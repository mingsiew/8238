(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: _actFillCPList.st
 * Author: hunholz
 * Created: March 30, 2012
 ********************************************************************
 * Implementation of program svCPCache
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actFillCPList:
	
	IF _xCacheReady AND SVCPCACHE_CNT_LISTRELATIONS > 0 THEN

		IF SVCPCACHE_CNT_RELATIONS > SVCPCACHE_CNT_LISTRELATIONS THEN
			
			IFsvCPCache.Out.wListOffset := MIN(IFsvCPCache.Out.wListOffset, SVCPCACHE_CNT_RELATIONS-SVCPCACHE_CNT_LISTRELATIONS);
			
		ELSE
			
			IFsvCPCache.Out.wListOffset := 0;
			
		END_IF
		
		IFsvCPCache.Out.wListCnt := 0;
		brsmemset(ADR(IFsvCPCache.Out.sListCategory), 0, SIZEOF(IFsvCPCache.Out.sListCategory));
		brsmemset(ADR(IFsvCPCache.Out.utfListCategoryname), 0, SIZEOF(IFsvCPCache.Out.utfListCategoryname));
		brsmemset(ADR(IFsvCPCache.Out.utfListProgramName), 0, SIZEOF(IFsvCPCache.Out.utfListProgramName));
		brsmemset(ADR(IFsvCPCache.Out.wListProgramNo), 0, SIZEOF(IFsvCPCache.Out.wListProgramNo));
		
		FOR _wfcli := 1 TO SVCPCACHE_CNT_LISTRELATIONS DO
	
			IF _wfcli + IFsvCPCache.Out.wListOffset <= SVCPCACHE_CNT_RELATIONS THEN
				
				IF _CPCache[_wfcli + IFsvCPCache.Out.wListOffset].dtTimeStamp > USINT_TO_DT(0) THEN
				
					IFsvCPCache.Out.sListCategory[_wfcli] := _CPCache[_wfcli + IFsvCPCache.Out.wListOffset].sCategory;
					IFsvCPCache.Out.wListProgramNo[_wfcli] := _CPCache[_wfcli + IFsvCPCache.Out.wListOffset].wProgramNo;
					IFsvCPCache.Out.utfListCategoryname[_wfcli] := _CPCache[_wfcli + IFsvCPCache.Out.wListOffset].utfCategoryName;
			
					FOR _wfclj := 1 TO IFmnParam.Out.Edit.wCntNamelist DO
						
						IF IFmnParam.Out.Edit.wNameListNo[_wfclj] = IFsvCPCache.Out.wListProgramNo[_wfcli] THEN
							IFsvCPCache.Out.utfListProgramName[_wfcli] := IFmnParam.Out.Edit.utfNameListName[_wfclj];
							EXIT;
						END_IF
						
					END_FOR
					
					IFsvCPCache.Out.wListCnt := IFsvCPCache.Out.wListCnt + 1;
					
				ELSE
					
					EXIT;
					
				END_IF
				
			END_IF
			
		END_FOR	
		
	END_IF
	
END_ACTION