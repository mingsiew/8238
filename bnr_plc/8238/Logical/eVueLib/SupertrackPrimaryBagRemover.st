
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackPrimaryBagRemover

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;
	
	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	// Device State Machine
	IF reset THEN udp_data.state := state := ReadyToWork; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;
	
	CASE udp_data.state OF

		ReadyToWork:
			IF (front_raw OR going_to) AND onoff AND NOT(halted) THEN
				udp_data.state := state := Receiving;
			END_IF;

		Receiving:
			IF front THEN
				udp_data.state := state := StripBag;
			END_IF;

		StripBag: 
			IF ton_strip.Q THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;   

		ReadyToRelease:
			IF fire THEN //(Use the .fire not the edge, so we can retry on a timeout.)
				udp_data.state := state := Releasing;
			END_IF;  

		Releasing:
			IF NOT(fire) OR after THEN
				udp_data.state := state := ReadyToWork;
			ELSIF ton_timeout.Q THEN
				udp_data.state := state := StripBag;
			END_IF;	

	END_CASE;
	
	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND front
	AND NOT(custom_send_lock)
	AND NOT(after_raw)
	AND NOT(safety_zone)
	);
            
	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND NOT(front_raw)
	AND NOT(custom_bring_lock)
	AND NOT(safety_zone)
	);
	
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;
          
	// Input Control
	arrive := arrive_raw := front_raw;  

	// Output Control
	stp := (udp_data.state = Releasing); 
  
	grab := ((udp_data.state = ReadyToRelease) OR (udp_data.state = StripBag)); 
          
	ton_timeout(IN:= (udp_data.state = Releasing), PT:= releaseTime);
	ton_strip(IN:= (udp_data.state = StripBag), PT:= stripTime); 
	
	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	//IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 
	

END_FUNCTION_BLOCK