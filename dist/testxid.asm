
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
  11:	e8 62 06 00 00       	call   678 <getuid>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "current uid is: %d\n", uid);
  19:	83 ec 04             	sub    $0x4,%esp
  1c:	ff 75 f4             	pushl  -0xc(%ebp)
  1f:	68 4d 0b 00 00       	push   $0xb4d
  24:	6a 02                	push   $0x2
  26:	e8 6c 07 00 00       	call   797 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
    printf(2, "setting uid to 100\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 61 0b 00 00       	push   $0xb61
  36:	6a 02                	push   $0x2
  38:	e8 5a 07 00 00       	call   797 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
    setuid(100);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	6a 64                	push   $0x64
  45:	e8 46 06 00 00       	call   690 <setuid>
  4a:	83 c4 10             	add    $0x10,%esp
    uid = getuid();
  4d:	e8 26 06 00 00       	call   678 <getuid>
  52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "current uid is: %d\n", uid);
  55:	83 ec 04             	sub    $0x4,%esp
  58:	ff 75 f4             	pushl  -0xc(%ebp)
  5b:	68 4d 0b 00 00       	push   $0xb4d
  60:	6a 02                	push   $0x2
  62:	e8 30 07 00 00       	call   797 <printf>
  67:	83 c4 10             	add    $0x10,%esp

    gid = getgid();
  6a:	e8 11 06 00 00       	call   680 <getgid>
  6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "current gid is: %d\n", gid);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f0             	pushl  -0x10(%ebp)
  78:	68 75 0b 00 00       	push   $0xb75
  7d:	6a 02                	push   $0x2
  7f:	e8 13 07 00 00       	call   797 <printf>
  84:	83 c4 10             	add    $0x10,%esp
    printf(2, "setting gid to 100\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 89 0b 00 00       	push   $0xb89
  8f:	6a 02                	push   $0x2
  91:	e8 01 07 00 00       	call   797 <printf>
  96:	83 c4 10             	add    $0x10,%esp
    setuid(100);
  99:	83 ec 0c             	sub    $0xc,%esp
  9c:	6a 64                	push   $0x64
  9e:	e8 ed 05 00 00       	call   690 <setuid>
  a3:	83 c4 10             	add    $0x10,%esp
    gid = getuid();
  a6:	e8 cd 05 00 00       	call   678 <getuid>
  ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "current gid is: %d\n", gid);
  ae:	83 ec 04             	sub    $0x4,%esp
  b1:	ff 75 f0             	pushl  -0x10(%ebp)
  b4:	68 75 0b 00 00       	push   $0xb75
  b9:	6a 02                	push   $0x2
  bb:	e8 d7 06 00 00       	call   797 <printf>
  c0:	83 c4 10             	add    $0x10,%esp

    ppid = getppid();
  c3:	e8 c0 05 00 00       	call   688 <getppid>
  c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(2, "My parent process is: %d\n", ppid);
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	ff 75 ec             	pushl  -0x14(%ebp)
  d1:	68 9d 0b 00 00       	push   $0xb9d
  d6:	6a 02                	push   $0x2
  d8:	e8 ba 06 00 00       	call   797 <printf>
  dd:	83 c4 10             	add    $0x10,%esp
    printf(2, "Test Over\n");
  e0:	83 ec 08             	sub    $0x8,%esp
  e3:	68 b7 0b 00 00       	push   $0xbb7
  e8:	6a 02                	push   $0x2
  ea:	e8 a8 06 00 00       	call   797 <printf>
  ef:	83 c4 10             	add    $0x10,%esp

    exit();
  f2:	e8 d1 04 00 00       	call   5c8 <exit>

