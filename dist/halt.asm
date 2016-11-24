
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// halt the system.
#include "types.h"
#include "user.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  halt();
  11:	e8 76 05 00 00       	call   58c <halt>
  exit();
  16:	e8 d1 04 00 00       	call   4ec <exit>

0000001b <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  21:	8b 45 08             	mov    0x8(%ebp),%eax
  24:	0f b7 00             	movzwl (%eax),%eax
  27:	98                   	cwtl   
  28:	83 f8 02             	cmp    $0x2,%eax
  2b:	74 1e                	je     4b <print_mode+0x30>
  2d:	83 f8 03             	cmp    $0x3,%eax
  30:	74 2d                	je     5f <print_mode+0x44>
  32:	83 f8 01             	cmp    $0x1,%eax
  35:	75 3c                	jne    73 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	68 71 0a 00 00       	push   $0xa71
  3f:	6a 01                	push   $0x1
  41:	e8 75 06 00 00       	call   6bb <printf>
  46:	83 c4 10             	add    $0x10,%esp
  49:	eb 3a                	jmp    85 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  4b:	83 ec 08             	sub    $0x8,%esp
  4e:	68 73 0a 00 00       	push   $0xa73
  53:	6a 01                	push   $0x1
  55:	e8 61 06 00 00       	call   6bb <printf>
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	eb 26                	jmp    85 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  5f:	83 ec 08             	sub    $0x8,%esp
  62:	68 75 0a 00 00       	push   $0xa75
  67:	6a 01                	push   $0x1
  69:	e8 4d 06 00 00       	call   6bb <printf>
  6e:	83 c4 10             	add    $0x10,%esp
  71:	eb 12                	jmp    85 <print_mode+0x6a>
    default: printf(1, "?");
  73:	83 ec 08             	sub    $0x8,%esp
  76:	68 77 0a 00 00       	push   $0xa77
  7b:	6a 01                	push   $0x1
  7d:	e8 39 06 00 00       	call   6bb <printf>
  82:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  8c:	83 e0 01             	and    $0x1,%eax
  8f:	84 c0                	test   %al,%al
  91:	74 14                	je     a7 <print_mode+0x8c>
    printf(1, "r");
  93:	83 ec 08             	sub    $0x8,%esp
  96:	68 79 0a 00 00       	push   $0xa79
  9b:	6a 01                	push   $0x1
  9d:	e8 19 06 00 00       	call   6bb <printf>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	eb 12                	jmp    b9 <print_mode+0x9e>
  else
    printf(1, "-");
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	68 73 0a 00 00       	push   $0xa73
  af:	6a 01                	push   $0x1
  b1:	e8 05 06 00 00       	call   6bb <printf>
  b6:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  c0:	83 e0 80             	and    $0xffffff80,%eax
  c3:	84 c0                	test   %al,%al
  c5:	74 14                	je     db <print_mode+0xc0>
    printf(1, "w");
  c7:	83 ec 08             	sub    $0x8,%esp
  ca:	68 7b 0a 00 00       	push   $0xa7b
  cf:	6a 01                	push   $0x1
  d1:	e8 e5 05 00 00       	call   6bb <printf>
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	eb 12                	jmp    ed <print_mode+0xd2>
  else
    printf(1, "-");
  db:	83 ec 08             	sub    $0x8,%esp
  de:	68 73 0a 00 00       	push   $0xa73
  e3:	6a 01                	push   $0x1
  e5:	e8 d1 05 00 00       	call   6bb <printf>
  ea:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  f4:	c0 e8 06             	shr    $0x6,%al
  f7:	83 e0 01             	and    $0x1,%eax
  fa:	0f b6 d0             	movzbl %al,%edx
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 104:	d0 e8                	shr    %al
 106:	83 e0 01             	and    $0x1,%eax
 109:	0f b6 c0             	movzbl %al,%eax
 10c:	21 d0                	and    %edx,%eax
 10e:	85 c0                	test   %eax,%eax
 110:	74 14                	je     126 <print_mode+0x10b>
    printf(1, "S");
 112:	83 ec 08             	sub    $0x8,%esp
 115:	68 7d 0a 00 00       	push   $0xa7d
 11a:	6a 01                	push   $0x1
 11c:	e8 9a 05 00 00       	call   6bb <printf>
 121:	83 c4 10             	add    $0x10,%esp
 124:	eb 34                	jmp    15a <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 126:	8b 45 08             	mov    0x8(%ebp),%eax
 129:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 12d:	83 e0 40             	and    $0x40,%eax
 130:	84 c0                	test   %al,%al
 132:	74 14                	je     148 <print_mode+0x12d>
    printf(1, "x");
 134:	83 ec 08             	sub    $0x8,%esp
 137:	68 7f 0a 00 00       	push   $0xa7f
 13c:	6a 01                	push   $0x1
 13e:	e8 78 05 00 00       	call   6bb <printf>
 143:	83 c4 10             	add    $0x10,%esp
 146:	eb 12                	jmp    15a <print_mode+0x13f>
  else
    printf(1, "-");
 148:	83 ec 08             	sub    $0x8,%esp
 14b:	68 73 0a 00 00       	push   $0xa73
 150:	6a 01                	push   $0x1
 152:	e8 64 05 00 00       	call   6bb <printf>
 157:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 161:	83 e0 20             	and    $0x20,%eax
 164:	84 c0                	test   %al,%al
 166:	74 14                	je     17c <print_mode+0x161>
    printf(1, "r");
 168:	83 ec 08             	sub    $0x8,%esp
 16b:	68 79 0a 00 00       	push   $0xa79
 170:	6a 01                	push   $0x1
 172:	e8 44 05 00 00       	call   6bb <printf>
 177:	83 c4 10             	add    $0x10,%esp
 17a:	eb 12                	jmp    18e <print_mode+0x173>
  else
    printf(1, "-");
 17c:	83 ec 08             	sub    $0x8,%esp
 17f:	68 73 0a 00 00       	push   $0xa73
 184:	6a 01                	push   $0x1
 186:	e8 30 05 00 00       	call   6bb <printf>
 18b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 195:	83 e0 10             	and    $0x10,%eax
 198:	84 c0                	test   %al,%al
 19a:	74 14                	je     1b0 <print_mode+0x195>
    printf(1, "w");
 19c:	83 ec 08             	sub    $0x8,%esp
 19f:	68 7b 0a 00 00       	push   $0xa7b
 1a4:	6a 01                	push   $0x1
 1a6:	e8 10 05 00 00       	call   6bb <printf>
 1ab:	83 c4 10             	add    $0x10,%esp
 1ae:	eb 12                	jmp    1c2 <print_mode+0x1a7>
  else
    printf(1, "-");
 1b0:	83 ec 08             	sub    $0x8,%esp
 1b3:	68 73 0a 00 00       	push   $0xa73
 1b8:	6a 01                	push   $0x1
 1ba:	e8 fc 04 00 00       	call   6bb <printf>
 1bf:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1c9:	83 e0 08             	and    $0x8,%eax
 1cc:	84 c0                	test   %al,%al
 1ce:	74 14                	je     1e4 <print_mode+0x1c9>
    printf(1, "x");
 1d0:	83 ec 08             	sub    $0x8,%esp
 1d3:	68 7f 0a 00 00       	push   $0xa7f
 1d8:	6a 01                	push   $0x1
 1da:	e8 dc 04 00 00       	call   6bb <printf>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	eb 12                	jmp    1f6 <print_mode+0x1db>
  else
    printf(1, "-");
 1e4:	83 ec 08             	sub    $0x8,%esp
 1e7:	68 73 0a 00 00       	push   $0xa73
 1ec:	6a 01                	push   $0x1
 1ee:	e8 c8 04 00 00       	call   6bb <printf>
 1f3:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1fd:	83 e0 04             	and    $0x4,%eax
 200:	84 c0                	test   %al,%al
 202:	74 14                	je     218 <print_mode+0x1fd>
    printf(1, "r");
 204:	83 ec 08             	sub    $0x8,%esp
 207:	68 79 0a 00 00       	push   $0xa79
 20c:	6a 01                	push   $0x1
 20e:	e8 a8 04 00 00       	call   6bb <printf>
 213:	83 c4 10             	add    $0x10,%esp
 216:	eb 12                	jmp    22a <print_mode+0x20f>
  else
    printf(1, "-");
 218:	83 ec 08             	sub    $0x8,%esp
 21b:	68 73 0a 00 00       	push   $0xa73
 220:	6a 01                	push   $0x1
 222:	e8 94 04 00 00       	call   6bb <printf>
 227:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 231:	83 e0 02             	and    $0x2,%eax
 234:	84 c0                	test   %al,%al
 236:	74 14                	je     24c <print_mode+0x231>
    printf(1, "w");
 238:	83 ec 08             	sub    $0x8,%esp
 23b:	68 7b 0a 00 00       	push   $0xa7b
 240:	6a 01                	push   $0x1
 242:	e8 74 04 00 00       	call   6bb <printf>
 247:	83 c4 10             	add    $0x10,%esp
 24a:	eb 12                	jmp    25e <print_mode+0x243>
  else
    printf(1, "-");
 24c:	83 ec 08             	sub    $0x8,%esp
 24f:	68 73 0a 00 00       	push   $0xa73
 254:	6a 01                	push   $0x1
 256:	e8 60 04 00 00       	call   6bb <printf>
 25b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 265:	83 e0 01             	and    $0x1,%eax
 268:	84 c0                	test   %al,%al
 26a:	74 14                	je     280 <print_mode+0x265>
    printf(1, "x");
 26c:	83 ec 08             	sub    $0x8,%esp
 26f:	68 7f 0a 00 00       	push   $0xa7f
 274:	6a 01                	push   $0x1
 276:	e8 40 04 00 00       	call   6bb <printf>
 27b:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 27e:	eb 13                	jmp    293 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 280:	83 ec 08             	sub    $0x8,%esp
 283:	68 73 0a 00 00       	push   $0xa73
 288:	6a 01                	push   $0x1
 28a:	e8 2c 04 00 00       	call   6bb <printf>
 28f:	83 c4 10             	add    $0x10,%esp

  return;
 292:	90                   	nop
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	57                   	push   %edi
 299:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 29a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 29d:	8b 55 10             	mov    0x10(%ebp),%edx
 2a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a3:	89 cb                	mov    %ecx,%ebx
 2a5:	89 df                	mov    %ebx,%edi
 2a7:	89 d1                	mov    %edx,%ecx
 2a9:	fc                   	cld    
 2aa:	f3 aa                	rep stos %al,%es:(%edi)
 2ac:	89 ca                	mov    %ecx,%edx
 2ae:	89 fb                	mov    %edi,%ebx
 2b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2b3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2b6:	90                   	nop
 2b7:	5b                   	pop    %ebx
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    

