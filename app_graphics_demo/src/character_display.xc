#include <platform.h>
#include "character_display.h"
#include "graphics.h"
#include "lcd.h"


extern unsigned lcd_buffer[2][LCD_ROW_WORDS];
extern unsigned index;

/* variable storing the space value between characters when writing text */
unsigned short text_space = 0;

void _fn_error(char errstring[])
{

}

void set_text_space(unsigned short space)
{
	text_space = space;
}

void write_character_6x6_bw(chanend client, unsigned start_row, unsigned start_col,
		             unsigned short char_buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6])
{
	unsigned buffer_col = 0;
	unsigned buffer_row = 0;
	unsigned col, row;
	unsigned short buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6];
	unsigned short background;

	if (start_row > (LCD_HEIGHT - ALPHA_HEIGHT_6x6))
	{
		_fn_error("Exceeds row size");
	}
	if (start_col > (LCD_WIDTH - ALPHA_WIDTH_6x6))
	{
		_fn_error("Exceeds column size");
	}

	background = get_background_color();

	for (buffer_row = 0; buffer_row < ALPHA_HEIGHT_6x6; buffer_row++)
	{
		for (buffer_col = 0; buffer_col < ALPHA_WIDTH_6x6; buffer_col++)
		{
		    if (char_buffer[buffer_row][buffer_col] == 0)
		    	buffer[buffer_row][buffer_col] = LCD_565_BLACK;
		    else
		    	buffer[buffer_row][buffer_col] = LCD_565_WHITE;
		}
	}

	/* From row 0 to start row of the character, fill the screen with background colour */
	for (row = 0; row < start_row; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
	buffer_row = 0;
	buffer_col = 0;

	/* Update the character data for the rows from start row to start row + Height of the
	 * pixel
	 */
	for (row = start_row; row < (start_row + ALPHA_HEIGHT_6x6); row++, buffer_row++)
	{

		for (col = start_col; col < (start_col + (ALPHA_WIDTH_6x6/2));
				              col++, buffer_col+=2 )
		{
			lcd_buffer[index][col] = buffer[buffer_row][buffer_col] |
					      ((unsigned)buffer[buffer_row][buffer_col + 1] << 16);
		}

		buffer_col = 0;
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
	/* Fill the rest of the rows with the background colour */
	for (;row < LCD_HEIGHT; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
		index = (index > 0)? 0: 1;
	}
}

/* To write a 6 * 6 pixel character in color */
void write_character_6x6_color(chanend client, unsigned start_row, unsigned start_col,
		             unsigned short char_buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6])
{
	unsigned buffer_col = 0;
	unsigned buffer_row = 0;
	unsigned col, row;
	unsigned short buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6];
	unsigned short background;
	unsigned short foreground;

	if (start_row > (LCD_HEIGHT - ALPHA_HEIGHT_6x6))
	{
		_fn_error("Exceeds row size");
	}
	if (start_col > (LCD_WIDTH - ALPHA_WIDTH_6x6))
	{
		_fn_error("Exceeds column size");
	}

	background = get_background_color();
	foreground = get_foreground_color();

	/* get the pixel data for the character.
	 * Where the pixel value is 1, the pixel data is updated with the foreground color
	 * Where the pixel value is 0, the pixel data is updated with the background color
	 */
	for (buffer_row = 0; buffer_row < ALPHA_HEIGHT_6x6; buffer_row++)
	{
		for (buffer_col = 0; buffer_col < ALPHA_WIDTH_6x6; buffer_col++)
		{
		    if (char_buffer[buffer_row][buffer_col] == 0)
		    	buffer[buffer_row][buffer_col] = background;
		    else
		    	buffer[buffer_row][buffer_col] = foreground;
		}
	}

	/* from row 0 to start row of the character, fill the rows with the background color */
	for (row = 0; row < start_row; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
	buffer_row = 0;
	buffer_col = 0;

	/* for the rows from start row till start row + height of the pixel update with the character
	 * data
	 */
	for (row = start_row; row < (start_row + ALPHA_HEIGHT_6x6); row++, buffer_row++)
	{

		for (col = start_col; col < (start_col + (ALPHA_WIDTH_6x6/2));
				              col++, buffer_col+=2 )
		{
			lcd_buffer[index][col] = buffer[buffer_row][buffer_col] |
					      ((unsigned)buffer[buffer_row][buffer_col + 1] << 16);
		}

		buffer_col = 0;
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
	/* for rest of the rows, fill with the background colour */
	for (;row < LCD_HEIGHT; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);
	}
}


