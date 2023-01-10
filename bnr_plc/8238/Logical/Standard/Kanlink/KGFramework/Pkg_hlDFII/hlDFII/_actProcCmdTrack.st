(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: _actProcCmdTrack.st
 * Author: hunholz
 * Created: June 20, 2012
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************) 

(* Process Commands for DFII *)
ACTION _actProcCmdTrack: 

	_TONRefreshTrack(IN := NOT _TONRefreshTrack.Q, PT := T#1s);

	CASE _eCmdTrackStep OF
		
		//*****************************************************	
		// Im Idle Zustand werden laufend die Auftrage gescannt
		//*****************************************************	
		eCMD_SQLREQ_IDLE:

			// Zuerst wird die Zeit vom Server geholt
			IF _bEventGetTrackTime <> _HLDFII_REQ_FINISHED THEN
						
				_wScheduleTrackStep := _HLDFII_SCHEDSTEP_T_GETTIME;
						
				// Dann wird zyklisch geschaut, ob Anforderungen anliegen
			ELSE
			
				IF _TONRefreshTrack.Q THEN
					
					_wScheduleTrackStepHelp := (_wScheduleTrackStepHelp + 1) MOD (_HLDFII_SCHEDSTEP_T_MAX);
							
					_wScheduleTrackStep := _wScheduleTrackStepHelp + 1;

				END_IF
				
			END_IF


		//*****************************************************	
		// Uhrzeit vom DB-Server holen
		//*****************************************************	
		eCMD_SQLREQ_WRITE_GETTIME:
			
			IF _eTrackStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				
				_eTrackStep := eSQLREQ_STEP_GETTIME;
				_eCmdTrackStep := eCMD_SQLREQ_WRITE_GETTIME_w;
				
			ELSIF _eTrackStep = eSQLREQ_STEP_ERROR THEN
				
				_bEventGetTrackTime := _HLDFII_REQ_FAULT;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			END_IF

		eCMD_SQLREQ_WRITE_GETTIME_w:
			
			IF _eTrackStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				
				_bEventGetTrackTime := _HLDFII_REQ_FINISHED;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			ELSIF _eTrackStep = eSQLREQ_STEP_ERROR THEN
				
				_bEventGetTrackTime := _HLDFII_REQ_FAULT;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			END_IF
			
		//***************************************
		// Batchdaten in Location-Table eintragen
		//***************************************
		eCMD_SQLREQ_WRITE_UPDLOC:

			IF _eTrackStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				
				_wIdxWriteUpdateLocation := 1;
				_eTrackStep := eSQLREQ_STEP_WRUPDLOC;
				_eCmdTrackStep := eCMD_SQLREQ_WRITE_UPDLOC_w;
				
			ELSIF _eTrackStep = eSQLREQ_STEP_ERROR THEN
				
				_xUpdateLocationFinished := TRUE;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			END_IF
			
		eCMD_SQLREQ_WRITE_UPDLOC_w:

			IF _eTrackStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				
				_xUpdateLocationFinished := TRUE;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			ELSIF _eTrackStep = eSQLREQ_STEP_ERROR THEN
				
				_xUpdateLocationFinished := TRUE;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			END_IF

		//***************************************
		// Maschinenstatus eintragen
		//***************************************
		eCMD_SQLREQ_WRITE_UPDSTATE:

			IF _eTrackStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				
				_wIdxWriteUpdateStatus := 1;
				_eTrackStep := eSQLREQ_STEP_WRUPDSTATE;
				_eCmdTrackStep := eCMD_SQLREQ_WRITE_UPDSTATE_w;
				
			ELSIF _eTrackStep = eSQLREQ_STEP_ERROR THEN
				
				_xUpdateStatusFinished := TRUE;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			END_IF
			
		eCMD_SQLREQ_WRITE_UPDSTATE_w:

			IF _eTrackStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				
				_xUpdateStatusFinished := TRUE;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			ELSIF _eTrackStep = eSQLREQ_STEP_ERROR THEN
				
				_xUpdateStatusFinished := TRUE;
				_eCmdTrackStep := eCMD_SQLREQ_IDLE;
				
			END_IF

			
	END_CASE

	
END_ACTION