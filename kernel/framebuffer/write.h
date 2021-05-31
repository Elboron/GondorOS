#ifndef FRA_WRITE
#define FRA_WRITE

typedef enum    FRA_Color {
    Black   =   0x0,
    Blue    =   0x1,
    Green   =   0x2,
    Cyan    =   0x3,
    Red     =   0x4,
    Magenta =   0x5,
    Brown   =   0x6,
    Light_Grey  =   0x7,
    Dark_Grey   =   0x8,
    Light_Blue  =   0x9,
    Light_Green =   0xA,
    Light_Cyan  =   0xB,
    Light_Red   =   0xC,
    Light_Magenta   =   0xD,
    Light_Brown =   0xE,
    White   =   0xF
} FRA_Color;

extern int  FRA_cursor_pos;
extern int  FRA_escape_character;

extern FRA_Color FRA_fg_color;
extern FRA_Color FRA_bg_color;

extern char*    FRA_video_address;


void    FRA_set_color (FRA_Color fgColor, FRA_Color bgColor);

void    FRA_new_page ();

void    FRA_fill (FRA_Color color);

int     FRA_write (const char* text);

#endif
