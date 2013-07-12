#include <stdio.h>
#include <platform.h>
#include "touch_controller_server.h"

#define TILE 0
on stdcore[TILE]: touch_controller_ports ports =
{
  {XS1_PORT_1E, XS1_PORT_1H, 1000},
		XS1_PORT_1D
};

void app(chanend c_touchscreen) {
	unsigned x=0, y=0, x_last=0, y_last=0;
	t_status touchFlag;

	// Testing functions interfacing touchscreen through a server
	printf ("\n Please touch the screen .....\n");

	while (1){
		touchFlag = touch_server_get_last_coord(c_touchscreen, x_last, y_last);
		touch_server_get_next_coord(c_touchscreen, x, y);

		printf ("\n Present Touch Coordinates (x,y) = (%u,%u).   ", x, y);
		if (touchFlag==TRUE)
			printf ("Previous Touch Coordinates (x,y) = (%u,%u). \n", x_last, y_last);
		else
			printf ("No touch before. \n");
	}
}


int main() {
	chan c;
	par {
		on stdcore[TILE]: app(c);
		on stdcore[TILE]: touch_controller_server(c, ports);
		par(int i=0;i<6;i++) on stdcore[TILE]: while(1);	// equivalent to the use of all other 6 logical cores. Comment this line to have only application and server running on two cores.
	}

	return 0;
}

