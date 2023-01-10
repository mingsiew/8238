
FUNCTION_BLOCK BCD_BIN_OUTPUT
	VAR_INPUT
		RegisterIN : UDINT;
		Enable : BOOL;
		BIN : BOOL;
	END_VAR
	VAR_OUTPUT
		Output1 : BOOL;
		Output2 : BOOL;
		Output4 : BOOL;
		Output8 : BOOL;
		Output10 : BOOL;
		Output20 : BOOL;
		Output40 : BOOL;
		Output80 : BOOL;
		Output100 : BOOL;
		Output200 : BOOL;
		Output400 : BOOL;
		Output800 : BOOL;
		Output1000 : BOOL;
		Output2000 : BOOL;
		Output4000 : BOOL;
		Output8000 : BOOL;
		Output10000 : BOOL;
		Output20000 : BOOL;
		Output40000 : BOOL;
		Output80000 : BOOL;
		Output100000 : BOOL;
		Output200000 : BOOL;
		Output400000 : BOOL;
		Output800000 : BOOL;
	END_VAR
	VAR
		BCDCode : UDINT;
		zzBIN_TO_BCD00000 : BIN_TO_BCD;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK BIN_TO_BCD
	VAR_INPUT
		RegisterIN : UDINT;
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		RegisterOUT : UDINT;
	END_VAR
	VAR
		remain : UDINT;
		f : UDINT;
		e : UDINT;
		d : UDINT;
		c : UDINT;
		b : UDINT;
		a : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK BIN_TO_BCD_INT
	VAR_INPUT
		RegisterIN : INT;
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		RegisterOUT : INT;
	END_VAR
	VAR
		remain : INT;
		f : INT;
		e : INT;
		d : INT;
		c : INT;
		b : INT;
		a : INT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK BIT_ENCODE
	VAR_INPUT
		Input : ARRAY[0..15] OF BOOL;
	END_VAR
	VAR_OUTPUT
		Output : UINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION DByte_TO_4Byte : UDINT (*Build 32 bit register from 2 16bit register*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		adrLower : UDINT;
		adrHigher : UDINT;
	END_VAR
	VAR
		internalValue : UDINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK DIS4
	VAR_INPUT
		RegisterIN : UINT;
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		Out1s : UINT;
		Out10s : UINT;
		Out100s : UINT;
		Out1000s : UINT;
	END_VAR
	VAR
		a : UINT;
		b : UINT;
		c : UINT;
		d : UINT;
		remain : UINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK GetModuleName (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		enable : {REDUND_UNREPLICABLE} BOOL;
		pModuleAddress : {REDUND_UNREPLICABLE} UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
		ModuleName : STRING[50];
	END_VAR
	VAR
		end : UDINT;
		zzEdge00000 : {REDUND_UNREPLICABLE} BOOL;
		state : {REDUND_UNREPLICABLE} UINT;
		pointer : {REDUND_UNREPLICABLE} UDINT;
		moduleAddress : {REDUND_UNREPLICABLE} STRING[50];
		searchLen : {REDUND_UNREPLICABLE} INT;
		searchString : {REDUND_UNREPLICABLE} STRING[50];
		mO_info : {REDUND_UNREPLICABLE} MO_info;
		scanCount : {REDUND_UNREPLICABLE} UINT;
		start : {REDUND_UNREPLICABLE} UDINT;
		foundCount : UDINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK getNodeFromPV (*Get Node and Connection string from a PV var.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		enable : BOOL;
		pvName : STRING[50]; (**Pointer to string name to search*)
	END_VAR
	VAR_OUTPUT
		status : UINT;
		NodeNumber : USINT;
		IF_Adr : STRING[75];
	END_VAR
	VAR
		state : USINT;
		searchString : STRING[50];
		zzEdge00000 : BOOL;
		scanCount : UINT;
		mO_info : MO_info;
		pointer : UDINT;
		searchLen : INT;
		startNode : UDINT;
		startPath : UDINT;
		endNode : UDINT;
		nodeString : STRING[5];
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK GetPowerlinkNodeIP (**Function to build BR camera image URL from EPL IP and Node address*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL; (**Start FUB on rising edge of enable *)
		EplInterfacePath : {REDUND_UNREPLICABLE} STRING[40]; (**String for the EPL interface*)
		Node : UDINT; (**Node number of camera*)
		pIPAddress : UDINT; (**Pointer to the String to copy the URL to*)
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		state : USINT; (**Internal state*)
		zzEdge00000 : BOOL;
		getEPL_IP : CfgGetIPAddr;
		eplAddress : STRING[16];
		eplIP : UDINT;
		device : STRING[40];
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION GetValueByName : BOOL (**Set Local variable from external task*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		TaskName : STRING[24];
		VarName : STRING[50];
		pValue : UDINT;
		sValue : UDINT;
	END_VAR
	VAR
		sVar : UDINT;
		pVar : UDINT;
		varName : STRING[75];
		status : UINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION Get_Higher2Bytes : UINT (*Copy the upper 2 bytes of a DWORD to a WORD*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : UDINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION Get_HigherByte : USINT (*Copy the upper 2 bytes of a DWORD to a WORD*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : UINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION Get_Lower2Bytes : UINT (*Copy the lower 2 bytes from a byte register*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : UDINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION Get_LowerByte : USINT (*Copy the lower 2 bytes from a byte register*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : UINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK LoadCell (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		udp_data : REFERENCE TO LoadcellUdpType;
		analog_weight : UINT;
		capture_weight_bool : BOOL;
		large_interval : UINT := 750;
		server_buffer_weight : UINT;
		server_min_weight : UINT;
		server_near_weight : UINT;
		server_notify_weight : UINT;
		server_over_weight : UINT;
		server_send_weight : UINT;
		small_interval : UINT := 100;
		weight_tolerance_percent : UINT;
		span : UINT;
		tare : UINT;
	END_VAR
	VAR_OUTPUT
		bufflector_door_weight : BOOL;
		capture_weight : UINT;
		capture_weight_value : UINT;
		empty : BOOL;
		full : BOOL;
		large_smoothing_value : UINT;
		large_smoothing_weight : UINT;
		live_weight_value : UINT;
		min_weight : BOOL;
		near_weight : BOOL;
		notify_weight : BOOL;
		over_weight : BOOL;
		small_smoothing_value : UINT;
		small_smoothing_weight : UINT;
	END_VAR
	VAR
		weight_array : ARRAY[0..750] OF UINT;
		small_value : UDINT;
		large_value : UDINT;
		i : INT;
		x : INT;
		weight_tolerance : UINT := 5;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK Queue (**Buffer queue -- Queues multiple input into waiting longest order*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		input : ARRAY[0..49] OF BOOL; (**Input condition of queue*)
		putToBackOfQueue : ARRAY[0..49] OF BOOL; (**Put the member to the back of the queue*)
		maxInputs : UINT; (**Set the buffer size to improve performance -- Default is 49*)
		priority : USINT;
	END_VAR
	VAR_OUTPUT
		waitingLongest : UINT; (*Index of array that has been TRUE for the longest*)
		waitTime : ARRAY[0..49] OF UDINT;
	END_VAR
	VAR
		n : {REDUND_UNREPLICABLE} UINT := 0;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION SetValueByName : BOOL (**Set Local variable from external task*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		TaskName : STRING[24];
		VarName : STRING[50];
		Value : UDINT;
	END_VAR
	VAR
		sVar : UDINT;
		pVar : UDINT;
		varName : STRING[75];
	END_VAR
END_FUNCTION

FUNCTION_BLOCK stASC_UINT
	VAR_INPUT
		Enable : BOOL;
		Input : ARRAY[0..3] OF USINT;
	END_VAR
	VAR_OUTPUT
		Output : UINT;
	END_VAR
	VAR
		Internal : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK stUINT_ASC
	VAR_INPUT
		Input : UINT;
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		Output : ARRAY[0..3] OF USINT;
	END_VAR
	VAR
		Value : ARRAY[0..3] OF UINT;
		n : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK stUNI4
	VAR_INPUT
		DataIN : ARRAY[0..3] OF USINT;
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		DataOUT : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK stUNI5
	VAR_INPUT
		DataIN : ARRAY[0..4] OF USINT;
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		DataOUT : UINT;
	END_VAR
	VAR
		Data : UDINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackRotasort (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		rotateTime : UDINT := 2000;
		NearWeightTime : UDINT := 1000;
		FullWeightTime : UDINT := 2000;
		settleTime : UDINT := 3000;
		retractTime : UDINT := 5000;
		MissingBagTime : UDINT := 60000;
		UnexpectedBagTime : UDINT := 30000;
		DBNC_loading_position_time : UDINT := 2000;
		DBNC_after_time : UDINT := 3000;
		DBNC_before_time : UDINT := 3000;
		rail_full : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		halted : BOOL;
		fire_ns : BOOL;
		conveyor_rail_running : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		ok_to_send : BOOL;
		insert_reset : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		front_b : BOOL;
		front_a : BOOL;
		arrive_raw : BOOL;
		after_raw : BOOL;
		before_raw : BOOL;
		loading_position_raw : BOOL;
		insert : BOOL;
		p_loadcell : UDINT;
		p_messages : UDINT;
		man_send_button : BOOL;
		sort_entry_clear : BOOL;
		sort_exit_clear : BOOL;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		clamp : BOOL;
		pusher : BOOL;
		foot : BOOL;
		reset_switch : BOOL;
		switch : BOOL;
		stp_b : BOOL;
		stp_a : BOOL;
		bring_ok : BOOL;
		warning_com : INT;
		releasing : BOOL;
		alarm : BOOL;
		sw_out_b : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_in_a : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		loadcell : REFERENCE TO LoadCell;
		ton_rotated : TON;
		AlarmTimer : TON;
		ton_straight : TON;
		NearWeightTimer : TON;
		FullWeightTimer : TON;
		ton_settledOnPoints : TON;
		ton_retractPusher : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
		rotate : BOOL;
		arrive : BOOL;
		front : BOOL;
		after : BOOL;
		before : BOOL;
		loading_position : BOOL;
		DBNC_after_timer : TOF;
		DBNC_before_timer : TOF;
		SwOutARTrig : r_trig;
		SwInARTrig : r_trig;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		Reset : INT := 1;
		ReadyToReceive : INT := 2;
		Receiving : INT := 3;
		SettleOnPoints : INT := 4;
		MoveToRotateBagIn : INT := 5;
		ReleaseBagToLoading : INT := 6;
		Loading : INT := 7;
		NearWeight : INT := 8;
		OverWeight : INT := 9;
		ReadyToRelease : INT := 10;
		MoveToRotateBagOut : INT := 11;
		ReleaseBagToPoints : INT := 12;
		RetractPusher : INT := 13;
		MoveToStraightBagOut : INT := 14;
		Releasing : INT := 15;
	END_VAR
	VAR
		DBNC_loading_position_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackSlingToBelt (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		WeightOkTime : UDINT := 1000;
		NearWeightTime : UDINT := 1000;
		FullWeightTime : UDINT := 2000;
		OpenDoorTime : UDINT := 7000;
		ResettingTime : UDINT := 7000;
		CloseTopDoorTime : UDINT := 7000;
		FastOnPulseTime : UDINT := 150;
		FastOffPulseTime : UDINT := 150;
		SlowOnPulseTime : UDINT := 450;
		SlowOffPulseTime : UDINT := 450;
		TransitToLoadingTime : UDINT := 7000;
		PurgeTime : UDINT := 10000;
		ReleaseDelayTime : UDINT := 3000;
		OverWeightTime : UDINT := 2500;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		rail_full : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		conveyor_rail_running : BOOL;
		purge : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		ok_to_send : BOOL;
		conveyor_running : BOOL;
		cc_shut_bottom_os : BOOL;
		cc_shut_top_os : BOOL;
		cc_open_bottom_os : BOOL;
		cc_open_top_os : BOOL;
		insert_reset : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		insert : BOOL;
		p_loadcell : UDINT;
		p_messages : UDINT;
		man_send : BOOL;
		man_send_button : BOOL;
		man_send_button_2 : BOOL;
		man_send_button_1 : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		open_bottom : BOOL;
		close_top : BOOL;
		green_light : BOOL;
		red_light : BOOL;
		releasing : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		loadcell : REFERENCE TO LoadCell;
		WeightOk : TON;
		AlarmTimer : TON;
		TransitToLoadingTimer : TON;
		NearWeightTimer : TON;
		FullWeightTimer : TON;
		ReleaseDelayTimer : TON;
		ResettingTimer : TON;
		CloseTopDoorTimer : TON;
		SlowOnPulseTimer : TON;
		SlowOffPulseTimer : TON;
		FastOnPulseTimer : TON;
		FastOffPulseTimer : TON;
		OverWeightTimer : TON;
		PurgeTimer : TON;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
	END_VAR
	VAR CONSTANT
		OVERWEIGHT : INT := 3;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		BAG_STUCK : INT := 0;
		Resetting : INT := 1;
		TransitToLoading : INT := 2;
		Loading : INT := 3;
		NearWeight : INT := 4;
		FullWeight : INT := 5;
		ReadyToRelease : INT := 6;
		Releasing : INT := 7;
		Purge : INT := 8;
		Buffering : INT := 9;
		OverWeight : INT := 10;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackEasisort (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		WeightOkTime : UDINT := 1000;
		EmptyWeightTime : UDINT := 10000;
		NearWeightTime : UDINT := 1000;
		FullWeightTime : UDINT := 2000;
		OpenDoorTime : UDINT := 7000;
		ResettingTime : UDINT := 7000;
		FastOnPulseTime : UDINT := 150;
		FastOffPulseTime : UDINT := 150;
		SlowOnPulseTime : UDINT := 450;
		SlowOffPulseTime : UDINT := 450;
		CloseDoorTime : UDINT := 7000;
		OverWeightTime : UDINT := 2500;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		rail_full : BOOL;
		purge : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		ok_to_send : BOOL;
		conveyor_running : BOOL;
		cc_shut_bottom_os : BOOL;
		cc_shut_top_os : BOOL;
		cc_open_bottom_os : BOOL;
		cc_open_top_os : BOOL;
		insert_reset : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		insert : BOOL;
		p_loadcell : UDINT;
		p_messages : UDINT;
		man_send : BOOL;
		man_send_button : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		run_conveyor : BOOL;
		open : BOOL;
		releasing : BOOL;
		red_light : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		loadcell : REFERENCE TO LoadCell;
		WeightOk : TON;
		AlarmTimer : TON;
		EmptyWeightTimer : TON;
		FullWeightTimer : TON;
		OpenDoorTimer : TON;
		ResettingTimer : TON;
		CloseDoorTimer : TON;
		SlowOnPulseTimer : TON;
		SlowOffPulseTimer : TON;
		FastOnPulseTimer : TON;
		FastOffPulseTimer : TON;
		OverWeightTimer : TON;
		NearWeightTimer : TON;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
	END_VAR
	VAR CONSTANT
		OVERWEIGHT : INT := 3;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		BAG_STUCK : INT := 0;
		Resetting : INT := 1;
		Loading : INT := 2;
		NearWeight : INT := 3;
		ReadyToRelease : INT := 4;
		OpenDoor : INT := 5;
		Releasing : INT := 6;
		RunEmpty : INT := 7;
		CloseDoor : INT := 8;
		OverWeight : INT := 9;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackBagCloserUnTracked (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		BagNotClosedTime : UDINT := 5000;
		OpeningTime : UDINT := 3000;
		ClosingTime : UDINT := 3000;
		DestabilizingTime : UDINT := 3000;
		StabilizingTime : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		empty_bag : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		stb : BOOL;
		close : BOOL;
		open : BOOL;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TON;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		BagNotClosedTimer : TON;
		OpeningTimer : TON;
		ClosingTimer : TON;
		DestabilizingTimer : TON;
		StabilizingTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		BAG_NOT_CLOSED : INT := 3;
		ReadyToWork : INT := 1;
		Stabilizing : INT := 2;
		Opening : INT := 3;
		Closing : INT := 4;
		Destabilizing : INT := 5;
		ReadyToRelease : INT := 6;
		Releasing : INT := 7;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackBagCloserTracked (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		BagNotClosedTime : UDINT := 5000;
		OpeningTime : UDINT := 3000;
		ClosingTime : UDINT := 3000;
		DestabilizingTime : UDINT := 3000;
		StabilizingTime : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		empty_bag : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		stb : BOOL;
		close : BOOL;
		open : BOOL;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TON;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		BagNotClosedTimer : TON;
		OpeningTimer : TON;
		ClosingTimer : TON;
		DestabilizingTimer : TON;
		StabilizingTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		BAG_NOT_CLOSED : INT := 3;
		ReadyToWork : INT := 1;
		Stabilizing : INT := 2;
		Opening : INT := 3;
		Closing : INT := 4;
		Destabilizing : INT := 5;
		ReadyToRelease : INT := 6;
		Releasing : INT := 7;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackRatchetLift (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 2000;
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		LowSensorTime : UDINT := 1000;
		HighSensorTime : UDINT := 1000;
		UnexpectedBagTime : UDINT := 30000;
		DBNC_after_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		high_valve : BOOL;
		low_valve : BOOL;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		ratchet : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		HighSensorTimer : TON;
		LowSensorTimer : TON;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		tof_pressure_1 : TOF;
		tof_pressure_2 : TOF;
		tof_pressure_3 : TOF;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		ReadyToWork : INT := 1;
		ReadyToRelease : INT := 2;
		Retract : INT := 3;
		Extend : INT := 4;
		Retract2 : INT := 5;
		Releasing : INT := 6;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrmyHalfBdyInxUnTrack (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		openTime : UDINT := 1000;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		dnbc_arrive_time : UDINT := 500;
		DBNC_after_time : UDINT := 1000;
		DBNC_front_time : UDINT := 3000;
		tof_pressureTime : UDINT := 3000;
		prs_open_time : UDINT := 1000;
		prs_wait_time : UDINT := 15000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_1 : BOOL;
		pressure_sensor_2 : BOOL;
		pressure_sensor_3 : BOOL;
		pressure_sensor_1 : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		full_sensor : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_1 : BOOL;
		inx : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		ton_open : TON;
		tof_arrive_dbnc : TOF;
		DBNC_after_timer : TON;
		AlarmTimer : TON;
		EmptyTimeoutTimer : TON;
		UnexpectedBagTimer : TON;
		DBNC_in_pos_timer : TON;
		tof_open_pressure_2 : TOF;
		tof_open_pressure_3 : TOF;
		tof_open_pressure_1 : TOF;
		tof_pressure_1 : TOF;
		tof_pressure_2 : TOF;
		tof_pressure_3 : TOF;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		ReadyToRelease : INT := 1;
		OpenStop : INT := 2;
		Releasing : INT := 3;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
		zzEdge3 : BOOL;
		zzEdge4 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrmyHalfBdyInxTrack (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		openTime : UDINT := 1000;
		AlarmTime : UDINT;
		MissingBagTime : UDINT := 60000;
		UnexpectedBagTime : UDINT := 30000;
		dnbc_arrive_time : UDINT := 500;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		tof_pressureTime : UDINT := 3000;
		prs_open_time : UDINT := 1000;
		prs_wait_time : UDINT := 15000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_1 : BOOL;
		pressure_sensor_2 : BOOL;
		pressure_sensor_3 : BOOL;
		pressure_sensor_1 : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		full_sensor : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_1 : BOOL;
		inx : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		ton_open : TON;
		tof_arrive_dbnc : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		EmptyTimeoutTimer : TON;
		UnexpectedBagTimer : TON;
		DBNC_in_pos_timer : TON;
		tof_open_pressure_2 : TOF;
		tof_open_pressure_3 : TOF;
		tof_open_pressure_1 : TOF;
		tof_pressure_1 : TOF;
		tof_pressure_2 : TOF;
		tof_pressure_3 : TOF;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		ReadyToRelease : INT := 1;
		OpenStop : INT := 2;
		Releasing : INT := 3;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		MissingBagTimer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
		zzEdge3 : BOOL;
		zzEdge4 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrmyFullBdyInxTrack (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		MissingBagTime : UDINT := 60000;
		UnexpectedBagTime : UDINT := 30000;
		dnbc_arrive_time : UDINT := 500;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		DBNC_in_pos_time : UDINT := 2000;
		tof_pressureTime : UDINT := 3000;
		lineFullTime : UDINT := 500;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_1 : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		in_pos_raw : BOOL;
		full_sensor : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_1 : BOOL;
		inx : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		full : BOOL;
		in_pos : BOOL;
		tof_arrive_dbnc : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		EmptyTimeoutTimer : TON;
		UnexpectedBagTimer : TON;
		DBNC_in_pos_timer : TON;
		tof_pressure_1 : TOF;
		tof_pressure_2 : TOF;
		tof_pressure_3 : TOF;
		ton_lineFull : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		ReadyToRelease : INT := 1;
		Seperate : INT := 2;
		Releasing : INT := 3;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		MissingBagTimer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
		zzEdge3 : BOOL;
		zzEdge4 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrmyFullBdyInxUnTrack (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		dnbc_arrive_time : UDINT := 500;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		DBNC_in_pos_time : UDINT := 2000;
		tof_pressureTime : UDINT := 3000;
		lineFullTime : UDINT := 500;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_1 : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		in_pos_raw : BOOL;
		full_sensor : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_1 : BOOL;
		inx : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		full : BOOL;
		in_pos : BOOL;
		tof_arrive_dbnc : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		EmptyTimeoutTimer : TON;
		UnexpectedBagTimer : TON;
		DBNC_in_pos_timer : TON;
		tof_pressure_1 : TOF;
		tof_pressure_2 : TOF;
		tof_pressure_3 : TOF;
		ton_lineFull : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		ReadyToRelease : INT := 1;
		Seperate : INT := 2;
		Releasing : INT := 3;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
		zzEdge3 : BOOL;
		zzEdge4 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackStp (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		EmptyTimeoutTime : UDINT := 5000;
		MissingBagTime : UDINT := 60000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		p_loadcell : UDINT;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		loadcell : REFERENCE TO LoadCell;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		EmptyTimeoutTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		ReadyToWork : INT := 1;
		ReadyToRelease : INT := 2;
		Releasing : INT := 3;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackBinTransferWithNetComm (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		ReleaseRearTime : UDINT := 2000;
		rail_alarm_time : UDINT := 90;
		DeStabilizingTime : UDINT := 5000;
		AlarmTime : UDINT;
		StabilizingTime : UDINT := 5000;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		DBNC_after_time : UDINT := 3000;
		DBNC_mid_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		xfer_complete : BOOL;
		xfer_in_progress : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		mid_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		sling_ready : BOOL;
		front_stp : BOOL;
		rear_stp : BOOL;
		fire_up : BOOL;
		stb : BOOL;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		mid_sensor : BOOL;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TON;
		DBNC_mid_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		ReadyToReceive : INT := 1;
		Receiving : INT := 2;
		CatchRear : INT := 3;
		ReadyToLoad : INT := 4;
		Stabilizing : INT := 5;
		BagReady : INT := 6;
		Loading : INT := 7;
		DeStabilizing : INT := 8;
		ReadyToRelease : INT := 9;
		ReleasingRear : INT := 10;
		Releasing : INT := 11;
	END_VAR
	VAR
		DeStabilizingTimer : TON;
		ReleaseRearTimer : TON;
		StabilizingTimer : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackSplitRailTransfer (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		rail_alarm_time : UDINT := 90;
		DestabilizingTime : UDINT := 2000;
		FootDelayTime : UDINT := 0;
		StabilizingTime : UDINT := 2000;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		DBNC_after_time : UDINT := 3000;
		DBNC_before_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		after_a : BOOL;
		after_b : BOOL;
		rail_mt : BOOL;
		over_full_sensor : BOOL;
		going_to : BOOL;
		open_signal : BOOL;
		transfer_requested_signal : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		xfer_complete : BOOL;
		xfer_in_progress : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_a : BOOL;
		before_raw : BOOL;
		front_b : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		sling_ready : BOOL;
		stp_a : BOOL;
		foot : BOOL;
		sw_out_b : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_in_a : BOOL;
		over_full_light : BOOL;
		stb : BOOL;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		front_raw : BOOL;
		arrive_raw : BOOL;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TON;
		DBNC_before_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
		SwOutARTrig : r_trig;
		SwInARTrig : r_trig;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		ReadyToWork : INT := 1;
		Stabilizing : INT := 2;
		ReadyForTransfer : INT := 3;
		Destabilizing : INT := 4;
		ReadyToRelease : INT := 5;
		Releasing : INT := 6;
		ReleaseRear : INT := 7;
		Overfull : INT := 8;
	END_VAR
	VAR
		DestabilizingTimer : TON;
		FootDelayTimer : TON;
		StabilizingTimer : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackBinTransfer (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		ReleaseRearTime : UDINT := 2000;
		rail_alarm_time : UDINT := 90;
		DeStabilizingTime : UDINT := 5000;
		AlarmTime : UDINT;
		StabilizingTime : UDINT := 5000;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		DBNC_after_time : UDINT := 3000;
		DBNC_mid_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		xfer_complete : BOOL;
		xfer_in_progress : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		mid_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		sling_ready : BOOL;
		front_stp : BOOL;
		rear_stp : BOOL;
		fire_up : BOOL;
		stb : BOOL;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		mid_sensor : BOOL;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TON;
		DBNC_mid_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		ReadyToReceive : INT := 1;
		Receiving : INT := 2;
		CatchRear : INT := 3;
		ReadyToLoad : INT := 4;
		Stabilizing : INT := 5;
		BagReady : INT := 6;
		Loading : INT := 7;
		DeStabilizing : INT := 8;
		ReadyToRelease : INT := 9;
		ReleasingRear : INT := 10;
		Releasing : INT := 11;
	END_VAR
	VAR
		DeStabilizingTimer : TON;
		ReleaseRearTimer : TON;
		StabilizingTimer : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrimaryBagRemover (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		DBNC_after_time : UDINT := 10;
		stripTime : UDINT := 3000;
		releaseTime : UDINT := 10000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		grab : BOOL;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive_raw : BOOL;
		arrive : BOOL;
		front : BOOL;
		AlarmTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		Receiving : INT := 2;
		StripBag : INT := 3;
		ReadyToRelease : INT := 4;
		Releasing : INT := 5;
	END_VAR
	VAR
		ton_strip : TON;
		ton_timeout : TON;
		DBNC_after_timer : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrimaryUnLoadingPoint (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		DBNC_front_time : UDINT := 3000;
		foot : BOOL;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		insert : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive_raw : BOOL;
		arrive : BOOL;
		front : BOOL;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		ReadyToWork : INT := 1;
		ReadyToUnload : INT := 2;
		ReadyToRelease : INT := 3;
		Releasing : INT := 4;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrimaryLoadingPoint (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rail_alarm_time : UDINT := 90;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		DBNC_front_time : UDINT := 3000;
		foot : BOOL;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		sis_weight_ok : BOOL;
		sis_weight_not_ok : BOOL;
		call_button : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		front_raw : BOOL;
		insert : BOOL;
		p_loadcell : UDINT;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		loadcell : REFERENCE TO LoadCell;
		after : BOOL;
		arrive_raw : BOOL;
		arrive : BOOL;
		front : BOOL;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		ReadyToWork : INT := 1;
		Loading : INT := 2;
		ReadyToRelease : INT := 3;
		Releasing : INT := 4;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackDischarger (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		ClampingTime : UDINT := 2000;
		RetractingTime1 : UDINT := 3000;
		RetractingTime : UDINT := 3000;
		ExtendingTime : UDINT := 10000;
		rail_alarm_time : UDINT := 90;
		AlmTime_LoadNotDropped : UDINT := 10000;
		RetryTime : UDINT := 5000;
		BagNotOpenTime : UDINT := 5000;
		DestabilizingTime : UDINT := 3000;
		TransferringTime : UDINT := 2000;
		ResetTime : UDINT := 5000;
		AlarmTime : UDINT;
		StabilizingTime : UDINT := 3000;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		lift_stp : BOOL;
		receive_pendant : BOOL;
		receive_signal : BOOL;
		open_pendant : BOOL;
		open_signal : BOOL;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		empty_bag : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		wash_com_wt : INT;
		wash_com_cust : INT;
		wash_com_cat : INT;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		p_loadcell : UDINT;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		static_open : BOOL;
		static_close : BOOL;
		sling_ready : BOOL;
		open : BOOL;
		close : BOOL;
		stb : BOOL;
		stp : BOOL;
		alarm : BOOL;
		cat_bcd : INT;
		cust_bcd : INT;
		weight_bcd : INT;
		cat_binary : INT;
		cust_binary : INT;
		weight_binary : INT;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		loadcell : REFERENCE TO LoadCell;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
		ResetTimeout : TOF;
		AlarmTimer : TON;
		BIN_TO_BCD_INT_weight : BIN_TO_BCD_INT;
		BIN_TO_BCD_INT_cust : BIN_TO_BCD_INT;
		BIN_TO_BCD_INT_sc : BIN_TO_BCD_INT;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		TOO_LONG_TO_TRANSFER : INT := 3;
		BAG_NOT_OPEN : INT := 4;
		BAG_EMPTY_PX : INT := 5;
		BAG_STUCK : INT := 0;
		ReadyToWork : INT := 1;
		Stabilizing : INT := 2;
		ReadyToTransfer : INT := 3;
		Transferring : INT := 4;
		LoadReceived : INT := 5;
		Extending : INT := 6;
		Clamping : INT := 7;
		Retracting : INT := 8;
		Destabilizing : INT := 9;
		ReadyToRelease : INT := 10;
		Releasing : INT := 11;
		RetryTransfer : INT := 12;
	END_VAR
	VAR
		RetryTimer : TON;
		LoadNotDroppedTimer : TON;
		ClampingTimer : TON;
		BagNotOpenTimer : TON;
		RetractingTimer : TON;
		ExtendingTimer : TON;
		DestabilizingTimer : TON;
		TransferringTimer : TON;
		StabilizingTimer : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackLiftingStaticBag (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		UnclampingTime : UDINT := 1500;
		PreparingToLowerTime : UDINT := 2000;
		DoneLoweringTime : UDINT := 1000;
		DoneLiftingTime : UDINT := 1000;
		PreparingToLiftTime : UDINT := 2000;
		rail_alarm_time : UDINT := 90;
		ClosingTime : UDINT := 10000;
		ReceivingTime : UDINT := 3000;
		AlarmTime : UDINT;
		DBNC_down_time : UDINT := 1000;
		DBNC_up_time : UDINT := 1000;
		open_pendant : BOOL;
		open_signal : BOOL;
		down_raw : BOOL;
		up_raw : BOOL;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		dischargerRailSlingReady : BOOL;
		going_to_ns : BOOL;
		stopped : BOOL;
		insert : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		p_messages : UDINT;
		static_open : BOOL;
		static_close : BOOL;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		sling_ready : BOOL;
		dischargerRailReceiveSignal : BOOL;
		fire_down : BOOL;
		fire_up : BOOL;
		lift_clamp : BOOL;
		close : BOOL;
		open : BOOL;
		clamp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		Closed : INT := 1;
		PreparingToLift : INT := 2;
		Lifting : INT := 3;
		DoneLifting : INT := 4;
		InReceivePosition : INT := 5;
		ReadyToReceive : INT := 6;
		Receiving : INT := 7;
		PreparingToLower : INT := 8;
		Lowering : INT := 9;
		DoneLowering : INT := 10;
		Loaded : INT := 11;
		ReadyToTransfer : INT := 12;
		Unclamping : INT := 13;
		Opening : INT := 14;
		Transferring : INT := 15;
		Closing : INT := 16;
	END_VAR
	VAR
		DBNC_down_timer : TON;
		DBNC_up_timer : TON;
		ClampingTimer : TON;
		ReceivingTimer : TON;
		DoneLoweringTimer : TON;
		DoneLiftingTimer : TON;
		UnclampingTimer : TON;
		PreparingToLowerTimer : TON;
		PreparingToLiftTimer : TON;
		ClosingTimer : TON;
		delete_latch : BOOL;
		up : BOOL;
		down : BOOL;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackStaticBag (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		UnclampingTime : UDINT := 1500;
		ClampingTime : UDINT := 2000;
		rail_alarm_time : UDINT := 90;
		ClosingTime : UDINT := 10000;
		ReceivingTime : UDINT := 3000;
		AlarmTime : UDINT;
		open_pendant : BOOL;
		open_signal : BOOL;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		stopped : BOOL;
		insert : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		sling_ready : BOOL;
		dischargerRailReceiveSignal : BOOL;
		open : BOOL;
		clamp : BOOL;
		stp : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		Closed : INT := 1;
		ReadyToReceive : INT := 2;
		Receiving : INT := 3;
		Clamping : INT := 4;
		Loaded : INT := 5;
		ReadyToTransfer : INT := 6;
		Unclamping : INT := 7;
		Transferring : INT := 8;
		Closing : INT := 9;
	END_VAR
	VAR
		ClampingTimer : TON;
		ReceivingTimer : TON;
		UnclampingTimer : TON;
		ClosingTimer : TON;
		delete_latch : BOOL;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackDischargerStBag (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		ClampingTime : UDINT := 2000;
		RetractingTime1 : UDINT := 3000;
		RetractingTime : UDINT := 3000;
		ExtendingTime : UDINT := 10000;
		rail_alarm_time : UDINT := 90;
		AlmTime_LoadNotDropped : UDINT := 10000;
		RetryTime : UDINT := 5000;
		BagNotOpenTime : UDINT := 5000;
		DestabilizingTime : UDINT := 3000;
		TransferringTime : UDINT := 2000;
		ResetTime : UDINT := 5000;
		AlarmTime : UDINT;
		StabilizingTime : UDINT := 3000;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		lift_stp : BOOL;
		receive_pendant : BOOL;
		receive_signal : BOOL;
		open_pendant : BOOL;
		open_signal : BOOL;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		empty_bag : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_os : BOOL;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		halted : BOOL;
		wash_com_wt : INT;
		wash_com_cust : INT;
		wash_com_cat : INT;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
		staticBagRailBringOk : BOOL;
		p_loadcell : UDINT;
		p_messages : UDINT;
		man_send : BOOL;
		man_open : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		static_open : BOOL;
		static_close : BOOL;
		sling_ready : BOOL;
		open : BOOL;
		close : BOOL;
		stb : BOOL;
		stp : BOOL;
		alarm : BOOL;
		cat_bcd : INT;
		cust_bcd : INT;
		weight_bcd : INT;
		cat_binary : INT;
		cust_binary : INT;
		weight_binary : INT;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		loadcell : REFERENCE TO LoadCell;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
		ResetTimeout : TOF;
		AlarmTimer : TON;
		BIN_TO_BCD_INT_weight : BIN_TO_BCD_INT;
		BIN_TO_BCD_INT_cust : BIN_TO_BCD_INT;
		BIN_TO_BCD_INT_sc : BIN_TO_BCD_INT;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		TOO_LONG_TO_TRANSFER : INT := 3;
		BAG_NOT_OPEN : INT := 4;
		BAG_EMPTY_PX : INT := 5;
		BAG_STUCK : INT := 0;
		ReadyToWork : INT := 1;
		Stabilizing : INT := 2;
		ReadyToTransfer : INT := 3;
		Transferring : INT := 4;
		LoadReceived : INT := 5;
		Extending : INT := 6;
		Clamping : INT := 7;
		Retracting : INT := 8;
		Destabilizing : INT := 9;
		ReadyToRelease : INT := 10;
		Releasing : INT := 11;
		RetryTransfer : INT := 12;
	END_VAR
	VAR
		RetryTimer : TON;
		LoadNotDroppedTimer : TON;
		ClampingTimer : TON;
		BagNotOpenTimer : TON;
		RetractingTimer : TON;
		ExtendingTimer : TON;
		DestabilizingTimer : TON;
		TransferringTimer : TON;
		StabilizingTimer : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackSplitRailInxUnTracked (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Pressure1Time : UDINT := 5000;
		Pressure2Time : UDINT := 5000;
		Pressure3Time : UDINT := 5000;
		Pressure4Time : UDINT := 5000;
		Pressure5Time : UDINT := 5000;
		TrolleyPrepareTime : UDINT := 3000;
		DBNC_before_time : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		AlarmTime : UDINT;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 30000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		p_messages : UDINT;
		rail_mt : BOOL;
		going_to : BOOL;
		front_a : BOOL;
		front_b : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		pressure_sensor_1 : BOOL;
		pressure_sensor_2 : BOOL;
		pressure_sensor_3 : BOOL;
		pressure_sensor_4 : BOOL;
		pressure_sensor_5 : BOOL;
		pressure_full_line_1 : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_4 : BOOL;
		pressure_full_line_5 : BOOL;
		ok_to_send : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		arrive_raw : BOOL;
		before_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		pressure_stop_1 : BOOL;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_4 : BOOL;
		pressure_stop_5 : BOOL;
		sw_out_b : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_in_a : BOOL;
		inx : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		SwOutARTrig : r_trig;
		SwInARTrig : r_trig;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		front_raw : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_before_timer : TOF;
		DBNC_after_timer : TOF;
		DBNC_front_timer : TON;
		Pressure1Timer : TON;
		Pressure2Timer : TON;
		Pressure3Timer : TON;
		Pressure4Timer : TON;
		Pressure5Timer : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		TrolleyPrepareTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToRelease : INT := 1;
		PrepareToRelease : INT := 2;
		Releasing : INT := 3;
		UNEXPECTED_BAG : INT := 1;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackRotaryTrn (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		arrive_raw : BOOL;
		after_raw : BOOL;
		AlarmTime : UDINT;
		before_raw : BOOL;
		custom_bring_lock : BOOL;
		custom_send_lock : BOOL;
		DBNC_before_time : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		destination : INT;
		fire : BOOL;
		fire_f_trig : f_trig;
		fire_ns : BOOL;
		fire_os : BOOL;
		fire_r_trig : r_trig;
		front_a : BOOL;
		front_b : BOOL;
		going_to : BOOL;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		halted : BOOL;
		input_enabled : BOOL;
		insert : BOOL;
		insert_reset : BOOL;
		MissingBagTime : UDINT := 60000;
		rail_full : BOOL;
		rail_mt : BOOL;
		rail_alarm_time : UDINT := 90;
		requestRotateTime : UDINT := 5000;
		rotateTime : UDINT := 2000;
		man_open : BOOL;
		man_send : BOOL;
		ok_to_send : BOOL;
		onoff : BOOL;
		p_messages : UDINT;
		request_rotate : BOOL;
		safety_zone : BOOL;
		settleTime : UDINT := 3000;
		sw_in_a : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_out_b : BOOL;
		reset : BOOL;
		UnexpectedBagTime : UDINT := 30000;
	END_VAR
	VAR_OUTPUT
		alarm : BOOL;
		bring_ok : BOOL;
		rotate : BOOL;
		reset_switch : BOOL;
		state : INT;
		stp : BOOL;
		stp_a : BOOL;
		stp_b : BOOL;
		switch : BOOL;
		udp_data : RailUdpType;
		waiting : BOOL;
		warning_com : INT;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_after_timer : TOF;
		DBNC_before_timer : TOF;
		ton_rotated : TON;
		ton_straight : TON;
		ton_settledOnPoints : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		Reset : INT := 1;
		ReadyToReceive : INT := 2;
		Receiving : INT := 3;
		SettleOnPoints : INT := 4;
		ReadyToRelease : INT := 5;
		MoveToRotate : INT := 6;
		ReadyToReleaseRotate : INT := 7;
		ReleasingStraight : INT := 8;
		ReleasingRotate : INT := 9;
		BAG_STUCK : INT := 0;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackRotaryTrf (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		arrive_raw : BOOL;
		after_raw : BOOL;
		AlarmTime : UDINT;
		before_raw : BOOL;
		custom_bring_lock : BOOL;
		custom_send_lock : BOOL;
		DBNC_before_time : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		destination : INT;
		fire : BOOL;
		fire_f_trig : f_trig;
		fire_ns : BOOL;
		fire_os : BOOL;
		fire_r_trig : r_trig;
		front_a : BOOL;
		front_b : BOOL;
		going_to : BOOL;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		halted : BOOL;
		input_enabled : BOOL;
		insert : BOOL;
		insert_reset : BOOL;
		MissingBagTime : UDINT := 60000;
		rail_full : BOOL;
		rail_mt : BOOL;
		rail_alarm_time : UDINT := 90;
		request_rotate : BOOL;
		requestRotateTime : UDINT := 5000;
		rotateTime : UDINT := 2000;
		man_open : BOOL;
		man_send : BOOL;
		ok_to_send : BOOL;
		onoff : BOOL;
		p_messages : UDINT;
		safety_zone : BOOL;
		settleTime : UDINT := 3000;
		sw_in_a : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_out_b : BOOL;
		reset : BOOL;
		UnexpectedBagTime : UDINT := 30000;
	END_VAR
	VAR_OUTPUT
		alarm : BOOL;
		bring_ok : BOOL;
		reset_switch : BOOL;
		state : INT;
		stp : BOOL;
		stp_a : BOOL;
		stp_b : BOOL;
		switch : BOOL;
		udp_data : RailUdpType;
		waiting : BOOL;
		warning_com : INT;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_after_timer : TOF;
		DBNC_before_timer : TOF;
		ton_rotated : TON;
		ton_straight : TON;
		ton_settledOnPoints : TON;
		ton_request_rotate : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		Reset : INT := 1;
		ReadyToReceive : INT := 2;
		ReceivingStraight : INT := 3;
		MoveToRotate : INT := 4;
		SettleOnPoints : INT := 5;
		MoveToStraight : INT := 6;
		ReadyToRelease : INT := 7;
		Releasing : INT := 8;
		BAG_STUCK : INT := 0;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackRudderStp (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		after_raw : BOOL;
		after_a_raw : BOOL;
		after_b_raw : BOOL;
		AlarmTime : UDINT;
		before_raw : BOOL;
		custom_bring_lock : BOOL;
		custom_send_lock : BOOL;
		DBNC_before_time : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		DBNC_after_a_time : UDINT := 3000;
		DBNC_after_b_time : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		destination : INT;
		fire : BOOL;
		fire_f_trig : f_trig;
		fire_ns : BOOL;
		fire_os : BOOL;
		fire_r_trig : r_trig;
		front_a : BOOL;
		front_b : BOOL;
		going_to : BOOL;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		halted : BOOL;
		input_enabled : BOOL;
		insert : BOOL;
		insert_reset : BOOL;
		MissingBagTime : UDINT := 60000;
		rail_full : BOOL;
		rail_mt : BOOL;
		rail_alarm_time : UDINT := 90;
		man_open : BOOL;
		man_send : BOOL;
		ok_to_send : BOOL;
		onoff : BOOL;
		p_messages : UDINT;
		safety_zone : BOOL;
		reset : BOOL;
		UnexpectedBagTime : UDINT := 30000;
	END_VAR
	VAR_OUTPUT
		alarm : BOOL;
		bring_ok : BOOL;
		udp_data : RailUdpType;
		state : INT;
		stp : BOOL;
		stp_a : BOOL;
		stp_b : BOOL;
		sw_in_a : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_out_b : BOOL;
		waiting : BOOL;
		warning_com : INT;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		SwOutARTrig : r_trig;
		SwInARTrig : r_trig;
		after : BOOL;
		after_a : BOOL;
		after_b : BOOL;
		arrive : BOOL;
		before : BOOL;
		front_a_seen : BOOL;
		front : BOOL;
		arrive_raw : BOOL;
		front_raw : BOOL;
		DBNC_after_timer : TOF;
		DBNC_after_b_timer : TOF;
		DBNC_after_a_timer : TOF;
		DBNC_arrive_timer : TOF;
		DBNC_before_timer : TOF;
		DBNC_front_timer : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		ReadyToRelease : INT := 2;
		ReleasingFront : INT := 3;
		ReleasingRear : INT := 4;
		BAG_STUCK : INT := 0;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackSplitRailStp (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		after_raw : BOOL;
		after_a_raw : BOOL;
		after_b_raw : BOOL;
		AlarmTime : UDINT;
		before_raw : BOOL;
		custom_bring_lock : BOOL;
		custom_send_lock : BOOL;
		DBNC_before_time : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		DBNC_after_a_time : UDINT := 3000;
		DBNC_after_b_time : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		destination : INT;
		fire : BOOL;
		fire_f_trig : f_trig;
		fire_ns : BOOL;
		fire_os : BOOL;
		fire_r_trig : r_trig;
		front_a : BOOL;
		front_b : BOOL;
		going_to : BOOL;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		halted : BOOL;
		input_enabled : BOOL;
		insert : BOOL;
		insert_reset : BOOL;
		MissingBagTime : UDINT := 60000;
		rail_full : BOOL;
		rail_mt : BOOL;
		rail_alarm_time : UDINT := 90;
		man_open : BOOL;
		man_send : BOOL;
		ok_to_send : BOOL;
		onoff : BOOL;
		p_messages : UDINT;
		safety_zone : BOOL;
		reset : BOOL;
		UnexpectedBagTime : UDINT := 30000;
	END_VAR
	VAR_OUTPUT
		alarm : BOOL;
		bring_ok : BOOL;
		udp_data : RailUdpType;
		state : INT;
		stp : BOOL;
		stp_a : BOOL;
		stp_b : BOOL;
		sw_in_a : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_out_b : BOOL;
		waiting : BOOL;
		warning_com : INT;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		SwOutARTrig : r_trig;
		SwInARTrig : r_trig;
		after : BOOL;
		after_a : BOOL;
		after_b : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		arrive_raw : BOOL;
		front_raw : BOOL;
		DBNC_after_timer : TOF;
		DBNC_after_b_timer : TOF;
		DBNC_after_a_timer : TOF;
		DBNC_arrive_timer : TOF;
		DBNC_before_timer : TOF;
		DBNC_front_timer : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		ReadyToRelease : INT := 2;
		ReleasingFront : INT := 3;
		ReleasingRear : INT := 4;
		BAG_STUCK : INT := 0;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackSplitRailInxTracked (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Pressure1Time : UDINT := 5000;
		Pressure2Time : UDINT := 5000;
		Pressure3Time : UDINT := 5000;
		Pressure4Time : UDINT := 5000;
		Pressure5Time : UDINT := 5000;
		TrolleyPrepareTime : UDINT := 3000;
		DBNC_before_time : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		AlarmTime : UDINT;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		p_messages : UDINT;
		rail_mt : BOOL;
		going_to : BOOL;
		front_a : BOOL;
		front_b : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		pressure_sensor_1 : BOOL;
		pressure_sensor_2 : BOOL;
		pressure_sensor_3 : BOOL;
		pressure_sensor_4 : BOOL;
		pressure_sensor_5 : BOOL;
		pressure_full_line_1 : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_4 : BOOL;
		pressure_full_line_5 : BOOL;
		ok_to_send : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		before_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		pressure_stop_1 : BOOL;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_4 : BOOL;
		pressure_stop_5 : BOOL;
		sw_out_b : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_in_a : BOOL;
		inx : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		SwOutARTrig : r_trig;
		SwInARTrig : r_trig;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		front_raw : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_before_timer : TOF;
		DBNC_after_timer : TOF;
		DBNC_front_timer : TON;
		Pressure1Timer : TON;
		Pressure2Timer : TON;
		Pressure3Timer : TON;
		Pressure4Timer : TON;
		Pressure5Timer : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
		TrolleyPrepareTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToRelease : INT := 1;
		PrepareToRelease : INT := 2;
		Releasing : INT := 3;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
		zzEdge1 : BOOL;
		zzEdge2 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackStackerOffgoing (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		AlarmTime : UDINT;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		ExtendingTime : UDINT := 3000;
		RetractingTime : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		DBNC_after_a_time : UDINT := 3000;
		DBNC_after_b_time : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		DBNC_before_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		front_a : BOOL;
		front_b : BOOL;
		ok_to_send : BOOL;
		p_messages : UDINT;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		halted : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_a_raw : BOOL;
		after_b_raw : BOOL;
		after_raw : BOOL;
		before_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		stp_a : BOOL;
		stp_b : BOOL;
		switch : BOOL;
		level_arm : BOOL;
		alarm : BOOL;
		reset_switch : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after_a : BOOL;
		after_b : BOOL;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_a_timer : TOF;
		DBNC_before_timer : TOF;
		DBNC_after_b_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
		ExtendingTimer : TON;
		RetractingTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		Extending : INT := 2;
		Retracting : INT := 3;
		ReadyToRelease : INT := 4;
		ReleasingFront : INT := 5;
		ReleasingRear : INT := 6;
		Releasing : INT := 7;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackStackerOngoing (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		AlarmTime : UDINT;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		ExtendingTime : UDINT := 5000;
		PusherOffTime : UDINT := 5000;
		PusherOnTime : UDINT := 5000;
		RingPusherTime : UDINT := 3000;
		RetractingTime : UDINT := 3000;
		DBNC_arrive_time : UDINT := 3000;
		DBNC_after_time : UDINT := 3000;
		DBNC_before_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		rail_full : BOOL;
		front_a : BOOL;
		front_b : BOOL;
		ok_to_send : BOOL;
		p_messages : UDINT;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		halted : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		before_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		stp : BOOL;
		pusher : BOOL;
		ring_pusher : BOOL;
		alarm : BOOL;
		tilt_arm : BOOL;
		sw_out_b : BOOL;
		sw_in_b : BOOL;
		sw_out_a : BOOL;
		sw_in_a : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_before_timer : TOF;
		DBNC_after_timer : TOF;
		PusherOnTimer : TON;
		PusherOffTimer : TON;
		RingPusherTimer : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
		ExtendingTimer : TON;
		RetractingTimer : TON;
		SwOutARTrig : r_trig;
		SwInARTrig : r_trig;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		Extending : INT := 2;
		Retracting : INT := 3;
		ReadyToRelease : INT := 4;
		Releasing : INT := 5;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackPrimaryIncline (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		AlarmTime : UDINT;
		rail_alarm_time : UDINT := 90;
		dbnc_top_switch_time : UDINT := 2000;
		UnexpectedBagTime : UDINT := 30000;
		DBNC_after_time : UDINT := 3000;
		DBNC_before_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		p_messages : UDINT;
		paddle_sensor : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		conveyor_running : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		rail_out_sensor : BOOL;
		halted : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		before_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		run_slant : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		trolleyAtTop : BOOL;
		after : BOOL;
		before : BOOL;
		arrive : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
		DBNC_before_timer : TOF;
		ton_top_sensor_dnbc : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		AlignLift : INT := 2;
		Receiving : INT := 3;
		ReadyToRelease : INT := 4;
		Releasing : INT := 5;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackIncline (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 3000;
		AlarmTime : UDINT;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 30000;
		DBNC_after_time : UDINT := 3000;
		rail_full : BOOL;
		ok_to_send : BOOL;
		p_messages : UDINT;
		paddle_sensor : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		conveyor_running : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		halted : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		run_slant : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TON;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		ReadyToRelease : INT := 2;
		Releasing : INT := 3;
		AlignLift : INT := 4;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
	END_VAR
	VAR
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackBeltConveyor (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 0;
		DBNC_after_time : UDINT := 0;
		ClearWarningTime : UDINT := 5000;
		ClearBeltTime : UDINT := 10000;
		MaximumRunningTime : UDINT := 120000;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 15000;
		MissingBagTime : UDINT := 15000;
		DBNC_front_time : UDINT := 0;
		rail_full : BOOL;
		ok_to_send : BOOL;
		p_messages : UDINT;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		conveyor_running : BOOL;
		purge : BOOL;
		halted : BOOL;
		receiving : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		after_raw : BOOL;
		insert : BOOL;
		warning_com : INT;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		clear_belt : BOOL;
		run_conveyor : BOOL;
		releasing : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		arrive : BOOL;
		halt : BOOL;
		front : BOOL;
		after : BOOL;
		ClearWarningTimer : TOF;
		DBNC_arrive_timer : TOF;
		ClearBeltTimer : TON;
		MaximumBeltRunningTime : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		RunToFront : INT := 2;
		ReadyToRelease : INT := 3;
		Releasing : INT := 4;
		ClearBelt : INT := 5;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		EXCEED_RUN_TIME : INT := 3;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		DBNC_after_timer : TOF;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackBeltTransfer (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_arrive_time : UDINT := 0;
		DBNC_after_time : UDINT := 0;
		ClearWarningTime : UDINT := 5000;
		ClearBeltTime : UDINT := 10000;
		MaximumRunningTime : UDINT := 120000;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 15000;
		MissingBagTime : UDINT := 15000;
		DBNC_front_time : UDINT := 0;
		rail_full : BOOL;
		ok_to_send : BOOL;
		p_messages : UDINT;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		conveyor_running : BOOL;
		purge : BOOL;
		halted : BOOL;
		receiving : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		after_raw : BOOL;
		insert : BOOL;
		warning_com : INT;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		clear_belt : BOOL;
		run_conveyor : BOOL;
		releasing : BOOL;
		alarm : BOOL;
	END_VAR
	VAR
		messages : REFERENCE TO RailMessages_typ;
		arrive : BOOL;
		after : BOOL;
		halt : BOOL;
		front : BOOL;
		ClearWarningTimer : TOF;
		DBNC_arrive_timer : TOF;
		ClearBeltTimer : TON;
		MaximumBeltRunningTime : TON;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
	END_VAR
	VAR CONSTANT
		ReadyToWork : INT := 1;
		RunToFront : INT := 2;
		ReadyToRelease : INT := 3;
		Releasing : INT := 4;
		ClearBelt : INT := 5;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		EXCEED_RUN_TIME : INT := 3;
	END_VAR
	VAR
		DBNC_front_timer : TON;
		DBNC_after_timer : TOF;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackIndexerTracked (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_counter_time : {REDUND_UNREPLICABLE} UDINT := 250;
		DBNC_arrive_time : UDINT := 3000;
		AlarmTime : UDINT;
		rail_alarm_time : UDINT := 90;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		RearTrolleyLockTime : UDINT := 10000;
		INS_ON_Time : UDINT := 10000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		tof_pressureTime : UDINT := 3000;
		pressure_full_line_1 : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_4 : BOOL;
		pressure_full_line_5 : BOOL;
		rail_full : BOOL;
		ok_to_send : BOOL;
		p_messages : UDINT;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		puncher : BOOL;
		warning_com : INT;
		inx : BOOL;
		alarm : BOOL;
		pressure_stop_1 : BOOL;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_4 : BOOL;
		pressure_stop_5 : BOOL;
	END_VAR
	VAR
		counter : INT;
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
		RearTrolleyLockTimer : TON;
		INS_OFF : TOF;
		tof_pressure : TOF;
		tof_pressure_2 : TOF;
		tof_pressure_3 : TOF;
		tof_pressure_4 : TOF;
		tof_pressure_5 : TOF;
	END_VAR
	VAR CONSTANT
		ReadyToRelease : INT := 1;
		Releasing : INT := 2;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		REAR_TROLLEY_LOCK : INT := 3;
	END_VAR
	VAR
		INS_ON : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK SupertrackIndexerUnTracked (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		DBNC_counter_time : {REDUND_UNREPLICABLE} UDINT := 250;
		DBNC_arrive_time : UDINT := 3000;
		AlarmTime : UDINT;
		UnexpectedBagTime : UDINT := 30000;
		MissingBagTime : UDINT := 60000;
		RearTrolleyLockTime : UDINT := 10000;
		rail_alarm_time : UDINT := 90;
		INS_ON_Time : UDINT := 10000;
		DBNC_after_time : UDINT := 3000;
		DBNC_front_time : UDINT := 3000;
		tof_pressureTime : UDINT := 3000;
		pressure_full_line_1 : BOOL;
		pressure_full_line_2 : BOOL;
		pressure_full_line_3 : BOOL;
		pressure_full_line_4 : BOOL;
		pressure_full_line_5 : BOOL;
		p_messages : UDINT;
		rail_full : BOOL;
		ok_to_send : BOOL;
		rail_mt : BOOL;
		going_to : BOOL;
		fire_ns : BOOL;
		fire_os : BOOL;
		man_send : BOOL;
		fire : BOOL;
		fire_r_trig : r_trig;
		fire_f_trig : f_trig;
		going_to_r_trig : r_trig;
		going_to_f_trig : f_trig;
		going_to_os : BOOL;
		going_to_ns : BOOL;
		insert_reset : BOOL;
		man_open : BOOL;
		destination : INT;
		input_enabled : BOOL;
		onoff : BOOL;
		safety_zone : BOOL;
		reset : BOOL;
		custom_send_lock : BOOL;
		custom_bring_lock : BOOL;
		after_raw : BOOL;
		front_raw : BOOL;
		arrive_raw : BOOL;
		insert : BOOL;
	END_VAR
	VAR_OUTPUT
		udp_data : RailUdpType;
		waiting : BOOL;
		state : INT;
		bring_ok : BOOL;
		warning_com : INT;
		inx : BOOL;
		alarm : BOOL;
		pressure_stop_1 : BOOL;
		pressure_stop_2 : BOOL;
		pressure_stop_3 : BOOL;
		pressure_stop_4 : BOOL;
		pressure_stop_5 : BOOL;
	END_VAR
	VAR
		counter : INT;
		messages : REFERENCE TO RailMessages_typ;
		after : BOOL;
		arrive : BOOL;
		before : BOOL;
		front : BOOL;
		DBNC_arrive_timer : TOF;
		DBNC_after_timer : TOF;
		AlarmTimer : TON;
		UnexpectedBagTimer : TON;
		MissingBagTimer : TON;
		RearTrolleyLockTimer : TON;
		INS_OFF : TOF;
		tof_pressure : TOF;
		tof_pressure_2 : TOF;
		tof_pressure_3 : TOF;
		tof_pressure_4 : TOF;
		tof_pressure_5 : TOF;
	END_VAR
	VAR CONSTANT
		ReadyToRelease : INT := 1;
		Releasing : INT := 2;
		UNEXPECTED_BAG : INT := 1;
		MISSING_BAG : INT := 2;
		REAR_TROLLEY_LOCK : INT := 3;
	END_VAR
	VAR
		INS_ON : TON;
		DBNC_front_timer : TON;
		zzEdge00001 : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK BCD_Encode (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Input : {REDUND_UNREPLICABLE} INT;
	END_VAR
	VAR_OUTPUT
		Output : UINT;
	END_VAR
END_FUNCTION_BLOCK
