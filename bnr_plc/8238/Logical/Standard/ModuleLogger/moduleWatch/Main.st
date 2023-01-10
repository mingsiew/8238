
PROGRAM _INIT
BusCouplerDiag[31]; // ADD Reference to structure so AS builds correctl
	
mpAuditTrail.MpLink := ADR(gAuditTrail);	
mpAuditTrail.DeviceName := ADR('user');
mpAuditTrail.Enable := 1;	
test := 0;
timebase := 600;// 10mins.	
	
END_PROGRAM

PROGRAM _CYCLIC
	
	
	IF (index > 0) AND (index <= MAX_BUS_COUPLERS) THEN
		busCouplerVisu ACCESS ADR(BusCouplerDiag[index]);
	ELSE
		busCouplerVisu ACCESS ADR(BusCouplerDiag[0]);
	END_IF;
	
	
	IF test > 0 THEN			
		IF test < 16#FF THEN	
			test := test + 1;
		ELSE
			test := 1;
		END_IF;	
		n := 13;
		//FOR n := 31 TO 44 DO
		BusCouplerDiag[n].ModuleLostWhilstOperational := test;
		BusCouplerDiag[n].StationAtBusEnd := test;
		BusCouplerDiag[n].StationPastInFrameError := test;
		BusCouplerDiag[n].StationPastOutFrameError := test;
		//END_FOR;	
	END_IF;	

	
	mpAuditTrail.Export := export;	
	mpAuditTrail();
	
	IF export AND mpAuditTrail.CommandDone THEN	
		export := 0;	
	END_IF;	

	IF clearBuffer THEN
		MpAuditClearBuffer(gAuditTrail);	
		clearBuffer := 0;	
	END_IF;		

	
	
	//New functions found in the B&R library to report IO execptions.
	//Can only be used in the excpetion task class.
	//IO_info_0(enable := 1);
	//IX_info_0(enable := 1);
	//
	//IO_info_0.enable := 1;	
	//IO_info_0();	
	
END_PROGRAM
PROGRAM _EXIT
	mpAuditTrail.Enable := 0; // Release the mappLink
	mpAuditTrail();
END_PROGRAM