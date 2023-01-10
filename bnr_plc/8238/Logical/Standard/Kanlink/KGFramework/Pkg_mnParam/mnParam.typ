(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Pkg_mnParam_Test
 * File: mnParam.typ
 * Author: hunholz
 * Created: July 23, 2011
 ********************************************************************
 * Data types of package Pkg_mnParam_Test
 ********************************************************************)

TYPE
	mnParamStatAd_typ : 	STRUCT 
		xParamOK : BOOL;
		xModelImported : BOOL;
		xSystemfault : BOOL;
		dtExportContent : DATE_AND_TIME;
		HeaderVersion : mnParam_HeaderVersionRow_typ;
		utfMachineNumber : WSTRING[15];
		utfMachineName : WSTRING[31];
		sPkgVersion : STRING[10];
		wCntFilesImportOK : UINT;
		wCntFilesImportFailed : UINT;
		wCntFilesImportFound : UINT;
	END_STRUCT;
END_TYPE

(*INTERFACE*)

TYPE
	mnParam_EditNumValue_typ : 	STRUCT 
		rVal : ARRAY[1..MNPARAM_CNT_EDITROWS]OF REAL;
		xSave : ARRAY[1..MNPARAM_CNT_EDITROWS]OF BOOL;
		wIdx : ARRAY[1..MNPARAM_CNT_EDITROWS]OF UINT;
	END_STRUCT;
	mnParam_EditStrValue_typ : 	STRUCT 
		utfVal : ARRAY[1..MNPARAM_CNT_EDITROWS]OF WSTRING[31];
		xSave : ARRAY[1..MNPARAM_CNT_EDITROWS]OF BOOL;
		wIdx : ARRAY[1..MNPARAM_CNT_EDITROWS]OF UINT;
	END_STRUCT;
	IFmnParamOutEditNumAttr_typ : 	STRUCT 
		wType : UINT;
		wParIdx : UINT;
		wFunctionID : UINT;
		wParamNo : UINT;
		wArrIdx : ARRAY[1..4]OF UINT;
		bWriteAccess : USINT;
		bReadAccess : USINT;
		wUnit : UINT;
		utfParameterName : WSTRING[63];
		utfParameterHelpTxt : WSTRING[255];
		utfInstance : WSTRING[31];
		utfFunction : WSTRING[31];
		sUnit : STRING[11];
		rMin : REAL;
		rMax : REAL;
		rDefault : REAL;
		lDigits : UDINT;
	END_STRUCT;
	IFmnParamOutEditStrAttr_typ : 	STRUCT 
		wType : UINT;
		wParIdx : UINT;
		wFunctionID : UINT;
		wParamNo : UINT;
		wArrIdx : ARRAY[1..4]OF UINT;
		bWriteAccess : USINT;
		bReadAccess : USINT;
		utfParameterName : WSTRING[63];
		utfParameterHelpTxt : WSTRING[255];
		utfInstance : WSTRING[31];
		utfFunction : WSTRING[31];
		utfDefault : WSTRING[31];
		wMaxLength : UINT;
	END_STRUCT;
	IFmnParamOutEdit_typ : 	STRUCT 
		wStatus : UINT;
		bContainer : USINT;
		bCntNumRows : USINT;
		bCntStrRows : USINT;
		bReserve : USINT;
		wContainerInstance : UINT;
		wRowStrCntAll : UINT;
		wRowStrOffset : UINT;
		wRowNumCntAll : UINT;
		wRowNumOffset : UINT;
		lPtrEditNumValues : UDINT;
		lPtrEditStrValues : UDINT;
		AttrNum : ARRAY[1..MNPARAM_CNT_EDITROWS]OF IFmnParamOutEditNumAttr_typ;
		AttrStr : ARRAY[1..MNPARAM_CNT_EDITROWS]OF IFmnParamOutEditStrAttr_typ;
		wCntFilesImportOK : UINT;
		wCntFilesImportFailed : UINT;
		wCntFilesImportFound : UINT;
		wCntNamelist : UINT;
		wIdxContainerNamelist : UINT;
		wParIdxNamelist : UINT;
		wNameListNo : ARRAY[1..MNPARAM_CNT_NAMELIST]OF UINT;
		utfNameListName : ARRAY[1..MNPARAM_CNT_NAMELIST]OF WSTRING[39];
		wFilterFunctionID : UINT;
		utfFilterFunction : WSTRING[31];
	END_STRUCT;
	IFmnParamOut_typ : 	STRUCT 
		utfMachineNumber : WSTRING[15];
		xParamOK : BOOL;
		xModelImported : BOOL;
		xSystemfault : BOOL;
		xRequestMachineNumber : BOOL := FALSE;
		HeaderVersion : mnParam_HeaderVersionRow_typ;
		Edit : IFmnParamOutEdit_typ;
	END_STRUCT;
	IFmnParamInEdit_typ : 	STRUCT 
		wCommand : UINT;
		bContainer : USINT;
		bCntNumRows : USINT;
		bCntStrRows : USINT;
		bLocUnit : USINT;
		bUserLevel : USINT;
		bSelectModeNum : USINT;
		bSelectModeStr : USINT;
		diContainerInstance : DINT;
		wContainerInstanceFrom : UINT;
		wRowStrOffset : UINT;
		wRowNumOffset : UINT;
		wSelParIdxNum : ARRAY[1..MNPARAM_CNT_EDITROWS]OF UINT;
		wSelParArrIdxNum : ARRAY[1..MNPARAM_CNT_EDITROWS,1..4]OF UINT;
		wSelParIdxStr : ARRAY[1..MNPARAM_CNT_EDITROWS]OF UINT;
		wSelParArrIdxStr : ARRAY[1..MNPARAM_CNT_EDITROWS,1..4]OF UINT;
		wSelIdxContainerNamelist : UINT;
		wSelParIdxNamelist : UINT;
		wFilterFunctionID : UINT;
	END_STRUCT;
	IFmnParamIn_typ : 	STRUCT 
		utfSetMachineNumber : WSTRING[15];
		xSetMachineNumber : BOOL := FALSE;
		Edit : IFmnParamInEdit_typ;
	END_STRUCT;
	IFmnParam_typ : 	STRUCT 
		In : IFmnParamIn_typ;
		Out : IFmnParamOut_typ;
	END_STRUCT;
END_TYPE
