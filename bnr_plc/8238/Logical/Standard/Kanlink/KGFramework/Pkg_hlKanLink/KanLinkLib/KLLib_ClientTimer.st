(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: WetLinkLib
 * File: WLLIb_ClientTimer.st
 * Author: stahlhut
 * Created: January 06, 2012
 ********************************************************************
 * Implementation of library WetLinkLib
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION KLLib_ClientTimer
FOR _i := 0 TO HLKANLINK_MAX_CLIENTCONNS DO
	_dClient  ACCESS ADR(Srv.ClientListe[_i]);
	_dInterface ACCESS (_dClient.adrInterface);

	// TimeOut (kurz) taskgerecht berechnen	
	IF (_dClient.TimeOutLeft >= _iCycleTime) AND _dClient.xReqPending THEN
 		_dClient.TimeOutLeft := _dClient.TimeOutLeft - _iCycleTime;
	END_IF;		
	
	IF _dClient.iCycleWait <= _dClient.iCycleTime THEN 
		_dClient.iCycleWait := _dClient.iCycleWait + _iCycleTime;
	END_IF;
	// Timeout aufgetreten nur bis n Zählen. Retry sofort nach timeout, sonst retry nach cycletime
	IF _dClient.xReqPending AND (_dClient.TimeOutLeft < _iCycleTime) THEN
		_dClient.iTimeOutCnt_Summe := _dClient.iTimeOutCnt_Summe + 1; 
		_dClient.xReqPending := FALSE;	// noch mal versuchen
		IF _dClient.iTimeOutCnt < 5 THEN
			_dClient.iTimeOutCnt := _dClient.iTimeOutCnt +1 ;	
			_dClient.xReqPending := FALSE;	// noch mal versuchen
			_dInterface.iState := 4; 	
			_dClient.iCycleWait := _dClient.iCycleTime;
		END_IF;		
	END_IF;
		// Verbindungsfehler 
	_dClient.xConnected := (_dClient.iTimeOutCnt < 5) AND _dClient.xActiv AND (_dClient.iCycleTime > 0);
	_dInterface.out.xConnected := _dClient.xConnected;
	IF (_dClient.iTimeOutCnt >= 5 ) AND ( _dInterface.iState = 2 ) THEN 
		_dInterface.iState := 255; // Timeout melden
	END_IF;	
		
END_FOR;

FOR _i := 0 TO HLKANLINK_MAX_MU_CLIENTCONNS DO

	// TimeOut (kurz) taskgerecht berechnen	
	IF (Srv.MuClientListe[_i].TimeOutLeft >= _iCycleTime) AND Srv.MuClientListe[_i].xReqPending THEN
 		Srv.MuClientListe[_i].TimeOutLeft := Srv.MuClientListe[_i].TimeOutLeft - _iCycleTime;
	END_IF;		

	IF Srv.MuClientListe[_i].iCycleWait <= Srv.MuClientListe[_i].iCycleTime THEN 
		Srv.MuClientListe[_i].iCycleWait := Srv.MuClientListe[_i].iCycleWait + _iCycleTime;
	END_IF;

	// Timeout aufgetreten nur bis n Zählen. Retry sofort nach timeout, sonst retry nach cycletime
	IF Srv.MuClientListe[_i].xReqPending AND (Srv.MuClientListe[_i].TimeOutLeft < _iCycleTime) THEN
		Srv.MuClientListe[_i].iTimeOutCnt_Summe := Srv.MuClientListe[_i].iTimeOutCnt_Summe + 1; 
		Srv.MuClientListe[_i].xReqPending := FALSE;	// noch mal versuchen
		IF Srv.MuClientListe[_i].iTimeOutCnt < 5 THEN
			Srv.MuClientListe[_i].iTimeOutCnt := Srv.MuClientListe[_i].iTimeOutCnt +1 ;	
			Srv.MuClientListe[_i].xReqPending := FALSE;	// noch mal versuchen
			Srv.MuClientListe[_i].iCycleWait := Srv.MuClientListe[_i].iCycleTime;
		END_IF;		
	END_IF;

	IF ((Srv.MuClientListe[_i].Clients[0] >= 0) AND (Srv.MuClientListe[_i].bUse <> 0) AND (Srv.MuClientListe[_i].bUse <> 255)) THEN
		FOR _k := 0 TO KLLIB_MAX_MUL DO
			IF (Srv.MuClientListe[_i].Clients[_k] >= 0) THEN
				IF (Srv.MuClientListe[_i].iCycleWait < Srv.ClientListe[Srv.MuClientListe[_i].Clients[_k]].iCycleWait) THEN
					Srv.MuClientListe[_i].iCycleWait := Srv.ClientListe[Srv.MuClientListe[_i].Clients[_k]].iCycleWait;
				END_IF
				IF (Srv.MuClientListe[_i].TimeOutLeft < Srv.ClientListe[Srv.MuClientListe[_i].Clients[_k]].TimeOutLeft) THEN
					Srv.MuClientListe[_i].TimeOutLeft := Srv.ClientListe[Srv.MuClientListe[_i].Clients[_k]].TimeOutLeft;
				END_IF
			ELSE
				EXIT;
			END_IF
		END_FOR
	ELSIF ((Srv.MuClientListe[_i].Clients[0] < 0) AND (Srv.MuClientListe[_i].bUse = 0)) THEN
		EXIT;
	END_IF
END_FOR

FOR _i := 0 TO HLKANLINK_MAX_SERVERCONNS DO
	_dServer ACCESS ADR(Srv.ServerListe[_i]);
	_dSrvIf ACCESS _dServer.adrInterface;	
		
	IF _dServer.iConnectionTimer <= 2000 THEN
		_dServer.iConnectionTimer := _dServer.iConnectionTimer + _iCycleTime;
	END_IF;
	_dServer.xConnected := (_dServer.iConnectionTimer < 2000);	
	_dSrvIf.out.xConnected := _dServer.xConnected;
END_FOR;
KLLib_ClientTimer := 0; 

END_FUNCTION
