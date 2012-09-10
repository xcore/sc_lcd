/* The file includes the demo API.
 * The API can be edited by the user based on need
 * Currently the following features are supported
 *  - Setting background color
 *  - Setting foreground color
 *  - Reading background and foreground color
 *  - Displaying an image
 *  - Writing character (6 * 6 pixel) in monochrome and color
 *  - Writing text (6 * 6 pixel) in monochrome and color
 *  - Writing text (16 * 16 pixel) in color (with support for normal and Italic fonts)
 *  - Setting font space in a text
 *  - The character set currently supports only Alphabets in Upper case and special character 'space'
 */
#include "platform.h"
#include "graphics.h"
#include "character_display.h"
#include "character_specific_includes.h"
#include "lcd.h"


/* The XMOS chip shown in the image. It is a 40 * 40 pixel image */
/* A black chip with white pins and diagram on it */
unsigned short image[IMAGE_HEIGHT][IMAGE_WIDTH] =
{
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
 {0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
 {0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0},
};


void graphics_demo(chanend client)
{
  unsigned display_counter = 0;
  char welcometext[] = {'W', 'E', 'L', 'C', 'O', 'M', 'E', ' ', 'T', 'O', ' ', 'X', 'M', 'O', 'S', '\0' };
  char usbtext[] = {'H', 'I', 'G', 'H', ' ', 'S', 'P', 'E', 'E', 'D', ' ', 'U', 'S', 'B', '\0'};
  char motortext[] = {'M', 'O', 'T', 'O', 'R', ' ', 'C', 'O', 'N', 'T', 'R', 'O', 'L', '\0'};
  char ethernettext[] = {'E', 'T', 'H', 'E', 'R', 'N', 'E', 'T', ' ', 'A', 'V', 'B', '\0'};
  char toolstext[] = {'F','R','E','E',' ','T','O','O','L','S','\0'};

  /* Initialize the first data for the LCD */
  lcd_init(client);

  /* Paint screen with black */
  set_graphics_frame(client);

  while(1)
  {
	  set_foreground_color(LCD_565_YELLOW);
	  set_text_space(4);
	  set_text_feature(TEXT_ITALIC);
	  while (display_counter < 75)
	  {
		  if (display_counter < 25)
		  {
		     put_image_BW(client, 50 , 10, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else if (display_counter < 50)
		  {
		     put_image_BW(client, 100 , 30, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else
		  {
		     put_image_BW(client, 130 , 60, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  write_text_16x16_color(client, 110, 60, welcometext);
		  display_counter++;
	  }
	  display_counter = 0;
	  while (display_counter < 75)
	  {
		  if (display_counter < 25)
		  {
		     put_image_BW(client, 150 , 80, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else if (display_counter < 50)
		  {
		     put_image_BW(client, 200 , 120, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else
		  {
		     put_image_BW(client, 180 , 180, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  write_text_16x16_color(client, 110, 60, usbtext);
		  display_counter++;
	  }
	  display_counter = 0;
	  while (display_counter < 75)
	  {
		  if (display_counter < 25)
		  {
		     put_image_BW(client, 160 , 200, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else if (display_counter < 50)
		  {
		     put_image_BW(client, 150 , 160, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else
		  {
		     put_image_BW(client, 135 , 130, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }

		  write_text_16x16_color(client, 110, 60, ethernettext);
		  display_counter++;
	  }
	  display_counter = 0;
	  while (display_counter < 75)
	  {
		  if (display_counter < 25)
		  {
		     put_image_BW(client, 65 , 170, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else if (display_counter < 50)
		  {
		     put_image_BW(client, 45 , 150, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else
		  {
		     put_image_BW(client, 30 , 130, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  write_text_16x16_color(client, 110, 60, motortext);

		  display_counter++;
	  }
	  display_counter = 0;
	  while (display_counter < 75)
	  {
		  if (display_counter < 25)
		  {
		     put_image_BW(client, 20 , 150, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else if (display_counter < 50)
		  {
		     put_image_BW(client, 30, 100, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  else
		  {
		     put_image_BW(client, 40, 50, IMAGE_HEIGHT, IMAGE_WIDTH);
		  }
		  write_text_16x16_color(client, 110, 60, toolstext);

		  display_counter++;
	  }
	  display_counter = 0;


  }
}

/* Variable holding the LCD port information
 * The ports used are based on the customer hardware used
 * The LCD panel's data line is connected as 32 bit line though only 16 bit RGB is used
 * Hence the data is sent as words of pixel information (each word containing 2 pixels)
 */
on stdcore[0]: lcd_ports lcd_ports_init = {
		XS1_PORT_1O,
		XS1_PORT_4F,
		XS1_PORT_32A,
		XS1_CLKBLK_3 };

/* The main function invoking the threads in the parallel statement */
int main(void)
{
  chan c_lcd;

  par {
	  lcd_server(c_lcd, lcd_ports_init);
      graphics_demo(c_lcd);

  }
  return 0;
}







