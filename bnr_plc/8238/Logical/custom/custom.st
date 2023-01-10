PROGRAM _INIT
	
	Std.TestMode;

//	FOR n := 1 TO MAX_CONTACTRON DO
//		incline						ACCESS ADR(IO_Link.Contactron[n]);
//		incline.Cmd.Reset_Automatic		:= 1;	
//		tripCurrent						:= CONTACTRON_TRIP_50_PERCENT;
//		//tripCurrent						:= CONTACTRON_TRIP_75_PERCENT;
//	END_FOR;
//	
//	camera ACCESS ADR(Camera[1].Interface);	
//	
//	gSettings.Drive[1].MotorSize	 			:= ABB_MOTOR_0_75KW;
//	gSettings.Drive[2].MotorSize	 			:= ABB_MOTOR_0_75KW;
//	gSettings.Drive[3].MotorSize	 			:= ABB_MOTOR_3KW;
//	gSettings.Drive[4].MotorSize	 			:= ABB_MOTOR_3KW;
////	gSettings.Drive[3].MotorSize	 			:= ABB_MOTOR_CUSTOM; //from motor template
//	
//	FOR n := 1 TO MAX_DRIVES DO		
//		ABB_EPL.Drives[n].Cmd.Direction 		:= ABB_DIRECTION_FWD;
//		ABB_EPL.Drives[n].Cmd.TargetVelocity 	:= gSettings.Drive[n].TargetVelocity;
//		gSettings.Drive[n].AccTime 				:= 0.5;
//		gSettings.Drive[n].DecTime 				:= 0.2;
//		gSettings.Drive[n].BrakeFitted			:= 0;
//	END_FOR;


	
END_PROGRAM


PROGRAM _CYCLIC


