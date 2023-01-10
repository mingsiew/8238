
ACTION _httpServer: 
	
	//Force the server to restart when then restart the PLC. Stops the server from crashing during PLC transfer
	IF (httpServer.status = ERR_FUB_ENABLE_FALSE) THEN
		httpServer.enable := 1;
	END_IF;
	//Error Handling -- Return the code 400 (Baf if there is a process error
	
	IF errorResponse THEN
		responseHeader.status := '400 Bad Request';		
		sendResponse := 1;	
	ELSIF ton_httpTimeOut.Q THEN
		responseHeader.status := '408 Request Timeout';		
		responseData := 'Response Timeout'; 
		sendResponse := 1;
	ELSIF sendResponse THEN;
		responseHeader.status := '200 OK';		
	END_IF;

	
	httpServer.enable := 1;	
	httpServer.send := sendResponse; // Send Response on Rising edge.
	httpServer.abort := abortResponse;	//Send abort Response on Rising Edge
	
	IF (overRideData.responseDataLen > 0) THEN
		httpServer.responseDataLen := overRideData.responseDataLen;
	ELSE	
		httpServer.responseDataLen := brsstrlen(ADR(responseData));
	END_IF;
	IF overRideData.responseHeader.contentType <> '' THEN
		responseHeader.contentType := overRideData.responseHeader.contentType;	
	ELSIF overRideData.responseHeader.contentType <> 'nothing' THEN
		responseHeader.contentType := '';	
	ELSE
		responseHeader.contentType := 'text/plain';
	END_IF;
	IF overRideData.responseHeader.status <> '' THEN
		responseHeader.status := overRideData.responseHeader.status;
	END_IF;
	
	responseHeader.contentLength := httpServer.responseDataLen;
	
	
	IF sendBinaryData THEN
		httpServer.pResponseData := ADR(responseDataBinary);
	ELSE
		httpServer.pResponseData := ADR(responseData);
	END_IF;	
	httpServer();
	
	sendBinaryData := 0;
	
	IF (httpServer.phase = httpPHASE_RECEIVED) AND NOT sendResponse THEN
		recieved := 1;
	ELSE
		recieved := 0;		
	END_IF;	
	//Clear the overrides
	overRideData.responseDataLen 			:= 0;
	overRideData.responseHeader				:= BLANK_RESPONSE_HEADER;				
	
	sendResponse := 0;
	abortResponse := 0;
	errorResponse := 0;
	
	//Request Timeout
	ton_httpTimeOut(IN:= (httpServer.phase = httpPHASE_RECEIVED),PT:= 500);//500
END_ACTION
