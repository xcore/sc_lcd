Overview
========

The LCD component is used to drive a single graphics LCD module up to 800 * 600 pixels with pixel clocks of up to 25MHz.

Features
--------

   * Standard component to support different LCD displays with RGB 565.
   * Different color depths 32 bpp, 16 bpp, etc. based on user configuration.
   * Resolution of up to 800 * 600 pixels. See table below for different screen configurations.
   * Outputs to a CMOS interface.
   * Configurability of 
     * LCD pixel dimensions,
     * clock rate,
     * horizontal and vertical timing requiremnts,
     * port mapping of the LCD.
   * Requires a single core for the server.
     * The function ``lcd_server`` requires just one core, the client functions, located in ``lcd.h`` are very low overhead and are called from the application.

Memory requirements
-------------------
+------------------+---------------+
| Resource         | Usage         |
+==================+===============+
| Stack            | 92 bytes      |
+------------------+---------------+
| Program          | 2168 bytes    |
+------------------+---------------+

Resource requirements
---------------------
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
----------- 

The achievable effective bandwidth varies according to the avaliable XCore MIPS. The maximum pixel clock supported is 25MHz.

