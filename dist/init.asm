
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 42 0b 00 00       	push   $0xb42
  1b:	e8 f2 05 00 00       	call   612 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 42 0b 00 00       	push   $0xb42
  33:	e8 e2 05 00 00       	call   61a <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 42 0b 00 00       	push   $0xb42
  45:	e8 c8 05 00 00       	call   612 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 f3 05 00 00       	call   64a <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 e6 05 00 00       	call   64a <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 4a 0b 00 00       	push   $0xb4a
  6f:	6a 01                	push   $0x1
  71:	e8 13 07 00 00       	call   789 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 4c 05 00 00       	call   5ca <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 5d 0b 00 00       	push   $0xb5d
  8f:	6a 01                	push   $0x1
  91:	e8 f3 06 00 00       	call   789 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 34 05 00 00       	call   5d2 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 10 0e 00 00       	push   $0xe10
  ac:	68 3f 0b 00 00       	push   $0xb3f
  b1:	e8 54 05 00 00       	call   60a <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 70 0b 00 00       	push   $0xb70
  c1:	6a 01                	push   $0x1
  c3:	e8 c1 06 00 00       	call   789 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 02 05 00 00       	call   5d2 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 86 0b 00 00       	push   $0xb86
  d8:	6a 01                	push   $0x1
  da:	e8 aa 06 00 00       	call   789 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 f3 04 00 00       	call   5da <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
      printf(1, "zombie!\n");
  }
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	0f b7 00             	movzwl (%eax),%eax
 10d:	98                   	cwtl   
 10e:	83 f8 02             	cmp    $0x2,%eax
 111:	74 1e                	je     131 <print_mode+0x30>
 113:	83 f8 03             	cmp    $0x3,%eax
 116:	74 2d                	je     145 <print_mode+0x44>
 118:	83 f8 01             	cmp    $0x1,%eax
 11b:	75 3c                	jne    159 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 11d:	83 ec 08             	sub    $0x8,%esp
 120:	68 8f 0b 00 00       	push   $0xb8f
 125:	6a 01                	push   $0x1
 127:	e8 5d 06 00 00       	call   789 <printf>
 12c:	83 c4 10             	add    $0x10,%esp
 12f:	eb 3a                	jmp    16b <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 131:	83 ec 08             	sub    $0x8,%esp
 134:	68 91 0b 00 00       	push   $0xb91
 139:	6a 01                	push   $0x1
 13b:	e8 49 06 00 00       	call   789 <printf>
 140:	83 c4 10             	add    $0x10,%esp
 143:	eb 26                	jmp    16b <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 145:	83 ec 08             	sub    $0x8,%esp
 148:	68 93 0b 00 00       	push   $0xb93
 14d:	6a 01                	push   $0x1
 14f:	e8 35 06 00 00       	call   789 <printf>
 154:	83 c4 10             	add    $0x10,%esp
 157:	eb 12                	jmp    16b <print_mode+0x6a>
    default: printf(1, "?");
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	68 95 0b 00 00       	push   $0xb95
 161:	6a 01                	push   $0x1
 163:	e8 21 06 00 00       	call   789 <printf>
 168:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 172:	83 e0 01             	and    $0x1,%eax
 175:	84 c0                	test   %al,%al
 177:	74 14                	je     18d <print_mode+0x8c>
    printf(1, "r");
 179:	83 ec 08             	sub    $0x8,%esp
 17c:	68 97 0b 00 00       	push   $0xb97
 181:	6a 01                	push   $0x1
 183:	e8 01 06 00 00       	call   789 <printf>
 188:	83 c4 10             	add    $0x10,%esp
 18b:	eb 12                	jmp    19f <print_mode+0x9e>
  else
    printf(1, "-");
 18d:	83 ec 08             	sub    $0x8,%esp
 190:	68 91 0b 00 00       	push   $0xb91
 195:	6a 01                	push   $0x1
 197:	e8 ed 05 00 00       	call   789 <printf>
 19c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1a6:	83 e0 80             	and    $0xffffff80,%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	74 14                	je     1c1 <print_mode+0xc0>
    printf(1, "w");
 1ad:	83 ec 08             	sub    $0x8,%esp
 1b0:	68 99 0b 00 00       	push   $0xb99
 1b5:	6a 01                	push   $0x1
 1b7:	e8 cd 05 00 00       	call   789 <printf>
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	eb 12                	jmp    1d3 <print_mode+0xd2>
  else
    printf(1, "-");
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	68 91 0b 00 00       	push   $0xb91
 1c9:	6a 01                	push   $0x1
 1cb:	e8 b9 05 00 00       	call   789 <printf>
 1d0:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1da:	c0 e8 06             	shr    $0x6,%al
 1dd:	83 e0 01             	and    $0x1,%eax
 1e0:	0f b6 d0             	movzbl %al,%edx
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 1ea:	d0 e8                	shr    %al
 1ec:	83 e0 01             	and    $0x1,%eax
 1ef:	0f b6 c0             	movzbl %al,%eax
 1f2:	21 d0                	and    %edx,%eax
 1f4:	85 c0                	test   %eax,%eax
 1f6:	74 14                	je     20c <print_mode+0x10b>
    printf(1, "S");
 1f8:	83 ec 08             	sub    $0x8,%esp
 1fb:	68 9b 0b 00 00       	push   $0xb9b
 200:	6a 01                	push   $0x1
 202:	e8 82 05 00 00       	call   789 <printf>
 207:	83 c4 10             	add    $0x10,%esp
 20a:	eb 34                	jmp    240 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 213:	83 e0 40             	and    $0x40,%eax
 216:	84 c0                	test   %al,%al
 218:	74 14                	je     22e <print_mode+0x12d>
    printf(1, "x");
 21a:	83 ec 08             	sub    $0x8,%esp
 21d:	68 9d 0b 00 00       	push   $0xb9d
 222:	6a 01                	push   $0x1
 224:	e8 60 05 00 00       	call   789 <printf>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	eb 12                	jmp    240 <print_mode+0x13f>
  else
    printf(1, "-");
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	68 91 0b 00 00       	push   $0xb91
 236:	6a 01                	push   $0x1
 238:	e8 4c 05 00 00       	call   789 <printf>
 23d:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 247:	83 e0 20             	and    $0x20,%eax
 24a:	84 c0                	test   %al,%al
 24c:	74 14                	je     262 <print_mode+0x161>
    printf(1, "r");
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	68 97 0b 00 00       	push   $0xb97
 256:	6a 01                	push   $0x1
 258:	e8 2c 05 00 00       	call   789 <printf>
 25d:	83 c4 10             	add    $0x10,%esp
 260:	eb 12                	jmp    274 <print_mode+0x173>
  else
    printf(1, "-");
 262:	83 ec 08             	sub    $0x8,%esp
 265:	68 91 0b 00 00       	push   $0xb91
 26a:	6a 01                	push   $0x1
 26c:	e8 18 05 00 00       	call   789 <printf>
 271:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 27b:	83 e0 10             	and    $0x10,%eax
 27e:	84 c0                	test   %al,%al
 280:	74 14                	je     296 <print_mode+0x195>
    printf(1, "w");
 282:	83 ec 08             	sub    $0x8,%esp
 285:	68 99 0b 00 00       	push   $0xb99
 28a:	6a 01                	push   $0x1
 28c:	e8 f8 04 00 00       	call   789 <printf>
 291:	83 c4 10             	add    $0x10,%esp
 294:	eb 12                	jmp    2a8 <print_mode+0x1a7>
  else
    printf(1, "-");
 296:	83 ec 08             	sub    $0x8,%esp
 299:	68 91 0b 00 00       	push   $0xb91
 29e:	6a 01                	push   $0x1
 2a0:	e8 e4 04 00 00       	call   789 <printf>
 2a5:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2af:	83 e0 08             	and    $0x8,%eax
 2b2:	84 c0                	test   %al,%al
 2b4:	74 14                	je     2ca <print_mode+0x1c9>
    printf(1, "x");
 2b6:	83 ec 08             	sub    $0x8,%esp
 2b9:	68 9d 0b 00 00       	push   $0xb9d
 2be:	6a 01                	push   $0x1
 2c0:	e8 c4 04 00 00       	call   789 <printf>
 2c5:	83 c4 10             	add    $0x10,%esp
 2c8:	eb 12                	jmp    2dc <print_mode+0x1db>
  else
    printf(1, "-");
 2ca:	83 ec 08             	sub    $0x8,%esp
 2cd:	68 91 0b 00 00       	push   $0xb91
 2d2:	6a 01                	push   $0x1
 2d4:	e8 b0 04 00 00       	call   789 <printf>
 2d9:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2e3:	83 e0 04             	and    $0x4,%eax
 2e6:	84 c0                	test   %al,%al
 2e8:	74 14                	je     2fe <print_mode+0x1fd>
    printf(1, "r");
 2ea:	83 ec 08             	sub    $0x8,%esp
 2ed:	68 97 0b 00 00       	push   $0xb97
 2f2:	6a 01                	push   $0x1
 2f4:	e8 90 04 00 00       	call   789 <printf>
 2f9:	83 c4 10             	add    $0x10,%esp
 2fc:	eb 12                	jmp    310 <print_mode+0x20f>
  else
    printf(1, "-");
 2fe:	83 ec 08             	sub    $0x8,%esp
 301:	68 91 0b 00 00       	push   $0xb91
 306:	6a 01                	push   $0x1
 308:	e8 7c 04 00 00       	call   789 <printf>
 30d:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 317:	83 e0 02             	and    $0x2,%eax
 31a:	84 c0                	test   %al,%al
 31c:	74 14                	je     332 <print_mode+0x231>
    printf(1, "w");
 31e:	83 ec 08             	sub    $0x8,%esp
 321:	68 99 0b 00 00       	push   $0xb99
 326:	6a 01                	push   $0x1
 328:	e8 5c 04 00 00       	call   789 <printf>
 32d:	83 c4 10             	add    $0x10,%esp
 330:	eb 12                	jmp    344 <print_mode+0x243>
  else
    printf(1, "-");
 332:	83 ec 08             	sub    $0x8,%esp
 335:	68 91 0b 00 00       	push   $0xb91
 33a:	6a 01                	push   $0x1
 33c:	e8 48 04 00 00       	call   789 <printf>
 341:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 34b:	83 e0 01             	and    $0x1,%eax
 34e:	84 c0                	test   %al,%al
 350:	74 14                	je     366 <print_mode+0x265>
    printf(1, "x");
 352:	83 ec 08             	sub    $0x8,%esp
 355:	68 9d 0b 00 00       	push   $0xb9d
 35a:	6a 01                	push   $0x1
 35c:	e8 28 04 00 00       	call   789 <printf>
 361:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 364:	eb 13                	jmp    379 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 366:	83 ec 08             	sub    $0x8,%esp
 369:	68 91 0b 00 00       	push   $0xb91
 36e:	6a 01                	push   $0x1
 370:	e8 14 04 00 00       	call   789 <printf>
 375:	83 c4 10             	add    $0x10,%esp

  return;
 378:	90                   	nop
}
 379:	c9                   	leave  
 37a:	c3                   	ret    

