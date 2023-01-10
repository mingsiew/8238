(********************************************************************
 * Program: st_rails
 * File: st_rails.st
 ********************************************************************)
PROGRAM _CYCLIC
(***	RAILS	***)
(*
  This section maps the plc state of io_ok and manages fire bits
*)

	(***	Rail: 1	***)
	IF r1.fire_ns THEN r1.destination := 0; END_IF;
	IF r1.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r1.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r1.fire := TRUE;
		END_IF;

		IF r1.fire AND r61.insert_reset THEN
			r1.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 2	***)
	IF r2.fire_ns THEN r2.destination := 0; END_IF;
	IF r2.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r2.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r2.fire := TRUE;
		END_IF;

		IF r2.fire AND r61.insert_reset THEN
			r2.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 3	***)
	IF r3.fire_ns THEN r3.destination := 0; END_IF;
	IF r3.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r3.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r3.fire := TRUE;
		END_IF;

		IF r3.fire AND r61.insert_reset THEN
			r3.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 4	***)
	IF r4.fire_ns THEN r4.destination := 0; END_IF;
	IF r4.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r4.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r4.fire := TRUE;
		END_IF;

		IF r4.fire AND r61.insert_reset THEN
			r4.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 5	***)
	IF r5.fire_ns THEN r5.destination := 0; END_IF;
	IF r5.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r5.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r5.fire := TRUE;
		END_IF;

		IF r5.fire AND r61.insert_reset THEN
			r5.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 6	***)
	IF r6.fire_ns THEN r6.destination := 0; END_IF;
	IF r6.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r6.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r6.fire := TRUE;
		END_IF;

		IF r6.fire AND r61.insert_reset THEN
			r6.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 7	***)
	IF r7.fire_ns THEN r7.destination := 0; END_IF;
	IF r7.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r7.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r7.fire := TRUE;
		END_IF;

		IF r7.fire AND r61.insert_reset THEN
			r7.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 8	***)
	IF r8.fire_ns THEN r8.destination := 0; END_IF;
	IF r8.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r8.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r8.fire := TRUE;
		END_IF;

		IF r8.fire AND r61.insert_reset THEN
			r8.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 9	***)
	IF r9.fire_ns THEN r9.destination := 0; END_IF;
	IF r9.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r9.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r9.fire := TRUE;
		END_IF;

		IF r9.fire AND r61.insert_reset THEN
			r9.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 10	***)
	IF r10.fire_ns THEN r10.destination := 0; END_IF;
	IF r10.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r10.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r10.fire := TRUE;
		END_IF;

		IF r10.fire AND r61.insert_reset THEN
			r10.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 11	***)
	IF r11.fire_ns THEN r11.destination := 0; END_IF;
	IF r11.destination = 61 THEN
		IF NOT(r61.going_to) AND NOT(r11.reset) AND NOT(r61.insert_reset) THEN
			r61.going_to := TRUE;
			r11.fire := TRUE;
		END_IF;

		IF r11.fire AND r61.insert_reset THEN
			r11.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 12	***)
	IF r12.fire_ns THEN r12.destination := 0; END_IF;
	IF r12.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r12.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r12.fire := TRUE;
		END_IF;

		IF r12.fire AND r63.insert_reset THEN
			r12.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 13	***)
	IF r13.fire_ns THEN r13.destination := 0; END_IF;
	IF r13.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r13.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r13.fire := TRUE;
		END_IF;

		IF r13.fire AND r63.insert_reset THEN
			r13.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 14	***)
	IF r14.fire_ns THEN r14.destination := 0; END_IF;
	IF r14.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r14.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r14.fire := TRUE;
		END_IF;

		IF r14.fire AND r63.insert_reset THEN
			r14.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 15	***)
	IF r15.fire_ns THEN r15.destination := 0; END_IF;
	IF r15.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r15.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r15.fire := TRUE;
		END_IF;

		IF r15.fire AND r63.insert_reset THEN
			r15.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 16	***)
	IF r16.fire_ns THEN r16.destination := 0; END_IF;
	IF r16.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r16.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r16.fire := TRUE;
		END_IF;

		IF r16.fire AND r63.insert_reset THEN
			r16.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 17	***)
	IF r17.fire_ns THEN r17.destination := 0; END_IF;
	IF r17.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r17.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r17.fire := TRUE;
		END_IF;

		IF r17.fire AND r63.insert_reset THEN
			r17.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 18	***)
	IF r18.fire_ns THEN r18.destination := 0; END_IF;
	IF r18.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r18.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r18.fire := TRUE;
		END_IF;

		IF r18.fire AND r63.insert_reset THEN
			r18.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 19	***)
	IF r19.fire_ns THEN r19.destination := 0; END_IF;
	IF r19.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r19.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r19.fire := TRUE;
		END_IF;

		IF r19.fire AND r63.insert_reset THEN
			r19.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 20	***)
	IF r20.fire_ns THEN r20.destination := 0; END_IF;
	IF r20.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r20.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r20.fire := TRUE;
		END_IF;

		IF r20.fire AND r63.insert_reset THEN
			r20.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 21	***)
	IF r21.fire_ns THEN r21.destination := 0; END_IF;
	IF r21.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r21.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r21.fire := TRUE;
		END_IF;

		IF r21.fire AND r63.insert_reset THEN
			r21.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 22	***)
	IF r22.fire_ns THEN r22.destination := 0; END_IF;
	IF r22.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r22.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r22.fire := TRUE;
		END_IF;

		IF r22.fire AND r63.insert_reset THEN
			r22.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 23	***)
	IF r23.fire_ns THEN r23.destination := 0; END_IF;
	IF r23.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r23.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r23.fire := TRUE;
		END_IF;

		IF r23.fire AND r63.insert_reset THEN
			r23.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 24	***)
	IF r24.fire_ns THEN r24.destination := 0; END_IF;
	IF r24.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r24.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r24.fire := TRUE;
		END_IF;

		IF r24.fire AND r63.insert_reset THEN
			r24.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 25	***)
	IF r25.fire_ns THEN r25.destination := 0; END_IF;
	IF r25.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r25.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r25.fire := TRUE;
		END_IF;

		IF r25.fire AND r63.insert_reset THEN
			r25.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 26	***)
	IF r26.fire_ns THEN r26.destination := 0; END_IF;
	IF r26.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r26.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r26.fire := TRUE;
		END_IF;

		IF r26.fire AND r63.insert_reset THEN
			r26.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 27	***)
	IF r27.fire_ns THEN r27.destination := 0; END_IF;
	IF r27.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r27.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r27.fire := TRUE;
		END_IF;

		IF r27.fire AND r63.insert_reset THEN
			r27.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 28	***)
	IF r28.fire_ns THEN r28.destination := 0; END_IF;
	IF r28.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r28.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r28.fire := TRUE;
		END_IF;

		IF r28.fire AND r63.insert_reset THEN
			r28.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 29	***)
	IF r29.fire_ns THEN r29.destination := 0; END_IF;
	IF r29.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r29.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r29.fire := TRUE;
		END_IF;

		IF r29.fire AND r63.insert_reset THEN
			r29.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 30	***)
	IF r30.fire_ns THEN r30.destination := 0; END_IF;
	IF r30.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r30.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r30.fire := TRUE;
		END_IF;

		IF r30.fire AND r63.insert_reset THEN
			r30.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 31	***)
	IF r31.fire_ns THEN r31.destination := 0; END_IF;
	IF r31.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r31.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r31.fire := TRUE;
		END_IF;

		IF r31.fire AND r63.insert_reset THEN
			r31.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 32	***)
	IF r32.fire_ns THEN r32.destination := 0; END_IF;
	IF r32.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r32.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r32.fire := TRUE;
		END_IF;

		IF r32.fire AND r63.insert_reset THEN
			r32.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 33	***)
	IF r33.fire_ns THEN r33.destination := 0; END_IF;
	IF r33.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r33.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r33.fire := TRUE;
		END_IF;

		IF r33.fire AND r63.insert_reset THEN
			r33.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 34	***)
	IF r34.fire_ns THEN r34.destination := 0; END_IF;
	IF r34.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r34.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r34.fire := TRUE;
		END_IF;

		IF r34.fire AND r63.insert_reset THEN
			r34.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 35	***)
	IF r35.fire_ns THEN r35.destination := 0; END_IF;
	IF r35.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r35.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r35.fire := TRUE;
		END_IF;

		IF r35.fire AND r63.insert_reset THEN
			r35.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 36	***)
	IF r36.fire_ns THEN r36.destination := 0; END_IF;
	IF r36.destination = 63 THEN
		IF NOT(r63.going_to) AND NOT(r36.reset) AND NOT(r63.insert_reset) THEN
			r63.going_to := TRUE;
			r36.fire := TRUE;
		END_IF;

		IF r36.fire AND r63.insert_reset THEN
			r36.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 37	***)
	IF r37.fire_ns THEN r37.destination := 0; END_IF;
	IF r37.destination = 66 THEN
		IF NOT(r66.going_to) AND NOT(r37.reset) AND NOT(r66.insert_reset) THEN
			r66.going_to := TRUE;
			r37.fire := TRUE;
		END_IF;

		IF r37.fire AND r66.insert_reset THEN
			r37.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 38	***)
	IF r38.fire_ns THEN r38.destination := 0; END_IF;
	IF r38.destination = 66 THEN
		IF NOT(r66.going_to) AND NOT(r38.reset) AND NOT(r66.insert_reset) THEN
			r66.going_to := TRUE;
			r38.fire := TRUE;
		END_IF;

		IF r38.fire AND r66.insert_reset THEN
			r38.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 39	***)
	IF r39.fire_ns THEN r39.destination := 0; END_IF;
	IF r39.destination = 66 THEN
		IF NOT(r66.going_to) AND NOT(r39.reset) AND NOT(r66.insert_reset) THEN
			r66.going_to := TRUE;
			r39.fire := TRUE;
		END_IF;

		IF r39.fire AND r66.insert_reset THEN
			r39.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 40	***)
	IF r40.fire_ns THEN r40.destination := 0; END_IF;
	IF r40.destination = 66 THEN
		IF NOT(r66.going_to) AND NOT(r40.reset) AND NOT(r66.insert_reset) THEN
			r66.going_to := TRUE;
			r40.fire := TRUE;
		END_IF;

		IF r40.fire AND r66.insert_reset THEN
			r40.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 41	***)
	IF r41.fire_ns THEN r41.destination := 0; END_IF;
	IF r41.destination = 66 THEN
		IF NOT(r66.going_to) AND NOT(r41.reset) AND NOT(r66.insert_reset) THEN
			r66.going_to := TRUE;
			r41.fire := TRUE;
		END_IF;

		IF r41.fire AND r66.insert_reset THEN
			r41.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 42	***)
	IF r42.fire_ns THEN r42.destination := 0; END_IF;
	IF r42.destination = 66 THEN
		IF NOT(r66.going_to) AND NOT(r42.reset) AND NOT(r66.insert_reset) THEN
			r66.going_to := TRUE;
			r42.fire := TRUE;
		END_IF;

		IF r42.fire AND r66.insert_reset THEN
			r42.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 43	***)
	IF r43.fire_ns THEN r43.destination := 0; END_IF;
	IF r43.destination = 65 THEN
		IF NOT(r65.going_to) AND NOT(r43.reset) AND NOT(r65.insert_reset) THEN
			r65.going_to := TRUE;
			r43.fire := TRUE;
		END_IF;

		IF r43.fire AND r65.insert_reset THEN
			r43.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 44	***)
	IF r44.fire_ns THEN r44.destination := 0; END_IF;
	IF r44.destination = 65 THEN
		IF NOT(r65.going_to) AND NOT(r44.reset) AND NOT(r65.insert_reset) THEN
			r65.going_to := TRUE;
			r44.fire := TRUE;
		END_IF;

		IF r44.fire AND r65.insert_reset THEN
			r44.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 45	***)
	IF r45.fire_ns THEN r45.destination := 0; END_IF;
	IF r45.destination = 65 THEN
		IF NOT(r65.going_to) AND NOT(r45.reset) AND NOT(r65.insert_reset) THEN
			r65.going_to := TRUE;
			r45.fire := TRUE;
		END_IF;

		IF r45.fire AND r65.insert_reset THEN
			r45.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 46	***)
	IF r46.fire_ns THEN r46.destination := 0; END_IF;
	IF r46.destination = 65 THEN
		IF NOT(r65.going_to) AND NOT(r46.reset) AND NOT(r65.insert_reset) THEN
			r65.going_to := TRUE;
			r46.fire := TRUE;
		END_IF;

		IF r46.fire AND r65.insert_reset THEN
			r46.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 47	***)
	IF r47.fire_ns THEN r47.destination := 0; END_IF;
	IF r47.destination = 65 THEN
		IF NOT(r65.going_to) AND NOT(r47.reset) AND NOT(r65.insert_reset) THEN
			r65.going_to := TRUE;
			r47.fire := TRUE;
		END_IF;

		IF r47.fire AND r65.insert_reset THEN
			r47.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 48	***)
	IF r48.fire_ns THEN r48.destination := 0; END_IF;
	IF r48.destination = 65 THEN
		IF NOT(r65.going_to) AND NOT(r48.reset) AND NOT(r65.insert_reset) THEN
			r65.going_to := TRUE;
			r48.fire := TRUE;
		END_IF;

		IF r48.fire AND r65.insert_reset THEN
			r48.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 49	***)
	IF r49.fire_ns THEN r49.destination := 0; END_IF;
	IF r49.destination = 69 THEN
		IF NOT(r69.going_to) AND NOT(r49.reset) AND NOT(r69.insert_reset) THEN
			r69.going_to := TRUE;
			r49.fire := TRUE;
		END_IF;

		IF r49.fire AND r69.insert_reset THEN
			r49.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 50	***)
	IF r50.fire_ns THEN r50.destination := 0; END_IF;
	IF r50.destination = 69 THEN
		IF NOT(r69.going_to) AND NOT(r50.reset) AND NOT(r69.insert_reset) THEN
			r69.going_to := TRUE;
			r50.fire := TRUE;
		END_IF;

		IF r50.fire AND r69.insert_reset THEN
			r50.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 51	***)
	IF r51.fire_ns THEN r51.destination := 0; END_IF;
	IF r51.destination = 69 THEN
		IF NOT(r69.going_to) AND NOT(r51.reset) AND NOT(r69.insert_reset) THEN
			r69.going_to := TRUE;
			r51.fire := TRUE;
		END_IF;

		IF r51.fire AND r69.insert_reset THEN
			r51.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 52	***)
	IF r52.fire_ns THEN r52.destination := 0; END_IF;
	IF r52.destination = 69 THEN
		IF NOT(r69.going_to) AND NOT(r52.reset) AND NOT(r69.insert_reset) THEN
			r69.going_to := TRUE;
			r52.fire := TRUE;
		END_IF;

		IF r52.fire AND r69.insert_reset THEN
			r52.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 53	***)
	IF r53.fire_ns THEN r53.destination := 0; END_IF;
	IF r53.destination = 69 THEN
		IF NOT(r69.going_to) AND NOT(r53.reset) AND NOT(r69.insert_reset) THEN
			r69.going_to := TRUE;
			r53.fire := TRUE;
		END_IF;

		IF r53.fire AND r69.insert_reset THEN
			r53.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 54	***)
	IF r54.fire_ns THEN r54.destination := 0; END_IF;
	IF r54.destination = 69 THEN
		IF NOT(r69.going_to) AND NOT(r54.reset) AND NOT(r69.insert_reset) THEN
			r69.going_to := TRUE;
			r54.fire := TRUE;
		END_IF;

		IF r54.fire AND r69.insert_reset THEN
			r54.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 55	***)
	IF r55.fire_ns THEN r55.destination := 0; END_IF;
	IF r55.destination = 68 THEN
		IF NOT(r68.going_to) AND NOT(r55.reset) AND NOT(r68.insert_reset) THEN
			r68.going_to := TRUE;
			r55.fire := TRUE;
		END_IF;

		IF r55.fire AND r68.insert_reset THEN
			r55.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 56	***)
	IF r56.fire_ns THEN r56.destination := 0; END_IF;
	IF r56.destination = 68 THEN
		IF NOT(r68.going_to) AND NOT(r56.reset) AND NOT(r68.insert_reset) THEN
			r68.going_to := TRUE;
			r56.fire := TRUE;
		END_IF;

		IF r56.fire AND r68.insert_reset THEN
			r56.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 57	***)
	IF r57.fire_ns THEN r57.destination := 0; END_IF;
	IF r57.destination = 68 THEN
		IF NOT(r68.going_to) AND NOT(r57.reset) AND NOT(r68.insert_reset) THEN
			r68.going_to := TRUE;
			r57.fire := TRUE;
		END_IF;

		IF r57.fire AND r68.insert_reset THEN
			r57.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 58	***)
	IF r58.fire_ns THEN r58.destination := 0; END_IF;
	IF r58.destination = 68 THEN
		IF NOT(r68.going_to) AND NOT(r58.reset) AND NOT(r68.insert_reset) THEN
			r68.going_to := TRUE;
			r58.fire := TRUE;
		END_IF;

		IF r58.fire AND r68.insert_reset THEN
			r58.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 59	***)
	IF r59.fire_ns THEN r59.destination := 0; END_IF;
	IF r59.destination = 68 THEN
		IF NOT(r68.going_to) AND NOT(r59.reset) AND NOT(r68.insert_reset) THEN
			r68.going_to := TRUE;
			r59.fire := TRUE;
		END_IF;

		IF r59.fire AND r68.insert_reset THEN
			r59.fire := FALSE;
		END_IF;
	END_IF;


	(***	Rail: 60	***)
	IF r60.fire_ns THEN r60.destination := 0; END_IF;
	IF r60.destination = 68 THEN
		IF NOT(r68.going_to) AND NOT(r60.reset) AND NOT(r68.insert_reset) THEN
			r68.going_to := TRUE;
			r60.fire := TRUE;
		END_IF;

		IF r60.fire AND r68.insert_reset THEN
			r60.fire := FALSE;
		END_IF;
	END_IF;


	r1.fire_r_trig(CLK:=r1.fire);
	r1.fire_f_trig(CLK:=r1.fire);
	r1.fire_os := r1.fire_r_trig.Q;
	r1.fire_ns := r1.fire_f_trig.Q;
	r1.going_to_r_trig(CLK:=r1.going_to);
	r1.going_to_f_trig(CLK:=r1.going_to);
	r1.going_to_os := r1.going_to_r_trig.Q;
	r1.going_to_ns := r1.going_to_f_trig.Q;

	r2.fire_r_trig(CLK:=r2.fire);
	r2.fire_f_trig(CLK:=r2.fire);
	r2.fire_os := r2.fire_r_trig.Q;
	r2.fire_ns := r2.fire_f_trig.Q;
	r2.going_to_r_trig(CLK:=r2.going_to);
	r2.going_to_f_trig(CLK:=r2.going_to);
	r2.going_to_os := r2.going_to_r_trig.Q;
	r2.going_to_ns := r2.going_to_f_trig.Q;

	r3.fire_r_trig(CLK:=r3.fire);
	r3.fire_f_trig(CLK:=r3.fire);
	r3.fire_os := r3.fire_r_trig.Q;
	r3.fire_ns := r3.fire_f_trig.Q;
	r3.going_to_r_trig(CLK:=r3.going_to);
	r3.going_to_f_trig(CLK:=r3.going_to);
	r3.going_to_os := r3.going_to_r_trig.Q;
	r3.going_to_ns := r3.going_to_f_trig.Q;

	r4.fire_r_trig(CLK:=r4.fire);
	r4.fire_f_trig(CLK:=r4.fire);
	r4.fire_os := r4.fire_r_trig.Q;
	r4.fire_ns := r4.fire_f_trig.Q;
	r4.going_to_r_trig(CLK:=r4.going_to);
	r4.going_to_f_trig(CLK:=r4.going_to);
	r4.going_to_os := r4.going_to_r_trig.Q;
	r4.going_to_ns := r4.going_to_f_trig.Q;

	r5.fire_r_trig(CLK:=r5.fire);
	r5.fire_f_trig(CLK:=r5.fire);
	r5.fire_os := r5.fire_r_trig.Q;
	r5.fire_ns := r5.fire_f_trig.Q;
	r5.going_to_r_trig(CLK:=r5.going_to);
	r5.going_to_f_trig(CLK:=r5.going_to);
	r5.going_to_os := r5.going_to_r_trig.Q;
	r5.going_to_ns := r5.going_to_f_trig.Q;

	r6.fire_r_trig(CLK:=r6.fire);
	r6.fire_f_trig(CLK:=r6.fire);
	r6.fire_os := r6.fire_r_trig.Q;
	r6.fire_ns := r6.fire_f_trig.Q;
	r6.going_to_r_trig(CLK:=r6.going_to);
	r6.going_to_f_trig(CLK:=r6.going_to);
	r6.going_to_os := r6.going_to_r_trig.Q;
	r6.going_to_ns := r6.going_to_f_trig.Q;

	r7.fire_r_trig(CLK:=r7.fire);
	r7.fire_f_trig(CLK:=r7.fire);
	r7.fire_os := r7.fire_r_trig.Q;
	r7.fire_ns := r7.fire_f_trig.Q;
	r7.going_to_r_trig(CLK:=r7.going_to);
	r7.going_to_f_trig(CLK:=r7.going_to);
	r7.going_to_os := r7.going_to_r_trig.Q;
	r7.going_to_ns := r7.going_to_f_trig.Q;

	r8.fire_r_trig(CLK:=r8.fire);
	r8.fire_f_trig(CLK:=r8.fire);
	r8.fire_os := r8.fire_r_trig.Q;
	r8.fire_ns := r8.fire_f_trig.Q;
	r8.going_to_r_trig(CLK:=r8.going_to);
	r8.going_to_f_trig(CLK:=r8.going_to);
	r8.going_to_os := r8.going_to_r_trig.Q;
	r8.going_to_ns := r8.going_to_f_trig.Q;

	r9.fire_r_trig(CLK:=r9.fire);
	r9.fire_f_trig(CLK:=r9.fire);
	r9.fire_os := r9.fire_r_trig.Q;
	r9.fire_ns := r9.fire_f_trig.Q;
	r9.going_to_r_trig(CLK:=r9.going_to);
	r9.going_to_f_trig(CLK:=r9.going_to);
	r9.going_to_os := r9.going_to_r_trig.Q;
	r9.going_to_ns := r9.going_to_f_trig.Q;

	r10.fire_r_trig(CLK:=r10.fire);
	r10.fire_f_trig(CLK:=r10.fire);
	r10.fire_os := r10.fire_r_trig.Q;
	r10.fire_ns := r10.fire_f_trig.Q;
	r10.going_to_r_trig(CLK:=r10.going_to);
	r10.going_to_f_trig(CLK:=r10.going_to);
	r10.going_to_os := r10.going_to_r_trig.Q;
	r10.going_to_ns := r10.going_to_f_trig.Q;

	r11.fire_r_trig(CLK:=r11.fire);
	r11.fire_f_trig(CLK:=r11.fire);
	r11.fire_os := r11.fire_r_trig.Q;
	r11.fire_ns := r11.fire_f_trig.Q;
	r11.going_to_r_trig(CLK:=r11.going_to);
	r11.going_to_f_trig(CLK:=r11.going_to);
	r11.going_to_os := r11.going_to_r_trig.Q;
	r11.going_to_ns := r11.going_to_f_trig.Q;

	r12.fire_r_trig(CLK:=r12.fire);
	r12.fire_f_trig(CLK:=r12.fire);
	r12.fire_os := r12.fire_r_trig.Q;
	r12.fire_ns := r12.fire_f_trig.Q;
	r12.going_to_r_trig(CLK:=r12.going_to);
	r12.going_to_f_trig(CLK:=r12.going_to);
	r12.going_to_os := r12.going_to_r_trig.Q;
	r12.going_to_ns := r12.going_to_f_trig.Q;

	r13.fire_r_trig(CLK:=r13.fire);
	r13.fire_f_trig(CLK:=r13.fire);
	r13.fire_os := r13.fire_r_trig.Q;
	r13.fire_ns := r13.fire_f_trig.Q;
	r13.going_to_r_trig(CLK:=r13.going_to);
	r13.going_to_f_trig(CLK:=r13.going_to);
	r13.going_to_os := r13.going_to_r_trig.Q;
	r13.going_to_ns := r13.going_to_f_trig.Q;

	r14.fire_r_trig(CLK:=r14.fire);
	r14.fire_f_trig(CLK:=r14.fire);
	r14.fire_os := r14.fire_r_trig.Q;
	r14.fire_ns := r14.fire_f_trig.Q;
	r14.going_to_r_trig(CLK:=r14.going_to);
	r14.going_to_f_trig(CLK:=r14.going_to);
	r14.going_to_os := r14.going_to_r_trig.Q;
	r14.going_to_ns := r14.going_to_f_trig.Q;

	r15.fire_r_trig(CLK:=r15.fire);
	r15.fire_f_trig(CLK:=r15.fire);
	r15.fire_os := r15.fire_r_trig.Q;
	r15.fire_ns := r15.fire_f_trig.Q;
	r15.going_to_r_trig(CLK:=r15.going_to);
	r15.going_to_f_trig(CLK:=r15.going_to);
	r15.going_to_os := r15.going_to_r_trig.Q;
	r15.going_to_ns := r15.going_to_f_trig.Q;

	r16.fire_r_trig(CLK:=r16.fire);
	r16.fire_f_trig(CLK:=r16.fire);
	r16.fire_os := r16.fire_r_trig.Q;
	r16.fire_ns := r16.fire_f_trig.Q;
	r16.going_to_r_trig(CLK:=r16.going_to);
	r16.going_to_f_trig(CLK:=r16.going_to);
	r16.going_to_os := r16.going_to_r_trig.Q;
	r16.going_to_ns := r16.going_to_f_trig.Q;

	r17.fire_r_trig(CLK:=r17.fire);
	r17.fire_f_trig(CLK:=r17.fire);
	r17.fire_os := r17.fire_r_trig.Q;
	r17.fire_ns := r17.fire_f_trig.Q;
	r17.going_to_r_trig(CLK:=r17.going_to);
	r17.going_to_f_trig(CLK:=r17.going_to);
	r17.going_to_os := r17.going_to_r_trig.Q;
	r17.going_to_ns := r17.going_to_f_trig.Q;

	r18.fire_r_trig(CLK:=r18.fire);
	r18.fire_f_trig(CLK:=r18.fire);
	r18.fire_os := r18.fire_r_trig.Q;
	r18.fire_ns := r18.fire_f_trig.Q;
	r18.going_to_r_trig(CLK:=r18.going_to);
	r18.going_to_f_trig(CLK:=r18.going_to);
	r18.going_to_os := r18.going_to_r_trig.Q;
	r18.going_to_ns := r18.going_to_f_trig.Q;

	r19.fire_r_trig(CLK:=r19.fire);
	r19.fire_f_trig(CLK:=r19.fire);
	r19.fire_os := r19.fire_r_trig.Q;
	r19.fire_ns := r19.fire_f_trig.Q;
	r19.going_to_r_trig(CLK:=r19.going_to);
	r19.going_to_f_trig(CLK:=r19.going_to);
	r19.going_to_os := r19.going_to_r_trig.Q;
	r19.going_to_ns := r19.going_to_f_trig.Q;

	r20.fire_r_trig(CLK:=r20.fire);
	r20.fire_f_trig(CLK:=r20.fire);
	r20.fire_os := r20.fire_r_trig.Q;
	r20.fire_ns := r20.fire_f_trig.Q;
	r20.going_to_r_trig(CLK:=r20.going_to);
	r20.going_to_f_trig(CLK:=r20.going_to);
	r20.going_to_os := r20.going_to_r_trig.Q;
	r20.going_to_ns := r20.going_to_f_trig.Q;

	r21.fire_r_trig(CLK:=r21.fire);
	r21.fire_f_trig(CLK:=r21.fire);
	r21.fire_os := r21.fire_r_trig.Q;
	r21.fire_ns := r21.fire_f_trig.Q;
	r21.going_to_r_trig(CLK:=r21.going_to);
	r21.going_to_f_trig(CLK:=r21.going_to);
	r21.going_to_os := r21.going_to_r_trig.Q;
	r21.going_to_ns := r21.going_to_f_trig.Q;

	r22.fire_r_trig(CLK:=r22.fire);
	r22.fire_f_trig(CLK:=r22.fire);
	r22.fire_os := r22.fire_r_trig.Q;
	r22.fire_ns := r22.fire_f_trig.Q;
	r22.going_to_r_trig(CLK:=r22.going_to);
	r22.going_to_f_trig(CLK:=r22.going_to);
	r22.going_to_os := r22.going_to_r_trig.Q;
	r22.going_to_ns := r22.going_to_f_trig.Q;

	r23.fire_r_trig(CLK:=r23.fire);
	r23.fire_f_trig(CLK:=r23.fire);
	r23.fire_os := r23.fire_r_trig.Q;
	r23.fire_ns := r23.fire_f_trig.Q;
	r23.going_to_r_trig(CLK:=r23.going_to);
	r23.going_to_f_trig(CLK:=r23.going_to);
	r23.going_to_os := r23.going_to_r_trig.Q;
	r23.going_to_ns := r23.going_to_f_trig.Q;

	r24.fire_r_trig(CLK:=r24.fire);
	r24.fire_f_trig(CLK:=r24.fire);
	r24.fire_os := r24.fire_r_trig.Q;
	r24.fire_ns := r24.fire_f_trig.Q;
	r24.going_to_r_trig(CLK:=r24.going_to);
	r24.going_to_f_trig(CLK:=r24.going_to);
	r24.going_to_os := r24.going_to_r_trig.Q;
	r24.going_to_ns := r24.going_to_f_trig.Q;

	r25.fire_r_trig(CLK:=r25.fire);
	r25.fire_f_trig(CLK:=r25.fire);
	r25.fire_os := r25.fire_r_trig.Q;
	r25.fire_ns := r25.fire_f_trig.Q;
	r25.going_to_r_trig(CLK:=r25.going_to);
	r25.going_to_f_trig(CLK:=r25.going_to);
	r25.going_to_os := r25.going_to_r_trig.Q;
	r25.going_to_ns := r25.going_to_f_trig.Q;

	r26.fire_r_trig(CLK:=r26.fire);
	r26.fire_f_trig(CLK:=r26.fire);
	r26.fire_os := r26.fire_r_trig.Q;
	r26.fire_ns := r26.fire_f_trig.Q;
	r26.going_to_r_trig(CLK:=r26.going_to);
	r26.going_to_f_trig(CLK:=r26.going_to);
	r26.going_to_os := r26.going_to_r_trig.Q;
	r26.going_to_ns := r26.going_to_f_trig.Q;

	r27.fire_r_trig(CLK:=r27.fire);
	r27.fire_f_trig(CLK:=r27.fire);
	r27.fire_os := r27.fire_r_trig.Q;
	r27.fire_ns := r27.fire_f_trig.Q;
	r27.going_to_r_trig(CLK:=r27.going_to);
	r27.going_to_f_trig(CLK:=r27.going_to);
	r27.going_to_os := r27.going_to_r_trig.Q;
	r27.going_to_ns := r27.going_to_f_trig.Q;

	r28.fire_r_trig(CLK:=r28.fire);
	r28.fire_f_trig(CLK:=r28.fire);
	r28.fire_os := r28.fire_r_trig.Q;
	r28.fire_ns := r28.fire_f_trig.Q;
	r28.going_to_r_trig(CLK:=r28.going_to);
	r28.going_to_f_trig(CLK:=r28.going_to);
	r28.going_to_os := r28.going_to_r_trig.Q;
	r28.going_to_ns := r28.going_to_f_trig.Q;

	r29.fire_r_trig(CLK:=r29.fire);
	r29.fire_f_trig(CLK:=r29.fire);
	r29.fire_os := r29.fire_r_trig.Q;
	r29.fire_ns := r29.fire_f_trig.Q;
	r29.going_to_r_trig(CLK:=r29.going_to);
	r29.going_to_f_trig(CLK:=r29.going_to);
	r29.going_to_os := r29.going_to_r_trig.Q;
	r29.going_to_ns := r29.going_to_f_trig.Q;

	r30.fire_r_trig(CLK:=r30.fire);
	r30.fire_f_trig(CLK:=r30.fire);
	r30.fire_os := r30.fire_r_trig.Q;
	r30.fire_ns := r30.fire_f_trig.Q;
	r30.going_to_r_trig(CLK:=r30.going_to);
	r30.going_to_f_trig(CLK:=r30.going_to);
	r30.going_to_os := r30.going_to_r_trig.Q;
	r30.going_to_ns := r30.going_to_f_trig.Q;

	r31.fire_r_trig(CLK:=r31.fire);
	r31.fire_f_trig(CLK:=r31.fire);
	r31.fire_os := r31.fire_r_trig.Q;
	r31.fire_ns := r31.fire_f_trig.Q;
	r31.going_to_r_trig(CLK:=r31.going_to);
	r31.going_to_f_trig(CLK:=r31.going_to);
	r31.going_to_os := r31.going_to_r_trig.Q;
	r31.going_to_ns := r31.going_to_f_trig.Q;

	r32.fire_r_trig(CLK:=r32.fire);
	r32.fire_f_trig(CLK:=r32.fire);
	r32.fire_os := r32.fire_r_trig.Q;
	r32.fire_ns := r32.fire_f_trig.Q;
	r32.going_to_r_trig(CLK:=r32.going_to);
	r32.going_to_f_trig(CLK:=r32.going_to);
	r32.going_to_os := r32.going_to_r_trig.Q;
	r32.going_to_ns := r32.going_to_f_trig.Q;

	r33.fire_r_trig(CLK:=r33.fire);
	r33.fire_f_trig(CLK:=r33.fire);
	r33.fire_os := r33.fire_r_trig.Q;
	r33.fire_ns := r33.fire_f_trig.Q;
	r33.going_to_r_trig(CLK:=r33.going_to);
	r33.going_to_f_trig(CLK:=r33.going_to);
	r33.going_to_os := r33.going_to_r_trig.Q;
	r33.going_to_ns := r33.going_to_f_trig.Q;

	r34.fire_r_trig(CLK:=r34.fire);
	r34.fire_f_trig(CLK:=r34.fire);
	r34.fire_os := r34.fire_r_trig.Q;
	r34.fire_ns := r34.fire_f_trig.Q;
	r34.going_to_r_trig(CLK:=r34.going_to);
	r34.going_to_f_trig(CLK:=r34.going_to);
	r34.going_to_os := r34.going_to_r_trig.Q;
	r34.going_to_ns := r34.going_to_f_trig.Q;

	r35.fire_r_trig(CLK:=r35.fire);
	r35.fire_f_trig(CLK:=r35.fire);
	r35.fire_os := r35.fire_r_trig.Q;
	r35.fire_ns := r35.fire_f_trig.Q;
	r35.going_to_r_trig(CLK:=r35.going_to);
	r35.going_to_f_trig(CLK:=r35.going_to);
	r35.going_to_os := r35.going_to_r_trig.Q;
	r35.going_to_ns := r35.going_to_f_trig.Q;

	r36.fire_r_trig(CLK:=r36.fire);
	r36.fire_f_trig(CLK:=r36.fire);
	r36.fire_os := r36.fire_r_trig.Q;
	r36.fire_ns := r36.fire_f_trig.Q;
	r36.going_to_r_trig(CLK:=r36.going_to);
	r36.going_to_f_trig(CLK:=r36.going_to);
	r36.going_to_os := r36.going_to_r_trig.Q;
	r36.going_to_ns := r36.going_to_f_trig.Q;

	r37.fire_r_trig(CLK:=r37.fire);
	r37.fire_f_trig(CLK:=r37.fire);
	r37.fire_os := r37.fire_r_trig.Q;
	r37.fire_ns := r37.fire_f_trig.Q;
	r37.going_to_r_trig(CLK:=r37.going_to);
	r37.going_to_f_trig(CLK:=r37.going_to);
	r37.going_to_os := r37.going_to_r_trig.Q;
	r37.going_to_ns := r37.going_to_f_trig.Q;

	r38.fire_r_trig(CLK:=r38.fire);
	r38.fire_f_trig(CLK:=r38.fire);
	r38.fire_os := r38.fire_r_trig.Q;
	r38.fire_ns := r38.fire_f_trig.Q;
	r38.going_to_r_trig(CLK:=r38.going_to);
	r38.going_to_f_trig(CLK:=r38.going_to);
	r38.going_to_os := r38.going_to_r_trig.Q;
	r38.going_to_ns := r38.going_to_f_trig.Q;

	r39.fire_r_trig(CLK:=r39.fire);
	r39.fire_f_trig(CLK:=r39.fire);
	r39.fire_os := r39.fire_r_trig.Q;
	r39.fire_ns := r39.fire_f_trig.Q;
	r39.going_to_r_trig(CLK:=r39.going_to);
	r39.going_to_f_trig(CLK:=r39.going_to);
	r39.going_to_os := r39.going_to_r_trig.Q;
	r39.going_to_ns := r39.going_to_f_trig.Q;

	r40.fire_r_trig(CLK:=r40.fire);
	r40.fire_f_trig(CLK:=r40.fire);
	r40.fire_os := r40.fire_r_trig.Q;
	r40.fire_ns := r40.fire_f_trig.Q;
	r40.going_to_r_trig(CLK:=r40.going_to);
	r40.going_to_f_trig(CLK:=r40.going_to);
	r40.going_to_os := r40.going_to_r_trig.Q;
	r40.going_to_ns := r40.going_to_f_trig.Q;

	r41.fire_r_trig(CLK:=r41.fire);
	r41.fire_f_trig(CLK:=r41.fire);
	r41.fire_os := r41.fire_r_trig.Q;
	r41.fire_ns := r41.fire_f_trig.Q;
	r41.going_to_r_trig(CLK:=r41.going_to);
	r41.going_to_f_trig(CLK:=r41.going_to);
	r41.going_to_os := r41.going_to_r_trig.Q;
	r41.going_to_ns := r41.going_to_f_trig.Q;

	r42.fire_r_trig(CLK:=r42.fire);
	r42.fire_f_trig(CLK:=r42.fire);
	r42.fire_os := r42.fire_r_trig.Q;
	r42.fire_ns := r42.fire_f_trig.Q;
	r42.going_to_r_trig(CLK:=r42.going_to);
	r42.going_to_f_trig(CLK:=r42.going_to);
	r42.going_to_os := r42.going_to_r_trig.Q;
	r42.going_to_ns := r42.going_to_f_trig.Q;

	r43.fire_r_trig(CLK:=r43.fire);
	r43.fire_f_trig(CLK:=r43.fire);
	r43.fire_os := r43.fire_r_trig.Q;
	r43.fire_ns := r43.fire_f_trig.Q;
	r43.going_to_r_trig(CLK:=r43.going_to);
	r43.going_to_f_trig(CLK:=r43.going_to);
	r43.going_to_os := r43.going_to_r_trig.Q;
	r43.going_to_ns := r43.going_to_f_trig.Q;

	r44.fire_r_trig(CLK:=r44.fire);
	r44.fire_f_trig(CLK:=r44.fire);
	r44.fire_os := r44.fire_r_trig.Q;
	r44.fire_ns := r44.fire_f_trig.Q;
	r44.going_to_r_trig(CLK:=r44.going_to);
	r44.going_to_f_trig(CLK:=r44.going_to);
	r44.going_to_os := r44.going_to_r_trig.Q;
	r44.going_to_ns := r44.going_to_f_trig.Q;

	r45.fire_r_trig(CLK:=r45.fire);
	r45.fire_f_trig(CLK:=r45.fire);
	r45.fire_os := r45.fire_r_trig.Q;
	r45.fire_ns := r45.fire_f_trig.Q;
	r45.going_to_r_trig(CLK:=r45.going_to);
	r45.going_to_f_trig(CLK:=r45.going_to);
	r45.going_to_os := r45.going_to_r_trig.Q;
	r45.going_to_ns := r45.going_to_f_trig.Q;

	r46.fire_r_trig(CLK:=r46.fire);
	r46.fire_f_trig(CLK:=r46.fire);
	r46.fire_os := r46.fire_r_trig.Q;
	r46.fire_ns := r46.fire_f_trig.Q;
	r46.going_to_r_trig(CLK:=r46.going_to);
	r46.going_to_f_trig(CLK:=r46.going_to);
	r46.going_to_os := r46.going_to_r_trig.Q;
	r46.going_to_ns := r46.going_to_f_trig.Q;

	r47.fire_r_trig(CLK:=r47.fire);
	r47.fire_f_trig(CLK:=r47.fire);
	r47.fire_os := r47.fire_r_trig.Q;
	r47.fire_ns := r47.fire_f_trig.Q;
	r47.going_to_r_trig(CLK:=r47.going_to);
	r47.going_to_f_trig(CLK:=r47.going_to);
	r47.going_to_os := r47.going_to_r_trig.Q;
	r47.going_to_ns := r47.going_to_f_trig.Q;

	r48.fire_r_trig(CLK:=r48.fire);
	r48.fire_f_trig(CLK:=r48.fire);
	r48.fire_os := r48.fire_r_trig.Q;
	r48.fire_ns := r48.fire_f_trig.Q;
	r48.going_to_r_trig(CLK:=r48.going_to);
	r48.going_to_f_trig(CLK:=r48.going_to);
	r48.going_to_os := r48.going_to_r_trig.Q;
	r48.going_to_ns := r48.going_to_f_trig.Q;

	r49.fire_r_trig(CLK:=r49.fire);
	r49.fire_f_trig(CLK:=r49.fire);
	r49.fire_os := r49.fire_r_trig.Q;
	r49.fire_ns := r49.fire_f_trig.Q;
	r49.going_to_r_trig(CLK:=r49.going_to);
	r49.going_to_f_trig(CLK:=r49.going_to);
	r49.going_to_os := r49.going_to_r_trig.Q;
	r49.going_to_ns := r49.going_to_f_trig.Q;

	r50.fire_r_trig(CLK:=r50.fire);
	r50.fire_f_trig(CLK:=r50.fire);
	r50.fire_os := r50.fire_r_trig.Q;
	r50.fire_ns := r50.fire_f_trig.Q;
	r50.going_to_r_trig(CLK:=r50.going_to);
	r50.going_to_f_trig(CLK:=r50.going_to);
	r50.going_to_os := r50.going_to_r_trig.Q;
	r50.going_to_ns := r50.going_to_f_trig.Q;

	r51.fire_r_trig(CLK:=r51.fire);
	r51.fire_f_trig(CLK:=r51.fire);
	r51.fire_os := r51.fire_r_trig.Q;
	r51.fire_ns := r51.fire_f_trig.Q;
	r51.going_to_r_trig(CLK:=r51.going_to);
	r51.going_to_f_trig(CLK:=r51.going_to);
	r51.going_to_os := r51.going_to_r_trig.Q;
	r51.going_to_ns := r51.going_to_f_trig.Q;

	r52.fire_r_trig(CLK:=r52.fire);
	r52.fire_f_trig(CLK:=r52.fire);
	r52.fire_os := r52.fire_r_trig.Q;
	r52.fire_ns := r52.fire_f_trig.Q;
	r52.going_to_r_trig(CLK:=r52.going_to);
	r52.going_to_f_trig(CLK:=r52.going_to);
	r52.going_to_os := r52.going_to_r_trig.Q;
	r52.going_to_ns := r52.going_to_f_trig.Q;

	r53.fire_r_trig(CLK:=r53.fire);
	r53.fire_f_trig(CLK:=r53.fire);
	r53.fire_os := r53.fire_r_trig.Q;
	r53.fire_ns := r53.fire_f_trig.Q;
	r53.going_to_r_trig(CLK:=r53.going_to);
	r53.going_to_f_trig(CLK:=r53.going_to);
	r53.going_to_os := r53.going_to_r_trig.Q;
	r53.going_to_ns := r53.going_to_f_trig.Q;

	r54.fire_r_trig(CLK:=r54.fire);
	r54.fire_f_trig(CLK:=r54.fire);
	r54.fire_os := r54.fire_r_trig.Q;
	r54.fire_ns := r54.fire_f_trig.Q;
	r54.going_to_r_trig(CLK:=r54.going_to);
	r54.going_to_f_trig(CLK:=r54.going_to);
	r54.going_to_os := r54.going_to_r_trig.Q;
	r54.going_to_ns := r54.going_to_f_trig.Q;

	r55.fire_r_trig(CLK:=r55.fire);
	r55.fire_f_trig(CLK:=r55.fire);
	r55.fire_os := r55.fire_r_trig.Q;
	r55.fire_ns := r55.fire_f_trig.Q;
	r55.going_to_r_trig(CLK:=r55.going_to);
	r55.going_to_f_trig(CLK:=r55.going_to);
	r55.going_to_os := r55.going_to_r_trig.Q;
	r55.going_to_ns := r55.going_to_f_trig.Q;

	r56.fire_r_trig(CLK:=r56.fire);
	r56.fire_f_trig(CLK:=r56.fire);
	r56.fire_os := r56.fire_r_trig.Q;
	r56.fire_ns := r56.fire_f_trig.Q;
	r56.going_to_r_trig(CLK:=r56.going_to);
	r56.going_to_f_trig(CLK:=r56.going_to);
	r56.going_to_os := r56.going_to_r_trig.Q;
	r56.going_to_ns := r56.going_to_f_trig.Q;

	r57.fire_r_trig(CLK:=r57.fire);
	r57.fire_f_trig(CLK:=r57.fire);
	r57.fire_os := r57.fire_r_trig.Q;
	r57.fire_ns := r57.fire_f_trig.Q;
	r57.going_to_r_trig(CLK:=r57.going_to);
	r57.going_to_f_trig(CLK:=r57.going_to);
	r57.going_to_os := r57.going_to_r_trig.Q;
	r57.going_to_ns := r57.going_to_f_trig.Q;

	r58.fire_r_trig(CLK:=r58.fire);
	r58.fire_f_trig(CLK:=r58.fire);
	r58.fire_os := r58.fire_r_trig.Q;
	r58.fire_ns := r58.fire_f_trig.Q;
	r58.going_to_r_trig(CLK:=r58.going_to);
	r58.going_to_f_trig(CLK:=r58.going_to);
	r58.going_to_os := r58.going_to_r_trig.Q;
	r58.going_to_ns := r58.going_to_f_trig.Q;

	r59.fire_r_trig(CLK:=r59.fire);
	r59.fire_f_trig(CLK:=r59.fire);
	r59.fire_os := r59.fire_r_trig.Q;
	r59.fire_ns := r59.fire_f_trig.Q;
	r59.going_to_r_trig(CLK:=r59.going_to);
	r59.going_to_f_trig(CLK:=r59.going_to);
	r59.going_to_os := r59.going_to_r_trig.Q;
	r59.going_to_ns := r59.going_to_f_trig.Q;

	r60.fire_r_trig(CLK:=r60.fire);
	r60.fire_f_trig(CLK:=r60.fire);
	r60.fire_os := r60.fire_r_trig.Q;
	r60.fire_ns := r60.fire_f_trig.Q;
	r60.going_to_r_trig(CLK:=r60.going_to);
	r60.going_to_f_trig(CLK:=r60.going_to);
	r60.going_to_os := r60.going_to_r_trig.Q;
	r60.going_to_ns := r60.going_to_f_trig.Q;

	r61.fire_r_trig(CLK:=r61.fire);
	r61.fire_f_trig(CLK:=r61.fire);
	r61.fire_os := r61.fire_r_trig.Q;
	r61.fire_ns := r61.fire_f_trig.Q;
	r61.going_to_r_trig(CLK:=r61.going_to);
	r61.going_to_f_trig(CLK:=r61.going_to);
	r61.going_to_os := r61.going_to_r_trig.Q;
	r61.going_to_ns := r61.going_to_f_trig.Q;

	r62.fire_r_trig(CLK:=r62.fire);
	r62.fire_f_trig(CLK:=r62.fire);
	r62.fire_os := r62.fire_r_trig.Q;
	r62.fire_ns := r62.fire_f_trig.Q;
	r62.going_to_r_trig(CLK:=r62.going_to);
	r62.going_to_f_trig(CLK:=r62.going_to);
	r62.going_to_os := r62.going_to_r_trig.Q;
	r62.going_to_ns := r62.going_to_f_trig.Q;

	r63.fire_r_trig(CLK:=r63.fire);
	r63.fire_f_trig(CLK:=r63.fire);
	r63.fire_os := r63.fire_r_trig.Q;
	r63.fire_ns := r63.fire_f_trig.Q;
	r63.going_to_r_trig(CLK:=r63.going_to);
	r63.going_to_f_trig(CLK:=r63.going_to);
	r63.going_to_os := r63.going_to_r_trig.Q;
	r63.going_to_ns := r63.going_to_f_trig.Q;

	r64.fire_r_trig(CLK:=r64.fire);
	r64.fire_f_trig(CLK:=r64.fire);
	r64.fire_os := r64.fire_r_trig.Q;
	r64.fire_ns := r64.fire_f_trig.Q;
	r64.going_to_r_trig(CLK:=r64.going_to);
	r64.going_to_f_trig(CLK:=r64.going_to);
	r64.going_to_os := r64.going_to_r_trig.Q;
	r64.going_to_ns := r64.going_to_f_trig.Q;

	r65.fire_r_trig(CLK:=r65.fire);
	r65.fire_f_trig(CLK:=r65.fire);
	r65.fire_os := r65.fire_r_trig.Q;
	r65.fire_ns := r65.fire_f_trig.Q;
	r65.going_to_r_trig(CLK:=r65.going_to);
	r65.going_to_f_trig(CLK:=r65.going_to);
	r65.going_to_os := r65.going_to_r_trig.Q;
	r65.going_to_ns := r65.going_to_f_trig.Q;

	r66.fire_r_trig(CLK:=r66.fire);
	r66.fire_f_trig(CLK:=r66.fire);
	r66.fire_os := r66.fire_r_trig.Q;
	r66.fire_ns := r66.fire_f_trig.Q;
	r66.going_to_r_trig(CLK:=r66.going_to);
	r66.going_to_f_trig(CLK:=r66.going_to);
	r66.going_to_os := r66.going_to_r_trig.Q;
	r66.going_to_ns := r66.going_to_f_trig.Q;

	r67.fire_r_trig(CLK:=r67.fire);
	r67.fire_f_trig(CLK:=r67.fire);
	r67.fire_os := r67.fire_r_trig.Q;
	r67.fire_ns := r67.fire_f_trig.Q;
	r67.going_to_r_trig(CLK:=r67.going_to);
	r67.going_to_f_trig(CLK:=r67.going_to);
	r67.going_to_os := r67.going_to_r_trig.Q;
	r67.going_to_ns := r67.going_to_f_trig.Q;

	r68.fire_r_trig(CLK:=r68.fire);
	r68.fire_f_trig(CLK:=r68.fire);
	r68.fire_os := r68.fire_r_trig.Q;
	r68.fire_ns := r68.fire_f_trig.Q;
	r68.going_to_r_trig(CLK:=r68.going_to);
	r68.going_to_f_trig(CLK:=r68.going_to);
	r68.going_to_os := r68.going_to_r_trig.Q;
	r68.going_to_ns := r68.going_to_f_trig.Q;

	r69.fire_r_trig(CLK:=r69.fire);
	r69.fire_f_trig(CLK:=r69.fire);
	r69.fire_os := r69.fire_r_trig.Q;
	r69.fire_ns := r69.fire_f_trig.Q;
	r69.going_to_r_trig(CLK:=r69.going_to);
	r69.going_to_f_trig(CLK:=r69.going_to);
	r69.going_to_os := r69.going_to_r_trig.Q;
	r69.going_to_ns := r69.going_to_f_trig.Q;

	r70.fire_r_trig(CLK:=r70.fire);
	r70.fire_f_trig(CLK:=r70.fire);
	r70.fire_os := r70.fire_r_trig.Q;
	r70.fire_ns := r70.fire_f_trig.Q;
	r70.going_to_r_trig(CLK:=r70.going_to);
	r70.going_to_f_trig(CLK:=r70.going_to);
	r70.going_to_os := r70.going_to_r_trig.Q;
	r70.going_to_ns := r70.going_to_f_trig.Q;

	r71.fire_r_trig(CLK:=r71.fire);
	r71.fire_f_trig(CLK:=r71.fire);
	r71.fire_os := r71.fire_r_trig.Q;
	r71.fire_ns := r71.fire_f_trig.Q;
	r71.going_to_r_trig(CLK:=r71.going_to);
	r71.going_to_f_trig(CLK:=r71.going_to);
	r71.going_to_os := r71.going_to_r_trig.Q;
	r71.going_to_ns := r71.going_to_f_trig.Q;

	r72.fire_r_trig(CLK:=r72.fire);
	r72.fire_f_trig(CLK:=r72.fire);
	r72.fire_os := r72.fire_r_trig.Q;
	r72.fire_ns := r72.fire_f_trig.Q;
	r72.going_to_r_trig(CLK:=r72.going_to);
	r72.going_to_f_trig(CLK:=r72.going_to);
	r72.going_to_os := r72.going_to_r_trig.Q;
	r72.going_to_ns := r72.going_to_f_trig.Q;

	r73.fire_r_trig(CLK:=r73.fire);
	r73.fire_f_trig(CLK:=r73.fire);
	r73.fire_os := r73.fire_r_trig.Q;
	r73.fire_ns := r73.fire_f_trig.Q;
	r73.going_to_r_trig(CLK:=r73.going_to);
	r73.going_to_f_trig(CLK:=r73.going_to);
	r73.going_to_os := r73.going_to_r_trig.Q;
	r73.going_to_ns := r73.going_to_f_trig.Q;

	r74.fire_r_trig(CLK:=r74.fire);
	r74.fire_f_trig(CLK:=r74.fire);
	r74.fire_os := r74.fire_r_trig.Q;
	r74.fire_ns := r74.fire_f_trig.Q;
	r74.going_to_r_trig(CLK:=r74.going_to);
	r74.going_to_f_trig(CLK:=r74.going_to);
	r74.going_to_os := r74.going_to_r_trig.Q;
	r74.going_to_ns := r74.going_to_f_trig.Q;


END_PROGRAM