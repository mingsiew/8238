(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: WetLinkLib
 * File: WLLib_SendData.st
 * Author: stahlhut
 * Created: January 07, 2012
 * changed April 2015
 ********************************************************************
 * 
 ********************************************************************) 




FUNCTION KLLib_SendData
	IF Srv.udp.send.enable = TRUE THEN //Sendung noch unterwegs, abbrechen
 		KLLib_SendData := 1;
		RETURN;
	END_IF;
	
	Srv.ServerData.PreHeaderSend.Magic := MagicNr;
	IF (iMuIndex >= 0) AND (bMode <> 0) THEN
		Srv.ServerData.PreHeaderSend.HeaderVersion := 16#0101;
	ELSE
		Srv.ServerData.PreHeaderSend.HeaderVersion := 16#0100;
	END_IF
	Srv._offset := 0;
	memcpy(ADR(Srv.ServerData.send_data),ADR(Srv.ServerData.PreHeaderSend),PreHeaderSize);
	Srv._offset := PreHeaderSize;
	
	IF (iIndex >= 0) AND (bMode <> 0) THEN
		memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,ADR(Srv.ServerData.HeaderV1Send[0]),HeaderSize);
		Srv._offset := Srv._offset+ HeaderSize;
		IF (bMode <> KLLIB_REQ) THEN
			memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,Srv.ClientListe[iIndex].AdrDataReq,Srv.ClientListe[iIndex].ReqLength);
		ELSIF (bMode <> KLLIB_RESP) THEN
			memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,Srv.ServerListe[iIndex].AdrDataResp,Srv.ServerListe[iIndex].RespLength);
		END_IF
		Srv._SendLen := Srv._offset + Srv.ServerData.HeaderV1Send[0].Length;
	ELSIF (iMuIndex >= 0) AND (bMode = KLLIB_REQ) THEN
		Srv._SendLen := PreHeaderSize;
		FOR _i := 0 TO KLLIB_MAX_MUL DO  
			IF (Srv.MuClientListe[iMuIndex].Clients[_i] >= 0) THEN
				memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,ADR(Srv.ServerData.HeaderV1Send[_i]),HeaderSize);
				Srv._offset := Srv._offset + HeaderSize;
				Srv._SendLen := Srv._SendLen + HeaderSize;
				memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,Srv.ClientListe[Srv.MuClientListe[iMuIndex].Clients[_i]].AdrDataReq,Srv.ClientListe[Srv.MuClientListe[iMuIndex].Clients[_i]].ReqLength);
				Srv._offset := Srv._offset+ Srv.ClientListe[Srv.MuClientListe[iMuIndex].Clients[_i]].ReqLength;
				Srv._SendLen := Srv._SendLen + Srv.ClientListe[Srv.MuClientListe[iMuIndex].Clients[_i]].ReqLength;
				Srv.MuClientListe[iMuIndex].Length := UDINT_TO_UINT(Srv._SendLen);
			ELSE
				EXIT;		
			END_IF
		END_FOR
	ELSIF (iMuIndex >= 0) AND (bMode = KLLIB_RESP) THEN
		Srv._SendLen := PreHeaderSize;
		FOR _i := 0 TO KLLIB_MAX_MUL DO  
			IF (Srv.MuServerListe.Servers[_i] >= 0) THEN
				memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,ADR(Srv.ServerData.HeaderV1Send[_i]),HeaderSize);
				Srv._offset := Srv._offset + HeaderSize;
				Srv._SendLen := Srv._SendLen + HeaderSize;
				IF Srv.ServerData.HeaderV1Rec[_i].Command < 1000 THEN 
					CASE Srv.ServerData.HeaderV1Rec[_i].Command OF
						0:   // MaschinenInfo Senden: Darf jeder lesen
						
							memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,ADR(Srv.ServerData.MetaInfoResp),74);
							Srv._offset := Srv._offset + 74;
							Srv._SendLen := Srv._SendLen + 74;
					
						2:   // Response Ping: Darf jeder lesen
					
							memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,ADR(Srv.ServerData.PingResp),17);
							Srv._offset := Srv._offset + 17;
							Srv._SendLen := Srv._SendLen + 17;
	
					END_CASE;

				ELSIF (Srv.MuServerListe.Servers[_i] <> 32000) THEN
					IF (Srv.MuServerListe.MuServer[_i] < 0) THEN
						memcpy(ADR(Srv.ServerData.send_data) + Srv._offset,Srv.ServerListe[Srv.MuServerListe.Servers[_i]].AdrDataResp,Srv.ServerListe[Srv.MuServerListe.Servers[_i]].RespLength);
						Srv._offset := Srv._offset + Srv.ServerListe[Srv.MuServerListe.Servers[_i]].RespLength;
						Srv._SendLen := Srv._SendLen + Srv.ServerListe[Srv.MuServerListe.Servers[_i]].RespLength;
					ELSE
						memcpy(ADR(Srv.ServerData.send_data) + Srv._offset,Srv.MuServerListe.AdrRespData[Srv.MuServerListe.MuServer[_i]],Srv.MuServerListe.lRespLength[Srv.MuServerListe.MuServer[_i]]);
						Srv._offset := Srv._offset + Srv.MuServerListe.lRespLength[Srv.MuServerListe.MuServer[_i]];
						Srv._SendLen := Srv._SendLen + Srv.MuServerListe.lRespLength[Srv.MuServerListe.MuServer[_i]];
					END_IF
				END_IF
			END_IF
		END_FOR
	ELSE
		memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,ADR(Srv.ServerData.HeaderV1Send[0]),HeaderSize);
		Srv._offset := Srv._offset+ HeaderSize;
		memcpy(ADR(Srv.ServerData.send_data)+Srv._offset,SendAdr,SendLen);
		Srv._SendLen := Srv._offset + Srv.ServerData.HeaderV1Send[0].Length;
	END_IF

	// Telegramm jetzt senden
	Srv.udp.send.enable := 1;
	Srv.udp.send.ident 	:= Srv.udp.open.ident;	(* Client Ident from AsUDP.UDP_Open *)
	Srv.udp.send.pHost 	:= pDestination;	(* IP Address of the Client *)
	Srv.udp.send.port 	:= Srv.iPort;
	Srv.udp.send.pData 	:= ADR(Srv.ServerData.send_data);	(* Which data to send *)
	Srv.udp.send.datalen :=  Srv._SendLen; //
	Srv.udp.send.flags 	:= 0;
	Srv.udp.send ;	(* Call the Function*)
	
	
		
END_FUNCTION