0000037b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	57                   	push   %edi
 37f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 380:	8b 4d 08             	mov    0x8(%ebp),%ecx
 383:	8b 55 10             	mov    0x10(%ebp),%edx
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	89 cb                	mov    %ecx,%ebx
 38b:	89 df                	mov    %ebx,%edi
 38d:	89 d1                	mov    %edx,%ecx
 38f:	fc                   	cld    
 390:	f3 aa                	rep stos %al,%es:(%edi)
 392:	89 ca                	mov    %ecx,%edx
 394:	89 fb                	mov    %edi,%ebx
 396:	89 5d 08             	mov    %ebx,0x8(%ebp)
 399:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 39c:	90                   	nop
 39d:	5b                   	pop    %ebx
 39e:	5f                   	pop    %edi
 39f:	5d                   	pop    %ebp
 3a0:	c3                   	ret    

000003a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
 3a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3ad:	90                   	nop
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
 3b1:	8d 50 01             	lea    0x1(%eax),%edx
 3b4:	89 55 08             	mov    %edx,0x8(%ebp)
 3b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 3ba:	8d 4a 01             	lea    0x1(%edx),%ecx
 3bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3c0:	0f b6 12             	movzbl (%edx),%edx
 3c3:	88 10                	mov    %dl,(%eax)
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	84 c0                	test   %al,%al
 3ca:	75 e2                	jne    3ae <strcpy+0xd>
    ;
  return os;
 3cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cf:	c9                   	leave  
 3d0:	c3                   	ret    

