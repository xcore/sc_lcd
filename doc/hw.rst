
Evaluation Platforms
====================

.. _sec_hardware_platforms:

Recommended Hardware
--------------------

sliceKIT
++++++++

This module may be evaluated using the sliceKIT Modular Development Platform, available from digikey. Required board SKUs are:

   * XP-SKC-L2 (sliceKIT L16 Core Board) plus XA-SK-SCR480 plus XA-SK-XTAG2 (sliceKIT XTAG adaptor) 

Demonstration Applications
--------------------------

LCD Demo Application
++++++++++++++++++++

The LCD demo application shows how a buffer of image data can be written to the 480x272 LCD screen that is supplied with the XA-SK-SCR480 Slice Card.

   * Package: sc_lcd
   * Application: app_lcd_demo


Touch Screen Demo Application
+++++++++++++++++++++++++++++

The touch screen demo application shows how a touch event is processed and the touch coordinates are fetched from the touch screen controller chip fitted on the XA-SK-SCR480 Slice Card.

   * Package: sc_lcd
   * Applications: app_touch_controller_lib_demo


Display Controller Application
++++++++++++++++++++++++++++++

This combination demo employs the ``module_lcd`` along with the ``module_sdram`` and the ``module_display_controller`` framebuffer framework component to implement a 480x272 display controller.

Required board SKUs for this demo are:

   * XP-SKC-L2 (sliceKIT L16 Core Board) plus XA-SK-XTAG2 (sliceKIT XTAG adaptor) 
   * XA-SK-SCR480 for the LCD
   * XA-SK-SDRAM for the SDRAM

   * Package: sw_display_controller
   * Application: app_display_controller


