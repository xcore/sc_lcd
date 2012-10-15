

LCD Programming Guide
=====================

This section provides information on how to program applications using the LCD module.

Source code structure
---------------------
.. list-table:: Project structure
  :header-rows: 1
  
  * - Project
    - File
    - Description
  * - module_lcd
    - ``lcd.h`` 
    - Header file containing the APIs for the LCD component
  * - 
    - ``lcd.xc``
    - File containing the implementation of the LCD component
  * - 
    - ``lcd_defines.xc``
    - Header file containing the user configurable defines for the LCD
  * - 
    - ``/devices``
    - Folder containing header files of configurations for LCDs


How to select the LCD target
----------------------------

The module has been designed to support multiple LCD targets. Each target has a specific configuration and have been provided
with the component int the ``/devices`` directory. The module only supports a single LCD target per XCore.

To select the target the following should be done:

If the required target is the part AT043TN24V7 LCD display then,
	* Create a header in the application project called ``lcd_conf.h``
	* In the ``lcd_conf.h`` add the define ``#define LCD_PART_NUMBER AT043TN24V7``. This will include the "lcd_defines_AT043TN24V7.h" required for the selected target.
	* Any specific overrides should be added to the ``lcd_conf.h``. For example, to override the ``LCD_HEIGHT`` to 600 pixels add the line ``#define LCD_HEIGHT 600``.
	* The application should also include the port mapping for the LCD as per the hardware used. A variable of the type structure ``lcd_ports`` should be created and must include the port information

Example:
In the application file
::

	struct lcd_ports lcd_ports = {
		XS1_PORT_1G, 
		XS1_PORT_1F, 
		XS1_PORT_16A, 
		XS1_PORT_1B, 
		XS1_PORT_1C, 
		XS1_CLKBLK_1
	};

The declared variable ``lcd_ports`` is used by the LCD server call to address these ports. A core should have the ``lcd_server`` running on it and it should be connected by a channel to the application, for example:
::

  chan c_lcd;
  par {
	lcd_server(c_lcd, lcd_ports);
	application(c_lcd);
  }

Executing The Project
---------------------
The module by itself cannot be build or executed separately. It must be linked in to an application which needs LCD display. Once the module is linked to the application, the application can be built and tested for driving a LCD screen.

The following should be done in order to link the component to the application project
  #. The module name ``module_lcd`` should be added to the list of MODULES in the application project build options. 
  #. Now the module is linked to the application and can be directly used

Software Requirements
---------------------

The module is built on XDE Tool version 12.0
The module can be used in version 12.0 or any higher version of xTIMEcomposer.

