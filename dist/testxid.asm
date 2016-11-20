
_testxid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"


//tests the functionality of system calls for Project 2 
int main(int argc, char* argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp

    
    uint uid, gid, ppid;

    uid = getuid();
  11:	e8 6a 06 00 00       	call   680 <getuid>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "current uid is: %d\n", uid);
  19:	83 ec 04             	sub    $0x4,%esp
  1c:	ff 75 f4             	pushl  -0xc(%ebp)
  1f:	68 3d 0b 00 00       	push   $0xb3d
  24:	6a 02                	push   $0x2
  26:	e8 5c 07 00 00       	call   787 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
    printf(2, "setting uid to 100\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 51 0b 00 00       	push   $0xb51
  36:	6a 02                	push   $0x2
  38:	e8 4a 07 00 00       	call   787 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
    setuid(100);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	6a 64                	push   $0x64
  45:	e8 4e 06 00 00       	call   698 <setuid>
  4a:	83 c4 10             	add    $0x10,%esp
    uid = getuid();
  4d:	e8 2e 06 00 00       	call   680 <getuid>
  52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "current uid is: %d\n", uid);
  55:	83 ec 04             	sub    $0x4,%esp
  58:	ff 75 f4             	pushl  -0xc(%ebp)
  5b:	68 3d 0b 00 00       	push   $0xb3d
  60:	6a 02                	push   $0x2
  62:	e8 20 07 00 00       	call   787 <printf>
  67:	83 c4 10             	add    $0x10,%esp

    gid = getgid();
  6a:	e8 19 06 00 00       	call   688 <getgid>
  6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "current gid is: %d\n", gid);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f0             	pushl  -0x10(%ebp)
  78:	68 65 0b 00 00       	push   $0xb65
  7d:	6a 02                	push   $0x2
  7f:	e8 03 07 00 00       	call   787 <printf>
  84:	83 c4 10             	add    $0x10,%esp
    printf(2, "setting gid to 100\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 79 0b 00 00       	push   $0xb79
  8f:	6a 02                	push   $0x2
  91:	e8 f1 06 00 00       	call   787 <printf>
  96:	83 c4 10             	add    $0x10,%esp
    setuid(100);
  99:	83 ec 0c             	sub    $0xc,%esp
  9c:	6a 64                	push   $0x64
  9e:	e8 f5 05 00 00       	call   698 <setuid>
  a3:	83 c4 10             	add    $0x10,%esp
    gid = getuid();
  a6:	e8 d5 05 00 00       	call   680 <getuid>
  ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "current gid is: %d\n", gid);
  ae:	83 ec 04             	sub    $0x4,%esp
  b1:	ff 75 f0             	pushl  -0x10(%ebp)
  b4:	68 65 0b 00 00       	push   $0xb65
  b9:	6a 02                	push   $0x2
  bb:	e8 c7 06 00 00       	call   787 <printf>
  c0:	83 c4 10             	add    $0x10,%esp

    ppid = getppid();
  c3:	e8 c8 05 00 00       	call   690 <getppid>
  c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(2, "My parent process is: %d\n", ppid);
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	ff 75 ec             	pushl  -0x14(%ebp)
  d1:	68 8d 0b 00 00       	push   $0xb8d
  d6:	6a 02                	push   $0x2
  d8:	e8 aa 06 00 00       	call   787 <printf>
  dd:	83 c4 10             	add    $0x10,%esp
    printf(2, "Test Over\n");
  e0:	83 ec 08             	sub    $0x8,%esp
  e3:	68 a7 0b 00 00       	push   $0xba7
  e8:	6a 02                	push   $0x2
  ea:	e8 98 06 00 00       	call   787 <printf>
  ef:	83 c4 10             	add    $0x10,%esp

    return 0;
  f2:	b8 00 00 00 00       	mov    $0x0,%eax

    
}
  f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  fa:	c9                   	leave  
  fb:	8d 61 fc             	lea    -0x4(%ecx),%esp
  fe:	c3                   	ret    

