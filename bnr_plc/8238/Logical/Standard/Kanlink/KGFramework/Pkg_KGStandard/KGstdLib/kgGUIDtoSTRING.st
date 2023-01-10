(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgGUIDtoSTRING.st
 * Author: hunholz
 * Created: November 17, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* GUID-String erzeugen *)
FUNCTION_BLOCK kgGUIDtoSTRING
	
	usintarray ACCESS ADR(GUID);

	brsmemset(ADR(sOut), 0, SIZEOF(sOut));
	
	_StringArray ACCESS ADR(sOut);

	_Ptr := 0;
	
	FOR _i := 0 TO 15 DO
		
		_b := (usintarray[_i] / 16);
		
		IF _b < 10 THEN			
			_StringArray[_Ptr] := _b + 48;
		ELSE
			_StringArray[_Ptr] := _b + 65;
		END_IF
		
		_Ptr := _Ptr + 1;

		_b := (usintarray[_i] MOD 16);

		IF _b < 10 THEN			
			_StringArray[_Ptr] := _b + 48;
		ELSE
			_StringArray[_Ptr] := _b + 65;
		END_IF

		_Ptr := _Ptr + 1;
		
		IF _i = 3 OR _i = 5 OR _i = 7 OR _i = 9 THEN
			
			_StringArray[_Ptr] := 45; // '-'
			_Ptr := _Ptr + 1;

		END_IF
		
	END_FOR
		
END_FUNCTION_BLOCK