Touch Controller Server Demo Quickstart Guide
=============================================

.. _Slicekit_TouchController_Server_Demo_Quickstart:


This demo uses the XA-SK-SCR480 Slice Card together with the Kentec K430WQA-V5-F display.  xSOFTip I2C Master component is used to communicate with the AD7879-1 low voltage controller chip on the slice card for interfacing the touch screen of the 
Kentec display. 

The demo consists of simple functions to read the touch coordinates and also to compute the time of touch.

  
Hardware Setup
++++++++++++++

The XP-SKC-L2 Slicekit Core board has four slots: ``SQUARE``, ``CIRCLE``, ``TRIANGLE`` and ``STAR``. 

To setup up the system:

   #. Connect the XA-SK-SCR480 Slice Card to the ``TRIANGLE`` slot (Tile 0) of XP-SKC-L2 Slicekit Core board.
   #. Connect the Kentec K430WQA-V5-F display to the connector on the slice card.
   #. Connect the XTAG Adapter to Slicekit Core board, and connect XTAG-2 to the adapter. 
   #. Connect the XTAG-2 to host PC. Note that a USB cable is not provided with the Slicekit starter kit.
   #. Switch on the power supply to the Slicekit Core board.

.. figure:: images/hardware_setup.jpg
   :align: center

   Hardware Setup for Touch Controller Demo
   
	
Import and Build the Application
++++++++++++++++++++++++++++++++

   #. Open xTIMEcomposer Studio.
   #. Import ``sc_lcd`` project and ``module_i2c_master`` module into the Project Explorer window of the xTIMEcomposer. 
   #. Click on the ``app_touch_controller_server_demo`` item in the Explorer pane. Then click on the build icon (hammer) in xTIMEcomposer. Check the console window to verify that the application has built successfully.


Run the Application
+++++++++++++++++++

Now that the application has been compiled, the next step is to run it on the Slicekit Core Board using the tools to load the application over JTAG (via the XTAG2 and XTAG Adaptor card) into the xCORE multicore microcontroller.

   #. Click on the run icon (the white arrow in the green circle). A dialog will appear asking which device to connect to. Select ``XMOS XTAG2``. 
   #. When the screen is touched, the coordinates of the last touch are displayed in the Debug Console window. If there is no touch, the message ``No touch so far. Please touch the screen .....`` is displayed. You can notice the change in touch coordinates whenever you touch the screen. Alternate lines of display print the time elapsed from the last touch. 
   #. Wait for the message ``Please touch the screen .....``. When the screen is touched, the touch coordinates are displayed. If there is no touch for a period of time (``TIME_OUT`` currently set to 10 seconds in ``touch_controller_conf.h``), a message ``No touch for more than 10 seconds`` is printed and the program continues to wait for a touch.
   #. You can terminate the program by clicking on the red button in the Console window.
 
    
Next Step
+++++++++

Look at the Code
................

   #. Examine the application code. In xTIMEcomposer, navigate to the ``src`` directory under ``app_touch_controller_server_demo`` and double click on the ``app_touch_controller_server_demo.xc`` file within it. The file will open in the central editor window.
   #. Find the ``main()`` function and note that it runs the ``app()`` function on one logical core and the ``touch_controller_server()`` on another core. You may engage other six logical cores using ``par`` replicator.
   #. The ``app()`` function in the file calls two functions, namely, ``touch_get_last_coord()`` and ``touch_get_last_coord_timed()`` repeatedly for 20 iterations. These functions retrieve the already stored touch coordinates from the server. The function  ``touch_get_next_coord()`` is called at the end. In the server side, it waits for the touch and reads the touch coordinates stored in the result registers of AD7879-1.  
   #. The various parameters used are defined in ``touch_controller_conf.h``. You can change their values if necessary.

   
   
