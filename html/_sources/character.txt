Character display Application
=============================

The character display application shows how to display character and text on the LCD module.
The application is intended to use the LCD component as a standalone component, which means there is no image buffer to store the LCD frame data.
The application writes directly to the LCD component.

Features supported in the application
-------------------------------------

The application supports the following:

#. Setting the graphics frame ready for display
#. Setting the background colour
#. Setting the foreground colour
#. Reading the background colour
#. Reading the foreground colour
#. Setting the space between characters in a text
#. Setting the text style - can be none, Italics, bold, bold and Italics
#. Displaying a character of size 6 * 6 pixel in monochrome colour
#. Displaying a character of size 6 * 6 pixel in colour
#. Displaying text of size 6 * 6 pixel in monochrome colour
#. Displaying text of size 6 * 6 pixel in colour (mentioned foreground colour is used)
#. Displaying text of size 16 * 16 pixel in colour (mentioned foreground colour is used)
#. Putting an image to the screen

Project structure
-----------------

The application includes character specific functionalities and general graphics functionalities.
The general graphics functionalities are available in the files

    * graphics.xc
    * graphics.h

The character specific functionalities are available in the files

.. list-table:: Project structure
  :header-rows: 1
  
  * - File
    - Description
  * - ``character_display.h``
    - Header file containing the APIs for the character and text writes
  * - ``character_display.xc``
    - File containing the implementation of the character and text write for 6 * 6 pixel and 16 * 16 pixel
  * - ``alphabet.c``
    - File containing the pixel data for 6 * 6 characters. Currently the file includes only A-Z (upper case) and space
  * - ``alphabet_16x16.c``
    - File containing the pixel data for 16 * 16 characters. Currently the file includes only A-Z (upper case) and space. It also includes the font with no formatting and in Italics
  * - ``alphabet_lookup_table.c``
    - File containing the lookup table for the characters and APIs to find the pixel data for a character    
  * - ``character_specific_includes.h``
    - Header file including the defines specific for the character list
    

APIs
----

Following are the list of APIs that can used for character and text display. Currently only 6 * 6 and 16 * 16 pixel fonts are supported

.. doxygenfunction:: set_background_color
.. doxygenfunction:: set_foreground_color
.. doxygenfunction:: set_graphics_frame
.. doxygenfunction:: get_foreground_color
.. doxygenfunction:: get_background_color
.. doxygenfunction:: put_image_BW
.. doxygenfunction:: write_text_6x6_bw
.. doxygenfunction:: write_text_6x6_color
.. doxygenfunction:: write_character_6x6_bw
.. doxygenfunction:: write_character_6x6_color
.. doxygenfunction:: write_text_16x16_color
.. doxygenfunction:: get_character_6x6
.. doxygenfunction:: get_character_16x16
.. doxygenfunction:: set_text_feature
.. doxygenfunction:: get_text_feature
.. doxygenfunction:: set_text_space

Demo
----

The file demo.xc includes a sample demo using the character and text display and displaying the image.
The function c:func::graphics_demo does the following

  * Displays the image of a silicon on the screen. The Silicon image keeps moving on the screen
  * The image is displayed as monochrome image
  * Multiple text that keeps changing after a certain time of display
  * The text is displayed in Yellow colour and in Italics
  * The text displayed are
      * WELCOME TO XMOS
      * HIGH SPEED USB
      * MOTOR CONTROL
      * ETHERNET AVB
      * FREE TOOLS

Executing the application
-------------------------

The application is available as app_graphics_demo.
The following steps ahould be followed to run the application
  #. Include the app_graphics_demo and module_lcd to the workspace
  #. Build the application
  #. Run the application using the XTAG
  #. The image of the silicon and the texts keeps repeating on the screen
  
