
ACTION _setBeltConfig: 

	bagIndex := 0;
	prg	:= 0;
	cat := 0;
	cus := 0;
	dst := 0;
	error := 0;
	found := 0;
	//Set common parameters of the function.
	getParameterName.searchString := requestData;
	getParameterName.searchOffset := 0;
	getParameterName.searchEndProperty := STRING_DOLLAR;
	REPEAT  

		//Find the first part of the array in JSON
		getParameterName.searchPropertyName := '{';
		getParameterName.searchEndProperty := '"';
		getParameterName();
		IF (getParameterName.status = ERR_OK) THEN
			getParameterName.searchOffset := DINT_TO_UINT(getParameterName.nextPosition);	
		ELSE
			error := 1;
		END_IF;	
		
		//Find the category
		getParameterName.searchPropertyName := '"category":';
		getParameterName.searchEndProperty := ',';
		getParameterName();
		IF getParameterName.status = ERR_OK THEN
			cat := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
		ELSE
			error := 2;
		END_IF;	

		//Find the customer
		getParameterName.searchPropertyName := ',"customer":';
		getParameterName.searchEndProperty := ',';
		getParameterName();
		IF getParameterName.status = ERR_OK THEN
			cus := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
		ELSE
			error := 2;
		END_IF;	
		
		
		//Find the program
		getParameterName.searchPropertyName := '"program":';
		getParameterName.searchEndProperty := '}';
		getParameterName();
		IF getParameterName.status = ERR_OK THEN
			prg := DINT_TO_USINT(atoi(ADR(getParameterName.outputValue)));
			CASE found OF
				0:
					bag ACCESS ADR(Bag[340]);
				1:
					bag ACCESS ADR(Bag[364]);
				2:
					bag ACCESS ADR(Bag[350]);
			END_CASE;	
			IF (found >= 0) AND (found <= 2) THEN	
				found := found + 1;	
				bag.Cat := cat;	
				bag.Prg := prg;
				bag.Cus := cus;
				bag.Dst := dst;
			ELSE
				error := 7;	
			END_IF;	
		ELSE
			error := 3;
		END_IF;	
		

	UNTIL ((error > 0) OR (found > 2))
	END_REPEAT;
	
	sendResponse := (found > 0);
	errorResponse := (error > 0);
	
END_ACTION
