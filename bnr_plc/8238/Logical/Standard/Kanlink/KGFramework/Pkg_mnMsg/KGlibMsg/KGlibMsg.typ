(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGlibMsg
 * File: KGlibMsg.typ
 * Author: hunholz
 * Created: May 30, 2011
 * Changed: June 15, 2011
 ********************************************************************
 * Data types of library KGlibMsg
 ********************************************************************)

TYPE
	MsgCfgLine_Typ : 	STRUCT 
		wFunction_ID : UINT;
		wMsgNumber : UINT;
		wInstance : UINT;
		wRes : UINT;
	END_STRUCT;
	MsgHistList_Typ : 	STRUCT 
		TimeStampEvent : DATE_AND_TIME;
		wFunction_ID : UINT;
		wMsgNumber : UINT;
		wInstance : UINT;
		wMsgClass : UINT;
		diAttr1 : DINT;
		diAttr2 : DINT;
		sAttrTxt : STRING[13];
		wEvent : UINT;
		lTime : UDINT;
	END_STRUCT;
	IFMsgHistList_Typ : 	STRUCT 
		utfMsgText : WSTRING[67];
		bMsgClass : USINT;
		bEvent : USINT;
	END_STRUCT;
	MsgList_Typ : 	STRUCT 
		TimeStamp : DATE_AND_TIME;
		wFunction_ID : UINT;
		wMsgNumber : UINT;
		bInstance : USINT;
		bAckLevel : USINT;
		sAttrTxt : STRING[13];
		diAttr1 : DINT;
		diAttr2 : DINT;
	END_STRUCT;
	MsgTxtLine_Typ : 	STRUCT 
		wFunctionID : UINT;
		wNumber : UINT;
		wInstance : UINT;
		utfText : WSTRING[63];
	END_STRUCT;
	MsgHelpTxtLine_Typ : 	STRUCT 
		wFunctionID : UINT;
		wNumber : UINT;
		wInstance : UINT;
		utfText : WSTRING[255];
	END_STRUCT;
	MsgKgMsgStatus_Typ : 	STRUCT 
		wFunctionID : UINT;
		wMsgClass : UINT;
		wNumber : UINT;
		wMsgAckLevel : UINT;
		wInstance : UINT;
		sMsgAttrTxt : STRING[13];
		diMsgAttr1 : DINT;
		diMsgAttr2 : DINT;
		wMaintNumber : UINT;
		sMaintAttrTxt : STRING[13];
		diMaintAttr1 : DINT;
		diMaintAttr2 : DINT;
		wMaintAckLevel : UINT;
		xAckMaint : BOOL;
		xAckFault : BOOL;
		xAckAva : BOOL;
		xAckRead : BOOL;
	END_STRUCT;
END_TYPE
