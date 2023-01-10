
TYPE
	OPCuaClient_typ : 	STRUCT 
		State : UINT;
		Config : OPCuAClient_Config_typ;
		Functions : OPCuaClient_Functions_typ;
		Error : OPCuaClient_Error_typ;
		WriteData : OPCuAClient_WriteData_typ;
		ReadData : OPCuAClient_ReadData_typ;
	END_STRUCT;
	OPCuAClient_Config_typ : 	STRUCT 
		ServerURL : STRING[255];
		SessionInfo : UASessionConnectInfo;
		SessionUser : UAUserIdentityToken;
		Data : OPCuAClient_Confg_Data_typ;
	END_STRUCT;
	OPCuAClient_WriteData_typ : 	STRUCT 
		NodeID : ARRAY[0..MAX_WRITE_NODES]OF UANodeID;
		NodeInfo : ARRAY[0..MAX_WRITE_NODES]OF UANodeAdditionalInfo;
		Variable : ARRAY[0..MAX_WRITE_NODES]OF STRING[MAX_LENGTH_VARIABLE];
		ErrorID : ARRAY[0..MAX_WRITE_NODES]OF DWORD;
		TimeStamps : ARRAY[0..MAX_WRITE_NODES]OF DATE_AND_TIME;
	END_STRUCT;
	OPCuAClient_ReadData_typ : 	STRUCT 
		NodeID : ARRAY[0..MAX_READ_NODES]OF UANodeID;
		NodeInfo : ARRAY[0..MAX_READ_NODES]OF UANodeAdditionalInfo;
		Variable : ARRAY[0..MAX_READ_NODES]OF STRING[MAX_LENGTH_VARIABLE];
		ErrorID : ARRAY[0..MAX_READ_NODES]OF DWORD;
		TimeStamps : ARRAY[0..MAX_READ_NODES]OF DATE_AND_TIME;
	END_STRUCT;
	OPCuaClient_Functions_typ : 	STRUCT 
		Connect : UA_Connect;
		GetNameSpace : UA_GetNamespaceIndex;
		WriteBulk : UaClt_WriteBulk;
		ReadBulk : UaClt_ReadBulk;
		Disconnect : UA_Disconnect;
		RetryTimer : TON;
		ErrorStatePLS : R_TRIG;
	END_STRUCT;
	OPCuaClient_Error_typ : 	STRUCT 
		ErrorID : DWORD; (**Raw error info*)
		ErrorCode : UINT; (**Decoded Error message*)
		Message : STRING[254];
		ErrorState : UINT; (*State which caused the error*)
		ErrorNode : UINT; (*Index of the read or write node that caused the error*)
	END_STRUCT;
	OPCuAClient_Confg_Data_typ : 	STRUCT 
		Read : ARRAY[0..MAX_READ_NODES]OF OPCuAClient_Config_ReadData_typ;
		Write : ARRAY[0..MAX_WRITE_NODES]OF OPCuAClient_Confg_WriteData_typ;
		WriteCount : UINT;
		ReadCount : UINT;
	END_STRUCT;
	OPCuAClient_Confg_WriteData_typ : 	STRUCT 
		NodeID : UANodeID;
		NodeInfo : UANodeAdditionalInfo;
		Variable : STRING[MAX_LENGTH_VARIABLE];
		ErrorID : DWORD;
		TimeStamps : DATE_AND_TIME;
	END_STRUCT;
	OPCuAClient_Config_ReadData_typ : 	STRUCT 
		NodeID : UANodeID;
		NodeInfo : UANodeAdditionalInfo;
		Variable : STRING[MAX_LENGTH_VARIABLE];
		ErrorID : DWORD;
		TimeStamps : DATE_AND_TIME;
	END_STRUCT;
END_TYPE
