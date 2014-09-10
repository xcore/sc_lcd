#include <platform.h>
#include <xclib.h>
#include "lcd.h"
#include "lcd_slicekit_support.h"
#include "sprite.h"

static unsafe void add(unsigned x, unsigned y, unsigned line, unsigned * unsafe buffer) {
  if (line >= x && line < x + SPRITE_HEIGHT_PX)
    for (unsigned i = y; i < y + SPRITE_WIDTH_WORDS; i++)
      buffer[i] = logo[(line - x) * SPRITE_WIDTH_WORDS + (i - y)];
}

static unsafe void sub(unsigned x, unsigned y, unsigned line, unsigned * unsafe buffer) {
  if (line >= x && line < x + SPRITE_HEIGHT_PX)
    for (unsigned i = y; i < y + SPRITE_WIDTH_WORDS; i++)
      buffer[i] = BACK_COLOUR;
}

static void move_sprite(int &x, int &y, int &vx, int &vy){
    x += vx;
    y += vy;
    if (y <= 0) {
        vy = -vy;
        y = 0;
    }
    if (y >= LCD_ROW_WORDS - SPRITE_WIDTH_WORDS) {
        vy = -vy;
        y = LCD_ROW_WORDS - SPRITE_WIDTH_WORDS - 1;
    }
    if (x <= 0) {
        vx = -vx;
        x = 0;
    }
    if (x >= LCD_HEIGHT - SPRITE_HEIGHT_PX) {
        vx = -vx;
        x = LCD_HEIGHT - SPRITE_HEIGHT_PX - 1;
    }
}


void demo(streaming chanend c_lcd) {
    unsigned buffer[2][LCD_ROW_WORDS];
    int x = 20, y = 0, vx = 1, vy = 2;
    unsigned index = 1;

    for(unsigned i=0;i<LCD_ROW_WORDS;i++){
        buffer[0][i] = BACK_COLOUR;
        buffer[1][i] = BACK_COLOUR;
    }

    unsafe {

        add(x, y, 0, buffer[0]);

        lcd_init(c_lcd, buffer[0]);

        unsigned line = 1;

        while(1){
            while(line < LCD_HEIGHT) {
                add(x, y, line, buffer[index]);
                lcd_req(c_lcd);
                lcd_update(c_lcd, buffer[index]);
                index = 1 - index;
                if(line)
                    sub(x, y, line - 1, buffer[index]);
                else
                    sub(x, y, LCD_HEIGHT - 1, buffer[index]);

                line++;
            }
            line = 0;

            move_sprite(x, y, vx, vy);
        }
    }
}

on tile[LCD_A16_CIRCLE_TILE]: lcd_ports ports = LCD_A16_CIRCLE_PORTS(XS1_CLKBLK_1);

int main() {
    streaming chan c_lcd;
  par {
    on tile[LCD_A16_CIRCLE_TILE]: lcd_server(c_lcd, ports);
    on tile[LCD_A16_CIRCLE_TILE]: demo(c_lcd);
    on tile[LCD_A16_CIRCLE_TILE]: par(int i=0;i<6;i++) while (1);
  }
  return 0;
}
