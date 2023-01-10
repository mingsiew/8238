(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTxt
 * File: mnTxtCyclic.st
 * Author: hunholz
 * Created: November 25, 2011
 ********************************************************************
 * Implementation of program mnTxt
 ********************************************************************)

PROGRAM _CYCLIC

	// Auf Sprachwechsel reagieren, bzw. letzte Sprache laden

	IF _xInitOK THEN

		IF IFmnTxt.Out.wSelectLanguageStatus = MNTXT_STAT_OK THEN
			
			// Sprache kann neu gewählt werden
			IF _wActLCID <> IFmnTxt.In.wSelectLanguage AND IFmnTxt.In.wSelectLanguage <> 0 THEN
				
				_wIdxLCID := 0;
				
				REPEAT
					
					IF IFmnTxt.In.wSelectLanguage = IFmnTxt.Out.wLCIDs[_wIdxLCID] THEN
						
						_wActLCID := IFmnTxt.In.wSelectLanguage;
	
						IFmnTxt.Out.wSelectedLanguage := _wActLCID;
						IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_LOADING;
						_LoadState := _ls_load_functiontxt_01;
						
					END_IF
					
					_wIdxLCID := _wIdxLCID + 1;
						
					UNTIL
					_wActLCID = IFmnTxt.In.wSelectLanguage OR _wIdxLCID >= IFmnTxt.Out.wCntLCID OR _wIdxLCID > MNTXT_MAX_IDX_LCID
				END_REPEAT
				
			END_IF
			
		ELSIF IFmnTxt.Out.wSelectLanguageStatus = MNTXT_STAT_NOLANGUAGE THEN	
	
			IF _LoadState = _ls_idle THEN
				
				// Sprache erstmals laden
				IF _wActLCID = 0 THEN
					
					IF _xGermanExist THEN
						
						_wActLCID := MNTXT_LCID_GERMAN;
						
					ELSE
						
						_wActLCID := IFmnTxt.Out.wLCIDs[0];
						
					END_IF
					
				END_IF
	
				IFmnTxt.Out.wSelectedLanguage := _wActLCID;
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_LOADING;
				_LoadState := _ls_load_functiontxt_01;
					
			END_IF
				
		END_IF

	END_IF
		
	// Zyklusbegrenzung zurücksetzen
	
	_lCycleCounter := 0;
	
	// Statemachine
	
	CASE _LoadState OF
		
		_ls_idle:
			
		// Grundzustand, nichts tun

		//###########################################################################################
		// FUNKTIONSTEXTE LADEN
		//###########################################################################################
		
		_ls_load_functiontxt_01:
			
			// Nachsehen, ob Funktionstexte existieren
			
			IFmnTxt.Out.wCntFunctionTxt := 0;
			
			IF MNTXT_LOAD_FUNCTIONTEXT AND _CheckDoFunc.doId <> 0 THEN

				IF MNTXT_ENABLE_LANSPECRESOURCE = 1 THEN
			
					_sLCID := UINT_TO_STRING(_wActLCID);
					_sPath := CONCAT('Language\Function',_sLCID);
					_sPath := CONCAT(_sPath,'.csv');

				ELSE
			
					_sPath := 'Language\Function.csv';
				
				END_IF

				_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_sPath), pInfo := ADR(_fiFileInfo));
			
				IF _FileInfo.status = ERR_OK THEN
					
					_LoadState := _ls_load_functiontxt_02;
					
				ELSIF _FileInfo.status <> ERR_FUB_BUSY THEN
				
					_LoadState := _ls_load_instancetxt_01;

				END_IF		
				
			ELSE

				_LoadState := _ls_load_instancetxt_01;

			END_IF
	
		_ls_load_functiontxt_02:
			
			// Speicher zum Parsen der Funktionstexte allokieren
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _fiFileInfo.size-SIZEOF(KGBOM) );

			IF _MemPartAlloc.status = ERR_OK THEN
				
				_lAdrFile := _MemPartAlloc.mem;
				_LoadState := _ls_load_functiontxt_03;
				
			ELSIF _MemPartAlloc.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMEM;
				_LoadState := _ls_error;

			END_IF

		_ls_load_functiontxt_03:
		
			_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPath), mode := fiREAD_ONLY);

			IF _FileOpen.status = ERR_OK THEN
				
				_LoadState := _ls_load_functiontxt_04;
				
			ELSIF _FileOpen.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRFUNCTIONTXT;
				_LoadState := _ls_error;

			END_IF

		_ls_load_functiontxt_04:

			_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _lAdrFile, len :=  _fiFileInfo.size-SIZEOF(KGBOM) );
		
			IF _FileRead.status <> ERR_FUB_BUSY THEN
				
				_LoadState := _ls_load_functiontxt_05;
				
			END_IF

		_ls_load_functiontxt_05:

			_FileClose(enable := TRUE, ident := _FileOpen.ident);

			IF _FileClose.status <> ERR_FUB_BUSY THEN
				
				IF _FileRead.status = ERR_OK THEN

					_LoadState := _ls_load_functiontxt_06;

				ELSE
					IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRFUNCTIONTXT;
					_LoadState := _ls_error;

				END_IF
				
			END_IF

		_ls_load_functiontxt_06:
		
			// Zeilen in der Datei zählen und Startadressen ermitteln
		
			_CountLines.enable := TRUE;
			_CountLines.pFile := _lAdrFile;
			_CountLines.FileSize := _fiFileInfo.size - SIZEOF(KGBOM);
			_CountLines.MaxLines := MNTXT_MAXPARSELINES;
			_CountLines.pAdresses := _lAdrLineAdress;
			_CountLines.pLens := _lAdrLineLen;
		
			_CountLines();
		
			IF _CountLines.status = ERR_OK THEN

				_LoadState := _ls_load_functiontxt_07;
				
				_wStartLine := 1;
				_wIdxFunctionTxt := 0;
				_GetCsvDat.enable := TRUE;

			ELSE
				
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRFUNCTIONTXT;
				_LoadState := _ls_error;

			END_IF		

		_ls_load_functiontxt_07:

			// Datei parsen
			
			REPEAT
				
				brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
				_GetCsvDat();
				_wStartLine := _wStartLine + 1;

				IF _GetCsvDat.RowType = 200 AND _GetCsvDat.csvTextRow.LCID = _wActLCID THEN
					
					_TxtLine.wNumber := 0;
					_TxtLine.wFunctionID := _GetCsvDat.csvTextRow.FunctionID;
					_TxtLine.utfText := _GetCsvDat.csvTextRow.utfText;
					
					_dowFuncTxt(enable := TRUE, ident := _CheckDoFunc.doId, Offset := SIZEOF(_TxtLine)*_wIdxFunctionTxt, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));

					_wIdxFunctionTxt := _wIdxFunctionTxt + 1;
					
				END_IF

				_lCycleCounter := _lCycleCounter + 1;

				UNTIL
				
				_lCycleCounter > 20 OR _wIdxFunctionTxt > MNTXT_MAX_IDX_TXT_FUNCTION OR _wStartLine > _CountLines.CntLines
				
			END_REPEAT
		
			IF _wIdxFunctionTxt > MNTXT_MAX_IDX_TXT_FUNCTION OR _wStartLine > _CountLines.CntLines THEN
				
				IFmnTxt.Out.wCntFunctionTxt := _wIdxFunctionTxt;
				_LoadState := _ls_load_functiontxt_08;
				
			END_IF
		
		_ls_load_functiontxt_08:
		
			// Speicher frei geben
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _lAdrFile);

			IF _MemPartFree.status = ERR_OK THEN
				
				_LoadState := _ls_load_instancetxt_01;
				
			ELSIF _MemPartFree.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRFUNCTIONTXT;
				_LoadState := _ls_error;

			END_IF

		//###########################################################################################
		// INSTANZTEXTE LADEN
		//###########################################################################################
		
		_ls_load_instancetxt_01:
			
			// Nachsehen, ob Instanztexte existieren
			
			IFmnTxt.Out.wCntInstanceTxt := 0;
			
			IF MNTXT_LOAD_INSTANCETEXT AND _CheckDoInst.doId <> 0 THEN

				IF MNTXT_ENABLE_LANSPECRESOURCE = 1 THEN
			
					_sLCID := UINT_TO_STRING(_wActLCID);
					_sPath := CONCAT('Language\Instance',_sLCID);
					_sPath := CONCAT(_sPath,'.csv');

				ELSE
			
					_sPath := 'Language\Instance.csv';
				
				END_IF

				_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_sPath), pInfo := ADR(_fiFileInfo));
			
				IF _FileInfo.status = ERR_OK THEN
					
					_LoadState := _ls_load_instancetxt_02;
					
				ELSIF _FileInfo.status <> ERR_FUB_BUSY THEN
				
					_LoadState := _ls_load_messagetxt_01;
	
				END_IF		
				
			ELSE

				_LoadState := _ls_load_messagetxt_01;
				
			END_IF
	
		_ls_load_instancetxt_02:
			
			// Speicher zum Parsen der Funktionstexte allokieren
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _fiFileInfo.size-SIZEOF(KGBOM) );

			IF _MemPartAlloc.status = ERR_OK THEN
				
				_lAdrFile := _MemPartAlloc.mem;
				_LoadState := _ls_load_instancetxt_03;
				
			ELSIF _MemPartAlloc.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMEM;
				_LoadState := _ls_error;

			END_IF

		_ls_load_instancetxt_03:
		
			_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPath), mode := fiREAD_ONLY);

			IF _FileOpen.status = ERR_OK THEN
				
				_LoadState := _ls_load_instancetxt_04;
				
			ELSIF _FileOpen.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRINSTANCETXT;
				_LoadState := _ls_error;

			END_IF

		_ls_load_instancetxt_04:

			_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _lAdrFile, len :=  _fiFileInfo.size-SIZEOF(KGBOM) );
		
			IF _FileRead.status <> ERR_FUB_BUSY THEN
				
				_LoadState := _ls_load_instancetxt_05;
				
			END_IF

		_ls_load_instancetxt_05:

			_FileClose(enable := TRUE, ident := _FileOpen.ident);

			IF _FileClose.status <> ERR_FUB_BUSY THEN
				
				IF _FileRead.status = ERR_OK THEN

					_LoadState := _ls_load_instancetxt_06;

				ELSE
					IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRINSTANCETXT;
					_LoadState := _ls_error;

				END_IF
				
			END_IF

		_ls_load_instancetxt_06:
		
			// Zeilen in der Datei zählen und Startadressen ermitteln
		
			_CountLines.enable := TRUE;
			_CountLines.pFile := _lAdrFile;
			_CountLines.FileSize := _fiFileInfo.size - SIZEOF(KGBOM);
			_CountLines.MaxLines := MNTXT_MAXPARSELINES;
			_CountLines.pAdresses := _lAdrLineAdress;
			_CountLines.pLens := _lAdrLineLen;
		
			_CountLines();
		
			IF _CountLines.status = ERR_OK THEN

				_LoadState := _ls_load_instancetxt_07;
				
				_wStartLine := 1;
				_wIdxInstanceTxt := 0;
				_GetCsvDat.enable := TRUE;

			ELSE
				
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRINSTANCETXT;
				_LoadState := _ls_error;

			END_IF		

		_ls_load_instancetxt_07:

			// Datei parsen
			
			REPEAT
				
				brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
				_GetCsvDat();
				_wStartLine := _wStartLine + 1;

				IF _GetCsvDat.RowType = 200 AND _GetCsvDat.csvTextRow.LCID = _wActLCID THEN
					
					_TxtLine.wNumber := _GetCsvDat.csvTextRow.TextNo;
					_TxtLine.wFunctionID := _GetCsvDat.csvTextRow.FunctionID;
					_TxtLine.utfText := _GetCsvDat.csvTextRow.utfText;
					
					_dowInstTxt(enable := TRUE, ident := _CheckDoInst.doId, Offset := SIZEOF(_TxtLine)*_wIdxInstanceTxt, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));

					_wIdxInstanceTxt := _wIdxInstanceTxt + 1;
					
				END_IF
				
				_lCycleCounter := _lCycleCounter + 1;
				
				UNTIL
				
				_lCycleCounter > 20 OR _wIdxInstanceTxt > MNTXT_MAX_IDX_TXT_INSTANCE OR _wStartLine > _CountLines.CntLines
				
			END_REPEAT
		
			IF _wIdxInstanceTxt > MNTXT_MAX_IDX_TXT_INSTANCE OR _wStartLine > _CountLines.CntLines THEN
				
				IFmnTxt.Out.wCntInstanceTxt := _wIdxInstanceTxt;
				_LoadState := _ls_load_instancetxt_08;
				
			END_IF
		
		_ls_load_instancetxt_08:
		
			// Speicher frei geben
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _lAdrFile);

			IF _MemPartFree.status = ERR_OK THEN
				
				_LoadState := _ls_load_messagetxt_01;
				
			ELSIF _MemPartFree.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRINSTANCETXT;
				_LoadState := _ls_error;

			END_IF

		//###########################################################################################
		// MELDUNGSTEXTE LADEN
		//###########################################################################################
		
		_ls_load_messagetxt_01:
			
			// Nachsehen, ob Meldungstexte existieren
			
			IFmnTxt.Out.wCntMessageTxt := 0;
			IFmnTxt.Out.wCntMessageHlpTxt := 0;
			
			IF MNTXT_ENABLE_LANSPECRESOURCE = 1 THEN
			
				_sLCID := UINT_TO_STRING(_wActLCID);
				_sPath := CONCAT('Messages\Messages',_sLCID);
				_sPath := CONCAT(_sPath,'.csv');

			ELSE
			
				_sPath := 'Messages\Messages.csv';
				
			END_IF
			
			_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_sPath), pInfo := ADR(_fiFileInfo));
		
			IF _FileInfo.status = ERR_OK THEN
				
				_LoadState := _ls_load_messagetxt_02;
				
			ELSIF _FileInfo.status <> ERR_FUB_BUSY THEN
			
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMESSAGETXT;
				_LoadState := _ls_error;

			END_IF		
	
		_ls_load_messagetxt_02:
			
			// Speicher zum Parsen der Funktionstexte allokieren
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _fiFileInfo.size-SIZEOF(KGBOM) );

			IF _MemPartAlloc.status = ERR_OK THEN
				
				_lAdrFile := _MemPartAlloc.mem;
				_LoadState := _ls_load_messagetxt_03;
				
			ELSIF _MemPartAlloc.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMEM;
				_LoadState := _ls_error;

			END_IF

		_ls_load_messagetxt_03:
		
			_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPath), mode := fiREAD_ONLY);

			IF _FileOpen.status = ERR_OK THEN
				
				_LoadState := _ls_load_messagetxt_04;
				
			ELSIF _FileOpen.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMESSAGETXT;
				_LoadState := _ls_error;

			END_IF

		_ls_load_messagetxt_04:

			_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _lAdrFile, len :=  _fiFileInfo.size-SIZEOF(KGBOM) );
		
			IF _FileRead.status <> ERR_FUB_BUSY THEN
				
				_LoadState := _ls_load_messagetxt_05;
				
			END_IF

		_ls_load_messagetxt_05:

			_FileClose(enable := TRUE, ident := _FileOpen.ident);

			IF _FileClose.status <> ERR_FUB_BUSY THEN
				
				IF _FileRead.status = ERR_OK THEN

					_LoadState := _ls_load_messagetxt_06;

				ELSE
					IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMESSAGETXT;
					_LoadState := _ls_error;

				END_IF
				
			END_IF

		_ls_load_messagetxt_06:
		
			// Zeilen in der Datei zählen und Startadressen ermitteln
		
			_CountLines.enable := TRUE;
			_CountLines.pFile := _lAdrFile;
			_CountLines.FileSize := _fiFileInfo.size - SIZEOF(KGBOM);
			_CountLines.MaxLines := MNTXT_MAXPARSELINES;
			_CountLines.pAdresses := _lAdrLineAdress;
			_CountLines.pLens := _lAdrLineLen;
		
			_CountLines();
		
			IF _CountLines.status = ERR_OK THEN

				_LoadState := _ls_load_messagetxt_07;
				
				_wStartLine := 1;
				_wIdxMessageTxt := 0;
				_wIdxMessageHelpTxt := 0;
				_GetCsvDat.enable := TRUE;

			ELSE
				
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMESSAGETXT;
				_LoadState := _ls_error;

			END_IF		

		_ls_load_messagetxt_07:

			// Datei parsen
			
			REPEAT
				
				brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
				_GetCsvDat();
				_wStartLine := _wStartLine + 1;

				IF _GetCsvDat.RowType = 200 AND _GetCsvDat.csvTextRow.LCID = _wActLCID AND _wIdxMessageTxt < _lLenMsg THEN
					
					_TxtLine.wNumber := _GetCsvDat.csvTextRow.TextNo;
					_TxtLine.wFunctionID := _GetCsvDat.csvTextRow.FunctionID;
					_TxtLine.utfText := _GetCsvDat.csvTextRow.utfText;
					
					_dowMsgTxt(enable := TRUE, ident := _CheckDoMsg.doId, Offset := SIZEOF(_TxtLine)*_wIdxMessageTxt, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));

					_wIdxMessageTxt := _wIdxMessageTxt + 1;
				
				ELSIF _GetCsvDat.RowType = 210 AND _GetCsvDat.csvHelpTextRow.LCID = _wActLCID AND _wIdxMessageHelpTxt < _lLenMsg THEN

					_TxtHelpLine.wNumber := _GetCsvDat.csvHelpTextRow.TextNo;
					_TxtHelpLine.wFunctionID := _GetCsvDat.csvHelpTextRow.FunctionID;
					
					_utfRC(pInput := ADR(_GetCsvDat.csvHelpTextRow.utfHelpText), pOutput := ADR(_TxtHelpLine.utfText), lSizeOutput := SIZEOF(_TxtHelpLine.utfText), xWSTRING := TRUE);
					
