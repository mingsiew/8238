(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Program: mnCnt
 * File: mnCntCyclic.st
 * Author: hunholz
 * Created: July 02, 2011
 * Changed: January 3, 2012
 ********************************************************************
 * Implementation of program mnCnt
 ********************************************************************)

PROGRAM _CYCLIC

	/////////////
	// BATCHDATEN
	/////////////
	
	IF IFmnCnt.In.bBatchEventValid > 0 AND NOT IFmnCnt.Out.xBatchEventReadOK THEN
		
		// RB Eintrag
		// Jedes Batch-Event wird in den Ringbuffer eingetregen
		IF _xBatchRbOK AND IFmnCnt.In.BatchEvent.bEvent <= MNCNT_BATCHEVENT_DELETE THEN
			
			_rbBatchIns(pEntry := ADR(IFmnCnt.In.BatchEvent), wPtrWrite := _wPtrWriteBatch, wPtrRead := _wPtrReadBatch, wPtrStart := _wPtrStartBatch);
			
			IF _rbBatchIns.wStatus <> ERR_OK THEN
				
				_xBatchRbOK := FALSE;
				
			END_IF
			
		END_IF
		
		// Statistik ergänzen
		// Für jedes Entlade-Event wird ein Gesamtsummenzähler sowie ein Programm-Summenzähler gezählt		
		IF _xBatchStatOK AND IFmnCnt.In.BatchEvent.bEvent = MNCNT_BATCHEVENT_UNLOAD THEN
			

			REPEAT
			
				_dwBatchStat.enable := TRUE;
				_dwBatchStat.ident := _doBatchStat.ident;
				_dwBatchStat.len := SIZEOF(_lSumWeight);
				_dwBatchStat.pSource := ADR(_lSumWeight);

				IF IFmnCnt.In.BatchEvent.bProgram <= 99 THEN
					
					// Zunächst die Zähler pro Programm addieren und in das Datenobjekt schreiben. Erst für den 1. Zähler, dann für den 2. Zähler
					_lSumWeight := _BatchStat.Weight1[IFmnCnt.In.BatchEvent.bProgram] + UINT_TO_UDINT(IFmnCnt.In.BatchEvent.Batch.wTotalWeight);
					
					_dwBatchStat.Offset := ADR(_BatchStat.Weight1[IFmnCnt.In.BatchEvent.bProgram]) - _doBatchStat.pDatObjMem;
					_dwBatchStat();
					
					IF _dwBatchStat.status <> ERR_OK THEN
						
						_xBatchStatOK := FALSE;
						
						EXIT;
						
					END_IF
	
					_lSumWeight := _BatchStat.Weight2[IFmnCnt.In.BatchEvent.bProgram] + UINT_TO_UDINT(IFmnCnt.In.BatchEvent.Batch.wTotalWeight);
					
					_dwBatchStat.Offset := ADR(_BatchStat.Weight2[IFmnCnt.In.BatchEvent.bProgram]) - _doBatchStat.pDatObjMem;
					_dwBatchStat();
					
					IF _dwBatchStat.status <> ERR_OK THEN
						
						_xBatchStatOK := FALSE;
						
						EXIT;
						
					END_IF
					
				END_IF
				
				// Dann wird der Gesamtzähler addiert

				_lSumWeight := _BatchStat.Weight1[100] + UINT_TO_UDINT(IFmnCnt.In.BatchEvent.Batch.wTotalWeight);
					
				_dwBatchStat.Offset := ADR(_BatchStat.Weight1[100]) - _doBatchStat.pDatObjMem;
				_dwBatchStat();
					
				IF _dwBatchStat.status <> ERR_OK THEN
						
					_xBatchStatOK := FALSE;
						
					EXIT;
						
				END_IF

				_lSumWeight := _BatchStat.Weight2[100] + UINT_TO_UDINT(IFmnCnt.In.BatchEvent.Batch.wTotalWeight);
					
				_dwBatchStat.Offset := ADR(_BatchStat.Weight2[100]) - _doBatchStat.pDatObjMem;
				_dwBatchStat();
					
				IF _dwBatchStat.status <> ERR_OK THEN
						
					_xBatchStatOK := FALSE;
						
					EXIT;
						
				END_IF
				
				UNTIL
				
				TRUE
				
			END_REPEAT
			
		END_IF
		
		IFmnCnt.Out.xBatchEventReadOK := _xBatchRbOK AND _xBatchStatOK;
		
	ELSIF IFmnCnt.In.bBatchEventValid = 0 THEN
		
		IFmnCnt.Out.xBatchEventReadOK := FALSE;
		
	END_IF
	
	//////////////
	// ZÄHLERDATEN
	//////////////
	
	FOR _i := 0 TO MNCNT_IDX_COUNTER_MAX DO
		
		IF IFmnCnt.In.bCntEventValid[_i] > 0 AND NOT IFmnCnt.Out.xCounterEventReadOK[_i] THEN
			
			// Ringbuffer Eintrag
			
			IF _xCounterRbOK THEN
				
				_rbCounterIns(pEntry := ADR(IFmnCnt.In.CounterEvent[_i]), wPtrWrite := _wPtrWriteCounter, wPtrRead := _wPtrReadCounter, wPtrStart := _wPtrStartCounter);
				
			END_IF

			IF _rbCounterIns.wStatus <> ERR_OK THEN
				
				_xCounterRbOK := FALSE;
				
			END_IF
			
			// Zählbare Zählerevents aufaddieren
			
			IF _xCounterStatOK AND IFmnCnt.In.CounterEvent[_i].lAmount > 0 AND IFmnCnt.In.CounterEvent[_i].bType < MNCNT_COUNTERTYPE_NOTCOUNTABLE THEN

				REPEAT
				
					// Zählernamen schreiben
					_dwCounterStat.enable := TRUE;
					_dwCounterStat.ident := _doCounterStat.ident;
	
					_dwCounterStat.pSource := ADR(IFmnCnt.In.CounterEvent[_i].Source.sNameId);
					_dwCounterStat.len := SIZEOF(_CounterStat.sCounterNameId[0]);
					_dwCounterStat.Offset := ADR(_CounterStat.sCounterNameId[_i]) - _doCounterStat.pDatObjMem;
					
					_dwCounterStat();
					
					IF _dwCounterStat.status <> ERR_OK THEN
						
						_xCounterStatOK := FALSE;
						
						EXIT;
						
					END_IF

					// Zählertyp schreiben
					_dwCounterStat.pSource := ADR(IFmnCnt.In.CounterEvent[_i].bType);
					_dwCounterStat.len := SIZEOF(_CounterStat.bCounterType[0]);
					_dwCounterStat.Offset := ADR(_CounterStat.bCounterType[_i]) - _doCounterStat.pDatObjMem;
					
					_dwCounterStat();
					
					IF _dwCounterStat.status <> ERR_OK THEN
						
						_xCounterStatOK := FALSE;
						
						EXIT;
						
					END_IF
					
					// Ersten Zähler addieren
					_lCounter := _CounterStat.Counter1[_i] + IFmnCnt.In.CounterEvent[_i].lAmount;
					
					_dwCounterStat.pSource := ADR(_lCounter);
					_dwCounterStat.len := SIZEOF(_CounterStat.Counter1[0]);
					_dwCounterStat.Offset := ADR(_CounterStat.Counter1[_i]) - _doCounterStat.pDatObjMem;
					
					_dwCounterStat();
					
					IF _dwCounterStat.status <> ERR_OK THEN
						
						_xCounterStatOK := FALSE;
						
						EXIT;
						
					END_IF

					// Zweiten Zähler addieren
					_lCounter := _CounterStat.Counter2[_i] + IFmnCnt.In.CounterEvent[_i].lAmount;
					
					_dwCounterStat.Offset := ADR(_CounterStat.Counter2[_i]) - _doCounterStat.pDatObjMem;
					
					_dwCounterStat();
					
					IF _dwCounterStat.status <> ERR_OK THEN
						
						_xCounterStatOK := FALSE;
						
						EXIT;
						
					END_IF

					UNTIL
					
					TRUE
				
				END_REPEAT
				
			END_IF

			IFmnCnt.Out.xCounterEventReadOK[_i] := _xCounterRbOK AND _xCounterStatOK;
			
		ELSIF IFmnCnt.In.bCntEventValid[_i] = 0 THEN
		
			IFmnCnt.Out.xCounterEventReadOK[_i] := FALSE;
			
		END_IF
		
	END_FOR


	//////////////
	// ZEITDATEN
	//////////////
	
	IF IFmnCnt.In.bTimeEventValid > 0 AND NOT IFmnCnt.Out.xTimeEventReadOK THEN
			
		// Ringbuffer Eintrag
		
		IF _xTimerRbOK THEN
			
			_rbTimerIns(pEntry := ADR(IFmnCnt.In.TimeEvent), wPtrWrite := _wPtrWriteTimer, wPtrRead := _wPtrReadTimer, wPtrStart := _wPtrStartTimer);
			
		END_IF

		IF _rbTimerIns.wStatus <> ERR_OK THEN
			
			_xTimerRbOK := FALSE;
			
		END_IF
		
		IF _xTimerStatOK AND IFmnCnt.In.TimeEvent.bState <= MNCNT_IDX_TIMESTATE_MAX AND IFmnCnt.In.TimeEvent.bSubState <= MNCNT_IDX_TIMESUBSTATE_MAX
			AND IFmnCnt.In.TimeEvent.lAmount > 0 THEN

			REPEAT
			
				_dwTimerStat.enable := TRUE;
				_dwTimerStat.ident := _doTimerStat.ident;

				// Ersten Zeitzähler addieren
				_lTime := _TimerStat.Counter1[IFmnCnt.In.TimeEvent.bState,IFmnCnt.In.TimeEvent.bSubState] + IFmnCnt.In.TimeEvent.lAmount;				
				
				_dwTimerStat.pSource := ADR(_lTime);
				_dwTimerStat.len := SIZEOF(_TimerStat.Counter1[0,0]);
				_dwTimerStat.Offset := ADR(_TimerStat.Counter1[IFmnCnt.In.TimeEvent.bState,IFmnCnt.In.TimeEvent.bSubState]) - _doTimerStat.pDatObjMem;
				
				_dwTimerStat();
				
				IF _dwTimerStat.status <> ERR_OK THEN
					
					_xTimerStatOK := FALSE;
					
					EXIT;
					
				END_IF

				// Zweiten Zeitzähler addieren
				_lTime := _TimerStat.Counter2[IFmnCnt.In.TimeEvent.bState,IFmnCnt.In.TimeEvent.bSubState] + IFmnCnt.In.TimeEvent.lAmount;				
				
				_dwTimerStat.Offset := ADR(_TimerStat.Counter2[IFmnCnt.In.TimeEvent.bState,IFmnCnt.In.TimeEvent.bSubState]) - _doTimerStat.pDatObjMem;
				
				_dwTimerStat();
				
				IF _dwTimerStat.status <> ERR_OK THEN
					
					_xTimerStatOK := FALSE;
					
					EXIT;
					
				END_IF

				UNTIL
				
				TRUE
			
			END_REPEAT
			
		END_IF

		IFmnCnt.Out.xTimeEventReadOK := _xTimerRbOK AND _xTimerStatOK;
		
	ELSIF IFmnCnt.In.bTimeEventValid = 0 THEN
	
		IFmnCnt.Out.xTimeEventReadOK := FALSE;
		
	END_IF


	//////////////
	// DOSIERDATEN
	//////////////
	
	FOR _i := 1 TO 48 DO
		
		IF IFmnCnt.In.bDosingEventValid[_i] > 0 AND NOT IFmnCnt.Out.xDosingEventReadOK[_i] THEN
			
			// Ringbuffer Eintrag
			
			IF _xDoseRbOK THEN
				
				_DosingEvent.DosingEvent := IFmnCnt.In.DosingEvent[_i];
				_DosingEvent.bId := UINT_TO_USINT(_i);
				_rbDoseIns(pEntry := ADR(_DosingEvent), wPtrWrite := _wPtrWriteDose, wPtrRead := _wPtrReadDose, wPtrStart := _wPtrStartDose);
				
			END_IF

			IF _rbDoseIns.wStatus <> ERR_OK THEN
				
				_xDoseRbOK := FALSE;
				
			END_IF
			
			
			IF _xDoseStatOK AND IFmnCnt.In.DosingEvent[_i].rAmount >= 0.001 THEN

				REPEAT
				
					_dwDosingStat.enable := TRUE;
					_dwDosingStat.ident := _doDosingStat.ident;
	
					// Namen der Dosierung schreiben
					_dwDosingStat.pSource := ADR(IFmnCnt.In.DosingEvent[_i].utfName);
					_dwDosingStat.len := SIZEOF(_DoseStat.utfDosingName[1]);
					_dwDosingStat.Offset := ADR(_DoseStat.utfDosingName[_i]) - _doDosingStat.pDatObjMem;
					
					_dwDosingStat();
					
					IF _dwDosingStat.status <> ERR_OK THEN
						
						_xDoseStatOK := FALSE;
						
						EXIT;
						
					END_IF

					// Einheit der Dosiermenge schreiben
					_dwDosingStat.pSource := ADR(IFmnCnt.In.DosingEvent[_i].sUnit);
					_dwDosingStat.len := SIZEOF(_DoseStat.sUnit[1]);
					_dwDosingStat.Offset := ADR(_DoseStat.sUnit[_i]) - _doDosingStat.pDatObjMem;
					
					_dwDosingStat();
					
					IF _dwDosingStat.status <> ERR_OK THEN
						
						_xDoseStatOK := FALSE;
						
						EXIT;
						
					END_IF

					// Pumpenkonstante schreiben
					_dwDosingStat.pSource := ADR(IFmnCnt.In.DosingEvent[_i].rPumpConst);
					_dwDosingStat.len := SIZEOF(_DoseStat.rPumpConst[1]);
					_dwDosingStat.Offset := ADR(_DoseStat.rPumpConst[_i]) - _doDosingStat.pDatObjMem;
					
					_dwDosingStat();
					
					IF _dwDosingStat.status <> ERR_OK THEN
						
						_xDoseStatOK := FALSE;
						
						EXIT;
						
					END_IF

					// Ersten Zähler für Dosiermenge addieren
					_rDoseingAmount := _DoseStat.Counter1[_i] + IFmnCnt.In.DosingEvent[_i].rAmount;
					
					_dwDosingStat.pSource := ADR(_rDoseingAmount);
					_dwDosingStat.len := SIZEOF(_DoseStat.Counter1[1]);
					_dwDosingStat.Offset := ADR(_DoseStat.Counter1[_i]) - _doDosingStat.pDatObjMem;
					
					_dwDosingStat();
					
					IF _dwDosingStat.status <> ERR_OK THEN
						
						_xDoseStatOK := FALSE;
						
						EXIT;
						
					END_IF

					// Zweiten Zähler für Dosiermenge addieren
					_rDoseingAmount := _DoseStat.Counter2[_i] + IFmnCnt.In.DosingEvent[_i].rAmount;
					
					_dwDosingStat.Offset := ADR(_DoseStat.Counter2[_i]) - _doDosingStat.pDatObjMem;
					
					_dwDosingStat();
					
					IF _dwDosingStat.status <> ERR_OK THEN
						
						_xDoseStatOK := FALSE;
						
						EXIT;
						
					END_IF

					UNTIL
					
					TRUE
				
				END_REPEAT
				
			END_IF

			IFmnCnt.Out.xDosingEventReadOK[_i] := _xDoseRbOK AND _xDoseStatOK;
			
		ELSIF IFmnCnt.In.bDosingEventValid[_i] = 0 THEN
		
			IFmnCnt.Out.xDosingEventReadOK[_i] := FALSE;
			
		END_IF
		
	END_FOR
	
	// Batchdaten an hlDFII senden
	
	// Senden nach 5 Sekunden wiederholen, wenn die letzte Sendung fehlerhaft war
	_TONrepeatDFIIBatchEvt(IN := (IFhlDFII.Out.RespCntBatchEvt.wResponse <> ERR_FUB_BUSY) AND (IFhlDFII.Out.RespCntBatchEvt.wResponse <> 0) 
			AND (IFhlDFII.Out.RespCntBatchEvt.wResponse <> IFhlDFII.In.ReqCntBatchEvt.wRequest), PT := T#5s);
	
	IF _xBatchRbOK THEN
		
		IF IFhlDFII.Out.RespCntBatchEvt.wResponse = 0 AND IFhlDFII.In.ReqCntBatchEvt.wRequest = 0 THEN

			// Die Schnittstelle zur Datenbank ist bereit!
			
			IF NOT _xRepeatDFIIBatchEvt THEN
				
				// Daten nur dann aus dem Ringbuffer lesen, wenn nicht wiederholt werden soll.

				IFhlDFII.In.ReqCntBatchEvt.bCntLines := 0;

				FOR _ii := 0 TO 4 DO
					
					_rbBatchRead(wPtrWrite := _wPtrWriteBatch, pEntry := ADR(IFhlDFII.In.ReqCntBatchEvt.CntBatchEvtList[_ii+1]), wPtrStart := _wPtrStartBatch, wPtrRead := _wPtrReadBatch);
					
					IF _rbBatchRead.wStatus <> 0 THEN
						// Ringbuffer hat keinen neuen Eintrag
						EXIT;
					END_IF
					
					IFhlDFII.In.ReqCntBatchEvt.bCntLines := IFhlDFII.In.ReqCntBatchEvt.bCntLines + 1;
					
				END_FOR

			END_IF
			
			_xRepeatDFIIBatchEvt := FALSE;
			
			IF IFhlDFII.In.ReqCntBatchEvt.bCntLines > 0 THEN
				// Senden wird nur ausgelöst, wenn der Ringbuffer einen neuen Eintrag hatte.
				IFhlDFII.In.ReqCntBatchEvt.wRequest := 1;
				
			END_IF
			
		ELSIF IFhlDFII.Out.RespCntBatchEvt.wResponse = IFhlDFII.In.ReqCntBatchEvt.wRequest THEN
			
			IFhlDFII.In.ReqCntBatchEvt.wRequest := 0;
			
		ELSIF IFhlDFII.Out.RespCntBatchEvt.wResponse <> ERR_FUB_BUSY AND _TONrepeatDFIIBatchEvt.Q THEN

			IFhlDFII.In.ReqCntBatchEvt.wRequest := 0;
			
			_xRepeatDFIIBatchEvt := TRUE;

		END_IF
		
	END_IF

	
	// Counter-Daten an hlDFII senden
	
	// Senden nach 5 Sekunden wiederholen, wenn die letzte Sendung fehlerhaft war
	_TONrepeatDFIICounterEvt(IN := (IFhlDFII.Out.RespCntCntEvt.wResponse <> ERR_FUB_BUSY) AND (IFhlDFII.Out.RespCntCntEvt.wResponse <> 0) 
	AND (IFhlDFII.Out.RespCntCntEvt.wResponse <> IFhlDFII.In.ReqCntCntEvt.wRequest), PT := T#5s);
	
	IF _xCounterRbOK THEN
		
		IF IFhlDFII.Out.RespCntCntEvt.wResponse = 0 AND IFhlDFII.In.ReqCntCntEvt.wRequest = 0 THEN

			// Die Schnittstelle zur Datenbank ist bereit!
			
			IF NOT _xRepeatDFIICounterEvt THEN
				
				// Daten nur dann aus dem Ringbuffer lesen, wenn nicht wiederholt werden soll.

				IFhlDFII.In.ReqCntCntEvt.bCntLines := 0;

				FOR _ii := 0 TO 4 DO
					
					_rbCounterRead(wPtrWrite := _wPtrWriteCounter, pEntry := ADR(IFhlDFII.In.ReqCntCntEvt.CntCounterEvtList[_ii+1]), wPtrStart := _wPtrStartCounter, wPtrRead := _wPtrReadCounter);
					
					IF _rbCounterRead.wStatus <> 0 THEN
						// Ringbuffer hat keinen neuen Eintrag
						EXIT;
					END_IF
					
					IFhlDFII.In.ReqCntCntEvt.bCntLines := IFhlDFII.In.ReqCntCntEvt.bCntLines + 1;
					
				END_FOR

			END_IF
			
			_xRepeatDFIICounterEvt := FALSE;
			
			IF IFhlDFII.In.ReqCntCntEvt.bCntLines > 0 THEN
				// Senden wird nur ausgelöst, wenn der Ringbuffer einen neuen Eintrag hatte.
				IFhlDFII.In.ReqCntCntEvt.wRequest := 1;
				
			END_IF
			
		ELSIF IFhlDFII.Out.RespCntCntEvt.wResponse = IFhlDFII.In.ReqCntCntEvt.wRequest THEN
			
			IFhlDFII.In.ReqCntCntEvt.wRequest := 0;
			
		ELSIF IFhlDFII.Out.RespCntCntEvt.wResponse <> ERR_FUB_BUSY AND _TONrepeatDFIICounterEvt.Q THEN

			IFhlDFII.In.ReqCntCntEvt.wRequest := 0;
			
			_xRepeatDFIICounterEvt := TRUE;

		END_IF
		
	END_IF

	// Timer-Daten an hlDFII senden
	
	// Senden nach 5 Sekunden wiederholen, wenn die letzte Sendung fehlerhaft war
	_TONrepeatDFIITimerEvt(IN := (IFhlDFII.Out.RespCntTimEvt.wResponse <> ERR_FUB_BUSY) AND (IFhlDFII.Out.RespCntTimEvt.wResponse <> 0) 
	AND (IFhlDFII.Out.RespCntTimEvt.wResponse <> IFhlDFII.In.ReqCntTimEvt.wRequest), PT := T#5s);
	
	IF _xTimerRbOK THEN
		
		IF IFhlDFII.Out.RespCntTimEvt.wResponse = 0 AND IFhlDFII.In.ReqCntTimEvt.wRequest = 0 THEN

			// Die Schnittstelle zur Datenbank ist bereit!
			
			IF NOT _xRepeatDFIITimerEvt THEN
				
				// Daten nur dann aus dem Ringbuffer lesen, wenn nicht wiederholt werden soll.

				IFhlDFII.In.ReqCntTimEvt.bCntLines := 0;

				FOR _ii := 0 TO 4 DO
					
					_rbTimerRead(wPtrWrite := _wPtrWriteTimer, pEntry := ADR(IFhlDFII.In.ReqCntTimEvt.CntTimerEvtList[_ii+1]), wPtrStart := _wPtrStartTimer, wPtrRead := _wPtrReadTimer);
					
					IF _rbTimerRead.wStatus <> 0 THEN
						// Ringbuffer hat keinen neuen Eintrag
						EXIT;
					END_IF
					
					IFhlDFII.In.ReqCntTimEvt.bCntLines := IFhlDFII.In.ReqCntTimEvt.bCntLines + 1;
					
				END_FOR

			END_IF
			
			_xRepeatDFIITimerEvt := FALSE;
			
			IF IFhlDFII.In.ReqCntTimEvt.bCntLines > 0 THEN
				// Senden wird nur ausgelöst, wenn der Ringbuffer einen neuen Eintrag hatte.
				IFhlDFII.In.ReqCntTimEvt.wRequest := 1;
				
			END_IF
			
		ELSIF IFhlDFII.Out.RespCntTimEvt.wResponse = IFhlDFII.In.ReqCntTimEvt.wRequest THEN
			
			IFhlDFII.In.ReqCntTimEvt.wRequest := 0;
			
		ELSIF IFhlDFII.Out.RespCntTimEvt.wResponse <> ERR_FUB_BUSY AND _TONrepeatDFIITimerEvt.Q THEN

			IFhlDFII.In.ReqCntTimEvt.wRequest := 0;
			
			_xRepeatDFIITimerEvt := TRUE;

		END_IF
		
	END_IF

	// Dosing-Daten an hlDFII senden
	
	// Senden nach 5 Sekunden wiederholen, wenn die letzte Sendung fehlerhaft war
	_TONrepeatDFIIDoseEvt(IN := (IFhlDFII.Out.RespCntDosEvt.wResponse <> ERR_FUB_BUSY) AND (IFhlDFII.Out.RespCntDosEvt.wResponse <> 0) 
	AND (IFhlDFII.Out.RespCntDosEvt.wResponse <> IFhlDFII.In.ReqCntDosEvt.wRequest), PT := T#5s);
	
	IF _xDoseRbOK THEN
		
		IF IFhlDFII.Out.RespCntDosEvt.wResponse = 0 AND IFhlDFII.In.ReqCntDosEvt.wRequest = 0 THEN

			// Die Schnittstelle zur Datenbank ist bereit!
			
			IF NOT _xRepeatDFIIDoseEvt THEN
				
				// Daten nur dann aus dem Ringbuffer lesen, wenn nicht wiederholt werden soll.

				IFhlDFII.In.ReqCntDosEvt.bCntLines := 0;

				FOR _ii := 0 TO 4 DO
					
					_rbDoseRead(wPtrWrite := _wPtrWriteDose, pEntry := ADR(IFhlDFII.In.ReqCntDosEvt.CntDosingEvtList[_ii+1]), wPtrStart := _wPtrStartDose, wPtrRead := _wPtrReadDose);
					
					IF _rbDoseRead.wStatus <> 0 THEN
						// Ringbuffer hat keinen neuen Eintrag
						EXIT;
					END_IF
					
					IFhlDFII.In.ReqCntDosEvt.bCntLines := IFhlDFII.In.ReqCntDosEvt.bCntLines + 1;
					
				END_FOR

			END_IF
			
			_xRepeatDFIIDoseEvt := FALSE;
			
			IF IFhlDFII.In.ReqCntDosEvt.bCntLines > 0 THEN
				// Senden wird nur ausgelöst, wenn der Ringbuffer einen neuen Eintrag hatte.
				IFhlDFII.In.ReqCntDosEvt.wRequest := 1;
				
			END_IF
			
		ELSIF IFhlDFII.Out.RespCntDosEvt.wResponse = IFhlDFII.In.ReqCntDosEvt.wRequest THEN
			
			IFhlDFII.In.ReqCntDosEvt.wRequest := 0;
			
		ELSIF IFhlDFII.Out.RespCntDosEvt.wResponse <> ERR_FUB_BUSY AND _TONrepeatDFIIDoseEvt.Q THEN

			IFhlDFII.In.ReqCntDosEvt.wRequest := 0;
			
			_xRepeatDFIIDoseEvt := TRUE;

		END_IF
		
	END_IF

END_PROGRAM
