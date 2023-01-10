
(* FUB to Get parameter values set in URI or BODY... *)
FUNCTION_BLOCK httpGetParameter
	status := ERR_FUB_BUSY;
// Get the function Name from the URI
//Use the string length of the service name	+
	memset(ADR(outputValue),0,SIZEOF(outputValue));
	matchString := searchPropertyName;
	strcpy(ADR(inputData[0]),ADR(searchString));
	startoffset := searchOffset;
	endIndex := LEN(searchString);
	startPosition := 16#FFF; 
	IF endIndex > startoffset THEN
		FOR n := startoffset TO endIndex DO
			memcpy(ADR(search),ADR(inputData[n]),LEN(matchString));
			compare := 	strcmp(ADR(search),ADR(matchString));
			IF (compare = 0) THEN
				startPosition := n + LEN(matchString);
				EXIT;	
			END_IF;	
		END_FOR;
	ELSE
		status := 100;
	END_IF;
	
	IF (startPosition <> 16#FFF) THEN
		//Get the End Position
		matchString := searchEndProperty;
		memset(ADR(search),0,SIZEOF(search));
		startoffset := startPosition;
		IF endIndex >= startoffset THEN
			FOR n := startoffset TO endIndex DO
				memcpy(ADR(search),ADR(inputData[n]),LEN(matchString));
				compare := 	strcmp(ADR(search),ADR(matchString));
				length := n - startPosition;
				IF (compare = 0) THEN
					EXIT;	
				END_IF;	
			END_FOR;
			outputValue := MID(searchString,length,startPosition + 1);
			postionFound := n;
			status := ERR_OK;
		ELSE
			status := 102;
		END_IF;
	ELSE
		outputValue := '';
		status := 101;
	END_IF;	
	
	
	
	
END_FUNCTION_BLOCK
