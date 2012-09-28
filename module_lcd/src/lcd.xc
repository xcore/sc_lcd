#include <platform.h>
#include <xs1.h>
#include "lcd.h"
#include <print.h>
#include <stdlib.h>

#define LDW(dst, mem, ind) asm("ldw %0, %1[%2]" : "=r"(dst) : "r"(mem), "r"(ind))

// Turn this on for debug only. It will cause the driver to error if timing in not met.
//#define TIMING_DEBUG

void lcd_init(chanend c_lcd) {
  outct(c_lcd, XS1_CT_END);
}

#pragma unsafe arrays
void lcd_server(chanend c_lcd, struct lcd_ports &p) {
  unsigned time;
#ifdef TIMING_DEBUG
  timer t;
  unsigned now;
  unsigned started = 0;
#endif
  configure_clock_rate_at_least(p.clk_lcd, LCD_FREQ_DIVIDEND, LCD_FREQ_DIVISOR);
  set_port_clock(p.lcd_clk, p.clk_lcd);
  set_port_mode_clock(p.lcd_clk);

  configure_out_port(p.lcd_rgb, p.clk_lcd, 0);
  configure_out_port(p.lcd_data_enabled, p.clk_lcd, 0);
  configure_out_port(p.lcd_hsync, p.clk_lcd, 0);
  configure_out_port(p.lcd_vsync, p.clk_lcd, 0);

  start_clock(p.clk_lcd);

  chkct(c_lcd, XS1_CT_END);
  outct(c_lcd, XS1_CT_END);

  partout(p.lcd_vsync, 1, 1);
  partout(p.lcd_hsync, 1, 1);
  p.lcd_data_enabled <: 0 @ time;

  time += 1000;

  while (1) {
    unsigned ptr;
    unsigned x;

    if (LCD_VERT_PULSE_WIDTH > 0)
      partout_timed(p.lcd_vsync, 1, 0, time);

    for (unsigned i = 0; i < LCD_VERT_PULSE_WIDTH; i++) {
      if (LCD_HOR_PULSE_WIDTH > 0)
        partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH + 1,
            1 << LCD_HOR_PULSE_WIDTH, time);
      time += LCD_HSYNC_TIME;
    }
    if (LCD_VERT_PULSE_WIDTH>0)
    partout_timed(p.lcd_vsync, 1, 1, time);

    if(LCD_HOR_PULSE_WIDTH) {
      for(unsigned i=0;i<LCD_VERT_BACK_PORCH - LCD_VERT_PULSE_WIDTH;i++) {
        if (LCD_HOR_PULSE_WIDTH>0)
        partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH+1, 1<<LCD_HOR_PULSE_WIDTH, time);
        time += LCD_HSYNC_TIME;
      }
    } else {
      time += LCD_HSYNC_TIME*(LCD_VERT_BACK_PORCH - LCD_VERT_PULSE_WIDTH);
    }

    for (int y = 0; y < LCD_HEIGHT; y++)
    {
      if (LCD_HOR_PULSE_WIDTH>0)
      partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH+1, 1<<LCD_HOR_PULSE_WIDTH, time);

      time += LCD_HOR_BACK_PORCH;

#ifdef TIMING_DEBUG
#define TIME_STEP (LCD_FREQ_DIVISOR*LCD_HSYNC_TIME*100)/(LCD_FREQ_DIVIDEND)
  #pragma ordered
      select {
        case c_lcd :> ptr:
        t:> now;
        started = 1;
        now += TIME_STEP;
        break;
        case started => t when timerafter(now) :> int:
        printstrln("LCD timing fail");
        _Exit(1);
        break;
      }
#else
      ptr = inuint(c_lcd);
      chkct(c_lcd, XS1_CT_END);
#endif

      LDW(x, ptr, 0);

      p.lcd_data_enabled @ time <: 1;
      p.lcd_rgb @ time <: x;

      time += LCD_WIDTH;

      p.lcd_data_enabled @ time <: 0;

      for (unsigned i = 1; i < LCD_ROW_WORDS; i++) {
        LDW(x, ptr, i);
        p.lcd_rgb <: x;
      }
      outct(c_lcd, XS1_CT_END);
      time += LCD_HOR_FRONT_PORCH;
    }

    for(unsigned i=0;i<LCD_VERT_FRONT_PORCH;i++) {
      if (LCD_HOR_PULSE_WIDTH>0)
      partout_timed(p.lcd_hsync, LCD_HOR_PULSE_WIDTH+1, 1<<LCD_HOR_PULSE_WIDTH, time);
      time += LCD_HSYNC_TIME;
    }
  }
}
