
(* Returns Text for OPCuA Error ID *)
FUNCTION_BLOCK OPCuaGetErrorMessage
	
	CASE ErrorID OF
			
		16#8000:
			ErrorMessage := 'Unspecified error';	
		16#8001:
			ErrorMessage := 'An unexpected error occurred ';	
		16#8002:
			ErrorMessage := 'An internal error occurred as a result of a programming or configuration errors.';	
		16#8003:
			ErrorMessage := 'Not enough memory to complete the operation.';	
		16#8004:
			ErrorMessage := 'An operating system resource is not available';	
		16#8005:
			ErrorMessage := 'A low level communication error occurred.';	
		16#8006:
			ErrorMessage := 'Encoding halted because of invalid data in the objects being serialized.';	
		16#8007:
			ErrorMessage := 'Decoding halted because of invalid data in the stream.';	
		16#8008:
			ErrorMessage := 'The message encoding/decoding limits have been exceeded.';	
		16#8009:
			ErrorMessage := 'An unrecognized response was received from the server.';	
		16#800A:
			ErrorMessage := 'The operation timed out.';	
		16#800B:
			ErrorMessage := 'The server does not support the requested service.';	
		16#800C:
			ErrorMessage := 'The operation was canceled because the application is shutting down.';	
		16#800D:
			ErrorMessage := 'The operation could not complete because the client is not connected to the server.';	
		16#800E:
			ErrorMessage := 'The server has stopped and cannot process any requests.';	
		16#800F:
			ErrorMessage := 'There was nothing to do because the client passed a list of operations with no elements';	

	
		16#8010:
			ErrorMessage := 'The request could not be processed because it specified too many operations.';
		16#8011:
			ErrorMessage := 'The extension object cannot be (de)serialized because the data type ID is not recognized.';
		16#8012:
			ErrorMessage := 'The certificate provided as a parameter is not valid.';
		16#8013:
			ErrorMessage := 'An error occurred while verifying security.';
		16#8014:
			ErrorMessage := 'The certificate has expired or is not yet valid.';
		16#8015:
			ErrorMessage := 'An issuer certificate has expired or is not yet valid.';	
		16#8016:
			ErrorMessage := 'The hostname used to connect to a Server does not match a hostname in the certificate.';
		16#8017:
			ErrorMessage := 'The URI specified in the application description does not match the URI in the certificate.';
		16#8018:
			ErrorMessage := 'The certificate cannot be used for the requested operation.';
		16#8019:
			ErrorMessage := 'The issuer certificate may not be used for the requested operation';
		16#801A:
			ErrorMessage := 'The certificate is not trusted.';
		16#801B:
			ErrorMessage := 'It was not possible to determine if the certificate has been revoked.';
		16#801C:
			ErrorMessage := 'It was not possible to determine if the issuer certificate has been revoked.';
		16#801D:
			ErrorMessage := 'The certificate has been revoked.';
		16#801E:
			ErrorMessage := 'The issuer certificate has been revoked.';	
		16#801F:
			ErrorMessage := 'User does not have permission to perform the requested operation';
		
		
		16#8020:
			ErrorMessage := 'The user identity token is not valid.';
		16#8021:
			ErrorMessage := 'The user identity token is valid but the server has rejected it.';
		16#8022:
			ErrorMessage := 'The specified secure channel is no longer valid.';
		16#8023:
			ErrorMessage := 'The timestamp is outside the range permitted by the server.';
		16#8024:
			ErrorMessage := ' The nonce does not appear to be a random value or it is not the correct length. ';
		16#8025:
			ErrorMessage := 'The session ID is not valid.';	
		16#8026:
			ErrorMessage := 'The session was closed by the client.';
		16#8027:
			ErrorMessage := ' The session cannot be used because ActivateSession has not been called.';
		16#8028:
			ErrorMessage := 'The subscription ID is not valid';
