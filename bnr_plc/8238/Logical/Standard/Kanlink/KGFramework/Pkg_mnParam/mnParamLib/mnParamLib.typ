(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParamLib.typ
 * Author: Reese_Markus
 * Created: July 25, 2011
 ********************************************************************
 * Data types of library mnParamLib
 ********************************************************************)
(**** Zeilen Strukturen ****)

TYPE
	mnParam_HeaderDoRow_typ : 	STRUCT 
		lActEndPos : UDINT;
	END_STRUCT;
	mnParam_HeaderVersionRow_typ : 	STRUCT 
		wVersion : UINT; (*Versionsnummer des Datenmodells*)
		wReserve : UINT;
		dtTimestamp : DATE_AND_TIME; (*Speicherdatum der Datei*)
		utfMachineType : WSTRING[11]; (*Maschinentyp*)
		utfMachineSubType : WSTRING[11]; (*MaschinenSubTyp*)
	END_STRUCT;
	mnParam_HeaderTimeRow_typ : 	STRUCT 
		dtTimestamp : DATE_AND_TIME; (*Zeitstempel der Datei*)
	END_STRUCT;
	mnParam_HeaderMachineNoRow_typ : 	STRUCT 
		utfMachineNo : WSTRING[15]; (*Maschinennummer*)
	END_STRUCT;
	mnParam_ContainerHeader_typ : 	STRUCT 
		xWriteProtected : BOOL; (*Wird gesetzt, wenn Datencontainer im PM-Verzeichnis liegt*)
		bReserve : ARRAY[0..2]OF USINT;
	END_STRUCT;
	mnParam_CProw_typ : 	STRUCT 
		sCategory : STRING[11];
		utfCategoryName : WSTRING[31];
		dtTimeStamp : DATE_AND_TIME;
		wProgramNo : UINT;
		wLoadrate : UINT;
		rSoilfactor : REAL;
		wColFor : UINT;
		wColBack : UINT;
	END_STRUCT;
	mnParam_LCIDrow_typ : 	STRUCT 
		LCID : UINT;
		utfName : WSTRING[31];
	END_STRUCT;
	mnParam_HelpTxtRow_typ : 	STRUCT 
		LCID : UINT;
		FunctionID : UINT;
		TextNo : UINT;
		utfHelpText : WSTRING[255];
	END_STRUCT;
	mnParam_TxtRow_typ : 	STRUCT 
		LCID : UINT;
		FunctionID : UINT;
		TextNo : UINT;
		utfText : WSTRING[63];
	END_STRUCT;
	mnParam_ContainerRow_typ : 	STRUCT 
		siContainerID : SINT; (*<0, 0 ist für _ConfigPar reserviert*)
		bDirectParam : USINT; (*0 - indirekt, 1 - direkt*)
		sNameDataObj : STRING[11]; (*Name des Daten-Objekts*)
		sNameCsv : STRING[31]; (*Name der CSV-Datei*)
		wMinBound : UINT; (*Kleinster Index, wenn es mehrere Container gibt, Dimension muss dazu größer 0 sein*)
		wDimension : UINT; (*0 - Es gibt nur einen Container, >0 - Anzahl der Container, aufsteigend nummeriert*)
		sStrucRoot : STRING[31]; (*Name des Wurzelelements*)
		lCountNum : DINT;
		lCountString : DINT;
	END_STRUCT;
	mnParam_LogicalStructRow_typ : 	STRUCT 
		wLogStrucNo : UINT; (*Eindeutiger Idex für das logische Strukturelement, >0*)
		wMinBound : UINT; (*kleinster Index*)
		wDimension : UINT; (*0 - kein Array*)
		siWriteAccess : SINT; (*Notwendiger Benutzerlevel, um Schreibrecht für alle Parameter unterhalb dieses Knotens zu erlangen, <0 - Recht ist vererbt*)
		siVisibleAccess : SINT; (*Notwendiger Benutzerlevel, um Leserecht für alle Parameter unterhalb dieses Knotens zu erlangen.*)
		iReferenz : INT; (*<=0 - Strukturelement ist Wurzel, >0 - Strukturelement ist Kind von IdxLogStruc*)
		wRefVisible : UINT; (*Verweis auf Parameter, die die Sichtbarkeit steuern*)
		wRefText : UINT; (*Verweis auf ein Textparameter, der das Element beschriftet. Sonst wird der Text aus der Rextresource verwendet*)
		bFormatArray : USINT;
		bReserve : USINT;
		utfMachineSubType : WSTRING[11];
		utfLogStrucName : WSTRING[31];
	END_STRUCT;
	mnParam_ParamNumRow_typ : 	STRUCT 
		wIdxNumPar : UINT; (*Eindeutiger Index für den Numerischen Parameter (Referenziert den Eintrag im Array auf der SPS)*)
		wFunction_ID : UINT; (*Nummer der Funktionsgruppe, zu dem der Parameter gehört*)
		wParNo : UINT; (*Eindeutige Paremeternummer innerhalb der Funktionsgruppe*)
		siWriteAccess : SINT; (*<0 - Recht ist vererbt, Notwendiger Benutzerlevel, um Schreibrecht für alle Parameter unterhalb dieses Knotens zu erlangen.*)
		siVisibleAccess : SINT; (*Notwendiger Benutzerlevel, um Leserecht für alle Parameter unterhalb dieses Knotens zu erlangen*)
		sAdresse : STRING[63]; (*Adress-String (bis zu 4 verschachtelte Arrays sind möglich)*)
		wUnitID : UINT; (*Einheitenklasse*)
		wMinBound : UINT; (*<0 - wird nicht für letzte Arraystufe herangezogen*)
		wDimension : UINT; (*0 - wird nicht für letzte Arraystufe herangezogen*)
		wReferenz : UINT; (*Verweis auf IdxLogStruc*)
		diMinValue : DINT; (*Untere Begrenzung*)
		diMaxValue : DINT; (*Obere Begrenzung*)
		diDefValue : DINT; (*Default Wert*)
		utfMachineSubType : WSTRING[11];
		wITIdx : UINT;
		bRowType : USINT; (*0 - Integer, 1 - Fließkomma*)
		bInputType : USINT;
		wRefVisible : UINT; (*Verweist auf Idx eines numerischen Parameters, der die Sichtbarkeit steuert*)
		wRefVisibleType : UINT; (*Gibt die Regel an, wie die Sichtbarkeit gesteuert wird*)
		wRefText : UINT; (*Verweist auf den Idx eines String Parameters, der in den Parameternamen eingefügt wird.*)
	END_STRUCT;
	mnParam_ParamStringRow_typ : 	STRUCT 
		wIdxStringPar : UINT; (*Eindeutiger Index für den Zeichen Parameter (Referenziert den Eintrag im Array auf der SPS)*)
		wFunction_ID : UINT; (*Nummer der Funktionsgruppe, zu dem der Parameter gehört*)
		wParNo : UINT; (*Eindeutige Parameternummer innerhalb der Funktionsgruppe*)
		bLenght : USINT; (*Maximale Eingabelänge für String (max. 31 Zeichen)*)
		siWriteAccess : SINT; (*<0 - Recht ist vererbt, Notwendiger Benutzerlevel, um Schreibrecht für alle Parameter unterhalb dieses Knotens zu erlangen*)
		siVisibleAccess : SINT; (*Notwendiger Benutzlevel, um Leserecht für alle Parameter unterhalb dieses Knotens zu erlangen*)
		bReserve : USINT;
		sAdresse : STRING[63]; (*Adress-String (bis zu 4 verschachtelete Arrays sind möglich)*)
		wMinBound : UINT; (*<0 - wird nicht für letzte Arraystufe herangezogen*)
		wDimension : UINT; (*0 - wird nicht für letzte Arraystufe herangezogen*)
		wReferenz : UINT; (*Verweis auf IdxLogStruc*)
		utfDefValue : WSTRING[31]; (*Default Wert*)
		utfMachineSubType : WSTRING[11];
		wRefVisible : UINT; (*Verweist auf Idx eines numerischen Parameters, der die Sichtbarkeit steuert*)
		wRefVisibleType : UINT; (*Gibt die Regel an, wie die Sichtbarkeit gesteuert wird*)
		wRefText : UINT; (*Verweist auf den Idx eines String Parameters, der in den Parameternamen eingefügt wird.*)
	END_STRUCT;
	mnParam_CsvNumRow_typ : 	STRUCT 
		wIdxNumPar : UINT; (*Eindeutiger Index für den numerischen Parameter (Referenziert den Eintrag im Array der SPS)*)
		xChanged : BOOL;
		bRowType : USINT; (*0 - Integer, 1 - Real*)
		diValue : DINT; (*Wert des Parameters*)
		wArrIdx1 : UINT; (*1. Array Index*)
		wArrIdx2 : UINT; (*2. Array Index*)
		wArrIdx3 : UINT; (*3. Array Index*)
		wArrIdx4 : UINT; (*4. Array Index*)
		utfMachineSubType : WSTRING[11];
	END_STRUCT;
	mnParam_CsvStringRow_typ : 	STRUCT 
		wIdxStringPar : UINT; (*Eindeutiger Index für den Zeichen Parameter (Referenziert den Eintrag im Array der SPS)*)
		xChanged : BOOL;
		bReserve : USINT;
		utfValue : WSTRING[31]; (*Wert des Parameters*)
		wArrIdx1 : UINT; (*1. Array Index*)
		wArrIdx2 : UINT; (*2. Array Index*)
		wArrIdx3 : UINT; (*3. Array Index*)
		wArrIdx4 : UINT; (*4. Array Index*)
		utfMachineSubType : WSTRING[11];
	END_STRUCT;
	mnParam_CsvIPRow_typ : 	STRUCT 
		utfIP_Adress : WSTRING[15];
		utfGateway : WSTRING[15];
	END_STRUCT;
	mnParam_CsvContent_typ : 	STRUCT 
		iContainerID : SINT; (*ContainerID 0 .. -127*)
		xExist : BOOL; (*Datei existiert*)
		wInstance : UINT; (*Instanz 0 .. 65535*)
		dtTimestamp : DATE_AND_TIME; (*Zeitstempel des Containers*)
	END_STRUCT;
