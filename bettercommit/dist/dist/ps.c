#include "types.h" 
#include "user.h"
#include "uproc.h"

//This is a SHELL PROGRAM that should only
//be used to EXECUTE SYSTEM CALLS

int main (int argc, char* argv[]){

    
    //contains all the pieces of time
    //with resolution of one second
    struct uproc* up;
    int MAX = 64; 
    char  *n = "Name", 
          *p = "PID",
          *u = "UID",
          *g = "GID",
          *pp = "PPID",
          *tot = "CPU (s)",
          *e = "Elapsed (s)",
          *st = "State",
          *si = "Size";
//          *pr = "Priority";

    up =  malloc( sizeof(&up) * MAX);
    MAX =  getprocs(MAX, up);
    
    if(MAX < 0){
        printf(1, "getprocs failed\n");
    exit();
    }
    
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp, tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t |  %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid,  up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
                     up[i].state, up[i].size);

    }
    
    exit();
}
        

