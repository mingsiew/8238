//V1.00.1 TR. 15/12/2020: ADD: Automatically populate camera ip and node.
//V1.00.2 TR. 19/02/2021: ADD: Allow auto tune when the image is not ready, Init focus/exposure settings.
//V1.00.3 TR  22/02/2021: ADD: New pre check state. to allow the camera to load its firmware without setting any bits.
//V1.00.4 TR  22/02/2021: UPDATE: Update to match new mappview -- Change the image widget from web view to image..   
//V1.00.5 TR 	26/05/2021: FIX: Camera could get stuck on the GET_IMAGE_STEP -> Added a retry timeout.
//V1.00.6 TR 	19/10/2021: ADD: Explicit state for retrying on time out, so we are sure to generate an edge on the Read command.

//http://10.8.4.20:81/index.html?visuid=mappvision  < -- DO NOT USE THIS ITS POOP

//?? Should we make auto retune on failure an option. or should the requester handle this on read fail?
//We can use the asHW TO detect when the camera is plugged into the system OR NOT as automatically make it visibile?

PROGRAM _INIT
	lastID 	:= 0;
	index 	:= 1;
	
	FOR n := 1 TO MAX_CAMERAS DO
		camera 		ACCESS ADR(Camera[n]);
		settings 	ACCESS ADR(gSettings.Camera[n]);	
		camera.Internal.state := CAMERA_LOAD_SETTINGS;
		//Initialise the fixed settings.
		settings.FlashColour 	:= 1;
		settings.FlashSegment 	:= 15;
		settings.NumSearchMax 	:= 1;
		settings.SymbolType 	:= 50;
		settings.Timeout		:= 50; // If set to 0 this is handled by the camera.
		
		IF (settings.Focus = 0) THEN settings.Focus := 1700; END_IF;
		IF (settings.Exposure = 0) THEN settings.Exposure := 35; END_IF;
		
		IF (settings.ReadCount = 0) THEN settings.ReadCount := 5; END_IF; 
	END_FOR;	
	
	xRun 	:= FALSE;
	init 	:= 0;
	index 	:= 0;
END_PROGRAM

