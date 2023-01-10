(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * PROGRAM: IOLink
 * File: IOLink_Driver.st
 * Author: Stephen Healey
 * Created: Sept 05, 2018
 ********************************************************************
 * Implementation OF PROGRAM IOLink
 ********************************************************************)
//V1.00.1 First Release
//V1.00.1 TR 10/11/2020  - Remove run signal from contactron when there is a fault to allow the error to be acknowledged.

//	Description
//IOLink task for controlling Contactron's and EasyB's
//Constants need to be set. MAX_CONTACTRON and MAX_EASYB should match the hardware
//IO needs to be mapped for the Contactron's in the X20DS438A
//EasyB's IO does not need mapping. The interface still needs enabling in the X20DS438A config

//-------------------------------------------------------------
//-----------------------------Init----------------------------
//-------------------------------------------------------------
//	1.	Configures IOLink physical device, adjust address as needed
//	2.	Resets the controller state, needs to start offset, not 0

//-------------------------------------------------------------
//-----------------------------Cyclic--------------------------
//-------------------------------------------------------------
//	1.	Calls contactron action only if MAX_CONTACTRON is greater than zero
//	2.	Calls easyB action only if MAX_EASYB is greater than zero
//	3.	Monitors tripped status of all the EasyB's and enables reseting

//Use the following charts when setting the trip currents for the IOLink devices

//Contactron 												EasyB
//Current Setting Chart							Current Setting Chart
//Bit 		Nominal current						Enum										USINT			Value			
//3 2 1 0 [mA]																													[mA]
//				 3 A 9 A
//0 0 0 0 180 1500									TRIP_CURRENT_DEFAULT		0					N/A
//0 0 0 1 300 2000									TRIP_CURRENT_500mA			5					500
//0 0 1 0 440 2500									TRIP_CURRENT_1A					10				1000
//0 0 1 1 600 3000									TRIP_CURRENT_2A					20				2000
//0 1 0 0 680 3500									TRIP_CURRENT_3A					30				3000
//0 1 0 1 880 4000									TRIP_CURRENT_4A					40				4000
//0 1 1 0 1000 4500									TRIP_CURRENT_5A					50				5000
//0 1 1 1 1100 5000									TRIP_CURRENT_6A					60				6000
//1 0 0 0 1200 5500									TRIP_CURRENT_8A					80				8000
//1 0 0 1 1500 6000									TRIP_CURRENT_10A				100				10000
//1 0 1 0 1600 6500
//1 0 1 1 1900 7000
//1 1 0 0 2100 7500
//1 1 0 1 2400 8000
//1 1 1 0 2700 8500
//1 1 1 1 3000 9000

PROGRAM _INIT
	//Configuration

	
	//Reset state

	
	backUp.fileDevice := 'UserPart';
	backUp.filePath := 'FuseTripConfig';
	
	//Load from file on boot

	backUp.step := backUpOpen;
END_PROGRAM

PROGRAM _CYCLIC
	//Call status
	IF IO_Link.Status THEN
	 _status;
	END_IF;
	
	//Call httpResponse conditionally
//	IF IO_Link.Load THEN
//		_backUpRead;
//		_encodeData;
//	END_IF;
	
	//Call httpRequest conditionally
//	IF IO_Link.Save THEN
//		_decodeData;
//		_backUpWrite;
//		_encodeData;
//	END_IF;
	
	//Call contactron action
	IF MAX_CONTACTRON > 0 THEN
		_Contactron;
	END_IF;
	
//	//Call easy b action
//	IF (MAX_EASYB > 0) AND (MAX_EASYB <= 40) THEN
//		_EasyB;
//		
//		//Monitor Tripped status
//		IO_Link.EasyB.Tripped := FALSE;
//		FOR n:=1 TO MAX_EASYB DO
//			IF IO_Link.EasyB.EasyB_Array[n].Status.TripState = EASYB_TRIPPED THEN
//				IO_Link.EasyB.Tripped := TRUE;
//				EXIT;
//			END_IF;
//		END_FOR;
//		//Reset Tripped status
//		IF IO_Link.EasyB.Tripped AND IO_Link.EasyB.Reset THEN
//			FOR n:=1 TO MAX_EASYB DO
//				IF IO_Link.EasyB.EasyB_Array[n].Status.TripState = EASYB_TRIPPED THEN
//					IO_Link.EasyB.EasyB_Array[n].Cmd.Reset := TRUE;
//				END_IF;
//			END_FOR;
//			IO_Link.EasyB.Reset := FALSE;
//		END_IF;
//		IO_Link.EasyB.TrippedLamp := IO_Link.EasyB.Tripped AND Std.Clock1s;
//	END_IF;
	
END_PROGRAM