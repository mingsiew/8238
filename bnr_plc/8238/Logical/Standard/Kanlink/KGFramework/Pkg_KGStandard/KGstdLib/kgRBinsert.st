(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgRBinsert.st
 * Author: hunholz
 * Created: December 20, 2011
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Insert any entry into a ringbuffer *)
FUNCTION_BLOCK kgRBinsert
	
	// VAR_IN_OUT UINT wPtrWrite
	// VAR_IN_OUT UINT wPtrRead
	// VAR_IN_OUT UINT wPtrStart
	// VAR_INPUT pEntry (Pointer to data)
	// VAR_INPUT lLenEntry (Size of data)
	// VAR_INPUT doLen
	// VAR_INPUT doIdent
	// VAR_OUT   wStatus
	
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
	IF  wPtrStart > _wPtrMax THEN
		// Constant UINT KG_ERR_RB_WRITEPOINTER = 2 of KGstdLib
		wStatus := KG_ERR_RB_STARTPOINTER;
		RETURN;
	END_IF;

	IF pEntry = 0 THEN
		// Constant UINT KG_ERR_RB_POINTER = 3 of KGstdLib
		wStatus := KG_ERR_RB_POINTER;
		RETURN;
	END_IF

	// VAR doWrite of DatObjWrite 'writes to a data object'
	// ADR() in ANSI C: &
	doWrite.enable := TRUE;			// enables execution
	doWrite.ident := doIdent;		// ID of the data object
	doWrite.len := lLenEntry;		// length of the data to be copied
	doWrite.Offset := wPtrWrite * lLenEntry;	// offset in the data area of the data object
	doWrite.pSource := pEntry;		// pointer to the data copied to the data object
	doWrite();
	
	IF doWrite.status = ERR_OK THEN
		
		wPtrWrite := UDINT_TO_UINT((wPtrWrite + 1) MOD _lRBlen);
		
		IF wPtrRead = wPtrWrite THEN
			wPtrRead := UDINT_TO_UINT((wPtrRead + 1) MOD _lRBlen);
		END_IF

		IF wPtrStart = wPtrWrite THEN
			wPtrStart := UDINT_TO_UINT((wPtrStart + 1) MOD _lRBlen);
		END_IF
		
	END_IF;
	
	wStatus := doWrite.status;	// UINT status: execution status: ERR_OK, ERR_FUB_ENABLE_FALSE, 0xXXXX = see help

END_FUNCTION_BLOCK