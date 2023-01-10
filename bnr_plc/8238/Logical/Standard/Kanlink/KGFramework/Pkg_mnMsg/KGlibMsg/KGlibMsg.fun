(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGlibMsg
 * File: KGlibMsg.fun
 * Author: hunholz
 * Created: May 30, 2011
 * Changed: June 15, 2011
 ********************************************************************
 * Functions and function blocks of library KGlibMsg
 ********************************************************************)

FUNCTION_BLOCK msgBinSearchCfgList (*Index der Meldung in der Meldungskonfiguration suchen*)
	VAR_INPUT
		MsgCfgList : REFERENCE TO ARRAY[1..65535] OF MsgCfgLine_Typ;
		wCntMsgCfg : UINT;
		wFunctionID : UINT;
		wMsgNo : UINT;
		wInstance : UINT;
	END_VAR
	VAR_OUTPUT
		wMsgIdx : UINT;
		wStatus : UINT;
	END_VAR
	VAR
		dMin : DINT;
		dMax : DINT;
		dSearch : DINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK msgInsertMsgLine (*Ein- oder Ausfügen von Meldungen*)
	VAR_INPUT
		AdrIntFaultList : UDINT;
		AdrExtFaultList : UDINT;
		AdrWarnList : UDINT;
		AdrInfoList : UDINT;
		AdrMaintList : UDINT;
		AdrCntIntFault : UDINT;
		AdrCntExtFault : UDINT;
		AdrCntWarn : UDINT;
		AdrCntInfo : UDINT;
		AdrCntMaint : UDINT;
		MsgLine : MsgList_Typ;
		Insert : BOOL;
		Class : USINT;
	END_VAR
	VAR_OUTPUT
		Changed : BOOL;
	END_VAR
	VAR
		MsgList : REFERENCE TO ARRAY[0..MNMSG_MAX_MSGLIST] OF MsgList_Typ;
		bCntList : REFERENCE TO USINT;
		xFound : BOOL;
		i : UINT;
		j : UINT;
		TestCnt : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK msgBinSearchTxtLine (*TODO: Add your comment here*)
	VAR_INPUT
		MsgTxtList : REFERENCE TO ARRAY[1..65535] OF MsgTxtLine_Typ;
		wCntMsgTxt : UINT;
		wFunctionID : UINT;
		wNumber : UINT;
		wInstance : UINT := 0;
		bTupel : USINT := 3;
	END_VAR
	VAR_OUTPUT
		wMsgPos : UINT;
		wStatus : UINT;
	END_VAR
	VAR
		xRepeat : BOOL := FALSE;
		xPosFound : BOOL := FALSE;
		xPosFoundLeft : BOOL := FALSE;
		xPosFoundRight : BOOL := FALSE;
		wPos : UINT;
		wPosMin : UINT;
		wPosMax : UINT;
		wPosBeg : UINT;
		wPosEnd : UINT;
		wPosMinLeft : UINT;
		wPosMaxLeft : UINT;
		wPosBegLeft : UINT;
		wPosMinRight : UINT;
		wPosMaxRight : UINT;
		wPosEndRight : UINT;
		wCnt : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK msgBinSearchHelpTxtLine (*TODO: Add your comment here*)
	VAR_INPUT
		MsgHelpTxtList : REFERENCE TO ARRAY[1..65535] OF MsgHelpTxtLine_Typ;
		wCntMsgHelpTxt : UINT;
		wFunctionID : UINT;
		wNumber : UINT;
		wInstance : UINT := 0;
		bTupel : USINT := 3;
	END_VAR
	VAR_OUTPUT
		wMsgPos : UINT;
		wStatus : UINT;
	END_VAR
	VAR
		xRepeat : BOOL := FALSE;
		xPosFound : BOOL := FALSE;
		xPosFoundLeft : BOOL := FALSE;
		xPosFoundRight : BOOL := FALSE;
		wPos : UINT;
		wPosMin : UINT;
		wPosMax : UINT;
		wPosBeg : UINT;
		wPosEnd : UINT;
		wPosMinLeft : UINT;
		wPosMaxLeft : UINT;
		wPosBegLeft : UINT;
		wPosMinRight : UINT;
		wPosMaxRight : UINT;
		wPosEndRight : UINT;
		wCnt : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK msgReplSubStr (*TODO: Add your comment here*)
	VAR_INPUT
		utfStr : REFERENCE TO WSTRING[255];
		utfSubStr : REFERENCE TO WSTRING[255];
		utfStrToReplWith : REFERENCE TO WSTRING[255];
		utfStrResult : REFERENCE TO WSTRING[255];
	END_VAR
	VAR_OUTPUT
		wStatus : UINT;
		wMatched : UINT;
	END_VAR
	VAR
		utfStrFirst : WSTRING[1];
		utfStrSecond : WSTRING[1];
		lChrPosStr : UDINT;
		lChrPosSubStr : UDINT;
		xCat : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK msgNextChrPos (*TODO: Add your comment here*)
	VAR_INPUT
		utfStr : REFERENCE TO WSTRING[255];
		utfChr : WSTRING[1];
		lStartPos : UDINT;
	END_VAR
	VAR_OUTPUT
		lChrPos : UDINT;
		wStatus : UINT;
	END_VAR
	VAR
		_utfChr : WSTRING[1];
		_lChrPos : UDINT;
		_lUtfLen : UDINT;
	END_VAR
END_FUNCTION_BLOCK
