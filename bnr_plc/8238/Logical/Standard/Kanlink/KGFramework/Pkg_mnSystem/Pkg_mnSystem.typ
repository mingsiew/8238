(********************************************************************
 * COPYRIGHT -- Kannegiesser GmbH
 ********************************************************************
 * Program: mnSystem
 * File: mnSystem.typ
 * Author: horn
 * Created: January 10, 2012
 ********************************************************************
 * Local data types of program mnSystem
 ********************************************************************)

TYPE
	mnSystemStatAd_typ : 	STRUCT 
		sPkgVersion : STRING[10]; (*Version des Packes mnSystem*)
		sPrjVersion : STRING[10]; (*Hauptversion des Projektes*)
		sFWVersion : STRING[10]; (*Frameworkversion abgeleitet aus mnTest*)
		sCPUType : STRING[19]; (*CPU-Typ*)
		wHeartbeat : UINT; (*Zählt sekündlich hoch*)
		wTemperatureCPU : UINT; (*CPU Temperatur 1/10 °C*)
		wTemperatureEnvironment : UINT; (*Umgebungstemperatur 1/10 °C*)
		lSerialNumber : UDINT; (*Seriennummer der CPU*)
	END_STRUCT;
	IFmnSystem_typ : 	STRUCT 
		In : IFmnSystemIn_typ;
		Out : IFmnSystemOut_typ;
	END_STRUCT;
	IFmnSystemOut_typ : 	STRUCT 
		xUSBStickReady : BOOL; (*USB-Stick erkannt*)
		xUSBStickScanned : BOOL; (*USB-Stick-Scan wurde erstmals durchgeführt*)
		xModuleFault : BOOL;
		sInterfaceUSB : STRING[31]; (*Interfacebezeichnung für den Stick*)
		x1s : BOOL;
		x500ms : BOOL;
	END_STRUCT;
	IFmnSystemIn_typ : 	STRUCT 
		PLC : mnSystem_PLC_typ;
		ModuleInfo : ARRAY[1..MNSYSTEM_CNT_MODULELINES,1..MNSYSTEM_CNT_MODULES]OF mnSystem_ModuleInfo_typ;
		ModuleStatus : ARRAY[1..MNSYSTEM_CNT_MODULELINES,1..MNSYSTEM_CNT_MODULES]OF mnSystem_ModuleStatus_typ;
		xSupplyFault : ARRAY[1..12]OF BOOL;
	END_STRUCT;
	mnSystem_PLC_typ : 	STRUCT 
		lSerialNumber : UDINT; (*Serien-Nummer des X20 Moduls*)
		wMDL_ID : UINT; (*Modul-ID des X20 Moduls*)
		bModeSwitch : USINT; (*Version der Firmware*)
		bBatteryStatusCPU : USINT; (*Status der Pufferbatterie*)
		xFanOk : BOOL; (*Status des CPU-Lüfters*)
		wTemperatureCPU : UINT; (*CPU-Temperatur*)
		wTemperatureENV : UINT;
		diSystemTime : DINT; (*Systemzeit der CPU in µs*)
		xStatusInput01 : BOOL; (*Status der 24V-Versorgung für I/O*)
		lPowerOnCycles : UDINT;
		lOperatingHoursPP : UDINT;
	END_STRUCT;
	mnSystem_ModuleStatus_typ : 	STRUCT 
		xiMDL_OK : BOOL; (*Status des Moduls*)
		xiStatIn01 : BOOL; (*Busversorgungswarnung (1 = Ueberstrom >2,3 A oder Unterspannung <4,7 V) *)
		xiStatIn02 : BOOL; (*I/O Versorgungswarnung (0 = DC OK)*)
		aiStatus : USINT; (*Status bei Temperatur Modul*)
		xiSingleStatus : ARRAY[1..12]OF BOOL; (*Status bei digitalen Ausgängen*)
	END_STRUCT;
	mnSystem_ModuleInfo_typ : 	STRUCT 
		lSerialNumber : UDINT; (*Serien-Nummer des X20 Moduls*)
		wMDL_ID : UINT; (*Modul-ID des X20 Moduls*)
		wHwVariant : UINT; (*Hardware Variante des X20 Moduls*)
		wFirmwareVers : UINT; (*Version der Firmware*)
	END_STRUCT;
	mnSystem_SignalIn_typ : 	STRUCT 
		xIn : ARRAY[1..12]OF BOOL;
		iIn : ARRAY[1..4]OF INT;
	END_STRUCT;
	mnSystem_SignalOut_typ : 	STRUCT 
		xOut : ARRAY[1..12]OF BOOL;
		iOut : ARRAY[1..4]OF INT;
	END_STRUCT;
END_TYPE

(*Parameter*)

TYPE
	mnSystemPar_typ : 	STRUCT 
		Cfg : mnSystemParCfg_typ;
		Mac : mnSystemParMac_typ;
	END_STRUCT;
	mnSystemParMac_typ : 	STRUCT 
		wWarnTemperatureEnvironment : UINT := 750; (*Warnschwelle für Temperaturüberwachung in 0,1 °C*)
	END_STRUCT;
	mnSystemParCfgLine_typ : 	STRUCT 
		wModuleID : ARRAY[1..MNSYSTEM_CNT_MODULES]OF UINT;
		sName : ARRAY[1..MNSYSTEM_CNT_MODULES]OF STRING[13];
	END_STRUCT;
	mnSystemParCfg_typ : 	STRUCT 
		Lines : ARRAY[1..MNSYSTEM_CNT_MODULELINES]OF mnSystemParCfgLine_typ;
		BindingWarnEnvTemp : ARRAY[1..2]OF mnSystemMdlBinding_typ;
		BindingMotProtCooling : ARRAY[1..2]OF mnSystemMdlBinding_typ;
		BindingOutCooling : ARRAY[1..2]OF mnSystemMdlBinding_typ;
		sSwitchBoxName : ARRAY[1..2]OF STRING[13];
	END_STRUCT;
	mnSystemMdlBinding_typ : 	STRUCT 
		wBindIndexModul : UINT; (*Gibt an, welches Modul verwendet wird*)
		wBindIndexChannel : UINT; (* Gibt an, welcher Platz auf dem Modul verwendet wird*)
		sDiscription : STRING[13];
		xInvers : BOOL; (*Invertiertes Eingangssignal*)
	END_STRUCT;
END_TYPE
