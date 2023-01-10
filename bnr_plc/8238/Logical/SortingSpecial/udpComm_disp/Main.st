(*
----------------------------------------------------------------------------------------------------------------------------------------
--LIVE DATA TASK--
UDP MAX FRAME SIZE IS 65507 Bytes
-----------------------------------------------------------------------------------------------------------------------------------------
*)
//V1.00.1 -- 06/09/2019 -- First Version
//V1.00.2 -- 05/01/2020 -- Clean up basic version + Add dynamic start up for ABB drive data
//V2.00.1 -- 11/03/2020 -- Add Structures to replace TCP/IP Driver
PROGRAM _INIT
//Configure a static connection (Testing)
LiveDataConnection[1].Config.ServerIP 		:= '10.8.15.118'; //eVueServerIP;
LiveDataConnection[1].Config.ServerPort		:= 54321;
LiveDataConnection[1].Config.Type 			:= LIVE_DATA_CONFIG_STATIC;
//Create a fix request pool for test
LiveDataConnection[1].RequestPool.PoolList[1] 	:= LIVE_DATA_TYPE_STATION_COUNTS;

LiveDataConnection[1].RequestPool.PoolListSize 	:= 1;
	
	
//	SortingBins.counting_frames[1].station := 1;
//	SortingBins.counting_frames[1].cus := 'cus01';
//	SortingBins.counting_frames[1].cat := 'cat01';
//	SortingBins.counting_frames[1].count := 55;
//	SortingBins.counting_frames[1].weight := 123;
	
//_initialiseComms;
END_PROGRAM

