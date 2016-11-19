#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

//Turn of the computer
int sys_halt(void){
  cprintf("Shutting down ...\n");
  outw (0xB004, 0x0 | 0x2000);
  return 0;
}

int sys_date(void){

    struct rtcdate* d;

    if(argptr(0, (char**)&d, sizeof(*d)) <0)
        return -1;
   
    cmostime(d);
    return 0;
}


uint
sys_getuid(void)
{
    return proc->uid;
}

uint
sys_getgid(void)
{ 
    return proc->gid;
}

uint
sys_getppid(void)
{

    if(proc->pid == 1)
        return 1;
    return proc->parent->pid;
}

int
sys_setuid(void)
{
    

    if(argint(0, (int*)&proc->uid)) 
        return -1;
    
    if(proc->uid < 0 || proc->uid > 32767){
        proc->uid = 0;
        return -1;
    }
    else
        return 0;
}

int
sys_setgid(void)
{

    if(argint(0, (int*)&proc->gid) )
        return -1;
    if(proc->gid < 0 || proc -> gid > 32767){
        proc->gid = 0;
        return -1;
    }
    else 
        return 0;
}


// Project 3
// TODO: Search through ptable to find the process.
// TODO: Update process' priority to new value. 
// TODO: Watch out for RUNNABLE process, be careful with the removal here.
// TODO: Watch out for old and new priority level
int 
sys_setpriority(void){

    int pid, priority;
   if(argint(0, &pid) < 0 )
        return -1;
   //TODO: I think you meant 1, and you need to do priority >= NUM_READY_LISTS.
   //TODO: Also should be an "OR" instead of an "AND"
   if(argint(0, &priority) < 0 && priority <= NUM_READY_LISTS ) // validate stack space and check queue bounds
        return -1;
   if(proc->pid == pid){   // garuntee this is correct process
       proc->priority = priority; //set new priority
       return 0;
    }
   else //TODO: Like getprocs, create a wrapper in proc.c to do the actual priority setting stuff.
       return -1;
    
    return 0;        //Error not reached!
}



