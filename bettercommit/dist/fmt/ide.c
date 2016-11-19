4250 // Simple PIO-based (non-DMA) IDE driver code.
4251 
4252 #include "types.h"
4253 #include "defs.h"
4254 #include "param.h"
4255 #include "memlayout.h"
4256 #include "mmu.h"
4257 #include "proc.h"
4258 #include "x86.h"
4259 #include "traps.h"
4260 #include "spinlock.h"
4261 #include "fs.h"
4262 #include "buf.h"
4263 
4264 #define SECTOR_SIZE   512
4265 #define IDE_BSY       0x80
4266 #define IDE_DRDY      0x40
4267 #define IDE_DF        0x20
4268 #define IDE_ERR       0x01
4269 
4270 #define IDE_CMD_READ  0x20
4271 #define IDE_CMD_WRITE 0x30
4272 
4273 // idequeue points to the buf now being read/written to the disk.
4274 // idequeue->qnext points to the next buf to be processed.
4275 // You must hold idelock while manipulating queue.
4276 
4277 static struct spinlock idelock;
4278 static struct buf *idequeue;
4279 
4280 static int havedisk1;
4281 static void idestart(struct buf*);
4282 
4283 // Wait for IDE disk to become ready.
4284 static int
4285 idewait(int checkerr)
4286 {
4287   int r;
4288 
4289   while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
4290     ;
4291   if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
4292     return -1;
4293   return 0;
4294 }
4295 
4296 
4297 
4298 
4299 
4300 void
4301 ideinit(void)
4302 {
4303   int i;
4304 
4305   initlock(&idelock, "ide");
4306   picenable(IRQ_IDE);
4307   ioapicenable(IRQ_IDE, ncpu - 1);
4308   idewait(0);
4309 
4310   // Check if disk 1 is present
4311   outb(0x1f6, 0xe0 | (1<<4));
4312   for(i=0; i<1000; i++){
4313     if(inb(0x1f7) != 0){
4314       havedisk1 = 1;
4315       break;
4316     }
4317   }
4318 
4319   // Switch back to disk 0.
4320   outb(0x1f6, 0xe0 | (0<<4));
4321 }
4322 
4323 // Start the request for b.  Caller must hold idelock.
4324 static void
4325 idestart(struct buf *b)
4326 {
4327   if(b == 0)
4328     panic("idestart");
4329   if(b->blockno >= FSSIZE)
4330     panic("incorrect blockno");
4331   int sector_per_block =  BSIZE/SECTOR_SIZE;
4332   int sector = b->blockno * sector_per_block;
4333 
4334   if (sector_per_block > 7) panic("idestart");
4335 
4336   idewait(0);
4337   outb(0x3f6, 0);  // generate interrupt
4338   outb(0x1f2, sector_per_block);  // number of sectors
4339   outb(0x1f3, sector & 0xff);
4340   outb(0x1f4, (sector >> 8) & 0xff);
4341   outb(0x1f5, (sector >> 16) & 0xff);
4342   outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
4343   if(b->flags & B_DIRTY){
4344     outb(0x1f7, IDE_CMD_WRITE);
4345     outsl(0x1f0, b->data, BSIZE/4);
4346   } else {
4347     outb(0x1f7, IDE_CMD_READ);
4348   }
4349 }
4350 // Interrupt handler.
4351 void
4352 ideintr(void)
4353 {
4354   struct buf *b;
4355 
4356   // First queued buffer is the active request.
4357   acquire(&idelock);
4358   if((b = idequeue) == 0){
4359     release(&idelock);
4360     // cprintf("spurious IDE interrupt\n");
4361     return;
4362   }
4363   idequeue = b->qnext;
4364 
4365   // Read data if needed.
4366   if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
4367     insl(0x1f0, b->data, BSIZE/4);
4368 
4369   // Wake process waiting for this buf.
4370   b->flags |= B_VALID;
4371   b->flags &= ~B_DIRTY;
4372   wakeup(b);
4373 
4374   // Start disk on next buf in queue.
4375   if(idequeue != 0)
4376     idestart(idequeue);
4377 
4378   release(&idelock);
4379 }
4380 
4381 // Sync buf with disk.
4382 // If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
4383 // Else if B_VALID is not set, read buf from disk, set B_VALID.
4384 void
4385 iderw(struct buf *b)
4386 {
4387   struct buf **pp;
4388 
4389   if(!(b->flags & B_BUSY))
4390     panic("iderw: buf not busy");
4391   if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
4392     panic("iderw: nothing to do");
4393   if(b->dev != 0 && !havedisk1)
4394     panic("iderw: ide disk 1 not present");
4395 
4396   acquire(&idelock);  //DOC:acquire-lock
4397 
4398 
4399 
4400   // Append b to idequeue.
4401   b->qnext = 0;
4402   for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
4403     ;
4404   *pp = b;
4405 
4406   // Start disk if necessary.
4407   if(idequeue == b)
4408     idestart(b);
4409 
4410   // Wait for request to finish.
4411   while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
4412     sleep(b, &idelock);
4413   }
4414 
4415   release(&idelock);
4416 }
4417 
4418 
4419 
4420 
4421 
4422 
4423 
4424 
4425 
4426 
4427 
4428 
4429 
4430 
4431 
4432 
4433 
4434 
4435 
4436 
4437 
4438 
4439 
4440 
4441 
4442 
4443 
4444 
4445 
4446 
4447 
4448 
4449 
