(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_WriteCSV253_Mem.st
 * Author: hunholz
 * Created: August 02, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Versions Kopfzeile *)
FUNCTION_BLOCK mnParam_WriteCSV253_Mem
	
	IF enable THEN
		
		IF pMem = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		IF (lSize + 8) <= lMaxSize THEN
			
			_pUtfString ACCESS pMem + lSize;
			
			_pUtfString[0] := 16#0032;	// 2
			_pUtfString[1] := 16#0035;	// 5
			_pUtfString[2] := 16#0033;	// 3
			_pUtfString[3] := 16#0009;	// TAB
			
			lSize := lSize + 8;
			
		ELSE
			
			status := 2;
			RETURN;

		END_IF

		// Version schreiben
	
		brsitoa(VersionRow.wVersion, ADR(_sVersion));

		IF LEN(_sVersion) > 0 THEN

			IF (lSize + LEN(_sVersion)*2 ) <= lMaxSize THEN

				brwcsconv(pMem + lSize, ADR(_sVersion), 0);
			
				lSize := lSize + 2*LEN(_sVersion);
				
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


		// Zeitstempel schreiben

		_dttoa(dtTimestamp := VersionRow.dtTimestamp);
		
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

		// Maschinentyp schreiben

		_lLen := brwcslen(ADR(VersionRow.utfMachineType));
		
		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcscpy(pMem + lSize, ADR(VersionRow.utfMachineType));
			
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

		_lLen := brwcslen(ADR(VersionRow.utfMachineSubType));
		
		IF _lLen > 0 THEN

			IF (lSize + _lLen*2 ) <= lMaxSize THEN

				brwcscpy(pMem + lSize, ADR(VersionRow.utfMachineSubType));
			
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
