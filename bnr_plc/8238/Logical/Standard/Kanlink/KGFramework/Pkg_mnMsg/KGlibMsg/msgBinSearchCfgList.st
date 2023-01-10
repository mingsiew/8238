(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGlibMsg
 * File: msgBinSearchCfgList.st
 * Author: hunholz
 * Created: May 30, 2011
 * Changed: June 15, 2011
 ********************************************************************
 * Implementation of library KGlibMsg
 ********************************************************************) 

(* Index der Meldung in der Meldungskonfiguration suchen *)
FUNCTION_BLOCK msgBinSearchCfgList

	wStatus := MNMSG_STAT_NOTFOUND;
	wMsgIdx := 65535;

	IF wFunctionID = 0 OR wMsgNo = 0 THEN
		RETURN;
	END_IF
	
	dMin := 1;
	dMax := UINT_TO_DINT(wCntMsgCfg);
	
	WHILE TRUE DO
		
		IF dMax < dMin THEN
			// Kein Ergebnis
			wStatus := MNMSG_STAT_NOTFOUND;
			EXIT;
		END_IF
		
		dSearch := dMin + ((dMax - dMin) / 2); 
		
		IF wFunctionID = MsgCfgList[dSearch].wFunction_ID 
			AND wMsgNo = MsgCfgList[dSearch].wMsgNumber 
			AND wInstance = MsgCfgList[dSearch].wInstance THEN
			
			wMsgIdx := DINT_TO_UINT(dSearch);
			wStatus := ERR_OK;

			EXIT;
		END_IF
			
		IF (wFunctionID > MsgCfgList[dSearch].wFunction_ID) OR 
			(wFunctionID = MsgCfgList[dSearch].wFunction_ID 
			AND wMsgNo > MsgCfgList[dSearch].wMsgNumber) OR 
			(wFunctionID = MsgCfgList[dSearch].wFunction_ID 
			AND wMsgNo = MsgCfgList[dSearch].wMsgNumber 
			AND wInstance > MsgCfgList[dSearch].wInstance) THEN

				dMin := dSearch + 1;
			
		ELSE
				
				dMax := dSearch - 1;
								
		END_IF

	END_WHILE;
	
END_FUNCTION_BLOCK
