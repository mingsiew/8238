(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: hlDFII
 * File: hlDFIIInit.st
 * Author: hunholz
 * Created: April 05, 2011
 ********************************************************************
 * Implementation of program hlDFII
 ********************************************************************)

PROGRAM _INIT

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'hlDFII';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(hlDFIIStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		hlDFIIStatAd.sPkgVersion := '---';
		
	END_IF		
	
	// Init

	_xInitDone := FALSE;
	_xReady := FALSE;
	
	_eStep := eSQLREQ_STEP_STOP;
	_eTrackStep := eSQLREQ_STEP_STOP;
	
	_eCmdDFIIStep := eCMD_SQLREQ_IDLE;
	_eCmdTrackStep := eCMD_SQLREQ_IDLE;
	
	_bEventRegMach := _HLDFII_REQ_START;
	_bEventGetTime := _HLDFII_REQ_START;
	
	_bEventGetTrackTime := _HLDFII_REQ_START;
	
	_lConnectionIdent := 0;
	_lConnectionTrackIdent := 0;
	
	_wScheduleStep := _HLDFII_SCHEDSTEP_GETTIME;
	_wScheduleTrackStep := _HLDFII_SCHEDSTEP_T_GETTIME;
	
	_GTlastAction(enable := TRUE);
	_GTlastActionTrack(enable := TRUE);
	
	brsmemset(ADR(hlDFIIStat),0,SIZEOF(hlDFIIStat));
	
	// Create Log
	//****************************************************************************************************************
	// Log erzeugen
	//****************************************************************************************************************

	_kgArLogWrite.enable := TRUE;
	_kgArLogWrite.ident := 0;
	_kgArLogWrite.errornr := 50010;
	
	_kgArLogWriteTrack.enable := TRUE;
	_kgArLogWriteTrack.ident := 0;
	_kgArLogWriteTrack.errornr := 50010;
		
	_AsArLogCreate(enable := TRUE, pName := ADR('hlDFIIL'), len := 4096*4, memType := arlogUSRROM);
		
	IF _AsArLogCreate.status = ERR_OK THEN
			
		_kgArLogWrite.ident := _AsArLogCreate.ident;
		_kgArLogWriteTrack.ident := _AsArLogCreate.ident;
			
	ELSIF _AsArLogCreate.status = arlogERR_EXISTING THEN
			
		_AsArLogGetInfo(enable := TRUE, pName := ADR('hlDFIIL'));

		IF _AsArLogGetInfo.status = ERR_OK THEN
				
			_kgArLogWrite.ident := _AsArLogGetInfo.ident;
			_kgArLogWriteTrack.ident := _AsArLogCreate.ident;
				
		END_IF
			
	END_IF

	//****************************************************************************************************************
	// Ringbuffer for Logs
	//****************************************************************************************************************

	_kgRBcreateDFIIlog(sName := '_dfiilogrb', bMemType := doTEMP, wCntEntry := 10, lLenEntry := SIZEOF(_sLogEntry), wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

	IF _kgRBcreateDFIIlog.wStatus = ERR_OK THEN

		_wPtrRBloc := 0;

		_xRBReady := TRUE;

		_InsertRB.doIdent := _kgRBcreateDFIIlog.doIdent;
		_InsertRB.doLen := _kgRBcreateDFIIlog.doLen;
		_InsertRB.lLenEntry := SIZEOF(_sLogEntry);
		_InsertRB.pEntry := ADR(_sLogEntryI);

		_InsertRBT.doIdent := _kgRBcreateDFIIlog.doIdent;
		_InsertRBT.doLen := _kgRBcreateDFIIlog.doLen;
		_InsertRBT.lLenEntry := SIZEOF(_sLogEntry);
		_InsertRBT.pEntry := ADR(_sLogEntryT);

		_ReadRB.doIdent := _kgRBcreateDFIIlog.doIdent;
		_ReadRB.doLen := _kgRBcreateDFIIlog.doLen;
		_ReadRB.lLenEntry := SIZEOF(_sLogEntry);
		_ReadRB.pEntry := ADR(_sLogEntry);

	ELSE
		
		_kgArLogWrite.logLevel := arlogLEVEL_INFO;
		_kgArLogWrite.text := 'Create Ringbuffer: {##AttrVar1}';
		_kgArLogWrite.var1 := _kgRBcreateDFIIlog.wStatus;
		_kgArLogWrite.var2 := 0;
		_kgArLogWrite();		
		
	END_IF
	
END_PROGRAM

