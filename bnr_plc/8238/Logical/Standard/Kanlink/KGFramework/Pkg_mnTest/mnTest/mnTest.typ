(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTest
 * File: mnTest.typ
 * Author: hunholz
 * Created: March 03, 2012
 ********************************************************************
 * Local data types of program mnTest
 ********************************************************************)

TYPE
	_CommandoState_enum : 
		(
		_csIdle,
		_csSetTestMode,
		_csWaitForNull
		);
	_TestState_enum : 
		(
		_tsIdle,
		_tsSetMode,
		_tsPrepTest1,
		_tsRun,
		_tsFault
		);
END_TYPE
