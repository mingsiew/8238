(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: mnParam
 * File: mnParamCyclic.st
 * Author: hunholz
 * Created: July 23, 2011
 * Changed: November 18, 2011
	##AH20111118
		- Fehlermeldung, wenn Maschinennummer in der Importdatei fehlt
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************)

PROGRAM _CYCLIC

	IF _xParamOK THEN

		#ifdef SINGLEmnParam
		IF NOT _xRun THEN
		
			RETURN;
		
		END_IF
		#endif
		//***********************************************
		// Parametermanager ist erfolgreich initialisiert
		//***********************************************
		
		//*********************************
		// Befehle dürfen angenommen werden
		//*********************************

		_xAllowCommands := _PmIntern.enCycIfState = cs_IfIdle AND _PmIntern.enCycMainState = cs_MainIdle;

		IF _xAllowCommands THEN

			//************************************************
			// Reset von Ausgängen, wenn kein Befehl aktiv ist
			//************************************************

			mnParamStatAd.wCntFilesImportFailed := 0;
			mnParamStatAd.wCntFilesImportOK := 0;
			mnParamStatAd.wCntFilesImportFound := 0;

			IFmnParam.Out.Edit.wCntFilesImportFailed := 0;
			IFmnParam.Out.Edit.wCntFilesImportOK := 0;
			IFmnParam.Out.Edit.wCntFilesImportFound := 0;

		END_IF

		
		
		//******************************************
		// Statemachine Kommandoschnittstelle zum PC
		//******************************************

		_actInterfacePC;

		//***************************************************
		// Statemachine Kommandoschnittstelle zur Applikation
		//***************************************************

		_actInterfaceApplication;
		
		//*********************************************************************************************
		// Statemachine zum Backup der Daten
		//*********************************************************************************************

		CASE _PmIntern.enCycBackup OF
			
			cs_BacIdle:
				
			// Tue nichts, setze ggf. Werte auf Default

			cs_BacUSBlinkDevice:
			
				_sDevString := CONCAT('/DEVICE=',_sUSBInterface);
				_DevLink(enable := TRUE, pDevice := ADR(_MNPARAM_TEMP_USBDEV), pParam := ADR(_sDevString));
			
				IF _DevLink.status = ERR_OK THEN

					_GetBackupTime(enable := TRUE);
					_BackupTimestamp(dtTimestamp := _GetBackupTime.DT1);
					_PmIntern.sActPath := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
					
					_PmIntern.enCycBackup := cs_BacCreateDirMachine;
					
					_lDevLinkHandle := _DevLink.handle;
					
				ELSIF _DevLink.status <> ERR_FUB_BUSY THEN
					
					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_BACKUP;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_LINKUSB;
					_PmIntern.Status.diMsgAttr2 := _DevLink.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycBackup := cs_BacRdyFault;

				END_IF

			cs_BacCreateDirMachine:
			
				_DirCreate(enable := TRUE, pDevice := ADR(_MNPARAM_TEMP_USBDEV), pName := ADR(_PmIntern.sActPath));
				
				IF _DirCreate.status <> ERR_FUB_BUSY THEN
					
					IF _DirCreate.status = ERR_OK OR _DirCreate.status = fiERR_DIR_ALREADY_EXIST THEN

						brsstrcat(ADR(_PmIntern.sActPath), ADR('\Backup\'));
						_PmIntern.enCycBackup := cs_BacCreateDirBackup;

					ELSE

						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_BACKUP;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CREATEDIR;
						_PmIntern.Status.diMsgAttr2 := _DirCreate.status;
						_PmIntern.Status.wMsgAckLevel := 0;
						
						_PmIntern.enCycBackup := cs_BacUSBunlinkDevice;
						
					END_IF
					
				END_IF
			
			cs_BacCreateDirBackup:

				_DirCreate(enable := TRUE, pDevice := ADR(_MNPARAM_TEMP_USBDEV), pName := ADR(_PmIntern.sActPath));
				
				IF _DirCreate.status <> ERR_FUB_BUSY THEN
					
					IF _DirCreate.status = ERR_OK OR _DirCreate.status = fiERR_DIR_ALREADY_EXIST THEN

						brsstrcat(ADR(_PmIntern.sActPath), ADR(_BackupTimestamp.sDate));
						brsstrcat(ADR(_PmIntern.sActPath), ADR('\'));
						_PmIntern.enCycBackup := cs_BacCreateDirDate;

					ELSE

						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_BACKUP;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CREATEDIR;
						_PmIntern.Status.diMsgAttr2 := _DirCreate.status;
						_PmIntern.Status.wMsgAckLevel := 0;
						
						_PmIntern.enCycBackup := cs_BacUSBunlinkDevice;
						
					END_IF
					
				END_IF

			cs_BacCreateDirDate:
				
				_DirCreate(enable := TRUE, pDevice := ADR(_MNPARAM_TEMP_USBDEV), pName := ADR(_PmIntern.sActPath));
				
				IF _DirCreate.status <> ERR_FUB_BUSY THEN
					
					IF _DirCreate.status = ERR_OK OR _DirCreate.status = fiERR_DIR_ALREADY_EXIST THEN

						_PmIntern.enCycBackup := cs_BacCopy;

					ELSE

						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_BACKUP;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CREATEDIR;
						_PmIntern.Status.diMsgAttr2 := _DirCreate.status;
						_PmIntern.Status.wMsgAckLevel := 0;
						
						_PmIntern.enCycBackup := cs_BacUSBunlinkDevice;
						
					END_IF
					
				END_IF

			cs_BacCopy:
			
				_DirCopy(enable := TRUE, pSrcDev := ADR(KG_DEVICE_COMPACTFLASH), pSrcDir := ADR('PM\Export\'), pDestDev := ADR(_MNPARAM_TEMP_USBDEV), pDestDir := ADR(_PmIntern.sActPath), option := fiOVERWRITE);

				IF _DirCopy.status <> ERR_FUB_BUSY THEN
					
					IF _DirCopy.status <> ERR_OK THEN

						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_BACKUP;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_COPY;
						_PmIntern.Status.diMsgAttr2 := _DirCopy.status;
						_PmIntern.Status.wMsgAckLevel := 0;
						
					END_IF

					_PmIntern.enCycBackup := cs_BacUSBunlinkDevice;

				END_IF

			
			cs_BacUSBunlinkDevice:

				_DevUnlink(enable := TRUE, handle := _lDevLinkHandle);
				
				IF _DevUnlink.status <> ERR_FUB_BUSY THEN
					
					IF _PmIntern.Status.wMsgNumber <> 0 THEN
						
						IF _PmIntern.Status.diMsgAttr1 = 0 THEN
							_PmIntern.Status.diMsgAttr1 := 59999;
						END_IF
						
						_PmIntern.enCycBackup := cs_BacRdyFault;
						
					ELSE
						
						_PmIntern.enCycBackup := cs_BacRdySuccess;

					END_IF
					
				END_IF

			cs_BacRdyFault:

			// Mit Fehler beendet
				
			cs_BacRdySuccess:
			
				// Mit Erfolg beendet
				
		END_CASE

		//*********************************************************************************************
		// Statemachine zum Erzeugen einer neuen Containerinstanz
		//*********************************************************************************************
		
		CASE _PmIntern.enCycCreate OF
			
			cs_CrtIdle:
				
			// Tue nichts, setze ggf. Werte auf Default
				
			cs_CrtStart:
				
				_DefineActContainer(Enable := TRUE, bContainerIdx := UINT_TO_USINT(_wCreateCont), wInstanceIdx := _wCreateInst, pIntern := ADR(_PmIntern));
	
				IF _DefineActContainer.Status = ERR_OK THEN
	
					// Container Parameter sind im gültigen Bereich und die Containerspec. ist ok
						
					IF NOT(_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCreateCont] + (_wCreateInst - _PmIntern.ActContainer.wMinBound)].xExist) AND _PmIntern.ActContainer.bDirect = 0 THEN
							
						// Die Containerinstanz existiert noch nicht
						// Defaultcontainer identifizieren
							
						_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefNum));
					
						IF _diCSVNum.status = ERR_OK THEN
								
							// Datenobjekt mit Default numerischen Parametern wurde gefunden
		
							_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;

							_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefString));
						
							IF _diCSVString.status = ERR_OK THEN
							
								// Datenobjekt mit Default String Parametern wurde gefunden
			
								_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;

								_diDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDef));
						
								IF _diDO.status = ERR_OK THEN
							
									_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDO.ident;
									
									_DTGetTime(enable := TRUE);
				
									_PmIntern.enCycCreate := cs_CrtCpyNumDef;
							
								ELSIF _diDO.status <> ERR_FUB_BUSY THEN
		
									_PmIntern.Status.wMsgClass := 10;
									_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
									_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
									_PmIntern.Status.diMsgAttr2 := 0;
									brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt),ADR(_PmIntern.ActContainer.sDoName));
									_PmIntern.Status.wMsgAckLevel := 0;
					
									_PmIntern.enCycCreate := cs_CrtRdyFault;
					
								END_IF
										
							ELSE 
		
								_PmIntern.Status.wMsgClass := 10;
								_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
								_PmIntern.Status.diMsgAttr2 := 0;
								_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameString;
								_PmIntern.Status.wMsgAckLevel := 0;
							
								_PmIntern.enCycCreate := cs_CrtRdyFault;
						
							END_IF
								
						ELSE

							_PmIntern.Status.wMsgClass := 10;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
							_PmIntern.Status.diMsgAttr2 := 0;
							_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameNum;
							_PmIntern.Status.wMsgAckLevel := 0;
						
							_PmIntern.enCycCreate := cs_CrtRdyFault;

						END_IF
								
					ELSE
	
						// Zielcontainer existiert bereits, oder Instanzen dürfen garnicht erzeugt werden
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
						_PmIntern.Status.diMsgAttr2 := 0;
						_PmIntern.Status.wMsgAckLevel := 0;
	
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CONTINST_EXIST;
							
						_PmIntern.enCycCreate := cs_CrtRdyFault;
							
					END_IF
	
				ELSE
	
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _DefineActContainer.Status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
	
					_PmIntern.enCycCreate := cs_CrtRdyFault;
	
				END_IF

			cs_CrtCpyNumDef:
			
				_dcpCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameNum), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpCSVNum.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVNum := _dcpCSVNum.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
					_PmIntern.CSVDataObjects.Idents.lCSVNum := _dcpCSVNum.identNew;
					
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
					
					_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );

					_dwCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := ADR(_pDoContainerNum.Header.Time.dtTimestamp) - ADR(_pDoContainerNum),pSource := ADR(_DTGetTime.DT1),len := SIZEOF(_DTGetTime.DT1));
					
					_PmIntern.enCycCreate := cs_CrtCpyStringDef;
					
				ELSIF _dcpCSVNum.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _dcpCSVNum.status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCreate := cs_CrtRdyFault;
					
				END_IF

			cs_CrtCpyStringDef:
			
				_dcpCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameString), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpCSVString.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVString := _dcpCSVString.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
					_PmIntern.CSVDataObjects.Idents.lCSVString := _dcpCSVString.identNew;
					
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
					
					_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );

					_dwCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := ADR(_pDoContainerString.Header.Time.dtTimestamp) - ADR(_pDoContainerString),pSource := ADR(_DTGetTime.DT1),len := SIZEOF(_DTGetTime.DT1));

					_PmIntern.enCycCreate := cs_CrtCpyBinDef;
					
				ELSIF _dcpCSVString.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _dcpCSVString.status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCreate := cs_CrtRdyFault;
					
				END_IF

			cs_CrtCpyBinDef:
			
				_dcpDefaultDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, pNameTarget := ADR(_PmIntern.ActContainer.sDoName), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpDefaultDO.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lDataObjekt := _dcpDefaultDO.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDefaultDO.len;
					_PmIntern.CSVDataObjects.Idents.lDataObjekt := _dcpDefaultDO.identNew;

					_PmIntern.enCycCreate := cs_CrtExpCSV;
					
				ELSIF _dcpDefaultDO.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _dcpDefaultDO.status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCreate := cs_CrtRdyFault;
					
				END_IF
			
			cs_CrtExpCSV:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				_PmIntern.ExpSettings.sFilename := _PmIntern.ActContainer.sCsvName;
				
				_ec(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ec.Status = ERR_OK THEN
					
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCreateCont] + (_wCreateInst - _PmIntern.ActContainer.wMinBound)].xExist := TRUE;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCreateCont] + (_wCreateInst - _PmIntern.ActContainer.wMinBound)].dtTimestamp := _DTGetTime.DT1;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCreateCont] + (_wCreateInst - _PmIntern.ActContainer.wMinBound)].iContainerID := _PmIntern.ActContainer.siContainerID;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCreateCont] + (_wCreateInst - _PmIntern.ActContainer.wMinBound)].wInstance := _PmIntern.ActContainer.wIndexIndirect;

					_PmIntern.enCycCreate := cs_CrtTOC;
					
				ELSIF _ec.Status <> ERR_FUB_BUSY THEN
					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _ec.Status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCreate := cs_CrtRdyFault;

				END_IF
			
			cs_CrtTOC:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				
				_ExportTableOfContent(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ExportTableOfContent.Status = ERR_OK THEN
					
					mnParamStatAd.dtExportContent := _ExportTableOfContent.dtTocWritten;

					_PmIntern.enCycCreate := cs_CrtRdySuccess;

				ELSIF _ExportTableOfContent.Status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _ExportTableOfContent.Status;
					_PmIntern.Status.diMsgAttr2 := _ExportTableOfContent.AdStatus;
					_PmIntern.Status.wMsgAckLevel := 0;
	
					_PmIntern.enCycCreate := cs_CrtRdyFault;

				END_IF
			
			cs_CrtRdyFault:

				// Mit Fehler beendet
				
			cs_CrtRdySuccess:
			
				// Mit Erfolg beendet

		END_CASE
	
		//*********************************************************************************************
		// Statemachine zum Loeschen von Datenobjekten mit indirekter Parametrierung
		//*********************************************************************************************
		
		CASE _PmIntern.enCycDelState OF
			
			cs_DelIdle:
			
			// Tue nichts, setze ggf. Werte auf Default
				
			cs_DelStart:
			
				// Pruefe, ob die Parameter gueltig sind
				
				IF _wDelCont <= MNPARAM_MAXIDX_CONTAINER THEN
					
					IF _pDoContainer.Container[_wDelCont].bDirectParam = 0 AND _pDoContainer.Container[_wDelCont].wDimension > 0 THEN
						
						IF _wDelInst >= _pDoContainer.Container[_wDelCont].wMinBound AND _wDelInst <= (_pDoContainer.Container[_wDelCont].wMinBound + _pDoContainer.Container[_wDelCont].wDimension - 1) THEN

							_c := _wDelCont;

							_PmIntern.ActContainer.siContainerID := _pDoContainer.Container[_c].siContainerID;
							_PmIntern.ActContainer.bDirect := _pDoContainer.Container[_c].bDirectParam;
							_PmIntern.ActContainer.wMinBound := _pDoContainer.Container[_c].wMinBound;
							_PmIntern.ActContainer.wDimension := _pDoContainer.Container[_c].wDimension;
							_PmIntern.ActContainer.wIndexIndirect := UDINT_TO_UINT(_wDelInst);

							brsmemset(ADR(_PmIntern.CSVDataObjects), 0, SIZEOF(_PmIntern.CSVDataObjects));

							IF (brsstrcmp(ADR(_pDoContainer.Container[_c].sNameDataObj), ADR('')) = 0) OR (brsstrcmp(ADR(_pDoContainer.Container[_c].sNameCsv), ADR('')) = 0) THEN
							// Container wird nicht bearbeitet, wenn einer der Namen LEER ist

								// Fehler
								_PmIntern.Status.wMsgClass := 10;
								_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELDEFFAULT;
								_PmIntern.Status.wMsgAckLevel := 0;
							
								_PmIntern.enCycDelState := cs_DelRdyFault;

							ELSIF (PV_xgetadr(ADR(_pDoContainer.Container[_c].sStrucRoot), ADR(_lPVadress), ADR(_lPVlen)) <> ERR_OK) THEN
							// Container wird nicht bearbeitet, wenn die Parametrierung indirekt ist und der StructRoot nicht existiert

								// Fehler
								_PmIntern.Status.wMsgClass := 10;
								_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELDEFFAULT;
								_PmIntern.Status.wMsgAckLevel := 0;
							
								_PmIntern.enCycDelState := cs_DelRdyFault;

							ELSE
					
								_PmIntern.ActContainer.lAdressStructRoot := _lPVadress;
								_PmIntern.ActContainer.lSizeStructRoot := _lPVlen;
								
								_wDimension := MAX(1, _PmIntern.ActContainer.wDimension);
					
								// Es gibt mehrere Instanzen von Datencontainern
								_PmIntern.ActContainer.sIndex := '';
								IF (_PmIntern.ActContainer.wMinBound + _wDimension - 1) > 99 AND  _PmIntern.ActContainer.wIndexIndirect  < 100 THEN
									brsstrcat(ADR(_PmIntern.ActContainer.sIndex), ADR('0'));
								END_IF
								IF (_PmIntern.ActContainer.wMinBound + _wDimension - 1) > 9 AND  _PmIntern.ActContainer.wIndexIndirect  < 10 THEN
									brsstrcat(ADR(_PmIntern.ActContainer.sIndex), ADR('0'));
								END_IF
								brsitoa(_PmIntern.ActContainer.wIndexIndirect,ADR(_sIndex));
								brsstrcat(ADR(_PmIntern.ActContainer.sIndex), ADR(_sIndex));
					
								brsstrcpy(ADR(_PmIntern.ActContainer.sDoName), ADR(_pDoContainer.Container[_c].sNameDataObj));
								brsstrcpy(ADR(_PmIntern.ActContainer.sDoNameDef), ADR(_PmIntern.ActContainer.sDoName));
								brsstrcat(ADR(_PmIntern.ActContainer.sDoName), ADR(_PmIntern.ActContainer.sIndex));
					
								brsstrcpy(ADR(_PmIntern.ActContainer.sDoNameNum), ADR(_pDoContainer.Container[_c].sNameDataObj));
								brsstrcpy(ADR(_PmIntern.ActContainer.sDoNameDefNum), ADR(_PmIntern.ActContainer.sDoNameNum));
								brsstrcat(ADR(_PmIntern.ActContainer.sDoNameNum), ADR(_PmIntern.ActContainer.sIndex));
								brsstrcat(ADR(_PmIntern.ActContainer.sDoNameNum), ADR('N'));
					
								brsstrcpy(ADR(_PmIntern.ActContainer.sDoNameString), ADR(_pDoContainer.Container[_c].sNameDataObj));
								brsstrcpy(ADR(_PmIntern.ActContainer.sDoNameDefString), ADR(_PmIntern.ActContainer.sDoNameString));
								brsstrcat(ADR(_PmIntern.ActContainer.sDoNameString), ADR(_PmIntern.ActContainer.sIndex));
								brsstrcat(ADR(_PmIntern.ActContainer.sDoNameString), ADR('S'));
					
								brsstrcpy(ADR(_PmIntern.ActContainer.sCsvName), ADR(_pDoContainer.Container[_c].sNameCsv));
								brsstrcat(ADR(_PmIntern.ActContainer.sCsvName), ADR(_PmIntern.ActContainer.sIndex));
								_PmIntern.ActContainer.sCsvName := CONCAT(_PmIntern.ActContainer.sCsvName, MNPARAM_FILESUFF);
					
								brsstrcpy(ADR(_PmIntern.ActContainer.sStrucRoot), ADR(_pDoContainer.Container[_c].sStrucRoot));

								_PmIntern.enCycDelState := cs_DelDInumPar;
													
							END_IF
							
						ELSE
							
							// Fehler
							_PmIntern.Status.wMsgClass := 10;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_WRONGIDX;
							_PmIntern.Status.wMsgAckLevel := 0;
							
							_PmIntern.enCycDelState := cs_DelRdyFault;
							
						END_IF
					
					ELSE
						
						// Fehler
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELDEFFAULT;
						_PmIntern.Status.wMsgAckLevel := 0;
						
						_PmIntern.enCycDelState := cs_DelRdyFault;
						
					END_IF
					
				ELSE
					
					// Fehler
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELPARFAULT;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycDelState := cs_DelRdyFault;
					
				END_IF
				
			cs_DelDInumPar:
			
				_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameNum));

				IF _diCSVNum.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;
					_PmIntern.CSVDataObjects.Adress.lCSVNum := _diCSVNum.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
					
					IF _diCSVNum.len >= SIZEOF(mnParam_CsvDynHeader_typ) THEN
				
						_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
						
						IF _pDoContainerNum.Header.Container.xWriteProtected THEN
							
							// Fehler
							_PmIntern.Status.wMsgClass := 10;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_WRITEPROTECTED;
							_PmIntern.Status.diMsgAttr2 := 0;		// Laengenfehler
							_PmIntern.Status.wMsgAckLevel := 0;
					
							_PmIntern.enCycDelState := cs_DelExpToc;

						ELSE
							
							_PmIntern.enCycDelState := cs_DelDIstringPar;
							
						END_IF
						
					ELSE

						// Fehler
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_NUMPARNOTFOUND;
						_PmIntern.Status.diMsgAttr2 := 0;		// Laengenfehler
						_PmIntern.Status.wMsgAckLevel := 0;
					
						_PmIntern.enCycDelState := cs_DelExpToc;
						
					END_IF
				
				ELSIF _diCSVNum.status = doERR_ILLOBJECT THEN

					_PmIntern.enCycDelState := cs_DelDIstringPar;
					
				ELSIF _diCSVNum.status <> ERR_FUB_BUSY THEN
					
					// Fehler
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_NUMPARNOTFOUND;
					_PmIntern.Status.diMsgAttr2 := _diCSVNum.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycDelState := cs_DelExpToc;

				END_IF

			cs_DelDIstringPar:				

				_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));

				IF _diCSVString.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
					_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
							
					_PmIntern.enCycDelState := cs_DelDIbinaerPar;
							
				ELSIF _diCSVString.status = doERR_ILLOBJECT THEN

					_PmIntern.enCycDelState := cs_DelDIbinaerPar;

				ELSIF _diCSVString.status <> ERR_FUB_BUSY THEN
					
					// Fehler
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_STRPARNOTFOUND;
					_PmIntern.Status.diMsgAttr2 := _diCSVString.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycDelState := cs_DelExpToc;

				END_IF

			cs_DelDIbinaerPar:
			
				_diDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoName));

				IF _diDO.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDO.ident;
					_PmIntern.CSVDataObjects.Adress.lDataObjekt := _diDO.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDO.len;
							
					_PmIntern.enCycDelState := cs_DelDDnumPar;
							
				ELSIF _diDO.status = doERR_ILLOBJECT THEN

					_PmIntern.enCycDelState := cs_DelDDnumPar;

				ELSIF _diDO.status <> ERR_FUB_BUSY THEN
					
					// Fehler
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_BINPARNOTFOUN;
					_PmIntern.Status.diMsgAttr2 := _diDO.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycDelState := cs_DelExpToc;

				END_IF
			
			cs_DelDDnumPar:
			
				IF _PmIntern.CSVDataObjects.Idents.lCSVNum > 0 THEN
					
					_ddCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum);
					
					IF _ddCSVNum.status = ERR_OK THEN
						
						_PmIntern.CSVDataObjects.Idents.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Size.lCSVNum := 0;

						_PmIntern.enCycDelState := cs_DelDDstringPar;
						
					ELSIF _ddCSVNum.status <> ERR_FUB_BUSY THEN

						_PmIntern.CSVDataObjects.Idents.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVNum := 0;
						_PmIntern.CSVDataObjects.Size.lCSVNum := 0;

						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELNUMPAR;
						_PmIntern.Status.diMsgAttr2 := _ddCSVNum.status;
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycDelState := cs_DelDDstringPar;
						
					END_IF
					
				ELSE
					
					_PmIntern.enCycDelState := cs_DelDDstringPar;
					
				END_IF
				
			cs_DelDDstringPar:

				IF _PmIntern.CSVDataObjects.Idents.lCSVString > 0 THEN
					
					_ddCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString);
					
					IF _ddCSVString.status = ERR_OK THEN
						
						_PmIntern.CSVDataObjects.Idents.lCSVString := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVString := 0;
						_PmIntern.CSVDataObjects.Size.lCSVString := 0;

						_PmIntern.enCycDelState := cs_DelDDbinaerPar;
						
					ELSIF _ddCSVString.status <> ERR_FUB_BUSY THEN

						_PmIntern.CSVDataObjects.Idents.lCSVString := 0;
						_PmIntern.CSVDataObjects.Adress.lCSVString := 0;
						_PmIntern.CSVDataObjects.Size.lCSVString := 0;

						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELSTRPAR;
						_PmIntern.Status.diMsgAttr2 := _ddCSVString.status;
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycDelState := cs_DelDDbinaerPar;
						
					END_IF
					
				ELSE
					
					_PmIntern.enCycDelState := cs_DelDDbinaerPar;
					
				END_IF

			cs_DelDDbinaerPar:

				IF _PmIntern.CSVDataObjects.Idents.lDataObjekt > 0 THEN
					
					_ddDataObjekt(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt);
					
					IF _ddDataObjekt.status = ERR_OK THEN
						
						_PmIntern.CSVDataObjects.Idents.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Adress.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Size.lDataObjekt := 0;

						_PmIntern.enCycDelState := cs_DelDelFile;
						
					ELSIF _ddDataObjekt.status <> ERR_FUB_BUSY THEN

						_PmIntern.CSVDataObjects.Idents.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Adress.lDataObjekt := 0;
						_PmIntern.CSVDataObjects.Size.lDataObjekt := 0;

						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELBINPAR;
						_PmIntern.Status.diMsgAttr2 := _ddDataObjekt.status;
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycDelState := cs_DelDelFile;
						
					END_IF
					
				ELSE
					
					_PmIntern.enCycDelState := cs_DelDelFile;
					
				END_IF
				
			cs_DelDelFile:
			
				_PmIntern.sActPathAndFilename := MNPARAM_PATH_EXPORT;
				brsstrcat(ADR(_PmIntern.sActPathAndFilename), ADR(_PmIntern.ActContainer.sCsvName));

				_FileDelete(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_PmIntern.sActPathAndFilename));
				
				IF _FileDelete.status = ERR_OK THEN

					_PmIntern.enCycDelState := cs_DelExpToc;
					
					_wIdxToc := _PmIntern.TOC.wStartIdx[_PmIntern.ActContainer.siContainerID * (-1)] + _PmIntern.ActContainer.wIndexIndirect - _PmIntern.ActContainer.wMinBound;

					IF _wIdxToc >= 1 AND _wIdxToc <= MNPARAM_CNT_CSVFILES THEN
				
						brsmemset(ADR(_PmIntern.TOC.TocEntry[_wIdxToc]), 0, SIZEOF(_PmIntern.TOC.TocEntry[1]));
					
					END_IF

				ELSIF _FileDelete.status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_DELETE;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DELFILE;
					_PmIntern.Status.diMsgAttr2 := _FileDelete.status;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycDelState := cs_DelExpToc;
					
				END_IF

			cs_DelExpToc:

				IF _PmIntern.Status.wMsgNumber = 0 THEN
					
					_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
					_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				
					_ExportTableOfContent(Enable := TRUE, pIntern := ADR(_PmIntern));
			
					IF _ExportTableOfContent.Status = ERR_OK THEN
					
						mnParamStatAd.dtExportContent := _ExportTableOfContent.dtTocWritten;
						
						_PmIntern.enCycDelState := cs_DelRdySuccess;

					ELSIF _ExportTableOfContent.Status <> ERR_FUB_BUSY THEN
						
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
						_PmIntern.Status.diMsgAttr1 := _ExportTableOfContent.Status;
						_PmIntern.Status.diMsgAttr2 := _ExportTableOfContent.AdStatus;
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycDelState := cs_DelRdyFault;
						
					END_IF
					
				ELSE

					_PmIntern.enCycDelState := cs_DelRdyFault;

				END_IF
			
			cs_DelRdyFault:

				// Mit Fehler beendet
				
			cs_DelRdySuccess:
			
				// Mit Erfolg beendet	
			
		END_CASE

		
		//*********************************************************************************************
		// Statemachine zum Kopieren einer Containerinstanz
		//*********************************************************************************************
		
		CASE _PmIntern.enCycCopy OF
			
			cs_CpyIdle:
				
			// Tue nichts, setze ggf. Werte auf Default
				
			cs_CpyStart:
				
				_DefineActContainer(Enable := TRUE, bContainerIdx := UINT_TO_USINT(_wCopyCont), wInstanceIdx := _wCopyInstFrom, pIntern := ADR(_PmIntern));
	
				IF _DefineActContainer.Status = ERR_OK THEN
	
					// Container Parameter sind im gültigen Bereich und die Containerspec. ist ok
						
					IF _PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCopyCont] + (_wCopyInstFrom - _PmIntern.ActContainer.wMinBound)].xExist AND _PmIntern.ActContainer.bDirect = 0 THEN
							
						// Die Containerinstanz existiert
						// Container identifizieren
							
						_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameNum));
					
						IF _diCSVNum.status = ERR_OK THEN
								
							// Datenobjekt mit numerischen Parametern wurde gefunden
		
							_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;

							_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));
						
							IF _diCSVString.status = ERR_OK THEN
							
								// Datenobjekt mit String Parametern wurde gefunden
			
								_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;

								_diDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoName));
						
								IF _diDO.status = ERR_OK THEN
							
									_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDO.ident;
									
									_DTGetTime(enable := TRUE);
				
									_PmIntern.enCycCopy := cs_CpyChckTarget;
							
								ELSIF _diDO.status <> ERR_FUB_BUSY THEN
		
									_PmIntern.Status.wMsgClass := 10;
									_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
									_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
									_PmIntern.Status.diMsgAttr2 := 0;
									brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt),ADR(_PmIntern.ActContainer.sDoName));
									_PmIntern.Status.wMsgAckLevel := 0;
					
									_PmIntern.enCycCopy := cs_CpyRdyFault;
					
								END_IF
										
							ELSE 
		
								_PmIntern.Status.wMsgClass := 10;
								_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
								_PmIntern.Status.diMsgAttr2 := 0;
								_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameString;
								_PmIntern.Status.wMsgAckLevel := 0;
							
								_PmIntern.enCycCopy := cs_CpyRdyFault;
						
							END_IF
								
						ELSE

							_PmIntern.Status.wMsgClass := 10;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
							_PmIntern.Status.diMsgAttr2 := 0;
							_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameNum;
							_PmIntern.Status.wMsgAckLevel := 0;
						
							_PmIntern.enCycCopy := cs_CpyRdyFault;

						END_IF
								
					ELSE
	
						// Quellcontainer existiert nicht oder Instanzen dürfen garnicht erzeugt werden
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
						_PmIntern.Status.diMsgAttr2 := 0;
						_PmIntern.Status.wMsgAckLevel := 0;
	
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CONTINST_NOT_EXIST;
							
						_PmIntern.enCycCopy := cs_CpyRdyFault;
							
					END_IF
	
				ELSE
	
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
					_PmIntern.Status.diMsgAttr1 := _DefineActContainer.Status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
	
					_PmIntern.enCycCopy := cs_CpyRdyFault;
	
				END_IF

			cs_CpyChckTarget:
			
				_DefineActContainer(Enable := TRUE, bContainerIdx := UINT_TO_USINT(_wCopyCont), wInstanceIdx := _wCopyInst, pIntern := ADR(_PmIntern));
	
				IF _DefineActContainer.Status = ERR_OK THEN
	
					// Container Parameter sind im gültigen Bereich und die Containerspec. ist ok
						
					IF NOT(_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCopyCont] + (_wCopyInst - _PmIntern.ActContainer.wMinBound)].xExist) THEN
						
						_PmIntern.enCycCopy := cs_CpyCpyNum;
						
					ELSE

						// Zielcontainer existiert bereits
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
						_PmIntern.Status.diMsgAttr2 := 0;
						_PmIntern.Status.wMsgAckLevel := 0;
	
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CONTINST_EXIST;
							
						_PmIntern.enCycCopy := cs_CpyRdyFault;
						
					END_IF
					
				ELSE
			
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
					_PmIntern.Status.diMsgAttr1 := _DefineActContainer.Status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
	
					_PmIntern.enCycCopy := cs_CpyRdyFault;

				END_IF

			cs_CpyCpyNum:
			
				_dcpCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameNum), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpCSVNum.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVNum := _dcpCSVNum.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
					_PmIntern.CSVDataObjects.Idents.lCSVNum := _dcpCSVNum.identNew;
					
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
					
					_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );

					_dwCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := ADR(_pDoContainerNum.Header.Time.dtTimestamp) - ADR(_pDoContainerNum),pSource := ADR(_DTGetTime.DT1),len := SIZEOF(_DTGetTime.DT1));

					//###Hu Bug835 - Schreibschutz aufheben
					_xNoWriteProtect := FALSE;
					_dwCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := ADR(_pDoContainerNum.Header.Container.xWriteProtected) - ADR(_pDoContainerNum),pSource := ADR(_xNoWriteProtect),len := SIZEOF(_xNoWriteProtect));
					
					_PmIntern.enCycCopy := cs_CpyCpyString;
					
				ELSIF _dcpCSVNum.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _dcpCSVNum.status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCopy := cs_CpyRdyFault;
					
				END_IF

			cs_CpyCpyString:
			
				_dcpCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameString), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpCSVString.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVString := _dcpCSVString.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
					_PmIntern.CSVDataObjects.Idents.lCSVString := _dcpCSVString.identNew;
					
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
					
					_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );

					_dwCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := ADR(_pDoContainerString.Header.Time.dtTimestamp) - ADR(_pDoContainerString),pSource := ADR(_DTGetTime.DT1),len := SIZEOF(_DTGetTime.DT1));

					//###Hu Bug835 - Schreibschutz aufheben
					_xNoWriteProtect := FALSE;

					_dwCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := ADR(_pDoContainerString.Header.Container.xWriteProtected) - ADR(_pDoContainerString),pSource := ADR(_xNoWriteProtect),len := SIZEOF(_xNoWriteProtect));

					_PmIntern.enCycCopy := cs_CpyCpyBin;
					
				ELSIF _dcpCSVString.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _dcpCSVString.status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCopy := cs_CpyRdyFault;
					
				END_IF

			cs_CpyCpyBin:
			
				_dcpDefaultDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, pNameTarget := ADR(_PmIntern.ActContainer.sDoName), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpDefaultDO.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lDataObjekt := _dcpDefaultDO.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDefaultDO.len;
					_PmIntern.CSVDataObjects.Idents.lDataObjekt := _dcpDefaultDO.identNew;

					_PmIntern.enCycCopy := cs_CpyExpCSV;
					
				ELSIF _dcpDefaultDO.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_CREATE;
					_PmIntern.Status.diMsgAttr1 := _dcpDefaultDO.status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCopy := cs_CpyRdyFault;
					
				END_IF
			
			cs_CpyExpCSV:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				_PmIntern.ExpSettings.sFilename := _PmIntern.ActContainer.sCsvName;
				
				_ec(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ec.Status = ERR_OK THEN
					
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCopyCont] + (_wCopyInst - _PmIntern.ActContainer.wMinBound)].xExist := TRUE;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCopyCont] + (_wCopyInst - _PmIntern.ActContainer.wMinBound)].dtTimestamp := _DTGetTime.DT1;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCopyCont] + (_wCopyInst - _PmIntern.ActContainer.wMinBound)].iContainerID := _PmIntern.ActContainer.siContainerID;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCopyCont] + (_wCopyInst - _PmIntern.ActContainer.wMinBound)].wInstance := _PmIntern.ActContainer.wIndexIndirect;

					_PmIntern.enCycCopy := cs_CpyTOC;
					
				ELSIF _ec.Status <> ERR_FUB_BUSY THEN
					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
					_PmIntern.Status.diMsgAttr1 := _ec.Status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycCopy := cs_CpyRdyFault;

				END_IF
			
			cs_CpyTOC:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				
				_ExportTableOfContent(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ExportTableOfContent.Status = ERR_OK THEN
					
					mnParamStatAd.dtExportContent := _ExportTableOfContent.dtTocWritten;

					_PmIntern.enCycCopy := cs_CpyRdySuccess;

				ELSIF _ExportTableOfContent.Status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_COPY;
					_PmIntern.Status.diMsgAttr1 := _ExportTableOfContent.Status;
					_PmIntern.Status.diMsgAttr2 := _ExportTableOfContent.AdStatus;
					_PmIntern.Status.wMsgAckLevel := 0;
	
					_PmIntern.enCycCopy := cs_CpyRdyFault;

				END_IF
			
			cs_CpyRdyFault:

			// Mit Fehler beendet
				
			cs_CpyRdySuccess:
			
				// Mit Erfolg beendet

		END_CASE


		//*********************************************************************************************
		// Statemachine zum Importieren von Daten
		//*********************************************************************************************
		
		_TONshowfailed(IN:=_PmIntern.enCycImpState = cs_ImpShowFailed, PT:=T#2s);
		
		CASE _PmIntern.enCycImpState OF
			
			cs_ImpIdle:
			
				// Warte auf Kommando, tue nichts
			
			cs_ImpUSBLinkDevice:
			
				_sDevString := CONCAT('/DEVICE=',_sUSBInterface);
				_DevLink(enable := TRUE, pDevice := ADR(_MNPARAM_TEMP_USBDEV), pParam := ADR(_sDevString));
			
				IF _DevLink.status = ERR_OK THEN
					
					_PmIntern.enCycImpState := cs_ImpUSBStart;
					
					_sImportDevice := _MNPARAM_TEMP_USBDEV;
					_lDevLinkHandle := _DevLink.handle;
					
				ELSIF _DevLink.status <> ERR_FUB_BUSY THEN
					
					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_LINKUSB;
					_PmIntern.Status.diMsgAttr2 := _DevLink.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycImpState := cs_ImpRdyFault;

				END_IF
				
			cs_ImpUSBStart:

				// Baue Pfad zusammen für Import von CF
				_PmIntern.ImportParamCont.lFileNumber := 1;
				
				_PmIntern.sActPath := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				brsstrcat(ADR(_PmIntern.sActPath), ADR('\Import\'));
				
				brsmemset(ADR(_PmIntern.CSVDataObjects), 0, SIZEOF(_PmIntern.CSVDataObjects));

				_PmIntern.enCycImpState := cs_ImpDirInfo;

			cs_ImpStart:

				_lDevLinkHandle := 0;
				
				// Baue Pfad zusammen für Import von CF
				_PmIntern.ImportParamCont.lFileNumber := 1;
				
				_PmIntern.sActPath := MNPARAM_PATH_IMPORT;
				
				_PmIntern.ImportParamCont.sPcNumber := UINT_TO_STRING(_wImpSource);
				_PmIntern.sActPath := CONCAT(_PmIntern.sActPath, _PmIntern.ImportParamCont.sPcNumber);
				_PmIntern.sActPath := CONCAT(_PmIntern.sActPath,'\');
				
				brsmemset(ADR(_PmIntern.CSVDataObjects), 0, SIZEOF(_PmIntern.CSVDataObjects));
				
				_sImportDevice := KG_DEVICE_COMPACTFLASH;

				_PmIntern.enCycImpState := cs_ImpDirInfo;

			cs_ImpDirInfo:

				mnParamStatAd.wCntFilesImportFound := 0;
				mnParamStatAd.wCntFilesImportFailed := 0;
				mnParamStatAd.wCntFilesImportOK := 0;

				_DirInfo(enable := TRUE, pDevice := ADR(_sImportDevice), pPath := ADR(_PmIntern.sActPath));
			
				IF _DirInfo.status = ERR_OK THEN
					
					_xFoundOneFile := FALSE;
					
					_PmIntern.ImportParamCont.lFileCnt := _DirInfo.filenum;
					mnParamStatAd.wCntFilesImportFound := UDINT_TO_UINT(_DirInfo.filenum);
					IFmnParam.Out.Edit.wCntFilesImportFound := mnParamStatAd.wCntFilesImportFound;
					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_FOUNDFILES;
					_LogEntryIn.lAttr1 := _PmIntern.ImportParamCont.lFileCnt;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
					
					IF _PmIntern.ImportParamCont.lFileCnt = 0 THEN
						
						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DIREMPTY;
						_PmIntern.Status.diMsgAttr2 := 0;
						_PmIntern.Status.wMsgAckLevel := 0;
					
						IF _lDevLinkHandle <> 0 THEN
							
							_PmIntern.enCycImpState := cs_ImpUSBunlinkDevice;
							
						ELSE
							
							_PmIntern.enCycImpState := cs_ImpRdyFault;

						END_IF
						
					ELSE
						
						_PmIntern.ImportParamCont.lFileNumber := 1;
						_PmIntern.enCycImpState := cs_ImpDirRead;
						
						mnParamStatAd.wCntFilesImportFound := UDINT_TO_UINT(_PmIntern.ImportParamCont.lFileCnt);
						
					END_IF
					
				ELSIF _DirInfo.status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_DIRREAD;
					_PmIntern.Status.diMsgAttr2 := UINT_TO_DINT(_DirRead.status);
					_PmIntern.Status.wMsgAckLevel := 0;
					
					IF _lDevLinkHandle <> 0 THEN
							
						_PmIntern.enCycImpState := cs_ImpUSBunlinkDevice;
							
					ELSE
							
						_PmIntern.enCycImpState := cs_ImpRdyFault;

					END_IF

				END_IF
			
			cs_ImpShowFailed:
			
				_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORTFAILED;
				
				IF _TONshowfailed.Q THEN
					
					IF _PmIntern.ImportParamCont.lFileNumber > _PmIntern.ImportParamCont.lFileCnt THEN

						IF _lDevLinkHandle = 0 THEN
							
							// Lösche Verzeichnis
							_PmIntern.enCycImpState := cs_ImpDelDir;
							
						ELSE
							
							// Beendet ohne Fehler
							_PmIntern.enCycImpState := cs_ImpCPCache1;
							
						END_IF
					
					ELSE

						_PmIntern.enCycImpState := cs_ImpDirRead;

					END_IF

					brsmemset(ADR(_PmIntern.Status), 0, SIZEOF(_PmIntern.Status));
					_PmIntern.Status.wFunction_ID := MNPARAM_FUNCTIONID;
					
					mnParamStatAd.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed + 1;
					
				END_IF
			
			cs_ImpDirRead:
			
				_DirRead(enable := TRUE, pDevice := ADR(_sImportDevice), pPath := ADR(_PmIntern.sActPath), entry := _PmIntern.ImportParamCont.lFileNumber-1 , option := fiFILE, pData := ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1]), data_len := SIZEOF(_PmIntern.ImportParamCont.fiDir_Read_Data[1]));

				IF _DirRead.status = ERR_OK THEN
					
					_PmIntern.enCycImpState := cs_ImpCheckFile;

				ELSIF _DirRead.status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPDIRREAD;
					_PmIntern.Status.diMsgAttr2 := _DirRead.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					IF _lDevLinkHandle <> 0 THEN
							
						_PmIntern.enCycImpState := cs_ImpUSBunlinkDevice;
							
					ELSE
							
						_PmIntern.enCycImpState := cs_ImpRdyFault;

					END_IF
					
				END_IF

			cs_ImpCheckFile:

				_xFoundFile := FALSE;
										
				// Ermitteln, ob der Containername gültig ist
					
				FOR _c := 0 TO _PmIntern.DataObjects.MaxIndex.lContainer DO

					_wIndexIndirect := _pDoContainer.Container[_c].wMinBound;
		
					REPEAT		// Bei indirekter Parametrierung, wird diese Schleife mehrmals durchlaufen			

						// Aktuellen Container initialisieren
						_DefineActContainer(Enable := TRUE, bContainerIdx := DINT_TO_USINT(_c), wInstanceIdx := _wIndexIndirect, pIntern := ADR(_PmIntern));


						IF _DefineActContainer.Status = ERR_OK AND brsstrcmp(ADR(_PmIntern.ActContainer.sCsvName), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0])) = 0 THEN
									
							// Datei gefunden
							_xFoundFile := TRUE;
									
						END_IF

						IF NOT _xFoundFile THEN
								
							_wIndexIndirect := _wIndexIndirect + 1;
								
						END_IF

						UNTIL
						_xFoundFile OR _PmIntern.ActContainer.bDirect = 1 OR (_PmIntern.ActContainer.bDirect = 0 AND _wIndexIndirect >= _PmIntern.ActContainer.wMinBound + _PmIntern.ActContainer.wDimension)
					END_REPEAT
							
					IF _xFoundFile THEN
						EXIT;
					END_IF	

				END_FOR
					
				IF _xFoundFile THEN
						
					IF _PmIntern.ImportParamCont.fiDir_Read_Data[1].Filelength >= SIZEOF(KGBOM) THEN
						_PmIntern.CSVFile.lSize := _PmIntern.ImportParamCont.fiDir_Read_Data[1].Filelength - SIZEOF(KGBOM);
					ELSE
						_xFoundFile := FALSE;
					END_IF
					
				END_IF	
				
				IF _xFoundFile THEN
					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_FOUNDFILE;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
					
					_xFoundOneFile := TRUE;
					_PmIntern.sActPathAndFilename := _PmIntern.sActPath;
					brsstrcat(ADR(_PmIntern.sActPathAndFilename), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.enCycImpState := cs_ImpAllocMemFile;
					_xNextFile := FALSE;
						
				ELSE
					
					_PmIntern.ImportParamCont.lFileNumber := _PmIntern.ImportParamCont.lFileNumber + 1;
					
					IF _PmIntern.ImportParamCont.lFileNumber > _PmIntern.ImportParamCont.lFileCnt THEN

						IF NOT _xFoundOneFile THEN

							_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPFILENOTFND;
							_PmIntern.Status.diMsgAttr2 := 0;
							_PmIntern.Status.wMsgAckLevel := 0;
							
							IF _lDevLinkHandle <> 0 THEN
							
								_PmIntern.enCycImpState := cs_ImpCPCache1;
							
							ELSE
							
								_PmIntern.enCycImpState := cs_ImpDelDir;

							END_IF
							
						ELSE
							
							_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_FILENOTSUPPORTED;
							_PmIntern.Status.diMsgAttr2 := 0;
							brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
							_PmIntern.Status.wMsgAckLevel := 0;
						
							_PmIntern.enCycImpState := cs_ImpShowFailed;
							
						END_IF
						
					ELSE

						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_FILENOTSUPPORTED;
						_PmIntern.Status.diMsgAttr2 := 0;
						brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
						_PmIntern.Status.wMsgAckLevel := 0;
						
						_PmIntern.enCycImpState := cs_ImpShowFailed;

					END_IF
					
				END_IF

			cs_ImpAllocMemFile:
			
				_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.CSVFile.lSize);
				
				IF _MemPartAlloc.status = ERR_OK THEN
					
					_PmIntern.CSVFile.lAdress := _MemPartAlloc.mem;

					_PmIntern.enCycImpState := cs_ImpOpenFile;
					
				ELSIF _MemPartAlloc.status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPALLOCMEM;
					_PmIntern.Status.diMsgAttr2 := _DirRead.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					mnParamStatAd.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed + 1;
					
					IF _lDevLinkHandle <> 0 THEN
							
						_PmIntern.enCycImpState := cs_ImpCPCache1;
							
					ELSE
							
						_PmIntern.enCycImpState := cs_ImpDelDir;

					END_IF
					
				END_IF
				
			cs_ImpOpenFile:
			
				_FileOpen(enable := TRUE, pDevice := ADR(_sImportDevice), pFile := ADR(_PmIntern.sActPathAndFilename), mode := FILE_R);	
				
				IF _FileOpen.status = ERR_OK THEN

					_PmIntern.enCycImpState := cs_ImpReadFile;

				ELSIF _FileOpen.status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPOPENFILE;
					_PmIntern.Status.diMsgAttr2 := _DirRead.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF
				
			cs_ImpReadFile:
			
				_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM), pDest := _PmIntern.CSVFile.lAdress, len := _PmIntern.CSVFile.lSize - SIZEOF(KGBOM));
				
				IF _FileRead.status = ERR_OK THEN

					_PmIntern.Parse.lFileAdress := _PmIntern.CSVFile.lAdress;
					_PmIntern.Parse.lFileSize := _PmIntern.CSVFile.lSize;

					_PmIntern.enCycImpState := cs_ImpCloseFile;

				ELSIF _FileRead.status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPREADFILE;
					_PmIntern.Status.diMsgAttr2 := _DirRead.status;
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycImpState := cs_ImpCloseFile;
					
				END_IF
				
			cs_ImpCloseFile:
			
				_FileClose(enable := TRUE, ident := _FileOpen.ident);
				
				IF _FileClose.status <> ERR_FUB_BUSY THEN
					
					_PmIntern.enCycImpState := cs_ImpParsVers;
					
				END_IF
				
			cs_ImpParsVers:	
				
				
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
						IF _GetCsvDat.RowType = 253 THEN
							
							_CsvHeaderVersion := _GetCsvDat.HeaderVersion;
							_xFoundVersion := TRUE;
							
						ELSIF _GetCsvDat.RowType = 252 THEN
							
							_CsvHeadMachineNo := _GetCsvDat.HeaderMachineNo;
							_xFoundMachineNo := TRUE;
							
						END_IF

						_wStartLine := _wStartLine + 1;
		
					UNTIL
						(_xFoundVersion AND _xFoundMachineNo) OR _wStartLine > _PmIntern.Parse.lCntLines
					END_REPEAT
					
					IF _xFoundVersion THEN
						
						IF brwcscmp(ADR(_CsvHeaderVersion.utfMachineType),ADR(_pDoContainer.Header.Version.utfMachineType)) = 0 THEN
							
							IF _xFoundMachineNo THEN
							
								IF brwcscmp(ADR(_CsvHeadMachineNo.utfMachineNo),ADR(IFmnParam.Out.utfMachineNumber)) = 0 OR MNPARAM_CMNO = MNPARAM_CMNO_CHECKNOT THEN
									
									_PmIntern.enCycImpState := cs_ImpGetRoot;
								
								ELSE
									
									_LogEntryIn.wErrorNo := _MNPARAM_LOG_WRONGMACHINENO;
									_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
									_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
									_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

									_xNextFile := TRUE;
									
									_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
									_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPMACHINENO;
									_PmIntern.Status.diMsgAttr2 := 0;
									brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
									_PmIntern.Status.wMsgAckLevel := 0;
						
									_PmIntern.enCycImpState := cs_ImpFreeMemFile;

								END_IF

							ELSE

								_LogEntryIn.wErrorNo := _MNPARAM_LOG_WRONGMACHINENO;
								_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
								_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
								_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

								_xNextFile := TRUE;

								_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPMACHINENO;
								_PmIntern.Status.diMsgAttr2 := 0;
								brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
								_PmIntern.Status.wMsgAckLevel := 0;

								_PmIntern.enCycImpState := cs_ImpFreeMemFile;
									
							END_IF

						ELSE

							_LogEntryIn.wErrorNo := _MNPARAM_LOG_WRONGMACHINETYPE;
							_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
							_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
							_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

							_xNextFile := TRUE;
					
							_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPTYPE;
							_PmIntern.Status.diMsgAttr2 := 0;
							brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
							_PmIntern.Status.wMsgAckLevel := 0;

							_PmIntern.enCycImpState := cs_ImpFreeMemFile;
							
						END_IF
						
					ELSE

						_LogEntryIn.wErrorNo := _MNPARAM_LOG_NOVERSION;
						_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
						_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

						_xNextFile := TRUE;
					
						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_NOVERSION;
						_PmIntern.Status.diMsgAttr2 := 0;
						brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycImpState := cs_ImpFreeMemFile;
						
					END_IF
			
				ELSE

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_CNTLINES;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPCNTLINES;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
									
				END_IF				
				
			cs_ImpGetRoot:
			
				IF (_PmIntern.ActContainer.bDirect = 0) THEN
					
					IF  (PV_xgetadr(ADR(_PmIntern.ActContainer.sStrucRoot), ADR(_lPVadress), ADR(_lPVlen)) = ERR_OK) THEN

						_PmIntern.ActContainer.lAdressStructRoot := _lPVadress;
						_PmIntern.ActContainer.lSizeStructRoot := _lPVlen;

						_PmIntern.CSVDataObjects.TempAdresses.lDataObjekt := _lPVadress;
						_PmIntern.CSVDataObjects.Size.lDataObjekt := _lPVlen;

						_PmIntern.enCycImpState := cs_ImpDiNum;
						
					ELSE
						_LogEntryIn.wErrorNo := _MNPARAM_LOG_ROOTVAR;
						_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
						_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

						_xNextFile := TRUE;
					
						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPROOT;
						_PmIntern.Status.diMsgAttr2 := 0;
						brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycImpState := cs_ImpFreeMemFile;
						
					END_IF

				ELSE
				
					_PmIntern.enCycImpState := cs_ImpDiNum;

				END_IF
				
			cs_ImpDiNum:
			
				_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameNum));
				
				IF _diCSVNum.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVNum := _diCSVNum.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
					_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;
					
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
					
					IF NOT _pDoContainerNum.Header.Container.xWriteProtected THEN
					
						_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );
	
						_PmIntern.enCycImpState := cs_ImpDiStr;

					ELSE

						_LogEntryIn.wErrorNo := _MNPARAM_LOG_WRITEPROTECTED;
						_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
						_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

						_xNextFile := TRUE;

						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_WRITEPROTECTED;
						_PmIntern.Status.diMsgAttr2 := 0;
						brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycImpState := cs_ImpFreeMemFile;
						
					END_IF
						
				ELSIF _diCSVNum.status = doERR_MODULNOTFOUND AND _PmIntern.ActContainer.bDirect = 0 THEN

					_PmIntern.enCycImpState := cs_ImpDiNumDef;
					
				ELSIF _diCSVNum.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;
					
					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF
				
			cs_ImpDiNumDef:	
			
				_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefNum));
				
				IF _diCSVNum.status = ERR_OK THEN

					_PmIntern.enCycImpState := cs_ImpCpNum;
					
				ELSIF _diCSVNum.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;
					
					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF
				
			cs_ImpCpNum:
			
				_dcpCSVNum(enable := TRUE, ident := _diCSVNum.ident, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameNum), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpCSVNum.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVNum := _dcpCSVNum.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
					_PmIntern.CSVDataObjects.Idents.lCSVNum := _dcpCSVNum.identNew;
					
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
					
					_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );

					_PmIntern.enCycImpState := cs_ImpDiStr;
					
				ELSIF _dcpCSVNum.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF

			cs_ImpDiStr:
			
				_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));
				
				IF _diCSVString.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
					_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
					
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
					
					_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );

					IF _PmIntern.ActContainer.bDirect = 1 THEN
	
						_PmIntern.enCycImpState := cs_ImpAllocMemNum;
					
					ELSE
						
						_PmIntern.enCycImpState := cs_ImpDiBin;
						
					END_IF

				ELSIF _diCSVString.status = doERR_MODULNOTFOUND AND _PmIntern.ActContainer.bDirect = 0 THEN

					_PmIntern.enCycImpState := cs_ImpDiStrDef;
					
				ELSIF _diCSVString.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF
				
			cs_ImpDiStrDef:	
			
				_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDefString));
				
				IF _diCSVString.status = ERR_OK THEN

					_PmIntern.enCycImpState := cs_ImpCpStr;
					
				ELSIF _diCSVString.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF
				
			cs_ImpCpStr:
			
				_dcpCSVString(enable := TRUE, ident := _diCSVString.ident, pNameTarget := ADR(_PmIntern.ActContainer.sDoNameString), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpCSVString.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lCSVString := _dcpCSVString.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
					_PmIntern.CSVDataObjects.Idents.lCSVString := _dcpCSVString.identNew;
					
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
					
					_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );

					_PmIntern.enCycImpState := cs_ImpDiBin;
					
				ELSIF _dcpCSVString.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF

			cs_ImpDiBin:
			
				_diDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoName));
				
				IF _diDO.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lDataObjekt := _diDO.pDatObjMem;
					_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDO.len;
					_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDO.ident;
					
					_PmIntern.enCycImpState := cs_ImpAllocMemNum;

				ELSIF _diDO.status = doERR_MODULNOTFOUND THEN

					_PmIntern.enCycImpState := cs_ImpDiBinDef;
					
				ELSIF _diDO.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF
				
			cs_ImpDiBinDef:	
			
				_diDefaultDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameDef));
				
				IF _diDefaultDO.status = ERR_OK THEN

					_PmIntern.enCycImpState := cs_ImpCpBin;
					
				ELSIF _diDefaultDO.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF
				
			cs_ImpCpBin:
			
				_dcpDefaultDO(enable := TRUE, ident := _diDefaultDO.ident, pNameTarget := ADR(_PmIntern.ActContainer.sDoName), MemTypeTarget := doUSRROM, OptionTarget := 0);
				
				IF _dcpDefaultDO.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.Adress.lDataObjekt := _dcpDefaultDO.pDatObjMemNew;
					_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDefaultDO.len;
					_PmIntern.CSVDataObjects.Idents.lDataObjekt := _dcpDefaultDO.identNew;

					_PmIntern.enCycImpState := cs_ImpAllocMemNum;
					
				ELSIF _dcpDefaultDO.status <> ERR_FUB_BUSY THEN

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;
					
				END_IF

			cs_ImpAllocMemNum:
			
				_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.CSVDataObjects.Size.lCSVNum);
				
				IF _MemPartAlloc.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := _MemPartAlloc.mem;
					
					_PmIntern.enCycImpState := cs_ImpAllocMemStr;
					
				ELSE

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;

				END_IF

			cs_ImpAllocMemStr:
			
				_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.CSVDataObjects.Size.lCSVString);
				
				IF _MemPartAlloc.status = ERR_OK THEN
					
					_PmIntern.CSVDataObjects.TempAdresses.lCSVString := _MemPartAlloc.mem;
					
					_PmIntern.enCycImpState := cs_ImpRdNum;
					
				ELSE

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;

				END_IF


			cs_ImpRdNum:
			
				_drCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := 0, pDestination := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum, len := _PmIntern.CSVDataObjects.Size.lCSVNum);
				
				IF _drCSVNum.status = ERR_OK THEN
					
					_PmIntern.enCycImpState := cs_ImpRdStr;
					
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVNum;
				
				ELSE

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;

				END_IF


			cs_ImpRdStr:
			
				_drCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := 0, pDestination := _PmIntern.CSVDataObjects.TempAdresses.lCSVString, len := _PmIntern.CSVDataObjects.Size.lCSVString);
				
				IF _drCSVString.status = ERR_OK THEN
	
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVString;
					
					IF _PmIntern.ActContainer.bDirect  = 1 THEN
	
						_PmIntern.enCycImpState := cs_ImpSetDefaultNum;

					ELSE
						
						_PmIntern.enCycImpState := cs_ImpRdBin;
						
					END_IF
				
				ELSE

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;

				END_IF

			cs_ImpRdBin:
			
				_drDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, Offset := 0, pDestination := _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt, len := _PmIntern.CSVDataObjects.Size.lDataObjekt);
				
				IF _drDO.status = ERR_OK THEN
					
					_PmIntern.enCycImpState := cs_ImpSetDefaultNum;
				
				ELSE

					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemFile;

				END_IF

			cs_ImpSetDefaultNum:
			
				IF _xImpSetDefault THEN
					
					FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.CSVDataObjects.MaxIndex.lCSVNum) DO
						
						IF _pDoContainerNum.CsvNum[_i].wIdxNumPar > 0 AND _pDoContainerNum.CsvNum[_i].wIdxNumPar <= _PmIntern.ActContainer.lCountParamNum THEN
						
							_pDoContainerNum.CsvNum[_i].diValue := _pDoParamNum.ParamNum[_pDoContainerNum.CsvNum[_i].wIdxNumPar].diDefValue;
							_pDoContainerNum.CsvNum[_i].xChanged := FALSE;
						
						END_IF
						
					END_FOR
					
				END_IF
			
				_PmIntern.enCycImpState := cs_ImpSetDefaultStr;

			cs_ImpSetDefaultStr:
			
				IF _xImpSetDefault THEN
					
					FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.CSVDataObjects.MaxIndex.lCSVString) DO
						
						IF _pDoContainerString.CsvString[_i].wIdxStringPar > 0 AND _pDoContainerString.CsvString[_i].wIdxStringPar <= _PmIntern.ActContainer.lCountParamString THEN
						
							_pDoContainerString.CsvString[_i].utfValue := _pDoParamString.ParamString[_pDoContainerString.CsvString[_i].wIdxStringPar].utfDefValue;
							_pDoContainerString.CsvString[_i].xChanged := FALSE;
						
						END_IF
						
					END_FOR
					
				END_IF
			
				_PmIntern.enCycImpState := cs_ImpParse;

			cs_ImpParse:
			
			
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
						
						END_IF
						
					ELSIF _GetCsvDat.RowType = 20 THEN

						_binarySearchString.CsvStructString := _GetCsvDat.CsvStringRow;
						_binarySearchString();
						
						IF _binarySearchString.status = 0 THEN

							_pDoContainerString.CsvString[_binarySearchString.lFoundRow] := _GetCsvDat.CsvStringRow;

							_pDoContainerString.CsvString[_binarySearchString.lFoundRow].xChanged := brwcscmp(ADR(_pDoParamString.ParamString[_GetCsvDat.CsvStringRow.wIdxStringPar].utfDefValue), ADR(_GetCsvDat.CsvStringRow.utfValue)) <> 0;

						END_IF
			
			
					END_IF

					_wStartLine := _wStartLine + 1;

					UNTIL
					_wStartLine > _PmIntern.Parse.lCntLines
				END_REPEAT

				_PmIntern.enCycImpState := cs_ImpFreeMemFile;
				
				_DTGetTime(enable := TRUE);
				
				_pDoContainerNum.Header.Time.dtTimestamp := _DTGetTime.DT1;
				_pDoContainerString.Header.Time.dtTimestamp := _DTGetTime.DT1;
			
			
			cs_ImpFreeMemFile:
			
				_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVFile.lAdress);
				
				_PmIntern.CSVFile.lAdress := 0;
				_PmIntern.CSVFile.lSize := 0;
				_PmIntern.Parse.lFileAdress := 0;
				_PmIntern.Parse.lFileSize := 0;

				IF _PmIntern.Status.wMsgNumber <> 0 THEN
					
					IF _PmIntern.CSVDataObjects.TempAdresses.lCSVNum <> 0 THEN
						_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
						_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := 0;
					END_IF

					IF _PmIntern.CSVDataObjects.TempAdresses.lCSVString <> 0 THEN
						_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
						_PmIntern.CSVDataObjects.TempAdresses.lCSVString := 0;
					END_IF
					
					IF _PmIntern.Status.diMsgAttr1 = 0 THEN
						_PmIntern.Status.diMsgAttr1 := 59999;
					END_IF
					
					IF _lDevLinkHandle <> 0 THEN
							
						_PmIntern.enCycImpState := cs_ImpCPCache1;
							
					ELSE
							
						_PmIntern.enCycImpState := cs_ImpDelDir;

					END_IF

					mnParamStatAd.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed + 1;
				
				ELSE
					
					IF _xNextFile THEN
						
						IF _PmIntern.CSVDataObjects.TempAdresses.lCSVNum <> 0 THEN
							_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
							_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := 0;
						END_IF

						IF _PmIntern.CSVDataObjects.TempAdresses.lCSVString <> 0 THEN
							_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
							_PmIntern.CSVDataObjects.TempAdresses.lCSVString := 0;
						END_IF

						_PmIntern.ImportParamCont.lFileNumber := _PmIntern.ImportParamCont.lFileNumber + 1;

						_PmIntern.enCycImpState := cs_ImpShowFailed;
						
					ELSE
						_PmIntern.enCycImpState := cs_ImpWrNum;
					END_IF
					
				END_IF
				
			cs_ImpWrNum:
			
				_dwCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum, len := _PmIntern.CSVDataObjects.Size.lCSVNum);				
			
				IF _dwCSVNum.status = ERR_OK THEN
					
					_PmIntern.enCycImpState := cs_ImpWrStr;
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
					
					
				ELSIF _dwCSVNum.status <> ERR_FUB_BUSY THEN
					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemStr;
					
				END_IF

			cs_ImpWrStr:
			
				_dwCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lCSVString, len := _PmIntern.CSVDataObjects.Size.lCSVString);				
			
				IF _dwCSVString.status = ERR_OK THEN
					
					_PmIntern.enCycImpState := cs_ImpSetPV;
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;

					
				ELSIF _dwCSVString.status <> ERR_FUB_BUSY THEN
					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemStr;
					
				END_IF

			cs_ImpSetPV:
			
				_DTGetTime(enable := TRUE);
				
				_dtStartSetPV := _DTGetTime.DT1;
			
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
						
					END_IF
					
				END_FOR
				
				// String Parameter schreiben
				FOR _i := 1 TO UDINT_TO_UINT(_PmIntern.CSVDataObjects.MaxIndex.lCSVString) DO

					IF _pDoContainerString.CsvString[_i].wIdxStringPar > 0 AND _pDoContainerString.CsvString[_i].wIdxStringPar <= _PmIntern.DataObjects.MaxIndex.lParamString THEN
						
						_PS := _pDoParamString.ParamString[_pDoContainerString.CsvString[_i].wIdxStringPar];
						
						_CS := _pDoContainerString.CsvString[_i];

						GetArrayPV(pPV := ADR(_PS.sAdresse), pStructRoot := ADR(_PmIntern.ActContainer.sStrucRoot), pPVFilled := ADR(_sPVAdress), idx1 :=_CS.wArrIdx1, idx2:=_CS.wArrIdx2, idx3:=_CS.wArrIdx3, idx4:=_CS.wArrIdx4);
						
						IF _pDoContainerString.CsvString[_i].wIdxStringPar = MNPARAM_PARIDX_MACHINENAME AND ABS(_PmIntern.ActContainer.siContainerID) = MNPARAM_IDX_MACHINENAMECONTAINER THEN
							mnParamStatAd.utfMachineName := _CS.utfValue;
						END_IF

						
						_WritePVString(pAdress := ADR(_sPVAdress), p_utfValue := ADR(_CS.utfValue));
										
					END_IF
					
				END_FOR

				IF _PmIntern.ActContainer.bDirect = 0 THEN
					
					_PmIntern.enCycImpState := cs_ImpWrBin;
					
				ELSE
					
					_PmIntern.enCycImpState := cs_ImpFreeMemStr;
					
				END_IF
				
				_DTGetTime(enable := TRUE);
				
				_dtEndSetPV := _DTGetTime.DT1;
				
				
			cs_ImpWrBin:

				_dwDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt, len := _PmIntern.CSVDataObjects.Size.lDataObjekt);				
			
				IF _dwDO.status = ERR_OK THEN
					
					_PmIntern.enCycImpState := cs_ImpFreeMemStr;
					
				ELSIF _dwDO.status <> ERR_FUB_BUSY THEN
					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_xNextFile := TRUE;

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycImpState := cs_ImpFreeMemStr;
					
				END_IF
			
			cs_ImpFreeMemStr:
			
				IF _PmIntern.CSVDataObjects.TempAdresses.lCSVString <> 0 THEN

					_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
				
					IF _MemPartFree.status <> ERR_FUB_BUSY THEN
					
						_PmIntern.enCycImpState := cs_ImpFreeMemNum;
						
						_PmIntern.CSVDataObjects.TempAdresses.lCSVString := 0;
					
					END_IF

				ELSE

					_PmIntern.enCycImpState := cs_ImpFreeMemNum;

				END_IF
					
			cs_ImpFreeMemNum:
			
				IF _PmIntern.CSVDataObjects.TempAdresses.lCSVNum <> 0 THEN
				
					_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
					
					IF _MemPartFree.status <> ERR_FUB_BUSY THEN
						
						_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := 0;
						
						IF _PmIntern.Status.wMsgNumber <> 0 THEN
						
							IF _PmIntern.Status.diMsgAttr1 = 0 THEN
								_PmIntern.Status.diMsgAttr1 := 59999;
							END_IF

							IF _lDevLinkHandle <> 0 THEN
							
								_PmIntern.enCycImpState := cs_ImpCPCache1;
							
							ELSE
							
								_PmIntern.enCycImpState := cs_ImpDelDir;

							END_IF

							mnParamStatAd.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed + 1;
					
						ELSE
						
							IF _xNextFile THEN
							
								mnParamStatAd.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed + 1;
								
								_PmIntern.ImportParamCont.lFileNumber := _PmIntern.ImportParamCont.lFileNumber + 1;
					
								_PmIntern.enCycImpState := cs_ImpShowFailed;

							ELSE

								_PmIntern.enCycImpState := cs_ImpExpCSV;

							END_IF
							
						
						END_IF
						
					END_IF
					
				ELSE

					IF _PmIntern.Status.wMsgNumber <> 0 THEN
						IF _PmIntern.Status.diMsgAttr1 = 0 THEN
							_PmIntern.Status.diMsgAttr1 := 59999;
						END_IF
						
						IF _lDevLinkHandle <> 0 THEN
							
							_PmIntern.enCycImpState := cs_ImpCPCache1;
							
						ELSE
							
							_PmIntern.enCycImpState := cs_ImpDelDir;

						END_IF

						mnParamStatAd.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed + 1;
					
					ELSE
						
						IF _xNextFile THEN
							
							IFmnParam.Out.Edit.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed;
							
							_PmIntern.ImportParamCont.lFileNumber := _PmIntern.ImportParamCont.lFileNumber + 1;
					
							_PmIntern.enCycImpState := cs_ImpShowFailed;

						ELSE

							_PmIntern.enCycImpState := cs_ImpExpCSV;

						END_IF
						
					END_IF

				END_IF
			
			cs_ImpExpCSV:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				_PmIntern.ExpSettings.sFilename := _PmIntern.ActContainer.sCsvName;
				
				_ec(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ec.Status = ERR_OK THEN
					
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[ABS(_PmIntern.ActContainer.siContainerID)]+(_PmIntern.ActContainer.wIndexIndirect-_PmIntern.ActContainer.wMinBound)].dtTimestamp := _pDoContainerNum.Header.Time.dtTimestamp;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[ABS(_PmIntern.ActContainer.siContainerID)]+(_PmIntern.ActContainer.wIndexIndirect-_PmIntern.ActContainer.wMinBound)].iContainerID := _PmIntern.ActContainer.siContainerID;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[ABS(_PmIntern.ActContainer.siContainerID)]+(_PmIntern.ActContainer.wIndexIndirect-_PmIntern.ActContainer.wMinBound)].wInstance := _PmIntern.ActContainer.wIndexIndirect;
					_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[ABS(_PmIntern.ActContainer.siContainerID)]+(_PmIntern.ActContainer.wIndexIndirect-_PmIntern.ActContainer.wMinBound)].xExist := TRUE;

					mnParamStatAd.wCntFilesImportOK := mnParamStatAd.wCntFilesImportOK + 1;

					_PmIntern.ImportParamCont.lFileNumber := _PmIntern.ImportParamCont.lFileNumber + 1;
					
					IF _PmIntern.ImportParamCont.lFileNumber > _PmIntern.ImportParamCont.lFileCnt THEN

						IF _lDevLinkHandle = 0 THEN
								
							// Lösche Verzeichnis
							_PmIntern.enCycImpState := cs_ImpDelDir;
								
						ELSE
								
							// Beendet ohne Fehler
							_PmIntern.enCycImpState := cs_ImpCPCache1;
								
						END_IF
						
					ELSE

						_PmIntern.enCycImpState := cs_ImpDirRead;

					END_IF
					
				ELSIF _ec.Status <> ERR_FUB_BUSY THEN

					
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_SYSTEMFAULT;
					_LogEntryIn.lAttr1 := SINT_TO_UDINT(ABS(_PmIntern.ActContainer.siContainerID));
					_LogEntryIn.lAttr2 := _PmIntern.ActContainer.wIndexIndirect;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
					_PmIntern.Status.diMsgAttr2 := 0;
					brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt), ADR(_PmIntern.ImportParamCont.fiDir_Read_Data[1].Filename[0]));
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.ImportParamCont.lFileNumber := _PmIntern.ImportParamCont.lFileNumber + 1;

					_PmIntern.enCycImpState := cs_ImpShowFailed;

				END_IF
			
			cs_ImpUSBunlinkDevice:
			
				_DevUnlink(enable := TRUE, handle := _lDevLinkHandle);
				
				IF _DevUnlink.status <> ERR_FUB_BUSY THEN
					
					IF _PmIntern.Status.wMsgNumber <> 0 THEN
						
						IF _PmIntern.Status.diMsgAttr1 = 0 THEN
							_PmIntern.Status.diMsgAttr1 := 59999;
						END_IF
						
						_PmIntern.enCycImpState := cs_ImpTOC;
						
					ELSE
						
						_PmIntern.enCycImpState := cs_ImpTOC;

					END_IF
					
				END_IF

			
			cs_ImpDelDir:

				_DirDeleteEx(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_PmIntern.sActPath));
				
				IF _DirDeleteEx.status <> ERR_FUB_BUSY THEN

					_PmIntern.enCycImpState := cs_ImpTOC;
					
				END_IF

			cs_ImpTOC:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				
				_ExportTableOfContent(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ExportTableOfContent.Status = ERR_OK THEN
					
					mnParamStatAd.dtExportContent := _ExportTableOfContent.dtTocWritten;
					
					IF _PmIntern.Status.wMsgNumber <> 0 THEN
						
						IF _PmIntern.Status.diMsgAttr1 = 0 THEN
							_PmIntern.Status.diMsgAttr1 := 59999;
						END_IF
						
						_PmIntern.enCycImpState := cs_ImpRdyFault;
						
					ELSE
						
						_PmIntern.enCycImpState := cs_ImpRdySuccess;

					END_IF

				ELSIF _ExportTableOfContent.Status <> ERR_FUB_BUSY THEN

					IF _PmIntern.Status.wMsgNumber <> 0 THEN
						
						IF _PmIntern.Status.diMsgAttr1 = 0 THEN
							_PmIntern.Status.diMsgAttr1 := 59999;
						END_IF
						
						_PmIntern.enCycImpState := cs_ImpRdyFault;
						
					ELSE
						
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_IMPORT;
						_PmIntern.Status.diMsgAttr1 := _ExportTableOfContent.Status;
						_PmIntern.Status.diMsgAttr2 := _ExportTableOfContent.AdStatus;
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycImpState := cs_ImpRdyFault;

					END_IF

				END_IF

			cs_ImpCPCache1:
			
				IF IFsvCPCache.In.wCmd = KG_CMD_NOCOMMAND THEN

					IFsvCPCache.In.sImpDevice := _MNPARAM_TEMP_USBDEV;
					IFsvCPCache.In.sImpPath := _PmIntern.sActPath;
					IFsvCPCache.In.wCmd := SVCPCACHE_CMD_RESTORE;
					
					_PmIntern.enCycImpState := cs_ImpCPCache2;
					
				ELSE
						
					_PmIntern.enCycImpState := cs_ImpUSBunlinkDevice;

				END_IF
			
			cs_ImpCPCache2:
			
				IF IFsvCPCache.Out.wCmdResponse <> KG_CMD_NOCOMMAND AND IFsvCPCache.Out.wCmdResponse <> KG_CMDSTAT_BUSY THEN
					
					IFsvCPCache.In.wCmd := KG_CMD_NOCOMMAND;

					_PmIntern.enCycImpState := cs_ImpUSBunlinkDevice;

				END_IF
			
			cs_ImpRdyFault:
			
			// Mit Fehler beendet
				
			cs_ImpRdySuccess:
			
				// Mit Erfolg beendet
		
		END_CASE
		
		//*********************************************************************************************
		// Statemachine zum Füllen des Editiors mit Daten
		//*********************************************************************************************
		
		CASE _PmIntern.enCycFillEditor OF
			
			cs_feIdle:
			
			cs_feStart:
			
				brsmemset(ADR(IFmnParam.Out.Edit.AttrNum), 0, SIZEOF(IFmnParam.Out.Edit.AttrNum));
				brsmemset(ADR(IFmnParam.Out.Edit.AttrStr), 0, SIZEOF(IFmnParam.Out.Edit.AttrStr));
				IFmnParam.Out.Edit.bCntNumRows := 0;
				IFmnParam.Out.Edit.bCntStrRows := 0;
				IFmnParam.Out.Edit.bContainer := 0;
				IFmnParam.Out.Edit.wContainerInstance := 0;
				IFmnParam.Out.Edit.wRowNumOffset := 0;
				IFmnParam.Out.Edit.wRowStrOffset := 0;
				
				brsmemset(ADR(_EditNumValues), 0, SIZEOF(_EditNumValues));
				brsmemset(ADR(_EditStrValues), 0, SIZEOF(_EditStrValues));
			
				IFmnParam.Out.Edit.wStatus := KG_STAT_BUSY;
			
				_DefineActContainer(Enable := TRUE, bContainerIdx := IFmnParam.In.Edit.bContainer, wInstanceIdx := DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance), pIntern := ADR(_PmIntern));
			
				IF _DefineActContainer.Status = ERR_OK THEN
					
					// Container Parameter sind im gültigen Bereich und die Containerspec. ist ok
					
					IF (_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[IFmnParam.In.Edit.bContainer] + (DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance) - _PmIntern.ActContainer.wMinBound)].xExist 
						AND _PmIntern.ActContainer.bDirect = 0) 
						OR
						(_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[IFmnParam.In.Edit.bContainer]].xExist AND _PmIntern.ActContainer.bDirect = 1) THEN
						
						// Die Containerinstanz existiert
						
						_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameNum));
				
						IF _diCSVNum.status = ERR_OK THEN
							
							// Datenobjekt mit aktuellen numerischen Parametern wurde gefunden
					
							_PmIntern.CSVDataObjects.Adress.lCSVNum := _diCSVNum.pDatObjMem;
							_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
							_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;
					
							_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
					
							_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );

							_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));
				
							IF _diCSVString.status = ERR_OK THEN
					
								// Datenobjekt mit aktuellen String Parametern wurde gefunden

								_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
								_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
								_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
					
								_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
					
								_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );

								_PmIntern.enCycFillEditor := cs_feFillEditor;
								
							ELSIF _diCSVString.status <> ERR_FUB_BUSY THEN

								_PmIntern.Status.wMsgClass := 10;
								_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_FILLEDITOR;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
								_PmIntern.Status.diMsgAttr2 := 0;
								_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameString;
								_PmIntern.Status.wMsgAckLevel := 0;
					
								_PmIntern.enCycFillEditor := cs_feRdyFault;
					
							END_IF
							
						ELSIF _diCSVNum.status <> ERR_FUB_BUSY THEN

							_PmIntern.Status.wMsgClass := 10;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_FILLEDITOR;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
							_PmIntern.Status.diMsgAttr2 := 0;
							_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameNum;
							_PmIntern.Status.wMsgAckLevel := 0;
					
							_PmIntern.enCycFillEditor := cs_feRdyFault;
					
						END_IF
						
					ELSE

						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_FILLEDITOR;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CONTINST_NOT_EXIST;
						_PmIntern.Status.diMsgAttr2 := 0;
						_PmIntern.Status.wMsgAckLevel := 0;

						_PmIntern.enCycFillEditor := cs_feRdyFault;
						
					END_IF
						
				ELSE

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_FILLEDITOR;
					_PmIntern.Status.diMsgAttr1 := _DefineActContainer.Status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycFillEditor := cs_feRdyFault;

				END_IF

			cs_feFillEditor:
			
				IFmnParam.Out.Edit.bContainer := IFmnParam.In.Edit.bContainer;
				IFmnParam.Out.Edit.wContainerInstance := DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance);
				IFmnParam.Out.Edit.lPtrEditNumValues := ADR(_EditNumValues);
				IFmnParam.Out.Edit.lPtrEditStrValues := ADR(_EditStrValues);
				IFmnParam.Out.Edit.utfFilterFunction := "";

				// Functionfilter auswerten
				
				IF IFmnTxt.Out.wSelectLanguageStatus = ERR_OK AND IFmnTxt.Out.ptrFunctionTxtList <> 0 AND
					IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_LINEAR_FFUNCT THEN
										
					_wIdxFunctionTxt := _BinSearchTxtLine(IFmnParam.In.Edit.wFilterFunctionID , 0, IFmnTxt.Out.ptrFunctionTxtList, IFmnTxt.Out.wCntFunctionTxt);

					IF _wIdxFunctionTxt <> 65535 THEN

						_pFunctionTxt ACCESS IFmnTxt.Out.ptrFunctionTxtList;
						brwcsncat(ADR(IFmnParam.Out.Edit.utfFilterFunction), ADR(_pFunctionTxt[_wIdxFunctionTxt].utfText), 31);
						
					END_IF
					
					IFmnParam.Out.Edit.wFilterFunctionID := IFmnParam.In.Edit.wFilterFunctionID;
					
				ELSE

					IFmnParam.Out.Edit.wFilterFunctionID := 0;
					
				END_IF

				// Numerische Werte auslesen
				
				IF _PmIntern.CSVDataObjects.MaxIndex.lCSVNum > 0 AND IFmnParam.In.Edit.bCntNumRows > 0 THEN
					
					IF IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_LINEAR OR IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_LINEAR_FFUNCT THEN

						// Vorhandene Zeilen bestimmen
						
						_wActIdx := 1;
						_wCntParams := 0;
						
						REPEAT
							
							// Nur ausführen, wenn _wActIdx zulässig ist
							IF _wActIdx <= _PmIntern.CSVDataObjects.MaxIndex.lCSVNum THEN
							
								// Referenz auf Parameterbeschreibung auslesen
								_wActRefIdx := _pDoContainerNum.CsvNum[_wActIdx].wIdxNumPar;
								
								// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
								IF _wActRefIdx <= _PmIntern.DataObjects.MaxIndex.lParamNum THEN
									
									IF IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_LINEAR OR _pDoParamNum.ParamNum[_wActRefIdx].wFunction_ID = IFmnParam.Out.Edit.wFilterFunctionID THEN
									
										// Schreib- und Leserechte ermitteln. Sie können vererbt sein!
										_GetAccessRights(Enable := TRUE, siWriteAccess := _pDoParamNum.ParamNum[_wActRefIdx].siWriteAccess, 
										siReadAccess := _pDoParamNum.ParamNum[_wActRefIdx].siVisibleAccess, 
										wReference := _pDoParamNum.ParamNum[_wActRefIdx].wReferenz, 
										lPtrLogicStruct := _PmIntern.DataObjects.Adress.lLogicalStruct, 
										wMaxIdxLogicStruct := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct));
	
										IF _GetAccessRights.bReadAccess <= IFmnParam.In.Edit.bUserLevel THEN
											
											_wCntParams := _wCntParams + 1;
											
										END_IF

									END_IF
									
								END_IF
								
							END_IF	

							_wActIdx := _wActIdx + 1;
							
							UNTIL
							
							_PmIntern.CSVDataObjects.MaxIndex.lCSVNum < _wActIdx
							
						END_REPEAT

						IFmnParam.Out.Edit.wRowNumCntAll := _wCntParams;
						
						IF _wCntParams >= (IFmnParam.In.Edit.wRowNumOffset + IFmnParam.In.Edit.bCntNumRows) THEN
							IFmnParam.Out.Edit.wRowNumOffset := IFmnParam.In.Edit.wRowNumOffset;
						ELSIF _wCntParams >= (IFmnParam.In.Edit.bCntNumRows) THEN
							IFmnParam.Out.Edit.wRowNumOffset := _wCntParams - IFmnParam.In.Edit.bCntNumRows;
						ELSE
							IFmnParam.Out.Edit.wRowNumOffset := 0;
						END_IF
						
						IF IFmnParam.Out.Edit.wRowNumCntAll > 0 THEN
							
							_wActRow := 1;
							_wActIdx := 1;
							_wCntParams := 0;
	
							REPEAT
	
								// Nur ausführen, wenn _wActIdx zulässig ist
								IF _wActIdx <= _PmIntern.CSVDataObjects.MaxIndex.lCSVNum THEN
								
									// Referenz auf Parameterbeschreibung auslesen
									_wActRefIdx := _pDoContainerNum.CsvNum[_wActIdx].wIdxNumPar;
									
									// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
									IF _wActRefIdx <= _PmIntern.DataObjects.MaxIndex.lParamNum THEN
										
										IF IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_LINEAR OR _pDoParamNum.ParamNum[_wActRefIdx].wFunction_ID = IFmnParam.Out.Edit.wFilterFunctionID THEN

											// Schreib- und Leserechte ermitteln. Sie können vererbt sein!
											_GetAccessRights(Enable := TRUE, siWriteAccess := _pDoParamNum.ParamNum[_wActRefIdx].siWriteAccess, 
												siReadAccess := _pDoParamNum.ParamNum[_wActRefIdx].siVisibleAccess, 
												wReference := _pDoParamNum.ParamNum[_wActRefIdx].wReferenz, 
												lPtrLogicStruct := _PmIntern.DataObjects.Adress.lLogicalStruct, 
												wMaxIdxLogicStruct := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct));
		
											IF _GetAccessRights.bReadAccess <= IFmnParam.In.Edit.bUserLevel THEN
		
												IF _wCntParams >= IFmnParam.Out.Edit.wRowNumOffset THEN
												
													IFmnParam.Out.Edit.AttrNum[_wActRow].bReadAccess := _GetAccessRights.bReadAccess;
													IFmnParam.Out.Edit.AttrNum[_wActRow].bWriteAccess := _GetAccessRights.bWriteAccess;
			
													// ***************ACTION***************
													_actFillEditNum;
													// ***************ACTION***************
												
													IFmnParam.Out.Edit.bCntNumRows := UINT_TO_USINT(_wActRow);
												
			
													_wActRow := _wActRow + 1;
		
												END_IF
												
												_wCntParams := _wCntParams + 1;
												
											END_IF
											
										END_IF
				
									END_IF
									
								END_IF
								
								_wActIdx := _wActIdx + 1;
								
								UNTIL
								
								_PmIntern.CSVDataObjects.MaxIndex.lCSVNum < _wActIdx OR _wActRow > MIN(MNPARAM_CNT_EDITROWS, IFmnParam.In.Edit.bCntNumRows)
								
							END_REPEAT

						END_IF
						
					ELSIF IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_BYIDX THEN

						IFmnParam.Out.Edit.wRowNumOffset := 0;
						IFmnParam.Out.Edit.wRowNumCntAll := 0;
						IFmnParam.Out.Edit.bCntNumRows := UINT_TO_USINT(MIN(MNPARAM_CNT_EDITROWS, IFmnParam.In.Edit.bCntNumRows));
						
						FOR _ii := 1 TO IFmnParam.Out.Edit.bCntNumRows DO

							_wActRow := _ii;
							
							// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
							IF IFmnParam.In.Edit.wSelParIdxNum[_wActRow] <= _PmIntern.DataObjects.MaxIndex.lParamNum AND IFmnParam.In.Edit.wSelParIdxNum[_wActRow] > 0 THEN

								_wActRefIdx := IFmnParam.In.Edit.wSelParIdxNum[_wActRow];

								// Suche Parameter-Containerindex anhand des Parameterindex und der 4 möglichen Array-Werte
								_binarySearchNum.enable := TRUE;
								_binarySearchNum.CsvStructNum.wIdxNumPar 	:= IFmnParam.In.Edit.wSelParIdxNum[_wActRow];
								_binarySearchNum.CsvStructNum.wArrIdx1 		:= IFmnParam.In.Edit.wSelParArrIdxNum[_wActRow,1];
								_binarySearchNum.CsvStructNum.wArrIdx2 		:= IFmnParam.In.Edit.wSelParArrIdxNum[_wActRow,2];
								_binarySearchNum.CsvStructNum.wArrIdx3 		:= IFmnParam.In.Edit.wSelParArrIdxNum[_wActRow,3];
								_binarySearchNum.CsvStructNum.wArrIdx4 		:= IFmnParam.In.Edit.wSelParArrIdxNum[_wActRow,4];
								_binarySearchNum.lpList 					:= _PmIntern.CSVDataObjects.Adress.lCSVNum;
								_binarySearchNum.lMaxRow 					:= _PmIntern.CSVDataObjects.MaxIndex.lCSVNum;

								_binarySearchNum();

								// Wurde der Parameter im Container gefunden ?
								IF _binarySearchNum.status = ERR_OK THEN

									_wActIdx := UDINT_TO_UINT(_binarySearchNum.lFoundRow);

									// Schreib- und Leserechte ermitteln. Sie können vererbt sein!
									_GetAccessRights(Enable := TRUE, siWriteAccess := _pDoParamNum.ParamNum[_wActRefIdx].siWriteAccess, 
										siReadAccess := _pDoParamNum.ParamNum[_wActRefIdx].siVisibleAccess, 
										wReference := _pDoParamNum.ParamNum[_wActRefIdx].wReferenz, 
										lPtrLogicStruct := _PmIntern.DataObjects.Adress.lLogicalStruct, 
										wMaxIdxLogicStruct := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct));

									IF _GetAccessRights.bReadAccess <= IFmnParam.In.Edit.bUserLevel THEN

										IFmnParam.Out.Edit.AttrNum[_wActRow].bReadAccess := _GetAccessRights.bReadAccess;
										IFmnParam.Out.Edit.AttrNum[_wActRow].bWriteAccess := _GetAccessRights.bWriteAccess;

										// ***************ACTION***************
										_actFillEditNum;
										// ***************ACTION***************

									END_IF

								END_IF

							END_IF
							
						END_FOR
							
					END_IF

				END_IF

				// Stringwerte auslesen, wenn gefordert

				IF _PmIntern.CSVDataObjects.MaxIndex.lCSVString > 0 AND IFmnParam.In.Edit.bCntStrRows > 0 THEN
					
					IF IFmnParam.In.Edit.bSelectModeStr = MNPARAM_SELECTMODE_LINEAR OR IFmnParam.In.Edit.bSelectModeStr = MNPARAM_SELECTMODE_LINEAR_FFUNCT THEN

						// Vorhandene Zeilen bestimmen
						
						_wActIdx := 1;
						_wCntParams := 0;
						
						REPEAT
							
							// Nur ausführen, wenn _wActIdx zulässig ist
							IF _wActIdx <= _PmIntern.CSVDataObjects.MaxIndex.lCSVString THEN
							
								// Referenz auf Parameterbeschreibung auslesen
								_wActRefIdx := _pDoContainerString.CsvString[_wActIdx].wIdxStringPar;
								
								// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
								IF _wActRefIdx <= _PmIntern.DataObjects.MaxIndex.lParamString THEN
									
									IF IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_LINEAR OR _pDoParamString.ParamString[_wActRefIdx].wFunction_ID = IFmnParam.Out.Edit.wFilterFunctionID THEN
	
										// Schreib- und Leserechte ermitteln. Sie können vererbt sein!
										_GetAccessRights(Enable := TRUE, siWriteAccess := _pDoParamString.ParamString[_wActRefIdx].siWriteAccess, 
										siReadAccess := _pDoParamString.ParamString[_wActRefIdx].siVisibleAccess, 
										wReference := _pDoParamString.ParamString[_wActRefIdx].wReferenz, 
										lPtrLogicStruct := _PmIntern.DataObjects.Adress.lLogicalStruct, 
										wMaxIdxLogicStruct := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct));
	
										IF _GetAccessRights.bReadAccess <= IFmnParam.In.Edit.bUserLevel THEN
											
											_wCntParams := _wCntParams + 1;
											
										END_IF

									END_IF
									
								END_IF
								
							END_IF	

							_wActIdx := _wActIdx + 1;
							
							UNTIL
							
							_PmIntern.CSVDataObjects.MaxIndex.lCSVString < _wActIdx
							
						END_REPEAT

						IFmnParam.Out.Edit.wRowStrCntAll := _wCntParams;
						
						IF _wCntParams >= (IFmnParam.In.Edit.wRowStrOffset + IFmnParam.In.Edit.bCntStrRows) THEN
							IFmnParam.In.Edit.wRowStrOffset := IFmnParam.In.Edit.wRowStrOffset;
						ELSIF _wCntParams >= (IFmnParam.In.Edit.bCntStrRows) THEN
							IFmnParam.Out.Edit.wRowStrOffset := _wCntParams - IFmnParam.In.Edit.bCntStrRows;
						ELSE
							IFmnParam.Out.Edit.wRowStrOffset := 0;
						END_IF
						
						IF IFmnParam.Out.Edit.wRowStrCntAll > 0 THEN
						
							_wActRow := 1;
							_wActIdx := 1;
							_wCntParams := 0;
	
							REPEAT
	
								// Nur ausführen, wenn _wActIdx zulässig ist
								IF _wActIdx <= _PmIntern.CSVDataObjects.MaxIndex.lCSVString THEN
								
									// Referenz auf Parameterbeschreibung auslesen
									_wActRefIdx := _pDoContainerString.CsvString[_wActIdx].wIdxStringPar;
									
									// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
									IF _wActRefIdx <= _PmIntern.DataObjects.MaxIndex.lParamString THEN
										
										IF IFmnParam.In.Edit.bSelectModeNum = MNPARAM_SELECTMODE_LINEAR OR _pDoParamString.ParamString[_wActRefIdx].wFunction_ID = IFmnParam.Out.Edit.wFilterFunctionID THEN

											// Schreib- und Leserechte ermitteln. Sie können vererbt sein!
											_GetAccessRights(Enable := TRUE, siWriteAccess := _pDoParamString.ParamString[_wActRefIdx].siWriteAccess, 
											siReadAccess := _pDoParamString.ParamString[_wActRefIdx].siVisibleAccess, 
											wReference := _pDoParamString.ParamString[_wActRefIdx].wReferenz, 
											lPtrLogicStruct := _PmIntern.DataObjects.Adress.lLogicalStruct, 
											wMaxIdxLogicStruct := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct));
		
											IF _GetAccessRights.bReadAccess <= IFmnParam.In.Edit.bUserLevel THEN
		
												IF _wCntParams >= IFmnParam.Out.Edit.wRowStrOffset THEN
		
													IFmnParam.Out.Edit.AttrStr[_wActRow].bReadAccess := _GetAccessRights.bReadAccess;
													IFmnParam.Out.Edit.AttrStr[_wActRow].bWriteAccess := _GetAccessRights.bWriteAccess;
			
													// ***************ACTION***************
													_actFillEditStr;
													// ***************ACTION***************
			
													IFmnParam.Out.Edit.bCntStrRows := UINT_TO_USINT(_wActRow);
												
													_wActRow := _wActRow + 1;
		
												END_IF
												
												_wCntParams := _wCntParams + 1;
												
											END_IF

										END_IF	
											
									END_IF
									
								END_IF
								
								_wActIdx := _wActIdx + 1;
								
								UNTIL
								
								_PmIntern.CSVDataObjects.MaxIndex.lCSVString < _wActIdx OR _wActRow > MIN(MNPARAM_CNT_EDITROWS, IFmnParam.In.Edit.bCntStrRows)
								
							END_REPEAT

						END_IF	
							
					ELSIF IFmnParam.In.Edit.bSelectModeStr = MNPARAM_SELECTMODE_BYIDX THEN

						IFmnParam.Out.Edit.wRowStrOffset := 0;
						IFmnParam.Out.Edit.bCntStrRows := UINT_TO_USINT(MIN(MNPARAM_CNT_EDITROWS, IFmnParam.In.Edit.bCntStrRows));
						
						FOR _ii := 1 TO IFmnParam.Out.Edit.bCntStrRows DO

							_wActRow := _ii;
							
							// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
							IF IFmnParam.In.Edit.wSelParIdxStr[_wActRow] <= _PmIntern.DataObjects.MaxIndex.lParamString AND IFmnParam.In.Edit.wSelParIdxStr[_wActRow] > 0 THEN

								_wActRefIdx := IFmnParam.In.Edit.wSelParIdxStr[_wActRow];

								// Suche Parameter-Containerindex anhand des Parameterindex und der 4 möglichen Array-Werte
								_binarySearchString.enable := TRUE;
								_binarySearchString.CsvStructString.wIdxStringPar 	:= IFmnParam.In.Edit.wSelParIdxStr[_wActRow];
								_binarySearchString.CsvStructString.wArrIdx1 		:= IFmnParam.In.Edit.wSelParArrIdxStr[_wActRow,1];
								_binarySearchString.CsvStructString.wArrIdx2 		:= IFmnParam.In.Edit.wSelParArrIdxStr[_wActRow,2];
								_binarySearchString.CsvStructString.wArrIdx3 		:= IFmnParam.In.Edit.wSelParArrIdxStr[_wActRow,3];
								_binarySearchString.CsvStructString.wArrIdx4 		:= IFmnParam.In.Edit.wSelParArrIdxStr[_wActRow,4];
								_binarySearchString.lpList 							:= _PmIntern.CSVDataObjects.Adress.lCSVString;
								_binarySearchString.lMaxRow 						:= _PmIntern.CSVDataObjects.MaxIndex.lCSVString;

								_binarySearchString();

								// Wurde der Parameter im Container gefunden ?
								IF _binarySearchString.status = ERR_OK THEN
									
									_wActIdx := UDINT_TO_UINT(_binarySearchString.lFoundRow);

									// Schreib- und Leserechte ermitteln. Sie können vererbt sein!
									_GetAccessRights(Enable := TRUE, siWriteAccess := _pDoParamString.ParamString[_wActRefIdx].siWriteAccess, 
									siReadAccess := _pDoParamString.ParamString[_wActRefIdx].siVisibleAccess, 
									wReference := _pDoParamString.ParamString[_wActRefIdx].wReferenz, 
									lPtrLogicStruct := _PmIntern.DataObjects.Adress.lLogicalStruct, 
									wMaxIdxLogicStruct := UDINT_TO_UINT(_PmIntern.DataObjects.MaxIndex.lLogicalStruct));

									IF _GetAccessRights.bReadAccess <= IFmnParam.In.Edit.bUserLevel THEN

										IFmnParam.Out.Edit.AttrStr[_wActRow].bReadAccess := _GetAccessRights.bReadAccess;
										IFmnParam.Out.Edit.AttrStr[_wActRow].bWriteAccess := _GetAccessRights.bWriteAccess;

										// ***************ACTION***************
										_actFillEditStr;
										// ***************ACTION***************

									END_IF

								END_IF

							END_IF
							
						END_FOR
							
					END_IF

				END_IF
						
				_PmIntern.enCycFillEditor := cs_feRdySuccess;
			
			cs_feRdyFault:
				
			// Mit Fehler beendet
				
			cs_feRdySuccess:
				
				// Erfolgreich beendet
			
		END_CASE
		

		//*********************************************************************************************
		// Statemachine zum Sichern der Daten des Editiors
		//*********************************************************************************************
			
		CASE _PmIntern.enCycSaveEditor OF
				
			cs_seIdle:
				
			cs_seStart:
	
				_DefineActContainer(Enable := TRUE, bContainerIdx := IFmnParam.In.Edit.bContainer, wInstanceIdx := DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance), pIntern := ADR(_PmIntern));
	
				IF _DefineActContainer.Status = ERR_OK THEN
	
					// Container Parameter sind im gültigen Bereich und die Containerspec. ist ok
						
					IF 	(_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[IFmnParam.In.Edit.bContainer] + (DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance) - _PmIntern.ActContainer.wMinBound)].xExist 
						AND _PmIntern.ActContainer.bDirect = 0) 
						OR
						(_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[IFmnParam.In.Edit.bContainer]].xExist AND _PmIntern.ActContainer.bDirect = 1) THEN
							
						// Die Containerinstanz existiert
							
						_diCSVNum(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameNum));
					
						IF _diCSVNum.status = ERR_OK THEN
								
							// Datenobjekt mit aktuellen numerischen Parametern wurde gefunden
						
							_PmIntern.CSVDataObjects.Adress.lCSVNum := _diCSVNum.pDatObjMem;
							_PmIntern.CSVDataObjects.Size.lCSVNum := _diCSVNum.len;
							_PmIntern.CSVDataObjects.Idents.lCSVNum := _diCSVNum.ident;
						
							_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
						
							IF NOT _pDoContainerNum.Header.Container.xWriteProtected THEN
							
								_PmIntern.CSVDataObjects.MaxIndex.lCSVNum := ( (_pDoContainerNum.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerNum.CsvNum[1]) );
		
								_diCSVString(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));
						
								IF _diCSVString.status = ERR_OK THEN
							
									// Datenobjekt mit aktuellen String Parametern wurde gefunden
		
									_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
									_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
									_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
							
									_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
							
									_PmIntern.CSVDataObjects.MaxIndex.lCSVString := ( (_pDoContainerString.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoContainerString.CsvString[1]) );
		
									IF _PmIntern.ActContainer.bDirect = 0 THEN
			
										_diDO(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoName));
						
										IF _diDO.status = ERR_OK THEN
							
											_PmIntern.CSVDataObjects.Adress.lDataObjekt := _diDO.pDatObjMem;
											_PmIntern.CSVDataObjects.Size.lDataObjekt := _diDO.len;
											_PmIntern.CSVDataObjects.Idents.lDataObjekt := _diDO.ident;
											
											IF  (PV_xgetadr(ADR(_PmIntern.ActContainer.sStrucRoot), ADR(_lPVadress), ADR(_lPVlen)) = ERR_OK) THEN

												_PmIntern.ActContainer.lAdressStructRoot := _lPVadress;
												_PmIntern.ActContainer.lSizeStructRoot := _lPVlen;

												_PmIntern.CSVDataObjects.TempAdresses.lDataObjekt := _lPVadress;
												_PmIntern.CSVDataObjects.Size.lDataObjekt := _lPVlen;
							
												_PmIntern.enCycSaveEditor := cs_seReadContainer;
												
											ELSE
												
												_PmIntern.Status.wMsgClass := 10;
												_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
												_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
												_PmIntern.Status.diMsgAttr2 := 0;
												brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt),ADR(_PmIntern.ActContainer.sStrucRoot));
												_PmIntern.Status.wMsgAckLevel := 0;
							
												_PmIntern.enCycSaveEditor := cs_seRdyFault;

											END_IF
							
										ELSIF _diDO.status <> ERR_FUB_BUSY THEN
		
											_PmIntern.Status.wMsgClass := 10;
											_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
											_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
											_PmIntern.Status.diMsgAttr2 := 0;
											brsstrcpy(ADR(_PmIntern.Status.sMsgAttrTxt),ADR(_PmIntern.ActContainer.sDoName));
											_PmIntern.Status.wMsgAckLevel := 0;
							
											_PmIntern.enCycSaveEditor := cs_seRdyFault;
							
										END_IF
										
									ELSE
										
										_PmIntern.enCycSaveEditor := cs_seReadContainer;
										
									END_IF
										
								ELSIF _diCSVString.status <> ERR_FUB_BUSY THEN
		
									_PmIntern.Status.wMsgClass := 10;
									_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
									_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
									_PmIntern.Status.diMsgAttr2 := 0;
									_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameString;
									_PmIntern.Status.wMsgAckLevel := 0;
							
									_PmIntern.enCycSaveEditor := cs_seRdyFault;
						
								END_IF
								
							ELSE

								_PmIntern.Status.wMsgClass := 10;
								_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_WRITEPROTECTED;
								_PmIntern.Status.diMsgAttr2 := 0;
								_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameNum;
								_PmIntern.Status.wMsgAckLevel := 0;
						
								_PmIntern.enCycSaveEditor := cs_seRdyFault;

							END_IF
								
						ELSIF _diCSVNum.status <> ERR_FUB_BUSY THEN
	
							_PmIntern.Status.wMsgClass := 10;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_SYSERROR;
							_PmIntern.Status.diMsgAttr2 := 0;
							_PmIntern.Status.sMsgAttrTxt := _PmIntern.ActContainer.sDoNameNum;
							_PmIntern.Status.wMsgAckLevel := 0;
						
							_PmIntern.enCycSaveEditor := cs_seRdyFault;
						
						END_IF
							
					ELSE
	
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
						_PmIntern.Status.diMsgAttr2 := 0;
						_PmIntern.Status.wMsgAckLevel := 0;
	
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_CONTINST_NOT_EXIST;
							
						_PmIntern.enCycSaveEditor := cs_seRdyFault;
							
					END_IF
	
				ELSE
	
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
					_PmIntern.Status.diMsgAttr1 := _DefineActContainer.Status;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
	
					_PmIntern.enCycSaveEditor := cs_seRdyFault;
	
				END_IF
	
			cs_seReadContainer:
			// Daten in den temporären Speicher laden		
	
				_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.CSVDataObjects.Size.lCSVNum);
					
				IF _MemPartAlloc.status = ERR_OK THEN
						
					_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := _MemPartAlloc.mem;
					
					_drCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := 0, pDestination := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum, len := _PmIntern.CSVDataObjects.Size.lCSVNum);
					
					IF _drCSVNum.status = ERR_OK THEN
						
						_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVNum;
						
						_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := _PmIntern.CSVDataObjects.Size.lCSVString);
					
						IF _MemPartAlloc.status = ERR_OK THEN
						
							_PmIntern.CSVDataObjects.TempAdresses.lCSVString := _MemPartAlloc.mem;
						
							_drCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := 0, pDestination := _PmIntern.CSVDataObjects.TempAdresses.lCSVString, len := _PmIntern.CSVDataObjects.Size.lCSVString);
					
							IF _drCSVString.status = ERR_OK THEN
		
								_pDoContainerString ACCESS _PmIntern.CSVDataObjects.TempAdresses.lCSVString;
						
								IF _PmIntern.ActContainer.bDirect  = 1 THEN
		
									_PmIntern.enCycSaveEditor := cs_seCommit;
	
								ELSE
							
									_drDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, Offset := 0, pDestination := _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt, len := _PmIntern.CSVDataObjects.Size.lDataObjekt);
					
									IF _drDO.status = ERR_OK THEN
						
										_PmIntern.enCycSaveEditor := cs_seCommit;
					
									ELSE
	
										_PmIntern.Status.wMsgClass := 10;
										_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
										_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPREADBIN;
										_PmIntern.Status.diMsgAttr2 := 0;
										_PmIntern.Status.wMsgAckLevel := 0;
				
										_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
										_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
				
										_PmIntern.enCycSaveEditor := cs_seRdyFault;
	
									END_IF
	
							
								END_IF
					
							ELSE
	
								_PmIntern.Status.wMsgClass := 10;
								_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
								_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPREADSTR;
								_PmIntern.Status.diMsgAttr2 := 0;
								_PmIntern.Status.wMsgAckLevel := 0;
	
								_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
								_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
				
								_PmIntern.enCycSaveEditor := cs_seRdyFault;
	
							END_IF
	
						
						ELSE
	
							_PmIntern.Status.wMsgClass := 10;
							_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
							_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPALLOCMEMS;
							_PmIntern.Status.diMsgAttr2 := 0;
							_PmIntern.Status.wMsgAckLevel := 0;
				
							_MemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
							
							_PmIntern.enCycSaveEditor := cs_seRdyFault;
	
						END_IF
	
					
					ELSE
	
						_PmIntern.Status.wMsgClass := 10;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPREADNUM;
						_PmIntern.Status.diMsgAttr2 := 0;
						_PmIntern.Status.wMsgAckLevel := 0;
				
						_PmIntern.enCycSaveEditor := cs_seRdyFault;
	
					END_IF
	
				ELSE
	
					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPALLOCMEMN;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
				
					_PmIntern.enCycSaveEditor := cs_seRdyFault;
	
				END_IF
	
			cs_seCommit:
			
			// Daten in die Datenobjekte schreiben
			
				_binarySearchNum.enable := TRUE;
				_binarySearchNum.lpList := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum;
				_binarySearchNum.lMaxRow := _PmIntern.CSVDataObjects.MaxIndex.lCSVNum;
	
				_binarySearchString.enable := TRUE;
				_binarySearchString.lpList := _PmIntern.CSVDataObjects.TempAdresses.lCSVString;
				_binarySearchString.lMaxRow := _PmIntern.CSVDataObjects.MaxIndex.lCSVString;
	
				_xNumDirty := FALSE;
	
				IF _PmIntern.CSVDataObjects.MaxIndex.lCSVNum > 0 AND IFmnParam.In.Edit.bCntNumRows > 0 AND IFmnParam.In.Edit.bCntNumRows <= MNPARAM_CNT_EDITROWS THEN
	
	
					FOR _i := 1 TO IFmnParam.Out.Edit.bCntNumRows DO
	
						IF _EditNumValues.xSave[_i] THEN
							
							_xNumDirty := TRUE;
							
						END_IF
					
					END_FOR
					
					IF _xNumDirty THEN
	
						FOR _i := 1 TO IFmnParam.Out.Edit.bCntNumRows DO
							
							_wActRow := _i;
							_wActIdx := _EditNumValues.wIdx[_i];
							
							IF _wActIdx > 0 AND _wActIdx <= _PmIntern.CSVDataObjects.MaxIndex.lCSVNum AND _EditNumValues.xSave[_wActRow] THEN
								
								_wActRefIdx := _pDoContainerNum.CsvNum[_wActIdx].wIdxNumPar;
									
								// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
								IF _wActRefIdx <= _PmIntern.DataObjects.MaxIndex.lParamNum THEN
	
									IF _pDoParamNum.ParamNum[_wActRefIdx].bRowType = 0 THEN
										_rValue := kgUnitconfDisplayToREAL(_EditNumValues.rVal[_wActRow], _pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit);
										_pDoContainerNum.CsvNum[_wActIdx].diValue := LIMIT(_pDoParamNum.ParamNum[_wActRefIdx].diMinValue, REAL_TO_DINT(_rValue), _pDoParamNum.ParamNum[_wActRefIdx].diMaxValue);
									ELSE
										_prMinValue ACCESS ADR(_pDoParamNum.ParamNum[_wActRefIdx].diMinValue);
										_prMaxValue ACCESS ADR(_pDoParamNum.ParamNum[_wActRefIdx].diMaxValue);
										_rValue := LIMIT(_prMinValue,kgUnitconfDisplayToREAL(_EditNumValues.rVal[_wActRow], _pDoParamNum.ParamNum[_wActRefIdx].wUnitID,IFmnParam.In.Edit.bLocUnit),_prMaxValue);
										_prValue ACCESS ADR(_pDoContainerNum.CsvNum[_wActIdx].diValue);
										_prValue := _rValue;
									END_IF
	
									_pDoContainerNum.CsvNum[_wActIdx].xChanged := _pDoParamNum.ParamNum[_wActRefIdx].diDefValue <> _pDoContainerNum.CsvNum[_wActIdx].diValue;
									
									_PN := _pDoParamNum.ParamNum[_wActRefIdx];
									_CN := _pDoContainerNum.CsvNum[_wActIdx];
	
									GetArrayPV(pPV := ADR(_PN.sAdresse), pStructRoot := ADR(_PmIntern.ActContainer.sStrucRoot), pPVFilled := ADR(_sPVAdress), idx1 :=_CN.wArrIdx1, idx2:=_CN.wArrIdx2, idx3:=_CN.wArrIdx3, idx4:=_CN.wArrIdx4);
																			
									IF _CN.bRowType = 0 THEN
	
										_WritePVNum(pAdress := ADR(_sPVAdress), diValue := _CN.diValue);
	
									ELSE
								
										_prValue ACCESS ADR(_CN.diValue);
										_WritePVrNum(pAdress := ADR(_sPVAdress), rValue := _prValue);
								
									END_IF
	
								END_IF
								
								_EditNumValues.xSave[_wActRow] := FALSE;
		
							END_IF
							
						END_FOR
						
					END_IF
				
				END_IF
	
				IF _PmIntern.CSVDataObjects.MaxIndex.lCSVString > 0 AND IFmnParam.In.Edit.bCntStrRows > 0 AND IFmnParam.In.Edit.bCntNumRows <= MNPARAM_CNT_EDITROWS THEN
	
					_xStrDirty := FALSE;
	
					FOR _i := 1 TO IFmnParam.Out.Edit.bCntStrRows DO
	
						IF _EditStrValues.xSave[_i] THEN
							
							_xStrDirty := TRUE;
							
						END_IF
					
					END_FOR
					
					IF _xStrDirty THEN
	
						FOR _i := 1 TO IFmnParam.Out.Edit.bCntStrRows DO
							
							_wActRow := _i;
							_wActIdx := _EditStrValues.wIdx[_i];
							
							IF _wActIdx > 0 AND _wActIdx <= _PmIntern.CSVDataObjects.MaxIndex.lCSVString AND _EditStrValues.xSave[_wActRow] THEN
								
								_wActRefIdx := _pDoContainerString.CsvString[_wActIdx].wIdxStringPar;
									
								// Ist die Referenz zulässig, d.h. ist der Parameter im Modell definiert?
								IF _wActRefIdx <= _PmIntern.DataObjects.MaxIndex.lParamString THEN
	
									_pDoContainerString.CsvString[_wActIdx].utfValue := _EditStrValues.utfVal[_wActRow];
									_pDoContainerString.CsvString[_wActIdx].xChanged := brwcscmp(ADR(_pDoParamString.ParamString[_wActRefIdx].utfDefValue),ADR(_pDoContainerString.CsvString[_wActIdx].utfValue)) <> 0;
	
									_PS := _pDoParamString.ParamString[_wActRefIdx];
									_CS := _pDoContainerString.CsvString[_wActIdx];
									
									GetArrayPV(pPV := ADR(_PS.sAdresse), pStructRoot := ADR(_PmIntern.ActContainer.sStrucRoot), pPVFilled := ADR(_sPVAdress), idx1 :=_CS.wArrIdx1, idx2:=_CS.wArrIdx2, idx3:=_CS.wArrIdx3, idx4:=_CS.wArrIdx4);
									
									IF _wActRefIdx = MNPARAM_PARIDX_MACHINENAME AND ABS(_PmIntern.ActContainer.siContainerID) = MNPARAM_IDX_MACHINENAMECONTAINER THEN
										mnParamStatAd.utfMachineName := _CS.utfValue;
									END_IF

									_WritePVString(pAdress := ADR(_sPVAdress), p_utfValue := ADR(_CS.utfValue));
	
								END_IF
								
								_EditStrValues.xSave[_wActRow] := FALSE;
		
							END_IF
							
						END_FOR
						
					END_IF
				
				END_IF
	
				IF _xNumDirty OR _xStrDirty THEN
					
					_DTGetTime(enable := TRUE);
					
					_pDoContainerNum.Header.Time.dtTimestamp := _DTGetTime.DT1;
					_pDoContainerString.Header.Time.dtTimestamp := _DTGetTime.DT1;
					
					IF _PmIntern.ActContainer.bDirect = 0 THEN
						
						_PmIntern.enCycSaveEditor := cs_seWriteDoBin;
						
					ELSE
						
						_PmIntern.enCycSaveEditor := cs_seWriteDoNum;
						
					END_IF
	
				ELSE	
					
					_PmIntern.enCycSaveEditor := cs_seFreeMem;
					
				END_IF
			
			cs_seWriteDoBin:
				
				_dwDO(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lDataObjekt, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lDataObjekt, len := _PmIntern.CSVDataObjects.Size.lDataObjekt);				
				
				IF _dwDO.status = ERR_OK THEN
						
					_PmIntern.enCycSaveEditor := cs_seWriteDoNum;
						
				ELSIF _dwDO.status <> ERR_FUB_BUSY THEN
						
					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPWRITEBIN;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
				
					_PmIntern.enCycSaveEditor := cs_seFreeMem;
						
				END_IF
			
			cs_seWriteDoNum:
				
				_dwCSVNum(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVNum, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum, len := _PmIntern.CSVDataObjects.Size.lCSVNum);				
				
				IF _dwCSVNum.status = ERR_OK THEN
						
					_PmIntern.enCycSaveEditor := cs_seWriteDoString;
					_pDoContainerNum ACCESS _PmIntern.CSVDataObjects.Adress.lCSVNum;
						
				ELSIF _dwCSVNum.status <> ERR_FUB_BUSY THEN
						
					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPWRITENUM;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
				
					_PmIntern.enCycSaveEditor := cs_seFreeMem;
						
				END_IF
	
			cs_seWriteDoString:
			
				_dwCSVString(enable := TRUE, ident := _PmIntern.CSVDataObjects.Idents.lCSVString, Offset := 0, pSource := _PmIntern.CSVDataObjects.TempAdresses.lCSVString, len := _PmIntern.CSVDataObjects.Size.lCSVString);				
				
				IF _dwCSVString.status = ERR_OK THEN
						
					_PmIntern.enCycSaveEditor := cs_seFreeMem;
					_pDoContainerString ACCESS _PmIntern.CSVDataObjects.Adress.lCSVString;
						
				ELSIF _dwCSVString.status <> ERR_FUB_BUSY THEN
						
					_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
					_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_IMPWRITESTR;
					_PmIntern.Status.diMsgAttr2 := 0;
					_PmIntern.Status.wMsgAckLevel := 0;
				
					_PmIntern.enCycSaveEditor := cs_seFreeMem;
						
				END_IF
			
			cs_seFreeMem:
			
				IF _PmIntern.CSVDataObjects.TempAdresses.lCSVNum <> 0 THEN
					
					_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVNum);
					_PmIntern.CSVDataObjects.TempAdresses.lCSVNum := 0;
					
					IF _MemPartFree.status <> ERR_OK AND _PmIntern.Status.wMsgNumber = 0 THEN
						
						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_FREEMEM;
						_PmIntern.Status.diMsgAttr2 := _MemPartFree.status;
						_PmIntern.Status.wMsgAckLevel := 0;
	
					END_IF
					
				END_IF
	
				IF _PmIntern.CSVDataObjects.TempAdresses.lCSVString <> 0 THEN
					
					_MemPartFree(enable := TRUE, ident  := _MemPartCreate.ident, mem := _PmIntern.CSVDataObjects.TempAdresses.lCSVString);
					_PmIntern.CSVDataObjects.TempAdresses.lCSVString := 0;
	
					IF _MemPartFree.status <> ERR_OK AND _PmIntern.Status.wMsgNumber = 0 THEN
						
						_PmIntern.Status.wMsgClass := MNMSG_CLASS_WARNING;
						_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
						_PmIntern.Status.diMsgAttr1 := MNPARAM_STAT_FREEMEM;
						_PmIntern.Status.diMsgAttr2 := _MemPartFree.status;
						_PmIntern.Status.wMsgAckLevel := 0;
	
					END_IF
	
				END_IF
	
				IF _PmIntern.Status.wMsgNumber <> 0 THEN
							
					IF _PmIntern.Status.diMsgAttr1 = 0 THEN
						_PmIntern.Status.diMsgAttr1 := 59999;
					END_IF
					_PmIntern.enCycSaveEditor := cs_seRdyFault;
	
				ELSE
					
					_PmIntern.enCycSaveEditor := cs_seExpCSV;
							
				END_IF
	
			cs_seExpCSV:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				_PmIntern.ExpSettings.sFilename := _PmIntern.ActContainer.sCsvName;
				
				_ec(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ec.Status = ERR_OK THEN
					
					_PmIntern.enCycSaveEditor := cs_seTOC;
					
				ELSIF _ec.Status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
					_PmIntern.Status.diMsgAttr1 := _ec.Status;
					_PmIntern.Status.diMsgAttr2 := _ec.AdStatus;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycSaveEditor := cs_seRdyFault;

				END_IF
				
			cs_seTOC:
			
				_PmIntern.ExpSettings.sCfDeviceName := KG_DEVICE_COMPACTFLASH;
				_PmIntern.ExpSettings.sPath := MNPARAM_PATH_EXPORT;
				
				_ExportTableOfContent(Enable := TRUE, pIntern := ADR(_PmIntern));
			
				IF _ExportTableOfContent.Status = ERR_OK THEN
					
					mnParamStatAd.dtExportContent := _ExportTableOfContent.dtTocWritten;
					
					_PmIntern.enCycSaveEditor := cs_seRdySuccess;
					
				ELSIF _ExportTableOfContent.Status <> ERR_FUB_BUSY THEN

					_PmIntern.Status.wMsgClass := 10;
					_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_SAVEEDITOR;
					_PmIntern.Status.diMsgAttr1 := _ExportTableOfContent.Status;
					_PmIntern.Status.diMsgAttr2 := _ExportTableOfContent.AdStatus;
					_PmIntern.Status.wMsgAckLevel := 0;

					_PmIntern.enCycSaveEditor := cs_seRdyFault;

				END_IF
			
			cs_seRdyFault:
				
			// Mit Fehler beendet
				
			cs_seRdySuccess:
				
				// Erfolgreich beendet
				
		END_CASE
		
		// ===========================
		// Logging
		// ===========================
	
		IF _xRBReady THEN
		
			CASE _wLogStep OF
			
				0:
					_ReadRB(wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart, wPtrWrite := _wPtrRBwrite);
			
					IF _ReadRB.wStatus = ERR_OK THEN
					
						CASE _LogEntry.wErrorNo OF
						
							0:
								_PmIntern.Logger.text := 'OK';
								
							_MNPARAM_LOG_STARTIMPORT:	

								IF _LogEntry.lAttr2 = MNPARAM_IMPORT_DIFFERENCE THEN
									_PmIntern.Logger.text := 'Start Import from {##AttrVar1}';
								ELSE
									_PmIntern.Logger.text := 'Start Restore from {##AttrVar1}';
								END_IF
								
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;

							_MNPARAM_LOG_STARTDELETE:

								_PmIntern.Logger.text := 'Start Delete Container {##AttrVar1}, Instance {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;
								
							_MNPARAM_LOG_ENDIMPORT_SUCC:
								
								_PmIntern.Logger.text := 'Restore/Import OK';

							_MNPARAM_LOG_ENDIMPORT_FAILED:
								
								_PmIntern.Logger.text := 'Restore/Import Failed: {##AttrVar1}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;

							_MNPARAM_LOG_ENDDELETE_SUCC:
								
								_PmIntern.Logger.text := 'Delete OK';

							_MNPARAM_LOG_ENDDELETE_FAILED:
								
								_PmIntern.Logger.text := 'Delete Failed: {##AttrVar1}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;

							_MNPARAM_LOG_STARTSAVE:
								
								_PmIntern.Logger.text := 'Start Save.';

							_MNPARAM_LOG_ENDSAVE_SUCC:
								
								_PmIntern.Logger.text := 'Save OK';

							_MNPARAM_LOG_ENDSAVE_FAILED:
								
								_PmIntern.Logger.text := 'Save Failed: {##AttrVar1}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								
							_MNPARAM_LOG_FOUNDFILES:
								
								_PmIntern.Logger.text := 'Found {##AttrVar1} File(s)';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								
							_MNPARAM_LOG_FOUNDFILE:

								_PmIntern.Logger.text := 'Found Container {##AttrVar1} Index {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;

							_MNPARAM_LOG_WRONGMACHINENO:

								_PmIntern.Logger.text := 'Wrong Machineno. Container {##AttrVar1} Index {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;

							_MNPARAM_LOG_WRONGMACHINETYPE:

								_PmIntern.Logger.text := 'Wrong Machinetype Container {##AttrVar1} Index {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;

							_MNPARAM_LOG_NOVERSION:

								_PmIntern.Logger.text := 'No Version in Container {##AttrVar1} Index {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;

							_MNPARAM_LOG_CNTLINES:

								_PmIntern.Logger.text := 'Fault at counting lines Container {##AttrVar1} Index {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;
								
							_MNPARAM_LOG_WRITEPROTECTED:

								_PmIntern.Logger.text := 'Write protected Container {##AttrVar1} Index {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;

							_MNPARAM_LOG_SYSTEMFAULT:

								_PmIntern.Logger.text := 'System fault Container {##AttrVar1} Index {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;
								
							_MNPARAM_LOG_STARTRESTORE:

								_PmIntern.Logger.text := 'Start Restore';

							_MNPARAM_LOG_STARTBACKUP:

								_PmIntern.Logger.text := 'Start Backup';

							_MNPARAM_LOG_ENDRESTORE_SUCC:
								
								_PmIntern.Logger.text := 'Restore OK';

							_MNPARAM_LOG_ENDRESTORE_FAILED:
								
								_PmIntern.Logger.text := 'Restore Failed: {##AttrVar1}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;

							_MNPARAM_LOG_ENDBACKUP_SUCC:
								
								_PmIntern.Logger.text := 'Backup OK';

							_MNPARAM_LOG_ENDBACKUP_FAILED:
								
								_PmIntern.Logger.text := 'Backup Failed: {##AttrVar1}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;

							_MNPARAM_LOG_STARTCREATE:

								_PmIntern.Logger.text := 'Start Create Container {##AttrVar1}, Instance {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;

							_MNPARAM_LOG_ENDCREATE_SUCC:
								
								_PmIntern.Logger.text := 'Create OK';

							_MNPARAM_LOG_ENDCREATE_FAILED:
								
								_PmIntern.Logger.text := 'Create Failed: {##AttrVar1}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;

							_MNPARAM_LOG_STARTCOPY:

								_PmIntern.Logger.text := 'Start Copy Container {##AttrVar1}, Instance {##AttrVar2}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;

							_MNPARAM_LOG_ENDCOPY_SUCC:
								
								_PmIntern.Logger.text := 'Copy OK';

							_MNPARAM_LOG_ENDCOPY_FAILED:
								
								_PmIntern.Logger.text := 'Copy Failed: {##AttrVar1}';
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;

							_MNPARAM_LOG_ROOTVAR:

								_PmIntern.Logger.text := 'Wrong rootvariable!';

							ELSE
							
								_PmIntern.Logger.text := UINT_TO_STRING(_LogEntry.wErrorNo);
								_PmIntern.Logger.text := CONCAT(_PmIntern.Logger.text, ' : {##AttrVar1} / {##AttrVar2}');
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;
			
						END_CASE
					
						_wLogStep := 1;
					
					END_IF

				1:
					_PmIntern.Logger.logLevel := arlogLEVEL_INFO;
					_PmIntern.Logger();
				
					IF _PmIntern.Logger.status <> ERR_FUB_BUSY THEN
					
						_wLogStep := 0;
					
					END_IF
				
			END_CASE
		
		END_IF
		
		IFmnParam.Out.Edit.wCntFilesImportFailed := mnParamStatAd.wCntFilesImportFailed;
		IFmnParam.Out.Edit.wCntFilesImportFound := mnParamStatAd.wCntFilesImportFound;
		IFmnParam.Out.Edit.wCntFilesImportOK := mnParamStatAd.wCntFilesImportOK;

	ELSIF NOT _xModelImportChecked THEN

		IF IFmnSystem.Out.xUSBStickScanned THEN
		
			IF IFmnSystem.Out.xUSBStickReady THEN
				
				_actImpModel;
				
			ELSE
			
				_xParamOK := NOT _xSysError AND NOT IFmnParam.Out.xRequestMachineNumber;
				_xModelImportChecked := TRUE;
	
			END_IF

		END_IF
		
		// ===========================
		// Logging
		// ===========================
	
		IF _xRBReady THEN
		
			CASE _wLogStep OF
			
				0:
					_ReadRB(wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart, wPtrWrite := _wPtrRBwrite);
			
					IF _ReadRB.wStatus = ERR_OK THEN
					
						CASE _LogEntry.wErrorNo OF
						
							0:
								_PmIntern.Logger.text := 'OK';

							ELSE
							
								_PmIntern.Logger.text := UINT_TO_STRING(_LogEntry.wErrorNo);
								_PmIntern.Logger.text := CONCAT(_PmIntern.Logger.text, ' : {##AttrVar1} / {##AttrVar2}');
								_PmIntern.Logger.var1 := _LogEntry.lAttr1;
								_PmIntern.Logger.var2 := _LogEntry.lAttr2;
			
						END_CASE
					
						_wLogStep := 1;
					
					END_IF

				1:
					_PmIntern.Logger.logLevel := arlogLEVEL_INFO;
					_PmIntern.Logger();
				
					IF _PmIntern.Logger.status <> ERR_FUB_BUSY THEN
					
						_wLogStep := 0;
					
					END_IF
				
			END_CASE
		
		END_IF
	
	ELSIF IFmnParam.Out.xRequestMachineNumber THEN	

		CASE _cycStateWriteMno OF
		
			// Warte auf Befehl, die gesetzte Maschinennummer zu schreiben
			cs_WrMnoIdle:
				
				IF IFmnParam.In.xSetMachineNumber THEN
					
					_cycStateWriteMno := cs_WrMnoDelFile;
					
				END_IF
			
			// Lösche zunächst eine möglicherweise vorhandene Datei
			cs_WrMnoDelFile:	
				
				_FileMnoDelete(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH),  pName := ADR('PM\_mnr.csv'));
				
				IF _FileMnoDelete.status <> ERR_FUB_BUSY THEN

					_cycStateWriteMno := cs_WrMnoCreateFile;

				END_IF

			// Erzeuge die Maschinennummerdatei
			cs_WrMnoCreateFile:
				
				_FileMnoCreate(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH),  pFile := ADR('PM\_mnr.csv'));
				
				IF _FileMnoCreate.status = ERR_OK THEN

					_lAdrBuf := ADR(_bBufMno);
					_lSizeBuf := 0;
					
					_newMno.utfMachineNo := IFmnParam.In.utfSetMachineNumber;
					
					_WriteBOM(enable := TRUE, pMem := _lAdrBuf, lMaxSize := SIZEOF(_bBufMno), lSize := _lSizeBuf);
					_WriteMno(enable := TRUE, pMem := _lAdrBuf, lMaxSize := SIZEOF(_bBufMno), MachineNoRow := _newMno, lSize := _lSizeBuf);
					
					_cycStateWriteMno := cs_WrMnoWriteFile;
					
				ELSIF _FileMnoCreate.status <> ERR_FUB_BUSY THEN
					
					IFmnParam.Out.xRequestMachineNumber := FALSE;
					
				END_IF
			
			// Schreibe die Maschinennummer
			cs_WrMnoWriteFile:
				
				_FileMnoWrite(enable := TRUE, ident := _FileMnoCreate.ident, offset := 0, pSrc := ADR(_bBufMno), len := _lSizeBuf);
				
				IF _FileMnoWrite.status = ERR_OK THEN
					
					_cycStateWriteMno := cs_WrMnoCloseFile;
					
				ELSIF _FileMnoWrite.status <> ERR_FUB_BUSY THEN
					
					IFmnParam.Out.xRequestMachineNumber := FALSE;
					
				END_IF
					
			// Schließe Datei
			cs_WrMnoCloseFile:
				
				_FileMnoClose(enable := TRUE, ident := _FileMnoCreate.ident);
				
				IF _FileMnoClose.status = ERR_OK THEN
					
					_cycStateWriteMno := cs_WrMnoReset;
					
				ELSIF _FileMnoClose.status <> ERR_FUB_BUSY THEN
					
					_cycStateWriteMno := cs_WrMnoReset;
					
				END_IF
				
			// Warmstart
			cs_WrMnoReset:
				
				SYSreset(TRUE, 1);
				
				
		END_CASE
		
		
		
		_PmIntern.Status.wMsgClass := 10;
		_PmIntern.Status.wMsgNumber := MNPARAM_MSG_WARN_MISSINGMNO;
		_PmIntern.Status.diMsgAttr1 := 0;
		_PmIntern.Status.diMsgAttr2 := 0;
		_PmIntern.Status.wMsgAckLevel := 0;

	ELSE // Parametermanager ist nicht bereit
		
		brsmemset(ADR(mnParamStatAd), 0 , SIZEOF(mnParamStatAd));
		brsmemset(ADR(IFmnParam.Out), 0 , SIZEOF(IFmnParam.Out));

		
		_PmIntern.Status.wMsgClass := 10;
		_PmIntern.Status.wMsgNumber := MNPARAM_MSG_SYSTEMERROR;
		_PmIntern.Status.diMsgAttr1 := 0;
		_PmIntern.Status.diMsgAttr2 := 0;
		_PmIntern.Status.wMsgAckLevel := 0;

	END_IF
	
	IF NOT IFmnTest.Out.xNoMessages THEN
		
		kgMsgStatus[MNPARAM_MSGSTATIDX] := _PmIntern.Status;
		
	END_IF
	
	mnParamStatAd.xParamOK := _xParamOK;
	IFmnParam.Out.xParamOK := _xParamOK;
	
	mnParamStatAd.xModelImported := _xImpDMOK;
	IFmnParam.Out.xModelImported := _xImpDMOK;
	
	mnParamStatAd.xSystemfault := _xSysError AND _xModelImportChecked;
	IFmnParam.Out.xSystemfault := _xSysError AND _xModelImportChecked;

END_PROGRAM
