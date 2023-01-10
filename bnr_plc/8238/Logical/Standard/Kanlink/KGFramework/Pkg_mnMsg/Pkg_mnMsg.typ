(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Pkg_mnMsg
 * File: Pkg_mnMsg.typ
 * Author: hunholz/ subramaniam
 * Created: January 05, 2011
 * Changed: June 15, 2011
 ********************************************************************
 * Data types of package Pkg_mnMsg
 ********************************************************************)
(*Typdeklaration für kgMsgStat*)

TYPE
	kgMsg_Status_Typ : 	STRUCT 
		wFunction_ID : UINT;
		wMsgClass : UINT;
		wMsgNumber : UINT;
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

(*Konfigurationsstruktur *)

TYPE
	CfgMsgStatList_Typ : 	STRUCT 
		wFunction_ID : UINT;
		wMsgNumber : UINT;
		wInstance : UINT;
		wRes : UINT;
	END_STRUCT;
END_TYPE

(*Struktur Meldungsstatistik *)

TYPE
	MsgStat_Typ : 	STRUCT 
		Header : MsgStatHeader_Typ;
		List : ARRAY[1..MNMSG_MAX_CFGMESSAGES]OF MsgStatList_Typ;
	END_STRUCT;
	MsgStatHeader_Typ : 	STRUCT 
		lVersion : UDINT;
		lLength : UDINT;
	END_STRUCT;
	MsgStatList_Typ : 	STRUCT 
		wFunction_ID : UINT;
		wMsgNumber : UINT;
		wInstance : UINT;
		wMsgClass : UINT;
		lCnt : UDINT;
		lTime : UDINT;
	END_STRUCT;
END_TYPE

(*Synchrones (Internes) Interface zur Steuerung*)

TYPE
	IFmnMsgOutMsgList_Typ : 	STRUCT 
		utfMsgText : WSTRING[67]; (*Meldungs-ID, Meldungs-Text*)
		utfMsgHelpText : WSTRING[255];
		wFunction_ID : UINT; (*Funktions-ID der Meldung*)
		wMsgNumber : UINT; (*Meldungs- oder Wartungsnummer*)
		bInstance : USINT; (*MeldungsInstanz*)
		bMsgClass : USINT; (*0..9 - Störung, 10..19 - Warnung, Info, 20 - Wartung*)
		bAckLevel : UINT; (*0 - jeder, 1 - Operator, 2 - Techniker, 3 - KG-Techniker, 4 - Admin, 255 - nicht quittierbar*)
	END_STRUCT;
	IFmnMsgOutMsgHistList_Typ : 	STRUCT 
		utfMsgText : WSTRING[67]; (*Timestamp, Meldungs-ID, Meldungs-Text*)
		bMsgClass : USINT; (*0..9 - Störung, 10..19 - Warnung, Info, 20 - Wartung*)
		bEvent : USINT; (*1 - gekommen, 2 - quittiert, 3 - gegangen*)
	END_STRUCT;
	IFmnMsgOutMsgStatistic_Typ : 	STRUCT 
		utfMsgText : WSTRING[67]; (*Meldungs-ID, Meldungs-Text*)
		lValue : UDINT; (*Anzahl der Meldungen bzw. Zeit der Meldungen*)
	END_STRUCT;
	IFmnMsgOut_Typ : 	STRUCT 
		MsgList : ARRAY[0..MNMSG_MAX_IDX_VCMSGLIST]OF IFmnMsgOutMsgList_Typ; (*Meldungsliste zur lokalen Anzeige auf der SPS*)
		MsgHistList : ARRAY[0..MNMSG_MAX_IDX_VCMSGHISTLIST]OF IFmnMsgOutMsgHistList_Typ; (*Ausschnitt aus der Meldungshistorie*)
		MsgStatistic : ARRAY[0..MNMSG_MAX_IDX_VCMSGSTATLIST]OF IFmnMsgOutMsgStatistic_Typ;
		wMsgListCnt : UINT; (*Anzahl Meldungen in der Meldungsliste*)
		wMsgHistListCnt : UINT; (*Anzahl der Events in der historischen Meldungsliste*)
		wMsgHistListMaxOffset : UINT; (*Maximal möglicher Offset im Ringbuffer, d.h. Anzahl der Einträge im RB - 1 oder 0, wenn RB leer*)
		wMsgHistListOffset : UINT;
		wMsgStatisticCnt : UINT;
		xFaultInt : BOOL;
		xFaultExt : BOOL;
		xWarning : BOOL;
		xInformation : BOOL;
		xFault : BOOL;
		xReserve : BOOL;
		xMaintenance : BOOL;
		xMnMsgReady : BOOL;
		wCntFaultNoAck : UINT;
		bHorn : USINT;
		bLight : USINT;
		wCmdRet : UINT;
	END_STRUCT;
	IFmnMsgIn_Typ : 	STRUCT 
		wCmd : UINT;
		wFunction_ID : UINT;
		wMsgNumber : UINT;
		wInstance : UINT;
		wMsgHistListSetOffset : UINT; (*Offset zum ersten Eintrag im originalen Ringbuffer.*)
		wMsgHistListClassSelect : UINT; (*Bitweise kodiert.*)
		wMsgHistListEventSelect : UINT; (*Eventnummer eintragen. 1..3. 0 - Alle anzeigen*)
		wMsgStatisticSelect : UINT; (*0 - *)
	END_STRUCT;
	IFmnMsgTrig_Typ : 	STRUCT 
		xTrigPrevMsgHistListPage : BOOL;
		xTrigNextMsgHistListPage : BOOL;
		xMsgHistListPointToMin : BOOL;
		xRefreshHistList : BOOL;
		xSetHistListOffset : BOOL;
		xRefreshStatistic : BOOL;
	END_STRUCT;
	IFmnMsg_Typ : 	STRUCT 
		In : IFmnMsgIn_Typ;
		Out : IFmnMsgOut_Typ;
		Trig : IFmnMsgTrig_Typ; (*Trigger werden von außen gesetzt und im Package zurückgesetzt*)
	END_STRUCT;
