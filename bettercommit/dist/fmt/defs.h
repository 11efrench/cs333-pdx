0300 struct buf;
0301 struct context;
0302 struct file;
0303 struct inode;
0304 struct pipe;
0305 struct proc;
0306 struct rtcdate;
0307 struct spinlock;
0308 struct stat;
0309 struct superblock;
0310 
0311 // bio.c
0312 void            binit(void);
0313 struct buf*     bread(uint, uint);
0314 void            brelse(struct buf*);
0315 void            bwrite(struct buf*);
0316 
0317 // console.c
0318 void            consoleinit(void);
0319 void            cprintf(char*, ...);
0320 void            consoleintr(int(*)(void));
0321 void            panic(char*) __attribute__((noreturn));
0322 
0323 // exec.c
0324 int             exec(char*, char**);
0325 
0326 // file.c
0327 struct file*    filealloc(void);
0328 void            fileclose(struct file*);
0329 struct file*    filedup(struct file*);
0330 void            fileinit(void);
0331 int             fileread(struct file*, char*, int n);
0332 int             filestat(struct file*, struct stat*);
0333 int             filewrite(struct file*, char*, int n);
0334 
0335 // fs.c
0336 void            readsb(int dev, struct superblock *sb);
0337 int             dirlink(struct inode*, char*, uint);
0338 struct inode*   dirlookup(struct inode*, char*, uint*);
0339 struct inode*   ialloc(uint, short);
0340 struct inode*   idup(struct inode*);
0341 void            iinit(int dev);
0342 void            ilock(struct inode*);
0343 void            iput(struct inode*);
0344 void            iunlock(struct inode*);
0345 void            iunlockput(struct inode*);
0346 void            iupdate(struct inode*);
0347 int             namecmp(const char*, const char*);
0348 struct inode*   namei(char*);
0349 struct inode*   nameiparent(char*, char*);
0350 int             readi(struct inode*, char*, uint, uint);
0351 void            stati(struct inode*, struct stat*);
0352 int             writei(struct inode*, char*, uint, uint);
0353 
0354 // ide.c
0355 void            ideinit(void);
0356 void            ideintr(void);
0357 void            iderw(struct buf*);
0358 
0359 // ioapic.c
0360 void            ioapicenable(int irq, int cpu);
0361 extern uchar    ioapicid;
0362 void            ioapicinit(void);
0363 
0364 // kalloc.c
0365 char*           kalloc(void);
0366 void            kfree(char*);
0367 void            kinit1(void*, void*);
0368 void            kinit2(void*, void*);
0369 
0370 // kbd.c
0371 void            kbdintr(void);
0372 
0373 // lapic.c
0374 void            cmostime(struct rtcdate *r);
0375 int             cpunum(void);
0376 extern volatile uint*    lapic;
0377 void            lapiceoi(void);
0378 void            lapicinit(void);
0379 void            lapicstartap(uchar, uint);
0380 void            microdelay(int);
0381 
0382 // log.c
0383 void            initlog(int dev);
0384 void            log_write(struct buf*);
0385 void            begin_op();
0386 void            end_op();
0387 
0388 // mp.c
0389 extern int      ismp;
0390 int             mpbcpu(void);
0391 void            mpinit(void);
0392 void            mpstartthem(void);
0393 
0394 // picirq.c
0395 void            picenable(int);
0396 void            picinit(void);
0397 
0398 
0399 
0400 // pipe.c
0401 int             pipealloc(struct file**, struct file**);
0402 void            pipeclose(struct pipe*, int);
0403 int             piperead(struct pipe*, char*, int);
0404 int             pipewrite(struct pipe*, char*, int);
0405 
0406 // proc.c
0407 struct proc*    copyproc(struct proc*);
0408 void            exit(void);
0409 int             fork(void);
0410 int             growproc(int);
0411 int             kill(int);
0412 void            pinit(void);
0413 void            procdump(void);
0414 void            scheduler(void) __attribute__((noreturn));
0415 void            sched(void);
0416 void            sleep(void*, struct spinlock*);
0417 void            userinit(void);
0418 int             wait(void);
0419 void            wakeup(void*);
0420 void            yield(void);
0421 
0422 // swtch.S
0423 void            swtch(struct context**, struct context*);
0424 
0425 // spinlock.c
0426 void            acquire(struct spinlock*);
0427 void            getcallerpcs(void*, uint*);
0428 int             holding(struct spinlock*);
0429 void            initlock(struct spinlock*, char*);
0430 void            release(struct spinlock*);
0431 void            pushcli(void);
0432 void            popcli(void);
0433 
0434 // string.c
0435 int             memcmp(const void*, const void*, uint);
0436 void*           memmove(void*, const void*, uint);
0437 void*           memset(void*, int, uint);
0438 char*           safestrcpy(char*, const char*, int);
0439 int             strlen(const char*);
0440 int             strncmp(const char*, const char*, uint);
0441 char*           strncpy(char*, const char*, int);
0442 
0443 // syscall.c
0444 int             argint(int, int*);
0445 int             argptr(int, char**, int);
0446 int             argstr(int, char**);
0447 int             fetchint(uint, int*);
0448 int             fetchstr(uint, char**);
0449 void            syscall(void);
0450 // timer.c
0451 void            timerinit(void);
0452 
0453 // trap.c
0454 void            idtinit(void);
0455 extern uint     ticks;
0456 void            tvinit(void);
0457 extern struct spinlock tickslock;
0458 
0459 // uart.c
0460 void            uartinit(void);
0461 void            uartintr(void);
0462 void            uartputc(int);
0463 
0464 // vm.c
0465 void            seginit(void);
0466 void            kvmalloc(void);
0467 void            vmenable(void);
0468 pde_t*          setupkvm(void);
0469 char*           uva2ka(pde_t*, char*);
0470 int             allocuvm(pde_t*, uint, uint);
0471 int             deallocuvm(pde_t*, uint, uint);
0472 void            freevm(pde_t*);
0473 void            inituvm(pde_t*, char*, uint);
0474 int             loaduvm(pde_t*, char*, struct inode*, uint, uint);
0475 pde_t*          copyuvm(pde_t*, uint);
0476 void            switchuvm(struct proc*);
0477 void            switchkvm(void);
0478 int             copyout(pde_t*, uint, void*, uint);
0479 void            clearpteu(pde_t *pgdir, char *uva);
0480 
0481 // number of elements in fixed-size array
0482 #define NELEM(x) (sizeof(x)/sizeof((x)[0]))
0483 
0484 
0485 
0486 
0487 
0488 
0489 
0490 
0491 
0492 
0493 
0494 
0495 
0496 
0497 
0498 
0499 
