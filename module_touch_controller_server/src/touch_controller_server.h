#ifndef TOUCHSCREEN_H_
#define TOUCHSCREEN_H_

#include "touch_controller_impl.h"

enum commands {
	NEXT_TOUCH_CMD = 1,
	LAST_TOUCH_CMD = 2,
	LAST_TOUCH_TIMED_CMD = 3
};

typedef enum{FALSE,TRUE} t_status;


void touch_controller_server(chanend c_server, touchController_ports &ports);
select process_interrupt(touchController_ports &ports, unsigned presentTimeSec, t_status &touched, unsigned &x, unsigned &y, unsigned &touchTime);

t_status touch_server_get_last_coord(chanend c_ts, unsigned &x, unsigned &y);
void touch_server_get_next_coord(chanend c_ts, unsigned &x, unsigned &y);
t_status touch_server_get_last_coord_timed(chanend c_ts, unsigned &t, unsigned &x, unsigned &y);

void scale_coords(unsigned &x, unsigned &y);


#endif /* TOUCHSCREEN_H_ */
