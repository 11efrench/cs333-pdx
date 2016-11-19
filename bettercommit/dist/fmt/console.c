7600 // Console input and output.
7601 // Input is from the keyboard or serial port.
7602 // Output is written to the screen and serial port.
7603 
7604 #include "types.h"
7605 #include "defs.h"
7606 #include "param.h"
7607 #include "traps.h"
7608 #include "spinlock.h"
7609 #include "fs.h"
7610 #include "file.h"
7611 #include "memlayout.h"
7612 #include "mmu.h"
7613 #include "proc.h"
7614 #include "x86.h"
7615 
7616 static void consputc(int);
7617 
7618 static int panicked = 0;
7619 
7620 static struct {
7621   struct spinlock lock;
7622   int locking;
7623 } cons;
7624 
7625 static void
7626 printint(int xx, int base, int sign)
7627 {
7628   static char digits[] = "0123456789abcdef";
7629   char buf[16];
7630   int i;
7631   uint x;
7632 
7633   if(sign && (sign = xx < 0))
7634     x = -xx;
7635   else
7636     x = xx;
7637 
7638   i = 0;
7639   do{
7640     buf[i++] = digits[x % base];
7641   }while((x /= base) != 0);
7642 
7643   if(sign)
7644     buf[i++] = '-';
7645 
7646   while(--i >= 0)
7647     consputc(buf[i]);
7648 }
7649 
7650 // Print to the console. only understands %d, %x, %p, %s.
7651 void
7652 cprintf(char *fmt, ...)
7653 {
7654   int i, c, locking;
7655   uint *argp;
7656   char *s;
7657 
7658   locking = cons.locking;
7659   if(locking)
7660     acquire(&cons.lock);
7661 
7662   if (fmt == 0)
7663     panic("null fmt");
7664 
7665   argp = (uint*)(void*)(&fmt + 1);
7666   for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
7667     if(c != '%'){
7668       consputc(c);
7669       continue;
7670     }
7671     c = fmt[++i] & 0xff;
7672     if(c == 0)
7673       break;
7674     switch(c){
7675     case 'd':
7676       printint(*argp++, 10, 1);
7677       break;
7678     case 'x':
7679     case 'p':
7680       printint(*argp++, 16, 0);
7681       break;
7682     case 's':
7683       if((s = (char*)*argp++) == 0)
7684         s = "(null)";
7685       for(; *s; s++)
7686         consputc(*s);
7687       break;
7688     case '%':
7689       consputc('%');
7690       break;
7691     default:
7692       // Print unknown % sequence to draw attention.
7693       consputc('%');
7694       consputc(c);
7695       break;
7696     }
7697   }
7698 
7699 
7700   if(locking)
7701     release(&cons.lock);
7702 }
7703 
7704 void
7705 panic(char *s)
7706 {
7707   int i;
7708   uint pcs[10];
7709 
7710   cli();
7711   cons.locking = 0;
7712   cprintf("cpu%d: panic: ", cpu->id);
7713   cprintf(s);
7714   cprintf("\n");
7715   getcallerpcs(&s, pcs);
7716   for(i=0; i<10; i++)
7717     cprintf(" %p", pcs[i]);
7718   panicked = 1; // freeze other CPU
7719   for(;;)
7720     ;
7721 }
7722 
7723 #define BACKSPACE 0x100
7724 #define CRTPORT 0x3d4
7725 static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory
7726 
7727 static void
7728 cgaputc(int c)
7729 {
7730   int pos;
7731 
7732   // Cursor position: col + 80*row.
7733   outb(CRTPORT, 14);
7734   pos = inb(CRTPORT+1) << 8;
7735   outb(CRTPORT, 15);
7736   pos |= inb(CRTPORT+1);
7737 
7738   if(c == '\n')
7739     pos += 80 - pos%80;
7740   else if(c == BACKSPACE){
7741     if(pos > 0) --pos;
7742   } else
7743     crt[pos++] = (c&0xff) | 0x0700;  // black on white
7744 
7745   if(pos < 0 || pos > 25*80)
7746     panic("pos under/overflow");
7747 
7748 
7749 
7750   if((pos/80) >= 24){  // Scroll up.
7751     memmove(crt, crt+80, sizeof(crt[0])*23*80);
7752     pos -= 80;
7753     memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
7754   }
7755 
7756   outb(CRTPORT, 14);
7757   outb(CRTPORT+1, pos>>8);
7758   outb(CRTPORT, 15);
7759   outb(CRTPORT+1, pos);
7760   crt[pos] = ' ' | 0x0700;
7761 }
7762 
7763 void
7764 consputc(int c)
7765 {
7766   if(panicked){
7767     cli();
7768     for(;;)
7769       ;
7770   }
7771 
7772   if(c == BACKSPACE){
7773     uartputc('\b'); uartputc(' '); uartputc('\b');
7774   } else
7775     uartputc(c);
7776   cgaputc(c);
7777 }
7778 
7779 #define INPUT_BUF 128
7780 struct {
7781   char buf[INPUT_BUF];
7782   uint r;  // Read index
7783   uint w;  // Write index
7784   uint e;  // Edit index
7785 } input;
7786 
7787 #define C(x)  ((x)-'@')  // Control-x
7788 
7789 void
7790 consoleintr(int (*getc)(void))
7791 {
7792   int c, doprocdump = 0;
7793 
7794   acquire(&cons.lock);
7795   while((c = getc()) >= 0){
7796     switch(c){
7797     case C('P'):  // Process listing.
7798       doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
7799       break;
7800     case C('U'):  // Kill line.
7801       while(input.e != input.w &&
7802             input.buf[(input.e-1) % INPUT_BUF] != '\n'){
7803         input.e--;
7804         consputc(BACKSPACE);
7805       }
7806       break;
7807     case C('H'): case '\x7f':  // Backspace
7808       if(input.e != input.w){
7809         input.e--;
7810         consputc(BACKSPACE);
7811       }
7812       break;
7813     default:
7814       if(c != 0 && input.e-input.r < INPUT_BUF){
7815         c = (c == '\r') ? '\n' : c;
7816         input.buf[input.e++ % INPUT_BUF] = c;
7817         consputc(c);
7818         if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
7819           input.w = input.e;
7820           wakeup(&input.r);
7821         }
7822       }
7823       break;
7824     }
7825   }
7826   release(&cons.lock);
7827   if(doprocdump) {
7828     procdump();  // now call procdump() wo. cons.lock held
7829   }
7830 }
7831 
7832 int
7833 consoleread(struct inode *ip, char *dst, int n)
7834 {
7835   uint target;
7836   int c;
7837 
7838   iunlock(ip);
7839   target = n;
7840   acquire(&cons.lock);
7841   while(n > 0){
7842     while(input.r == input.w){
7843       if(proc->killed){
7844         release(&cons.lock);
7845         ilock(ip);
7846         return -1;
7847       }
7848       sleep(&input.r, &cons.lock);
7849     }
7850     c = input.buf[input.r++ % INPUT_BUF];
7851     if(c == C('D')){  // EOF
7852       if(n < target){
7853         // Save ^D for next time, to make sure
7854         // caller gets a 0-byte result.
7855         input.r--;
7856       }
7857       break;
7858     }
7859     *dst++ = c;
7860     --n;
7861     if(c == '\n')
7862       break;
7863   }
7864   release(&cons.lock);
7865   ilock(ip);
7866 
7867   return target - n;
7868 }
7869 
7870 int
7871 consolewrite(struct inode *ip, char *buf, int n)
7872 {
7873   int i;
7874 
7875   iunlock(ip);
7876   acquire(&cons.lock);
7877   for(i = 0; i < n; i++)
7878     consputc(buf[i] & 0xff);
7879   release(&cons.lock);
7880   ilock(ip);
7881 
7882   return n;
7883 }
7884 
7885 void
7886 consoleinit(void)
7887 {
7888   initlock(&cons.lock, "console");
7889 
7890   devsw[CONSOLE].write = consolewrite;
7891   devsw[CONSOLE].read = consoleread;
7892   cons.locking = 1;
7893 
7894   picenable(IRQ_KBD);
7895   ioapicenable(IRQ_KBD, 0);
7896 }
7897 
7898 
7899 
