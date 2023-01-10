(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Cmd 30002/Wetextraction
 * File: CmdWetExt.typ
 * Author: stahlhut
 * Created: 20.03.2012
 ********************************************************************
 * Data types of library KanlinkLib
 ********************************************************************)

TYPE
	KL_WetExtNextBatch_typ : 	STRUCT  (*Nächster Posten Entwässerung "Letzte Kammer"*)
		wProgNr : UINT;
		wWeight : UINT;
		bBatchNo : ARRAY[0..15]OF USINT;
		bTypeBatchNo : USINT;
	END_STRUCT;
	KL_WetExtRespDos_typ : 	STRUCT 
		xRunning : BOOL; (*Dosierung aktiv*)
		xJobDone : BOOL; (*Dosierung beendet*)
	END_STRUCT;
	KL_WetExtReqDos_typ : 	STRUCT 
		lAmount : UDINT; (*Dosiermenge für Posten*)
		xEnable : BOOL; (*Dosieren*)
	END_STRUCT;
	KL_WetExtTankInfo_typ : 	STRUCT 
		wNr : UINT;
		xReady : BOOL;
		iTemperature : INT;
	END_STRUCT;
	KL_WetExtractResp_typ : 	STRUCT 
		wState : UINT; (*Status der Entwässerung / nach Tis*)
		wNiveau : UINT;
		DosState : ARRAY[0..8]OF KL_WetExtRespDos_typ; (*Dosierungsstatus*)
		WetAccState : ARRAY[0..4]OF KL_WetExtTankInfo_typ;
		NextBatch : KL_WetExtNextBatch_typ;
	END_STRUCT;
	KL_WetExtractReq_typ : 	STRUCT 
		wState : UINT; (*Status der Entwässerung / nach Tis*)
		wRecycleDest : UINT; (*Ziel der Rückgewinnung*)
		Dosage : ARRAY[0..8]OF KL_WetExtReqDos_typ;
		xFlush : BOOL; (*Schüttenspülung*)
		wReqTankInfo : ARRAY[0..4]OF UINT; (*Tankinfo für Nr xxx*)
		xTankReq : ARRAY[0..4]OF BOOL;
		xDrain : BOOL;
		xPump : BOOL;
		sCategory : STRING[11];
	END_STRUCT;
	KL_WetExtract_typ : 	STRUCT 
		Resp : KL_WetExtractResp_typ;
		Req : KL_WetExtractReq_typ;
	END_STRUCT;
END_TYPE
