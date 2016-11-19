4450 // Buffer cache.
4451 //
4452 // The buffer cache is a linked list of buf structures holding
4453 // cached copies of disk block contents.  Caching disk blocks
4454 // in memory reduces the number of disk reads and also provides
4455 // a synchronization point for disk blocks used by multiple processes.
4456 //
4457 // Interface:
4458 // * To get a buffer for a particular disk block, call bread.
4459 // * After changing buffer data, call bwrite to write it to disk.
4460 // * When done with the buffer, call brelse.
4461 // * Do not use the buffer after calling brelse.
4462 // * Only one process at a time can use a buffer,
4463 //     so do not keep them longer than necessary.
4464 //
4465 // The implementation uses three state flags internally:
4466 // * B_BUSY: the block has been returned from bread
4467 //     and has not been passed back to brelse.
4468 // * B_VALID: the buffer data has been read from the disk.
4469 // * B_DIRTY: the buffer data has been modified
4470 //     and needs to be written to disk.
4471 
4472 #include "types.h"
4473 #include "defs.h"
4474 #include "param.h"
4475 #include "spinlock.h"
4476 #include "fs.h"
4477 #include "buf.h"
4478 
4479 struct {
4480   struct spinlock lock;
4481   struct buf buf[NBUF];
4482 
4483   // Linked list of all buffers, through prev/next.
4484   // head.next is most recently used.
4485   struct buf head;
4486 } bcache;
4487 
4488 void
4489 binit(void)
4490 {
4491   struct buf *b;
4492 
4493   initlock(&bcache.lock, "bcache");
4494 
4495   // Create linked list of buffers
4496   bcache.head.prev = &bcache.head;
4497   bcache.head.next = &bcache.head;
4498   for(b = bcache.buf; b < bcache.buf+NBUF; b++){
4499     b->next = bcache.head.next;
4500     b->prev = &bcache.head;
4501     b->dev = -1;
4502     bcache.head.next->prev = b;
4503     bcache.head.next = b;
4504   }
4505 }
4506 
4507 // Look through buffer cache for block on device dev.
4508 // If not found, allocate a buffer.
4509 // In either case, return B_BUSY buffer.
4510 static struct buf*
4511 bget(uint dev, uint blockno)
4512 {
4513   struct buf *b;
4514 
4515   acquire(&bcache.lock);
4516 
4517  loop:
4518   // Is the block already cached?
4519   for(b = bcache.head.next; b != &bcache.head; b = b->next){
4520     if(b->dev == dev && b->blockno == blockno){
4521       if(!(b->flags & B_BUSY)){
4522         b->flags |= B_BUSY;
4523         release(&bcache.lock);
4524         return b;
4525       }
4526       sleep(b, &bcache.lock);
4527       goto loop;
4528     }
4529   }
4530 
4531   // Not cached; recycle some non-busy and clean buffer.
4532   // "clean" because B_DIRTY and !B_BUSY means log.c
4533   // hasn't yet committed the changes to the buffer.
4534   for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
4535     if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
4536       b->dev = dev;
4537       b->blockno = blockno;
4538       b->flags = B_BUSY;
4539       release(&bcache.lock);
4540       return b;
4541     }
4542   }
4543   panic("bget: no buffers");
4544 }
4545 
4546 
4547 
4548 
4549 
4550 // Return a B_BUSY buf with the contents of the indicated block.
4551 struct buf*
4552 bread(uint dev, uint blockno)
4553 {
4554   struct buf *b;
4555 
4556   b = bget(dev, blockno);
4557   if(!(b->flags & B_VALID)) {
4558     iderw(b);
4559   }
4560   return b;
4561 }
4562 
4563 // Write b's contents to disk.  Must be B_BUSY.
4564 void
4565 bwrite(struct buf *b)
4566 {
4567   if((b->flags & B_BUSY) == 0)
4568     panic("bwrite");
4569   b->flags |= B_DIRTY;
4570   iderw(b);
4571 }
4572 
4573 // Release a B_BUSY buffer.
4574 // Move to the head of the MRU list.
4575 void
4576 brelse(struct buf *b)
4577 {
4578   if((b->flags & B_BUSY) == 0)
4579     panic("brelse");
4580 
4581   acquire(&bcache.lock);
4582 
4583   b->next->prev = b->prev;
4584   b->prev->next = b->next;
4585   b->next = bcache.head.next;
4586   b->prev = &bcache.head;
4587   bcache.head.next->prev = b;
4588   bcache.head.next = b;
4589 
4590   b->flags &= ~B_BUSY;
4591   wakeup(b);
4592 
4593   release(&bcache.lock);
4594 }
4595 // Blank page.
4596 
4597 
4598 
4599 