PROGRAM _CYCLIC

  IF EDGEPOS(udpIdent_Error) THEN
    udpCloseAllIdent := 0;
    n := 0;
  END_IF;
  IF udpIdent_Error THEN // We have too many ports open -- temp stop all clients and close all udp connections.

    CASE udpCloseAllIdent OF

    0://Get list off all open idents
      ioctl ACCESS ADR(udpIoctl_Error);
      ioctl.enable := 1;
      ioctl.ident := udpINVALID_IDENT;
      ioctl.ioctl := udpID_LIST_GET;
      ioctl.pData := ADR(identInfo.IdentsList[0]);
      ioctl.datalen := SIZEOF(identInfo.IdentsList);
      ioctl();
      IF (ioctl.status = ERR_OK) THEN
        udpCloseAllIdent := 1;
      ELSIF (ioctl.status <> ERR_FUB_BUSY) THEN

      END_IF;

    1://Close all open connections

      close ACCESS ADR(udpClose_Error);
      close.enable := (identInfo.IdentsList[n] > 0);
      close.ident := identInfo.IdentsList[n];
      close();
      IF (close.status = ERR_OK) OR ((close.status <> ERR_FUB_BUSY) AND (close.status <> ERR_FUB_ENABLE_FALSE)) THEN
        identInfo.IdentsList[n] := 0;
        IF (n < 199) THEN
          n := n + 1;
        ELSE
          udpCloseAllIdent := 2;
        END_IF;
      ELSIF (identInfo.IdentsList[n] = 0) THEN
        udpCloseAllIdent := 2;
      END_IF;

    2:// Reinint all connections
      FOR n := 1 TO LIVE_DATA_MAX_CONNECTIONS DO
        connection ACCESS ADR(LiveDataConnection[n]);
        connection.State := LIVE_DATA_INIT;
      END_FOR;
      udpIdent_Error := 0;
      udpCloseAllIdent := 0;
    END_CASE;


  ELSE //Run
    FOR n := 1 TO LIVE_DATA_MAX_CONNECTIONS DO
      connection ACCESS ADR(LiveDataConnection[n]);
      CASE connection.State  OF
        LIVE_DATA_INIT: //Every connection must be initialised with server IP and Port. This can be static or dynamic via http GET.
          CASE connection.Config.Type OF
            LIVE_DATA_CONFIG_STATIC:
              //Check the IP is valid
              IF connection.Config.ServerIP <> '' THEN //Don;t check Port as this could be 0
                connection.State := LIVE_DATA_WAIT;
              END_IF;
            LIVE_DATA_CONFIG_DYNAMIC_CLIENT:
              //Http request to load the Server details + current request pool
            LIVE_DATA_CONFIG_DYNAMIC_SERVER;
              //Wait for a request on the http server to start a connection.
          END_CASE;

        LIVE_DATA_WAIT:
          _AddRemoveFromPool;
          //Wait for the Request pool to be greater than 0
          IF (connection.RequestPool.PoolListSize > 0) THEN
            connection.State := LIVE_DATA_OPEN_CONNECTION;
          END_IF;

        LIVE_DATA_OPEN_CONNECTION:
          //Open connection to serverr
          open ACCESS ADR(connection.Functions.Open);
          open.enable 	:= 1;
          open.options	:= 0;
          open.pIfAddr 	:= 0;//
          open.port		:= 0;//
          open();
          IF (open.status = ERR_OK) THEN
            connection.State := LIVE_DATA_SETUP_CONNECTION_TOS;
          ELSIF (open.status <> ERR_FUB_BUSY) THEN
            connection.Error := open.status;
            connection.State := LIVE_DATA_ERROR; // Go directly to error as the connection has failed
          END_IF;

        LIVE_DATA_SETUP_CONNECTION_TOS://Configure the UDP
          //We must set
          //1) Type of service 	-- udpIP_TOS_SET -- udpIP_TOS_RELIABILITY
          //2) Time to live 		--
          //Optional Send Buffer	-- udpSO_SNDBUF_SET

          //				udpIP_TOS_LOWDELAY			16
          //				udpIP_TOS_THROUGHPUT		8
          //				udpIP_TOS_RELIABILITY		4
          //				udpIP_TOS_MINCOST			2

          ioctl ACCESS ADR(connection.Functions.Ioctl);
          ioctl.enable := 1;
          ioctl.ident := connection.Functions.Open.ident;
          ioctl.ioctl := udpIP_TOS_SET;
          ioctl.pData := ADR(connection.Config.TOS);
          ioctl.datalen := 4;
          ioctl();
          IF (ioctl.status = ERR_OK) THEN
            connection.State := LIVE_DATA_SETUP_CONNECTION_TTL;
          ELSIF (ioctl.status <> ERR_FUB_BUSY) THEN
            connection.Error := ioctl.status;
            connection.State := LIVE_DATA_CLOSE_CONNECTION;
          END_IF;

        LIVE_DATA_SETUP_CONNECTION_TTL: //Time to LIVE in seconds -- MAX 255

          ioctl ACCESS ADR(connection.Functions.Ioctl);
          ioctl.enable := 1;
          ioctl.ident := connection.Functions.Open.ident;
          ioctl.ioctl := udpIP_TTL_SET;
          ioctl.pData := ADR(connection.Config.TTL);
          ioctl.datalen := 4;
          ioctl();
          IF (ioctl.status = ERR_OK) THEN
            connection.State := LIVE_DATA_CONNECT;
          ELSIF (ioctl.status <> ERR_FUB_BUSY) THEN
            connection.Error := ioctl.status;
            connection.State := LIVE_DATA_CLOSE_CONNECTION;
          END_IF;

        LIVE_DATA_CONNECT: // Connect to a specific Device (this is optional but improves performance)
          connect	ACCESS ADR(connection.Functions.Connect);
          connect.enable 	:= 1;
          connect.ident 	:= connection.Functions.Open.ident;
          connect.pHost	:= ADR(connection.Config.ServerIP);
          connect.port 	:= connection.Config.ServerPort;
          connect();
          IF (connect.status = ERR_OK) THEN
            IF getIdentInfo THEN
              connection.State := LIVE_DATA_GET_IDENT_LIST;
            ELSE
              connection.State := LIVE_DATA_BUILD_DATA;
            END_IF;
          ELSIF (connect.status <> ERR_FUB_BUSY) THEN
            connection.Error := connect.status;
            connection.State := LIVE_DATA_DISCONNECT;
          END_IF;
        LIVE_DATA_BUILD_DATA:
          //Build data-- Build a header and data combined.
          //Byte 1 		-- Request Type USINT
          //Byte 2 & 3	-- Header Size(Bytes) UINT
          //Byte 4,5,6,7	-- CheckSum		UDINT
          //Byte xxx		-- HEADER INFO -- BESPOKE TO Request Type
          //DATA--
          IF (connection.RequestPool.Pointer > 0) THEN
            CASE connection.RequestPool.PoolList[connection.RequestPool.Pointer] OF

