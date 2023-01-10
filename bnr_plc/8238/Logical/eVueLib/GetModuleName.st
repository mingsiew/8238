
(* TODO: Add your comment here *)
FUNCTION_BLOCK GetModuleName
	

	IF NOT enable THEN
		state := 0;
	END_IF;	

	IF (state = 0) THEN // Not ENABLED
		IF enable THEN 
			state := 1;	
			pointer := 0;
		ELSE	
			status := ERR_FUB_ENABLE_FALSE;	
		END_IF;
	END_IF;	

	
	IF (state = 1) THEN // get pointer to iom file so we can interate through the string. 	
		brsstrcpy(ADR(moduleAddress),ADR('"'));
		brsstrcat(ADR(moduleAddress),pModuleAddress);
		brsstrcat(ADR(moduleAddress),ADR('"'));
		brsmemset(ADR(searchString),0,SIZEOF(searchString));
		brsmemset(ADR(ModuleName),0,SIZEOF(ModuleName));
		searchLen := LEN(moduleAddress);
		mO_info(enable := (searchLen > 0), pName := ADR('arconfig'), grp := 0);
		IF ((searchLen <= 2) OR (searchLen > SIZEOF(searchString))) THEN
			state := 100;
			status := 101;
		ELSIF (mO_info.status = ERR_OK) THEN
			state := state := 2;
		ELSIF (mO_info.status <> ERR_FUB_BUSY) THEN
			status := mO_info.status; 
			state := 100;
		END_IF;		
	END_IF;	
		
	//iterate through the string until we find our address
	scanCount := 0;
	WHILE ((pointer < (mO_info.size - searchLen)) AND (scanCount <= 50000) AND (state = 2)) DO 
		scanCount := scanCount + 1;  
		brsmemcpy(ADR(searchString),(mO_info.address + pointer),searchLen);
		IF (searchString = moduleAddress) THEN
			brsmemset(ADR(searchString),0,SIZEOF(searchString));
			foundCount := foundCount + 1;
			state := 3;
		END_IF;
		pointer := pointer + 1;
		IF (pointer = (mO_info.size - searchLen)) THEN
			state := 20; // NOT FOUND
		END_IF;
	END_WHILE;

	// Iterate back through the string to find the module Name
	scanCount := 0;
	WHILE ((pointer > 0) AND (pointer < (mO_info.size - 1)) AND (scanCount <= 200) AND (state = 3)) DO 
		scanCount := scanCount + 1;  
		pointer := pointer + 1;
		brsmemcpy(ADR(searchString),(mO_info.address + pointer),42);
		IF (searchString = '<Parameter ID="HardwareModuleName" Value="')THEN
			brsmemset(ADR(searchString),0,SIZEOF(searchString));
			pointer := pointer + 42;	
			start := pointer;					
			state := 4;
		END_IF;
		IF (pointer = 0) OR (pointer = (mO_info.size - 1)) OR (scanCount = 200) THEN
			state := 100; // ERROR;
			status := 103;
		END_IF;
	END_WHILE;
	
	// Iterate back through the string to find the module Name
	scanCount := 0;
	WHILE ((pointer > 0) AND (pointer < (mO_info.size - 1)) AND (scanCount <= 100) AND (state = 4)) DO 
		scanCount := scanCount + 1;  
		pointer := pointer + 1;
		brsmemcpy(ADR(searchString),(mO_info.address + pointer),1);
		IF (searchString = '"')THEN
			end := pointer;					
			state := 5;
		END_IF;
		IF (pointer = 0) OR (pointer = (mO_info.size - 1)) OR (scanCount = 100) THEN
			state := 100; // ERROR;
			status := 104;
		END_IF;
	END_WHILE;

	IF (state = 5) THEN
		// Get the Name
		IF ((end - start) <= SIZEOF(ModuleName)) THEN
			brsmemset(ADR(ModuleName),0,SIZEOF(ModuleName));
			brsmemcpy(ADR(ModuleName),mO_info.address + start, end - start);	 
			state := 10;
		ELSE
			state := 100;
			status := 105;
		END_IF;	
	END_IF;
		
	IF (state = 10) THEN// Complete	
	
	END_IF;
		
	IF (state = 20) THEN // NOT FOUND		
	
	END_IF;	
	
	IF (state = 100) THEN // ERROR	
		state := 0;	
	END_IF;

	IF (state = 10) THEN
		status := ERR_OK;
		state := 0;
	ELSIF (state = 20) THEN // NOT FOUND		
		status := 200; // NOT FOUND
		state := 0;
	ELSIF (state > 0) AND (state < 100) THEN	
		status := ERR_FUB_BUSY;
	END_IF;	

END_FUNCTION_BLOCK
