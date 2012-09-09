#ifndef __LCD_DEFINES_H__
#define __LCD_DEFINES_H__

/* This file is included when the target selected is TM043NDH02
 * This LCD panel is supplied by SHANGHAI TIANMA MICRO-ELECTRONICS corporation
 * This is a 272 * 480 LCD panel with no memory buffer  */

#ifdef __lcd_conf_h_exists__
#include "lcd_conf.h"
#endif

/* Structure to hold the port details */

struct lcd_ports_struct
{
	/* The clock line */
	out port p_lcd_clk;

	/* The LCD signal lines */
	out port p_lcd_tim;

	/* 32 bit data port */
	out port p_lcd_rgb;

	/* Clock block used for LCD clock */
	clock clk_lcd;
};

typedef struct lcd_ports_struct lcd_ports;

/*
 *  This define is used to represent the width of the LCD panel in pixels
 */
#define LCD_WIDTH (480)

/*
 *  This define is used to represent the height of the LCD panel in terms of lines
 */
#define LCD_HEIGHT (272)


#define LCD_BITS_PER_PIXEL (16)
/*
 *  This define is used to represent the width of the LCD panel in words
 *  The LCD row width is used in terms of words because the SDRAM used along with
 *  the lcd module is accessed as words
 */
#define LCD_ROW_WORDS ((LCD_WIDTH*LCD_BITS_PER_PIXEL)/32)

/*
 * The horizontal porch timings are very important to decide the LCD refresh
 * The horizontal timings include - horizontal pulse period + horizontal front porch
 * + horizontal back porch
 * While giving the timing, the user should provide the sum of the pulse period and
 * porch periods
 * example: Horizontal pulse = 41 clk, horizontal front porch = 2 clk,
 * horizontal back porch = 2 clk
 * Total porch timings = 41 + 2 + 2 = 45 clk
 */
#ifndef LCD_HOR_PORCH
#define LCD_HOR_PORCH  (45)
#endif
/* The total time for HSYNC in terms of clock.
 * HSYNC is calculated as sum of Horizontal Porch + LCD Width
 */
#define LCD_HSYNC_TIME (LCD_WIDTH + LCD_HOR_PORCH)

/* The vertical porch timings are very important to decide the LCD refresh
 * The vertical timings include - vertical pulse period + vertical front porch
 * + vertical back porch (optinal)
 * The vertical timings is given in terms of the horizontal timing
 * To calculate the vertical timings
 * Vert_porch = HSYNC_TIME * (Vertical pulse period + vertical front porch +
 * Optional Vertical back porch)
 */
#ifndef LCD_VERT_PORCH
#define LCD_VERT_PORCH (LCD_HSYNC_TIME * 5)
#endif
/* The defines FREQ_DIVIDEND and FREQ_DIVISOR are used to calculate the
 * frequency of the clock used for LCD.
 * The frequency configured = (FREQ_DIVIDEND / FREQ_DIVISOR) in MHz
 */
#ifndef LCD_FREQ_DIVIDEND
#define LCD_FREQ_DIVIDEND 100
#endif

#ifndef LCD_FREQ_DIVISOR
#define LCD_FREQ_DIVISOR 8
#endif
#endif
