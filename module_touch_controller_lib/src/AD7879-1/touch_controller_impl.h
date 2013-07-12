
#ifndef TOUCH_CONTROLLER_IMPL_H_
#define TOUCH_CONTROLLER_IMPL_H_

#define TOUCH_LIB_TS_WIDTH 4096
#define TOUCH_LIB_TS_HEIGHT 4096

#include "i2c.h"

typedef struct {
	r_i2c i2c_ports;	/**< The I2C ports */
	in port PENIRQ;		/**< The pen-down interrupt line */
}touch_controller_ports;

#endif /* TOUCH_CONTROLLER_IMPL_H_ */
