#include <stdio.h>
#include <platform.h>

#include "touch_controller_lib.h"
#include "touch_controller_impl.h"

#define TILE 0 // triangle slot is used to plug LCD slice. Hence Tile 0
on stdcore[TILE]: touchController_ports ports =
{
		XS1_PORT_1E, XS1_PORT_1H, 1000,
		XS1_PORT_1D
};


void app(touchController_ports &ports) {
	unsigned x=0, y=0;
	unsigned time,timerTime;
	timer t;
	int choice;

	touch_controller_init(ports);	// Initialises control registers of touch screen controller

	// Testing functions interfacing touchscreen
	printf ("\n Please touch the screen .......\n");
	touch_req_next_coord(ports, x, y);
	printf ("\n Touch Coordinates (x,y) = (%u,%u)\n", x, y);

	t :> timerTime;
	t when timerafter(timerTime+200000000):> void;	//
	printf ("\n Please touch the screen again to display touch coordinates with time delay.......\n");
	touch_req_next_coord_timed(ports, x, y, time, t);
	printf ("\n Touch Coordinates (x,y) = (%u,%u) after %u seconds \n", x, y, time);

}


int main() {

	par {
		on stdcore[TILE]: app(ports);
//		par(int i=0;i<7;i++) on stdcore[TILE]:  while(1);	// equivalent to the use of all other 7 logical cores. Comment this line to have application running on single core.
   	}

	return 0;
}

