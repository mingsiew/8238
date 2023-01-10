(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * File: Batch.typ
 * Author: horn
 * Created: 01.03.2011
 * Changed: 03.08.2011
 ********************************************************************
 * Global data types of project POWERTRANSplus
 ********************************************************************)

TYPE
	BatchProcData_typ : 	STRUCT 
		bProgram : USINT;
		bTypeOfLinen : USINT;
		wDisinfectionTime : UINT;
		wPreWashingTime : UINT;
		wMainWashingTime : UINT;
		wRinsingTime : UINT;
		wTotalWashingTime : UINT;
		xDrainConnectionBox : BOOL;
		xCleanConnectionBox : BOOL;
		xColorChange : BOOL;
	END_STRUCT;
	Batch_typ : 	STRUCT 
		BatchData : BatchData_typ;
		BatchProcData : BatchProcData_typ;
	END_STRUCT;
	BatchLoadTrig_typ : 	STRUCT 
		lTriggerChange : ARRAY[0..2] OF UDINT;
	END_STRUCT;
	BatchTrig_typ : 	STRUCT 
		lTriggerChange : ARRAY[0..30] OF UDINT;
	END_STRUCT;
	BatchLoad_typ : 	STRUCT 
		Batch : ARRAY[0..2] OF Batch_typ;
	END_STRUCT;
	BatchUnloadTrig_typ : 	STRUCT 
		lTriggerChange : ARRAY[0..2] OF UDINT;
	END_STRUCT;
END_TYPE
