
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackRatchetLift

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_arrive_timer(IN := arrive_raw, PT := DBNC_arrive_time);
	arrive := DBNC_arrive_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;
	
	// Device State Machine
	IF reset THEN udp_data.state := state := ReadyToWork; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;

	CASE udp_data.state OF
		ReadyToWork:
			IF NOT(rail_mt) AND onoff AND NOT(halted) THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Retract;
			END_IF;

		Retract:
			IF LowSensorTimer.Q THEN
				udp_data.state := state := Extend;
			END_IF;

		Extend:
			IF HighSensorTimer.Q THEN
				udp_data.state := state := Retract2;
			END_IF;

		Retract2:
			IF LowSensorTimer.Q THEN
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
	AND rail_full
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToWork
	AND rail_mt
	AND high_valve
	AND NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);
	
	IF going_to AND arrive THEN insert := TRUE; END_IF;
	
	// Output Control
	ratchet := udp_data.state = Retract OR udp_data.state = Retract2;

	//Output Timer
	HighSensorTimer(IN := high_valve, PT := HighSensorTime);
	LowSensorTimer(IN := low_valve, PT := LowSensorTime);
	
	
	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (arrive AND rail_mt AND NOT(ratchet)), PT := UnexpectedBagTime);


	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;


	messages.Write := 0;
	IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;

	// Always clear acknowledgements    
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));  

END_FUNCTION_BLOCK