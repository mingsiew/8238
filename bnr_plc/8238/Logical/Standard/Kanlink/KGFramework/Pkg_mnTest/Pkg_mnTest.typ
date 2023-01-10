(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Package: Pkg_mnTest
 * File: Pkg_mnTest.typ
 * Author: hunholz
 * Created: March 06, 2012
 ********************************************************************
 * Data types of package Pkg_mnTest
 ********************************************************************)

TYPE
	IFmnTestOut_typ : 	STRUCT 
		xNoMessages : BOOL := FALSE;
	END_STRUCT;
	IFmnTestIn_typ : 	STRUCT 
		pStrucTest : UDINT;
	END_STRUCT;
	IFmnTest_typ : 	STRUCT 
		In : IFmnTestIn_typ;
		Out : IFmnTestOut_typ;
	END_STRUCT;
	mnTestStatAd_typ : 	STRUCT 
		wMode : UINT; (*0 - deaktiviert. 1.. Nummer des Testmode*)
		sPkgVersion : STRING[10];
	END_STRUCT;
END_TYPE
