
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackBinTransferWithNetComm

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_front_timer(IN := front_raw, PT := DBNC_front_time);
	front := DBNC_front_timer.Q;

	DBNC_arrive_timer(IN := arrive_raw, PT := DBNC_arrive_time);
	arrive := DBNC_arrive_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	DBNC_mid_timer(IN := mid_raw, PT := DBNC_mid_time);
	mid_sensor := DBNC_mid_timer.Q;

	// Device State Machine
	IF reset THEN
		IF rail_mt AND NOT(going_to) THEN
			udp_data.state := state := ReadyToReceive;
		ELSIF NOT(rail_mt) THEN
			udp_data.state := state := ReadyToLoad;
		END_IF;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToReceive; END_IF;
	

	CASE udp_data.state OF
		ReadyToReceive:
			IF going_to THEN
				udp_data.state := state := Receiving;
			ELSIF NOT(rail_mt) THEN
				udp_data.state := state := ReadyToLoad;
			END_IF;

		Receiving:
			IF mid_sensor THEN
				udp_data.state := state := CatchRear;
			ELSIF NOT(going_to) THEN
				udp_data.state := state := ReadyToReceive;
			END_IF;

		CatchRear:
			IF NOT(rail_mt) THEN
				udp_data.state := state := ReadyToLoad;
			ELSIF NOT(going_to) THEN
				udp_data.state := state := ReadyToReceive;
			END_IF;

		ReadyToLoad:
			IF onoff AND NOT(halted) THEN
				udp_data.state := state := Stabilizing;
			ELSIF rail_mt AND NOT(front) THEN
				udp_data.state := state := ReadyToReceive;
			END_IF;

		Stabilizing:
			IF StabilizingTimer.Q THEN
				udp_data.state := state := BagReady;
			END_IF;

		BagReady:
			IF xfer_in_progress THEN
				udp_data.state := state := Loading;
			ELSIF man_send THEN
				udp_data.state := state := DeStabilizing;
			ELSIF rail_mt THEN
				udp_data.state := state := ReadyToReceive;
			END_IF;

		Loading:
			IF xfer_complete THEN
				udp_data.state := state := DeStabilizing;
			END_IF;

		DeStabilizing:
			IF DeStabilizingTimer.Q THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := ReleasingRear;
			END_IF;

		ReleasingRear:
			IF ReleaseRearTimer.Q THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
				udp_data.state := state := ReadyToReceive;
				man_send := FALSE;
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
	udp_data.state = ReadyToReceive
	AND NOT(mid_sensor)
	AND NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	);

	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Control Timers
	StabilizingTimer(IN := (udp_data.state = Stabilizing), PT := StabilizingTime);
	DeStabilizingTimer(IN := (udp_data.state = DeStabilizing), PT := DeStabilizingTime);
	ReleaseRearTimer(IN := udp_data.state = ReleasingRear, PT := ReleaseRearTime);

	// Output Control
	front_stp := udp_data.state = Releasing;
	rear_stp := udp_data.state = Receiving OR udp_data.state = ReleasingRear OR udp_data.state = Releasing;
	stb := udp_data.state = Stabilizing OR udp_data.state = BagReady OR udp_data.state = Loading;
	fire_up := udp_data.state = Stabilizing OR udp_data.state = BagReady OR udp_data.state = Loading;

	sling_ready := udp_data.state = BagReady;

	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (front AND rail_mt), PT := UnexpectedBagTime);
	MissingBagTimer(IN := (NOT(front) AND NOT(rail_mt)), PT := MissingBagTime);

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;
	udp_data.warning_com.1 := warning_com.1 := MissingBagTimer.Q;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 
	

END_FUNCTION_BLOCK