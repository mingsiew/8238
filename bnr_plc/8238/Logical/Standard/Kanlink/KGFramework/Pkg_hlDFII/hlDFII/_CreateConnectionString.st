(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: _CreateConnectionString.st
 * Author: hunholz
 * Created: June 19, 2012
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************) 

(* Connectionstring for SQL-Client *)
FUNCTION_BLOCK _CreateConnectionString
	
	ConnString := USINT_TO_STRING(IP.bNetId1);
	ConnString := CONCAT(ConnString,'.');
	_sOkt := USINT_TO_STRING(IP.bNetId2);
	ConnString := CONCAT(ConnString,_sOkt);
	ConnString := CONCAT(ConnString,'.');
	_sOkt := USINT_TO_STRING(IP.bNetId3+Conn.bDBservReg);
	ConnString := CONCAT(ConnString,_sOkt);
	ConnString := CONCAT(ConnString,'.');
	_sOkt := USINT_TO_STRING(Conn.bDBservAdr);
	ConnString := CONCAT(ConnString,_sOkt);
		
	HostString := ConnString;
		
	_sInstance := Conn.sServInst;
		
	IF Conn.wDBservPort <> 0 THEN
			
		// Wenn der Port <> 0 ist, wird der SQL-Server direkt über den Port angesprochen
	
		ConnString := CONCAT(ConnString, ':');
		_sPort 	 := UINT_TO_STRING(Conn.wDBservPort);
		ConnString := CONCAT(ConnString, _sPort);

	ELSE
			
		// Wenn mit der Instanz gearbeitet wird, muss auf dem PC der SQL-Browser-Dienst laufen

		IF LEN(_sInstance) > 0 THEN

			REPEAT
				
				_iFound := FIND(_sInstance,' ');
				
				IF _iFound <> 0 THEN
					_sInstance := DELETE(_sInstance,1,_iFound);
				END_IF
				
				UNTIL 
				_iFound = 0 OR LEN(_sInstance) = 0
			END_REPEAT
		
			IF LEN(_sInstance) > 0 THEN
				ConnString := CONCAT(ConnString, '\');
				ConnString := CONCAT(ConnString, _sInstance);
			END_IF
		
		END_IF

	END_IF
	
	
	
END_FUNCTION_BLOCK