END_TYPE

(**** Dynamische Strukturen ****)

TYPE
	mnParam_ContainerDynHeader_typ : 	STRUCT 
		Do : mnParam_HeaderDoRow_typ; (*Header - Do*)
		Version : mnParam_HeaderVersionRow_typ; (*Header - Version*)
		Time : mnParam_HeaderTimeRow_typ; (*Header - Zeitstempel*)
	END_STRUCT;
	mnParam_ContainerDyn_typ : 	STRUCT  (*Zeilen: 20*)
		Header : mnParam_ContainerDynHeader_typ;
		Container : ARRAY[0..MNPARAM_MAXIDX_CONTAINER]OF mnParam_ContainerRow_typ;
	END_STRUCT;
	mnParam_LogicalStructDyn_typ : 	STRUCT  (*Zeilen: 50*)
		Header : mnParam_ContainerDynHeader_typ;
		LogicalStruct : ARRAY[1..MNPARAM_MAXIDX_LOGICSTRUCT]OF mnParam_LogicalStructRow_typ;
	END_STRUCT;
	mnParam_ParamNumDyn_typ : 	STRUCT  (*Zeilen: 300*)
		Header : mnParam_ContainerDynHeader_typ;
		ParamNum : ARRAY[1..MNPARAM_MAXIDX_PARAMNUM]OF mnParam_ParamNumRow_typ;
	END_STRUCT;
	mnParam_ParamStringDyn_typ : 	STRUCT  (*Zeilen: 300*)
		Header : mnParam_ContainerDynHeader_typ;
		ParamString : ARRAY[1..MNPARAM_MAXIDX_PARAMSTRING]OF mnParam_ParamStringRow_typ;
	END_STRUCT;
	mnParam_CsvDynHeader_typ : 	STRUCT 
		Do : mnParam_HeaderDoRow_typ; (*Header - Do*)
		Version : mnParam_HeaderVersionRow_typ; (*Header - Version*)
		Time : mnParam_HeaderTimeRow_typ; (*Header - Zeitstempel*)
		MachineNo : mnParam_HeaderMachineNoRow_typ; (*Header - Maschinen Nummer*)
		Container : mnParam_ContainerHeader_typ; (*Header - Interne Daten*)
	END_STRUCT;
	mnParam_CsvNumDyn_typ : 	STRUCT  (*Zeilen: 5000*)
		Header : mnParam_CsvDynHeader_typ;
		CsvNum : ARRAY[1..MNPARAM_MAXIDX_CSVNUM]OF mnParam_CsvNumRow_typ;
	END_STRUCT;
	mnParam_CsvStringDyn_typ : 	STRUCT  (*Zeilen: 5000*)
		Header : mnParam_CsvDynHeader_typ; (*Header - Do*)
		CsvString : ARRAY[1..MNPARAM_MAXIDX_CSVSTRING]OF mnParam_CsvStringRow_typ;
	END_STRUCT;
END_TYPE
