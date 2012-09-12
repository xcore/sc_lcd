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
    - File containing the implementation of the LCD component thread
  * - 
    - ``lcd_defines.xc``
    - Header file containing the user configurable defines for the LCD


How to select the LCD target
----------------------------

The component has been designed to support multiple LCD targets. Each target specific configurations have been already provided
with the component as ``lcd_defines.h``. Each target specific lcd_defines.h is available under the sub-folder with the target name.

Inorder to select the target the following should be done:

If the required target is TM04NDH02 panel

  * In the makefile set the option LCD_TARGET for the panel name LCD_TARGET = AT043TN24  
  * In the INCLUDES, add the sub-folder with the target name (i.e) INCLUDES = ../module_lcd/src/$(LCD_TARGET)
  
    This will include the "lcd_defines.h" required for the selected target
  * The application should also include the port mapping for the LCD as per the hardware used.
  
    A variable of the type structure "lcd_ports" should be created and must include the port information

Example:
In the application file

on stdcore[0]: lcd_ports lcd_p orts_init = {
                  XS1_PORT_1O,
                  
                  XS1_PORT_4F,
                  
                  XS1_PORT_32A,
                  
                  XS1_CLKBLK_3 };

The declared variable lcd_ports_init is used in the LCD thread call as lcd_server(c_lcd, lcd_ports_init);