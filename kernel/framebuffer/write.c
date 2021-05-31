#include "write.h"

int FRA_cursor_pos  =   0;
int FRA_escape_character    =   0;
FRA_Color    FRA_fg_color;
FRA_Color    FRA_bg_color;
char*   FRA_video_address   =   (char*) 0xb8000;

void    FRA_set_color (FRA_Color fgColor, FRA_Color bgColor) {
	FRA_fg_color = fgColor;
	FRA_bg_color = bgColor;
}

void    FRA_new_page  () {
	for (int i = 0; i < (80 * 25); ++i) {
        	FRA_video_address[i * 2] = 0;
        	FRA_video_address[i * 2 + 1] = 0x0;
	}
}

void	FRA_fill (FRA_Color      color) {
    	for (int i = 0; i < (80*25); ++i) {
        	FRA_video_address[i * 2 + 1] = ((color << 4) | (FRA_video_address[FRA_cursor_pos * 2 + 1] & 0x0F));
	}
}

int	FRA_write (const char* text) {
	for     (int i = 0; ; ++i) {
        	switch  (text[i]) {
        	case '\0':
            		return 1;
        	case '\a':
            		break;
        	case '\b':
            		FRA_video_address[FRA_cursor_pos * 2 - 1] = 0;
        	case '\e':
            		FRA_escape_character = 1;
            		break;
        	case '\f':
            		FRA_new_page();
            		break;
        	case '\n':
            		FRA_cursor_pos += 80 - (FRA_cursor_pos % 80);
            		break;
        	case '\r':
            		FRA_cursor_pos -= 80 - (FRA_cursor_pos % 80);
            		break;
        	case '\t':
            		FRA_cursor_pos += 8;
            		break;
        	case '\v':
            		FRA_cursor_pos += 480;
            		break;
        	default:
            		if  (FRA_escape_character) {
                		FRA_escape_character = 0;
                		break;
            		}
            		FRA_video_address[FRA_cursor_pos * 2] = text[i];
            		FRA_video_address[FRA_cursor_pos * 2 + 1] = ((FRA_bg_color << 4) | FRA_fg_color) & 0x7F;
            		++FRA_cursor_pos;
            		break; 
        	}
	}
	return -1;
}

