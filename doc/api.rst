
Project structure
=================

The component ``sc_lcd`` includes the modules ``module_lcd``, ``module_text_display``, ``module_touch_controller_lib`` and the ``module_touch_controller_server``.

module_lcd
----------

Configuration Defines
+++++++++++++++++++++

The ``module_lcd`` includes device support defines, each support header, located in the ``devices`` directory defines a number of parameters. It is sufficient for the user to specify which device to support in the ``lcd_conf.h`` for the device to be correctly supported. To do this ``lcd_conf.h`` must include the define:
::
#define LCD_PART_NUMBER p

where p is the part the user requires support for. ``lcd_conf.h`` must be located in the application project and not the module. Currently, support is provided for:
  * AT043TN24V7
  * K430WQAV4F
  * K70DWN0V1F

Implementation Specific Defines
+++++++++++++++++++++++++++++++
It is possible to override the default defines when a part number is selected. The defines available are:

**LCD_WIDTH**
	This define is used to represent the width of the LCD panel in pixels.

**LCD_HEIGHT**
	This define is used to represent the height of the LCD panel in pixels.

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
	The defines FREQ_DIVIDEND and FREQ_DIVISOR are used to calculate the frequency of the clock used for LCD. The frequency configured = (FREQ_DIVIDEND / FREQ_DIVISOR) in MHz

**LCD_FREQ_DIVISOR**
	The defines FREQ_DIVIDEND and FREQ_DIVISOR are used to calculate the frequency of the clock used for LCD. The frequency configured = (FREQ_DIVIDEND / FREQ_DIVISOR) in MHz

**LCD_FAST_WRITE**
	The define enables a faster LCD write function, however, it produces more code. Use when a 25MHz pixel clock is required. It cannot be used with LCD_HOR_PULSE_WIDTH > 0 or LCD_VERT_PULSE_WIDTH > 0 as horizontal and veritcal sync signals are not supported in LCD_FAST_WRITE mode.

API
+++

The LCD display module functionality is defined in
  * ``lcd.xc``
  * ``lcd.h``
  * ``lcd_defines.h``
  * ``lcd_assembly.S``
  * ``/devices``

where the following functions can be found:

.. doxygenfunction:: lcd_init
.. doxygenfunction:: lcd_req
.. doxygenfunction:: lcd_update
.. doxygenfunction:: lcd_update_p
.. doxygenfunction:: lcd_server


module_touch_controller_lib
---------------------------

The device-specific configuration defines and user defines are listed in ``touch_lib_conf.h``.


Configuration Defines
+++++++++++++++++++++

**TOUCH_LIB_LCD_WIDTH**
	This define is used to represent the width of the LCD panel in pixels.

**TOUCH_LIB_LCD_HEIGHT**
	This define is used to represent the height of the LCD panel in pixels.

**TOUCH_LIB_TS_WIDTH**
     This define is used to represent the width of the touch screen in points.

**TOUCH_LIB_TS_HEIGHT**
     This define is used to represent the height of the touch screen in points.

API
+++

The touch screen module functionality is defined in
  * ``touch_controller_lib.xc``
  * ``touch_controller_lib.h``
  * ``/AD7879-1``

where the following functions can be found:


.. doxygenfunction:: touch_lib_init
.. doxygenfunction:: touch_lib_get_touch_coordinates
.. doxygenfunction:: touch_lib_req_next_coord
.. doxygenfunction:: touch_lib_req_next_coord_timed
.. doxygenfunction:: touch_lib_next_coord_timed
.. doxygenfunction:: touch_lib_scale_coords


module_touch_controller_server
------------------------------

The device-specific configuration defines and user defines are listed in ``touch_lib_conf.h``.


Configuration Defines
+++++++++++++++++++++

**TOUCH_SERVER_LCD_WIDTH**
	This define is used to represent the width of the LCD panel in pixels.

**TOUCH_SERVER_LCD_HEIGHT**
	This define is used to represent the height of the LCD panel in pixels.

**TOUCH_SERVER_TS_WIDTH**
     This define is used to represent the width of the touch screen in points.

**TOUCH_SERVER_TS_HEIGHT**
     This define is used to represent the height of the touch screen in points.


API
+++

The touch screen module functionality is defined in
  * ``touch_controller_server.xc``
  * ``touch_controller_server.h``
  * ``/AD7879-1``

where the following functions can be found:

.. doxygenfunction:: touch_server_get_touch_coordinates
.. doxygenfunction:: touch_controller_server
.. doxygenfunction:: touch_server_process_interrupt
.. doxygenfunction:: touch_server_get_last_coord
.. doxygenfunction:: touch_server_get_next_coord
.. doxygenfunction:: touch_server_get_last_coord_timed
.. doxygenfunction:: touch_server_scale_coords


