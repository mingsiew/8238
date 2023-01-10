(*Insert your comment here.*)

TYPE
	Fuse_typ : 	STRUCT 
		Info : Fuse_Info_typ;
		Functions : FuseFunctions_typ;
		pDevice : UDINT; (**pointer to Address on IO Link interface*)
		Settings : FuseSetting_typ;
		Internal : FuseInternal_typ;
	END_STRUCT;
	Fuse_Info_typ : 	STRUCT  (*Actual Values Being read from the fuse*)
		CommsOk : BOOL; (*Comms Is Healthy*)
		NoNodes : USINT; (*91 - 8bit RO*)
		MinVoltage : INT; (*101 - 16Bit  R/W*)
		MaxVoltage : INT; (*100 - 16Bit  R/W*)
		InputVoltage : UINT;
		Channel : ARRAY[1..MAX_FUSE_CHANNELS]OF FuseChannel_Info_typ;
	END_STRUCT;
	FuseChannel_Info_typ : 	STRUCT 
		Type : FuseType_enum;
		Status : FuseStatus_enum;
		TripCurrent : USINT;
		ActualCurrent : UINT;
	END_STRUCT;
	FuseType_enum : 
		(
		EB_UNKNOWN := 0,
		EB_3824_100_0 := 170,
		EB_0824_100_0 := 138,
		EB_1824_010_0 := 145,
		EB_1824_020_0 := 146,
		EB_1824_030_0 := 147,
		EB_1824_040_0 := 148,
		EB_1824_060_0 := 150,
		EB_1824_080_0 := 152,
		EB_1824_100_0 := 154
		);
END_TYPE

(*Split up the function blocks, so we can read multiple pieces of data at once.*)

TYPE
	FuseFunctions_typ : 	STRUCT 
		Read_8 : ioLinkRead; (*Read 8 bit register*)
		Read_16 : ioLinkRead; (*Read 16 register*)
		Write : ioLinkWrite;
	END_STRUCT;
	FuseInternal_typ : 	STRUCT  (*Internal bits for use*)
		config_state : UINT;
		LastError : UINT;
		Data_8 : USINT;
		Data_16 : UINT;
		WriteData : UINT;
	END_STRUCT;
	FuseStatus_enum : 
		(
		EB_STATE_NC := 0, (*Not connected*)
		EB_STATE_OFF := 1, (*Switched Off - via software resetable*)
		EB_STATE_ON := 2, (*Switch On*)
		EB_STATE_TRIP := 3, (*Tripped*)
		EB_STATE_I_90 := 6, (*Current Exceeds 90%*)
		EB_STATE_I_100 := 14, (*Current Exceeds 100%*)
		EB_STATE_TRIP_HARDWARE := 18, (*Tripped - Hardware Error*)
		EB_STATE_TRIP_THERMAL := 20, (*Tripped - Thermal Release*)
		EB_STATE_TRIP_SW_OFF := 50 (*Switched Off Via the Button -- Cannot be overridden*)
		);
	visu_action_btn_typ : 	STRUCT 
		Visible : BOOL;
		Text : STRING[25];
		Value : BOOL;
		visu_style : STRING[20] := 'KannegiesserBlue';
	END_STRUCT;
END_TYPE
