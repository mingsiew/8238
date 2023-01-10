(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: _actProcSQLTrack.st
 * Author: hunholz
 * Created: June 20, 2012
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************) 

(* Process SQL-Queries *)
ACTION _actProcSQLTrack: 
	
	CASE _eTrackStep OF
		
		eSQLREQ_STEP_STOP:
		
		eSQLREQ_STEP_WAITFORCOMMAND:
		
		(* Verbinde Datenbank *)
		eSQLREQ_STEP_CONNECT:
		
			
			_Track_Connect.enable := TRUE;
			_Track_Connect.databaseSystem := DB_SYSTEM_MS_SQL;
			_Track_Connect.pUserName := ADR('mas');
			_Track_Connect.pPassword := ADR('1234');
			_Track_Connect.pServerName := ADR(_CreateConnStringTracking.ConnString);
			_Track_Connect.pDatabaseName := ADR(hlDFIIPar.Mac.TrackConn.sDBname);

			_eTrackStep := eSQLREQ_STEP_CONNECT_r;

		(* Warte bis mit Datenbank verbunden *)
		eSQLREQ_STEP_CONNECT_r:
		
			_Track_Connect();
			
			IF _Track_Connect.status = ERR_OK THEN
				
				// Verbindung Erfolgreich
				
				IF _Track_Connect.connectionIdent = 0 THEN
					
					// Wenn Verbindung nicht möglich, immer erst wieder Zeit holen
					_bEventGetTrackTime := _HLDFII_REQ_START;
					IFhlDFII.Out.xTrackConnected := FALSE;

					// Fehler ist Clientseitig
					_sLogEntryT := 'Client Fault: Connect failed! ';
					_sLogEntryT := CONCAT(_sLogEntryT,_CreateConnStringTracking.ConnString);
					_eTrackStep := eSQLREQ_STEP_LOGRB_ERROR;
					
				ELSE
						
					IFhlDFII.Out.xTrackConnected := TRUE;
						
					_sLogEntryT := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
					_sLogEntryT := CONCAT(_sLogEntryT, '-hlDFII$tSUCC$tCONNECT_T');
					_InsertRBT(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

					_lConnectionTrackIdent := _Track_Connect.connectionIdent;
					_eTrackStep := eSQLREQ_STEP_WAITFORCOMMAND;
				END_IF
				
			ELSIF _Track_Connect.status <> ERR_FUB_BUSY THEN

				// Wenn Verbindung nicht möglich, immer erst wieder Zeit holen und Maschine registrieren
				_bEventGetTrackTime := _HLDFII_REQ_START;
				IFhlDFII.Out.xTrackConnected := FALSE;
					
				// Verbindung fehlerbehaftet
				IF _Track_Connect.connectionIdent <> 0 THEN
					
					// Fehler ist Serverseitig, Fehlermeldung holen
					
					_lConnectionTrackIdent := _Track_Connect.connectionIdent;
					_sTrackAction := 'Connect failed:';
					_eTrackStep := eSQLREQ_STEP_GET_ERROR;
					
				ELSE
					
					// Keine Verbindung zustande gekommen
					_sLogEntryT := 'Connect failed! ';
					_sLogEntryT := CONCAT(_sLogEntryT,_CreateConnStringTracking.ConnString);
						
					_eTrackStep := eSQLREQ_STEP_LOGRB_ERROR;
					
				END_IF
				
			END_IF
			
		
		(* Baue Datenbankverbindung ab *)
		eSQLREQ_STEP_DISCONNECT:
		
			IF _lConnectionTrackIdent <> 0 THEN
				_Track_Disconnect.enable := TRUE;
				_Track_Disconnect.connectionIdent := _lConnectionTrackIdent;
				_eTrackStep := eSQLREQ_STEP_DISCONNECT_r;
			ELSE
				_eTrackStep := eSQLREQ_STEP_STOP;
			END_IF
			
		(* Warte bis Verbindung abgebaut ist *)
		eSQLREQ_STEP_DISCONNECT_r:
		
			_Track_Disconnect();
			
			IF _Track_Disconnect.status <> ERR_FUB_BUSY THEN
				
				// Verbindung erfolgreich unterbrochen
				
				_sLogEntryT := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryT := CONCAT(_sLogEntryT, '-hlDFII$tSUCC$tDISCONNECT_T');
				_InsertRBT(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
					
				_eTrackStep := eSQLREQ_STEP_STOP;
				_lConnectionTrackIdent := 0;
				
			END_IF

		// Uhrzeit von DB lesen
		eSQLREQ_STEP_GETTIME:
	
			_sSQLstringTrack := 'SELECT DATEDIFF(s,$'1970-01-01T00:00:00$',GETDATE())';

			_Track_DBExecute.enable := TRUE;
			_Track_DBExecute.pSqlStatement := ADR(_sSQLstringTrack);
			_Track_DBExecute.connectionIdent := _lConnectionTrackIdent;

			_eTrackStep := eSQLREQ_STEP_GETTIME_r;

		eSQLREQ_STEP_GETTIME_r:
	
			_Track_DBExecute();
		
			IF _Track_DBExecute.status = ERR_OK THEN
			
				_eTrackStep := eSQLREQ_STEP_GETTIME_FETCH;

			ELSIF _Track_DBExecute.status <> ERR_FUB_BUSY THEN

				_sTrackAction := 'Get Time failed:';
				_eTrackStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

		(* Zeile holen *)
		eSQLREQ_STEP_GETTIME_FETCH:			

			_Track_DBFetch.enable := TRUE;
			_Track_DBFetch.connectionIdent := _lConnectionTrackIdent;
			_eTrackStep := eSQLREQ_STEP_GETTIME_FETCH_r;
	
		eSQLREQ_STEP_GETTIME_FETCH_r:

			_Track_DBFetch();
	
			IF _Track_DBFetch.status = ERR_OK THEN
		
				_bTrackCol := 1;
				_eTrackStep := eSQLREQ_STEP_GETTIME_GETVAL;
			
			ELSIF _Track_DBFetch.status <> ERR_FUB_BUSY THEN
				
				IF _Track_DBFetch.dbError = DB_SQL_NO_DATA THEN
					
					_eTrackStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
				ELSE
				
					_sTrackAction := 'Get Time failed (FETCH):';
					_eTrackStep := eSQLREQ_STEP_GET_ERROR;
				
				END_IF
		
			END_IF
				
		(* Werte holen *)
		
		eSQLREQ_STEP_GETTIME_GETVAL:
		
			_Track_GetData.enable := TRUE;
			_Track_GetData.connectionIdent := _lConnectionTrackIdent;
			_Track_GetData.columnIdx := _bTrackCol;
				
			_diTimeTrack := -1;
			_Track_GetData.pData := ADR(_diTimeTrack);
			_Track_GetData.dataSize := SIZEOF(_diTimeTrack);
			_Track_GetData.dataType := DB_SQL_INTEGER;
			
			_eTrackStep := eSQLREQ_STEP_GETTIME_GETVAL_r;
			
		eSQLREQ_STEP_GETTIME_GETVAL_r:
		
			_Track_GetData();
			
			IF _Track_GetData.status = ERR_OK THEN
					
				IF _diTimeTrack > 0 THEN
						
					_DTSetTime(enable := TRUE, DT1 := DINT_TO_DT(_diTimeTrack));
						
				END_IF
					
				_sLogEntryT := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryT := CONCAT(_sLogEntryT, '-hlDFII$tSUCC$tGETTIME_T');
				_InsertRBT(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
					
				_eTrackStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
			ELSIF _Track_GetData.status <> ERR_FUB_BUSY THEN
				_sTrackAction := 'Get Time failed (VAL):';
				_eTrackStep := eSQLREQ_STEP_GET_ERROR;
			END_IF

		eSQLREQ_STEP_WRUPDLOC:
		
			IF _wIdxWriteUpdateLocation > HLDFII_MAXIDX_REQ_UPDATEBATCH THEN
				
				_eTrackStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
			ELSIF _ReqUpdBatch[_wIdxWriteUpdateLocation].wLocation > 0 THEN
				
				_sSQLstringTrack := 'EXEC [BatchManagement].[uspBatchUpdate] ';
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,'@BatchNumber = ');
				
				_GetBatchno(usintarray := _ReqUpdBatch[_wIdxWriteUpdateLocation].bBatchNo);
				_lBatchNo := kgBatchNoToUDINT(_GetBatchno.GUID);
				_sTrackValue := UDINT_TO_STRING(_lBatchNo);
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackValue);
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,', @MachID = ');
				IF _ReqUpdBatch[_wIdxWriteUpdateLocation].lMachineNo > 0 THEN
					_sTrackValue := UDINT_TO_STRING(_ReqUpdBatch[_wIdxWriteUpdateLocation].lMachineNo);
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackValue);
				ELSE
					_sTrackMachineNo := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackMachineNo);
				END_IF
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,', @LocationNumber = ');
				_sTrackValue := UDINT_TO_STRING(_ReqUpdBatch[_wIdxWriteUpdateLocation].wLocation);
				_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackValue);

				_sSQLstringTrack := CONCAT(_sSQLstringTrack,', @ElementIndex = ');
				_sTrackValue := UDINT_TO_STRING(_ReqUpdBatch[_wIdxWriteUpdateLocation].wElement);
				_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackValue);
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,', @TimeStamp = $'');
				_mnParam_datetimetoa(dtTimestamp := _ReqUpdBatch[_wIdxWriteUpdateLocation].dtTimeStamp);
				_sSQLstringTrack := CONCAT(_sSQLstringTrack, _mnParam_datetimetoa.sDateTime);
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,'$'');

				_Track_DBExecute.enable := TRUE;
				_Track_DBExecute.pSqlStatement := ADR(_sSQLstringTrack);
				_Track_DBExecute.connectionIdent := _lConnectionTrackIdent;

				_eTrackStep := eSQLREQ_STEP_WRUPDLOC_r;

			ELSE
				
				_wIdxWriteUpdateLocation := _wIdxWriteUpdateLocation + 1;
				
			END_IF
		
		eSQLREQ_STEP_WRUPDLOC_r:
		
			_Track_DBExecute();
				
			IF _Track_DBExecute.status = ERR_OK  OR _Track_DBExecute.dbError = DB_SQL_NO_DATA THEN

				_dtTimeStampUpdBatch[_wIdxWriteUpdateLocation] := _ReqUpdBatch[_wIdxWriteUpdateLocation].dtTimeStamp;
				
				_wIdxWriteUpdateLocation := _wIdxWriteUpdateLocation + 1;
				_eTrackStep := eSQLREQ_STEP_WRUPDLOC;

			ELSIF _Track_DBExecute.status <> ERR_FUB_BUSY THEN

				_dtTimeStampUpdBatch[_wIdxWriteUpdateLocation] := _ReqUpdBatch[_wIdxWriteUpdateLocation].dtTimeStamp;

				_sTrackAction := 'Write Update Location failed:';
				_eTrackStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

		eSQLREQ_STEP_WRUPDSTATE:
		
			IF _wIdxWriteUpdateStatus > HLDFII_MAXIDX_REQ_UPDATESTATUS THEN
				
				_eTrackStep := eSQLREQ_STEP_WAITFORCOMMAND;
				
			ELSIF _ReqUpdStatus[_wIdxWriteUpdateStatus].xEnable AND (
				_ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX <> _wStatusX[_wIdxWriteUpdateStatus] 
				OR _ReqUpdStatus[_wIdxWriteUpdateStatus].wSubState <> _wSubState[_wIdxWriteUpdateStatus]
				OR brsstrcmp(ADR(_ReqUpdStatus[_wIdxWriteUpdateStatus]),ADR(_sSubStates[_wIdxWriteUpdateStatus])) <> 0)THEN
				
				_sSQLstringTrack := 'EXEC [BatchManagement].[uspMachineStateUpdate] ';
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,' @MachID = ');
				IF _ReqUpdStatus[_wIdxWriteUpdateStatus].lMachineNo > 0 THEN
					_sTrackValue := UDINT_TO_STRING(_ReqUpdStatus[_wIdxWriteUpdateStatus].lMachineNo);
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackValue);
				ELSE
					_sTrackMachineNo := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackMachineNo);
				END_IF
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,', @MachineState = ');
				_sTrackValue := UINT_TO_STRING(_ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX AND 16#FF);
				_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sTrackValue);

				_sSQLstringTrack := CONCAT(_sSQLstringTrack,', @MachineStateDesc = N$'');
				IF _ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX.8 AND NOT _ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX.9 THEN

					_sSQLstringTrack := CONCAT(_sSQLstringTrack, 'PAUSED');

					CASE _ReqUpdStatus[_wIdxWriteUpdateStatus].wSubState OF
							
						MNCNT_TIMERSUBSTATE_OFF:

							_sSubState := 'OFF';

						MNCNT_TIMERSUBSTATE_STOP:

							_sSubState := 'STOP';
								
						MNCNT_TIMERSUBSTATE_INTFAULT:

							_sSubState := 'INTFAULT';

						MNCNT_TIMERSUBSTATE_EXTFAULT:

							_sSubState := 'EXTFAULT';

						MNCNT_TIMERSUBSTATE_SAFESTOP:

							_sSubState := 'SAFESTOM';

						MNCNT_TIMERSUBSTATE_EMERGENCYSTP:

							_sSubState := 'EMERGSTOP';

						ELSE

							_sSubState := '';
								
					END_CASE	

				ELSIF NOT _ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX.8 AND _ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX.9 THEN
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, 'WAIT');
					
					CASE _ReqUpdStatus[_wIdxWriteUpdateStatus].wSubState OF

						MNCNT_TIMERSUBSTATE_LOADING:

							_sSubState := 'LOADING';

						MNCNT_TIMERSUBSTATE_UNLOADING:

							_sSubState := 'UNLOADING';
								
						MNCNT_TIMERSUBSTATE_DOSING:

							_sSubState := 'DOSING';

						MNCNT_TIMERSUBSTATE_WATERLEVEL:

							_sSubState := 'WATERLEVEL';

						MNCNT_TIMERSUBSTATE_TEMPERATURE:

							_sSubState := 'TEMP';

						MNCNT_TIMERSUBSTATE_DISINFECTION:

							_sSubState := 'DISINFECTION';

						MNCNT_TIMERSUBSTATE_AIRPRESSURE:

							_sSubState := 'AIRPRESS';

						ELSE

							_sSubState := '';

					END_CASE	

				ELSE
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, 'ACTIVE');
					
					CASE _ReqUpdStatus[_wIdxWriteUpdateStatus].wSubState OF
						
						MNCNT_TIMERSUBSTATE_WASHING:

							_sSubState := 'PROCESSING';
	
						MNCNT_TIMERSUBSTATE_PREPERATION:
	
							_sSubState := 'PREPERATION';
									
						MNCNT_TIMERSUBSTATE_TRANSFER:
	
							_sSubState := 'TRANSFER';
	
						MNCNT_TIMERSUBSTATE_PREPFORSTOP:
	
							_sSubState := 'PREPFORSTOP';
	
						ELSE
	
							_sSubState := '';
	
					END_CASE	

				END_IF
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,'$'');
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,', @MachineSubState = N$'');
				
				IF brsstrcmp(ADR(_ReqUpdStatus[_wIdxWriteUpdateStatus].sSubState),ADR('')) <> 0 THEN
					
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, _ReqUpdStatus[_wIdxWriteUpdateStatus].sSubState);

				ELSE
					
					_sSQLstringTrack := CONCAT(_sSQLstringTrack, _sSubState);

				END_IF
				
				_sSQLstringTrack := CONCAT(_sSQLstringTrack,'$'');

				_Track_DBExecute.enable := TRUE;
				_Track_DBExecute.pSqlStatement := ADR(_sSQLstringTrack);
				_Track_DBExecute.connectionIdent := _lConnectionTrackIdent;

				_eTrackStep := eSQLREQ_STEP_WRUPDSTATE_r ;

			ELSE
				
				_wIdxWriteUpdateStatus := _wIdxWriteUpdateStatus + 1;
				
			END_IF
		
		eSQLREQ_STEP_WRUPDSTATE_r:
		
			_Track_DBExecute();
				
			IF _Track_DBExecute.status = ERR_OK  OR _Track_DBExecute.dbError = DB_SQL_NO_DATA THEN

				_wStatusX[_wIdxWriteUpdateStatus] := _ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX;
				_wSubState[_wIdxWriteUpdateStatus] := _ReqUpdStatus[_wIdxWriteUpdateStatus].wSubState;
				_sSubStates[_wIdxWriteUpdateStatus] := _ReqUpdStatus[_wIdxWriteUpdateStatus].sSubState;
				
				_wIdxWriteUpdateStatus := _wIdxWriteUpdateStatus + 1;
				_eTrackStep := eSQLREQ_STEP_WRUPDSTATE;

			ELSIF _Track_DBExecute.status <> ERR_FUB_BUSY THEN

				_wStatusX[_wIdxWriteUpdateStatus] := _ReqUpdStatus[_wIdxWriteUpdateStatus].wStatusX;

				_sTrackAction := 'Write Update Status failed:';
				_eTrackStep := eSQLREQ_STEP_GET_ERROR;

			END_IF

		
		(* Lese Fehler aus *)
		eSQLREQ_STEP_GET_ERROR:
		
			IF _lConnectionTrackIdent = 0 THEN
				IFhlDFII.Out.sStatusTracking := 'Connect failed !';
				_eTrackStep := eSQLREQ_STEP_ERROR;
			ELSE
				_Track_DBErrMsg.enable := TRUE;
				_Track_DBErrMsg.connectionIdent := _lConnectionTrackIdent;
				_Track_DBErrMsg.pErrorMessage := ADR(IFhlDFII.Out.sStatusTracking);
				_Track_DBErrMsg.errorMessageSize := SIZEOF(IFhlDFII.Out.sStatusTracking);
				_eTrackStep := eSQLREQ_STEP_GET_ERROR_r;
			END_IF
			
		(* Warte bis Fehler ausgelesen *)
		eSQLREQ_STEP_GET_ERROR_r:
		
			_Track_DBErrMsg();
			
			IF _Track_DBErrMsg.status = ERR_OK THEN
					
				_sLogEntryT := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryT := CONCAT(_sLogEntryT, '-hlDFII$tWARN$t');
				_sLogEntryT := CONCAT(_sLogEntryT, _sTrackAction);
				_sLogEntryT := CONCAT(_sLogEntryT, IFhlDFII.Out.sStatusTracking);

				_eTrackStep := eSQLREQ_STEP_LOGRB_ERROR;
					
			ELSIF _Track_DBErrMsg.status <> ERR_FUB_BUSY THEN

				IFhlDFII.Out.sStatusTracking := ' DBErrMsg.status = ';
				_sTrackValue := UINT_TO_STRING(_Track_DBErrMsg.status);
				IFhlDFII.Out.sStatusTracking := CONCAT(IFhlDFII.Out.sStatusTracking, _sTrackValue);
					
				_sLogEntryT := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
				_sLogEntryT := CONCAT(_sLogEntryT, '-hlDFII$tWARN$t');
				_sLogEntryT := CONCAT(_sLogEntryT, _sTrackAction);
				_sLogEntryT := CONCAT(_sLogEntryT, IFhlDFII.Out.sStatusTracking);

				_eTrackStep := eSQLREQ_STEP_LOGRB_ERROR;

			END_IF
			
		eSQLREQ_STEP_LOGRB_ERROR:
					
			_InsertRBT(wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);
			_eTrackStep := eSQLREQ_STEP_LOG_ERROR;
			
		eSQLREQ_STEP_LOG_ERROR:
			
			_kgArLogWriteTrack.logLevel 	:= arlogLEVEL_WARNING;
			_kgArLogWriteTrack.text		:= LEFT(_sLogEntryT, 127);
			_kgArLogWriteTrack();
			
			IF _kgArLogWriteTrack.status <> ERR_FUB_BUSY THEN
				brsmemset(ADR(_sLogEntryT), 0, SIZEOF(_sLogEntryT));
				_eTrackStep := eSQLREQ_STEP_LOG_ERROR1;
			END_IF

		eSQLREQ_STEP_LOG_ERROR1:
			
			_kgArLogWriteTrack.logLevel 	:= arlogLEVEL_WARNING;
			_kgArLogWriteTrack.text		:= LEFT(_sSQLstringTrack, 127);
			_kgArLogWriteTrack();
			
			IF _kgArLogWriteTrack.status <> ERR_FUB_BUSY THEN
				_eTrackStep := eSQLREQ_STEP_ERROR;
			END_IF

		(* Fehlerschritt *)
		eSQLREQ_STEP_ERROR:
			
	END_CASE

	
END_ACTION