
//V1.00.0 -- First Release
//V1.00.1 -- Update so we monitor the status of the fuse and can send reset commands
//V1.00.2 -- Invert the fault lamp to a healthy lamp to stay consistent with hardwired devices
//V1.00.3 -- 03 March 2021. Improve error handling, on IO link fault

//V2.00.1 -- 19/03/2021  - Rewrite for better performance and add mappview hooks
//V2.00.2	-- Refactor as io link has a limit of 7 simultaneous function blocks
//V2.00.3	-- Refactor as io link has a limit of 7 simultaneous function blocks  Read/Write combined. not exclusive
//V2.00.4 -- Add visualization code so we can read out the live values.
//V2.00.5 -- Add front end visu


PROGRAM _INIT
	Fuse[1].pDevice := ADR('SL1.IF1.ST21.IF1.ST4.IF1'); 
	Fuse[2].pDevice := ADR('SL1.IF1.ST21.IF1.ST4.IF2');
	Fuse[3].pDevice := ADR('SL1.IF1.ST21.IF1.ST4.IF3');	
	Fuse[4].pDevice := ADR('SL1.IF1.ST21.IF1.ST5.IF1');	
	Fuse[5].pDevice := ADR('SL1.IF1.ST21.IF1.ST5.IF2'); 
	Fuse[6].pDevice := ADR('SL1.IF1.ST21.IF1.ST5.IF3');
	Fuse[7].pDevice := ADR('SL1.IF1.ST21.IF1.ST6.IF1');	
	//
	Fuse[8].pDevice := ADR('SL1.IF1.ST22.IF1.ST4.IF1');		
	Fuse[9].pDevice := ADR('SL1.IF1.ST22.IF1.ST4.IF2');	
	Fuse[10].pDevice := ADR('SL1.IF1.ST22.IF1.ST4.IF3');	
	Fuse[11].pDevice := ADR('SL1.IF1.ST22.IF1.ST5.IF1');
	//Fuse[12].pDevice := ADR('SL1.IF1.ST22.IF1.ST5.IF2');
	//Fuse[13].pDevice := ADR('SL1.IF1.ST22.IF1.ST5.IF3');


	gSettings.Fuse[1].GroupID := 'F71';	
	gSettings.Fuse[2].GroupID := 'F72';	
	gSettings.Fuse[3].GroupID := 'F81';		
	gSettings.Fuse[4].GroupID := 'F73';		
	gSettings.Fuse[5].GroupID := 'F74';	
	gSettings.Fuse[6].GroupID := 'F75';	
	gSettings.Fuse[7].GroupID := 'F76';	
	//
	gSettings.Fuse[8].GroupID := 'F71';	
	gSettings.Fuse[9].GroupID := 'F72';		
	gSettings.Fuse[10].GroupID := 'F81';		
	gSettings.Fuse[11].GroupID := 'F73';		
	//gSettings.Fuse[12].GroupID := 'F73';		
	//gSettings.Fuse[13].GroupID := 'F73';
	
	visu_index := 1;
	//alarm 	ACCESS ADR(Alarm[208]);	
	FOR n := 1 TO MAX_FUSE_BANKS DO	
		visu_settings ACCESS ADR(gSettings.Fuse[n]);		
		IF (visu_settings.MinVoltage = 0) THEN visu_settings.MinVoltage := 1900; END_IF;
		IF (visu_settings.MaxVoltage = 0) THEN visu_settings.MaxVoltage := 2850; END_IF;
		FOR i := 1 TO MAX_FUSE_CHANNELS DO
			IF (visu_settings.Channel[i].TripCurrent = 0) THEN visu_settings.Channel[i].TripCurrent := 40; END_IF;
			IF (visu_settings.Channel[i].FuseID = '') THEN
				brsitoa(i,ADR(sIndex)); 
				visu_settings.Channel[i].FuseID := Fuse[n].Settings.GroupID;
				brsstrcat(ADR(visu_settings.Channel[i].FuseID),ADR('.'));
				brsstrcat(ADR(visu_settings.Channel[i].FuseID),ADR(sIndex));
			END_IF;
		END_FOR;
	END_FOR;
END_PROGRAM

PROGRAM _CYCLIC

	IF EDGEPOS(X[1005].X04) THEN
		reset[0] := 1;	
	END_IF;		
	IF EDGEPOS(X[2005].X04) THEN
		reset[1] := 1;	
	END_IF;	
	
	fuseFault[0] := 0;
	fuseFault[1] := 0;	
	//alarm.On	:= 0;
	//alarm.Name	:= 0;		

	//	IF visu_id <= MAX_FUSE_BANKS THEN
	//	visu_data ACCESS ADR(Fuse[visu_id]);
	//ELSE		
	//	visu_data ACCESS ADR(Fuse[0]);	
	//END_IF;	

	FOR n := 1 TO MAX_FUSE_BANKS DO	
		fuse ACCESS ADR(Fuse[n]);		
	
		fuse.Settings := gSettings.Fuse[n];	
	
		//Set up and monitoring of the fuses
		_config;
		// Monitor the state for messaging and alarms.
		IF fuse.Info.NoNodes > 0 THEN
			FOR i := 1 TO fuse.Info.NoNodes DO	
				CASE fuse.Info.Channel[i].Status OF 
					EB_STATE_NC: // Not connected
			
					EB_STATE_OFF: 
			
					EB_STATE_ON:	
				
					EB_STATE_TRIP:	
						fuseFault[1] := 1;		
			
					EB_STATE_I_90:
			
					EB_STATE_I_100:
				
					EB_STATE_TRIP_HARDWARE: // Fuse failed
			
					EB_STATE_TRIP_THERMAL: 
						fuseFault[1] := 1;	
			
					EB_STATE_TRIP_SW_OFF: // Turned off by hand
				
				END_CASE;
			END_FOR;	
		END_IF;	
	
	END_FOR;

	
	// Read live values when required.	
	_visuRead; 
				

	//Y[1006].Y10 := NOT fuseFault[0];	
	//Y[2006].Y10 := NOT fuseFault[1];	

END_PROGRAM



