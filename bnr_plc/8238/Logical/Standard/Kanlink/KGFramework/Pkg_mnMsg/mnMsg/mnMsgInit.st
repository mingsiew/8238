(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: mnMsgInit.st
 * Author: subramaniam/hunholz
 * Created: January 28, 2011
 * Changed: October 20, 2011 by A. Hunholz
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************
*)
PROGRAM _INIT

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'mnMsg';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnMsgStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnMsgStatAd.sPkgVersion := '---';
		
	END_IF

	//********************Startoption der Plausibilitaetspruefung**********************
	//____________________________________________________________

	// Initialisierung von (Zaehl)variablen und Booleans
	_xMsgStatisticNumFirstEntry 	:= TRUE;
	_xMsgStatisticWriteNum 			:= TRUE;
	_xMsgStatisticTimeFirstEntry 	:= TRUE;
	_xMsgStatisticWriteTime 		:= TRUE;
	_xFirstElementToInsertTime 		:= TRUE;
	_xFirstElementToInsertNum 		:= TRUE;
	
	// Filter setzen
	IFmnMsg.In.wMsgHistListClassSelect.0 := 1;
	IFmnMsg.In.wMsgHistListClassSelect.1 := 1;
	IFmnMsg.In.wMsgHistListClassSelect.2 := 1;
	IFmnMsg.In.wMsgHistListClassSelect.3 := 1;

	_EventStatisticDelStep := Del_Wait;

	//*********************Synchrone Schnittstelle zurücksetzen*****************************

	brsmemset(ADR(IFmnMsg.Out),0,SIZEOF(IFmnMsg.Out));
	brsmemset (ADR (kgMsgStatus[MNMSG_IDX_KGMSGSTAT]), 0, SIZEOF (kgMsgStatus[0])); 

	//*********************Alle Listen loeschen

	brsmemset (ADR(_MsgImage), 0, SIZEOF (_MsgImage));	// Meldungsabbild
	brsmemset (ADR(_MsgImageState),0,SIZEOF(_MsgImageState));	// Meldungsabbild

	brsmemset (ADR(mnMsgStatAd.Msg), 0 ,SIZEOF (mnMsgStatAd.Msg));
	
	//****************************************************************************************************************
	// Log erzeugen
	//****************************************************************************************************************

	_kgArLogWrite.enable := TRUE;
	_kgArLogWrite.ident := 0;
	_kgArLogWrite.errornr := 50001;
		
	_AsArLogCreate(enable := TRUE, pName := ADR('mnMsgL'), len := 4096, memType := arlogUSRROM);
		
	IF _AsArLogCreate.status = ERR_OK THEN
			
		_kgArLogWrite.ident := _AsArLogCreate.ident;
			
	ELSIF _AsArLogCreate.status = arlogERR_EXISTING THEN
			
		_AsArLogGetInfo(enable := TRUE, pName := ADR('mnMsgL'));

		IF _AsArLogGetInfo.status = ERR_OK THEN
				
			_kgArLogWrite.ident := _AsArLogGetInfo.ident;
				
		END_IF
			
	END_IF
	
	//***************** Datenobjekte prüfen
	//______________________________

	// Unbedingtes REPEAT, damit bei Fehler alles Andere per EXIT 
	// übersprungen werden kann.
	
	REPEAT
		
		//*************** KONFIGURATION 
		//**************************************
		// _doInfoCfg 'Bild der Konfigurationsdatei' of DatObjInfo
		
		_doInfoCfg.enable := TRUE;	// VAR_INPUT BOOL enable 'enables execution'
		_doInfoCfg.pName := ADR('CfgMsgStat');	// VAR_INPUT UDINT pName 'name of data object'
		_doInfoCfg();	
		
		IF _doInfoCfg.status <> ERR_OK THEN

			_kgArLogWrite.logLevel := arlogLEVEL_INFO;
			_kgArLogWrite.text := 'Messageconfiguration does not exist: {##AttrVar1}';
			_kgArLogWrite.var1 := _doInfoCfg.status;
			_kgArLogWrite.var2 := 0;
			_kgArLogWrite();
			EXIT;
			
		ELSE

			// _doInfoCfg 'Bild der Konfigurationsdatei' of DatObjInfo
			// wCntCfg of Plausib_Typ: number of configuration entries
			_Plausibility.dCfgLen := _doInfoCfg.len; // VAR_OUTPUT UDINT len 'length of the data area in the data object'
			_Plausibility.dCfgMem := _doInfoCfg.pDatObjMem; // VAR_OUTPUT UDINT pDatObjMem 'pointer to the data in the data object'
			_Plausibility.wCfgCnt := UDINT_TO_UINT((_doInfoCfg.len-SIZEOF(UINT))/SIZEOF (MsgCfgLine_Typ)); // Laenge der Version zu Beginn abziehen
			
			_wVersion ACCESS _Plausibility.dCfgMem;
			_Plausibility.wCfgVersion := _wVersion;

			IF _Plausibility.wCfgCnt > MNMSG_MAX_CFGMESSAGES THEN
				
				_kgArLogWrite.logLevel := arlogLEVEL_INFO;
				_kgArLogWrite.text := 'To much entries in Messageconfiguration: {##AttrVar1}';
				_kgArLogWrite.var1 := _Plausibility.wCfgCnt;
				_kgArLogWrite.var2 := 0;
				_kgArLogWrite();
				EXIT;

			END_IF

			// Zugriff auf die Konfigurationszeilen
			_MsgCfgList ACCESS _doInfoCfg.pDatObjMem + SIZEOF(UINT); // Offset Versionsnummer

			// Binäre Suche initialisieren
			_BinSearchCfg.MsgCfgList := _doInfoCfg.pDatObjMem + SIZEOF(UINT);	// Offset Versionsnummer
			_BinSearchCfg.wCntMsgCfg := _Plausibility.wCfgCnt;	// VAR_INPUT UINT wCntMsgCfg

		END_IF


		//*****************************
		// STATISTIK
		//*****************************

		_kgCheckStat(Enable := TRUE, pName := ADR('_MsgStat'), MinLen := SIZEOF(_MsgStatList), NomLen := SIZEOF(_MsgStatList), Create := TRUE, MemType := doUSRROM);

		IF _kgCheckStat.Status = ERR_OK OR _kgCheckStat.Status = KG_INFO_DO_NEW THEN
			
			_doWriteStat.enable := TRUE;
			_doWriteStat.ident := _kgCheckStat.doId;
			
			IF _kgCheckStat.Status = KG_INFO_DO_NEW THEN

				// Kopfdaten schreiben
				_StatHeader.lVersion := _Plausibility.wCfgVersion;	
				_StatHeader.lLength :=  UINT_TO_UDINT(MNMSG_MAX_CFGMESSAGES);

				_doWriteStat.Offset := 0;	
				_doWriteStat.len := SIZEOF(_StatHeader);	
				_doWriteStat.pSource := ADR(_StatHeader);	
				_doWriteStat();

				IF _doWriteStat.status = ERR_OK THEN
				
					_xStatReady := TRUE;
					_MsgStatList ACCESS _kgCheckStat.doMem;

					_kgArLogWrite.logLevel := arlogLEVEL_INFO;
					_kgArLogWrite.text := 'Statistic created!';
					_kgArLogWrite.var1 := 0;
					_kgArLogWrite.var2 := 0;
					_kgArLogWrite();

				ELSE
				
					_kgArLogWrite.logLevel := arlogLEVEL_INFO;
					_kgArLogWrite.text := 'Write Statistic: {##AttrVar1}';
					_kgArLogWrite.var1 := _doWriteStat.status;
					_kgArLogWrite.var2 := 0;
					_kgArLogWrite();

				END_IF

			ELSE
				
				brsmemcpy(ADR(_StatHeader), _kgCheckStat.doMem, SIZEOF(_StatHeader));
				
				IF _StatHeader.lVersion <> _Plausibility.wCfgVersion THEN
					
					//Konfigurationsversion hat sich geändert --> Statistik neu erstellen
					
					_doDeleteStat(enable := TRUE, ident := _kgCheckStat.doId);
					
					_kgCheckStat(Enable := TRUE, pName := ADR('_MsgStat'), MinLen := SIZEOF(_MsgStatList), NomLen := SIZEOF(_MsgStatList), Create := TRUE, MemType := doUSRROM);

					IF _kgCheckStat.Status = KG_INFO_DO_NEW THEN
			
						_doWriteStat.enable := TRUE;
						_doWriteStat.ident := _kgCheckStat.doId;

						// Kopfdaten schreiben
						_StatHeader.lVersion := _Plausibility.wCfgVersion;	
						_StatHeader.lLength :=  UINT_TO_UDINT(MNMSG_MAX_CFGMESSAGES);

						_doWriteStat.Offset := 0;	
						_doWriteStat.len := SIZEOF(_StatHeader);	
						_doWriteStat.pSource := ADR(_StatHeader);	
						_doWriteStat();

						IF _doWriteStat.status = ERR_OK THEN
				
							_xStatReady := TRUE;
							_MsgStatList ACCESS _kgCheckStat.doMem;

							_kgArLogWrite.logLevel := arlogLEVEL_INFO;
							_kgArLogWrite.text := 'Statistic recreated!';
							_kgArLogWrite.var1 := 0;
							_kgArLogWrite.var2 := 0;
							_kgArLogWrite();

						ELSE
				
							_kgArLogWrite.logLevel := arlogLEVEL_INFO;
							_kgArLogWrite.text := 'Write Statistic*: {##AttrVar1}';
							_kgArLogWrite.var1 := _doWriteStat.status;
							_kgArLogWrite.var2 := 0;
							_kgArLogWrite();

						END_IF

					ELSE

						_kgArLogWrite.logLevel := arlogLEVEL_INFO;
						_kgArLogWrite.text := 'Check Statistic*: {##AttrVar1}';
						_kgArLogWrite.var1 := _kgCheckStat.Status;
						_kgArLogWrite.var2 := 0;
						_kgArLogWrite();

					END_IF
				
				ELSE //IF _StatHeader.lVersion <> _Plausibility.wCfgVersion THEN
					
					// Version ist OK
					_xStatReady := TRUE;
					_MsgStatList ACCESS _kgCheckStat.doMem;

				END_IF
				
			END_IF
			
		ELSE
			
			_kgArLogWrite.logLevel := arlogLEVEL_INFO;
			_kgArLogWrite.text := 'Check Statistic: {##AttrVar1}';
			_kgArLogWrite.var1 := _kgCheckStat.Status;
			_kgArLogWrite.var2 := 0;
			_kgArLogWrite();
			
		END_IF
		

		//*************** RINGBUFFER
		//*********************************
		
		_kgCheckHist(Enable := TRUE, pName := ADR('_MsgRB'), MinLen :=  MNMSG_MAX_MESSAGEHISTORY * SIZEOF(MsgHistList_Typ), NomLen :=  MNMSG_MAX_MESSAGEHISTORY * SIZEOF(MsgHistList_Typ), Create := TRUE, MemType := doUSRROM);

		IF _kgCheckHist.Status = ERR_OK OR _kgCheckHist.Status = KG_INFO_DO_NEW THEN

			IF _kgCheckHist.Status = KG_INFO_DO_NEW THEN

				_kgArLogWrite.logLevel := arlogLEVEL_INFO;
				_kgArLogWrite.text := 'History created!';
				_kgArLogWrite.var1 := 0;
				_kgArLogWrite.var2 := 0;
				_kgArLogWrite();

				_wPtrRBwrite := 0;
				_wPtrRBread := 0;
				_wPtrRBloc := 0;

			END_IF

			_xRBReady := TRUE;

			// _InsertRB of msgInsertRB 'Eintrag in den Ringbuffer'
			_InsertRB.doIdent := _kgCheckHist.doId;
			_InsertRB.doLen := _kgCheckHist.doLen;
		
			_ReadRB.doIdent := _kgCheckHist.doId;
			_ReadRB.doLen := _kgCheckHist.doLen;
					
			_LocRB.doIdent := _kgCheckHist.doId;
			_LocRB.doLen := _kgCheckHist.doLen;
			
			_DebugHistory ACCESS _kgCheckHist.doMem;

		ELSE
			
			_kgArLogWrite.logLevel := arlogLEVEL_INFO;
			_kgArLogWrite.text := 'Check History: {##AttrVar1}';
			_kgArLogWrite.var1 := _kgCheckStat.Status;
			_kgArLogWrite.var2 := 0;
			_kgArLogWrite();
			
		END_IF
		
		_Plausibility.xOK := TRUE;
		
		//***********************************************************************************
		// Statistik für Werte vor dem letzten Ausschalten schreiben, um dann die
		// Statistik zurücksetzen zu können
		//***********************************************************************************

		IF _xRBReady THEN

			FOR _wMsgIdx := 1 TO _Plausibility.wCfgCnt DO
			
				IF _MsgImageTime[_wMsgIdx].dtTimeStamp <> DT#1970-01-01-00:00:00  THEN
				
					// Es steht noch eine Zeit im Image, die noch nicht erfasst wurde
					// D.h. beim Ausschalten der SPS stand diese Meldung noch an.
				
					_lTime := 0;
					
					IF _xStatReady THEN
					
						// Statistik schreiben
						IF (_dtLastExecute >= _MsgImageTime[_wMsgIdx].dtTimeStamp) THEN
							_lTime := DiffDT(_dtLastExecute, _MsgImageTime[_wMsgIdx].dtTimeStamp);
						END_IF
						
						_StatLine.lTime := _MsgStatList.List[_wMsgIdx].lTime + _lTime;
						_StatLine.lCnt := _MsgStatList.List[_wMsgIdx].lCnt + 1;
						_StatLine.wFunction_ID := _MsgCfgList[_wMsgIdx].wFunction_ID;
						_StatLine.wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
						_StatLine.wInstance := _MsgCfgList[_wMsgIdx].wInstance;
						_StatLine.wMsgClass := _MsgStatList.List[_wMsgIdx].wMsgClass;

						_doWriteStat.Offset := SIZEOF(_StatHeader) + (_wMsgIdx-1)*SIZEOF(_StatLine);
						_doWriteStat.len := SIZEOF(_StatLine);
						_doWriteStat.pSource := ADR(_StatLine);

						_doWriteStat();

					END_IF
				
					// Ringbuffer schreiben
					_TempHistline.TimeStampEvent := _dtLastExecute;
					_TempHistline.wFunction_ID := _MsgCfgList[_wMsgIdx].wFunction_ID;
					_TempHistline.wInstance := _MsgCfgList[_wMsgIdx].wInstance;
					_TempHistline.wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
					IF _xStatReady THEN
						_TempHistline.wMsgClass := _MsgStatList.List[_wMsgIdx].wMsgClass;
					ELSE
						_TempHistline.wMsgClass := MNMSG_CLASS_INFO;
					END_IF
					_TempHistline.diAttr1 := 0;
					_TempHistline.diAttr2 := 0;
					_TempHistline.sAttrTxt := '';
					_TempHistline.wEvent := MNMSG_EVENT_GONE;	// Constant of library KGlibMMsg UINT MSG_EVENT_GONE = 3
					_TempHistline.lTime := _lTime;

					_InsertRB.pEntry := ADR(_TempHistline);
					_InsertRB.lLenEntry := SIZEOF(_TempHistline);
					_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart); 

					IF _InsertRB.wStatus <> ERR_OK THEN
						_kgArLogWrite.logLevel := arlogLEVEL_INFO;
						_kgArLogWrite.text := 'Inster History: {##AttrVar1}';
						_kgArLogWrite.var1 := _InsertRB.wStatus;
						_kgArLogWrite.var2 := 0;
						_kgArLogWrite();
					END_IF
					
				END_IF
			
			END_FOR

		END_IF
		
		// Nachdem das Image in die Statistik und in den Ringbuffer geschrieben wurde,
		// kann es auf Null zurückgesetzt werden
		brsmemset(ADR(_MsgImageTime),0,SIZEOF(_MsgImageTime));

		UNTIL

		TRUE

	END_REPEAT;

	_dtHelp(enable := TRUE);

	_xStatFault := NOT _xStatReady;
	
	_xNotOkFirstScan := TRUE;

END_PROGRAM
