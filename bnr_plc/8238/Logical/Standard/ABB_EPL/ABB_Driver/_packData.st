
ACTION _packData: 

	IF drive.Cmd.Run THEN
		CASE drive.Cmd.Direction OF
			
			ABB_DIRECTION_FWD:	
				drive.Comm.TargetVelocity :=	drive.Cmd.TargetVelocity;
			
			ABB_DIRECTION_REV:	
				drive.Comm.TargetVelocity :=	drive.Cmd.TargetVelocity * - 1;
		END_CASE;
	ELSIF drive.Manual.Run THEN
		CASE drive.Manual.Direction OF
			
			ABB_DIRECTION_FWD:	
				drive.Comm.TargetVelocity :=	drive.Manual.Velocity;
			ABB_DIRECTION_REV:	
				drive.Comm.TargetVelocity :=	drive.Manual.Velocity * - 1;
			ELSE
				drive.Comm.TargetVelocity :=	drive.Manual.Velocity;
		END_CASE;	
	END_IF;	
		
	//Control Word																Status Word
	//Bit 0		Switch On														Bit 0		Ready To Switch On
	//Bit 1		Enable Voltage											Bit 1		Switched On
	//Bit 2		Quick Stop													Bit 2		Operation Enabled
	//Bit 3		Enable Operation										Bit 3		Fault
	//Bit 4		Not Used In Scalor Mode							Bit 4		Voltage Enabled
	//Bit 5		Not Used In Scalor Mode							Bit 5		Quick Stop
	//Bit 6		Not Used In Scalor Mode							Bit 6		Switch On Disabled
	//Bit 7		Fault Reset													Bit 7 	Warning
	//Bit 8		Halt																Bit 8		Drive Specific TBC
	//Bit 9		Operation Mode Specific							Bit 9		Remote
	//Bit 10	Reserved	??Remote Control??				Bit 10	Target Reached
	//Bit 11	Drive Specific	TBC									Bit 11 	Internal Limit Reached
	//Bit 12	Drive Specific	TBC									Bit 12	Not Used In Scalor Mode
	//Bit 13	Drive Specific	TBC									Bit 13	Not Used In Scalor Mode
	//Bit 14	Drive Specific	TBC									Bit 14	Drive Specific TBC
	//Bit 15	Drive Specific	TBC									Bit 15	Drive Specific TBC
	
	drive.Status.ReadyToSwitchOn 	:= drive.Comm.StatusWord.0;
	drive.Status.ReadyToRun 		:= drive.Comm.StatusWord.1;
	drive.Comm.StatusWord.2; //Ready to ref-- not used
	drive.Status.Tripped 			:= drive.Comm.StatusWord.3;
	drive.Status.DriveEnabled 	:= drive.Comm.StatusWord.4; //the drive is enabled..
	drive.Status.QuickstopActive 	:= NOT drive.Comm.StatusWord.5; //QuickStop is not active
	drive.Status.SwitchOnInhibit 	:= drive.Comm.StatusWord.6; //We can't enable the drive....
	drive.Status.Warning 			:= drive.Comm.StatusWord.7;
	drive.Status.AtSpeed 			:= drive.Comm.StatusWord.8;
	drive.Status.OnRemote 		:= drive.Comm.StatusWord.9;
	
	drive.Status.ActCurrent := drive.Comm.ActCurrent;
	drive.Status.ActTorque := drive.Comm.ActTorque;
	
	//drive.Status.ThermalTrip := drive.Comm.DI.0;	
	
END_ACTION
