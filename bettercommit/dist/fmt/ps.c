9250 #include "types.h"
9251 #include "user.h"
9252 #include "uproc.h"
9253 
9254 //This is a SHELL PROGRAM that should only
9255 //be used to EXECUTE SYSTEM CALLS
9256 
9257 int main (int argc, char* argv[]){
9258 
9259 
9260     //contains all the pieces of time
9261     //with resolution of one second
9262     struct uproc* up;
9263     int MAX = 64;
9264     char  *n = "Name",
9265           *p = "PID",
9266           *u = "UID",
9267           *g = "GID",
9268           *pp = "PPID",
9269           *tot = "CPU (s)",
9270           *e = "Elapsed (s)",
9271           *st = "State",
9272           *si = "Size";
9273 //          *pr = "Priority";
9274 
9275     up =  malloc( sizeof(&up) * MAX);
9276     MAX =  getprocs(MAX, up);
9277 
9278     if(MAX < 0){
9279         printf(1, "getprocs failed\n");
9280     exit();
9281     }
9282 
9283 
9284     printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n",
9285                 n, p,u,g,pp, tot,e,st,si);
9286     for(int  i = 0; i < MAX; i++){
9287 
9288        printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t |  %d.%d\t | %d.%d\t | %s\t | %d\t | \n",
9289                      up[i].name, up[i].pid, up[i].uid, up[i].gid,
9290                      up[i].ppid,  up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100,
9291                      up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100,
9292                      up[i].state, up[i].size);
9293 
9294     }
9295 
9296     exit();
9297 }
9298 
9299 
