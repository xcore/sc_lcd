#ifndef _lcd_h_
#define _lcd_h_

#include "lcd_defines.h"

struct lcd_ports
{
  /* The clock line */
  out port lcd_clk;

  /* The LCD signal lines */
  out port lcd_data_enabled;

  /* 16 bit data port */
  out port lcd_rgb;

  /* The hsync line */
  out buffered port:32 lcd_hsync;

  /* The vsync line */
  out buffered port:32 lcd_vsync;

  /* Clock block used for LCD clock */
  clock clk_lcd;
};

void lcd_server(chanend c_lcd, struct lcd_ports &ports);

void lcd_init(chanend c_lcd);

static inline void lcd_update(chanend c_lcd, unsigned buffer[]){
	unsigned buffer_pointer;
	asm  ("mov %0, %1" : "=r"(buffer_pointer) : "r"(buffer));
	c_lcd <: buffer_pointer;
}

#endif
