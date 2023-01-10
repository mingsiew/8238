(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV80_Mem.st
 * Author: hunholz
 * Created: October 20, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* String Daten schreiben *)
FUNCTION_BLOCK mnParam_WriteCSV80_Mem

	IF enable THEN
		
		status := ERR_OK;
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 6) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0038;	// 8
			_pUtfString[1] := 16#0030;	// 0
			_pUtfString[2] := 16#0009;	// TAB
			
			lSize := lSize + 6;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		// Container-ID

		brsitoa(ContentRow.iContainerID, ADR(_sValue));
		
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
		
		// Instanz
		
		brsitoa(ContentRow.wInstance, ADR(_sValue));
		
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
		
		_dttoa(dtTimestamp := ContentRow.dtTimestamp);
		
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
		
	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		
	END_IF	

END_FUNCTION_BLOCK
