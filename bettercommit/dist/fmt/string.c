6500 #include "types.h"
6501 #include "x86.h"
6502 
6503 void*
6504 memset(void *dst, int c, uint n)
6505 {
6506   if ((int)dst%4 == 0 && n%4 == 0){
6507     c &= 0xFF;
6508     stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
6509   } else
6510     stosb(dst, c, n);
6511   return dst;
6512 }
6513 
6514 int
6515 memcmp(const void *v1, const void *v2, uint n)
6516 {
6517   const uchar *s1, *s2;
6518 
6519   s1 = v1;
6520   s2 = v2;
6521   while(n-- > 0){
6522     if(*s1 != *s2)
6523       return *s1 - *s2;
6524     s1++, s2++;
6525   }
6526 
6527   return 0;
6528 }
6529 
6530 void*
6531 memmove(void *dst, const void *src, uint n)
6532 {
6533   const char *s;
6534   char *d;
6535 
6536   s = src;
6537   d = dst;
6538   if(s < d && s + n > d){
6539     s += n;
6540     d += n;
6541     while(n-- > 0)
6542       *--d = *--s;
6543   } else
6544     while(n-- > 0)
6545       *d++ = *s++;
6546 
6547   return dst;
6548 }
6549 
6550 // memcpy exists to placate GCC.  Use memmove.
6551 void*
6552 memcpy(void *dst, const void *src, uint n)
6553 {
6554   return memmove(dst, src, n);
6555 }
6556 
6557 int
6558 strncmp(const char *p, const char *q, uint n)
6559 {
6560   while(n > 0 && *p && *p == *q)
6561     n--, p++, q++;
6562   if(n == 0)
6563     return 0;
6564   return (uchar)*p - (uchar)*q;
6565 }
6566 
6567 char*
6568 strncpy(char *s, const char *t, int n)
6569 {
6570   char *os;
6571 
6572   os = s;
6573   while(n-- > 0 && (*s++ = *t++) != 0)
6574     ;
6575   while(n-- > 0)
6576     *s++ = 0;
6577   return os;
6578 }
6579 
6580 // Like strncpy but guaranteed to NUL-terminate.
6581 char*
6582 safestrcpy(char *s, const char *t, int n)
6583 {
6584   char *os;
6585 
6586   os = s;
6587   if(n <= 0)
6588     return os;
6589   while(--n > 0 && (*s++ = *t++) != 0)
6590     ;
6591   *s = 0;
6592   return os;
6593 }
6594 
6595 
6596 
6597 
6598 
6599 
6600 int
6601 strlen(const char *s)
6602 {
6603   int n;
6604 
6605   for(n = 0; s[n]; n++)
6606     ;
6607   return n;
6608 }
6609 
6610 
6611 
6612 
6613 
6614 
6615 
6616 
6617 
6618 
6619 
6620 
6621 
6622 
6623 
6624 
6625 
6626 
6627 
6628 
6629 
6630 
6631 
6632 
6633 
6634 
6635 
6636 
6637 
6638 
6639 
6640 
6641 
6642 
6643 
6644 
6645 
6646 
6647 
6648 
6649 
