#ifndef LCD_SLICEKIT_SUPPORT_H_
#define LCD_SLICEKIT_SUPPORT_H_
/*
#define LCD_CLOCK_DIVIDER 3
#define LCD_H_FRONT_PORCH 5
#define LCD_H_BACK_PORCH 40
#define LCD_H_PULSE_WIDTH 1
#define LCD_V_FRONT_PORCH 8
#define LCD_V_BACK_PORCH 8
#define LCD_V_PULSE_WIDTH 1
#define LCD_HEIGHT 272
#define LCD_WIDTH 480
#define LCD_ROW_WORDS (LCD_WIDTH/2)

*/
#define LCD_CLOCK_DIVIDER 4
#define LCD_H_FRONT_PORCH 2
#define LCD_H_BACK_PORCH 88
#define LCD_H_PULSE_WIDTH 1

#define LCD_V_FRONT_PORCH 6
#define LCD_V_BACK_PORCH 32
#define LCD_V_PULSE_WIDTH 3

#define LCD_HEIGHT 480
#define LCD_WIDTH 800
#define LCD_ROW_WORDS (LCD_WIDTH/2)


#define LCD_SETTINGS {LCD_WIDTH, LCD_HEIGHT, LCD_H_FRONT_PORCH, LCD_H_BACK_PORCH, LCD_H_PULSE_WIDTH, LCD_V_FRONT_PORCH, LCD_V_BACK_PORCH, LCD_V_PULSE_WIDTH, data16_port16, LCD_CLOCK_DIVIDER}
/////////////////////////////////////////////////////////////////////////////////////////////////////////


#define LCD_A16_CIRCLE_TILE 1
//#define LCD_A16_CIRCLE_PORTS(X)   {XS1_PORT_16B, XS1_PORT_1I, XS1_PORT_1L, XS1_PORT_1J, XS1_PORT_1K, X, LCD_SETTINGS}
#define LCD_A16_CIRCLE_PORTS(X)   {XS1_PORT_16B, XS1_PORT_1I, null, XS1_PORT_1J, XS1_PORT_1K, X, LCD_SETTINGS}


/*
#define LCD_A16_SQUARE_TILE 1
#define LCD_A16_SQUARE_PORTS(X)   #error config not tested


#define LCD_A16_TRIANGLE_TILE 0
#define LCD_A16_TRIANGLE_PORTS(X) #error config not tested

//not working
#define LCD_A16_STAR_TILE 0
#define LCD_A16_STAR_PORTS(X)     #error config not tested


/////////////////////////////////////////////////////////////////////////////////////////////////////////

#define LCD_L16_SQUARE_TILE 1
#define LCD_L16_SQUARE_PORTS(X)   #error config not tested

#define LCD_L16_CIRCLE_TILE 1
#define LCD_L16_CIRCLE_PORTS(X)   #error config not tested

#define LCD_L16_TRIANGLE_TILE 0
#define LCD_L16_TRIANGLE_PORTS(X) #error config not tested

#define LCD_L16_STAR_TILE 0
#define LCD_L16_STAR_PORTS(X)     #error config not tested

/////////////////////////////////////////////////////////////////////////////////////////////////////////

#define LCD_U16_SQUARE_TILE 1
#define LCD_U16_SQUARE_PORTS(X)    #error config not tested

#define LCD_U16_DIAMOND_TILE       #error config not supported
*/

#endif /* LCD_SLICEKIT_SUPPORT_H_ */
