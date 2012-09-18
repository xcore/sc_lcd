
Evaluation Platforms
====================

.. _sec_hardware_platforms:

Recommended Hardware
--------------------

Slicekit
++++++++

This module may be evaluated using the Slicekit Modular Development Platform, available from digikey. Required board SKUs are:

   * XP-SKC-L2 (Slicekit L2 Core Board) plus XA-SK-SDRAM plus XA-SK-XTAG2 (Slicekit XTAG adaptor) 

Demonstration Applications
--------------------------

LCD Demo Application
++++++++++++++++++++

The LCD demo application shows how a buffer of image data can be written to the  the LCD screen.

   * Package: sc_lcd
   * Application: app_lcd_demo


Text Display Application
++++++++++++++++++++++++

This application demonstrates how the ``module_text_display`` can be used to put text into the LCD image buffer for display to the screen.

   * Package: sc_lcd
   * Application: app_text_display


Display Controller Application
++++++++++++++++++++++++++++++

This combination demo employs the ``module_lcd`` along with the ``module_sdram_burst`` and the ``module_framebuffer`` framebuffer framework component to implement a 480x272 display controller.

Required board SKUs for this demo are:

   * XP-SKC-L2 (Slicekit L2 Core Board) plus XA-SK-SDRAM plus XA-SK-LCD480 plus XA-SK-XTAG2 (Slicekit XTAG adaptor) 

   * Package: sw_display_controller
   * Application: app_graphics_demo

