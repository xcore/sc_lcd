#include <stdio.h>
#include <platform.h>

#include "touch_controller_server.h"

#define TILE 0 // triangle slot is used to plug LCD slice. Hence Tile 0
on stdcore[TILE]: touchController_ports ports =
{
		XS1_PORT_1E, XS1_PORT_1H, 1000,
		XS1_PORT_1D
};


void app(chanend c_touchscreen) {
	timer t;
	unsigned x=0, y=0;
	unsigned time, timerTime;
	t_status touchFlag;

	t :> timerTime;

	// Testing functions interfacing touchscreen through a server
	for (int i=0; i<20; i++){
		t when timerafter(timerTime+50000000):> timerTime;	// Execute function every half a second

		touchFlag = touch_get_last_coord(c_touchscreen, x, y);
		if (touchFlag==TRUE)
			printf ("\n Last Touch Coordinates (x,y) = (%u,%u)\n", x, y);
		else
			printf ("\n No touch so far. Please touch the screen .....\n");

		t when timerafter(timerTime+50000000):> timerTime;	// Execute function every half a second

		touchFlag = touch_get_last_coord_timed(c_touchscreen, time, x, y);
		if (touchFlag==TRUE)
			printf ("\n Last Touch Coordinates (x,y) = (%u,%u) before %u seconds \n", x, y, time);
		else
			printf ("\n No touch so far. Please touch the screen ..... \n");
	}

	t when timerafter(timerTime+200000000):> timerTime;	// Wait for 2 seconds
	printf ("\n Please touch the screen .....\n");
	touch_get_next_coord(c_touchscreen, x, y);
	printf ("\n Touch Coordinates (x,y) = (%u,%u)\n", x, y);

}


int main() {
	chan c;

	par {
		on stdcore[TILE]: app(c);
		on stdcore[TILE]: touch_controller_server(c,ports);

		par(int i=0;i<6;i++) on stdcore[TILE]: while(1);	// equivalent to the use of all other 6 logical cores. Comment this line to have only application and server running on two cores.
	}

	return 0;
}

