(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: svCPCacheInit.st
 * Author: hunholz
 * Created: March 29, 2012
 ********************************************************************
 * Implementation of program svCPCache
 ********************************************************************)

PROGRAM _INIT

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'svCPCache';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(svCPCacheStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		svCPCacheStatAd.sPkgVersion := '---';
		
	END_IF
	
	_xCacheInitReady := FALSE;

	REPEAT // UNTIL TRUE
	
		// Schleife, die nur einmal durchlaufen wird, aber jederzeit verlassen werden kann
		#pragma warning ( disable : 1288 )
		//Mögliche Optionen
		//SVCPCACHE_DBREQ_NO = 0
		//SVCPCACHE_DBREQ_DFII = 1
		IF SVCPCACHE_DB_REQUEST > 1 THEN
			EXIT;
		END_IF
			
		#pragma warning ( default : 1288 )
		
		//Container sind von 0..20 möglich
		IF SVCPCACHE_NO_INDCONTAINER > 20 THEN
			EXIT;
		END_IF
		
		// Speicher zum Parsen und Schreiben allokieren
		
		_lMemLen := SVCPCACHE_CNT_RELATIONS * 146 + 200;
		
		_MemPartCreate(enable := TRUE, len := _lMemLen + 100);
		
		IF _MemPartCreate.status <> ERR_OK THEN
			EXIT;
		END_IF
		
		_xCacheInitReady := TRUE;
		
		UNTIL TRUE
		
	END_REPEAT


END_PROGRAM

