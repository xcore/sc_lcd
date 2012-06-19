#ifndef __LCD_DEFINES_H__
#define __LCD_DEFINES_H__

/* Defines for LCD panel */

/*
 *  This define is used to represent the width of the LCD panel in pixels
 *  User configuration required: YES
 */
#define LCD_WIDTH 480

/*
 *  This define is used to represent the height of the LCD panel in terms of lines
 *  User configuration required: YES
 */
#define LCD_HEIGHT 272

/*
 *  This define is used to represent the width of the LCD panel in words
 *  The LCD row width is used in terms of words because the SDRAM used along with
 *  the lcd module is accessed as words
 *  User configuration required: YES (if the SDRAM word size changes)
 */
#define LCD_ROW_WORDS (LCD_WIDTH/2)

/*
 * The horizontal porch timings are very important to decide the LCD refresh
 * The horizontal timings include - horizontal pulse period + horizontal front porch
 * + horizontal back porch
 * While giving the timing, the user should provide the sum of the pulse period and
 * porch periods
 * example: Horizontal pulse = 41 clk, horizontal front porch = 2 clk,
 * horizontal back porch = 2 clk
 * Total porch timings = 41 + 2 + 2 = 45 clk
 * User configuration required: YES depending on the LCD used
 */
#define HOR_PORCH  (45)

/* The total time for HSYNC in terms of clock.
 * HSYNC is calculated as sum of Horizontal Porch + LCD Width
 * User configuration required: YES (if the HYSNC time calculation varies
 * depending on the LCD used)
 */
#define HSYNC_TIME LCD_WIDTH + HOR_PORCH

/* The vertical porch timings are very important to decide the LCD refresh
 * The vertical timings include - vertical pulse period + vertical front porch
 * + vertical back porch (optinal)
 * The vertical timings is given in terms of the horizontal timing
 * To calculate the vertical timings
 * Vert_porch = HSYNC_TIME * (Vertical pulse period + vertical front porch +
 * Optional Vertical back porch)
 * User configuration required: YES depending on the LCD used
 */
#define VERT_PORCH HSYNC_TIME * (10 + 2 + 2)

/* The defines FREQ_DIVIDEND and FREQ_DIVISOR are used to calculate the
 * frequency of the clock used for LCD.
 * The frequency configured = (FREQ_DIVIDEND / FREQ_DIVISOR) in MHz
 * User configuration required: YES depending on the LCD used
 */
#define FREQ_DIVIDEND 100
#define FREQ_DIVISOR 8

#endif
