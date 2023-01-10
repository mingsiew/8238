//Acknowledge a message.
//V1.00.0 - 27/04/2022  First Version.
ACTION _inputScreenMsg: 
//						We always have 4 WORD Packet
//						Word 0 is TYPE
//						Word 1 is Sling Input Station ID
//						Word 2..3 -- UDINT- Action code -- displayID * 1000 + action ID  -- 1001 = Screen state 1 action 1.  
  start := server[n].RecieveData[1];
  //Range checking.
  IF (start > 0)  AND (start <= SLING_INPUTS_COUNT) THEN
   //Do something with the message here.
    brsmemcpy(ADR(SlingInputComm[start].Read),ADR(server[n].RecieveData[2]),4); 
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
