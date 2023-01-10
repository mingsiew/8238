
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackDischargerStBag

	messages ACCESS p_messages;
	loadcell ACCESS p_loadcell;

	
	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	DBNC_arrive_timer(IN := arrive_raw, PT := DBNC_arrive_time);
	arrive := DBNC_arrive_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	// Device State Machine
	IF ResetTimeout.Q THEN
		udp_data.state := state := ReadyToWork;
		man_send := FALSE;
		man_open := FALSE;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;
	

	CASE udp_data.state OF
		ReadyToWork:
			IF NOT(rail_mt) AND front AND onoff AND NOT(halted) AND NOT(ResetTimeout.Q) THEN
				udp_data.state := state := Stabilizing;
			ELSIF man_send THEN
				udp_data.state := state := Destabilizing;
			END_IF;

		Stabilizing:
			static_close := FALSE;
			IF StabilizingTimer.Q THEN 
				IF empty_bag OR (messages.Read[BAG_EMPTY_PX] = 1) THEN
					udp_data.state := state := ReadyToTransfer;
				ELSIF (messages.Read[BAG_EMPTY_PX] = 2) THEN 
					udp_data.state := state := Destabilizing;
				END_IF;
			ELSIF NOT(onoff) THEN
				udp_data.state := state := ReadyToWork;
			ELSIF man_send THEN
				udp_data.state := state := Destabilizing;
			END_IF;

		ReadyToTransfer:
			IF open_signal OR open_pendant OR man_open THEN
				man_open := FALSE;
				udp_data.state := state := Transferring;
			ELSIF NOT(onoff) THEN
				udp_data.state := state := ReadyToWork;
			ELSIF man_send THEN
				udp_data.state := state := Destabilizing;
				man_send := FALSE;
			END_IF;

		Transferring:
			IF TransferringTimer.Q THEN
				static_close := TRUE;
			END_IF;
			IF receive_signal OR receive_pendant THEN
				udp_data.state := state := LoadReceived;
			ELSIF (messages.Read[TOO_LONG_TO_TRANSFER] > 0) THEN  
				CASE messages.Read[TOO_LONG_TO_TRANSFER] OF
					1: //'retry_transfer'
						udp_data.state := state := RetryTransfer;  
					2: //'send_bag_away'
						udp_data.state := state := Extending;  
				END_CASE;
			ELSIF man_send THEN
				udp_data.state := state := Extending;
				man_send := FALSE;
			END_IF;

		LoadReceived:
			static_close := TRUE;
			IF empty_bag THEN // Bag hasn't opened
				CASE messages.Read[BAG_NOT_OPEN] OF
					1: //'retry_transfer'
						udp_data.state := state := RetryTransfer;  
					2: //'send_bag_away'
						udp_data.state := state := Extending;  
				END_CASE;
			ELSIF NOT(empty_bag) THEN
				udp_data.state := state := Extending;
			ELSIF man_send THEN
				udp_data.state := state := Extending;
				man_send := FALSE;
			END_IF;

		Extending:
			static_close := TRUE;
			IF ExtendingTimer.Q THEN
				udp_data.state := state := Clamping;
			END_IF;

		Clamping:
			IF ClampingTimer.Q THEN
				udp_data.state := state := Retracting;
			END_IF;

		Retracting:
			IF RetractingTimer.Q THEN
				udp_data.state := state := Destabilizing;
			END_IF;

		Destabilizing:
			IF DestabilizingTimer.Q THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
				man_send := FALSE;
				man_open := FALSE;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

		RetryTransfer:
			IF RetryTimer.Q THEN
				udp_data.state := state := Stabilizing;
			END_IF;

	END_CASE;

	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	AND NOT(open)
	AND NOT(receive_signal)
	AND staticBagRailBringOk
	);
	
	
	IF udp_data.state = Releasing THEN
		loadcell.capture_weight_bool := TRUE;
	ELSE
		loadcell.capture_weight_bool := FALSE;
	END_IF;

		// Communication
	IF sling_ready THEN
		cat_binary := wash_com_cat;
		cust_binary := wash_com_cust;
		weight_binary := wash_com_wt;
	END_IF;
	IF NOT(sling_ready) THEN
		cat_binary := 0;
		cust_binary := 0;
		weight_binary := 0;
	END_IF;
	BIN_TO_BCD_INT_sc(RegisterIN:= cat_binary);
	cat_bcd := BIN_TO_BCD_INT_sc.RegisterOUT;
	BIN_TO_BCD_INT_cust(RegisterIN:= cust_binary);
	cust_bcd := BIN_TO_BCD_INT_cust.RegisterOUT;
	BIN_TO_BCD_INT_weight(RegisterIN:= weight_binary);
	weight_bcd := BIN_TO_BCD_INT_weight.RegisterOUT;


	// Insert
	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Output Control
	stb := (
	udp_data.state = Stabilizing
	OR udp_data.state = ReadyToTransfer
	OR udp_data.state = Transferring
	OR udp_data.state = LoadReceived
	OR udp_data.state = Extending
	OR udp_data.state = Clamping
	OR udp_data.state = Retracting
	);

	open := (
	udp_data.state = Transferring
	OR udp_data.state = LoadReceived
	OR udp_data.state = Extending
	);

	stp := udp_data.state = Releasing OR lift_stp;
	sling_ready := udp_data.state = ReadyToTransfer AND onoff AND NOT(halted) AND NOT(safety_zone);
	close := udp_data.state = Extending;

	// Speed reducing static always is 'unclampled'
	// Open and close also triggered in state machine
	static_open := TRUE;
	IF EDGEPOS(going_to) THEN static_close := FALSE; END_IF;

	// Control Timers
	ResetTimeout(IN := reset, PT := ResetTime);
	StabilizingTimer(IN := (udp_data.state = Stabilizing), PT := StabilizingTime);
	TransferringTimer(IN := (udp_data.state = Transferring), PT := TransferringTime);
	DestabilizingTimer(IN := (udp_data.state = Destabilizing), PT := DestabilizingTime);
	ExtendingTimer(IN := (udp_data.state = Extending), PT := ExtendingTime);
	RetractingTimer(IN := (udp_data.state = Retracting), PT := RetractingTime);
	ClampingTimer(IN := (udp_data.state = Clamping), PT := ClampingTime);
	RetryTimer(IN := (udp_data.state = RetryTransfer), PT := RetryTime);

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (front AND rail_mt), PT := UnexpectedBagTime);
	MissingBagTimer(IN := (NOT(front) AND NOT(rail_mt)), PT := MissingBagTime);
	LoadNotDroppedTimer(IN:= (udp_data.state = Transferring), PT := AlmTime_LoadNotDropped);
	BagNotOpenTimer(IN:= ((udp_data.state = LoadReceived) AND empty_bag) , PT := BagNotOpenTime);    

	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := 0;//UnexpectedBagTimer.Q;
	udp_data.warning_com.1 := warning_com.1 := 0;//MissingBagTimer.Q;
	udp_data.warning_com.14 := warning_com.14 := sling_ready;

	// Rail Fault Handling.  
	
	messages.Write := 0;
	//BAG_STUCK  -- NOT YET IMPLEMENTED
	IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q      THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;
	IF LoadNotDroppedTimer.Q  THEN messages.Write := BIT_SET(messages.Write,TOO_LONG_TO_TRANSFER); END_IF;
	IF BagNotOpenTimer.Q      THEN messages.Write := BIT_SET(messages.Write,BAG_NOT_OPEN); END_IF;
	IF ((udp_data.state = Stabilizing) AND StabilizingTimer.Q AND NOT empty_bag) THEN messages.Write := BIT_SET(messages.Write,BAG_EMPTY_PX); END_IF;   
 
	// Always clear acknowledgements    
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));    



END_FUNCTION_BLOCK
