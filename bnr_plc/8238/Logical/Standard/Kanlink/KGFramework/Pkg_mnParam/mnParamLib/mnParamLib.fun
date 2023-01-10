(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParamLib.fun
 * Author: Reese_Markus
 * Created: July 25, 2011
 ********************************************************************
 * Functions and function blocks of library mnParamLib
 ********************************************************************)

FUNCTION_BLOCK mnParam_BinarySearchInNumeric (*TODO: Add your comment here*)
	VAR_INPUT
		enable : BOOL;
		CsvStructNum : mnParam_CsvNumRow_typ;
		lpList : UDINT;
		lMaxRow : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
		lFoundRow : UDINT;
	END_VAR
	VAR
		_CsvStructNumDyn : REFERENCE TO mnParam_CsvNumDyn_typ;
		_lMin : UDINT;
		_lMax : UDINT;
		_lMid : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_CountLines (*Zählt die gültigen Zeilen der Datei und gibt eine Zeilenstruktur zurück*)
	VAR_INPUT
		enable : BOOL;
		MaxLines : UINT;
		pAdresses : UDINT;
		pLens : UDINT;
		pFile : UDINT;
		FileSize : UDINT;
	END_VAR
	VAR_OUTPUT
		CntLines : UINT;
		status : UINT;
	END_VAR
	VAR
		_plAdresses : REFERENCE TO ARRAY[1..20000] OF UDINT;
		_pwLens : REFERENCE TO ARRAY[1..20000] OF UINT;
		_xNewLine : BOOL;
		_p : UDINT;
		_pChar : REFERENCE TO UINT;
		_lDif : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_GetCsvDat (*Parsen einer CSV-Zeile*)
	VAR_INPUT
		enable : BOOL;
		utfCsvString : WSTRING[299];
	END_VAR
	VAR_OUTPUT
		status : UINT;
		RowType : UINT;
		HeaderVersion : mnParam_HeaderVersionRow_typ;
		HeaderMachineNo : mnParam_HeaderMachineNoRow_typ;
		HeaderTime : mnParam_HeaderTimeRow_typ;
		ContainerRow : mnParam_ContainerRow_typ;
		LogicalStructRow : mnParam_LogicalStructRow_typ;
		ParamNumRow : mnParam_ParamNumRow_typ;
		ParamStringRow : mnParam_ParamStringRow_typ;
		CsvNumRow : mnParam_CsvNumRow_typ;
		CsvStringRow : mnParam_CsvStringRow_typ;
		CsvIPRow : mnParam_CsvIPRow_typ;
		CsvLCIDrow : mnParam_LCIDrow_typ;
		CsvCProw : mnParam_CProw_typ;
		csvTextRow : mnParam_TxtRow_typ;
		csvHelpTextRow : mnParam_HelpTxtRow_typ;
	END_VAR
	VAR
		_utfRowType : WSTRING[15];
		_diRowType : DINT;
		_sRowType : STRING[15];
		_utfSubString : WSTRING[255];
		_sSubString : STRING[63];
		_diVersion : DINT;
		_atodt : mnParam_atodatetime;
		_GetNextSubstring : mnParam_GetNextSubstring;
		_pUtfCsvString : UDINT;
		_diNum : DINT;
		_utfDataObj : WSTRING[11];
		_rValue : REAL;
		_pdiValue : REFERENCE TO DINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_atodatetime (*String mit ISO-Zeitformat in DATE_AND_TIME wandeln*)
	VAR_INPUT
		pStr : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
		dtTimeStamp : DATE_AND_TIME;
	END_VAR
	VAR
		_wPositionInTime : UINT;
		_DateTime : DTStructure;
		_sSubString : STRING[7];
		_sStr : STRING[23];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_GetNextSubstring (*TODO: Add your comment here*)
	VAR_INPUT
		enable : BOOL;
	END_VAR
	VAR_OUTPUT
		status : UINT;
		Length : UDINT;
		pUtfCsvSubstring : UDINT;
		EndOfLine : BOOL;
	END_VAR
	VAR_IN_OUT
		pUtfCsvString : UDINT;
	END_VAR
	VAR
		_lLen : UDINT;
		_lAdrTab : UDINT;
		_utfSubString : WSTRING[255];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_GetContainerOfParamNum (*ContainerID ermitteln und Array-Grenzen*)
	VAR_INPUT
		enable : BOOL;
		pLogicStructs : UDINT;
		wMaxIdxLogicStructs : UINT;
		pParamNum : UDINT;
	END_VAR
	VAR_OUTPUT
		wMinBound : ARRAY[1..4] OF UINT;
		wDimension : ARRAY[1..4] OF UINT;
		status : UINT;
		wCountArray : UINT;
		iContainer : INT;
	END_VAR
	VAR
		_LS : REFERENCE TO ARRAY[1..MNPARAM_MAXIDX_LOGICSTRUCT] OF mnParam_LogicalStructRow_typ;
		_PN : REFERENCE TO mnParam_ParamNumRow_typ;
		_iIdxLS : INT;
		_bMaxCycle : USINT;
		_i : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION GetArrayPV : UINT (*Liefert PV-Adresse mit Indizes*)
	VAR_INPUT
		pPV : UDINT;
		pStructRoot : UDINT;
		pPVFilled : UDINT;
		idx1 : UINT;
		idx2 : UINT;
		idx3 : UINT;
		idx4 : UINT;
	END_VAR
	VAR
		_p : INT;
		_sIndex : STRING[7];
		_GetArrayPV : REFERENCE TO STRING[63];
	END_VAR
