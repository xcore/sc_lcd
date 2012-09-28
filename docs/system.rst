Component Description
=====================

Basics of Graphics LCD
----------------------

The LCD screen types are being widely used in embedded applications due to their cost and simple interface. 

LCD Component Feature
-----------------------

The LCD component is designed to support various LCD available on the market that interface via a CMOS interface.

The LCD component has the following features:

  * Configurability of 
     * LCD pixel dimensions,
     * clock rate,
     * horizontal and vertical timing requiremnts,
     * port mapping of the LCD.
  * Requires a single core for the server.
     * The function ``lcd_server`` requires just one core, the client functions, located in ``lcd.h`` are very low overhead and are called from the application.

