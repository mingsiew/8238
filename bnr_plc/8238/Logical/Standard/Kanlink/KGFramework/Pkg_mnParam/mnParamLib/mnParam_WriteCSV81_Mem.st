(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV81_Mem.st
 * Author: hunholz
 * Created: Mar 29, 2012
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* String Daten schreiben *)
FUNCTION_BLOCK mnParam_WriteCSV81_Mem

	IF enable THEN
		
		status := ERR_OK;
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 6) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0038;	// 8
			_pUtfString[1] := 16#0031;	// 1
			_pUtfString[2] := 16#0009;	// TAB
			
			lSize := lSize + 6;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		// Category

		_lLen := LEN(CPRow.sCategory);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(CPRow.sCategory), 0);
			
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

		// Categoryname schreiben

		_lLen := brwcslen(ADR(CPRow.utfCategoryName));
		
		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcscpy(pMem + lSize, ADR(CPRow.utfCategoryName));
			
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

		// Programmno
		
		brsitoa(CPRow.wProgramNo, ADR(_sValue));
		
		_lLen := LEN(_sValue);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sValue), 0);
			
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
		
		// Zeitstempel
		
		_dttoa(dtTimestamp := CPRow.dtTimeStamp);
		
		IF (lSize + 38 ) <= lMaxSize THEN

			brwcsconv(pMem + lSize, ADR(_dttoa.sDateTime), 0);
		
			lSize := lSize + 38;
			
		ELSE
		
			status := 2;
			RETURN;

		END_IF

		IF (lSize + 2) <= lMaxSize THEN

			_pUtfString ACCESS pMem + lSize;
		
			_pUtfString[0] := 16#0009;	// TAB

			lSize := lSize + 2;

		ELSE
		
			status := 2;
			RETURN;

		END_IF


		// Soilfactor
		
		_sValue := REAL_TO_STRING(CPRow.rSoilfactor);
		
		_lLen := LEN(_sValue);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sValue), 0);
			
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


		// Loadrate
		
		_sValue := UINT_TO_STRING(CPRow.wLoadrate);
		
		_lLen := LEN(_sValue);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sValue), 0);
			
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
		

		// Foreground color
		
		_sValue := UINT_TO_STRING(CPRow.wColFor);
		
		_lLen := LEN(_sValue);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sValue), 0);
			
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
		

		// Background color
		
		_sValue := UINT_TO_STRING(CPRow.wColBack);
		
		_lLen := LEN(_sValue);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sValue), 0);
			
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
		
	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		
	END_IF	

END_FUNCTION_BLOCK
