//V1.00.1  - TR - Add simulution mode.


PROGRAM _INIT
 
	selectedVC := 240;
	
END_PROGRAM


PROGRAM _CYCLIC

	MTBasicsPWM_0.DutyCycle		:= 50;
	MTBasicsPWM_0.Period		:= 2;
	MTBasicsPWM_0.Enable		:= TRUE;
	MTBasicsPWM_0(Enable:= TRUE,DutyCycle:= 50,Period:= 2,Update := 1);
	
	//FOR i := 38 TO 39 DO

	
pHmiOpcUa ACCESS ADR(OpcUa.VC[selectedVC]);
	
	

IF Std.TestMode THEN
		FOR i := 231 TO 254 DO
			
			hoist ACCESS ADR (OpcUa.VC[i]);
			
			hoist.Read.Heartbeat				:= MTBasicsPWM_0.Out; // NOT OpcUa.VC[i].Write.Heartbeat;
			hoist.Read.PositionNo 			:=	hoist.Write.TargetPosition;
			hoist.Read.Auto							:= 1;
			hoist.Read.ReadyToReceive 	:= 1;
			hoist.Read.IsHome						:= 1;
			
			ton_simulateRecv[i].IN 			:= 	hoist.Write.ReceiveBag;
			ton_simulateRecv[i].PT 			:= T#5s;
			ton_simulateRecv[i]();
			
			hoist.Read.ReceiveBag := ton_simulateRecv[i].Q;
			
			IF ton_simulateRecv[i].Q THEN
				hoist.Read.BagOnCarriage := 1; 
			ELSIF hoist.Write.ReleaseBag THEN
				hoist.Read.BagOnCarriage := 0; 
			END_IF;
		
		END_FOR;	
	
		
ELSE		
		FOR i := 231 TO 254 DO
			OpcUa.VC[i].Write.Heartbeat	:= MTBasicsPWM_0.Out; // NOT OpcUa.VC[i].Write.Heartbeat;
			//OpcUa.VC[i].Write.Heartbeat	:= pulse.Out;
	
			OpcUa.VC[i].Read.StatusInfo;
			OpcUa.VC[i].Read.ActPosition;
			OpcUa.VC[i].Read.PositionNo;
			OpcUa.VC[i].Read.ReceiveBag;
			OpcUa.VC[i].Read.ReleaseBag;
			OpcUa.VC[i].Read.Heartbeat;
			OpcUa.VC[i].Read.ReadyToReceive;

		END_FOR;	

END_IF;
	
	
	
	
	(* Establish a connection to the client *)
	
	
