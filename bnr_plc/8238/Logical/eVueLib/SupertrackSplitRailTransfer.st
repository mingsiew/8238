
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackSplitRailTransfer

	messages ACCESS p_messages;
		
	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	DBNC_arrive_timer(IN := arrive_raw, PT := DBNC_arrive_time);
	arrive := DBNC_arrive_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	DBNC_before_timer(IN := before_raw, PT := DBNC_before_time);
	before := DBNC_before_timer.Q;

	// Device State Machine
	IF reset THEN
		udp_data.state := state := ReadyToWork;
		man_send := FALSE;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;

	CASE udp_data.state OF
		ReadyToWork:
			IF NOT(rail_mt) AND front AND onoff AND NOT(halted) THEN
				udp_data.state := state := Stabilizing;
			END_IF;

		Stabilizing:
			IF StabilizingTimer.Q THEN
				udp_data.state := state := ReadyForTransfer;
			END_IF;

		ReadyForTransfer:
			IF xfer_complete OR man_send OR open_signal THEN
				udp_data.state := state := Destabilizing;
			END_IF;

		Destabilizing:
			IF DestabilizingTimer.Q THEN
				IF over_full_sensor THEN
					udp_data.state := state := Overfull;
				ELSE
					udp_data.state := state := ReadyToRelease;
				END_IF;
			END_IF;

		Overfull:
			IF NOT(over_full_sensor) THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				man_send := FALSE;
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF NOT(fire) THEN
				udp_data.state := state := ReadyToWork;
			ELSIF after_b OR after_a THEN
				udp_data.state := state := ReleaseRear;
			END_IF;

		ReleaseRear:
			IF NOT(fire) OR after THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

	END_CASE;

	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND front
	AND NOT(custom_send_lock)
	AND NOT(before)
	AND NOT(after)
	AND NOT(over_full_sensor)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(before)
	AND NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	AND NOT(stp)
	);


	//Insert
	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Input Control
	arrive_raw := front_raw := front_a AND front_b;

	// Output Control
	stb := udp_data.state = Stabilizing OR udp_data.state = ReadyForTransfer;
	foot := FootDelayTimer.Q;
	stp := udp_data.state = Releasing;
	sling_ready := transfer_requested_signal AND udp_data.state = ReadyForTransfer AND onoff AND NOT(halted) AND NOT(safety_zone);
	over_full_light := over_full_sensor;
	stp_a := udp_data.state = ReleaseRear;

	// Output Switch Control
	IF SwInARTrig.Q THEN
		sw_in_a := TRUE;
	END_IF;

	IF before AND going_to THEN
		sw_in_a := FALSE;
		sw_in_b  := TRUE;
	END_IF;

	IF NOT(going_to) THEN
		sw_in_a := FALSE;
		sw_in_b  := FALSE;
	END_IF;

	IF SwOutARTrig.Q THEN
		sw_out_a := TRUE;
	END_IF;

	IF fire AND after THEN
		sw_out_a := FALSE;
		sw_out_b  := TRUE;
	END_IF;

	IF NOT(fire) THEN
		sw_out_a := FALSE;
		sw_out_b  := FALSE;
	END_IF;

	IF reset THEN
		sw_out_a := FALSE;
		sw_out_b  := FALSE;
	END_IF;


	// Control Timers
	StabilizingTimer(IN := udp_data.state = Stabilizing, PT := StabilizingTime);
	FootDelayTimer(IN := stb, PT := FootDelayTime);
	DestabilizingTimer(IN := udp_data.state = Destabilizing, PT := DestabilizingTime);


	// Control Triggers
	SwInARTrig(CLK := (going_to));
	SwOutARTrig(CLK := (fire));

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (front AND rail_mt), PT := UnexpectedBagTime);
	MissingBagTimer(IN := (NOT(front) AND NOT(rail_mt)), PT := MissingBagTime);

	udp_data.alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;
	udp_data.warning_com.1 := warning_com.1 := MissingBagTimer.Q;
	udp_data.warning_com.11 := warning_com.11 := xfer_in_progress;
	udp_data.warning_com.14 := warning_com.14 := sling_ready;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 
	

END_FUNCTION_BLOCK