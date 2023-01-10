
TYPE
	SafeTowerLightType : 	STRUCT 
		TL_DO_Green : BOOL; (*Tower light output for Green light*)
		TL_DO_Yellow : BOOL; (*Tower light output for Yellow light*)
		TL_DO_Red : BOOL; (*Tower light output for Red light*)
		TL_DO_Sounder : BOOL; (*Tower light output for sounder*)
	END_STRUCT;
	SafeZoneType : 	STRUCT 
		TowerLight : SafeTowerLightType; (*Tower light structure*)
		AccessRequested : BOOL; (*Operator as requested access*)
		RequestAccess : BOOL; (*Command to request Access ON with Reset PB and Zone Status is Healthy.*)
		Main_Lamp : BOOL; (*Main panel lamp*)
		BagsInTransit : BOOL; (*True = Sequences are still not in a safe step*)
		HoistsOutOfPosition : BOOL; (*True = Hoists in zone are not parked*)
		Disable : BOOL; (*Passed into sequences to inhibit stepping on*)
		EDM : BOOL; (*EDM Feedback from linking relays*)
		ResetReady : BOOL; (*Zone is ready to be reset*)
		LiftGates : BOOL; (*Lift the edge protection gates.*)
		HaltSys : BOOL;
		Zone_Status : BOOL; (*State of the zone passed back from safe PLC*)
		PressureSwitch : BOOL;
		DoorLock : BOOL; (**Lock Doors in the area*)
		SafeInput : BOOL; (**Safety Input Condition Passed from Safe PLC*)
		ResetButton : BOOL;
		DataFromSafePLC : INT; (*Data from Safety PLC*)
	END_STRUCT;
	Safety_Hoist_type : 	STRUCT 
		O_OpenGuard : BOOL; (*Sliding guard output*)
		O_CloseGuard : BOOL; (*Sliding guard output*)
		OutOfPosition : BOOL; (*True when hoist is not in Service position*)
	END_STRUCT;
	Safety_typ : 	STRUCT 
		ModuleOk : BOOL;
		ModuleID : UDINT;
		FW_Version : UDINT;
		SFW_Version : UINT;
		UDID_low : UDINT;
		UDID_high : UINT;
		ModuleFault : BOOL;
		MasterReset_Comm : INT; (**Bits to do a master reset on a collection of safety zones*)
		EDM_Comm : DINT; (**EDM states packed for PLC comm*)
		Reset_Comm : DINT; (**Bits to reset zone with no reset button accessible via SD*)
	END_STRUCT;
	SM_type : 	STRUCT  (**Safety Module type*)
		ModuleOk : BOOL;
		SerialNumber : UDINT;
		ModuleID : UINT;
		HardwareVariant : UINT;
		FirmwareVersion : UINT;
		SafeModuleOK : BOOL;
		SafeDigitialInput01 : BOOL;
		SafeDigitialInput02 : BOOL;
		SafeDigitialInput03 : BOOL;
		SafeDigitialInput04 : BOOL;
		SafeDigitialInput05 : BOOL;
		SafeDigitialInput06 : BOOL;
		SafeDigitialInput07 : BOOL;
		SafeDigitialInput08 : BOOL;
		SafeTwoChannelInput0102 : BOOL;
		SafeTwoChannelInput0304 : BOOL;
		SafeTwoChannelInput0506 : BOOL;
		SafeTwoChannelInput0708 : BOOL;
		SafeTwoChannelOk0102 : BOOL;
		SafeTwoChannelOk0304 : BOOL;
		SafeTwoChannelOk0506 : BOOL;
		SafeTwoChannelOk0708 : BOOL;
		DigitalInput01 : BOOL;
		DigitalInput02 : BOOL;
		DigitalOutput01 : BOOL;
		DigitalOutput02 : BOOL;
	END_STRUCT;
END_TYPE
