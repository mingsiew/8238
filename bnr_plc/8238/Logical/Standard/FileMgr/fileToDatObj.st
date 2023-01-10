(* *read from a file into a data object. *)	
FUNCTION_BLOCK fileToDatObj
	
	IF enable THEN
		CASE fileState OF
			Fi_To_Do_INIT:
				pDatObjMem := 0;	
				fileState := Fi_To_Do_FILE_OPEN;
				status := ERR_FUB_BUSY;	
				error := 0;
			
			Fi_To_Do_FILE_OPEN:
				fileOpen.enable := 1;	
				fileOpen.pDevice := pFileDevice;
				fileOpen.pFile := pFileName; 
				fileOpen.mode := fiREAD_WRITE;
				fileOpen();
				IF fileOpen.status = ERR_OK THEN	
					fi_ident := fileOpen.ident;
					fiSize := fileOpen.filelen;
					fileState := Fi_To_Do_DObj_GET_INFO;
				ELSIF fileOpen.status = fiERR_FILE_NOT_FOUND THEN			
					fileState := Fi_To_Do_ERROR;	
					status := fileOpen.status;
				ELSIF fileOpen.status <> ERR_FUB_BUSY THEN
					fileState := Fi_To_Do_ERROR;	
					status := fileOpen.status;
				END_IF;
			
			Fi_To_Do_DObj_GET_INFO:
				do_GetInfo.enable := 1;
				do_GetInfo.pName := pDoName;
				do_GetInfo();
				IF do_GetInfo.status = ERR_OK THEN
					do_Ident := do_GetInfo.ident;
					fileState := Fi_To_Do_DObj_DELETE;
				ELSIF do_GetInfo.status = doERR_MODULNOTFOUND THEN	
					fileState := Fi_To_Do_DObj_CREATE;		
				ELSIF do_GetInfo.status <> ERR_FUB_BUSY THEN	
					fileState := Fi_To_Do_FILE_CLOSE;
					error := do_GetInfo.status;
				END_IF;	
			
			
			Fi_To_Do_DObj_DELETE:
				do_Delete.enable := 1;
				do_Delete.ident := do_Ident;
				do_Delete();
				IF do_Delete.status = ERR_OK THEN
					fileState := Fi_To_Do_DObj_CREATE;	
				ELSIF do_Delete.status <> ERR_FUB_BUSY THEN	
					fileState := Fi_To_Do_FILE_CLOSE;
					error := do_Delete.status;
				END_IF;	
			
			
			Fi_To_Do_DObj_CREATE:
				do_Create.enable 	:= 1;
				do_Create.pName 	:= pDoName;
				do_Create.Option 	:= doNO_CS; // No checksum if do not call the DatObjWrite FUB>
				do_Create.pCpyData 	:= 0;
				do_Create.MemType	:= MemType;// doUSRROM; 
				do_Create.len		:= fiSize;
				do_Create();
				IF (do_Create.status = ERR_OK) OR (do_Create.status = doERR_CHECKSUM_WARNING) THEN
					do_Ident := do_Create.ident;
					pDatObjMem	:= do_Create.pDatObjMem;
					fileState := Fi_To_Do_FILE_READ;
				ELSIF do_Create.status <> ERR_FUB_BUSY THEN	
					error := do_Create.status;
					fileState := Fi_To_Do_FILE_CLOSE;
				END_IF;		
			
			Fi_To_Do_FILE_READ:
				fileRead.enable := 1;
				fileRead.ident := fi_ident;
				fileRead.pDest := pDatObjMem;
				fileRead.len := fiSize;
				fileRead.offset := 0;
				fileRead();
				IF fileRead.status = ERR_OK THEN
					fileState := Fi_To_Do_FILE_CLOSE;
				ELSIF fileRead.status <> ERR_FUB_BUSY THEN
					error := fileRead.status;
					fileState := Fi_To_Do_FILE_CLOSE;
				END_IF;
			
			Fi_To_Do_DObj_WRITE:	
				do_Write.enable := 1;
				do_Write.ident := do_Ident;
				do_Write.Offset := 0;
				do_Write.len := fiSize;
				do_Write.pSource := pDatObjMem;
				do_Write();
				IF do_Write.status = ERR_OK	 THEN
					fileState := Fi_To_Do_FILE_CLOSE;
				ELSIF do_Write.status <> ERR_FUB_BUSY THEN
					error := fileRead.status;
					fileState := Fi_To_Do_FILE_CLOSE;
				END_IF;	
					
			Fi_To_Do_FILE_CLOSE:
				fileClose.enable := 1;
				fileClose.ident := fi_ident;
				fileClose();
				IF fileClose.status = ERR_OK THEN
					IF (error > 0) THEN
						status := error;
						fileState := Fi_To_Do_ERROR;
					ELSE	
						status := ERR_OK;
						fileState := Fi_To_Do_INIT; //Reset FUB
					END_IF;
				ELSIF fileClose.status <> ERR_FUB_BUSY THEN
					fileState := Fi_To_Do_ERROR;	
					status := fileClose.status;
				END_IF;		
			
			Fi_To_Do_ERROR://Error!!
				fileState:= Fi_To_Do_INIT;	
			
		END_CASE;
	ELSE
		error := 0;
		fileState := Fi_To_Do_INIT;
		status := ERR_FUB_ENABLE_FALSE;
	END_IF;		
		
END_FUNCTION_BLOCK
