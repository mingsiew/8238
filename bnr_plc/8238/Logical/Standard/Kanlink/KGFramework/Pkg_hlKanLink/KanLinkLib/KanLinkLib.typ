(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: WetLinkLib
 * File: WetLinkLib.typ
 * Author: stahlhut
 * Created: January 06, 2012
 ********************************************************************
 * Data types of library WetLinkLib
 ********************************************************************)
(*Interne Strukturen*)

TYPE
	udp_typ : 	STRUCT  (*UDP Typ*)
		open : UdpOpen;
		send : UdpSend;
		rec : UdpRecv;
		close : UdpClose;
	END_STRUCT;
	udint_array_typ : 	STRUCT  (*Casten von UDINT -> byte*)
		a : USINT;
		b : USINT;
		c : USINT;
		d : USINT;
	END_STRUCT;
	ServerDataTyp : 	STRUCT  (*Datatyp for global Variables*)
		receive_data : ARRAY[0..8191]OF USINT; (*Data which has been received*)
		send_data : ARRAY[0..8191]OF USINT; (*Data which should be sent*)
		PreHeaderSend : PreHeader_Typ;
		PreHeaderRec : PreHeader_Typ;
		HeaderV1Send : ARRAY[0..KLLIB_MAX_MUL]OF HeaderV1_Typ;
		HeaderV1Rec : ARRAY[0..KLLIB_MAX_MUL]OF HeaderV1_Typ;
		MetaInfoResp : KLresp0_MetaInfo_typ;
		ErrorFrame : KL_Error_Frame_typ;
		PingReq : KLreq2_Ping_typ;
		PingResp : KLresp2_Ping_typ;
		IPAdr : STRING[16]; (*IP-Adresse des Clients*)
	END_STRUCT;
	PreHeader_Typ : 	STRUCT 
		Magic : UDINT; (*MagicNr*)
		HeaderVersion : UINT; (*Headerversion*)
		Tag : UINT; (*Reserve*)
	END_STRUCT;
	HeaderV1_Typ : 	STRUCT 
		ReqID : UINT;
		dataFormat : UINT;
		Command : UINT;
		Length : UINT;
		CmdNr : UINT;
		CmdTag : UINT; (*Unterschiedliche Parameter zum Command*)
		Tag : UDINT; (*Reserve/Spezial*)
	END_STRUCT;
	KL_ServerListe_typ : 	STRUCT 
		Cmd : UINT;
		CmdOpt : UINT;
		Adr : UINT;
		Area : UINT;
		pRespStr : UDINT; (*Adresse des Resp String*)
		pReqStr : UDINT; (*Adresse des Req String*)
		AdrDataReq : UDINT;
		ReqLength : UDINT; (*Länge Request Daten*)
		AdrDataResp : UDINT;
		RespLength : UDINT; (*Länge Response Daten*)
		Key : KL_Key_typ; (*Suchschlüssel/ Darf nicht doppelt vorkommen== Konfigurierungsfehler*)
		xConnected : BOOL; (*Falls Commando 2s nicht angefragt wird ist verbindung unterbrochen*)
		iConnectionTimer : UINT; (*Der Zugehörige Zähler / Timer*)
		adrParameter : UDINT; (*Adresse der Parameter*)
		sServerIPAdr : STRING[16];
		sClientIPAdr : STRING[16];
		iReqCnt : UINT;
		xReqManually : BOOL;
		iReqID : UINT;
		iCfgStatus : UINT;
		adrInterface : UDINT;
		xActiv : BOOL;
		tag : UDINT;
	END_STRUCT;
	KL_MuServerListe_typ : 	STRUCT 
		Servers : ARRAY[0..KLLIB_MAX_MUL]OF INT;
		wOffset : ARRAY[0..KLLIB_MAX_MUL]OF UINT;
		MuServer : ARRAY[0..KLLIB_MAX_MUL]OF INT;
		lRespLength : ARRAY[0..KLLIB_MAX_MUL]OF UDINT;
		AdrRespData : ARRAY[0..KLLIB_MAX_MUL]OF UDINT;
		RespData : ARRAY[0..8191]OF USINT; (*Data which should be sent*)
		bMuServerIdx : USINT;
	END_STRUCT;
	KL_MuClientListe_typ : 	STRUCT 
		bUse : USINT; (*1 = Multiclient aktiv, 2 = Multiclient wurde noch nicht geprüft, 255 = Server akzeptiert kein Multiclient*)
		Clients : ARRAY[0..KLLIB_MAX_MUL]OF INT;
		sClientAdr : STRING[16];
		iCycleTime : UINT;
		iCnt : UINT;
		iReqId : UINT;
		TimeOut : UINT;
		iTimeOutCnt : UINT;
		iCycleWait : UINT;
		xReqPending : BOOL;
		xActiv : BOOL;
		iTimeOutCnt_Summe : UINT;
		TimeOutLeft : UINT;
		xConnected : BOOL; (*True wenn Verbindung aktiv und läuft*)
		Length : UINT;
		RespLength : UDINT;
		ReqLength : UDINT;
	END_STRUCT;
	KL_ClientListe_typ : 	STRUCT 
		RecCmd : UINT; (*Rec Command nr*)
		Cmd : UINT; (*Send Command nr*)
		CmdOpt : UINT; (*SendeOptionen Senden Nr des Commando etc*)
		Adr : UINT;
		Area : UINT;
		Key : KL_Key_typ;
		pResp : UDINT; (*Adresse des Namen der Response Struktur*)
		pReq : UDINT; (*Adresse des Namen der Request Struktur*)
		AdrDataReq : UDINT;
		AdrDataResp : UDINT;
		ReqLength : UDINT;
		RespLength : UDINT;
		TimeOut : UINT;
		TimeOutLeft : UINT;
		xError : BOOL;
		iCycleWait : UINT;
		iCycleTime : UINT;
		xDataRec : BOOL;
		MuClient : SINT; (*Enthalten im Multiclient*)
		iReqId : UINT;
		sClientAdr : STRING[16];
		xReqPending : BOOL;
		iTimeOutCnt : UINT;
		xActiv : BOOL;
		iCnt : UINT;
		xConnected : BOOL; (*True wenn Verbindung aktiv und läuft*)
		iTimeOutCnt_Summe : UINT;
		adrInterface : UDINT;
		adrParameter : UDINT; (*Adresse der Parameter*)
		recTag : UDINT; (*Tag des Kommandos*)
	END_STRUCT;
