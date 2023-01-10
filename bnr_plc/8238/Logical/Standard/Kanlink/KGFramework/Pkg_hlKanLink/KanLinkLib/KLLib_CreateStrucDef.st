(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KanLinkLib
 * File: KLLib_CreateStrucDef.st
 * Author: hunholz
 * Created: February 23, 2012
 ********************************************************************
 * Implementation of library KanLinkLib
 ********************************************************************) 

(* Erzeuge eine Strukturdefinition zu einer Variablen *)

(* 1. Array müssen bei 0 beginnen
   2. Enumerationen und abgeleitete Datentypen sind verboten
*)
FUNCTION KLLib_CreateStrucDef
	
	KLLib_CreateStrucDef := ERR_OK;
	
	IF lPtrAdr = 0 OR lPtrLen = 0 THEN
		
		KLLib_CreateStrucDef := KLLIB_MSG_NULL_POINTER;
		RETURN;
		
	END_IF

	_sPvName := sRootName;

	_lAdr ACCESS lPtrAdr;
	_lLen ACCESS lPtrLen;

	IF _lAdr = 0 THEN
		KLLib_CreateStrucDef := KLLIB_MSG_NULL_POINTER;
		RETURN;
	END_IF

	IF sItemName <> '' THEN
		_sPvName := CONCAT(_sPvName, '.');
		_sPvName := CONCAT(_sPvName, sItemName);
	ELSE
		brsmemset(_lAdr, 0, _lLen);
	END_IF

	_wStatus := PV_ninfo(ADR(_sPvName), ADR(_lDataType), ADR(_lDataLen), ADR(_wDataDimension));
	
	IF _wStatus = ERR_OK THEN

		brsitoa(UINT_TO_DINT(_wDataDimension), ADR(_sValueDim));
		brsitoa(UDINT_TO_DINT(_lDataLen), ADR(_sValueLen));
		
		_wStatus := PV_xgetadr(ADR(_sPvName), ADR(_lDataAdr), ADR(_lDataLen));
		
		IF lDataAdr > 0 AND _lDataAdr > lDataAdr THEN
			
			brsitoa(UDINT_TO_DINT(_lDataAdr - lDataAdr), ADR(_sValueOffs));
			
		ELSE
			
			_sValueOffs := '0';
			
		END_IF
		
		CASE _lDataType OF

			0:  // Struktur
				
				_sLine := 'STRUC$T';
				_sLine := CONCAT(_sLine, sItemName);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueLen);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueOffs);
				_sLine := CONCAT(_sLine, '$T1');
			
				_wStatus := KLLib_WriteStrucDefLine(lPtrLine := ADR(_sLine), lPtrAdr := lPtrAdr, lPtrLen := lPtrLen);
				
				IF _wStatus <> ERR_OK THEN

					KLLib_CreateStrucDef := _wStatus;
					RETURN;
					
				END_IF

				// Die einzelnen Elemente der Struktur ermitteln
				
				FOR _i := 1 TO _wDataDimension DO

					_wStatus := PV_item(ADR(_sPvName), _i-1, ADR(_sItemName));
					
					IF _wStatus = ERR_OK THEN
						
						// Rekursion mit dem Strukturelement
						
						_wStatus := KLLib_CreateStrucDef(lPtrAdr := lPtrAdr, lPtrLen := lPtrLen, sRootName := _sPvName, sItemName := _sItemName, lDataAdr := _lDataAdr);
						
						IF _wStatus <> ERR_OK THEN
							KLLib_CreateStrucDef := _wStatus;
							RETURN;
						END_IF							
						
					ELSE
						KLLib_CreateStrucDef := _wStatus;
						RETURN;
					END_IF
					
				END_FOR
			
				_sLine := 'ENDSTRUC';

				_wStatus := KLLib_WriteStrucDefLine(lPtrLine := ADR(_sLine), lPtrAdr := lPtrAdr, lPtrLen := lPtrLen);
				
				IF _wStatus <> ERR_OK THEN

					KLLib_CreateStrucDef := _wStatus;
					RETURN;
					
				END_IF

			15:	// Array einer Struktur
				
				_sLine := 'STRUC$T';
				_sLine := CONCAT(_sLine, sItemName);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueLen);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueOffs);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueDim);

				_wStatus := KLLib_WriteStrucDefLine(lPtrLine := ADR(_sLine), lPtrAdr := lPtrAdr, lPtrLen := lPtrLen);
				
				IF _wStatus <> ERR_OK THEN

					KLLib_CreateStrucDef := _wStatus;
					RETURN;
					
				END_IF

				// Um die Elemente der Struktur zu ermitteln wird PV_ninfo erneut mit einem Element des Array aufgerufen
				
				_sPvName := CONCAT(_sPvName,'[0]');
				
				_wStatus := PV_ninfo(ADR(_sPvName), ADR(_lDataType), ADR(_lDataLen), ADR(_wDataDimension));
				
				IF _wStatus = ERR_OK THEN
					
					// Die einzelnen Elemente der Struktur ermitteln

					FOR _i := 1 TO _wDataDimension DO

						_wStatus := PV_item(ADR(_sPvName), _i-1, ADR(_sItemName));
					
						IF _wStatus = ERR_OK THEN
						
							// Rekursion mit dem Strukturelement

							_wStatus := KLLib_CreateStrucDef(lPtrAdr := lPtrAdr, lPtrLen := lPtrLen, sRootName := _sPvName, sItemName := _sItemName, lDataAdr := _lDataAdr);
						
							IF _wStatus <> ERR_OK THEN
								KLLib_CreateStrucDef := _wStatus;
								RETURN;
							END_IF							
						
						ELSE
							KLLib_CreateStrucDef := _wStatus;
							RETURN;
						END_IF
					
					END_FOR
			
					_sLine := 'ENDSTRUC';

					_wStatus := KLLib_WriteStrucDefLine(lPtrLine := ADR(_sLine), lPtrAdr := lPtrAdr, lPtrLen := lPtrLen);
				
					IF _wStatus <> ERR_OK THEN

						KLLib_CreateStrucDef := _wStatus;
						RETURN;
					
					END_IF

				ELSE

					KLLib_CreateStrucDef := KLLIB_MSG_VAR_ERROR;
					RETURN;

				END_IF

			1..14,16..23:
				
				_sLine := CONCAT(_sType[_lDataType],'$T');
				_sLine := CONCAT(_sLine, sItemName);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueLen);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueOffs);
				_sLine := CONCAT(_sLine, '$T');
				_sLine := CONCAT(_sLine, _sValueDim);

				_wStatus := KLLib_WriteStrucDefLine(lPtrLine := ADR(_sLine), lPtrAdr := lPtrAdr, lPtrLen := lPtrLen);
				
				IF _wStatus <> ERR_OK THEN

					KLLib_CreateStrucDef := _wStatus;
					RETURN;
					
				END_IF
				
		END_CASE
		
	ELSE

		KLLib_CreateStrucDef := _wStatus;
		RETURN;

	END_IF
	
END_FUNCTION