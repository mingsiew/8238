(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actLocMOD.st
 * Author: kuehne
 * Created: February 24, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actLocMOD:
	IF _xRBoneTurn THEN
		IF MNMSG_MAX_MESSAGEHISTORY >= 1 AND (_wPtrRBloc + _wMsgHistListOffsetRB) > 0 THEN
			_wPtrRBloc := (_wPtrRBloc + _wMsgHistListOffsetRB) MOD UDINT_TO_UINT(MNMSG_MAX_MESSAGEHISTORY); // sum equals cnt: 0
		ELSE
			_wPtrRBloc := 0;
		END_IF;
	ELSE
		IF _wPtrRBwrite > 0 AND (_wPtrRBloc + _wMsgHistListOffsetRB) > 0 THEN
			_wPtrRBloc := (_wPtrRBloc + _wMsgHistListOffsetRB) MOD _wPtrRBwrite; // sum equals ptr: 0
		ELSE
			_wPtrRBloc := 0;
		END_IF;
	END_IF;
	IF _wPtrRBloc > _wPtrRBlocTemp THEN
		_wMsgHistListOffsetRB := _wPtrRBloc - _wPtrRBlocTemp;
	ELSE
		_wMsgHistListOffsetRB := 0;
	END_IF;
END_ACTION