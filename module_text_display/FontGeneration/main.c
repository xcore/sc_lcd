#include <stdio.h>
#include <ft2build.h>

#include FT_FREETYPE_H
#include FT_GLYPH_H

#define ROM_OPTIMIZED

int main(int     argc,
         char**  argv)
{
  FT_Library library;
  FT_Face face; /* handle to face object */

  FT_GlyphSlot  slot;
  unsigned error;
  unsigned char ascii_char;
  int loop;
  unsigned int no_of_bytes;

  char* font_name;
  char * file_name;
  char* output_file;
  unsigned short font_height;
  unsigned short font_width;
  unsigned int char_offset = 0;

  /* For test purpose */
  FILE *p = NULL;
  FILE *dummy_file = NULL;
  int len = 0;
  char *file;
  char * dummy_filename = "DUMMY.txt";
  char get_ch;

  file_name = argv[1];
  font_name = argv[2];
  font_width = atoi(argv[3]);
  font_height = atoi(argv[4]);
  output_file = argv[5];

  file = output_file;
  p = fopen(file, "w");
  dummy_file = fopen(dummy_filename, "w");

  error = FT_Init_FreeType( &library );
  if ( error )
  {
    fprintf(p, "Could not initialize Freetype");
    return 1;
  }

  error = FT_New_Face( library, file_name, 0, &face );

  if ( error == FT_Err_Unknown_File_Format )
  {
    fprintf(p, "Unknown Font file format");
    return 2;
  }

  /* Add code to find the character size in points before calling API */
  //error = FT_Set_Char_Size( face,  0, 0, 480, 272 );
  //error = FT_Set_Char_Size( face,  font_width * 64, font_height * 64, 480, 272 );
  error = FT_Set_Pixel_Sizes( face, font_width, font_height);

  if (error)
  {
	fprintf(p, "The character size could not be set");
  }

  /* Assign the memory for glyph image */
  slot = face-> glyph;

  fprintf(p, "// The header file for %s font of sizes %d width and %d height \n \n", font_name, font_width, font_height);
  fprintf(p, "const unsigned char %s%d[] =  { \n", font_name, font_width );


  for ( ascii_char = 0; ascii_char < 128; ascii_char++ )
  {

    FT_UInt glyph_index;
    /* retrieve glyph index from character code */
    glyph_index = FT_Get_Char_Index( face, ascii_char );

    /* Load the glyph image. Previous image will be erased */
    /* The load option is set so that monochrome bitmaps can be rendered by calling the render function */
    error = FT_Load_Glyph( face, glyph_index, (FT_LOAD_RENDER | FT_LOAD_MONOCHROME) );

    if ( error ) continue; /* ignore errors */

	//fprintf(p, "Linear Horizontal advance is %d \n", slot->linearHoriAdvance);
	//fprintf(p, "bitmap_left is %d \n", slot->bitmap_left);
	//fprintf(p, "bitmap_top is %d \n", slot->bitmap_top);
	//fprintf(p, "bitmap rows is %d \n", slot->bitmap.rows);
	//fprintf(p, "bitmap pixels in rows is %d \n", slot->bitmap.width);
	//fprintf(p, "Glyph width is %d \n", slot->metrics.width);
	//fprintf(p, "Glyph height is %d \n", slot->metrics.height);
	//fprintf(p, "Glyph Hor Bearing X is %d \n", slot->metrics.horiBearingX);
	//fprintf(p, "Glyph Hor Bearing Y is %d \n", slot->metrics.horiBearingY);
	//fprintf(p, "Glyph Hor advance is %d \n", slot->metrics.horiAdvance);

    no_of_bytes = (unsigned int)(slot->bitmap.width / 8) + (unsigned int)((slot->bitmap.width % 8)? 1 : 0);

    if (no_of_bytes != 0)
       fprintf(p, "0x%-2X ,0x%-2X ,0x%-2X ,", slot->bitmap.rows, slot->bitmap.width, no_of_bytes);
    else
       fprintf(p, "0x%-2X ,0x%-2X ,0x%-2X ", slot->bitmap.rows, slot->bitmap.width, no_of_bytes);
    fprintf(dummy_file, "0x%X, \n",char_offset);

    char_offset += no_of_bytes * slot->bitmap.rows;

    no_of_bytes *= slot->bitmap.rows;

	//fprintf(p, "Number of elements written %d", fwrite(slot->bitmap.buffer, 1, 64, p));

    #ifdef ROM_OPTIMIZED
	 for (loop = 0; loop < no_of_bytes; loop++)
	 {
	   if (loop < no_of_bytes - 1)
	   fprintf(p, "0x%-2X, ", slot->bitmap.buffer[loop]);
	   else
	   // The last byte
	   fprintf(p, "0x%X", slot->bitmap.buffer[loop]);
	 }
	#else
     for (loop = 0; loop < no_of_bytes; loop++)
	 {
	   if (loop < no_of_bytes - 1)
	   {
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x07) & 0x01);
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x06) & 0x01);
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x05) & 0x01);
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x04) & 0x01);
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x03) & 0x01);
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x02) & 0x01);
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x01) & 0x01);
         fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x00) & 0x01);
       }
	   else
	   // The last byte
	   {
	     fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x07) & 0x01);
		 fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x06) & 0x01);
		 fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x05) & 0x01);
		 fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x04) & 0x01);
		 fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x03) & 0x01);
		 fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x02) & 0x01);
		 fprintf(p, "0x%-2X, ", (slot->bitmap.buffer[loop] >> 0x01) & 0x01);
         fprintf(p, "0x%-2X  ", (slot->bitmap.buffer[loop] >> 0x00) & 0x01);
       }
	 }
    #endif
	fprintf(p, ", //bitmap for character %c \n", ascii_char);


    /* convert to an anti-aliased bitmap */
    error = FT_Render_Glyph( slot, FT_RENDER_MODE_MONO );

    if ( error ) continue;

  }
  fprintf(p, "}; ");

  fprintf(p, "\n \n \n");
  fprintf(p, "const unsigned int %s_lookuptable[] = { \n", font_name);
  fclose(dummy_file);
  dummy_file = fopen(dummy_filename, "r");

  while((get_ch=getc(dummy_file))!=EOF)
      putc(get_ch,p);

  fprintf(p, "}; ");
  fclose(p);
  fclose(dummy_file);

  getch();
  return 0;

}
