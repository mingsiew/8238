(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgCheckDo.st
 * Author: hunholz
 * Created: February 22, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Prüfe auf Datenobjekt und erzeuge es ggf. neu *)
FUNCTION_BLOCK kgCheckDo
	
	IF Enable THEN
		
		_xReady := FALSE;
		
		IF MinLen > NomLen THEN
			
			Status := KG_ERR_WRONGSIZES;
			RETURN;
			
		END_IF
		
		REPEAT

			CASE _wStep OF

				0:	// Hole Info
					
					_doInfo(enable := TRUE, pName := pName);
					
					IF _doInfo.status = ERR_OK THEN
						
						IF _doInfo.len >= MinLen THEN
							
							doId 	:= _doInfo.ident;
							doMem 	:= _doInfo.pDatObjMem;
							doLen 	:= _doInfo.len;
							
							Status := ERR_OK;
							
							_xReady := TRUE;
							
						ELSE
							
							_wStep := 1;
							Status := ERR_OK;
							
						END_IF
						
					ELSIF _doInfo.status <> ERR_FUB_BUSY THEN
						
						IF Create THEN
							
							// DO ist nicht vorhanden
							
							_wStep := 2;
							Status := ERR_OK;

						ELSE

							Status := _doInfo.status;
							_xReady := TRUE;

						END_IF
						
					END_IF
						
				1:	// Lösche vorhandenes DO
					
					_doDelete(enable := TRUE, ident := _doInfo.ident);
					
					IF _doDelete.status <> ERR_FUB_BUSY THEN
						
						Status := ERR_OK;
						_wStep := 2;
						
					ELSE
						
						Status := ERR_FUB_BUSY;
						
					END_IF
					
				2:	// Erzeuge DO neu
					
					_doCreate(enable := TRUE, grp := 0, pName := pName, len := NomLen, MemType := MemType, Option := 0, pCpyData := 0);
					
					IF _doCreate.status = ERR_OK THEN
						
						_wStep := 3;
						
					ELSIF _doCreate.status <> ERR_FUB_BUSY THEN
						
						_wStep := 0;
						
					END_IF

					Status := _doCreate.status;

				3: // Info erneut einlesen
						
					_doInfo(enable := TRUE, pName := pName);
					
					IF _doInfo.status = ERR_OK THEN
						
						doId 	:= _doInfo.ident;
						doMem 	:= _doInfo.pDatObjMem;
						doLen 	:= _doInfo.len;
							
						Status := KG_INFO_DO_NEW;
							
						_xReady := TRUE;
						
						_wStep := 0;
							
					ELSIF _doInfo.status <> ERR_FUB_BUSY THEN
						
						Status := _doInfo.status;
						_wStep := 0;
						
					ELSE

						Status := _doInfo.status;

					END_IF
					
				ELSE
					
					_wStep := 0;
					Status := ERR_OK;
				
			END_CASE
			
			UNTIL
			
			Status <> ERR_OK OR _xReady
			
		END_REPEAT
		
	ELSE
		
		_wStep := 0;
		
		Status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
	
	
END_FUNCTION_BLOCK