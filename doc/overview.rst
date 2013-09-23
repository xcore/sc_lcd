Overview
========

LCD component
-------------

The LCD component is used to drive a single graphics LCD module up to 800 * 600 pixels with pixel clocks of up to 25MHz.

Features
++++++++

   * Standard component to support different LCD displays with RGB 565.
   * Different color depths 32 bpp, 16 bpp, etc. based on user configuration.
   * Resolution of up to 800 * 600 pixels. See table below for different screen configurations.
   * Outputs to a CMOS interface.
   * Configurability of 
     * LCD pixel dimensions,
     * clock rate,
     * horizontal and vertical timing requirements,
     * port mapping of the LCD.
   * Requires a single core for the server.
     * The function ``lcd_server`` requires just one core, the client functions, located in ``lcd.h`` are very low overhead and are called from the application.

Memory requirements
+++++++++++++++++++
+------------------+---------------+
| Resource         | Usage         |
+==================+===============+
| Stack            | 92 bytes      |
+------------------+---------------+
| Program          | 2168 bytes    |
+------------------+---------------+

Resource requirements
+++++++++++++++++++++
+---------------+-------+
| Resource      | Usage |
+===============+=======+
| Channels      |   1   |
+---------------+-------+
| Timers        |   0   |
+---------------+-------+
| Clocks        |   1   |
+---------------+-------+
| Logical Cores |   1   |
+---------------+-------+

Performance
+++++++++++

The achievable effective bandwidth varies according to the available XCore MIPS. The maximum pixel clock supported is 25MHz.


Touch screen component
----------------------

The touch screen component is used to read the touch coordinates from the touch screen controller AD7879-1.

Features
++++++++

   * Standard components to support touch screen controller with I2C serial interface
   * Supports 4-wire resistive touch screens of different sizes
   * Resolution of 4096 * 4096 points
   * Pen-down interrupt signal supported
   * Outputs touch coordinates with time information
   * ``module_touch_controller_lib`` requires a single core while ``module_touch_controller_server`` requires an additional core for the server.

Memory requirements
+++++++++++++++++++

app_touch_controller_lib_demo

+------------------+---------------+
| Resource         | Usage         |
+==================+===============+
| Stack            | 304 bytes     |
+------------------+---------------+
| Program          | 3160 bytes    |
+------------------+---------------+

app_touch_controller_server_demo

+------------------+---------------+
| Resource         | Usage         |
+==================+===============+
| Stack            | 420 bytes     |
+------------------+---------------+
| Program          | 3576 bytes    |
+------------------+---------------+


Resource requirements
+++++++++++++++++++++

app_touch_controller_lib_demo

+---------------+-------+
| Resource      | Usage |
+===============+=======+
| Channels      |   0   |
+---------------+-------+
| Timers        |   3   |
+---------------+-------+
| Clocks        |   1   |
+---------------+-------+
| Logical Cores |   1   |
+---------------+-------+

app_touch_controller_server_demo

+---------------+-------+
| Resource      | Usage |
+===============+=======+
| Channels      |   1   |
+---------------+-------+
| Timers        |   3   |
+---------------+-------+
| Clocks        |   1   |
+---------------+-------+
| Logical Cores |   2   |
+---------------+-------+


