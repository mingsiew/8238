<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="Lift_PosMo" Source="Robo_Drive_Control.Lift_PosMonitor.prg" Memory="UserROM" Language="IEC" Debugging="true" Disabled="true" />
    <Task Name="ServerTask" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="USB_Pmem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="zzClearMem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="can_dry1" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="zzSQLid" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <Task Name="Belt_Test" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="IO_INPUTS" Source="IO_INPUTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="S_COMM_IN" Source="S_COMM_IN.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="DBOUNCE" Source="DBOUNCE.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="INSERTS" Source="INSERTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="WEIGHT" Source="WEIGHT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BRING_OK" Source="BRING_OK.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="LIFTS" Source="LIFTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CLOSERS" Source="CLOSERS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SWITCHES" Source="SWITCHES.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OPENERS" Source="OPENERS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="RAIL_SUB" Source="RAIL_SUB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ALARMS" Source="ALARMS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IO_OUTPUTS" Source="IO_OUTPUTS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="S_COMM_OUT" Source="S_COMM_OUT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Lift_v8_1" Source="Robo_Drive_Control.Lift_v8_1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="custom" Source="custom.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="zzStd" Source="Standard.Standard.zzStd.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5" />
  <TaskClass Name="Cyclic#6" />
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8">
    <Task Name="ModSlave" Source="ModSlave.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="Param_1_5k" Source="Robo_Drive_Control.Param_1_5kwStar_expo.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="assl1" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="arsdmsvp" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="arsdmhtm" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="arsdmsvg" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaMap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" TransferOnlyIfNotOnTarget="true" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
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
    <LibraryObject Name="FC302" Source="Robo_Drive_Control.FC302.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="MbusTCP" Source="Libraries.MbusTCP.lby" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsARCfg" Source="Libraries.AsARCfg.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsTCP" Source="Libraries.AsTCP.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asstring" Source="Libraries.asstring.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsCANopen" Source="Robo_Drive_Control.AsCANopen.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="runtime" Source="Libraries.runtime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="standard" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asieccon" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="astime" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="vcresman" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="WETCAN2" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MTTypes" Source="Libraries.MTTypes.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="brsystem" Source="Libraries.brsystem.lby" Memory="UserROM" Language="Binary" Debugging="true" />
  </Libraries>
</SwConfiguration>