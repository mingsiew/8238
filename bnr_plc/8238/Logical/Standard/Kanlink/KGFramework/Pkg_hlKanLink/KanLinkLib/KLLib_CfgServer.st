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

(* Configuriert einen Kanlink Server *)
FUNCTION_BLOCK KLLib_CfgServer
	// überprüfen
	IF (adrKanlink = 0) OR (adrSReq = 0) OR (adrSResp = 0) OR (adrName = 0)  THEN 
		status := 1; // Fehler 1 adressen fehler
		RETURN;
	END_IF;	
	IF (ServerIndex > HLKANLINK_MAX_SERVERCONNS) THEN
		status := 2; // Fehler Index zu gross
		RETURN;
	END_IF;
	
	_dKL ACCESS adrKanlink;
	IF _dKL.ServerListe[ServerIndex].adrParameter = 0 THEN 
		status := 3; // fehler Kanlink / fehlende init der adressen Interface
		RETURN;
	END_IF;
	
	IF TimeOut < 200 THEN 
		TimeOut := 1000;
	END_IF;	
	
	_dSrvPar ACCESS _dKL.ServerListe[ServerIndex].adrParameter;
	_dSrvPar.Adr := IPAdr;
	_dSrvPar.Area := Area;
	_dSrvPar.Cmd := Cmd;
	_dSrvPar.CmdOpt := CmdOpt;
	memcpy(ADR( _dSrvPar.Name ),adrName,15);
	memcpy(ADR(_dSrvPar.sReq),adrSReq,80);
	memcpy(ADR(_dSrvPar.sResp),adrSResp,80);
	_dSrvPar.TimeOut := TimeOut;
	
	_iret := KLLib_ReadServerPara(ADR(_dKL.ServerListe[ServerIndex]),(_dKL.ServerListe[ServerIndex].adrParameter),adrKanlink);
	
	IF ( _iret <> 0 ) THEN 
		status := 4;
	ELSE
		status := 0; // mit ok beenden
	END_IF;	

	
	
	
END_FUNCTION_BLOCK