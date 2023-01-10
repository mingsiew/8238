(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * File: KG_Cmd.typ
 * Author: hunholz
 * Created: Feb 29, 2012
 ********************************************************************
 * Global data types of KGFramework
 ********************************************************************)

TYPE
	KG_Cmd_typ : 	STRUCT 
		Response : KG_CmdResponse_typ; (*Wird vom verantwortlichen SPS-Package beschrieben*)
		Request : KG_CmdRequest_typ; (*Wird nur von "au�erhalb" beschrieben*)
	END_STRUCT;
	KG_CmdRequest_typ : 	STRUCT 
		Command : KG_Command_typ; (*Kommando mit Attributen. Zus�tzliche Attribute werden �ber eine zus�tzliche Struktur �bergeben.*)
	END_STRUCT;
	KG_CmdResponse_typ : 	STRUCT 
		wCmdStatus : UINT; (*R�ckgabewert. 0 - NoCommand, 1..59999 - R�ckgabe des Kommandowertes bei erfolgreichem Abschluss, 60000..65534 - Fehler, 65535 - Busy*)
		wLockStatus : UINT; (*0 - Kommandokanal ist frei, Clientnummer des Clients, der den Kommandokanal blockiert hat*)
	END_STRUCT;
	KG_Command_typ : 	STRUCT 
		wCommand : UINT; (*0 - kein Kommando, 1..59999 - G�ltige Kommandonummer*)
		lData0 : UDINT; (*beliebig, entsprechend des Kommandos*)
		lData1 : UDINT; (*beliebig, entsprechend des Kommandos*)
	END_STRUCT;
END_TYPE
