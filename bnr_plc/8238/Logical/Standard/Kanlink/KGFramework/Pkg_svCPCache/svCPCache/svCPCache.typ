(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: svCPCache
 * File: svCPCache.typ
 * Author: hunholz
 * Created: March 29, 2012
 ********************************************************************
 * Local data types of program svCPCache
 ********************************************************************)

TYPE
	enum_CmdCP : 
		(
		cs_CmdIdle,
		cs_CmdSave,
		cs_CmdWaitForDB,
		cs_CmdImport,
		cs_CmdWaitForNoCommand
		);
	enum_ImportCP : 
		(
		cs_ImpIdle,
		cs_ImpStart,
		cs_ImpFileOpen,
		cs_ImpFileRead,
		cs_ImpFileClose,
		cs_ImpParse,
		cs_ImpRdySuccess,
		cs_ImpRdyFault
		);
	enum_SaveCP : 
		(
		cs_SaveIdle,
		cs_SaveCreateCSV,
		cs_SaveDeleteFile,
		cs_SaveCreateFile,
		cs_SaveOpenFile,
		cs_SaveWriteFile,
		cs_SaveCloseFile,
		cs_SaveRdySuccess,
		cs_SaveRdyFault
		);
END_TYPE
