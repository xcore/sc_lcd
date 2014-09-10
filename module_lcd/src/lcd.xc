#include <platform.h>
#include <xs1.h>
#include "lcd.h"
#include <print.h>
#include <stdlib.h>

static void init(streaming chanend c_lcd){
    c_lcd :> int;
    c_lcd <: 0;
}

void lcd_init(streaming chanend c_lcd, unsigned * unsafe buffer){
    c_lcd <: 0;
    c_lcd :> int;
    unsafe {
        c_lcd <: buffer;
    }
}

void lcd_update(streaming chanend c_lcd, unsigned * unsafe buffer){
    unsafe {
        c_lcd <: buffer;
    }
}

static void return_pointer(streaming chanend c_lcd, unsigned * unsafe buffer){
    unsafe {
        c_lcd <: buffer;
    }
}

void lcd_req(streaming chanend c_lcd){
    c_lcd :> int;
}

static void fetch_pointer(streaming chanend c_lcd, unsigned * unsafe & buffer){
    c_lcd :> buffer;
}

void lcd_fast_loop(out buffered port:32 lcd_rgb, unsigned * unsafe buffer, int i);

#pragma unsafe arrays
static void output_data16_port16(lcd_ports &p, unsigned * unsafe buffer, unsigned &time){
    unsigned words_per_row = p.s.width>>1;
    unsafe {
        p.lcd_rgb @ time <: buffer[0];

        time += p.s.width;

        int i = -(words_per_row-1);
        buffer += words_per_row;

        if(!isnull(p.lcd_data_enabled))
            p.lcd_data_enabled @ time <: 0;         //blocking instruction

        while(i){
            p.lcd_rgb <: buffer[i];
            i++;
        }
    }
}

#pragma unsafe arrays
static void output_data16_port32(lcd_ports &p, unsigned * unsafe buffer, unsigned &time){
    unsigned words_per_row = p.s.width>>1;
    unsafe {
        unsigned d = buffer[0];
        p.lcd_rgb @ time <: d;

        time += p.s.width;
        if(!isnull(p.lcd_data_enabled))
            p.lcd_data_enabled @ time <: 0;         //blocking instruction

        p.lcd_rgb @ time <: (d>>16);

        for (unsigned i = 1; i < words_per_row; i++){
          d = buffer[i];
          p.lcd_rgb <: d;
          p.lcd_rgb <:(d>>16);
        }
    }
}

static void output_hsync_pulse(unsigned time, lcd_ports &p){
    if(p.s.h_pulse_width < 32){
        partout_timed(p.h_sync, p.s.h_pulse_width + 1, 1 << p.s.h_pulse_width, time);
    } else {
        partout_timed(p.h_sync, 1, 0, time);
        unsigned t = time + p.s.h_pulse_width;
        partout_timed(p.h_sync, 1, 1, t);
    }
}

static void error(){}

#pragma unsafe arrays
void lcd_server(streaming chanend c_lcd, lcd_ports &p) {
  unsigned time;

  stop_clock(p.clk_lcd);

  configure_clock_ref(p.clk_lcd, p.s.clock_divider);
  configure_port_clock_output(p.lcd_clk, p.clk_lcd);
  configure_out_port(p.lcd_rgb, p.clk_lcd, 0);

  set_port_inv(p.lcd_clk);

  if(!isnull(p.lcd_data_enabled))
      configure_out_port(p.lcd_data_enabled, p.clk_lcd, 0);
  if(!isnull(p.h_sync))
      configure_out_port(p.h_sync, p.clk_lcd, 1);
  if(!isnull(p.v_sync))
      configure_out_port(p.v_sync, p.clk_lcd, 1);

  start_clock(p.clk_lcd);

  // Sanity checks
  if(isnull(p.h_sync) && p.s.h_pulse_width!=0)
      error();

  if(isnull(p.v_sync) && p.s.v_pulse_width!=0)
      error();

  //wait here for the client to say that it is ready
  init(c_lcd);

  // get the port time
  p.lcd_rgb <: 0 @ time;

  time += 1000;

  //The count of pixel clocks per horizontal scan line
  unsigned h_sync_clocks = p.s.h_front_porch + p.s.h_back_porch + p.s.width;

  while (1) {

    if(!isnull(p.v_sync))
        p.v_sync @ time <: 0;

    if(!isnull(p.h_sync)){
         for (unsigned i = 0; i < p.s.v_pulse_width; i++) {
             output_hsync_pulse(time, p);
             time += h_sync_clocks;
         }
    } else
        time += h_sync_clocks * p.s.v_pulse_width;

    if(!isnull(p.v_sync))
        p.v_sync @ time <: 1;

    if(!isnull(p.h_sync)){
        for(unsigned i=0;i<p.s.v_back_porch - p.s.v_pulse_width;i++) {
            output_hsync_pulse(time, p);
            time += h_sync_clocks;
        }
    } else
        time += h_sync_clocks*(p.s.v_back_porch - p.s.v_pulse_width);

    for (int y = 0; y < p.s.height; y++) {
        if(!isnull(p.h_sync))
            output_hsync_pulse(time, p);
        time += p.s.h_back_porch;

        unsigned * unsafe buffer;
        fetch_pointer(c_lcd, buffer);

	    if(!isnull(p.lcd_data_enabled))
	        p.lcd_data_enabled @ time <: 1;

	    switch(p.s.output_mode){
          case data16_port16: output_data16_port16(p, buffer, time); break;
          case data16_port32: output_data16_port32(p, buffer, time); break;
	    }
	    return_pointer(c_lcd, buffer);

        time += p.s.h_front_porch;
    }


    for(unsigned i=0;i<p.s.v_front_porch;i++) {
        if(!isnull(p.h_sync))
            output_hsync_pulse(time, p);
        time += h_sync_clocks;
    }
  }
}
