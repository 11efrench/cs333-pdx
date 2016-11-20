
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
  11:	e8 7f 05 00 00       	call   595 <halt>
  return 0;
  16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1b:	83 c4 04             	add    $0x4,%esp
  1e:	59                   	pop    %ecx
  1f:	5d                   	pop    %ebp
  20:	8d 61 fc             	lea    -0x4(%ecx),%esp
  23:	c3                   	ret    

00000024 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  2a:	8b 45 08             	mov    0x8(%ebp),%eax
  2d:	0f b7 00             	movzwl (%eax),%eax
  30:	98                   	cwtl   
  31:	83 f8 02             	cmp    $0x2,%eax
  34:	74 1e                	je     54 <print_mode+0x30>
  36:	83 f8 03             	cmp    $0x3,%eax
  39:	74 2d                	je     68 <print_mode+0x44>
  3b:	83 f8 01             	cmp    $0x1,%eax
  3e:	75 3c                	jne    7c <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  40:	83 ec 08             	sub    $0x8,%esp
  43:	68 62 0a 00 00       	push   $0xa62
  48:	6a 01                	push   $0x1
  4a:	e8 5d 06 00 00       	call   6ac <printf>
  4f:	83 c4 10             	add    $0x10,%esp
  52:	eb 3a                	jmp    8e <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  54:	83 ec 08             	sub    $0x8,%esp
  57:	68 64 0a 00 00       	push   $0xa64
  5c:	6a 01                	push   $0x1
  5e:	e8 49 06 00 00       	call   6ac <printf>
  63:	83 c4 10             	add    $0x10,%esp
  66:	eb 26                	jmp    8e <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  68:	83 ec 08             	sub    $0x8,%esp
  6b:	68 66 0a 00 00       	push   $0xa66
  70:	6a 01                	push   $0x1
  72:	e8 35 06 00 00       	call   6ac <printf>
  77:	83 c4 10             	add    $0x10,%esp
  7a:	eb 12                	jmp    8e <print_mode+0x6a>
    default: printf(1, "?");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 68 0a 00 00       	push   $0xa68
  84:	6a 01                	push   $0x1
  86:	e8 21 06 00 00       	call   6ac <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  8e:	8b 45 08             	mov    0x8(%ebp),%eax
  91:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  95:	83 e0 01             	and    $0x1,%eax
  98:	84 c0                	test   %al,%al
  9a:	74 14                	je     b0 <print_mode+0x8c>
    printf(1, "r");
  9c:	83 ec 08             	sub    $0x8,%esp
  9f:	68 6a 0a 00 00       	push   $0xa6a
  a4:	6a 01                	push   $0x1
  a6:	e8 01 06 00 00       	call   6ac <printf>
  ab:	83 c4 10             	add    $0x10,%esp
  ae:	eb 12                	jmp    c2 <print_mode+0x9e>
  else
    printf(1, "-");
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	68 64 0a 00 00       	push   $0xa64
  b8:	6a 01                	push   $0x1
  ba:	e8 ed 05 00 00       	call   6ac <printf>
  bf:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  c9:	83 e0 80             	and    $0xffffff80,%eax
  cc:	84 c0                	test   %al,%al
  ce:	74 14                	je     e4 <print_mode+0xc0>
    printf(1, "w");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 6c 0a 00 00       	push   $0xa6c
  d8:	6a 01                	push   $0x1
  da:	e8 cd 05 00 00       	call   6ac <printf>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 12                	jmp    f6 <print_mode+0xd2>
  else
    printf(1, "-");
  e4:	83 ec 08             	sub    $0x8,%esp
  e7:	68 64 0a 00 00       	push   $0xa64
  ec:	6a 01                	push   $0x1
  ee:	e8 b9 05 00 00       	call   6ac <printf>
  f3:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
  fd:	c0 e8 06             	shr    $0x6,%al
 100:	83 e0 01             	and    $0x1,%eax
 103:	0f b6 d0             	movzbl %al,%edx
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 10d:	d0 e8                	shr    %al
 10f:	83 e0 01             	and    $0x1,%eax
 112:	0f b6 c0             	movzbl %al,%eax
 115:	21 d0                	and    %edx,%eax
 117:	85 c0                	test   %eax,%eax
 119:	74 14                	je     12f <print_mode+0x10b>
    printf(1, "S");
 11b:	83 ec 08             	sub    $0x8,%esp
 11e:	68 6e 0a 00 00       	push   $0xa6e
 123:	6a 01                	push   $0x1
 125:	e8 82 05 00 00       	call   6ac <printf>
 12a:	83 c4 10             	add    $0x10,%esp
 12d:	eb 34                	jmp    163 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 136:	83 e0 40             	and    $0x40,%eax
 139:	84 c0                	test   %al,%al
 13b:	74 14                	je     151 <print_mode+0x12d>
    printf(1, "x");
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	68 70 0a 00 00       	push   $0xa70
 145:	6a 01                	push   $0x1
 147:	e8 60 05 00 00       	call   6ac <printf>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	eb 12                	jmp    163 <print_mode+0x13f>
  else
    printf(1, "-");
 151:	83 ec 08             	sub    $0x8,%esp
 154:	68 64 0a 00 00       	push   $0xa64
 159:	6a 01                	push   $0x1
 15b:	e8 4c 05 00 00       	call   6ac <printf>
 160:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 16a:	83 e0 20             	and    $0x20,%eax
 16d:	84 c0                	test   %al,%al
 16f:	74 14                	je     185 <print_mode+0x161>
    printf(1, "r");
 171:	83 ec 08             	sub    $0x8,%esp
 174:	68 6a 0a 00 00       	push   $0xa6a
 179:	6a 01                	push   $0x1
 17b:	e8 2c 05 00 00       	call   6ac <printf>
 180:	83 c4 10             	add    $0x10,%esp
 183:	eb 12                	jmp    197 <print_mode+0x173>
  else
    printf(1, "-");
 185:	83 ec 08             	sub    $0x8,%esp
 188:	68 64 0a 00 00       	push   $0xa64
 18d:	6a 01                	push   $0x1
 18f:	e8 18 05 00 00       	call   6ac <printf>
 194:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 19e:	83 e0 10             	and    $0x10,%eax
 1a1:	84 c0                	test   %al,%al
 1a3:	74 14                	je     1b9 <print_mode+0x195>
    printf(1, "w");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 6c 0a 00 00       	push   $0xa6c
 1ad:	6a 01                	push   $0x1
 1af:	e8 f8 04 00 00       	call   6ac <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
 1b7:	eb 12                	jmp    1cb <print_mode+0x1a7>
  else
    printf(1, "-");
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	68 64 0a 00 00       	push   $0xa64
 1c1:	6a 01                	push   $0x1
 1c3:	e8 e4 04 00 00       	call   6ac <printf>
 1c8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1d2:	83 e0 08             	and    $0x8,%eax
 1d5:	84 c0                	test   %al,%al
 1d7:	74 14                	je     1ed <print_mode+0x1c9>
    printf(1, "x");
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	68 70 0a 00 00       	push   $0xa70
 1e1:	6a 01                	push   $0x1
 1e3:	e8 c4 04 00 00       	call   6ac <printf>
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	eb 12                	jmp    1ff <print_mode+0x1db>
  else
    printf(1, "-");
 1ed:	83 ec 08             	sub    $0x8,%esp
 1f0:	68 64 0a 00 00       	push   $0xa64
 1f5:	6a 01                	push   $0x1
 1f7:	e8 b0 04 00 00       	call   6ac <printf>
 1fc:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 206:	83 e0 04             	and    $0x4,%eax
 209:	84 c0                	test   %al,%al
 20b:	74 14                	je     221 <print_mode+0x1fd>
    printf(1, "r");
 20d:	83 ec 08             	sub    $0x8,%esp
 210:	68 6a 0a 00 00       	push   $0xa6a
 215:	6a 01                	push   $0x1
 217:	e8 90 04 00 00       	call   6ac <printf>
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	eb 12                	jmp    233 <print_mode+0x20f>
  else
    printf(1, "-");
 221:	83 ec 08             	sub    $0x8,%esp
 224:	68 64 0a 00 00       	push   $0xa64
 229:	6a 01                	push   $0x1
 22b:	e8 7c 04 00 00       	call   6ac <printf>
 230:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 23a:	83 e0 02             	and    $0x2,%eax
 23d:	84 c0                	test   %al,%al
 23f:	74 14                	je     255 <print_mode+0x231>
    printf(1, "w");
 241:	83 ec 08             	sub    $0x8,%esp
 244:	68 6c 0a 00 00       	push   $0xa6c
 249:	6a 01                	push   $0x1
 24b:	e8 5c 04 00 00       	call   6ac <printf>
 250:	83 c4 10             	add    $0x10,%esp
 253:	eb 12                	jmp    267 <print_mode+0x243>
  else
    printf(1, "-");
 255:	83 ec 08             	sub    $0x8,%esp
 258:	68 64 0a 00 00       	push   $0xa64
 25d:	6a 01                	push   $0x1
 25f:	e8 48 04 00 00       	call   6ac <printf>
 264:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 26e:	83 e0 01             	and    $0x1,%eax
 271:	84 c0                	test   %al,%al
 273:	74 14                	je     289 <print_mode+0x265>
    printf(1, "x");
 275:	83 ec 08             	sub    $0x8,%esp
 278:	68 70 0a 00 00       	push   $0xa70
 27d:	6a 01                	push   $0x1
 27f:	e8 28 04 00 00       	call   6ac <printf>
 284:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 287:	eb 13                	jmp    29c <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	68 64 0a 00 00       	push   $0xa64
 291:	6a 01                	push   $0x1
 293:	e8 14 04 00 00       	call   6ac <printf>
 298:	83 c4 10             	add    $0x10,%esp

  return;
 29b:	90                   	nop
}
 29c:	c9                   	leave  
 29d:	c3                   	ret    

