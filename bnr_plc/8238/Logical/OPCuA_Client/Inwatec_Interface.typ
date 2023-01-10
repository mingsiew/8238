
TYPE
	Inwatec_typ : 	STRUCT 
		Inlet : Inwatec_data_typ;
		Outlet : Inwatec_data_typ;
		Config : Inwatec_config_typ;
	END_STRUCT;
	Inwatec_config_typ : 	STRUCT 
		ServerURL : STRING[255];
		Direction : USINT; (*0 = drop to inwatec, 1= recieve from inwatec*)
		Authenication : UAUserIdentityToken := (UserIdentityTokenType:=UAUITT_Username,TokenParam1:='ExternalSystem',TokenParam2:='Inwatec');
		CommID : USINT;
	END_STRUCT;
	Inwatec_data_typ : 	STRUCT 
		tx_handshake : USINT;
		option_flag_1 : USINT;
		option_flag_2 : USINT;
		system_status : USINT;
		i_am_alive : BOOL;
		batch_id : UDINT;
		source_id : DINT;
		batch_count : INT;
		weight : REAL;
		customer : STRING[25];
		customer_name : STRING[25];
		customer_numeric : DINT;
		category : STRING[20];
		category_name : STRING[20];
		category_numeric : DINT;
		lot : STRING[20];
		lot_numeric : DINT;
		sublot : STRING[20];
		sublot_numeric : DINT;
		option_1 : UDINT;
		option_2 : DINT;
	END_STRUCT;
END_TYPE
