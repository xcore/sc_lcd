#include "lcd.h"

#define TEXT_DISPLAY_CHAR_HEIGHT 10
#define TEXT_DISPLAY_CHAR_WIDTH 8

#define ASCII_SET_SIZE 128

/*
 * char map
 * This is a header that contains a bit map of characters encoded as a one bit bit field.
 * This is what needs doing.
 */
unsigned char_map[TEXT_DISPLAY_CHAR_HEIGHT*TEXT_DISPLAY_CHAR_WIDTH*ASCII_SET_SIZE];


short bg_colour = 0x0000;
short fg_colour = 0xffff;

void setFGColour(short colour){
  fg_colour = colour;
}

void setBGColour(short colour){
  bg_colour = colour;
}

/*
 * /param string[] The string to emit to the buffer.
 * /param length The length of the string.
 * /param line The line number of the characters that is to be emitted to the buffer.
 * /param line_buffer[] The display line buffer.
 * /param buffer_word_offset An offset from the begining of the line to write the text from.
 */
void addString(char string [], unsigned length, unsigned line, unsigned line_buffer[], unsigned buffer_word_offset){

  //the number of chars able to print in the screen from buffer_word_offset
  unsigned max_length = (LCD_ROW_WORDS - buffer_word_offset)*2 / TEXT_DISPLAY_CHAR_WIDTH;

  if(length > max_length)
    length = max_length;

  for(unsigned l=0;l<length;l++){
    char c = string[l];
    unsigned pixel_offset = c * TEXT_DISPLAY_CHAR_HEIGHT*TEXT_DISPLAY_CHAR_WIDTH  + TEXT_DISPLAY_CHAR_WIDTH * line;
    unsigned word = pixel_offset / 32;
    unsigned word_offset = pixel_offset % 32;
    unsigned word = char_map[word];
    for (unsigned i = 0; i < TEXT_DISPLAY_CHAR_WIDTH; i++) {
      if ((word >> (word_offset + i)) & 1) {
        ( line_buffer, short[])[buffer_word_offset*2 + i] = fg_colour;
      } else {
        ( line_buffer, short[])[buffer_word_offset*2 + i] = bg_colour;
      }
      if (word_offset + i == 32) {
        word_offset = 0;
        word = char_map[word + 1];
      }
    }
  }
}
