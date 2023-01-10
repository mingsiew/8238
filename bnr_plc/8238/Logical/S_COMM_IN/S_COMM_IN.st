(********************************************************************
 * Program: server_comm_in
 * File: server_comm_in.st
 ********************************************************************)
PROGRAM _CYCLIC
(***	INSERT RESETS	***)
r1.insert_reset 	:=	insert_reset_1.0;
r2.insert_reset 	:=	insert_reset_1.1;
r3.insert_reset 	:=	insert_reset_1.2;
r4.insert_reset 	:=	insert_reset_1.3;
r5.insert_reset 	:=	insert_reset_1.4;
r6.insert_reset 	:=	insert_reset_1.5;
r7.insert_reset 	:=	insert_reset_1.6;
r8.insert_reset 	:=	insert_reset_1.7;
r9.insert_reset 	:=	insert_reset_1.8;
r10.insert_reset	:=	insert_reset_1.9;
r11.insert_reset	:=	insert_reset_1.10;
r12.insert_reset	:=	insert_reset_1.11;
r13.insert_reset	:=	insert_reset_1.12;
r14.insert_reset	:=	insert_reset_1.13;
r15.insert_reset	:=	insert_reset_1.14;
r16.insert_reset	:=	insert_reset_1.15;
r17.insert_reset	:=	insert_reset_2.0;
r18.insert_reset	:=	insert_reset_2.1;
r19.insert_reset	:=	insert_reset_2.2;
r20.insert_reset	:=	insert_reset_2.3;
r21.insert_reset	:=	insert_reset_2.4;
r22.insert_reset	:=	insert_reset_2.5;
r23.insert_reset	:=	insert_reset_2.6;
r24.insert_reset	:=	insert_reset_2.7;
r25.insert_reset	:=	insert_reset_2.8;
r26.insert_reset	:=	insert_reset_2.9;
r27.insert_reset	:=	insert_reset_2.10;
r28.insert_reset	:=	insert_reset_2.11;
r29.insert_reset	:=	insert_reset_2.12;
r30.insert_reset	:=	insert_reset_2.13;
r31.insert_reset	:=	insert_reset_2.14;
r32.insert_reset	:=	insert_reset_2.15;
r33.insert_reset	:=	insert_reset_3.0;
r34.insert_reset	:=	insert_reset_3.1;
r35.insert_reset	:=	insert_reset_3.2;
r36.insert_reset	:=	insert_reset_3.3;
r37.insert_reset	:=	insert_reset_3.4;
r38.insert_reset	:=	insert_reset_3.5;
r39.insert_reset	:=	insert_reset_3.6;
r40.insert_reset	:=	insert_reset_3.7;
r41.insert_reset	:=	insert_reset_3.8;
r42.insert_reset	:=	insert_reset_3.9;
r43.insert_reset	:=	insert_reset_3.10;
r44.insert_reset	:=	insert_reset_3.11;
r45.insert_reset	:=	insert_reset_3.12;
r46.insert_reset	:=	insert_reset_3.13;
r47.insert_reset	:=	insert_reset_3.14;
r48.insert_reset	:=	insert_reset_3.15;
r49.insert_reset	:=	insert_reset_4.0;
r50.insert_reset	:=	insert_reset_4.1;
r51.insert_reset	:=	insert_reset_4.2;
r52.insert_reset	:=	insert_reset_4.3;
r53.insert_reset	:=	insert_reset_4.4;
r54.insert_reset	:=	insert_reset_4.5;
r55.insert_reset	:=	insert_reset_4.6;
r56.insert_reset	:=	insert_reset_4.7;
r57.insert_reset	:=	insert_reset_4.8;
r58.insert_reset	:=	insert_reset_4.9;
r59.insert_reset	:=	insert_reset_4.10;
r60.insert_reset	:=	insert_reset_4.11;
r61.insert_reset	:=	insert_reset_4.12;
r62.insert_reset	:=	insert_reset_4.13;
r63.insert_reset	:=	insert_reset_4.14;
r64.insert_reset	:=	insert_reset_4.15;
r65.insert_reset	:=	insert_reset_5.0;
r66.insert_reset	:=	insert_reset_5.1;
r67.insert_reset	:=	insert_reset_5.2;
r68.insert_reset	:=	insert_reset_5.3;
r69.insert_reset	:=	insert_reset_5.4;
r70.insert_reset	:=	insert_reset_5.5;
r71.insert_reset	:=	insert_reset_5.6;
r72.insert_reset	:=	insert_reset_5.7;
r73.insert_reset	:=	insert_reset_5.8;
r74.insert_reset	:=	insert_reset_5.9;

insert_reset_1	:=	0;
insert_reset_2	:=	0;
insert_reset_3	:=	0;
insert_reset_4	:=	0;
insert_reset_5	:=	0;


(***	SIGNALS	***)
IF rail_signal_1.0 THEN rail_signal_1.0 := 0; r1.man_open := 0; r1.man_send := 0; r1.ok_to_send := 0; r1.insert := 0; r1.reset := 1; ELSE r1.reset := 0; END_IF;
IF rail_signal_1.1 THEN rail_signal_1.1 := 0; r1.man_open := 1; END_IF;
IF rail_signal_1.2 THEN rail_signal_1.2 := 0; r1.man_send := 1; END_IF;
IF rail_signal_1.3 THEN rail_signal_1.3 := 0; r1.ok_to_send := 1; END_IF;
IF rail_signal_1.4 THEN rail_signal_1.4 := 0; r1.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_1.5 THEN rail_signal_1.5 := 0; r1.cc_open_bottom_os := 1; END_IF;
IF rail_signal_1.6 THEN rail_signal_1.6 := 0; r1.cc_shut_top_os := 1; END_IF;
IF rail_signal_1.7 THEN rail_signal_1.7 := 0; r1.cc_open_top_os := 1; END_IF;
IF rail_signal_1.8 THEN rail_signal_1.8 := 0; r1.purge := 1; END_IF;


IF rail_signal_2.0 THEN rail_signal_2.0 := 0; r2.man_open := 0; r2.man_send := 0; r2.ok_to_send := 0; r2.insert := 0; r2.reset := 1; ELSE r2.reset := 0; END_IF;
IF rail_signal_2.1 THEN rail_signal_2.1 := 0; r2.man_open := 1; END_IF;
IF rail_signal_2.2 THEN rail_signal_2.2 := 0; r2.man_send := 1; END_IF;
IF rail_signal_2.3 THEN rail_signal_2.3 := 0; r2.ok_to_send := 1; END_IF;
IF rail_signal_2.4 THEN rail_signal_2.4 := 0; r2.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_2.5 THEN rail_signal_2.5 := 0; r2.cc_open_bottom_os := 1; END_IF;
IF rail_signal_2.6 THEN rail_signal_2.6 := 0; r2.cc_shut_top_os := 1; END_IF;
IF rail_signal_2.7 THEN rail_signal_2.7 := 0; r2.cc_open_top_os := 1; END_IF;
IF rail_signal_2.8 THEN rail_signal_2.8 := 0; r2.purge := 1; END_IF;


IF rail_signal_3.0 THEN rail_signal_3.0 := 0; r3.man_open := 0; r3.man_send := 0; r3.ok_to_send := 0; r3.insert := 0; r3.reset := 1; ELSE r3.reset := 0; END_IF;
IF rail_signal_3.1 THEN rail_signal_3.1 := 0; r3.man_open := 1; END_IF;
IF rail_signal_3.2 THEN rail_signal_3.2 := 0; r3.man_send := 1; END_IF;
IF rail_signal_3.3 THEN rail_signal_3.3 := 0; r3.ok_to_send := 1; END_IF;
IF rail_signal_3.4 THEN rail_signal_3.4 := 0; r3.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_3.5 THEN rail_signal_3.5 := 0; r3.cc_open_bottom_os := 1; END_IF;
IF rail_signal_3.6 THEN rail_signal_3.6 := 0; r3.cc_shut_top_os := 1; END_IF;
IF rail_signal_3.7 THEN rail_signal_3.7 := 0; r3.cc_open_top_os := 1; END_IF;
IF rail_signal_3.8 THEN rail_signal_3.8 := 0; r3.purge := 1; END_IF;


IF rail_signal_4.0 THEN rail_signal_4.0 := 0; r4.man_open := 0; r4.man_send := 0; r4.ok_to_send := 0; r4.insert := 0; r4.reset := 1; ELSE r4.reset := 0; END_IF;
IF rail_signal_4.1 THEN rail_signal_4.1 := 0; r4.man_open := 1; END_IF;
IF rail_signal_4.2 THEN rail_signal_4.2 := 0; r4.man_send := 1; END_IF;
IF rail_signal_4.3 THEN rail_signal_4.3 := 0; r4.ok_to_send := 1; END_IF;
IF rail_signal_4.4 THEN rail_signal_4.4 := 0; r4.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_4.5 THEN rail_signal_4.5 := 0; r4.cc_open_bottom_os := 1; END_IF;
IF rail_signal_4.6 THEN rail_signal_4.6 := 0; r4.cc_shut_top_os := 1; END_IF;
IF rail_signal_4.7 THEN rail_signal_4.7 := 0; r4.cc_open_top_os := 1; END_IF;
IF rail_signal_4.8 THEN rail_signal_4.8 := 0; r4.purge := 1; END_IF;


IF rail_signal_5.0 THEN rail_signal_5.0 := 0; r5.man_open := 0; r5.man_send := 0; r5.ok_to_send := 0; r5.insert := 0; r5.reset := 1; ELSE r5.reset := 0; END_IF;
IF rail_signal_5.1 THEN rail_signal_5.1 := 0; r5.man_open := 1; END_IF;
IF rail_signal_5.2 THEN rail_signal_5.2 := 0; r5.man_send := 1; END_IF;
IF rail_signal_5.3 THEN rail_signal_5.3 := 0; r5.ok_to_send := 1; END_IF;
IF rail_signal_5.4 THEN rail_signal_5.4 := 0; r5.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_5.5 THEN rail_signal_5.5 := 0; r5.cc_open_bottom_os := 1; END_IF;
IF rail_signal_5.6 THEN rail_signal_5.6 := 0; r5.cc_shut_top_os := 1; END_IF;
IF rail_signal_5.7 THEN rail_signal_5.7 := 0; r5.cc_open_top_os := 1; END_IF;
IF rail_signal_5.8 THEN rail_signal_5.8 := 0; r5.purge := 1; END_IF;


IF rail_signal_6.0 THEN rail_signal_6.0 := 0; r6.man_open := 0; r6.man_send := 0; r6.ok_to_send := 0; r6.insert := 0; r6.reset := 1; ELSE r6.reset := 0; END_IF;
IF rail_signal_6.1 THEN rail_signal_6.1 := 0; r6.man_open := 1; END_IF;
IF rail_signal_6.2 THEN rail_signal_6.2 := 0; r6.man_send := 1; END_IF;
IF rail_signal_6.3 THEN rail_signal_6.3 := 0; r6.ok_to_send := 1; END_IF;
IF rail_signal_6.4 THEN rail_signal_6.4 := 0; r6.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_6.5 THEN rail_signal_6.5 := 0; r6.cc_open_bottom_os := 1; END_IF;
IF rail_signal_6.6 THEN rail_signal_6.6 := 0; r6.cc_shut_top_os := 1; END_IF;
IF rail_signal_6.7 THEN rail_signal_6.7 := 0; r6.cc_open_top_os := 1; END_IF;
IF rail_signal_6.8 THEN rail_signal_6.8 := 0; r6.purge := 1; END_IF;


IF rail_signal_7.0 THEN rail_signal_7.0 := 0; r7.man_open := 0; r7.man_send := 0; r7.ok_to_send := 0; r7.insert := 0; r7.reset := 1; ELSE r7.reset := 0; END_IF;
IF rail_signal_7.1 THEN rail_signal_7.1 := 0; r7.man_open := 1; END_IF;
IF rail_signal_7.2 THEN rail_signal_7.2 := 0; r7.man_send := 1; END_IF;
IF rail_signal_7.3 THEN rail_signal_7.3 := 0; r7.ok_to_send := 1; END_IF;
IF rail_signal_7.4 THEN rail_signal_7.4 := 0; r7.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_7.5 THEN rail_signal_7.5 := 0; r7.cc_open_bottom_os := 1; END_IF;
IF rail_signal_7.6 THEN rail_signal_7.6 := 0; r7.cc_shut_top_os := 1; END_IF;
IF rail_signal_7.7 THEN rail_signal_7.7 := 0; r7.cc_open_top_os := 1; END_IF;
IF rail_signal_7.8 THEN rail_signal_7.8 := 0; r7.purge := 1; END_IF;


IF rail_signal_8.0 THEN rail_signal_8.0 := 0; r8.man_open := 0; r8.man_send := 0; r8.ok_to_send := 0; r8.insert := 0; r8.reset := 1; ELSE r8.reset := 0; END_IF;
IF rail_signal_8.1 THEN rail_signal_8.1 := 0; r8.man_open := 1; END_IF;
IF rail_signal_8.2 THEN rail_signal_8.2 := 0; r8.man_send := 1; END_IF;
IF rail_signal_8.3 THEN rail_signal_8.3 := 0; r8.ok_to_send := 1; END_IF;
IF rail_signal_8.4 THEN rail_signal_8.4 := 0; r8.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_8.5 THEN rail_signal_8.5 := 0; r8.cc_open_bottom_os := 1; END_IF;
IF rail_signal_8.6 THEN rail_signal_8.6 := 0; r8.cc_shut_top_os := 1; END_IF;
IF rail_signal_8.7 THEN rail_signal_8.7 := 0; r8.cc_open_top_os := 1; END_IF;
IF rail_signal_8.8 THEN rail_signal_8.8 := 0; r8.purge := 1; END_IF;


IF rail_signal_9.0 THEN rail_signal_9.0 := 0; r9.man_open := 0; r9.man_send := 0; r9.ok_to_send := 0; r9.insert := 0; r9.reset := 1; ELSE r9.reset := 0; END_IF;
IF rail_signal_9.1 THEN rail_signal_9.1 := 0; r9.man_open := 1; END_IF;
IF rail_signal_9.2 THEN rail_signal_9.2 := 0; r9.man_send := 1; END_IF;
IF rail_signal_9.3 THEN rail_signal_9.3 := 0; r9.ok_to_send := 1; END_IF;
IF rail_signal_9.4 THEN rail_signal_9.4 := 0; r9.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_9.5 THEN rail_signal_9.5 := 0; r9.cc_open_bottom_os := 1; END_IF;
IF rail_signal_9.6 THEN rail_signal_9.6 := 0; r9.cc_shut_top_os := 1; END_IF;
IF rail_signal_9.7 THEN rail_signal_9.7 := 0; r9.cc_open_top_os := 1; END_IF;
IF rail_signal_9.8 THEN rail_signal_9.8 := 0; r9.purge := 1; END_IF;


IF rail_signal_10.0 THEN rail_signal_10.0 := 0; r10.man_open := 0; r10.man_send := 0; r10.ok_to_send := 0; r10.insert := 0; r10.reset := 1; ELSE r10.reset := 0; END_IF;
IF rail_signal_10.1 THEN rail_signal_10.1 := 0; r10.man_open := 1; END_IF;
IF rail_signal_10.2 THEN rail_signal_10.2 := 0; r10.man_send := 1; END_IF;
IF rail_signal_10.3 THEN rail_signal_10.3 := 0; r10.ok_to_send := 1; END_IF;
IF rail_signal_10.4 THEN rail_signal_10.4 := 0; r10.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_10.5 THEN rail_signal_10.5 := 0; r10.cc_open_bottom_os := 1; END_IF;
IF rail_signal_10.6 THEN rail_signal_10.6 := 0; r10.cc_shut_top_os := 1; END_IF;
IF rail_signal_10.7 THEN rail_signal_10.7 := 0; r10.cc_open_top_os := 1; END_IF;
IF rail_signal_10.8 THEN rail_signal_10.8 := 0; r10.purge := 1; END_IF;


