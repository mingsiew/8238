(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgUnitconfREALtoDisplay.st
 * Author: hunholz
 * Created: March 15, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Wandelt Wert entsprechend der Unit *)
FUNCTION kgUnitconfREALtoDisplay
	
	lDigits := 0;
	sUnit := '';
	
	CASE Unit OF
		
		2,60,70,80,91,901:

			// 1/10
			kgUnitconfREALtoDisplay := Value * 0.1;
			lDigits := 1;
			
			CASE Unit OF
				
				2:
					// Sekunden
					sUnit := 's';
					
				60:
					// Hertz
					sUnit := 'Hz';
					
				70:
					// Winkel
					sUnit := '°';
					
				80:
					// Prozent
					sUnit := '%';
				91:
					// Prozent
					sUnit := 'g';
				
			END_CASE
		
		90,902:
			// 1/100
			kgUnitconfREALtoDisplay := Value * 0.01;
			lDigits := 2;

			CASE Unit OF
				
				90:
					// g
					sUnit := 'g';

			END_CASE

			
		4,903:
			
			// 1/1000
			kgUnitconfREALtoDisplay := Value * 0.001;
			lDigits := 3;

			CASE Unit OF
				
				4:
					// Sekunde
					sUnit := 's';

			END_CASE

		10:
			// liter Gallonen
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.2641721;
				lDigits := 1;
				sUnit := 'US gal';
			ELSE
				kgUnitconfREALtoDisplay := Value;
				sUnit := 'l';
			END_IF
		
		11:
			// milliliter Ounce
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.03381402;
				lDigits := 3;
				sUnit := 'fl.Oz.';
				
			ELSE
				kgUnitconfREALtoDisplay := Value;
				sUnit := 'ml';
			END_IF

		20:
			// mm inch
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.03937;
				lDigits := 2;
				sUnit := 'inch';
			ELSE
				kgUnitconfREALtoDisplay := Value;
				sUnit := 'mm';
			END_IF

		21:
			// mm cm inch
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.03937;
				lDigits := 2;
				sUnit := 'inch';
			ELSE
				kgUnitconfREALtoDisplay := Value * 0.1;
				lDigits := 1;
				sUnit := 'cm';
			END_IF

		22:
			// mm dm inch
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.03937;
				sUnit := 'inch';
			ELSE
				kgUnitconfREALtoDisplay := Value * 0.01;
				sUnit := 'dm';
			END_IF
			lDigits := 2;

		23:
			// mm m feet
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.00328;
				sUnit := 'ft';
			ELSE
				kgUnitconfREALtoDisplay := Value * 0.001;
				sUnit := 'm';
			END_IF
			lDigits := 3;
			
		30:
			// 0,1kg kg lbs
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.220462;
				sUnit := 'lbs';
			ELSE
				kgUnitconfREALtoDisplay := Value * 0.1;
				sUnit := 'kg';
			END_IF
			lDigits := 1;

		40:
			// 0,1 °C °C °F
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := (Value * 0.18) + 32.0;
				sUnit := '°F';
			ELSE
				kgUnitconfREALtoDisplay := Value * 0.1;
				sUnit := '°C';
			END_IF
			lDigits := 1;

		41:
			// °C °C °F
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := (Value * 1.8) + 32.0;
				sUnit := '°F';
			ELSE
				kgUnitconfREALtoDisplay := Value;
				sUnit := '°C';
			END_IF

		50:
			// 0,1 bar bar psi
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 1.450368;
				sUnit := 'psi';
			ELSE
				kgUnitconfREALtoDisplay := Value * 0.1;
				lDigits := 1;
				sUnit := 'bar';
			END_IF

		310:
			// 0,01 l/kg l/kg gal/lbs
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfREALtoDisplay := Value * 0.00119827;
				lDigits := 2;
				sUnit := 'gal/lbs';
			ELSE
				kgUnitconfREALtoDisplay := Value * 0.01;
				lDigits := 1;
				sUnit := 'l/kg';
			END_IF

		ELSE
		
			kgUnitconfREALtoDisplay := Value;
			
			CASE Unit OF
				
				1:
					sUnit := 's';
				3:
					sUnit := 'min';
				81:
					sUnit := '%';
				
			END_CASE
			
	END_CASE
	
	IF pDigits > 0 THEN
		
		brsmemcpy(pDigits, ADR(lDigits), SIZEOF(lDigits));
		
	END_IF
	
	IF pUnit > 0 THEN
		
		brsmemcpy(pUnit, ADR(sUnit), SIZEOF(sUnit));
		
	END_IF

END_FUNCTION