000002bb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
 2be:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2c7:	90                   	nop
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	8d 50 01             	lea    0x1(%eax),%edx
 2ce:	89 55 08             	mov    %edx,0x8(%ebp)
 2d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 2d4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2da:	0f b6 12             	movzbl (%edx),%edx
 2dd:	88 10                	mov    %dl,(%eax)
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	84 c0                	test   %al,%al
 2e4:	75 e2                	jne    2c8 <strcpy+0xd>
    ;
  return os;
 2e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2ee:	eb 08                	jmp    2f8 <strcmp+0xd>
    p++, q++;
 2f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	84 c0                	test   %al,%al
 300:	74 10                	je     312 <strcmp+0x27>
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 10             	movzbl (%eax),%edx
 308:	8b 45 0c             	mov    0xc(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	38 c2                	cmp    %al,%dl
 310:	74 de                	je     2f0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	0f b6 d0             	movzbl %al,%edx
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f b6 c0             	movzbl %al,%eax
 324:	29 c2                	sub    %eax,%edx
 326:	89 d0                	mov    %edx,%eax
}
 328:	5d                   	pop    %ebp
 329:	c3                   	ret    

0000032a <strlen>:

uint
strlen(char *s)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 337:	eb 04                	jmp    33d <strlen+0x13>
 339:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 33d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	01 d0                	add    %edx,%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	84 c0                	test   %al,%al
 34a:	75 ed                	jne    339 <strlen+0xf>
    ;
  return n;
 34c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 34f:	c9                   	leave  
 350:	c3                   	ret    

