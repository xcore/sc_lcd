#include <platform.h>
#include "CommonHeader.h"
#include "graphics.h"
#include "lcd.h"

extern unsigned lcd_buffer[2][LCD_ROW_WORDS];
extern unsigned index;

void _fn_error(char errstring[])
{

}

#define ROWS_OFFSET 0
#define PIXEL_OFFSET 1
#define BYTE_OFFSET 2

#ifdef _SIZE_OPTIMIZED_LESS_ROM

extern unsigned int _getoffset(unsigned f_index, unsigned char_index);
extern unsigned char _getcharvalue(unsigned f_index, unsigned char_index);

void write_character(chanend client, unsigned start_row, unsigned start_col,
		             unsigned char ascii_char,graphics_displayoption dispopt,
		             unsigned short int char_size,
		             font_support_list font_support)
{
	unsigned buffer_col = 0;
	unsigned buffer_row = 0;
	unsigned col, row;
	unsigned short background;
	unsigned short foreground;
	unsigned short skip_size;
	unsigned char f_index;
    unsigned int char_offset = 0;

    f_index = font_support;

	if (start_row >= (LCD_HEIGHT - char_size))
	{
		_fn_error("Exceeds row size");
	}
	if (start_col >= (LCD_WIDTH - char_size))
	{
		_fn_error("Exceeds column size");
	}

	background = get_background_color();
	foreground = get_foreground_color();

	/* From row 0 to start row of the character, fill the screen with background colour */
	fill_rows(client, 0, start_row, 0, LCD_ROW_WORDS, background);

	/* Update the character data for the rows from start row to start row + Height of the
	 * pixel
	 */
    char_offset = _getoffset(f_index, ascii_char);

    /* A glyph has variable size. The size of the glyph will be < or = to the char size.
     * If the size is less than the character size, the rows which are empty should be filled
     * with the background color
     * The size of the character in the glyph always starts from the base to top
     * In case the character size is lesser, it implies that the top rows should be filled with the
     * background color till a valid row of the glyph is reached
     */
    skip_size = char_size - _getcharvalue(f_index, char_offset);

    row = start_row;
    while(skip_size != 0)
    {
    	fill_rows(client, row, row, 0, LCD_ROW_WORDS, background);
    	skip_size--;
    	row++;
    }
    /* Now the character start is reached */
	if (dispopt == DISPLAY_MONOCHROME)
	{
		for(; row < start_row + char_size; row++)
		{
			for (col = 0; col < start_col; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			for (; col < (_getcharvalue(f_index, char_offset + BYTE_OFFSET) * 8)/2; )
			{
				signed int shift = 7;
				unsigned and_with = 0x01;
				unsigned short color1;
				unsigned short color2;
				static unsigned short increment_val = 0;
				unsigned byte_value;
				byte_value = _getcharvalue(f_index, char_offset + BYTE_OFFSET + increment_val);
				while(shift >= 0)
				{
				  color1 = FindColor_Monochrome((byte_value >> shift) & and_with);
				  shift--;
				  color2 = FindColor_Monochrome((byte_value >> shift) & and_with);
				  shift--;

				  lcd_buffer[index][col] = CreateWord(background, background);
				  col++;
				}
				increment_val++;
			}
			for(; col < LCD_ROW_WORDS; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}

			lcd_update(client, lcd_buffer[index]);

			// The value of index switches between 1 and 0
		    index = (index > 0)? 0: 1;
		}
	}
	else
	{
		for(; row < start_row + char_size; row++)
		{
			for (col = 0; col < start_col; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			for (; col < (_getcharvalue(f_index, char_offset + BYTE_OFFSET) * 8)/2; )
			{
				signed int shift = 7;
				unsigned and_with = 0x01;
				unsigned short color1;
				unsigned short color2;
				static unsigned short increment_val = 0;
				unsigned byte_value;
				byte_value = _getcharvalue(f_index, char_offset + BYTE_OFFSET + increment_val);
				while(shift >= 0)
				{
				  color1 = FindColor((byte_value >> shift) & and_with, background, foreground);
				  shift--;
				  color2 = FindColor((byte_value >> shift) & and_with, background, foreground);
				  shift--;

				  lcd_buffer[index][col] = CreateWord(background, background);
				  col++;
				}
				increment_val++;
			}
			for(; col < LCD_ROW_WORDS; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}

			lcd_update(client, lcd_buffer[index]);
			// The value of index switches between 1 and 0
		    index = (index > 0)? 0: 1;
		}
	} // end of color display option

	/* Fill the rest of the rows with the background colour */
	fill_rows(client, row, LCD_HEIGHT, 0, LCD_ROW_WORDS, background);
}
#elif defined(_SPEED_OPTIMIZED_LESS_ROM)

void update_character(chanend client, unsigned start_row, unsigned start_col,
                      unsigned char ascii_char, graphics_displayoption dispopt,
                      unsigned short int char_size,
                      const unsigned char ascii_table[], const unsigned int offset_table[])
{
	unsigned col, row;
	unsigned short background;
	unsigned short foreground;
	unsigned short skip_size;
	unsigned int char_offset = 0;

	background = get_background_color();
	foreground = get_foreground_color();

	/* From row 0 to start row of the character, fill the screen with background colour */
	fill_rows(client, 0, start_row, 0, LCD_ROW_WORDS, background);

	/* Update the character data for the rows from start row to start row + Height of the
	 * pixel
	 */
	char_offset = offset_table[ascii_char];

	/* A glyph has variable size. The size of the glyph will be < or = to the char size.
	 * If the size is less than the character size, the rows which are empty should be filled
	 * with the background color
	 * The size of the character in the glyph always starts from the base to top
	 * In case the character size is lesser, it implies that the top rows should be filled with the
	 * background color till a valid row of the glyph is reached
	 */
	skip_size = char_size - ascii_table[char_offset];

	row = start_row;
	while(skip_size != 0)
	{
		fill_rows(client, row, row, 0, LCD_ROW_WORDS, background);
    	skip_size--;
    	row++;
    }
    /* Now the character start is reached */
	if (dispopt == DISPLAY_MONOCHROME)
	{
		for(; row < start_row + char_size; row++)
		{
			for (col = 0; col < start_col; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}

			for (; col < (ascii_table[char_offset + BYTE_OFFSET] * 8)/2; )
			{
				signed int shift = 7;
				unsigned and_with = 0x01;
				unsigned short color1;
				unsigned short color2;
				static unsigned short increment_val = 0;
				unsigned byte_value;
				byte_value = ascii_table[char_offset + BYTE_OFFSET + increment_val];
				while(shift >= 0)
				{
				  color1 = FindColor_Monochrome((byte_value >> shift) & and_with);
				  shift--;
				  color2 = FindColor_Monochrome((byte_value >> shift) & and_with);
				  shift--;
				  lcd_buffer[index][col] = CreateWord(background, background);
				  col++;
				}
				increment_val++;
			}
			for(; col < LCD_ROW_WORDS; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			lcd_update(client, lcd_buffer[index]);
			// The value of index switches between 1 and 0
		    index = (index > 0)? 0: 1;
		}
	}
	else
	{
		for(; row < start_row + char_size; row++)
		{
			for (col = 0; col < start_col; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}

			for (; col < (ascii_table[char_offset + BYTE_OFFSET] * 8)/2; )
			{
				signed int shift = 7;
				unsigned and_with = 0x01;
				unsigned short color1;
				unsigned short color2;
				static unsigned short increment_val = 0;
				unsigned byte_value;
				byte_value = ascii_table[char_offset + BYTE_OFFSET + increment_val];
				while(shift >= 0)
				{
				  color1 = FindColor((byte_value >> shift) & and_with, background, foreground);
				  shift--;
				  color2 = FindColor((byte_value >> shift) & and_with, background, foreground);
				  shift--;
				  lcd_buffer[index][col] = CreateWord(background, background);
				  col++;
				}
				increment_val++;
			}
			for(; col < LCD_ROW_WORDS; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			lcd_update(client, lcd_buffer[index]);
			// The value of index switches between 1 and 0
		    index = (index > 0)? 0: 1;
		}
	} // end of color display option

    /* Fill the rest of the rows with the background colour */
    fill_rows(client, row, LCD_HEIGHT, 0, LCD_ROW_WORDS, background);
}

/* since there is no pointer support in the xc files, the font tables cannot be
 * directly accessed as pointers.
 * Hence the user is forced to write switch conditions for each font type
 * This process uses a very high amount of memory, but is optimized for speed
 */
void write_character(chanend client, unsigned start_row, unsigned start_col,
		             unsigned char ascii_char,graphics_displayoption dispopt,
		             unsigned short int char_size,
		             font_support_list font_support)
{

	if (start_row >= (LCD_HEIGHT - char_size))
	{
		_fn_error("Exceeds row size");
	}
	if (start_col >= (LCD_WIDTH - char_size))
	{
		_fn_error("Exceeds column size");
	}

	/* The switch case to decide which font table to be used
	 * This should be extended as the font types are extended
	 * refer to files commonheader.h and character_specific_includes which should be
	 * extended along with the added font support
	 */
	switch(font_support)
	{

	case 0:
		update_character(client, start_row, start_col, ascii_char, dispopt,
	                      char_size, FONT0_TABLENAME, FONT0_OFFSETTABLE);
		break;
	case 1:
		update_character(client, start_row, start_col, ascii_char, dispopt,
			                      char_size, FONT1_TABLENAME, FONT1_OFFSETTABLE);
	    break;
	case 2:
		update_character(client, start_row, start_col, ascii_char, dispopt,
		                         char_size, FONT2_TABLENAME, FONT2_OFFSETTABLE);
	    break;
	case 3:
		update_character(client, start_row, start_col, ascii_char, dispopt,
	                      char_size, FONT3_TABLENAME, FONT3_OFFSETTABLE);
		break;
	case 4:
		update_character(client, start_row, start_col, ascii_char, dispopt,
			                      char_size, FONT4_TABLENAME, FONT4_OFFSETTABLE);
	    break;
	case 5:
		update_character(client, start_row, start_col, ascii_char, dispopt,
		                         char_size, FONT5_TABLENAME, FONT5_OFFSETTABLE);
	    break;
	}

}

#elif defined(_SPEED_OPTIMIZED_EXCESS_ROM)
void update_character(chanend client, unsigned start_row, unsigned start_col,
                      unsigned char ascii_char, graphics_displayoption dispopt,
                      unsigned short int char_size,
                      const unsigned char ascii_table[], const unsigned int offset_table[])
{
	unsigned col, row;
	unsigned short background;
	unsigned short foreground;
	unsigned short skip_size;
	unsigned int char_offset = 0;
	unsigned short color1, color2;


	background = get_background_color();
	foreground = get_foreground_color();

	/* From row 0 to start row of the character, fill the screen with background colour */
	fill_rows(client, 0, start_row, 0, LCD_ROW_WORDS, background);

	/* Update the character data for the rows from start row to start row + Height of the
	 * pixel
	 */
	char_offset = offset_table[ascii_char];

	/* A glyph has variable size. The size of the glyph will be < or = to the char size.
	 * If the size is less than the character size, the rows which are empty should be filled
	 * with the background color
	 * The size of the character in the glyph always starts from the base to top
	 * In case the character size is lesser, it implies that the top rows should be filled with the
	 * background color till a valid row of the glyph is reached
	 */
	skip_size = char_size - ascii_table[char_offset];

	row = start_row;
	while(skip_size != 0)
	{
		fill_rows(client, row, row, 0, LCD_ROW_WORDS, background);
    	skip_size--;
    	row++;
    }
    /* Now the character start is reached */
	if (dispopt == DISPLAY_MONOCHROME)
	{
		for(; row < start_row + char_size; row++)
		{
			for (col = 0; col < start_col; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			for (; col < (ascii_table[char_offset + BYTE_OFFSET])/2; )
			{

				static unsigned int increment_val = 0;
				color1 = ascii_table[char_offset + BYTE_OFFSET + increment_val++] > 0?
						             LCD_565_WHITE: LCD_565_BLACK;
                color2 = ascii_table[char_offset + BYTE_OFFSET + increment_val++] > 0?
			             LCD_565_WHITE: LCD_565_BLACK;
				lcd_buffer[index][col] = CreateWord(background, background);
				col++;

			}
			for(; col < LCD_ROW_WORDS; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			lcd_update(client, lcd_buffer[index]);
			// The value of index switches between 1 and 0
		    index = (index > 0)? 0: 1;
		}
	}
	else
	{
		for(; row < start_row + char_size; row++)
		{
			for (col = 0; col < start_col; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			for (; col < (ascii_table[char_offset + BYTE_OFFSET])/2; )
			{
				static unsigned int increment_val = 0;

				color1 = ascii_table[char_offset + BYTE_OFFSET + increment_val++] > 0?
						             foreground: background;
                color2 = ascii_table[char_offset + BYTE_OFFSET + increment_val++] > 0?
                		             foreground: background;
				lcd_buffer[index][col] = CreateWord(background, background);
				col++;

			}
			for(; col < LCD_ROW_WORDS; col++)
			{
				lcd_buffer[index][col] = CreateWord(background, background);
			}
			lcd_update(client, lcd_buffer[index]);
			// The value of index switches between 1 and 0
		    index = (index > 0)? 0: 1;
		}
	} // end of color display option

    /* Fill the rest of the rows with the background colour */
    fill_rows(client, row, LCD_HEIGHT, 0, LCD_ROW_WORDS, background);
}

/* since there is no pointer support in the xc files, the font tables cannot be
 * directly accessed as pointers.
 * Hence the user is forced to write switch conditions for each font type
 * This process uses a very high amount of memory, but is optimized for speed
 */
void write_character(chanend client, unsigned start_row, unsigned start_col,
		             unsigned char ascii_char,graphics_displayoption dispopt,
		             unsigned short int char_size,
		             font_support_list font_support)
{

	if (start_row >= (LCD_HEIGHT - char_size))
	{
		_fn_error("Exceeds row size");
	}
	if (start_col >= (LCD_WIDTH - char_size))
	{
		_fn_error("Exceeds column size");
	}

	/* The switch case to decide which font table to be used
	 * This should be extended as the font types are extended
	 * refer to files commonheader.h and character_specific_includes which should be
	 * extended along with the added font support
	 */
	switch(font_support)
	{

	case 0:
		update_character(client, start_row, start_col, ascii_char, dispopt,
	                      char_size, FONT0_TABLENAME, FONT0_OFFSETTABLE);
		break;
	case 1:
		update_character(client, start_row, start_col, ascii_char, dispopt,
			                      char_size, FONT1_TABLENAME, FONT1_OFFSETTABLE);
	    break;
#ifndef _SPEED_OPTIMIZED_EXCESS_ROM
	case 2:
		update_character(client, start_row, start_col, ascii_char, dispopt,
		                         char_size, FONT2_TABLENAME, FONT2_OFFSETTABLE);
	    break;
	case 3:
		update_character(client, start_row, start_col, ascii_char, dispopt,
	                      char_size, FONT3_TABLENAME, FONT3_OFFSETTABLE);
		break;
	case 4:
		update_character(client, start_row, start_col, ascii_char, dispopt,
			                      char_size, FONT4_TABLENAME, FONT4_OFFSETTABLE);
	    break;
	case 5:
		update_character(client, start_row, start_col, ascii_char, dispopt,
		                         char_size, FONT5_TABLENAME, FONT5_OFFSETTABLE);
	    break;
#endif
	}

}


#endif


void write_text_6x6_bw(chanend client, unsigned start_row, unsigned start_col, char text_to_type[])
{
}




