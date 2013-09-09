#include <platform.h>
#include "lcd.h"

#define LDW(dst, mem, ind) asm("ldw %0, %1[%2]" : "=r"(dst) : "r"(mem), "r"(ind))

void lcd_init(chanend c_lcd) {
  outct(c_lcd, XS1_CT_END);
}

static void request_a_new_line_buffer(streaming chanend c){
  c<: 0;
}

static unsigned take_new_line_buffer(streaming chanend c){
  unsigned d;
  c:> d;
  return d;
}
#pragma unsafe arrays
void lcd_server(streaming chanend c_lcd, struct lcd_ports &p) {
  unsigned time;

  configure_clock_rate_at_least(p.clk_lcd, LCD_FREQ_DIVIDEND, LCD_FREQ_DIVISOR);

  set_port_clock(p.lcd_clk, p.clk_lcd);
  set_port_mode_clock(p.lcd_clk);

  set_port_clock(p.lcd_rgb, p.clk_lcd);
  set_port_clock(p.lcd_data_enabled, p.clk_lcd);

  set_port_inv(p.lcd_clk);
#if LCD_HOR_PULSE_WIDTH
  set_port_clock(p.lcd_hsync, p.clk_lcd);
#endif

#if LCD_VERT_PULSE_WIDTH
  set_port_clock(p.lcd_vsync, p.clk_lcd);
#endif
  start_clock(p.clk_lcd);

  p.lcd_data_enabled <: 0;

#if LCD_VERT_PULSE_WIDTH
  partout(p.lcd_vsync, 1, 1);
#endif
#if LCD_HOR_PULSE_WIDTH
  partout(p.lcd_hsync, 1, 1);
#endif

  request_a_new_line_buffer(c_lcd);
  p.lcd_data_enabled <: 0 @ time;
  time += 1000; //TODO this can be a lot lower

  while (1) {
    unsigned ptr;
    unsigned x;

#if (LCD_VERT_PULSE_WIDTH > 0)
      partout_timed(p.lcd_vsync, 1, 0, time);
#endif
    for (unsigned i = 0; i < LCD_VERT_PULSE_WIDTH; i++) {
#if (LCD_HOR_PULSE_WIDTH > 0)
        partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH + 1,
            1 << LCD_HOR_PULSE_WIDTH, time);
#endif
      time += LCD_HSYNC_TIME;
    }
#if (LCD_VERT_PULSE_WIDTH>0)
    partout_timed(p.lcd_vsync, 1, 1, time);
#endif
#if(LCD_HOR_PULSE_WIDTH)
      for(unsigned i=0;i<LCD_VERT_BACK_PORCH - LCD_VERT_PULSE_WIDTH;i++) {
        if (LCD_HOR_PULSE_WIDTH>0)
        partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH+1, 1<<LCD_HOR_PULSE_WIDTH, time);
        time += LCD_HSYNC_TIME;
      }
#else
      time += LCD_HSYNC_TIME*(LCD_VERT_BACK_PORCH - LCD_VERT_PULSE_WIDTH);
#endif

    for (int y = 0; y < LCD_HEIGHT; y++)
    {
#if (LCD_HOR_PULSE_WIDTH>0)
      partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH+1, 1<<LCD_HOR_PULSE_WIDTH, time);
#endif
      time += LCD_HOR_BACK_PORCH;

      ptr = take_new_line_buffer(c_lcd);
      request_a_new_line_buffer(c_lcd);


#if LCD_FAST_WRITE==1
	  lcd_fast_write(ptr, time, p.lcd_rgb, p.lcd_data_enabled);
	  time += LCD_WIDTH;
#else
	  LDW(x, ptr, 0);

	  p.lcd_data_enabled @ time <: 1;
    p.lcd_rgb @ time <: x;

#if LCD_USE_32_BIT_DATA_PORT==1
    p.lcd_rgb  <: x>>16;
#endif
	  time += LCD_WIDTH;
	  p.lcd_data_enabled @ time <: 0;

	  for (unsigned i = 1; i < LCD_ROW_WORDS; i++) {
		LDW(x, ptr, i);
		p.lcd_rgb <: x;
#if LCD_USE_32_BIT_DATA_PORT==1
    p.lcd_rgb  <: x>>16;
#endif
	  }
#endif
      time += LCD_HOR_FRONT_PORCH;
    }

    for(unsigned i=0;i<LCD_VERT_FRONT_PORCH;i++) {
#if (LCD_HOR_PULSE_WIDTH>0)
      partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH+1, 1<<LCD_HOR_PULSE_WIDTH, time);
#endif
      time += LCD_HSYNC_TIME;
    }
  }
}
