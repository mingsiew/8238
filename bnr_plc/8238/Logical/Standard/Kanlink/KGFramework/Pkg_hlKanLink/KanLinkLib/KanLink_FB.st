(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: Kanlink
 * File: 
 * Author: stahlhut
 * Created: January 06, 2012
 ********************************************************************
 * Implementation of library Kanlink

29.8.2012 Bug behoben verunden recAdr mit 0x0F


 ********************************************************************) 


FUNCTION_BLOCK KanLink_FB
	   
	xReturn := 0;
	
	IF Step <> 10 THEN 
		xReturn := 1;
		RETURN;
	END_IF;	
	KLLib_ClientTimer(adrSelf,_iCycleTime);
	 
	
	IF  udp.send.enable THEN 
		udp.send; 

		IF  udp.send.status = 0 THEN  
			udp.send.enable := FALSE;
		ELSIF udp.send.status = ERR_FUB_BUSY THEN  
			udp.send.enable := TRUE;
			xReturn := 1;
			RETURN;
		ELSE  
			ErrorNr := 4;
			udp.send.enable := FALSE;
		END_IF
	END_IF;
 
	udp.rec.enable := 1;
	udp.rec.ident := udp.open.ident;
	udp.rec.pData := ADR(ServerData.receive_data);	// Datenspeicher
	udp.rec.datamax := SIZEOF(ServerData.receive_data);	// Länge des Datenspeichers
	udp.rec.flags := 0;
	udp.rec.pIpAddr := ADR(client_address);	// IP Adresse des Senders
	udp.rec;	

	IF udp.rec.status = 0 THEN  // Daten empfangen
		// Header Daten kopieren
		_dPrehead ACCESS ADR(ServerData.receive_data);
		_dHead ACCESS ADR(ServerData.receive_data) + PreHeaderSize;
		memcpy(ADR(ServerData.PreHeaderRec),ADR(ServerData.receive_data),PreHeaderSize);
		memset(ADR(ServerData.HeaderV1Rec),0,SIZEOF(ServerData.HeaderV1Rec));
		memcpy(ADR(ServerData.HeaderV1Rec[0]),ADR(ServerData.receive_data)+PreHeaderSize,SIZEOF(ServerData.HeaderV1Rec[0]));
	
		ServerData.IPAdr := client_address;
	
		_xPreheadOK := (ServerData.PreHeaderRec.Magic = MagicNr);
		_xVersionOK := (ServerData.PreHeaderRec.HeaderVersion = 16#100) OR (ServerData.PreHeaderRec.HeaderVersion = 16#101);
	
		IF (_dHead.Command AND 1) = 0 THEN 
			_xGetServerReq := TRUE;
		ELSIF (_dHead.Command AND 1) = 1 THEN 
			_xGetClientResp := TRUE;
		END_IF;					 
	
		IF (ServerData.PreHeaderRec.HeaderVersion = 16#101) THEN
			brsmemset(ADR(MuServerListe.wOffset),0,SIZEOF(MuServerListe.wOffset));
			brsmemset(ADR(MuServerListe.Servers),0,SIZEOF(MuServerListe.Servers));
			FOR _i := 1 TO KLLIB_MAX_MUL DO
				IF (_i = 1) THEN
					MuServerListe.wOffset[_i] := ServerData.HeaderV1Rec[_i - 1].Length + UDINT_TO_UINT(PreHeaderSize) + UDINT_TO_UINT(HeaderSize);
				ELSE
					MuServerListe.wOffset[_i] := MuServerListe.wOffset[_i - 1] + ServerData.HeaderV1Rec[_i - 1].Length + UDINT_TO_UINT(HeaderSize);
				END_IF
				IF (udp.rec.recvlen < (UINT_TO_UDINT(MuServerListe.wOffset[_i]) + HeaderSize)) THEN
					EXIT;
				END_IF
				memcpy(ADR(ServerData.HeaderV1Rec[_i]),ADR(ServerData.receive_data)+MuServerListe.wOffset[_i],SIZEOF(ServerData.HeaderV1Rec[_i]));
				IF (((ServerData.HeaderV1Rec[_i].Command = 0) AND (ServerData.HeaderV1Rec[_i].ReqID = 0)) OR ((ServerData.HeaderV1Rec[_i].Length = 0) AND (ServerData.HeaderV1Rec[_i].ReqID = 0))) THEN
					EXIT;
				END_IF
			END_FOR
		END_IF

	ELSIF udp.rec.status = udpERR_NO_DATA THEN  // Keine Daten empfangen, Client abarbeiten
		_xSendClient := TRUE;
	ELSIF udp.rec.status = ERR_FUB_BUSY THEN  (* UdpRecv not finished -> redo *)					
		xReturn := 1;
		RETURN;
	ELSE  (* Goto Error Step *)
		ErrorNr := 5; 
		xReturn := 1;
		RETURN;
	END_IF
	
	// dieser teil ist nur für den Linker (unused Variable)
	IF _xUse THEN
		_udArr;
		_dRecAdr;
		RecKey := RecKey;
		sNetID := sNetID;
		udNetID := udNetID;
		ServerListe := ServerListe; 
		ClientListe	:= ClientListe;
		MuClientListe;
		_xOpenPort := _xOpenPort; 
		_uiLastId	:= _uiLastId; 
		CanReturn	:= CanReturn; 
		_offset 	:= _offset; 
		_SendLen	:= _SendLen; 
		DoCommand	:= DoCommand; 
	 	adrInterface	:= adrInterface;
		iPort 	:= iPort; 
		sIF	:= sIF; 
		KLLib_Init_0.enable	:= KLLib_Init_0.enable;
		CfgClient.adrKanlink	:= CfgClient.adrKanlink;
		CfgServer.adrKanlink	:= CfgServer.adrKanlink; 
	END_IF; 

END_FUNCTION_BLOCK
