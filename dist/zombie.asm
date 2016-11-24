
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
  4b:	68 82 0a 00 00       	push   $0xa82
  50:	6a 01                	push   $0x1
  52:	e8 75 06 00 00       	call   6cc <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb 3a                	jmp    96 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  5c:	83 ec 08             	sub    $0x8,%esp
  5f:	68 84 0a 00 00       	push   $0xa84
  64:	6a 01                	push   $0x1
  66:	e8 61 06 00 00       	call   6cc <printf>
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	eb 26                	jmp    96 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  70:	83 ec 08             	sub    $0x8,%esp
  73:	68 86 0a 00 00       	push   $0xa86
  78:	6a 01                	push   $0x1
  7a:	e8 4d 06 00 00       	call   6cc <printf>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	eb 12                	jmp    96 <print_mode+0x6a>
    default: printf(1, "?");
  84:	83 ec 08             	sub    $0x8,%esp
  87:	68 88 0a 00 00       	push   $0xa88
  8c:	6a 01                	push   $0x1
  8e:	e8 39 06 00 00       	call   6cc <printf>
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
  a7:	68 8a 0a 00 00       	push   $0xa8a
  ac:	6a 01                	push   $0x1
  ae:	e8 19 06 00 00       	call   6cc <printf>
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	eb 12                	jmp    ca <print_mode+0x9e>
  else
    printf(1, "-");
  b8:	83 ec 08             	sub    $0x8,%esp
  bb:	68 84 0a 00 00       	push   $0xa84
  c0:	6a 01                	push   $0x1
  c2:	e8 05 06 00 00       	call   6cc <printf>
  c7:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  d1:	83 e0 80             	and    $0xffffff80,%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 14                	je     ec <print_mode+0xc0>
    printf(1, "w");
  d8:	83 ec 08             	sub    $0x8,%esp
  db:	68 8c 0a 00 00       	push   $0xa8c
  e0:	6a 01                	push   $0x1
  e2:	e8 e5 05 00 00       	call   6cc <printf>
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	eb 12                	jmp    fe <print_mode+0xd2>
  else
    printf(1, "-");
  ec:	83 ec 08             	sub    $0x8,%esp
  ef:	68 84 0a 00 00       	push   $0xa84
  f4:	6a 01                	push   $0x1
  f6:	e8 d1 05 00 00       	call   6cc <printf>
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
 126:	68 8e 0a 00 00       	push   $0xa8e
 12b:	6a 01                	push   $0x1
 12d:	e8 9a 05 00 00       	call   6cc <printf>
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
 148:	68 90 0a 00 00       	push   $0xa90
 14d:	6a 01                	push   $0x1
 14f:	e8 78 05 00 00       	call   6cc <printf>
 154:	83 c4 10             	add    $0x10,%esp
 157:	eb 12                	jmp    16b <print_mode+0x13f>
  else
    printf(1, "-");
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	68 84 0a 00 00       	push   $0xa84
 161:	6a 01                	push   $0x1
 163:	e8 64 05 00 00       	call   6cc <printf>
 168:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 172:	83 e0 20             	and    $0x20,%eax
 175:	84 c0                	test   %al,%al
 177:	74 14                	je     18d <print_mode+0x161>
    printf(1, "r");
 179:	83 ec 08             	sub    $0x8,%esp
 17c:	68 8a 0a 00 00       	push   $0xa8a
 181:	6a 01                	push   $0x1
 183:	e8 44 05 00 00       	call   6cc <printf>
 188:	83 c4 10             	add    $0x10,%esp
 18b:	eb 12                	jmp    19f <print_mode+0x173>
  else
    printf(1, "-");
 18d:	83 ec 08             	sub    $0x8,%esp
 190:	68 84 0a 00 00       	push   $0xa84
 195:	6a 01                	push   $0x1
 197:	e8 30 05 00 00       	call   6cc <printf>
 19c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1a6:	83 e0 10             	and    $0x10,%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	74 14                	je     1c1 <print_mode+0x195>
    printf(1, "w");
 1ad:	83 ec 08             	sub    $0x8,%esp
 1b0:	68 8c 0a 00 00       	push   $0xa8c
 1b5:	6a 01                	push   $0x1
 1b7:	e8 10 05 00 00       	call   6cc <printf>
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	eb 12                	jmp    1d3 <print_mode+0x1a7>
  else
    printf(1, "-");
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	68 84 0a 00 00       	push   $0xa84
 1c9:	6a 01                	push   $0x1
 1cb:	e8 fc 04 00 00       	call   6cc <printf>
 1d0:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1da:	83 e0 08             	and    $0x8,%eax
 1dd:	84 c0                	test   %al,%al
 1df:	74 14                	je     1f5 <print_mode+0x1c9>
    printf(1, "x");
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	68 90 0a 00 00       	push   $0xa90
 1e9:	6a 01                	push   $0x1
 1eb:	e8 dc 04 00 00       	call   6cc <printf>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	eb 12                	jmp    207 <print_mode+0x1db>
  else
    printf(1, "-");
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	68 84 0a 00 00       	push   $0xa84
 1fd:	6a 01                	push   $0x1
 1ff:	e8 c8 04 00 00       	call   6cc <printf>
 204:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 20e:	83 e0 04             	and    $0x4,%eax
 211:	84 c0                	test   %al,%al
 213:	74 14                	je     229 <print_mode+0x1fd>
    printf(1, "r");
 215:	83 ec 08             	sub    $0x8,%esp
 218:	68 8a 0a 00 00       	push   $0xa8a
 21d:	6a 01                	push   $0x1
 21f:	e8 a8 04 00 00       	call   6cc <printf>
 224:	83 c4 10             	add    $0x10,%esp
 227:	eb 12                	jmp    23b <print_mode+0x20f>
  else
    printf(1, "-");
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	68 84 0a 00 00       	push   $0xa84
 231:	6a 01                	push   $0x1
 233:	e8 94 04 00 00       	call   6cc <printf>
 238:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 242:	83 e0 02             	and    $0x2,%eax
 245:	84 c0                	test   %al,%al
 247:	74 14                	je     25d <print_mode+0x231>
    printf(1, "w");
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	68 8c 0a 00 00       	push   $0xa8c
 251:	6a 01                	push   $0x1
 253:	e8 74 04 00 00       	call   6cc <printf>
 258:	83 c4 10             	add    $0x10,%esp
 25b:	eb 12                	jmp    26f <print_mode+0x243>
  else
    printf(1, "-");
 25d:	83 ec 08             	sub    $0x8,%esp
 260:	68 84 0a 00 00       	push   $0xa84
 265:	6a 01                	push   $0x1
 267:	e8 60 04 00 00       	call   6cc <printf>
 26c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 276:	83 e0 01             	and    $0x1,%eax
 279:	84 c0                	test   %al,%al
 27b:	74 14                	je     291 <print_mode+0x265>
    printf(1, "x");
 27d:	83 ec 08             	sub    $0x8,%esp
 280:	68 90 0a 00 00       	push   $0xa90
 285:	6a 01                	push   $0x1
 287:	e8 40 04 00 00       	call   6cc <printf>
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
 294:	68 84 0a 00 00       	push   $0xa84
 299:	6a 01                	push   $0x1
 29b:	e8 2c 04 00 00       	call   6cc <printf>
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