000003d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3d4:	eb 08                	jmp    3de <strcmp+0xd>
    p++, q++;
 3d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3da:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	0f b6 00             	movzbl (%eax),%eax
 3e4:	84 c0                	test   %al,%al
 3e6:	74 10                	je     3f8 <strcmp+0x27>
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	0f b6 10             	movzbl (%eax),%edx
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	38 c2                	cmp    %al,%dl
 3f6:	74 de                	je     3d6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	0f b6 00             	movzbl (%eax),%eax
 3fe:	0f b6 d0             	movzbl %al,%edx
 401:	8b 45 0c             	mov    0xc(%ebp),%eax
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	0f b6 c0             	movzbl %al,%eax
 40a:	29 c2                	sub    %eax,%edx
 40c:	89 d0                	mov    %edx,%eax
}
 40e:	5d                   	pop    %ebp
 40f:	c3                   	ret    

00000410 <strlen>:

uint
strlen(char *s)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 416:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 41d:	eb 04                	jmp    423 <strlen+0x13>
 41f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 423:	8b 55 fc             	mov    -0x4(%ebp),%edx
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	01 d0                	add    %edx,%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	84 c0                	test   %al,%al
 430:	75 ed                	jne    41f <strlen+0xf>
    ;
  return n;
 432:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <memset>:

void*
memset(void *dst, int c, uint n)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 43a:	8b 45 10             	mov    0x10(%ebp),%eax
 43d:	50                   	push   %eax
 43e:	ff 75 0c             	pushl  0xc(%ebp)
 441:	ff 75 08             	pushl  0x8(%ebp)
 444:	e8 32 ff ff ff       	call   37b <stosb>
 449:	83 c4 0c             	add    $0xc,%esp
  return dst;
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <strchr>:

