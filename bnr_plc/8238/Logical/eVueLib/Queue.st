
(* *Buffer queue -- Queues multiple input into waiting longest order *)
FUNCTION_BLOCK Queue
	waitingLongest := 0;
	waitTime[0] := 0;
	
	//Set some default values.
	IF (maxInputs = 0) THEN
		maxInputs := 49;
	END_IF;
	
	
	
	FOR n := 1 TO maxInputs DO
		IF input[n] AND putToBackOfQueue[n] THEN
			putToBackOfQueue[n] := FALSE;
			waitTime[n] := 1;	
		ELSIF input[n] AND (waitTime[n] < 16#FFFFFFFF) THEN
			waitTime[n] := waitTime[n] + 1;
		ELSIF NOT input[n] THEN
			waitTime[n] := 0;			
		END_IF;				
	END_FOR;
	
	IF (priority > 0) AND (waitTime[priority] > 1) THEN
		waitingLongest := priority;
	ELSE	
		FOR n := 1 TO maxInputs DO			
			IF (waitTime[n] > waitTime[0]) THEN
				waitTime[0] := waitTime[n];
				waitingLongest := n;
			END_IF;
		END_FOR;
	END_IF;
	
	
	
END_FUNCTION_BLOCK
