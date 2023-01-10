
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackStp

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
	IF reset THEN udp_data.state := state := ReadyToWork; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;

	CASE udp_data.state OF
		ReadyToWork:
			IF NOT(rail_mt) AND front AND onoff AND NOT(halted) THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;
	
		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			ELSIF EmptyTimeoutTimer.Q THEN
				udp_data.state := state := ReadyToWork;
			END_IF;
	
		Releasing:
			IF after OR NOT(fire) THEN
				udp_data.state := state := ReadyToWork;
			END_IF;
	END_CASE;
	
	
	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND front
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;
	
	// Weight Comm
	IF udp_data.state = ReadyToWork OR udp_data.state = ReadyToRelease THEN
		loadcell.capture_weight_bool := TRUE;
	ELSE
		loadcell.capture_weight_bool := FALSE;
	END_IF;
	
	// Output Control
	stp := udp_data.state = Releasing;

	// Control Timers
	EmptyTimeoutTimer(IN := udp_data.state = ReadyToRelease AND rail_mt AND NOT(front) AND NOT(arrive), PT := EmptyTimeoutTime);
	
	
	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (front AND rail_mt AND NOT(stp)), PT := UnexpectedBagTime);
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