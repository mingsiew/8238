(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnParam
 * File: _actInterfacePC.st
 * Author: hunholz
 * Created: March 28, 2012
 ********************************************************************
 * Implementation of program mnParam
 ********************************************************************) 

(* Kommando-Interface zum PC über mnParamCmd *)
ACTION _actInterfacePC:
	
	CASE _PmIntern.enCycMainState OF

		cs_MainIdle:

			//************************************************
			// Kein PC-Befehl aktiv. Warte auf Befehl
			//************************************************
				
			CASE mnParamCmd.Request.Command.wCommand OF
						
				MNPARAM_CMD_NOCOMMAND:
					
					mnParamCmd.Response.wCmdStatus := MNPARAM_STAT_NOCOMMAND;
					
				MNPARAM_CMD_IMPORT:

					IF _xAllowCommands THEN

						_xAllowCommands := FALSE;
						
						// Warten bis Import abgeschlossen
						_PmIntern.enCycMainState := cs_MainImport;
							
						// Wir MNPARAM_IMPORT_RESTORE als Attribut mitgegeben, werden vor dem Import
						// alle Variablen auf Default gesetzt.
						_wImpSource := UDINT_TO_UINT(mnParamCmd.Request.Command.lData0);
						_xImpSetDefault := mnParamCmd.Request.Command.lData1 = MNPARAM_IMPORT_RESTORE;
							
						mnParamCmd.Response.wCmdStatus := KG_STAT_BUSY;
							
						_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTIMPORT;
						_LogEntryIn.lAttr1 := mnParamCmd.Request.Command.lData0;
						_LogEntryIn.lAttr2 := mnParamCmd.Request.Command.lData1;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

						// Starte Import
						_PmIntern.enCycImpState := cs_ImpStart;

					ELSE

						// Kommando ablehnen
						mnParamCmd.Response.wCmdStatus := KG_CMDSTAT_NOTREADY;
						_PmIntern.enCycMainState := cs_MainWaitCmdZero;
							
					END_IF
						
				MNPARAM_CMD_DELETE:

					IF _xAllowCommands THEN
							
						_xAllowCommands := FALSE;

						// Warten bis Delete abgeschlossen
						_PmIntern.enCycMainState := cs_MainDelete;
							
						// Parameter übernehmen
						_wDelCont := UDINT_TO_UINT(mnParamCmd.Request.Command.lData0);
						_wDelInst := UDINT_TO_UINT(mnParamCmd.Request.Command.lData1);
							
						mnParamCmd.Response.wCmdStatus := KG_STAT_BUSY;
							
						_LogEntryIn.wErrorNo := _MNPARAM_LOG_STARTDELETE;
						_LogEntryIn.lAttr1 := mnParamCmd.Request.Command.lData0;
						_LogEntryIn.lAttr2 := mnParamCmd.Request.Command.lData1;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

						// Starte Delete
						_PmIntern.enCycDelState := cs_DelStart;

					ELSE
							
						// Kommando ablehnen
						mnParamCmd.Response.wCmdStatus := KG_CMDSTAT_NOTREADY;
						_PmIntern.enCycMainState := cs_MainWaitCmdZero;
							
					END_IF
						
				ELSE
					// ungültiges Kommando
					mnParamCmd.Response.wCmdStatus := KG_CMDSTAT_NOTVALID;
					_PmIntern.enCycMainState := cs_MainWaitCmdZero;
						
			END_CASE
			
		cs_MainImport:

			mnParamCmd.Response.wCmdStatus := KG_STAT_BUSY;
			
			// Warten bis Import fertig ist
			IF _PmIntern.enCycImpState = cs_ImpRdySuccess THEN
					
				// ERFOLG
				
				// Import Statemachine zurücksetzen
				_PmIntern.enCycImpState := cs_ImpIdle;
					
				// Rückmeldung OK
				mnParamCmd.Response.wCmdStatus := MNPARAM_CMD_IMPORT;
					
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDIMPORT_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
				
				_actFillNamelist;

				_PmIntern.enCycMainState := cs_MainWaitCmdZero;

			ELSIF _PmIntern.enCycImpState = cs_ImpRdyFault THEN
					
				// FEHLER
					
				// Import Statemachine zurücksetzen
				_PmIntern.enCycImpState := cs_ImpIdle;

				// Fehlercode für Rückmeldung übernehmen
				mnParamCmd.Response.wCmdStatus := MAX(59999,DINT_TO_UINT(_PmIntern.Status.diMsgAttr1));

				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDIMPORT_FAILED;
				_LogEntryIn.lAttr1 := mnParamCmd.Response.wCmdStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

				// Warnung ausgeben
				_PmIntern.enCycMainState := cs_MainWarning;

			END_IF	
					
		cs_MainDelete:

			mnParamCmd.Response.wCmdStatus := KG_STAT_BUSY;

			// Warten bis Delete fertig ist
			IF _PmIntern.enCycDelState = cs_DelRdySuccess THEN
				
				// ERFOLG
					
				// Delete Statemachine zurücksetzen
				_PmIntern.enCycDelState := cs_DelIdle;

				// Rückmeldung OK
				mnParamCmd.Response.wCmdStatus := MNPARAM_CMD_DELETE;
				
				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDDELETE_SUCC;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
				
				IF _wDelCont = MNPARAM_IDX_PROGCONTAINER THEN
					
					_actFillNamelist;
					
				END_IF

				_PmIntern.enCycMainState := cs_MainWaitCmdZero;

			ELSIF _PmIntern.enCycDelState = cs_DelRdyFault THEN
					
				// FEHLER
					
				// Delete Statemachine zurücksetzen
				_PmIntern.enCycDelState := cs_DelIdle;

				// Fehlercode als Rückmeldung
				mnParamCmd.Response.wCmdStatus := MAX(59999,DINT_TO_UINT(_PmIntern.Status.diMsgAttr1));

				_LogEntryIn.wErrorNo := _MNPARAM_LOG_ENDDELETE_FAILED;
				_LogEntryIn.lAttr1 := mnParamCmd.Response.wCmdStatus;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

				// Warnung ausgeben
				_PmIntern.enCycMainState := cs_MainWarning;

			END_IF	
			
		cs_MainWarning:

			//*****************
			// Warnung ausgeben
			//*****************
				
			mnParamCmd.Response.wCmdStatus := MAX(59999,DINT_TO_UINT(_PmIntern.Status.diMsgAttr1));
			
			IF TONwarn.Q THEN

				// Warnungszeit ist abgelaufen
					
				// Warnung zurücksetzen					
				brsmemset(ADR(_PmIntern.Status), 0, SIZEOF(_PmIntern.Status));
				_PmIntern.Status.wFunction_ID := MNPARAM_FUNCTIONID;
					
				// Auf Rücksetzen des Kommandos warten
				_PmIntern.enCycMainState := cs_MainWaitCmdZero;
					
			END_IF
				
		cs_MainWaitCmdZero:

			//**********************************************
			// Warten, dass das Kommando zurückgenommen wird
			//**********************************************

			IF mnParamCmd.Request.Command.wCommand = MNPARAM_CMD_NOCOMMAND THEN
					
				mnParamCmd.Response.wCmdStatus := MNPARAM_STAT_NOCOMMAND;
				_PmIntern.enCycMainState := cs_MainIdle;
					
			END_IF
			
	END_CASE
		
	// Warnung soll für 10 Sekunden anstehen
	TONwarn(IN := _PmIntern.enCycMainState = cs_MainWarning, PT := T#10s);

END_ACTION