8150 // init: The initial user-level program
8151 
8152 #include "types.h"
8153 #include "stat.h"
8154 #include "user.h"
8155 #include "fcntl.h"
8156 
8157 char *argv[] = { "sh", 0 };
8158 
8159 int
8160 main(void ){
8161 
8162   int pid, wpid;
8163 
8164   if(open("console", O_RDWR) < 0){
8165     mknod("console", 1, 1);
8166     open("console", O_RDWR);
8167   }
8168   dup(0);  // stdout
8169   dup(0);  // stderr
8170 
8171   for(;;){
8172     printf(1, "init: starting sh\n");
8173     pid = fork();
8174     if(pid < 0){
8175       printf(1, "init: fork failed\n");
8176       exit();
8177     }
8178     if(pid == 0){
8179       exec("sh", argv);
8180       printf(1, "init: exec sh failed\n");
8181       exit();
8182     }
8183     while((wpid=wait()) >= 0 && wpid != pid)
8184       printf(1, "zombie!\n");
8185   }
8186 }
8187 
8188 
8189 
8190 
8191 
8192 
8193 
8194 
8195 
8196 
8197 
8198 
8199 
