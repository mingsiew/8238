//Visualisation controll
ACTION _visuControl: 
		
	//Set the index of the camera we are looking at.
	IF (visu.cameraID <= 0) THEN 
		visu.cameraID := MAX_CAMERAS;	
	ELSIF (visu.cameraID > MAX_CAMERAS) THEN
		visu.cameraID := 1;	
	END_IF;
	
	visu_camera 	ACCESS ADR(Camera[visu.cameraID]);
	visu_settings 	ACCESS ADR(gSettings.Camera[visu.cameraID]);
	state 			ACCESS ADR(visu_camera.Internal.state);
	
	IF (visu.cameraID <> lastID) THEN
		
		visu.reload 		:= 1; 
		lastID 				:= visu.cameraID;	
	END_IF;		

	IF EDGEPOS(visu.cmd.AutoTune AND state = CAMERA_AUTO_TEACH_DONE) THEN
		visu.cmd.AutoTune := 0;		
	END_IF;	
	
	IF visu_camera.Functions.ImageAquisitionComplete.Q AND visu.cmd.Capture  THEN
		visu.reload 		:= 1; 
		visu.cmd.Capture 	:= 0;
		visu_camera.Internal.readCount := 0; //Reset the read count as the image was manually triggered
	END_IF;	
	
	tof_repeat.IN := (visu_camera.Functions.ImageAquisitionComplete.Q AND visu.cmd.Repeat); 
	tof_repeat.PT := T#250ms;//4FPS
	tof_repeat();
	
	IF EDGENEG(tof_repeat.Q) THEN
		visu.cmd.Capture := 1;
	END_IF;
	
	IF EDGEPOS( visu.cmd.Repeat) THEN
		IF (state = CAMERA_READY) THEN			
			visu.cmd.Capture := 1;	
		ELSE	
			visu.cmd.Repeat := 0;	
		END_IF;	
	END_IF;
	
	IF visu.reload THEN // Build a path with the timestamp so we can force the mapp image widget to update.
		//'http://192.168.201.17:8080/jpg?q=50t={timevalue}';
		itoa(ABS(clock_ms()),ADR(timeString));
		buildURL := web_path[visu.cameraID];
		brsstrcat(ADR(buildURL),ADR(timeString));
		visu.ImageAddress := buildURL;
		visu.reload := 0;	
	END_IF;	
		
	
	IF EDGEPOS(visu.cmd.SaveSettings) THEN
		camera.Parameters.Write.Focus 			:= settings.Focus;
		camera.Parameters.Write.Gain 			:= settings.Gain;		
		camera.Parameters.Write.Exposure 		:= settings.Exposure;	
		//		camera.Parameters.Write.FlashSegment 	:= settings.FlashSegment;		
		//		camera.Parameters.Write.FlashColour 	:= settings.FlashColour;		
		//		camera.Parameters.Write.NumSearchMax 	:= settings.NumSearchMax;
		//		camera.Parameters.Write.SymbolType	 	:= settings.SymbolType;		
		camera.Parameters.Write.Timeout	 		:= settings.Timeout;	
		visu.cmd.SaveSettings := 0;
	END_IF;
	
	visu.voltageOk := visu_camera.ModuleOk AND NOT visu_camera.Errors.UnderVoltage;
	
	visu.buttonEnable.Tune 		:= (((state = CAMERA_READY) OR (state = CAMERA_AUTO_TEACH_DONE) OR (state = CAMERA_NOT_READY)) AND NOT visu.cmd.Repeat);
	visu.buttonEnable.Capture 	:= ((state = CAMERA_READY) OR visu.cmd.Capture) AND NOT visu.cmd.Repeat;
	visu.buttonEnable.Repeat 	:= ((state = CAMERA_READY) OR visu.cmd.Repeat);
	visu.enableSettings			:= (state <> CAMERA_AUTO_TEACH);
	
END_ACTION
