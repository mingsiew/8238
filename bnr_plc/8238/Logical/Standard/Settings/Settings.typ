
TYPE
	settings_typ : 	STRUCT 
		Camera : ARRAY[0..MAX_CAMERAS]OF Camera_Settings_typ;
		Drive : ARRAY[0..MAX_DRIVES]OF ABB_Settings_typ;
		Rail : ARRAY[0..MAX_RAILS]OF Rail_Permenant_typ;
		Fuse : ARRAY[0..MAX_FUSE_BANKS]OF FuseSetting_typ;
		Contactron : ARRAY[0..MAX_CONTACTRON]OF contactron_setting_typ;
	END_STRUCT;
	Rail_Permenant_typ : 	STRUCT 
		State : INT;
		Count : INT;
	END_STRUCT;
END_TYPE
