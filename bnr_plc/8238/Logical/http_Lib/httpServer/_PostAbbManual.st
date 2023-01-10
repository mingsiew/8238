
ACTION _abbManual: 
	//'{"belt":1,"speed":25,"direction":0,"command":1}'
	belt 		:= 0;
	velocity 	:= 0;
	direction 	:= 0;
	command 	:= 0;	
	
	error := 0;
	found := 0;
	//Set common parameters of the function.
	getParameterName.searchString := requestData;
	getParameterName.searchOffset := 0;
	getParameterName.searchEndProperty := STRING_DOLLAR;

	//Find the id
	getParameterName.searchPropertyName := '"belt":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		belt := DINT_TO_USINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := getParameterName.nextPosition;
	ELSE
		error := 1;
	END_IF;	
	

	//set the velocity
	getParameterName.searchPropertyName := '"speed":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		velocity := DINT_TO_INT(atoi(ADR(getParameterName.outputValue)));
	ELSE
		error := 2;
	END_IF;	

	//set the direction
	getParameterName.searchPropertyName := '"direction":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		direction := DINT_TO_USINT(atoi(ADR(getParameterName.outputValue)));
	ELSE
		error := 3;
	END_IF;	
	
	
	getParameterName.searchPropertyName := '"command":';
	getParameterName.searchEndProperty := '}';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		command := DINT_TO_USINT(atoi(ADR(getParameterName.outputValue)));
		IF (belt <= MAX_DRIVES) THEN
			CASE command OF
			
			1://Manual Reset	
				ABB_EPL.Drives[belt].Manual.tof_run.IN := (velocity > 0);
				ABB_EPL.Drives[belt].Manual.Velocity := velocity;
				ABB_EPL.Drives[belt].Manual.Direction := direction;
			2: //Future Error Reset
					
				
			END_CASE;		
			found := 1;
		ELSE
			error := 3;
		END_IF;	
		
	ELSE
		error := 2;
	END_IF;	
	
	
	
	sendResponse := (found > 0);
	errorResponse := (error > 0);
	
	
END_ACTION
