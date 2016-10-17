#include "types.h" 
#include "user.h"

//This is a SHELL PROGRAM that should only
//be used to EXECUTE SYSTEM CALLS

int main (int argc, char* argv[]){


  if( argc < 2) 
      printf(1, "Usage: Report runtime of programs provided as arguments, no arguments provided\n");

  
  uint start = (uint)uptime();
  uint finish = 0;
  uint pid = fork();

  if(pid == 0 ){

      if(exec(argv[1], argv +1)){
          printf(1, "Exec Failed");
          exit();
      }
  }
  else{
    wait();
  }

    finish  = (uint)uptime();
    printf(1, "%s took %d.%d time to run\n", argv[1], (finish - start) / 100, (finish - start) % 100);
  
  exit();
}
        

