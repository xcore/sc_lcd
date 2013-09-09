#ifndef _lcd_h_
#define _lcd_h_
#include <xs1.h>
#include "lcd_defines.h"
/**
 * The structure to represent LCD port configuration
 */
typedef struct lcd_ports {
  out port lcd_clk; /**< The clock line */
  out port lcd_data_enabled; /**< The LCD data enabled */
  out buffered port:32 lcd_rgb; /**< 16 bit data port */
#if LCD_HOR_PULSE_WIDTH
  out buffered port:32 lcd_hsync; /**< The hsync line */
#endif
#if LCD_VERT_PULSE_WIDTH
  out buffered port:32 lcd_vsync; /**< The vsync line */
#endif
  clock clk_lcd; /**< Clock block used for LCD clock */
} lcd_ports;

/** \brief The LCD server thread.
 *
 * \param client The channel end connecting to the client.
 * \param ports The structure carrying the LCD port details.
 */
void lcd_server(streaming chanend c_client, lcd_ports &ports);


/** \brief LCD update function. This sends a buffer of data to the lcd server to to sent to the lcd.
 *
 * \param c_lcd The channel end connecting to the lcd server.
 * \param buffer[] The data to to emitted to the lcd screen, stored in rgb565.
 *
 * Note, no array bounds checking is performed.
 */
static inline void lcd_update(streaming chanend c_lcd, unsigned buffer[]) {
  unsigned buffer_pointer;
  asm ("mov %0, %1" : "=r"(buffer_pointer) : "r"(buffer));
  c_lcd <: buffer_pointer;
}

/** \brief C interface for LCD update function. This sends a buffer of data to the lcd server to to sent to the lcd.
 *
 * \param c_lcd The channel end connecting to the lcd server.
 * \param buffer A pointer to data to to emitted to the lcd screen, stored in rgb565.
 *
 * Note, no array bounds checking is performed.
 */
static inline void lcd_update_p(streaming chanend c_lcd, unsigned buffer) {
  c_lcd <: buffer;
}

/** \brief Receives the request for data from the LCD server.
 *
 * \param c_lcd The channel end connecting to the lcd server.
 */
#pragma select handler
static inline void lcd_req(streaming chanend c_lcd) {
  c_lcd :> int;
}

#endif
