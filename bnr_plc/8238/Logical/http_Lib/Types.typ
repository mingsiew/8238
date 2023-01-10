
TYPE
	dataPointer_typ : 	STRUCT 
		Adr : UDINT;
		Size : UDINT;
	END_STRUCT;
	httpConfig_typ : 	STRUCT 
		Host : STRING[20];
		Port : UINT;
	END_STRUCT;
	http_Cmd_typ : 	STRUCT 
		Method : UINT; (*Set the http cmd type.. POST,GET,PUT,DELETE*)
		Cmd_URL : dataPointer_typ; (*The string data appended to the URL - Use with GET and DELETE *)
		Body_Data : dataPointer_typ; (*Data to send in the body of the message - USE with POST and PUT*)
		ResponseData : dataPointer_typ; (*Data address of where to set the http response data*)
	END_STRUCT;
	http_comm_typ : 	STRUCT 
		Command : http_Cmd_typ; (**Set the values to pass into the http comm driver,*)
		Status : HTTP_Status_enum; (**Status of the http comm driver.*)
		LastError : STRING[60]; (**String to describe the last error*)
		lastResponse : httpResponseHeader_t;
		Overwrite : http_overwrite_t;
		ReplyCode : UINT; (**The response code *)
	END_STRUCT;
	http_overwrite_t : 	STRUCT 
		Host : BOOL; (**Set this to overwrite the host name and Port*)
		RequestHeader : BOOL; (**Set this to overwrite the Request Header*)
		Host_Config : httpConfig_typ; (**This data will overwrite the default host config*)
		RequestHeader_Data : httpRequestHeader_t; (**This data will overwrite the default request header.*)
	END_STRUCT;
	HTTP_Status_enum : 
		(
		HTTP_COMM_STATUS_DISABLED,
		HTTP_COMM_STATUS_ACTIVE_WAIT_BUF,
		HTTP_COMM_STATUS_IN_BUFFER,
		HTTP_COMM_STATUS_IN_PROCESS,
		HTTP_COMM_STATUS_COMPLETE,
		HTTP_COMM_STATUS_ERROR
		);
END_TYPE

(*Response Data from LiveData*)