000000ff <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	0f b7 00             	movzwl (%eax),%eax
 10b:	98                   	cwtl   
 10c:	83 f8 02             	cmp    $0x2,%eax
 10f:	74 1e                	je     12f <print_mode+0x30>
 111:	83 f8 03             	cmp    $0x3,%eax
 114:	74 2d                	je     143 <print_mode+0x44>
 116:	83 f8 01             	cmp    $0x1,%eax
 119:	75 3c                	jne    157 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 11b:	83 ec 08             	sub    $0x8,%esp
 11e:	68 b2 0b 00 00       	push   $0xbb2
 123:	6a 01                	push   $0x1
 125:	e8 5d 06 00 00       	call   787 <printf>
 12a:	83 c4 10             	add    $0x10,%esp
 12d:	eb 3a                	jmp    169 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 12f:	83 ec 08             	sub    $0x8,%esp
 132:	68 b4 0b 00 00       	push   $0xbb4
 137:	6a 01                	push   $0x1
 139:	e8 49 06 00 00       	call   787 <printf>
 13e:	83 c4 10             	add    $0x10,%esp
 141:	eb 26                	jmp    169 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 143:	83 ec 08             	sub    $0x8,%esp
 146:	68 b6 0b 00 00       	push   $0xbb6
 14b:	6a 01                	push   $0x1
 14d:	e8 35 06 00 00       	call   787 <printf>
 152:	83 c4 10             	add    $0x10,%esp
 155:	eb 12                	jmp    169 <print_mode+0x6a>
    default: printf(1, "?");
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	68 b8 0b 00 00       	push   $0xbb8
 15f:	6a 01                	push   $0x1
 161:	e8 21 06 00 00       	call   787 <printf>
 166:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 170:	83 e0 01             	and    $0x1,%eax
 173:	84 c0                	test   %al,%al
 175:	74 14                	je     18b <print_mode+0x8c>
    printf(1, "r");
 177:	83 ec 08             	sub    $0x8,%esp
 17a:	68 ba 0b 00 00       	push   $0xbba
 17f:	6a 01                	push   $0x1
 181:	e8 01 06 00 00       	call   787 <printf>
 186:	83 c4 10             	add    $0x10,%esp
 189:	eb 12                	jmp    19d <print_mode+0x9e>
  else
    printf(1, "-");
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	68 b4 0b 00 00       	push   $0xbb4
 193:	6a 01                	push   $0x1
 195:	e8 ed 05 00 00       	call   787 <printf>
 19a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1a4:	83 e0 80             	and    $0xffffff80,%eax
 1a7:	84 c0                	test   %al,%al
 1a9:	74 14                	je     1bf <print_mode+0xc0>
    printf(1, "w");
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	68 bc 0b 00 00       	push   $0xbbc
 1b3:	6a 01                	push   $0x1
 1b5:	e8 cd 05 00 00       	call   787 <printf>
 1ba:	83 c4 10             	add    $0x10,%esp
 1bd:	eb 12                	jmp    1d1 <print_mode+0xd2>
  else
    printf(1, "-");
 1bf:	83 ec 08             	sub    $0x8,%esp
 1c2:	68 b4 0b 00 00       	push   $0xbb4
 1c7:	6a 01                	push   $0x1
 1c9:	e8 b9 05 00 00       	call   787 <printf>
 1ce:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1d8:	c0 e8 06             	shr    $0x6,%al
 1db:	83 e0 01             	and    $0x1,%eax
 1de:	0f b6 d0             	movzbl %al,%edx
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 1e8:	d0 e8                	shr    %al
 1ea:	83 e0 01             	and    $0x1,%eax
 1ed:	0f b6 c0             	movzbl %al,%eax
 1f0:	21 d0                	and    %edx,%eax
 1f2:	85 c0                	test   %eax,%eax
 1f4:	74 14                	je     20a <print_mode+0x10b>
    printf(1, "S");
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	68 be 0b 00 00       	push   $0xbbe
 1fe:	6a 01                	push   $0x1
 200:	e8 82 05 00 00       	call   787 <printf>
 205:	83 c4 10             	add    $0x10,%esp
 208:	eb 34                	jmp    23e <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 211:	83 e0 40             	and    $0x40,%eax
 214:	84 c0                	test   %al,%al
 216:	74 14                	je     22c <print_mode+0x12d>
    printf(1, "x");
 218:	83 ec 08             	sub    $0x8,%esp
 21b:	68 c0 0b 00 00       	push   $0xbc0
 220:	6a 01                	push   $0x1
 222:	e8 60 05 00 00       	call   787 <printf>
 227:	83 c4 10             	add    $0x10,%esp
 22a:	eb 12                	jmp    23e <print_mode+0x13f>
  else
    printf(1, "-");
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	68 b4 0b 00 00       	push   $0xbb4
 234:	6a 01                	push   $0x1
 236:	e8 4c 05 00 00       	call   787 <printf>
 23b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 245:	83 e0 20             	and    $0x20,%eax
 248:	84 c0                	test   %al,%al
 24a:	74 14                	je     260 <print_mode+0x161>
    printf(1, "r");
 24c:	83 ec 08             	sub    $0x8,%esp
 24f:	68 ba 0b 00 00       	push   $0xbba
 254:	6a 01                	push   $0x1
 256:	e8 2c 05 00 00       	call   787 <printf>
 25b:	83 c4 10             	add    $0x10,%esp
 25e:	eb 12                	jmp    272 <print_mode+0x173>
  else
    printf(1, "-");
 260:	83 ec 08             	sub    $0x8,%esp
 263:	68 b4 0b 00 00       	push   $0xbb4
 268:	6a 01                	push   $0x1
 26a:	e8 18 05 00 00       	call   787 <printf>
 26f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 279:	83 e0 10             	and    $0x10,%eax
 27c:	84 c0                	test   %al,%al
 27e:	74 14                	je     294 <print_mode+0x195>
    printf(1, "w");
 280:	83 ec 08             	sub    $0x8,%esp
 283:	68 bc 0b 00 00       	push   $0xbbc
 288:	6a 01                	push   $0x1
 28a:	e8 f8 04 00 00       	call   787 <printf>
 28f:	83 c4 10             	add    $0x10,%esp
 292:	eb 12                	jmp    2a6 <print_mode+0x1a7>
  else
    printf(1, "-");
 294:	83 ec 08             	sub    $0x8,%esp
 297:	68 b4 0b 00 00       	push   $0xbb4
 29c:	6a 01                	push   $0x1
 29e:	e8 e4 04 00 00       	call   787 <printf>
 2a3:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2ad:	83 e0 08             	and    $0x8,%eax
 2b0:	84 c0                	test   %al,%al
 2b2:	74 14                	je     2c8 <print_mode+0x1c9>
    printf(1, "x");
 2b4:	83 ec 08             	sub    $0x8,%esp
 2b7:	68 c0 0b 00 00       	push   $0xbc0
 2bc:	6a 01                	push   $0x1
 2be:	e8 c4 04 00 00       	call   787 <printf>
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	eb 12                	jmp    2da <print_mode+0x1db>
  else
    printf(1, "-");
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	68 b4 0b 00 00       	push   $0xbb4
 2d0:	6a 01                	push   $0x1
 2d2:	e8 b0 04 00 00       	call   787 <printf>
 2d7:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2e1:	83 e0 04             	and    $0x4,%eax
 2e4:	84 c0                	test   %al,%al
 2e6:	74 14                	je     2fc <print_mode+0x1fd>
    printf(1, "r");
 2e8:	83 ec 08             	sub    $0x8,%esp
 2eb:	68 ba 0b 00 00       	push   $0xbba
 2f0:	6a 01                	push   $0x1
 2f2:	e8 90 04 00 00       	call   787 <printf>
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	eb 12                	jmp    30e <print_mode+0x20f>
  else
    printf(1, "-");
 2fc:	83 ec 08             	sub    $0x8,%esp
 2ff:	68 b4 0b 00 00       	push   $0xbb4
 304:	6a 01                	push   $0x1
 306:	e8 7c 04 00 00       	call   787 <printf>
 30b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 315:	83 e0 02             	and    $0x2,%eax
 318:	84 c0                	test   %al,%al
 31a:	74 14                	je     330 <print_mode+0x231>
    printf(1, "w");
 31c:	83 ec 08             	sub    $0x8,%esp
 31f:	68 bc 0b 00 00       	push   $0xbbc
 324:	6a 01                	push   $0x1
 326:	e8 5c 04 00 00       	call   787 <printf>
 32b:	83 c4 10             	add    $0x10,%esp
 32e:	eb 12                	jmp    342 <print_mode+0x243>
  else
    printf(1, "-");
 330:	83 ec 08             	sub    $0x8,%esp
 333:	68 b4 0b 00 00       	push   $0xbb4
 338:	6a 01                	push   $0x1
 33a:	e8 48 04 00 00       	call   787 <printf>
 33f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 349:	83 e0 01             	and    $0x1,%eax
 34c:	84 c0                	test   %al,%al
 34e:	74 14                	je     364 <print_mode+0x265>
    printf(1, "x");
 350:	83 ec 08             	sub    $0x8,%esp
 353:	68 c0 0b 00 00       	push   $0xbc0
 358:	6a 01                	push   $0x1
 35a:	e8 28 04 00 00       	call   787 <printf>
 35f:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 362:	eb 13                	jmp    377 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 364:	83 ec 08             	sub    $0x8,%esp
 367:	68 b4 0b 00 00       	push   $0xbb4
 36c:	6a 01                	push   $0x1
 36e:	e8 14 04 00 00       	call   787 <printf>
 373:	83 c4 10             	add    $0x10,%esp

  return;
 376:	90                   	nop
}
 377:	c9                   	leave  
 378:	c3                   	ret    

