
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
  1b:	c7 45 dc ac 09 00 00 	movl   $0x9ac,-0x24(%ebp)
          *p = "PID",
  22:	c7 45 d8 b1 09 00 00 	movl   $0x9b1,-0x28(%ebp)
          *u = "UID",
  29:	c7 45 d4 b5 09 00 00 	movl   $0x9b5,-0x2c(%ebp)
          *g = "GID",
  30:	c7 45 d0 b9 09 00 00 	movl   $0x9b9,-0x30(%ebp)
          *pp = "PPID",
  37:	c7 45 cc bd 09 00 00 	movl   $0x9bd,-0x34(%ebp)
          *tot = "CPU (s)",
  3e:	c7 45 c8 c2 09 00 00 	movl   $0x9c2,-0x38(%ebp)
          *e = "Elapsed (s)",
  45:	c7 45 c4 ca 09 00 00 	movl   $0x9ca,-0x3c(%ebp)
          *st = "State",
  4c:	c7 45 c0 d6 09 00 00 	movl   $0x9d6,-0x40(%ebp)
          *si = "Size";
  53:	c7 45 bc dc 09 00 00 	movl   $0x9dc,-0x44(%ebp)
 
    up =  malloc( sizeof(&up) * MAX);
  5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  5d:	c1 e0 02             	shl    $0x2,%eax
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	50                   	push   %eax
  64:	e8 5f 08 00 00       	call   8c8 <malloc>
  69:	83 c4 10             	add    $0x10,%esp
  6c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    MAX =  getprocs(MAX, up);
  6f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  75:	83 ec 08             	sub    $0x8,%esp
  78:	52                   	push   %edx
  79:	50                   	push   %eax
  7a:	e8 97 04 00 00       	call   516 <getprocs>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	89 45 e0             	mov    %eax,-0x20(%ebp)

    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
  85:	83 ec 04             	sub    $0x4,%esp
  88:	ff 75 bc             	pushl  -0x44(%ebp)
  8b:	ff 75 c0             	pushl  -0x40(%ebp)
  8e:	ff 75 c4             	pushl  -0x3c(%ebp)
  91:	ff 75 c8             	pushl  -0x38(%ebp)
  94:	ff 75 cc             	pushl  -0x34(%ebp)
  97:	ff 75 d0             	pushl  -0x30(%ebp)
  9a:	ff 75 d4             	pushl  -0x2c(%ebp)
  9d:	ff 75 d8             	pushl  -0x28(%ebp)
  a0:	ff 75 dc             	pushl  -0x24(%ebp)
  a3:	68 e4 09 00 00       	push   $0x9e4
  a8:	6a 01                	push   $0x1
  aa:	e8 46 05 00 00       	call   5f5 <printf>
  af:	83 c4 30             	add    $0x30,%esp
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
  b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  b9:	e9 18 01 00 00       	jmp    1d6 <main+0x1d6>
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
                     up[i].state, up[i].size);
  be:	8b 55 b8             	mov    -0x48(%ebp),%edx
  c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  c4:	6b c0 5c             	imul   $0x5c,%eax,%eax
  c7:	01 d0                	add    %edx,%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
  c9:	8b 40 38             	mov    0x38(%eax),%eax
  cc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
                     up[i].state, up[i].size);
  cf:	8b 55 b8             	mov    -0x48(%ebp),%edx
  d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  d5:	6b c0 5c             	imul   $0x5c,%eax,%eax
  d8:	01 d0                	add    %edx,%eax
  da:	8d 78 18             	lea    0x18(%eax),%edi
  dd:	89 7d b0             	mov    %edi,-0x50(%ebp)
    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
  e0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  e6:	6b c0 5c             	imul   $0x5c,%eax,%eax
  e9:	01 d0                	add    %edx,%eax
  eb:	8b 48 10             	mov    0x10(%eax),%ecx
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
  ee:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  f3:	89 c8                	mov    %ecx,%eax
  f5:	f7 e2                	mul    %edx
  f7:	89 d3                	mov    %edx,%ebx
  f9:	c1 eb 05             	shr    $0x5,%ebx
  fc:	6b c3 64             	imul   $0x64,%ebx,%eax
  ff:	89 cb                	mov    %ecx,%ebx
 101:	29 c3                	sub    %eax,%ebx
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
 103:	8b 55 b8             	mov    -0x48(%ebp),%edx
 106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 109:	6b c0 5c             	imul   $0x5c,%eax,%eax
 10c:	01 d0                	add    %edx,%eax
 10e:	8b 40 10             	mov    0x10(%eax),%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 111:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 116:	f7 e2                	mul    %edx
 118:	c1 ea 05             	shr    $0x5,%edx
 11b:	89 55 ac             	mov    %edx,-0x54(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
 11e:	8b 55 b8             	mov    -0x48(%ebp),%edx
 121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 124:	6b c0 5c             	imul   $0x5c,%eax,%eax
 127:	01 d0                	add    %edx,%eax
 129:	8b 48 14             	mov    0x14(%eax),%ecx
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 12c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 131:	89 c8                	mov    %ecx,%eax
 133:	f7 e2                	mul    %edx
 135:	89 d6                	mov    %edx,%esi
 137:	c1 ee 05             	shr    $0x5,%esi
 13a:	6b c6 64             	imul   $0x64,%esi,%eax
 13d:	89 ce                	mov    %ecx,%esi
 13f:	29 c6                	sub    %eax,%esi
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
 141:	8b 55 b8             	mov    -0x48(%ebp),%edx
 144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 147:	6b c0 5c             	imul   $0x5c,%eax,%eax
 14a:	01 d0                	add    %edx,%eax
 14c:	8b 40 14             	mov    0x14(%eax),%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 14f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 154:	f7 e2                	mul    %edx
 156:	89 d0                	mov    %edx,%eax
 158:	c1 e8 05             	shr    $0x5,%eax
 15b:	89 45 a8             	mov    %eax,-0x58(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
                     up[i].ppid, up[i].CPU_total_ticks / 100, up[i].CPU_total_ticks % 100, 
 15e:	8b 55 b8             	mov    -0x48(%ebp),%edx
 161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 164:	6b c0 5c             	imul   $0x5c,%eax,%eax
 167:	01 d0                	add    %edx,%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 169:	8b 48 0c             	mov    0xc(%eax),%ecx
 16c:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 16f:	8b 55 b8             	mov    -0x48(%ebp),%edx
 172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 175:	6b c0 5c             	imul   $0x5c,%eax,%eax
 178:	01 d0                	add    %edx,%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 17a:	8b 78 08             	mov    0x8(%eax),%edi
 17d:	89 7d a0             	mov    %edi,-0x60(%ebp)
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 180:	8b 55 b8             	mov    -0x48(%ebp),%edx
 183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 186:	6b c0 5c             	imul   $0x5c,%eax,%eax
 189:	01 d0                	add    %edx,%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 18b:	8b 78 04             	mov    0x4(%eax),%edi
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 18e:	8b 55 b8             	mov    -0x48(%ebp),%edx
 191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 194:	6b c0 5c             	imul   $0x5c,%eax,%eax
 197:	01 d0                	add    %edx,%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 199:	8b 08                	mov    (%eax),%ecx
                     up[i].name, up[i].pid, up[i].uid, up[i].gid, 
 19b:	8b 55 b8             	mov    -0x48(%ebp),%edx
 19e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1a1:	6b c0 5c             	imul   $0x5c,%eax,%eax
 1a4:	01 d0                	add    %edx,%eax
 1a6:	83 c0 3c             	add    $0x3c,%eax
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 
       printf(1, " %s\t | %d\t | %d\t | %d\t | %d\t | %d.%d\t | %d.%d\t | %s\t | %d\t | \n", 
 1a9:	83 ec 0c             	sub    $0xc,%esp
 1ac:	ff 75 b4             	pushl  -0x4c(%ebp)
 1af:	ff 75 b0             	pushl  -0x50(%ebp)
 1b2:	53                   	push   %ebx
 1b3:	ff 75 ac             	pushl  -0x54(%ebp)
 1b6:	56                   	push   %esi
 1b7:	ff 75 a8             	pushl  -0x58(%ebp)
 1ba:	ff 75 a4             	pushl  -0x5c(%ebp)
 1bd:	ff 75 a0             	pushl  -0x60(%ebp)
 1c0:	57                   	push   %edi
 1c1:	51                   	push   %ecx
 1c2:	50                   	push   %eax
 1c3:	68 1c 0a 00 00       	push   $0xa1c
 1c8:	6a 01                	push   $0x1
 1ca:	e8 26 04 00 00       	call   5f5 <printf>
 1cf:	83 c4 40             	add    $0x40,%esp

    
    printf(1, "%s\t | %s\t | %s\t | %s\t | %s\t | %s | %s | %s\t | %s\t | \n", 
                n, p,u,g,pp,tot,e,st,si);

    for(int  i = 0; i < MAX; i++){
 1d2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
 1dc:	0f 8c dc fe ff ff    	jl     be <main+0xbe>
                     up[i].elapsed_ticks / 100, up[i].elapsed_ticks % 100, 
                     up[i].state, up[i].size);

    }
    
    exit();
 1e2:	e8 57 02 00 00       	call   43e <exit>

000001e7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	57                   	push   %edi
 1eb:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1ef:	8b 55 10             	mov    0x10(%ebp),%edx
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	89 cb                	mov    %ecx,%ebx
 1f7:	89 df                	mov    %ebx,%edi
 1f9:	89 d1                	mov    %edx,%ecx
 1fb:	fc                   	cld    
 1fc:	f3 aa                	rep stos %al,%es:(%edi)
 1fe:	89 ca                	mov    %ecx,%edx
 200:	89 fb                	mov    %edi,%ebx
 202:	89 5d 08             	mov    %ebx,0x8(%ebp)
 205:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 208:	90                   	nop
 209:	5b                   	pop    %ebx
 20a:	5f                   	pop    %edi
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    

0000020d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 219:	90                   	nop
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	8d 50 01             	lea    0x1(%eax),%edx
 220:	89 55 08             	mov    %edx,0x8(%ebp)
 223:	8b 55 0c             	mov    0xc(%ebp),%edx
 226:	8d 4a 01             	lea    0x1(%edx),%ecx
 229:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 22c:	0f b6 12             	movzbl (%edx),%edx
 22f:	88 10                	mov    %dl,(%eax)
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	84 c0                	test   %al,%al
 236:	75 e2                	jne    21a <strcpy+0xd>
    ;
  return os;
 238:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 240:	eb 08                	jmp    24a <strcmp+0xd>
    p++, q++;
 242:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 246:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	74 10                	je     264 <strcmp+0x27>
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	38 c2                	cmp    %al,%dl
 262:	74 de                	je     242 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	0f b6 d0             	movzbl %al,%edx
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	0f b6 c0             	movzbl %al,%eax
 276:	29 c2                	sub    %eax,%edx
 278:	89 d0                	mov    %edx,%eax
}
 27a:	5d                   	pop    %ebp
 27b:	c3                   	ret    

0000027c <strlen>:

uint
strlen(char *s)
{
 27c:	55                   	push   %ebp
 27d:	89 e5                	mov    %esp,%ebp
 27f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 289:	eb 04                	jmp    28f <strlen+0x13>
 28b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	01 d0                	add    %edx,%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	84 c0                	test   %al,%al
 29c:	75 ed                	jne    28b <strlen+0xf>
    ;
  return n;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2a6:	8b 45 10             	mov    0x10(%ebp),%eax
 2a9:	50                   	push   %eax
 2aa:	ff 75 0c             	pushl  0xc(%ebp)
 2ad:	ff 75 08             	pushl  0x8(%ebp)
 2b0:	e8 32 ff ff ff       	call   1e7 <stosb>
 2b5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <strchr>:

char*
strchr(const char *s, char c)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2c9:	eb 14                	jmp    2df <strchr+0x22>
    if(*s == c)
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2d4:	75 05                	jne    2db <strchr+0x1e>
      return (char*)s;
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	eb 13                	jmp    2ee <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	84 c0                	test   %al,%al
 2e7:	75 e2                	jne    2cb <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ee:	c9                   	leave  
 2ef:	c3                   	ret    

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2fd:	eb 42                	jmp    341 <gets+0x51>
    cc = read(0, &c, 1);
 2ff:	83 ec 04             	sub    $0x4,%esp
 302:	6a 01                	push   $0x1
 304:	8d 45 ef             	lea    -0x11(%ebp),%eax
 307:	50                   	push   %eax
 308:	6a 00                	push   $0x0
 30a:	e8 47 01 00 00       	call   456 <read>
 30f:	83 c4 10             	add    $0x10,%esp
 312:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 319:	7e 33                	jle    34e <gets+0x5e>
      break;
    buf[i++] = c;
 31b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31e:	8d 50 01             	lea    0x1(%eax),%edx
 321:	89 55 f4             	mov    %edx,-0xc(%ebp)
 324:	89 c2                	mov    %eax,%edx
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	01 c2                	add    %eax,%edx
 32b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 331:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 335:	3c 0a                	cmp    $0xa,%al
 337:	74 16                	je     34f <gets+0x5f>
 339:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33d:	3c 0d                	cmp    $0xd,%al
 33f:	74 0e                	je     34f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 341:	8b 45 f4             	mov    -0xc(%ebp),%eax
 344:	83 c0 01             	add    $0x1,%eax
 347:	3b 45 0c             	cmp    0xc(%ebp),%eax
 34a:	7c b3                	jl     2ff <gets+0xf>
 34c:	eb 01                	jmp    34f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 34e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 34f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	01 d0                	add    %edx,%eax
 357:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35d:	c9                   	leave  
 35e:	c3                   	ret    

0000035f <stat>:

int
stat(char *n, struct stat *st)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 365:	83 ec 08             	sub    $0x8,%esp
 368:	6a 00                	push   $0x0
 36a:	ff 75 08             	pushl  0x8(%ebp)
 36d:	e8 0c 01 00 00       	call   47e <open>
 372:	83 c4 10             	add    $0x10,%esp
 375:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 378:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 37c:	79 07                	jns    385 <stat+0x26>
    return -1;
 37e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 383:	eb 25                	jmp    3aa <stat+0x4b>
  r = fstat(fd, st);
 385:	83 ec 08             	sub    $0x8,%esp
 388:	ff 75 0c             	pushl  0xc(%ebp)
 38b:	ff 75 f4             	pushl  -0xc(%ebp)
 38e:	e8 03 01 00 00       	call   496 <fstat>
 393:	83 c4 10             	add    $0x10,%esp
 396:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 399:	83 ec 0c             	sub    $0xc,%esp
 39c:	ff 75 f4             	pushl  -0xc(%ebp)
 39f:	e8 c2 00 00 00       	call   466 <close>
 3a4:	83 c4 10             	add    $0x10,%esp
  return r;
 3a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <atoi>:

int
atoi(const char *s)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b9:	eb 25                	jmp    3e0 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3be:	89 d0                	mov    %edx,%eax
 3c0:	c1 e0 02             	shl    $0x2,%eax
 3c3:	01 d0                	add    %edx,%eax
 3c5:	01 c0                	add    %eax,%eax
 3c7:	89 c1                	mov    %eax,%ecx
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	8d 50 01             	lea    0x1(%eax),%edx
 3cf:	89 55 08             	mov    %edx,0x8(%ebp)
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	0f be c0             	movsbl %al,%eax
 3d8:	01 c8                	add    %ecx,%eax
 3da:	83 e8 30             	sub    $0x30,%eax
 3dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	3c 2f                	cmp    $0x2f,%al
 3e8:	7e 0a                	jle    3f4 <atoi+0x48>
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	0f b6 00             	movzbl (%eax),%eax
 3f0:	3c 39                	cmp    $0x39,%al
 3f2:	7e c7                	jle    3bb <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f7:	c9                   	leave  
 3f8:	c3                   	ret    

000003f9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3f9:	55                   	push   %ebp
 3fa:	89 e5                	mov    %esp,%ebp
 3fc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 405:	8b 45 0c             	mov    0xc(%ebp),%eax
 408:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 40b:	eb 17                	jmp    424 <memmove+0x2b>
    *dst++ = *src++;
 40d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 410:	8d 50 01             	lea    0x1(%eax),%edx
 413:	89 55 fc             	mov    %edx,-0x4(%ebp)
 416:	8b 55 f8             	mov    -0x8(%ebp),%edx
 419:	8d 4a 01             	lea    0x1(%edx),%ecx
 41c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 41f:	0f b6 12             	movzbl (%edx),%edx
 422:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 424:	8b 45 10             	mov    0x10(%ebp),%eax
 427:	8d 50 ff             	lea    -0x1(%eax),%edx
 42a:	89 55 10             	mov    %edx,0x10(%ebp)
 42d:	85 c0                	test   %eax,%eax
 42f:	7f dc                	jg     40d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 431:	8b 45 08             	mov    0x8(%ebp),%eax
}
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 436:	b8 01 00 00 00       	mov    $0x1,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <exit>:
SYSCALL(exit)
 43e:	b8 02 00 00 00       	mov    $0x2,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <wait>:
SYSCALL(wait)
 446:	b8 03 00 00 00       	mov    $0x3,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <pipe>:
SYSCALL(pipe)
 44e:	b8 04 00 00 00       	mov    $0x4,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <read>:
SYSCALL(read)
 456:	b8 05 00 00 00       	mov    $0x5,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <write>:
SYSCALL(write)
 45e:	b8 10 00 00 00       	mov    $0x10,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <close>:
SYSCALL(close)
 466:	b8 15 00 00 00       	mov    $0x15,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <kill>:
SYSCALL(kill)
 46e:	b8 06 00 00 00       	mov    $0x6,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <exec>:
SYSCALL(exec)
 476:	b8 07 00 00 00       	mov    $0x7,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <open>:
SYSCALL(open)
 47e:	b8 0f 00 00 00       	mov    $0xf,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <mknod>:
SYSCALL(mknod)
 486:	b8 11 00 00 00       	mov    $0x11,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <unlink>:
SYSCALL(unlink)
 48e:	b8 12 00 00 00       	mov    $0x12,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <fstat>:
SYSCALL(fstat)
 496:	b8 08 00 00 00       	mov    $0x8,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <link>:
SYSCALL(link)
 49e:	b8 13 00 00 00       	mov    $0x13,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <mkdir>:
SYSCALL(mkdir)
 4a6:	b8 14 00 00 00       	mov    $0x14,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <chdir>:
SYSCALL(chdir)
 4ae:	b8 09 00 00 00       	mov    $0x9,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <dup>:
SYSCALL(dup)
 4b6:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <getpid>:
SYSCALL(getpid)
 4be:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <sbrk>:
SYSCALL(sbrk)
 4c6:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <sleep>:
SYSCALL(sleep)
 4ce:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <uptime>:
SYSCALL(uptime)
 4d6:	b8 0e 00 00 00       	mov    $0xe,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <halt>:
SYSCALL(halt)
 4de:	b8 16 00 00 00       	mov    $0x16,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <date>:
//Student Implementations 
SYSCALL(date)
 4e6:	b8 17 00 00 00       	mov    $0x17,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <getuid>:

SYSCALL(getuid)
 4ee:	b8 18 00 00 00       	mov    $0x18,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <getgid>:
SYSCALL(getgid)
 4f6:	b8 19 00 00 00       	mov    $0x19,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <getppid>:
SYSCALL(getppid)
 4fe:	b8 1a 00 00 00       	mov    $0x1a,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <setuid>:

SYSCALL(setuid)
 506:	b8 1b 00 00 00       	mov    $0x1b,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <setgid>:
SYSCALL(setgid)
 50e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <getprocs>:
SYSCALL(getprocs)
 516:	b8 1d 00 00 00       	mov    $0x1d,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 51e:	55                   	push   %ebp
 51f:	89 e5                	mov    %esp,%ebp
 521:	83 ec 18             	sub    $0x18,%esp
 524:	8b 45 0c             	mov    0xc(%ebp),%eax
 527:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 52a:	83 ec 04             	sub    $0x4,%esp
 52d:	6a 01                	push   $0x1
 52f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 532:	50                   	push   %eax
 533:	ff 75 08             	pushl  0x8(%ebp)
 536:	e8 23 ff ff ff       	call   45e <write>
 53b:	83 c4 10             	add    $0x10,%esp
}
 53e:	90                   	nop
 53f:	c9                   	leave  
 540:	c3                   	ret    

