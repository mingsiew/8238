/********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: MbusTCP
 * Author: strickers
 * Created: October 29, 2009
 *******************************************************************/
#include <MBdeclarations.h>

/* ------------------------------------------------------------------------------------------------- */
/* Local functions */
/* ------------------------------------------------------------------------------------------------- */
UINT create_request_to_slave	(modbus_master_cfg_typ* config, USINT req_nr, USINT* send_buff, UINT size_buf, UINT transaction_id, modbus_log_typ LOGBOOK);
UINT analyze_answer_from_slave	(modbus_master_cfg_typ*	config,	USINT req_nr, USINT* receive_buff, UINT	transaction_id, modbus_log_typ LOGBOOK);
										
/* ------------------------------------------------------------------------------------------------- */
/* Master function block */
/* ------------------------------------------------------------------------------------------------- */
void MBmaster(MBmaster_typ* inst)
{
	USINT	x;
	USINT	receive_status;

	/* Increase cycle timers when connected */
	if(inst->internal.step > WAIT_CONNECTION)
	{
		/* Make sure cycle time has a value */
		if((inst->cycle_time == 0) && (inst->internal.step != ERROR))
		{
			NewLogEntry("ERR: Cyclic time is 0", inst->log);
			inst->status 		= ERROR_CYCLIC_ZERO;
			inst->internal.step = ERROR;
		}
		else
		{
			for(x=0;x<sizeof((*(inst->p_cfg)).action_param)/sizeof((*(inst->p_cfg)).action_param[0]);x++)
				inst->internal.send_timer[x] += inst->cycle_time;
		}
	}
	switch(inst->internal.step)
	{
		/* ------------------------------------------------------------------------------------------ */
		/* Assign buffers and port */
		case INIT:
			inst->internal.tcp_send.pData 		= (UDINT)inst->internal.send_buff;
			inst->internal.tcp_receive.pData	= (UDINT)inst->internal.receive_buff;
			inst->internal.tcp_receive.datamax	= sizeof(inst->internal.receive_buff);
			if(inst->port == 0) inst->port = MODBUS_TCP_PORT;
			inst->internal.step = DISABLE;
		/* ------------------------------------------------------------------------------------------ */
		/* Wait for function block enable */		
		case DISABLE:
			if(inst->enable)
			{
				inst->internal.step = GET_IP;
				NewLogEntry("Validating own ip...", inst->log);
			}
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Read own IP address */		
		case GET_IP:	
			if(inst->enable)
			{
				inst->internal.tcp_ip.enable 	= 1;
				inst->internal.tcp_ip.pDevice 	= (UDINT)inst->device;
				inst->internal.tcp_ip.pIPAddr 	= (UDINT)inst->my_ip;
				inst->internal.tcp_ip.Len 		= 18; 
				CfgGetIPAddr(&inst->internal.tcp_ip);
				inst->status = inst->internal.tcp_ip.status;
				/* -------------------------------------------------------------------------------------- */
				/* Success  */		
				if (inst->internal.tcp_ip.status == 0)
				{
					if(strcmp(inst->my_ip, "0.0.0.0") == 0) break;
					inst->internal.step = OPEN_PORT;
				}
				else if(inst->internal.tcp_ip.status == cfgERR_DEVICE_NOT_EXIST)
				{
					NewLogEntry("ERR: Invalid ethernet device", inst->log);
					inst->status 		= ERROR_DEVICE_ERR;
					inst->internal.step = ERROR;
				}
				else if(inst->internal.tcp_ip.status != BUSY) inst->internal.step = ERROR;
			}
			else inst->internal.step = CLOSE_PORT;
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Open ethernet port */
		case OPEN_PORT:
			if(inst->enable)
			{
				inst->internal.tcp_open.options = tcpOPT_REUSEADDR;
				inst->internal.tcp_open.enable 	= 1;
				TcpOpen(&inst->internal.tcp_open);
				/* -------------------------------------------------------------------------------------- */
				/* Success  */		
				if (inst->internal.tcp_open.status == 0)
				{
					NewLogEntry("Open port successful", inst->log);
					inst->internal.tcp_client.enable	= 1;
					inst->internal.tcp_client.ident		= inst->internal.tcp_open.ident;
					inst->internal.tcp_client.pServer	= (UDINT)inst->slave_ip_addr;
					inst->internal.tcp_client.portserv	= inst->port;
					inst->internal.tcp_send.ident		= inst->internal.tcp_open.ident;
					inst->internal.tcp_receive.ident	= inst->internal.tcp_open.ident;
					NewLogEntry("Trying to connect...", inst->log);
					inst->internal.step = WAIT_CONNECTION;
				}
				else if(inst->internal.tcp_open.status != BUSY) inst->internal.step = ERROR;
				inst->status = inst->internal.tcp_open.status;
			}
			else inst->status = 65534;
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Open ethernet port */
		case WAIT_CONNECTION:
			if(inst->enable)
			{
				inst->internal.tcp_client.enable = 1;
				TcpClient(&inst->internal.tcp_client);
				inst->status = inst->internal.tcp_client.status;
				/* ---------------------------------------------------------------------------------- */
				/* Success */		
				if(inst->internal.tcp_client.status == 0)
				{
					NewLogEntry("Connected", inst->log);
					inst->internal.step = CREATE_REQUEST;
				}
				else if(inst->internal.tcp_client.status == tcpERR_INVALID)
				{
					NewLogEntry("ERR: Cant find slave", inst->log);
					inst->status = ERROR_TIMEOUT_CONNECT;
					inst->internal.step = CLOSE_PORT;
				}
				else if(inst->internal.tcp_client.status != BUSY)
				{
					NewLogEntry("ERR: Could not establish connection", inst->log);
					inst->status = ERROR_TIMEOUT_CONNECT;
					inst->internal.step = ERROR;
				}
			}
			else inst->internal.step = CLOSE_PORT;
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Create new requests  */						
		case CREATE_REQUEST:
			if(inst->enable)
			{
				UINT tmp_req = inst->internal.last_req;
				/* ---------------------------------------------------------------------------------- */
				/* Find next request */
				do
				{
					/* ---------------------------------------------------------------------------------- */
					/* Switch to next action, roll over */
					inst->internal.last_req++;
					if(((*(inst->p_cfg)).action_param[inst->internal.last_req].p_pv == 0) || (inst->internal.last_req >= sizeof((*(inst->p_cfg)).action_param)/sizeof((*(inst->p_cfg)).action_param[0]))) inst->internal.last_req=0;
					/* ---------------------------------------------------------------------------------- */
					/* Execute action when set to single or timer is expired */		
					if (((*(inst->p_cfg)).action_enable[inst->internal.last_req].single) || 
						((inst->internal.send_timer[inst->internal.last_req] >= (*(inst->p_cfg)).action_param[inst->internal.last_req].timer) && ((*(inst->p_cfg)).action_enable[inst->internal.last_req].cyclic)))
					{
						if(((*(inst->p_cfg)).action_param[inst->internal.last_req].p_pv) != 0)
						{
							inst->internal.step = SEND_REQUEST;
							inst->internal.transaction_id++;
							inst->internal.tcp_send.datalen = create_request_to_slave((modbus_master_cfg_typ*)(inst->p_cfg), inst->internal.last_req, inst->internal.send_buff, sizeof(inst->internal.send_buff), inst->internal.transaction_id, inst->log);
							inst->internal.send_timer[inst->internal.last_req] = 0;
						}
						else /* Variable address is empty */
						{
						NewLogEntry("ERR: Empty variable ADR", inst->log);
						inst->status 		= ERROR_ADR_EMPTY;
						inst->internal.step = ERROR;
						}
						break;
					}
					if(inst->internal.last_req == tmp_req) break;
				}
				while(1);			
			}
			else inst->internal.step = CLOSE_PORT;
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Create new requests */									
		case SEND_REQUEST:
			if(inst->enable)
			{
				inst->internal.tcp_send.enable = 1;
				TcpSend(&inst->internal.tcp_send);
				/* ---------------------------------------------------------------------------------- */
				/* Success */		
				if(inst->internal.tcp_send.status == 0)
				{
					inst->internal.receive_timer = 0;
					inst->internal.step = WAIT_ANSWER;
				}
				else if(((inst->internal.tcp_send.status != BUSY) 				&&
					     (inst->internal.tcp_send.status != tcpERR_WOULDBLOCK)	&&
					     (inst->internal.tcp_send.status != tcpERR_SENTLEN))    ||
						 (inst->internal.tcp_send.status == tcpERR_NOT_CONNECTED))	inst->internal.step = CLOSE_PORT;
			}
			else inst->internal.step = CLOSE_PORT;
			inst->status = inst->internal.tcp_send.status;
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Wait for answer */
		case WAIT_ANSWER:
			if(inst->enable)
			{
				inst->internal.tcp_receive.enable = 1;
				TcpRecv(&inst->internal.tcp_receive);
				/* ---------------------------------------------------------------------------------- */
				/* Success */		
				if(inst->internal.tcp_receive.status == 0)
				{
					if(inst->internal.tcp_receive.recvlen != 0)
					{
						if((inst->internal.tcp_receive.recvlen > 8) && (inst->internal.tcp_receive.recvlen < sizeof(inst->internal.receive_buff)))
						{	
							receive_status = analyze_answer_from_slave((modbus_master_cfg_typ*)(inst->p_cfg), inst->internal.last_req, inst->internal.receive_buff, inst->internal.transaction_id, inst->log);				
							if(receive_status) inst->last_error = ERROR_BAD_SLAVE_DATA;							
						}
						else if(inst->internal.tcp_receive.recvlen >= sizeof(inst->internal.receive_buff))
						{						
							NewLogEntry("ERR: Data received too long", inst->log);
							receive_status = 1;
							inst->last_error = ERROR_SLAVE_DATA_TOO_LONG;
						}
						else
						{						
							NewLogEntry("ERR: Data received too short", inst->log);
							receive_status = 1;
							inst->last_error = ERROR_SLAVE_DATA_TOO_SHORT;
						}
						if(receive_status) 	inst->internal.wrong_message ++;
						(*(inst->p_cfg)).action_enable[inst->internal.last_req].single = 0;				
						inst->internal.step = CREATE_REQUEST;
					}
					else inst->internal.step = CLOSE_PORT;
				}
				else if((inst->internal.tcp_receive.status != BUSY) &&
					    (inst->internal.tcp_receive.status != tcpERR_NO_DATA)) inst->internal.step = CLOSE_PORT;
				/* ---------------------------------------------------------------------------------- */
				/* See if request timed out */
				inst->internal.receive_timer += inst->cycle_time;
				if (inst->internal.receive_timer >= RECEIVE_TIMEOUT)
				{
					NewLogEntry("ERR: Request timed out", inst->log);
					inst->status = ERROR_TIMEOUT_REQ;
					inst->last_error = ERROR_TIMEOUT_REQ;
					inst->internal.step = CREATE_REQUEST;
					break;
				}
			}
			else inst->internal.step = CLOSE_PORT;
			if(inst->internal.tcp_receive.status != tcpERR_NO_DATA)	inst->status = inst->internal.tcp_receive.status;
			else													inst->status = 0;
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Close connection */	
		case CLOSE_PORT:
			inst->internal.tcp_close.enable 	= 1;
			inst->internal.tcp_close.ident		= inst->internal.tcp_open.ident;
			inst->internal.tcp_close.how 		= 0;
			TcpClose(&inst->internal.tcp_close);
			/* -------------------------------------------------------------------------------------- */
			/* Success */		
			if(inst->internal.tcp_close.status == 0)
			{
				NewLogEntry("Port closed", inst->log);
				inst->internal.send_timer[0] = 0;
				inst->internal.step = WAIT;
			}
			else if(inst->internal.tcp_close.status == tcpERR_INVALID_IDENT)
			{
				inst->internal.step = ERROR;
			}
			inst->status = inst->internal.tcp_close.status;
		break;
		/* ------------------------------------------------------------------------------------------ */
		/* Wait before reopen port */
		case WAIT:
			inst->internal.tcp_open.enable = 0;
			TcpOpen(&inst->internal.tcp_open);
			inst->internal.tcp_client.enable = 0;
			TcpClient(&inst->internal.tcp_client);
				
			inst->internal.send_timer[0] += inst->cycle_time;
			if (inst->internal.send_timer[0] > 1000) inst->internal.step = OPEN_PORT;
		break;			
		/* ------------------------------------------------------------------------------------------ */
		/* Error state */
		case ERROR:
			if (inst->status < 50000) inst->status = ERROR_CRITICAL;
			if (inst->enable == 0) inst->internal.step = DISABLE;
		break;			
	}
}

