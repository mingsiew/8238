
PROGRAM _CYCLIC

	
//	Std.SafetyOnZone[1]	;Soiled EStops + SIC1-4 + SIC7
//	Std.SafetyOnZone[2]	;SSL1 Guarded Area + STB1, STB2, STB11
//	Std.SafetyOnZone[3]	;SSL2 Guarded Area + STB3, STB4, STB12
//	Std.SafetyOnZone[4]	;STB5, STB6, STB7
//	Std.SafetyOnZone[5]	;STB8, STB9, STB10
//	Std.SafetyOnZone[6]	;SB1
//	Std.SafetyOnZone[7]	;SB2
//	Std.SafetyOnZone[8]	;SB3
//	Std.SafetyOnZone[9]	;SB4
//
//No access on zone 0
	
		
	//	SafetyZone[0].BagsInTransit :=  FALSE;  // Safe to enter when false (Switch is NO) FALSE WHEN OK..
	//	SafetyZone[0].HoistsOutOfPosition := FALSE; //<-- This is used to stop the door from opening if not position FALSE IS OK -- SWITCH IS NC..
	SafetyZone[1].ResetButton := X[1001].X03 OR X[1003].X03;
	SafetyZone[2].ResetButton := SM[1401].DigitalInput01 OR SM[1404].DigitalInput01;
	SafetyZone[3].ResetButton := SM[1402].DigitalInput01 OR SM[1406].DigitalInput01;
	SafetyZone[4].ResetButton := SM[1402].DigitalInput02;
	SafetyZone[5].ResetButton := SM[1406].DigitalInput02;
	SafetyZone[6].ResetButton := X[1001].X03 OR X[1003].X03;
	SafetyZone[7].ResetButton := X[1001].X03 OR X[1003].X03;
	SafetyZone[8].ResetButton := X[1001].X03 OR X[1003].X03;
	SafetyZone[9].ResetButton := X[1001].X03 OR X[1003].X03;
	
	SafetyZone[1].BagsInTransit :=  FALSE;
	SafetyZone[1].HoistsOutOfPosition := FALSE;
	
	SafetyZone[2].BagsInTransit :=  FALSE;
	SafetyZone[2].HoistsOutOfPosition := FALSE;
	
	SafetyZone[3].BagsInTransit :=  FALSE;
	SafetyZone[3].HoistsOutOfPosition := FALSE;
	
	SafetyZone[4].BagsInTransit :=  FALSE;
	SafetyZone[4].HoistsOutOfPosition := FALSE;
	
	SafetyZone[5].BagsInTransit :=  FALSE;
	SafetyZone[5].HoistsOutOfPosition := FALSE;
	
	SafetyZone[6].BagsInTransit :=  FALSE;
	SafetyZone[6].HoistsOutOfPosition := FALSE; 	
	
	SafetyZone[7].BagsInTransit :=  FALSE;  
	SafetyZone[7].HoistsOutOfPosition := FALSE;	
	
	SafetyZone[8].BagsInTransit :=  FALSE;  
	SafetyZone[8].HoistsOutOfPosition := FALSE;	
	
	SafetyZone[9].BagsInTransit :=  FALSE;  
	SafetyZone[9].HoistsOutOfPosition := FALSE;	
	

	SM[1401].DigitalOutput01 := SafetyZone[2].DoorLock; //SSL1,STB1,STB2,STB11
	SM[1402].DigitalOutput01 := SafetyZone[3].DoorLock; //SSL2,STB3,STB4,STB12
	//SM[1403].DigitalOutput01 := SafetyZone[10].DoorLock; //SSL3
	SM[1404].DigitalOutput01 := SafetyZone[2].DoorLock; //SSL1,STB1,STB2,STB11
	SM[1404].DigitalOutput02 := SafetyZone[4].DoorLock; //STB5,STB6,STB7
	SM[1406].DigitalOutput01 := SafetyZone[3].DoorLock; //SSL2,STB3,STB4,STB12
	SM[1406].DigitalOutput02 := SafetyZone[13].DoorLock; //STB8,STB9,STB10
	
	
END_PROGRAM
