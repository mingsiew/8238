(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV90_Mem.st
 * Author: hunholz
 * Created: August 02, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* String Daten schreiben *)
FUNCTION_BLOCK mnParam_WriteCSV90_Mem

	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 6) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0039;	// 9
			_pUtfString[1] := 16#0030;	// 0
			_pUtfString[2] := 16#0009;	// TAB
			
			lSize := lSize + 6;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		// IP-Adresse

		_lLen := brwcslen(ADR(IPRow.utfIP_Adress));
		
		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcscpy(pMem + lSize, ADR(IPRow.utfIP_Adress));
			
				lSize := lSize + 2* _lLen;
				
			ELSE
			
				status := 2;
				RETURN;

			END_IF
		
		END_IF

		IF (lSize + 2) <= lMaxSize THEN

			_pUtfString ACCESS pMem + lSize;
		
			_pUtfString[0] := 16#0009;	// TAB

			lSize := lSize + 2;

		ELSE
		
			status := 2;
			RETURN;

		END_IF


		// Gateway

		_lLen := brwcslen(ADR(IPRow.utfGateway));
		
		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcscpy(pMem + lSize, ADR(IPRow.utfGateway));
			
				lSize := lSize + 2* _lLen;
				
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
