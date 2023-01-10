
ACTION _vcCommand: 
	//IF VC_Command[1] = VC_CMD_NOTHING THEN
		getParameterName.searchString := requestData;
		getParameterName.searchPropertyName := 'command":"';
		getParameterName.searchEndProperty := '"';
		getParameterName.searchOffset := 0;
		getParameterName();
		IF (getParameterName.status = ERR_OK) THEN	
			IF getParameterName.outputValue = 'get-empty-bag' THEN				
				VC_Command[1] := VC_CMD_GOTO_EMPTY;		
			ELSIF getParameterName.outputValue = 'bag-removed' THEN				
				VC_Command[1] := VC_CMD_BAG_REMOVED_CONFIRM;	
			ELSIF getParameterName.outputValue = 'load-maintenance-bag' THEN				
				VC_Command[1] := VC_CMD_LOAD_MAINT_BAG;	
			ELSIF getParameterName.outputValue = 'go-to-loading' THEN				
				VC_Command[1] := VC_CMD_GOTO_LOADING;	
			ELSE
				errorResponse 	:= 1;
			END_IF;	
		ELSE	
			errorResponse := 1;	
		END_IF;	
//WE NEED TO HAVE A COMMAND RESPONSE SO WE CAN SEND THE CORRECT RESPONSE TO THE DISPLAY>>>	
	
//	ELSE		
//		IF (D[903] = 8) THEN
			sendResponse := 1;
//		ELSIF VC_Command[1] = VC_CMD_FAIL THEN
//			sendResponse := 1;
//			overRideData.responseHeader.status := '409 Conflict';
//		END_IF;
//	END_IF;	
END_ACTION
