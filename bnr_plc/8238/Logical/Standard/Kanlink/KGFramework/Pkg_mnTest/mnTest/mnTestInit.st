(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTest
 * File: mnTestInit.st
 * Author: hunholz
 * Created: March 03, 2012
 ********************************************************************
 * Implementation of program mnTest
 ********************************************************************)

PROGRAM _INIT

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'mnTestFW';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnTestStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnTestStatAd.sPkgVersion := '---';
		
	END_IF
	
	// Test ist auf jeden Fall deaktiviert
	
	_wTestMode := 0;

END_PROGRAM

