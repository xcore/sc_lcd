#include <platform.h>
#include "lcd.h"
#include "sprite.h"

lcd_ports ports = { XS1_PORT_1I, XS1_PORT_1L, XS1_PORT_16B, XS1_PORT_1J,
    XS1_PORT_1K, XS1_CLKBLK_1 };
/*
 * Plug XA-SK-SRC480 into the TRIANGLE slot.
 * Build and run.
 */

static inline void add(unsigned x, unsigned y, unsigned line, unsigned buffer[]) {
  if (line >= x && line < x + SPRITE_HEIGHT_PX)
    for (unsigned i = y; i < y + SPRITE_WIDTH_WORDS; i++)
      buffer[i] = logo[(line - x) * SPRITE_WIDTH_WORDS + (i - y)];
}

static inline void sub(unsigned x, unsigned y, unsigned line, unsigned buffer[]) {
  if (line >= x && line < x + SPRITE_HEIGHT_PX)
    for (unsigned i = y; i < y + SPRITE_WIDTH_WORDS; i++)
      buffer[i] = BACK_COLOUR;
}

void demo(chanend c_lcd) {
  unsigned buffer[2][LCD_ROW_WORDS];
  unsigned buffer_index = 0, update = 0;
  int x = 20, y = 0, vx = 1, vy = 2;
  for (unsigned i = 0; i < LCD_ROW_WORDS; i++)
    buffer[0][i] = buffer[1][i] = BACK_COLOUR;
  lcd_init(c_lcd);
  while (1) {
    add(x, y, 0, buffer[buffer_index]);
    lcd_req(c_lcd);
    lcd_update(c_lcd, buffer[buffer_index]);
    for (unsigned line = 1; line < LCD_HEIGHT; line++) {
      add(x, y, line, buffer[1 - buffer_index]);
      lcd_req(c_lcd);
      lcd_update(c_lcd, buffer[1 - buffer_index]);
      sub(x, y, line - 1, buffer[buffer_index]);
      buffer_index = 1 - buffer_index;
    }
    sub(x, y, LCD_HEIGHT - 1, buffer[buffer_index]);
    if (update == 0) {
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
    update = 1 - update;
  }
}

int main() {
  chan c_lcd;
  par {
    lcd_server(c_lcd, ports);
    demo(c_lcd);
    par(int i=0;i<6;i++) while (1);
  }
  return 0;
}
