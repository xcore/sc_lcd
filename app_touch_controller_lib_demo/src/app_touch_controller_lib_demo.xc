#include <stdio.h>
#include <platform.h>
#include "touch_controller_lib.h"

touch_controller_ports ports =
{
		{XS1_PORT_1E, XS1_PORT_1H, 1000},
		XS1_PORT_1D
};

#define TIMEOUT_MS 10000 //(10 seconds)

int main() {
	unsigned x, y, time;
	timer t;

	touch_lib_init(ports);

	printf ("Touch the screen (No timeout)\n");
	touch_lib_get_next_coord(ports, x, y);
	touch_lib_scale_coords(x, y);
	printf ("Touch Coordinates (x,y) = (%u,%u)\n", x, y);
	t:> time;
	//wait a second
	t when timerafter(time + 100000000) :> time;
	printf ("Touch the screen (%d millisecond timeout)\n", TIMEOUT_MS);

	select {
		case touch_lib_touch_event(ports);
		case t when timerafter (time + TIMEOUT_MS*1000000) :> int :{
			printf ("Timeout\n");
			return 1;
		}
	}
	touch_lib_get_touch_coords(ports, x, y);
	touch_lib_scale_coords(x, y);
	printf ("Touch Coordinates (x,y) = (%u,%u)\n", x, y);
	return 0;
}
