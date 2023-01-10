(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * File: Global.typ
 * Author: tamme
 * Created: March 17, 2011
 ********************************************************************
 * Global data types of project Ethernetmanagr
 ********************************************************************)

TYPE
	mnEthIP_typ : 	STRUCT 
		sIP : STRING[15];
		sGateway : STRING[15];
		sHostname : STRING[15];
		sNetId : STRING[15];
		bNetId1 : USINT;
		bNetId2 : USINT;
		bNetId3 : USINT;
		bRegion : USINT;
		bStation : USINT;
		bNumber : USINT;
	END_STRUCT;
	IFmnEthOut_typ : 	STRUCT 
		IP : mnEthIP_typ;
		sEthDevice : STRING[15];
		xDataValid : BOOL;
	END_STRUCT;
	IFmnEthIn_typ : 	STRUCT 
		bNodeSwitch : USINT;
	END_STRUCT;
	IFmnEth_typ : 	STRUCT 
		In : IFmnEthIn_typ;
		Out : IFmnEthOut_typ;
	END_STRUCT;
	mnEthStatAd_typ : 	STRUCT 
		IP : mnEthIP_typ;
		xDataValid : BOOL;
		sPkgVersion : STRING[11];
	END_STRUCT;
	mnEthPar_typ : 	STRUCT 
		Cfg : mnEthParCfg_typ;
		Mac : mnEthParMac_typ;
	END_STRUCT;
	mnEthParMac_typ : 	STRUCT 
		xStartDHCP : BOOL;
		xStartSNTPClt : BOOL;
		xStartSNTPSrv : BOOL;
		xForceNotSubnetmask : BOOL;
		sIP_SNTP_Srv : STRING[15];
	END_STRUCT;
	mnEthParCfg_typ : 	STRUCT 
		bNETid1 : USINT;
		bNETid2 : USINT;
		bNETid3 : USINT;
		bRegion : USINT;
		bStation : USINT;
	END_STRUCT;
END_TYPE
