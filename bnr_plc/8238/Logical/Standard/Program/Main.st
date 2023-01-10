
PROGRAM _INIT
	(* Insert code here *)
	Path := 'SL1.IF1.ST11.IF1.ST3.TRC';
	myAsIoTrcGet.pDevice := ADR(Path);//'SS1.IF1.ST131.TRC');
	myAsIoTrcGet.pBuffer := ADR(myBuffer);
	myAsIoTrcGet.bufferLen := SIZEOF(myBuffer); 
	//Sys file to try
//	User			XML - Users
//	Role			XML - Roles	
//	sysconf			NOT AVAILABLE ?
//	ashwd			NOT READABLE
//	arconfig		XML -- Contains all hardware configuration  !!! Use this to get module name. ***
//	asfw			NOT READABLE
//	ashwac			XML -- No data ??
//	iomap			IO File - Readable
//	asiol1			XML -- No data ??
//	asiol3			XML -- No data ??
//	Config			XML -- MAPP Components config
//	TC				XML -- Text Config.
//	viComp			VISION
//	Settings		VISION
//	viAppBCDE		VISION
	
	sysFileName := 'iomap';
END_PROGRAM

PROGRAM _CYCLIC

	
	//We can run an IO trace.. Is this useful when looking for breaks in the IO.. Maybe we can run somekind of automated test.

	IF myAsIoTrcGet.enable <> 0 THEN
		myAsIoTrcGet();
		myAsIoTrcGet.enable := 0;
	END_IF
	
	// Testing resolving the Module Name.
	
	CASE test OF
		10:
		
			mO_info(enable := 1, pName := ADR(sysFileName), grp := 0);
			IF mO_info.status = ERR_OK THEN
				test := 20;
			END_IF;	
			
		20:// File Write	
			fileRW.enable := 1;
			fileRW.mode := FILE_SAVE;
			fileRW.pData := mO_info.address;	
			fileRW.sizeData := 	mO_info.size;
			fileRW.pFileDevice := ADR('user');
			fileRW.pFileName := ADR(sysFileName);
			fileRW();
			IF fileRW.status = ERR_OK THEN
				test := 0;
			ELSIF fileRW.status <> ERR_FUB_BUSY THEN
				test := 100;
			END_IF;	
		
		
		50:// Read a module name
			getModuleName.enable := 1;
			getModuleName.pModuleAddress := ADR(moduleAddress);
			getModuleName();
			IF getModuleName.status = ERR_OK THEN
				test := 0;
			ELSIF (getModuleName.status <> ERR_FUB_BUSY) THEN
				test := 100;
			END_IF;	
		
	END_CASE;
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

