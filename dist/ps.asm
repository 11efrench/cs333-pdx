
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "uproc.h"

//This is a SHELL PROGRAM that should only
//be used to EXECUTE SYSTEM CALLS

int main (int argc, char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 58             	sub    $0x58,%esp

    
    //contains all the pieces of time
    //with resolution of one second
    struct uproc* up;
    int MAX = 64; 
  14:	c7 45 e0 40 00 00 00 	movl   $0x40,-0x20(%ebp)
    char  *n = "Name", 
  1b:	c7 45 dc c8 09 00 00 	movl   $0x9c8,-0x24(%ebp)
          *p = "PID",
  22:	c7 45 d8 cd 09 00 00 	movl   $0x9cd,-0x28(%ebp)
          *u = "UID",
  29:	c7 45 d4 d1 09 00 00 	movl   $0x9d1,-0x2c(%ebp)
          *g = "GID",
  30:	c7 45 d0 d5 09 00 00 	movl   $0x9d5,-0x30(%ebp)
          *pp = "PPID",
  37:	c7 45 cc d9 09 00 00 	movl   $0x9d9,-0x34(%ebp)
          *tot = "CPU (s)",
  3e:	c7 45 c8 de 09 00 00 	movl   $0x9de,-0x38(%ebp)
          *e = "Elapsed (s)",
  45:	c7 45 c4 e6 09 00 00 	movl   $0x9e6,-0x3c(%ebp)
          *st = "State",
  4c:	c7 45 c0 f2 09 00 00 	movl   $0x9f2,-0x40(%ebp)
          *si = "Size";
  53:	c7 45 bc f8 09 00 00 	movl   $0x9f8,-0x44(%ebp)
 
    up =  malloc( sizeof(&up) * MAX);
  5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  5d:	c1 e0 02             	shl    $0x2,%eax
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	50                   	push   %eax
  64:	e8 7c 08 00 00       	call   8e5 <malloc>
  69:	83 c4 10             	add    $0x10,%esp
  6c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    MAX =  getprocs(MAX, up);
  6f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  75:	83 ec 08             	sub    $0x8,%esp
  78:	52                   	push   %edx
  79:	50                   	push   %eax
  7a:	e8 b4 04 00 00       	call   533 <getprocs>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	89 45 e0             	mov    %eax,-0x20(%ebp)
    
    if(MAX < 0){
  85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  89:	79 17                	jns    a2 <main+0xa2>
        printf(1, "getprocs failed\n");
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 fd 09 00 00       	push   $0x9fd
  93:	6a 01                	push   $0x1
  95:	e8 78 05 00 00       	call   612 <printf>
  9a:	83 c4 10             	add    $0x10,%esp
    exit();
  9d:	e8 b9 03 00 00       	call   45b <exit>
    }
    
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
  a2:	83 ec 04             	sub    $0x4,%esp
  a5:	ff 75 bc             	pushl  -0x44(%ebp)
  a8:	ff 75 c0             	pushl  -0x40(%ebp)
  ab:	ff 75 c4             	pushl  -0x3c(%ebp)
  ae:	ff 75 c8             	pushl  -0x38(%ebp)
  b1:	ff 75 cc             	pushl  -0x34(%ebp)
  b4:	ff 75 d0             	pushl  -0x30(%ebp)
  b7:	ff 75 d4             	pushl  -0x2c(%ebp)
  ba:	ff 75 d8             	pushl  -0x28(%ebp)
  bd:	ff 75 dc             	pushl  -0x24(%ebp)
  c0:	68 10 0a 00 00       	push   $0xa10
  c5:	6a 01                	push   $0x1
  c7:	e8 46 05 00 00       	call   612 <printf>
  cc:	83 c4 30             	add    $0x30,%esp
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
  cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  d6:	e9 18 01 00 00       	jmp    1f3 <main+0x1f3>
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
                     up[i].state, up[i].size);
  db:	8b 55 b8             	mov    -0x48(%ebp),%edx
  de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  e1:	6b c0 5c             	imul   $0x5c,%eax,%eax
  e4:	01 d0                	add    %edx,%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
  e6:	8b 40 38             	mov    0x38(%eax),%eax
  e9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
                     up[i].state, up[i].size);
  ec:	8b 55 b8             	mov    -0x48(%ebp),%edx
  ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f2:	6b c0 5c             	imul   $0x5c,%eax,%eax
  f5:	01 d0                	add    %edx,%eax
  f7:	8d 78 18             	lea    0x18(%eax),%edi
  fa:	89 7d b0             	mov    %edi,-0x50(%ebp)
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
  fd:	8b 55 b8             	mov    -0x48(%ebp),%edx
 100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 103:	6b c0 5c             	imul   $0x5c,%eax,%eax
 106:	01 d0                	add    %edx,%eax
 108:	8b 48 10             	mov    0x10(%eax),%ecx
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 10b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 110:	89 c8                	mov    %ecx,%eax
 112:	f7 e2                	mul    %edx
 114:	89 d3                	mov    %edx,%ebx
 116:	c1 eb 05             	shr    $0x5,%ebx
 119:	6b c3 64             	imul   $0x64,%ebx,%eax
 11c:	89 cb                	mov    %ecx,%ebx
 11e:	29 c3                	sub    %eax,%ebx
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
 120:	8b 55 b8             	mov    -0x48(%ebp),%edx
 123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 126:	6b c0 5c             	imul   $0x5c,%eax,%eax
 129:	01 d0                	add    %edx,%eax
 12b:	8b 40 10             	mov    0x10(%eax),%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 12e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 133:	f7 e2                	mul    %edx
 135:	c1 ea 05             	shr    $0x5,%edx
 138:	89 55 ac             	mov    %edx,-0x54(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
 13b:	8b 55 b8             	mov    -0x48(%ebp),%edx
 13e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 141:	6b c0 5c             	imul   $0x5c,%eax,%eax
 144:	01 d0                	add    %edx,%eax
 146:	8b 48 14             	mov    0x14(%eax),%ecx
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 149:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 14e:	89 c8                	mov    %ecx,%eax
 150:	f7 e2                	mul    %edx
 152:	89 d6                	mov    %edx,%esi
 154:	c1 ee 05             	shr    $0x5,%esi
 157:	6b c6 64             	imul   $0x64,%esi,%eax
 15a:	89 ce                	mov    %ecx,%esi
 15c:	29 c6                	sub    %eax,%esi
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
 15e:	8b 55 b8             	mov    -0x48(%ebp),%edx
 161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 164:	6b c0 5c             	imul   $0x5c,%eax,%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 40 14             	mov    0x14(%eax),%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 16c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 171:	f7 e2                	mul    %edx
 173:	89 d0                	mov    %edx,%eax
 175:	c1 e8 05             	shr    $0x5,%eax
 178:	89 45 a8             	mov    %eax,-0x58(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
 17b:	8b 55 b8             	mov    -0x48(%ebp),%edx
 17e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 181:	6b c0 5c             	imul   $0x5c,%eax,%eax
 184:	01 d0                	add    %edx,%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 186:	8b 48 0c             	mov    0xc(%eax),%ecx
 189:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 18c:	8b 55 b8             	mov    -0x48(%ebp),%edx
 18f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 192:	6b c0 5c             	imul   $0x5c,%eax,%eax
 195:	01 d0                	add    %edx,%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 197:	8b 78 08             	mov    0x8(%eax),%edi
 19a:	89 7d a0             	mov    %edi,-0x60(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 19d:	8b 55 b8             	mov    -0x48(%ebp),%edx
 1a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1a3:	6b c0 5c             	imul   $0x5c,%eax,%eax
 1a6:	01 d0                	add    %edx,%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 1a8:	8b 78 04             	mov    0x4(%eax),%edi
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 1ab:	8b 55 b8             	mov    -0x48(%ebp),%edx
 1ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1b1:	6b c0 5c             	imul   $0x5c,%eax,%eax
 1b4:	01 d0                	add    %edx,%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 1b6:	8b 08                	mov    (%eax),%ecx
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 1b8:	8b 55 b8             	mov    -0x48(%ebp),%edx
 1bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1be:	6b c0 5c             	imul   $0x5c,%eax,%eax
 1c1:	01 d0                	add    %edx,%eax
 1c3:	83 c0 3c             	add    $0x3c,%eax
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 1c6:	83 ec 0c             	sub    $0xc,%esp
 1c9:	ff 75 b4             	pushl  -0x4c(%ebp)
 1cc:	ff 75 b0             	pushl  -0x50(%ebp)
 1cf:	53                   	push   %ebx
 1d0:	ff 75 ac             	pushl  -0x54(%ebp)
 1d3:	56                   	push   %esi
 1d4:	ff 75 a8             	pushl  -0x58(%ebp)
 1d7:	ff 75 a4             	pushl  -0x5c(%ebp)
 1da:	ff 75 a0             	pushl  -0x60(%ebp)
 1dd:	57                   	push   %edi
 1de:	51                   	push   %ecx
 1df:	50                   	push   %eax
 1e0:	68 48 0a 00 00       	push   $0xa48
 1e5:	6a 01                	push   $0x1
 1e7:	e8 26 04 00 00       	call   612 <printf>
 1ec:	83 c4 40             	add    $0x40,%esp
    }
    
    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);
    for(int  i = 0; i < MAX; i++){
 1ef:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
 1f9:	0f 8c dc fe ff ff    	jl     db <main+0xdb>
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
                     up[i].state, up[i].size);

    }
    
    exit();
 1ff:	e8 57 02 00 00       	call   45b <exit>