/* ------------------------------------------------------------------------------------------------- */
/* Create new request to slave */
/* ------------------------------------------------------------------------------------------------- */
UINT create_request_to_slave(modbus_master_cfg_typ* config, USINT 	req_nr,	USINT* send_buff, UINT size_buf, UINT transaction_id, modbus_log_typ LOGBOOK)
{
	UINT	uint_var;
	INT		int_var;
	INT		value;
	UINT	data_len, i;

	/* Error message for undefined function code */
	memset(send_buff, 0, size_buf);
	/* Transaction id: 2 byte */
	uint_var = MySwapUINT(transaction_id);
	memcpy(&send_buff[0], &uint_var, sizeof(uint_var));
	/* Protocol id: 2 byte */
	uint_var = 0;
	memcpy(&send_buff[2], &uint_var, sizeof(uint_var));
	/* Length: 2 byte */
	/* Unit: 1 byte */
	send_buff[6] = (*config).action_param[req_nr].unit;
	switch((*config).action_param[req_nr].type)
	{	
		case READ_COILS:
			/* Function code: 1 byte */
			send_buff[7] = READ_COILS;
			/* Strating address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Coils number: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].quantity);
			memcpy(&send_buff[10], &uint_var, sizeof(uint_var));
			/* Data len */
			data_len = 6;
			break;
		case READ_DISCRETE_INPUTS:
			/* Function code: 1 byte */
			send_buff[7] = READ_DISCRETE_INPUTS;
			/* Starting address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Inputs number: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].quantity);
			memcpy(&send_buff[10], &uint_var, sizeof(uint_var));
			/* Data length */
			data_len = 6;
			break;
		case READ_HOLDING_REGISTERS:
			/* Function code: 1 byte */
			send_buff[7] = READ_HOLDING_REGISTERS;
			/* Starting address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Holding registers number: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].quantity);
			memcpy(&send_buff[10], &uint_var, sizeof(uint_var));
			/* Data length */
			data_len = 6;
			break;
		case READ_INPUT_REGISTERS:
			/* Function code: 1 byte */
			send_buff[7] = READ_INPUT_REGISTERS;
			/* Starting address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Input registers number: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].quantity);
			memcpy(&send_buff[10], &uint_var, sizeof(uint_var));
			/* Data length */
			data_len = 6;
			break;
		case WRITE_SINGLE_COIL:
			/* Function code: 1 byte */
			send_buff[7] = WRITE_SINGLE_COIL;
			/* Starting address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Value: 2 byte */
			if(*((BOOL*)((*config).action_param[req_nr].p_pv)))	value = ON;
			else												value = OFF;
			int_var = MySwapINT(value);
			memcpy(&send_buff[10], &int_var, sizeof(int_var));
			/* Data length */
			data_len = 6;
			break;
		case WRITE_SINGLE_REGISTER:
			/* Function code: 1 byte */
			send_buff[7] = WRITE_SINGLE_REGISTER;
			/* Starting address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Value: 2 byte */
			value = *((INT*)((*config).action_param[req_nr].p_pv));
			int_var = MySwapINT(value);
			memcpy(&send_buff[10], &int_var, sizeof(int_var));
			/* Data length */
			data_len = 6;
			break;
		case WRITE_MULTIPLE_COILS:
			/* Function code: 1 byte */
			send_buff[7] = WRITE_MULTIPLE_COILS;
			/* Starting address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Quantity: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].quantity);
			memcpy(&send_buff[10], &uint_var, sizeof(uint_var));
			/* Byte count: 1 byte */
			if( (*config).action_param[req_nr].quantity % 8)	send_buff[12] = ((*config).action_param[req_nr].quantity / 8) + 1;
			else												send_buff[12] = (*config).action_param[req_nr].quantity / 8;
			/* Coil value: x byte */
			for(i = 0; i < (*config).action_param[req_nr].quantity; i++)
			{
				if(	((BOOL*)((*config).action_param[req_nr].p_pv))[i])
					send_buff[13 + (i/8)] = send_buff[13 + (i/8)] | (USINT)(0x01 << (i%8));
				else
					send_buff[13 + (i/8)] = send_buff[13 + (i/8)] & (USINT)~(0x01 << (i%8));
			}
			/* Data length */
			data_len = 7 + send_buff[12];
			break;
			
		case WRITE_MULTIPLE_REGISTERS:
			/* Function code: 1 byte */
			send_buff[7] = WRITE_MULTIPLE_REGISTERS;
			/* Starting address: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].start_addr);
			memcpy(&send_buff[8], &uint_var, sizeof(uint_var));
			/* Quantity: 2 byte */
			uint_var = MySwapUINT((*config).action_param[req_nr].quantity);
			memcpy(&send_buff[10], &uint_var, sizeof(uint_var));
			/* Byte count: 1 byte */
			send_buff[12] = (*config).action_param[req_nr].quantity * 2;
			/* Coil value: x byte */
			for(i = 0; i < (*config).action_param[req_nr].quantity; i++)
			{
				value = ((INT*)((*config).action_param[req_nr].p_pv))[i];
				int_var = MySwapINT(value);
				memcpy(&send_buff[13 + (i*2)], &int_var, sizeof(int_var));
			}
			/* Data length */
			data_len = 7 + send_buff[12];
			break;

		default:
			/* Unsupported function code */
			NewLogEntry("ERR: Client function code", LOGBOOK);
			break;
	}
	/* Create log entry */
	MessageLog (TYP_REQUEST, (*config).action_param[req_nr].type, (*config).action_param[req_nr].start_addr, (*config).action_param[req_nr].quantity, LOGBOOK);

	/* Length: 2 byte */
	uint_var = MySwapUINT(data_len);
	memcpy(&send_buff[4], &uint_var, sizeof(uint_var));
	return 6 + data_len;
}

