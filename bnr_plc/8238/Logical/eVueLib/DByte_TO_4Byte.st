
(* Build 32 bit register from 2 16bit register *)
FUNCTION DByte_TO_4Byte	
	memcpy(ADR(internalValue),adrLower,2);
	memcpy(ADR(internalValue)+2,adrHigher,2);
	DByte_TO_4Byte := internalValue;
END_FUNCTION
