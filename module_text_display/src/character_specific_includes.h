#ifndef _CHARACTER_SPECIFIC_INCLUDES
#define _CHARACTER_SPECIFIC_INCLUDES

#include "CommonHeader.h"
#include "fontlist.h"

/* The structure to hold the font names and the associated font tables and offset tables */
typedef struct
{
	font_support_list font_support;
	const unsigned char * table_addr;
	const unsigned int * offset_table;
}Font_table;

#ifndef _SPEED_OPTIMIZED_EXCESS_ROM
/* This table should be extended by the user based on the number of fonts supported */
const Font_table font_table_used[] =
{
		{Arial, Arial_Normal16, Arial_Normal_lookuptable},
		{Arial_Italic, Arial_Italic16, Arial_Italic_lookuptable},
		{Arial_Bold, Arial_Bold16, Arial_Bold_lookuptable},
		{TimesNewRoman, TimesNew_Normal16, TimesNew_Normal_lookuptable},
		{TimesNewRoman_Italic, TimesNew_Italic16, TimesNew_Italic_lookuptable},
		{TimesNewRoman_Bold, TimesNew_Bold16, TimesNew_Bold_lookuptable}
};
#else

const Font_table font_table_used[] =
{
		{Arial, Arial_Normal16, Arial_Normal_lookuptable},
		{TimesNewRoman, TimesNew_Normal16, TimesNew_Normal_lookuptable},
};
#endif




#endif
