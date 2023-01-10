
(* *Get API name from URI *)
FUNCTION FindAPI
	
	Start := LEN(ServiceName) + 2;// We must add the / character and 1 to place the cursor on the first Letter of the API name.
	Length := FIND(URI,'?');
	IF (Length = 0) THEN
		Length := LEN(URI)- LEN(ServiceName) + 1;;	
	ELSE 
		Length := Length - LEN(ServiceName) - 2;	
	END_IF;	
	
	 
	apiName := 	MID(URI,Length,Start);
	
	IF (apiName = 'ConfirmBagReEntry') THEN FindAPI := API_MAINTENANCE_CONFIRM_REENTRY;		
	ELSIF (apiName = 'Functions') THEN FindAPI := API_ST_FUNCTIONS;	
//	ELSIF (apiName = 'SendBeltLoadingConfig') THEN FindAPI := API_CUSTOM_BELT_CONFIG;		
	
	ELSIF (apiName = 'discharger-submit') THEN FindAPI := API_DISCHARGER_SUBMIT;
	ELSIF (apiName = 'abb-manual-control') THEN FindAPI := API_ABB_MANUAL_CMD;
	ELSIF (apiName = 'submit-customer-change') THEN FindAPI := API_CUSTOMER_CHANGE;		
	ELSIF (apiName = 'loading-screen-submit') THEN FindAPI := API_LOADING_SUBMIT;
	ELSIF (apiName = 'loading-screen-changed') THEN FindAPI := API_LOADING_NEWDATA;	
	ELSIF (apiName = 'loading-screen-with-tour-submit') THEN FindAPI := API_LOADING_WITH_TOUR_SUBMIT;
	ELSIF (apiName = 'loading-screen-with-tour-changed') THEN FindAPI := API_LOADING_WITH_TOUR_NEWDATA;	
	ELSIF (apiName = 'update-var-by-name') THEN FindAPI := API_UPDATE_VAR_BY_NAME;	
	ELSIF (apiName = 'commit-updates') THEN FindAPI := API_CONFIG_SAVE;
	ELSIF (apiName = 'load-config') THEN FindAPI := API_CONFIG_LOAD_NEW;	
	ELSIF (apiName = 'nedlin-get-csp-data') THEN FindAPI := API_NEDLIN_GET_CSP_DATA;	
	ELSIF (apiName = 'nedlin-set-csp-data') THEN FindAPI := API_NEDLIN_SET_CSP_DATA;	
	ELSIF (apiName = 'reset-sorting-count') THEN FindAPI := API_RESET_SORTING_COUNT;	
	ELSE FindAPI := API_UNKNOWN;
	END_IF;		
		
		
		
END_FUNCTION
