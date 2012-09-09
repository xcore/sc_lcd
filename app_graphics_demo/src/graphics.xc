#include <xs1.h>
#include <platform.h>
#include "graphics.h"
#include "character_display.h"
#include "lcd.h"

/* The image to be displayed. The image is defined in the demo.xc */
extern unsigned short image[IMAGE_HEIGHT][IMAGE_WIDTH];

/* The LCD buffer to store 2 lines of LCD row data */
unsigned lcd_buffer[2][LCD_ROW_WORDS];
/* Stores the index of the LCD buffer */
unsigned index = 0;

static unsigned short bg_color = LCD_565_BLACK;
static unsigned short fg_color = LCD_565_WHITE;

static text_feature feature = TEXT_NONE;


void set_background_color(chanend client, unsigned short color)
{
  unsigned row, col;

  bg_color = color;

  /* each row of LCD screen is updated with the background colour */
  for (row = 0; row < LCD_HEIGHT; row++)
  {
	  for (col = 0; col < LCD_ROW_WORDS; col++)
	  {
		  lcd_buffer[index][col] =
				  (unsigned)((unsigned)color | (unsigned)((unsigned)color << 16));
	  }
	  lcd_update(client, lcd_buffer[index]);

	  // The value of index switches between 1 and 0
	  index = (index > 0)? 0: 1;
  }

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
		          unsigned height, unsigned width)
{

	unsigned row, col;
	unsigned screen_bg_color = bg_color;
	unsigned image_row, image_col;

    /* Before reaching the start row for the image, paint the screen from row 0
     * to start row with background colour
     */
	for (row = 0; row < start_row; row++)
	  {
		  for (col = 0; col < LCD_ROW_WORDS; col++)
		  {
			  lcd_buffer[index][col] =
					  (unsigned)((unsigned)screen_bg_color | (unsigned)((unsigned)screen_bg_color << 16));
		  }
		  lcd_update(client, lcd_buffer[index]);

		  // The value of index switches between 1 and 0
		  index = (index > 0)? 0: 1;

	  }

	  image_row = 0;

	  /* update the image contents from start row till start row + Image height */
	  for (; row < (start_row + height); row++, image_row++)
	  {

		  for (col = 0; col < start_col; col++)
		  {
			  lcd_buffer[index][col] =
					  (unsigned)((unsigned)screen_bg_color | (unsigned)((unsigned)screen_bg_color << 16));
		  }
		  image_col = 0;
		  for (; col < (start_col + width/2); col++, image_col+=2)
		  {
		  	  unsigned short color1, color2;
		  	  /* The image is updated in monochrome colour
		  	   * Wherever the image value is mentioned as 1 - is filled with WHITE
		  	   * image value mentioned as 0 - is filled with BLACK
		  	   */
              if (image[image_row][image_col] == 0)
            	  color1 = LCD_565_BLACK;
              else
            	  color1 = LCD_565_WHITE;
              if (image[image_row][image_col + 1] == 0)
                  color2 = LCD_565_BLACK;
              else
              	  color2 = LCD_565_WHITE;

              lcd_buffer[index][col] =
		  					  (unsigned)((unsigned)color1 | (unsigned)((unsigned)color2 << 16));
		  }
		  for (; col < LCD_ROW_WORDS; col++)
		  {
			  lcd_buffer[index][col] =
		  					  (unsigned)((unsigned)bg_color | (unsigned)((unsigned)bg_color << 16));
		  }
		  lcd_update(client, lcd_buffer[index]);

		  // The value of index switches between 1 and 0
		  index = (index > 0)? 0: 1;
	  }

	  /* After the image is updated, fill the rest of the rows with background colour */
	  for (; row < LCD_HEIGHT; row++)
	  {
		  for (col = 0; col < LCD_ROW_WORDS; col++)
		  {
			  lcd_buffer[index][col] =
					  (unsigned)((unsigned)bg_color | (unsigned)((unsigned)bg_color << 16));
		  }
		  lcd_update(client, lcd_buffer[index]);

		  // The value of index switches between 1 and 0
		  index = (index > 0)? 0: 1;
	  }
}