00000204 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 209:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20c:	8b 55 10             	mov    0x10(%ebp),%edx
 20f:	8b 45 0c             	mov    0xc(%ebp),%eax
 212:	89 cb                	mov    %ecx,%ebx
 214:	89 df                	mov    %ebx,%edi
 216:	89 d1                	mov    %edx,%ecx
 218:	fc                   	cld    
 219:	f3 aa                	rep stos %al,%es:(%edi)
 21b:	89 ca                	mov    %ecx,%edx
 21d:	89 fb                	mov    %edi,%ebx
 21f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 222:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 225:	90                   	nop
 226:	5b                   	pop    %ebx
 227:	5f                   	pop    %edi
 228:	5d                   	pop    %ebp
 229:	c3                   	ret    

0000022a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 236:	90                   	nop
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	8d 50 01             	lea    0x1(%eax),%edx
 23d:	89 55 08             	mov    %edx,0x8(%ebp)
 240:	8b 55 0c             	mov    0xc(%ebp),%edx
 243:	8d 4a 01             	lea    0x1(%edx),%ecx
 246:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 249:	0f b6 12             	movzbl (%edx),%edx
 24c:	88 10                	mov    %dl,(%eax)
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	84 c0                	test   %al,%al
 253:	75 e2                	jne    237 <strcpy+0xd>
    ;
  return os;
 255:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 258:	c9                   	leave  
 259:	c3                   	ret    

