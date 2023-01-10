
FUNCTION_BLOCK LoadCell
	
	IF capture_weight_bool THEN	
		brsmemmove(ADR(weight_array[1]), ADR(weight_array), 1498);
		
		weight_array[0] := analog_weight;
		
		IF small_interval > 0 THEN
			small_value := 0;
			FOR i := 0 TO small_interval - 1 DO
			small_value := small_value + weight_array[i];
			END_FOR;
			udp_data.small_smoothing_value := small_smoothing_value := DINT_TO_UINT(small_value / small_interval);
			
		END_IF;
		
		IF large_interval > 0 THEN
			large_value := 0;
			FOR x := 0 TO large_interval - 1 DO
			large_value := large_value + weight_array[x];
			END_FOR;
			
			udp_data.large_smoothing_value := large_smoothing_value := DINT_TO_UINT(large_value / large_interval);
		END_IF;
			
		udp_data.capture_weight := capture_weight := analog_weight;
	END_IF;

	weight_tolerance := (((server_send_weight - tare)/100) * weight_tolerance_percent);
	empty := (analog_weight <= (tare + weight_tolerance)) AND (tare > 0);
	min_weight:= (analog_weight > server_min_weight) AND (server_min_weight > 0);
	near_weight := (analog_weight > server_near_weight) AND (server_near_weight > 0);
	bufflector_door_weight := (analog_weight > server_buffer_weight) AND (server_buffer_weight > 0);
	notify_weight := (analog_weight > server_notify_weight) AND (server_notify_weight > 0);
	full := (analog_weight > server_send_weight) AND (server_send_weight > 0);
	over_weight:= (analog_weight >= server_over_weight);
	
	IF span > 0 THEN
		udp_data.capture_weight_value := capture_weight_value := (((udp_data.capture_weight - tare) * 100) / span);
		udp_data.live_weight_value := live_weight_value := (((analog_weight - tare) * 100) / span);
		udp_data.small_smoothing_weight := small_smoothing_weight := (((udp_data.small_smoothing_value - tare) * 100) / span);
		udp_data.large_smoothing_weight := large_smoothing_weight := (((udp_data.large_smoothing_value - tare) * 100) / span);
	END_IF;
		
END_FUNCTION_BLOCK
