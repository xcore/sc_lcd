#ifndef __LCD_DEFINES_H__
#define __LCD_DEFINES_H__

#include "lcd_conf.h"

#include "lcd_defines_AT043TN24.h"
#include "lcd_defines_K430WQAV4F.h"

#ifndef ADD_SUFFIX
#define _ADD_SUFFIX(A,B) A ## _ ## B
#define ADD_SUFFIX(A,B) _ADD_SUFFIX(A,B)
#endif

#ifndef LCD_PART_NUMBER
#error LCD_PART_NUMBER not define. Define this value in lcd_conf.h in your application.
#endif

/* Defines for LCD panel */

/*
 *  This define is used to represent the width of the LCD panel in pixels
 */
#ifndef LCD_WIDTH
#define LCD_WIDTH ADD_SUFFIX(LCD_WIDTH, LCD_PART_NUMBER)
#endif
/*
 *  This define is used to represent the height of the LCD panel in terms of lines
 */
#ifndef LCD_HEIGHT
#define LCD_HEIGHT ADD_SUFFIX(LCD_HEIGHT, LCD_PART_NUMBER)
#endif


#ifndef LCD_BITS_PER_PIXEL
#define LCD_BITS_PER_PIXEL ADD_SUFFIX(LCD_BITS_PER_PIXEL, LCD_PART_NUMBER)
#endif

/*
 *  This define is used to represent the width of the LCD panel in words
 *  The LCD row width is used in terms of words because the SDRAM used along with
 *  the lcd module is accessed as words
 */
#define LCD_ROW_WORDS (LCD_WIDTH*LCD_BITS_PER_PIXEL/32)

//given in data clocks
#ifndef LCD_HOR_FRONT_PORCH
#define LCD_HOR_FRONT_PORCH ADD_SUFFIX(LCD_HOR_FRONT_PORCH, LCD_PART_NUMBER)
#endif

//given in data clocks
#ifndef LCD_HOR_BACK_PORCH
#define LCD_HOR_BACK_PORCH ADD_SUFFIX(LCD_HOR_BACK_PORCH, LCD_PART_NUMBER)
#endif

//given in data clocks
#ifndef LCD_VERT_FRONT_PORCH
#define LCD_VERT_FRONT_PORCH ADD_SUFFIX(LCD_VERT_FRONT_PORCH, LCD_PART_NUMBER)
#endif

//given in data clocks
#ifndef LCD_VERT_BACK_PORCH
#define LCD_VERT_BACK_PORCH ADD_SUFFIX(LCD_VERT_BACK_PORCH, LCD_PART_NUMBER)
#endif

//given in data clocks
#ifndef LCD_HOR_PULSE_WIDTH
#define LCD_HOR_PULSE_WIDTH ADD_SUFFIX(LCD_HOR_PULSE_WIDTH, LCD_PART_NUMBER)
#endif

//given in horizontals
#ifndef LCD_VERT_PULSE_WIDTH
#define LCD_VERT_PULSE_WIDTH ADD_SUFFIX(LCD_VERT_PULSE_WIDTH, LCD_PART_NUMBER)
#endif

/* The total time for HSYNC in terms of clock.
 */
#define LCD_HSYNC_TIME (LCD_HOR_BACK_PORCH + LCD_WIDTH + LCD_HOR_FRONT_PORCH)

/* The defines FREQ_DIVIDEND and FREQ_DIVISOR are used to calculate the
 * frequency of the clock used for LCD.
 * The frequency configured = (FREQ_DIVIDEND / FREQ_DIVISOR) in MHz
 */
#ifndef LCD_FREQ_DIVIDEND
#define LCD_FREQ_DIVIDEND ADD_SUFFIX(LCD_FREQ_DIVIDEND, LCD_PART_NUMBER)
#endif

#ifndef LCD_FREQ_DIVISOR
#define LCD_FREQ_DIVISOR ADD_SUFFIX(LCD_FREQ_DIVISOR, LCD_PART_NUMBER)
#endif
#endif
