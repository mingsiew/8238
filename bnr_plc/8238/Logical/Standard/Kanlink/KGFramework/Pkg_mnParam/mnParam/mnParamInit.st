(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: mnParam
 * File: mnParamInit.st
 * Author: hunholz
 * Created: July 23, 2011
 * Changed: December 20, 2011
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************)

PROGRAM _INIT

	// Debug
	
	_lSingleStep;
	_wSinglestep;
	_lLoop;
	
	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'mnParam';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnParamStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnParamStatAd.sPkgVersion := '---';
		
	END_IF
	
	_PmIntern.ExpSettings.sSoftwareComment := 'Parameter Manager mnParam ';
	_PmIntern.ExpSettings.sSoftwareComment := CONCAT(_PmIntern.ExpSettings.sSoftwareComment, mnParamStatAd.sPkgVersion);
	
	// Um SINGLEmnParam zu definieren, muss in den Eigenschaften der Task mnParam (Configuration View - Cpu.sw)
	// im Tabulator "Compiler" im Feld "Additional build options:" folgendes eingetragen sein: 
// -D SINGLEmnParam

#ifdef SINGLEmnParam
	
	// Singlestep, ja oder nein
	_xSingleStep := TRUE;
	_lSingleStep := 0;
	_wSinglestep := 0;
	#else

	// Singlestep, ja oder nein
	_xSingleStep := FALSE;

