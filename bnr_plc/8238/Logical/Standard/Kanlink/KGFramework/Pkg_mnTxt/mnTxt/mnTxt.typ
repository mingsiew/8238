(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTxt
 * File: mnTxt.typ
 * Author: hunholz
 * Created: November 25, 2011
 ********************************************************************
 * Local data types of program mnTxt
 ********************************************************************)

TYPE
	_mntxt_loadstate_enum : 
		(
		_ls_idle := 0,
		_ls_load_functiontxt_01 := 100,
		_ls_load_functiontxt_02,
		_ls_load_functiontxt_03,
		_ls_load_functiontxt_04,
		_ls_load_functiontxt_05,
		_ls_load_functiontxt_06,
		_ls_load_functiontxt_07,
		_ls_load_functiontxt_08,
		_ls_load_instancetxt_01 := 200,
		_ls_load_instancetxt_02,
		_ls_load_instancetxt_03,
		_ls_load_instancetxt_04,
		_ls_load_instancetxt_05,
		_ls_load_instancetxt_06,
		_ls_load_instancetxt_07,
		_ls_load_instancetxt_08,
		_ls_load_messagetxt_01 := 300,
		_ls_load_messagetxt_02,
		_ls_load_messagetxt_03,
		_ls_load_messagetxt_04,
		_ls_load_messagetxt_05,
		_ls_load_messagetxt_06,
		_ls_load_messagetxt_07,
		_ls_load_messagetxt_08,
		_ls_load_paramtxt_01 := 400,
		_ls_load_paramtxt_02,
		_ls_load_paramtxt_03,
		_ls_load_paramtxt_04,
		_ls_load_paramtxt_05,
		_ls_load_paramtxt_06,
		_ls_load_paramtxt_07,
		_ls_load_paramtxt_08,
		_ls_error := 65535
		);
	_mntxt_initstate_enum : 
		(
		_is_checkFunctionTxt,
		_is_writeFunctionTxt,
		_is_checkInstanceTxt,
		_is_writeInstanceTxt,
		_is_checkParTxt,
		_is_writeParTxt,
		_is_checkParHlpTxt,
		_is_writeParHlpTxt,
		_is_checkMsgCnt,
		_is_checkMsgTxt,
		_is_writeMsgTxt,
		_is_checkMsgHlpTxt,
		_is_writeMsgHlpTxt
		);
	_mntxt_rem_typ : 	STRUCT 
		dtFuncTxt : DATE_AND_TIME;
		dtInstTxt : DATE_AND_TIME;
		dtParTxt : DATE_AND_TIME;
		dtMsgTxt : DATE_AND_TIME;
	END_STRUCT;
END_TYPE
