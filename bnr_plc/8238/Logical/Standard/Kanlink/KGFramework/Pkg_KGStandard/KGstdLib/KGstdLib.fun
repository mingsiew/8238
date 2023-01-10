(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: KGstd.fun
 * Author: hunholz
 * Created: June 23, 2011
 ********************************************************************
 * Functions and function blocks of library KGstd
 ********************************************************************)

FUNCTION_BLOCK kgGetEthPort (*Returns the CPUs ethernet port as string*)
	VAR_INPUT
		enable : BOOL;
		adrIF : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		_bStep : USINT;
		DiagCreateInfo_CPU : DiagCreateInfo;
		DiagGetNumInfo_CPU : DiagGetNumInfo;
		DiagDisposeInfo_CPU : DiagDisposeInfo;
		_xReady : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION kgitoa_udint : UINT (*Wandelt UDINT Werte in einen String*)
	VAR_INPUT
		num : UDINT;
	END_VAR
	VAR_IN_OUT
		str : STRING[11];
	END_VAR
	VAR
		_num : UDINT;
		_digit : UDINT;
		_sdigit : STRING[1];
		_bdigit : REFERENCE TO USINT;
	END_VAR
END_FUNCTION

FUNCTION kgatoi_udint : UINT (*String in UDINT wandeln*)
	VAR_INPUT
		str : STRING[11];
	END_VAR
	VAR_IN_OUT
		num : UDINT;
	END_VAR
	VAR
		_len : UINT;
		_result : UINT;
		_sdigit : STRING[1];
		_bdigit : REFERENCE TO USINT;
		_mul : UDINT;
		_digit : UDINT;
		_i : INT;
	END_VAR
END_FUNCTION

