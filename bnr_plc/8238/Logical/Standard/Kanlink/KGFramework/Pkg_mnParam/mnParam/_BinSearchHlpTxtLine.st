(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _BinSearchHlpTxtLine.st
 * Author: hunholz
 * Created: February 21, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Finde Hilfstextzeile nach Funktion-ID und Nummer *)
FUNCTION _BinSearchHlpTxtLine
	
	_BinSearchHlpTxtLine := 65535;

	IF lPtrHlpTxtLines = 0 OR wCntRows < 1 THEN
		// Null-Pointer oder leere Liste
		RETURN;
	END_IF
	
	// Access auf dynamische Struktur
	_pHlpTextLines ACCESS lPtrHlpTxtLines;
		
		
	_wMin := 0;
	_wMax := wCntRows-1;
		
	WHILE TRUE DO
		
		IF (_wMin <= _wMax) THEN
			
			// Suche nach korrektem IdxPar		
			// Middle Index berechnen
			_wMid := (_wMin + _wMax) / 2;
			
			// Suche erfolgreich?
			IF _pHlpTextLines[_wMid].wFunctionID = wFunctionID THEN
				
				IF _pHlpTextLines[_wMid].wNumber = wNo THEN
					
					_BinSearchHlpTxtLine := _wMid;
					
					EXIT;
					
				ELSIF wNo < _pHlpTextLines[_wMid].wNumber THEN
					
					_wMax := _wMid - 1;
					
				ELSE
					
					_wMin := _wMid + 1;
					
				END_IF
				
			ELSIF wFunctionID < _pHlpTextLines[_wMid].wFunctionID THEN

				_wMax := _wMid - 1;
					
			ELSE
					
				_wMin := _wMid + 1;
					
			END_IF
		
		ELSE
			// Fehler in der Binären-Suche
			// zB entsprechende Zeile konnte nicht gefunden werden
			EXIT;
		END_IF;
		
	END_WHILE;
	
END_FUNCTION