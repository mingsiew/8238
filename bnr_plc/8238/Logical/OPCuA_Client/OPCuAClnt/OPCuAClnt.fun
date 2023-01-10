
{REDUND_OK} FUNCTION_BLOCK OPCuaGetErrorMessage (*Returns Text for OPCuA Error ID*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		ErrorID : UDINT;
	END_VAR
	VAR_OUTPUT
		ErrorMessage : STRING[254];
	END_VAR
END_FUNCTION_BLOCK
