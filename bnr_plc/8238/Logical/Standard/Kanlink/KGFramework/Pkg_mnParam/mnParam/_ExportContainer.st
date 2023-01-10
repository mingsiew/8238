(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _ExportContainer.st
 * Author: hunholz
 * Created: February 16, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Schreibe Containerdaten in eine CSV-Datei *)
FUNCTION_BLOCK _ExportContainer
	
	IF Enable THEN
		
		Status := ERR_OK;
		
		//=======================
		// Auf Nullpointer prüfen
		//=======================
		
		IF pIntern = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF
		
		_Intern ACCESS pIntern;
		
		IF _Intern.DataObjects.Adress.lContainer = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF

		_DoContainer ACCESS _Intern.DataObjects.Adress.lContainer;
		
		IF _Intern.DataObjects.Adress.lParamNum = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF

		_DoParamNum ACCESS _Intern.DataObjects.Adress.lParamNum;

		IF _Intern.DataObjects.Adress.lParamString = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF

		_DoParamString ACCESS _Intern.DataObjects.Adress.lParamString;

		IF _Intern.CSVDataObjects.Adress.lCSVNum = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF
		
		_DoNum ACCESS _Intern.CSVDataObjects.Adress.lCSVNum;

		IF _Intern.CSVDataObjects.Adress.lCSVString = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF
		
		_DoString ACCESS _Intern.CSVDataObjects.Adress.lCSVString;

		//===================
		// Eigentliche Aktion
		//===================
		
		_xReady := FALSE;
		_xBusy := FALSE;
		
		REPEAT
			
			CASE _ContainerExpState OF
				
				//=============================================
				// Speicher zum schreiben der Zeilen allokieren
				//=============================================
				ces_AllocMemCSV:
					
					_wIntStatus := 0;
					
					_MemPartAlloc(enable := TRUE, ident := _Intern.MemSettings.PartIdent , len := MNPARAM_TEMPWRITECSVSIZE);
					
					IF _MemPartAlloc.status = ERR_OK THEN
					
						_Intern.WriteCSV.lFileAdress := _MemPartAlloc.mem;
						_Intern.WriteCSV.lFileSize := 0;
					
						_ContainerExpState := ces_CreateCSV;
						
						_xFault := FALSE;
					
					ELSIF _MemPartAlloc.status <> ERR_FUB_BUSY THEN

						_wIntStatus := MNPARAM_STAT_EXPALLOCMEMCSV;
						_wIntAdStatus := _MemPartAlloc.status;
						
						_ContainerExpState := ces_Log;
						
						_Intern.Logger.logLevel := arlogLEVEL_INFO;
						_Intern.Logger.text		:= 'MemPartAlloc for Writing CSV File for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
						_Intern.Logger.var1		:= _Intern.ActContainer.siContainerID;
						_Intern.Logger.var2		:= _MemPartAlloc.status;
						
					ELSE
						
						_xBusy := TRUE;
					
					END_IF

				//=============================================
				// Zeilen schreiben
				//=============================================
				ces_CreateCSV:

					_WriteBOM(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);
				
					// Kopfdaten schreiben
					_WriteComment(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, sComment := _Intern.ExpSettings.sSoftwareComment , lSize := _Intern.WriteCSV.lFileSize);
					_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);
				
					_WriteVersion(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, VersionRow := _Intern.DataModelCsv.HeaderVersion, lSize := _Intern.WriteCSV.lFileSize);

					_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);

					_WriteMachineNo(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, MachineNoRow := _Intern.ExpSettings.HeaderMachineNo, lSize := _Intern.WriteCSV.lFileSize);

					_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);

					_WriteTimeStamp(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, TimeRow := _DoNum.Header.Time, lSize := _Intern.WriteCSV.lFileSize);

					_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);
				
					_WriteComment(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, sComment := 'Numeric Parameter:', lSize := _Intern.WriteCSV.lFileSize);
				
					_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);

					// Numerische Daten schreiben

					_wOldIdx := 65535;

					FOR _i := 1 TO UDINT_TO_UINT(_Intern.CSVDataObjects.MaxIndex.lCSVNum) DO
					
						IF _DoNum.CsvNum[_i].xChanged THEN

							IF _wOldIdx <> _DoNum.CsvNum[_i].wIdxNumPar THEN

								_wOldIdx := _DoNum.CsvNum[_i].wIdxNumPar;
							
								_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);
				
								_WriteComment(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, sComment := _DoParamNum.ParamNum[_wOldIdx].sAdresse, lSize := _Intern.WriteCSV.lFileSize);									
							
							END_IF
						
							IF _DoNum.CsvNum[_i].bRowType = 0 THEN
						
								_WriteNumPar(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, NumRow := _DoNum.CsvNum[_i], lSize := _Intern.WriteCSV.lFileSize);
	
							ELSE

								_WriteRealPar(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, NumRow := _DoNum.CsvNum[_i], lSize := _Intern.WriteCSV.lFileSize);
							
							END_IF
					
						END_IF
					
					END_FOR

					_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);

					_WriteComment(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, sComment := 'String Parameter:', lSize := _Intern.WriteCSV.lFileSize);
				
					_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);
				
					// String Daten schreiben

					_wOldIdx := 65535;

					FOR _i := 1 TO UDINT_TO_UINT(_Intern.CSVDataObjects.MaxIndex.lCSVString) DO
					
						IF _DoString.CsvString[_i].xChanged THEN

							IF _wOldIdx <> _DoString.CsvString[_i].wIdxStringPar THEN

								_wOldIdx := _DoString.CsvString[_i].wIdxStringPar;
							
								_WriteNewLine(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);
				
								_WriteComment(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, sComment := _DoParamString.ParamString[_wOldIdx].sAdresse, lSize := _Intern.WriteCSV.lFileSize);
							
							END_IF
						
							_WriteString(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, StringRow := _DoString.CsvString[_i], lSize := _Intern.WriteCSV.lFileSize);

						END_IF
					
					END_FOR
						
					_WriteFileEnd(enable := TRUE, pMem := _Intern.WriteCSV.lFileAdress, lMaxSize := MNPARAM_TEMPWRITECSVSIZE, lSize := _Intern.WriteCSV.lFileSize);

					_ContainerExpState := ces_DeleteFileCSV;
				
					_sPathAndFilename := CONCAT(_Intern.ExpSettings.sPath, _Intern.ExpSettings.sFilename);
				
				//==============================================
				// Möglicherweise vorhandene Exportdatei löschen
				//==============================================
				ces_DeleteFileCSV:
					
					_deleteCSVFile(enable := TRUE, pDevice := ADR(_Intern.ExpSettings.sCfDeviceName), pName := ADR(_sPathAndFilename));
				
					IF _deleteCSVFile.status <> ERR_FUB_BUSY THEN
					
						_ContainerExpState := ces_CreateFileCSV;
						
					ELSE
						
						_xBusy := TRUE;
					
					END_IF

				//==============================================
				// Exportdatei erzeugen
				//==============================================
				ces_CreateFileCSV:
					
					_createCSVFile(enable := TRUE, pDevice := ADR(_Intern.ExpSettings.sCfDeviceName), pFile := ADR(_sPathAndFilename) );

					IF _createCSVFile.status = ERR_OK THEN

						_ContainerExpState := ces_WriteFileCSV;
