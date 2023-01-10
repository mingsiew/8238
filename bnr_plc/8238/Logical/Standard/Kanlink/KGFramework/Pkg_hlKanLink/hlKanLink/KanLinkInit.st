(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: KanLink
 * File: KanLinkInit.st
 * Author: stahlhut
 * Created: December 23, 2011
 ********************************************************************
 * Implementation of program KanLink
 ********************************************************************)

PROGRAM _INIT

	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	

	ST_name(0,ADR(_sName),0);
	ST_info(0,ADR(_state),ADR(_tcnr));


	_sPkgName := 'hlKanLink';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(hlKanLinkStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		hlKanLinkStatAd.sPkgVersion := '---';
		
	END_IF

	_xInitOK := FALSE;
	
	// nötige adressen initialisieren:
	Kanlink.adrSelf := ADR(Kanlink);
	Kanlink.CfgServer.adrKanlink := ADR(Kanlink);
	Kanlink.CfgClient.adrKanlink := ADR(Kanlink);

	FOR _i := 0 TO HLKANLINK_MAX_SERVERCONNS DO 
		Kanlink.ServerListe[_i].adrInterface := ADR(IFhlKanLink.Server[_i]);
		KLLib_ReadServerPara(ADR(Kanlink.ServerListe[_i]), ADR( IFhlKanLink.Parameter.Server[_i]),ADR(Kanlink));
	END_FOR;

	FOR _i := 0 TO HLKANLINK_MAX_CLIENTCONNS DO  
		KLLib_ReadClientPara(ADR(Kanlink.ClientListe[_i]),ADR(IFhlKanLink.Parameter.Client[_i]),ADR(Kanlink));
		Kanlink.ClientListe[_i].TimeOut := 140;
		Kanlink.ClientListe[_i].adrInterface := ADR(IFhlKanLink.Parameter.Client[_i]);
	END_FOR;		

	
	// Create Log
	//****************************************************************************************************************
	// Log erzeugen
	//****************************************************************************************************************

	_kgArLogWrite.enable := TRUE;
	_kgArLogWrite.ident := 0;
	_kgArLogWrite.errornr := 50010;
		
	_AsArLogCreate(enable := TRUE, pName := ADR('hlKanLinkL'), len := 4096*1, memType := arlogUSRROM);
		
	IF _AsArLogCreate.status = ERR_OK THEN
			
		_kgArLogWrite.ident := _AsArLogCreate.ident;
			
	ELSIF _AsArLogCreate.status = arlogERR_EXISTING THEN
			
		_AsArLogGetInfo(enable := TRUE, pName := ADR('hlKanLinkL'));

		IF _AsArLogGetInfo.status = ERR_OK THEN
				
			_kgArLogWrite.ident := _AsArLogGetInfo.ident;
				
		END_IF
			
	END_IF

	//****************************************************************************************************************
	// Ringbuffer for Logs
	//****************************************************************************************************************

	
	_kgRBcreateKanLinklog(sName := '_klLogrb', bMemType := doUSRRAM, wCntEntry := 10, lLenEntry := SIZEOF(_LogEntry), wPtrWrite := _wPtrRBwrite, wPtrRead := _wPtrRBread, wPtrStart := _wPtrRBstart);

	IF _kgRBcreateKanLinklog.wStatus = ERR_OK THEN

		_wPtrRBloc := 0;

		_xRBReady := TRUE;

		_InsertRB.doIdent := _kgRBcreateKanLinklog.doIdent;
		_InsertRB.doLen := _kgRBcreateKanLinklog.doLen;
		_InsertRB.lLenEntry := SIZEOF(_LogEntry);
		_InsertRB.pEntry := ADR(_LogEntryIn);
		
		_ReadRB.doIdent := _kgRBcreateKanLinklog.doIdent;
		_ReadRB.doLen := _kgRBcreateKanLinklog.doLen;
		_ReadRB.lLenEntry := SIZEOF(_LogEntry);
		_ReadRB.pEntry := ADR(_LogEntry);

	ELSE
		
		_kgArLogWrite.logLevel := arlogLEVEL_INFO;
		_kgArLogWrite.text := 'Create Ringbuffer: {##AttrVar1}';
		_kgArLogWrite.var1 := _kgRBcreateKanLinklog.wStatus;
		_kgArLogWrite.var2 := 0;
		_kgArLogWrite();		
		
	END_IF
	
	_wLogStep := 0;

	
	// Create StructureDescriptions
	//****************************************************************************************************************
	// Speicher allokoieren
	//****************************************************************************************************************

	_MemPartCreate(enable := TRUE, len := 8000);

	_LogEntryIn.wErrorNo := HLKANLINK_MSG_NO_STRUCDEF;
	
	IF _MemPartCreate.status = ERR_OK THEN
		
		_lTempMemIdent := _MemPartCreate.ident;

		_MemPartCreate(enable := TRUE, len := 8000);
		
		IF _MemPartCreate.status = ERR_OK THEN

			_lMemIdent := _MemPartCreate.ident;
			
			_MemAllocTemp(enable := TRUE, ident := _lTempMemIdent, len := 7500);
			
			IF _MemAllocTemp.status = ERR_OK THEN
				
				_lAdr := _MemAllocTemp.mem;
				_lLen := _MemAllocTemp.len;
			
				_wStatus := KLLib_CreateStrucDef(lPtrAdr := ADR(_lAdr), lPtrLen := ADR(_lLen), sRootName := 'hlKanLink:Kanlink.ServerData.MetaInfoResp', sItemName := '', lDataAdr := 0);

				IF _wStatus = ERR_OK THEN

					_MemAlloc(enable := TRUE, ident := _lMemIdent, len := _MemAllocTemp.len - _lLen);
					
					IF _MemAlloc.status = ERR_OK THEN
						
						_lPtrStrucDef[_HLKANLINK_IDX_STRUCDEF_RESP_0] := _MemAlloc.mem;
						_lPtrStrucLen[_HLKANLINK_IDX_STRUCDEF_RESP_0] := _MemAlloc.len;
						
						brsmemcpy(_MemAlloc.mem, _MemAllocTemp.mem, _MemAlloc.len);
						
						_MemFreeTemp(enable := TRUE, ident := _lTempMemIdent, mem := _MemAllocTemp.mem );
						
					ELSE

						_LogEntryIn.lAttr1 := _MemAlloc.status;
						_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
						
					END_IF

				ELSE

					_LogEntryIn.lAttr1 := _wStatus;
					_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);

				END_IF
				
			ELSE

				_LogEntryIn.lAttr1 := _MemAllocTemp.status;
				_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
				
			END_IF
			
		ELSE
	
			_LogEntryIn.lAttr1 := _MemPartCreate.status;
			_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
		
		END_IF
		
	ELSE
	
		_LogEntryIn.lAttr1 := _MemPartCreate.status;
		_InsertRB(wPtrStart := _wPtrRBstart, wPtrRead := _wPtrRBread, wPtrWrite := _wPtrRBwrite);
		
	END_IF
	
	
END_PROGRAM