IF rail_signal_11.0 THEN rail_signal_11.0 := 0; r11.man_open := 0; r11.man_send := 0; r11.ok_to_send := 0; r11.insert := 0; r11.reset := 1; ELSE r11.reset := 0; END_IF;
IF rail_signal_11.1 THEN rail_signal_11.1 := 0; r11.man_open := 1; END_IF;
IF rail_signal_11.2 THEN rail_signal_11.2 := 0; r11.man_send := 1; END_IF;
IF rail_signal_11.3 THEN rail_signal_11.3 := 0; r11.ok_to_send := 1; END_IF;
IF rail_signal_11.4 THEN rail_signal_11.4 := 0; r11.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_11.5 THEN rail_signal_11.5 := 0; r11.cc_open_bottom_os := 1; END_IF;
IF rail_signal_11.6 THEN rail_signal_11.6 := 0; r11.cc_shut_top_os := 1; END_IF;
IF rail_signal_11.7 THEN rail_signal_11.7 := 0; r11.cc_open_top_os := 1; END_IF;
IF rail_signal_11.8 THEN rail_signal_11.8 := 0; r11.purge := 1; END_IF;


IF rail_signal_12.0 THEN rail_signal_12.0 := 0; r12.man_open := 0; r12.man_send := 0; r12.ok_to_send := 0; r12.insert := 0; r12.reset := 1; ELSE r12.reset := 0; END_IF;
IF rail_signal_12.1 THEN rail_signal_12.1 := 0; r12.man_open := 1; END_IF;
IF rail_signal_12.2 THEN rail_signal_12.2 := 0; r12.man_send := 1; END_IF;
IF rail_signal_12.3 THEN rail_signal_12.3 := 0; r12.ok_to_send := 1; END_IF;
IF rail_signal_12.4 THEN rail_signal_12.4 := 0; r12.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_12.5 THEN rail_signal_12.5 := 0; r12.cc_open_bottom_os := 1; END_IF;
IF rail_signal_12.6 THEN rail_signal_12.6 := 0; r12.cc_shut_top_os := 1; END_IF;
IF rail_signal_12.7 THEN rail_signal_12.7 := 0; r12.cc_open_top_os := 1; END_IF;
IF rail_signal_12.8 THEN rail_signal_12.8 := 0; r12.purge := 1; END_IF;


IF rail_signal_13.0 THEN rail_signal_13.0 := 0; r13.man_open := 0; r13.man_send := 0; r13.ok_to_send := 0; r13.insert := 0; r13.reset := 1; ELSE r13.reset := 0; END_IF;
IF rail_signal_13.1 THEN rail_signal_13.1 := 0; r13.man_open := 1; END_IF;
IF rail_signal_13.2 THEN rail_signal_13.2 := 0; r13.man_send := 1; END_IF;
IF rail_signal_13.3 THEN rail_signal_13.3 := 0; r13.ok_to_send := 1; END_IF;
IF rail_signal_13.4 THEN rail_signal_13.4 := 0; r13.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_13.5 THEN rail_signal_13.5 := 0; r13.cc_open_bottom_os := 1; END_IF;
IF rail_signal_13.6 THEN rail_signal_13.6 := 0; r13.cc_shut_top_os := 1; END_IF;
IF rail_signal_13.7 THEN rail_signal_13.7 := 0; r13.cc_open_top_os := 1; END_IF;
IF rail_signal_13.8 THEN rail_signal_13.8 := 0; r13.purge := 1; END_IF;


IF rail_signal_14.0 THEN rail_signal_14.0 := 0; r14.man_open := 0; r14.man_send := 0; r14.ok_to_send := 0; r14.insert := 0; r14.reset := 1; ELSE r14.reset := 0; END_IF;
IF rail_signal_14.1 THEN rail_signal_14.1 := 0; r14.man_open := 1; END_IF;
IF rail_signal_14.2 THEN rail_signal_14.2 := 0; r14.man_send := 1; END_IF;
IF rail_signal_14.3 THEN rail_signal_14.3 := 0; r14.ok_to_send := 1; END_IF;
IF rail_signal_14.4 THEN rail_signal_14.4 := 0; r14.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_14.5 THEN rail_signal_14.5 := 0; r14.cc_open_bottom_os := 1; END_IF;
IF rail_signal_14.6 THEN rail_signal_14.6 := 0; r14.cc_shut_top_os := 1; END_IF;
IF rail_signal_14.7 THEN rail_signal_14.7 := 0; r14.cc_open_top_os := 1; END_IF;
IF rail_signal_14.8 THEN rail_signal_14.8 := 0; r14.purge := 1; END_IF;


IF rail_signal_15.0 THEN rail_signal_15.0 := 0; r15.man_open := 0; r15.man_send := 0; r15.ok_to_send := 0; r15.insert := 0; r15.reset := 1; ELSE r15.reset := 0; END_IF;
IF rail_signal_15.1 THEN rail_signal_15.1 := 0; r15.man_open := 1; END_IF;
IF rail_signal_15.2 THEN rail_signal_15.2 := 0; r15.man_send := 1; END_IF;
IF rail_signal_15.3 THEN rail_signal_15.3 := 0; r15.ok_to_send := 1; END_IF;
IF rail_signal_15.4 THEN rail_signal_15.4 := 0; r15.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_15.5 THEN rail_signal_15.5 := 0; r15.cc_open_bottom_os := 1; END_IF;
IF rail_signal_15.6 THEN rail_signal_15.6 := 0; r15.cc_shut_top_os := 1; END_IF;
IF rail_signal_15.7 THEN rail_signal_15.7 := 0; r15.cc_open_top_os := 1; END_IF;
IF rail_signal_15.8 THEN rail_signal_15.8 := 0; r15.purge := 1; END_IF;


IF rail_signal_16.0 THEN rail_signal_16.0 := 0; r16.man_open := 0; r16.man_send := 0; r16.ok_to_send := 0; r16.insert := 0; r16.reset := 1; ELSE r16.reset := 0; END_IF;
IF rail_signal_16.1 THEN rail_signal_16.1 := 0; r16.man_open := 1; END_IF;
IF rail_signal_16.2 THEN rail_signal_16.2 := 0; r16.man_send := 1; END_IF;
IF rail_signal_16.3 THEN rail_signal_16.3 := 0; r16.ok_to_send := 1; END_IF;
IF rail_signal_16.4 THEN rail_signal_16.4 := 0; r16.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_16.5 THEN rail_signal_16.5 := 0; r16.cc_open_bottom_os := 1; END_IF;
IF rail_signal_16.6 THEN rail_signal_16.6 := 0; r16.cc_shut_top_os := 1; END_IF;
IF rail_signal_16.7 THEN rail_signal_16.7 := 0; r16.cc_open_top_os := 1; END_IF;
IF rail_signal_16.8 THEN rail_signal_16.8 := 0; r16.purge := 1; END_IF;


IF rail_signal_17.0 THEN rail_signal_17.0 := 0; r17.man_open := 0; r17.man_send := 0; r17.ok_to_send := 0; r17.insert := 0; r17.reset := 1; ELSE r17.reset := 0; END_IF;
IF rail_signal_17.1 THEN rail_signal_17.1 := 0; r17.man_open := 1; END_IF;
IF rail_signal_17.2 THEN rail_signal_17.2 := 0; r17.man_send := 1; END_IF;
IF rail_signal_17.3 THEN rail_signal_17.3 := 0; r17.ok_to_send := 1; END_IF;
IF rail_signal_17.4 THEN rail_signal_17.4 := 0; r17.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_17.5 THEN rail_signal_17.5 := 0; r17.cc_open_bottom_os := 1; END_IF;
IF rail_signal_17.6 THEN rail_signal_17.6 := 0; r17.cc_shut_top_os := 1; END_IF;
IF rail_signal_17.7 THEN rail_signal_17.7 := 0; r17.cc_open_top_os := 1; END_IF;
IF rail_signal_17.8 THEN rail_signal_17.8 := 0; r17.purge := 1; END_IF;


IF rail_signal_18.0 THEN rail_signal_18.0 := 0; r18.man_open := 0; r18.man_send := 0; r18.ok_to_send := 0; r18.insert := 0; r18.reset := 1; ELSE r18.reset := 0; END_IF;
IF rail_signal_18.1 THEN rail_signal_18.1 := 0; r18.man_open := 1; END_IF;
IF rail_signal_18.2 THEN rail_signal_18.2 := 0; r18.man_send := 1; END_IF;
IF rail_signal_18.3 THEN rail_signal_18.3 := 0; r18.ok_to_send := 1; END_IF;
IF rail_signal_18.4 THEN rail_signal_18.4 := 0; r18.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_18.5 THEN rail_signal_18.5 := 0; r18.cc_open_bottom_os := 1; END_IF;
IF rail_signal_18.6 THEN rail_signal_18.6 := 0; r18.cc_shut_top_os := 1; END_IF;
IF rail_signal_18.7 THEN rail_signal_18.7 := 0; r18.cc_open_top_os := 1; END_IF;
IF rail_signal_18.8 THEN rail_signal_18.8 := 0; r18.purge := 1; END_IF;


IF rail_signal_19.0 THEN rail_signal_19.0 := 0; r19.man_open := 0; r19.man_send := 0; r19.ok_to_send := 0; r19.insert := 0; r19.reset := 1; ELSE r19.reset := 0; END_IF;
IF rail_signal_19.1 THEN rail_signal_19.1 := 0; r19.man_open := 1; END_IF;
IF rail_signal_19.2 THEN rail_signal_19.2 := 0; r19.man_send := 1; END_IF;
IF rail_signal_19.3 THEN rail_signal_19.3 := 0; r19.ok_to_send := 1; END_IF;
IF rail_signal_19.4 THEN rail_signal_19.4 := 0; r19.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_19.5 THEN rail_signal_19.5 := 0; r19.cc_open_bottom_os := 1; END_IF;
IF rail_signal_19.6 THEN rail_signal_19.6 := 0; r19.cc_shut_top_os := 1; END_IF;
IF rail_signal_19.7 THEN rail_signal_19.7 := 0; r19.cc_open_top_os := 1; END_IF;
IF rail_signal_19.8 THEN rail_signal_19.8 := 0; r19.purge := 1; END_IF;


IF rail_signal_20.0 THEN rail_signal_20.0 := 0; r20.man_open := 0; r20.man_send := 0; r20.ok_to_send := 0; r20.insert := 0; r20.reset := 1; ELSE r20.reset := 0; END_IF;
IF rail_signal_20.1 THEN rail_signal_20.1 := 0; r20.man_open := 1; END_IF;
IF rail_signal_20.2 THEN rail_signal_20.2 := 0; r20.man_send := 1; END_IF;
IF rail_signal_20.3 THEN rail_signal_20.3 := 0; r20.ok_to_send := 1; END_IF;
IF rail_signal_20.4 THEN rail_signal_20.4 := 0; r20.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_20.5 THEN rail_signal_20.5 := 0; r20.cc_open_bottom_os := 1; END_IF;
IF rail_signal_20.6 THEN rail_signal_20.6 := 0; r20.cc_shut_top_os := 1; END_IF;
IF rail_signal_20.7 THEN rail_signal_20.7 := 0; r20.cc_open_top_os := 1; END_IF;
IF rail_signal_20.8 THEN rail_signal_20.8 := 0; r20.purge := 1; END_IF;


IF rail_signal_21.0 THEN rail_signal_21.0 := 0; r21.man_open := 0; r21.man_send := 0; r21.ok_to_send := 0; r21.insert := 0; r21.reset := 1; ELSE r21.reset := 0; END_IF;
IF rail_signal_21.1 THEN rail_signal_21.1 := 0; r21.man_open := 1; END_IF;
IF rail_signal_21.2 THEN rail_signal_21.2 := 0; r21.man_send := 1; END_IF;
IF rail_signal_21.3 THEN rail_signal_21.3 := 0; r21.ok_to_send := 1; END_IF;
IF rail_signal_21.4 THEN rail_signal_21.4 := 0; r21.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_21.5 THEN rail_signal_21.5 := 0; r21.cc_open_bottom_os := 1; END_IF;
IF rail_signal_21.6 THEN rail_signal_21.6 := 0; r21.cc_shut_top_os := 1; END_IF;
IF rail_signal_21.7 THEN rail_signal_21.7 := 0; r21.cc_open_top_os := 1; END_IF;
IF rail_signal_21.8 THEN rail_signal_21.8 := 0; r21.purge := 1; END_IF;


IF rail_signal_22.0 THEN rail_signal_22.0 := 0; r22.man_open := 0; r22.man_send := 0; r22.ok_to_send := 0; r22.insert := 0; r22.reset := 1; ELSE r22.reset := 0; END_IF;
IF rail_signal_22.1 THEN rail_signal_22.1 := 0; r22.man_open := 1; END_IF;
IF rail_signal_22.2 THEN rail_signal_22.2 := 0; r22.man_send := 1; END_IF;
IF rail_signal_22.3 THEN rail_signal_22.3 := 0; r22.ok_to_send := 1; END_IF;
IF rail_signal_22.4 THEN rail_signal_22.4 := 0; r22.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_22.5 THEN rail_signal_22.5 := 0; r22.cc_open_bottom_os := 1; END_IF;
IF rail_signal_22.6 THEN rail_signal_22.6 := 0; r22.cc_shut_top_os := 1; END_IF;
IF rail_signal_22.7 THEN rail_signal_22.7 := 0; r22.cc_open_top_os := 1; END_IF;
IF rail_signal_22.8 THEN rail_signal_22.8 := 0; r22.purge := 1; END_IF;


IF rail_signal_23.0 THEN rail_signal_23.0 := 0; r23.man_open := 0; r23.man_send := 0; r23.ok_to_send := 0; r23.insert := 0; r23.reset := 1; ELSE r23.reset := 0; END_IF;
IF rail_signal_23.1 THEN rail_signal_23.1 := 0; r23.man_open := 1; END_IF;
IF rail_signal_23.2 THEN rail_signal_23.2 := 0; r23.man_send := 1; END_IF;
IF rail_signal_23.3 THEN rail_signal_23.3 := 0; r23.ok_to_send := 1; END_IF;
IF rail_signal_23.4 THEN rail_signal_23.4 := 0; r23.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_23.5 THEN rail_signal_23.5 := 0; r23.cc_open_bottom_os := 1; END_IF;
IF rail_signal_23.6 THEN rail_signal_23.6 := 0; r23.cc_shut_top_os := 1; END_IF;
IF rail_signal_23.7 THEN rail_signal_23.7 := 0; r23.cc_open_top_os := 1; END_IF;
IF rail_signal_23.8 THEN rail_signal_23.8 := 0; r23.purge := 1; END_IF;


IF rail_signal_24.0 THEN rail_signal_24.0 := 0; r24.man_open := 0; r24.man_send := 0; r24.ok_to_send := 0; r24.insert := 0; r24.reset := 1; ELSE r24.reset := 0; END_IF;
IF rail_signal_24.1 THEN rail_signal_24.1 := 0; r24.man_open := 1; END_IF;
IF rail_signal_24.2 THEN rail_signal_24.2 := 0; r24.man_send := 1; END_IF;
IF rail_signal_24.3 THEN rail_signal_24.3 := 0; r24.ok_to_send := 1; END_IF;
IF rail_signal_24.4 THEN rail_signal_24.4 := 0; r24.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_24.5 THEN rail_signal_24.5 := 0; r24.cc_open_bottom_os := 1; END_IF;
IF rail_signal_24.6 THEN rail_signal_24.6 := 0; r24.cc_shut_top_os := 1; END_IF;
IF rail_signal_24.7 THEN rail_signal_24.7 := 0; r24.cc_open_top_os := 1; END_IF;
IF rail_signal_24.8 THEN rail_signal_24.8 := 0; r24.purge := 1; END_IF;