0000025a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 25a:	55                   	push   %ebp
 25b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 25d:	eb 08                	jmp    267 <strcmp+0xd>
    p++, q++;
 25f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 263:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	84 c0                	test   %al,%al
 26f:	74 10                	je     281 <strcmp+0x27>
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 10             	movzbl (%eax),%edx
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	38 c2                	cmp    %al,%dl
 27f:	74 de                	je     25f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	0f b6 d0             	movzbl %al,%edx
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	0f b6 c0             	movzbl %al,%eax
 293:	29 c2                	sub    %eax,%edx
 295:	89 d0                	mov    %edx,%eax
}
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    

00000299 <strlen>:

uint
strlen(char *s)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 29f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2a6:	eb 04                	jmp    2ac <strlen+0x13>
 2a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	84 c0                	test   %al,%al
 2b9:	75 ed                	jne    2a8 <strlen+0xf>
    ;
  return n;
 2bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2c3:	8b 45 10             	mov    0x10(%ebp),%eax
 2c6:	50                   	push   %eax
 2c7:	ff 75 0c             	pushl  0xc(%ebp)
 2ca:	ff 75 08             	pushl  0x8(%ebp)
 2cd:	e8 32 ff ff ff       	call   204 <stosb>
 2d2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <strchr>:

char*
strchr(const char *s, char c)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 04             	sub    $0x4,%esp
 2e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2e6:	eb 14                	jmp    2fc <strchr+0x22>
    if(*s == c)
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2f1:	75 05                	jne    2f8 <strchr+0x1e>
      return (char*)s;
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	eb 13                	jmp    30b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	84 c0                	test   %al,%al
 304:	75 e2                	jne    2e8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 306:	b8 00 00 00 00       	mov    $0x0,%eax
}
 30b:	c9                   	leave  
 30c:	c3                   	ret    

0000030d <gets>:

