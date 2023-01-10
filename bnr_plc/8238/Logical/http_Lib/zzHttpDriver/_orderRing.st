
ACTION _orderRing: 
	//Only loop from position 1 as 0 will be active..
	FOR n := 1 TO HTTP_MAX_COMM DO
		r := ringBuffer[n];
		//If the comm is in not in the queue, or in process then remove it from the queue.
		IF (HTTP_Comm[r].Status <> HTTP_COMM_STATUS_IN_BUFFER)  THEN 
			ringBuffer[n] := 0;
		END_IF;	
	END_FOR;	
	//Shuffle List	
	FOR n:= 1 TO (HTTP_MAX_COMM - 1)DO	
		IF ringBuffer[n] = 0 THEN 	
			sizeRingArray := SIZEOF(ringBuffer);
			sizeRingData := SIZEOF(ringBuffer[0]);
			moveSize := (sizeRingArray - ((n+1)*sizeRingData));
			memcpy(ADR(ringBuffer[n]),ADR(ringBuffer[n + 1]),moveSize);
			ringBuffer[HTTP_MAX_COMM] := 0;
		END_IF;	
	END_FOR	
END_ACTION
