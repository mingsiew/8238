
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackPrmyFullBdyInxTrack

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	DBNC_in_pos_timer(IN := in_pos_raw, PT := (DBNC_in_pos_time*2));
	in_pos := DBNC_in_pos_timer.Q;

	ton_lineFull(IN:= full_sensor, PT:= lineFullTime);
	full :=  ton_lineFull.Q;

	// Device State Machine
	IF reset THEN
		udp_data.state := state := ReadyToRelease;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToRelease; END_IF;
	
	CASE udp_data.state OF
		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Seperate;
			END_IF;

		Seperate: 
			IF DBNC_in_pos_timer.Q THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
				udp_data.state := state := ReadyToRelease;
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
	NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	AND NOT(full)
	);
  
	tof_arrive_dbnc(IN:= EDGENEG(arrive_raw), PT:= dnbc_arrive_time);
	arrive := arrive_raw AND NOT tof_arrive_dbnc.Q;
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Output Control
	inx := udp_data.state = Seperate;  
  
	// Pressure Relief    
	tof_pressure_1(IN := pressure_full_line_1, PT:= tof_pressureTime);  
	pressure_stop_1 := NOT tof_pressure_1.Q;   
	
	tof_pressure_2(IN := pressure_full_line_2, PT:= tof_pressureTime);  
	pressure_stop_2 := NOT tof_pressure_2.Q;     

	tof_pressure_3(IN := pressure_full_line_3, PT:= tof_pressureTime);  
	pressure_stop_3 := NOT tof_pressure_3.Q; 

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (arrive AND NOT(front) AND NOT(inx)), PT := UnexpectedBagTime);
	MissingBagTimer(IN := (NOT(front) AND NOT(rail_mt) AND NOT(inx)), PT := MissingBagTime);

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := MissingBagTimer.Q;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 
	

END_FUNCTION_BLOCK


