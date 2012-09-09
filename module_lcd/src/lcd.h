#ifndef _lcd_h_
#define _lcd_h_

#include "lcd_defines.h"

/** \brief The function handles the LCD graphics module. It handles the LCD module's clock, vertical sync and horizontal sync and data parameters
* 
* \param c_lcd The channel end number
*/
void lcd_server(chanend c_lcd, lcd_ports &ports);

/** \brief The function to initialize the LCD data write
*
* \param c_lcd The channel end number
*/
void lcd_init(chanend c_lcd);

/** \brief The function updates the LCD channel with the data in the buffer
*
* \param c_lcd The channel end number
* \param buffer[] The buffer containing the data to be updated
*
* \note The function should be called for each line of LCD data.
* \note There should be no delay between writes for consecutive lines of data as the LCD server expects continuous data till the entire screen is refreshed
*/
void lcd_update(chanend c_lcd, unsigned buffer[]);

#endif
