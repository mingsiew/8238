//-----------------------------------------
//--AsEPL library Status Error Codes-------
//-----------------------------------------

//Error									Description
//0  										No error 
//65534  								Function block parameter "enable" not equal to 1 
//65535  								Function block still working 
      
//31340  								Basis of error numbers, internal error 
//31341  								Specified device not a POWERLINK interface 
//31342  								Function can only be executed on an MN (managing node). 
//31343  								Function can only be executed on a CN (controlled node). 
//31344  								Read or write access failed. See errorinfo for the precise cause of the error. 
//31345  								Input parameters outside of permitted value range 
//31346  								Specified index already exists 
//31347  								Specified subindex already exists 
//31348  								Specified index does not exist 
//31349  								Specified subindex does not exist 
//31392  								Null pointer given as data buffer 
//31399  								Error code for non-implemented functionality 


//-----------------------------------------
//-----AsEPL library Error Info Codes------
//-----------------------------------------

//Error									Description
//16#0504_0000 					SDO communication timeout. 
//16#0504_0001 					Invalid or unknown client/server command. 
//16#0504_0002 					Size of transferred data invalid. 
//16#0504_0003 					Error in sequence layer. 
//16#0504_0005 					Could not allocate enough memory. 
//16#0601_0000 					Cannot access object. 
//16#0601_0001 					Attempted to read a write-only object. 
//16#0601_0002 					Attempted to write a read-only object. 
//16#0602_0000 					Object not in object dictionary. 
//16#0604_0041 					Attempted to map an object in the PDO that doesn't support it. 
//16#0604_0042 					Assignment would exceed PDO length. 
//16#0604_0043 					General parameter incompatibility. 
//16#0604_0047 					General device incompatibility. 
//16#0606_0000 					Access failed due to hardware error. 
//16#0607_0010 					Data type doesn't match the length of the access. 
//16#0607_0012 					Length of the access is larger than the length of the data type. 
//16#0607_0013 					Length of the access is smaller than the length of the data type. 
//16#0609_0011 					Subindex does not exist. 
//16#0609_0030 					Invalid value range. 
//16#0609_0031 					Value too high for value range. 
//16#0609_0032 					Value too low for value range. 
//16#0609_0036 					Maximum value less than minimum value. 
//16#0800_0000 					General error. 
//16#0800_0020 					Cannot transfer or store data. 
//16#0800_0021 					Data cannot be transferred or stored since it's being used locally by the device. 
//16#0800_0022 					Data cannot be transferred or saved due to the device state. 

