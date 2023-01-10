(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: Kanlink Cmd 1004 Status Information
 * File: CmdSI.typ
 * Author: Horn
 * Created: 02.03.2016
 ********************************************************************
 * Data types of library Kanlink
 ********************************************************************)
(*Kommando*)

TYPE
	KLreq1004_Status_typ : 	STRUCT 
		wCntPositions : UINT;
		wCmdReq : UINT;
		wNoOfPosition : ARRAY[0..11]OF UINT;
	END_STRUCT;
	KLresp1004_Status_typ : 	STRUCT 
		wCntPositions : UINT;
		wCmdResp : UINT;
		wNoOfPositions : ARRAY[0..11]OF UINT;
		StatusInfo : ARRAY[0..11]OF StatusInfo_typ;
	END_STRUCT;
	KL_SI_typ : 	STRUCT 
		Req : KLreq1004_Status_typ;
		Resp : KLresp1004_Status_typ;
	END_STRUCT;
	StatusInfo_typ : 	STRUCT 
		wStatusX : UINT;
		wSubState : UINT;
		wData1 : UINT;
		wData2 : UINT;
	END_STRUCT;
	StatusDataCmd1_typ : 	STRUCT 
		wRemainCycleTime : UINT; (*Resttaktzeit bis zum Transfer*)
		wTargetCycleTime : UINT; (*Solltektzeit ohne Verkürzung oder Verlängerung*)
	END_STRUCT;
END_TYPE
