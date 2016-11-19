7200 // The I/O APIC manages hardware interrupts for an SMP system.
7201 // http://www.intel.com/design/chipsets/datashts/29056601.pdf
7202 // See also picirq.c.
7203 
7204 #include "types.h"
7205 #include "defs.h"
7206 #include "traps.h"
7207 
7208 #define IOAPIC  0xFEC00000   // Default physical address of IO APIC
7209 
7210 #define REG_ID     0x00  // Register index: ID
7211 #define REG_VER    0x01  // Register index: version
7212 #define REG_TABLE  0x10  // Redirection table base
7213 
7214 // The redirection table starts at REG_TABLE and uses
7215 // two registers to configure each interrupt.
7216 // The first (low) register in a pair contains configuration bits.
7217 // The second (high) register contains a bitmask telling which
7218 // CPUs can serve that interrupt.
7219 #define INT_DISABLED   0x00010000  // Interrupt disabled
7220 #define INT_LEVEL      0x00008000  // Level-triggered (vs edge-)
7221 #define INT_ACTIVELOW  0x00002000  // Active low (vs high)
7222 #define INT_LOGICAL    0x00000800  // Destination is CPU id (vs APIC ID)
7223 
7224 volatile struct ioapic *ioapic;
7225 
7226 // IO APIC MMIO structure: write reg, then read or write data.
7227 struct ioapic {
7228   uint reg;
7229   uint pad[3];
7230   uint data;
7231 };
7232 
7233 static uint
7234 ioapicread(int reg)
7235 {
7236   ioapic->reg = reg;
7237   return ioapic->data;
7238 }
7239 
7240 static void
7241 ioapicwrite(int reg, uint data)
7242 {
7243   ioapic->reg = reg;
7244   ioapic->data = data;
7245 }
7246 
7247 
7248 
7249 
7250 void
7251 ioapicinit(void)
7252 {
7253   int i, id, maxintr;
7254 
7255   if(!ismp)
7256     return;
7257 
7258   ioapic = (volatile struct ioapic*)IOAPIC;
7259   maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
7260   id = ioapicread(REG_ID) >> 24;
7261   if(id != ioapicid)
7262     cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
7263 
7264   // Mark all interrupts edge-triggered, active high, disabled,
7265   // and not routed to any CPUs.
7266   for(i = 0; i <= maxintr; i++){
7267     ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
7268     ioapicwrite(REG_TABLE+2*i+1, 0);
7269   }
7270 }
7271 
7272 void
7273 ioapicenable(int irq, int cpunum)
7274 {
7275   if(!ismp)
7276     return;
7277 
7278   // Mark interrupt edge-triggered, active high,
7279   // enabled, and routed to the given cpunum,
7280   // which happens to be that cpu's APIC ID.
7281   ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
7282   ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
7283 }
7284 
7285 
7286 
7287 
7288 
7289 
7290 
7291 
7292 
7293 
7294 
7295 
7296 
7297 
7298 
7299 
