(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KanLinkLib
 * File: KLLib_WriteStrucDefLine.st
 * Author: hunholz
 * Created: February 24, 2012
 ********************************************************************
 * Implementation of library KanLinkLib
 ********************************************************************) 

(* Übertrage einen String als Zeile in den Speicher *)
FUNCTION KLLib_WriteStrucDefLine
	
	IF lPtrAdr = 0 OR lPtrLen = 0 OR lPtrLine = 0 THEN
		
		KLLib_WriteStrucDefLine := KLLIB_MSG_NULL_POINTER;
		RETURN;
		
	END_IF
	
	_lAdr ACCESS lPtrAdr;
	_lLen ACCESS lPtrLen;
	_sLine ACCESS lPtrLine;
	
	_sLine := CONCAT(_sLine, '$R$L');
	
	_iStringlen := LEN(_sLine);
			
	IF (INT_TO_UDINT(_iStringlen)+1) > _lLen THEN

		KLLib_WriteStrucDefLine := KLLIB_MSG_NOT_ENOUGH_MEM;
		RETURN;
					
	ELSE
		
		brsstrcpy(_lAdr, lPtrLine);
		_lAdr := _lAdr + INT_TO_UDINT(_iStringlen);
		_lLen := _lLen - INT_TO_UDINT(_iStringlen);
					
	END_IF
	
	KLLib_WriteStrucDefLine := ERR_OK;

END_FUNCTION