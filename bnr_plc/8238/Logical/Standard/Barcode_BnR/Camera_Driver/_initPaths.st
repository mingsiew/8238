//Build the WEB URL for the camera images..
//Only do it once..
ACTION _initPaths: 
	
	IF (index >= 1) AND (index <= MAX_CAMERAS) THEN//  AND (LEN(POWERLINK_INTERFACE_ADDRESS) > 0) THEN
		CASE init OF
			0: // Get the Node number

				pvName := 'Camera[';
				itoa(index,ADR(camNo));	
				brsstrcat(ADR(pvName),ADR(camNo));
				brsstrcat(ADR(pvName),ADR(']'));
				getNode.enable := 1;	
				getNode.pvName := pvName;
				getNode();
				IF (getNode.status = ERR_OK) THEN 
					Camera[index].Node := getNode.NodeNumber;
					itoa(getNode.NodeNumber,ADR(sNode));
					init := 1;	
				ELSIF (getNode.status <> ERR_FUB_BUSY) THEN
					init := 10;	 // SKIP -- CAMERA HASN'T BEEN MAPPED
				END_IF;
				
			1:		
				getPowerlinkNodeIP();
				//Initialise the Camera values for Visu
				getPowerlinkNodeIP.EplInterfacePath 	:= getNode.IF_Adr;//POWERLINK_INTERFACE_ADDRESS;
				getPowerlinkNodeIP.pIPAddress			:= ADR(eplIpAddress);	
				getPowerlinkNodeIP.Enable := 1;
				getPowerlinkNodeIP.Node 	:= USINT_TO_UDINT(Camera[index].Node); 
			
				IF (getPowerlinkNodeIP.Status = ERR_OK) THEN
					//Build the URL
					web_path[index]	:= 'http://';
					web_path[index] := CONCAT(web_path[index],eplIpAddress); 
					web_path[index]:= CONCAT(web_path[index],':8080/jpg?q=50,t=');
					getPowerlinkNodeIP.Enable := 0;
					init := 2;
				ELSIF (getPowerlinkNodeIP.Status <> ERR_FUB_BUSY) AND (getPowerlinkNodeIP.Status <> ERR_FUB_ENABLE_FALSE) THEN
					web_path[index]	:= '';	
					init := 2;
					getPowerlinkNodeIP.Enable := 0;
				END_IF;	

			2:// Get the camera name
				IF (gSettings.Camera[index].Name = '') THEN	
					moduleAddress := CONCAT(getNode.IF_Adr,'.ST');
					moduleAddress := CONCAT(moduleAddress,sNode);
					
					getModuleName.enable := 1;
					getModuleName.pModuleAddress := ADR(moduleAddress);
					getModuleName();
					IF getModuleName.status = ERR_OK THEN
						init := 10;
						gSettings.Camera[index].Name := LEFT(getModuleName.ModuleName,SIZEOF(gSettings.Camera[index].Name));
					ELSIF (getModuleName.status <> ERR_FUB_BUSY) THEN
						gSettings.Camera[index].Name := 'unknown';
						init := 10;
					END_IF;
				ELSE	
					init := 10;
				END_IF;	
			
			10://
				init := 0;
				index := index + 1;	
			
		END_CASE;
		

		
	ELSIF (index < 1) THEN
		index := 1;
	ELSIF index > MAX_CAMERAS THEN
		xRun := 1;	
	END_IF;
		
		
		
	
END_ACTION
