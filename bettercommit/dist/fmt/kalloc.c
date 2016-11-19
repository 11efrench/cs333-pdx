3000 // Physical memory allocator, intended to allocate
3001 // memory for user processes, kernel stacks, page table pages,
3002 // and pipe buffers. Allocates 4096-byte pages.
3003 
3004 #include "types.h"
3005 #include "defs.h"
3006 #include "param.h"
3007 #include "memlayout.h"
3008 #include "mmu.h"
3009 #include "spinlock.h"
3010 
3011 void freerange(void *vstart, void *vend);
3012 extern char end[]; // first address after kernel loaded from ELF file
3013 
3014 struct run {
3015   struct run *next;
3016 };
3017 
3018 struct {
3019   struct spinlock lock;
3020   int use_lock;
3021   struct run *freelist;
3022 } kmem;
3023 
3024 // Initialization happens in two phases.
3025 // 1. main() calls kinit1() while still using entrypgdir to place just
3026 // the pages mapped by entrypgdir on free list.
3027 // 2. main() calls kinit2() with the rest of the physical pages
3028 // after installing a full page table that maps them on all cores.
3029 void
3030 kinit1(void *vstart, void *vend)
3031 {
3032   initlock(&kmem.lock, "kmem");
3033   kmem.use_lock = 0;
3034   freerange(vstart, vend);
3035 }
3036 
3037 void
3038 kinit2(void *vstart, void *vend)
3039 {
3040   freerange(vstart, vend);
3041   kmem.use_lock = 1;
3042 }
3043 
3044 
3045 
3046 
3047 
3048 
3049 
3050 void
3051 freerange(void *vstart, void *vend)
3052 {
3053   char *p;
3054   p = (char*)PGROUNDUP((uint)vstart);
3055   for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
3056     kfree(p);
3057 }
3058 
3059 // Free the page of physical memory pointed at by v,
3060 // which normally should have been returned by a
3061 // call to kalloc().  (The exception is when
3062 // initializing the allocator; see kinit above.)
3063 void
3064 kfree(char *v)
3065 {
3066   struct run *r;
3067 
3068   if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
3069     panic("kfree");
3070 
3071   // Fill with junk to catch dangling refs.
3072   memset(v, 1, PGSIZE);
3073 
3074   if(kmem.use_lock)
3075     acquire(&kmem.lock);
3076   r = (struct run*)v;
3077   r->next = kmem.freelist;
3078   kmem.freelist = r;
3079   if(kmem.use_lock)
3080     release(&kmem.lock);
3081 }
3082 
3083 // Allocate one 4096-byte page of physical memory.
3084 // Returns a pointer that the kernel can use.
3085 // Returns 0 if the memory cannot be allocated.
3086 char*
3087 kalloc(void)
3088 {
3089   struct run *r;
3090 
3091   if(kmem.use_lock)
3092     acquire(&kmem.lock);
3093   r = kmem.freelist;
3094   if(r)
3095     kmem.freelist = r->next;
3096   if(kmem.use_lock)
3097     release(&kmem.lock);
3098   return (char*)r;
3099 }
