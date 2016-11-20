
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 df 04 00 00       	call   4f5 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 69 05 00 00       	call   58d <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 d1 04 00 00       	call   4fd <exit>

0000002c <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  32:	8b 45 08             	mov    0x8(%ebp),%eax
  35:	0f b7 00             	movzwl (%eax),%eax
  38:	98                   	cwtl   
  39:	83 f8 02             	cmp    $0x2,%eax
  3c:	74 1e                	je     5c <print_mode+0x30>
  3e:	83 f8 03             	cmp    $0x3,%eax
  41:	74 2d                	je     70 <print_mode+0x44>
  43:	83 f8 01             	cmp    $0x1,%eax
  46:	75 3c                	jne    84 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 6a 0a 00 00       	push   $0xa6a
  50:	6a 01                	push   $0x1
  52:	e8 5d 06 00 00       	call   6b4 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb 3a                	jmp    96 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 6c 0a 00 00       	push   $0xa6c
  64:	6a 01                	push   $0x1
  66:	e8 49 06 00 00       	call   6b4 <printf>
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	eb 26                	jmp    96 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  70:	83 ec 08             	sub    $0x8,%esp
  73:	68 6e 0a 00 00       	push   $0xa6e
  78:	6a 01                	push   $0x1
  7a:	e8 35 06 00 00       	call   6b4 <printf>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	eb 12                	jmp    96 <print_mode+0x6a>
    default: printf(1, "?");
  84:	83 ec 08             	sub    $0x8,%esp
  87:	68 70 0a 00 00       	push   $0xa70
  8c:	6a 01                	push   $0x1
  8e:	e8 21 06 00 00       	call   6b4 <printf>
  93:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  9d:	83 e0 01             	and    $0x1,%eax
  a0:	84 c0                	test   %al,%al
  a2:	74 14                	je     b8 <print_mode+0x8c>
    printf(1, "r");
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 72 0a 00 00       	push   $0xa72
  ac:	6a 01                	push   $0x1
  ae:	e8 01 06 00 00       	call   6b4 <printf>
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	eb 12                	jmp    ca <print_mode+0x9e>
  else
    printf(1, "-");
  b8:	83 ec 08             	sub    $0x8,%esp
  bb:	68 6c 0a 00 00       	push   $0xa6c
  c0:	6a 01                	push   $0x1
  c2:	e8 ed 05 00 00       	call   6b4 <printf>
  c7:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  d1:	83 e0 80             	and    $0xffffff80,%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 14                	je     ec <print_mode+0xc0>
    printf(1, "w");
  d8:	83 ec 08             	sub    $0x8,%esp
  db:	68 74 0a 00 00       	push   $0xa74
  e0:	6a 01                	push   $0x1
  e2:	e8 cd 05 00 00       	call   6b4 <printf>
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	eb 12                	jmp    fe <print_mode+0xd2>
  else
    printf(1, "-");
  ec:	83 ec 08             	sub    $0x8,%esp
  ef:	68 6c 0a 00 00       	push   $0xa6c
  f4:	6a 01                	push   $0x1
  f6:	e8 b9 05 00 00       	call   6b4 <printf>
  fb:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  fe:	8b 45 08             	mov    0x8(%ebp),%eax
 101:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 105:	c0 e8 06             	shr    $0x6,%al
 108:	83 e0 01             	and    $0x1,%eax
 10b:	0f b6 d0             	movzbl %al,%edx
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 115:	d0 e8                	shr    %al
 117:	83 e0 01             	and    $0x1,%eax
 11a:	0f b6 c0             	movzbl %al,%eax
 11d:	21 d0                	and    %edx,%eax
 11f:	85 c0                	test   %eax,%eax
 121:	74 14                	je     137 <print_mode+0x10b>
    printf(1, "S");
 123:	83 ec 08             	sub    $0x8,%esp
 126:	68 76 0a 00 00       	push   $0xa76
 12b:	6a 01                	push   $0x1
 12d:	e8 82 05 00 00       	call   6b4 <printf>
 132:	83 c4 10             	add    $0x10,%esp
 135:	eb 34                	jmp    16b <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 13e:	83 e0 40             	and    $0x40,%eax
 141:	84 c0                	test   %al,%al
 143:	74 14                	je     159 <print_mode+0x12d>
    printf(1, "x");
 145:	83 ec 08             	sub    $0x8,%esp
 148:	68 78 0a 00 00       	push   $0xa78
 14d:	6a 01                	push   $0x1
 14f:	e8 60 05 00 00       	call   6b4 <printf>
 154:	83 c4 10             	add    $0x10,%esp
 157:	eb 12                	jmp    16b <print_mode+0x13f>
  else
    printf(1, "-");
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	68 6c 0a 00 00       	push   $0xa6c
 161:	6a 01                	push   $0x1
 163:	e8 4c 05 00 00       	call   6b4 <printf>
 168:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 172:	83 e0 20             	and    $0x20,%eax
 175:	84 c0                	test   %al,%al
 177:	74 14                	je     18d <print_mode+0x161>
    printf(1, "r");
 179:	83 ec 08             	sub    $0x8,%esp
 17c:	68 72 0a 00 00       	push   $0xa72
 181:	6a 01                	push   $0x1
 183:	e8 2c 05 00 00       	call   6b4 <printf>
 188:	83 c4 10             	add    $0x10,%esp
 18b:	eb 12                	jmp    19f <print_mode+0x173>
  else
    printf(1, "-");
 18d:	83 ec 08             	sub    $0x8,%esp
 190:	68 6c 0a 00 00       	push   $0xa6c
 195:	6a 01                	push   $0x1
 197:	e8 18 05 00 00       	call   6b4 <printf>
 19c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1a6:	83 e0 10             	and    $0x10,%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	74 14                	je     1c1 <print_mode+0x195>
    printf(1, "w");
 1ad:	83 ec 08             	sub    $0x8,%esp
 1b0:	68 74 0a 00 00       	push   $0xa74
 1b5:	6a 01                	push   $0x1
 1b7:	e8 f8 04 00 00       	call   6b4 <printf>
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	eb 12                	jmp    1d3 <print_mode+0x1a7>
  else
    printf(1, "-");
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	68 6c 0a 00 00       	push   $0xa6c
 1c9:	6a 01                	push   $0x1
 1cb:	e8 e4 04 00 00       	call   6b4 <printf>
 1d0:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1da:	83 e0 08             	and    $0x8,%eax
 1dd:	84 c0                	test   %al,%al
 1df:	74 14                	je     1f5 <print_mode+0x1c9>
    printf(1, "x");
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	68 78 0a 00 00       	push   $0xa78
 1e9:	6a 01                	push   $0x1
 1eb:	e8 c4 04 00 00       	call   6b4 <printf>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	eb 12                	jmp    207 <print_mode+0x1db>
  else
    printf(1, "-");
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	68 6c 0a 00 00       	push   $0xa6c
 1fd:	6a 01                	push   $0x1
 1ff:	e8 b0 04 00 00       	call   6b4 <printf>
 204:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 20e:	83 e0 04             	and    $0x4,%eax
 211:	84 c0                	test   %al,%al
 213:	74 14                	je     229 <print_mode+0x1fd>
    printf(1, "r");
 215:	83 ec 08             	sub    $0x8,%esp
 218:	68 72 0a 00 00       	push   $0xa72
 21d:	6a 01                	push   $0x1
 21f:	e8 90 04 00 00       	call   6b4 <printf>
 224:	83 c4 10             	add    $0x10,%esp
 227:	eb 12                	jmp    23b <print_mode+0x20f>
  else
    printf(1, "-");
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	68 6c 0a 00 00       	push   $0xa6c
 231:	6a 01                	push   $0x1
 233:	e8 7c 04 00 00       	call   6b4 <printf>
 238:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 242:	83 e0 02             	and    $0x2,%eax
 245:	84 c0                	test   %al,%al
 247:	74 14                	je     25d <print_mode+0x231>
    printf(1, "w");
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	68 74 0a 00 00       	push   $0xa74
 251:	6a 01                	push   $0x1
 253:	e8 5c 04 00 00       	call   6b4 <printf>
 258:	83 c4 10             	add    $0x10,%esp
 25b:	eb 12                	jmp    26f <print_mode+0x243>
  else
    printf(1, "-");
 25d:	83 ec 08             	sub    $0x8,%esp
 260:	68 6c 0a 00 00       	push   $0xa6c
 265:	6a 01                	push   $0x1
 267:	e8 48 04 00 00       	call   6b4 <printf>
 26c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 276:	83 e0 01             	and    $0x1,%eax
 279:	84 c0                	test   %al,%al
 27b:	74 14                	je     291 <print_mode+0x265>
    printf(1, "x");
 27d:	83 ec 08             	sub    $0x8,%esp
 280:	68 78 0a 00 00       	push   $0xa78
 285:	6a 01                	push   $0x1
 287:	e8 28 04 00 00       	call   6b4 <printf>
 28c:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 28f:	eb 13                	jmp    2a4 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 291:	83 ec 08             	sub    $0x8,%esp
 294:	68 6c 0a 00 00       	push   $0xa6c
 299:	6a 01                	push   $0x1
 29b:	e8 14 04 00 00       	call   6b4 <printf>
 2a0:	83 c4 10             	add    $0x10,%esp

  return;
 2a3:	90                   	nop
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	57                   	push   %edi
 2aa:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ae:	8b 55 10             	mov    0x10(%ebp),%edx
 2b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b4:	89 cb                	mov    %ecx,%ebx
 2b6:	89 df                	mov    %ebx,%edi
 2b8:	89 d1                	mov    %edx,%ecx
 2ba:	fc                   	cld    
 2bb:	f3 aa                	rep stos %al,%es:(%edi)
 2bd:	89 ca                	mov    %ecx,%edx
 2bf:	89 fb                	mov    %edi,%ebx
 2c1:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2c4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2c7:	90                   	nop
 2c8:	5b                   	pop    %ebx
 2c9:	5f                   	pop    %edi
 2ca:	5d                   	pop    %ebp
 2cb:	c3                   	ret    

