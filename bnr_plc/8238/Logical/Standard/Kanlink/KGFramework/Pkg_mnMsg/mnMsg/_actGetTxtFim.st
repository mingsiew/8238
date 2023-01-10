(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actGetTxtFim.st
 * Author: kuehne
 * Created: February 21, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actGetTxtFim:
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
			_BinSearchCfg.wFunctionID := _wActFunctionID;
			_BinSearchCfg.wMsgNo := _wActMsgNumber;
			_BinSearchCfg.wInstance := _wActInstance;
			_BinSearchCfg();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := DINT_TO_WSTRING(_MsgImage[_wImageIdx].diMsgAttr1);
			ELSE
				_utfMsgTextTempThird := "{##AttrVar1}";
			END_IF;
			_utfMsgTextTempSecond := "";
			_fbMsgReplSubStr.utfStr := ADR(_MsgTxtLine[_wTxtIdx].utfText);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar1}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := DINT_TO_WSTRING(_MsgImage[_wImageIdx].diMsgAttr2);
			ELSE
				_utfMsgTextTempThird := "{##AttrVar2}";
			END_IF;
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar2}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := STRING_TO_WSTRING(_MsgImage[_wImageIdx].sMsgAttrTxt);
			ELSE
				_utfMsgTextTempThird := "{##AttrTxt}";
			END_IF;
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
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
			_BinSearchCfg.wFunctionID := _wActFunctionID;
			_BinSearchCfg.wMsgNo := _wActMsgNumber;
			_BinSearchCfg.wInstance := _wActInstance;
			_BinSearchCfg();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := DINT_TO_WSTRING(_MsgImage[_wImageIdx].diMsgAttr1);
			ELSE
				_utfMsgTextTempThird := "{##AttrVar1}";
			END_IF;
			_utfMsgTextTempSecond := "";
			_fbMsgReplSubStr.utfStr := ADR(_MsgTxtLine[_wTxtIdx].utfText);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar1}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := DINT_TO_WSTRING(_MsgImage[_wImageIdx].diMsgAttr2);
			ELSE
				_utfMsgTextTempThird := "{##AttrVar2}";
			END_IF;
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar2}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := STRING_TO_WSTRING(_MsgImage[_wImageIdx].sMsgAttrTxt);
			ELSE
				_utfMsgTextTempThird := "{##AttrTxt}";
			END_IF;
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
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
			_BinSearchCfg.wFunctionID := _wActFunctionID;
			_BinSearchCfg.wMsgNo := _wActMsgNumber;
			_BinSearchCfg.wInstance := _wActInstance;
			_BinSearchCfg();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := DINT_TO_WSTRING(_MsgImage[_wImageIdx].diMsgAttr1);
			ELSE
				_utfMsgTextTempThird := "{##AttrVar1}";
			END_IF;
			_utfMsgTextTempSecond := "";
			_fbMsgReplSubStr.utfStr := ADR(_MsgTxtLine[_wTxtIdx].utfText);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar1}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := DINT_TO_WSTRING(_MsgImage[_wImageIdx].diMsgAttr2);
			ELSE
				_utfMsgTextTempThird := "{##AttrVar2}";
			END_IF;
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrVar2}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			IF _BinSearchCfg.wStatus = ERR_OK THEN
				_wImageIdx := _BinSearchCfg.wMsgIdx;
				_utfMsgTextTempThird := "";
				_utfMsgTextTempThird := STRING_TO_WSTRING(_MsgImage[_wImageIdx].sMsgAttrTxt);
			ELSE
				_utfMsgTextTempThird := "{##AttrTxt}";
			END_IF;
			_utfMsgTextTempFourth := "";
			_utfMsgTextTempFourth := _utfMsgTextTempSecond;
			_utfMsgTextTempSecond := "";
			_fbMsgReplSubStr.utfStr := ADR(_utfMsgTextTempFourth);
			_fbMsgReplSubStr.utfSubStr := ADR("{##AttrTxt}");
			_fbMsgReplSubStr.utfStrToReplWith := ADR(_utfMsgTextTempThird);
			_fbMsgReplSubStr.utfStrResult := ADR(_utfMsgTextTempSecond);
			_fbMsgReplSubStr();
			brwcsncat(ADR(_utfMsgTextTempFirst), ADR(_utfMsgTextTempSecond),
			UDINT_TO_UINT(brwcslen(ADR(_utfMsgTextTempSecond)) - (brwcslen(ADR(_utfMsgTextTempFirst)) + brwcslen(ADR(_utfMsgTextTempSecond)) - (SIZEOF(_utfMsgTextTempFirst) / 2 - 1))));
		END_IF;
	ELSE
		brwcscat(ADR(_utfMsgTextTempFirst), ADR(""));
	END_IF;
END_ACTION