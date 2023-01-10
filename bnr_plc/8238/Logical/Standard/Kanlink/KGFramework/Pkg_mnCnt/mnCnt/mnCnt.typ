(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: mnCnt
 * File: mnCnt.typ
 * Author: hunholz
 * Created: November 11, 2011
 ********************************************************************
 * Local data types of program mnCnt
 ********************************************************************)

TYPE
	EventSumDel_enum : 
		(
		Del_Delete,
		Del_Wait,
		Del_Create,
		Del_Info,
		Del_Write,
		Del_Error
		);
	mnCnt_BatchStat_typ : 	STRUCT 
		Weight1 : ARRAY[0..100]OF UDINT;
		Weight2 : ARRAY[0..100]OF UDINT;
	END_STRUCT;
	mnCnt_CounterStat_typ : 	STRUCT 
		sCounterNameId : ARRAY[0..MNCNT_IDX_COUNTER_MAX]OF STRING[10];
		bCounterType : ARRAY[0..MNCNT_IDX_COUNTER_MAX]OF USINT;
		Counter1 : ARRAY[0..MNCNT_IDX_COUNTER_MAX]OF UDINT;
		Counter2 : ARRAY[0..MNCNT_IDX_COUNTER_MAX]OF UDINT;
	END_STRUCT;
	mnCnt_TimerStat_typ : 	STRUCT 
		Counter1 : ARRAY[0..MNCNT_IDX_TIMESTATE_MAX,0..MNCNT_IDX_TIMESUBSTATE_MAX]OF UDINT;
		Counter2 : ARRAY[0..MNCNT_IDX_TIMESTATE_MAX,0..MNCNT_IDX_TIMESUBSTATE_MAX]OF UDINT;
	END_STRUCT;
	mnCnt_DoseStat_typ : 	STRUCT 
		utfDosingName : ARRAY[1..48]OF WSTRING[23];
		sUnit : ARRAY[1..48]OF STRING[11];
		rPumpConst : ARRAY[1..48]OF REAL;
		Counter1 : ARRAY[1..48]OF REAL;
		Counter2 : ARRAY[1..48]OF REAL;
	END_STRUCT;
	mnCnt_DatObjNames_typ : 	STRUCT 
		sBatchStatName : STRING[11] := '_mnCntBst';
		sBatchRBName : STRING[11] := '_mnCntBrb';
		sCountStatName : STRING[11] := '_mnCntCst';
		sCountRBName : STRING[11] := '_mnCntCrb';
		sTimeStatName : STRING[11] := '_mnCntTst';
		sTimeRBName : STRING[11] := '_mnCntTrb';
		sDoseStatName : STRING[11] := '_mnCntDst';
		sDoseRBName : STRING[11] := '_mnCntDrb';
	END_STRUCT;
END_TYPE
