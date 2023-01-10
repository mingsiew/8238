PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<networks maxcolumn="0">
	<network label="Pre_Lift_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r1.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r1.destination"/>
		</row>
	</network>
	<network label="Pre_Lift_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r1.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r1.lockout"/>
		</row>
	</network>
	<network label="Pre_Lift_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r1.lockout"/>
			<contact type="closed" name="r1.custom_send_lock"/>
			<contact type="open" name="r1.front"/>
			<contact type="closed" name="r1.after"/>
			<coil type="open" name="r1.waiting"/>
		</row>
	</network>
	<network label="Pre_Lift_to_r2_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r1.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r1_to_r2"/>
		</row>
		<row>
			<analog type="input" name="2"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Pre_Lift_to_r2_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r1_to_r2"/>
			<contact type="closed" name="r2.going_to"/>
			<contact type="closed" name="r1.reset"/>
			<contact type="closed" name="r2.insert_reset"/>
			<coil type="set" name="r2.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r1.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r1.fire"/>
			<contact type="open" name="r2.insert_reset"/>
			<line/>
			<coil type="reset" name="r1.fire"/>
		</row>
	</network>
	<network label="Pre_Lift_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r1.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r1.fire"/>
		</row>
	</network>
	<network label="Slant_Lift_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r2.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r2.destination"/>
		</row>
	</network>
	<network label="Slant_Lift_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r2.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r2.lockout"/>
		</row>
	</network>
	<network label="Slant_Lift_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r2.lockout"/>
			<contact type="closed" name="r2.custom_send_lock"/>
			<contact type="open" name="r2.front"/>
			<contact type="closed" name="r2.after"/>
			<coil type="open" name="r2.waiting"/>
		</row>
	</network>
	<network label="Slant_Lift_to_r3_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r2.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r2_to_r3"/>
		</row>
		<row>
			<analog type="input" name="3"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Slant_Lift_to_r3_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r2_to_r3"/>
			<contact type="closed" name="r3.going_to"/>
			<contact type="closed" name="r2.reset"/>
			<contact type="closed" name="r3.insert_reset"/>
			<coil type="set" name="r3.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r2.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r2.fire"/>
			<contact type="open" name="r3.insert_reset"/>
			<line/>
			<coil type="reset" name="r2.fire"/>
		</row>
	</network>
	<network label="Slant_Lift_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r2.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r2.fire"/>
		</row>
	</network>
	<network label="Rail_3_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r3.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r3.destination"/>
		</row>
	</network>
	<network label="Rail_3_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r3.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r3.lockout"/>
		</row>
	</network>
	<network label="Rail_3_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r3.lockout"/>
			<contact type="closed" name="r3.custom_send_lock"/>
			<contact type="open" name="r3.front"/>
			<contact type="closed" name="r3.after"/>
			<coil type="open" name="r3.waiting"/>
		</row>
	</network>
	<network label="Rail_3_to_r4_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r3.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r3_to_r4"/>
		</row>
		<row>
			<analog type="input" name="4"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Rail_3_to_r4_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r3_to_r4"/>
			<contact type="closed" name="r4.going_to"/>
			<contact type="closed" name="r3.reset"/>
			<contact type="closed" name="r4.insert_reset"/>
			<coil type="set" name="r4.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r3.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r3.fire"/>
			<contact type="open" name="r4.insert_reset"/>
			<line/>
			<coil type="reset" name="r3.fire"/>
		</row>
	</network>
	<network label="Rail_3_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r3.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r3.fire"/>
		</row>
	</network>
	<network label="Down_Stop_4_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r4.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r4.destination"/>
		</row>
	</network>
	<network label="Down_Stop_4_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r4.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r4.lockout"/>
		</row>
	</network>
	<network label="Down_Stop_4_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r4.lockout"/>
			<contact type="closed" name="r4.custom_send_lock"/>
			<contact type="open" name="r4.front"/>
			<contact type="closed" name="r4.after"/>
			<coil type="open" name="r4.waiting"/>
		</row>
	</network>
	<network label="Down_Stop_4_to_r5_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r4.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r4_to_r5"/>
		</row>
		<row>
			<analog type="input" name="5"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Down_Stop_4_to_r5_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r4_to_r5"/>
			<contact type="closed" name="r5.going_to"/>
			<contact type="closed" name="r4.reset"/>
			<contact type="closed" name="r5.insert_reset"/>
			<coil type="set" name="r5.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r4.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r4.fire"/>
			<contact type="open" name="r5.insert_reset"/>
			<line/>
			<coil type="reset" name="r4.fire"/>
		</row>
	</network>
	<network label="Down_Stop_4_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r4.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r4.fire"/>
		</row>
	</network>
	<network label="Rail_5_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r5.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r5.destination"/>
		</row>
	</network>
	<network label="Rail_5_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r5.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r5.lockout"/>
		</row>
	</network>
	<network label="Rail_5_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r5.lockout"/>
			<contact type="closed" name="r5.custom_send_lock"/>
			<contact type="open" name="r5.front"/>
			<contact type="closed" name="r5.after"/>
			<coil type="open" name="r5.waiting"/>
		</row>
	</network>
	<network label="Rail_5_to_r6_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r5.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r5_to_r6"/>
		</row>
		<row>
			<analog type="input" name="6"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Rail_5_to_r6_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r5_to_r6"/>
			<contact type="closed" name="r6.going_to"/>
			<contact type="closed" name="r5.reset"/>
			<contact type="closed" name="r6.insert_reset"/>
			<coil type="set" name="r6.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r5.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r5.fire"/>
			<contact type="open" name="r6.insert_reset"/>
			<line/>
			<coil type="reset" name="r5.fire"/>
		</row>
	</network>
	<network label="Rail_5_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r5.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r5.fire"/>
		</row>
	</network>
	<network label="Rail_6_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r6.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r6.destination"/>
		</row>
	</network>
	<network label="Rail_6_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r6.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r6.lockout"/>
		</row>
	</network>
	<network label="Rail_6_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r6.lockout"/>
			<contact type="closed" name="r6.custom_send_lock"/>
			<contact type="open" name="r6.front"/>
			<contact type="closed" name="r6.after"/>
			<coil type="open" name="r6.waiting"/>
		</row>
	</network>
	<network label="Rail_6_to_r1_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r6.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r6_to_r1"/>
		</row>
		<row>
			<analog type="input" name="1"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Rail_6_to_r1_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r6_to_r1"/>
			<contact type="closed" name="r1.going_to"/>
			<contact type="closed" name="r6.reset"/>
			<contact type="closed" name="r1.insert_reset"/>
			<coil type="set" name="r1.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r6.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r6.fire"/>
			<contact type="open" name="r1.insert_reset"/>
			<line/>
			<coil type="reset" name="r6.fire"/>
		</row>
	</network>
	<network label="Rail_6_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r6.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r6.fire"/>
		</row>
	</network>
	<network label="Easy_Sort_1_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r7.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r7.destination"/>
		</row>
	</network>
	<network label="Easy_Sort_1_lockout" comment="" row="4" column="0" commented="0">
		<row>
			<contact type="open" name="r7.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r7.lockout"/>
		</row>
		<row>
			<contact type="open" name="r8.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r9.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r21.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="Easy_Sort_1_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r7.lockout"/>
			<contact type="closed" name="r7.custom_send_lock"/>
			<contact type="open" name="r7.front"/>
			<contact type="open" name="r7.done"/>
			<coil type="open" name="r7.waiting"/>
		</row>
	</network>
	<network label="Easy_Sort_1_to_r10_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r7.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r7_to_r10"/>
		</row>
		<row>
			<analog type="input" name="10"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Easy_Sort_1_to_r10_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r7_to_r10"/>
			<contact type="closed" name="r10.going_to"/>
			<contact type="closed" name="r7.reset"/>
			<contact type="closed" name="r10.insert_reset"/>
			<coil type="set" name="r10.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r7.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r7.fire"/>
			<contact type="open" name="r10.insert_reset"/>
			<line/>
			<coil type="reset" name="r7.fire"/>
		</row>
	</network>
	<network label="Easy_Sort_1_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r7.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r7.fire"/>
		</row>
	</network>
	<network label="Easy_Sort_2_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r8.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r8.destination"/>
		</row>
	</network>
	<network label="Easy_Sort_2_lockout" comment="" row="4" column="0" commented="0">
		<row>
			<contact type="open" name="r7.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r8.lockout"/>
		</row>
		<row>
			<contact type="open" name="r8.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r9.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r21.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="Easy_Sort_2_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r8.lockout"/>
			<contact type="closed" name="r8.custom_send_lock"/>
			<contact type="open" name="r8.front"/>
			<contact type="open" name="r8.done"/>
			<coil type="open" name="r8.waiting"/>
		</row>
	</network>
	<network label="Easy_Sort_2_to_r10_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r8.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r8_to_r10"/>
		</row>
		<row>
			<analog type="input" name="10"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Easy_Sort_2_to_r10_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r8_to_r10"/>
			<contact type="closed" name="r10.going_to"/>
			<contact type="closed" name="r8.reset"/>
			<contact type="closed" name="r10.insert_reset"/>
			<coil type="set" name="r10.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r8.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r8.fire"/>
			<contact type="open" name="r10.insert_reset"/>
			<line/>
			<coil type="reset" name="r8.fire"/>
		</row>
	</network>
	<network label="Easy_Sort_2_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r8.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r8.fire"/>
		</row>
	</network>
	<network label="Easy_Sort_3_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r9.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r9.destination"/>
		</row>
	</network>
	<network label="Easy_Sort_3_lockout" comment="" row="4" column="0" commented="0">
		<row>
			<contact type="open" name="r7.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r9.lockout"/>
		</row>
		<row>
			<contact type="open" name="r8.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r9.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r21.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="Easy_Sort_3_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r9.lockout"/>
			<contact type="closed" name="r9.custom_send_lock"/>
			<contact type="open" name="r9.front"/>
			<contact type="open" name="r9.done"/>
			<coil type="open" name="r9.waiting"/>
		</row>
	</network>
	<network label="Easy_Sort_3_to_r10_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r9.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r9_to_r10"/>
		</row>
		<row>
			<analog type="input" name="10"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Easy_Sort_3_to_r10_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r9_to_r10"/>
			<contact type="closed" name="r10.going_to"/>
			<contact type="closed" name="r9.reset"/>
			<contact type="closed" name="r10.insert_reset"/>
			<coil type="set" name="r10.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r9.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r9.fire"/>
			<contact type="open" name="r10.insert_reset"/>
			<line/>
			<coil type="reset" name="r9.fire"/>
		</row>
	</network>
	<network label="Easy_Sort_3_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r9.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r9.fire"/>
		</row>
	</network>
	<network label="Transfer_Rail_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r10.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r10.destination"/>
		</row>
	</network>
	<network label="Transfer_Rail_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r10.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r10.lockout"/>
		</row>
	</network>
	<network label="Transfer_Rail_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r10.lockout"/>
			<contact type="closed" name="r10.custom_send_lock"/>
			<contact type="open" name="r10.front"/>
			<contact type="open" name="r10.down"/>
			<contact type="open" name="r10.fire_down"/>
			<contact type="closed" name="r10.up"/>
			<contact type="closed" name="r10.fire_up"/>
			<contact type="closed" name="r10.after"/>
			<coil type="open" name="r10.waiting"/>
		</row>
	</network>
	<network label="Transfer_Rail_to_r11_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r10.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r10_to_r11"/>
		</row>
		<row>
			<analog type="input" name="11"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Transfer_Rail_to_r11_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r10_to_r11"/>
			<contact type="closed" name="r11.going_to"/>
			<contact type="closed" name="r10.reset"/>
			<contact type="closed" name="r11.insert_reset"/>
			<coil type="set" name="r11.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r10.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r10.fire"/>
			<contact type="open" name="r11.insert_reset"/>
			<line/>
			<coil type="reset" name="r10.fire"/>
		</row>
	</network>
	<network label="Transfer_Rail_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r10.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r10.fire"/>
		</row>
	</network>
	<network label="Pre_Storage_1_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r11.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r11.destination"/>
		</row>
	</network>
	<network label="Pre_Storage_1_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r11.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r11.lockout"/>
		</row>
	</network>
	<network label="Pre_Storage_1_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r11.lockout"/>
			<contact type="closed" name="r11.custom_send_lock"/>
			<contact type="open" name="r11.front"/>
			<contact type="closed" name="r11.after"/>
			<coil type="open" name="r11.waiting"/>
		</row>
	</network>
	<network label="Pre_Storage_1_to_r12_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r11.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r11_to_r12"/>
		</row>
		<row>
			<analog type="input" name="12"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Pre_Storage_1_to_r12_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r11_to_r12"/>
			<contact type="closed" name="r12.going_to"/>
			<contact type="closed" name="r11.reset"/>
			<contact type="closed" name="r12.insert_reset"/>
			<coil type="set" name="r12.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r11.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r11.fire"/>
			<contact type="open" name="r12.insert_reset"/>
			<line/>
			<coil type="reset" name="r11.fire"/>
		</row>
	</network>
	<network label="Pre_Storage_1_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r11.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r11.fire"/>
		</row>
	</network>
	<network label="Pre_Storage_2_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r12.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r12.destination"/>
		</row>
	</network>
	<network label="Pre_Storage_2_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r12.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r12.lockout"/>
		</row>
	</network>
	<network label="Pre_Storage_2_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r12.lockout"/>
			<contact type="closed" name="r12.custom_send_lock"/>
			<contact type="open" name="r12.front"/>
			<contact type="closed" name="r12.after"/>
			<coil type="open" name="r12.waiting"/>
		</row>
	</network>
	<network label="Pre_Storage_2_to_r13_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r12.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r12_to_r13"/>
		</row>
		<row>
			<analog type="input" name="13"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Pre_Storage_2_to_r13_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r12_to_r13"/>
			<contact type="closed" name="r13.going_to"/>
			<contact type="closed" name="r12.reset"/>
			<contact type="closed" name="r13.insert_reset"/>
			<coil type="set" name="r13.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r12.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r12.fire"/>
			<contact type="open" name="r13.insert_reset"/>
			<line/>
			<coil type="reset" name="r12.fire"/>
		</row>
	</network>
	<network label="Pre_Storage_2_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r12.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r12.fire"/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r13.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r13.destination"/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r13.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r13.lockout"/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r13.lockout"/>
			<contact type="closed" name="r13.custom_send_lock"/>
			<contact type="open" name="r13.front"/>
			<contact type="open" name="r13.done"/>
			<contact type="closed" name="r13.after"/>
			<coil type="open" name="r13.waiting"/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_to_r14_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r13.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r13_to_r14"/>
		</row>
		<row>
			<analog type="input" name="14"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_to_r14_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r13_to_r14"/>
			<contact type="closed" name="r14.going_to"/>
			<contact type="closed" name="r13.reset"/>
			<contact type="closed" name="r14.insert_reset"/>
			<coil type="set" name="r14.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r13.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r13.fire"/>
			<contact type="open" name="r14.insert_reset"/>
			<line/>
			<coil type="reset" name="r13.fire"/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_to_r15_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r13.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r13_to_r15"/>
		</row>
		<row>
			<analog type="input" name="15"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_to_r15_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r13_to_r15"/>
			<contact type="closed" name="r15.going_to"/>
			<contact type="closed" name="r13.reset"/>
			<contact type="closed" name="r15.insert_reset"/>
			<coil type="set" name="r15.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r13.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r13.fire"/>
			<contact type="open" name="r15.insert_reset"/>
			<line/>
			<coil type="reset" name="r13.fire"/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_to_r16_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r13.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r13_to_r16"/>
		</row>
		<row>
			<analog type="input" name="16"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_to_r16_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r13_to_r16"/>
			<contact type="closed" name="r16.going_to"/>
			<contact type="closed" name="r13.reset"/>
			<contact type="closed" name="r16.insert_reset"/>
			<coil type="set" name="r16.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r13.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r13.fire"/>
			<contact type="open" name="r16.insert_reset"/>
			<line/>
			<coil type="reset" name="r13.fire"/>
		</row>
	</network>
	<network label="Belt_Opener_Rail_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r13.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r13.fire"/>
		</row>
	</network>
	<network label="Storage_Rail_1_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r14.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r14.destination"/>
		</row>
	</network>
	<network label="Storage_Rail_1_lockout" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r14.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r14.lockout"/>
		</row>
		<row>
			<contact type="open" name="r15.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r18.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="Storage_Rail_1_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r14.lockout"/>
			<contact type="closed" name="r14.custom_send_lock"/>
			<contact type="open" name="r14.front"/>
			<contact type="closed" name="r14.after"/>
			<coil type="open" name="r14.waiting"/>
		</row>
	</network>
	<network label="Storage_Rail_1_to_r19_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r14.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r14_to_r19"/>
		</row>
		<row>
			<analog type="input" name="19"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Storage_Rail_1_to_r19_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r14_to_r19"/>
			<contact type="closed" name="r19.going_to"/>
			<contact type="closed" name="r14.reset"/>
			<contact type="closed" name="r19.insert_reset"/>
			<coil type="set" name="r19.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r14.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r14.fire"/>
			<contact type="open" name="r19.insert_reset"/>
			<line/>
			<coil type="reset" name="r14.fire"/>
		</row>
	</network>
	<network label="Storage_Rail_1_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r14.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r14.fire"/>
		</row>
	</network>
	<network label="Storage_Rail_2_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r15.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r15.destination"/>
		</row>
	</network>
	<network label="Storage_Rail_2_lockout" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r14.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r15.lockout"/>
		</row>
		<row>
			<contact type="open" name="r15.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r18.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="Storage_Rail_2_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r15.lockout"/>
			<contact type="closed" name="r15.custom_send_lock"/>
			<contact type="open" name="r15.front"/>
			<contact type="closed" name="r15.after"/>
			<coil type="open" name="r15.waiting"/>
		</row>
	</network>
	<network label="Storage_Rail_2_to_r19_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r15.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r15_to_r19"/>
		</row>
		<row>
			<analog type="input" name="19"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Storage_Rail_2_to_r19_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r15_to_r19"/>
			<contact type="closed" name="r19.going_to"/>
			<contact type="closed" name="r15.reset"/>
			<contact type="closed" name="r19.insert_reset"/>
			<coil type="set" name="r19.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r15.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r15.fire"/>
			<contact type="open" name="r19.insert_reset"/>
			<line/>
			<coil type="reset" name="r15.fire"/>
		</row>
	</network>
	<network label="Storage_Rail_2_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r15.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r15.fire"/>
		</row>
	</network>
	<network label="Storage_Rail_3_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r16.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r16.destination"/>
		</row>
	</network>
	<network label="Storage_Rail_3_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r16.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r16.lockout"/>
		</row>
	</network>
	<network label="Storage_Rail_3_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r16.lockout"/>
			<contact type="closed" name="r16.custom_send_lock"/>
			<contact type="open" name="r16.front"/>
			<contact type="closed" name="r16.after"/>
			<coil type="open" name="r16.waiting"/>
		</row>
	</network>
	<network label="Storage_Rail_3_to_r17_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r16.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r16_to_r17"/>
		</row>
		<row>
			<analog type="input" name="17"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Storage_Rail_3_to_r17_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r16_to_r17"/>
			<contact type="closed" name="r17.going_to"/>
			<contact type="closed" name="r16.reset"/>
			<contact type="closed" name="r17.insert_reset"/>
			<coil type="set" name="r17.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r16.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r16.fire"/>
			<contact type="open" name="r17.insert_reset"/>
			<line/>
			<coil type="reset" name="r16.fire"/>
		</row>
	</network>
	<network label="Storage_Rail_3_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r16.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r16.fire"/>
		</row>
	</network>
	<network label="Storage_Opener_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r17.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r17.destination"/>
		</row>
	</network>
	<network label="Storage_Opener_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r17.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r17.lockout"/>
		</row>
	</network>
	<network label="Storage_Opener_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r17.lockout"/>
			<contact type="closed" name="r17.custom_send_lock"/>
			<contact type="open" name="r17.front"/>
			<contact type="open" name="r17.done"/>
			<contact type="closed" name="r17.after"/>
			<coil type="open" name="r17.waiting"/>
		</row>
	</network>
	<network label="Storage_Opener_to_r18_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r17.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r17_to_r18"/>
		</row>
		<row>
			<analog type="input" name="18"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Storage_Opener_to_r18_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r17_to_r18"/>
			<contact type="closed" name="r18.going_to"/>
			<contact type="closed" name="r17.reset"/>
			<contact type="closed" name="r18.insert_reset"/>
			<coil type="set" name="r18.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r17.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r17.fire"/>
			<contact type="open" name="r18.insert_reset"/>
			<line/>
			<coil type="reset" name="r17.fire"/>
		</row>
	</network>
	<network label="Storage_Opener_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r17.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r17.fire"/>
		</row>
	</network>
	<network label="Empty_1_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r18.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r18.destination"/>
		</row>
	</network>
	<network label="Empty_1_lockout" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r14.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r18.lockout"/>
		</row>
		<row>
			<contact type="open" name="r15.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r18.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="Empty_1_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r18.lockout"/>
			<contact type="closed" name="r18.custom_send_lock"/>
			<contact type="open" name="r18.front"/>
			<contact type="closed" name="r18.after"/>
			<coil type="open" name="r18.waiting"/>
		</row>
	</network>
	<network label="Empty_1_to_r19_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r18.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r18_to_r19"/>
		</row>
		<row>
			<analog type="input" name="19"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Empty_1_to_r19_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r18_to_r19"/>
			<contact type="closed" name="r19.going_to"/>
			<contact type="closed" name="r18.reset"/>
			<contact type="closed" name="r19.insert_reset"/>
			<coil type="set" name="r19.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r18.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r18.fire"/>
			<contact type="open" name="r19.insert_reset"/>
			<line/>
			<coil type="reset" name="r18.fire"/>
		</row>
	</network>
	<network label="Empty_1_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r18.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r18.fire"/>
		</row>
	</network>
	<network label="Empty_2_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r19.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r19.destination"/>
		</row>
	</network>
	<network label="Empty_2_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r19.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r19.lockout"/>
		</row>
	</network>
	<network label="Empty_2_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r19.lockout"/>
			<contact type="closed" name="r19.custom_send_lock"/>
			<contact type="open" name="r19.front"/>
			<contact type="closed" name="r19.after"/>
			<coil type="open" name="r19.waiting"/>
		</row>
	</network>
	<network label="Empty_2_to_r20_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r19.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r19_to_r20"/>
		</row>
		<row>
			<analog type="input" name="20"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Empty_2_to_r20_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r19_to_r20"/>
			<contact type="closed" name="r20.going_to"/>
			<contact type="closed" name="r19.reset"/>
			<contact type="closed" name="r20.insert_reset"/>
			<coil type="set" name="r20.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r19.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r19.fire"/>
			<contact type="open" name="r20.insert_reset"/>
			<line/>
			<coil type="reset" name="r19.fire"/>
		</row>
	</network>
	<network label="Empty_2_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r19.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r19.fire"/>
		</row>
	</network>
	<network label="Empty_3_Lift_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r20.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r20.destination"/>
		</row>
	</network>
	<network label="Empty_3_Lift_lockout" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r20.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r20.lockout"/>
		</row>
	</network>
	<network label="Empty_3_Lift_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r20.lockout"/>
			<contact type="closed" name="r20.custom_send_lock"/>
			<contact type="open" name="r20.front"/>
			<contact type="open" name="r20.up"/>
			<contact type="open" name="r20.fire_up"/>
			<contact type="closed" name="r20.down"/>
			<contact type="closed" name="r20.fire_down"/>
			<contact type="closed" name="r20.after"/>
			<coil type="open" name="r20.waiting"/>
		</row>
	</network>
	<network label="Empty_3_Lift_to_r21_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r20.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r20_to_r21"/>
		</row>
		<row>
			<analog type="input" name="21"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Empty_3_Lift_to_r21_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r20_to_r21"/>
			<contact type="closed" name="r21.going_to"/>
			<contact type="closed" name="r20.reset"/>
			<contact type="closed" name="r21.insert_reset"/>
			<coil type="set" name="r21.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r20.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r20.fire"/>
			<contact type="open" name="r21.insert_reset"/>
			<line/>
			<coil type="reset" name="r20.fire"/>
		</row>
	</network>
	<network label="Empty_3_Lift_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r20.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r20.fire"/>
		</row>
	</network>
	<network label="Empty_4_clear_dest" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r21.fire"/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="0"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="r21.destination"/>
		</row>
	</network>
	<network label="Empty_4_lockout" comment="" row="4" column="0" commented="0">
		<row>
			<contact type="open" name="r7.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r21.lockout"/>
		</row>
		<row>
			<contact type="open" name="r8.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r9.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r21.fire" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="Empty_4_io_ok" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r21.lockout"/>
			<contact type="closed" name="r21.custom_send_lock"/>
			<contact type="open" name="r21.front"/>
			<contact type="closed" name="r21.after"/>
			<coil type="open" name="r21.waiting"/>
		</row>
	</network>
	<network label="Empty_4_to_r10_P1" comment="" row="2" column="0" commented="0">
		<row>
			<analog type="input" name="r21.destination"/>
			<function position="top" type="EQ"><input name="IN1" extensible="true"/><output name="1"/></function>
			<coil type="open" name="r21_to_r10"/>
		</row>
		<row>
			<analog type="input" name="10"/>
			<function position="bottom" type="EQ"><input name="" extensible="true"/></function>
			<empty/>
		</row>
	</network>
	<network label="Empty_4_to_r10_P2" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r21_to_r10"/>
			<contact type="closed" name="r10.going_to"/>
			<contact type="closed" name="r21.reset"/>
			<contact type="closed" name="r10.insert_reset"/>
			<coil type="set" name="r10.going_to"/>
		</row>
		<row>
			<empty or="true"/>
			<empty/>
			<empty/>
			<empty or="true"/>
			<coil type="set" name="r21.fire"/>
		</row>
		<row>
			<empty or="true"/>
			<contact type="open" name="r21.fire"/>
			<contact type="open" name="r10.insert_reset"/>
			<line/>
			<coil type="reset" name="r21.fire"/>
		</row>
	</network>
	<network label="Empty_4_reset" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r21.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r21.fire"/>
		</row>
	</network>
</networks>
END_PROGRAM


