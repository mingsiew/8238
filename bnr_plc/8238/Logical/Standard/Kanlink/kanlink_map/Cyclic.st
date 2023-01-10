
PROGRAM _CYCLIC

////SDC1 r43
//Comm[1].Customer	:= wash_com_cust_1;
//Comm[1].Category	:= wash_com_cat_1;
//Comm[1].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_1),ADR(wash_com_batch1_2));
//Comm[1].Weight		:= (wash_com_wt_1 * 10);
//
//Comm[1].BagReady	:= r43.sling_ready;
//r43.open_signal	:= 	Comm[1].DropLoad;
//r43.receive_signal	:= 	Comm[1].LoadDropped;
//IF EDGEPOS(Comm[1].LoadDropped) THEN
//	wash_com_cust_1 := 0;
//	wash_com_cat_1  := 0;
//	wash_com_wt_1  := 0;
//	wash_com_batch1_1 := 0;
//	wash_com_batch1_2 := 0;
//END_IF;
//
////SDC2 r45
//Comm[2].Customer	:= wash_com_cust_2;
//Comm[2].Category	:= wash_com_cat_2;
//Comm[2].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_2),ADR(wash_com_batch2_2));
//Comm[2].Weight		:= (wash_com_wt_2 * 10);
//
//Comm[2].BagReady	:= r45.sling_ready;
//r45.open_signal	:= 	Comm[2].DropLoad;
//r45.receive_signal	:= 	Comm[2].LoadDropped;
//IF EDGEPOS(Comm[2].LoadDropped) THEN
//	wash_com_cust_2 := 0;
//	wash_com_cat_2  := 0;
//	wash_com_wt_2  := 0;
//	wash_com_batch1_2 := 0;
//	wash_com_batch2_2 := 0;
//END_IF;
//
////SDC3 r47
//Comm[3].Customer	:= wash_com_cust_3;
//Comm[3].Category	:= wash_com_cat_3;
//Comm[3].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_3),ADR(wash_com_batch2_3));
//Comm[3].Weight		:= (wash_com_wt_3 * 10);
//
//Comm[3].BagReady	:= r47.sling_ready;
//r47.open_signal	:= 	Comm[3].DropLoad;
//r47.receive_signal	:= 	Comm[3].LoadDropped;
//IF EDGEPOS(Comm[3].LoadDropped) THEN
//	wash_com_cust_3 := 0;
//	wash_com_cat_3  := 0;
//	wash_com_wt_3  := 0;
//	wash_com_batch1_3 := 0;
//	wash_com_batch2_3 := 0;
//END_IF;
//
////CDC8 r110
//Comm[4].Customer	:= wash_com_cust_12;
//Comm[4].Category	:= wash_com_cat_12;
//Comm[4].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_12),ADR(wash_com_batch2_12));
//Comm[4].Weight		:= (wash_com_wt_12 * 10);
//
//Comm[4].BagReady	:= r110.sling_ready;
//r110.open_signal	:= 	Comm[4].DropLoad;
//r110.receive_signal	:= 	Comm[4].LoadDropped;
//IF EDGEPOS(Comm[4].LoadDropped) THEN
//	wash_com_cust_12 := 0;
//	wash_com_cat_12  := 0;
//	wash_com_wt_12  := 0;
//	wash_com_batch1_12 := 0;
//	wash_com_batch2_12 := 0;
//END_IF;
//
////CDC5 r113
//Comm[5].Customer	:= wash_com_cust_13;
//Comm[5].Category	:= wash_com_cat_13;
//Comm[5].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_13),ADR(wash_com_batch2_13));
//Comm[5].Weight		:= (wash_com_wt_13 * 10);
//
//Comm[5].BagReady	:= r113.sling_ready;
//r113.open_signal	:= 	Comm[5].DropLoad;
//r113.receive_signal	:= 	Comm[5].LoadDropped;
//IF EDGEPOS(Comm[5].LoadDropped) THEN
//	wash_com_cust_13 := 0;
//	wash_com_cat_13  := 0;
//	wash_com_wt_13  := 0;
//	wash_com_batch1_13 := 0;
//	wash_com_batch2_13 := 0;
//END_IF;
//
//////CDC6 r68
////Comm[6].Customer	:= wash_com_cust_6;
////Comm[6].Category	:= wash_com_cat_6;
////Comm[6].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_6),ADR(wash_com_batch2_6));
////Comm[6].Weight		:= (wash_com_wt_6 * 10);
////
////Comm[6].BagReady	:= r68.sling_ready;
////r68.open_signal	:= 	Comm[6].DropLoad;
////r68.receive_signal	:= 	Comm[6].LoadDropped;
////IF EDGEPOS(Comm[6].LoadDropped) THEN
////	wash_com_cust_6 := 0;
////	wash_com_cat_6  := 0;
////	wash_com_wt_6  := 0;
////	wash_com_batch1_6 := 0;
////	wash_com_batch2_6 := 0;
////END_IF;
////
//////CDC7 r70
////Comm[7].Customer	:= wash_com_cust_7;
////Comm[7].Category	:= wash_com_cat_7;
////Comm[7].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_7),ADR(wash_com_batch2_7));
////Comm[7].Weight		:= (wash_com_wt_7 * 10);
////
////Comm[7].BagReady	:= r70.sling_ready;
////r70.open_signal	:= 	Comm[7].DropLoad;
////r70.receive_signal	:= 	Comm[7].LoadDropped;
////IF EDGEPOS(Comm[7].LoadDropped) THEN
////	wash_com_cust_7 := 0;
////	wash_com_cat_7  := 0;
////	wash_com_wt_7  := 0;
////	wash_com_batch1_7 := 0;
////	wash_com_batch2_7 := 0;
////END_IF;
////
//////SSL1 r1 - Comm[8]
////	
////CSL1 r65
//wash_com_cust_14 	:= UDINT_TO_INT(Comm[14].Customer);
//wash_com_cat_14 		:= UDINT_TO_INT(Comm[14].Category);
//wash_com_wt_14 		:= (Comm[14].Weight/10);
//wash_com_batch1_14	:= Get_Lower2Bytes(Comm[14].BatchID);
//wash_com_batch2_14	:= Get_Higher2Bytes(Comm[14].BatchID);
//
//Comm[14].ReadyToLoad		:= r65.sling_ready;
//r65.xfer_in_progress	:= Comm[14].Unloading;
//
//IF EDGEPOS(r65.fire) THEN
//	wash_com_cust_14 := 0;
//	wash_com_cat_14 := 0;
//	wash_com_wt_14 := 0;
//	wash_com_batch1_14 := 0;
//	wash_com_batch2_14 := 0;
//END_IF;
//
////CSL2 r68
//wash_com_cust_15 	:= UDINT_TO_INT(Comm[15].Customer);
//wash_com_cat_15 	:= UDINT_TO_INT(Comm[15].Category);
//wash_com_wt_15 		:= (Comm[15].Weight/10);
//wash_com_batch1_15	:= Get_Lower2Bytes(Comm[15].BatchID);
//wash_com_batch2_15	:= Get_Higher2Bytes(Comm[15].BatchID);
//
//Comm[15].ReadyToLoad	:= r68.sling_ready;
//r68.xfer_in_progress	:= Comm[15].Unloading;
//
//IF EDGEPOS(r68.fire) THEN
//	wash_com_cust_15 := 0;
//	wash_com_cat_15 := 0;
//	wash_com_wt_15 := 0;
//	wash_com_batch1_15 := 0;
//	wash_com_batch2_15 := 0;
//END_IF;
//
////CSL3 r49
//wash_com_cust_11 	:= UDINT_TO_INT(Comm[11].Customer);
//wash_com_cat_11 	:= UDINT_TO_INT(Comm[11].Category);
//wash_com_wt_11 		:= (Comm[11].Weight/10);
//wash_com_batch1_11	:= Get_Lower2Bytes(Comm[11].BatchID);
//wash_com_batch2_11	:= Get_Higher2Bytes(Comm[11].BatchID);
//
//Comm[11].ReadyToLoad	:= r49.sling_ready;
//r49.xfer_in_progress	:= Comm[11].Unloading;
//
//IF EDGEPOS(r49.fire) THEN
//	wash_com_cust_11 := 0;
//	wash_com_cat_11 := 0;
//	wash_com_wt_11 := 0;
//	wash_com_batch1_11 := 0;
//	wash_com_batch2_11 := 0;
//END_IF;

