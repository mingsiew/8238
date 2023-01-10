(********************************************************************
 * Program: loadcells
 * File: loadcells.st
 ********************************************************************)
PROGRAM _INIT
//  FOR i := 1 TO 49 DO
//    loadcell_array[i].udp_data := ADR(loadcell_udp_array[i]);
//  END_FOR;

END_PROGRAM

PROGRAM _CYCLIC

	//==============================
	//	//Weights
	//==============================
	
	//Sorting
	IF NOT Std.TestMode THEN
		weight1 := DINT_TO_UINT(ABS(WeightRaw[1301].Wgt_Channel_1)/100);
		weight2 := DINT_TO_UINT(ABS(WeightRaw[1302].Wgt_Channel_1)/100);
		weight3 := DINT_TO_UINT(ABS(WeightRaw[1303].Wgt_Channel_1)/100);
		weight4 := DINT_TO_UINT(ABS(WeightRaw[1304].Wgt_Channel_1)/100);
		weight5 := DINT_TO_UINT(ABS(WeightRaw[1305].Wgt_Channel_1)/100);
		weight6 := DINT_TO_UINT(ABS(WeightRaw[1306].Wgt_Channel_1)/100);
		weight7 := DINT_TO_UINT(ABS(WeightRaw[1307].Wgt_Channel_1)/100);
		weight8 := DINT_TO_UINT(ABS(WeightRaw[1308].Wgt_Channel_1)/100);
		weight9 := DINT_TO_UINT(ABS(WeightRaw[1309].Wgt_Channel_1)/100);
		weight10 := DINT_TO_UINT(ABS(WeightRaw[1310].Wgt_Channel_1)/100);
		weight11 := DINT_TO_UINT(ABS(WeightRaw[1311].Wgt_Channel_1)/100);
		weight12 := DINT_TO_UINT(ABS(WeightRaw[1312].Wgt_Channel_1)/100);
		weight13 := DINT_TO_UINT(ABS(WeightRaw[1313].Wgt_Channel_1)/100);
		weight14 := DINT_TO_UINT(ABS(WeightRaw[1314].Wgt_Channel_1)/100);
		weight15 := DINT_TO_UINT(ABS(WeightRaw[1315].Wgt_Channel_1)/100);
		weight16 := DINT_TO_UINT(ABS(WeightRaw[1316].Wgt_Channel_1)/100);
		weight17 := DINT_TO_UINT(ABS(WeightRaw[1317].Wgt_Channel_1)/100);
		weight18 := DINT_TO_UINT(ABS(WeightRaw[1318].Wgt_Channel_1)/100);
	ELSE
		weight1 := testweight;
		weight2 := testweight;
		weight3 := testweight;
		weight4 := testweight;
		weight5 := testweight;
		weight6 := testweight;
		weight7 := testweight;
		weight8 := testweight;
		weight9 := testweight;
		weight10 := testweight;
		weight11 := testweight;
		weight12 := testweight;
		weight13 := testweight;
		weight14 := testweight;
		weight15 := testweight;
		weight16 := testweight;
		weight17 := testweight;
		weight18 := testweight;
	END_IF;
	
	//	weight19 := DINT_TO_UINT(ABS(WeightRaw[1319].Wgt_Channel_1)/100);
	//	weight20 := DINT_TO_UINT(ABS(WeightRaw[1320].Wgt_Channel_1)/100);
	//	weight21 := DINT_TO_UINT(ABS(WeightRaw[1321].Wgt_Channel_1)/100);
	//	weight22 := DINT_TO_UINT(ABS(WeightRaw[1322].Wgt_Channel_1)/100);
	//	weight23 := DINT_TO_UINT(ABS(WeightRaw[1323].Wgt_Channel_1)/100);
	//	weight24 := DINT_TO_UINT(ABS(WeightRaw[1324].Wgt_Channel_1)/100);
	//	
	//	//Loading Units 
	//	weight31 := DINT_TO_UINT(ABS(WeightRaw[1025].Wgt_Channel_1 + WeightRaw[1025].Wgt_Channel_2)/100); //SLU3
	//	weight32 := DINT_TO_UINT(ABS(WeightRaw[1027].Wgt_Channel_1 + WeightRaw[1027].Wgt_Channel_2)/100); //SLU4
	//	weight33 := DINT_TO_UINT(ABS(WeightRaw[1029].Wgt_Channel_1 + WeightRaw[1029].Wgt_Channel_2)/100); //SLU5
	//	weight34 := DINT_TO_UINT(ABS(WeightRaw[1621].Wgt_Channel_1 + WeightRaw[1621].Wgt_Channel_2)/100); //SLU6
	//	
	//	//Weigh Beams
	//	weight48 := DINT_TO_UINT(ABS(WeightRaw[1339].Wgt_Channel_1)/100); //SWB1 ????
	//	weight49 := DINT_TO_UINT(ABS(WeightRaw[1340].Wgt_Channel_1)/100); //SWB2 ????
	
END_PROGRAM
