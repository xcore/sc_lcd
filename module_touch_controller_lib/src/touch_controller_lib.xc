#include <stdio.h>
#include <stdlib.h>

#include "touch_lib_conf.h"
#include "touch_controller_lib.h"
#include "touch_controller_impl.h"


select touch_lib_req_next_coord(touch_controller_ports &ports, unsigned &ts_x, unsigned &ts_y)
{

	case ports.PENIRQ when pinseq(0) :> void:		// pen interrupt goes low when there is a touch

		ports.PENIRQ when pinsneq(0) :> void;		// wait for the interrupt to go high. This indicates completion of ADC conversion.
		{ts_x,ts_y} = get_touch_coordinates(ports.i2c_ports);
		scale_coords(ts_x, ts_y);

	break;

}



void touch_lib_req_next_coord_timed(touch_controller_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &nSec, timer t)
{
	unsigned timerCount, touched = FALSE;

	nSec = 0;
	t :> timerCount;
	timerCount += TOUCH_LIB_DELAY;

	while (1){

		touch_lib_next_coord_timed(ports, ts_x, ts_y, nSec, t, timerCount, touched);
		if (touched) break;
		if ((nSec%TOUCH_LIB_TIME_OUT)==0){
			printf ("\n No activity for %d seconds.\n", nSec);
		}
	}
}


select touch_lib_next_coord_timed(touch_controller_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &nSec, timer t, unsigned &timerCount, unsigned &touched)
{

	case ports.PENIRQ when pinseq(0) :> void:		// pen interrupt goes low when there is a touch

		ports.PENIRQ when pinsneq(0) :> void;		// wait for the interrupt to go high. This indicates completion of ADC conversion.
		touched = TRUE;

		{ts_x,ts_y} = get_touch_coordinates(ports.i2c_ports);
		scale_coords(ts_x, ts_y);

	break;

	case t when timerafter(timerCount) :> void:	// timer event every one second
		timerCount += TOUCH_LIB_DELAY;
		nSec++;
	break;

}


void scale_coords(unsigned &x, unsigned &y){

	x = (x*TOUCH_LIB_LCD_WIDTH)/TOUCH_LIB_TS_WIDTH;		// corresponds to column
	y = (y*TOUCH_LIB_LCD_HEIGHT)/TOUCH_LIB_TS_HEIGHT;	// corresponds to row
}

