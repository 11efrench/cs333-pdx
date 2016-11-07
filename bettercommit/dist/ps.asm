
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
  1b:	c7 45 dc d0 09 00 00 	movl   $0x9d0,-0x24(%ebp)
          *p = "PID",
  22:	c7 45 d8 d5 09 00 00 	movl   $0x9d5,-0x28(%ebp)
          *u = "UID",
  29:	c7 45 d4 d9 09 00 00 	movl   $0x9d9,-0x2c(%ebp)
          *g = "GID",
  30:	c7 45 d0 dd 09 00 00 	movl   $0x9dd,-0x30(%ebp)
          *pp = "PPID",
  37:	c7 45 cc e1 09 00 00 	movl   $0x9e1,-0x34(%ebp)
          *tot = "CPU (s)",
  3e:	c7 45 c8 e6 09 00 00 	movl   $0x9e6,-0x38(%ebp)
          *e = "Elapsed (s)",
  45:	c7 45 c4 ee 09 00 00 	movl   $0x9ee,-0x3c(%ebp)
          *st = "State",
  4c:	c7 45 c0 fa 09 00 00 	movl   $0x9fa,-0x40(%ebp)
          *si = "Size";
  53:	c7 45 bc 00 0a 00 00 	movl   $0xa00,-0x44(%ebp)
 
    up =  malloc( sizeof(&up) * MAX);
  5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  5d:	c1 e0 02             	shl    $0x2,%eax
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	50                   	push   %eax
  64:	e8 84 08 00 00       	call   8ed <malloc>
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
  8e:	68 05 0a 00 00       	push   $0xa05
  93:	6a 01                	push   $0x1
  95:	e8 80 05 00 00       	call   61a <printf>
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
  c0:	68 18 0a 00 00       	push   $0xa18
  c5:	6a 01                	push   $0x1
  c7:	e8 4e 05 00 00       	call   61a <printf>
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
 1e0:	68 50 0a 00 00       	push   $0xa50
 1e5:	6a 01                	push   $0x1
 1e7:	e8 2e 04 00 00       	call   61a <printf>
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

0000053b <setpriority>:
// Project 3
SYSCALL(setpriority)
 53b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 543:	55                   	push   %ebp
 544:	89 e5                	mov    %esp,%ebp
 546:	83 ec 18             	sub    $0x18,%esp
 549:	8b 45 0c             	mov    0xc(%ebp),%eax
 54c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 54f:	83 ec 04             	sub    $0x4,%esp
 552:	6a 01                	push   $0x1
 554:	8d 45 f4             	lea    -0xc(%ebp),%eax
 557:	50                   	push   %eax
 558:	ff 75 08             	pushl  0x8(%ebp)
 55b:	e8 1b ff ff ff       	call   47b <write>
 560:	83 c4 10             	add    $0x10,%esp
}
 563:	90                   	nop
 564:	c9                   	leave  
 565:	c3                   	ret    

00000566 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 566:	55                   	push   %ebp
 567:	89 e5                	mov    %esp,%ebp
 569:	53                   	push   %ebx
 56a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 56d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 574:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 578:	74 17                	je     591 <printint+0x2b>
 57a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 57e:	79 11                	jns    591 <printint+0x2b>
    neg = 1;
 580:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 587:	8b 45 0c             	mov    0xc(%ebp),%eax
 58a:	f7 d8                	neg    %eax
 58c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58f:	eb 06                	jmp    597 <printint+0x31>
  } else {
    x = xx;
 591:	8b 45 0c             	mov    0xc(%ebp),%eax
 594:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 59e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5a1:	8d 41 01             	lea    0x1(%ecx),%eax
 5a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ad:	ba 00 00 00 00       	mov    $0x0,%edx
 5b2:	f7 f3                	div    %ebx
 5b4:	89 d0                	mov    %edx,%eax
 5b6:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 5bd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c7:	ba 00 00 00 00       	mov    $0x0,%edx
 5cc:	f7 f3                	div    %ebx
 5ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d5:	75 c7                	jne    59e <printint+0x38>
  if(neg)
 5d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5db:	74 2d                	je     60a <printint+0xa4>
    buf[i++] = '-';
 5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e0:	8d 50 01             	lea    0x1(%eax),%edx
 5e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5e6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5eb:	eb 1d                	jmp    60a <printint+0xa4>
    putc(fd, buf[i]);
 5ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f3:	01 d0                	add    %edx,%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 3c ff ff ff       	call   543 <putc>
 607:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 60a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 60e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 612:	79 d9                	jns    5ed <printint+0x87>
    putc(fd, buf[i]);
}
 614:	90                   	nop
 615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 618:	c9                   	leave  
 619:	c3                   	ret    

