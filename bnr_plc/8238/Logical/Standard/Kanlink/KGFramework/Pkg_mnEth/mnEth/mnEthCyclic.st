(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: mnEth
 * File: mnEthCyclic.st
 * Author: hunholz
 * Created: August 9, 2011
 * Changed: October 7, 2011
 ********************************************************************
 * Implementation of program mnEth
 ********************************************************************)

PROGRAM _CYCLIC

	// Input Messagesystem

	_kgMsgStatus.xAckAva := kgMsgStatus[MNETH_IDX_KGMSGSTAT].xAckAva;
	_kgMsgStatus.xAckFault := kgMsgStatus[MNETH_IDX_KGMSGSTAT].xAckFault;
	_kgMsgStatus.xAckMaint := kgMsgStatus[MNETH_IDX_KGMSGSTAT].xAckMaint;

	_kgMsgStatus.wFunction_ID := 4;

	IF _xmnEthOk THEN
		
		CASE enEState OF
			
			es_idle:
			
				IF _xSetHostname THEN

					enEState := es_SetHostname1;

				ELSIF _xSetDefault THEN
					
					enEState := es_SetDef1;
					_xCheckedUSB := TRUE;

				ELSIF NOT _xCheckedUSB THEN
					
					IF IFmnSystem.Out.xUSBStickReady THEN

						enEState := es_SetUSB1;
						
						_sPathCsv := _sHostname;
						_sPathCsv := CONCAT(_sPathCsv, '\mnEth\mnEth.csv');
						_sDevice := IFmnSystem.Out.sInterfaceUSB;
						
					END_IF

					_xCheckedUSB := TRUE;
					
				ELSIF mnEthPar.Mac.xStartDHCP AND IFmnParam.Out.xParamOK AND NOT _xDHCPstarted THEN
					
					// schaltet den DHCP-Server ein. Nicht dauerhaft. Wird der Maschinenparameter auf FALSE gesetzt
					// dann bleibt der DHCP-Server aus.
					enEState := es_DHCP1;
					
				ELSIF mnEthPar.Mac.xStartSNTPClt AND IFmnParam.Out.xParamOK AND NOT _xSNTPCltStarted THEN
					
					enEState := es_SNTPcltStart1;

				ELSIF NOT mnEthPar.Mac.xStartSNTPClt AND IFmnParam.Out.xParamOK AND _xSNTPCltStarted THEN
					
					enEState := es_SNTPcltStop1;

				ELSIF mnEthPar.Mac.xStartSNTPSrv AND IFmnParam.Out.xParamOK AND NOT _xSNTPSrvStarted THEN
					
					enEState := es_SNTPsrvStart1;

				ELSIF NOT mnEthPar.Mac.xStartSNTPSrv AND IFmnParam.Out.xParamOK AND _xSNTPSrvStarted THEN
					
					enEState := es_SNTPsrvStop1;
					
				ELSIF _bWaitCounter >= 3 THEN
					
					_xChanged := FALSE;
					
					_ParSet := _ParAktuell;
					
					enEState := es_WriteCSV1;
					
				ELSIF _TONidle.Q THEN
					
					enEState := es_Change1;
					
				END_IF

			// Beobachte eingestellte IP und das Gateway
			es_Change1:
			
				_CfgGetGateway(enable := TRUE, pDevice := ADR(_sEthDevice), pGateway := ADR(_ParGet.Gateway_Adr), Len := SIZEOF(_ParGet.Gateway_Adr));
				
				IF _CfgGetGateway.status = ERR_OK THEN
					
					enEState := es_Change2;
					
				ELSIF _CfgGetGateway.status <> ERR_FUB_BUSY THEN
					
					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_CHANGE;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgGetGateway.status);
					
					enEState := es_Warning;					
				END_IF

			es_Change2:
			
				_CfgGetIPAddress(enable := TRUE, pDevice := ADR(_sEthDevice), pIPAddr := ADR(_ParGet.IP_Adr), Len := SIZEOF(_ParGet.IP_Adr));
				
				IF _CfgGetIPAddress.status = ERR_OK THEN
					
					enEState := es_Change3;
					
				ELSIF _CfgGetIPAddress.status <> ERR_FUB_BUSY THEN
					
					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_CHANGE;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgGetIPAddress.status);
					
					enEState := es_Warning;					
				END_IF
	
			es_Change3:
			
				IF (brsstrcmp(ADR(_ParAktuell.Gateway_Adr), ADR(_ParGet.Gateway_Adr)) = 0)	AND (brsstrcmp(ADR(_ParAktuell.IP_Adr), ADR(_ParGet.IP_Adr)) = 0) THEN
					
					IF _xChanged THEN
						
						_bWaitCounter := _bWaitCounter + 1;
						
					ELSE
						
						_bWaitCounter := 0;
						
					END_IF
					
					enEState := es_idle;
					
				ELSE
					
					IF ethInetAton(pIpStr := ADR(_ParGet.IP_Adr), ADR(_lIPAdr)) = ERR_OK THEN
		
						IF ethInetAton(pIpStr := ADR(_ParGet.Gateway_Adr), ADR(_lGatewayAdr)) = ERR_OK THEN
			
							_pOctet ACCESS ADR(_lIPAdr);
			
							_ParGet.IP_ID1 := _pOctet[0];
							_ParGet.IP_ID2 := _pOctet[1];
							_ParGet.IP_ID3 := (_pOctet[2] / 16) * 16;
							
							_ParGet.Region := _pOctet[2] MOD 16;
							_ParGet.Station := _pOctet[3];

							IF _ParGet.Region = 3 THEN
								_ParGet.Number := kgGetLineNumberW3(Station := _ParGet.Station, pMachineType := ADR(_kgMachineTypeW3));
							ELSE
								_ParGet.Number := 0;
							END_IF

							// NET-Id bestimmen
							_lNetId := _lIPAdr;
							_pOctet ACCESS ADR(_lNetId);

							_pOctet[2] := _ParGet.IP_ID3;
							_pOctet[3] := 0;
					
							ethInetNtoa(ipAdr := _lNetId, pIpStr := ADR(_ParGet.NetId_Adr));
								
							_pOctet ACCESS ADR(_lGatewayAdr);
			
							_ParGet.GWRegion 	:= _pOctet[2] MOD 16;
							_ParGet.GWStation 	:= _pOctet[3];
							
							enEState := es_Change4;
			
						END_IF
		
					END_IF	
				
				END_IF
				
			es_Change4:

				_CfgSetIPAddr(enable := TRUE, pDevice := ADR(_sEthDevice), pIPAddr := ADR(_ParGet.IP_Adr), Option := cfgOPTION_NON_VOLATILE);
				
				IF _CfgSetIPAddr.status = ERR_OK THEN

					enEState := es_Change5;
					
				ELSIF _CfgSetIPAddr.status <> ERR_FUB_BUSY THEN
					
					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_CHANGE;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgSetIPAddr.status);
					
					enEState := es_Warning;
										
				END_IF
			
			es_Change5:
				
				_CfgSetDefaultGateway(enable := TRUE, pDevice := ADR(_sEthDevice), pGateway := ADR(_ParGet.Gateway_Adr), Option := cfgOPTION_NON_VOLATILE);
				
				IF _CfgSetDefaultGateway.status = ERR_OK THEN

					enEState := es_Change6;
					
				ELSIF _CfgSetDefaultGateway.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_CHANGE;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgSetDefaultGateway.status);
					
					enEState := es_Warning;
					
				END_IF
				
			es_Change6:
			

				IF NOT mnEthPar.Mac.xForceNotSubnetmask THEN

					_CfgSetSubnetMask(enable := TRUE, pDevice := ADR(_sEthDevice), pSubnetMask := ADR(_sSubnetMask), Option := cfgOPTION_NON_VOLATILE);

					IF _CfgSetSubnetMask.status <> ERR_FUB_BUSY THEN
					
						enEState := es_Change7;
					
					END_IF

				ELSE

					enEState := es_Change7;

				END_IF				

			es_Change7:
				
				_pOctet ACCESS ADR(_lBroadcastAdr);
		
				_pOctet[0] := _ParGet.IP_ID1;
				_pOctet[1] := _ParGet.IP_ID2;
				_pOctet[2] := _ParGet.IP_ID3 + 15;
				_pOctet[3] := 255;
		
				ethInetNtoa(ADR(_lBroadcastAdr), ADR(_sBroadcastAdr));
		
				_CfgSetBroadcastAdr(enable := TRUE, pDevice := ADR(_sEthDevice), pBroadcastAddr := ADR(_sBroadcastAdr), Option := cfgOPTION_NON_VOLATILE);				
								
				IF _CfgSetBroadcastAdr.status = ERR_OK THEN

					_ParAktuell := _ParGet;
					
					_xChanged  := TRUE;

					enEState := es_idle;
					
				ELSIF _CfgSetBroadcastAdr.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_SETDEF;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgSetBroadcastAdr.status);
					
					enEState := es_Warning;
					
				END_IF			

			// Setze Default aus Parameter
			es_SetDef1:
			
				IF IFmnParam.Out.xParamOK THEN

					_ParSet.IP_ID1 := mnEthPar.Cfg.bNETid1;
					_ParSet.IP_ID2 := mnEthPar.Cfg.bNETid2;
					_ParSet.IP_ID3 := mnEthPar.Cfg.bNETid3;
					
					_ParSet.Region := mnEthPar.Cfg.bRegion;
					_ParSet.Station := mnEthPar.Cfg.bStation;

					_ParSet.GWRegion 	:= 15;
					_ParSet.GWStation 	:= 254;
					
					IF _ParAktuell.Region = 3 THEN
						_ParSet.Number := kgGetLineNumberW3(Station := _ParSet.Station, pMachineType := ADR(_kgMachineTypeW3));
					ELSE
						_ParSet.Number := 0;
					END_IF
						
					_pOctet ACCESS ADR(_lIPAdr);
			
					_pOctet[0] := _ParSet.IP_ID1;
					_pOctet[1] := _ParSet.IP_ID2;
					_pOctet[2] := _ParSet.IP_ID3 + _ParSet.Region;
					_pOctet[3] := _ParSet.Station;
					
					ethInetNtoa(_lIPAdr, ADR(_ParSet.IP_Adr));
	
					// NET-Id bestimmen
					_lNetId := _lIPAdr;
					_pOctet ACCESS ADR(_lNetId);
	
					_pOctet[2] := _ParSet.IP_ID3;
					_pOctet[3] := 0;
										
					ethInetNtoa(ipAdr := _lNetId, pIpStr := ADR(_ParSet.NetId_Adr));
					
					// Gateway Adress
					_pOctet[0] := _ParSet.IP_ID1;
					_pOctet[1] := _ParSet.IP_ID2;
					_pOctet[2] := _ParSet.IP_ID3 + _ParSet.GWRegion;
					_pOctet[3] := _ParSet.GWStation;
					
					ethInetNtoa(_lIPAdr, ADR(_ParSet.Gateway_Adr));
					
					
					enEState := es_SetDef2;

				END_IF
			
			es_SetDef2:
				
				_CfgSetIPAddr(enable := TRUE, pDevice := ADR(_sEthDevice), pIPAddr := ADR(_ParSet.IP_Adr), Option := cfgOPTION_VOLATILE);
				
				IF _CfgSetIPAddr.status = ERR_OK THEN

					enEState := es_SetDef3;
					
				ELSIF _CfgSetIPAddr.status <> ERR_FUB_BUSY THEN
					
					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_SETDEF;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgSetIPAddr.status);
					
					_xSetDefault := FALSE;
					enEState := es_Warning;
										
				END_IF
				
			es_SetDef3:
				
				_CfgGetGateway(enable := TRUE, pDevice := ADR(_sEthDevice), pGateway := ADR(_ParSet.Gateway_Adr), Len := SIZEOF(_ParSet.Gateway_Adr));
				
				IF _CfgGetGateway.status = ERR_OK THEN

					enEState := es_SetDef4;
					
				ELSIF _CfgGetGateway.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_SETDEF;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgGetGateway.status);
					
					_xSetDefault := FALSE;
					enEState := es_Warning;
					
				END_IF
				
			es_SetDef4:
			
				IF NOT mnEthPar.Mac.xForceNotSubnetmask THEN
				
					_CfgSetSubnetMask(enable := TRUE, pDevice := ADR(_sEthDevice), pSubnetMask := ADR(_sSubnetMask), Option := cfgOPTION_VOLATILE);

					IF _CfgSetSubnetMask.status <> ERR_FUB_BUSY THEN
					
						enEState := es_SetDef5;
					
					END_IF
				
				ELSE				

					enEState := es_SetDef5;
				
				END_IF
				
			es_SetDef5:
				
				_pOctet ACCESS ADR(_lBroadcastAdr);
		
				_pOctet[0] := _ParSet.IP_ID1;
				_pOctet[1] := _ParSet.IP_ID2;
				_pOctet[2] := _ParSet.IP_ID3 + 15;
				_pOctet[3] := 255;
		
				ethInetNtoa(ADR(_lBroadcastAdr), ADR(_sBroadcastAdr));
		
				_CfgSetBroadcastAdr(enable := TRUE, pDevice := ADR(_sEthDevice), pBroadcastAddr := ADR(_sBroadcastAdr), Option := cfgOPTION_VOLATILE);				
								
				IF _CfgSetBroadcastAdr.status = ERR_OK THEN

					_xSetDefault := FALSE;
					enEState := es_WriteCSV1;
					
				ELSIF _CfgSetBroadcastAdr.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_SETDEF;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgSetBroadcastAdr.status);
					
					_xSetDefault := FALSE;
					enEState := es_Warning;
					
				END_IF

			es_SetUSB1:
			
				_FileOpenCsv(enable := TRUE, pDevice := ADR(_sDevice), pFile := ADR(_sPathCsv), mode := fiREAD_ONLY);

				IF _FileOpenCsv.status = ERR_OK THEN
				
					enEState := es_SetUSB2;
					
				ELSE
					
					enEState := es_idle;
					
				END_IF
					
			
			es_SetUSB2:
			
				_FileReadCsv(enable := TRUE, ident := _FileOpenCsv.ident, pDest := _pParseMem, len := 256);
			
				IF _FileReadCsv.status = ERR_OK THEN
				
					_GetCsvDat.enable := TRUE;
					brwcsncpy( ADR(_GetCsvDat.utfCsvString), _pParseMem+2, 126);
					_GetCsvDat();
				
					IF _GetCsvDat.RowType = 90 THEN
					
						_ParSet.IP_Adr := WSTRING_TO_STRING(_GetCsvDat.CsvIPRow.utfIP_Adress);
						_ParSet.Gateway_Adr := WSTRING_TO_STRING(_GetCsvDat.CsvIPRow.utfGateway);
					
						IF ethInetAton(pIpStr := ADR(_ParSet.IP_Adr), ADR(_lIPAdr)) = ERR_OK THEN
						
							IF ethInetAton(pIpStr := ADR(_ParSet.Gateway_Adr), ADR(_lGatewayAdr)) = ERR_OK THEN
							
								_pOctet ACCESS ADR(_lIPAdr);
							
								_ParSet.IP_ID1 := _pOctet[0];
								_ParSet.IP_ID2 := _pOctet[1];
								_ParSet.IP_ID3 := (_pOctet[2] / 16) * 16;
								
								_ParSet.Region := _pOctet[2] MOD 16;
								_ParSet.Station := _pOctet[3];
									
								IF _ParSet.Region = 3 THEN
									_ParSet.Number := kgGetLineNumberW3(Station := _ParSet.Station, pMachineType := ADR(_kgMachineTypeW3));
								ELSE
									_ParSet.Number := 0;
								END_IF

								// NET-Id bestimmen
								_lNetId := _lIPAdr;
								_pOctet ACCESS ADR(_lNetId);

								_pOctet[2] := _ParSet.IP_ID3;
								_pOctet[3] := 0;
									
								ethInetNtoa(ipAdr := _lNetId, pIpStr := ADR(_ParSet.NetId_Adr));
							
								_pOctet ACCESS ADR(_lGatewayAdr);
							
								_ParSet.GWRegion := _pOctet[2] MOD 16;
								_ParSet.GWStation := _pOctet[3];
								
								enEState := es_SetUSB3;
														
							END_IF
						
						END_IF
					
					END_IF
				
				END_IF

			es_SetUSB3:
				
				_CfgSetIPAddr(enable := TRUE, pDevice := ADR(_sEthDevice), pIPAddr := ADR(_ParSet.IP_Adr), Option := cfgOPTION_VOLATILE);
				
				IF _CfgSetIPAddr.status = ERR_OK THEN

					enEState := es_SetUSB4;
					
				ELSIF _CfgSetIPAddr.status <> ERR_FUB_BUSY THEN
					
					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_SETUSB;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgSetIPAddr.status);
					
					_xSetDefault := FALSE;
					enEState := es_Warning;
										
				END_IF
				
			es_SetUSB4:
				
				_CfgGetGateway(enable := TRUE, pDevice := ADR(_sEthDevice), pGateway := ADR(_ParSet.Gateway_Adr), Len := SIZEOF(_ParSet.Gateway_Adr));
				
				IF _CfgGetGateway.status = ERR_OK THEN

					enEState := es_SetUSB5;
					
				ELSIF _CfgGetGateway.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_SETUSB;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgGetGateway.status);
					
					_xSetDefault := FALSE;
					enEState := es_Warning;
					
				END_IF
				
			es_SetUSB5:
			
				IF NOT mnEthPar.Mac.xForceNotSubnetmask THEN
				
					_CfgSetSubnetMask(enable := TRUE, pDevice := ADR(_sEthDevice), pSubnetMask := ADR(_sSubnetMask), Option := cfgOPTION_VOLATILE);

					IF _CfgSetSubnetMask.status <> ERR_FUB_BUSY THEN
					
						enEState := es_SetUSB6;
					
					END_IF
				
				ELSE				

					enEState := es_SetUSB6;
				
				END_IF
				
			es_SetUSB6:
				
				_pOctet ACCESS ADR(_lBroadcastAdr);
		
				_pOctet[0] := _ParSet.IP_ID1;
				_pOctet[1] := _ParSet.IP_ID2;
				_pOctet[2] := _ParSet.IP_ID3 + 15;
				_pOctet[3] := 255;
		
				ethInetNtoa(ADR(_lBroadcastAdr), ADR(_sBroadcastAdr));
		
				_CfgSetBroadcastAdr(enable := TRUE, pDevice := ADR(_sEthDevice), pBroadcastAddr := ADR(_sBroadcastAdr), Option := cfgOPTION_VOLATILE);				
								
				IF _CfgSetBroadcastAdr.status = ERR_OK THEN

					_xSetDefault := FALSE;
					enEState := es_WriteCSV1;
					
				ELSIF _CfgSetBroadcastAdr.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_SETUSB;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_CfgSetBroadcastAdr.status);
					
					_xSetDefault := FALSE;
					enEState := es_Warning;
					
				END_IF

			
			es_WriteCSV1:
			
				_ParAktuell := _ParSet;
			
				brsmemset(_pParseMem, 0, 256);
		
				_lFileSize := 0;
		
				brwcsconv(ADR( _IPRow.utfIP_Adress), ADR(_ParSet.IP_Adr), 0);
				brwcsconv(ADR(_IPRow.utfGateway), ADR(_ParSet.Gateway_Adr), 0);
						
				_WriteBOM(enable := TRUE, pMem := _pParseMem, lMaxSize := 256, lSize := _lFileSize);
				_WriteCsv90(enable := TRUE, pMem := _pParseMem, lMaxSize := 256, IPRow := _IPRow, lSize := _lFileSize);

				enEState := es_WriteCSV2;
				
			es_WriteCSV2:
				
				_FileDeleteCsv(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pName := ADR(_sPathCsv));

				IF _FileDeleteCsv.status <> ERR_FUB_BUSY THEN
					
					enEState := es_WriteCSV3;
					
				END_IF				
				
			es_WriteCSV3:
		
				_FileCreateCsv(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPathCsv));
				
				IF _FileCreateCsv.status = ERR_OK THEN

					enEState := es_WriteCSV5;
					
				ELSIF _FileCreateCsv.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_WRITECSV;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_FileCreateCsv.status);
					
					enEState := es_Warning;
					
				END_IF				
		
			es_WriteCSV4:
			
				_FileOpenCsv(enable := TRUE, pDevice := ADR(KG_DEVICE_COMPACTFLASH), pFile := ADR(_sPathCsv), mode := fiWRITE_ONLY);
				
				IF _FileOpenCsv.status = ERR_OK THEN

					enEState := es_WriteCSV5;
					
				ELSIF _FileOpenCsv.status <> ERR_FUB_BUSY THEN

					_kgMsgStatus.wMsgClass := 11;
					_kgMsgStatus.wMsgNumber := _MNETH_MSG_WRITECSV;
					_kgMsgStatus.diMsgAttr1 := UINT_TO_DINT(_FileOpenCsv.status);
					
					enEState := es_Warning;
										
				END_IF						
		
			es_WriteCSV5:
			
				_FileWriteCsv(enable := TRUE, ident := _FileCreateCsv.ident, offset := 0, pSrc := _pParseMem, len := _lFileSize);

				IF _FileWriteCsv.status <> ERR_FUB_BUSY THEN

					enEState := es_WriteCSV6;
					
				END_IF

			es_WriteCSV6:
			
				_FileCloseCsv(enable := TRUE, ident := _FileCreateCsv.ident);
			
				IF _FileCloseCsv.status <> ERR_FUB_BUSY THEN
					
					_bWaitCounter := 0;
					_xChanged := FALSE;

					enEState := es_idle;
					
				END_IF
					

			es_Warning:

				_bWaitCounter := 0;
				_xChanged := FALSE;


				IF _TONwarning.Q THEN

					brsmemset(ADR(_kgMsgStatus),0,SIZEOF(kgMsgStatus[0]));
					_kgMsgStatus.wFunction_ID := 4;
					
					enEState := es_idle;

				END_IF					

			es_DHCP1:
			
				brsstrcpy(ADR(_cfgLease.name), ADR('KANLINK'));
				brsstrcpy(ADR(_cfgLease.defaultGateway), ADR(_ParAktuell.Gateway_Adr));
				brsstrcpy(ADR(_cfgLease.subnetMask), ADR(_sSubnetMask));

				// Startadresse
				_lIPAdr := 0;				
				_pOctet ACCESS ADR(_lIPAdr);
				_pOctet[0] := _ParAktuell.IP_ID1;
				_pOctet[1] := _ParAktuell.IP_ID2;
				_pOctet[2] := _ParAktuell.IP_ID3;
				
				_pOctet[3] := 150;
				
				ethInetNtoa(_lIPAdr, ADR(_cfgLease.startAdr));

				// Stopadresse
				_pOctet[3] := 169;
				
				ethInetNtoa(_lIPAdr, ADR(_cfgLease.stopAdr));
				
				_cfgLease.leaseTimeout := -1;
				
				enEState := es_DHCP2;
				
			es_DHCP2:
			
				_CfgSetDhcpsData(enable := TRUE, pInterfaceList := ADR(_sEthDevice), pLeases := ADR(_cfgLease), numLeases := 1, option := cfgOPTION_VOLATILE);
				
				IF (_CfgSetDhcpsData.status = ERR_OK) THEN
					
					enEState := es_DHCP3;
					
				ELSIF _CfgSetDhcpsData.status <> ERR_FUB_BUSY THEN
					
					enEState := es_idle;
					_xDHCPstarted := TRUE;
					
				END_IF

			es_DHCP3:
			
				_CfgSetDhcpServer(enable := TRUE, start := 1, option := cfgOPTION_VOLATILE);
				
				IF _CfgSetDhcpServer.status <> ERR_FUB_BUSY THEN
					
					enEState := es_idle;
					_xDHCPstarted := TRUE;
					
				END_IF
				
			es_SNTPcltStart1:
			
				_CfgSetSntpClient(enable := TRUE, run := 1, pServerAddr := ADR(mnEthPar.Mac.sIP_SNTP_Srv), sntpcInterval := 30, rtcInterval := 30, option := cfgOPTION_VOLATILE);

				IF _CfgSetSntpClient.status <> ERR_FUB_BUSY THEN
					
					enEState := es_idle;
					_xSNTPCltStarted := TRUE;
					
				END_IF

			es_SNTPcltStop1:
			
				_CfgSetSntpClient(enable := TRUE, run := 0, pServerAddr := ADR(mnEthPar.Mac.sIP_SNTP_Srv), sntpcInterval := 30, rtcInterval := 30, option := cfgOPTION_VOLATILE);

				IF _CfgSetSntpClient.status <> ERR_FUB_BUSY THEN
					
					enEState := es_idle;
					_xSNTPCltStarted := FALSE;
					
				END_IF

			es_SNTPsrvStart1:
			
				_CfgSetSntpServer(enable := TRUE, start := 1, option := cfgOPTION_VOLATILE);

				IF _CfgSetSntpServer.status <> ERR_FUB_BUSY THEN
					
					enEState := es_idle;
					_xSNTPSrvStarted := TRUE;
					
				END_IF

			es_SNTPsrvStop1:
			
				_CfgSetSntpServer(enable := TRUE, start := 0, option := cfgOPTION_VOLATILE);

				IF _CfgSetSntpServer.status <> ERR_FUB_BUSY THEN
					
					enEState := es_idle;
					_xSNTPSrvStarted := FALSE;
					
				END_IF

			es_SetHostname1:
			
				IF IFmnParam.Out.xParamOK THEN
					
					brwcsconv(ADR(_sMnr), ADR(IFmnParam.Out.utfMachineNumber) ,1);
					
					_sHostname := 'KaMa';
					brsstrcat(ADR(_sHostname), ADR(_sMnr));
	
					enEState := es_SetHostname2;
					
				END_IF
				
			es_SetHostname2:
				
				_CfgGetHostName(enable := TRUE, pHostName := ADR(_sActHostname), Len := SIZEOF(_sActHostname));
				
				IF _CfgGetHostName.status = ERR_OK THEN
					
					IF brsstrcmp(ADR(_sHostname), ADR(_sActHostname)) = 0 THEN
						
						_xSetHostname := FALSE;
						enEState := es_idle;
					
					ELSE
						
						enEState := es_SetHostname3;
						
					END_IF
					
				ELSIF _CfgGetHostName.status <> ERR_FUB_BUSY THEN
					
					_xSetHostname := FALSE;
					enEState := es_idle;
					
				END_IF

			es_SetHostname3:
				
				_CfgSetHostName(enable := TRUE, pHostName := ADR(_sHostname), Option := cfgOPTION_NON_VOLATILE);
				
				IF _CfgSetHostName.status <> ERR_FUB_BUSY THEN
					
					_xSetHostname := FALSE;
					enEState := es_idle;
					
				END_IF						

		END_CASE

		_TONidle(IN := enEState = es_idle, PT := T#2s);
		
		_TONwarning(IN := enEState = es_Warning, PT := T#30s);


		// Ethernetdaten übergeben
		mnEthStatAd.IP.sHostname		:= _sHostname;
		mnEthStatAd.IP.sIP 				:= _ParAktuell.IP_Adr;
		mnEthStatAd.IP.sGateway 		:= _ParAktuell.Gateway_Adr;
		mnEthStatAd.IP.sNetId			:= _ParAktuell.NetId_Adr;
		mnEthStatAd.IP.bNetId1			:= _ParAktuell.IP_ID1;
		mnEthStatAd.IP.bNetId2			:= _ParAktuell.IP_ID2;
		mnEthStatAd.IP.bNetId3			:= _ParAktuell.IP_ID3;
		mnEthStatAd.IP.bNumber			:= _ParAktuell.Number;
		mnEthStatAd.IP.bRegion			:= _ParAktuell.Region;
		mnEthStatAd.IP.bStation			:= _ParAktuell.Station;
		IFmnEth.Out.IP					:= mnEthStatAd.IP;
		IFmnEth.Out.sEthDevice 			:= _sEthDevice;
		mnEthStatAd.xDataValid			:= NOT _xSetDefault AND NOT _xSetHostname;
		IFmnEth.Out.xDataValid			:= mnEthStatAd.xDataValid;
		
	ELSE

		_kgMsgStatus.wMsgClass := 11;
		
		mnEthStatAd.xDataValid := FALSE;

		
	END_IF // _xmnEthOk
	
	// MsgSystem Output
	
	IF NOT IFmnTest.Out.xNoMessages THEN
		
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].diMaintAttr1 		:= _kgMsgStatus.diMaintAttr1;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].diMaintAttr2 		:= _kgMsgStatus.diMaintAttr2;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].diMsgAttr1 		:= _kgMsgStatus.diMsgAttr1;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].diMsgAttr2 		:= _kgMsgStatus.diMsgAttr2;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].sMaintAttrTxt 		:= _kgMsgStatus.sMaintAttrTxt;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].sMsgAttrTxt		:= _kgMsgStatus.sMsgAttrTxt;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wFunction_ID		:= _kgMsgStatus.wFunction_ID;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wInstance			:= _kgMsgStatus.wInstance;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMaintAckLevel		:= _kgMsgStatus.wMaintAckLevel;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMaintNumber		:= _kgMsgStatus.wMaintNumber;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgAckLevel		:= _kgMsgStatus.wMsgAckLevel;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgClass			:= _kgMsgStatus.wMsgClass;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].wMsgNumber			:= _kgMsgStatus.wMsgNumber;
		kgMsgStatus[MNETH_IDX_KGMSGSTAT].xAckRead			:= _kgMsgStatus.xAckRead;
		
	END_IF

END_PROGRAM
