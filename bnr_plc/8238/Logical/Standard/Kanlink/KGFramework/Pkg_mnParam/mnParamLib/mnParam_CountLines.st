(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_CountLines.st
 * Author: hunholz
 * Created: July 25, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Zählt die gültigen Zeilen der Datei und gibt eine Zeilenstruktur zurück *)
FUNCTION_BLOCK mnParam_CountLines

	IF enable THEN
	
		// Gültigkeit der Übergabeparameter
		IF pAdresses = 0 OR pLens = 0 OR MaxLines > 20000 OR pFile = 0 THEN
			status := 1;
			RETURN;
		END_IF
	
		status := 0;
	
		CntLines := 0;
		
		brsmemset(pAdresses, 0, UINT_TO_UDINT(MaxLines) * 4);
		brsmemset(pLens, 0, UINT_TO_UDINT(MaxLines) * 2);
	
		_plAdresses ACCESS pAdresses;
		_pwLens ACCESS pLens;
		
		_xNewLine := TRUE;
	
		FOR _p := pFile TO pFile + FileSize  - 2 BY 2 DO
				
			_pChar	ACCESS _p;
				
			IF _pChar = 16#000D OR _pChar = 16#000A THEN
					
				IF NOT _xNewLine THEN
	
					// Zeilenende gefunden
					_lDif := _p - _plAdresses[CntLines];
	
					_pwLens[CntLines] := UDINT_TO_UINT( (_lDif) / 2 );
	
				END_IF
	
				_xNewLine := TRUE;
				
				IF CntLines >= MaxLines THEN
					EXIT;
				END_IF
						
			ELSIF _xNewLine THEN
	
				CntLines := CntLines + 1;
				_plAdresses[CntLines]	:= _p;
				_xNewLine := FALSE;
					
			END_IF	
				
		END_FOR
			
		IF NOT _xNewLine THEN
	
			_lDif := _p - _plAdresses[CntLines];
	
			_pwLens[CntLines] := UDINT_TO_UINT( (_lDif) / 2 );
				
		END_IF

	ELSE

		status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
	
END_FUNCTION_BLOCK
