(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: kgitoa_udint.st
 * Author: hunholz
 * Created: June 23, 2011
 ********************************************************************
 * Implementation of library KGstd
 ********************************************************************) 

(* Wandelt UDINT in String *)
FUNCTION kgitoa_udint
	
	_num := num;
	str := '';
	_sdigit := '0';
	_bdigit ACCESS ADR(_sdigit);
	
	REPEAT
		
		_digit := _num MOD 10;
		
		_bdigit := 48 + UDINT_TO_USINT(_digit);
		str := INSERT(str,_sdigit,0);
		
		_num := _num / 10;
		
	UNTIL
		_num = 0
	END_REPEAT;
	
	kgitoa_udint := 0;

END_FUNCTION
