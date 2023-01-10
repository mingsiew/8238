(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgRBbulkloc.st
 * Author: hunholz
 * Created: January 24, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Lese mehrere Einträge gleichzeitig in ein Array *)
FUNCTION_BLOCK kgRBbulkloc
	
	_lRBlen := doLen / lLenEntry;
	
	// Der Ringbuffer muss wenigstens zwei Einträge halten können, wobei
	// ein Eintrag immer leer ist.
	IF _lRBlen <= 1 THEN
		wStatus := KG_ERR_RB_SIZE;
		RETURN;
	END_IF
	
	_wPtrMax := UDINT_TO_UINT(_lRBlen - 1);
	
	IF ((wPtrWrite+1)MOD _lRBlen) = wPtrStart THEN
		_wActLen := _wPtrMax;
	ELSE
		_wActLen := wPtrWrite - wPtrStart;
	END_IF
	
	// Der Schreibzeiger muss immer auf eine gültige Position innerhalb des
	// Ringbuffers zeigen.
	IF  wPtrWrite > _wPtrMax THEN
		// Constant UINT KG_ERR_RB_WRITEPOINTER = 2 of KGstdLib
		wStatus := KG_ERR_RB_WRITEPOINTER;
		RETURN;
	END_IF;

	// Der Lesezeiger muss immer auf eine gültige Position innerhalb des
	// Ringbuffers zeigen.
	IF bMode = KG_RB_LOC_MODE_ABSOLUTE THEN
		
		IF  wPtrLoc > _wPtrMax THEN
			wStatus := KG_ERR_RB_LOCPOINTER;
			RETURN;
		END_IF;

	ELSIF wPtrLoc >= _wActLen THEN

		wStatus := KG_ERR_RB_LOCPOINTER;
		RETURN;

	END_IF
		
	_wPtrLoc := MUX(USINT_TO_SINT(bMode), wPtrLoc, UDINT_TO_UINT((wPtrStart+wPtrLoc)MOD _lRBlen), UDINT_TO_UINT((wPtrStart+(_wActLen - wPtrLoc - 1))MOD _lRBlen));
		
	IF (_wPtrLoc = wPtrWrite) THEN
			
		wStatus := KG_ERR_RB_NOREAD;
		RETURN;
		
	END_IF

	IF (_wPtrLoc > wPtrWrite) AND (UDINT_TO_UINT((wPtrWrite+1)MOD _lRBlen) <> wPtrStart) THEN
		// Lesezeiger zeigt in einen noch nicht beschriebenen Bereich
		wStatus := KG_ERR_RB_LOCPOINTER;
		RETURN;
	END_IF;		

		
	IF (pEntry = 0) THEN
		
		wStatus := KG_ERR_RB_POINTER;
		RETURN;
		
	END_IF

	wCntLoc := 0;
	
	brsmemset(pEntry, 0, lLenEntry*wCntEntry);
	
	IF (wCntEntry = 0) THEN
		
		wStatus := ERR_OK;
		RETURN;
	
	END_IF

	FOR _i := 0 TO wCntEntry-1 DO
	
		// doRead of DatObjRead 'reads from a data object'
		_doRead.enable 			:= TRUE;	// enables execution
		_doRead.ident 			:= doIdent;	// ID of the data object
		_doRead.len 				:= lLenEntry * 1;	// length of the data to be copied
		_doRead.Offset 			:= _wPtrLoc * lLenEntry;	// offset in the data area of the data object
		_doRead.pDestination 	:= pEntry + (_i * lLenEntry);	// memory to which the data to be read is copied
		_doRead();
		
		wStatus := _doRead.status; // executions status: ERR_OK, ERR_FUB_ENABLE_FALSE, 0xXXXX = see help
		
		IF wStatus <> ERR_OK THEN
			RETURN;
		END_IF

		wCntLoc := wCntLoc + 1;
		
		IF bMode = KG_RB_LOC_MODE_FROMEND THEN
			
			IF _wPtrLoc = wPtrStart THEN
				RETURN;
			END_IF
			
			IF _wPtrLoc = 0 THEN
				_wPtrLoc := UDINT_TO_UINT(_lRBlen);
			END_IF
			
			_wPtrLoc := _wPtrLoc - 1;
			
		ELSE
			
			_wPtrLoc := UDINT_TO_UINT((_wPtrLoc + 1) MOD _lRBlen);
			
			IF _wPtrLoc = wPtrWrite THEN
				RETURN;
			END_IF
			
		END_IF
		
	END_FOR
	
END_FUNCTION_BLOCK