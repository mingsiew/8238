//V2.00.1 -- First stable release
//V2.00.2 -- Set brake control to be optional - This means changing when we encode the paramater structure.
//V2.00.3 -- Add new constant to set MAX_FREQUENCY
//V2.00.4 -- If the drive started not on remote it wouldn;t always go into config to start. ADD new mode for when module ok is false.
//V2.00.5 -- Add test mode for simulation
//V2.00.6 -- BUG FIX -- Minumum speed was being set to Max which stopped speed control
//V2.00.7 -- REMOVE -- Remove the old structure for settings via http
//V2.00.8 -- FIX -- Correct the scaling of MaxCurrent from settings - we now us 200 = 2A
//V3.00.1 -- CHANGE Combine Settings task into driver- Remove parameters from EPL write and move to SDO configuration function block
//V3.00.2 -- ADD Manual control mode via http!
//V3.00.3 -- Convert Manual Control to mappView.
//V4.00.1 -- Automatically get node number from PV structure.
//V4.00.2 -- Move Control word states into the program as the were not being copy when the task was moved causing errors.
//V4.00.3 -- Change halt mode of belts to we do a proper decel
//V4.00.4 -- Change error handling to always reset STO automatically 

PROGRAM _INIT
	setNodeNumber.pDevice := ADR('SL1.IF1');
	FOR n := 1 TO MAX_DRIVES DO
		drive ACCESS ADR(ABB_EPL.Drives[n]);
		drive.Comm.State := ABB_CONFIG;
		drive.Config.currentParam := 1; //Reset starting parameter index	
		drive.Config.Node := 0;
		drive.Config.EPL_Address := '';
		index := 0;
		init_state := 0;
	END_FOR;
	
	FOR n := 1 TO 8 DO
		visu_manual[n].ListBoxVisible := 0;
		visu_manual[n].TargetVelocity := ABB_MIN_VELOCITY;
		visu_manual[n].selectedIndex := 0;
	END_FOR;
	
	IF (MAX_DRIVES > 8) THEN
		max_manualControls := 8;
	ELSIF (MAX_DRIVES > 1) THEN
		max_manualControls := MAX_DRIVES;
	ELSE
		max_manualControls := 1;
	END_IF;	
	xRun := FALSE;
END_PROGRAM

