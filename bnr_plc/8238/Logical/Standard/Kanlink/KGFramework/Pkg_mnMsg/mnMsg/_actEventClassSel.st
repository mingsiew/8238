(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnMsg
 * File: actEventClassSel.st
 * Author: kuehne
 * Created: February 24, 2012
 ********************************************************************
 * Implementation of program mnMsg
 ********************************************************************) 

(* Add a new action to your IEC program or library *)
ACTION _actEventClassSel:
	IF (_TempHistline.wEvent <> _wMsgHistListEventSelRB) AND (_wMsgHistListEventSelRB <> 0) THEN
		_xSelOk := FALSE;
	ELSIF ((_TempHistline.wMsgClass = 0) OR (_TempHistline.wMsgClass = 1)) AND (_wMsgHistListClassSelRB.0 = 0) THEN
		_xSelOk := FALSE;
	ELSIF (_TempHistline.wMsgClass = 10) AND (_wMsgHistListClassSelRB.1  = 0) THEN
		_xSelOk := FALSE;
	ELSIF (_TempHistline.wMsgClass = 11) AND (_wMsgHistListClassSelRB.2 = 0) THEN
		_xSelOk := FALSE;
	ELSIF (_TempHistline.wMsgClass = 20) AND (_wMsgHistListClassSelRB.3 = 0) THEN
		_xSelOk := FALSE;
	ELSE
		_wPtrRBlocLastFound := _wPtrRBloc;
		_xSelOk := TRUE;
	END_IF;
END_ACTION