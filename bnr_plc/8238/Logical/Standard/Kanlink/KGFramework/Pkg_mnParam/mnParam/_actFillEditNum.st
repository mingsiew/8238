(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _actFillEditNum.st
 * Author: hunholz
 * Created: March 21, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Attribute und Werte füllen *)
ACTION _actFillEditNum: 
	
	// Attribute übertragen
									
	IFmnParam.Out.Edit.AttrNum[_wActRow].wType := _pDoParamNum.ParamNum[_wActRefIdx].bRowType + MNPARAM_CSV_DAT_NUM;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wUnit := _pDoParamNum.ParamNum[_wActRefIdx].wUnitID;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wFunctionID := _pDoParamNum.ParamNum[_wActRefIdx].wFunction_ID;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wParamNo := _pDoParamNum.ParamNum[_wActRefIdx].wParNo;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wParIdx := _wActRefIdx;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wArrIdx[1] := _pDoContainerNum.CsvNum[_wActIdx].wArrIdx1;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wArrIdx[2] := _pDoContainerNum.CsvNum[_wActIdx].wArrIdx2;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wArrIdx[3] := _pDoContainerNum.CsvNum[_wActIdx].wArrIdx3;
	IFmnParam.Out.Edit.AttrNum[_wActRow].wArrIdx[4] := _pDoContainerNum.CsvNum[_wActIdx].wArrIdx4;
									
	_pDigits := ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].lDigits);
	_pUnit := ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].sUnit);
									
	IF _pDoParamNum.ParamNum[_wActRefIdx].bRowType = 0 THEN
										
		// INT
		IFmnParam.Out.Edit.AttrNum[_wActRow].rDefault := kgUnitconfREALtoDisplay(DINT_TO_REAL(_pDoParamNum.ParamNum[_wActRefIdx].diDefValue),_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, _pDigits, _pUnit);
		IFmnParam.Out.Edit.AttrNum[_wActRow].rMax := kgUnitconfREALtoDisplay(DINT_TO_REAL(_pDoParamNum.ParamNum[_wActRefIdx].diMaxValue),_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, 0, 0);
		IFmnParam.Out.Edit.AttrNum[_wActRow].rMin := kgUnitconfREALtoDisplay(DINT_TO_REAL(_pDoParamNum.ParamNum[_wActRefIdx].diMinValue),_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, 0, 0);
										
	ELSE
										
		// REAL
		_prValue ACCESS ADR(_pDoParamNum.ParamNum[_wActRefIdx].diDefValue);
		IFmnParam.Out.Edit.AttrNum[_wActRow].rDefault := kgUnitconfREALtoDisplay(_prValue,_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, _pDigits, _pUnit);
		_prValue ACCESS ADR(_pDoParamNum.ParamNum[_wActRefIdx].diMaxValue);
		IFmnParam.Out.Edit.AttrNum[_wActRow].rMax := kgUnitconfREALtoDisplay(_prValue,_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, 0, 0);
		_prValue ACCESS ADR(_pDoParamNum.ParamNum[_wActRefIdx].diMinValue);
		IFmnParam.Out.Edit.AttrNum[_wActRow].rMin := kgUnitconfREALtoDisplay(_prValue,_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, 0, 0);
										
	END_IF
									
									
	// Wert übergeben
										
	IF _pDoParamNum.ParamNum[_wActRefIdx].bRowType = 0 THEN
		_EditNumValues.rVal[_wActRow] := kgUnitconfREALtoDisplay(DINT_TO_REAL(_pDoContainerNum.CsvNum[_wActIdx].diValue),_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, 0, 0);
	ELSE
		_prValue ACCESS ADR(_pDoContainerNum.CsvNum[_wActIdx].diValue);
		_EditNumValues.rVal[_wActRow] := kgUnitconfREALtoDisplay(_prValue,_pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit, 0, 0);
	END_IF
	
	_EditNumValues.wIdx[_wActRow] := _wActIdx;
									
	// Texte übergeben (Binäre Suche)
									
	IF IFmnTxt.Out.wSelectLanguageStatus = ERR_OK AND IFmnTxt.Out.ptrFunctionTxtList <> 0 AND IFmnTxt.Out.ptrInstanceTxtList <> 0 AND
		IFmnTxt.Out.ptrParamTxtList <> 0 AND IFmnTxt.Out.ptrParamHelpTxtList <> 0 THEN
										
		_wIdxFunctionTxt := _BinSearchTxtLine(IFmnParam.Out.Edit.AttrNum[_wActRow].wFunctionID, 0, IFmnTxt.Out.ptrFunctionTxtList, IFmnTxt.Out.wCntFunctionTxt);
										
		_wIdxInstanceTxt := _BinSearchTxtLine(IFmnParam.Out.Edit.AttrNum[_wActRow].wFunctionID, IFmnParam.Out.Edit.AttrNum[_wActRow].wArrIdx[1],
		IFmnTxt.Out.ptrInstanceTxtList, IFmnTxt.Out.wCntInstanceTxt);
										
		_wIdxParamTxt := _BinSearchTxtLine(IFmnParam.Out.Edit.AttrNum[_wActRow].wFunctionID, IFmnParam.Out.Edit.AttrNum[_wActRow].wParamNo,
		IFmnTxt.Out.ptrParamTxtList, IFmnTxt.Out.wCntParamTxt);
											
		_wIdxParamHlpTxt := _BinSearchHlpTxtLine(IFmnParam.Out.Edit.AttrNum[_wActRow].wFunctionID, IFmnParam.Out.Edit.AttrNum[_wActRow].wParamNo,
		IFmnTxt.Out.ptrParamHelpTxtList, IFmnTxt.Out.wCntParamHlpTxt);
											
		IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName := "";
		IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterHelpTxt := "";
		IFmnParam.Out.Edit.AttrNum[_wActRow].utfFunction := "";
		IFmnParam.Out.Edit.AttrNum[_wActRow].utfInstance := "";
		_wLenUtf := 0;
	
		IF _wIdxFunctionTxt <> 65535 THEN
			_pFunctionTxt ACCESS IFmnTxt.Out.ptrFunctionTxtList;
			brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfFunction), ADR(_pFunctionTxt[_wIdxFunctionTxt].utfText), 31);
			IF NOT MNPARAM_DISABLE_FILLEDIT_FUNCT THEN
				brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName), ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfFunction), 63-_wLenUtf);
				_wLenUtf := UDINT_TO_UINT(brwcslen(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName)));
				brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName), ADR("."), 63-_wLenUtf);
				_wLenUtf := UDINT_TO_UINT(brwcslen(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName)));
			END_IF
		END_IF
	
		IF _wIdxInstanceTxt <> 65535 THEN
			_pInstanceTxt ACCESS IFmnTxt.Out.ptrInstanceTxtList;
			brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfInstance), ADR(_pInstanceTxt[_wIdxInstanceTxt].utfText), 31);
			IF NOT MNPARAM_DISABLE_FILLEDIT_INST THEN
				brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName), ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfInstance), 63-_wLenUtf);
				_wLenUtf := UDINT_TO_UINT(brwcslen(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName)));
				brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName), ADR("."), 63-_wLenUtf);
				_wLenUtf := UDINT_TO_UINT(brwcslen(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName)));
			END_IF
		END_IF
	
		IF _wIdxParamTxt <> 65535 THEN
			_pParamTxt ACCESS IFmnTxt.Out.ptrParamTxtList;
			brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterName), ADR(_pParamTxt[_wIdxParamTxt].utfText), 63-_wLenUtf);
		END_IF
	
		IF _wIdxParamHlpTxt <> 65535 THEN
			_pParamHlpTxt ACCESS IFmnTxt.Out.ptrParamHelpTxtList;
			brwcsncat(ADR(IFmnParam.Out.Edit.AttrNum[_wActRow].utfParameterHelpTxt), ADR(_pParamHlpTxt[_wIdxParamHlpTxt].utfText), 255);
		END_IF
	
	END_IF

END_ACTION