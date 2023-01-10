(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgArLogWrite.st
 * Author: hunholz
 * Created: December 19, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Checks ident on > 0 and formats string with two numbers *)
FUNCTION_BLOCK kgArLogWrite
	
	IF ident > 0 THEN
		
		_kgLogLine(sLoglineTemplate := text, lAttr1 := var1, lAttr2 := var2);
		
		_AsArLogWrite(enable := enable, ident := ident, logLevel := logLevel, errornr := errornr, mem := 0, len := 0, asciiString := _kgLogLine.pLogline);
		
		status := _AsArLogWrite.status;
		
	ELSE
		
		status := 1;
		
	END_IF
	
END_FUNCTION_BLOCK