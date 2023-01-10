(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: kgGetMacAdress.st
 * Author: hunholz
 * Created: July 19, 2011
 ********************************************************************
 * Implementation of library KGstd
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION_BLOCK kgGetMacAdress
	
	IF Enable THEN
	
		// MAC-Adresse initialisieren
		brsmemset(ADR(Mac),0,SIZEOF(Mac));
	
		// Ermittle den Ethernet-Devicestring aus der CPU-ID
		// Siehe Library Netlink
		
		_gep.enable := TRUE;
		_gep.adrIF := ADR(_sIF);
		
		REPEAT
			
			_gep();
			
		UNTIL
	
			_gep.status <> ERR_FUB_BUSY
	
		END_REPEAT
		
		// Lese die MAC-Adresse aus
		
		IF _gep.status = 0 THEN
			
			_exi.enable := TRUE;
			_exi.pDevice := ADR(_sIF);
			
			_exi();
			
			_bMAC := _exi.mac;
		
			Status := _exi.status;
			
			IF Status = 0 THEN
				
				Mac := _bMAC;
				
			END_IF
			
		ELSE
			
			Status := _gep.status;
			
		END_IF

	ELSE
	
		Status := ERR_FUB_ENABLE_FALSE;
		
	END_IF
	
END_FUNCTION_BLOCK