FUNCTION kgatoi_uint : UINT (*atoi für UINT mit Fehlermeldung*)
	VAR_INPUT
		str : STRING[11];
	END_VAR
	VAR_IN_OUT
		num : UINT;
	END_VAR
	VAR
		_result : UINT;
		_len : INT;
		_sdigit : STRING[1];
		_bdigit : REFERENCE TO USINT;
		_mul : UINT;
		_i : INT;
		_digit : USINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK kgNextBatchNoLong (*Generiert eine neue Postennummer*)
	VAR_INPUT
		Enable : BOOL; (*Positive Flanke erzeugt neue Nummer*)
		Group : USINT; (*0..7*)
	END_VAR
	VAR_OUTPUT
		Status : UINT; (*0 : OK, 1 : Maximale Anzahl möglicher Nummern pro Tag erreich, B&R Werte*)
		BatchNo : UDINT;
	END_VAR
	VAR
		_bOldYear : USINT;
		_bOldMonth : USINT;
		_bOldDay : USINT;
		DTStrucGetTime : DTStructureGetTime;
		_dtStruc : DTStructure;
		_bGroup : USINT;
		_wNo : UINT;
		_bStep : USINT;
		_diBatchNo : DatObjInfo;
		_pBatchNo : REFERENCE TO UDINT;
		_dwBatchNo : DatObjWrite;
		_dcBatchNo : DatObjCreate;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgGetMacAdress (*Nur im Init-Up aufrufen*)
	VAR_INPUT
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		Mac : MAC_type;
		Status : UINT;
	END_VAR
	VAR
		_gep : kgGetEthPort;
		_sIF : STRING[23];
		_exi : ETHxinfo;
		_bMAC : MAC_type;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgGetBatchNoUnique (*Batchnummer als Unique Identifier 16 Byte*)
	VAR_INPUT
		Enable : BOOL;
		Mac : MAC_type;
	END_VAR
	VAR_OUTPUT
		BatchNo : GUID_type;
		Status : UINT;
	END_VAR
	VAR
		DTGetTime_0 : DTGetTime;
		_time : TIME;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION kgBatchNoToUDINT : UDINT (*Extrahiere aus GUID ein UDINT*)
	VAR_INPUT
		GUID : GUID_type;
	END_VAR
	VAR
		_udint : REFERENCE TO UDINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK kgUSINT16toGUID (*Konvertiere USINT-Array to GUID_typ*)
	VAR_INPUT
		usintarray : ARRAY[0..15] OF USINT;
	END_VAR
	VAR_OUTPUT
		GUID : GUID_type;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgGUIDtoSTRING (*GUID-String erzeugen*)
	VAR_INPUT
		GUID : GUID_type;
	END_VAR
	VAR_OUTPUT
		sOut : STRING[36];
	END_VAR
	VAR
		usintarray : REFERENCE TO ARRAY[0..15] OF USINT;
		_StringArray : REFERENCE TO ARRAY[0..36] OF USINT;
		_Ptr : INT;
		_i : INT;
		_b : USINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgLogLine (*Logzeile mit zwei numerischen Variablen erzeugen*)
	VAR_INPUT
		sLoglineTemplate : STRING[127];
		lAttr1 : UDINT;
		lAttr2 : UDINT;
	END_VAR
	VAR_OUTPUT
		sLogline : STRING[127];
		pLogline : UDINT;
	END_VAR
	VAR
		_iPos1 : INT;
		_iPos2 : INT;
		_iCrs : INT;
		sValue : STRING[11];
		_sTemp : STRING[127];
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgArLogWrite (*Checks ident on > 0 and formats string with two numbers*)
	VAR_INPUT
		enable : BOOL;
		ident : UDINT;
		logLevel : UDINT;
		errornr : UDINT;
		text : STRING[127];
		var1 : UDINT;
		var2 : UDINT;
	END_VAR
	VAR_OUTPUT
		status : UINT;
	END_VAR
	VAR
		_AsArLogWrite : AsArLogWrite;
		_kgLogLine : kgLogLine;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgRBinsert (*Insert any entry into a ringbuffer*)
	VAR_INPUT
		pEntry : UDINT;
		lLenEntry : UDINT;
		doIdent : UDINT;
		doLen : UDINT;
	END_VAR
	VAR_OUTPUT
		wStatus : UINT;
	END_VAR
	VAR_IN_OUT
		wPtrStart : UINT;
		wPtrWrite : UINT;
		wPtrRead : UINT;
	END_VAR
	VAR
		doWrite : DatObjWrite;
		_lRBlen : UDINT;
		_wPtrMax : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgRBread (*Reads one entry and moves the readpointer*)
	VAR_INPUT
		pEntry : UDINT;
		lLenEntry : UDINT;
		doIdent : UDINT;
		doLen : UDINT;
		wPtrStart : UINT;
		wPtrWrite : UINT;
	END_VAR
	VAR_OUTPUT
		wStatus : UINT;
	END_VAR
	VAR_IN_OUT
		wPtrRead : UINT;
	END_VAR
	VAR
		doRead : DatObjRead;
		_lRBlen : UDINT;
		_wPtrMax : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgRBloc (*Free Readpointer access*)
	VAR_INPUT
		pEntry : UDINT;
		lLenEntry : UDINT;
		doIdent : UDINT;
		doLen : UDINT;
		wPtrStart : UINT;
		wPtrWrite : UINT;
		wPtrLoc : UINT;
		bMode : USINT; (*Lese relativ zum Start- oder Schreibzeiger*)
	END_VAR
	VAR_OUTPUT
		wStatus : UINT;
	END_VAR
	VAR
		doRead : DatObjRead;
		_lRBlen : UDINT;
		_wPtrMax : UINT;
		_wPtrLoc : UINT;
		_wActLen : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION kgGUIDisZero : BOOL (*Prüfen, ob alle 16 Byte der GUID 0 sind.*)
	VAR_INPUT
		GUID : GUID_type;
	END_VAR
	VAR
		_bGUID : REFERENCE TO ARRAY[0..15] OF USINT;
		_i : USINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK kgRBcreate (*Erzeuge Datenobjekt für Ringbuffer*)
	VAR_INPUT
		sName : STRING[10]; (*Name des Datenobjekts*)
		bMemType : USINT; (*Speichertyp*)
		wCntEntry : UINT; (*Mindestanzahl der RB_Einträge*)
		lLenEntry : UDINT; (*Länge des einzelnen Eintrags*)
	END_VAR
	VAR_OUTPUT
		doIdent : UDINT; (*Identifier des Datenobjekts*)
		doLen : UDINT; (*Länge des Datenobjekts*)
		wStatus : UINT; (*Status*)
		pDatObjMem : UDINT;
	END_VAR
	VAR_IN_OUT
		wPtrWrite : UINT; (*Schreibzeiger*)
		wPtrRead : UINT; (*Lesezeiger*)
		wPtrStart : UINT; (*Startzeiger*)
	END_VAR
	VAR
		_diRB : DatObjInfo;
		_dcRB : DatObjCreate;
		_ddRB : DatObjDelete;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK kgRBbulkloc (*Lese mehrere Einträge gleichzeitig in ein Array*)
	VAR_INPUT
		pEntry : UDINT; (*Zeiger auf den Zielbereich*)
		lLenEntry : UDINT; (*Länge eines Eintrags*)
		wCntEntry : UINT; (*Anzahl Einträge*)
		doIdent : UDINT;
		doLen : UDINT;
		wPtrStart : UINT;
		wPtrWrite : UINT;
		wPtrLoc : UINT;
		bMode : USINT;
	END_VAR
	VAR_OUTPUT
		wStatus : UINT;
		wCntLoc : UINT;
	END_VAR
	VAR
		_lRBlen : UDINT;
		_wPtrMax : UINT;
		_wActLen : UINT;
		_wPtrLoc : UINT;
		_i : UINT;
		_doRead : DatObjRead;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION kgGetLineNumberW3 : USINT (*Maschinennummer und -typ aus Stationsadresse berechnen*)
	VAR_INPUT
		Station : USINT;
		pMachineType : UDINT;
	END_VAR
	VAR
		_MachineType : REFERENCE TO kgMachinetypeW3_typ;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK kgInitBatchNoLong (*Legt ggf. Datenobjekt zum Speichern der laufenden Postennummer an*)
	VAR_INPUT
		Enable : BOOL;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		_bStep : USINT;
		_diBatchNo : DatObjInfo;
		_dcBatchNo : DatObjCreate;
		_BatchNo : UDINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION kgGetMachineAdressW3 : USINT (*Ermittelt die Maschinenadresse aus Liniennummer und Maschinentyp*)
	VAR_INPUT
		LineNumber : USINT;
		MachineType : kgMachinetypeW3_typ;
	END_VAR
	VAR
		_diMachineType : REFERENCE TO DINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK kgCheckDo (*Prüfe auf Datenobjekt und erzeuge es ggf. neu*)
	VAR_INPUT
		Enable : BOOL;
		pName : UDINT;
		MinLen : UDINT;
		NomLen : UDINT;
		Create : BOOL;
		MemType : USINT;
	END_VAR
	VAR_OUTPUT
		doId : UDINT;
		doMem : UDINT;
		doLen : UDINT;
		Status : UINT;
	END_VAR
	VAR
		_wStep : UINT;
		_doInfo : DatObjInfo;
		_xReady : BOOL;
		_doDelete : DatObjDelete;
		_doCreate : DatObjCreate;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION kgXOR : USINT (*XOR über Byte-Feld*)
	VAR_INPUT
		pMem : UDINT; (*Speicher*)
		wLen : UINT; (*Länge*)
		bInit : USINT; (*Startwert*)
		pStatus : UDINT; (*Status*)
		pWordResult : UDINT;
	END_VAR
	VAR
		_wDynStatus : REFERENCE TO UINT;
		_xStatusOk : BOOL;
		_bMem : REFERENCE TO ARRAY[1..65535] OF USINT;
		_xWordResultOk : BOOL;
		_bWordResult : REFERENCE TO ARRAY[0..1] OF USINT;
		_i : UINT;
	END_VAR
