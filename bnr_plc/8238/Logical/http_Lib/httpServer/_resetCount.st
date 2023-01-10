
ACTION _resetCount: 
	//{"id":1}
	IF (found = 0) AND (error = 0) THEN
		index := 0;
		cus := 0;

		error := 0;
		found := 0;
		//Set common parameters of the function.
		getParameterName.searchString := requestData;
		getParameterName.searchOffset := 0;
		getParameterName.searchEndProperty := STRING_DOLLAR;

		//Find the Index
		getParameterName.searchPropertyName := '"id":';
		getParameterName.searchEndProperty := '}';
		getParameterName();
		IF getParameterName.status = ERR_OK THEN
			index := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
			IF (index >= 0) AND (index <= MAX_STATIONS) THEN
				SortingBins.counting_frames[index].count := 0;
				found := found + 1;	
			ELSE
				error := 99;
				overRideData.responseHeader.status := '404 Not Found';
				responseData := 'Index out of range';
				httpServer.responseDataLen := LEN(responseData);
			END_IF;	
			
		ELSE
			error := 2;
		END_IF;	
	END_IF;
		
	sendResponse := (found > 0);
	errorResponse := (error > 0);
	
END_ACTION