IF rail_signal_25.0 THEN rail_signal_25.0 := 0; r25.man_open := 0; r25.man_send := 0; r25.ok_to_send := 0; r25.insert := 0; r25.reset := 1; ELSE r25.reset := 0; END_IF;
IF rail_signal_25.1 THEN rail_signal_25.1 := 0; r25.man_open := 1; END_IF;
IF rail_signal_25.2 THEN rail_signal_25.2 := 0; r25.man_send := 1; END_IF;
IF rail_signal_25.3 THEN rail_signal_25.3 := 0; r25.ok_to_send := 1; END_IF;
IF rail_signal_25.4 THEN rail_signal_25.4 := 0; r25.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_25.5 THEN rail_signal_25.5 := 0; r25.cc_open_bottom_os := 1; END_IF;
IF rail_signal_25.6 THEN rail_signal_25.6 := 0; r25.cc_shut_top_os := 1; END_IF;
IF rail_signal_25.7 THEN rail_signal_25.7 := 0; r25.cc_open_top_os := 1; END_IF;
IF rail_signal_25.8 THEN rail_signal_25.8 := 0; r25.purge := 1; END_IF;


IF rail_signal_26.0 THEN rail_signal_26.0 := 0; r26.man_open := 0; r26.man_send := 0; r26.ok_to_send := 0; r26.insert := 0; r26.reset := 1; ELSE r26.reset := 0; END_IF;
IF rail_signal_26.1 THEN rail_signal_26.1 := 0; r26.man_open := 1; END_IF;
IF rail_signal_26.2 THEN rail_signal_26.2 := 0; r26.man_send := 1; END_IF;
IF rail_signal_26.3 THEN rail_signal_26.3 := 0; r26.ok_to_send := 1; END_IF;
IF rail_signal_26.4 THEN rail_signal_26.4 := 0; r26.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_26.5 THEN rail_signal_26.5 := 0; r26.cc_open_bottom_os := 1; END_IF;
IF rail_signal_26.6 THEN rail_signal_26.6 := 0; r26.cc_shut_top_os := 1; END_IF;
IF rail_signal_26.7 THEN rail_signal_26.7 := 0; r26.cc_open_top_os := 1; END_IF;
IF rail_signal_26.8 THEN rail_signal_26.8 := 0; r26.purge := 1; END_IF;


IF rail_signal_27.0 THEN rail_signal_27.0 := 0; r27.man_open := 0; r27.man_send := 0; r27.ok_to_send := 0; r27.insert := 0; r27.reset := 1; ELSE r27.reset := 0; END_IF;
IF rail_signal_27.1 THEN rail_signal_27.1 := 0; r27.man_open := 1; END_IF;
IF rail_signal_27.2 THEN rail_signal_27.2 := 0; r27.man_send := 1; END_IF;
IF rail_signal_27.3 THEN rail_signal_27.3 := 0; r27.ok_to_send := 1; END_IF;
IF rail_signal_27.4 THEN rail_signal_27.4 := 0; r27.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_27.5 THEN rail_signal_27.5 := 0; r27.cc_open_bottom_os := 1; END_IF;
IF rail_signal_27.6 THEN rail_signal_27.6 := 0; r27.cc_shut_top_os := 1; END_IF;
IF rail_signal_27.7 THEN rail_signal_27.7 := 0; r27.cc_open_top_os := 1; END_IF;
IF rail_signal_27.8 THEN rail_signal_27.8 := 0; r27.purge := 1; END_IF;


IF rail_signal_28.0 THEN rail_signal_28.0 := 0; r28.man_open := 0; r28.man_send := 0; r28.ok_to_send := 0; r28.insert := 0; r28.reset := 1; ELSE r28.reset := 0; END_IF;
IF rail_signal_28.1 THEN rail_signal_28.1 := 0; r28.man_open := 1; END_IF;
IF rail_signal_28.2 THEN rail_signal_28.2 := 0; r28.man_send := 1; END_IF;
IF rail_signal_28.3 THEN rail_signal_28.3 := 0; r28.ok_to_send := 1; END_IF;
IF rail_signal_28.4 THEN rail_signal_28.4 := 0; r28.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_28.5 THEN rail_signal_28.5 := 0; r28.cc_open_bottom_os := 1; END_IF;
IF rail_signal_28.6 THEN rail_signal_28.6 := 0; r28.cc_shut_top_os := 1; END_IF;
IF rail_signal_28.7 THEN rail_signal_28.7 := 0; r28.cc_open_top_os := 1; END_IF;
IF rail_signal_28.8 THEN rail_signal_28.8 := 0; r28.purge := 1; END_IF;


IF rail_signal_29.0 THEN rail_signal_29.0 := 0; r29.man_open := 0; r29.man_send := 0; r29.ok_to_send := 0; r29.insert := 0; r29.reset := 1; ELSE r29.reset := 0; END_IF;
IF rail_signal_29.1 THEN rail_signal_29.1 := 0; r29.man_open := 1; END_IF;
IF rail_signal_29.2 THEN rail_signal_29.2 := 0; r29.man_send := 1; END_IF;
IF rail_signal_29.3 THEN rail_signal_29.3 := 0; r29.ok_to_send := 1; END_IF;
IF rail_signal_29.4 THEN rail_signal_29.4 := 0; r29.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_29.5 THEN rail_signal_29.5 := 0; r29.cc_open_bottom_os := 1; END_IF;
IF rail_signal_29.6 THEN rail_signal_29.6 := 0; r29.cc_shut_top_os := 1; END_IF;
IF rail_signal_29.7 THEN rail_signal_29.7 := 0; r29.cc_open_top_os := 1; END_IF;
IF rail_signal_29.8 THEN rail_signal_29.8 := 0; r29.purge := 1; END_IF;


IF rail_signal_30.0 THEN rail_signal_30.0 := 0; r30.man_open := 0; r30.man_send := 0; r30.ok_to_send := 0; r30.insert := 0; r30.reset := 1; ELSE r30.reset := 0; END_IF;
IF rail_signal_30.1 THEN rail_signal_30.1 := 0; r30.man_open := 1; END_IF;
IF rail_signal_30.2 THEN rail_signal_30.2 := 0; r30.man_send := 1; END_IF;
IF rail_signal_30.3 THEN rail_signal_30.3 := 0; r30.ok_to_send := 1; END_IF;
IF rail_signal_30.4 THEN rail_signal_30.4 := 0; r30.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_30.5 THEN rail_signal_30.5 := 0; r30.cc_open_bottom_os := 1; END_IF;
IF rail_signal_30.6 THEN rail_signal_30.6 := 0; r30.cc_shut_top_os := 1; END_IF;
IF rail_signal_30.7 THEN rail_signal_30.7 := 0; r30.cc_open_top_os := 1; END_IF;
IF rail_signal_30.8 THEN rail_signal_30.8 := 0; r30.purge := 1; END_IF;


IF rail_signal_31.0 THEN rail_signal_31.0 := 0; r31.man_open := 0; r31.man_send := 0; r31.ok_to_send := 0; r31.insert := 0; r31.reset := 1; ELSE r31.reset := 0; END_IF;
IF rail_signal_31.1 THEN rail_signal_31.1 := 0; r31.man_open := 1; END_IF;
IF rail_signal_31.2 THEN rail_signal_31.2 := 0; r31.man_send := 1; END_IF;
IF rail_signal_31.3 THEN rail_signal_31.3 := 0; r31.ok_to_send := 1; END_IF;
IF rail_signal_31.4 THEN rail_signal_31.4 := 0; r31.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_31.5 THEN rail_signal_31.5 := 0; r31.cc_open_bottom_os := 1; END_IF;
IF rail_signal_31.6 THEN rail_signal_31.6 := 0; r31.cc_shut_top_os := 1; END_IF;
IF rail_signal_31.7 THEN rail_signal_31.7 := 0; r31.cc_open_top_os := 1; END_IF;
IF rail_signal_31.8 THEN rail_signal_31.8 := 0; r31.purge := 1; END_IF;


IF rail_signal_32.0 THEN rail_signal_32.0 := 0; r32.man_open := 0; r32.man_send := 0; r32.ok_to_send := 0; r32.insert := 0; r32.reset := 1; ELSE r32.reset := 0; END_IF;
IF rail_signal_32.1 THEN rail_signal_32.1 := 0; r32.man_open := 1; END_IF;
IF rail_signal_32.2 THEN rail_signal_32.2 := 0; r32.man_send := 1; END_IF;
IF rail_signal_32.3 THEN rail_signal_32.3 := 0; r32.ok_to_send := 1; END_IF;
IF rail_signal_32.4 THEN rail_signal_32.4 := 0; r32.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_32.5 THEN rail_signal_32.5 := 0; r32.cc_open_bottom_os := 1; END_IF;
IF rail_signal_32.6 THEN rail_signal_32.6 := 0; r32.cc_shut_top_os := 1; END_IF;
IF rail_signal_32.7 THEN rail_signal_32.7 := 0; r32.cc_open_top_os := 1; END_IF;
IF rail_signal_32.8 THEN rail_signal_32.8 := 0; r32.purge := 1; END_IF;


IF rail_signal_33.0 THEN rail_signal_33.0 := 0; r33.man_open := 0; r33.man_send := 0; r33.ok_to_send := 0; r33.insert := 0; r33.reset := 1; ELSE r33.reset := 0; END_IF;
IF rail_signal_33.1 THEN rail_signal_33.1 := 0; r33.man_open := 1; END_IF;
IF rail_signal_33.2 THEN rail_signal_33.2 := 0; r33.man_send := 1; END_IF;
IF rail_signal_33.3 THEN rail_signal_33.3 := 0; r33.ok_to_send := 1; END_IF;
IF rail_signal_33.4 THEN rail_signal_33.4 := 0; r33.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_33.5 THEN rail_signal_33.5 := 0; r33.cc_open_bottom_os := 1; END_IF;
IF rail_signal_33.6 THEN rail_signal_33.6 := 0; r33.cc_shut_top_os := 1; END_IF;
IF rail_signal_33.7 THEN rail_signal_33.7 := 0; r33.cc_open_top_os := 1; END_IF;
IF rail_signal_33.8 THEN rail_signal_33.8 := 0; r33.purge := 1; END_IF;


IF rail_signal_34.0 THEN rail_signal_34.0 := 0; r34.man_open := 0; r34.man_send := 0; r34.ok_to_send := 0; r34.insert := 0; r34.reset := 1; ELSE r34.reset := 0; END_IF;
IF rail_signal_34.1 THEN rail_signal_34.1 := 0; r34.man_open := 1; END_IF;
IF rail_signal_34.2 THEN rail_signal_34.2 := 0; r34.man_send := 1; END_IF;
IF rail_signal_34.3 THEN rail_signal_34.3 := 0; r34.ok_to_send := 1; END_IF;
IF rail_signal_34.4 THEN rail_signal_34.4 := 0; r34.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_34.5 THEN rail_signal_34.5 := 0; r34.cc_open_bottom_os := 1; END_IF;
IF rail_signal_34.6 THEN rail_signal_34.6 := 0; r34.cc_shut_top_os := 1; END_IF;
IF rail_signal_34.7 THEN rail_signal_34.7 := 0; r34.cc_open_top_os := 1; END_IF;
IF rail_signal_34.8 THEN rail_signal_34.8 := 0; r34.purge := 1; END_IF;


IF rail_signal_35.0 THEN rail_signal_35.0 := 0; r35.man_open := 0; r35.man_send := 0; r35.ok_to_send := 0; r35.insert := 0; r35.reset := 1; ELSE r35.reset := 0; END_IF;
IF rail_signal_35.1 THEN rail_signal_35.1 := 0; r35.man_open := 1; END_IF;
IF rail_signal_35.2 THEN rail_signal_35.2 := 0; r35.man_send := 1; END_IF;
IF rail_signal_35.3 THEN rail_signal_35.3 := 0; r35.ok_to_send := 1; END_IF;
IF rail_signal_35.4 THEN rail_signal_35.4 := 0; r35.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_35.5 THEN rail_signal_35.5 := 0; r35.cc_open_bottom_os := 1; END_IF;
IF rail_signal_35.6 THEN rail_signal_35.6 := 0; r35.cc_shut_top_os := 1; END_IF;
IF rail_signal_35.7 THEN rail_signal_35.7 := 0; r35.cc_open_top_os := 1; END_IF;
IF rail_signal_35.8 THEN rail_signal_35.8 := 0; r35.purge := 1; END_IF;


IF rail_signal_36.0 THEN rail_signal_36.0 := 0; r36.man_open := 0; r36.man_send := 0; r36.ok_to_send := 0; r36.insert := 0; r36.reset := 1; ELSE r36.reset := 0; END_IF;
IF rail_signal_36.1 THEN rail_signal_36.1 := 0; r36.man_open := 1; END_IF;
IF rail_signal_36.2 THEN rail_signal_36.2 := 0; r36.man_send := 1; END_IF;
IF rail_signal_36.3 THEN rail_signal_36.3 := 0; r36.ok_to_send := 1; END_IF;
IF rail_signal_36.4 THEN rail_signal_36.4 := 0; r36.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_36.5 THEN rail_signal_36.5 := 0; r36.cc_open_bottom_os := 1; END_IF;
IF rail_signal_36.6 THEN rail_signal_36.6 := 0; r36.cc_shut_top_os := 1; END_IF;
IF rail_signal_36.7 THEN rail_signal_36.7 := 0; r36.cc_open_top_os := 1; END_IF;
IF rail_signal_36.8 THEN rail_signal_36.8 := 0; r36.purge := 1; END_IF;


IF rail_signal_37.0 THEN rail_signal_37.0 := 0; r37.man_open := 0; r37.man_send := 0; r37.ok_to_send := 0; r37.insert := 0; r37.reset := 1; ELSE r37.reset := 0; END_IF;
IF rail_signal_37.1 THEN rail_signal_37.1 := 0; r37.man_open := 1; END_IF;
IF rail_signal_37.2 THEN rail_signal_37.2 := 0; r37.man_send := 1; END_IF;
IF rail_signal_37.3 THEN rail_signal_37.3 := 0; r37.ok_to_send := 1; END_IF;
IF rail_signal_37.4 THEN rail_signal_37.4 := 0; r37.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_37.5 THEN rail_signal_37.5 := 0; r37.cc_open_bottom_os := 1; END_IF;
IF rail_signal_37.6 THEN rail_signal_37.6 := 0; r37.cc_shut_top_os := 1; END_IF;
IF rail_signal_37.7 THEN rail_signal_37.7 := 0; r37.cc_open_top_os := 1; END_IF;
IF rail_signal_37.8 THEN rail_signal_37.8 := 0; r37.purge := 1; END_IF;


IF rail_signal_38.0 THEN rail_signal_38.0 := 0; r38.man_open := 0; r38.man_send := 0; r38.ok_to_send := 0; r38.insert := 0; r38.reset := 1; ELSE r38.reset := 0; END_IF;
IF rail_signal_38.1 THEN rail_signal_38.1 := 0; r38.man_open := 1; END_IF;
IF rail_signal_38.2 THEN rail_signal_38.2 := 0; r38.man_send := 1; END_IF;
IF rail_signal_38.3 THEN rail_signal_38.3 := 0; r38.ok_to_send := 1; END_IF;
IF rail_signal_38.4 THEN rail_signal_38.4 := 0; r38.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_38.5 THEN rail_signal_38.5 := 0; r38.cc_open_bottom_os := 1; END_IF;
IF rail_signal_38.6 THEN rail_signal_38.6 := 0; r38.cc_shut_top_os := 1; END_IF;
IF rail_signal_38.7 THEN rail_signal_38.7 := 0; r38.cc_open_top_os := 1; END_IF;
IF rail_signal_38.8 THEN rail_signal_38.8 := 0; r38.purge := 1; END_IF;


