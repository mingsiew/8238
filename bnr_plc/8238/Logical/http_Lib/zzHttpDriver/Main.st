//V2.00.1- First Release of Version Control - Remove all unused code- Removed temp memory for recieve data as this helps when we get a "Invalid Character error"
//V2.00.2 -- ADD: New error handling if we do not recieve data when expected.
//V2.00.3 -- ADD: Add http reply code to the http data type so we don;t have to decode the string in the user tasks
//V3.00.1 -- CHANGE: TR 23/08/2019 - Convert the driver to a state machine
//V3.00.2 -- FIX: When writing to reports the status is being set as disabled causing repeated writes -- Comment out in HTTP_CLIENT_PROCESS_REQUEST and it works.. It makes no sense!!
//V3.00.3 -- FIX: Found solution to 3.02. The original state was being set to DISABLE so the proces step was exiting incorrectly.
//V3.00.4 -- FIX: Issue with certain errors getting stuck on the abort step.
//V3.00.5 -- FIX: 35560 error non more idents availble!! 
//V3.00.6 -- FIX: URL Wasn;t not being cleared correctly
//V3.00.7 -- FIX: TCP ERROR could lock up the driver.
//V3.00.8 -- FIX: The way we were passing the http port mean that it was always being set to 0 reegardless of the default setting, when not using overwrite
PROGRAM _INIT
	//Use Static code now but change to config file later..
	HTTP_Config.Host := '10.8.4.220';	
	HTTP_Config.Port := 0;	
	httpComm ACCESS ADR(HTTP_Comm[0]);
	
	pUrl 							:= ADR(URL);
	pRequestHeader 					:= ADR(requestHeader);
	pResponseHeader 				:= ADR(responseHeader);
	pStatistics 					:= ADR(Statistics);
	pHost 							:= ADR(requestHeader.host);
	
	http_Client.pUri 				:= pUrl;
	http_Client.option 				:= httpOPTION_HTTP_11;
	http_Client.pHost 				:= pHost;
	http_Client.pRequestHeader 		:= pRequestHeader;
	http_Client.pResponseHeader 	:= pResponseHeader;
	http_Client.pStatistics 		:= pStatistics;
	
	//Configure RequestHeader
	requestHeader.protocol := DEFAULT_REQUEST_HEADER.protocol; //'HTTP/1.1';
	requestHeader.contentType := DEFAULT_REQUEST_HEADER.contentType;//'text/plain';
	requestHeader.connection := DEFAULT_REQUEST_HEADER.connection;//'close';
	requestHeader.keepAlive := DEFAULT_REQUEST_HEADER.keepAlive;//'max=100,timeout=5';


	sizeTempMem := 500000; //Allocate 500k of free memory
	TMP_alloc(sizeTempMem,ADR(pTempMem));
	
	ringBuffer[0] := 0;
	//Check for any requests that were being processed on shut down..
	FOR n := 1 TO HTTP_MAX_COMM DO
		IF HTTP_Comm[n].Status = HTTP_COMM_STATUS_IN_PROCESS THEN
			ringBuffer[0] := n;	
		ELSIF HTTP_Comm[n].Status = HTTP_COMM_STATUS_IN_BUFFER THEN
			ringBuffer[n] := n;	
		END_IF;
	END_FOR;
	_orderRing;
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Listen to requests and add to ring buffer.
	_ringBuffer;
	http_Client.send	:= EDGEPOS(httpState = HTTP_CLIENT_PROCESS_SEND );
	http_Client.abort	:= EDGEPOS(httpState = HTTP_CLIENT_ABORT);
	
	CASE httpState OF 
		
		HTTP_CLIENT_WAIT_FOR_COMMAND: // Order the ring buffer and wait for a new command to be processed.
			http_Client.enable := 0;
			retryCount := 0;
			httpComm ACCESS ADR(HTTP_Comm[0]);
			//Wait for next command from ring buffer
			IF(ringBuffer[0] = 0) AND (ringBuffer[1] > 0) THEN
				ringBuffer[0] := ringBuffer[1];	
				httpComm ACCESS ADR(HTTP_Comm[ringBuffer[0]]);
				httpComm.Status := HTTP_COMM_STATUS_IN_PROCESS;
				ringBuffer[1] := 0;
			ELSIF (ringBuffer[0] > 0) THEN
				httpState := HTTP_CLIENT_PROCESS_REQUEST;		
			END_IF;
								
			
		HTTP_CLIENT_PROCESS_REQUEST:
			http_Client.enable := 0;

			replyCode := 0;					
			status := HTTP_COMM_STATUS_IN_PROCESS;
			lastError := '';
			
			httpComm ACCESS ADR(HTTP_Comm[ringBuffer[0]]);
			
			//brsmemcpy(ADR(URL),ADR(BLANK_CHARACTER),SIZEOF(URL));
			brsmemset(ADR(URL),0,SIZEOF(URL));
			//URL := '';
			brsmemcpy(ADR(URL),httpComm.Command.Cmd_URL.Adr,httpComm.Command.Cmd_URL.Size);
			responseHeader := emptyResponseHeader;
			
			//Check for any overwrite of the host or header
			IF httpComm.Overwrite.RequestHeader THEN
				requestHeader.protocol 		:= httpComm.Overwrite.RequestHeader_Data.protocol; 
				requestHeader.contentType 	:= httpComm.Overwrite.RequestHeader_Data.contentType;
				requestHeader.connection 	:= httpComm.Overwrite.RequestHeader_Data.connection;
				requestHeader.keepAlive 	:= httpComm.Overwrite.RequestHeader_Data.keepAlive;	
			ELSE	
				requestHeader.protocol 		:= DEFAULT_REQUEST_HEADER.protocol; //'HTTP/1.1';
				requestHeader.contentType 	:= DEFAULT_REQUEST_HEADER.contentType;//'text/plain';
				requestHeader.connection 	:= DEFAULT_REQUEST_HEADER.connection;//'close';
				requestHeader.keepAlive 	:= DEFAULT_REQUEST_HEADER.keepAlive;//'max=100,timeout=5';	
			END_IF;		
			IF httpComm.Overwrite.Host THEN
				requestHeader.host 		:= httpComm.Overwrite.Host_Config.Host;
				http_Client.hostPort  	:= httpComm.Overwrite.Host_Config.Port;			
			ELSE
				requestHeader.host 		:= HTTP_Config.Host;
				http_Client.hostPort 	:= HTTP_Config.Port;
			END_IF;	
			
			requestHeader.contentLength 	:= httpComm.Command.Body_Data.Size;		
			http_Client.method 				:= httpComm.Command.Method;
			http_Client.pRequestData 		:= httpComm.Command.Body_Data.Adr;
			http_Client.requestDataLen 		:= httpComm.Command.Body_Data.Size;
			
			IF (httpComm.Command.ResponseData.Adr > 0) AND (httpComm.Command.ResponseData.Size > 0) THEN
				http_Client.pResponseData 	:= httpComm.Command.ResponseData.Adr;	
				http_Client.responseDataSize := httpComm.Command.ResponseData.Size; 
			ELSE
				http_Client.pResponseData := pTempMem;
				http_Client.responseDataSize := sizeTempMem;
			END_IF;	
			IF (http_Client.status = ERR_FUB_ENABLE_FALSE) AND (http_Client.phase = httpPHASE_NOT_CONNECTED) THEN 
				httpState := HTTP_CLIENT_PROCESS_ENABLE;
			END_IF;
			
		HTTP_CLIENT_PROCESS_ENABLE:	
			http_Client.enable := 1;
			IF (http_Client.status = ERR_OK) THEN
				CASE http_Client.phase OF
					httpPHASE_NOT_CONNECTED,httpPHASE_WAITING:	
						httpState := HTTP_CLIENT_PROCESS_SEND;
					
					httpPHASE_SENDING,httpPHASE_RECEIVING:	
						httpState := HTTP_CLIENT_PROCESS_WAIT_RESP;
					
					httpPHASE_RECEIVED:
						httpState := HTTP_CLIENT_PROCESS_SEND; // Received is the left over from the last successful send.
				END_CASE;
			END_IF;
				
		HTTP_CLIENT_PROCESS_SEND:
			http_Client.enable := 1;
			IF (http_Client.phase = httpPHASE_SENDING) THEN
				httpState := HTTP_CLIENT_PROCESS_WAIT_RESP;
			ELSIF (http_Client.status <> ERR_OK) AND (http_Client.status <> ERR_FUB_BUSY) THEN	
				httpState := HTTP_CLIENT_ABORT;
			ELSIF (http_Client.phase = httpPHASE_RECEIVED) AND (http_Client.httpStatus > 0) THEN
				httpState := HTTP_CLIENT_PROCESS_RESPONSE;
			END_IF;	
				
		
		HTTP_CLIENT_PROCESS_WAIT_RESP:
			http_Client.enable := 1;
			IF (http_Client.phase = httpPHASE_RECEIVED) THEN
				httpState := HTTP_CLIENT_PROCESS_RESPONSE;
			ELSIF (http_Client.status <> ERR_OK) AND (http_Client.status <> ERR_FUB_BUSY) THEN	
				httpState := HTTP_CLIENT_ABORT;
			END_IF;	
		
		
		HTTP_CLIENT_PROCESS_RESPONSE:
			http_Client.enable := 1;
			IF (http_Client.status = ERR_OK) THEN
				replyCode := http_Client.httpStatus;
				CASE http_Client.httpStatus OF
					200..207:
						IF (responseHeader.contentLength > 0) THEN
							IF (responseHeader.contentLength <= httpComm.Command.ResponseData.Size) THEN
								status := HTTP_COMM_STATUS_COMPLETE;
							ELSE
								status := HTTP_COMM_STATUS_ERROR;
								lastError := 'Response data area to small';
							END_IF;
						ELSIF ((httpComm.Command.Method = httpMETHOD_POST) OR (httpComm.Command.Method = httpMETHOD_PUT)) THEN
							status := HTTP_COMM_STATUS_COMPLETE;	
						END_IF;	
					300..307:
						//Implementation not done
						status := HTTP_COMM_STATUS_ERROR;
						lastError := responseHeader.status;
					400..426: //Errors
						status := HTTP_COMM_STATUS_ERROR;
						lastError := responseHeader.status;
					500..510://Server Errors
						status	:= HTTP_COMM_STATUS_ERROR;
						lastError 	:= responseHeader.status;
					ELSE
						httpState 	:= HTTP_CLIENT_ABORT;
				END_CASE;
			ELSIF (http_Client.status = httpERR_BUFFER_SIZE) THEN	// Response buffer is too small -- Abort and try again with temp memory area
				
			ELSIF (http_Client.status <> ERR_FUB_BUSY) THEN	//http client failure.
				itoa(http_Client.status,ADR(lastError));	
				httpState := HTTP_CLIENT_ABORT;
			END_IF;	
				
			IF (status <> HTTP_COMM_STATUS_IN_PROCESS) THEN
				httpState := HTTP_CLIENT_COMPLETE;	
			END_IF;
				
		HTTP_CLIENT_COMPLETE:
			count := count + 1;
			http_Client.enable := 0;
			httpComm.Status := status;
			httpComm.LastError := lastError;
			httpComm.ReplyCode := replyCode;
			ringBuffer[0] := 0;		
			httpState := HTTP_CLIENT_WAIT_FOR_COMMAND;
			
			
		HTTP_CLIENT_ABORT:
			http_Client.enable := 1;
			
			IF ((http_Client.status = ERR_OK) AND NOT http_Client.abort) THEN 
				IF (http_Client.phase = httpPHASE_WAITING) OR (http_Client.phase = httpPHASE_NOT_CONNECTED)  THEN
					IF (retryCount > 0) THEN
						httpState := HTTP_CLIENT_COMPLETE;	
						status := HTTP_COMM_STATUS_ERROR;
					ELSE
						retryCount := 1;	
						httpState := HTTP_CLIENT_PROCESS_REQUEST;
					END_IF;	
				ELSIF (http_Client.phase = httpPHASE_RECEIVED) THEN //???
					IF (retryCount > 0) THEN
						httpState := HTTP_CLIENT_COMPLETE;	
						status := HTTP_COMM_STATUS_ERROR;
					ELSE
						retryCount := 1;	
						httpState := HTTP_CLIENT_PROCESS_REQUEST;
					END_IF;	
				END_IF;	
			END_IF;
	END_CASE;
	
	http_Client();	
	
END_PROGRAM
PROGRAM _EXIT
	WHILE (http_Client.status <> ERR_OK) DO
		http_Client.enable := 1;
		http_Client.abort := 1;
		http_Client();
	END_WHILE;
		
END_PROGRAM

