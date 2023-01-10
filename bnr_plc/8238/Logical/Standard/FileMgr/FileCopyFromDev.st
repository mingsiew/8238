
(* *Copy file from devlink link file device *)
FUNCTION_BLOCK FileCopyFromDev
	status := ERR_FUB_BUSY;
	IF enable THEN
		CASE fileState OF
			FiCopyDev_INIT:	
				fileState := FiCopyDev_DEVLINK;
				status := ERR_FUB_BUSY;	
				error := 0;
			
			FiCopyDev_DEVLINK:
				devLink.enable := 1;
				devLink.pDevice := pFileDevice;
				devLink.pParam := pDevLinkParameter;
				devLink();
				IF (devLink.status = ERR_OK) OR (devLink.status = fiERR_DEVICE_ALREADY_EXIST) THEN
					fileState := FiCopyDev_COPY;
					devHandle := devLink.handle; // Handle is not returned when fiERR_DEVICE_ALREADY_EXIST
				ELSIF devLink.status = fiERR_SYSTEM THEN
					status := FileIoGetSysError();
					fileState := FiCopyDev_ERROR;		
				END_IF;
			
			FiCopyDev_COPY:
				fileCopy.enable := 1;
				fileCopy.pSrc := pFileName;
				fileCopy.pSrcDev := pFileDevice;
				fileCopy.pDest := pDest;
				fileCopy.pDestDev := pDestDev;
				fileCopy.option := fiOVERWRITE;
				fileCopy();
				IF fileCopy.status = ERR_OK THEN
					fileState := FiCopyDev_UNLINK;
				ELSIF fileCopy.status <> ERR_FUB_BUSY THEN	
					error := fileCopy.status;
					fileState := FiCopyDev_UNLINK;
				END_IF;				
				
			FiCopyDev_UNLINK:
				devUnlink.enable := (devHandle > 0);				
				devUnlink.handle := devHandle;
				devUnlink(); 
				IF (devUnlink.status = ERR_OK) OR (devHandle = 0) THEN
					IF error = 0 THEN
						status := ERR_OK;
						fileState := FiCopyDev_INIT;
					ELSE	
						fileState := FiCopyDev_ERROR;
					END_IF;	
				ELSIF (devUnlink.status <> ERR_FUB_BUSY) THEN		
					error := devUnlink.status;	
					fileState := FiCopyDev_ERROR;	
				END_IF;	
					
			FiCopyDev_ERROR://Error!!
				status := error;
				error := 0;
				fileState:= FiCopyDev_INIT;	
			
		END_CASE;
	ELSE
		error := 0;
		fileState := FiCopyDev_INIT;
		status := ERR_FUB_ENABLE_FALSE;
	END_IF;	
END_FUNCTION_BLOCK
