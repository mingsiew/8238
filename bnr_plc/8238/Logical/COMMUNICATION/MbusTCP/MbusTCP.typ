
TYPE
	modbus_slave_cfg_typ : 	STRUCT 
		p_discrete_inputs : ARRAY[0..99]OF UDINT;
		p_coils : ARRAY[0..99]OF UDINT;
		p_input_registers : ARRAY[0..99]OF UDINT;
		p_holding_registers : ARRAY[0..20000]OF UDINT;
	END_STRUCT;
	master_info_typ : 	STRUCT 
		ident : UDINT;
		port : UINT;
		ip_addr : ARRAY[0..17]OF USINT; (*Client IP address*)
		timeout_timer : TON; (*Timer to determine when connection times out*)
		disconnect : BOOL; (*Flag to disconnect this client if it times out.*)
	END_STRUCT;
	receive_buff_typ : 	STRUCT  (*Receive data buffer*)
		byte : ARRAY[0..32000]OF USINT; (*Received data*)
	END_STRUCT;
	modbus_master_action_enable_typ : 	STRUCT 
		cyclic : BOOL;
		single : BOOL;
	END_STRUCT;
	modbus_master_action_param_typ : 	STRUCT 
		unit : USINT;
		type : USINT;
		start_addr : UINT;
		quantity : UINT;
		p_pv : UDINT;
		timer : UDINT;
	END_STRUCT;
	modbus_master_cfg_typ : 	STRUCT 
		action_enable : ARRAY[0..19]OF modbus_master_action_enable_typ;
		action_param : ARRAY[0..19]OF modbus_master_action_param_typ;
	END_STRUCT;
	modbus_master_internal_typ : 	STRUCT  (*Internal master variables*)
		step : UINT; (*Internal state in a state machine*)
		tcp_open : TcpOpen; (*TcpOpen FUB from AsTCP*)
		tcp_ioctl : TcpIoctl; (*TcpIoctl FUB from AsTCP*)
		tcp_client : TcpClient; (*TcpClient FUB from AsTCP*)
		tcp_send : TcpSend; (*TcpSend FUB from AsTCP*)
		tcp_receive : TcpRecv; (*TcpRecv FUB from AsTCP*)
		tcp_close : TcpClose; (*TcpClose FUB from AsTCP*)
		tcp_ip : CfgGetIPAddr;
		linger_opt : tcpLINGER_typ; (*TcpIoctl linger options*)
		last_req : USINT; (*Last request*)
		receive_timer : UDINT; (*Receive timer*)
		send_timer : ARRAY[0..19]OF UDINT; (*Send timer*)
		send_buff : ARRAY[0..500]OF USINT; (*Send buffer*)
		receive_buff : ARRAY[0..500]OF USINT; (*Receive buffer*)
		transaction_id : UINT; (*Transaction ID*)
		wrong_message : UDINT; (*Wrong message counter*)
	END_STRUCT;
	modbus_log_typ : 	STRUCT  (*Log of data for the ModbusTCP FUBs*)
		data_lines : UINT; (*Number of character lines in the log*)
		pData : UDINT; (*Pointer to the log buffer*)
	END_STRUCT;
	modbus_slave_internal_typ : 	STRUCT  (*Internal slave variables*)
		step : UINT; (*Internal state in a state machine*)
		substep : UINT; (*Internal substate in a state machine*)
		i : USINT; (*Loop counter*)
		master_nr : USINT; (*Client ID*)
		master_last : USINT;
		master_info : ARRAY[0..10]OF master_info_typ; (*Client info*)
		master_addr : ARRAY[0..17]OF USINT; (*Client IP address*)
		tcp_open : TcpOpen; (*TcpOpen FUB from AsTCP*)
		tcp_ioctl : TcpIoctl; (*TcpIoctl FUB from AsTCP*)
		tcp_server : TcpServer; (*TcpServer FUB from AsTCP*)
		tcp_send : TcpSend; (*TcpSend FUB from AsTCP*)
		tcp_receive : ARRAY[0..10]OF TcpRecv; (*TcpRecv FUB from AsTCP*)
		tcp_close : TcpClose; (*TcpClose FUB from AsTCP*)
		tcp_ip : CfgGetIPAddr;
		linger_opt : tcpLINGER_typ; (*TcpIoctl linger options*)
		send_buff : ARRAY[0..32000]OF USINT; (*Send buffer*)
		send_byte : UINT;
		receive_buff : ARRAY[0..10]OF receive_buff_typ; (*Receive buffers for clients*)
		open_connections : ARRAY[0..254]OF UDINT; (*Open Connections*)
		connection_pointer : UINT;
	END_STRUCT;
END_TYPE
