3100 // x86 trap and interrupt constants.
3101 
3102 // Processor-defined:
3103 #define T_DIVIDE         0      // divide error
3104 #define T_DEBUG          1      // debug exception
3105 #define T_NMI            2      // non-maskable interrupt
3106 #define T_BRKPT          3      // breakpoint
3107 #define T_OFLOW          4      // overflow
3108 #define T_BOUND          5      // bounds check
3109 #define T_ILLOP          6      // illegal opcode
3110 #define T_DEVICE         7      // device not available
3111 #define T_DBLFLT         8      // double fault
3112 // #define T_COPROC      9      // reserved (not used since 486)
3113 #define T_TSS           10      // invalid task switch segment
3114 #define T_SEGNP         11      // segment not present
3115 #define T_STACK         12      // stack exception
3116 #define T_GPFLT         13      // general protection fault
3117 #define T_PGFLT         14      // page fault
3118 // #define T_RES        15      // reserved
3119 #define T_FPERR         16      // floating point error
3120 #define T_ALIGN         17      // aligment check
3121 #define T_MCHK          18      // machine check
3122 #define T_SIMDERR       19      // SIMD floating point error
3123 
3124 // These are arbitrarily chosen, but with care not to overlap
3125 // processor defined exceptions or interrupt vectors.
3126 #define T_SYSCALL       64      // system call
3127 #define T_DEFAULT      500      // catchall
3128 
3129 #define T_IRQ0          32      // IRQ 0 corresponds to int T_IRQ
3130 
3131 #define IRQ_TIMER        0
3132 #define IRQ_KBD          1
3133 #define IRQ_COM1         4
3134 #define IRQ_IDE         14
3135 #define IRQ_ERROR       19
3136 #define IRQ_SPURIOUS    31
3137 
3138 
3139 
3140 
3141 
3142 
3143 
3144 
3145 
3146 
3147 
3148 
3149 
