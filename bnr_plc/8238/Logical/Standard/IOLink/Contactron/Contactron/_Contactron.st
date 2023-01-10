
ACTION _Contactron: 
	//----------------------------------------------
	//-----------------Contactron-------------------
	//----------------------------------------------

	//Write control word
	FOR n:=1 TO MAX_CONTACTRON DO
		contactron ACCESS ADR(IO_Link.Contactron[n]);
		
		
		IF Std.TestMode  THEN
			contactron.Status.Running := 1;
			IF contactron.Cmd.Run THEN
				contactron.Status.Current := 1.0;
			ELSE
				contactron.Status.Current := 0.0;
			END_IF;
			
		ELSE
			brsmemcpy(ADR(contactron.Comms.Read.CurrentActual) + 1,ADR(contactron.Comms.Read.Data[1]),1);//High Byte
			brsmemcpy(ADR(contactron.Comms.Read.CurrentActual),ADR(contactron.Comms.Read.Data[2]),1);// Low Byte
			contactron.Comms.Read.DeviceType 			:= contactron.Comms.Read.Data[3];//2
			contactron.Comms.Read.ThermalPercentOfMax 	:= contactron.Comms.Read.Data[4];//3
			contactron.Comms.Read.CurrentPercentOfMax 	:= contactron.Comms.Read.Data[5];//4
			contactron.Comms.Read.CurrentStatus 		:= contactron.Comms.Read.Data[6];//5
			contactron.Comms.Read.Diagnostics 			:= contactron.Comms.Read.Data[7];//6
			
		
			//Read status
			contactron.Status.Error 			:= contactron.Comms.Read.Diagnostics.0;
			contactron.Status.STO_Active 		:= NOT contactron.Comms.Read.Diagnostics.3;
			contactron.Status.Running 		:= contactron.Comms.Read.Diagnostics.5;
			contactron.Status.Overload_Warning 	:= contactron.Comms.Read.Diagnostics.6;
			contactron.Status.MainsFailure 		:= ((contactron.Comms.Read.CurrentStatus AND CONTACTRON_TRIP_STATUS) = CONTACTRON_MAINS_LOSS);
			contactron.Status.PhaseLoss 		:= ((contactron.Comms.Read.CurrentStatus AND CONTACTRON_TRIP_STATUS) = CONTACTRON_PHASE_LOSS);
			contactron.Status.Current 			:= contactron.Comms.Read.CurrentActual * 0.01;
			contactron.Status.DeviceType 		:= contactron.Comms.Read.DeviceType;
			
			
			IF contactron.Status.Error THEN
				run := 0;
			ELSIF contactron.Manual.Enable THEN
				run := 0;
				contactron.Comms.Write.Control.0 := contactron.Manual.RunForwards;
				contactron.Comms.Write.Control.7 := contactron.Manual.RunForwards;
				contactron.Comms.Write.Control.1 := contactron.Manual.RunReverse;
				contactron.Comms.Write.Control.5 := contactron.Manual.RunReverse;	
			ELSE	
				run := contactron.Cmd.Run;
			END_IF;
			
			IF NOT 	contactron.Manual.Enable THEN
				
				CASE contactron.Cmd.Direction OF
					CONTACTRON_FORWARD:
						contactron.Comms.Write.Control.0 := run;
						contactron.Comms.Write.Control.7 := run;
						contactron.Comms.Write.Control.1 := FALSE;
						contactron.Comms.Write.Control.5 := FALSE;
			
					CONTACTRON_REVERSE:
						contactron.Comms.Write.Control.0 := FALSE;
						contactron.Comms.Write.Control.7 := FALSE;
						contactron.Comms.Write.Control.1 := run;
						contactron.Comms.Write.Control.5 := run;
			
					ELSE
						contactron.Comms.Write.Control.0 := FALSE;
						contactron.Comms.Write.Control.7 := FALSE;
						contactron.Comms.Write.Control.1 := FALSE;
						contactron.Comms.Write.Control.5 := FALSE;
				END_CASE;
			END_IF;
			contactron.Comms.Write.Control.2 := contactron.Cmd.Reset_Manual OR contactron.Manual.ErrorReset;
			contactron.Comms.Write.Control.3 := contactron.Cmd.Reset_Automatic;
			contactron.Comms.Write.Control.4 := FALSE; //NOT USED
			contactron.Comms.Write.Control.6 := contactron.Cmd.Stop;
		
			IF contactron.Cmd.Current > 0 THEN //Write trip current level
				contactron.Comms.Write.NominalCurrent := (contactron.Cmd.Current OR CONTACTRON_WRITE_CURRENT);
			ELSE
				contactron.Comms.Write.NominalCurrent := 0;
			END_IF;
			IF contactron.Cmd.Current = (contactron.Comms.Read.CurrentStatus AND CONTACTRON_CURRENT_STATUS) THEN
				contactron.Cmd.Current := 0; //Reset trip current if cmd written
			END_IF;
	
		END_IF;
		
		//Clear the manual commands.
		contactron.Manual := CONTACTRON_MANUAL_DEFAULT;
	END_FOR;
END_ACTION