//					_TxtHelpLine.utfText := _GetCsvDat.csvHelpTextRow.utfHelpText;
					
					_dowMsgHlpTxt(enable := TRUE, ident := _CheckDoMsgHlp.doId, Offset := SIZEOF(_TxtHelpLine)*_wIdxMessageHelpTxt, pSource := ADR(_TxtHelpLine), len := SIZEOF(_TxtHelpLine));

					_wIdxMessageHelpTxt := _wIdxMessageHelpTxt + 1;

				END_IF
				
				_lCycleCounter := _lCycleCounter + 1;
				
				UNTIL
				
				_lCycleCounter > 20 OR (_wIdxMessageTxt >= _lLenMsg AND _wIdxMessageHelpTxt >= _lLenMsg) OR _wStartLine > _CountLines.CntLines
				
			END_REPEAT
		
			IF (_wIdxMessageTxt >= _lLenMsg AND _wIdxMessageHelpTxt >= _lLenMsg) OR _wStartLine > _CountLines.CntLines THEN
				
				IFmnTxt.Out.wCntMessageTxt := _wIdxMessageTxt;
				IFmnTxt.Out.wCntMessageHlpTxt := _wIdxMessageHelpTxt;
				_LoadState := _ls_load_messagetxt_08;
				
			END_IF
		
		_ls_load_messagetxt_08:
		
			// Speicher frei geben
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _lAdrFile);

			IF _MemPartFree.status = ERR_OK THEN
				
				_LoadState := _ls_load_paramtxt_01;
				
			ELSIF _MemPartFree.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMESSAGETXT;
				_LoadState := _ls_error;

			END_IF

		//###########################################################################################
		// PARAMETERTEXTE LADEN
		//###########################################################################################
		
		_ls_load_paramtxt_01:
			
			// Nachsehen, ob Parametertexte existieren
			
			IFmnTxt.Out.wCntParamTxt := 0;
			IFmnTxt.Out.wCntParamHlpTxt := 0;
			
			IF MNTXT_LOAD_PARAMETERTEXT AND _CheckDoPar.doId <> 0 THEN

				IF MNTXT_ENABLE_LANSPECRESOURCE = 1 THEN
			
					_sLCID := UINT_TO_STRING(_wActLCID);
					_sPath := CONCAT('Language\ParamTxt',_sLCID);
					_sPath := CONCAT(_sPath,'.csv');

				ELSE
			
					_sPath := 'Language\ParamTxt.csv';
				
				END_IF

				_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_sPath), pInfo := ADR(_fiFileInfo));
			
				IF _FileInfo.status = ERR_OK THEN
					
					_LoadState := _ls_load_paramtxt_02;
					
				ELSIF _FileInfo.status <> ERR_FUB_BUSY THEN
				
					IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRPARAMTXT;
					_LoadState := _ls_error;

				END_IF		
				
			ELSE

				_LoadState := _ls_idle;
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_OK;

			END_IF
		
		_ls_load_paramtxt_02:
			
			// Speicher zum Parsen der Parametertexte allokieren
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _fiFileInfo.size-SIZEOF(KGBOM) );

			IF _MemPartAlloc.status = ERR_OK THEN
				
				_lAdrFile := _MemPartAlloc.mem;
				_LoadState := _ls_load_paramtxt_03;
				
			ELSIF _MemPartAlloc.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRMEM;
				_LoadState := _ls_error;

			END_IF

		_ls_load_paramtxt_03:
		
			_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPath), mode := fiREAD_ONLY);

			IF _FileOpen.status = ERR_OK THEN
				
				_LoadState := _ls_load_paramtxt_04;
				
			ELSIF _FileOpen.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRPARAMTXT;
				_LoadState := _ls_error;

			END_IF

		_ls_load_paramtxt_04:

			_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _lAdrFile, len :=  _fiFileInfo.size-SIZEOF(KGBOM) );
		
			IF _FileRead.status <> ERR_FUB_BUSY THEN
				
				_LoadState := _ls_load_paramtxt_05;
				
			END_IF

		_ls_load_paramtxt_05:

			_FileClose(enable := TRUE, ident := _FileOpen.ident);

			IF _FileClose.status <> ERR_FUB_BUSY THEN
				
				IF _FileRead.status = ERR_OK THEN

					_LoadState := _ls_load_paramtxt_06;

				ELSE
					IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRPARAMTXT;
					_LoadState := _ls_error;

				END_IF
				
			END_IF

		_ls_load_paramtxt_06:
		
			// Zeilen in der Datei zählen und Startadressen ermitteln
		
			_CountLines.enable := TRUE;
			_CountLines.pFile := _lAdrFile;
			_CountLines.FileSize := _fiFileInfo.size - SIZEOF(KGBOM);
			_CountLines.MaxLines := MNTXT_MAXPARSELINES;
			_CountLines.pAdresses := _lAdrLineAdress;
			_CountLines.pLens := _lAdrLineLen;
		
			_CountLines();
		
			IF _CountLines.status = ERR_OK THEN

				_LoadState := _ls_load_paramtxt_07;
				
				_wStartLine := 1;
				_wIdxParamTxt := 0;
				_wIdxParamHelpTxt := 0;
				_GetCsvDat.enable := TRUE;

			ELSE
				
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRPARAMTXT;
				_LoadState := _ls_error;

			END_IF		

		_ls_load_paramtxt_07:

			// Datei parsen
			
			REPEAT
				
				brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
				_GetCsvDat();
				_wStartLine := _wStartLine + 1;

				IF _GetCsvDat.RowType = 200 AND _GetCsvDat.csvTextRow.LCID = _wActLCID AND _wIdxParamTxt <= MNTXT_MAX_IDX_TXT_PARAMETER THEN
					
					_TxtLine.wNumber := _GetCsvDat.csvTextRow.TextNo;
					_TxtLine.wFunctionID := _GetCsvDat.csvTextRow.FunctionID;
					_TxtLine.utfText := _GetCsvDat.csvTextRow.utfText;
					
					_dowParTxt(enable := TRUE, ident := _CheckDoPar.doId, Offset := SIZEOF(_TxtLine)*_wIdxParamTxt, pSource := ADR(_TxtLine), len := SIZEOF(_TxtLine));

					_wIdxParamTxt := _wIdxParamTxt + 1;
				
				ELSIF _GetCsvDat.RowType = 210 AND _GetCsvDat.csvHelpTextRow.LCID = _wActLCID AND _wIdxParamHelpTxt <= MNTXT_MAX_IDX_TXT_PARAMETER AND MNTXT_LOAD_PARAMTERHELPTEXT THEN

					_TxtHelpLine.wNumber := _GetCsvDat.csvHelpTextRow.TextNo;
					_TxtHelpLine.wFunctionID := _GetCsvDat.csvHelpTextRow.FunctionID;
					
					// _TxtHelpLine.utfText := _GetCsvDat.csvHelpTextRow.utfHelpText;

					_utfRC(pInput := ADR(_GetCsvDat.csvHelpTextRow.utfHelpText), pOutput := ADR(_TxtHelpLine.utfText), lSizeOutput := SIZEOF(_TxtHelpLine.utfText), xWSTRING := TRUE);

					_dowParHlpTxt(enable := TRUE, ident := _CheckDoParHlp.doId, Offset := SIZEOF(_TxtHelpLine)*_wIdxParamHelpTxt, pSource := ADR(_TxtHelpLine), len := SIZEOF(_TxtHelpLine));

					_wIdxParamHelpTxt := _wIdxParamHelpTxt + 1;

				END_IF
				
				_lCycleCounter := _lCycleCounter + 1;
				
				UNTIL
				
				_lCycleCounter > 20 OR (_wIdxParamTxt > MNTXT_MAX_IDX_TXT_PARAMETER AND _wIdxParamHelpTxt > MNTXT_MAX_IDX_TXT_PARAMETER) OR _wStartLine > _CountLines.CntLines
				
			END_REPEAT
		
			IF (_wIdxParamTxt > MNTXT_MAX_IDX_TXT_PARAMETER AND _wIdxParamHelpTxt > MNTXT_MAX_IDX_TXT_PARAMETER) OR _wStartLine > _CountLines.CntLines THEN
				
				IFmnTxt.Out.wCntParamTxt := _wIdxParamTxt;
				IFmnTxt.Out.wCntParamHlpTxt := _wIdxParamHelpTxt;
				_LoadState := _ls_load_paramtxt_08;
				
			END_IF
		
		_ls_load_paramtxt_08:
		
			// Speicher frei geben
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _lAdrFile);

			IF _MemPartFree.status = ERR_OK THEN
				
				_LoadState := _ls_idle;
				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_OK;
				
				
			ELSIF _MemPartFree.status <> ERR_FUB_BUSY THEN

				IFmnTxt.Out.wSelectLanguageStatus := MNTXT_STAT_ERRPARAMTXT;
				_LoadState := _ls_error;

			END_IF

		_ls_error:
			
			// Fehlerzustand
			
	END_CASE

END_PROGRAM
