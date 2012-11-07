#include <xs1.h>
#include <platform.h>
#include "graphics.h"
#include "character_display.h"
#include "lcd.h"

/* The LCD buffer to store 2 lines of LCD row data */
unsigned lcd_buffer[2][LCD_ROW_WORDS];
/* Stores the index of the LCD buffer */
unsigned index = 0;

static unsigned short bg_color = LCD_565_BLACK;
static unsigned short fg_color = LCD_565_WHITE;

static text_feature feature = TEXT_NONE;

void fill_rows(chanend client, unsigned start_row, unsigned end_row, unsigned start_col,
		              unsigned end_col, unsigned color)
{
      unsigned row, col;

	  for (row = start_row; row < end_row; row++)
	  {
		  for (col = start_col; col < end_col; col++)
		  {
			  lcd_buffer[index][col] = CreateWord(color,color);
		  }
		  lcd_update(client, lcd_buffer[index]);

		  // The value of index switches between 1 and 0
		  index = (index > 0)? 0: 1;
	  }
}

void set_background_color(chanend client, unsigned short color)
{
  unsigned row, col;

  bg_color = color;

  /* each row of LCD screen is updated with the background colour */
  fill_rows(client, 0, LCD_HEIGHT, 0, LCD_ROW_WORDS, bg_color);

}

void set_foreground_color(unsigned short color)
{
	/* The text written to the screen takes the mentioned foreground color */
	fg_color = color;
}

unsigned short get_foreground_color(void)
{
	return fg_color;
}

unsigned short get_background_color(void)
{
	return bg_color;
}

void set_graphics_frame(chanend client)
{

	bg_color = LCD_565_BLACK;
	fg_color = LCD_565_WHITE;
	set_background_color(client, bg_color);
}

void set_text_feature(text_feature txt_ft)
{
	feature = txt_ft;
}

/* To read back the property of text */
text_feature get_text_feature(void)
{
	return feature;
}

void put_image_BW(chanend client, unsigned start_row, unsigned start_col,
		          unsigned height, unsigned width, unsigned short image[])
{

	unsigned row, col;
	unsigned image_index;

	image_index = 0;
	/* Before reaching the start row for the image, paint the screen from row 0
     * to start row with background colour
     */
	fill_rows(client, 0, start_row, 0, LCD_ROW_WORDS, bg_color);

    /* update the image contents from start row till start row + Image height */
	for (; row < (start_row + height); row++)
	{
      for (col = 0; col < start_col; col++)
	  {
		  lcd_buffer[index][col] = CreateWord(bg_color, bg_color);
	  }

	  for (; col < (start_col + width/2); col++, image_index+=2)
	  {
	  	  unsigned short color1, color2;
	  	  /* The image is updated in monochrome colour
	  	   * Wherever the image value is mentioned as 1 - is filled with WHITE
	  	   * image value mentioned as 0 - is filled with BLACK
	  	   */
	  	  color1 = FindColor_Monochrome(image[image_index]);
          color2 = FindColor_Monochrome(image[image_index + 1]);

          lcd_buffer[index][col] = CreateWord(color2, color1);

	  }
	  for (; col < LCD_ROW_WORDS; col++)
	  {
		  lcd_buffer[index][col] = CreateWord(bg_color, bg_color);
	  }

	  lcd_update(client, lcd_buffer[index]);

	  // The value of index switches between 1 and 0
	  index = (index > 0)? 0: 1;
    }

	/* Fill the remaining rows with the background color */
	fill_rows(client, row, LCD_HEIGHT, 0, LCD_ROW_WORDS, bg_color);


}


