
ACTION _visuRead: 

	IF (index < 1 ) OR (index > MAX_FUSE_BANKS) THEN
		index := 1;
	END_IF;	
	IF (visu_index < 1 ) THEN 
		visu_index := MAX_FUSE_BANKS;
	ELSIF(visu_index > MAX_FUSE_BANKS) THEN
		visu_index := 1;
	END_IF;		
	
	
	visu_fuse ACCESS ADR(Fuse[index]);
	visu_settings ACCESS ADR(gSettings.Fuse[index]);
	
	IF (visu_index <> last_visu_index) AND (visu_index > 0) THEN
		//Initialise visu settings.
		FOR n := 1 TO MAX_FUSE_CHANNELS DO
			brsitoa(gSettings.Fuse[visu_index].Channel[n].TripCurrent,ADR(visu_set_current[n])); 
		END_FOR;
		last_visu_index := visu_index;
	ELSIF (visu_index = 0) THEN
		last_visu_index := 0;	
	END_IF;
	
	readVoltage.pDeviceName := readCurrent.pDeviceName  := visu_fuse.pDevice;
	
	readVoltage.enable := 1;
	readVoltage.subIndex := readCurrent.subIndex :=  0;
	readVoltage.datatype := readCurrent.datatype := ioLinkTYPE_UINT;	
	readVoltage.pData		:= ADR(inputVoltage);
	readVoltage.dataLen	:= SIZEOF(inputVoltage);
	readVoltage.index := 90;
	readVoltage();		
	visu_fuse.Info.InputVoltage := inputVoltage;
	
	IF (act_current_channel < 1) THEN
		act_current_channel := 1;	
	END_IF;	
		
	//Cycle through the channel data
	readCurrent.enable := (act_current_channel <= visu_fuse.Info.NoNodes);
	readCurrent.pData		:= ADR(actualCurrent);
	readCurrent.dataLen	:= SIZEOF(actualCurrent);		
	readCurrent.index := 300 + act_current_channel;		
	readCurrent();
	IF (readCurrent.status = ERR_OK) THEN
		visu_fuse.Info.Channel[act_current_channel].ActualCurrent := actualCurrent;  // Scale the value here so we can see it correctly on the UI.
		act_current_channel := act_current_channel + 1;
	ELSIF (readCurrent.status = ERR_FUB_ENABLE_FALSE) THEN	
		IF (visu_index > 0) AND (visu_index <= MAX_FUSE_BANKS)  THEN
			index := visu_index;
		ELSE	
			index := index + 1;
		END_IF;	
		act_current_channel := 1;
	ELSIF (readCurrent.status <> ERR_FUB_BUSY) THEN	 //ERROR try the next fuse	
		visu_fuse.Info.Channel[act_current_channel].ActualCurrent := 100;//16#FFFF;  // Error value
		act_current_channel := act_current_channel + 1;	
	END_IF;
			
	
	IF (visu_fuse.Info.NoNodes > 0) AND (index = visu_index) AND (visu_index > 0) THEN
		FOR n := 1 TO visu_fuse.Info.NoNodes DO
			CASE visu_fuse.Info.Channel[n].Status OF
				EB_STATE_NC, EB_STATE_TRIP_SW_OFF, EB_STATE_TRIP_HARDWARE: // Fuse failed: // Turned off by hand: // Not connected
					visu_action[n].Visible := 0;
					visu_action[n].visu_style := 'Kg_Red';
					
				EB_STATE_OFF: 
					visu_action[n].Visible := 1;
					visu_action[n].Text  	:= '$$Fuses.Action.TurnOn';
					visu_action[n].visu_style := 'Kg_Red';
					IF visu_action[n].Value THEN
						visu_settings.Channel[n].SetState := EB_SET_STATE_ON;
						visu_action[n].Value := 0;
					END_IF;	

				EB_STATE_ON, EB_STATE_I_90, EB_STATE_I_100:	
					visu_action[n].Visible := 1;
					visu_action[n].Text  	:= '$$Fuses.Action.TurnOff';
					visu_action[n].visu_style := 'KannegiesserBlue';
					IF visu_action[n].Value THEN
						visu_settings.Channel[n].SetState := EB_SET_STATE_OFF;
						visu_action[n].Value := 0;
					END_IF;	
					
					
				EB_STATE_TRIP,EB_STATE_TRIP_THERMAL: 
					visu_action[n].Visible := 1;
					visu_action[n].Text  	:= '$$Fuses.Action.Reset';
					visu_action[n].visu_style := 'Kg_Orange';
					IF visu_action[n].Value THEN
						visu_settings.Channel[n].SetState := EB_SET_STATE_RESET;
						visu_action[n].Value := 0;
					END_IF;		
			END_CASE;	
			
			
			visu_settings.Channel[n].TripCurrent := DINT_TO_USINT(brsatoi(ADR(visu_set_current[n])));
		END_FOR
	END_IF;

	// We should clear the UI. if we are not reading correctly.
	IF (visu_index <> index) THEN
		visu_fuse.Info.CommsOk := 0;	
	END_IF;
	
END_ACTION
