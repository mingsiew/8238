(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: libTestUse
 * File: TestUser_RunTest.st
 * Author: hunholz
 * Created: March 06, 2012
 ********************************************************************
 * Implementation of library libTestUse
 ********************************************************************) 

(* Zyklische Bearbeitung des Tests *)
FUNCTION_BLOCK TestUser_RunTest

//	Template	
//	
//	IF enable THEN
//		
//		IF pStruc = 0 THEN
//			
//			status := LIBTEST_STAT_POINTER_IS_NULL;
//			RETURN;
//			
//		ELSE
//			
//			status := ERR_OK;
//			
//		END_IF
//		
//	ELSE
//		
//		status := ERR_FUB_ENABLE_FALSE;
//		
//	END_IF

	
	IF enable THEN
		
		IF pStruc = 0 THEN
			
			status := KG_ERR_NULPOINTER;
			RETURN;
			
		END_IF
			
		_CmdTest ACCESS pStruc;

		status := ERR_OK;

		// Kommandos
		
		FOR _i := 1 TO LIBTEST_CNT_TSTCMD DO
			
			IF _CmdTest.pCmd[_i] = 0 THEN
				EXIT;
			ELSE
				_wCommand ACCESS _CmdTest.pCmd[_i];
			END_IF

			_bResult := 0;
			_wResult := 0;

			IF _wCommand > 0 THEN
			
				_bResult := kgXOR(pMem := _CmdTest.pCmd[_i] + 4, wLen := 2* SIZEOF(UDINT), bInit := _bResult, pStatus := ADR(_wXORStatus), pWordResult := ADR(_wResult));
				
				FOR _j := 1 TO LIBTEST_CNT_TSTPARAM DO
					
					IF _CmdTest.pParamMem[_i,_j] = 0 OR _CmdTest.pParamSize[_i,_j] = 0 THEN
						
						EXIT;
						
					END_IF
					
					_bResult := kgXOR(pMem := _CmdTest.pParamMem[_i,_j], wLen := UDINT_TO_UINT(_CmdTest.pParamSize[_i,_j]), bInit := _bResult, pStatus := ADR(_wXORStatus), pWordResult := ADR(_wResult));
					
				END_FOR
				
			END_IF
			
			IF _CmdTest.pCmdResult[_i] > 0 THEN

				_CmdResult ACCESS _CmdTest.pCmdResult[_i];
				_CmdResult[0] := _wResult;
				_CmdResult[1] := _wResult;

			END_IF

		END_FOR
		
		// Batches
		
		_TonShiftClck1(IN := NOT _TonShiftClck2.Q, PT := T#15s);
		_TonShiftClck2(IN := _TonShiftClck1.Q, PT := T#15s);
		
		IF _TonShiftClck2.Q AND _CmdTest.pBatch > 0 AND _CmdTest.pBatchLoad > 0 
			AND _CmdTest.pBatchLoadTrig > 0 AND _CmdTest.pBatchTrig > 0 
			AND _CmdTest.pBatchUnload > 0 AND _CmdTest.pBatchUnloadTrig > 0 
			AND _CmdTest.pBatchForLoadingOk > 0 THEN
			
			_Batch ACCESS _CmdTest.pBatch;
			_BatchLoad ACCESS _CmdTest.pBatchLoad;
			_BatchUnload ACCESS _CmdTest.pBatchUnload;
			_BatchTrig ACCESS _CmdTest.pBatchTrig;
			_BatchLoadTrig ACCESS _CmdTest.pBatchLoadTrig;
			_BatchUnloadTrig ACCESS _CmdTest.pBatchUnloadTrig;
			_xBatchForLoadingOk ACCESS _CmdTest.pBatchForLoadingOk;
			
			CASE _wShiftStep OF
				
				0:
				// Beladeposition schreiben
				
					_GetTime(enable := TRUE);
					
					_lBatchNo := MAX(_lBatchNo+1,1);
					_pBatchNo ACCESS ADR(_BatchLoad[1].Batch[1].BatchData.bBatchNo[0]);
					_pBatchNo := _lBatchNo;

					_BatchLoad[1].Batch[1].BatchData.bCntCustomers := 1;
					_BatchLoad[1].Batch[1].BatchData.dtTimeStamp := _GetTime.DT1;
					
					_sValue := UDINT_TO_STRING(_lBatchNo);
					_BatchLoad[1].Batch[1].BatchData.sCategory := CONCAT('C',_sValue);
					_BatchLoad[1].Batch[1].BatchData.wTotalWeight := 300 + (UDINT_TO_UINT(_lBatchNo) MOD 1000);
				
					_BatchLoad[1].Batch[1].BatchData.PartBatch[0].sCustomNo := CONCAT('K',_sValue);
					_BatchLoad[1].Batch[1].BatchData.PartBatch[0].wCustomWeight := _BatchLoad[1].Batch[1].BatchData.wTotalWeight;
				
					_BatchLoad[2].Batch[1].BatchData := _BatchLoad[1].Batch[1].BatchData;
					_BatchLoad[3].Batch[1].BatchData := _BatchLoad[1].Batch[1].BatchData;
				
					_BatchLoadTrig[1].lTriggerChange[1] := _BatchLoadTrig[1].lTriggerChange[1] + 1;
					_BatchLoadTrig[2].lTriggerChange[1] := _BatchLoadTrig[2].lTriggerChange[1] + 1;
					_BatchLoadTrig[3].lTriggerChange[1] := _BatchLoadTrig[3].lTriggerChange[1] + 1;
				
					brsmemset(_CmdTest.pBatchUnload, 0, SIZEOF(_BatchUnload));
					_BatchUnloadTrig.lTriggerChange[1] := _BatchUnloadTrig.lTriggerChange[1] + 1;
					_BatchUnloadTrig.lTriggerChange[2] := _BatchUnloadTrig.lTriggerChange[2] + 1;

					_wShiftStep := 1;
				
				1:
					_Batch[0].BatchData := _BatchLoad[1].Batch[1].BatchData;
					_BatchTrig.lTriggerChange[0] := _BatchTrig.lTriggerChange[0] + 1;
					
					_Batch[0].BatchProcData.bProgram := UDINT_TO_USINT(_lBatchNo MOD 100);
					
					_xBatchForLoadingOk := TRUE;

					_wShiftStep := 2;
				2:
					_BatchUnload[1].BatchData := _Batch[30].BatchData;
					_BatchUnload[2].BatchData := _Batch[30].BatchData;
					_BatchUnloadTrig.lTriggerChange[1] := _BatchUnloadTrig.lTriggerChange[1] + 1;
					_BatchUnloadTrig.lTriggerChange[2] := _BatchUnloadTrig.lTriggerChange[2] + 1;
					
					FOR _j := 30 TO 2 BY -1 DO
					
						_Batch[_j] := _Batch[_j-1];
						_BatchTrig.lTriggerChange[_j] := _BatchTrig.lTriggerChange[_j] + 1;
						
					END_FOR
					
					brsmemset(ADR(_Batch[1]), 0, SIZEOF(_Batch[1]));
					_BatchTrig.lTriggerChange[1] := _BatchTrig.lTriggerChange[1] + 1;

					_wShiftStep := 3;
				3:

					_Batch[1] := _Batch[0];
					_BatchTrig.lTriggerChange[1] := _BatchTrig.lTriggerChange[1] + 1;
					
					brsmemset(ADR(_Batch[0]), 0, SIZEOF(_Batch[0]));
					_BatchTrig.lTriggerChange[0] := _BatchTrig.lTriggerChange[0] + 1;
					
					_xBatchForLoadingOk := FALSE;
					
					brsmemset(_CmdTest.pBatchLoad, 0, SIZEOF(_BatchLoad));
					_BatchLoadTrig[1].lTriggerChange[1] := _BatchLoadTrig[1].lTriggerChange[1] + 1;
					_BatchLoadTrig[2].lTriggerChange[1] := _BatchLoadTrig[2].lTriggerChange[1] + 1;
					_BatchLoadTrig[3].lTriggerChange[1] := _BatchLoadTrig[3].lTriggerChange[1] + 1;

					_wShiftStep := 0;
					
				ELSE
					
					_wShiftStep := 0;
				
			END_CASE
			
		END_IF

		// 1 s Clock

		_Ton1sClck1(IN := NOT _Ton1sClck2.Q, PT := T#500ms);
		_Ton1sClck2(IN := _Ton1sClck1.Q, PT := T#500ms);

		// MachineState
		
		IF _CmdTest.pMachineState > 0 AND _CmdTest.pMachineStateAtt1 > 0 AND _CmdTest.pMachineStateAtt2 > 0 AND _CmdTest.pMachineStateTxt > 0 AND _Ton1sClck2.Q THEN
			
			_enMachineState ACCESS _CmdTest.pMachineState;
			_wMachineStateTxt ACCESS _CmdTest.pMachineStateTxt;
			_lMachineStateAtt1 ACCESS _CmdTest.pMachineStateAtt1;
			_lMachineStateAtt2 ACCESS _CmdTest.pMachineStateAtt2;
			
			_wMachineStateCnt := (_wMachineStateCnt + 1) MOD 1000;
			
			_enMachineState := _wMachineStateCnt;
			_wMachineStateTxt := _wMachineStateCnt + 1;
			_lMachineStateAtt1 := _wMachineStateCnt + 2;
			_lMachineStateAtt2 := _wMachineStateCnt + 3;
			
		END_IF
		
	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
	
END_FUNCTION_BLOCK