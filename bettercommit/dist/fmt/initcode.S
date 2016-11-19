8050 # Initial process execs /init.
8051 
8052 #include "syscall.h"
8053 #include "traps.h"
8054 
8055 
8056 # exec(init, argv)
8057 .globl start
8058 start:
8059   pushl $argv
8060   pushl $init
8061   pushl $0  // where caller pc would be
8062   movl $SYS_exec, %eax
8063   int $T_SYSCALL
8064 
8065 # for(;;) exit();
8066 exit:
8067   movl $SYS_exit, %eax
8068   int $T_SYSCALL
8069   jmp exit
8070 
8071 # char init[] = "/init\0";
8072 init:
8073   .string "/init\0"
8074 
8075 # char *argv[] = { init, 0 };
8076 .p2align 2
8077 argv:
8078   .long init
8079   .long 0
8080 
8081 
8082 
8083 
8084 
8085 
8086 
8087 
8088 
8089 
8090 
8091 
8092 
8093 
8094 
8095 
8096 
8097 
8098 
8099 
