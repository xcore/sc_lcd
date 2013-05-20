#include <stdio.h>
#include <platform.h>

#include "touch_controller_lib.h"

#define TILE 0 // triangle slot is used to plug LCD slice. Hence Tile 0
on stdcore[TILE]: touch_controller_ports ports =
{
		XS1_PORT_1E, XS1_PORT_1H, 1000,
		XS1_PORT_1D
};

void app(touch_controller_ports &ports) {
	unsigned x=0, y=0;
	unsigned time,timerTime;
	timer t;

	touch_lib_init(ports);	// Initialises control registers of touch screen controller

	// Testing functions interfacing touchscreen
	printf ("\n Please touch the screen .......\n");
	touch_lib_req_next_coord(ports, x, y);
	printf ("\n Touch Coordinates (x,y) = (%u,%u)\n", x, y);

	t :> timerTime;
	t when timerafter(timerTime+200000000):> void;	//
	printf ("\n Please touch the screen again to display touch coordinates with time delay.......\n");
	touch_lib_req_next_coord_timed(ports, x, y, time, t);
	printf ("\n Touch Coordinates (x,y) = (%u,%u) after %u seconds \n", x, y, time);
}


int main() {
	app(ports);
	return 0;
}
