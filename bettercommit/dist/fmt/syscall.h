3400 // System call numbers
3401 #define SYS_fork    1
3402 #define SYS_exit    SYS_fork+1
3403 #define SYS_wait    SYS_exit+1
3404 #define SYS_pipe    SYS_wait+1
3405 #define SYS_read    SYS_pipe+1
3406 #define SYS_kill    SYS_read+1
3407 #define SYS_exec    SYS_kill+1
3408 #define SYS_fstat   SYS_exec+1
3409 #define SYS_chdir   SYS_fstat+1
3410 #define SYS_dup     SYS_chdir+1
3411 #define SYS_getpid  SYS_dup+1
3412 #define SYS_sbrk    SYS_getpid+1
3413 #define SYS_sleep   SYS_sbrk+1
3414 #define SYS_uptime  SYS_sleep+1
3415 #define SYS_open    SYS_uptime+1
3416 #define SYS_write   SYS_open+1
3417 #define SYS_mknod   SYS_write+1
3418 #define SYS_unlink  SYS_mknod+1
3419 #define SYS_link    SYS_unlink+1
3420 #define SYS_mkdir   SYS_link+1
3421 #define SYS_close   SYS_mkdir+1
3422 #define SYS_halt    SYS_close+1
3423 // student system calls begin here. Follow the existing pattern.
3424 
3425 #define SYS_date       SYS_halt+1
3426 
3427 #define SYS_getuid     SYS_date+1
3428 #define SYS_getgid     SYS_getuid+1
3429 #define SYS_getppid    SYS_getgid+1
3430 
3431 #define SYS_setuid     SYS_getppid+1
3432 #define SYS_setgid     SYS_setuid+1
3433 #define SYS_getprocs   SYS_setgid+1
3434 
3435 // Project 3
3436 #define SYS_setpriority SYS_getprocs+1
3437 
3438 
3439 
3440 
3441 
3442 
3443 
3444 
3445 
3446 
3447 
3448 
3449 
