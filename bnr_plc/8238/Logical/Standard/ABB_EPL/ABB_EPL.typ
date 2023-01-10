
TYPE
	ABB_EPL_Struct : 	STRUCT 
		Drives : ARRAY[1..MAX_DRIVES]OF ABB_EPL_typ;
	END_STRUCT;
	ABB_EPL_typ : 	STRUCT 
		Comm : ABB_EPL_Comm_typ;
		Cmd : ABB_EPL_cmd_typ;
		Status : ABB_EPL_status_typ;
		Config : EPL_Config;
		Manual : ABB_Manual_typ;
	END_STRUCT;
	ABB_EPL_Comm_typ : 	STRUCT 
		ControlWord : UINT;
		StatusWord : UINT;
		ModuleOk : BOOL;
		State : ABB_EPL_Comm_State_enum;
		TargetVelocity : INT; (*RPM*)
		ActVelocity : INT; (*RPM*)
		ActCurrent : DINT;
		ActTorque : DINT;
		ErrorCode : UINT;
	END_STRUCT;
	ABB_Motor_Size_enum : 
		(
		ABB_MOTOR_0_25KW := 0,
		ABB_MOTOR_0_37KW_0_91A_1374 := 1,
		ABB_MOTOR_0_37KW_0_97A_1342 := 2,
		ABB_MOTOR_0_37KW_1_14A_1380 := 3,
		ABB_MOTOR_0_75KW := 4,
		ABB_MOTOR_1_5KW := 5,
		ABB_MOTOR_2_2KW_4_75A_1450 := 6,
		ABB_MOTOR_3KW := 7,
		ABB_MOTOR_CUSTOM := 8
		);
	ABB_EPL_cmd_typ : 	STRUCT 
		TargetVelocity : INT; (*RPM*)
		Run : BOOL;
		Reset : BOOL;
		QuickStop : BOOL;
		Direction : ABB_DIRECTION_Enum;
	END_STRUCT;
	ABB_EPL_Comm_State_enum : 
		(
		ABB_DISCONNECTED := 0,
		ABB_QUICK_STOP := 1,
		ABB_CONFIG := 2,
		ABB_SWITCH_ON_INHIBITED := 3,
		ABB_NOT_READY_TO_SWITCH_ON := 4,
		ABB_READY_TO_SWITCH_ON := 5,
		ABB_READY_TO_RUN := 6,
		ABB_RUNNING := 7,
		ABB_TRIPPED := 8,
		ABB_OFF_REMOTE := 9, (**Drive not on remote control*)
		ABB_STO := 10,
		ABB_RAMP_DOWN := 11,
		ABB_INIT := 12 (*Driver is init*)
		);
	ABB_EPL_status_typ : 	STRUCT 
		ReadyToSwitchOn : BOOL;
		ReadyToRun : BOOL;
		Tripped : BOOL;
		DriveEnabled : BOOL;
		QuickstopActive : BOOL;
		SwitchOnInhibit : BOOL;
		Warning : BOOL;
		AtSpeed : BOOL; (**Drive is running at target velocity*)
		ActCurrent : DINT; (*Amps*)
		ActTorque : DINT; (*% of nominal motor torque*)
		ThermalTrip : BOOL;
		OnRemote : BOOL; (**Powerlink control is active*)
		Running : BOOL;
	END_STRUCT;
	ABB_DIRECTION_Enum : 
		(
		ABB_DIRECTION_FWD := 0,
		ABB_DIRECTION_REV := 1
		);
	EPL_Config : 	STRUCT 
		function : EplSDOWrite;
		currentParam : USINT;
		params : ARRAY[0..MAX_PARAMS]OF EPL_SDO;
		Node : USINT;
		EPL_Address : STRING[25];
	END_STRUCT;
	ABB_Manual_typ : 	STRUCT 
		Enable : BOOL; (*Visu Index for Manual Control*)
		Run : BOOL;
		Velocity : INT;
		Direction : ABB_DIRECTION_Enum;
		ErrorReset : BOOL;
	END_STRUCT;
	EPL_SDO : 	STRUCT 
		index : UINT;
		subIndex : USINT;
		data : DINT;
		datalen : UDINT;
		status : UINT;
		errorInfo : UDINT;
	END_STRUCT;
	ABB_Settings_typ : 	STRUCT  (**Moved to gSettings Structure*)
		MotorSize : ABB_Motor_Size_enum;
		BrakeFitted : BOOL; (*Does the motor have a brake fitted*)
		AccTime : REAL;
		DecTime : REAL;
		AutoReset : BOOL := 0; (**Option to auto reset errors.*)
		Name : STRING[50];
		TargetVelocity : INT;
	END_STRUCT;
END_TYPE