//		16#8029:
//		ErrorMessage := '';
		16#802A:
			ErrorMessage := ' The header for the request is missing or invalid. ';
		16#802B:
			ErrorMessage := 'The timestamps to return parameter is invalid.';
		16#802C:
			ErrorMessage := 'The request was canceled by the client.';
//		16#802D:
//		ErrorMessage := '';
//		16#802E:
//		ErrorMessage := '';	
//		16#802F:
//		ErrorMessage := '';
		
//		16#8030:
//		ErrorMessage := '';
		16#8031:
			ErrorMessage := 'Communication with the data source is defined but not established, and there is no last known value available.';
		16#8032:
			ErrorMessage := ' Waiting for the server to obtain values from the underlying data source. ';
		16#8033:
			ErrorMessage := 'The syntax of the node ID is not valid.';
		16#8034:
			ErrorMessage := 'The node ID refers to a node that does not exist in the server address space.';
		16#8035:
			ErrorMessage := 'The attribute is not supported for the specified node.';	
		16#8036:
			ErrorMessage := 'The syntax of the index range parameter is invalid. ';
		16#8037:
			ErrorMessage := 'No data exists within the range of indexes specified.';
		16#8038:
			ErrorMessage := 'The data encoding is invalid.';
		16#8039:
			ErrorMessage := 'The server does not support the requested data encoding for the node.';
		16#803A:
			ErrorMessage := 'The access level does not allow reading or subscribing to the node.';
		16#803B:
			ErrorMessage := 'The access level does not allow writing to the node.';
		16#803C:
			ErrorMessage := 'The value was out of range.';
		16#803D:
			ErrorMessage := 'The requested operation is not supported.';
		16#803E:
			ErrorMessage := 'A requested item was not found or a search operation ended without success ';	
		16#803F:
			ErrorMessage := 'The object cannot be used because it has been deleted.';
		
		
		16#8040:
			ErrorMessage := 'Requested operation is not implemented.';
		16#8041:
			ErrorMessage := 'The monitoring mode is invalid.';
		16#8042:
			ErrorMessage := 'The monitoring item ID does not refer to a valid monitored item.';
		16#8043:
			ErrorMessage := 'The monitored item filter parameter is not valid.';
		16#8044:
			ErrorMessage := 'The server does not support the requested monitored item filter.';
		16#8045:
			ErrorMessage := 'A monitoring filter cannot be used in combination with the attribute specified.';	
		16#8046:
			ErrorMessage := 'A mandatory structured parameter was missing or null.';
		16#8047:
			ErrorMessage := 'The event filter is not valid.Identifier unknown';
		16#8048:
			ErrorMessage := 'The content filter is not valid.';
		16#8049:
			ErrorMessage := 'The operand used in a content filter is not valid.';
		16#804A:
			ErrorMessage := 'The continuation point provided is no longer valid.';
		16#804B:
			ErrorMessage := 'The operation could not be processed because all continuation points have been allocated.';
		16#804C:
			ErrorMessage := 'The reference type ID does not refer to a valid reference type node.';
		16#804D:
			ErrorMessage := 'The browse direction is not valid.';
		16#804E:
			ErrorMessage := 'The node is not part of the view.';	
		16#804F:
			ErrorMessage := 'The server URI is not a valid URI.';
		
		16#8050:
			ErrorMessage := 'No server name was specified.';
		16#8051:
			ErrorMessage := 'No discovery URL was specified.';
		16#8052:
			ErrorMessage := 'The semaphore file specified by the client is not valid.';
		16#8053:
			ErrorMessage := 'The security token request type is not valid.';
		16#8054:
			ErrorMessage := 'The security mode does not meet the requirements set by the server.';
		16#8055:
			ErrorMessage := 'The security policy does not meet the requirements set by the server.';	
		16#8056:
			ErrorMessage := 'The server has reached its maximum number of sessions.';
		16#8057:
			ErrorMessage := 'The user token signature is missing or invalid.';
		16#8058:
			ErrorMessage := 'The signature generated with the client certificate is missing or invalid.';
		16#8059:
			ErrorMessage := 'The client did not provide at least one software certificate that is valid and meets the profile requirements for the server.';
		16#805A:
			ErrorMessage := 'The request was canceled by the client with the cancel service.';
		16#805B:
			ErrorMessage := 'The parent node ID does not to refer to a valid node.';
		16#805C:
			ErrorMessage := 'The reference could not be created because it violates limitations imposed by the data model.';
		16#805D:
			ErrorMessage := 'The requested node ID was reject because it was either invalid or server does not allow node IDs to be specified by the client.';
		16#805E:
			ErrorMessage := 'The requested node ID is already used by another node.';	
		16#805F:
			ErrorMessage := 'The node class is not valid.';
		
		
		16#8060:
		ErrorMessage := 'The browse name is invalid.';
		16#8061:
		ErrorMessage := 'The browse name is not unique among nodes that share the same relationship with the parent.';
		16#8062:
		ErrorMessage := 'The node attributes are not valid for the node class.';
		16#8063:
		ErrorMessage := 'The type definition node ID does not reference an appropriate type node.';
		16#8064:
		ErrorMessage := 'The source node ID does not reference a valid node. ';
		16#8065:
		ErrorMessage := 'The target node ID does not reference a valid node.';	
		16#8066:
		ErrorMessage := 'The reference type between the nodes is already defined.';
		16#8067:
		ErrorMessage := 'The server does not allow this type of self reference on this node. ';
		16#8068:
		ErrorMessage := 'The reference type is not valid for a reference to a remote server. ';
		16#8069:
		ErrorMessage := 'The server will not allow the node to be deleted. ';
		16#806A:
		ErrorMessage := 'The server index is not valid. ';
		16#806B:
		ErrorMessage := 'The view ID does not refer to a valid view node.';
