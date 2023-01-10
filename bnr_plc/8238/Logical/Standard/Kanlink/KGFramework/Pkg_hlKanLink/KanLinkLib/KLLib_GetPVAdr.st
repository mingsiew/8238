(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: WetLinkLib
 * File: WLLib_GetPVAdr.st
 * Author: stahlhut
 * Created: January 06, 2012
 ********************************************************************
 * Implementation of library WetLinkLib
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION KLLib_GetPVAdr
	iStat := PV_xgetadr((ServerItem.pReqStr),ADR(ServerItem.AdrDataReq),ADR(ServerItem.ReqLength));
	IF iStat <> 0 THEN // fehler aufgetreten
 		ServerItem.AdrDataReq := 0;
		ServerItem.ReqLength := 0;
	END_IF;
	iStat := PV_xgetadr((ServerItem.pRespStr),ADR(ServerItem.AdrDataResp),ADR(ServerItem.RespLength));
	IF iStat <> 0 THEN // fehler aufgetreten
 		ServerItem.AdrDataResp := 0;
		ServerItem.RespLength := 0;
	END_IF;
	KLLib_GetPVAdr := 0;		 	
END_FUNCTION