000002cc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2d8:	90                   	nop
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	8d 50 01             	lea    0x1(%eax),%edx
 2df:	89 55 08             	mov    %edx,0x8(%ebp)
 2e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 2e5:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2eb:	0f b6 12             	movzbl (%edx),%edx
 2ee:	88 10                	mov    %dl,(%eax)
 2f0:	0f b6 00             	movzbl (%eax),%eax
 2f3:	84 c0                	test   %al,%al
 2f5:	75 e2                	jne    2d9 <strcpy+0xd>
    ;
  return os;
 2f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    

000002fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2ff:	eb 08                	jmp    309 <strcmp+0xd>
    p++, q++;
 301:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 305:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	84 c0                	test   %al,%al
 311:	74 10                	je     323 <strcmp+0x27>
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	0f b6 10             	movzbl (%eax),%edx
 319:	8b 45 0c             	mov    0xc(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	38 c2                	cmp    %al,%dl
 321:	74 de                	je     301 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	0f b6 d0             	movzbl %al,%edx
 32c:	8b 45 0c             	mov    0xc(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	0f b6 c0             	movzbl %al,%eax
 335:	29 c2                	sub    %eax,%edx
 337:	89 d0                	mov    %edx,%eax
}
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret    

0000033b <strlen>:

uint
strlen(char *s)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 348:	eb 04                	jmp    34e <strlen+0x13>
 34a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 34e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	01 d0                	add    %edx,%eax
 356:	0f b6 00             	movzbl (%eax),%eax
 359:	84 c0                	test   %al,%al
 35b:	75 ed                	jne    34a <strlen+0xf>
    ;
  return n;
 35d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <memset>:

void*
memset(void *dst, int c, uint n)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 365:	8b 45 10             	mov    0x10(%ebp),%eax
 368:	50                   	push   %eax
 369:	ff 75 0c             	pushl  0xc(%ebp)
 36c:	ff 75 08             	pushl  0x8(%ebp)
 36f:	e8 32 ff ff ff       	call   2a6 <stosb>
 374:	83 c4 0c             	add    $0xc,%esp
  return dst;
 377:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <strchr>:

char*
strchr(const char *s, char c)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	83 ec 04             	sub    $0x4,%esp
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 388:	eb 14                	jmp    39e <strchr+0x22>
    if(*s == c)
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	0f b6 00             	movzbl (%eax),%eax
 390:	3a 45 fc             	cmp    -0x4(%ebp),%al
 393:	75 05                	jne    39a <strchr+0x1e>
      return (char*)s;
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	eb 13                	jmp    3ad <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 39a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	84 c0                	test   %al,%al
 3a6:	75 e2                	jne    38a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <gets>:

char*
gets(char *buf, int max)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3bc:	eb 42                	jmp    400 <gets+0x51>
    cc = read(0, &c, 1);
 3be:	83 ec 04             	sub    $0x4,%esp
 3c1:	6a 01                	push   $0x1
 3c3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3c6:	50                   	push   %eax
 3c7:	6a 00                	push   $0x0
 3c9:	e8 47 01 00 00       	call   515 <read>
 3ce:	83 c4 10             	add    $0x10,%esp
 3d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d8:	7e 33                	jle    40d <gets+0x5e>
      break;
    buf[i++] = c;
 3da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3dd:	8d 50 01             	lea    0x1(%eax),%edx
 3e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e3:	89 c2                	mov    %eax,%edx
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	01 c2                	add    %eax,%edx
 3ea:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ee:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f4:	3c 0a                	cmp    $0xa,%al
 3f6:	74 16                	je     40e <gets+0x5f>
 3f8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3fc:	3c 0d                	cmp    $0xd,%al
 3fe:	74 0e                	je     40e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 400:	8b 45 f4             	mov    -0xc(%ebp),%eax
 403:	83 c0 01             	add    $0x1,%eax
 406:	3b 45 0c             	cmp    0xc(%ebp),%eax
 409:	7c b3                	jl     3be <gets+0xf>
 40b:	eb 01                	jmp    40e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 40d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 40e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 419:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <stat>:

int
stat(char *n, struct stat *st)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 424:	83 ec 08             	sub    $0x8,%esp
 427:	6a 00                	push   $0x0
 429:	ff 75 08             	pushl  0x8(%ebp)
 42c:	e8 0c 01 00 00       	call   53d <open>
 431:	83 c4 10             	add    $0x10,%esp
 434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43b:	79 07                	jns    444 <stat+0x26>
    return -1;
 43d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 442:	eb 25                	jmp    469 <stat+0x4b>
  r = fstat(fd, st);
 444:	83 ec 08             	sub    $0x8,%esp
 447:	ff 75 0c             	pushl  0xc(%ebp)
 44a:	ff 75 f4             	pushl  -0xc(%ebp)
 44d:	e8 03 01 00 00       	call   555 <fstat>
 452:	83 c4 10             	add    $0x10,%esp
 455:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 458:	83 ec 0c             	sub    $0xc,%esp
 45b:	ff 75 f4             	pushl  -0xc(%ebp)
 45e:	e8 c2 00 00 00       	call   525 <close>
 463:	83 c4 10             	add    $0x10,%esp
  return r;
 466:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 469:	c9                   	leave  
 46a:	c3                   	ret    

0000046b <atoi>:

int
atoi(const char *s)
{
 46b:	55                   	push   %ebp
 46c:	89 e5                	mov    %esp,%ebp
 46e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 478:	eb 25                	jmp    49f <atoi+0x34>
    n = n*10 + *s++ - '0';
 47a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 47d:	89 d0                	mov    %edx,%eax
 47f:	c1 e0 02             	shl    $0x2,%eax
 482:	01 d0                	add    %edx,%eax
 484:	01 c0                	add    %eax,%eax
 486:	89 c1                	mov    %eax,%ecx
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	8d 50 01             	lea    0x1(%eax),%edx
 48e:	89 55 08             	mov    %edx,0x8(%ebp)
 491:	0f b6 00             	movzbl (%eax),%eax
 494:	0f be c0             	movsbl %al,%eax
 497:	01 c8                	add    %ecx,%eax
 499:	83 e8 30             	sub    $0x30,%eax
 49c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	0f b6 00             	movzbl (%eax),%eax
 4a5:	3c 2f                	cmp    $0x2f,%al
 4a7:	7e 0a                	jle    4b3 <atoi+0x48>
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	3c 39                	cmp    $0x39,%al
 4b1:	7e c7                	jle    47a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4b6:	c9                   	leave  
 4b7:	c3                   	ret    

000004b8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ca:	eb 17                	jmp    4e3 <memmove+0x2b>
    *dst++ = *src++;
 4cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4cf:	8d 50 01             	lea    0x1(%eax),%edx
 4d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4d8:	8d 4a 01             	lea    0x1(%edx),%ecx
 4db:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4de:	0f b6 12             	movzbl (%edx),%edx
 4e1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4e3:	8b 45 10             	mov    0x10(%ebp),%eax
 4e6:	8d 50 ff             	lea    -0x1(%eax),%edx
 4e9:	89 55 10             	mov    %edx,0x10(%ebp)
 4ec:	85 c0                	test   %eax,%eax
 4ee:	7f dc                	jg     4cc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f3:	c9                   	leave  
 4f4:	c3                   	ret    

000004f5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4f5:	b8 01 00 00 00       	mov    $0x1,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <exit>:
SYSCALL(exit)
 4fd:	b8 02 00 00 00       	mov    $0x2,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <wait>:
SYSCALL(wait)
 505:	b8 03 00 00 00       	mov    $0x3,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <pipe>:
SYSCALL(pipe)
 50d:	b8 04 00 00 00       	mov    $0x4,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <read>:
SYSCALL(read)
 515:	b8 05 00 00 00       	mov    $0x5,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <write>:
SYSCALL(write)
 51d:	b8 10 00 00 00       	mov    $0x10,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <close>:
SYSCALL(close)
 525:	b8 15 00 00 00       	mov    $0x15,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <kill>:
SYSCALL(kill)
 52d:	b8 06 00 00 00       	mov    $0x6,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <exec>:
SYSCALL(exec)
 535:	b8 07 00 00 00       	mov    $0x7,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <open>:
SYSCALL(open)
 53d:	b8 0f 00 00 00       	mov    $0xf,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <mknod>:
SYSCALL(mknod)
 545:	b8 11 00 00 00       	mov    $0x11,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <unlink>:
SYSCALL(unlink)
 54d:	b8 12 00 00 00       	mov    $0x12,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <fstat>:
SYSCALL(fstat)
 555:	b8 08 00 00 00       	mov    $0x8,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <link>:
SYSCALL(link)
 55d:	b8 13 00 00 00       	mov    $0x13,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <mkdir>:
SYSCALL(mkdir)
 565:	b8 14 00 00 00       	mov    $0x14,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <chdir>:
SYSCALL(chdir)
 56d:	b8 09 00 00 00       	mov    $0x9,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <dup>:
SYSCALL(dup)
 575:	b8 0a 00 00 00       	mov    $0xa,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <getpid>:
SYSCALL(getpid)
 57d:	b8 0b 00 00 00       	mov    $0xb,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <sbrk>:
SYSCALL(sbrk)
 585:	b8 0c 00 00 00       	mov    $0xc,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <sleep>:
SYSCALL(sleep)
 58d:	b8 0d 00 00 00       	mov    $0xd,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <uptime>:
SYSCALL(uptime)
 595:	b8 0e 00 00 00       	mov    $0xe,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <halt>:
SYSCALL(halt)
 59d:	b8 16 00 00 00       	mov    $0x16,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <date>:
//Student Implementations 
SYSCALL(date)
 5a5:	b8 17 00 00 00       	mov    $0x17,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <getuid>:

SYSCALL(getuid)
 5ad:	b8 18 00 00 00       	mov    $0x18,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <getgid>:
SYSCALL(getgid)
 5b5:	b8 19 00 00 00       	mov    $0x19,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <getppid>:
SYSCALL(getppid)
 5bd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <setuid>:

SYSCALL(setuid)
 5c5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <setgid>:
SYSCALL(setgid)
 5cd:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <getprocs>:
SYSCALL(getprocs)
 5d5:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5dd:	55                   	push   %ebp
 5de:	89 e5                	mov    %esp,%ebp
 5e0:	83 ec 18             	sub    $0x18,%esp
 5e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5e9:	83 ec 04             	sub    $0x4,%esp
 5ec:	6a 01                	push   $0x1
 5ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 23 ff ff ff       	call   51d <write>
 5fa:	83 c4 10             	add    $0x10,%esp
}
 5fd:	90                   	nop
 5fe:	c9                   	leave  
 5ff:	c3                   	ret    

00000600 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	53                   	push   %ebx
 604:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 607:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 60e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 612:	74 17                	je     62b <printint+0x2b>
 614:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 618:	79 11                	jns    62b <printint+0x2b>
    neg = 1;
 61a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 621:	8b 45 0c             	mov    0xc(%ebp),%eax
 624:	f7 d8                	neg    %eax
 626:	89 45 ec             	mov    %eax,-0x14(%ebp)
 629:	eb 06                	jmp    631 <printint+0x31>
  } else {
    x = xx;
 62b:	8b 45 0c             	mov    0xc(%ebp),%eax
 62e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 638:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 63b:	8d 41 01             	lea    0x1(%ecx),%eax
 63e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 641:	8b 5d 10             	mov    0x10(%ebp),%ebx
 644:	8b 45 ec             	mov    -0x14(%ebp),%eax
 647:	ba 00 00 00 00       	mov    $0x0,%edx
 64c:	f7 f3                	div    %ebx
 64e:	89 d0                	mov    %edx,%eax
 650:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 657:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 65b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 65e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 661:	ba 00 00 00 00       	mov    $0x0,%edx
 666:	f7 f3                	div    %ebx
 668:	89 45 ec             	mov    %eax,-0x14(%ebp)
 66b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 66f:	75 c7                	jne    638 <printint+0x38>
  if(neg)
 671:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 675:	74 2d                	je     6a4 <printint+0xa4>
    buf[i++] = '-';
 677:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67a:	8d 50 01             	lea    0x1(%eax),%edx
 67d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 680:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 685:	eb 1d                	jmp    6a4 <printint+0xa4>
    putc(fd, buf[i]);
 687:	8d 55 dc             	lea    -0x24(%ebp),%edx
 68a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68d:	01 d0                	add    %edx,%eax
 68f:	0f b6 00             	movzbl (%eax),%eax
 692:	0f be c0             	movsbl %al,%eax
 695:	83 ec 08             	sub    $0x8,%esp
 698:	50                   	push   %eax
 699:	ff 75 08             	pushl  0x8(%ebp)
 69c:	e8 3c ff ff ff       	call   5dd <putc>
 6a1:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6a4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ac:	79 d9                	jns    687 <printint+0x87>
    putc(fd, buf[i]);
}
 6ae:	90                   	nop
 6af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6b2:	c9                   	leave  
 6b3:	c3                   	ret    