#endif

	// Start der Initialisierung
	_xInitOk := FALSE;
	
	mnParamStatAd.xParamOK := FALSE;
	IFmnParam.Out.xParamOK := FALSE;
	

	// Interner Status
	_PmIntern.Status.wFunction_ID := MNPARAM_FUNCTIONID;
	
	// enInitState als UDINT
	_pl_InitState ACCESS ADR(_PmIntern.enInitState);

	REPEAT // Init, einmaliger Durchlauf

		//****************************************************************************************************************
		// Linke Device F:\
		//****************************************************************************************************************
		_PmIntern.enInitState := is_DeleteImport;

		//****************************************************************************************************************
		// Importverzeichnis löschen
		//****************************************************************************************************************

		REPEAT

			_DirDeleteEx(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(MNPARAM_PATH_IMPORT));

			UNTIL
			_DirDeleteEx.status <> ERR_FUB_BUSY
		END_REPEAT

		//****************************************************************************************************************
		// Log erzeugen
		//****************************************************************************************************************
		_PmIntern.enInitState := is_CreateLog;

		_PmIntern.Logger.enable := TRUE;
		_PmIntern.Logger.ident := 0;
		_PmIntern.Logger.errornr := 50000;
		
		_AsArLogCreate(enable := TRUE, pName := ADR('mnParamL'), len := 4096*4, memType := arlogUSRROM);
		
		IF _AsArLogCreate.status = ERR_OK THEN
			
			_PmIntern.Logger.ident := _AsArLogCreate.ident;
			
		ELSIF _AsArLogCreate.status = arlogERR_EXISTING THEN
			
			_AsArLogGetInfo(enable := TRUE, pName := ADR('mnParamL'));

			IF _AsArLogGetInfo.status = ERR_OK THEN
				
				_PmIntern.Logger.ident := _AsArLogGetInfo.ident;
				
			END_IF
			
		END_IF

		//****************************************************************************************************************
		// Konfigurierte Konstanten gegen die Library prüfen
		//****************************************************************************************************************

		IF MNPARAM_CNT_LOGICSTRUCT > MNPARAM_MAXIDX_LOGICSTRUCT OR MNPARAM_CNT_PARAMNUM > MNPARAM_MAXIDX_PARAMNUM OR MNPARAM_CNT_PARAMSTRING > MNPARAM_MAXIDX_PARAMSTRING THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'Value for MNPARAM_CNT_... to high!';
			_PmIntern.Logger.var1		:= 0;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;

		END_IF
		
		


		//#########################################################################################
		//							START VORBEREITUNG DATENMODELL
		//#########################################################################################



		//****************************************************************************************************************
		// Ist das Datenmodell vorhanden ?
		//****************************************************************************************************************


		_PmIntern.enInitState := is_TestDataModel;

		_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_PmIntern.DataModelCsv.sNameInPm), pInfo := ADR(_fiFileInfo));
		
		IF _FileInfo.status <> ERR_OK OR _fiFileInfo.size <= SIZEOF(KGBOM) THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= CONCAT(_PmIntern.DataModelCsv.sNameInPm, ' :  FileInfo.status = {##AttrVar1}');
			_PmIntern.Logger.var1		:= _FileInfo.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;
	
		END_IF
				
		_PmIntern.DataModelCsv.lSize := _fiFileInfo.size - SIZEOF(KGBOM);		
				
		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
		#ifdef SINGLEmnParam
		REPEAT
			UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
		#endif


		//****************************************************************************************************************
		// Speicher Erzeugen, für schnelles parsen im Hauptspeicher
		//****************************************************************************************************************
		_PmIntern.enInitState := is_CreateMem;

		// Berechnung des Benötigten Speicherplatzes
		
		_lLineMem := (((SIZEOF(_plLineAdress) + SIZEOF(_pwLineLen)) / 8) + 2 ) * 8;
		
		_lModelMem := ((_PmIntern.DataModelCsv.lSize / 8) + 2) * 8;
		_lModelMem := _lModelMem + ((SIZEOF(_pDoContainer) / 8) + 2) * 8;
		_lModelMem := _lModelMem + (((SIZEOF(_pDoLogicalStruct.Header) + MNPARAM_CNT_LOGICSTRUCT*SIZEOF(_pDoLogicalStruct.LogicalStruct[1])) / 8) + 2) * 8;
		_lModelMem := _lModelMem + (((SIZEOF(_pDoParamNum.Header) + MNPARAM_CNT_PARAMNUM*SIZEOF(_pDoParamNum.ParamNum[1])) / 8) + 2) * 8;
		_lModelMem := _lModelMem + (((SIZEOF(_pDoParamString.Header) + MNPARAM_CNT_PARAMSTRING*SIZEOF(_pDoParamString.ParamString[1])) / 8) + 2) * 8;
		
		_lContMem := ((MNPARAM_TEMPWRITECSVSIZE / 8) + 2) * 8;
		_lContMem := _lContMem + (((SIZEOF(mnParam_ContainerDynHeader_typ) + MNPARAM_CNT_NUMPARAMS*SIZEOF(_pDoContainerNum.CsvNum[1])) / 8) + 2) * 8;
		_lContMem := _lContMem + (((SIZEOF(mnParam_ContainerDynHeader_typ) + MNPARAM_CNT_STRINGPARAMS*SIZEOF(_pDoContainerString.CsvString[1])) / 8) + 2) * 8;
		
		_PmIntern.MemSettings.PartLen := _lLineMem + MAX(_lModelMem, _lContMem) + 1000;
		
		_MemPartCreate(enable := TRUE, len := _PmIntern.MemSettings.PartLen);

		IF _MemPartCreate.status <> ERR_OK THEN

			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'MemPartCreate.status = {##AttrVar1}';
			_PmIntern.Logger.var1		:= _MemPartCreate.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;
			
		END_IF
		
		_PmIntern.MemSettings.PartIdent := _MemPartCreate.ident;

		// Zeilenadresstabelle
		_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(_plLineAdress) + SIZEOF(_pwLineLen) );
		
		IF _MemPartAlloc.status <> ERR_OK THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'Line adress/len table: MemPartAlloc.status = {##AttrVar1}';
			_PmIntern.Logger.var1		:= _MemPartAlloc.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;

		END_IF		

		_PmIntern.Parse.lLineTableAdress := _MemPartAlloc.mem;
		_plLineAdress ACCESS _PmIntern.Parse.lLineTableAdress;
		
		_PmIntern.Parse.lLineTableLen := _PmIntern.Parse.lLineTableAdress + SIZEOF(_plLineAdress);
		_pwLineLen ACCESS _PmIntern.Parse.lLineTableLen;

		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
		#ifdef SINGLEmnParam
		REPEAT
			UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
		#endif


		//****************************************************************************************************************
		// Datenmodell auf jeden Fall in das Export-Verzeichnis kopieren
		//****************************************************************************************************************


		_PmIntern.enInitState := is_CopyDataModel;
		
		_DirCreate(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(MNPARAM_PATH_EXPORT));

		_FileCopy(enable := TRUE, pSrcDev := ADR(KG_DEVICE_COMPACTFLASH), pSrc := ADR(_PmIntern.DataModelCsv.sNameInPm), pDestDev := ADR(KG_DEVICE_COMPACTFLASH), pDest := ADR(_PmIntern.DataModelCsv.sNameInExp), option := fiOVERWRITE);
		
		IF _FileCopy.status <> ERR_OK THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
			_PmIntern.Logger.text		:= CONCAT(_PmIntern.DataModelCsv.sNameInPm, ' :  FileCopy.status = {##AttrVar1}');
			_PmIntern.Logger.var1		:= _FileCopy.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

		END_IF
				
		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
		#ifdef SINGLEmnParam
		REPEAT
			UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
		#endif



		//****************************************************************************************************************
		// Informationen der Datenobjekte zum Datenmodell einlesen
		//****************************************************************************************************************


		_PmIntern.enInitState := is_InfoDataModelDO;
		
		// Wenn es Unstimmigkeiten gibt, müssen vorhandene Modell-Datenobjekte gelöscht und neu angelegt werden
		_PmIntern.xResetModelDOs := FALSE;

		// Containerabbild
		
		// Exemplarisch 
		// Prüfen, ob das DO vorhanden ist und ob die Größe wenigstens den Header enthalten kann
		// sonst wird das Datenmodell komplett neu eingelesen
		_diContainer(enable := TRUE, pName := ADR(_PmIntern.DataObjects.Names.sDataModelContainer));
		
		_PmIntern.DataObjects.Idents.lContainer := 0;

		IF _diContainer.status = ERR_OK THEN
			
			_PmIntern.DataObjects.Idents.lContainer := _diContainer.ident;
			_PmIntern.DataObjects.Adress.lContainer := _diContainer.pDatObjMem;
			_PmIntern.DataObjects.Size.lContainer := _diContainer.len;

			IF _diContainer.len >= SIZEOF(mnParam_ContainerDynHeader_typ) THEN
				
				_pDoContainer ACCESS _PmIntern.DataObjects.Adress.lContainer;

				// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
				_PmIntern.DataObjects.MaxIndex.lContainer := ( (_pDoContainer.Header.Do.lActEndPos - SIZEOF(mnParam_ContainerDynHeader_typ)) / SIZEOF(_pDoContainer.Container[0]) );
				IF _PmIntern.DataObjects.MaxIndex.lContainer > 0 THEN
					_PmIntern.DataObjects.MaxIndex.lContainer := _PmIntern.DataObjects.MaxIndex.lContainer -1;
				END_IF
				
			ELSE
				
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Dataobject Containerdefinition Datamodel to small, create new!';
				_PmIntern.Logger.var1		:= 0;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_PmIntern.xResetModelDOs := TRUE;
				
			END_IF

		ELSE
			
			_PmIntern.xResetModelDOs := TRUE;

			_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
			_PmIntern.Logger.text		:= 'Dataobject Containerdefinition is not existing: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _diContainer.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();
			
		END_IF

		// Strukturabbild
		_diLogicalStruct(enable := TRUE, pName := ADR(_PmIntern.DataObjects.Names.sDataModelLogicalStruct));
		
		_PmIntern.DataObjects.Idents.lLogicalStruct := 0;

		IF _diLogicalStruct.status = ERR_OK THEN
			
			_PmIntern.DataObjects.Idents.lLogicalStruct := _diLogicalStruct.ident;
			_PmIntern.DataObjects.Adress.lLogicalStruct := _diLogicalStruct.pDatObjMem;
			_PmIntern.DataObjects.Size.lLogicalStruct := _diLogicalStruct.len;
			
			IF _diLogicalStruct.len >= SIZEOF(mnParam_ContainerDynHeader_typ) THEN
				
				_pDoLogicalStruct ACCESS _PmIntern.DataObjects.Adress.lLogicalStruct;

				// Maximalen Index für Einträge prüfen.
				_PmIntern.DataObjects.MaxIndex.lLogicalStruct := ( (_pDoLogicalStruct.Header.Do.lActEndPos - SIZEOF(mnParam_ContainerDynHeader_typ)) / SIZEOF(_pDoLogicalStruct.LogicalStruct[1]) );
				
			ELSE
				
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Dataobject Logical Structure Datamodel to small, create new!';
				_PmIntern.Logger.var1		:= 0;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_PmIntern.xResetModelDOs := TRUE;
				
			END_IF

		ELSE
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
			_PmIntern.Logger.text		:= 'Dataobject Logical Structure is not existing: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _diLogicalStruct.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_PmIntern.xResetModelDOs := TRUE;
			
		END_IF
		
		// Numerische Parameter
		_diParamNum(enable := TRUE, pName := ADR(_PmIntern.DataObjects.Names.sDataModelParamNum));
		
		_PmIntern.DataObjects.Idents.lParamNum := 0;

		IF _diParamNum.status = ERR_OK THEN
			
			_PmIntern.DataObjects.Idents.lParamNum := _diParamNum.ident;
			_PmIntern.DataObjects.Adress.lParamNum := _diParamNum.pDatObjMem;
			_PmIntern.DataObjects.Size.lParamNum := _diParamNum.len;
			
			IF _diParamNum.len >= SIZEOF(mnParam_ContainerDynHeader_typ) THEN
				
				_pDoParamNum ACCESS _PmIntern.DataObjects.Adress.lParamNum;

				// Maximalen Index für Einträge prüfen.
				_PmIntern.DataObjects.MaxIndex.lParamNum := ( (_pDoParamNum.Header.Do.lActEndPos - SIZEOF(mnParam_ContainerDynHeader_typ)) / SIZEOF(_pDoParamNum.ParamNum[1]) );
				
			ELSE
				
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Dataobject Numeric Parameter Datamodel to small, create new!';
				_PmIntern.Logger.var1		:= 0;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_PmIntern.xResetModelDOs := TRUE;
				
			END_IF

		ELSE
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
			_PmIntern.Logger.text		:= 'Dataobject Numeric Parameter is not existing: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _diParamNum.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_PmIntern.xResetModelDOs := TRUE;
			
		END_IF

		// String Parameter
		_diParamString(enable := TRUE, pName := ADR(_PmIntern.DataObjects.Names.sDataModelParamString));
		
		_PmIntern.DataObjects.Idents.lParamString := 0;

		IF _diParamString.status = ERR_OK THEN
			
			_PmIntern.DataObjects.Idents.lParamString := _diParamString.ident;
			_PmIntern.DataObjects.Adress.lParamString := _diParamString.pDatObjMem;
			_PmIntern.DataObjects.Size.lParamString := _diParamString.len;
			
			IF _diParamString.len >= SIZEOF(mnParam_ContainerDynHeader_typ) THEN
				
				_pDoParamString ACCESS _PmIntern.DataObjects.Adress.lParamString;

				// Maximalen Index für Einträge prüfen.
				_PmIntern.DataObjects.MaxIndex.lParamString := ( (_pDoParamString.Header.Do.lActEndPos - SIZEOF(mnParam_ContainerDynHeader_typ)) / SIZEOF(_pDoParamString.ParamString[1]) );
				
			ELSE
				
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Dataobject String Parameter Datamodel to small, create new!';
				_PmIntern.Logger.var1		:= 0;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_PmIntern.xResetModelDOs := TRUE;
				
			END_IF
			
			
		ELSE
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
			_PmIntern.Logger.text		:= 'Dataobject String Parameter is not existing: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _diParamString.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_PmIntern.xResetModelDOs := TRUE;
			
		END_IF

		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
		#ifdef SINGLEmnParam
		REPEAT
			UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif



		//****************************************************************************************************************
		// Speicher allokieren und Datenmodell in den Speicher laden
		//****************************************************************************************************************

		_PmIntern.enInitState := is_ReadDataModel;

		_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.DataModelCsv.lSize);
		
		IF _MemPartAlloc.status <> ERR_OK THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'Load Datamodel, MemPartAlloc: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _MemPartAlloc.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;
	
		END_IF		

		_PmIntern.Parse.lFileAdress := _MemPartAlloc.mem;
		_PmIntern.Parse.lFileSize := _PmIntern.DataModelCsv.lSize;

		_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH),pFile := ADR(_PmIntern.DataModelCsv.sNameInPm), mode := fiREAD_ONLY);

		IF _FileOpen.status <> ERR_OK THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'Load Datamodel, FileOpen: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _FileOpen.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;
	
		END_IF		

		_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _PmIntern.Parse.lFileAdress, len :=  _PmIntern.Parse.lFileSize ) ;

		IF _FileRead.status <> ERR_OK THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'Load Datamodel, FileRead: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _FileRead.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;
	
		END_IF	
		
		_FileClose(enable := TRUE, ident := _FileOpen.ident);

		IF _FileClose.status <> ERR_OK THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
			_PmIntern.Logger.text		:= 'Load Datamodel, FileClose: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _FileClose.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

		END_IF	

		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
		#ifdef SINGLEmnParam
		REPEAT
			UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
		#endif

		//****************************************************************************************************************
		// Datenmodell parsen bis Version
		//****************************************************************************************************************


		_PmIntern.enInitState := is_ParseDataModelVers;
		
		brsmemset(_PmIntern.Parse.lLineTableAdress, 0, MNPARAM_MAXPARSELINES * SIZEOF(UDINT));
		brsmemset(_PmIntern.Parse.lLineTableLen, 0, MNPARAM_MAXPARSELINES * SIZEOF(UINT));
		
		_CountLines.enable 	:= TRUE;
		_CountLines.pFile 		:= _PmIntern.Parse.lFileAdress;
		_CountLines.FileSize 	:= _PmIntern.Parse.lFileSize;
		_CountLines.MaxLines	:= MNPARAM_MAXPARSELINES;
		_CountLines.pAdresses	:= _PmIntern.Parse.lLineTableAdress;
		_CountLines.pLens		:= _PmIntern.Parse.lLineTableLen;
		
		_CountLines();
		
		IF _CountLines.status <> ERR_OK THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'Read Datamodel, CountLines: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _CountLines.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;
		
		END_IF

		_PmIntern.Parse.lCntLines := _CountLines.CntLines;
		
		// Suche Versionszeile
		
		_wStartLine := 1;
		
		REPEAT
			
			_GetCsvDat.enable := TRUE;
			brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
			_GetCsvDat();
			_wStartLine := _wStartLine + 1;
			
			UNTIL
			_GetCsvDat.RowType = MNPARAM_CSV_HEADER_VERSION OR _wStartLine > _PmIntern.Parse.lCntLines
		END_REPEAT

		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
		#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif

		IF _GetCsvDat.RowType <> MNPARAM_CSV_HEADER_VERSION THEN
			
			_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
			_PmIntern.Logger.text		:= 'Read Datamodel. No Version!';
			_PmIntern.Logger.var1		:= 0;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();

			_xSysError := TRUE;

			EXIT;
		
		END_IF
		
		_PmIntern.DataModelCsv.HeaderVersion := _GetCsvDat.HeaderVersion;
		mnParamStatAd.HeaderVersion := _PmIntern.DataModelCsv.HeaderVersion;
		IFmnParam.Out.HeaderVersion := _PmIntern.DataModelCsv.HeaderVersion;

		IFmnParam.Out.utfMachineNumber := MNPARAM_INVALID_MACHINENO;
		mnParamStatAd.utfMachineNumber := MNPARAM_INVALID_MACHINENO;
		_PmIntern.ExpSettings.HeaderMachineNo.utfMachineNo := MNPARAM_INVALID_MACHINENO;

		_sPathMnrCsv := 'PM\_mnr.csv'; 
		
		_FileOpenCsv(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPathMnrCsv), mode := fiREAD_ONLY);
	
		IF _FileOpenCsv.status = ERR_OK THEN
		
			_FileReadCsv(enable := TRUE, ident := _FileOpenCsv.ident, pDest := ADR(_utfParseMem), len := SIZEOF(_utfParseMem));
		
			IF _FileReadCsv.status = ERR_OK THEN
			
				_GetCsvDat.enable := TRUE;
				brwcsncpy( ADR(_GetCsvDat.utfCsvString), ADR(_utfParseMem)+2, SIZEOF(_utfParseMem)-2);
				// Nur erste Zeile
				_lPosLF := brwcschr(ADR(_GetCsvDat.utfCsvString),16#0A);
				_lPosCR := brwcschr(ADR(_GetCsvDat.utfCsvString),16#0D);
				IF (_lPosCR <> 0) THEN
					brsmemset(_lPosCR , 0, 2);
				END_IF
				IF (_lPosLF <> 0) THEN
					brsmemset(_lPosLF , 0, 2);
				END_IF
					
				_GetCsvDat();
			
				IF _GetCsvDat.RowType = MNPARAM_CSV_HEADER_MACHINENO THEN
				
					IF brwcslen(ADR(_GetCsvDat.HeaderMachineNo.utfMachineNo)) > 0 THEN
						IFmnParam.Out.utfMachineNumber := _GetCsvDat.HeaderMachineNo.utfMachineNo;
						mnParamStatAd.utfMachineNumber := _GetCsvDat.HeaderMachineNo.utfMachineNo;
						_PmIntern.ExpSettings.HeaderMachineNo := _GetCsvDat.HeaderMachineNo;
					ELSE
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Machineno. is an empty string!';
						_PmIntern.Logger.var1		:= _FileOpenCsv.status;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

						IF MNPARAM_REQMISSINGMNO = 1 THEN
				
							IFmnParam.Out.xRequestMachineNumber := TRUE;
							EXIT;
				
						END_IF

					END_IF

				ELSE
					
					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Read Machinenumber, no Rowtype 252 in first line!';
					_PmIntern.Logger.var1		:= _FileOpenCsv.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();

					IF MNPARAM_REQMISSINGMNO = 1 THEN
				
						IFmnParam.Out.xRequestMachineNumber := TRUE;
						EXIT;
				
					END_IF

				END_IF

			ELSE
				
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Read Machinenumber, FileRead: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _FileReadCsv.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				IF MNPARAM_REQMISSINGMNO = 1 THEN
				
					IFmnParam.Out.xRequestMachineNumber := TRUE;
					EXIT;
				
				END_IF

			END_IF	

			_FileCloseCsv(enable := TRUE, ident := _FileOpenCsv.ident);

		ELSE

			_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
			_PmIntern.Logger.text		:= 'Read Machinenumber, FileOpen: {##AttrVar1}';
			_PmIntern.Logger.var1		:= _FileOpenCsv.status;
			_PmIntern.Logger.var2		:= 0;
			_PmIntern.Logger();
			
			IF MNPARAM_REQMISSINGMNO = 1 THEN
				
				IFmnParam.Out.xRequestMachineNumber := TRUE;
				EXIT;
				
			END_IF

		END_IF

		// Aus Kompatibilitätsgründen, werden Maschinennummer und Maschinentyp in die _Info_ geschrieben
		IF PV_xgetadr(ADR('_Info_.InfoGeneral.utfMaschinennummer[0]'), ADR(_lAdrInfoMaschinennummer), ADR(_lLenInfoMaschinennummer)) = ERR_OK THEN
			_utfMaschinennummer ACCESS _lAdrInfoMaschinennummer;
			_utfMaschinennummer := IFmnParam.Out.utfMachineNumber;
		END_IF
		IF PV_xgetadr(ADR('_Info_.InfoGeneral.utfMaschinentyp[0]'), ADR(_lAdrInfoMaschinentyp), ADR(_lLenInfoMaschinentyp)) = ERR_OK THEN
			_utfMaschinentyp ACCESS _lAdrInfoMaschinentyp;
			_utfMaschinentyp := mnParamStatAd.HeaderVersion.utfMachineType;
		END_IF
		
		
		//****************************************************************************************************************
		// Prüfe die Version des bereits vorhanden Datanmodells
		//****************************************************************************************************************

		_PmIntern.enInitState := is_TestVersDataModel;

		IF NOT _PmIntern.xResetModelDOs THEN
			
			// Alle Datenobjekte sind vorhanden, Version kann geprüft werden
			
			IF _pDoContainer.Header.Version.wVersion <> _PmIntern.DataModelCsv.HeaderVersion.wVersion 
				OR _pDoLogicalStruct.Header.Version.wVersion <> _PmIntern.DataModelCsv.HeaderVersion.wVersion
				OR _pDoParamNum.Header.Version.wVersion <> _PmIntern.DataModelCsv.HeaderVersion.wVersion
				OR _pDoParamString.Header.Version.wVersion <> _PmIntern.DataModelCsv.HeaderVersion.wVersion THEN
				
				_PmIntern.xResetModelDOs := TRUE;
				
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Version check: Reset Datamodel!';
				_PmIntern.Logger.var1		:= 0;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

			END_IF
			
		END_IF

// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif



		//****************************************************************************************************************
		// Lösche altes Datenmodell
		//****************************************************************************************************************


		_PmIntern.enInitState := is_ResetDataModel;

		IF _PmIntern.xResetModelDOs THEN
			
			IF _PmIntern.DataObjects.Idents.lContainer <> 0 THEN
				
				_ddContainer(enable := TRUE, ident := _PmIntern.DataObjects.Idents.lContainer);
				_PmIntern.DataObjects.Idents.lContainer := 0;
				
				IF _ddContainer.status <> ERR_OK THEN

					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Reset Datamodel, DataObjDelete Container: {##AttrVar1}';
					_PmIntern.Logger.var1		:= _ddContainer.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();
					
				END_IF
				
			END_IF

			IF _PmIntern.DataObjects.Idents.lLogicalStruct <> 0 THEN
				
				_ddLogicalStruct(enable := TRUE, ident := _PmIntern.DataObjects.Idents.lLogicalStruct);
				_PmIntern.DataObjects.Idents.lLogicalStruct := 0;

				IF _ddLogicalStruct.status <> ERR_OK THEN

					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Reset Datamodel, DataObjDelete Logical Struct: {##AttrVar1}';
					_PmIntern.Logger.var1		:= _ddLogicalStruct.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();
					
				END_IF
				
			END_IF
			
			IF _PmIntern.DataObjects.Idents.lParamNum <> 0 THEN
				
				_ddParamNum(enable := TRUE, ident := _PmIntern.DataObjects.Idents.lParamNum);
				_PmIntern.DataObjects.Idents.lParamNum := 0;
				
				IF _ddParamNum.status <> ERR_OK THEN

					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Reset Datamodel, DataObjDelete Numeric Parameter: {##AttrVar1}';
					_PmIntern.Logger.var1		:= _ddParamNum.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();
					
				END_IF
				
				
			END_IF

			IF _PmIntern.DataObjects.Idents.lParamString <> 0 THEN
				
				_ddParamString(enable := TRUE, ident := _PmIntern.DataObjects.Idents.lParamString);
				_PmIntern.DataObjects.Idents.lParamString := 0;

				IF _ddParamString.status <> ERR_OK THEN

					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Reset Datamodel, DataObjDelete String Parameter: {##AttrVar1}';
					_PmIntern.Logger.var1		:= _ddParamString.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();
					
				END_IF
				
			END_IF

		END_IF //IF _PmIntern.xResetModelDOs THEN

		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif



		//****************************************************************************************************************
		// Reserviere Speicher für temporäres Datenmodell
		//****************************************************************************************************************


		_PmIntern.enInitState := is_CreateTempDataModel;

		IF _PmIntern.xResetModelDOs THEN
			
			// Container
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(_pDoContainer) );
		
			IF _MemPartAlloc.status <> ERR_OK THEN
			
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Read Datamodel, Container, MemPartAlloc: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartAlloc.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;

			END_IF		

			_PmIntern.DataObjects.TempAdresses.lContainer 	:= _MemPartAlloc.mem;
			_PmIntern.DataObjects.Size.lContainer				:= _MemPartAlloc.len;
			brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
			_pDoContainer ACCESS _PmIntern.DataObjects.TempAdresses.lContainer;
		
			_pDoContainer.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;
		

			// LogStruct
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(_pDoLogicalStruct.Header) + MNPARAM_CNT_LOGICSTRUCT*SIZEOF(_pDoLogicalStruct.LogicalStruct[1]) );
		
			IF _MemPartAlloc.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
				_PmIntern.Logger.text		:= 'Read Datamodel, Logical Structure, MemPartAlloc: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartAlloc.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;
			
			END_IF		

			_PmIntern.DataObjects.TempAdresses.lLogicalStruct 	:= _MemPartAlloc.mem;
			_PmIntern.DataObjects.Size.lLogicalStruct				:= _MemPartAlloc.len;
			brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
			_pDoLogicalStruct ACCESS _PmIntern.DataObjects.TempAdresses.lLogicalStruct;
		
			_pDoLogicalStruct.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;

			// NumParam
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(_pDoParamNum.Header) + MNPARAM_CNT_PARAMNUM*SIZEOF(_pDoParamNum.ParamNum[1]) );
		
			IF _MemPartAlloc.status <> ERR_OK THEN
			
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
				_PmIntern.Logger.text		:= 'Read Datamodel, Numeric Parameter, MemPartAlloc: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartAlloc.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;

			END_IF		

			_PmIntern.DataObjects.TempAdresses.lParamNum 	:= _MemPartAlloc.mem;
			_PmIntern.DataObjects.Size.lParamNum				:= _MemPartAlloc.len;
			brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
			_pDoParamNum ACCESS _PmIntern.DataObjects.TempAdresses.lParamNum;
		
			_pDoParamNum.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;
		
			// StringParam
			_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(_pDoParamString.Header) + MNPARAM_CNT_PARAMSTRING*SIZEOF(_pDoParamString.ParamString[1]) );
		
			IF _MemPartAlloc.status <> ERR_OK THEN
			
				_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
				_PmIntern.Logger.text		:= 'Read Datamodel, String Parameter, MemPartAlloc: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartAlloc.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;

			END_IF		

			_PmIntern.DataObjects.TempAdresses.lParamString 	:= _MemPartAlloc.mem;
			_PmIntern.DataObjects.Size.lParamString				:= _MemPartAlloc.len;
			brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
			_pDoParamString ACCESS _PmIntern.DataObjects.TempAdresses.lParamString;
		
			_pDoParamString.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;

		END_IF //IF _PmIntern.xResetModelDOs THEN

// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif



		//****************************************************************************************************************
		// Datenmodell komplett parsen
		//****************************************************************************************************************


		_PmIntern.enInitState := is_ParseDataModel;

		IF _PmIntern.xResetModelDOs THEN

			brsmemset(ADR(_PmIntern.DataObjects.MaxIndex), 0, SIZEOF(_PmIntern.DataObjects.MaxIndex));
			
			_pDoContainer.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;
			_pDoLogicalStruct.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;
			_pDoParamNum.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;
			_pDoParamString.Header.Version := _PmIntern.DataModelCsv.HeaderVersion;

			REPEAT
			
				_GetCsvDat.enable := TRUE;
				brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
				_GetCsvDat();

				IF _GetCsvDat.RowType = 251 THEN
				
					_pDoContainer.Header.Time := _GetCsvDat.HeaderTime;
					_pDoLogicalStruct.Header.Time := _GetCsvDat.HeaderTime;
					_pDoParamNum.Header.Time := _GetCsvDat.HeaderTime;
					_pDoParamString.Header.Time := _GetCsvDat.HeaderTime;

				ELSIF _GetCsvDat.RowType = 140 THEN
				
					IF (_GetCsvDat.ContainerRow.siContainerID <= 0 AND _GetCsvDat.ContainerRow.siContainerID > MNPARAM_MAXIDX_CONTAINER*(-1)) THEN
					
						_wIndex := USINT_TO_UINT(0 -_GetCsvDat.ContainerRow.siContainerID);
					
						_pDoContainer.Container[_wIndex] := _GetCsvDat.ContainerRow;
					
						_PmIntern.DataObjects.MaxIndex.lContainer := MAX(_PmIntern.DataObjects.MaxIndex.lContainer, UINT_TO_UDINT(_wIndex));
				
					END_IF
				
				ELSIF _GetCsvDat.RowType = 130 THEN
				
					IF (_GetCsvDat.LogicalStructRow.wLogStrucNo > 0 AND _GetCsvDat.LogicalStructRow.wLogStrucNo <= MNPARAM_CNT_LOGICSTRUCT) THEN
					
						_pDoLogicalStruct.LogicalStruct[_GetCsvDat.LogicalStructRow.wLogStrucNo] := _GetCsvDat.LogicalStructRow;
					
						_PmIntern.DataObjects.MaxIndex.lLogicalStruct := MAX(_PmIntern.DataObjects.MaxIndex.lLogicalStruct, UINT_TO_UDINT(_GetCsvDat.LogicalStructRow.wLogStrucNo));

					END_IF

				ELSIF _GetCsvDat.RowType = 120 THEN
				
					IF (_GetCsvDat.ParamStringRow.wIdxStringPar > 0 AND _GetCsvDat.ParamStringRow.wIdxStringPar <= MNPARAM_CNT_PARAMSTRING) THEN
					
						_pDoParamString.ParamString[_GetCsvDat.ParamStringRow.wIdxStringPar] := _GetCsvDat.ParamStringRow;
					
						_PmIntern.DataObjects.MaxIndex.lParamString := MAX(_PmIntern.DataObjects.MaxIndex.lParamString, UINT_TO_UDINT(_GetCsvDat.ParamStringRow.wIdxStringPar));

					END_IF

						
				ELSIF _GetCsvDat.RowType = 110 OR _GetCsvDat.RowType = 111 THEN
				
					IF (_GetCsvDat.ParamNumRow.wIdxNumPar > 0 AND _GetCsvDat.ParamNumRow.wIdxNumPar <= MNPARAM_CNT_PARAMNUM) THEN
					
						_pDoParamNum.ParamNum[_GetCsvDat.ParamNumRow.wIdxNumPar] := _GetCsvDat.ParamNumRow;
					
						_PmIntern.DataObjects.MaxIndex.lParamNum := MAX(_PmIntern.DataObjects.MaxIndex.lParamNum, UINT_TO_UDINT(_GetCsvDat.ParamNumRow.wIdxNumPar));

					END_IF

				END_IF

				_wStartLine := _wStartLine + 1;
			
			UNTIL
				_wStartLine > _PmIntern.Parse.lCntLines
			END_REPEAT

			// Endadressen berechnen
			_pDoContainer.Header.Do.lActEndPos := ADR(_pDoContainer.Container[_PmIntern.DataObjects.MaxIndex.lContainer]) + SIZEOF(_pDoContainer.Container[0]) - ADR(_pDoContainer);
		
			IF _PmIntern.DataObjects.MaxIndex.lLogicalStruct > 0 THEN
				_pDoLogicalStruct.Header.Do.lActEndPos := ADR(_pDoLogicalStruct.LogicalStruct[_PmIntern.DataObjects.MaxIndex.lLogicalStruct]) + SIZEOF(_pDoLogicalStruct.LogicalStruct[1]) - ADR(_pDoLogicalStruct);
			ELSE
				_pDoLogicalStruct.Header.Do.lActEndPos := ADR(_pDoLogicalStruct.LogicalStruct[1]) - ADR(_pDoLogicalStruct);
			END_IF

			IF _PmIntern.DataObjects.MaxIndex.lParamString > 0 THEN
				_pDoParamString.Header.Do.lActEndPos := ADR(_pDoParamString.ParamString[_PmIntern.DataObjects.MaxIndex.lParamString]) + SIZEOF(_pDoParamString.ParamString[1]) - ADR(_pDoParamString);
			ELSE
				_pDoParamString.Header.Do.lActEndPos := ADR(_pDoParamString.ParamString[1]) - ADR(_pDoParamString);
			END_IF

			IF _PmIntern.DataObjects.MaxIndex.lParamNum > 0 THEN
				_pDoParamNum.Header.Do.lActEndPos := ADR(_pDoParamNum.ParamNum[_PmIntern.DataObjects.MaxIndex.lParamNum]) + SIZEOF(_pDoParamNum.ParamNum[1]) - ADR(_pDoParamNum);
			ELSE
				_pDoParamNum.Header.Do.lActEndPos := ADR(_pDoParamNum.ParamNum[1]) - ADR(_pDoParamNum);
			END_IF

		END_IF //IF _PmIntern.xResetModelDOs THEN
		
// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif






		//****************************************************************************************************************
		// Datenmodell komplett in Datenobjekte schreiben
		//****************************************************************************************************************


		_PmIntern.enInitState := is_WriteDataModel;

		IF _PmIntern.xResetModelDOs THEN

			// Schreibe Container
			_dcContainer(enable := TRUE, grp := 0, pName := ADR(_PmIntern.DataObjects.Names.sDataModelContainer), len := _PmIntern.DataObjects.Size.lContainer, MemType := doUSRROM, Option := 0, pCpyData :=_PmIntern.DataObjects.TempAdresses.lContainer);
		
			IF _dcContainer.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
				_PmIntern.Logger.text		:= 'Read Datamodel, Container, DataObjectCreate: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _dcContainer.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;
			
			END_IF
		
			_PmIntern.DataObjects.Idents.lContainer := _dcContainer.ident;
			_PmIntern.DataObjects.Adress.lContainer := _dcContainer.pDatObjMem;
		
			_pDoContainer ACCESS _PmIntern.DataObjects.Adress.lContainer;
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.DataObjects.TempAdresses.lContainer);

			_PmIntern.DataObjects.TempAdresses.lContainer := 0;
				
			IF _MemPartFree.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Read Datamodel, Container, MemPartFree: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartFree.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();
			
			END_IF

			// Schreibe logische Struktur
			_dcLogicalStruct(enable := TRUE, grp := 0, pName := ADR(_PmIntern.DataObjects.Names.sDataModelLogicalStruct), len := _PmIntern.DataObjects.Size.lLogicalStruct, MemType := doUSRROM, Option := 0, pCpyData :=_PmIntern.DataObjects.TempAdresses.lLogicalStruct);
		
			IF _dcLogicalStruct.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
				_PmIntern.Logger.text		:= 'Read Datamodel, Logical Structure, DataObjectCreate: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _dcLogicalStruct.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;
			
			END_IF
		
			_PmIntern.DataObjects.Idents.lLogicalStruct := _dcLogicalStruct.ident;
			_PmIntern.DataObjects.Adress.lLogicalStruct := _dcLogicalStruct.pDatObjMem;
		
			_pDoLogicalStruct ACCESS _PmIntern.DataObjects.Adress.lLogicalStruct;
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.DataObjects.TempAdresses.lLogicalStruct);

			_PmIntern.DataObjects.TempAdresses.lLogicalStruct := 0;
				
			IF _MemPartFree.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Read Datamodel, Logical Structure, MemPartFree: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartFree.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();
			
			END_IF


			// Schreibe Parameter String
			_dcParamString(enable := TRUE, grp := 0, pName := ADR(_PmIntern.DataObjects.Names.sDataModelParamString), len := _PmIntern.DataObjects.Size.lParamString, MemType := doUSRROM, Option := 0, pCpyData :=_PmIntern.DataObjects.TempAdresses.lParamString);
		
			IF _dcParamString.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
				_PmIntern.Logger.text		:= 'Read Datamodel, String Parameter, DataObjectCreate: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _dcParamString.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;
			
			END_IF
		
			_PmIntern.DataObjects.Idents.lParamString := _dcParamString.ident;
			_PmIntern.DataObjects.Adress.lParamString := _dcParamString.pDatObjMem;
		
			_pDoParamString ACCESS _PmIntern.DataObjects.Adress.lParamString;
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.DataObjects.TempAdresses.lParamString);
		
			_PmIntern.DataObjects.TempAdresses.lParamString := 0;
		
			IF _MemPartFree.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Read Datamodel, String Parameter, MemPartFree: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartFree.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();
			
			END_IF


			// Schreibe Parameter Num
			_dcParamNum(enable := TRUE, grp := 0, pName := ADR(_PmIntern.DataObjects.Names.sDataModelParamNum), len := _PmIntern.DataObjects.Size.lParamNum, MemType := doUSRROM, Option := 0, pCpyData := _PmIntern.DataObjects.TempAdresses.lParamNum);
		
			IF _dcParamNum.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
				_PmIntern.Logger.text		:= 'Read Datamodel, Numeric Parameter, DataObjectCreate: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _dcParamNum.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();

				_xSysError := TRUE;

				EXIT;
			
			END_IF
		
			_PmIntern.DataObjects.Idents.lParamNum := _dcParamNum.ident;
			_PmIntern.DataObjects.Adress.lParamNum := _dcParamNum.pDatObjMem;
		
			_pDoParamNum ACCESS _PmIntern.DataObjects.Adress.lParamNum;
		
			_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.DataObjects.TempAdresses.lParamNum);
		
			_PmIntern.DataObjects.TempAdresses.lParamNum := 0;
		
			IF _MemPartFree.status <> ERR_OK THEN

				_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
				_PmIntern.Logger.text		:= 'Read Datamodel, Numeric Parameter, MemPartFree: {##AttrVar1}';
				_PmIntern.Logger.var1		:= _MemPartFree.status;
				_PmIntern.Logger.var2		:= 0;
				_PmIntern.Logger();
			
			END_IF

		END_IF //IF _PmIntern.xResetModelDOs THEN

		// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
		#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif


		//****************************************************************************************************************
		// Für Container mit indirekter Parametrierung, prüfen ob Default-Daten existieren und ggf.
		// anlegen.
		//****************************************************************************************************************

		// Über alle Container iterieren
		FOR _c := 0 TO _PmIntern.DataObjects.MaxIndex.lContainer DO
			
			_DefineActContainer(Enable := TRUE, bContainerIdx := DINT_TO_USINT(_c), wInstanceIdx := _pDoContainer.Container[_c].wMinBound, pIntern := ADR(_PmIntern));
			
			IF _pDoContainer.Container[_c].bDirectParam = 0 AND _DefineActContainer.Status = ERR_OK THEN

				//****************************************************************************************************************
				// Default-Datenobjekte suchen
				//****************************************************************************************************************
				_PmIntern.enInitState := is_TestDefautDO;

				// Initialisieren
				
				_PmIntern.xResetConateinerDOs := FALSE;
				_PmIntern.CSVDataObjects.Idents.lCSVNum := 0;
				_PmIntern.CSVDataObjects.Idents.lCSVString := 0;
				_PmIntern.CSVDataObjects.Idents.lDataObjekt := 0;
				
				// Num-Container suchen

				_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefNum));

				IF _diCSVNum.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;
					_PmIntern.CSVDataObjects.Adress.lCSVNum := _diCSVNum.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
					
					IF _diCSVNum.len >= SIZEOF(mnParam_CsvDynHeader_typ) THEN
				
						_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;

						// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
						_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );
				
					ELSE
				
						_PmIntern.xResetConateinerDOs := TRUE;

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Data Object Default Numeric Container to small. Reset!';
						_PmIntern.Logger.var1		:= 0;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();
				
					END_IF

					IF _pDoContainerNum.Header.Version.wVersion <> _pDoContainer.Header.Version.wVersion THEN
						
						_PmIntern.xResetConateinerDOs := TRUE;

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Data Object Default Numeric Container wrong version. Reset!';
						_PmIntern.Logger.var1		:= 0;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

					END_IF						
				
				ELSE

					_PmIntern.xResetConateinerDOs := TRUE;
					
					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Data Object Default Numeric Container does not exist. {##AttrVar1}';
					_PmIntern.Logger.var1		:= _diCSVNum.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();

				END_IF

				// String Container suchen
				
				_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefString));

				IF _diCSVString.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
					_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
					
					IF _diCSVString.len >= SIZEOF(mnParam_CsvDynHeader_typ) THEN
				
						_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;

						// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
						_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );
				
					ELSE
				
						_PmIntern.xResetConateinerDOs := TRUE;

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Data Object Default String Container to small. Reset!';
						_PmIntern.Logger.var1		:= 0;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();
				
					END_IF

					IF _pDoContainerString.Header.Version.wVersion <> _pDoContainer.Header.Version.wVersion THEN
						
						_PmIntern.xResetConateinerDOs := TRUE;

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Data Object Default String Container wrong version. Reset!';
						_PmIntern.Logger.var1		:= 0;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

					END_IF						
				
				ELSE

					_PmIntern.xResetConateinerDOs := TRUE;

					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Data Object Default String Container does not exist. {##AttrVar1}';
					_PmIntern.Logger.var1		:= _diCSVString.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();
					
				END_IF

				// Default Binärobjekt suchen
				
				_diDefaultDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDef));
	
				IF _diDefaultDO.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDefaultDO.ident;
					_PmIntern.CSVDataObjects.Adress.lDataObjekt := _diDefaultDO.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDefaultDO.len;
					
					IF _diDefaultDO.len < _lPVlen THEN
				
						_PmIntern.xResetConateinerDOs := TRUE;
				
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Data Object Default Binary Container to small. Reset!';
						_PmIntern.Logger.var1		:= 0;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

					END_IF
				
				ELSE

					_PmIntern.xResetConateinerDOs := TRUE;

					_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
					_PmIntern.Logger.text		:= 'Data Object Default Binary Container does not exist. {##AttrVar1}';
					_PmIntern.Logger.var1		:= _diDefaultDO.status;
					_PmIntern.Logger.var2		:= 0;
					_PmIntern.Logger();
					
				END_IF
				
				// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
				#ifdef SINGLEmnParam
				REPEAT
					UNTIL
					_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif


				IF _PmIntern.xResetConateinerDOs THEN

					//****************************************************************************************************************
					// Defaultdaten löschen
					//****************************************************************************************************************

					_PmIntern.enInitState := is_ResetDefaultDO;
					
					IF _PmIntern.CSVDataObjects.Idents.lCSVNum <> 0 THEN
						
						_ddCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum);
						
						_PmIntern.CSVDataObjects.Idents.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Size.lCSVNum := 0;
						
						IF _ddCSVNum.status <> ERR_OK THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Data Object Delete: Default Numeric Container. {##AttrVar1}';
							_PmIntern.Logger.var1		:= _ddCSVNum.status;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();
						
						END_IF
					END_IF
					
					IF _PmIntern.CSVDataObjects.Idents.lCSVString <> 0 THEN
						
						_ddCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString);
						
						_PmIntern.CSVDataObjects.Idents.lCSVString := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVString := 0;
						_PmIntern.CSVDataObjects.Size.lCSVString := 0;

						IF _ddCSVString.status <> ERR_OK THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Data Object Delete: Default String Container. {##AttrVar1}';
							_PmIntern.Logger.var1		:= _ddCSVString.status;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();

						END_IF
						
					END_IF
					
					IF _PmIntern.CSVDataObjects.Idents.lDataObjekt <> 0 THEN
						
						_ddDataObjekt(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt);
						
						_PmIntern.CSVDataObjects.Idents.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Adress.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Size.lDataObjekt := 0;
						
						IF _ddDataObjekt.status <> ERR_OK THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Data Object Delete: Default Binary Container. {##AttrVar1}';
							_PmIntern.Logger.var1		:= _ddDataObjekt.status;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();

						END_IF
					END_IF

					// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
					#ifdef SINGLEmnParam
					REPEAT
						UNTIL
						_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif			

					//****************************************************************************************************************
					// Speicher zum Erstellen der Datenobjekte Allokieren
					//****************************************************************************************************************
					_PmIntern.enInitState := is_CreateDefaultDO1;

					_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(mnParam_CsvDynHeader_typ) + (_PmIntern.ActContainer.lCountParamNum * SIZEOF(_pDoContainerNum.CsvNum[1])) );
				
					IF _MemPartAlloc.status <> ERR_OK THEN

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
						_PmIntern.Logger.text		:= 'MemPartAlloc: Default Numeric Container. {##AttrVar1}';
						_PmIntern.Logger.var1		:= _MemPartAlloc.status;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

						_xSysError := TRUE;

						EXIT;

					END_IF

					brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
					_PmIntern.CSVDataObjects.TempAdresses.lCSVNum 	:= _MemPartAlloc.mem;
					_PmIntern.CSVDataObjects.Size.lCSVNum 				:= _MemPartAlloc.len;
				
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVNum;

					_pDoContainerNum.Header.Version := _pDoContainer.Header.Version;
					_pDoContainerNum.Header.Do.lActEndPos := _PmIntern.CSVDataObjects.Size.lCSVNum;
					brwcscpy(ADR(_pDoContainerNum.Header.MachineNo.utfMachineNo), ADR(IFmnParam.Out.utfMachineNumber));

					_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(mnParam_CsvDynHeader_typ) + (_PmIntern.ActContainer.lCountParamString * SIZEOF(_pDoContainerString.CsvString[1])) );
				
					IF _MemPartAlloc.status <> ERR_OK THEN

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
						_PmIntern.Logger.text		:= 'MemPartAlloc: Default String Container. {##AttrVar1}';
						_PmIntern.Logger.var1		:= _MemPartAlloc.status;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

						_xSysError := TRUE;
						
						// Speicher konnte nicht reserviert werden
						EXIT;

					END_IF

					brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
					_PmIntern.CSVDataObjects.TempAdresses.lCSVString 	:= _MemPartAlloc.mem;
					_PmIntern.CSVDataObjects.Size.lCSVString 				:= _MemPartAlloc.len;
				
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVString;

					_pDoContainerString.Header.Version := _pDoContainer.Header.Version;
					_pDoContainerString.Header.Do.lActEndPos := _PmIntern.CSVDataObjects.Size.lCSVString;
					brwcscpy(ADR(_pDoContainerString.Header.MachineNo.utfMachineNo), ADR(IFmnParam.Out.utfMachineNumber));
				
					
				
// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif		

					//****************************************************************************************************************
					// Datenobjekte beschreiben (NUM)
					//****************************************************************************************************************
					_PmIntern.enInitState := is_CreateDefaultDO2;
					
					_wIdxCsvNum := 1;
					
					FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lParamNum) DO

						_getContainerParamNum(enable := TRUE, pLogicStructs := ADR(_pDoLogicalStruct.LogicalStruct[1]), wMaxIdxLogicStructs := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct), pParamNum := ADR(_pDoParamNum.ParamNum[_i]));

						IF _getContainerParamNum.status <> ERR_OK  AND _getContainerParamNum.status <> 2 THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Numeric Parameter Idx = {##AttrVar1} - Can$'t get Container: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _i;
							_PmIntern.Logger.var2		:= _getContainerParamNum.status;
							_PmIntern.Logger();

						END_IF
						
						IF _getContainerParamNum.status = ERR_OK  AND _getContainerParamNum.iContainer = _pDoContainer.Container[_c].siContainerID THEN
							
							_dim1 := MAX(1, _getContainerParamNum.wDimension[1]);
							_dim2 := MAX(1, _getContainerParamNum.wDimension[2]);
							_dim3 := MAX(1, _getContainerParamNum.wDimension[3]);
							_dim4 := MAX(1, _getContainerParamNum.wDimension[4]);
							
							FOR _i1 := _getContainerParamNum.wMinBound[1] TO _getContainerParamNum.wMinBound[1] + _dim1-1 DO

								FOR _i2 := _getContainerParamNum.wMinBound[2] TO _getContainerParamNum.wMinBound[2] + _dim2 -1 DO

									FOR _i3 := _getContainerParamNum.wMinBound[3] TO _getContainerParamNum.wMinBound[3] + _dim3 -1 DO

										FOR _i4 := _getContainerParamNum.wMinBound[4] TO _getContainerParamNum.wMinBound[4] + _dim4 -1 DO
									
											IF _wIdxCsvNum <= _PmIntern.ActContainer.lCountParamNum THEN
									
												_pDoContainerNum.CsvNum[_wIdxCsvNum].wIdxNumPar := _i;
												_pDoContainerNum.CsvNum[_wIdxCsvNum].diValue := _pDoParamNum.ParamNum[_i].diDefValue;

												IF _getContainerParamNum.wCountArray >= 1 THEN

													_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx1 := _i1;

													IF _getContainerParamNum.wCountArray >= 2 THEN
	
														_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx2 := _i2;

														IF _getContainerParamNum.wCountArray >= 3 THEN
	
															_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx3 := _i3;

															IF _getContainerParamNum.wCountArray = 4 THEN
	
																_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx4 := _i4;
													
															END_IF
													
														END_IF
													
													END_IF
												
												END_IF

												GetArrayPV(pPV := ADR(_pDoParamNum.ParamNum[_i].sAdresse), pStructRoot := ADR(_PmIntern.ActContainer.sStrucRoot), pPVFilled := ADR(_sPVAdress), idx1 :=_i1, idx2:=_i2, idx3:=_i3, idx4:=_i4);
												
												IF _pDoContainerNum.CsvNum[_wIdxCsvNum].bRowType = 0 THEN
													_WritePVNum(pAdress := ADR(_sPVAdress), diValue := _pDoContainerNum.CsvNum[_wIdxCsvNum].diValue);
												ELSE
													_pdiValue ACCESS ADR(_rValue);
													_pdiValue := _pDoContainerNum.CsvNum[_wIdxCsvNum].diValue;
													_WritePVrNum(pAdress := ADR(_sPVAdress), rValue := _rValue);
												END_IF
											
												IF _WritePVNum.status <> ERR_OK THEN

													_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
													_PmIntern.Logger.text		:= CONCAT(_sPVAdress, '(Index = {##AttrVar1}) : Does not exist! Status: {##AttrVar2}');
													_PmIntern.Logger.var1		:= _i;
													_PmIntern.Logger.var2		:= _WritePVNum.status;
													_PmIntern.Logger();

												END_IF
									
												_wIdxCsvNum := _wIdxCsvNum + 1;

											END_IF
											
										END_FOR
									
									END_FOR
									
								END_FOR
								
							END_FOR	
						
						END_IF
						
					END_FOR

					//****************************************************************************************************************
					// Datenobjekte beschreiben (STRING)
					//****************************************************************************************************************
					_PmIntern.enInitState := is_CreateDefaultDO3;

					_wIdxCsvString := 1;
					
					FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lParamString) DO

						_getContainerParamString(enable := TRUE, pLogicStructs := ADR(_pDoLogicalStruct.LogicalStruct[1]), wMaxIdxLogicStructs := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct), pParamString := ADR(_pDoParamString.ParamString[_i]));
						
						IF _getContainerParamString.status <> ERR_OK AND _getContainerParamString.status <> 2 THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'String Parameter Idx = {##AttrVar1} - Can$'t get Container: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _i;
							_PmIntern.Logger.var2		:= _getContainerParamString.status;
							_PmIntern.Logger();

						END_IF

						IF _getContainerParamString.status = ERR_OK AND _getContainerParamString.iContainer = _pDoContainer.Container[_c].siContainerID THEN
							
							_dim1 := MAX(1, _getContainerParamString.wDimension[1]);
							_dim2 := MAX(1, _getContainerParamString.wDimension[2]);
							_dim3 := MAX(1, _getContainerParamString.wDimension[3]);
							_dim4 := MAX(1, _getContainerParamString.wDimension[4]);

							FOR _i1 := _getContainerParamString.wMinBound[1] TO _getContainerParamString.wMinBound[1] + _dim1 - 1 DO

								FOR _i2 := _getContainerParamString.wMinBound[2] TO _getContainerParamString.wMinBound[2] + _dim2 - 1 DO

									FOR _i3 := _getContainerParamString.wMinBound[3] TO _getContainerParamString.wMinBound[3] + _dim3 - 1 DO

										FOR _i4 := _getContainerParamString.wMinBound[4] TO _getContainerParamString.wMinBound[4] + _dim4 - 1 DO
									
											IF _wIdxCsvString <= _PmIntern.ActContainer.lCountParamString THEN
									
												_pDoContainerString.CsvString[_wIdxCsvString].wIdxStringPar := _i;
												brwcsncpy(ADR(_pDoContainerString.CsvString[_wIdxCsvString].utfValue), ADR(_pDoParamString.ParamString[_i].utfDefValue), 31);

												IF _getContainerParamString.wCountArray >= 1 THEN

													_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx1 := _i1;

													IF _getContainerParamString.wCountArray >= 2 THEN
	
														_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx2 := _i2;

														IF _getContainerParamString.wCountArray >= 3 THEN
	
															_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx3 := _i3;

															IF _getContainerParamString.wCountArray = 4 THEN
	
																_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx4 := _i4;
													
															END_IF
													
														END_IF
													
													END_IF
												
												END_IF
									
												GetArrayPV(pPV := ADR(_pDoParamString.ParamString[_i].sAdresse), pStructRoot := ADR(_PmIntern.ActContainer.sStrucRoot), pPVFilled := ADR(_sPVAdress), idx1 :=_i1, idx2:=_i2, idx3:=_i3, idx4:=_i4);
											
												_WritePVString(pAdress := ADR(_sPVAdress), p_utfValue := ADR(_pDoContainerString.CsvString[_wIdxCsvString].utfValue));
											
												IF _WritePVString.status <> ERR_OK THEN

													_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
													_PmIntern.Logger.text		:= CONCAT(_sPVAdress, '(Index = {##AttrVar1}) : Does not exist! Status: {##AttrVar2}');
													_PmIntern.Logger.var1		:= _i;
													_PmIntern.Logger.var2		:= _WritePVString.status;
													_PmIntern.Logger();

												END_IF

												_wIdxCsvString := _wIdxCsvString + 1;

											END_IF
											
										END_FOR
									
									END_FOR
									
								END_FOR
								
							END_FOR	
						
						END_IF
						
					END_FOR

					//****************************************************************************************************************
					// Datenobjekte anlegen
					//****************************************************************************************************************
					_PmIntern.enInitState := is_CreateDefaultDO4;

					_dcDataObjekt(enable := TRUE, grp := 0, pName := ADR(_PmIntern.ActContainer.sDoNameDef), len := _PmIntern.ActContainer.lSizeStructRoot, MemType := doUSRROM, Option := 0, pCpyData := _PmIntern.ActContainer.lAdressStructRoot);
					
					IF (_dcDataObjekt.status = ERR_OK) THEN

						_PmIntern.CSVDataObjects.Idents.lDataObjekt := _dcDataObjekt.ident;
						_PmIntern.CSVDataObjects.Adress.lDataObjekt := _dcDataObjekt.pDatObjMem;
						_PmIntern.CSVDataObjects.Size.lDataObjekt := _dcDataObjekt.len;

					ELSE
					
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Binary Data Object Create failed: Index = {##AttrVar1}, Status: {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _dcDataObjekt.status;
						_PmIntern.Logger();
					
					END_IF

					_dcCSVNum(enable := TRUE, grp := 0, pName := ADR(_PmIntern.ActContainer.sDoNameDefNum), len := _PmIntern.CSVDataObjects.Size.lCSVNum, MemType := doUSRROM, Option := 0, pCpyData := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);

					IF (_dcCSVNum.status = ERR_OK) THEN
						_PmIntern.CSVDataObjects.Idents.lCSVNum := _dcCSVNum.ident;
						_PmIntern.CSVDataObjects.Adress.lCSVNum := _dcCSVNum.pDatObjMem;
						_PmIntern.CSVDataObjects.Size.lCSVNum := _dcCSVNum.len;
					ELSE 
					
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Numeric Data Object Create failed: Index = {##AttrVar1}, Status: {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _dcCSVNum.status;
						_PmIntern.Logger();
					
					END_IF

					_dcCSVString(enable := TRUE, grp := 0, pName := ADR(_PmIntern.ActContainer.sDoNameDefString), len := _PmIntern.CSVDataObjects.Size.lCSVString, MemType := doUSRROM, Option := 0, pCpyData :=_PmIntern.CSVDataObjects.TempAdresses.lCSVString);

					IF (_dcCSVString.status = ERR_OK) THEN
						_PmIntern.CSVDataObjects.Idents.lCSVString := _dcCSVString.ident;
						_PmIntern.CSVDataObjects.Adress.lCSVString := _dcCSVString.pDatObjMem;
						_PmIntern.CSVDataObjects.Size.lCSVString := _dcCSVString.len;
					ELSE
					
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'String Data Object Create failed: Index = {##AttrVar1}, Status: {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _dcCSVString.status;
						_PmIntern.Logger();
					
					END_IF

					_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
					_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := 0;
					
					_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
					_PmIntern.CSVDataObjects.TempAdresses.lCSVString := 0;

				END_IF // IF _PmIntern.xResetConateinerDOs
				
			END_IF	//Ist der Container indirekt und gültig

// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			_lSingleStep > _pl_InitState OR NOT _xSingleStep
		END_REPEAT
#endif

			// TOC-Startidize berechnen
			
			IF _c = 0 THEN
				_PmIntern.TOC.wStartIdx[0] := 1;
			ELSE
				IF _pDoContainer.Container[_c-1].bDirectParam = 0 THEN
					_PmIntern.TOC.wStartIdx[_c] := _PmIntern.TOC.wStartIdx[_c-1] + _pDoContainer.Container[_c-1].wDimension;
				ELSE
					_PmIntern.TOC.wStartIdx[_c] := _PmIntern.TOC.wStartIdx[_c-1] + 1;
				END_IF
			END_IF
			
		END_FOR

//=========================================================================================
//							ENDE VORBEREITUNG DATENMODELL
//=========================================================================================




//#########################################################################################
//							START DATENCONTAINER PRUEFEN UND EINLESEN
//#########################################################################################

		_xAllContainerOK := TRUE;
		
		// Über alle Container iterieren
		FOR _c := 0 TO _PmIntern.DataObjects.MaxIndex.lContainer DO
			
			//------------------------------------------------
			// FLUSSDIAGRAMM POSITION 5
			//------------------------------------------------
			
			_wIndexIndirect := _pDoContainer.Container[_c].wMinBound;
			
			REPEAT		// Bei indirekter Parametrierung, wird diese Schleife mehrmals durchlaufen			

				// Reset DataObject initialisieren
				_PmIntern.xResetConateinerDOs := FALSE;
				
				_PmIntern.xExportContainerCsv := FALSE;
				_PmIntern.ActContainer.xDataImported := FALSE;
				_PmIntern.ActContainer.xWriteProtected := FALSE;
				_PmIntern.ActContainer.xExportfileExist := FALSE;
				
				brsmemset(ADR(_PmIntern.CSVDataObjects), 0, SIZEOF(_PmIntern.CSVDataObjects));

				// Aktuellen Container initialisieren
				_DefineActContainer(Enable := TRUE, bContainerIdx := DINT_TO_USINT(_c), wInstanceIdx := _wIndexIndirect, pIntern := ADR(_PmIntern));
				
				IF _DefineActContainer.Status <> ERR_OK THEN

					_PmIntern.Logger.logLevel 	:= arlogLEVEL_WARNING;
					_PmIntern.Logger.text		:= 'Error in container specification: Index = {##AttrVar1}, Status = {##AttrVar2}';
					_PmIntern.Logger.var1		:= _pDoContainer.Container[_c].siContainerID;
					_PmIntern.Logger.var2		:= _DefineActContainer.Status;
					_PmIntern.Logger();

					_xAllContainerOK := FALSE;

					_xSysError := TRUE;
					
					// Namen nicht definiert, Container können nicht bearbeitet werden
					EXIT;

				END_IF
			
				//****************************************************************************************************************
				// Existieren bereits die Datenobjekte
				//****************************************************************************************************************

				_PmIntern.enInitState := is_LookForDOvalue;

				// Numerische Daten			
				_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameNum));

				IF _diCSVNum.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;
					_PmIntern.CSVDataObjects.Adress.lCSVNum := _diCSVNum.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
					
					IF _diCSVNum.len >= SIZEOF(mnParam_CsvDynHeader_typ) THEN
				
						_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;

						IF _PmIntern.CSVDataObjects.Size.lCSVNum < _pDoContainerNum.Header.Do.lActEndPos OR _pDoContainerNum.Header.Version.wVersion <> _pDoContainer.Header.Version.wVersion THEN
							
							// Gibt es Größendiskrepanzen oder ist die Version nicht stimmig zum Datenmodell, wird das DO verworfen
							
							_PmIntern.xResetConateinerDOs := TRUE;
							
							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Numeric Container: Wrong Size or Version: Index = {##AttrVar1}. RESET';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();

						ELSE

							// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
							_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );

						END_IF
				
					ELSE
						
						_PmIntern.xResetConateinerDOs := TRUE;

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Numeric Container: To small: Index = {##AttrVar1}. RESET';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

					END_IF
					
				ELSE

					_PmIntern.xResetConateinerDOs := TRUE;
					
					IF _PmIntern.ActContainer.bDirect <> 0 THEN

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Numeric Container does not exist: Index = {##AttrVar1}. Status = {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _diCSVNum.status;
						_PmIntern.Logger();
					
					END_IF					
					
				END_IF

				// String Daten
				_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));

				IF _diCSVString.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
					_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
					
					IF _diCSVString.len >= SIZEOF(mnParam_CsvDynHeader_typ) THEN
				
						_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;

						IF _PmIntern.CSVDataObjects.Size.lCSVString < _pDoContainerString.Header.Do.lActEndPos OR _pDoContainerString.Header.Version.wVersion <> _pDoContainer.Header.Version.wVersion THEN
							
							_PmIntern.xResetConateinerDOs := TRUE;
							
							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'String Container: Wrong Size or Version: Index = {##AttrVar1}. RESET';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();

						ELSE

							// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
							_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );

						END_IF
				
					ELSE
						
						_PmIntern.xResetConateinerDOs := TRUE;

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'String Container: To small: Index = {##AttrVar1}. RESET';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= 0;
						_PmIntern.Logger();

					END_IF
					
				ELSE

					_PmIntern.xResetConateinerDOs := TRUE;
					
					IF _PmIntern.ActContainer.bDirect <> 0 THEN

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'String Container does not exist: Index = {##AttrVar1}. Status = {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _diCSVString.status;
						_PmIntern.Logger();
					
					END_IF					

				END_IF

				// Bei indirekter Parametrierung, das Binär-Datenobjekt
				IF _PmIntern.ActContainer.bDirect = 0 THEN
					
					_diDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoName));

					IF _diDO.status = ERR_OK THEN

						_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDO.ident;
						_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDO.len;
						_PmIntern.CSVDataObjects.Adress.lDataObjekt := _diDO.pDatObjMem;
						
						IF _PmIntern.ActContainer.lSizeStructRoot <= _diDO.len THEN
					
							_drDO(enable := TRUE, ident := _diDO.ident, Offset := 0, pDestination := _PmIntern.ActContainer.lAdressStructRoot, len := _PmIntern.ActContainer.lSizeStructRoot);
						
						ELSE

							_PmIntern.xResetConateinerDOs := TRUE;

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Binary Dataobject: To small: Index = {##AttrVar1}. RESET';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();
						
						END_IF

					ELSE

						_PmIntern.xResetConateinerDOs := TRUE;

					END_IF
					
				END_IF
				
				// ggf. DO löschen
				
				IF _PmIntern.xResetConateinerDOs THEN
					
					IF _PmIntern.CSVDataObjects.Idents.lCSVNum <> 0 THEN
					
						_ddCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum);
					
						IF _ddCSVNum.status <> ERR_OK THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Delete Numeric Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _ddCSVNum.status;
							_PmIntern.Logger();

						END_IF					

						_PmIntern.CSVDataObjects.Idents.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Size.lCSVNum := 0;

					END_IF

					IF _PmIntern.CSVDataObjects.Idents.lCSVString <> 0 THEN
					
						_ddCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString);
					
						IF _ddCSVString.status <> ERR_OK THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Delete Numeric Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _ddCSVString.status;
							_PmIntern.Logger();
					
						END_IF					

						_PmIntern.CSVDataObjects.Idents.lCSVString := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVString := 0;
						_PmIntern.CSVDataObjects.Size.lCSVString := 0;

					END_IF

					IF _PmIntern.CSVDataObjects.Idents.lDataObjekt <> 0 THEN
					
						_ddDataObjekt(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt);
					
						IF _ddDataObjekt.status <> ERR_OK THEN

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Delete Binary DataObject: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _ddDataObjekt.status;
							_PmIntern.Logger();
					
						END_IF					

						_PmIntern.CSVDataObjects.Idents.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Adress.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Size.lDataObjekt := 0;

					END_IF
					
				ELSE	

					_wIdxToc := _PmIntern.TOC.wStartIdx[_PmIntern.ActContainer.siContainerID * (-1)] + _PmIntern.ActContainer.wIndexIndirect - _PmIntern.ActContainer.wMinBound;

					IF _wIdxToc >= 1 AND _wIdxToc <= MNPARAM_CNT_CSVFILES THEN
				
						_PmIntern.TOC.TocEntry[_wIdxToc].xExist := TRUE;
						_PmIntern.TOC.TocEntry[_wIdxToc].iContainerID := _PmIntern.ActContainer.siContainerID;
						IF _PmIntern.ActContainer.bDirect = 1 THEN
							_PmIntern.TOC.TocEntry[_wIdxToc].wInstance := 0;
						ELSE
							_PmIntern.TOC.TocEntry[_wIdxToc].wInstance := _PmIntern.ActContainer.wIndexIndirect;
						END_IF
						_PmIntern.TOC.TocEntry[_wIdxToc].dtTimestamp :=  _pDoContainerNum.Header.Time.dtTimestamp;
					
					END_IF

				END_IF

// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
		REPEAT
		UNTIL
			(_lSingleStep > _pl_InitState) AND (_lLoop >= _lLoopCount) OR NOT _xSingleStep
		END_REPEAT
#endif

				//****************************************************************************************************************
				// Existiert das csv-File ?
				//****************************************************************************************************************

				_PmIntern.enInitState := is_LookForFile;

				// 1. Versuch: Zunächst im PM-Verzeichnis suchen

				brsmemset(ADR(_PmIntern.CSVFile), 0, SIZEOF(_PmIntern.CSVFile));
				_PmIntern.Parse.lFileAdress := 0;
				_PmIntern.Parse.lCntLines := 0;
				_PmIntern.Parse.lFileSize := 0;


				_PmIntern.sActPathAndFilename := MNPARAM_PATH_PM;
				brsstrcat(ADR(_PmIntern.sActPathAndFilename), ADR(_PmIntern.ActContainer.sCsvName));
				brsstrcpy(ADR(_PmIntern.CSVFile.sName), ADR(_PmIntern.ActContainer.sCsvName));
		
				_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_PmIntern.sActPathAndFilename), pInfo := ADR(_fiFileInfo));
		
				IF _FileInfo.status = ERR_OK AND _fiFileInfo.size > SIZEOF(KGBOM) THEN

					// File existiert --> öffnen und in temporären Speicher kopieren
					_PmIntern.CSVFile.lSize := _fiFileInfo.size - SIZEOF(KGBOM);
					
					_PmIntern.CSVFile.sNameInPm := _PmIntern.sActPathAndFilename;

					_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.CSVFile.lSize);
		
					IF _MemPartAlloc.status = ERR_OK THEN

						_PmIntern.Parse.lFileAdress := _MemPartAlloc.mem;
						_PmIntern.Parse.lFileSize := _PmIntern.CSVFile.lSize;

						_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH),pFile := ADR(_PmIntern.CSVFile.sNameInPm), mode := fiREAD_ONLY);

						IF _FileOpen.status = ERR_OK THEN
			
							_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _PmIntern.Parse.lFileAdress, len :=  _PmIntern.Parse.lFileSize) ;

							IF _FileRead.status <> ERR_OK THEN

								// Datei aus PM lesen, ist misslungen
								_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.Parse.lFileAdress);

								_PmIntern.Parse.lFileAdress := 0;
								_PmIntern.Parse.lCntLines := 0;
								_PmIntern.Parse.lFileSize := 0;
							
								_PmIntern.CSVFile.sNameInPm := '';
								_PmIntern.CSVFile.lSize := 0;

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'FileRead Data Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _FileRead.status;
								_PmIntern.Logger();
								
							ELSE
								
								_PmIntern.ActContainer.xWriteProtected := TRUE;
								
								_PmIntern.sActPathAndFilename := MNPARAM_PATH_EXPORT;
								brsstrcat(ADR(_PmIntern.sActPathAndFilename), ADR(_PmIntern.ActContainer.sCsvName));
								brsstrcpy(ADR(_PmIntern.CSVFile.sName), ADR(_PmIntern.ActContainer.sCsvName));
		
								_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_PmIntern.sActPathAndFilename), pInfo := ADR(_fiFileInfo));
					
								IF _FileInfo.status = ERR_OK AND _fiFileInfo.size > SIZEOF(KGBOM) THEN
						
									_PmIntern.ActContainer.xExportfileExist := TRUE;
						
								END_IF
								
							END_IF // _FileRead.status = ERR_OK
			
							REPEAT
								_FileClose(enable := TRUE, ident := _FileOpen.ident);
								UNTIL _FileClose.status <> ERR_FUB_BUSY
							END_REPEAT
							
						ELSE

							// Datei aus PM lesen, ist misslungen
							_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.Parse.lFileAdress);
							
							_PmIntern.Parse.lFileAdress := 0;
							_PmIntern.Parse.lCntLines := 0;
							_PmIntern.Parse.lFileSize := 0;
							
							_PmIntern.CSVFile.sNameInPm := '';
							_PmIntern.CSVFile.lSize := 0;

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'FileOpen Data Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _FileOpen.status;
							_PmIntern.Logger();

						END_IF // _FileOpen.status = ERR_OK

						_PmIntern.CSVFile.sNameInPm := '';
						_PmIntern.CSVFile.lSize := 0;

					ELSE

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'MemPartAlloc for Data Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _MemPartAlloc.status;
						_PmIntern.Logger();

					END_IF // _MemPartAlloc.status = ERR_OK

					_PmIntern.CSVFile.sNameInPm := '';
					_PmIntern.CSVFile.lSize := 0;

				END_IF  //_FileInfo.status = ERR_OK
				
				// 2. Versuch: Im Export-Verzeichnis suchen

				IF _PmIntern.Parse.lFileAdress = 0 THEN
					
					// Im PM-Verzeichnis gab es keine Datei, dann im Export-Verzeichnis suchen
					
					brsmemset(ADR(_PmIntern.CSVFile), 0, SIZEOF(_PmIntern.CSVFile));

					_PmIntern.sActPathAndFilename := MNPARAM_PATH_EXPORT;
					brsstrcat(ADR(_PmIntern.sActPathAndFilename), ADR(_PmIntern.ActContainer.sCsvName));
					brsstrcpy(ADR(_PmIntern.CSVFile.sName), ADR(_PmIntern.ActContainer.sCsvName));
		
					_FileInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_PmIntern.sActPathAndFilename), pInfo := ADR(_fiFileInfo));
		
					IF _FileInfo.status = ERR_OK AND _fiFileInfo.size > SIZEOF(KGBOM) THEN

						// File existiert --> öffnen und Version bestimmen
						_PmIntern.CSVFile.lSize := _fiFileInfo.size - SIZEOF(KGBOM);
					
						_PmIntern.CSVFile.sNameInExp := _PmIntern.sActPathAndFilename;

						_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.CSVFile.lSize);
		
						IF _MemPartAlloc.status = ERR_OK THEN

							_PmIntern.Parse.lFileAdress := _MemPartAlloc.mem;
							_PmIntern.Parse.lFileSize := _PmIntern.CSVFile.lSize;

							_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH),pFile := ADR(_PmIntern.sActPathAndFilename), mode := fiREAD_ONLY);

							IF _FileOpen.status = ERR_OK THEN
			
								_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM),pDest := _PmIntern.Parse.lFileAdress, len :=  _PmIntern.Parse.lFileSize) ;

								IF _FileRead.status <> ERR_OK THEN

									// Datei aus PM lesen, ist misslungen
									_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.Parse.lFileAdress);

									_PmIntern.Parse.lFileAdress := 0;
									_PmIntern.Parse.lCntLines := 0;
									_PmIntern.Parse.lFileSize := 0;
							
									_PmIntern.CSVFile.sNameInExp := '';
									_PmIntern.CSVFile.lSize := 0;

									_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
									_PmIntern.Logger.text		:= 'FileRead Data Container from Export: Index = {##AttrVar1}. Status: {##AttrVar2}';
									_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
									_PmIntern.Logger.var2		:= _FileRead.status;
									_PmIntern.Logger();
								
								ELSE
									
									_PmIntern.ActContainer.xWriteProtected := FALSE;
									
									_PmIntern.ActContainer.xExportfileExist := TRUE;
									
								END_IF // _FileRead.status = ERR_OK
			
								REPEAT
									_FileClose(enable := TRUE, ident := _FileOpen.ident);
									UNTIL _FileClose.status <> ERR_FUB_BUSY
								END_REPEAT

							ELSE

								// Datei aus PM lesen, ist misslungen
								_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.Parse.lFileAdress);
							
								_PmIntern.Parse.lFileAdress := 0;
								_PmIntern.Parse.lCntLines := 0;
								_PmIntern.Parse.lFileSize := 0;
							
								_PmIntern.CSVFile.sNameInExp := '';
								_PmIntern.CSVFile.lSize := 0;

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'FileOpen Data Container in Export: Index = {##AttrVar1}. Status: {##AttrVar2}';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _FileOpen.status;
								_PmIntern.Logger();
								
							END_IF // _FileOpen.status = ERR_OK

							_PmIntern.CSVFile.sNameInExp := '';
							_PmIntern.CSVFile.lSize := 0;

						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'MemPartAlloc for Data Container from Export: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _MemPartAlloc.status;
							_PmIntern.Logger();

						END_IF // _MemPartAlloc.status = ERR_OK

						_PmIntern.CSVFile.sNameInExp := '';
						_PmIntern.CSVFile.lSize := 0;

					END_IF  //_FileInfo.status = ERR_OK
									
				END_IF				

				// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
				#ifdef SINGLEmnParam
				REPEAT
					UNTIL
					(_lSingleStep > _pl_InitState) AND (_lLoop >= _lLoopCount) OR NOT _xSingleStep
				END_REPEAT
				#endif


				//****************************************************************************************************************
				// Datenobjekte anlegen
				//****************************************************************************************************************

				_PmIntern.enInitState := is_CreateDOvalue;

				IF _PmIntern.CSVDataObjects.Idents.lCSVNum = 0 AND (_PmIntern.ActContainer.bDirect = 1 OR _PmIntern.Parse.lFileAdress <> 0) THEN
					
					//**************************************************************		
					// Für indirekte Parametrierung
					//**************************************************************		
								
					IF _PmIntern.ActContainer.bDirect = 0 THEN
						
						// Einfach die Default-Vorlagen verwenden
						_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefNum));
						
						IF _diCSVNum.status = ERR_OK THEN
							
							_dcpCSVNum(enable := TRUE, ident := _diCSVNum.ident, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameNum), MemTypeTarget := doUSRROM, OptionTarget := 0);
							
							IF _dcpCSVNum.status = ERR_OK THEN
								
								_PmIntern.CSVDataObjects.Idents.lCSVNum := _dcpCSVNum.identNew;
								_PmIntern.CSVDataObjects.Adress.lCSVNum := _dcpCSVNum.pDatObjMemNew;
								_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
								
								_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;

								// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
								_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );

								// Es muss auch eine CSV-Datei geschrieben werden
								_PmIntern.xExportContainerCsv := TRUE;

							ELSE

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'Copy Default Data Object Numeric: Index = {##AttrVar1}. Status: {##AttrVar2}';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _dcpCSVNum.status;
								_PmIntern.Logger();
							
							END_IF
							
						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Default Data Object Numeric does not exist: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _diCSVNum.status;
							_PmIntern.Logger();
							
						END_IF
						

						// Einfach die Default-Vorlagen verwenden
						_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefString));
						
						IF _diCSVString.status = ERR_OK THEN
							
							_dcpCSVString(enable := TRUE, ident := _diCSVString.ident, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameString), MemTypeTarget := doUSRROM, OptionTarget := 0);
							
							IF _dcpCSVString.status = ERR_OK THEN
								
								_PmIntern.CSVDataObjects.Idents.lCSVString := _dcpCSVString.identNew;
								_PmIntern.CSVDataObjects.Adress.lCSVString := _dcpCSVString.pDatObjMemNew;
								_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
								
								_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;

								// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
								_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );

								// Es muss auch eine CSV-Datei geschrieben werden
								_PmIntern.xExportContainerCsv := TRUE;

							ELSE

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'Copy Default Data Object String: Index = {##AttrVar1}. Status: {##AttrVar2}';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _dcpCSVString.status;
								_PmIntern.Logger();
							
							END_IF
							
						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Default Data Object String does not exist: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _diCSVString.status;
							_PmIntern.Logger();
							
						END_IF


						// Einfach die Default-Vorlagen verwenden
						_diDefaultDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDef));
						
						IF _diDefaultDO.status = ERR_OK THEN
							
							_dcpDefaultDO(enable := TRUE, ident := _diDefaultDO.ident, pNameTarget := ADR(_PmIntern.ActContainer.sDoName), MemTypeTarget := doUSRROM, OptionTarget := 0);
							
							IF _dcpDefaultDO.status = ERR_OK THEN
								
								_PmIntern.CSVDataObjects.Idents.lDataObjekt := _dcpDefaultDO.identNew;
								_PmIntern.CSVDataObjects.Adress.lDataObjekt := _dcpDefaultDO.pDatObjMemNew;
								_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDefaultDO.len;
								
								_drDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, Offset := 0, pDestination := _PmIntern.ActContainer.lAdressStructRoot, len := _PmIntern.ActContainer.lSizeStructRoot);

							ELSE

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'Copy Default Data Object Binary: Index = {##AttrVar1}. Status: {##AttrVar2}';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _dcpDefaultDO.status;
								_PmIntern.Logger();

							END_IF

						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Default Data Object Binary does not exist: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _diDefaultDO.status;
							_PmIntern.Logger();

						END_IF


						//**************************************************************		
						// Für direkte Parametrierung
						//**************************************************************		
					ELSE

						// DO auf jeden Fall auf Basis des aktuellen Datenmodells erzeugen
						
						//****************************************************************************************************************
						// Speicher zum Erstellen der Datenobjekte Allokieren
						//****************************************************************************************************************
						
						_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := _pDoContainer.Container[_c].lCountNum;
						_PmIntern.ActContainer.lCountParamNum := _pDoContainer.Container[_c].lCountNum;
						_PmIntern.CSVDataObjects.MaxIndex.lCSVString := _pDoContainer.Container[_c].lCountString;
						_PmIntern.ActContainer.lCountParamString := _pDoContainer.Container[_c].lCountString;
						
						_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(mnParam_CsvDynHeader_typ) + (_PmIntern.CSVDataObjects.MaxIndex.lCSVNum * SIZEOF(_pDoContainerNum.CsvNum[1])) );
				
						IF _MemPartAlloc.status = ERR_OK THEN

							brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
							_PmIntern.CSVDataObjects.TempAdresses.lCSVNum 	:= _MemPartAlloc.mem;
							_PmIntern.CSVDataObjects.Size.lCSVNum 				:= _MemPartAlloc.len;
				
							_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVNum;

							_pDoContainerNum.Header.Version := _pDoContainer.Header.Version;
							_pDoContainerNum.Header.Do.lActEndPos := _PmIntern.CSVDataObjects.Size.lCSVNum;
							brwcscpy(ADR(_pDoContainerNum.Header.MachineNo.utfMachineNo), ADR(IFmnParam.Out.utfMachineNumber));

							_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := SIZEOF(mnParam_CsvDynHeader_typ) + (_PmIntern.CSVDataObjects.MaxIndex.lCSVString * SIZEOF(_pDoContainerString.CsvString[1])) );
				
							IF _MemPartAlloc.status = ERR_OK THEN

								brsmemset(_MemPartAlloc.mem, 0, _MemPartAlloc.len);
								_PmIntern.CSVDataObjects.TempAdresses.lCSVString 	:= _MemPartAlloc.mem;
								_PmIntern.CSVDataObjects.Size.lCSVString 				:= _MemPartAlloc.len;
				
								_pDoContainerString ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVString;

								_pDoContainerString.Header.Version := _pDoContainer.Header.Version;
								_pDoContainerString.Header.Do.lActEndPos := _PmIntern.CSVDataObjects.Size.lCSVString;
								brwcscpy(ADR(_pDoContainerString.Header.MachineNo.utfMachineNo), ADR(IFmnParam.Out.utfMachineNumber));

								//****************************************************************************************************************
								// Datenobjekte beschreiben (NUM)
								//****************************************************************************************************************

								_wIdxCsvNum := 1;
					
								FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lParamNum) DO

									_getContainerParamNum(enable := TRUE, pLogicStructs := ADR(_pDoLogicalStruct.LogicalStruct[1]), wMaxIdxLogicStructs := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct), pParamNum := ADR(_pDoParamNum.ParamNum[_i]));
						
									IF _getContainerParamNum.status = ERR_OK  AND _getContainerParamNum.iContainer = _pDoContainer.Container[_c].siContainerID THEN
							
										_dim1 := MAX(1, _getContainerParamNum.wDimension[1]);
										_dim2 := MAX(1, _getContainerParamNum.wDimension[2]);
										_dim3 := MAX(1, _getContainerParamNum.wDimension[3]);
										_dim4 := MAX(1, _getContainerParamNum.wDimension[4]);
							
										FOR _i1 := _getContainerParamNum.wMinBound[1] TO _getContainerParamNum.wMinBound[1] + _dim1-1 DO

											FOR _i2 := _getContainerParamNum.wMinBound[2] TO _getContainerParamNum.wMinBound[2] + _dim2 -1 DO

												FOR _i3 := _getContainerParamNum.wMinBound[3] TO _getContainerParamNum.wMinBound[3] + _dim3 -1 DO

													FOR _i4 := _getContainerParamNum.wMinBound[4] TO _getContainerParamNum.wMinBound[4] + _dim4 -1 DO
									
														IF _wIdxCsvNum <= _PmIntern.CSVDataObjects.MaxIndex.lCSVNum THEN
									
															_pDoContainerNum.CsvNum[_wIdxCsvNum].wIdxNumPar := _i;
															_pDoContainerNum.CsvNum[_wIdxCsvNum].bRowType := _pDoParamNum.ParamNum[_i].bRowType;
															_pDoContainerNum.CsvNum[_wIdxCsvNum].diValue := _pDoParamNum.ParamNum[_i].diDefValue;

															IF _getContainerParamNum.wCountArray >= 1 THEN

																_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx1 := _i1;

																IF _getContainerParamNum.wCountArray >= 2 THEN
	
																	_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx2 := _i2;

																	IF _getContainerParamNum.wCountArray >= 3 THEN
	
																		_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx3 := _i3;

																		IF _getContainerParamNum.wCountArray = 4 THEN
	
																			_pDoContainerNum.CsvNum[_wIdxCsvNum].wArrIdx4 := _i4;
													
																		END_IF
													
																	END_IF
													
																END_IF
												
															END_IF

															_wIdxCsvNum := _wIdxCsvNum + 1;

														END_IF
											
													END_FOR
									
												END_FOR
									
											END_FOR
								
										END_FOR	
						
									END_IF
						
								END_FOR
									

								//****************************************************************************************************************
								// Datenobjekte beschreiben (STRING)
								//****************************************************************************************************************
								_wIdxCsvString := 1;
					
								FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lParamString) DO

									_getContainerParamString(enable := TRUE, pLogicStructs := ADR(_pDoLogicalStruct.LogicalStruct[1]), wMaxIdxLogicStructs := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct), pParamString := ADR(_pDoParamString.ParamString[_i]));
						
									IF _getContainerParamString.status = ERR_OK AND _getContainerParamString.iContainer = _pDoContainer.Container[_c].siContainerID THEN
							
										_dim1 := MAX(1, _getContainerParamString.wDimension[1]);
										_dim2 := MAX(1, _getContainerParamString.wDimension[2]);
										_dim3 := MAX(1, _getContainerParamString.wDimension[3]);
										_dim4 := MAX(1, _getContainerParamString.wDimension[4]);

										FOR _i1 := _getContainerParamString.wMinBound[1] TO _getContainerParamString.wMinBound[1] + _dim1 - 1 DO

											FOR _i2 := _getContainerParamString.wMinBound[2] TO _getContainerParamString.wMinBound[2] + _dim2 - 1 DO

												FOR _i3 := _getContainerParamString.wMinBound[3] TO _getContainerParamString.wMinBound[3] + _dim3 - 1 DO

													FOR _i4 := _getContainerParamString.wMinBound[4] TO _getContainerParamString.wMinBound[4] + _dim4 - 1 DO
									
														IF _wIdxCsvString <= _PmIntern.CSVDataObjects.MaxIndex.lCSVString THEN
									
															_pDoContainerString.CsvString[_wIdxCsvString].wIdxStringPar := _i;
															brwcsncpy(ADR(_pDoContainerString.CsvString[_wIdxCsvString].utfValue), ADR(_pDoParamString.ParamString[_i].utfDefValue), 31);

															IF _getContainerParamString.wCountArray >= 1 THEN

																_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx1 := _i1;

																IF _getContainerParamString.wCountArray >= 2 THEN
	
																	_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx2 := _i2;

																	IF _getContainerParamString.wCountArray >= 3 THEN
	
																		_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx3 := _i3;

																		IF _getContainerParamString.wCountArray = 4 THEN
	
																			_pDoContainerString.CsvString[_wIdxCsvString].wArrIdx4 := _i4;
													
																		END_IF
													
																	END_IF
													
																END_IF
												
															END_IF
									
															_wIdxCsvString := _wIdxCsvString + 1;

														END_IF
											
													END_FOR
									
												END_FOR
									
											END_FOR
								
										END_FOR	
						
									END_IF
						
								END_FOR

								//****************************************************************************************************************
								// Datenobjekte anlegen
								//****************************************************************************************************************

								_dcCSVNum(enable := TRUE, grp := 0, pName := ADR(_PmIntern.ActContainer.sDoNameNum), len := _PmIntern.CSVDataObjects.Size.lCSVNum, MemType := doUSRROM, Option := 0, pCpyData := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);

								IF (_dcCSVNum.status = ERR_OK) THEN
									_PmIntern.CSVDataObjects.Idents.lCSVNum := _dcCSVNum.ident;
									_PmIntern.CSVDataObjects.Adress.lCSVNum := _dcCSVNum.pDatObjMem;
									_PmIntern.CSVDataObjects.Size.lCSVNum := _dcCSVNum.len;
									
									_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;

									// Es muss auch eine CSV-Datei geschrieben werden
									_PmIntern.xExportContainerCsv := TRUE;
														
								ELSE

									_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
									_PmIntern.Logger.text		:= 'Create Data Object Numeric failed: Index = {##AttrVar1}. Status: {##AttrVar2}';
									_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
									_PmIntern.Logger.var2		:= _dcCSVNum.status;
									_PmIntern.Logger();
									
								END_IF

								_dcCSVString(enable := TRUE, grp := 0, pName := ADR(_PmIntern.ActContainer.sDoNameString), len := _PmIntern.CSVDataObjects.Size.lCSVString, MemType := doUSRROM, Option := 0, pCpyData :=_PmIntern.CSVDataObjects.TempAdresses.lCSVString);

								IF (_dcCSVString.status = ERR_OK) THEN
									_PmIntern.CSVDataObjects.Idents.lCSVString := _dcCSVString.ident;
									_PmIntern.CSVDataObjects.Adress.lCSVString := _dcCSVString.pDatObjMem;
									_PmIntern.CSVDataObjects.Size.lCSVString := _dcCSVString.len;

									_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;

									// Es muss auch eine CSV-Datei geschrieben werden
									_PmIntern.xExportContainerCsv := TRUE;
														
								ELSE

									_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
									_PmIntern.Logger.text		:= 'Create Data Object String failed: Index = {##AttrVar1}. Status: {##AttrVar2}';
									_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
									_PmIntern.Logger.var2		:= _dcCSVString.status;
									_PmIntern.Logger();

								END_IF

								_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
								_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := 0;
					
								_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
								_PmIntern.CSVDataObjects.TempAdresses.lCSVString := 0;

							ELSE

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'MemPartAlloc for Data Object String: Index = {##AttrVar1}. Status: {##AttrVar2}';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _MemPartAlloc.status;
								_PmIntern.Logger();

							END_IF //IF _MemPartAlloc.status = ERR_OK 

						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'MemPartAlloc for Data Object Numeric: Index = {##AttrVar1}. Status: {##AttrVar2}';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _MemPartAlloc.status;
							_PmIntern.Logger();

						END_IF

					END_IF // Direkte Parametrierung

				END_IF // Müssen Datenobjekte angelegt werden

				// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
				#ifdef SINGLEmnParam
				REPEAT
		UNTIL
					(_lSingleStep > _pl_InitState) AND (_lLoop >= _lLoopCount) OR NOT _xSingleStep
				END_REPEAT
