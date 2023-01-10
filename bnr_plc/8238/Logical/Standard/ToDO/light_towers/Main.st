
PROGRAM _INIT
  myZone[1] := 1;
  myZone[2] := 11;	 
END_PROGRAM

PROGRAM _CYCLIC
  // Soiled Tower
  AlarmOutput[1] := system_alarm_2 OR soiled_validation_alarm OR halted;
  AlarmOutput[2] := system_alarm_1 OR clean_validation_alarm OR halted;

  FOR n := 1 TO MAX_SYSTEMS DO
    safeZone ACCESS ADR(SafetyZone[myZone[n]]);
    
    tmrAlmOutput[n].IN := AlarmOutput[n];
    tmrAlmOutput[n].PT := T#5s;
    tmrAlmOutput[n]();
    
    safeZone.TowerLight.TL_DO_Red 		:= FALSE;
    safeZone.TowerLight.TL_DO_Yellow	:= FALSE;
    safeZone.TowerLight.TL_DO_Green	:= FALSE;	
    IF safeZone.HaltSys AND NOT safeZone.ResetReady THEN	//Emergency stop blink red. (State 1)
      safeZone.TowerLight.TL_DO_Red 		:= Std.Clock1s ;
    ELSIF safeZone.HaltSys THEN // Estop waiting for reset  (State 2)
      safeZone.TowerLight.TL_DO_Yellow		:= Std.Clock1s;
    ELSIF AlarmOutput[n] THEN //State 10 -- Show Warning Not Fault when alarm is on as other parts might still be running		
      safeZone.TowerLight.TL_DO_Yellow 	:= TRUE;		
      safeZone.TowerLight.TL_DO_Green	 := TRUE;
    ELSE //Machine Running (State 6)	
      safeZone.TowerLight.TL_DO_Green	 := TRUE;
    END_IF;		
    safeZone.TowerLight.TL_DO_Sounder := (AlarmOutput[n] AND NOT tmrAlmOutput[n].Q);
  END_FOR;
    
END_PROGRAM


