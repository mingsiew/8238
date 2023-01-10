(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: kgatoi_uint.st
 * Author: hunholz
 * Created: June 28, 2011
 ********************************************************************
 * Implementation of library KGstd
 ********************************************************************) 

(* atoi für UINT mit Fehlermeldung *)
FUNCTION kgatoi_uint

	num := 0;
	
	_result := 0;
	
	_len := LEN(str);
	
	_sdigit := '0';
	_bdigit ACCESS ADR(_sdigit);
	
	_mul := 1;
	
	// Ist String generell zu lang ?
	IF _len > 5 THEN
	
		_result := 1;
	
	ELSIF _len > 0 THEN
		
		FOR _i := _len TO 1 BY -1 DO
			
			_sdigit := MID(str,1, _i);
			
			// Auf ungültiges Zeiche prüfen
			IF (_bdigit < 48 OR _bdigit > 57) THEN
				_result := 2;
				num := 0;
				EXIT;
			ELSE
				_digit := _bdigit - 48;
			END_IF
			
			
			// Auf Wertüberlauf prüfen
			IF _len = 5 AND _i = 1 THEN
				
				IF _digit > 6 OR (_digit = 6 AND num > 5535) THEN
					_result := 3;
					num := 0;
					EXIT;
				END_IF
					
			END_IF			

			num := num + (_digit * _mul);
			
			IF (_i <> 1) THEN
				_mul := _mul * 10;
			END_IF
			
		END_FOR
		
	END_IF
	
	kgatoi_uint := _result;


END_FUNCTION
