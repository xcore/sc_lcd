#ifndef __LCD_DEFINES_H__
#define __LCD_DEFINES_H__

#include "lcd_conf.h"

#include "lcd_defines_AT043TN24V7.h"
#include "lcd_defines_K430WQAV4F.h"
#include "lcd_defines_K70DWN0V1F.h"


extern void lcd_fast_write(unsigned data, int time, out buffered port:32 lcd_rgb, out port lcd_data_enabled);

#ifndef ADD_SUFFIX
#define _ADD_SUFFIX(A,B) A ## _ ## B
#define ADD_SUFFIX(A,B) _ADD_SUFFIX(A,B)
#endif

/**
 * Define this value in lcd_conf.h in your application.
 */
#ifndef LCD_PART_NUMBER
#error LCD_PART_NUMBER not define. Define this value in lcd_conf.h in your application.
#endif

/**
 *  This define is used to represent the width of the LCD panel in pixels.
 */
#ifndef LCD_WIDTH
#define LCD_WIDTH ADD_SUFFIX(LCD_WIDTH, LCD_PART_NUMBER)
#endif

/**
 *  This define is used to represent the height of the LCD panel in pixels.
 */
#ifndef LCD_HEIGHT
#define LCD_HEIGHT ADD_SUFFIX(LCD_HEIGHT, LCD_PART_NUMBER)
#endif

/*
 * Count of bits used to set a pixel's colour.
 */
#ifndef LCD_BITS_PER_PIXEL
#define LCD_BITS_PER_PIXEL ADD_SUFFIX(LCD_BITS_PER_PIXEL, LCD_PART_NUMBER)
#endif

/**
 *  This define is used to represent the width of the LCD panel in words.
 *  The LCD row width is used in terms of words because the SDRAM used along with
 *  the lcd module is accessed as words
 */
#ifdef LCD_ROW_WORDS
#error Do not define LCD_ROW_WORDS. It is derived from LCD_WIDTH and LCD_BITS_PER_PIXEL
#endif
#define LCD_ROW_WORDS (LCD_WIDTH*LCD_BITS_PER_PIXEL/32)

/**
 *  The horizontal front porch timing requirement given in pixel clocks.
 */
#ifndef LCD_HOR_FRONT_PORCH
#define LCD_HOR_FRONT_PORCH ADD_SUFFIX(LCD_HOR_FRONT_PORCH, LCD_PART_NUMBER)
#endif

/**
 *  The horizontal back porch timing requirement given in pixel clocks.
 */
#ifndef LCD_HOR_BACK_PORCH
#define LCD_HOR_BACK_PORCH ADD_SUFFIX(LCD_HOR_BACK_PORCH, LCD_PART_NUMBER)
#endif

/**
 *  The vertical front porch timing requirement given in horizontal time periods.
 */
#ifndef LCD_VERT_FRONT_PORCH
#define LCD_VERT_FRONT_PORCH ADD_SUFFIX(LCD_VERT_FRONT_PORCH, LCD_PART_NUMBER)
#endif

/**
 *  The vertical back porch timing requirement given in horizontal time periods.
 */
#ifndef LCD_VERT_BACK_PORCH
#define LCD_VERT_BACK_PORCH ADD_SUFFIX(LCD_VERT_BACK_PORCH, LCD_PART_NUMBER)
#endif

/**
 * The horizontal pulse width timing requirement given in pixel clocks. 
 * This is the duration that the hsync signal should go low to denote the 
 * start of the horizontal frame. Set to 0 when hsync is not necessary.
 */
#ifndef LCD_HOR_PULSE_WIDTH
#define LCD_HOR_PULSE_WIDTH ADD_SUFFIX(LCD_HOR_PULSE_WIDTH, LCD_PART_NUMBER)
#endif

/**
 * The vertical pulse width timing requirement given in vertical time periods. 
 * This is the duration that the vsync signal should go low to denote the start 
 * of the vertical frame. Set to 0 when vsync is not necessary.
 */
#ifndef LCD_VERT_PULSE_WIDTH
#define LCD_VERT_PULSE_WIDTH ADD_SUFFIX(LCD_VERT_PULSE_WIDTH, LCD_PART_NUMBER)
#endif

/**
 * Fast write is used when the pixel clock is between 25MHz and 50MHz.
 */
#ifndef LCD_FAST_WRITE
#define LCD_FAST_WRITE ADD_SUFFIX(LCD_FAST_WRITE, LCD_PART_NUMBER)
#if LCD_FAST_WRITE == 1
#if LCD_VERT_PULSE_WIDTH > 0
#error Cannot use LCD_FAST_WRITE with LCD_VERT_PULSE_WIDTH > 0
#endif
#if LCD_HOR_PULSE_WIDTH > 0
#error Cannot use LCD_FAST_WRITE with LCD_HOR_PULSE_WIDTH > 0
#endif
#endif
#endif

/** 
 * The total time for HSYNC in terms of pixel clocks.
 */
#define LCD_HSYNC_TIME (LCD_HOR_BACK_PORCH + LCD_WIDTH + LCD_HOR_FRONT_PORCH)

/**
 * The defines FREQ_DIVIDEND and FREQ_DIVISOR are used to calculate the
 * frequency of the clock used for LCD.
 * The frequency configured = (FREQ_DIVIDEND / FREQ_DIVISOR) in MHz
 */
#ifndef LCD_FREQ_DIVIDEND
#define LCD_FREQ_DIVIDEND ADD_SUFFIX(LCD_FREQ_DIVIDEND, LCD_PART_NUMBER)
#endif

/**
 *  
 */
#ifndef LCD_FREQ_DIVISOR
#define LCD_FREQ_DIVISOR ADD_SUFFIX(LCD_FREQ_DIVISOR, LCD_PART_NUMBER)
#endif
#endif
