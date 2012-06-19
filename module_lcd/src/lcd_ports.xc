#include <platform.h>

/* Configure the port details as per the hardware used*/
/* The user should include the .xn file according to the hardware used */

/* The clock line */
out port p_lcd_clk = XS1_PORT_1O;

/* The LCD signal lines */
out port p_lcd_tim = XS1_PORT_4F;

/* 32 bit data port */
out port p_lcd_rgb = XS1_PORT_32A;

/* Clock block used for LCD clock */
clock clk_lcd = XS1_CLKBLK_3;
