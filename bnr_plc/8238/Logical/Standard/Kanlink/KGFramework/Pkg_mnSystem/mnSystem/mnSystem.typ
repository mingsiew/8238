(********************************************************************
 * COPYRIGHT -- Kannegiesser GmbH
 ********************************************************************
 * Program: mnSystem
 * File: _mnSystem.typ
 * Author: horn
 * Created: January 10, 2012
 ********************************************************************
 * Local data types of program mnSystem
 ********************************************************************)

TYPE
	_mnSystemMdlBind_typ : 	STRUCT 
		wModule : UINT;
		wChannel : UINT;
		sDiscription : STRING[13];
		xInvers : BOOL;
		xQualitiyOk : BOOL;
	END_STRUCT;
END_TYPE
