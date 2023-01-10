
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackRudderStp

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
	
	DBNC_after_a_timer(IN := after_a_raw, PT := DBNC_after_a_time);
	after_a := DBNC_after_a_timer.Q;

	DBNC_after_b_timer(IN := after_b_raw, PT := DBNC_after_b_time);
	after_b := DBNC_after_b_timer.Q;


	// Device State Machine
	IF reset THEN udp_data.state := state := ReadyToWork; END_IF;
	IF udp_data.state = 0 THEN
		udp_data.state := state := ReadyToWork;;
		front_a_seen := FALSE;
	END_IF;
	
	CASE udp_data.state OF
		ReadyToWork:
			IF front_a AND NOT(front_a_seen) THEN
				front_a_seen := TRUE;
			ELSIF NOT(rail_mt) AND front AND onoff AND NOT(halted) THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := ReleasingFront;
				front_a_seen := FALSE;
			END_IF;

		ReleasingFront:
			IF after_a THEN
				udp_data.state := state := ReleasingRear;
			ELSIF NOT(fire) OR after THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

		ReleasingRear:
			IF after_b OR NOT(fire) THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

	END_CASE;

	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND front
	AND NOT(custom_send_lock)
	AND NOT(after_b)
	AND NOT(after)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(going_to)
	AND NOT(before)
	AND NOT(arrive)
	AND NOT(front_a)
	AND NOT(front_b)
	AND NOT(custom_bring_lock)
	);

	IF going_to AND arrive THEN insert := TRUE; END_IF;
	
	// Input Control
	arrive_raw := front_raw := front_a_seen AND front_b;

	// Output Control
	stp := udp_data.state = ReleasingFront OR udp_data.state = ReleasingRear;
	stp_a := udp_data.state = ReleasingFront OR udp_data.state = ReleasingRear;
	stp_b := udp_data.state = ReleasingRear;
	
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

	// Control Triggers
	SwInARTrig(CLK := (going_to));
	SwOutARTrig(CLK := (fire));

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (front AND rail_mt), PT := UnexpectedBagTime);
	MissingBagTimer(IN := (NOT(front) AND NOT(rail_mt)), PT := MissingBagTime);

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;
	udp_data.warning_com.1 := warning_com.1 := MissingBagTimer.Q;

	messages.Write := 0;
	IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q      THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;

	// Always clear acknowledgements    
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));  

END_FUNCTION_BLOCK