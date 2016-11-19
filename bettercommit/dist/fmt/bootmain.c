8950 // Boot loader.
8951 //
8952 // Part of the boot block, along with bootasm.S, which calls bootmain().
8953 // bootasm.S has put the processor into protected 32-bit mode.
8954 // bootmain() loads an ELF kernel image from the disk starting at
8955 // sector 1 and then jumps to the kernel entry routine.
8956 
8957 #include "types.h"
8958 #include "elf.h"
8959 #include "x86.h"
8960 #include "memlayout.h"
8961 
8962 #define SECTSIZE  512
8963 
8964 void readseg(uchar*, uint, uint);
8965 
8966 void
8967 bootmain(void)
8968 {
8969   struct elfhdr *elf;
8970   struct proghdr *ph, *eph;
8971   void (*entry)(void);
8972   uchar* pa;
8973 
8974   elf = (struct elfhdr*)0x10000;  // scratch space
8975 
8976   // Read 1st page off disk
8977   readseg((uchar*)elf, 4096, 0);
8978 
8979   // Is this an ELF executable?
8980   if(elf->magic != ELF_MAGIC)
8981     return;  // let bootasm.S handle error
8982 
8983   // Load each program segment (ignores ph flags).
8984   ph = (struct proghdr*)((uchar*)elf + elf->phoff);
8985   eph = ph + elf->phnum;
8986   for(; ph < eph; ph++){
8987     pa = (uchar*)ph->paddr;
8988     readseg(pa, ph->filesz, ph->off);
8989     if(ph->memsz > ph->filesz)
8990       stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
8991   }
8992 
8993   // Call the entry point from the ELF header.
8994   // Does not return!
8995   entry = (void(*)(void))(elf->entry);
8996   entry();
8997 }
8998 
8999 
9000 void
9001 waitdisk(void)
9002 {
9003   // Wait for disk ready.
9004   while((inb(0x1F7) & 0xC0) != 0x40)
9005     ;
9006 }
9007 
9008 // Read a single sector at offset into dst.
9009 void
9010 readsect(void *dst, uint offset)
9011 {
9012   // Issue command.
9013   waitdisk();
9014   outb(0x1F2, 1);   // count = 1
9015   outb(0x1F3, offset);
9016   outb(0x1F4, offset >> 8);
9017   outb(0x1F5, offset >> 16);
9018   outb(0x1F6, (offset >> 24) | 0xE0);
9019   outb(0x1F7, 0x20);  // cmd 0x20 - read sectors
9020 
9021   // Read data.
9022   waitdisk();
9023   insl(0x1F0, dst, SECTSIZE/4);
9024 }
9025 
9026 // Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
9027 // Might copy more than asked.
9028 void
9029 readseg(uchar* pa, uint count, uint offset)
9030 {
9031   uchar* epa;
9032 
9033   epa = pa + count;
9034 
9035   // Round down to sector boundary.
9036   pa -= offset % SECTSIZE;
9037 
9038   // Translate from bytes to sectors; kernel starts at sector 1.
9039   offset = (offset / SECTSIZE) + 1;
9040 
9041   // If this is too slow, we could read lots of sectors at a time.
9042   // We'd write more to memory than asked, but it doesn't matter --
9043   // we load in increasing order.
9044   for(; pa < epa; pa += SECTSIZE, offset++)
9045     readsect(pa, offset);
9046 }
9047 
9048 
9049 
