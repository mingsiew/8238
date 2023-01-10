<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="moduleWatc" Source="Standard.ModuleLogger.moduleWatch.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="USB_Pmem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="zzClearMem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="can_dry1" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="zzSQLid" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="IO_Info" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="IOLink_Dri" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="SCANNERS" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="SafetyUI" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="S_COMM_IN" Source="S_COMM_IN.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IO_INPUTS" Source="IO_INPUTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="DBOUNCE" Source="DBOUNCE.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="custom" Source="custom.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BELT_TO_TR" Source="BELT_TO_TRANSFER.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CONVEYOR_M" Source="CONVEYOR_MAP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SAFETY_ZON" Source="SAFETY_ZONES.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="RAIL_SUB" Source="RAIL_SUB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="LOADCELLS" Source="LOADCELLS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="INSERTS" Source="INSERTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="WEIGHT" Source="WEIGHT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CLOSERS" Source="CLOSERS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OPENERS" Source="OPENERS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SWITCHES" Source="SWITCHES.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="LIFTS" Source="LIFTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BRING_OK" Source="BRING_OK.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Permenant" Source="Standard.Settings.Permenant.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Lift_v8_1" Source="Robo_Drive_Control.Lift_v8_1.prg" Memory="UserROM" Language="IEC" Debugging="true" Disabled="true" />
    <Task Name="zzStd1" Source="Standard.Standard.zzStd.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FuseManage" Source="Standard.IOLink.Fuses.FuseManagement.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Camera_Dri" Source="Standard.Barcode_BnR.Camera_Driver.prg" Memory="UserROM" Language="IEC" Debugging="true" Disabled="true" />
    <Task Name="HoistServe" Source="Standard.HoistLibrary.HoistServer.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="hlKanLink" Source="Standard.Kanlink.KGFramework.Pkg_hlKanLink.hlKanLink.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4">
    <Task Name="WARNINGS" Source="WARNINGS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5">
    <Task Name="ALARMS" Source="ALARMS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="zz_Kanlink" Source="Standard.Kanlink.zz_KanlinkConfig.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Kan_Driver" Source="Standard.Kanlink.Kan_Driver.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="mnEth" Source="Standard.Kanlink.KGFramework.Pkg_mnEth.mnEth.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="svCPCache" Source="Standard.Kanlink.KGFramework.Pkg_svCPCache.svCPCache.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="kanlink_ma" Source="Standard.Kanlink.kanlink_map.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7">
    <Task Name="Contactron" Source="Standard.IOLink.Contactron.Contactron.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="httpServer" Source="http_Lib.httpServer.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#8">
    <Task Name="IO_OUTPUTS" Source="IO_OUTPUTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="S_COMM_OUT" Source="S_COMM_OUT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ModSlave" Source="COMMUNICATION.ModSlave.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="udpComm" Source="COMMUNICATION.UdpComm.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="tcpComm" Source="COMMUNICATION.TcpComm.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="udpComm_di" Source="SortingSpecial.udpComm_disp.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="zzGetTime" Source="CSP_Control.zzGetTime.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OPCuAClien" Source="OPCuA_Client.OPCuAClient.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="mappSafety" Source="Safety.mappSafety.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AccessCont" Source="Safety.AccessControl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Safety" Source="Safety.Safety.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ABB_Driver" Source="Standard.ABB_EPL.ABB_Driver.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="Param_1_5k" Source="Robo_Drive_Control.Param_1_5kwStar.dob" Memory="UserROM" Language="Simple" Disabled="true" />
    <DataObject Name="assl1" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="arsdmsvp" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="arsdmhtm" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="arsdmsvg" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="mvLoader" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCLang" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arflatprv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arcoal" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arsvcreg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="FWRules" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaSrv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TC" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="viComp" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Settings" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="viAppBCDE" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="cUnits" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Settings_1" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_1" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol1" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol3" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol2" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol20" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol17" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol4" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol19" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol24" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol30" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol9" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol12" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol5" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol29" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol18" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol16" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol22" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol6" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol11" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol28" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol8" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol26" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol7" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol15" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol21" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol10" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol13" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol32" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol25" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol31" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol14" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol23" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asiol27" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaMap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfntttf" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfile" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcshared" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccshape" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcgclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arial" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="CT1102" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcchspot" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsint" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="PCT0403" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbtn" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsloc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccovl" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccline" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcctext" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcalarm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcbclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcrt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccnum" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccstr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="CT1103" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arialbd" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="PCT0402" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpdsw" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="verdanab" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="verdana" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="webserv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arsdm" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="AsOpcUac" Source="Libraries.AsOpcUac.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="OPCuAClnt" Source="OPCuA_Client.OPCuAClnt.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="FC302" Source="Robo_Drive_Control.FC302.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="standard" Source="Libraries.standard.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="runtime" Source="Libraries.runtime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="OPERATOR" Source="Libraries.OPERATOR.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsTime" Source="Libraries.AsTime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsString" Source="Libraries.AsString.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsTCP" Source="Libraries.AsTCP.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsARCfg" Source="Libraries.AsARCfg.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIecCon" Source="Libraries.AsIecCon.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="FileIO" Source="Libraries.FileIO.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsBrMath" Source="Libraries.AsBrMath.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="CAN_Lib" Source="Libraries.CAN_Lib.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsUDP" Source="Libraries.AsUDP.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="MTTypes" Source="Libraries.MTTypes.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="brsystem" Source="Libraries.brsystem.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpAudit" Source="Libraries.MpAudit.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpBase" Source="Libraries.MpBase.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="DataObj" Source="Libraries.DataObj.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsXml" Source="Libraries.AsXml.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="MTBasics" Source="Libraries.MTBasics.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpServer" Source="Libraries.MpServer.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ArSsl" Source="Libraries.ArSsl.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="ArUser" Source="Libraries.ArUser.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="ViBase" Source="Libraries.ViBase.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsZip" Source="Libraries.AsZip.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="powerlnk" Source="Libraries.powerlnk.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsEPL" Source="Standard.ABB_EPL.AsEPL.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsETH" Source="Libraries.AsETH.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsIODiag" Source="Libraries.AsIODiag.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsHttp" Source="Libraries.AsHttp.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsIOAcc" Source="Libraries.AsIOAcc.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsIoTrc" Source="Libraries.AsIoTrc.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="FileMgr" Source="Standard.FileMgr.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="AsIOLink" Source="Libraries.AsIOLink.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsCANopen" Source="Robo_Drive_Control.AsCANopen.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIO" Source="Libraries.AsIO.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="MbusTCP" Source="COMMUNICATION.MbusTCP.lby" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="SfDomain" Source="Libraries.SfDomain.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="KGstdLib" Source="Standard.Kanlink.KGFramework.Pkg_KGStandard.KGstdLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="KGlibMsg" Source="Standard.Kanlink.KGFramework.Pkg_mnMsg.KGlibMsg.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="mnParamLib" Source="Standard.Kanlink.KGFramework.Pkg_mnParam.mnParamLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="KanLinkLib" Source="Standard.Kanlink.KGFramework.Pkg_hlKanLink.KanLinkLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="KL_UserLib" Source="Standard.Kanlink.KGFrameworkShare.Pkg_hlKanLinkUser.KL_UserLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="libTestUse" Source="Standard.Kanlink.KGFrameworkShare.Pkg_mnTestUser.libTestUse.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="AsBrWStr" Source="Libraries.AsBrWStr.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="ETHERNET" Source="Libraries.ETHERNET.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsArLog" Source="Libraries.AsArLog.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsUSB" Source="Libraries.AsUSB.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsMem" Source="Libraries.AsMem.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsDb" Source="Libraries.AsDb.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="KanHttp" Source="http_Lib.KanHttp.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="AsFifo" Source="Libraries.AsFifo.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="eVueLib" Source="eVueLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="SfDomDrv" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpSfDomMgr" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="SfDomVis" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="SupFile" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="vcresman" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="WETCAN2" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIOMMan" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="IOLinkLib" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ABB_EPL" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
  </Libraries>
</SwConfiguration>