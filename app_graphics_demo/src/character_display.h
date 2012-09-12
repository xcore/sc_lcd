#ifndef _CHARACTER_DISPLAY_
#define _CHARACTER_DISPLAY_

#include "character_specific_includes.h"

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
void write_text_6x6_bw(chanend client, unsigned start_row, unsigned start_col,
		char text_to_type[]);

/** \brief To write a text with fonts of pixel size 6 * 6
 *
 * \param client The LCD channel number
 * \param start_row Start row for the text
 * \param start_col Start column for the text
 * \param text_to_type[] The array holding the text to type
 *
 * \note Each text string should end with \0 indicating the end of text*
 * \note The user should make sure the text size doesn't exceed the LCD width size. Else the code will have unexpected behaviour
 * \note The user should make sure the character size also doesn't exceed the LCD limits
 * \note The API displays the text in colour specified as the foreground colour
 * \note The current code supports only A- Z (upper case) and "space"
 */
void write_text_6x6_color(chanend client, unsigned start_row, unsigned start_col,
		char text_to_type[]);

/** \brief To write a single character of pixel size 6 * 6
 *
 * \param client The LCD channel number
 * \param start_row Start row for the text
 * \param start_col Start column for the text
 * \param char_buffer[] The character to be displayed. Array holding the character pixel data is passed as parameter
 *
 * \note The user should make sure the start column and start row doesn't exceed the LCD width and height. Else the code will have unexpected behaviour
 * \note The user should make sure the character size also doesn't exceed the LCD limits
 * \note The API displays the character in monochrome colour
 * \note The current code supports only A- Z (upper case) and "space"*
 */
void write_character_6x6_bw(chanend client, unsigned start_row, unsigned start_col,
		             unsigned short char_buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6]);

/** \brief To write a single character of pixel size 6 * 6
 *
 * \param client The LCD channel number
 * \param start_row Start row for the text
 * \param start_col Start column for the text
 * \param char_buffer[] The character to be displayed. Array holding the character pixel data is passed as parameter
 *
 * \note The user should make sure the start column and start row doesn't exceed the LCD width and height. Else the code will have unexpected behaviour
 * \note The user should make sure the character size also doesn't exceed the LCD limits
 * \note The API displays the character in the color mentioned as foreground color
 * \note The current code supports only A- Z (upper case) and "space"
 */
void write_character_6x6_color(chanend client, unsigned start_row, unsigned start_col,
		             unsigned short char_buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6]);

/** \brief To write a text with fonts of pixel size 16 * 16
 *
 * \param client The LCD channel number
 * \param start_row Start row for the text
 * \param start_col Start column for the text
 * \param text_to_type[] The array holding the text to type
 *
 * \note Each text string should end with \0 indicating the end of text
 * \note The user should make sure the text size doesn't exceed the LCD width size. Else the code will have unexpected behaviour
 * \note The user should make sure the character size also doesn't exceed the LCD limits
 * \note The API displays the text in colour specified as the foreground colour
 * \note The current code supports only A- Z (upper case) and "space"
 */
void write_text_16x16_color(chanend client, unsigned start_row, unsigned start_col,
		char text_to_type[]);

#endif