ACTION _encodeParameters:
	//Clear all parameters
	FOR i:= 1 TO MAX_PARAMS DO
		//Clear stauts/error
		drive.Config.params[i].status := 1; //Set to 1 here, if not cleared when written is shows it has not been written
		drive.Config.params[i].errorInfo := 0;		
	END_FOR;
	
	//Set all parameters
	//Brake Function
	drive.Config.params[1].index := 16#402C;	//Brake Control Enable 44.06
	drive.Config.params[1].subIndex := 16#6;
	drive.Config.params[1].data := BOOL_TO_DINT(settings.BrakeFitted);	//Enable brake control
	drive.Config.params[1].datalen := 4;
	
	drive.Config.params[2].index := 16#400A;	//RO1 Source 10.24
	drive.Config.params[2].subIndex := 16#18;
	drive.Config.params[2].data := 22;	//Relay is active when brake is active
	drive.Config.params[2].datalen := 4;
	
	//Motor Data
	drive.Config.params[3].index := 16#4063;	//Motor Nominal Voltage 99.07
	drive.Config.params[3].subIndex := 16#7;
	drive.Config.params[3].data := 4150;	//415V
	drive.Config.params[3].datalen := 4;
	
	drive.Config.params[4].index := 16#4063;	//Motor Nominal Frequency 99.08
	drive.Config.params[4].subIndex := 16#8;
	drive.Config.params[4].data := 5000;	//50Hz
	drive.Config.params[4].datalen := 4;
	
	drive.Config.params[5].index := 16#4063;	//Motor Power Factor 99.11
	drive.Config.params[5].subIndex := 16#B;
	drive.Config.params[5].data := 80;	//0.8
	drive.Config.params[5].datalen := 4;
	
	drive.Config.params[6].index := 16#4063;	//Motor Control Mode 99.04
	drive.Config.params[6].subIndex := 16#4;
	drive.Config.params[6].data := 1;	//Scalor
	drive.Config.params[6].datalen := 2;
	
	//Limits
	drive.Config.params[7].index := 16#401E;	//Max Current 30.17
	drive.Config.params[7].subIndex := 16#11;
	drive.Config.params[7].data := maxCurrent;
	drive.Config.params[7].datalen := 4;
	
	drive.Config.params[8].index := 16#401E;	//Max Frequency 30.14
	drive.Config.params[8].subIndex := 16#E;
	drive.Config.params[8].data := ABB_MAX_VELOCITY * 100;	//60Hz
	drive.Config.params[8].datalen := 4;
	
	//Fault Functions
	//	drive.Config.params[9].index := 16#401F;	//External Event 1 Source 31.01
	//	drive.Config.params[9].subIndex := 16#1;
	//	drive.Config.params[9].data := 2;	//Digital Input 1 Triggers Fault When Low
	//	drive.Config.params[9].datalen := 4;
	
	drive.Config.params[9].index := 16#4032;	//Comms loss function 50.02
	drive.Config.params[9].subIndex := 16#2;
	drive.Config.params[9].data := 1;	//Fault on comms loss
	drive.Config.params[9].datalen := 2;
		
	//Other
	drive.Config.params[10].index := 16#4014;	//External Commands 20.01
	drive.Config.params[10].subIndex := 16#1;
	drive.Config.params[10].data := 12;	//Fieldbus A Selected
	drive.Config.params[10].datalen := 2;
	
	drive.Config.params[11].index := 16#401C;	//Frequency Ext 1 Ref 28.11
	drive.Config.params[11].subIndex := 16#B;
	drive.Config.params[11].data := 4;	//Fieldbus A As Ref
	drive.Config.params[11].datalen := 4;	
	
	drive.Config.params[12].index := 16#401F;	//STO Indication 31.22
	drive.Config.params[12].subIndex := 16#16;
	drive.Config.params[12].data := 3;	//Warning/Warning
	drive.Config.params[12].datalen := 2;	
	
	drive.Config.params[13].index := 16#4013;	//Disable local mode 19.17
	drive.Config.params[13].subIndex := 16#11;
	drive.Config.params[13].data := BOOL_TO_DINT(NOT Std.Drives_AllowLocalMode);// 0 = Enabled ,1 = Locked
	drive.Config.params[13].datalen := 2;
	
	drive.Config.params[14].index := 16#4032;	//Comm loss time out 50.03
	drive.Config.params[14].subIndex := 16#3;
	drive.Config.params[14].data := 15;	//1 second
	drive.Config.params[14].datalen := 2;
	
	drive.Config.params[15].index := 16#401E;	//Min Frequency 30.13
	drive.Config.params[15].subIndex := 16#D;
	drive.Config.params[15].data := ABB_MAX_VELOCITY * -100;
	drive.Config.params[15].datalen := 4;
	
	drive.Config.params[16].index := 16#4063;	//Nominal Current 9906
	drive.Config.params[16].subIndex := 16#6;
	drive.Config.params[16].data := nominalCurrent_9906;
	drive.Config.params[16].datalen := 4;
	
	drive.Config.params[17].index := 16#4063;	//Nominal Speed 9909
	drive.Config.params[17].subIndex := 16#9;
	drive.Config.params[17].data := nominalSpeed_9909;
	drive.Config.params[17].datalen := 4;
	
	drive.Config.params[18].index := 16#4063;	//Nominal Power 9910
	drive.Config.params[18].subIndex := 16#A;
	drive.Config.params[18].data := nominalPower_9910;
	drive.Config.params[18].datalen := 4;
	
	drive.Config.params[19].index := 16#401C;	//Acc time 2872  1500 = 1.5secs
	drive.Config.params[19].subIndex := 16#48;
	drive.Config.params[19].data := accTime;
	drive.Config.params[19].datalen := 4;
	
	drive.Config.params[20].index := 16#401C;	//Dec time 2873
	drive.Config.params[20].subIndex := 16#49;
	drive.Config.params[20].data := decTime;
	drive.Config.params[20].datalen := 4;
		
	
END_ACTION
