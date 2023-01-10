
ACTION _setBagDestination: 

	mis := 0;
	bagIndex := 0;
	dst := 0;
	error := 0;
	
	
	//Set common parameters of the function.
	getParameterName.searchString := requestData;
	getParameterName.searchOffset := 0;
	getParameterName.searchEndProperty := STRING_DOLLAR ;
	
	//Get Mis Parameter
	getParameterName.searchPropertyName := 'mis=';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		mis := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
	ELSE
		error := 1;	
	END_IF;	
	
	//Get bag index Parameter
	getParameterName.searchPropertyName := 'bagindex=';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		bagIndex := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
	ELSE
		error := 2;		
	END_IF;	
	
	//Get Destination
	getParameterName.searchPropertyName := 'dest=';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		dst := DINT_TO_USINT(atoi(ADR(getParameterName.outputValue)));
	ELSE
		error := 3;	
	END_IF;	
	
	CASE error OF
		0:// No Errors SEND //Check bag is correct.
			IF (bagIndex <= MAX_BAGS) THEN
				IF Bag[bagIndex].Cat > 0 THEN
					IF Bag[bagIndex].Mis = mis THEN
						IF dst <= MAX_LINES THEN
							Bag[bagIndex].Dst := dst;
							responseData := getParameterName.outputValue;
						ELSE
							responseData := 'error bag destination out of range';
						END_IF;	
					ELSE
						responseData := 'error bag index and mis don;t match';
					END_IF;
				ELSE
					responseData := 'error bag at bag index is not valid - No Category';
				END_IF;	
			ELSE	
				responseData := 'error Bag index greater then bags';
			END_IF;		
		1: //Mis Param not found	
			responseData := 'error mis parameter not found';	
		2: //bagindex Param not found	
			responseData := 'error bagindex parameter not found';	
		3: //Dest Param not found	
			responseData := 'error dest parameter not found';	
	END_CASE;				

	sendResponse := 1;
	httpServer.responseDataLen := LEN(responseData);

END_ACTION
