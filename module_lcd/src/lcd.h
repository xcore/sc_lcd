#ifndef _lcd_h_
#define _lcd_h_

#include "lcd_defines.h"

/** \brief The function handles the LCD graphics module. It handles the LCD module's clock, vertical sync and horizontal sync and data parameters
* 
* \param c_lcd The channel end number
*/
void lcd(chanend c_lcd);

#endif