000005dd <chown>:

SYSCALL(chown)
 5dd:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <chgrp>:
SYSCALL(chgrp)
 5e5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <chmod>:
SYSCALL(chmod)
 5ed:	b8 20 00 00 00       	mov    $0x20,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5f5:	55                   	push   %ebp
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	83 ec 18             	sub    $0x18,%esp
 5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fe:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 601:	83 ec 04             	sub    $0x4,%esp
 604:	6a 01                	push   $0x1
 606:	8d 45 f4             	lea    -0xc(%ebp),%eax
 609:	50                   	push   %eax
 60a:	ff 75 08             	pushl  0x8(%ebp)
 60d:	e8 0b ff ff ff       	call   51d <write>
 612:	83 c4 10             	add    $0x10,%esp
}
 615:	90                   	nop
 616:	c9                   	leave  
 617:	c3                   	ret    

00000618 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	53                   	push   %ebx
 61c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 61f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 626:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 62a:	74 17                	je     643 <printint+0x2b>
 62c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 630:	79 11                	jns    643 <printint+0x2b>
    neg = 1;
 632:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 639:	8b 45 0c             	mov    0xc(%ebp),%eax
 63c:	f7 d8                	neg    %eax
 63e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 641:	eb 06                	jmp    649 <printint+0x31>
  } else {
    x = xx;
 643:	8b 45 0c             	mov    0xc(%ebp),%eax
 646:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 650:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 653:	8d 41 01             	lea    0x1(%ecx),%eax
 656:	89 45 f4             	mov    %eax,-0xc(%ebp)
 659:	8b 5d 10             	mov    0x10(%ebp),%ebx
 65c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 65f:	ba 00 00 00 00       	mov    $0x0,%edx
 664:	f7 f3                	div    %ebx
 666:	89 d0                	mov    %edx,%eax
 668:	0f b6 80 04 0d 00 00 	movzbl 0xd04(%eax),%eax
 66f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 673:	8b 5d 10             	mov    0x10(%ebp),%ebx
 676:	8b 45 ec             	mov    -0x14(%ebp),%eax
 679:	ba 00 00 00 00       	mov    $0x0,%edx
 67e:	f7 f3                	div    %ebx
 680:	89 45 ec             	mov    %eax,-0x14(%ebp)
 683:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 687:	75 c7                	jne    650 <printint+0x38>
  if(neg)
 689:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 68d:	74 2d                	je     6bc <printint+0xa4>
    buf[i++] = '-';
 68f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 692:	8d 50 01             	lea    0x1(%eax),%edx
 695:	89 55 f4             	mov    %edx,-0xc(%ebp)
 698:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 69d:	eb 1d                	jmp    6bc <printint+0xa4>
    putc(fd, buf[i]);
 69f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a5:	01 d0                	add    %edx,%eax
 6a7:	0f b6 00             	movzbl (%eax),%eax
 6aa:	0f be c0             	movsbl %al,%eax
 6ad:	83 ec 08             	sub    $0x8,%esp
 6b0:	50                   	push   %eax
 6b1:	ff 75 08             	pushl  0x8(%ebp)
 6b4:	e8 3c ff ff ff       	call   5f5 <putc>
 6b9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6bc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c4:	79 d9                	jns    69f <printint+0x87>
    putc(fd, buf[i]);
}
 6c6:	90                   	nop
 6c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ca:	c9                   	leave  
 6cb:	c3                   	ret    

