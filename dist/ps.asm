
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
  1b:	c7 45 dc 5c 0c 00 00 	movl   $0xc5c,-0x24(%ebp)
          *p = "PID",
  22:	c7 45 d8 61 0c 00 00 	movl   $0xc61,-0x28(%ebp)
          *u = "UID",
  29:	c7 45 d4 65 0c 00 00 	movl   $0xc65,-0x2c(%ebp)
          *g = "GID",
  30:	c7 45 d0 69 0c 00 00 	movl   $0xc69,-0x30(%ebp)
          *pp = "PPID",
  37:	c7 45 cc 6d 0c 00 00 	movl   $0xc6d,-0x34(%ebp)
          *tot = "CPU (s)",
  3e:	c7 45 c8 72 0c 00 00 	movl   $0xc72,-0x38(%ebp)
          *e = "Elapsed (s)",
  45:	c7 45 c4 7a 0c 00 00 	movl   $0xc7a,-0x3c(%ebp)
          *st = "State",
  4c:	c7 45 c0 86 0c 00 00 	movl   $0xc86,-0x40(%ebp)
          *si = "Size";
  53:	c7 45 bc 8c 0c 00 00 	movl   $0xc8c,-0x44(%ebp)
 
    up =  malloc( sizeof(&up) * MAX);
  5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  5d:	c1 e0 02             	shl    $0x2,%eax
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	50                   	push   %eax
  64:	e8 0e 0b 00 00       	call   b77 <malloc>
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
  8e:	68 91 0c 00 00       	push   $0xc91
  93:	6a 01                	push   $0x1
  95:	e8 0a 08 00 00       	call   8a4 <printf>
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
  c0:	68 a4 0c 00 00       	push   $0xca4
  c5:	6a 01                	push   $0x1
  c7:	e8 d8 07 00 00       	call   8a4 <printf>
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
 1e0:	68 dc 0c 00 00       	push   $0xcdc
 1e5:	6a 01                	push   $0x1
 1e7:	e8 b8 06 00 00       	call   8a4 <printf>
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
 223:	68 1b 0d 00 00       	push   $0xd1b
 228:	6a 01                	push   $0x1
 22a:	e8 75 06 00 00       	call   8a4 <printf>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	eb 3a                	jmp    26e <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 234:	83 ec 08             	sub    $0x8,%esp
 237:	68 1d 0d 00 00       	push   $0xd1d
 23c:	6a 01                	push   $0x1
 23e:	e8 61 06 00 00       	call   8a4 <printf>
 243:	83 c4 10             	add    $0x10,%esp
 246:	eb 26                	jmp    26e <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 248:	83 ec 08             	sub    $0x8,%esp
 24b:	68 1f 0d 00 00       	push   $0xd1f
 250:	6a 01                	push   $0x1
 252:	e8 4d 06 00 00       	call   8a4 <printf>
 257:	83 c4 10             	add    $0x10,%esp
 25a:	eb 12                	jmp    26e <print_mode+0x6a>
    default: printf(1, "?");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 21 0d 00 00       	push   $0xd21
 264:	6a 01                	push   $0x1
 266:	e8 39 06 00 00       	call   8a4 <printf>
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
 27f:	68 23 0d 00 00       	push   $0xd23
 284:	6a 01                	push   $0x1
 286:	e8 19 06 00 00       	call   8a4 <printf>
 28b:	83 c4 10             	add    $0x10,%esp
 28e:	eb 12                	jmp    2a2 <print_mode+0x9e>
  else
    printf(1, "-");
 290:	83 ec 08             	sub    $0x8,%esp
 293:	68 1d 0d 00 00       	push   $0xd1d
 298:	6a 01                	push   $0x1
 29a:	e8 05 06 00 00       	call   8a4 <printf>
 29f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2a9:	83 e0 80             	and    $0xffffff80,%eax
 2ac:	84 c0                	test   %al,%al
 2ae:	74 14                	je     2c4 <print_mode+0xc0>
    printf(1, "w");
 2b0:	83 ec 08             	sub    $0x8,%esp
 2b3:	68 25 0d 00 00       	push   $0xd25
 2b8:	6a 01                	push   $0x1
 2ba:	e8 e5 05 00 00       	call   8a4 <printf>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	eb 12                	jmp    2d6 <print_mode+0xd2>
  else
    printf(1, "-");
 2c4:	83 ec 08             	sub    $0x8,%esp
 2c7:	68 1d 0d 00 00       	push   $0xd1d
 2cc:	6a 01                	push   $0x1
 2ce:	e8 d1 05 00 00       	call   8a4 <printf>
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
 2fe:	68 27 0d 00 00       	push   $0xd27
 303:	6a 01                	push   $0x1
 305:	e8 9a 05 00 00       	call   8a4 <printf>
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
 320:	68 29 0d 00 00       	push   $0xd29
 325:	6a 01                	push   $0x1
 327:	e8 78 05 00 00       	call   8a4 <printf>
 32c:	83 c4 10             	add    $0x10,%esp
 32f:	eb 12                	jmp    343 <print_mode+0x13f>
  else
    printf(1, "-");
 331:	83 ec 08             	sub    $0x8,%esp
 334:	68 1d 0d 00 00       	push   $0xd1d
 339:	6a 01                	push   $0x1
 33b:	e8 64 05 00 00       	call   8a4 <printf>
 340:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 34a:	83 e0 20             	and    $0x20,%eax
 34d:	84 c0                	test   %al,%al
 34f:	74 14                	je     365 <print_mode+0x161>
    printf(1, "r");
 351:	83 ec 08             	sub    $0x8,%esp
 354:	68 23 0d 00 00       	push   $0xd23
 359:	6a 01                	push   $0x1
 35b:	e8 44 05 00 00       	call   8a4 <printf>
 360:	83 c4 10             	add    $0x10,%esp
 363:	eb 12                	jmp    377 <print_mode+0x173>
  else
    printf(1, "-");
 365:	83 ec 08             	sub    $0x8,%esp
 368:	68 1d 0d 00 00       	push   $0xd1d
 36d:	6a 01                	push   $0x1
 36f:	e8 30 05 00 00       	call   8a4 <printf>
 374:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 37e:	83 e0 10             	and    $0x10,%eax
 381:	84 c0                	test   %al,%al
 383:	74 14                	je     399 <print_mode+0x195>
    printf(1, "w");
 385:	83 ec 08             	sub    $0x8,%esp
 388:	68 25 0d 00 00       	push   $0xd25
 38d:	6a 01                	push   $0x1
 38f:	e8 10 05 00 00       	call   8a4 <printf>
 394:	83 c4 10             	add    $0x10,%esp
 397:	eb 12                	jmp    3ab <print_mode+0x1a7>
  else
    printf(1, "-");
 399:	83 ec 08             	sub    $0x8,%esp
 39c:	68 1d 0d 00 00       	push   $0xd1d
 3a1:	6a 01                	push   $0x1
 3a3:	e8 fc 04 00 00       	call   8a4 <printf>
 3a8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3b2:	83 e0 08             	and    $0x8,%eax
 3b5:	84 c0                	test   %al,%al
 3b7:	74 14                	je     3cd <print_mode+0x1c9>
    printf(1, "x");
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	68 29 0d 00 00       	push   $0xd29
 3c1:	6a 01                	push   $0x1
 3c3:	e8 dc 04 00 00       	call   8a4 <printf>
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	eb 12                	jmp    3df <print_mode+0x1db>
  else
    printf(1, "-");
 3cd:	83 ec 08             	sub    $0x8,%esp
 3d0:	68 1d 0d 00 00       	push   $0xd1d
 3d5:	6a 01                	push   $0x1
 3d7:	e8 c8 04 00 00       	call   8a4 <printf>
 3dc:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3e6:	83 e0 04             	and    $0x4,%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	74 14                	je     401 <print_mode+0x1fd>
    printf(1, "r");
 3ed:	83 ec 08             	sub    $0x8,%esp
 3f0:	68 23 0d 00 00       	push   $0xd23
 3f5:	6a 01                	push   $0x1
 3f7:	e8 a8 04 00 00       	call   8a4 <printf>
 3fc:	83 c4 10             	add    $0x10,%esp
 3ff:	eb 12                	jmp    413 <print_mode+0x20f>
  else
    printf(1, "-");
 401:	83 ec 08             	sub    $0x8,%esp
 404:	68 1d 0d 00 00       	push   $0xd1d
 409:	6a 01                	push   $0x1
 40b:	e8 94 04 00 00       	call   8a4 <printf>
 410:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 41a:	83 e0 02             	and    $0x2,%eax
 41d:	84 c0                	test   %al,%al
 41f:	74 14                	je     435 <print_mode+0x231>
    printf(1, "w");
 421:	83 ec 08             	sub    $0x8,%esp
 424:	68 25 0d 00 00       	push   $0xd25
 429:	6a 01                	push   $0x1
 42b:	e8 74 04 00 00       	call   8a4 <printf>
 430:	83 c4 10             	add    $0x10,%esp
 433:	eb 12                	jmp    447 <print_mode+0x243>
  else
    printf(1, "-");
 435:	83 ec 08             	sub    $0x8,%esp
 438:	68 1d 0d 00 00       	push   $0xd1d
 43d:	6a 01                	push   $0x1
 43f:	e8 60 04 00 00       	call   8a4 <printf>
 444:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 44e:	83 e0 01             	and    $0x1,%eax
 451:	84 c0                	test   %al,%al
 453:	74 14                	je     469 <print_mode+0x265>
    printf(1, "x");
 455:	83 ec 08             	sub    $0x8,%esp
 458:	68 29 0d 00 00       	push   $0xd29
 45d:	6a 01                	push   $0x1
 45f:	e8 40 04 00 00       	call   8a4 <printf>
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
 46c:	68 1d 0d 00 00       	push   $0xd1d
 471:	6a 01                	push   $0x1
 473:	e8 2c 04 00 00       	call   8a4 <printf>
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

