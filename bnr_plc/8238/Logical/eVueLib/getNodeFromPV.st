
(* Get Node and Connection string from a PV var. *)
FUNCTION_BLOCK getNodeFromPV

	IF NOT enable THEN
		state := 0;
	END_IF;	

	IF (state = 0) THEN // Not ENABLED
		IF enable THEN 
			state := 1;	
			pointer := 0;
			IF_Adr := '';
			NodeNumber := 0;
			brsmemset(ADR(searchString),0,SIZEOF(searchString));
		ELSE
			status := ERR_FUB_ENABLE_FALSE;	
		END_IF;
	END_IF;		
	
	
	
	IF (state = 1) THEN // get pointer to iom file so we can interate through the string. 
		searchLen := LEN(pvName);
		mO_info(enable := (searchLen > 0), pName := ADR('iomap'), grp := 0);
		IF ((searchLen = 0) OR (searchLen > SIZEOF(searchString))) THEN
			state := 100;
			status := 101;
		ELSIF (mO_info.status = ERR_OK) THEN
			state := state := 2;
		ELSIF (mO_info.status <> ERR_FUB_BUSY) THEN
			status := mO_info.status; 
			state := 100;
		END_IF;		
	END_IF;	
		
	//iterate through the string until we find our var name	
	scanCount := 0;
	WHILE ((pointer < (mO_info.size - searchLen)) AND (scanCount <= 50000) AND (state = 2)) DO 
		scanCount := scanCount + 1;  
		brsmemcpy(ADR(searchString),(mO_info.address + pointer),searchLen);
		IF (searchString = pvName) THEN
			brsmemset(ADR(searchString),0,SIZEOF(searchString));
			state := 3;
		END_IF;
		pointer := pointer + 1;
		IF (pointer = (mO_info.size - searchLen)) THEN
			state := 20; // NOT FOUND
		END_IF;
	END_WHILE;
		
	
	// Iterate back through the string to find the start of the node
	scanCount := 0;
	WHILE ((pointer > 0) AND (pointer < (mO_info.size - searchLen)) AND (scanCount <= 250) AND (state = 3)) DO 
		scanCount := scanCount + 1;  
		pointer := pointer - 1;
		brsmemcpy(ADR(searchString),(mO_info.address + pointer),2);
		IF (searchString = 'ST') THEN
			startNode := pointer + 2;				
			brsmemset(ADR(searchString),0,SIZEOF(searchString));
			state := 4;
		END_IF;
		IF (pointer = 0) OR (scanCount = 250) THEN
			state := 100; // ERROR;
			status := 103;
		END_IF;
	END_WHILE;

	
	// Iterate back through the string to find the start of the path
	scanCount := 0;
	WHILE ((pointer > 0) AND (pointer < (mO_info.size - searchLen)) AND (scanCount <= 250) AND (state = 4)) DO 
		scanCount := scanCount + 1;  
		pointer := pointer - 1;
		brsmemcpy(ADR(searchString),(mO_info.address + pointer),2);
		IF (searchString = '="') THEN
			startPath := pointer + 2;
			pointer := startNode; 
			brsmemset(ADR(searchString),0,SIZEOF(searchString));
			state := 5;
		END_IF;
		IF (pointer = 0) OR (scanCount = 250) THEN
			state := 100; // ERROR;
			status := 104;
		END_IF;
	END_WHILE;

	// Iterate back through the string to find the end of the node	
	scanCount := 0;
	WHILE ((pointer > 0) AND (pointer < (mO_info.size - 1)) AND (scanCount <= 250) AND (state = 5)) DO 
		scanCount := scanCount + 1;  
		pointer := pointer + 1;
		brsmemcpy(ADR(searchString),(mO_info.address + pointer),1);
		IF (searchString = '"') OR (searchString = '.') THEN
			endNode := pointer;					
			state := 6;
		END_IF;
		IF (pointer = 0) OR (pointer = (mO_info.size - 1)) OR (scanCount = 250) THEN
			state := 100; // ERROR;
			status := 105;
		END_IF;
	END_WHILE;
	
	IF (state = 6) THEN
		brsmemset(ADR(IF_Adr),0,SIZEOF(IF_Adr));	
		brsmemcpy(ADR(IF_Adr),mO_info.address + startPath, startNode - 3 - startPath);
		IF (LEFT(IF_Adr,1) = '%') THEN
			 IF_Adr := RIGHT(IF_Adr,(LEN(IF_Adr) - 4));
		END_IF;	
		// Get the Node
		brsmemset(ADR(nodeString),0,SIZEOF(nodeString));
		brsmemcpy(ADR(nodeString),mO_info.address + startNode, endNode - startNode);	 
		NodeNumber := DINT_TO_USINT(atoi(ADR(nodeString)));
		state := 10;
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
