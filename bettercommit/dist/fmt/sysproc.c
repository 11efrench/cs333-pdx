3700 #include "types.h"
3701 #include "x86.h"
3702 #include "defs.h"
3703 #include "date.h"
3704 #include "param.h"
3705 #include "memlayout.h"
3706 #include "mmu.h"
3707 #include "proc.h"
3708 
3709 int
3710 sys_fork(void)
3711 {
3712   return fork();
3713 }
3714 
3715 int
3716 sys_exit(void)
3717 {
3718   exit();
3719   return 0;  // not reached
3720 }
3721 
3722 int
3723 sys_wait(void)
3724 {
3725   return wait();
3726 }
3727 
3728 int
3729 sys_kill(void)
3730 {
3731   int pid;
3732 
3733   if(argint(0, &pid) < 0)
3734     return -1;
3735   return kill(pid);
3736 }
3737 
3738 int
3739 sys_getpid(void)
3740 {
3741   return proc->pid;
3742 }
3743 
3744 
3745 
3746 
3747 
3748 
3749 
3750 int
3751 sys_sbrk(void)
3752 {
3753   int addr;
3754   int n;
3755 
3756   if(argint(0, &n) < 0)
3757     return -1;
3758   addr = proc->sz;
3759   if(growproc(n) < 0)
3760     return -1;
3761   return addr;
3762 }
3763 
3764 int
3765 sys_sleep(void)
3766 {
3767   int n;
3768   uint ticks0;
3769 
3770   if(argint(0, &n) < 0)
3771     return -1;
3772   acquire(&tickslock);
3773   ticks0 = ticks;
3774   while(ticks - ticks0 < n){
3775     if(proc->killed){
3776       release(&tickslock);
3777       return -1;
3778     }
3779     sleep(&ticks, &tickslock);
3780   }
3781   release(&tickslock);
3782   return 0;
3783 }
3784 
3785 // return how many clock tick interrupts have occurred
3786 // since start.
3787 int
3788 sys_uptime(void)
3789 {
3790   uint xticks;
3791 
3792   acquire(&tickslock);
3793   xticks = ticks;
3794   release(&tickslock);
3795   return xticks;
3796 }
3797 
3798 
3799 
3800 //Turn of the computer
3801 int sys_halt(void){
3802   cprintf("Shutting down ...\n");
3803   outw (0xB004, 0x0 | 0x2000);
3804   return 0;
3805 }
3806 
3807 int sys_date(void){
3808 
3809     struct rtcdate* d;
3810 
3811     if(argptr(0, (char**)&d, sizeof(*d)) <0)
3812         return -1;
3813 
3814     cmostime(d);
3815     return 0;
3816 }
3817 
3818 
3819 uint
3820 sys_getuid(void)
3821 {
3822     return proc->uid;
3823 }
3824 
3825 uint
3826 sys_getgid(void)
3827 {
3828     return proc->gid;
3829 }
3830 
3831 uint
3832 sys_getppid(void)
3833 {
3834 
3835     if(proc->pid == 1)
3836         return 1;
3837     return proc->parent->pid;
3838 }
3839 
3840 
3841 
3842 
3843 
3844 
3845 
3846 
3847 
3848 
3849 
3850 int
3851 sys_setuid(void)
3852 {
3853 
3854 
3855     if(argint(0, (int*)&proc->uid))
3856         return -1;
3857 
3858     if(proc->uid < 0 || proc->uid > 32767){
3859         proc->uid = 0;
3860         return -1;
3861     }
3862     else
3863         return 0;
3864 }
3865 
3866 int
3867 sys_setgid(void)
3868 {
3869 
3870     if(argint(0, (int*)&proc->gid) )
3871         return -1;
3872     if(proc->gid < 0 || proc -> gid > 32767){
3873         proc->gid = 0;
3874         return -1;
3875     }
3876     else
3877         return 0;
3878 }
3879 
3880 
3881 // Project 3
3882 int
3883 sys_setpriority(void){
3884 
3885     int pid, priority;
3886    if(argint(0, &pid) < 0 )
3887         return -1;
3888    if(argint(0, &priority) < 0 && priority <= NUM_READY_LISTS ) // validate stack space and check queue bounds
3889         return -1;
3890    if(proc->pid == pid){   // garuntee this is correct process
3891        proc->priority = priority; //set new priority
3892        return 0;
3893     }
3894    else
3895        return -1;
3896 
3897     return 0;        //Error not reached!
3898 }
3899 
