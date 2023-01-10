PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<contact type="open" name="r1.fire"/>
			<line/>
			<line/>
			<coil type="open" name="r1.custom_bring_lock"/>
		</row>
		<row>
			<contact type="open" name="r2.arrive_raw" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r1.front_raw" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r1.fire"/>
			<contact type="open" name="r2.dog_sensor"/>
			<contact type="closed" name="r2.arrive"/>
			<contact type="open" name="r1.front"/>
			<coil type="set" name="r1.inx"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r2.full_sensor"/>
			<line/>
			<line/>
			<coil type="reset" name="r1.inx"/>
		</row>
	</network>
	<network label="" comment="" row="4" column="0" commented="0">
		<row>
			<contact type="closed" name="r2.full_sensor"/>
			<contact type="closed" name="r1.inx"/>
			<contact type="open" name="r1.front"/>
			<coil type="open" name="r2.run_slant"/>
		</row>
		<row>
			<contact type="closed" name="r2.full_sensor"/>
			<contact type="closed" name="r1.rail_mt"/>
			<line or="true"/>
			<empty/>
		</row>
		<row>
			<contact type="positive transition" name="r1.onoff"/>
			<line/>
			<line or="true"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="slant_timeout"/>
			<line/>
			<line or="true"/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r1.onoff"/>
			<line/>
			<line/>
			<coil type="reset" name="r2.run_slant"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="negative transition" name="r2.onoff"/>
			<line/>
			<line/>
			<coil type="reset" name="r2.run_slant"/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="zzTON00000000" type="TON"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r2.full_sensor"/>
			<line/>
			<functionblock position="top" type="TON"><input name="IN"/><output name="Q"/></functionblock>
			<coil type="open" name="r2.custom_bring_lock"/>
		</row>
		<row>
			<contact type="closed" name="r2.dog_sensor" or="true"/>
			<analog type="input" name="T#2s"/>
			<functionblock position="bottom" type="TON"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="zzTOF00000000" type="TOF"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r1.fire"/>
			<functionblock position="top" type="TOF"><input name="IN"/><output name="Q"/></functionblock>
			<coil type="open" name="slant_timeout"/>
		</row>
		<row>
			<analog type="input" name="T#300s"/>
			<functionblock position="bottom" type="TOF"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="3" column="0" commented="0">
		<row>
			<empty/>
			<functionblock position="header" name="zzTON00000001" type="TON"/>
			<empty/>
		</row>
		<row>
			<contact type="open" name="r2.full_sensor"/>
			<functionblock position="top" type="TON"><input name="IN"/><output name="Q"/></functionblock>
			<coil type="reset" name="r2.run_slant"/>
		</row>
		<row>
			<analog type="input" name="T#4s"/>
			<functionblock position="bottom" type="TON"><input name="PT"/><output name="ET"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r20.rail_mt"/>
			<contact type="open" name="r20.front"/>
			<line/>
			<coil type="set" name="r20.fire_up"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="positive transition" name="r21.arrive"/>
			<line/>
			<line/>
			<coil type="reset" name="r20.fire_up"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="open" name="r20.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r20.fire_up"/>
		</row>
		<row>
			<contact type="open" name="r20.jogmode" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r20.fire_up"/>
			<contact type="closed" name="r20.jogmode"/>
			<line/>
			<coil type="open" name="r20.fire_down"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r20.down"/>
			<line/>
			<line/>
			<coil type="open" name="r19.custom_send_lock"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r20.onoff"/>
			<contact type="open" name="halted"/>
			<line/>
			<coil type="open" name="r20.jogmode"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r10.going_to"/>
			<contact type="open" name="r10.front"/>
			<contact type="closed" name="r10.empty"/>
			<coil type="set" name="r10.fire_down"/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="positive transition" name="r11.arrive"/>
			<line/>
			<line/>
			<coil type="reset" name="r10.fire_down"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="open" name="r10.reset"/>
			<line/>
			<line/>
			<coil type="reset" name="r10.fire_down"/>
		</row>
		<row>
			<contact type="open" name="r10.jogmode" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="closed" name="r10.fire_down"/>
			<contact type="closed" name="r10.jogmode"/>
			<line/>
			<coil type="open" name="r10.fire_up"/>
		</row>
	</network>
</networks>
END_PROGRAM









