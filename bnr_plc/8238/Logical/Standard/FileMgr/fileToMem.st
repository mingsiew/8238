
(* *Opens File Into memory area*)
FUNCTION_BLOCK fileToMem
	IF enable THEN
		CASE fileState OF
			Fi_To_Mem_INIT:	
				fileState := Fi_To_Mem_FILE_OPEN;
				status := ERR_FUB_BUSY;	
				error := 0;
			
			Fi_To_Mem_FILE_OPEN:
				fileOpen.enable := 1;	
				fileOpen.pDevice := pFileDevice;
				fileOpen.pFile := pFileName; 
				fileOpen.mode := fiREAD_ONLY;
				fileOpen();
				IF fileOpen.status = ERR_OK THEN	
					fi_ident := fileOpen.ident;
					fiSize := fileOpen.filelen;
					IF fiSize <= sizeTempMem THEN
						fileState := Fi_To_Mem_FILE_READ;
					ELSE
						error := fiERR_NOT_ENOUGH_FREEMEM;
						fileState := Fi_To_Mem_FILE_CLOSE;
					END_IF;	
				ELSIF fileOpen.status = fiERR_FILE_NOT_FOUND THEN			
					fileState := Fi_To_Mem_ERROR;	
					status := fileOpen.status;
				ELSIF fileOpen.status <> ERR_FUB_BUSY THEN
					fileState := Fi_To_Mem_ERROR;	
					status := fileOpen.status;
				END_IF;
			
			Fi_To_Mem_FILE_READ:
				fileRead.enable := 1;
				fileRead.ident := fi_ident;
				fileRead.pDest := pTempMem;
				fileRead.len := fiSize;
				fileRead.offset := 0;
				fileRead();
				IF fileRead.status = ERR_OK THEN
					fileState := Fi_To_Mem_FILE_CLOSE;
				ELSIF fileRead.status <> ERR_FUB_BUSY THEN
					error := fileRead.status;
					fileState := Fi_To_Mem_FILE_CLOSE;
				END_IF;
					
			Fi_To_Mem_FILE_CLOSE:
				fileClose.enable := 1;
				fileClose.ident := fi_ident;
				fileClose();
				IF fileClose.status = ERR_OK THEN
					IF (error > 0) THEN
						status := error;
						fileState := Fi_To_Mem_ERROR;
					ELSE	
						status := ERR_OK;
						fileState := Fi_To_Mem_INIT; //Reset FUB
					END_IF;
				ELSIF fileClose.status <> ERR_FUB_BUSY THEN
					fileState := Fi_To_Mem_ERROR;	
					status := fileClose.status;
				END_IF;		
			
			Fi_To_Mem_ERROR://Error!!
				fileState:= Fi_To_Mem_INIT;	
			
		END_CASE;
	ELSE
		error := 0;
		fileState := Fi_To_Mem_INIT;
		status := ERR_FUB_ENABLE_FALSE;
	END_IF;			

END_FUNCTION_BLOCK
