
TYPE
	visu_typ : 	STRUCT  (**Data type for camera mappview*)
		cameraID : USINT; (**ID of the camera we are looking at.*)
		reload : BOOL; (**Command to reload the web viewer*)
		cmd : visu_cmd_typ;
		voltageOk : BOOL;
		ImageAddress : STRING[100]; (**Ip Address of Image Path*)
		buttonEnable : visu_btn_status_typ;
		enableSettings : BOOL; (**Enable input of manually setting camera settings.*)
	END_STRUCT;
	visu_cmd_typ : 	STRUCT 
		AutoTune : BOOL; (**Auto Tune*)
		Capture : BOOL; (**Get a single image*)
		Repeat : BOOL; (**Repeat capture image*)
		SaveSettings : BOOL; (**Apply the setting values*)
	END_STRUCT;
	visu_btn_status_typ : 	STRUCT 
		Tune : BOOL;
		Repeat : BOOL;
		Capture : BOOL;
	END_STRUCT;
END_TYPE
