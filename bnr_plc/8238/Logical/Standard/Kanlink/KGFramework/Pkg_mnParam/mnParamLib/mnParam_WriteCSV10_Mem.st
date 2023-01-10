(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV10_Mem.st
 * Author: hunholz
 * Created: August 02, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Datenzeile numerisch schreiben *)
FUNCTION_BLOCK mnParam_WriteCSV10_Mem
	
	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 6) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0031;	// 1
			_pUtfString[1] := 16#0030;	// 0
			_pUtfString[2] := 16#0009;	// TAB
			
			lSize := lSize + 6;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		// IdxNumPar schreiben

		brsitoa(NumRow.wIdxNumPar, ADR(_sNumeric));
		
		_lLen := LEN(_sNumeric);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sNumeric), 0);
			
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

		// Value schreiben

		brsitoa(NumRow.diValue, ADR(_sNumeric));
		
		_lLen := LEN(_sNumeric);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sNumeric), 0);
			
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

		// 1 Array Index

		brsitoa(NumRow.wArrIdx1, ADR(_sNumeric));
		
		_lLen := LEN(_sNumeric);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sNumeric), 0);
			
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

		// 2 Array Index

		brsitoa(NumRow.wArrIdx2, ADR(_sNumeric));
		
		_lLen := LEN(_sNumeric);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sNumeric), 0);
			
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

		// 3 Array Index

		brsitoa(NumRow.wArrIdx3, ADR(_sNumeric));
		
		_lLen := LEN(_sNumeric);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sNumeric), 0);
			
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

		// 4 Array Index

		brsitoa(NumRow.wArrIdx4, ADR(_sNumeric));
		
		_lLen := LEN(_sNumeric);

		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sNumeric), 0);
			
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

		// Maschinensubtyp schreiben

		_lLen := brwcslen(ADR(NumRow.utfMachineSubType));
		
		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcscpy(pMem + lSize, ADR(NumRow.utfMachineSubType));
			
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
