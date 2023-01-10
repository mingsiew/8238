(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KGstdLib
 * File: kgUnitconfDisplayToREAL.st
 * Author: hunholz
 * Created: March 15, 2012
 ********************************************************************
 * Implementation of library KGstdLib
 ********************************************************************) 

(* Wandelt Wert entsprechend der Unit *)
FUNCTION kgUnitconfDisplayToREAL

	CASE Unit OF
		
		2,60,70,80,91,901:
			// 1/10
			kgUnitconfDisplayToREAL := Display * 10;
		
		90,902:
			// 1/100
			kgUnitconfDisplayToREAL := Display * 100;
		
		4,903:
			// 1/1000
			kgUnitconfDisplayToREAL := Display * 1000;
			
		10:
			// liter Gallonen
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.2641721;
			ELSE
				kgUnitconfDisplayToREAL := Display;
			END_IF
		
		11:
			// milliliter Ounce
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.03381402;
			ELSE
				kgUnitconfDisplayToREAL := Display;
			END_IF

		20:
			// mm inch
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.03937;
			ELSE
				kgUnitconfDisplayToREAL := Display;
			END_IF

		21:
			// mm cm inch
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.03937;
			ELSE
				kgUnitconfDisplayToREAL := Display * 10;
			END_IF

		22:
			// mm dm inch
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.03937;
			ELSE
				kgUnitconfDisplayToREAL := Display * 100;
			END_IF

		23:
			// mm m feet
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.00328;
			ELSE
				kgUnitconfDisplayToREAL := Display * 1000;
			END_IF
			
		30:
			// 0,1kg kg lbs
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.220462;
			ELSE
				kgUnitconfDisplayToREAL := Display * 10;
			END_IF

		40:
			// 0,1 °C °C °F
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := (Display - 32.0) / 0.18;
			ELSE
				kgUnitconfDisplayToREAL := Display * 10;
			END_IF

		41:
			// °C °C °F
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := (Display - 32.0) / 1.8;
			ELSE
				kgUnitconfDisplayToREAL := Display;
			END_IF

		50:
			// 0,1 bar bar psi
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 1.450368;
			ELSE
				kgUnitconfDisplayToREAL := Display * 10;
			END_IF

		310:
			// 0,01 l/kg l/kg gal/lbs
			IF LocUnit = KG_UNIT_US THEN
				kgUnitconfDisplayToREAL := Display / 0.00119827;
			ELSE
				kgUnitconfDisplayToREAL := Display * 100;
			END_IF

		ELSE
		
			kgUnitconfDisplayToREAL := Display;
			
	END_CASE

END_FUNCTION