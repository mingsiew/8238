
(* Copy the lower 2 bytes from a byte register *)
FUNCTION Get_Lower2Bytes
	
	memcpy(ADR(Get_Lower2Bytes),ADR(input),2);
	
END_FUNCTION
