(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: Kanlink 
 * File: Kanlink.typ
 * Author: stahlhut
 * Created: 20.03.2012
 ********************************************************************
 * Data types of library Kanlink Commando 30010 Silo
 ********************************************************************)
(*Kommandos*)

TYPE
	KLresp30010_SH_typ : 	STRUCT 
		MachineNo : STRING[15];
		State : UINT;
		RouteState : ARRAY[1..20]OF UINT;
		WetAccState : ARRAY[1..10]OF UINT;
		WetAccNiveau_mm : ARRAY[1..10]OF UINT;
		WetAccNiveau_rel : ARRAY[1..10]OF UINT;
		WetAccNiveau_Liter : ARRAY[1..10]OF UINT;
		WetAccTemp : ARRAY[1..10]OF UINT;
		WetAccMinLvlOK : ARRAY[1..10]OF UINT;
		WetAccMaxLvlOK : ARRAY[1..10]OF UINT;
	END_STRUCT;
	KLreq30010_SH_typ : 	STRUCT 
		MachineNo : STRING[15];
		State : UINT;
		Handshake : BOOL;
		Route : ARRAY[1..20]OF USINT;
		TankTemp : ARRAY[1..10]OF UINT;
	END_STRUCT;
	KL_SiloData_typ : 	STRUCT 
		Req : KLreq30010_SH_typ;
		Resp : KLresp30010_SH_typ;
	END_STRUCT;
END_TYPE
