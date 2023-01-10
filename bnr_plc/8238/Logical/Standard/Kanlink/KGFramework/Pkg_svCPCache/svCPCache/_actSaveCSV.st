(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: _actSaveCSV.st
 * Author: hunholz
 * Created: March 30, 2012
 ********************************************************************
 * Implementation of program svCPCache
 ********************************************************************) 

(* Schrittkette zum Speichern der Kategorie-Programm-Zuordnung *)
ACTION _actSaveCSV: 
	
	_wSaveCSVstatus := ERR_OK;
	
	CASE _enSave OF
		
		cs_SaveIdle:
		
			// Tue nichts

		cs_SaveCreateCSV:
			
			_SaveMemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident , len := _lMemLen);
			_lWriteSize := 0;
					
			IF _SaveMemPartAlloc.status = ERR_OK THEN
					
				_WriteBOM(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, lSize := _lWriteSize);
				
				// Kopfdaten schreiben
				_WriteComment(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, sComment := CONCAT('svCPCache Version: ',svCPCacheStatAd.sPkgVersion) , lSize := _lWriteSize);
				_WriteNewLine(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, lSize := _lWriteSize);

				_MachineNoRow.utfMachineNo := IFmnParam.Out.utfMachineNumber;
				_WriteMachineNo(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, MachineNoRow := _MachineNoRow, lSize := _lWriteSize);

				_WriteNewLine(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, lSize := _lWriteSize);

				_DTGetTime(enable := TRUE);
				_HeaderTimeRow.dtTimestamp := _DTGetTime.DT1;
					
				_WriteTimeStamp(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, TimeRow := _HeaderTimeRow, lSize := _lWriteSize);

				_WriteNewLine(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, lSize := _lWriteSize);
				
				FOR _sci := 1 TO SVCPCACHE_CNT_RELATIONS DO
						
					IF _CPCache[_sci].dtTimeStamp <> USINT_TO_DT(0) AND _CPCache[_sci].sCategory <> '' THEN
							
						_WriteCP(enable := TRUE, pMem := _SaveMemPartAlloc.mem, lMaxSize := _lMemLen, CPRow := _CPCache[_sci], lSize := _lWriteSize);

					END_IF
						
				END_FOR

				_sPathFile := CONCAT(_SVCPCACHE_CSV_PATH,_SVCPCACHE_CSV_FILE);
				
				_enSave := cs_SaveDeleteFile;
					
			ELSE
				
				_wSaveCSVstatus := SVCPCACHE_STAT_MEMALLOC;
				_enSave := cs_SaveRdyFault;
				
			END_IF

		cs_SaveDeleteFile:
		
			_FileDelete(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_sPathFile));
			
			IF _FileDelete.status <> ERR_FUB_BUSY THEN
				
				_enSave := cs_SaveCreateFile;
				
			END_IF
		
		//==============================================
		// Exportdatei erzeugen
		//==============================================
		cs_SaveCreateFile:
		
			
			
			_FileCreate(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPathFile) );

			IF _FileCreate.status = ERR_OK THEN

				_enSave := cs_SaveWriteFile;
		
			ELSIF _FileCreate.status <> ERR_FUB_BUSY THEN

				_SaveMemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _SaveMemPartAlloc.mem);
				
				_wSaveCSVstatus := SVCPCACHE_STAT_CREATEFILE;
				_enSave := cs_SaveRdyFault;
		
			END_IF

		//==============================================
		// Exportdatei öffnen
		//==============================================
		cs_SaveOpenFile:

			_FileOpen(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPathFile), mode := fiWRITE_ONLY);

			IF _FileOpen.status = ERR_OK THEN

				_enSave := cs_SaveWriteFile;
					
			ELSIF _FileOpen.status <> ERR_FUB_BUSY THEN

				_SaveMemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _SaveMemPartAlloc.mem);
				
				_wSaveCSVstatus := SVCPCACHE_STAT_OPENFILE;
				_enSave := cs_SaveRdyFault;
					
			END_IF
					

		//==============================================
		// Exportdatei schreiben
		//==============================================
		cs_SaveWriteFile:

			_FileWrite(enable := TRUE, ident := _FileCreate.ident, offset := 0, pSrc :=_SaveMemPartAlloc.mem, len := _lWriteSize);
				
			IF _FileWrite.status = ERR_OK THEN
					
				_SaveMemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _SaveMemPartAlloc.mem);
				_enSave := cs_SaveCloseFile;
					
			ELSIF _FileWrite.status <> ERR_FUB_BUSY THEN

				_SaveMemPartFree(enable := TRUE, ident := _MemPartCreate.ident, mem := _SaveMemPartAlloc.mem);

				_wSaveCSVstatus := SVCPCACHE_STAT_WRITEFILE;
				_enSave := cs_SaveCloseFile;
						
			END_IF				

		//==============================================
		// Exportdatei schließen
		//==============================================
		cs_SaveCloseFile:
					
			_FileClose(enable := TRUE, ident := _FileCreate.ident);

			IF _FileClose.status <> ERR_FUB_BUSY THEN

				IF _wSaveCSVstatus = ERR_OK THEN
					
					_enSave := cs_SaveRdySuccess;
					
				ELSE
					
					_enSave := cs_SaveRdyFault;
					
				END_IF

			END_IF

		cs_SaveRdyFault:
			
			// Mit Fehler beendet
		
		cs_SaveRdySuccess:
			
			// Erfolgreich beendet		
			
	END_CASE

END_ACTION