#endif

				//****************************************************************************************************************
				// CSV-Datei auf Datum prüfen und ggf. einlesen
				//****************************************************************************************************************

				_PmIntern.enInitState := is_TestFileDate;

				// Wenn Datei gefunden, dann Version und Datum bestimmen

				IF _PmIntern.Parse.lFileAdress <> 0   THEN
					
					brsmemset(_PmIntern.Parse.lLineTableAdress, 0, MNPARAM_MAXPARSELINES * SIZEOF(UDINT));
					brsmemset(_PmIntern.Parse.lLineTableLen, 0, MNPARAM_MAXPARSELINES * SIZEOF(UINT));
		
					_CountLines.enable 	:= TRUE;
					_CountLines.pFile 		:= _PmIntern.Parse.lFileAdress;
					_CountLines.FileSize 	:= _PmIntern.Parse.lFileSize;
					_CountLines.MaxLines	:= MNPARAM_MAXPARSELINES;
					_CountLines.pAdresses	:= _PmIntern.Parse.lLineTableAdress;
					_CountLines.pLens		:= _PmIntern.Parse.lLineTableLen;
		
					_CountLines();

					IF _CountLines.status = ERR_OK THEN

						_PmIntern.Parse.lCntLines := _CountLines.CntLines;
		
						// Suche Versionszeile
		
						_wStartLine := 1;
						_xFoundVersion := FALSE;
						_xFoundDate := FALSE;
						_xFoundMachineNo := FALSE;
					
						REPEAT
			
							_GetCsvDat.enable := TRUE;
							brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
							_GetCsvDat();
							IF _GetCsvDat.RowType = MNPARAM_CSV_HEADER_VERSION THEN
								
								_CsvHeaderVersion := _GetCsvDat.HeaderVersion;
								_xFoundVersion := TRUE;
								
							ELSIF _GetCsvDat.RowType = MNPARAM_CSV_HEADER_TIMESTAMP THEN
								
								_CsvHeaderDate := _GetCsvDat.HeaderTime;
								_xFoundDate := TRUE;

							ELSIF _GetCsvDat.RowType = MNPARAM_CSV_HEADER_MACHINENO THEN
								
								_CsvHeaderMachineNo := _GetCsvDat.HeaderMachineNo;
								_xFoundMachineNo := TRUE;

							END_IF

							_wStartLine := _wStartLine + 1;
			
						UNTIL
							(_xFoundDate AND _xFoundVersion AND _xFoundMachineNo) OR _wStartLine > _PmIntern.Parse.lCntLines
						END_REPEAT

						_PmIntern.ActContainer.xDataImported := FALSE;

						IF _xFoundDate AND _xFoundVersion AND _xFoundMachineNo THEN
							
							// Ist der Maschinentyp OK ?
							IF brwcscmp(ADR(_CsvHeaderVersion.utfMachineType),ADR(_pDoContainer.Header.Version.utfMachineType)) = 0 THEN
								
								// Ist die Maschinennummer OK ?
								IF brwcscmp(ADR(_CsvHeaderMachineNo.utfMachineNo),ADR(IFmnParam.Out.utfMachineNumber)) = 0 THEN
								
									// Ist die CSV-Datei neuer als die Daten in den DO ?
									IF _pDoContainerNum.Header.Time.dtTimestamp < _CsvHeaderDate.dtTimestamp THEN
										
										//****************************************************************************************************************
										// Datenobjekte für das Importieren in den Hauptspeicher kopieren
										//****************************************************************************************************************
	
										_PmIntern.enInitState := is_ImportData1;
	
										//##20110901AH
										_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
										_PmIntern.Logger.text		:= 'Import Container Index = {##AttrVar1}. Index: {##AttrVar2}';
										_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
										_PmIntern.Logger.var2		:= _PmIntern.ActContainer.wIndexIndirect;
										_PmIntern.Logger();
	
										// Numerische Daten			
										_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameNum));
	
										IF _diCSVNum.status = ERR_OK THEN
						
											_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;
											_PmIntern.CSVDataObjects.Adress.lCSVNum := _diCSVNum.pDatObjMem;
											_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
						
											_MemPartAlloc(enable :=TRUE, ident := _MemPartCreate.ident, len := _diCSVNum.len);
											
											IF _MemPartAlloc.status = ERR_OK THEN
												
												_drCSVNum(enable := TRUE, ident := _diCSVNum.ident, Offset := 0, pDestination := _MemPartAlloc.mem, len := _MemPartAlloc.len);
												
												IF _drCSVNum.status = ERR_OK THEN
													
													// Im Hauptspeicher ist wieder Schreibzugriff möglich
													_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := _MemPartAlloc.mem;
													_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVNum;
	
													// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
													_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );
													
												ELSE
													
													_PmIntern.CSVDataObjects.Idents.lCSVNum := 0;
													_PmIntern.CSVDataObjects.Adress.lCSVNum := 0;
													_PmIntern.CSVDataObjects.Size.lCSVNum := 0;
	
													_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _MemPartAlloc.mem);
													
													_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
													_PmIntern.Logger.text		:= 'Read Data Object Numeric Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
													_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
													_PmIntern.Logger.var2		:= _drCSVNum.status;
													_PmIntern.Logger();
	
												END_IF
												
											ELSE
												
												_PmIntern.CSVDataObjects.Idents.lCSVNum := 0;
												_PmIntern.CSVDataObjects.Adress.lCSVNum := 0;
												_PmIntern.CSVDataObjects.Size.lCSVNum := 0;
	
												_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
												_PmIntern.Logger.text		:= 'MemPartAlloc for Read Data Object Numeric Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
												_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
												_PmIntern.Logger.var2		:= _MemPartAlloc.status;
												_PmIntern.Logger();
												
											END_IF // _MemPartAlloc.status
										
										ELSE
												
											_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
											_PmIntern.Logger.text		:= 'Data Object Numeric Container does not exist: Index = {##AttrVar1}. Status: {##AttrVar2}';
											_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
											_PmIntern.Logger.var2		:= _diCSVNum.status;
											_PmIntern.Logger();
	
										END_IF // _diCSVNum.status
	
	
										// String Daten			
										_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));
	
										IF _diCSVString.status = ERR_OK THEN
						
											_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
											_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
											_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
						
											_MemPartAlloc(enable :=TRUE, ident := _MemPartCreate.ident, len := _diCSVString.len);
											
											IF _MemPartAlloc.status = ERR_OK THEN
												
												_drCSVString(enable := TRUE, ident := _diCSVString.ident, Offset := 0, pDestination := _MemPartAlloc.mem, len := _MemPartAlloc.len);
												
												IF _drCSVString.status = ERR_OK THEN
													
													// Im Hauptspeicher ist wieder Schreibzugriff möglich
													_PmIntern.CSVDataObjects.TempAdresses.lCSVString := _MemPartAlloc.mem;
													_pDoContainerString ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVString;
	
													// Maximalen Index für Einträge prüfen. Lücken sollte es nicht geben
													_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );
													
												ELSE
													
													_PmIntern.CSVDataObjects.Idents.lCSVString := 0;
													_PmIntern.CSVDataObjects.Adress.lCSVString := 0;
													_PmIntern.CSVDataObjects.Size.lCSVString := 0;
	
													_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _MemPartAlloc.mem);
													
													_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
													_PmIntern.Logger.text		:= 'Read Data Object String Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
													_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
													_PmIntern.Logger.var2		:= _drCSVString.status;
													_PmIntern.Logger();
													
												END_IF
												
											ELSE
												
												_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
												_PmIntern.Logger.text		:= 'MemPartAlloc for Read Data Object String Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
												_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
												_PmIntern.Logger.var2		:= _MemPartAlloc.status;
												_PmIntern.Logger();
												
											END_IF // _MemPartAlloc.status
										
										ELSE
												
											_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
											_PmIntern.Logger.text		:= 'Data Object String Container does not exist: Index = {##AttrVar1}. Status: {##AttrVar2}';
											_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
											_PmIntern.Logger.var2		:= _diCSVString.status;
											_PmIntern.Logger();
	
										END_IF // _diCSVNum.status
	
	
										// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
										#ifdef SINGLEmnParam
										REPEAT
											UNTIL
											_lSingleStep > _pl_InitState OR NOT _xSingleStep
										END_REPEAT
										#endif									
										

										//****************************************************************************************************************
										// Alles auf Default setzen
										//****************************************************************************************************************

										FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.CSVDataObjects.MaxIndex.lCSVNum) DO
						
											IF _pDoContainerNum.CsvNum[_i].wIdxNumPar > 0 AND _pDoContainerNum.CsvNum[_i].wIdxNumPar <= _PmIntern.ActContainer.lCountParamNum THEN
						
												_pDoContainerNum.CsvNum[_i].diValue := _pDoParamNum.ParamNum[_pDoContainerNum.CsvNum[_i].wIdxNumPar].diDefValue;
												_pDoContainerNum.CsvNum[_i].xChanged := FALSE;
						
											END_IF
						
										END_FOR

										FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.CSVDataObjects.MaxIndex.lCSVString) DO
						
											IF _pDoContainerString.CsvString[_i].wIdxStringPar > 0 AND _pDoContainerString.CsvString[_i].wIdxStringPar <= _PmIntern.ActContainer.lCountParamString THEN
						
												_pDoContainerString.CsvString[_i].utfValue := _pDoParamString.ParamString[_pDoContainerString.CsvString[_i].wIdxStringPar].utfDefValue;
												_pDoContainerString.CsvString[_i].xChanged := FALSE;
						
											END_IF
						
										END_FOR
										
										//****************************************************************************************************************
										// CSV-Datei importieren
										//****************************************************************************************************************
	
										_PmIntern.enInitState := is_ImportData2;
										
										_binarySearchNum.enable := TRUE;
										_binarySearchNum.lpList := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum;
										_binarySearchNum.lMaxRow := _PmIntern.CSVDataObjects.MaxIndex.lCSVNum;
	
										_binarySearchString.enable := TRUE;
										_binarySearchString.lpList := _PmIntern.CSVDataObjects.TempAdresses.lCSVString;
										_binarySearchString.lMaxRow := _PmIntern.CSVDataObjects.MaxIndex.lCSVString;
										
										REPEAT
				
											_GetCsvDat.enable := TRUE;
											brwcsncpy( ADR(_GetCsvDat.utfCsvString), _plLineAdress[_wStartLine], MIN(299, _pwLineLen[_wStartLine]));
											_GetCsvDat();
											
											IF _GetCsvDat.RowType = 10 OR _GetCsvDat.RowType = 11 THEN
	
												_binarySearchNum.CsvStructNum := _GetCsvDat.CsvNumRow;
												_binarySearchNum();
												
												IF _binarySearchNum.status = 0 THEN
	
													_pDoContainerNum.CsvNum[_binarySearchNum.lFoundRow] := _GetCsvDat.CsvNumRow;

													_LP(pCsvNumRow := ADR(_pDoContainerNum.CsvNum[_binarySearchNum.lFoundRow]), pParamNum := ADR(_pDoParamNum.ParamNum[_GetCsvDat.CsvNumRow.wIdxNumPar]) );
	
													_pDoContainerNum.CsvNum[_binarySearchNum.lFoundRow].xChanged := _pDoParamNum.ParamNum[_GetCsvDat.CsvNumRow.wIdxNumPar].diDefValue <> _GetCsvDat.CsvNumRow.diValue;
													
												ELSE
	
													_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
													_PmIntern.Logger.text		:= 'Binary Search Numeric. Container Index = {##AttrVar1}. Status: {##AttrVar2}: ';
													brsitoa(_GetCsvDat.CsvNumRow.wIdxNumPar, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvNumRow.wArrIdx1, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvNumRow.wArrIdx2, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvNumRow.wArrIdx3, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvNumRow.wArrIdx4, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
													_PmIntern.Logger.var2		:= _binarySearchNum.status;
													_PmIntern.Logger();
	
												END_IF
												
											ELSIF _GetCsvDat.RowType = 20 THEN
	
												_binarySearchString.CsvStructString := _GetCsvDat.CsvStringRow;
												_binarySearchString();
												
												IF _binarySearchString.status = 0 THEN
													
													_pDoContainerString.CsvString[_binarySearchString.lFoundRow] := _GetCsvDat.CsvStringRow;
													
													_pDoContainerString.CsvString[_binarySearchString.lFoundRow].xChanged := brwcscmp(ADR(_pDoParamString.ParamString[_GetCsvDat.CsvStringRow.wIdxStringPar].utfDefValue), ADR(_GetCsvDat.CsvStringRow.utfValue)) <> 0;
											
												ELSE
	
													_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
													_PmIntern.Logger.text		:= 'Binary Search String. Container Index = {##AttrVar1}. Status: {##AttrVar2}: ';
													brsitoa(_GetCsvDat.CsvStringRow.wIdxStringPar, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvStringRow.wArrIdx1, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvStringRow.wArrIdx2, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvStringRow.wArrIdx3, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, ', ');
													brsitoa(_GetCsvDat.CsvStringRow.wArrIdx4, ADR(_sNumeric));
													_PmIntern.Logger.text		:= CONCAT(_PmIntern.Logger.text, _sNumeric);
													_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
													_PmIntern.Logger.var2		:= _binarySearchString.status;
													_PmIntern.Logger();
													
												END_IF
									
									
											END_IF
	
											_wStartLine := _wStartLine + 1;
				
											UNTIL
											_wStartLine > _PmIntern.Parse.lCntLines
										END_REPEAT
	
										// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
										#ifdef SINGLEmnParam
										REPEAT
											UNTIL
											_lSingleStep > _pl_InitState OR NOT _xSingleStep
										END_REPEAT
										#endif
	
										//****************************************************************************************************************
										// DO schreiben 
										//****************************************************************************************************************
	
										_PmIntern.enInitState := is_ImportData3;
	
										_DTGetTime(enable := TRUE);
										_pDoContainerNum.Header.Time.dtTimestamp := _DTGetTime.DT1;
										_pDoContainerString.Header.Time.dtTimestamp := _DTGetTime.DT1;
										
										_pDoContainerNum.Header.Container.xWriteProtected := _PmIntern.ActContainer.xWriteProtected;
										_pDoContainerString.Header.Container.xWriteProtected := _PmIntern.ActContainer.xWriteProtected;
	
										IF _PmIntern.CSVDataObjects.Idents.lCSVNum <> 0 THEN
	
											_dwCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum, len := _PmIntern.CSVDataObjects.Size.lCSVNum);
											
											IF _dwCSVNum.status <> ERR_OK THEN
	
												_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
												_PmIntern.Logger.text		:= 'Write Data Object Numeric Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
												_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
												_PmIntern.Logger.var2		:= _dwCSVNum.status;
												_PmIntern.Logger();
												
											END_IF
											
											_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
											
											_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
											
											_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := 0;
	
										END_IF	
	
										IF _PmIntern.CSVDataObjects.Idents.lCSVString <> 0 THEN
	
											_dwCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lCSVString, len := _PmIntern.CSVDataObjects.Size.lCSVString);
											
											IF _dwCSVString.status <> ERR_OK THEN
	
												_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
												_PmIntern.Logger.text		:= 'Write Data Object String Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
												_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
												_PmIntern.Logger.var2		:= _dwCSVString.status;
												_PmIntern.Logger();
												
											END_IF
											
											_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
											
											_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
											
											_PmIntern.CSVDataObjects.TempAdresses.lCSVString := 0;
	
										END_IF	
	
										_PmIntern.ActContainer.xDataImported := TRUE;
									
									ELSIF _pDoContainerNum.Header.Time.dtTimestamp > _CsvHeaderDate.dtTimestamp THEN

										_PmIntern.ActContainer.xDataImported := TRUE;

									END_IF
									
								ELSE

									//Ungültige Maschinennummer
									_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
									_PmIntern.Logger.text		:= 'Wrong Machineno. in CSV-Container: Index = {##AttrVar1}/{##AttrVar2}. ';
									_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
									_PmIntern.Logger.var2		:= _PmIntern.ActContainer.wIndexIndirect;
									_PmIntern.Logger();
									
								END_IF
								
							ELSE

								//Ungültige Datei
								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'Wrong Machine Type in CSV-Container: Index = {##AttrVar1}/{##AttrVar2}. ';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _PmIntern.ActContainer.wIndexIndirect;
								_PmIntern.Logger();
								
							END_IF

						ELSE

							//Ungültige Datei
							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'No Version, date or machineno. in CSV-Container: Index = {##AttrVar1}/{##AttrVar2}. ';
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _PmIntern.ActContainer.wIndexIndirect;
							_PmIntern.Logger();

						END_IF
						
					ELSE

						//Ungültige Datei
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Fault in Counting Lines of CSV-Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _CountLines.status;
						_PmIntern.Logger();
						
					END_IF
					
					// Temporären Speicher zum Parsen der csv-Datei wieder frei geben
					_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.Parse.lFileAdress);
					_PmIntern.Parse.lFileAdress := 0;
										
				END_IF	

				// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