000006cc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6d9:	8d 45 0c             	lea    0xc(%ebp),%eax
 6dc:	83 c0 04             	add    $0x4,%eax
 6df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6e9:	e9 59 01 00 00       	jmp    847 <printf+0x17b>
    c = fmt[i] & 0xff;
 6ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f4:	01 d0                	add    %edx,%eax
 6f6:	0f b6 00             	movzbl (%eax),%eax
 6f9:	0f be c0             	movsbl %al,%eax
 6fc:	25 ff 00 00 00       	and    $0xff,%eax
 701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 704:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 708:	75 2c                	jne    736 <printf+0x6a>
      if(c == '%'){
 70a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 70e:	75 0c                	jne    71c <printf+0x50>
        state = '%';
 710:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 717:	e9 27 01 00 00       	jmp    843 <printf+0x177>
      } else {
        putc(fd, c);
 71c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 c7 fe ff ff       	call   5f5 <putc>
 72e:	83 c4 10             	add    $0x10,%esp
 731:	e9 0d 01 00 00       	jmp    843 <printf+0x177>
      }
    } else if(state == '%'){
 736:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 73a:	0f 85 03 01 00 00    	jne    843 <printf+0x177>
      if(c == 'd'){
 740:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 744:	75 1e                	jne    764 <printf+0x98>
        printint(fd, *ap, 10, 1);
 746:	8b 45 e8             	mov    -0x18(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	6a 01                	push   $0x1
 74d:	6a 0a                	push   $0xa
 74f:	50                   	push   %eax
 750:	ff 75 08             	pushl  0x8(%ebp)
 753:	e8 c0 fe ff ff       	call   618 <printint>
 758:	83 c4 10             	add    $0x10,%esp
        ap++;
 75b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 75f:	e9 d8 00 00 00       	jmp    83c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 764:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 768:	74 06                	je     770 <printf+0xa4>
 76a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 76e:	75 1e                	jne    78e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 770:	8b 45 e8             	mov    -0x18(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	6a 00                	push   $0x0
 777:	6a 10                	push   $0x10
 779:	50                   	push   %eax
 77a:	ff 75 08             	pushl  0x8(%ebp)
 77d:	e8 96 fe ff ff       	call   618 <printint>
 782:	83 c4 10             	add    $0x10,%esp
        ap++;
 785:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 789:	e9 ae 00 00 00       	jmp    83c <printf+0x170>
      } else if(c == 's'){
 78e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 792:	75 43                	jne    7d7 <printf+0x10b>
        s = (char*)*ap;
 794:	8b 45 e8             	mov    -0x18(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 79c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a4:	75 25                	jne    7cb <printf+0xff>
          s = "(null)";
 7a6:	c7 45 f4 92 0a 00 00 	movl   $0xa92,-0xc(%ebp)
        while(*s != 0){
 7ad:	eb 1c                	jmp    7cb <printf+0xff>
          putc(fd, *s);
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	0f b6 00             	movzbl (%eax),%eax
 7b5:	0f be c0             	movsbl %al,%eax
 7b8:	83 ec 08             	sub    $0x8,%esp
 7bb:	50                   	push   %eax
 7bc:	ff 75 08             	pushl  0x8(%ebp)
 7bf:	e8 31 fe ff ff       	call   5f5 <putc>
 7c4:	83 c4 10             	add    $0x10,%esp
          s++;
 7c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	0f b6 00             	movzbl (%eax),%eax
 7d1:	84 c0                	test   %al,%al
 7d3:	75 da                	jne    7af <printf+0xe3>
 7d5:	eb 65                	jmp    83c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7d7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7db:	75 1d                	jne    7fa <printf+0x12e>
        putc(fd, *ap);
 7dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e0:	8b 00                	mov    (%eax),%eax
 7e2:	0f be c0             	movsbl %al,%eax
 7e5:	83 ec 08             	sub    $0x8,%esp
 7e8:	50                   	push   %eax
 7e9:	ff 75 08             	pushl  0x8(%ebp)
 7ec:	e8 04 fe ff ff       	call   5f5 <putc>
 7f1:	83 c4 10             	add    $0x10,%esp
        ap++;
 7f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7f8:	eb 42                	jmp    83c <printf+0x170>
      } else if(c == '%'){
 7fa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7fe:	75 17                	jne    817 <printf+0x14b>
        putc(fd, c);
 800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 803:	0f be c0             	movsbl %al,%eax
 806:	83 ec 08             	sub    $0x8,%esp
 809:	50                   	push   %eax
 80a:	ff 75 08             	pushl  0x8(%ebp)
 80d:	e8 e3 fd ff ff       	call   5f5 <putc>
 812:	83 c4 10             	add    $0x10,%esp
 815:	eb 25                	jmp    83c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 817:	83 ec 08             	sub    $0x8,%esp
 81a:	6a 25                	push   $0x25
 81c:	ff 75 08             	pushl  0x8(%ebp)
 81f:	e8 d1 fd ff ff       	call   5f5 <putc>
 824:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 82a:	0f be c0             	movsbl %al,%eax
 82d:	83 ec 08             	sub    $0x8,%esp
 830:	50                   	push   %eax
 831:	ff 75 08             	pushl  0x8(%ebp)
 834:	e8 bc fd ff ff       	call   5f5 <putc>
 839:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 83c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 843:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 847:	8b 55 0c             	mov    0xc(%ebp),%edx
 84a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84d:	01 d0                	add    %edx,%eax
 84f:	0f b6 00             	movzbl (%eax),%eax
 852:	84 c0                	test   %al,%al
 854:	0f 85 94 fe ff ff    	jne    6ee <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 85a:	90                   	nop
 85b:	c9                   	leave  
 85c:	c3                   	ret    

0000085d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85d:	55                   	push   %ebp
 85e:	89 e5                	mov    %esp,%ebp
 860:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 863:	8b 45 08             	mov    0x8(%ebp),%eax
 866:	83 e8 08             	sub    $0x8,%eax
 869:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	a1 20 0d 00 00       	mov    0xd20,%eax
 871:	89 45 fc             	mov    %eax,-0x4(%ebp)
 874:	eb 24                	jmp    89a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	8b 00                	mov    (%eax),%eax
 87b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 87e:	77 12                	ja     892 <free+0x35>
 880:	8b 45 f8             	mov    -0x8(%ebp),%eax
 883:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 886:	77 24                	ja     8ac <free+0x4f>
 888:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88b:	8b 00                	mov    (%eax),%eax
 88d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 890:	77 1a                	ja     8ac <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	8b 45 fc             	mov    -0x4(%ebp),%eax
 895:	8b 00                	mov    (%eax),%eax
 897:	89 45 fc             	mov    %eax,-0x4(%ebp)
 89a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8a0:	76 d4                	jbe    876 <free+0x19>
 8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a5:	8b 00                	mov    (%eax),%eax
 8a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8aa:	76 ca                	jbe    876 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8af:	8b 40 04             	mov    0x4(%eax),%eax
 8b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bc:	01 c2                	add    %eax,%edx
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	39 c2                	cmp    %eax,%edx
 8c5:	75 24                	jne    8eb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	8b 50 04             	mov    0x4(%eax),%edx
 8cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	8b 40 04             	mov    0x4(%eax),%eax
 8d5:	01 c2                	add    %eax,%edx
 8d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8da:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	8b 00                	mov    (%eax),%eax
 8e2:	8b 10                	mov    (%eax),%edx
 8e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e7:	89 10                	mov    %edx,(%eax)
 8e9:	eb 0a                	jmp    8f5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 10                	mov    (%eax),%edx
 8f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f8:	8b 40 04             	mov    0x4(%eax),%eax
 8fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	01 d0                	add    %edx,%eax
 907:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90a:	75 20                	jne    92c <free+0xcf>
    p->s.size += bp->s.size;
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 50 04             	mov    0x4(%eax),%edx
 912:	8b 45 f8             	mov    -0x8(%ebp),%eax
 915:	8b 40 04             	mov    0x4(%eax),%eax
 918:	01 c2                	add    %eax,%edx
 91a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 920:	8b 45 f8             	mov    -0x8(%ebp),%eax
 923:	8b 10                	mov    (%eax),%edx
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	89 10                	mov    %edx,(%eax)
 92a:	eb 08                	jmp    934 <free+0xd7>
  } else
    p->s.ptr = bp;
 92c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 932:	89 10                	mov    %edx,(%eax)
  freep = p;
 934:	8b 45 fc             	mov    -0x4(%ebp),%eax
 937:	a3 20 0d 00 00       	mov    %eax,0xd20
}
 93c:	90                   	nop
 93d:	c9                   	leave  
 93e:	c3                   	ret    

0000093f <morecore>:

static Header*
morecore(uint nu)
{
 93f:	55                   	push   %ebp
 940:	89 e5                	mov    %esp,%ebp
 942:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 945:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 94c:	77 07                	ja     955 <morecore+0x16>
    nu = 4096;
 94e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 955:	8b 45 08             	mov    0x8(%ebp),%eax
 958:	c1 e0 03             	shl    $0x3,%eax
 95b:	83 ec 0c             	sub    $0xc,%esp
 95e:	50                   	push   %eax
 95f:	e8 21 fc ff ff       	call   585 <sbrk>
 964:	83 c4 10             	add    $0x10,%esp
 967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 96a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 96e:	75 07                	jne    977 <morecore+0x38>
    return 0;
 970:	b8 00 00 00 00       	mov    $0x0,%eax
 975:	eb 26                	jmp    99d <morecore+0x5e>
  hp = (Header*)p;
 977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 97d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 980:	8b 55 08             	mov    0x8(%ebp),%edx
 983:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 986:	8b 45 f0             	mov    -0x10(%ebp),%eax
 989:	83 c0 08             	add    $0x8,%eax
 98c:	83 ec 0c             	sub    $0xc,%esp
 98f:	50                   	push   %eax
 990:	e8 c8 fe ff ff       	call   85d <free>
 995:	83 c4 10             	add    $0x10,%esp
  return freep;
 998:	a1 20 0d 00 00       	mov    0xd20,%eax
}
 99d:	c9                   	leave  
 99e:	c3                   	ret    

0000099f <malloc>:

void*
malloc(uint nbytes)
{
 99f:	55                   	push   %ebp
 9a0:	89 e5                	mov    %esp,%ebp
 9a2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	83 c0 07             	add    $0x7,%eax
 9ab:	c1 e8 03             	shr    $0x3,%eax
 9ae:	83 c0 01             	add    $0x1,%eax
 9b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9b4:	a1 20 0d 00 00       	mov    0xd20,%eax
 9b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9c0:	75 23                	jne    9e5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9c2:	c7 45 f0 18 0d 00 00 	movl   $0xd18,-0x10(%ebp)
 9c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cc:	a3 20 0d 00 00       	mov    %eax,0xd20
 9d1:	a1 20 0d 00 00       	mov    0xd20,%eax
 9d6:	a3 18 0d 00 00       	mov    %eax,0xd18
    base.s.size = 0;
 9db:	c7 05 1c 0d 00 00 00 	movl   $0x0,0xd1c
 9e2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e8:	8b 00                	mov    (%eax),%eax
 9ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f0:	8b 40 04             	mov    0x4(%eax),%eax
 9f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9f6:	72 4d                	jb     a45 <malloc+0xa6>
      if(p->s.size == nunits)
 9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fb:	8b 40 04             	mov    0x4(%eax),%eax
 9fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a01:	75 0c                	jne    a0f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a06:	8b 10                	mov    (%eax),%edx
 a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0b:	89 10                	mov    %edx,(%eax)
 a0d:	eb 26                	jmp    a35 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	8b 40 04             	mov    0x4(%eax),%eax
 a15:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a18:	89 c2                	mov    %eax,%edx
 a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a23:	8b 40 04             	mov    0x4(%eax),%eax
 a26:	c1 e0 03             	shl    $0x3,%eax
 a29:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a32:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	a3 20 0d 00 00       	mov    %eax,0xd20
      return (void*)(p + 1);
 a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a40:	83 c0 08             	add    $0x8,%eax
 a43:	eb 3b                	jmp    a80 <malloc+0xe1>
    }
    if(p == freep)
 a45:	a1 20 0d 00 00       	mov    0xd20,%eax
 a4a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a4d:	75 1e                	jne    a6d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a4f:	83 ec 0c             	sub    $0xc,%esp
 a52:	ff 75 ec             	pushl  -0x14(%ebp)
 a55:	e8 e5 fe ff ff       	call   93f <morecore>
 a5a:	83 c4 10             	add    $0x10,%esp
 a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a64:	75 07                	jne    a6d <malloc+0xce>
        return 0;
 a66:	b8 00 00 00 00       	mov    $0x0,%eax
 a6b:	eb 13                	jmp    a80 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a76:	8b 00                	mov    (%eax),%eax
 a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a7b:	e9 6d ff ff ff       	jmp    9ed <malloc+0x4e>
}
 a80:	c9                   	leave  
 a81:	c3                   	ret    
