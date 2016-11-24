#include "types.h"
#include "user.h"
#include "stat.h"
int
main(int argc, char* argv[])
{
    char * path;
    struct stat st;
    int fd;
    int uid;
    int rc;
    path = argv[2];
    uid = atoi(argv[1]);
    
    if(argc < 3) {
      printf(1, "Usage: change uid for file \n");
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
    
    rc = chown(path, uid);
    if(rc  < 0) 
        printf(1, "Change User Failed.\n");

    exit();
    
}
