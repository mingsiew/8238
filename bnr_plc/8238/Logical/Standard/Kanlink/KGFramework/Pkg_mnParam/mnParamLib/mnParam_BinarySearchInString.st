(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_BinarySearchInString.st
 * Author: hunholz
 * Created: August 01, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Binärsuche von CSV-String-Container-Zeilen *)
FUNCTION_BLOCK mnParam_BinarySearchInString

IF enable THEN
		
	IF lpList = 0 OR lMaxRow < 1 THEN
		// Null-Pointer
		status := 1;
		RETURN;
	END_IF
	
	// Access auf dynamische Struktur
	_CsvStructStringDyn ACCESS lpList;
		
		
	_lMin := 1;
	_lMax := lMaxRow;
		
	WHILE TRUE DO
		
		IF (_lMin <= _lMax) THEN
			
			// Suche nach korrektem IdxPar		
			// Middle Index berechnen
			_lMid := (_lMin + _lMax) / 2;
			
			// Suche erfolgreich?
			IF (CsvStructString.wIdxStringPar = _CsvStructStringDyn.CsvString[_lMid].wIdxStringPar) THEN
				// korrekten IdxPar gefunden
				
				// Suche erfolgreich?
				IF (CsvStructString.wArrIdx1 = _CsvStructStringDyn.CsvString[_lMid].wArrIdx1) THEN
					// korrekten wArrIdx1 gefunden
					
					// Suche erfolgreich?
					IF (CsvStructString.wArrIdx2 = _CsvStructStringDyn.CsvString[_lMid].wArrIdx2) THEN
						// korrekten wArrIdx2 gefunden
						
						// Suche erfolgreich?
						IF (CsvStructString.wArrIdx3 = _CsvStructStringDyn.CsvString[_lMid].wArrIdx3) THEN
							// korrekten wArrIdx3 gefunden
							
							// Suche erfolgreich?
							IF (CsvStructString.wArrIdx4 = _CsvStructStringDyn.CsvString[_lMid].wArrIdx4) THEN
								// korrekten wArrIdx4 gefunden
								
								// gefundenen Zeilen Index übergeben
								lFoundRow := _lMid;
								
								status := 0; // ohne Fehler durchlaufen
								
								EXIT; // While-Schleife der Suche verlassen
								
							ELSIF (CsvStructString.wArrIdx4 < _CsvStructStringDyn.CsvString[_lMid].wArrIdx4) THEN
								// gefundener Index ist grösser
								_lMax := _lMid - 1;				
							ELSE
								// gefundener Index ist kleiner
								_lMin := _lMid + 1;								
							END_IF;
						
						ELSIF (CsvStructString.wArrIdx3 < _CsvStructStringDyn.CsvString[_lMid].wArrIdx3) THEN
							// gefundener Index ist grösser
							_lMax := _lMid - 1;				
						ELSE
							// gefundener Index ist kleiner
							_lMin := _lMid + 1;								
						END_IF;
					
					ELSIF (CsvStructString.wArrIdx2 < _CsvStructStringDyn.CsvString[_lMid].wArrIdx2) THEN
						// gefundener Index ist grösser
						_lMax := _lMid - 1;				
					ELSE
						// gefundener Index ist kleiner
						_lMin := _lMid + 1;								
					END_IF;
				
				ELSIF (CsvStructString.wArrIdx1 < _CsvStructStringDyn.CsvString[_lMid].wArrIdx1) THEN
					// gefundener Index ist grösser
					_lMax := _lMid - 1;				
				ELSE
					// gefundener Index ist kleiner
					_lMin := _lMid + 1;								
				END_IF;
			
			ELSIF (CsvStructString.wIdxStringPar < _CsvStructStringDyn.CsvString[_lMid].wIdxStringPar) THEN
				// gefundener Index ist grösser
				_lMax := _lMid - 1;				
			ELSE
				// gefundener Index ist kleiner
				_lMin := _lMid + 1;								
			END_IF;
		
		ELSIF (_lMin > _lMax) THEN
			// Fehler in der Binären-Suche
			// zB entsprechende Zeile konnte nicht gefunden werden
			status := 2;
			EXIT;
		END_IF;
		
	END_WHILE;

ELSE

	status := 65534; // Eingang enable nicht gesetzt

END_IF

END_FUNCTION_BLOCK
