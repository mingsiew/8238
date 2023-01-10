(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _actImpModel.st
 * Author: hunholz
 * Created: June 04, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Datenmodell von USB-Stick importieren *)
ACTION _actImpModel: 
	
	CASE _wStateImportDatamodel OF

		0:	// USB Device erstellen
			_sDevString := CONCAT('/DEVICE=',IFmnSystem.Out.sInterfaceUSB);
			_DevLink(enable := TRUE, pDevice := ADR(_MNPARAM_TEMP_USBDEV), pParam := ADR(_sDevString));
			
			IF _DevLink.status = ERR_OK THEN
					
				_sImportDevice := _MNPARAM_TEMP_USBDEV;
				_lDevLinkHandle := _DevLink.handle;

				_wStateImportDatamodel := 10;
				
			ELSIF _DevLink.status <> ERR_FUB_BUSY THEN

				_xModelImportChecked := TRUE;
				_xParamOK := NOT _xSysError;
				
			END_IF

		10:	// Nach dem Pfad SetupKG suchen
			
			_DirInfo(enable := TRUE, pDevice := ADR(_sImportDevice), pPath := ADR(MNPARAM_PATH_IMPORTDATAMODEL));
			
			IF _DirInfo.status = ERR_OK THEN
					
				_xFoundDM := FALSE;
				_lDirNum := _DirInfo.dirnum;
				
				IF _xRBReady THEN
					_LogEntryIn.wErrorNo := _MNPARAM_LOG_FOUNDIMPDIR;
					_LogEntryIn.lAttr1 := _lDirNum;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
				END_IF
					
				IF _lDirNum = 0 THEN
						
					_wStateImportDatamodel := 999;
						
				ELSE
						
					_wStateImportDatamodel := 20;
						
				END_IF
					
			ELSIF _DirInfo.status <> ERR_FUB_BUSY THEN

				_wStateImportDatamodel := 999;

			END_IF
					
		20:		// Search for DataModel.csv
		
			_sTestFile := CONCAT(MNPARAM_PATH_IMPORTDATAMODEL,'\PM\DataModel.csv');
		
			_FileInfo(enable := TRUE, pDevice := ADR(_sImportDevice), pName := ADR(_sTestFile), pInfo := ADR(_fiDataModel));
		
			IF _FileInfo.status <> ERR_FUB_BUSY THEN
				
				_xFoundDM := _FileInfo.status = ERR_OK;					
				
				IF _xFoundDM THEN
					
					_wStateImportDatamodel := 40;
					
				ELSE

					_wStateImportDatamodel := 30;

				END_IF
				
				
			END_IF

		30:		// Search for _mnr.csv
		
			_sTestFile := CONCAT(MNPARAM_PATH_IMPORTDATAMODEL,'\PM\_mnr.csv');
		
			_FileInfo(enable := TRUE, pDevice := ADR(_sImportDevice), pName := ADR(_sTestFile), pInfo := ADR(_fiMNR));
		
			IF _FileInfo.status <> ERR_FUB_BUSY THEN
				
				_xFoundDM := _FileInfo.status = ERR_OK;					
					
				_wStateImportDatamodel := 40;
				
			END_IF

		40:		// Copy all
		
			_DirCopy(enable := TRUE, pSrcDev := ADR(_sImportDevice), pSrcDir := ADR(MNPARAM_PATH_IMPORTDATAMODEL), pDestDev := ADR(KG_DEVICE_COMPACTFLASH), pDestDir := ADR(''), option := fiOVERWRITE + fiRECURSIVE);

			IF _DirCopy.status <> ERR_FUB_BUSY THEN
				
				_xImpDMOK := _DirCopy.status = ERR_OK;
				
				_wStateImportDatamodel := 999;
				
			END_IF
		
		999:	// Device unlinken
			
			_DevUnlink(enable := TRUE, handle := _lDevLinkHandle);
				
			IF _DevUnlink.status <> ERR_FUB_BUSY THEN

				_wStateImportDatamodel := 65535;
				
				_xModelImportChecked := TRUE;
				
				IF NOT _xFoundDM AND _xImpDMOK THEN
					
					_xParamOK := NOT _xSysError;
					
				END_IF
					
			END_IF
		
	END_CASE
	
END_ACTION