
ACTION _config: 
	
	state 		ACCESS ADR(fuse.Internal.config_state);
	read_8		ACCESS ADR(fuse.Functions.Read_8);
	read_16		ACCESS ADR(fuse.Functions.Read_16);
	write		ACCESS ADR(fuse.Functions.Write);
	error		ACCESS ADR(fuse.Internal.LastError);
	
	read_8.pDeviceName 		:= fuse.pDevice;
	read_8.pData			:= ADR(fuse.Internal.Data_8);
	read_8.datatype 		:= ioLinkTYPE_USINT;
	read_8.dataLen			:= SIZEOF(fuse.Internal.Data_8);
	read_8.subIndex 		:= 0;
	
	read_16.pDeviceName 	:= fuse.pDevice;
	read_16.pData			:= ADR(fuse.Internal.Data_16);
	read_16.datatype 		:= ioLinkTYPE_UINT;
	read_16.dataLen			:= SIZEOF(fuse.Internal.Data_16);
	read_16.subIndex 		:= 0;
	
	write.pDeviceName := fuse.pDevice;
	write.pData 	:= ADR(fuse.Internal.WriteData);
	
	CASE state OF
		0:// Init  Turn of all functions just in case.	
			fuse.Info.CommsOk := 0;	
			state := 1;
		
		1://
			read_8.enable 	:= 0;
			read_8();
			IF (read_8.status = ERR_FUB_ENABLE_FALSE) THEN
				state := 2;	
			END_IF;

		2:	
			read_16.enable 	:= 0;
			read_16();
			IF (read_16.status = ERR_FUB_ENABLE_FALSE) THEN
				state := 3;		
			END_IF;
			
		3..9: 	
			write.enable := 0;
			write();
			IF (write.status = ERR_FUB_ENABLE_FALSE) THEN
				state := 10;		
			END_IF;
			
		10://Read the number of nodes.
			read_8.enable 	:= 1;			
			read_8.index		:= 91;
			read_8();	
			IF (read_8.status = ERR_OK) THEN	
				fuse.Info.CommsOk := 1;
				fuse.Info.NoNodes := fuse.Internal.Data_8;					
				fuse.Internal.Data_8 := 0;
				IF (fuse.Info.NoNodes > 0) THEN
					IF fuse.Info.NoNodes > MAX_FUSE_CHANNELS THEN
						fuse.Info.NoNodes := MAX_FUSE_CHANNELS;
					END_IF;	
					state := 11;
				ELSE
					state := 0;	
				END_IF;
			ELSIF (read_8.status <> ERR_FUB_BUSY) AND (read_8.status <> ERR_FUB_ENABLE_FALSE)  THEN  // Error read_8ing re initialise
				error := read_8.status;
				fuse.Info.CommsOk := 0;
				state := 0;
			END_IF;	
			
		11..50:// read_8 the type  MAX 40 Fuses.	
			channel := (state - 10);
			IF channel <= fuse.Info.NoNodes THEN
				read_8.enable 	:= 1;			
				read_8.index		:= 900 + channel;
				read_8();	
				IF (read_8.status = ERR_OK) THEN	
					fuse.Info.Channel[channel].Type := fuse.Internal.Data_8;					
					state := state + 1;
				ELSIF (read_8.status <> ERR_FUB_BUSY) AND (read_8.status <> ERR_FUB_ENABLE_FALSE)  THEN  // Error read_8ing re initialise
					fuse.Info.CommsOk := 0;
					state := 0;
				END_IF;		
			ELSE
				state := 51;
			END_IF;		
		
		51..90:// read_8 the trip current
			channel := (state - 50);
			IF channel <= fuse.Info.NoNodes THEN	
				read_8.enable 	:= 1;			
				read_8.index		:= 400 + channel;
				read_8();	
				IF (read_8.status = ERR_OK) THEN	
					fuse.Info.CommsOk := 1;
					fuse.Info.Channel[channel].TripCurrent := fuse.Internal.Data_8;					
					state := state + 1;
				ELSIF (read_8.status <> ERR_FUB_BUSY) AND (read_8.status <> ERR_FUB_ENABLE_FALSE)  THEN  // Error reading re initialise
					state := 0;
				END_IF;		
			ELSE
				state := 91;
			END_IF;	
		
		91://Release the function block	
			read_8.enable := 0;	
			read_8();
			IF (read_8.status = ERR_FUB_ENABLE_FALSE) THEN	
				state := 92;	
			END_IF;			
			
		92..93: // Read the max voltage
			read_16.enable := 1;			
			read_16.datatype := ioLinkTYPE_INT;
			read_16.index		:= 100;
			read_16();	
			IF (read_16.status = ERR_OK) THEN	
				fuse.Info.CommsOk := 1;
				fuse.Info.MaxVoltage := fuse.Internal.Data_16;				
				state := state + 1;
			ELSIF (read_16.status <> ERR_FUB_BUSY) AND (read_16.status <> ERR_FUB_ENABLE_FALSE)  THEN  // Error read_16ing re initialise
				fuse.Info.CommsOk := 0;
				state := 0;
			END_IF;		

			
		94:// Read the Min Voltage;
			read_16.enable 	:= 1;			
			read_16.datatype := ioLinkTYPE_INT;
			read_16.index		:= 101;
			read_16();	
			IF (read_16.status = ERR_OK) THEN	
				fuse.Info.CommsOk := 1;
				fuse.Info.MinVoltage :=  fuse.Internal.Data_16;				
				state := state + 1;
			ELSIF (read_16.status <> ERR_FUB_BUSY) AND (read_16.status <> ERR_FUB_ENABLE_FALSE)  THEN  // Error reading re initialise
				fuse.Info.CommsOk := 0;
				state := 0;
			END_IF;		
	
		95..100: // Disable the 16 way 
			read_16.enable := 0;	
			read_16();
			IF (read_16.status = ERR_FUB_ENABLE_FALSE) THEN	
				state := 101;	
			END_IF;		

		101..140: // Read the channel status
			channel := (state - 100);
			IF channel <= fuse.Info.NoNodes THEN
				read_8.enable := 1;
				read_8.index := 500 + channel;
				read_8();
				IF (read_8.status = ERR_OK) THEN
					fuse.Info.Channel[channel].Status := fuse.Internal.Data_8;
					state := state + 1;	
				END_IF;
			ELSE
				state := 141;
			END_IF;	
				
		
		141: // Decide what to do next?	
			//Check for differences then write if required
			//Check if the Min voltage has changed.	
			IF (fuse.Info.MinVoltage <> fuse.Settings.MinVoltage) AND (fuse.Settings.MinVoltage > 0) THEN	
				state := 150;		
			END_IF;	
			//Check if the Max voltage has changed.
			IF (fuse.Info.MaxVoltage <> fuse.Settings.MaxVoltage) AND (fuse.Settings.MaxVoltage > 0) THEN	
				state := 151;		
			END_IF;	
			IF (fuse.Info.NoNodes > 0) THEN
				// Check if the trip current has changed 
				FOR n := 1 TO fuse.Info.NoNodes DO 
					IF (fuse.Info.Channel[n].TripCurrent <> fuse.Settings.Channel[n].TripCurrent) AND (fuse.Settings.Channel[n].TripCurrent > 0) THEN
						state := 161;
						EXIT;
					END_IF;	
				END_FOR;
				// Check if the state has changed	
				FOR n := 1 TO fuse.Info.NoNodes DO
					CASE fuse.Info.Channel[n].Status  OF
						EB_STATE_NC, EB_STATE_TRIP_SW_OFF:  // We cannot do anything is software. 
							// We can;t do anything.
							
						EB_STATE_ON,EB_STATE_I_90, EB_STATE_I_100:
							IF (fuse.Settings.Channel[n].SetState = EB_SET_STATE_OFF ) THEN
								state := 200 + n;
								EXIT;
							END_IF;	
	
						EB_STATE_TRIP, EB_STATE_TRIP_THERMAL, EB_STATE_TRIP_HARDWARE: 
							IF (fuse.Settings.Channel[n].SetState = EB_SET_STATE_RESET ) THEN
								state := 200 + n;
								EXIT;
							END_IF;				
						
						EB_STATE_OFF: // Turned off by hand
							IF (fuse.Settings.Channel[n].SetState = EB_SET_STATE_ON ) THEN
								state := 200 + n;
								EXIT;
							END_IF;		
					END_CASE;
					IF (state = 141) THEN
						fuse.Settings.Channel[n].SetState := 0;	// Setting is not valid and cannot be actioned so clear it.
					END_IF;
				END_FOR;	
				
				IF (state = 141) THEN
					state := 101;	
				END_IF;	
				
			ELSE
				state := 0;
			END_IF;	
		
		142: // Disable the write FUB	AND read all the settings again.	
			write.enable := 0;
			write();
			IF (write.status = ERR_FUB_ENABLE_FALSE) THEN
				state := 0;		
			END_IF;
	
		150:// Write the Min Voltage
			fuse.Internal.WriteData := fuse.Settings.MinVoltage;
			write.enable := (fuse.Internal.WriteData > 0);
			write.index := 101;
			write.dataLen := 2;
			write.datatype := ioLinkTYPE_UINT;
			write();
			IF write.status = ERR_OK THEN
				state := 142;
			ELSIF (write.status < ERR_FUB_ENABLE_FALSE) THEN	
				state := 0;		
			ELSIF (fuse.Internal.WriteData = 0) THEN
				state := 142;	
			END_IF;	
			
			
		151:// Write the Max Voltage
			fuse.Internal.WriteData := fuse.Settings.MaxVoltage;
			write.enable := (fuse.Internal.WriteData > 0);
			write.index := 100;
			write.dataLen := 2;
			write.datatype := ioLinkTYPE_UINT;
			write();
			IF write.status = ERR_OK THEN
				state := 142;
			ELSIF (write.status < ERR_FUB_ENABLE_FALSE) THEN	
				error := write.status;
				state := 0;		
			ELSIF (fuse.Internal.WriteData = 0) THEN
				state := 142;	
			END_IF;
			

					
		161..200:// Write the trip current current			
			writeChannel := (state - 160);
			IF writeChannel > fuse.Info.NoNodes THEN
				state := 142;
			ELSE	
				fuse.Internal.WriteData := fuse.Settings.Channel[writeChannel].TripCurrent;
				write.enable := (fuse.Internal.WriteData > 0);
				write.index := 400 + writeChannel;
				write.datatype := ioLinkTYPE_USINT;
				write.dataLen := 1;
				write();
				IF (write.status = ERR_OK) THEN
					state := state + 1;
				ELSIF (write.status = ERR_FUB_ENABLE_FALSE) THEN // Nothing to do 
					state := state + 1;
				ELSIF (write.status <> ERR_FUB_BUSY) THEN	
					error := write.status;
					state := 0;
				END_IF;			
			END_IF;		
				
		201..240:// Write the state.	
			writeChannel := (state - 200);
			IF writeChannel > fuse.Info.NoNodes THEN
				state := 142;
			ELSE	
				CASE fuse.Settings.Channel[writeChannel].SetState OF  // Manual setting of state.
					0: // Do nothing
						fuse.Internal.WriteData := 0;
					EB_SET_STATE_ON:// Digital ON  -- This will not override a push button OFF  
						fuse.Internal.WriteData := ((writeChannel - 1) * 5) + 1; 
					EB_SET_STATE_OFF:// Digital OFF
						fuse.Internal.WriteData := ((writeChannel - 1) * 5) + 2; 
					EB_SET_STATE_RESET:// Reset
						fuse.Internal.WriteData := ((writeChannel - 1) * 5) + 3; 
				END_CASE;				
				write.enable := (fuse.Internal.WriteData > 0);
				write.index := 80;
				write.datatype := ioLinkTYPE_USINT;
				write.dataLen := 1;
				write();
				IF (write.status = ERR_OK) THEN
					fuse.Settings.Channel[writeChannel].SetState := 0;
					state := 142;
				ELSIF (write.status = ERR_FUB_ENABLE_FALSE) THEN // Nothing to do 
					state := 142;
				ELSIF (write.status <> ERR_FUB_BUSY) THEN	
					error := write.status;
					state := 0;		
				ELSIF (fuse.Internal.WriteData = 0) THEN
					state := 142;	
				END_IF;	
			END_IF;
		
	END_CASE;	
	
	
	
	
END_ACTION
