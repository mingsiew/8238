
TYPE
	state_enum : 
		(
		CONTACTRON := 0,
		EASYB := 1
		);
	BackUp : 	STRUCT 
		filePath : STRING[15];
		fileDevice : STRING[10];
		status : UINT;
		ident : UDINT;
		step : backUp_enum;
		functions : backUp_functions;
	END_STRUCT;
	backUp_enum : 
		(
		backUpStart := 0,
		backUpOpen := 1,
		backUpCreate := 2,
		backUpWrite := 3,
		backUpRead := 4,
		backUpClose := 5,
		backUpErrorRead := 6,
		backUpErrorWrite := 7,
		backUpExit := 100
		);
	backUp_functions : 	STRUCT 
		fWrite : FileWrite;
		fRead : FileRead;
		fOpen : FileOpen;
		fCreate : FileCreate;
		fClose : FileClose;
	END_STRUCT;
END_TYPE
