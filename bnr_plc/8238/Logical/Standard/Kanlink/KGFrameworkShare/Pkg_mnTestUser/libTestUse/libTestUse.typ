(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: libTestUse
 * File: libTestUse.typ
 * Author: hunholz
 * Created: March 06, 2012
 ********************************************************************
 * Data types of library libTestUse
 ********************************************************************)

TYPE
	TestUser_CmdTest_typ : 	STRUCT 
		pCmd : ARRAY[1..LIBTEST_CNT_TSTCMD]OF UDINT;
		pParamMem : ARRAY[1..LIBTEST_CNT_TSTCMD,1..LIBTEST_CNT_TSTPARAM]OF UDINT;
		pParamSize : ARRAY[1..LIBTEST_CNT_TSTCMD,1..LIBTEST_CNT_TSTPARAM]OF UDINT;
		pCmdResult : ARRAY[1..LIBTEST_CNT_TSTCMD]OF UDINT;
		pBatchLoad : UDINT;
		pBatch : UDINT;
		pBatchUnload : UDINT;
		pBatchLoadTrig : UDINT;
		pBatchTrig : UDINT;
		pBatchUnloadTrig : UDINT;
		pBatchForLoadingOk : UDINT;
		pMachineState : UDINT;
		pMachineStateTxt : UDINT;
		pMachineStateAtt1 : UDINT;
		pMachineStateAtt2 : UDINT;
	END_STRUCT;
END_TYPE
