(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actInsertMsgL.st
 * Author: kuehne
 * Created: February 23, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actInsertMsgL:
	_InsertMsgLine.Class := _bActMsgLClass;
	_InsertMsgLine.Insert := TRUE;
	_InsertMsgLine.MsgLine.wFunction_ID :=  _MsgCfgList[_wMsgIdx].wFunction_ID;
	_InsertMsgLine.MsgLine.wMsgNumber := _MsgCfgList[_wMsgIdx].wMsgNumber;
	_InsertMsgLine.MsgLine.bInstance := UINT_TO_USINT(_MsgCfgList[_wMsgIdx].wInstance);
	_InsertMsgLine.MsgLine.bAckLevel := UINT_TO_USINT(_MsgImage[_wMsgIdx].wMsgAckLevel);
	_InsertMsgLine.MsgLine.TimeStamp := _MsgImageTime[_wMsgIdx].dtTimeStamp;
	_InsertMsgLine.MsgLine.diAttr1 := _MsgImage[_wMsgIdx].diMsgAttr1;
	_InsertMsgLine.MsgLine.diAttr2 := _MsgImage[_wMsgIdx].diMsgAttr2;
	strcpy(ADR(_InsertMsgLine.MsgLine.sAttrTxt),ADR(_MsgImage[_wMsgIdx].sMsgAttrTxt));
	_InsertMsgLine();
END_ACTION