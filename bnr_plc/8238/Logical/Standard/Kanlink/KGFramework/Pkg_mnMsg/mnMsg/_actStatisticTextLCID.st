(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actStatisticTextLCID.st
 * Author: kuehne
 * Created: February 24, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actStatisticTextLCID:
	_GetNextChrPos.lStartPos := 0;
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
	_lPosSpaceFirst := _GetNextChrPos.lChrPos;
	_lAdrSpaceFirst := ADR(_utfMsgTxtLCIDfirst) + 2 * _lPosSpaceFirst;
	//
	IF (_lPosPointFirst > 0) AND (_lPosPointFirst < (SIZEOF(_utfLCIDFunctionId) / 2)) THEN
		_utfLCIDFunctionId := "";
		wcsncat(ADR(_utfLCIDFunctionId), ADR(_utfMsgTxtLCIDfirst), _lPosPointFirst);
		_wLCIDFunctionId := WSTRING_TO_UINT(_utfLCIDFunctionId);
	ELSE
		_utfLCIDFunctionId := "";
		_wLCIDFunctionId := 0;
	END_IF;
	IF ((_lPosPointSecond - 1 - _lPosPointFirst) > 0) AND ((_lPosPointSecond - 1 - _lPosPointFirst) < (SIZEOF(_utfLCIDMsgNumber) / 2)) THEN
		_utfLCIDMsgNumber := "";
		wcsncat(ADR(_utfLCIDMsgNumber), _lAdrPointFirst + 2, _lPosPointSecond - 1 - _lPosPointFirst);
		_wLCIDMsgNumber := WSTRING_TO_UINT(_utfLCIDMsgNumber);
	ELSE
		_utfLCIDMsgNumber := "";
		_wLCIDMsgNumber := 0;
	END_IF;
	IF ((_lPosSpaceFirst - 1 - _lPosPointSecond) > 0) AND ((_lPosSpaceFirst - 1 - _lPosPointSecond) < (SIZEOF(_utfLCIDInstance) / 2)) THEN
		_utfLCIDInstance := "";
		wcsncat(ADR(_utfLCIDInstance), _lAdrPointSecond + 2, _lPosSpaceFirst - 1 - _lPosPointSecond);
		_wLCIDInstance := WSTRING_TO_UINT(_utfLCIDInstance);
	ELSE
		_utfLCIDInstance := "";
		_wLCIDInstance := 0;
	END_IF;
	_utfMsgTxtLCIDfirst := "";
	wcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_utfLCIDFunctionId),
	UDINT_TO_UINT(wcslen(ADR(_utfLCIDFunctionId)) - (wcslen(ADR(_utfMsgTxtLCIDfirst)) + wcslen(ADR(_utfLCIDFunctionId)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
	wcsncat(ADR(_utfMsgTxtLCIDfirst), ADR("."),
	UDINT_TO_UINT(wcslen(ADR(".")) - (wcslen(ADR(_utfMsgTxtLCIDfirst)) + wcslen(ADR(".")) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
	wcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_utfLCIDMsgNumber),
	UDINT_TO_UINT(wcslen(ADR(_utfLCIDMsgNumber)) - (wcslen(ADR(_utfMsgTxtLCIDfirst)) + wcslen(ADR(_utfLCIDMsgNumber)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
	wcsncat(ADR(_utfMsgTxtLCIDfirst), ADR("."),
	UDINT_TO_UINT(wcslen(ADR(".")) - (wcslen(ADR(_utfMsgTxtLCIDfirst)) + wcslen(ADR(".")) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
	wcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(_utfLCIDInstance),
	UDINT_TO_UINT(wcslen(ADR(_utfLCIDInstance)) - (wcslen(ADR(_utfMsgTxtLCIDfirst)) + wcslen(ADR(_utfLCIDInstance)) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
	wcsncat(ADR(_utfMsgTxtLCIDfirst), ADR(" "),
	UDINT_TO_UINT(wcslen(ADR(" ")) - (wcslen(ADR(_utfMsgTxtLCIDfirst)) + wcslen(ADR(" ")) - (SIZEOF(_utfMsgTxtLCIDfirst) / 2 - 1))));
	_wActFunctionID := _wLCIDFunctionId;
	_wActMsgNumber := _wLCIDMsgNumber;
	_wActInstance := _wLCIDInstance;
	_utfMsgTextTempFirst := "";
	_utfMsgTextTempFirst := _utfMsgTxtLCIDfirst;
	_actGetTxtFim;
	_utfMsgTxtLCIDfirst := "";
	_utfMsgTxtLCIDfirst := _utfMsgTextTempFirst;
END_ACTION