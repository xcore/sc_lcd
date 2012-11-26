#ifndef TOUCHSCREEN_H_
#define TOUCHSCREEN_H_

#include "touch_controller_impl.h"

select touch_req_next_coord(touchController_ports &ports, unsigned &ts_x, unsigned &ts_y);
void touch_req_next_coord_timed(touchController_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &time, timer t);
select touch_next_coord_timed(touchController_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &nSec, timer t, unsigned &timerCount, unsigned &touched);
void scale_coords(unsigned &x, unsigned &y);

enum {
	TRUE = 1, FALSE = 0
};


#endif /* TOUCHSCREEN_H_ */
