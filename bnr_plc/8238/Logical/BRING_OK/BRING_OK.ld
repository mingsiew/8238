PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<networks maxcolumn="0">
  <network label="Pre_Lift">
    <row>
      <contact name="r1.custom_bring_lock" type="closed"/>
      <contact name="r1.arrive" type="closed"/>
      <contact name="r1.switch" type="closed"/>
      <contact name="r1.going_to" type="closed"/>
      <coil name="r1.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Slant_Lift">
    <row>
      <contact name="r2.custom_bring_lock" type="closed"/>
      <contact name="r2.arrive" type="closed"/>
      <contact name="r2.switch" type="closed"/>
      <contact name="r2.going_to" type="closed"/>
      <contact name="r2.full_sensor" type="closed"/>
      <contact name="r2.run_slant" type="open"/>
      <coil name="r2.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Rail_3">
    <row>
      <contact name="r3.custom_bring_lock" type="closed"/>
      <contact name="r3.arrive" type="closed"/>
      <contact name="r3.switch" type="closed"/>
      <contact name="r3.going_to" type="closed"/>
      <coil name="r3.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Down_Stop_4">
    <row>
      <contact name="r4.custom_bring_lock" type="closed"/>
      <contact name="r4.arrive" type="closed"/>
      <contact name="r4.switch" type="closed"/>
      <contact name="r4.going_to" type="closed"/>
      <contact name="r4.fire" type="closed"/>
      <coil name="r4.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Rail_5">
    <row>
      <contact name="r5.custom_bring_lock" type="closed"/>
      <contact name="r5.arrive" type="closed"/>
      <contact name="r5.switch" type="closed"/>
      <contact name="r5.going_to" type="closed"/>
      <coil name="r5.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Rail_6">
    <row>
      <contact name="r6.custom_bring_lock" type="closed"/>
      <contact name="r6.arrive" type="closed"/>
      <contact name="r6.switch" type="closed"/>
      <contact name="r6.going_to" type="closed"/>
      <coil name="r6.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Easy_Sort_1">
    <row>
      <contact name="r7.custom_bring_lock" type="closed"/>
      <contact name="r7.arrive" type="closed"/>
      <contact name="r7.switch" type="closed"/>
      <contact name="r7.going_to" type="closed"/>
      <coil name="r7.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Easy_Sort_2">
    <row>
      <contact name="r8.custom_bring_lock" type="closed"/>
      <contact name="r8.arrive" type="closed"/>
      <contact name="r8.switch" type="closed"/>
      <contact name="r8.going_to" type="closed"/>
      <coil name="r8.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Easy_Sort_3">
    <row>
      <contact name="r9.custom_bring_lock" type="closed"/>
      <contact name="r9.arrive" type="closed"/>
      <contact name="r9.switch" type="closed"/>
      <contact name="r9.going_to" type="closed"/>
      <coil name="r9.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Transfer_Rail">
    <row>
      <contact name="r10.custom_bring_lock" type="closed"/>
      <contact name="r10.arrive" type="closed"/>
      <contact name="r10.switch" type="closed"/>
      <contact name="r10.going_to" type="closed"/>
      <contact name="r10.fire" type="closed"/>
      <contact name="r10.fire_up" type="open"/>
      <contact name="r10.up" type="open"/>
      <coil name="r10.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Pre_Storage_1">
    <row>
      <contact name="r11.custom_bring_lock" type="closed"/>
      <contact name="r11.arrive" type="closed"/>
      <contact name="r11.switch" type="closed"/>
      <contact name="r11.going_to" type="closed"/>
      <contact name="r11.fire" type="closed"/>
      <coil name="r11.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Pre_Storage_2">
    <row>
      <contact name="r12.custom_bring_lock" type="closed"/>
      <contact name="r12.arrive" type="closed"/>
      <contact name="r12.switch" type="closed"/>
      <contact name="r12.going_to" type="closed"/>
      <coil name="r12.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Belt_Opener_Rail">
    <row>
      <contact name="r13.custom_bring_lock" type="closed"/>
      <contact name="r13.arrive" type="closed"/>
      <contact name="r13.switch" type="closed"/>
      <contact name="r13.going_to" type="closed"/>
      <contact name="r13.fire" type="closed"/>
      <contact name="r13.stb" type="closed"/>
      <contact name="r13.open" type="closed"/>
      <contact name="r13.receive_signal" type="closed"/>
      <coil name="r13.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Storage_Rail_1">
    <row>
      <contact name="r14.custom_bring_lock" type="closed"/>
      <contact name="r14.arrive" type="closed"/>
      <contact name="r14.switch" type="closed"/>
      <contact name="r14.going_to" type="closed"/>
      <coil name="r14.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Storage_Rail_2">
    <row>
      <contact name="r15.custom_bring_lock" type="closed"/>
      <contact name="r15.arrive" type="closed"/>
      <contact name="r15.switch" type="closed"/>
      <contact name="r15.going_to" type="closed"/>
      <coil name="r15.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Storage_Rail_3">
    <row>
      <contact name="r16.custom_bring_lock" type="closed"/>
      <contact name="r16.arrive" type="closed"/>
      <contact name="r16.switch" type="closed"/>
      <contact name="r16.going_to" type="closed"/>
      <coil name="r16.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Storage_Opener">
    <row>
      <contact name="r17.custom_bring_lock" type="closed"/>
      <contact name="r17.arrive" type="closed"/>
      <contact name="r17.switch" type="closed"/>
      <contact name="r17.going_to" type="closed"/>
      <contact name="r17.fire" type="closed"/>
      <contact name="r17.stb" type="closed"/>
      <contact name="r17.open" type="closed"/>
      <contact name="r17.close" type="closed"/>
      <contact name="r17.receive_signal" type="closed"/>
      <coil name="r17.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Empty_1">
    <row>
      <contact name="r18.custom_bring_lock" type="closed"/>
      <contact name="r18.arrive" type="closed"/>
      <contact name="r18.switch" type="closed"/>
      <contact name="r18.going_to" type="closed"/>
      <coil name="r18.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Empty_2">
    <row>
      <contact name="r19.custom_bring_lock" type="closed"/>
      <contact name="r19.arrive" type="closed"/>
      <contact name="r19.switch" type="closed"/>
      <contact name="r19.going_to" type="closed"/>
      <coil name="r19.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Empty_3_Lift">
    <row>
      <contact name="r20.custom_bring_lock" type="closed"/>
      <contact name="r20.arrive" type="closed"/>
      <contact name="r20.switch" type="closed"/>
      <contact name="r20.going_to" type="closed"/>
      <contact name="r20.fire" type="closed"/>
      <contact name="r20.fire_down" type="open"/>
      <contact name="r20.down" type="open"/>
      <coil name="r20.bring_ok" type="open"/>
    </row>
  </network>
  <network label="Empty_4">
    <row>
      <contact name="r21.custom_bring_lock" type="closed"/>
      <contact name="r21.arrive" type="closed"/>
      <contact name="r21.switch" type="closed"/>
      <contact name="r21.going_to" type="closed"/>
      <contact name="r21.fire" type="closed"/>
      <coil name="r21.bring_ok" type="open"/>
    </row>
  </network>
</networks>

END_PROGRAM
