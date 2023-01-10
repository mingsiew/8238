(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WritePVString.st
 * Author: hunholz
 * Created: July 27, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Schreibe String-Variable *)
FUNCTION_BLOCK mnParam_WritePVString

	status := 0;
	
	IF pAdress = 0 OR p_utfValue = 0 THEN
		status := 1;
		RETURN;
	END_IF
	
	status := PV_xgetadr(pAdress, ADR(_lPVadress), ADR(_lPVlen));
	IF status = ERR_OK THEN
		
		status := PV_ninfo(pAdress, ADR(_lPVdataType), ADR(_lDataLen),  ADR(_wDataDimension));
		IF  status = ERR_OK THEN

			IF _lPVdataType = 6 THEN
				
				// UINT-Array für utf-Strings
				
				brwcsncpy(_lPVadress, p_utfValue, _wDataDimension-1);
				
			ELSIF _lPVdataType = 9 THEN

				// STRING
				brsmemset(_lPVadress, 0, _lPVlen);
				
				brwcsncpy(ADR(_utfValue), p_utfValue, MIN(31, _lPVlen-1));
				brwcsconv(_lPVadress, ADR(_utfValue), 1);
				
			ELSIF _lPVdataType = 21 THEN
				
				// WSTRING
				brsmemset(_lPVadress, 0, _lPVlen);
				
				brwcsncpy(_lPVadress, p_utfValue, MIN(31, (_lPVlen/2)-1));
				
			ELSE
				
				status := 2;

			END_IF
		END_IF
	END_IF

END_FUNCTION_BLOCK
