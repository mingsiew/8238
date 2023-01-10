
ACTION _decodeData: 

	state := CONTACTRON;
	count := 1;
	memset(ADR(tempString),0,SIZEOF(tempString));
	
	FOR loop:=0 TO SIZEOF(IO_Link.httpResponse) - 1 DO
		IF IO_Link.httpResponse[loop] = 0 THEN //Null
			EXIT;
		ELSIF IO_Link.httpResponse[loop] = 44 THEN //Comma
			CASE state OF
				CONTACTRON:
					fuseSettingStructure.Contactron[count] := DINT_TO_USINT(atoi(ADR(tempString)));
					count := count + 1;
					IF count > MAX_CONTACTRON THEN state := EASYB; count := 1; END_IF;
				EASYB:
					CASE DINT_TO_USINT(atoi(ADR(tempString))) OF
						TRIP_CURRENT_DEFAULT:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_DEFAULT;
						TRIP_CURRENT_500mA:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_500mA;
						TRIP_CURRENT_1A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_1A;
						TRIP_CURRENT_2A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_2A;
						TRIP_CURRENT_3A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_3A;
						TRIP_CURRENT_4A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_4A;
						TRIP_CURRENT_5A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_5A;
						TRIP_CURRENT_6A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_6A;
						TRIP_CURRENT_8A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_8A;
						TRIP_CURRENT_10A:
							fuseSettingStructure.EasyB[count] := TRIP_CURRENT_10A;						
					END_CASE;
					count := count + 1;
			END_CASE;
			memset(ADR(tempString),0,SIZEOF(tempString));
		ELSE
			itoa(IO_Link.httpResponse[loop]-48, ADR(tempString2));
			tempString := CONCAT(tempString, tempString2);
		END_IF;
	END_FOR;
	
END_ACTION
