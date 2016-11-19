9200 #include "types.h"
9201 #include "user.h"
9202 
9203 //This is a SHELL PROGRAM that should only
9204 //be used to EXECUTE SYSTEM CALLS
9205 
9206 int main (int argc, char* argv[]){
9207 
9208 
9209   if( argc < 2)
9210       printf(1, "Usage: Report runtime of programs provided as arguments, no arguments provided\n");
9211 
9212 
9213   uint start = (uint)uptime();
9214   uint finish = 0;
9215   uint pid = fork();
9216 
9217   if(pid == 0 ){
9218 
9219       if(exec(argv[1], argv +1)){
9220           printf(1, "Exec Failed");
9221           exit();
9222       }
9223   }
9224   else{
9225     wait();
9226   }
9227 
9228     finish  = (uint)uptime();
9229     printf(1, "%s took %d.%d time to run\n", argv[1], (finish - start) / 100, (finish - start) % 100);
9230 
9231   exit();
9232 }
9233 
9234 
9235 
9236 
9237 
9238 
9239 
9240 
9241 
9242 
9243 
9244 
9245 
9246 
9247 
9248 
9249 