00000351 <memset>:

void*
memset(void *dst, int c, uint n)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 354:	8b 45 10             	mov    0x10(%ebp),%eax
 357:	50                   	push   %eax
 358:	ff 75 0c             	pushl  0xc(%ebp)
 35b:	ff 75 08             	pushl  0x8(%ebp)
 35e:	e8 32 ff ff ff       	call   295 <stosb>
 363:	83 c4 0c             	add    $0xc,%esp
  return dst;
 366:	8b 45 08             	mov    0x8(%ebp),%eax
}
 369:	c9                   	leave  
 36a:	c3                   	ret    

0000036b <strchr>:

char*
strchr(const char *s, char c)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 04             	sub    $0x4,%esp
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 377:	eb 14                	jmp    38d <strchr+0x22>
    if(*s == c)
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	0f b6 00             	movzbl (%eax),%eax
 37f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 382:	75 05                	jne    389 <strchr+0x1e>
      return (char*)s;
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	eb 13                	jmp    39c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 389:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	84 c0                	test   %al,%al
 395:	75 e2                	jne    379 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 397:	b8 00 00 00 00       	mov    $0x0,%eax
}
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <gets>:

char*
gets(char *buf, int max)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3ab:	eb 42                	jmp    3ef <gets+0x51>
    cc = read(0, &c, 1);
 3ad:	83 ec 04             	sub    $0x4,%esp
 3b0:	6a 01                	push   $0x1
 3b2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3b5:	50                   	push   %eax
 3b6:	6a 00                	push   $0x0
 3b8:	e8 47 01 00 00       	call   504 <read>
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c7:	7e 33                	jle    3fc <gets+0x5e>
      break;
    buf[i++] = c;
 3c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cc:	8d 50 01             	lea    0x1(%eax),%edx
 3cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d2:	89 c2                	mov    %eax,%edx
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	01 c2                	add    %eax,%edx
 3d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3dd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3df:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3e3:	3c 0a                	cmp    $0xa,%al
 3e5:	74 16                	je     3fd <gets+0x5f>
 3e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3eb:	3c 0d                	cmp    $0xd,%al
 3ed:	74 0e                	je     3fd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f2:	83 c0 01             	add    $0x1,%eax
 3f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3f8:	7c b3                	jl     3ad <gets+0xf>
 3fa:	eb 01                	jmp    3fd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3fc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	01 d0                	add    %edx,%eax
 405:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 408:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40b:	c9                   	leave  
 40c:	c3                   	ret    

