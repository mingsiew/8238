(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: mnParam.fun
 * Author: hunholz
 * Created: February 16, 2012
 ********************************************************************
 * Functions and function blocks of program mnParam
 ********************************************************************)

FUNCTION_BLOCK _ExportContainer (*Schreibe Containerdaten in eine CSV-Datei*)
	VAR_INPUT
		Enable : BOOL;
		pIntern : UDINT;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
		AdStatus : UINT;
		dtContainerWritten : DATE_AND_TIME;
	END_VAR
	VAR
		_Intern : REFERENCE TO PmIntern_typ;
		_ContainerExpState : enum_ContainerExportState := ces_AllocMemCSV;
		_xBusy : BOOL;
		_xReady : BOOL;
		_MemPartAlloc : AsMemPartAllocClear;
		_wIntStatus : UINT;
		_WriteBOM : mnParam_WriteBOM_Mem;
		_WriteComment : mnParam_WriteCSV254_Mem;
		_WriteNewLine : mnParam_WriteNewline_Mem;
		_WriteFileEnd : mnParam_WriteCSV255_Mem;
		_WriteVersion : mnParam_WriteCSV253_Mem;
		_WriteMachineNo : mnParam_WriteCSV252_Mem;
		_WriteTimeStamp : mnParam_WriteCSV251_Mem;
		_WriteNumPar : mnParam_WriteCSV10_Mem;
		_WriteRealPar : mnParam_WriteCSV11_Mem;
		_WriteString : mnParam_WriteCSV20_Mem;
		_DoContainer : REFERENCE TO mnParam_ContainerDyn_typ;
		_DoParamNum : REFERENCE TO mnParam_ParamNumDyn_typ;
		_DoParamString : REFERENCE TO mnParam_ParamStringDyn_typ;
		_DoNum : REFERENCE TO mnParam_CsvNumDyn_typ;
		_DoString : REFERENCE TO mnParam_CsvStringDyn_typ;
		_wOldIdx : UINT;
		_i : UINT;
		_deleteCSVFile : FileDelete;
		_createCSVFile : FileCreate;
		_openCSVFile : FileOpen;
		_writeCSVFile : FileWrite;
		_DTGetTime : DTGetTime;
		_xFault : BOOL;
		_closeCSVFile : FileClose;
		_wIntAdStatus : UINT;
		_MemPartFree : AsMemPartFree;
		_sPathAndFilename : STRING[63];
		_wIdxToc : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK _ExportToc (*Inhaltsverzeichnis schreiben*)
	VAR_INPUT
		Enable : BOOL;
		pIntern : UDINT;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
		AdStatus : UINT;
		dtTocWritten : DATE_AND_TIME;
	END_VAR
	VAR
		_Intern : REFERENCE TO PmIntern_typ;
		_xReady : BOOL;
		_xBusy : BOOL;
		_TocExpState : enum_TocExportState;
		_wIntStatus : UINT;
		_MemPartAlloc : AsMemPartAllocClear;
		_xFault : BOOL;
		_WriteToc : mnParam_WriteCSV80_Mem;
		_i : UINT;
		_WriteBOM : mnParam_WriteBOM_Mem;
		_WriteComment : mnParam_WriteCSV254_Mem;
		_WriteNewLine : mnParam_WriteNewline_Mem;
		_WriteVersion : mnParam_WriteCSV253_Mem;
		_WriteMachineNo : mnParam_WriteCSV252_Mem;
		_WriteTimeStamp : mnParam_WriteCSV251_Mem;
		_DTGetTime : DTGetTime;
		_HeaderTimeRow : mnParam_HeaderTimeRow_typ;
		_sPathAndFilename : STRING[63];
		_deleteCSVFile : FileDelete;
		_WriteFileEnd : mnParam_WriteCSV255_Mem;
		_createCSVFile : FileCreate;
		_wIntAdStatus : UINT;
		_openCSVFile : FileOpen;
		_writeCSVFile : FileWrite;
		_closeCSVFile : FileClose;
		_MemPartFree : AsMemPartFree;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK _DefActContainer (*Fülle ActContainer*)
	VAR_INPUT
		Enable : BOOL;
		bContainerIdx : USINT;
		wInstanceIdx : UINT;
		pIntern : UDINT;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		_Intern : REFERENCE TO PmIntern_typ;
		_DoContainer : REFERENCE TO mnParam_ContainerDyn_typ;
		_lPVadress : UDINT;
		_lPVlen : UDINT;
		_wDimension : UINT;
		_sIndex : STRING[5];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK _GetRights (*Ermittelt Lese- und Schreibrecht*)
	VAR_INPUT
		Enable : BOOL;
		siWriteAccess : SINT;
		siReadAccess : SINT;
		wReference : UINT;
		lPtrLogicStruct : UDINT;
		wMaxIdxLogicStruct : UINT;
	END_VAR
	VAR_OUTPUT
		bWriteAccess : USINT;
		bReadAccess : USINT;
		Status : UINT;
	END_VAR
	VAR
		_DoLogStruc : REFERENCE TO mnParam_LogicalStructDyn_typ;
		_wLogIdx : UINT;
		_xReady : BOOL;
		_bSearchIt : USINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION _BinSearchTxtLine : UINT (*Finde Textzeile nach Function-ID und Nummer*)
	VAR_INPUT
		wFunctionID : UINT;
		wNo : UINT;
		lPtrTxtLines : UDINT;
		wCntRows : UINT;
	END_VAR
	VAR
		_pTextLines : REFERENCE TO ARRAY[0..65534] OF mnTxt_TxtLine_Typ;
		_wMin : UINT;
		_wMax : UINT;
		_wMid : UINT;
	END_VAR
END_FUNCTION

FUNCTION _BinSearchHlpTxtLine : UINT (*Finde Hilfstextzeile nach Funktion-ID und Nummer*)
	VAR_INPUT
		wFunctionID : UINT;
		wNo : UINT;
		lPtrHlpTxtLines : UDINT;
		wCntRows : UINT;
	END_VAR
	VAR
		_pHlpTextLines : REFERENCE TO ARRAY[0..65534] OF mnTxt_HelpTxtLine_Typ;
		_wMin : UINT;
		_wMax : UINT;
		_wMid : UINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK _LimParam (*Parameter begrenzen*)
	VAR_INPUT
		pCsvNumRow : UDINT;
		pParamNum : UDINT;
	END_VAR
	VAR
		_ParamNum : REFERENCE TO mnParam_ParamNumRow_typ;
		_CsvNumRow : REFERENCE TO mnParam_CsvNumRow_typ;
		_rValue : REFERENCE TO REAL;
		_rMinValue : REFERENCE TO REAL;
		_rMaxValue : REFERENCE TO REAL;
	END_VAR
END_FUNCTION_BLOCK
