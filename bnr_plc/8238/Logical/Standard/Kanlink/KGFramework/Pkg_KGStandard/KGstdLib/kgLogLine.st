(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgLogLine.st
 * Author: hunholz
 * Created: December 19, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Logzeile mit zwei numerischen Variablen erzeugen *)
FUNCTION_BLOCK kgLogLine
	
	sLogline := '';
	pLogline := ADR(sLogline);
	
	IF LEN(sLoglineTemplate) > 0 THEN

		_iPos1 := FIND(sLoglineTemplate,'{##AttrVar1}');
		_iPos2 := FIND(sLoglineTemplate,'{##AttrVar2}');
		_iCrs := 1;
		
		IF (_iPos1 > 0) AND (_iPos2 = 0 OR _iPos1 < _iPos2) THEN
			
			_sTemp := MID(sLoglineTemplate, _iPos1 - _iCrs, _iCrs);
			sLogline := CONCAT(sLogline, _sTemp);
			_iCrs := _iPos1 + 12;
			_iPos1 := 0;
			
			brsitoa(lAttr1, ADR(sValue));
			sLogline := CONCAT(sLogline, sValue);
			
		END_IF

		IF (_iPos2 > 0) AND (_iPos1 = 0 OR _iPos2 < _iPos1) THEN
			
			_sTemp := MID(sLoglineTemplate, _iPos2 - _iCrs, _iCrs);
			sLogline := CONCAT(sLogline, _sTemp);
			_iCrs := _iPos2 + 12;
			_iPos2 := 0;
			
			brsitoa(lAttr2, ADR(sValue));
			sLogline := CONCAT(sLogline, sValue);
			
		END_IF

		IF (_iPos1 > 0) THEN
			
			_sTemp := MID(sLoglineTemplate, _iPos1 - _iCrs, _iCrs);
			sLogline := CONCAT(sLogline, _sTemp);
			_iCrs := _iPos1 + 12;
			
			brsitoa(lAttr1, ADR(sValue));
			sLogline := CONCAT(sLogline, sValue);
			
		END_IF

		_sTemp := RIGHT(sLoglineTemplate, LEN(sLoglineTemplate)-_iCrs+1);
		sLogline := CONCAT(sLogline, _sTemp); 
	
	END_IF	
		
	
END_FUNCTION_BLOCK