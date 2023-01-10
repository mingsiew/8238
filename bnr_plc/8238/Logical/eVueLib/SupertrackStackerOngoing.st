
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackStackerOngoing

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
	IF reset THEN udp_data.state := state := ReadyToWork; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;

	CASE udp_data.state OF
		ReadyToWork:
			IF NOT(rail_mt) AND front AND onoff AND NOT(halted) THEN
				udp_data.state := state := Extending;
			END_IF;

		Extending:
			IF ExtendingTimer.Q THEN
				udp_data.state := state := Retracting;
			END_IF;

		Retracting:
			IF RetractingTimer.Q THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF NOT(fire) OR after THEN
				udp_data.state := state := ReadyToWork;
			END_IF;
	END_CASE;
	

	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND front
	AND NOT(custom_send_lock)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(arrive)
	AND NOT(going_to)
	AND NOT(tilt_arm)
	AND NOT(stp)
	AND NOT(ring_pusher)
	AND NOT(pusher)
	AND NOT(custom_bring_lock)
	AND NOT(safety_zone)
	);

	IF going_to AND arrive THEN insert := TRUE; END_IF;
	
	// Input Control
	arrive_raw := front_raw := front_a AND front_b;

	 // Output Control
	tilt_arm := udp_data.state = Extending;
	stp := udp_data.state = Releasing;
	pusher := PusherOnTimer.Q;
	ring_pusher :=  RingPusherTimer.Q;

	// Control Timers
	ExtendingTimer(IN := (udp_data.state = Extending), PT := ExtendingTime);
	RetractingTimer(IN := (udp_data.state = Retracting), PT := RetractingTime);
	PusherOnTimer(IN := udp_data.state = Releasing AND NOT(PusherOffTimer.Q), PT := PusherOnTime);
	PusherOffTimer(IN := udp_data.state = Releasing AND PusherOnTimer.Q, PT := PusherOffTime);

	RingPusherTimer(IN := udp_data.state = Extending, PT := RingPusherTime);

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
	UnexpectedBagTimer(IN := ((arrive OR front) AND rail_mt AND NOT(stp)), PT := UnexpectedBagTime);
	MissingBagTimer(IN := (NOT(front) AND NOT(rail_mt) AND NOT(stp)), PT := MissingBagTime);

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
