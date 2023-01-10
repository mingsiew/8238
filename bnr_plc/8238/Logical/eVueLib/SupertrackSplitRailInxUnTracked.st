
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackSplitRailInxUnTracked

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	DBNC_arrive_timer(IN := arrive_raw, PT := DBNC_arrive_time);
	arrive := DBNC_arrive_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;
	
	DBNC_before_timer(IN := before_raw, PT := DBNC_before_time);
	before := DBNC_before_timer.Q;


	// Device State Machine
	IF reset THEN udp_data.state := state := ReadyToRelease; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToRelease; END_IF;

	CASE udp_data.state OF
		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := PrepareToRelease;
			END_IF;
			
		PrepareToRelease:
			IF TrolleyPrepareTimer.Q THEN
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
	NOT(before)
	AND NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);


	IF going_to AND arrive THEN insert := TRUE; END_IF;
	
	// Input Control
	front_raw := front_a AND front_b;

	// Output Control
	inx := udp_data.state = PrepareToRelease;
	
	//Pressure Relief Outputs
	Pressure1Timer(IN := NOT(pressure_sensor_1) AND NOT(pressure_full_line_1), PT := Pressure1Time);
	Pressure2Timer(IN := NOT(pressure_sensor_2) AND NOT(pressure_full_line_2), PT := Pressure2Time);
	Pressure3Timer(IN := NOT(pressure_sensor_3) AND NOT(pressure_full_line_3), PT := Pressure3Time);
	Pressure4Timer(IN := NOT(pressure_sensor_4) AND NOT(pressure_full_line_4), PT := Pressure4Time);
	Pressure5Timer(IN := NOT(pressure_sensor_5) AND NOT(pressure_full_line_5), PT := Pressure5Time);

	pressure_stop_1 := Pressure1Timer.Q;
	pressure_stop_2 := Pressure2Timer.Q;
	pressure_stop_3 := Pressure3Timer.Q;
	pressure_stop_4 := Pressure4Timer.Q;
	pressure_stop_5 := Pressure5Timer.Q;
	
	// Output Switch Control
	IF SwInARTrig.Q THEN
		sw_in_a := TRUE;
	END_IF;

	IF before AND going_to THEN
		sw_in_a := FALSE;
		sw_in_b  := TRUE;
	END_IF;

	IF NOT(going_to) THEN
		sw_in_a := FALSE;
		sw_in_b  := FALSE;
	END_IF;

	IF SwOutARTrig.Q THEN
		sw_out_a := TRUE;
	END_IF;

	IF fire AND after THEN
		sw_out_a := FALSE;
		sw_out_b  := TRUE;
	END_IF;

	IF NOT(fire) THEN
		sw_out_a := FALSE;
		sw_out_b  := FALSE;
	END_IF;

	IF reset THEN
		sw_out_a := FALSE;
		sw_out_b  := FALSE;
	END_IF;

	// Control Triggers
	SwInARTrig(CLK := (going_to));
	SwOutARTrig(CLK := (fire));
	TrolleyPrepareTimer(IN := udp_data.state = PrepareToRelease, PT := TrolleyPrepareTime);

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (arrive AND NOT(front) AND NOT(inx)), PT := UnexpectedBagTime);

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;

	messages.Write := 0;
	IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;


	// Always clear acknowledgements    
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));  
	
END_FUNCTION_BLOCK