0000029e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
 2a1:	57                   	push   %edi
 2a2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a6:	8b 55 10             	mov    0x10(%ebp),%edx
 2a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ac:	89 cb                	mov    %ecx,%ebx
 2ae:	89 df                	mov    %ebx,%edi
 2b0:	89 d1                	mov    %edx,%ecx
 2b2:	fc                   	cld    
 2b3:	f3 aa                	rep stos %al,%es:(%edi)
 2b5:	89 ca                	mov    %ecx,%edx
 2b7:	89 fb                	mov    %edi,%ebx
 2b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2bc:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2bf:	90                   	nop
 2c0:	5b                   	pop    %ebx
 2c1:	5f                   	pop    %edi
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    

000002c4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2d0:	90                   	nop
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	8d 50 01             	lea    0x1(%eax),%edx
 2d7:	89 55 08             	mov    %edx,0x8(%ebp)
 2da:	8b 55 0c             	mov    0xc(%ebp),%edx
 2dd:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2e3:	0f b6 12             	movzbl (%edx),%edx
 2e6:	88 10                	mov    %dl,(%eax)
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	84 c0                	test   %al,%al
 2ed:	75 e2                	jne    2d1 <strcpy+0xd>
    ;
  return os;
 2ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2f7:	eb 08                	jmp    301 <strcmp+0xd>
    p++, q++;
 2f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2fd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	84 c0                	test   %al,%al
 309:	74 10                	je     31b <strcmp+0x27>
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	0f b6 10             	movzbl (%eax),%edx
 311:	8b 45 0c             	mov    0xc(%ebp),%eax
 314:	0f b6 00             	movzbl (%eax),%eax
 317:	38 c2                	cmp    %al,%dl
 319:	74 de                	je     2f9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f b6 d0             	movzbl %al,%edx
 324:	8b 45 0c             	mov    0xc(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	0f b6 c0             	movzbl %al,%eax
 32d:	29 c2                	sub    %eax,%edx
 32f:	89 d0                	mov    %edx,%eax
}
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    

