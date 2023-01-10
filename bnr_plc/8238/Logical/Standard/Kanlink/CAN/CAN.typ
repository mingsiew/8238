
TYPE
	WET_CAN : 	STRUCT 
		ControlSignals : USINT;
		ControlSignals2 : USINT;
		Category : UINT;
		Customer : UINT;
		Weight : UINT;
	END_STRUCT;
	DRY_CAN : 	STRUCT 
		ControlSignals : USINT;
		ControlByte2 : USINT;
		Category : UDINT;
		Weight : UINT;
	END_STRUCT;
	DRY_CAN1 : 	STRUCT 
		CustomerCode : UDINT;
		BatchCode : UDINT;
	END_STRUCT;
	DRYCAN_comm_typ : 	STRUCT 
		ReadFrame : DRY_CAN;
		WriteFrame : DRY_CAN;
		WriteFrame1 : DRY_CAN1;
		EventRead : BOOL;
		EventWrite : BOOL;
		EventWrite1 : BOOL;
	END_STRUCT;
	Batchpart_typ : 	STRUCT 
		Wgt : UINT;
		Customer : UDINT;
	END_STRUCT;
	Comm_typ : 	STRUCT 
		BagReady : BOOL;
		Unloading : BOOL;
		DropLoad : BOOL;
		LoadDropped : BOOL;
		Category : UDINT;
		Customer : UDINT;
		BatchID : UDINT;
		Weight : UINT;
		Live : BOOL;
		LiveTime : UINT;
		ReadyToLoad : BOOL;
		Loading : BOOL;
		UnloadFinished : BOOL;
		HaltSys : BOOL;
		Batch_QtyRemaining : UINT;
		LoadRecieved : BOOL;
		Transfer : BOOL;
		Batchpart : ARRAY[0..7]OF Batchpart_typ;
		CategoryStr : STRING[11];
		CustomerStr : STRING[11];
	END_STRUCT;
END_TYPE
