#include <platform.h>
#include <xclib.h>
#include "lcd.h"
#include "lcd_slicekit_support.h"

void test(streaming chanend c_lcd) {
    unsigned full_line[LCD_ROW_WORDS];
    unsigned index = 0;
    unsigned ends[2][LCD_ROW_WORDS];
    for(unsigned i=0;i<LCD_ROW_WORDS;i++)
        full_line[i] = 0xffffffff;

    unsafe {

        lcd_init(c_lcd, full_line);

        while(1){

            //red
            for(unsigned i=1;i<LCD_HEIGHT/3;i++){

                for(unsigned w=0;w<LCD_ROW_WORDS;w++){
                    unsigned c = 0x001f*w/LCD_ROW_WORDS;
                    ends[index][w] = ((c+1)<<16)|c;
                }
                ends[index][0] |= 0x0000ffff;
                ends[index][LCD_ROW_WORDS-1] |= 0xffff0000;
                lcd_req(c_lcd);
                lcd_update(c_lcd, ends[index]);
                index = 1-index;
            }

            //green
            for(unsigned i=LCD_HEIGHT/3;i<2*LCD_HEIGHT/3;i++){

                for(unsigned w=0;w<LCD_ROW_WORDS;w++){
                    unsigned c = 0x003f*w/LCD_ROW_WORDS;
                    ends[index][w] = (((c+1)<<16)|c)<<5;
                }
                ends[index][0] |= 0x0000ffff;
                ends[index][LCD_ROW_WORDS-1] |= 0xffff0000;
                lcd_req(c_lcd);
                lcd_update(c_lcd, ends[index]);
                index = 1-index;
            }

            //blue
            for(unsigned i=2*LCD_HEIGHT/3;i<LCD_HEIGHT-1;i++){

                for(unsigned w=0;w<LCD_ROW_WORDS;w++){
                    unsigned c = 0x001f*w/LCD_ROW_WORDS;
                    ends[index][w] = (((c+1)<<16)|c)<<11;
                }
                ends[index][0] |= 0x0000ffff;
                ends[index][LCD_ROW_WORDS-1] |= 0xffff0000;
                lcd_req(c_lcd);
                lcd_update(c_lcd, ends[index]);
                index = 1-index;
            }

            lcd_req(c_lcd);
            lcd_update(c_lcd, full_line);

            lcd_req(c_lcd);
            lcd_update(c_lcd, full_line);
        }
    }
}

on tile[LCD_A16_CIRCLE_TILE]: lcd_ports ports = LCD_A16_CIRCLE_PORTS(XS1_CLKBLK_1);

int main() {
    streaming chan c_lcd;
  par {
    on tile[LCD_A16_CIRCLE_TILE]: lcd_server(c_lcd, ports);
    on tile[LCD_A16_CIRCLE_TILE]: test(c_lcd);
  }
  return 0;
}
