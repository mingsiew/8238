(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KL_UserLib
 * Datei: KL_OnRecReq.st
 * Autor: stahlhut
 * Erstellt: 16. Januar 2012
 ********************************************************************
 * Implementierung der Library KL_UserLib
 ********************************************************************) 

(* Wird aufgerufen bei Empfang eines Requests *)
FUNCTION KL_OnRecReq
	_dKl ACCESS adrKanlink;
	s :=  _dKl.Step;
			
	
	IF (adrKanlink = 0 ) OR (adrReqData = 0) OR (adrRespData = 0) OR (adrUserData = 0) THEN 
		KL_OnRecReq := 1; // fehler melden
		RETURN;
	END_IF;	
	
	_dUserData ACCESS adrUserData;
	_dBI ACCESS  _dUserData.adrBatch;
	// Batchinfo bearbeiten
	IF iCmdNr = 1002 THEN 
		_dReq ACCESS adrReqData;
		_dResp ACCESS adrRespData;
		
		FOR _i := 0 TO 5 DO 
			IF _dReq.wNoOfPosition[_i] > 30 THEN
				_iNr := 30;
			ELSE  
				_iNr := _dReq.wNoOfPosition[_i]; 
			END_IF;	
			_dResp.BatchData[_i] :=   _dBI[_iNr].BatchData;
			_dResp.wNoOfPositions[_i] := _iNr;  //  _dReq.wNoOfPosition[_i];
		END_FOR;
		
	END_IF;
	
END_FUNCTION