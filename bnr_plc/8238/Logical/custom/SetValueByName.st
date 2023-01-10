
//*Set Local variable from external task
FUNCTION SetValueByName
	SetValueByName := 0;
	varName := '::';
	brsstrcat(ADR(varName),ADR(TaskName));
	brsstrcat(ADR(varName),ADR(':'));
	brsstrcat(ADR(varName),ADR(VarName));

	
	IF (PV_xgetadr(ADR(varName),ADR(pVar),ADR(sVar)) = 0) THEN
		IF (SIZEOF(Value) <= sVar)THEN
			brsmemcpy(pVar,ADR(Value),SIZEOF(Value));
			SetValueByName := 1;
		ELSE
			brsmemcpy(pVar,ADR(Value),sVar);
			SetValueByName := 1;
		END_IF;
	END_IF;
END_FUNCTION
