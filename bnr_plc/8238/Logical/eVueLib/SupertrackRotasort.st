
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackRotasort

	messages ACCESS p_messages;
	loadcell ACCESS p_loadcell;

	// Debounce Inputs
	DBNC_before_timer(IN := before_raw, PT := DBNC_before_time);
	before := DBNC_before_timer.Q;

	DBNC_loading_position_timer(IN := loading_position_raw, PT := DBNC_loading_position_time);
	loading_position := DBNC_loading_position_timer.Q;

	DBNC_after_timer(IN := after_raw, PT := DBNC_after_time);
	after := DBNC_after_timer.Q;

	// Device State Machine
	IF reset THEN udp_data.state := state := Reset; END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := Reset; END_IF;
	
	CASE udp_data.state OF

		Reset: //decide what to do
			IF onoff AND NOT(halted) THEN
				IF going_to THEN 
					udp_data.state := state := Receiving;  
				ELSIF (loading_position_raw OR NOT rail_mt) THEN
					udp_data.state := state := Loading;
				ELSIF rail_mt AND NOT front_a AND NOT front_b AND NOT loading_position_raw THEN
					udp_data.state := state := ReadyToReceive; 
				ELSIF ton_straight.Q THEN
					udp_data.state := state := ReadyToReceive;
				END_IF;
			END_IF;

		ReadyToReceive: // stp a & b are open waiting for bags to pass through.
			IF going_to THEN
				udp_data.state := state := Receiving;
			END_IF;

		Receiving: //Bag is on its way  stp b is open wait for bag to arrive.
			IF arrive THEN
				udp_data.state := state := SettleOnPoints;
			END_IF;

		SettleOnPoints:  //Wait for bag to arrive a and b closed
			IF ton_settledOnPoints.Q THEN
				udp_data.state := state := MoveToRotateBagIn;
			END_IF;
                
		MoveToRotateBagIn: // Move to "in" position
			IF ton_rotated.Q THEN
				udp_data.state := state := ReleaseBagToLoading;
			END_IF;
               
		ReleaseBagToLoading: // Release the bag in the loading position  
			IF loading_position THEN
				udp_data.state := state := Loading;  
			END_IF;  

		Loading:
			IF loadcell.over_weight THEN
				udp_data.state := state := OverWeight; 
			ELSIF NearWeightTimer.Q THEN
				udp_data.state := state := NearWeight;
			ELSIF man_send THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;

		NearWeight:
			IF loadcell.over_weight THEN
				udp_data.state := state := OverWeight; 
			ELSIF (FullWeightTimer.Q OR man_send) THEN
				udp_data.state := state := ReadyToRelease;
			END_IF;
              
		OverWeight:
			IF NOT(loadcell.over_weight) THEN
				udp_data.state := state := Loading;
			END_IF;

		ReadyToRelease:// Wait for the decider to tell us wehere to go
			IF fire_os THEN
				udp_data.state := state := MoveToRotateBagOut;
			END_IF;

		MoveToRotateBagOut: // Rotate so we can release a bag.
			IF ton_rotated.Q THEN
				udp_data.state := state := ReleaseBagToPoints;
			END_IF;

		ReleaseBagToPoints: //   
			IF front_a AND front_b THEN   
				udp_data.state := state := RetractPusher;
			END_IF; 
              
		RetractPusher: //   
			IF ton_retractPusher.Q THEN   
				udp_data.state := state := MoveToStraightBagOut;
			END_IF; 

		MoveToStraightBagOut:
			IF ton_straight.Q THEN
				udp_data.state := state := Releasing;
			END_IF;

		Releasing:
			IF after OR NOT(fire) THEN
				udp_data.state := state := Reset;
			END_IF;
	END_CASE;
	
	// Comm Logic
	udp_data.waiting := waiting := (
	udp_data.state = ReadyToRelease
	AND NOT(custom_send_lock)
	AND NOT(after)
	AND NOT(safety_zone)
	AND sort_exit_clear
	AND onoff
	);

	udp_data.bring_ok := bring_ok := (
	udp_data.state = ReadyToReceive
	AND ton_straight.Q
	AND NOT(front_a)
	AND NOT(front_b)
	AND NOT(going_to)
	AND NOT(custom_bring_lock)
	AND NOT(loading_position)
	AND sort_entry_clear
	AND onoff
	);

	//Don't arrive the bag until we are in the loading position and points are back straight.
	IF going_to AND (loading_position AND ton_straight.Q) THEN insert := TRUE; END_IF;

	// Input Control
	front := front_a OR front_b;
	arrive := arrive_raw;

	// Output Control
	stp_a := (
	((udp_data.state = ReadyToReceive) AND ton_straight.Q)
	OR ((udp_data.state = Loading) AND ton_straight.Q)
	OR ((udp_data.state = NearWeight) AND ton_straight.Q)
	OR ((udp_data.state = ReadyToRelease) AND ton_straight.Q)
	OR ((udp_data.state = ReleaseBagToLoading) AND ton_rotated.Q)
	OR ((udp_data.state = ReleaseBagToPoints) AND ton_rotated.Q)
	OR ((udp_data.state = Releasing) AND ton_straight.Q)
	OR ((udp_data.state = Reset) AND NOT onoff AND ton_straight.Q)
	);

	stp_b := (
	((udp_data.state = ReadyToReceive) AND ton_straight.Q)
	OR ((udp_data.state = Receiving) AND ton_straight.Q)
	OR ((udp_data.state = Loading) AND ton_straight.Q)
	OR ((udp_data.state = NearWeight) AND ton_straight.Q)
	OR ((udp_data.state = ReadyToRelease) AND ton_straight.Q)
	OR ((udp_data.state = ReleaseBagToLoading) AND ton_rotated.Q)
	OR ((udp_data.state = ReleaseBagToPoints) AND ton_rotated.Q)
	OR ((udp_data.state = Releasing) AND ton_straight.Q)
	OR ((udp_data.state = Reset) AND NOT onoff AND ton_straight.Q)
	);

	rotate := (
	(udp_data.state = MoveToRotateBagIn)
	OR (udp_data.state = ReleaseBagToLoading)
	OR (udp_data.state = MoveToRotateBagOut)
	OR (udp_data.state = ReleaseBagToPoints)
	OR (udp_data.state = RetractPusher)
	);

	switch := rotate;// AND NOT ton_rotated.Q;
	reset_switch  := NOT rotate;// AND NOT ton_straight.Q;
	foot := (udp_data.state = Loading);  

	pusher := (udp_data.state = ReleaseBagToPoints); // Pusher pushes the bag out.
	clamp := ((rotate AND NOT ton_rotated.Q) OR (NOT rotate AND NOT ton_straight.Q));  // We have to fire this to unlock the rails so we can move them

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

	ton_straight(IN:= sw_in_a AND sw_in_b, PT:= rotateTime);
	ton_rotated(IN:= sw_out_a AND sw_out_b, PT:= rotateTime);
	ton_settledOnPoints(IN:= front_a AND front_b, PT:= settleTime);
	ton_retractPusher(IN:=(udp_data.state = RetractPusher), PT:= retractTime); 

	// Weight Comm
	IF (udp_data.state = NearWeight) OR (udp_data.state = ReadyToRelease) OR (udp_data.state = Loading) OR (udp_data.state = OverWeight)THEN
		loadcell.capture_weight_bool := TRUE;
	ELSE
		loadcell.capture_weight_bool := FALSE;
	END_IF;
	
	NearWeightTimer(IN := (loadcell.near_weight), PT := NearWeightTime);
	FullWeightTimer(IN := (loadcell.full), PT := FullWeightTime);  
	
	// Input Control
	man_send := FALSE;
	IF man_send_button THEN
		man_send := TRUE;
	END_IF; 
	
	// Alarm Timers
	AlarmTimer(IN := fire, PT := (t#1s * rail_alarm_time));
	UnexpectedBagTimer(IN := (loading_position AND rail_mt), PT := UnexpectedBagTime);
	MissingBagTimer(IN := (NOT(loading_position) AND NOT(rail_mt)), PT := MissingBagTime);

	// Alarm Coms
	alarm := AlarmTimer.Q;
	warning_com.0 := UnexpectedBagTimer.Q;
	warning_com.1 := MissingBagTimer.Q;

	//Rail Messages
	messages.Write := 0;
	//BAG_STUCK # not yet implemented
	IF UnexpectedBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	IF MissingBagTimer.Q THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;

	// Always clear acknowledgements
	brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read)); 
	

END_FUNCTION_BLOCK