#ifndef _CHARACTER_SPECIFIC_INCLUDES
#define _CHARACTER_SPECIFIC_INCLUDES

/** Enum defining the text feature
 */
typedef enum
{
	TEXT_NONE,
	TEXT_BOLD,
	TEXT_ITALIC,
	TEXT_BOLDITALIC
}text_feature;

/************************* 6 * 6 pixel ********************************/
/* The size of look up table */
#define LOOKUP_TABLE_SIZE_6x6 27
/* Height of the 6 * 6 pixel */
#define ALPHA_HEIGHT_6x6 6
/* Width of the 6 * 6 pixel */
#define ALPHA_WIDTH_6x6 6
/**********************************************************************/

/************************* 16 * 16 pixel ******************************/
/* The size of look up table */
#define LOOKUP_TABLE_SIZE_16x16 27
/* Height of the 16 * 16 pixel */
#define ALPHA_HEIGHT_16x16 16
/* Width of the 16 * 16 pixel */
#define ALPHA_WIDTH_16x16 16

#define SIZE_OF_BYTE 8
/* The number of bytes required to store each row of 16 * 16 pixel
 * when bit encoding is done */
#define WIDTH_16x16 (ALPHA_WIDTH_16x16/SIZE_OF_BYTE)
/**********************************************************************/

/** \brief Gets the character data from the look up table for the specified character (size of 6 * 6 pixels)
 *
 * \param alpha The character whose pixel data is required
 * \param char_buffer[][] The character buffer to hold the pixel data for the mentioned character
 *
 */
void get_character_6x6(char alpha, unsigned short char_buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6]);

/** \brief Gets the character data from the look up table for the specified character (size of 6 * 6 pixels)
 *
 * \param alpha The character whose pixel data is required
 * \param char_buffer[][] The character buffer to hold the pixel data for the mentioned character
 *
 */
void get_character_16x16(char alpha, unsigned short char_buffer[ALPHA_HEIGHT_16x16][ALPHA_WIDTH_16x16]);

/** \brief To set the feature for the text
 *
 * \param txt_ft The text feature (defined as enum text_feature)
 *
 * \note The current code supports only None and Italics. Bold and Bold Italics has to be implemented
 */
void set_text_feature(text_feature txt_ft);

/** \brief The read back the feature set for text
 *
 * \return The feature set (defined as enum text_feature)
 *
 */
text_feature get_text_feature(void);

/** \brief To set the space between characters in a text
 *
 * \param space space between the characters
 * \note The size should be mentioned as multiples of 2 (as the LCD is updated as words)
 */
void set_text_space(unsigned short space);

/** \brief Finds the color in monochrome */
#define FindColor_Monochrome(a) a == 1? LCD_565_WHITE: LCD_565_BLACK

/** \brief Finds the color to be displayed in case of RGB color */
#define FindColor(a, bgcolor, fgcolor)  a == 1? fgcolor: bgcolor

/** \brief Creates a word from 2 16 bit values */
#define CreateWord(MSB,LSB) (unsigned)((unsigned)LSB | (unsigned)((unsigned)MSB << 16))

#endif
