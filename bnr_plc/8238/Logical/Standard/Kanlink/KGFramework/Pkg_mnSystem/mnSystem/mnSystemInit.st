(********************************************************************
 * COPYRIGHT -- Kannegiesser GmbH
 ********************************************************************
 * Program: mnSystem
 * File: mnSystemInit.st
 * Author: horn
 * Created: January 10, 2012
 ********************************************************************
 * Implementation of program mnSystem
 ********************************************************************)

PROGRAM _INIT


	// Packet-Version auslesen mit MO_ver aus SYS_lib und für den Additional Status zur Verfügung stellen
	
	_sPkgName := 'mnSystem';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnSystemStatAd.sPkgVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnSystemStatAd.sPkgVersion := '---';
		
	END_IF

	_sPkgName := 'mnMaster';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnSystemStatAd.sPrjVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnSystemStatAd.sPrjVersion := '---';
		
	END_IF

	_sPkgName := 'mnTest';
	
	IF ( MO_ver(ADR(_sPkgName), 0, ADR(_VerStruc)) = 0 ) THEN
		
		brsmemcpy(ADR(mnSystemStatAd.sFWVersion), ADR(_VerStruc.version), SIZEOF(_VerStruc.version));
		
	ELSE
		
		mnSystemStatAd.sFWVersion := '---';
		
	END_IF

	// CPU-Typ bestimmen
	
	CASE IFmnSystem.In.PLC.wMDL_ID OF

		KG_CPU_CTT_11:
			
			mnSystemStatAd.sCPUType := 'CTT-11';

		KG_CPU_PCT_03:
			
			mnSystemStatAd.sCPUType := 'PCT-03';

		KG_CPU_PCT_04:
			
			mnSystemStatAd.sCPUType := 'PCT-04';

		KG_CPU_PP65_0571_P74:
			
			mnSystemStatAd.sCPUType := 'PP65.0571.P74';

		KG_CPU_PP420_1043_75:
			
			mnSystemStatAd.sCPUType := 'PP420.1043.75';

		KG_CPU_X20CP1484:
			
			mnSystemStatAd.sCPUType := 'CP1484';

		KG_CPU_X20CP1484_1:
			
			mnSystemStatAd.sCPUType := 'CP1484-1';

		KG_CPU_X20CP1486:
			
			mnSystemStatAd.sCPUType := 'CP1486';

		KG_CPU_X20CP3484:

			mnSystemStatAd.sCPUType := 'CP3484';

		KG_CPU_X20CP3484_1:
			
			mnSystemStatAd.sCPUType := 'CP3484-1';

		KG_CPU_X20CP3486:
			
			mnSystemStatAd.sCPUType := 'CP3486';

		KG_CPU_X20CP3585:
			
			mnSystemStatAd.sCPUType := 'CP3585';
			
		KG_CPU_X20CP1584:
			
			mnSystemStatAd.sCPUType := 'CP1584';

		ELSE
		
			mnSystemStatAd.sCPUType := UINT_TO_STRING(IFmnSystem.In.PLC.wMDL_ID);
		
	END_CASE
	
	_wMdlId := IFmnSystem.In.PLC.wMDL_ID;

END_PROGRAM

