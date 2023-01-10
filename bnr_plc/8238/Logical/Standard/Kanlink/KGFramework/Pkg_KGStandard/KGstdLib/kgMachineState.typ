(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Package: Pkg_KGStandard
 * File: kgMachineState.typ
 * Author: hunholz
 * Created: April 11, 2012
 ********************************************************************
 * Data types of package Pkg_KGStandard
 ********************************************************************)

TYPE
	kgMachineState_enum : 
		(
		msOFF := 0, (*Machine turned off*)
		msEmergency_Stop := 1, (*Emergency stop*)
		msSafe := 2, (*Safety stop*)
		msFault := 3, (*Fault*)
		msFaultWaitQuit := 4, (*Fault, waiting for acknowledge*)
		msService := 5, (*Service*)
		msAutomatic := 6, (*Automatic run*)
		msStop := 7, (*Stop*)
		msStandby := 8, (*Automatic wait (Standby)*)
		msStandbyWaitQuit := 9, (*Automatic wait for manuel action*)
		msWarning := 10, (*Automatic warning*)
		msAuto_Dryer_Heating := 30,
		msAuto_Dryer_Cooldown := 31,
		msAuto_Dryer_Clean_Filter := 32,
		msAuto_Dryer_Afterrung := 33,
		msAuto_Dryer_Cleaningfan_Running := 34,
		msAuto_Conv_Fwd := 40,
		msAuto_Conv_Fwd2nd := 41,
		msAuto_Conv_Rev := 42,
		msAuto_Conv_Rev2nd := 43
		);
END_TYPE
