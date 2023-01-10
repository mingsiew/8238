(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgRBloc.st
 * Author: hunholz
 * Created: December 20, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Free Readpointer access *)
FUNCTION_BLOCK kgRBloc

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

	// doRead of DatObjRead 'reads from a data object'
	doRead.enable 			:= TRUE;	// enables execution
	doRead.ident 			:= doIdent;	// ID of the data object
	doRead.len 				:= lLenEntry * 1;	// length of the data to be copied
	doRead.Offset 			:= _wPtrLoc * lLenEntry;	// offset in the data area of the data object
	doRead.pDestination 	:= pEntry;	// memory to which the data to be read is copied
	doRead();
	
	wStatus := doRead.status; // executions status: ERR_OK, ERR_FUB_ENABLE_FALSE, 0xXXXX = see help
	
END_FUNCTION_BLOCK