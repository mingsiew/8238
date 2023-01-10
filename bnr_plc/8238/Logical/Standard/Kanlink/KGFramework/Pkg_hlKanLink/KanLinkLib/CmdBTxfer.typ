(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: Kanlink Commando 1000 BatchTransfer
 * File: 
 * Author: stahlhut
 * Created: 20.03.2012
 ********************************************************************
 * Data types of library WetLinkLib
 ********************************************************************)
(*Interne Strukturen*)

TYPE
	KL_BTxf_typ : 	STRUCT  (*Batch Transfer Server*)
		Req : KLreq1000_BTH_typ;
		Resp : KLresp1000_BTH_typ;
	END_STRUCT;
	KLreq1000_BTH_typ : 	STRUCT 
		xHready : BOOL;
		xHreadyForLoad : BOOL;
		xHbatchReceived : BOOL;
		xHtransferzoneOccupied : BOOL;
		xHreqCtrlTransfer : BOOL;
		xHtransferRunning : BOOL;
		xHwaitingForTransfer : BOOL;
		xHshiftBatches : BOOL;
		wHstate : UINT;
		bHcmdAutomatic : USINT;
		xHreserve : ARRAY[1..5]OF BOOL;
		wTimeToReadyForLoad : UINT;
		wRemainProctime : UINT; (*Remaining Processtime / Verbleibende Prozesszeit*)
	END_STRUCT;
	KLresp1000_BTH_typ : 	STRUCT 
		xHsCmdFinishProcess : BOOL;
		xHsReqForUnload : BOOL;
		xHsUnloading : BOOL;
		xHsReqCtrlTransfer : BOOL;
		xHsTransferRunning : BOOL;
		xHsRes : BOOL;
		wState : UINT;
		bCmdAuto : USINT;
		xCmdStartProcess : BOOL;
		xHsDataValid : BOOL;
		xHsRes2 : ARRAY[0..2]OF BOOL;
		wCntLoads : UINT;
		BatchData : BatchData_typ;
	END_STRUCT;
END_TYPE
