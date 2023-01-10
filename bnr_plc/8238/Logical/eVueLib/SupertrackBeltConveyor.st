
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackBeltConveyor

	messages ACCESS p_messages;

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
			IF NOT(rail_mt) AND NOT(halted) THEN
				udp_data.state := state := RunToFront;
			END_IF;

		RunToFront:
			IF NOT(front) THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
				udp_data.state := state := ClearBelt;
			END_IF;

		ClearBelt:
			IF ClearBeltTimer.Q THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

	END_CASE;
	
	
	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND NOT(custom_send_lock)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND arrive
	AND front
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);
	
	IF going_to AND NOT(arrive) THEN insert := TRUE; END_IF;

	// Output Control
	run_conveyor := (
	NOT(halted) AND NOT halt
	AND (
	udp_data.state = Releasing
	OR udp_data.state = ClearBelt
	OR udp_data.state = RunToFront
	OR (going_to AND front AND (udp_data.state = ReadyToWork))
	));

	releasing := (
	udp_data.state = Releasing
	OR udp_data.state = ClearBelt    
	);

	//Control Timers
	ClearBeltTimer(IN := (udp_data.state = ClearBelt AND arrive AND NOT receiving AND conveyor_running AND front AND NOT(fire)), PT := ClearBeltTime);
	MaximumBeltRunningTime(IN:= (run_conveyor AND conveyor_running), PT := MaximumRunningTime );
	IF MaximumBeltRunningTime.Q THEN
		halt := TRUE;
	END_IF;   


	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (NOT front AND ((rail_mt AND (udp_data.state <> ClearBelt)) OR (conveyor_running AND (udp_data.state = ClearBelt)))) , PT := UnexpectedBagTime);
	MissingBagTimer(IN := (front AND NOT(rail_mt)), PT := MissingBagTime );

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := 0;//UnexpectedBagTimer.Q;
	udp_data.warning_com.1 := warning_com.1 := 0;//MissingBagTimer.Q;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;
	IF halt THEN  messages.Write := BIT_SET(messages.Write,EXCEED_RUN_TIME); END_IF;
            
	CASE messages.Read[EXCEED_RUN_TIME] OF
		1: //They want to continue running
			halt := 0;
		2: //Confirm belt is clear 
			halt := 0;
			IF (udp_data.state = RunToFront) THEN
				IF rail_mt THEN
					udp_data.state := state := ReadyToWork;
				END_IF;
			ELSE    
				udp_data.state := state := ReadyToWork;
			END_IF;
	END_CASE;    

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));
	

END_FUNCTION_BLOCK