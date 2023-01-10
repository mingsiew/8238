//0, 15// Derived data types Data types declared with the construction TYPE...END_TYPE [1], [2]					
//1:// BOOL 8-bit containing a boolean value FALSE=0 OR TRUE=1
//2:// SINT 8-bit signed integer
//3:// INT 16-bit signed integer			
//4:// DINT 32-bit signed integer
//5:// USINT 8-bit unsigned integer
//6:// UINT 16-bit unsigned integer
//7:// UDINT 32-bit unsigned integer	
//8:// REAL 32-bit floating point number		
//9:// STRING Variable-length single-byte character string			 
//10:// ULINT 	64-bit unsigned integer		 
//11:// DATE_AND_TIME 32-bit date in seconds since 01/01/1970 00:00:00			
//12:// TIME 32-bit time in ms				 
//13:// DATE 32-bit date (only)				
//14:// LREAL 64-bit floating point number				
//16:// TIME_OF_DAY 32-bit time OF day (only)				 
//17:// BYTE 	Bit string OF length 8			
//18:// WORD Bit string OF length 16					 
//19:// DWORD Bit string OF length 32
//20:// LWORD Bit string OF length 64				 
//21:// WSTRING Variable-length double-byte character string 				
//23:// LINT 	64-bit signed integer

ACTION _updateVarByName: 

