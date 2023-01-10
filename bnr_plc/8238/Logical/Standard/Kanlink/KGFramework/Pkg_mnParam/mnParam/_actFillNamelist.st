(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _actFillNamelist.st
 * Author: hunholz
 * Created: March 30, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Namensliste für Programme füllen *)
ACTION _actFillNamelist: 
	
	IFmnParam.Out.Edit.wCntNamelist := 0;
	brsmemset(ADR(IFmnParam.Out.Edit.wNameListNo), 0, SIZEOF(IFmnParam.Out.Edit.wNameListNo));
	brsmemset(ADR(IFmnParam.Out.Edit.utfNameListName), 0, SIZEOF(IFmnParam.Out.Edit.utfNameListName));
	
	IF IFmnParam.Out.Edit.wIdxContainerNamelist <= MNPARAM_MAXIDX_CONTAINER THEN

		IF _pDoContainer.Container[IFmnParam.Out.Edit.wIdxContainerNamelist].bDirectParam = 0 AND _pDoContainer.Container[IFmnParam.Out.Edit.wIdxContainerNamelist].wDimension > 0 THEN
						
			_wActListIdx := 1;
						
			FOR _k := 0 TO _pDoContainer.Container[IFmnParam.Out.Edit.wIdxContainerNamelist].wDimension-1 DO
							
				IF _PmIntern.TOC.TocEntry[_PmIntern.TOC.wStartIdx[IFmnParam.Out.Edit.wIdxContainerNamelist] + _k].xExist THEN
								
					IFmnParam.Out.Edit.wNameListNo[_wActListIdx] := _pDoContainer.Container[IFmnParam.Out.Edit.wIdxContainerNamelist].wMinBound + _k;
								
					_DefineActContainer(Enable := TRUE, bContainerIdx := UINT_TO_USINT(IFmnParam.Out.Edit.wIdxContainerNamelist), wInstanceIdx := IFmnParam.Out.Edit.wNameListNo[_wActListIdx], pIntern := ADR(_PmIntern));

					IF _DefineActContainer.Status = ERR_OK THEN
									
						IF IFmnParam.Out.Edit.wParIdxNamelist > 0 AND IFmnParam.Out.Edit.wParIdxNamelist <= _PmIntern.DataObjects.MaxIndex.lParamString THEN
										
							_diProgname(enable := TRUE, pName := ADR(_PmIntern.ActContainer.sDoNameString));
										
							IF _diProgname.status = ERR_OK THEN

								IFmnParam.Out.Edit.utfNameListName[_wActListIdx] := UINT_TO_WSTRING(_k);
								brwcscat(ADR(IFmnParam.Out.Edit.utfNameListName[_wActListIdx]), ADR(" - "));
								
								// Datenobjekt mit aktuellen String Parametern wurde gefunden
								_PmIntern.CSVDataObjects.Adress.lCSVString := _diCSVString.pDatObjMem;
								_PmIntern.CSVDataObjects.Size.lCSVString := _diCSVString.len;
								_PmIntern.CSVDataObjects.Idents.lCSVString := _diCSVString.ident;
					
								_pDoProgContainer ACCESS _diProgname.pDatObjMem;
								_lMaxIndexProgContainer := ( (_pDoProgContainer.Header.Do.lActEndPos - SIZEOF(mnParam_CsvDynHeader_typ)) / SIZEOF(_pDoProgContainer.CsvString[1]) );

								// Suche Parameter-Containerindex anhand des Parameterindex und der 4 möglichen Array-Werte
								_binarySearchString.enable := TRUE;
								_binarySearchString.CsvStructString.wIdxStringPar 	:= IFmnParam.Out.Edit.wParIdxNamelist;
								_binarySearchString.CsvStructString.wArrIdx1 		:= 0;
								_binarySearchString.CsvStructString.wArrIdx2 		:= 0;
								_binarySearchString.CsvStructString.wArrIdx3 		:= 0;
								_binarySearchString.CsvStructString.wArrIdx4 		:= 0;
								_binarySearchString.lpList 							:=  _diProgname.pDatObjMem;
								_binarySearchString.lMaxRow 						:= _lMaxIndexProgContainer;

								_binarySearchString();

								// Wurde der Parameter im Container gefunden ?
								IF _binarySearchString.status = ERR_OK THEN
									
									brwcscat(ADR(IFmnParam.Out.Edit.utfNameListName[_wActListIdx]), ADR(_pDoProgContainer.CsvString[_binarySearchString.lFoundRow].utfValue));

								END_IF

							END_IF
										
						END_IF
							
						IFmnParam.Out.Edit.wCntNamelist := _wActListIdx;
						_wActListIdx := _wActListIdx + 1;
									
						IF _wActListIdx > MNPARAM_CNT_NAMELIST THEN
							// Abbrechen, wenn die Liste voll ist
							EXIT;
						END_IF

					ELSE
									
						IFmnParam.Out.Edit.wNameListNo[_wActListIdx] := 0;
									
					END_IF
								
				END_IF
							
			END_FOR
						
		END_IF

	END_IF

END_ACTION