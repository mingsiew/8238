
ACTION _EasyB: 
	//----------------------------------------------
	//--------------------Easy-B--------------------
	//----------------------------------------------
	
	//Read Controller Data
	IO_Link.EasyB.ControllerRead.enable := TRUE;
	IO_Link.EasyB.ControllerRead.pDeviceName := ADR(IO_Link.Device);
	
	CASE IO_Link.EasyB.ControllerState OF
		EASYB_READ_NUMBER_OF_NODES:
			//Specific function config
			IO_Link.EasyB.ControllerRead.index := 91;
			IO_Link.EasyB.ControllerRead.subIndex := 0;
			IO_Link.EasyB.ControllerRead.pData := ADR(IO_Link.EasyB.ControllerNumberOfNodes);
			IO_Link.EasyB.ControllerRead.dataLen := SIZEOF(IO_Link.EasyB.ControllerNumberOfNodes);
			IO_Link.EasyB.ControllerRead.datatype := ioLinkTYPE_SINT;
			IO_Link.EasyB.ControllerRead();
			//Goto next state
			IF IO_Link.EasyB.ControllerRead.status <> ERR_FUB_BUSY THEN
				IO_Link.EasyB.ControllerState := EASYB_READ_SUPPLY_VOLTAGE;
			END_IF;
			
		EASYB_READ_SUPPLY_VOLTAGE:
			//Specific function config
			IO_Link.EasyB.ControllerRead.index := 90;
			IO_Link.EasyB.ControllerRead.subIndex := 0;
			IO_Link.EasyB.ControllerRead.pData := ADR(IO_Link.EasyB.ControllerSupplyVoltage);
			IO_Link.EasyB.ControllerRead.dataLen := SIZEOF(IO_Link.EasyB.ControllerSupplyVoltage);
			IO_Link.EasyB.ControllerRead.datatype := ioLinkTYPE_INT;
			IO_Link.EasyB.ControllerRead();
			//Goto next state
			IF IO_Link.EasyB.ControllerRead.status <> ERR_FUB_BUSY THEN
				IO_Link.EasyB.ControllerState := EASYB_READ_NUMBER_OF_NODES;
			END_IF;
	END_CASE;
	
	//----------------------------------------------
	//-----------------Read Fuse Data---------------
	//----------------------------------------------
	FOR n:=1 TO MAX_EASYB DO
		IO_Link.EasyB.EasyB_Array[n].Comms.Read.enable := TRUE;
		IO_Link.EasyB.EasyB_Array[n].Comms.Read.pDeviceName := ADR(IO_Link.Device);
		
		CASE IO_Link.EasyB.EasyB_Array[n].State OF
			EASYB_READ_CURRENT:
				//Specific function config
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.index := 300 + n;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.subIndex := 0;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Status.Current);
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.dataLen := SIZEOF(IO_Link.EasyB.EasyB_Array[n].Status.Current);
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.datatype := ioLinkTYPE_INT;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read();
				//Goto next state
				IF IO_Link.EasyB.EasyB_Array[n].Comms.Read.status <> ERR_FUB_BUSY THEN
					IO_Link.EasyB.EasyB_Array[n].State := EASYB_READ_TRIPPED;
				END_IF;
			
			EASYB_READ_TRIPPED:
				//Specific function config
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.index := 500 + n;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.subIndex := 0;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Status.TripState);
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.dataLen := 1;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.datatype := ioLinkTYPE_USINT;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read();
				//Goto next state
				IF IO_Link.EasyB.EasyB_Array[n].Comms.Read.status <> ERR_FUB_BUSY THEN
					IO_Link.EasyB.EasyB_Array[n].State := EASYB_READ_TRIP_COUNT;
				END_IF;
			
			EASYB_READ_TRIP_COUNT:
				//Specific function config
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.index := 200 + n;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.subIndex := 0;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Status.TripCount);
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.dataLen := SIZEOF(IO_Link.EasyB.EasyB_Array[n].Status.TripCount);
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.datatype := ioLinkTYPE_USINT;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read();
				//Goto next state
				IF IO_Link.EasyB.EasyB_Array[n].Comms.Read.status <> ERR_FUB_BUSY THEN
					IO_Link.EasyB.EasyB_Array[n].State := EASYB_READ_TRIP_CURRENT;
				END_IF;
			
			EASYB_READ_TRIP_CURRENT:
				//Specific function config
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.index := 400 + n;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.subIndex := 0;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Status.TripCurrent);
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.dataLen := 1;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.datatype := ioLinkTYPE_USINT;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read();
				//Goto next state
				IF IO_Link.EasyB.EasyB_Array[n].Comms.Read.status <> ERR_FUB_BUSY THEN
					IO_Link.EasyB.EasyB_Array[n].State := EASYB_READ_FUSE_TYPE;
				END_IF;
			
			EASYB_READ_FUSE_TYPE:
				//Specific function config
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.index := 900 + n;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.subIndex := 0;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Status.Type);
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.dataLen := 1;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read.datatype := ioLinkTYPE_USINT;
				IO_Link.EasyB.EasyB_Array[n].Comms.Read();
				//Goto next state
				IF IO_Link.EasyB.EasyB_Array[n].Comms.Read.status <> ERR_FUB_BUSY THEN
					IO_Link.EasyB.EasyB_Array[n].State := EASYB_READ_CURRENT;
				END_IF;
		END_CASE;
		
		//----------------------------------------------
		//-----------------Write Fuse Data--------------
		//----------------------------------------------
		IO_Link.EasyB.EasyB_Array[n].Comms.Write.enable := TRUE;
		IO_Link.EasyB.EasyB_Array[n].Comms.Write.pDeviceName := ADR(IO_Link.Device);

		//Use ELSIF statement so only one action can happen at once as dataToWrite is shared.
		IF IO_Link.EasyB.EasyB_Array[n].Cmd.On THEN
			//Specific function config
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.index := 80;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.subIndex := 0;
			IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite := (1 + ((n-1)*5));
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite);
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.dataLen := 1;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.datatype := ioLinkTYPE_USINT;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write();
			//Goto next state
			IF IO_Link.EasyB.EasyB_Array[n].Comms.Write.status <> ERR_FUB_BUSY THEN
				IO_Link.EasyB.EasyB_Array[n].Cmd.On := FALSE;
			END_IF;
		ELSIF IO_Link.EasyB.EasyB_Array[n].Cmd.Off THEN
			//Specific function config
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.index := 80;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.subIndex := 0;
			IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite := (2 + ((n-1)*5));
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite);
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.dataLen := 1;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.datatype := ioLinkTYPE_USINT;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write();
			//Goto next state
			IF IO_Link.EasyB.EasyB_Array[n].Comms.Write.status <> ERR_FUB_BUSY THEN
				IO_Link.EasyB.EasyB_Array[n].Cmd.Off := FALSE;
			END_IF;
		ELSIF IO_Link.EasyB.EasyB_Array[n].Cmd.Reset THEN
			//Specific function config
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.index := 80;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.subIndex := 0;
			IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite := (3 + ((n-1)*5));
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite);
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.dataLen := 1;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.datatype := ioLinkTYPE_USINT;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write();
			//Goto next state
			IF IO_Link.EasyB.EasyB_Array[n].Comms.Write.status <> ERR_FUB_BUSY THEN
				IO_Link.EasyB.EasyB_Array[n].Cmd.Reset := FALSE;
			END_IF;
		ELSIF IO_Link.EasyB.EasyB_Array[n].Cmd.ClearCounter THEN
			//Specific function config
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.index := 83;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.subIndex := 0;
			IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite := n;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Comms.dataToWrite);
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.dataLen := 1;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.datatype := ioLinkTYPE_USINT;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write();
			//Goto next state
			IF IO_Link.EasyB.EasyB_Array[n].Comms.Write.status <> ERR_FUB_BUSY THEN
				IO_Link.EasyB.EasyB_Array[n].Cmd.ClearCounter := FALSE;
			END_IF;
		ELSIF IO_Link.EasyB.EasyB_Array[n].Cmd.SetTripCurrent > 0 THEN
			//Specific function config
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.index := 400 + n;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.subIndex := 0;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.pData := ADR(IO_Link.EasyB.EasyB_Array[n].Cmd.SetTripCurrent);
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.dataLen := 1;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write.datatype := ioLinkTYPE_USINT;
			IO_Link.EasyB.EasyB_Array[n].Comms.Write();
			//Goto next state
			IF IO_Link.EasyB.EasyB_Array[n].Comms.Write.status <> ERR_FUB_BUSY THEN
				IO_Link.EasyB.EasyB_Array[n].Cmd.SetTripCurrent := 0;
			END_IF;
		END_IF;
	END_FOR;
END_ACTION
