(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgRBcreate.st
 * Author: hunholz
 * Created: January 24, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Erzeuge Datenobjekt für Ringbuffer *)
FUNCTION_BLOCK kgRBcreate

	_diRB.enable := TRUE;
	_diRB.pName := ADR(sName);
	_diRB();

	IF wCntEntry = 0 THEN
		
		wStatus := KG_ERR_RB_SIZE;
		RETURN;
		
	END_IF
	
	IF _diRB.status = ERR_OK THEN
		
		IF ((wCntEntry+1) * lLenEntry) > _diRB.len THEN
		
			_ddRB.enable := TRUE;
			_ddRB.ident := _diRB.ident;
			_ddRB();

			wPtrRead := 0;
			wPtrStart := 0;
			wPtrWrite := 0;

			IF _ddRB.status <> ERR_OK THEN
				
				wStatus := _ddRB.status;
				RETURN;
			
			END_IF
			
		END_IF
		
	END_IF
	
	_diRB();
	
	IF _diRB.status = doERR_MODULNOTFOUND  THEN															

		wPtrRead := 0;
		wPtrStart := 0;
		wPtrWrite := 0;

		_dcRB.enable := TRUE;
		_dcRB.pName := ADR(sName);
		_dcRB.len := (wCntEntry+1) * lLenEntry;
		_dcRB.MemType := bMemType;
		_dcRB();

		IF _dcRB.status = ERR_OK OR _dcRB.status = doERR_DUPOBJECT  THEN

			_diRB();
				
			IF _diRB.status <> ERR_OK THEN
				
				wStatus := _diRB.status;
				RETURN;
					
			END_IF;
			
		ELSE

			wStatus := _diRB.status;
			RETURN;

		END_IF;
	
	ELSIF _diRB.status <> ERR_OK THEN

		wStatus := _diRB.status;
		RETURN;

	END_IF;

	doIdent := _diRB.ident;
	doLen := _diRB.len;
	pDatObjMem := _diRB.pDatObjMem;
	
	wStatus := ERR_OK;
	
END_FUNCTION_BLOCK