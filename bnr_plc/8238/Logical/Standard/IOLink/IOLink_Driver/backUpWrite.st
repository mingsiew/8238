
ACTION _backUpWrite:
	IF (backUp.step = backUpExit) OR (backUp.step = backUpErrorRead) THEN
		backUp.step := backUpOpen;
	END_IF;
		CASE backUp.step OF
			backUpOpen:
				backUp.functions.fOpen.enable := TRUE;
				backUp.functions.fOpen.pDevice := ADR(backUp.fileDevice);
				backUp.functions.fOpen.pFile := ADR(backUp.filePath);
				backUp.functions.fOpen.mode := FILE_RW;
				backUp.functions.fOpen();
				backUp.ident := backUp.functions.fOpen.ident;
				backUp.status := backUp.functions.fOpen.status;
				IF (backUp.status = fiERR_FILE_NOT_FOUND) THEN
					backUp.step := backUpCreate; //File not found goto creat file step
				ELSIF (backUp.status = ERR_OK) THEN
					backUp.step := backUpWrite;	//File opened goto file write
				ELSIF (backUp.status = ERR_FUB_BUSY) THEN
					backUp.step := backUpOpen; //Function block still busy
				ELSE
					backUp.step := backUpErrorWrite; //Error goto error step
				END_IF;
			
			backUpCreate:
				backUp.functions.fCreate.enable := TRUE;
				backUp.functions.fCreate.pDevice := ADR(backUp.fileDevice);
				backUp.functions.fCreate.pFile := ADR(backUp.filePath);
				backUp.functions.fCreate();
				backUp.ident := backUp.functions.fCreate.ident;
				backUp.status := backUp.functions.fCreate.status;
				IF (backUp.status = ERR_OK) THEN
					backUp.step := backUpWrite;	//File created goto file write
				ELSIF (backUp.status = ERR_FUB_BUSY) THEN
					backUp.step := backUpCreate; //Function block still busy
				ELSE
					backUp.step := backUpErrorWrite; //Error goto error step
				END_IF;
		
			backUpWrite:
				backUp.functions.fWrite.enable := TRUE;
				backUp.functions.fWrite.ident := backUp.ident;
				backUp.functions.fWrite.offset := 0;
				backUp.functions.fWrite.pSrc := ADR(fuseSettingStructure);
				backUp.functions.fWrite.len := SIZEOF(fuseSettingStructure);
				backUp.functions.fWrite();
				backUp.status := backUp.functions.fWrite.status;
				IF (backUp.status = ERR_OK) THEN
					backUp.step := backUpClose; //Goto close file
				ELSIF (backUp.status = ERR_FUB_BUSY) THEN
					backUp.step := backUpWrite; //Function block still busy
				ELSE
					backUp.step := backUpErrorWrite; //Error goto error step
				END_IF;
			
			
			backUpClose:
				backUp.functions.fClose.enable := TRUE;
				backUp.functions.fClose.ident := backUp.ident;
				backUp.functions.fClose();
				backUp.status := backUp.functions.fClose.status;
				IF (backUp.status = ERR_OK) THEN
				//Exit case and action
					IO_Link.Save := FALSE;
					backUp.step := backUpExit;
				ELSIF (backUp.status = ERR_FUB_BUSY) THEN
					backUp.step := backUpClose; //Function block still busy
				ELSE
					backUp.step := backUpErrorWrite; //Error goto error step
				END_IF;
			
			backUpErrorWrite:
			//Error state
			IO_Link.Save := FALSE;
	END_CASE;
END_ACTION
