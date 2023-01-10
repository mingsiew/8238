(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgInitBatchNoLong.st
 * Author: hunholz
 * Created: January 31, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Legt ggf. Datenobjekt zum Speichern der laufenden Postennummer an *)
FUNCTION_BLOCK kgInitBatchNoLong

	IF Enable AND _bStep = 0 THEN
		_bStep := 1;
	END_IF
	
	IF _bStep = 1 AND NOT Enable THEN
		_bStep := 0;
	END_IF

	CASE _bStep OF
		
		0: // Enable ist FALSE

			Status := ERR_FUB_ENABLE_FALSE;

		1: // Enable ist TRUE
		
			_diBatchNo(enable := TRUE, pName := ADR('_BatchNo'));
			
			IF _diBatchNo.status = doERR_MODULNOTFOUND THEN
				
				Status := ERR_FUB_BUSY;
				
				_bStep := 2;
				
			ELSE
			
				Status := _diBatchNo.status;
			
			END_IF
			
		2: // Create DO
			
			_dcBatchNo.enable := TRUE;
			_dcBatchNo.len := SIZEOF(_BatchNo);
			_dcBatchNo.MemType := doUSRROM;
			_dcBatchNo.pName := ADR('_BatchNo');
		
			_dcBatchNo();
			
			Status := _dcBatchNo.status;
		
			IF _dcBatchNo.status <> ERR_FUB_BUSY THEN
				_bStep := 1;
			END_IF
			
	END_CASE
	
END_FUNCTION_BLOCK