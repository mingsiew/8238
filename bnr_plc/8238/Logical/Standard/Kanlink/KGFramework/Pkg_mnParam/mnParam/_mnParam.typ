(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: mnParam
 * File: _mnParam.typ
 * Author: hunholz
 * Created: July 23, 2011
 ********************************************************************
 * Local data types of program mnParam
 ********************************************************************)

TYPE
	enum_CycMainState : 
		(
		cs_MainIdle,
		cs_MainImport,
		cs_MainDelete,
		cs_MainWarning,
		cs_MainWaitCmdZero
		);
	enum_CycIfState : 
		(
		cs_IfIdle,
		cs_IfFillEditor,
		cs_IfSaveEditor,
		cs_IfCreateIndCont,
		cs_IfDeleteIndCont,
		cs_IfCopyIndCont,
		cs_IfRestore,
		cs_IfBackup,
		cs_IfReady,
		cs_IfFillNameList
		);
	enum_CycFillEditor : 
		(
		cs_feIdle,
		cs_feStart,
		cs_feFillEditor,
		cs_feRdySuccess,
		cs_feRdyFault
		);
	enum_CycSaveEditor : 
		(
		cs_seIdle,
		cs_seStart,
		cs_seReadContainer,
		cs_seCommit,
		cs_seWriteDoNum,
		cs_seWriteDoString,
		cs_seWriteDoBin,
		cs_seFreeMem,
		cs_seExpCSV,
		cs_seTOC,
		cs_seRdySuccess,
		cs_seRdyFault
		);
	enum_CycImpState : 
		(
		cs_ImpIdle,
		cs_ImpUSBLinkDevice,
		cs_ImpUSBStart,
		cs_ImpStart,
		cs_ImpDirInfo,
		cs_ImpShowFailed,
		cs_ImpDirRead,
		cs_ImpCheckFile,
		cs_ImpAllocMemFile,
		cs_ImpOpenFile,
		cs_ImpReadFile,
		cs_ImpCloseFile,
		cs_ImpParsVers,
		cs_ImpGetRoot,
		cs_ImpDiNum,
		cs_ImpDiNumDef,
		cs_ImpCpNum,
		cs_ImpDiStr,
		cs_ImpDiStrDef,
		cs_ImpCpStr,
		cs_ImpDiBin,
		cs_ImpDiBinDef,
		cs_ImpCpBin,
		cs_ImpAllocMemNum,
		cs_ImpAllocMemStr,
		cs_ImpRdNum,
		cs_ImpRdStr,
		cs_ImpRdBin,
		cs_ImpSetDefaultNum,
		cs_ImpSetDefaultStr,
		cs_ImpParse,
		cs_ImpFreeMemFile,
		cs_ImpWrNum,
		cs_ImpWrStr,
		cs_ImpSetPV,
		cs_ImpWrBin,
		cs_ImpFreeMemStr,
		cs_ImpFreeMemNum,
		cs_ImpExpCSV,
		cs_ImpDelDir,
		cs_ImpUSBunlinkDevice,
		cs_ImpTOC,
		cs_ImpCPCache1,
		cs_ImpCPCache2,
		cs_ImpRdyFault,
		cs_ImpRdySuccess
		);
	enum_CycDelState : 
		(
		cs_DelIdle,
		cs_DelStart,
		cs_DelDInumPar,
		cs_DelDIstringPar,
		cs_DelDIbinaerPar,
		cs_DelDDnumPar,
		cs_DelDDstringPar,
		cs_DelDDbinaerPar,
		cs_DelDelFile,
		cs_DelExpToc,
		cs_DelRdyFault,
		cs_DelRdySuccess
		);
	enum_CycBackState : 
		(
		cs_BacIdle,
		cs_BacUSBlinkDevice,
		cs_BacCreateDirMachine,
		cs_BacCreateDirBackup,
		cs_BacCreateDirDate,
		cs_BacCopy,
		cs_BacUSBunlinkDevice,
		cs_BacRdyFault,
		cs_BacRdySuccess
		);
	enum_CycCreateState : 
		(
		cs_CrtIdle,
		cs_CrtStart,
		cs_CrtCpyNumDef,
		cs_CrtCpyStringDef,
		cs_CrtCpyBinDef,
		cs_CrtExpCSV,
		cs_CrtTOC,
		cs_CrtRdyFault,
		cs_CrtRdySuccess
		);
	enum_CycCopyState : 
		(
		cs_CpyIdle,
		cs_CpyStart,
		cs_CpyChckTarget,
		cs_CpyCpyNum,
		cs_CpyCpyString,
		cs_CpyCpyBin,
		cs_CpyExpCSV,
		cs_CpyTOC,
		cs_CpyRdyFault,
		cs_CpyRdySuccess
		);
	enum_CycWriteMno : 
		(
		cs_WrMnoIdle,
		cs_WrMnoDelFile,
		cs_WrMnoCreateFile,
		cs_WrMnoWriteFile,
		cs_WrMnoCloseFile,
		cs_WrMnoReset
		);
	enum_InitState : 
		(
		is_DeleteImport := 10,
		is_CreateLog := 15,
		is_CreateMem := 20,
		is_TestDataModel := 40,
		is_CopyDataModel := 50,
		is_InfoDataModelDO := 60,
		is_ReadDataModel := 70,
		is_ParseDataModelVers := 80,
		is_TestVersDataModel := 90,
		is_ResetDataModel := 100,
		is_CreateTempDataModel := 110,
		is_ParseDataModel := 120,
		is_WriteDataModel := 130,
		is_TestDefautDO := 140,
		is_ResetDefaultDO := 150,
		is_CreateDefaultDO1 := 160,
		is_CreateDefaultDO2 := 161,
		is_CreateDefaultDO3 := 162,
		is_CreateDefaultDO4 := 163,
		is_CreateContainerNames := 200,
		is_LookForDOvalue := 210,
		is_LookForFile := 220,
		is_CreateDOvalue := 230,
		is_TestFileDate := 240,
		is_ImportData1 := 250,
		is_ImportData2 := 251,
		is_ImportData3 := 252,
		is_ImportData4 := 253,
		is_SetValue1 := 260,
		is_SetValue2 := 261,
		is_SetValue3 := 262,
		is_ExpCSV := 270
		);
	enum_ContainerExportState : 
		(
		ces_AllocMemCSV,
		ces_CreateCSV,
		ces_DeleteFileCSV,
		ces_CreateFileCSV,
		ces_OpenFileCSV,
		ces_WriteFileCSV,
		ces_CloseFileCSV,
		ces_FreeMemCSV,
		ces_Log
		);
	enum_TocExportState : 
		(
		tes_AllocMemCSV,
		tes_CreateCSV,
		tes_DeleteFileCSV,
		tes_CreateFileCSV,
		tes_OpenFileCSV,
		tes_WriteFileCSV,
		tes_CloseFileCSV,
		tes_FreeMemCSV,
		tes_Log
		);
	PmIntern_typ : 	STRUCT 
		Status : kgMsg_Status_Typ;
		Logger : kgArLogWrite;
		MemSettings : MemSettings_typ;
		ExpSettings : ExpSettings_typ;
		DataModelCsv : DataModelCsv_typ;
		DataObjects : DataObjects_typ;
		CSVFile : DataModelCsv_typ;
		CSVDataObjects : CsvDataObjects_typ;
		Parse : Parse_typ;
		WriteCSV : WriteCSV_typ;
		ActContainer : Container_typ;
		ImportParamCont : DirRead_typ;
		TOC : Toc_typ;
		enInitState : enum_InitState;
		enCycMainState : enum_CycMainState;
		enCycIfState : enum_CycIfState;
		enCycImpState : enum_CycImpState;
		enCycDelState : enum_CycDelState;
		enCycFillEditor : enum_CycFillEditor;
		enCycSaveEditor : enum_CycSaveEditor;
		enCycBackup : enum_CycBackState;
		enCycCreate : enum_CycCreateState;
		enCycCopy : enum_CycCopyState;
		sActPath : STRING[63];
		sActPathAndFilename : STRING[63];
		xResetModelDOs : BOOL;
		xResetConateinerDOs : BOOL;
		xExportContainerCsv : BOOL;
	END_STRUCT;
	DirRead_typ : 	STRUCT 
		lFileNumber : UDINT;
		lFileCnt : UDINT;
		fiDir_Read_Data : ARRAY[1..MNPARAM_CNT_CSVFILES]OF fiDIR_READ_DATA;
		sPcNumber : STRING[7];
	END_STRUCT;
	Container_typ : 	STRUCT 
		sDoNameNum : STRING[11]; (*von Parameter Daten-Objekt*)
		sDoNameString : STRING[11]; (*von Parameter Daten-Objekt*)
		sDoNameDefNum : STRING[11];
		sDoNameDefString : STRING[11];
		sCsvName : STRING[23];
		sDoName : STRING[11]; (*von Struktur Daten-Objekt*)
		sDoNameDef : STRING[11];
		sIndex : STRING[7]; (*Index für die Instanzierung von Container Daten-Objekten*)
		sStrucRoot : STRING[31];
		lAdressStructRoot : UDINT;
		lSizeStructRoot : UDINT;
		lCountParamNum : UDINT; (*Anzahl der numerischen Parametern*)
		lCountParamString : UDINT; (*Anzahl der String-Parameter*)
		siContainerID : SINT;
		bDirect : USINT; (*0 - Indirekt*)
		wMinBound : UINT; (*Untere Grenze, bei mehreren Instanzen*)
		wDimension : UINT; (*Dimension, bei mehreren Instanzen*)
		wIndexIndirect : UINT; (*Laufindex, wenn mehrere Instanzen bearbeitet werden*)
		xDataImported : BOOL;
		xWriteProtected : BOOL;
		xExportfileExist : BOOL;
	END_STRUCT;
	ExpSettings_typ : 	STRUCT 
		sCfDeviceName : STRING[10]; (*Device (Compactflash, USB-Stick)*)
		sPath : STRING[31]; (*Pfad mit abschließendem Backslash*)
		sFilename : STRING[31]; (*Dateiname*)
		sSoftwareComment : STRING[47]; (*Kommentarzeile mit Paketnamen und Version*)
		HeaderMachineNo : mnParam_HeaderMachineNoRow_typ; (*Maschinennummer*)
	END_STRUCT;
	MemSettings_typ : 	STRUCT 
		PartIdent : UDINT; (*Ident der Partition*)
		PartLen : UDINT; (*Größe der Speicherpartition*)
	END_STRUCT;
	Toc_typ : 	STRUCT 
		wStartIdx : ARRAY[0..MNPARAM_MAXIDX_CONTAINER]OF UINT;
		TocEntry : ARRAY[1..MNPARAM_CNT_CSVFILES]OF mnParam_CsvContent_typ;
	END_STRUCT;
	DataModelCsv_typ : 	STRUCT 
		sName : STRING[23] := 'DataModel.csv'; (*Name der DatenModell.csv*)
		sNameInPm : STRING[63] := 'PM\DataModel.csv'; (*Name der DatenModell.csv im PM Ordner*)
		sNameInExp : STRING[63] := 'PM\Export\DataModel.csv'; (*Name der DatenModell.csv im Eport Ordner*)
		lAdress : UDINT;
		lSize : UDINT;
		HeaderVersion : mnParam_HeaderVersionRow_typ;
	END_STRUCT;
	DataObjects_typ : 	STRUCT 
		Names : DoNames_typ;
		Idents : DoIdents_typ;
		Adress : DoIdents_typ;
		Size : DoIdents_typ;
		TempAdresses : DoIdents_typ;
		MaxIndex : DoIdents_typ;
	END_STRUCT;
	CsvDataObjects_typ : 	STRUCT 
		Idents : CSVDoIdents_typ;
		Size : CSVDoIdents_typ;
		Adress : CSVDoIdents_typ;
		TempAdresses : CSVDoIdents_typ;
		MaxIndex : CSVDoIdents_typ;
	END_STRUCT;
	DoNames_typ : 	STRUCT 
		sDataModelContainer : STRING[10] := '_PmCont'; (*Data Model - Container*)
		sDataModelLogicalStruct : STRING[10] := '_PmLogStru'; (*Data Model - Logische Struktur*)
		sDataModelParamNum : STRING[10] := '_PmParNum'; (*Data Model - Parameter*)
		sDataModelParamString : STRING[10] := '_PmParStr'; (*Data Model - Parameter*)
	END_STRUCT;
	DoIdents_typ : 	STRUCT 
		lContainer : UDINT; (*Ident des DataObject Container*)
		lLogicalStruct : UDINT; (*Ident des DataObject Logical Struct*)
		lParamNum : UDINT; (*Ident des DataObject Param Num*)
		lParamString : UDINT; (*Ident des DataObject Param String*)
	END_STRUCT;
	CSVDoIdents_typ : 	STRUCT 
		lCSVNum : UDINT;
		lCSVString : UDINT;
		lDataObjekt : UDINT;
	END_STRUCT;
	Parse_typ : 	STRUCT 
		lFileAdress : UDINT;
		lFileSize : UDINT;
		lCntLines : UDINT;
		lLineTableAdress : UDINT;
		lLineTableLen : UDINT;
	END_STRUCT;
	WriteCSV_typ : 	STRUCT 
		lFileSize : UDINT;
		lFileAdress : UDINT;
	END_STRUCT;
END_TYPE
