(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_GetContainerOfParamNum.st
 * Author: hunholz
 * Created: July 27, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* ContainerID ermitteln und Array-Grenzen *)
FUNCTION_BLOCK mnParam_GetContainerOfParamNum
	
	IF enable THEN
	
		status := 0;
		brsmemset(ADR(wMinBound), 0, SIZEOF(wMinBound));
		brsmemset(ADR(wDimension), 0, SIZEOF(wDimension));
		wCountArray := 0;
		iContainer := 127;
		
		IF pLogicStructs = 0 OR pParamNum = 0 THEN
			
			status := 1;
			RETURN;
			
		END_IF
		
		_LS ACCESS pLogicStructs;
		_PN ACCESS pParamNum;
		
		IF _PN.wReferenz = 0 OR _PN.wReferenz > wMaxIdxLogicStructs THEN
		
			status := 2;
			RETURN;
			
		END_IF
		
		_bMaxCycle := 0;
		_iIdxLS := UINT_TO_INT(_PN.wReferenz);
		
		IF _PN.wDimension > 0 THEN
			wCountArray := 1;
			wDimension[1] := _PN.wDimension;
			wMinBound[1] := _PN.wMinBound;
		END_IF
		
		IF _LS[_iIdxLS].wDimension > 0 THEN
	
			wCountArray := wCountArray + 1;
	
			IF wCountArray > 1 THEN
				FOR _i := 2 TO wCountArray DO
					wDimension[wCountArray - _i + 2] := wDimension[wCountArray - _i + 1];
					wMinBound[wCountArray - _i + 2] := wMinBound[wCountArray - _i + 1];
				END_FOR
			END_IF
	
			wDimension[1] := _LS[_iIdxLS].wDimension;
			wMinBound[1] := _LS[_iIdxLS].wMinBound;
	
		END_IF	
		
		REPEAT
	
			IF _LS[_iIdxLS].iReferenz > 0 THEN
				
				IF INT_TO_UINT(_LS[_iIdxLS].iReferenz) > wMaxIdxLogicStructs THEN
					status := 10;
					RETURN;
				END_IF
				
				_iIdxLS := _LS[_iIdxLS].iReferenz;
			
				IF _LS[_iIdxLS].wDimension > 0 THEN
				
					IF wCountArray >= 4 THEN
						status := 3;
						RETURN;
					END_IF
				
					wCountArray := wCountArray + 1;
	
					IF wCountArray > 1 THEN
						FOR _i := 2 TO wCountArray DO
							wDimension[wCountArray - _i + 2] := wDimension[wCountArray - _i + 1];
							wMinBound[wCountArray - _i + 2] := wMinBound[wCountArray - _i + 1];
						END_FOR
					END_IF
	
					wDimension[1] := _LS[_iIdxLS].wDimension;
					wMinBound[1] := _LS[_iIdxLS].wMinBound;
				
				END_IF	
			
				_bMaxCycle := _bMaxCycle + 1;
			
			END_IF	
			
			IF _bMaxCycle >= 30 THEN
				status := 4;
				RETURN;
			END_IF
			
			IF _LS[_iIdxLS].iReferenz <= 0 THEN
				iContainer := _LS[_iIdxLS].iReferenz;
				RETURN;
			END_IF		
			
		UNTIL
			FALSE
		END_REPEAT

	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
		
END_FUNCTION_BLOCK
