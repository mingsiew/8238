(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: mnTest
 * File: _MessageTest1.st
 * Author: hunholz
 * Created: March 07, 2012
 ********************************************************************
 * Implementation of program mnTest
 ********************************************************************) 

(* Meldungen zyklisch bearbeiten *)
ACTION _MessageTest1: 
	
	_TONmsgclk1(IN := NOT _TONmsgclk2.Q, PT := _tMsgGap);
	_TONmsgclk2(IN := _TONmsgclk1.Q, PT := T#100ms);
	
	// Bug 781 : Meldungsabstände in der Simulation sporadisch verkürzen
	
	IF EDGEPOS(_TONmsgclk1.Q) THEN
		_wMsgTick := _wMsgTick + 1;
		_lGap := DINT_TO_UDINT( ((ABS(IFmnSystem.In.PLC.diSystemTime) / 100000 / 3) MOD 100) * 100);
		_tMsgGap := UDINT_TO_TIME(_lGap);
	END_IF
	
	IF _wMsgTick > _MNTEST_MAX_MSGGROUPS THEN
		_wMsgTick := 1;
	END_IF
	
	FOR _ii := 1 TO _MNTEST_MAX_MSGGROUPS DO

		
		CASE _wStateMsgTest[_ii] OF
			
			0:
				IF (_ii + _wMsgIdxOffset[_ii]) <= _wMsgCnt THEN
					// Warte auf Meldungsbeginn
					IF _ii = _wMsgTick THEN
						// Meldung setzen
						_xReason[_ii] := TRUE;
						kgMsgStatus[_ii].wFunction_ID := _MsgCfgList[_ii+_wMsgIdxOffset[_ii]].wFunction_ID;
						kgMsgStatus[_ii].wInstance := _MsgCfgList[_ii+_wMsgIdxOffset[_ii]].wInstance;
						
						IF _wMsgClass[_ii MOD 5] = MNMSG_CLASS_MAINTENANCE THEN
							kgMsgStatus[_ii].diMaintAttr1 := _ii;
							kgMsgStatus[_ii].diMaintAttr2 := _ii + 100;
							kgMsgStatus[_ii].sMaintAttrTxt := UINT_TO_STRING(_ii);
							kgMsgStatus[_ii].wMaintAckLevel := MNMSG_CLASS_NO_ACK;
							kgMsgStatus[_ii].wMaintNumber := _MsgCfgList[_ii+_wMsgIdxOffset[_ii]].wMsgNumber;
							kgMsgStatus[_ii].wMsgClass := MNMSG_CLASS_MAINTENANCE;
						ELSE
							kgMsgStatus[_ii].diMsgAttr1 := _ii;
							kgMsgStatus[_ii].diMsgAttr2 := _ii + 100;
							kgMsgStatus[_ii].sMsgAttrTxt := UINT_TO_STRING(_ii);
							kgMsgStatus[_ii].wMsgAckLevel := SEL((_wMsgClass[_ii MOD 4] < 10),0,MNMSG_CLASS_NO_ACK);
							kgMsgStatus[_ii].wMsgNumber := _MsgCfgList[_ii+_wMsgIdxOffset[_ii]].wMsgNumber;
							kgMsgStatus[_ii].wMsgClass := _wMsgClass[_ii MOD 5];
						END_IF							
						
						_wStateMsgTest[_ii] := 1;
						
					END_IF
				ELSE
					_wMsgIdxOffset[_ii] := 0;
				END_IF
				
			1:
				// Warte bis Meldung beendet
				IF _TONMsg[_ii].Q THEN
					
					_xReason[_ii] := FALSE;
					
					IF kgMsgStatus[_ii].wMaintAckLevel = MNMSG_CLASS_NO_ACK THEN
						
						kgMsgStatus[_ii].wMaintAckLevel := _ii MOD 4;
						_wStateMsgTest[_ii] := 10;
						
					ELSIF kgMsgStatus[_ii].wMsgAckLevel = MNMSG_CLASS_NO_ACK THEN

						kgMsgStatus[_ii].wMsgAckLevel := _ii MOD 4;
						_wStateMsgTest[_ii] := 20;

					ELSE
						
						_wStateMsgTest[_ii] := 99;
						
					END_IF
					
				END_IF
				
			10:
			// Warten auf Wartungsquittierung
			
				IF kgMsgStatus[_ii].xAckMaint THEN
					kgMsgStatus[_ii].xAckRead := TRUE;
					_wStateMsgTest[_ii] := 99;
				END_IF

			20:
				// Warten auf Störungsquittierung
			
				IF kgMsgStatus[_ii].xAckFault THEN
					kgMsgStatus[_ii].xAckRead := TRUE;
					_wStateMsgTest[_ii] := 99;
				END_IF

			99:
				// Meldung entfernen
				kgMsgStatus[_ii].diMaintAttr1 := 0;
				kgMsgStatus[_ii].diMaintAttr2 := 0;
				kgMsgStatus[_ii].sMaintAttrTxt := '';
				kgMsgStatus[_ii].wMaintAckLevel := 0;
				kgMsgStatus[_ii].wMaintNumber := 0;
				kgMsgStatus[_ii].xAckRead := FALSE;
				kgMsgStatus[_ii].wMsgClass := 0;
				kgMsgStatus[_ii].diMsgAttr1 := 0;
				kgMsgStatus[_ii].diMsgAttr2 := 0;
				kgMsgStatus[_ii].sMsgAttrTxt := '';
				kgMsgStatus[_ii].wMsgAckLevel := 0;
				kgMsgStatus[_ii].wMsgNumber := 0;
				kgMsgStatus[_ii].wFunction_ID := 0;
				kgMsgStatus[_ii].wInstance := 0;

				_wStateMsgTest[_ii] := 100;
				
			100:
				// Warten bis Wartezeit beendet
				IF _TONMsgPause[_ii].Q THEN
					_wMsgIdxOffset[_ii] := _wMsgIdxOffset[_ii] + _MNTEST_MAX_MSGGROUPS;
					_wStateMsgTest[_ii] := 0;
				END_IF
			
		END_CASE
		
		_TONMsg[_ii](IN := _xReason[_ii], PT := T#10m);
		_TONMsgPause[_ii](IN := NOT _xReason[_ii], PT := T#4m);
		
	END_FOR
	
END_ACTION