char*
gets(char *buf, int max)
{
 30d:	55                   	push   %ebp
 30e:	89 e5                	mov    %esp,%ebp
 310:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 313:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 31a:	eb 42                	jmp    35e <gets+0x51>
    cc = read(0, &c, 1);
 31c:	83 ec 04             	sub    $0x4,%esp
 31f:	6a 01                	push   $0x1
 321:	8d 45 ef             	lea    -0x11(%ebp),%eax
 324:	50                   	push   %eax
 325:	6a 00                	push   $0x0
 327:	e8 47 01 00 00       	call   473 <read>
 32c:	83 c4 10             	add    $0x10,%esp
 32f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 332:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 336:	7e 33                	jle    36b <gets+0x5e>
      break;
    buf[i++] = c;
 338:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33b:	8d 50 01             	lea    0x1(%eax),%edx
 33e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 341:	89 c2                	mov    %eax,%edx
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	01 c2                	add    %eax,%edx
 348:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 34e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 352:	3c 0a                	cmp    $0xa,%al
 354:	74 16                	je     36c <gets+0x5f>
 356:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 35a:	3c 0d                	cmp    $0xd,%al
 35c:	74 0e                	je     36c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 361:	83 c0 01             	add    $0x1,%eax
 364:	3b 45 0c             	cmp    0xc(%ebp),%eax
 367:	7c b3                	jl     31c <gets+0xf>
 369:	eb 01                	jmp    36c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 36b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 36c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	01 d0                	add    %edx,%eax
 374:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 377:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <stat>:

int
stat(char *n, struct stat *st)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 382:	83 ec 08             	sub    $0x8,%esp
 385:	6a 00                	push   $0x0
 387:	ff 75 08             	pushl  0x8(%ebp)
 38a:	e8 0c 01 00 00       	call   49b <open>
 38f:	83 c4 10             	add    $0x10,%esp
 392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 395:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 399:	79 07                	jns    3a2 <stat+0x26>
    return -1;
 39b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3a0:	eb 25                	jmp    3c7 <stat+0x4b>
  r = fstat(fd, st);
 3a2:	83 ec 08             	sub    $0x8,%esp
 3a5:	ff 75 0c             	pushl  0xc(%ebp)
 3a8:	ff 75 f4             	pushl  -0xc(%ebp)
 3ab:	e8 03 01 00 00       	call   4b3 <fstat>
 3b0:	83 c4 10             	add    $0x10,%esp
 3b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3b6:	83 ec 0c             	sub    $0xc,%esp
 3b9:	ff 75 f4             	pushl  -0xc(%ebp)
 3bc:	e8 c2 00 00 00       	call   483 <close>
 3c1:	83 c4 10             	add    $0x10,%esp
  return r;
 3c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3c7:	c9                   	leave  
 3c8:	c3                   	ret    

000003c9 <atoi>:

int
atoi(const char *s)
{
 3c9:	55                   	push   %ebp
 3ca:	89 e5                	mov    %esp,%ebp
 3cc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3d6:	eb 25                	jmp    3fd <atoi+0x34>
    n = n*10 + *s++ - '0';
 3d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3db:	89 d0                	mov    %edx,%eax
 3dd:	c1 e0 02             	shl    $0x2,%eax
 3e0:	01 d0                	add    %edx,%eax
 3e2:	01 c0                	add    %eax,%eax
 3e4:	89 c1                	mov    %eax,%ecx
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	8d 50 01             	lea    0x1(%eax),%edx
 3ec:	89 55 08             	mov    %edx,0x8(%ebp)
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	0f be c0             	movsbl %al,%eax
 3f5:	01 c8                	add    %ecx,%eax
 3f7:	83 e8 30             	sub    $0x30,%eax
 3fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	0f b6 00             	movzbl (%eax),%eax
 403:	3c 2f                	cmp    $0x2f,%al
 405:	7e 0a                	jle    411 <atoi+0x48>
 407:	8b 45 08             	mov    0x8(%ebp),%eax
 40a:	0f b6 00             	movzbl (%eax),%eax
 40d:	3c 39                	cmp    $0x39,%al
 40f:	7e c7                	jle    3d8 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
 419:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 428:	eb 17                	jmp    441 <memmove+0x2b>
    *dst++ = *src++;
 42a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 42d:	8d 50 01             	lea    0x1(%eax),%edx
 430:	89 55 fc             	mov    %edx,-0x4(%ebp)
 433:	8b 55 f8             	mov    -0x8(%ebp),%edx
 436:	8d 4a 01             	lea    0x1(%edx),%ecx
 439:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 43c:	0f b6 12             	movzbl (%edx),%edx
 43f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 441:	8b 45 10             	mov    0x10(%ebp),%eax
 444:	8d 50 ff             	lea    -0x1(%eax),%edx
 447:	89 55 10             	mov    %edx,0x10(%ebp)
 44a:	85 c0                	test   %eax,%eax
 44c:	7f dc                	jg     42a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 451:	c9                   	leave  
 452:	c3                   	ret    

00000453 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 453:	b8 01 00 00 00       	mov    $0x1,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <exit>:
SYSCALL(exit)
 45b:	b8 02 00 00 00       	mov    $0x2,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <wait>:
SYSCALL(wait)
 463:	b8 03 00 00 00       	mov    $0x3,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <pipe>:
SYSCALL(pipe)
 46b:	b8 04 00 00 00       	mov    $0x4,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <read>:
SYSCALL(read)
 473:	b8 05 00 00 00       	mov    $0x5,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <write>:
SYSCALL(write)
 47b:	b8 10 00 00 00       	mov    $0x10,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <close>:
SYSCALL(close)
 483:	b8 15 00 00 00       	mov    $0x15,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <kill>:
SYSCALL(kill)
 48b:	b8 06 00 00 00       	mov    $0x6,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <exec>:
SYSCALL(exec)
 493:	b8 07 00 00 00       	mov    $0x7,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <open>:
SYSCALL(open)
 49b:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <mknod>:
SYSCALL(mknod)
 4a3:	b8 11 00 00 00       	mov    $0x11,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <unlink>:
SYSCALL(unlink)
 4ab:	b8 12 00 00 00       	mov    $0x12,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <fstat>:
SYSCALL(fstat)
 4b3:	b8 08 00 00 00       	mov    $0x8,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <link>:
SYSCALL(link)
 4bb:	b8 13 00 00 00       	mov    $0x13,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <mkdir>:
SYSCALL(mkdir)
 4c3:	b8 14 00 00 00       	mov    $0x14,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <chdir>:
SYSCALL(chdir)
 4cb:	b8 09 00 00 00       	mov    $0x9,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <dup>:
SYSCALL(dup)
 4d3:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <getpid>:
SYSCALL(getpid)
 4db:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <sbrk>:
SYSCALL(sbrk)
 4e3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <sleep>:
SYSCALL(sleep)
 4eb:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <uptime>:
SYSCALL(uptime)
 4f3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <halt>:
SYSCALL(halt)
 4fb:	b8 16 00 00 00       	mov    $0x16,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <date>:
//Student Implementations 
SYSCALL(date)
 503:	b8 17 00 00 00       	mov    $0x17,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <getuid>:

SYSCALL(getuid)
 50b:	b8 18 00 00 00       	mov    $0x18,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <getgid>:
SYSCALL(getgid)
 513:	b8 19 00 00 00       	mov    $0x19,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <getppid>:
SYSCALL(getppid)
 51b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <setuid>:

SYSCALL(setuid)
 523:	b8 1b 00 00 00       	mov    $0x1b,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <setgid>:
SYSCALL(setgid)
 52b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <getprocs>:
SYSCALL(getprocs)
 533:	b8 1d 00 00 00       	mov    $0x1d,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	83 ec 18             	sub    $0x18,%esp
 541:	8b 45 0c             	mov    0xc(%ebp),%eax
 544:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 547:	83 ec 04             	sub    $0x4,%esp
 54a:	6a 01                	push   $0x1
 54c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54f:	50                   	push   %eax
 550:	ff 75 08             	pushl  0x8(%ebp)
 553:	e8 23 ff ff ff       	call   47b <write>
 558:	83 c4 10             	add    $0x10,%esp
}
 55b:	90                   	nop
 55c:	c9                   	leave  
 55d:	c3                   	ret    

0000055e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55e:	55                   	push   %ebp
 55f:	89 e5                	mov    %esp,%ebp
 561:	53                   	push   %ebx
 562:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 565:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 56c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 570:	74 17                	je     589 <printint+0x2b>
 572:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 576:	79 11                	jns    589 <printint+0x2b>
    neg = 1;
 578:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57f:	8b 45 0c             	mov    0xc(%ebp),%eax
 582:	f7 d8                	neg    %eax
 584:	89 45 ec             	mov    %eax,-0x14(%ebp)
 587:	eb 06                	jmp    58f <printint+0x31>
  } else {
    x = xx;
 589:	8b 45 0c             	mov    0xc(%ebp),%eax
 58c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 596:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 599:	8d 41 01             	lea    0x1(%ecx),%eax
 59c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 59f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a5:	ba 00 00 00 00       	mov    $0x0,%edx
 5aa:	f7 f3                	div    %ebx
 5ac:	89 d0                	mov    %edx,%eax
 5ae:	0f b6 80 e4 0c 00 00 	movzbl 0xce4(%eax),%eax
 5b5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bf:	ba 00 00 00 00       	mov    $0x0,%edx
 5c4:	f7 f3                	div    %ebx
 5c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5cd:	75 c7                	jne    596 <printint+0x38>
  if(neg)
 5cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d3:	74 2d                	je     602 <printint+0xa4>
    buf[i++] = '-';
 5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d8:	8d 50 01             	lea    0x1(%eax),%edx
 5db:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5de:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5e3:	eb 1d                	jmp    602 <printint+0xa4>
    putc(fd, buf[i]);
 5e5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5eb:	01 d0                	add    %edx,%eax
 5ed:	0f b6 00             	movzbl (%eax),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	83 ec 08             	sub    $0x8,%esp
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 3c ff ff ff       	call   53b <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 602:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60a:	79 d9                	jns    5e5 <printint+0x87>
    putc(fd, buf[i]);
}
 60c:	90                   	nop
 60d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 610:	c9                   	leave  
 611:	c3                   	ret    