00000333 <strlen>:

uint
strlen(char *s)
{
 333:	55                   	push   %ebp
 334:	89 e5                	mov    %esp,%ebp
 336:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 339:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 340:	eb 04                	jmp    346 <strlen+0x13>
 342:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 346:	8b 55 fc             	mov    -0x4(%ebp),%edx
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	01 d0                	add    %edx,%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	84 c0                	test   %al,%al
 353:	75 ed                	jne    342 <strlen+0xf>
    ;
  return n;
 355:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 358:	c9                   	leave  
 359:	c3                   	ret    

0000035a <memset>:

void*
memset(void *dst, int c, uint n)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 35d:	8b 45 10             	mov    0x10(%ebp),%eax
 360:	50                   	push   %eax
 361:	ff 75 0c             	pushl  0xc(%ebp)
 364:	ff 75 08             	pushl  0x8(%ebp)
 367:	e8 32 ff ff ff       	call   29e <stosb>
 36c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 372:	c9                   	leave  
 373:	c3                   	ret    

00000374 <strchr>:

char*
strchr(const char *s, char c)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 04             	sub    $0x4,%esp
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 380:	eb 14                	jmp    396 <strchr+0x22>
    if(*s == c)
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	0f b6 00             	movzbl (%eax),%eax
 388:	3a 45 fc             	cmp    -0x4(%ebp),%al
 38b:	75 05                	jne    392 <strchr+0x1e>
      return (char*)s;
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	eb 13                	jmp    3a5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 392:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	84 c0                	test   %al,%al
 39e:	75 e2                	jne    382 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    

000003a7 <gets>:

char*
gets(char *buf, int max)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3b4:	eb 42                	jmp    3f8 <gets+0x51>
    cc = read(0, &c, 1);
 3b6:	83 ec 04             	sub    $0x4,%esp
 3b9:	6a 01                	push   $0x1
 3bb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3be:	50                   	push   %eax
 3bf:	6a 00                	push   $0x0
 3c1:	e8 47 01 00 00       	call   50d <read>
 3c6:	83 c4 10             	add    $0x10,%esp
 3c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d0:	7e 33                	jle    405 <gets+0x5e>
      break;
    buf[i++] = c;
 3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d5:	8d 50 01             	lea    0x1(%eax),%edx
 3d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3db:	89 c2                	mov    %eax,%edx
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	01 c2                	add    %eax,%edx
 3e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3e6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3e8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ec:	3c 0a                	cmp    $0xa,%al
 3ee:	74 16                	je     406 <gets+0x5f>
 3f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f4:	3c 0d                	cmp    $0xd,%al
 3f6:	74 0e                	je     406 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fb:	83 c0 01             	add    $0x1,%eax
 3fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
 401:	7c b3                	jl     3b6 <gets+0xf>
 403:	eb 01                	jmp    406 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 405:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 406:	8b 55 f4             	mov    -0xc(%ebp),%edx
 409:	8b 45 08             	mov    0x8(%ebp),%eax
 40c:	01 d0                	add    %edx,%eax
 40e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 411:	8b 45 08             	mov    0x8(%ebp),%eax
}
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <stat>:

