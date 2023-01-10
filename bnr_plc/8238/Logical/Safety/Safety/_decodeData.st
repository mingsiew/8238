
ACTION _decodeData: 

//	Zone Status Encoding
//	0 - Zone Input State
//	1 - Zone Ready FOR Reset
//	2 - E-stop FUB error
//	3 - EDM Input State
//	4 - EDM Ready
//	5 - EDM Error
//	6 - EDM Disabled
//	7 - Zone Dependancy
//	8 - Safe System OK
//	9 - Auto Reset
//	10 - ACCESS Request 
//	11 - Zone Status
		
	
safeZone.Zone_Status 		:= safeZone.DataFromSafePLC.11;	
safeZone.ResetReady			:= safeZone.DataFromSafePLC.1;		
safeZone.RequestAccess		:= safeZone.DataFromSafePLC.10;   // Derived in the PLC from from Zone Healthy and Reset Push button 	
	
		
	
	

END_ACTION