#ifdef SINGLEmnParam
				REPEAT
					UNTIL
					(_lSingleStep > _pl_InitState) AND (_lLoop >= _lLoopCount) OR NOT _xSingleStep
				END_REPEAT
#endif


				//****************************************************************************************************************
				// Datenobjekt für indirekte Parametrierung identifizieren
				//****************************************************************************************************************

				_PmIntern.enInitState := is_SetValue1;

				// Bei indirekter Parametrierung, das Binär-Datenobjekt
				IF _PmIntern.ActContainer.bDirect = 0 AND (_PmIntern.CSVDataObjects.MaxIndex.lCSVNum > 0 OR _PmIntern.CSVDataObjects.MaxIndex.lCSVString > 0) AND _PmIntern.ActContainer.xDataImported THEN

					_diDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoName));

					IF _diDO.status = ERR_OK THEN
						
						_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDO.ident;
						
						_wStatus := PV_xgetadr(ADR(_PmIntern.ActContainer.sStrucRoot), ADR(_PmIntern.CSVDataObjects.TempAdresses.lDataObjekt), ADR(_PmIntern.CSVDataObjects.Size.lDataObjekt));
						
						IF _wStatus = ERR_OK THEN
							
							_drDO(enable := TRUE, ident := _diDO.ident, Offset := 0, pDestination := _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt, len := _PmIntern.CSVDataObjects.Size.lDataObjekt);

							IF _drDO.status <> ERR_OK THEN

								//Ungültige Datei
								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= 'Data Object Read Binary Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
								_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
								_PmIntern.Logger.var2		:= _drDO.status;
								_PmIntern.Logger();
								
							END_IF
							
						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= CONCAT('Root element does not exist: Index = {##AttrVar1}. Status: {##AttrVar2} - ', _PmIntern.ActContainer.sStrucRoot);
							_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
							_PmIntern.Logger.var2		:= _wStatus;
							_PmIntern.Logger();
							
						END_IF

					ELSE

						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Data Object Binary does not exist! Container: Index = {##AttrVar1}. Status: {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _diDO.status;
						_PmIntern.Logger();
						
					END_IF
					
				END_IF


				// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
				#ifdef SINGLEmnParam
				REPEAT
					UNTIL
					(_lSingleStep > _pl_InitState) AND (_lLoop >= _lLoopCount) OR NOT _xSingleStep
				END_REPEAT
#endif
				
				//****************************************************************************************************************
				// Daten setzen
				//****************************************************************************************************************

				_PmIntern.enInitState := is_SetValue2;

				IF _PmIntern.ActContainer.bDirect = 1 OR _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt > 0 THEN
					
					// Numerische Parameter schreiben
					FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.CSVDataObjects.MaxIndex.lCSVNum) DO

						IF _pDoContainerNum.CsvNum[_i].wIdxNumPar > 0 AND _pDoContainerNum.CsvNum[_i].wIdxNumPar <= _PmIntern.DataObjects.MaxIndex.lParamNum THEN
							
							_PN := _pDoParamNum.ParamNum[_pDoContainerNum.CsvNum[_i].wIdxNumPar];
							
							_CN := _pDoContainerNum.CsvNum[_i];

							GetArrayPV(pPV := ADR(_PN.sAdresse), pStructRoot := ADR(_PmIntern.ActContainer.sStrucRoot), pPVFilled := ADR(_sPVAdress), idx1 :=_CN.wArrIdx1, idx2:=_CN.wArrIdx2, idx3:=_CN.wArrIdx3, idx4:=_CN.wArrIdx4);
							
							IF _CN.bRowType = 0 THEN
																			
								_WritePVNum(pAdress := ADR(_sPVAdress), diValue := _CN.diValue);
								
							ELSE
								
								_pdiValue ACCESS ADR(_rValue);
								_pdiValue := _CN.diValue;
								_WritePVrNum(pAdress := ADR(_sPVAdress), rValue := _rValue);
								
							END_IF
											
							IF _WritePVNum.status <> ERR_OK THEN

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= CONCAT('Write Numeric PV Status {##AttrVar1} - ',_sPVAdress);
								_PmIntern.Logger.var1		:= _WritePVNum.status;
								_PmIntern.Logger.var2		:= 0;
								_PmIntern.Logger();

							END_IF

						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Wrong Numeric Parameter Reference : {##AttrVar1}';
							_PmIntern.Logger.var1		:= _pDoContainerNum.CsvNum[_i].wIdxNumPar;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();
							
						END_IF
						
					END_FOR
					
					// String Parameter schreiben
					FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.CSVDataObjects.MaxIndex.lCSVString) DO

						IF _pDoContainerString.CsvString[_i].wIdxStringPar > 0 AND _pDoContainerString.CsvString[_i].wIdxStringPar <= _PmIntern.DataObjects.MaxIndex.lParamString THEN
							
							_PS := _pDoParamString.ParamString[_pDoContainerString.CsvString[_i].wIdxStringPar];
							
							_CS := _pDoContainerString.CsvString[_i];

							GetArrayPV(pPV := ADR(_PS.sAdresse), pStructRoot := ADR(_PmIntern.ActContainer.sStrucRoot), pPVFilled := ADR(_sPVAdress), idx1 :=_CS.wArrIdx1, idx2:=_CS.wArrIdx2, idx3:=_CS.wArrIdx3, idx4:=_CS.wArrIdx4);
																			
							IF _pDoContainerString.CsvString[_i].wIdxStringPar = MNPARAM_PARIDX_MACHINENAME AND _c = MNPARAM_IDX_MACHINENAMECONTAINER THEN
								mnParamStatAd.utfMachineName := _CS.utfValue;
							END_IF

							_WritePVString(pAdress := ADR(_sPVAdress), p_utfValue := ADR(_CS.utfValue));
											
							IF _WritePVString.status <> ERR_OK THEN

								_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
								_PmIntern.Logger.text		:= CONCAT('Write String PV Status {##AttrVar1} - ',_sPVAdress);
								_PmIntern.Logger.var1		:= _WritePVString.status;
								_PmIntern.Logger.var2		:= 0;
								_PmIntern.Logger();

							END_IF

						ELSE

							_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
							_PmIntern.Logger.text		:= 'Wrong String Parameter Reference : {##AttrVar1}';
							_PmIntern.Logger.var1		:= _pDoContainerString.CsvString[_i].wIdxStringPar;
							_PmIntern.Logger.var2		:= 0;
							_PmIntern.Logger();
							
						END_IF
						
					END_FOR
					
					
				END_IF				


				//****************************************************************************************************************
				// Datenobjekt für indirekte Parametrierung sichern
				//****************************************************************************************************************

				_PmIntern.enInitState := is_SetValue3;

				IF _PmIntern.ActContainer.bDirect = 0 AND _PmIntern.CSVDataObjects.Idents.lDataObjekt > 0 AND _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt > 0 THEN

					_dwDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt, len := _PmIntern.CSVDataObjects.Size.lDataObjekt);
					
					IF _dwDO.status <> ERR_OK THEN
	
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Writing Binary Data Object for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _dwDO.status;
						_PmIntern.Logger();
						
					END_IF
					
					_PmIntern.CSVDataObjects.Adress.lDataObjekt := 0;
					_PmIntern.CSVDataObjects.Idents.lDataObjekt := 0;
					_PmIntern.CSVDataObjects.Size.lDataObjekt := 0;
					_PmIntern.CSVDataObjects.TempAdresses.lDataObjekt := 0;
					
				END_IF


				//****************************************************************************************************************
				// CSV-Dateien in das Export-Verzeichnis schreiben
				//****************************************************************************************************************

				_PmIntern.enInitState := is_ExpCSV;
			
				IF _PmIntern.xExportContainerCsv OR _PmIntern.ActContainer.xDataImported OR (NOT _PmIntern.xResetConateinerDOs AND NOT _PmIntern.ActContainer.xExportfileExist) THEN

					_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
					_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
					_PmIntern.ExpSettings.sFilename := _PmIntern.ActContainer.sCsvName;
					
					_ec(Enable := TRUE, pIntern := ADR(_PmIntern));
					
					IF _ec.Status = ERR_OK THEN
						
						_wIdxToc := _PmIntern.TOC.wStartIdx[_PmIntern.ActContainer.siContainerID * (-1)] + _PmIntern.ActContainer.wIndexIndirect - _PmIntern.ActContainer.wMinBound;

						IF _wIdxToc >= 1 AND _wIdxToc <= MNPARAM_CNT_CSVFILES THEN
				
							_PmIntern.TOC.TocEntry[_wIdxToc].xExist := TRUE;
							_PmIntern.TOC.TocEntry[_wIdxToc].iContainerID := _PmIntern.ActContainer.siContainerID;
							IF _PmIntern.ActContainer.bDirect = 1 THEN
								_PmIntern.TOC.TocEntry[_wIdxToc].wInstance := 0;
							ELSE
								_PmIntern.TOC.TocEntry[_wIdxToc].wInstance := _PmIntern.ActContainer.wIndexIndirect;
							END_IF
							_PmIntern.TOC.TocEntry[_wIdxToc].dtTimestamp :=  _pDoContainerNum.Header.Time.dtTimestamp;
					
						END_IF
						
					ELSE
						
						_PmIntern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_PmIntern.Logger.text		:= 'Writing CSV for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
						_PmIntern.Logger.var1		:= _PmIntern.ActContainer.siContainerID;
						_PmIntern.Logger.var2		:= _ec.Status;
						_PmIntern.Logger();
	
					END_IF
						
				END_IF
							
				// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
				#ifdef SINGLEmnParam
				REPEAT
					UNTIL
					(_lSingleStep > _pl_InitState) AND (_lLoop >= _lLoopCount) OR NOT _xSingleStep
				END_REPEAT
				#endif
				
				//****************************************************************************************************************
				// Nächste Iteration
				//****************************************************************************************************************
		
				// Bei indirekter Parametrierung mit Instanzen, die nächste Instanz wählen
				IF _PmIntern.ActContainer.bDirect = 0 AND _PmIntern.ActContainer.wDimension > 0 THEN