//						_ContainerExpState := ces_OpenFileCSV;
					
					ELSIF _createCSVFile.status <> ERR_FUB_BUSY THEN

						_wIntStatus := MNPARAM_STAT_CREATECSV;
						_wIntAdStatus := _createCSVFile.status;
						
						_ContainerExpState := ces_FreeMemCSV;
						
						_Intern.Logger.logLevel 	:= arlogLEVEL_INFO;
						_Intern.Logger.text		:= 'FileCreate for Writing CSV File for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
						_Intern.Logger.var1		:= _Intern.ActContainer.siContainerID;
						_Intern.Logger.var2		:= _createCSVFile.status;
						
						_xFault := TRUE;
						
					ELSE
						
						_xBusy := TRUE;
					
					END_IF

				//==============================================
				// Exportdatei öffnen
				//==============================================
				ces_OpenFileCSV:

					_openCSVFile(enable := TRUE, pDevice := ADR(_Intern.ExpSettings.sCfDeviceName), pFile := ADR(_sPathAndFilename), mode := fiWRITE_ONLY);

					IF _openCSVFile.status = ERR_OK THEN

						_ContainerExpState := ces_WriteFileCSV;
					
					ELSIF _openCSVFile.status <> ERR_FUB_BUSY THEN

						_wIntStatus := MNPARAM_STAT_OPENCSV;
						_wIntAdStatus := _openCSVFile.status;
						
						_ContainerExpState := ces_FreeMemCSV;
						
						_Intern.Logger.logLevel := arlogLEVEL_INFO;
						_Intern.Logger.text		:= 'FileOpen for Writing CSV File for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
						_Intern.Logger.var1		:= _Intern.ActContainer.siContainerID;
						_Intern.Logger.var2		:= _openCSVFile.status;
						
						_xFault := TRUE;
						
					ELSE
						
						_xBusy := TRUE;
					
					END_IF
					

				//==============================================
				// Exportdatei schreiben
				//==============================================
				ces_WriteFileCSV:

					_writeCSVFile(enable := TRUE, ident := _createCSVFile.ident, offset := 0, pSrc :=_Intern.WriteCSV.lFileAdress, len := _Intern.WriteCSV.lFileSize);
				
					IF _writeCSVFile.status = ERR_OK THEN
					
						_ContainerExpState := ces_CloseFileCSV;
					
						_DTGetTime(enable := TRUE);
						dtContainerWritten := _DTGetTime.DT1;
						
						_wIdxToc := _Intern.TOC.wStartIdx[_Intern.ActContainer.siContainerID * (-1)] + _Intern.ActContainer.wIndexIndirect - _Intern.ActContainer.wMinBound;

						IF _wIdxToc >= 1 AND _wIdxToc <= MNPARAM_CNT_CSVFILES THEN
							_Intern.TOC.TocEntry[_wIdxToc].dtTimestamp := _DoNum.Header.Time.dtTimestamp;
						END_IF
					
					ELSIF _writeCSVFile.status <> ERR_FUB_BUSY THEN

						_wIntStatus := MNPARAM_STAT_WRITECSV;
						_wIntAdStatus := _writeCSVFile.status;
						
						_ContainerExpState := ces_CloseFileCSV;
						
						_Intern.Logger.logLevel := arlogLEVEL_INFO;
						_Intern.Logger.text		:= 'FileWrite for Writing CSV File for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
						_Intern.Logger.var1		:= _Intern.ActContainer.siContainerID;
						_Intern.Logger.var2		:= _writeCSVFile.status;

						_xFault := TRUE;
						
					ELSE
						
						_xBusy := TRUE;
					
					END_IF				

				//==============================================
				// Exportdatei schließen
				//==============================================
				ces_CloseFileCSV:
					
					_closeCSVFile(enable := TRUE, ident := _createCSVFile.ident);

					IF _closeCSVFile.status = ERR_OK THEN
						
						_ContainerExpState := ces_FreeMemCSV;
						
					ELSIF _closeCSVFile.status <> ERR_FUB_BUSY THEN
						
						IF NOT _xFault THEN

							_wIntStatus := MNPARAM_STAT_CLOSECSV;
							_wIntAdStatus := _closeCSVFile.status;
							
							_Intern.Logger.logLevel := arlogLEVEL_INFO;
							_Intern.Logger.text		:= 'FileClose for Writing CSV File for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
							_Intern.Logger.var1		:= _Intern.ActContainer.siContainerID;
							_Intern.Logger.var2		:= _closeCSVFile.status;
							
						END_IF
						
						_xFault := TRUE;
					
						_ContainerExpState := ces_FreeMemCSV;
					
					ELSE	
						
						_xBusy := TRUE;
						
					END_IF

				//==============================================
				// Allokierten Speicher frei geben
				//==============================================
				ces_FreeMemCSV:

					_MemPartFree(enable := TRUE, ident  := _Intern.MemSettings.PartIdent, mem := _Intern.WriteCSV.lFileAdress);
				
					IF _MemPartFree.status = ERR_OK THEN
						
						_Intern.WriteCSV.lFileAdress := 0;
						_Intern.WriteCSV.lFileSize := 0;

						IF _xFault THEN
							
							Status := _wIntStatus;
							AdStatus := _wIntAdStatus;

							_ContainerExpState := ces_Log;
							
						ELSE
							
							Status := ERR_OK;
							AdStatus := 0;

							_xReady := TRUE;
							
							_ContainerExpState := ces_AllocMemCSV;

						END_IF

					ELSIF _MemPartFree.status <> ERR_FUB_BUSY THEN
					
						_Intern.WriteCSV.lFileAdress := 0;
						_Intern.WriteCSV.lFileSize := 0;
					
						IF _xFault THEN
							
							Status := _wIntStatus;
							AdStatus := _wIntAdStatus;
							
						ELSE
							
							Status := MNPARAM_STAT_EXPFREEMEM;
							AdStatus := _MemPartFree.status;

							_Intern.Logger.logLevel := arlogLEVEL_INFO;
							_Intern.Logger.text		:= 'FreeMem for Writing CSV File for Container Index: {##AttrVar1}. Status : {##AttrVar2}';
							_Intern.Logger.var1		:= _Intern.ActContainer.siContainerID;
							_Intern.Logger.var2		:= _MemPartFree.status;

						END_IF

						_ContainerExpState := ces_Log;
						
					ELSE	
						
						_xBusy := TRUE;

					END_IF		
					
				//==============
				// Fehler loggen
				//==============
				ces_Log:
				
					_Intern.Logger();

					IF _Intern.Logger.status <> ERR_FUB_BUSY THEN
						
						Status := _wIntStatus;
						AdStatus := _wIntAdStatus;
						
						_ContainerExpState := ces_AllocMemCSV;
						
						_xReady := TRUE;
						
					ELSE
						
						_xBusy := TRUE;
						
					END_IF
					
			END_CASE
			
			UNTIL
			
			_xBusy OR _xReady
			
		END_REPEAT
		
		IF _xBusy THEN
			Status := ERR_FUB_BUSY;
		END_IF
		
	ELSE
		
		_ContainerExpState := ces_AllocMemCSV;
		
		Status := ERR_FUB_ENABLE_FALSE;
		AdStatus := 0;
		
	END_IF
	
	
END_FUNCTION_BLOCK