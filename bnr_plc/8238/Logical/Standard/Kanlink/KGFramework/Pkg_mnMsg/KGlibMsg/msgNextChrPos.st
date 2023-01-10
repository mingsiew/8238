(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGlibMsg
 * File: msgNextChrPos.st
 * Author: kuehne
 * Created: February 23, 2012
 ********************************************************************
 * Implementation of library KGlibMsg
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION_BLOCK msgNextChrPos
	wStatus := 1;
	lChrPos := 0;
	_lChrPos := lStartPos;
	_lUtfLen := brwcslen(ADR(utfStr));
	WHILE _lChrPos < _lUtfLen AND wStatus = 1 DO
		_utfChr := "";
		brwcsncat(ADR(_utfChr), ADR(utfStr) + 2 * _lChrPos, 1);
		IF _utfChr = utfChr THEN
			lChrPos := _lChrPos;
			wStatus := ERR_OK;
		END_IF;
		_lChrPos := _lChrPos + 1;
	END_WHILE;
END_FUNCTION_BLOCK