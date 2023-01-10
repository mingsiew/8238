(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _GetRights.st
 * Author: hunholz
 * Created: February 20, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Ermittelt Lese- und Schreibrecht *)
FUNCTION_BLOCK _GetRights
	
	IF Enable THEN
	
		Status := ERR_OK;
		
		bWriteAccess := 0;
		bReadAccess := 0;
		
		IF lPtrLogicStruct = 0 THEN
			
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		
		END_IF
		
		_DoLogStruc ACCESS lPtrLogicStruct;
		
		IF siWriteAccess >= 0 THEN
			
			bWriteAccess := SINT_TO_USINT(siWriteAccess);
			
		ELSE
			
			_wLogIdx := wReference;
			_xReady := FALSE;
			_bSearchIt := 0;
			
			REPEAT
				
				IF _wLogIdx <= wMaxIdxLogicStruct  AND _wLogIdx > 0 THEN
					
					IF _DoLogStruc.LogicalStruct[_wLogIdx].siWriteAccess >= 0 THEN
						
						// Gültiges Recht gefunden
						bWriteAccess := SINT_TO_USINT(_DoLogStruc.LogicalStruct[_wLogIdx].siWriteAccess);
						_xReady := TRUE;
						
					ELSE
						
						IF _DoLogStruc.LogicalStruct[_wLogIdx].iReferenz > 0 THEN
	
							_wLogIdx := INT_TO_UINT(_DoLogStruc.LogicalStruct[_wLogIdx].iReferenz);
							_bSearchIt := _bSearchIt + 1;
							
							// Wenn maximale Suchtiefe erreicht, dann abbrechen
							_xReady := _bSearchIt > 6;
							
						ELSE
							
							// Kein Recht definiert und Referenz verweist auf Container, abbrechen
							_xReady := TRUE;
							
						END_IF
						
					END_IF
					
				ELSE
					
					// Referenz ist ungültig, abbrechen
					_xReady := TRUE;
					
				END_IF
				
				UNTIL
					_xReady
			END_REPEAT
			
		END_IF
		
		IF siReadAccess >= 0 THEN
			
			bReadAccess := SINT_TO_USINT(siReadAccess);
			
		ELSE
	
			_wLogIdx := wReference;
			_xReady := FALSE;
			_bSearchIt := 0;
			
			REPEAT
				
				IF _wLogIdx <= wMaxIdxLogicStruct  AND _wLogIdx > 0 THEN
					
					IF _DoLogStruc.LogicalStruct[_wLogIdx].siVisibleAccess >= 0 THEN
						
						// Gültiges Recht gefunden
						bReadAccess := SINT_TO_USINT(_DoLogStruc.LogicalStruct[_wLogIdx].siVisibleAccess);
						_xReady := TRUE;
						
					ELSE
						
						IF _DoLogStruc.LogicalStruct[_wLogIdx].iReferenz > 0 THEN
	
							_wLogIdx := INT_TO_UINT(_DoLogStruc.LogicalStruct[_wLogIdx].iReferenz);
							_bSearchIt := _bSearchIt + 1;
							
							// Wenn maximale Suchtiefe erreicht, dann abbrechen
							_xReady := _bSearchIt > 6;
							
						ELSE
							
							// Kein Recht definiert und Referenz verweist auf Container, abbrechen
							_xReady := TRUE;
							
						END_IF
						
					END_IF
					
				ELSE
					
					// Referenz ist ungültig, abbrechen
					_xReady := TRUE;
					
				END_IF
				
				UNTIL
				_xReady
			END_REPEAT
	
		END_IF

	ELSE
		
		Status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
		
END_FUNCTION_BLOCK