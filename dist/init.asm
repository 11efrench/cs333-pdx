
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
  16:	68 5a 0b 00 00       	push   $0xb5a
  1b:	e8 f2 05 00 00       	call   612 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 5a 0b 00 00       	push   $0xb5a
  33:	e8 e2 05 00 00       	call   61a <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 5a 0b 00 00       	push   $0xb5a
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
  6a:	68 62 0b 00 00       	push   $0xb62
  6f:	6a 01                	push   $0x1
  71:	e8 2b 07 00 00       	call   7a1 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 4c 05 00 00       	call   5ca <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 75 0b 00 00       	push   $0xb75
  8f:	6a 01                	push   $0x1
  91:	e8 0b 07 00 00       	call   7a1 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 34 05 00 00       	call   5d2 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 28 0e 00 00       	push   $0xe28
  ac:	68 57 0b 00 00       	push   $0xb57
  b1:	e8 54 05 00 00       	call   60a <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 88 0b 00 00       	push   $0xb88
  c1:	6a 01                	push   $0x1
  c3:	e8 d9 06 00 00       	call   7a1 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 02 05 00 00       	call   5d2 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 9e 0b 00 00       	push   $0xb9e
  d8:	6a 01                	push   $0x1
  da:	e8 c2 06 00 00       	call   7a1 <printf>
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
 120:	68 a7 0b 00 00       	push   $0xba7
 125:	6a 01                	push   $0x1
 127:	e8 75 06 00 00       	call   7a1 <printf>
 12c:	83 c4 10             	add    $0x10,%esp
 12f:	eb 3a                	jmp    16b <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 131:	83 ec 08             	sub    $0x8,%esp
 134:	68 a9 0b 00 00       	push   $0xba9
 139:	6a 01                	push   $0x1
 13b:	e8 61 06 00 00       	call   7a1 <printf>
 140:	83 c4 10             	add    $0x10,%esp
 143:	eb 26                	jmp    16b <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 145:	83 ec 08             	sub    $0x8,%esp
 148:	68 ab 0b 00 00       	push   $0xbab
 14d:	6a 01                	push   $0x1
 14f:	e8 4d 06 00 00       	call   7a1 <printf>
 154:	83 c4 10             	add    $0x10,%esp
 157:	eb 12                	jmp    16b <print_mode+0x6a>
    default: printf(1, "?");
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	68 ad 0b 00 00       	push   $0xbad
 161:	6a 01                	push   $0x1
 163:	e8 39 06 00 00       	call   7a1 <printf>
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
 17c:	68 af 0b 00 00       	push   $0xbaf
 181:	6a 01                	push   $0x1
 183:	e8 19 06 00 00       	call   7a1 <printf>
 188:	83 c4 10             	add    $0x10,%esp
 18b:	eb 12                	jmp    19f <print_mode+0x9e>
  else
    printf(1, "-");
 18d:	83 ec 08             	sub    $0x8,%esp
 190:	68 a9 0b 00 00       	push   $0xba9
 195:	6a 01                	push   $0x1
 197:	e8 05 06 00 00       	call   7a1 <printf>
 19c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1a6:	83 e0 80             	and    $0xffffff80,%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	74 14                	je     1c1 <print_mode+0xc0>
    printf(1, "w");
 1ad:	83 ec 08             	sub    $0x8,%esp
 1b0:	68 b1 0b 00 00       	push   $0xbb1
 1b5:	6a 01                	push   $0x1
 1b7:	e8 e5 05 00 00       	call   7a1 <printf>
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	eb 12                	jmp    1d3 <print_mode+0xd2>
  else
    printf(1, "-");
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	68 a9 0b 00 00       	push   $0xba9
 1c9:	6a 01                	push   $0x1
 1cb:	e8 d1 05 00 00       	call   7a1 <printf>
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
 1fb:	68 b3 0b 00 00       	push   $0xbb3
 200:	6a 01                	push   $0x1
 202:	e8 9a 05 00 00       	call   7a1 <printf>
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
 21d:	68 b5 0b 00 00       	push   $0xbb5
 222:	6a 01                	push   $0x1
 224:	e8 78 05 00 00       	call   7a1 <printf>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	eb 12                	jmp    240 <print_mode+0x13f>
  else
    printf(1, "-");
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	68 a9 0b 00 00       	push   $0xba9
 236:	6a 01                	push   $0x1
 238:	e8 64 05 00 00       	call   7a1 <printf>
 23d:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 247:	83 e0 20             	and    $0x20,%eax
 24a:	84 c0                	test   %al,%al
 24c:	74 14                	je     262 <print_mode+0x161>
    printf(1, "r");
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	68 af 0b 00 00       	push   $0xbaf
 256:	6a 01                	push   $0x1
 258:	e8 44 05 00 00       	call   7a1 <printf>
 25d:	83 c4 10             	add    $0x10,%esp
 260:	eb 12                	jmp    274 <print_mode+0x173>
  else
    printf(1, "-");
 262:	83 ec 08             	sub    $0x8,%esp
 265:	68 a9 0b 00 00       	push   $0xba9
 26a:	6a 01                	push   $0x1
 26c:	e8 30 05 00 00       	call   7a1 <printf>
 271:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 27b:	83 e0 10             	and    $0x10,%eax
 27e:	84 c0                	test   %al,%al
 280:	74 14                	je     296 <print_mode+0x195>
    printf(1, "w");
 282:	83 ec 08             	sub    $0x8,%esp
 285:	68 b1 0b 00 00       	push   $0xbb1
 28a:	6a 01                	push   $0x1
 28c:	e8 10 05 00 00       	call   7a1 <printf>
 291:	83 c4 10             	add    $0x10,%esp
 294:	eb 12                	jmp    2a8 <print_mode+0x1a7>
  else
    printf(1, "-");
 296:	83 ec 08             	sub    $0x8,%esp
 299:	68 a9 0b 00 00       	push   $0xba9
 29e:	6a 01                	push   $0x1
 2a0:	e8 fc 04 00 00       	call   7a1 <printf>
 2a5:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2af:	83 e0 08             	and    $0x8,%eax
 2b2:	84 c0                	test   %al,%al
 2b4:	74 14                	je     2ca <print_mode+0x1c9>
    printf(1, "x");
 2b6:	83 ec 08             	sub    $0x8,%esp
 2b9:	68 b5 0b 00 00       	push   $0xbb5
 2be:	6a 01                	push   $0x1
 2c0:	e8 dc 04 00 00       	call   7a1 <printf>
 2c5:	83 c4 10             	add    $0x10,%esp
 2c8:	eb 12                	jmp    2dc <print_mode+0x1db>
  else
    printf(1, "-");
 2ca:	83 ec 08             	sub    $0x8,%esp
 2cd:	68 a9 0b 00 00       	push   $0xba9
 2d2:	6a 01                	push   $0x1
 2d4:	e8 c8 04 00 00       	call   7a1 <printf>
 2d9:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2e3:	83 e0 04             	and    $0x4,%eax
 2e6:	84 c0                	test   %al,%al
 2e8:	74 14                	je     2fe <print_mode+0x1fd>
    printf(1, "r");
 2ea:	83 ec 08             	sub    $0x8,%esp
 2ed:	68 af 0b 00 00       	push   $0xbaf
 2f2:	6a 01                	push   $0x1
 2f4:	e8 a8 04 00 00       	call   7a1 <printf>
 2f9:	83 c4 10             	add    $0x10,%esp
 2fc:	eb 12                	jmp    310 <print_mode+0x20f>
  else
    printf(1, "-");
 2fe:	83 ec 08             	sub    $0x8,%esp
 301:	68 a9 0b 00 00       	push   $0xba9
 306:	6a 01                	push   $0x1
 308:	e8 94 04 00 00       	call   7a1 <printf>
 30d:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 317:	83 e0 02             	and    $0x2,%eax
 31a:	84 c0                	test   %al,%al
 31c:	74 14                	je     332 <print_mode+0x231>
    printf(1, "w");
 31e:	83 ec 08             	sub    $0x8,%esp
 321:	68 b1 0b 00 00       	push   $0xbb1
 326:	6a 01                	push   $0x1
 328:	e8 74 04 00 00       	call   7a1 <printf>
 32d:	83 c4 10             	add    $0x10,%esp
 330:	eb 12                	jmp    344 <print_mode+0x243>
  else
    printf(1, "-");
 332:	83 ec 08             	sub    $0x8,%esp
 335:	68 a9 0b 00 00       	push   $0xba9
 33a:	6a 01                	push   $0x1
 33c:	e8 60 04 00 00       	call   7a1 <printf>
 341:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 34b:	83 e0 01             	and    $0x1,%eax
 34e:	84 c0                	test   %al,%al
 350:	74 14                	je     366 <print_mode+0x265>
    printf(1, "x");
 352:	83 ec 08             	sub    $0x8,%esp
 355:	68 b5 0b 00 00       	push   $0xbb5
 35a:	6a 01                	push   $0x1
 35c:	e8 40 04 00 00       	call   7a1 <printf>
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
 369:	68 a9 0b 00 00       	push   $0xba9
 36e:	6a 01                	push   $0x1
 370:	e8 2c 04 00 00       	call   7a1 <printf>
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