000006b4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6c1:	8d 45 0c             	lea    0xc(%ebp),%eax
 6c4:	83 c0 04             	add    $0x4,%eax
 6c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6d1:	e9 59 01 00 00       	jmp    82f <printf+0x17b>
    c = fmt[i] & 0xff;
 6d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6dc:	01 d0                	add    %edx,%eax
 6de:	0f b6 00             	movzbl (%eax),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	25 ff 00 00 00       	and    $0xff,%eax
 6e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f0:	75 2c                	jne    71e <printf+0x6a>
      if(c == '%'){
 6f2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f6:	75 0c                	jne    704 <printf+0x50>
        state = '%';
 6f8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ff:	e9 27 01 00 00       	jmp    82b <printf+0x177>
      } else {
        putc(fd, c);
 704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 707:	0f be c0             	movsbl %al,%eax
 70a:	83 ec 08             	sub    $0x8,%esp
 70d:	50                   	push   %eax
 70e:	ff 75 08             	pushl  0x8(%ebp)
 711:	e8 c7 fe ff ff       	call   5dd <putc>
 716:	83 c4 10             	add    $0x10,%esp
 719:	e9 0d 01 00 00       	jmp    82b <printf+0x177>
      }
    } else if(state == '%'){
 71e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 722:	0f 85 03 01 00 00    	jne    82b <printf+0x177>
      if(c == 'd'){
 728:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 72c:	75 1e                	jne    74c <printf+0x98>
        printint(fd, *ap, 10, 1);
 72e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 731:	8b 00                	mov    (%eax),%eax
 733:	6a 01                	push   $0x1
 735:	6a 0a                	push   $0xa
 737:	50                   	push   %eax
 738:	ff 75 08             	pushl  0x8(%ebp)
 73b:	e8 c0 fe ff ff       	call   600 <printint>
 740:	83 c4 10             	add    $0x10,%esp
        ap++;
 743:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 747:	e9 d8 00 00 00       	jmp    824 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 74c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 750:	74 06                	je     758 <printf+0xa4>
 752:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 756:	75 1e                	jne    776 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 758:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	6a 00                	push   $0x0
 75f:	6a 10                	push   $0x10
 761:	50                   	push   %eax
 762:	ff 75 08             	pushl  0x8(%ebp)
 765:	e8 96 fe ff ff       	call   600 <printint>
 76a:	83 c4 10             	add    $0x10,%esp
        ap++;
 76d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 771:	e9 ae 00 00 00       	jmp    824 <printf+0x170>
      } else if(c == 's'){
 776:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 77a:	75 43                	jne    7bf <printf+0x10b>
        s = (char*)*ap;
 77c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77f:	8b 00                	mov    (%eax),%eax
 781:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 784:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 78c:	75 25                	jne    7b3 <printf+0xff>
          s = "(null)";
 78e:	c7 45 f4 7a 0a 00 00 	movl   $0xa7a,-0xc(%ebp)
        while(*s != 0){
 795:	eb 1c                	jmp    7b3 <printf+0xff>
          putc(fd, *s);
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	0f b6 00             	movzbl (%eax),%eax
 79d:	0f be c0             	movsbl %al,%eax
 7a0:	83 ec 08             	sub    $0x8,%esp
 7a3:	50                   	push   %eax
 7a4:	ff 75 08             	pushl  0x8(%ebp)
 7a7:	e8 31 fe ff ff       	call   5dd <putc>
 7ac:	83 c4 10             	add    $0x10,%esp
          s++;
 7af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	0f b6 00             	movzbl (%eax),%eax
 7b9:	84 c0                	test   %al,%al
 7bb:	75 da                	jne    797 <printf+0xe3>
 7bd:	eb 65                	jmp    824 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7bf:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7c3:	75 1d                	jne    7e2 <printf+0x12e>
        putc(fd, *ap);
 7c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c8:	8b 00                	mov    (%eax),%eax
 7ca:	0f be c0             	movsbl %al,%eax
 7cd:	83 ec 08             	sub    $0x8,%esp
 7d0:	50                   	push   %eax
 7d1:	ff 75 08             	pushl  0x8(%ebp)
 7d4:	e8 04 fe ff ff       	call   5dd <putc>
 7d9:	83 c4 10             	add    $0x10,%esp
        ap++;
 7dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e0:	eb 42                	jmp    824 <printf+0x170>
      } else if(c == '%'){
 7e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e6:	75 17                	jne    7ff <printf+0x14b>
        putc(fd, c);
 7e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7eb:	0f be c0             	movsbl %al,%eax
 7ee:	83 ec 08             	sub    $0x8,%esp
 7f1:	50                   	push   %eax
 7f2:	ff 75 08             	pushl  0x8(%ebp)
 7f5:	e8 e3 fd ff ff       	call   5dd <putc>
 7fa:	83 c4 10             	add    $0x10,%esp
 7fd:	eb 25                	jmp    824 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ff:	83 ec 08             	sub    $0x8,%esp
 802:	6a 25                	push   $0x25
 804:	ff 75 08             	pushl  0x8(%ebp)
 807:	e8 d1 fd ff ff       	call   5dd <putc>
 80c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 80f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 812:	0f be c0             	movsbl %al,%eax
 815:	83 ec 08             	sub    $0x8,%esp
 818:	50                   	push   %eax
 819:	ff 75 08             	pushl  0x8(%ebp)
 81c:	e8 bc fd ff ff       	call   5dd <putc>
 821:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 82b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 82f:	8b 55 0c             	mov    0xc(%ebp),%edx
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	01 d0                	add    %edx,%eax
 837:	0f b6 00             	movzbl (%eax),%eax
 83a:	84 c0                	test   %al,%al
 83c:	0f 85 94 fe ff ff    	jne    6d6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 842:	90                   	nop
 843:	c9                   	leave  
 844:	c3                   	ret    

00000845 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 845:	55                   	push   %ebp
 846:	89 e5                	mov    %esp,%ebp
 848:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84b:	8b 45 08             	mov    0x8(%ebp),%eax
 84e:	83 e8 08             	sub    $0x8,%eax
 851:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	a1 08 0d 00 00       	mov    0xd08,%eax
 859:	89 45 fc             	mov    %eax,-0x4(%ebp)
 85c:	eb 24                	jmp    882 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	8b 00                	mov    (%eax),%eax
 863:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 866:	77 12                	ja     87a <free+0x35>
 868:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86e:	77 24                	ja     894 <free+0x4f>
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 878:	77 1a                	ja     894 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 882:	8b 45 f8             	mov    -0x8(%ebp),%eax
 885:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 888:	76 d4                	jbe    85e <free+0x19>
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	8b 00                	mov    (%eax),%eax
 88f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 892:	76 ca                	jbe    85e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 894:	8b 45 f8             	mov    -0x8(%ebp),%eax
 897:	8b 40 04             	mov    0x4(%eax),%eax
 89a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a4:	01 c2                	add    %eax,%edx
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	39 c2                	cmp    %eax,%edx
 8ad:	75 24                	jne    8d3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b2:	8b 50 04             	mov    0x4(%eax),%edx
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	01 c2                	add    %eax,%edx
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	8b 10                	mov    (%eax),%edx
 8cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cf:	89 10                	mov    %edx,(%eax)
 8d1:	eb 0a                	jmp    8dd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d6:	8b 10                	mov    (%eax),%edx
 8d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8db:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	8b 40 04             	mov    0x4(%eax),%eax
 8e3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	01 d0                	add    %edx,%eax
 8ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f2:	75 20                	jne    914 <free+0xcf>
    p->s.size += bp->s.size;
 8f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f7:	8b 50 04             	mov    0x4(%eax),%edx
 8fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fd:	8b 40 04             	mov    0x4(%eax),%eax
 900:	01 c2                	add    %eax,%edx
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 908:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90b:	8b 10                	mov    (%eax),%edx
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	89 10                	mov    %edx,(%eax)
 912:	eb 08                	jmp    91c <free+0xd7>
  } else
    p->s.ptr = bp;
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	8b 55 f8             	mov    -0x8(%ebp),%edx
 91a:	89 10                	mov    %edx,(%eax)
  freep = p;
 91c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91f:	a3 08 0d 00 00       	mov    %eax,0xd08
}
 924:	90                   	nop
 925:	c9                   	leave  
 926:	c3                   	ret    

00000927 <morecore>:

static Header*
morecore(uint nu)
{
 927:	55                   	push   %ebp
 928:	89 e5                	mov    %esp,%ebp
 92a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 92d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 934:	77 07                	ja     93d <morecore+0x16>
    nu = 4096;
 936:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 93d:	8b 45 08             	mov    0x8(%ebp),%eax
 940:	c1 e0 03             	shl    $0x3,%eax
 943:	83 ec 0c             	sub    $0xc,%esp
 946:	50                   	push   %eax
 947:	e8 39 fc ff ff       	call   585 <sbrk>
 94c:	83 c4 10             	add    $0x10,%esp
 94f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 952:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 956:	75 07                	jne    95f <morecore+0x38>
    return 0;
 958:	b8 00 00 00 00       	mov    $0x0,%eax
 95d:	eb 26                	jmp    985 <morecore+0x5e>
  hp = (Header*)p;
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 965:	8b 45 f0             	mov    -0x10(%ebp),%eax
 968:	8b 55 08             	mov    0x8(%ebp),%edx
 96b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 96e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 971:	83 c0 08             	add    $0x8,%eax
 974:	83 ec 0c             	sub    $0xc,%esp
 977:	50                   	push   %eax
 978:	e8 c8 fe ff ff       	call   845 <free>
 97d:	83 c4 10             	add    $0x10,%esp
  return freep;
 980:	a1 08 0d 00 00       	mov    0xd08,%eax
}
 985:	c9                   	leave  
 986:	c3                   	ret    

00000987 <malloc>:

void*
malloc(uint nbytes)
{
 987:	55                   	push   %ebp
 988:	89 e5                	mov    %esp,%ebp
 98a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98d:	8b 45 08             	mov    0x8(%ebp),%eax
 990:	83 c0 07             	add    $0x7,%eax
 993:	c1 e8 03             	shr    $0x3,%eax
 996:	83 c0 01             	add    $0x1,%eax
 999:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 99c:	a1 08 0d 00 00       	mov    0xd08,%eax
 9a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9a8:	75 23                	jne    9cd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9aa:	c7 45 f0 00 0d 00 00 	movl   $0xd00,-0x10(%ebp)
 9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b4:	a3 08 0d 00 00       	mov    %eax,0xd08
 9b9:	a1 08 0d 00 00       	mov    0xd08,%eax
 9be:	a3 00 0d 00 00       	mov    %eax,0xd00
    base.s.size = 0;
 9c3:	c7 05 04 0d 00 00 00 	movl   $0x0,0xd04
 9ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d0:	8b 00                	mov    (%eax),%eax
 9d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d8:	8b 40 04             	mov    0x4(%eax),%eax
 9db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9de:	72 4d                	jb     a2d <malloc+0xa6>
      if(p->s.size == nunits)
 9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e3:	8b 40 04             	mov    0x4(%eax),%eax
 9e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e9:	75 0c                	jne    9f7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ee:	8b 10                	mov    (%eax),%edx
 9f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f3:	89 10                	mov    %edx,(%eax)
 9f5:	eb 26                	jmp    a1d <malloc+0x96>
      else {
        p->s.size -= nunits;
 9f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fa:	8b 40 04             	mov    0x4(%eax),%eax
 9fd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a00:	89 c2                	mov    %eax,%edx
 a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a05:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0b:	8b 40 04             	mov    0x4(%eax),%eax
 a0e:	c1 e0 03             	shl    $0x3,%eax
 a11:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a17:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a1a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a20:	a3 08 0d 00 00       	mov    %eax,0xd08
      return (void*)(p + 1);
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	83 c0 08             	add    $0x8,%eax
 a2b:	eb 3b                	jmp    a68 <malloc+0xe1>
    }
    if(p == freep)
 a2d:	a1 08 0d 00 00       	mov    0xd08,%eax
 a32:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a35:	75 1e                	jne    a55 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a37:	83 ec 0c             	sub    $0xc,%esp
 a3a:	ff 75 ec             	pushl  -0x14(%ebp)
 a3d:	e8 e5 fe ff ff       	call   927 <morecore>
 a42:	83 c4 10             	add    $0x10,%esp
 a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a4c:	75 07                	jne    a55 <malloc+0xce>
        return 0;
 a4e:	b8 00 00 00 00       	mov    $0x0,%eax
 a53:	eb 13                	jmp    a68 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 00                	mov    (%eax),%eax
 a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a63:	e9 6d ff ff ff       	jmp    9d5 <malloc+0x4e>
}
 a68:	c9                   	leave  
 a69:	c3                   	ret    
