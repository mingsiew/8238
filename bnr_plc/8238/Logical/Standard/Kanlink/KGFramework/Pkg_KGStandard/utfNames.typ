(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Pkg_KGStandard
 * File: utfNames.typ
 * Author: hunholz
 * Created: June 29, 2011
 ********************************************************************
 * Data types of package Pkg_KGStandard
 ********************************************************************)
(*Abgeleitete Datentypen dürfen nicht als Parameter verwendet
werden, da der Parameter-Manager bzw. die B&R-System-Funktion
dann den Datentypen nicht ermitteln kann!!!*)

TYPE
	utfName31_typ :WSTRING[31];
	utfName15_typ :WSTRING[15];
END_TYPE
