
(* *Read or write to file device *)
FUNCTION_BLOCK fileReadWrite
	
	IF enable THEN
		CASE fileState OF
			0:
				IF mode	= FILE_SAVE THEN
					fileState := FILE_STATE_OPEN;
					status := ERR_FUB_BUSY;
				ELSIF mode = FILE_READ THEN
					fileState := FILE_STATE_OPEN;
					status := ERR_FUB_BUSY;
				ELSE
					fileState := FILE_STATE_ERROR;
					status := 99;//Incorrect config
				END_IF;	
					
			FILE_STATE_OPEN:
				fileOpen.enable := 1;	
				fileOpen.pDevice := pFileDevice; //MEMCARD
				fileOpen.pFile := pFileName; 
				fileOpen.mode := fiREAD_WRITE;
				fileOpen();
				IF fileOpen.status = ERR_OK THEN	
					
					ident := fileOpen.ident;
					IF mode = FILE_SAVE THEN	
						fileState := FILE_STATE_WRITE;
						IF appendToFile THEN Offset := fileOpen.filelen; END_IF;
					ELSIF mode = FILE_READ THEN
						fileState := FILE_STATE_READ;	
					END_IF;	
				ELSIF fileOpen.status = fiERR_FILE_NOT_FOUND THEN			
					IF mode = FILE_SAVE THEN
						fileState := FILE_STATE_CREATE;		
					ELSE
						fileState := FILE_STATE_ERROR;	
						status := fileOpen.status;
					END_IF;	
				ELSIF fileOpen.status <> ERR_FUB_BUSY THEN
					fileState := FILE_STATE_ERROR;	
					status := fileOpen.status;
				END_IF;
	
			FILE_STATE_CREATE:
				fileCreate.enable := 1;
				fileCreate.pDevice := pFileDevice;
				fileCreate.pFile := pFileName;
				fileCreate();
				IF fileCreate.status = ERR_OK THEN
					fileState := FILE_STATE_WRITE;
					ident := fileCreate.ident;
				ELSIF fileCreate.status <> ERR_FUB_BUSY THEN
					fileState := FILE_STATE_ERROR;	
					status := fileCreate.status;
				END_IF;	
			
				
			FILE_STATE_WRITE:
				fileWrite.enable := 1;
				fileWrite.ident := ident;
				fileWrite.pSrc := pData;
				fileWrite.len := sizeData;
				fileWrite.offset := Offset;
				fileWrite();
				IF fileWrite.status = ERR_OK THEN
					fileState := FILE_STATE_CLOSE;
				ELSIF fileWrite.status <> ERR_FUB_BUSY THEN
					error := fileWrite.status;
					fileState := FILE_STATE_CLOSE;
				END_IF;	
					
			FILE_STATE_READ:
				fileRead.enable := 1;
				fileRead.ident := ident;
				fileRead.pDest := pData;
				fileRead.len := sizeData;
				fileRead.offset := Offset;
				fileRead();
				IF fileRead.status = ERR_OK THEN
					fileState := FILE_STATE_CLOSE;
				ELSIF fileRead.status <> ERR_FUB_BUSY THEN
					error := fileRead.status;
					fileState := FILE_STATE_CLOSE;
				END_IF;
			
			
			FILE_STATE_CLOSE:
				fileClose.enable := 1;
				fileClose.ident := ident;
				fileClose();
				IF fileClose.status = ERR_OK THEN
					IF (error > 0) THEN
						status := error;
						fileState := FILE_STATE_ERROR;
					ELSE	
						status := ERR_OK;
						fileState := 0; //Reset FUB
					END_IF;
				ELSIF fileClose.status <> ERR_FUB_BUSY THEN
					fileState := FILE_STATE_ERROR;	
					status := fileClose.status;
				END_IF;		
			
			FILE_STATE_ERROR://Error!!
				fileState:= 0;	
			
		END_CASE;
	ELSE
		error := 0;
		fileState := 0;
		status := ERR_FUB_ENABLE_FALSE;
	END_IF;	

END_FUNCTION_BLOCK
