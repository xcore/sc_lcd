#include "touch_lib_conf.h"
#include "touch_controller_lib.h"

void touch_lib_get_next_coord(touch_controller_ports &ports, unsigned &x, unsigned &y)
{
  touch_lib_touch_event(ports);
  touch_lib_get_touch_coords(ports, x, y);
}

void touch_lib_scale_coords(unsigned &x, unsigned &y){

	x = (x*TOUCH_LIB_LCD_WIDTH)/TOUCH_LIB_TS_WIDTH;		// corresponds to column
	y = (y*TOUCH_LIB_LCD_HEIGHT)/TOUCH_LIB_TS_HEIGHT;	// corresponds to row
}

