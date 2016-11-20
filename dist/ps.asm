
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
  1b:	c7 45 dc 44 0c 00 00 	movl   $0xc44,-0x24(%ebp)
          *p = "PID",
  22:	c7 45 d8 49 0c 00 00 	movl   $0xc49,-0x28(%ebp)
          *u = "UID",
  29:	c7 45 d4 4d 0c 00 00 	movl   $0xc4d,-0x2c(%ebp)
          *g = "GID",
  30:	c7 45 d0 51 0c 00 00 	movl   $0xc51,-0x30(%ebp)
          *pp = "PPID",
  37:	c7 45 cc 55 0c 00 00 	movl   $0xc55,-0x34(%ebp)
          *tot = "CPU (s)",
  3e:	c7 45 c8 5a 0c 00 00 	movl   $0xc5a,-0x38(%ebp)
          *e = "Elapsed (s)",
  45:	c7 45 c4 62 0c 00 00 	movl   $0xc62,-0x3c(%ebp)
          *st = "State",
  4c:	c7 45 c0 6e 0c 00 00 	movl   $0xc6e,-0x40(%ebp)
          *si = "Size";
  53:	c7 45 bc 74 0c 00 00 	movl   $0xc74,-0x44(%ebp)
 
    up =  malloc( sizeof(&up) * MAX);
  5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  5d:	c1 e0 02             	shl    $0x2,%eax
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	50                   	push   %eax
  64:	e8 f6 0a 00 00       	call   b5f <malloc>
  69:	83 c4 10             	add    $0x10,%esp
  6c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    MAX =  getprocs(MAX, up);
  6f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  75:	83 ec 08             	sub    $0x8,%esp
  78:	52                   	push   %edx
  79:	50                   	push   %eax
  7a:	e8 2e 07 00 00       	call   7ad <getprocs>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	89 45 e0             	mov    %eax,-0x20(%ebp)
    
    if(MAX < 0){
  85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  89:	79 17                	jns    a2 <main+0xa2>
        printf(1, "getprocs failed\n");
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 79 0c 00 00       	push   $0xc79
  93:	6a 01                	push   $0x1
  95:	e8 f2 07 00 00       	call   88c <printf>
  9a:	83 c4 10             	add    $0x10,%esp
    exit();
  9d:	e8 33 06 00 00       	call   6d5 <exit>
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
  c0:	68 8c 0c 00 00       	push   $0xc8c
  c5:	6a 01                	push   $0x1
  c7:	e8 c0 07 00 00       	call   88c <printf>
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
 1e0:	68 c4 0c 00 00       	push   $0xcc4
 1e5:	6a 01                	push   $0x1
 1e7:	e8 a0 06 00 00       	call   88c <printf>
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
 1ff:	e8 d1 04 00 00       	call   6d5 <exit>

00000204 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b7 00             	movzwl (%eax),%eax
 210:	98                   	cwtl   
 211:	83 f8 02             	cmp    $0x2,%eax
 214:	74 1e                	je     234 <print_mode+0x30>
 216:	83 f8 03             	cmp    $0x3,%eax
 219:	74 2d                	je     248 <print_mode+0x44>
 21b:	83 f8 01             	cmp    $0x1,%eax
 21e:	75 3c                	jne    25c <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 220:	83 ec 08             	sub    $0x8,%esp
 223:	68 03 0d 00 00       	push   $0xd03
 228:	6a 01                	push   $0x1
 22a:	e8 5d 06 00 00       	call   88c <printf>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	eb 3a                	jmp    26e <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 234:	83 ec 08             	sub    $0x8,%esp
 237:	68 05 0d 00 00       	push   $0xd05
 23c:	6a 01                	push   $0x1
 23e:	e8 49 06 00 00       	call   88c <printf>
 243:	83 c4 10             	add    $0x10,%esp
 246:	eb 26                	jmp    26e <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 248:	83 ec 08             	sub    $0x8,%esp
 24b:	68 07 0d 00 00       	push   $0xd07
 250:	6a 01                	push   $0x1
 252:	e8 35 06 00 00       	call   88c <printf>
 257:	83 c4 10             	add    $0x10,%esp
 25a:	eb 12                	jmp    26e <print_mode+0x6a>
    default: printf(1, "?");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 09 0d 00 00       	push   $0xd09
 264:	6a 01                	push   $0x1
 266:	e8 21 06 00 00       	call   88c <printf>
 26b:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 275:	83 e0 01             	and    $0x1,%eax
 278:	84 c0                	test   %al,%al
 27a:	74 14                	je     290 <print_mode+0x8c>
    printf(1, "r");
 27c:	83 ec 08             	sub    $0x8,%esp
 27f:	68 0b 0d 00 00       	push   $0xd0b
 284:	6a 01                	push   $0x1
 286:	e8 01 06 00 00       	call   88c <printf>
 28b:	83 c4 10             	add    $0x10,%esp
 28e:	eb 12                	jmp    2a2 <print_mode+0x9e>
  else
    printf(1, "-");
 290:	83 ec 08             	sub    $0x8,%esp
 293:	68 05 0d 00 00       	push   $0xd05
 298:	6a 01                	push   $0x1
 29a:	e8 ed 05 00 00       	call   88c <printf>
 29f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2a9:	83 e0 80             	and    $0xffffff80,%eax
 2ac:	84 c0                	test   %al,%al
 2ae:	74 14                	je     2c4 <print_mode+0xc0>
    printf(1, "w");
 2b0:	83 ec 08             	sub    $0x8,%esp
 2b3:	68 0d 0d 00 00       	push   $0xd0d
 2b8:	6a 01                	push   $0x1
 2ba:	e8 cd 05 00 00       	call   88c <printf>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	eb 12                	jmp    2d6 <print_mode+0xd2>
  else
    printf(1, "-");
 2c4:	83 ec 08             	sub    $0x8,%esp
 2c7:	68 05 0d 00 00       	push   $0xd05
 2cc:	6a 01                	push   $0x1
 2ce:	e8 b9 05 00 00       	call   88c <printf>
 2d3:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2dd:	c0 e8 06             	shr    $0x6,%al
 2e0:	83 e0 01             	and    $0x1,%eax
 2e3:	0f b6 d0             	movzbl %al,%edx
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 2ed:	d0 e8                	shr    %al
 2ef:	83 e0 01             	and    $0x1,%eax
 2f2:	0f b6 c0             	movzbl %al,%eax
 2f5:	21 d0                	and    %edx,%eax
 2f7:	85 c0                	test   %eax,%eax
 2f9:	74 14                	je     30f <print_mode+0x10b>
    printf(1, "S");
 2fb:	83 ec 08             	sub    $0x8,%esp
 2fe:	68 0f 0d 00 00       	push   $0xd0f
 303:	6a 01                	push   $0x1
 305:	e8 82 05 00 00       	call   88c <printf>
 30a:	83 c4 10             	add    $0x10,%esp
 30d:	eb 34                	jmp    343 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 316:	83 e0 40             	and    $0x40,%eax
 319:	84 c0                	test   %al,%al
 31b:	74 14                	je     331 <print_mode+0x12d>
    printf(1, "x");
 31d:	83 ec 08             	sub    $0x8,%esp
 320:	68 11 0d 00 00       	push   $0xd11
 325:	6a 01                	push   $0x1
 327:	e8 60 05 00 00       	call   88c <printf>
 32c:	83 c4 10             	add    $0x10,%esp
 32f:	eb 12                	jmp    343 <print_mode+0x13f>
  else
    printf(1, "-");
 331:	83 ec 08             	sub    $0x8,%esp
 334:	68 05 0d 00 00       	push   $0xd05
 339:	6a 01                	push   $0x1
 33b:	e8 4c 05 00 00       	call   88c <printf>
 340:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 34a:	83 e0 20             	and    $0x20,%eax
 34d:	84 c0                	test   %al,%al
 34f:	74 14                	je     365 <print_mode+0x161>
    printf(1, "r");
 351:	83 ec 08             	sub    $0x8,%esp
 354:	68 0b 0d 00 00       	push   $0xd0b
 359:	6a 01                	push   $0x1
 35b:	e8 2c 05 00 00       	call   88c <printf>
 360:	83 c4 10             	add    $0x10,%esp
 363:	eb 12                	jmp    377 <print_mode+0x173>
  else
    printf(1, "-");
 365:	83 ec 08             	sub    $0x8,%esp
 368:	68 05 0d 00 00       	push   $0xd05
 36d:	6a 01                	push   $0x1
 36f:	e8 18 05 00 00       	call   88c <printf>
 374:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 37e:	83 e0 10             	and    $0x10,%eax
 381:	84 c0                	test   %al,%al
 383:	74 14                	je     399 <print_mode+0x195>
    printf(1, "w");
 385:	83 ec 08             	sub    $0x8,%esp
 388:	68 0d 0d 00 00       	push   $0xd0d
 38d:	6a 01                	push   $0x1
 38f:	e8 f8 04 00 00       	call   88c <printf>
 394:	83 c4 10             	add    $0x10,%esp
 397:	eb 12                	jmp    3ab <print_mode+0x1a7>
  else
    printf(1, "-");
 399:	83 ec 08             	sub    $0x8,%esp
 39c:	68 05 0d 00 00       	push   $0xd05
 3a1:	6a 01                	push   $0x1
 3a3:	e8 e4 04 00 00       	call   88c <printf>
 3a8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3b2:	83 e0 08             	and    $0x8,%eax
 3b5:	84 c0                	test   %al,%al
 3b7:	74 14                	je     3cd <print_mode+0x1c9>
    printf(1, "x");
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	68 11 0d 00 00       	push   $0xd11
 3c1:	6a 01                	push   $0x1
 3c3:	e8 c4 04 00 00       	call   88c <printf>
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	eb 12                	jmp    3df <print_mode+0x1db>
  else
    printf(1, "-");
 3cd:	83 ec 08             	sub    $0x8,%esp
 3d0:	68 05 0d 00 00       	push   $0xd05
 3d5:	6a 01                	push   $0x1
 3d7:	e8 b0 04 00 00       	call   88c <printf>
 3dc:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3e6:	83 e0 04             	and    $0x4,%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	74 14                	je     401 <print_mode+0x1fd>
    printf(1, "r");
 3ed:	83 ec 08             	sub    $0x8,%esp
 3f0:	68 0b 0d 00 00       	push   $0xd0b
 3f5:	6a 01                	push   $0x1
 3f7:	e8 90 04 00 00       	call   88c <printf>
 3fc:	83 c4 10             	add    $0x10,%esp
 3ff:	eb 12                	jmp    413 <print_mode+0x20f>
  else
    printf(1, "-");
 401:	83 ec 08             	sub    $0x8,%esp
 404:	68 05 0d 00 00       	push   $0xd05
 409:	6a 01                	push   $0x1
 40b:	e8 7c 04 00 00       	call   88c <printf>
 410:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 41a:	83 e0 02             	and    $0x2,%eax
 41d:	84 c0                	test   %al,%al
 41f:	74 14                	je     435 <print_mode+0x231>
    printf(1, "w");
 421:	83 ec 08             	sub    $0x8,%esp
 424:	68 0d 0d 00 00       	push   $0xd0d
 429:	6a 01                	push   $0x1
 42b:	e8 5c 04 00 00       	call   88c <printf>
 430:	83 c4 10             	add    $0x10,%esp
 433:	eb 12                	jmp    447 <print_mode+0x243>
  else
    printf(1, "-");
 435:	83 ec 08             	sub    $0x8,%esp
 438:	68 05 0d 00 00       	push   $0xd05
 43d:	6a 01                	push   $0x1
 43f:	e8 48 04 00 00       	call   88c <printf>
 444:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 44e:	83 e0 01             	and    $0x1,%eax
 451:	84 c0                	test   %al,%al
 453:	74 14                	je     469 <print_mode+0x265>
    printf(1, "x");
 455:	83 ec 08             	sub    $0x8,%esp
 458:	68 11 0d 00 00       	push   $0xd11
 45d:	6a 01                	push   $0x1
 45f:	e8 28 04 00 00       	call   88c <printf>
 464:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 467:	eb 13                	jmp    47c <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 469:	83 ec 08             	sub    $0x8,%esp
 46c:	68 05 0d 00 00       	push   $0xd05
 471:	6a 01                	push   $0x1
 473:	e8 14 04 00 00       	call   88c <printf>
 478:	83 c4 10             	add    $0x10,%esp

  return;
 47b:	90                   	nop
}
 47c:	c9                   	leave  
 47d:	c3                   	ret    

