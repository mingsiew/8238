
{REDUND_ERROR} FUNCTION SetValueByName : BOOL (**Set Local variable from external task*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		TaskName : STRING[24];
		VarName : STRING[50];
		Value : UDINT;
	END_VAR
	VAR
		sVar : UDINT;
		pVar : UDINT;
		varName : STRING[75];
	END_VAR
END_FUNCTION
