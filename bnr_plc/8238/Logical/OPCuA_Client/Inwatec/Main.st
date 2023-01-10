
PROGRAM _INIT
//Config and manage inwatec OPCuA communications
Inwatec[1].Config.ServerURL := 'opc.tcp://10.16.118.1:3001'; 
Inwatec[1].Config.Direction := INWATEC_RELEASE_TO;	
Inwatec[1].Config.CommID 		:= 81;	

Inwatec[2].Config.ServerURL := 'opc.tcp://10.16.118.1:3002'; 
Inwatec[2].Config.Direction := INWATEC_RELEASE_TO;	
Inwatec[2].Config.CommID 		:= 82;		

Inwatec[3].Config.ServerURL := 'opc.tcp://10.16.118.1:3003'; 
Inwatec[3].Config.Direction := INWATEC_RELEASE_TO;	
Inwatec[3].Config.CommID 		:= 83;	

Inwatec[4].Config.ServerURL := 'opc.tcp://10.16.118.1:3101'; 
Inwatec[4].Config.Direction := INWATEC_RECIEVE_FROM;	
Inwatec[4].Config.CommID 		:= 84;	

Inwatec[5].Config.ServerURL := 'opc.tcp://10.16.118.1:3102'; 
Inwatec[5].Config.Direction := INWATEC_RECIEVE_FROM;	
Inwatec[5].Config.CommID 		:= 85;		

Inwatec[6].Config.ServerURL := 'opc.tcp://10.16.118.1:3103'; 
Inwatec[6].Config.Direction := INWATEC_RECIEVE_FROM;	
Inwatec[6].Config.CommID 		:= 86;		

Inwatec[7].Config.ServerURL := 'opc.tcp://10.16.118.2:3001'; 
Inwatec[7].Config.Direction := INWATEC_RELEASE_TO;	
Inwatec[7].Config.CommID 		:= 87;	

Inwatec[8].Config.ServerURL := 'opc.tcp://10.16.118.2:3002'; 
Inwatec[8].Config.Direction := INWATEC_RELEASE_TO;	
Inwatec[8].Config.CommID 		:= 88;		

Inwatec[9].Config.ServerURL := 'opc.tcp://10.16.118.2:3003'; 
Inwatec[9].Config.Direction := INWATEC_RELEASE_TO;	
Inwatec[9].Config.CommID 		:= 89;	

Inwatec[10].Config.ServerURL := 'opc.tcp://10.16.118.2:3004'; 
Inwatec[10].Config.Direction := INWATEC_RELEASE_TO;	
Inwatec[10].Config.CommID 		:= 90;	

Inwatec[11].Config.ServerURL := 'opc.tcp://10.16.118.2:3101'; 
Inwatec[11].Config.Direction := INWATEC_RECIEVE_FROM;	
Inwatec[11].Config.CommID 		:= 91;	

END_PROGRAM

PROGRAM _CYCLIC


FOR i := 1 TO MAX_INWATEC_INTERFACES DO	
	iw ACCESS ADR(Inwatec[i]);
	//Range check	
	IF (iw.Config.CommID > 0) AND (iw.Config.CommID <= MAX_COMM) THEN			
		comm ACCESS ADR(Comm[iw.Config.CommID]);
		
		CASE iw.Config.Direction OF	
			INWATEC_RELEASE_TO:  // We need to set the batch information
				iw_d ACCESS ADR(iw.Outlet);		// Write Vars
				iw_r ACCESS ADR(iw.Inlet);		// Read Vars
					
				iw_d.batch_id 					:= comm.BatchID;
				iw_d.weight 						:= (UINT_TO_REAL(comm.Weight)/10); 
				iw_d.customer_numeric 	:= comm.Customer;	
				iw_d.category_numeric		:= comm.Category;
				iw_d.batch_count 				:= comm.Batch_QtyRemaining;
				
				iw_d.tx_handshake.0 		:= comm.BagReady;				// Bag in position
					
				// Read Variables	
				comm.DropLoad 				:= iw_r.tx_handshake.0;
				comm.Unloading				:= iw_r.tx_handshake.1;
				comm.LoadDropped			:= iw_r.tx_handshake.2;
						
			
			INWATEC_RECIEVE_FROM:// We are reading the batch information.
				iw_d ACCESS ADR(iw.Inlet); 		// Write Vars
				iw_r ACCESS ADR(iw.Outlet);		// Read Vars
					
				iw_d.tx_handshake.0 		:= comm.ReadyToLoad; 	// Bag in position ready for load
				iw_d.tx_handshake.1 		:= comm.Loading;			// Recieving load
				iw_d.tx_handshake.2 		:= comm.LoadRecieved;	// Bag has recieved the load
					
				// Read Variables	
				comm.BatchID 						:= iw_r.batch_id; 
				comm.Weight							:= REAL_TO_UINT(iw_r.weight * 10);
				comm.Customer 					:= iw_r.customer_numeric;	
				comm.Category						:= iw_r.category_numeric;
				comm.Batch_QtyRemaining	:= iw_r.batch_count;
			
				comm.ReadyToLoad				:= iw_r.tx_handshake.0;
				comm.Unloading					:= iw_r.tx_handshake.1;
				comm.UnloadFinished			:= iw_r.tx_handshake.2;
						
			ELSE	
				iw_d ACCESS ADR(iw.Inlet);	// Code just ensure we don;t get a pointer error.
				iw_r ACCESS ADR(iw.Outlet);	
		END_CASE;		
		
		//Common controls.
		iw_d.system_status.0 := 0;// Is there any alarm on the device;
		iw_d.system_status.1 := 1; // PLC is alive;	
		iw_d.system_status.2 := NOT comm.HaltSys; // System is in production (Maybe map Estop zone here)
		
		iw_d.i_am_alive 			:= Std.Clock1s; 		
			
		IF iw_r.i_am_alive THEN	
			comm.LiveTime := 500; // 5s ish..
			iw_r.i_am_alive := 0;	
		ELSIF (comm.LiveTime > 0) THEN
				comm.LiveTime := (comm.LiveTime - 1);
		END_IF;
		comm.Live := (comm.LiveTime > 0); 	

	END_IF;	
END_FOR;	
 

END_PROGRAM



