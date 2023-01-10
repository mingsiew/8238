
TYPE
	MappSafety_typ : 	STRUCT 
		State : USINT;
		Commands : MappSafetyCommands_typ;
		Visu : MappSafetyVisu_typ;
	END_STRUCT;
	MappSafetyCommands_typ : 	STRUCT 
		Transfer : BOOL;
		Complete : BOOL;
		Exchange : BOOL;
		Format : BOOL;
		Restart : BOOL;
		ActivateSetupMode : BOOL;
		ResetError : BOOL;
	END_STRUCT;
	MappSafetyVisu_typ : 	STRUCT 
		Transfer : btn_ctrl_typ;
		Complete : btn_ctrl_typ;
		Exchange : btn_ctrl_typ;
		Format : btn_ctrl_typ;
		Restart : btn_ctrl_typ;
		ActivateSetupMode : btn_ctrl_typ;
		ResetError : btn_ctrl_typ;
	END_STRUCT;
	btn_ctrl_typ : 	STRUCT 
		Enable : BOOL;
		Visible : BOOL;
	END_STRUCT;
END_TYPE