int
stat(char *n, struct stat *st)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
 419:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41c:	83 ec 08             	sub    $0x8,%esp
 41f:	6a 00                	push   $0x0
 421:	ff 75 08             	pushl  0x8(%ebp)
 424:	e8 0c 01 00 00       	call   535 <open>
 429:	83 c4 10             	add    $0x10,%esp
 42c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 42f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 433:	79 07                	jns    43c <stat+0x26>
    return -1;
 435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43a:	eb 25                	jmp    461 <stat+0x4b>
  r = fstat(fd, st);
 43c:	83 ec 08             	sub    $0x8,%esp
 43f:	ff 75 0c             	pushl  0xc(%ebp)
 442:	ff 75 f4             	pushl  -0xc(%ebp)
 445:	e8 03 01 00 00       	call   54d <fstat>
 44a:	83 c4 10             	add    $0x10,%esp
 44d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 450:	83 ec 0c             	sub    $0xc,%esp
 453:	ff 75 f4             	pushl  -0xc(%ebp)
 456:	e8 c2 00 00 00       	call   51d <close>
 45b:	83 c4 10             	add    $0x10,%esp
  return r;
 45e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 461:	c9                   	leave  
 462:	c3                   	ret    

00000463 <atoi>:

int
atoi(const char *s)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 470:	eb 25                	jmp    497 <atoi+0x34>
    n = n*10 + *s++ - '0';
 472:	8b 55 fc             	mov    -0x4(%ebp),%edx
 475:	89 d0                	mov    %edx,%eax
 477:	c1 e0 02             	shl    $0x2,%eax
 47a:	01 d0                	add    %edx,%eax
 47c:	01 c0                	add    %eax,%eax
 47e:	89 c1                	mov    %eax,%ecx
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	8d 50 01             	lea    0x1(%eax),%edx
 486:	89 55 08             	mov    %edx,0x8(%ebp)
 489:	0f b6 00             	movzbl (%eax),%eax
 48c:	0f be c0             	movsbl %al,%eax
 48f:	01 c8                	add    %ecx,%eax
 491:	83 e8 30             	sub    $0x30,%eax
 494:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	0f b6 00             	movzbl (%eax),%eax
 49d:	3c 2f                	cmp    $0x2f,%al
 49f:	7e 0a                	jle    4ab <atoi+0x48>
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	0f b6 00             	movzbl (%eax),%eax
 4a7:	3c 39                	cmp    $0x39,%al
 4a9:	7e c7                	jle    472 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4ae:	c9                   	leave  
 4af:	c3                   	ret    

000004b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4c2:	eb 17                	jmp    4db <memmove+0x2b>
    *dst++ = *src++;
 4c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c7:	8d 50 01             	lea    0x1(%eax),%edx
 4ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4d0:	8d 4a 01             	lea    0x1(%edx),%ecx
 4d3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4d6:	0f b6 12             	movzbl (%edx),%edx
 4d9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4db:	8b 45 10             	mov    0x10(%ebp),%eax
 4de:	8d 50 ff             	lea    -0x1(%eax),%edx
 4e1:	89 55 10             	mov    %edx,0x10(%ebp)
 4e4:	85 c0                	test   %eax,%eax
 4e6:	7f dc                	jg     4c4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4eb:	c9                   	leave  
 4ec:	c3                   	ret    

000004ed <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ed:	b8 01 00 00 00       	mov    $0x1,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <exit>:
SYSCALL(exit)
 4f5:	b8 02 00 00 00       	mov    $0x2,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <wait>:
SYSCALL(wait)
 4fd:	b8 03 00 00 00       	mov    $0x3,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <pipe>:
