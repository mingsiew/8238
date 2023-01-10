(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTxt
 * File: _utfReplaceCtrl.st
 * Author: hunholz
 * Created: June 22, 2012
 ********************************************************************
 * Implementation of program mnTxt
 ********************************************************************) 

(* Replace Linefeed *)
FUNCTION_BLOCK _utfReplaceCtrl
	
	wStatus := ERR_OK;
	
	IF pInput = 0 OR pOutput = 0 THEN
		wStatus := KG_ERR_NULPOINTER;
		RETURN;
	END_IF
	
	IF xWSTRING THEN
	
		IF lSizeOutput < 2 THEN
			
			wStatus := KG_ERR_WRONGSIZES;
			RETURN;
			
		END_IF
		
		_utfInput ACCESS pInput;
		
		IF (brwcslen(pInput) * 2) + 2 > MIN(lSizeOutput,2048) THEN
			
			brsmemcpy(pOutput,pInput,MIN(lSizeOutput,2048));
			_wChar1 ACCESS pOutput + (MIN(lSizeOutput,2048)-2);
			_wChar1 := 0;
			
		ELSE
			
			brwcscpy(pOutput, pInput);
			
		END_IF

		_utfOutput ACCESS pOutput;
		
		_pOutput := pOutput;
		
		REPEAT
		
			_lChar1 := brwcschr(_pOutput, 16#5C);
			_lChar2 := brwcschr(_pOutput, 16#6E);
		
			IF _lChar1 > 0 AND _lChar2 > 0 AND (_lChar1+2) = _lChar2 THEN
				
				_wChar1 ACCESS _lChar1;
				_wChar2 ACCESS _lChar2;
				
				_wChar1 := 16#0D;
				_wChar2 := 16#0A;
				
			ELSIF _lChar1 > 0 AND _lChar2 > 0 THEN
				
				IF _lChar1 < _lChar2 THEN
					_pOutput := _lChar1 + 2;
				ELSE
					_pOutput := _lChar2 + 2;
				END_IF
			
			END_IF
			
			UNTIL
			_lChar1 = 0 OR _lChar2 = 0
		END_REPEAT
		
	ELSE

		IF lSizeOutput = 0 THEN
			
			wStatus := KG_ERR_WRONGSIZES;
			RETURN;
			
		END_IF

		_sInput ACCESS pInput;

		_sOutput ACCESS pOutput;

		IF INT_TO_UDINT(LEN(_sInput) + 1)	> MIN(lSizeOutput,256) THEN

			brsmemcpy(pOutput,pInput,MIN(lSizeOutput,256));
			_bChar1 ACCESS pOutput + (MIN(lSizeOutput,256)-1);
			_bChar1 := 0;
			
		ELSE
			
			_sOutput := _sInput;			
			
		END_IF

		
		REPEAT
		
			_iPos := FIND(_sOutput,'\n');
		
			IF _iPos > 0 THEN
				
				_sOutput := REPLACE(_sOutput, '$R$N', 2, _iPos);
				
			END_IF
			
			UNTIL
			_iPos = 0
		END_REPEAT


	END_IF
	
END_FUNCTION_BLOCK