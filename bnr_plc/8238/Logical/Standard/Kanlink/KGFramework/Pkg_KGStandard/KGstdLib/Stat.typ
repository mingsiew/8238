(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Package: Pkg_KGStandard
 * File: State.typ
 * Author: hunholz
 * Created: September 20, 2011
 ********************************************************************
 * Data types of package Pkg_KGStandard
 ********************************************************************)

TYPE
	Stat_typ : 	STRUCT 
		wStatus : UINT;
		sStatus : STRING[127];
	END_STRUCT;
END_TYPE
