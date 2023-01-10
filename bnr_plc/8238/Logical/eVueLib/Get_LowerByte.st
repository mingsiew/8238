
(* Copy the lower 2 bytes from a byte register *)
FUNCTION Get_LowerByte
	
	memcpy(ADR(Get_LowerByte),ADR(input),1);
	
END_FUNCTION
