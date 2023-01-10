
(* Copy the upper 2 bytes of a DWORD to a WORD *)
FUNCTION Get_HigherByte
	memcpy(ADR(Get_HigherByte),ADR(input) + 1,1);
END_FUNCTION
