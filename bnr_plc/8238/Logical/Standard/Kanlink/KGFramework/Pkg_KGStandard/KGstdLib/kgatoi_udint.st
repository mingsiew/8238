(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: kgatoi_udint.st
 * Author: hunholz
 * Created: June 23, 2011
 ********************************************************************
 * Implementation of library KGstd
 ********************************************************************) 

(* String in UDINT wandeln *)
FUNCTION kgatoi_udint
	
	num := 0;
	
	_result := 0;
	
	_len := LEN(str);
	
	_sdigit := '0';
	_bdigit ACCESS ADR(_sdigit);
	
	_mul := 1;
	
	// Ist String generell zu lang ?
	IF _len > 10 THEN
	
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
			IF _len = 10 AND _i = 1 THEN
				
				IF _digit > 4 OR (_digit = 4 AND num > 294967295) THEN
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
	
	kgatoi_udint := _result;

END_FUNCTION