SYSCALL(pipe)
 505:	b8 04 00 00 00       	mov    $0x4,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <read>:
SYSCALL(read)
 50d:	b8 05 00 00 00       	mov    $0x5,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <write>:
SYSCALL(write)
 515:	b8 10 00 00 00       	mov    $0x10,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <close>:
SYSCALL(close)
 51d:	b8 15 00 00 00       	mov    $0x15,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <kill>:
SYSCALL(kill)
 525:	b8 06 00 00 00       	mov    $0x6,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <exec>:
SYSCALL(exec)
 52d:	b8 07 00 00 00       	mov    $0x7,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <open>:
SYSCALL(open)
 535:	b8 0f 00 00 00       	mov    $0xf,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <mknod>:
SYSCALL(mknod)
 53d:	b8 11 00 00 00       	mov    $0x11,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <unlink>:
SYSCALL(unlink)
 545:	b8 12 00 00 00       	mov    $0x12,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <fstat>:
SYSCALL(fstat)
 54d:	b8 08 00 00 00       	mov    $0x8,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <link>:
SYSCALL(link)
 555:	b8 13 00 00 00       	mov    $0x13,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <mkdir>:
SYSCALL(mkdir)
 55d:	b8 14 00 00 00       	mov    $0x14,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <chdir>:
SYSCALL(chdir)
 565:	b8 09 00 00 00       	mov    $0x9,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <dup>:
SYSCALL(dup)
 56d:	b8 0a 00 00 00       	mov    $0xa,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <getpid>:
SYSCALL(getpid)
 575:	b8 0b 00 00 00       	mov    $0xb,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <sbrk>:
SYSCALL(sbrk)
 57d:	b8 0c 00 00 00       	mov    $0xc,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <sleep>:
SYSCALL(sleep)
 585:	b8 0d 00 00 00       	mov    $0xd,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <uptime>:
SYSCALL(uptime)
 58d:	b8 0e 00 00 00       	mov    $0xe,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <halt>:
SYSCALL(halt)
 595:	b8 16 00 00 00       	mov    $0x16,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <date>:
//Student Implementations 
SYSCALL(date)
 59d:	b8 17 00 00 00       	mov    $0x17,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <getuid>:

SYSCALL(getuid)
 5a5:	b8 18 00 00 00       	mov    $0x18,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <getgid>:
SYSCALL(getgid)
 5ad:	b8 19 00 00 00       	mov    $0x19,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <getppid>:
SYSCALL(getppid)
 5b5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <setuid>:

SYSCALL(setuid)
 5bd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <setgid>:
SYSCALL(setgid)
 5c5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <getprocs>:
SYSCALL(getprocs)
 5cd:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5d5:	55                   	push   %ebp
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	83 ec 18             	sub    $0x18,%esp
 5db:	8b 45 0c             	mov    0xc(%ebp),%eax
 5de:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5e1:	83 ec 04             	sub    $0x4,%esp
 5e4:	6a 01                	push   $0x1
 5e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 23 ff ff ff       	call   515 <write>
 5f2:	83 c4 10             	add    $0x10,%esp
}
 5f5:	90                   	nop
 5f6:	c9                   	leave  
 5f7:	c3                   	ret    

000005f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f8:	55                   	push   %ebp
 5f9:	89 e5                	mov    %esp,%ebp
 5fb:	53                   	push   %ebx
 5fc:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 606:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 60a:	74 17                	je     623 <printint+0x2b>
 60c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 610:	79 11                	jns    623 <printint+0x2b>
    neg = 1;
 612:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 619:	8b 45 0c             	mov    0xc(%ebp),%eax
 61c:	f7 d8                	neg    %eax
 61e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 621:	eb 06                	jmp    629 <printint+0x31>
  } else {
    x = xx;
 623:	8b 45 0c             	mov    0xc(%ebp),%eax
 626:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 630:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 633:	8d 41 01             	lea    0x1(%ecx),%eax
 636:	89 45 f4             	mov    %eax,-0xc(%ebp)
 639:	8b 5d 10             	mov    0x10(%ebp),%ebx
 63c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 63f:	ba 00 00 00 00       	mov    $0x0,%edx
 644:	f7 f3                	div    %ebx
 646:	89 d0                	mov    %edx,%eax
 648:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 64f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 653:	8b 5d 10             	mov    0x10(%ebp),%ebx
 656:	8b 45 ec             	mov    -0x14(%ebp),%eax
 659:	ba 00 00 00 00       	mov    $0x0,%edx
 65e:	f7 f3                	div    %ebx
 660:	89 45 ec             	mov    %eax,-0x14(%ebp)
 663:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 667:	75 c7                	jne    630 <printint+0x38>
  if(neg)
 669:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 66d:	74 2d                	je     69c <printint+0xa4>
    buf[i++] = '-';
 66f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 672:	8d 50 01             	lea    0x1(%eax),%edx
 675:	89 55 f4             	mov    %edx,-0xc(%ebp)
 678:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 67d:	eb 1d                	jmp    69c <printint+0xa4>
    putc(fd, buf[i]);
 67f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 682:	8b 45 f4             	mov    -0xc(%ebp),%eax
 685:	01 d0                	add    %edx,%eax
 687:	0f b6 00             	movzbl (%eax),%eax
 68a:	0f be c0             	movsbl %al,%eax
 68d:	83 ec 08             	sub    $0x8,%esp
 690:	50                   	push   %eax
 691:	ff 75 08             	pushl  0x8(%ebp)
 694:	e8 3c ff ff ff       	call   5d5 <putc>
 699:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 69c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a4:	79 d9                	jns    67f <printint+0x87>
    putc(fd, buf[i]);
}
 6a6:	90                   	nop
 6a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6aa:	c9                   	leave  
 6ab:	c3                   	ret    

