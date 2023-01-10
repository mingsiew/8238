(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _DefActContainer.st
 * Author: hunholz
 * Created: February 17, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Fülle ActContainer *)
FUNCTION_BLOCK _DefActContainer
	
	IF Enable THEN
		
		Status := ERR_OK;
		
		//=======================
		// Auf Nullpointer prüfen
		//=======================
		
		IF pIntern = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF
		
		_Intern ACCESS pIntern;
		
		IF _Intern.DataObjects.Adress.lContainer = 0 THEN
			Status := MNPARAM_STAT_NULLPOINTER;
			RETURN;
		END_IF

		_DoContainer ACCESS _Intern.DataObjects.Adress.lContainer;
		
		// Containerindex zulässig ?
		IF bContainerIdx > _Intern.DataObjects.MaxIndex.lContainer THEN

			Status := MNPARAM_STAT_CONTAINER_NOT_VALID;
			
			RETURN;
					
		END_IF

		// Datenobjekt- und Dateinamen ok?
		
		IF (brsstrcmp(ADR(_DoContainer.Container[bContainerIdx].sNameDataObj), ADR('')) = 0) OR (brsstrcmp(ADR(_DoContainer.Container[bContainerIdx].sNameCsv), ADR('')) = 0) THEN

			Status := MNPARAM_STAT_CONTAINER_NOT_VALID;
			
			RETURN;
			
		END_IF
		
		// Ist die Rootvariable bei indirekter Parametrierung OK ?
		
		IF _DoContainer.Container[bContainerIdx].bDirectParam = 0 AND (PV_xgetadr(ADR(_DoContainer.Container[bContainerIdx].sStrucRoot), ADR(_lPVadress), ADR(_lPVlen)) <> ERR_OK) THEN

			Status := MNPARAM_STAT_CONTAINER_NOT_VALID;
			
			RETURN;
			
		END_IF

		_Intern.ActContainer.siContainerID := _DoContainer.Container[bContainerIdx].siContainerID;
		
		_Intern.ActContainer.bDirect := _DoContainer.Container[bContainerIdx].bDirectParam;
		
		_Intern.ActContainer.wMinBound := _DoContainer.Container[bContainerIdx].wMinBound;
		_Intern.ActContainer.wDimension := _DoContainer.Container[bContainerIdx].wDimension;
		
		IF wInstanceIdx < _Intern.ActContainer.wMinBound THEN
			
			Status := MNPARAM_STAT_CONTINST_NOT_VALID;
			
			RETURN;
			
		END_IF
		
		IF _Intern.ActContainer.wDimension <= 1 AND wInstanceIdx > _Intern.ActContainer.wMinBound THEN

			Status := MNPARAM_STAT_CONTINST_NOT_VALID;
			
			RETURN;
			
		END_IF

		IF wInstanceIdx > (_Intern.ActContainer.wMinBound + _Intern.ActContainer.wDimension - 1) THEN

			Status := MNPARAM_STAT_CONTINST_NOT_VALID;
			
			RETURN;
			
		END_IF

		_Intern.ActContainer.wIndexIndirect := wInstanceIdx;
		
		IF _DoContainer.Container[bContainerIdx].bDirectParam = 0 THEN

			// Indirekte Parametrierung
			
			_wDimension := MAX(1,_Intern.ActContainer.wDimension);
			
			_Intern.ActContainer.lAdressStructRoot := _lPVadress;
			_Intern.ActContainer.lSizeStructRoot := _lPVlen;

			_Intern.ActContainer.sDoNameDef := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj,'d');
			_Intern.ActContainer.sDoNameDefNum := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj, 'Nd');
			_Intern.ActContainer.sDoNameDefString := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj, 'Sd');
			_Intern.ActContainer.sStrucRoot := _DoContainer.Container[bContainerIdx].sStrucRoot;
			
			_Intern.ActContainer.sIndex := '';
			IF (_Intern.ActContainer.wMinBound + _wDimension - 1) > 9999 AND  _Intern.ActContainer.wIndexIndirect  < 10000 THEN
				_Intern.ActContainer.sIndex := CONCAT(_Intern.ActContainer.sIndex,'0');
			END_IF
			IF (_Intern.ActContainer.wMinBound + _wDimension - 1) > 999 AND  _Intern.ActContainer.wIndexIndirect  < 1000 THEN
				_Intern.ActContainer.sIndex := CONCAT(_Intern.ActContainer.sIndex,'0');
			END_IF
			IF (_Intern.ActContainer.wMinBound + _wDimension - 1) > 99 AND  _Intern.ActContainer.wIndexIndirect  < 100 THEN
				_Intern.ActContainer.sIndex := CONCAT(_Intern.ActContainer.sIndex,'0');
			END_IF
			IF (_Intern.ActContainer.wMinBound + _wDimension - 1) > 9 AND  _Intern.ActContainer.wIndexIndirect  < 10 THEN
				_Intern.ActContainer.sIndex := CONCAT(_Intern.ActContainer.sIndex,'0');
			END_IF
			
			_sIndex := UINT_TO_STRING(_Intern.ActContainer.wIndexIndirect);
			_Intern.ActContainer.sIndex := CONCAT(_Intern.ActContainer.sIndex,_sIndex);
			
			_Intern.ActContainer.sDoName := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj, _Intern.ActContainer.sIndex);
			
			_Intern.ActContainer.sDoNameNum := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj, _Intern.ActContainer.sIndex);
			_Intern.ActContainer.sDoNameNum := CONCAT(_Intern.ActContainer.sDoNameNum, 'N');
			
			_Intern.ActContainer.sDoNameString := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj, _Intern.ActContainer.sIndex);
			_Intern.ActContainer.sDoNameString := CONCAT(_Intern.ActContainer.sDoNameString, 'S');
					
			_Intern.ActContainer.sCsvName := CONCAT(_DoContainer.Container[bContainerIdx].sNameCsv, _Intern.ActContainer.sIndex);
			_Intern.ActContainer.sCsvName := CONCAT(_Intern.ActContainer.sCsvName, MNPARAM_FILESUFF);
					

		ELSE
			
			// Direkte Parametrierung

			_Intern.ActContainer.lAdressStructRoot := 0;
			_Intern.ActContainer.lSizeStructRoot := 0;

			_Intern.ActContainer.sDoName := '';
			_Intern.ActContainer.sDoNameDef := '';
			_Intern.ActContainer.sDoNameDefNum := '';
			_Intern.ActContainer.sDoNameDefString := '';
			_Intern.ActContainer.sStrucRoot := '';
			
			_Intern.ActContainer.sDoNameNum := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj, 'N');
			_Intern.ActContainer.sDoNameString := CONCAT(_DoContainer.Container[bContainerIdx].sNameDataObj, 'S');
			
			_Intern.ActContainer.sCsvName := CONCAT(_DoContainer.Container[bContainerIdx].sNameCsv, MNPARAM_FILESUFF);
			
		END_IF
		
		_Intern.ActContainer.lCountParamNum := _DoContainer.Container[bContainerIdx].lCountNum;
		_Intern.ActContainer.lCountParamString := _DoContainer.Container[bContainerIdx].lCountString;

	ELSE
	
		Status := ERR_FUB_ENABLE_FALSE;

	END_IF
	
END_FUNCTION_BLOCK