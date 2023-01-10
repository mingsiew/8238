
TYPE
	Camera_typ : 	STRUCT 
		ModuleOk : BOOL;
		Node : USINT; (**Node number of the camera  -- To be automatically found.*)
		Parameters : Camera_param_typ;
		Info : Camera_Info_typ;
		Results : STRING[20];
		Errors : Camera_error_typ;
		Interface : Camera_interface_typ;
		Internal : Camera_internal_typ;
		Functions : Camera_function_typ;
	END_STRUCT;
	Camera_error_typ : 	STRUCT 
		UnderVoltage : BOOL;
		OS_check : BOOL; (*Operating system is loading*)
		VA_loading : BOOL; (*Visual Application is loading.*)
	END_STRUCT;
	Camera_Info_typ : 	STRUCT 
		Status : UDINT;
		AcceptedAcquisitionCnt : USINT;
		CompletedAcquisitionCnt : USINT;
		FailedAcquisitionCnt : USINT;
		ImageAcquisitionReady : BOOL;
		ImageProcessingActive : BOOL;
		ImageProcessingTime : UINT;
		ImageProcessingError : UINT;
		Temperature : SINT;
		NumResults : USINT;
		FunctionProcessingTime : UINT;
	END_STRUCT;
	Camera_interface_typ : 	STRUCT 
		Ready : BOOL; (**Camera is ready to read *)
		Read : BOOL; (**Set high to read the code.. Pos edge starts process. Neg Edge resets, and clears results*)
		ReadFail : BOOL; (**The read count has exceeded the maximum try count -- The camera will still try to read until the read command is removed.*)
		ResultReady : BOOL; (**Results are ready to be processed*)
		Result : STRING[20]; (**Raw string from barcode reader*)
		AutoTune : BOOL; (**Set high to autotune the camera.*)
		AutoTuneDone : BOOL; (**The camera has been successfully tuned.*)
	END_STRUCT;
	Camera_internal_typ : 	STRUCT 
		state : Camera_state_enum; (**Set high to read the code.. Pos edge starts process. Neg Edge resets, and clears results*)
		readCount : UINT; (**Number of reads on each count*)
		tuning : BOOL; (**Bit when the camera is in a tuning state.*)
	END_STRUCT;
	Camera_param_read_typ : 	STRUCT 
		Focus : UINT;
		Gain : USINT;
		Exposure : UDINT;
	END_STRUCT;
	Camera_param_typ : 	STRUCT 
		Read : Camera_param_read_typ;
		Write : Camera_param_write_typ;
	END_STRUCT;
	Camera_param_write_typ : 	STRUCT 
		Focus : UINT; (**Focus Value*)
		Gain : USINT; (**Camera Gain*)
		Exposure : UDINT; (**Camera Exposure time in uS*)
		FlashSegment : USINT; (**Sections of the Flash which should be active. 0 = All off. 15 = All on*)
		FlashColour : USINT; (**Flash color, Always 1 for RED*)
		StatusLED : USINT; (**Write to the status LED*)
		Enable : BOOL; (**Enable the barcode read function*)
		NumSearchMax : USINT; (** Number of barcodes we are looking to decode*)
		SymbolType : USINT; (**Type of barcode we are looking to decode*)
		Timeout : UINT;
		SearchAcquisitionSettings : BOOL; (**Enable Auto teach mode.*)
		ResetAcquisitionSettings : BOOL; (**Clear the results*)
		Read : BOOL; (**Command to Read*)
	END_STRUCT;
	Camera_Settings_typ : 	STRUCT 
		Focus : UINT; (**Focus Value*)
		Gain : USINT; (**Camera Gain*)
		Exposure : UDINT; (**Camera Exposure time in uS*)
		FlashSegment : USINT := 15; (**Sections of the Flash which should be active. 0 = All off. 15 = All on*)
		FlashColour : USINT := 1; (**Flash color, Always 1 for RED*)
		NumSearchMax : USINT := 1; (** Number of barcodes we are looking to decode*)
		SymbolType : USINT := 50; (**Type of barcode we are looking to decode*)
		Timeout : UINT := 0;
		ReadCount : UINT := 0; (**Read count before error flag comes on*)
		Name : STRING[50]; (*'Name for idenification*)
	END_STRUCT;
	Camera_state_enum : 
		(
		CAMERA_LOAD_SETTINGS := 0,
		CAMERA_READY := 1,
		CAMERA_GET_IMAGE := 2,
		CAMERA_RESULT_ACQUIRED := 3,
		CAMERA_AUTO_TEACH := 4,
		CAMERA_AUTO_TEACH_DONE := 5,
		CAMERA_NOT_READY := 6,
		CAMERA_NOT_PRESENT := 7,
		CAMERA_BOOTING := 8,
		CAMERA_RESET := 10, (**Reset between retrying to take image*)
		CAMERA_ERROR := 100
		);
	Camera_function_typ : 	STRUCT 
		ClearResults : F_TRIG;
		AutoTuneComplete : R_TRIG;
		ImageAquisitionComplete : F_TRIG;
		ReadEdgeNeg : F_TRIG;
		TonRetry : TON;
		TonReset : TON;
	END_STRUCT;
END_TYPE
