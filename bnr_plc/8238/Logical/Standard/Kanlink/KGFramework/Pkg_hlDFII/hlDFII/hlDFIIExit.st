(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: hlDFII
 * File: hlDFIIExit.st
 * Author: hunholz
 * Created: April 05, 2011
 * Changed: November 14, 2011
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************)

PROGRAM _EXIT

	REPEAT
		_UdpClose(enable := TRUE, ident := _UdpOpen.ident);
		UNTIL
		_UdpClose.status <> ERR_FUB_BUSY
	END_REPEAT
	
	WHILE _eStep <> eSQLREQ_STEP_STOP DO
		
		CASE _eStep OF
			
			(* Beende Verbindungsaufbau, und baue dann die Verbindung wieder ab *)
			eSQLREQ_STEP_CONNECT_r:
				_DFII_Connect();
				IF _DFII_Connect.status <> ERR_FUB_BUSY THEN
					_eStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Beende DFII_DBErrMsg *)
			eSQLREQ_STEP_GET_ERROR_r:
				_DFII_DBErrMsg();
				IF _DFII_DBErrMsg.status <> ERR_FUB_BUSY THEN
					_eStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Beende Execute *)
			eSQLREQ_STEP_GPBC_r:
			eSQLREQ_STEP_WRMSG_r:
			eSQLREQ_STEP_WRCNTBATCHEVT_r:
			eSQLREQ_STEP_WRCNTCNTEVT_r:
			eSQLREQ_STEP_WRCNTTIMEVT_r:
			eSQLREQ_STEP_WRCNTDOSEVT_r:
			eSQLREQ_STEP_REGMACH_r:
			eSQLREQ_STEP_GETTIME_r:
				_DFII_DBExecute();
				IF _DFII_DBExecute.status <> ERR_FUB_BUSY THEN
					_eStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Beende Fetch *)
			eSQLREQ_STEP_GPBC_FETCH_r:
			eSQLREQ_STEP_GETTIME_FETCH_r:
				_DFII_DBFetch();
				IF _DFII_DBFetch.status <> ERR_FUB_BUSY THEN
					_eStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Bende GetVal *)
			eSQLREQ_STEP_GPBC_GETVAL_r:
			eSQLREQ_STEP_GETTIME_GETVAL_r:
				_DFII_GetData();
				IF _DFII_GetData.status <> ERR_FUB_BUSY THEN
					_eStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Baue Verbindung ab *)
			eSQLREQ_STEP_DISCONNECT:
		
				_DFII_Disconnect.enable := TRUE;
				_DFII_Disconnect.connectionIdent := _lConnectionIdent;
				_eStep := eSQLREQ_STEP_DISCONNECT_r;

			(* Warte bis Verbindung abgebaut ist *)
			eSQLREQ_STEP_DISCONNECT_r:
		
				_DFII_Disconnect();
			
				IF _DFII_Disconnect.status <> ERR_FUB_BUSY THEN
					_eStep := eSQLREQ_STEP_STOP;
				END_IF
			
			eSQLREQ_STEP_ERROR:
			
				_eStep := eSQLREQ_STEP_DISCONNECT;
				
			ELSE

				_eStep := eSQLREQ_STEP_DISCONNECT;
			
		END_CASE
		
	END_WHILE

	WHILE _eTrackStep <> eSQLREQ_STEP_STOP DO
		
		CASE _eTrackStep OF
			
			(* Beende Verbindungsaufbau, und baue dann die Verbindung wieder ab *)
			eSQLREQ_STEP_CONNECT_r:
				_Track_Connect();
				IF _Track_Connect.status <> ERR_FUB_BUSY THEN
					_eTrackStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Beende Track_DBErrMsg *)
			eSQLREQ_STEP_GET_ERROR_r:
				_Track_DBErrMsg();
				IF _Track_DBErrMsg.status <> ERR_FUB_BUSY THEN
					_eTrackStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Beende Execute *)
			eSQLREQ_STEP_GETTIME_r:
			eSQLREQ_STEP_WRUPDSTATE_r:
			eSQLREQ_STEP_WRUPDLOC_r:
				_Track_DBExecute();
				IF _Track_DBExecute.status <> ERR_FUB_BUSY THEN
					_eTrackStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Beende Fetch *)
			eSQLREQ_STEP_GETTIME_FETCH_r:
				_Track_DBFetch();
				IF _Track_DBFetch.status <> ERR_FUB_BUSY THEN
					_eTrackStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Bende GetVal *)
			eSQLREQ_STEP_GETTIME_GETVAL_r:
				_Track_GetData();
				IF _Track_GetData.status <> ERR_FUB_BUSY THEN
					_eTrackStep := eSQLREQ_STEP_DISCONNECT;
				END_IF
				
			(* Baue Verbindung ab *)
			eSQLREQ_STEP_DISCONNECT:
		
				_Track_Disconnect.enable := TRUE;
				_Track_Disconnect.connectionIdent := _lConnectionTrackIdent;
				_eTrackStep := eSQLREQ_STEP_DISCONNECT_r;

			(* Warte bis Verbindung abgebaut ist *)
			eSQLREQ_STEP_DISCONNECT_r:
		
				_Track_Disconnect();
			
				IF _Track_Disconnect.status <> ERR_FUB_BUSY THEN
					_eTrackStep := eSQLREQ_STEP_STOP;
				END_IF
			
			eSQLREQ_STEP_ERROR:
			
				_eTrackStep := eSQLREQ_STEP_DISCONNECT;
				
			ELSE

				_eTrackStep := eSQLREQ_STEP_DISCONNECT;
			
		END_CASE
		
	END_WHILE


END_PROGRAM
