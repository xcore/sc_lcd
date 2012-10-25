#ifndef _CHARACTER_DISPLAY_
#define _CHARACTER_DISPLAY_

#include "commonheader.h"


/** \brief To write a text with fonts of pixel size 6 * 6
 *
 * \param client The LCD channel number
 * \param start_row Start row for the text
 * \param start_col Start column for the text
 * \param text_to_type[] The array holding the text to type
 *
 * \note Each text string should end with \0 indicating the end of text
 * \note The user should make sure the text size doesn't exceed the LCD width size. Else the code will have unexpected behaviour
 * \note The user should make sure the character size also doesn't exceed the LCD limits
 * \note The API displays the text in monochrome colour
 * \note The current code supports only A- Z (upper case) and "space"
 */
void write_character(chanend client, unsigned start_row, unsigned start_col,
		             unsigned char ascii_char,graphics_displayoption dispopt,
		             unsigned short int char_size,
		             font_support_list font_support);


void write_text_6x6_bw(chanend client, unsigned start_row, unsigned start_col, char text_to_type[]);
#endif
