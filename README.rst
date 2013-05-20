LCD Driver Component
....................

:Latest release: 1.1.0rc0
:Maintainer: andrewstanfordjason
:Description: Driver component and supporting modules for RGB565 LCDs


Key Features
============

   * Standard component to support different LCD displays with RGB 565.
      * Different color depths 32 bpp, 16 bpp, etc. based on user configuration.
      * Resolution of up to 800 * 600 pixels. See table below for different screen configurations.
      * Outputs to a CMOS interface.
   * Standard components to support touch screen controller with I2C serial interface
      * Supports 4-wire resistive touch screens of different sizes
      * Pen-down interrupt signal supported
      * Outputs touch coordinates with time information

Firmware Overview
=================

The LCD component is used to drive a single graphics LCD module up to 800 * 600 pixels with pixel clocks of up to 25MHz.

Known Issues
============

none

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the maintainer for this line.

Required software (dependencies)
================================

  * sc_util (git@github.com:xcore/sc_util)
  * sc_i2c (git@github.com:xcore/sc_i2c.git)

