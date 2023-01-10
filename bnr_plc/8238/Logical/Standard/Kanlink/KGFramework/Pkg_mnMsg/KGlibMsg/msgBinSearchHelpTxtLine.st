(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGlibMsg
 * File: msgBinSearchTxtLine.st
 * Author: kuehne
 * Created: November 29, 2011
 ********************************************************************
 * Implementation of library KGlibMsg
 ********************************************************************)

(* TODO: Add your comment here *)
FUNCTION_BLOCK msgBinSearchHelpTxtLine
	wStatus := MNMSG_STAT_NOTFOUND;
	wMsgPos := 65535;
	IF bTupel = 0 OR bTupel > 3 THEN
		RETURN;
	END_IF;
	IF bTupel = 1 THEN
		IF (wFunctionID < 1) OR (wCntMsgHelpTxt < 1) THEN
			RETURN;
		END_IF;
	END_IF;
	IF bTupel = 2 OR bTupel = 3 THEN
		IF (wFunctionID < 1) OR (wNumber < 1) OR (wCntMsgHelpTxt < 1) THEN
			RETURN;
		END_IF;
	END_IF;
	wPosMin := 0;
	wPosBeg := wPosMin;
	wPosEnd := wPosMin + wCntMsgHelpTxt - 1;
	IF wPosEnd = wPosBeg THEN
		CASE bTupel OF
			1:
				IF (MsgHelpTxtList[wPosBeg].wFunctionID = wFunctionID) THEN
					wMsgPos := wPosBeg;
					wStatus := ERR_OK;
					RETURN;
				ELSE
					RETURN;
				END_IF;
			2:
				IF (MsgHelpTxtList[wPosBeg].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosBeg].wNumber = wNumber) THEN
					wMsgPos := wPosBeg;
					wStatus := ERR_OK;
					RETURN;
				ELSE
					RETURN;
				END_IF;
			3:
				IF (MsgHelpTxtList[wPosBeg].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosBeg].wNumber = wNumber) AND ((MsgHelpTxtList[wPosBeg].wInstance = wInstance) OR (wInstance = 0)) THEN
					wMsgPos := wPosBeg;
					wStatus := ERR_OK;
					RETURN;
				ELSE
					RETURN;
				END_IF;
		END_CASE;
	END_IF;
	wPosMin := 1;
	wPosBeg := wPosMin;
	wPosMax := wPosMin + wCntMsgHelpTxt - 1;
	wPosEnd := wPosMin + wCntMsgHelpTxt - 1;
	wPos := (wPosMin + wPosMax) / 2;
	xPosFound := FALSE;
	WHILE NOT xPosFound DO
		IF ((wPos = (wPosBeg + 1)) OR (wPos = wPosBeg)) AND NOT xPosFound THEN
			wPos := wPosBeg;
			IF (MsgHelpTxtList[wPos].wFunctionID > wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID > wFunctionID) THEN
				wPos := wPosBeg + 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID > wFunctionID) THEN
				wPos := wPosBeg + 1;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID = wFunctionID) THEN
				wPos := wPosBeg + 1;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID < wFunctionID) THEN
				IF wPosEnd = (wPosBeg + 1) THEN
					wCnt := wPosBeg;
					WHILE MsgHelpTxtList[wCnt].wFunctionID < wFunctionID AND (wCnt < wPosEnd) DO
						wCnt := wCnt + 1;
					END_WHILE;
					wPos := wCnt;
				ELSE
					wPos := wPosBeg + 2;
					IF NOT (MsgHelpTxtList[wPos].wFunctionID = wFunctionID) THEN
						wCnt := wPosBeg;
						WHILE MsgHelpTxtList[wCnt].wFunctionID < wFunctionID AND (wCnt < wPosEnd) DO
							wCnt := wCnt + 1;
						END_WHILE;
						wPos := wCnt;
					END_IF;
				END_IF;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID > wFunctionID) THEN
				wPos := wPosBeg + 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID = wFunctionID) THEN
				wPos := wPosBeg + 0;
				xPosFound := TRUE;
			ELSE
				// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
				wCnt := wPosBeg;
				WHILE MsgHelpTxtList[wCnt].wFunctionID < wFunctionID AND (wCnt < wPosEnd) DO
					wCnt := wCnt + 1;
				END_WHILE;
				wPos := wCnt;
				xPosFound := TRUE;
			END_IF;
		END_IF;
		IF ((wPos = (wPosEnd - 1)) OR (wPos = wPosEnd)) AND NOT xPosFound THEN
			wPos := wPosEnd;
			IF (MsgHelpTxtList[wPos].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPos - 1].wFunctionID < wFunctionID) THEN
				wPos := wPosEnd;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID > wFunctionID) AND (MsgHelpTxtList[wPos - 1].wFunctionID < wFunctionID) THEN
				wPos := wPosEnd - 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID > wFunctionID) AND (MsgHelpTxtList[wPos - 1].wFunctionID = wFunctionID) THEN
				wPos := wPosEnd - 1;
				xPosFound := TRUE;
			(* ELSIF (MsgHelpTxtList[wPos].wFunctionID > wFunctionID) AND (MsgHelpTxtList[wPos - 1].wFunctionID > wFunctionID) THEN
				wPos := wPosEnd - 1;
				xPosFound := TRUE; *)
			ELSIF (MsgHelpTxtList[wPos].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPos - 1].wFunctionID < wFunctionID) THEN
				wPos := wPosEnd - 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPos - 1].wFunctionID = wFunctionID) THEN
				wPos := wPosEnd - 1;
				xPosFound := TRUE;
			ELSE
				// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
				wCnt := wPosBeg;
				WHILE MsgHelpTxtList[wCnt].wFunctionID < wFunctionID AND (wCnt < wPosEnd) DO
					wCnt := wCnt + 1;
				END_WHILE;
				wPos := wCnt;
				xPosFound := TRUE;
			END_IF;
		END_IF;
		IF NOT xPosFound THEN
			IF (MsgHelpTxtList[wPos].wFunctionID > wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID > wFunctionID) THEN
				wPosMax := wPos;
				wPos := (wPosMin + wPosMax) / 2;
				IF (wPosMax - wPos) = 0 THEN
					wCnt := wPosBeg;
					WHILE MsgHelpTxtList[wCnt].wFunctionID < wFunctionID AND (wCnt < wPosEnd) DO
						wCnt := wCnt + 1;
					END_WHILE;
					wPos := wCnt;
					xPosFound := TRUE;
				END_IF;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID < wFunctionID) THEN
				wPosMin := wPos;
				wPos := (wPosMin + wPosMax) / 2;
				IF (wPos - wPosMin) = 0 THEN
					wCnt := wPosBeg;
					WHILE MsgHelpTxtList[wCnt].wFunctionID < wFunctionID AND (wCnt < wPosEnd) DO
						wCnt := wCnt + 1;
					END_WHILE;
					wPos := wCnt;
					xPosFound := TRUE;
				END_IF;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID > wFunctionID) THEN
				xPosFound := TRUE;
				wPos := wPos + 1;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID = wFunctionID) THEN
				xPosFound := TRUE;
				wPos := wPos + 1;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID > wFunctionID) THEN
				xPosFound := TRUE;
				wPos := wPos;
			ELSIF (MsgHelpTxtList[wPos].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPos + 1].wFunctionID = wFunctionID) THEN
				xPosFound := TRUE;
				wPos := wPos;
			ELSE
				// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
				wCnt := wPosBeg;
				WHILE MsgHelpTxtList[wCnt].wFunctionID < wFunctionID AND (wCnt < wPosEnd) DO
					wCnt := wCnt + 1;
				END_WHILE;
				wPos := wCnt;
				xPosFound := TRUE;
			END_IF;
		END_IF;
	END_WHILE;
	IF MsgHelpTxtList[wPos].wFunctionID <> wFunctionID THEN
		wPosMin := wPosBeg;
		wPosMax := wPosEnd;
		wCnt := wPosBeg;
		WHILE MsgHelpTxtList[wCnt].wFunctionID <> wFunctionID AND (wCnt < wPosEnd) DO
			wCnt := wCnt + 1;
		END_WHILE;
		wPos := wCnt;
		xPosFound := TRUE;
	END_IF;
	IF bTupel = 1 THEN
		IF MsgHelpTxtList[wPos].wFunctionID = wFunctionID THEN
			wMsgPos := wPos;
			wStatus := ERR_OK;
			RETURN;
		ELSE
			RETURN;
		END_IF;
	END_IF;
	IF MsgHelpTxtList[wPos].wFunctionID = wFunctionID THEN
		//###DK2011Dec07
		wPosMinLeft := wPosMin;
		wPosMaxLeft := wPos;
		wPosBegLeft := (wPosMinLeft + wPosMaxLeft) / 2;
		xPosFoundLeft := FALSE;
		xRepeat := TRUE;
		WHILE (NOT xPosFoundLeft) AND xRepeat DO
			IF ((wPosBegLeft = (wPosBeg + 1)) OR (wPosBegLeft = wPosBeg)) AND (NOT xPosFoundLeft) AND xRepeat THEN
				wPosBegLeft := wPosBeg;
				IF (MsgHelpTxtList[wPosBegLeft].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosBegLeft + 1].wFunctionID = wFunctionID) THEN
					xPosFoundLeft := TRUE;
					xRepeat := FALSE;
				ELSIF (MsgHelpTxtList[wPosBegLeft].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPosBegLeft + 1].wFunctionID = wFunctionID) THEN
					wPosBegLeft := wPosBeg + 1;
					xPosFoundLeft := TRUE;
					xRepeat := FALSE;
				ELSE
					xPosFoundLeft := FALSE;
					xRepeat := FALSE;
				END_IF;
			END_IF;
			IF (NOT xPosFoundLeft) AND xRepeat THEN
				IF (MsgHelpTxtList[wPosBegLeft].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosBegLeft - 1].wFunctionID = wFunctionID) THEN
					wPosMaxLeft := wPosBegLeft;
					wPosBegLeft := (wPosMinLeft + wPosMaxLeft) / 2;
					IF (wPosMaxLeft - wPosBegLeft) = 0 THEN
						xPosFoundLeft := FALSE;
						xRepeat := FALSE;
					END_IF;
				ELSIF (MsgHelpTxtList[wPosBegLeft].wFunctionID < wFunctionID) AND (MsgHelpTxtList[wPosBegLeft - 1].wFunctionID < wFunctionID) THEN
					wPosMinLeft := wPosBegLeft;
					wPosBegLeft := (wPosMinLeft + wPosMaxLeft) / 2;
					IF (wPosMinLeft - wPosBegLeft) = 0 THEN
						xPosFoundLeft := FALSE;
						xRepeat := FALSE;
					END_IF;
				ELSIF (MsgHelpTxtList[wPosBegLeft].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosBegLeft - 1].wFunctionID < wFunctionID) THEN
					xPosFoundLeft := TRUE;
					xRepeat := FALSE;
				ELSE
					xPosFoundLeft := FALSE;
					xRepeat := FALSE;
				END_IF;
			END_IF;
		END_WHILE;
		//###DK2011Dec07
		//###DK2011Dec07
		wPosMinRight := wPos;
		wPosMaxRight := wPosMax;
		wPosEndRight := (wPosMinRight + wPosMaxRight) / 2;
		xPosFoundRight := FALSE;
		xRepeat := TRUE;
		WHILE (NOT xPosFoundRight) AND xRepeat DO
			IF ((wPosEndRight = (wPosEnd - 1)) OR (wPosEndRight = wPosEnd)) AND (NOT xPosFoundRight) AND xRepeat THEN
				wPosEndRight := wPosEnd;
				IF (MsgHelpTxtList[wPosEndRight].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosEndRight - 1].wFunctionID = wFunctionID) THEN
					xPosFoundRight := TRUE;
					xRepeat := FALSE;
				ELSIF (MsgHelpTxtList[wPosEndRight].wFunctionID > wFunctionID) AND (MsgHelpTxtList[wPosEndRight - 1].wFunctionID = wFunctionID) THEN
					wPosEndRight := wPosEnd - 1;
					xPosFoundRight := TRUE;
					xRepeat := FALSE;
				ELSE
					xPosFoundRight := FALSE;
					xRepeat := FALSE;
				END_IF;
			END_IF;
			IF (NOT xPosFoundRight) AND xRepeat THEN
				IF (MsgHelpTxtList[wPosEndRight].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosEndRight + 1].wFunctionID = wFunctionID) THEN
					wPosMinRight := wPosEndRight;
					wPosEndRight := (wPosMinRight + wPosMaxRight) / 2;
					IF (wPosMinRight - wPosEndRight) = 0 THEN
						xPosFoundRight := FALSE;
						xRepeat := FALSE;
					END_IF;
				ELSIF (MsgHelpTxtList[wPosEndRight].wFunctionID > wFunctionID) AND (MsgHelpTxtList[wPosEndRight + 1].wFunctionID > wFunctionID) THEN
					wPosMaxRight := wPosEndRight;
					wPosEndRight := (wPosMinRight + wPosMaxRight) / 2;
					IF (wPosMaxRight - wPosEndRight) = 0 THEN
						xPosFoundRight := FALSE;
						xRepeat := FALSE;
					END_IF;
				ELSIF (MsgHelpTxtList[wPosEndRight].wFunctionID = wFunctionID) AND (MsgHelpTxtList[wPosEndRight + 1].wFunctionID > wFunctionID) THEN
					xPosFoundRight := TRUE;
					xRepeat := FALSE;
				ELSE
					xPosFoundRight := FALSE;
					xRepeat := FALSE;
				END_IF;
			END_IF;
		END_WHILE;
		//###DK2011Dec07
		IF NOT xPosFoundLeft THEN
			wPosBeg := wPos;
			IF (wPosBeg - 1) >= wPosMin THEN
				IF MsgHelpTxtList[wPosBeg - 1].wFunctionID = wFunctionID THEN
					wPosBeg := wPosBeg - 1;
					xRepeat := TRUE;
				ELSE
					xRepeat := FALSE;
				END_IF;
			ELSE
				xRepeat := FALSE;
			END_IF;
			WHILE xRepeat DO
				IF (wPosBeg - 1) >= wPosMin THEN
					IF MsgHelpTxtList[wPosBeg - 1].wFunctionID = wFunctionID THEN
						wPosBeg := wPosBeg - 1;
						xRepeat := TRUE;
					ELSE
						xRepeat := FALSE;
					END_IF;
				ELSE
					xRepeat := FALSE;
				END_IF;
			END_WHILE;
		ELSE
			wPosBeg := wPosBegLeft;
		END_IF;
		IF NOT xPosFoundRight THEN
			wPosEnd := wPos;
			IF (wPosEnd + 1) <= (wPosMin + wCntMsgHelpTxt - 1) THEN
				IF MsgHelpTxtList[wPosEnd + 1].wFunctionID = wFunctionID THEN
					wPosEnd := wPosEnd + 1;
					xRepeat := TRUE;
				ELSE
					xRepeat := FALSE;
				END_IF;
			ELSE
				xRepeat := FALSE;
			END_IF;
			WHILE xRepeat DO
				IF (wPosEnd + 1) <= (wPosMin + wCntMsgHelpTxt - 1) THEN
					IF MsgHelpTxtList[wPosEnd + 1].wFunctionID = wFunctionID THEN
						wPosEnd := wPosEnd + 1;
						xRepeat := TRUE;
					ELSE
						xRepeat := FALSE;
					END_IF;
				ELSE
					xRepeat := FALSE;
				END_IF;
			END_WHILE;
		ELSE
			wPosEnd := wPosEndRight;
		END_IF;
	ELSE
		RETURN;
	END_IF;
	wPosMin := wPosBeg;
	wPosMax := wPosEnd;
	wPos := (wPosMin + wPosMax) / 2;
	xPosFound := FALSE;
	IF wPosMax = wPosBeg THEN
		wPos := wPosBeg;
		xPosFound := TRUE;
	END_IF;
	WHILE NOT xPosFound DO
		IF ((wPos = (wPosBeg + 1)) OR (wPos = wPosBeg)) AND NOT xPosFound THEN
			wPos := wPosBeg;
			IF (MsgHelpTxtList[wPos].wNumber > wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber > wNumber) THEN
				wPos := wPosBeg + 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber < wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber > wNumber) THEN
				wPos := wPosBeg + 1;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber < wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber = wNumber) THEN
				wPos := wPosBeg + 1;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber < wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber < wNumber) THEN
				IF wPosEnd = (wPosBeg + 1) THEN
					wCnt := wPosBeg;
					WHILE MsgHelpTxtList[wCnt].wNumber < wNumber AND (wCnt < wPosEnd) DO
						wCnt := wCnt + 1;
					END_WHILE;
					wPos := wCnt;
				ELSE
					wPos := wPosBeg + 2;
					IF NOT (MsgHelpTxtList[wPos].wNumber = wNumber) THEN
						wCnt := wPosBeg;
						WHILE MsgHelpTxtList[wCnt].wNumber < wNumber AND (wCnt < wPosEnd) DO
							wCnt := wCnt + 1;
						END_WHILE;
						wPos := wCnt;
					END_IF;
				END_IF;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber = wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber > wNumber) THEN
				wPos := wPosBeg + 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber = wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber = wNumber) THEN
				wPos := wPosBeg + 0;
				xPosFound := TRUE;
			ELSE
				// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
				wCnt := wPosBeg;
				WHILE MsgHelpTxtList[wCnt].wNumber < wNumber AND (wCnt < wPosEnd) DO
					wCnt := wCnt + 1;
				END_WHILE;
				wPos := wCnt;
				xPosFound := TRUE;
			END_IF;
		END_IF;
		IF ((wPos = (wPosEnd - 1)) OR (wPos = wPosEnd)) AND NOT xPosFound THEN
			wPos := wPosEnd;
			IF (MsgHelpTxtList[wPos].wNumber < wNumber) AND (MsgHelpTxtList[wPos - 1].wNumber < wNumber) THEN
				wPos := wPosEnd;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber > wNumber) AND (MsgHelpTxtList[wPos - 1].wNumber < wNumber) THEN
				wPos := wPosEnd - 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber > wNumber) AND (MsgHelpTxtList[wPos - 1].wNumber = wNumber) THEN
				wPos := wPosEnd - 1;
				xPosFound := TRUE;
			(* ELSIF (MsgHelpTxtList[wPos].wNumber > wNumber) AND (MsgHelpTxtList[wPos - 1].wNumber > wNumber) THEN
				wPos := wPosEnd - 1;
				xPosFound := TRUE; *)
			ELSIF (MsgHelpTxtList[wPos].wNumber = wNumber) AND (MsgHelpTxtList[wPos - 1].wNumber < wNumber) THEN
				wPos := wPosEnd - 0;
				xPosFound := TRUE;
			ELSIF (MsgHelpTxtList[wPos].wNumber = wNumber) AND (MsgHelpTxtList[wPos - 1].wNumber = wNumber) THEN
				wPos := wPosEnd - 1;
				xPosFound := TRUE;
			ELSE
				// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
				wCnt := wPosBeg;
				WHILE MsgHelpTxtList[wCnt].wNumber < wNumber AND (wCnt < wPosEnd) DO
					wCnt := wCnt + 1;
				END_WHILE;
				wPos := wCnt;
				xPosFound := TRUE;
			END_IF;
		END_IF;
		IF NOT xPosFound THEN
			IF (MsgHelpTxtList[wPos].wNumber > wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber > wNumber) THEN
				wPosMax := wPos;
				wPos := (wPosMin + wPosMax) / 2;
				IF (wPosMax - wPos) = 0 THEN
					wCnt := wPosBeg;
					WHILE MsgHelpTxtList[wCnt].wNumber < wNumber AND (wCnt < wPosEnd) DO
						wCnt := wCnt + 1;
					END_WHILE;
					wPos := wCnt;
					xPosFound := TRUE;
				END_IF;
			ELSIF (MsgHelpTxtList[wPos].wNumber < wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber < wNumber) THEN
				wPosMin := wPos;
				wPos := (wPosMin + wPosMax) / 2;
				IF (wPos - wPosMin) = 0 THEN
					wCnt := wPosBeg;
					WHILE MsgHelpTxtList[wCnt].wNumber < wNumber AND (wCnt < wPosEnd) DO
						wCnt := wCnt + 1;
					END_WHILE;
					wPos := wCnt;
					xPosFound := TRUE;
				END_IF;
			ELSIF (MsgHelpTxtList[wPos].wNumber < wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber > wNumber) THEN
				xPosFound := TRUE;
				wPos := wPos + 1;
			ELSIF (MsgHelpTxtList[wPos].wNumber < wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber = wNumber) THEN
				xPosFound := TRUE;
				wPos := wPos + 1;
			ELSIF (MsgHelpTxtList[wPos].wNumber = wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber > wNumber) THEN
				xPosFound := TRUE;
				wPos := wPos;
			ELSIF (MsgHelpTxtList[wPos].wNumber = wNumber) AND (MsgHelpTxtList[wPos + 1].wNumber = wNumber) THEN
				xPosFound := TRUE;
				wPos := wPos;
			ELSE
				// to be sure: implement a simple algorithm with linear time here to avoid unlimited repetition
				wCnt := wPosBeg;
				WHILE MsgHelpTxtList[wCnt].wNumber < wNumber AND (wCnt < wPosEnd) DO
					wCnt := wCnt + 1;
				END_WHILE;
				wPos := wCnt;
				xPosFound := TRUE;
			END_IF;
		END_IF;
	END_WHILE;
	IF MsgHelpTxtList[wPos].wNumber <> wNumber THEN
		wPosMin := wPosBeg;
		wPosMax := wPosEnd;
		wCnt := wPosBeg;
		WHILE MsgHelpTxtList[wCnt].wNumber <> wNumber AND (wCnt < wPosEnd) DO
			wCnt := wCnt + 1;
		END_WHILE;
		wPos := wCnt;
		xPosFound := TRUE;
	END_IF;
	IF MsgHelpTxtList[wPos].wNumber <> wNumber THEN
		RETURN;
	END_IF;
	IF wInstance = 0 OR bTupel = 2 THEN
		wMsgPos := wPos;
		wStatus := ERR_OK;
		RETURN;
	END_IF;
	wPosBeg := wPos;
	wPosEnd := wPos;
	IF (wPosBeg - 1) >= wPosMin THEN
		IF MsgHelpTxtList[wPosBeg - 1].wNumber = wNumber THEN
			wPosBeg := wPosBeg - 1;
			xRepeat := TRUE;
		ELSE
			xRepeat := FALSE;
		END_IF;
	ELSE
		xRepeat := FALSE;
	END_IF;
	WHILE xRepeat DO
		IF (wPosBeg - 1) >= wPosMin THEN
			IF MsgHelpTxtList[wPosBeg - 1].wNumber = wNumber THEN
				wPosBeg := wPosBeg - 1;
				xRepeat := TRUE;
			ELSE
				xRepeat := FALSE;
			END_IF;
		ELSE
			xRepeat := FALSE;
		END_IF;
	END_WHILE;
	IF (wPosEnd + 1) <= wPosMax THEN
		IF MsgHelpTxtList[wPosEnd + 1].wNumber = wNumber THEN
			wPosEnd := wPosEnd + 1;
			xRepeat := TRUE;
		ELSE
			xRepeat := FALSE;
		END_IF;
	ELSE
		xRepeat := FALSE;
	END_IF;
	WHILE xRepeat DO
		IF (wPosEnd + 1) <= wPosMax THEN
			IF MsgHelpTxtList[wPosEnd + 1].wNumber = wNumber THEN
				wPosEnd := wPosEnd + 1;
				xRepeat := TRUE;
			ELSE
				xRepeat := FALSE;
			END_IF;
		ELSE
			xRepeat := FALSE;
		END_IF;
	END_WHILE;
	wCnt := wPosBeg;
	WHILE MsgHelpTxtList[wCnt].wInstance <> wInstance AND (wCnt < wPosEnd) DO
		wCnt := wCnt + 1;
	END_WHILE;
	wPos := wCnt;
	IF MsgHelpTxtList[wPos].wInstance = wInstance THEN
		wMsgPos := wPos;
		wStatus := ERR_OK;
	END_IF;
END_FUNCTION_BLOCK