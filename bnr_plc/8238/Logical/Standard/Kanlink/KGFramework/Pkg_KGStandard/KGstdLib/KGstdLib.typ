(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * Library: KGstd
 * File: KGstd.typ
 * Author: hunholz
 * Created: June 23, 2011
 ********************************************************************
 * Data types of library KGstd
 ********************************************************************)

TYPE
	MAC_type :ARRAY[0..5]OF USINT;
	GUID_type :ARRAY[0..15]OF USINT;
	KG_ErrLog_typ : 	STRUCT 
		wErrorNo : UINT;
		lAttr1 : UDINT;
		lAttr2 : UDINT;
	END_STRUCT;
END_TYPE
