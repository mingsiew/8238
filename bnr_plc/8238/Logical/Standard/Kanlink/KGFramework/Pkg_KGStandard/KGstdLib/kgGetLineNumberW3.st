(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgGetLineNumberW3.st
 * Author: hunholz
 * Created: January 27, 2012
 * Changed: February 8, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Liniennummer und -typ aus Stationsadresse berechnen *)
FUNCTION kgGetLineNumberW3
	
	_MachineType ACCESS pMachineType;
	
	_MachineType := kgW3NOTDEFINED;
	kgGetLineNumberW3 := 0;
	
	CASE Station OF
		
		1..10:
			kgGetLineNumberW3 := Station;
			_MachineType := kgW3LOADSYSTEM;
			
		11..30:
			kgGetLineNumberW3 := Station - 10;
			_MachineType := kgW3WASHER;

		31..40:
			kgGetLineNumberW3 := Station - 30;
			_MachineType := kgW3WETSHUTTLE;

		41..50:
			kgGetLineNumberW3 := Station - 40;
			_MachineType := kgW3EXTRACTOR;
		
		51..60:
			kgGetLineNumberW3 := Station - 50;
			_MachineType := kgW3EXTRACTOR2;

		61..70:
			kgGetLineNumberW3 := Station - 60;
			_MachineType := kgW3CONVEYOR;

		71..100:
			kgGetLineNumberW3 := Station - 70;
			_MachineType := kgW3DRYER;
		
		111..120:
			kgGetLineNumberW3 := Station - 110;
			_MachineType := kgW3SHAKER;
		
		121..150:
			kgGetLineNumberW3 := Station - 120;
			_MachineType := kgW3SINGLEWASHER;
		
		151..160:
			kgGetLineNumberW3 := Station - 150;
			_MachineType := kgW3PROCESS;
		
		161..180:
			kgGetLineNumberW3 := Station - 160;
			_MachineType := kgW3IFBOX;

		181..200:
			kgGetLineNumberW3 := Station - 180;
			_MachineType := kgW3DEVICE;
		
		202:
			kgGetLineNumberW3 := 202;
			_MachineType := kgW3SERVER;
			
		211..230:
			kgGetLineNumberW3 := Station - 210;
			_MachineType := kgW3PCSTATION;
		
		231..250:
			kgGetLineNumberW3 := Station - 230;
			_MachineType := kgW3BIT;
		
	END_CASE


END_FUNCTION