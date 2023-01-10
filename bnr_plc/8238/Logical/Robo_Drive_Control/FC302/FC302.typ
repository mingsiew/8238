(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: FC302
 * File: FC302.typ
 * Author: D.Jefferys
 * Created: February 12, 2009
 ********************************************************************
 * Data types of library FC302
 ********************************************************************)

TYPE
	RoboPositionNames : 	STRUCT 
		Name : ARRAY[0..MaxPositions]OF UINT;
		Extra : ARRAY[0..MaxPositions]OF UINT;
	END_STRUCT;
	FC302_Position_Type : 	STRUCT 
		Lift : FC032_Drive_Positions_Type;
		Rotate : FC032_Drive_Positions_Type;
	END_STRUCT;
	FC032_Drive_Positions_Type : 	STRUCT 
		RefOffset : DINT;
		MaxSpeed : DINT; (*Max speed in mm/sec*)
		CycleCount : DINT; (*Read only for TrackView display only*)
		PositionNow : DINT;
		OperationMode : DINT; (*0=Normal Sequence 1=Manual Operation*)
		IOStatus : DINT; (*I/O Transmitted to TrackView*)
		Monitor : DINT; (*Monitor Values*)
		SeqStep : DINT; (*Sequence Step*)
		Posn : ARRAY[0..MaxPositions]OF DINT;
	END_STRUCT;
	FC302_Drive_Permanent_Typ : 	STRUCT 
		Lift : FC302_LiftPermenant;
		Rotate : FC302_RotatePermenant;
	END_STRUCT;
	FC302_LiftPermenant : 	STRUCT 
		CycleCount : DINT;
	END_STRUCT;
	FC302_RotatePermenant : 	STRUCT 
		CycleCount : DINT;
	END_STRUCT;
	FC302_Drive_Retain_Typ : 	STRUCT 
		Lift : FC302_LiftRemanent;
		Rotate : FC302_RotateRemanent;
	END_STRUCT;
	FC302_Drive_Typ : 	STRUCT 
		Lift : FC302_Lift;
		Rotate : FC302_Rotate;
	END_STRUCT;
	FC302_RotateRemanent : 	STRUCT 
		PosnRef : DINT;
	END_STRUCT;
	FC302_LiftRemanent : 	STRUCT 
		PosnRef : DINT;
	END_STRUCT;
	FC302_Lift : 	STRUCT 
		SeqStep : UINT;
		Encoder : DINT; (*Encoder raw value from card*)
		PosnActRaw : UDINT; (*Encoder position actual value always positive*)
		PosnAct : DINT;
		PosnNow : DINT; (*Actual calculated position in 100th of mm*)
		PulsePer10th_mm : REAL;
		DistRemain : DINT;
		mmPerHz : REAL;
		RunHz : UINT; (*Calculated run frequency *)
		StopDist : DINT;
		RunForwards : BOOL;
		RunReverse : BOOL;
		RunFreq : UINT; (*Actual drive running frequency *)
		RampStart : DINT; (*Final Ramp Start (ms)*)
		RampTime : DINT; (*Final Ramp Time (ms)*)
		RampMax : DINT; (*Final Ramp Max Time (ms)*)
		CAN : FC302_CAN_Typ;
		Scan : FC302_CAN_Scan_Typ;
		CTW : FC302_CTW_Typ;
		STW : FC302_STW_Typ;
		SeqIn : FC302_ControlIn; (*Inputs from PLC Sequence*)
		SeqOut : FC302_ControlOut; (*Outputs to PLC Sequence*)
		ParaList : ARRAY[0..59]OF FC302_Parameter_Typ;
		Motor : FC302_Motor_Info;
		ParamWrite : FC302_ParamWrite;
		ParameterCount : UINT;
		ModuleOK : BOOL;
	END_STRUCT;
	FC302_Rotate : 	STRUCT 
		SeqStep : UINT;
		Encoder : DINT; (*Encoder raw value from card*)
		PosnActRaw : UDINT; (*Encoder position actual value always positive*)
		PosnAct : DINT;
		PosnNow : DINT; (*Actual calculated position in 100ths of degrees*)
		PulsePer100th_Deg : REAL;
		DistRemain : DINT;
		mmPerHz : REAL;
		RunHz : UINT; (*Calculated run frequency *)
		StopDist : DINT;
		RefOffsetDeg : UINT; (*Degrees from 0 of the reference proximity switch in 100ths 50 = 5000*)
		RunForwards : BOOL;
		RunReverse : BOOL;
		RunFreq : UINT; (*Actual drive running frequency *)
		RampStart : DINT; (*Final Ramp Start (ms)*)
		RampTime : DINT; (*Final Ramp Time (ms)*)
		RampMax : DINT; (*Final Ramp Max Time (ms)*)
		CAN : FC302_CAN_Typ;
		CTW : FC302_CTW_Typ;
		STW : FC302_STW_Typ;
		Scan : FC302_CAN_Scan_Typ;
		SeqIn : FC302_ControlIn; (*Inputs from PLC Sequence*)
		SeqOut : FC302_ControlOut; (*Outputs to PLC Sequence*)
		ParaList : ARRAY[0..59]OF FC302_Parameter_Typ;
		Motor : FC302_Motor_Info;
		ParamWrite : FC302_ParamWrite;
		ParameterCount : UINT;
		ModuleOK : BOOL;
	END_STRUCT;
	FC302_ControlIn : 	STRUCT 
		DoRef : BOOL;
		AutoTunePosn : UINT; (*Auto tune position number*)
		AutoTuneReceive : BOOL; (*Auto tune for receive alignment*)
		sDevice : STRING[10]; (*CAN Device eg. "SS1.IF2"*)
		sParTblName : STRING[10]; (*Taskname of parameter table*)
		Node : USINT; (*CAN Node of drive*)
		DisableDrive : BOOL; (*Input - Enable drive to run the motor*)
		I_RefPosn : BOOL; (*Input - PLC Input for reference position*)
		I_ForwardLimitOk : BOOL; (*Input - PLC Input for Top/Clockwise limit *)
		I_ReverseLimitOk : BOOL; (*Input - PLC Input for Bottom/Anti-clockwise limit*)
		I_RailOkRelease : BOOL; (*Input - PLC Input for Rail aligned for bag to leave*)
		I_RailOkReceive : BOOL; (*Input - PLC Input for Rail aligned to Receive a bag*)
		JogForwards : BOOL;
		JogReverse : BOOL;
		EStop : BOOL; (*Input - System emergency stop - will stop drive*)
		PosnReq : DINT; (*Input - Required position in mm 10ths / 100ths Deg *)
		MaxSpeed : DINT; (*Input - Max running speed mm/sec *)
		PowerSave : BOOL; (*Input - Not Busy so save power move slower*)
		RailAlign : USINT; (*Input - Rail Align Requirement*)
		Run : BOOL; (*Input - Run Drive*)
	END_STRUCT;
	FC302_ControlOut : 	STRUCT 
		PosnNow : INT; (*Output - Actual Position in mm*)
		PosnOk : BOOL; (*Output - Current position ok for release*)
		DriveDisabled : BOOL; (*Output - Drive acknoledge Enable Movement is off*)
		RefComplete : BOOL; (*Output - Drive is referenced and ready to run*)
		AutoTunePosn : UINT; (*Auto tune position number*)
		Status : UINT; (*Output - Drive sequence status 0 = all ok ready*)
	END_STRUCT;
	FC302_CAN_Scan_Typ : 	STRUCT 
		Start : TIME;
		End : TIME;
		LastScan : UINT;
		MinScan : UINT;
		MaxScan : UINT;
		StartTrig : BOOL;
		EndTrig : BOOL;
	END_STRUCT;
	FC302_CAN_Typ : 	STRUCT 
		ModuleOk : BOOL; (*Module OK*)
		NodeStatus : UINT; (*Node Status*)
		ControlWord : UINT; (*Control Word*)
		StatusWord : UINT; (*Status Word*)
		TargetVelocity : UINT; (*Target Velocity*)
		ControlEffort : UINT; (*Control Effort*)
	END_STRUCT;
	FC302_Parameter_Typ : 	STRUCT 
		index : UINT;
		subindex : USINT;
		datalen : USINT;
		data : UDINT;
	END_STRUCT;
	FC302_ParamWrite : 	STRUCT 
		ErrorCount : UINT;
		Index : UINT;
		SubIndex : USINT;
	END_STRUCT;
	FC302_STW_Typ : 	STRUCT  (*Status Word Type*)
		ControlReady : BOOL; (*0 = Off tripped  1 = Controls ready*)
		DriveReady : BOOL; (*0 = Drive not ready 1 = Drive ready*)
		CoastingStop : BOOL; (*0 = Drive has released the motor 1 = Operation enabled*)
		Trip : BOOL; (*0 = No error 1 = Drive Tripped*)
		Error : BOOL; (*0 = No error 1 = Drive has an error but not tripped*)
		NotUsed : BOOL;
		TripLock : BOOL; (*0 = No error 1 = Drive is tripped and locked*)
		Warning : BOOL; (*0 = No error 1 = Drive warning has occured*)
		SpeedReference : BOOL; (*0 = Speed not equal to reference 1 = Speed equals reference*)
		BusOperation : BOOL; (*0 = Local operation no bus control 1 = Bus operation enabled *)
		FreqLimitOk : BOOL; (*0 = Frequency limit reached high or low 1 = Between the limits*)
		DriveOverTemp : BOOL; (*0 = Temperature ok 1 = Drive stopped because of over temperature will resume *)
		DriveVoltageFault : BOOL; (*0 = Voltage ok 1 = Drive DC voltage too high or low*)
		DriveTorqueLimit : BOOL; (*0 = Torque ok 1 = Torque (Current) limit in param 4-18 has been exceded *)
		ThermalTimerLimit : BOOL; (*0 = Timer ok 1 = One of the thermal protection timers has exceeded 100%*)
		InOperation : BOOL; (*0 = Stopped 1 = Drive running greater then 0 Hz*)
	END_STRUCT;
	FC302_Motor_Info : 	STRUCT  (*Current Motor Information *)
		Value : INT;
	END_STRUCT;
	FC302_CTW_Typ : 	STRUCT  (*Control Word Type*)
		ExtRefSelectionLSB : BOOL; (*Used to select between the 4 reference values in parameter 3-10*)
		ExtRefSelectionMSB : BOOL; (*Used to select between the 4 reference values in parameter 3-10*)
		DC_Brake : BOOL; (*0 = DC Brake 1 = Ramp *)
		Coasting : BOOL; (*0 = Coasting 1 = No Coasting, selecting 0 will shut off the output transistors.*)
		QuickStop : BOOL; (*0 = QuickStop 1= Ramp, selecting 0 will use parameter 3-81 quick stop ramp time.*)
		HoldOutputFreq : BOOL; (*0 = Hold 1= Ramp, always use Ramp*)
		RampStopStart : BOOL; (*0 = Ramp stop 1 = Start, Normal stsrt / stop*)
		ResetTrip : BOOL; (*0 = Nothing 1 = Reset Trip*)
		Jog : BOOL; (*0 = Normal 1 = Jog, Jog frequency set by parameter 3-19*)
		RampSelection : BOOL; (*0 = Ramp 1 1 = Ramp 2, Select between ramp 1 and 2 3-40 to 3-47 or 3-50 to 3-57*)
		DataValid : BOOL; (*0 = Not Valid 1 = Data Valid, If not valid then the whole control word is ignored.*)
		Relay01Active : BOOL; (*0 = No function*)
		Relay02Active : BOOL; (*0 = No function*)
		ParaSetUpLSB : BOOL; (*Used to select between the 4 different parameter setups*)
		ParaSetUpMSB : BOOL; (*Used to select between the 4 different parameter setups*)
		Reverse : BOOL; (*0 = No reversing 1 = Reversing*)
	END_STRUCT;
END_TYPE
