(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: KanLinkLib
 * Datei: KL_BuildKey.st
 * Autor: stahlhut
 * Erstellt: 16. Januar 2012
 ********************************************************************
 * Implementierung der Library KanLinkLib
 ********************************************************************) 

(* Berechnen des Connection Key *)
FUNCTION KL_BuildKey
	
	IF adrKey = 0 THEN // Fehler aufgetreten

		Key.CmdKey := 0;
		Key.IP_Key := 0;
		KL_BuildKey := FALSE;

	ELSE

		Key ACCESS adrKey;
		Key.CmdKey := SHL(UINT_TO_UDINT(Command),16)+USINT_TO_UINT(CmdNr);
		ethInetAton(ADR(IPAdr),ADR(IP_Key));
		Key.IP_Key := IP_Key;
		KL_BuildKey := TRUE;

	END_IF
	
END_FUNCTION