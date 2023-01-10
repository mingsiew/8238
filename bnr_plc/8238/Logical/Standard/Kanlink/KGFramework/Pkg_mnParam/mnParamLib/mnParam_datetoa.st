(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_datetoa.st
 * Author: hunholz
 * Created: Mar 23, 2012
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Wandelt Datum in ISO String *)
FUNCTION_BLOCK mnParam_datetoa
	
	brsmemset(ADR(_s2dig),0,SIZEOF(_s2dig));
	_b2dig ACCESS ADR(_s2dig);
	
	DT_TO_DTStructure(DT1 := dtTimestamp, ADR(_dtStruc));
	
	brsitoa(_dtStruc.year, ADR(sDate));
	
	brsstrcat(ADR(sDate), ADR('-'));
	
	_b2dig[0] := (_dtStruc.month / 10) + 16#30;
	_b2dig[1] := (_dtStruc.month MOD 10) + 16#30;
	
	brsstrcat(ADR(sDate), ADR(_s2dig));
	brsstrcat(ADR(sDate), ADR('-'));
	
	_b2dig[0] := (_dtStruc.day / 10) + 16#30;
	_b2dig[1] := (_dtStruc.day MOD 10) + 16#30;
	
	brsstrcat(ADR(sDate), ADR(_s2dig));

END_FUNCTION_BLOCK
