
ACTION _backUpRead:
	IF (backUp.step = backUpExit) THEN
		backUp.step := backUpOpen;
	END_IF;
	CASE backUp.step OF
			backUpOpen:
				backUp.functions.fOpen.enable := TRUE;
				backUp.functions.fOpen.pDevice := ADR(backUp.fileDevice);
				backUp.functions.fOpen.pFile := ADR(backUp.filePath);
				backUp.functions.fOpen.mode := FILE_RW;
				backUp.functions.fOpen();
				backUp.status := backUp.functions.fOpen.status;
				IF (backUp.status = fiERR_FILE_NOT_FOUND) THEN
					backUp.step := backUpErrorRead; //Error goto error step
				ELSIF (backUp.status = ERR_OK) THEN
					backUp.step := backUpRead;	//File opened goto read write
					backUp.ident := backUp.functions.fOpen.ident;
				ELSIF (backUp.status = ERR_FUB_BUSY) THEN
					backUp.step := backUpOpen; //Function block still busy
				ELSE
					backUp.step := backUpErrorRead; //Error goto error step
				END_IF;
			
			backUpRead:
				backUp.functions.fRead.enable := TRUE;
				backUp.functions.fRead.ident := backUp.ident;
				backUp.functions.fRead.offset := 0;
				backUp.functions.fRead.pDest := ADR(fuseSettingStructure);
				backUp.functions.fRead.len := SIZEOF(fuseSettingStructure);
				backUp.functions.fRead();
				backUp.status := backUp.functions.fRead.status;
				IF (backUp.status = fiERR_FILE_NOT_FOUND) THEN
					backUp.step := backUpExit; //File not found goto exit loop
				ELSIF (backUp.status = ERR_OK) THEN
					backUp.step := backUpClose;	//goto close file
				ELSIF (backUp.status = ERR_FUB_BUSY) THEN
					backUp.step := backUpRead; //Function block still busy
				ELSE
					backUp.step := backUpErrorRead; //Error goto error step
				END_IF;
			
			backUpClose:
				backUp.functions.fClose.enable := TRUE;
				backUp.functions.fClose.ident := backUp.ident;
				backUp.functions.fClose();
				backUp.status := backUp.functions.fClose.status;
				IF (backUp.status = ERR_OK) THEN
					//Exit case and action
					IO_Link.Load := FALSE;
					backUp.step := backUpExit;
				ELSIF (backUp.status = ERR_FUB_BUSY) THEN
					backUp.step := backUpClose; //Function block still busy
				ELSE
					backUp.step := backUpErrorRead; //Error goto error step
				END_IF;
			
			backUpErrorRead:
				IO_Link.Load := FALSE;
				//Error state
		END_CASE;
END_ACTION
