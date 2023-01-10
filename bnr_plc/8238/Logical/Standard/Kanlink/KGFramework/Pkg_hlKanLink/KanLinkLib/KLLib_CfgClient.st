(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KanLinkLib
 * File: KLLib_CfgServer.st
 * Author: stahlhut
 * Created: February 01, 2012
 ********************************************************************
 * Implementation of library KanLinkLib
 ********************************************************************) 

(* Configuriert einen Kanlink Client *)
FUNCTION_BLOCK KLLib_CfgClient
	// überprüfen
	IF (adrKanlink = 0) OR (adrSReq = 0) OR (adrSResp = 0) OR (adrName = 0)  THEN 
		status := 1; // Fehler 1 adressen fehler
		RETURN;
	END_IF;	
	IF (ClientIndex > HLKANLINK_MAX_CLIENTCONNS) THEN
		status := 2; // Fehler Index zu gross
		RETURN;
	END_IF;
	
	_dKL ACCESS adrKanlink;
	IF _dKL.ClientListe[ClientIndex].adrParameter = 0 THEN 
		status := 3; // fehler Kanlink / fehlende init der adressen Interface
		RETURN;
	END_IF;
	
	IF CycleTime < 200 THEN 
		CycleTime := 1000;
	END_IF;	
	
	_dCltPar ACCESS _dKL.ClientListe[ClientIndex].adrParameter;
	_dCltPar.Adr := IPAdr;
	_dCltPar.Area := Area;
	_dCltPar.Cmd := Cmd;
	_dCltPar.CmdOpt := CmdOpt;
	memcpy(ADR( _dCltPar.Name ),adrName,15);
	memcpy(ADR(_dCltPar.sReq),adrSReq,80);
	memcpy(ADR(_dCltPar.sResp),adrSResp,80);
	_dCltPar.CycleTime := CycleTime;
	
	_iret := KLLib_ReadClientPara(ADR(_dKL.ClientListe[ClientIndex]),(_dKL.ClientListe[ClientIndex].adrParameter),adrKanlink);
	
	IF ( _iret <> 0 ) THEN 
		_dKL.ClientListe[ClientIndex].xActiv := 0;
		status := 4;
	ELSE
		_dKL.ClientListe[ClientIndex].xActiv := (_dKL.ClientListe[ClientIndex].Cmd <> 0);
		status := 0; // mit ok beenden
	END_IF;	
	
	
END_FUNCTION_BLOCK