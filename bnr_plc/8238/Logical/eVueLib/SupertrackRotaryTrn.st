
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackRotaryTrn

	messages ACCESS p_messages;

	  // Debounce Inputs
	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;
	
	DBNC_before_timer(IN := before_raw, PT := DBNC_before_time);
	before := DBNC_before_timer.Q;
	

	// Device State Machine
	IF reset THEN udp_data.state := state := Reset; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := Reset; END_IF;

	CASE udp_data.state OF

		Reset: //Always move to straight then decide what to do
			IF onoff AND NOT(halted) THEN
				IF ton_straight.Q AND NOT rail_mt THEN
					udp_data.state := state := SettleOnPoints;
				ELSIF ton_straight.Q AND rail_mt AND NOT front_a AND NOT front_b THEN
					udp_data.state := state := ReadyToReceive;
				END_IF;
			END_IF;

		ReadyToReceive: // stp b is open wait for bag to arrive.
			IF going_to THEN
				udp_data.state := state := Receiving;
			END_IF;

		Receiving: //Bag is on its way  stp b is open wait for bag to arrive.
			IF arrive THEN
				udp_data.state := state := SettleOnPoints;
			END_IF;

		SettleOnPoints:  //Wait for bag to arrive a and b closed
			IF ton_settledOnPoints.Q THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:// Decide where to send bag - Waiting for straight rail is on.
			IF fire_os THEN
				udp_data.state := state := ReleasingStraight;
			ELSIF request_rotate THEN
				udp_data.state := state := MoveToRotate;
			END_IF;

		MoveToRotate: // Move to "in" position
			IF ton_rotated.Q THEN
				udp_data.state := state := ReadyToReleaseRotate;
			END_IF;

		ReadyToReleaseRotate:
			IF fire_os THEN
				udp_data.state := state := ReleasingRotate;
			END_IF;

		ReleasingStraight:
			IF after OR NOT(fire) THEN
				udp_data.state := state := Reset;
			END_IF;

		ReleasingRotate:
			IF after OR NOT(fire) THEN
				udp_data.state := state := Reset;
			END_IF;

	END_CASE;
	
	
	// Comm Logic
	udp_data.waiting := waiting := (
	(((udp_data.state = ReadyToRelease) AND ton_straight.Q)
	OR ((udp_data.state = ReadyToReleaseRotate) AND ton_rotated.Q))
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	(udp_data.state = ReadyToReceive)
	AND ton_straight.Q
	AND NOT(front_a)
	AND NOT(front_b)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;
	
	// Input Control
	arrive := arrive_raw;
	front := front_a OR front_b;
	

	// Output Control
	stp_a := (
	((udp_data.state = ReleasingStraight) AND ton_straight.Q)
	OR ((udp_data.state = ReleasingRotate) AND ton_rotated.Q)
	);

	stp_b := (
	((udp_data.state = ReleasingStraight) AND ton_straight.Q)
	OR ((udp_data.state = ReleasingRotate) AND ton_rotated.Q)
	OR (udp_data.state = ReadyToReceive)
	OR (udp_data.state = Receiving)
	);
	
	rotate := (
	(udp_data.state = MoveToRotate)
	OR (udp_data.state = ReadyToReleaseRotate)
	OR (udp_data.state = ReleasingRotate)
	);
	
	switch := rotate;
	reset_switch  := NOT rotate;

	ton_straight(IN:= sw_in_a AND sw_in_b, PT:= rotateTime);
	ton_rotated(IN:= sw_out_a AND sw_out_b, PT:= rotateTime);
	ton_settledOnPoints(IN:= front_a AND front_b, PT:= settleTime);

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (arrive AND NOT(front)), PT := UnexpectedBagTime);
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