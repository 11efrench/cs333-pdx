#include "types.h" 
#include "user.h"
#include "date.h"


int main (int argc, char* argv[]){
{
    
    //contains all the pieces of time
    //with resolution of one second
    struct rtcdate r;
    r  = cmostime(&r);  //fill r

    if (date(&r)) {

        printf(2, "Date_failed\n");
        exit();
    }

    //date exists
    cprintf(" day: %d /
              month: %d /
              year: %d \t 
              hour: %d
              minute: %d 
              second: %d \n",
              r.day, r.month, r.year, r.hour, r.minute, r.second);


    exit();
}
        

