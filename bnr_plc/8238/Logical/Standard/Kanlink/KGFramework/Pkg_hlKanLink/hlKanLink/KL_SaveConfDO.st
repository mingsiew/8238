(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Program: WetLink
 * File: WL_SaveConfDO.st
 * Author: stahlhut
 * Created: January 09, 2012
 ********************************************************************
 * Implementation of program WetLink
 ********************************************************************) 

(* Speichern der Parameter in Datenobjekt *)
FUNCTION_BLOCK KL_SaveConfDO
CASE iSaveStep  OF 
	0: ;
	 // DO vorhanden?

		status :=ERR_FUB_BUSY;

		DatObjInfo_0.enable := TRUE;
 		DatObjInfo_0.pName := adrName;
		DatObjInfo_0;
		IF DatObjInfo_0.status = ERR_FUB_BUSY THEN 
  			// warten
		ELSIF DatObjInfo_0.status = 0 THEN 
			// DO existiert, weiter mit löschen
			iSaveStep := 2;
		ELSIF DatObjInfo_0.status = doERR_MODULNOTFOUND THEN 
			// Do existiert nicht, weiter mit Schreiben
			iSaveStep := 3;
		ELSE // fehler aufgetreten
			status := 3; 
			iSaveStep := 0;
		END_IF;
	2: // löschen

		status :=ERR_FUB_BUSY;
		DatObjDelete_0(enable := 1 , ident := DatObjInfo_0.ident);
		CASE DatObjDelete_0.status OF
  			0: // fertig
				iSaveStep := 3;
			ERR_FUB_BUSY: 
				// warten
			ELSE // fehler
				status :=4;
				iSaveStep := 0;
		END_CASE;
	3:	
		DatObjCreate_0.enable := 1;
		DatObjCreate_0.MemType := doUSRROM;
		DatObjCreate_0.pName := adrName;
		DatObjCreate_0.pCpyData := adrDaten;
		DatObjCreate_0.len := len;
		DatObjCreate_0;
		CASE DatObjCreate_0.status OF
  			0: //fertig
				iSaveStep:= 0;
				status :=0;
				
			ERR_FUB_BUSY: 
				// warten
				status := ERR_FUB_BUSY;
			ELSE
   				// fehler 
				status := 5;
		END_CASE;						
	ELSE
		iSaveStep := 0;
		status := 6;
END_CASE;	

END_FUNCTION_BLOCK
