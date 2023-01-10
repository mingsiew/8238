(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV255_Mem.st
 * Author: hunholz
 * Created: August 01, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* File-Ende schreiben *)
FUNCTION_BLOCK mnParam_WriteCSV255_Mem
	
	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 10) > lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0032;	// 2
			_pUtfString[1] := 16#0035;	// 5
			_pUtfString[2] := 16#0035;	// 5
			_pUtfString[3] := 16#000D;	// Return
			_pUtfString[4] := 16#000A;	// Linefeed
			
			lSize := lSize + 10;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		status := 0;
		
	ELSE
		
		status := 65334;
		
	END_IF

END_FUNCTION_BLOCK