char*
strchr(const char *s, char c)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	83 ec 04             	sub    $0x4,%esp
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 45d:	eb 14                	jmp    473 <strchr+0x22>
    if(*s == c)
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	0f b6 00             	movzbl (%eax),%eax
 465:	3a 45 fc             	cmp    -0x4(%ebp),%al
 468:	75 05                	jne    46f <strchr+0x1e>
      return (char*)s;
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	eb 13                	jmp    482 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 46f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	0f b6 00             	movzbl (%eax),%eax
 479:	84 c0                	test   %al,%al
 47b:	75 e2                	jne    45f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 47d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 482:	c9                   	leave  
 483:	c3                   	ret    

00000484 <gets>:

char*
gets(char *buf, int max)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 48a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 491:	eb 42                	jmp    4d5 <gets+0x51>
    cc = read(0, &c, 1);
 493:	83 ec 04             	sub    $0x4,%esp
 496:	6a 01                	push   $0x1
 498:	8d 45 ef             	lea    -0x11(%ebp),%eax
 49b:	50                   	push   %eax
 49c:	6a 00                	push   $0x0
 49e:	e8 47 01 00 00       	call   5ea <read>
 4a3:	83 c4 10             	add    $0x10,%esp
 4a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ad:	7e 33                	jle    4e2 <gets+0x5e>
      break;
    buf[i++] = c;
 4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b2:	8d 50 01             	lea    0x1(%eax),%edx
 4b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b8:	89 c2                	mov    %eax,%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	01 c2                	add    %eax,%edx
 4bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c9:	3c 0a                	cmp    $0xa,%al
 4cb:	74 16                	je     4e3 <gets+0x5f>
 4cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4d1:	3c 0d                	cmp    $0xd,%al
 4d3:	74 0e                	je     4e3 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d8:	83 c0 01             	add    $0x1,%eax
 4db:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4de:	7c b3                	jl     493 <gets+0xf>
 4e0:	eb 01                	jmp    4e3 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4e2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	01 d0                	add    %edx,%eax
 4eb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f1:	c9                   	leave  
 4f2:	c3                   	ret    

000004f3 <stat>:

