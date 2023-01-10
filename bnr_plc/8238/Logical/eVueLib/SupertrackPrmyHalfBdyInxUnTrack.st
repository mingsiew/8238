
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackPrmyHalfBdyInxUnTrack

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	// Device State Machine
	IF reset THEN
		udp_data.state := state := ReadyToRelease;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToRelease; END_IF;
	
	CASE udp_data.state OF
		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := OpenStop;
			END_IF;

		OpenStop: 
			IF ton_open.Q THEN
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
	);

  
	tof_arrive_dbnc(IN:= EDGENEG(arrive_raw), PT:= dnbc_arrive_time);
	arrive := arrive_raw AND NOT tof_arrive_dbnc.Q;
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Output Control
	inx := udp_data.state = OpenStop;  
            
	ton_open(IN:= (udp_data.state = OpenStop),PT:= openTime);  
	
	// Pressure reliefts
	tof_pressure_1(IN := pressure_full_line_1 OR pressure_stop_1 , PT:= prs_wait_time);  
	tof_pressure_2(IN := pressure_full_line_2 OR pressure_stop_2 , PT:= prs_wait_time);  
	tof_pressure_3(IN := pressure_full_line_3 OR pressure_stop_3 , PT:= prs_wait_time);  
            
	tof_open_pressure_1(IN := pressure_sensor_1 AND NOT tof_pressure_1.Q, PT:= prs_open_time);
	tof_open_pressure_2(IN := pressure_sensor_2 AND NOT tof_pressure_2.Q, PT:= prs_open_time);
	tof_open_pressure_3(IN := pressure_sensor_3 AND NOT tof_pressure_3.Q, PT:= prs_open_time);
            
	pressure_stop_1 := tof_open_pressure_1.Q;         
	pressure_stop_2 := tof_open_pressure_2.Q;  
	pressure_stop_3 := tof_open_pressure_3.Q;   
	

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (arrive AND NOT(front) AND NOT(inx)), PT := UnexpectedBagTime);

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
