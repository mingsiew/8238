(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTxt
 * File: mnTxtInit.st
 * Author: hunholz
 * Created: November 25, 2011
 ********************************************************************
 * Implementation of program mnTxt
 ********************************************************************)

PROGRAM _INIT

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'mnTxt';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnTxtStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnTxtStatAd.sPkgVersion := '---';
		
	END_IF
	
	
	
	brsmemset(ADR(IFmnTxt.Out), 0, SIZEOF(IFmnTxt.Out));
	
	IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_INIT;
	
	REPEAT
		
		//===================================
		// Speicher zum Parsen bereitstellen
		//===================================
		
		// Bedarf berechnen
		
		_lLineMem := (((SIZEOF(_plLineAdress) + SIZEOF(_pwLineLen)) / 8) + 2 ) * 8;

		_lLineMem := _lLineMem + ((MNTXT_TEMPREADCSVSIZE / 8) + 2) * 8;
		
		_lLineMem := _lLineMem + 1000;

		_MemPartCreate(enable := TRUE, len := _lLineMem);

		IF _MemPartCreate.status <> ERR_OK THEN

			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMEM;
			EXIT;
			
		END_IF

		// Zeilenadresstabelle
		_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(_plLineAdress) + SIZEOF(_pwLineLen) );
		
		IF _MemPartAlloc.status <> ERR_OK THEN
			
			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMEM;
			EXIT;

		END_IF		

		_lAdrLineAdress := _MemPartAlloc.mem;
		_plLineAdress ACCESS _lAdrLineAdress;
		
		_lAdrLineLen := _lAdrLineAdress + SIZEOF(_plLineAdress);
		_pwLineLen ACCESS _lAdrLineLen;
		
		//LCID_Tabelle einlesen
		
		_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR('Language\lcid.csv'), pInfo := ADR(_fiFileInfo));
		
		IF _FileInfo.status <> ERR_OK THEN
			
			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRLCID;
			EXIT;

		END_IF		
			
		_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _fiFileInfo.size-SIZEOF(KGBOM) );
		
		IF _MemPartAlloc.status <> ERR_OK THEN
			
			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMEM;
			EXIT;

		END_IF		
		
		_lAdrFile := _MemPartAlloc.mem;

		_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR('Language\lcid.csv'), mode := fiREAD_ONLY);
		
		IF _FileOpen.status <> ERR_OK THEN
			
			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRLCID;
			EXIT;

		END_IF		
		
		_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _lAdrFile, len :=  _fiFileInfo.size-SIZEOF(KGBOM) ) ;

		_FileClose(enable := TRUE, ident := _FileOpen.ident);
		
		IF _FileRead.status <> ERR_OK THEN
			
			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRLCID;
			EXIT;

		END_IF		
		
		// Zeilen in der Datei zählen und Startadressen ermitteln
		
		_CountLines.enable := TRUE;
		_CountLines.pFile := _lAdrFile;
		_CountLines.FileSize := _fiFileInfo.size - SIZEOF(KGBOM);
		_CountLines.MaxLines := MNTXT_MAXPARSELINES;
		_CountLines.pAdresses := _lAdrLineAdress;
		_CountLines.pLens := _lAdrLineLen;
		
		_CountLines();
		
		IF _CountLines.status <> ERR_OK THEN
			
			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRLCID;
			EXIT;

		END_IF		

		// Zeilen auslesen und LCID-Werte ermitteln
		
		_xGermanExist := FALSE;
		_wStartLine := 1;
		_wIdxLCID := 0;
		_GetCsvDat.enable := TRUE;
		
		REPEAT
			
			brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
			_GetCsvDat();
			_wStartLine := _wStartLine + 1;
			
			IF _GetCsvDat.RowType = 248 AND _GetCsvDat.CsvLCIDrow.LCID > 0 THEN
				
				IFmnTxt.Out.wLCIDs[_wIdxLCID] := _GetCsvDat.CsvLCIDrow.LCID;
				_wIdxLCID := _wIdxLCID + 1;
				
				IF _GetCsvDat.CsvLCIDrow.LCID = MNTXT_LCID_GERMAN THEN
					_xGermanExist := TRUE;
				END_IF
			
			END_IF
			
			UNTIL
			_wIdxLCID > MNTXT_MAX_IDX_LCID OR _wStartLine > _CountLines.CntLines
		END_REPEAT

		IFmnTxt.Out.wCntLCID := _wIdxLCID;
		
		_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _lAdrFile);
		
		IF IFmnTxt.Out.wCntLCID = 0 THEN

			IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRLCID;
			EXIT;
			
		END_IF
		
		//##############################################################################

		IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_NOLANGUAGE;
		
		_initState := _is_checkFunctionTxt;
		_xInitOK := FALSE;
		_xInitDone := FALSE;
		
		UNTIL
		TRUE
	END_REPEAT
	
	REPEAT
		
		CASE _initState OF
			
			// Datenobjekte für Funktionstexte prüfen und ggf. anlegen
			_is_checkFunctionTxt:
				
				IFmnTxt.Out.ptrFunctionTxtList := 0;
				IFmnTxt.Out.wCntFunctionTxt := 0;
				
				_lLenFuncTxt := SIZEOF(_TxtLine)*(MNTXT_MAX_IDX_TXT_FUNCTION+1);
				
				IF MNTXT_LOAD_FUNCTIONTEXT THEN
					
					_CheckDoFunc(Enable := TRUE, pName := ADR(MNTXT_DATOBJNAME_FUNTXT), MinLen := _lLenFuncTxt, NomLen := _lLenFuncTxt, Create := TRUE, MemType := doUSRROM);
					
					IF _CheckDoFunc.Status <> ERR_FUB_BUSY THEN

						// DO mit Templatetexten füllen, wenn es neu angelegt wurde

						IF _CheckDoFunc.Status = KG_INFO_DO_NEW OR _CheckDoFunc.Status = ERR_OK THEN

							_debFunctionTxtList ACCESS _CheckDoFunc.doMem;
							
							IFmnTxt.Out.ptrFunctionTxtList := _CheckDoFunc.doMem;
							
							IF _CheckDoFunc.Status = KG_INFO_DO_NEW THEN
								
								_initState := _is_writeFunctionTxt;
								_ii := 0;

							ELSE	

								_initState := _is_checkInstanceTxt;	
								
							END_IF

						ELSE
							
							_xInitDone := TRUE;
							IFmnTxt.Out.wSelectLanguageStatus := _CheckDoFunc.Status;

						END_IF
						
					END_IF
					
				ELSE

					_initState := _is_checkInstanceTxt;	

				END_IF
			
			_is_writeFunctionTxt:

				REPEAT
					
					_TxtLine.wNumber 		:= _ii;
					_TxtLine.wFunctionID 	:= _ii;
					_TxtLine.utfText		:= "Function";
					_utfNo					:= UINT_TO_WSTRING(_ii);
					brwcscat(ADR(_TxtLine.utfText), ADR(_utfNo));
					
					_dowFuncTxt(enable := TRUE, ident := _CheckDoFunc.doId, Offset := SIZEOF(_TxtLine)*_ii, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));
					
					IF _dowFuncTxt.status <> ERR_OK THEN
	
						IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRDATOBJ;
						_xInitDone := TRUE;
						EXIT;
						
					END_IF
				
					_ii := _ii + 1;
					
					UNTIL
					((_ii MOD 10) = 0) OR _ii > MNTXT_MAX_IDX_TXT_FUNCTION
				END_REPEAT
			
				IF _ii > MNTXT_MAX_IDX_TXT_FUNCTION THEN
					
					_initState := _is_checkInstanceTxt;
					
				END_IF
			
			// Datenobjekte für Instanztexte prüfen und ggf. anlegen
			_is_checkInstanceTxt:
				
				IFmnTxt.Out.ptrInstanceTxtList := 0;
				IFmnTxt.Out.wCntInstanceTxt		:= 0;
				
				_lLenInstTxt := SIZEOF(_TxtLine)*(MNTXT_MAX_IDX_TXT_INSTANCE + 1);
				
				IF MNTXT_LOAD_INSTANCETEXT THEN
					
					_CheckDoInst(Enable := TRUE, pName := ADR(MNTXT_DATOBJNAME_INSTXT), MinLen := _lLenInstTxt, NomLen := _lLenInstTxt, Create := TRUE, MemType := doUSRROM);
					
					IF _CheckDoInst.Status <> ERR_FUB_BUSY THEN

						// DO mit Templatetexten füllen, wenn es neu angelegt wurde

						IF _CheckDoInst.Status = KG_INFO_DO_NEW OR _CheckDoInst.Status = ERR_OK THEN

							IFmnTxt.Out.ptrInstanceTxtList := _CheckDoInst.doMem;
							
							_debInstanceTxtList ACCESS _CheckDoInst.doMem;

							IF _CheckDoInst.Status = KG_INFO_DO_NEW THEN
							
								_ii := 0;
								_initState := _is_writeInstanceTxt;
								
							ELSE	

								_initState := _is_checkParTxt;	

							END_IF

						ELSE	
							
							IFmnTxt.Out.wSelectLanguageStatus := _CheckDoInst.Status;
							_xInitDone := TRUE;
							
						END_IF
						
					END_IF
					
				ELSE

					_initState := _is_checkParTxt;	

				END_IF

			_is_writeInstanceTxt:
			

				REPEAT
					
					_TxtLine.wNumber 		:= _ii;
					_TxtLine.wFunctionID 	:= _ii;
					_TxtLine.utfText		:= "Instance";
					_utfNo					:= UINT_TO_WSTRING(_ii);
					brwcscat(ADR(_TxtLine.utfText), ADR(_utfNo));
				
					_dowInstTxt(enable := TRUE, ident := _CheckDoInst.doId, Offset := SIZEOF(_TxtLine)*_ii, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));
				
					IF _dowInstTxt.status <> ERR_OK THEN

						IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRDATOBJ;
						_xInitDone := TRUE;
						EXIT;
					
					END_IF
					
					_ii := _ii + 1;
					
					UNTIL
					((_ii MOD 10) = 0) OR _ii > MNTXT_MAX_IDX_TXT_INSTANCE
				END_REPEAT
			
				IF _ii > MNTXT_MAX_IDX_TXT_INSTANCE THEN
					
					_initState := _is_checkParTxt;
					
				END_IF

			
			// Datenobjekte für Parametertexte prüfen und ggf. anlegen
			_is_checkParTxt:

				IFmnTxt.Out.ptrParamTxtList := 0;
				IFmnTxt.Out.wCntParamTxt := 0;
				
				_lLenParTxt := SIZEOF(_TxtLine)*(MNTXT_MAX_IDX_TXT_PARAMETER + 1);
				
				IF MNTXT_LOAD_PARAMETERTEXT THEN
					
					_CheckDoPar(Enable := TRUE, pName := ADR(MNTXT_DATOBJNAME_PARTXT), MinLen := _lLenParTxt, NomLen := _lLenParTxt, Create := TRUE, MemType := doUSRROM);
					
					IF _CheckDoPar.Status <> ERR_FUB_BUSY THEN

						// DO mit Templatetexten füllen, wenn es neu angelegt wurde

						IF _CheckDoPar.Status = KG_INFO_DO_NEW OR _CheckDoPar.Status = ERR_OK THEN

							_debParameterTxtList ACCESS _CheckDoPar.doMem;
							
							IFmnTxt.Out.ptrParamTxtList := _CheckDoPar.doMem;

							IF _CheckDoPar.Status = KG_INFO_DO_NEW THEN
							
								_ii := 0;
								_initState := _is_writeParTxt;
								
							ELSE
								
								_initState := _is_checkParHlpTxt;

							END_IF

						ELSE	
							
							IFmnTxt.Out.wSelectLanguageStatus := _CheckDoPar.Status;
							_xInitDone := TRUE;
							
						END_IF
						
					END_IF
					
				ELSE

					_initState := _is_checkParHlpTxt;	

				END_IF

			_is_writeParTxt:

				REPEAT

					_TxtLine.wNumber 		:= _ii;
					_TxtLine.wFunctionID 	:= _ii;
					_TxtLine.utfText		:= "Parameter";
					_utfNo					:= UINT_TO_WSTRING(_ii);
					brwcscat(ADR(_TxtLine.utfText), ADR(_utfNo));
				
					_dowParTxt(enable := TRUE, ident := _CheckDoPar.doId, Offset := SIZEOF(_TxtLine)*_ii, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));
				
					IF _dowParTxt.status <> ERR_OK THEN

						IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRDATOBJ;
						_xInitDone := TRUE;
						EXIT;
					
					END_IF
					
					_ii := _ii + 1;
					
					UNTIL
					((_ii MOD 10) = 0) OR _ii > MNTXT_MAX_IDX_TXT_PARAMETER
				END_REPEAT
			
				IF _ii > MNTXT_MAX_IDX_TXT_PARAMETER THEN
					
					_initState := _is_checkParHlpTxt;
					
				END_IF

			// Datenobjekte für Parameterhilfstexte prüfen und ggf. anlegen
			_is_checkParHlpTxt:
				
				IFmnTxt.Out.ptrParamHelpTxtList := 0;
				IFmnTxt.Out.wCntParamHlpTxt := 0;

				_lLenParHlpTxt := SIZEOF(_TxtHelpLine)*(MNTXT_MAX_IDX_TXT_PARAMETER + 1);
				
				IF MNTXT_LOAD_PARAMTERHELPTEXT THEN
					
					_CheckDoParHlp(Enable := TRUE, pName := ADR(MNTXT_DATOBJNAME_PARHELPTXT), MinLen := _lLenParHlpTxt, NomLen := _lLenParHlpTxt, Create := TRUE, MemType := doUSRROM);
					
					IF _CheckDoParHlp.Status <> ERR_FUB_BUSY THEN

						// DO mit Templatetexten füllen, wenn es neu angelegt wurde

						IF _CheckDoParHlp.Status = KG_INFO_DO_NEW OR _CheckDoParHlp.Status = ERR_OK THEN

							_debParameterHlpTxtList ACCESS _CheckDoParHlp.doMem;

							IFmnTxt.Out.ptrParamHelpTxtList := _CheckDoParHlp.doMem;

							IF _CheckDoParHlp.Status = KG_INFO_DO_NEW THEN

								_ii := 0;
								_initState := _is_writeParHlpTxt;
								
							ELSE
								
								_initState := _is_checkMsgCnt;	

							END_IF

						ELSE	
							
							IFmnTxt.Out.wSelectLanguageStatus := _CheckDoParHlp.Status;
							_xInitDone := TRUE;
							
						END_IF
						
					END_IF
					
				ELSE

					_initState := _is_checkMsgCnt;	

				END_IF

			_is_writeParHlpTxt:
			
				REPEAT

					_TxtHelpLine.wNumber 		:= _ii;
					_TxtHelpLine.wFunctionID 	:= _ii;
					_TxtHelpLine.utfText		:= "Parameter Help";
					_utfNo						:= UINT_TO_WSTRING(_ii);
					brwcscat(ADR(_TxtHelpLine.utfText), ADR(_utfNo));
				
					_dowParHlpTxt(enable := TRUE, ident := _CheckDoParHlp.doId, Offset := SIZEOF(_TxtHelpLine)*_ii, pSource := ADR(_TxtHelpLine), len := SIZEOF(_TxtHelpLine));
				
					IF _dowParHlpTxt.status <> ERR_OK THEN

						IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRDATOBJ;
						_xInitDone := TRUE;
						EXIT;
					
					END_IF
					
					_ii := _ii + 1;

					UNTIL
					((_ii MOD 10) =0) OR _ii > MNTXT_MAX_IDX_TXT_PARAMETER
				END_REPEAT
			
				IF _ii > MNTXT_MAX_IDX_TXT_PARAMETER THEN
					
					_initState := _is_checkMsgCnt;
					
				END_IF

			// Anzahl Meldungen ermitteln
			_is_checkMsgCnt:

				REPEAT 
				
					_doiMsgCfg(enable := TRUE, pName := ADR('CfgMsgStat'));
				
					IF _doiMsgCfg.status <> ERR_OK THEN
					
						IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMSGCFG;
						_xInitDone := TRUE;
						EXIT;
					
					END_IF
		
					IF _doiMsgCfg.len < 2 THEN
					
						IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMSGCFG;
						_xInitDone := TRUE;
						EXIT;
					
					END_IF
		
					_MsgCfgList ACCESS _doiMsgCfg.pDatObjMem + 2;
		
					_lLenMsg := (_doiMsgCfg.len-2) / SIZEOF(_MsgCfgList[0]);
					
					_initState := _is_checkMsgTxt;

					UNTIL
					TRUE

				END_REPEAT
			
			// Datenobjekte für Meldungstexte prüfen und ggf. anlegen
			_is_checkMsgTxt:
				
				// Referenz auf die Meldungskonfiguration holen und Anzahl der möglichen Meldungen
				// ermitteln

				IFmnTxt.Out.ptrMessageTxtList := 0;
				IFmnTxt.Out.wCntMessageTxt := 0;
				
				_lLenMsgTxt := SIZEOF(_TxtLine)* _lLenMsg;
	
				_CheckDoMsg(Enable := TRUE, pName := ADR(MNTXT_DATOBJNAME_MSGTXT), MinLen := _lLenMsgTxt, NomLen := _lLenMsgTxt, Create := TRUE, MemType := doUSRROM);
					
				IF _CheckDoMsg.Status <> ERR_FUB_BUSY THEN

					// DO mit Templatetexten füllen, wenn es neu angelegt wurde
					IF _CheckDoMsg.Status = KG_INFO_DO_NEW OR _CheckDoMsg.Status = ERR_OK THEN

						_debMessageTxtList ACCESS _CheckDoMsg.doMem;

						IFmnTxt.Out.ptrMessageTxtList := _CheckDoMsg.doMem;
						IFmnTxt.Out.wCntMessageTxt := UDINT_TO_UINT(_lLenMsg);

						_ii := 0;
						
						_initState := _is_writeMsgTxt;

					ELSE	
							
						IFmnTxt.Out.wSelectLanguageStatus := _CheckDoMsg.Status;
						_xInitDone := TRUE;
							
					END_IF
					
				END_IF

			_is_writeMsgTxt:
			
				IF _CheckDoMsg.Status = KG_INFO_DO_NEW AND _lLenMsg > 0 THEN

					REPEAT

						_TxtLine.wNumber 		:= _MsgCfgList[_ii].wMsgNumber;
						_TxtLine.wFunctionID 	:= _MsgCfgList[_ii].wFunction_ID;
						_TxtLine.wInstance		:= _MsgCfgList[_ii].wInstance;
						_TxtLine.utfText		:= "Message";
						_utfNo					:= UINT_TO_WSTRING(_MsgCfgList[_ii].wMsgNumber);
						brwcscat(ADR(_TxtLine.utfText), ADR(_utfNo));
				
						_dowMsgTxt(enable := TRUE, ident := _CheckDoMsg.doId, Offset := SIZEOF(_TxtLine)*_ii, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));
				
						IF _dowMsgTxt.status <> ERR_OK THEN

							IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRDATOBJ;
							_xInitDone := TRUE;
							EXIT;
					
						END_IF
						
						_ii := _ii + 1;

						UNTIL
						((_ii MOD 10) = 0) OR _ii >= _lLenMsg

					END_REPEAT
					
					IF _ii >= _lLenMsg THEN
						
						_initState := _is_checkMsgHlpTxt;
						
					END_IF
			
				ELSE
					
					_initState := _is_checkMsgHlpTxt;
					
				END_IF
			

			// Datenobjekte für Meldungstexte prüfen und ggf. anlegen
			_is_checkMsgHlpTxt:

				IFmnTxt.Out.ptrMessageHelpTxtList := 0;
				IFmnTxt.Out.wCntMessageHlpTxt := 0;
				
				_lLenMsgHlpTxt := SIZEOF(_TxtHelpLine)* _lLenMsg;

				_CheckDoMsgHlp(Enable := TRUE, pName := ADR(MNTXT_DATOBJNAME_MSGHELPTXT), MinLen := _lLenMsgHlpTxt, NomLen := _lLenMsgHlpTxt, Create := TRUE, MemType := doUSRROM);
					
				IF _CheckDoMsgHlp.Status <> ERR_FUB_BUSY THEN

					// DO mit Templatetexten füllen, wenn es neu angelegt wurde
					IF _CheckDoMsgHlp.Status = KG_INFO_DO_NEW OR _CheckDoMsgHlp.Status = ERR_OK THEN

						_debMessageHlpTxtList ACCESS _CheckDoMsgHlp.doMem;
						
						IFmnTxt.Out.ptrMessageHelpTxtList := _CheckDoMsgHlp.doMem;
						IFmnTxt.Out.wCntMessageHlpTxt := UDINT_TO_UINT(_lLenMsg);
						
						_ii := 0;
						
						_initState := _is_writeMsgHlpTxt;

					ELSE	
							
						IFmnTxt.Out.wSelectLanguageStatus := _CheckDoMsg.Status;
						_xInitDone := TRUE;
							
					END_IF

				END_IF

			_is_writeMsgHlpTxt:
				
				IF _CheckDoMsgHlp.Status = KG_INFO_DO_NEW AND _lLenMsg > 0 THEN

					REPEAT
								
						_TxtHelpLine.wNumber 		:= _MsgCfgList[_ii].wMsgNumber;
						_TxtHelpLine.wFunctionID 	:= _MsgCfgList[_ii].wFunction_ID;
						_TxtHelpLine.wInstance		:= _MsgCfgList[_ii].wInstance;
						_TxtHelpLine.utfText		:= "Message Help";
						_utfNo					:= UINT_TO_WSTRING(_MsgCfgList[_ii].wMsgNumber);
						brwcscat(ADR(_TxtHelpLine.utfText), ADR(_utfNo));
					
						_dowMsgHlpTxt(enable := TRUE, ident := _CheckDoMsgHlp.doId, Offset := SIZEOF(_TxtHelpLine)*_ii, pSource := ADR(_TxtHelpLine), len := SIZEOF(_TxtHelpLine));
				
						IF _dowMsgHlpTxt.status <> ERR_OK THEN

							IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRDATOBJ;
							_xInitDone := TRUE;
							EXIT;
					
						END_IF

						_ii := _ii + 1;
						
						UNTIL
						((_ii MOD 10)) = 0 OR	_ii >= _lLenMsg						
					END_REPEAT
					
					IF _ii >= _lLenMsg THEN
						_xInitDone := TRUE;
						_xInitOK := TRUE;
					END_IF
					
				ELSE
					
					_xInitDone := TRUE;
					_xInitOK := TRUE;
					
				END_IF
				
		END_CASE
		
		
		UNTIL
		_xInitDone
	END_REPEAT
				
	mnTxtPar;
	
END_PROGRAM

