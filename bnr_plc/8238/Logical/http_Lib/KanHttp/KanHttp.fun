
FUNCTION_BLOCK httpGetParameter (*FUB to Get parameter values set in URI or BODY...*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		searchPropertyName : STRING[50]; (*StringValue of propery or name to match*)
		searchEndProperty : STRING[50]; (*String Character or value to show end of property value -- DEFAULT & *)
		searchOffset : UINT; (*Offset can be set to skip searching begining of string if not required*)
		searchString : {REDUND_UNREPLICABLE} STRING[5000];
	END_VAR
	VAR_OUTPUT
		outputValue : STRING[100]; (*String Value found*)
		status : UINT;
		postionFound : UINT; (*Start position of the data found *)
	END_VAR
	VAR
		matchString : STRING[50];
		inputData : ARRAY[0..4999] OF USINT;
		endIndex : UINT;
		startPosition : UINT;
		n : UINT;
		compare : DINT;
		length : UINT;
		startoffset : UINT;
		search : STRING[50];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION FindAPI : UINT (**Get API name from URI*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		URI : STRING[500];
		ServiceName : STRING[50];
	END_VAR
	VAR
		Length : INT;
		Start : INT;
		apiName : STRING[100];
	END_VAR
END_FUNCTION
