Example Applications
====================

This tutorial describes the demo applications included in the XMOS LCD software component. 
:ref:`sec_hardware_platforms` describes the required hardware setups to run the demos.

app_lcd_demo
------------

This application demonstrates how the module is used to write image data to the LCD screen. The purpose of this application is to show how data is passed to the ``lcd_server`` 

Application Notes
-----------------
  #. ``lcd_server`` requires a single logical core.
  #. ``lcd_init`` must be called before ``lcd_update_p`` or ``lcd_update`` are called. This puts the LCD server into a state ready to accept data.
  #. ``lcd_update`` and ``lcd_update_p`` are used to send an array of pixel data to the LCD server. There is a real-time requirement that this function is called often enough to maintain the display.  ``lcd_update_p`` is the C interface to the LCD server, it takes a pointer to an array rather than the array itself. 
  #. ``lcd_req`` is a function (also a select handler) that acknowledges the LCDs request for the next line of pixel data. 
  #. The LCD server does no buffering of pixel line arrays, therefore, for every ``lcd_req`` there must be only one  ``lcd_update`` or ``lcd_update_p``. Likewise for every ``lcd_update`` or ``lcd_update_p`` there must be only one ``lcd_req``.
  #. The pixel array must be on the same tile as the ``lcd_server``.

Getting Started
+++++++++++++++

   #. Plug the XA-SK-LCD Slice Card into the 'STAR' slot of the Slicekit Core Board
   #. Plug the XA-SK-XTAG2 Card into the Slicekit Core Board.
   #. Ensure the XMOS LINK switch on the XA-SK-XTAG2 is set to "off".
   #. Ensure the jumper on the XA-SK-SCR480 is bridged if the back light is required.
   #. Open ``app_lcd_demo.xc`` and build the project.
   #. Run the program

The output produced should look like a bouncing "X" on the LCD screen.

app_touch_controller_lib_demo
-----------------------------

This application demonstrates how the module ``module_touch_controller_lib`` is used to fetch the touch coordinates from the touch screen controller. 

Application Notes
-----------------
 
  #. ``touch_lib_init`` must be called before calling ``touch_lib_req_next_coord`` or/and ``touch_lib_req_next_coord_timed``. 
  #. ``touch_lib_req_next_coord`` and ``touch_lib_req_next_coord_timed`` wait for touch event and then read the touch coordinates stored in the result registers of touch screen controller. ``touch_lib_req_next_coord_timed`` computes the time delay in touch event from the function call. 
  

Getting Started
+++++++++++++++

   #. Plug the XA-SK-LCD Slice Card into the 'TRIANGLE' slot of the Slicekit Core Board
   #. Plug the XA-SK-XTAG2 Card into the Slicekit Core Board.
   #. Click on the ``app_touch_controller_lib_demo`` and build the project.
   #. Run the demo.



