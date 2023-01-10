(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteNewline_Mem.st
 * Author: hunholz
 * Created: August 02, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Leerzeile *)
FUNCTION_BLOCK mnParam_WriteNewline_Mem

	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 4) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#000D;	// Return
			_pUtfString[1] := 16#000A;	// Newline
			
			lSize := lSize + 4;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		status := 0;
		
	ELSE
		
		status := 65334;
		
	END_IF
END_FUNCTION_BLOCK