0000040d <stat>:

int
stat(char *n, struct stat *st)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
 410:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 413:	83 ec 08             	sub    $0x8,%esp
 416:	6a 00                	push   $0x0
 418:	ff 75 08             	pushl  0x8(%ebp)
 41b:	e8 0c 01 00 00       	call   52c <open>
 420:	83 c4 10             	add    $0x10,%esp
 423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42a:	79 07                	jns    433 <stat+0x26>
    return -1;
 42c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 431:	eb 25                	jmp    458 <stat+0x4b>
  r = fstat(fd, st);
 433:	83 ec 08             	sub    $0x8,%esp
 436:	ff 75 0c             	pushl  0xc(%ebp)
 439:	ff 75 f4             	pushl  -0xc(%ebp)
 43c:	e8 03 01 00 00       	call   544 <fstat>
 441:	83 c4 10             	add    $0x10,%esp
 444:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 447:	83 ec 0c             	sub    $0xc,%esp
 44a:	ff 75 f4             	pushl  -0xc(%ebp)
 44d:	e8 c2 00 00 00       	call   514 <close>
 452:	83 c4 10             	add    $0x10,%esp
  return r;
 455:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 458:	c9                   	leave  
 459:	c3                   	ret    

0000045a <atoi>:

int
atoi(const char *s)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 467:	eb 25                	jmp    48e <atoi+0x34>
    n = n*10 + *s++ - '0';
 469:	8b 55 fc             	mov    -0x4(%ebp),%edx
 46c:	89 d0                	mov    %edx,%eax
 46e:	c1 e0 02             	shl    $0x2,%eax
 471:	01 d0                	add    %edx,%eax
 473:	01 c0                	add    %eax,%eax
 475:	89 c1                	mov    %eax,%ecx
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	8d 50 01             	lea    0x1(%eax),%edx
 47d:	89 55 08             	mov    %edx,0x8(%ebp)
 480:	0f b6 00             	movzbl (%eax),%eax
 483:	0f be c0             	movsbl %al,%eax
 486:	01 c8                	add    %ecx,%eax
 488:	83 e8 30             	sub    $0x30,%eax
 48b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	0f b6 00             	movzbl (%eax),%eax
 494:	3c 2f                	cmp    $0x2f,%al
 496:	7e 0a                	jle    4a2 <atoi+0x48>
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	3c 39                	cmp    $0x39,%al
 4a0:	7e c7                	jle    469 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4a5:	c9                   	leave  
 4a6:	c3                   	ret    

000004a7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4a7:	55                   	push   %ebp
 4a8:	89 e5                	mov    %esp,%ebp
 4aa:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4b9:	eb 17                	jmp    4d2 <memmove+0x2b>
    *dst++ = *src++;
 4bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4be:	8d 50 01             	lea    0x1(%eax),%edx
 4c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c7:	8d 4a 01             	lea    0x1(%edx),%ecx
 4ca:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4cd:	0f b6 12             	movzbl (%edx),%edx
 4d0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d2:	8b 45 10             	mov    0x10(%ebp),%eax
 4d5:	8d 50 ff             	lea    -0x1(%eax),%edx
 4d8:	89 55 10             	mov    %edx,0x10(%ebp)
 4db:	85 c0                	test   %eax,%eax
 4dd:	7f dc                	jg     4bb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    

000004e4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e4:	b8 01 00 00 00       	mov    $0x1,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <exit>:
SYSCALL(exit)
 4ec:	b8 02 00 00 00       	mov    $0x2,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <wait>:
