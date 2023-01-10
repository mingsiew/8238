/********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: MbusTCP
 * Author: strickers
 * Created: October 29, 2009
 *******************************************************************/
#include <MBdeclarations.h>

/* ------------------------------------------------------------------------------------------------- */
/* Swap or not swap, that is the question */
/* ------------------------------------------------------------------------------------------------- */
UINT MySwapUINT(UINT data)
{
	if(IsI386) return swapINT(data);
	return data;
}
INT MySwapINT(INT data)
{
	if(IsI386) return swapINT(data);
	return data;
}

/* ------------------------------------------------------------------------------------------------- */
/* Generate logbook message for requests and responses */
/* ------------------------------------------------------------------------------------------------- */
void MessageLog (USINT type, USINT function_code, UINT start_addr, UINT length, modbus_log_typ LOGBOOK)
{
	STRING str1[LOG_LINE_LEN];
	STRING str2[LOG_LINE_LEN];

	if(DEBUG_LEVEL ==1) return;
	
	if (type == TYP_REQUEST)
	{
		strcpy(str1, "Request FCT:");
		itoa(function_code, (UDINT)&str2);
		strcat(str1, str2);
		strcat(str1, " ADR:");
		itoa(start_addr, (UDINT)&str2);
		strcat(str1, str2);
		strcat(str1, " LEN:");
		itoa(length, (UDINT)&str2);
		strcat(str1, str2);
	}
	else if (type == TYP_RESPONSE)
	{
		strcpy(str1, "Response FCT:");
		itoa(function_code, (UDINT)&str2);
		strcat(str1, str2);
		strcat(str1, " ok");
	}
	NewLogEntry(str1, LOGBOOK);	
}

/* ------------------------------------------------------------------------------------------------- */
/*	Generate logbook message */
/* ------------------------------------------------------------------------------------------------- */
void NewLogEntry (STRING message[LOG_LINE_LEN], modbus_log_typ LOGBOOK)
{
	RTCtime_typ	RTCtime_struct;
	STRING		lstr1[LOG_LINE_LEN], lstr2[LOG_LINE_LEN];
	
	/* Check if logging is enabled before writing to log */
	if ((LOGBOOK.data_lines > 0) && (LOGBOOK.pData != 0))
	{
		strcpy(lstr1, "");
		strcpy(lstr2, "");
		RTC_gettime(&RTCtime_struct);
		itoa(RTCtime_struct.hour, (UDINT)&lstr1);
		if(strlen(lstr1) == 1) strcat(lstr2, "0");
		strcat(lstr2, lstr1);
		strcat(lstr2, ":");
		itoa(RTCtime_struct.minute, (UDINT)&lstr1);
		if(strlen(lstr1) == 1) strcat(lstr2, "0");
		strcat(lstr2, lstr1);
		strcat(lstr2, ":");
		itoa(RTCtime_struct.second, (UDINT)&lstr1);
		if(strlen(lstr1) == 1) strcat(lstr2, "0");
		strcat(lstr2, lstr1);
		strcat(lstr2, ":");
		itoa(RTCtime_struct.millisec, (UDINT)&lstr1);
		if(strlen(lstr1) == 1) strcat(lstr2, "00");
		if(strlen(lstr1) == 2) strcat(lstr2, "0");
		strcat(lstr2, lstr1);
		strcat(lstr2, " ");
		strcat(lstr2, message);
		memmove((void*)(LOGBOOK.pData)+LOG_LINE_LEN+1, (void*)LOGBOOK.pData, (LOG_LINE_LEN+1)*(LOGBOOK.data_lines-1));
		strcpy((void*)LOGBOOK.pData, lstr2);
	}
}
