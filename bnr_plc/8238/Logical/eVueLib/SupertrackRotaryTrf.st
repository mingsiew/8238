
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackRotaryTrf

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

		Reset: // Check the points are straight
			IF onoff AND NOT(halted) THEN
				IF ton_rotated.Q AND NOT rail_mt THEN
					udp_data.state := state := SettleOnPoints;
				ELSIF rail_mt AND NOT front_a AND NOT front_b THEN
					udp_data.state := state := ReadyToReceive;
				ELSIF front_a AND NOT rail_mt THEN
					udp_data.state := state := ReadyToRelease;
				END_IF;
			END_IF;


		ReadyToReceive: // stp b is open
			IF going_to THEN
				udp_data.state := state := ReceivingStraight;
			ELSIF ton_request_rotate.Q THEN // Requested to go to rotate position
				udp_data.state := state := MoveToRotate;
			END_IF;

		ReceivingStraight: //Bag is on its way
			IF arrive THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		MoveToRotate: // Move to "in" position
			IF ton_rotated.Q THEN
				udp_data.state := state := SettleOnPoints;
			END_IF;

		SettleOnPoints:  //Wait for bag to arrive a and b closed
			IF ton_settledOnPoints.Q THEN
				udp_data.state := state := MoveToStraight;
			END_IF;

		MoveToStraight:
			IF ton_straight.Q THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
				udp_data.state := state := Reset;
			END_IF;

	END_CASE;
	
	
	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND ton_straight.Q
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	((udp_data.state = ReadyToReceive) AND ton_straight.Q AND NOT request_rotate) OR
	((udp_data.state = SettleOnPoints) AND ton_rotated.Q)
	AND NOT(front_a)
	AND NOT(front_b)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);

	ton_request_rotate(IN:= request_rotate, PT:= requestRotateTime);
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;
	
	// Input Control
	arrive := arrive_raw OR front_a;
	front := front_a OR front_b;
	

	// Output Control
	stp_a := (udp_data.state = Releasing) AND ton_straight.Q;
	stp_b := ((udp_data.state = Releasing) OR (udp_data.state = ReceivingStraight)) AND ton_straight.Q;

	switch := (
	(udp_data.state = MoveToRotate)
	OR (udp_data.state = SettleOnPoints)
	);// AND NOT ton_rotated.Q;

	reset_switch  := (
	(udp_data.state = ReadyToReceive)
	OR (udp_data.state = ReceivingStraight)
	OR (udp_data.state = MoveToStraight)
	OR (udp_data.state = ReadyToRelease)
	OR (udp_data.state = Releasing)
	);// AND NOT ton_straight.Q;
	
	ton_rotated(IN:= sw_in_a AND sw_in_b, PT:= rotateTime);
	ton_straight(IN:= sw_out_a AND sw_out_b, PT:= rotateTime);
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