(*	ReadHeartbeat;
	
	
	CASE Connect_to_OpcUaServer_step OF
		
		WAIT:
		
			IF Connect_OpcUa THEN
			
				Connect_to_OpcUaServer_step := CONNECT_TO_OPCUA;
			END_IF;
				
				
		CONNECT_TO_OPCUA:
			
			SessionConnectInfo_0.SecurityMsgMode := UASecurityMsgMode_None; 
			SessionConnectInfo_0.SecurityPolicy := UASecurityPolicy_None; 
			SessionConnectInfo_0.TransportProfile := UATP_UATcp; 
			SessionConnectInfo_0.UserIdentityToken.UserIdentityTokenType := UAUITT_Anonymous; 
			SessionConnectInfo_0.SessionTimeout := T#10m; 
			SessionConnectInfo_0.MonitorConnection := T#10s;
				
			UA_Connect_0.ServerEndpointUrl := 'opc.tcp://10.44.10.244:4840';
			UA_Connect_0.Timeout := T#10s;
			UA_Connect_0.Execute := TRUE;
			UA_Connect_0.SessionConnectInfo := SessionConnectInfo_0;
				

			IF (UA_Connect_0.Done = 1) THEN 
				UA_Connect_0.Execute := FALSE;
				Connect_OpcUa := FALSE; 
				ConnectionHdl := UA_Connect_0.ConnectionHdl; 
				Connect_to_OpcUaServer_step := GET_NAMESPACE;
			END_IF;
	
			IF (UA_Connect_0.Error = 1) THEN 
				ConnectionHdl := 0;
				UA_Connect_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := ERROR_OPCUA;
			END_IF;
		
			
		GET_NAMESPACE:
		
			UA_GetNamespaceIndex_0.ConnectionHdl := ConnectionHdl;
			UA_GetNamespaceIndex_0.NamespaceUri := 'urn:B&R/pv/';
			UA_GetNamespaceIndex_0.Timeout := T#5s;
			UA_GetNamespaceIndex_0.Execute := TRUE;

				
			IF (UA_GetNamespaceIndex_0.Done = 1) THEN 
				NamespaceIndex := UA_GetNamespaceIndex_0.NamespaceIndex; 
				UA_GetNamespaceIndex_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := GET_NODE_HANDLE;
			END_IF;
			
			IF (UA_GetNamespaceIndex_0.Error = 1) THEN 
				NamespaceIndex := 0;
				UA_GetNamespaceIndex_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := ERROR_OPCUA;
			END_IF; 

		
		
		GET_NODE_HANDLE:
		
			UANodeID_0[0].NamespaceIndex := NamespaceIndex;
			UANodeID_0[0].Identifier := '::Test_OpcUa_Client:WriteHeartbeat';
			UANodeID_0[0].IdentifierType := UAIdentifierType_String;		
					
			
			UA_NodeGetHandleList_0.ConnectionHdl := ConnectionHdl;
			UA_NodeGetHandleList_0.NodeIDCount := 1;
			UA_NodeGetHandleList_0.NodeIDs := UANodeID_0;
			UA_NodeGetHandleList_0.Timeout := T#10s;
			UA_NodeGetHandleList_0.Execute := TRUE;

			IF (UA_NodeGetHandleList_0.Done = 1) THEN 
				NodeHdls := UA_NodeGetHandleList_0.NodeHdls; 
				UA_NodeGetHandleList_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := READ_LIST;
			END_IF;
			
			IF (UA_NodeGetHandleList_0.Error = 1) THEN 
				NodeHdls[0] := 0;

				UA_NodeGetHandleList_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := ERROR_OPCUA;
			END_IF;
		
		READ_LIST:
			
			UANodeAdditionalInfo_0[0].AttributeId := UAAI_Value;
			UANodeAdditionalInfo_0[0].IndexRangeCount := 0;
					
			Variable_Rd0[0] := '::ServerTask:ReadHeartbeat';
			
			
			IF NOT UA_ReadList_0.Done THEN
				
				UA_ReadList_0
					(
					Execute := TRUE,
					ConnectionHdl := ConnectionHdl,
					NodeHdlCount := 1,
					NodeHdls := NodeHdls,
					NodeAddInfo := UANodeAdditionalInfo_0,
					Timeout := T#10s,
				Variables := Variable_Rd0);

				IF (UA_ReadList_0.Busy = 0) THEN 
					UA_ReadList_0.Execute := FALSE; 
				
					IF (UA_ReadList_0.Done = 1) THEN 
						TimestampHeart := UA_ReadList_0.TimeStamps[0];

					END_IF;
					IF (UA_ReadList_0.Error = 1) THEN 
						TimestampHeart := 0;
						Connect_to_OpcUaServer_step := ERROR_OPCUA;
					END_IF;
				END_IF;
			
			ELSIF StopReading THEN	
				Connect_to_OpcUaServer_step := RELEASE_NODE;
				UA_ReadList_0.Execute := FALSE;
				
			ELSE 
				UA_ReadList_0
					(
					Execute := FALSE,
					ConnectionHdl := ConnectionHdl,
					NodeHdlCount := 1,
					NodeHdls := NodeHdls,
					NodeAddInfo := UANodeAdditionalInfo_0,
					Timeout := T#10s,
				Variables := Variable_Rd0);
			END_IF;
	
			
		RELEASE_NODE:
		
			UA_NodeReleaseHandleList_0.ConnectionHdl := ConnectionHdl;
			UA_NodeReleaseHandleList_0.NodeHdlCount := 1;
			UA_NodeReleaseHandleList_0.NodeHdls := NodeHdls;
			UA_NodeReleaseHandleList_0.Timeout := T#10s;
			UA_NodeReleaseHandleList_0.Execute := TRUE;
			StopReading := FALSE;

				
			IF (UA_NodeReleaseHandleList_0.Done = 1) THEN 
				NodeHdls[0] := 0;
 
				UA_NodeReleaseHandleList_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := DISCONNECT_OPCUA;
			END_IF;
			
			IF (UA_NodeReleaseHandleList_0.Error = 1) THEN 
				NodeHdls[0] := 0; 
				
				UA_NodeReleaseHandleList_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := ERROR_OPCUA;
			END_IF;
		
		DISCONNECT_OPCUA:
		
			UA_Disconnect_0.ConnectionHdl := ConnectionHdl;
			UA_Disconnect_0.Timeout := T#10s;
			UA_Disconnect_0.Execute := TRUE;

			IF (UA_Disconnect_0.Done = 1) THEN 
				ConnectionHdl := 0;
				UA_Disconnect_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := WAIT;	
			END_IF;
			
			IF (UA_Disconnect_0.Error = 1) THEN  
				ConnectionHdl := 0;
				UA_Disconnect_0.Execute := FALSE;
				Connect_to_OpcUaServer_step := ERROR_OPCUA;
			END_IF;

			
		
		ERROR_OPCUA:
		
			
		
	END_CASE;
		
	
	UA_Connect_0;
	UA_GetNamespaceIndex_0;
	UA_NodeGetHandleList_0;
	UA_NodeReleaseHandleList_0;
	UA_Disconnect_0;				*)
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