IF rail_signal_39.0 THEN rail_signal_39.0 := 0; r39.man_open := 0; r39.man_send := 0; r39.ok_to_send := 0; r39.insert := 0; r39.reset := 1; ELSE r39.reset := 0; END_IF;
IF rail_signal_39.1 THEN rail_signal_39.1 := 0; r39.man_open := 1; END_IF;
IF rail_signal_39.2 THEN rail_signal_39.2 := 0; r39.man_send := 1; END_IF;
IF rail_signal_39.3 THEN rail_signal_39.3 := 0; r39.ok_to_send := 1; END_IF;
IF rail_signal_39.4 THEN rail_signal_39.4 := 0; r39.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_39.5 THEN rail_signal_39.5 := 0; r39.cc_open_bottom_os := 1; END_IF;
IF rail_signal_39.6 THEN rail_signal_39.6 := 0; r39.cc_shut_top_os := 1; END_IF;
IF rail_signal_39.7 THEN rail_signal_39.7 := 0; r39.cc_open_top_os := 1; END_IF;
IF rail_signal_39.8 THEN rail_signal_39.8 := 0; r39.purge := 1; END_IF;


IF rail_signal_40.0 THEN rail_signal_40.0 := 0; r40.man_open := 0; r40.man_send := 0; r40.ok_to_send := 0; r40.insert := 0; r40.reset := 1; ELSE r40.reset := 0; END_IF;
IF rail_signal_40.1 THEN rail_signal_40.1 := 0; r40.man_open := 1; END_IF;
IF rail_signal_40.2 THEN rail_signal_40.2 := 0; r40.man_send := 1; END_IF;
IF rail_signal_40.3 THEN rail_signal_40.3 := 0; r40.ok_to_send := 1; END_IF;
IF rail_signal_40.4 THEN rail_signal_40.4 := 0; r40.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_40.5 THEN rail_signal_40.5 := 0; r40.cc_open_bottom_os := 1; END_IF;
IF rail_signal_40.6 THEN rail_signal_40.6 := 0; r40.cc_shut_top_os := 1; END_IF;
IF rail_signal_40.7 THEN rail_signal_40.7 := 0; r40.cc_open_top_os := 1; END_IF;
IF rail_signal_40.8 THEN rail_signal_40.8 := 0; r40.purge := 1; END_IF;


IF rail_signal_41.0 THEN rail_signal_41.0 := 0; r41.man_open := 0; r41.man_send := 0; r41.ok_to_send := 0; r41.insert := 0; r41.reset := 1; ELSE r41.reset := 0; END_IF;
IF rail_signal_41.1 THEN rail_signal_41.1 := 0; r41.man_open := 1; END_IF;
IF rail_signal_41.2 THEN rail_signal_41.2 := 0; r41.man_send := 1; END_IF;
IF rail_signal_41.3 THEN rail_signal_41.3 := 0; r41.ok_to_send := 1; END_IF;
IF rail_signal_41.4 THEN rail_signal_41.4 := 0; r41.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_41.5 THEN rail_signal_41.5 := 0; r41.cc_open_bottom_os := 1; END_IF;
IF rail_signal_41.6 THEN rail_signal_41.6 := 0; r41.cc_shut_top_os := 1; END_IF;
IF rail_signal_41.7 THEN rail_signal_41.7 := 0; r41.cc_open_top_os := 1; END_IF;
IF rail_signal_41.8 THEN rail_signal_41.8 := 0; r41.purge := 1; END_IF;


IF rail_signal_42.0 THEN rail_signal_42.0 := 0; r42.man_open := 0; r42.man_send := 0; r42.ok_to_send := 0; r42.insert := 0; r42.reset := 1; ELSE r42.reset := 0; END_IF;
IF rail_signal_42.1 THEN rail_signal_42.1 := 0; r42.man_open := 1; END_IF;
IF rail_signal_42.2 THEN rail_signal_42.2 := 0; r42.man_send := 1; END_IF;
IF rail_signal_42.3 THEN rail_signal_42.3 := 0; r42.ok_to_send := 1; END_IF;
IF rail_signal_42.4 THEN rail_signal_42.4 := 0; r42.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_42.5 THEN rail_signal_42.5 := 0; r42.cc_open_bottom_os := 1; END_IF;
IF rail_signal_42.6 THEN rail_signal_42.6 := 0; r42.cc_shut_top_os := 1; END_IF;
IF rail_signal_42.7 THEN rail_signal_42.7 := 0; r42.cc_open_top_os := 1; END_IF;
IF rail_signal_42.8 THEN rail_signal_42.8 := 0; r42.purge := 1; END_IF;


IF rail_signal_43.0 THEN rail_signal_43.0 := 0; r43.man_open := 0; r43.man_send := 0; r43.ok_to_send := 0; r43.insert := 0; r43.reset := 1; ELSE r43.reset := 0; END_IF;
IF rail_signal_43.1 THEN rail_signal_43.1 := 0; r43.man_open := 1; END_IF;
IF rail_signal_43.2 THEN rail_signal_43.2 := 0; r43.man_send := 1; END_IF;
IF rail_signal_43.3 THEN rail_signal_43.3 := 0; r43.ok_to_send := 1; END_IF;
IF rail_signal_43.4 THEN rail_signal_43.4 := 0; r43.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_43.5 THEN rail_signal_43.5 := 0; r43.cc_open_bottom_os := 1; END_IF;
IF rail_signal_43.6 THEN rail_signal_43.6 := 0; r43.cc_shut_top_os := 1; END_IF;
IF rail_signal_43.7 THEN rail_signal_43.7 := 0; r43.cc_open_top_os := 1; END_IF;
IF rail_signal_43.8 THEN rail_signal_43.8 := 0; r43.purge := 1; END_IF;


IF rail_signal_44.0 THEN rail_signal_44.0 := 0; r44.man_open := 0; r44.man_send := 0; r44.ok_to_send := 0; r44.insert := 0; r44.reset := 1; ELSE r44.reset := 0; END_IF;
IF rail_signal_44.1 THEN rail_signal_44.1 := 0; r44.man_open := 1; END_IF;
IF rail_signal_44.2 THEN rail_signal_44.2 := 0; r44.man_send := 1; END_IF;
IF rail_signal_44.3 THEN rail_signal_44.3 := 0; r44.ok_to_send := 1; END_IF;
IF rail_signal_44.4 THEN rail_signal_44.4 := 0; r44.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_44.5 THEN rail_signal_44.5 := 0; r44.cc_open_bottom_os := 1; END_IF;
IF rail_signal_44.6 THEN rail_signal_44.6 := 0; r44.cc_shut_top_os := 1; END_IF;
IF rail_signal_44.7 THEN rail_signal_44.7 := 0; r44.cc_open_top_os := 1; END_IF;
IF rail_signal_44.8 THEN rail_signal_44.8 := 0; r44.purge := 1; END_IF;


IF rail_signal_45.0 THEN rail_signal_45.0 := 0; r45.man_open := 0; r45.man_send := 0; r45.ok_to_send := 0; r45.insert := 0; r45.reset := 1; ELSE r45.reset := 0; END_IF;
IF rail_signal_45.1 THEN rail_signal_45.1 := 0; r45.man_open := 1; END_IF;
IF rail_signal_45.2 THEN rail_signal_45.2 := 0; r45.man_send := 1; END_IF;
IF rail_signal_45.3 THEN rail_signal_45.3 := 0; r45.ok_to_send := 1; END_IF;
IF rail_signal_45.4 THEN rail_signal_45.4 := 0; r45.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_45.5 THEN rail_signal_45.5 := 0; r45.cc_open_bottom_os := 1; END_IF;
IF rail_signal_45.6 THEN rail_signal_45.6 := 0; r45.cc_shut_top_os := 1; END_IF;
IF rail_signal_45.7 THEN rail_signal_45.7 := 0; r45.cc_open_top_os := 1; END_IF;
IF rail_signal_45.8 THEN rail_signal_45.8 := 0; r45.purge := 1; END_IF;


IF rail_signal_46.0 THEN rail_signal_46.0 := 0; r46.man_open := 0; r46.man_send := 0; r46.ok_to_send := 0; r46.insert := 0; r46.reset := 1; ELSE r46.reset := 0; END_IF;
IF rail_signal_46.1 THEN rail_signal_46.1 := 0; r46.man_open := 1; END_IF;
IF rail_signal_46.2 THEN rail_signal_46.2 := 0; r46.man_send := 1; END_IF;
IF rail_signal_46.3 THEN rail_signal_46.3 := 0; r46.ok_to_send := 1; END_IF;
IF rail_signal_46.4 THEN rail_signal_46.4 := 0; r46.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_46.5 THEN rail_signal_46.5 := 0; r46.cc_open_bottom_os := 1; END_IF;
IF rail_signal_46.6 THEN rail_signal_46.6 := 0; r46.cc_shut_top_os := 1; END_IF;
IF rail_signal_46.7 THEN rail_signal_46.7 := 0; r46.cc_open_top_os := 1; END_IF;
IF rail_signal_46.8 THEN rail_signal_46.8 := 0; r46.purge := 1; END_IF;


IF rail_signal_47.0 THEN rail_signal_47.0 := 0; r47.man_open := 0; r47.man_send := 0; r47.ok_to_send := 0; r47.insert := 0; r47.reset := 1; ELSE r47.reset := 0; END_IF;
IF rail_signal_47.1 THEN rail_signal_47.1 := 0; r47.man_open := 1; END_IF;
IF rail_signal_47.2 THEN rail_signal_47.2 := 0; r47.man_send := 1; END_IF;
IF rail_signal_47.3 THEN rail_signal_47.3 := 0; r47.ok_to_send := 1; END_IF;
IF rail_signal_47.4 THEN rail_signal_47.4 := 0; r47.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_47.5 THEN rail_signal_47.5 := 0; r47.cc_open_bottom_os := 1; END_IF;
IF rail_signal_47.6 THEN rail_signal_47.6 := 0; r47.cc_shut_top_os := 1; END_IF;
IF rail_signal_47.7 THEN rail_signal_47.7 := 0; r47.cc_open_top_os := 1; END_IF;
IF rail_signal_47.8 THEN rail_signal_47.8 := 0; r47.purge := 1; END_IF;


IF rail_signal_48.0 THEN rail_signal_48.0 := 0; r48.man_open := 0; r48.man_send := 0; r48.ok_to_send := 0; r48.insert := 0; r48.reset := 1; ELSE r48.reset := 0; END_IF;
IF rail_signal_48.1 THEN rail_signal_48.1 := 0; r48.man_open := 1; END_IF;
IF rail_signal_48.2 THEN rail_signal_48.2 := 0; r48.man_send := 1; END_IF;
IF rail_signal_48.3 THEN rail_signal_48.3 := 0; r48.ok_to_send := 1; END_IF;
IF rail_signal_48.4 THEN rail_signal_48.4 := 0; r48.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_48.5 THEN rail_signal_48.5 := 0; r48.cc_open_bottom_os := 1; END_IF;
IF rail_signal_48.6 THEN rail_signal_48.6 := 0; r48.cc_shut_top_os := 1; END_IF;
IF rail_signal_48.7 THEN rail_signal_48.7 := 0; r48.cc_open_top_os := 1; END_IF;
IF rail_signal_48.8 THEN rail_signal_48.8 := 0; r48.purge := 1; END_IF;


IF rail_signal_49.0 THEN rail_signal_49.0 := 0; r49.man_open := 0; r49.man_send := 0; r49.ok_to_send := 0; r49.insert := 0; r49.reset := 1; ELSE r49.reset := 0; END_IF;
IF rail_signal_49.1 THEN rail_signal_49.1 := 0; r49.man_open := 1; END_IF;
IF rail_signal_49.2 THEN rail_signal_49.2 := 0; r49.man_send := 1; END_IF;
IF rail_signal_49.3 THEN rail_signal_49.3 := 0; r49.ok_to_send := 1; END_IF;
IF rail_signal_49.4 THEN rail_signal_49.4 := 0; r49.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_49.5 THEN rail_signal_49.5 := 0; r49.cc_open_bottom_os := 1; END_IF;
IF rail_signal_49.6 THEN rail_signal_49.6 := 0; r49.cc_shut_top_os := 1; END_IF;
IF rail_signal_49.7 THEN rail_signal_49.7 := 0; r49.cc_open_top_os := 1; END_IF;
IF rail_signal_49.8 THEN rail_signal_49.8 := 0; r49.purge := 1; END_IF;


IF rail_signal_50.0 THEN rail_signal_50.0 := 0; r50.man_open := 0; r50.man_send := 0; r50.ok_to_send := 0; r50.insert := 0; r50.reset := 1; ELSE r50.reset := 0; END_IF;
IF rail_signal_50.1 THEN rail_signal_50.1 := 0; r50.man_open := 1; END_IF;
IF rail_signal_50.2 THEN rail_signal_50.2 := 0; r50.man_send := 1; END_IF;
IF rail_signal_50.3 THEN rail_signal_50.3 := 0; r50.ok_to_send := 1; END_IF;
IF rail_signal_50.4 THEN rail_signal_50.4 := 0; r50.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_50.5 THEN rail_signal_50.5 := 0; r50.cc_open_bottom_os := 1; END_IF;
IF rail_signal_50.6 THEN rail_signal_50.6 := 0; r50.cc_shut_top_os := 1; END_IF;
IF rail_signal_50.7 THEN rail_signal_50.7 := 0; r50.cc_open_top_os := 1; END_IF;
IF rail_signal_50.8 THEN rail_signal_50.8 := 0; r50.purge := 1; END_IF;


IF rail_signal_51.0 THEN rail_signal_51.0 := 0; r51.man_open := 0; r51.man_send := 0; r51.ok_to_send := 0; r51.insert := 0; r51.reset := 1; ELSE r51.reset := 0; END_IF;
IF rail_signal_51.1 THEN rail_signal_51.1 := 0; r51.man_open := 1; END_IF;
IF rail_signal_51.2 THEN rail_signal_51.2 := 0; r51.man_send := 1; END_IF;
IF rail_signal_51.3 THEN rail_signal_51.3 := 0; r51.ok_to_send := 1; END_IF;
IF rail_signal_51.4 THEN rail_signal_51.4 := 0; r51.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_51.5 THEN rail_signal_51.5 := 0; r51.cc_open_bottom_os := 1; END_IF;
IF rail_signal_51.6 THEN rail_signal_51.6 := 0; r51.cc_shut_top_os := 1; END_IF;
IF rail_signal_51.7 THEN rail_signal_51.7 := 0; r51.cc_open_top_os := 1; END_IF;
IF rail_signal_51.8 THEN rail_signal_51.8 := 0; r51.purge := 1; END_IF;


IF rail_signal_52.0 THEN rail_signal_52.0 := 0; r52.man_open := 0; r52.man_send := 0; r52.ok_to_send := 0; r52.insert := 0; r52.reset := 1; ELSE r52.reset := 0; END_IF;
IF rail_signal_52.1 THEN rail_signal_52.1 := 0; r52.man_open := 1; END_IF;
IF rail_signal_52.2 THEN rail_signal_52.2 := 0; r52.man_send := 1; END_IF;
IF rail_signal_52.3 THEN rail_signal_52.3 := 0; r52.ok_to_send := 1; END_IF;
IF rail_signal_52.4 THEN rail_signal_52.4 := 0; r52.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_52.5 THEN rail_signal_52.5 := 0; r52.cc_open_bottom_os := 1; END_IF;
IF rail_signal_52.6 THEN rail_signal_52.6 := 0; r52.cc_shut_top_os := 1; END_IF;
IF rail_signal_52.7 THEN rail_signal_52.7 := 0; r52.cc_open_top_os := 1; END_IF;
IF rail_signal_52.8 THEN rail_signal_52.8 := 0; r52.purge := 1; END_IF;