END_TYPE

(*Kommandos*)

TYPE
	KL_Error_Frame_typ : 	STRUCT 
		Version : UINT;
		ErrorNumber : UINT;
		ErrorText : STRING[63];
	END_STRUCT;
	KLresp0_MetaInfo_typ : 	STRUCT 
		KanLink_Hostname : STRING[15];
		Machine_type : STRING[15];
		SoftwareNo : STRING[15];
		SoftwareVersion : STRING[15];
		DataModelTimeStamp : DATE_AND_TIME;
		DataModelVersion : UINT;
		TimeZone : UINT;
		SommerTime : UINT;
	END_STRUCT;
	KLreq2_Ping_typ : 	STRUCT 
		KanLink_Hostname : STRING[15];
	END_STRUCT;
	KLresp2_Ping_typ : 	STRUCT 
		KanLink_Hostname : STRING[15];
		FrameVersion : USINT;
	END_STRUCT;
	BatchData_typ : 	STRUCT 
		dtTimeStamp : DATE_AND_TIME;
		bTypeBatchNo : USINT;
		bCntCustomers : USINT;
		wTotalWeight : UINT;
		bBatchNo : ARRAY[0..15]OF USINT;
		sCategory : STRING[11];
		utfMark : ARRAY[0..31]OF UINT;
		bCustom : ARRAY[0..11]OF USINT;
		PartBatch : ARRAY[0..7]OF PartBatchData_typ;
	END_STRUCT;
	PartBatchData_typ : 	STRUCT 
		sCustomNo : STRING[11];
		wCustomWeight : UINT;
	END_STRUCT;
END_TYPE
