(********************************************************************
 * Program: alarms
 * File: alarms.st
 ********************************************************************)
(*** Reset alarm bits at top of scan ***)
PROGRAM _CYCLIC
	system_alarm_1	:=	0;
	system_alarm_2	:=	0;


	(*** Rail Alarms ***)
	IF r1.alarm OR (r1.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r2.alarm OR (r2.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r3.alarm OR (r3.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r4.alarm OR (r4.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r5.alarm OR (r5.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r6.alarm OR (r6.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r7.alarm OR (r7.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r8.alarm OR (r8.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r9.alarm OR (r9.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r10.alarm OR (r10.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r11.alarm OR (r11.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r12.alarm OR (r12.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r13.alarm OR (r13.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r14.alarm OR (r14.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r15.alarm OR (r15.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r16.alarm OR (r16.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r17.alarm OR (r17.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r18.alarm OR (r18.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r19.alarm OR (r19.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r20.alarm OR (r20.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r21.alarm OR (r21.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r22.alarm OR (r22.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r23.alarm OR (r23.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r24.alarm OR (r24.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r25.alarm OR (r25.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r26.alarm OR (r26.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r27.alarm OR (r27.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r28.alarm OR (r28.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r29.alarm OR (r29.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r30.alarm OR (r30.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r31.alarm OR (r31.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r32.alarm OR (r32.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r33.alarm OR (r33.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r34.alarm OR (r34.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r35.alarm OR (r35.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r36.alarm OR (r36.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r37.alarm OR (r37.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r38.alarm OR (r38.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r39.alarm OR (r39.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r40.alarm OR (r40.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r41.alarm OR (r41.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r42.alarm OR (r42.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r43.alarm OR (r43.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r44.alarm OR (r44.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r45.alarm OR (r45.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r46.alarm OR (r46.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r47.alarm OR (r47.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r48.alarm OR (r48.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r49.alarm OR (r49.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r50.alarm OR (r50.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r51.alarm OR (r51.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r52.alarm OR (r52.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r53.alarm OR (r53.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r54.alarm OR (r54.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r55.alarm OR (r55.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r56.alarm OR (r56.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r57.alarm OR (r57.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r58.alarm OR (r58.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r59.alarm OR (r59.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r60.alarm OR (r60.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r61.alarm OR (r61.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r62.alarm OR (r62.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r63.alarm OR (r63.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r64.alarm OR (r64.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r65.alarm OR (r65.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r66.alarm OR (r66.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r67.alarm OR (r67.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r68.alarm OR (r68.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r69.alarm OR (r69.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r70.alarm OR (r70.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r71.alarm OR (r71.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r72.alarm OR (r72.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r73.alarm OR (r73.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;

	IF r74.alarm OR (r74.warning_com AND 15) > 0 THEN system_alarm_1 := TRUE; END_IF;



	(*** STROBE AND HORN LOGIC ***)
	strobe1 := system_alarm_1 OR soiled_validation_alarm;
	horn1 := not_one_sec_pulse.Q AND (system_alarm_1 OR soiled_validation_alarm);
	strobe2 := system_alarm_2 OR clean_validation_alarm;
	horn2 := not_one_sec_pulse.Q AND (system_alarm_2 OR clean_validation_alarm);

END_PROGRAM