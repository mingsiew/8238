(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WritePVNum.st
 * Author: hunholz
 * Created: July 27, 2011
 * Changed: November 28, 2011
 * ###AH20111128 DINT_TO_UINT gegen DINT_TO_UDINT getauscht. UDINT wurde abgeschnitten.
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* DINT auf beliebige, numerische Variable schreiben *)
FUNCTION_BLOCK mnParam_WritePVNum

	status := 0;
	
	IF pAdress = 0 THEN
		status := 1;
		RETURN;
	END_IF
	
	status := PV_xgetadr(pAdress, ADR(_lPVadress), ADR(_lPVlen));
	
	IF status = ERR_OK THEN
		
		status := PV_ninfo(pAdress, ADR(_lPVdataType), ADR(_lDataLen),  ADR(_wDataDimension));
		
		IF  status = ERR_OK THEN
			
			IF _lPVdataType = 1 THEN
				// Bool
				_pBool ACCESS _lPVadress;
				_pBool := DINT_TO_BOOL(LIMIT(0, diValue ,1));
			ELSIF _lPVdataType = 2 THEN
				// SINT
				_pSint ACCESS _lPVadress;
				_pSint := DINT_TO_SINT(LIMIT(-128, diValue, 127));
			ELSIF _lPVdataType = 3 THEN
				// INT
				_pInt ACCESS _lPVadress;
				_pInt := DINT_TO_INT(LIMIT(-32768, diValue, 32767));
			ELSIF _lPVdataType = 4 THEN
				// DINT
				_pDint ACCESS _lPVadress;
				_pDint := diValue;
			ELSIF _lPVdataType = 5 THEN
				// USINT
				_pUsint ACCESS _lPVadress;
				_pUsint := DINT_TO_USINT(LIMIT(0,diValue,255));
			ELSIF _lPVdataType = 6 THEN
				// UINT
				_pUint ACCESS _lPVadress;
				_pUint := DINT_TO_UINT(LIMIT(0,diValue,65535));
			ELSIF _lPVdataType = 7 THEN
				// UDINT
				_pUdint ACCESS _lPVadress;
				_pUdint := DINT_TO_UDINT(LIMIT(0,diValue,16#7FFFFFFF));
			ELSIF _lPVdataType = 8 THEN
				// REAL
				_pReal ACCESS _lPVadress;
				_pReal := DINT_TO_REAL(diValue);
			ELSIF _lPVdataType = 11 THEN
				// DATE_AND_TIME
				_pDT ACCESS _lPVadress;
				_pDT := DINT_TO_DT(diValue);
			ELSIF _lPVdataType = 12 THEN
				// TIME
				_pT ACCESS _lPVadress;
				_pT := DINT_TO_TIME(diValue);
			ELSE
				status := 2;
			END_IF
			
		END_IF

	END_IF

END_FUNCTION_BLOCK
