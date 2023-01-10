(********************************************************************
 * COPYRIGHT -- Kannegiesser GmbH
 ********************************************************************
 * Program: mnSystem
 * File: mnSystemCyclic.st
 * Author: Hunholz
 * Created: Mar 16, 2012
 ********************************************************************
 * Implementation of program mnSystem
 ********************************************************************)

PROGRAM _CYCLIC

	//**********************
	// USB Knoten überwachen
	//**********************
	
	// Alle 5 Sekunden eine Liste der verfügbaren Sticks zur Verfügung stellen
		
	_TONsearchForUSB(IN := _wUSBstate = 0 , PT := T#5s);
		
	CASE _wUSBstate OF
			
		0:

			IFmnSystem.Out.sInterfaceUSB := _sInterfaceUSB;
			IFmnSystem.Out.xUSBStickReady := _xUSBStickReady;

			IF _TONsearchForUSB.Q OR _xFirstScan THEN
					
				_xFirstScan := FALSE;
				_wUSBstate := 1;
					
			END_IF
				
		1:
			_UsbNodeListGet(enable := TRUE, pBuffer := ADR(_lUSBlist), bufferSize := SIZEOF(_lUSBlist), filterInterfaceClass := asusb_CLASS_MASS_STORAGE, filterInterfaceSubClass := asusb_SUBCLASS_SCSI_COMMAND_SET);
				
			IF _UsbNodeListGet.status <> ERR_FUB_BUSY THEN

				_sInterfaceUSB := '';
				_xUSBStickReady := FALSE;
				
				IF _UsbNodeListGet.status = ERR_OK THEN
					
					_wUSBstate := 2;
					
					_wCycleFound := _wCycleFound + 1;

				ELSE

					IFmnSystem.Out.xUSBStickScanned := TRUE;
					_wUSBstate := 0;

					_wCycleNotFound := _wCycleNotFound + 1;

				END_IF
				
			END_IF
					
		2:
			
			_UsbNodeGet(enable := TRUE, nodeId := _lUSBlist[1], pBuffer := ADR(_usbNode), bufferSize := SIZEOF(_usbNode));
					
			IF _UsbNodeGet.status <> ERR_FUB_BUSY THEN

				IF _UsbNodeGet.status = ERR_OK THEN

					brsmemcpy(ADR(_sInterfaceUSB),ADR(_usbNode.ifName),SIZEOF(_sInterfaceUSB));
					_xUSBStickReady := TRUE;		

					_wCycleReady := _wCycleReady + 1;

				END_IF
				
				IFmnSystem.Out.xUSBStickScanned := TRUE;
				IFmnSystem.Out.sInterfaceUSB := _sInterfaceUSB;
				IFmnSystem.Out.xUSBStickReady := _xUSBStickReady;

				_wUSBstate := 0;
			
			END_IF

		ELSE
			
			_wUSBstate := 0;

	END_CASE
	
	//#####################################################################################################################
	
	// Heartbeeat erzeugen (Sekunden)
	_GetTime(enable := TRUE);
	mnSystemStatAd.wHeartbeat := DT_TO_UINT(_GetTime.DT1);
	
	_diDifSystime := IFmnSystem.In.PLC.diSystemTime - _diOldSysTime;
	_diOldSysTime := IFmnSystem.In.PLC.diSystemTime;
	
	IF _diDifSystime >= 0 THEN
		
		_l1sCount := _l1sCount + DINT_TO_UDINT(_diDifSystime);
		
		IF _l1sCount > 1000000 THEN
			
			IFmnSystem.Out.x1s := NOT IFmnSystem.Out.x1s;
			_l1sCount := _l1sCount - 1000000;
			
		END_IF

		_l500msCount := _l500msCount + DINT_TO_UDINT(_diDifSystime);
		
		IF _l500msCount > 500000 THEN
			
			IFmnSystem.Out.x500ms := NOT IFmnSystem.Out.x500ms;
			_l500msCount := _l500msCount - 500000;
			
		END_IF

	END_IF

	// Lüfterüberwachung

	CASE IFmnSystem.In.PLC.wMDL_ID OF
		
		KG_CPU_X20CP1486:
			
			_xFanOk := IFmnSystem.In.PLC.xFanOk;
			
		ELSE
			
			_xFanOk := TRUE;
		
	END_CASE
	
	//********************************
	// Überwachung Umgebungstemperatur
	//********************************
	
	_TONtemp(IN := (IFmnSystem.In.PLC.wTemperatureENV > mnSystemPar.Mac.wWarnTemperatureEnvironment) AND IFmnParam.Out.xParamOK, PT := T#10m);
	_TONtempC(IN := (IFmnSystem.In.PLC.wTemperatureENV > (mnSystemPar.Mac.wWarnTemperatureEnvironment - 50)) AND IFmnParam.Out.xParamOK, PT := T#10m);

	//************************
	// Überwachung von Modulen
	//************************

	IF IFmnParam.Out.xParamOK THEN
		
		_xModuleFault := FALSE;
		_wModuleFaultLineNumber := 0;
		_wModuleFaultModuleNumber := 0;
		
		FOR _ii := 1 TO MNSYSTEM_CNT_MODULELINES DO
			
			FOR _jj := 1 TO MNSYSTEM_CNT_MODULES DO

				IF mnSystemPar.Cfg.Lines[_ii].wModuleID[_jj] <> KG_MODULE_NO THEN
					
					// Modul ist konfiguriert

					IF (mnSystemPar.Cfg.Lines[_ii].wModuleID[_jj] <> IFmnSystem.In.ModuleInfo[_ii,_jj].wMDL_ID) THEN
						_xModuleFault := TRUE;
						_wModuleFaultLineNumber := _ii;
						_wModuleFaultModuleNumber := _jj;
						EXIT;
					END_IF
					
				END_IF
				
			END_FOR
			
			IF _xModuleFault THEN
				EXIT;
			END_IF
			
		END_FOR
		
		// Cooling
		
		FOR _iC := 1 TO 2 DO
			
			IF NOT _xCInitDone[_iC] THEN
				
				IF mnSystemPar.Cfg.BindingMotProtCooling[_iC].wBindIndexModul > 0 AND mnSystemPar.Cfg.BindingMotProtCooling[_iC].wBindIndexModul <= MNSYSTEM_CNT_MODULES 
					AND mnSystemPar.Cfg.BindingMotProtCooling[_iC].wBindIndexChannel > 0 AND mnSystemPar.Cfg.BindingMotProtCooling[_iC].wBindIndexChannel <= 12 THEN
					
					_BindMotProtCooling[_iC].wModule := mnSystemPar.Cfg.BindingMotProtCooling[_iC].wBindIndexModul;
					_BindMotProtCooling[_iC].wChannel := mnSystemPar.Cfg.BindingMotProtCooling[_iC].wBindIndexChannel;
					_BindMotProtCooling[_iC].sDiscription := mnSystemPar.Cfg.BindingMotProtCooling[_iC].sDiscription;
					_BindMotProtCooling[_iC].xInvers := mnSystemPar.Cfg.BindingMotProtCooling[_iC].xInvers;
					_BindMotProtCooling[_iC].xQualitiyOk := TRUE;

				END_IF

				IF mnSystemPar.Cfg.BindingOutCooling[_iC].wBindIndexModul > 0 AND mnSystemPar.Cfg.BindingOutCooling[_iC].wBindIndexModul <= MNSYSTEM_CNT_MODULES 
					AND mnSystemPar.Cfg.BindingOutCooling[_iC].wBindIndexChannel > 0 AND mnSystemPar.Cfg.BindingOutCooling[_iC].wBindIndexChannel <= 12 THEN
					
					_BindingOutCooling[_iC].wModule := mnSystemPar.Cfg.BindingOutCooling[_iC].wBindIndexModul;
					_BindingOutCooling[_iC].wChannel := mnSystemPar.Cfg.BindingOutCooling[_iC].wBindIndexChannel;
					_BindingOutCooling[_iC].sDiscription := mnSystemPar.Cfg.BindingOutCooling[_iC].sDiscription;
					_BindingOutCooling[_iC].xInvers := mnSystemPar.Cfg.BindingOutCooling[_iC].xInvers;
					_BindingOutCooling[_iC].xQualitiyOk := TRUE;

				END_IF

				IF mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].wBindIndexModul > 0 AND mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].wBindIndexModul <= MNSYSTEM_CNT_MODULES 
					AND mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].wBindIndexChannel > 0 AND mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].wBindIndexChannel <= 12 THEN
					
					_BindingWarnEnvTemp[_iC].wModule := mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].wBindIndexModul;
					_BindingWarnEnvTemp[_iC].wChannel := mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].wBindIndexChannel;
					_BindingWarnEnvTemp[_iC].sDiscription := mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].sDiscription;
					_BindingWarnEnvTemp[_iC].xInvers := mnSystemPar.Cfg.BindingWarnEnvTemp[_iC].xInvers;
					_BindingWarnEnvTemp[_iC].xQualitiyOk := TRUE;

				END_IF

				_xCInitDone[_iC] := TRUE;
			
			ELSE	
				
				IF _BindMotProtCooling[_iC].xQualitiyOk THEN
					
					_xFaultMotProtCooling[_iC] := MDLIn[1,_BindMotProtCooling[_iC].wModule].xIn[_BindMotProtCooling[_iC].wChannel] XOR _BindMotProtCooling[_iC].xInvers;
					
				ELSE
					
					_xFaultMotProtCooling[_iC] := FALSE;
					
				END_IF

				IF _BindingWarnEnvTemp[_iC].xQualitiyOk THEN
					
					_xWarnEnvTemp[_iC] := MDLIn[1,_BindingWarnEnvTemp[_iC].wModule].xIn[_BindingWarnEnvTemp[_iC].wChannel] XOR _BindingWarnEnvTemp[_iC].xInvers;
					
				ELSE
					
					_xWarnEnvTemp[_iC] := FALSE;
					
				END_IF
				
				IF _BindingOutCooling[_iC].xQualitiyOk THEN
					
					MDLOut[1,_BindingOutCooling[_iC].wModule].xOut[_BindingOutCooling[_iC].wChannel] := (NOT _xFaultMotProtCooling[_iC] AND (_xWarnEnvTemp[_iC] OR (_TONtempC.Q AND (_iC = 1)))) 
																											XOR _BindingOutCooling[_iC].xInvers;
					
				END_IF

			END_IF
			
			
		END_FOR
		
	ELSE
		
		_xModuleFault := FALSE;
		_wModuleFaultLineNumber := 0;
		_wModuleFaultModuleNumber := 0;
		
	END_IF
	
	// Meldungen
	IF NOT IFmnTest.Out.xNoMessages THEN

		kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wFunction_ID 	:= 110;

		IF _xModuleFault THEN

			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgClass		:= MNMSG_CLASS_WARNING;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgAckLevel	:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgNumber		:= MNSYSTEM_MSG_WRONGMODULE;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr1		:= _wModuleFaultLineNumber;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr2		:= _wModuleFaultModuleNumber;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= mnSystemPar.Cfg.Lines[_wModuleFaultLineNumber].sName[_wModuleFaultModuleNumber];

		ELSIF NOT _xFanOk THEN

			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgClass		:= MNMSG_CLASS_WARNING;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgAckLevel	:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgNumber		:= MNSYSTEM_MSG_FAN;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr1		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr2		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= '';

		ELSIF _xFaultMotProtCooling[1] OR _xFaultMotProtCooling[1] THEN

			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgClass		:= MNMSG_CLASS_WARNING;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgAckLevel	:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgNumber		:= MNSYSTEM_MSG_MOTPROTCOOLING;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr1		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr2		:= 0;
			IF _xFaultMotProtCooling[1] THEN
				kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= _BindMotProtCooling[1].sDiscription;
			ELSE
				kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= _BindMotProtCooling[2].sDiscription;
			END_IF

		ELSIF _TONtemp.Q OR _xWarnEnvTemp[1] OR _xWarnEnvTemp[2] THEN	

			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgClass		:= MNMSG_CLASS_WARNING;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgAckLevel	:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgNumber		:= MNSYSTEM_MSG_ENVTEMP;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr1		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr2		:= 0;
			IF _xWarnEnvTemp[1] THEN
				kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= mnSystemPar.Cfg.sSwitchBoxName[1];
			ELSIF _xWarnEnvTemp[2] THEN
				kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= mnSystemPar.Cfg.sSwitchBoxName[2];
			ELSE
				kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= 'CPU';
			END_IF				

		ELSIF IFmnSystem.In.PLC.bBatteryStatusCPU <> 1 THEN
			
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgClass		:= MNMSG_CLASS_WARNING;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgAckLevel	:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgNumber		:= MNSYSTEM_MSG_BATTERY;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr1		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr2		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= '';
			
		ELSE
	
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wFunction_ID 	:= 110;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgClass		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgAckLevel	:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].wMsgNumber		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr1		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].diMsgAttr2		:= 0;
			kgMsgStatus[MNSYSTEM_IDX_KGMSGSTAT].sMsgAttrTxt		:= '';
	
		END_IF
		
	END_IF

	// Stati
	mnSystemStatAd.lSerialNumber 			:= IFmnSystem.In.PLC.lSerialNumber;
	mnSystemStatAd.wTemperatureCPU 			:= IFmnSystem.In.PLC.wTemperatureCPU;
	mnSystemStatAd.wTemperatureEnvironment 	:= IFmnSystem.In.PLC.wTemperatureENV;

	// Interface
	IFmnSystem.Out.xModuleFault				:= _xModuleFault;
	
END_PROGRAM
