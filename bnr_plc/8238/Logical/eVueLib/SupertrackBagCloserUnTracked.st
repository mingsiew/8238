
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackBagCloserUnTracked

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
			IF front AND onoff AND NOT(halted) THEN
				udp_data.state := state := Stabilizing;
			END_IF;

		Stabilizing:
			IF StabilizingTimer.Q THEN
				udp_data.state := state := Opening;
			ELSIF NOT(onoff) THEN
				udp_data.state := state := ReadyToWork;
			END_IF;
     
		Opening:
			IF OpeningTimer.Q THEN
				udp_data.state := state := Closing;
			END_IF;

		Closing:
			IF ClosingTimer.Q THEN
				udp_data.state := state := Destabilizing;
			END_IF;

		Destabilizing:
			IF DestabilizingTimer.Q THEN
				IF empty_bag THEN 
					udp_data.state := state := ReadyToRelease;
				ELSIF (messages.Read[BAG_NOT_CLOSED] = 2) THEN 
					udp_data.state := state := ReadyToRelease;
				ELSIF (messages.Read[BAG_NOT_CLOSED] = 1) THEN 
					udp_data.state := state := Stabilizing;
				END_IF; 
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
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
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Output Control
	stb := (
	udp_data.state = Stabilizing
	OR udp_data.state = Opening
	OR udp_data.state = Closing
	);

	open := (
	udp_data.state = Opening
	OR udp_data.state = Closing
	);

	stp := udp_data.state = Releasing;
	close := udp_data.state = Closing;


	// Control Timers

	StabilizingTimer(IN := (udp_data.state = Stabilizing), PT := StabilizingTime);
	DestabilizingTimer(IN := (udp_data.state = Destabilizing), PT := DestabilizingTime);
	ClosingTimer(IN := (udp_data.state = Closing), PT := ClosingTime);
	OpeningTimer(IN := (udp_data.state = Opening), PT := OpeningTime);
	
	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	udp_data.alarm := alarm := AlarmTimer.Q;

	// Rail Fault Handling.  
	messages.Write := 0;
	//BAG_STUCK  -- NOT YET IMPLEMENTED
	IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q      THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;
	IF BagNotClosedTimer.Q    THEN messages.Write := BIT_SET(messages.Write,BAG_NOT_CLOSED); END_IF; 
 
	// Always clear acknowledgements    
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 

END_FUNCTION_BLOCK