PROGRAM _CYCLIC	

	IF EDGENEG(xRun) THEN
		FOR n := 1 TO MAX_CAMERAS DO
			Camera[n].Node := 0;
		END_FOR;	
		index 	:= 0;	
		init 	:= 0;
	ELSIF NOT xRun THEN	
		_initPaths;
	ELSE
		FOR n := 1 TO MAX_CAMERAS DO
			camera 		ACCESS ADR(Camera[n]);
			settings 	ACCESS ADR(gSettings.Camera[n]);		
			state 		ACCESS ADR(camera.Internal.state);
			
			camera.Errors.OS_check := camera.Info.Status.24;			
			camera.Errors.VA_loading := camera.Info.Status.25;
			
			IF camera.Errors.OS_check OR camera.Errors.VA_loading THEN
				state := CAMERA_BOOTING;
			ELSIF camera.Errors.UnderVoltage THEN
				state := CAMERA_ERROR;		
			ELSIF NOT camera.ModuleOk THEN
				state := CAMERA_NOT_PRESENT;	
			END_IF;
			
			CASE state OF
				CAMERA_LOAD_SETTINGS: // Load the settings from the camera setting area	
					camera.Parameters.Write.Focus 			:= settings.Focus;
					camera.Parameters.Write.Gain 			:= settings.Gain;		
					camera.Parameters.Write.Exposure 		:= settings.Exposure;	
					camera.Parameters.Write.FlashSegment 	:= settings.FlashSegment;		
					camera.Parameters.Write.FlashColour 	:= settings.FlashColour;		
					camera.Parameters.Write.NumSearchMax 	:= settings.NumSearchMax;
					camera.Parameters.Write.SymbolType	 	:= settings.SymbolType;		
					camera.Parameters.Write.Timeout	 		:= settings.Timeout;	
					camera.Internal.readCount				:= 0;
					IF camera.Info.ImageAcquisitionReady THEN
						state := CAMERA_READY;		
					ELSE		
						state := CAMERA_NOT_READY;		
					END_IF;	
				
				CAMERA_READY:		
					IF NOT camera.Info.ImageAcquisitionReady THEN
						state := CAMERA_NOT_READY;					
					ELSIF camera.Interface.Read OR visu.cmd.Capture THEN	
						state := CAMERA_GET_IMAGE;				
					ELSIF camera.Interface.AutoTune OR visu.cmd.AutoTune THEN
						state := CAMERA_AUTO_TEACH;		
					END_IF;	
					
				CAMERA_GET_IMAGE:				
					IF camera.Functions.ImageAquisitionComplete.Q THEN			
						camera.Internal.readCount := camera.Internal.readCount + 1;	
						IF (camera.Info.NumResults > 0) THEN			
							brsstrcpy(ADR(camera.Interface.Result),ADR(camera.Results));
							state := CAMERA_RESULT_ACQUIRED;						
						ELSE		
							state := CAMERA_RESET;
						END_IF;			
					ELSIF camera.Functions.TonRetry.Q THEN
						state := CAMERA_RESET;
					END_IF;

				CAMERA_RESULT_ACQUIRED:
					IF NOT camera.Interface.Read AND NOT visu.cmd.Capture THEN	 			
						IF NOT camera.Info.ImageAcquisitionReady THEN
							state := CAMERA_NOT_READY;					
						ELSE	
							state := CAMERA_RESET;				
						END_IF;				
					END_IF;
					
				CAMERA_AUTO_TEACH:
					IF camera.Info.Status > 0 THEN
						camera.Internal.tuning := 1;
					END_IF;		
					IF camera.Functions.AutoTuneComplete.Q THEN	
						settings.Exposure := camera.Parameters.Read.Exposure;
						settings.Focus := camera.Parameters.Read.Focus;	
						settings.Gain := camera.Parameters.Read.Gain;	
						state := CAMERA_AUTO_TEACH_DONE;	
					END_IF;	
		
				CAMERA_AUTO_TEACH_DONE:
					IF NOT camera.Interface.AutoTune AND NOT visu.cmd.AutoTune THEN		
						state := CAMERA_LOAD_SETTINGS;		
					END_IF;
					
				CAMERA_NOT_READY:		
					IF camera.Info.ImageAcquisitionReady THEN		
						state := CAMERA_LOAD_SETTINGS;
					ELSIF camera.Interface.AutoTune OR visu.cmd.AutoTune THEN
						state := CAMERA_AUTO_TEACH;	
					END_IF;			
				
				CAMERA_BOOTING: //loading OS or updating firmare.
					IF NOT camera.Errors.OS_check AND NOT camera.Errors.VA_loading THEN
						state := CAMERA_LOAD_SETTINGS;
					END_IF;
				
				CAMERA_RESET:	
					IF camera.Functions.TonReset.Q THEN	
						state := CAMERA_READY;	
					END_IF;	
					
				CAMERA_NOT_PRESENT:		
					IF camera.ModuleOk THEN	
						state := CAMERA_LOAD_SETTINGS;
					END_IF;	
		
				CAMERA_ERROR:	
					IF NOT camera.Errors.UnderVoltage THEN		
						state := CAMERA_LOAD_SETTINGS;
					END_IF;	
			
			END_CASE;
		
			camera.Parameters.Write.Read := (state = CAMERA_GET_IMAGE);		
			camera.Interface.ResultReady := (state = CAMERA_RESULT_ACQUIRED);		
			camera.Parameters.Write.Enable := ((state = CAMERA_READY) OR (state = CAMERA_RESULT_ACQUIRED) OR (state = CAMERA_GET_IMAGE));
			camera.Parameters.Write.SearchAcquisitionSettings := (state = CAMERA_AUTO_TEACH);
			
			camera.Functions.TonRetry.IN := (state = CAMERA_GET_IMAGE) AND NOT camera.Info.ImageProcessingActive;
			camera.Functions.TonRetry.PT := T#2s;
			camera.Functions.TonRetry();
			
			
			camera.Functions.TonReset.IN := (state = CAMERA_RESET);
			camera.Functions.TonReset.PT := T#100ms;
			camera.Functions.TonReset();	
			
			camera.Functions.AutoTuneComplete.CLK := (camera.Internal.tuning AND (camera.Info.Status = 0));	
			camera.Functions.AutoTuneComplete();
		
			camera.Functions.ClearResults.CLK := (state = CAMERA_RESULT_ACQUIRED);
			camera.Functions.ClearResults();		
	
			camera.Functions.ImageAquisitionComplete.CLK :=	camera.Info.ImageProcessingActive;
			camera.Functions.ImageAquisitionComplete();	
		
			camera.Functions.ReadEdgeNeg.CLK := camera.Interface.Read;	
			camera.Functions.ReadEdgeNeg();	
	
			IF camera.Functions.ReadEdgeNeg.Q THEN 	
				camera.Internal.readCount := 0;
			END_IF;		
			
			IF camera.Functions.ClearResults.Q THEN
				brsstrcpy(ADR(camera.Interface.Result),ADR(''));
				camera.Internal.readCount := 0;	
			END_IF;		
		
			camera.Interface.ReadFail := (camera.Internal.readCount >= settings.ReadCount);	
		
			IF (state = CAMERA_AUTO_TEACH) THEN 
				camera.Parameters.Write.StatusLED := CAMERA_LED_BLUE; 	
			ELSIF (state = CAMERA_AUTO_TEACH_DONE) THEN
				IF Std.Clock1s THEN		
					camera.Parameters.Write.StatusLED := CAMERA_LED_BLUE; 	
				ELSE
					camera.Parameters.Write.StatusLED := CAMERA_LED_DISABLED;	
				END_IF;
			ELSIF camera.Interface.ReadFail THEN	
				camera.Parameters.Write.StatusLED := CAMERA_LED_RED; 
			ELSE	
				camera.Parameters.Write.StatusLED := CAMERA_LED_AUTO; 		
			END_IF;
		
			IF (state <> CAMERA_AUTO_TEACH) THEN	
				camera.Internal.tuning := 0;		
			END_IF;	
	
			camera.Interface.Ready := (state = CAMERA_READY) AND (NOT visu.cmd.Repeat OR (visu.cameraID <> n));
			camera.Parameters.Write.ResetAcquisitionSettings := (state = CAMERA_NOT_READY);		
			camera.Interface.AutoTuneDone := (state = CAMERA_AUTO_TEACH_DONE); 
		
		END_FOR;		

		//Control for MappView	
	
		_visuControl;	
		

	END_IF;		
		
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