PROGRAM _CYCLIC
	
	IF EDGENEG(xRun) THEN
		FOR n := 1 TO MAX_DRIVES DO
			drive ACCESS ADR(ABB_EPL.Drives[n]);
			drive.Comm.State := ABB_INIT;
			drive.Config.currentParam := 1; //Reset starting parameter index	
			drive.Config.Node := 0;
			drive.Config.EPL_Address := '';
			index := 0;	
			init_state := 0;
		END_FOR;
	ELSIF NOT xRun THEN
		_getNodeInfo;
	ELSE
		
		_manual;  // mappView manual control.
		FOR x := 1 TO MAX_DRIVES DO
			IF (testDrive > 0) THEN
				n := testDrive;
			ELSE
				n := x;
			END_IF;
			
			drive 		ACCESS ADR(ABB_EPL.Drives[n]);	
			settings	ACCESS ADR(gSettings.Drive[n]);
		
			//Control Word												Status Word
			//Bit 0		Switch On										Bit 0	Ready To Switch On
			//Bit 1		Enable Voltage									Bit 1	Switched On
			//Bit 2		Quick Stop										Bit 2	Operation Enabled
			//Bit 3		Enable Operation								Bit 3	Fault
			//Bit 4		Not Used In Scalor Mode							Bit 4	Voltage Enabled
			//Bit 5		Not Used In Scalor Mode							Bit 5	Quick Stop
			//Bit 6		Not Used In Scalor Mode							Bit 6	Switch On Disabled
			//Bit 7		Fault Reset										Bit 7 	Warning
			//Bit 8		Halt											Bit 8	Drive Specific TBC
			//Bit 9		Operation Mode Specific							Bit 9	Remote
			//Bit 10	Reserved	??Remote Control??					Bit 10	Target Reached
			//Bit 11	Drive Specific	TBC								Bit 11 	Internal Limit Reached
			//Bit 12	Drive Specific	TBC								Bit 12	Not Used In Scalor Mode
			//Bit 13	Drive Specific	TBC								Bit 13	Not Used In Scalor Mode
			//Bit 14	Drive Specific	TBC								Bit 14	Drive Specific TBC
			//Bit 15	Drive Specific	TBC								Bit 15	Drive Specific TBC

			//Use a local instance of controlword so we don't pass changing data to the drive while processing

			controlWord := SHUT_DOWN;	// 0000 0000 0111 0110
		
			//Encode the controlword and statusword		
			_packData;
			
			IF Std.TestMode AND NOT drive.Comm.ModuleOk THEN // TEST MODE
				IF drive.Cmd.Run THEN 
					drive.Comm.State := ABB_RUNNING; 
				ELSE
					drive.Status.ReadyToRun := 1;
				END_IF;		
			ELSIF NOT drive.Comm.ModuleOk THEN	
				drive.Comm.State := ABB_DISCONNECTED;
			ELSIF (drive.Config.params[MAX_PARAMS].status <> 0) OR (drive.Config.currentParam < MAX_PARAMS) THEN
				drive.Comm.State := ABB_CONFIG;
			ELSIF NOT drive.Status.OnRemote THEN
				drive.Comm.State := ABB_OFF_REMOTE;
			ELSIF drive.Status.Tripped THEN
				drive.Comm.State := ABB_TRIPPED;
			ELSIF NOT drive.Cmd.QuickStop THEN	//Enable quick stop
				drive.Comm.State := ABB_QUICK_STOP;
			ELSIF drive.Status.SwitchOnInhibit THEN 
				drive.Comm.State := ABB_SWITCH_ON_INHIBITED;	
			ELSIF drive.Comm.ErrorCode = ABB_FAULT_STO THEN
				drive.Comm.State := ABB_STO;
			END_IF;
	
			CASE drive.Comm.State OF
			
				ABB_DISCONNECTED:
					drive.Config.currentParam := 1; // Force write of parameters	
				
				ABB_CONFIG: //Wait for module OK to be TRUE
					_setParameters; //Write params
					IF drive.Comm.ModuleOk AND (drive.Config.params[MAX_PARAMS].status = 0) THEN
						drive.Comm.State := ABB_SWITCH_ON_INHIBITED;
					END_IF;	

				ABB_SWITCH_ON_INHIBITED:	//Wait for quick stop and enable to be true
					IF NOT drive.Status.SwitchOnInhibit THEN 
						drive.Comm.State := ABB_NOT_READY_TO_SWITCH_ON;	
					END_IF;
		
				ABB_NOT_READY_TO_SWITCH_ON:
					IF drive.Status.ReadyToSwitchOn THEN	
						drive.Comm.State := ABB_READY_TO_SWITCH_ON;		
					END_IF;
				
				ABB_READY_TO_SWITCH_ON:
					controlWord := SWITCH_ON; //0000 0111 0111 
					IF drive.Status.ReadyToRun THEN	
						drive.Comm.State := ABB_READY_TO_RUN;		
					END_IF;	
		
		
				ABB_READY_TO_RUN:
					controlWord := SWITCH_ON; //0000 0111 0111
					IF drive.Cmd.Run AND (ABS(drive.Cmd.TargetVelocity) >= ABB_MIN_VELOCITY) AND NOT drive.Manual.Enable THEN //Check min frequency is met
						drive.Comm.State := ABB_RUNNING;		
					ELSIF drive.Manual.Run AND (ABS(drive.Manual.Velocity) >= ABB_MIN_VELOCITY)  THEN
						drive.Comm.State := ABB_RUNNING;	
					END_IF;
		
				ABB_RUNNING:
					controlWord := ENABLE_OPERATION; //0000 0111 1111
					IF NOT (drive.Cmd.Run AND NOT drive.Manual.Enable) AND NOT (drive.Manual.Run AND drive.Manual.Enable) THEN	
						drive.Comm.State := ABB_RAMP_DOWN;		
					END_IF;		
					
				ABB_RAMP_DOWN:
					controlWord := RAMP_DOWN; //0001 0111 1111
					IF drive.Comm.StatusWord.11 = 0 AND drive.Comm.ActVelocity = 0 THEN
						drive.Comm.State := ABB_READY_TO_RUN;
					END_IF;
			
				ABB_QUICK_STOP:
					controlWord := QUICK_STOP; //0000 0111 0010
					IF drive.Comm.StatusWord.11 = 0 AND drive.Comm.ActVelocity = 0 AND drive.Cmd.QuickStop THEN
						drive.Comm.State := ABB_READY_TO_RUN;
					END_IF;
				
				ABB_TRIPPED: // AUTO Reseting -- We should change to manual reset..
					//We must wait for the drive to be ready for reset and give an edge.
						IF (drive.Comm.StatusWord.11 = 0) AND (drive.Comm.ActVelocity = 0) THEN 
							IF settings.AutoReset THEN
								controlWord := FAULT_RESET;
							ELSIF drive.Manual.ErrorReset THEN	
								controlWord := FAULT_RESET;
								drive.Manual.ErrorReset := FALSE; // Reset the command.
							ELSIF (drive.Comm.ErrorCode = 16#A5A0) THEN	
								controlWord := FAULT_RESET; // ALWAYS CLEAR THE STO ERROR AUTO MATICALLY
							ELSIF (drive.Comm.ErrorCode = 0) THEN	
								controlWord := FAULT_RESET; // THE FAULT HAS BEEN CLEARED EXTERNALLY	
							END_IF;	
						ELSE
							controlWord := DISABLE_VOLTAGE; //0000 0000 0000
						END_IF;
	
					//We can auto reset here..but we should log an error somewhere..
					IF NOT drive.Status.Tripped THEN
						drive.Manual.ErrorReset := FALSE; // Reset the command.
						drive.Cmd.Reset	 		:= FALSE;
						drive.Comm.State := ABB_SWITCH_ON_INHIBITED;
					END_IF;	
		
				ABB_OFF_REMOTE:
					//Remote control not active
					controlWord := SET_REMOTE;
					////				IF drive.Status.OnRemote THEN
					////					IF (drive.Config.params[MAX_PARAMS].status <> 0) THEN
					////						drive.Comm.State := ABB_CONFIG;
					////					ELSE
					////						drive.Comm.State := ABB_SWITCH_ON_INHIBITED;
					////					END_IF;
					////				END_IF;
					//				IF NOT Std.Drives_AllowLocalMode AND (drive.Config.params[13].data = Std.Drives_AllowLocalMode) THEN //Only reset the parameters if the local control mode has chnaged 
					//					_encodeParameters; 
					//					drive.Config.currentParam := 1; //Reset starting parameter index
					//				END_IF;
					//			
				ABB_STO:
					IF drive.Comm.ErrorCode <> ABB_FAULT_STO THEN
						drive.Comm.State := ABB_SWITCH_ON_INHIBITED;
					END_IF;
		
			END_CASE;	
			drive.Status.Running := (drive.Comm.State =  ABB_RUNNING);
			drive.Comm.ControlWord := controlWord;				
			
			drive.Manual := DRIVE_MANUAL_DEFAULT; 	
		END_FOR;
		
	END_IF;
	
	
	
	
	
	
	
	
	//Temp code so that we can set a node number, The NODE must already be set to 1 (DEFAULT)
	IF (newNode > 0) THEN
		setNodeNumber.enable := 1;
		setNodeNumber.node := 1;
		setNodeNumber.index := 16#4033;
		setNodeNumber.subindex := 16#03;
		setNodeNumber.pData :=  ADR(newNode);
		setNodeNumber.datalen := 2;
		setNodeNumber();
		IF (setNodeNumber.status = ERR_OK) THEN
			newNode := 0;	
		END_IF;
	ELSIF saveNewNode THEN
		saveVar := 1;
		setNodeNumber.enable := 1;
		setNodeNumber.node := 1;
		setNodeNumber.index := 16#4033;
		setNodeNumber.subindex := 16#1B;
		setNodeNumber.pData :=  ADR(saveVar);
		setNodeNumber.datalen := 2;
		setNodeNumber();
		IF (setNodeNumber.status = ERR_OK) THEN
			saveNewNode := 0;	
		END_IF;
	ELSIF (factoryReset > 0) THEN
		saveVar := 34560;
		setNodeNumber.enable := 1;
		setNodeNumber.node := UINT_TO_USINT(factoryReset);
		setNodeNumber.index := 16#4060;
		setNodeNumber.subindex := 16#06;
		setNodeNumber.pData :=  ADR(saveVar);
		setNodeNumber.datalen := 2;
		setNodeNumber();
		IF (setNodeNumber.status = ERR_OK) THEN
			factoryReset := 0;	
		END_IF;
	END_IF;
		 
END_PROGRAM



