(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: mnEth
 * File: mnEth.typ
 * Author: tamme
 * Created: March 17, 2011
 ********************************************************************
 * Local data types of program mnEth
 ********************************************************************)

TYPE
	enumEthernetState : 
		(
		es_idle := 0,
		es_SetDef1 := 100,
		es_SetDef2,
		es_SetDef3,
		es_SetDef4,
		es_SetDef5,
		es_WriteCSV1 := 200,
		es_WriteCSV2,
		es_WriteCSV3,
		es_WriteCSV4,
		es_WriteCSV5,
		es_WriteCSV6,
		es_Change1 := 300,
		es_Change2,
		es_Change3,
		es_Change4,
		es_Change5,
		es_Change6,
		es_Change7,
		es_DHCP1 := 400,
		es_DHCP2,
		es_DHCP3,
		es_SNTPcltStart1 := 500,
		es_SNTPcltStop1 := 510,
		es_SNTPsrvStart1 := 520,
		es_SNTPsrvStop1 := 530,
		es_SetHostname1 := 600,
		es_SetHostname2,
		es_SetHostname3,
		es_SetUSB1 := 700,
		es_SetUSB2,
		es_SetUSB3,
		es_SetUSB4,
		es_SetUSB5,
		es_SetUSB6,
		es_Warning := 900
		);
	_EthPar_typ : 	STRUCT 
		IP_ID1 : USINT;
		IP_ID2 : USINT;
		IP_ID3 : USINT;
		Region : USINT;
		Station : USINT;
		Number : USINT;
		GWRegion : USINT;
		GWStation : USINT;
		IP_Adr : STRING[15];
		Gateway_Adr : STRING[15];
		NetId_Adr : STRING[15];
	END_STRUCT;
END_TYPE
