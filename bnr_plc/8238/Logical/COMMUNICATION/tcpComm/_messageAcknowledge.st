//Acknowledge a message.
//V1.00.0 - 11/10/2021  First Version.
ACTION _messageAcknowledge: 
//						We always have 4 WORD Packet
//						Word 0 is TYPE
//						Word 1 is Rail ID
//						Word 2 is Message id of the rail
//						Word 3 is Action of the message .. 1 = Acknowledge
	start 	:= server[n].RecieveData[1];
	length 	:= server[n].RecieveData[2];	
	//Range checking.
	IF (server[n].RecieveData[1] > 0)  AND (server[n].RecieveData[1] <= RAIL_COUNT) AND (server[n].RecieveData[2] > 0) AND (server[n].RecieveData[2] <= 15) THEN
    messages ACCESS ADR (RailComm[server[n].RecieveData[1]].Messages);
    messages.Read[server[n].RecieveData[2]] := server[n].RecieveData[3];
    server[n].SendData[0] := TCP_SUCCESS;
		sendSize[n] := 2; //2 bytes 
		state := TCP_SERVER_SEND;
	ELSE	
		//Reply with a failure
		brsstrcpy(ADR(server[n].SendData[0]),ADR(TCP_FAIL_EVUE));
		sendSize[n] := LEN(TCP_FAIL_EVUE);
		state := TCP_SERVER_SEND;
	END_IF;
END_ACTION
