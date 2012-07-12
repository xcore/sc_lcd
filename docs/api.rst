.. _sec_api:

Project structure
=================

The 'module_lcd' is a standalone module. It can be used by the application to drive a graphics LCD module.

Configuration Defines
---------------------

The following defines must be configured for the LCD component based on the Graphics LCD module used and can be found in the files ``lcd_defines.h`` and ``lcd_ports.xc``

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
   * - **VERT_PORCH**
     - This is the vertical porch timing for the LCD. 
       The value given here should include the vertical blanking period, vertical front porch and vertical back porch.
       The user should refer to the LCD datasheet to find the values
     - 6330
   * - **HOR_PORCH**
     - This is the horizontal porch timing for the LCD. 
       The value given here should include the horizontal blanking period, horizontal front porch and horizontal back porch.
       The user should refer to the LCD datasheet to find the values.
     - 45
   * - **p_lcd_clk**
     - This is a out port defined in the ``lcd_ports.xc`` file. The user should give the port details which should be used as LCD clock.
     - XS1_PORT_1O
   * - **p_lcd_tim**
     - This is a out port defined in the ``lcd_ports.xc`` file. The user should give the port details which should be used as LCD signals 
     - XS1_PORT_4F
   * - **p_lcd_rgb**
     - This is a out port defined in the ``lcd_ports.xc`` file. The user should give the port details which should be used for the 32 bit    RGB lines.
       (includes 2 data of 16 bit RGB color)
     - XS1_PORT_32A
   * - **clk_lcd**
     - This is a clock defined in the ``lcd_ports.xc`` file. The user should give the clock block which can used as LCD clock
     - XS1_CLKBLK_3
	 

API
---

The LCD display module functionality is defined in
        * ``lcd.xc``
        * ``lcd.h``
        * ``lcd_defines.h``

The function :c:func:`lcd` in lcd.xc is handled in the thread.
This section explains only the important APIs that are frequently used. Other static APIs are not discussed in this section.
The other APIs can be seen in the files ``lcd.xc`` and ``lcd.h``.

Note that to enable the application to use the LCD module, the module should be added to the build options of the project, as follows:

  #. Open the file ``BuildOptions`` available in ..\app_graphics_demo folder 
  #. Add the name ``module_lcd`` to the option ``MODULE`` in the BuildOptions. This will enable the application project to use the LCD module		   
  #. Add the object names 'lcd' and 'lcd_ports' to the option ``OBJNAMES``
  #. Add the module ``module_lcd`` to the ``References`` option in the project settings of the application project


.. doxygenfunction:: lcd

