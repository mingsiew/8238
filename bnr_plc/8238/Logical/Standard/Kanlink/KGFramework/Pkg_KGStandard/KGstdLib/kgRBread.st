(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgRBread.st
 * Author: hunholz
 * Created: December 20, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Reads one entry and moves the readpointer *)
FUNCTION_BLOCK kgRBread

	_lRBlen := doLen / lLenEntry;
	
	// Der Ringbuffer muss wenigstens zwei Einträge halten können, wobei
	// ein Eintrag immer leer ist.
	IF _lRBlen <= 1 THEN
		wStatus := KG_ERR_RB_SIZE;
		RETURN;
	END_IF
	
	_wPtrMax := UDINT_TO_UINT(_lRBlen - 1);
	
	// Der Schreibzeiger muss immer auf eine gültige Position innerhalb des
	// Ringbuffers zeigen.
	IF  wPtrWrite > _wPtrMax THEN
		// Constant UINT KG_ERR_RB_WRITEPOINTER = 2 of KGstdLib
		wStatus := KG_ERR_RB_WRITEPOINTER;
		RETURN;
	END_IF;

	// Der Startzeiger muss immer auf eine gültige Position innerhalb des
	// Ringbuffers zeigen.
	IF  wPtrRead > _wPtrMax THEN
		// Constant UINT KG_ERR_RB_WRITEPOINTER = 2 of KGstdLib
		wStatus := KG_ERR_RB_READPOINTER;
		RETURN;
	END_IF;

	IF (wPtrRead = wPtrWrite) THEN
		
		wStatus := KG_ERR_RB_NOREAD;
		RETURN;
	
	END_IF
	
	IF (wPtrRead > wPtrWrite) AND (UDINT_TO_UINT((wPtrWrite+1)MOD _lRBlen) <> wPtrStart) THEN
		// Lesezeiger zeigt in einen noch nicht beschriebenen Bereich
		wStatus := KG_ERR_RB_READPOINTER;
		RETURN;
	END_IF;		

	IF (pEntry = 0) THEN
		
		wStatus := KG_ERR_RB_POINTER;
		RETURN;
		
	END_IF

	// doRead of DatObjRead 'reads from a data object'
	doRead.enable 		:= TRUE;	// enables execution
	doRead.ident 		:= doIdent;	// ID of the data object
	doRead.len 			:= lLenEntry;	// length of the data to be copied
	doRead.Offset 		:= wPtrRead * lLenEntry;	// offset in the data area of the data object
	doRead.pDestination := pEntry;	// memory to which the data to be read is copied
	doRead();
	
	IF doRead.status = ERR_OK THEN
	
		wPtrRead := UDINT_TO_UINT((wPtrRead + 1) MOD _lRBlen);
				
	END_IF
	
	wStatus := doRead.status; // executions status: ERR_OK, ERR_FUB_ENABLE_FALSE, 0xXXXX = see help

END_FUNCTION_BLOCK