void write_text_6x6_bw(chanend client, unsigned start_row, unsigned start_col, char text_to_type[])
{
	unsigned temp_buffer[ALPHA_HEIGHT_6x6][LCD_ROW_WORDS];
	unsigned buffer_col = 0;
	unsigned buffer_row = 0;
	unsigned col, row;
	unsigned loop = 0;
	unsigned temp_start_col;
	unsigned short char_buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6] = {{0,0,0,0,0,0}};
	unsigned short background;

    background = get_background_color();

	temp_start_col = start_col;

	/* the functions first creates the buffer of size 6 rows and updates the text to the
	 * buffer. This intermediate buffer is then updated to the LCD screen
	 */
	for (row = 0; row < ALPHA_HEIGHT_6x6; row++)
	{
		for (col = 0; col < start_col; col++)
		{
           temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
		}
	}
	/* The loop is iterated till it encounter a '\0' which indicates end of text  */
	while (text_to_type[loop] != '\0')
	{
		/* get the character pixel data from the lookup table */
		get_character_6x6(text_to_type[loop], char_buffer);
		for (buffer_row = 0; buffer_row < ALPHA_HEIGHT_6x6; buffer_row++)
		{
		   for (buffer_col = 0; buffer_col < ALPHA_WIDTH_6x6; buffer_col++)
		   {
		       /* Since it is a monochrome display
		        * Pixel value with 1 is updated with WHITE colour
		        * Pixel value with 0 is updated with BLACK colour
		        */
			   if (char_buffer[buffer_row][buffer_col] == 0)
		          	char_buffer[buffer_row][buffer_col] = LCD_565_BLACK;
		       else
		    	   	char_buffer[buffer_row][buffer_col] = LCD_565_WHITE;
		   }
	   	}
		buffer_row = 0; buffer_col = 0;

		/* Update the temporary buffer with the character data */
		for (row = 0; row < ALPHA_HEIGHT_6x6; row++)
		{
			buffer_col = 0;
			for (col = temp_start_col; col < (temp_start_col + (ALPHA_WIDTH_6x6/2));
						              col++, buffer_col+=2 )
		    {
				temp_buffer[row][col] = char_buffer[row][buffer_col] |
						      ((unsigned)char_buffer[row][buffer_col + 1] << 16);
		    }
			buffer_col = 0;
			for (; col < (temp_start_col + (ALPHA_WIDTH_6x6/2) + (text_space/2));
							              col++, buffer_col+=2 )
			{
				temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
			}
		} /* end of loop for the rows in the temporary buffer */

		/* Provide space between the characters based on the text space value
		 * set using the function set_text_space
		 */
		temp_start_col += (ALPHA_WIDTH_6x6/2);
		temp_start_col += (text_space/2);
		loop++;
	} /* End of while loop for each character in the text */
	temp_start_col = col;

	for (row = 0; row < ALPHA_HEIGHT_6x6; row++)
	{
		for (col = temp_start_col; col < LCD_ROW_WORDS; col++)
		{
           temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
		}
	}
	/* Now sending to LCD frame */
	/* for rows from 0 to start row of the text, update with the background colour*/
	for (row = 0; row < start_row; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
    buffer_row = 0;
    /* send the temp buffer */
	for (row = start_row; row < (start_row + ALPHA_HEIGHT_6x6); row++, buffer_row++)
	{
		for (col = 0; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] = temp_buffer[buffer_row][col];
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
	/* Fill the rest of the rows with the background colour */

	for (; row < LCD_HEIGHT; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
}

void write_text_6x6_color(chanend client, unsigned start_row, unsigned start_col, char text_to_type[])
{
	unsigned temp_buffer[ALPHA_HEIGHT_6x6][LCD_ROW_WORDS];
	unsigned buffer_col = 0;
	unsigned buffer_row = 0;
	unsigned col, row;
	unsigned loop = 0;
	unsigned temp_start_col;
	unsigned short char_buffer[ALPHA_HEIGHT_6x6][ALPHA_WIDTH_6x6] = {{0,0,0,0,0,0}};
	unsigned short background;
	unsigned short foreground;

    background = get_background_color();
    foreground = get_foreground_color();

	temp_start_col = start_col;


	/* the functions first creates the buffer of size 6 rows and updates the text to the
	 * buffer. This intermediate buffer is then updated to the LCD screen
	 */
	for (row = 0; row < ALPHA_HEIGHT_6x6; row++)
	{
		for (col = 0; col < start_col; col++)
		{
           temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
		}
	}

	/* The loop is iterated till it encounter a '\0' which indicates end of text  */
	while (text_to_type[loop] != '\0')
	{
		/* get the character pixel data from the lookup table */
		get_character_6x6(text_to_type[loop], char_buffer);
		for (buffer_row = 0; buffer_row < ALPHA_HEIGHT_6x6; buffer_row++)
		{
		   for (buffer_col = 0; buffer_col < ALPHA_WIDTH_6x6; buffer_col++)
		   {
			   /* Since it is a colour display
			    * Pixel value with 1 is updated with foreground colour
			   	* Pixel value with 0 is updated with background colour
			   	*/

			   if (char_buffer[buffer_row][buffer_col] == 0)
		          	char_buffer[buffer_row][buffer_col] = background;
		       else
		    	   	char_buffer[buffer_row][buffer_col] = foreground;
		   }
	   	}
		buffer_row = 0; buffer_col = 0;
		/* Update the temporary buffer with the character data */
		for (row = 0; row < ALPHA_HEIGHT_6x6; row++)
		{
			buffer_col = 0;
			for (col = temp_start_col; col < (temp_start_col + (ALPHA_WIDTH_6x6/2));
						              col++, buffer_col+=2 )
		    {
				temp_buffer[row][col] = char_buffer[row][buffer_col] |
						      ((unsigned)char_buffer[row][buffer_col + 1] << 16);
		    }
			buffer_col = 0;
			for (; col < (temp_start_col + (ALPHA_WIDTH_6x6/2) + (text_space/2));
							              col++, buffer_col+=2 )
			{
				temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
			}
		}
		/* Set the text space based on the spacing value set in the function set_text_space */
		temp_start_col += (ALPHA_WIDTH_6x6/2);
		temp_start_col += (text_space/2);
		loop++;
	}

	temp_start_col = col;
	for (row = 0; row < ALPHA_HEIGHT_6x6; row++)
	{
		for (col = temp_start_col; col < LCD_ROW_WORDS; col++)
		{
           temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
		}
	}
	/* Now sending to LCD frame */
	/* for rows from 0 to start row of the text, update with the background colour*/
	for (row = 0; row < start_row; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
		index = (index > 0)? 0: 1;
	}
    buffer_row = 0;
    /* send the temp buffer */
	for (row = start_row; row < (start_row + ALPHA_HEIGHT_6x6); row++, buffer_row++)
	{
		for (col = 0; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] = temp_buffer[buffer_row][col];
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
		index = (index > 0)? 0: 1;
	}
	/* Fill the rest of the rows with the background colour */
	for (; row < LCD_HEIGHT; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

	    // The value of index switches between 1 and 0
		index = (index > 0)? 0: 1;
	}
}
/* To write a 16 * 16 pixel text in color */
void write_text_16x16_color(chanend client, unsigned start_row, unsigned start_col, char text_to_type[])
{
	unsigned temp_buffer[ALPHA_HEIGHT_16x16][LCD_ROW_WORDS];
	unsigned buffer_col = 0;
	unsigned buffer_row = 0;
	unsigned col, row;
	unsigned loop = 0;
	unsigned temp_start_col;
	unsigned short char_buffer[ALPHA_HEIGHT_16x16][ALPHA_WIDTH_16x16] = {{0,0,0,0,0,0}};
	unsigned short background;
	unsigned short foreground;

    background = get_background_color();
    foreground = get_foreground_color();

	temp_start_col = start_col;


	/* the functions first creates the buffer of size 16 rows and updates the text to the
	 * buffer. This intermediate buffer is then updated to the LCD screen
	 */
	for (row = 0; row < ALPHA_HEIGHT_16x16; row++)
	{
		for (col = 0; col < start_col; col++)
		{
           temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
		}
	}
	/* The loop is iterated till it encounter a '\0' which indicates end of text  */
	while (text_to_type[loop] != '\0')
	{
		/* The loop is iterated till it encounter a '\0' which indicates end of text  */
		get_character_16x16(text_to_type[loop],char_buffer);
		for (buffer_row = 0; buffer_row < ALPHA_HEIGHT_16x16; buffer_row++)
		{
		   /* Since it is a colour display
		    * Pixel value with 1 is updated with foreground colour
		   	* Pixel value with 0 is updated with background colour
		   	*/
			for (buffer_col = 0; buffer_col < ALPHA_WIDTH_16x16; buffer_col++)
		   {
		       if (char_buffer[buffer_row][buffer_col] == 0)
		          	char_buffer[buffer_row][buffer_col] = background;
		       else
		    	   	char_buffer[buffer_row][buffer_col] = foreground;
		   }
	   	}
		buffer_row = 0; buffer_col = 0;
		/* Update the temporary buffer with the character data */
		for (row = 0; row < ALPHA_HEIGHT_16x16; row++)
		{
			buffer_col = 0;
			for (col = temp_start_col; col < (temp_start_col + (ALPHA_WIDTH_16x16/2));
						              col++, buffer_col+=2 )
		    {
				temp_buffer[row][col] = char_buffer[row][buffer_col] |
						      ((unsigned)char_buffer[row][buffer_col + 1] << 16);
		    }
			buffer_col = 0;
			for (; col < (temp_start_col + (ALPHA_WIDTH_16x16/2) + (text_space/2));
							              col++, buffer_col+=2 )
			{
				temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
			}
		}
		temp_start_col += (ALPHA_WIDTH_16x16/2);
		temp_start_col += (text_space/2);
		loop++;
	}

	temp_start_col = col;
	for (row = 0; row < ALPHA_HEIGHT_16x16; row++)
	{
		for (col = temp_start_col; col < LCD_ROW_WORDS; col++)
		{
           temp_buffer[row][col] = (unsigned)background | (unsigned)((unsigned)background << 16);
		}
	}
	/* Now sending to LCD frame */
	/* for rows from 0 to start row of the text, update with the background colour*/
	for (row = 0; row < start_row; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
    buffer_row = 0;
    /* send the temp buffer */
	for (row = start_row; row < (start_row + ALPHA_HEIGHT_16x16); row++, buffer_row++)
	{
		for (col = 0; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] = temp_buffer[buffer_row][col];
		}

		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
	/* Fill the rest of the rows with the background colour */
	for (; row < LCD_HEIGHT; row++)
	{
		for (col = 0 ; col < LCD_ROW_WORDS; col++)
		{
			lcd_buffer[index][col] =
					(unsigned)background | (unsigned)((unsigned)background << 16);
		}
		lcd_update(client, lcd_buffer[index]);

		// The value of index switches between 1 and 0
	    index = (index > 0)? 0: 1;
	}
}

