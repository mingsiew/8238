(*USINT s sent in TCP as 2 bytes if it is not followed by another USINT ignore the upper*)

TYPE
  LiveData_RequestPool_typ : 	STRUCT 
    AddToPool : UINT; (**Request to Add a Packet type to the request Pool*)
    RemoveFromPool : UINT; (**Request to Remove a Packet type from the pool*)
    PoolList : ARRAY[1..LIVE_DATA_MAX_POOL_SIZE]OF UINT; (**Pool List - (Data packets are polled through)*)
    PoolListSize : USINT; (**Size of the current Pool List*)
    Pointer : USINT; (**Pointer to active Packet*)
  END_STRUCT;
  LiveData_Tview_typ : 	STRUCT  (*Type 2 - Trackview data*)
    Header : LiveDataHeader_typ;
    HeaderCustom : ARRAY[0..99]OF USINT; (*Extra header information so Live DATA API can decode*)
    data : ARRAY[0..4]OF BOOL; (**To be built custom*)
  END_STRUCT;
END_TYPE

(*Data Frame ABB i s type 4 -- Defined in ABB Package*)
(*HEADER TYPE*)

TYPE
  LiveDataHeader_typ : 	STRUCT  (**Must be first part of all Data Frames*)
    Type : UINT; (*Byte 1*)
    HeaderSize : UINT; (*Byte 2 & 3*)
    Checksum : UDINT; (*Bytes 4 -7*)
  END_STRUCT;
  LiveDataHeaderCustom_typ : 	STRUCT  (**Standard Header with customer area*)
    Type : UINT; (*Byte 1*)
    HeaderSize : UINT; (*Byte 2 & 3*)
    Checksum : UDINT; (*Bytes 4 -7*)
    Custom : UINT; (*Bytes 8-9*)
  END_STRUCT;
END_TYPE

(*Insert your comment here.*)

TYPE
  LiveDataConnection_typ : 	STRUCT 
    State : LiveDataConnectionState_enum; (**State of the connection*)
    RequestPool : LiveData_RequestPool_typ; (**Structure to manage to list of requested data types*)
    Config : LiveDataConnectionConfig_typ;
    Functions : LiveDataConnectionFunctions_typ;
    Error : UINT;
  END_STRUCT;
  LiveDataConnectionState_enum : 
    (
    LIVE_DATA_INIT := 0,
    LIVE_DATA_WAIT := 10,
    LIVE_DATA_OPEN_CONNECTION := 20,
    LIVE_DATA_SETUP_CONNECTION_TOS := 30,
    LIVE_DATA_SETUP_CONNECTION_TTL := 31,
    LIVE_DATA_CONNECT := 40,
    LIVE_DATA_BUILD_DATA := 50,
    LIVE_DATA_SEND_DATA := 60,
    LIVE_DATA_CHECK_REQUESTPOOL := 70,
    LIVE_DATA_DISCONNECT := 80,
    LIVE_DATA_CLOSE_CONNECTION := 90,
    LIVE_DATA_ERROR := 200,
    LIVE_DATA_GET_IDENT_MAX := 210, (**Debugging functions*)
    LIVE_DATA_GET_IDENT_LIST := 220 (**Debugging functions*)
    );
  LiveDataConnectionFunctions_typ : 	STRUCT 
    Open : UdpOpen;
    Ioctl : UdpIoctl;
    Connect : UdpConnect;
    Send : UdpSend;
    Disconnect : UdpDisconnect;
    Close : UdpClose;
  END_STRUCT;
  LiveDataConnectionConfig_typ : 	STRUCT 
    ServerIP : STRING[16]; (**IP Address of Server*)
    ServerPort : UINT; (**Server connection Port*)
    Type : LiveDataConnectionConfig_enum;
    TTL : UDINT := 30; (*Time To Live MAx 255*)
    TOS : UDINT := 4;
  END_STRUCT;
  LiveDataConnectionConfig_enum : 
    (
    LIVE_DATA_CONFIG_DYNAMIC_SERVER := 0, (*Idle connection listen on http server to start a connection*)
    LIVE_DATA_CONFIG_STATIC := 1, (*The IP and request are fixed and will be manually configured*)
    LIVE_DATA_CONFIG_DYNAMIC_CLIENT := 2 (*Use a Get request to load the Server Data and any required connections*)
    );
END_TYPE      
