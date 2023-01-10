//---------------------------------------------
//-------------Safety Request------------------
//---------------------------------------------
//V1.00.2 -- 2019 May 24 -- TR -- Fix issue with master reset not working if not ready.
//V1.00.3 -- 2019 June 26 -- TR -- FIx issue with the solenoid not opening if the hoist switch is made after the bagInTransit timers.. Add timer for hoist in position so the hoist cannot be moving past the safe position and open the door.
//V1.00.4 -- 2019 November 11 -- TR -- 	FIX: Issues with the solenoid locking incorrectly,
						//ADD: Control to lift the edge protection gates ( Map Directly to all required outputs.) 	
//V1.00.5 -- 2020 Decemeber 16 -- TR -- UPDATE : Change to new structure for Safety.
//V1.00.6 -- 2021 January 02 -- TR -- UPDATE : Add Test Mode bit
//V2.00.1 - 2001 Feburary 05 - Change Structures to remove links to direct IO points. Data now comes from Safe PLC.

PROGRAM _INIT

//***************************************************************************************
//	N.B Zone 11 has been faked so we can control the lamp tower correctly FOR the primary
//***************************************************************************************

//DECLARE MAX_SAFE_SYSTEMS IN CONTSTANTS
	
	startZone[1] := 1;   // Number of the Master Zone
	endZone[1] := 5;	// Last zone in the area
	enableMasterReset[1] := TRUE; // Set to true if master reset is to be used/
//	alarmCondition[1] := system_alarm_1 OR soiled_validation_alarm OR halted;	
	
	
	//zone for clean alarms.
	startZone[2] := 11;   // Number of the Master Zone
	endZone[2] := MAX_SAFE_ZONES;	// Last zone in the area
	enableMasterReset[2] := TRUE; // Set to true if master reset is to be used/
	
	
	//NB//  A ZONE CANNOT BELONG TO MORE THAN 1 SAFE SYSTEM.			

	// MAX Zone if 30	
	
	debounceMasterPT := 476; //4.76 second
	transitSettlePT := 3000; //3000seconds
	startUpWarningPT := 500; //5 secs
	
	
	FOR n:=1 TO MAX_SAFE_ZONES DO
		safeState[n] := 4;
	END_FOR;	

	
	#if (MAX_SAFE_ZONES  > 30)  
	#error 'Cannot have more than 30 safety zones'  
	#endif	
	
END_PROGRAM

PROGRAM _CYCLIC

alarmCondition[1] := system_alarm_1 OR soiled_validation_alarm OR halted;		
alarmCondition[2] := system_alarm_2 OR clean_validation_alarm OR halted;	

