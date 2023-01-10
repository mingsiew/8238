(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: WetLink
 * File: WetLink.fun
 * Author: stahlhut
 * Created: January 09, 2012
 ********************************************************************
 * Functions and function blocks of program WetLink
 ********************************************************************)

FUNCTION_BLOCK KL_SaveConfDO (*Speichern der Parameter in Datenobjekt*)
	VAR_INPUT
		adrName : UDINT;
		adrDaten : UDINT;
		len : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
		iSaveStep : INT;
		DatObjInfo_0 : DatObjInfo;
		DatObjDelete_0 : DatObjDelete;
		DatObjCreate_0 : DatObjCreate;
	END_VAR
END_FUNCTION_BLOCK
