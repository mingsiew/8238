(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: GetArrayPV.st
 * Author: hunholz
 * Created: July 27, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Liefert PV-Adresse mit Indizes *)
FUNCTION GetArrayPV

	GetArrayPV := 0;
	
	IF pPV = 0  OR pPVFilled = 0 OR pStructRoot = 0 THEN
		GetArrayPV := 1;
		RETURN;
	END_IF

	_GetArrayPV ACCESS pPVFilled;
	_GetArrayPV := '';
	
	brsstrcpy(pPVFilled, pStructRoot);
	brsstrcat(pPVFilled, pPV);
	
	_p := FIND(_GetArrayPV, '[]') ;
	IF _p <> 0 THEN
		brsitoa(idx1, ADR(_sIndex));
		_GetArrayPV := INSERT(_GetArrayPV, _sIndex, _p);
		_p := FIND(_GetArrayPV, '[]') ;
		IF _p <> 0 THEN
			brsitoa(idx2, ADR(_sIndex));
			_GetArrayPV := INSERT(_GetArrayPV, _sIndex, _p);
			_p := FIND(_GetArrayPV, '[]') ;
			IF _p <> 0 THEN
				brsitoa(idx3, ADR(_sIndex));
				_GetArrayPV := INSERT(_GetArrayPV, _sIndex, _p);
				_p := FIND(_GetArrayPV, '[]') ;
				IF _p <> 0 THEN
					brsitoa(idx4, ADR(_sIndex));
					_GetArrayPV := INSERT(_GetArrayPV, _sIndex, _p);
				END_IF
			END_IF
		END_IF
	END_IF	

END_FUNCTION
