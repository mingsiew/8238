
ACTION _getNodeInfo: 
	IF (index >= 1) AND (index <= MAX_DRIVES) THEN//  AND (LEN(POWERLINK_INTERFACE_ADDRESS) > 0) THEN
		config ACCESS ADR (ABB_EPL.Drives[index].Config);
		
		CASE init_state OF
			0:
				IF (config.Node = 0) THEN
					pvName := 'ABB_EPL.Drives[';
					itoa(index,ADR(driveNo));	
					brsstrcat(ADR(pvName),ADR(driveNo));
					brsstrcat(ADR(pvName),ADR(']'));
					getNode.enable := 1;	
					getNode.pvName := pvName;
					getNode();
					IF (getNode.status = ERR_OK) THEN 
						config.Node 		:= getNode.NodeNumber;
						config.EPL_Address 	:= getNode.IF_Adr;
						// Build the path for the name
						itoa(getNode.NodeNumber,ADR(sNode));
						moduleAddress := CONCAT(getNode.IF_Adr,'.ST');
						moduleAddress := CONCAT(moduleAddress,sNode);
						init_state := 1;
					ELSIF (getNode.status <> ERR_FUB_BUSY) THEN
						init_state := 10; // SKIP -- CAMERA HASN'T BEEN MAPPED
					END_IF;
				ELSE	
					init_state := 10; // SKIP -- CAMERA HASN'T BEEN MAPPED
				END_IF
	
				
			1: //Get the name if it hasn;t be set	
				IF (gSettings.Drive[index].Name = '') THEN	
					getModuleName.enable := 1;
					getModuleName.pModuleAddress := ADR(moduleAddress);
					getModuleName();
					IF getModuleName.status = ERR_OK THEN
						init_state := 10;
						gSettings.Drive[index].Name := LEFT(getModuleName.ModuleName,SIZEOF(gSettings.Drive[index].Name));
					ELSIF (getModuleName.status <> ERR_FUB_BUSY) THEN
						gSettings.Drive[index].Name := 'unknown';
						init_state := 10;
					END_IF;
				ELSE	
					init_state := 10;
				END_IF;	
			
			10:// Done	
				index := index + 1;
				init_state := 0;
			ELSE 
				index := index + 1;
				init_state := 0;	
		END_CASE;			
		
	ELSIF (index < 1) THEN
		index := 1;
	ELSIF index > MAX_DRIVES THEN
		xRun := 1;	
	END_IF;
	
	
	
		
	
END_ACTION
