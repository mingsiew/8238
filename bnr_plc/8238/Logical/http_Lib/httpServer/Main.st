//V2.00.1 -- TR. First release using version numbering
//V2.00.2 -- TR. Remove old http server functions FOR ABB settings as vars have been removed
//		  -- FIX: 200 OK could be returned in error
//V2.00.3 -- ADD: Load new configuration file command
//V2.00.4 -- REMOVE: Clear up old API Calls
//V2.00.5 -- Add Discharger Displays
//V2.00.6 -- ADD Part load and ABB Manual Controls (NEEDS ABB DRIVER 3.00.2)
//V2.00.7 -- ADD more functionality to ABB Manual Controls (Command and Direction) 
//V3.00.1 -- Standardise the response data from LiveData displays
//V3.00.2 -- ADD Update var by name endpoint
//V3.00.3 -- FIX - Range issues in updateVarByName - ADD HTTP CALLS FOR PLC-CONFIG.Web

//V9.99.9  -- Special version for NEDLIN

PROGRAM _INIT
	serviceName := 'supertrackPLC.api';
	httpServer.pServiceName := ADR(serviceName);
	httpServer.pUri := ADR(URI);	
	httpServer.uriSize := SIZEOF(URI);
	httpServer.pRequestHeader := ADR(requestHeader);	
	httpServer.pRequestData := ADR(requestData);	
	httpServer.requestDataSize := SIZEOF(requestData);	
	httpServer.pResponseHeader := ADR(responseHeader);	
	
	
	httpServer.pStatistics := ADR(Statistics);
		
	httpServer.option := httpOPTION_HTTP_11 + httpOPTION_SERVICE_TYPE_ROOT; //HTTP 1.1	
	httpServer.enable := 0;
	

	
END_PROGRAM


PROGRAM _CYCLIC
	
	_httpServer;
	
	wait(CLK := (httpServer.phase = httpPHASE_SENDING));
	recv(CLK := (httpServer.phase = httpPHASE_RECEIVED));	
	IF wait.Q THEN
		memset(ADR(responseData),0,SIZEOF(responseData));//Clear responseData
		memset(ADR(responseDataBinary),0,SIZEOF(responseDataBinary));
		found	:= 0;
		error := 0;
	END_IF;
	
	IF EDGEPOS(recieved) THEN
		requestArriveTime := CurrentTimestamp; // Get time stamp when the request arrives.
	END_IF;	
	
	IF recieved THEN//recv.Q THEN
		//Get the API!	
		api := FindAPI(URI,serviceName);

		CASE api OF
			
			API_UNKNOWN:
				errorResponse := 1;
				overRideData.responseHeader.status := '501 Not Implemented';
				responseData := 'Unknown API';
				httpServer.responseDataLen := LEN(responseData);	
			
//			API_MAINTENANCE_CONFIRM_REENTRY:
//				sendResponse := 1;	
			
			API_ST_FUNCTIONS://Legacy function => ?function=xxx
				_apiFunctions;


			
//			API_DISCHARGER_SUBMIT:
//				
//				getParameterName.searchString := requestData;
//				getParameterName.searchOffset := 0;
//				getParameterName.searchEndProperty := STRING_DOLLAR;
//				//Find the first part of the array in JSON
//				getParameterName.searchPropertyName := 'playId":"';
//				getParameterName.searchEndProperty := '",';
//				getParameterName();
//				IF (getParameterName.status = ERR_OK) THEN
//					index := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));	
//					IF (index <= MAX_DISPLAYS) THEN
//						LiveData_Recv[index].Submit_Discharger := 1;
//					END_IF;
//					sendResponse := 1;		
//				ELSE
//					errorResponse := 1;
//					overRideData.responseHeader.status := '404 Not Found';
//					responseData := 'Unknown display';
//					httpServer.responseDataLen := LEN(responseData);	
//				END_IF;	
	
//			API_ABB_MANUAL_CMD:
//				_abbManual;
//
//			API_CUSTOMER_CHANGE:	
//				_customerChange;	
//				
//			API_LOADING_SUBMIT:
//				_getLoadingSubmit;
//				
//			API_LOADING_NEWDATA:
//				_getLoadingData;
//				
//			API_LOADING_WITH_TOUR_SUBMIT:	
//				_getTourLoadingSubmit;
//				
//			API_LOADING_WITH_TOUR_NEWDATA:
//				_getTourLoadingData;
//			
//			API_UPDATE_VAR_BY_NAME:
//				_updateVarByName;	
//			
//			API_CONFIG_LOAD_NEW: // Request to load new configuration.
//				IF (Configuration.Interface.Status.LastLoaded >= requestArriveTime)  THEN // Send 200 OK when we see that the configuration is newer than the previous
//					sendResponse := 1;
//				ELSIF Configuration.Interface.Status.Error THEN
//					errorResponse := 1;
//					overRideData.responseHeader.status := '500 Internal Server Error';
//					responseData := 'Failed to load file';			
//					httpServer.responseDataLen := LEN(responseData);		
//				ELSIF NOT Configuration.Interface.Cmd.Load AND (Configuration.Interface.Status.LastLoaded < requestArriveTime) THEN
//					Configuration.Interface.Cmd.Load := 1;
//					debugCount := debugCount + 1;
//				END_IF;	
//			
//			API_CONFIG_SAVE:
//			
//				IF (Configuration.Interface.Status.LastSaved >= requestArriveTime)  THEN // Send 200 OK when we see that the configuration is newer than the previous
//					sendResponse := 1;
//				ELSIF Configuration.Interface.Status.Error THEN
//					errorResponse := 1;
//					overRideData.responseHeader.status := '500 Internal Server Error';
//					responseData := 'Failed to save file';			
//					httpServer.responseDataLen := LEN(responseData);	
//				ELSIF NOT Configuration.Interface.Cmd.Save AND (Configuration.Interface.Status.LastSaved < requestArriveTime) THEN
//					Configuration.Interface.Cmd.Save := 1;
//				END_IF;	
			
			
			API_NEDLIN_GET_CSP_DATA: // Get the current CSP data status.
				length := SIZEOF(CSP);
				overRideData.responseHeader.contentType := 'nothing';
				brsmemcpy(ADR(responseDataBinary),ADR(CSP),length);
				overRideData.responseDataLen := length;
				sendResponse := 1;	
				sendBinaryData := 1;
			
			
			API_NEDLIN_SET_CSP_DATA: //  Set the incoming customers 
				_nedlinSetCustomer;
			
			API_RESET_SORTING_COUNT:
				_resetCount;
			
			
		END_CASE;
	ELSE		
		api := 0;
		activeFunction := 0;
	END_IF;
	
END_PROGRAM

PROGRAM _EXIT
	//Disable the Server on Exit..
	httpServer.enable := 0;	
	httpServer();
END_PROGRAM
