7550 #include "types.h"
7551 #include "x86.h"
7552 #include "defs.h"
7553 #include "kbd.h"
7554 
7555 int
7556 kbdgetc(void)
7557 {
7558   static uint shift;
7559   static uchar *charcode[4] = {
7560     normalmap, shiftmap, ctlmap, ctlmap
7561   };
7562   uint st, data, c;
7563 
7564   st = inb(KBSTATP);
7565   if((st & KBS_DIB) == 0)
7566     return -1;
7567   data = inb(KBDATAP);
7568 
7569   if(data == 0xE0){
7570     shift |= E0ESC;
7571     return 0;
7572   } else if(data & 0x80){
7573     // Key released
7574     data = (shift & E0ESC ? data : data & 0x7F);
7575     shift &= ~(shiftcode[data] | E0ESC);
7576     return 0;
7577   } else if(shift & E0ESC){
7578     // Last character was an E0 escape; or with 0x80
7579     data |= 0x80;
7580     shift &= ~E0ESC;
7581   }
7582 
7583   shift |= shiftcode[data];
7584   shift ^= togglecode[data];
7585   c = charcode[shift & (CTL | SHIFT)][data];
7586   if(shift & CAPSLOCK){
7587     if('a' <= c && c <= 'z')
7588       c += 'A' - 'a';
7589     else if('A' <= c && c <= 'Z')
7590       c += 'a' - 'A';
7591   }
7592   return c;
7593 }
7594 
7595 void
7596 kbdintr(void)
7597 {
7598   consoleintr(kbdgetc);
7599 }
