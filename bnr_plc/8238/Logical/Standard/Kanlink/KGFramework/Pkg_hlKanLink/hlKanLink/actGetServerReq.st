(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: hlKanLink
 * File: actGetServerReq.st
 * Author: stahlhut
 * Created: April 01, 2015
 ********************************************************************
 * Implementation of program hlKanLink
 ********************************************************************) 

(* Kanlink Server/Request bearbeiten *)
ACTION actGetServerReq: 

		Kanlink.MuServerListe.bMuServerIdx := 0;
		FOR _k := 0 TO KLLIB_MAX_MUL DO
			Kanlink.MuServerListe.Servers[_k] := -1;
			Kanlink.MuServerListe.MuServer[_k] := -1;
		END_FOR

		FOR _k := 0 TO KLLIB_MAX_MUL DO
		
			IF ((Kanlink.ServerData.HeaderV1Rec[_k].Command = 0) AND (Kanlink.ServerData.HeaderV1Rec[_k].ReqID = 0)) THEN
				EXIT;
			END_IF
			
			// Commandos unter 1000 sind für alle gleich:
			IF Kanlink.ServerData.HeaderV1Rec[_k].Command < 1000 THEN 

				CASE Kanlink.ServerData.HeaderV1Rec[_k].Command OF
					0:   // MaschinenInfo Senden: Darf jeder lesen
					
						Kanlink.ServerData.HeaderV1Send[_k].Command := 1;
						Kanlink.ServerData.HeaderV1Send[_k].dataFormat := 5;
						Kanlink.ServerData.HeaderV1Send[_k].Length := 74;
						Kanlink.ServerData.HeaderV1Send[_k].Tag := Kanlink.ServerData.HeaderV1Rec[_k].Tag;
						Kanlink.ServerData.HeaderV1Send[_k].ReqID := Kanlink.ServerData.HeaderV1Rec[_k].ReqID;

						IF (Kanlink.ServerData.PreHeaderRec.HeaderVersion = 16#0101) THEN
							Kanlink.MuServerListe.Servers[_k]:= 32000;
							_sClientIPAdr := Kanlink.client_address;
						ELSE
							KLLib_SendData(ADR(Kanlink),ADR(Kanlink.ServerData.MetaInfoResp),74,ADR(Kanlink.client_address), -1,      -1,KLLIB_RESP);
							_iIdxFound := 32000;
						END_IF		
					
					2:   // Response Ping: Darf jeder lesen
				
						Kanlink.ServerData.HeaderV1Send[_k].Command := 3;
						Kanlink.ServerData.HeaderV1Send[_k].dataFormat := 5;
						Kanlink.ServerData.HeaderV1Send[_k].Length := 17;
						Kanlink.ServerData.HeaderV1Send[_k].Tag := Kanlink.ServerData.HeaderV1Rec[_k].Tag;
						Kanlink.ServerData.HeaderV1Send[_k].ReqID := Kanlink.ServerData.HeaderV1Rec[_k].ReqID;

						IF (Kanlink.ServerData.PreHeaderRec.HeaderVersion = 16#0101) THEN
							Kanlink.MuServerListe.Servers[_k]:= 32000;
							_sClientIPAdr := Kanlink.client_address;
						ELSE
							KLLib_SendData(ADR(Kanlink),ADR(Kanlink.ServerData.PingResp),17,ADR(Kanlink.client_address), -1,      -1,KLLIB_RESP);
							_iIdxFound := 32000;
						END_IF	

				END_CASE;

			ELSE
				// >= 1000 sind spezifische Daten
			
				// Anfrage Konfiguriert?
				// Zur Anfrage Verbindung raussuchen..	
				_xIdxFound := FALSE;
				_iIdxFound := 32000;
			
				KL_BuildKey(Command := Kanlink.ServerData.HeaderV1Rec[_k].Command,CmdNr := UINT_TO_USINT( Kanlink.ServerData.HeaderV1Rec[_k].CmdNr AND 16#00FF) ,IPAdr := Kanlink.ServerData.IPAdr, adrKey:= ADR(Kanlink.RecKey));
				FOR _i := 0 TO HLKANLINK_MAX_SERVERCONNS  DO 
	
					_ptrIndex ACCESS ADR(Kanlink.ServerListe[_i]);
					_dSrvIf ACCESS _ptrIndex.adrInterface;
					IF _ptrIndex.Adr = 0 THEN // wenn alle das Commando lesen dürfen/ Adresse und Area ausblenden
						IF Kanlink.RecKey.CmdKey = _ptrIndex.Key.CmdKey THEN // Index gefunden, beantworten: 
							_xIdxFound := TRUE;
							_iIdxFound := _i;
							Kanlink.MuServerListe.Servers[_k] := _i;
							EXIT;
						END_IF;						
					ELSE
						IF (Kanlink.RecKey.CmdKey = _ptrIndex.Key.CmdKey) AND (Kanlink.RecKey.IP_Key = _ptrIndex.Key.IP_Key) THEN // Index gefunden, beantworten: 
							_xIdxFound := TRUE;
							_iIdxFound := _i;
							Kanlink.MuServerListe.Servers[_k]:= _i;
							EXIT;
						END_IF;
					END_IF;	
				END_FOR

				IF (_k > 0) THEN
					FOR _i := 0 TO (_k - 1) DO 
						IF (Kanlink.MuServerListe.Servers[_i] = Kanlink.MuServerListe.Servers[_k]) THEN
							Kanlink.MuServerListe.MuServer[_k] := USINT_TO_INT(Kanlink.MuServerListe.bMuServerIdx);
							Kanlink.MuServerListe.bMuServerIdx := Kanlink.MuServerListe.bMuServerIdx + 1;
							IF (Kanlink.MuServerListe.MuServer[_k] = 0) THEN
								Kanlink.MuServerListe.AdrRespData[Kanlink.MuServerListe.MuServer[_k]] := ADR(Kanlink.MuServerListe.RespData);
							ELSE
								Kanlink.MuServerListe.AdrRespData[Kanlink.MuServerListe.MuServer[_k]] := Kanlink.MuServerListe.AdrRespData[Kanlink.MuServerListe.MuServer[_k] - 1] + Kanlink.MuServerListe.lRespLength[Kanlink.MuServerListe.MuServer[_k] - 1];
							END_IF
							EXIT;
						END_IF
					END_FOR
				END_IF

				_xAdrErr := (_ptrIndex.AdrDataReq = 0) OR (_ptrIndex.AdrDataResp = 0);
			
				IF (_xIdxFound = FALSE) OR _xAdrErr THEN // Falls keine gültige Verbindung dann Fehlerframe senden
					// Fehlerframe senden:
					Kanlink.ServerData.HeaderV1Send[_k].Command := Kanlink.ServerData.HeaderV1Rec[_k].Command +1;
					Kanlink.ServerData.HeaderV1Send[_k].dataFormat := 255;
					Kanlink.ServerData.HeaderV1Send[_k].Length := 68;
					Kanlink.ServerData.HeaderV1Send[_k].Tag := Kanlink.ServerData.HeaderV1Rec[_k].Tag;
					Kanlink.ServerData.HeaderV1Send[_k].ReqID := Kanlink.ServerData.HeaderV1Rec[_k].ReqID;
	
					// Error Frame: 
					Kanlink.ServerData.ErrorFrame.ErrorNumber := 2;
					strcpy(ADR(Kanlink.ServerData.ErrorFrame.ErrorText),ADR('request not supported'));
	
				ELSE
					// Empfangene Daten speichern:
					
					IF NOT( (_dSrvIf.iState <> 0) AND _ptrIndex.xReqManually) THEN  // falls Req bereits bearbeitet wird verwerfen
						_ptrIndex.iReqCnt := _ptrIndex.iReqCnt + 1;
						_dSrvIf.iState := 1; 
						strcpy(ADR(_ptrIndex.sClientIPAdr),ADR(Kanlink.client_address));
						_sClientIPAdr := Kanlink.client_address;
						// todo längenüberprüfung _ptrIndex.ReqLength
						IF (_k = 0) THEN
							memcpy(_ptrIndex.AdrDataReq,ADR(Kanlink.ServerData.receive_data) + PreHeaderSize + HeaderSize,_ptrIndex.ReqLength);
						ELSE
							memcpy(_ptrIndex.AdrDataReq,ADR(Kanlink.ServerData.receive_data) + Kanlink.MuServerListe.wOffset[_k] + HeaderSize,_ptrIndex.ReqLength);
						END_IF
		
						_ptrIndex.iReqID := Kanlink.ServerData.HeaderV1Rec[_k].ReqID;
						_dSrvIf.out.tag	:= Kanlink.ServerData.HeaderV1Rec[_k].Tag;

						IF (_ptrIndex.CmdOpt AND KL_optOnReqCall) <> 0 THEN 
							IF (Kanlink.MuServerListe.MuServer[_k] < 0) THEN
								KL_OnRecReq(adrReqData := _ptrIndex.AdrDataReq, adrRespData := _ptrIndex.AdrDataResp, adrKanlink := ADR(Kanlink),_ptrIndex.Cmd, adrUserData := IFhlKanLink.Parameter.adrUserTyp);
							ELSE
								KL_OnRecReq(adrReqData := _ptrIndex.AdrDataReq, adrRespData := Kanlink.MuServerListe.AdrRespData[Kanlink.MuServerListe.MuServer[_k]], adrKanlink := ADR(Kanlink),_ptrIndex.Cmd, adrUserData := IFhlKanLink.Parameter.adrUserTyp);
								Kanlink.MuServerListe.lRespLength[Kanlink.MuServerListe.MuServer[_k]] := _ptrIndex.RespLength;
							END_IF
						END_IF;	
						IF _ptrIndex.xReqManually = 0 THEN 
	
							Kanlink.ServerData.HeaderV1Send[_k].Command := _ptrIndex.Cmd + 1;
							Kanlink.ServerData.HeaderV1Send[_k].dataFormat := 5;
							Kanlink.ServerData.HeaderV1Send[_k].Length := UDINT_TO_UINT( _ptrIndex.RespLength);
							Kanlink.ServerData.HeaderV1Send[_k].ReqID := _ptrIndex.iReqID;
							Kanlink.ServerData.HeaderV1Send[_k].CmdNr := _ptrIndex.CmdOpt AND 16#00FF;
							Kanlink.ServerData.HeaderV1Send[_k].Tag	:= _dSrvIf.tag;
							_ptrIndex.iConnectionTimer := 0;
						END_IF;	
					END_IF;	
				
				END_IF;	
				
			END_IF;		

		END_FOR

		IF (Kanlink.ServerData.PreHeaderRec.HeaderVersion = 16#0101) THEN
			KLLib_SendData(ADR(Kanlink),0,0,ADR(_sClientIPAdr),-1,0,KLLIB_RESP);
		ELSIF (_iIdxFound <> 32000) THEN
			KLLib_SendData(ADR(Kanlink),_ptrIndex.AdrDataResp,_ptrIndex.RespLength,ADR(_ptrIndex.sClientIPAdr), -1,      -1,KLLIB_RESP);
		END_IF

END_ACTION