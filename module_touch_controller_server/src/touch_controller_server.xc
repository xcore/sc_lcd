#include <stdio.h>
#include <stdlib.h>

#include "touch_server_conf.h"
#include "touch_controller_server.h"
#include "touch_controller_impl.h"

#define TOUCH_SERVER_DELAY 100000000		// corresponds to 1 sec for 100MHz timer


enum commands {
	NEXT_TOUCH_CMD = 1,
	LAST_TOUCH_CMD = 2,
	LAST_TOUCH_TIMED_CMD = 3
};

void touch_controller_server(chanend c_server, touch_controller_ports &ports)
{
	unsigned cmd, exitLoop=0;
	t_status touched=FALSE, nextTouched=FALSE;
	unsigned ts_x=0, ts_y=0;
	unsigned touchTime, currentTime, elapsedTime, cmdTime;
	unsigned time, nSec;
	timer t;

	touch_server_init(ports);	// sets control registers in the controller
	t :> time;
	t when timerafter(time+1000000):>void;	// wait for the interrupt value to settle down

	while(1)
	{

		# pragma ordered
		select
		{
			case t when timerafter(time) :> void:	// timer event every one second
				time += TOUCH_SERVER_DELAY;
				nSec++;
				break;

			case ports.PENIRQ when pinseq(0) :> void:		// pen interrupt goes low when there is a touch
				touch_server_process_interrupt(ports,nSec,touched,ts_x,ts_y,touchTime);
				break;

			case c_server :> cmd:	// process commands from the application program
			{

				switch (cmd) {
				case NEXT_TOUCH_CMD:
					cmdTime = nSec;

					while(1){
						select {
						case ports.PENIRQ when pinseq(0) :> void:	// wait for pen interrupt
							touch_server_process_interrupt(ports,nSec,touched,ts_x,ts_y,touchTime);
							nextTouched = TRUE;
							break;

						case t when timerafter(time) :> void:	// timer event every one second
							time += TOUCH_SERVER_DELAY;
							nSec++;

							// Time out
							if (((nSec-cmdTime)%TOUCH_SERVER_TIME_OUT)==0){
								printf ("\n No activity for %d seconds. \n", nSec-cmdTime);
							}

							// Send X,Y to application program through channel
							if (nextTouched){
								c_server <: ts_x;
								c_server <: ts_y;
								nextTouched = FALSE;
								exitLoop = 1;
							}
							break;
						}

						if (exitLoop) break;
					}

					exitLoop = 0;
					break;

				case LAST_TOUCH_CMD:
					// Send the stored touch coordinates of last touch
					c_server <: touched;
					c_server <: ts_x;
					c_server <: ts_y;
					break;

				case LAST_TOUCH_TIMED_CMD:
					// compute elapsedTime in seconds
					currentTime = nSec;
					elapsedTime = currentTime-touchTime;

					// send the stored touch coordinates of last touch and the time elapsed
					c_server <: touched;
					c_server <: ts_x;
					c_server <: ts_y;
					c_server <: elapsedTime;
					break;

				default:
					break;
				}

				break;
			}

		}

	}

}


select touch_server_process_interrupt(touch_controller_ports &ports, unsigned presentTimeSec, t_status &touched, unsigned &x, unsigned &y, unsigned &touchTime){

	case ports.PENIRQ when pinsneq(0) :> void:		// wait for the interrupt to go high. This indicates completion of ADC conversion.
	touchTime = presentTimeSec;
	touched = TRUE;

	{x,y} = get_touch_coordinates(ports.i2c_ports);

	break;

}


void touch_server_get_next_coord(chanend c_ts, unsigned &x, unsigned &y){
	c_ts <: NEXT_TOUCH_CMD;
	c_ts :> x;
	c_ts :> y;

	touch_server_scale_coords(x,y);
}


t_status touch_server_get_last_coord(chanend c_ts, unsigned &x, unsigned &y){
	unsigned temp_x,temp_y;
	t_status touched;

	c_ts <: LAST_TOUCH_CMD;
	c_ts :> touched;
	c_ts :> temp_x;
	c_ts :> temp_y;

	if (touched==TRUE){
		x = temp_x; y = temp_y;		// change (x,y) of application program only if there is touch
		touch_server_scale_coords(x,y);
	}

	return (touched);
}


t_status touch_server_get_last_coord_timed(chanend c_ts, unsigned &t, unsigned &x, unsigned &y){
	unsigned temp_x,temp_y,temp_t;
	t_status touched;

	c_ts <: LAST_TOUCH_TIMED_CMD;
	c_ts :> touched;
	c_ts :> temp_x;
	c_ts :> temp_y;
	c_ts :> temp_t;

	if (touched==TRUE){
		x = temp_x; y = temp_y;	t = temp_t;	// change (x,y)and time values of application program only if there is touch
		touch_server_scale_coords(x,y);
	}

	return (touched);
}


void touch_server_scale_coords(unsigned &x, unsigned &y){

	x = (x*TOUCH_SERVER_LCD_WIDTH)/TOUCH_SERVER_TS_WIDTH;		// corresponds to column
	y = (y*TOUCH_SERVER_LCD_HEIGHT)/TOUCH_SERVER_TS_HEIGHT;	// corresponds to row

}
