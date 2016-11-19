5550 //
5551 // File descriptors
5552 //
5553 
5554 #include "types.h"
5555 #include "defs.h"
5556 #include "param.h"
5557 #include "fs.h"
5558 #include "file.h"
5559 #include "spinlock.h"
5560 
5561 struct devsw devsw[NDEV];
5562 struct {
5563   struct spinlock lock;
5564   struct file file[NFILE];
5565 } ftable;
5566 
5567 void
5568 fileinit(void)
5569 {
5570   initlock(&ftable.lock, "ftable");
5571 }
5572 
5573 // Allocate a file structure.
5574 struct file*
5575 filealloc(void)
5576 {
5577   struct file *f;
5578 
5579   acquire(&ftable.lock);
5580   for(f = ftable.file; f < ftable.file + NFILE; f++){
5581     if(f->ref == 0){
5582       f->ref = 1;
5583       release(&ftable.lock);
5584       return f;
5585     }
5586   }
5587   release(&ftable.lock);
5588   return 0;
5589 }
5590 
5591 
5592 
5593 
5594 
5595 
5596 
5597 
5598 
5599 
5600 // Increment ref count for file f.
5601 struct file*
5602 filedup(struct file *f)
5603 {
5604   acquire(&ftable.lock);
5605   if(f->ref < 1)
5606     panic("filedup");
5607   f->ref++;
5608   release(&ftable.lock);
5609   return f;
5610 }
5611 
5612 // Close file f.  (Decrement ref count, close when reaches 0.)
5613 void
5614 fileclose(struct file *f)
5615 {
5616   struct file ff;
5617 
5618   acquire(&ftable.lock);
5619   if(f->ref < 1)
5620     panic("fileclose");
5621   if(--f->ref > 0){
5622     release(&ftable.lock);
5623     return;
5624   }
5625   ff = *f;
5626   f->ref = 0;
5627   f->type = FD_NONE;
5628   release(&ftable.lock);
5629 
5630   if(ff.type == FD_PIPE)
5631     pipeclose(ff.pipe, ff.writable);
5632   else if(ff.type == FD_INODE){
5633     begin_op();
5634     iput(ff.ip);
5635     end_op();
5636   }
5637 }
5638 
5639 
5640 
5641 
5642 
5643 
5644 
5645 
5646 
5647 
5648 
5649 
5650 // Get metadata about file f.
5651 int
5652 filestat(struct file *f, struct stat *st)
5653 {
5654   if(f->type == FD_INODE){
5655     ilock(f->ip);
5656     stati(f->ip, st);
5657     iunlock(f->ip);
5658     return 0;
5659   }
5660   return -1;
5661 }
5662 
5663 // Read from file f.
5664 int
5665 fileread(struct file *f, char *addr, int n)
5666 {
5667   int r;
5668 
5669   if(f->readable == 0)
5670     return -1;
5671   if(f->type == FD_PIPE)
5672     return piperead(f->pipe, addr, n);
5673   if(f->type == FD_INODE){
5674     ilock(f->ip);
5675     if((r = readi(f->ip, addr, f->off, n)) > 0)
5676       f->off += r;
5677     iunlock(f->ip);
5678     return r;
5679   }
5680   panic("fileread");
5681 }
5682 
5683 // Write to file f.
5684 int
5685 filewrite(struct file *f, char *addr, int n)
5686 {
5687   int r;
5688 
5689   if(f->writable == 0)
5690     return -1;
5691   if(f->type == FD_PIPE)
5692     return pipewrite(f->pipe, addr, n);
5693   if(f->type == FD_INODE){
5694     // write a few blocks at a time to avoid exceeding
5695     // the maximum log transaction size, including
5696     // i-node, indirect block, allocation blocks,
5697     // and 2 blocks of slop for non-aligned writes.
5698     // this really belongs lower down, since writei()
5699     // might be writing a device like the console.
5700     int max = ((LOGSIZE-1-1-2) / 2) * 512;
5701     int i = 0;
5702     while(i < n){
5703       int n1 = n - i;
5704       if(n1 > max)
5705         n1 = max;
5706 
5707       begin_op();
5708       ilock(f->ip);
5709       if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
5710         f->off += r;
5711       iunlock(f->ip);
5712       end_op();
5713 
5714       if(r < 0)
5715         break;
5716       if(r != n1)
5717         panic("short filewrite");
5718       i += r;
5719     }
5720     return i == n ? n : -1;
5721   }
5722   panic("filewrite");
5723 }
5724 
5725 
5726 
5727 
5728 
5729 
5730 
5731 
5732 
5733 
5734 
5735 
5736 
5737 
5738 
5739 
5740 
5741 
5742 
5743 
5744 
5745 
5746 
5747 
5748 
5749 