END_FUNCTION

FUNCTION_BLOCK mnParam_WritePVNum (*DINT auf beliebige, numerische Variable schreiben*)
	VAR_INPUT
		pAdress : UDINT;
		diValue : DINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		_lPVadress : UDINT;
		_lPVlen : UDINT;
		_lPVdataType : UDINT;
		_lDataLen : UDINT;
		_wDataDimension : UINT;
		_pBool : REFERENCE TO BOOL;
		_pSint : REFERENCE TO SINT;
		_pInt : REFERENCE TO INT;
		_pDint : REFERENCE TO DINT;
		_pUsint : REFERENCE TO USINT;
		_pUint : REFERENCE TO UINT;
		_pUdint : REFERENCE TO UDINT;
		_pDT : REFERENCE TO DATE_AND_TIME;
		_pT : REFERENCE TO TIME;
		_pReal : REFERENCE TO REAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WritePVrNum (*DINT auf beliebige, numerische Variable schreiben*)
	VAR_INPUT
		pAdress : UDINT;
		rValue : REAL;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		_lPVadress : UDINT;
		_lPVlen : UDINT;
		_lPVdataType : UDINT;
		_lDataLen : UDINT;
		_wDataDimension : UINT;
		_pReal : REFERENCE TO REAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_GetContainerOfParamStrin (*Container für String-Parameter bestimmen*)
	VAR_INPUT
		enable : BOOL;
		pLogicStructs : UDINT;
		wMaxIdxLogicStructs : UINT;
		pParamString : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
		wMinBound : ARRAY[1..4] OF UINT;
		wDimension : ARRAY[1..4] OF UINT;
		wCountArray : UINT;
		iContainer : INT;
	END_VAR
	VAR
		_LS : REFERENCE TO ARRAY[1..MNPARAM_MAXIDX_LOGICSTRUCT] OF mnParam_LogicalStructRow_typ;
		_PS : REFERENCE TO mnParam_ParamStringRow_typ;
		_bMaxCycle : USINT;
		_iIdxLS : INT;
		_i : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WritePVString (*Schreibe String-Variable*)
	VAR_INPUT
		pAdress : UDINT;
		p_utfValue : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		_lPVadress : UDINT;
		_lPVlen : UDINT;
		_lPVdataType : UDINT;
		_lDataLen : UDINT;
		_wDataDimension : UINT;
		_utfValue : ARRAY[0..31] OF UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_BinarySearchInString (*Binärsuche von CSV-String-Container-Zeilen*)
	VAR_INPUT
		enable : BOOL;
		lpList : UDINT;
		lMaxRow : UDINT;
		CsvStructString : mnParam_CsvStringRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
		lFoundRow : UDINT;
	END_VAR
	VAR
		_CsvStructStringDyn : REFERENCE TO mnParam_CsvStringDyn_typ;
		_lMin : UDINT;
		_lMax : UDINT;
		_lMid : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV255_Mem (*File-Ende schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..4] OF UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteBOM_Mem (*Byte Order Mark*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV254_Mem (*Kommentarzeile schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		sComment : STRING[63];
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..3] OF UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteNewline_Mem (*Leerzeile*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..1] OF UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_datetimetoa (*Wandelt Datum Zeit in ISO String*)
	VAR_INPUT
		dtTimestamp : DATE_AND_TIME;
	END_VAR
	VAR_OUTPUT
		sDateTime : STRING[19];
	END_VAR
	VAR
		_dtStruc : DTStructure;
		_s2dig : STRING[2];
		_b2dig : REFERENCE TO ARRAY[0..1] OF USINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_datetoa (*Wandelt Datum Zeit in ISO String*)
	VAR_INPUT
		dtTimestamp : DATE_AND_TIME;
	END_VAR
	VAR_OUTPUT
		sDate : STRING[11];
	END_VAR
	VAR
		_dtStruc : DTStructure;
		_s2dig : STRING[2];
		_b2dig : REFERENCE TO ARRAY[0..1] OF USINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV253_Mem (*Versions Kopfzeile*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		VersionRow : mnParam_HeaderVersionRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..11] OF UINT;
		_sVersion : STRING[5];
		_lLen : UDINT;
		_dttoa : mnParam_datetimetoa;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV252_Mem (*Versions Kopfzeile*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		MachineNoRow : mnParam_HeaderMachineNoRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..11] OF UINT;
		_lLen : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV251_Mem (*Dateizeitstempel schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		TimeRow : mnParam_HeaderTimeRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..11] OF UINT;
		_dttoa : mnParam_datetimetoa;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV10_Mem (*Datenzeile numerisch schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		NumRow : mnParam_CsvNumRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..11] OF UINT;
		_sNumeric : STRING[11];
		_lLen : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV20_Mem (*String Daten schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		StringRow : mnParam_CsvStringRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..11] OF UINT;
		_sNumeric : STRING[11];
		_lLen : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV80_Mem (*String Daten schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		ContentRow : mnParam_CsvContent_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..15] OF UINT;
		_sValue : STRING[11];
		_lLen : UDINT;
		_dttoa : mnParam_datetimetoa;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV81_Mem (*String Daten schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		CPRow : mnParam_CProw_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..15] OF UINT;
		_sValue : STRING[23];
		_lLen : UDINT;
		_dttoa : mnParam_datetimetoa;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV90_Mem (*String Daten schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		IPRow : mnParam_CsvIPRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..15] OF UINT;
		_lLen : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK mnParam_WriteCSV11_Mem (*Datenzeile numerisch schreiben*)
	VAR_INPUT
		enable : BOOL;
		pMem : UDINT;
		lMaxSize : UDINT;
		NumRow : mnParam_CsvNumRow_typ;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR_IN_OUT
		lSize : UDINT;
	END_VAR
	VAR
		_pUtfString : REFERENCE TO ARRAY[0..11] OF UINT;
		_sNumeric : STRING[31];
		_lLen : UDINT;
		_pdiValue : REFERENCE TO DINT;
		_rValue : REAL;
	END_VAR
END_FUNCTION_BLOCK
