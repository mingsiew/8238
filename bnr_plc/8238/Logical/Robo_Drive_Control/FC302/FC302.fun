(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: FC302
 * File: FC302.fun
 * Author: D.Jefferys
 * Created: February 12, 2009
 ********************************************************************
 * Functions and function blocks of library FC302
 ********************************************************************)

FUNCTION_BLOCK FC302_WriteParam
	VAR_INPUT
		enable : BOOL;
		pDevice : UDINT; (*Add your parameter comment*)
		node : USINT; (*Add your parameter comment*)
		index : UINT; (*Add your parameter comment*)
		subindex : USINT; (*Add your parameter comment*)
		data : UDINT; (*Add your parameter comment*)
		bytelen : USINT; (*Add your parameter comment*)
	END_VAR
	VAR_OUTPUT
		status : UINT; (*Add your parameter comment*)
	END_VAR
	VAR
		CANopenSDOWrite8_0 : CANopenSDOWrite8;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FC302_ReadSTW (*FC302 Read Status Word*)
	VAR_INPUT
		StatusWord : UINT; (*Add your parameter comment*)
	END_VAR
	VAR_OUTPUT
		STW : FC302_STW_Typ; (*Add your parameter comment*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FC302_WriteCTW (*Control Word build*)
	VAR_INPUT
		CTW : FC302_CTW_Typ; (*Add your parameter comment*)
	END_VAR
	VAR_OUTPUT
		ControlWord : UINT; (*Add your parameter comment*)
	END_VAR
	VAR
		LocalControlWord : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FC302_ReadParamTbl
	VAR_INPUT
		Enable : BOOL;
		adrTableName : UDINT;
		adrDestTable : UDINT;
		ParamLimit : UINT;
	END_VAR
	VAR_OUTPUT
		ParamCount : UINT;
		Status : UINT;
	END_VAR
	VAR
		DatObjInfo_0 : DatObjInfo;
		DatObjRead_0 : DatObjRead;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FC302_ReadParam (*Read Parameter from Danfoss FC302*)
	VAR_INPUT
		enable : BOOL; (*Add your parameter comment*)
		pDevice : UDINT; (*Add your parameter comment*)
		node : USINT; (*Add your parameter comment*)
		index : UINT; (*Add your parameter comment*)
		subindex : USINT; (*Add your parameter comment*)
	END_VAR
	VAR_OUTPUT
		data : UDINT; (*Add your parameter comment*)
		status : UINT; (*Add your parameter comment*)
	END_VAR
	VAR
		bytelen : USINT; (*Add your parameter comment*)
		CANopenSDORead8_0 : CANopenSDORead8;
	END_VAR
END_FUNCTION_BLOCK
