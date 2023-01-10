(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: Kanlink Cmd 1002 Batch Information
 * File: WetLinkLib.typ
 * Author: stahlhut
 * Created: 20.03.2012
 ********************************************************************
 * Data types of library Kanlink
 ********************************************************************)
(*Kommando*)

TYPE
	KLreq1002_Info_typ : 	STRUCT 
		wCntPositions : UINT;
		wNoOfPosition : ARRAY[0..5]OF UINT;
		wRes : UINT;
	END_STRUCT;
	KLresp1002_Info_typ : 	STRUCT 
		wCntPositions : UINT;
		wNoOfPositions : ARRAY[0..5]OF UINT;
		wRes : UINT;
		BatchData : ARRAY[0..5]OF BatchData_typ;
	END_STRUCT;
	KL_BI_typ : 	STRUCT 
		Req : KLreq1002_Info_typ;
		Resp : KLresp1002_Info_typ;
	END_STRUCT;
END_TYPE
