(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: pkg_sqlreq
 * File: pkg_sqlreq.typ
 * Author: hunholz
 * Created: April 05, 2011
 ********************************************************************
 * Data types of package pkg_sqlreq
 ********************************************************************)

TYPE
	hlDFIIStatAd_typ : 	STRUCT 
		sPkgVersion : STRING[10];
	END_STRUCT;
	hlDFIIParMacConn_typ : 	STRUCT 
		bDBservReg : USINT := 3;
		bDBservAdr : USINT := 202;
		wDBservPort : UINT := 1433;
		sServInst : STRING[15];
		sDBname : STRING[15] := 'DFII';
		wIdletimeDisconnect : UINT := 10;
	END_STRUCT;
	hlDFIIParMac_typ : 	STRUCT 
		DFIIConn : hlDFIIParMacConn_typ;
		TrackConn : hlDFIIParMacConn_typ;
	END_STRUCT;
	hlDFIIPar_typ : 	STRUCT 
		Mac : hlDFIIParMac_typ;
	END_STRUCT;
	IFhlDFII_typ : 	STRUCT 
		In : IFhlDFII_In_typ;
		Out : IFhlDFII_Out_typ;
	END_STRUCT;
	IFhlDFII_Out_typ : 	STRUCT 
		wStatus : UINT;
		xConnected : BOOL;
		xTrackConnected : BOOL;
		sStatusTracking : STRING[127];
		RespProgByCat : IFhlDFII_Out_RespProgByCat_typ;
		RespMsgEvt : IFhlDFII_Out_RespMsgEvt_typ;
		RespCntBatchEvt : IFhlDFII_Out_RespCntBatchEvt_typ;
		RespCntCntEvt : IFhlDFII_Out_RespCntCntEvt_typ;
		RespCntTimEvt : IFhlDFII_Out_RespCntTimEvt_typ;
		RespCntDosEvt : IFhlDFII_Out_RespCntDosEvt_typ;
	END_STRUCT;
	IFhlDFII_Out_RespProgByCat_typ : 	STRUCT 
		wResponse : UINT; (*0 - idle, 1 - req num OK, 2 - req alpha OK, 65535 - busy*)
		bProgramNo : USINT;
		sProgramName : STRING[31];
		sCategoryName : STRING[31];
		wLoadrate : UINT;
		rSoilfactor : REAL;
		wColorIdxFor : UINT;
		wColorIdxBack : UINT;
	END_STRUCT;
	IFhlDFII_Out_RespMsgEvt_typ : 	STRUCT 
		wResponse : UINT; (*0 - idle, 1 - req OK, 65535 - busy*)
	END_STRUCT;
	IFhlDFII_Out_RespCntBatchEvt_typ : 	STRUCT 
		wResponse : UINT; (*0 - idle, 1 - req, OK, 65535 - busy*)
	END_STRUCT;
	IFhlDFII_Out_RespCntCntEvt_typ : 	STRUCT 
		wResponse : UINT; (*0 - idle, 1 - req, OK, 65535 - busy*)
	END_STRUCT;
	IFhlDFII_Out_RespCntTimEvt_typ : 	STRUCT 
		wResponse : UINT; (*0 - idle, 1 - req, OK, 65535 - busy*)
	END_STRUCT;
	IFhlDFII_Out_RespCntDosEvt_typ : 	STRUCT 
		wResponse : UINT; (*0 - idle, 1 - req, OK, 65535 - busy*)
	END_STRUCT;
	IFhlDFII_In_typ : 	STRUCT 
		utfMachineType : WSTRING[15];
		ReqProgByCat : IFhlDFII_In_ReqProgByCat_typ;
		ReqMsgEvt : IFhlDFII_In_ReqMsgEvt_typ;
		ReqCntBatchEvt : IFhlDFII_In_ReqCntBatchEvt_typ;
		ReqCntCntEvt : IFhlDFII_In_ReqCntCntEvt_typ;
		ReqCntTimEvt : IFhlDFII_In_ReqCntTimEvt_typ;
		ReqCntDosEvt : IFhlDFII_In_ReqCntDosEvt_typ;
		ReqUpdStatus : ARRAY[1..HLDFII_MAXIDX_REQ_UPDATESTATUS]OF IFhlDFII_In_ReqUpdStatus_typ;
		ReqUpdBatch : ARRAY[1..HLDFII_MAXIDX_REQ_UPDATEBATCH]OF IFhlDFII_In_ReqUpdBatch_typ;
	END_STRUCT;
	IFhlDFII_In_ReqProgByCat_typ : 	STRUCT 
		wRequest : UINT; (*0 - idle, 1 - req num, 2 - req alpha*)
		sCategoryNo_In : STRING[11];
	END_STRUCT;
	IFhlDFII_In_ReqMsgEvt_typ : 	STRUCT 
		wRequest : UINT; (*0 - idle, 1 - req*)
		bCntLines : USINT; (*1..5*)
		MsgHistList : ARRAY[1..5]OF MsgHistList_Typ;
	END_STRUCT;
	IFhlDFII_In_ReqCntBatchEvt_typ : 	STRUCT 
		wRequest : UINT; (*0 - idle, 1 - request*)
		bCntLines : USINT; (*1..5*)
		CntBatchEvtList : ARRAY[1..5]OF mnCntEventBatch_Typ;
	END_STRUCT;
	IFhlDFII_In_ReqCntCntEvt_typ : 	STRUCT 
		wRequest : UINT; (*0 - idle, 1 - request*)
		bCntLines : USINT; (*1..5*)
		CntCounterEvtList : ARRAY[1..5]OF mnCntEventCounter_Typ;
	END_STRUCT;
	IFhlDFII_In_ReqCntTimEvt_typ : 	STRUCT 
		wRequest : UINT; (*0 - idle, 1 - request*)
		bCntLines : USINT; (*1..5*)
		CntTimerEvtList : ARRAY[1..5]OF mnCntEventTime_Typ;
	END_STRUCT;
	IFhlDFII_In_ReqCntDosEvt_typ : 	STRUCT 
		wRequest : UINT; (*0 - idle, 1 - request*)
		bCntLines : USINT; (*1..5*)
		CntDosingEvtList : ARRAY[1..5]OF mnCntEventDosingId_Typ;
	END_STRUCT;
	IFhlDFII_In_ReqUpdStatus_typ : 	STRUCT 
		wStatusX : UINT;
		wSubState : UINT;
		sSubState : STRING[23];
		xEnable : BOOL;
		lMachineNo : UDINT;
	END_STRUCT;
	IFhlDFII_In_ReqUpdBatch_typ : 	STRUCT 
		dtTimeStamp : DATE_AND_TIME;
		lMachineNo : UDINT;
		bBatchNo : ARRAY[0..15]OF USINT;
		wLocation : UINT;
		wElement : UINT;
	END_STRUCT;
END_TYPE
