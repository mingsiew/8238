(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: hlDFII
 * File: hlDFIICyclic.st
 * Author: hunholz
 * Created: April 05, 2011
 * Changed: November 14, 2011
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************)

PROGRAM _CYCLIC


	// Init
	IF IFmnParam.Out.xParamOK AND NOT _xInitDone THEN
		
		brwcsconv(ADR(_sMNo), ADR(IFmnParam.Out.utfMachineNumber), 1);
		
		FOR _ii := 1 TO HLDFII_MAXIDX_REQ_UPDATESTATUS DO
			_wStatusX[_ii] := 16#FFFF;
		END_FOR
		
		_xInitDone := TRUE;
		
	END_IF
	
	IF NOT _xReady AND IFmnEth.Out.xDataValid AND IFmnParam.Out.xParamOK AND HLDFII_RUN_CLIENT THEN
		
		//**********************
		// INITIALISIERUNG
		//***********************

		_CreateConnStringDFII(IP := IFmnEth.Out.IP, Conn := hlDFIIPar.Mac.DFIIConn);
		
		_CreateConnStringTracking(IP := IFmnEth.Out.IP, Conn := hlDFIIPar.Mac.TrackConn);

		_xReady := TRUE;
		
		// UDP-Log vorbereiten
		
		_UdpOpen.enable	 := TRUE;
		_UdpOpen.pIfAddr := 0;
		_UdpOpen.port	 := HLDFII_UDP_PORT_LOG4NET;
		_UdpOpen.options := udpOPT_BROADCAST;
		
	ELSIF _xReady THEN

		//***********************************
		// ZYKLISCHE ABARBEITUNG
		//***********************************
		
		hlDFIIStat.wStatus := 0;

		////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		// DFII		
		////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////

		//*********************************************************************************
		// Request Scheduler DFII
		//*********************************************************************************

		_actReqScheduleDFII;

		//*********************************************************************************
		// Aufträge ausführen
		//*********************************************************************************
	
		_actProcCmdDFII;

		//*********************************************************************************
		// Verbindung nach ablauf der Idletime abbauen, wenn keine Aktion ist
		//*********************************************************************************

		IF _eStep = eSQLREQ_STEP_ERROR THEN
			
			_eStep := eSQLREQ_STEP_DISCONNECT;
			
		ELSIF (_eCmdDFIIStep = eCMD_SQLREQ_IDLE) AND(_eStep = eSQLREQ_STEP_WAITFORCOMMAND) THEN
		
			_GTCurrent(enable := TRUE);
		
			IF _GTCurrent.DT1 > _GTlastAction.DT1 THEN
			
				IF DiffDT(_GTCurrent.DT1, _GTlastAction.DT1) > hlDFIIPar.Mac.DFIIConn.wIdletimeDisconnect THEN
				
					// Idletime abgelaufen, Verbindung abbauen
					_eStep := eSQLREQ_STEP_DISCONNECT;
				
				END_IF
			
			END_IF	
		
		ELSE	
		
			_GTlastAction(enable := TRUE);
		
		END_IF
	
		//*********************************************************************************
		// Verbindung bei Bedarf aufbauen
		//*********************************************************************************

		IF _eCmdDFIIStep <> eCMD_SQLREQ_IDLE AND _eStep = eSQLREQ_STEP_STOP THEN
		
			_eStep := eSQLREQ_STEP_CONNECT;
		
		END_IF
		

		//*********************************************************************************
		// SQL-Befehle ausführen
		//*********************************************************************************
	
		_actProcSQLDFII;
		
		// Wenn Maschinenregistrierung fehlerhaft war, wiederholen nach ca. 1 Minute
		TONrepReg(IN := _bEventRegMach = 255, PT := T#60s);
		IF TONrepReg.Q THEN
			_bEventRegMach := 1;
		END_IF
		// Wenn Zeit lesen fehlerhaft war, wiederholen nach ca. 1 Minute
		TONrepGettime(IN := _bEventGetTime = 255, PT := T#60s);
		IF TONrepGettime.Q THEN
			_bEventGetTime := 1;
		END_IF

		
		////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		// TRACKING		
		////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////

		//*********************************************************************************
		// Request Scheduler Tracking
		//*********************************************************************************

		_actReqScheduleTrack;

		//*********************************************************************************
		// Aufträge ausführen
		//*********************************************************************************

		_actProcCmdTrack;
		
		//*********************************************************************************
		// Verbindung nach ablauf der Idletime abbauen, wenn keine Aktion ist
		//*********************************************************************************

		IF _eTrackStep = eSQLREQ_STEP_ERROR THEN
			
			_eTrackStep := eSQLREQ_STEP_DISCONNECT;
			
		ELSIF (_eCmdTrackStep = eCMD_SQLREQ_IDLE) AND(_eTrackStep = eSQLREQ_STEP_WAITFORCOMMAND) THEN
		
			_GTCurrent(enable := TRUE);
		
			IF _GTCurrent.DT1 > _GTlastActionTrack.DT1 THEN
			
				IF DiffDT(_GTCurrent.DT1, _GTlastActionTrack.DT1) > hlDFIIPar.Mac.TrackConn.wIdletimeDisconnect THEN
				
					// Idletime abgelaufen, Verbindung abbauen
					_eTrackStep := eSQLREQ_STEP_DISCONNECT;
				
				END_IF
			
			END_IF	
		
		ELSE	
		
			_GTlastActionTrack(enable := TRUE);
		
		END_IF
	
		//*********************************************************************************
		// Verbindung bei Bedarf aufbauen
		//*********************************************************************************

		IF _eCmdTrackStep <> eCMD_SQLREQ_IDLE AND _eTrackStep = eSQLREQ_STEP_STOP THEN
		
			_eTrackStep := eSQLREQ_STEP_CONNECT;
		
		END_IF
		
		_actProcSQLTrack;
		
		// Wenn Zeit lesen fehlerhaft war, wiederholen nach ca. 1 Minute
		TONrepGettimeTrack(IN := _bEventGetTrackTime = _HLDFII_REQ_FAULT, PT := T#60s);
		IF TONrepGettimeTrack.Q THEN
			_bEventGetTrackTime := _HLDFII_REQ_START;
		END_IF

		
		
		//**********************************************************************************
		// UDP Logging
		//**********************************************************************************
		
		CASE _wStepUdp OF
			
			0:
				_UdpOpen();
				IF _UdpOpen.status = ERR_OK THEN
					_wStepUdp := 1;
				END_IF
				
			1:
				_ReadRB(wPtrWrite := _wPtrRBwrite, wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread);

				IF _ReadRB.wStatus = ERR_OK THEN
					_wStepUdp := 2;
					_UdpSend.enable := TRUE;
					_UdpSend.ident := _UdpOpen.ident;
					_UdpSend.pHost := ADR(_CreateConnStringDFII.HostString);
					_UdpSend.port := HLDFII_UDP_PORT_LOG4NET;
					_UdpSend.pData := ADR(_sLogEntry);
					_UdpSend.datalen := SIZEOF(_sLogEntry);
				END_IF
				
			2:
				_UdpSend();
				IF _UdpSend.status <> ERR_FUB_BUSY THEN
					_wStepUdp := 1;
				END_IF
			
		END_CASE

		hlDFIIStat.wStatus := SEL(IFhlDFII.Out.xConnected,HLDFII_STAT_NO_CONNECTION, HLDFII_STAT_OK);
		IFhlDFII.Out.wStatus := SEL(IFhlDFII.Out.xConnected,HLDFII_STAT_NO_CONNECTION, HLDFII_STAT_OK);
		
	ELSE
		
		IF IFmnEth.Out.xDataValid AND IFmnParam.Out.xParamOK THEN
	
			hlDFIIStat.wStatus := HLDFII_STAT_DISABLED;
			IFhlDFII.Out.wStatus := HLDFII_STAT_DISABLED;
			
		ELSE
			
			hlDFIIStat.wStatus := HLDFII_STAT_INIT;
			IFhlDFII.Out.wStatus := HLDFII_STAT_INIT;
			
		END_IF
		
	END_IF

	// Debughilfe für _sSQLstring
	_wStartDebug := LIMIT(0,_wStartDebug, 992);
	_sDebugSQLstring ACCESS (ADR(_sSQLBatchEventString)+_wStartDebug);
	
END_PROGRAM
