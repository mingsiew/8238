(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: kgGetBatchNoUnique.st
 * Author: hunholz
 * Created: July 19, 2011
 * Changed: February 15, 2012
 ********************************************************************
 * Implementation of library KGstd
 ********************************************************************) 

(* Batchnummer als Unique Identifier 16 Byte *)
FUNCTION_BLOCK kgGetBatchNoUnique

	Status := ERR_OK;

	brsmemset(ADR(BatchNo),0,SIZEOF(BatchNo));

	IF Enable THEN
		
		DTGetTime_0(enable := TRUE);
		
		_time := clock_ms();

		brsmemcpy(ADR(BatchNo[0]),ADR(DTGetTime_0.DT1), 4);
		brsmemcpy(ADR(BatchNo[4]),ADR(_time), 2);
		BatchNo[6] := 16#10;
		brsmemcpy(ADR(BatchNo[7]),ADR(_time)+2, 1);
		BatchNo[8] := 16#50;
		brsmemcpy(ADR(BatchNo[9]),ADR(_time)+3, 1);
		brsmemcpy(ADR(BatchNo[10]), ADR(Mac[0]), 6);
		
	ELSE
			
		Status := ERR_FUB_ENABLE_FALSE;
		
	END_IF

END_FUNCTION_BLOCK
