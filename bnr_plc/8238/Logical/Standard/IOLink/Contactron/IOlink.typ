
TYPE
	contactron_visu_manual_typ : 	STRUCT 
		Visible : BOOL; (**Are the controls Visible*)
		Name : STRING[10];
		RunReverse : BOOL;
		RunForwards : BOOL;
		SetCurrent : INT;
		Error : BOOL;
		ErrorReset : BOOL;
		selectedIndex : UINT;
		selectedValue : STRING[10];
		refreshDropDown : R_TRIG;
		ListBoxVisible : BOOL;
		EnableRunReverse : BOOL;
		EnableRunForwards : BOOL;
		Enable : BOOL;
		Status : Contactron_Status_Type;
		ErrorString : STRING[400];
	END_STRUCT;
	contactron_manual_typ : 	STRUCT 
		RunReverse : BOOL;
		RunForwards : BOOL;
		Enable : BOOL;
		ErrorReset : BOOL;
	END_STRUCT;
	Contactron_Cmd_Type : 	STRUCT 
		Reset_Manual : BOOL;
		Reset_Automatic : BOOL;
		Stop : BOOL;
		Run : BOOL;
		Direction : Contactron_Direction;
		Current : USINT; (*Sets the trip current, enable must be off to write*)
	END_STRUCT;
	Contactron_Comms_Type : 	STRUCT 
		Write : Contactron_Outputs_Type;
		Read : Contactron_Inputs_Type;
	END_STRUCT;
	Contactron_Device_Type : 
		(
		CONTACTRON_H5_3 := 0,
		CONTACTRON_H5_9 := 1,
		CONTACTRON_H3_3 := 2,
		CONTACTRON_H3_9 := 3
		);
	Contactron_Direction : 
		(
		CONTACTRON_FORWARD := 0,
		CONTACTRON_REVERSE := 1
		);
	Contactron_Inputs_Type : 	STRUCT 
		Diagnostics : USINT;
		CurrentStatus : USINT; (*Current trip level and trip status*)
		ThermalPercentOfMax : USINT;
		CurrentPercentOfMax : USINT;
		DeviceType : USINT; (*Type of contactron used*)
		CurrentActual : USINT; (*10mA*)
		Data : ARRAY[0..7]OF USINT;
	END_STRUCT;
	Contactron_Outputs_Type : 	STRUCT 
		Control : USINT;
		NominalCurrent : USINT;
	END_STRUCT;
	Contactron_Status_Type : 	STRUCT 
		Error : BOOL;
		STO_Active : BOOL;
		Running : BOOL;
		Overload_Warning : BOOL;
		MainsFailure : BOOL;
		PhaseLoss : BOOL;
		Current : REAL;
		DeviceType : Contactron_Device_Type;
	END_STRUCT;
	Contactron_Type : 	STRUCT  (*Parent structure to hold all Contactron structures*)
		Cmd : Contactron_Cmd_Type;
		Status : Contactron_Status_Type;
		Comms : Contactron_Comms_Type;
		Manual : contactron_manual_typ;
	END_STRUCT;
	IO_Link_Type : 	STRUCT  (*Parent structure to hold all IO_Link device structures*)
		Contactron : ARRAY[0..MAX_CONTACTRON]OF Contactron_Type; (*Parent structure to hold all Contactron structures*)
	END_STRUCT;
END_TYPE

(**)

TYPE
	contactron_setting_typ : 	STRUCT 
		Name : STRING[50];
		SetCurrent : INT;
	END_STRUCT;
END_TYPE