//{"varName":"xxx","value":10}	
//{"varName":"xxx","value":"stringValue"}
scanCount := 0;	
WHILE (scanCount <= 19) AND NOT sendResponse AND NOT errorResponse DO
	scanCount := scanCount + 1; //Supercharge peformance by doing 20 scans per cycle

	CASE setValue OF

		0:// init search vars
			searchOffset := 0;	
			//Create a FIFO to write our values into so we can commit them on success!!	
			arrayEnd := FIND(requestData,'}]');// Be sure to check for end ] or we could get errors updating arrays.
			error := 0;
			setValue := 1;
			pos1 := 0;	
			pos2 := 0;
			
		1:// create fifo to write data into.	
			createFifo.enable := 1;
			createFifo.mode := fifoMODE_WRITE_UNTIL_FULL;
			createFifo.size := LEN(requestData);
			createFifo.pFifo := ADR('update-by-name-list');
			createFifo();
			IF (createFifo.status = ERR_OK) THEN
				setValue := 4;	
			ELSIF (createFifo.status = fifoERR_FIFO_ALREADY_EXISTS) THEN	
				setValue := 2;
			ELSIF (createFifo.status <> ERR_FUB_BUSY) THEN
				setValue := 100;
				status := 94;
			END_IF;	
	
		2:// get ident if fifo already exists	
			fi_status := fifoGetIdent(createFifo.pFifo,ADR(createFifo.ident));
			IF fi_status = ERR_OK THEN
				setValue := 3;
			ELSE	
				setValue := 100;
				status := 94;
			END_IF;
		
		3:// Clear the FIFO if it already exists
			clearFifo.enable := 1;
			clearFifo.ident := createFifo.ident;
			clearFifo();
			IF clearFifo.status = ERR_OK THEN
				setValue := 4;
			ELSIF (clearFifo.status <> ERR_FUB_BUSY) THEN
				setValue := 100;
				status := 94;
			END_IF;
		
		4:// Validate the json, make sure if we have a [
			IF (arrayEnd > 0) THEN	
				IF FIND(requestData,'[{') > 0 THEN
					setValue := 5; //Array start and end found
				ELSE
					setValue := 100;
					status := 95;
				END_IF;	
			ELSE
				IF FIND(requestData,'[{') = 0 THEN
					setValue := 5; //Array start and end not found
				ELSE
					setValue := 100;
					status := 95;
				END_IF;	
			END_IF;		
		
		5://find the order of the parameters in the request sting.		
			found 	:= 0;
			getParameterName.searchString := requestData;	
			IF (pos1 = 0) THEN	
				pos1 := FIND(requestData,SEARCH_STRING_VAR_NAME);	
				pos2 := FIND(requestData,SEARCH_STRING_VAR_VALUE);
			END_IF;
			IF (pos1 = 0) OR (pos2 = 0) THEN	
				setValue := 100;
				status := 93;
			ELSIF (pos1 > pos2) THEN	
				setValue := 6;	
			ELSE	
				setValue := 8;	
			END_IF;		
	
		6:// find the value first	
			value 	:= '';
			isString := 0;	
			getParameterName.searchPropertyName := SEARCH_STRING_VAR_VALUE;
			getParameterName.searchEndProperty := ',';
			getParameterName.searchOffset := searchOffset;	
			getParameterName();
			IF getParameterName.status = ERR_OK THEN
				searchOffset := getParameterName.nextPosition;
				//If we have been passed a string remove the ""
				IF LEFT(getParameterName.outputValue,1) = '"' THEN
					isString := 1;
					value := MID(getParameterName.outputValue,(LEN(getParameterName.outputValue) - 2),2);
				ELSE	
					value := getParameterName.outputValue; 
				END_IF;
				setValue := 7;	
			ELSE
				setValue := 100;
				status := 2;
			END_IF;			
			
		7:// find the name 2nd
			varName := '';	
			found 	:= 0;
			//Set common parameters of the function.
		
			getParameterName.searchOffset := searchOffset;
			//Find the id
			getParameterName.searchPropertyName := SEARCH_STRING_VAR_NAME;
			getParameterName.searchEndProperty := '"';
			getParameterName();
			IF getParameterName.status = ERR_OK THEN
				varName := getParameterName.outputValue;
				searchOffset := getParameterName.nextPosition;
				setValue := 10;	
			ELSE
				setValue := 100;
				status := 1;
			END_IF;		

		8:// find the first param
	
			varName := '';	
			getParameterName.searchOffset := searchOffset;
			//Find the id
			getParameterName.searchPropertyName := SEARCH_STRING_VAR_NAME;
			getParameterName.searchEndProperty := '"';
			getParameterName();
			IF getParameterName.status = ERR_OK THEN
				varName := getParameterName.outputValue;
				searchOffset := getParameterName.nextPosition;
				setValue := 9;	
			ELSE
				setValue := 100;
				status := 1;
			END_IF;		
	
		
		9:// find the 2nd param		
			value 	:= '';
			isString := 0;		
			getParameterName.searchPropertyName := SEARCH_STRING_VAR_VALUE;
			getParameterName.searchEndProperty := '}';
			getParameterName.searchOffset := searchOffset;	
			getParameterName();
			IF getParameterName.status = ERR_OK THEN
				searchOffset := getParameterName.nextPosition;
				//If we have been passed a string remove the ""
				IF LEFT(getParameterName.outputValue,1) = '"' THEN
					isString := 1;
					value := MID(getParameterName.outputValue,(LEN(getParameterName.outputValue) - 2),2);
				ELSE	
					value := getParameterName.outputValue; 
				END_IF;
				setValue := 10;	
			ELSE
				setValue := 100;
				status := 2;
			END_IF;		


		10: //get the ident	

			//status := PV_ident(ADR(varName),1,0,ADR(ident));
			status := PV_xgetadr(ADR(varName),ADR(pv_adr),ADR(pv_len));
			IF (status = ERR_OK) THEN
				setValue := 11;	
			ELSIF (status <> ERR_FUB_BUSY) THEN	
				IF (status = 14710) THEN
					overRideData.responseHeader.status := '404 Not Found';	
					responseData := 'PV Not found';
					httpServer.responseDataLen := LEN(responseData);	
				END_IF;
				setValue := 100;//
			END_IF;	

		11: // Get the data type so we can scale correctly 
			status := PV_ninfo(ADR(varName),ADR(pv_type),ADR(pv_length),ADR(pv_dimension));
			IF (status = ERR_OK) THEN
				setValue := 12;	
			ELSIF (status <> ERR_FUB_BUSY) THEN	
				setValue := 100;//
			END_IF;	

		12: // Found update the value	
			//Type 0 or 15 is part of a type not a var name.
			//We must also check the dimension is 1 or we are trying to update the root of an array.
			//TEMP INCASE OF MALFORM JSON
			//			IF (isString AND (pv_type <> 9)) THEN		
			//				isString := 0;
			//			END_IF;
				
			stringCheck := (NOT isString AND (pv_type <> 9)) OR (isString AND (pv_type = 9)); // We have to modify this if we want to support strings other than STRING	
			IF (pv_dimension = 1) AND stringCheck THEN
				num_Val := atoi(ADR(value));
				CASE pv_type OF
					0,15:// Derived data types Data types declared with the construction TYPE...END_TYPE [1], [2]
						status := 99; 	
						setValue := 100;
					1:// BOOL
						IF (num_Val >= 0) AND (num_Val <= 1) THEN 
							pData := ADR(num_Val);
							//memcpy(pv_adr,ADR(num_Val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;		
					2:// SINT
						IF (num_Val >= -128) AND (num_Val <= 16#7F) THEN 
							pData := ADR(num_Val);
							//memcpy(pv_adr,ADR(num_Val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;	
					3:// INT 
						IF (num_Val >= -32768) AND (num_Val <= 16#7FFF) THEN 
							pData := ADR(num_Val);
							//memcpy(pv_adr,ADR(num_Val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;	
					4:// DINT
						IF (num_Val >= -2147483648) AND (num_Val <= 16#7FFFFFFF) THEN 
							pData := ADR(num_Val);
							//memcpy(pv_adr,ADR(num_Val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;	
	
					5: //USINT		
						IF (num_Val >= 0) AND (num_Val <= 16#FF) THEN 
							pData := ADR(num_Val);
							//memcpy(pv_adr,ADR(num_Val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;	
					6:// UINT		
						IF (num_Val >= 0) AND (num_Val <= 16#FFFF) THEN 
							pData := ADR(num_Val);
							//memcpy(pv_adr,ADR(num_Val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;	
					7: //UDINT		
						IF (num_Val >= 0) AND (DINT_TO_UDINT(num_Val) <= 16#FFFF_FFFF) THEN  // 
							pData := ADR(num_Val);
							//memcpy(pv_adr,ADR(num_Val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;	
			
					8:// REAL 32-bit floating point number
						float_val := atof(ADR(value)); 
						IF (float_val >= -3.4E38) AND (float_val <= 3.4E38) THEN 
							pData := ADR(float_val);
							//memcpy(pv_adr,ADR(float_val),pv_length);
							found := 1;
						ELSE
							status := 96; 	
							setValue := 100;
						END_IF;	
						found := 1;
	
					9:// STRING Variable-length single-byte character string
						IF (LEN(value) <= pv_length) THEN
							memset(ADR(string_Val),0,pv_length);
							memcpy(ADR(string_Val),ADR(value),LEN(value));
							pData := ADR(string_Val);
							found := 1;
						ELSE						
							status := 96; 	
							setValue := 100;
						END_IF;
					10..14,16..23:
						status := 98; 	
						setValue := 100;

				END_CASE;	
			ELSIF NOT stringCheck THEN
				status := 97; 	
				setValue := 100;
			ELSE; 
				status := 99; 	
				setValue := 100;
			END_IF;	
			IF (found > 0) THEN
				setValue := 13;
			END_IF;
	
		13: // Add header data to the fifo	
			data[0] := pv_adr;
			data[1] := pv_len;
			writeFifo.enable := 1;
			writeFifo.ident := createFifo.ident;	
			writeFifo.pData := ADR(data[0]);
			writeFifo.size := 8;//
			writeFifo();	
			IF (writeFifo.status = ERR_OK) THEN
				setValue := 14;
			ELSIF writeFifo.status <> ERR_FUB_BUSY THEN
				setValue := 100;
				status := 94;		
			END_IF;	
	
		14:// Add the actual data the fifo
			writeFifo.enable := 1;
			writeFifo.ident := createFifo.ident;	
			writeFifo.pData := pData;
			writeFifo.size := pv_len;//
			writeFifo();	
			IF (writeFifo.status = ERR_OK) THEN
				setValue := 20;
			ELSIF writeFifo.status <> ERR_FUB_BUSY THEN
				setValue := 100;
				status := 94;		
			END_IF;		

		20:// Check if we need to search again or complete the 
			IF(arrayEnd <= 1) OR ((arrayEnd - searchOffset) < 5) THEN	
				setValue := 30;		
			ELSE //Search again
				setValue := 5;
			END_IF;			
	
		30:// Process the results Read out the data header	
			readFifo.enable := 1;
			readFifo.ident := createFifo.ident;
			readFifo.pData := ADR(data[0]);
			readFifo.size := 8;
			readFifo();
			IF (readFifo.status = ERR_OK) THEN
				pv_adr := data[0];
				pv_len := data[1];
				setValue := 31;
			ELSIF (readFifo.status = fifoERR_BUFFER_EMPTY) THEN
				setValue := 40;
			ELSIF readFifo.status <> ERR_FUB_BUSY THEN
				setValue := 100;
				status := 94;		
			END_IF;	
		
		31:// Process the results Read out the data
			readFifo.enable := 1;
			readFifo.ident := createFifo.ident;
			readFifo.pData := pv_adr;
			readFifo.size := pv_len;
			readFifo();
			IF (readFifo.status = ERR_OK) THEN
				setValue := 30; // Go back to iterate through the fifo
				//			ELSIF (readFifo.status = fifoERR_BUFFER_EMPTY) THEN
				//				setValue := 40;
			ELSIF readFifo.status <> ERR_FUB_BUSY THEN
				setValue := 100;
				status := 94;		
			END_IF;		
	
		40:// Delete the FIFO	
			deleteFifo.enable := 1;
			deleteFifo.ident := createFifo.ident;
			deleteFifo();
			IF deleteFifo.status = ERR_OK THEN
				setValue := 90;
			ELSIF (deleteFifo.status <> ERR_FUB_BUSY) THEN
				setValue := 100;
				status := 94;
			END_IF;
		
		90:// Send the response
	
		
		100:// Error Step			
			error := status;

			CASE status OF
				94: 
					overRideData.responseHeader.status := '400 Bad Request';	
					responseData := 'PLC FIFO Failure';
					httpServer.responseDataLen := LEN(responseData);
			
				95:
					overRideData.responseHeader.status := '400 Bad Request';	
					responseData := 'Malformed JSON array';
					httpServer.responseDataLen := LEN(responseData);
			
				96:					
					overRideData.responseHeader.status := '403 Forbidden';	
					responseData := 'Value out of range';
					httpServer.responseDataLen := LEN(responseData);
		
				97:
					overRideData.responseHeader.status := '405 Method Not Allowed';	
					responseData := 'You have sent a string to a numeric data type';
					httpServer.responseDataLen := LEN(responseData);	
		
				98:	
					overRideData.responseHeader.status := '405 Method Not Allowed';	
					responseData := 'This data type is currently not supported';
					httpServer.responseDataLen := LEN(responseData);	
				99:		
					overRideData.responseHeader.status := '403 Forbidden';	
					responseData := 'You have requested to update a structure part, or Array item without specifing the full path';
					httpServer.responseDataLen := LEN(responseData);
			END_CASE;

	END_CASE;	

	


	sendResponse := (setValue = 90);
	errorResponse := (error > 0);			
	//Configuration.Data.Belt[0].Alarm.General	
	IF EDGEPOS(sendResponse) OR EDGEPOS(errorResponse) THEN
		setValue := 0;	
	END_IF;
END_WHILE;		
	
END_ACTION