int
stat(char *n, struct stat *st)
{
 4f3:	55                   	push   %ebp
 4f4:	89 e5                	mov    %esp,%ebp
 4f6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f9:	83 ec 08             	sub    $0x8,%esp
 4fc:	6a 00                	push   $0x0
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 0c 01 00 00       	call   612 <open>
 506:	83 c4 10             	add    $0x10,%esp
 509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 50c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 510:	79 07                	jns    519 <stat+0x26>
    return -1;
 512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 517:	eb 25                	jmp    53e <stat+0x4b>
  r = fstat(fd, st);
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	ff 75 0c             	pushl  0xc(%ebp)
 51f:	ff 75 f4             	pushl  -0xc(%ebp)
 522:	e8 03 01 00 00       	call   62a <fstat>
 527:	83 c4 10             	add    $0x10,%esp
 52a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 52d:	83 ec 0c             	sub    $0xc,%esp
 530:	ff 75 f4             	pushl  -0xc(%ebp)
 533:	e8 c2 00 00 00       	call   5fa <close>
 538:	83 c4 10             	add    $0x10,%esp
  return r;
 53b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 53e:	c9                   	leave  
 53f:	c3                   	ret    

00000540 <atoi>:

int
atoi(const char *s)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 546:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 54d:	eb 25                	jmp    574 <atoi+0x34>
    n = n*10 + *s++ - '0';
 54f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 552:	89 d0                	mov    %edx,%eax
 554:	c1 e0 02             	shl    $0x2,%eax
 557:	01 d0                	add    %edx,%eax
 559:	01 c0                	add    %eax,%eax
 55b:	89 c1                	mov    %eax,%ecx
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	8d 50 01             	lea    0x1(%eax),%edx
 563:	89 55 08             	mov    %edx,0x8(%ebp)
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	01 c8                	add    %ecx,%eax
 56e:	83 e8 30             	sub    $0x30,%eax
 571:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	0f b6 00             	movzbl (%eax),%eax
 57a:	3c 2f                	cmp    $0x2f,%al
 57c:	7e 0a                	jle    588 <atoi+0x48>
 57e:	8b 45 08             	mov    0x8(%ebp),%eax
 581:	0f b6 00             	movzbl (%eax),%eax
 584:	3c 39                	cmp    $0x39,%al
 586:	7e c7                	jle    54f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 588:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 58b:	c9                   	leave  
 58c:	c3                   	ret    

0000058d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 58d:	55                   	push   %ebp
 58e:	89 e5                	mov    %esp,%ebp
 590:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 599:	8b 45 0c             	mov    0xc(%ebp),%eax
 59c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 59f:	eb 17                	jmp    5b8 <memmove+0x2b>
    *dst++ = *src++;
 5a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a4:	8d 50 01             	lea    0x1(%eax),%edx
 5a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 5b0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5b3:	0f b6 12             	movzbl (%edx),%edx
 5b6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b8:	8b 45 10             	mov    0x10(%ebp),%eax
 5bb:	8d 50 ff             	lea    -0x1(%eax),%edx
 5be:	89 55 10             	mov    %edx,0x10(%ebp)
 5c1:	85 c0                	test   %eax,%eax
 5c3:	7f dc                	jg     5a1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c8:	c9                   	leave  
 5c9:	c3                   	ret    

000005ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ca:	b8 01 00 00 00       	mov    $0x1,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <exit>:
SYSCALL(exit)
 5d2:	b8 02 00 00 00       	mov    $0x2,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <wait>:
SYSCALL(wait)
 5da:	b8 03 00 00 00       	mov    $0x3,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <pipe>:
SYSCALL(pipe)
 5e2:	b8 04 00 00 00       	mov    $0x4,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <read>:
SYSCALL(read)
 5ea:	b8 05 00 00 00       	mov    $0x5,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <write>:
SYSCALL(write)
 5f2:	b8 10 00 00 00       	mov    $0x10,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <close>:
SYSCALL(close)
 5fa:	b8 15 00 00 00       	mov    $0x15,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <kill>:
SYSCALL(kill)
 602:	b8 06 00 00 00       	mov    $0x6,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <exec>:
SYSCALL(exec)
 60a:	b8 07 00 00 00       	mov    $0x7,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <open>:
SYSCALL(open)
 612:	b8 0f 00 00 00       	mov    $0xf,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <mknod>:
SYSCALL(mknod)
 61a:	b8 11 00 00 00       	mov    $0x11,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <unlink>:
SYSCALL(unlink)
 622:	b8 12 00 00 00       	mov    $0x12,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <fstat>:
SYSCALL(fstat)
 62a:	b8 08 00 00 00       	mov    $0x8,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <link>:
SYSCALL(link)
 632:	b8 13 00 00 00       	mov    $0x13,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <mkdir>:
SYSCALL(mkdir)
 63a:	b8 14 00 00 00       	mov    $0x14,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <chdir>:
SYSCALL(chdir)
 642:	b8 09 00 00 00       	mov    $0x9,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <dup>:
SYSCALL(dup)
 64a:	b8 0a 00 00 00       	mov    $0xa,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <getpid>:
SYSCALL(getpid)
 652:	b8 0b 00 00 00       	mov    $0xb,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <sbrk>:
SYSCALL(sbrk)
 65a:	b8 0c 00 00 00       	mov    $0xc,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <sleep>:
SYSCALL(sleep)
 662:	b8 0d 00 00 00       	mov    $0xd,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <uptime>:
SYSCALL(uptime)
 66a:	b8 0e 00 00 00       	mov    $0xe,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <halt>:
SYSCALL(halt)
 672:	b8 16 00 00 00       	mov    $0x16,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <date>:
//Student Implementations 
SYSCALL(date)
 67a:	b8 17 00 00 00       	mov    $0x17,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <getuid>:

SYSCALL(getuid)
 682:	b8 18 00 00 00       	mov    $0x18,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <getgid>:
SYSCALL(getgid)
 68a:	b8 19 00 00 00       	mov    $0x19,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <getppid>:
SYSCALL(getppid)
 692:	b8 1a 00 00 00       	mov    $0x1a,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <setuid>:

SYSCALL(setuid)
 69a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <setgid>:
SYSCALL(setgid)
 6a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <getprocs>:
SYSCALL(getprocs)
 6aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b2:	55                   	push   %ebp
 6b3:	89 e5                	mov    %esp,%ebp
 6b5:	83 ec 18             	sub    $0x18,%esp
 6b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6be:	83 ec 04             	sub    $0x4,%esp
 6c1:	6a 01                	push   $0x1
 6c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6c6:	50                   	push   %eax
 6c7:	ff 75 08             	pushl  0x8(%ebp)
 6ca:	e8 23 ff ff ff       	call   5f2 <write>
 6cf:	83 c4 10             	add    $0x10,%esp
}
 6d2:	90                   	nop
 6d3:	c9                   	leave  
 6d4:	c3                   	ret    