000000f7 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b7 00             	movzwl (%eax),%eax
 103:	98                   	cwtl   
 104:	83 f8 02             	cmp    $0x2,%eax
 107:	74 1e                	je     127 <print_mode+0x30>
 109:	83 f8 03             	cmp    $0x3,%eax
 10c:	74 2d                	je     13b <print_mode+0x44>
 10e:	83 f8 01             	cmp    $0x1,%eax
 111:	75 3c                	jne    14f <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 113:	83 ec 08             	sub    $0x8,%esp
 116:	68 c2 0b 00 00       	push   $0xbc2
 11b:	6a 01                	push   $0x1
 11d:	e8 75 06 00 00       	call   797 <printf>
 122:	83 c4 10             	add    $0x10,%esp
 125:	eb 3a                	jmp    161 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 127:	83 ec 08             	sub    $0x8,%esp
 12a:	68 c4 0b 00 00       	push   $0xbc4
 12f:	6a 01                	push   $0x1
 131:	e8 61 06 00 00       	call   797 <printf>
 136:	83 c4 10             	add    $0x10,%esp
 139:	eb 26                	jmp    161 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	68 c6 0b 00 00       	push   $0xbc6
 143:	6a 01                	push   $0x1
 145:	e8 4d 06 00 00       	call   797 <printf>
 14a:	83 c4 10             	add    $0x10,%esp
 14d:	eb 12                	jmp    161 <print_mode+0x6a>
    default: printf(1, "?");
 14f:	83 ec 08             	sub    $0x8,%esp
 152:	68 c8 0b 00 00       	push   $0xbc8
 157:	6a 01                	push   $0x1
 159:	e8 39 06 00 00       	call   797 <printf>
 15e:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 168:	83 e0 01             	and    $0x1,%eax
 16b:	84 c0                	test   %al,%al
 16d:	74 14                	je     183 <print_mode+0x8c>
    printf(1, "r");
 16f:	83 ec 08             	sub    $0x8,%esp
 172:	68 ca 0b 00 00       	push   $0xbca
 177:	6a 01                	push   $0x1
 179:	e8 19 06 00 00       	call   797 <printf>
 17e:	83 c4 10             	add    $0x10,%esp
 181:	eb 12                	jmp    195 <print_mode+0x9e>
  else
    printf(1, "-");
 183:	83 ec 08             	sub    $0x8,%esp
 186:	68 c4 0b 00 00       	push   $0xbc4
 18b:	6a 01                	push   $0x1
 18d:	e8 05 06 00 00       	call   797 <printf>
 192:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 19c:	83 e0 80             	and    $0xffffff80,%eax
 19f:	84 c0                	test   %al,%al
 1a1:	74 14                	je     1b7 <print_mode+0xc0>
    printf(1, "w");
 1a3:	83 ec 08             	sub    $0x8,%esp
 1a6:	68 cc 0b 00 00       	push   $0xbcc
 1ab:	6a 01                	push   $0x1
 1ad:	e8 e5 05 00 00       	call   797 <printf>
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	eb 12                	jmp    1c9 <print_mode+0xd2>
  else
    printf(1, "-");
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	68 c4 0b 00 00       	push   $0xbc4
 1bf:	6a 01                	push   $0x1
 1c1:	e8 d1 05 00 00       	call   797 <printf>
 1c6:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1d0:	c0 e8 06             	shr    $0x6,%al
 1d3:	83 e0 01             	and    $0x1,%eax
 1d6:	0f b6 d0             	movzbl %al,%edx
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 1e0:	d0 e8                	shr    %al
 1e2:	83 e0 01             	and    $0x1,%eax
 1e5:	0f b6 c0             	movzbl %al,%eax
 1e8:	21 d0                	and    %edx,%eax
 1ea:	85 c0                	test   %eax,%eax
 1ec:	74 14                	je     202 <print_mode+0x10b>
    printf(1, "S");
 1ee:	83 ec 08             	sub    $0x8,%esp
 1f1:	68 ce 0b 00 00       	push   $0xbce
 1f6:	6a 01                	push   $0x1
 1f8:	e8 9a 05 00 00       	call   797 <printf>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	eb 34                	jmp    236 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 209:	83 e0 40             	and    $0x40,%eax
 20c:	84 c0                	test   %al,%al
 20e:	74 14                	je     224 <print_mode+0x12d>
    printf(1, "x");
 210:	83 ec 08             	sub    $0x8,%esp
 213:	68 d0 0b 00 00       	push   $0xbd0
 218:	6a 01                	push   $0x1
 21a:	e8 78 05 00 00       	call   797 <printf>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	eb 12                	jmp    236 <print_mode+0x13f>
  else
    printf(1, "-");
 224:	83 ec 08             	sub    $0x8,%esp
 227:	68 c4 0b 00 00       	push   $0xbc4
 22c:	6a 01                	push   $0x1
 22e:	e8 64 05 00 00       	call   797 <printf>
 233:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 23d:	83 e0 20             	and    $0x20,%eax
 240:	84 c0                	test   %al,%al
 242:	74 14                	je     258 <print_mode+0x161>
    printf(1, "r");
 244:	83 ec 08             	sub    $0x8,%esp
 247:	68 ca 0b 00 00       	push   $0xbca
 24c:	6a 01                	push   $0x1
 24e:	e8 44 05 00 00       	call   797 <printf>
 253:	83 c4 10             	add    $0x10,%esp
 256:	eb 12                	jmp    26a <print_mode+0x173>
  else
    printf(1, "-");
 258:	83 ec 08             	sub    $0x8,%esp
 25b:	68 c4 0b 00 00       	push   $0xbc4
 260:	6a 01                	push   $0x1
 262:	e8 30 05 00 00       	call   797 <printf>
 267:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 271:	83 e0 10             	and    $0x10,%eax
 274:	84 c0                	test   %al,%al
 276:	74 14                	je     28c <print_mode+0x195>
    printf(1, "w");
 278:	83 ec 08             	sub    $0x8,%esp
 27b:	68 cc 0b 00 00       	push   $0xbcc
 280:	6a 01                	push   $0x1
 282:	e8 10 05 00 00       	call   797 <printf>
 287:	83 c4 10             	add    $0x10,%esp
 28a:	eb 12                	jmp    29e <print_mode+0x1a7>
  else
    printf(1, "-");
 28c:	83 ec 08             	sub    $0x8,%esp
 28f:	68 c4 0b 00 00       	push   $0xbc4
 294:	6a 01                	push   $0x1
 296:	e8 fc 04 00 00       	call   797 <printf>
 29b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2a5:	83 e0 08             	and    $0x8,%eax
 2a8:	84 c0                	test   %al,%al
 2aa:	74 14                	je     2c0 <print_mode+0x1c9>
    printf(1, "x");
 2ac:	83 ec 08             	sub    $0x8,%esp
 2af:	68 d0 0b 00 00       	push   $0xbd0
 2b4:	6a 01                	push   $0x1
 2b6:	e8 dc 04 00 00       	call   797 <printf>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	eb 12                	jmp    2d2 <print_mode+0x1db>
  else
    printf(1, "-");
 2c0:	83 ec 08             	sub    $0x8,%esp
 2c3:	68 c4 0b 00 00       	push   $0xbc4
 2c8:	6a 01                	push   $0x1
 2ca:	e8 c8 04 00 00       	call   797 <printf>
 2cf:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2d9:	83 e0 04             	and    $0x4,%eax
 2dc:	84 c0                	test   %al,%al
 2de:	74 14                	je     2f4 <print_mode+0x1fd>
    printf(1, "r");
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	68 ca 0b 00 00       	push   $0xbca
 2e8:	6a 01                	push   $0x1
 2ea:	e8 a8 04 00 00       	call   797 <printf>
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	eb 12                	jmp    306 <print_mode+0x20f>
  else
    printf(1, "-");
 2f4:	83 ec 08             	sub    $0x8,%esp
 2f7:	68 c4 0b 00 00       	push   $0xbc4
 2fc:	6a 01                	push   $0x1
 2fe:	e8 94 04 00 00       	call   797 <printf>
 303:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 30d:	83 e0 02             	and    $0x2,%eax
 310:	84 c0                	test   %al,%al
 312:	74 14                	je     328 <print_mode+0x231>
    printf(1, "w");
 314:	83 ec 08             	sub    $0x8,%esp
 317:	68 cc 0b 00 00       	push   $0xbcc
 31c:	6a 01                	push   $0x1
 31e:	e8 74 04 00 00       	call   797 <printf>
 323:	83 c4 10             	add    $0x10,%esp
 326:	eb 12                	jmp    33a <print_mode+0x243>
  else
    printf(1, "-");
 328:	83 ec 08             	sub    $0x8,%esp
 32b:	68 c4 0b 00 00       	push   $0xbc4
 330:	6a 01                	push   $0x1
 332:	e8 60 04 00 00       	call   797 <printf>
 337:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 341:	83 e0 01             	and    $0x1,%eax
 344:	84 c0                	test   %al,%al
 346:	74 14                	je     35c <print_mode+0x265>
    printf(1, "x");
 348:	83 ec 08             	sub    $0x8,%esp
 34b:	68 d0 0b 00 00       	push   $0xbd0
 350:	6a 01                	push   $0x1
 352:	e8 40 04 00 00       	call   797 <printf>
 357:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 35a:	eb 13                	jmp    36f <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 35c:	83 ec 08             	sub    $0x8,%esp
 35f:	68 c4 0b 00 00       	push   $0xbc4
 364:	6a 01                	push   $0x1
 366:	e8 2c 04 00 00       	call   797 <printf>
 36b:	83 c4 10             	add    $0x10,%esp

  return;
 36e:	90                   	nop
}
 36f:	c9                   	leave  
 370:	c3                   	ret    

