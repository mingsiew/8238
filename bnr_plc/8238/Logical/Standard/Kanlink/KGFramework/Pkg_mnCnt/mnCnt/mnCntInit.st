(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: mnCnt
 * File: mnCntInit.st
 * Author: hunholz
 * Created: July 02, 2011
 ********************************************************************
 * Implementation of program mnCnt
 ********************************************************************)

PROGRAM _INIT

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'mnCnt';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnCntStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnCntStatAd.sPkgVersion := '---';
		
	END_IF

	// Initialisierungen
	
	// Function ID von mnCnt
	kgMsgStatus[MNCNT_IDX_KGMSGSTAT].wFunction_ID := 6;
	
	// =============
	// Batche-Events
	// =============
	
	IFmnCnt.Out.xBatchEventReadOK := FALSE;
	
	// Statistik prüfen
	
	_doBatchStat.enable := TRUE;
	_doBatchStat.pName := ADR(_DataObjectName.sBatchStatName);						
	_doBatchStat();
	
	IF _doBatchStat.status <> ERR_OK THEN
		
		_dcBatchStat.enable := TRUE;
		_dcBatchStat.MemType := doUSRROM;
		_dcBatchStat.pName := ADR(_DataObjectName.sBatchStatName);
		_dcBatchStat.len := SIZEOF(_BatchStat);
		_dcBatchStat();
		
		_doBatchStat();
		
	END_IF

	IF _doBatchStat.status = ERR_OK THEN

		_BatchStat ACCESS _doBatchStat.pDatObjMem;

		_xBatchStatOK := TRUE;
		
	END_IF

	// Ringbuffer prüfen
	
	_kgRBcreateBatch.sName := _DataObjectName.sBatchRBName;
	_kgRBcreateBatch.bMemType := doUSRROM;
	_kgRBcreateBatch.lLenEntry := SIZEOF(_BatchRB[1]);
	_kgRBcreateBatch.wCntEntry := MNCNT_MAX_RBENTRY_BATCH;
	
	_kgRBcreateBatch(wPtrWrite := _wPtrWriteBatch , wPtrRead := _wPtrReadBatch, wPtrStart := _wPtrStartBatch);
	
	IF _kgRBcreateBatch.wStatus = ERR_OK THEN
		
		_rbBatchIns.doIdent 	:= _kgRBcreateBatch.doIdent;
		_rbBatchIns.doLen		:= _kgRBcreateBatch.doLen;
		_rbBatchIns.lLenEntry	:= SIZEOF(_BatchRB[1]);
		
		_rbBatchRead.doIdent 	:= _kgRBcreateBatch.doIdent;
		_rbBatchRead.doLen		:= _kgRBcreateBatch.doLen;
		_rbBatchRead.lLenEntry	:= SIZEOF(_BatchRB[1]);
		
		_xBatchRbOK 			:= TRUE;
		
		_BatchRB ACCESS _kgRBcreateBatch.pDatObjMem;
		
	END_IF
	
	// =============
	// Counter-Events
	// =============
	
	brsmemset(ADR(IFmnCnt.Out.xCounterEventReadOK), 0, SIZEOF(IFmnCnt.Out.xCounterEventReadOK));
	
	// Statistik prüfen
	
	_doCounterStat.enable := TRUE;
	_doCounterStat.pName := ADR(_DataObjectName.sCountStatName);						
	_doCounterStat();
	
	IF _doCounterStat.status = ERR_OK THEN
		
		// Statistik wurde vergrößtert, d.h. die aktuelle wird gelöscht
		IF _doCounterStat.len < SIZEOF(_CounterStat) THEN
			
			_ddCounterStat.enable := TRUE;
			_ddCounterStat.ident := _doCounterStat.ident;
			_ddCounterStat();
			
			_doCounterStat();
			
		END_IF
		
	END_IF
		
	IF _doCounterStat.status <> ERR_OK THEN	
		
		_dcCounterStat.enable := TRUE;
		_dcCounterStat.MemType := doUSRROM;
		_dcCounterStat.pName := ADR(_DataObjectName.sCountStatName);
		_dcCounterStat.len := SIZEOF(_CounterStat);
		_dcCounterStat();
		
		_doCounterStat();
		
	END_IF

	IF _doCounterStat.status = ERR_OK THEN

		_CounterStat ACCESS _doCounterStat.pDatObjMem;

		_xCounterStatOK := TRUE;
		
	END_IF
			
	// Ringbuffer prüfen
	
	_kgRBcreateCounter.sName := _DataObjectName.sCountRBName;
	_kgRBcreateCounter.bMemType := doUSRROM;
	_kgRBcreateCounter.lLenEntry := SIZEOF(_CounterRB[1]);
	_kgRBcreateCounter.wCntEntry := MNCNT_MAX_RBENTRY_COUNTER;
	
	_kgRBcreateCounter(wPtrWrite := _wPtrWriteCounter , wPtrRead := _wPtrReadCounter, wPtrStart := _wPtrStartCounter);
	
	IF _kgRBcreateCounter.wStatus = ERR_OK THEN
		
		_rbCounterIns.doIdent 	:= _kgRBcreateCounter.doIdent;
		_rbCounterIns.doLen		:= _kgRBcreateCounter.doLen;
		_rbCounterIns.lLenEntry	:= SIZEOF(_CounterRB[1]);
		
		_rbCounterRead.doIdent 	:= _kgRBcreateCounter.doIdent;
		_rbCounterRead.doLen		:= _kgRBcreateCounter.doLen;
		_rbCounterRead.lLenEntry	:= SIZEOF(_CounterRB[1]);
		
		_xCounterRbOK 			:= TRUE;
		
		_CounterRB ACCESS _kgRBcreateCounter.pDatObjMem;
		
	END_IF

	
	// =============
	// Timer-Events
	// =============
	
	brsmemset(ADR(IFmnCnt.Out.xTimeEventReadOK), 0, SIZEOF(IFmnCnt.Out.xTimeEventReadOK));
	
	// Statistik prüfen
	
	_doTimerStat.enable := TRUE;
	_doTimerStat.pName := ADR(_DataObjectName.sTimeStatName);
	_doTimerStat();
	
	IF _doTimerStat.status = ERR_OK THEN
		
		// Statistik wurde vergrößtert, d.h. die aktuelle wird gelöscht
		IF _doTimerStat.len < SIZEOF(_TimerStat) THEN
			
			_ddTimerStat.enable := TRUE;
			_ddTimerStat.ident := _doTimerStat.ident;
			_ddTimerStat();
			
			_doTimerStat();
			
		END_IF
		
	END_IF
		
	IF _doTimerStat.status <> ERR_OK THEN	
		
		_dcTimerStat.enable := TRUE;
		_dcTimerStat.MemType := doUSRROM;
		_dcTimerStat.pName := ADR(_DataObjectName.sTimeStatName);
		_dcTimerStat.len := SIZEOF(_TimerStat);
		_dcTimerStat();
		
		_doTimerStat();
		
	END_IF

	IF _doTimerStat.status = ERR_OK THEN

		_TimerStat ACCESS _doTimerStat.pDatObjMem;

		_xTimerStatOK := TRUE;
		
	END_IF

	// Ringbuffer prüfen
	
	_kgRBcreateTimer.sName := _DataObjectName.sTimeRBName;
	_kgRBcreateTimer.bMemType := doUSRROM;
	_kgRBcreateTimer.lLenEntry := SIZEOF(_TimerRB[1]);
	_kgRBcreateTimer.wCntEntry := MNCNT_MAX_RBENTRY_TIME;
	
	_kgRBcreateTimer(wPtrWrite := _wPtrWriteTimer , wPtrRead := _wPtrReadTimer, wPtrStart := _wPtrStartTimer);
	
	IF _kgRBcreateTimer.wStatus = ERR_OK THEN
		
		_rbTimerIns.doIdent 	:= _kgRBcreateTimer.doIdent;
		_rbTimerIns.doLen		:= _kgRBcreateTimer.doLen;
		_rbTimerIns.lLenEntry	:= SIZEOF(_TimerRB[1]);
		
		_rbTimerRead.doIdent 	:= _kgRBcreateTimer.doIdent;
		_rbTimerRead.doLen		:= _kgRBcreateTimer.doLen;
		_rbTimerRead.lLenEntry	:= SIZEOF(_TimerRB[1]);
		
		_xTimerRbOK 			:= TRUE;
		
		_TimerRB ACCESS _kgRBcreateTimer.pDatObjMem;
		
	END_IF
	
	// =============
	// Dosing-Events
	// =============
	
	brsmemset(ADR(IFmnCnt.Out.xDosingEventReadOK), 0, SIZEOF(IFmnCnt.Out.xDosingEventReadOK));
	
	// Statistik prüfen
	
	_doDosingStat.enable := TRUE;
	_doDosingStat.pName := ADR(_DataObjectName.sDoseStatName);
	_doDosingStat();
	
	IF _doDosingStat.status = ERR_OK THEN
		
		// Statistik wurde vergrößtert, d.h. die aktuelle wird gelöscht
		IF _doDosingStat.len < SIZEOF(_DoseStat) THEN
			
			_ddDosingStat.enable := TRUE;
			_ddDosingStat.ident := _doDosingStat.ident;
			_ddDosingStat();
			
			_doDosingStat();
			
		END_IF
		
	END_IF
		
	IF _doDosingStat.status <> ERR_OK THEN	
		
		_dcDosingStat.enable := TRUE;
		_dcDosingStat.MemType := doUSRROM;
		_dcDosingStat.pName := ADR(_DataObjectName.sDoseStatName);
		_dcDosingStat.len := SIZEOF(_DoseStat);
		_dcDosingStat();
		
		_doDosingStat();
		
	END_IF

	IF _doDosingStat.status = ERR_OK THEN

		_DoseStat ACCESS _doDosingStat.pDatObjMem;

		_xDoseStatOK := TRUE;
		
	END_IF
			
	// Ringbuffer prüfen
	
	_kgRBcreateDosing.sName := _DataObjectName.sDoseRBName;
	_kgRBcreateDosing.bMemType := doUSRROM;
	_kgRBcreateDosing.lLenEntry := SIZEOF(_DoseRB[1]);
	_kgRBcreateDosing.wCntEntry := MNCNT_MAX_RBENTRY_DOSE;
	
	_kgRBcreateDosing(wPtrWrite := _wPtrWriteDose , wPtrRead := _wPtrReadDose, wPtrStart := _wPtrStartDose);
	
	IF _kgRBcreateDosing.wStatus = ERR_OK THEN
		
		_rbDoseIns.doIdent 	:= _kgRBcreateDosing.doIdent;
		_rbDoseIns.doLen		:= _kgRBcreateDosing.doLen;
		_rbDoseIns.lLenEntry	:= SIZEOF(_DoseRB[1]);
		
		_rbDoseRead.doIdent 	:= _kgRBcreateDosing.doIdent;
		_rbDoseRead.doLen		:= _kgRBcreateDosing.doLen;
		_rbDoseRead.lLenEntry	:= SIZEOF(_DoseRB[1]);
		
		_xDoseRbOK 			:= TRUE;
		
		_DoseRB ACCESS _kgRBcreateDosing.pDatObjMem;
		
	END_IF
	
END_PROGRAM

