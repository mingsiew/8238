(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgBatchNoToUDINT.st
 * Author: hunholz
 * Created: November 17, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Extrahiere aus GUID ein UDINT *)
FUNCTION kgBatchNoToUDINT
	
	_udint ACCESS ADR(GUID);
	
	kgBatchNoToUDINT := _udint;
	
END_FUNCTION