0000047e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 47e:	55                   	push   %ebp
 47f:	89 e5                	mov    %esp,%ebp
 481:	57                   	push   %edi
 482:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 483:	8b 4d 08             	mov    0x8(%ebp),%ecx
 486:	8b 55 10             	mov    0x10(%ebp),%edx
 489:	8b 45 0c             	mov    0xc(%ebp),%eax
 48c:	89 cb                	mov    %ecx,%ebx
 48e:	89 df                	mov    %ebx,%edi
 490:	89 d1                	mov    %edx,%ecx
 492:	fc                   	cld    
 493:	f3 aa                	rep stos %al,%es:(%edi)
 495:	89 ca                	mov    %ecx,%edx
 497:	89 fb                	mov    %edi,%ebx
 499:	89 5d 08             	mov    %ebx,0x8(%ebp)
 49c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 49f:	90                   	nop
 4a0:	5b                   	pop    %ebx
 4a1:	5f                   	pop    %edi
 4a2:	5d                   	pop    %ebp
 4a3:	c3                   	ret    

000004a4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 4aa:	8b 45 08             	mov    0x8(%ebp),%eax
 4ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 4b0:	90                   	nop
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	8d 50 01             	lea    0x1(%eax),%edx
 4b7:	89 55 08             	mov    %edx,0x8(%ebp)
 4ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 4bd:	8d 4a 01             	lea    0x1(%edx),%ecx
 4c0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 4c3:	0f b6 12             	movzbl (%edx),%edx
 4c6:	88 10                	mov    %dl,(%eax)
 4c8:	0f b6 00             	movzbl (%eax),%eax
 4cb:	84 c0                	test   %al,%al
 4cd:	75 e2                	jne    4b1 <strcpy+0xd>
    ;
  return os;
 4cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4d2:	c9                   	leave  
 4d3:	c3                   	ret    