//	//==============================
//	//Inclines
//	//==============================
//	
//	FOR n := 1 TO MAX_CONTACTRON DO
//		incline					ACCESS ADR(IO_Link.Contactron[n]);
//		IF 	(incline.Comms.Read.CurrentStatus = 0) THEN
//			incline.Cmd.Current		:= tripCurrent;	
//		END_IF;
//	END_FOR;
//	
//	IO_Link.Contactron[1].Cmd.Run := r57.run_slant; //SICU1		//Y[1399].Y06
//	IO_Link.Contactron[2].Cmd.Run := r116.run_slant; //CICU1
//	IO_Link.Contactron[3].Cmd.Run := r101.run_slant; //CICU2
//	IO_Link.Contactron[4].Cmd.Run := r127.run_slant; //CICU3
////	IO_Link.Contactron[2].Cmd.Run := r21.run_slant; //CICU4
//
//	//====================================
//	//TRN Controls
//	//====================================		
//	
//	//STRN2
//	r62.request_rotate := (r25.state = 1) AND (OpcUa.VC[232].Read.PositionNo = 2) AND (OpcUa.VC[232].Read.Auto) AND (OpcUa.VC[232].Read.ReadyToReceive) AND NOT r25.safety_zone; 
//	ton_rotated_strn2(IN:= (r62.sw_out_a AND r62.sw_out_b),PT := T#2s);
//	ton_straight_strn2(IN:= (r62.sw_in_a AND r62.sw_in_b),PT := T#2s);
//	r62.custom_bring_lock := ton_rotated_strn2.Q OR r62.front_a OR r62.front_b OR NOT r62.rail_mt; 
//	rotate_r62 := ((r62.state >= 6) AND (r62.state <= 7)) OR (r62.state = 9);
//	straight_r62 := ((r62.state = 8) OR (r62.state = 1) OR (r62.state = 5));
//	r62.clamp := (rotate_r62 AND NOT ton_rotated_strn2.Q) OR (straight_r62 AND NOT ton_straight_strn2.Q);  // We have to fire this to unlock the rails so we can move them
//	
//	r25.custom_bring_lock := NOT ton_rotated_strn2.Q;
//	//r63.custom_bring_lock := NOT ton_straight_strn2.Q;
//	
//	//STRN1
//	r63.request_rotate := NOT r22.safety_zone; 
//	ton_rotated_strn1(IN:= (r63.sw_out_a AND r63.sw_out_b),PT := T#2s);
//	ton_straight_strn1(IN:= (r63.sw_in_a AND r63.sw_in_b),PT := T#2s);
//	r63.custom_bring_lock := ton_rotated_strn2.Q OR r63.front_a OR r63.front_b OR NOT r63.rail_mt OR NOT ton_straight_strn2.Q; 
//	rotate_r63 := ((r63.state >= 6) AND (r63.state <= 7)) OR (r63.state = 9);
//	straight_r63 := ((r63.state = 8) OR (r63.state = 1) OR (r63.state = 5));
//	r63.clamp := (rotate_r63 AND NOT ton_rotated_strn1.Q) OR (straight_r63 AND NOT ton_straight_strn1.Q);  // We have to fire this to unlock the rails so we can move them
//	
//	r22.custom_bring_lock := NOT ton_rotated_strn1.Q;
//	
//	
//	//CTRN1
//	r135.request_rotate := (r65.state = 1) AND (OpcUa.VC[241].Read.PositionNo = 2) AND (OpcUa.VC[241].Read.Auto) AND (OpcUa.VC[241].Read.ReadyToReceive);
//	ton_rotated_ctrn1(IN:= (r135.sw_out_a AND r135.sw_out_b), PT := T#2s);
//	ton_straight_ctrn1(IN:= (r135.sw_in_a AND r135.sw_in_b), PT := T#2s);
//	r135.custom_bring_lock := ton_rotated_ctrn1.Q OR r135.front_a OR r135.front_b OR NOT r135.rail_mt; 
//	rotate_r135 := ((r135.state >= 6) AND (r135.state <= 7)) OR (r135.state = 9);
//	straight_r135 := ((r135.state = 8) OR (r135.state = 1) OR (r135.state = 5));
//	r135.clamp := (rotate_r135 AND NOT ton_rotated_ctrn1.Q) OR (straight_r135 AND NOT ton_straight_ctrn1.Q);  // We have to fire this to unlock the rails so we can move them
//	
//	//CTRN2
//	r133.request_rotate := (r68.state = 1) AND (OpcUa.VC[242].Read.PositionNo = 2) AND (OpcUa.VC[242].Read.Auto) AND (OpcUa.VC[242].Read.ReadyToReceive);
//	ton_rotated_ctrn2(IN:= (r133.sw_out_a AND r133.sw_out_b), PT := T#2s);
//	ton_straight_ctrn2(IN:= (r133.sw_in_a AND r133.sw_in_b), PT := T#2s);
//	r133.custom_bring_lock := ton_rotated_ctrn2.Q OR r133.front_a OR r133.front_b OR NOT r133.rail_mt;
//	rotate_r133 := ((r133.state >= 6) AND (r133.state <= 7)) OR (r133.state = 9);
//	straight_r133 := ((r133.state = 8) OR (r133.state = 1) OR (r133.state = 5));
//	r133.clamp := (rotate_r133 AND NOT ton_rotated_ctrn2.Q) OR (straight_r133 AND NOT ton_straight_ctrn2.Q);  // We have to fire this to unlock the rails so we can move them
//	
//	
////	//====================================
////	//TRF Controls
////	//====================================	
////	
////	ton_clear_strf1(IN:= (NOT r22.front_a AND NOT r22.front_b),PT := T#2s);
////	ton_clear_strf2(IN:= (NOT r25.front_a AND NOT r25.front_b),PT := T#2s);
////	
////	r63.custom_send_lock	:=	NOT ton_clear_strf1.Q AND (r22.state >= 5);
////	r62.custom_send_lock	:=	NOT ton_clear_strf2.Q AND (r25.state >= 5);
//
////==============================
////Custom for CDC6 & CDC7
////==============================	
//	RequestBag 		:= WORD_TO_INT(plc_info1);
//	IF RequestBag = 7 THEN
//		cdc7RequestBag := TRUE;
//		cdc6RequestBag := FALSE;
//	ELSIF RequestBag = 6 THEN
//		cdc6RequestBag := TRUE;
//		cdc7RequestBag := FALSE;
//	ELSE
//		cdc6RequestBag := FALSE;
//		cdc7RequestBag := FALSE;
//	END_IF;
//	
//	r104.lift_stp := r106.going_to;
//		
//	// Clean custom code
//	r104.custom_bring_lock := cdc7RequestBag OR r106.going_to;
//	r106.custom_bring_lock := r104.going_to OR r104.front_raw OR NOT r104.rail_mt OR r104.fire;
//	
//	r104.going_to;
//	r106.going_to;
//	r103.custom_send_lock;
////==============================
////Sorting Stations Mapping
////==============================
//
////	r41.jogmode := 1;	//set belt pulse mode = TRUE
////	r42.jogmode := 1;
////	r43.jogmode := 1;
////	r44.jogmode := 1;
////	r45.jogmode := 1;
////	r46.jogmode := 1;
////	r47.jogmode := 1;
////	r48.jogmode := 1;
////	r49.jogmode := 1;
////	r50.jogmode := 1;
//
//	//	IO_Link.Contactron[2].Cmd.Run := r41.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[3].Cmd.Run := r42.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[4].Cmd.Run := r43.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[5].Cmd.Run := r44.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[6].Cmd.Run := r45.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[7].Cmd.Run := r46.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[8].Cmd.Run := r47.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[9].Cmd.Run := r48.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[10].Cmd.Run := r49.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	IO_Link.Contactron[11].Cmd.Run := r50.run_conveyor AND (r40.conveyor_running OR (r40.run_conveyor AND Std.TestMode));
//	//	
//	r1.custom_send_lock := r1.over_weight;
//	r2.custom_send_lock := r2.over_weight;
//	r3.custom_send_lock := r3.over_weight;
//	r4.custom_send_lock := r4.over_weight;
//	r5.custom_send_lock := r5.over_weight;
//	r6.custom_send_lock := r6.over_weight;
//	r7.custom_send_lock := r7.over_weight;
//	r8.custom_send_lock := r8.over_weight;
//	r9.custom_send_lock := r9.over_weight;
//	r10.custom_send_lock := r10.over_weight;
//	r11.custom_send_lock := r11.over_weight;
//	r12.custom_send_lock := r12.over_weight;
//	r13.custom_send_lock := r13.over_weight;
//	r14.custom_send_lock := r14.over_weight;
//	r15.custom_send_lock := r15.over_weight;
//	r16.custom_send_lock := r16.over_weight;
//	r17.custom_send_lock := r17.over_weight;
//	r18.custom_send_lock := r18.over_weight;
//	r19.custom_send_lock := r19.over_weight;
//	r20.custom_send_lock := r20.over_weight;
//		
//	//==============================
//	//Speed Reducers
//	//==============================
//	
//	////////////////////////SSR1 is a brush style//////////////////////////
//	
//	//inputs
//	i_bagApproach[1] := ssr1_prs; //ssr1 on soiled system
//	//i_bagApproach[2] := ssr2_prs; //ssr2 on soiled system
//	//i_bagApproach[3] := csr1_prs; //csr1 on clean system
//	
//	FOR n := 1 TO MAX_SPEED_REDUCERS DO
//		
//		ctu_tripCount[n](CU := i_bagApproach[n],PV := 2,RESET := ton_10ms_openBrush[n].Q);
//		ton_10ms_openBrush[n](IN := NOT SafetyZone[1].HaltSys AND o_closeBrush[n], PT := 300);
//	
//		IF (ctu_tripCount[n].CV >= 2) THEN
//			o_closeBrush[n] := TRUE;
//		END_IF;
//	
//		IF ton_10ms_openBrush[n].Q THEN
//			o_closeBrush[n] := FALSE;
//		END_IF;
//	END_FOR;
//	
//	//Outputs
//	ssr1_close := o_closeBrush[1];
////	ssr2_close := o_closeBrush[2];
////	csr1_close := o_closeBrush[3];
//	
//
//	
//	//==============================
//	//ABB DRIVES       
//	//==============================
//	
//	FOR n := 1 TO MAX_DRIVES DO
//		ABB_EPL.Drives[n].Cmd.TargetVelocity := gSettings.Drive[n].TargetVelocity;
//	END_FOR;
//	
//	ABB_EPL.Drives[1].Cmd.QuickStop := NOT SafetyZone[1].HaltSys; //SB1
//	ABB_EPL.Drives[2].Cmd.QuickStop := NOT SafetyZone[1].HaltSys; //SB2
//	ABB_EPL.Drives[3].Cmd.QuickStop := NOT SafetyZone[4].HaltSys; //STB1
//	ABB_EPL.Drives[4].Cmd.QuickStop := NOT SafetyZone[5].HaltSys; //STB2
//
////	tof_largeload(IN := X[1351].X06, PT:=t#10s);
////	IF tof_largeload.Q THEN
////		ABB_EPL.Drives[2].Cmd.TargetVelocity := gSettings.Drive[2].TargetVelocity/2;
////		//testspeed := gSettings.Drive[2].TargetVelocity/2;
////	ELSE
////		ABB_EPL.Drives[2].Cmd.TargetVelocity := gSettings.Drive[2].TargetVelocity;
////		//testspeed := gSettings.Drive[2].TargetVelocity;
////	END_IF;
//
//	//==============================
//	//SB1 & SB2 - PB control
//	//==============================
//	IF EDGENEG (sb1_start) THEN
//		runBelts_SB1 := 1;
//	END_IF;
//	IF NOT sb1_stop OR SafetyZone[1].HaltSys THEN
//		runBelts_SB1 := 0;
//	END_IF;
//	
//	IF EDGENEG (sb2_start) THEN
//		runBelts_SB2 := 1;
//	END_IF;
//	IF NOT sb2_stop OR SafetyZone[1].HaltSys THEN
//		runBelts_SB2 := 0;
//	END_IF;
//	
//	sb1_lamp := runBelts_SB1;
//	sb2_lamp := runBelts_SB2;
//	
//	ABB_EPL.Drives[1].Cmd.Run := (runBelts_SB1) AND sb1_endPX;
//	ABB_EPL.Drives[2].Cmd.Run := (runBelts_SB2) AND sb2_endPX;
//	ABB_EPL.Drives[3].Cmd.Run := r21.run_conveyor;
//	r21.conveyor_running := ABB_EPL.Drives[3].Status.Running OR r21.run_conveyor;
//	ABB_EPL.Drives[4].Cmd.Run := r24.run_conveyor;
//	r24.conveyor_running := ABB_EPL.Drives[4].Status.Running OR r24.run_conveyor;
//		
//
//	//==============================
//	//UI Indicators - in iolist
//	//==============================	
//	
//
//	
//	//==============================
//	//Timers
//	//==============================
//	
//	SetValueByName('R043','DBNC_after_time',50);
//	SetValueByName('R045','DBNC_after_time',50);
//	SetValueByName('R047','DBNC_after_time',50);
//	SetValueByName('R092','DBNC_after_time',50);
////	SetValueByName('R047','DBNC_after_time',50);
////	SetValueByName('R047','DBNC_after_time',50);
//	//	SetValueByName('R042','PulseTimerOffTime',1000);
////	//SetValueByName('R043','PulseTimerOnTime',3000);
////	SetValueByName('R043','PulseTimerOffTime',1000);
////	//SetValueByName('R044','PulseTimerOnTime',3000);
////	SetValueByName('R044','PulseTimerOffTime',1000);
////	//SetValueByName('R045','PulseTimerOnTime',3000);
////	SetValueByName('R045','PulseTimerOffTime',1000);
////	//SetValueByName('R046','PulseTimerOnTime',3000);
////	SetValueByName('R046','PulseTimerOffTime',1000);
////	//SetValueByName('R047','PulseTimerOnTime',3000);
////	SetValueByName('R047','PulseTimerOffTime',1000);
////	//SetValueByName('R048','PulseTimerOnTime',3000);
////	SetValueByName('R048','PulseTimerOffTime',1000);
////	//SetValueByName('R049','PulseTimerOnTime',3000);
////	SetValueByName('R049','PulseTimerOffTime',1000);
////	//SetValueByName('R050','PulseTimerOnTime',3000);
////	SetValueByName('R050','PulseTimerOffTime',1000);
////	//SetValueByName('R041','PulseTimerOnTime',3000);
////	//SetValueByName('R041','PulseTimerOffTime',5000);
////	//SetValueByName('R040','MaximumRunningTime',200000);
////	//	SetValueByName('R041','DBNC_front_time',2000);
////	//	SetValueByName('R076','DBNC_front_time',1000);
////	//	
////	
////	// Camera
////	camera.Read := r31.front; 	
////	IF camera.ResultReady AND r31.front THEN
////		brsmemcpy(ADR(barcode1),ADR(camera.Result),SIZEOF(barcode1));
////	ELSE
////		brsmemset(ADR(barcode1),0,SIZEOF(barcode1));
////	END_IF;
////	
////	IF EDGEPOS(camera.Read) THEN
////		readCount := readCount + 1;
////	END_IF;
////		
////
////	//	
////	tof_cameraClean(IN := (readCount > 100), PT:=t#2s);  
////	r31.puncher := NOT tof_cameraClean.Q;
////	
////	IF (readCount > 105) THEN
////		readCount := 0;
////	END_IF;
	
END_PROGRAM