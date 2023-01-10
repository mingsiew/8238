
TYPE
	SortingItem_typ : 	STRUCT 
		station : UINT;
		count : UINT;
		weight : UINT;
		cus : STRING[11];
		cat : STRING[11];
		spare1 : UINT;
		spare2 : UINT;
	END_STRUCT;
	Sorting_typ : 	STRUCT 
		counting_frames : ARRAY[0..MAX_STATIONS]OF SortingItem_typ;
	END_STRUCT;
END_TYPE