00000541 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 541:	55                   	push   %ebp
 542:	89 e5                	mov    %esp,%ebp
 544:	53                   	push   %ebx
 545:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 548:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 54f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 553:	74 17                	je     56c <printint+0x2b>
 555:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 559:	79 11                	jns    56c <printint+0x2b>
    neg = 1;
 55b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 562:	8b 45 0c             	mov    0xc(%ebp),%eax
 565:	f7 d8                	neg    %eax
 567:	89 45 ec             	mov    %eax,-0x14(%ebp)
 56a:	eb 06                	jmp    572 <printint+0x31>
  } else {
    x = xx;
 56c:	8b 45 0c             	mov    0xc(%ebp),%eax
 56f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 572:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 579:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 57c:	8d 41 01             	lea    0x1(%ecx),%eax
 57f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 582:	8b 5d 10             	mov    0x10(%ebp),%ebx
 585:	8b 45 ec             	mov    -0x14(%ebp),%eax
 588:	ba 00 00 00 00       	mov    $0x0,%edx
 58d:	f7 f3                	div    %ebx
 58f:	89 d0                	mov    %edx,%eax
 591:	0f b6 80 b8 0c 00 00 	movzbl 0xcb8(%eax),%eax
 598:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 59c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 59f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a2:	ba 00 00 00 00       	mov    $0x0,%edx
 5a7:	f7 f3                	div    %ebx
 5a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b0:	75 c7                	jne    579 <printint+0x38>
  if(neg)
 5b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b6:	74 2d                	je     5e5 <printint+0xa4>
    buf[i++] = '-';
 5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bb:	8d 50 01             	lea    0x1(%eax),%edx
 5be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5c1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5c6:	eb 1d                	jmp    5e5 <printint+0xa4>
    putc(fd, buf[i]);
 5c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ce:	01 d0                	add    %edx,%eax
 5d0:	0f b6 00             	movzbl (%eax),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	83 ec 08             	sub    $0x8,%esp
 5d9:	50                   	push   %eax
 5da:	ff 75 08             	pushl  0x8(%ebp)
 5dd:	e8 3c ff ff ff       	call   51e <putc>
 5e2:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5e5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ed:	79 d9                	jns    5c8 <printint+0x87>
    putc(fd, buf[i]);
}
 5ef:	90                   	nop
 5f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5f3:	c9                   	leave  
 5f4:	c3                   	ret    

