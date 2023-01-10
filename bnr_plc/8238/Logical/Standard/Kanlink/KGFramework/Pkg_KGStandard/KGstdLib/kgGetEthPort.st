(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: Netlink
 * File: GetEthPort.st
 * Author: hunholz
 * Created: June 30, 2011
 ********************************************************************
 * Implementation of library Netlink
 ********************************************************************) 

(* Returns the CPUs ethernet port as string *)
FUNCTION_BLOCK kgGetEthPort

	IF enable THEN
	
		IF adrIF <= 16#3FFF THEN
		
			_bStep := 10;
			status := KG_ERR_GETETHPORT_ADRIF;
			RETURN;
			
		END_IF	
			
		_xReady := FALSE;
		
		REPEAT

			CASE (_bStep) OF
				
				10:
				// Create Info
					DiagCreateInfo_CPU(enable := TRUE, infoKind := asdiagPLUGGED);
					
					status := DiagCreateInfo_CPU.status;
							  				
					IF (status = ERR_OK) THEN
			  			_bStep := 12;
					END_IF;		
	
				12:
					// Get Info
					DiagGetNumInfo_CPU(enable := TRUE,
											ident := DiagCreateInfo_CPU.ident,
											index := 0,
											infoCode := asdiagPLUGGED_MODNO);
					
					status := DiagGetNumInfo_CPU.status;
					
					IF (status = ERR_OK) THEN

						CASE DiagGetNumInfo_CPU.value OF

							KG_CPU_X20CP1484, KG_CPU_X20CP1484_1, KG_CPU_X20CP3484_1, KG_CPU_X20CP1486, KG_CPU_X20CP3486, KG_CPU_X20CP3585, KG_CPU_X20CP1584,KG_CPU_X20CP1586, KG_CPU_X20CP3484:
								brsstrcpy(adrIF, ADR('IF2'));	
							
							KG_CPU_PP420_1043_75, KG_CPU_CTT_11, KG_CPU_PP65_0571_P74, KG_CPU_PCT_04, KG_CPU_PCT_03:
								brsstrcpy(adrIF, ADR('IF5'));	
							
							ELSE	// keinen gültigen B&R ID-Code gefunden
								brsstrcpy(adrIF, ADR('IF3'));		
								//status := KG_ERR_GETETHPORT_IFSTRING;
							
						END_CASE

						_bStep := 14;

					ELSIF (status <> ERR_FUB_BUSY) THEN
						_bStep := 10;
					END_IF;
	
				14:	
					// Write string to variable

					DiagDisposeInfo_CPU(enable := TRUE, ident := DiagCreateInfo_CPU.ident);

					status := DiagDisposeInfo_CPU.status;

					_xReady := (status = ERR_OK);

					IF (status <> ERR_FUB_BUSY) THEN
						
						_bStep := 10;
						DiagCreateInfo_CPU(enable := FALSE);
						DiagDisposeInfo_CPU(enable := FALSE);
						DiagGetNumInfo_CPU(enable := FALSE);						
						
					END_IF;
			
				ELSE
					
					_bStep := 10;
					status := ERR_FUB_BUSY;
					
			END_CASE;
			
			UNTIL
			
			status <> ERR_OK OR _xReady
			
		END_REPEAT
		
	ELSE
		
		status := ERR_FUB_ENABLE_FALSE;
		_bStep := 10;
		
	END_IF
	
END_FUNCTION_BLOCK
