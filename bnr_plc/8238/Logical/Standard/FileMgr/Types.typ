
TYPE
	fileToDatObj_state : 
		(
		Fi_To_Do_INIT,
		Fi_To_Do_FILE_OPEN,
		Fi_To_Do_FILE_READ,
		Fi_To_Do_FILE_CLOSE,
		Fi_To_Do_DObj_GET_INFO,
		Fi_To_Do_DObj_DELETE,
		Fi_To_Do_DObj_CREATE,
		Fi_To_Do_ERROR,
		Fi_To_Do_DObj_WRITE
		);
	fileToMem_state : 
		(
		Fi_To_Mem_INIT,
		Fi_To_Mem_FILE_OPEN,
		Fi_To_Mem_FILE_READ,
		Fi_To_Mem_FILE_CLOSE,
		Fi_To_Mem_ERROR
		);
	fileCopyFromDev_state : 
		(
		FiCopyDev_INIT,
		FiCopyDev_DEVLINK,
		FiCopyDev_COPY,
		FiCopyDev_UNLINK,
		FiCopyDev_ERROR
		);

END_TYPE
