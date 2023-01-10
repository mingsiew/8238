(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTest
 * File: mnTestCyclic.st
 * Author: hunholz
 * Created: March 03, 2012
 ********************************************************************
 * Implementation of program mnTest
 ********************************************************************)

PROGRAM _CYCLIC

	//====================
	// Kommandointerpreter
	//====================

	CASE _CommandoState OF
		
		_csIdle:
			
			CASE mnTestCmd.Request.Command.wCommand OF
				
				KG_CMD_NOCOMMAND:

					mnTestCmd.Response.wCmdStatus := KG_CMD_NOCOMMAND;

				MNTEST_CMD_RESET:
					
					IF mnTestCmd.Request.Command.lData0 <> MNTEST_RESETMODE_WARMSTART AND mnTestCmd.Request.Command.lData0 <> MNTEST_RESETMODE_COLDSTART THEN

						mnTestCmd.Response.wCmdStatus := KG_CMDSTAT_INVALID_PARAMETER;
						
					ELSE
						
						SYSreset(enable := TRUE, mode := UDINT_TO_USINT(mnTestCmd.Request.Command.lData0));
						mnTestCmd.Response.wCmdStatus := MNTEST_CMD_RESET;
						
					END_IF

					_CommandoState := _csWaitForNull;

				MNTEST_CMD_SETMODE:
				
					IF _wTestMode <> 0 THEN 

						mnTestCmd.Response.wCmdStatus := MNTEST_CMDSTAT_SETMODEFAILED;
						
					ELSIF mnTestCmd.Request.Command.lData0 = 0 OR mnTestCmd.Request.Command.lData0 > MNTEST_TESTMODE_MAX THEN

						mnTestCmd.Response.wCmdStatus := KG_CMDSTAT_INVALID_PARAMETER;
						
					ELSE
						
						IF IFmnParam.Out.xParamOK THEN
							_wTestMode := UDINT_TO_UINT(mnTestCmd.Request.Command.lData0);
							mnTestCmd.Response.wCmdStatus := MNTEST_CMD_SETMODE;
							_TestState := _tsSetMode;
						END_IF
					
					END_IF
					
					_CommandoState := _csWaitForNull;

				ELSE
				
					_CommandoState := _csWaitForNull;
					mnTestCmd.Response.wCmdStatus := KG_CMDSTAT_NOTVALID;
				
			END_CASE
			
			
		_csWaitForNull:
			
			IF mnTestCmd.Request.Command.wCommand = KG_CMD_NOCOMMAND THEN
				
				_CommandoState := _csIdle;
				mnTestCmd.Response.wCmdStatus := KG_CMD_NOCOMMAND;
				
			END_IF
		
		ELSE
		
			_CommandoState := _csIdle;
		
	END_CASE


	//======================
	// Statemachine Testmode
	//======================
	
	CASE _TestState OF
		
		_tsIdle:
			
			// Tue nichts
			
		_tsSetMode:
			
			_sMachineNo := WSTRING_TO_STRING(IFmnParam.Out.utfMachineNumber);
			
			_fbSetMode(enable := TRUE, pStruc := IFmnTest.In.pStrucTest, wMode := _wTestMode, sMachineNo := _sMachineNo);
			
			IF _fbSetMode.status = ERR_OK THEN
				
				IF _wTestMode = 1 THEN
					
					// Framework darf keine Meldungen mehr erzeugen und das
					// Meldesystem wird zurückgesetzt
					IFmnTest.Out.xNoMessages := TRUE;
					brsmemset(ADR(kgMsgStatus),0,SIZEOF(kgMsgStatus));
					
					_TestState := _tsPrepTest1;

				ELSIF _wTestMode = 2 THEN

					brsmemset(ADR(kgMsgStatus),0,SIZEOF(kgMsgStatus));
					
					_TestState := _tsRun;

				END_IF
					
			ELSE
				
				_TestState := _tsFault;
				
				mnTestStat.wStatus := MNTEST_STAT_ERRFBSETMODE;
				mnTestStat.sStatus := UINT_TO_STRING(_fbSetMode.status);
				
			END_IF
		
		_tsPrepTest1:
		
		
			_doInfoCfg.enable := TRUE;	// VAR_INPUT BOOL enable 'enables execution'
			_doInfoCfg.pName := ADR('CfgMsgStat');	// VAR_INPUT UDINT pName 'name of data object'
			_doInfoCfg();
			
			IF _doInfoCfg.status = ERR_OK THEN
			
				_wMsgCnt := UDINT_TO_UINT((_doInfoCfg.len-SIZEOF(UINT))/SIZEOF (MsgCfgLine_Typ)); // Laenge der Version zu Beginn abziehen
				
				IF _wMsgCnt > 0 AND _wMsgCnt <= MNMSG_MAX_CFGMESSAGES THEN
	
					_MsgCfgList ACCESS _doInfoCfg.pDatObjMem + SIZEOF(UINT);
					_TestState := _tsRun;
					
				ELSE
					// Meldungskonfiguration fehlerhaft
					_TestState := _tsFault;

					mnTestStat.wStatus := MNTEST_STAT_ERRMSGCFGCNT;
					mnTestStat.sStatus := UINT_TO_STRING(_wMsgCnt);

				END_IF
			
			ELSE
				// Meldungskonfiguration fehlt
				_TestState := _tsFault;
				mnTestStat.wStatus := MNTEST_STAT_ERRMSGCFG;
				mnTestStat.sStatus := UINT_TO_STRING(_doInfoCfg.status);
				
			END_IF
		

		_tsRun:
			
			_fbRunTest(enable := TRUE, pStruc := IFmnTest.In.pStrucTest, wMode := _wTestMode, sMachineNo := _sMachineNo);
			
			IF _fbRunTest.status = KG_ERR_NULPOINTER THEN
				
				_TestState := _tsFault;

				mnTestStat.wStatus := MNTEST_STAT_FBRUNTEST;
				mnTestStat.sStatus := UINT_TO_STRING(_fbRunTest.status);
				
			END_IF
		
			// ACTION RUN MessageTest
			
			IF _wTestMode = 1 THEN
				_MessageTest1;
			END_IF
		
			
		_tsFault:
			
			// Tue erstmal nichts
		
	END_CASE
	
	mnTestStatAd.wMode := _wTestMode;
	
END_PROGRAM
