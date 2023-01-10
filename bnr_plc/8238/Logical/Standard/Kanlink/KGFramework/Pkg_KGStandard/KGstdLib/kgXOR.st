(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgXOR.st
 * Author: hunholz
 * Created: March 07, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* XOR über Byte-Feld *)
FUNCTION kgXOR
	
	_xStatusOk := pStatus > 0;
	
	kgXOR := 0;
	
	IF _xStatusOk THEN
		_wDynStatus ACCESS pStatus;
		_wDynStatus := ERR_OK;
	END_IF
	
	_xWordResultOk := pWordResult > 0;
	
	IF _xWordResultOk THEN
		
		_bWordResult ACCESS pWordResult;
		
	END_IF
	
	IF pMem = 0 THEN
		IF _xStatusOk THEN
			_wDynStatus := KG_ERR_NULPOINTER;
		END_IF
		RETURN;
	
	ELSE
		
		_bMem ACCESS pMem;
		
	END_IF
	
	kgXOR := bInit;
	
	FOR _i := 1 TO wLen DO
	
		kgXOR := kgXOR XOR _bMem[_i];
		
	END_FOR
	
	IF _xWordResultOk THEN
		
		_bWordResult[0] := kgXOR;
		_bWordResult[1] := kgXOR;
		
	END_IF
		
END_FUNCTION