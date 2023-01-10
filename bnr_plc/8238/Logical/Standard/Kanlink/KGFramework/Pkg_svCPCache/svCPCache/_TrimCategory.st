(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: _TrimCategory.st
 * Author: hunholz
 * Created: March 30, 2012
 ********************************************************************
 * Implementation of program svCPCache
 ********************************************************************) 

(* Entfernt führende Nullen und Leerzeichen, sowie folgende Leerzeichen *)
FUNCTION_BLOCK _TrimCategory

	sOutCategory := sCategory;
	
	IF LEN(sOutCategory) > 0 THEN
		REPEAT
			_iFound := FIND(sOutCategory,' ');
				
			IF _iFound <> 0 THEN
				sOutCategory := DELETE(sOutCategory,1,_iFound);
			END_IF
				
			UNTIL 
			_iFound = 0 OR LEN(sOutCategory) = 0
		END_REPEAT
	END_IF

	//Bug 689: Eine Null muss stehen bleiben
	IF LEN(sOutCategory) > 1 THEN
		REPEAT
			_iFound := FIND(sOutCategory,'0');
				
			IF _iFound = 1 THEN
				sOutCategory := DELETE(sOutCategory,1,_iFound);
			END_IF
				
			UNTIL 
			_iFound <> 1 OR LEN(sOutCategory) = 1
		END_REPEAT
	END_IF
	
END_FUNCTION_BLOCK