SYSCALL(wait)
 4f4:	b8 03 00 00 00       	mov    $0x3,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <pipe>:
SYSCALL(pipe)
 4fc:	b8 04 00 00 00       	mov    $0x4,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <read>:
SYSCALL(read)
 504:	b8 05 00 00 00       	mov    $0x5,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <write>:
SYSCALL(write)
 50c:	b8 10 00 00 00       	mov    $0x10,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <close>:
SYSCALL(close)
 514:	b8 15 00 00 00       	mov    $0x15,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <kill>:
SYSCALL(kill)
 51c:	b8 06 00 00 00       	mov    $0x6,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <exec>:
SYSCALL(exec)
 524:	b8 07 00 00 00       	mov    $0x7,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <open>:
SYSCALL(open)
 52c:	b8 0f 00 00 00       	mov    $0xf,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <mknod>:
SYSCALL(mknod)
 534:	b8 11 00 00 00       	mov    $0x11,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <unlink>:
SYSCALL(unlink)
 53c:	b8 12 00 00 00       	mov    $0x12,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <fstat>:
SYSCALL(fstat)
 544:	b8 08 00 00 00       	mov    $0x8,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <link>:
SYSCALL(link)
 54c:	b8 13 00 00 00       	mov    $0x13,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <mkdir>:
SYSCALL(mkdir)
 554:	b8 14 00 00 00       	mov    $0x14,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <chdir>:
SYSCALL(chdir)
 55c:	b8 09 00 00 00       	mov    $0x9,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <dup>:
SYSCALL(dup)
 564:	b8 0a 00 00 00       	mov    $0xa,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <getpid>:
SYSCALL(getpid)
 56c:	b8 0b 00 00 00       	mov    $0xb,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <sbrk>:
SYSCALL(sbrk)
 574:	b8 0c 00 00 00       	mov    $0xc,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <sleep>:
SYSCALL(sleep)
 57c:	b8 0d 00 00 00       	mov    $0xd,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <uptime>:
SYSCALL(uptime)
 584:	b8 0e 00 00 00       	mov    $0xe,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <halt>:
SYSCALL(halt)
 58c:	b8 16 00 00 00       	mov    $0x16,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <date>:
//Student Implementations 
SYSCALL(date)
 594:	b8 17 00 00 00       	mov    $0x17,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <getuid>:

SYSCALL(getuid)
 59c:	b8 18 00 00 00       	mov    $0x18,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <getgid>:
SYSCALL(getgid)
 5a4:	b8 19 00 00 00       	mov    $0x19,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <getppid>:
SYSCALL(getppid)
 5ac:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <setuid>:

SYSCALL(setuid)
 5b4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <setgid>:
SYSCALL(setgid)
 5bc:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <getprocs>:
SYSCALL(getprocs)
 5c4:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <chown>:

SYSCALL(chown)
 5cc:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <chgrp>:
SYSCALL(chgrp)
 5d4:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <chmod>:
SYSCALL(chmod)
 5dc:	b8 20 00 00 00       	mov    $0x20,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	83 ec 18             	sub    $0x18,%esp
 5ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ed:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	6a 01                	push   $0x1
 5f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	pushl  0x8(%ebp)
 5fc:	e8 0b ff ff ff       	call   50c <write>
 601:	83 c4 10             	add    $0x10,%esp
}
 604:	90                   	nop
 605:	c9                   	leave  
 606:	c3                   	ret    

