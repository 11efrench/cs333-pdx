8100 #include "syscall.h"
8101 #include "traps.h"
8102 
8103 #define SYSCALL(name) \
8104   .globl name; \
8105   name: \
8106     movl $SYS_ ## name, %eax; \
8107     int $T_SYSCALL; \
8108     ret
8109 
8110 SYSCALL(fork)
8111 SYSCALL(exit)
8112 SYSCALL(wait)
8113 SYSCALL(pipe)
8114 SYSCALL(read)
8115 SYSCALL(write)
8116 SYSCALL(close)
8117 SYSCALL(kill)
8118 SYSCALL(exec)
8119 SYSCALL(open)
8120 SYSCALL(mknod)
8121 SYSCALL(unlink)
8122 SYSCALL(fstat)
8123 SYSCALL(link)
8124 SYSCALL(mkdir)
8125 SYSCALL(chdir)
8126 SYSCALL(dup)
8127 SYSCALL(getpid)
8128 SYSCALL(sbrk)
8129 SYSCALL(sleep)
8130 SYSCALL(uptime)
8131 SYSCALL(halt)
8132 //Student Implementations
8133 SYSCALL(date)
8134 
8135 SYSCALL(getuid)
8136 SYSCALL(getgid)
8137 SYSCALL(getppid)
8138 
8139 SYSCALL(setuid)
8140 SYSCALL(setgid)
8141 SYSCALL(getprocs)
8142 // Project 3
8143 SYSCALL(setpriority)
8144 
8145 
8146 
8147 
8148 
8149 
