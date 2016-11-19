2050 // Segments in proc->gdt.
2051 #define NSEGS     7
2052 #define INITUID 0
2053 #define INITGID 0
2054 #define NUM_READY_LISTS 5
2055 #define TICKS_TO_PROMOTE 100
2056 #define INITBUDGET 50
2057 
2058 // Per-CPU state
2059 struct cpu {
2060   uchar id;                    // Local APIC ID; index into cpus[] below
2061   struct context *scheduler;   // swtch() here to enter scheduler
2062   struct taskstate ts;         // Used by x86 to find stack for interrupt
2063   struct segdesc gdt[NSEGS];   // x86 global descriptor table
2064   volatile uint started;       // Has the CPU started?
2065   int ncli;                    // Depth of pushcli nesting.
2066   int intena;                  // Were interrupts enabled before pushcli?
2067 
2068   // Cpu-local storage variables; see below
2069   struct cpu *cpu;
2070   struct proc *proc;           // The currently-running process.
2071 };
2072 
2073 extern struct cpu cpus[NCPU];
2074 extern int ncpu;
2075 
2076 // Per-CPU variables, holding pointers to the
2077 // current cpu and to the current process.
2078 // The asm suffix tells gcc to use "%gs:0" to refer to cpu
2079 // and "%gs:4" to refer to proc.  seginit sets up the
2080 // %gs segment register so that %gs refers to the memory
2081 // holding those two variables in the local cpu's struct cpu.
2082 // This is similar to how thread-local variables are implemented
2083 // in thread libraries such as Linux pthreads.
2084 extern struct cpu *cpu asm("%gs:0");       // &cpus[cpunum()]
2085 extern struct proc *proc asm("%gs:4");     // cpus[cpunum()].proc
2086 
2087 // Saved registers for kernel context switches.
2088 // Don't need to save all the segment registers (%cs, etc),
2089 // because they are constant across kernel contexts.
2090 // Don't need to save %eax, %ecx, %edx, because the
2091 // x86 convention is that the caller has saved them.
2092 // Contexts are stored at the bottom of the stack they
2093 // describe; the stack pointer is the address of the context.
2094 // The layout of the context matches the layout of the stack in swtch.S
2095 // at the "Switch stacks" comment. Switch doesn't save eip explicitly,
2096 // but it is on the stack and allocproc() manipulates it.
2097 struct context {
2098   uint edi;
2099   uint esi;
2100   uint ebx;
2101   uint ebp;
2102   uint eip;
2103 };
2104 
2105 enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
2106 
2107 // Per-process state
2108 struct proc {
2109   uint sz;                     // Size of process memory (bytes)
2110   pde_t* pgdir;                // Page table
2111   char *kstack;                // Bottom of kernel stack for this process
2112   enum procstate state;        // Process state
2113   uint pid;                    // Process ID
2114   struct proc *parent;         // Parent process
2115   struct trapframe *tf;        // Trap frame for current syscall
2116   struct context *context;     // swtch() here to run process
2117   void *chan;                  // If non-zero, sleeping on chan
2118   int killed;                  // If non-zero, have been killed
2119   struct file *ofile[NOFILE];  // Open files
2120   struct inode *cwd;           // Current directory
2121   char name[16];               // Process name (debugging)
2122 
2123   //STUDENT IMPLEMENTATION
2124   uint start_ticks;            // Start time
2125   uint uid;                    // User ID Number
2126   uint gid;                    // Group ID Number
2127   uint cpu_ticks_total;        // Amount of ticks
2128   uint cpu_ticks_in;           // Total ticks spent in cpu
2129   uint priority;               // The priority of this process
2130   struct proc* next;           // Points to next process in the same list
2131   int budget;                 // Ticks Before Aging
2132 
2133 };
2134 
2135 // Process memory is laid out contiguously, low addresses first:
2136 //   text
2137 //   original data and bss
2138 //   fixed-size stack
2139 //   expandable heap
2140 
2141 
2142 
2143 
2144 
2145 
2146 
2147 
2148 
2149 
