2150 #include "types.h"
2151 #include "defs.h"
2152 #include "param.h"
2153 #include "memlayout.h"
2154 #include "mmu.h"
2155 #include "x86.h"
2156 #include "proc.h"
2157 #include "spinlock.h"
2158 #include "asm.h"
2159 #include "uproc.h"
2160 #include "queue.h"
2161 
2162 struct {
2163   struct spinlock lock;
2164   struct proc proc[NPROC];
2165   struct queue ReadyList[NUM_READY_LISTS];  // Array of queue for MLFQ
2166   struct queue FreeList;                    // Queue for UNUSED processes
2167   uint PromoteAtTime;
2168 
2169 } ptable;
2170 
2171 static struct proc *initproc;
2172 
2173 int nextpid = 1;
2174 extern void forkret(void);
2175 extern void trapret(void);
2176 // Project 3
2177 // Helper Functions to manipulate the queues
2178 
2179 extern int      queue (struct queue* this, struct proc* first);
2180 extern int     enqueue (struct queue* this, struct proc* nproc);
2181 extern  struct proc* dequeue (struct queue* this);
2182 extern int     updateBudget(struct proc* this, int now);
2183 extern void    promote();
2184 
2185 static void wakeup1(void *chan);
2186 
2187 void
2188 pinit(void)
2189 {
2190   initlock(&ptable.lock, "ptable");
2191 }
2192 
2193 
2194 
2195 
2196 
2197 
2198 
2199 
2200 // Look in the process table for an UNUSED proc.
2201 // If found, change state to EMBRYO and initialize
2202 // state required to run in the kernel.
2203 // Otherwise return 0.
2204 static struct proc*
2205 allocproc(void)
2206 {
2207   struct proc *p;
2208   char *sp;
2209 
2210   acquire(&ptable.lock);
2211   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
2212     if(p->state == UNUSED)
2213       goto found;
2214   release(&ptable.lock);
2215   return 0;
2216 
2217   // Project 3 Pull process from Free List
2218   acquire(&ptable.lock);
2219   p = 0;                                // Must be initialized, so assume the worst case
2220   p = dequeue(&ptable.FreeList);
2221 
2222   if(p != 0)
2223       goto found;
2224   release(&ptable.lock);
2225   return 0;
2226 
2227 found:
2228   p->state = EMBRYO;
2229   p->pid = nextpid++;
2230   release(&ptable.lock);
2231 
2232   // Allocate kernel stack.
2233   if((p->kstack = kalloc()) == 0){
2234     p->state = UNUSED;
2235     enqueue(&ptable.FreeList, p);
2236     return 0;
2237   }
2238   sp = p->kstack + KSTACKSIZE;
2239 
2240   // Leave room for trap frame.
2241   sp -= sizeof *p->tf;
2242   p->tf = (struct trapframe*)sp;
2243 
2244   // Set up new context to start executing at forkret,
2245   // which returns to trapret.
2246   sp -= 4;
2247   *(uint*)sp = (uint)trapret;
2248 
2249 
2250   sp -= sizeof *p->context;
2251   p->context = (struct context*)sp;
2252   memset(p->context, 0, sizeof *p->context);
2253   p->context->eip = (uint)forkret;
2254 
2255   // STUDENT CODE
2256   // Grab Start Time
2257   acquire(&tickslock);
2258   p->start_ticks = (uint)ticks;
2259   release(&tickslock);
2260 
2261   p->cpu_ticks_total = 0;
2262   p->cpu_ticks_in = 0;
2263   return p;
2264 }
2265 
2266 // Set up first user process.
2267 void
2268 userinit(void)
2269 {
2270   struct proc *p;
2271   extern char _binary_initcode_start[], _binary_initcode_size[];
2272 
2273   //Project 3
2274   // Before any process is created initialize all processes to
2275   // the free list
2276 
2277   acquire(&ptable.lock);
2278   queue(&ptable.FreeList, &ptable.proc[0]);
2279   for(int i = 1; i < NPROC; i++){
2280     enqueue(&ptable.FreeList, &ptable.proc[i]);
2281   }
2282   release(&ptable.lock);
2283 
2284 
2285   p = allocproc();
2286   initproc = p;
2287   if((p->pgdir = setupkvm()) == 0)
2288     panic("userinit: out of memory?");
2289   inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
2290   p->sz = PGSIZE;
2291   memset(p->tf, 0, sizeof(*p->tf));
2292   p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
2293   p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
2294   p->tf->es = p->tf->ds;
2295   p->tf->ss = p->tf->ds;
2296   p->tf->eflags = FL_IF;
2297   p->tf->esp = PGSIZE;
2298   p->tf->eip = 0;  // beginning of initcode.S
2299 
2300   safestrcpy(p->name, "initcode", sizeof(p->name));
2301   p->cwd = namei("/");
2302 
2303   p->state = RUNNABLE;
2304 
2305   p->uid = INITUID;
2306   p->gid = INITGID;
2307   p->budget = INITBUDGET;
2308   //Project 3
2309   acquire(&ptable.lock);
2310   enqueue(&ptable.ReadyList[0], p);
2311   release(&ptable.lock);
2312 }
2313 
2314 // Grow current process's memory by n bytes.
2315 // Return 0 on success, -1 on failure.
2316 int
2317 growproc(int n)
2318 {
2319   uint sz;
2320 
2321   sz = proc->sz;
2322   if(n > 0){
2323     if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
2324       return -1;
2325   } else if(n < 0){
2326     if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
2327       return -1;
2328   }
2329   proc->sz = sz;
2330   switchuvm(proc);
2331   return 0;
2332 }
2333 
2334 // Create a new process copying p as the parent.
2335 // Sets up stack to return as if from system call.
2336 // Caller must set state of returned proc to RUNNABLE.
2337 int
2338 fork(void)
2339 {
2340   int i, pid;
2341   struct proc *np;
2342 
2343   // Allocate process.
2344   if((np = allocproc()) == 0)
2345     return -1;
2346 
2347 
2348 
2349 
2350   // Copy process state from p.
2351   if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
2352     kfree(np->kstack);
2353     np->kstack = 0;
2354     np->state = UNUSED;
2355     acquire(&ptable.lock);
2356     enqueue(&ptable.FreeList, np);
2357     release(&ptable.lock);
2358     return -1;
2359   }
2360   np->sz = proc->sz;
2361   np->parent = proc;
2362   *np->tf = *proc->tf;
2363 
2364   // Clear %eax so that fork returns 0 in the child.
2365   np->tf->eax = 0;
2366 
2367   for(i = 0; i < NOFILE; i++)
2368     if(proc->ofile[i])
2369       np->ofile[i] = filedup(proc->ofile[i]);
2370   np->cwd = idup(proc->cwd);
2371 
2372   safestrcpy(np->name, proc->name, sizeof(proc->name));
2373 
2374   //STUDENT CODE copy all ids
2375   pid = np->pid;
2376   np->uid = proc->uid;
2377   np->gid = proc->gid;
2378 
2379   // lock to force the compiler to emit the np->state write last.
2380   acquire(&ptable.lock);
2381   np->state = RUNNABLE;
2382   enqueue(&ptable.ReadyList[0], np);
2383   release(&ptable.lock);
2384 
2385   return pid;
2386 }
2387 
2388 
2389 
2390 
2391 
2392 
2393 
2394 
2395 
2396 
2397 
2398 
2399 
2400 // Exit the current process.  Does not return.
2401 // An exited process remains in the zombie state
2402 // until its parent calls wait() to find out it exited.
2403 void
2404 exit(void)
2405 {
2406   struct proc *p;
2407   int fd;
2408 
2409   if(proc == initproc)
2410     panic("init exiting");
2411 
2412   // Close all open files.
2413   for(fd = 0; fd < NOFILE; fd++){
2414     if(proc->ofile[fd]){
2415       fileclose(proc->ofile[fd]);
2416       proc->ofile[fd] = 0;
2417     }
2418   }
2419 
2420   begin_op();
2421   iput(proc->cwd);
2422   end_op();
2423   proc->cwd = 0;
2424 
2425   acquire(&ptable.lock);
2426 
2427   // Parent might be sleeping in wait().
2428   wakeup1(proc->parent);
2429 
2430   // Pass abandoned children to init.
2431   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2432     if(p->parent == proc){
2433       p->parent = initproc;
2434       if(p->state == ZOMBIE)
2435         wakeup1(initproc);
2436     }
2437   }
2438   // Jump into the scheduler, never to return.
2439   proc->state = ZOMBIE;
2440   sched();
2441   panic("zombie exit");
2442 }
2443 
2444 
2445 
2446 
2447 
2448 
2449 
2450 // Wait for a child process to exit and return its pid.
2451 // Return -1 if this process has no children.
2452 int
2453 wait(void)
2454 {
2455   struct proc *p;
2456   int havekids, pid;
2457 
2458   acquire(&ptable.lock);
2459   for(;;){
2460     // Scan through table looking for zombie children.
2461     havekids = 0;
2462     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2463       if(p->parent != proc)
2464         continue;
2465       havekids = 1;
2466       if(p->state == ZOMBIE){
2467         // Found one.
2468         pid = p->pid;
2469         kfree(p->kstack);
2470         p->kstack = 0;
2471         freevm(p->pgdir);
2472         p->state = UNUSED;
2473         p->pid = 0;
2474         p->parent = 0;
2475         p->name[0] = 0;
2476         p->killed = 0;
2477         enqueue(&ptable.FreeList, p);
2478         release(&ptable.lock);
2479         return pid;
2480       }
2481     }
2482 
2483     // No point waiting if we don't have any children.
2484     if(!havekids || proc->killed){
2485       release(&ptable.lock);
2486       return -1;
2487     }
2488 
2489     // Wait for children to exit.  (See wakeup1 call in proc_exit.)
2490     sleep(proc, &ptable.lock);  //DOC: wait-sleep
2491   }
2492 }
2493 
2494 
2495 
2496 
2497 
2498 
2499 
2500 // Per-CPU process scheduler.
2501 // Each CPU calls scheduler() after setting itself up.
2502 // Scheduler never returns.  It loops, doing:
2503 //  - choose a process to run
2504 //  - swtch to start running that process
2505 //  - eventually that process transfers control
2506 //      via swtch back to the scheduler.
2507 #ifndef CS333_P3
2508 // original xv6 scheduler. Use if CS333_P3 NOT defined.
2509 void
2510 scheduler(void)
2511 {
2512   struct proc *p;
2513   uint now;
2514 
2515   for(;;){
2516     // Enable interrupts on this processor.
2517     sti();
2518 
2519     // Loop over process table looking for process to run.
2520     acquire(&ptable.lock);
2521     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2522       if(p->state != RUNNABLE)
2523         continue;
2524 
2525       // Switch to chosen process.  It is the process's job
2526       // to release ptable.lock and then reacquire it
2527       // before jumping back to us.
2528       proc = p;
2529       switchuvm(p);
2530       p->state = RUNNING;
2531 
2532       acquire(&tickslock);
2533       now = (uint)ticks;
2534       release(&tickslock);
2535       p->cpu_ticks_in = now;
2536 
2537       swtch(&cpu->scheduler, proc->context);
2538       switchkvm();
2539 
2540       // Process is done running for now.
2541       // It should have changed its p->state before coming back.
2542       proc = 0;
2543     }
2544     release(&ptable.lock);
2545 
2546   }
2547 }
2548 
2549 
2550 #else
2551 // CS333_P3 MLFQ scheduler implementation goes here
2552 void
2553 scheduler(void)
2554 {
2555 
2556   int CURRENT = 0;
2557   struct proc *p = 0;
2558   uint now = 0;
2559 
2560 //  acquire(&ptable.lock);
2561 //  ptable.PromoteAtTime = TICKS_TO_PROMOTE;
2562 //  release(&ptable.lock);
2563   for(;;){
2564     // Enable interrupts on this processor.
2565     sti();
2566 //    if(now >= ptable.PromoteAtTime ){
2567 //          promote();
2568 //          ptable.PromoteAtTime = ptable.PromoteAtTime + TICKS_TO_PROMOTE;
2569 //    }
2570     if(CURRENT == NUM_READY_LISTS) //Go back to top of queue
2571         CURRENT = 0;
2572     // Loop over process table looking for process to run.
2573     acquire(&ptable.lock);
2574     p = dequeue(&ptable.ReadyList[CURRENT]);
2575     if(p == 0){
2576        CURRENT++;
2577         release(&ptable.lock);
2578         continue;
2579     }
2580       // Switch to chosen process.  It is the process's job
2581       // to release ptable.lock and then reacquire it
2582       // before jumping back to us.
2583       proc = p;
2584       switchuvm(p);
2585       p->state = RUNNING;
2586 
2587       acquire(&tickslock);
2588       now = (uint)ticks;
2589       release(&tickslock);
2590       p->cpu_ticks_in = now;
2591       // Is it time to promote?
2592      swtch(&cpu->scheduler, proc->context);
2593       switchkvm();
2594 
2595       // Process is done running for now.
2596       // It should have changed its p->state before coming back.
2597       proc = 0;
2598     release(&ptable.lock);
2599    }
2600 }
2601 #endif
2602 
2603 // Enter scheduler.  Must hold only ptable.lock
2604 // and have changed proc->state.
2605 void
2606 sched(void)
2607 {
2608   int rc;
2609   int intena;
2610   uint now;
2611 
2612   if(!holding(&ptable.lock))
2613     panic("sched ptable.lock");
2614   if(cpu->ncli != 1)
2615     panic("sched locks");
2616   if(proc->state == RUNNING)
2617     panic("sched running");
2618   if(readeflags()&FL_IF)
2619     panic("sched interruptible");
2620   intena = cpu->intena;
2621 
2622   acquire(&tickslock);
2623   now = (uint)ticks;
2624   release(&tickslock);
2625 
2626   proc->cpu_ticks_total = proc->cpu_ticks_total + (now - proc->cpu_ticks_in);
2627 
2628   rc = updateBudget(proc, now);
2629   if(rc && (proc->priority< NUM_READY_LISTS)){
2630       cprintf("%s demoted, was %d, now %d\n", proc->name, proc->priority, proc->priority+1);
2631       proc->priority = proc->priority+ 1;
2632   }
2633 
2634   swtch(&proc->context, cpu->scheduler);
2635   cpu->intena = intena;
2636 }
2637 
2638 // Give up the CPU for one scheduling round.
2639 void
2640 yield(void)
2641 {
2642   acquire(&ptable.lock);  //DOC: yieldlock
2643   proc->state = RUNNABLE;
2644   enqueue(&ptable.ReadyList[proc->priority], proc);
2645   sched();
2646   release(&ptable.lock);
2647 }
2648 
2649 
2650 // A fork child's very first scheduling by scheduler()
2651 // will swtch here.  "Return" to user space.
2652 void
2653 forkret(void)
2654 {
2655   static int first = 1;
2656   // Still holding ptable.lock from scheduler.
2657   release(&ptable.lock);
2658 
2659   if (first) {
2660     // Some initialization functions must be run in the context
2661     // of a regular process (e.g., they call sleep), and thus cannot
2662     // be run from main().
2663     first = 0;
2664     iinit(ROOTDEV);
2665     initlog(ROOTDEV);
2666   }
2667 
2668   // Return to "caller", actually trapret (see allocproc).
2669 }
2670 
2671 // Atomically release lock and sleep on chan.
2672 // Reacquires lock when awakened.
2673 void
2674 sleep(void *chan, struct spinlock *lk)
2675 {
2676   if(proc == 0)
2677     panic("sleep");
2678 
2679   if(lk == 0)
2680     panic("sleep without lk");
2681 
2682   // Must acquire ptable.lock in order to
2683   // change p->state and then call sched.
2684   // Once we hold ptable.lock, we can be
2685   // guaranteed that we won't miss any wakeup
2686   // (wakeup runs with ptable.lock locked),
2687   // so it's okay to release lk.
2688   if(lk != &ptable.lock){  //DOC: sleeplock0
2689     acquire(&ptable.lock);  //DOC: sleeplock1
2690     release(lk);
2691   }
2692 
2693   // Go to sleep.
2694   proc->chan = chan;
2695   proc->state = SLEEPING;
2696   sched();
2697 
2698   // Tidy up.
2699   proc->chan = 0;
2700   // Reacquire original lock.
2701   if(lk != &ptable.lock){  //DOC: sleeplock2
2702     release(&ptable.lock);
2703     acquire(lk);
2704   }
2705 }
2706 
2707 // Wake up all processes sleeping on chan.
2708 // The ptable lock must be held.
2709 static void
2710 wakeup1(void *chan)
2711 {
2712   struct proc *p;
2713 
2714   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
2715     if(p->state == SLEEPING && p->chan == chan){
2716       p->state = RUNNABLE;
2717       enqueue(&ptable.ReadyList[0], p);
2718     }
2719 
2720 }
2721 
2722 // Wake up all processes sleeping on chan.
2723 void
2724 wakeup(void *chan)
2725 {
2726   acquire(&ptable.lock);
2727   wakeup1(chan);
2728   release(&ptable.lock);
2729 }
2730 
2731 // Kill the process with the given pid.
2732 // Process won't exit until it returns
2733 // to user space (see trap in trap.c).
2734 int
2735 kill(int pid)
2736 {
2737   struct proc *p;
2738 
2739   acquire(&ptable.lock);
2740   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2741     if(p->pid == pid){
2742       p->killed = 1;
2743       // Wake process from sleep if necessary.
2744       if(p->state == SLEEPING){
2745         p->state = RUNNABLE;
2746         enqueue(&ptable.ReadyList[0], p);
2747       }
2748       release(&ptable.lock);
2749       return 0;
2750     }
2751   }
2752   release(&ptable.lock);
2753   return -1;
2754 }
2755 
2756 // Print a process listing to console.  For debugging.
2757 // Runs when user types ^P on console.
2758 // No lock to avoid wedging a stuck machine further.
2759 void
2760 procdump(void)
2761 {
2762   static char *states[] = {
2763   [UNUSED]    "unused",
2764   [EMBRYO]    "embryo",
2765   [SLEEPING]  "sleep ",
2766   [RUNNABLE]  "runble",
2767   [RUNNING]   "run   ",
2768   [ZOMBIE]    "zombie"
2769   };
2770   int i;
2771   struct proc *p;
2772   char *state;
2773   uint pc[10];
2774 
2775   uint now;         //Snag the current ticks and cast
2776 
2777   acquire(&tickslock);
2778   now = (uint)ticks;
2779   release(&tickslock);
2780 
2781   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
2782     if(p->state == UNUSED)
2783       continue;
2784     if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
2785       state = states[p->state];
2786     else
2787       state = "???";
2788     cprintf("%d %s %s %d %d.%d %d.%d", p->pid, state, p->name, p->priority,
2789             (now - p->start_ticks) / 100,
2790             (now - p->start_ticks) % 100,
2791              p->cpu_ticks_total / 100,
2792              p->cpu_ticks_total % 100);
2793     if(p->state == SLEEPING){
2794       getcallerpcs((uint*)p->context->ebp+2, pc);
2795       for(i=0; i<10 && pc[i] != 0; i++)
2796         cprintf(" %p", pc[i]);
2797     }
2798     cprintf("\n");
2799   }
2800 }
2801 
2802 
2803 int
2804 sys_getprocs(void)
2805 {
2806 
2807   static char *states[] = {
2808   [UNUSED]    "unused",
2809   [EMBRYO]    "embryo",
2810   [SLEEPING]  "sleep ",
2811   [RUNNABLE]  "runble",
2812   [RUNNING]   "run   ",
2813   [ZOMBIE]    "zombie"
2814   };
2815 
2816   uint now;
2817   acquire(&tickslock);
2818   now = (uint)ticks;
2819   release(&tickslock);
2820 
2821 
2822     struct proc* p;
2823     struct uproc* up;
2824     int MAX = 0;
2825     int i = 0;
2826 
2827     if( argint(0, &MAX) == -1)
2828         return -1;
2829 
2830     if(argptr(1, (char**)&up, sizeof(*up)) < 0)
2831         return -1;
2832 
2833   acquire(&ptable.lock);
2834 
2835   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
2836   {
2837 
2838         if( p->state && i < MAX){
2839 
2840             up[i].pid = p->pid;
2841             up[i].uid = p->uid;
2842             up[i].gid = p->gid;
2843             up[i].CPU_total_ticks = p->cpu_ticks_total;
2844             up[i].elapsed_ticks = now - p->start_ticks;
2845             up[i].size = p->sz;
2846 //            up[i].priority = p->priority;
2847             safestrcpy(up[i].name, p->name, sizeof(p->name));
2848             safestrcpy(up[i].state, states[p->state], sizeof(p->state));
2849             if(up[i].pid == 1)
2850                 up[i].ppid = 1;
2851             else
2852                 up[i].ppid = p->parent->pid;
2853             i++;
2854         }
2855   }
2856   release(&ptable.lock);
2857   return i;
2858 }
2859 
2860 //Implementations for priority queue struct
2861 
2862 //Constructor set all values to null
2863 int
2864 queue(struct queue *this, struct proc *first )
2865 {
2866     this->head  = this->tail = first;         // This works fine even if the list is null
2867     return 0;                                 // it just feels more OO to have a constructor
2868                                               // and makes it more readable
2869 }
2870 
2871 // add process to the end of the list
2872 int
2873 enqueue(struct queue *this, struct proc *nproc){
2874 
2875       if(this->tail == 0){                  // If list is empty initialize
2876           return queue(this, nproc);
2877           return 0;
2878       }
2879 
2880       this->tail->next = nproc;            // Otherwise add it in as normal
2881       this->tail = nproc;
2882       this->tail->next = 0;
2883       return 0;
2884 }
2885 
2886 
2887 
2888 
2889 
2890 
2891 
2892 
2893 
2894 
2895 
2896 
2897 
2898 
2899 
2900 // take process from head of list
2901 struct proc*
2902 dequeue(struct queue *this){
2903 
2904      struct proc* nproc = 0;;
2905       if(this->tail == 0)
2906           return  nproc;
2907       if(this->tail == this->head){
2908           nproc = this->tail;
2909           this->head = 0;
2910           this->tail = 0;
2911           nproc->next = 0;
2912           return nproc;
2913         }
2914       nproc = this->head;
2915       this->head = this->head->next;
2916       nproc->next = 0;
2917       return nproc;
2918 
2919 }
2920 
2921 int
2922 updateBudget(struct proc * this, int now){
2923 
2924     this->budget = this->budget - (now - this->cpu_ticks_in);
2925     if(this->budget <=0){
2926         this->budget = INITBUDGET;
2927         return 1;
2928     }
2929     return 0;
2930 }
2931 
2932 void
2933 promote(){
2934 
2935     int i = 1;
2936     struct proc * p;
2937     for(i = 1;  i < NUM_READY_LISTS; i++){
2938         p = dequeue(&ptable.ReadyList[i]);
2939         if(p == 0)
2940             continue;
2941         p->budget = INITBUDGET;
2942         p->priority = p->priority - 1;
2943         enqueue(&ptable.ReadyList[p->priority - 1], p);
2944     }
2945 }
2946 
2947 
2948 
2949 
