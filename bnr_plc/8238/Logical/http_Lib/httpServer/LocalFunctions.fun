
FUNCTION_BLOCK httpGetParameter (*FUB to Get parameter values set in URI or BODY...*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		searchPropertyName : STRING[50]; (*StringValue of propery or name to match*)
		searchEndProperty : STRING[50]; (*String Character or value to show end of property value -- DEFAULT & *)
		searchOffset : UINT; (*Offset can be set to skip searching begining of string if not required*)
		searchString : STRING[500];
	END_VAR
	VAR_OUTPUT
		outputValue : STRING[100]; (*String Value found*)
		status : UINT;
		nextPosition : UINT;
	END_VAR
	VAR
		matchString : STRING[50];
		inputData : ARRAY[0..499] OF USINT;
		endIndex : INT;
		startPosition : INT;
		n : INT;
		compare : DINT;
		length : UINT;
		startoffset : UINT;
		search : STRING[50];
	END_VAR
END_FUNCTION_BLOCK