000007b5 <chown>:

SYSCALL(chown)
 7b5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 7ba:	cd 40                	int    $0x40
 7bc:	c3                   	ret    

000007bd <chgrp>:
SYSCALL(chgrp)
 7bd:	b8 1f 00 00 00       	mov    $0x1f,%eax
 7c2:	cd 40                	int    $0x40
 7c4:	c3                   	ret    

000007c5 <chmod>:
SYSCALL(chmod)
 7c5:	b8 20 00 00 00       	mov    $0x20,%eax
 7ca:	cd 40                	int    $0x40
 7cc:	c3                   	ret    

000007cd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7cd:	55                   	push   %ebp
 7ce:	89 e5                	mov    %esp,%ebp
 7d0:	83 ec 18             	sub    $0x18,%esp
 7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7d9:	83 ec 04             	sub    $0x4,%esp
 7dc:	6a 01                	push   $0x1
 7de:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7e1:	50                   	push   %eax
 7e2:	ff 75 08             	pushl  0x8(%ebp)
 7e5:	e8 0b ff ff ff       	call   6f5 <write>
 7ea:	83 c4 10             	add    $0x10,%esp
}
 7ed:	90                   	nop
 7ee:	c9                   	leave  
 7ef:	c3                   	ret    

000007f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	53                   	push   %ebx
 7f4:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7fe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 802:	74 17                	je     81b <printint+0x2b>
 804:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 808:	79 11                	jns    81b <printint+0x2b>
    neg = 1;
 80a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 811:	8b 45 0c             	mov    0xc(%ebp),%eax
 814:	f7 d8                	neg    %eax
 816:	89 45 ec             	mov    %eax,-0x14(%ebp)
 819:	eb 06                	jmp    821 <printint+0x31>
  } else {
    x = xx;
 81b:	8b 45 0c             	mov    0xc(%ebp),%eax
 81e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 828:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 82b:	8d 41 01             	lea    0x1(%ecx),%eax
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 831:	8b 5d 10             	mov    0x10(%ebp),%ebx
 834:	8b 45 ec             	mov    -0x14(%ebp),%eax
 837:	ba 00 00 00 00       	mov    $0x0,%edx
 83c:	f7 f3                	div    %ebx
 83e:	89 d0                	mov    %edx,%eax
 840:	0f b6 80 a8 0f 00 00 	movzbl 0xfa8(%eax),%eax
 847:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 84b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 84e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 851:	ba 00 00 00 00       	mov    $0x0,%edx
 856:	f7 f3                	div    %ebx
 858:	89 45 ec             	mov    %eax,-0x14(%ebp)
 85b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 85f:	75 c7                	jne    828 <printint+0x38>
  if(neg)
 861:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 865:	74 2d                	je     894 <printint+0xa4>
    buf[i++] = '-';
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8d 50 01             	lea    0x1(%eax),%edx
 86d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 870:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 875:	eb 1d                	jmp    894 <printint+0xa4>
    putc(fd, buf[i]);
 877:	8d 55 dc             	lea    -0x24(%ebp),%edx
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	01 d0                	add    %edx,%eax
 87f:	0f b6 00             	movzbl (%eax),%eax
 882:	0f be c0             	movsbl %al,%eax
 885:	83 ec 08             	sub    $0x8,%esp
 888:	50                   	push   %eax
 889:	ff 75 08             	pushl  0x8(%ebp)
 88c:	e8 3c ff ff ff       	call   7cd <putc>
 891:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 894:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89c:	79 d9                	jns    877 <printint+0x87>
    putc(fd, buf[i]);
}
 89e:	90                   	nop
 89f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8a2:	c9                   	leave  
 8a3:	c3                   	ret    

