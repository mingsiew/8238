
ACTION _encodeData:
	//Clear string memory
	memset(ADR(IO_Link.httpRequest),0,SIZEOF(IO_Link.httpRequest));
	//Add length to start of string
	ftoa(MAX_CONTACTRON,ADR(tempString));
	strcat(ADR(IO_Link.httpRequest),ADR(tempString));
	strcat(ADR(IO_Link.httpRequest),ADR(","));
	ftoa(MAX_EASYB,ADR(tempString));
	strcat(ADR(IO_Link.httpRequest),ADR(tempString));
	strcat(ADR(IO_Link.httpRequest),ADR(","));
	//Encode data
	FOR n:=1 TO MAX_CONTACTRON DO
		ftoa(fuseSettingStructure.Contactron[n],ADR(tempString));
		strcat(ADR(IO_Link.httpRequest),ADR(tempString));
		strcat(ADR(IO_Link.httpRequest),ADR(","));
	END_FOR;
	FOR n:=1 TO MAX_EASYB DO
		ftoa(fuseSettingStructure.EasyB[n],ADR(tempString));
		strcat(ADR(IO_Link.httpRequest),ADR(tempString));
		strcat(ADR(IO_Link.httpRequest),ADR(","));
	END_FOR;
	
	FOR n:=1 TO MAX_EASYB DO
		IO_Link.EasyB.EasyB_Array[n].Cmd.SetTripCurrent := fuseSettingStructure.EasyB[n];
	END_FOR;
	FOR n:=1 TO MAX_CONTACTRON DO
		IO_Link.Contactron[n].Cmd.Current := fuseSettingStructure.Contactron[n];
	END_FOR;
END_ACTION
