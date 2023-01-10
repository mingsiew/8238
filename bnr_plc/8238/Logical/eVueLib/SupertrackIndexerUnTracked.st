
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackIndexerUnTracked

	messages ACCESS p_messages;

	  // Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	DBNC_arrive_timer(IN := arrive_raw, PT := DBNC_arrive_time);
	arrive := DBNC_arrive_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	// Device State Machine
	IF reset THEN udp_data.state := state := ReadyToRelease; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToRelease; END_IF;

	CASE udp_data.state OF
		ReadyToRelease:
			IF fire_os THEN
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
	AND (counter = 2)
	);

	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Trolley Counting
	IF reset THEN
		counter := 2;
	END_IF;

	IF EDGEPOS(going_to) THEN
		counter := 0;
	END_IF;

	IF EDGEPOS(arrive_raw) AND NOT(INS_OFF.Q) THEN
		IF (counter < 2 )THEN
			counter := counter + 1;
		END_IF;
	END_IF;

	IF ok_to_send THEN
		IF rail_full THEN
			counter := 1;
		ELSE
			counter := 2;
		END_IF;
		ok_to_send := 0;
	END_IF;

	INS_OFF(IN := (arrive_raw), PT := DBNC_counter_time);

	// Output Control
	inx := udp_data.state = Releasing;

	// Pressure Relief
	tof_pressure(IN := pressure_full_line_1, PT:= tof_pressureTime);
	pressure_stop_1 := NOT tof_pressure.Q;

	tof_pressure_2(IN := pressure_full_line_2, PT:= tof_pressureTime);
	pressure_stop_2 := NOT tof_pressure_2.Q;

	tof_pressure_3(IN := pressure_full_line_3, PT:= tof_pressureTime);
	pressure_stop_3 := NOT tof_pressure_3.Q;

	tof_pressure_4(IN := pressure_full_line_4, PT:= tof_pressureTime);
	pressure_stop_4 := NOT tof_pressure_4.Q;

	tof_pressure_5(IN := pressure_full_line_5, PT:= tof_pressureTime);
	pressure_stop_5 := NOT tof_pressure_5.Q;

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (arrive AND NOT(front) AND NOT(inx)), PT := UnexpectedBagTime);
	RearTrolleyLockTimer(IN := (counter = 0) AND NOT(front) AND NOT(going_to), PT := RearTrolleyLockTime);

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;
	udp_data.warning_com.2 := warning_com.2 := RearTrolleyLockTimer.Q;

	messages.Write := 0;
	IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF RearTrolleyLockTimer.Q      THEN messages.Write := BIT_SET(messages.Write,REAR_TROLLEY_LOCK); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));


END_FUNCTION_BLOCK
