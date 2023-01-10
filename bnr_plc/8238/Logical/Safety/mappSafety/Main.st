
PROGRAM _INIT
	sfDomain := ADR(gSafeDomain);
	
	sfDomainConnect.UserName := 'Safety';	 
	sfDomainConnect.Password := 'safeplc';
	
	sfDomainTransfer.SafeAppFilePath :=	'SafeLOGIC-1'; // We must be connected for this to work.
	
	sfDomainConnect.SfDomain := sfDomainInfo.SfDomain := sfDomainTransfer.SfDomain := sfDomainControl.SfDomain :=  sfDomainExchange.SfDomain := sfDomainCompletion.SfDomain :=  sfDomain;
	refreshTime := T#5s;
	state ACCESS ADR(MappSafety.State);
	safeInfoValid := FALSE;
	state := 0;
END_PROGRAM

PROGRAM _CYCLIC

	sfDomainConnect.Enable := (state <> 200);
	IF NOT sfDomainConnect.Active AND (state <> 200) THEN  // No connection to the domain,			
		safeInfoValid := 0;
	END_IF;		
	
	sfDomainInfo.Execute 				:= 0;	
	sfDomainTransfer.Execute 			:= 0;	
	sfDomainCompletion.Execute 			:= 0;	
	sfDomainExchange.Execute 			:= 0;	
	sfDomainControl.Execute 			:= 0;	
	
	ton_refresh(IN := (state = 10), PT:= refreshTime);
	
	CASE state OF
		0: // Connect to the safe PLC 
			IF sfDomainConnect.Active THEN
				state := 1;
			ELSIF sfDomainConnect.Error THEN
				state := 200;
			END_IF;	
		
		1: // Read the status of the safety plc.
			sfDomainInfo.Execute := 1;
			IF sfDomainInfo.Done THEN
				safeInfoValid := 1; 
				safetyInfo := sfDomainInfo.Info;
				state := 10;	
			ELSIF sfDomainInfo.Error THEN	
				state := 200;	
			END_IF;
		
		10:// Decide what to do//	
			// Check for any actions first. 
			IF NOT  safetyInfo.SafeApplication.ExistOnSafeLogic THEN
				state := 11;
			ELSIF MappSafety.Commands.Transfer THEN
				MappSafety.Commands.Transfer := 0;	
				state := 20;
			ELSIF MappSafety.Commands.Complete THEN
					MappSafety.Commands.Complete := 0;	
					state := 30;	
			ELSIF MappSafety.Commands.Exchange THEN
				MappSafety.Commands.Exchange := 0;	
				state := 40;		
			ELSIF MappSafety.Commands.Restart THEN
				MappSafety.Commands.Restart := 0;	
				state := 50;		
			ELSIF MappSafety.Commands.Format THEN
				MappSafety.Commands.Format := 0;	
				state := 51;		
			ELSIF MappSafety.Commands.ActivateSetupMode THEN
				MappSafety.Commands.ActivateSetupMode := 0;	
				state := 52;		
			ELSIF ton_refresh.Q THEN
				state := 1;
			END_IF;	
			
		11:// Program not downloaded.	
			IF MappSafety.Commands.Transfer THEN
				MappSafety.Commands.Transfer := 0;	
				state := 20;	
			ELSIF MappSafety.Commands.Restart THEN
				MappSafety.Commands.Restart := 0;	
				state := 50;		
			ELSIF MappSafety.Commands.Format THEN
				MappSafety.Commands.Format := 0;	
				state := 51;	
			END_IF;
			
		20:// Transfer the project.	
			sfDomainTransfer.Execute := 1;
			IF sfDomainTransfer.Done THEN
				state := 0;
			ELSIF sfDomainTransfer.Error THEN	
				state := 200;	
			END_IF;
			
		
		30:// Complete the setup	
			sfDomainCompletion.Execute := 1;	
			IF sfDomainCompletion.Done THEN
				state := 0;
			ELSIF sfDomainCompletion.Error THEN	
				state := 200;	
			END_IF;
			
			
		40:// Acknowledge some request from the safe PLC.	
			sfDomainExchange.Execute := 1;	
			IF sfDomainExchange.Done THEN
				state := 0;
			ELSIF sfDomainExchange.Error THEN	
				state := 200;	
			END_IF;
				
		
		50:// Control the Safe PLC -- Force a restart..
			sfDomainControl.Execute := 1;	
			sfDomainControl.ControlCommand := sfDOM_REBOOT;
			IF sfDomainControl.Done THEN
				state := 0;
			ELSIF sfDomainControl.Error THEN	
				state := 200;	
			END_IF;
		
		51:// Control the Safe PLC -- Format the safe plc
			sfDomainControl.Execute := 1;	
			sfDomainControl.ControlCommand := sfDOM_FORMAT_REBOOT;
			IF sfDomainControl.Done THEN
				state := 0;
			ELSIF sfDomainControl.Error THEN	
				state := 200;	
			END_IF;	
		
		52:// Control the Safe PLC -- Activate setup mode.
			sfDomainControl.Execute := 1;	
			sfDomainControl.ControlCommand := sfDOM_ACT_SETUP_MODE;
			IF sfDomainControl.Done THEN
				state := 0;
			ELSIF sfDomainControl.Error THEN	
				state := 200;	
			END_IF;		
			
			
		200:// Error step
			IF MappSafety.Commands.ResetError THEN
				MappSafety.Commands.ResetError := 0;	
				state := 0;			
			END_IF;
	END_CASE;	
	
	
	
	
	sfDomainCompletion.Info := safetyInfo;	
	sfDomainExchange.Info := safetyInfo;		
	
	sfDomainConnect();		
	sfDomainInfo();
	sfDomainTransfer();	
	sfDomainControl();	
	sfDomainExchange();		
	sfDomainCompletion();	
	
	//We have to read the domain info and pass it to the Completion function.	
	_visu;
	
	
END_PROGRAM
PROGRAM _EXIT
	
	sfDomainConnect.Enable 					:= 0;		
	sfDomainConnect();		

END_PROGRAM


