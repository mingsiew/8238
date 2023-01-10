//V1.00 	- First Version
//V1.00.1 	- ADD Evue modbus decode function. 
PROGRAM _INIT
  _initialiseComms;
	listenPort 	:= TCP_COMM_PORT;
	socketState := TCP_SOCKET_OPEN;	
END_PROGRAM
PROGRAM _CYCLIC

	CASE socketState OF
		TCP_SOCKET_OPEN:
			tcpOpen.enable := 1;
			tcpOpen.options := tcpOPT_REUSEADDR;
			tcpOpen.pIfAddr := 0; //Listen for any connection
			tcpOpen.port := listenPort;
			tcpOpen();
			IF (tcpOpen.status = ERR_OK) THEN
				socketState := TCP_SOCKET_LISTEN;
			ELSIF tcpOpen.status <> ERR_FUB_BUSY THEN
				socketState := TCP_SOCKET_GET_CONNECTION_LIST; // Close all connections if we have any socket errors
			END_IF;

		TCP_SOCKET_LISTEN:
			tcpServer.enable := (tcpOpen.ident > 0);
			tcpServer.ident := tcpOpen.ident;
			tcpServer.backlog := MAX_TCP_CONNECTIONS; //Only this many connections
			tcpServer.pIpAddr := ADR(ipAddress);
			tcpServer();
			IF tcpServer.status = ERR_OK THEN
				connectCount := connectCount + 1; // DEBUG INFO ONLY
				FOR n := 0 TO MAX_TCP_CONNECTIONS DO // Find an available server
					IF (server[n].State = TCP_SERVER_IDLE) AND (server[n].Ident = 0) THEN	
						server[n].Ident			:= tcpServer.identclnt;
						server[n].ResponsePort 	:= tcpServer.portclnt;
						server[n].IpAddress 	:= ipAddress;
						EXIT;
					END_IF;
				END_FOR;				
			ELSIF tcpServer.status <> ERR_FUB_BUSY THEN
				socketState := TCP_SOCKET_GET_CONNECTION_LIST; // Close all connections if we have any socket errors.
			END_IF;

		TCP_SOCKET_GET_CONNECTION_LIST:	
			tcp_Ioctl.enable := 1;
			tcp_Ioctl.ident := tcpINVALID_IDENT; 
			tcp_Ioctl.ioctl := tcpID_LIST_GET;
			tcp_Ioctl.pData := ADR(usedIdentList[0]);
			tcp_Ioctl.datalen := SIZEOF(usedIdentList);
			tcp_Ioctl();
			IF (tcp_Ioctl.status = ERR_OK) THEN
				x := 0;
				socketState := TCP_SOCKET_CLOSE_ALL_CONNECTIONS;
			ELSIF (tcp_Ioctl.status <> ERR_FUB_BUSY) THEN
				socketState := TCP_SOCKET_OPEN;//TCP_SOCKET_ERROR;
			END_IF;	

		TCP_SOCKET_CLOSE_ALL_CONNECTIONS:

			//WHILE (usedIdentList[n] <> 0) DO  // Remove the While loop- PLC can;t cope in 10ms
			socketClose.enable := (usedIdentList[x] > 0);
			socketClose.ident := usedIdentList[x];
			socketClose.how  := 0;// (tcpSHUT_RD OR tcpSHUT_WR); // Bitwise- set both flags.
			socketClose();
			IF (socketClose.status = ERR_OK) THEN
				usedIdentList[x] := 0;
				IF x < 254 THEN x:= x + 1; END_IF;
			ELSIF (socketClose.status <> ERR_FUB_BUSY) THEN
				usedIdentList[x] := 0;
				IF x < 254 THEN x:= x + 1; END_IF;
			END_IF;
			//END_WHILE;
			IF (usedIdentList[x] = 0) THEN
				socketState := TCP_SOCKET_OPEN;
			END_IF;

		TCP_SOCKET_ERROR:

	END_CASE

	//Handle each server state..
	FOR n := 0 TO MAX_TCP_CONNECTIONS DO	

		IF (socketState = TCP_SOCKET_LISTEN) THEN

			//Set up the references
			_references;

			//Close the connection after 60'
			ton_NoData.IN := (state = TCP_SERVER_RECV);
			ton_NoData.PT := T#60s;
			ton_NoData();

			CASE state OF

				TCP_SERVER_IDLE:
					IF ident > 0 THEN
						state := TCP_SERVER_RECV; 
					END_IF;	

				TCP_SERVER_RECV:
					tcpRecv.enable := (ident > 0);	
					tcpRecv.ident := ident;
					tcpRecv.pData := ADR(server[n].RecieveData[0]);
					tcpRecv.datamax := SIZEOF(server[n].RecieveData);	
					tcpRecv.flags := 0;
					tcpRecv();
					IF tcpRecv.status = ERR_OK AND (tcpRecv.recvlen > 0)  THEN