//					_PmIntern.ActContainer.wIndexIndirect := _PmIntern.ActContainer.wIndexIndirect + 1;
					_wIndexIndirect := _wIndexIndirect + 1;
				END_IF
	
				_lLoopCount := _lLoopCount + 1;
				
				UNTIL
				// Direkte Parametrierung, Indirekte Parametrierung ohne Instanzen oder Indirekte Parametrierung und alle Instanzen abgearbeitet
//				_PmIntern.ActContainer.bDirect = 1 OR ( _PmIntern.ActContainer.bDirect = 0 AND _PmIntern.ActContainer.wIndexIndirect >= (_PmIntern.ActContainer.wMinBound + _PmIntern.ActContainer.wDimension)  )
				_PmIntern.ActContainer.bDirect = 1 OR ( _PmIntern.ActContainer.bDirect = 0 AND _wIndexIndirect >= (_PmIntern.ActContainer.wMinBound + _PmIntern.ActContainer.wDimension)  )
			END_REPEAT

		END_FOR	// _c - Über alle Container iterieren

		_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
		_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
					
		_ExportTableOfContent(Enable := TRUE, pIntern := ADR(_PmIntern));

		IF _ExportTableOfContent.Status = ERR_OK THEN
			
			mnParamStatAd.dtExportContent := _ExportTableOfContent.dtTocWritten;
	
		END_IF 
		
		//=========================================================================================
		//							ENDE DATENCONTAINER PRUEFEN UND EINLESEN
		//=========================================================================================

		IFmnParam.Out.Edit.wIdxContainerNamelist := MNPARAM_IDX_PROGCONTAINER;
		IFmnParam.Out.Edit.wParIdxNamelist := MNPARAM_PARIDX_PROGNAME;
		
		_actFillNamelist;
		
		// Initialisierung Fehlerfrei abgeschlossen
		_xInitOk := TRUE;

		UNTIL
		TRUE
	END_REPEAT	// Init-Block. Bei Fehlern wird der Block mit EXIT vorzeitig verlassen

	// Wenn SINGLEmnParam definiert ist, dann wartet die Ausführung hier solange, bis _lSingleStep > _pl_InitState gesetzt wurde
	#ifdef SINGLEmnParam
	REPEAT
		UNTIL
		_lSingleStep > _pl_InitState OR NOT _xSingleStep
	END_REPEAT
	#endif

	// Wenn alles fehlerfrei durchgelaufen ist, wird das OK gesetzt
	// Andernfalls Meldung und Log-Datei auswerten

	IF _xSysError THEN
		
		_PmIntern.Status.wMsgClass := 0;
		_PmIntern.Status.wMsgNumber := MNPARAM_MSG_SYSTEMERROR;
		_PmIntern.Status.wMsgAckLevel := 255;
		_PmIntern.Status.diMsgAttr1 := 0;
		_PmIntern.Status.sMsgAttrTxt := '';

	ELSE		
	

		//		// Aus Kompatibilitätsgründen
		//		IF PV_xgetadr(ADR('MachineState.xCfgOk'), ADR(_lAdrCfgOk), ADR(_lLenCfgOk)) = ERR_OK THEN
