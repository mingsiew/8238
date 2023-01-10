
ACTION _status:
	CASE statusState OF
		0:
			offset := 1;
			FOR n:=1 TO MAX_CONTACTRON DO
				statusValue[n] := IO_Link.Contactron[n].Status.Current;
				offset := offset + 1;
			END_FOR;
			offset := MAX_CONTACTRON;
//			FOR n:=1 TO MAX_EASYB DO
//				statusValue[offset + n] := INT_TO_REAL(IO_Link.EasyB.EasyB_Array[n].Status.Current);
//				offset := offset + 1;
//			END_FOR;
			statusState := 1;
		1:
//			memset(ADR(IO_Link.httpRequest),0,SIZEOF(IO_Link.httpRequest));
//			ftoa(MAX_CONTACTRON,ADR(tempString));
//			strcat(ADR(IO_Link.httpRequest),ADR(tempString));
//			strcat(ADR(IO_Link.httpRequest),ADR(","));
//			ftoa(MAX_EASYB,ADR(tempString));
//			strcat(ADR(IO_Link.httpRequest),ADR(tempString));
//			strcat(ADR(IO_Link.httpRequest),ADR(","));
//			FOR n:=1 TO offset DO
//				ftoa(statusValue[n],ADR(tempString));
//				strcat(ADR(IO_Link.httpRequest),ADR(tempString));
//				strcat(ADR(IO_Link.httpRequest),ADR(","));
//			END_FOR;
//			statusState := 0;
//			IO_Link.Status := FALSE;
	END_CASE;
	
	
END_ACTION
