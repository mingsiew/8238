(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV251_Mem.st
 * Author: hunholz
 * Created: August 02, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Dateizeitstempel schreiben *)
FUNCTION_BLOCK mnParam_WriteCSV251_Mem

	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 8) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0032;	// 2
			_pUtfString[1] := 16#0035;	// 5
			_pUtfString[2] := 16#0031;	// 1
			_pUtfString[3] := 16#0009;	// TAB
			
			lSize := lSize + 8;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		// Zeitstempel schreiben

		_dttoa(dtTimestamp := TimeRow.dtTimestamp);
		
		IF (lSize + 38 ) <= lMaxSize THEN

			brwcsconv(pMem + lSize, ADR(_dttoa.sDateTime), 0);
		
			lSize := lSize + 38;
			
		ELSE
		
			status := 2;
			RETURN;

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
