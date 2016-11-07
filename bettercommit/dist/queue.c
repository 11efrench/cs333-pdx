
/*

#include "queue.h"
#include "proc.h"
//Implementations for priority queue struct

//Constructor set all values to null
int
queue(struct queue *this, struct proc *first )
{
    this->head = this->tail = first;         // This works fine even if the list is null
    return 0;                                // it just feels more OO to have a constructor
                                             // and makes it more readable
}

// add process to the end of the list
int 
enqueue(struct queue *this, struct proc *nproc){

    if(this->tail == 0){               // Empty list
      this->head = this->tail = nproc;
      return 0;
    }
    else{                        // Non empty list
      this->tail->next = nproc;
      this->tail = nproc;
      return 0;
    }

    return -1;                   // Error!! Should never happen
}

// take process from head of list
struct proc* 
dequeue(struct queue *this){

    if(this->head == 0)                // Empy list, return error
      return 0;               
    else{                        // Non empty list
      struct proc* temp;
      temp = this->head;
      this->head = this->head->next;
      return temp ;  
    }

    return 0;                   //Error!! Should never execute
}
*/
