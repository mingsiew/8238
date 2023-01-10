(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actGetOneTurnRB.st
 * Author: kuehne
 * Created: February 22, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actGetOneTurnRB:
	IF _xRBReady THEN
		IF _wPtrRBstart = 0 THEN
			_xRBoneTurn := FALSE;
			IF _wPtrRBwrite > 0 THEN
				_wMsgHistListMaxOffsetRB := _wPtrRBwrite - 1;
			ELSE
				_wMsgHistListMaxOffsetRB := 0;
			END_IF;
		END_IF;
		IF _wPtrRBstart = _wPtrRBwrite + 1 THEN
			_xRBoneTurn := TRUE;
			_wMsgHistListMaxOffsetRB := MNMSG_MAX_MESSAGEHISTORY - 1;
		END_IF;
	ELSE
		_xRBoneTurn := FALSE;
		_wMsgHistListMaxOffsetRB := 0;
	END_IF;
END_ACTION