IF rail_signal_53.0 THEN rail_signal_53.0 := 0; r53.man_open := 0; r53.man_send := 0; r53.ok_to_send := 0; r53.insert := 0; r53.reset := 1; ELSE r53.reset := 0; END_IF;
IF rail_signal_53.1 THEN rail_signal_53.1 := 0; r53.man_open := 1; END_IF;
IF rail_signal_53.2 THEN rail_signal_53.2 := 0; r53.man_send := 1; END_IF;
IF rail_signal_53.3 THEN rail_signal_53.3 := 0; r53.ok_to_send := 1; END_IF;
IF rail_signal_53.4 THEN rail_signal_53.4 := 0; r53.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_53.5 THEN rail_signal_53.5 := 0; r53.cc_open_bottom_os := 1; END_IF;
IF rail_signal_53.6 THEN rail_signal_53.6 := 0; r53.cc_shut_top_os := 1; END_IF;
IF rail_signal_53.7 THEN rail_signal_53.7 := 0; r53.cc_open_top_os := 1; END_IF;
IF rail_signal_53.8 THEN rail_signal_53.8 := 0; r53.purge := 1; END_IF;


IF rail_signal_54.0 THEN rail_signal_54.0 := 0; r54.man_open := 0; r54.man_send := 0; r54.ok_to_send := 0; r54.insert := 0; r54.reset := 1; ELSE r54.reset := 0; END_IF;
IF rail_signal_54.1 THEN rail_signal_54.1 := 0; r54.man_open := 1; END_IF;
IF rail_signal_54.2 THEN rail_signal_54.2 := 0; r54.man_send := 1; END_IF;
IF rail_signal_54.3 THEN rail_signal_54.3 := 0; r54.ok_to_send := 1; END_IF;
IF rail_signal_54.4 THEN rail_signal_54.4 := 0; r54.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_54.5 THEN rail_signal_54.5 := 0; r54.cc_open_bottom_os := 1; END_IF;
IF rail_signal_54.6 THEN rail_signal_54.6 := 0; r54.cc_shut_top_os := 1; END_IF;
IF rail_signal_54.7 THEN rail_signal_54.7 := 0; r54.cc_open_top_os := 1; END_IF;
IF rail_signal_54.8 THEN rail_signal_54.8 := 0; r54.purge := 1; END_IF;


IF rail_signal_55.0 THEN rail_signal_55.0 := 0; r55.man_open := 0; r55.man_send := 0; r55.ok_to_send := 0; r55.insert := 0; r55.reset := 1; ELSE r55.reset := 0; END_IF;
IF rail_signal_55.1 THEN rail_signal_55.1 := 0; r55.man_open := 1; END_IF;
IF rail_signal_55.2 THEN rail_signal_55.2 := 0; r55.man_send := 1; END_IF;
IF rail_signal_55.3 THEN rail_signal_55.3 := 0; r55.ok_to_send := 1; END_IF;
IF rail_signal_55.4 THEN rail_signal_55.4 := 0; r55.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_55.5 THEN rail_signal_55.5 := 0; r55.cc_open_bottom_os := 1; END_IF;
IF rail_signal_55.6 THEN rail_signal_55.6 := 0; r55.cc_shut_top_os := 1; END_IF;
IF rail_signal_55.7 THEN rail_signal_55.7 := 0; r55.cc_open_top_os := 1; END_IF;
IF rail_signal_55.8 THEN rail_signal_55.8 := 0; r55.purge := 1; END_IF;


IF rail_signal_56.0 THEN rail_signal_56.0 := 0; r56.man_open := 0; r56.man_send := 0; r56.ok_to_send := 0; r56.insert := 0; r56.reset := 1; ELSE r56.reset := 0; END_IF;
IF rail_signal_56.1 THEN rail_signal_56.1 := 0; r56.man_open := 1; END_IF;
IF rail_signal_56.2 THEN rail_signal_56.2 := 0; r56.man_send := 1; END_IF;
IF rail_signal_56.3 THEN rail_signal_56.3 := 0; r56.ok_to_send := 1; END_IF;
IF rail_signal_56.4 THEN rail_signal_56.4 := 0; r56.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_56.5 THEN rail_signal_56.5 := 0; r56.cc_open_bottom_os := 1; END_IF;
IF rail_signal_56.6 THEN rail_signal_56.6 := 0; r56.cc_shut_top_os := 1; END_IF;
IF rail_signal_56.7 THEN rail_signal_56.7 := 0; r56.cc_open_top_os := 1; END_IF;
IF rail_signal_56.8 THEN rail_signal_56.8 := 0; r56.purge := 1; END_IF;


IF rail_signal_57.0 THEN rail_signal_57.0 := 0; r57.man_open := 0; r57.man_send := 0; r57.ok_to_send := 0; r57.insert := 0; r57.reset := 1; ELSE r57.reset := 0; END_IF;
IF rail_signal_57.1 THEN rail_signal_57.1 := 0; r57.man_open := 1; END_IF;
IF rail_signal_57.2 THEN rail_signal_57.2 := 0; r57.man_send := 1; END_IF;
IF rail_signal_57.3 THEN rail_signal_57.3 := 0; r57.ok_to_send := 1; END_IF;
IF rail_signal_57.4 THEN rail_signal_57.4 := 0; r57.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_57.5 THEN rail_signal_57.5 := 0; r57.cc_open_bottom_os := 1; END_IF;
IF rail_signal_57.6 THEN rail_signal_57.6 := 0; r57.cc_shut_top_os := 1; END_IF;
IF rail_signal_57.7 THEN rail_signal_57.7 := 0; r57.cc_open_top_os := 1; END_IF;
IF rail_signal_57.8 THEN rail_signal_57.8 := 0; r57.purge := 1; END_IF;


IF rail_signal_58.0 THEN rail_signal_58.0 := 0; r58.man_open := 0; r58.man_send := 0; r58.ok_to_send := 0; r58.insert := 0; r58.reset := 1; ELSE r58.reset := 0; END_IF;
IF rail_signal_58.1 THEN rail_signal_58.1 := 0; r58.man_open := 1; END_IF;
IF rail_signal_58.2 THEN rail_signal_58.2 := 0; r58.man_send := 1; END_IF;
IF rail_signal_58.3 THEN rail_signal_58.3 := 0; r58.ok_to_send := 1; END_IF;
IF rail_signal_58.4 THEN rail_signal_58.4 := 0; r58.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_58.5 THEN rail_signal_58.5 := 0; r58.cc_open_bottom_os := 1; END_IF;
IF rail_signal_58.6 THEN rail_signal_58.6 := 0; r58.cc_shut_top_os := 1; END_IF;
IF rail_signal_58.7 THEN rail_signal_58.7 := 0; r58.cc_open_top_os := 1; END_IF;
IF rail_signal_58.8 THEN rail_signal_58.8 := 0; r58.purge := 1; END_IF;


IF rail_signal_59.0 THEN rail_signal_59.0 := 0; r59.man_open := 0; r59.man_send := 0; r59.ok_to_send := 0; r59.insert := 0; r59.reset := 1; ELSE r59.reset := 0; END_IF;
IF rail_signal_59.1 THEN rail_signal_59.1 := 0; r59.man_open := 1; END_IF;
IF rail_signal_59.2 THEN rail_signal_59.2 := 0; r59.man_send := 1; END_IF;
IF rail_signal_59.3 THEN rail_signal_59.3 := 0; r59.ok_to_send := 1; END_IF;
IF rail_signal_59.4 THEN rail_signal_59.4 := 0; r59.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_59.5 THEN rail_signal_59.5 := 0; r59.cc_open_bottom_os := 1; END_IF;
IF rail_signal_59.6 THEN rail_signal_59.6 := 0; r59.cc_shut_top_os := 1; END_IF;
IF rail_signal_59.7 THEN rail_signal_59.7 := 0; r59.cc_open_top_os := 1; END_IF;
IF rail_signal_59.8 THEN rail_signal_59.8 := 0; r59.purge := 1; END_IF;


IF rail_signal_60.0 THEN rail_signal_60.0 := 0; r60.man_open := 0; r60.man_send := 0; r60.ok_to_send := 0; r60.insert := 0; r60.reset := 1; ELSE r60.reset := 0; END_IF;
IF rail_signal_60.1 THEN rail_signal_60.1 := 0; r60.man_open := 1; END_IF;
IF rail_signal_60.2 THEN rail_signal_60.2 := 0; r60.man_send := 1; END_IF;
IF rail_signal_60.3 THEN rail_signal_60.3 := 0; r60.ok_to_send := 1; END_IF;
IF rail_signal_60.4 THEN rail_signal_60.4 := 0; r60.cc_shut_bottom_os := 1; END_IF;
IF rail_signal_60.5 THEN rail_signal_60.5 := 0; r60.cc_open_bottom_os := 1; END_IF;
IF rail_signal_60.6 THEN rail_signal_60.6 := 0; r60.cc_shut_top_os := 1; END_IF;
IF rail_signal_60.7 THEN rail_signal_60.7 := 0; r60.cc_open_top_os := 1; END_IF;
IF rail_signal_60.8 THEN rail_signal_60.8 := 0; r60.purge := 1; END_IF;


IF rail_signal_61.0 THEN rail_signal_61.0 := 0; r61.man_open := 0; r61.man_send := 0; r61.ok_to_send := 0; r61.insert := 0; r61.reset := 1; ELSE r61.reset := 0; END_IF;
IF rail_signal_61.1 THEN rail_signal_61.1 := 0; r61.man_open := 1; END_IF;
IF rail_signal_61.2 THEN rail_signal_61.2 := 0; r61.man_send := 1; END_IF;
IF rail_signal_61.3 THEN rail_signal_61.3 := 0; r61.ok_to_send := 1; END_IF;
IF rail_signal_61.8 THEN rail_signal_61.8 := 0; r61.purge := 1; END_IF;


IF rail_signal_62.0 THEN rail_signal_62.0 := 0; r62.man_open := 0; r62.man_send := 0; r62.ok_to_send := 0; r62.insert := 0; r62.reset := 1; ELSE r62.reset := 0; END_IF;
IF rail_signal_62.1 THEN rail_signal_62.1 := 0; r62.man_open := 1; END_IF;
IF rail_signal_62.2 THEN rail_signal_62.2 := 0; r62.man_send := 1; END_IF;
IF rail_signal_62.3 THEN rail_signal_62.3 := 0; r62.ok_to_send := 1; END_IF;
IF rail_signal_62.8 THEN rail_signal_62.8 := 0; r62.purge := 1; END_IF;


IF rail_signal_63.0 THEN rail_signal_63.0 := 0; r63.man_open := 0; r63.man_send := 0; r63.ok_to_send := 0; r63.insert := 0; r63.reset := 1; ELSE r63.reset := 0; END_IF;
IF rail_signal_63.1 THEN rail_signal_63.1 := 0; r63.man_open := 1; END_IF;
IF rail_signal_63.2 THEN rail_signal_63.2 := 0; r63.man_send := 1; END_IF;
IF rail_signal_63.3 THEN rail_signal_63.3 := 0; r63.ok_to_send := 1; END_IF;
IF rail_signal_63.8 THEN rail_signal_63.8 := 0; r63.purge := 1; END_IF;


IF rail_signal_64.0 THEN rail_signal_64.0 := 0; r64.man_open := 0; r64.man_send := 0; r64.ok_to_send := 0; r64.insert := 0; r64.reset := 1; ELSE r64.reset := 0; END_IF;
IF rail_signal_64.1 THEN rail_signal_64.1 := 0; r64.man_open := 1; END_IF;
IF rail_signal_64.2 THEN rail_signal_64.2 := 0; r64.man_send := 1; END_IF;
IF rail_signal_64.3 THEN rail_signal_64.3 := 0; r64.ok_to_send := 1; END_IF;
IF rail_signal_64.8 THEN rail_signal_64.8 := 0; r64.purge := 1; END_IF;


IF rail_signal_65.0 THEN rail_signal_65.0 := 0; r65.man_open := 0; r65.man_send := 0; r65.ok_to_send := 0; r65.insert := 0; r65.reset := 1; ELSE r65.reset := 0; END_IF;
IF rail_signal_65.1 THEN rail_signal_65.1 := 0; r65.man_open := 1; END_IF;
IF rail_signal_65.2 THEN rail_signal_65.2 := 0; r65.man_send := 1; END_IF;
IF rail_signal_65.3 THEN rail_signal_65.3 := 0; r65.ok_to_send := 1; END_IF;
IF rail_signal_65.8 THEN rail_signal_65.8 := 0; r65.purge := 1; END_IF;


IF rail_signal_66.0 THEN rail_signal_66.0 := 0; r66.man_open := 0; r66.man_send := 0; r66.ok_to_send := 0; r66.insert := 0; r66.reset := 1; ELSE r66.reset := 0; END_IF;
IF rail_signal_66.1 THEN rail_signal_66.1 := 0; r66.man_open := 1; END_IF;
IF rail_signal_66.2 THEN rail_signal_66.2 := 0; r66.man_send := 1; END_IF;
IF rail_signal_66.3 THEN rail_signal_66.3 := 0; r66.ok_to_send := 1; END_IF;
IF rail_signal_66.8 THEN rail_signal_66.8 := 0; r66.purge := 1; END_IF;


IF rail_signal_67.0 THEN rail_signal_67.0 := 0; r67.man_open := 0; r67.man_send := 0; r67.ok_to_send := 0; r67.insert := 0; r67.reset := 1; ELSE r67.reset := 0; END_IF;
IF rail_signal_67.1 THEN rail_signal_67.1 := 0; r67.man_open := 1; END_IF;
IF rail_signal_67.2 THEN rail_signal_67.2 := 0; r67.man_send := 1; END_IF;
IF rail_signal_67.3 THEN rail_signal_67.3 := 0; r67.ok_to_send := 1; END_IF;
IF rail_signal_67.8 THEN rail_signal_67.8 := 0; r67.purge := 1; END_IF;


IF rail_signal_68.0 THEN rail_signal_68.0 := 0; r68.man_open := 0; r68.man_send := 0; r68.ok_to_send := 0; r68.insert := 0; r68.reset := 1; ELSE r68.reset := 0; END_IF;
IF rail_signal_68.1 THEN rail_signal_68.1 := 0; r68.man_open := 1; END_IF;
IF rail_signal_68.2 THEN rail_signal_68.2 := 0; r68.man_send := 1; END_IF;
IF rail_signal_68.3 THEN rail_signal_68.3 := 0; r68.ok_to_send := 1; END_IF;
IF rail_signal_68.8 THEN rail_signal_68.8 := 0; r68.purge := 1; END_IF;


IF rail_signal_69.0 THEN rail_signal_69.0 := 0; r69.man_open := 0; r69.man_send := 0; r69.ok_to_send := 0; r69.insert := 0; r69.reset := 1; ELSE r69.reset := 0; END_IF;
IF rail_signal_69.1 THEN rail_signal_69.1 := 0; r69.man_open := 1; END_IF;
IF rail_signal_69.2 THEN rail_signal_69.2 := 0; r69.man_send := 1; END_IF;
IF rail_signal_69.3 THEN rail_signal_69.3 := 0; r69.ok_to_send := 1; END_IF;
IF rail_signal_69.8 THEN rail_signal_69.8 := 0; r69.purge := 1; END_IF;


IF rail_signal_70.0 THEN rail_signal_70.0 := 0; r70.man_open := 0; r70.man_send := 0; r70.ok_to_send := 0; r70.insert := 0; r70.reset := 1; ELSE r70.reset := 0; END_IF;
IF rail_signal_70.1 THEN rail_signal_70.1 := 0; r70.man_open := 1; END_IF;
IF rail_signal_70.2 THEN rail_signal_70.2 := 0; r70.man_send := 1; END_IF;
IF rail_signal_70.3 THEN rail_signal_70.3 := 0; r70.ok_to_send := 1; END_IF;
IF rail_signal_70.8 THEN rail_signal_70.8 := 0; r70.purge := 1; END_IF;


