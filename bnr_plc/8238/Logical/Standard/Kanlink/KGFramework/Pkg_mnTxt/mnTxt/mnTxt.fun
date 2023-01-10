(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTxt
 * File: mnTxt.fun
 * Author: hunholz
 * Created: June 22, 2012
 ********************************************************************
 * Functions and function blocks of program mnTxt
 ********************************************************************)

FUNCTION_BLOCK _utfReplaceCtrl (*Replace Linefeed*)
	VAR_INPUT
		pInput : UDINT;
		pOutput : UDINT;
		lSizeOutput : UDINT;
		xWSTRING : BOOL;
	END_VAR
	VAR_OUTPUT
		wStatus : UINT;
	END_VAR
	VAR
		_utfInput : REFERENCE TO WSTRING[1023];
		_sInput : REFERENCE TO STRING[255];
		_lChar1 : UDINT;
		_lChar2 : UDINT;
		_wChar1 : REFERENCE TO UINT;
		_wChar2 : REFERENCE TO UINT;
		_sOutput : REFERENCE TO STRING[255];
		_utfOutput : REFERENCE TO WSTRING[1023];
		_bChar1 : REFERENCE TO USINT;
		_iPos : INT;
		_pOutput : UDINT;
	END_VAR
END_FUNCTION_BLOCK
