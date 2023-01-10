
//*Set Local variable from external task
FUNCTION GetValueByName
	GetValueByName := 0;
	
	IF (brsstrlen(ADR(TaskName)) > 0 )THEN
		varName := '::';
		brsstrcat(ADR(varName),ADR(TaskName));
		brsstrcat(ADR(varName),ADR(':'));
		brsstrcat(ADR(varName),ADR(VarName));
	ELSE
		brsstrcpy(ADR(varName),ADR(VarName));	
	END_IF;	
	
	status := PV_xgetadr(ADR(varName),ADR(pVar),ADR(sVar));
	IF (status = 0) THEN
		IF (sValue >= sVar)THEN
			//Clear the value
			IF (sValue > sVar) THEN
				brsmemset(pValue,0,sValue);
			END_IF;	
			brsmemcpy(pValue,pVar,sVar);
			GetValueByName := 1;
		END_IF;
	END_IF;
END_FUNCTION