00000371 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	57                   	push   %edi
 375:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 376:	8b 4d 08             	mov    0x8(%ebp),%ecx
 379:	8b 55 10             	mov    0x10(%ebp),%edx
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	89 cb                	mov    %ecx,%ebx
 381:	89 df                	mov    %ebx,%edi
 383:	89 d1                	mov    %edx,%ecx
 385:	fc                   	cld    
 386:	f3 aa                	rep stos %al,%es:(%edi)
 388:	89 ca                	mov    %ecx,%edx
 38a:	89 fb                	mov    %edi,%ebx
 38c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 38f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 392:	90                   	nop
 393:	5b                   	pop    %ebx
 394:	5f                   	pop    %edi
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    

00000397 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3a3:	90                   	nop
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	8d 50 01             	lea    0x1(%eax),%edx
 3aa:	89 55 08             	mov    %edx,0x8(%ebp)
 3ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 3b0:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3b6:	0f b6 12             	movzbl (%edx),%edx
 3b9:	88 10                	mov    %dl,(%eax)
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	84 c0                	test   %al,%al
 3c0:	75 e2                	jne    3a4 <strcpy+0xd>
    ;
  return os;
 3c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3ca:	eb 08                	jmp    3d4 <strcmp+0xd>
    p++, q++;
 3cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	0f b6 00             	movzbl (%eax),%eax
 3da:	84 c0                	test   %al,%al
 3dc:	74 10                	je     3ee <strcmp+0x27>
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	0f b6 10             	movzbl (%eax),%edx
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	38 c2                	cmp    %al,%dl
 3ec:	74 de                	je     3cc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	0f b6 d0             	movzbl %al,%edx
 3f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	0f b6 c0             	movzbl %al,%eax
 400:	29 c2                	sub    %eax,%edx
 402:	89 d0                	mov    %edx,%eax
}
 404:	5d                   	pop    %ebp
 405:	c3                   	ret    

00000406 <strlen>:

