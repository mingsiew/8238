(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteBOM_Mem.st
 * Author: hunholz
 * Created: August 01, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Byte Order Mark *)
FUNCTION_BLOCK mnParam_WriteBOM_Mem

	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 2) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem;
			
			_pUtfString := 16#FEFF;	// BOM
			
			lSize := lSize + 2;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		status := 0;
		
	ELSE
		
		status := 65334;
		
	END_IF

END_FUNCTION_BLOCK
