(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: WetLink
 * File: WLLib_InitCltPV.st
 * Author: stahlhut
 * Created: January 06, 2012
 ********************************************************************
 * Implementation of program WetLink
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION KLLib_InitCltPV
	iStat  := PV_xgetadr((dclt.pReq),ADR(dclt.AdrDataReq),ADR(dclt.ReqLength));
	IF iStat <> 0 THEN // fehler aufgetreten
 		dclt.AdrDataReq := 0;
		dclt.ReqLength := 0;
	END_IF;

	iStat := PV_xgetadr((dclt.pResp),ADR(dclt.AdrDataResp),ADR(dclt.RespLength));
	IF iStat <> 0 THEN // fehler aufgetreten
 		dclt.AdrDataResp := 0;
		dclt.RespLength := 0;
	END_IF;
	KLLib_InitCltPV := 0;
END_FUNCTION
