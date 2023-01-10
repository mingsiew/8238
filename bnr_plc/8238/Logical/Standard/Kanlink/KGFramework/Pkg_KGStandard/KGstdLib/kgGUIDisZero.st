(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgGUIDisZero.st
 * Author: hunholz
 * Created: January 03, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Prüfen, ob alle 16 Byte der GUID 0 sind. *)
FUNCTION kgGUIDisZero
	
	_bGUID ACCESS ADR(GUID);
	
	kgGUIDisZero := TRUE;
	
	FOR _i := 0 TO 15 DO
		IF _bGUID[_i] > 0 THEN
			kgGUIDisZero := FALSE;
			EXIT;
		END_IF			
	END_FOR
	
END_FUNCTION