//
//			_xCfgOk ACCESS _lAdrCfgOk;
//			_xCfgOk := TRUE;
//
//		END_IF
		
		//****************************************************************************************************************
		// Ringbuffer for Logs
		//****************************************************************************************************************
	
		_kgRBcreatePMlog(sName := '_pmLogrb', bMemType := doTEMP, wCntEntry := 100, lLenEntry := SIZEOF(_LogEntry), wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

		IF _kgRBcreatePMlog.wStatus = ERR_OK THEN

			_wPtrRBloc := 0;

			_xRBReady := TRUE;

			_InsertRB.doIdent := _kgRBcreatePMlog.doIdent;
			_InsertRB.doLen := _kgRBcreatePMlog.doLen;
			_InsertRB.lLenEntry := SIZEOF(_LogEntry);
			_InsertRB.pEntry := ADR(_LogEntryIn);
		
			_ReadRB.doIdent := _kgRBcreatePMlog.doIdent;
			_ReadRB.doLen := _kgRBcreatePMlog.doLen;
			_ReadRB.lLenEntry := SIZEOF(_LogEntry);
			_ReadRB.pEntry := ADR(_LogEntry);

		ELSE
		
			_PmIntern.Logger.logLevel := arlogLEVEL_INFO;
			_PmIntern.Logger.text := 'Create Ringbuffer: {##AttrVar1}';
			_PmIntern.Logger.var1 := _kgRBcreatePMlog.wStatus;
			_PmIntern.Logger.var2 := 0;
			_PmIntern.Logger();		
		
		END_IF

	END_IF

END_PROGRAM

