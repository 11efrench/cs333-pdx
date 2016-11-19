7950 // Intel 8250 serial port (UART).
7951 
7952 #include "types.h"
7953 #include "defs.h"
7954 #include "param.h"
7955 #include "traps.h"
7956 #include "spinlock.h"
7957 #include "fs.h"
7958 #include "file.h"
7959 #include "mmu.h"
7960 #include "proc.h"
7961 #include "x86.h"
7962 
7963 #define COM1    0x3f8
7964 
7965 static int uart;    // is there a uart?
7966 
7967 void
7968 uartinit(void)
7969 {
7970   char *p;
7971 
7972   // Turn off the FIFO
7973   outb(COM1+2, 0);
7974 
7975   // 9600 baud, 8 data bits, 1 stop bit, parity off.
7976   outb(COM1+3, 0x80);    // Unlock divisor
7977   outb(COM1+0, 115200/9600);
7978   outb(COM1+1, 0);
7979   outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
7980   outb(COM1+4, 0);
7981   outb(COM1+1, 0x01);    // Enable receive interrupts.
7982 
7983   // If status is 0xFF, no serial port.
7984   if(inb(COM1+5) == 0xFF)
7985     return;
7986   uart = 1;
7987 
7988   // Acknowledge pre-existing interrupt conditions;
7989   // enable interrupts.
7990   inb(COM1+2);
7991   inb(COM1+0);
7992   picenable(IRQ_COM1);
7993   ioapicenable(IRQ_COM1, 0);
7994 
7995   // Announce that we're here.
7996   for(p="xv6...\n"; *p; p++)
7997     uartputc(*p);
7998 }
7999 
8000 void
8001 uartputc(int c)
8002 {
8003   int i;
8004 
8005   if(!uart)
8006     return;
8007   for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8008     microdelay(10);
8009   outb(COM1+0, c);
8010 }
8011 
8012 static int
8013 uartgetc(void)
8014 {
8015   if(!uart)
8016     return -1;
8017   if(!(inb(COM1+5) & 0x01))
8018     return -1;
8019   return inb(COM1+0);
8020 }
8021 
8022 void
8023 uartintr(void)
8024 {
8025   consoleintr(uartgetc);
8026 }
8027 
8028 
8029 
8030 
8031 
8032 
8033 
8034 
8035 
8036 
8037 
8038 
8039 
8040 
8041 
8042 
8043 
8044 
8045 
8046 
8047 
8048 
8049 
