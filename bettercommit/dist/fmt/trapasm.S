3200 #include "mmu.h"
3201 
3202   # vectors.S sends all traps here.
3203 .globl alltraps
3204 alltraps:
3205   # Build trap frame.
3206   pushl %ds
3207   pushl %es
3208   pushl %fs
3209   pushl %gs
3210   pushal
3211 
3212   # Set up data and per-cpu segments.
3213   movw $(SEG_KDATA<<3), %ax
3214   movw %ax, %ds
3215   movw %ax, %es
3216   movw $(SEG_KCPU<<3), %ax
3217   movw %ax, %fs
3218   movw %ax, %gs
3219 
3220   # Call trap(tf), where tf=%esp
3221   pushl %esp
3222   call trap
3223   addl $4, %esp
3224 
3225   # Return falls through to trapret...
3226 .globl trapret
3227 trapret:
3228   popal
3229   popl %gs
3230   popl %fs
3231   popl %es
3232   popl %ds
3233   addl $0x8, %esp  # trapno and errcode
3234   iret
3235 
3236 
3237 
3238 
3239 
3240 
3241 
3242 
3243 
3244 
3245 
3246 
3247 
3248 
3249 