////CDC2 r70  - DOUBLE DROP>
//Comm[1].Customer	:= wash_com_cust_1;
//Comm[1].Category	:= wash_com_cat_1;
//Comm[1].BatchID		:= DByte_TO_4Byte(ADR(wash_com_batch1_1),ADR(wash_com_batch2_1));
////Comm[1].Weight		:= (wash_com_wt_1 * 10);
//	
//bag_4_wieight 		:= WORD_TO_INT(plc_info1);  // 2nd Bag wieght - 1 if the wieght is -0 so we know there is 2 bags.
//doubleDrop			:= (bag_2_wieight > 0);
////Build the batch of 2	
//
//IF EDGEPOS(r70.loading_signal) THEN // Decider has ran
//	IF doubleDrop THEN
//		Comm[1].Batch_QtyRemaining := 2;
//	ELSE	
//		Comm[1].Batch_QtyRemaining := 1;	
//	END_IF;
//END_IF;		
//	
//IF EDGEPOS(r70.state = 2 ) THEN // Bag arrives in the discharger	
//	CASE Comm[1].Batch_QtyRemaining OF		
//		1:
//			Comm[1].Batchpart[1].Customer := Comm[1].Customer;	
//			Comm[1].Batchpart[1].Wgt := (wash_com_wt_1 * 10);
//			Comm[1].Batchpart[2].Customer := 0;	
	//			Comm[1].Batchpart[2].Wgt := 0;
//			Comm[1].Weight := (wash_com_wt_1 *10);
//		2:
//			Comm[1].Batchpart[1].Customer := Comm[1].Customer;	
//			Comm[1].Batchpart[1].Wgt := (wash_com_wt_1 * 10);
//			Comm[1].Batchpart[2].Customer := Comm[1].Customer;	
//			Comm[1].Batchpart[2].Wgt := (bag_2_wieight * 10);
//			Comm[1].Weight := ((wash_com_wt_1 + bag_2_wieight) *10);
//	END_CASE;				
//END_IF;		
//
//Comm[1].BagReady	:= r70.sling_ready;
//r70.open_signal	:= 	Comm[1].DropLoad;
//r70.receive_signal	:= 	Comm[1].LoadDropped;
//IF EDGEPOS(Comm[1].LoadDropped) THEN
//	wash_com_cust_1 := 0;
//	wash_com_cat_1  := 0;
//	wash_com_wt_1  := 0;
//	wash_com_batch1_1 := 0;
//	wash_com_batch2_1 := 0;
//	// Count down the loads
//	IF 	Comm[1].Batch_QtyRemaining >= 1 THEN
//		Comm[1].Batch_QtyRemaining := Comm[1].Batch_QtyRemaining - 1; 	
//	ELSE	
//		Comm[1].Batch_QtyRemaining := 0;
//	END_IF;		
//END_IF;
//	

END_PROGRAM
