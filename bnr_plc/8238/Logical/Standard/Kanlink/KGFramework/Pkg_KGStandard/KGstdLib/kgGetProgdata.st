(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgGetProgdata.st
 * Author: hunholz
 * Created: April 11, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Read Programdata from a dataobject *)
FUNCTION kgGetProgdata
	
	IF LEN(sBaseName) = 0 THEN
		kgGetProgdata := KG_ERR_NULLSTRING;
		RETURN;
	END_IF
	
	IF pMem = 0 THEN
		kgGetProgdata := KG_ERR_NULPOINTER;
		RETURN;
	END_IF
	
	_sIndex := '';
	IF wProgMaxNo > 9999 AND  wProgNo  < 10000 THEN
		_sIndex := CONCAT(_sIndex,'0');
	END_IF
	IF wProgMaxNo > 999 AND  wProgNo  < 1000 THEN
		_sIndex := CONCAT(_sIndex,'0');
	END_IF
	IF wProgMaxNo > 99 AND  wProgNo  < 100 THEN
		_sIndex := CONCAT(_sIndex,'0');
	END_IF
	IF wProgMaxNo > 9 AND  wProgNo  < 10 THEN
		_sIndex := CONCAT(_sIndex,'0');
	END_IF
	
	_sIndex1 := UINT_TO_STRING(wProgNo);
	
	_sIndex := CONCAT(_sIndex, _sIndex1);
	
	_sName := CONCAT(sBaseName, _sIndex);
	
	_diProg(enable := TRUE, pName := ADR(_sName));
	
	IF _diProg.status = ERR_OK THEN
		
		// Bug 690 : Datenobjekt hat 4Byte Alignment. Struktur kann 1 bis 3 Byte kleiner sein.
//		IF _diProg.len > lSize THEN
//			kgGetProgdata := KG_ERR_WRONGSIZES;
//			RETURN;
//		END_IF
		
		brsmemcpy(pMem, _diProg.pDatObjMem, MIN(_diProg.len,lSize));
		
		kgGetProgdata := ERR_OK;
		
		RETURN;
		
	ELSE
		kgGetProgdata := _diProg.status;
		RETURN;
	END_IF
	
END_FUNCTION