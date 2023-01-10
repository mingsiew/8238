(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _LimParam.st
 * Author: hunholz
 * Created: June 12, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Parameter begrenzen *)
FUNCTION_BLOCK _LimParam
	
	IF pParamNum = 0 OR pCsvNumRow = 0 THEN
		
		RETURN;

	END_IF
	
	_ParamNum ACCESS pParamNum;
	_CsvNumRow ACCESS pCsvNumRow;
	
	IF _CsvNumRow.bRowType = 10 THEN
		
		_CsvNumRow.diValue := LIMIT(_ParamNum.diMinValue, _CsvNumRow.diValue, _ParamNum.diMaxValue);
		
	ELSE
		
		_rValue ACCESS ADR(_CsvNumRow.diValue);
		_rMinValue ACCESS ADR(_ParamNum.diMinValue);
		_rMaxValue ACCESS ADR(_ParamNum.diMaxValue);
		
		_rValue := LIMIT(_rMinValue, _rValue, _rMaxValue);
		
	END_IF
	
END_FUNCTION_BLOCK