
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackEasisort

	messages ACCESS p_messages;
	loadcell ACCESS p_loadcell;

	IF  udp_data.state = 0 THEN  udp_data.state := state := Resetting; END_IF;

	// Device State Machine
	IF reset THEN
		udp_data.state := state := Resetting;
		man_send := FALSE;
		purge := FALSE;
	END_IF;
	IF OverWeightTimer.Q AND (( udp_data.state = Loading) OR ( udp_data.state = NearWeight) OR ( udp_data.state = ReadyToRelease)) THEN
		 udp_data.state := state := OverWeight;
	END_IF;
	CASE  udp_data.state OF

		Resetting:
			IF ResettingTimer.Q THEN
			  udp_data.state := state := Loading;
			END_IF;

		Loading:
			IF purge THEN
              udp_data.state := state := OpenDoor;
            ELSIF NearWeightTimer.Q THEN
			  udp_data.state := state := NearWeight;
			ELSIF man_send THEN
			  udp_data.state := state := ReadyToRelease;
			END_IF;

		NearWeight:
			IF purge THEN
              udp_data.state := state := OpenDoor;
            ELSIF FullWeightTimer.Q THEN
			  udp_data.state := state := ReadyToRelease;
			ELSIF man_send THEN
			  udp_data.state := state := ReadyToRelease;
			END_IF;

		ReadyToRelease:
			IF fire_os THEN
				udp_data.state := state := OpenDoor;
			END_IF;

		OpenDoor:
			IF OpenDoorTimer.Q THEN
			  IF purge THEN
                udp_data.state := state := RunEmpty;
              ELSE
				udp_data.state := state := Releasing;
			  END_IF;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
			  udp_data.state := state := RunEmpty;
			END_IF;

		RunEmpty:
			IF EmptyWeightTimer.Q THEN
			  udp_data.state := state := CloseDoor;
			END_IF;

		CloseDoor:
			IF CloseDoorTimer.Q THEN
			  udp_data.state := state := Loading;
			  purge := FALSE;
			END_IF;

		OverWeight:
			IF (messages.Read[OVERWEIGHT] = 1) AND WeightOk.Q THEN
			  udp_data.state := state := Loading;
			END_IF;

	END_CASE;

	// Comm Logic
	udp_data.waiting := waiting := (
	(udp_data.state = ReadyToRelease)
	AND NOT custom_send_lock
	AND NOT after
	AND NOT safety_zone
	AND NOT loadcell.over_weight
	);

	// Inserts
	IF going_to AND arrive THEN insert := TRUE; END_IF;

	IF udp_data.state = NearWeight OR udp_data.state = Loading THEN
		loadcell.capture_weight_bool := TRUE;
	ELSE
		loadcell.capture_weight_bool := FALSE;
	END_IF;

	// Input Control
	man_send := FALSE; // Clear any manual send request if not on the right step
	IF man_send_button THEN
		man_send := TRUE;
	END_IF;

	// Output Control
	open := releasing :=  (
	udp_data.state = OpenDoor
	OR udp_data.state = Releasing
	OR udp_data.state = RunEmpty
	);

	run_conveyor  := (
	udp_data.state = Releasing
	OR udp_data.state = RunEmpty
	);

	red_light := (
	((loadcell.notify_weight AND SlowOnPulseTimer.Q)
	OR udp_data.state = ReadyToRelease
	OR udp_data.state = RunEmpty
	OR udp_data.state = CloseDoor
	OR udp_data.state = Releasing
	OR udp_data.state = Resetting
	AND NOT(loadcell.over_weight))
	OR (loadcell.over_weight AND FastOnPulseTimer.Q)
	);

	// Control Timers
	EmptyWeightTimer(IN:= loadcell.empty AND conveyor_running, PT:= EmptyWeightTime);
	NearWeightTimer(IN := (loadcell.near_weight), PT := NearWeightTime);
	FullWeightTimer(IN := (loadcell.full), PT := FullWeightTime);
	ResettingTimer(IN := (udp_data.state = Resetting), PT := ResettingTime);
	CloseDoorTimer(IN := (udp_data.state = CloseDoor), PT := CloseDoorTime);
	OpenDoorTimer(IN := udp_data.state = OpenDoor, PT:= OpenDoorTime);
	WeightOk(IN := (udp_data.state = OverWeight), PT:= WeightOkTime);

	FastOnPulseTimer(IN := NOT(FastOffPulseTimer.Q), PT := FastOnPulseTime);
	FastOffPulseTimer(IN := FastOnPulseTimer.Q, PT := FastOffPulseTime);
	SlowOnPulseTimer(IN := NOT(SlowOffPulseTimer.Q), PT := SlowOnPulseTime);
	SlowOffPulseTimer(IN := SlowOnPulseTimer.Q, PT := SlowOffPulseTime);


	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	OverWeightTimer(IN := (loadcell.over_weight AND NOT(rail_mt)), PT := OverWeightTime);

	udp_data.alarm := alarm := AlarmTimer.Q;

	messages.Write := 0;
	IF (udp_data.state = OverWeight)  THEN messages.Write := BIT_SET(messages.Write,OVERWEIGHT); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));

END_FUNCTION_BLOCK
