9150 #include "types.h"
9151 #include "user.h"
9152 #include "date.h"
9153 
9154 //This is a SHELL PROGRAM that should only
9155 //be used to EXECUTE SYSTEM CALLS
9156 
9157 int main (int argc, char* argv[]){
9158 
9159 
9160     //contains all the pieces of time
9161     //with resolution of one second
9162     struct rtcdate r;
9163 
9164     if (date(&r)) {
9165 
9166         printf(2, "Date_failed\n");
9167         exit();
9168     }
9169 
9170     if( date(&r) == 0){
9171         printf(1, "day: %d month: %d year: %d \t hour: %d minute: %d second: %d \n", r.day, r.month, r.year, r.hour, r.minute, r.second);
9172         exit();
9173     }
9174 }
9175 
9176 
9177 
9178 
9179 
9180 
9181 
9182 
9183 
9184 
9185 
9186 
9187 
9188 
9189 
9190 
9191 
9192 
9193 
9194 
9195 
9196 
9197 
9198 
9199 
