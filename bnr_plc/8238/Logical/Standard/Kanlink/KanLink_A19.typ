(********************************************************************
 * COPYRIGHT -- HP
 ********************************************************************
 * Package: KanLink_A7
 * File: KanLink_A7.typ
 * Author: treamsbottom
 * Created: January 28, 2013
 ********************************************************************
 * Data types of package KanLink_A7
 ********************************************************************)

TYPE
	IP_Type : 	STRUCT 
		Area : UINT;
		Adr : UINT;
		CmdOpt : UINT;
		AdvMode : BOOL := FALSE;
		AdrAdvMode : STRING[15];
		CommID : USINT;
	END_STRUCT;
	KanOVClient_typ : 	STRUCT 
		IP : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS]OF IP_Type;
		Enable : BOOL;
		MaxConns : UINT;
		InfoReq : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS]OF BatchInfo_typ;
		InfoResp : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS]OF InfoResp_typ;
		StatusReg : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS]OF UINT;
		IndexOffset : UINT;
		CANOffset : UINT; (**Can offset for CAN live index passed to Tview*)
	END_STRUCT;
	KanOVServer_typ : 	STRUCT 
		IP : ARRAY[0..HLKANLINK_MAX_SERVERCONNS]OF IP_Type;
		Enable : BOOL;
		MaxConns : UINT;
		InfoResp : ARRAY[0..HLKANLINK_MAX_SERVERCONNS]OF KLresp1002_Info_typ;
		IndexOffset : UINT;
	END_STRUCT;
	KANServer_typ : 	STRUCT 
		IP : ARRAY[0..HLKANLINK_MAX_SERVERCONNS]OF IP_Type;
		Enable : BOOL;
		MaxConns : UINT;
	END_STRUCT;
	KanLinkCon_Typ : 	STRUCT 
		Server : KANServer_typ;
		Client : KANClient_typ;
		OverviewServer : KanOVServer_typ;
		OverviewClient : KanOVClient_typ;
		ErrorString : STRING[80];
		GlobalSettings : KAN_Settings;
	END_STRUCT;
	KANClient_typ : 	STRUCT 
		IP : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS]OF IP_Type;
		Enable : BOOL;
		MaxConns : UINT;
	END_STRUCT;
	BagNums_typ : 	STRUCT 
		BagNums : ARRAY[0..6]OF UINT;
	END_STRUCT;
	KANBatch_typ : 	STRUCT 
		BatchData : ARRAY[0..6]OF BatchData_typ;
	END_STRUCT;
	BatchInfo_typ : 	STRUCT 
		wCntPositions : UINT;
		wNoOfPosition : ARRAY[0..HLKANLINK_MAX_OVERVIEW_DATA]OF UINT;
		wRes : UINT;
	END_STRUCT;
	InfoResp_typ : 	STRUCT 
		BagNum : ARRAY[0..HLKANLINK_MAX_OVERVIEW_DATA]OF UINT;
	END_STRUCT;
	KAN_Settings : 	STRUCT 
		UseBatchCode : BOOL;
		TransferProgramCode : BOOL; (**This puts the cat code in custom area and transfers the prg code to the m/c*)
		BatchCodeTyp : USINT;
		TransferProgin_bCustom : BOOL;
	END_STRUCT;
END_TYPE
