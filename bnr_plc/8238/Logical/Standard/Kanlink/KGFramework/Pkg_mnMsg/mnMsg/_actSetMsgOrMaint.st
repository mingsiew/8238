(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actSetMsgOrMaint.st
 * Author: kuehne
 * Created: February 22, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

 (* Add a new action to your IEC program or library *)
ACTION _actSetMsgOrMaint:
	IF kgMsgStatus[_wSrcIdx].wMsgClass = 20 THEN
		IF kgMsgStatus[_wSrcIdx].wMaintNumber = 0 AND kgMsgStatus[_wSrcIdx].wMsgNumber <> 0 THEN
			kgMsgStatus[_wSrcIdx].wMaintNumber := kgMsgStatus[_wSrcIdx].wMsgNumber;
		END_IF;
		kgMsgStatus[_wSrcIdx].wMsgNumber := 0;
		IF kgMsgStatus[_wSrcIdx].wMaintAckLevel = 0 AND kgMsgStatus[_wSrcIdx].wMsgAckLevel <> 0 THEN
			kgMsgStatus[_wSrcIdx].wMaintAckLevel := kgMsgStatus[_wSrcIdx].wMsgAckLevel;
		END_IF;
		kgMsgStatus[_wSrcIdx].wMsgAckLevel := 0;
		IF kgMsgStatus[_wSrcIdx].diMaintAttr1 = 0 AND kgMsgStatus[_wSrcIdx].diMsgAttr1 <> 0 THEN
			kgMsgStatus[_wSrcIdx].diMaintAttr1 := kgMsgStatus[_wSrcIdx].diMsgAttr1;
		END_IF;
		kgMsgStatus[_wSrcIdx].diMsgAttr1 := 0;
		IF kgMsgStatus[_wSrcIdx].diMaintAttr2 = 0 AND kgMsgStatus[_wSrcIdx].diMsgAttr2 <> 0 THEN
			kgMsgStatus[_wSrcIdx].diMaintAttr2 := kgMsgStatus[_wSrcIdx].diMsgAttr2;
		END_IF;
		kgMsgStatus[_wSrcIdx].diMsgAttr2 := 0;
		IF kgMsgStatus[_wSrcIdx].sMaintAttrTxt = '' AND kgMsgStatus[_wSrcIdx].sMsgAttrTxt <> '' THEN
			kgMsgStatus[_wSrcIdx].sMaintAttrTxt := kgMsgStatus[_wSrcIdx].sMsgAttrTxt;
		END_IF;
		kgMsgStatus[_wSrcIdx].sMsgAttrTxt := '';
	END_IF;
	IF kgMsgStatus[_wSrcIdx].wMsgClass = 0 OR kgMsgStatus[_wSrcIdx].wMsgClass = 1 OR kgMsgStatus[_wSrcIdx].wMsgClass = 10 OR kgMsgStatus[_wSrcIdx].wMsgClass = 11 THEN
		IF kgMsgStatus[_wSrcIdx].wMsgNumber = 0 AND kgMsgStatus[_wSrcIdx].wMaintNumber <> 0 THEN
			kgMsgStatus[_wSrcIdx].wMsgNumber := kgMsgStatus[_wSrcIdx].wMaintNumber;
		END_IF;
		kgMsgStatus[_wSrcIdx].wMaintNumber := 0;
		IF kgMsgStatus[_wSrcIdx].wMsgAckLevel = 0 AND kgMsgStatus[_wSrcIdx].wMaintAckLevel <> 0 THEN
			kgMsgStatus[_wSrcIdx].wMsgAckLevel := kgMsgStatus[_wSrcIdx].wMaintAckLevel;
		END_IF;
		kgMsgStatus[_wSrcIdx].wMaintAckLevel := 0;
		IF kgMsgStatus[_wSrcIdx].diMsgAttr1 = 0 AND kgMsgStatus[_wSrcIdx].diMaintAttr1 <> 0 THEN
			kgMsgStatus[_wSrcIdx].diMsgAttr1 := kgMsgStatus[_wSrcIdx].diMaintAttr1;
		END_IF;
		kgMsgStatus[_wSrcIdx].diMaintAttr1 := 0;
		IF kgMsgStatus[_wSrcIdx].diMsgAttr2 = 0 AND kgMsgStatus[_wSrcIdx].diMaintAttr2 <> 0 THEN
			kgMsgStatus[_wSrcIdx].diMsgAttr2 := kgMsgStatus[_wSrcIdx].diMaintAttr2;
		END_IF;
		kgMsgStatus[_wSrcIdx].diMaintAttr2 := 0;
		IF kgMsgStatus[_wSrcIdx].sMsgAttrTxt = '' AND kgMsgStatus[_wSrcIdx].sMaintAttrTxt <> '' THEN
			kgMsgStatus[_wSrcIdx].sMsgAttrTxt := kgMsgStatus[_wSrcIdx].sMaintAttrTxt;
		END_IF;
		kgMsgStatus[_wSrcIdx].sMaintAttrTxt := '';
	END_IF;
END_ACTION