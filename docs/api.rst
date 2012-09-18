Project structure
=================

The component ``sc_lcd`` includes the module ``module_lcd``. It can be used by an application to drive an LCD module.

Configuration Defines
---------------------

The ``module_lcd`` includes device support defines, each support header, located in the ``devices`` directory defines a number of parameters. It is sufficient for the user to specify which device to support in the ``lcd_conf.h`` for the device to be correctly supported. To do this ``lcd_conf.h`` must include the define:
::
#define LCD_PART_NUMBER p

where p is the part the user requires support for. ``lcd_conf.h`` must be located in the application project and not the module. Currently, support is provided for
::
	AT043TN24
	K430WQAV4F

Implementation Specific Defines
+++++++++++++++++++++++++++++++
It is possible to override the default defines when a part number is selected. The defines avaliable are:

**LCD_WIDTH**
	This define is used to represent the width of the LCD panel in pixels.

**LCD_HEIGHT**
	This define is used to represent the height of the LCD panel in terms of lines.

**LCD_BITS_PER_PIXEL**
	Count of bits used to set a pixels colour, i.e. if the screen was wired for rgb565 then the LCD_BITS_PER_PIXEL would be 16, rgb888 would be 24. This is independant of the actual bit depth of the lcd. 
	
**LCD_HOR_FRONT_PORCH**
	The horizontal front porch timing requirement given in pixel clocks.

**LCD_HOR_BACK_PORCH**
	The horizontal back porch timing requirement given in pixel clocks.

**LCD_VERT_FRONT_PORCH**
	The vertical front porch timing requirement given in horizontal time periods.

**LCD_VERT_BACK_PORCH**
	The vertical back porch timing requirement given in horizontal time periods.

**LCD_HOR_PULSE_WIDTH**
	The horizontal pulse width timing requirement given in pixel clocks. This is the duration that the hsync signal should go low to denote the start of the horizontal frame. Set to 0 when hsync is not necessary.

**LCD_VERT_PULSE_WIDTH**
	The vertical pulse width timing requirement given in vertical time periods. This is the duration that the vsync signal should go low to denote the start of the vertical frame. Set to 0 when vsync is not necessary.

**LCD_FREQ_DIVIDEND**
**LCD_FREQ_DIVISOR**
	The defines FREQ_DIVIDEND and FREQ_DIVISOR are used to calculate the frequency of the clock used for LCD. The frequency configured = (FREQ_DIVIDEND / FREQ_DIVISOR) in MHz

API
---

The LCD display module functionality is defined in
        * ``lcd.xc``
        * ``lcd.h``
        * ``lcd_defines.h``
	* ``\devices``

.. doxygenfunction:: lcd_init
.. doxygenfunction:: lcd_update
.. doxygenfunction:: lcd_server
