
(* Copy the upper 2 bytes of a DWORD to a WORD *)
FUNCTION Get_Higher2Bytes
	memcpy(ADR(Get_Higher2Bytes),ADR(input) + 2,2);
END_FUNCTION