IF rail_signal_71.0 THEN rail_signal_71.0 := 0; r71.man_open := 0; r71.man_send := 0; r71.ok_to_send := 0; r71.insert := 0; r71.reset := 1; ELSE r71.reset := 0; END_IF;
IF rail_signal_71.1 THEN rail_signal_71.1 := 0; r71.man_open := 1; END_IF;
IF rail_signal_71.2 THEN rail_signal_71.2 := 0; r71.man_send := 1; END_IF;
IF rail_signal_71.3 THEN rail_signal_71.3 := 0; r71.ok_to_send := 1; END_IF;


IF rail_signal_72.0 THEN rail_signal_72.0 := 0; r72.man_open := 0; r72.man_send := 0; r72.ok_to_send := 0; r72.insert := 0; r72.reset := 1; ELSE r72.reset := 0; END_IF;
IF rail_signal_72.1 THEN rail_signal_72.1 := 0; r72.man_open := 1; END_IF;
IF rail_signal_72.2 THEN rail_signal_72.2 := 0; r72.man_send := 1; END_IF;
IF rail_signal_72.3 THEN rail_signal_72.3 := 0; r72.ok_to_send := 1; END_IF;


IF rail_signal_73.0 THEN rail_signal_73.0 := 0; r73.man_open := 0; r73.man_send := 0; r73.ok_to_send := 0; r73.insert := 0; r73.reset := 1; ELSE r73.reset := 0; END_IF;
IF rail_signal_73.1 THEN rail_signal_73.1 := 0; r73.man_open := 1; END_IF;
IF rail_signal_73.2 THEN rail_signal_73.2 := 0; r73.man_send := 1; END_IF;
IF rail_signal_73.3 THEN rail_signal_73.3 := 0; r73.ok_to_send := 1; END_IF;


IF rail_signal_74.0 THEN rail_signal_74.0 := 0; r74.man_open := 0; r74.man_send := 0; r74.ok_to_send := 0; r74.insert := 0; r74.reset := 1; ELSE r74.reset := 0; END_IF;
IF rail_signal_74.1 THEN rail_signal_74.1 := 0; r74.man_open := 1; END_IF;
IF rail_signal_74.2 THEN rail_signal_74.2 := 0; r74.man_send := 1; END_IF;
IF rail_signal_74.3 THEN rail_signal_74.3 := 0; r74.ok_to_send := 1; END_IF;


validation_alarm := server_status.0;
halted := server_status.1;
soiled_validation_alarm := server_status.2;
clean_validation_alarm := server_status.3;


r1.onoff         := rail_status_1.0;
r1.rail_mt       := rail_status_1.1;
r1.rail_full     := rail_status_1.2;
r1.input_enabled := rail_status_1.3;

r2.onoff         := rail_status_2.0;
r2.rail_mt       := rail_status_2.1;
r2.rail_full     := rail_status_2.2;
r2.input_enabled := rail_status_2.3;

r3.onoff         := rail_status_3.0;
r3.rail_mt       := rail_status_3.1;
r3.rail_full     := rail_status_3.2;
r3.input_enabled := rail_status_3.3;

r4.onoff         := rail_status_4.0;
r4.rail_mt       := rail_status_4.1;
r4.rail_full     := rail_status_4.2;
r4.input_enabled := rail_status_4.3;

r5.onoff         := rail_status_5.0;
r5.rail_mt       := rail_status_5.1;
r5.rail_full     := rail_status_5.2;
r5.input_enabled := rail_status_5.3;

r6.onoff         := rail_status_6.0;
r6.rail_mt       := rail_status_6.1;
r6.rail_full     := rail_status_6.2;
r6.input_enabled := rail_status_6.3;

r7.onoff         := rail_status_7.0;
r7.rail_mt       := rail_status_7.1;
r7.rail_full     := rail_status_7.2;
r7.input_enabled := rail_status_7.3;

r8.onoff         := rail_status_8.0;
r8.rail_mt       := rail_status_8.1;
r8.rail_full     := rail_status_8.2;
r8.input_enabled := rail_status_8.3;

r9.onoff         := rail_status_9.0;
r9.rail_mt       := rail_status_9.1;
r9.rail_full     := rail_status_9.2;
r9.input_enabled := rail_status_9.3;

r10.onoff         := rail_status_10.0;
r10.rail_mt       := rail_status_10.1;
r10.rail_full     := rail_status_10.2;
r10.input_enabled := rail_status_10.3;

r11.onoff         := rail_status_11.0;
r11.rail_mt       := rail_status_11.1;
r11.rail_full     := rail_status_11.2;
r11.input_enabled := rail_status_11.3;

r12.onoff         := rail_status_12.0;
r12.rail_mt       := rail_status_12.1;
r12.rail_full     := rail_status_12.2;
r12.input_enabled := rail_status_12.3;

r13.onoff         := rail_status_13.0;
r13.rail_mt       := rail_status_13.1;
r13.rail_full     := rail_status_13.2;
r13.input_enabled := rail_status_13.3;

r14.onoff         := rail_status_14.0;
r14.rail_mt       := rail_status_14.1;
r14.rail_full     := rail_status_14.2;
r14.input_enabled := rail_status_14.3;

r15.onoff         := rail_status_15.0;
r15.rail_mt       := rail_status_15.1;
r15.rail_full     := rail_status_15.2;
r15.input_enabled := rail_status_15.3;

r16.onoff         := rail_status_16.0;
r16.rail_mt       := rail_status_16.1;
r16.rail_full     := rail_status_16.2;
r16.input_enabled := rail_status_16.3;

r17.onoff         := rail_status_17.0;
r17.rail_mt       := rail_status_17.1;
r17.rail_full     := rail_status_17.2;
r17.input_enabled := rail_status_17.3;

r18.onoff         := rail_status_18.0;
r18.rail_mt       := rail_status_18.1;
r18.rail_full     := rail_status_18.2;
r18.input_enabled := rail_status_18.3;

r19.onoff         := rail_status_19.0;
r19.rail_mt       := rail_status_19.1;
r19.rail_full     := rail_status_19.2;
r19.input_enabled := rail_status_19.3;

r20.onoff         := rail_status_20.0;
r20.rail_mt       := rail_status_20.1;
r20.rail_full     := rail_status_20.2;
r20.input_enabled := rail_status_20.3;

r21.onoff         := rail_status_21.0;
r21.rail_mt       := rail_status_21.1;
r21.rail_full     := rail_status_21.2;
r21.input_enabled := rail_status_21.3;

r22.onoff         := rail_status_22.0;
r22.rail_mt       := rail_status_22.1;
r22.rail_full     := rail_status_22.2;
r22.input_enabled := rail_status_22.3;

r23.onoff         := rail_status_23.0;
r23.rail_mt       := rail_status_23.1;
r23.rail_full     := rail_status_23.2;
r23.input_enabled := rail_status_23.3;

r24.onoff         := rail_status_24.0;
r24.rail_mt       := rail_status_24.1;
r24.rail_full     := rail_status_24.2;
r24.input_enabled := rail_status_24.3;

r25.onoff         := rail_status_25.0;
r25.rail_mt       := rail_status_25.1;
r25.rail_full     := rail_status_25.2;
r25.input_enabled := rail_status_25.3;

r26.onoff         := rail_status_26.0;
r26.rail_mt       := rail_status_26.1;
r26.rail_full     := rail_status_26.2;
r26.input_enabled := rail_status_26.3;

r27.onoff         := rail_status_27.0;
r27.rail_mt       := rail_status_27.1;
r27.rail_full     := rail_status_27.2;
r27.input_enabled := rail_status_27.3;

r28.onoff         := rail_status_28.0;
r28.rail_mt       := rail_status_28.1;
r28.rail_full     := rail_status_28.2;
r28.input_enabled := rail_status_28.3;

r29.onoff         := rail_status_29.0;
r29.rail_mt       := rail_status_29.1;
r29.rail_full     := rail_status_29.2;
r29.input_enabled := rail_status_29.3;

r30.onoff         := rail_status_30.0;
r30.rail_mt       := rail_status_30.1;
r30.rail_full     := rail_status_30.2;
r30.input_enabled := rail_status_30.3;

r31.onoff         := rail_status_31.0;
r31.rail_mt       := rail_status_31.1;
r31.rail_full     := rail_status_31.2;
r31.input_enabled := rail_status_31.3;

r32.onoff         := rail_status_32.0;
r32.rail_mt       := rail_status_32.1;
r32.rail_full     := rail_status_32.2;
r32.input_enabled := rail_status_32.3;

r33.onoff         := rail_status_33.0;
r33.rail_mt       := rail_status_33.1;
r33.rail_full     := rail_status_33.2;
r33.input_enabled := rail_status_33.3;

r34.onoff         := rail_status_34.0;
r34.rail_mt       := rail_status_34.1;
r34.rail_full     := rail_status_34.2;
r34.input_enabled := rail_status_34.3;

r35.onoff         := rail_status_35.0;
r35.rail_mt       := rail_status_35.1;
r35.rail_full     := rail_status_35.2;
r35.input_enabled := rail_status_35.3;

r36.onoff         := rail_status_36.0;
r36.rail_mt       := rail_status_36.1;
r36.rail_full     := rail_status_36.2;
r36.input_enabled := rail_status_36.3;

r37.onoff         := rail_status_37.0;
r37.rail_mt       := rail_status_37.1;
r37.rail_full     := rail_status_37.2;
r37.input_enabled := rail_status_37.3;

r38.onoff         := rail_status_38.0;
r38.rail_mt       := rail_status_38.1;
r38.rail_full     := rail_status_38.2;
r38.input_enabled := rail_status_38.3;

r39.onoff         := rail_status_39.0;
r39.rail_mt       := rail_status_39.1;
r39.rail_full     := rail_status_39.2;
r39.input_enabled := rail_status_39.3;

r40.onoff         := rail_status_40.0;
r40.rail_mt       := rail_status_40.1;
r40.rail_full     := rail_status_40.2;
r40.input_enabled := rail_status_40.3;

r41.onoff         := rail_status_41.0;
r41.rail_mt       := rail_status_41.1;
r41.rail_full     := rail_status_41.2;
r41.input_enabled := rail_status_41.3;

r42.onoff         := rail_status_42.0;
r42.rail_mt       := rail_status_42.1;
r42.rail_full     := rail_status_42.2;
r42.input_enabled := rail_status_42.3;

r43.onoff         := rail_status_43.0;
r43.rail_mt       := rail_status_43.1;
r43.rail_full     := rail_status_43.2;
r43.input_enabled := rail_status_43.3;

r44.onoff         := rail_status_44.0;
r44.rail_mt       := rail_status_44.1;
r44.rail_full     := rail_status_44.2;
r44.input_enabled := rail_status_44.3;

r45.onoff         := rail_status_45.0;
r45.rail_mt       := rail_status_45.1;
r45.rail_full     := rail_status_45.2;
r45.input_enabled := rail_status_45.3;

r46.onoff         := rail_status_46.0;
r46.rail_mt       := rail_status_46.1;
r46.rail_full     := rail_status_46.2;
r46.input_enabled := rail_status_46.3;

r47.onoff         := rail_status_47.0;
r47.rail_mt       := rail_status_47.1;
r47.rail_full     := rail_status_47.2;
r47.input_enabled := rail_status_47.3;

r48.onoff         := rail_status_48.0;
r48.rail_mt       := rail_status_48.1;
r48.rail_full     := rail_status_48.2;
r48.input_enabled := rail_status_48.3;

r49.onoff         := rail_status_49.0;
r49.rail_mt       := rail_status_49.1;
r49.rail_full     := rail_status_49.2;
r49.input_enabled := rail_status_49.3;

r50.onoff         := rail_status_50.0;
r50.rail_mt       := rail_status_50.1;
r50.rail_full     := rail_status_50.2;
r50.input_enabled := rail_status_50.3;

r51.onoff         := rail_status_51.0;
r51.rail_mt       := rail_status_51.1;
r51.rail_full     := rail_status_51.2;
r51.input_enabled := rail_status_51.3;

r52.onoff         := rail_status_52.0;
r52.rail_mt       := rail_status_52.1;
r52.rail_full     := rail_status_52.2;
r52.input_enabled := rail_status_52.3;

r53.onoff         := rail_status_53.0;
r53.rail_mt       := rail_status_53.1;
r53.rail_full     := rail_status_53.2;
r53.input_enabled := rail_status_53.3;

r54.onoff         := rail_status_54.0;
r54.rail_mt       := rail_status_54.1;
r54.rail_full     := rail_status_54.2;
r54.input_enabled := rail_status_54.3;

r55.onoff         := rail_status_55.0;
r55.rail_mt       := rail_status_55.1;
r55.rail_full     := rail_status_55.2;
r55.input_enabled := rail_status_55.3;

r56.onoff         := rail_status_56.0;
r56.rail_mt       := rail_status_56.1;
r56.rail_full     := rail_status_56.2;
r56.input_enabled := rail_status_56.3;

r57.onoff         := rail_status_57.0;
r57.rail_mt       := rail_status_57.1;
r57.rail_full     := rail_status_57.2;
r57.input_enabled := rail_status_57.3;

r58.onoff         := rail_status_58.0;
r58.rail_mt       := rail_status_58.1;
r58.rail_full     := rail_status_58.2;
r58.input_enabled := rail_status_58.3;

r59.onoff         := rail_status_59.0;
r59.rail_mt       := rail_status_59.1;
r59.rail_full     := rail_status_59.2;
r59.input_enabled := rail_status_59.3;

r60.onoff         := rail_status_60.0;
r60.rail_mt       := rail_status_60.1;
r60.rail_full     := rail_status_60.2;
r60.input_enabled := rail_status_60.3;

r61.onoff         := rail_status_61.0;
r61.rail_mt       := rail_status_61.1;
r61.rail_full     := rail_status_61.2;
r61.input_enabled := rail_status_61.3;

r62.onoff         := rail_status_62.0;
r62.rail_mt       := rail_status_62.1;
r62.rail_full     := rail_status_62.2;
r62.input_enabled := rail_status_62.3;

r63.onoff         := rail_status_63.0;
r63.rail_mt       := rail_status_63.1;
r63.rail_full     := rail_status_63.2;
r63.input_enabled := rail_status_63.3;

r64.onoff         := rail_status_64.0;
r64.rail_mt       := rail_status_64.1;
r64.rail_full     := rail_status_64.2;
r64.input_enabled := rail_status_64.3;

r65.onoff         := rail_status_65.0;
r65.rail_mt       := rail_status_65.1;
r65.rail_full     := rail_status_65.2;
r65.input_enabled := rail_status_65.3;

r66.onoff         := rail_status_66.0;
r66.rail_mt       := rail_status_66.1;
r66.rail_full     := rail_status_66.2;
r66.input_enabled := rail_status_66.3;

r67.onoff         := rail_status_67.0;
r67.rail_mt       := rail_status_67.1;
r67.rail_full     := rail_status_67.2;
r67.input_enabled := rail_status_67.3;

r68.onoff         := rail_status_68.0;
r68.rail_mt       := rail_status_68.1;
r68.rail_full     := rail_status_68.2;
r68.input_enabled := rail_status_68.3;

r69.onoff         := rail_status_69.0;
r69.rail_mt       := rail_status_69.1;
r69.rail_full     := rail_status_69.2;
r69.input_enabled := rail_status_69.3;

r70.onoff         := rail_status_70.0;
r70.rail_mt       := rail_status_70.1;
r70.rail_full     := rail_status_70.2;
r70.input_enabled := rail_status_70.3;

r71.onoff         := rail_status_71.0;
r71.rail_mt       := rail_status_71.1;
r71.rail_full     := rail_status_71.2;
r71.input_enabled := rail_status_71.3;

r72.onoff         := rail_status_72.0;
r72.rail_mt       := rail_status_72.1;
r72.rail_full     := rail_status_72.2;
r72.input_enabled := rail_status_72.3;

