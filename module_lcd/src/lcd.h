#ifndef _lcd_h_
#define _lcd_h_

#include "lcd_defines.h"
/**
 * The structure to represent LCD port configuration
 */
struct lcd_ports {
  out port lcd_clk; 			/**< The clock line */
  out port lcd_data_enabled; 		/**< The LCD data enabled */
  out port lcd_rgb; 			/**< 16 bit data port */
  out buffered port:32 lcd_hsync; 	/**< The hsync line */
  out buffered port:32 lcd_vsync; 	/**< The vsync line */
  clock clk_lcd; 			/**< Clock block used for LCD clock */
};

/** \brief The LCD server thread.
* 
* \param client The channel end connecting to the client.
* \param ports The structure carrying the LCD port details. 
*/
void lcd_server(chanend client, struct lcd_ports &ports);

/** \brief LCD init function. This sets the lcd into a state where it is ready to accept data.
* 
* \param c_lcd The channel end connecting to the lcd server.
*/
void lcd_init(chanend c_lcd);

/** \brief LCD update function. This sends a buffer of data to the lcd server to to sent to the lcd.
* 
* \param c_lcd The channel end connecting to the lcd server.
* \param buffer[] The data to to emitted to the lcd screen, stored in rgb565. Note, no array bounds checking is performed.
*/
static inline void lcd_update(chanend c_lcd, unsigned buffer[]){
	unsigned buffer_pointer;
	asm  ("mov %0, %1" : "=r"(buffer_pointer) : "r"(buffer));
	c_lcd <: buffer_pointer;
}

#endif
