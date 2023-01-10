(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: mnMsgCyclic.st
 * Author: subramaniam
 * Created: January 28, 2011
 * Changed: 2011-10-20 by A. Hunholz
 *
 	###AH20110525	Generell überarbeitet
						Initialisierung ins Ini_up, da nichts
						auf Parametern fußt
						
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************
 * History
 		###AH20110702 MNMSG_IDX_KGMSGSTAT eingeführt
		
		###AH20110908 MNMSG_IDX_KGMSGSTATTEST eingeführt
						 Fehler beim Austragen der Meldungen behoben
						 Testmeldungen können erzeugt werden. Siehe Pkg_mnMsg_Test.txt

		###AH20111020 IFmnMsg.In.wCmd
		###AH20111219 Beginn: Version 1.07.0
						- Meldungen reduziert. SPS-Logbuch eingeführt
						- Konstanten nach Regel benannt
						- Schnittstelle zu hlDFII angepasst
						- Ringbuffer nach KGstandard ausgelagert
*)

PROGRAM _CYCLIC

	// Aktuellen Zeitstempel zyklisch bestimmen
	_dtTimeStamp(enable := TRUE);

	IF _Plausibility.xOK THEN

		// Konfiguration laufend überwachen

		_doInfoCfg();

		IF _doInfoCfg.status <> ERR_OK THEN
		
			// Konfigurationsdatenmodul wurde gelöscht
			_Plausibility.xOK := FALSE;
			_xLogNoCfg := TRUE;
		
		ELSE

			// configuration data pointer has moved or different configuration data length (?)
			IF _Plausibility.dCfgMem <> _doInfoCfg.pDatObjMem OR _Plausibility.dCfgLen <> _doInfoCfg.len THEN
				
				// Konfigurationsdatenmodul hat sich geändert .. Es ist ein Warmstart notwendig
				_Plausibility.xOK := FALSE;
				
				_xLogCfgMoved := TRUE;
		
			END_IF

		END_IF

	END_IF

	// Logging
	
	CASE _wLogStep OF
		
		0: 
			IF _xLogNoCfg THEN
				
				_kgArLogWrite.text := 'Messageconfiguration removed: {##AttrVar1}';
				_kgArLogWrite.var1 := _doInfoCfg.status;
				_kgArLogWrite.var2 := 0;
				_xLogNoCfg := FALSE;
				_wLogStep := 1;
				
			ELSIF _xLogCfgMoved THEN
				
				_kgArLogWrite.text := 'Messageconfiguration moved! Request warmstart!';
				_kgArLogWrite.var1 := 0;
				_kgArLogWrite.var2 := 0;
				_xLogCfgMoved := FALSE;
				_wLogStep := 1;
				
			ELSIF _xLogCreateStat THEN
				
				_kgArLogWrite.text := 'Create statistic failed!';
				_kgArLogWrite.var1 := 0;
				_kgArLogWrite.var2 := 0;
				_xLogCreateStat := FALSE;
				_wLogStep := 1;
				
			ELSIF _xLogDeleteStat THEN
				
				_kgArLogWrite.text := 'Delete statistic failed!';
				_kgArLogWrite.var1 := 0;
				_kgArLogWrite.var2 := 0;
				_xLogDeleteStat := FALSE;
				_wLogStep := 1;
		
			ELSIF _xLogInfoStat THEN

				_kgArLogWrite.text := 'Info statistic failed!';
				_kgArLogWrite.var1 := 0;
				_kgArLogWrite.var2 := 0;
				_xLogInfoStat := FALSE;
				_wLogStep := 1;
		
			ELSIF _xLogWriteStat THEN
				
				_kgArLogWrite.text := 'Write statistic failed!';
				_kgArLogWrite.var1 := 0;
				_kgArLogWrite.var2 := 0;
				_xLogWriteStat := FALSE;
				_wLogStep := 1;
				
			END_IF
			
		1:
			_kgArLogWrite();
			IF _kgArLogWrite.status <> ERR_FUB_BUSY THEN
				_wLogStep := 0;
			END_IF
			
	END_CASE
	
	//==============================
	// Pointer zyklisch neu zuweisen
	//==============================

	_InsertRB.lLenEntry := SIZEOF(_TempHistline);
	_InsertRB.pEntry := ADR(_TempHistline);
		
	_ReadRB.lLenEntry := SIZEOF(_TempHistline);
	_ReadRB.pEntry := ADR(_TempHistline);
		
	_LocRB.lLenEntry := SIZEOF(_TempHistline);
	_LocRB.pEntry := ADR(_TempHistline);

	_InsertMsgLine.AdrIntFaultList := ADR(mnMsgStatAd.Msg.MsgListFaultInt);	// Meldungsliste interne Fehler
	_InsertMsgLine.AdrExtFaultList := ADR(mnMsgStatAd.Msg.MsgListFaultExt);	// Meldungsliste externe Fehler
	_InsertMsgLine.AdrWarnList := ADR(mnMsgStatAd.Msg.MsgListWarning);	// Meldungsliste Warnungen
	_InsertMsgLine.AdrInfoList := ADR(mnMsgStatAd.Msg.MsgListInformation);	// Meldungsliste Informationen
	_InsertMsgLine.AdrMaintList := ADR(mnMsgStatAd.Msg.MsgListMaintenance);	// Meldungsliste Wartungsmeldungen
	_InsertMsgLine.AdrCntIntFault := ADR(mnMsgStatAd.Msg.MsgCntFaultInt);	// Anzahl der Meldungen in der internen Fehlerliste
	_InsertMsgLine.AdrCntExtFault := ADR(mnMsgStatAd.Msg.MsgCntFaultExt);	// Anzahl der Meldungen in der externen Fehlerliste
	_InsertMsgLine.AdrCntWarn := ADR(mnMsgStatAd.Msg.MsgCntWarning);	// Anzahl der Meldungen in der Warnungsliste
	_InsertMsgLine.AdrCntInfo := ADR(mnMsgStatAd.Msg.MsgCntInformation);	// Anzahl der Meldungen in der Informationsliste
	_InsertMsgLine.AdrCntMaint := ADR(mnMsgStatAd.Msg.MsgCntMaintenance);	// Anzahl der Meldungen in der Wartungsliste

	//==============================
	// Meldungen des MnMsg
	//==============================

	_mnMsgStat.wFunction_ID := 2;
	
	IF _xStatFault THEN
		_mnMsgStat.wMsgClass := MNMSG_CLASS_INFO;
		_mnMsgStat.wMsgNumber := MNMSG_MSG_NO_STATISTIC;
	ELSIF NOT _xRBReady THEN
		_mnMsgStat.wMsgClass := MNMSG_CLASS_INFO;
		_mnMsgStat.wMsgNumber := MNMSG_MSG_NO_HISTORY;
	ELSE
		_mnMsgStat.wMsgClass := MNMSG_CLASS_INFO;
		_mnMsgStat.wMsgNumber := MNMSG_MSG_NO_MESSAGE;
	END_IF
		
	// Meldungen des mnMsg wie andere Meldungen auch behandeln

	IF NOT IFmnTest.Out.xNoMessages THEN
		kgMsgStatus[MNMSG_IDX_KGMSGSTAT] := _mnMsgStat;
	END_IF

	// Ist mnPar fertig
	
	_xMnParOk := IFmnParam.Out.xParamOK;

	//Plausibilitaetspruefung erfolgreich
	//___________________________

	IFmnMsg.Out.xMnMsgReady := _Plausibility.xOK;
	mnMsgStatAd.xReady := _Plausibility.xOK;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	//****************************************Zyklischer Teil der Meldungsmanager**************************************************************************************************************************************************
	//
	//_____________________________________________________________________________________________________________________________________________________________________

	//****************************************Einlesen  der Meldungen aus dem Feld*****************************************************************
	//
	// Es werden alle Meldungen aus dem "kgMsgStatus" ARRAY gelesen und mit der ImageMessage Abbild verglichen. Wenn 
	// die Meldung in der Liste existiert, wird der Status verglichen. Wenn eine Quittierung vorhanden ist, wird der Status geaendert
	// (von eins = gekommen auf zwei = quittiert) und anschliessend als quittiert in den Ringbuffer eingetragen. Existiert die 
	// Meldung ohne Statusaenderung wird die Meldung als anstehende Meldung angenommen und somit für den weiteren Prozess
	// unrelevant. Wenn die Meldung in der ImageMessage Liste nicht existiert, wird die Meldung in der Liste als gekommen 
	// aufgenommen und in Ringbuffer geschrieben.
	// Desweiteren werden zyklisch die Liste der letzten Meldungen aktualisiert, um die gegangenen Fehler zu lokalisieren.
	//_______________________________________________________________________________________________________

	// So, if _plausibility.xOK = TRUE ...
	IF _Plausibility.xOK THEN

		//==============================
		// Befehle aus IFmnMsg auswerten
		//==============================
		
		_xCmdAckAll := FALSE;
		_xCmdAck := FALSE;
		_xCmdAckAllMaint := FALSE;

		// _enCmdState of CmdState_enum
		CASE _enIFCmdState OF

			// Grundzustand
			enCS_Idle:


				CASE IFmnMsg.In.wCmd OF
					
					
					KG_CMD_NOCOMMAND:
					
						IFmnMsg.Out.wCmdRet := KG_CMD_NOCOMMAND;
					
					// Kommando zum Quittieren ausgelöst
					MNMSG_CMD_ACK:
						
						IFmnMsg.Out.wCmdRet := MNMSG_CMD_ACK; // Function block still working.
						_xCmdAck := TRUE;
						_enIFCmdState := enCS_WaitForZero;

					// Alle anstehenden Stoerungen quittieren
					MNMSG_CMD_ACK_FAULT:
						
						IFmnMsg.Out.wCmdRet := MNMSG_CMD_ACK_FAULT;
						_xCmdAckAll := TRUE;
						_enIFCmdState := enCS_WaitForZero;

					// Alle anstehenden Wartungen quittieren
					MNMSG_CMD_ACK_MAINT:

						IFmnMsg.Out.wCmdRet := MNMSG_CMD_ACK_MAINT;
						_xCmdAckAllMaint := TRUE;
						_enIFCmdState := enCS_WaitForZero;

					// Alle Statistiken werden geloescht
					MNMSG_CMD_DEL_STAT:
							
						IF _xStatReady THEN

							IFmnMsg.Out.wCmdRet := KG_CMDSTAT_BUSY;

							IF _EventStatisticDelStep = Del_Wait THEN
								_xStatReady := FALSE;	
								_EventStatisticDelStep := Del_Delete;
								_enIFCmdState := enCS_CmdDelStat;
							END_IF
								
						ELSE

							_enIFCmdState := enCS_WaitForZero;
							IFmnMsg.Out.wCmdRet := MNMSG_CMDSTAT_STATNOTREADY;
								
						END_IF

					// Historie wird gelöscht
					MNMSG_CMD_DEL_HIST:
						
						IF _xRBReady THEN

							IFmnMsg.Out.wCmdRet := KG_CMDSTAT_BUSY;

							IF _EventHistDelStep = Del_WaitH THEN
								_EventHistDelStep := Del_DeleteH;
								_enIFCmdState := enCS_CmdDelHist;
							END_IF
							
						ELSE

							_enIFCmdState := enCS_WaitForZero;
							IFmnMsg.Out.wCmdRet := MNMSG_CMDSTAT_HISTNOTREADY;
							
						END_IF;
					
					// Hupe aus
					MNMSG_CMD_HORN_OFF:
							
						IFmnMsg.Out.wCmdRet := MNMSG_CMD_HORN_OFF;
						_xIFcmdHornOff := TRUE;
						_enIFCmdState := enCS_WaitForZero;

					// Ungültiges Kommando
					ELSE

						IFmnMsg.Out.wCmdRet := KG_CMDSTAT_NOTVALID;
						_enIFCmdState := enCS_WaitForZero;
						
					END_CASE

			// Warten bis Schrittkette zum Löschen der Statistik beendet wurde
			enCS_CmdDelStat:

				IFmnMsg.Out.wCmdRet := KG_CMDSTAT_BUSY;

				IF _EventStatisticDelStep = Del_Wait OR _EventStatisticDelStep = Del_Error THEN

					IF _EventStatisticDelStep = Del_Wait THEN
						
						// Erfolgreich beendet
						IFmnMsg.Out.wCmdRet := MNMSG_CMD_DEL_STAT;
						
					ELSE
						
						// Mit Fehler beendet
						IFmnMsg.Out.wCmdRet := MNMSG_CMDSTAT_DELSTATFAILED;
						
					END_IF
					
					_enIFCmdState := enCS_WaitForZero;
				
				END_IF

			// Warten bis Schrittkette zum Löschen der Historie beendet wurde
			enCS_CmdDelHist:

				IFmnMsg.Out.wCmdRet := KG_CMDSTAT_BUSY;

				IF _EventHistDelStep = Del_WaitH OR _EventHistDelStep = Del_ErrorH THEN
				
					IF _EventHistDelStep = Del_WaitH THEN

						// Erfolgreich beendet
						IFmnMsg.Out.wCmdRet := MNMSG_CMD_DEL_HIST;

					ELSE

						// Mit Fehler beendet
						IFmnMsg.Out.wCmdRet := MNMSG_CMDSTAT_DELHISTFAILED;

					END_IF
					
					_enIFCmdState := enCS_WaitForZero;
				
				END_IF;

			enCS_WaitForZero:
				
				IF IFmnMsg.In.wCmd = KG_CMD_NOCOMMAND THEN
				
					_enIFCmdState := enCS_Idle;
					IFmnMsg.Out.wCmdRet := KG_CMD_NOCOMMAND;
					
				END_IF
			
		END_CASE

		//===============================
		// Befehle aus mnMsgCmd auswerten
		//===============================
		
		_xExtCmdAckAll := FALSE;
		_xExtCmdAck := FALSE;
		_xExtCmdAckAllMaint := FALSE;

		CASE _enExtCmdState OF

			// Grundzustand
			enCS_Idle:

				CASE mnMsgCmd.Request.Command.wCommand OF
					
					// Kein Kommando
					KG_CMD_NOCOMMAND:
					
						mnMsgCmd.Response.wCmdStatus := KG_CMD_NOCOMMAND;
					
					// Kommando zum Quittieren ausgelöst
					MNMSG_CMD_ACK:
						
						mnMsgCmd.Response.wCmdStatus := MNMSG_CMD_ACK;
						_xExtCmdAck := TRUE;
						_enExtCmdState := enCS_WaitForZero;

						_iCmdData0 ACCESS ADR (mnMsgCmd.Request.Command.lData0);
						_iCmdData1 ACCESS ADR (mnMsgCmd.Request.Command.lData1);
					
						_wExtCmdFunctionID 	:= _iCmdData0[MSW];
						_wExtCmdMsgNo		:= _iCmdData0[LSW];
						_wExtCmdInstance	:= _iCmdData1[MSW];
						_wExtCmdAckLevel	:= _iCmdData1[LSW];
					
					// Alle anstehenden Stoerungen quittieren
					MNMSG_CMD_ACK_FAULT:
						
						mnMsgCmd.Response.wCmdStatus := MNMSG_CMD_ACK_FAULT;
						_xExtCmdAckAll := TRUE;
						_enExtCmdState := enCS_WaitForZero;

						_wExtCmdAckLevel	:= UDINT_TO_UINT(mnMsgCmd.Request.Command.lData0);

					// Alle anstehenden Wartungen quittieren
					MNMSG_CMD_ACK_MAINT:

						mnMsgCmd.Response.wCmdStatus := MNMSG_CMD_ACK_MAINT;
						_xExtCmdAckAllMaint := TRUE;
						_enExtCmdState := enCS_WaitForZero;

						_wExtCmdAckLevel	:= UDINT_TO_UINT(mnMsgCmd.Request.Command.lData0);
					
					// Hupe aus
					MNMSG_CMD_HORN_OFF:
							
						mnMsgCmd.Response.wCmdStatus := MNMSG_CMD_HORN_OFF;
						_xExtcmdHornOff := TRUE;
						_enExtCmdState := enCS_WaitForZero;

					// Ungültiges Kommando
					ELSE
								
						mnMsgCmd.Response.wCmdStatus := KG_CMDSTAT_NOTVALID;
						_enExtCmdState := enCS_WaitForZero;
						
				END_CASE

			enCS_WaitForZero:
				
				IF mnMsgCmd.Request.Command.wCommand = KG_CMD_NOCOMMAND THEN
				
					_enExtCmdState := enCS_Idle;
					mnMsgCmd.Response.wCmdStatus := KG_CMD_NOCOMMAND;
					
				END_IF
			
		END_CASE

		IF (IFmnTxt.Out.wSelectedLanguage <> 0) AND (IFmnTxt.Out.wSelectLanguageStatus = ERR_OK) THEN
			_xMnTxtReady := TRUE;
			_wLCID := IFmnTxt.Out.wSelectedLanguage;
		ELSE
			_xMnTxtReady := FALSE;
		END_IF;


		// Hilfsliste initialisieren
		memset(ADR(_MsgImageState),0,SIZEOF(_MsgImageState));
		
		// Zählen der Fehler, die nicht quittierbar sind
		_wCntFaultNotAck := 0;  // Für die Anzeige, ob alle Störungen quittierbar sind
		
		// NEUE MELDUNGEN ODER BESTEHENDE MELDUNGEN
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		FOR _wSrcIdx := 0 TO MNMSG_MAX_IDX_KGMSGSTATUS DO

			// Meldungen prüfen
			//====================================================
			
			IF kgMsgStatus[_wSrcIdx].wMsgNumber > 0 THEN

				// Es wurde eine Meldung gesetzt (wMsgNumber > 0)
				
				// Meldung in der Konfiguration suchen
				_BinSearchCfg.wFunctionID 	:= kgMsgStatus[_wSrcIdx].wFunction_ID;
				_BinSearchCfg.wMsgNo 		:= kgMsgStatus[_wSrcIdx].wMsgNumber;
				_BinSearchCfg.wInstance 	:= kgMsgStatus[_wSrcIdx].wInstance;
				_BinSearchCfg();
				
				IF _BinSearchCfg.wStatus = ERR_OK THEN
						
					// Meldung gefunden
					_wMsgIdx := _BinSearchCfg.wMsgIdx;

					// Meldung im Abbild aktiv setzen
					_MsgImageState[_wMsgIdx].xOn := TRUE;

					// Meldungsklasse hat sich geändert
					_xMsgClassChanged := _MsgImage[_wMsgIdx].wMsgClass <> kgMsgStatus[_wSrcIdx].wMsgClass;

					// Zählen, wenn es eine nicht quittierbare Störung ist
					IF kgMsgStatus[_wSrcIdx].wMsgClass < 10 AND kgMsgStatus[_wSrcIdx].wMsgAckLevel = MNMSG_CLASS_NO_ACK THEN 
						
						_wCntFaultNotAck := _wCntFaultNotAck + 1;
						
					END_IF
	
					IF _MsgImageTime[_wMsgIdx].dtTimeStamp <> DT#1970-01-01-00:00 THEN

						// Gültiger Zeitstempel im Image heißt, dass die Meldung bereits aktiv war
	
						//###PRÜFEN WAS DAS SOLL###
						_MsgImageState[_wMsgIdx].xOn := _MsgImage[_wMsgIdx].wMsgClass = kgMsgStatus[_wSrcIdx].wMsgClass;

						_xAckLevelChanged := _MsgImage[_wMsgIdx].wMsgAckLevel <> kgMsgStatus[_wSrcIdx].wMsgAckLevel;

						_xAckLevelRosen := FALSE;
						_xAckLevelFallen := FALSE;

						IF (_MsgImage[_wMsgIdx].wMsgAckLevel <> MNMSG_CLASS_NO_ACK) AND (kgMsgStatus[_wSrcIdx].wMsgAckLevel = MNMSG_CLASS_NO_ACK) AND
							(kgMsgStatus[_wSrcIdx].wMsgClass = MNMSG_CLASS_INTFAULT 
							OR kgMsgStatus[_wSrcIdx].wMsgClass = MNMSG_CLASS_EXTFAULT 
							OR kgMsgStatus[_wSrcIdx].wMsgClass = MNMSG_CLASS_MAINTENANCE) THEN
							
							// Ursache steht wieder an, Meldung ist nicht quittierbar
							_xAckLevelRosen := TRUE;
							
						END_IF;
						
						IF (_MsgImage[_wMsgIdx].wMsgAckLevel = MNMSG_CLASS_NO_ACK) AND (kgMsgStatus[_wSrcIdx].wMsgAckLevel <> MNMSG_CLASS_NO_ACK) AND
							(kgMsgStatus[_wSrcIdx].wMsgClass = MNMSG_CLASS_INTFAULT 
							OR kgMsgStatus[_wSrcIdx].wMsgClass = MNMSG_CLASS_EXTFAULT 
							OR kgMsgStatus[_wSrcIdx].wMsgClass = MNMSG_CLASS_MAINTENANCE) THEN
							
							// Ursache ist verschwunden, Meldung ist quittierbar
							_xAckLevelFallen := TRUE;
							
						END_IF;
						
						_MsgImage[_wMsgIdx].wMsgAckLevel := kgMsgStatus[_wSrcIdx].wMsgAckLevel;
								
						//Steht ein Acknowledg aus der IFmnMsg oder aus der mnMsgCmd vor, aendert sich der Status
						//_______________________________________________________________________________
						// Interne Schnittstelle IFmnMsg, alle Meldungen quittieren
						_xAck :=  _xCmdAckAll;
						
						// Kommandoschnittstelle mnMsgCmd, alle Meldungen quittieren
						_xAck := _xAck OR _xExtCmdAckAll AND _wExtCmdAckLevel >= kgMsgStatus[_wSrcIdx].wMsgAckLevel;
						
						// Interne Schnittstelle IFmnMsg, einzelne Meldung quittieren
						_xAck := _xAck OR 
							(_xCmdAck 
							AND IFmnMsg.In.wFunction_ID = kgMsgStatus[_wSrcIdx].wFunction_ID 
							AND	IFmnMsg.In.wMsgNumber = kgMsgStatus[_wSrcIdx].wMsgNumber 
							AND IFmnMsg.In.wInstance = kgMsgStatus[_wSrcIdx].wInstance);

						// Kommandoschnittstelle mnMsgCmd, einzelne Meldung quittieren
						_xAck := _xAck OR _xExtCmdAck 
							AND _wExtCmdFunctionID = kgMsgStatus[_wSrcIdx].wFunction_ID	
							AND _wExtCmdMsgNo = kgMsgStatus[_wSrcIdx].wMsgNumber 
							AND _wExtCmdInstance = kgMsgStatus[_wSrcIdx].wInstance 
							AND _wExtCmdAckLevel >= kgMsgStatus[_wSrcIdx].wMsgAckLevel;
							
						// Nur für Störungen, die quittierbar sind
						_xAck := _xAck AND (kgMsgStatus[_wSrcIdx].wMsgClass < 10) AND (kgMsgStatus[_wSrcIdx].wMsgAckLevel <> MNMSG_CLASS_NO_ACK);
	
						IF _xAck THEN
											
							kgMsgStatus[_wSrcIdx].xAckFault := TRUE;	// Quittierung Störung
							kgMsgStatus[_wSrcIdx].xAckAva := TRUE;		// Quittierung available

							_wActEvent := MNMSG_EVENT_ACK;
							_lActTime := 0;
							_actInsertRB;
	
						END_IF;	//IF _xAck
							
						IF _xAck OR _xAckLevelChanged THEN
	
							// Liste bearbeiten
							// _InsertMsgLine of msgInsertMsgLine FB 'Ein und Ausfuegen von Meldungen' local variable of program mnMsg 'Meldungslisten'
							// UDINT strcpy of library asstring 'copies one character string into another'
							// strcpy(pDest 'pointer to the destination character string', pScr 'pointer to the source character string')
							_bActMsgLClass := UINT_TO_USINT(_MsgImage[_wMsgIdx].wMsgClass);
							
							_actInsertMsgL;

							IF _InsertMsgLine.Changed THEN
							
								CASE _MsgImage[_wMsgIdx].wMsgClass  OF
							
									MNMSG_CLASS_INTFAULT: _MsgImageHelp.xFaultIntChanged := TRUE;
								
									MNMSG_CLASS_EXTFAULT: _MsgImageHelp.xFaultExtChanged := TRUE;
																								
								END_CASE						
							
							END_IF
							
						END_IF	// END_IF _xAck OR _xAckLevelChanged
	
						IF _xAckLevelRosen THEN
							_wActEvent := MNMSG_EVENT_COME;
							_lActTime := 0;
							_actInsertRB;
						END_IF;
						
						IF _xAckLevelFallen THEN
							_wActEvent := MNMSG_EVENT_GONE;
							_lActTime := 0;
							_actInsertRB;
						END_IF;
							
					ELSE 
									
						// Meldung ist neu, Daten übernehmen, Eintrag in Ringbuffer als gekommen
						_MsgImageTime[_wMsgIdx].dtTimeStamp := _dtTimeStamp.DT1;
									
						_MsgImage[_wMsgIdx].wMsgClass := kgMsgStatus[_wSrcIdx].wMsgClass;
						_MsgImage[_wMsgIdx].wMsgAckLevel := kgMsgStatus[_wSrcIdx].wMsgAckLevel;
						_MsgImage[_wMsgIdx].diMsgAttr1 := kgMsgStatus[_wSrcIdx].diMsgAttr1;
						_MsgImage[_wMsgIdx].diMsgAttr2 := kgMsgStatus[_wSrcIdx].diMsgAttr2;
						strcpy(ADR(_MsgImage[_wMsgIdx].sMsgAttrTxt),ADR(kgMsgStatus[_wSrcIdx].sMsgAttrTxt));
			
						_wActEvent := MNMSG_EVENT_COME;
						_lActTime := 0;
						_actInsertRB;
			
						// Liste bearbeiten
						_bActMsgLClass := UINT_TO_USINT(_MsgImage[_wMsgIdx].wMsgClass);
						_actInsertMsgL;

						IF _InsertMsgLine.Changed THEN
										
							CASE _MsgImage[_wMsgIdx].wMsgClass  OF
										
								MNMSG_CLASS_INTFAULT: _MsgImageHelp.xFaultIntChanged := TRUE;
											
								MNMSG_CLASS_EXTFAULT: _MsgImageHelp.xFaultExtChanged := TRUE;
											
								MNMSG_CLASS_WARNING: _MsgImageHelp.xWarningChanged := TRUE;
											
								MNMSG_CLASS_INFO: _MsgImageHelp.xInfoChanged := TRUE;
																				
							END_CASE; // _MsgImage[_wMsgIdx].wMsgClass						
				
						END_IF; // _InsertMsgLine.Changed
						
					END_IF
					
				ELSE
					// Keine Meldung gefunden
				END_IF; // _BinSearchCfg.wStatus = ERR_OK

			ELSE	
				// Es steht keine Meldung an, nichts tun
			END_IF; // kgMsgStatus[_wSrcIdx].wMsgNumber > 0

			
			
			// Wartung Prüfen
			//========================================================
			
			IF kgMsgStatus[_wSrcIdx].wMaintNumber > 0 THEN
				
				// Es steht eine Wartung an
				_BinSearchCfg.wFunctionID 	:= kgMsgStatus[_wSrcIdx].wFunction_ID;
				_BinSearchCfg.wInstance 	:= kgMsgStatus[_wSrcIdx].wInstance;
				_BinSearchCfg.wMsgNo := kgMsgStatus[_wSrcIdx].wMaintNumber;
				_BinSearchCfg();
				
				IF _BinSearchCfg.wStatus = ERR_OK THEN
					
					// Wartung gefunden
					_wMsgIdx := _BinSearchCfg.wMsgIdx;
					
					_MsgImageState[_wMsgIdx].xOn := TRUE;

					_xMsgClassChanged := _MsgImage[_wMsgIdx].wMsgClass <> kgMsgStatus[_wSrcIdx].wMsgClass;
					IF _xMsgClassChanged THEN
						//_MsgImageTime[_wMsgIdx].dtTimeStamp := DT#1970-01-01-00:00;
					END_IF;

					IF _MsgImageTime[_wMsgIdx].dtTimeStamp <> DT#1970-01-01-00:00 THEN
						
						// Wartung ist schon aktiv

						// ###PRÜFEN WAS DAS SOLL###
						_MsgImageState[_wMsgIdx].xOn := _MsgImage[_wMsgIdx].wMsgClass = MNMSG_CLASS_MAINTENANCE;

						_xAckLevelChanged := kgMsgStatus[_wSrcIdx].wMaintAckLevel <> _MsgImage[_wMsgIdx].wMsgAckLevel;
						
						_xAckLevelRosen := FALSE;
						_xAckLevelFallen := FALSE;

						// _xAckLevelChanged := _MsgImage[_wMsgIdx].wMsgAckLevel <> kgMsgStatus[_wSrcIdx].wMsgAckLevel;
						IF (_MsgImage[_wMsgIdx].wMsgAckLevel <> MNMSG_CLASS_NO_ACK) AND (kgMsgStatus[_wSrcIdx].wMaintAckLevel = MNMSG_CLASS_NO_ACK) THEN
							
							_xAckLevelRosen := TRUE;
							
						END_IF;
						
						IF (_MsgImage[_wMsgIdx].wMsgAckLevel = MNMSG_CLASS_NO_ACK) AND (kgMsgStatus[_wSrcIdx].wMaintAckLevel <> MNMSG_CLASS_NO_ACK) THEN
							
							_xAckLevelFallen := TRUE;
							
						END_IF;
						
						_MsgImage[_wMsgIdx].wMsgAckLevel := kgMsgStatus[_wSrcIdx].wMaintAckLevel;
							

						//Steht ein Acknowledg aus der IFmnMsg oder aus der mnMsgCmd vor, aendert sich der Status
 						//_______________________________________________________________________________
						// Interne Schnittstelle IFmnMsg, alle Meldungen quittieren
						_xAck :=  _xCmdAckAllMaint;
					
						// Kommandoschnittstelle mnMsgCmd, alle Meldungen quittieren
						_xAck := _xAck OR _xExtCmdAckAllMaint AND _wExtCmdAckLevel >= kgMsgStatus[_wSrcIdx].wMaintAckLevel ;
					
						// Interne Schnittstelle IFmnMsg, einzelne Meldung quittieren
						_xAck := _xAck OR 
							(_xCmdAck 
						AND IFmnMsg.In.wFunction_ID = kgMsgStatus[_wSrcIdx].wFunction_ID
						AND IFmnMsg.In.wMsgNumber = kgMsgStatus[_wSrcIdx].wMaintNumber 
						AND IFmnMsg.In.wInstance = kgMsgStatus[_wSrcIdx].wInstance);
					
						// Kommandoschnittstelle mnMsgCmd, einzelne Meldung quittieren
						_xAck := _xAck OR _xExtCmdAck 
						AND _wExtCmdFunctionID = kgMsgStatus[_wSrcIdx].wFunction_ID	
						AND _wExtCmdMsgNo = kgMsgStatus[_wSrcIdx].wMaintNumber 
						AND _wExtCmdInstance = kgMsgStatus[_wSrcIdx].wInstance 
						AND _wExtCmdAckLevel >= kgMsgStatus[_wSrcIdx].wMaintAckLevel;

						IF _xAck THEN
											
							kgMsgStatus[_wSrcIdx].xAckMaint := TRUE;
							kgMsgStatus[_wSrcIdx].xAckAva := TRUE;
						
							_wActEvent := MNMSG_EVENT_ACK;
							_lActTime := 0;
							_actInsertRB;
							
						END_IF; // IF _xAck
						
			
						IF _xAck OR _xAckLevelChanged THEN
						
							// Liste bearbeiten
							_bActMsgLClass := UINT_TO_USINT(MNMSG_CLASS_MAINTENANCE);
							_actInsertMsgL;
	
							IF _InsertMsgLine.Changed THEN
								_MsgImageHelp.xMaintChanged := TRUE;
							END_IF
	
						END_IF

						IF _xAckLevelRosen THEN
							_wActEvent := MNMSG_EVENT_COME;
							_lActTime := 0;
							_actInsertRB;
						END_IF;
				
						IF _xAckLevelFallen THEN
							_wActEvent := MNMSG_EVENT_GONE;
							_lActTime := 0;
							_actInsertRB;
						END_IF;
						
					ELSE // Meldung ist neu
							
						// Wartung ist neu, Daten übernehmen, Eintrag in Ringbuffer als gekommen
						_MsgImageTime[_wMsgIdx].dtTimeStamp := _dtTimeStamp.DT1;
								
						_MsgImage[_wMsgIdx].wMsgClass := MNMSG_CLASS_MAINTENANCE;
						_MsgImage[_wMsgIdx].wMsgAckLevel := kgMsgStatus[_wSrcIdx].wMaintAckLevel;
						_MsgImage[_wMsgIdx].diMsgAttr1 := kgMsgStatus[_wSrcIdx].diMaintAttr1;
						_MsgImage[_wMsgIdx].diMsgAttr2 := kgMsgStatus[_wSrcIdx].diMaintAttr2;
						strcpy(ADR(_MsgImage[_wMsgIdx].sMsgAttrTxt),ADR(kgMsgStatus[_wSrcIdx].sMaintAttrTxt));
									
						_wActEvent := MNMSG_EVENT_COME;
						_lActTime := 0;
						_actInsertRB;
				
						// Liste bearbeiten
						_bActMsgLClass := UINT_TO_USINT(MNMSG_CLASS_MAINTENANCE);
						_actInsertMsgL;

						IF _InsertMsgLine.Changed THEN
							_MsgImageHelp.xMaintChanged := TRUE;
						END_IF; // _InsertMsgLine.Changed

					END_IF;

				ELSE
					// Keine Meldung gefunden
				END_IF; // _BinSearchCfg.wStatus = ERR_OK

			ELSE
				
				// Meldung nicht aktiv
				
			END_IF; // kgMsgStatus[_wSrcIdx].wMaintNumber > 0
	
			IF kgMsgStatus[_wSrcIdx].xAckRead THEN
				kgMsgStatus[_wSrcIdx].xAckAva := FALSE;
				kgMsgStatus[_wSrcIdx].xAckFault := FALSE;
				kgMsgStatus[_wSrcIdx].xAckMaint := FALSE;
				kgMsgStatus[_wSrcIdx].xAckRead := FALSE;
			END_IF; // kgMsgStatus[_wSrcIdx].xAckRead
			
		END_FOR; // Durchsuchen aller möglichen, anstehenden Meldungen


		// GEGANGENE MELDUNGEN
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		FOR _wMsgIdx := 1 TO MNMSG_MAX_CFGMESSAGES DO
			
			IF (_MsgImageTime[_wMsgIdx].dtTimeStamp <> DT#1970-01-01-00:00 AND NOT _MsgImageState[_wMsgIdx].xOn) THEN

				// Meldung ist gegangen
				
				IF _xStatReady THEN

					IF (_dtTimeStamp.DT1 >= _MsgImageTime[_wMsgIdx].dtTimeStamp) THEN
						_lTime := DiffDT(_dtTimeStamp.DT1,_MsgImageTime[_wMsgIdx].dtTimeStamp);
					ELSE
						_lTime := 0;
					END_IF;

					_StatLine.lTime := _MsgStatList.List[_wMsgIdx].lTime + _lTime;
					_StatLine.lCnt := _MsgStatList.List[_wMsgIdx].lCnt + 1;
					_StatLine.wFunction_ID := _MsgCfgList[_wMsgIdx].wFunction_ID;
					_StatLine.wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
					_StatLine.wInstance := UINT_TO_USINT(_MsgCfgList[_wMsgIdx].wInstance);
					_StatLine.wMsgClass := _MsgImage[_wMsgIdx].wMsgClass;

					IF MNMSG_RUN_VC THEN
					
						//###DK2011Nov21
						// Time
						_lValueTime := _MsgStatList.List[_wMsgIdx].lTime + _lTime;
						IF _lValueTime > 0 THEN
							_xMsgStatisticWriteTime := TRUE;
							IF _xMsgStatisticTimeFirstEntry THEN
								_lValueTimeMin := _lValueTime;
								_xMsgStatisticTimeFirstEntry := FALSE;
							END_IF;
							IF _wIFMsgStatisticCntTime > MNMSG_MAX_IDX_VCMSGSTATLIST THEN
								IF _lValueTime < _lValueTimeMin THEN
									_xMsgStatisticWriteTime := FALSE;
								END_IF;
							ELSE
								IF _lValueTime < _lValueTimeMin THEN
									_lValueTimeMin := _lValueTime;
								END_IF;
							END_IF;
							// Sortierung absteigend
							IF _xMsgStatisticWriteTime THEN
								_wPosMinTime := 0;
								IF _xFirstElementToInsertTime THEN
									_wPosMaxTime := 0;
									_wPosSearchTime := 0;
									_wPosEndTime := 0;
									_wIFMsgStatisticCntTime := 0;
									_xPosFoundTime := TRUE;
								ELSE
									_xPosFoundTime := FALSE;
									_wPosMaxTime := _wPosEndTime;
									_wPosSearchTime := (_wPosMaxTime + _wPosMinTime) / 2;
									IF _wPosEndTime = 0 THEN
										IF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) THEN
											_wPosSearchTime := 1;
										ELSE
											_wPosSearchTime := 0;
										END_IF;
										_xPosFoundTime := TRUE;
									END_IF;
								END_IF;
								WHILE NOT _xPosFoundTime DO
									IF ((_wPosSearchTime = 1) OR (_wPosSearchTime = 0)) AND NOT _xPosFoundTime THEN
										_wPosSearchTime := 0;
										IF (_msgStatisticTimeIdx[_wPosSearchTime].lValue < _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue < _lValueTime) THEN
											_wPosSearchTime := 0;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue < _lValueTime) THEN
											_wPosSearchTime := 1;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue = _lValueTime) THEN
											_wPosSearchTime := 1;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue > _lValueTime) THEN
											_wPosSearchTime := 2;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue = _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue < _lValueTime) THEN
											_wPosSearchTime := 0;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue = _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue = _lValueTime) THEN
											_wPosSearchTime := 0;
											_xPosFoundTime := TRUE;
										ELSE
											// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
											_lHElseTime1 := _lHElseTime1 + 1;
											_wMsgListCnt := 0;
											WHILE _msgStatisticTimeIdx[_wMsgListCnt].lValue > _lValueTime AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
												_wMsgListCnt := _wMsgListCnt + 1;
											END_WHILE;
											_wPosSearchTime := _wMsgListCnt;
											_xPosFoundTime := TRUE;
										END_IF;
									END_IF;
									IF ((_wPosSearchTime = (_wPosEndTime - 1)) OR (_wPosSearchTime = _wPosEndTime)) AND NOT _xPosFoundTime THEN
										_wPosSearchTime := _wPosEndTime;
										IF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime - 1].lValue > _lValueTime) THEN
											_wPosSearchTime := _wPosEndTime + 1;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue < _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime - 1].lValue > _lValueTime) THEN
											_wPosSearchTime := _wPosEndTime - 0;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue < _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime - 1].lValue = _lValueTime) THEN
											_wPosSearchTime := _wPosEndTime - 1;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue < _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime - 1].lValue < _lValueTime) THEN
											_wPosSearchTime := _wPosEndTime - 1;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue = _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime - 1].lValue > _lValueTime) THEN
											_wPosSearchTime := _wPosEndTime - 0;
											_xPosFoundTime := TRUE;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue = _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime - 1].lValue = _lValueTime) THEN
											_wPosSearchTime := _wPosEndTime - 1;
											_xPosFoundTime := TRUE;
										ELSE
											// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
											_lHElseTime2 := _lHElseTime2 + 1;
											_wMsgListCnt := 0;
											WHILE _msgStatisticTimeIdx[_wMsgListCnt].lValue > _lValueTime AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
												_wMsgListCnt := _wMsgListCnt + 1;
											END_WHILE;
											_wPosSearchTime := _wMsgListCnt;
											_xPosFoundTime := TRUE;
										END_IF;
									END_IF;
									IF NOT _xPosFoundTime THEN
										IF (_msgStatisticTimeIdx[_wPosSearchTime].lValue < _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue < _lValueTime) THEN
											_wPosMaxTime := _wPosSearchTime;
											_wPosSearchTime := (_wPosMinTime + _wPosMaxTime) / 2;
											IF (_wPosMaxTime - _wPosSearchTime) = 0 THEN
												_wMsgListCnt := 0;
												WHILE _msgStatisticTimeIdx[_wMsgListCnt].lValue > _lValueTime AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
													_wMsgListCnt := _wMsgListCnt + 1;
												END_WHILE;
												_wPosSearchTime := _wMsgListCnt;
												_xPosFoundTime := TRUE;
											END_IF;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue > _lValueTime) THEN
											_wPosMinTime := _wPosSearchTime;
											_wPosSearchTime := (_wPosMinTime + _wPosMaxTime) / 2;
											IF (_wPosSearchTime - _wPosMinTime) = 0 THEN
												_wMsgListCnt := 0;
												WHILE _msgStatisticTimeIdx[_wMsgListCnt].lValue > _lValueTime AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
													_wMsgListCnt := _wMsgListCnt + 1;
												END_WHILE;
												_wPosSearchTime := _wMsgListCnt;
												_xPosFoundTime := TRUE;
											END_IF;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue < _lValueTime) THEN
											_xPosFoundTime := TRUE;
											_wPosSearchTime := _wPosSearchTime + 1;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue > _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue = _lValueTime) THEN
											_xPosFoundTime := TRUE;
											_wPosSearchTime := _wPosSearchTime + 1;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue = _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue < _lValueTime) THEN
											_xPosFoundTime := TRUE;
											_wPosSearchTime := _wPosSearchTime;
										ELSIF (_msgStatisticTimeIdx[_wPosSearchTime].lValue = _lValueTime) AND (_msgStatisticTimeIdx[_wPosSearchTime + 1].lValue = _lValueTime) THEN
											_xPosFoundTime := TRUE;
											_wPosSearchTime := _wPosSearchTime;
										ELSE
											// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
											_lHElseTime3 := _lHElseTime3 + 1;
											_lHElseTime3EndPos := _wPosEndTime;
											_wHElseTime3PosSearch := _wPosSearchTime;
											_lHElseTime3lValuePosP0 := _msgStatisticTimeIdx[_wPosSearchTime].lValue;
											_lHElseTime3lValuePosP1 := _msgStatisticTimeIdx[_wPosSearchTime + 1].lValue;
											_lHElseTime3lValueTime := _lValueTime;
											_wMsgListCnt := 0;
											WHILE _msgStatisticTimeIdx[_wMsgListCnt].lValue > _lValueTime AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
												_wMsgListCnt := _wMsgListCnt + 1;
											END_WHILE;
											_wPosSearchTime := _wMsgListCnt;
											_xPosFoundTime := TRUE;
										END_IF;
									END_IF;
								END_WHILE;	// WHILE NOT _xPosFound DO
								IF _wPosSearchTime > MNMSG_MAX_IDX_VCMSGSTATLIST THEN
									_wPosSearchTime := MNMSG_MAX_IDX_VCMSGSTATLIST;
								END_IF;
								IF _wPosEndTime < MNMSG_MAX_IDX_VCMSGSTATLIST THEN
									_diMemMoveTimeIdx := _wPosEndTime - _wPosSearchTime + 1;
								ELSE
									_diMemMoveTimeIdx := _wPosEndTime - _wPosSearchTime;
								END_IF;
								IF (_diMemMoveTimeIdx > 0) AND ((_wPosSearchTime + _diMemMoveTimeIdx) <= MNMSG_MAX_IDX_VCMSGSTATLIST) THEN
									memmove(ADR(_msgStatisticTimeIdx[_wPosSearchTime + 1]), ADR(_msgStatisticTimeIdx[_wPosSearchTime]), _diMemMoveTimeIdx * SIZEOF(_msgStatisticTimeIdx[0]));
								END_IF;
								_msgStatisticTimeIdx[_wPosSearchTime].wFunction_ID := _MsgCfgList[_wMsgIdx].wFunction_ID;
								_msgStatisticTimeIdx[_wPosSearchTime].wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
								_msgStatisticTimeIdx[_wPosSearchTime].wInstance := _MsgCfgList[_wMsgIdx].wInstance;
								_msgStatisticTimeIdx[_wPosSearchTime].lValue := _lValueTime;
								IF NOT _xFirstElementToInsertTime THEN
									IF _wPosEndTime < MNMSG_MAX_IDX_VCMSGSTATLIST THEN
										_wPosEndTime := _wPosEndTime + 1;
									ELSE
										_wPosEndTime := MNMSG_MAX_IDX_VCMSGSTATLIST;
									END_IF;
								ELSE
									_xFirstElementToInsertTime := FALSE;
								END_IF;
								_lValueTimeMin := _msgStatisticTimeIdx[_wPosEndTime].lValue;
								_wIFMsgStatisticCntTime := _wIFMsgStatisticCntTime + 1;
								IF _wIFMsgStatisticCntTime > _wPosEndTime THEN
									_wIFMsgStatisticCntTime := _wPosEndTime + 1;
								END_IF;
								IF _wIFMsgStatisticCntTime > MNMSG_MAX_IDX_VCMSGSTATLIST THEN
									_wIFMsgStatisticCntTime := MNMSG_MAX_IDX_VCMSGSTATLIST + 1;
								END_IF;
							END_IF;	// _xMsgStatisticWriteTime
						END_IF;	// _lValue > 0
						//###DK2011Nov21
	
						//###DK2011Nov22
						// Num
						_lValueNum := _MsgStatList.List[_wMsgIdx].lCnt + 1; // + 5 for test
						IF _lValueNum > 0 THEN
							_xMsgStatisticWriteNum := TRUE;
							IF _xMsgStatisticNumFirstEntry THEN
								_lValueNumMin := _lValueNum;
								_xMsgStatisticNumFirstEntry := FALSE;
							END_IF;
							IF _wIFMsgStatisticCntNum > MNMSG_MAX_IDX_VCMSGSTATLIST THEN
								IF _lValueNum < _lValueNumMin THEN
									_xMsgStatisticWriteNum := FALSE;
								END_IF;
							ELSE
								IF _lValueNum < _lValueNumMin THEN
									_lValueNumMin := _lValueNum;
								END_IF;
							END_IF;
							// Sortierung absteigend
							IF _xMsgStatisticWriteNum THEN
								_wPosMinNum := 0;
								IF _xFirstElementToInsertNum THEN
									_wPosMaxNum := 0;
									_wPosSearchNum := 0;
									_wPosEndNum := 0;
									_wIFMsgStatisticCntNum := 0;
									_xPosFoundNum := TRUE;
								ELSE
									_xPosFoundNum := FALSE;
									_wPosMaxNum := _wPosEndNum;
									_wPosSearchNum := (_wPosMaxNum + _wPosMinNum) / 2;
									IF _wPosEndNum = 0 THEN
										IF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) THEN
											_wPosSearchNum := 1;
										ELSE
											_wPosSearchNum := 0;
										END_IF;
										_xPosFoundNum := TRUE;
									END_IF;
								END_IF;
								WHILE NOT _xPosFoundNum DO
									IF ((_wPosSearchNum = 1) OR (_wPosSearchNum = 0)) AND NOT _xPosFoundNum THEN
										_wPosSearchNum := 0;
										IF (_msgStatisticNumIdx[_wPosSearchNum].lValue < _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue < _lValueNum) THEN
											_wPosSearchNum := 0;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue < _lValueNum) THEN
											_wPosSearchNum := 1;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue = _lValueNum) THEN
											_wPosSearchNum := 1;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue > _lValueNum) THEN
											_wPosSearchNum := 2;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue = _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue < _lValueNum) THEN
											_wPosSearchNum := 0;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue = _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue = _lValueNum) THEN
											_wPosSearchNum := 0;
											_xPosFoundNum := TRUE;
										ELSE
											// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
											_lHElseNum1 := _lHElseNum1 + 1;
											_wMsgListCnt := 0;
											WHILE _msgStatisticNumIdx[_wMsgListCnt].lValue > _lValueNum AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
												_wMsgListCnt := _wMsgListCnt + 1;
											END_WHILE;
											_wPosSearchNum := _wMsgListCnt;
											_xPosFoundNum := TRUE;
										END_IF;
									END_IF;
									IF ((_wPosSearchNum = (_wPosEndNum - 1)) OR (_wPosSearchNum = _wPosEndNum)) AND NOT _xPosFoundNum THEN
										_wPosSearchNum := _wPosEndNum;
										IF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum - 1].lValue > _lValueNum) THEN
											_wPosSearchNum := _wPosEndNum + 1;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue < _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum - 1].lValue > _lValueNum) THEN
											_wPosSearchNum := _wPosEndNum - 0;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue < _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum - 1].lValue = _lValueNum) THEN
											_wPosSearchNum := _wPosEndNum - 1;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue < _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum - 1].lValue < _lValueNum) THEN
											_wPosSearchNum := _wPosEndNum - 1;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue = _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum - 1].lValue > _lValueNum) THEN
											_wPosSearchNum := _wPosEndNum - 0;
											_xPosFoundNum := TRUE;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue = _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum - 1].lValue = _lValueNum) THEN
											_wPosSearchNum := _wPosEndNum - 1;
											_xPosFoundNum := TRUE;
										ELSE
											// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
											_lHElseNum2 := _lHElseNum2 + 1;
											_wMsgListCnt := 0;
											WHILE _msgStatisticNumIdx[_wMsgListCnt].lValue > _lValueNum AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
												_wMsgListCnt := _wMsgListCnt + 1;
											END_WHILE;
											_wPosSearchNum := _wMsgListCnt;
											_xPosFoundNum := TRUE;
										END_IF;
									END_IF;
									IF NOT _xPosFoundNum THEN
										IF (_msgStatisticNumIdx[_wPosSearchNum].lValue < _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue < _lValueNum) THEN
											_wPosMaxNum := _wPosSearchNum;
											_wPosSearchNum := (_wPosMinNum + _wPosMaxNum) / 2;
											IF (_wPosMaxNum - _wPosSearchNum) = 0 THEN
												_wMsgListCnt := 0;
												WHILE _msgStatisticNumIdx[_wMsgListCnt].lValue > _lValueNum AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
													_wMsgListCnt := _wMsgListCnt + 1;
												END_WHILE;
												_wPosSearchNum := _wMsgListCnt;
												_xPosFoundNum := TRUE;
											END_IF;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue > _lValueNum) THEN
											_wPosMinNum := _wPosSearchNum;
											_wPosSearchNum := (_wPosMinNum + _wPosMaxNum) / 2;
											IF (_wPosSearchNum - _wPosMinNum) = 0 THEN
												_wMsgListCnt := 0;
												WHILE _msgStatisticNumIdx[_wMsgListCnt].lValue > _lValueNum AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
													_wMsgListCnt := _wMsgListCnt + 1;
												END_WHILE;
												_wPosSearchNum := _wMsgListCnt;
												_xPosFoundNum := TRUE;
											END_IF;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue < _lValueNum) THEN
											_xPosFoundNum := TRUE;
											_wPosSearchNum := _wPosSearchNum + 1;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue > _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue = _lValueNum) THEN
											_xPosFoundNum := TRUE;
											_wPosSearchNum := _wPosSearchNum + 1;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue = _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue < _lValueNum) THEN
											_xPosFoundNum := TRUE;
											_wPosSearchNum := _wPosSearchNum;
										ELSIF (_msgStatisticNumIdx[_wPosSearchNum].lValue = _lValueNum) AND (_msgStatisticNumIdx[_wPosSearchNum + 1].lValue = _lValueNum) THEN
											_xPosFoundNum := TRUE;
											_wPosSearchNum := _wPosSearchNum;
										ELSE
											// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
											_lHElseNum3 := _lHElseNum3 + 1;
											_wMsgListCnt := 0;
											WHILE _msgStatisticNumIdx[_wMsgListCnt].lValue > _lValueNum AND (_wMsgListCnt < MNMSG_MAX_IDX_VCMSGSTATLIST) DO
												_wMsgListCnt := _wMsgListCnt + 1;
											END_WHILE;
											_wPosSearchNum := _wMsgListCnt;
											_xPosFoundNum := TRUE;
										END_IF;
									END_IF;
								END_WHILE;	// WHILE NOT _xPosFound DO
								IF _wPosSearchNum > MNMSG_MAX_IDX_VCMSGSTATLIST THEN
									_wPosSearchNum := MNMSG_MAX_IDX_VCMSGSTATLIST;
								END_IF;
								IF _wPosEndNum < MNMSG_MAX_IDX_VCMSGSTATLIST THEN
									_diMemMoveNumIdx := _wPosEndNum - _wPosSearchNum + 1;
								ELSE
									_diMemMoveNumIdx := _wPosEndNum - _wPosSearchNum;
								END_IF;
								IF (_diMemMoveNumIdx > 0) AND ((_wPosSearchNum + _diMemMoveNumIdx) <= MNMSG_MAX_IDX_VCMSGSTATLIST) THEN
									memmove(ADR(_msgStatisticNumIdx[_wPosSearchNum + 1]), ADR(_msgStatisticNumIdx[_wPosSearchNum]), _diMemMoveNumIdx * SIZEOF(_msgStatisticNumIdx[0]));
								END_IF;
								_msgStatisticNumIdx[_wPosSearchTime].wFunction_ID := _MsgCfgList[_wMsgIdx].wFunction_ID;
								_msgStatisticNumIdx[_wPosSearchTime].wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
								_msgStatisticNumIdx[_wPosSearchTime].wInstance := _MsgCfgList[_wMsgIdx].wInstance;
								_msgStatisticNumIdx[_wPosSearchNum].lValue := _lValueNum;
								IF NOT _xFirstElementToInsertNum THEN
									IF _wPosEndNum < MNMSG_MAX_IDX_VCMSGSTATLIST THEN
										_wPosEndNum := _wPosEndNum + 1;
									ELSE
										_wPosEndNum := MNMSG_MAX_IDX_VCMSGSTATLIST;
									END_IF;
								ELSE
									_xFirstElementToInsertNum := FALSE;
								END_IF;
								_lValueNumMin := _msgStatisticNumIdx[_wPosEndNum].lValue;
								_wIFMsgStatisticCntNum := _wIFMsgStatisticCntNum + 1;
								IF _wIFMsgStatisticCntNum > _wPosEndNum THEN
									_wIFMsgStatisticCntNum := _wPosEndNum + 1;
								END_IF;
								IF _wIFMsgStatisticCntNum > MNMSG_MAX_IDX_VCMSGSTATLIST THEN
									_wIFMsgStatisticCntNum := MNMSG_MAX_IDX_VCMSGSTATLIST + 1;
								END_IF;
							END_IF;	// _xMsgStatisticWriteNum
						END_IF;	// _lValue > 0
						//###DK2011Nov22

					END_IF // IF MNMSG_RUN_VC
						
					IF _xStatReady THEN
						_doWriteStat.Offset := SIZEOF(_StatHeader) + (_wMsgIdx-1)*SIZEOF(_StatLine);
						_doWriteStat.len := SIZEOF(_StatLine);
						_doWriteStat.pSource := ADR(_StatLine);
						_doWriteStat();
					END_IF;

				ELSE

					_lTime := 0;

				END_IF;
				
				_wActEvent := MNMSG_EVENT_GONE_TWO;
				_lActTime := _lTime;
				_actInsertRB;

				// Liste bearbeiten
				_InsertMsgLine.Class := UINT_TO_USINT(_MsgImage[_wMsgIdx].wMsgClass);
				_InsertMsgLine.Insert := FALSE;

				memset(ADR(_InsertMsgLine.MsgLine),0,SIZEOF(_InsertMsgLine.MsgLine));

				_InsertMsgLine.MsgLine.wFunction_ID :=  _MsgCfgList[_wMsgIdx].wFunction_ID;
				_InsertMsgLine.MsgLine.wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
				_InsertMsgLine.MsgLine.bInstance := UINT_TO_USINT(_MsgCfgList[_wMsgIdx].wInstance);
				_InsertMsgLine();
				
				IF _InsertMsgLine.Changed THEN

					CASE _MsgImage[_wMsgIdx].wMsgClass  OF
				
						MNMSG_CLASS_INTFAULT: _MsgImageHelp.xFaultIntChanged := TRUE;
					
						MNMSG_CLASS_EXTFAULT: _MsgImageHelp.xFaultExtChanged := TRUE;
					
						MNMSG_CLASS_WARNING: _MsgImageHelp.xWarningChanged := TRUE;
					
						MNMSG_CLASS_INFO: _MsgImageHelp.xInfoChanged := TRUE;

						MNMSG_CLASS_MAINTENANCE: _MsgImageHelp.xMaintChanged := TRUE;
					
					END_CASE
					
				END_IF

				// Image löschen
				// ###AH20110908
				memset(ADR(_MsgImage[_wMsgIdx]),0,SIZEOF(_MsgImage[_wMsgIdx]));
				memset(ADR(_MsgImageTime[_wMsgIdx]),0,SIZEOF(_MsgImageTime[_wMsgIdx]));
				
			END_IF
			
		END_FOR
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// Änderung an die Visualisierung melden

		// _dtTimeStamp löst nur alle Sekunde auf. Die Listen werden schneller aktualisiert
		
		IF _MsgImageHelp.xFaultExtChanged THEN

			mnMsgStatAd.Msg.dtMsgExtFaultChanged := DINT_TO_DT(IFmnSystem.In.PLC.diSystemTime);
			_MsgImageHelp.xFaultExtChanged := FALSE;
			_xUpdateMsgList := TRUE;

		END_IF

		IF _MsgImageHelp.xFaultIntChanged THEN

			mnMsgStatAd.Msg.dtMsgIntFaultChanged := DINT_TO_DT(IFmnSystem.In.PLC.diSystemTime);
			_MsgImageHelp.xFaultIntChanged := FALSE;
			_xUpdateMsgList := TRUE;

		END_IF

		IF _MsgImageHelp.xWarningChanged THEN

			mnMsgStatAd.Msg.dtMsgWarningChanged := DINT_TO_DT(IFmnSystem.In.PLC.diSystemTime);
			_MsgImageHelp.xWarningChanged := FALSE;
			_xUpdateMsgList := TRUE;

		END_IF

		IF _MsgImageHelp.xInfoChanged THEN

			mnMsgStatAd.Msg.dtMsgInfoChanged := DINT_TO_DT(IFmnSystem.In.PLC.diSystemTime);
			_MsgImageHelp.xInfoChanged := FALSE;
			_xUpdateMsgList := TRUE;

		END_IF

		IF _MsgImageHelp.xMaintChanged THEN

			mnMsgStatAd.Msg.dtMsgMaintChanged := DINT_TO_DT(IFmnSystem.In.PLC.diSystemTime);
			_MsgImageHelp.xMaintChanged := FALSE;
			_xUpdateMsgList := TRUE;
			
		END_IF

		IF EDGEPOS(_xMnTxtReady) THEN
			_xUpdateMsgList := TRUE;
		END_IF
		
		IF MNMSG_RUN_VC THEN
			
			//###DK2011Nov11
			// IFmnMsgOut_Typ contains MsgList 'Meldungsliste zur lokalen Anzeige auf der SPS'
			// MsgList of IFmnMsgOutMsgList_Typ[0..MNMSG_MAX_IDX_MSGLIST]
			// Constant UINT MNMSG_MAX_IDX_MSGLIST = 19
			// IntFault Class = 0, ExtFault Class = 1, Warning Class = 10, Info Class = 11, Maint Class = 20
			// MsgListFaultInt 'Meldungsliste der Visualisierung' 'Meldungsliste interne Fehler'
			// USINT MsgCntFaultInt 'Anzahl der Meldungen in der internen Fehlerliste'
			// IF _InsertMsgLine.Changed OR _xMsgClassChanged THEN
			IF (_xUpdateMsgListLan OR _xUpdateMsgList) AND _xMnTxtReady THEN
				
				_xUpdateMsgListLan := FALSE;
				_xUpdateMsgList := FALSE;
				
				_wIFMsgListCnt := 0;
				
				IF (_wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST) AND (mnMsgStatAd.Msg.MsgCntFaultInt > 0) THEN
					FOR _wMsgListCnt := 0 TO (mnMsgStatAd.Msg.MsgCntFaultInt - 1) BY 1 DO
						IF _wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST THEN
							_utfMsgTextTempFirst := "";
							_utfMsgTextTempSecond := "";
							_wActFunctionID := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].wFunction_ID;
							_wActMsgNumber := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].wMsgNumber;
							_wActInstance := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].bInstance;
							_diActAttr1 := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].diAttr1;
							_diActAttr2 := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].diAttr2;
							_sActAttrTxt := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].sAttrTxt;
							_actGetTxtFimh;
							// wcscat(ADR(_utfMsgTextTempSecond), ADR("help text"));	//Also for test
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgHelpText := _utfMsgTextTempSecond;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wFunction_ID := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].wFunction_ID;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wMsgNumber :=  mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].wMsgNumber;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bInstance := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].bInstance;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bMsgClass := 0;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bAckLevel := mnMsgStatAd.Msg.MsgListFaultInt[_wMsgListCnt].bAckLevel;
							_wIFMsgListCnt := _wIFMsgListCnt + 1;
						END_IF;
					END_FOR;
				END_IF;
				IF (_wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST) AND (mnMsgStatAd.Msg.MsgCntFaultExt > 0) THEN
					FOR _wMsgListCnt := 0 TO (mnMsgStatAd.Msg.MsgCntFaultExt - 1) BY 1 DO
						IF _wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST THEN
							_utfMsgTextTempFirst := "";
							_utfMsgTextTempSecond := "";
							_wActFunctionID := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].wFunction_ID;
							_wActMsgNumber := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].wMsgNumber;
							_wActInstance := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].bInstance;
							_diActAttr1 := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].diAttr1;
							_diActAttr2 := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].diAttr2;
							_sActAttrTxt := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].sAttrTxt;
							_actGetTxtFimh;
							// wcscat(ADR(_utfMsgTextTempSecond), ADR("help text"));	//Also for test
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgHelpText := _utfMsgTextTempSecond;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wFunction_ID := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].wFunction_ID;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wMsgNumber :=  mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].wMsgNumber;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bInstance := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].bInstance;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bMsgClass := 1;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bAckLevel := mnMsgStatAd.Msg.MsgListFaultExt[_wMsgListCnt].bAckLevel;
							_wIFMsgListCnt := _wIFMsgListCnt + 1;
						END_IF;
					END_FOR;
				END_IF;
				IF (_wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST) AND (mnMsgStatAd.Msg.MsgCntWarning > 0) THEN
					FOR _wMsgListCnt := 0 TO (mnMsgStatAd.Msg.MsgCntWarning - 1) BY 1 DO
						IF _wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST THEN
							_utfMsgTextTempFirst := "";
							_utfMsgTextTempSecond := "";
							_wActFunctionID := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].wFunction_ID;
							_wActMsgNumber := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].wMsgNumber;
							_wActInstance := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].bInstance;
							_diActAttr1 := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].diAttr1;
							_diActAttr2 := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].diAttr2;
							_sActAttrTxt := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].sAttrTxt;
							_actGetTxtFimh;
							// wcscat(ADR(_utfMsgTextTempSecond), ADR("help text"));	//Also for test
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgHelpText := _utfMsgTextTempSecond;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wFunction_ID := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].wFunction_ID;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wMsgNumber :=  mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].wMsgNumber;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bInstance := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].bInstance;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bMsgClass := 10;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bAckLevel := mnMsgStatAd.Msg.MsgListWarning[_wMsgListCnt].bAckLevel;
							_wIFMsgListCnt := _wIFMsgListCnt + 1;
						END_IF;
					END_FOR;
				END_IF;
				IF (_wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST) AND (mnMsgStatAd.Msg.MsgCntInformation > 0) THEN
					FOR _wMsgListCnt := 0 TO (mnMsgStatAd.Msg.MsgCntInformation - 1) BY 1 DO
						IF _wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST THEN
							_utfMsgTextTempFirst := "";
							_utfMsgTextTempSecond := "";
							_wActFunctionID := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].wFunction_ID;
							_wActMsgNumber := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].wMsgNumber;
							_wActInstance := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].bInstance;
							_diActAttr1 := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].diAttr1;
							_diActAttr2 := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].diAttr2;
							_sActAttrTxt := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].sAttrTxt;
							_actGetTxtFimh;
							// wcscat(ADR(_utfMsgTextTempSecond), ADR("help text"));	//Also for test
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgHelpText := _utfMsgTextTempSecond;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wFunction_ID := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].wFunction_ID;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].wMsgNumber :=  mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].wMsgNumber;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bInstance := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].bInstance;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bMsgClass := 11;
							IFmnMsg.Out.MsgList[_wIFMsgListCnt].bAckLevel := mnMsgStatAd.Msg.MsgListInformation[_wMsgListCnt].bAckLevel;
							_wIFMsgListCnt := _wIFMsgListCnt + 1;
						END_IF;
					END_FOR;
				END_IF;
				IF mnMsgStatAd.Msg.MsgCntMaintenance > 0 THEN
					IF (_wIFMsgListCnt + mnMsgStatAd.Msg.MsgCntMaintenance) <= MNMSG_MAX_IDX_VCMSGLIST THEN
						FOR _wMsgListCnt := 0 TO (mnMsgStatAd.Msg.MsgCntMaintenance - 1) BY 1 DO
							IF _wIFMsgListCnt <= MNMSG_MAX_IDX_VCMSGLIST THEN
								_utfMsgTextTempFirst := "";
								_utfMsgTextTempSecond := "";
								_wActFunctionID := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].wFunction_ID;
								_wActMsgNumber := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].wMsgNumber;
								_wActInstance := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].bInstance;
								_diActAttr1 := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].diAttr1;
								_diActAttr2 := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].diAttr2;
								_sActAttrTxt := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].sAttrTxt;
								_actGetTxtFimh;
								// wcscat(ADR(_utfMsgTextTempSecond), ADR("help text"));	//Also for test
								IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
								IFmnMsg.Out.MsgList[_wIFMsgListCnt].utfMsgHelpText := _utfMsgTextTempSecond;
								IFmnMsg.Out.MsgList[_wIFMsgListCnt].wFunction_ID := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].wFunction_ID;
								IFmnMsg.Out.MsgList[_wIFMsgListCnt].wMsgNumber :=  mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].wMsgNumber;
								IFmnMsg.Out.MsgList[_wIFMsgListCnt].bInstance := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].bInstance;
								IFmnMsg.Out.MsgList[_wIFMsgListCnt].bMsgClass := 20;
								IFmnMsg.Out.MsgList[_wIFMsgListCnt].bAckLevel := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].bAckLevel;
								_wIFMsgListCnt := _wIFMsgListCnt + 1;
							END_IF;
						END_FOR;
						
					ELSE
						// Wartungen von hinten auffüllen
						
						_wIFMsgListCnt := MNMSG_MAX_IDX_VCMSGLIST + 1;
	
						_wMsgCntMaint := MIN(mnMsgStatAd.Msg.MsgCntMaintenance, MIN(_wIFMsgListCnt,MNMSG_MAX_VCMSGLISTMAINT));
						
						FOR _wMsgListCnt := MNMSG_MAX_IDX_VCMSGLIST TO LIMIT(0,((MNMSG_MAX_IDX_VCMSGLIST + 1) -_wMsgCntMaint), MNMSG_MAX_IDX_VCMSGLIST) BY -1 DO
							_utfMsgTextTempFirst := "";
							_utfMsgTextTempSecond := "";
							_wIdxMsgListMaint := (_wMsgListCnt + _wMsgCntMaint) - MNMSG_MAX_IDX_VCMSGLIST;
							_wActFunctionID := mnMsgStatAd.Msg.MsgListMaintenance[_wIdxMsgListMaint].wFunction_ID;
							_wActMsgNumber := mnMsgStatAd.Msg.MsgListMaintenance[_wIdxMsgListMaint].wMsgNumber;
							_wActInstance := mnMsgStatAd.Msg.MsgListMaintenance[_wIdxMsgListMaint].bInstance;
							_diActAttr1 := mnMsgStatAd.Msg.MsgListMaintenance[_wIdxMsgListMaint].diAttr1;
							_diActAttr2 := mnMsgStatAd.Msg.MsgListMaintenance[_wIdxMsgListMaint].diAttr2;
							_sActAttrTxt := mnMsgStatAd.Msg.MsgListMaintenance[_wIdxMsgListMaint].sAttrTxt;
							_actGetTxtFimh;
							// wcscat(ADR(_utfMsgTextTempSecond), ADR("help text"));	//Also for test
							IFmnMsg.Out.MsgList[_wMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
							IFmnMsg.Out.MsgList[_wMsgListCnt].utfMsgHelpText := _utfMsgTextTempSecond;
							IFmnMsg.Out.MsgList[_wMsgListCnt].wFunction_ID := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].wFunction_ID;
							IFmnMsg.Out.MsgList[_wMsgListCnt].wMsgNumber :=  mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].wMsgNumber;
							IFmnMsg.Out.MsgList[_wMsgListCnt].bInstance := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].bInstance;
							IFmnMsg.Out.MsgList[_wMsgListCnt].bMsgClass := 20;
							IFmnMsg.Out.MsgList[_wMsgListCnt].bAckLevel := mnMsgStatAd.Msg.MsgListMaintenance[_wMsgListCnt].bAckLevel;
						END_FOR;
					END_IF;
				END_IF;
				
				_ii := _wIFMsgListCnt;
				
				WHILE _ii <= MNMSG_MAX_IDX_VCMSGLIST DO
					IFmnMsg.Out.MsgList[_ii].utfMsgText := "";
					IFmnMsg.Out.MsgList[_ii].utfMsgHelpText := "";
					IFmnMsg.Out.MsgList[_ii].wFunction_ID := 0;
					IFmnMsg.Out.MsgList[_ii].wMsgNumber :=  0;
					IFmnMsg.Out.MsgList[_ii].bInstance := 0;
					IFmnMsg.Out.MsgList[_ii].bMsgClass := 0;
					IFmnMsg.Out.MsgList[_ii].bAckLevel := 0;
					_ii := _ii + 1;
				END_WHILE;
			END_IF;
			
			IFmnMsg.Out.wMsgListCnt := _wIFMsgListCnt;
			//###DK2011Nov11

		END_IF // IF MNMSG_RUN_VC
		
			
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		//*******************Meldungsstatistik loeschen und fuer die Aufzeichnung Bereitstellen*******************************
		//
		//Beim loeschen der Meldungsstatistik wird die gesammte Datenmodul geloescht und neue erstellt.
		//________________________________________________________________________________________
	
		_xDeleteMsgStat := EDGEPOS(_EventStatisticDelStep = Del_Delete);
		
		IF _xDeleteMsgStat THEN
			// Delete MsgStatistic.
			//###DK2012Jan06
			FOR _wMsgListCnt := 0 TO MNMSG_MAX_IDX_VCMSGSTATLIST BY 1 DO
				_msgStatisticNumIdx[_wMsgListCnt].wFunction_ID := 0;
				_msgStatisticNumIdx[_wMsgListCnt].wMsgNumber := 0;
				_msgStatisticNumIdx[_wMsgListCnt].wInstance := 0;
				_msgStatisticNumIdx[_wMsgListCnt].lValue := 0;
			END_FOR;
			_wIFMsgStatisticCntNum := 0;
			FOR _wMsgListCnt := 0 TO MNMSG_MAX_IDX_VCMSGSTATLIST BY 1 DO
				_msgStatisticTimeIdx[_wMsgListCnt].wFunction_ID := 0;
				_msgStatisticTimeIdx[_wMsgListCnt].wMsgNumber := 0;
				_msgStatisticTimeIdx[_wMsgListCnt].wInstance := 0;
				_msgStatisticTimeIdx[_wMsgListCnt].lValue := 0;
			END_FOR;
			_wIFMsgStatisticCntTime := 0;

			_xRefreshStatistic := TRUE;

			_lTime := 0;
			_lValueTimeMin := 0;
			_lValueNumMin := 0;
			_xMsgStatisticTimeFirstEntry := TRUE;
			_xMsgStatisticNumFirstEntry := TRUE;
			_xMsgStatisticWriteTime := TRUE;
			_xMsgStatisticWriteNum := TRUE;
			_xFirstElementToInsertTime := TRUE;
			_xFirstElementToInsertNum := TRUE;
		END_IF;

		// Statistik löschen
		CASE _EventStatisticDelStep OF

			Del_Wait:
				// Nichts tun

			Del_Delete:
				// Datenobjekt löschen
				_doDeleteStat.enable := TRUE;
				_doDeleteStat.ident :=  _kgCheckStat.doId;
				_doDeleteStat();

				IF _doDeleteStat.status = ERR_OK OR _doDeleteStat.status =  doERR_MODULNOTFOUND THEN
					
					_EventStatisticDelStep := Del_Check;

				ELSIF _doDeleteStat.status <> ERR_FUB_BUSY   THEN
						
					_xStatFault := TRUE;
					_xLogDeleteStat := TRUE;
					_EventStatisticDelStep := Del_Error;

				END_IF;

			Del_Check:

				_kgCheckStat(Enable := TRUE, pName := ADR('_MsgStat'), MinLen := SIZEOF(_MsgStatList), NomLen := SIZEOF(_MsgStatList), Create := TRUE, MemType := doUSRROM);

				IF _kgCheckStat.Status = KG_INFO_DO_NEW THEN

					_MsgStatList ACCESS _kgCheckStat.doMem;

					_StatHeader.lVersion := 0;
					_StatHeader.lLength :=  UINT_TO_UDINT(MNMSG_MAX_CFGMESSAGES);
				
					_doWriteStat.enable := TRUE;
					_doWriteStat.ident := _kgCheckStat.doId;
				
					_doWriteStat.Offset := 0;
					_doWriteStat.len := SIZEOF(_StatHeader);
					_doWriteStat.pSource := ADR(_StatHeader);

					_EventStatisticDelStep := Del_Write;		

				ELSIF _kgCheckStat.Status <> ERR_FUB_BUSY THEN

					_xStatFault := TRUE;
					_xLogCreateStat := TRUE;
					_EventStatisticDelStep := Del_Error;
					
				END_IF

			Del_Write:

				_doWriteStat();
								
				IF _doWriteStat.status = ERR_OK THEN
					
					_xStatReady := TRUE;
					_EventStatisticDelStep := Del_Wait;	

				ELSIF _doWriteStat.status <> ERR_FUB_BUSY THEN

					_xStatFault := TRUE;
					_xLogWriteStat := TRUE;
					_EventStatisticDelStep := Del_Error;		
					
				END_IF

			Del_Error:
				//?: Leer?
		
		END_CASE;

		CASE _EventHistDelStep OF

			Del_WaitH:

			Del_DeleteH:
				_wPtrRBwrite := 0;
				_wPtrRBread := 0;
				_wPtrRBloc := 0;
				_wPtrRBstart := 0;
				_wPtrRBlocTemp := 0;
				_wPtrRBlocTempTwo := 0;
				_wPtrRBlocTempThree := 0;
				_wPtrRBlocLastFound := 0;
				_wMsgHistListCntRB := 0;
				_wMsgHistListOffsetRB := 0;
				_wMsgHistListMaxOffsetRB := 0;
				_xTrigRefreshHistList := TRUE;
				IFmnMsg.Out.wMsgHistListCnt := _wMsgHistListCntRB;
				IFmnMsg.Out.wMsgHistListMaxOffset := _wMsgHistListMaxOffsetRB;
				IFmnMsg.Out.wMsgHistListOffset := _wMsgHistListOffsetRB;
				_xRefreshHistList := TRUE;

				_EventHistDelStep := Del_WaitH;

			Del_ErrorH:
				//?: Leer?
		END_CASE;

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		//**************************************************Ansteuerung der IFmnMsg Interface*************************************************************
		//___________________________________________________________________________________________________________


		IFmnMsg.Out.xFaultInt := mnMsgStatAd.Msg.MsgCntFaultInt <> 0;
		IFmnMsg.Out.xFaultExt := mnMsgStatAd.Msg.MsgCntFaultExt <> 0;
		IFmnMsg.Out.xWarning := mnMsgStatAd.Msg.MsgCntWarning <> 0;
		IFmnMsg.Out.xInformation := mnMsgStatAd.Msg.MsgCntInformation <> 0;
		IFmnMsg.Out.xMaintenance := mnMsgStatAd.Msg.MsgCntMaintenance <> 0;
		IFmnMsg.Out.wCntFaultNoAck := _wCntFaultNotAck;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		//**************************************************Ansteuerung des MachineState.xFault*************************************************************
		//___________________________________________________________________________________________________________

		IFmnMsg.Out.xFault	:= ((mnMsgStatAd.Msg.MsgCntFaultInt <> 0) OR (mnMsgStatAd.Msg.MsgCntFaultExt <> 0));

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		IF _xMnParOk THEN	// mnPar fertig

			// Die Hupe geht nur mit einer positiven Flanke an. Mit Quittierung und Verschwinden der Meldung geht die Hupe wieder aus

			IF EDGEPOS(IFmnMsg.Out.xFaultExt OR IFmnMsg.Out.xFaultInt) THEN
				// DK: IF EDGEPOS(IFmnMsg.Out.xFaultExt) OR EDGEPOS(IFmnMsg.Out.xFaultInt) THEN
				_xHornFaultOnh := TRUE;
				// _xHHornFaultOnh := TRUE;	// For test.
			ELSIF NOT (IFmnMsg.Out.xFaultExt OR IFmnMsg.Out.xFaultInt) THEN
				// DK: ELSIF NOT(IFmnMsg.Out.xFaultExt) AND NOT(IFmnMsg.Out.xFaultInt) THEN
				_xHornFaultOnh := FALSE;
			END_IF

			IF EDGEPOS(IFmnMsg.Out.xWarning) THEN
				_xHornWarnOnh := TRUE;
				ELSIF NOT IFmnMsg.Out.xWarning THEN
					_xHornWarnOnh := FALSE;
			END_IF

			IF _xExtcmdHornOff OR _xIFcmdHornOff THEN
				_xHornFaultOnh := FALSE;
				_xHornWarnOnh := FALSE;
			END_IF

			// Einmaliges EIN für Fehler
			// _tpFault of TP FB 'implements a pulse generator' local variable of program mnMsg 'Hupensteuerung'
			// mnMsgPar of mnMsgPar_Typ variable of package Pkg_mnMsg 'Kommandschnittstelle Visualisierung'
			// mnMsgPar_Typ contains Mac of mnMsgParMac_Typ
			_tpFault(IN := _xHornFaultOnh,PT := UDINT_TO_TIME(UINT_TO_UDINT(mnMsgPar.Mac.wTimeOnFault)*1000));
			// Intervall bei Fehler
			// _tonFault1 of TON FB 'implements a switch on delay' local variable of program mnMsg 'Hupensteuerung'
			// _tonFault2 of TON FB 'implements a switch on delay' local variable of program mnMsg 'Hupensteuerung'
			_tonFault1(IN := _xHornFaultOnh AND NOT _tonFault2.Q,PT := UDINT_TO_TIME(UINT_TO_UDINT(mnMsgPar.Mac.wTimeOnFault)*1000));
			_tonFault2(IN := _tonFault1.Q,PT := UDINT_TO_TIME(UINT_TO_UDINT(mnMsgPar.Mac.wTimeOffFault)*1000));

			// _wFaultMode local variable of program mnMsg 'Hupensteuerung'
			_wFaultMode := mnMsgPar.Mac.wModeHorn MOD 10;

			// UINT MSG_HORNMODE_ON variable of packagePkg_mnMsg 'Modus der Hupe', init value 1
			IF _wFaultMode = MNMSG_HORNMODE_ON THEN
			
				IF mnMsgPar.Mac.wTimeOnFault = 0 THEN
				
					//Dauer ein
					_xHornFaultOn := _xHornFaultOnh;
				
				ELSE
				
					// Puls
					_xHornFaultOn := _tpFault.Q;
				
				END_IF
			
			ELSIF _wFaultMode = MNMSG_HORNMODE_INTERV THEN
			
				// Intervall
				_xHornFaultOn := _xHornFaultOnh AND NOT _tonFault1.Q;
			
			ELSE
			
				//AUS
				_xHornFaultOn := FALSE;
			
			END_IF
				

			// Einmaliges EIN für Warnung
			_tpWarn(IN := _xHornWarnOnh,PT := UDINT_TO_TIME(UINT_TO_UDINT(mnMsgPar.Mac.wTimeOnWarning)*1000));
			// Intervall bei Fehler
			_tonWarn1(IN := _xHornWarnOnh AND NOT _tonWarn2.Q,PT := UDINT_TO_TIME(UINT_TO_UDINT(mnMsgPar.Mac.wTimeOnWarning)*1000));
			_tonWarn2(IN := _tonWarn1.Q,PT := UDINT_TO_TIME(UINT_TO_UDINT(mnMsgPar.Mac.wTimeOffWarning)*1000));
		
			_wWarnMode := mnMsgPar.Mac.wModeHorn / 10;
		
			IF _wWarnMode = MNMSG_HORNMODE_ON THEN
			
				IF mnMsgPar.Mac.wTimeOnWarning = 0 THEN
				
					//Dauer ein
					_xHornWarnOn := _xHornWarnOnh;
				
				ELSE
				
					// Puls
					_xHornWarnOn := _tpWarn.Q;
				
				END_IF
			
			ELSIF _wWarnMode = MNMSG_HORNMODE_INTERV THEN
			
				// Intervall
				_xHornWarnOn := _xHornWarnOnh AND NOT _tonWarn1.Q;
			
			ELSE
			
				//AUS
				_xHornWarnOn := FALSE;
			
			END_IF
		
			// Ansgang ansteuern
			IF _xHornFaultOnh THEN
				IFmnMsg.Out.bHorn  := SEL(_xHornFaultOn, 0, 1);
			ELSIF _xHornWarnOnh THEN
				IFmnMsg.Out.bHorn  := SEL(_xHornWarnOn, 0, 2);
			ELSE
				IFmnMsg.Out.bHorn := 0;
			END_IF

			_xIFcmdHornOff := FALSE;
			_xExtcmdHornOff := FALSE;
			
			mnMsgStatAd.Msg.bHorn := _xHornFaultOnh OR _xHornWarnOnh;

			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		//*************************************************************Lichtsteuerung*************************************************************************
		//_______________________________________________________________________________________________________

			IF IFmnMsg.Out.xFaultInt OR IFmnMsg.Out.xFaultExt THEN

				IFmnMsg.Out.bLight := 1;

			ELSIF IFmnMsg.Out.xWarning THEN

				IFmnMsg.Out.bLight := 10;

			ELSIF IFmnMsg.Out.xInformation THEN

				IFmnMsg.Out.bLight := 11;

			ELSIF IFmnMsg.Out.xMaintenance THEN

				IFmnMsg.Out.bLight := 20;

			ELSE

				IFmnMsg.Out.bLight := 0;	

			END_IF;

		ELSE
			
			IFmnMsg.Out.bHorn := 0;
			IFmnMsg.Out.bLight := 0;
		
		END_IF

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		//****************Ringbuffer in die SQL-Datenbank übertragen*****************************************
		//_______________________________________________________________________________


		IF _xRBReady THEN

			CASE _wStepRdRb OF
			
				0:	// IDLE
			
					IFhlDFII.In.ReqMsgEvt.wRequest := 0;
					
					IF ((hlDFIIStat.wStatus = 0) AND (_wPtrRBread <> _wPtrRBwrite) AND (IFhlDFII.Out.RespMsgEvt.wResponse = 0)) THEN
						// DF_Interface ist bereit und es sind Einträge im RB zum schreiben
						// hlDFIIStat of Stat_typ belongs to Pkg_hlDFIIShare::Pkg_hlDFII
						// IFhlDFII of IFhlDFII_typ, IFhlDFII_typ contains InOut of IFHlDFII_InOut_Typ
						// bEvent: 0 - idle, 1 - req, 2 - busy, 3 - ready, 255 - fault
						//?: 1 - req: request?
						_wStepRdRb := 10;
					END_IF
			
				10:	// Daten zusammenstellen
					// USINT bCntLines: 1..5
			
					IFhlDFII.In.ReqMsgEvt.bCntLines := 0;
				
					FOR _ii := 1 TO 5 DO
					
						//###AH 16.07.2012 : Version 1.12.0
						_ReadRB(wPtrStart := _wPtrRBstart, wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread);
						//?: 1 bis 5: Muss hier erweitert werden?

						IF (_ReadRB.wStatus = 0) THEN
					
							IFhlDFII.In.ReqMsgEvt.MsgHistList[_ii] := _TempHistline;
							IFhlDFII.In.ReqMsgEvt.bCntLines := IFhlDFII.In.ReqMsgEvt.bCntLines + 1;
					
							IF _wPtrRBread = _wPtrRBwrite THEN
								EXIT;
							END_IF
					
						ELSE
							EXIT;
						END_IF
					
					END_FOR
				
					IF (IFhlDFII.In.ReqMsgEvt.bCntLines > 0) THEN
						IFhlDFII.In.ReqMsgEvt.wRequest := 1;
						_wStepRdRb := 20;
					ELSE
						_wStepRdRb := 0;
					END_IF

				
				20: // Auf Abarbeitung warten
			
					IF IFhlDFII.Out.RespMsgEvt.wResponse = IFhlDFII.In.ReqMsgEvt.wRequest THEN
						_wStepRdRb := 0;
					ELSIF IFhlDFII.Out.RespMsgEvt.wResponse <> ERR_FUB_BUSY THEN
						_wStepRdRb := 30;
					END_IF

				30: // Wiederholen
					
					_lErrCnt := _lErrCnt + 1;
					IFhlDFII.In.ReqMsgEvt.wRequest := 0;
					IF hlDFIIStat.wStatus = 0 AND IFhlDFII.Out.RespMsgEvt.wResponse = 0 AND _TONrepeatDFII.Q THEN
						IFhlDFII.In.ReqMsgEvt.wRequest := 1;
						_wStepRdRb := 20;
					END_IF
					
			END_CASE 

			_TONrepeatDFII(IN := _wStepRdRb = 30, PT := T#30s);
			
		END_IF // _xRBReady

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


		IF MNMSG_RUN_VC THEN
			
			//###DK2012Jan02
			// Wird an die richtige Stelle geschrieben? - done
			// Ist TO wMsgHistListMaxOffset richtig? - done
			//###DK2012Feb21
			IF _xUpdateMsgHistListRB AND _xMnTxtReady THEN
				// _wMsgHistListCntUpdate := IFmnMsg.Out.wMsgHistListCnt;
				_wMsgHistListCntUpdate := _wMsgHistListCntRB;
				IF _wMsgHistListCntUpdate > 0 THEN
					FOR _wMsgListCnt := 0 TO (_wMsgHistListCntUpdate - 1) BY 1 DO
						_utfMsgTxtLCIDfirst := "";
						_utfMsgTxtLCIDsecond := "";
						(* wcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(IFmnMsg.Out.MsgHistList[_wMsgListCnt].utfMsgText),
						UDINT_TO_UINT(wcslen(ADR(IFmnMsg.Out.MsgHistList[_wMsgListCnt].utfMsgText)) - (wcslen(ADR(_utfMsgTxtLCIDfirst)) + wcslen(ADR(IFmnMsg.Out.MsgHistList[_wMsgListCnt].utfMsgText)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1)))); *)
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_MsgHistListRB[_wMsgListCnt].utfMsgText),
						UDINT_TO_UINT(brwcslen(ADR(_MsgHistListRB[_wMsgListCnt].utfMsgText)) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(_MsgHistListRB[_wMsgListCnt].utfMsgText)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						_GetNextChrPos.lStartPos := 15;
						_GetNextChrPos.utfStr := ADR(_utfMsgTxtLCIDfirst);
						_GetNextChrPos.utfChr := " ";
						_GetNextChrPos();
						_lPosSpaceFirst := _GetNextChrPos.lChrPos;
						_lAdrSpaceFirst := ADR(_utfMsgTxtLCIDfirst) + 2 * _lPosSpaceFirst;
						//
						_GetNextChrPos.lStartPos := _lPosSpaceFirst + 1;
						_GetNextChrPos.utfStr := ADR(_utfMsgTxtLCIDfirst);
						_GetNextChrPos.utfChr := ".";
						_GetNextChrPos();
						_lPosPointFirst := _GetNextChrPos.lChrPos;
						_lAdrPointFirst := ADR(_utfMsgTxtLCIDfirst) + 2 * _lPosPointFirst;
						//
						_GetNextChrPos.lStartPos := _lPosPointFirst + 1;
						_GetNextChrPos.utfStr := ADR(_utfMsgTxtLCIDfirst);
						_GetNextChrPos.utfChr := ".";
						_GetNextChrPos();
						_lPosPointSecond := _GetNextChrPos.lChrPos;
						_lAdrPointSecond := ADR(_utfMsgTxtLCIDfirst) + 2 * _lPosPointSecond;
						//
						_GetNextChrPos.lStartPos := _lPosPointSecond + 1;
						_GetNextChrPos.utfStr := ADR(_utfMsgTxtLCIDfirst);
						_GetNextChrPos.utfChr := " ";
						_GetNextChrPos();
						_lPosSpaceSecond := _GetNextChrPos.lChrPos;
						_lAdrSpaceSecond := ADR(_utfMsgTxtLCIDfirst) + 2 * _lPosSpaceSecond;
						//
						IF (_lPosSpaceFirst > 0) AND (_lPosSpaceFirst < (SIZEOF(_utfRbsDateTime) / 2)) THEN
							_utfRbsDateTime := "";
							brwcsncat(ADR(_utfRbsDateTime), ADR(_utfMsgTxtLCIDfirst), _lPosSpaceFirst);
						ELSE
							_utfRbsDateTime := "";
						END_IF;
						IF ((_lPosPointFirst - 1 - _lPosSpaceFirst) > 0) AND ((_lPosPointFirst - 1 - _lPosSpaceFirst) < (SIZEOF(_utfLCIDFunctionId) / 2)) THEN
							_utfLCIDFunctionId := "";
							brwcsncat(ADR(_utfLCIDFunctionId), _lAdrSpaceFirst + 2, _lPosPointFirst - 1 - _lPosSpaceFirst);
							_wLCIDFunctionId := WSTRING_TO_UINT(_utfLCIDFunctionId);
						ELSE
							_utfLCIDFunctionId := "";
							_wLCIDFunctionId := 0;
						END_IF;
						IF ((_lPosPointSecond - 1 - _lPosPointFirst) > 0) AND ((_lPosPointSecond - 1 - _lPosSpaceFirst) < (SIZEOF(_utfLCIDMsgNumber) / 2)) THEN
							_utfLCIDMsgNumber := "";
							brwcsncat(ADR(_utfLCIDMsgNumber), _lAdrPointFirst + 2, _lPosPointSecond - 1 - _lPosPointFirst);
							_wLCIDMsgNumber := WSTRING_TO_UINT(_utfLCIDMsgNumber);
						ELSE
							_utfLCIDMsgNumber := "";
							_wLCIDMsgNumber := 0;
						END_IF;
						IF ((_lPosSpaceSecond - 1 - _lPosPointSecond) > 0) AND ((_lPosSpaceSecond - 1 - _lPosPointSecond) < (SIZEOF(_utfLCIDInstance) / 2)) THEN
							_utfLCIDInstance := "";
							brwcsncat(ADR(_utfLCIDInstance), _lAdrPointSecond + 2, _lPosSpaceSecond - 1 - _lPosPointSecond);
							_wLCIDInstance := WSTRING_TO_UINT(_utfLCIDInstance);
						ELSE
							_utfLCIDInstance := "";
							_wLCIDInstance := 0;
						END_IF;
						_utfMsgTxtLCIDfirst := "";
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_utfRbsDateTime),
						UDINT_TO_UINT(brwcslen(ADR(_utfRbsDateTime)) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(_utfRbsDateTime)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(" "),
						UDINT_TO_UINT(brwcslen(ADR(" ")) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(" ")) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_utfLCIDFunctionId),
						UDINT_TO_UINT(brwcslen(ADR(_utfLCIDFunctionId)) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(_utfLCIDFunctionId)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR("."),
						UDINT_TO_UINT(brwcslen(ADR(".")) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(".")) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_utfLCIDMsgNumber),
						UDINT_TO_UINT(brwcslen(ADR(_utfLCIDMsgNumber)) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(_utfLCIDMsgNumber)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR("."),
						UDINT_TO_UINT(brwcslen(ADR(".")) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(".")) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_utfLCIDInstance),
						UDINT_TO_UINT(brwcslen(ADR(_utfLCIDInstance)) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(_utfLCIDInstance)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						brwcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(" "),
						UDINT_TO_UINT(brwcslen(ADR(" ")) - (brwcslen(ADR(_utfMsgTxtLCIDfirst)) + brwcslen(ADR(" ")) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
						_wActFunctionID := _wLCIDFunctionId;
						_wActMsgNumber := _wLCIDMsgNumber;
						_wActInstance := _wLCIDInstance;
						_utfMsgTextTempFirst := "";
						_utfMsgTextTempFirst := _utfMsgTxtLCIDfirst;
						_actGetTxtFim;
						_utfMsgTxtLCIDfirst := "";
						_utfMsgTxtLCIDfirst := _utfMsgTextTempFirst;
						_MsgHistListRB[_wMsgListCnt].utfMsgText := "";
						brwcsncat(ADR(_MsgHistListRB[_wMsgListCnt].utfMsgText), ADR(_utfMsgTxtLCIDfirst),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTxtLCIDfirst)) - (brwcslen(ADR(_MsgHistListRB[_wMsgListCnt].utfMsgText)) + brwcslen(ADR(_utfMsgTxtLCIDfirst)) - (SIZEOF(_MsgHistListRB[_wMsgListCnt].utfMsgText) / 2 - 1))));
					END_FOR;
				END_IF; // IF _wMsgHistListCntUpdate > 0 THEN
				_xUpdateMsgHistListRB := FALSE;
			END_IF; // _xUpdateMsgHistListRB AND _xMnTxtReady
			//###DK2012Feb21

			IF _wPrevLCID <> _wLCID THEN
				IF _xMnTxtReady AND (IFmnTxt.In.wSelectLanguage = IFmnTxt.Out.wSelectedLanguage) THEN
					_wPrevLCID := _wLCID;
					_xUpdateMsgListLan := TRUE;
					_xUpdateMsgHistListRB := TRUE;
					_xMsgStatisticSelectChanged := TRUE;
				END_IF;
			END_IF;
	
			//###DK2012Feb06
			// Set HistList.
			IF IFmnMsg.Trig.xSetHistListOffset THEN
				IFmnMsg.Trig.xSetHistListOffset := FALSE;
				IFmnMsg.Out.wMsgHistListOffset := IFmnMsg.In.wMsgHistListSetOffset;
			END_IF;
			
			_wMsgHistListOffsetRB := IFmnMsg.Out.wMsgHistListOffset;
			_wMsgHistListEventSelRB := IFmnMsg.In.wMsgHistListEventSelect;
			_wMsgHistListClassSelRB := IFmnMsg.In.wMsgHistListClassSelect;
			//###AH2011Dec19
			
			_xTrigRefreshHistList := EDGEPOS(IFmnMsg.Trig.xRefreshHistList OR _xRefreshHistList);
			IF IFmnMsg.Trig.xRefreshHistList OR _xRefreshHistList THEN
				_xRefreshHistListRB := TRUE;
				IFmnMsg.Trig.xRefreshHistList := FALSE;
				_xRefreshHistList := FALSE;
			END_IF;
			
			IF IFmnMsg.Trig.xMsgHistListPointToMin THEN
				_xMsgHistListPointToMinRB := TRUE;
				IFmnMsg.Trig.xMsgHistListPointToMin := FALSE;
			END_IF;
			
			IF IFmnMsg.Trig.xTrigPrevMsgHistListPage THEN
				_xTrigPrevMsgHistListPageRB := TRUE;
				IFmnMsg.Trig.xTrigPrevMsgHistListPage := FALSE;
			END_IF;
			
			IF IFmnMsg.Trig.xTrigNextMsgHistListPage THEN
				_xTrigNextMsgHistListPageRB := TRUE;
				IFmnMsg.Trig.xTrigNextMsgHistListPage := FALSE;
			END_IF;
			//###DK2012Feb06
			//###DK2012Feb17
			IF _wPrevMsgHistListOffsetRB <> _wMsgHistListOffsetRB THEN
				_wPrevMsgHistListOffsetRB := _wMsgHistListOffsetRB;
				_xMsgHistListOffsetChRB := TRUE;
			END_IF;
			IF _wPrevMsgHistListEventSelRB <> _wMsgHistListEventSelRB THEN
				_wPrevMsgHistListEventSelRB := _wMsgHistListEventSelRB;
				_xMsgHistListEventSelChRB := TRUE;
			END_IF;
			IF _wPrevMsgHistListClassSelRB <> _wMsgHistListClassSelRB THEN
				_wPrevMsgHistListClassSelRB := _wMsgHistListClassSelRB;
				_xMsgHistListClassSelChRB := TRUE;
			END_IF;
			IF _xMsgHistListPointToMinRB THEN
				IFmnMsg.Out.wMsgHistListOffset := _wPtrRBstart;
				_wMsgHistListOffsetRB := _wPtrRBstart;
				_xTrigRefreshHistList := TRUE;
				_xMsgHistListPointToMinRB := FALSE;
			END_IF;
			_actGetOneTurnRB;
			// What if prevPage and nextPage are pressed simultaneously?
			IF _xTrigPrevMsgHistListPageRB THEN
				IF _xRBReady THEN
					_wPtrRBlocTemp := _wPtrRBloc;
					_actLocMOD;
					_wMsgListCnt := 0;
					_wPtrRBlocTempTwo := _wPtrRBloc;
					_wPtrRBlocLastFound := _wPtrRBloc;
					_wPtrRBlocTempFour := _wPtrRBloc;
					_xPtrRBlocAgain := FALSE;
					WHILE (_wPtrRBlocTempTwo - _wPtrRBloc) < (MNMSG_MAX_IDX_VCMSGHISTLIST + _wMsgListCnt) DO
						_wPtrRBlocTempThree := _wPtrRBloc;
						_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
						_wPtrRBloc := _wPtrRBlocTempThree;
						_actEventClassSel;
						IF NOT _xSelOk THEN
							_wMsgListCnt := _wMsgListCnt + 1;
						END_IF;
						IF _wMsgListCnt > MNMSG_MAX_MESSAGEHISTORY THEN
							_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
							EXIT;
						END_IF;
						IF _wPtrRBloc = _wPtrRBstart THEN
							_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
							EXIT;
						END_IF;
						IF _wPtrRBloc > 1 THEN
							_wPtrRBloc := _wPtrRBloc - 1;
						ELSE
							IF _xRBoneTurn THEN
								_wPtrRBloc := _wMsgHistListMaxOffsetRB;
								_wPtrRBlocTempTwo := _wPtrRBlocTempTwo + _wMsgHistListMaxOffsetRB;
								IF _wPtrRBlocTempTwo > 2 * _wMsgHistListMaxOffsetRB THEN
									_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
									EXIT;
								END_IF;
							ELSE
								_wPtrRBloc := 0;
								_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
								_actEventClassSel;
								_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
								EXIT;
							END_IF;
						END_IF;
						_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
						_actEventClassSel;
						_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
					END_WHILE;
					_wPtrRBloc := _wPtrRBlocTemp;
				END_IF;
				_xTrigPrevMsgHistListPageRB := FALSE;
				_xTrigRefreshHistList := TRUE;
			END_IF;
			IF _xTrigNextMsgHistListPageRB THEN
				IF _xRBReady THEN
					_wPtrRBlocTemp := _wPtrRBloc;
					_actLocMOD;
					_wMsgListCnt := 0;
					_xTurnaround := FALSE;
					_wPtrRBlocTempTwo := _wPtrRBloc;
					_wPtrRBlocLastFound := _wPtrRBloc;
					_wPtrRBlocTempFour := _wPtrRBloc;
					_xPtrRBlocAgain := FALSE;
					WHILE (_wPtrRBloc - _wPtrRBlocTempTwo) < MNMSG_MAX_IDX_VCMSGHISTLIST + _wMsgListCnt DO
						_wPtrRBlocTempThree := _wPtrRBloc;
						_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
						_wPtrRBloc := _wPtrRBlocTempThree;
						_actEventClassSel;
						IF NOT _xSelOk THEN
							_wMsgListCnt := _wMsgListCnt + 1;
						END_IF;
						IF _wMsgListCnt > MNMSG_MAX_MESSAGEHISTORY THEN
							_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
							EXIT;
						END_IF;
						IF _xRBoneTurn AND _wPtrRBstart > 0 THEN // _xRBoneTurn
							IF _wPtrRBloc = _wPtrRBstart - 1 THEN // _wPtrRBwrite
								IF _wPtrRBloc > 0 THEN
									_wPtrRBloc := _wPtrRBloc - 1;
									_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
									_actEventClassSel;
									_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
								ELSE
									_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
								END_IF;
								EXIT;
							END_IF;
						ELSE // NOT _xRBoneTurn
							IF _wPtrRBloc = _wMsgHistListMaxOffsetRB THEN
								_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
								EXIT;
							END_IF;
						END_IF;
						IF _wPtrRBloc + 1 <= _wMsgHistListMaxOffsetRB THEN
							_wPtrRBloc := _wPtrRBloc + 1;
						ELSE
							IF _xRBoneTurn THEN
								IF _xTurnaround THEN
									_xTurnaround := FALSE;
									EXIT;
								END_IF;
								_wPtrRBloc := 0;
								_wPtrRBlocTempTwo := _wPtrRBloc;
								_wMsgListCnt := 0;
								_xTurnaround := TRUE;
							ELSE
								_wPtrRBloc := _wMsgHistListMaxOffsetRB;
								_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
								_actEventClassSel;
								_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
								EXIT;
							END_IF;
						END_IF;
						_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
						_actEventClassSel;
						_wMsgHistListOffsetRB := _wPtrRBlocLastFound;
					END_WHILE;
					_wPtrRBloc := _wPtrRBlocTemp;
				END_IF;
				_xTrigNextMsgHistListPageRB := FALSE;
				_xTrigRefreshHistList := TRUE;
			END_IF;
			IF _xTrigRefreshHistList OR _xRefreshHistListRB OR _xMsgHistListOffsetChRB OR _xMsgHistListEventSelChRB OR _xMsgHistListClassSelChRB THEN
				IF _xRBReady THEN
					_wMsgHistListCntRB := 0;
					_wPtrRBlocTemp := _wPtrRBloc;
					_actLocMOD;
					_wCntSafety := 0;
					_wMsgHistListCntRB := 0;
					//###DK2012Feb06
					WHILE _wMsgHistListCntRB <= MNMSG_MAX_IDX_VCMSGHISTLIST DO
						_LocRB(wPtrWrite := _wPtrRBwrite, wPtrLoc := _wPtrRBloc, wPtrStart := _wPtrRBstart);
						_actEventClassSel;
						_wPtrRBloc := _wPtrRBloc + 1;
						IF (_wPtrRBloc = MNMSG_MAX_MESSAGEHISTORY) THEN
							_wPtrRBloc := _wPtrRBloc MOD UDINT_TO_UINT(MNMSG_MAX_MESSAGEHISTORY);
						END_IF;
						IF _wMsgHistListCntRB > MNMSG_MAX_IDX_VCMSGHISTLIST THEN
							EXIT;
						END_IF;
						_MsgHistListRB[_wMsgHistListCntRB].bEvent := UINT_TO_USINT(_TempHistline.wEvent);
						_MsgHistListRB[_wMsgHistListCntRB].bMsgClass := UINT_TO_USINT(_TempHistline.wMsgClass);
						_utfMsgTextTempFirst := "";
						_utfMsgTextTempSecond := "";
						_utfMsgTextTempThird := "";
						_utfMsgTextTempFourth := "";
						IF SIZEOF(_TempHistline.TimeStampEvent) <= 4 THEN
							_utfMsgTextTempFirst := DT_TO_WSTRING(_TempHistline.TimeStampEvent);
						ELSE
							_utfMsgTextTempFirst := "";
						END_IF;
						IF UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempFirst))) > 3 THEN
							brwcsncpy(ADR(_utfMsgTextTempFirst), (ADR(_utfMsgTextTempFirst) + (2 * 3)), UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempFirst))) - 3);
							brwcsset((ADR(_utfMsgTextTempFirst) + 2 * brwcslen(ADR(_utfMsgTextTempFirst))), 3, WSTRING_TO_UINT(""));
						END_IF;
						_utfMsgTextTempSecond := " ";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := UINT_TO_WSTRING(_TempHistline.wFunction_ID);
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := ".";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := UINT_TO_WSTRING(_TempHistline.wMsgNumber);
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := ".";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := UINT_TO_WSTRING(_TempHistline.wInstance);
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := " ";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_wActFunctionID := _TempHistline.wFunction_ID;
						_wActMsgNumber := _TempHistline.wMsgNumber;
						_wActInstance := _TempHistline.wInstance;
						_actGetTxtFim;
						_MsgHistListRB[_wMsgHistListCntRB].utfMsgText := _utfMsgTextTempFirst;
						IF (_LocRB.wStatus = ERR_OK) AND _xSelOk THEN
							_wMsgHistListCntRB := _wMsgHistListCntRB + 1;
						END_IF;
						IF _wPtrRBloc = _wPtrRBwrite THEN
							EXIT;
						END_IF;
						_wCntSafety := _wCntSafety + 1;
						IF _wCntSafety > MNMSG_MAX_MESSAGEHISTORY THEN
							EXIT;
						END_IF;
					END_WHILE;
					_wPtrRBloc := _wPtrRBlocTemp;
					_wMsgListCnt := _wMsgHistListCntRB;
					WHILE _wMsgListCnt <= MNMSG_MAX_IDX_VCMSGHISTLIST DO
						_MsgHistListRB[_wMsgListCnt].utfMsgText := "";
						_MsgHistListRB[_wMsgListCnt].bMsgClass := 0;
						_MsgHistListRB[_wMsgListCnt].bEvent := 0;
						_wMsgListCnt := _wMsgListCnt + 1;
					END_WHILE;
					//###DK2012Feb06
				END_IF;
				_xTrigRefreshHistList := FALSE;
				_xRefreshHistListRB := FALSE;
				_xMsgHistListOffsetChRB := FALSE;
				_xMsgHistListEventSelChRB := FALSE;
				_xMsgHistListClassSelChRB := FALSE;
			END_IF;
			IFmnMsg.Out.MsgHistList := _MsgHistListRB;
			IFmnMsg.Out.wMsgHistListCnt := _wMsgHistListCntRB;
			IFmnMsg.Out.wMsgHistListOffset := _wMsgHistListOffsetRB;
			IFmnMsg.Out.wMsgHistListMaxOffset := _wMsgHistListMaxOffsetRB;
	
			//###DK2012Jan12
			// Set statistic.
			IF _wPrevMsgStatisticSelect <> IFmnMsg.In.wMsgStatisticSelect THEN
				_wPrevMsgStatisticSelect := IFmnMsg.In.wMsgStatisticSelect;
				_xMsgStatisticSelectChanged := TRUE;
			END_IF;
	
			IF IFmnMsg.Trig.xRefreshStatistic OR _xRefreshStatistic THEN
				_msgStatisticNumShowIdx := _msgStatisticNumIdx;
				_msgStatisticTimeShowIdx := _msgStatisticTimeIdx;
				_wIFMsgStatisticCntNumShow := _wIFMsgStatisticCntNum;
				_wIFMsgStatisticCntTimeShow := _wIFMsgStatisticCntTime;
				IFmnMsg.Trig.xRefreshStatistic := FALSE;
				_xRefreshStatistic := FALSE;
				_xMsgStatisticSelectChanged := TRUE;
			END_IF;
	
			IF _xMsgStatisticSelectChanged THEN
				IF IFmnMsg.In.wMsgStatisticSelect = 0 THEN
					IFmnMsg.Out.wMsgStatisticCnt := _wIFMsgStatisticCntNumShow;
					FOR _wMsgListCnt := 0 TO MNMSG_MAX_IDX_VCMSGSTATLIST BY 1 DO
						_utfMsgTextTempFirst := UINT_TO_WSTRING(_msgStatisticNumShowIdx[_wMsgListCnt].wFunction_ID);
						_utfMsgTextTempSecond := ".";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := UINT_TO_WSTRING(_msgStatisticNumShowIdx[_wMsgListCnt].wMsgNumber);
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := ".";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := UINT_TO_WSTRING(_msgStatisticNumShowIdx[_wMsgListCnt].wInstance);
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := " ";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_wActFunctionID := _msgStatisticNumShowIdx[_wMsgListCnt].wFunction_ID;
						_wActMsgNumber := _msgStatisticNumShowIdx[_wMsgListCnt].wMsgNumber;
						_wActInstance := _msgStatisticNumShowIdx[_wMsgListCnt].wInstance;
						_actGetTxtFim;
						IF NOT((_wActFunctionID = 0) OR (_wActMsgNumber = 0)) THEN
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].lValue := _msgStatisticNumShowIdx[_wMsgListCnt].lValue;
						ELSE
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].utfMsgText := "";
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].lValue := 0;
						END_IF;
					END_FOR;
				END_IF;
				IF IFmnMsg.In.wMsgStatisticSelect = 1 THEN
					IFmnMsg.Out.wMsgStatisticCnt := _wIFMsgStatisticCntTimeShow;
					FOR _wMsgListCnt := 0 TO MNMSG_MAX_IDX_VCMSGSTATLIST BY 1 DO
						_utfMsgTextTempFirst := UINT_TO_WSTRING(_msgStatisticTimeShowIdx[_wMsgListCnt].wFunction_ID);
						_utfMsgTextTempSecond := ".";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := UINT_TO_WSTRING(_msgStatisticTimeShowIdx[_wMsgListCnt].wMsgNumber);
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := ".";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := UINT_TO_WSTRING(_msgStatisticTimeShowIdx[_wMsgListCnt].wInstance);
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_utfMsgTextTempSecond := " ";
						brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
						UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
						_wActFunctionID := _msgStatisticTimeShowIdx[_wMsgListCnt].wFunction_ID;
						_wActMsgNumber := _msgStatisticTimeShowIdx[_wMsgListCnt].wMsgNumber;
						_wActInstance := _msgStatisticTimeShowIdx[_wMsgListCnt].wInstance;
						_actGetTxtFim;
						IF NOT ((_wActFunctionID = 0) OR (_wActMsgNumber = 0)) THEN
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].utfMsgText := _utfMsgTextTempFirst;
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].lValue := _msgStatisticTimeShowIdx[_wMsgListCnt].lValue;
						ELSE
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].utfMsgText := "";
							IFmnMsg.Out.MsgStatistic[_wMsgListCnt].lValue := 0;
						END_IF;
					END_FOR;
				END_IF;
				_xMsgStatisticSelectChanged := FALSE;
			END_IF;
			//###DK2012Jan12
			
		END_IF
		

	ELSE	// _Plausibility.xOK

		// Horning for 500ms. After it has finished it will start again ten seconds later.
		_tonCrit1(IN := NOT _tonCrit2.Q, PT := T#500ms);
		_tonCrit2(IN := _tonCrit1.Q, PT := T#10s);
	
		IFmnMsg.Out.bHorn := SEL(NOT _tonCrit1.Q, 0, 1);	// Causes some horning now.
		
		IFmnMsg.Out.bLight := 1;

		// Meldung setzen
			
		IF _xNotOkFirstScan THEN
		
			_xNotOkFirstScan := FALSE;

			// Meldungsliste füllen
		
			brsmemset (ADR(mnMsgStatAd.Msg), 0, SIZEOF (mnMsgStatAd.Msg));

			_InsertMsgLine.AdrIntFaultList := ADR(mnMsgStatAd.Msg.MsgListFaultInt);
			_InsertMsgLine.AdrCntIntFault := ADR(mnMsgStatAd.Msg.MsgCntFaultInt);

			_dtHelp(enable := TRUE);
			
			_InsertMsgLine.Class := MNMSG_CLASS_INTFAULT;
			_InsertMsgLine.Insert := TRUE;
			_InsertMsgLine.MsgLine.bAckLevel := MNMSG_CLASS_NO_ACK;
			_InsertMsgLine.MsgLine.bInstance := 0;
			_InsertMsgLine.MsgLine.diAttr1 := 0;
			_InsertMsgLine.MsgLine.wFunction_ID := 2;
			_InsertMsgLine.MsgLine.wMsgNumber := MNMSG_MSG_SYSTEMFAULT;
			_InsertMsgLine.MsgLine.TimeStamp := _dtHelp.DT1;
			_InsertMsgLine();

			mnMsgStatAd.Msg.dtMsgIntFaultChanged := _dtHelp.DT1;

		END_IF
		
	END_IF;	// IFmnMsg.Out.xMnMsgReady 

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	_LastExecute(enable := TRUE);
	_dtLastExecute := _LastExecute.DT1;

END_PROGRAM