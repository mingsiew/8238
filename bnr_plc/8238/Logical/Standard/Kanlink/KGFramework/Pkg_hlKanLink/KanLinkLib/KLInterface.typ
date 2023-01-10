(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: Kanlink	 Interface
 * File: 
 * Author: stahlhut
 * Created: 20.03.2012
 ********************************************************************
 * Data types of Interface Kanlink
 ********************************************************************)

TYPE
	KL_Key_typ : 	STRUCT 
		IP_Key : UDINT;
		CmdKey : UDINT;
	END_STRUCT;
	KL_Parameter_typ : 	STRUCT 
		Server : ARRAY[0..HLKANLINK_MAX_SERVERCONNS] OF KL_ServerPar_typ;
		Client : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS] OF KL_ClientPar_typ;
		adrUserTyp : UDINT;
	END_STRUCT;
	KL_ClientPar_typ : 	STRUCT 
		Name : STRING[15];
		Adr : UINT;
		Cmd : UINT;
		CmdOpt : UINT; (*Bits 0..3 = Nummer des Clients*)
		Area : UINT;
		CycleTime : UINT;
		sReq : STRING[80];
		sResp : STRING[80];
		AdvMode : BOOL; (*Modus mit dem eine vollständige IP-Adresse eingegeben werden kann*)
		AdrAdvMode : STRING[16]; (*Vollständige IP-Adresse*)
	END_STRUCT;
	KL_ServerPar_typ : 	STRUCT 
		Name : STRING[15];
		Adr : UINT;
		Cmd : UINT;
		CmdOpt : UINT; (*Bits 0..3 = Nummer der Verbindung*)
		Area : UINT;
		TimeOut : UINT;
		sReq : STRING[80];
		sResp : STRING[80];
		AdvMode : BOOL; (*Modus mit dem eine vollständige IP-Adresse eingegeben werden kann
oder die Prüfung der IP-Adresse entfällt.*)
		AdrAdvMode : STRING[16]; (*Vollständige IP-Adresse*)
	END_STRUCT;
	IF_ServerOutTyp : 	STRUCT 
		xConnected : BOOL;
		iCfgState : UINT; (*0 = ConfOK*)
		tag : UDINT;
	END_STRUCT;
	IF_Server_typ : 	STRUCT 
		iState : UINT;
		out : IF_ServerOutTyp;
		tag : UDINT;
	END_STRUCT;
	IF_ClientOut_typ : 	STRUCT 
		xConnected : BOOL;
		recTag : UDINT;
	END_STRUCT;
	IF_Client_typ : 	STRUCT 
		out : IF_ClientOut_typ;
		iState : UINT;
		tag : UDINT;
	END_STRUCT;
	IFhlKanLink_Typ : 	STRUCT 
		in : IF_KL_Control_in_typ;
		out : IF_KL_Control_out_typ;
		Server : ARRAY[0..HLKANLINK_MAX_SERVERCONNS] OF IF_Server_typ;
		Client : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS] OF IF_Client_typ;
		Parameter : KL_Parameter_typ;
		xError : BOOL; (*Kanlink in Störung*)
	END_STRUCT;
	IF_KL_Control_in_typ : 	STRUCT 
		xRun : BOOL; (*Rise= Starten Kanlink /fall = stoppen Kanlink*)
		xRestart : BOOL;
	END_STRUCT;
	IF_KL_Control_out_typ : 	STRUCT 
		iError : UINT;
		iServerError : ARRAY[0..HLKANLINK_MAX_SERVERCONNS] OF UINT;
		iClientError : ARRAY[0..HLKANLINK_MAX_CLIENTCONNS] OF UINT;
		iStep : UINT; (*Statemachine KanLink*)
	END_STRUCT;
	IFhlKLVisuIN_typ : 	STRUCT 
		cmdNr : INT; (*Ausführbares Commando*)
		cmdTag : INT; (*Dazugehörige Daten*)
		iServerNr : UINT; (*zu lesende Serverlist*)
		iCltNr : UINT; (*zu lesender Client*)
	END_STRUCT;
	IFhlKLVisuOUT_typ : 	STRUCT 
		step : UINT;
		udpOpenStatus : UINT;
		udpSendStatus : UINT;
		udpRecStatus : UINT;
		iCycleTime : UINT;
		udNetId : UDINT;
		server : KL_ServerListe_typ;
		client : KL_ClientListe_typ;
		cmdResp : INT; (*Response auf CmdNr*)
	END_STRUCT;
	IFhlKLVisu_typ : 	STRUCT 
		in : IFhlKLVisuIN_typ;
		out : IFhlKLVisuOUT_typ;
	END_STRUCT;
END_TYPE