000005f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5f5:	55                   	push   %ebp
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 602:	8d 45 0c             	lea    0xc(%ebp),%eax
 605:	83 c0 04             	add    $0x4,%eax
 608:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 60b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 612:	e9 59 01 00 00       	jmp    770 <printf+0x17b>
    c = fmt[i] & 0xff;
 617:	8b 55 0c             	mov    0xc(%ebp),%edx
 61a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61d:	01 d0                	add    %edx,%eax
 61f:	0f b6 00             	movzbl (%eax),%eax
 622:	0f be c0             	movsbl %al,%eax
 625:	25 ff 00 00 00       	and    $0xff,%eax
 62a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 62d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 631:	75 2c                	jne    65f <printf+0x6a>
      if(c == '%'){
 633:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 637:	75 0c                	jne    645 <printf+0x50>
        state = '%';
 639:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 640:	e9 27 01 00 00       	jmp    76c <printf+0x177>
      } else {
        putc(fd, c);
 645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 648:	0f be c0             	movsbl %al,%eax
 64b:	83 ec 08             	sub    $0x8,%esp
 64e:	50                   	push   %eax
 64f:	ff 75 08             	pushl  0x8(%ebp)
 652:	e8 c7 fe ff ff       	call   51e <putc>
 657:	83 c4 10             	add    $0x10,%esp
 65a:	e9 0d 01 00 00       	jmp    76c <printf+0x177>
      }
    } else if(state == '%'){
 65f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 663:	0f 85 03 01 00 00    	jne    76c <printf+0x177>
      if(c == 'd'){
 669:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 66d:	75 1e                	jne    68d <printf+0x98>
        printint(fd, *ap, 10, 1);
 66f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	6a 01                	push   $0x1
 676:	6a 0a                	push   $0xa
 678:	50                   	push   %eax
 679:	ff 75 08             	pushl  0x8(%ebp)
 67c:	e8 c0 fe ff ff       	call   541 <printint>
 681:	83 c4 10             	add    $0x10,%esp
        ap++;
 684:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 688:	e9 d8 00 00 00       	jmp    765 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 68d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 691:	74 06                	je     699 <printf+0xa4>
 693:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 697:	75 1e                	jne    6b7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 699:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	6a 00                	push   $0x0
 6a0:	6a 10                	push   $0x10
 6a2:	50                   	push   %eax
 6a3:	ff 75 08             	pushl  0x8(%ebp)
 6a6:	e8 96 fe ff ff       	call   541 <printint>
 6ab:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b2:	e9 ae 00 00 00       	jmp    765 <printf+0x170>
      } else if(c == 's'){
 6b7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6bb:	75 43                	jne    700 <printf+0x10b>
        s = (char*)*ap;
 6bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6cd:	75 25                	jne    6f4 <printf+0xff>
          s = "(null)";
 6cf:	c7 45 f4 5b 0a 00 00 	movl   $0xa5b,-0xc(%ebp)
        while(*s != 0){
 6d6:	eb 1c                	jmp    6f4 <printf+0xff>
          putc(fd, *s);
 6d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6db:	0f b6 00             	movzbl (%eax),%eax
 6de:	0f be c0             	movsbl %al,%eax
 6e1:	83 ec 08             	sub    $0x8,%esp
 6e4:	50                   	push   %eax
 6e5:	ff 75 08             	pushl  0x8(%ebp)
 6e8:	e8 31 fe ff ff       	call   51e <putc>
 6ed:	83 c4 10             	add    $0x10,%esp
          s++;
 6f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f7:	0f b6 00             	movzbl (%eax),%eax
 6fa:	84 c0                	test   %al,%al
 6fc:	75 da                	jne    6d8 <printf+0xe3>
 6fe:	eb 65                	jmp    765 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 700:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 704:	75 1d                	jne    723 <printf+0x12e>
        putc(fd, *ap);
 706:	8b 45 e8             	mov    -0x18(%ebp),%eax
 709:	8b 00                	mov    (%eax),%eax
 70b:	0f be c0             	movsbl %al,%eax
 70e:	83 ec 08             	sub    $0x8,%esp
 711:	50                   	push   %eax
 712:	ff 75 08             	pushl  0x8(%ebp)
 715:	e8 04 fe ff ff       	call   51e <putc>
 71a:	83 c4 10             	add    $0x10,%esp
        ap++;
 71d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 721:	eb 42                	jmp    765 <printf+0x170>
      } else if(c == '%'){
 723:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 727:	75 17                	jne    740 <printf+0x14b>
        putc(fd, c);
 729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72c:	0f be c0             	movsbl %al,%eax
 72f:	83 ec 08             	sub    $0x8,%esp
 732:	50                   	push   %eax
 733:	ff 75 08             	pushl  0x8(%ebp)
 736:	e8 e3 fd ff ff       	call   51e <putc>
 73b:	83 c4 10             	add    $0x10,%esp
 73e:	eb 25                	jmp    765 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 740:	83 ec 08             	sub    $0x8,%esp
 743:	6a 25                	push   $0x25
 745:	ff 75 08             	pushl  0x8(%ebp)
 748:	e8 d1 fd ff ff       	call   51e <putc>
 74d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	83 ec 08             	sub    $0x8,%esp
 759:	50                   	push   %eax
 75a:	ff 75 08             	pushl  0x8(%ebp)
 75d:	e8 bc fd ff ff       	call   51e <putc>
 762:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 765:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 76c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 770:	8b 55 0c             	mov    0xc(%ebp),%edx
 773:	8b 45 f0             	mov    -0x10(%ebp),%eax
 776:	01 d0                	add    %edx,%eax
 778:	0f b6 00             	movzbl (%eax),%eax
 77b:	84 c0                	test   %al,%al
 77d:	0f 85 94 fe ff ff    	jne    617 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 783:	90                   	nop
 784:	c9                   	leave  
 785:	c3                   	ret    

00000786 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 786:	55                   	push   %ebp
 787:	89 e5                	mov    %esp,%ebp
 789:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	83 e8 08             	sub    $0x8,%eax
 792:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 795:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 79a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79d:	eb 24                	jmp    7c3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a7:	77 12                	ja     7bb <free+0x35>
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7af:	77 24                	ja     7d5 <free+0x4f>
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b9:	77 1a                	ja     7d5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c9:	76 d4                	jbe    79f <free+0x19>
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 00                	mov    (%eax),%eax
 7d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d3:	76 ca                	jbe    79f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	01 c2                	add    %eax,%edx
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	39 c2                	cmp    %eax,%edx
 7ee:	75 24                	jne    814 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f3:	8b 50 04             	mov    0x4(%eax),%edx
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	8b 00                	mov    (%eax),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	01 c2                	add    %eax,%edx
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 00                	mov    (%eax),%eax
 80b:	8b 10                	mov    (%eax),%edx
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	89 10                	mov    %edx,(%eax)
 812:	eb 0a                	jmp    81e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	8b 10                	mov    (%eax),%edx
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	01 d0                	add    %edx,%eax
 830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 833:	75 20                	jne    855 <free+0xcf>
    p->s.size += bp->s.size;
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	8b 50 04             	mov    0x4(%eax),%edx
 83b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	01 c2                	add    %eax,%edx
 843:	8b 45 fc             	mov    -0x4(%ebp),%eax
 846:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 849:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84c:	8b 10                	mov    (%eax),%edx
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	89 10                	mov    %edx,(%eax)
 853:	eb 08                	jmp    85d <free+0xd7>
  } else
    p->s.ptr = bp;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 55 f8             	mov    -0x8(%ebp),%edx
 85b:	89 10                	mov    %edx,(%eax)
  freep = p;
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	a3 d4 0c 00 00       	mov    %eax,0xcd4
}
 865:	90                   	nop
 866:	c9                   	leave  
 867:	c3                   	ret    

00000868 <morecore>:

static Header*
morecore(uint nu)
{
 868:	55                   	push   %ebp
 869:	89 e5                	mov    %esp,%ebp
 86b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 86e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 875:	77 07                	ja     87e <morecore+0x16>
    nu = 4096;
 877:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 87e:	8b 45 08             	mov    0x8(%ebp),%eax
 881:	c1 e0 03             	shl    $0x3,%eax
 884:	83 ec 0c             	sub    $0xc,%esp
 887:	50                   	push   %eax
 888:	e8 39 fc ff ff       	call   4c6 <sbrk>
 88d:	83 c4 10             	add    $0x10,%esp
 890:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 893:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 897:	75 07                	jne    8a0 <morecore+0x38>
    return 0;
 899:	b8 00 00 00 00       	mov    $0x0,%eax
 89e:	eb 26                	jmp    8c6 <morecore+0x5e>
  hp = (Header*)p;
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a9:	8b 55 08             	mov    0x8(%ebp),%edx
 8ac:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b2:	83 c0 08             	add    $0x8,%eax
 8b5:	83 ec 0c             	sub    $0xc,%esp
 8b8:	50                   	push   %eax
 8b9:	e8 c8 fe ff ff       	call   786 <free>
 8be:	83 c4 10             	add    $0x10,%esp
  return freep;
 8c1:	a1 d4 0c 00 00       	mov    0xcd4,%eax
}
 8c6:	c9                   	leave  
 8c7:	c3                   	ret    

000008c8 <malloc>:

void*
malloc(uint nbytes)
{
 8c8:	55                   	push   %ebp
 8c9:	89 e5                	mov    %esp,%ebp
 8cb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	83 c0 07             	add    $0x7,%eax
 8d4:	c1 e8 03             	shr    $0x3,%eax
 8d7:	83 c0 01             	add    $0x1,%eax
 8da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8dd:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 8e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e9:	75 23                	jne    90e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8eb:	c7 45 f0 cc 0c 00 00 	movl   $0xccc,-0x10(%ebp)
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	a3 d4 0c 00 00       	mov    %eax,0xcd4
 8fa:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 8ff:	a3 cc 0c 00 00       	mov    %eax,0xccc
    base.s.size = 0;
 904:	c7 05 d0 0c 00 00 00 	movl   $0x0,0xcd0
 90b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	8b 40 04             	mov    0x4(%eax),%eax
 91c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 91f:	72 4d                	jb     96e <malloc+0xa6>
      if(p->s.size == nunits)
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 92a:	75 0c                	jne    938 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	8b 10                	mov    (%eax),%edx
 931:	8b 45 f0             	mov    -0x10(%ebp),%eax
 934:	89 10                	mov    %edx,(%eax)
 936:	eb 26                	jmp    95e <malloc+0x96>
      else {
        p->s.size -= nunits;
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 40 04             	mov    0x4(%eax),%eax
 93e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 941:	89 c2                	mov    %eax,%edx
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	8b 40 04             	mov    0x4(%eax),%eax
 94f:	c1 e0 03             	shl    $0x3,%eax
 952:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 55 ec             	mov    -0x14(%ebp),%edx
 95b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 95e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 961:	a3 d4 0c 00 00       	mov    %eax,0xcd4
      return (void*)(p + 1);
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	83 c0 08             	add    $0x8,%eax
 96c:	eb 3b                	jmp    9a9 <malloc+0xe1>
    }
    if(p == freep)
 96e:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 973:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 976:	75 1e                	jne    996 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 978:	83 ec 0c             	sub    $0xc,%esp
 97b:	ff 75 ec             	pushl  -0x14(%ebp)
 97e:	e8 e5 fe ff ff       	call   868 <morecore>
 983:	83 c4 10             	add    $0x10,%esp
 986:	89 45 f4             	mov    %eax,-0xc(%ebp)
 989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98d:	75 07                	jne    996 <malloc+0xce>
        return 0;
 98f:	b8 00 00 00 00       	mov    $0x0,%eax
 994:	eb 13                	jmp    9a9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9a4:	e9 6d ff ff ff       	jmp    916 <malloc+0x4e>
}
 9a9:	c9                   	leave  
 9aa:	c3                   	ret    
