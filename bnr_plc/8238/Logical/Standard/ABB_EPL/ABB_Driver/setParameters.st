
ACTION _setParameters:
	
	CASE settings.MotorSize OF // Need to set these values correctly
		
		ABB_MOTOR_0_25KW:
			nominalCurrent_9906		:= 7; //0.68 A
			nominalPower_9910		:= 25; // 0.37 kW
			nominalSpeed_9909 		:= 1300;	
			maxCurrent				:= 190;//1.9A
			
		ABB_MOTOR_0_37KW_0_91A_1374:	
			nominalCurrent_9906		:= 9; //0.91 A
			nominalPower_9910		:= 37; // 0.37 kW
			nominalSpeed_9909 		:= 1374;	
			maxCurrent 				:= 320; //3.2A
			
		ABB_MOTOR_0_37KW_0_97A_1342:	
			nominalCurrent_9906		:= 10; //0.97 A
			nominalPower_9910		:= 37; // 0.37 kW
			nominalSpeed_9909 		:= 1342;	
			maxCurrent 				:= 350; //3.5A
			
		ABB_MOTOR_0_37KW_1_14A_1380:	
			nominalCurrent_9906		:= 7; //1.14 A
			nominalPower_9910		:= 37; // 0.37 kW
			nominalSpeed_9909 		:= 1380;	
			maxCurrent 				:= 350;//3.5A
			
		ABB_MOTOR_0_75KW:	
			nominalCurrent_9906		:= 18; //1.75 A
			nominalPower_9910		:= 75; // 0.75 kW
			nominalSpeed_9909 		:= 1440;
			maxCurrent 				:= 1170; //11.7A
			
		ABB_MOTOR_1_5KW:
			nominalCurrent_9906		:= 30;// 3 A?
			nominalPower_9910		:= 150;// 1.5kW
			nominalSpeed_9909 		:= 1450;
			maxCurrent 				:= 2200; //22A ???
			
		ABB_MOTOR_2_2KW_4_75A_1450:	
			nominalCurrent_9906		:= 48; //4.75 A
			nominalPower_9910		:= 220; // 2.2 kW
			nominalSpeed_9909 		:= 1450;
			maxCurrent 				:= 3000; //30A ???
			
		ABB_MOTOR_3KW:	
			nominalCurrent_9906		:= 64; 
			nominalPower_9910		:= 300; // 3 kW
			nominalSpeed_9909 		:= 1456;	
			maxCurrent 				:= 5248; //52.48
		
		ABB_MOTOR_CUSTOM: // Future  Alow Motor data to be set individaully
			nominalCurrent_9906		:= 26; //2.55A 
			nominalPower_9910		:= 110; //1.1 
			nominalSpeed_9909 		:= 1455;	
			maxCurrent 				:= 1760; //17.6A
	
			
	END_CASE;
	
	accTime := REAL_TO_DINT(settings.AccTime * 1000); 	
	decTime := REAL_TO_DINT(settings.DecTime * 1000); 	
			
	//V2.00.2 Encode parameters 
	_encodeParameters;
	
	drive.Config.function.enable := TRUE;																	//Enable function block
	
	
	IF (drive.Config.Node > 0) THEN
		drive.Config.function.node := drive.Config.Node; 														//Node number of drive, set in ABB_EPL[n].cmd.node if non standard.
		drive.Config.function.pDevice := ADR(drive.Config.EPL_Address);											//Set powerlink address in ABB_Driver init task
	ELSE
		//drive.Config.function.node := n + 100; //Set the default to drive + 100
	END_IF;	
	IF (drive.Config.Node > 0) AND (drive.Config.currentParam <= MAX_PARAMS) THEN
		IF (drive.Config.params[drive.Config.currentParam].status > 0) THEN									//Call function only if not completed		
			drive.Config.function.index := drive.Config.params[drive.Config.currentParam].index; 			//Powerlink index address
			drive.Config.function.subindex := drive.Config.params[drive.Config.currentParam].subIndex;		//Powerlink sub index address
			drive.Config.function.pData := ADR(drive.Config.params[drive.Config.currentParam].data);		//Value of data to write
			drive.Config.function.datalen := drive.Config.params[drive.Config.currentParam].datalen;		//Size of data type														//Call function
			IF (drive.Config.function.status = ERR_OK) THEN 												//Clear errors
				drive.Config.params[drive.Config.currentParam].status := 0;
				drive.Config.params[drive.Config.currentParam].errorInfo := 0;
				drive.Config.currentParam := drive.Config.currentParam + 1;
			ELSIF (drive.Config.function.status <> ERR_FUB_BUSY) AND (drive.Config.function.status <> ERR_FUB_ENABLE_FALSE) THEN //Store errors
				drive.Config.params[drive.Config.currentParam].status := drive.Config.function.status;
				drive.Config.params[drive.Config.currentParam].errorInfo := drive.Config.function.errorinfo;
				drive.Config.function.enable := FALSE;
				//			ELSIF drive.Config.function.status <> 20925 THEN;//ERR_PLMGR_STATION_NOT_ACTIVE THEN  //Only skip if the devuce is active																																					//Skip if other error to stop PLC hanging in bootup
				//				drive.Config.params[drive.Config.currentParam].status := drive.Config.function.status;
				//				drive.Config.params[drive.Config.currentParam].errorInfo := drive.Config.function.errorinfo;
				//				drive.Config.currentParam := drive.Config.currentParam + 1;
			END_IF;
			drive.Config.function();	
		ELSE
			drive.Config.function.enable := FALSE;
		END_IF;
	END_IF;
		
	//Parameters should be loaded onto default settings.
	//to default the drive set 9606 t0 34560 
	//Node ID (5103) has to be manually set
	
END_ACTION
