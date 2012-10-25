#include "character_specific_includes.h"

unsigned int _getoffset(unsigned f_index, unsigned char_index)
{
   return font_table_used[f_index].offset_table[char_index];
}

unsigned char _getcharvalue(unsigned f_index, unsigned char_index)
{
   return font_table_used[f_index].table_addr[char_index];
}