000006b2 <chown>:

SYSCALL(chown)
 6b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <chgrp>:
SYSCALL(chgrp)
 6ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <chmod>:
SYSCALL(chmod)
 6c2:	b8 20 00 00 00       	mov    $0x20,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6ca:	55                   	push   %ebp
 6cb:	89 e5                	mov    %esp,%ebp
 6cd:	83 ec 18             	sub    $0x18,%esp
 6d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6d6:	83 ec 04             	sub    $0x4,%esp
 6d9:	6a 01                	push   $0x1
 6db:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6de:	50                   	push   %eax
 6df:	ff 75 08             	pushl  0x8(%ebp)
 6e2:	e8 0b ff ff ff       	call   5f2 <write>
 6e7:	83 c4 10             	add    $0x10,%esp
}
 6ea:	90                   	nop
 6eb:	c9                   	leave  
 6ec:	c3                   	ret    

000006ed <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ed:	55                   	push   %ebp
 6ee:	89 e5                	mov    %esp,%ebp
 6f0:	53                   	push   %ebx
 6f1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6fb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ff:	74 17                	je     718 <printint+0x2b>
 701:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 705:	79 11                	jns    718 <printint+0x2b>
    neg = 1;
 707:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 70e:	8b 45 0c             	mov    0xc(%ebp),%eax
 711:	f7 d8                	neg    %eax
 713:	89 45 ec             	mov    %eax,-0x14(%ebp)
 716:	eb 06                	jmp    71e <printint+0x31>
  } else {
    x = xx;
 718:	8b 45 0c             	mov    0xc(%ebp),%eax
 71b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 71e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 725:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 728:	8d 41 01             	lea    0x1(%ecx),%eax
 72b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 72e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 731:	8b 45 ec             	mov    -0x14(%ebp),%eax
 734:	ba 00 00 00 00       	mov    $0x0,%edx
 739:	f7 f3                	div    %ebx
 73b:	89 d0                	mov    %edx,%eax
 73d:	0f b6 80 30 0e 00 00 	movzbl 0xe30(%eax),%eax
 744:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 748:	8b 5d 10             	mov    0x10(%ebp),%ebx
 74b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 74e:	ba 00 00 00 00       	mov    $0x0,%edx
 753:	f7 f3                	div    %ebx
 755:	89 45 ec             	mov    %eax,-0x14(%ebp)
 758:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 75c:	75 c7                	jne    725 <printint+0x38>
  if(neg)
 75e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 762:	74 2d                	je     791 <printint+0xa4>
    buf[i++] = '-';
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8d 50 01             	lea    0x1(%eax),%edx
 76a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 76d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 772:	eb 1d                	jmp    791 <printint+0xa4>
    putc(fd, buf[i]);
 774:	8d 55 dc             	lea    -0x24(%ebp),%edx
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	01 d0                	add    %edx,%eax
 77c:	0f b6 00             	movzbl (%eax),%eax
 77f:	0f be c0             	movsbl %al,%eax
 782:	83 ec 08             	sub    $0x8,%esp
 785:	50                   	push   %eax
 786:	ff 75 08             	pushl  0x8(%ebp)
 789:	e8 3c ff ff ff       	call   6ca <putc>
 78e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 791:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 799:	79 d9                	jns    774 <printint+0x87>
    putc(fd, buf[i]);
}
 79b:	90                   	nop
 79c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 79f:	c9                   	leave  
 7a0:	c3                   	ret    

