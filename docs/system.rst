Component Description
=====================

Basics of Graphics LCD
----------------------
Crstals in LCD screens are organized in some random pattern when there is no electric field and aligns to the field when there is an electric field.
The crystals themselves do not emit light, but they gate the amount of light that can pass through them. For example, a crystal which is perpendicualr to a light source will block the light from passing through it. Since the crystals do not emit light on their own, a light source or a backlight is required to get the images on the LCD screen.

The LCDs are classified into Super Twisted Nematic (STN displays) displays and Thin Filn Transistor displays (TFT displays) depending on the technology. This cmoponent uses only TFT displays.

In order to create colors in the otherwise black and white LCD screen, color filters are used for each pixel. To generate the real world colors, there are 3 segments which individually pass light through the red, blue and green filters inorder to make the RGB color. For a 320 * 240 pixel LCD screen, there is actually 320 * 3 = 960 segments (in order to generate the RGB color) and there are 240 rows.
	 
A TFT display needs 1 clock to drive 3 segments - i.e.: 1 clock to generate 1 pixel and hence 320 clock to generate the 320 pixels. The color level depends on the number of lines used to generate the color. The LCD panel might use 24 lines to generate a color. Such LCD panel color code is defined as 24 bpp (24 bits per pixel). The LCD panel might also support 18bpp, 16 bpp, 15 bpp and 8 bpp.

LCDs with parallel RGB interfaces require the following signals for data:

   * D0 - Dx (Data lines) 	
   * LCD CLK (LCD clock)

For data valid determination, either a single data enable signal...

   * LCDDATAENAB - Used to indicate valid data on data bus 

or a vsynch/hsync are required. The LCD component does not current support this option.

   * VSYNC (Vertical Sync) - Used to reset the LCD row pointer to top of the display
   * HSYNC (Horizontal Sync) - Used to reset the LCD column pointer to the edge of the display
        

Some panels might also need LCD power, backlight power, touchscreen lines etc.
The following figure shows the LCD timing parameters. The user should be aware of these parameters to configure the LCD component.

.. only:: html

  .. figure:: images/lcd_timing.png
     :align: center

     LCD Timing Parameters

.. only:: latex

  .. figure:: images/lcd_timing.pdf
     :figwidth: 50%
     :align: center

     LCD Timing Parameters
	 
The frame buffer is the memory allocated for data used to periodically refresh the display. 
The buffer size is computed using rows * columns * size of each pixel. The LCD modules used in this project do not have an
inbuilt frame buffer. Refer to the sw_display_controller application for an example of an integration of this component with an external SDRAM controller and frame buffer management code.


