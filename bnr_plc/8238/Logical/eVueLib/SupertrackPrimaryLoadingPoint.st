
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackPrimaryLoadingPoint

	messages ACCESS p_messages;
	loadcell ACCESS p_loadcell;

	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	// Device State Machine
	IF reset THEN
		IF front THEN
			udp_data.state := state := Loading;
		ELSE
			udp_data.state := state := ReadyToWork;
		END_IF;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;
	
	
	CASE udp_data.state OF
		ReadyToWork:
			IF front AND onoff AND NOT(halted) THEN
				udp_data.state := state := Loading;
			END_IF;

		Loading:
			IF man_send OR EDGENEG(foot) THEN
				man_send := 0;
				udp_data.state := state := ReadyToRelease;
			ELSIF rail_mt AND NOT front_raw THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF NOT(fire) THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

	END_CASE;
	
	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND NOT(custom_send_lock)
	AND NOT(safety_zone)
	AND NOT(loadcell.over_weight)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(arrive)
	AND NOT(custom_bring_lock)
	);

	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Input Control
	arrive := arrive_raw := front_raw;

	// Weight
	IF NOT(udp_data.state = Releasing) THEN
		loadcell.capture_weight_bool := TRUE;
	ELSE
		loadcell.capture_weight_bool := FALSE;
	END_IF;

	// Output Control
	stp := (udp_data.state = Releasing);  // Stop inside remover

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (front AND rail_mt), PT := UnexpectedBagTime);


	// Alarm Coms
	alarm := AlarmTimer.Q;
	warning_com.0 := UnexpectedBagTimer.Q;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 
	

END_FUNCTION_BLOCK