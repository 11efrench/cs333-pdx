6950 // The local APIC manages internal (non-I/O) interrupts.
6951 // See Chapter 8 & Appendix C of Intel processor manual volume 3.
6952 // As of 7/26/2016, Intel processor manual Chapter 10 of Volume 3
6953 
6954 #include "types.h"
6955 #include "defs.h"
6956 #include "date.h"
6957 #include "memlayout.h"
6958 #include "traps.h"
6959 #include "mmu.h"
6960 #include "x86.h"
6961 
6962 // Local APIC registers, divided by 4 for use as uint[] indices.
6963 #define ID      (0x0020/4)   // ID
6964 #define VER     (0x0030/4)   // Version
6965 #define TPR     (0x0080/4)   // Task Priority
6966 #define EOI     (0x00B0/4)   // EOI
6967 #define SVR     (0x00F0/4)   // Spurious Interrupt Vector
6968   #define ENABLE     0x00000100   // Unit Enable
6969 #define ESR     (0x0280/4)   // Error Status
6970 #define ICRLO   (0x0300/4)   // Interrupt Command
6971   #define INIT       0x00000500   // INIT/RESET
6972   #define STARTUP    0x00000600   // Startup IPI
6973   #define DELIVS     0x00001000   // Delivery status
6974   #define ASSERT     0x00004000   // Assert interrupt (vs deassert)
6975   #define DEASSERT   0x00000000
6976   #define LEVEL      0x00008000   // Level triggered
6977   #define BCAST      0x00080000   // Send to all APICs, including self.
6978   #define BUSY       0x00001000
6979   #define FIXED      0x00000000
6980 #define ICRHI   (0x0310/4)   // Interrupt Command [63:32]
6981 #define TIMER   (0x0320/4)   // Local Vector Table 0 (TIMER)
6982   #define X1         0x0000000B   // divide counts by 1
6983   #define PERIODIC   0x00020000   // Periodic
6984 #define PCINT   (0x0340/4)   // Performance Counter LVT
6985 #define LINT0   (0x0350/4)   // Local Vector Table 1 (LINT0)
6986 #define LINT1   (0x0360/4)   // Local Vector Table 2 (LINT1)
6987 #define ERROR   (0x0370/4)   // Local Vector Table 3 (ERROR)
6988   #define MASKED     0x00010000   // Interrupt masked
6989 #define TICR    (0x0380/4)   // Timer Initial Count
6990 #define TCCR    (0x0390/4)   // Timer Current Count
6991 #define TDCR    (0x03E0/4)   // Timer Divide Configuration
6992 
6993 volatile uint *lapic;  // Initialized in mp.c
6994 
6995 static void
6996 lapicw(int index, int value)
6997 {
6998   lapic[index] = value;
6999   lapic[ID];  // wait for write to finish, by reading
7000 }
7001 
7002 void
7003 lapicinit(void)
7004 {
7005   if(!lapic)
7006     return;
7007 
7008   // Enable local APIC; set spurious interrupt vector.
7009   lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
7010 
7011   // The timer repeatedly counts down at bus frequency
7012   // from lapic[TICR] and then issues an interrupt.
7013   // If xv6 cared more about precise timekeeping,
7014   // TICR would be calibrated using an external time source.
7015   lapicw(TDCR, X1);
7016   lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
7017   lapicw(TICR, 10000000);
7018 
7019   // Disable logical interrupt lines.
7020   lapicw(LINT0, MASKED);
7021   lapicw(LINT1, MASKED);
7022 
7023   // Disable performance counter overflow interrupts
7024   // on machines that provide that interrupt entry.
7025   if(((lapic[VER]>>16) & 0xFF) >= 4)
7026     lapicw(PCINT, MASKED);
7027 
7028   // Map error interrupt to IRQ_ERROR.
7029   lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
7030 
7031   // Clear error status register (requires back-to-back writes).
7032   lapicw(ESR, 0);
7033   lapicw(ESR, 0);
7034 
7035   // Ack any outstanding interrupts.
7036   lapicw(EOI, 0);
7037 
7038   // Send an Init Level De-Assert to synchronise arbitration ID's.
7039   lapicw(ICRHI, 0);
7040   lapicw(ICRLO, BCAST | INIT | LEVEL);
7041   while(lapic[ICRLO] & DELIVS)
7042     ;
7043 
7044   // Enable interrupts on the APIC (but not on the processor).
7045   lapicw(TPR, 0);
7046 }
7047 
7048 
7049 
7050 int
7051 cpunum(void)
7052 {
7053   // Cannot call cpu when interrupts are enabled:
7054   // result not guaranteed to last long enough to be used!
7055   // Would prefer to panic but even printing is chancy here:
7056   // almost everything, including cprintf and panic, calls cpu,
7057   // often indirectly through acquire and release.
7058   if(readeflags()&FL_IF){
7059     static int n;
7060     if(n++ == 0)
7061       cprintf("cpu called from %x with interrupts enabled\n",
7062         __builtin_return_address(0));
7063   }
7064 
7065   if(lapic)
7066     return lapic[ID]>>24;
7067   return 0;
7068 }
7069 
7070 // Acknowledge interrupt.
7071 void
7072 lapiceoi(void)
7073 {
7074   if(lapic)
7075     lapicw(EOI, 0);
7076 }
7077 
7078 // Spin for a given number of microseconds.
7079 // On real hardware would want to tune this dynamically.
7080 void
7081 microdelay(int us)
7082 {
7083 }
7084 
7085 #define CMOS_PORT    0x70
7086 #define CMOS_RETURN  0x71
7087 
7088 // Start additional processor running entry code at addr.
7089 // See Appendix B of MultiProcessor Specification.
7090 void
7091 lapicstartap(uchar apicid, uint addr)
7092 {
7093   int i;
7094   ushort *wrv;
7095 
7096   // "The BSP must initialize CMOS shutdown code to 0AH
7097   // and the warm reset vector (DWORD based at 40:67) to point at
7098   // the AP startup code prior to the [universal startup algorithm]."
7099   outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
7100   outb(CMOS_PORT+1, 0x0A);
7101   wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
7102   wrv[0] = 0;
7103   wrv[1] = addr >> 4;
7104 
7105   // "Universal startup algorithm."
7106   // Send INIT (level-triggered) interrupt to reset other CPU.
7107   lapicw(ICRHI, apicid<<24);
7108   lapicw(ICRLO, INIT | LEVEL | ASSERT);
7109   microdelay(200);
7110   lapicw(ICRLO, INIT | LEVEL);
7111   microdelay(100);    // should be 10ms, but too slow in Bochs!
7112 
7113   // Send startup IPI (twice!) to enter code.
7114   // Regular hardware is supposed to only accept a STARTUP
7115   // when it is in the halted state due to an INIT.  So the second
7116   // should be ignored, but it is part of the official Intel algorithm.
7117   // Bochs complains about the second one.  Too bad for Bochs.
7118   for(i = 0; i < 2; i++){
7119     lapicw(ICRHI, apicid<<24);
7120     lapicw(ICRLO, STARTUP | (addr>>12));
7121     microdelay(200);
7122   }
7123 }
7124 
7125 #define CMOS_STATA   0x0a
7126 #define CMOS_STATB   0x0b
7127 #define CMOS_UIP    (1 << 7)        // RTC update in progress
7128 
7129 #define SECS    0x00
7130 #define MINS    0x02
7131 #define HOURS   0x04
7132 #define DAY     0x07
7133 #define MONTH   0x08
7134 #define YEAR    0x09
7135 
7136 static uint cmos_read(uint reg)
7137 {
7138   outb(CMOS_PORT,  reg);
7139   microdelay(200);
7140 
7141   return inb(CMOS_RETURN);
7142 }
7143 
7144 
7145 
7146 
7147 
7148 
7149 
7150 static void fill_rtcdate(struct rtcdate *r)
7151 {
7152   r->second = cmos_read(SECS);
7153   r->minute = cmos_read(MINS);
7154   r->hour   = cmos_read(HOURS);
7155   r->day    = cmos_read(DAY);
7156   r->month  = cmos_read(MONTH);
7157   r->year   = cmos_read(YEAR);
7158 }
7159 
7160 // qemu seems to use 24-hour GWT and the values are BCD encoded
7161 void cmostime(struct rtcdate *r)
7162 {
7163   struct rtcdate t1, t2;
7164   int sb, bcd;
7165 
7166   sb = cmos_read(CMOS_STATB);
7167 
7168   bcd = (sb & (1 << 2)) == 0;
7169 
7170   // make sure CMOS doesn't modify time while we read it
7171   for (;;) {
7172     fill_rtcdate(&t1);
7173     if (cmos_read(CMOS_STATA) & CMOS_UIP)
7174         continue;
7175     fill_rtcdate(&t2);
7176     if (memcmp(&t1, &t2, sizeof(t1)) == 0)
7177       break;
7178   }
7179 
7180   // convert
7181   if (bcd) {
7182 #define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
7183     CONV(second);
7184     CONV(minute);
7185     CONV(hour  );
7186     CONV(day   );
7187     CONV(month );
7188     CONV(year  );
7189 #undef     CONV
7190   }
7191 
7192   *r = t1;
7193   r->year += 2000;
7194 }
7195 
7196 
7197 
7198 
7199 
