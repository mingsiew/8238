(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_GetNextSubstring.st
 * Author: hunholz
 * Created: July 26, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION_BLOCK mnParam_GetNextSubstring
	
	IF enable THEN
	
		EndOfLine := FALSE;
		brsmemset(ADR(_utfSubString), 0, SIZEOF(_utfSubString));
		
		// Länge des Strings ermitteln
		_lLen :=  brwcslen(pUtfCsvString);
		
		// Tab-Zeichen suchen
		_lAdrTab := brwcschr(pUtfCsvString, 16#0009);
	
		// Kein Tab-Zeichen gefunden, dann String zurückgeben und EndOfLine auf TRUE setzen
		IF _lAdrTab = 0 THEN
	
			EndOfLine := TRUE;
			Length := MIN(255,_lLen);
			brwcsncpy(ADR(_utfSubString), pUtfCsvString, Length);
		
		ELSE
			
			_lLen := (_lAdrTab - pUtfCsvString ) / 2;
			Length := MIN(255, _lLen);
			IF Length = 0 THEN
				_utfSubString := "";
			ELSE
				brwcsncpy(ADR(_utfSubString), pUtfCsvString, Length);
			END_IF
			pUtfCsvString := _lAdrTab + 2;
			
		END_IF
		
		pUtfCsvSubstring := ADR(_utfSubString);
		
		status := ERR_OK;
		
	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
		

END_FUNCTION_BLOCK
