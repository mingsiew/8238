(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actGetTxtFimh.st
 * Author: kuehne
 * Created: February 22, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

 (* Add a new action to your IEC program or library *)
ACTION _actGetTxtFimh:
	IF _xMnTxtReady THEN
		_MsgTxtLine ACCESS IFmnTxt.Out.ptrFunctionTxtList;
		_BinSearchTxt.MsgTxtList := IFmnTxt.Out.ptrFunctionTxtList;
		_BinSearchTxt.wCntMsgTxt := IFmnTxt.Out.wCntFunctionTxt;
		_BinSearchTxt.wFunctionID := _wActFunctionID;
		_BinSearchTxt.wNumber := _wActMsgNumber;
		_BinSearchTxt.wInstance := _wActInstance;
		_BinSearchTxt.bTupel := 1;
		_BinSearchTxt();
		IF _BinSearchTxt.wStatus <> ERR_OK THEN
			brwcscat(ADR(_utfMsgTextTempFirst), ADR(""));
		ELSE
			_wTxtIdx := _BinSearchTxt.wMsgPos;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr1);
			_fbMsgReplSubStr.utfStr := ADR(_MsgTxtLine[_wTxtIdx].utfText);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar1}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr2);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar2}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := STRING_TO_WSTRING(_sActAttrTxt);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrTxt}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
			UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
			_utfMsgTextTempSecond := ": ";
			brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
			UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
		END_IF;
		_MsgTxtLine ACCESS IFmnTxt.Out.ptrInstanceTxtList;
		_BinSearchTxt.MsgTxtList := IFmnTxt.Out.ptrInstanceTxtList;
		_BinSearchTxt.wCntMsgTxt := IFmnTxt.Out.wCntInstanceTxt;
		_BinSearchTxt.wFunctionID := _wActFunctionID;
		_BinSearchTxt.wNumber := _wActInstance;
		_BinSearchTxt.wInstance := 0;
		_BinSearchTxt.bTupel := 2;
		_BinSearchTxt();
		IF _BinSearchTxt.wStatus <> ERR_OK THEN
			brwcscat(ADR(_utfMsgTextTempFirst), ADR(""));
		ELSE
			_wTxtIdx := _BinSearchTxt.wMsgPos;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr1);
			_fbMsgReplSubStr.utfStr := ADR(_MsgTxtLine[_wTxtIdx].utfText);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar1}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr2);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar2}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := STRING_TO_WSTRING(_sActAttrTxt);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrTxt}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
			UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempSecond := ": ";
			brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
			UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
		END_IF;
		_MsgTxtLine ACCESS IFmnTxt.Out.ptrMessageTxtList;
		_BinSearchTxt.MsgTxtList := IFmnTxt.Out.ptrMessageTxtList;
		_BinSearchTxt.wCntMsgTxt := IFmnTxt.Out.wCntMessageTxt;
		_BinSearchTxt.wFunctionID := _wActFunctionID;
		_BinSearchTxt.wNumber := _wActMsgNumber;
		_BinSearchTxt.wInstance := _wActInstance;
		_BinSearchTxt.bTupel := 2;
		_BinSearchTxt();
		IF _BinSearchTxt.wStatus <> ERR_OK THEN
			brwcscat(ADR(_utfMsgTextTempFirst), ADR(""));
		ELSE
			_wTxtIdx := _BinSearchTxt.wMsgPos;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr1);
			_fbMsgReplSubStr.utfStr := ADR(_MsgTxtLine[_wTxtIdx].utfText);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar1}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr2);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar2}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := STRING_TO_WSTRING(_sActAttrTxt);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrTxt}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
			UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
		END_IF;
		// wcscat(ADR(_utfMsgTextTempFirst), ADR("internal error"));	//Also for test
		_MsgHelpTxtLine ACCESS IFmnTxt.Out.ptrMessageHelpTxtList;
		_BinSearchHelpTxt.MsgHelpTxtList := IFmnTxt.Out.ptrMessageHelpTxtList;
		_BinSearchHelpTxt.wCntMsgHelpTxt := IFmnTxt.Out.wCntMessageHlpTxt;
		_BinSearchHelpTxt.wFunctionID := _wActFunctionID;
		_BinSearchHelpTxt.wNumber := _wActMsgNumber;
		_BinSearchHelpTxt.wInstance := _wActInstance;
		_BinSearchHelpTxt.bTupel := 2;
		_BinSearchHelpTxt();
		IF _BinSearchHelpTxt.wStatus <> ERR_OK THEN
			_utfMsgTextTempSecond := "";
		ELSE
			_wTxtIdx := _BinSearchHelpTxt.wMsgPos;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr1);
			_fbMsgReplSubStr.utfStr := ADR(_MsgHelpTxtLine[_wTxtIdx].utfText);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar1}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := DINT_TO_WSTRING(_diActAttr2);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar2}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			_utfMsgTextTempThird := "";
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_utfMsgTextTempThird := STRING_TO_WSTRING(_sActAttrTxt);
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrTxt}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
		END_IF;
	ELSE
		brwcscat(ADR(_utfMsgTextTempFirst), ADR(""));
		brwcscat(ADR(_utfMsgTextTempSecond), ADR(""));
	END_IF; // IF _xMnTxtReady THEN
END_ACTION