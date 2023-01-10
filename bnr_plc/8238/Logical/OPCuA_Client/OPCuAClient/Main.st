
PROGRAM _INIT

	#if (MAX_OPCuA_CLIENTS < MAX_INWATEC_INTERFACES)	
		#error 'Not enough opcua clients for Inwatec'	
	#endif	

	_inwatec_config;	

	////Test connection.	
	//OPCuA_Client[3].Config.ServerURL :=	'opc.tcp://10.8.4.20:4840';  // IP Address of interface.		
	//	
	//OPCuA_Client[3].Config.SessionUser.UserIdentityTokenType := UAUITT_Username;
	//OPCuA_Client[3].Config.SessionUser.TokenParam1 := 'test';  //UserName
	//OPCuA_Client[3].Config.SessionUser.TokenParam2 := 'test';  //Password
	//
	//
	////Set the Vars.
	//OPCuA_Client[3].Config.Data.Read[0].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Write.Heartbeat';  
	//OPCuA_Client[3].Config.Data.Read[0].Variable := 'TestRead[0]';
	//OPCuA_Client[3].Config.Data.Read[1].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Write.PermissionToMove';
	//OPCuA_Client[3].Config.Data.Read[1].Variable := 'TestRead[1]';
	//OPCuA_Client[3].Config.Data.Read[2].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Write.ReleaseBag';
	//OPCuA_Client[3].Config.Data.Read[2].Variable := 'TestRead[2]';
	//OPCuA_Client[3].Config.Data.Read[3].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Write.ReceiveBag';
	//OPCuA_Client[3].Config.Data.Read[3].Variable := 'TestRead[3]';
	//
	//OPCuA_Client[3].Config.Data.Write[0].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Read.Heartbeat';
	//OPCuA_Client[3].Config.Data.Write[0].Variable := 'TestWrite[0]';
	//OPCuA_Client[3].Config.Data.Write[1].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Read.Auto';
	//OPCuA_Client[3].Config.Data.Write[1].Variable := 'TestWrite[1]';
	//OPCuA_Client[3].Config.Data.Write[2].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Read.Manual';
	//OPCuA_Client[3].Config.Data.Write[2].Variable := 'TestWrite[2]';
	//OPCuA_Client[3].Config.Data.Write[3].NodeID.Identifier := '::AsGlobalPV:OpcUa.VC[231].Read.ChuteBlocked';
	//OPCuA_Client[3].Config.Data.Write[3].Variable := 'TestWrite[3]';	



	FOR x := 1 TO MAX_OPCuA_CLIENTS DO
		client ACCESS ADR (OPCuA_Client[x]);
		client.Config.SessionInfo.SessionName := 'supertrack';
		client.Config.SessionInfo.ApplicationName := '';
		client.Config.SessionInfo.SecurityMsgMode := UASecurityMsgMode_Sign;//UASecurityMsgMode_BestAvailab;
		client.Config.SessionInfo.SecurityPolicy := UASecurityPolicy_Basic256Sha256;//UASecurityPolicy_BestAvailable;
		client.Config.SessionInfo.CertificateStore := '';
		client.Config.SessionInfo.ClientCertificateName := '';
		client.Config.SessionInfo.ServerUri := '';
		client.Config.SessionInfo.CheckServerCertificate := 0;
		client.Config.SessionInfo.TransportProfile := UATP_UATcp;
		client.Config.SessionInfo.UserIdentityToken := client.Config.SessionUser;
		client.Config.SessionInfo.VendorSpecificParameter := '';
		client.Config.SessionInfo.SessionTimeout := T#5s;
		client.Config.SessionInfo.MonitorConnection := T#500ms;
		//client.Config.SessionInfo.LocaleIDs

		client.Config.Data.ReadCount := MAX_READ_NODES;
		FOR i := 0 TO MAX_READ_NODES DO
			client.Config.Data.Read[i].NodeID.IdentifierType := UAIdentifierType_String;
			client.Config.Data.Read[i].NodeInfo.AttributeId := UAAI_Value;
			IF (client.Config.Data.Read[i].NodeID.Identifier = '') THEN
				client.Config.Data.ReadCount := i;
				EXIT;	
			END_IF;	
		END_FOR;

		client.Config.Data.WriteCount := MAX_WRITE_NODES;
		FOR i := 0 TO MAX_WRITE_NODES DO
			client.Config.Data.Write[i].NodeID.IdentifierType := UAIdentifierType_String;
			client.Config.Data.Write[i].NodeInfo.AttributeId := UAAI_Value;	
			IF (client.Config.Data.Write[i].NodeID.Identifier = '') THEN
				client.Config.Data.WriteCount := i;
				EXIT;	
			END_IF;
		END_FOR;

		client.Functions.RetryTimer.PT := T#5s; // Time to try to reconnect if the server isn;t available.
	END_FOR;

END_PROGRAM

