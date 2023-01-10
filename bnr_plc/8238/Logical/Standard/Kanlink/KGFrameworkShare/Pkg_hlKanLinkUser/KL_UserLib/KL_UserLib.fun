(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: WL_UserLib
 * File: WL_UserLib.fun
 * Author: stahlhut
 * Created: January 10, 2012
 ********************************************************************
 * Functions and function blocks of library WL_UserLib
 ********************************************************************)

FUNCTION KL_OnRecReq : UDINT (*Wird aufgerufen bei Empfang eines Requests*)
	VAR_INPUT
		adrReqData : UDINT;
		adrRespData : UDINT;
		adrKanlink : UDINT;
		iCmdNr : UINT; (*Empfangene Commandnr*)
		adrUserData : UDINT;
	END_VAR
	VAR
		_dKl : REFERENCE TO KanLink_FB;
		_dResp : REFERENCE TO KLresp1002_Info_typ;
		s : INT;
		_dReq : REFERENCE TO KLreq1002_Info_typ;
		_i : UINT;
		_dUserData : REFERENCE TO KL_UserTyp;
		_dBI : REFERENCE TO ARRAY[0..30] OF Batch_typ;
		_iNr : UINT;
	END_VAR
END_FUNCTION
