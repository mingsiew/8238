(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: _actProcCmdDFII.st
 * Author: hunholz
 * Created: June 20, 2012
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************) 

(* Process Commands for DFII *)
ACTION _actProcCmdDFII: 
	
	CASE _eCmdDFIIStep OF
		
		//*****************************************************	
		// Im Idle Zustand werden laufend die Auftrage gescannt
		//*****************************************************	
		eCMD_SQLREQ_IDLE:

			// Zuerst wird die Zeit vom Server geholt
			IF _bEventGetTime <> _HLDFII_REQ_FINISHED THEN
						
				_wScheduleStep := _HLDFII_SCHEDSTEP_GETTIME;
						
				// Die Maschine wird auf jeden Fall registriert
			ELSIF _bEventRegMach <> _HLDFII_REQ_FINISHED THEN
						
				_wScheduleStep := _HLDFII_SCHEDSTEP_REGMACHINE;
						
				// Dann wird zyklisch geschaut, ob Anforderungen anliegen
			ELSE
			
				_wScheduleStepHelp := (_wScheduleStepHelp + 1) MOD (_HLDFII_SCHEDSTEP_MAX-1);
						
				_wScheduleStep := _wScheduleStepHelp + 2;
						
			END_IF

		//*****************************************************	
		// Auftrag: Programm nach Kategorie auslesen
		//*****************************************************	
		eCMD_SQLREQ_GET_PROG_BY_CAT:		
		
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				IFhlDFII.Out.RespProgByCat.bProgramNo 		:= 0;
				IFhlDFII.Out.RespProgByCat.sProgramName 	:= '';
				IFhlDFII.Out.RespProgByCat.rSoilfactor 		:= 1.0;
				IFhlDFII.Out.RespProgByCat.wLoadrate 		:= 100;
				IFhlDFII.Out.RespProgByCat.wColorIdxFor 	:= 0;
				IFhlDFII.Out.RespProgByCat.wColorIdxBack 	:= 15;
				_eStep := eSQLREQ_STEP_GPBC;
				_eCmdDFIIStep := eCMD_SQLREQ_GET_PROG_BY_CAT_w;
					
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
					
				IFhlDFII.Out.RespProgByCat.wResponse := HLDFII_MSG_PROGBYCAT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
					
			END_IF		
		
		eCMD_SQLREQ_GET_PROG_BY_CAT_w:

			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				IFhlDFII.Out.RespProgByCat.wResponse := IFhlDFII.In.ReqProgByCat.wRequest;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespProgByCat.wResponse := HLDFII_MSG_PROGBYCAT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		//*****************************************************	
		// Meldungen schreiben
		//*****************************************************	
		eCMD_SQLREQ_WRITE_MSG:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_bCntWrMsg := 1;
				_eStep := eSQLREQ_STEP_WRMSG;
				_eCmdDFIIStep := eCMD_SQLREQ_WRITE_MSG_w;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespMsgEvt.wResponse := HLDFII_MSG_MSGEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		eCMD_SQLREQ_WRITE_MSG_w:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				IFhlDFII.Out.RespMsgEvt.wResponse := IFhlDFII.In.ReqMsgEvt.wRequest;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespMsgEvt.wResponse := HLDFII_MSG_MSGEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		//*****************************************************	
		// Posten-Zählevents schreiben
		//*****************************************************	
		eCMD_SQLREQ_WRITE_CNTBATCHEVT:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_bCntWrCntBatchEvt := 1;
				_eStep := eSQLREQ_STEP_WRCNTBATCHEVT;
				_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTBATCHEVT_w;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntBatchEvt.wResponse := HLDFII_MSG_CNTBATCHEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		eCMD_SQLREQ_WRITE_CNTBATCHEVT_w:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				IFhlDFII.Out.RespCntBatchEvt.wResponse := IFhlDFII.In.ReqCntBatchEvt.wRequest;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntBatchEvt.wResponse := HLDFII_MSG_CNTBATCHEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF
		
		//*****************************************************	
		// Zählerevents schreiben
		//*****************************************************	
		eCMD_SQLREQ_WRITE_CNTCNTEVT:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_bCntWrCntCntEvt := 1;
				_eStep := eSQLREQ_STEP_WRCNTCNTEVT;
				_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTCNTEVT_w;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntCntEvt.wResponse := HLDFII_MSG_CNTCNTEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		eCMD_SQLREQ_WRITE_CNTCNTEVT_w:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				IFhlDFII.Out.RespCntCntEvt.wResponse := IFhlDFII.In.ReqCntCntEvt.wRequest;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntCntEvt.wResponse := HLDFII_MSG_CNTCNTEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		//*****************************************************	
		// Zeitevents schreiben
		//*****************************************************	
		eCMD_SQLREQ_WRITE_CNTTIMEVT:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_bCntWrCntTimeEvt := 1;
				_eStep := eSQLREQ_STEP_WRCNTTIMEVT;
				_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTTIMEVT_w;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntTimEvt.wResponse := HLDFII_MSG_CNTTIMEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		eCMD_SQLREQ_WRITE_CNTTIMEVT_w:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				IFhlDFII.Out.RespCntTimEvt.wResponse := IFhlDFII.In.ReqCntTimEvt.wRequest;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntTimEvt.wResponse := HLDFII_MSG_CNTTIMEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		//*****************************************************	
		// Dosierevents schreiben
		//*****************************************************	
		eCMD_SQLREQ_WRITE_CNTDOSEVT:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_bCntWrCntDoseEvt := 1;
				_eStep := eSQLREQ_STEP_WRCNTDOSEVT;
				_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTDOSEVT_W;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntDosEvt.wResponse := HLDFII_MSG_CNTDOSEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		eCMD_SQLREQ_WRITE_CNTDOSEVT_W:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				IFhlDFII.Out.RespCntDosEvt.wResponse := IFhlDFII.In.ReqCntDosEvt.wRequest;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				IFhlDFII.Out.RespCntDosEvt.wResponse := HLDFII_MSG_CNTDOSEVT_ERR;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		//*****************************************************	
		// Maschine registrieren
		//*****************************************************	
		eCMD_SQLREQ_WRITE_REGMACH:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_eStep := eSQLREQ_STEP_REGMACH;
				_eCmdDFIIStep := eCMD_SQLREQ_WRITE_REGMACH_w;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				_bEventRegMach := 255;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		eCMD_SQLREQ_WRITE_REGMACH_w:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_bEventRegMach := 3;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				_bEventRegMach := 255;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		//*****************************************************	
		// Uhrzeit vom DB-Server holen
		//*****************************************************	
		eCMD_SQLREQ_WRITE_GETTIME:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_eStep := eSQLREQ_STEP_GETTIME;
				_eCmdDFIIStep := eCMD_SQLREQ_WRITE_GETTIME_w;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				_bEventGetTime := 255;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

		eCMD_SQLREQ_WRITE_GETTIME_w:
			
			IF _eStep = eSQLREQ_STEP_WAITFORCOMMAND THEN
				_bEventGetTime := 3;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			ELSIF _eStep = eSQLREQ_STEP_ERROR THEN
				_bEventGetTime := 255;
				_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
			END_IF

	END_CASE

	
END_ACTION