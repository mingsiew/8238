(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: WetLinkLib
 * File: WLLib_ReadServerPara.st
 * Author: stahlhut
 * Created: January 08, 2012
 ********************************************************************
 * Implementation of library WetLinkLib
 ********************************************************************) 

(* TODO: Add your comment here *)
FUNCTION KLLib_ReadServerPara

_xError := (adrServerItem = 0) OR (adrParaItem=0) OR (adrKanLink=0);

IF _xError THEN // Fehler aufgetreten
	dServer.iCfgStatus := 2;		
	KLLib_ReadServerPara := 1;
ELSE
	dServer ACCESS adrServerItem;
	dPara ACCESS adrParaItem;
	KanLink ACCESS adrKanLink;
	_udArr ACCESS ADR(_udAdr);

	dServer.iCfgStatus := 0;		
	
	dServer.Cmd :=  dPara.Cmd;
	dServer.CmdOpt := dPara.CmdOpt;
	IF (dPara.AdvMode) THEN

	END_IF
	IF dPara.AdvMode THEN
		ethInetAton (ADR(dPara.AdrAdvMode),ADR(_udAdr));
		dServer.sServerIPAdr := dPara.AdrAdvMode;
		dServer.Area := (USINT_TO_UINT(_udArr.c) AND 16#0F);;
		dServer.Adr := USINT_TO_UINT(_udArr.d);
		dPara.Adr := dServer.Adr;
		dPara.Area := dServer.Area;
	ELSE
		dServer.Adr :=  dPara.Adr;
		dServer.Area := dPara.Area;
	END_IF
	dServer.pReqStr := ADR(dPara.sReq);
	dServer.pRespStr := ADR(dPara.sResp);
	dServer.adrParameter := adrParaItem;
	dServer.xReqManually := (dPara.CmdOpt AND KL_optReqManually) <> 0 ;	
	KLLib_ReadServerPara := 0;

	_udNetId ACCESS ADR(KanLink.udNetID);
	IF NOT dPara.AdvMode THEN
		_udArr.a := _udNetId.a;
		_udArr.b := _udNetId.b;
		_udArr.c := (_udNetId.c AND 16#F0) +  UINT_TO_USINT(dServer.Area);
		_udArr.d := UINT_TO_USINT(dServer.Adr);
	
		ethInetNtoa((_udAdr),ADR(dServer.sServerIPAdr));
	END_IF	 

	KL_BuildKey(Command:= (dServer.Cmd),CmdNr := UINT_TO_USINT( dPara.CmdOpt) ,IPAdr := dServer.sServerIPAdr ,adrKey := ADR(dServer.Key));
	KLLib_GetPVAdr(adrServerItem);
	IF (dServer.AdrDataReq= 0) OR (dServer.AdrDataResp = 0) THEN 
		dServer.iCfgStatus := 1; // fehler melden
	END_IF;		

END_IF;	


END_FUNCTION
