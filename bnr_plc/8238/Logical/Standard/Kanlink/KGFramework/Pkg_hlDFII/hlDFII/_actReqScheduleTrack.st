(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: _actReqScheduleTrack.st
 * Author: hunholz
 * Created: June 20, 2012
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************) 

(* Process Requests for Track *)
ACTION _actReqScheduleTrack: 
	
	// Der Scheduler wird nur ausgeführt, wenn kein SQL-Commando bearbeitet wird
	
	IF _eCmdTrackStep = eCMD_SQLREQ_IDLE THEN
		
		CASE _wScheduleTrackStep OF
			
			_HLDFII_SCHEDSTEP_T_GETTIME:
				
				// Uhrzeit holen
				IF _bEventGetTrackTime = _HLDFII_REQ_START THEN
					// Auftrag starten
					_eCmdTrackStep := eCMD_SQLREQ_WRITE_GETTIME;
					_bEventGetTrackTime := _HLDFII_REQ_RUN;
				END_IF
			
			_HLDFII_SCHEDSTEP_T_UPDLOC:
				
				IF _xUpdateStatusFinished THEN
				
					_xReadyForRequestUpdateState := TRUE;
					_xUpdateStatusFinished := FALSE;
					
				END_IF
					
				IF _xReadyForRequestUpdateLocation THEN

					_xChange := FALSE;
					
					FOR _ii := 1 TO HLDFII_MAXIDX_REQ_UPDATEBATCH DO
						
						IF IFhlDFII.In.ReqUpdBatch[_ii].dtTimeStamp <> _dtTimeStampUpdBatch[_ii] AND IFhlDFII.In.ReqUpdBatch[_ii].wLocation > 0 THEN

							_xChange := TRUE;
							_ReqUpdBatch := IFhlDFII.In.ReqUpdBatch;
							
						END_IF
						
					END_FOR
					
					IF _xChange THEN
						_eCmdTrackStep := eCMD_SQLREQ_WRITE_UPDLOC;
						_xReadyForRequestUpdateLocation := FALSE;
					END_IF

				END_IF
				
			_HLDFII_SCHEDSTEP_T_UPDSTAT:
				
				IF _xUpdateLocationFinished THEN
				
					_xReadyForRequestUpdateLocation := TRUE;
					_xUpdateLocationFinished := FALSE;
				
				END_IF
						
				IF _xReadyForRequestUpdateState THEN

						_xChange := FALSE;
					
					FOR _ii := 1 TO HLDFII_MAXIDX_REQ_UPDATESTATUS DO
						
						IF (IFhlDFII.In.ReqUpdStatus[_ii].wStatusX <> _wStatusX[_ii]) OR (IFhlDFII.In.ReqUpdStatus[_ii].wSubState <> _wSubState[_ii]
							OR brsstrcmp(ADR(IFhlDFII.In.ReqUpdStatus[_ii].sSubState),ADR(_sSubStates[_ii])) <> 0) AND IFhlDFII.In.ReqUpdStatus[_ii].xEnable THEN

							_xChange := TRUE;
							_ReqUpdStatus := IFhlDFII.In.ReqUpdStatus;
							
						END_IF
						
					END_FOR
					
					IF _xChange THEN
						_eCmdTrackStep := eCMD_SQLREQ_WRITE_UPDSTATE;
						_xReadyForRequestUpdateState := FALSE;
					END_IF

				END_IF
						
		END_CASE

	END_IF

END_ACTION