00000612 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 612:	55                   	push   %ebp
 613:	89 e5                	mov    %esp,%ebp
 615:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 618:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 61f:	8d 45 0c             	lea    0xc(%ebp),%eax
 622:	83 c0 04             	add    $0x4,%eax
 625:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 628:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 62f:	e9 59 01 00 00       	jmp    78d <printf+0x17b>
    c = fmt[i] & 0xff;
 634:	8b 55 0c             	mov    0xc(%ebp),%edx
 637:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63a:	01 d0                	add    %edx,%eax
 63c:	0f b6 00             	movzbl (%eax),%eax
 63f:	0f be c0             	movsbl %al,%eax
 642:	25 ff 00 00 00       	and    $0xff,%eax
 647:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 64a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64e:	75 2c                	jne    67c <printf+0x6a>
      if(c == '%'){
 650:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 654:	75 0c                	jne    662 <printf+0x50>
        state = '%';
 656:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 65d:	e9 27 01 00 00       	jmp    789 <printf+0x177>
      } else {
        putc(fd, c);
 662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 665:	0f be c0             	movsbl %al,%eax
 668:	83 ec 08             	sub    $0x8,%esp
 66b:	50                   	push   %eax
 66c:	ff 75 08             	pushl  0x8(%ebp)
 66f:	e8 c7 fe ff ff       	call   53b <putc>
 674:	83 c4 10             	add    $0x10,%esp
 677:	e9 0d 01 00 00       	jmp    789 <printf+0x177>
      }
    } else if(state == '%'){
 67c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 680:	0f 85 03 01 00 00    	jne    789 <printf+0x177>
      if(c == 'd'){
 686:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 68a:	75 1e                	jne    6aa <printf+0x98>
        printint(fd, *ap, 10, 1);
 68c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	6a 01                	push   $0x1
 693:	6a 0a                	push   $0xa
 695:	50                   	push   %eax
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 c0 fe ff ff       	call   55e <printint>
 69e:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a5:	e9 d8 00 00 00       	jmp    782 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6aa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6ae:	74 06                	je     6b6 <printf+0xa4>
 6b0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b4:	75 1e                	jne    6d4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	6a 00                	push   $0x0
 6bd:	6a 10                	push   $0x10
 6bf:	50                   	push   %eax
 6c0:	ff 75 08             	pushl  0x8(%ebp)
 6c3:	e8 96 fe ff ff       	call   55e <printint>
 6c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cf:	e9 ae 00 00 00       	jmp    782 <printf+0x170>
      } else if(c == 's'){
 6d4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d8:	75 43                	jne    71d <printf+0x10b>
        s = (char*)*ap;
 6da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ea:	75 25                	jne    711 <printf+0xff>
          s = "(null)";
 6ec:	c7 45 f4 87 0a 00 00 	movl   $0xa87,-0xc(%ebp)
        while(*s != 0){
 6f3:	eb 1c                	jmp    711 <printf+0xff>
          putc(fd, *s);
 6f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f8:	0f b6 00             	movzbl (%eax),%eax
 6fb:	0f be c0             	movsbl %al,%eax
 6fe:	83 ec 08             	sub    $0x8,%esp
 701:	50                   	push   %eax
 702:	ff 75 08             	pushl  0x8(%ebp)
 705:	e8 31 fe ff ff       	call   53b <putc>
 70a:	83 c4 10             	add    $0x10,%esp
          s++;
 70d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 711:	8b 45 f4             	mov    -0xc(%ebp),%eax
 714:	0f b6 00             	movzbl (%eax),%eax
 717:	84 c0                	test   %al,%al
 719:	75 da                	jne    6f5 <printf+0xe3>
 71b:	eb 65                	jmp    782 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 71d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 721:	75 1d                	jne    740 <printf+0x12e>
        putc(fd, *ap);
 723:	8b 45 e8             	mov    -0x18(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	0f be c0             	movsbl %al,%eax
 72b:	83 ec 08             	sub    $0x8,%esp
 72e:	50                   	push   %eax
 72f:	ff 75 08             	pushl  0x8(%ebp)
 732:	e8 04 fe ff ff       	call   53b <putc>
 737:	83 c4 10             	add    $0x10,%esp
        ap++;
 73a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73e:	eb 42                	jmp    782 <printf+0x170>
      } else if(c == '%'){
 740:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 744:	75 17                	jne    75d <printf+0x14b>
        putc(fd, c);
 746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 749:	0f be c0             	movsbl %al,%eax
 74c:	83 ec 08             	sub    $0x8,%esp
 74f:	50                   	push   %eax
 750:	ff 75 08             	pushl  0x8(%ebp)
 753:	e8 e3 fd ff ff       	call   53b <putc>
 758:	83 c4 10             	add    $0x10,%esp
 75b:	eb 25                	jmp    782 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 75d:	83 ec 08             	sub    $0x8,%esp
 760:	6a 25                	push   $0x25
 762:	ff 75 08             	pushl  0x8(%ebp)
 765:	e8 d1 fd ff ff       	call   53b <putc>
 76a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 76d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 770:	0f be c0             	movsbl %al,%eax
 773:	83 ec 08             	sub    $0x8,%esp
 776:	50                   	push   %eax
 777:	ff 75 08             	pushl  0x8(%ebp)
 77a:	e8 bc fd ff ff       	call   53b <putc>
 77f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 782:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 789:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 78d:	8b 55 0c             	mov    0xc(%ebp),%edx
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	01 d0                	add    %edx,%eax
 795:	0f b6 00             	movzbl (%eax),%eax
 798:	84 c0                	test   %al,%al
 79a:	0f 85 94 fe ff ff    	jne    634 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a0:	90                   	nop
 7a1:	c9                   	leave  
 7a2:	c3                   	ret    

000007a3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a3:	55                   	push   %ebp
 7a4:	89 e5                	mov    %esp,%ebp
 7a6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	83 e8 08             	sub    $0x8,%eax
 7af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b2:	a1 00 0d 00 00       	mov    0xd00,%eax
 7b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ba:	eb 24                	jmp    7e0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c4:	77 12                	ja     7d8 <free+0x35>
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cc:	77 24                	ja     7f2 <free+0x4f>
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 00                	mov    (%eax),%eax
 7d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d6:	77 1a                	ja     7f2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e6:	76 d4                	jbe    7bc <free+0x19>
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f0:	76 ca                	jbe    7bc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 802:	01 c2                	add    %eax,%edx
 804:	8b 45 fc             	mov    -0x4(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	39 c2                	cmp    %eax,%edx
 80b:	75 24                	jne    831 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	8b 50 04             	mov    0x4(%eax),%edx
 813:	8b 45 fc             	mov    -0x4(%ebp),%eax
 816:	8b 00                	mov    (%eax),%eax
 818:	8b 40 04             	mov    0x4(%eax),%eax
 81b:	01 c2                	add    %eax,%edx
 81d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 820:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	8b 00                	mov    (%eax),%eax
 828:	8b 10                	mov    (%eax),%edx
 82a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82d:	89 10                	mov    %edx,(%eax)
 82f:	eb 0a                	jmp    83b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 10                	mov    (%eax),%edx
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	01 d0                	add    %edx,%eax
 84d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 850:	75 20                	jne    872 <free+0xcf>
    p->s.size += bp->s.size;
 852:	8b 45 fc             	mov    -0x4(%ebp),%eax
 855:	8b 50 04             	mov    0x4(%eax),%edx
 858:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85b:	8b 40 04             	mov    0x4(%eax),%eax
 85e:	01 c2                	add    %eax,%edx
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
 863:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 866:	8b 45 f8             	mov    -0x8(%ebp),%eax
 869:	8b 10                	mov    (%eax),%edx
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	89 10                	mov    %edx,(%eax)
 870:	eb 08                	jmp    87a <free+0xd7>
  } else
    p->s.ptr = bp;
 872:	8b 45 fc             	mov    -0x4(%ebp),%eax
 875:	8b 55 f8             	mov    -0x8(%ebp),%edx
 878:	89 10                	mov    %edx,(%eax)
  freep = p;
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	a3 00 0d 00 00       	mov    %eax,0xd00
}
 882:	90                   	nop
 883:	c9                   	leave  
 884:	c3                   	ret    

00000885 <morecore>:

static Header*
morecore(uint nu)
{
 885:	55                   	push   %ebp
 886:	89 e5                	mov    %esp,%ebp
 888:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 88b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 892:	77 07                	ja     89b <morecore+0x16>
    nu = 4096;
 894:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 89b:	8b 45 08             	mov    0x8(%ebp),%eax
 89e:	c1 e0 03             	shl    $0x3,%eax
 8a1:	83 ec 0c             	sub    $0xc,%esp
 8a4:	50                   	push   %eax
 8a5:	e8 39 fc ff ff       	call   4e3 <sbrk>
 8aa:	83 c4 10             	add    $0x10,%esp
 8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b4:	75 07                	jne    8bd <morecore+0x38>
    return 0;
 8b6:	b8 00 00 00 00       	mov    $0x0,%eax
 8bb:	eb 26                	jmp    8e3 <morecore+0x5e>
  hp = (Header*)p;
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c6:	8b 55 08             	mov    0x8(%ebp),%edx
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cf:	83 c0 08             	add    $0x8,%eax
 8d2:	83 ec 0c             	sub    $0xc,%esp
 8d5:	50                   	push   %eax
 8d6:	e8 c8 fe ff ff       	call   7a3 <free>
 8db:	83 c4 10             	add    $0x10,%esp
  return freep;
 8de:	a1 00 0d 00 00       	mov    0xd00,%eax
}
 8e3:	c9                   	leave  
 8e4:	c3                   	ret    

000008e5 <malloc>:

void*
malloc(uint nbytes)
{
 8e5:	55                   	push   %ebp
 8e6:	89 e5                	mov    %esp,%ebp
 8e8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8eb:	8b 45 08             	mov    0x8(%ebp),%eax
 8ee:	83 c0 07             	add    $0x7,%eax
 8f1:	c1 e8 03             	shr    $0x3,%eax
 8f4:	83 c0 01             	add    $0x1,%eax
 8f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8fa:	a1 00 0d 00 00       	mov    0xd00,%eax
 8ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 902:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 906:	75 23                	jne    92b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 908:	c7 45 f0 f8 0c 00 00 	movl   $0xcf8,-0x10(%ebp)
 90f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 912:	a3 00 0d 00 00       	mov    %eax,0xd00
 917:	a1 00 0d 00 00       	mov    0xd00,%eax
 91c:	a3 f8 0c 00 00       	mov    %eax,0xcf8
    base.s.size = 0;
 921:	c7 05 fc 0c 00 00 00 	movl   $0x0,0xcfc
 928:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92e:	8b 00                	mov    (%eax),%eax
 930:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	8b 40 04             	mov    0x4(%eax),%eax
 939:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93c:	72 4d                	jb     98b <malloc+0xa6>
      if(p->s.size == nunits)
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	8b 40 04             	mov    0x4(%eax),%eax
 944:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 947:	75 0c                	jne    955 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	8b 10                	mov    (%eax),%edx
 94e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 951:	89 10                	mov    %edx,(%eax)
 953:	eb 26                	jmp    97b <malloc+0x96>
      else {
        p->s.size -= nunits;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 40 04             	mov    0x4(%eax),%eax
 95b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 95e:	89 c2                	mov    %eax,%edx
 960:	8b 45 f4             	mov    -0xc(%ebp),%eax
 963:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	8b 40 04             	mov    0x4(%eax),%eax
 96c:	c1 e0 03             	shl    $0x3,%eax
 96f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 972:	8b 45 f4             	mov    -0xc(%ebp),%eax
 975:	8b 55 ec             	mov    -0x14(%ebp),%edx
 978:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 97b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97e:	a3 00 0d 00 00       	mov    %eax,0xd00
      return (void*)(p + 1);
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	83 c0 08             	add    $0x8,%eax
 989:	eb 3b                	jmp    9c6 <malloc+0xe1>
    }
    if(p == freep)
 98b:	a1 00 0d 00 00       	mov    0xd00,%eax
 990:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 993:	75 1e                	jne    9b3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 995:	83 ec 0c             	sub    $0xc,%esp
 998:	ff 75 ec             	pushl  -0x14(%ebp)
 99b:	e8 e5 fe ff ff       	call   885 <morecore>
 9a0:	83 c4 10             	add    $0x10,%esp
 9a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9aa:	75 07                	jne    9b3 <malloc+0xce>
        return 0;
 9ac:	b8 00 00 00 00       	mov    $0x0,%eax
 9b1:	eb 13                	jmp    9c6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bc:	8b 00                	mov    (%eax),%eax
 9be:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c1:	e9 6d ff ff ff       	jmp    933 <malloc+0x4e>
}
 9c6:	c9                   	leave  
 9c7:	c3                   	ret    