000004d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 4d7:	eb 08                	jmp    4e1 <strcmp+0xd>
    p++, q++;
 4d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	0f b6 00             	movzbl (%eax),%eax
 4e7:	84 c0                	test   %al,%al
 4e9:	74 10                	je     4fb <strcmp+0x27>
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ee:	0f b6 10             	movzbl (%eax),%edx
 4f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f4:	0f b6 00             	movzbl (%eax),%eax
 4f7:	38 c2                	cmp    %al,%dl
 4f9:	74 de                	je     4d9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	0f b6 00             	movzbl (%eax),%eax
 501:	0f b6 d0             	movzbl %al,%edx
 504:	8b 45 0c             	mov    0xc(%ebp),%eax
 507:	0f b6 00             	movzbl (%eax),%eax
 50a:	0f b6 c0             	movzbl %al,%eax
 50d:	29 c2                	sub    %eax,%edx
 50f:	89 d0                	mov    %edx,%eax
}
 511:	5d                   	pop    %ebp
 512:	c3                   	ret    

00000513 <strlen>:

uint
strlen(char *s)
{
 513:	55                   	push   %ebp
 514:	89 e5                	mov    %esp,%ebp
 516:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 519:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 520:	eb 04                	jmp    526 <strlen+0x13>
 522:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 526:	8b 55 fc             	mov    -0x4(%ebp),%edx
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	01 d0                	add    %edx,%eax
 52e:	0f b6 00             	movzbl (%eax),%eax
 531:	84 c0                	test   %al,%al
 533:	75 ed                	jne    522 <strlen+0xf>
    ;
  return n;
 535:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 538:	c9                   	leave  
 539:	c3                   	ret    

0000053a <memset>:

void*
memset(void *dst, int c, uint n)
{
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 53d:	8b 45 10             	mov    0x10(%ebp),%eax
 540:	50                   	push   %eax
 541:	ff 75 0c             	pushl  0xc(%ebp)
 544:	ff 75 08             	pushl  0x8(%ebp)
 547:	e8 32 ff ff ff       	call   47e <stosb>
 54c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 552:	c9                   	leave  
 553:	c3                   	ret    

00000554 <strchr>:

char*
strchr(const char *s, char c)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	83 ec 04             	sub    $0x4,%esp
 55a:	8b 45 0c             	mov    0xc(%ebp),%eax
 55d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 560:	eb 14                	jmp    576 <strchr+0x22>
    if(*s == c)
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	3a 45 fc             	cmp    -0x4(%ebp),%al
 56b:	75 05                	jne    572 <strchr+0x1e>
      return (char*)s;
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	eb 13                	jmp    585 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 572:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	0f b6 00             	movzbl (%eax),%eax
 57c:	84 c0                	test   %al,%al
 57e:	75 e2                	jne    562 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 580:	b8 00 00 00 00       	mov    $0x0,%eax
}
 585:	c9                   	leave  
 586:	c3                   	ret    

00000587 <gets>:

char*
gets(char *buf, int max)
{
 587:	55                   	push   %ebp
 588:	89 e5                	mov    %esp,%ebp
 58a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 58d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 594:	eb 42                	jmp    5d8 <gets+0x51>
    cc = read(0, &c, 1);
 596:	83 ec 04             	sub    $0x4,%esp
 599:	6a 01                	push   $0x1
 59b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 59e:	50                   	push   %eax
 59f:	6a 00                	push   $0x0
 5a1:	e8 47 01 00 00       	call   6ed <read>
 5a6:	83 c4 10             	add    $0x10,%esp
 5a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b0:	7e 33                	jle    5e5 <gets+0x5e>
      break;
    buf[i++] = c;
 5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b5:	8d 50 01             	lea    0x1(%eax),%edx
 5b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5bb:	89 c2                	mov    %eax,%edx
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	01 c2                	add    %eax,%edx
 5c2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5c6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 5c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5cc:	3c 0a                	cmp    $0xa,%al
 5ce:	74 16                	je     5e6 <gets+0x5f>
 5d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5d4:	3c 0d                	cmp    $0xd,%al
 5d6:	74 0e                	je     5e6 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	83 c0 01             	add    $0x1,%eax
 5de:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5e1:	7c b3                	jl     596 <gets+0xf>
 5e3:	eb 01                	jmp    5e6 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 5e5:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	01 d0                	add    %edx,%eax
 5ee:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5f4:	c9                   	leave  
 5f5:	c3                   	ret    

000005f6 <stat>:

int
stat(char *n, struct stat *st)
{
 5f6:	55                   	push   %ebp
 5f7:	89 e5                	mov    %esp,%ebp
 5f9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5fc:	83 ec 08             	sub    $0x8,%esp
 5ff:	6a 00                	push   $0x0
 601:	ff 75 08             	pushl  0x8(%ebp)
 604:	e8 0c 01 00 00       	call   715 <open>
 609:	83 c4 10             	add    $0x10,%esp
 60c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 60f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 613:	79 07                	jns    61c <stat+0x26>
    return -1;
 615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 61a:	eb 25                	jmp    641 <stat+0x4b>
  r = fstat(fd, st);
 61c:	83 ec 08             	sub    $0x8,%esp
 61f:	ff 75 0c             	pushl  0xc(%ebp)
 622:	ff 75 f4             	pushl  -0xc(%ebp)
 625:	e8 03 01 00 00       	call   72d <fstat>
 62a:	83 c4 10             	add    $0x10,%esp
 62d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	ff 75 f4             	pushl  -0xc(%ebp)
 636:	e8 c2 00 00 00       	call   6fd <close>
 63b:	83 c4 10             	add    $0x10,%esp
  return r;
 63e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 641:	c9                   	leave  
 642:	c3                   	ret    

00000643 <atoi>:

int
atoi(const char *s)
{
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 649:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 650:	eb 25                	jmp    677 <atoi+0x34>
    n = n*10 + *s++ - '0';
 652:	8b 55 fc             	mov    -0x4(%ebp),%edx
 655:	89 d0                	mov    %edx,%eax
 657:	c1 e0 02             	shl    $0x2,%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	01 c0                	add    %eax,%eax
 65e:	89 c1                	mov    %eax,%ecx
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	8d 50 01             	lea    0x1(%eax),%edx
 666:	89 55 08             	mov    %edx,0x8(%ebp)
 669:	0f b6 00             	movzbl (%eax),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	01 c8                	add    %ecx,%eax
 671:	83 e8 30             	sub    $0x30,%eax
 674:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	0f b6 00             	movzbl (%eax),%eax
 67d:	3c 2f                	cmp    $0x2f,%al
 67f:	7e 0a                	jle    68b <atoi+0x48>
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	0f b6 00             	movzbl (%eax),%eax
 687:	3c 39                	cmp    $0x39,%al
 689:	7e c7                	jle    652 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 68e:	c9                   	leave  
 68f:	c3                   	ret    

00000690 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 696:	8b 45 08             	mov    0x8(%ebp),%eax
 699:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 69c:	8b 45 0c             	mov    0xc(%ebp),%eax
 69f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 6a2:	eb 17                	jmp    6bb <memmove+0x2b>
    *dst++ = *src++;
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8d 50 01             	lea    0x1(%eax),%edx
 6aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b0:	8d 4a 01             	lea    0x1(%edx),%ecx
 6b3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6b6:	0f b6 12             	movzbl (%edx),%edx
 6b9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6bb:	8b 45 10             	mov    0x10(%ebp),%eax
 6be:	8d 50 ff             	lea    -0x1(%eax),%edx
 6c1:	89 55 10             	mov    %edx,0x10(%ebp)
 6c4:	85 c0                	test   %eax,%eax
 6c6:	7f dc                	jg     6a4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 6c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6cb:	c9                   	leave  
 6cc:	c3                   	ret    

000006cd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6cd:	b8 01 00 00 00       	mov    $0x1,%eax
 6d2:	cd 40                	int    $0x40
 6d4:	c3                   	ret    

000006d5 <exit>:
SYSCALL(exit)
 6d5:	b8 02 00 00 00       	mov    $0x2,%eax
 6da:	cd 40                	int    $0x40
 6dc:	c3                   	ret    

000006dd <wait>:
SYSCALL(wait)
 6dd:	b8 03 00 00 00       	mov    $0x3,%eax
 6e2:	cd 40                	int    $0x40
 6e4:	c3                   	ret    

000006e5 <pipe>:
SYSCALL(pipe)
 6e5:	b8 04 00 00 00       	mov    $0x4,%eax
 6ea:	cd 40                	int    $0x40
 6ec:	c3                   	ret    

000006ed <read>:
SYSCALL(read)
 6ed:	b8 05 00 00 00       	mov    $0x5,%eax
 6f2:	cd 40                	int    $0x40
 6f4:	c3                   	ret    

000006f5 <write>:
SYSCALL(write)
 6f5:	b8 10 00 00 00       	mov    $0x10,%eax
 6fa:	cd 40                	int    $0x40
 6fc:	c3                   	ret    

000006fd <close>:
SYSCALL(close)
 6fd:	b8 15 00 00 00       	mov    $0x15,%eax
 702:	cd 40                	int    $0x40
 704:	c3                   	ret    

00000705 <kill>:
SYSCALL(kill)
 705:	b8 06 00 00 00       	mov    $0x6,%eax
 70a:	cd 40                	int    $0x40
 70c:	c3                   	ret    

0000070d <exec>:
SYSCALL(exec)
 70d:	b8 07 00 00 00       	mov    $0x7,%eax
 712:	cd 40                	int    $0x40
 714:	c3                   	ret    

00000715 <open>:
SYSCALL(open)
 715:	b8 0f 00 00 00       	mov    $0xf,%eax
 71a:	cd 40                	int    $0x40
 71c:	c3                   	ret    

0000071d <mknod>:
SYSCALL(mknod)
 71d:	b8 11 00 00 00       	mov    $0x11,%eax
 722:	cd 40                	int    $0x40
 724:	c3                   	ret    

00000725 <unlink>:
SYSCALL(unlink)
 725:	b8 12 00 00 00       	mov    $0x12,%eax
 72a:	cd 40                	int    $0x40
 72c:	c3                   	ret    

0000072d <fstat>:
SYSCALL(fstat)
 72d:	b8 08 00 00 00       	mov    $0x8,%eax
 732:	cd 40                	int    $0x40
 734:	c3                   	ret    

00000735 <link>:
SYSCALL(link)
 735:	b8 13 00 00 00       	mov    $0x13,%eax
 73a:	cd 40                	int    $0x40
 73c:	c3                   	ret    

0000073d <mkdir>:
SYSCALL(mkdir)
 73d:	b8 14 00 00 00       	mov    $0x14,%eax
 742:	cd 40                	int    $0x40
 744:	c3                   	ret    

00000745 <chdir>:
SYSCALL(chdir)
 745:	b8 09 00 00 00       	mov    $0x9,%eax
 74a:	cd 40                	int    $0x40
 74c:	c3                   	ret    

0000074d <dup>:
SYSCALL(dup)
 74d:	b8 0a 00 00 00       	mov    $0xa,%eax
 752:	cd 40                	int    $0x40
 754:	c3                   	ret    

00000755 <getpid>:
SYSCALL(getpid)
 755:	b8 0b 00 00 00       	mov    $0xb,%eax
 75a:	cd 40                	int    $0x40
 75c:	c3                   	ret    

0000075d <sbrk>:
SYSCALL(sbrk)
 75d:	b8 0c 00 00 00       	mov    $0xc,%eax
 762:	cd 40                	int    $0x40
 764:	c3                   	ret    

00000765 <sleep>:
SYSCALL(sleep)
 765:	b8 0d 00 00 00       	mov    $0xd,%eax
 76a:	cd 40                	int    $0x40
 76c:	c3                   	ret    

0000076d <uptime>:
SYSCALL(uptime)
 76d:	b8 0e 00 00 00       	mov    $0xe,%eax
 772:	cd 40                	int    $0x40
 774:	c3                   	ret    

00000775 <halt>:
SYSCALL(halt)
 775:	b8 16 00 00 00       	mov    $0x16,%eax
 77a:	cd 40                	int    $0x40
 77c:	c3                   	ret    

0000077d <date>:
//Student Implementations 
SYSCALL(date)
 77d:	b8 17 00 00 00       	mov    $0x17,%eax
 782:	cd 40                	int    $0x40
 784:	c3                   	ret    

00000785 <getuid>:

SYSCALL(getuid)
 785:	b8 18 00 00 00       	mov    $0x18,%eax
 78a:	cd 40                	int    $0x40
 78c:	c3                   	ret    

0000078d <getgid>:
SYSCALL(getgid)
 78d:	b8 19 00 00 00       	mov    $0x19,%eax
 792:	cd 40                	int    $0x40
 794:	c3                   	ret    

00000795 <getppid>:
SYSCALL(getppid)
 795:	b8 1a 00 00 00       	mov    $0x1a,%eax
 79a:	cd 40                	int    $0x40
 79c:	c3                   	ret    

0000079d <setuid>:

SYSCALL(setuid)
 79d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 7a2:	cd 40                	int    $0x40
 7a4:	c3                   	ret    

000007a5 <setgid>:
SYSCALL(setgid)
 7a5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 7aa:	cd 40                	int    $0x40
 7ac:	c3                   	ret    

000007ad <getprocs>:
SYSCALL(getprocs)
 7ad:	b8 1d 00 00 00       	mov    $0x1d,%eax
 7b2:	cd 40                	int    $0x40
 7b4:	c3                   	ret    

000007b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7b5:	55                   	push   %ebp
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	83 ec 18             	sub    $0x18,%esp
 7bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 7be:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7c1:	83 ec 04             	sub    $0x4,%esp
 7c4:	6a 01                	push   $0x1
 7c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7c9:	50                   	push   %eax
 7ca:	ff 75 08             	pushl  0x8(%ebp)
 7cd:	e8 23 ff ff ff       	call   6f5 <write>
 7d2:	83 c4 10             	add    $0x10,%esp
}
 7d5:	90                   	nop
 7d6:	c9                   	leave  
 7d7:	c3                   	ret    

000007d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7d8:	55                   	push   %ebp
 7d9:	89 e5                	mov    %esp,%ebp
 7db:	53                   	push   %ebx
 7dc:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7ea:	74 17                	je     803 <printint+0x2b>
 7ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7f0:	79 11                	jns    803 <printint+0x2b>
    neg = 1;
 7f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7fc:	f7 d8                	neg    %eax
 7fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
 801:	eb 06                	jmp    809 <printint+0x31>
  } else {
    x = xx;
 803:	8b 45 0c             	mov    0xc(%ebp),%eax
 806:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 809:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 810:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 813:	8d 41 01             	lea    0x1(%ecx),%eax
 816:	89 45 f4             	mov    %eax,-0xc(%ebp)
 819:	8b 5d 10             	mov    0x10(%ebp),%ebx
 81c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81f:	ba 00 00 00 00       	mov    $0x0,%edx
 824:	f7 f3                	div    %ebx
 826:	89 d0                	mov    %edx,%eax
 828:	0f b6 80 90 0f 00 00 	movzbl 0xf90(%eax),%eax
 82f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 833:	8b 5d 10             	mov    0x10(%ebp),%ebx
 836:	8b 45 ec             	mov    -0x14(%ebp),%eax
 839:	ba 00 00 00 00       	mov    $0x0,%edx
 83e:	f7 f3                	div    %ebx
 840:	89 45 ec             	mov    %eax,-0x14(%ebp)
 843:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 847:	75 c7                	jne    810 <printint+0x38>
  if(neg)
 849:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 84d:	74 2d                	je     87c <printint+0xa4>
    buf[i++] = '-';
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8d 50 01             	lea    0x1(%eax),%edx
 855:	89 55 f4             	mov    %edx,-0xc(%ebp)
 858:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 85d:	eb 1d                	jmp    87c <printint+0xa4>
    putc(fd, buf[i]);
 85f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	01 d0                	add    %edx,%eax
 867:	0f b6 00             	movzbl (%eax),%eax
 86a:	0f be c0             	movsbl %al,%eax
 86d:	83 ec 08             	sub    $0x8,%esp
 870:	50                   	push   %eax
 871:	ff 75 08             	pushl  0x8(%ebp)
 874:	e8 3c ff ff ff       	call   7b5 <putc>
 879:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 87c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 884:	79 d9                	jns    85f <printint+0x87>
    putc(fd, buf[i]);
}
 886:	90                   	nop
 887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 88a:	c9                   	leave  
 88b:	c3                   	ret    

0000088c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 88c:	55                   	push   %ebp
 88d:	89 e5                	mov    %esp,%ebp
 88f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 892:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 899:	8d 45 0c             	lea    0xc(%ebp),%eax
 89c:	83 c0 04             	add    $0x4,%eax
 89f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8a9:	e9 59 01 00 00       	jmp    a07 <printf+0x17b>
    c = fmt[i] & 0xff;
 8ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	01 d0                	add    %edx,%eax
 8b6:	0f b6 00             	movzbl (%eax),%eax
 8b9:	0f be c0             	movsbl %al,%eax
 8bc:	25 ff 00 00 00       	and    $0xff,%eax
 8c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8c8:	75 2c                	jne    8f6 <printf+0x6a>
      if(c == '%'){
 8ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ce:	75 0c                	jne    8dc <printf+0x50>
        state = '%';
 8d0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8d7:	e9 27 01 00 00       	jmp    a03 <printf+0x177>
      } else {
        putc(fd, c);
 8dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8df:	0f be c0             	movsbl %al,%eax
 8e2:	83 ec 08             	sub    $0x8,%esp
 8e5:	50                   	push   %eax
 8e6:	ff 75 08             	pushl  0x8(%ebp)
 8e9:	e8 c7 fe ff ff       	call   7b5 <putc>
 8ee:	83 c4 10             	add    $0x10,%esp
 8f1:	e9 0d 01 00 00       	jmp    a03 <printf+0x177>
      }
    } else if(state == '%'){
 8f6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8fa:	0f 85 03 01 00 00    	jne    a03 <printf+0x177>
      if(c == 'd'){
 900:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 904:	75 1e                	jne    924 <printf+0x98>
        printint(fd, *ap, 10, 1);
 906:	8b 45 e8             	mov    -0x18(%ebp),%eax
 909:	8b 00                	mov    (%eax),%eax
 90b:	6a 01                	push   $0x1
 90d:	6a 0a                	push   $0xa
 90f:	50                   	push   %eax
 910:	ff 75 08             	pushl  0x8(%ebp)
 913:	e8 c0 fe ff ff       	call   7d8 <printint>
 918:	83 c4 10             	add    $0x10,%esp
        ap++;
 91b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 91f:	e9 d8 00 00 00       	jmp    9fc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 924:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 928:	74 06                	je     930 <printf+0xa4>
 92a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 92e:	75 1e                	jne    94e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 930:	8b 45 e8             	mov    -0x18(%ebp),%eax
 933:	8b 00                	mov    (%eax),%eax
 935:	6a 00                	push   $0x0
 937:	6a 10                	push   $0x10
 939:	50                   	push   %eax
 93a:	ff 75 08             	pushl  0x8(%ebp)
 93d:	e8 96 fe ff ff       	call   7d8 <printint>
 942:	83 c4 10             	add    $0x10,%esp
        ap++;
 945:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 949:	e9 ae 00 00 00       	jmp    9fc <printf+0x170>
      } else if(c == 's'){
 94e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 952:	75 43                	jne    997 <printf+0x10b>
        s = (char*)*ap;
 954:	8b 45 e8             	mov    -0x18(%ebp),%eax
 957:	8b 00                	mov    (%eax),%eax
 959:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 95c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 960:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 964:	75 25                	jne    98b <printf+0xff>
          s = "(null)";
 966:	c7 45 f4 13 0d 00 00 	movl   $0xd13,-0xc(%ebp)
        while(*s != 0){
 96d:	eb 1c                	jmp    98b <printf+0xff>
          putc(fd, *s);
 96f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 972:	0f b6 00             	movzbl (%eax),%eax
 975:	0f be c0             	movsbl %al,%eax
 978:	83 ec 08             	sub    $0x8,%esp
 97b:	50                   	push   %eax
 97c:	ff 75 08             	pushl  0x8(%ebp)
 97f:	e8 31 fe ff ff       	call   7b5 <putc>
 984:	83 c4 10             	add    $0x10,%esp
          s++;
 987:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	0f b6 00             	movzbl (%eax),%eax
 991:	84 c0                	test   %al,%al
 993:	75 da                	jne    96f <printf+0xe3>
 995:	eb 65                	jmp    9fc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 997:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 99b:	75 1d                	jne    9ba <printf+0x12e>
        putc(fd, *ap);
 99d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a0:	8b 00                	mov    (%eax),%eax
 9a2:	0f be c0             	movsbl %al,%eax
 9a5:	83 ec 08             	sub    $0x8,%esp
 9a8:	50                   	push   %eax
 9a9:	ff 75 08             	pushl  0x8(%ebp)
 9ac:	e8 04 fe ff ff       	call   7b5 <putc>
 9b1:	83 c4 10             	add    $0x10,%esp
        ap++;
 9b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9b8:	eb 42                	jmp    9fc <printf+0x170>
      } else if(c == '%'){
 9ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9be:	75 17                	jne    9d7 <printf+0x14b>
        putc(fd, c);
 9c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9c3:	0f be c0             	movsbl %al,%eax
 9c6:	83 ec 08             	sub    $0x8,%esp
 9c9:	50                   	push   %eax
 9ca:	ff 75 08             	pushl  0x8(%ebp)
 9cd:	e8 e3 fd ff ff       	call   7b5 <putc>
 9d2:	83 c4 10             	add    $0x10,%esp
 9d5:	eb 25                	jmp    9fc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9d7:	83 ec 08             	sub    $0x8,%esp
 9da:	6a 25                	push   $0x25
 9dc:	ff 75 08             	pushl  0x8(%ebp)
 9df:	e8 d1 fd ff ff       	call   7b5 <putc>
 9e4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 9e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ea:	0f be c0             	movsbl %al,%eax
 9ed:	83 ec 08             	sub    $0x8,%esp
 9f0:	50                   	push   %eax
 9f1:	ff 75 08             	pushl  0x8(%ebp)
 9f4:	e8 bc fd ff ff       	call   7b5 <putc>
 9f9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a03:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a07:	8b 55 0c             	mov    0xc(%ebp),%edx
 a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0d:	01 d0                	add    %edx,%eax
 a0f:	0f b6 00             	movzbl (%eax),%eax
 a12:	84 c0                	test   %al,%al
 a14:	0f 85 94 fe ff ff    	jne    8ae <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a1a:	90                   	nop
 a1b:	c9                   	leave  
 a1c:	c3                   	ret    

00000a1d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a1d:	55                   	push   %ebp
 a1e:	89 e5                	mov    %esp,%ebp
 a20:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a23:	8b 45 08             	mov    0x8(%ebp),%eax
 a26:	83 e8 08             	sub    $0x8,%eax
 a29:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2c:	a1 ac 0f 00 00       	mov    0xfac,%eax
 a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a34:	eb 24                	jmp    a5a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a39:	8b 00                	mov    (%eax),%eax
 a3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a3e:	77 12                	ja     a52 <free+0x35>
 a40:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a46:	77 24                	ja     a6c <free+0x4f>
 a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4b:	8b 00                	mov    (%eax),%eax
 a4d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a50:	77 1a                	ja     a6c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a55:	8b 00                	mov    (%eax),%eax
 a57:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a60:	76 d4                	jbe    a36 <free+0x19>
 a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a65:	8b 00                	mov    (%eax),%eax
 a67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a6a:	76 ca                	jbe    a36 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6f:	8b 40 04             	mov    0x4(%eax),%eax
 a72:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a7c:	01 c2                	add    %eax,%edx
 a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a81:	8b 00                	mov    (%eax),%eax
 a83:	39 c2                	cmp    %eax,%edx
 a85:	75 24                	jne    aab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a87:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a8a:	8b 50 04             	mov    0x4(%eax),%edx
 a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a90:	8b 00                	mov    (%eax),%eax
 a92:	8b 40 04             	mov    0x4(%eax),%eax
 a95:	01 c2                	add    %eax,%edx
 a97:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a9a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa0:	8b 00                	mov    (%eax),%eax
 aa2:	8b 10                	mov    (%eax),%edx
 aa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa7:	89 10                	mov    %edx,(%eax)
 aa9:	eb 0a                	jmp    ab5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 aab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aae:	8b 10                	mov    (%eax),%edx
 ab0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ac2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac5:	01 d0                	add    %edx,%eax
 ac7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 aca:	75 20                	jne    aec <free+0xcf>
    p->s.size += bp->s.size;
 acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acf:	8b 50 04             	mov    0x4(%eax),%edx
 ad2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad5:	8b 40 04             	mov    0x4(%eax),%eax
 ad8:	01 c2                	add    %eax,%edx
 ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
 add:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ae0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae3:	8b 10                	mov    (%eax),%edx
 ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae8:	89 10                	mov    %edx,(%eax)
 aea:	eb 08                	jmp    af4 <free+0xd7>
  } else
    p->s.ptr = bp;
 aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 af2:	89 10                	mov    %edx,(%eax)
  freep = p;
 af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af7:	a3 ac 0f 00 00       	mov    %eax,0xfac
}
 afc:	90                   	nop
 afd:	c9                   	leave  
 afe:	c3                   	ret    

00000aff <morecore>:

static Header*
morecore(uint nu)
{
 aff:	55                   	push   %ebp
 b00:	89 e5                	mov    %esp,%ebp
 b02:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b05:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b0c:	77 07                	ja     b15 <morecore+0x16>
    nu = 4096;
 b0e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b15:	8b 45 08             	mov    0x8(%ebp),%eax
 b18:	c1 e0 03             	shl    $0x3,%eax
 b1b:	83 ec 0c             	sub    $0xc,%esp
 b1e:	50                   	push   %eax
 b1f:	e8 39 fc ff ff       	call   75d <sbrk>
 b24:	83 c4 10             	add    $0x10,%esp
 b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b2a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b2e:	75 07                	jne    b37 <morecore+0x38>
    return 0;
 b30:	b8 00 00 00 00       	mov    $0x0,%eax
 b35:	eb 26                	jmp    b5d <morecore+0x5e>
  hp = (Header*)p;
 b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b40:	8b 55 08             	mov    0x8(%ebp),%edx
 b43:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b49:	83 c0 08             	add    $0x8,%eax
 b4c:	83 ec 0c             	sub    $0xc,%esp
 b4f:	50                   	push   %eax
 b50:	e8 c8 fe ff ff       	call   a1d <free>
 b55:	83 c4 10             	add    $0x10,%esp
  return freep;
 b58:	a1 ac 0f 00 00       	mov    0xfac,%eax
}
 b5d:	c9                   	leave  
 b5e:	c3                   	ret    

00000b5f <malloc>:

void*
malloc(uint nbytes)
{
 b5f:	55                   	push   %ebp
 b60:	89 e5                	mov    %esp,%ebp
 b62:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b65:	8b 45 08             	mov    0x8(%ebp),%eax
 b68:	83 c0 07             	add    $0x7,%eax
 b6b:	c1 e8 03             	shr    $0x3,%eax
 b6e:	83 c0 01             	add    $0x1,%eax
 b71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b74:	a1 ac 0f 00 00       	mov    0xfac,%eax
 b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b80:	75 23                	jne    ba5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b82:	c7 45 f0 a4 0f 00 00 	movl   $0xfa4,-0x10(%ebp)
 b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b8c:	a3 ac 0f 00 00       	mov    %eax,0xfac
 b91:	a1 ac 0f 00 00       	mov    0xfac,%eax
 b96:	a3 a4 0f 00 00       	mov    %eax,0xfa4
    base.s.size = 0;
 b9b:	c7 05 a8 0f 00 00 00 	movl   $0x0,0xfa8
 ba2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba8:	8b 00                	mov    (%eax),%eax
 baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb0:	8b 40 04             	mov    0x4(%eax),%eax
 bb3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bb6:	72 4d                	jb     c05 <malloc+0xa6>
      if(p->s.size == nunits)
 bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbb:	8b 40 04             	mov    0x4(%eax),%eax
 bbe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bc1:	75 0c                	jne    bcf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc6:	8b 10                	mov    (%eax),%edx
 bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bcb:	89 10                	mov    %edx,(%eax)
 bcd:	eb 26                	jmp    bf5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd2:	8b 40 04             	mov    0x4(%eax),%eax
 bd5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bd8:	89 c2                	mov    %eax,%edx
 bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bdd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be3:	8b 40 04             	mov    0x4(%eax),%eax
 be6:	c1 e0 03             	shl    $0x3,%eax
 be9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bef:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bf2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf8:	a3 ac 0f 00 00       	mov    %eax,0xfac
      return (void*)(p + 1);
 bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c00:	83 c0 08             	add    $0x8,%eax
 c03:	eb 3b                	jmp    c40 <malloc+0xe1>
    }
    if(p == freep)
 c05:	a1 ac 0f 00 00       	mov    0xfac,%eax
 c0a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c0d:	75 1e                	jne    c2d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 c0f:	83 ec 0c             	sub    $0xc,%esp
 c12:	ff 75 ec             	pushl  -0x14(%ebp)
 c15:	e8 e5 fe ff ff       	call   aff <morecore>
 c1a:	83 c4 10             	add    $0x10,%esp
 c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c24:	75 07                	jne    c2d <malloc+0xce>
        return 0;
 c26:	b8 00 00 00 00       	mov    $0x0,%eax
 c2b:	eb 13                	jmp    c40 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c36:	8b 00                	mov    (%eax),%eax
 c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c3b:	e9 6d ff ff ff       	jmp    bad <malloc+0x4e>
}
 c40:	c9                   	leave  
 c41:	c3                   	ret    