END_FUNCTION

FUNCTION kgUnitconfREALtoDisplay : REAL (*Wandelt Wert entsprechend der Unit*)
	VAR_INPUT
		Value : REAL;
		Unit : UINT;
		LocUnit : USINT;
		pDigits : UDINT;
		pUnit : UDINT;
	END_VAR
	VAR
		lDigits : UDINT;
		sUnit : STRING[11];
	END_VAR
END_FUNCTION

FUNCTION kgUnitconfDisplayToREAL : REAL (*Wandelt Wert entsprechend der Unit*)
	VAR_INPUT
		Display : REAL;
		Unit : UINT;
		LocUnit : USINT;
	END_VAR
END_FUNCTION

FUNCTION kgGetProgdata : UINT (*Read Programdata from a dataobject*)
	VAR_INPUT
		sBaseName : STRING[11];
		wProgNo : UINT;
		wProgMaxNo : UINT;
		pMem : UDINT;
		lSize : UDINT;
	END_VAR
	VAR
		_sIndex : STRING[5];
		_sIndex1 : STRING[5];
		_sName : STRING[16];
		_diProg : DatObjInfo;
	END_VAR
END_FUNCTION

FUNCTION kgSignalLight : BOOL
	VAR_INPUT
		xClock : BOOL;
		wStatus : UINT;
	END_VAR
	VAR_IN_OUT
		xGreen : BOOL;
		xYellow : BOOL;
		xRed : BOOL;
	END_VAR
END_FUNCTION
