(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actInsertRB.st
 * Author: kuehne
 * Created: February 22, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actInsertRB:
	IF _xRBReady THEN
		_TempHistline.TimeStampEvent := _dtTimeStamp.DT1;
		_TempHistline.wFunction_ID := _MsgCfgList[_wMsgIdx].wFunction_ID;
		_TempHistline.wInstance := _MsgCfgList[_wMsgIdx].wInstance;
		_TempHistline.wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
		_TempHistline.wMsgClass := _MsgImage[_wMsgIdx].wMsgClass;
		_TempHistline.diAttr1 := _MsgImage[_wMsgIdx].diMsgAttr1;
		_TempHistline.diAttr2 := _MsgImage[_wMsgIdx].diMsgAttr2;
		strcpy(ADR(_TempHistline.sAttrTxt), ADR(_MsgImage[_wMsgIdx].sMsgAttrTxt));
		_TempHistline.lTime := _lActTime;
		_TempHistline.wEvent := _wActEvent;
		_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
	END_IF;
END_ACTION