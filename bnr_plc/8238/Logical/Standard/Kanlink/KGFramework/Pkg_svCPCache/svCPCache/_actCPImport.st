(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: _actCPImport.st
 * Author: hunholz
 * Created: March 29, 2012
 ********************************************************************
 * Implementation of program svCPCache
 ********************************************************************) 

(* Kategorie-Programm-Zuordnung aus CSV-Datei lesen *)
ACTION _actCPImport:
	
	CASE _enImport OF
	
		cs_ImpIdle:
			
			// Tue nichts
			
		cs_ImpStart:
		
			// Initialisierung
			brsmemset(ADR(_CPCache), 0, SIZEOF(_CPCache));
			brsmemset(ADR(_lLineAdress), 0, SIZEOF(_lLineAdress));
			brsmemset(ADR(_wLineLen), 0, SIZEOF(_wLineLen));
			_wCntRelations := 0;
			_xImpFault := FALSE;
			_xImpReady := FALSE;
			_lTempMem := 0;
			
			_enImport := cs_ImpFileOpen;

		cs_ImpFileOpen:	
			
			_FileOpen(enable := TRUE, pDevice := ADR(_sDevice), pFile := ADR(_sPathFile), mode := fiREAD_ONLY);
			
			IF _FileOpen.status = ERR_OK THEN
				
				IF _FileOpen.filelen > SIZEOF(KGBOM) THEN
				
					_lFileLen := _FileOpen.filelen - SIZEOF(KGBOM);
					
					_MemPartAllocClear(enable := TRUE, ident := _MemPartCreate.ident, len := _lFileLen);
					
					IF _MemPartAllocClear.status = ERR_OK THEN
						
						_lTempMem := _MemPartAllocClear.mem;
						_enImport := cs_ImpFileRead;
						
					ELSE
						
						_xImpFault := TRUE;
						_enImport := cs_ImpFileClose;
						
					END_IF

				ELSE	

					_xImpReady := TRUE;
					_enImport := cs_ImpFileClose;
						
				END_IF
					
			ELSIF _FileOpen.status <> ERR_FUB_BUSY THEN
				
				_enImport := cs_ImpRdySuccess;
				
			END_IF

		cs_ImpFileRead:
		
			_FileRead(enable := TRUE, ident := _FileOpen.ident, offset := SIZEOF(KGBOM), pDest := _MemPartAllocClear.mem, len := _lFileLen);
			
			IF _FileRead.status <> ERR_FUB_BUSY THEN
				
				IF _FileRead.status <> ERR_OK THEN
					
					_xImpFault := TRUE;
					
				END_IF
				
				_enImport := cs_ImpFileClose;
				
			END_IF
		
		cs_ImpFileClose:
		
			_FileClose(enable := TRUE, ident := _FileOpen.ident);
			
			IF _FileClose.status = ERR_OK THEN
				
				IF _xImpFault THEN
					
					_enImport := cs_ImpRdyFault;
					
					IF _lTempMem <> 0 THEN
						_MemPartFree(enable := TRUE, ident := _MemPartAllocClear.ident, mem := _lTempMem);
					END_IF						
					
				ELSIF _xImpReady THEN	

					_enImport := cs_ImpRdySuccess;

					IF _lTempMem <> 0 THEN
						_MemPartFree(enable := TRUE, ident := _MemPartAllocClear.ident, mem := _lTempMem);
					END_IF						

				ELSE
					
					_enImport := cs_ImpParse;
					
				END_IF
				
			ELSIF _FileClose.status <> ERR_FUB_BUSY THEN
				
				_enImport := cs_ImpRdyFault;
		
			END_IF
		
		cs_ImpParse:
		
			_CountLines.enable 	:= TRUE;
			_CountLines.pFile 		:= _lTempMem;
			_CountLines.FileSize 	:= _lFileLen;
			_CountLines.MaxLines	:= SVCPCACHE_MAX_PARSELINES;
			_CountLines.pAdresses	:= ADR(_lLineAdress);
			_CountLines.pLens		:= ADR(_wLineLen);
		
			_CountLines();

			IF _CountLines.status <> ERR_OK THEN
				
				_MemPartFree(enable := TRUE, ident := _MemPartAllocClear.ident, mem := _lTempMem);
				_enImport := cs_ImpRdyFault;

			ELSE
				
				_wStartLine := 1;
				
				REPEAT
			
					_GetCsvDat.enable := TRUE;
					brwcsncpy( ADR(_GetCsvDat.utfCsvString), _lLineAdress[_wStartLine], MIN(299, _wLineLen[_wStartLine]));
					_GetCsvDat();
					
					IF _GetCsvDat.RowType = MNPARAM_CSV_CP AND _wCntRelations < SVCPCACHE_CNT_RELATIONS THEN

						_wCntRelations := _wCntRelations + 1;
						
						_CPCache[_wCntRelations] := _GetCsvDat.CsvCProw;
						
					END_IF
					
					_wStartLine := _wStartLine + 1;
					
					UNTIL
					_wStartLine > _CountLines.CntLines
					
				END_REPEAT

				_MemPartFree(enable := TRUE, ident := _MemPartAllocClear.ident, mem := _lTempMem);
				_enImport := cs_ImpRdySuccess;
				
			END_IF
				
		cs_ImpRdySuccess:
			
			// Beendet mit Erfolg
			
		cs_ImpRdyFault:
			
			// Mit Fehler beendet
		
	END_CASE
	
END_ACTION