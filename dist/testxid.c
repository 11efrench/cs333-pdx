#include "types.h"
#include "user.h"


//tests the functionality of system calls for Project 2 
int main(int argc, char* argv[])
{

    
    uint uid, gid, ppid;

    uid = getuid();
    printf(2, "current uid is: %d\n", uid);
    printf(2, "setting uid to 100\n");
    setuid(100);
    uid = getuid();
    printf(2, "current uid is: %d\n", uid);

    gid = getgid();
    printf(2, "current gid is: %d\n", gid);
    printf(2, "setting gid to 100\n");
    setuid(100);
    gid = getuid();
    printf(2, "current gid is: %d\n", gid);

    ppid = getppid();
    printf(2, "My parent process is: %d\n", ppid);
    printf(2, "Test Over\n");

    exit();

    
}