000006d5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d5:	55                   	push   %ebp
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	53                   	push   %ebx
 6d9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6e7:	74 17                	je     700 <printint+0x2b>
 6e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ed:	79 11                	jns    700 <printint+0x2b>
    neg = 1;
 6ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f9:	f7 d8                	neg    %eax
 6fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6fe:	eb 06                	jmp    706 <printint+0x31>
  } else {
    x = xx;
 700:	8b 45 0c             	mov    0xc(%ebp),%eax
 703:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 706:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 70d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 710:	8d 41 01             	lea    0x1(%ecx),%eax
 713:	89 45 f4             	mov    %eax,-0xc(%ebp)
 716:	8b 5d 10             	mov    0x10(%ebp),%ebx
 719:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71c:	ba 00 00 00 00       	mov    $0x0,%edx
 721:	f7 f3                	div    %ebx
 723:	89 d0                	mov    %edx,%eax
 725:	0f b6 80 18 0e 00 00 	movzbl 0xe18(%eax),%eax
 72c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 730:	8b 5d 10             	mov    0x10(%ebp),%ebx
 733:	8b 45 ec             	mov    -0x14(%ebp),%eax
 736:	ba 00 00 00 00       	mov    $0x0,%edx
 73b:	f7 f3                	div    %ebx
 73d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 740:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 744:	75 c7                	jne    70d <printint+0x38>
  if(neg)
 746:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74a:	74 2d                	je     779 <printint+0xa4>
    buf[i++] = '-';
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	8d 50 01             	lea    0x1(%eax),%edx
 752:	89 55 f4             	mov    %edx,-0xc(%ebp)
 755:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 75a:	eb 1d                	jmp    779 <printint+0xa4>
    putc(fd, buf[i]);
 75c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 762:	01 d0                	add    %edx,%eax
 764:	0f b6 00             	movzbl (%eax),%eax
 767:	0f be c0             	movsbl %al,%eax
 76a:	83 ec 08             	sub    $0x8,%esp
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 3c ff ff ff       	call   6b2 <putc>
 776:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 779:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 77d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 781:	79 d9                	jns    75c <printint+0x87>
    putc(fd, buf[i]);
}
 783:	90                   	nop
 784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 787:	c9                   	leave  
 788:	c3                   	ret    

