
ACTION _visu: 
	
	
	brsitoa(MappSafety.State,ADR(sState));
	brsitoa(safetyInfo.Status.SafeOSState,ADR(sSafeOsState));
	brsitoa(safetyInfo.Status.SafeNodesState,ADR(sSafeNodeState));
	brsitoa(safetyInfo.Status.SystemState,ADR(sSystemState));
	brsitoa(safetyInfo.Status.OperationalModeState,ADR(sOperationalModeState));
	
	MappSafety.Visu.ResetError.Enable := MappSafety.Visu.ResetError.Visible	:=  (MappSafety.State = 200);
	
	MappSafety.Visu.Transfer.Enable 			:= NOT MappSafety.Commands.Transfer AND (MappSafety.State <= 11);	
	MappSafety.Visu.Complete.Enable 			:= NOT MappSafety.Commands.Complete AND (MappSafety.State <= 10);	
	MappSafety.Visu.ActivateSetupMode.Enable 	:= NOT MappSafety.Commands.ActivateSetupMode AND (MappSafety.State <= 10);	
	MappSafety.Visu.Exchange.Enable 			:= NOT MappSafety.Commands.Exchange AND (MappSafety.State <= 10);	
	MappSafety.Visu.Format.Enable 				:= NOT MappSafety.Commands.Format AND (MappSafety.State <= 11);	
	MappSafety.Visu.Restart.Enable 				:= NOT MappSafety.Commands.Restart AND (MappSafety.State <= 10);	
	
	
	MappSafety.Visu.Exchange.Visible 	:= MappSafety.Visu.ActivateSetupMode.Visible := safeInfoValid AND NOT safetyInfo.Status.SetupModeActive AND (MappSafety.State <= 10); 	
	MappSafety.Visu.Transfer.Visible 	:= safeInfoValid;// AND safetyInfo.SafeApplication.ExistOnSafeLogic;
	MappSafety.Visu.Complete.Visible 	:= safeInfoValid AND (safetyInfo.SafeApplication.ExistOnSafeLogic AND NOT safetyInfo.SafeApplication.Acknowledged) OR safetyInfo.Status.SetupModeActive ;
	MappSafety.Visu.Restart.Visible 	:= 	TRUE;
	MappSafety.Visu.Format.Visible 		:= safeInfoValid;// AND safetyInfo.SafeApplication.ExistOnSafeLogic;
	
END_ACTION