//		16#806C:
//		ErrorMessage := '';
		16#806D:
		ErrorMessage := 'The requested operation has too many matches to return.';
		16#806E:
		ErrorMessage := 'The requested operation requires too many resources in the server.';	
		16#806F:
		ErrorMessage := 'The requested operation has no match to return.';
		
		16#8070:
		ErrorMessage := ' The max age parameter is invalid. ';
		16#8071:
		ErrorMessage := 'The history details parameter is not valid.';
		16#8072:
		ErrorMessage := 'The server does not support the requested operation.';
		16#8073:
		ErrorMessage := 'The server not does support writing the combination of value, status and timestamps provided.';
		16#8074:
		ErrorMessage := 'The value provided for the attribute is not of the same type as the attributes value.';
		16#8075:
		ErrorMessage := 'The method ID does not refer to a method for the specified object.';	
		16#8076:
		ErrorMessage := 'The client did not specify all of the input arguments for the method. ';
		16#8077:
		ErrorMessage := 'The server has reached its maximum number of subscriptions.';
		16#8078:
		ErrorMessage := 'The server has reached the maximum number of queued publish requests.';
		16#8079:
		ErrorMessage := 'There is no subscription available for this session. ';
		16#807A:
		ErrorMessage := 'The sequence number is unknown to the server.';
		16#807B:
		ErrorMessage := 'The requested notification message is no longer available.';
		16#807C:
		ErrorMessage := 'The client of the current session does not support one or more profiles required for the subscription.';
		16#807D:
		ErrorMessage := 'The server cannot process the request because it is too busy.';
		16#807E:
		ErrorMessage := 'The type of the message specified in the header invalid.';	
		16#807F:
		ErrorMessage := 'The secure channel ID and/or token ID are not currently in use.';
		
		
		16#8080:
			ErrorMessage := 'The size of the message specified in the header is too large.';
		16#8081:
			ErrorMessage := 'There are not enough resources to process the request.';
		16#8082:
			ErrorMessage := 'An internal error occurred.';
		16#8083:
			ErrorMessage := 'The server does not recognize the query string specified.';
		16#8084:
			ErrorMessage := 'The request could not be sent because of a network interruption.';
		16#8085:
			ErrorMessage := 'Timeout occurred while processing the request';	
		16#8086:
			ErrorMessage := 'The secure channel has been closed.';
		16#8087:
			ErrorMessage := 'The token has expired or is not recognized.';
		16#8088:
			ErrorMessage := 'The sequence number is not valid.';
		16#8089:
			ErrorMessage := 'There is a problem with the configuration that affects the usefulness of the value';
		16#808A:
			ErrorMessage := 'The variable should receive its value from another variable, but has never been configured to do so.';
		16#808B:
			ErrorMessage := 'There has been a failure in the device/data source that generates the value that has affected the value.';
		16#808C:
			ErrorMessage := 'There has been a failure in the sensor from which the value is derived by the device/data source.';
		16#808D:
			ErrorMessage := 'The source of the data is not operational.';
		16#808E:
			ErrorMessage := 'The deadband filter is not valid.';	
