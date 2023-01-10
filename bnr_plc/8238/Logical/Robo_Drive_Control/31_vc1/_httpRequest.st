
ACTION _httpRequest: 
	
	CASE HTTP_Comm[myHttp].Status OF
		
		HTTP_COMM_STATUS_DISABLED:
			
			//Build Request String..
			requestURL := HTTP_IF_CALL_USP_NOREPLY_URL;
			itoa(Bag[myBag].Mis,ADR(batchString));
			itoa(Bag[myWeighBag].Wgt,ADR(weightString));	
			//Bag[myBag].Wgt := Bag[myWeighBag].Wgt;
			
			requestData := CONCAT(HTTP_POST_BATCH_UPDATE_DRY_WGT,'@BatchID_Int=');
			requestData := CONCAT(requestData,batchString);
			requestData := CONCAT(requestData,',@DryWeight=');
			requestData := CONCAT(requestData,weightString);

			HTTP_Comm[myHttp].Command.Method := httpMETHOD_POST;
			HTTP_Comm[myHttp].Command.Cmd_URL.Adr := ADR(requestURL);
			HTTP_Comm[myHttp].Command.Cmd_URL.Size := LEN(requestURL);
			HTTP_Comm[myHttp].Command.Body_Data.Adr := ADR(requestData);
			HTTP_Comm[myHttp].Command.Body_Data.Size := strlen(ADR(requestData));
			HTTP_Comm[myHttp].Command.ResponseData.Adr := 0;
			HTTP_Comm[myHttp].Command.ResponseData.Size := 0;
			HTTP_Comm[myHttp].Status := HTTP_COMM_STATUS_ACTIVE_WAIT_BUF;
		
		HTTP_COMM_STATUS_ACTIVE_WAIT_BUF:
		//Command is sent to ring buffer.
		HTTP_COMM_STATUS_IN_BUFFER:
		//Command recieved and in ring buffer
		HTTP_COMM_STATUS_IN_PROCESS:
		//Command being processed by httpClient.
		HTTP_COMM_STATUS_COMPLETE:
			httpComplete := 1;
			//HTTP_Comm[myHttp].Status := HTTP_COMM_STATUS_DISABLED;				
		HTTP_COMM_STATUS_ERROR: // Go to next index
			HTTP_Comm[myHttp].Status := HTTP_COMM_STATUS_DISABLED;		
			
	END_CASE;
	
	
END_ACTION
