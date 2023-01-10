PROGRAM _CYCLIC
<?xml version="1.0"?>
<?AutomationStudio Version=3.0.71?>
<!-- Automation Studio Generated XML Section -->
<networks maxcolumn="0">
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r11.fire"/>
			<contact type="open" name="r11.after"/>
			<line/>
			<coil type="set" name="r11.switch"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="closed" name="r11.fire"/>
			<line/>
			<line/>
			<coil type="reset" name="r11.switch"/>
		</row>
		<row>
			<contact type="open" name="r11.reset" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="1" column="0" commented="0">
		<row>
			<contact type="open" name="r20.fire"/>
			<contact type="open" name="r20.after_raw"/>
			<line/>
			<coil type="set" name="r20.switch"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<contact type="closed" name="r20.fire"/>
			<line/>
			<line/>
			<coil type="reset" name="r20.switch"/>
		</row>
		<row>
			<contact type="open" name="r20.reset" or="true"/>
			<empty/>
			<empty/>
			<empty/>
		</row>
	</network>
</networks>
END_PROGRAM






