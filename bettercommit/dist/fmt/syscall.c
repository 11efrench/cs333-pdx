3450 #include "types.h"
3451 #include "defs.h"
3452 #include "param.h"
3453 #include "memlayout.h"
3454 #include "mmu.h"
3455 #include "proc.h"
3456 #include "x86.h"
3457 #include "syscall.h"
3458 
3459 // User code makes a system call with INT T_SYSCALL.
3460 // System call number in %eax.
3461 // Arguments on the stack, from the user call to the C
3462 // library system call function. The saved user %esp points
3463 // to a saved program counter, and then the first argument.
3464 
3465 // Fetch the int at addr from the current process.
3466 int
3467 fetchint(uint addr, int *ip)
3468 {
3469   if(addr >= proc->sz || addr+4 > proc->sz)
3470     return -1;
3471   *ip = *(int*)(addr);
3472   return 0;
3473 }
3474 
3475 // Fetch the nul-terminated string at addr from the current process.
3476 // Doesn't actually copy the string - just sets *pp to point at it.
3477 // Returns length of string, not including nul.
3478 int
3479 fetchstr(uint addr, char **pp)
3480 {
3481   char *s, *ep;
3482 
3483   if(addr >= proc->sz)
3484     return -1;
3485   *pp = (char*)addr;
3486   ep = (char*)proc->sz;
3487   for(s = *pp; s < ep; s++)
3488     if(*s == 0)
3489       return s - *pp;
3490   return -1;
3491 }
3492 
3493 // Fetch the nth 32-bit system call argument.
3494 int
3495 argint(int n, int *ip)
3496 {
3497   return fetchint(proc->tf->esp + 4 + 4*n, ip);
3498 }
3499 
3500 // Fetch the nth word-sized system call argument as a pointer
3501 // to a block of memory of size n bytes.  Check that the pointer
3502 // lies within the process address space.
3503 int
3504 argptr(int n, char **pp, int size)
3505 {
3506   int i;
3507 
3508   if(argint(n, &i) < 0)
3509     return -1;
3510   if((uint)i >= proc->sz || (uint)i+size > proc->sz)
3511     return -1;
3512   *pp = (char*)i;
3513   return 0;
3514 }
3515 
3516 // Fetch the nth word-sized system call argument as a string pointer.
3517 // Check that the pointer is valid and the string is nul-terminated.
3518 // (There is no shared writable memory, so the string can't change
3519 // between this check and being used by the kernel.)
3520 int
3521 argstr(int n, char **pp)
3522 {
3523   int addr;
3524   if(argint(n, &addr) < 0)
3525     return -1;
3526   return fetchstr(addr, pp);
3527 }
3528 
3529 extern int sys_chdir(void);
3530 extern int sys_close(void);
3531 extern int sys_dup(void);
3532 extern int sys_exec(void);
3533 extern int sys_exit(void);
3534 extern int sys_fork(void);
3535 extern int sys_fstat(void);
3536 extern int sys_getpid(void);
3537 extern int sys_kill(void);
3538 extern int sys_link(void);
3539 extern int sys_mkdir(void);
3540 extern int sys_mknod(void);
3541 extern int sys_open(void);
3542 extern int sys_pipe(void);
3543 extern int sys_read(void);
3544 extern int sys_sbrk(void);
3545 extern int sys_sleep(void);
3546 extern int sys_unlink(void);
3547 extern int sys_wait(void);
3548 extern int sys_write(void);
3549 extern int sys_uptime(void);
3550 extern int sys_halt(void);
3551 
3552 //Student functions
3553 extern int sys_date(void);
3554 
3555 extern int sys_getuid(void);
3556 extern int sys_getgid(void);
3557 extern int sys_getppid(void);
3558 
3559 extern int sys_setuid(void);
3560 extern int sys_setgid(void);
3561 
3562 extern int sys_getprocs(void);
3563 // Project 3
3564 extern int sys_setpriority(void);
3565 
3566 static int (*syscalls[])(void) = {
3567 [SYS_fork]    sys_fork,
3568 [SYS_exit]    sys_exit,
3569 [SYS_wait]    sys_wait,
3570 [SYS_pipe]    sys_pipe,
3571 [SYS_read]    sys_read,
3572 [SYS_kill]    sys_kill,
3573 [SYS_exec]    sys_exec,
3574 [SYS_fstat]   sys_fstat,
3575 [SYS_chdir]   sys_chdir,
3576 [SYS_dup]     sys_dup,
3577 [SYS_getpid]  sys_getpid,
3578 [SYS_sbrk]    sys_sbrk,
3579 [SYS_sleep]   sys_sleep,
3580 [SYS_uptime]  sys_uptime,
3581 [SYS_open]    sys_open,
3582 [SYS_write]   sys_write,
3583 [SYS_mknod]   sys_mknod,
3584 [SYS_unlink]  sys_unlink,
3585 [SYS_link]    sys_link,
3586 [SYS_mkdir]   sys_mkdir,
3587 [SYS_close]   sys_close,
3588 [SYS_halt]    sys_halt,
3589 
3590 //Student Functions
3591 [SYS_date]    sys_date,
3592 
3593 [SYS_getuid]  sys_getuid,
3594 [SYS_getgid]  sys_getgid,
3595 [SYS_getppid] sys_getppid,
3596 
3597 [SYS_setuid]  sys_setuid,
3598 [SYS_setgid]  sys_setgid,
3599 
3600 [SYS_getprocs] sys_getprocs,
3601 
3602 // Project 3
3603 [SYS_setpriority] sys_setpriority,
3604 
3605 };
3606 
3607 // put data structure for printing out system call invocation information here
3608 // This is basically an enum, but can get called differently
3609 #ifdef PRINT_SYSCALLS
3610 char* (sysname[]) = {
3611 [SYS_fork]    "sys_fork",
3612 [SYS_exit]    "sys_exit",
3613 [SYS_wait]    "sys_wait",
3614 [SYS_pipe]    "sys_pipe",
3615 [SYS_read]    "sys_read",
3616 [SYS_kill]    "sys_kill",
3617 [SYS_exec]    "sys_exec",
3618 [SYS_fstat]   "sys_fstat",
3619 [SYS_chdir]   "sys_chdir",
3620 [SYS_dup]     "sys_dup",
3621 [SYS_getpid]  "sys_getpid",
3622 [SYS_sbrk]    "sys_sbrk",
3623 [SYS_sleep]   "sys_sleep",
3624 [SYS_uptime]  "sys_uptime",
3625 [SYS_open]    "sys_open",
3626 [SYS_write]   "sys_write",
3627 [SYS_mknod]   "sys_mknod",
3628 [SYS_unlink]  "sys_unlink",
3629 [SYS_link]    "sys_link",
3630 [SYS_mkdir]   "sys_mkdir",
3631 [SYS_close]   "sys_close",
3632 [SYS_halt]    "sys_halt",
3633 };
3634 #endif
3635 
3636 
3637 void
3638 syscall(void)
3639 {
3640   int num;
3641 
3642   num = proc->tf->eax;
3643   if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
3644     proc->tf->eax = syscalls[num]();
3645     //Start of Project 1
3646     //cprintf("Syscall Happening '\n'");
3647 
3648 
3649 
3650     #ifdef PRINT_SYSCALLS
3651     cprintf("\n \t \t \t  %s -> %d \n", sysname[num], proc->tf->eax );
3652     #endif
3653 
3654   } else {
3655     cprintf("%d %s: unknown sys call %d\n",
3656             proc->pid, proc->name, num);
3657     proc->tf->eax = -1;
3658   }
3659 }
3660 
3661 
3662 
3663 
3664 
3665 
3666 
3667 
3668 
3669 
3670 
3671 
3672 
3673 
3674 
3675 
3676 
3677 
3678 
3679 
3680 
3681 
3682 
3683 
3684 
3685 
3686 
3687 
3688 
3689 
3690 
3691 
3692 
3693 
3694 
3695 
3696 
3697 
3698 
3699 