00000607 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	53                   	push   %ebx
 60b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 60e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 615:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 619:	74 17                	je     632 <printint+0x2b>
 61b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 61f:	79 11                	jns    632 <printint+0x2b>
    neg = 1;
 621:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 628:	8b 45 0c             	mov    0xc(%ebp),%eax
 62b:	f7 d8                	neg    %eax
 62d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 630:	eb 06                	jmp    638 <printint+0x31>
  } else {
    x = xx;
 632:	8b 45 0c             	mov    0xc(%ebp),%eax
 635:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 638:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 63f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 642:	8d 41 01             	lea    0x1(%ecx),%eax
 645:	89 45 f4             	mov    %eax,-0xc(%ebp)
 648:	8b 5d 10             	mov    0x10(%ebp),%ebx
 64b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64e:	ba 00 00 00 00       	mov    $0x0,%edx
 653:	f7 f3                	div    %ebx
 655:	89 d0                	mov    %edx,%eax
 657:	0f b6 80 f0 0c 00 00 	movzbl 0xcf0(%eax),%eax
 65e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 662:	8b 5d 10             	mov    0x10(%ebp),%ebx
 665:	8b 45 ec             	mov    -0x14(%ebp),%eax
 668:	ba 00 00 00 00       	mov    $0x0,%edx
 66d:	f7 f3                	div    %ebx
 66f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 672:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 676:	75 c7                	jne    63f <printint+0x38>
  if(neg)
 678:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 67c:	74 2d                	je     6ab <printint+0xa4>
    buf[i++] = '-';
 67e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 681:	8d 50 01             	lea    0x1(%eax),%edx
 684:	89 55 f4             	mov    %edx,-0xc(%ebp)
 687:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 68c:	eb 1d                	jmp    6ab <printint+0xa4>
    putc(fd, buf[i]);
 68e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 691:	8b 45 f4             	mov    -0xc(%ebp),%eax
 694:	01 d0                	add    %edx,%eax
 696:	0f b6 00             	movzbl (%eax),%eax
 699:	0f be c0             	movsbl %al,%eax
 69c:	83 ec 08             	sub    $0x8,%esp
 69f:	50                   	push   %eax
 6a0:	ff 75 08             	pushl  0x8(%ebp)
 6a3:	e8 3c ff ff ff       	call   5e4 <putc>
 6a8:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b3:	79 d9                	jns    68e <printint+0x87>
    putc(fd, buf[i]);
}
 6b5:	90                   	nop
 6b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6b9:	c9                   	leave  
 6ba:	c3                   	ret    

