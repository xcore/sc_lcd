sc_lcd
======

The LCD component used to drive the Graphics LCD screen of resolution upto 800 * 600 pixels.
The component includes 1 module - module_lcd.
It functions as a standalone component - so that the pixel data can be directly sent to the LCD incase there is no image buffer available.

Example applications have been provided with the component
 - app_graphics_demo - highlighting the capability of XCORE to write character and text using a standalone LCD component
 - app_image_rotation - simple movement of a 2D image across the LCD screen