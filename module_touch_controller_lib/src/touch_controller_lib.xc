#include <stdio.h>
#include <stdlib.h>

#include "touch_controller_conf.h"
#include "touch_controller_lib.h"
#include "touch_controller_impl.h"


select touch_req_next_coord(touchController_ports &ports, unsigned &ts_x, unsigned &ts_y)
{

	case ports.PENIRQ when pinseq(0) :> void:		// pen interrupt goes low when there is a touch

		ports.PENIRQ when pinsneq(0) :> void;		// wait for the interrupt to go high. This indicates completion of ADC conversion.
		{ts_x,ts_y} = get_touch_coordinates(ports.i2c_ports);
		scale_coords(ts_x, ts_y);

	break;

}



void touch_req_next_coord_timed(touchController_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &nSec, timer t)
{
	unsigned timerCount, touched = FALSE;

	nSec = 0;
	t :> timerCount;
	timerCount += DELAY;

	while (1){

		touch_next_coord_timed(ports, ts_x, ts_y, nSec, t, timerCount, touched);
		if (touched) break;
#if (TIME_OUT_MSG_ENABLE)
		if (nSec==TIME_OUT){
			printf ("\n No touch for more than %d seconds.\n", TIME_OUT);
		}
#endif
	}
}


select touch_next_coord_timed(touchController_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &nSec, timer t, unsigned &timerCount, unsigned &touched)
{

	case ports.PENIRQ when pinseq(0) :> void:		// pen interrupt goes low when there is a touch

		ports.PENIRQ when pinsneq(0) :> void;		// wait for the interrupt to go high. This indicates completion of ADC conversion.
		touched = TRUE;

		{ts_x,ts_y} = get_touch_coordinates(ports.i2c_ports);
		scale_coords(ts_x, ts_y);

	break;

	case t when timerafter(timerCount) :> void:	// timer event every one second
		timerCount += DELAY;
		nSec++;
	break;

}


void scale_coords(unsigned &x, unsigned &y){

	x = (x*LCD_WIDTH)/TS_WIDTH;		// corresponds to column
	y = (y*LCD_HEIGHT)/TS_HEIGHT;	// corresponds to row
}