000007a1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7ae:	8d 45 0c             	lea    0xc(%ebp),%eax
 7b1:	83 c0 04             	add    $0x4,%eax
 7b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7be:	e9 59 01 00 00       	jmp    91c <printf+0x17b>
    c = fmt[i] & 0xff;
 7c3:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c9:	01 d0                	add    %edx,%eax
 7cb:	0f b6 00             	movzbl (%eax),%eax
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	25 ff 00 00 00       	and    $0xff,%eax
 7d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7dd:	75 2c                	jne    80b <printf+0x6a>
      if(c == '%'){
 7df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e3:	75 0c                	jne    7f1 <printf+0x50>
        state = '%';
 7e5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7ec:	e9 27 01 00 00       	jmp    918 <printf+0x177>
      } else {
        putc(fd, c);
 7f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f4:	0f be c0             	movsbl %al,%eax
 7f7:	83 ec 08             	sub    $0x8,%esp
 7fa:	50                   	push   %eax
 7fb:	ff 75 08             	pushl  0x8(%ebp)
 7fe:	e8 c7 fe ff ff       	call   6ca <putc>
 803:	83 c4 10             	add    $0x10,%esp
 806:	e9 0d 01 00 00       	jmp    918 <printf+0x177>
      }
    } else if(state == '%'){
 80b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 80f:	0f 85 03 01 00 00    	jne    918 <printf+0x177>
      if(c == 'd'){
 815:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 819:	75 1e                	jne    839 <printf+0x98>
        printint(fd, *ap, 10, 1);
 81b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81e:	8b 00                	mov    (%eax),%eax
 820:	6a 01                	push   $0x1
 822:	6a 0a                	push   $0xa
 824:	50                   	push   %eax
 825:	ff 75 08             	pushl  0x8(%ebp)
 828:	e8 c0 fe ff ff       	call   6ed <printint>
 82d:	83 c4 10             	add    $0x10,%esp
        ap++;
 830:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 834:	e9 d8 00 00 00       	jmp    911 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 839:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 83d:	74 06                	je     845 <printf+0xa4>
 83f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 843:	75 1e                	jne    863 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 845:	8b 45 e8             	mov    -0x18(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	6a 00                	push   $0x0
 84c:	6a 10                	push   $0x10
 84e:	50                   	push   %eax
 84f:	ff 75 08             	pushl  0x8(%ebp)
 852:	e8 96 fe ff ff       	call   6ed <printint>
 857:	83 c4 10             	add    $0x10,%esp
        ap++;
 85a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 85e:	e9 ae 00 00 00       	jmp    911 <printf+0x170>
      } else if(c == 's'){
 863:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 867:	75 43                	jne    8ac <printf+0x10b>
        s = (char*)*ap;
 869:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 871:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 879:	75 25                	jne    8a0 <printf+0xff>
          s = "(null)";
 87b:	c7 45 f4 b7 0b 00 00 	movl   $0xbb7,-0xc(%ebp)
        while(*s != 0){
 882:	eb 1c                	jmp    8a0 <printf+0xff>
          putc(fd, *s);
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	0f b6 00             	movzbl (%eax),%eax
 88a:	0f be c0             	movsbl %al,%eax
 88d:	83 ec 08             	sub    $0x8,%esp
 890:	50                   	push   %eax
 891:	ff 75 08             	pushl  0x8(%ebp)
 894:	e8 31 fe ff ff       	call   6ca <putc>
 899:	83 c4 10             	add    $0x10,%esp
          s++;
 89c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	0f b6 00             	movzbl (%eax),%eax
 8a6:	84 c0                	test   %al,%al
 8a8:	75 da                	jne    884 <printf+0xe3>
 8aa:	eb 65                	jmp    911 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8ac:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8b0:	75 1d                	jne    8cf <printf+0x12e>
        putc(fd, *ap);
 8b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b5:	8b 00                	mov    (%eax),%eax
 8b7:	0f be c0             	movsbl %al,%eax
 8ba:	83 ec 08             	sub    $0x8,%esp
 8bd:	50                   	push   %eax
 8be:	ff 75 08             	pushl  0x8(%ebp)
 8c1:	e8 04 fe ff ff       	call   6ca <putc>
 8c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 8c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8cd:	eb 42                	jmp    911 <printf+0x170>
      } else if(c == '%'){
 8cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8d3:	75 17                	jne    8ec <printf+0x14b>
        putc(fd, c);
 8d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d8:	0f be c0             	movsbl %al,%eax
 8db:	83 ec 08             	sub    $0x8,%esp
 8de:	50                   	push   %eax
 8df:	ff 75 08             	pushl  0x8(%ebp)
 8e2:	e8 e3 fd ff ff       	call   6ca <putc>
 8e7:	83 c4 10             	add    $0x10,%esp
 8ea:	eb 25                	jmp    911 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ec:	83 ec 08             	sub    $0x8,%esp
 8ef:	6a 25                	push   $0x25
 8f1:	ff 75 08             	pushl  0x8(%ebp)
 8f4:	e8 d1 fd ff ff       	call   6ca <putc>
 8f9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ff:	0f be c0             	movsbl %al,%eax
 902:	83 ec 08             	sub    $0x8,%esp
 905:	50                   	push   %eax
 906:	ff 75 08             	pushl  0x8(%ebp)
 909:	e8 bc fd ff ff       	call   6ca <putc>
 90e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 911:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 918:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 91c:	8b 55 0c             	mov    0xc(%ebp),%edx
 91f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 922:	01 d0                	add    %edx,%eax
 924:	0f b6 00             	movzbl (%eax),%eax
 927:	84 c0                	test   %al,%al
 929:	0f 85 94 fe ff ff    	jne    7c3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 92f:	90                   	nop
 930:	c9                   	leave  
 931:	c3                   	ret    

00000932 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 932:	55                   	push   %ebp
 933:	89 e5                	mov    %esp,%ebp
 935:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 938:	8b 45 08             	mov    0x8(%ebp),%eax
 93b:	83 e8 08             	sub    $0x8,%eax
 93e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 941:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 946:	89 45 fc             	mov    %eax,-0x4(%ebp)
 949:	eb 24                	jmp    96f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 953:	77 12                	ja     967 <free+0x35>
 955:	8b 45 f8             	mov    -0x8(%ebp),%eax
 958:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95b:	77 24                	ja     981 <free+0x4f>
 95d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 960:	8b 00                	mov    (%eax),%eax
 962:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 965:	77 1a                	ja     981 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	8b 00                	mov    (%eax),%eax
 96c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 96f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 972:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 975:	76 d4                	jbe    94b <free+0x19>
 977:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97a:	8b 00                	mov    (%eax),%eax
 97c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 97f:	76 ca                	jbe    94b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 981:	8b 45 f8             	mov    -0x8(%ebp),%eax
 984:	8b 40 04             	mov    0x4(%eax),%eax
 987:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 98e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 991:	01 c2                	add    %eax,%edx
 993:	8b 45 fc             	mov    -0x4(%ebp),%eax
 996:	8b 00                	mov    (%eax),%eax
 998:	39 c2                	cmp    %eax,%edx
 99a:	75 24                	jne    9c0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 99c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99f:	8b 50 04             	mov    0x4(%eax),%edx
 9a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a5:	8b 00                	mov    (%eax),%eax
 9a7:	8b 40 04             	mov    0x4(%eax),%eax
 9aa:	01 c2                	add    %eax,%edx
 9ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9af:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b5:	8b 00                	mov    (%eax),%eax
 9b7:	8b 10                	mov    (%eax),%edx
 9b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bc:	89 10                	mov    %edx,(%eax)
 9be:	eb 0a                	jmp    9ca <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c3:	8b 10                	mov    (%eax),%edx
 9c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cd:	8b 40 04             	mov    0x4(%eax),%eax
 9d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9da:	01 d0                	add    %edx,%eax
 9dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9df:	75 20                	jne    a01 <free+0xcf>
    p->s.size += bp->s.size;
 9e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e4:	8b 50 04             	mov    0x4(%eax),%edx
 9e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ea:	8b 40 04             	mov    0x4(%eax),%eax
 9ed:	01 c2                	add    %eax,%edx
 9ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f8:	8b 10                	mov    (%eax),%edx
 9fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fd:	89 10                	mov    %edx,(%eax)
 9ff:	eb 08                	jmp    a09 <free+0xd7>
  } else
    p->s.ptr = bp;
 a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a04:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a07:	89 10                	mov    %edx,(%eax)
  freep = p;
 a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0c:	a3 4c 0e 00 00       	mov    %eax,0xe4c
}
 a11:	90                   	nop
 a12:	c9                   	leave  
 a13:	c3                   	ret    

00000a14 <morecore>:

static Header*
morecore(uint nu)
{
 a14:	55                   	push   %ebp
 a15:	89 e5                	mov    %esp,%ebp
 a17:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a1a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a21:	77 07                	ja     a2a <morecore+0x16>
    nu = 4096;
 a23:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a2a:	8b 45 08             	mov    0x8(%ebp),%eax
 a2d:	c1 e0 03             	shl    $0x3,%eax
 a30:	83 ec 0c             	sub    $0xc,%esp
 a33:	50                   	push   %eax
 a34:	e8 21 fc ff ff       	call   65a <sbrk>
 a39:	83 c4 10             	add    $0x10,%esp
 a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a3f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a43:	75 07                	jne    a4c <morecore+0x38>
    return 0;
 a45:	b8 00 00 00 00       	mov    $0x0,%eax
 a4a:	eb 26                	jmp    a72 <morecore+0x5e>
  hp = (Header*)p;
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a55:	8b 55 08             	mov    0x8(%ebp),%edx
 a58:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5e:	83 c0 08             	add    $0x8,%eax
 a61:	83 ec 0c             	sub    $0xc,%esp
 a64:	50                   	push   %eax
 a65:	e8 c8 fe ff ff       	call   932 <free>
 a6a:	83 c4 10             	add    $0x10,%esp
  return freep;
 a6d:	a1 4c 0e 00 00       	mov    0xe4c,%eax
}
 a72:	c9                   	leave  
 a73:	c3                   	ret    

00000a74 <malloc>:

void*
malloc(uint nbytes)
{
 a74:	55                   	push   %ebp
 a75:	89 e5                	mov    %esp,%ebp
 a77:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a7a:	8b 45 08             	mov    0x8(%ebp),%eax
 a7d:	83 c0 07             	add    $0x7,%eax
 a80:	c1 e8 03             	shr    $0x3,%eax
 a83:	83 c0 01             	add    $0x1,%eax
 a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a89:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a95:	75 23                	jne    aba <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a97:	c7 45 f0 44 0e 00 00 	movl   $0xe44,-0x10(%ebp)
 a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa1:	a3 4c 0e 00 00       	mov    %eax,0xe4c
 aa6:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 aab:	a3 44 0e 00 00       	mov    %eax,0xe44
    base.s.size = 0;
 ab0:	c7 05 48 0e 00 00 00 	movl   $0x0,0xe48
 ab7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abd:	8b 00                	mov    (%eax),%eax
 abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	8b 40 04             	mov    0x4(%eax),%eax
 ac8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 acb:	72 4d                	jb     b1a <malloc+0xa6>
      if(p->s.size == nunits)
 acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad0:	8b 40 04             	mov    0x4(%eax),%eax
 ad3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ad6:	75 0c                	jne    ae4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	8b 10                	mov    (%eax),%edx
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	89 10                	mov    %edx,(%eax)
 ae2:	eb 26                	jmp    b0a <malloc+0x96>
      else {
        p->s.size -= nunits;
 ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae7:	8b 40 04             	mov    0x4(%eax),%eax
 aea:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aed:	89 c2                	mov    %eax,%edx
 aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	8b 40 04             	mov    0x4(%eax),%eax
 afb:	c1 e0 03             	shl    $0x3,%eax
 afe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b07:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0d:	a3 4c 0e 00 00       	mov    %eax,0xe4c
      return (void*)(p + 1);
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	83 c0 08             	add    $0x8,%eax
 b18:	eb 3b                	jmp    b55 <malloc+0xe1>
    }
    if(p == freep)
 b1a:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 b1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b22:	75 1e                	jne    b42 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b24:	83 ec 0c             	sub    $0xc,%esp
 b27:	ff 75 ec             	pushl  -0x14(%ebp)
 b2a:	e8 e5 fe ff ff       	call   a14 <morecore>
 b2f:	83 c4 10             	add    $0x10,%esp
 b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b39:	75 07                	jne    b42 <malloc+0xce>
        return 0;
 b3b:	b8 00 00 00 00       	mov    $0x0,%eax
 b40:	eb 13                	jmp    b55 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4b:	8b 00                	mov    (%eax),%eax
 b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b50:	e9 6d ff ff ff       	jmp    ac2 <malloc+0x4e>
}
 b55:	c9                   	leave  
 b56:	c3                   	ret    
