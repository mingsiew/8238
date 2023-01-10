
ACTION _apiFunctions: 
	IF activeFunction = 0 THEN _getFunctionName; END_IF;
	//Exectute the Function 	
	CASE activeFunction OF
		HTTP_SVR_FNC_NOT_FOUND: //Nothing
			sendResponse := 1;
			memset(ADR(responseData),0,SIZEOF(responseData));//Clear responseData
			responseData := 'error Function Not found, Function Must be specified with function=';
			httpServer.responseDataLen := LEN(responseData);
			
		HTTP_SVR_GET_FNC_SET_BAG_DEST: //Set Bag Destination -- 1
		//				_setBagDestination;
		HTTP_SVR_GET_FNC_TEST://Test
			sendResponse := 1;
			memset(ADR(responseData),0,SIZEOF(responseData));//Clear responseData
			responseData := 'Test Get';
			httpServer.responseDataLen := LEN(responseData);
			
		HTTP_SVR_POST_FNC_TEST:
			//sendResponse := 1;
			memset(ADR(responseData),0,SIZEOF(responseData));//Clear responseData
			responseData := 'Test Post';
			httpServer.responseDataLen := LEN(responseData);
			
			
		HTTP_SVR_GET_FNC_RESTART_PLC:
			sendResponse := 1;
			memset(ADR(responseData),0,SIZEOF(responseData));//Clear responseData
			responseData := 'PLC will carry out a warm restart';
			httpServer.responseDataLen := LEN(responseData);
			IF httpServer.phase = 4 THEN //Wait for response to be sent
				SYSreset(TRUE,1); //Restart PLC
			END_IF;
				

			

			
	END_CASE	

END_ACTION
