#include "touch_controller_impl.h"

#define DEV_ADDR 0x2c
#define CNTL_REG1 0x01
#define CNTL_REG2 0x02
#define CNTL_REG3 0x03
#define Y_REG 0x08
#define X_REG 0x09

	// control register 1 setting
	// [15]=0 pen intr enabled;[14:12]=000 ADC channel for manual conversion, not applicable; [11:10]=11 ADC master mode;
	// [9:8]=ADC acquisition time to 16 microsec; [7:0]=0000 0011 conversion interval timer to 620 microsec

#define CNTL_WORD1_MS_BYTE 0x0f;
#define CNTL_WORD1_LS_BYTE 0x03;

	// control register 2 setting
	// Bits [15:14]=01 power save mode; [13:10]=0000 GPIO disabled; [9]=0 ratiometric conversion for greater accuracy;
	// [8:7]=01 4 middle values chosen for averaging filter; [6:5]=10 8 measurements for median filters;
	// These filters may be used for noise suppression. See pg.17 of AD7879/AD7889 spec
	// [4]=0 SW reset disabled; [3:0]=1111 ADC first conversion delay set to 4.096ms
	// To disable median filter, choose [8:5]=0000;  Eg. data[0]=0x40; data[1]=0x0f;

#define CNTL_WORD2_MS_BYTE 0x40;
#define CNTL_WORD2_LS_BYTE 0xcf;

	// control register 3 setting
	// [15]=1 temperature intr disabled; [14]=1 AUX interrupt disabled; [13]=1 INT but disbled if bit 15 of CR1 id 0 (fig.38)
	// [12]=1 GPIO intr disabled; [11:9]=0000 limit check disabled as not applicable; [7:6]=11 YX measurement enabled
	// [5:0]=000000 other measurements disabled

#define CNTL_WORD3_MS_BYTE 0xf0;
#define CNTL_WORD3_LS_BYTE 0xc0;

#pragma unsafe arrays
void touch_lib_init(touch_controller_ports &ports) {

	unsigned char data[2];
	unsigned time;
	timer t;

	data[0] = CNTL_WORD2_MS_BYTE;
	data[1] = CNTL_WORD2_LS_BYTE;
	i2c_master_write_reg(DEV_ADDR, CNTL_REG2, data, 2, ports.i2c_ports);


	data[0] = CNTL_WORD3_MS_BYTE;
	data[1] = CNTL_WORD3_LS_BYTE;
	i2c_master_write_reg(DEV_ADDR, CNTL_REG3, data, 2, ports.i2c_ports);


	data[0] = CNTL_WORD1_MS_BYTE;
	data[1] = CNTL_WORD1_LS_BYTE;
	i2c_master_write_reg(DEV_ADDR, CNTL_REG1, data, 2, ports.i2c_ports);

	t :> time;
	t when timerafter(time+1000000):>void;	// wait for the touch screen controller to settle down
	ports.PENIRQ when pinseq(1) :> void;		// wait for pen interrupt to go high
}

#pragma unsafe arrays
void touch_lib_get_touch_coords(touch_controller_ports &ports, unsigned &x, unsigned &y){
	unsigned char Ybytes[2], Xbytes[2];
  // Read Y register storing Y position of touch
  i2c_master_read_reg(DEV_ADDR, Y_REG, Ybytes, 2, ports.i2c_ports);
  // Combine MS byte and LS byte to get a 16-bit Y value
  y = (unsigned)((Ybytes[0] << 8) + Ybytes[1]);

  // Read X register storing X position of touch
  i2c_master_read_reg(DEV_ADDR, X_REG, Xbytes, 2, ports.i2c_ports);
  // Combine MS byte and LS byte to get a 16-bit Y value
  x = (unsigned)((Xbytes[0] << 8) + Xbytes[1]);
}

select touch_lib_touch_event(touch_controller_ports &ports){
  case ports.PENIRQ when pinseq(0):>int:
  break;
}

