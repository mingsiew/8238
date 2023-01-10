(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: mnParamLib
 * File: mnParam_datetimetoa.st
 * Author: hunholz
 * Created: August 02, 2011
 ********************************************************************
 * Implementation of library mnParamLib
 ********************************************************************) 

(* Wandelt Datum Zeit in ISO String *)
FUNCTION_BLOCK mnParam_datetimetoa
	
	brsmemset(ADR(_s2dig),0,SIZEOF(_s2dig));
	_b2dig ACCESS ADR(_s2dig);
	
	DT_TO_DTStructure(DT1 := dtTimestamp, ADR(_dtStruc));
	
	brsitoa(_dtStruc.year, ADR(sDateTime));
	
	brsstrcat(ADR(sDateTime), ADR('-'));
	
	_b2dig[0] := (_dtStruc.month / 10) + 16#30;
	_b2dig[1] := (_dtStruc.month MOD 10) + 16#30;
	
	brsstrcat(ADR(sDateTime), ADR(_s2dig));
	brsstrcat(ADR(sDateTime), ADR('-'));
	
	_b2dig[0] := (_dtStruc.day / 10) + 16#30;
	_b2dig[1] := (_dtStruc.day MOD 10) + 16#30;
	
	brsstrcat(ADR(sDateTime), ADR(_s2dig));
	brsstrcat(ADR(sDateTime), ADR('T'));
	
	_b2dig[0] := (_dtStruc.hour / 10) + 16#30;
	_b2dig[1] := (_dtStruc.hour MOD 10) + 16#30;
	
	brsstrcat(ADR(sDateTime), ADR(_s2dig));
	brsstrcat(ADR(sDateTime), ADR(':'));

	_b2dig[0] := (_dtStruc.minute / 10) + 16#30;
	_b2dig[1] := (_dtStruc.minute MOD 10) + 16#30;
	
	brsstrcat(ADR(sDateTime), ADR(_s2dig));
	brsstrcat(ADR(sDateTime), ADR(':'));

	_b2dig[0] := (_dtStruc.second / 10) + 16#30;
	_b2dig[1] := (_dtStruc.second MOD 10) + 16#30;
	
	brsstrcat(ADR(sDateTime), ADR(_s2dig));

END_FUNCTION_BLOCK
