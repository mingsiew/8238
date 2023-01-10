(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: mnEth
 * File: mnEthInit.st
 * Author: hunholz
 * Created: August 9, 2011
 * Changed: February 3, 2012 2.07.0
 ********************************************************************
 * Implementation of program mnEth
 ********************************************************************)

PROGRAM _INIT

	_xmnEthOk := TRUE;
	
	_xDHCPstarted := FALSE;
	_xSNTPSrvStarted := FALSE;
	_xSNTPCltStarted := FALSE;
	
	brsmemset(ADR(kgMsgStatus[MNETH_IDX_KGMSGSTAT]),0,SIZEOF(kgMsgStatus[0]));
	
	kgMsgStatus[MNETH_IDX_KGMSGSTAT].wFunction_ID := 4;

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'mnEth';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnEthStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnEthStatAd.sPkgVersion := '---';
		
	END_IF
	
	//***********************************************
	//Lese das Ethernet-Device der CPU aus
	//***********************************************
	REPEAT
	
		_GetEthPort(enable := TRUE, adrIF := ADR(_sEthDevice));
	
	UNTIL
	
		_GetEthPort.status <> ERR_FUB_BUSY

	END_REPEAT
	
	IFmnEth.Out.sEthDevice := _sEthDevice;
	
	IF brsstrcmp(ADR(_sEthDevice), ADR('ERR')) = 0 THEN
		
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgAckLevel := 0;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgClass := 10;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgNumber := _MNETH_MSG_IFDEVICE;
		
		_xmnEthOk := FALSE;
		
	END_IF

	//**********************************************************
	//Bestimme den Hostnamen der SPS und setze ihn
	//**********************************************************
	
	_xSetDefault := FALSE;

	IF IFmnEth.In.bNodeSwitch = 16#FE THEN
			
		// Setze auf jeden Fall die Default Adresse
		_xSetDefault := TRUE;
		
	END_IF

	//********************************************************************************************
	//Erzeuge einen Speicherbereich zum parsen oder schreiben von CSV-Dateien
	//********************************************************************************************
	
	_pParseMem := 0;
	
	_MemPartCreate(enable := TRUE, len := 512);
	
	IF _MemPartCreate.status = ERR_OK THEN
		
		_MemPartAlloc(enable := TRUE, ident := _MemPartCreate.ident, len := 256);
		
		IF _MemPartAlloc.status = ERR_OK THEN
			
			_pParseMem := _MemPartAlloc.mem;
			
		ELSE

			kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgAckLevel := 0;
			kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgClass := 10;
			kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgNumber := _MNETH_MSG_MEM;
			
			_xmnEthOk := FALSE;
			
		END_IF

	ELSE

		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgAckLevel := 0;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgClass := 10;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgNumber := _MNETH_MSG_MEM;
		
		_xmnEthOk := FALSE;
		
	END_IF

	//********************************************************************************
	// Sicherstellen, dass das Verzeichnis mnEth auf der CF-Card existiert
	//********************************************************************************
	
	_DirInfo(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pPath := ADR('mnEth'));
	
	IF _DirInfo.status <> ERR_OK THEN
		
		_DirCreate(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR('mnEth'));
		
	END_IF
	
	//*****************************************************************************************************
	// Wenn nicht default gesetzt werden soll, csv-Datei auf CF suchen
	//*****************************************************************************************************	

	_xSetIPFromCF := FALSE;

	_sPathCsv := 'mnEth\mnEth.csv'; 

	IF _xmnEthOk THEN
	
		IF NOT _xSetDefault THEN
	
			_sPathCsv := 'mnEth\mnEth.csv'; 
		
			_FileOpenCsv(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPathCsv), mode := fiREAD_ONLY);
	
			IF _FileOpenCsv.status = ERR_OK THEN
		
				_FileReadCsv(enable := TRUE, ident := _FileOpenCsv.ident, pDest := _pParseMem, len := 256);
		
				IF _FileReadCsv.status = ERR_OK THEN
			
					_GetCsvDat.enable := TRUE;
					brwcsncpy( ADR(_GetCsvDat.utfCsvString), _pParseMem+2, 126);
					// Nur erste Zeile
					_lPosLF := brwcschr(ADR(_GetCsvDat.utfCsvString),16#0A);
					_lPosCR := brwcschr(ADR(_GetCsvDat.utfCsvString),16#0D);
					IF (_lPosCR <> 0) THEN
						brsmemset(_lPosCR , 0, 2);
					END_IF
					IF (_lPosLF <> 0) THEN
						brsmemset(_lPosLF , 0, 2);
					END_IF
					
					_GetCsvDat();
			
					IF _GetCsvDat.RowType = 90 THEN
				
						brwcsconv(ADR(_ParSetCF.IP_Adr), ADR(_GetCsvDat.CsvIPRow.utfIP_Adress), 1);
						brwcsconv(ADR(_ParSetCF.Gateway_Adr), ADR( _GetCsvDat.CsvIPRow.utfGateway), 1);
				
						IF ethInetAton(pIpStr := ADR(_ParSetCF.IP_Adr), ADR(_lIPAdr)) = ERR_OK THEN
					
							IF ethInetAton(pIpStr := ADR(_ParSetCF.Gateway_Adr), ADR(_lGatewayAdr)) = ERR_OK THEN
						
								_pOctet ACCESS ADR(_lIPAdr);
						
								_ParSetCF.IP_ID1 := _pOctet[0];
								_ParSetCF.IP_ID2 := _pOctet[1];
								_ParSetCF.IP_ID3 := (_pOctet[2] / 16) * 16;
								
								_ParSetCF.Region := _pOctet[2] MOD 16;
								_ParSetCF.Station := _pOctet[3];

								IF _ParSetCF.Region = 3 THEN
									_ParSetCF.Number := kgGetLineNumberW3(Station := _ParSetCF.Station, pMachineType := ADR(_kgMachineTypeW3));
								ELSE
									_ParSetCF.Number := 0;
								END_IF

								// NET-Id bestimmen
								_lNetId := _lIPAdr;
								_pOctet ACCESS ADR(_lNetId);

								_pOctet[2] := _ParSetCF.IP_ID3;
								_pOctet[3] := 0;
								
								ethInetNtoa(ipAdr := _lNetId, pIpStr := ADR(_ParSetCF.NetId_Adr));
						
								_pOctet ACCESS ADR(_lGatewayAdr);
						
								_ParSetCF.GWRegion 	:= _pOctet[2] MOD 16;
								_ParSetCF.GWStation := _pOctet[3];
						
								_xSetIPFromCF := TRUE;
													
							END_IF
					
						END_IF
				
					END_IF
			
				END_IF

				_FileCloseCsv(enable := TRUE, ident := _FileOpenCsv.ident);
		
			END_IF
		
		END_IF	

	END_IF
	
	//*****************************************************************************************************
	// Adressen von CF setzen
	//*****************************************************************************************************

	IF _xmnEthOk THEN
	
		IF _xSetIPFromCF THEN
		
			_ParSet := _ParSetCF;

			// Für Testzwecke in Hausnetzen mit anderer Netzwerkmaske

//			#ifndef NoSubnetMask		
//
//			_CfgGetSubnetMask(enable := TRUE, pDevice := ADR(_sEthDevice), pSubnetMask := ADR(_sActSubnetMask), Len := SIZEOF(_sActSubnetMask));
//
//			IF (brsstrcmp(ADR(_sActSubnetMask), ADR(_sSubnetMask)) <> 0) THEN
//	
//				_CfgSetSubnetMask(enable := TRUE, pDevice := ADR(_sEthDevice), pSubnetMask := ADR(_sSubnetMask), Option := cfgOPTION_NON_VOLATILE);
//				
//			END_IF
//			#endif		

			_pOctet ACCESS ADR(_lBroadcastAdr);
		
			_pOctet[0] := _ParSet.IP_ID1;
			_pOctet[1] := _ParSet.IP_ID2;
			_pOctet[2] := _ParSet.IP_ID3 + 15;
			_pOctet[3] := 255;
		
			ethInetNtoa(ADR(_lBroadcastAdr), ADR(_sBroadcastAdr));

			_CfgGetBroadcastAdr(enable := TRUE, pDevice := ADR(_sEthDevice), pBroadcastAddr := ADR(_sActBroadcastAdr), Len := SIZEOF(_sActBroadcastAdr));
			
			IF (brsstrcmp(ADR(_sActBroadcastAdr), ADR(_sBroadcastAdr)) <> 0) THEN
		
				_CfgSetBroadcastAdr(enable := TRUE, pDevice := ADR(_sEthDevice), pBroadcastAddr := ADR(_sBroadcastAdr), Option := cfgOPTION_NON_VOLATILE);
				
			END_IF
			
			_CfgGetIPAddress(enable := TRUE, pDevice := ADR(_sEthDevice), pIPAddr := ADR(_sActIPAdr), Len := SIZEOF(_sActIPAdr));
			
			IF (brsstrcmp(ADR(_sActIPAdr), ADR(_ParSet.IP_Adr)) <> 0) THEN
			
				_CfgSetIPAddr(enable := TRUE, pDevice := ADR(_sEthDevice), pIPAddr := ADR(_ParSet.IP_Adr), Option := cfgOPTION_NON_VOLATILE);
	
			END_IF
			
			_CfgGetGateway(enable := TRUE, pDevice := ADR(_sEthDevice), pGateway := ADR(_sActGateway), Len := SIZEOF(_sActGateway));

			IF (brsstrcmp(ADR(_sActGateway), ADR(_ParSet.Gateway_Adr)) <> 0) THEN
			
				_CfgSetDefaultGateway(enable := TRUE, pDevice := ADR(_sEthDevice), pGateway := ADR(_ParSet.Gateway_Adr), Option := cfgOPTION_NON_VOLATILE);
			
			END_IF
			
			_ParAktuell := _ParSet;

		ELSE
		
			_CfgGetGateway(enable := TRUE, pDevice := ADR(_sEthDevice), pGateway := ADR(_ParAktuell.Gateway_Adr), Len := SIZEOF(_ParAktuell.Gateway_Adr));
			
			_CfgGetIPAddress(enable := TRUE, pDevice := ADR(_sEthDevice), pIPAddr := ADR(_ParAktuell.IP_Adr), Len := SIZEOF(_ParAktuell.IP_Adr));
			
			IF ethInetAton(pIpStr := ADR(_ParAktuell.IP_Adr), ADR(_lIPAdr)) = ERR_OK THEN
		
				IF ethInetAton(pIpStr := ADR(_ParAktuell.Gateway_Adr), ADR(_lGatewayAdr)) = ERR_OK THEN
			
					_pOctet ACCESS ADR(_lIPAdr);
			
					_ParAktuell.IP_ID1 := _pOctet[0];
					_ParAktuell.IP_ID2 := _pOctet[1];
					_ParAktuell.IP_ID3 := (_pOctet[2] / 16) * 16;
					
					_ParAktuell.Region := _pOctet[2] MOD 16;
					_ParAktuell.Station := _pOctet[3];
			
					IF _ParAktuell.Region = 3 THEN
						_ParAktuell.Number := kgGetLineNumberW3(Station := _ParAktuell.Station, pMachineType := ADR(_kgMachineTypeW3));
					ELSE
						_ParAktuell.Number := 0;
					END_IF

					// NET-Id bestimmen
					_lNetId := _lIPAdr;
					_pOctet ACCESS ADR(_lNetId);

					_pOctet[2] := _ParAktuell.IP_ID3;
					_pOctet[3] := 0;
					
					ethInetNtoa(ipAdr := _lNetId, pIpStr := ADR(_ParAktuell.NetId_Adr));			
			
					_pOctet ACCESS ADR(_lGatewayAdr);
			
					_ParAktuell.GWRegion 	:= _pOctet[2] MOD 16;
					_ParAktuell.GWStation 	:= _pOctet[3];
			
				END_IF
		
			END_IF
			
		END_IF
		
		_xChanged := FALSE;

	END_IF
	
	
END_PROGRAM
