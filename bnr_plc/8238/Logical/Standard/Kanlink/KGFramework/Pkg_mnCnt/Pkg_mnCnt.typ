(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Pkg_mnCnt
 * File: Pkg_mnCnt.typ
 * Author: hunholz
 * Created: July 02, 2011
 ********************************************************************
 * Data types of package Pkg_mnCnt
 ********************************************************************)

TYPE
	mnCntLocation_Typ : 	STRUCT 
		sNameId : STRING[10]; (*Text-ID des Ortes*)
		bLocationExt : USINT; (*0 - Interner Ort, 1 - Externer Ort*)
	END_STRUCT;
	mnCntStatAd_Typ : 	STRUCT 
		sPkgVersion : STRING[10];
	END_STRUCT;
	mnCntEventBatch_Typ : 	STRUCT 
		Batch : BatchData_typ;
		FromLocation : mnCntLocation_Typ;
		ToLocation : mnCntLocation_Typ;
		bProgram : USINT;
		bEvent : USINT; (*0 - Beladung, 1 - Entladung, 2 - Geändert, 3 - Gelöscht*)
	END_STRUCT;
	mnCntEventCounter_Typ : 	STRUCT 
		Source : mnCntLocation_Typ; (*Quell Ort für Medien*)
		Destination : mnCntLocation_Typ; (*Ziel Ort für Medien, Ort der Messung*)
		BatchNo : GUID_type; (*Postennummer (long oder GUID)*)
		dtTimeStamp : DATE_AND_TIME; (*Zeitstempel des Zählwerts*)
		lAmount : UDINT; (*Menge bzw. Wert*)
		lNomAmount : UDINT; (*Sollmenge*)
		bTypeBatchNo : USINT; (*0 - Postennummer ist long, 1 - Postennummer ist GUID*)
		bType : USINT; (*1 - Wasser, 2 - Dampf, 3 - Gas, 4 - Elektrische Energie, 11 - Temperatur, 12 - Druck, 13 - Drehzahl*)
	END_STRUCT;
	mnCntEventDosing_Typ : 	STRUCT 
		BatchNo : GUID_type; (*Postennummer (long oder GUID)*)
		dtTimeStamp : DATE_AND_TIME; (*Zeitstempel der Dosierung*)
		rNomAmount : REAL; (*Solldosiermenge*)
		rAmount : REAL; (*Istdosiermenge*)
		rPumpConst : REAL; (*Pumpenkonstante*)
		sUnit : STRING[11]; (*Einheit der Dosierung*)
		utfName : WSTRING[23]; (*Name der Dosierung*)
		Source : mnCntLocation_Typ; (*Quelle*)
		Destination : mnCntLocation_Typ; (*Zielort*)
		bTypeBatchNo : USINT; (*0 - Postennummer ist long, 1 - Postennummer ist GUID*)
	END_STRUCT;
	mnCntEventDosingId_Typ : 	STRUCT 
		bId : USINT;
		DosingEvent : mnCntEventDosing_Typ;
	END_STRUCT;
	IFmnCnt_Typ : 	STRUCT 
		In : IFmnCntIn_Typ;
		Out : IFmnCntOut_Typ;
	END_STRUCT;
	mnCntEventTime_Typ : 	STRUCT 
		dtTimeStamp : DATE_AND_TIME;
		lAmount : UDINT; (*Zeitintervall*)
		bState : USINT; (*0 - Inaktiv, 1 - Warten, 2 - Aktiv*)
		bSubState : USINT; (*0.0 - AUS/Taktende, 0.1 - Stop, 0.2 - int. Störung, 0.3 - ext. Störung, 0.4 - Sicherer Halt, 0.5 - NOT-HALT, 1.0 - Beladung, 1.1 - Entladung, 1.2 - Dosierung, 2.0 - Prozess, 2.1 - Vorbereitung*)
	END_STRUCT;
	IFmnCntOut_Typ : 	STRUCT 
		wStatus : UINT;
		xBatchEventReadOK : BOOL;
		xCounterEventReadOK : ARRAY[0..MNCNT_IDX_COUNTER_MAX]OF BOOL;
		xDosingEventReadOK : ARRAY[1..48]OF BOOL;
		xTimeEventReadOK : BOOL;
	END_STRUCT;
	IFmnCntIn_Typ : 	STRUCT 
		wCmd : UINT;
		bBatchEventValid : USINT; (*0->1: Batchevent übernehmen*)
		bCntEventValid : ARRAY[0..MNCNT_IDX_COUNTER_MAX]OF USINT; (*0->1 : Zählerwert übernehmen*)
		bDosingEventValid : ARRAY[1..48]OF USINT; (*0->1 : Zählerwert übernehmen*)
		bTimeEventValid : USINT; (*0->1 : Zeitwert übernehmen*)
		BatchEvent : mnCntEventBatch_Typ; (*Postenevent*)
		CounterEvent : ARRAY[0..MNCNT_IDX_COUNTER_MAX]OF mnCntEventCounter_Typ; (*Zählerevents*)
		DosingEvent : ARRAY[1..48]OF mnCntEventDosing_Typ; (*max. 48 Dosierevents*)
		TimeEvent : mnCntEventTime_Typ; (*Zeitwerte*)
	END_STRUCT;
	mnCntParMacDosingDef_Typ : 	STRUCT 
		utfName : WSTRING[23];
		xUseConversion : BOOL;
		bCompartment : USINT;
		bIdx : USINT;
		bReserve : USINT;
		rConversionMultiplier : REAL;
		sUnit : STRING[11];
	END_STRUCT;
	mnCntParMac_Typ : 	STRUCT 
		DosingDefines : ARRAY[1..48]OF mnCntParMacDosingDef_Typ;
	END_STRUCT;
	mnCntPar_Typ : 	STRUCT 
		Mac : mnCntParMac_Typ;
	END_STRUCT;
END_TYPE