//		16#808F:
//		ErrorMessage := '';
		
		
		
		
//		16#8090:
//		ErrorMessage := '';
//		16#8091:
//		ErrorMessage := '';
//		16#8092:
//		ErrorMessage := '';
//		16#8093:
//		ErrorMessage := '';
//		16#8094:
//		ErrorMessage := '';
//		16#8095:
//		ErrorMessage := '';	
//		16#8096:
//		ErrorMessage := '';
		16#8097:
			ErrorMessage := 'This condition refresh failed; a condition refresh operation is already in progress.';
		16#8098:
			ErrorMessage := 'This condition has already been disabled.';
		16#8099:
			ErrorMessage := ' Property not available, this condition is disabled. ';
		16#809A:
			ErrorMessage := 'The specified event ID is not recognized.';
		16#809B:
			ErrorMessage := ' No data is available for the desired time domain or event filter. ';
//		16#809C:
//		ErrorMessage := '';
		16#809D:
			ErrorMessage := 'Data is missing due to collection started/stopped/lost.';
		16#809E:
			ErrorMessage := 'Expected data is unavailable for the requested time range due to an unmounted data storage medium, an offline archive or tape or similar reason for temporary unavailability.';	
		16#809F:
			ErrorMessage := ' The data or event was not successfully inserted because a matching entry exists.';
		
		
		16#80A0:
			ErrorMessage := 'The data or event was not successfully updated because no matching entry exists.';
		16#80A1:
			ErrorMessage := 'The client requested history using a timestamp format the server does not support (i.e requested server timestamp when server only supports source timestamp).';
//		16#80A2:
//		ErrorMessage := '';
//			16#80A3:
//		ErrorMessage := '';
//			16#80A4:
//		ErrorMessage := '';
//		16#80A5:
//		ErrorMessage := '';	
//		16#80A6:
//		ErrorMessage := '';
//		16#80A7:
//		ErrorMessage := '';
//		16#80A8:
//		ErrorMessage := '';
//		16#80A9:
//		ErrorMessage := '';
//		16#80AA:
//		ErrorMessage := '';
		16#80AB:
			ErrorMessage := 'One or more arguments are invalid.';
		16#80AC:
			ErrorMessage := 'Could not establish a network connection to remote server.';
		16#80AD:
			ErrorMessage := 'The server has disconnected from the client.';
		16#80AE:
			ErrorMessage := 'The network connection has been closed.';	
		16#80AF:
			ErrorMessage := 'The operation cannot be completed because the object is closed, uninitialized or in some other invalid state.';
		
		16#80B0:
		ErrorMessage := 'Cannot move beyond end of the stream.';
		16#80B1:
		ErrorMessage := 'No data is currently available for reading from a non-blocking stream.';
		16#80B2:
		ErrorMessage := 'The asynchronous operation is waiting for a response. ';
		16#80B3:
		ErrorMessage := 'The asynchronous operation was abandoned by the caller. ';
		16#80B4:
		ErrorMessage := 'The stream did not return all data requested (possibly because it is a non-blocking stream).';
		16#80B5:
		ErrorMessage := 'Non-blocking behavior is required and the operation would block.';	
		16#80B6:
		ErrorMessage := 'A value had an invalid syntax.';
		16#80B7:
		ErrorMessage := 'The operation could not be finished because all available connections are in use.';
		16#80B8:
		ErrorMessage := 'The request message size exceeds limits set by the server.';
		16#80B9:
		ErrorMessage := 'The response message size exceeds limits set by the client.';
