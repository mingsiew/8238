(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: _actIFCmd.st
 * Author: hunholz
 * Created: March 30, 2012
 ********************************************************************
 * Implementation of program svCPCache
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actIFCmd: 
	
	CASE _enCmd OF
		
		cs_CmdIdle:
			
		// Warte auf Kommando
		
			CASE IFsvCPCache.In.wCmd OF
				
				KG_CMD_NOCOMMAND:
				
					IFsvCPCache.Out.wCmdResponse := KG_CMD_NOCOMMAND;

				SVCPCACHE_CMD_GETPROG:

					IFsvCPCache.Out.rRespSoilFactor 		:= 1.0;
					IFsvCPCache.Out.utfRespCategoryName		:= "";
					IFsvCPCache.Out.wRespColidxBack			:= 15;
					IFsvCPCache.Out.wRespColidxFor			:= 1;
					IFsvCPCache.Out.wRespLoadrate			:= 100;
					IFsvCPCache.Out.wRespProgramNo			:= 0;
					IFsvCPCache.Out.utfRespProgramName		:= "";
					
					IFsvCPCache.Out.wRespFromDB				:= SVCPCACHE_DBREQ_LOCAL;

					_TrimCat(sCategory := IFsvCPCache.In.sReqCategory);
					_sCategory := _TrimCat.sOutCategory;
					
					IF _sCategory <> '' THEN

						// Suche Kategorie auf jeden Fall lokal

						_xCategoryExist := FALSE;
						_wCategoryIdx := 0;
							
						FOR _i := 1 TO SVCPCACHE_CNT_RELATIONS DO
								
							IF _CPCache[_i].dtTimeStamp = USINT_TO_DT(0) THEN
								EXIT;
							ELSIF _CPCache[_i].sCategory = _sCategory THEN
								_xCategoryExist := TRUE;
								_wCategoryIdx := _i;
								EXIT;
							END_IF
								
						END_FOR

						// Entscheidung, ob in der Datenbank gesucht werden soll
						
						IF IFsvCPCache.In.wReqUseDB = SVCPCACHE_DBREQ_LOCAL THEN
							
							IF _xCategoryExist THEN
								
								IFsvCPCache.Out.rRespSoilFactor 		:= _CPCache[_wCategoryIdx].rSoilfactor;
								IFsvCPCache.Out.utfRespCategoryName		:= _CPCache[_wCategoryIdx].utfCategoryName;
								IFsvCPCache.Out.wRespColidxBack			:= _CPCache[_wCategoryIdx].wColBack;
								IFsvCPCache.Out.wRespColidxFor			:= _CPCache[_wCategoryIdx].wColFor;
								IFsvCPCache.Out.wRespLoadrate			:= _CPCache[_wCategoryIdx].wLoadrate;
								IFsvCPCache.Out.wRespProgramNo			:= _CPCache[_wCategoryIdx].wProgramNo;
								
								FOR _i := 1 TO IFmnParam.Out.Edit.wCntNamelist DO
						
									IF IFmnParam.Out.Edit.wNameListNo[_i] = IFsvCPCache.Out.wRespProgramNo THEN
										IFsvCPCache.Out.utfRespProgramName := IFmnParam.Out.Edit.utfNameListName[_i];
										EXIT;
									END_IF
						
								END_FOR

								IFsvCPCache.Out.wCmdResponse := SVCPCACHE_CMD_GETPROG;
								_enCmd := cs_CmdWaitForNoCommand;

							ELSE

								IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_CATEGORYNOTEXIST;
								_enCmd := cs_CmdWaitForNoCommand;

							END_IF
							
						ELSE // Abfrage der Datenbank starten	

							IF IFhlDFII.Out.xConnected THEN
								
								IFsvCPCache.Out.wCmdResponse := KG_STAT_BUSY;
								_enCmd := cs_CmdWaitForDB;

							ELSE

								IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_DBNOTREADY;
								_enCmd := cs_CmdWaitForNoCommand;
								
								IF _xCategoryExist THEN
								
									IFsvCPCache.Out.rRespSoilFactor 		:= _CPCache[_wCategoryIdx].rSoilfactor;
									IFsvCPCache.Out.utfRespCategoryName		:= _CPCache[_wCategoryIdx].utfCategoryName;
									IFsvCPCache.Out.wRespColidxBack			:= _CPCache[_wCategoryIdx].wColBack;
									IFsvCPCache.Out.wRespColidxFor			:= _CPCache[_wCategoryIdx].wColFor;
									IFsvCPCache.Out.wRespLoadrate			:= _CPCache[_wCategoryIdx].wLoadrate;
									IFsvCPCache.Out.wRespProgramNo			:= _CPCache[_wCategoryIdx].wProgramNo;
								
									FOR _i := 1 TO IFmnParam.Out.Edit.wCntNamelist DO
						
										IF IFmnParam.Out.Edit.wNameListNo[_i] = IFsvCPCache.Out.wRespProgramNo THEN
											IFsvCPCache.Out.utfRespProgramName := IFmnParam.Out.Edit.utfNameListName[_i];
											EXIT;
										END_IF
						
									END_FOR
									
								END_IF

							END_IF
							
						END_IF
						
					ELSE

						IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_INVALIDCATEGORY;
						_enCmd := cs_CmdWaitForNoCommand;
		
					END_IF
				
				SVCPCACHE_CMD_INSERTCATEGORY:
					
					_wCmd := SVCPCACHE_CMD_INSERTCATEGORY;
				
					IF IFsvCPCache.Out.wCntRelations < SVCPCACHE_CNT_RELATIONS THEN

						_TrimCat(sCategory := IFsvCPCache.In.sReqCategory);
						_sCategory := _TrimCat.sOutCategory;
						
						IF _sCategory <> '' THEN
							
							_xCategoryExist := FALSE;
							
							FOR _i := 1 TO SVCPCACHE_CNT_RELATIONS DO
								
								IF _CPCache[_i].dtTimeStamp = USINT_TO_DT(0) THEN
									EXIT;
								ELSIF _CPCache[_i].sCategory = _sCategory THEN
									_xCategoryExist := TRUE;
									EXIT;
								END_IF
								
							END_FOR
							
							IF NOT _xCategoryExist THEN

								_DTGetTime(enable := TRUE);
								
								FOR _i := 1 TO SVCPCACHE_CNT_RELATIONS DO
								
									IF _CPCache[_i].dtTimeStamp = USINT_TO_DT(0) THEN
										
										_CPCache[_i].dtTimeStamp := _DTGetTime.DT1;
										_CPCache[_i].sCategory := _sCategory;
										_CPCache[_i].utfCategoryName := IFsvCPCache.In.utfReqCategoryName;
										_CPCache[_i].wProgramNo := IFsvCPCache.In.wReqProgramNo;
										_CPCache[_i].rSoilfactor := IFsvCPCache.In.rReqSoilfactor;
										_CPCache[_i].wLoadrate := IFsvCPCache.In.wReqLoadrate;
										_CPCache[_i].wColFor := IFsvCPCache.In.wReqColidxFor;
										_CPCache[_i].wColBack := IFsvCPCache.In.wReqColidxBack;
										
										IFsvCPCache.Out.wCntRelations := IFsvCPCache.Out.wCntRelations + 1;
										
										EXIT;
										
									ELSIF brsstrcmp(ADR(_CPCache[_i].sCategory),ADR(_sCategory)) > 0 THEN
										
										brsmemmove(ADR(_CPCache[_i+1]), ADR(_CPCache[_i]), SIZEOF(_CPCache[1])*(IFsvCPCache.Out.wCntRelations-_i+1) );
										
										_CPCache[_i].dtTimeStamp := _DTGetTime.DT1;
										_CPCache[_i].sCategory := _sCategory;
										_CPCache[_i].utfCategoryName := IFsvCPCache.In.utfReqCategoryName;
										_CPCache[_i].wProgramNo := IFsvCPCache.In.wReqProgramNo;
										_CPCache[_i].rSoilfactor := IFsvCPCache.In.rReqSoilfactor;
										_CPCache[_i].wLoadrate := IFsvCPCache.In.wReqLoadrate;
										_CPCache[_i].wColFor := IFsvCPCache.In.wReqColidxFor;
										_CPCache[_i].wColBack := IFsvCPCache.In.wReqColidxBack;
										
										IFsvCPCache.Out.wCntRelations := IFsvCPCache.Out.wCntRelations + 1;
										
										EXIT;
										
									END_IF
								
								END_FOR
								
								_enSave := cs_SaveCreateCSV;
								
								_enCmd := cs_CmdSave;
								
							ELSE
								
								IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_CATEGORYEXIST;
								_enCmd := cs_CmdWaitForNoCommand;

							END_IF
							
						ELSE
							
							IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_INVALIDCATEGORY;
							_enCmd := cs_CmdWaitForNoCommand;
						
						END_IF
						
					ELSE
						
						IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_NOSPACE;
						_enCmd := cs_CmdWaitForNoCommand;
						
					END_IF
				


				SVCPCACHE_CMD_UPDATECATEGORY:

					_wCmd := SVCPCACHE_CMD_UPDATECATEGORY;

					IF IFsvCPCache.Out.wCntRelations > 0 THEN

						_TrimCat(sCategory := IFsvCPCache.In.sReqCategory);
						_sCategory := _TrimCat.sOutCategory;
						
						IF _sCategory <> '' THEN
							
							_xCategoryExist := FALSE;
							
							FOR _i := 1 TO SVCPCACHE_CNT_RELATIONS DO
								
								IF _CPCache[_i].dtTimeStamp = USINT_TO_DT(0) THEN
									EXIT;
								ELSIF _CPCache[_i].sCategory = _sCategory THEN
									_xCategoryExist := TRUE;
									EXIT;
								END_IF
								
							END_FOR
							
							IF _xCategoryExist THEN

								_DTGetTime(enable := TRUE);
								
								_CPCache[_i].dtTimeStamp := _DTGetTime.DT1;
								_CPCache[_i].sCategory := _sCategory;
								_CPCache[_i].utfCategoryName := IFsvCPCache.In.utfReqCategoryName;
								_CPCache[_i].wProgramNo := IFsvCPCache.In.wReqProgramNo;
								_CPCache[_i].rSoilfactor := IFsvCPCache.In.rReqSoilfactor;
								_CPCache[_i].wLoadrate := IFsvCPCache.In.wReqLoadrate;
								_CPCache[_i].wColFor := IFsvCPCache.In.wReqColidxFor;
								_CPCache[_i].wColBack := IFsvCPCache.In.wReqColidxBack;
								
								_enSave := cs_SaveCreateCSV;
								
								_enCmd := cs_CmdSave;
								
							ELSE
								
								IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_CATEGORYNOTEXIST;
								_enCmd := cs_CmdWaitForNoCommand;

							END_IF
							
						ELSE
							
							IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_INVALIDCATEGORY;
							_enCmd := cs_CmdWaitForNoCommand;
						
						END_IF
						
					ELSE
						
						IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_CATEGORYLISTEMPTY;
						_enCmd := cs_CmdWaitForNoCommand;
						
					END_IF

				SVCPCACHE_CMD_DELETECATEGORY:

					_wCmd := SVCPCACHE_CMD_DELETECATEGORY;

					IF IFsvCPCache.Out.wCntRelations > 0 THEN

						_TrimCat(sCategory := IFsvCPCache.In.sReqCategory);
						_sCategory := _TrimCat.sOutCategory;
						
						IF _sCategory <> '' THEN
							
							_xCategoryExist := FALSE;
							
							FOR _i := 1 TO SVCPCACHE_CNT_RELATIONS DO
								
								IF _CPCache[_i].dtTimeStamp = USINT_TO_DT(0) THEN
									EXIT;
								ELSIF _CPCache[_i].sCategory = _sCategory THEN
									_xCategoryExist := TRUE;
									EXIT;
								END_IF
								
							END_FOR
							
							IF _xCategoryExist THEN

								IF _i < IFsvCPCache.Out.wCntRelations THEN

									brsmemmove(ADR(_CPCache[_i]), ADR(_CPCache[_i+1]), SIZEOF(_CPCache[1])*(IFsvCPCache.Out.wCntRelations-_i) );
									
								END_IF

								brsmemset(ADR(_CPCache[IFsvCPCache.Out.wCntRelations]), 0, SIZEOF(_CPCache[1]));
								
								IFsvCPCache.Out.wCntRelations := IFsvCPCache.Out.wCntRelations - 1;

								_enSave := cs_SaveCreateCSV;
								
								_enCmd := cs_CmdSave;
								
							ELSE
								
								IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_CATEGORYNOTEXIST;
								_enCmd := cs_CmdWaitForNoCommand;

							END_IF
							
						ELSE
							
							IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_INVALIDCATEGORY;
							_enCmd := cs_CmdWaitForNoCommand;
						
						END_IF
						
					ELSE
						
						IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_CATEGORYLISTEMPTY;
						_enCmd := cs_CmdWaitForNoCommand;
						
					END_IF
				
				
				SVCPCACHE_CMD_SETOFFSET:
					
					IFsvCPCache.Out.wListOffset := IFsvCPCache.In.wSetOffset;
					_actFillCPList;
					
					IFsvCPCache.Out.wCmdResponse := SVCPCACHE_CMD_SETOFFSET;
					_enCmd := cs_CmdWaitForNoCommand;
					
				SVCPCACHE_CMD_RESTORE:
					
					IF _enImport = cs_ImpIdle THEN

						_sDevice := IFsvCPCache.In.sImpDevice;
						_sPathFile := CONCAT(IFsvCPCache.In.sImpPath,_SVCPCACHE_CSV_FILE);
					
						IFsvCPCache.Out.wCmdResponse := KG_STAT_BUSY;
						_wCmd := SVCPCACHE_CMD_RESTORE;
	
						_enCmd := cs_CmdImport;
						
						_enImport := cs_ImpStart;
						
					END_IF
					
				ELSE

					IFsvCPCache.Out.wCmdResponse := KG_CMDSTAT_NOTVALID;
					_enCmd := cs_CmdWaitForNoCommand;
				
			END_CASE
			
		cs_CmdImport:

			(* ACTION*)
		
			_actCPImport;
		
			IF _enImport = cs_ImpRdyFault THEN
			
				// Einlesen mit Fehler abgebrochen
				_xCacheInitReady := FALSE;
			
				_enImport := cs_ImpIdle;

				IFsvCPCache.Out.wCmdResponse := SVCPCACHE_STAT_FILENOTFOUND;
				_enCmd := cs_CmdWaitForNoCommand;

			ELSIF _enImport = cs_ImpRdySuccess THEN
			
				// Erfolgreich eingelesen
				_xCacheReady := TRUE;
			
				IFsvCPCache.Out.xListReady := TRUE;
				IFsvCPCache.Out.wCntRelations := _wCntRelations;

				_enImport := cs_ImpIdle;

				// Liste füllen
				IFsvCPCache.Out.wListOffset := 0;
			
				_enSave := cs_SaveCreateCSV;
				_enCmd := cs_CmdSave;
			
			END_IF

		
		cs_CmdSave:
		
			IF _enSave = cs_SaveRdySuccess THEN
				
				_actFillCPList;

				_enSave := cs_SaveIdle;
				
				IFsvCPCache.Out.wCmdResponse := _wCmd;
				_enCmd := cs_CmdWaitForNoCommand;
				
			ELSIF _enSave = cs_SaveRdyFault THEN

				_enSave := cs_SaveIdle;

				IFsvCPCache.Out.wCmdResponse := _wSaveCSVstatus;
				_enCmd := cs_CmdWaitForNoCommand;

			END_IF
		
		cs_CmdWaitForDB:
		
			IF IFhlDFII.In.ReqProgByCat.wRequest = 0 AND IFhlDFII.Out.RespProgByCat.wResponse = 0 THEN
				
				IFhlDFII.In.ReqProgByCat.sCategoryNo_In := IFsvCPCache.In.sReqCategory;
				IFhlDFII.In.ReqProgByCat.wRequest		:= 2;
				
			ELSIF IFhlDFII.In.ReqProgByCat.wRequest = 2 AND IFhlDFII.Out.RespProgByCat.wResponse = 2 THEN
				
				_DTGetTime(enable := TRUE);
				
				IFsvCPCache.Out.rRespSoilFactor 		:= IFhlDFII.Out.RespProgByCat.rSoilfactor;
				IFsvCPCache.Out.utfRespCategoryName 	:= STRING_TO_WSTRING(IFhlDFII.Out.RespProgByCat.sCategoryName);
				IFsvCPCache.Out.wRespColidxBack			:= IFhlDFII.Out.RespProgByCat.wColorIdxBack;
				IFsvCPCache.Out.wRespColidxFor			:= IFhlDFII.Out.RespProgByCat.wColorIdxFor;
				IFsvCPCache.Out.wRespLoadrate			:= IFhlDFII.Out.RespProgByCat.wLoadrate;
				IFsvCPCache.Out.wRespProgramNo			:= IFhlDFII.Out.RespProgByCat.bProgramNo; 
								
				FOR _i := 1 TO IFmnParam.Out.Edit.wCntNamelist DO
						
					IF IFmnParam.Out.Edit.wNameListNo[_i] = IFsvCPCache.Out.wRespProgramNo THEN
						IFsvCPCache.Out.utfRespProgramName := IFmnParam.Out.Edit.utfNameListName[_i];
						EXIT;
					END_IF
						
				END_FOR

				IFsvCPCache.Out.wRespFromDB				:= SVCPCACHE_DBREQ_DFII;

				IF _xCategoryExist AND
					_CPCache[_wCategoryIdx].utfCategoryName = IFsvCPCache.Out.utfRespCategoryName AND
					_CPCache[_wCategoryIdx].rSoilfactor = IFsvCPCache.Out.rRespSoilFactor AND
					_CPCache[_wCategoryIdx].wLoadrate = IFsvCPCache.Out.wRespLoadrate AND
					_CPCache[_wCategoryIdx].wColBack = IFsvCPCache.Out.wRespColidxBack AND
					_CPCache[_wCategoryIdx].wColFor = IFsvCPCache.Out.wRespColidxFor AND
					_CPCache[_wCategoryIdx].wProgramNo =  IFsvCPCache.Out.wRespProgramNo THEN

					// Lokale Daten sind gleich den Daten aus der Datenbank
					
					IFsvCPCache.Out.wCmdResponse			:= SVCPCACHE_CMD_GETPROG;
					_enCmd := cs_CmdWaitForNoCommand;
					
				ELSIF _xCategoryExist THEN
					
					// Lokale Daten werden aktualisiert

					_CPCache[_wCategoryIdx].utfCategoryName := STRING_TO_WSTRING(IFhlDFII.Out.RespProgByCat.sCategoryName);
					_CPCache[_wCategoryIdx].rSoilfactor 	:= IFhlDFII.Out.RespProgByCat.rSoilfactor;
					_CPCache[_wCategoryIdx].wLoadrate 		:= IFhlDFII.Out.RespProgByCat.wLoadrate;
					_CPCache[_wCategoryIdx].wColBack 		:= IFhlDFII.Out.RespProgByCat.wColorIdxBack;
					_CPCache[_wCategoryIdx].wColFor 		:= IFhlDFII.Out.RespProgByCat.wColorIdxFor;
					_CPCache[_wCategoryIdx].wProgramNo 		:= IFhlDFII.Out.RespProgByCat.bProgramNo;
					_CPCache[_wCategoryIdx].dtTimeStamp		:= _DTGetTime.DT1;

					_wCmd := SVCPCACHE_CMD_GETPROG;
					_enSave := cs_SaveCreateCSV;
					_enCmd := cs_CmdSave;
					
				ELSE
					
					// Es wird versucht eine neue Kategorie in den lokalen Speicher abzulegen
					
					IF IFsvCPCache.Out.wCntRelations < SVCPCACHE_CNT_RELATIONS THEN
								
						FOR _i := 1 TO SVCPCACHE_CNT_RELATIONS DO
								
							IF _CPCache[_i].dtTimeStamp = USINT_TO_DT(0) THEN
										
								_CPCache[_i].dtTimeStamp 		:= _DTGetTime.DT1;
								_CPCache[_i].sCategory 			:= _sCategory;
								_CPCache[_i].utfCategoryName 	:= STRING_TO_WSTRING(IFhlDFII.Out.RespProgByCat.sCategoryName);
								_CPCache[_i].wProgramNo 		:= IFhlDFII.Out.RespProgByCat.bProgramNo;
								_CPCache[_i].rSoilfactor 		:= IFhlDFII.Out.RespProgByCat.rSoilfactor;
								_CPCache[_i].wLoadrate 			:= IFhlDFII.Out.RespProgByCat.wLoadrate;
								_CPCache[_i].wColFor 			:= IFhlDFII.Out.RespProgByCat.wColorIdxFor;
								_CPCache[_i].wColBack 			:= IFhlDFII.Out.RespProgByCat.wColorIdxBack;
										
								IFsvCPCache.Out.wCntRelations := IFsvCPCache.Out.wCntRelations + 1;
										
								EXIT;
										
							ELSIF brsstrcmp(ADR(_CPCache[_i].sCategory),ADR(_sCategory)) > 0 THEN
										
								brsmemmove(ADR(_CPCache[_i+1]), ADR(_CPCache[_i]), SIZEOF(_CPCache[1])*(IFsvCPCache.Out.wCntRelations-_i+1) );
										
								_CPCache[_i].dtTimeStamp 		:= _DTGetTime.DT1;
								_CPCache[_i].sCategory 			:= _sCategory;
								_CPCache[_i].utfCategoryName 	:= STRING_TO_WSTRING(IFhlDFII.Out.RespProgByCat.sCategoryName);
								_CPCache[_i].wProgramNo 		:= IFhlDFII.Out.RespProgByCat.bProgramNo;
								_CPCache[_i].rSoilfactor 		:= IFhlDFII.Out.RespProgByCat.rSoilfactor;
								_CPCache[_i].wLoadrate 			:= IFhlDFII.Out.RespProgByCat.wLoadrate;
								_CPCache[_i].wColFor 			:= IFhlDFII.Out.RespProgByCat.wColorIdxFor;
								_CPCache[_i].wColBack 			:= IFhlDFII.Out.RespProgByCat.wColorIdxBack;
										
								IFsvCPCache.Out.wCntRelations := IFsvCPCache.Out.wCntRelations + 1;
										
								EXIT;
										
							END_IF
								
						END_FOR

						_wCmd := SVCPCACHE_CMD_GETPROG;
						_enSave := cs_SaveCreateCSV;
						_enCmd := cs_CmdSave;
						
					ELSE

						// Kein Platz für eine neue Kategorie
						
						IFsvCPCache.Out.wCmdResponse			:= SVCPCACHE_CMD_GETPROG;
						_enCmd := cs_CmdWaitForNoCommand;
						
					END_IF
					
				END_IF

				IFhlDFII.In.ReqProgByCat.wRequest		:= 0;

			ELSIF IFhlDFII.In.ReqProgByCat.wRequest = 2 AND IFhlDFII.Out.RespProgByCat.wResponse <> 65535 AND IFhlDFII.Out.RespProgByCat.wResponse <> 0 THEN
				
				IF _xCategoryExist THEN
					
					IFsvCPCache.Out.rRespSoilFactor 		:= _CPCache[_wCategoryIdx].rSoilfactor;
					IFsvCPCache.Out.utfRespCategoryName		:= _CPCache[_wCategoryIdx].utfCategoryName;
					IFsvCPCache.Out.wRespColidxBack			:= _CPCache[_wCategoryIdx].wColBack;
					IFsvCPCache.Out.wRespColidxFor			:= _CPCache[_wCategoryIdx].wColFor;
					IFsvCPCache.Out.wRespLoadrate			:= _CPCache[_wCategoryIdx].wLoadrate;
					IFsvCPCache.Out.wRespProgramNo			:= _CPCache[_wCategoryIdx].wProgramNo;
								
					FOR _i := 1 TO IFmnParam.Out.Edit.wCntNamelist DO
						
						IF IFmnParam.Out.Edit.wNameListNo[_i] = IFsvCPCache.Out.wRespProgramNo THEN
							IFsvCPCache.Out.utfRespProgramName := IFmnParam.Out.Edit.utfNameListName[_i];
							EXIT;
						END_IF
						
					END_FOR

					IFsvCPCache.Out.wCmdResponse 			:= SVCPCACHE_CMD_GETPROG;
					
				ELSE
				
					IFsvCPCache.Out.wCmdResponse			:= IFhlDFII.Out.RespProgByCat.wResponse;

				END_IF

				IFhlDFII.In.ReqProgByCat.wRequest		:= 0;
				_enCmd := cs_CmdWaitForNoCommand;
				
			END_IF
		
		cs_CmdWaitForNoCommand:
			
			IF IFsvCPCache.In.wCmd = KG_CMD_NOCOMMAND THEN
				
				IFsvCPCache.Out.wCmdResponse := KG_STAT_OK;
				
				_enCmd := cs_CmdIdle;
				
			END_IF
		
	END_CASE
	
	
END_ACTION