END_TYPE

(*Additional Status*)

TYPE
	mnMsgStatAdMsg_Typ : 	STRUCT 
		dtMsgIntFaultChanged : DATE_AND_TIME;
		dtMsgExtFaultChanged : DATE_AND_TIME;
		dtMsgWarningChanged : DATE_AND_TIME;
		dtMsgInfoChanged : DATE_AND_TIME;
		dtMsgMaintChanged : DATE_AND_TIME;
		MsgCntFaultInt : USINT;
		MsgCntFaultExt : USINT;
		MsgCntWarning : USINT;
		MsgCntInformation : USINT;
		MsgCntMaintenance : USINT;
		bHorn : USINT;
		Reserve : ARRAY[0..1]OF USINT;
		MsgListFaultInt : ARRAY[0..MNMSG_MAX_MSGLIST]OF MsgList_Typ;
		MsgListFaultExt : ARRAY[0..MNMSG_MAX_MSGLIST]OF MsgList_Typ;
		MsgListWarning : ARRAY[0..MNMSG_MAX_MSGLIST]OF MsgList_Typ;
		MsgListInformation : ARRAY[0..MNMSG_MAX_MSGLIST]OF MsgList_Typ;
		MsgListMaintenance : ARRAY[0..MNMSG_MAX_MSGLIST]OF MsgList_Typ;
	END_STRUCT;
	mnMsgStatAd_Typ : 	STRUCT 
		Msg : mnMsgStatAdMsg_Typ;
		sPkgVersion : STRING[10];
		xReady : BOOL;
	END_STRUCT;
END_TYPE

(*Parameter*)

TYPE
	mnMsgPar_Typ : 	STRUCT 
		Mac : mnMsgParMac_Typ;
	END_STRUCT;
	mnMsgParMac_Typ : 	STRUCT 
		wModeHorn : UINT;
		wTimeOnFault : UINT;
		wTimeOffFault : UINT;
		wTimeOnWarning : UINT;
		wTimeOffWarning : UINT;
	END_STRUCT;
END_TYPE
