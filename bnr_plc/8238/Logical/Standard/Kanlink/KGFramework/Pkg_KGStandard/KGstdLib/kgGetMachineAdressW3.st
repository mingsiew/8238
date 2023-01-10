(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgGetMachineAdressW3.st
 * Author: hunholz
 * Created: February 08, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Ermittelt die Maschinenadresse aus Liniennummer und Maschinentyp *)
FUNCTION kgGetMachineAdressW3
	
	_diMachineType ACCESS ADR(MachineType);

	kgGetMachineAdressW3 := 0;

	IF MachineType = kgW3SERVER THEN
		
		kgGetMachineAdressW3 := 202;
		
	ELSE
		
		CASE MachineType OF
			
			kgW3LOADSYSTEM, kgW3EXTRACTOR, kgW3EXTRACTOR2, kgW3CONVEYOR, kgW3SHAKER, kgW3PROCESS:

				IF LineNumber >= 1 AND LineNumber <= 10 THEN

					kgGetMachineAdressW3 := DINT_TO_USINT(_diMachineType) + LineNumber;
					
				END_IF

			kgW3WASHER, kgW3IFBOX, kgW3DEVICE, kgW3PCSTATION, kgW3BIT:

				IF LineNumber >= 1 AND LineNumber <= 20 THEN

					kgGetMachineAdressW3 := DINT_TO_USINT(_diMachineType) + LineNumber;
					
				END_IF

			kgW3DRYER, kgW3SINGLEWASHER:

				IF LineNumber >= 1 AND LineNumber <= 30 THEN

					kgGetMachineAdressW3 := DINT_TO_USINT(_diMachineType) + LineNumber;
					
				END_IF
					
			
		END_CASE
		
	END_IF

END_FUNCTION