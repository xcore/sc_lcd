#ifndef TOUCH_CONTROLLER_LIB_H_
#define TOUCH_CONTROLLER_LIB_H_

/*
 * This should import the implementation specific ports for the touch
 * controller that is in use.
 */
#include "touch_controller_impl.h"

/*
 * Implementation Specific
 */

/** \brief The touch controller initialisation.
 *
 * \param ports The structure containing the touch controller port details.
 */
void touch_lib_init(touch_controller_ports &ports);

/** \brief Get the current touch coordinates from the touch controller.
 * The returned coordinates are not scaled.
 *
 * \param ports The structure containing the touch controller port details.
 * \param x The X coordinate of point of touch.
 * \param y The Y coordinate of point of touch.
 */
void touch_lib_get_touch_coords(touch_controller_ports &ports,
    unsigned &x, unsigned &y);

/** \brief A select function that will wait until the touch controller reports
 * a touch event.
 *
 * \param ports The structure containing the touch controller port details.
 */
select touch_lib_touch_event(touch_controller_ports &ports);


/** \brief This function will block until the controller reports a touch event at
 * which point it will return the coordinates of that event. The coordinates are
 * not scaled.
 *
 * \param ports The structure containing the touch controller port details.
 * \param x The X coordinate of point of touch.
 * \param y The Y coordinate of point of touch.
 */
void touch_lib_get_next_coord(touch_controller_ports &ports,
		unsigned &x, unsigned &y);

/** \brief The function to scale coordinate values (from the touch point
 * coordinates to the LCD pixel coordinates)
 *
 * \param x The scaled X coordinate value
 * \param y The scaled Y coordinate value
 */
void touch_lib_scale_coords(unsigned &x, unsigned &y);

#endif /* TOUCH_CONTROLLER_LIB_H_ */
