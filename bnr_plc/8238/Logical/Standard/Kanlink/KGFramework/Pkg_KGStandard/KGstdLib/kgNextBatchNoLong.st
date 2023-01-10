(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: kgNextBatchNoLong.st
 * Author: hunholz
 * Created: July 19, 2011
 * Changed: Feb 15, 2012
 ********************************************************************
 * Implementation of library KGstd
 ********************************************************************) 

(* Generiert eine neue Postennummer *)
FUNCTION_BLOCK kgNextBatchNoLong
	
	IF EDGEPOS(Enable) THEN
		IF _bStep = 0 THEN
			_bStep := 1;
		END_IF
	END_IF
	
	IF _bStep = 255 AND NOT Enable THEN
		_bStep := 0;
	END_IF
	
	CASE _bStep OF
		
		0: // Enable ist FALSE

			Status := ERR_FUB_ENABLE_FALSE;

		1: // Enable ist TRUE

			_diBatchNo(enable := TRUE, pName := ADR('_BatchNo'));
			
			IF _diBatchNo.status = ERR_OK THEN
				
				_pBatchNo ACCESS _diBatchNo.pDatObjMem;

				// Datum der aktuellen Postennummer extrahieren
				_bOldYear := UDINT_TO_USINT( SHR( (_pBatchNo AND 16#003F8000) ,15));
				_bOldMonth := UDINT_TO_USINT( SHR( (_pBatchNo AND 16#03C00000) , 22));
				_bOldDay := UDINT_TO_USINT( SHR( (_pBatchNo AND 16#7C000000) ,26));
				_bGroup := UDINT_TO_USINT( SHR( (_pBatchNo AND 16#00007000) ,12));
				_wNo := UDINT_TO_UINT( _pBatchNo AND 16#00000FFF );
		
				DTStrucGetTime.enable := TRUE;
				DTStrucGetTime.pDTStructure := ADR(_dtStruc);
				DTStrucGetTime();

				IF (_bGroup <> Group MOD 8 ) THEN
					_bGroup := Group MOD 8;
					_wNo := 0;
				END_IF	
		
				IF (_bOldDay <> _dtStruc.day) OR (_bOldMonth <> _dtStruc.month) OR (_bOldYear <> UINT_TO_USINT(_dtStruc.year MOD 2000) ) THEN
					_bOldDay := _dtStruc.day;
					_bOldMonth := _dtStruc.month;
					_bOldYear := UINT_TO_USINT(_dtStruc.year MOD 2000);
					_wNo := 0;
				END_IF
		
				IF _wNo = 4095 THEN
			
					Status := 1;
		
				ELSE
			
					_wNo := _wNo + 1;
			
					BatchNo := 0;
					BatchNo := BatchNo OR SHL(USINT_TO_UDINT(_bOldDay),26);
					BatchNo := BatchNo OR SHL(USINT_TO_UDINT(_bOldMonth),22);
					BatchNo := BatchNo OR SHL(USINT_TO_UDINT(_bOldYear),15);
					BatchNo := BatchNo OR SHL(USINT_TO_UDINT(_bGroup),12);
					BatchNo := BatchNo OR UINT_TO_UDINT(_wNo);
					
					_dwBatchNo(enable := TRUE, ident := _diBatchNo.ident, len := SIZEOF(BatchNo), Offset := 0, pSource := ADR(BatchNo));
					
					Status := _dwBatchNo.status;
			
				END_IF
				
				_bStep := 255;	// Fertig

			ELSE

				_bStep := 2;	// Datenobjekt anlegen

				Status := ERR_FUB_BUSY;
				
			END_IF
			
		2:	// Datenobjekt anlegen
		
			_dcBatchNo.enable := TRUE;
			_dcBatchNo.len := SIZEOF(BatchNo);
			_dcBatchNo.MemType := doUSRROM;
			_dcBatchNo.pName := ADR('_BatchNo');
		
			_dcBatchNo();
			
			Status := _dcBatchNo.status;
		
			IF _dcBatchNo.status = ERR_OK THEN
				_bStep := 1;

				Status := ERR_FUB_BUSY;

			ELSIF _dcBatchNo.status <> ERR_FUB_BUSY THEN

				Status := _dcBatchNo.status;
				BatchNo := 0;
				_bStep := 255;

			END_IF
			
		255:	// Fertig
			
			_diBatchNo(enable := TRUE, pName := ADR('_BatchNo'));
			
			IF _diBatchNo.status = ERR_OK THEN

				_pBatchNo ACCESS _diBatchNo.pDatObjMem;
				BatchNo := _pBatchNo;
				
			ELSE
				
				_bStep := 2;	// Datenobjekt anlegen

				Status := ERR_FUB_BUSY;

				BatchNo := 0;
			
			END_IF
		
	END_CASE

END_FUNCTION_BLOCK
