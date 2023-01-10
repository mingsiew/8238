(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: hlDFII
 * File: _actReqScheduleDFII.st
 * Author: hunholz
 * Created: June 20, 2012
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************) 

(* Process Requests for DFII *)
ACTION _actReqScheduleDFII: 
	
	// Der Scheduler wird nur ausgeführt, wenn kein SQL-Commando bearbeitet wird
	
	IF _eCmdDFIIStep = eCMD_SQLREQ_IDLE THEN
		
		CASE _wScheduleStep OF
			
			_HLDFII_SCHEDSTEP_GETTIME:
				
				// Uhrzeit holen
				IF _bEventGetTime = _HLDFII_REQ_START THEN
					// Auftrag starten
					_eCmdDFIIStep := eCMD_SQLREQ_WRITE_GETTIME;
					_bEventGetTime := _HLDFII_REQ_RUN;
				END_IF
			
			_HLDFII_SCHEDSTEP_REGMACHINE:
				
				// Maschine registrieren
				IF _bEventRegMach = _HLDFII_REQ_START AND brwcscmp(ADR(IFmnParam.Out.utfMachineNumber),ADR(MNPARAM_INVALID_MACHINENO)) <> 0 THEN
					// Auftrag starten
					_eCmdDFIIStep := eCMD_SQLREQ_WRITE_REGMACH;
					_bEventRegMach := _HLDFII_REQ_RUN;
				END_IF
			
			_HLDFII_SCHEDSTEP_PROGBYCAT:
				
				// Programmnummer anhand der Kategorie ermitteln
				IF _xWaitReqProgByCatIsZero THEN
						
					IF IFhlDFII.In.ReqProgByCat.wRequest = 0 THEN

						_xWaitReqProgByCatIsZero := FALSE;
						IFhlDFII.Out.RespProgByCat.wResponse := 0;
							
					END_IF

				ELSE	

					// Prüfen ob eine Programmnummer gelesen werden soll
					IF IFhlDFII.In.ReqProgByCat.wRequest = 1 OR IFhlDFII.In.ReqProgByCat.wRequest = 2 THEN
						
						IF IFhlDFII.Out.xConnected THEN
								
							_xWaitReqProgByCatIsZero := TRUE;
							// Auftrag starten
							_eCmdDFIIStep := eCMD_SQLREQ_GET_PROG_BY_CAT;
							IFhlDFII.Out.RespProgByCat.wResponse := ERR_FUB_BUSY;

						ELSE

							_xWaitReqProgByCatIsZero := TRUE;
							IFhlDFII.Out.RespProgByCat.wResponse := HLDFII_STAT_NO_CONNECTION;

						END_IF
							
					END_IF
			
				END_IF
				
			_HLDFII_SCHEDSTEP_MSGEVENT:
				
				// Meldungden senden
				IF _xWaitReqMsgEvtIsZero THEN
						
					IF IFhlDFII.In.ReqMsgEvt.wRequest = 0 THEN
						_xWaitReqMsgEvtIsZero := FALSE;
						IFhlDFII.Out.RespMsgEvt.wResponse := 0;
					END_IF
						
				ELSE

					IF IFhlDFII.Out.xConnected THEN

						// Prüfen ob Meldungsevents geschrieben werden sollen
						IF IFhlDFII.In.ReqMsgEvt.wRequest = 1 THEN
								
							_xWaitReqMsgEvtIsZero := TRUE;
								
							IF IFhlDFII.In.ReqMsgEvt.bCntLines > 0 THEN
								_eCmdDFIIStep := eCMD_SQLREQ_WRITE_MSG;
								IFhlDFII.Out.RespMsgEvt.wResponse := ERR_FUB_BUSY;
							ELSE
								IFhlDFII.Out.RespMsgEvt.wResponse := IFhlDFII.In.ReqMsgEvt.wRequest;
							END_IF
								
						END_IF

					ELSE

						_xWaitReqMsgEvtIsZero := TRUE;
						IFhlDFII.Out.RespMsgEvt.wResponse := HLDFII_STAT_NO_CONNECTION;

					END_IF

				END_IF

			_HLDFII_SCHEDSTEP_CNTBATCH:
				
				// Postendaten senden
				IF _xWaitReqCntBatchIsZero THEN
						
					IF IFhlDFII.In.ReqCntBatchEvt.wRequest = 0 THEN
						
						_xWaitReqCntBatchIsZero := FALSE;
						IFhlDFII.Out.RespCntBatchEvt.wResponse := 0;
							
					END_IF
						
				ELSE
						
					IF IFhlDFII.Out.xConnected THEN

						// Prüfen ob Zähler-Posten-Events geschrieben werden sollen
						IF IFhlDFII.In.ReqCntBatchEvt.wRequest = 1 THEN
								
							_xWaitReqCntBatchIsZero := TRUE;
								
							IF IFhlDFII.In.ReqCntBatchEvt.bCntLines > 0 THEN
								_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTBATCHEVT;
								IFhlDFII.Out.RespCntBatchEvt.wResponse := ERR_FUB_BUSY;
							ELSE
								IFhlDFII.Out.RespCntBatchEvt.wResponse  := IFhlDFII.In.ReqCntBatchEvt.wRequest;
							END_IF
						END_IF

					ELSE

						_xWaitReqCntBatchIsZero := TRUE;
						IFhlDFII.Out.RespCntBatchEvt.wResponse := HLDFII_STAT_NO_CONNECTION;

					END_IF

				END_IF	
			
			// Zähler senden
			_HLDFII_SCHEDSTEP_CNTCNT:
				
				IF _xWaitReqCntCntIsZero THEN
						
					IF IFhlDFII.In.ReqCntCntEvt.wRequest = 0 THEN
							
						_xWaitReqCntCntIsZero := FALSE;
						IFhlDFII.Out.RespCntCntEvt.wResponse := 0;
							
					END_IF
						
				ELSE
					
					IF IFhlDFII.Out.xConnected THEN
						
						// Prüfen ob Zähler-Zähler-Events geschrieben werden sollen
						IF IFhlDFII.In.ReqCntCntEvt.wRequest = 1 THEN
								
							_xWaitReqCntCntIsZero := TRUE;
								
							IF IFhlDFII.In.ReqCntCntEvt.bCntLines > 0 THEN
								_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTCNTEVT;
								IFhlDFII.Out.RespCntCntEvt.wResponse := ERR_FUB_BUSY;
							ELSE
								IFhlDFII.Out.RespCntCntEvt.wResponse  := IFhlDFII.In.ReqCntCntEvt.wRequest;
							END_IF
						END_IF

					ELSE

						_xWaitReqCntCntIsZero := TRUE;
						IFhlDFII.Out.RespCntCntEvt.wResponse := HLDFII_STAT_NO_CONNECTION;

					END_IF
							
				END_IF	
			
			// Zeiten senden
			_HLDFII_SCHEDSTEP_CNTTIME:
				
				IF _xWaitReqCntTimIsZero THEN
						
					IF IFhlDFII.In.ReqCntTimEvt.wRequest = 0 THEN
							
						_xWaitReqCntTimIsZero := FALSE;
						IFhlDFII.Out.RespCntTimEvt.wResponse := 0;
							
					END_IF
						
				ELSE
						
					IF IFhlDFII.Out.xConnected THEN
						
						// Prüfen ob Zähler-Zeit-Events geschrieben werden sollen
						IF IFhlDFII.In.ReqCntTimEvt.wRequest = 1 THEN
								
							_xWaitReqCntTimIsZero := TRUE;
								
							IF IFhlDFII.In.ReqCntTimEvt.bCntLines > 0 THEN
								_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTTIMEVT;
								IFhlDFII.Out.RespCntTimEvt.wResponse := ERR_FUB_BUSY;
							ELSE
								IFhlDFII.Out.RespCntTimEvt.wResponse  := IFhlDFII.In.ReqCntTimEvt.wRequest;
							END_IF
						END_IF
						
					ELSE
							
						_xWaitReqCntTimIsZero := TRUE;
						IFhlDFII.Out.RespCntTimEvt.wResponse := HLDFII_STAT_NO_CONNECTION;

					END_IF

				END_IF	
			
			// Dosierungen senden
			_HLDFII_SCHEDSTEP_CNTDOS:
				
				IF _xWaitReqCntDosIsZero THEN
						
					IF IFhlDFII.In.ReqCntDosEvt.wRequest = 0 THEN
							
						_xWaitReqCntDosIsZero := FALSE;
						IFhlDFII.Out.RespCntDosEvt.wResponse := 0;
						
					END_IF
						
				ELSE
						
					IF IFhlDFII.Out.xConnected THEN
							
						// Prüfen ob Zähler-Dosier-Events geschrieben werden sollen
						IF IFhlDFII.In.ReqCntDosEvt.wRequest = 1 THEN
								
							_xWaitReqCntDosIsZero := TRUE;
								
							IF IFhlDFII.In.ReqCntDosEvt.bCntLines > 0 THEN
								_eCmdDFIIStep := eCMD_SQLREQ_WRITE_CNTDOSEVT;
								IFhlDFII.Out.RespCntDosEvt.wResponse := ERR_FUB_BUSY;
							ELSE
								IFhlDFII.Out.RespCntDosEvt.wResponse  := IFhlDFII.In.ReqCntDosEvt.wRequest;
							END_IF

						END_IF

					ELSE
							
						_xWaitReqCntDosIsZero := TRUE;
						IFhlDFII.Out.RespCntDosEvt.wResponse := HLDFII_STAT_NO_CONNECTION;

					END_IF
							
				END_IF
						
		END_CASE

	END_IF

END_ACTION