PROGRAM _CYCLIC
//MAX of 40 Connections.

	FOR x := 1 TO MAX_OPCuA_CLIENTS DO
		client ACCESS ADR (OPCuA_Client[x]);
		f ACCESS ADR(client.Functions);
		IF client.Config.ServerURL <> '' THEN


			f.Connect.Execute 			:= (client.State = OPCuA_CLIENT_STATE_CONNECT);
			f.GetNameSpace.Execute	:= (client.State = OPCuA_CLIENT_STATE_GET_NAMESPACE);
			f.ReadBulk.Execute := f.WriteBulk.Execute	:= (client.State = OPCuA_CLIENT_STATE_READ_WRITE);
			f.Disconnect.Execute 		:= (client.State = OPCuA_CLIENT_STATE_DISCONNECT);

			CASE client.State OF

				OPCuA_CLIENT_STATE_CONNECT:
					f.Connect.ServerEndpointUrl := client.Config.ServerURL;
					f.Connect.SessionConnectInfo := client.Config.SessionInfo;
					f.Connect.Timeout := T#1s;
					IF f.Connect.Done THEN	
						client.State := OPCuA_CLIENT_STATE_GET_NAMESPACE;
					ELSIF f.Connect.Error THEN	
						client.Error.ErrorState := client.State;
						client.State := OPCuA_CLIENT_STATE_ERROR;
						client.Error.ErrorID :=  f.Connect.ErrorID;
					END_IF;	

				OPCuA_CLIENT_STATE_GET_NAMESPACE:
					f.GetNameSpace.ConnectionHdl  := f.Connect.ConnectionHdl;
					f.GetNameSpace.NamespaceUri		:= 'urn:B&R/pv/';
					f.GetNameSpace.Timeout 				:= T#1s;						

					IF f.GetNameSpace.Done THEN
						client.State := OPCuA_CLIENT_STATE_BUILD_DATA;
					ELSIF f.GetNameSpace.Error THEN	
						client.Error.ErrorState := client.State;
						client.State := OPCuA_CLIENT_STATE_ERROR;
						client.Error.ErrorID :=  f.GetNameSpace.ErrorID;	
					END_IF;	

				OPCuA_CLIENT_STATE_BUILD_DATA:

					FOR i := 0 TO client.Config.Data.ReadCount DO
						client.ReadData.NodeID[i].NamespaceIndex 	:= f.GetNameSpace.NamespaceIndex;
						client.ReadData.NodeID[i].IdentifierType 	:= client.Config.Data.Read[i].NodeID.IdentifierType;
						client.ReadData.NodeID[i].Identifier 			:= client.Config.Data.Read[i].NodeID.Identifier;
						client.ReadData.NodeInfo[i].AttributeId 	:= client.Config.Data.Read[i].NodeInfo.AttributeId;
						client.ReadData.Variable[i]								:= client.Config.Data.Read[i].Variable;
					END_FOR;

					FOR i := 0 TO client.Config.Data.WriteCount DO
						client.WriteData.NodeID[i].NamespaceIndex 	:= f.GetNameSpace.NamespaceIndex;
						client.WriteData.NodeID[i].IdentifierType 	:= client.Config.Data.Write[i].NodeID.IdentifierType;
						client.WriteData.NodeID[i].Identifier 			:= client.Config.Data.Write[i].NodeID.Identifier;
						client.WriteData.NodeInfo[i].AttributeId 		:= client.Config.Data.Write[i].NodeInfo.AttributeId;
						client.WriteData.Variable[i]								:= client.Config.Data.Write[i].Variable;

					END_FOR;


					client.State := OPCuA_CLIENT_STATE_READ_WRITE;


				OPCuA_CLIENT_STATE_READ_WRITE:
					f.ReadBulk.ConnectionHdl 	:= f.Connect.ConnectionHdl;
					f.ReadBulk.NodeIDCount 		:= client.Config.Data.ReadCount;
					f.ReadBulk.NodeAddInfo 		:= ADR(client.ReadData.NodeInfo);
					f.ReadBulk.NodeErrorIDs 	:= ADR(client.ReadData.ErrorID);
					f.ReadBulk.NodeIDs 				:= ADR(client.ReadData.NodeID);
					f.ReadBulk.TimeStamps 		:= ADR(client.ReadData.TimeStamps);
					f.ReadBulk.Variables 			:= ADR(client.ReadData.Variable);
					f.ReadBulk.Timeout 				:= T#1500ms;
					IF f.ReadBulk.Done THEN
						f.ReadBulk.Execute := 0; // Read Cyclica
						f.ReadBulk;
					ELSIF f.ReadBulk.Error THEN
						IF 	f.ReadBulk.ErrorID = OPCuA_ERR_OUT_OF_SERVICE THEN
							client.State := OPCuA_CLIENT_STATE_DISCONNECT;
						ELSE
							client.Error.ErrorState := client.State;
							client.State := OPCuA_CLIENT_STATE_ERROR;
							IF (f.ReadBulk.ErrorID > 0) THEN 
								client.Error.ErrorID := f.ReadBulk.ErrorID;
							ELSE
								//Look for the bad node..
								FOR i := 0 TO client.Config.Data.ReadCount DO
									IF (client.ReadData.ErrorID[i] > 0) THEN	
										client.Error.ErrorID := client.ReadData.ErrorID[i];
										client.Error.ErrorNode := i;
										EXIT;
									END_IF;	
								END_FOR;	
							END_IF;	
						END_IF;

					END_IF


					//Disadvantage of writing like this, is we are always pushing just like tradional TCP.
					f.WriteBulk.ConnectionHdl := f.Connect.ConnectionHdl;
					f.WriteBulk.NodeIDCount		:= client.Config.Data.WriteCount;
					f.WriteBulk.NodeAddInfo		:= ADR(client.WriteData.NodeInfo);
					f.WriteBulk.NodeErrorIDs	:= ADR(client.WriteData.ErrorID);
					f.WriteBulk.NodeIDs				:= ADR(client.WriteData.NodeID);
					f.WriteBulk.Variables			:= ADR(client.WriteData.Variable);
					f.WriteBulk.Timeout				:= T#1500ms;

					IF f.WriteBulk.Done THEN
						f.WriteBulk.Execute := 0; // Read Cyclica
						f.WriteBulk();
					ELSIF f.WriteBulk.Error THEN
						IF 	f.WriteBulk.ErrorID = OPCuA_ERR_OUT_OF_SERVICE THEN
							client.State := OPCuA_CLIENT_STATE_DISCONNECT;
						ELSE
							client.Error.ErrorState := OPCuA_CLIENT_STATE_READ_WRITE + 1000;// Add 1000 to show its a write failure.
							client.State := OPCuA_CLIENT_STATE_ERROR;
							IF (f.WriteBulk.ErrorID > 0) THEN 
								client.Error.ErrorID := f.WriteBulk.ErrorID;
							ELSE
								//Look for the bad node..
								FOR i := 0 TO client.Config.Data.WriteCount DO
									IF (client.WriteData.ErrorID[i] > 0) THEN	
										client.Error.ErrorID := client.WriteData.ErrorID[i];
										client.Error.ErrorNode := i;
										EXIT;
									END_IF;	
								END_FOR;	
							END_IF;	
						END_IF;

					END_IF;

				OPCuA_CLIENT_STATE_DISCONNECT:
					f.Disconnect.ConnectionHdl := f.Connect.ConnectionHdl;
					f.Disconnect.Timeout := T#2s;
					IF f.Disconnect.Done THEN	
						client.State := OPCuA_CLIENT_STATE_CONNECT;
					ELSIF f.Disconnect.Error THEN
						IF (f.Connect.ConnectionHdl = 0) OR (f.Disconnect.ErrorID = 16#A0080000) OR (f.Disconnect.ErrorID = 16#80AD0000)  THEN
							client.State := OPCuA_CLIENT_STATE_CONNECT;
						ELSE	
							//client.State := OPCuA_CLIENT_STATE_ERROR;
							//client.Error.ErrorID := f.Disconnect.ErrorID;	
						END_IF;	
					END_IF;

				OPCuA_CLIENT_STATE_ERROR:			
					//Maybe should just write to a logger then restart!
					IF client.Functions.RetryTimer.Q THEN
						IF (f.Connect.ConnectionHdl > 0) THEN
							client.State := OPCuA_CLIENT_STATE_DISCONNECT; // Always try to disconnect any open connections before reconnecting.
						ELSE
							client.State := OPCuA_CLIENT_STATE_CONNECT;	
						END_IF;	
					ELSIF (client.Error.ErrorID = OPCuA_ERR_TIMEOUT) THEN	
						//				client.Functions.RetryTimer.IN := 1;	
						//			ELSE
						//				client.State := OPCuA_CLIENT_STATE_DISCONNECT;	
					END_IF;	



			END_CASE;		
			client.Functions.ErrorStatePLS.CLK := (client.State = OPCuA_CLIENT_STATE_ERROR);
			client.Functions.ErrorStatePLS();	

			IF client.Functions.ErrorStatePLS.Q THEN	
				brsmemcpy(ADR(client.Error.ErrorCode),ADR(client.Error.ErrorID) + 2,2);	
				getErrorText.ErrorID := client.Error.ErrorCode;
				getErrorText();
				client.Error.Message := 	getErrorText.ErrorMessage;	
			END_IF;

			f.Connect();
			f.GetNameSpace();
			f.ReadBulk();
			f.WriteBulk();
			f.Disconnect();
			client.Functions.RetryTimer.IN := (client.State = OPCuA_CLIENT_STATE_ERROR);
			client.Functions.RetryTimer();
		//client.Functions.RetryTimer.IN := 0;	
		END_IF;
	END_FOR;	
	//TestRead;// 
	//TestWrite;
	//	TestReadx;// 
	//	TestWritex;			
	
END_PROGRAM

PROGRAM _EXIT
(* Insert code here *)

END_PROGRAM

