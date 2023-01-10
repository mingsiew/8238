
(* TODO: Add your comment here *)
FUNCTION_BLOCK BCD_Encode

	Output := 0;

	IF Input.0 THEN
		Output := Output + 1;
	END_IF;
	IF Input.1 THEN
		Output := Output + 2;
	END_IF;
	IF Input.2 THEN
		Output := Output + 4;
	END_IF;
	IF Input.3 THEN
		Output := Output + 8;
	END_IF;
	IF Input.4 THEN
		Output := Output + 10;
	END_IF;
	IF Input.5 THEN
		Output := Output + 20;
	END_IF;
	IF Input.6 THEN
		Output := Output + 40;
	END_IF;
	IF Input.7 THEN
		Output := Output + 80;
	END_IF;
	IF Input.8 THEN
		Output := Output + 100;
	END_IF;
	IF Input.9 THEN
		Output := Output + 200;
	END_IF;
	IF Input.10 THEN
		Output := Output + 400;
	END_IF;
	IF Input.11 THEN
		Output := Output + 800;
	END_IF;
	IF Input.12 THEN
		Output := Output + 1000;
	END_IF;
	IF Input.13 THEN
		Output := Output + 2000;
	END_IF;
	IF Input.14 THEN
		Output := Output + 4000;
	END_IF;
	IF Input.15 THEN
		Output := Output + 8000;
	END_IF;

END_FUNCTION_BLOCK
