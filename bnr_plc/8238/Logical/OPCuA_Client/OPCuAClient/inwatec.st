
ACTION _inwatec_config: 

FOR i := 1 TO MAX_INWATEC_INTERFACES DO	
	//Always match the inwatec array to the opcua array
	iw ACCESS ADR(Inwatec[i]);
	client ACCESS ADR(OPCuA_Client[i]);	
	
	client.Config.ServerURL :=	iw.Config.ServerURL;
	client.Config.SessionUser := iw.Config.Authenication;
	
	CASE iw.Config.Direction OF	
		0: //Dropping onto Inwatec
			//Write to Outlet, Read from Inlet
			
			client.Config.Data.Read[0].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.batch_count';  	
			client.Config.Data.Read[1].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.batch_id';  		
			client.Config.Data.Read[2].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.category';  	
			client.Config.Data.Read[3].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.category_name';  		
			client.Config.Data.Read[4].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.category_numeric';  		
			client.Config.Data.Read[5].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.customer';  		
			client.Config.Data.Read[6].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.customer_name';  	
			client.Config.Data.Read[7].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.customer_numeric';  	
			client.Config.Data.Read[8].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.i_am_alive';  
			client.Config.Data.Read[9].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.lot'; 
			client.Config.Data.Read[10].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.lot_numeric'; 
			client.Config.Data.Read[11].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.option_1'; 
			client.Config.Data.Read[12].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.option_2'; 
			client.Config.Data.Read[13].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.source_id'; 
			client.Config.Data.Read[14].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.sublot'; 
			client.Config.Data.Read[15].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.sublot_numeric'; 	
			client.Config.Data.Read[16].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.system_status'; 
			client.Config.Data.Read[17].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.tx_handshake'; 
			client.Config.Data.Read[18].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.weight'; 
			client.Config.Data.Read[19].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.option_flag_1'; 
			client.Config.Data.Read[20].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].inlet.option_flag_2'; 
				
			client.Config.Data.Write[0].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.batch_count';  	
			client.Config.Data.Write[1].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.batch_id';  		
			client.Config.Data.Write[2].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.category';  	
			client.Config.Data.Write[3].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.category_name';  		
			client.Config.Data.Write[4].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.category_numeric';  		
			client.Config.Data.Write[5].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.customer';  		
			client.Config.Data.Write[6].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.customer_name';  	
			client.Config.Data.Write[7].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.customer_numeric';  	
			client.Config.Data.Write[8].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.i_am_alive';  
			client.Config.Data.Write[9].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.lot'; 
			client.Config.Data.Write[10].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.lot_numeric'; 
			client.Config.Data.Write[11].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.option_1'; 
			client.Config.Data.Write[12].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.option_2'; 
			client.Config.Data.Write[13].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.source_id'; 
			client.Config.Data.Write[14].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.sublot'; 
			client.Config.Data.Write[15].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.sublot_numeric'; 	
			client.Config.Data.Write[16].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.system_status'; 
			client.Config.Data.Write[17].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.tx_handshake'; 
			client.Config.Data.Write[18].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.weight'; 	
			client.Config.Data.Write[19].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.option_flag_1'; 
			client.Config.Data.Write[20].NodeID.Identifier := '::BatchIn:batch_to_inwatec[0].outlet.option_flag_2'; 	
			

			brsitoa(i,ADR(str_index));	
			FOR x := 0 TO MAX_READ_NODES DO 
				client.Config.Data.Read[x].Variable := 'Inwatec[';			
				brsstrcat(ADR(client.Config.Data.Read[x].Variable),ADR(str_index));
			END_FOR;		
			brsstrcat(ADR(client.Config.Data.Read[0].Variable),ADR('].Inlet.batch_count'));	
			brsstrcat(ADR(client.Config.Data.Read[1].Variable),ADR('].Inlet.batch_id'));	
			brsstrcat(ADR(client.Config.Data.Read[2].Variable),ADR('].Inlet.category'));		
			brsstrcat(ADR(client.Config.Data.Read[3].Variable),ADR('].Inlet.category_name'));		
			brsstrcat(ADR(client.Config.Data.Read[4].Variable),ADR('].Inlet.category_numeric'));	
			brsstrcat(ADR(client.Config.Data.Read[5].Variable),ADR('].Inlet.customer'));	
			brsstrcat(ADR(client.Config.Data.Read[6].Variable),ADR('].Inlet.customer_name'));		
			brsstrcat(ADR(client.Config.Data.Read[7].Variable),ADR('].Inlet.customer_numeric'));	
			brsstrcat(ADR(client.Config.Data.Read[8].Variable),ADR('].Inlet.i_am_alive'));	
			brsstrcat(ADR(client.Config.Data.Read[9].Variable),ADR('].Inlet.lot'));	
			brsstrcat(ADR(client.Config.Data.Read[10].Variable),ADR('].Inlet.lot_numeric'));		
			brsstrcat(ADR(client.Config.Data.Read[11].Variable),ADR('].Inlet.option_1'));	
			brsstrcat(ADR(client.Config.Data.Read[12].Variable),ADR('].Inlet.option_2'));	
			brsstrcat(ADR(client.Config.Data.Read[13].Variable),ADR('].Inlet.source_id'));	
			brsstrcat(ADR(client.Config.Data.Read[14].Variable),ADR('].Inlet.sublot'));		
			brsstrcat(ADR(client.Config.Data.Read[15].Variable),ADR('].Inlet.sublot_numeric'));	
			brsstrcat(ADR(client.Config.Data.Read[16].Variable),ADR('].Inlet.system_status'));	
			brsstrcat(ADR(client.Config.Data.Read[17].Variable),ADR('].Inlet.tx_handshake'));	
			brsstrcat(ADR(client.Config.Data.Read[18].Variable),ADR('].Inlet.weight'));	
			brsstrcat(ADR(client.Config.Data.Read[19].Variable),ADR('].Inlet.option_flag_1'));		
			brsstrcat(ADR(client.Config.Data.Read[20].Variable),ADR('].Inlet.option_flag_2'));	
			
			brsitoa(i,ADR(str_index));	
			FOR x := 0 TO MAX_WRITE_NODES DO 
				client.Config.Data.Read[x].Variable := 'Inwatec[';			
				brsstrcat(ADR(client.Config.Data.Read[x].Variable),ADR(str_index));
			END_FOR;		
			brsstrcat(ADR(client.Config.Data.Write[0].Variable),ADR('].Outlet.batch_count'));	
			brsstrcat(ADR(client.Config.Data.Write[1].Variable),ADR('].Outlet.batch_id'));	
			brsstrcat(ADR(client.Config.Data.Write[2].Variable),ADR('].Outlet.category'));		
			brsstrcat(ADR(client.Config.Data.Write[3].Variable),ADR('].Outlet.category_name'));		
			brsstrcat(ADR(client.Config.Data.Write[4].Variable),ADR('].Outlet.category_numeric'));	
			brsstrcat(ADR(client.Config.Data.Write[5].Variable),ADR('].Outlet.customer'));	
			brsstrcat(ADR(client.Config.Data.Write[6].Variable),ADR('].Outlet.customer_name'));		
			brsstrcat(ADR(client.Config.Data.Write[7].Variable),ADR('].Outlet.customer_numeric'));	
			brsstrcat(ADR(client.Config.Data.Write[8].Variable),ADR('].Outlet.i_am_alive'));	
			brsstrcat(ADR(client.Config.Data.Write[9].Variable),ADR('].Outlet.lot'));	
			brsstrcat(ADR(client.Config.Data.Write[10].Variable),ADR('].Outlet.lot_numeric'));		
			brsstrcat(ADR(client.Config.Data.Write[11].Variable),ADR('].Outlet.option_1'));	
			brsstrcat(ADR(client.Config.Data.Write[12].Variable),ADR('].Outlet.option_2'));	
			brsstrcat(ADR(client.Config.Data.Write[13].Variable),ADR('].Outlet.source_id'));	
			brsstrcat(ADR(client.Config.Data.Write[14].Variable),ADR('].Outlet.sublot'));		
			brsstrcat(ADR(client.Config.Data.Write[15].Variable),ADR('].Outlet.sublot_numeric'));	
			brsstrcat(ADR(client.Config.Data.Write[16].Variable),ADR('].Outlet.system_status'));	
			brsstrcat(ADR(client.Config.Data.Write[17].Variable),ADR('].Outlet.tx_handshake'));	
			brsstrcat(ADR(client.Config.Data.Write[18].Variable),ADR('].Outlet.weight'));	
			brsstrcat(ADR(client.Config.Data.Write[19].Variable),ADR('].Outlet.option_flag_1'));		
			brsstrcat(ADR(client.Config.Data.Write[20].Variable),ADR('].Outlet.option_flag_2'));		
				
		1: //Recieving from Inwatec	
				//Write to Inlet, Read from Outlet
				client.Config.Data.Read[0].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.batch_count';  	
				client.Config.Data.Read[1].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.batch_id';  		
				client.Config.Data.Read[2].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.category';  	
				client.Config.Data.Read[3].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.category_name';  		
				client.Config.Data.Read[4].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.category_numeric';  		
				client.Config.Data.Read[5].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.customer';  		
				client.Config.Data.Read[6].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.customer_name';  	
				client.Config.Data.Read[7].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.customer_numeric';  	
				client.Config.Data.Read[8].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.i_am_alive';  
				client.Config.Data.Read[9].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.lot'; 
				client.Config.Data.Read[10].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.lot_numeric'; 
				client.Config.Data.Read[11].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.option_1'; 
				client.Config.Data.Read[12].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.option_2'; 
				client.Config.Data.Read[13].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.source_id'; 
				client.Config.Data.Read[14].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.sublot'; 
				client.Config.Data.Read[15].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.sublot_numeric'; 	
				client.Config.Data.Read[16].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.system_status'; 
				client.Config.Data.Read[17].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.tx_handshake'; 
				client.Config.Data.Read[18].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.weight'; 
				client.Config.Data.Read[19].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.option_flag_1'; 
				client.Config.Data.Read[20].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].outlet.option_flag_2'; 
				
				client.Config.Data.Write[0].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.batch_count';  	
				client.Config.Data.Write[1].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.batch_id';  		
				client.Config.Data.Write[2].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.category';  	
				client.Config.Data.Write[3].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.category_name';  		
				client.Config.Data.Write[4].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.category_numeric';  		
				client.Config.Data.Write[5].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.customer';  		
				client.Config.Data.Write[6].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.customer_name';  	
				client.Config.Data.Write[7].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.customer_numeric';  	
				client.Config.Data.Write[8].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.i_am_alive';  
				client.Config.Data.Write[9].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.lot'; 
				client.Config.Data.Write[10].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.lot_numeric'; 
				client.Config.Data.Write[11].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.option_1'; 
				client.Config.Data.Write[12].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.option_2'; 
				client.Config.Data.Write[13].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.source_id'; 
				client.Config.Data.Write[14].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.sublot'; 
				client.Config.Data.Write[15].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.sublot_numeric'; 	
				client.Config.Data.Write[16].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.system_status'; 
				client.Config.Data.Write[17].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.tx_handshake'; 
				client.Config.Data.Write[18].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.weight'; 	
				client.Config.Data.Write[19].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.option_flag_1'; 
				client.Config.Data.Write[20].NodeID.Identifier := '::BatchOut:batch_from_inwatec[0].inlet.option_flag_2'; 	
			

				brsitoa(i,ADR(str_index));	
				FOR x := 0 TO MAX_READ_NODES DO 
					client.Config.Data.Read[x].Variable := 'Inwatec[';			
					brsstrcat(ADR(client.Config.Data.Read[x].Variable),ADR(str_index));
				END_FOR;		
				brsstrcat(ADR(client.Config.Data.Read[0].Variable),ADR('].Outlet.batch_count'));	
				brsstrcat(ADR(client.Config.Data.Read[1].Variable),ADR('].Outlet.batch_id'));	
				brsstrcat(ADR(client.Config.Data.Read[2].Variable),ADR('].Outlet.category'));		
				brsstrcat(ADR(client.Config.Data.Read[3].Variable),ADR('].Outlet.category_name'));		
				brsstrcat(ADR(client.Config.Data.Read[4].Variable),ADR('].Outlet.category_numeric'));	
				brsstrcat(ADR(client.Config.Data.Read[5].Variable),ADR('].Outlet.customer'));	
				brsstrcat(ADR(client.Config.Data.Read[6].Variable),ADR('].Outlet.customer_name'));		
				brsstrcat(ADR(client.Config.Data.Read[7].Variable),ADR('].Outlet.customer_numeric'));	
				brsstrcat(ADR(client.Config.Data.Read[8].Variable),ADR('].Outlet.i_am_alive'));	
				brsstrcat(ADR(client.Config.Data.Read[9].Variable),ADR('].Outlet.lot'));	
				brsstrcat(ADR(client.Config.Data.Read[10].Variable),ADR('].Outlet.lot_numeric'));		
				brsstrcat(ADR(client.Config.Data.Read[11].Variable),ADR('].Outlet.option_1'));	
				brsstrcat(ADR(client.Config.Data.Read[12].Variable),ADR('].Outlet.option_2'));	
				brsstrcat(ADR(client.Config.Data.Read[13].Variable),ADR('].Outlet.source_id'));	
				brsstrcat(ADR(client.Config.Data.Read[14].Variable),ADR('].Outlet.sublot'));		
				brsstrcat(ADR(client.Config.Data.Read[15].Variable),ADR('].Outlet.sublot_numeric'));	
				brsstrcat(ADR(client.Config.Data.Read[16].Variable),ADR('].Outlet.system_status'));	
				brsstrcat(ADR(client.Config.Data.Read[17].Variable),ADR('].Outlet.tx_handshake'));	
				brsstrcat(ADR(client.Config.Data.Read[18].Variable),ADR('].Outlet.weight'));	
				brsstrcat(ADR(client.Config.Data.Read[19].Variable),ADR('].Outlet.option_flag_1'));		
				brsstrcat(ADR(client.Config.Data.Read[20].Variable),ADR('].Outlet.option_flag_2'));	
			
				brsitoa(i,ADR(str_index));	
				FOR x := 0 TO MAX_WRITE_NODES DO 
					client.Config.Data.Read[x].Variable := 'Inwatec[';			
					brsstrcat(ADR(client.Config.Data.Read[x].Variable),ADR(str_index));
				END_FOR;		
				brsstrcat(ADR(client.Config.Data.Write[0].Variable),ADR('].Inlet.batch_count'));	
				brsstrcat(ADR(client.Config.Data.Write[1].Variable),ADR('].Inlet.batch_id'));	
				brsstrcat(ADR(client.Config.Data.Write[2].Variable),ADR('].Inlet.category'));		
				brsstrcat(ADR(client.Config.Data.Write[3].Variable),ADR('].Inlet.category_name'));		
				brsstrcat(ADR(client.Config.Data.Write[4].Variable),ADR('].Inlet.category_numeric'));	
				brsstrcat(ADR(client.Config.Data.Write[5].Variable),ADR('].Inlet.customer'));	
				brsstrcat(ADR(client.Config.Data.Write[6].Variable),ADR('].Inlet.customer_name'));		
				brsstrcat(ADR(client.Config.Data.Write[7].Variable),ADR('].Inlet.customer_numeric'));	
				brsstrcat(ADR(client.Config.Data.Write[8].Variable),ADR('].Inlet.i_am_alive'));	
				brsstrcat(ADR(client.Config.Data.Write[9].Variable),ADR('].Inlet.lot'));	
				brsstrcat(ADR(client.Config.Data.Write[10].Variable),ADR('].Inlet.lot_numeric'));		
				brsstrcat(ADR(client.Config.Data.Write[11].Variable),ADR('].Inlet.option_1'));	
				brsstrcat(ADR(client.Config.Data.Write[12].Variable),ADR('].Inlet.option_2'));	
				brsstrcat(ADR(client.Config.Data.Write[13].Variable),ADR('].Inlet.source_id'));	
				brsstrcat(ADR(client.Config.Data.Write[14].Variable),ADR('].Inlet.sublot'));		
				brsstrcat(ADR(client.Config.Data.Write[15].Variable),ADR('].Inlet.sublot_numeric'));	
				brsstrcat(ADR(client.Config.Data.Write[16].Variable),ADR('].Inlet.system_status'));	
				brsstrcat(ADR(client.Config.Data.Write[17].Variable),ADR('].Inlet.tx_handshake'));	
				brsstrcat(ADR(client.Config.Data.Write[18].Variable),ADR('].Inlet.weight'));	
				brsstrcat(ADR(client.Config.Data.Write[19].Variable),ADR('].Inlet.option_flag_1'));		
				brsstrcat(ADR(client.Config.Data.Write[20].Variable),ADR('].Inlet.option_flag_2'));			
			
		END_CASE;
	
		
END_FOR;		

END_ACTION
