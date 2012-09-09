#ifndef _GRAPHICS_H
#define _GRAPHICS_H

#include "character_specific_includes.h"

/* The width of the image to be displayed in pixels */
#define IMAGE_HEIGHT 40
#define IMAGE_WIDTH 44

/** \brief The function sets te background color for the LCD screen
 *
 * \param client The LCD channel number
 * \param color The color to be set for the background color
 *
 * \note At start-up the graphics initialization sets the color to black
 */
void set_background_color(chanend client, unsigned short color);

/** \brief The function sets the foreground color in the LCD screen
 *
 * \param client The LCD channel number
 * \param color The color to be set for the foreground color
 *
 * \note At start-up the graphics initialization sets the color to white
 * \note The text written on the screen takes the foreground color
 */
void set_foreground_color(unsigned short color);

/** \brief The function initializes the graphics screen - includes setting the background and foreground color
 *
 * \param client The LCD channel number
 *
 */
void set_graphics_frame(chanend client);

/** \brief The function reads the foreground colour set
 *
 * \return The foreground colour set
 */
unsigned short get_foreground_color(void);

/** \brief The function reads the background colour set
 *
 * \return The background colour set
 */
unsigned short get_background_color(void);

/** \brief The display an image on the screen. The image will be displayed in monochrome colour
 *
 * \param client The LCD channel number
 * \param start_row The row to start the image
 * \param start_col The column to start the image. Should be in multiples of 2 as the LCD write is done in words and not in pixels
 * \param height Height of the image in rows
 * \param width Width of the image in pixels
 *
 * \note The 0s in the image structure is displayed in BLACK and the 1s in the image structure is displayed in WHITE
 */
void put_image_BW(chanend client, unsigned start_row, unsigned start_col,
		          unsigned height, unsigned width);


/* RGB 565 colour defines */
#define LCD_565_RED           0x001F
#define LCD_565_BLUE	      0xf800
#define LCD_565_GREEN	      0x07e0
#define LCD_565_BLACK	      0x0000
#define LCD_565_TEAL	      0xFFE0
#define LCD_565_YELLOW	      0x07ff
#define LCD_565_WHITE	      0xffff
#define LCD_565_GREY0	      0xe79c
#define LCD_565_GREY1	      0xc718
#define LCD_565_GREY2	      0x8410
#define LCD_565_GREY3	      0x2104

#endif
