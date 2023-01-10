(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgUSINT16toGUID.st
 * Author: hunholz
 * Created: November 17, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Konvertiere USINT-Array to GUID_typ *)
FUNCTION_BLOCK kgUSINT16toGUID
	
	brsmemcpy(ADR(GUID), ADR(usintarray), SIZEOF(GUID));
	
END_FUNCTION_BLOCK