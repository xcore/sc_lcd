Rotating Image Application
==========================

The rotating image application shows how a 2D image can be moved across the LCD screen. 
The application uses the character "X" from the "XMOS" logo. The image is of size 64  * 64 pixels.

Features supported in the application
-------------------------------------

The application supports the following:

#. Moving a 64 * 64 pixel size image across the screen
#. The image sizes can be modified for smaller or bigger images
#. Checks for the LCD width and height to make sure the image doesn't go beyond the LCD limits

Project structure
-----------------

The application includes the following files

  * - File
    - Description
  * - ``rotate.h``
    - Header file containing the image pixel data
  * - ``main.xc``
    - File containing the implementation of the 2D image rotation across the screen

APIs
----

The demo is executed in the API c:func::`demo` which takes of the image rotation and check for LCD limits

Executing the application
-------------------------

The application is available as app_image_rotation.
The following steps ahould be followed to run the application
  #. Include the app_image_rotation and module_lcd to the workspace
  #. Build the application
  #. Run the application using the XTAG
  #. The image of the XMOS logo will move across the screen
  