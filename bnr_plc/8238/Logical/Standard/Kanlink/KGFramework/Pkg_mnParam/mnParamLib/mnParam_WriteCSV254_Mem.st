(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV254_Mem.st
 * Author: hunholz
 * Created: August 01, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Kommentarzeile schreiben *)
FUNCTION_BLOCK mnParam_WriteCSV254_Mem

	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 8) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0032;	// 2
			_pUtfString[1] := 16#0035;	// 5
			_pUtfString[2] := 16#0034;	// 4
			_pUtfString[3] := 16#0009;	// TAB
			
			lSize := lSize + 8;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		IF LEN(sComment) > 0 THEN

			IF (lSize + LEN(sComment)*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(sComment), 0);
			
				lSize := lSize + 2*LEN(sComment);
				
			ELSE
			
				status := 2;
				RETURN;

			END_IF

		END_IF		

		IF (lSize + 4) <= lMaxSize THEN

			_pUtfString ACCESS pMem + lSize;
		
			_pUtfString[0] := 16#000D;	// Return
			_pUtfString[1] := 16#000A;	// Linefeed

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
