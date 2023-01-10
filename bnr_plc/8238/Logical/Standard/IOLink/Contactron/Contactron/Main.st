(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * PROGRAM: IOLink
 * File: IOLink_Driver.s
 * Author: Stephen Healy NOT ANYMORE :)
 * Created: Sept 05, 2018
 ********************************************************************
 * Implementation OF PROGRAM IOLink
 ********************************************************************)
//V1.00.1 First Release
//V1.00.1 TR 10/11/2020  - Remove run signal from contactron when there is a fault to allow the error to be acknowledged.
//V1.00.2 TR 07/04/2021  - Add Test mode

//V2.00.1 -- Remove dependency on shitty firmware hack- Add mappview visu support

PROGRAM _INIT



END_PROGRAM

PROGRAM _CYCLIC

	
	//Call contactron action
	IF MAX_CONTACTRON > 0 THEN
		_visu;
		_Contactron;
	
	END_IF;

	
END_PROGRAM