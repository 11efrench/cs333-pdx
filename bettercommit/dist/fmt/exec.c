6200 #include "types.h"
6201 #include "param.h"
6202 #include "memlayout.h"
6203 #include "mmu.h"
6204 #include "proc.h"
6205 #include "defs.h"
6206 #include "x86.h"
6207 #include "elf.h"
6208 
6209 int
6210 exec(char *path, char **argv)
6211 {
6212   char *s, *last;
6213   int i, off;
6214   uint argc, sz, sp, ustack[3+MAXARG+1];
6215   struct elfhdr elf;
6216   struct inode *ip;
6217   struct proghdr ph;
6218   pde_t *pgdir, *oldpgdir;
6219 
6220   begin_op();
6221   if((ip = namei(path)) == 0){
6222     end_op();
6223     return -1;
6224   }
6225   ilock(ip);
6226   pgdir = 0;
6227 
6228   // Check ELF header
6229   if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
6230     goto bad;
6231   if(elf.magic != ELF_MAGIC)
6232     goto bad;
6233 
6234   if((pgdir = setupkvm()) == 0)
6235     goto bad;
6236 
6237   // Load program into memory.
6238   sz = 0;
6239   for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
6240     if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
6241       goto bad;
6242     if(ph.type != ELF_PROG_LOAD)
6243       continue;
6244     if(ph.memsz < ph.filesz)
6245       goto bad;
6246     if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
6247       goto bad;
6248     if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
6249       goto bad;
6250   }
6251   iunlockput(ip);
6252   end_op();
6253   ip = 0;
6254 
6255   // Allocate two pages at the next page boundary.
6256   // Make the first inaccessible.  Use the second as the user stack.
6257   sz = PGROUNDUP(sz);
6258   if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
6259     goto bad;
6260   clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
6261   sp = sz;
6262 
6263   // Push argument strings, prepare rest of stack in ustack.
6264   for(argc = 0; argv[argc]; argc++) {
6265     if(argc >= MAXARG)
6266       goto bad;
6267     sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
6268     if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
6269       goto bad;
6270     ustack[3+argc] = sp;
6271   }
6272   ustack[3+argc] = 0;
6273 
6274   ustack[0] = 0xffffffff;  // fake return PC
6275   ustack[1] = argc;
6276   ustack[2] = sp - (argc+1)*4;  // argv pointer
6277 
6278   sp -= (3+argc+1) * 4;
6279   if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
6280     goto bad;
6281 
6282   // Save program name for debugging.
6283   for(last=s=path; *s; s++)
6284     if(*s == '/')
6285       last = s+1;
6286   safestrcpy(proc->name, last, sizeof(proc->name));
6287 
6288   // Commit to the user image.
6289   oldpgdir = proc->pgdir;
6290   proc->pgdir = pgdir;
6291   proc->sz = sz;
6292   proc->tf->eip = elf.entry;  // main
6293   proc->tf->esp = sp;
6294   switchuvm(proc);
6295   freevm(oldpgdir);
6296   return 0;
6297 
6298 
6299 
6300  bad:
6301   if(pgdir)
6302     freevm(pgdir);
6303   if(ip){
6304     iunlockput(ip);
6305     end_op();
6306   }
6307   return -1;
6308 }
6309 
6310 
6311 
6312 
6313 
6314 
6315 
6316 
6317 
6318 
6319 
6320 
6321 
6322 
6323 
6324 
6325 
6326 
6327 
6328 
6329 
6330 
6331 
6332 
6333 
6334 
6335 
6336 
6337 
6338 
6339 
6340 
6341 
6342 
6343 
6344 
6345 
6346 
6347 
6348 
6349 