FOR s := 1 TO MAX_SAFE_SYSTEMS DO	

	ton_10ms_startUp_Warning[s].IN:= masterResetRequest[s];
	ton_10ms_startUp_Warning[s].PT:= startUpWarningPT;
	ton_10ms_startUp_Warning[s]();	
		
	IF  ton_10ms_startUp_Warning[s].Q AND Std.Clock1s THEN	
		Safety.MasterReset_Comm	:= BIT_SET(Safety.MasterReset_Comm,s);
	ELSE
		Safety.MasterReset_Comm	:= BIT_CLR(Safety.MasterReset_Comm,s);
	END_IF;		
	
	masterZoneNo := startZone[s]; // Number of the master zone for the safe system.	
		
		
	ton_10ms_Master_Reset[s].IN:= SafetyZone[masterZoneNo].ResetButton AND enableMasterReset[s];//masterResetRequest[s];
	ton_10ms_Master_Reset[s].PT:= debounceMasterPT;
	ton_10ms_Master_Reset[s]();
	
	IF 	ton_10ms_Master_Reset[s].Q THEN
		masterResetRequest[s] := 1;	
	END_IF;
		
	tmrAlmOutput[s].IN := alarmCondition[s];	
	tmrAlmOutput[s].PT := T#5s;	
	tmrAlmOutput[s]();	
	
		
	FOR n:= startZone[s] TO endZone[s] DO
		
		IF startZone[s] = 0 THEN	
			EXIT;
		END_IF;
				
		safeZone ACCESS ADR(SafetyZone[n]);
		masterZone := (n = startZone[s]);	
			
		_decodeData;
		
		//Set the EDM bit//
		IF safeZone.EDM THEN	
			Safety.EDM_Comm := BIT_SET(Safety.EDM_Comm,n);
		ELSE
			Safety.EDM_Comm := BIT_CLR(Safety.EDM_Comm,n);
		END_IF;	
	
		 
		//set the reset bit//	
		IF safeZone.ResetButton THEN
			Safety.Reset_Comm := BIT_SET(Safety.Reset_Comm,n);
		ELSE
			Safety.Reset_Comm := BIT_CLR(Safety.Reset_Comm,n);
		END_IF;		

			
		//-------------------------------------------------------
		//---------------------Master-reset----------------------
		//-------------------------------------------------------
		IF Std.TestMode AND (Safety.SFW_Version = 0) THEN	
			safeZone.DoorLock 	:= FALSE;
			safeZone.LiftGates 	:= FALSE;
			safeZone.Zone_Status 	:= TRUE;
			safeZone.Disable 		:= FALSE;	
			safeZone.HaltSys 		:= NOT(safeZone.Zone_Status AND NOT safeZone.Disable);			
		ELSE		
			lockDoor[n] := FALSE;

			tof_HoistsOutOfPosition[n].IN := safeZone.HoistsOutOfPosition;
			tof_HoistsOutOfPosition[n].PT := 100;
			tof_HoistsOutOfPosition[n]();

			ton_entryError[n].IN := (safeState[n] = 3);
			ton_entryError[n].PT := 100;
			ton_entryError[n]();

			IF ton_10ms_Master_Reset[s].Q AND NOT safeZone.Zone_Status AND safeZone.ResetReady THEN // only put a zone to reset if it needs it
				masterReset[n] := TRUE; // Set masterReset
				safeState[n] := 10; // Goto master reset state	
			END_IF;


			//-------------------------------------------------------
			//------------------END-Master-Reset-END-----------------
			//-------------------------------------------------------

			//-------------------------------------------------------
			//------------------Safety-State-Machine-----------------
			//-------------------------------------------------------

			//Wait for bags to finish moving and hoists to get into position.. Door can be unlocked 
			ton_10ms_Transit_Settle[n](IN:= safeZone.AccessRequested AND (safeState[n] = 1), PT:=transitSettlePT);
			IF NOT masterZone THEN
				f_trigRequestAccess[n].CLK:= safeZone.RequestAccess;
				f_trigRequestAccess[n]();
			END_IF;		
			CASE safeState[n] OF
				0: //Zone reset do not enter

					// Operator requests access by pressing Access DI for 1 second then releasing
					IF safeZone.AccessRequested THEN
						safeState[n] := 1;
					ELSIF safeZone.Zone_Status AND f_trigRequestAccess[n].Q  THEN//	ELSIF (debounceEdgeNeg[n] OR safeZone.AccessRequested) AND NOT masterReset THEN //Look for falling edge if masterReset not requested
						safeZone.AccessRequested := TRUE; //Reset after unlocking or safe zone goes off
						safeState[n] := 1; //Access has been requested
						masterReset[n] := 0;
						//If zone accessed by override or depedant Zone drops out.
					ELSIF NOT safeZone.Zone_Status AND NOT safeZone.SafeInput THEN //If entered with overide goto state 3
						safeState[n] := 3;
					ELSIF NOT safeZone.Zone_Status AND safeZone.SafeInput THEN //If dependant zone drops out
						safeState[n] := 4;
					END_IF;

				1: //Access has been requested
					//Allow 1 second for moving bags to settle, once ok
					ton_10ms_bagsInTransit[n](IN:=NOT safeZone.BagsInTransit, PT:=100); //buffer the BagsInTransit bool

					//Latch solenoid lock open
					IF ton_10ms_bagsInTransit[n].Q AND safeZone.Disable AND NOT tof_HoistsOutOfPosition[n].Q THEN //Use Disable instead of AccessRequested, to ensure one cyclic check with Disable on to stop BagsInTransit being missed
						//safeZone.LockDoors := TRUE; //Reset after reset pressed and door shut
						safeState[n] := 2; //Safe to enter no bags in transit
					ELSIF ton_10ms_Transit_Settle[n].Q THEN
						//safeZone.LockDoors := NOT tof_HoistsOutOfPosition[n].Q; //Reset after reset pressed and door shut
						safeState[n] := 3; //Waiting time elapsed, enter with caution
					END_IF;

					//If zone accessed by override or depedant Zone drops out.
					IF NOT safeZone.Zone_Status AND NOT safeZone.SafeInput THEN //If entered with overide goto state 3
						safeState[n] := 3;
					ELSIF NOT safeZone.Zone_Status AND safeZone.SafeInput THEN //If dependant zone drops out
						safeState[n] := 4;
					ELSIF safeZone.Zone_Status AND f_trigRequestAccess[n].Q THEN //Cancel the request
						safeZone.AccessRequested := FALSE; //Reset after safe zone goes off
						safeState[n] := 4;
					END_IF;

				2..3: //Zone unlocked	
					//Reset access request
					lockDoor[n] := NOT tof_HoistsOutOfPosition[n].Q;

					IF safeZone.AccessRequested AND NOT safeZone.Zone_Status THEN
						safeZone.AccessRequested := FALSE; //Reset after safe zone goes off
						IF n = 0 THEN
							safeState[n] := 0; //Zone reset do not enter
						END_IF
					ELSIF safeZone.Zone_Status AND f_trigRequestAccess[n].Q  AND safeZone.AccessRequested THEN //Cancel the request
						safeZone.AccessRequested := FALSE; //Reset after safe zone goes off
						safeState[n] := 4;
					ELSIF safeZone.Zone_Status AND NOT safeZone.AccessRequested THEN // zone has been accessed and reset.
						safeState[n] := 0;
					END_IF;

				4:
					//Reset tower light state only if safety plc feedback ok
					IF safeZone.Zone_Status THEN //Check Safe PLC status
						safeState[n] := 0; //Zone reset do not enter
					END_IF;

				10: // Master reset
					IF (safeZone.Zone_Status OR NOT safeZone.ResetReady) THEN
						safeState[n] := 0;
						masterReset[n] := FALSE;
					END_IF;	

			END_CASE;

			//	//Lock solenoid
			//	//ton_10ms_Reset_Debounce[n](IN:=safeZone.Interlock.GS_DI_01_Access_Reset, PT:=debouncePT);
			//	IF (safeZone.Interlock.GS_DI_01_Access_Reset AND (safeState[n] > 1) AND NOT masterReset[n]) THEN
			//		//safeZone.LockDoors := FALSE; //Reset after reset pressed and door shut
			//		safeZone.AccessRequested := FALSE;
			//		safeState[n] := 4; // Check zone status
			//		//		ELSIF masterReset AND NOT safeZone.Zone_Status AND safeZone.ResetReady THEN
			//		//			safeState[n] := 10; // Goto master reset state
			//	END_IF;

			//Set disable to safe zone off or access requested
			safeZone.Disable := safeZone.AccessRequested OR NOT safeZone.Zone_Status;

			//-------------------------------------------------------
			//-------END--------Safety State Machine-------END-------
			//-------------------------------------------------------

			//-------------------------------------------------------
			//---------Set tower light status-&-TV-Indicators--------
			//-------------------------------------------------------
			IF NOT masterZone THEN //Light tower 0 does not need to indicate access state.. It is used on the main cab to indicate alarms. See alarm Task.
				safeZone.TowerLight.TL_DO_Green := safeZone.TowerLight.TL_DO_Yellow := safeZone.TowerLight.TL_DO_Red := safeZone.TowerLight.TL_DO_Sounder := 0;
				CASE safeState[n] OF
					0: //Zone reset do not enter
						safeZone.TowerLight.TL_DO_Green 	:= safeZone.Zone_Status;
						safeZone.TowerLight.TL_DO_Red 		:= NOT safeZone.Zone_Status;
					1: //Access has been requested
						safeZone.TowerLight.TL_DO_Yellow 	:= Std.Clock1s; 	//Means Zone Ok but access requested
						safeZone.TowerLight.TL_DO_Green 	:= safeZone.Zone_Status;
						safeZone.TowerLight.TL_DO_Red 		:= NOT safeZone.Zone_Status;
					2: //Safe to enter no bags in transit and hoists in position
						safeZone.TowerLight.TL_DO_Yellow 	:= TRUE; //Amber & RED steady indicates safe to enter
						safeZone.TowerLight.TL_DO_Green 	:= safeZone.Zone_Status;
						safeZone.TowerLight.TL_DO_Red 		:= TRUE;
					3: //
						safeZone.TowerLight.TL_DO_Yellow 	:= Std.Clock200ms; //Amber/Green Alternate-- Enter with Caution
						safeZone.TowerLight.TL_DO_Sounder 	:= NOT ton_entryError[n].Q; //Short alarm to indicate enter with caution
						safeZone.TowerLight.TL_DO_Green 	:= NOT Std.Clock200ms;
						safeZone.TowerLight.TL_DO_Red 		:= NOT Std.Clock200ms OR safeZone.HoistsOutOfPosition; // If red ight on then fault

					4: //Ready for Reset  
						safeZone.TowerLight.TL_DO_Yellow 	:= Std.Clock500ms AND safeZone.ResetReady; //Flash Yellow when ready to be reset
						safeZone.TowerLight.TL_DO_Green 	:= safeZone.Zone_Status;

					10://Master Reset Zone about to start
						safeZone.TowerLight.TL_DO_Sounder := TRUE;
						safeZone.TowerLight.TL_DO_Red := Std.Clock200ms; //Red fast flash indicates zone will reset
				END_CASE;
				
			ELSE // Master Zone lamp controls
				safeZone.TowerLight.TL_DO_Red 		:= FALSE;
				safeZone.TowerLight.TL_DO_Yellow	:= FALSE;
				safeZone.TowerLight.TL_DO_Green	:= FALSE;	
				
				IF safeZone.HaltSys AND NOT safeZone.ResetReady THEN	//Emergency stop blink red. (State 1)
					safeZone.TowerLight.TL_DO_Red 		:= Std.Clock1s ;
				ELSIF safeZone.HaltSys THEN // Estop waiting for reset  (State 2)
					safeZone.TowerLight.TL_DO_Yellow		:= Std.Clock1s;
				ELSIF alarmCondition[s] THEN //State 10 -- Show Warning Not Fault when alarm is on as other parts might still be running		
					safeZone.TowerLight.TL_DO_Yellow 	:= TRUE;		
					safeZone.TowerLight.TL_DO_Green	 := TRUE;
				ELSE //Machine Running (State 6)	
					safeZone.TowerLight.TL_DO_Green	 := TRUE;	
				END_IF;		
				safeZone.TowerLight.TL_DO_Sounder := (alarmCondition[s] AND NOT tmrAlmOutput[s].Q);	
					
			END_IF;		

			//-------------------------------------------------------------
			//-------END-Set tower light status-&-TV-Indicators-END--------
			//-------------------------------------------------------------


			//Check if the master reset has reset all zones.
			IF (masterReset[n] AND NOT safeZone.Zone_Status) THEN 
				resetRequired[s] := 1;	
			END_IF;	

			safeZone.DoorLock := lockDoor[n];
			safeZone.LiftGates := (safeZone.Zone_Status AND (safeZone.BagsInTransit OR NOT safeZone.AccessRequested)); // Edge protection gates.
			safeZone.HaltSys := NOT(safeZone.Zone_Status AND NOT safeZone.Disable);	
		END_IF;		


	END_FOR;

	IF NOT resetRequired[s] THEN
		masterResetRequest[s] := 0;	
	END_IF;	
	resetRequired[s] := 0;	

	//Flash reset btn on main cabinet
	IF masterResetRequest[s] THEN // We can do a master reset and not out safe 0 to reset
		SafetyZone[startZone[s]].Main_Lamp := Std.Clock200ms;
	ELSE
		SafetyZone[startZone[s]].Main_Lamp := Std.Clock1s AND NOT SafetyZone[startZone[s]].Zone_Status;
	END_IF;	


END_FOR;



END_PROGRAM