//                LIVE_DATA_TYPE_DISP_UDP_COMM_1..LIVE_DATA_TYPE_DISP_UDP_COMM_5:
//                  //Built the packet
//                  udpComm[0] := connection.RequestPool.Pointer;
//                  FOR n := 1 TO DISP_SEND_PACKET_SIZE DO
//                    pointer :=  n + (DISP_SEND_PACKET_SIZE * (udpComm[0] - 1));
//                    IF (CommArrayDisp[pointer] <> 0) AND (pointer <= DISP_COMM_BUFFER_SIZE) THEN
//                      brsmemcpy(ADR(udpComm[n]),CommArrayDisp[pointer],2);
//                    ELSE
//                      udpComm[n] := 0;
//                    END_IF;
//                  END_FOR;
//                  pData := ADR(udpComm);
//                  length := SIZEOF(udpComm);
//                  connection.State := LIVE_DATA_SEND_DATA;
//
//                LIVE_DATA_TYPE_RAIL_MESSAGES:// Rail messages
//                  messages[0] := LIVE_DATA_TYPE_RAIL_MESSAGES;
//                  FOR n := 1 TO RAIL_COUNT DO
//                    messages[n] := RailComm[n].Messages.Write;
//                  END_FOR;
//                  pData := ADR(messages);
//                  length := SIZEOF(messages);
//                  connection.State := LIVE_DATA_SEND_DATA;
//
//                LIVE_DATA_TYPE_SLING_INPUT_STATE:// Sling input screen states.
//                  values[0] := LIVE_DATA_TYPE_SLING_INPUT_STATE;
//                  FOR n := 1 TO SLING_INPUTS_COUNT DO
//                    values[n] := SlingInputComm[n].Write;
//                  END_FOR;
//                  pData := ADR(values);
//                  length := ((SLING_INPUTS_COUNT + 1) * 2);
//                  connection.State := LIVE_DATA_SEND_DATA;
			
									LIVE_DATA_TYPE_STATION_COUNTS:	
										values[0] := LIVE_DATA_TYPE_STATION_COUNTS;
										values[1] := MAX_STATIONS;
										
										length := SIZEOF(SortingBins);
										brsmemcpy(ADR(values[2]),ADR(SortingBins),length);
										length := length + 2;
										pData := ADR(values);
										connection.State := LIVE_DATA_SEND_DATA;						
						
              ELSE
                //Invalid type- Check the pool again
                connection.State := LIVE_DATA_CHECK_REQUESTPOOL;
            END_CASE;
          ELSE
            connection.State := LIVE_DATA_CHECK_REQUESTPOOL;
          END_IF;

        LIVE_DATA_SEND_DATA:
          send ACCESS ADR(connection.Functions.Send);
          send.enable 	:= 1;
          send.ident 		:= connection.Functions.Open.ident;
          send.flags 		:= udpMSG_DONTROUTE;// Do not send via the gateway- Route Directly to Server
          send.pData 		:= pData;
          send.datalen	:= length;
          send();
          IF (send.status = ERR_OK) THEN
            connection.State := LIVE_DATA_CHECK_REQUESTPOOL;
          ELSIF send.status = udpERR_CONNREFUSED THEN // Server is not there, disconnect and start again
            connection.State := LIVE_DATA_DISCONNECT;
          ELSIF (send.status <> ERR_FUB_BUSY) THEN
            connection.Error := send.status;
            connection.State := LIVE_DATA_DISCONNECT;
          END_IF;

          //send.pHost || THESE ARE IGNORED BECAUSE WE ARE MAKING A DIRECT CONNECTION USING THE CONNECT FUB||
          //send.port

        LIVE_DATA_CHECK_REQUESTPOOL:
          //Check that the request pool hasn;t changed- Shuffle to the next Requested packet.
          _AddRemoveFromPool;
          //IF the pool is empty close the connection and wait
          IF (connection.RequestPool.Pointer = 0) AND (connection.RequestPool.PoolListSize > 0) THEN
            connection.RequestPool.Pointer := 1;
          ELSIF (connection.RequestPool.Pointer = connection.RequestPool.PoolListSize) THEN
            connection.RequestPool.Pointer := 1;
          ELSIF (connection.RequestPool.Pointer < connection.RequestPool.PoolListSize) THEN
            connection.RequestPool.Pointer := connection.RequestPool.Pointer + 1;
          ELSIF (connection.RequestPool.Pointer > connection.RequestPool.PoolListSize) AND (connection.RequestPool.PoolListSize > 0) THEN
            connection.RequestPool.Pointer := 1;
          END_IF;

          validConnection := (connection.Config.ServerIP <> '');
          IF (connection.RequestPool.PoolListSize = 0) OR NOT validConnection THEN
            connection.State := LIVE_DATA_DISCONNECT;
          ELSE
            connection.State := LIVE_DATA_BUILD_DATA;
          END_IF;

        LIVE_DATA_DISCONNECT:
          disconnect ACCESS ADR(connection.Functions.Disconnect);
          disconnect.enable := 1;
          disconnect.ident := connection.Functions.Open.ident;
          disconnect();
          IF (disconnect.status = ERR_OK) THEN
            connection.State := LIVE_DATA_CLOSE_CONNECTION;
          ELSIF (disconnect.status <> ERR_FUB_BUSY) THEN
            connection.Error := disconnect.status;
            connection.State := LIVE_DATA_CLOSE_CONNECTION;
          END_IF;

        LIVE_DATA_CLOSE_CONNECTION:
          close ACCESS ADR(connection.Functions.Close);
          close.enable := 1;
          close.ident := connection.Functions.Open.ident;
          close();
          IF (close.status = ERR_OK) THEN
            IF (connection.Error > 0) THEN
              connection.State := LIVE_DATA_ERROR;
            ELSE
              connection.State := LIVE_DATA_INIT;
            END_IF;
            IF (connection.Config.Type <> LIVE_DATA_CONFIG_STATIC) THEN
              connection.RequestPool 			:= CLEAR_REQUEST_POOL;
              connection.Config.ServerIP 		:= '';
              connection.Config.ServerPort 	:= 0;
            END_IF;

          ELSIF (close.status <> ERR_FUB_BUSY) THEN
            connection.Error := close.status ;
            connection.State := LIVE_DATA_ERROR;
          END_IF;

        LIVE_DATA_ERROR:
          IF (connection.Error = udpERR_NOMORE_IDENTS) THEN
            // All Idents are used we have to close them manually.
            udpIdent_Error := 1;
          ELSE
            errorCount := errorCount + 1;
            connection.Error := 0;
            connection.State := LIVE_DATA_INIT;
          END_IF;

        LIVE_DATA_GET_IDENT_LIST:
          ioctl ACCESS ADR(connection.Functions.Ioctl);
          ioctl.enable := 1;
          ioctl.ident := udpINVALID_IDENT;
          ioctl.ioctl := udpID_LIST_GET;
          ioctl.pData := ADR(identInfo.IdentsList[0]);
          ioctl.datalen := SIZEOF(identInfo.IdentsList);
          ioctl();
          IF (ioctl.status = ERR_OK) THEN
            connection.State := LIVE_DATA_GET_IDENT_MAX;
          ELSIF (ioctl.status <> ERR_FUB_BUSY) THEN

          END_IF;

        LIVE_DATA_GET_IDENT_MAX:
          ioctl ACCESS ADR(connection.Functions.Ioctl);
          ioctl.enable := 1;
          ioctl.ident := udpINVALID_IDENT;
          ioctl.ioctl := udpID_MAX_GET;
          ioctl.pData := ADR(identInfo.MaxIdents);
          ioctl.datalen := 4;
          ioctl();
          IF (ioctl.status = ERR_OK) THEN
            connection.State := LIVE_DATA_BUILD_DATA;
          ELSIF (ioctl.status <> ERR_FUB_BUSY) THEN

          END_IF;

      END_CASE;

    END_FOR;
  END_IF;

END_PROGRAM

PROGRAM _EXIT
  // DO we have to close the connections on EXIT -- Perhaps when a transfer happens!!

END_PROGRAM
