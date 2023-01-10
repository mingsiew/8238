(********************************************************************
 * Program: dbounce
 * File: dbounce.st
 ********************************************************************)
PROGRAM _CYCLIC
	(* Pulse Generators *)
	one_sec_pulse(IN:= not_one_sec_pulse.Q, PT:= t#1s);
	not_one_sec_pulse(IN:=NOT(one_sec_pulse.Q), PT:= t#1s);
	thirty_msec_pulse(IN:= not_thirty_msec_pulse.Q, PT:= t#30ms);
	not_thirty_msec_pulse(IN:=NOT(thirty_msec_pulse.Q), PT:= t#30ms);

END_PROGRAM