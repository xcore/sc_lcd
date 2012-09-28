#include <platform.h>
#include "lcd.h"
#include "sprite.h"

//struct lcd_ports lcd_ports = {
//  XS1_PORT_1G, XS1_PORT_1F, XS1_PORT_16A, XS1_PORT_1B, XS1_PORT_1C, XS1_CLKBLK_1};

struct lcd_ports lcd_ports = {
  XS1_PORT_1I, XS1_PORT_1L, XS1_PORT_16B, XS1_PORT_1J, XS1_PORT_1K, XS1_CLKBLK_1};

static inline void add(unsigned x, unsigned y, unsigned line, unsigned buffer[]){
	if(line >= x && line < x + SPRITE_HEIGHT_PX)
		for(unsigned i=y;i<y + SPRITE_WIDTH_WORDS;i++)
			buffer[i] = logo[(line-x)*SPRITE_WIDTH_WORDS+(i-y)];
}

static inline void sub(unsigned x, unsigned y, unsigned line, unsigned buffer[]){
	if(line >= x && line < x + SPRITE_HEIGHT_PX)
		for(unsigned i=y;i<y + SPRITE_WIDTH_WORDS;i++)
			buffer[i] = BACK_COLOUR;
}

void demo(chanend c_lcd){
	unsigned buffer[2][LCD_ROW_WORDS];
	unsigned buffer_index = 0, update = 0;
	int x=20, y=0, vx=1, vy=2;
	for(unsigned i=0;i<LCD_ROW_WORDS;i++)
		buffer[0][i] = buffer[1][i] = BACK_COLOUR;
	lcd_init(c_lcd);
	while(1){
		add(x, y, 0, buffer[buffer_index]);
		lcd_req(c_lcd);
		lcd_update(c_lcd, buffer[buffer_index]);
		for(unsigned line=1;line<LCD_HEIGHT;line++){
			add(x, y, line, buffer[1 - buffer_index]);
			lcd_req(c_lcd);
			lcd_update(c_lcd, buffer[1 - buffer_index]);
			sub(x, y, line-1, buffer[buffer_index]);
			buffer_index = 1 - buffer_index;
		}
		sub(x, y, LCD_HEIGHT-1, buffer[buffer_index]);
		if(update==0){
			x+=vx;
			y+=vy;
			if(y>=LCD_ROW_WORDS - SPRITE_WIDTH_WORDS || y<=0)
				vy = -vy;
			if(x>=LCD_HEIGHT - SPRITE_HEIGHT_PX || x <= 0)
				vx = -vx;
		}
		update = 1 - update;
	}
}

out port p = XS1_PORT_8D;
static void disable_flash(){
#if 1
  p <:0x80;
  p <:0xc0;
  p <:0x80;
#else
  p <:0x00;
  p <:0x40;
  p <:0x00;
#endif
  set_port_use_off(p);
}

int main() {
  chan c_lcd;
  disable_flash();
  par {
	lcd_server(c_lcd, lcd_ports);
	demo(c_lcd);
	par(int i=0;i<6;i++) while(1);
  }
  return 0;
}
