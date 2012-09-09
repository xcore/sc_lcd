#include <platform.h>
#include "lcd.h"

/**
 * \brief The assembly instruction to load the value of the word to the mentioned destination address
 */
#define LDW(dst, mem, ind) asm("ldw %0, %1[%2]" : "=r"(dst) : "r"(mem), "r"(ind))

void lcd_init(chanend c_lcd){
	c_lcd <: 0;
}


void lcd_update(chanend c_lcd, unsigned buffer[])
{
	unsigned buffer_pointer;
	asm  ("mov %0, %1" : "=r"(buffer_pointer) : "r"(buffer));

	/* Send the buffer contents over the LCD channel */
	c_lcd <: buffer_pointer;
}


#pragma unsafe arrays
void lcd_server(chanend c_lcd, lcd_ports &p)
{
  unsigned time;
  unsigned x;

  configure_clock_rate_at_least( p.clk_lcd, LCD_FREQ_DIVIDEND, LCD_FREQ_DIVISOR);
  set_port_clock(p.p_lcd_clk, p.clk_lcd);
  set_port_mode_clock(p.p_lcd_clk);

  /* RGB port controlled by the clock */
  configure_out_port(p.p_lcd_rgb, p.clk_lcd, 0);
  /* Timing port controlled by the clock */
  configure_out_port(p.p_lcd_tim, p.clk_lcd, 0);
  start_clock(p.clk_lcd);

  /* wait until buffers are ready */
  c_lcd :> int;
  p.p_lcd_tim <: 0 @ time;

  /* wait a bit for the first data to arrive */
  time += 1000;

  while(1){
    unsigned ptr;

    /* Update the time for the Vertical Porch which includes the
     * Vertical pulse and porch timings
     * Each Vertical Sync will include write of the whole image
     * i.e.: All the "LCD_HEIGHT" rows of the screen will be updated
     * The total refresh timing is handled inside the below "for" loop
     * The addition of LCD_VERT_PORCH is used only to indicate the start timings
     */
    time += LCD_VERT_PORCH;

    /* Loop running for each row of the LCD screen */
    for (int y = 0; y < LCD_HEIGHT; y++)
    {
      c_lcd :> ptr;

      /* Update the time for the Horizontal Porch which include the
       * horizontal pulse and porch timings
       * Within each horizontal Sync, all the "LCD_WIDTH" pixels of a row is
       * refreshed.
       */
      time += LCD_HOR_PORCH;

      LDW(x, ptr, 0);

      /* Enable the data by writing to the LCD signals */
      p.p_lcd_tim @ time <: 0xf;

      /* Copy the 16 bit RGB data to the data lines
       * The first byte is written seperately to indicate the start of the
       * LCD screen update at the required time by using the @time command
       * The update of the rest of the pixel automatically follows after
       * the mentioned time  */
      p.p_lcd_rgb @ time <: x;

      /* Copy the next 16 bit RGB data to the data lines. XMOS uses a 32 bit
       * port for the LCD data. Hence the data should be split into 2 - 16bit data
       */
      p.p_lcd_rgb <: (x>>16);

      /* Update the time to include the width of the LCD screen */
      time += LCD_WIDTH;

      /* Disable the data when a row is complete.
       * The data is enabled again before copying the next row of data
       * in the "for" loop
       */
      p.p_lcd_tim @ time <: 0 ;

      /* clock out a line of pixels. The loop iteration is for the number of words (and not for the
       * number of pixels) in each row of the LCD */
      for (int i = 1; i <  (LCD_WIDTH / 2); i++)
      {
        LDW(x, ptr, i);
        p.p_lcd_rgb <: x;
        p.p_lcd_rgb <: (x>>16);
      } /* End of loop for number of pixels in a row in the LCD screen */

    } /* End of loop for rows in the LCD screen */
  } /* End of while loop */
} /* End of LCD thread */
