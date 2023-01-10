

PROGRAM _CYCLIC
	AutoRefTolerance := 50; //10 = 1mm	
	FOR n:= 1 TO MaxRobo DO	
		i_refSwitch := X[30 + (n * 2)].X04;
		refPLS[n].CLK := i_refSwitch;
		refPLS[n]();	
		PositionError := 0;		
		IF (RB[n].Lift.SeqStep = 30) AND refPLS[n].Q THEN
			IF RB[n].Lift.RunReverse THEN
				PositionError := (RB_Posn[n].Lift.RefOffset - RB[n].Lift.PosnNow);	
				IF n = debugRB THEN
					lastPosError := PositionError;
				END_IF;	
			END_IF;		
			IF 	(RB[n].Lift.PosnAct > RB_Retain[n].Lift.PosnRef + AutoRefTolerance) 
				OR (RB[n].Lift.PosnAct < (RB_Retain[n].Lift.PosnRef + AutoRefTolerance)) THEN//Check Hoist is going down FOR direction onto Prox
				//;MASK out +/- with ABS
				IF (ABS(PositionError) > AutoRefTolerance) THEN
					RB[n].Lift.SeqStep := 23;
				END_IF;
			END_IF;
		END_IF;
	END_FOR;		
	 
END_PROGRAM



