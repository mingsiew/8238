(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _actInterfaceApplication.st
 * Author: hunholz
 * Created: March 28, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Kommando-Interface zur Applikation über IFmnParam *)
ACTION _actInterfaceApplication: 
	
	CASE _PmIntern.enCycIfState OF
			
		cs_IfIdle:
				
			//*************************************************
			// Kein Applikations-Befehl aktiv. Warte auf Befehl
			//*************************************************

			CASE IFmnParam.In.Edit.wCommand OF
						
				MNPARAM_CMD_NOCOMMAND:
				
					IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_NOCOMMAND;
						
				MNPARAM_CMD_FILLEDITOR:
						
					IF _xAllowCommands THEN

						_xAllowCommands := FALSE;

						// Warten bis das Füllen des Editors abgeschlossen ist.
						_PmIntern.enCycIfState := cs_IfFillEditor;

						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;
							
						// Füllen des Editors starten
						_PmIntern.enCycFillEditor := cs_feStart;
							
					ELSE

						// Kommando ablehnen
						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTREADY;
						// Kommando muss zurückgenommen werden
						_PmIntern.enCycIfState := cs_IfReady;
							
					END_IF
								
				MNPARAM_CMD_SAVEEDITOR:
								
					IF _xAllowCommands THEN

						_xAllowCommands := FALSE;

						// Warten bis das Sichern des Editors abgeschlossen ist
						_PmIntern.enCycIfState := cs_IfSaveEditor;

						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;
							
						_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTSAVE;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

						// Sichern starten
						_PmIntern.enCycSaveEditor := cs_seStart;

					ELSE

						// Kommando ablehnen
						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTREADY;
						// Kommando muss zurückgenommen werden
						_PmIntern.enCycIfState := cs_IfReady;
							
					END_IF
					
				MNPARAM_CMD_CREATE_INDCONT:
					
					IF _xAllowCommands THEN
						
						_xAllowCommands := FALSE;
						
						// Parameter übernehmen
						_wCreateCont := IFmnParam.In.Edit.bContainer;
						
						IF IFmnParam.In.Edit.diContainerInstance < 0 THEN

							IF _wCreateCont <= MNPARAM_MAXIDX_CONTAINER THEN

								IF _pDoContainer.Container[_wCreateCont].bDirectParam = 0 THEN
								
									FOR _inst := 0 TO _pDoContainer.Container[_wCreateCont].wDimension - 1 DO
									
										IF NOT(_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCreateCont] + _inst].xExist) THEN
											EXIT;
										END_IF

									END_FOR
									
									IF _inst < _pDoContainer.Container[_wCreateCont].wDimension THEN

										_wCreateInst := _pDoContainer.Container[_wCreateCont].wMinBound + _inst;

										// Warten bis das Anlegen einer Instanz abgeschlossen ist
										_PmIntern.enCycIfState := cs_IfCreateIndCont;
						
										IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;

										_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTCREATE;
										_LogEntryIn.lAttr1 := _wCreateCont;
										_LogEntryIn.lAttr2 := _wCreateInst;
										_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

										// Instanz anlegen
										_PmIntern.enCycCreate := cs_CrtStart;
										
									ELSE

										// Warten bis das Anlegen einer Instanz abgeschlossen ist
										_PmIntern.enCycIfState := cs_IfReady;
										IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_NO_FREE_CONTINST;

									END_IF
								
								ELSE

									// Warten bis das Anlegen einer Instanz abgeschlossen ist
									_PmIntern.enCycIfState := cs_IfReady;
									IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_CONTAINER_NOT_VALID;
									
								END_IF
								
							ELSE

								// Warten bis das Anlegen einer Instanz abgeschlossen ist
								_PmIntern.enCycIfState := cs_IfReady;
								IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_CONTAINER_NOT_VALID;

							END_IF
							
						ELSE

							_wCreateInst := DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance);
							
							// Warten bis das Anlegen einer Instanz abgeschlossen ist
							_PmIntern.enCycIfState := cs_IfCreateIndCont;
						
							IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;

							_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTCREATE;
							_LogEntryIn.lAttr1 := _wCreateCont;
							_LogEntryIn.lAttr2 := _wCreateInst;
							_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

							// Instanz anlegen
							_PmIntern.enCycCreate := cs_CrtStart;

						END_IF
						

					ELSE

						// Kommando ablehnen
						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTREADY;
						// Kommando muss zurückgenommen werden
						_PmIntern.enCycIfState := cs_IfReady;
							
					END_IF

				MNPARAM_CMD_DELETE_INDCONT:

					IF _xAllowCommands THEN
						
						_xAllowCommands := FALSE;

						// Warten bis das Löschen der Instanz abgeschlossen ist
						_PmIntern.enCycIfState := cs_IfDeleteIndCont;

						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;
						
						// Parameter übernehmen
						_wDelCont := IFmnParam.In.Edit.bContainer;
						_wDelInst := DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance);
						
						_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTDELETE;
						_LogEntryIn.lAttr1 := _wDelCont;
						_LogEntryIn.lAttr2 := _wDelInst;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

						// Löschen starten
						_PmIntern.enCycDelState := cs_DelStart;

					ELSE

						// Kommando ablehnen
						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTREADY;
						// Kommando muss zurückgenommen werden
						_PmIntern.enCycIfState := cs_IfReady;
							
					END_IF

				MNPARAM_CMD_COPY_INDCONT:
					
					IF _xAllowCommands THEN
						
						_xAllowCommands := FALSE;

						// Parameter übernehmen
						_wCopyCont := IFmnParam.In.Edit.bContainer;
						_wCopyInstFrom := IFmnParam.In.Edit.wContainerInstanceFrom;
						
						IF IFmnParam.In.Edit.diContainerInstance < 0 THEN

							IF _wCopyCont <= MNPARAM_MAXIDX_CONTAINER THEN

								IF _pDoContainer.Container[_wCopyCont].bDirectParam = 0 THEN
								
									FOR _inst := 0 TO _pDoContainer.Container[_wCopyCont].wDimension - 1 DO
									
										IF NOT(_PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[_wCopyCont] + _inst].xExist) THEN
											EXIT;
										END_IF

									END_FOR
									
									IF _inst < _pDoContainer.Container[_wCopyCont].wDimension THEN

										_wCopyInst := _pDoContainer.Container[_wCopyCont].wMinBound + _inst;

										// Warten bis das Kopieren einer Instanz abgeschlossen ist
										_PmIntern.enCycIfState := cs_IfCopyIndCont;
						
										IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;

										_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTCOPY;
										_LogEntryIn.lAttr1 := _wCreateCont;
										_LogEntryIn.lAttr2 := _wCreateInst;
										_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

										// Instanz anlegen
										_PmIntern.enCycCopy := cs_CpyStart;
										
									ELSE

										// Warten bis das Anlegen einer Instanz abgeschlossen ist
										_PmIntern.enCycIfState := cs_IfReady;
										IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_NO_FREE_CONTINST;

									END_IF
								
								ELSE

									// Warten bis das Anlegen einer Instanz abgeschlossen ist
									_PmIntern.enCycIfState := cs_IfReady;
									IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_CONTAINER_NOT_VALID;
									
								END_IF
								
							ELSE

								// Warten bis das Anlegen einer Instanz abgeschlossen ist
								_PmIntern.enCycIfState := cs_IfReady;
								IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_CONTAINER_NOT_VALID;

							END_IF
							
						ELSE

							_wCopyInst := DINT_TO_UINT(IFmnParam.In.Edit.diContainerInstance);
							
							// Warten bis das Kopieren einer Instanz abgeschlossen ist
							_PmIntern.enCycIfState := cs_IfCopyIndCont;
						
							IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;

							_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTCOPY;
							_LogEntryIn.lAttr1 := _wCreateCont;
							_LogEntryIn.lAttr2 := _wCreateInst;
							_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

							// Instanz anlegen
							_PmIntern.enCycCopy := cs_CpyStart;

						END_IF


					ELSE

						// Kommando ablehnen
						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTREADY;
						// Kommando muss zurückgenommen werden
						_PmIntern.enCycIfState := cs_IfReady;
							
					END_IF
					
				MNPARAM_CMD_BACKUP:

					IF _xAllowCommands THEN

						_xAllowCommands := FALSE;
						
						// USB-Flashdisk muss gesteckt sein
						IF IFmnSystem.Out.xUSBStickReady THEN

							// Warten bis Backup beendet ist
							_PmIntern.enCycIfState := cs_IfBackup;

							IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;

							_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTBACKUP;
							_LogEntryIn.lAttr1 := 0;
							_LogEntryIn.lAttr2 := 0;
							_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
								
							// Devicenamen der USB-Flashdisk übernehmen
							_sUSBInterface := IFmnSystem.Out.sInterfaceUSB;
								
							// Backup starten
							_PmIntern.enCycBackup := cs_BacUSBlinkDevice;
								
						ELSE
								
							// Es ist keine USB-Flashdisk gesteckt
							IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_NOUSBSTICK;
							// Kommando muss zurückgenommen werden
							_PmIntern.enCycIfState := cs_IfReady;

						END_IF

					ELSE

						// Kommando ablehnen
						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTREADY;
						// Kommando muss zurückgenommen werden
						_PmIntern.enCycIfState := cs_IfReady;
							
					END_IF
					
				MNPARAM_CMD_RESTORE:

					IF _xAllowCommands THEN

						_xAllowCommands := FALSE;
							
						// USB-Flashdisk muss gesteckt sein
						IF IFmnSystem.Out.xUSBStickReady THEN

							// Warten bis Restore abgeschlossen ist
							_PmIntern.enCycIfState := cs_IfRestore;

							IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_BUSY;

							// Devicenamen der USB-Flashdisk übernehmen
							_sUSBInterface := IFmnSystem.Out.sInterfaceUSB;

							_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTRESTORE;
							_LogEntryIn.lAttr1 := 0;
							_LogEntryIn.lAttr2 := 0;
							_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

							// Restore starten
							_PmIntern.enCycImpState := cs_ImpUSBLinkDevice;
								
						ELSE
								
							// Es ist keine USB-Flashdisk gesteckt
							IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_NOUSBSTICK;
							// Kommando muss zurückgenommen werden
							_PmIntern.enCycIfState := cs_IfReady;

						END_IF
							
					ELSE

						// Kommando ablehnen
						IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTREADY;
						// Kommando muss zurückgenommen werden
						_PmIntern.enCycIfState := cs_IfReady;
							
					END_IF

				MNPARAM_CMD_FILLNAMELIST:

					IF _xAllowCommands THEN

						_xAllowCommands := FALSE;
						
						IFmnParam.Out.Edit.wIdxContainerNamelist := IFmnParam.In.Edit.wSelIdxContainerNamelist;
						IFmnParam.Out.Edit.wParIdxNamelist := IFmnParam.In.Edit.wSelParIdxNamelist;

						_actFillNamelist;

						IFmnParam.Out.Edit.wStatus := KG_STAT_BUSY;

						_PmIntern.enCycIfState := cs_IfFillNameList;

					END_IF
						
				ELSE
							
					// Kommando ungültig
					IFmnParam.Out.Edit.wStatus := KG_CMDSTAT_NOTVALID;
					// Kommando muss zurückgenommen werden
					_PmIntern.enCycIfState := cs_IfReady;
							
			END_CASE
					
		cs_IfFillNameList:
		
			IF IFsvCPCache.In.wCmd = KG_CMD_NOCOMMAND AND IFsvCPCache.Out.wCmdResponse = KG_CMD_NOCOMMAND THEN
				
				IFsvCPCache.In.wSetOffset := 0;
				IFsvCPCache.In.wCmd := SVCPCACHE_CMD_SETOFFSET;
				
			END_IF
		
			IF IFsvCPCache.In.wCmd = SVCPCACHE_CMD_SETOFFSET AND IFsvCPCache.Out.wCmdResponse = SVCPCACHE_CMD_SETOFFSET THEN

				IFsvCPCache.In.wCmd := KG_CMD_NOCOMMAND;

				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_FILLNAMELIST_OK;
				_PmIntern.enCycIfState := cs_IfReady;

			END_IF
		
		cs_IfFillEditor:
			
			// Warten bis Füllen des Editor fertig ist
			IF _PmIntern.enCycFillEditor = cs_feRdySuccess THEN

				// ERFOLG
				
				// Rückmeldung
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_FILLEDITOR_OK;
				
				// Statemachine Editor Füllen zurücksetzen
				_PmIntern.enCycFillEditor := cs_feIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
			ELSIF _PmIntern.enCycFillEditor = cs_feRdyFault THEN

				// FEHLER
				
				// Status zurückliefern
				IFmnParam.Out.Edit.wStatus := DINT_TO_UINT(_PmIntern.Status.diMsgAttr1);

				// Statemachine Editor Füllen zurücksetzen
				_PmIntern.enCycFillEditor := cs_feIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;

			END_IF	
					
		cs_IfSaveEditor:

			// Warten bis Editor gesichert wurde
			IF _PmIntern.enCycSaveEditor = cs_seRdySuccess THEN
			
				// ERFOLG
				
				// Rückmeldung
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_SAVEEDITOR_OK;
				
				// Statemchine Editor sichern zurücksetzen
				_PmIntern.enCycSaveEditor := cs_seIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDSAVE_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			ELSIF _PmIntern.enCycSaveEditor = cs_seRdyFault THEN

				// FEHLER
				
				// Status zurückmelden
				IFmnParam.Out.Edit.wStatus := DINT_TO_UINT(_PmIntern.Status.diMsgAttr1);

				// Statemchine Editor sichern zurücksetzen
				_PmIntern.enCycSaveEditor := cs_seIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDSAVE_FAILED;
				_LogEntryIn.lAttr1 := IFmnParam.Out.Edit.wStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			END_IF	

		cs_IfCreateIndCont:

			// Warten bis Instanz angelegt wurde
			IF _PmIntern.enCycCreate = cs_CrtRdySuccess THEN
			
				// ERFOLG
				
				// Rückmeldung
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_CREATE_INDCONT_OK;
				
				// Statemachine Instanz anlegen zurücksetzen
				_PmIntern.enCycCreate := cs_CrtIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDCREATE_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

				IF _wCreateCont = MNPARAM_IDX_PROGCONTAINER THEN
					
					_actFillNamelist;
					
				END_IF
				
			ELSIF _PmIntern.enCycCreate = cs_CrtRdyFault THEN

				// FEHLER
				
				// Status zurückmelden
				IFmnParam.Out.Edit.wStatus := DINT_TO_UINT(_PmIntern.Status.diMsgAttr1);

				// Statemachine Instanz anlegen zurücksetzen
				_PmIntern.enCycCreate := cs_CrtIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDCREATE_FAILED;
				_LogEntryIn.lAttr1 := IFmnParam.Out.Edit.wStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			END_IF	
			
		cs_IfDeleteIndCont:
			
			// Warten bis Instanz löschen fertig ist
			IF _PmIntern.enCycDelState = cs_DelRdySuccess THEN
				
				// ERFOLG
				
				// Rückmeldung
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_DELETE_INDCONT_OK;
				
				// Statemachin Delete zurücksetzen
				_PmIntern.enCycDelState := cs_DelIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDDELETE_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
				
				IF _wDelCont = MNPARAM_IDX_PROGCONTAINER THEN
					
					_actFillNamelist;
					
				END_IF


			ELSIF _PmIntern.enCycDelState = cs_DelRdyFault THEN
					
				// FEHLER
				
				// Status zurückmelden
				IFmnParam.Out.Edit.wStatus := MAX(59999,DINT_TO_UINT(_PmIntern.Status.diMsgAttr1));

				// Statemachin Delete zurücksetzen
				_PmIntern.enCycDelState := cs_DelIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDDELETE_FAILED;
				_LogEntryIn.lAttr1 := IFmnParam.Out.Edit.wStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			END_IF	

		cs_IfCopyIndCont:

			// Warten bis Instanz kopiert wurde
			IF _PmIntern.enCycCopy = cs_CpyRdySuccess THEN
			
				// ERFOLG
				
				// Status zurückmelden
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_COPY_INDCONT_OK;
				
				// Statemachine Kopieren zurücksetzen
				_PmIntern.enCycCopy := cs_CpyIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDCOPY_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
				
				IF _wCopyCont = MNPARAM_IDX_PROGCONTAINER THEN
					
					_actFillNamelist;
					
				END_IF


			ELSIF _PmIntern.enCycCopy = cs_CpyRdyFault THEN

				// FEHLER
				
				// Status zurückmelden
				IFmnParam.Out.Edit.wStatus := DINT_TO_UINT(_PmIntern.Status.diMsgAttr1);

				// Statemachine Kopieren zurücksetzen
				_PmIntern.enCycCopy := cs_CpyIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDCOPY_FAILED;
				_LogEntryIn.lAttr1 := IFmnParam.Out.Edit.wStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			END_IF	

		cs_IfBackup:

			// Warten bis Backup fertig ist
			IF _PmIntern.enCycBackup = cs_BacRdySuccess THEN
				
				// ERFOLG
				
				// Rückmeldung
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_BACKUP_OK;
				
				// Statemachine Backup zurücksetzen
				_PmIntern.enCycBackup := cs_BacIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDBACKUP_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			ELSIF _PmIntern.enCycBackup = cs_BacRdyFault THEN
					
				// FEHLER
				
				// Status zurückmelden
				IFmnParam.Out.Edit.wStatus := MAX(59999,DINT_TO_UINT(_PmIntern.Status.diMsgAttr1));

				// Statemachine Backup zurücksetzen
				_PmIntern.enCycBackup := cs_BacIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDBACKUP_FAILED;
				_LogEntryIn.lAttr1 := IFmnParam.Out.Edit.wStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			END_IF	

		cs_IfRestore:

			// Warten bis Import/Restore fertig ist
			IF _PmIntern.enCycImpState = cs_ImpRdySuccess THEN
				
				// ERFOLGE
				
				// Rückmeldung
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_RESTORE_OK;
				
				// Statemachine Import zurücksetzen
				_PmIntern.enCycImpState := cs_ImpIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDRESTORE_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
				
				_actFillNamelist;

			ELSIF _PmIntern.enCycImpState = cs_ImpRdyFault THEN
					
				// FEHLER
				
				// Status zurückmelden
				IFmnParam.Out.Edit.wStatus := MAX(59999,DINT_TO_UINT(_PmIntern.Status.diMsgAttr1));
				
				// Statemachine Import zurücksetzen
				_PmIntern.enCycImpState := cs_ImpIdle;
				// Kommando muss zurückgenommen werden
				_PmIntern.enCycIfState := cs_IfReady;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDRESTORE_FAILED;
				_LogEntryIn.lAttr1 := IFmnParam.Out.Edit.wStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

			END_IF	

		cs_IfReady:

			// Warten, bis das Kommando zurückgenommen wurde. Bei Warnung mindestzeit abwarten
			IF IFmnParam.In.Edit.wCommand = MNPARAM_CMD_NOCOMMAND AND (_PmIntern.Status.wMsgNumber = 0 OR TONwarn2.Q) THEN
				
				// Rückmeldung
				IFmnParam.Out.Edit.wStatus := MNPARAM_STAT_NOCOMMAND;

				// Meldung zurücksetzen
				brsmemset(ADR(_PmIntern.Status), 0, SIZEOF(_PmIntern.Status));
				_PmIntern.Status.wFunction_ID := MNPARAM_FUNCTIONID;					

				// Interface zur Applikation wieder bereit schalten
				_PmIntern.enCycIfState := cs_IfIdle;

			END_IF
			
	END_CASE
	
	// Warnung soll mindestens 4 Sekunden anstehen
	TONwarn2(IN := _PmIntern.enCycIfState = cs_IfReady, PT := T#4s);

END_ACTION