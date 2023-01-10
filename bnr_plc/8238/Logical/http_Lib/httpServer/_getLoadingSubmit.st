
ACTION _getLoadingSubmit: 


	prg	:= 0;
	cat := 0;
	cus := 0;
	dst := 0;
	sp1 := 0;
	sp2 := 0;
	sp3 := 0;
	index 	:= 0;

	
	error := 0;
	found := 0;
	//Set common parameters of the function.
	getParameterName.searchString := requestData;
	getParameterName.searchOffset := 0;
	getParameterName.searchEndProperty := STRING_DOLLAR;

	//Find the index
	getParameterName.searchPropertyName := '"displayId":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		index := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := getParameterName.nextPosition;
	ELSE
		error := 1;
	END_IF;	
	
	
	//Find the category
	getParameterName.searchPropertyName := '"cat":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		cat := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := getParameterName.nextPosition;
	ELSE
		error := 2;
	END_IF;	

	//Find the customer
	getParameterName.searchPropertyName := '"cus":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		cus := DINT_TO_UDINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := getParameterName.nextPosition;
	ELSE
		error := 3;
	END_IF;		
	
	//Find the Program
	getParameterName.searchPropertyName := '"prg":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		prg := DINT_TO_USINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := getParameterName.nextPosition;
	ELSE
		error := 5;
	END_IF;		
	
	
	//Find the sp1
	getParameterName.searchPropertyName := '"sp1":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		sp1 := DINT_TO_UINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := getParameterName.nextPosition;
	ELSE
		error := 6;
	END_IF;	
	
	//Find the sp2
	getParameterName.searchPropertyName := '"sp2":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		sp2 := DINT_TO_UINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := getParameterName.nextPosition;
	ELSE
		error := 7;
	END_IF;	
	//Find the sp3
	getParameterName.searchPropertyName := '"sp3":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		sp3 := DINT_TO_UINT(atoi(ADR(getParameterName.outputValue)));
		getParameterName.searchOffset := 0;
	ELSE
		error := 8;
	END_IF;	
	
	//Find the program
	getParameterName.searchPropertyName := '"dst":';
	getParameterName.searchEndProperty := ',';
	getParameterName();
	IF getParameterName.status = ERR_OK THEN
		dst := DINT_TO_USINT(atoi(ADR(getParameterName.outputValue)));
		IF (index <= MAX_DISPLAYS) THEN
			found := found + 1;	
			bag ACCESS ADR(LiveData_Recv[index].Bag);
			bag.Cat := cat;	
			bag.Prg := prg;
			bag.Cus := cus;
			bag.Dst := dst;
			LiveData_Recv[index].Setpoints.SP1 := sp1 * 10;
			LiveData_Recv[index].Setpoints.SP2:= sp2 * 10;
			LiveData_Recv[index].Setpoints.SP3 := sp3 * 10;
			LiveData_Recv[index].Submit_Loading := 1;
		ELSE	
			error := 99;
			overRideData.responseHeader.status := '404 Not Found';
			responseData := 'Unknown display';
			httpServer.responseDataLen := LEN(responseData);
		END_IF;	
	ELSE
		error := 10;
	END_IF;	
		
	sendResponse := (found > 0);
	errorResponse := (error > 0);
	
END_ACTION
