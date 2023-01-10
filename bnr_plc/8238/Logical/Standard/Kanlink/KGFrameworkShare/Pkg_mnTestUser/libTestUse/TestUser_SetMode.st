(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: libTestUse
 * File: TestUser_SetMode.st
 * Author: hunholz
 * Created: March 06, 2012
 ********************************************************************
 * Implementation of library libTestUse
 ********************************************************************) 

(* Versetzt die Anwendung in unterschiedliche Testmodi *)
FUNCTION_BLOCK TestUser_SetMode

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
		
		status := ERR_FUB_BUSY;
		
		CASE _wSetModeState OF
			
			0:
				status := TestUser_StopTask(st_name :=  ADR('hlKanLink'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlDos'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				
				status := TestUser_StopTask(st_name :=  ADR('hlSignal'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlDSwIn'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlEncode01'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlFC01'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlMotor'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlSafety'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlRate'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlVirtRate'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlValve'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlTemp'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlNiveau'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('svWetAcc'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('svRoute'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('svDrive01'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				
				status := TestUser_StopTask(st_name :=  ADR('svTakt'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('svFan'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('svCnt'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('fnWater'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('fnHeater'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('fnDrive01'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('mnComp18'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp17'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp16'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp15'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp14'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp13'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp12'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp11'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp10'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp09'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp08'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp07'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp06'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp05'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp04'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp03'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp02'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF
				status := TestUser_StopTask(st_name :=  ADR('mnComp01'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('mnTank'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('mnLoad'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('mnUnload'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('mnMaster'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('fnDos'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlGrease'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('hlHWCont'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('mnKanLink'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('Bufferhand'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				status := TestUser_StopTask(st_name :=  ADR('TestDaten'));
				IF status <> ERR_OK THEN
					RETURN;
				END_IF

				_wSetModeState := 1;
				status := ERR_OK;
				
			ELSE
				
				status := ERR_OK;
			
		END_CASE
		
	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		_wSetModeState := 0;
		
	END_IF
	
END_FUNCTION_BLOCK