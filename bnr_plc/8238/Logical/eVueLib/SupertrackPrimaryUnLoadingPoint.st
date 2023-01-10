
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackPrimaryUnLoadingPoint

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	// Device State Machine
	IF reset THEN
		IF front THEN
			udp_data.state := state := ReadyToUnload;
		ELSE
			udp_data.state := state := ReadyToWork;
		END_IF;
	END_IF;

	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;
	
	CASE udp_data.state OF

		ReadyToWork:
			IF front AND onoff AND NOT(halted) THEN
				udp_data.state := state := ReadyToUnload;
			END_IF;

		ReadyToUnload:
			IF man_send OR EDGENEG(foot) THEN
				man_send := 0;
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
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	);
            
	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(arrive)
	AND NOT(front)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;
          
	// Input Control
	arrive := arrive_raw := front_raw;
	after := after_raw;


	// Output Control
	stp := (udp_data.state = Releasing);  
	
	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (front AND rail_mt), PT := UnexpectedBagTime);


	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 
	

END_FUNCTION_BLOCK

