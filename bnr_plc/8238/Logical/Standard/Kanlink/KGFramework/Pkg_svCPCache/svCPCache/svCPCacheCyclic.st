(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: svCPCacheCyclic.st
 * Author: hunholz
 * Created: March 29, 2012
 ********************************************************************
 * Implementation of program svCPCache
 ********************************************************************)

PROGRAM _CYCLIC

	// Zyklische Arbeit. Entgegennehmen von Aufträgen
	IF _xCacheReady THEN
		
		// Kommandos abarbeiten
		_actIFCmd;
		
		// CSV-File speichern
		_actSaveCSV;
		
	END_IF

	// Erstmaliges Lesen der Kategorie-Programm-Zuordnung
	IF _xCacheInitReady AND NOT _xCacheReady AND IFmnParam.Out.xParamOK THEN
		
		_sDevice := KG_DEVICE_COMPACTFLASH;
		_sPathFile := CONCAT(_SVCPCACHE_CSV_PATH, _SVCPCACHE_CSV_FILE);
		
		IF _enImport = cs_ImpIdle THEN
			_enImport := cs_ImpStart;
		END_IF
		
		///////////////////////////////
		// ACTION
		///////////////////////////////
		_actCPImport;
		
		IF _enImport = cs_ImpRdyFault THEN
			
			// Einlesen mit Fehler abgebrochen
			_xCacheInitReady := FALSE;
			
			_enImport := cs_ImpIdle;
			
		ELSIF _enImport = cs_ImpRdySuccess THEN
			
			// Erfolgreich eingelesen
			_xCacheReady := TRUE;
			
			IFsvCPCache.Out.xListReady := TRUE;
			IFsvCPCache.Out.wCntRelations := _wCntRelations;
			
			// Liste füllen
			IFsvCPCache.Out.wListOffset := 0;
			_actFillCPList;
			
			_enImport := cs_ImpIdle;
			
		END_IF
		
	END_IF
	
	IFsvCPCache.Out.xReady := _xCacheReady;
	svCPCacheStatAd.xReady := _xCacheReady;

END_PROGRAM
