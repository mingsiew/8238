(********************************************************************
 * COPYRIGHT -- Herbert Kannegiesser GmbH
 ********************************************************************
 * Library: libTestUse
 * File: TestUser_StopTask.st
 * Author: hunholz
 * Created: March 06, 2012
 ********************************************************************
 * Implementation of library libTestUse
 ********************************************************************) 

(* Stoppt Task per Namen *)
FUNCTION TestUser_StopTask
	
	TestUser_StopTask := ST_ident(st_name := st_name, st_grp := 0, st_ident := ADR(_lTaskIdent));
	IF TestUser_StopTask <> ERR_OK THEN
		RETURN;
	END_IF
	TestUser_StopTask := ST_tmp_suspend(st_ident := _lTaskIdent);
	
END_FUNCTION