00000789 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 789:	55                   	push   %ebp
 78a:	89 e5                	mov    %esp,%ebp
 78c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 78f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 796:	8d 45 0c             	lea    0xc(%ebp),%eax
 799:	83 c0 04             	add    $0x4,%eax
 79c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 79f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a6:	e9 59 01 00 00       	jmp    904 <printf+0x17b>
    c = fmt[i] & 0xff;
 7ab:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	01 d0                	add    %edx,%eax
 7b3:	0f b6 00             	movzbl (%eax),%eax
 7b6:	0f be c0             	movsbl %al,%eax
 7b9:	25 ff 00 00 00       	and    $0xff,%eax
 7be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c5:	75 2c                	jne    7f3 <printf+0x6a>
      if(c == '%'){
 7c7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7cb:	75 0c                	jne    7d9 <printf+0x50>
        state = '%';
 7cd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d4:	e9 27 01 00 00       	jmp    900 <printf+0x177>
      } else {
        putc(fd, c);
 7d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7dc:	0f be c0             	movsbl %al,%eax
 7df:	83 ec 08             	sub    $0x8,%esp
 7e2:	50                   	push   %eax
 7e3:	ff 75 08             	pushl  0x8(%ebp)
 7e6:	e8 c7 fe ff ff       	call   6b2 <putc>
 7eb:	83 c4 10             	add    $0x10,%esp
 7ee:	e9 0d 01 00 00       	jmp    900 <printf+0x177>
      }
    } else if(state == '%'){
 7f3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7f7:	0f 85 03 01 00 00    	jne    900 <printf+0x177>
      if(c == 'd'){
 7fd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 801:	75 1e                	jne    821 <printf+0x98>
        printint(fd, *ap, 10, 1);
 803:	8b 45 e8             	mov    -0x18(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	6a 01                	push   $0x1
 80a:	6a 0a                	push   $0xa
 80c:	50                   	push   %eax
 80d:	ff 75 08             	pushl  0x8(%ebp)
 810:	e8 c0 fe ff ff       	call   6d5 <printint>
 815:	83 c4 10             	add    $0x10,%esp
        ap++;
 818:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81c:	e9 d8 00 00 00       	jmp    8f9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 821:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 825:	74 06                	je     82d <printf+0xa4>
 827:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 82b:	75 1e                	jne    84b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 82d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	6a 00                	push   $0x0
 834:	6a 10                	push   $0x10
 836:	50                   	push   %eax
 837:	ff 75 08             	pushl  0x8(%ebp)
 83a:	e8 96 fe ff ff       	call   6d5 <printint>
 83f:	83 c4 10             	add    $0x10,%esp
        ap++;
 842:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 846:	e9 ae 00 00 00       	jmp    8f9 <printf+0x170>
      } else if(c == 's'){
 84b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 84f:	75 43                	jne    894 <printf+0x10b>
        s = (char*)*ap;
 851:	8b 45 e8             	mov    -0x18(%ebp),%eax
 854:	8b 00                	mov    (%eax),%eax
 856:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 859:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 85d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 861:	75 25                	jne    888 <printf+0xff>
          s = "(null)";
 863:	c7 45 f4 9f 0b 00 00 	movl   $0xb9f,-0xc(%ebp)
        while(*s != 0){
 86a:	eb 1c                	jmp    888 <printf+0xff>
          putc(fd, *s);
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	0f b6 00             	movzbl (%eax),%eax
 872:	0f be c0             	movsbl %al,%eax
 875:	83 ec 08             	sub    $0x8,%esp
 878:	50                   	push   %eax
 879:	ff 75 08             	pushl  0x8(%ebp)
 87c:	e8 31 fe ff ff       	call   6b2 <putc>
 881:	83 c4 10             	add    $0x10,%esp
          s++;
 884:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	0f b6 00             	movzbl (%eax),%eax
 88e:	84 c0                	test   %al,%al
 890:	75 da                	jne    86c <printf+0xe3>
 892:	eb 65                	jmp    8f9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 894:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 898:	75 1d                	jne    8b7 <printf+0x12e>
        putc(fd, *ap);
 89a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89d:	8b 00                	mov    (%eax),%eax
 89f:	0f be c0             	movsbl %al,%eax
 8a2:	83 ec 08             	sub    $0x8,%esp
 8a5:	50                   	push   %eax
 8a6:	ff 75 08             	pushl  0x8(%ebp)
 8a9:	e8 04 fe ff ff       	call   6b2 <putc>
 8ae:	83 c4 10             	add    $0x10,%esp
        ap++;
 8b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b5:	eb 42                	jmp    8f9 <printf+0x170>
      } else if(c == '%'){
 8b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8bb:	75 17                	jne    8d4 <printf+0x14b>
        putc(fd, c);
 8bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c0:	0f be c0             	movsbl %al,%eax
 8c3:	83 ec 08             	sub    $0x8,%esp
 8c6:	50                   	push   %eax
 8c7:	ff 75 08             	pushl  0x8(%ebp)
 8ca:	e8 e3 fd ff ff       	call   6b2 <putc>
 8cf:	83 c4 10             	add    $0x10,%esp
 8d2:	eb 25                	jmp    8f9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d4:	83 ec 08             	sub    $0x8,%esp
 8d7:	6a 25                	push   $0x25
 8d9:	ff 75 08             	pushl  0x8(%ebp)
 8dc:	e8 d1 fd ff ff       	call   6b2 <putc>
 8e1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e7:	0f be c0             	movsbl %al,%eax
 8ea:	83 ec 08             	sub    $0x8,%esp
 8ed:	50                   	push   %eax
 8ee:	ff 75 08             	pushl  0x8(%ebp)
 8f1:	e8 bc fd ff ff       	call   6b2 <putc>
 8f6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 900:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 904:	8b 55 0c             	mov    0xc(%ebp),%edx
 907:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90a:	01 d0                	add    %edx,%eax
 90c:	0f b6 00             	movzbl (%eax),%eax
 90f:	84 c0                	test   %al,%al
 911:	0f 85 94 fe ff ff    	jne    7ab <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 917:	90                   	nop
 918:	c9                   	leave  
 919:	c3                   	ret    

0000091a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91a:	55                   	push   %ebp
 91b:	89 e5                	mov    %esp,%ebp
 91d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 920:	8b 45 08             	mov    0x8(%ebp),%eax
 923:	83 e8 08             	sub    $0x8,%eax
 926:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 929:	a1 34 0e 00 00       	mov    0xe34,%eax
 92e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 931:	eb 24                	jmp    957 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 933:	8b 45 fc             	mov    -0x4(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93b:	77 12                	ja     94f <free+0x35>
 93d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 940:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 943:	77 24                	ja     969 <free+0x4f>
 945:	8b 45 fc             	mov    -0x4(%ebp),%eax
 948:	8b 00                	mov    (%eax),%eax
 94a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94d:	77 1a                	ja     969 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 952:	8b 00                	mov    (%eax),%eax
 954:	89 45 fc             	mov    %eax,-0x4(%ebp)
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95d:	76 d4                	jbe    933 <free+0x19>
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 00                	mov    (%eax),%eax
 964:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 967:	76 ca                	jbe    933 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 969:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96c:	8b 40 04             	mov    0x4(%eax),%eax
 96f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 976:	8b 45 f8             	mov    -0x8(%ebp),%eax
 979:	01 c2                	add    %eax,%edx
 97b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97e:	8b 00                	mov    (%eax),%eax
 980:	39 c2                	cmp    %eax,%edx
 982:	75 24                	jne    9a8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 984:	8b 45 f8             	mov    -0x8(%ebp),%eax
 987:	8b 50 04             	mov    0x4(%eax),%edx
 98a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98d:	8b 00                	mov    (%eax),%eax
 98f:	8b 40 04             	mov    0x4(%eax),%eax
 992:	01 c2                	add    %eax,%edx
 994:	8b 45 f8             	mov    -0x8(%ebp),%eax
 997:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	8b 00                	mov    (%eax),%eax
 99f:	8b 10                	mov    (%eax),%edx
 9a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a4:	89 10                	mov    %edx,(%eax)
 9a6:	eb 0a                	jmp    9b2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ab:	8b 10                	mov    (%eax),%edx
 9ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b5:	8b 40 04             	mov    0x4(%eax),%eax
 9b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c2:	01 d0                	add    %edx,%eax
 9c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c7:	75 20                	jne    9e9 <free+0xcf>
    p->s.size += bp->s.size;
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	8b 50 04             	mov    0x4(%eax),%edx
 9cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d2:	8b 40 04             	mov    0x4(%eax),%eax
 9d5:	01 c2                	add    %eax,%edx
 9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e0:	8b 10                	mov    (%eax),%edx
 9e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e5:	89 10                	mov    %edx,(%eax)
 9e7:	eb 08                	jmp    9f1 <free+0xd7>
  } else
    p->s.ptr = bp;
 9e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f4:	a3 34 0e 00 00       	mov    %eax,0xe34
}
 9f9:	90                   	nop
 9fa:	c9                   	leave  
 9fb:	c3                   	ret    

000009fc <morecore>:

static Header*
morecore(uint nu)
{
 9fc:	55                   	push   %ebp
 9fd:	89 e5                	mov    %esp,%ebp
 9ff:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a02:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a09:	77 07                	ja     a12 <morecore+0x16>
    nu = 4096;
 a0b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a12:	8b 45 08             	mov    0x8(%ebp),%eax
 a15:	c1 e0 03             	shl    $0x3,%eax
 a18:	83 ec 0c             	sub    $0xc,%esp
 a1b:	50                   	push   %eax
 a1c:	e8 39 fc ff ff       	call   65a <sbrk>
 a21:	83 c4 10             	add    $0x10,%esp
 a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a27:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a2b:	75 07                	jne    a34 <morecore+0x38>
    return 0;
 a2d:	b8 00 00 00 00       	mov    $0x0,%eax
 a32:	eb 26                	jmp    a5a <morecore+0x5e>
  hp = (Header*)p;
 a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3d:	8b 55 08             	mov    0x8(%ebp),%edx
 a40:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a46:	83 c0 08             	add    $0x8,%eax
 a49:	83 ec 0c             	sub    $0xc,%esp
 a4c:	50                   	push   %eax
 a4d:	e8 c8 fe ff ff       	call   91a <free>
 a52:	83 c4 10             	add    $0x10,%esp
  return freep;
 a55:	a1 34 0e 00 00       	mov    0xe34,%eax
}
 a5a:	c9                   	leave  
 a5b:	c3                   	ret    

00000a5c <malloc>:

void*
malloc(uint nbytes)
{
 a5c:	55                   	push   %ebp
 a5d:	89 e5                	mov    %esp,%ebp
 a5f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a62:	8b 45 08             	mov    0x8(%ebp),%eax
 a65:	83 c0 07             	add    $0x7,%eax
 a68:	c1 e8 03             	shr    $0x3,%eax
 a6b:	83 c0 01             	add    $0x1,%eax
 a6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a71:	a1 34 0e 00 00       	mov    0xe34,%eax
 a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a7d:	75 23                	jne    aa2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a7f:	c7 45 f0 2c 0e 00 00 	movl   $0xe2c,-0x10(%ebp)
 a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a89:	a3 34 0e 00 00       	mov    %eax,0xe34
 a8e:	a1 34 0e 00 00       	mov    0xe34,%eax
 a93:	a3 2c 0e 00 00       	mov    %eax,0xe2c
    base.s.size = 0;
 a98:	c7 05 30 0e 00 00 00 	movl   $0x0,0xe30
 a9f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa5:	8b 00                	mov    (%eax),%eax
 aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aad:	8b 40 04             	mov    0x4(%eax),%eax
 ab0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab3:	72 4d                	jb     b02 <malloc+0xa6>
      if(p->s.size == nunits)
 ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 abe:	75 0c                	jne    acc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac3:	8b 10                	mov    (%eax),%edx
 ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac8:	89 10                	mov    %edx,(%eax)
 aca:	eb 26                	jmp    af2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acf:	8b 40 04             	mov    0x4(%eax),%eax
 ad2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ad5:	89 c2                	mov    %eax,%edx
 ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ada:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	8b 40 04             	mov    0x4(%eax),%eax
 ae3:	c1 e0 03             	shl    $0x3,%eax
 ae6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aec:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aef:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af5:	a3 34 0e 00 00       	mov    %eax,0xe34
      return (void*)(p + 1);
 afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afd:	83 c0 08             	add    $0x8,%eax
 b00:	eb 3b                	jmp    b3d <malloc+0xe1>
    }
    if(p == freep)
 b02:	a1 34 0e 00 00       	mov    0xe34,%eax
 b07:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b0a:	75 1e                	jne    b2a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b0c:	83 ec 0c             	sub    $0xc,%esp
 b0f:	ff 75 ec             	pushl  -0x14(%ebp)
 b12:	e8 e5 fe ff ff       	call   9fc <morecore>
 b17:	83 c4 10             	add    $0x10,%esp
 b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b21:	75 07                	jne    b2a <malloc+0xce>
        return 0;
 b23:	b8 00 00 00 00       	mov    $0x0,%eax
 b28:	eb 13                	jmp    b3d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b33:	8b 00                	mov    (%eax),%eax
 b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b38:	e9 6d ff ff ff       	jmp    aaa <malloc+0x4e>
}
 b3d:	c9                   	leave  
 b3e:	c3                   	ret    
