
PROGRAM _INIT
//Set all the rail states to perm.	

FOR n := 1 TO MAX_RAILS DO	
  //build the var_name;

  pSettings.Rail_Counter[n] := ADR(gSettings.Rail[n].Count);
  pSettings.Rail_State[n] := ADR(gSettings.Rail[n].State);

  itoa(n,ADR(index_string));	
  //r109.state                      
  var_name := 'r'; 
  brsstrcat(ADR(var_name),ADR(index_string));
  brsstrcat(ADR(var_name),ADR('.state'));	
  // Get the Pointer address.
  IF (PV_xgetadr(ADR(var_name),ADR(pVar),ADR(sVar)) = 0) THEN
    p.Rail_State[n] := pVar;
    brsmemcpy(p.Rail_State[n],pSettings.Rail_State[n],2);
  ELSE	
    p.Rail_State[n] := 0;	
  END_IF;
	
  var_name := 'r'; 
  brsstrcat(ADR(var_name),ADR(index_string));
  brsstrcat(ADR(var_name),ADR('.counter'));		
  IF (PV_xgetadr(ADR(var_name),ADR(pVar),ADR(sVar)) = 0) THEN
    p.Rail_Counter[n] := pVar;
    brsmemcpy(p.Rail_Counter[n],pSettings.Rail_Counter[n],2);
  ELSE	
    p.Rail_Counter[n] := 0;	
  END_IF;	
END_FOR;   

END_PROGRAM

PROGRAM _CYCLIC
(*******************************
Update belt speeds.	
*******************************)		
// Set the values from eVue.

beltSpeed[1] := Get_HigherByte(conveyor_module_1_value_1);
beltSpeed[2] := Get_LowerByte(conveyor_module_1_value_1);
beltSpeed[3] := Get_HigherByte(conveyor_module_1_value_2);
beltSpeed[4] := Get_LowerByte(conveyor_module_1_value_2);
//beltSpeed[5] := Get_HigherByte(conveyor_module_1_value_3);
//beltSpeed[6] := Get_LowerByte(conveyor_module_1_value_3);
//
FOR n := 1 TO MAX_DRIVES DO
  IF (beltSpeed[n] > 0) AND (beltSpeed[n] <> gSettings.Drive[n].TargetVelocity) THEN	
    gSettings.Drive[n].TargetVelocity := beltSpeed[n];
  ELSIF (gSettings.Drive[n].TargetVelocity = 0) THEN	
    gSettings.Drive[n].TargetVelocity := ABB_MAX_VELOCITY;	
  END_IF;
END_FOR;


FOR n := 1 TO MAX_RAILS DO	
  IF (p.Rail_Counter[n] > 0) AND (pSettings.Rail_Counter[n] > 0) THEN
    brsmemcpy(pSettings.Rail_Counter[n],p.Rail_Counter[n],2);	
  END_IF;		
  IF (p.Rail_State[n] > 0) AND (pSettings.Rail_State[n] > 0) THEN
    brsmemcpy(pSettings.Rail_State[n],p.Rail_State[n],2);	
  END_IF;		

END_FOR;		






END_PROGRAM


