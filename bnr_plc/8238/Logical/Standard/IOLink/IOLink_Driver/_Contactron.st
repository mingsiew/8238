
ACTION _Contactron: 
	//----------------------------------------------
	//-----------------Contactron-------------------
	//----------------------------------------------

	//Write control word
	FOR n:=1 TO MAX_CONTACTRON DO
		IO_Link.Contactron[n].Comms.Read.CurrentActual := IO_Link.Contactron[n].Comms.Read.Data[0];
		IO_Link.Contactron[n].Comms.Read.DeviceType := IO_Link.Contactron[n].Comms.Read.Data[1];
		IO_Link.Contactron[n].Comms.Read.ThermalPercentOfMax := IO_Link.Contactron[n].Comms.Read.Data[2];
		IO_Link.Contactron[n].Comms.Read.CurrentPercentOfMax := IO_Link.Contactron[n].Comms.Read.Data[3];
		IO_Link.Contactron[n].Comms.Read.CurrentStatus := IO_Link.Contactron[n].Comms.Read.Data[4];
		IO_Link.Contactron[n].Comms.Read.Diagnostics := IO_Link.Contactron[n].Comms.Read.Data[5];

		
		//Read status
		IO_Link.Contactron[n].Status.Error := IO_Link.Contactron[n].Comms.Read.Diagnostics.0;
		IO_Link.Contactron[n].Status.STO_Active := NOT IO_Link.Contactron[n].Comms.Read.Diagnostics.3;
		IO_Link.Contactron[n].Status.Device_Ok := IO_Link.Contactron[n].Comms.Read.Diagnostics.5;
		IO_Link.Contactron[n].Status.Overload_Warning := IO_Link.Contactron[n].Comms.Read.Diagnostics.6;
		IO_Link.Contactron[n].Status.MainsFailure := ((IO_Link.Contactron[n].Comms.Read.CurrentStatus AND CONTACTRON_TRIP_STATUS) = CONTACTRON_MAINS_LOSS);
		IO_Link.Contactron[n].Status.PhaseLoss := ((IO_Link.Contactron[n].Comms.Read.CurrentStatus AND CONTACTRON_TRIP_STATUS) = CONTACTRON_PHASE_LOSS);
		IO_Link.Contactron[n].Status.Current := IO_Link.Contactron[n].Comms.Read.CurrentActual * 0.01;
		IO_Link.Contactron[n].Status.DeviceType := IO_Link.Contactron[n].Comms.Read.DeviceType;
		
		
		CASE IO_Link.Contactron[n].Cmd.Direction OF
			CONTACTRON_FORWARD:
				IO_Link.Contactron[n].Comms.Write.Control.0 := IO_Link.Contactron[n].Cmd.Run AND NOT IO_Link.Contactron[n].Status.Error;
				IO_Link.Contactron[n].Comms.Write.Control.7 := IO_Link.Contactron[n].Cmd.Run AND NOT IO_Link.Contactron[n].Status.Error;
				IO_Link.Contactron[n].Comms.Write.Control.1 := FALSE;
				IO_Link.Contactron[n].Comms.Write.Control.5 := FALSE;
			
			CONTACTRON_REVERSE:
				IO_Link.Contactron[n].Comms.Write.Control.0 := FALSE;
				IO_Link.Contactron[n].Comms.Write.Control.7 := FALSE;
				IO_Link.Contactron[n].Comms.Write.Control.1 := IO_Link.Contactron[n].Cmd.Run AND NOT IO_Link.Contactron[n].Status.Error;
				IO_Link.Contactron[n].Comms.Write.Control.5 := IO_Link.Contactron[n].Cmd.Run AND NOT IO_Link.Contactron[n].Status.Error;
			
			ELSE
				IO_Link.Contactron[n].Comms.Write.Control.0 := FALSE;
				IO_Link.Contactron[n].Comms.Write.Control.7 := FALSE;
				IO_Link.Contactron[n].Comms.Write.Control.1 := FALSE;
				IO_Link.Contactron[n].Comms.Write.Control.5 := FALSE;

		END_CASE;
		
		IO_Link.Contactron[n].Comms.Write.Control.2 := IO_Link.Contactron[n].Cmd.Reset_Manual;
		IO_Link.Contactron[n].Comms.Write.Control.3 := IO_Link.Contactron[n].Cmd.Reset_Automatic;
		IO_Link.Contactron[n].Comms.Write.Control.4 := FALSE; //NOT USED
		IO_Link.Contactron[n].Comms.Write.Control.6 := IO_Link.Contactron[n].Cmd.Stop;
		
		IF IO_Link.Contactron[n].Cmd.Current > 0 THEN //Write trip current level
			IO_Link.Contactron[n].Comms.Write.NominalCurrent := (IO_Link.Contactron[n].Cmd.Current OR CONTACTRON_WRITE_CURRENT);
		ELSE
			IO_Link.Contactron[n].Comms.Write.NominalCurrent := 0;
		END_IF;
		IF IO_Link.Contactron[n].Cmd.Current = (IO_Link.Contactron[n].Comms.Read.CurrentStatus AND CONTACTRON_CURRENT_STATUS) THEN
			IO_Link.Contactron[n].Cmd.Current := 0; //Reset trip current if cmd written
		END_IF;
	


	END_FOR;
END_ACTION
