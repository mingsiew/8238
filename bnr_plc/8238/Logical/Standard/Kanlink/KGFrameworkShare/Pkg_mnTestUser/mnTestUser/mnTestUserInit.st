(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTestUser
 * File: mnTestUserInit.st
 * Author: hunholz
 * Created: March 07, 2012
 ********************************************************************
 * Implementation of program mnTestUser
 ********************************************************************)

PROGRAM _INIT


	IFmnTest.In.pStrucTest := ADR(_CmdTest);
	
	_CmdTest.pCmd[1] := ADR(mnMasterCmd.Request.Command);
	_CmdTest.pParamMem[1,1] := ADR(mnMasterCmdAd.SetBatch);
	_CmdTest.pParamSize[1,1] := SIZEOF(mnMasterCmdAd.SetBatch);
	_CmdTest.pCmdResult[1] := ADR(mnMasterCmd.Response);

	_CmdTest.pCmd[2] := ADR(mnLoadCmd.Request.Command);
	_CmdTest.pCmdResult[2] := ADR(mnLoadCmd.Response);
	
	FOR _i := 0 TO wCountCompMN DO
	
		_CmdTest.pCmd[3 +_i] := ADR(mnCompCmd[_i].Request.Command);
		_CmdTest.pCmdResult[3 + _i] := ADR(mnCompCmd[_i].Response);
		
	END_FOR
	
	_CmdTest.pBatchLoad := ADR(BatchLoad);
	_CmdTest.pBatch := ADR(Batch);
	_CmdTest.pBatchUnload := ADR(BatchUnload);
	_CmdTest.pBatchTrig := ADR(BatchTrig);
	_CmdTest.pBatchLoadTrig := ADR(BatchLoadTrig);
	_CmdTest.pBatchUnloadTrig := ADR(BatchUnloadTrig);

	_CmdTest.pBatchForLoadingOk := ADR(mnMasterStatAd.xBatchTransferDataForLoadingOK);
//	
//	_CmdTest.pMachineState := ADR(MachineState.wState);
//	_CmdTest.pMachineStateTxt := ADR(MachineState.wStateTxt);
//	_CmdTest.pMachineStateAtt1 := ADR(MachineState.lStateTxtAtt1);
//	_CmdTest.pMachineStateAtt2 := ADR(MachineState.lStateTxtAtt2);
	
END_PROGRAM

