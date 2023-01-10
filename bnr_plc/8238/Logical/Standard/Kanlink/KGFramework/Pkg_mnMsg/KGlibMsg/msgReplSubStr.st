(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGlibMsg
 * File: msgReplSubStr.st
 * Author: kuehne
 * Created: January 23, 2012
 ********************************************************************
 * Implementation of library KGlibMsg
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION_BLOCK msgReplSubStr
	wStatus := 1;
	wMatched := 0;
	xCat := FALSE;
	IF brwcslen(ADR(utfStr)) = 0 OR brwcslen(ADR(utfSubStr)) = 0 THEN
		RETURN;
	END_IF;
	lChrPosStr := 0;
	lChrPosSubStr := 0;
	WHILE lChrPosStr < brwcslen(ADR(utfStr)) DO
		utfStrFirst := "";
		brwcsncat(ADR(utfStrFirst), ADR(utfStr) + 2 * lChrPosStr, 1);
		utfStrSecond := "";
		brwcsncat(ADR(utfStrSecond), ADR(utfSubStr) + 2 * lChrPosSubStr, 1);
		IF NOT (utfStrFirst = utfStrSecond) THEN
			IF xCat THEN
				IF (brwcslen(ADR(utfStrResult)) + lChrPosSubStr < (SIZEOF(utfStrResult) / 2)) THEN
					brwcsncat(ADR(utfStrResult), ADR(utfSubStr), lChrPosSubStr);
				ELSE
					brwcsncat(ADR(utfStrResult), ADR(utfSubStr),
					UDINT_TO_UINT(brwcslen(ADR(utfSubStr)) - (brwcslen(ADR(utfStrResult)) + brwcslen(ADR(utfSubStr)) - (SIZEOF(utfStrResult) / 2 - 1))));
				END_IF;
				xCat := FALSE;
			END_IF;
			WHILE lChrPosStr < brwcslen(ADR(utfStr)) DO
				lChrPosSubStr := 0;
				utfStrFirst := "";
				brwcsncat(ADR(utfStrFirst), ADR(utfStr) + 2 * lChrPosStr, 1);
				utfStrSecond := "";
				brwcsncat(ADR(utfStrSecond), ADR(utfSubStr) + 2 * lChrPosSubStr, 1);
				IF utfStrFirst = utfStrSecond THEN
					lChrPosStr := lChrPosStr + 1;
					lChrPosSubStr := lChrPosSubStr + 1;
					xCat := TRUE;
					EXIT;
				ELSE
					brwcsncat(ADR(utfStrResult), ADR(utfStrFirst),
					UDINT_TO_UINT(brwcslen(ADR(utfStrFirst)) - (brwcslen(ADR(utfStrResult)) + brwcslen(ADR(utfStrFirst)) - (SIZEOF(utfStrResult) / 2 - 1))));
				END_IF;
				lChrPosStr := lChrPosStr + 1;
			END_WHILE;
		ELSE
			IF lChrPosSubStr = brwcslen(ADR(utfSubStr)) - 1 THEN
				wMatched := wMatched + 1;
				wStatus := ERR_OK;
				brwcsncat(ADR(utfStrResult), ADR(utfStrToReplWith),
				UDINT_TO_UINT(brwcslen(ADR(utfStrToReplWith)) - (brwcslen(ADR(utfStrResult)) + brwcslen(ADR(utfStrToReplWith)) - (SIZEOF(utfStrResult) / 2 - 1))));
				xCat := FALSE;
			ELSE
				xCat := TRUE;
			END_IF;
			IF (lChrPosStr = brwcslen(ADR(utfStr)) - 1) AND (xCat = TRUE) THEN
				brwcsncat(ADR(utfStrResult), ADR(utfSubStr), lChrPosSubStr + 1);
			END_IF;
			lChrPosStr := lChrPosStr + 1;
			lChrPosSubStr := lChrPosSubStr + 1;
		END_IF;
	END_WHILE;
END_FUNCTION_BLOCK