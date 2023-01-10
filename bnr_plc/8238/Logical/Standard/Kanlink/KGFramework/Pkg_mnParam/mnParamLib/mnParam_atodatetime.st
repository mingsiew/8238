(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_atodatetime.st
 * Author: hunholz
 * Created: July 25, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* String mit ISO-Zeitformat in DATE_AND_TIME wandeln *)
FUNCTION_BLOCK mnParam_atodatetime
	
	brsmemset(ADR(dtTimeStamp), 0, SIZEOF(dtTimeStamp));
	brsmemset(ADR(_DateTime), 0, SIZEOF(_DateTime));
	brsmemset(ADR(_sStr), 0, SIZEOF(_sStr));
	
	IF brsstrlen(pStr) > 23 THEN
		// String abschneiden
		brsmemcpy(ADR(_sStr), pStr, 23);
	ELSE
		brsstrcpy(ADR(_sStr), pStr);
	END_IF
	
	_wPositionInTime := 0;
	
	_wPositionInTime := FIND(_sStr, '-');
	IF (_wPositionInTime < 8) THEN
		_sSubString := LEFT(_sStr, _wPositionInTime);
		_DateTime.year := DINT_TO_UINT(atoi(ADR(_sSubString)));
	END_IF
	
	_sStr := DELETE(_sStr, _wPositionInTime, 1);
	
	_wPositionInTime := FIND(_sStr, '-');
	IF (_wPositionInTime < 8) THEN
		_sSubString := LEFT(_sStr, _wPositionInTime);
		_DateTime.month := DINT_TO_USINT(atoi(ADR(_sSubString)));
	END_IF
	
	_sStr := DELETE(_sStr, _wPositionInTime, 1);
	
	_wPositionInTime := FIND(_sStr, 'T');
	IF (_wPositionInTime < 8) THEN
		_sSubString := LEFT(_sStr, _wPositionInTime);
		_DateTime.day := DINT_TO_USINT(atoi(ADR(_sSubString)));
	END_IF
	
	_sStr := DELETE(_sStr, _wPositionInTime, 1);
	
	_wPositionInTime := FIND(_sStr, ':');
	IF (_wPositionInTime < 8) THEN
		_sSubString := LEFT(_sStr, _wPositionInTime);
		_DateTime.hour := DINT_TO_USINT(atoi(ADR(_sSubString)));
	END_IF
	
	_sStr := DELETE(_sStr, _wPositionInTime, 1);
	
	_wPositionInTime := FIND(_sStr, ':');
	IF (_wPositionInTime < 8) THEN
		_sSubString := LEFT(_sStr, _wPositionInTime);
		_DateTime.minute := DINT_TO_USINT(atoi(ADR(_sSubString)));
	END_IF
	
	_sStr := DELETE(_sStr, _wPositionInTime, 1);

	_DateTime.second := DINT_TO_USINT(atoi(ADR(_sStr)));

	IF _DateTime.day = 0 OR _DateTime.month = 0 OR _DateTime.year = 0 THEN
	
		status := 1;
	
	ELSE
	
		dtTimeStamp := DTStructure_TO_DT(ADR(_DateTime));
		
	END_IF

	
END_FUNCTION_BLOCK
