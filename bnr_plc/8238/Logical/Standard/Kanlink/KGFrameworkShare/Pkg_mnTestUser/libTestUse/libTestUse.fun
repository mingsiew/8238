(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: libTestUse
 * File: libTestUse.fun
 * Author: hunholz
 * Created: March 06, 2012
 ********************************************************************
 * Functions and function blocks of library libTestUse
 ********************************************************************)

FUNCTION_BLOCK TestUser_SetMode (*Versetzt die Anwendung in unterschiedliche Testmodi*)
	VAR_INPUT
		enable : BOOL;
		wMode : UINT;
		pStruc : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		_wSetModeState : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK TestUser_RunTest (*Zyklische Bearbeitung des Tests*)
	VAR_INPUT
		enable : BOOL;
		wMode : UINT;
		pStruc : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		_CmdTest : REFERENCE TO TestUser_CmdTest_typ;
		_i : UINT;
		_wCommand : REFERENCE TO UINT;
		_CmdResult : REFERENCE TO ARRAY[0..1] OF UINT;
		_bResult : USINT;
		_wResult : UINT;
		_wXORStatus : UINT;
		_j : UINT;
		_BatchLoad : REFERENCE TO ARRAY[0..3] OF BatchLoad_typ;
		_Batch : REFERENCE TO ARRAY[0..30] OF Batch_typ;
		_BatchUnload : REFERENCE TO ARRAY[0..2] OF Batch_typ;
		_BatchLoadTrig : REFERENCE TO ARRAY[0..3] OF BatchLoadTrig_typ;
		_BatchTrig : REFERENCE TO BatchTrig_typ;
		_BatchUnloadTrig : REFERENCE TO BatchUnloadTrig_typ;
		_xBatchLoadOk : BOOL;
		_xBatchOk : BOOL;
		_xBatchUnloadOk : BOOL;
		_TonShiftClck1 : TON;
		_TonShiftClck2 : TON;
		_wShiftStep : UINT;
		_lBatchNo : UDINT;
		_pBatchNo : REFERENCE TO UDINT;
		_GetTime : DTGetTime;
		_sValue : STRING[10];
		_xBatchForLoadingOk : REFERENCE TO BOOL;
		_enMachineState : REFERENCE TO UDINT;
		_wMachineStateTxt : REFERENCE TO UINT;
		_lMachineStateAtt1 : REFERENCE TO UDINT;
		_lMachineStateAtt2 : REFERENCE TO UDINT;
		_wMachineStateCnt : UINT;
		_Ton1sClck2 : TON;
		_Ton1sClck1 : TON;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION TestUser_StopTask : UINT (*Stoppt Task per Namen*)
	VAR_INPUT
		st_name : UDINT;
	END_VAR
	VAR
		_lTaskIdent : UDINT;
	END_VAR
END_FUNCTION
