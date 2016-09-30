#include "types.h" 
#include "user.h"
#include "date.h"

//This is a SHELL PROGRAM that should only
//be used to EXECUTE SYSTEM CALLS

int main (int argc, char* argv[]){

    
    //contains all the pieces of time
    //with resolution of one second
    struct rtcdate r;

    if (date(&r)) {

        printf(2, "Date_failed\n");
        exit();
    }

    date(&r);
    exit();
}
        