r73.onoff         := rail_status_73.0;
r73.rail_mt       := rail_status_73.1;
r73.rail_full     := rail_status_73.2;
r73.input_enabled := rail_status_73.3;

r74.onoff         := rail_status_74.0;
r74.rail_mt       := rail_status_74.1;
r74.rail_full     := rail_status_74.2;
r74.input_enabled := rail_status_74.3;
(*** RESETTING INSERT AND GOING TO ON INSERT RESET ***)

IF r1.insert_reset THEN r1.insert := 0; r1.going_to := 0; END_IF;
IF r2.insert_reset THEN r2.insert := 0; r2.going_to := 0; END_IF;
IF r3.insert_reset THEN r3.insert := 0; r3.going_to := 0; END_IF;
IF r4.insert_reset THEN r4.insert := 0; r4.going_to := 0; END_IF;
IF r5.insert_reset THEN r5.insert := 0; r5.going_to := 0; END_IF;
IF r6.insert_reset THEN r6.insert := 0; r6.going_to := 0; END_IF;
IF r7.insert_reset THEN r7.insert := 0; r7.going_to := 0; END_IF;
IF r8.insert_reset THEN r8.insert := 0; r8.going_to := 0; END_IF;
IF r9.insert_reset THEN r9.insert := 0; r9.going_to := 0; END_IF;
IF r10.insert_reset THEN r10.insert := 0; r10.going_to := 0; END_IF;
IF r11.insert_reset THEN r11.insert := 0; r11.going_to := 0; END_IF;
IF r12.insert_reset THEN r12.insert := 0; r12.going_to := 0; END_IF;
IF r13.insert_reset THEN r13.insert := 0; r13.going_to := 0; END_IF;
IF r14.insert_reset THEN r14.insert := 0; r14.going_to := 0; END_IF;
IF r15.insert_reset THEN r15.insert := 0; r15.going_to := 0; END_IF;
IF r16.insert_reset THEN r16.insert := 0; r16.going_to := 0; END_IF;
IF r17.insert_reset THEN r17.insert := 0; r17.going_to := 0; END_IF;
IF r18.insert_reset THEN r18.insert := 0; r18.going_to := 0; END_IF;
IF r19.insert_reset THEN r19.insert := 0; r19.going_to := 0; END_IF;
IF r20.insert_reset THEN r20.insert := 0; r20.going_to := 0; END_IF;
IF r21.insert_reset THEN r21.insert := 0; r21.going_to := 0; END_IF;
IF r22.insert_reset THEN r22.insert := 0; r22.going_to := 0; END_IF;
IF r23.insert_reset THEN r23.insert := 0; r23.going_to := 0; END_IF;
IF r24.insert_reset THEN r24.insert := 0; r24.going_to := 0; END_IF;
IF r25.insert_reset THEN r25.insert := 0; r25.going_to := 0; END_IF;
IF r26.insert_reset THEN r26.insert := 0; r26.going_to := 0; END_IF;
IF r27.insert_reset THEN r27.insert := 0; r27.going_to := 0; END_IF;
IF r28.insert_reset THEN r28.insert := 0; r28.going_to := 0; END_IF;
IF r29.insert_reset THEN r29.insert := 0; r29.going_to := 0; END_IF;
IF r30.insert_reset THEN r30.insert := 0; r30.going_to := 0; END_IF;
IF r31.insert_reset THEN r31.insert := 0; r31.going_to := 0; END_IF;
IF r32.insert_reset THEN r32.insert := 0; r32.going_to := 0; END_IF;
IF r33.insert_reset THEN r33.insert := 0; r33.going_to := 0; END_IF;
IF r34.insert_reset THEN r34.insert := 0; r34.going_to := 0; END_IF;
IF r35.insert_reset THEN r35.insert := 0; r35.going_to := 0; END_IF;
IF r36.insert_reset THEN r36.insert := 0; r36.going_to := 0; END_IF;
IF r37.insert_reset THEN r37.insert := 0; r37.going_to := 0; END_IF;
IF r38.insert_reset THEN r38.insert := 0; r38.going_to := 0; END_IF;
IF r39.insert_reset THEN r39.insert := 0; r39.going_to := 0; END_IF;
IF r40.insert_reset THEN r40.insert := 0; r40.going_to := 0; END_IF;
IF r41.insert_reset THEN r41.insert := 0; r41.going_to := 0; END_IF;
IF r42.insert_reset THEN r42.insert := 0; r42.going_to := 0; END_IF;
IF r43.insert_reset THEN r43.insert := 0; r43.going_to := 0; END_IF;
IF r44.insert_reset THEN r44.insert := 0; r44.going_to := 0; END_IF;
IF r45.insert_reset THEN r45.insert := 0; r45.going_to := 0; END_IF;
IF r46.insert_reset THEN r46.insert := 0; r46.going_to := 0; END_IF;
IF r47.insert_reset THEN r47.insert := 0; r47.going_to := 0; END_IF;
IF r48.insert_reset THEN r48.insert := 0; r48.going_to := 0; END_IF;
IF r49.insert_reset THEN r49.insert := 0; r49.going_to := 0; END_IF;
IF r50.insert_reset THEN r50.insert := 0; r50.going_to := 0; END_IF;
IF r51.insert_reset THEN r51.insert := 0; r51.going_to := 0; END_IF;
IF r52.insert_reset THEN r52.insert := 0; r52.going_to := 0; END_IF;
IF r53.insert_reset THEN r53.insert := 0; r53.going_to := 0; END_IF;
IF r54.insert_reset THEN r54.insert := 0; r54.going_to := 0; END_IF;
IF r55.insert_reset THEN r55.insert := 0; r55.going_to := 0; END_IF;
IF r56.insert_reset THEN r56.insert := 0; r56.going_to := 0; END_IF;
IF r57.insert_reset THEN r57.insert := 0; r57.going_to := 0; END_IF;
IF r58.insert_reset THEN r58.insert := 0; r58.going_to := 0; END_IF;
IF r59.insert_reset THEN r59.insert := 0; r59.going_to := 0; END_IF;
IF r60.insert_reset THEN r60.insert := 0; r60.going_to := 0; END_IF;
IF r61.insert_reset THEN r61.insert := 0; r61.going_to := 0; END_IF;
IF r62.insert_reset THEN r62.insert := 0; r62.going_to := 0; END_IF;
IF r63.insert_reset THEN r63.insert := 0; r63.going_to := 0; END_IF;
IF r64.insert_reset THEN r64.insert := 0; r64.going_to := 0; END_IF;
IF r65.insert_reset THEN r65.insert := 0; r65.going_to := 0; END_IF;
IF r66.insert_reset THEN r66.insert := 0; r66.going_to := 0; END_IF;
IF r67.insert_reset THEN r67.insert := 0; r67.going_to := 0; END_IF;
IF r68.insert_reset THEN r68.insert := 0; r68.going_to := 0; END_IF;
IF r69.insert_reset THEN r69.insert := 0; r69.going_to := 0; END_IF;
IF r70.insert_reset THEN r70.insert := 0; r70.going_to := 0; END_IF;
IF r71.insert_reset THEN r71.insert := 0; r71.going_to := 0; END_IF;
IF r72.insert_reset THEN r72.insert := 0; r72.going_to := 0; END_IF;
IF r73.insert_reset THEN r73.insert := 0; r73.going_to := 0; END_IF;
IF r74.insert_reset THEN r74.insert := 0; r74.going_to := 0; END_IF;


(*** RAIL DEST MAPPING FOR RAIL DESTINATIONS ***)

DEST_SIZE := rail_destination_1;
DEST_RAIL := 0;
DEST_NUM := 0;
IF DEST_SIZE > 0 THEN
	FOR DEST_INDEX := 1 TO DEST_SIZE DO
		CASE DEST_INDEX OF
		1:	DEST_RAIL := rail_destination_2; DEST_NUM := rail_destination_3;
		2:	DEST_RAIL := rail_destination_4; DEST_NUM := rail_destination_5;
		3:	DEST_RAIL := rail_destination_6; DEST_NUM := rail_destination_7;
		4:	DEST_RAIL := rail_destination_8; DEST_NUM := rail_destination_9;
		5:	DEST_RAIL := rail_destination_10; DEST_NUM := rail_destination_11;
		6:	DEST_RAIL := rail_destination_12; DEST_NUM := rail_destination_13;
		7:	DEST_RAIL := rail_destination_14; DEST_NUM := rail_destination_15;
		8:	DEST_RAIL := rail_destination_16; DEST_NUM := rail_destination_17;
		9:	DEST_RAIL := rail_destination_18; DEST_NUM := rail_destination_19;
		10:	DEST_RAIL := rail_destination_20; DEST_NUM := rail_destination_21;
		11:	DEST_RAIL := rail_destination_22; DEST_NUM := rail_destination_23;
		12:	DEST_RAIL := rail_destination_24; DEST_NUM := rail_destination_25;
		13:	DEST_RAIL := rail_destination_26; DEST_NUM := rail_destination_27;
		14:	DEST_RAIL := rail_destination_28; DEST_NUM := rail_destination_29;
		15:	DEST_RAIL := rail_destination_30; DEST_NUM := rail_destination_31;
		16:	DEST_RAIL := rail_destination_32; DEST_NUM := rail_destination_33;
		17:	DEST_RAIL := rail_destination_34; DEST_NUM := rail_destination_35;
		18:	DEST_RAIL := rail_destination_36; DEST_NUM := rail_destination_37;
		19:	DEST_RAIL := rail_destination_38; DEST_NUM := rail_destination_39;
		20:	DEST_RAIL := rail_destination_40; DEST_NUM := rail_destination_41;
		21:	DEST_RAIL := rail_destination_42; DEST_NUM := rail_destination_43;
		22:	DEST_RAIL := rail_destination_44; DEST_NUM := rail_destination_45;
		23:	DEST_RAIL := rail_destination_46; DEST_NUM := rail_destination_47;
		24:	DEST_RAIL := rail_destination_48; DEST_NUM := rail_destination_49;
		25:	DEST_RAIL := rail_destination_50; DEST_NUM := rail_destination_51;
		26:	DEST_RAIL := rail_destination_52; DEST_NUM := rail_destination_53;
		27:	DEST_RAIL := rail_destination_54; DEST_NUM := rail_destination_55;
		28:	DEST_RAIL := rail_destination_56; DEST_NUM := rail_destination_57;
		29:	DEST_RAIL := rail_destination_58; DEST_NUM := rail_destination_59;
		30:	DEST_RAIL := rail_destination_60; DEST_NUM := rail_destination_61;
		31:	DEST_RAIL := rail_destination_62; DEST_NUM := rail_destination_63;
		32:	DEST_RAIL := rail_destination_64; DEST_NUM := rail_destination_65;
		33:	DEST_RAIL := rail_destination_66; DEST_NUM := rail_destination_67;
		34:	DEST_RAIL := rail_destination_68; DEST_NUM := rail_destination_69;
		35:	DEST_RAIL := rail_destination_70; DEST_NUM := rail_destination_71;
		36:	DEST_RAIL := rail_destination_72; DEST_NUM := rail_destination_73;
		37:	DEST_RAIL := rail_destination_74; DEST_NUM := rail_destination_75;
		38:	DEST_RAIL := rail_destination_76; DEST_NUM := rail_destination_77;
		39:	DEST_RAIL := rail_destination_78; DEST_NUM := rail_destination_79;
		40:	DEST_RAIL := rail_destination_80; DEST_NUM := rail_destination_81;
		41:	DEST_RAIL := rail_destination_82; DEST_NUM := rail_destination_83;
		42:	DEST_RAIL := rail_destination_84; DEST_NUM := rail_destination_85;
		43:	DEST_RAIL := rail_destination_86; DEST_NUM := rail_destination_87;
		44:	DEST_RAIL := rail_destination_88; DEST_NUM := rail_destination_89;
		45:	DEST_RAIL := rail_destination_90; DEST_NUM := rail_destination_91;
		46:	DEST_RAIL := rail_destination_92; DEST_NUM := rail_destination_93;
		47:	DEST_RAIL := rail_destination_94; DEST_NUM := rail_destination_95;
		48:	DEST_RAIL := rail_destination_96; DEST_NUM := rail_destination_97;
		49:	DEST_RAIL := rail_destination_98; DEST_NUM := rail_destination_99;
		50:	DEST_RAIL := rail_destination_100; DEST_NUM := rail_destination_101;
		END_CASE;
		CASE DEST_RAIL OF
		1:	r1.destination := DEST_NUM;
		2:	r2.destination := DEST_NUM;
		3:	r3.destination := DEST_NUM;
		4:	r4.destination := DEST_NUM;
		5:	r5.destination := DEST_NUM;
		6:	r6.destination := DEST_NUM;
		7:	r7.destination := DEST_NUM;
		8:	r8.destination := DEST_NUM;
		9:	r9.destination := DEST_NUM;
		10:	r10.destination := DEST_NUM;
		11:	r11.destination := DEST_NUM;
		12:	r12.destination := DEST_NUM;
		13:	r13.destination := DEST_NUM;
		14:	r14.destination := DEST_NUM;
		15:	r15.destination := DEST_NUM;
		16:	r16.destination := DEST_NUM;
		17:	r17.destination := DEST_NUM;
		18:	r18.destination := DEST_NUM;
		19:	r19.destination := DEST_NUM;
		20:	r20.destination := DEST_NUM;
		21:	r21.destination := DEST_NUM;
		22:	r22.destination := DEST_NUM;
		23:	r23.destination := DEST_NUM;
		24:	r24.destination := DEST_NUM;
		25:	r25.destination := DEST_NUM;
		26:	r26.destination := DEST_NUM;
		27:	r27.destination := DEST_NUM;
		28:	r28.destination := DEST_NUM;
		29:	r29.destination := DEST_NUM;
		30:	r30.destination := DEST_NUM;
		31:	r31.destination := DEST_NUM;
		32:	r32.destination := DEST_NUM;
		33:	r33.destination := DEST_NUM;
		34:	r34.destination := DEST_NUM;
		35:	r35.destination := DEST_NUM;
		36:	r36.destination := DEST_NUM;
		37:	r37.destination := DEST_NUM;
		38:	r38.destination := DEST_NUM;
		39:	r39.destination := DEST_NUM;
		40:	r40.destination := DEST_NUM;
		41:	r41.destination := DEST_NUM;
		42:	r42.destination := DEST_NUM;
		43:	r43.destination := DEST_NUM;
		44:	r44.destination := DEST_NUM;
		45:	r45.destination := DEST_NUM;
		46:	r46.destination := DEST_NUM;
		47:	r47.destination := DEST_NUM;
		48:	r48.destination := DEST_NUM;
		49:	r49.destination := DEST_NUM;
		50:	r50.destination := DEST_NUM;
		51:	r51.destination := DEST_NUM;
		52:	r52.destination := DEST_NUM;
		53:	r53.destination := DEST_NUM;
		54:	r54.destination := DEST_NUM;
		55:	r55.destination := DEST_NUM;
		56:	r56.destination := DEST_NUM;
		57:	r57.destination := DEST_NUM;
		58:	r58.destination := DEST_NUM;
		59:	r59.destination := DEST_NUM;
		60:	r60.destination := DEST_NUM;
		61:	r61.destination := DEST_NUM;
		62:	r62.destination := DEST_NUM;
		63:	r63.destination := DEST_NUM;
		64:	r64.destination := DEST_NUM;
		65:	r65.destination := DEST_NUM;
		66:	r66.destination := DEST_NUM;
		67:	r67.destination := DEST_NUM;
		68:	r68.destination := DEST_NUM;
		69:	r69.destination := DEST_NUM;
		70:	r70.destination := DEST_NUM;
		71:	r71.destination := DEST_NUM;
		72:	r72.destination := DEST_NUM;
		73:	r73.destination := DEST_NUM;
		74:	r74.destination := DEST_NUM;
		END_CASE;
	END_FOR;