0000061a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 61a:	55                   	push   %ebp
 61b:	89 e5                	mov    %esp,%ebp
 61d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 620:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 627:	8d 45 0c             	lea    0xc(%ebp),%eax
 62a:	83 c0 04             	add    $0x4,%eax
 62d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 630:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 637:	e9 59 01 00 00       	jmp    795 <printf+0x17b>
    c = fmt[i] & 0xff;
 63c:	8b 55 0c             	mov    0xc(%ebp),%edx
 63f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 642:	01 d0                	add    %edx,%eax
 644:	0f b6 00             	movzbl (%eax),%eax
 647:	0f be c0             	movsbl %al,%eax
 64a:	25 ff 00 00 00       	and    $0xff,%eax
 64f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 652:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 656:	75 2c                	jne    684 <printf+0x6a>
      if(c == '%'){
 658:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65c:	75 0c                	jne    66a <printf+0x50>
        state = '%';
 65e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 665:	e9 27 01 00 00       	jmp    791 <printf+0x177>
      } else {
        putc(fd, c);
 66a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66d:	0f be c0             	movsbl %al,%eax
 670:	83 ec 08             	sub    $0x8,%esp
 673:	50                   	push   %eax
 674:	ff 75 08             	pushl  0x8(%ebp)
 677:	e8 c7 fe ff ff       	call   543 <putc>
 67c:	83 c4 10             	add    $0x10,%esp
 67f:	e9 0d 01 00 00       	jmp    791 <printf+0x177>
      }
    } else if(state == '%'){
 684:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 688:	0f 85 03 01 00 00    	jne    791 <printf+0x177>
      if(c == 'd'){
 68e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 692:	75 1e                	jne    6b2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 694:	8b 45 e8             	mov    -0x18(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	6a 01                	push   $0x1
 69b:	6a 0a                	push   $0xa
 69d:	50                   	push   %eax
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 c0 fe ff ff       	call   566 <printint>
 6a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ad:	e9 d8 00 00 00       	jmp    78a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6b2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b6:	74 06                	je     6be <printf+0xa4>
 6b8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6bc:	75 1e                	jne    6dc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	6a 00                	push   $0x0
 6c5:	6a 10                	push   $0x10
 6c7:	50                   	push   %eax
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 96 fe ff ff       	call   566 <printint>
 6d0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d7:	e9 ae 00 00 00       	jmp    78a <printf+0x170>
      } else if(c == 's'){
 6dc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6e0:	75 43                	jne    725 <printf+0x10b>
        s = (char*)*ap;
 6e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e5:	8b 00                	mov    (%eax),%eax
 6e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f2:	75 25                	jne    719 <printf+0xff>
          s = "(null)";
 6f4:	c7 45 f4 8f 0a 00 00 	movl   $0xa8f,-0xc(%ebp)
        while(*s != 0){
 6fb:	eb 1c                	jmp    719 <printf+0xff>
          putc(fd, *s);
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	0f b6 00             	movzbl (%eax),%eax
 703:	0f be c0             	movsbl %al,%eax
 706:	83 ec 08             	sub    $0x8,%esp
 709:	50                   	push   %eax
 70a:	ff 75 08             	pushl  0x8(%ebp)
 70d:	e8 31 fe ff ff       	call   543 <putc>
 712:	83 c4 10             	add    $0x10,%esp
          s++;
 715:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 719:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71c:	0f b6 00             	movzbl (%eax),%eax
 71f:	84 c0                	test   %al,%al
 721:	75 da                	jne    6fd <printf+0xe3>
 723:	eb 65                	jmp    78a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 725:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 729:	75 1d                	jne    748 <printf+0x12e>
        putc(fd, *ap);
 72b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	0f be c0             	movsbl %al,%eax
 733:	83 ec 08             	sub    $0x8,%esp
 736:	50                   	push   %eax
 737:	ff 75 08             	pushl  0x8(%ebp)
 73a:	e8 04 fe ff ff       	call   543 <putc>
 73f:	83 c4 10             	add    $0x10,%esp
        ap++;
 742:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 746:	eb 42                	jmp    78a <printf+0x170>
      } else if(c == '%'){
 748:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74c:	75 17                	jne    765 <printf+0x14b>
        putc(fd, c);
 74e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 751:	0f be c0             	movsbl %al,%eax
 754:	83 ec 08             	sub    $0x8,%esp
 757:	50                   	push   %eax
 758:	ff 75 08             	pushl  0x8(%ebp)
 75b:	e8 e3 fd ff ff       	call   543 <putc>
 760:	83 c4 10             	add    $0x10,%esp
 763:	eb 25                	jmp    78a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 765:	83 ec 08             	sub    $0x8,%esp
 768:	6a 25                	push   $0x25
 76a:	ff 75 08             	pushl  0x8(%ebp)
 76d:	e8 d1 fd ff ff       	call   543 <putc>
 772:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 778:	0f be c0             	movsbl %al,%eax
 77b:	83 ec 08             	sub    $0x8,%esp
 77e:	50                   	push   %eax
 77f:	ff 75 08             	pushl  0x8(%ebp)
 782:	e8 bc fd ff ff       	call   543 <putc>
 787:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 78a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 791:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 795:	8b 55 0c             	mov    0xc(%ebp),%edx
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	01 d0                	add    %edx,%eax
 79d:	0f b6 00             	movzbl (%eax),%eax
 7a0:	84 c0                	test   %al,%al
 7a2:	0f 85 94 fe ff ff    	jne    63c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a8:	90                   	nop
 7a9:	c9                   	leave  
 7aa:	c3                   	ret    

000007ab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ab:	55                   	push   %ebp
 7ac:	89 e5                	mov    %esp,%ebp
 7ae:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b1:	8b 45 08             	mov    0x8(%ebp),%eax
 7b4:	83 e8 08             	sub    $0x8,%eax
 7b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ba:	a1 08 0d 00 00       	mov    0xd08,%eax
 7bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c2:	eb 24                	jmp    7e8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cc:	77 12                	ja     7e0 <free+0x35>
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d4:	77 24                	ja     7fa <free+0x4f>
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 00                	mov    (%eax),%eax
 7db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7de:	77 1a                	ja     7fa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ee:	76 d4                	jbe    7c4 <free+0x19>
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f8:	76 ca                	jbe    7c4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	8b 40 04             	mov    0x4(%eax),%eax
 800:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 807:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80a:	01 c2                	add    %eax,%edx
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	39 c2                	cmp    %eax,%edx
 813:	75 24                	jne    839 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 815:	8b 45 f8             	mov    -0x8(%ebp),%eax
 818:	8b 50 04             	mov    0x4(%eax),%edx
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	8b 00                	mov    (%eax),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	01 c2                	add    %eax,%edx
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	8b 10                	mov    (%eax),%edx
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	89 10                	mov    %edx,(%eax)
 837:	eb 0a                	jmp    843 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	8b 10                	mov    (%eax),%edx
 83e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 841:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 843:	8b 45 fc             	mov    -0x4(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	01 d0                	add    %edx,%eax
 855:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 858:	75 20                	jne    87a <free+0xcf>
    p->s.size += bp->s.size;
 85a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85d:	8b 50 04             	mov    0x4(%eax),%edx
 860:	8b 45 f8             	mov    -0x8(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	01 c2                	add    %eax,%edx
 868:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 86e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 871:	8b 10                	mov    (%eax),%edx
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	89 10                	mov    %edx,(%eax)
 878:	eb 08                	jmp    882 <free+0xd7>
  } else
    p->s.ptr = bp;
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 880:	89 10                	mov    %edx,(%eax)
  freep = p;
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	a3 08 0d 00 00       	mov    %eax,0xd08
}
 88a:	90                   	nop
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <morecore>:

static Header*
morecore(uint nu)
{
 88d:	55                   	push   %ebp
 88e:	89 e5                	mov    %esp,%ebp
 890:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 893:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 89a:	77 07                	ja     8a3 <morecore+0x16>
    nu = 4096;
 89c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a3:	8b 45 08             	mov    0x8(%ebp),%eax
 8a6:	c1 e0 03             	shl    $0x3,%eax
 8a9:	83 ec 0c             	sub    $0xc,%esp
 8ac:	50                   	push   %eax
 8ad:	e8 31 fc ff ff       	call   4e3 <sbrk>
 8b2:	83 c4 10             	add    $0x10,%esp
 8b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8bc:	75 07                	jne    8c5 <morecore+0x38>
    return 0;
 8be:	b8 00 00 00 00       	mov    $0x0,%eax
 8c3:	eb 26                	jmp    8eb <morecore+0x5e>
  hp = (Header*)p;
 8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ce:	8b 55 08             	mov    0x8(%ebp),%edx
 8d1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	83 c0 08             	add    $0x8,%eax
 8da:	83 ec 0c             	sub    $0xc,%esp
 8dd:	50                   	push   %eax
 8de:	e8 c8 fe ff ff       	call   7ab <free>
 8e3:	83 c4 10             	add    $0x10,%esp
  return freep;
 8e6:	a1 08 0d 00 00       	mov    0xd08,%eax
}
 8eb:	c9                   	leave  
 8ec:	c3                   	ret    

000008ed <malloc>:

void*
malloc(uint nbytes)
{
 8ed:	55                   	push   %ebp
 8ee:	89 e5                	mov    %esp,%ebp
 8f0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f3:	8b 45 08             	mov    0x8(%ebp),%eax
 8f6:	83 c0 07             	add    $0x7,%eax
 8f9:	c1 e8 03             	shr    $0x3,%eax
 8fc:	83 c0 01             	add    $0x1,%eax
 8ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 902:	a1 08 0d 00 00       	mov    0xd08,%eax
 907:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 90e:	75 23                	jne    933 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 910:	c7 45 f0 00 0d 00 00 	movl   $0xd00,-0x10(%ebp)
 917:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91a:	a3 08 0d 00 00       	mov    %eax,0xd08
 91f:	a1 08 0d 00 00       	mov    0xd08,%eax
 924:	a3 00 0d 00 00       	mov    %eax,0xd00
    base.s.size = 0;
 929:	c7 05 04 0d 00 00 00 	movl   $0x0,0xd04
 930:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 933:	8b 45 f0             	mov    -0x10(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	8b 40 04             	mov    0x4(%eax),%eax
 941:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 944:	72 4d                	jb     993 <malloc+0xa6>
      if(p->s.size == nunits)
 946:	8b 45 f4             	mov    -0xc(%ebp),%eax
 949:	8b 40 04             	mov    0x4(%eax),%eax
 94c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 94f:	75 0c                	jne    95d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	8b 10                	mov    (%eax),%edx
 956:	8b 45 f0             	mov    -0x10(%ebp),%eax
 959:	89 10                	mov    %edx,(%eax)
 95b:	eb 26                	jmp    983 <malloc+0x96>
      else {
        p->s.size -= nunits;
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	8b 40 04             	mov    0x4(%eax),%eax
 963:	2b 45 ec             	sub    -0x14(%ebp),%eax
 966:	89 c2                	mov    %eax,%edx
 968:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	8b 40 04             	mov    0x4(%eax),%eax
 974:	c1 e0 03             	shl    $0x3,%eax
 977:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 97a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 980:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 983:	8b 45 f0             	mov    -0x10(%ebp),%eax
 986:	a3 08 0d 00 00       	mov    %eax,0xd08
      return (void*)(p + 1);
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	83 c0 08             	add    $0x8,%eax
 991:	eb 3b                	jmp    9ce <malloc+0xe1>
    }
    if(p == freep)
 993:	a1 08 0d 00 00       	mov    0xd08,%eax
 998:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 99b:	75 1e                	jne    9bb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 99d:	83 ec 0c             	sub    $0xc,%esp
 9a0:	ff 75 ec             	pushl  -0x14(%ebp)
 9a3:	e8 e5 fe ff ff       	call   88d <morecore>
 9a8:	83 c4 10             	add    $0x10,%esp
 9ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b2:	75 07                	jne    9bb <malloc+0xce>
        return 0;
 9b4:	b8 00 00 00 00       	mov    $0x0,%eax
 9b9:	eb 13                	jmp    9ce <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9be:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c4:	8b 00                	mov    (%eax),%eax
 9c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c9:	e9 6d ff ff ff       	jmp    93b <malloc+0x4e>
}
 9ce:	c9                   	leave  
 9cf:	c3                   	ret    
