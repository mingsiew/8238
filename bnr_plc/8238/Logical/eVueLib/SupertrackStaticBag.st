
(* TODO: Add your comment here *)
FUNCTION_BLOCK SupertrackStaticBag

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

	CASE udp_data.state OF
		Closed:
			IF input_enabled AND NOT(safety_zone) AND NOT(halted) THEN
				udp_data.state := state := ReadyToReceive;
			END_IF;

		ReadyToReceive:
			IF man_send THEN
				udp_data.state := state := Receiving;
			ELSIF NOT(input_enabled) OR safety_zone OR halted THEN
				udp_data.state := state := Closed;
			ELSIF NOT(rail_mt) THEN
				udp_data.state := state := Loaded;
			END_IF;

		Receiving:
			IF ReceivingTimer.Q THEN udp_data.state := state := Clamping; END_IF;

		Clamping:
			IF ClampingTimer.Q THEN udp_data.state := state := Loaded; END_IF;

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
			ELSIF rail_mt THEN
				udp_data.state := state := Closed;
			END_IF;

		Unclamping:
			IF UnclampingTimer.Q THEN udp_data.state := state := Transferring; END_IF;

		Transferring:
			IF man_send THEN udp_data.state := state := Closing; END_IF;

		Closing:
			IF ClosingTimer.Q AND NOT(delete_latch) THEN udp_data.state := state := ReadyToReceive; END_IF;

	END_CASE;	

	// Output Control
	clamp := (
	udp_data.state = Unclamping
	OR udp_data.state = Transferring
	OR udp_data.state = Closing
	OR udp_data.state = Closed
	OR udp_data.state = ReadyToReceive
	OR udp_data.state = Receiving
	);

	open := udp_data.state = Transferring;

	// Control Timers
	ReceivingTimer(IN := (udp_data.state = Receiving), PT := ReceivingTime);
	ClampingTimer(IN := (udp_data.state = Clamping), PT := ClampingTime);
	UnclampingTimer(IN := (udp_data.state = Unclamping), PT := UnclampingTime);
	ClosingTimer(IN := (udp_data.state = Closing), PT := ClosingTime);

	// Comm Logic
	bring_ok := udp_data.state = Closing OR udp_data.state = Closed OR udp_data.state = ReadyToReceive;
	waiting := FALSE;
	man_open := man_send := FALSE;
	sling_ready := udp_data.state = ReadyToTransfer;
	dischargerRailReceiveSignal := udp_data.state = Clamping;

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