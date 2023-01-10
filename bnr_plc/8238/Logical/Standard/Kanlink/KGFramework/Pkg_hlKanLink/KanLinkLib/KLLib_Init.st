(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KanLinkLib
 * File: KL_Init.st
 * Author: stahlhut
 * Created: January 12, 2012
 ********************************************************************
 * Implementation of library KanLinkLib
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION_BLOCK KLLib_Init
 
	IF (adrServer = 0) OR (adrInterface = 0 )  THEN // fehler 
		status := 1;
		enable := 0;
		RETURN;
	END_IF;	
	IF enable = 0 THEN 
		status := ERR_FUB_ENABLE_FALSE;
		RETURN;
	END_IF;
	
	
	IF (status = ERR_FUB_BUSY	) AND (enable = 0) THEN 
		status := ERR_FUB_ENABLE_FALSE;
		_bStep := 100;
	END_IF;	
		
	
	
	CASE _bStep OF 
		0: // nix tun
			status := ERR_FUB_BUSY;
			_bStep := 10;
		10:
			_dServer ACCESS adrServer; 
			_dServer.adrSelf := adrServer;
			_dIf ACCESS adrInterface;
			_dServer.adrInterface := adrInterface;

			
			
			IF _dServer.iPort = 0 THEN 
				_dServer.iPort := 23500; // standardport benutzen
			END_IF;		
			RTInfo_0.enable := TRUE;
			RTInfo_0;	
			
			_dServer._iCycleTime := UDINT_TO_UINT( RTInfo_0.cycle_time / 1000);

			_bStep := 20;
		20:
			GetEthPort_0.enable := 1; 
			GetEthPort_0.adrIF := ADR(_dServer.sIF);	
			GetEthPort_0;
			IF GetEthPort_0.status = ERR_OK THEN
				_bStep := 30;
			ELSIF GetEthPort_0.status <> ERR_FUB_BUSY THEN // fehler aufgetreten
				status := 2;
				_bStep := 100;
			END_IF;
		30: 
			CfgGetIPAddr_0.enable  := 1;
			CfgGetIPAddr_0.pDevice := ADR(_dServer.sIF);
			CfgGetIPAddr_0.pIPAddr := ADR(_dServer.sNetID);
			CfgGetIPAddr_0.Len := 16;
			CfgGetIPAddr_0;	
			IF  (CfgGetIPAddr_0.status = ERR_OK) THEN 
				_i := 0;
				_bStep := 40;
				ethInetAton(ADR(_dServer.sNetID),ADR(_dServer.udNetID));
				
			ELSIF CfgGetIPAddr_0.status <> ERR_FUB_BUSY THEN // fehler aufgetreten
				status := 3;
				_bStep := 100;
			END_IF;
		
		40:
			_dServer.ServerListe[_i].adrInterface := ADR(_dIf.Server[_i]);
			KLLib_ReadServerPara(ADR(_dServer.ServerListe[_i]), ADR( _dIf.Parameter.Server[_i]),ADR(_dServer));

			_i := _i + 1;
			IF (_i > HLKANLINK_MAX_SERVERCONNS) THEN
				_i := 0;
				_bStep := 41;		
			END_IF

		41:
			KLLib_ReadClientPara(ADR(_dServer.ClientListe[_i]),ADR(_dIf.Parameter.Client[_i]),ADR(_dServer));
			_dServer.ClientListe[_i].xActiv := (_dServer.ClientListe[_i].Cmd <> 0);
			_dServer.ClientListe[_i].TimeOut := 140;
			_dServer.ClientListe[_i].adrInterface := ADR(_dIf.Client[_i]);
			_dServer.ClientListe[_i].MuClient := -1;

			_i := _i + 1;
			IF (_i > HLKANLINK_MAX_CLIENTCONNS) THEN
				_i := 0;
				_bStep := 45;		
			END_IF

		45:
			memset(ADR(_dServer.MuClientListe),0,SIZEOF(_dServer.MuClientListe));
			FOR _m := 0 TO HLKANLINK_MAX_MU_CLIENTCONNS DO  
				FOR _i := 0 TO KLLIB_MAX_MUL DO  
					_dServer.MuClientListe[_m].Clients[_i] := -1;
				END_FOR
			END_FOR
			_m := 0;
			_i := 0;
			_bStep := 46;		

		46:
			IF ((0 < brsstrlen(ADR(_dServer.ClientListe[_i].sClientAdr))) AND (_dServer.ClientListe[_i].Cmd <> 0)) THEN
				// Hinzufügen zu einem bestehenden Multiclient
				IF ((0 = brsstrcmp(ADR(_dServer.MuClientListe[_m].sClientAdr),ADR(_dServer.ClientListe[_i].sClientAdr))) AND (_dServer.ClientListe[_i].MuClient = -1) AND (_dServer.MuClientListe[_m].Clients[KLLIB_MAX_MUL] = -1)
					AND ((_dServer.MuClientListe[_m].ReqLength + HeaderSize + _dServer.ClientListe[_i].ReqLength) < 8192) AND ((_dServer.MuClientListe[_m].RespLength + HeaderSize + _dServer.ClientListe[_i].RespLength) < 8192)) THEN
					FOR _n := 1 TO KLLIB_MAX_MUL DO  
						IF (_dServer.MuClientListe[_m].Clients[_n] = -1) THEN
							_dServer.ClientListe[_i].MuClient := INT_TO_USINT(_m);
							_dServer.MuClientListe[_m].Clients[_n] := _i;
							_dServer.MuClientListe[_m].ReqLength := _dServer.MuClientListe[_m].ReqLength + HeaderSize + _dServer.ClientListe[_i].ReqLength;
							_dServer.MuClientListe[_m].RespLength := _dServer.MuClientListe[_m].RespLength + HeaderSize + _dServer.ClientListe[_i].RespLength;
							EXIT;
						END_IF
					END_FOR
				ELSE
					FOR _k := 0 TO HLKANLINK_MAX_CLIENTCONNS DO
						// Erzeugen eines neuen MultiClients
						IF ((0 = brsstrcmp(ADR(_dServer.ClientListe[_i].sClientAdr),ADR(_dServer.ClientListe[_k].sClientAdr))) AND (_i <> _k) AND (_dServer.ClientListe[_i].MuClient = -1) AND (_dServer.ClientListe[_k].MuClient = -1) AND (_dServer.MuClientListe[_m].Clients[0] = -1)) THEN
							_dServer.MuClientListe[_m].sClientAdr := _dServer.ClientListe[_i].sClientAdr;
							_dServer.MuClientListe[_m].ReqLength := PreHeaderSize;
							_dServer.MuClientListe[_m].RespLength := PreHeaderSize;
							_dServer.ClientListe[_i].MuClient := INT_TO_USINT(_m);
							_dServer.MuClientListe[_m].Clients[0] := _i;
							_dServer.MuClientListe[_m].ReqLength := _dServer.MuClientListe[_m].ReqLength + HeaderSize + _dServer.ClientListe[_i].ReqLength;
							_dServer.MuClientListe[_m].RespLength := _dServer.MuClientListe[_m].RespLength + HeaderSize + _dServer.ClientListe[_i].RespLength;
							EXIT;
						END_IF
					END_FOR
				END_IF
			END_IF
			
			_i := _i + 1;
			IF (_i > HLKANLINK_MAX_CLIENTCONNS) THEN
				_i := 0;
				_m := _m + 1;
			END_IF

			IF (_m > HLKANLINK_MAX_MU_CLIENTCONNS) THEN
				_bStep := 47;		
			END_IF

		47:
			// Bestimmen der Parameter für die Verbindung
			FOR _m := 0 TO HLKANLINK_MAX_MU_CLIENTCONNS DO  
				IF (0 < brsstrlen(ADR(_dServer.MuClientListe[_m].sClientAdr))) THEN
					_dServer.MuClientListe[_m].bUse := 2;
					_dServer.MuClientListe[_m].TimeOut := 140;
					_dServer.MuClientListe[_m].xActiv := TRUE;
					FOR _i := 0 TO KLLIB_MAX_MUL DO  
						IF (_dServer.MuClientListe[_m].Clients[_i] >= 0) THEN
							IF ((_dServer.MuClientListe[_m].iCycleTime = 0) OR ((_dServer.ClientListe[_dServer.MuClientListe[_m].Clients[_i]].iCycleTime < _dServer.MuClientListe[_m].iCycleTime) AND (_dServer.ClientListe[_dServer.MuClientListe[_m].Clients[_i]].iCycleTime > 0))) THEN
								_dServer.MuClientListe[_m].iCycleTime := _dServer.ClientListe[_dServer.MuClientListe[_m].Clients[_i]].iCycleTime;
							END_IF
						ELSE
							EXIT;
						END_IF
					END_FOR
				ELSE
					EXIT;
				END_IF
			END_FOR
			_bStep := 50;		
		
		50: 
			_dServer.udp.open.enable := 1;
			_dServer.udp.open.pIfAddr := ADR(_dServer.sNetID);	(* Übergeben des Interface funzt nicht *)
			_dServer.udp.open.port := _dServer.iPort;	(* Port to listen*)
			_dServer.udp.open.options := 0;
			_dServer.udp.open;	(* Call the Function*)
		 
			IF _dServer.udp.open.status = 0 THEN  (* UdpOpen successful*)
				_dServer._uiLastId := _dServer.udp.open.ident;
				_bStep := 90;
			ELSIF _dServer.udp.open.status = ERR_FUB_BUSY THEN  (* UdpOpen not finished -> redo *)			
				
			ELSIF _dServer.udp.open.status = udpERR_ALREADY_EXIST THEN // erst schliessen
				_dServer.udp.close.enable := 1;
				_dServer.udp.close.ident := _dServer._uiLastId;
				_dServer.udp.close;
				IF _dServer.udp.close.status = 0 THEN
					//
				ELSIF _dServer.udp.close.status = ERR_FUB_BUSY THEN
					
				ELSE
					status := 5001;
					_bStep := 100;	// unbekannter close fehler aufgetreten
				END_IF;	
				
			ELSE	
				status := 5002;
				_bStep := 100; // unbekannter open fehler aufgetreten
			END_IF		
		
		90:  // fertig
			status := ERR_OK;
			enable := 0;
			_bStep := 0;
			
		100: // fehler aufgetreten
			enable := 0;
			_bStep := 0;
			
	END_CASE;
			

END_FUNCTION_BLOCK
