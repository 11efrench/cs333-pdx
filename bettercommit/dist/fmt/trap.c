3250 #include "types.h"
3251 #include "defs.h"
3252 #include "param.h"
3253 #include "memlayout.h"
3254 #include "mmu.h"
3255 #include "proc.h"
3256 #include "x86.h"
3257 #include "traps.h"
3258 #include "spinlock.h"
3259 
3260 // Interrupt descriptor table (shared by all CPUs).
3261 struct gatedesc idt[256];
3262 extern uint vectors[];  // in vectors.S: array of 256 entry pointers
3263 struct spinlock tickslock;
3264 uint ticks;
3265 
3266 void
3267 tvinit(void)
3268 {
3269   int i;
3270 
3271   for(i = 0; i < 256; i++)
3272     SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
3273   SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
3274 
3275   initlock(&tickslock, "time");
3276 }
3277 
3278 void
3279 idtinit(void)
3280 {
3281   lidt(idt, sizeof(idt));
3282 }
3283 
3284 void
3285 trap(struct trapframe *tf)
3286 {
3287   if(tf->trapno == T_SYSCALL){
3288     if(proc->killed)
3289       exit();
3290     proc->tf = tf;
3291     syscall();
3292     if(proc->killed)
3293       exit();
3294     return;
3295   }
3296 
3297   switch(tf->trapno){
3298   case T_IRQ0 + IRQ_TIMER:
3299     if(cpu->id == 0){
3300       acquire(&tickslock);
3301       ticks++;
3302       release(&tickslock);    // NOTE: MarkM has reversed these two lines.
3303       wakeup(&ticks);         // wakeup() should not require the tickslock to be held
3304     }
3305     lapiceoi();
3306     break;
3307   case T_IRQ0 + IRQ_IDE:
3308     ideintr();
3309     lapiceoi();
3310     break;
3311   case T_IRQ0 + IRQ_IDE+1:
3312     // Bochs generates spurious IDE1 interrupts.
3313     break;
3314   case T_IRQ0 + IRQ_KBD:
3315     kbdintr();
3316     lapiceoi();
3317     break;
3318   case T_IRQ0 + IRQ_COM1:
3319     uartintr();
3320     lapiceoi();
3321     break;
3322   case T_IRQ0 + 7:
3323   case T_IRQ0 + IRQ_SPURIOUS:
3324     cprintf("cpu%d: spurious interrupt at %x:%x\n",
3325             cpu->id, tf->cs, tf->eip);
3326     lapiceoi();
3327     break;
3328 
3329   default:
3330     if(proc == 0 || (tf->cs&3) == 0){
3331       // In kernel, it must be our mistake.
3332       cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
3333               tf->trapno, cpu->id, tf->eip, rcr2());
3334       panic("trap");
3335     }
3336     // In user space, assume process misbehaved.
3337     cprintf("pid %d %s: trap %d err %d on cpu %d "
3338             "eip 0x%x addr 0x%x--kill proc\n",
3339             proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip,
3340             rcr2());
3341     proc->killed = 1;
3342   }
3343 
3344   // Force process exit if it has been killed and is in user space.
3345   // (If it is still executing in the kernel, let it keep running
3346   // until it gets to the regular system call return.)
3347   if(proc && proc->killed && (tf->cs&3) == DPL_USER)
3348     exit();
3349 
3350   // Force process to give up CPU on clock tick.
3351   // If interrupts were on while locks held, would need to check nlock.
3352   if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
3353     yield();
3354 
3355   // Check if the process has been killed since we yielded
3356   if(proc && proc->killed && (tf->cs&3) == DPL_USER)
3357     exit();
3358 }
3359 
3360 
3361 
3362 
3363 
3364 
3365 
3366 
3367 
3368 
3369 
3370 
3371 
3372 
3373 
3374 
3375 
3376 
3377 
3378 
3379 
3380 
3381 
3382 
3383 
3384 
3385 
3386 
3387 
3388 
3389 
3390 
3391 
3392 
3393 
3394 
3395 
3396 
3397 
3398 
3399 
