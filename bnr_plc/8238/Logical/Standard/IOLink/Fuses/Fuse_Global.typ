
TYPE
	FuseSetting_typ : 	STRUCT 
		GroupID : STRING[20]; (*Fuse Group Name*)
		MinVoltage : INT;
		MaxVoltage : INT;
		Channel : ARRAY[1..MAX_FUSE_CHANNELS]OF FuseChannelSetting_typ;
	END_STRUCT;
	FuseChannelSetting_typ : 	STRUCT 
		FuseID : STRING[30]; (*Name can be to help identify the fuse*)
		SetState : USINT; (*State user wants to set the fuse too... Not Actual State*)
		TripCurrent : USINT;
	END_STRUCT;
END_TYPE
