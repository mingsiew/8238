
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackLiftingStaticBag

	messages ACCESS p_messages;
	
	// Device State Machine
	IF reset THEN
		IF rail_mt THEN
			udp_data.state := state := ReadyToReceive;
		ELSE
			udp_data.state := state := Loaded;
		END_IF;
	END_IF;
	IF udp_data.state = 0 THEN udp_data.state := state := ReadyToReceive; END_IF;

	
	// Debounce ON
	DBNC_up_timer(IN := up_raw, PT := DBNC_up_time);
	up := DBNC_up_timer.Q;

	DBNC_down_timer(IN := down_raw, PT := DBNC_down_time);
	down := DBNC_down_timer.Q;
	
	CASE udp_data.state OF
		Closed:
			IF dischargerRailSlingReady AND input_enabled AND NOT(safety_zone) AND NOT(halted) THEN
				udp_data.state := state := PreparingToLift;
			END_IF;

		PreparingToLift:
			IF PreparingToLiftTimer.Q THEN udp_data.state := state := Lifting; END_IF;

		Lifting:
			IF up THEN udp_data.state := state := DoneLifting; END_IF;

		DoneLifting:
			IF DoneLiftingTimer.Q THEN udp_data.state := state := InReceivePosition; END_IF;

		InReceivePosition:
			IF input_enabled AND NOT(safety_zone) AND NOT(halted) THEN
				udp_data.state := state := ReadyToReceive;
			ELSIF NOT(input_enabled) THEN
				udp_data.state := state := PreparingToLower;
			END_IF;

		ReadyToReceive:
			IF man_send THEN
				udp_data.state := state := Receiving;
			ELSIF NOT(input_enabled) OR safety_zone OR halted THEN
				udp_data.state := state := InReceivePosition;
			END_IF;

		Receiving:
			IF ReceivingTimer.Q THEN udp_data.state := state := PreparingToLower; END_IF;

		PreparingToLower:
			IF PreparingToLowerTimer.Q THEN udp_data.state := state := Lowering; END_IF;

		Lowering:
			IF down THEN udp_data.state := state := DoneLowering; END_IF;

		DoneLowering:
			IF DoneLoweringTimer.Q THEN
				IF rail_mt THEN
					udp_data.state := state := Closed;
				ELSE
					udp_data.state := state := Loaded;
				END_IF;
			END_IF;

		Loaded:
			IF NOT(halted) AND NOT(safety_zone) AND NOT(stopped) THEN
				udp_data.state := state := ReadyToTransfer;
			END_IF;

		ReadyToTransfer:
			IF open_signal OR man_open OR open_pendant THEN
				delete_latch := TRUE;
				udp_data.state := state := Unclamping;
			ELSIF halted OR stopped OR safety_zone THEN
				udp_data.state := state := Loaded;
			END_IF;

		Unclamping:
			IF UnclampingTimer.Q THEN udp_data.state := state := Opening; END_IF;

		Opening:
			IF static_open THEN udp_data.state := state := Transferring; END_IF;

		Transferring:
			IF man_send THEN udp_data.state := state := Closing; END_IF;

		Closing:
			IF static_close THEN udp_data.state := state := Closed; END_IF;

	END_CASE;
	

	clamp := udp_data.state = Unclamping OR udp_data.state = Opening OR udp_data.state = Transferring OR udp_data.state = Closing;
	open := udp_data.state = Opening;
	close := udp_data.state = Closing;

	lift_clamp := (
	udp_data.state = PreparingToLift
	OR udp_data.state = Lifting
	OR udp_data.state = PreparingToLower
	OR udp_data.state = Lowering
	);

	fire_up := (
	udp_data.state = Lifting
	OR udp_data.state = InReceivePosition
	OR udp_data.state = ReadyToReceive
	OR udp_data.state = Receiving
	OR udp_data.state = PreparingToLower
	);

	fire_down := NOT(fire_up);

	// Control Timers
	ReceivingTimer(IN := (udp_data.state = Receiving), PT := ReceivingTime);
	PreparingToLiftTimer(IN := (udp_data.state = PreparingToLift), PT := PreparingToLiftTime);
	PreparingToLowerTimer(IN := (udp_data.state = PreparingToLower), PT := PreparingToLowerTime);
	UnclampingTimer(IN := (udp_data.state = Unclamping), PT := UnclampingTime);
	DoneLiftingTimer(IN := udp_data.state = DoneLifting, PT := DoneLiftingTime);
	DoneLoweringTimer(IN := udp_data.state = DoneLowering, PT := DoneLoweringTime);
	
	// Comm Logic
	bring_ok := udp_data.state = Closing OR udp_data.state = Closed;
	waiting := FALSE;
	man_open := man_send := FALSE;
	sling_ready := udp_data.state = ReadyToTransfer;
	dischargerRailReceiveSignal := udp_data.state = DoneLowering;

	IF rail_mt THEN delete_latch := FALSE; END_IF;

	udp_data.alarm := alarm := FALSE;
	udp_data.warning_com.0 := warning_com.0 := FALSE;
	udp_data.warning_com.1 := warning_com.1 := FALSE;
	udp_data.warning_com.12 := warning_com.12 := delete_latch;
	udp_data.warning_com.14 := warning_com.14 := sling_ready;

	//messages.Write := 0;
	//IF UnexpectedBagTimer.Q   THEN messages.Write := BIT_SET(messages.Write,UNEXPECTED_BAG); END_IF;
	//IF MissingBagTimer.Q      THEN messages.Write := BIT_SET(messages.Write,MISSING_BAG); END_IF;

	// Always clear acknowledgements    
	//brsmemset(ADR(messages.Read[0]),0,SIZEOF(messages.Read));  

END_FUNCTION_BLOCK