00000379 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	57                   	push   %edi
 37d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 37e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 381:	8b 55 10             	mov    0x10(%ebp),%edx
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	89 cb                	mov    %ecx,%ebx
 389:	89 df                	mov    %ebx,%edi
 38b:	89 d1                	mov    %edx,%ecx
 38d:	fc                   	cld    
 38e:	f3 aa                	rep stos %al,%es:(%edi)
 390:	89 ca                	mov    %ecx,%edx
 392:	89 fb                	mov    %edi,%ebx
 394:	89 5d 08             	mov    %ebx,0x8(%ebp)
 397:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 39a:	90                   	nop
 39b:	5b                   	pop    %ebx
 39c:	5f                   	pop    %edi
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret    

0000039f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
 3a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3ab:	90                   	nop
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
 3af:	8d 50 01             	lea    0x1(%eax),%edx
 3b2:	89 55 08             	mov    %edx,0x8(%ebp)
 3b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 3b8:	8d 4a 01             	lea    0x1(%edx),%ecx
 3bb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3be:	0f b6 12             	movzbl (%edx),%edx
 3c1:	88 10                	mov    %dl,(%eax)
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	84 c0                	test   %al,%al
 3c8:	75 e2                	jne    3ac <strcpy+0xd>
    ;
  return os;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3d2:	eb 08                	jmp    3dc <strcmp+0xd>
    p++, q++;
 3d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	84 c0                	test   %al,%al
 3e4:	74 10                	je     3f6 <strcmp+0x27>
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	0f b6 10             	movzbl (%eax),%edx
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	38 c2                	cmp    %al,%dl
 3f4:	74 de                	je     3d4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	0f b6 00             	movzbl (%eax),%eax
 3fc:	0f b6 d0             	movzbl %al,%edx
 3ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 402:	0f b6 00             	movzbl (%eax),%eax
 405:	0f b6 c0             	movzbl %al,%eax
 408:	29 c2                	sub    %eax,%edx
 40a:	89 d0                	mov    %edx,%eax
}
 40c:	5d                   	pop    %ebp
 40d:	c3                   	ret    

