#include <platform.h>
#include "lcd.h"

/* User should configure the port details in lcd_ports.xc */

extern clock clk_lcd;
extern out port p_lcd_clk;
extern out port p_lcd_tim;
extern out port p_lcd_rgb;

#define LDW(dst, mem, ind) asm("ldw %0, %1[%2]" : "=r"(dst) : "r"(mem), "r"(ind))

#pragma unsafe arrays

void lcd(chanend c_lcd) {
  unsigned time;
  unsigned x;

  configure_clock_rate_at_least(clk_lcd, FREQ_DIVIDEND, FREQ_DIVISOR);
  set_port_clock(p_lcd_clk, clk_lcd);
  set_port_mode_clock(p_lcd_clk);

  /* RGB port controlled by the clock */
  configure_out_port(p_lcd_rgb, clk_lcd, 0);
  /* Timing port controlled by the clock */
  configure_out_port(p_lcd_tim, clk_lcd, 0);
  start_clock(clk_lcd);

  /* wait until buffers are ready */
  c_lcd :> int;
  p_lcd_tim <: 0 @ time;

  /* wait a bit for the first data to arrive */
  time += 1000;
  c_lcd <: 0;

  while(1){
    unsigned ptr;

    /* Update the time for the Vertical Porch which includes the
     * Vertical pulse and porch timings
     * Each Vertical Sync will include write of the whole image
     * i.e.: All the "LCD_HEIGHT" rows of the screen will be updated
     * The total refresh timing is handled inside the below "for" loop
     * The addition of VERT_PORCH is used only to indicate the start timings
     */
    time += VERT_PORCH;

    /* Loop running for each row of the LCD screen */
    for (int y = 0; y < LCD_HEIGHT; y++)
    {
      c_lcd :> ptr;

      /* Update the time for the Horizontal Porch which include the
       * horizontal pulse and porch timings
       * Within each horizontal Sync, all the "LCD_WIDTH" pixels of a row is
       * refreshed.
       */
      time += HOR_PORCH;

      LDW(x, ptr, 0);

      /* Enable the data by writing to the LCD signals */
      p_lcd_tim @ time <: 0xf;
      /* Copy the 16 bit RGB data to the data lines
       * The first byte is written seperately to indicate the start of the
       * LCD screen update at the required time by using the @time command
       * The update of the rest of the pixel automatically follows after
       * the mentioned time  */
      p_lcd_rgb @ time <: x;

      /* Copy the next 16 bit RGB data to the data lines. XMOS uses a 32 bit
       * port for the LCD data. Hence the data should be split into 2 - 16bit data
       */
      p_lcd_rgb <: (x>>16);

      /* Update the time to include the width of the LCD screen */
      time += LCD_WIDTH;

      /* Disable the data when a row is complete.
       * The data is enabled again before copying the next row of data
       * in the "for" loop
       */
      p_lcd_tim @ time <: 0 ;

      /* clock out a line of pixels */
      for (int i = 1; i <  (LCD_WIDTH / 2); i++)
      {
        LDW(x, ptr, i);
        p_lcd_rgb <: x;
        p_lcd_rgb <: (x>>16);
      }
      c_lcd <: 0;
    }
  }
}
