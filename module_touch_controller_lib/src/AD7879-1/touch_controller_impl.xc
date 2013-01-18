
#include <print.h>

#include "touch_controller_impl.h"
#include "touch_lib_conf.h"

#pragma unsafe arrays

void touch_lib_init(touch_controller_ports &ports) {

	unsigned char data[2];
	unsigned intr, time;
	timer t;

	data[0] = TOUCH_LIB_CNTL_WORD2_MS_BYTE;
	data[1] = TOUCH_LIB_CNTL_WORD2_LS_BYTE;
	i2c_master_write_reg(TOUCH_LIB_DEV_ADDR, TOUCH_LIB_CNTL_REG2, data, 2, ports.i2c_ports);


	data[0] = TOUCH_LIB_CNTL_WORD3_MS_BYTE;
	data[1] = TOUCH_LIB_CNTL_WORD3_LS_BYTE;
	i2c_master_write_reg(TOUCH_LIB_DEV_ADDR, TOUCH_LIB_CNTL_REG3, data, 2, ports.i2c_ports);


	data[0] = TOUCH_LIB_CNTL_WORD1_MS_BYTE;
	data[1] = TOUCH_LIB_CNTL_WORD1_LS_BYTE;
	i2c_master_write_reg(TOUCH_LIB_DEV_ADDR, TOUCH_LIB_CNTL_REG1, data, 2, ports.i2c_ports);

	t :> time;
	t when timerafter(time+1000000):>void;	// wait for the touch screen controller to settle down
	ports.PENIRQ when pinseq(1) :> intr;		// wait for pen interrupt to go high

}


{unsigned, unsigned} get_touch_coordinates(r_i2c &i2c_ports){
	unsigned char Ybytes[2], Xbytes[2];
	unsigned x,y;

	i2c_master_read_reg(TOUCH_LIB_DEV_ADDR, TOUCH_LIB_Y_REG, Ybytes, 2, i2c_ports);	// Read Y register storing Y position of touch
	y = (unsigned)((Ybytes[0] << 8) + Ybytes[1]);	// Combine MS byte and LS byte to get a 16-bit Y value

	i2c_master_read_reg(TOUCH_LIB_DEV_ADDR, TOUCH_LIB_X_REG, Xbytes, 2, i2c_ports);	// Read X register storing X position of touch
	x = (unsigned)((Xbytes[0] << 8) + Xbytes[1]);

	return {x,y};
}