0000040e <strlen>:

uint
strlen(char *s)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 41b:	eb 04                	jmp    421 <strlen+0x13>
 41d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 421:	8b 55 fc             	mov    -0x4(%ebp),%edx
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	01 d0                	add    %edx,%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	84 c0                	test   %al,%al
 42e:	75 ed                	jne    41d <strlen+0xf>
    ;
  return n;
 430:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 433:	c9                   	leave  
 434:	c3                   	ret    

00000435 <memset>:

void*
memset(void *dst, int c, uint n)
{
 435:	55                   	push   %ebp
 436:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 438:	8b 45 10             	mov    0x10(%ebp),%eax
 43b:	50                   	push   %eax
 43c:	ff 75 0c             	pushl  0xc(%ebp)
 43f:	ff 75 08             	pushl  0x8(%ebp)
 442:	e8 32 ff ff ff       	call   379 <stosb>
 447:	83 c4 0c             	add    $0xc,%esp
  return dst;
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <strchr>:

char*
strchr(const char *s, char c)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 04             	sub    $0x4,%esp
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 45b:	eb 14                	jmp    471 <strchr+0x22>
    if(*s == c)
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	0f b6 00             	movzbl (%eax),%eax
 463:	3a 45 fc             	cmp    -0x4(%ebp),%al
 466:	75 05                	jne    46d <strchr+0x1e>
      return (char*)s;
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	eb 13                	jmp    480 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 46d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 471:	8b 45 08             	mov    0x8(%ebp),%eax
 474:	0f b6 00             	movzbl (%eax),%eax
 477:	84 c0                	test   %al,%al
 479:	75 e2                	jne    45d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 47b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 480:	c9                   	leave  
 481:	c3                   	ret    

00000482 <gets>:

char*
gets(char *buf, int max)
{
 482:	55                   	push   %ebp
 483:	89 e5                	mov    %esp,%ebp
 485:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 48f:	eb 42                	jmp    4d3 <gets+0x51>
    cc = read(0, &c, 1);
 491:	83 ec 04             	sub    $0x4,%esp
 494:	6a 01                	push   $0x1
 496:	8d 45 ef             	lea    -0x11(%ebp),%eax
 499:	50                   	push   %eax
 49a:	6a 00                	push   $0x0
 49c:	e8 47 01 00 00       	call   5e8 <read>
 4a1:	83 c4 10             	add    $0x10,%esp
 4a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ab:	7e 33                	jle    4e0 <gets+0x5e>
      break;
    buf[i++] = c;
 4ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b0:	8d 50 01             	lea    0x1(%eax),%edx
 4b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b6:	89 c2                	mov    %eax,%edx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	01 c2                	add    %eax,%edx
 4bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c7:	3c 0a                	cmp    $0xa,%al
 4c9:	74 16                	je     4e1 <gets+0x5f>
 4cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4cf:	3c 0d                	cmp    $0xd,%al
 4d1:	74 0e                	je     4e1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d6:	83 c0 01             	add    $0x1,%eax
 4d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4dc:	7c b3                	jl     491 <gets+0xf>
 4de:	eb 01                	jmp    4e1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4e0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	01 d0                	add    %edx,%eax
 4e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ef:	c9                   	leave  
 4f0:	c3                   	ret    

000004f1 <stat>:

int
stat(char *n, struct stat *st)
{
 4f1:	55                   	push   %ebp
 4f2:	89 e5                	mov    %esp,%ebp
 4f4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f7:	83 ec 08             	sub    $0x8,%esp
 4fa:	6a 00                	push   $0x0
 4fc:	ff 75 08             	pushl  0x8(%ebp)
 4ff:	e8 0c 01 00 00       	call   610 <open>
 504:	83 c4 10             	add    $0x10,%esp
 507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 50a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50e:	79 07                	jns    517 <stat+0x26>
    return -1;
 510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 515:	eb 25                	jmp    53c <stat+0x4b>
  r = fstat(fd, st);
 517:	83 ec 08             	sub    $0x8,%esp
 51a:	ff 75 0c             	pushl  0xc(%ebp)
 51d:	ff 75 f4             	pushl  -0xc(%ebp)
 520:	e8 03 01 00 00       	call   628 <fstat>
 525:	83 c4 10             	add    $0x10,%esp
 528:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 52b:	83 ec 0c             	sub    $0xc,%esp
 52e:	ff 75 f4             	pushl  -0xc(%ebp)
 531:	e8 c2 00 00 00       	call   5f8 <close>
 536:	83 c4 10             	add    $0x10,%esp
  return r;
 539:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 53c:	c9                   	leave  
 53d:	c3                   	ret    

0000053e <atoi>:

int
atoi(const char *s)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 544:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 54b:	eb 25                	jmp    572 <atoi+0x34>
    n = n*10 + *s++ - '0';
 54d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 550:	89 d0                	mov    %edx,%eax
 552:	c1 e0 02             	shl    $0x2,%eax
 555:	01 d0                	add    %edx,%eax
 557:	01 c0                	add    %eax,%eax
 559:	89 c1                	mov    %eax,%ecx
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	8d 50 01             	lea    0x1(%eax),%edx
 561:	89 55 08             	mov    %edx,0x8(%ebp)
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	01 c8                	add    %ecx,%eax
 56c:	83 e8 30             	sub    $0x30,%eax
 56f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	3c 2f                	cmp    $0x2f,%al
 57a:	7e 0a                	jle    586 <atoi+0x48>
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	3c 39                	cmp    $0x39,%al
 584:	7e c7                	jle    54d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 586:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 589:	c9                   	leave  
 58a:	c3                   	ret    

0000058b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 58b:	55                   	push   %ebp
 58c:	89 e5                	mov    %esp,%ebp
 58e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 597:	8b 45 0c             	mov    0xc(%ebp),%eax
 59a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 59d:	eb 17                	jmp    5b6 <memmove+0x2b>
    *dst++ = *src++;
 59f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a2:	8d 50 01             	lea    0x1(%eax),%edx
 5a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5ab:	8d 4a 01             	lea    0x1(%edx),%ecx
 5ae:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5b1:	0f b6 12             	movzbl (%edx),%edx
 5b4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b6:	8b 45 10             	mov    0x10(%ebp),%eax
 5b9:	8d 50 ff             	lea    -0x1(%eax),%edx
 5bc:	89 55 10             	mov    %edx,0x10(%ebp)
 5bf:	85 c0                	test   %eax,%eax
 5c1:	7f dc                	jg     59f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c6:	c9                   	leave  
 5c7:	c3                   	ret    

000005c8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c8:	b8 01 00 00 00       	mov    $0x1,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <exit>:
SYSCALL(exit)
 5d0:	b8 02 00 00 00       	mov    $0x2,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <wait>:
SYSCALL(wait)
 5d8:	b8 03 00 00 00       	mov    $0x3,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <pipe>:
SYSCALL(pipe)
 5e0:	b8 04 00 00 00       	mov    $0x4,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <read>:
SYSCALL(read)
 5e8:	b8 05 00 00 00       	mov    $0x5,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <write>:
SYSCALL(write)
 5f0:	b8 10 00 00 00       	mov    $0x10,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <close>:
SYSCALL(close)
 5f8:	b8 15 00 00 00       	mov    $0x15,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <kill>:
SYSCALL(kill)
 600:	b8 06 00 00 00       	mov    $0x6,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <exec>:
SYSCALL(exec)
 608:	b8 07 00 00 00       	mov    $0x7,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <open>:
SYSCALL(open)
 610:	b8 0f 00 00 00       	mov    $0xf,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <mknod>:
SYSCALL(mknod)
 618:	b8 11 00 00 00       	mov    $0x11,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <unlink>:
SYSCALL(unlink)
 620:	b8 12 00 00 00       	mov    $0x12,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <fstat>:
SYSCALL(fstat)
 628:	b8 08 00 00 00       	mov    $0x8,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <link>:
SYSCALL(link)
 630:	b8 13 00 00 00       	mov    $0x13,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <mkdir>:
SYSCALL(mkdir)
 638:	b8 14 00 00 00       	mov    $0x14,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <chdir>:
SYSCALL(chdir)
 640:	b8 09 00 00 00       	mov    $0x9,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <dup>:
SYSCALL(dup)
 648:	b8 0a 00 00 00       	mov    $0xa,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <getpid>:
SYSCALL(getpid)
 650:	b8 0b 00 00 00       	mov    $0xb,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <sbrk>:
SYSCALL(sbrk)
 658:	b8 0c 00 00 00       	mov    $0xc,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <sleep>:
SYSCALL(sleep)
 660:	b8 0d 00 00 00       	mov    $0xd,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <uptime>:
SYSCALL(uptime)
 668:	b8 0e 00 00 00       	mov    $0xe,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <halt>:
SYSCALL(halt)
 670:	b8 16 00 00 00       	mov    $0x16,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <date>:
//Student Implementations 
SYSCALL(date)
 678:	b8 17 00 00 00       	mov    $0x17,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <getuid>:

SYSCALL(getuid)
 680:	b8 18 00 00 00       	mov    $0x18,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <getgid>:
SYSCALL(getgid)
 688:	b8 19 00 00 00       	mov    $0x19,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <getppid>:
SYSCALL(getppid)
 690:	b8 1a 00 00 00       	mov    $0x1a,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <setuid>:

SYSCALL(setuid)
 698:	b8 1b 00 00 00       	mov    $0x1b,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <setgid>:
SYSCALL(setgid)
 6a0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <getprocs>:
SYSCALL(getprocs)
 6a8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 18             	sub    $0x18,%esp
 6b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6bc:	83 ec 04             	sub    $0x4,%esp
 6bf:	6a 01                	push   $0x1
 6c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6c4:	50                   	push   %eax
 6c5:	ff 75 08             	pushl  0x8(%ebp)
 6c8:	e8 23 ff ff ff       	call   5f0 <write>
 6cd:	83 c4 10             	add    $0x10,%esp
}
 6d0:	90                   	nop
 6d1:	c9                   	leave  
 6d2:	c3                   	ret    

000006d3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	53                   	push   %ebx
 6d7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6e5:	74 17                	je     6fe <printint+0x2b>
 6e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6eb:	79 11                	jns    6fe <printint+0x2b>
    neg = 1;
 6ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f7:	f7 d8                	neg    %eax
 6f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6fc:	eb 06                	jmp    704 <printint+0x31>
  } else {
    x = xx;
 6fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 701:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 70b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 70e:	8d 41 01             	lea    0x1(%ecx),%eax
 711:	89 45 f4             	mov    %eax,-0xc(%ebp)
 714:	8b 5d 10             	mov    0x10(%ebp),%ebx
 717:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71a:	ba 00 00 00 00       	mov    $0x0,%edx
 71f:	f7 f3                	div    %ebx
 721:	89 d0                	mov    %edx,%eax
 723:	0f b6 80 3c 0e 00 00 	movzbl 0xe3c(%eax),%eax
 72a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 72e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 731:	8b 45 ec             	mov    -0x14(%ebp),%eax
 734:	ba 00 00 00 00       	mov    $0x0,%edx
 739:	f7 f3                	div    %ebx
 73b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 73e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 742:	75 c7                	jne    70b <printint+0x38>
  if(neg)
 744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 748:	74 2d                	je     777 <printint+0xa4>
    buf[i++] = '-';
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	8d 50 01             	lea    0x1(%eax),%edx
 750:	89 55 f4             	mov    %edx,-0xc(%ebp)
 753:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 758:	eb 1d                	jmp    777 <printint+0xa4>
    putc(fd, buf[i]);
 75a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	01 d0                	add    %edx,%eax
 762:	0f b6 00             	movzbl (%eax),%eax
 765:	0f be c0             	movsbl %al,%eax
 768:	83 ec 08             	sub    $0x8,%esp
 76b:	50                   	push   %eax
 76c:	ff 75 08             	pushl  0x8(%ebp)
 76f:	e8 3c ff ff ff       	call   6b0 <putc>
 774:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 777:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 77b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77f:	79 d9                	jns    75a <printint+0x87>
    putc(fd, buf[i]);
}
 781:	90                   	nop
 782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 785:	c9                   	leave  
 786:	c3                   	ret    

00000787 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 787:	55                   	push   %ebp
 788:	89 e5                	mov    %esp,%ebp
 78a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 78d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 794:	8d 45 0c             	lea    0xc(%ebp),%eax
 797:	83 c0 04             	add    $0x4,%eax
 79a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 79d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a4:	e9 59 01 00 00       	jmp    902 <printf+0x17b>
    c = fmt[i] & 0xff;
 7a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	01 d0                	add    %edx,%eax
 7b1:	0f b6 00             	movzbl (%eax),%eax
 7b4:	0f be c0             	movsbl %al,%eax
 7b7:	25 ff 00 00 00       	and    $0xff,%eax
 7bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c3:	75 2c                	jne    7f1 <printf+0x6a>
      if(c == '%'){
 7c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c9:	75 0c                	jne    7d7 <printf+0x50>
        state = '%';
 7cb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d2:	e9 27 01 00 00       	jmp    8fe <printf+0x177>
      } else {
        putc(fd, c);
 7d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7da:	0f be c0             	movsbl %al,%eax
 7dd:	83 ec 08             	sub    $0x8,%esp
 7e0:	50                   	push   %eax
 7e1:	ff 75 08             	pushl  0x8(%ebp)
 7e4:	e8 c7 fe ff ff       	call   6b0 <putc>
 7e9:	83 c4 10             	add    $0x10,%esp
 7ec:	e9 0d 01 00 00       	jmp    8fe <printf+0x177>
      }
    } else if(state == '%'){
 7f1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7f5:	0f 85 03 01 00 00    	jne    8fe <printf+0x177>
      if(c == 'd'){
 7fb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7ff:	75 1e                	jne    81f <printf+0x98>
        printint(fd, *ap, 10, 1);
 801:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	6a 01                	push   $0x1
 808:	6a 0a                	push   $0xa
 80a:	50                   	push   %eax
 80b:	ff 75 08             	pushl  0x8(%ebp)
 80e:	e8 c0 fe ff ff       	call   6d3 <printint>
 813:	83 c4 10             	add    $0x10,%esp
        ap++;
 816:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81a:	e9 d8 00 00 00       	jmp    8f7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 81f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 823:	74 06                	je     82b <printf+0xa4>
 825:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 829:	75 1e                	jne    849 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 82b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	6a 00                	push   $0x0
 832:	6a 10                	push   $0x10
 834:	50                   	push   %eax
 835:	ff 75 08             	pushl  0x8(%ebp)
 838:	e8 96 fe ff ff       	call   6d3 <printint>
 83d:	83 c4 10             	add    $0x10,%esp
        ap++;
 840:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 844:	e9 ae 00 00 00       	jmp    8f7 <printf+0x170>
      } else if(c == 's'){
 849:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 84d:	75 43                	jne    892 <printf+0x10b>
        s = (char*)*ap;
 84f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 852:	8b 00                	mov    (%eax),%eax
 854:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 857:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 85b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85f:	75 25                	jne    886 <printf+0xff>
          s = "(null)";
 861:	c7 45 f4 c2 0b 00 00 	movl   $0xbc2,-0xc(%ebp)
        while(*s != 0){
 868:	eb 1c                	jmp    886 <printf+0xff>
          putc(fd, *s);
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	0f b6 00             	movzbl (%eax),%eax
 870:	0f be c0             	movsbl %al,%eax
 873:	83 ec 08             	sub    $0x8,%esp
 876:	50                   	push   %eax
 877:	ff 75 08             	pushl  0x8(%ebp)
 87a:	e8 31 fe ff ff       	call   6b0 <putc>
 87f:	83 c4 10             	add    $0x10,%esp
          s++;
 882:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	0f b6 00             	movzbl (%eax),%eax
 88c:	84 c0                	test   %al,%al
 88e:	75 da                	jne    86a <printf+0xe3>
 890:	eb 65                	jmp    8f7 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 892:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 896:	75 1d                	jne    8b5 <printf+0x12e>
        putc(fd, *ap);
 898:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	0f be c0             	movsbl %al,%eax
 8a0:	83 ec 08             	sub    $0x8,%esp
 8a3:	50                   	push   %eax
 8a4:	ff 75 08             	pushl  0x8(%ebp)
 8a7:	e8 04 fe ff ff       	call   6b0 <putc>
 8ac:	83 c4 10             	add    $0x10,%esp
        ap++;
 8af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b3:	eb 42                	jmp    8f7 <printf+0x170>
      } else if(c == '%'){
 8b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8b9:	75 17                	jne    8d2 <printf+0x14b>
        putc(fd, c);
 8bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8be:	0f be c0             	movsbl %al,%eax
 8c1:	83 ec 08             	sub    $0x8,%esp
 8c4:	50                   	push   %eax
 8c5:	ff 75 08             	pushl  0x8(%ebp)
 8c8:	e8 e3 fd ff ff       	call   6b0 <putc>
 8cd:	83 c4 10             	add    $0x10,%esp
 8d0:	eb 25                	jmp    8f7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d2:	83 ec 08             	sub    $0x8,%esp
 8d5:	6a 25                	push   $0x25
 8d7:	ff 75 08             	pushl  0x8(%ebp)
 8da:	e8 d1 fd ff ff       	call   6b0 <putc>
 8df:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e5:	0f be c0             	movsbl %al,%eax
 8e8:	83 ec 08             	sub    $0x8,%esp
 8eb:	50                   	push   %eax
 8ec:	ff 75 08             	pushl  0x8(%ebp)
 8ef:	e8 bc fd ff ff       	call   6b0 <putc>
 8f4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 902:	8b 55 0c             	mov    0xc(%ebp),%edx
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	01 d0                	add    %edx,%eax
 90a:	0f b6 00             	movzbl (%eax),%eax
 90d:	84 c0                	test   %al,%al
 90f:	0f 85 94 fe ff ff    	jne    7a9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 915:	90                   	nop
 916:	c9                   	leave  
 917:	c3                   	ret    

00000918 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 918:	55                   	push   %ebp
 919:	89 e5                	mov    %esp,%ebp
 91b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91e:	8b 45 08             	mov    0x8(%ebp),%eax
 921:	83 e8 08             	sub    $0x8,%eax
 924:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 927:	a1 58 0e 00 00       	mov    0xe58,%eax
 92c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 92f:	eb 24                	jmp    955 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 00                	mov    (%eax),%eax
 936:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 939:	77 12                	ja     94d <free+0x35>
 93b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 941:	77 24                	ja     967 <free+0x4f>
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	8b 00                	mov    (%eax),%eax
 948:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94b:	77 1a                	ja     967 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 00                	mov    (%eax),%eax
 952:	89 45 fc             	mov    %eax,-0x4(%ebp)
 955:	8b 45 f8             	mov    -0x8(%ebp),%eax
 958:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95b:	76 d4                	jbe    931 <free+0x19>
 95d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 960:	8b 00                	mov    (%eax),%eax
 962:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 965:	76 ca                	jbe    931 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 967:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96a:	8b 40 04             	mov    0x4(%eax),%eax
 96d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 974:	8b 45 f8             	mov    -0x8(%ebp),%eax
 977:	01 c2                	add    %eax,%edx
 979:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97c:	8b 00                	mov    (%eax),%eax
 97e:	39 c2                	cmp    %eax,%edx
 980:	75 24                	jne    9a6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 982:	8b 45 f8             	mov    -0x8(%ebp),%eax
 985:	8b 50 04             	mov    0x4(%eax),%edx
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	8b 00                	mov    (%eax),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	01 c2                	add    %eax,%edx
 992:	8b 45 f8             	mov    -0x8(%ebp),%eax
 995:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 998:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99b:	8b 00                	mov    (%eax),%eax
 99d:	8b 10                	mov    (%eax),%edx
 99f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a2:	89 10                	mov    %edx,(%eax)
 9a4:	eb 0a                	jmp    9b0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a9:	8b 10                	mov    (%eax),%edx
 9ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b3:	8b 40 04             	mov    0x4(%eax),%eax
 9b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c0:	01 d0                	add    %edx,%eax
 9c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c5:	75 20                	jne    9e7 <free+0xcf>
    p->s.size += bp->s.size;
 9c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ca:	8b 50 04             	mov    0x4(%eax),%edx
 9cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d0:	8b 40 04             	mov    0x4(%eax),%eax
 9d3:	01 c2                	add    %eax,%edx
 9d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9de:	8b 10                	mov    (%eax),%edx
 9e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e3:	89 10                	mov    %edx,(%eax)
 9e5:	eb 08                	jmp    9ef <free+0xd7>
  } else
    p->s.ptr = bp;
 9e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9ed:	89 10                	mov    %edx,(%eax)
  freep = p;
 9ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f2:	a3 58 0e 00 00       	mov    %eax,0xe58
}
 9f7:	90                   	nop
 9f8:	c9                   	leave  
 9f9:	c3                   	ret    

000009fa <morecore>:

static Header*
morecore(uint nu)
{
 9fa:	55                   	push   %ebp
 9fb:	89 e5                	mov    %esp,%ebp
 9fd:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a00:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a07:	77 07                	ja     a10 <morecore+0x16>
    nu = 4096;
 a09:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a10:	8b 45 08             	mov    0x8(%ebp),%eax
 a13:	c1 e0 03             	shl    $0x3,%eax
 a16:	83 ec 0c             	sub    $0xc,%esp
 a19:	50                   	push   %eax
 a1a:	e8 39 fc ff ff       	call   658 <sbrk>
 a1f:	83 c4 10             	add    $0x10,%esp
 a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a25:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a29:	75 07                	jne    a32 <morecore+0x38>
    return 0;
 a2b:	b8 00 00 00 00       	mov    $0x0,%eax
 a30:	eb 26                	jmp    a58 <morecore+0x5e>
  hp = (Header*)p;
 a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3b:	8b 55 08             	mov    0x8(%ebp),%edx
 a3e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a44:	83 c0 08             	add    $0x8,%eax
 a47:	83 ec 0c             	sub    $0xc,%esp
 a4a:	50                   	push   %eax
 a4b:	e8 c8 fe ff ff       	call   918 <free>
 a50:	83 c4 10             	add    $0x10,%esp
  return freep;
 a53:	a1 58 0e 00 00       	mov    0xe58,%eax
}
 a58:	c9                   	leave  
 a59:	c3                   	ret    

00000a5a <malloc>:

void*
malloc(uint nbytes)
{
 a5a:	55                   	push   %ebp
 a5b:	89 e5                	mov    %esp,%ebp
 a5d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a60:	8b 45 08             	mov    0x8(%ebp),%eax
 a63:	83 c0 07             	add    $0x7,%eax
 a66:	c1 e8 03             	shr    $0x3,%eax
 a69:	83 c0 01             	add    $0x1,%eax
 a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a6f:	a1 58 0e 00 00       	mov    0xe58,%eax
 a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a7b:	75 23                	jne    aa0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a7d:	c7 45 f0 50 0e 00 00 	movl   $0xe50,-0x10(%ebp)
 a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a87:	a3 58 0e 00 00       	mov    %eax,0xe58
 a8c:	a1 58 0e 00 00       	mov    0xe58,%eax
 a91:	a3 50 0e 00 00       	mov    %eax,0xe50
    base.s.size = 0;
 a96:	c7 05 54 0e 00 00 00 	movl   $0x0,0xe54
 a9d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa3:	8b 00                	mov    (%eax),%eax
 aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aab:	8b 40 04             	mov    0x4(%eax),%eax
 aae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab1:	72 4d                	jb     b00 <malloc+0xa6>
      if(p->s.size == nunits)
 ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab6:	8b 40 04             	mov    0x4(%eax),%eax
 ab9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 abc:	75 0c                	jne    aca <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac1:	8b 10                	mov    (%eax),%edx
 ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac6:	89 10                	mov    %edx,(%eax)
 ac8:	eb 26                	jmp    af0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acd:	8b 40 04             	mov    0x4(%eax),%eax
 ad0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ad3:	89 c2                	mov    %eax,%edx
 ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ade:	8b 40 04             	mov    0x4(%eax),%eax
 ae1:	c1 e0 03             	shl    $0x3,%eax
 ae4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aea:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aed:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af3:	a3 58 0e 00 00       	mov    %eax,0xe58
      return (void*)(p + 1);
 af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afb:	83 c0 08             	add    $0x8,%eax
 afe:	eb 3b                	jmp    b3b <malloc+0xe1>
    }
    if(p == freep)
 b00:	a1 58 0e 00 00       	mov    0xe58,%eax
 b05:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b08:	75 1e                	jne    b28 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b0a:	83 ec 0c             	sub    $0xc,%esp
 b0d:	ff 75 ec             	pushl  -0x14(%ebp)
 b10:	e8 e5 fe ff ff       	call   9fa <morecore>
 b15:	83 c4 10             	add    $0x10,%esp
 b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b1f:	75 07                	jne    b28 <malloc+0xce>
        return 0;
 b21:	b8 00 00 00 00       	mov    $0x0,%eax
 b26:	eb 13                	jmp    b3b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b31:	8b 00                	mov    (%eax),%eax
 b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b36:	e9 6d ff ff ff       	jmp    aa8 <malloc+0x4e>
}
 b3b:	c9                   	leave  
 b3c:	c3                   	ret    
