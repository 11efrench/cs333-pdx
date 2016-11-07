#include "types.h"
#include "user.h"

// PrioCount should be set to the nummber of priority levels
#define PrioCount 10
#define numChildren 10

void
countForever(int p)
{
  int j;
 // unsigned long count = 0;

  j = getpid();
  //p = p%PrioCount;
  setpriority(j, p);
  printf(1, "%d: start prio %d\n", j, p);

  while (1) {
   // count++;
   // if ((count & 0xFFFFFFF) == 0) {
      //p = (p+1) % PrioCount;
      //setpriority(j, p);
      //printf(1, "%d: new prio %d\n", j, p);
    //}
  }
}

int
main(int argc, char *argv[])
{
  int i, rc;

  for (i=0; i<numChildren; i++) {
    rc = fork();
    if (!rc) { // child
      countForever(i);
    }
  }

  

  // what the heck, let's have the parent waste time as well!
  countForever(0);
  exit();
}