//		16#80BA:
//		ErrorMessage := '';
		16#80BB:
		ErrorMessage := ' The event cannot be acknowledged. ';
//		16#80BC:
//		ErrorMessage := '';
		16#80BD:
		ErrorMessage := 'The defined timestamp to return was invalid.';
		16#80BE:
		ErrorMessage := 'The applications do not have compatible protocol versions.';	
		16#80BF:
		ErrorMessage := 'The sub-state machine is not currently active.';
		
		
//		16#80C0:
//		ErrorMessage := '';
		16#80C1:
		ErrorMessage := ' An unrecognized operator was provided in a filter. ';
		16#80C2:
		ErrorMessage := 'A valid operator was provided, but the server does not provide support for this filter operator.';
		16#80C3:
		ErrorMessage := 'The number of operands provided for the filter operator was less then expected for the operand provided.';
		16#80C4:
		ErrorMessage := 'The referenced element is not a valid element in the content filter.';
		16#80C5:
		ErrorMessage := 'The referenced literal is not a valid value.';	
		16#80C6:
		ErrorMessage := 'The server does not support changing the user identity assigned to the session.';
//		16#80C7:
//		ErrorMessage := '';
		16#80C8:
		ErrorMessage := 'The provided node ID was not a type definition node ID. ';
		16#80C9:
		ErrorMessage := 'The view timestamp is not available or not supported.';
		16#80CA:
		ErrorMessage := 'The view parameters are not consistent with each other.';
		16#80CB:
		ErrorMessage := 'The view version is not available or not supported';
		16#80CC:
		ErrorMessage := 'This condition has already been enabled.';
		16#80CD:
		ErrorMessage := 'The dialog box state is not active.';
		16#80CE:
		ErrorMessage := 'The response is not valid for the dialog box.';	
		16#80CF:
		ErrorMessage := ' The condition branch has already been acknowledged. ';
		
		16#80D0:
			ErrorMessage := 'The condition branch has already been confirmed.';
		16#80D1:
			ErrorMessage := 'The condition has already been shelved.';
		16#80D2:
			ErrorMessage := 'The condition is not currently shelved.';
		16#80D3:
			ErrorMessage := 'The shelving time not within an acceptable range.';
		16#80D4:
			ErrorMessage := 'The requested number of aggregates does not match the requested number of node IDs.';
		16#80D5:
			ErrorMessage := ' The requested aggregate is not support by the server.';	
		16#80D6:
			ErrorMessage := 'The aggregate value could not be derived due to invalid data inputs.';
		16#80D7:
			ErrorMessage := 'No data found to provide upper or lower bound value.';
		16#80D8:
			ErrorMessage := 'The server cannot retrieve a bound for the variable.';
//		16#80D9:
//			ErrorMessage := '';
		16#80DA:
			ErrorMessage := 'The aggregate configuration is not valid for specified node.';
		16#80DB:
			ErrorMessage := ' The request could not be processed because there are too many monitored items in the subscription. ';
//		16#80DC:
//		ErrorMessage := '';
//		16#80DD:
//		ErrorMessage := '';
//		16#80DE:
//		ErrorMessage := '';	
//		16#80DF:
//		ErrorMessage := '';
		
		ELSE	
			ErrorMessage := '';	
	END_CASE;
	
	
	
END_FUNCTION_BLOCK
