(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Package: Pkg_mnTxt
 * File: Pkg_mnTxt.typ
 * Author: hunholz
 * Created: November 25, 2011
 ********************************************************************
 * Data types of package Pkg_mnTxt
 ********************************************************************)
(*Interface*)

TYPE
	IFmnTxt_Typ : 	STRUCT 
		In : IFmnTxt_In_Typ;
		Out : IFmnTxt_Out_Typ;
	END_STRUCT;
	IFmnTxt_Out_Typ : 	STRUCT 
		wSelectedLanguage : UINT; (*Aktive Sprache*)
		wSelectLanguageStatus : UINT; (*0 - Sprache gültig, nur dann sind auch die Pointer auf die Texte gültig
60000..65000 - Fehler
65535 - Sprache wird geladen*)
		wLCIDs : ARRAY[0..MNTXT_MAX_IDX_LCID]OF UINT;
		wCntLCID : UINT;
		wCntInstanceTxt : UINT := 0;
		wCntFunctionTxt : UINT := 0;
		wCntParamTxt : UINT := 0;
		wCntParamHlpTxt : UINT := 0;
		wCntMessageTxt : UINT := 0;
		wCntMessageHlpTxt : UINT := 0;
		ptrInstanceTxtList : UDINT; (*Zeigt auf das Datenobjekt _mnTxtI, Zeilen vom Typ mnTxt_TxtLine_Typ*)
		ptrFunctionTxtList : UDINT; (*Zeigt auf das Datenobjekt _mnTxtF, Zeilen vom Typ mnTxt_TxtLine_Typ*)
		ptrParamTxtList : UDINT; (*Zeigt auf das Datenobjekt _mnTxtP, Zeilen vom Typ mnTxt_TxtLine_Typ*)
		ptrParamHelpTxtList : UDINT; (*Zeigt auf das Datenobjekt _mnTxtPh, Zeilen vom Typ mnTxt_HelpTxtLine_Typ*)
		ptrMessageTxtList : UDINT; (*Zeigt auf das Datenobjekt _mnTxtM, Zeilen vom Typ mnTxt_TxtLine_Typ*)
		ptrMessageHelpTxtList : UDINT; (*Zeigt auf das Datenobjekt _mnTxtMh, Zeilen vom Typ mnTxt_HelpTxtLine_Typ*)
	END_STRUCT;
	IFmnTxt_In_Typ : 	STRUCT 
		wSelectLanguage : UINT; (*LCID der Sprache, die genutzt werden soll*)
	END_STRUCT;
END_TYPE

(*Parameter*)

TYPE
	mnTxtPar_Typ : 	STRUCT 
		Mac : mnTxtPar_Mac_Typ; (*Maschinenparameter*)
	END_STRUCT;
	mnTxtPar_Mac_Typ : 	STRUCT 
		wStartUpLanguage : UINT := 0; (*Die Sprache ist remanent. Ist hier ein Wert > 0 gewählt, wird diese Sprache beim Einschalten immer geladen.*)
	END_STRUCT;
END_TYPE

(*Status*)

TYPE
	mnTxtStatAd_Typ : 	STRUCT 
		sPkgVersion : STRING[10];
	END_STRUCT;
END_TYPE

(*Öffentliche Typen*)

TYPE
	mnTxt_TxtLine_Typ : 	STRUCT 
		wFunctionID : UINT; (*Funktions-Identifier*)
		wNumber : UINT; (*Textnummer*)
		wInstance : UINT; (*Instanznummer, um kompatibel zu mnMsg zu sein*)
		utfText : WSTRING[63]; (*Eigentlicher Text*)
	END_STRUCT;
	mnTxt_HelpTxtLine_Typ : 	STRUCT 
		wFunctionID : UINT; (*Funktions-Identifier*)
		wNumber : UINT; (*Textnummer*)
		wInstance : UINT; (*Instanznummer, um kompatibel zu mnMsg zu sein*)
		utfText : WSTRING[255]; (*Eigentlicher Hilfstext*)
	END_STRUCT;
END_TYPE
