6350 #include "types.h"
6351 #include "defs.h"
6352 #include "param.h"
6353 #include "mmu.h"
6354 #include "proc.h"
6355 #include "fs.h"
6356 #include "file.h"
6357 #include "spinlock.h"
6358 
6359 #define PIPESIZE 512
6360 
6361 struct pipe {
6362   struct spinlock lock;
6363   char data[PIPESIZE];
6364   uint nread;     // number of bytes read
6365   uint nwrite;    // number of bytes written
6366   int readopen;   // read fd is still open
6367   int writeopen;  // write fd is still open
6368 };
6369 
6370 int
6371 pipealloc(struct file **f0, struct file **f1)
6372 {
6373   struct pipe *p;
6374 
6375   p = 0;
6376   *f0 = *f1 = 0;
6377   if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
6378     goto bad;
6379   if((p = (struct pipe*)kalloc()) == 0)
6380     goto bad;
6381   p->readopen = 1;
6382   p->writeopen = 1;
6383   p->nwrite = 0;
6384   p->nread = 0;
6385   initlock(&p->lock, "pipe");
6386   (*f0)->type = FD_PIPE;
6387   (*f0)->readable = 1;
6388   (*f0)->writable = 0;
6389   (*f0)->pipe = p;
6390   (*f1)->type = FD_PIPE;
6391   (*f1)->readable = 0;
6392   (*f1)->writable = 1;
6393   (*f1)->pipe = p;
6394   return 0;
6395 
6396 
6397 
6398 
6399 
6400  bad:
6401   if(p)
6402     kfree((char*)p);
6403   if(*f0)
6404     fileclose(*f0);
6405   if(*f1)
6406     fileclose(*f1);
6407   return -1;
6408 }
6409 
6410 void
6411 pipeclose(struct pipe *p, int writable)
6412 {
6413   acquire(&p->lock);
6414   if(writable){
6415     p->writeopen = 0;
6416     wakeup(&p->nread);
6417   } else {
6418     p->readopen = 0;
6419     wakeup(&p->nwrite);
6420   }
6421   if(p->readopen == 0 && p->writeopen == 0){
6422     release(&p->lock);
6423     kfree((char*)p);
6424   } else
6425     release(&p->lock);
6426 }
6427 
6428 int
6429 pipewrite(struct pipe *p, char *addr, int n)
6430 {
6431   int i;
6432 
6433   acquire(&p->lock);
6434   for(i = 0; i < n; i++){
6435     while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
6436       if(p->readopen == 0 || proc->killed){
6437         release(&p->lock);
6438         return -1;
6439       }
6440       wakeup(&p->nread);
6441       sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
6442     }
6443     p->data[p->nwrite++ % PIPESIZE] = addr[i];
6444   }
6445   wakeup(&p->nread);  //DOC: pipewrite-wakeup1
6446   release(&p->lock);
6447   return n;
6448 }
6449 
6450 int
6451 piperead(struct pipe *p, char *addr, int n)
6452 {
6453   int i;
6454 
6455   acquire(&p->lock);
6456   while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
6457     if(proc->killed){
6458       release(&p->lock);
6459       return -1;
6460     }
6461     sleep(&p->nread, &p->lock); //DOC: piperead-sleep
6462   }
6463   for(i = 0; i < n; i++){  //DOC: piperead-copy
6464     if(p->nread == p->nwrite)
6465       break;
6466     addr[i] = p->data[p->nread++ % PIPESIZE];
6467   }
6468   wakeup(&p->nwrite);  //DOC: piperead-wakeup
6469   release(&p->lock);
6470   return i;
6471 }
6472 
6473 
6474 
6475 
6476 
6477 
6478 
6479 
6480 
6481 
6482 
6483 
6484 
6485 
6486 
6487 
6488 
6489 
6490 
6491 
6492 
6493 
6494 
6495 
6496 
6497 
6498 
6499 
