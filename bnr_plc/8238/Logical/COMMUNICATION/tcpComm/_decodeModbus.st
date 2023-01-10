//Decode eVue old modbus comms.
//V1.00.0 - 07/12/2020  First Version.
ACTION _decodeModbus: 
//						We always have 4 WORD header
//						Word 0 is TYPE
//						Word 1 is Start Address
//						Word 2 is Length OF Data
//						Word 3 is spare.
	start 	:= server[n].RecieveData[1];
	length 	:= server[n].RecieveData[2];	
	//Range checking.
	IF ((start + length) <= TCP_RECV_BUFFER_SIZE) AND (length > 0) AND (length <= TCP_RECV_BUFFER_SIZE) AND (length < tcpRecv.recvlen) THEN
		//brsmemcpy(ADR(TcpCommArray[start]),ADR(server[n].RecieveData[4]),(length * SIZEOF(server[n].RecieveData[0])));
		FOR x := start TO (start + length) BY 2 DO // 2 byte for each register	
			IF (CommArray[start] > 0) THEN
				brsmemcpy(CommArray[start],ADR(server[n].RecieveData[4]),2);		
			END_IF;
		END_FOR;
		brsstrcpy(ADR(server[n].SendData[0]),ADR(TCP_PASS_EVUE));
		sendSize[n] := LEN(TCP_PASS_EVUE);
		state := TCP_SERVER_SEND;
	ELSE	
		//Reply with a failure
		brsstrcpy(ADR(server[n].SendData[0]),ADR(TCP_FAIL_EVUE));
		sendSize[n] := LEN(TCP_FAIL_EVUE);
		state := TCP_SERVER_SEND;
	END_IF;
END_ACTION