000008a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8a4:	55                   	push   %ebp
 8a5:	89 e5                	mov    %esp,%ebp
 8a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8b1:	8d 45 0c             	lea    0xc(%ebp),%eax
 8b4:	83 c0 04             	add    $0x4,%eax
 8b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8c1:	e9 59 01 00 00       	jmp    a1f <printf+0x17b>
    c = fmt[i] & 0xff;
 8c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cc:	01 d0                	add    %edx,%eax
 8ce:	0f b6 00             	movzbl (%eax),%eax
 8d1:	0f be c0             	movsbl %al,%eax
 8d4:	25 ff 00 00 00       	and    $0xff,%eax
 8d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e0:	75 2c                	jne    90e <printf+0x6a>
      if(c == '%'){
 8e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8e6:	75 0c                	jne    8f4 <printf+0x50>
        state = '%';
 8e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8ef:	e9 27 01 00 00       	jmp    a1b <printf+0x177>
      } else {
        putc(fd, c);
 8f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f7:	0f be c0             	movsbl %al,%eax
 8fa:	83 ec 08             	sub    $0x8,%esp
 8fd:	50                   	push   %eax
 8fe:	ff 75 08             	pushl  0x8(%ebp)
 901:	e8 c7 fe ff ff       	call   7cd <putc>
 906:	83 c4 10             	add    $0x10,%esp
 909:	e9 0d 01 00 00       	jmp    a1b <printf+0x177>
      }
    } else if(state == '%'){
 90e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 912:	0f 85 03 01 00 00    	jne    a1b <printf+0x177>
      if(c == 'd'){
 918:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 91c:	75 1e                	jne    93c <printf+0x98>
        printint(fd, *ap, 10, 1);
 91e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 921:	8b 00                	mov    (%eax),%eax
 923:	6a 01                	push   $0x1
 925:	6a 0a                	push   $0xa
 927:	50                   	push   %eax
 928:	ff 75 08             	pushl  0x8(%ebp)
 92b:	e8 c0 fe ff ff       	call   7f0 <printint>
 930:	83 c4 10             	add    $0x10,%esp
        ap++;
 933:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 937:	e9 d8 00 00 00       	jmp    a14 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 93c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 940:	74 06                	je     948 <printf+0xa4>
 942:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 946:	75 1e                	jne    966 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 948:	8b 45 e8             	mov    -0x18(%ebp),%eax
 94b:	8b 00                	mov    (%eax),%eax
 94d:	6a 00                	push   $0x0
 94f:	6a 10                	push   $0x10
 951:	50                   	push   %eax
 952:	ff 75 08             	pushl  0x8(%ebp)
 955:	e8 96 fe ff ff       	call   7f0 <printint>
 95a:	83 c4 10             	add    $0x10,%esp
        ap++;
 95d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 961:	e9 ae 00 00 00       	jmp    a14 <printf+0x170>
      } else if(c == 's'){
 966:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 96a:	75 43                	jne    9af <printf+0x10b>
        s = (char*)*ap;
 96c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 96f:	8b 00                	mov    (%eax),%eax
 971:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 974:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 97c:	75 25                	jne    9a3 <printf+0xff>
          s = "(null)";
 97e:	c7 45 f4 2b 0d 00 00 	movl   $0xd2b,-0xc(%ebp)
        while(*s != 0){
 985:	eb 1c                	jmp    9a3 <printf+0xff>
          putc(fd, *s);
 987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98a:	0f b6 00             	movzbl (%eax),%eax
 98d:	0f be c0             	movsbl %al,%eax
 990:	83 ec 08             	sub    $0x8,%esp
 993:	50                   	push   %eax
 994:	ff 75 08             	pushl  0x8(%ebp)
 997:	e8 31 fe ff ff       	call   7cd <putc>
 99c:	83 c4 10             	add    $0x10,%esp
          s++;
 99f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a6:	0f b6 00             	movzbl (%eax),%eax
 9a9:	84 c0                	test   %al,%al
 9ab:	75 da                	jne    987 <printf+0xe3>
 9ad:	eb 65                	jmp    a14 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9b3:	75 1d                	jne    9d2 <printf+0x12e>
        putc(fd, *ap);
 9b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9b8:	8b 00                	mov    (%eax),%eax
 9ba:	0f be c0             	movsbl %al,%eax
 9bd:	83 ec 08             	sub    $0x8,%esp
 9c0:	50                   	push   %eax
 9c1:	ff 75 08             	pushl  0x8(%ebp)
 9c4:	e8 04 fe ff ff       	call   7cd <putc>
 9c9:	83 c4 10             	add    $0x10,%esp
        ap++;
 9cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9d0:	eb 42                	jmp    a14 <printf+0x170>
      } else if(c == '%'){
 9d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9d6:	75 17                	jne    9ef <printf+0x14b>
        putc(fd, c);
 9d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9db:	0f be c0             	movsbl %al,%eax
 9de:	83 ec 08             	sub    $0x8,%esp
 9e1:	50                   	push   %eax
 9e2:	ff 75 08             	pushl  0x8(%ebp)
 9e5:	e8 e3 fd ff ff       	call   7cd <putc>
 9ea:	83 c4 10             	add    $0x10,%esp
 9ed:	eb 25                	jmp    a14 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9ef:	83 ec 08             	sub    $0x8,%esp
 9f2:	6a 25                	push   $0x25
 9f4:	ff 75 08             	pushl  0x8(%ebp)
 9f7:	e8 d1 fd ff ff       	call   7cd <putc>
 9fc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 9ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a02:	0f be c0             	movsbl %al,%eax
 a05:	83 ec 08             	sub    $0x8,%esp
 a08:	50                   	push   %eax
 a09:	ff 75 08             	pushl  0x8(%ebp)
 a0c:	e8 bc fd ff ff       	call   7cd <putc>
 a11:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a1b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
 a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a25:	01 d0                	add    %edx,%eax
 a27:	0f b6 00             	movzbl (%eax),%eax
 a2a:	84 c0                	test   %al,%al
 a2c:	0f 85 94 fe ff ff    	jne    8c6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a32:	90                   	nop
 a33:	c9                   	leave  
 a34:	c3                   	ret    

00000a35 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a35:	55                   	push   %ebp
 a36:	89 e5                	mov    %esp,%ebp
 a38:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a3b:	8b 45 08             	mov    0x8(%ebp),%eax
 a3e:	83 e8 08             	sub    $0x8,%eax
 a41:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a44:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a4c:	eb 24                	jmp    a72 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a51:	8b 00                	mov    (%eax),%eax
 a53:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a56:	77 12                	ja     a6a <free+0x35>
 a58:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a5e:	77 24                	ja     a84 <free+0x4f>
 a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a63:	8b 00                	mov    (%eax),%eax
 a65:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a68:	77 1a                	ja     a84 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6d:	8b 00                	mov    (%eax),%eax
 a6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a72:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a75:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a78:	76 d4                	jbe    a4e <free+0x19>
 a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7d:	8b 00                	mov    (%eax),%eax
 a7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a82:	76 ca                	jbe    a4e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a87:	8b 40 04             	mov    0x4(%eax),%eax
 a8a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a94:	01 c2                	add    %eax,%edx
 a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a99:	8b 00                	mov    (%eax),%eax
 a9b:	39 c2                	cmp    %eax,%edx
 a9d:	75 24                	jne    ac3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa2:	8b 50 04             	mov    0x4(%eax),%edx
 aa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa8:	8b 00                	mov    (%eax),%eax
 aaa:	8b 40 04             	mov    0x4(%eax),%eax
 aad:	01 c2                	add    %eax,%edx
 aaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab8:	8b 00                	mov    (%eax),%eax
 aba:	8b 10                	mov    (%eax),%edx
 abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abf:	89 10                	mov    %edx,(%eax)
 ac1:	eb 0a                	jmp    acd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac6:	8b 10                	mov    (%eax),%edx
 ac8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 acb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad0:	8b 40 04             	mov    0x4(%eax),%eax
 ad3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
 add:	01 d0                	add    %edx,%eax
 adf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ae2:	75 20                	jne    b04 <free+0xcf>
    p->s.size += bp->s.size;
 ae4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae7:	8b 50 04             	mov    0x4(%eax),%edx
 aea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aed:	8b 40 04             	mov    0x4(%eax),%eax
 af0:	01 c2                	add    %eax,%edx
 af2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 afb:	8b 10                	mov    (%eax),%edx
 afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b00:	89 10                	mov    %edx,(%eax)
 b02:	eb 08                	jmp    b0c <free+0xd7>
  } else
    p->s.ptr = bp;
 b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b07:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b0a:	89 10                	mov    %edx,(%eax)
  freep = p;
 b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b0f:	a3 c4 0f 00 00       	mov    %eax,0xfc4
}
 b14:	90                   	nop
 b15:	c9                   	leave  
 b16:	c3                   	ret    

00000b17 <morecore>:

static Header*
morecore(uint nu)
{
 b17:	55                   	push   %ebp
 b18:	89 e5                	mov    %esp,%ebp
 b1a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b1d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b24:	77 07                	ja     b2d <morecore+0x16>
    nu = 4096;
 b26:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b2d:	8b 45 08             	mov    0x8(%ebp),%eax
 b30:	c1 e0 03             	shl    $0x3,%eax
 b33:	83 ec 0c             	sub    $0xc,%esp
 b36:	50                   	push   %eax
 b37:	e8 21 fc ff ff       	call   75d <sbrk>
 b3c:	83 c4 10             	add    $0x10,%esp
 b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b42:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b46:	75 07                	jne    b4f <morecore+0x38>
    return 0;
 b48:	b8 00 00 00 00       	mov    $0x0,%eax
 b4d:	eb 26                	jmp    b75 <morecore+0x5e>
  hp = (Header*)p;
 b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b58:	8b 55 08             	mov    0x8(%ebp),%edx
 b5b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b61:	83 c0 08             	add    $0x8,%eax
 b64:	83 ec 0c             	sub    $0xc,%esp
 b67:	50                   	push   %eax
 b68:	e8 c8 fe ff ff       	call   a35 <free>
 b6d:	83 c4 10             	add    $0x10,%esp
  return freep;
 b70:	a1 c4 0f 00 00       	mov    0xfc4,%eax
}
 b75:	c9                   	leave  
 b76:	c3                   	ret    

00000b77 <malloc>:

void*
malloc(uint nbytes)
{
 b77:	55                   	push   %ebp
 b78:	89 e5                	mov    %esp,%ebp
 b7a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b7d:	8b 45 08             	mov    0x8(%ebp),%eax
 b80:	83 c0 07             	add    $0x7,%eax
 b83:	c1 e8 03             	shr    $0x3,%eax
 b86:	83 c0 01             	add    $0x1,%eax
 b89:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b8c:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b98:	75 23                	jne    bbd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b9a:	c7 45 f0 bc 0f 00 00 	movl   $0xfbc,-0x10(%ebp)
 ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba4:	a3 c4 0f 00 00       	mov    %eax,0xfc4
 ba9:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 bae:	a3 bc 0f 00 00       	mov    %eax,0xfbc
    base.s.size = 0;
 bb3:	c7 05 c0 0f 00 00 00 	movl   $0x0,0xfc0
 bba:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc0:	8b 00                	mov    (%eax),%eax
 bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc8:	8b 40 04             	mov    0x4(%eax),%eax
 bcb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bce:	72 4d                	jb     c1d <malloc+0xa6>
      if(p->s.size == nunits)
 bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd3:	8b 40 04             	mov    0x4(%eax),%eax
 bd6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bd9:	75 0c                	jne    be7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bde:	8b 10                	mov    (%eax),%edx
 be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be3:	89 10                	mov    %edx,(%eax)
 be5:	eb 26                	jmp    c0d <malloc+0x96>
      else {
        p->s.size -= nunits;
 be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bea:	8b 40 04             	mov    0x4(%eax),%eax
 bed:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bf0:	89 c2                	mov    %eax,%edx
 bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfb:	8b 40 04             	mov    0x4(%eax),%eax
 bfe:	c1 e0 03             	shl    $0x3,%eax
 c01:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c07:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c0a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c10:	a3 c4 0f 00 00       	mov    %eax,0xfc4
      return (void*)(p + 1);
 c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c18:	83 c0 08             	add    $0x8,%eax
 c1b:	eb 3b                	jmp    c58 <malloc+0xe1>
    }
    if(p == freep)
 c1d:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 c22:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c25:	75 1e                	jne    c45 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 c27:	83 ec 0c             	sub    $0xc,%esp
 c2a:	ff 75 ec             	pushl  -0x14(%ebp)
 c2d:	e8 e5 fe ff ff       	call   b17 <morecore>
 c32:	83 c4 10             	add    $0x10,%esp
 c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c3c:	75 07                	jne    c45 <malloc+0xce>
        return 0;
 c3e:	b8 00 00 00 00       	mov    $0x0,%eax
 c43:	eb 13                	jmp    c58 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4e:	8b 00                	mov    (%eax),%eax
 c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c53:	e9 6d ff ff ff       	jmp    bc5 <malloc+0x4e>
}
 c58:	c9                   	leave  
 c59:	c3                   	ret    
