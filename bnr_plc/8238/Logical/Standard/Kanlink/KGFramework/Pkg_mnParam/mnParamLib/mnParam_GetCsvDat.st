(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_GetCsvDat.st
 * Author: hunholz
 * Created: July 25, 2011
 * Changed: Mar 29, 2012
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Parsen einer CSV-Zeile *)
FUNCTION_BLOCK mnParam_GetCsvDat
	
	IF enable THEN
		
		status := ERR_OK;
		
		RowType := 0;
	
		brsmemset(ADR(HeaderVersion), 0, SIZEOF(HeaderVersion));
		brsmemset(ADR(HeaderMachineNo), 0, SIZEOF(HeaderMachineNo));
		brsmemset(ADR(HeaderTime), 0, SIZEOF(HeaderTime));
		brsmemset(ADR(ContainerRow), 0, SIZEOF(ContainerRow));
		brsmemset(ADR(LogicalStructRow), 0, SIZEOF(LogicalStructRow));
		brsmemset(ADR(ParamNumRow), 0, SIZEOF(ParamNumRow));
		brsmemset(ADR(ParamStringRow), 0, SIZEOF(ParamStringRow));
		brsmemset(ADR(CsvNumRow), 0, SIZEOF(CsvNumRow));
		brsmemset(ADR(CsvStringRow), 0, SIZEOF(CsvStringRow));
		brsmemset(ADR(CsvIPRow),0,SIZEOF(CsvIPRow));
		brsmemset(ADR(csvTextRow),0,SIZEOF(csvTextRow));
		brsmemset(ADR(csvHelpTextRow), 0, SIZEOF(csvHelpTextRow));
		brsmemset(ADR(CsvCProw), 0, SIZEOF(CsvCProw));
	
		_pUtfCsvString := ADR(utfCsvString);
		
		_GetNextSubstring.enable := TRUE;
		_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
		_utfRowType := "";
		
		brwcsncpy(ADR(_utfRowType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 15));
		brwcsconv(ADR(_sRowType), ADR(_utfRowType), 1);
	
		_diRowType := atoi(ADR(_sRowType) );
		
		IF _diRowType = MNPARAM_CSV_FILEEND THEN
			
			// FileEnde
			RowType := MNPARAM_CSV_FILEEND;
			// Keine Rückgabewerte
	
		ELSIF _diRowType = MNPARAM_CSV_COMMENT THEN
			
			// Kommentarzeile
			RowType := MNPARAM_CSV_COMMENT;
	
		ELSIF _diRowType = MNPARAM_CSV_HEADER_VERSION THEN
			
			// Version Datenmodell
			RowType := MNPARAM_CSV_HEADER_VERSION;
							
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diVersion := atoi(ADR(_sSubString) );
			
				HeaderVersion.wVersion := DINT_TO_UINT(LIMIT(0, _diVersion, 65535));
	
			END_IF
	
			IF NOT _GetNextSubstring.EndOfLine THEN
	
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
	
				_atodt(pStr := ADR(_sSubString));
				HeaderVersion.dtTimestamp := _atodt.dtTimeStamp;
	
			END_IF
	
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				brwcsncpy(ADR(HeaderVersion.utfMachineType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length,11));
				
			END_IF
	
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				brwcsncpy(ADR(HeaderVersion.utfMachineSubType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length,11));
				
			END_IF
	
		ELSIF _diRowType = MNPARAM_CSV_HEADER_MACHINENO THEN
			
			// Maschinennummer
			RowType := MNPARAM_CSV_HEADER_MACHINENO;
					
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				brwcsncpy(ADR(HeaderMachineNo.utfMachineNo), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length,15));
				
			END_IF
	
		ELSIF _diRowType = MNPARAM_CSV_HEADER_TIMESTAMP THEN
			
			// TimeStamp
			RowType := MNPARAM_CSV_HEADER_TIMESTAMP;
					
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
	
				_atodt(pStr := ADR(_sSubString));
				HeaderTime.dtTimestamp := _atodt.dtTimeStamp;
				
			END_IF
	
		ELSIF _diRowType = MNPARAM_CSV_LANGUAGEDEF THEN
			
			// Sprachdefinition
			RowType := MNPARAM_CSV_LANGUAGEDEF;
			
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				_utfSubString := "";
				
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvLCIDrow.LCID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
			
			END_IF
			
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				brwcsncpy(ADR(CsvLCIDrow.utfName), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 31));
			
			END_IF

		ELSIF _diRowType = MNPARAM_CSV_LAN_HELPTEXT THEN
			
			// Sprachhilfstext
			RowType := MNPARAM_CSV_LAN_HELPTEXT;
			
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				_utfSubString := "";
				
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				csvHelpTextRow.LCID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
			
			END_IF

			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				_utfSubString := "";
				
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				csvHelpTextRow.FunctionID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
			
			END_IF

			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				_utfSubString := "";
				
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				csvHelpTextRow.TextNo := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
			
			END_IF
			
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				brwcsncpy(ADR(csvHelpTextRow.utfHelpText), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 255));
			
			END_IF

		ELSIF _diRowType = MNPARAM_CSV_LAN_TEXT THEN
			
			// Sprachtext
			RowType := MNPARAM_CSV_LAN_TEXT;
			
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				_utfSubString := "";
				
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				csvTextRow.LCID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
			
			END_IF

			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				_utfSubString := "";
				
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				csvTextRow.FunctionID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
			
			END_IF

			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				_utfSubString := "";
				
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				csvTextRow.TextNo := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
			
			END_IF
			
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
				
				brwcsncpy(ADR(csvTextRow.utfText), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
			
			END_IF


		ELSIF _diRowType = MNPARAM_CSV_DEF_CONTAINER THEN
			
			// Containerbeschreibung
			RowType := MNPARAM_CSV_DEF_CONTAINER;
	
			// Container ID
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ContainerRow.siContainerID := DINT_TO_SINT(LIMIT(-128, _diNum, 127));
	
			END_IF
	
			// DirectParam
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ContainerRow.bDirectParam := DINT_TO_BOOL(LIMIT(0, _diNum, 1));
	
			END_IF
	
			// Name Data Obj
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfDataObj), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 11));
				brwcsconv(ADR(ContainerRow.sNameDataObj), ADR(_utfDataObj), 1);
	
			END_IF
	
			// Name Csv File
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 31));
				brwcsconv(ADR(ContainerRow.sNameCsv), ADR(_utfSubString), 1);
	
			END_IF
			
			// Min Bound
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ContainerRow.wMinBound := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Dimension
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ContainerRow.wDimension := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
			
			// Struct Root
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
	
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 31));
				brwcsconv(ADR(ContainerRow.sStrucRoot), ADR(_utfSubString), 1);
	
			END_IF
	
			IF NOT _GetNextSubstring.EndOfLine THEN
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			END_IF
	
			// Anzahl der Numparameter
			IF NOT _GetNextSubstring.EndOfLine THEN
	
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				
				ContainerRow.lCountNum := atoi(ADR(_sSubString) );
				
			END_IF
	
			// Anzahl der Stringparameter
			IF NOT _GetNextSubstring.EndOfLine THEN
	
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				
				ContainerRow.lCountString := atoi(ADR(_sSubString) );
				
			END_IF
	
			
		ELSIF _diRowType = MNPARAM_CSV_DEF_LOGSTRUC THEN
			
			// Logische Struktur
			RowType := MNPARAM_CSV_DEF_LOGSTRUC;
	
			// Index
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.wLogStrucNo := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Min Bound
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.wMinBound := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Dimension
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.wDimension := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
			
			// Referenz
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
	
				LogicalStructRow.iReferenz := DINT_TO_INT(LIMIT(-32768, _diNum, 32767));
						
			END_IF
	
			// Ref Visible
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.wRefVisible := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Ref Text
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.wRefText := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// WriteAccess
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.siWriteAccess := DINT_TO_SINT(LIMIT(-128, _diNum, 127));
	
			END_IF
	
			// VisibleAccess
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.siVisibleAccess := DINT_TO_SINT(LIMIT(-128, _diNum, 127));
	
			END_IF
	
			// Format Array
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				LogicalStructRow.bFormatArray := DINT_TO_USINT(LIMIT(0, _diNum, 255));
	
			END_IF
	
			// Machine Sub Type
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(LogicalStructRow.utfMachineSubType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 11));
	
			END_IF
	
			// LogStructName
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(LogicalStructRow.utfLogStrucName), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 31));
	
			END_IF
	
	
	
	
		ELSIF _diRowType = MNPARAM_CSV_DEF_STRING THEN
			
			// String
			RowType := MNPARAM_CSV_DEF_STRING;
			
			// Index
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wIdxStringPar := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Function ID
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wFunction_ID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Parameter No
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wParNo := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Länge
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.bLenght := DINT_TO_USINT(LIMIT(0, _diNum, 255));
	
			END_IF
	
			// WriteAccess
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.siWriteAccess := DINT_TO_SINT(LIMIT(-128, _diNum, 127));
	
			END_IF
	
			// VisibleAccess
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.siVisibleAccess := DINT_TO_SINT(LIMIT(-128, _diNum, 127));
	
			END_IF		
			
			// Adresse
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(ParamStringRow.sAdresse), ADR(_utfSubString), 1);
	
			END_IF
	
			// Min Bound
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wMinBound := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Dimension
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wDimension := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
			
			// Referenz
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wReferenz := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
						
			END_IF
	
			// Def. Value
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(ParamStringRow.utfDefValue), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 31));
	
			END_IF
	
			// Machine Sub Type
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(ParamStringRow.utfMachineSubType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 11));
	
			END_IF
	
			// RefVisible
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wRefVisible := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
						
			END_IF

			// RefVisible
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wRefVisibleType := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
						
			END_IF

			// RefText
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamStringRow.wRefText := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
						
			END_IF

	
		ELSIF _diRowType = MNPARAM_CSV_DEF_NUM OR _diRowType = MNPARAM_CSV_DEF_REAL THEN
			
			// Logische Struktur
			RowType := DINT_TO_UINT(_diRowType);
			ParamNumRow.bRowType := UINT_TO_USINT(RowType - MNPARAM_CSV_DEF_NUM);
			
			// Index
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wIdxNumPar := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Function ID
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wFunction_ID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Parameter No
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wParNo := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// WriteAccess
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.siWriteAccess := DINT_TO_SINT(LIMIT(-128, _diNum, 127));
	
			END_IF
	
			// VisibleAccess
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.siVisibleAccess := DINT_TO_SINT(LIMIT(-128, _diNum, 127));
	
			END_IF		
			
			// Unit ID
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wUnitID := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF	
	
			// Adresse
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(ParamNumRow.sAdresse), ADR(_utfSubString), 1);
	
			END_IF
	
			// Min Bound
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wMinBound := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Dimension
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wDimension := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
			
			// Referenz
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				_utfSubString := "";
	
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wReferenz := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
						
			END_IF
	
			IF ParamNumRow.bRowType = 0 THEN
	
				// MinValue
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					ParamNumRow.diMinValue := atoi(ADR(_sSubString) );
						
				END_IF
	
				// MaxValue
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					ParamNumRow.diMaxValue := atoi(ADR(_sSubString) );
						
				END_IF
	
				// DefValue
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					ParamNumRow.diDefValue := brsatoi(ADR(_sSubString) );
						
				END_IF
	
			ELSE
				
				// MinValue
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					_rValue := brsatof(ADR(_sSubString) );
					_pdiValue ACCESS ADR(_rValue);
					ParamNumRow.diMinValue := _pdiValue;
						
				END_IF
	
				// MaxValue
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					_rValue := brsatof(ADR(_sSubString) );
					_pdiValue ACCESS ADR(_rValue);
					ParamNumRow.diMaxValue := _pdiValue;
						
				END_IF
	
				// DefValue
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					_rValue := brsatof(ADR(_sSubString) );
					_pdiValue ACCESS ADR(_rValue);
					ParamNumRow.diDefValue := _pdiValue;
						
				END_IF
	
			END_IF
			
			// InputType
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.bInputType := DINT_TO_USINT(LIMIT(0, _diNum, 255));
	
			END_IF	
	
			// ITidx
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wITIdx := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Machine Sub Type
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(ParamNumRow.utfMachineSubType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 11));
	
			END_IF

			// RefVisible
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wRefVisible := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF

			// RefVisibleType
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wRefVisibleType := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF

			// RefText
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				ParamNumRow.wRefText := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF

		ELSIF _diRowType = MNPARAM_CSV_IP THEN
			
			// CSV IP Row
			RowType := MNPARAM_CSV_IP;
	
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(CsvIPRow.utfIP_Adress), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 15));
	
			END_IF
	
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(CsvIPRow.utfGateway), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 15));
	
			END_IF
	
	
		ELSIF _diRowType = MNPARAM_CSV_CP THEN
			
			// CSV Category-Program-Row
			RowType := MNPARAM_CSV_CP;
			
			// Categroy
			IF NOT _GetNextSubstring.EndOfLine THEN
				
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				_utfSubString := "";
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 11));
				CsvCProw.sCategory := WSTRING_TO_STRING(_utfSubString);
	
			END_IF
		
			// Category-Name
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(CsvCProw.utfCategoryName), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 31));
	
			END_IF
			
			// Programmno
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvCProw.wProgramNo := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
			
			// Zeitstempel
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
	
				_atodt(pStr := ADR(_sSubString));
				CsvCProw.dtTimeStamp := _atodt.dtTimeStamp;
				
			END_IF

			// Verschmutzungsfaktor
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
	
				CsvCProw.rSoilfactor := STRING_TO_REAL(_sSubString);
				
			END_IF

			// Beladegrad
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
	
				CsvCProw.wLoadrate := STRING_TO_UINT(_sSubString);
				
			END_IF

			// Fordergrundfarbe
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
	
				CsvCProw.wColFor := STRING_TO_UINT(_sSubString);
				
			END_IF

			// Hintergrundfarbe
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
	
				CsvCProw.wColBack := STRING_TO_UINT(_sSubString);
				
			END_IF

			
		ELSIF _diRowType = MNPARAM_CSV_DAT_STRING THEN
			
			// CSV String Parameter
			RowType := MNPARAM_CSV_DAT_STRING;
	
			// Index
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvStringRow.wIdxStringPar := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Value
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(CsvStringRow.utfValue), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 31));
	
			END_IF
	
			//  ArrIndex1
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvStringRow.wArrIdx1 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			//  ArrIndex2
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvStringRow.wArrIdx2 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			//  ArrIndex3
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvStringRow.wArrIdx3 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			//  ArrIndex4
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvStringRow.wArrIdx4 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Machine Sub Type
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(CsvStringRow.utfMachineSubType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 11));
	
			END_IF
	
	
	
		ELSIF _diRowType = MNPARAM_CSV_DAT_NUM OR _diRowType = MNPARAM_CSV_DAT_REAL THEN
			
			// CSV Num Parameter
			RowType := DINT_TO_UINT(_diRowType);
			
			CsvNumRow.bRowType := UINT_TO_USINT(RowType - MNPARAM_CSV_DAT_NUM);
	
			// Index
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvNumRow.wIdxNumPar := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			IF RowType = 10 THEN
	
				// Value Integer
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					CsvNumRow.diValue := atoi(ADR(_sSubString) );
						
				END_IF
	
			ELSE
	
				// Value Real
				IF NOT _GetNextSubstring.EndOfLine THEN
		
					_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
					_utfSubString := "";
			
					brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
					brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
					_rValue := atof(ADR(_sSubString));
					_pdiValue ACCESS ADR(_rValue);
					CsvNumRow.diValue := _pdiValue;
						
				END_IF
				
			END_IF
	
			//  ArrIndex1
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvNumRow.wArrIdx1 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			//  ArrIndex2
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvNumRow.wArrIdx2 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			//  ArrIndex3
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvNumRow.wArrIdx3 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			//  ArrIndex4
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
	
				_utfSubString := "";
			
				brwcsncpy(ADR(_utfSubString), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 63));
				brwcsconv(ADR(_sSubString), ADR(_utfSubString), 1);
				_diNum := atoi(ADR(_sSubString) );
						
				CsvNumRow.wArrIdx4 := DINT_TO_UINT(LIMIT(0, _diNum, 65535));
	
			END_IF
	
			// Machine Sub Type
			IF NOT _GetNextSubstring.EndOfLine THEN
		
				_GetNextSubstring(pUtfCsvString := _pUtfCsvString);
			
				brwcsncpy(ADR(CsvNumRow.utfMachineSubType), _GetNextSubstring.pUtfCsvSubstring, MIN(_GetNextSubstring.Length, 11));
	
			END_IF
	
	
	
		END_IF	

	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
		
END_FUNCTION_BLOCK
