(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGlibMsg
 * File: msgInsertMsgLine.st
 * Author: hunholz
 * Created: May 30, 2011
 * Changed: June 15, 2011
 ********************************************************************
 * Implementation of library KGlibMsg
 ********************************************************************) 

(* Ein- oder Ausfügen von Meldungen *)
FUNCTION_BLOCK msgInsertMsgLine

	TestCnt := TestCnt + 1;

	Changed := FALSE;

	// VAR Ref MsgList of MsgList_Typ[0..MSGLISTMAX]
	// Constant UINT MSGLISTMAX = 39
	// VAR_INPUT USINT Class belongs to KGlibMsg
	// Constant USINT MSG_CLASS_INTFAULT = 0
	// VAR_INPUT UDINT AdrIntFaultList, AdrCntIntFault
	IF Class = MNMSG_CLASS_INTFAULT AND AdrIntFaultList <> 0 AND AdrCntIntFault <> 0 THEN
		MsgList ACCESS AdrIntFaultList;
		bCntList ACCESS AdrCntIntFault;
	ELSIF Class = MNMSG_CLASS_EXTFAULT AND AdrExtFaultList <> 0 AND AdrCntExtFault <> 0 THEN
		MsgList ACCESS AdrExtFaultList;
		bCntList ACCESS AdrCntExtFault;
	ELSIF Class = MNMSG_CLASS_WARNING AND AdrWarnList <> 0 AND AdrCntWarn <> 0 THEN
		MsgList ACCESS AdrWarnList;
		bCntList ACCESS AdrCntWarn;
	ELSIF Class = MNMSG_CLASS_INFO AND AdrInfoList <> 0 AND AdrCntInfo <> 0 THEN
		MsgList ACCESS AdrInfoList;
		bCntList ACCESS  AdrCntInfo;
	ELSIF Class = MNMSG_CLASS_MAINTENANCE AND AdrMaintList <> 0 THEN
		MsgList ACCESS AdrMaintList;
		bCntList ACCESS AdrCntMaint;
	ELSE
		RETURN;
	END_IF

	xFound := FALSE;

	// VAR Ref USINT bCntList
	// VAR Ref MsgList of MsgList_Typ[0..MSGLISTMAX]
	// Constant UINT MSGLISTMAX = 39

	IF bCntList > 0 THEN

		FOR i := 0 TO bCntList-1	DO
			IF MsgList[i].wFunction_ID = MsgLine.wFunction_ID AND MsgList[i].wMsgNumber = MsgLine.wMsgNumber AND MsgList[i].bInstance = MsgLine.bInstance THEN

				// DINT brsmemcmp 'compares memory areas' belongs to library AsBrStr
				// VAR_INPUT MsgLine of MsgList_Typ
				IF Insert  AND brsmemcmp(ADR(MsgList[i]),ADR(MsgLine),SIZEOF(MsgLine)) <> 0 THEN 
					MsgList[i] := MsgLine; 
					Changed := TRUE;
				END_IF
				
				xFound := TRUE;
				EXIT;
				
			END_IF	
			
		END_FOR
	
	END_IF

	
	IF Insert THEN	// xInsert ?
		// Hinzufügen
			
		IF NOT xFound AND bCntList <= MNMSG_MAX_MSGLIST THEN
			MsgList[bCntList] := MsgLine;
			bCntList := bCntList + 1;
			Changed := TRUE;
		END_IF

	ELSE
		// Eintrag entfernen
		// UDINT brsmemset 'fills the memory area with specific values'
		// VAR Ref USINT bCntList
		IF xFound THEN
			
			brsmemset(ADR(MsgList[MNMSG_MAX_MSGLIST]),0,SIZEOF(MsgList[MNMSG_MAX_MSGLIST]));
			
			FOR j := i TO bCntList-1 DO
				IF j <> MNMSG_MAX_MSGLIST THEN
					MsgList[j] := MsgList[j+1];
				END_IF
			END_FOR
		
			bCntList := bCntList - 1;
			
			Changed := TRUE;
			
		END_IF
		
	END_IF		
	
END_FUNCTION_BLOCK
