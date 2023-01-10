
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackPrimaryIncline

	messages ACCESS p_messages;

	// Debounce Inputs
	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;
	
	DBNC_before_timer(IN := before_raw, PT := DBNC_before_time);
	before := DBNC_before_timer.Q;
	
	//debounce timer for top sensor as the bag can swing when releasing
	ton_top_sensor_dnbc(IN:=(udp_data.state = Releasing) AND conveyor_running, PT:= dbnc_top_switch_time);
	//Clear the trolley at top bit when we have released the trolley from the inclines.
	IF ton_top_sensor_dnbc.Q THEN
		trolleyAtTop := 0;
	END_IF;

	//Detect the EDGE of the trolley moving off the out sensor
	IF EDGEPOS(rail_out_sensor) THEN
		trolleyAtTop := 1;
	END_IF;

	// Move this outside the case so that we can see the edge correctly
	IF  EDGEPOS(trolleyAtTop) AND (udp_data.state = Releasing)  THEN
		udp_data.state := state := ReadyToRelease;
	END_IF;

	// Device State Machine
	IF reset THEN
		udp_data.state := state := ReadyToWork;
		IF rail_mt THEN
			trolleyAtTop := 0;
		END_IF;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToWork; END_IF;

	CASE udp_data.state OF

		ReadyToWork: // Motor can run  if not MT
			IF trolleyAtTop THEN
				udp_data.state := state := ReadyToRelease;
			ELSIF before AND NOT rail_full THEN
				udp_data.state := state := AlignLift;
			END_IF;

		AlignLift: // Find the paddle in position
			IF trolleyAtTop THEN
				udp_data.state := state := ReadyToRelease;
			ELSIF rail_full THEN
				udp_data.state := state := ReadyToWork;
			ELSIF paddle_sensor THEN
				udp_data.state := state := Receiving;
			END_IF;

		Receiving: // Motor stopped and bag coming in from buffer
			IF arrive_raw THEN
				udp_data.state := state := ReadyToWork;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF after OR NOT(fire)  THEN
				trolleyAtTop := 0;
				udp_data.state := state := ReadyToWork;
			ELSIF NOT trolleyAtTop AND before AND NOT rail_full AND NOT rail_mt AND paddle_sensor  THEN
				udp_data.state := state := Receiving;
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
	NOT(arrive)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	AND (udp_data.state = Receiving)
	);

	arrive := arrive_raw;

	IF going_to AND arrive THEN insert := TRUE; END_IF;

	// Output Control;
	run_slant := (
	(((((udp_data.state = ReadyToWork) AND (NOT rail_mt OR (fire AND rail_mt))) OR (udp_data.state = AlignLift)) AND NOT trolleyAtTop)
	OR (udp_data.state = Releasing))
	AND onoff
	);
	
	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (arrive AND rail_mt AND NOT(run_slant)), PT := UnexpectedBagTime);

	// Alarm Coms
	udp_data.alarm := alarm := AlarmTimer.Q;
	udp_data.warning_com.0 := warning_com.0 := UnexpectedBagTimer.Q;

	messages.Write := 0;
	IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	
	// Always clear acknowledgements    
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));  
	

END_FUNCTION_BLOCK