000006bb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6bb:	55                   	push   %ebp
 6bc:	89 e5                	mov    %esp,%ebp
 6be:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6c8:	8d 45 0c             	lea    0xc(%ebp),%eax
 6cb:	83 c0 04             	add    $0x4,%eax
 6ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6d8:	e9 59 01 00 00       	jmp    836 <printf+0x17b>
    c = fmt[i] & 0xff;
 6dd:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e3:	01 d0                	add    %edx,%eax
 6e5:	0f b6 00             	movzbl (%eax),%eax
 6e8:	0f be c0             	movsbl %al,%eax
 6eb:	25 ff 00 00 00       	and    $0xff,%eax
 6f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f7:	75 2c                	jne    725 <printf+0x6a>
      if(c == '%'){
 6f9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6fd:	75 0c                	jne    70b <printf+0x50>
        state = '%';
 6ff:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 706:	e9 27 01 00 00       	jmp    832 <printf+0x177>
      } else {
        putc(fd, c);
 70b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70e:	0f be c0             	movsbl %al,%eax
 711:	83 ec 08             	sub    $0x8,%esp
 714:	50                   	push   %eax
 715:	ff 75 08             	pushl  0x8(%ebp)
 718:	e8 c7 fe ff ff       	call   5e4 <putc>
 71d:	83 c4 10             	add    $0x10,%esp
 720:	e9 0d 01 00 00       	jmp    832 <printf+0x177>
      }
    } else if(state == '%'){
 725:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 729:	0f 85 03 01 00 00    	jne    832 <printf+0x177>
      if(c == 'd'){
 72f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 733:	75 1e                	jne    753 <printf+0x98>
        printint(fd, *ap, 10, 1);
 735:	8b 45 e8             	mov    -0x18(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	6a 01                	push   $0x1
 73c:	6a 0a                	push   $0xa
 73e:	50                   	push   %eax
 73f:	ff 75 08             	pushl  0x8(%ebp)
 742:	e8 c0 fe ff ff       	call   607 <printint>
 747:	83 c4 10             	add    $0x10,%esp
        ap++;
 74a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74e:	e9 d8 00 00 00       	jmp    82b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 753:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 757:	74 06                	je     75f <printf+0xa4>
 759:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 75d:	75 1e                	jne    77d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 75f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	6a 00                	push   $0x0
 766:	6a 10                	push   $0x10
 768:	50                   	push   %eax
 769:	ff 75 08             	pushl  0x8(%ebp)
 76c:	e8 96 fe ff ff       	call   607 <printint>
 771:	83 c4 10             	add    $0x10,%esp
        ap++;
 774:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 778:	e9 ae 00 00 00       	jmp    82b <printf+0x170>
      } else if(c == 's'){
 77d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 781:	75 43                	jne    7c6 <printf+0x10b>
        s = (char*)*ap;
 783:	8b 45 e8             	mov    -0x18(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 78b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 78f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 793:	75 25                	jne    7ba <printf+0xff>
          s = "(null)";
 795:	c7 45 f4 81 0a 00 00 	movl   $0xa81,-0xc(%ebp)
        while(*s != 0){
 79c:	eb 1c                	jmp    7ba <printf+0xff>
          putc(fd, *s);
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	0f b6 00             	movzbl (%eax),%eax
 7a4:	0f be c0             	movsbl %al,%eax
 7a7:	83 ec 08             	sub    $0x8,%esp
 7aa:	50                   	push   %eax
 7ab:	ff 75 08             	pushl  0x8(%ebp)
 7ae:	e8 31 fe ff ff       	call   5e4 <putc>
 7b3:	83 c4 10             	add    $0x10,%esp
          s++;
 7b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	0f b6 00             	movzbl (%eax),%eax
 7c0:	84 c0                	test   %al,%al
 7c2:	75 da                	jne    79e <printf+0xe3>
 7c4:	eb 65                	jmp    82b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ca:	75 1d                	jne    7e9 <printf+0x12e>
        putc(fd, *ap);
 7cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	0f be c0             	movsbl %al,%eax
 7d4:	83 ec 08             	sub    $0x8,%esp
 7d7:	50                   	push   %eax
 7d8:	ff 75 08             	pushl  0x8(%ebp)
 7db:	e8 04 fe ff ff       	call   5e4 <putc>
 7e0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e7:	eb 42                	jmp    82b <printf+0x170>
      } else if(c == '%'){
 7e9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ed:	75 17                	jne    806 <printf+0x14b>
        putc(fd, c);
 7ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f2:	0f be c0             	movsbl %al,%eax
 7f5:	83 ec 08             	sub    $0x8,%esp
 7f8:	50                   	push   %eax
 7f9:	ff 75 08             	pushl  0x8(%ebp)
 7fc:	e8 e3 fd ff ff       	call   5e4 <putc>
 801:	83 c4 10             	add    $0x10,%esp
 804:	eb 25                	jmp    82b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 806:	83 ec 08             	sub    $0x8,%esp
 809:	6a 25                	push   $0x25
 80b:	ff 75 08             	pushl  0x8(%ebp)
 80e:	e8 d1 fd ff ff       	call   5e4 <putc>
 813:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 819:	0f be c0             	movsbl %al,%eax
 81c:	83 ec 08             	sub    $0x8,%esp
 81f:	50                   	push   %eax
 820:	ff 75 08             	pushl  0x8(%ebp)
 823:	e8 bc fd ff ff       	call   5e4 <putc>
 828:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 82b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 832:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 836:	8b 55 0c             	mov    0xc(%ebp),%edx
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	01 d0                	add    %edx,%eax
 83e:	0f b6 00             	movzbl (%eax),%eax
 841:	84 c0                	test   %al,%al
 843:	0f 85 94 fe ff ff    	jne    6dd <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 849:	90                   	nop
 84a:	c9                   	leave  
 84b:	c3                   	ret    

0000084c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84c:	55                   	push   %ebp
 84d:	89 e5                	mov    %esp,%ebp
 84f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	83 e8 08             	sub    $0x8,%eax
 858:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85b:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 860:	89 45 fc             	mov    %eax,-0x4(%ebp)
 863:	eb 24                	jmp    889 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86d:	77 12                	ja     881 <free+0x35>
 86f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 872:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 875:	77 24                	ja     89b <free+0x4f>
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87f:	77 1a                	ja     89b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	89 45 fc             	mov    %eax,-0x4(%ebp)
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88f:	76 d4                	jbe    865 <free+0x19>
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 899:	76 ca                	jbe    865 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 89b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ab:	01 c2                	add    %eax,%edx
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	39 c2                	cmp    %eax,%edx
 8b4:	75 24                	jne    8da <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b9:	8b 50 04             	mov    0x4(%eax),%edx
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	8b 40 04             	mov    0x4(%eax),%eax
 8c4:	01 c2                	add    %eax,%edx
 8c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	8b 10                	mov    (%eax),%edx
 8d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d6:	89 10                	mov    %edx,(%eax)
 8d8:	eb 0a                	jmp    8e4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dd:	8b 10                	mov    (%eax),%edx
 8df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 40 04             	mov    0x4(%eax),%eax
 8ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f4:	01 d0                	add    %edx,%eax
 8f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f9:	75 20                	jne    91b <free+0xcf>
    p->s.size += bp->s.size;
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	8b 50 04             	mov    0x4(%eax),%edx
 901:	8b 45 f8             	mov    -0x8(%ebp),%eax
 904:	8b 40 04             	mov    0x4(%eax),%eax
 907:	01 c2                	add    %eax,%edx
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 90f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 912:	8b 10                	mov    (%eax),%edx
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	89 10                	mov    %edx,(%eax)
 919:	eb 08                	jmp    923 <free+0xd7>
  } else
    p->s.ptr = bp;
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 921:	89 10                	mov    %edx,(%eax)
  freep = p;
 923:	8b 45 fc             	mov    -0x4(%ebp),%eax
 926:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 92b:	90                   	nop
 92c:	c9                   	leave  
 92d:	c3                   	ret    

0000092e <morecore>:

static Header*
morecore(uint nu)
{
 92e:	55                   	push   %ebp
 92f:	89 e5                	mov    %esp,%ebp
 931:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 934:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 93b:	77 07                	ja     944 <morecore+0x16>
    nu = 4096;
 93d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 944:	8b 45 08             	mov    0x8(%ebp),%eax
 947:	c1 e0 03             	shl    $0x3,%eax
 94a:	83 ec 0c             	sub    $0xc,%esp
 94d:	50                   	push   %eax
 94e:	e8 21 fc ff ff       	call   574 <sbrk>
 953:	83 c4 10             	add    $0x10,%esp
 956:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 959:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 95d:	75 07                	jne    966 <morecore+0x38>
    return 0;
 95f:	b8 00 00 00 00       	mov    $0x0,%eax
 964:	eb 26                	jmp    98c <morecore+0x5e>
  hp = (Header*)p;
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 96c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96f:	8b 55 08             	mov    0x8(%ebp),%edx
 972:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 975:	8b 45 f0             	mov    -0x10(%ebp),%eax
 978:	83 c0 08             	add    $0x8,%eax
 97b:	83 ec 0c             	sub    $0xc,%esp
 97e:	50                   	push   %eax
 97f:	e8 c8 fe ff ff       	call   84c <free>
 984:	83 c4 10             	add    $0x10,%esp
  return freep;
 987:	a1 0c 0d 00 00       	mov    0xd0c,%eax
}
 98c:	c9                   	leave  
 98d:	c3                   	ret    

0000098e <malloc>:

void*
malloc(uint nbytes)
{
 98e:	55                   	push   %ebp
 98f:	89 e5                	mov    %esp,%ebp
 991:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 994:	8b 45 08             	mov    0x8(%ebp),%eax
 997:	83 c0 07             	add    $0x7,%eax
 99a:	c1 e8 03             	shr    $0x3,%eax
 99d:	83 c0 01             	add    $0x1,%eax
 9a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9a3:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 9a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9af:	75 23                	jne    9d4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9b1:	c7 45 f0 04 0d 00 00 	movl   $0xd04,-0x10(%ebp)
 9b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bb:	a3 0c 0d 00 00       	mov    %eax,0xd0c
 9c0:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 9c5:	a3 04 0d 00 00       	mov    %eax,0xd04
    base.s.size = 0;
 9ca:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 9d1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d7:	8b 00                	mov    (%eax),%eax
 9d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9df:	8b 40 04             	mov    0x4(%eax),%eax
 9e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e5:	72 4d                	jb     a34 <malloc+0xa6>
      if(p->s.size == nunits)
 9e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ea:	8b 40 04             	mov    0x4(%eax),%eax
 9ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9f0:	75 0c                	jne    9fe <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f5:	8b 10                	mov    (%eax),%edx
 9f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fa:	89 10                	mov    %edx,(%eax)
 9fc:	eb 26                	jmp    a24 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a01:	8b 40 04             	mov    0x4(%eax),%eax
 a04:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a07:	89 c2                	mov    %eax,%edx
 a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	8b 40 04             	mov    0x4(%eax),%eax
 a15:	c1 e0 03             	shl    $0x3,%eax
 a18:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a21:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a27:	a3 0c 0d 00 00       	mov    %eax,0xd0c
      return (void*)(p + 1);
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	83 c0 08             	add    $0x8,%eax
 a32:	eb 3b                	jmp    a6f <malloc+0xe1>
    }
    if(p == freep)
 a34:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 a39:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a3c:	75 1e                	jne    a5c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a3e:	83 ec 0c             	sub    $0xc,%esp
 a41:	ff 75 ec             	pushl  -0x14(%ebp)
 a44:	e8 e5 fe ff ff       	call   92e <morecore>
 a49:	83 c4 10             	add    $0x10,%esp
 a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a53:	75 07                	jne    a5c <malloc+0xce>
        return 0;
 a55:	b8 00 00 00 00       	mov    $0x0,%eax
 a5a:	eb 13                	jmp    a6f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a65:	8b 00                	mov    (%eax),%eax
 a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a6a:	e9 6d ff ff ff       	jmp    9dc <malloc+0x4e>
}
 a6f:	c9                   	leave  
 a70:	c3                   	ret    
