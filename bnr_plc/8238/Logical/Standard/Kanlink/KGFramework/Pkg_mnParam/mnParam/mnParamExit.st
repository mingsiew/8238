(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: mnParamExit.st
 * Author: hunholz
 * Created: December 20, 2011
 *******************************************************************)

PROGRAM _EXIT

	IF _MemPartCreate.ident > 0 THEN
		
		_MemPartDestroy(enable := TRUE, ident := _MemPartCreate.ident);
		
	END_IF
	
END_PROGRAM