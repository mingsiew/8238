(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: svCPCache.fun
 * Author: hunholz
 * Created: March 30, 2012
 ********************************************************************
 * Functions and function blocks of program svCPCache
 ********************************************************************)

FUNCTION_BLOCK _TrimCategory (*Entfernt führende Nullen und Leerzeichen, sowie folgende Leerzeichen*)
	VAR_INPUT
		sCategory : STRING[11];
	END_VAR
	VAR_OUTPUT
		sOutCategory : STRING[11];
	END_VAR
	VAR
		_iFound : INT;
	END_VAR
END_FUNCTION_BLOCK
