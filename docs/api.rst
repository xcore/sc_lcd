Project structure
=================

The component sc_lcd includes the standalone module 'module_lcd'.
It can be used by the application to drive a graphics LCD module.

Configuration Defines
---------------------

The following defines must be configured for the LCD component based on the Graphics LCD module used and can be found in the files ``lcd_defines.h``
The default values shown are for target TM043NDH02

.. list-table:: LCD Defines
   :header-rows: 1
   :widths: 3 2 1
  
   * - Define
     - Description
     - Default
   * - **LCD_WIDTH**
     - The width of the LCD screen in terms of pixels.
     - 480 
   * - **LCD_HEIGHT**
     - The height of the LCD screen in terms of rows.       
     - 272
   * - **LCD_BITS_PER_PIXEL**
     - The number of bits per pixel
     - 16
   * - **LCD_HOR_PORCH**
     - This is the horizontal porch timing for the LCD. 
       The value given here should include the horizontal blanking period, horizontal front porch and horizontal back porch.
       The user should refer to the LCD datasheet to find the values.
     - 45
   * - **LCD_HSYNC_TIME**
     - The total HYSYN time in number of clocks
     - Calculated from LCD_WIDTH and LCD_HOR_PORCH
   * - **LCD_VERT_PORCH**
     - This is the vertical porch timing for the LCD. 
       The value given here should include the vertical blanking period, vertical front porch and vertical back porch.
       The user should refer to the LCD datasheet to find the values
     - Calculated based on the HYSNC timing
   * - **LCD_FREQ_DIVIDEND**
     - The frequency dividend and divisor are used to calculate the frequency to be configured
     - 100
   * - **LCD_FREQ_DIVISOR**
     - The frequency dividend and divisor are used to calculate the frequency to be configured
     - 8

API
---

The LCD display module functionality is defined in
        * ``lcd.xc``
        * ``lcd.h``
        * ``lcd_defines.h``

The function :c:func:`lcd` in lcd.xc is handled in the thread.

.. doxygenfunction:: lcd_server
.. only:: html

  .. figure:: images/lcd_function.png
     :align: center

.. only:: latex

  .. figure:: images/lcd_function.pdf
     :figwidth: 50%
     :align: center

.. doxygenfunction:: lcd_init
.. doxygenfunction:: lcd_update