//						Open the packet TO decide how TO deocde it
// 						FIRST WORD MUSE BE PACKET TYPE
						CASE server[n].RecieveData[0] OF 
							1: // eVue Modbus replacement.
								_decodeModbus;
							100://ECHO
								IF (tcpRecv.recvlen <= TCP_SEND_BUFFER_SIZE) THEN
									memcpy(ADR(server[n].SendData[0]),ADR(server[n].RecieveData[0]),tcpRecv.recvlen);
									sendSize[n] := tcpRecv.recvlen;
								ELSE // Only respond as much as we can.
									memcpy(ADR(server[n].SendData[0]),ADR(server[n].RecieveData[0]),TCP_SEND_BUFFER_SIZE);
									sendSize[n] := TCP_SEND_BUFFER_SIZE;	
								END_IF;	
								state := TCP_SERVER_SEND;
              LIVE_DATA_TYPE_RAIL_MESSAGES: //1001 Message Acknowledge
                _messageAcknowledge;
              LIVE_DATA_TYPE_SLING_INPUT_STATE://3001 - Sling input station command
                _inputScreenMsg;
              ELSE // Fail to DECODE -- Send fail message.
								brsstrcpy(ADR(server[n].SendData[0]),ADR(TCP_FAIL_DECODE));
								sendSize[n] := LEN(TCP_FAIL_DECODE);
								state := TCP_SERVER_SEND;				
						END_CASE;	
					ELSIF (tcpRecv.status = tcpERR_NOT_CONNECTED) THEN
						state := TCP_SERVER_CLOSE;
					ELSIF (tcpRecv.status = tcpERR_NO_DATA) THEN
						//state := TCP_SERVER_SEND;
					ELSIF(tcpRecv.status <> ERR_FUB_BUSY) THEN
						state := TCP_SERVER_CLOSE;	
					ELSIF ton_NoData.Q THEN
						state := TCP_SERVER_CLOSE;
					ELSIF (ident = 0) THEN
						server[n] := SERVER_IDLE;	
					END_IF;	


				TCP_SERVER_SEND:
					tcpSend.enable := (ident > 0);
					tcpSend.ident := ident;
					tcpSend.pData := ADR(server[n].SendData[0]);
					tcpSend.datalen := sendSize[n];
					tcpSend.flags := 0;
					tcpSend();
					IF tcpSend.status = ERR_OK THEN
						state := TCP_SERVER_RECV;
					ELSIF (tcpSend.status <> ERR_FUB_BUSY) THEN
						state := TCP_SERVER_CLOSE;		
					ELSIF (ident = 0) THEN
						server[n] := SERVER_IDLE;	
					END_IF;	

				TCP_SERVER_CLOSE:
					tcpClose.enable := (ident > 0);			
					tcpClose.how	:= 0;
					tcpClose.ident	:= ident;
					tcpClose();
					IF tcpClose.status = ERR_OK THEN
						ident := 0;
						server[n] := SERVER_IDLE;		
					ELSIF tcpClose.status <> ERR_FUB_BUSY THEN
						ident := 0;
						server[n] := SERVER_IDLE;	
					END_IF;	

			END_CASE;

			IF EDGEPOS(state = TCP_SERVER_RECV) THEN	
				memset(ADR(server[n].SendData[0]),0,SIZEOF(server[n].SendData));
				memset(ADR(server[n].RecieveData[0]),0,SIZEOF(server[n].RecieveData));
			END_IF;
		ELSE	
			server[n] := SERVER_IDLE;			
		END_IF;	
	END_FOR;		

END_PROGRAM
PROGRAM _EXIT

END_PROGRAM
