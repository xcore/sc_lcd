
#ifndef TOUCH_CONTROLLER_IMPL_H_
#define TOUCH_CONTROLLER_IMPL_H_

#include "i2c.h"

typedef struct {
	r_i2c i2c_ports;	/**< The I2C ports */
	in port PENIRQ;		/**< The pen-down interrupt line */
}touch_controller_ports;


#define TOUCH_LIB_DEV_ADDR 0x2c
#define TOUCH_LIB_CNTL_REG1 0x01
#define TOUCH_LIB_CNTL_REG2 0x02
#define TOUCH_LIB_CNTL_REG3 0x03
#define TOUCH_LIB_Y_REG 0x08
#define TOUCH_LIB_X_REG 0x09

	// control register 1 setting
	// [15]=0 pen intr enabled;[14:12]=000 ADC channel for manual conversion, not applicable; [11:10]=11 ADC master mode;
	// [9:8]=ADC acquisition time to 16 microsec; [7:0]=0000 0011 conversion interval timer to 620 microsec

#define TOUCH_LIB_CNTL_WORD1_MS_BYTE 0x0f;
#define TOUCH_LIB_CNTL_WORD1_LS_BYTE 0x03;

	// control register 2 setting
	// Bits [15:14]=01 power save mode; [13:10]=0000 GPIO disabled; [9]=0 ratiometric conversion for greater accuracy;
	// [8:7]=01 4 middle values chosen for averaging filter; [6:5]=10 8 measurements for median filters;
	// These filters may be used for noise suppression. See pg.17 of AD7879/AD7889 spec
	// [4]=0 SW reset disabled; [3:0]=1111 ADC first conversion delay set to 4.096ms
	// To disable median filter, choose [8:5]=0000;  Eg. data[0]=0x40; data[1]=0x0f;

#define TOUCH_LIB_CNTL_WORD2_MS_BYTE 0x40; 
#define TOUCH_LIB_CNTL_WORD2_LS_BYTE 0xcf; 

	// control register 3 setting
	// [15]=1 temperature intr disabled; [14]=1 AUX interrupt disabled; [13]=1 INT but disbled if bit 15 of CR1 id 0 (fig.38)
	// [12]=1 GPIO intr disabled; [11:9]=0000 limit check disabled as not applicable; [7:6]=11 YX measurement enabled
	// [5:0]=000000 other measurements disabled

#define TOUCH_LIB_CNTL_WORD3_MS_BYTE 0xf0;
#define TOUCH_LIB_CNTL_WORD3_LS_BYTE 0xc0;

/** \brief The touch controller initialisation.
 *
 * \param ports The structure containing the touch controller port details.
 */
void touch_lib_init(touch_controller_ports &ports);

/** \brief Get touch coordinates from the result registers of touch controller.
 *
 * \param i2c_ports The structure containing the I2C port details.
 */
{unsigned,unsigned}  get_touch_coordinates(r_i2c &i2c_ports);


#endif /* TOUCH_CONTROLLER_IMPL_H_ */
