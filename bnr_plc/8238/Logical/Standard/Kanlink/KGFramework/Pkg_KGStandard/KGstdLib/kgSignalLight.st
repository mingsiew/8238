(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgSignalLight.st
 * Author: hunholz
 * Created: July 12, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Process red/yellow/green *)
FUNCTION kgSignalLight
	
	xGreen 		:= FALSE;
	xRed		:= FALSE;
	xYellow 	:= FALSE;
		
	CASE wStatus OF
			
		(*-0- Maschine aus*)
		KG_MACHINESTATE_OFF:
				
		(*-1- NOT-HALT*)	
		KG_MACHINESTATE_EMERGENCYSTOP:
				
			xRed := xClock;
	
		(*-2- Sicherer HALT*)
		KG_MACHINESTATE_SAFESTOP:
				
			xYellow := xClock;
 	
		(*-3- Störung*)
		KG_MACHINESTATE_FAULT:
				
			xRed := TRUE;
	
		(*-4- Störung quittierbar*)
		KG_MACHINESTATE_FAULT_GONE:
				
			xRed := TRUE;
			xYellow := xClock;
	
		(*-5- Service / Handbetrieb*)
		KG_MACHINESTATE_SERVICE:
				
			xYellow := xClock;
			xGreen := xClock;
	
		(*-6- Maschine läuft*)
		KG_MACHINESTATE_AUTOMATIC_RUN:

			xGreen := TRUE;
	
		(*-7- STOP*)
		KG_MACHINESTATE_STOP:
	
		(*-8- Maschine wartet auf Automatik-Freigabe*)
		KG_MACHINESTATE_WAIT_AUTOMATIC:
				
			xGreen := xClock;
	
		(*-9- Maschine wartet auf Bestätigung durch Bediener*)
		KG_MACHINESTATE_WAIT_MAN:
				
			xYellow := xClock;
			xGreen := TRUE;
	
		(*-10- Warnung*)
		KG_MACHINESTATE_WARNING:

			xYellow := TRUE;
			xGreen := TRUE;
				
		ELSE

			xGreen := TRUE;

	END_CASE

	
END_FUNCTION