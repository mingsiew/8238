(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: hlKanLink
 * File: actResponse.st
 * Author: stahlhut
 * Created: April 01, 2015
 ********************************************************************
 * Implementation of program hlKanLink
 ********************************************************************) 

(* Response eines Servers bearbeiten *)
ACTION actResponse: 

		FOR _k := 0 TO KLLIB_MAX_MUL DO
			Kanlink.MuServerListe.Servers[_k] := -1;
		END_FOR
		
		FOR _k := 0 TO KLLIB_MAX_MUL DO

			IF ((Kanlink.ServerData.HeaderV1Rec[_k].Command = 0) AND (Kanlink.ServerData.HeaderV1Rec[_k].ReqID = 0)) THEN
				EXIT;
			END_IF
			
			KL_BuildKey(Command := Kanlink.ServerData.HeaderV1Rec[_k].Command,CmdNr := UINT_TO_USINT( Kanlink.ServerData.HeaderV1Rec[_k].CmdNr AND 16#00FF) ,IPAdr := Kanlink.ServerData.IPAdr, adrKey:= ADR(Kanlink.RecKey));
		
			_xIdxFound := FALSE;
			FOR _i := 0 TO HLKANLINK_MAX_CLIENTCONNS DO 
				_dClient ACCESS ADR(Kanlink.ClientListe[_i]);
					
				IF (Kanlink.RecKey.CmdKey = _dClient.Key.CmdKey) AND (Kanlink.RecKey.IP_Key = _dClient.Key.IP_Key) THEN // Index gefunden, beantworten: 
					_xIdxFound := TRUE;
					Kanlink.MuServerListe.Servers[_k] := _i;
					EXIT;
				END_IF;						
			END_FOR
			
			_xAdrOK := _dClient.AdrDataResp <> 0 ;
		
			IF _xIdxFound AND _xAdrOK THEN 
				_dClient.xReqPending := FALSE;
				IF (_dClient.MuClient >= 0) THEN
					IF (Kanlink.ServerData.PreHeaderRec.HeaderVersion = 16#0101) THEN
						IF (Kanlink.MuClientListe[_dClient.MuClient].bUse = 2) THEN
							Kanlink.MuClientListe[_dClient.MuClient].bUse := 1;
						END_IF
					ELSIF (Kanlink.ServerData.PreHeaderRec.HeaderVersion = 16#0100) THEN
						Kanlink.MuClientListe[_dClient.MuClient].bUse := 255;
					END_IF
					IF ((Kanlink.MuClientListe[_dClient.MuClient].bUse <> 0) AND (Kanlink.MuClientListe[_dClient.MuClient].bUse <> 255)) THEN
						Kanlink.MuClientListe[_dClient.MuClient].xReqPending := FALSE;
					END_IF
				END_IF

				IF _dClient.iTimeOutCnt > 0 THEN 
					_dClient.iTimeOutCnt := _dClient.iTimeOutCnt - 1;
				END_IF;
				IF _dClient.adrInterface <> 0 THEN 	
					_dCltIf ACCESS _dClient.adrInterface; 
					_dCltIf.iState := 3; 	
				END_IF;
			
				IF (_k = 0) THEN
					memcpy(_dClient.AdrDataResp,ADR(Kanlink.ServerData.receive_data) + PreHeaderSize + HeaderSize,_dClient.RespLength);
				ELSE
					memcpy(_dClient.AdrDataResp,ADR(Kanlink.ServerData.receive_data) + Kanlink.MuServerListe.wOffset[_k] + HeaderSize,_dClient.RespLength);
				END_IF

				_dCltIf.out.recTag := Kanlink.ServerData.HeaderV1Rec[_k].Tag; 
			
		  	END_IF;		 			
								
		END_FOR

		_iCltRespCnt := _iCltRespCnt + 1; 
		Kanlink._xGetClientResp := FALSE;
		
		Kanlink._xSendClient := TRUE; // Daten einsortiert, nix weiter zutun also Clients bearbeiten
		Kanlink.udp.rec.enable := 1;

END_ACTION