000006ac <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6b9:	8d 45 0c             	lea    0xc(%ebp),%eax
 6bc:	83 c0 04             	add    $0x4,%eax
 6bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6c9:	e9 59 01 00 00       	jmp    827 <printf+0x17b>
    c = fmt[i] & 0xff;
 6ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d4:	01 d0                	add    %edx,%eax
 6d6:	0f b6 00             	movzbl (%eax),%eax
 6d9:	0f be c0             	movsbl %al,%eax
 6dc:	25 ff 00 00 00       	and    $0xff,%eax
 6e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e8:	75 2c                	jne    716 <printf+0x6a>
      if(c == '%'){
 6ea:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ee:	75 0c                	jne    6fc <printf+0x50>
        state = '%';
 6f0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6f7:	e9 27 01 00 00       	jmp    823 <printf+0x177>
      } else {
        putc(fd, c);
 6fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ff:	0f be c0             	movsbl %al,%eax
 702:	83 ec 08             	sub    $0x8,%esp
 705:	50                   	push   %eax
 706:	ff 75 08             	pushl  0x8(%ebp)
 709:	e8 c7 fe ff ff       	call   5d5 <putc>
 70e:	83 c4 10             	add    $0x10,%esp
 711:	e9 0d 01 00 00       	jmp    823 <printf+0x177>
      }
    } else if(state == '%'){
 716:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 71a:	0f 85 03 01 00 00    	jne    823 <printf+0x177>
      if(c == 'd'){
 720:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 724:	75 1e                	jne    744 <printf+0x98>
        printint(fd, *ap, 10, 1);
 726:	8b 45 e8             	mov    -0x18(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	6a 01                	push   $0x1
 72d:	6a 0a                	push   $0xa
 72f:	50                   	push   %eax
 730:	ff 75 08             	pushl  0x8(%ebp)
 733:	e8 c0 fe ff ff       	call   5f8 <printint>
 738:	83 c4 10             	add    $0x10,%esp
        ap++;
 73b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73f:	e9 d8 00 00 00       	jmp    81c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 744:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 748:	74 06                	je     750 <printf+0xa4>
 74a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 74e:	75 1e                	jne    76e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 750:	8b 45 e8             	mov    -0x18(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	6a 00                	push   $0x0
 757:	6a 10                	push   $0x10
 759:	50                   	push   %eax
 75a:	ff 75 08             	pushl  0x8(%ebp)
 75d:	e8 96 fe ff ff       	call   5f8 <printint>
 762:	83 c4 10             	add    $0x10,%esp
        ap++;
 765:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 769:	e9 ae 00 00 00       	jmp    81c <printf+0x170>
      } else if(c == 's'){
 76e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 772:	75 43                	jne    7b7 <printf+0x10b>
        s = (char*)*ap;
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 77c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 784:	75 25                	jne    7ab <printf+0xff>
          s = "(null)";
 786:	c7 45 f4 72 0a 00 00 	movl   $0xa72,-0xc(%ebp)
        while(*s != 0){
 78d:	eb 1c                	jmp    7ab <printf+0xff>
          putc(fd, *s);
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	0f b6 00             	movzbl (%eax),%eax
 795:	0f be c0             	movsbl %al,%eax
 798:	83 ec 08             	sub    $0x8,%esp
 79b:	50                   	push   %eax
 79c:	ff 75 08             	pushl  0x8(%ebp)
 79f:	e8 31 fe ff ff       	call   5d5 <putc>
 7a4:	83 c4 10             	add    $0x10,%esp
          s++;
 7a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	0f b6 00             	movzbl (%eax),%eax
 7b1:	84 c0                	test   %al,%al
 7b3:	75 da                	jne    78f <printf+0xe3>
 7b5:	eb 65                	jmp    81c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7b7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7bb:	75 1d                	jne    7da <printf+0x12e>
        putc(fd, *ap);
 7bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	0f be c0             	movsbl %al,%eax
 7c5:	83 ec 08             	sub    $0x8,%esp
 7c8:	50                   	push   %eax
 7c9:	ff 75 08             	pushl  0x8(%ebp)
 7cc:	e8 04 fe ff ff       	call   5d5 <putc>
 7d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d8:	eb 42                	jmp    81c <printf+0x170>
      } else if(c == '%'){
 7da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7de:	75 17                	jne    7f7 <printf+0x14b>
        putc(fd, c);
 7e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e3:	0f be c0             	movsbl %al,%eax
 7e6:	83 ec 08             	sub    $0x8,%esp
 7e9:	50                   	push   %eax
 7ea:	ff 75 08             	pushl  0x8(%ebp)
 7ed:	e8 e3 fd ff ff       	call   5d5 <putc>
 7f2:	83 c4 10             	add    $0x10,%esp
 7f5:	eb 25                	jmp    81c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f7:	83 ec 08             	sub    $0x8,%esp
 7fa:	6a 25                	push   $0x25
 7fc:	ff 75 08             	pushl  0x8(%ebp)
 7ff:	e8 d1 fd ff ff       	call   5d5 <putc>
 804:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80a:	0f be c0             	movsbl %al,%eax
 80d:	83 ec 08             	sub    $0x8,%esp
 810:	50                   	push   %eax
 811:	ff 75 08             	pushl  0x8(%ebp)
 814:	e8 bc fd ff ff       	call   5d5 <putc>
 819:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 81c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 823:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 827:	8b 55 0c             	mov    0xc(%ebp),%edx
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	01 d0                	add    %edx,%eax
 82f:	0f b6 00             	movzbl (%eax),%eax
 832:	84 c0                	test   %al,%al
 834:	0f 85 94 fe ff ff    	jne    6ce <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 83a:	90                   	nop
 83b:	c9                   	leave  
 83c:	c3                   	ret    

0000083d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83d:	55                   	push   %ebp
 83e:	89 e5                	mov    %esp,%ebp
 840:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	83 e8 08             	sub    $0x8,%eax
 849:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	a1 08 0d 00 00       	mov    0xd08,%eax
 851:	89 45 fc             	mov    %eax,-0x4(%ebp)
 854:	eb 24                	jmp    87a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	8b 45 fc             	mov    -0x4(%ebp),%eax
 859:	8b 00                	mov    (%eax),%eax
 85b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 85e:	77 12                	ja     872 <free+0x35>
 860:	8b 45 f8             	mov    -0x8(%ebp),%eax
 863:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 866:	77 24                	ja     88c <free+0x4f>
 868:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86b:	8b 00                	mov    (%eax),%eax
 86d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 870:	77 1a                	ja     88c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 872:	8b 45 fc             	mov    -0x4(%ebp),%eax
 875:	8b 00                	mov    (%eax),%eax
 877:	89 45 fc             	mov    %eax,-0x4(%ebp)
 87a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 880:	76 d4                	jbe    856 <free+0x19>
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	8b 00                	mov    (%eax),%eax
 887:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 88a:	76 ca                	jbe    856 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 88c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 899:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89c:	01 c2                	add    %eax,%edx
 89e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a1:	8b 00                	mov    (%eax),%eax
 8a3:	39 c2                	cmp    %eax,%edx
 8a5:	75 24                	jne    8cb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8aa:	8b 50 04             	mov    0x4(%eax),%edx
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	8b 40 04             	mov    0x4(%eax),%eax
 8b5:	01 c2                	add    %eax,%edx
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c0:	8b 00                	mov    (%eax),%eax
 8c2:	8b 10                	mov    (%eax),%edx
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	89 10                	mov    %edx,(%eax)
 8c9:	eb 0a                	jmp    8d5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	8b 10                	mov    (%eax),%edx
 8d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e5:	01 d0                	add    %edx,%eax
 8e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ea:	75 20                	jne    90c <free+0xcf>
    p->s.size += bp->s.size;
 8ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ef:	8b 50 04             	mov    0x4(%eax),%edx
 8f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f5:	8b 40 04             	mov    0x4(%eax),%eax
 8f8:	01 c2                	add    %eax,%edx
 8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 900:	8b 45 f8             	mov    -0x8(%ebp),%eax
 903:	8b 10                	mov    (%eax),%edx
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	89 10                	mov    %edx,(%eax)
 90a:	eb 08                	jmp    914 <free+0xd7>
  } else
    p->s.ptr = bp;
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 912:	89 10                	mov    %edx,(%eax)
  freep = p;
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	a3 08 0d 00 00       	mov    %eax,0xd08
}
 91c:	90                   	nop
 91d:	c9                   	leave  
 91e:	c3                   	ret    

0000091f <morecore>:

static Header*
morecore(uint nu)
{
 91f:	55                   	push   %ebp
 920:	89 e5                	mov    %esp,%ebp
 922:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 925:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 92c:	77 07                	ja     935 <morecore+0x16>
    nu = 4096;
 92e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 935:	8b 45 08             	mov    0x8(%ebp),%eax
 938:	c1 e0 03             	shl    $0x3,%eax
 93b:	83 ec 0c             	sub    $0xc,%esp
 93e:	50                   	push   %eax
 93f:	e8 39 fc ff ff       	call   57d <sbrk>
 944:	83 c4 10             	add    $0x10,%esp
 947:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 94a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 94e:	75 07                	jne    957 <morecore+0x38>
    return 0;
 950:	b8 00 00 00 00       	mov    $0x0,%eax
 955:	eb 26                	jmp    97d <morecore+0x5e>
  hp = (Header*)p;
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 95d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 960:	8b 55 08             	mov    0x8(%ebp),%edx
 963:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 966:	8b 45 f0             	mov    -0x10(%ebp),%eax
 969:	83 c0 08             	add    $0x8,%eax
 96c:	83 ec 0c             	sub    $0xc,%esp
 96f:	50                   	push   %eax
 970:	e8 c8 fe ff ff       	call   83d <free>
 975:	83 c4 10             	add    $0x10,%esp
  return freep;
 978:	a1 08 0d 00 00       	mov    0xd08,%eax
}
 97d:	c9                   	leave  
 97e:	c3                   	ret    

0000097f <malloc>:

void*
malloc(uint nbytes)
{
 97f:	55                   	push   %ebp
 980:	89 e5                	mov    %esp,%ebp
 982:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	83 c0 07             	add    $0x7,%eax
 98b:	c1 e8 03             	shr    $0x3,%eax
 98e:	83 c0 01             	add    $0x1,%eax
 991:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 994:	a1 08 0d 00 00       	mov    0xd08,%eax
 999:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9a0:	75 23                	jne    9c5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9a2:	c7 45 f0 00 0d 00 00 	movl   $0xd00,-0x10(%ebp)
 9a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ac:	a3 08 0d 00 00       	mov    %eax,0xd08
 9b1:	a1 08 0d 00 00       	mov    0xd08,%eax
 9b6:	a3 00 0d 00 00       	mov    %eax,0xd00
    base.s.size = 0;
 9bb:	c7 05 04 0d 00 00 00 	movl   $0x0,0xd04
 9c2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c8:	8b 00                	mov    (%eax),%eax
 9ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d0:	8b 40 04             	mov    0x4(%eax),%eax
 9d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d6:	72 4d                	jb     a25 <malloc+0xa6>
      if(p->s.size == nunits)
 9d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9db:	8b 40 04             	mov    0x4(%eax),%eax
 9de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e1:	75 0c                	jne    9ef <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e6:	8b 10                	mov    (%eax),%edx
 9e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9eb:	89 10                	mov    %edx,(%eax)
 9ed:	eb 26                	jmp    a15 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	8b 40 04             	mov    0x4(%eax),%eax
 9f5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9f8:	89 c2                	mov    %eax,%edx
 9fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a03:	8b 40 04             	mov    0x4(%eax),%eax
 a06:	c1 e0 03             	shl    $0x3,%eax
 a09:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a12:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a18:	a3 08 0d 00 00       	mov    %eax,0xd08
      return (void*)(p + 1);
 a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a20:	83 c0 08             	add    $0x8,%eax
 a23:	eb 3b                	jmp    a60 <malloc+0xe1>
    }
    if(p == freep)
 a25:	a1 08 0d 00 00       	mov    0xd08,%eax
 a2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a2d:	75 1e                	jne    a4d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a2f:	83 ec 0c             	sub    $0xc,%esp
 a32:	ff 75 ec             	pushl  -0x14(%ebp)
 a35:	e8 e5 fe ff ff       	call   91f <morecore>
 a3a:	83 c4 10             	add    $0x10,%esp
 a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a44:	75 07                	jne    a4d <malloc+0xce>
        return 0;
 a46:	b8 00 00 00 00       	mov    $0x0,%eax
 a4b:	eb 13                	jmp    a60 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a56:	8b 00                	mov    (%eax),%eax
 a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a5b:	e9 6d ff ff ff       	jmp    9cd <malloc+0x4e>
}
 a60:	c9                   	leave  
 a61:	c3                   	ret    