END_IF;
rail_destination_1 := 0;
rail_destination_2 := 0;
rail_destination_3 := 0;
rail_destination_4 := 0;
rail_destination_5 := 0;
rail_destination_6 := 0;
rail_destination_7 := 0;
rail_destination_8 := 0;
rail_destination_9 := 0;
rail_destination_10 := 0;
rail_destination_11 := 0;
rail_destination_12 := 0;
rail_destination_13 := 0;
rail_destination_14 := 0;
rail_destination_15 := 0;
rail_destination_16 := 0;
rail_destination_17 := 0;
rail_destination_18 := 0;
rail_destination_19 := 0;
rail_destination_20 := 0;
rail_destination_21 := 0;
rail_destination_22 := 0;
rail_destination_23 := 0;
rail_destination_24 := 0;
rail_destination_25 := 0;
rail_destination_26 := 0;
rail_destination_27 := 0;
rail_destination_28 := 0;
rail_destination_29 := 0;
rail_destination_30 := 0;
rail_destination_31 := 0;
rail_destination_32 := 0;
rail_destination_33 := 0;
rail_destination_34 := 0;
rail_destination_35 := 0;
rail_destination_36 := 0;
rail_destination_37 := 0;
rail_destination_38 := 0;
rail_destination_39 := 0;
rail_destination_40 := 0;
rail_destination_41 := 0;
rail_destination_42 := 0;
rail_destination_43 := 0;
rail_destination_44 := 0;
rail_destination_45 := 0;
rail_destination_46 := 0;
rail_destination_47 := 0;
rail_destination_48 := 0;
rail_destination_49 := 0;
rail_destination_50 := 0;
rail_destination_51 := 0;
rail_destination_52 := 0;
rail_destination_53 := 0;
rail_destination_54 := 0;
rail_destination_55 := 0;
rail_destination_56 := 0;
rail_destination_57 := 0;
rail_destination_58 := 0;
rail_destination_59 := 0;
rail_destination_60 := 0;
rail_destination_61 := 0;
rail_destination_62 := 0;
rail_destination_63 := 0;
rail_destination_64 := 0;
rail_destination_65 := 0;
rail_destination_66 := 0;
rail_destination_67 := 0;
rail_destination_68 := 0;
rail_destination_69 := 0;
rail_destination_70 := 0;
rail_destination_71 := 0;
rail_destination_72 := 0;
rail_destination_73 := 0;
rail_destination_74 := 0;
rail_destination_75 := 0;
rail_destination_76 := 0;
rail_destination_77 := 0;
rail_destination_78 := 0;
rail_destination_79 := 0;
rail_destination_80 := 0;
rail_destination_81 := 0;
rail_destination_82 := 0;
rail_destination_83 := 0;
rail_destination_84 := 0;
rail_destination_85 := 0;
rail_destination_86 := 0;
rail_destination_87 := 0;
rail_destination_88 := 0;
rail_destination_89 := 0;
rail_destination_90 := 0;
rail_destination_91 := 0;
rail_destination_92 := 0;
rail_destination_93 := 0;
rail_destination_94 := 0;
rail_destination_95 := 0;
rail_destination_96 := 0;
rail_destination_97 := 0;
rail_destination_98 := 0;
rail_destination_99 := 0;
rail_destination_100 := 0;
rail_destination_101 := 0;


(*** RESET CLEARING DEST, FIRE, AND GOING_TO ***)


(*** Rail 1 ***)
IF r1.reset THEN
	r1.fire := 0;
	IF r1.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r1.destination := 0;
END_IF;

(*** Rail 2 ***)
IF r2.reset THEN
	r2.fire := 0;
	IF r2.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r2.destination := 0;
END_IF;

(*** Rail 3 ***)
IF r3.reset THEN
	r3.fire := 0;
	IF r3.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r3.destination := 0;
END_IF;

(*** Rail 4 ***)
IF r4.reset THEN
	r4.fire := 0;
	IF r4.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r4.destination := 0;
END_IF;

(*** Rail 5 ***)
IF r5.reset THEN
	r5.fire := 0;
	IF r5.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r5.destination := 0;
END_IF;

(*** Rail 6 ***)
IF r6.reset THEN
	r6.fire := 0;
	IF r6.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r6.destination := 0;
END_IF;

(*** Rail 7 ***)
IF r7.reset THEN
	r7.fire := 0;
	IF r7.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r7.destination := 0;
END_IF;

(*** Rail 8 ***)
IF r8.reset THEN
	r8.fire := 0;
	IF r8.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r8.destination := 0;
END_IF;

(*** Rail 9 ***)
IF r9.reset THEN
	r9.fire := 0;
	IF r9.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r9.destination := 0;
END_IF;

(*** Rail 10 ***)
IF r10.reset THEN
	r10.fire := 0;
	IF r10.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r10.destination := 0;
END_IF;

(*** Rail 11 ***)
IF r11.reset THEN
	r11.fire := 0;
	IF r11.destination = 61 THEN
		r61.going_to := 0;
	END_IF;
	r11.destination := 0;
END_IF;

(*** Rail 12 ***)
IF r12.reset THEN
	r12.fire := 0;
	IF r12.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r12.destination := 0;
END_IF;

(*** Rail 13 ***)
IF r13.reset THEN
	r13.fire := 0;
	IF r13.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r13.destination := 0;
END_IF;

(*** Rail 14 ***)
IF r14.reset THEN
	r14.fire := 0;
	IF r14.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r14.destination := 0;
END_IF;

(*** Rail 15 ***)
IF r15.reset THEN
	r15.fire := 0;
	IF r15.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r15.destination := 0;
END_IF;

(*** Rail 16 ***)
IF r16.reset THEN
	r16.fire := 0;
	IF r16.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r16.destination := 0;
END_IF;

(*** Rail 17 ***)
IF r17.reset THEN
	r17.fire := 0;
	IF r17.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r17.destination := 0;
END_IF;

(*** Rail 18 ***)
IF r18.reset THEN
	r18.fire := 0;
	IF r18.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r18.destination := 0;
END_IF;

(*** Rail 19 ***)
IF r19.reset THEN
	r19.fire := 0;
	IF r19.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r19.destination := 0;
END_IF;

(*** Rail 20 ***)
IF r20.reset THEN
	r20.fire := 0;
	IF r20.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r20.destination := 0;
END_IF;

(*** Rail 21 ***)
IF r21.reset THEN
	r21.fire := 0;
	IF r21.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r21.destination := 0;
END_IF;

(*** Rail 22 ***)
IF r22.reset THEN
	r22.fire := 0;
	IF r22.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r22.destination := 0;
END_IF;

(*** Rail 23 ***)
IF r23.reset THEN
	r23.fire := 0;
	IF r23.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r23.destination := 0;
END_IF;

(*** Rail 24 ***)
IF r24.reset THEN
	r24.fire := 0;
	IF r24.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r24.destination := 0;
END_IF;

(*** Rail 25 ***)
IF r25.reset THEN
	r25.fire := 0;
	IF r25.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r25.destination := 0;
END_IF;

(*** Rail 26 ***)
IF r26.reset THEN
	r26.fire := 0;
	IF r26.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r26.destination := 0;
END_IF;

(*** Rail 27 ***)
IF r27.reset THEN
	r27.fire := 0;
	IF r27.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r27.destination := 0;
END_IF;

(*** Rail 28 ***)
IF r28.reset THEN
	r28.fire := 0;
	IF r28.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r28.destination := 0;
END_IF;

(*** Rail 29 ***)
IF r29.reset THEN
	r29.fire := 0;
	IF r29.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r29.destination := 0;
END_IF;

(*** Rail 30 ***)
IF r30.reset THEN
	r30.fire := 0;
	IF r30.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r30.destination := 0;
END_IF;

(*** Rail 31 ***)
IF r31.reset THEN
	r31.fire := 0;
	IF r31.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r31.destination := 0;
END_IF;

(*** Rail 32 ***)
IF r32.reset THEN
	r32.fire := 0;
	IF r32.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r32.destination := 0;
END_IF;

(*** Rail 33 ***)
IF r33.reset THEN
	r33.fire := 0;
	IF r33.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r33.destination := 0;
END_IF;

(*** Rail 34 ***)
IF r34.reset THEN
	r34.fire := 0;
	IF r34.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r34.destination := 0;
END_IF;

(*** Rail 35 ***)
IF r35.reset THEN
	r35.fire := 0;
	IF r35.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r35.destination := 0;
END_IF;

(*** Rail 36 ***)
IF r36.reset THEN
	r36.fire := 0;
	IF r36.destination = 63 THEN
		r63.going_to := 0;
	END_IF;
	r36.destination := 0;
END_IF;

(*** Rail 37 ***)
IF r37.reset THEN
	r37.fire := 0;
	IF r37.destination = 66 THEN
		r66.going_to := 0;
	END_IF;
	r37.destination := 0;
END_IF;

(*** Rail 38 ***)
IF r38.reset THEN
	r38.fire := 0;
	IF r38.destination = 66 THEN
		r66.going_to := 0;
	END_IF;
	r38.destination := 0;
END_IF;

(*** Rail 39 ***)
IF r39.reset THEN
	r39.fire := 0;
	IF r39.destination = 66 THEN
		r66.going_to := 0;
	END_IF;
	r39.destination := 0;
END_IF;

(*** Rail 40 ***)
IF r40.reset THEN
	r40.fire := 0;
	IF r40.destination = 66 THEN
		r66.going_to := 0;
	END_IF;
	r40.destination := 0;
END_IF;

(*** Rail 41 ***)
IF r41.reset THEN
	r41.fire := 0;
	IF r41.destination = 66 THEN
		r66.going_to := 0;
	END_IF;
	r41.destination := 0;
END_IF;

(*** Rail 42 ***)
IF r42.reset THEN
	r42.fire := 0;
	IF r42.destination = 66 THEN
		r66.going_to := 0;
	END_IF;
	r42.destination := 0;
END_IF;

(*** Rail 43 ***)
IF r43.reset THEN
	r43.fire := 0;
	IF r43.destination = 65 THEN
		r65.going_to := 0;
	END_IF;
	r43.destination := 0;
END_IF;

(*** Rail 44 ***)
IF r44.reset THEN
	r44.fire := 0;
	IF r44.destination = 65 THEN
		r65.going_to := 0;
	END_IF;
	r44.destination := 0;
END_IF;

(*** Rail 45 ***)
IF r45.reset THEN
	r45.fire := 0;
	IF r45.destination = 65 THEN
		r65.going_to := 0;
	END_IF;
	r45.destination := 0;
END_IF;

(*** Rail 46 ***)
IF r46.reset THEN
	r46.fire := 0;
	IF r46.destination = 65 THEN
		r65.going_to := 0;
	END_IF;
	r46.destination := 0;
END_IF;

(*** Rail 47 ***)
IF r47.reset THEN
	r47.fire := 0;
	IF r47.destination = 65 THEN
		r65.going_to := 0;
	END_IF;
	r47.destination := 0;
END_IF;

(*** Rail 48 ***)
IF r48.reset THEN
	r48.fire := 0;
	IF r48.destination = 65 THEN
		r65.going_to := 0;
	END_IF;
	r48.destination := 0;
END_IF;

(*** Rail 49 ***)
IF r49.reset THEN
	r49.fire := 0;
	IF r49.destination = 69 THEN
		r69.going_to := 0;
	END_IF;
	r49.destination := 0;
END_IF;

(*** Rail 50 ***)
IF r50.reset THEN
	r50.fire := 0;
	IF r50.destination = 69 THEN
		r69.going_to := 0;
	END_IF;
	r50.destination := 0;
END_IF;

(*** Rail 51 ***)
IF r51.reset THEN
	r51.fire := 0;
	IF r51.destination = 69 THEN
		r69.going_to := 0;
	END_IF;
	r51.destination := 0;
END_IF;

(*** Rail 52 ***)
IF r52.reset THEN
	r52.fire := 0;
	IF r52.destination = 69 THEN
		r69.going_to := 0;
	END_IF;
	r52.destination := 0;
END_IF;

(*** Rail 53 ***)
IF r53.reset THEN
	r53.fire := 0;
	IF r53.destination = 69 THEN
		r69.going_to := 0;
	END_IF;
	r53.destination := 0;
END_IF;

(*** Rail 54 ***)
IF r54.reset THEN
	r54.fire := 0;
	IF r54.destination = 69 THEN
		r69.going_to := 0;
	END_IF;
	r54.destination := 0;
END_IF;

(*** Rail 55 ***)
IF r55.reset THEN
	r55.fire := 0;
	IF r55.destination = 68 THEN
		r68.going_to := 0;
	END_IF;
	r55.destination := 0;
END_IF;

(*** Rail 56 ***)
IF r56.reset THEN
	r56.fire := 0;
	IF r56.destination = 68 THEN
		r68.going_to := 0;
	END_IF;
	r56.destination := 0;
END_IF;

(*** Rail 57 ***)
IF r57.reset THEN
	r57.fire := 0;
	IF r57.destination = 68 THEN
		r68.going_to := 0;
	END_IF;
	r57.destination := 0;
END_IF;

(*** Rail 58 ***)
IF r58.reset THEN
	r58.fire := 0;
	IF r58.destination = 68 THEN
		r68.going_to := 0;
	END_IF;
	r58.destination := 0;
END_IF;

(*** Rail 59 ***)
IF r59.reset THEN
	r59.fire := 0;
	IF r59.destination = 68 THEN
		r68.going_to := 0;
	END_IF;
	r59.destination := 0;
END_IF;

(*** Rail 60 ***)
IF r60.reset THEN
	r60.fire := 0;
	IF r60.destination = 68 THEN
		r68.going_to := 0;
	END_IF;
	r60.destination := 0;
END_IF;

(*** Rail 61 ***)
IF r61.reset THEN
	r61.fire := 0;
	r61.destination := 0;
END_IF;

(*** Rail 62 ***)
IF r62.reset THEN
	r62.fire := 0;
	r62.destination := 0;
END_IF;

(*** Rail 63 ***)
IF r63.reset THEN
	r63.fire := 0;
	r63.destination := 0;
END_IF;

(*** Rail 64 ***)
IF r64.reset THEN
	r64.fire := 0;
	r64.destination := 0;
END_IF;

(*** Rail 65 ***)
IF r65.reset THEN
	r65.fire := 0;
	r65.destination := 0;
END_IF;

(*** Rail 66 ***)
IF r66.reset THEN
	r66.fire := 0;
	r66.destination := 0;
END_IF;

(*** Rail 67 ***)
IF r67.reset THEN
	r67.fire := 0;
	r67.destination := 0;
END_IF;

(*** Rail 68 ***)
IF r68.reset THEN
	r68.fire := 0;
	r68.destination := 0;
END_IF;

(*** Rail 69 ***)
IF r69.reset THEN
	r69.fire := 0;
	r69.destination := 0;
END_IF;

(*** Rail 70 ***)
IF r70.reset THEN
	r70.fire := 0;
	r70.destination := 0;
END_IF;

(*** Rail 71 ***)
IF r71.reset THEN
	r71.fire := 0;
	r71.destination := 0;
END_IF;

(*** Rail 72 ***)
IF r72.reset THEN
	r72.fire := 0;
	r72.destination := 0;
END_IF;

(*** Rail 73 ***)
IF r73.reset THEN
	r73.fire := 0;
	r73.destination := 0;
END_IF;

(*** Rail 74 ***)
IF r74.reset THEN
	r74.fire := 0;
	r74.destination := 0;
END_IF;



(*** Conveyor Stop Signals ***)

conveyor_stop_1 := conveyor_stop_word_1.0;
conveyor_stop_2 := conveyor_stop_word_1.1;
conveyor_stop_3 := conveyor_stop_word_1.2;
conveyor_stop_4 := conveyor_stop_word_1.3;

END_PROGRAM