
ACTION _visu: 
	
	
		
	FOR n := 1 TO max_manualControls DO				
		
		visu_man ACCESS ADR(visu_manual[n]);
		
		selIndex := atoi(ADR(visu_man.selectedValue));
		IF (selIndex > 0) AND (selIndex <= MAX_CONTACTRON) AND (selIndex <> visu_man.selectedIndex) THEN
			updateDropDown := 1;
			visu_man.selectedIndex := DINT_TO_UINT(selIndex);
		END_IF;
		
		visu_man.ListBoxVisible := (visu_man.selectedIndex = 0);
		
		visu_man.refreshDropDown.CLK := (visu_man.selectedIndex = 0);
		visu_man.refreshDropDown();
		IF visu_man.refreshDropDown.Q THEN
			updateDropDown := 1;
		END_IF;
		
		contactron ACCESS ADR(IO_Link.Contactron[visu_man.selectedIndex]);		
		contactron.Manual.Enable := 1; //Mark Contactron as in manual mode
		
		visu_man.Visible 		:= (visu_man.selectedIndex > 0);
		IF (gSettings.Contactron[visu_man.selectedIndex].Name <> '') THEN
			visu_man.Name    		:= gSettings.Contactron[visu_man.selectedIndex].Name;
		ELSE
			itoa(visu_man.selectedIndex,ADR(sIndex));
			visu_man.Name  := 'C ';
			brsstrcat(ADR(visu_man.Name ),ADR(sIndex));
		END_IF;
										
		visu_man.Status			 	:= contactron.Status;
			
		visu_man.Error := visu_man.Status.Error OR visu_man.Status.STO_Active OR visu_man.Status.Overload_Warning
											OR visu_man.Status.MainsFailure OR visu_man.Status.PhaseLoss;
		
		errorString := '';
		// We can;t use the text from the database as it doesn;t understand the end of line characters
		IF visu_man.Status.Error THEN
			brsstrcat(ADR(errorString),ADR('Error'));//brsstrcat(ADR(errorString),ADR('$$IAT/Contactron.Error'));
			brsstrcat(ADR(errorString),ADR('\n'));
		END_IF;	
		IF visu_man.Status.STO_Active THEN
			brsstrcat(ADR(errorString),ADR('STO Active'));//brsstrcat(ADR(errorString),ADR('$$IAT/Contactron.STO'));
			brsstrcat(ADR(errorString),ADR('\n'));
		END_IF;		
		IF visu_man.Status.Overload_Warning THEN
			brsstrcat(ADR(errorString),ADR('Overload Warning'));//brsstrcat(ADR(errorString),ADR('$$IAT/Contactron.Overload'));
			brsstrcat(ADR(errorString),ADR('\n'));
		END_IF;	
		IF visu_man.Status.MainsFailure THEN
			brsstrcat(ADR(errorString),ADR('Mains Failure'));//brsstrcat(ADR(errorString),ADR('$$IAT/Contactron.MainsFailure'));
			brsstrcat(ADR(errorString),ADR('\n'));
		END_IF;	
		IF visu_man.Status.PhaseLoss THEN
			brsstrcat(ADR(errorString),ADR('Phase Loss'));//brsstrcat(ADR(errorString),ADR('$$IAT/Contactron.PhaseLoss'));
		END_IF;	
		
		brsstrcpy(ADR(visu_man.ErrorString),ADR(errorString));
		
		IF visu_man.ErrorReset THEN
			visu_man.ErrorReset := 0;		
			contactron.Manual.ErrorReset := 1;
		END_IF;	
			
		visu_man.Enable := NOT contactron.Status.Error;
		
		IF NOT visu_man.Enable THEN
			visu_man.RunReverse							:= 0;
			visu_man.RunForwards						:= 0;
			visu_man.EnableRunReverse   		:= 0;
			visu_man.EnableRunForwards			:= 0;
		ELSIF visu_man.RunForwards THEN
			contactron.Manual.RunForwards 	:= 1;
			visu_man.EnableRunReverse	  		:= 0;
		ELSIF visu_man.RunReverse THEN
			contactron.Manual.RunReverse		:= 1;
			visu_man.EnableRunForwards			:= 0;
		ELSE
			visu_man.EnableRunReverse				:= 1;
			visu_man.EnableRunForwards			:= 1;
		END_IF;
			
	END_FOR;	

	
	//Build the list box string;
	//[{'value':'text_1', 'text':'$$IAT/testText1'}, {'value':'text_2', 'text':'$$IAT/testText2'}]
	IF updateDropDown THEN
		index := 1;
		brsmemset(ADR(manualSelectDrowDown),0,SIZEOF(manualSelectDrowDown));
		manualSelectDrowDown[0] := '{"value":0,"text":""}';
		FOR n := 1 TO MAX_CONTACTRON DO	
			contactron ACCESS ADR(IO_Link.Contactron[n]);	
			IF NOT contactron.Manual.Enable THEN
				itoa(n,ADR(sIndex));
				
				IF (gSettings.Contactron[n].Name <> '') THEN
					name := gSettings.Contactron[n].Name;
				ELSE	
					name := 'C ';
					brsstrcat(ADR(name),ADR(sIndex));
				END_IF;	
				brsstrcat(ADR(manualSelectDrowDown[index]),ADR('{"value":"'));
				brsstrcat(ADR(manualSelectDrowDown[index]),ADR(sIndex));
				brsstrcat(ADR(manualSelectDrowDown[index]),ADR('","text":"'));
				brsstrcat(ADR(manualSelectDrowDown[index]),ADR(name));
				brsstrcat(ADR(manualSelectDrowDown[index]),ADR('"}'));
				index := index + 1;
			END_IF;
		END_FOR;
		updateDropDown := FALSE;	
	END_IF;	


	
	

	

END_ACTION
