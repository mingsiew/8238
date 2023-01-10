(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Package: Pkg_KGStandard
 * File: kgMachinetyp.typ
 * Author: hunholz
 * Created: January 27, 2012
 ********************************************************************
 * Data types of package Pkg_KGStandard
 ********************************************************************)
(**********************************)
(*Maschinentypen, -gruppen*)
(***********************************)

TYPE
	kgMachinetypeW3_typ : 
		(
		kgW3LOADSYSTEM := 0,
		kgW3WASHER := 10,
		kgW3WETSHUTTLE := 30,
		kgW3EXTRACTOR := 40,
		kgW3EXTRACTOR2 := 50, (*behind a WETSHUTTLE*)
		kgW3CONVEYOR := 60,
		kgW3DRYER := 70,
		kgW3SHAKER := 110, (*"Entsander"*)
		kgW3SINGLEWASHER := 120, (*FA+*)
		kgW3PROCESS := 150, (*EMS, Silo-Tank*)
		kgW3IFBOX := 160,
		kgW3DEVICE := 180, (*Camera, Printer*)
		kgW3SERVER := 202,
		kgW3PCSTATION := 210,
		kgW3BIT := 230,
		kgW3NOTDEFINED := 255
		);
END_TYPE
