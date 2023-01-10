
TYPE
	csp_data_typ : 	STRUCT 
		Customer : UDINT;
		Name : STRING[10];
		PermissionToLoad : BOOL;
	END_STRUCT;
	csp_typ : 	STRUCT 
		Customer : UDINT;
		Data : ARRAY[0..1]OF csp_data_typ;
	END_STRUCT;
END_TYPE
