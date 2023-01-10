
TYPE
	abb_visu_manual_typ : 	STRUCT 
		Visible : BOOL; (**Are the controls Visible*)
		Name : STRING[50];
		Node : USINT;
		ModuleOk : BOOL;
		ActVelocity : INT; (*RPM*)
		ActCurrent : DINT;
		ActTorque : DINT;
		ErrorCode : UINT;
		RunReverse : BOOL;
		RunForwards : BOOL;
		State : STRING[40]; (**Text picker was being a pain in group box so print string output.*)
		TargetVelocity : INT;
		ErrorReset : BOOL;
		ErrorActive : BOOL;
		selectedIndex : UINT;
		selectedValue : STRING[10];
		refreshDropDown : R_TRIG;
		ListBoxVisible : BOOL;
		EnableRunReverse : BOOL;
		EnableRunForwards : BOOL;
	END_STRUCT;
END_TYPE
