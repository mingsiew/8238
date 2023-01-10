(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: hlDFII.fun
 * Author: hunholz
 * Created: June 19, 2012
 ********************************************************************
 * Functions and function blocks of program hlDFII
 ********************************************************************)

FUNCTION_BLOCK _CreateConnectionString (*Connectionstring for SQL-Client*)
	VAR_INPUT
		IP : mnEthIP_typ;
		Conn : hlDFIIParMacConn_typ;
	END_VAR
	VAR_OUTPUT
		ConnString : STRING[39];
		HostString : STRING[15];
	END_VAR
	VAR
		_sOkt : STRING[3];
		_sInstance : STRING[15];
		_sPort : STRING[5];
		_iFound : INT;
	END_VAR
END_FUNCTION_BLOCK
