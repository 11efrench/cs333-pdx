#include "types.h"
#include "user.h"
#include "stat.h"
int 
convert(char set, char owner, char group, char other)
{
    
    int nset, nowner, ngroup, nother;

    nset = atoi(&set);
    nowner = atoi(&owner);
    ngroup = atoi(&group);
    nother = atoi(&other);
    
    if(nset    < 0 || nset    > 1 || nowner  < 0 || nowner  > 7 || ngroup  < 0 || ngroup  > 7 || nother  < 0 || nother  > 7)
        return -1;
    nset    = nset << 9;
    nowner  = nowner << 6;
    ngroup  = ngroup << 3;

    return nset | nowner | ngroup | nother;
}

int
main(int argc, char* argv[])
{
    char * path;
    struct stat st;
    int fd;
    int mode;
    int rc;
    path = argv[2];
    
    if( (mode  = convert(argv[1][0], argv[1][1], argv[1][2], argv[1][3]))  < 0){
        printf(1, "Bad mode\n");
        exit();
    }

    if(argc < 3) {
      printf(1, "Usage: change gid for file \n");
      exit();
    }

    if((fd = open(path,  0)) < 0 )
    {
      printf(1, "Failed to open specified file\n");
      exit();
    }
    
    if(fstat(fd, &st) < 0) 
    {
        printf(1, "Cannot pull stat from specified file\n");
        exit();
    }
    close(fd);
    
    rc = chmod(path, mode);
    if(rc  < 0) 
        printf(1, "Change User Failed.\n");

    exit();
    
}
