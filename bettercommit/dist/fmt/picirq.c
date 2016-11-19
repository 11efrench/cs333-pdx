7300 // Intel 8259A programmable interrupt controllers.
7301 
7302 #include "types.h"
7303 #include "x86.h"
7304 #include "traps.h"
7305 
7306 // I/O Addresses of the two programmable interrupt controllers
7307 #define IO_PIC1         0x20    // Master (IRQs 0-7)
7308 #define IO_PIC2         0xA0    // Slave (IRQs 8-15)
7309 
7310 #define IRQ_SLAVE       2       // IRQ at which slave connects to master
7311 
7312 // Current IRQ mask.
7313 // Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
7314 static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);
7315 
7316 static void
7317 picsetmask(ushort mask)
7318 {
7319   irqmask = mask;
7320   outb(IO_PIC1+1, mask);
7321   outb(IO_PIC2+1, mask >> 8);
7322 }
7323 
7324 void
7325 picenable(int irq)
7326 {
7327   picsetmask(irqmask & ~(1<<irq));
7328 }
7329 
7330 // Initialize the 8259A interrupt controllers.
7331 void
7332 picinit(void)
7333 {
7334   // mask all interrupts
7335   outb(IO_PIC1+1, 0xFF);
7336   outb(IO_PIC2+1, 0xFF);
7337 
7338   // Set up master (8259A-1)
7339 
7340   // ICW1:  0001g0hi
7341   //    g:  0 = edge triggering, 1 = level triggering
7342   //    h:  0 = cascaded PICs, 1 = master only
7343   //    i:  0 = no ICW4, 1 = ICW4 required
7344   outb(IO_PIC1, 0x11);
7345 
7346   // ICW2:  Vector offset
7347   outb(IO_PIC1+1, T_IRQ0);
7348 
7349 
7350   // ICW3:  (master PIC) bit mask of IR lines connected to slaves
7351   //        (slave PIC) 3-bit # of slave's connection to master
7352   outb(IO_PIC1+1, 1<<IRQ_SLAVE);
7353 
7354   // ICW4:  000nbmap
7355   //    n:  1 = special fully nested mode
7356   //    b:  1 = buffered mode
7357   //    m:  0 = slave PIC, 1 = master PIC
7358   //      (ignored when b is 0, as the master/slave role
7359   //      can be hardwired).
7360   //    a:  1 = Automatic EOI mode
7361   //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
7362   outb(IO_PIC1+1, 0x3);
7363 
7364   // Set up slave (8259A-2)
7365   outb(IO_PIC2, 0x11);                  // ICW1
7366   outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
7367   outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
7368   // NB Automatic EOI mode doesn't tend to work on the slave.
7369   // Linux source code says it's "to be investigated".
7370   outb(IO_PIC2+1, 0x3);                 // ICW4
7371 
7372   // OCW3:  0ef01prs
7373   //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
7374   //    p:  0 = no polling, 1 = polling mode
7375   //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
7376   outb(IO_PIC1, 0x68);             // clear specific mask
7377   outb(IO_PIC1, 0x0a);             // read IRR by default
7378 
7379   outb(IO_PIC2, 0x68);             // OCW3
7380   outb(IO_PIC2, 0x0a);             // OCW3
7381 
7382   if(irqmask != 0xFFFF)
7383     picsetmask(irqmask);
7384 }
7385 
7386 
7387 
7388 
7389 
7390 
7391 
7392 
7393 
7394 
7395 
7396 
7397 
7398 
7399 
