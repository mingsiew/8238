ACTION _references: 
  ident ACCESS ADR(server[n].Ident); 
  state ACCESS ADR(server[n].State);
  tcpRecv ACCESS ADR(server[n].Functions.TcpRecv);
  tcpSend ACCESS ADR(server[n].Functions.TcpSend);
  tcpClose ACCESS ADR(server[n].Functions.TcpClose);
  ton_NoData ACCESS ADR(server[n].Functions.Ton_NoData);
END_ACTION
