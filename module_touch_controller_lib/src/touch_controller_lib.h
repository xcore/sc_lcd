#ifndef TOUCHSCREEN_H_
#define TOUCHSCREEN_H_

#include "touch_controller_impl.h"

#define TOUCH_LIB_DELAY 100000000		// corresponds to 1 sec for 100MHz timer

/** \brief The function to fetch the next touch coordinates from the touch screen controller.
 *
 * \param ports The structure containing the touch controller port details.
 * \param ts_x The X coordinate of point of touch.
 * \param ts_y The Y coordinate of point of touch.
 */
select touch_lib_req_next_coord(touch_controller_ports &ports, unsigned &ts_x, unsigned &ts_y);

/** \brief The function to fetch the next touch coordinates from the touch screen controller. The delay in touch event is also computed.
 *
 * \param ports The structure carrying the LCD port details.
 * \param ts_x The X coordinate of point of touch.
 * \param ts_y The Y coordinate of point of touch.
 * \param time The delay in touch event in seconds.
 * \param t The timer used to compute the delay in touch event.
 */
void touch_lib_req_next_coord_timed(touch_controller_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &time, timer t);

/** \brief The function called by another function to fetch the next touch coordinates from the touch screen controller. The delay in touch event is also computed.
 *
 * \param ports The structure carrying the LCD port details.
 * \param ts_x The X coordinate of point of touch.
 * \param ts_y The Y coordinate of point of touch.
 * \param time The delay in touch event in seconds.
 * \param t The timer used to compute the delay in touch event.
 * \param timerCount A counter variable.
 * \param touched The flag that records the touch status.
 */
select touch_lib_next_coord_timed(touch_controller_ports &ports, unsigned &ts_x, unsigned &ts_y, unsigned &nSec, timer t, unsigned &timerCount, unsigned &touched);

/** \brief The function to scale coordinate values (from the touch point coordinates to the LCD pixel coordinates)
 *
 * \param x The X coordinate value
 * \param y The Y coordinate value
 */
void scale_coords(unsigned &x, unsigned &y);

enum {
	TRUE = 1, FALSE = 0
};


#endif /* TOUCHSCREEN_H_ */
