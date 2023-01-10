(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: mnMsg.typ
 * Author: subramaniam/Hunholz
 * Created: January 28, 2011
 * Changed: June 15, 2011
 ********************************************************************
 * Local data types of program mnMsg
 ********************************************************************)

TYPE
	CmdState_enum : 
		(
		enCS_Idle,
		enCS_WaitForZero,
		enCS_CmdDelStat,
		enCS_CmdDelHist
		);
	EventStatisticDel_enum : 
		(
		Del_Delete,
		Del_Wait,
		Del_Check,
		Del_Write,
		Del_Error
		);
	EventHistDel_enum : 
		(
		Del_DeleteH,
		Del_WaitH,
		Del_ErrorH
		);
END_TYPE

(*Plausibilitaetspruefung Meldungsmanager ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*)

TYPE
	Plausib_Typ : 	STRUCT 
		dCfgMem : UDINT;
		dCfgLen : UDINT;
		wCfgCnt : UINT;
		wCfgVersion : UINT;
		xOK : BOOL;
	END_STRUCT;
END_TYPE

(*Meldungsabbild ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*)

TYPE
	ImageMsgState_Typ : 	STRUCT 
		xOn : BOOL;
		xChanged : BOOL;
	END_STRUCT;
	ImageMsgTime_Typ : 	STRUCT 
		dtTimeStamp : DATE_AND_TIME;
	END_STRUCT;
	ImageMsg_Typ : 	STRUCT 
		wStatus : UINT;
		wMsgClass : UINT;
		wMsgAckLevel : UINT;
		sMsgAttrTxt : STRING[13];
		diMsgAttr1 : DINT;
		diMsgAttr2 : DINT;
	END_STRUCT;
	ImageMsgHelp_Typ : 	STRUCT  (*Hilfsstruktur der Meldeabbild*)
		xFaultIntChanged : BOOL;
		xFaultExtChanged : BOOL;
		xWarningChanged : BOOL;
		xInfoChanged : BOOL;
		xMaintChanged : BOOL;
	END_STRUCT;
	mnMsgStatisticIdx_Type : 	STRUCT 
		wFunction_ID : UINT;
		wMsgNumber : UINT;
		wInstance : UINT;
		lValue : UDINT;
	END_STRUCT;
END_TYPE
