(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WritePVrNum.st
 * Author: hunholz
 * Created: August 18, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* REAL auf  numerische Variable schreiben *)
FUNCTION_BLOCK mnParam_WritePVrNum

	status := 0;
	
	IF pAdress = 0 THEN
		status := 1;
		RETURN;
	END_IF
	
	status := PV_xgetadr(pAdress, ADR(_lPVadress), ADR(_lPVlen));
	IF status = ERR_OK THEN
		
		status := PV_ninfo(pAdress, ADR(_lPVdataType), ADR(_lDataLen),  ADR(_wDataDimension));
		IF  status = ERR_OK THEN
			
			IF _lPVdataType = 8 THEN
				// REAL
				_pReal ACCESS _lPVadress;
				_pReal := rValue;
			ELSE
				status := 2;
			END_IF
			
		END_IF

	ELSE
		
		
	END_IF

END_FUNCTION_BLOCK
