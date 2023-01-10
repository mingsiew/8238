
ACTION _addToRing:
	FOR r := 1 TO HTTP_MAX_COMM DO	
		IF (ringBuffer[r] = 0) THEN	
			ringBuffer[r] := n;
			HTTP_Comm[n].Status := HTTP_COMM_STATUS_IN_BUFFER;
			EXIT;
		END_IF;
	END_FOR;	
END_ACTION
