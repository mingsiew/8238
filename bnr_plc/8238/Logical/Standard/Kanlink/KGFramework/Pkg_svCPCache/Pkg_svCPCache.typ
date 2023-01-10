(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Package: Pkg_svCPCache
 * File: Pkg_svCPCache.typ
 * Author: hunholz
 * Created: March 29, 2012
 ********************************************************************
 * Data types of package Pkg_svCPCache
 ********************************************************************)

TYPE
	svCPCache_Relation_Typ : 	STRUCT 
		dtTimestamp : DATE_AND_TIME;
		sCategory : STRING[11];
		wProgramNo : UINT;
	END_STRUCT;
	IFsvCPCache_In_Typ : 	STRUCT 
		wCmd : UINT;
		wReqUseDB : UINT;
		sReqCategory : STRING[11];
		utfReqCategoryName : WSTRING[31];
		wReqProgramNo : UINT;
		wReqLoadrate : UINT;
		rReqSoilfactor : REAL;
		wReqColidxFor : UINT;
		wReqColidxBack : UINT;
		wSetOffset : UINT;
		sImpDevice : STRING[31];
		sImpPath : STRING[31];
	END_STRUCT;
	IFsvCPCache_Out_Typ : 	STRUCT 
		xReady : BOOL;
		xListReady : BOOL;
		wCmdResponse : UINT;
		wCntRelations : UINT;
		wRespFromDB : UINT;
		utfRespCategoryName : WSTRING[31];
		rRespSoilFactor : REAL;
		wRespColidxFor : UINT;
		wRespColidxBack : UINT;
		wRespLoadrate : UINT;
		wRespProgramNo : UINT;
		utfRespProgramName : WSTRING[31];
		wListOffset : UINT;
		wListCnt : UINT;
		sListCategory : ARRAY[1..SVCPCACHE_CNT_LISTRELATIONS]OF STRING[11];
		utfListCategoryname : ARRAY[1..SVCPCACHE_CNT_LISTRELATIONS]OF WSTRING[31];
		wListProgramNo : ARRAY[1..SVCPCACHE_CNT_LISTRELATIONS]OF UINT;
		utfListProgramName : ARRAY[1..SVCPCACHE_CNT_LISTRELATIONS]OF WSTRING[31];
	END_STRUCT;
	IFsvCPCache_Typ : 	STRUCT 
		In : IFsvCPCache_In_Typ;
		Out : IFsvCPCache_Out_Typ;
	END_STRUCT;
	svCPCacheStatAd_Typ : 	STRUCT 
		xReady : BOOL;
		sPkgVersion : STRING[10];
	END_STRUCT;
END_TYPE
