(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: _actProcSQLDFII.st
 * Author: hunholz
 * Created: June 20, 2012
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************) 

(* Process SQL-Queries *)
ACTION _actProcSQLDFII: 
	
	CASE _eStep OF
		
		eSQLREQ_STEP_STOP:
		
		eSQLREQ_STEP_WAITFORCOMMAND:
		
		(* Verbinde Datenbank *)
		eSQLREQ_STEP_CONNECT:
		
			_DFII_Connect.enable := TRUE;
			_DFII_Connect.databaseSystem := DB_SYSTEM_MS_SQL;
			_DFII_Connect.pUserName := ADR('plc');
			_DFII_Connect.pPassword := ADR('plc');
			_DFII_Connect.pServerName := ADR(_CreateConnStringDFII.ConnString);
			_DFII_Connect.pDatabaseName := ADR(hlDFIIPar.Mac.DFIIConn.sDBname);
			_eStep := eSQLREQ_STEP_CONNECT_r;
			
		(* Warte bis mit Datenbank verbunden *)
		eSQLREQ_STEP_CONNECT_r:
		
			_DFII_Connect();
				
			IF _DFII_Connect.status = ERR_OK THEN
				
				// Verbindung Erfolgreich
				
				IF _DFII_Connect.connectionIdent = 0 THEN
					
					// Wenn Verbindung nicht möglich, immer erst wieder Zeit holen und Maschine registrieren
					_bEventRegMach := 1;
					_bEventGetTime := 1;
					IFhlDFII.Out.xConnected := FALSE;

					// Fehler ist Clientseitig
					_sLogEntryI := 'Client Fault: Connect failed! ';
					_sLogEntryI := CONCAT(_sLogEntryI,_CreateConnStringDFII.ConnString);
					_eStep := eSQLREQ_STEP_LOGRB_ERROR;
					
				ELSE
						
					IFhlDFII.Out.xConnected := TRUE;
						
					_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
					_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tCONNECT');
					_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

					_lConnectionIdent := _DFII_Connect.connectionIdent;
					_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
				END_IF
				
			ELSIF _DFII_Connect.status <> ERR_FUB_BUSY THEN

				// Wenn Verbindung nicht möglich, immer erst wieder Zeit holen und Maschine registrieren
				_bEventRegMach := 1;
				_bEventGetTime := 1;
				IFhlDFII.Out.xConnected := FALSE;
					
				// Verbindung fehlerbehaftet
				IF _DFII_Connect.connectionIdent <> 0 THEN
					
					// Fehler ist Serverseitig, Fehlermeldung holen
					
					_lConnectionIdent := _DFII_Connect.connectionIdent;
					_sAction := 'Connect failed:';
					_eStep := eSQLREQ_STEP_GET_ERROR;
					
				ELSE
					
					// Keine Verbindung zustande gekommen
					_sLogEntryI := 'Connect failed! ';
					_sLogEntryI := CONCAT(_sLogEntryI,_CreateConnStringDFII.ConnString);
						
					_eStep := eSQLREQ_STEP_LOGRB_ERROR;
					
				END_IF
				
			END_IF
			
		
		(* Baue Datenbankverbindung ab *)
		eSQLREQ_STEP_DISCONNECT:
		
			IF _lConnectionIdent <> 0 THEN
				_DFII_Disconnect.enable := TRUE;
				_DFII_Disconnect.connectionIdent := _lConnectionIdent;
				_eStep := eSQLREQ_STEP_DISCONNECT_r;
			ELSE
				_eStep := eSQLREQ_STEP_STOP;
			END_IF
			
		(* Warte bis Verbindung abgebaut ist *)
		eSQLREQ_STEP_DISCONNECT_r:
		
			_DFII_Disconnect();
			
			IF _DFII_Disconnect.status <> ERR_FUB_BUSY THEN
				
				// Verbindung erfolgreich unterbrochen
				
				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tDISCONNECT');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
					
				_eStep := eSQLREQ_STEP_STOP;
				_lConnectionIdent := 0;
				
			END_IF
		
		(* Lese Programmnummer aus Datenbank *)
		eSQLREQ_STEP_GPBC:
			
			_sCat := IFhlDFII.In.ReqProgByCat.sCategoryNo_In;
			
			brsstrcpy(ADR(_sSQLstring), ADR('SELECT [ProgramNo], [ProgramName], [CategoryName], [LoadFactor], [SoiledFactor], [fgColorIndex], [bgColorIndex]  FROM [dbo].[vwCatToProg01] WHERE [MachineID] = N$''));
			brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
			IF (IFhlDFII.In.ReqProgByCat.wRequest = 2) THEN
				brsstrcat(ADR(_sSQLstring),ADR('$' AND  LTRIM(RTRIM(CategoryNoAlpha)) =  LTRIM(RTRIM($''));
			ELSE
				brsstrcat(ADR(_sSQLstring),ADR('$' AND [CategoryNo] = '));
			END_IF
			brsstrcat(ADR(_sSQLstring),ADR(_sCat));
			IF (IFhlDFII.In.ReqProgByCat.wRequest = 2) THEN
				brsstrcat(ADR(_sSQLstring),ADR('$'))'));
			END_IF				
			
			_DFII_DBExecute.enable := TRUE;
			_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
			_DFII_DBExecute.connectionIdent := _lConnectionIdent;
			
			_eStep := eSQLREQ_STEP_GPBC_r;
			
		eSQLREQ_STEP_GPBC_r:
			
			_DFII_DBExecute();
			
			IF _DFII_DBExecute.status = ERR_OK THEN

				_eStep := eSQLREQ_STEP_GPBC_FETCH;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				IF _DFII_DBExecute.dbError = DB_SQL_NO_DATA THEN

					_eStep := eSQLREQ_STEP_WAITFORCOMMAND;

				ELSE

					_sAction := 'Get Program failed:';
					_eStep := eSQLREQ_STEP_GET_ERROR;

				END_IF

			END_IF

		(* Zeile holen *)
		eSQLREQ_STEP_GPBC_FETCH:			
	
			_DFII_DBFetch.enable := TRUE;
			_DFII_DBFetch.connectionIdent := _lConnectionIdent;
			_eStep := eSQLREQ_STEP_GPBC_FETCH_r;
			
		eSQLREQ_STEP_GPBC_FETCH_r:
		
			_DFII_DBFetch();
			
			IF _DFII_DBFetch.status = ERR_OK THEN
				
				_bCol := 1;
				_eStep := eSQLREQ_STEP_GPBC_GETVAL;
			
			ELSIF _DFII_DBFetch.status <> ERR_FUB_BUSY THEN
				
				IF _DFII_DBFetch.dbError = DB_SQL_NO_DATA THEN
					
					_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
				ELSE
				
					_sAction := 'Get Program failed (FETCH):';
					_eStep := eSQLREQ_STEP_GET_ERROR;
				
				END_IF
		
			END_IF
				
		(* Werte holen *)
		
		eSQLREQ_STEP_GPBC_GETVAL:
		
			_DFII_GetData.enable := TRUE;
			_DFII_GetData.connectionIdent := _lConnectionIdent;
			_DFII_GetData.columnIdx := _bCol;
			
			CASE _bCol OF
				
				1:	_DFII_GetData.pData := ADR(_iProgNo);
					_DFII_GetData.dataSize := SIZEOF(_iProgNo);
					_DFII_GetData.dataType := DB_SQL_SMALLINT;
					
				2: 	_DFII_GetData.pData := ADR(IFhlDFII.Out.RespProgByCat.sProgramName);
					_DFII_GetData.dataSize := SIZEOF(IFhlDFII.Out.RespProgByCat.sProgramName);
					_DFII_GetData.dataType := DB_SQL_CHAR;

				3: 	_DFII_GetData.pData := ADR(IFhlDFII.Out.RespProgByCat.sCategoryName);
					_DFII_GetData.dataSize := SIZEOF(IFhlDFII.Out.RespProgByCat.sCategoryName);
					_DFII_GetData.dataType := DB_SQL_CHAR;

				4: 	_DFII_GetData.pData := ADR(_rLoadfactor);
					_DFII_GetData.dataSize := SIZEOF(_rLoadfactor);
					_DFII_GetData.dataType := DB_SQL_REAL;

				5: 	_DFII_GetData.pData := ADR(IFhlDFII.Out.RespProgByCat.rSoilfactor);
					_DFII_GetData.dataSize := SIZEOF(IFhlDFII.Out.RespProgByCat.rSoilfactor);
					_DFII_GetData.dataType := DB_SQL_REAL;

				6: 	_DFII_GetData.pData := ADR(_diColIdxFor);
					_DFII_GetData.dataSize := SIZEOF(_diColIdxFor);
					_DFII_GetData.dataType := DB_SQL_INTEGER;

				7: 	_DFII_GetData.pData := ADR(_diColIdxBack);
					_DFII_GetData.dataSize := SIZEOF(_diColIdxBack);
					_DFII_GetData.dataType := DB_SQL_INTEGER;

			END_CASE
			
			_eStep := eSQLREQ_STEP_GPBC_GETVAL_r;
			
		eSQLREQ_STEP_GPBC_GETVAL_r:
		
			_DFII_GetData();
			
			IF _DFII_GetData.status = ERR_OK THEN
				
				_bCol := _bCol + 1;
				
				IF _bCol <= 7 THEN
					_eStep := eSQLREQ_STEP_GPBC_GETVAL;
				ELSE
					IF _iProgNo >= 0 AND _iProgNo <= 99 THEN
							
						IFhlDFII.Out.RespProgByCat.bProgramNo := INT_TO_USINT(_iProgNo);
						IFhlDFII.Out.RespProgByCat.wLoadrate := REAL_TO_UINT(_rLoadfactor);
						IFhlDFII.Out.RespProgByCat.wColorIdxFor := DINT_TO_UINT(_diColIdxFor);
						IFhlDFII.Out.RespProgByCat.wColorIdxBack := DINT_TO_UINT(_diColIdxBack);
							
					ELSE

						IFhlDFII.Out.RespProgByCat.bProgramNo := 0;
						IFhlDFII.Out.RespProgByCat.wLoadrate := 100;
						IFhlDFII.Out.RespProgByCat.wColorIdxFor := 0;
						IFhlDFII.Out.RespProgByCat.wColorIdxBack := 15;

					END_IF
					
					_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
					_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tGET PROG BY CAT');
					_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
						
					_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
				END_IF
				
			ELSIF _DFII_GetData.status <> ERR_FUB_BUSY THEN
				_sAction := 'Get Program failed (VAL):';
				_eStep := eSQLREQ_STEP_GET_ERROR;
			END_IF
				
		// Meldungen per Prozedur schreiben
		eSQLREQ_STEP_WRMSG:
			
			IF _bCntWrMsg > IFhlDFII.In.ReqMsgEvt.bCntLines THEN
					 
				_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
					 	
			ELSE
			
				brsstrcpy(ADR(_sSQLstring), ADR('EXEC [dbo].[spInsMsgEvt01]  @MachineID = N$''));
				brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
				brsstrcat(ADR(_sSQLstring), ADR('$''));
					
				brsstrcat(ADR(_sSQLstring),ADR(', @FunctionID = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].wFunction_ID,ADR(_sFunctionID));
				brsstrcat(ADR(_sSQLstring),ADR(_sFunctionID));

				brsstrcat(ADR(_sSQLstring),ADR(', @MsgNo = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].wMsgNumber,ADR(_sMsgNo));
				brsstrcat(ADR(_sSQLstring),ADR(_sMsgNo));
			
				brsstrcat(ADR(_sSQLstring),ADR(', @Instance = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].wInstance,ADR(_sInstance));
				brsstrcat(ADR(_sSQLstring),ADR(_sInstance));
			
				brsstrcat(ADR(_sSQLstring),ADR(', @MsgClass = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].wMsgClass,ADR(_sClass));
				brsstrcat(ADR(_sSQLstring),ADR(_sClass));
			
				brsstrcat(ADR(_sSQLstring),ADR(', @Event = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].wEvent,ADR(_sEvent));
				brsstrcat(ADR(_sSQLstring),ADR(_sEvent));
			
				brsstrcat(ADR(_sSQLstring),ADR(', @TimeStamp = '));
				brsitoa(DT_TO_DINT(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].TimeStampEvent),ADR(_sTimeStamp));
				brsstrcat(ADR(_sSQLstring),ADR(_sTimeStamp));

				brsstrcat(ADR(_sSQLstring),ADR(', @Time = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].lTime,ADR(_sTime));
				brsstrcat(ADR(_sSQLstring),ADR(_sTime));

				// ##AH20111118
				brsstrcat(ADR(_sSQLstring),ADR(', @Attr1 = $''));
				brsstrcat(ADR(_sSQLstring),ADR(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].sAttrTxt));

				brsstrcat(ADR(_sSQLstring),ADR('$', @Attr2 = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].diAttr1,ADR(_sValue));
				brsstrcat(ADR(_sSQLstring),ADR(_sValue));

				brsstrcat(ADR(_sSQLstring),ADR(', @Attr3 = '));
				brsitoa(IFhlDFII.In.ReqMsgEvt.MsgHistList[_bCntWrMsg].diAttr2,ADR(_sValue));
				brsstrcat(ADR(_sSQLstring),ADR(_sValue));


				_DFII_DBExecute.enable := TRUE;
				_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
				_DFII_DBExecute.connectionIdent := _lConnectionIdent;

				_eStep := eSQLREQ_STEP_WRMSG_r;
					
			END_IF
	
		eSQLREQ_STEP_WRMSG_r:
			
			_DFII_DBExecute();
				
			IF _DFII_DBExecute.status = ERR_OK  OR _DFII_DBExecute.dbError = DB_SQL_NO_DATA THEN
					
				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tWRITE MESSAGE');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

				_bCntWrMsg := _bCntWrMsg + 1;
				_eStep := eSQLREQ_STEP_WRMSG;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				_sAction := 'Write Msg failed:';
				
				_eStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

		// Postendaten schreiben
		eSQLREQ_STEP_WRCNTBATCHEVT:
			
			IF _bCntWrCntBatchEvt > IFhlDFII.In.ReqCntBatchEvt.bCntLines THEN
					 
				_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
					 	
			ELSE
					
				CASE IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].bEvent OF
						
					MNCNT_BATCHEVENT_LOAD, MNCNT_BATCHEVENT_UNLOAD:

						_sSQLstring := 'EXEC [dbo].[spInsEventStat] ';

						_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bBatchNo);
							
						IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bTypeBatchNo = 0 THEN
								
							brsstrcat(ADR(_sSQLstring), ADR('@BatchID_INT = '));
							kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
							brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
								
						ELSE

							brsstrcat(ADR(_sSQLstring), ADR('@BatchID_GUID = $''));
							_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
							brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
							brsstrcat(ADR(_sSQLstring), ADR('$''));
								
						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR(', @MachineID = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						brsstrcat(ADR(_sSQLstring), ADR(', @CategoryNoAlpha = $''));
						brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.sCategory));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						brsstrcat(ADR(_sSQLstring), ADR(', @ProgNo = '));
						itoa(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].bProgram, ADR(_sValue));
						brsstrcat(ADR(_sSQLstring), ADR(_sValue));

						brsstrcat(ADR(_sSQLstring), ADR(', @Selection = N$''));
						brwcsconv(ADR(_sMark), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.utfMark), 1);
						brsstrcat(ADR(_sSQLstring), ADR(_sMark));
						brsstrcat(ADR(_sSQLstring), ADR('$''));
							
						brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
						_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.dtTimeStamp);
						brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
						brsstrcat(ADR(_sSQLstring), ADR('$'$R$L'));
							
						IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bCntCustomers > 0 AND IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bCntCustomers <= 8 THEN
								
							FOR _ii := 1 TO IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bCntCustomers DO
									
								_idxCustomer := _ii - 1;
									
								brsstrcat(ADR(_sSQLstring), ADR('EXEC [dbo].[spInsEventStatItem_PartBatch] '));

								_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bBatchNo);
							
								IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bTypeBatchNo = 0 THEN
								
									brsstrcat(ADR(_sSQLstring), ADR('@BatchID_INT = '));
									kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
									brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
								
								ELSE

									brsstrcat(ADR(_sSQLstring), ADR('@BatchID_GUID = $''));
									_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
									brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
									brsstrcat(ADR(_sSQLstring), ADR('$''));
								
								END_IF
							
								brsstrcat(ADR(_sSQLstring), ADR(', @Machine = N$''));
								brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
								brsstrcat(ADR(_sSQLstring), ADR('$''));

								brsstrcat(ADR(_sSQLstring), ADR(', @PartBatchID = '));
								brsitoa(_ii, ADR(_sValue));
								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
									
								brsstrcat(ADR(_sSQLstring), ADR(', @ActualAmount = '));
								_sValue := REAL_TO_STRING(UINT_TO_REAL(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.PartBatch[_idxCustomer].wCustomWeight)/10.0);
								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
									
								brsstrcat(ADR(_sSQLstring), ADR(', @Customer = $''));
								brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.PartBatch[_idxCustomer].sCustomNo));
								brsstrcat(ADR(_sSQLstring), ADR('$''));

								IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].bEvent = MNCNT_BATCHEVENT_LOAD THEN

									brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 1, @ToOutside = 0 '));

								END_IF	

								IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].bEvent = MNCNT_BATCHEVENT_UNLOAD THEN

									brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 0, @ToOutside = 1  '));

								END_IF	

								brsstrcat(ADR(_sSQLstring), ADR(', @FromName = N$''));
								brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].FromLocation.sNameId));
								brsstrcat(ADR(_sSQLstring), ADR('$''));

								brsstrcat(ADR(_sSQLstring), ADR(', @ToName = N$''));
								brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].ToLocation.sNameId));
								brsstrcat(ADR(_sSQLstring), ADR('$''));

								brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
								_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.dtTimeStamp);
								brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
								brsstrcat(ADR(_sSQLstring), ADR('$'$R$L'));
									
							END_FOR

							_DFII_DBExecute.enable := TRUE;
							_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
							_DFII_DBExecute.connectionIdent := _lConnectionIdent;

						END_IF

						_sSQLBatchEventString := _sSQLstring;

						_eStep := eSQLREQ_STEP_WRCNTBATCHEVT_r;

					MNCNT_BATCHEVENT_CHANGEDATA:

						_sSQLstring := 'EXEC [dbo].[spUpdEventStat] ';

						_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bBatchNo);
							
						IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bTypeBatchNo = 0 THEN
								
							brsstrcat(ADR(_sSQLstring), ADR('@BatchID_INT = '));
							kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
							brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
								
						ELSE

							brsstrcat(ADR(_sSQLstring), ADR('@BatchID_GUID = $''));
							_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
							brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
							brsstrcat(ADR(_sSQLstring), ADR('$''));
								
						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR(', @MachineID = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						brsstrcat(ADR(_sSQLstring), ADR(', @CategoryNoAlpha = $''));
						brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.sCategory));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						brsstrcat(ADR(_sSQLstring), ADR(', @ProgNo = '));
						itoa(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].bProgram, ADR(_sValue));
						brsstrcat(ADR(_sSQLstring), ADR(_sValue));

						brsstrcat(ADR(_sSQLstring), ADR(', @Selection = N$''));
						brwcsconv(ADR(_sMark), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.utfMark), 1);
						brsstrcat(ADR(_sSQLstring), ADR(_sMark));
						brsstrcat(ADR(_sSQLstring), ADR('$''));
							
						brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
						_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.dtTimeStamp);
						brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
						brsstrcat(ADR(_sSQLstring), ADR('$'$R$L'));
							
						IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bCntCustomers > 0 AND IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bCntCustomers <= 8 THEN
								
							FOR _ii := 1 TO IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bCntCustomers DO
									
								_idxCustomer := _ii - 1;
									
								brsstrcat(ADR(_sSQLstring), ADR('EXEC [dbo].[spUpdEventStatItem_PartBatch] '));

								_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bBatchNo);
							
								IF IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.bTypeBatchNo = 0 THEN
								
									brsstrcat(ADR(_sSQLstring), ADR('@BatchID_INT = '));
									kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
									brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
								
								ELSE

									brsstrcat(ADR(_sSQLstring), ADR('@BatchID_GUID = $''));
									_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
									brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
									brsstrcat(ADR(_sSQLstring), ADR('$''));
								
								END_IF
							
								brsstrcat(ADR(_sSQLstring), ADR(', @Machine = N$''));
								brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
								brsstrcat(ADR(_sSQLstring), ADR('$''));

								brsstrcat(ADR(_sSQLstring), ADR(', @PartBatchID = '));
								brsitoa(_ii, ADR(_sValue));
								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
									
								brsstrcat(ADR(_sSQLstring), ADR(', @ActualAmount = '));
								_sValue := REAL_TO_STRING(UINT_TO_REAL(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.PartBatch[_idxCustomer].wCustomWeight)/10.0);
								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
									
								brsstrcat(ADR(_sSQLstring), ADR(', @Customer = $''));
								brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.PartBatch[_idxCustomer].sCustomNo));
								brsstrcat(ADR(_sSQLstring), ADR('$''));

								brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
								_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_bCntWrCntBatchEvt].Batch.dtTimeStamp);
								brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
								brsstrcat(ADR(_sSQLstring), ADR('$'$R$L'));
									
							END_FOR

							_DFII_DBExecute.enable := TRUE;
							_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
							_DFII_DBExecute.connectionIdent := _lConnectionIdent;

						END_IF

						_sSQLBatchEventString := _sSQLstring;
							
						_eStep := eSQLREQ_STEP_WRCNTBATCHEVT_r;

						
					MNCNT_BATCHEVENT_DELETE:

						_bCntWrCntBatchEvt := _bCntWrCntBatchEvt + 1;

				END_CASE

					
			END_IF
	
		eSQLREQ_STEP_WRCNTBATCHEVT_r:
			
			_DFII_DBExecute();
				
			IF _DFII_DBExecute.status = ERR_OK  OR _DFII_DBExecute.dbError = DB_SQL_NO_DATA THEN

				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tWRITE BATCH EVENT');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
					
				_bCntWrCntBatchEvt := _bCntWrCntBatchEvt + 1;
				_eStep := eSQLREQ_STEP_WRCNTBATCHEVT;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				_sAction := 'Write Batch failed:';
				_eStep := eSQLREQ_STEP_GET_ERROR;

			END_IF
			
		eSQLREQ_STEP_WRCNTCNTEVT:
			
			IF _bCntWrCntCntEvt > IFhlDFII.In.ReqCntCntEvt.bCntLines THEN
					 
				_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
					 	
			ELSE
					
				CASE IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].bType OF
						
					MNCNT_COUNTERTYPE_WATER:
							
						_sSQLstring := 'EXEC [dbo].[spInsEventStatItem_Water] ';
							
						brsstrcat(ADR(_sSQLstring), ADR('@Machine = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].BatchNo);
							
						IF NOT kgGUIDisZero(_kgUSINT16toGUID.GUID) THEN
							
							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].bTypeBatchNo = 0 THEN
									
								brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_INT = '));
								kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
								brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
									
							ELSE
	
								brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_GUID = $''));
								_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
								brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
								brsstrcat(ADR(_sSQLstring), ADR('$''));
									
							END_IF

						END_IF

						brsstrcat(ADR(_sSQLstring), ADR(', @ActualAmount = '));
						_sValue := REAL_TO_STRING(UDINT_TO_REAL(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].lAmount));
						brsstrcat(ADR(_sSQLstring), ADR(_sValue));
							
						brsstrcat(ADR(_sSQLstring), ADR(', @TargetAmount = '));
						_sValue := REAL_TO_STRING(UDINT_TO_REAL(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].lNomAmount));
						brsstrcat(ADR(_sSQLstring), ADR(_sValue));

						//							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.bCompartment > 0 THEN
						//
						//								brsstrcat(ADR(_sSQLstring), ADR(', @FromChamber = '));
						//								_sValue := USINT_TO_STRING(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.bCompartment);
						//								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
						//
						//							ELSE

						brsstrcat(ADR(_sSQLstring), ADR(', @FromName = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.sNameId));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						//							END_IF
							
						IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.bLocationExt > 0 THEN
								
							brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 1'));
								
						ELSE

							brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 0'));

						END_IF
							
						//							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bCompartment > 0 THEN
						//
						//								brsstrcat(ADR(_sSQLstring), ADR(', @ToChamber = '));
						//								_sValue := USINT_TO_STRING(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bCompartment);
						//								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
						//
						//							ELSE

						brsstrcat(ADR(_sSQLstring), ADR(', @ToName = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.sNameId));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						//							END_IF
							
						IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bLocationExt > 0 THEN
								
							brsstrcat(ADR(_sSQLstring), ADR(', @ToOutside = 1'));

						ELSE
								
							brsstrcat(ADR(_sSQLstring), ADR(', @ToOutside = 0'));

						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
						_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].dtTimeStamp);
						brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
						brsstrcat(ADR(_sSQLstring), ADR('$''));
						
						_DFII_DBExecute.enable := TRUE;
						_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
						_DFII_DBExecute.connectionIdent := _lConnectionIdent;

						_eStep := eSQLREQ_STEP_WRCNTCNTEVT_r;


					MNCNT_COUNTERTYPE_TEMPERATURE:

						_sSQLstring := 'EXEC [dbo].[spInsEventStatItem_Temperature] ';
							
						brsstrcat(ADR(_sSQLstring), ADR('@Machine = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].BatchNo);
							
						IF NOT kgGUIDisZero(_kgUSINT16toGUID.GUID) THEN
							
							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].bTypeBatchNo = 0 THEN
									
								brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_INT = '));
								kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
								brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
									
							ELSE
	
								brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_GUID = $''));
								_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
								brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
								brsstrcat(ADR(_sSQLstring), ADR('$''));
									
							END_IF

						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR(', @ActualAmount = '));
						_sValue := REAL_TO_STRING(UDINT_TO_REAL(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].lAmount));
						brsstrcat(ADR(_sSQLstring), ADR(_sValue));
							
						brsstrcat(ADR(_sSQLstring), ADR(', @TargetAmount = '));
						_sValue := REAL_TO_STRING(UDINT_TO_REAL(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].lNomAmount));
						brsstrcat(ADR(_sSQLstring), ADR(_sValue));

						//							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bCompartment > 0 THEN
						//
						//								brsstrcat(ADR(_sSQLstring), ADR(', @LocationChamber = '));
						//								_sValue := USINT_TO_STRING(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bCompartment);
						//								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
						//
						//							ELSE

						brsstrcat(ADR(_sSQLstring), ADR(', @LocationName = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.sNameId));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						//							END_IF
							
						IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bLocationExt > 0 THEN
								
							brsstrcat(ADR(_sSQLstring), ADR(', @LocationOutside = 1'));

						ELSE
								
							brsstrcat(ADR(_sSQLstring), ADR(', @LocationOutside = 0'));

						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
						_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].dtTimeStamp);
						brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
						brsstrcat(ADR(_sSQLstring), ADR('$''));
							
						_DFII_DBExecute.enable := TRUE;
						_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
						_DFII_DBExecute.connectionIdent := _lConnectionIdent;

						_eStep := eSQLREQ_STEP_WRCNTCNTEVT_r;


					MNCNT_COUNTERTYPE_STEAM, MNCNT_COUNTERTYPE_ELECTRICENERGY, MNCNT_COUNTERTYPE_GAS:

						IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].bType = MNCNT_COUNTERTYPE_STEAM THEN
							_sSQLstring := 'EXEC [dbo].[spInsEventStatItem_Steam] ';
						ELSIF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].bType = MNCNT_COUNTERTYPE_GAS THEN
							_sSQLstring := 'EXEC [dbo].[spInsEventStatItem_Gas] ';
						ELSE
							_sSQLstring := 'EXEC [dbo].[spInsEventStatItem_Energy] ';
						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR('@Machine = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].BatchNo);
							
						IF NOT kgGUIDisZero(_kgUSINT16toGUID.GUID) THEN
							
							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].bTypeBatchNo = 0 THEN
									
								brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_INT = '));
								kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
								brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
									
							ELSE
	
								brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_GUID = $''));
								_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
								brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
								brsstrcat(ADR(_sSQLstring), ADR('$''));
									
							END_IF

						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR(', @ActualAmount = '));
						_sValue := REAL_TO_STRING(UDINT_TO_REAL(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].lAmount));
						brsstrcat(ADR(_sSQLstring), ADR(_sValue));
							
						//							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.bCompartment > 0 THEN
						//
						//								brsstrcat(ADR(_sSQLstring), ADR(', @FromChamber = '));
						//								_sValue := USINT_TO_STRING(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.bCompartment);
						//								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
						//
						//							ELSE

						brsstrcat(ADR(_sSQLstring), ADR(', @FromName = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.sNameId));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						//							END_IF
							
						IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Source.bLocationExt > 0 THEN
								
							brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 1'));

						ELSE
								
							brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 0'));

						END_IF
							
						//							IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bCompartment > 0 THEN
						//
						//								brsstrcat(ADR(_sSQLstring), ADR(', @ToChamber = '));
						//								_sValue := USINT_TO_STRING(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bCompartment);
						//								brsstrcat(ADR(_sSQLstring), ADR(_sValue));
						//
						//							ELSE

						brsstrcat(ADR(_sSQLstring), ADR(', @ToName = N$''));
						brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.sNameId));
						brsstrcat(ADR(_sSQLstring), ADR('$''));

						//							END_IF
							
						IF IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].Destination.bLocationExt > 0 THEN
								
							brsstrcat(ADR(_sSQLstring), ADR(', @ToOutside = 1'));
							
						ELSE

							brsstrcat(ADR(_sSQLstring), ADR(', @ToOutside = 0'));

						END_IF
							
						brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
						_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_bCntWrCntCntEvt].dtTimeStamp);
						brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
						brsstrcat(ADR(_sSQLstring), ADR('$''));
							
						_DFII_DBExecute.enable := TRUE;
						_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
						_DFII_DBExecute.connectionIdent := _lConnectionIdent;

						_eStep := eSQLREQ_STEP_WRCNTCNTEVT_r;


					ELSE
							
						_bCntWrCntCntEvt := _bCntWrCntCntEvt + 1;							
							
				END_CASE
					
					
			END_IF
			
		eSQLREQ_STEP_WRCNTCNTEVT_r:
			
			_DFII_DBExecute();
				
			IF _DFII_DBExecute.status = ERR_OK  OR _DFII_DBExecute.dbError = DB_SQL_NO_DATA THEN

				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tWRITE COUNT EVENT');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

				_bCntWrCntCntEvt := _bCntWrCntCntEvt + 1;
				_eStep := eSQLREQ_STEP_WRCNTCNTEVT;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				_sAction := 'Write Counter failed:';
				_eStep := eSQLREQ_STEP_GET_ERROR;

			END_IF
			
		// Zeitzähler senden
			
		eSQLREQ_STEP_WRCNTTIMEVT:
			
			IF _bCntWrCntTimeEvt > IFhlDFII.In.ReqCntTimEvt.bCntLines THEN
					 
				_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
					 	
			ELSE
					
							
				_sSQLstring := 'EXEC [dbo].[spInsEventStatItem_StateTime] ';
							
				brsstrcat(ADR(_sSQLstring), ADR('@Machine = N$''));
				brsstrcat(ADR(_sSQLstring), ADR(_sMNo));			
				brsstrcat(ADR(_sSQLstring), ADR('$''));

				brsstrcat(ADR(_sSQLstring), ADR(', @ActualAmount = '));
				_sValue := REAL_TO_STRING(UDINT_TO_REAL(IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].lAmount));
				brsstrcat(ADR(_sSQLstring), ADR(_sValue));
					
				IF IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].bState = MNCNT_TIMERSTATE_PAUSED THEN
						
					brsstrcat(ADR(_sSQLstring), ADR(', @State = $'PAUSED$''));
						
					CASE IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].bSubState OF
							
						MNCNT_TIMERSUBSTATE_OFF:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'OFF$''));

						MNCNT_TIMERSUBSTATE_STOP:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'STOP$''));
								
						MNCNT_TIMERSUBSTATE_INTFAULT:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'INTFAULT$''));

						MNCNT_TIMERSUBSTATE_EXTFAULT:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'EXTFAULT$''));

						MNCNT_TIMERSUBSTATE_SAFESTOP:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'SAFESTOP$''));

						MNCNT_TIMERSUBSTATE_EMERGENCYSTP:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'EMERGSTOP$''));

						ELSE

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'$''));
								
					END_CASE	

				ELSIF IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].bState = MNCNT_TIMERSTATE_WAIT THEN

					brsstrcat(ADR(_sSQLstring), ADR(', @State = $'WAIT$''));

					CASE IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].bSubState OF
							
						MNCNT_TIMERSUBSTATE_LOADING:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'LOADING$''));

						MNCNT_TIMERSUBSTATE_UNLOADING:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'UNLOADING$''));
								
						MNCNT_TIMERSUBSTATE_DOSING:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'DOSING$''));

						MNCNT_TIMERSUBSTATE_WATERLEVEL:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'WATERLEVEL$''));

						MNCNT_TIMERSUBSTATE_TEMPERATURE:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'TEMP$''));

						MNCNT_TIMERSUBSTATE_DISINFECTION:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'DISINFECT$''));

						MNCNT_TIMERSUBSTATE_AIRPRESSURE:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'AIRPRESS$''));

						ELSE

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'$''));

					END_CASE	

						
				ELSIF IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].bState = MNCNT_TIMERSTATE_ACTIVE THEN

					brsstrcat(ADR(_sSQLstring), ADR(', @State = $'ACTIVE$''));

					CASE IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].bSubState OF
							
						MNCNT_TIMERSUBSTATE_WASHING:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'PROCESSING$''));

						MNCNT_TIMERSUBSTATE_PREPERATION:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'PREP$''));
								
						MNCNT_TIMERSUBSTATE_TRANSFER:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'TRANSFER$''));

						MNCNT_TIMERSUBSTATE_PREPFORSTOP:

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'PREPFORSTOP$''));

						ELSE

							brsstrcat(ADR(_sSQLstring), ADR(', @SubState = $'$''));

					END_CASE	

				ELSE

					brsstrcat(ADR(_sSQLstring), ADR(', @State = $'$', @SubState = $'$''));
							
				END_IF

				brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
				_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_bCntWrCntTimeEvt].dtTimeStamp);
				brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
				brsstrcat(ADR(_sSQLstring), ADR('$''));
							
				_DFII_DBExecute.enable := TRUE;
				_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
				_DFII_DBExecute.connectionIdent := _lConnectionIdent;

				_eStep := eSQLREQ_STEP_WRCNTTIMEVT_r;

					
			END_IF
			
		eSQLREQ_STEP_WRCNTTIMEVT_r:
			
			_DFII_DBExecute();
				
			IF _DFII_DBExecute.status = ERR_OK  OR _DFII_DBExecute.dbError = DB_SQL_NO_DATA THEN

				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tWRITE TIME EVENT');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

				_bCntWrCntTimeEvt := _bCntWrCntTimeEvt + 1;
				_eStep := eSQLREQ_STEP_WRCNTTIMEVT;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				_sAction := 'Write Time failed:';
				_eStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

		// Dosierevents schreiben
			
		eSQLREQ_STEP_WRCNTDOSEVT:
			
			IF _bCntWrCntDoseEvt > IFhlDFII.In.ReqCntDosEvt.bCntLines THEN
					 
				_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
					 	
			ELSE
					
				_sSQLstring := 'EXEC [dbo].[spInsEventStatItem_Chemical] ';
							
				brsstrcat(ADR(_sSQLstring), ADR('@Machine = N$''));
				brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
				brsstrcat(ADR(_sSQLstring), ADR('$''));

				_kgUSINT16toGUID(usintarray := IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.BatchNo);
							
				IF NOT kgGUIDisZero(_kgUSINT16toGUID.GUID) THEN
							
					IF IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.bTypeBatchNo = 0 THEN
									
						brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_INT = '));
						kgitoa_udint(num := kgBatchNoToUDINT(_kgUSINT16toGUID.GUID),str := _sUDINT);
						brsstrcat(ADR(_sSQLstring), ADR(_sUDINT));
									
					ELSE
	
						brsstrcat(ADR(_sSQLstring), ADR(', @BatchID_GUID = $''));
						_kgGUIDtoSTRING(GUID := _kgUSINT16toGUID.GUID);
						brsstrcat(ADR(_sSQLstring), ADR(_kgGUIDtoSTRING.sOut));
						brsstrcat(ADR(_sSQLstring), ADR('$''));
									
					END_IF

				END_IF
							
				brsstrcat(ADR(_sSQLstring), ADR(', @ActualAmount = '));
				_sValue := REAL_TO_STRING(IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.rAmount);
				brsstrcat(ADR(_sSQLstring), ADR(_sValue));
							
				brsstrcat(ADR(_sSQLstring), ADR(', @TargetAmount = '));
				_sValue := REAL_TO_STRING(IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.rNomAmount);
				brsstrcat(ADR(_sSQLstring), ADR(_sValue));

				brsstrcat(ADR(_sSQLstring), ADR(', @Unit = $''));
				brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.sUnit));
				brsstrcat(ADR(_sSQLstring), ADR('$''));
					
				_sDoseName := WSTRING_TO_STRING(IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.utfName);
					
				brsstrcat(ADR(_sSQLstring), ADR(', @Name = N$''));
				brsstrcat(ADR(_sSQLstring), ADR(_sDoseName));
				brsstrcat(ADR(_sSQLstring), ADR('$''));
					
				brsstrcat(ADR(_sSQLstring), ADR(', @FromName = N$''));
				brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.Source.sNameId));
				brsstrcat(ADR(_sSQLstring), ADR('$''));

				IF IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.Source.bLocationExt > 0 THEN
						
					brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 1'));

				ELSE

					brsstrcat(ADR(_sSQLstring), ADR(', @FromOutside = 0'));

				END_IF

				brsstrcat(ADR(_sSQLstring), ADR(', @ToName = N$''));
				brsstrcat(ADR(_sSQLstring), ADR(IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.Destination.sNameId));
				brsstrcat(ADR(_sSQLstring), ADR('$''));

				IF IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.Destination.bLocationExt > 0 THEN
								
					brsstrcat(ADR(_sSQLstring), ADR(', @ToOutside = 1'));
							
				ELSE

					brsstrcat(ADR(_sSQLstring), ADR(', @ToOutside = 0'));

				END_IF

				brsstrcat(ADR(_sSQLstring), ADR(', @Time = $''));
				_mnParam_datetimetoa(dtTimestamp := IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_bCntWrCntDoseEvt].DosingEvent.dtTimeStamp);
				brsstrcat(ADR(_sSQLstring), ADR(_mnParam_datetimetoa.sDateTime));
				brsstrcat(ADR(_sSQLstring), ADR('$''));
						
				_DFII_DBExecute.enable := TRUE;
				_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
				_DFII_DBExecute.connectionIdent := _lConnectionIdent;

				_eStep := eSQLREQ_STEP_WRCNTDOSEVT_r;
					
			END_IF
			
		eSQLREQ_STEP_WRCNTDOSEVT_r:
			
			_DFII_DBExecute();
				
			IF _DFII_DBExecute.status = ERR_OK  OR _DFII_DBExecute.dbError = DB_SQL_NO_DATA THEN

				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tWRITE DOSING EVENT');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
					
				_bCntWrCntDoseEvt := _bCntWrCntDoseEvt + 1;
				_eStep := eSQLREQ_STEP_WRCNTDOSEVT;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				_sAction := 'Write Dosing failed:';
				_eStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

			
			
		// Maschine registrieren
		eSQLREQ_STEP_REGMACH:
		
	
			brsstrcpy(ADR(_sSQLstring), ADR('EXEC [dbo].[spRegMachine01]  @MachineID = N$''));
			brsstrcat(ADR(_sSQLstring), ADR(_sMNo));
			brsstrcat(ADR(_sSQLstring), ADR('$''));

			brsstrcat(ADR(_sSQLstring),ADR(', @ShortName = $''));
			brwcsconv(ADR(_sShortName),ADR(mnParamStatAd.HeaderVersion.utfMachineType),1);
			brsstrcat(ADR(_sSQLstring),ADR(_sShortName));
			brsstrcat(ADR(_sSQLstring),ADR('$''));

			brsstrcat(ADR(_sSQLstring),ADR(', @Name = $''));
			brwcsconv(ADR(_sName),ADR(mnParamStatAd.utfMachineName),1);
			brsstrcat(ADR(_sSQLstring),ADR(_sName));
			brsstrcat(ADR(_sSQLstring),ADR('$''));

			_DFII_DBExecute.enable := TRUE;
			_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
			_DFII_DBExecute.connectionIdent := _lConnectionIdent;

			_eStep := eSQLREQ_STEP_REGMACH_r;

		eSQLREQ_STEP_REGMACH_r:
	
			_DFII_DBExecute();
		
			IF _DFII_DBExecute.status = ERR_OK  OR _DFII_DBExecute.dbError = DB_SQL_NO_DATA THEN

				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tREGMACHINE');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

				_eStep := eSQLREQ_STEP_WAITFORCOMMAND;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				_sAction := 'Reg. Machine failed:';
				_eStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

		// Uhrzeit von DB lesen
		eSQLREQ_STEP_GETTIME:
	
			_sSQLstring := 'SELECT DATEDIFF(s,$'1970-01-01T00:00:00$',GETDATE())';

			_DFII_DBExecute.enable := TRUE;
			_DFII_DBExecute.pSqlStatement := ADR(_sSQLstring);
			_DFII_DBExecute.connectionIdent := _lConnectionIdent;

			_eStep := eSQLREQ_STEP_GETTIME_r;

		eSQLREQ_STEP_GETTIME_r:
	
			_DFII_DBExecute();
		
			IF _DFII_DBExecute.status = ERR_OK THEN
			
				_eStep := eSQLREQ_STEP_GETTIME_FETCH;

			ELSIF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN

				_sAction := 'Get Time failed:';
				_eStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

		(* Zeile holen *)
		eSQLREQ_STEP_GETTIME_FETCH:			

			_DFII_DBFetch.enable := TRUE;
			_DFII_DBFetch.connectionIdent := _lConnectionIdent;
			_eStep := eSQLREQ_STEP_GETTIME_FETCH_r;
	
		eSQLREQ_STEP_GETTIME_FETCH_r:

			_DFII_DBFetch();
	
			IF _DFII_DBFetch.status = ERR_OK THEN
		
				_bCol := 1;
				_eStep := eSQLREQ_STEP_GETTIME_GETVAL;
			
			ELSIF _DFII_DBFetch.status <> ERR_FUB_BUSY THEN
				
				IF _DFII_DBFetch.dbError = DB_SQL_NO_DATA THEN
					
					_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
				ELSE
				
					_sAction := 'Get Time failed (FETCH):';
					_eStep := eSQLREQ_STEP_GET_ERROR;
				
				END_IF
		
			END_IF
				
		(* Werte holen *)
		
		eSQLREQ_STEP_GETTIME_GETVAL:
		
			_DFII_GetData.enable := TRUE;
			_DFII_GetData.connectionIdent := _lConnectionIdent;
			_DFII_GetData.columnIdx := _bCol;
				
			_diTime := -1;
			_DFII_GetData.pData := ADR(_diTime);
			_DFII_GetData.dataSize := SIZEOF(_diTime);
			_DFII_GetData.dataType := DB_SQL_INTEGER;
			
			_eStep := eSQLREQ_STEP_GETTIME_GETVAL_r;
			
		eSQLREQ_STEP_GETTIME_GETVAL_r:
		
			_DFII_GetData();
			
			IF _DFII_GetData.status = ERR_OK THEN
					
				IF _diTime > 0 THEN
						
					_DTSetTime(enable := TRUE, DT1 := DINT_TO_DT(_diTime));
						
				END_IF
					
				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tSUCC$tGETTIME');
				_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
					
				_eStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
			ELSIF _DFII_GetData.status <> ERR_FUB_BUSY THEN
				_sAction := 'Get Time failed (VAL):';
				_eStep := eSQLREQ_STEP_GET_ERROR;
			END_IF

			
		(* Lese Fehler aus *)
		eSQLREQ_STEP_GET_ERROR:
		
			IF _lConnectionIdent = 0 THEN
				hlDFIIStat.sStatus := 'Connect failed !';
				_eStep := eSQLREQ_STEP_ERROR;
			ELSE
				brsmemset(ADR(hlDFIIStat.sStatus),0,SIZEOF(hlDFIIStat.sStatus));
				_DFII_DBErrMsg.enable := TRUE;
				_DFII_DBErrMsg.connectionIdent := _lConnectionIdent;
				_DFII_DBErrMsg.pErrorMessage := ADR(hlDFIIStat.sStatus);
				_DFII_DBErrMsg.errorMessageSize := SIZEOF(hlDFIIStat.sStatus);
				_eStep := eSQLREQ_STEP_GET_ERROR_r;
			END_IF
			
		(* Warte bis Fehler ausgelesen *)
		eSQLREQ_STEP_GET_ERROR_r:
		
			_DFII_DBErrMsg();
			
			IF _DFII_DBErrMsg.status = ERR_OK THEN
					
				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tWARN$t');
				_sLogEntryI := CONCAT(_sLogEntryI, _sAction);
				_sLogEntryI := CONCAT(_sLogEntryI, hlDFIIStat.sStatus);

				_eStep := eSQLREQ_STEP_LOGRB_ERROR;
					
			ELSIF _DFII_DBErrMsg.status <> ERR_FUB_BUSY THEN

				hlDFIIStat.sStatus := ' DBErrMsg.status = ';
				_sValue := UINT_TO_STRING(_DFII_DBErrMsg.status);
				hlDFIIStat.sStatus := CONCAT(hlDFIIStat.sStatus, _sValue);
					
				_sLogEntryI := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryI := CONCAT(_sLogEntryI, '-hlDFII$tWARN$t');
				_sLogEntryI := CONCAT(_sLogEntryI, _sAction);
				_sLogEntryI := CONCAT(_sLogEntryI, hlDFIIStat.sStatus);

				_eStep := eSQLREQ_STEP_LOGRB_ERROR;

			END_IF
			
		eSQLREQ_STEP_LOGRB_ERROR:
					
			_InsertRB(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
			_eStep := eSQLREQ_STEP_LOG_ERROR;
			
		eSQLREQ_STEP_LOG_ERROR:
			
			_kgArLogWrite.logLevel 	:= arlogLEVEL_WARNING;
			_kgArLogWrite.text		:= LEFT(_sLogEntryI, 127);
			_kgArLogWrite();
			
			IF _kgArLogWrite.status <> ERR_FUB_BUSY THEN
				brsmemset(ADR(_sLogEntryI), 0, SIZEOF(_sLogEntryI));
				_eStep := eSQLREQ_STEP_LOG_ERROR1;
			END_IF

		eSQLREQ_STEP_LOG_ERROR1:
			
			_kgArLogWrite.logLevel 	:= arlogLEVEL_WARNING;
			_kgArLogWrite.text		:= LEFT(_sSQLstring, 127);
			_kgArLogWrite();
			
			IF _kgArLogWrite.status <> ERR_FUB_BUSY THEN
				_eStep := eSQLREQ_STEP_ERROR;
			END_IF

		(* Fehlerschritt *)
		eSQLREQ_STEP_ERROR:
			
	END_CASE

	
END_ACTION