uint
strlen(char *s)
{
 406:	55                   	push   %ebp
 407:	89 e5                	mov    %esp,%ebp
 409:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 40c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 413:	eb 04                	jmp    419 <strlen+0x13>
 415:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 419:	8b 55 fc             	mov    -0x4(%ebp),%edx
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	01 d0                	add    %edx,%eax
 421:	0f b6 00             	movzbl (%eax),%eax
 424:	84 c0                	test   %al,%al
 426:	75 ed                	jne    415 <strlen+0xf>
    ;
  return n;
 428:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 42b:	c9                   	leave  
 42c:	c3                   	ret    

0000042d <memset>:

void*
memset(void *dst, int c, uint n)
{
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 430:	8b 45 10             	mov    0x10(%ebp),%eax
 433:	50                   	push   %eax
 434:	ff 75 0c             	pushl  0xc(%ebp)
 437:	ff 75 08             	pushl  0x8(%ebp)
 43a:	e8 32 ff ff ff       	call   371 <stosb>
 43f:	83 c4 0c             	add    $0xc,%esp
  return dst;
 442:	8b 45 08             	mov    0x8(%ebp),%eax
}
 445:	c9                   	leave  
 446:	c3                   	ret    

00000447 <strchr>:

char*
strchr(const char *s, char c)
{
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	83 ec 04             	sub    $0x4,%esp
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 453:	eb 14                	jmp    469 <strchr+0x22>
    if(*s == c)
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	0f b6 00             	movzbl (%eax),%eax
 45b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 45e:	75 05                	jne    465 <strchr+0x1e>
      return (char*)s;
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	eb 13                	jmp    478 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 465:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	0f b6 00             	movzbl (%eax),%eax
 46f:	84 c0                	test   %al,%al
 471:	75 e2                	jne    455 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 473:	b8 00 00 00 00       	mov    $0x0,%eax
}
 478:	c9                   	leave  
 479:	c3                   	ret    

0000047a <gets>:

char*
gets(char *buf, int max)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 487:	eb 42                	jmp    4cb <gets+0x51>
    cc = read(0, &c, 1);
 489:	83 ec 04             	sub    $0x4,%esp
 48c:	6a 01                	push   $0x1
 48e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 491:	50                   	push   %eax
 492:	6a 00                	push   $0x0
 494:	e8 47 01 00 00       	call   5e0 <read>
 499:	83 c4 10             	add    $0x10,%esp
 49c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 49f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a3:	7e 33                	jle    4d8 <gets+0x5e>
      break;
    buf[i++] = c;
 4a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a8:	8d 50 01             	lea    0x1(%eax),%edx
 4ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ae:	89 c2                	mov    %eax,%edx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	01 c2                	add    %eax,%edx
 4b5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4bb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bf:	3c 0a                	cmp    $0xa,%al
 4c1:	74 16                	je     4d9 <gets+0x5f>
 4c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c7:	3c 0d                	cmp    $0xd,%al
 4c9:	74 0e                	je     4d9 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ce:	83 c0 01             	add    $0x1,%eax
 4d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4d4:	7c b3                	jl     489 <gets+0xf>
 4d6:	eb 01                	jmp    4d9 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4d8:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	01 d0                	add    %edx,%eax
 4e1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e7:	c9                   	leave  
 4e8:	c3                   	ret    

000004e9 <stat>:

int
stat(char *n, struct stat *st)
{
 4e9:	55                   	push   %ebp
 4ea:	89 e5                	mov    %esp,%ebp
 4ec:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ef:	83 ec 08             	sub    $0x8,%esp
 4f2:	6a 00                	push   $0x0
 4f4:	ff 75 08             	pushl  0x8(%ebp)
 4f7:	e8 0c 01 00 00       	call   608 <open>
 4fc:	83 c4 10             	add    $0x10,%esp
 4ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 506:	79 07                	jns    50f <stat+0x26>
    return -1;
 508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 50d:	eb 25                	jmp    534 <stat+0x4b>
  r = fstat(fd, st);
 50f:	83 ec 08             	sub    $0x8,%esp
 512:	ff 75 0c             	pushl  0xc(%ebp)
 515:	ff 75 f4             	pushl  -0xc(%ebp)
 518:	e8 03 01 00 00       	call   620 <fstat>
 51d:	83 c4 10             	add    $0x10,%esp
 520:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 523:	83 ec 0c             	sub    $0xc,%esp
 526:	ff 75 f4             	pushl  -0xc(%ebp)
 529:	e8 c2 00 00 00       	call   5f0 <close>
 52e:	83 c4 10             	add    $0x10,%esp
  return r;
 531:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 534:	c9                   	leave  
 535:	c3                   	ret    

00000536 <atoi>:

int
atoi(const char *s)
{
 536:	55                   	push   %ebp
 537:	89 e5                	mov    %esp,%ebp
 539:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 53c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 543:	eb 25                	jmp    56a <atoi+0x34>
    n = n*10 + *s++ - '0';
 545:	8b 55 fc             	mov    -0x4(%ebp),%edx
 548:	89 d0                	mov    %edx,%eax
 54a:	c1 e0 02             	shl    $0x2,%eax
 54d:	01 d0                	add    %edx,%eax
 54f:	01 c0                	add    %eax,%eax
 551:	89 c1                	mov    %eax,%ecx
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	8d 50 01             	lea    0x1(%eax),%edx
 559:	89 55 08             	mov    %edx,0x8(%ebp)
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	0f be c0             	movsbl %al,%eax
 562:	01 c8                	add    %ecx,%eax
 564:	83 e8 30             	sub    $0x30,%eax
 567:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	0f b6 00             	movzbl (%eax),%eax
 570:	3c 2f                	cmp    $0x2f,%al
 572:	7e 0a                	jle    57e <atoi+0x48>
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	0f b6 00             	movzbl (%eax),%eax
 57a:	3c 39                	cmp    $0x39,%al
 57c:	7e c7                	jle    545 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 57e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 581:	c9                   	leave  
 582:	c3                   	ret    

00000583 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 583:	55                   	push   %ebp
 584:	89 e5                	mov    %esp,%ebp
 586:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 58f:	8b 45 0c             	mov    0xc(%ebp),%eax
 592:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 595:	eb 17                	jmp    5ae <memmove+0x2b>
    *dst++ = *src++;
 597:	8b 45 fc             	mov    -0x4(%ebp),%eax
 59a:	8d 50 01             	lea    0x1(%eax),%edx
 59d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5a3:	8d 4a 01             	lea    0x1(%edx),%ecx
 5a6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5a9:	0f b6 12             	movzbl (%edx),%edx
 5ac:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ae:	8b 45 10             	mov    0x10(%ebp),%eax
 5b1:	8d 50 ff             	lea    -0x1(%eax),%edx
 5b4:	89 55 10             	mov    %edx,0x10(%ebp)
 5b7:	85 c0                	test   %eax,%eax
 5b9:	7f dc                	jg     597 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5be:	c9                   	leave  
 5bf:	c3                   	ret    

000005c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c0:	b8 01 00 00 00       	mov    $0x1,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <exit>:
SYSCALL(exit)
 5c8:	b8 02 00 00 00       	mov    $0x2,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <wait>:
SYSCALL(wait)
 5d0:	b8 03 00 00 00       	mov    $0x3,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <pipe>:
SYSCALL(pipe)
 5d8:	b8 04 00 00 00       	mov    $0x4,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <read>:
SYSCALL(read)
 5e0:	b8 05 00 00 00       	mov    $0x5,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <write>:
SYSCALL(write)
 5e8:	b8 10 00 00 00       	mov    $0x10,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <close>:
SYSCALL(close)
 5f0:	b8 15 00 00 00       	mov    $0x15,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <kill>:
SYSCALL(kill)
 5f8:	b8 06 00 00 00       	mov    $0x6,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <exec>:
SYSCALL(exec)
 600:	b8 07 00 00 00       	mov    $0x7,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <open>:
SYSCALL(open)
 608:	b8 0f 00 00 00       	mov    $0xf,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <mknod>:
SYSCALL(mknod)
 610:	b8 11 00 00 00       	mov    $0x11,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <unlink>:
SYSCALL(unlink)
 618:	b8 12 00 00 00       	mov    $0x12,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <fstat>:
SYSCALL(fstat)
 620:	b8 08 00 00 00       	mov    $0x8,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <link>:
SYSCALL(link)
 628:	b8 13 00 00 00       	mov    $0x13,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <mkdir>:
SYSCALL(mkdir)
 630:	b8 14 00 00 00       	mov    $0x14,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <chdir>:
SYSCALL(chdir)
 638:	b8 09 00 00 00       	mov    $0x9,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <dup>:
SYSCALL(dup)
 640:	b8 0a 00 00 00       	mov    $0xa,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <getpid>:
SYSCALL(getpid)
 648:	b8 0b 00 00 00       	mov    $0xb,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <sbrk>:
SYSCALL(sbrk)
 650:	b8 0c 00 00 00       	mov    $0xc,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <sleep>:
SYSCALL(sleep)
 658:	b8 0d 00 00 00       	mov    $0xd,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <uptime>:
SYSCALL(uptime)
 660:	b8 0e 00 00 00       	mov    $0xe,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <halt>:
SYSCALL(halt)
 668:	b8 16 00 00 00       	mov    $0x16,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <date>:
//Student Implementations 
SYSCALL(date)
 670:	b8 17 00 00 00       	mov    $0x17,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <getuid>:

SYSCALL(getuid)
 678:	b8 18 00 00 00       	mov    $0x18,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <getgid>:
SYSCALL(getgid)
 680:	b8 19 00 00 00       	mov    $0x19,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <getppid>:
SYSCALL(getppid)
 688:	b8 1a 00 00 00       	mov    $0x1a,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <setuid>:

SYSCALL(setuid)
 690:	b8 1b 00 00 00       	mov    $0x1b,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <setgid>:
SYSCALL(setgid)
 698:	b8 1c 00 00 00       	mov    $0x1c,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <getprocs>:
SYSCALL(getprocs)
 6a0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <chown>:

SYSCALL(chown)
 6a8:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <chgrp>:
SYSCALL(chgrp)
 6b0:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <chmod>:
SYSCALL(chmod)
 6b8:	b8 20 00 00 00       	mov    $0x20,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	83 ec 18             	sub    $0x18,%esp
 6c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6cc:	83 ec 04             	sub    $0x4,%esp
 6cf:	6a 01                	push   $0x1
 6d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6d4:	50                   	push   %eax
 6d5:	ff 75 08             	pushl  0x8(%ebp)
 6d8:	e8 0b ff ff ff       	call   5e8 <write>
 6dd:	83 c4 10             	add    $0x10,%esp
}
 6e0:	90                   	nop
 6e1:	c9                   	leave  
 6e2:	c3                   	ret    

000006e3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6e3:	55                   	push   %ebp
 6e4:	89 e5                	mov    %esp,%ebp
 6e6:	53                   	push   %ebx
 6e7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6f1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6f5:	74 17                	je     70e <printint+0x2b>
 6f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6fb:	79 11                	jns    70e <printint+0x2b>
    neg = 1;
 6fd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 704:	8b 45 0c             	mov    0xc(%ebp),%eax
 707:	f7 d8                	neg    %eax
 709:	89 45 ec             	mov    %eax,-0x14(%ebp)
 70c:	eb 06                	jmp    714 <printint+0x31>
  } else {
    x = xx;
 70e:	8b 45 0c             	mov    0xc(%ebp),%eax
 711:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 714:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 71b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 71e:	8d 41 01             	lea    0x1(%ecx),%eax
 721:	89 45 f4             	mov    %eax,-0xc(%ebp)
 724:	8b 5d 10             	mov    0x10(%ebp),%ebx
 727:	8b 45 ec             	mov    -0x14(%ebp),%eax
 72a:	ba 00 00 00 00       	mov    $0x0,%edx
 72f:	f7 f3                	div    %ebx
 731:	89 d0                	mov    %edx,%eax
 733:	0f b6 80 44 0e 00 00 	movzbl 0xe44(%eax),%eax
 73a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 73e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 741:	8b 45 ec             	mov    -0x14(%ebp),%eax
 744:	ba 00 00 00 00       	mov    $0x0,%edx
 749:	f7 f3                	div    %ebx
 74b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 74e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 752:	75 c7                	jne    71b <printint+0x38>
  if(neg)
 754:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 758:	74 2d                	je     787 <printint+0xa4>
    buf[i++] = '-';
 75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75d:	8d 50 01             	lea    0x1(%eax),%edx
 760:	89 55 f4             	mov    %edx,-0xc(%ebp)
 763:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 768:	eb 1d                	jmp    787 <printint+0xa4>
    putc(fd, buf[i]);
 76a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	01 d0                	add    %edx,%eax
 772:	0f b6 00             	movzbl (%eax),%eax
 775:	0f be c0             	movsbl %al,%eax
 778:	83 ec 08             	sub    $0x8,%esp
 77b:	50                   	push   %eax
 77c:	ff 75 08             	pushl  0x8(%ebp)
 77f:	e8 3c ff ff ff       	call   6c0 <putc>
 784:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 787:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 78b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 78f:	79 d9                	jns    76a <printint+0x87>
    putc(fd, buf[i]);
}
 791:	90                   	nop
 792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 795:	c9                   	leave  
 796:	c3                   	ret    

00000797 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 797:	55                   	push   %ebp
 798:	89 e5                	mov    %esp,%ebp
 79a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 79d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7a4:	8d 45 0c             	lea    0xc(%ebp),%eax
 7a7:	83 c0 04             	add    $0x4,%eax
 7aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7b4:	e9 59 01 00 00       	jmp    912 <printf+0x17b>
    c = fmt[i] & 0xff;
 7b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	01 d0                	add    %edx,%eax
 7c1:	0f b6 00             	movzbl (%eax),%eax
 7c4:	0f be c0             	movsbl %al,%eax
 7c7:	25 ff 00 00 00       	and    $0xff,%eax
 7cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7d3:	75 2c                	jne    801 <printf+0x6a>
      if(c == '%'){
 7d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d9:	75 0c                	jne    7e7 <printf+0x50>
        state = '%';
 7db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7e2:	e9 27 01 00 00       	jmp    90e <printf+0x177>
      } else {
        putc(fd, c);
 7e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ea:	0f be c0             	movsbl %al,%eax
 7ed:	83 ec 08             	sub    $0x8,%esp
 7f0:	50                   	push   %eax
 7f1:	ff 75 08             	pushl  0x8(%ebp)
 7f4:	e8 c7 fe ff ff       	call   6c0 <putc>
 7f9:	83 c4 10             	add    $0x10,%esp
 7fc:	e9 0d 01 00 00       	jmp    90e <printf+0x177>
      }
    } else if(state == '%'){
 801:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 805:	0f 85 03 01 00 00    	jne    90e <printf+0x177>
      if(c == 'd'){
 80b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 80f:	75 1e                	jne    82f <printf+0x98>
        printint(fd, *ap, 10, 1);
 811:	8b 45 e8             	mov    -0x18(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	6a 01                	push   $0x1
 818:	6a 0a                	push   $0xa
 81a:	50                   	push   %eax
 81b:	ff 75 08             	pushl  0x8(%ebp)
 81e:	e8 c0 fe ff ff       	call   6e3 <printint>
 823:	83 c4 10             	add    $0x10,%esp
        ap++;
 826:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 82a:	e9 d8 00 00 00       	jmp    907 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 82f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 833:	74 06                	je     83b <printf+0xa4>
 835:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 839:	75 1e                	jne    859 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 83b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83e:	8b 00                	mov    (%eax),%eax
 840:	6a 00                	push   $0x0
 842:	6a 10                	push   $0x10
 844:	50                   	push   %eax
 845:	ff 75 08             	pushl  0x8(%ebp)
 848:	e8 96 fe ff ff       	call   6e3 <printint>
 84d:	83 c4 10             	add    $0x10,%esp
        ap++;
 850:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 854:	e9 ae 00 00 00       	jmp    907 <printf+0x170>
      } else if(c == 's'){
 859:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 85d:	75 43                	jne    8a2 <printf+0x10b>
        s = (char*)*ap;
 85f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 867:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 86b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86f:	75 25                	jne    896 <printf+0xff>
          s = "(null)";
 871:	c7 45 f4 d2 0b 00 00 	movl   $0xbd2,-0xc(%ebp)
        while(*s != 0){
 878:	eb 1c                	jmp    896 <printf+0xff>
          putc(fd, *s);
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	0f be c0             	movsbl %al,%eax
 883:	83 ec 08             	sub    $0x8,%esp
 886:	50                   	push   %eax
 887:	ff 75 08             	pushl  0x8(%ebp)
 88a:	e8 31 fe ff ff       	call   6c0 <putc>
 88f:	83 c4 10             	add    $0x10,%esp
          s++;
 892:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	0f b6 00             	movzbl (%eax),%eax
 89c:	84 c0                	test   %al,%al
 89e:	75 da                	jne    87a <printf+0xe3>
 8a0:	eb 65                	jmp    907 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8a2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8a6:	75 1d                	jne    8c5 <printf+0x12e>
        putc(fd, *ap);
 8a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ab:	8b 00                	mov    (%eax),%eax
 8ad:	0f be c0             	movsbl %al,%eax
 8b0:	83 ec 08             	sub    $0x8,%esp
 8b3:	50                   	push   %eax
 8b4:	ff 75 08             	pushl  0x8(%ebp)
 8b7:	e8 04 fe ff ff       	call   6c0 <putc>
 8bc:	83 c4 10             	add    $0x10,%esp
        ap++;
 8bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c3:	eb 42                	jmp    907 <printf+0x170>
      } else if(c == '%'){
 8c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8c9:	75 17                	jne    8e2 <printf+0x14b>
        putc(fd, c);
 8cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ce:	0f be c0             	movsbl %al,%eax
 8d1:	83 ec 08             	sub    $0x8,%esp
 8d4:	50                   	push   %eax
 8d5:	ff 75 08             	pushl  0x8(%ebp)
 8d8:	e8 e3 fd ff ff       	call   6c0 <putc>
 8dd:	83 c4 10             	add    $0x10,%esp
 8e0:	eb 25                	jmp    907 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8e2:	83 ec 08             	sub    $0x8,%esp
 8e5:	6a 25                	push   $0x25
 8e7:	ff 75 08             	pushl  0x8(%ebp)
 8ea:	e8 d1 fd ff ff       	call   6c0 <putc>
 8ef:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f5:	0f be c0             	movsbl %al,%eax
 8f8:	83 ec 08             	sub    $0x8,%esp
 8fb:	50                   	push   %eax
 8fc:	ff 75 08             	pushl  0x8(%ebp)
 8ff:	e8 bc fd ff ff       	call   6c0 <putc>
 904:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 907:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 90e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 912:	8b 55 0c             	mov    0xc(%ebp),%edx
 915:	8b 45 f0             	mov    -0x10(%ebp),%eax
 918:	01 d0                	add    %edx,%eax
 91a:	0f b6 00             	movzbl (%eax),%eax
 91d:	84 c0                	test   %al,%al
 91f:	0f 85 94 fe ff ff    	jne    7b9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 925:	90                   	nop
 926:	c9                   	leave  
 927:	c3                   	ret    

00000928 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 928:	55                   	push   %ebp
 929:	89 e5                	mov    %esp,%ebp
 92b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 92e:	8b 45 08             	mov    0x8(%ebp),%eax
 931:	83 e8 08             	sub    $0x8,%eax
 934:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 937:	a1 60 0e 00 00       	mov    0xe60,%eax
 93c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 93f:	eb 24                	jmp    965 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	8b 00                	mov    (%eax),%eax
 946:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 949:	77 12                	ja     95d <free+0x35>
 94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 951:	77 24                	ja     977 <free+0x4f>
 953:	8b 45 fc             	mov    -0x4(%ebp),%eax
 956:	8b 00                	mov    (%eax),%eax
 958:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95b:	77 1a                	ja     977 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 960:	8b 00                	mov    (%eax),%eax
 962:	89 45 fc             	mov    %eax,-0x4(%ebp)
 965:	8b 45 f8             	mov    -0x8(%ebp),%eax
 968:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 96b:	76 d4                	jbe    941 <free+0x19>
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	8b 00                	mov    (%eax),%eax
 972:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 975:	76 ca                	jbe    941 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 977:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97a:	8b 40 04             	mov    0x4(%eax),%eax
 97d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 984:	8b 45 f8             	mov    -0x8(%ebp),%eax
 987:	01 c2                	add    %eax,%edx
 989:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98c:	8b 00                	mov    (%eax),%eax
 98e:	39 c2                	cmp    %eax,%edx
 990:	75 24                	jne    9b6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 992:	8b 45 f8             	mov    -0x8(%ebp),%eax
 995:	8b 50 04             	mov    0x4(%eax),%edx
 998:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99b:	8b 00                	mov    (%eax),%eax
 99d:	8b 40 04             	mov    0x4(%eax),%eax
 9a0:	01 c2                	add    %eax,%edx
 9a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ab:	8b 00                	mov    (%eax),%eax
 9ad:	8b 10                	mov    (%eax),%edx
 9af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b2:	89 10                	mov    %edx,(%eax)
 9b4:	eb 0a                	jmp    9c0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b9:	8b 10                	mov    (%eax),%edx
 9bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9be:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c3:	8b 40 04             	mov    0x4(%eax),%eax
 9c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d0:	01 d0                	add    %edx,%eax
 9d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d5:	75 20                	jne    9f7 <free+0xcf>
    p->s.size += bp->s.size;
 9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9da:	8b 50 04             	mov    0x4(%eax),%edx
 9dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e0:	8b 40 04             	mov    0x4(%eax),%eax
 9e3:	01 c2                	add    %eax,%edx
 9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ee:	8b 10                	mov    (%eax),%edx
 9f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f3:	89 10                	mov    %edx,(%eax)
 9f5:	eb 08                	jmp    9ff <free+0xd7>
  } else
    p->s.ptr = bp;
 9f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9fd:	89 10                	mov    %edx,(%eax)
  freep = p;
 9ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a02:	a3 60 0e 00 00       	mov    %eax,0xe60
}
 a07:	90                   	nop
 a08:	c9                   	leave  
 a09:	c3                   	ret    

00000a0a <morecore>:

static Header*
morecore(uint nu)
{
 a0a:	55                   	push   %ebp
 a0b:	89 e5                	mov    %esp,%ebp
 a0d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a10:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a17:	77 07                	ja     a20 <morecore+0x16>
    nu = 4096;
 a19:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a20:	8b 45 08             	mov    0x8(%ebp),%eax
 a23:	c1 e0 03             	shl    $0x3,%eax
 a26:	83 ec 0c             	sub    $0xc,%esp
 a29:	50                   	push   %eax
 a2a:	e8 21 fc ff ff       	call   650 <sbrk>
 a2f:	83 c4 10             	add    $0x10,%esp
 a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a35:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a39:	75 07                	jne    a42 <morecore+0x38>
    return 0;
 a3b:	b8 00 00 00 00       	mov    $0x0,%eax
 a40:	eb 26                	jmp    a68 <morecore+0x5e>
  hp = (Header*)p;
 a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4b:	8b 55 08             	mov    0x8(%ebp),%edx
 a4e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a54:	83 c0 08             	add    $0x8,%eax
 a57:	83 ec 0c             	sub    $0xc,%esp
 a5a:	50                   	push   %eax
 a5b:	e8 c8 fe ff ff       	call   928 <free>
 a60:	83 c4 10             	add    $0x10,%esp
  return freep;
 a63:	a1 60 0e 00 00       	mov    0xe60,%eax
}
 a68:	c9                   	leave  
 a69:	c3                   	ret    

00000a6a <malloc>:

void*
malloc(uint nbytes)
{
 a6a:	55                   	push   %ebp
 a6b:	89 e5                	mov    %esp,%ebp
 a6d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a70:	8b 45 08             	mov    0x8(%ebp),%eax
 a73:	83 c0 07             	add    $0x7,%eax
 a76:	c1 e8 03             	shr    $0x3,%eax
 a79:	83 c0 01             	add    $0x1,%eax
 a7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a7f:	a1 60 0e 00 00       	mov    0xe60,%eax
 a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a8b:	75 23                	jne    ab0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a8d:	c7 45 f0 58 0e 00 00 	movl   $0xe58,-0x10(%ebp)
 a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a97:	a3 60 0e 00 00       	mov    %eax,0xe60
 a9c:	a1 60 0e 00 00       	mov    0xe60,%eax
 aa1:	a3 58 0e 00 00       	mov    %eax,0xe58
    base.s.size = 0;
 aa6:	c7 05 5c 0e 00 00 00 	movl   $0x0,0xe5c
 aad:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab3:	8b 00                	mov    (%eax),%eax
 ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abb:	8b 40 04             	mov    0x4(%eax),%eax
 abe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ac1:	72 4d                	jb     b10 <malloc+0xa6>
      if(p->s.size == nunits)
 ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac6:	8b 40 04             	mov    0x4(%eax),%eax
 ac9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 acc:	75 0c                	jne    ada <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad1:	8b 10                	mov    (%eax),%edx
 ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad6:	89 10                	mov    %edx,(%eax)
 ad8:	eb 26                	jmp    b00 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
 add:	8b 40 04             	mov    0x4(%eax),%eax
 ae0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ae3:	89 c2                	mov    %eax,%edx
 ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aee:	8b 40 04             	mov    0x4(%eax),%eax
 af1:	c1 e0 03             	shl    $0x3,%eax
 af4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afa:	8b 55 ec             	mov    -0x14(%ebp),%edx
 afd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b03:	a3 60 0e 00 00       	mov    %eax,0xe60
      return (void*)(p + 1);
 b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0b:	83 c0 08             	add    $0x8,%eax
 b0e:	eb 3b                	jmp    b4b <malloc+0xe1>
    }
    if(p == freep)
 b10:	a1 60 0e 00 00       	mov    0xe60,%eax
 b15:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b18:	75 1e                	jne    b38 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b1a:	83 ec 0c             	sub    $0xc,%esp
 b1d:	ff 75 ec             	pushl  -0x14(%ebp)
 b20:	e8 e5 fe ff ff       	call   a0a <morecore>
 b25:	83 c4 10             	add    $0x10,%esp
 b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b2f:	75 07                	jne    b38 <malloc+0xce>
        return 0;
 b31:	b8 00 00 00 00       	mov    $0x0,%eax
 b36:	eb 13                	jmp    b4b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b41:	8b 00                	mov    (%eax),%eax
 b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b46:	e9 6d ff ff ff       	jmp    ab8 <malloc+0x4e>
}
 b4b:	c9                   	leave  
 b4c:	c3                   	ret    
