
ACTION _ringBuffer: 

	//Listen to new comm events..
	FOR n := 0 TO HTTP_MAX_COMM DO	
		//httpComm ACCESS ADR(HTTP_Comm[n]);
		//There is an active comm that is not in the buffer...
		IF (HTTP_Comm[n].Status = HTTP_COMM_STATUS_ACTIVE_WAIT_BUF) THEN
			_addToRing;	//Add to the next avaible space in the ring buffer.
		END_IF;
	END_FOR;
		
	//Update the ring to ensure we clear any comms that are in error or complete.
	//If a comm is in error, it should be upto the requesting task to clear the error and retry to comm.. 
	_orderRing;
	
	
	
	
		
	
END_ACTION
