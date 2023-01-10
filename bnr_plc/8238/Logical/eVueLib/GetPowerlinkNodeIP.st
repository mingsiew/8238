
(* *Function to build BR camera image URL from EPL IP and Node address *)
FUNCTION_BLOCK GetPowerlinkNodeIP
		
	IF EDGEPOS(Enable)AND (state = 0) THEN	
		state := 1;
	ELSIF (((state = 4) OR (state = 100)) AND NOT Enable) THEN
		state := 0;
	END_IF;
	
	getEPL_IP.enable 	:= (state = 2);	
	
	CASE state OF
		0:  // WAIT
			Status := ERR_FUB_ENABLE_FALSE;	
		
		1: // Build and check the interface path
			Status := ERR_FUB_BUSY;	
			IF (RIGHT(EplInterfacePath,4) = '.ETH') THEN			
				device := EplInterfacePath;
				state := 2;
			ELSE
				device := CONCAT(EplInterfacePath,'.ETH');
				state := 2;
			END_IF;	
				
		2:// Get the IP address of the interface..
			Status := ERR_FUB_BUSY;	
			getEPL_IP.pIPAddr 	:= ADR(eplAddress); 
			getEPL_IP.Len 		:= SIZEOF(eplAddress);
			getEPL_IP.pDevice 	:= ADR(device);
			IF (getEPL_IP.status = ERR_OK) THEN	
				state := 3;
				//brsstrcpy(pIPAddress,ADR(''));
			ELSIF (getEPL_IP.status <> ERR_FUB_BUSY) AND (getEPL_IP.status <> ERR_FUB_ENABLE_FALSE)  THEN
				Status := getEPL_IP.status;
				state := 100;
			END_IF;
		
		3://Replace the 
			Status := ERR_FUB_BUSY;	
			ethInetAton(ADR(eplAddress),ADR(eplIP));
			eplIP := (eplIP AND 16#00FF_FFFF) OR (16#FF00_0000 AND SHL(Node,24));// Replace the end of the IP with the node
			ethInetNtoa(eplIP,pIPAddress);
			state := 4;	
			
		4:// Complete
			Status := ERR_OK;	
			

			
		100:// Error step	
				
		
		
	
	END_CASE;
	
	getEPL_IP();
	
	
	
END_FUNCTION_BLOCK