/* ------------------------------------------------------------------------------------------------- */
/* Analyse response from slave */
/* ------------------------------------------------------------------------------------------------- */
UINT analyze_answer_from_slave(modbus_master_cfg_typ* config,USINT req_nr, USINT* receive_buff, UINT transaction_id, modbus_log_typ LOGBOOK)
{
	INT		int_var;
	UINT	uint_var, receive_tr_id, protocol_id, length;
	UINT	unit, function_code, quantity, i;
	
	memcpy(&uint_var, &(receive_buff[0]), sizeof(uint_var));
	receive_tr_id	= MySwapUINT(uint_var);
	memcpy(&uint_var, &(receive_buff[2]), sizeof(uint_var));
	protocol_id		= MySwapUINT(uint_var);
	memcpy(&uint_var, &(receive_buff[4]), sizeof(uint_var));
	length 			= MySwapUINT(uint_var);
	unit 			= receive_buff[6];
	function_code	= receive_buff[7];

	if((receive_tr_id 	== transaction_id)	&&
	   (protocol_id		== 0)				&&
	   (length			> 0)				&&
	   (function_code	< 0x80))
	{
		switch(function_code)
		{	
			case READ_COILS:
				/* Quantity: 1 byte */
				quantity = (*config).action_param[req_nr].quantity;
				/* Coil value: x byte */
				for(i = 0; i < quantity; i++)
				{
					if (receive_buff[9 + (i/8)] & (USINT)(0x01 << (i%8))) 	((BOOL*)((*config).action_param[req_nr].p_pv))[i] = 1;
					else													((BOOL*)((*config).action_param[req_nr].p_pv))[i] = 0;
				}
				break;

			case READ_DISCRETE_INPUTS:
				/* Quantity: 1 byte */
				quantity = (*config).action_param[req_nr].quantity;
				/* Coil value: x byte */
				for(i = 0; i < quantity; i++)
				{
					if (receive_buff[9 + (i/8)] & (USINT)(0x01 << (i%8)))	((BOOL*)((*config).action_param[req_nr].p_pv))[i] = 1;
					else													((BOOL*)((*config).action_param[req_nr].p_pv))[i] = 0;
				}
				break;

			case READ_HOLDING_REGISTERS:
				/* Quantity: 1 byte */
				quantity = receive_buff[8] / 2;
				/* Coil value: x byte */
				for(i = 0; i < quantity; i++)
				{
					memcpy(&int_var, &receive_buff[9 + (i*2)], sizeof(int_var));
					((INT*)((*config).action_param[req_nr].p_pv))[i] = MySwapINT(int_var);
				}
				break;

			case READ_INPUT_REGISTERS:
				/* Quantity: 1 byte */
				quantity = receive_buff[8] / 2;
				/* Coil value: x byte */
				for(i = 0; i < quantity; i++)
				{
					memcpy(&int_var, &receive_buff[9 + (i*2)], sizeof(int_var));
					((INT*)((*config).action_param[req_nr].p_pv))[i] = MySwapINT(int_var);
				}
				break;

			default:
				/* Unsupported function code */
				if ((function_code > WRITE_SINGLE_REGISTER) && ((function_code != WRITE_MULTIPLE_COILS) && (function_code != WRITE_MULTIPLE_REGISTERS)))
					NewLogEntry("ERR: Server function code", LOGBOOK);
				break;
		}
		/* Create log entry */
		MessageLog (TYP_RESPONSE, function_code, 0, 0, LOGBOOK);
	}
	/* Generate error on function exception from slave */
	else if(function_code >= 0x80)
	{
		function_code -= 0x80;
		switch(receive_buff[8])
			{
				case 1: NewLogEntry("ERR: Server->Bad function", LOGBOOK); break; 	
				case 2: NewLogEntry("ERR: Server->Data address", LOGBOOK); break; 	
				case 3: NewLogEntry("ERR: Server->Data value", LOGBOOK); break; 	
				case 4: NewLogEntry("ERR: Server->Device failure", LOGBOOK); break; 	
				case 5: NewLogEntry("ERR: Server->Exception ack", LOGBOOK); break; 	
				case 6: NewLogEntry("ERR: Server->Slave busy", LOGBOOK); break; 	
				case 10: NewLogEntry("ERR: Server->Path unavailable", LOGBOOK); break; 	
				default: NewLogEntry("ERR: Server->unknown", LOGBOOK); break; 	
			}
		return 1;
	}
	else
	{
		NewLogEntry("ERR: Bad slave message", LOGBOOK);
		return 1;
	}
	return 0;
}
