Component Description
=====================

Basics of Graphics LCD
----------------------
The LCD screen as the name indicates is an array of 'Liquid Crystal Display', which are organized in some random pattern when there is no electric field and aligns to the field when there is an electric field.
The crystals themselves do not emit light, but they gate the amount of light that can pass through them. For example, a crystal which is perpendicualr to a light source will block the light from passing through it. Since the crystals do not emit light on their own, a light source or a backlight is required to get the images on the LCD screen.
The LCDs are classified into Super Twisted Nematic (STN displays) displays and Thin Filn Transistor displays (TFT displays) depending on the technology. This project uses only TFT displays.

In order to create colors in the otherwise black and white LCD screen, color filters are used for each pixel. To generate the real world colors, there are 3 segments which individually pass light through the red, blue and green filters inorder to make the RGB color. For a 320 * 240 pixel LCD screen, there is actually 320 * 3 = 960 segments (in order to generate the RGB color) and there are 240 rows.
	 
A TFT display needs 1 clock to drive 3 segments - i.e.: 1 clock to generate 1 pixel and hence 320 clock to generate the 320 pixels. The color level depends on the number of lines used to generate the color.
The LCD panel might use 24 lines to generate a color. Such LCD panel color code is defined as 24 bpp (24 bits per pixel). The LCD panel might also support 18bpp, 16 bpp, 15 bpp and 8 bpp.

LCDs required the following basic signals:

        * VSYNC (Vertical Sync) - Used to reset the LCD row pointer to top of the display
        * HSYNC (Horizontal Sync) - Used to reset the LCD column pointer to the edge of the display
        * D0 - Dx (Data lines) 	
        * LCD CLK (LCD clock)
        * LCDDATAENAB - Used to indicate valid data on data bus

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
inbuilt frame buffer. The external memory is used as the frame buffer.

LCD component
-------------

The LCD display component controls the LCD graphics module which includes handling the clock and the data enable signals.
The Data enable signals can be used to handle the timings for the vertical and horizontal porch and hence controls the lcd data update.
The LCD component can also be modified to support the vertical and horizontal Sync signals in case of LCD modules which need the HSYNC and VSYNC signals. 


Note that the current code supports only LCDDATAENAB signal as the LCD module used does not need the HYSNC and VSYNC signals.
The LCD uses 16 bps (bits per pixel) color code.
The LCD module includes the main function :c:func:`lcd` which is handled in a thread.

The same LCD component can be used to drive various graphics LCD modules. The maximum resolution supported is 800 * 600.
The component supports only LCD modules with no in-built memory.
The project is designed in such a way that the external memory is used for storing the LCD buffer data.
The LCD parameters are configured in the files ``lcd.h`` and ``lcd_ports.xc``.


