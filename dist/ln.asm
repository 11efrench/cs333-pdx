
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 b2 0a 00 00       	push   $0xab2
  1e:	6a 02                	push   $0x2
  20:	e8 d7 06 00 00       	call   6fc <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 18 05 00 00       	call   545 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 5e 05 00 00       	call   5a5 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 c5 0a 00 00       	push   $0xac5
  65:	6a 02                	push   $0x2
  67:	e8 90 06 00 00       	call   6fc <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 d1 04 00 00       	call   545 <exit>

00000074 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  7a:	8b 45 08             	mov    0x8(%ebp),%eax
  7d:	0f b7 00             	movzwl (%eax),%eax
  80:	98                   	cwtl   
  81:	83 f8 02             	cmp    $0x2,%eax
  84:	74 1e                	je     a4 <print_mode+0x30>
  86:	83 f8 03             	cmp    $0x3,%eax
  89:	74 2d                	je     b8 <print_mode+0x44>
  8b:	83 f8 01             	cmp    $0x1,%eax
  8e:	75 3c                	jne    cc <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  90:	83 ec 08             	sub    $0x8,%esp
  93:	68 d9 0a 00 00       	push   $0xad9
  98:	6a 01                	push   $0x1
  9a:	e8 5d 06 00 00       	call   6fc <printf>
  9f:	83 c4 10             	add    $0x10,%esp
  a2:	eb 3a                	jmp    de <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 db 0a 00 00       	push   $0xadb
  ac:	6a 01                	push   $0x1
  ae:	e8 49 06 00 00       	call   6fc <printf>
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	eb 26                	jmp    de <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  b8:	83 ec 08             	sub    $0x8,%esp
  bb:	68 dd 0a 00 00       	push   $0xadd
  c0:	6a 01                	push   $0x1
  c2:	e8 35 06 00 00       	call   6fc <printf>
  c7:	83 c4 10             	add    $0x10,%esp
  ca:	eb 12                	jmp    de <print_mode+0x6a>
    default: printf(1, "?");
  cc:	83 ec 08             	sub    $0x8,%esp
  cf:	68 df 0a 00 00       	push   $0xadf
  d4:	6a 01                	push   $0x1
  d6:	e8 21 06 00 00       	call   6fc <printf>
  db:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  e5:	83 e0 01             	and    $0x1,%eax
  e8:	84 c0                	test   %al,%al
  ea:	74 14                	je     100 <print_mode+0x8c>
    printf(1, "r");
  ec:	83 ec 08             	sub    $0x8,%esp
  ef:	68 e1 0a 00 00       	push   $0xae1
  f4:	6a 01                	push   $0x1
  f6:	e8 01 06 00 00       	call   6fc <printf>
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	eb 12                	jmp    112 <print_mode+0x9e>
  else
    printf(1, "-");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 db 0a 00 00       	push   $0xadb
 108:	6a 01                	push   $0x1
 10a:	e8 ed 05 00 00       	call   6fc <printf>
 10f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 119:	83 e0 80             	and    $0xffffff80,%eax
 11c:	84 c0                	test   %al,%al
 11e:	74 14                	je     134 <print_mode+0xc0>
    printf(1, "w");
 120:	83 ec 08             	sub    $0x8,%esp
 123:	68 e3 0a 00 00       	push   $0xae3
 128:	6a 01                	push   $0x1
 12a:	e8 cd 05 00 00       	call   6fc <printf>
 12f:	83 c4 10             	add    $0x10,%esp
 132:	eb 12                	jmp    146 <print_mode+0xd2>
  else
    printf(1, "-");
 134:	83 ec 08             	sub    $0x8,%esp
 137:	68 db 0a 00 00       	push   $0xadb
 13c:	6a 01                	push   $0x1
 13e:	e8 b9 05 00 00       	call   6fc <printf>
 143:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 146:	8b 45 08             	mov    0x8(%ebp),%eax
 149:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 14d:	c0 e8 06             	shr    $0x6,%al
 150:	83 e0 01             	and    $0x1,%eax
 153:	0f b6 d0             	movzbl %al,%edx
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 15d:	d0 e8                	shr    %al
 15f:	83 e0 01             	and    $0x1,%eax
 162:	0f b6 c0             	movzbl %al,%eax
 165:	21 d0                	and    %edx,%eax
 167:	85 c0                	test   %eax,%eax
 169:	74 14                	je     17f <print_mode+0x10b>
    printf(1, "S");
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	68 e5 0a 00 00       	push   $0xae5
 173:	6a 01                	push   $0x1
 175:	e8 82 05 00 00       	call   6fc <printf>
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	eb 34                	jmp    1b3 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 186:	83 e0 40             	and    $0x40,%eax
 189:	84 c0                	test   %al,%al
 18b:	74 14                	je     1a1 <print_mode+0x12d>
    printf(1, "x");
 18d:	83 ec 08             	sub    $0x8,%esp
 190:	68 e7 0a 00 00       	push   $0xae7
 195:	6a 01                	push   $0x1
 197:	e8 60 05 00 00       	call   6fc <printf>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	eb 12                	jmp    1b3 <print_mode+0x13f>
  else
    printf(1, "-");
 1a1:	83 ec 08             	sub    $0x8,%esp
 1a4:	68 db 0a 00 00       	push   $0xadb
 1a9:	6a 01                	push   $0x1
 1ab:	e8 4c 05 00 00       	call   6fc <printf>
 1b0:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1ba:	83 e0 20             	and    $0x20,%eax
 1bd:	84 c0                	test   %al,%al
 1bf:	74 14                	je     1d5 <print_mode+0x161>
    printf(1, "r");
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	68 e1 0a 00 00       	push   $0xae1
 1c9:	6a 01                	push   $0x1
 1cb:	e8 2c 05 00 00       	call   6fc <printf>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	eb 12                	jmp    1e7 <print_mode+0x173>
  else
    printf(1, "-");
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	68 db 0a 00 00       	push   $0xadb
 1dd:	6a 01                	push   $0x1
 1df:	e8 18 05 00 00       	call   6fc <printf>
 1e4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1ee:	83 e0 10             	and    $0x10,%eax
 1f1:	84 c0                	test   %al,%al
 1f3:	74 14                	je     209 <print_mode+0x195>
    printf(1, "w");
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	68 e3 0a 00 00       	push   $0xae3
 1fd:	6a 01                	push   $0x1
 1ff:	e8 f8 04 00 00       	call   6fc <printf>
 204:	83 c4 10             	add    $0x10,%esp
 207:	eb 12                	jmp    21b <print_mode+0x1a7>
  else
    printf(1, "-");
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	68 db 0a 00 00       	push   $0xadb
 211:	6a 01                	push   $0x1
 213:	e8 e4 04 00 00       	call   6fc <printf>
 218:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 222:	83 e0 08             	and    $0x8,%eax
 225:	84 c0                	test   %al,%al
 227:	74 14                	je     23d <print_mode+0x1c9>
    printf(1, "x");
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	68 e7 0a 00 00       	push   $0xae7
 231:	6a 01                	push   $0x1
 233:	e8 c4 04 00 00       	call   6fc <printf>
 238:	83 c4 10             	add    $0x10,%esp
 23b:	eb 12                	jmp    24f <print_mode+0x1db>
  else
    printf(1, "-");
 23d:	83 ec 08             	sub    $0x8,%esp
 240:	68 db 0a 00 00       	push   $0xadb
 245:	6a 01                	push   $0x1
 247:	e8 b0 04 00 00       	call   6fc <printf>
 24c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 256:	83 e0 04             	and    $0x4,%eax
 259:	84 c0                	test   %al,%al
 25b:	74 14                	je     271 <print_mode+0x1fd>
    printf(1, "r");
 25d:	83 ec 08             	sub    $0x8,%esp
 260:	68 e1 0a 00 00       	push   $0xae1
 265:	6a 01                	push   $0x1
 267:	e8 90 04 00 00       	call   6fc <printf>
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	eb 12                	jmp    283 <print_mode+0x20f>
  else
    printf(1, "-");
 271:	83 ec 08             	sub    $0x8,%esp
 274:	68 db 0a 00 00       	push   $0xadb
 279:	6a 01                	push   $0x1
 27b:	e8 7c 04 00 00       	call   6fc <printf>
 280:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 28a:	83 e0 02             	and    $0x2,%eax
 28d:	84 c0                	test   %al,%al
 28f:	74 14                	je     2a5 <print_mode+0x231>
    printf(1, "w");
 291:	83 ec 08             	sub    $0x8,%esp
 294:	68 e3 0a 00 00       	push   $0xae3
 299:	6a 01                	push   $0x1
 29b:	e8 5c 04 00 00       	call   6fc <printf>
 2a0:	83 c4 10             	add    $0x10,%esp
 2a3:	eb 12                	jmp    2b7 <print_mode+0x243>
  else
    printf(1, "-");
 2a5:	83 ec 08             	sub    $0x8,%esp
 2a8:	68 db 0a 00 00       	push   $0xadb
 2ad:	6a 01                	push   $0x1
 2af:	e8 48 04 00 00       	call   6fc <printf>
 2b4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2be:	83 e0 01             	and    $0x1,%eax
 2c1:	84 c0                	test   %al,%al
 2c3:	74 14                	je     2d9 <print_mode+0x265>
    printf(1, "x");
 2c5:	83 ec 08             	sub    $0x8,%esp
 2c8:	68 e7 0a 00 00       	push   $0xae7
 2cd:	6a 01                	push   $0x1
 2cf:	e8 28 04 00 00       	call   6fc <printf>
 2d4:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 2d7:	eb 13                	jmp    2ec <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 2d9:	83 ec 08             	sub    $0x8,%esp
 2dc:	68 db 0a 00 00       	push   $0xadb
 2e1:	6a 01                	push   $0x1
 2e3:	e8 14 04 00 00       	call   6fc <printf>
 2e8:	83 c4 10             	add    $0x10,%esp

  return;
 2eb:	90                   	nop
}
 2ec:	c9                   	leave  
 2ed:	c3                   	ret    

000002ee <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	57                   	push   %edi
 2f2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f6:	8b 55 10             	mov    0x10(%ebp),%edx
 2f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fc:	89 cb                	mov    %ecx,%ebx
 2fe:	89 df                	mov    %ebx,%edi
 300:	89 d1                	mov    %edx,%ecx
 302:	fc                   	cld    
 303:	f3 aa                	rep stos %al,%es:(%edi)
 305:	89 ca                	mov    %ecx,%edx
 307:	89 fb                	mov    %edi,%ebx
 309:	89 5d 08             	mov    %ebx,0x8(%ebp)
 30c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 30f:	90                   	nop
 310:	5b                   	pop    %ebx
 311:	5f                   	pop    %edi
 312:	5d                   	pop    %ebp
 313:	c3                   	ret    

00000314 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 320:	90                   	nop
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	8d 50 01             	lea    0x1(%eax),%edx
 327:	89 55 08             	mov    %edx,0x8(%ebp)
 32a:	8b 55 0c             	mov    0xc(%ebp),%edx
 32d:	8d 4a 01             	lea    0x1(%edx),%ecx
 330:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 333:	0f b6 12             	movzbl (%edx),%edx
 336:	88 10                	mov    %dl,(%eax)
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	84 c0                	test   %al,%al
 33d:	75 e2                	jne    321 <strcpy+0xd>
    ;
  return os;
 33f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 347:	eb 08                	jmp    351 <strcmp+0xd>
    p++, q++;
 349:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	0f b6 00             	movzbl (%eax),%eax
 357:	84 c0                	test   %al,%al
 359:	74 10                	je     36b <strcmp+0x27>
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	0f b6 10             	movzbl (%eax),%edx
 361:	8b 45 0c             	mov    0xc(%ebp),%eax
 364:	0f b6 00             	movzbl (%eax),%eax
 367:	38 c2                	cmp    %al,%dl
 369:	74 de                	je     349 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	0f b6 d0             	movzbl %al,%edx
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	0f b6 00             	movzbl (%eax),%eax
 37a:	0f b6 c0             	movzbl %al,%eax
 37d:	29 c2                	sub    %eax,%edx
 37f:	89 d0                	mov    %edx,%eax
}
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    

00000383 <strlen>:

uint
strlen(char *s)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 390:	eb 04                	jmp    396 <strlen+0x13>
 392:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 396:	8b 55 fc             	mov    -0x4(%ebp),%edx
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	01 d0                	add    %edx,%eax
 39e:	0f b6 00             	movzbl (%eax),%eax
 3a1:	84 c0                	test   %al,%al
 3a3:	75 ed                	jne    392 <strlen+0xf>
    ;
  return n;
 3a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a8:	c9                   	leave  
 3a9:	c3                   	ret    

000003aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ad:	8b 45 10             	mov    0x10(%ebp),%eax
 3b0:	50                   	push   %eax
 3b1:	ff 75 0c             	pushl  0xc(%ebp)
 3b4:	ff 75 08             	pushl  0x8(%ebp)
 3b7:	e8 32 ff ff ff       	call   2ee <stosb>
 3bc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c2:	c9                   	leave  
 3c3:	c3                   	ret    

000003c4 <strchr>:

char*
strchr(const char *s, char c)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	83 ec 04             	sub    $0x4,%esp
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3d0:	eb 14                	jmp    3e6 <strchr+0x22>
    if(*s == c)
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3db:	75 05                	jne    3e2 <strchr+0x1e>
      return (char*)s;
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	eb 13                	jmp    3f5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	0f b6 00             	movzbl (%eax),%eax
 3ec:	84 c0                	test   %al,%al
 3ee:	75 e2                	jne    3d2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <gets>:

char*
gets(char *buf, int max)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 404:	eb 42                	jmp    448 <gets+0x51>
    cc = read(0, &c, 1);
 406:	83 ec 04             	sub    $0x4,%esp
 409:	6a 01                	push   $0x1
 40b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 40e:	50                   	push   %eax
 40f:	6a 00                	push   $0x0
 411:	e8 47 01 00 00       	call   55d <read>
 416:	83 c4 10             	add    $0x10,%esp
 419:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 41c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 420:	7e 33                	jle    455 <gets+0x5e>
      break;
    buf[i++] = c;
 422:	8b 45 f4             	mov    -0xc(%ebp),%eax
 425:	8d 50 01             	lea    0x1(%eax),%edx
 428:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42b:	89 c2                	mov    %eax,%edx
 42d:	8b 45 08             	mov    0x8(%ebp),%eax
 430:	01 c2                	add    %eax,%edx
 432:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 436:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 438:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 43c:	3c 0a                	cmp    $0xa,%al
 43e:	74 16                	je     456 <gets+0x5f>
 440:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 444:	3c 0d                	cmp    $0xd,%al
 446:	74 0e                	je     456 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 448:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44b:	83 c0 01             	add    $0x1,%eax
 44e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 451:	7c b3                	jl     406 <gets+0xf>
 453:	eb 01                	jmp    456 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 455:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 456:	8b 55 f4             	mov    -0xc(%ebp),%edx
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	01 d0                	add    %edx,%eax
 45e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 461:	8b 45 08             	mov    0x8(%ebp),%eax
}
 464:	c9                   	leave  
 465:	c3                   	ret    

00000466 <stat>:

int
stat(char *n, struct stat *st)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 46c:	83 ec 08             	sub    $0x8,%esp
 46f:	6a 00                	push   $0x0
 471:	ff 75 08             	pushl  0x8(%ebp)
 474:	e8 0c 01 00 00       	call   585 <open>
 479:	83 c4 10             	add    $0x10,%esp
 47c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 47f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 483:	79 07                	jns    48c <stat+0x26>
    return -1;
 485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 48a:	eb 25                	jmp    4b1 <stat+0x4b>
  r = fstat(fd, st);
 48c:	83 ec 08             	sub    $0x8,%esp
 48f:	ff 75 0c             	pushl  0xc(%ebp)
 492:	ff 75 f4             	pushl  -0xc(%ebp)
 495:	e8 03 01 00 00       	call   59d <fstat>
 49a:	83 c4 10             	add    $0x10,%esp
 49d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4a0:	83 ec 0c             	sub    $0xc,%esp
 4a3:	ff 75 f4             	pushl  -0xc(%ebp)
 4a6:	e8 c2 00 00 00       	call   56d <close>
 4ab:	83 c4 10             	add    $0x10,%esp
  return r;
 4ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <atoi>:

int
atoi(const char *s)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4c0:	eb 25                	jmp    4e7 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c5:	89 d0                	mov    %edx,%eax
 4c7:	c1 e0 02             	shl    $0x2,%eax
 4ca:	01 d0                	add    %edx,%eax
 4cc:	01 c0                	add    %eax,%eax
 4ce:	89 c1                	mov    %eax,%ecx
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	8d 50 01             	lea    0x1(%eax),%edx
 4d6:	89 55 08             	mov    %edx,0x8(%ebp)
 4d9:	0f b6 00             	movzbl (%eax),%eax
 4dc:	0f be c0             	movsbl %al,%eax
 4df:	01 c8                	add    %ecx,%eax
 4e1:	83 e8 30             	sub    $0x30,%eax
 4e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	0f b6 00             	movzbl (%eax),%eax
 4ed:	3c 2f                	cmp    $0x2f,%al
 4ef:	7e 0a                	jle    4fb <atoi+0x48>
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	0f b6 00             	movzbl (%eax),%eax
 4f7:	3c 39                	cmp    $0x39,%al
 4f9:	7e c7                	jle    4c2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4fe:	c9                   	leave  
 4ff:	c3                   	ret    

00000500 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 50c:	8b 45 0c             	mov    0xc(%ebp),%eax
 50f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 512:	eb 17                	jmp    52b <memmove+0x2b>
    *dst++ = *src++;
 514:	8b 45 fc             	mov    -0x4(%ebp),%eax
 517:	8d 50 01             	lea    0x1(%eax),%edx
 51a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 51d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 520:	8d 4a 01             	lea    0x1(%edx),%ecx
 523:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 526:	0f b6 12             	movzbl (%edx),%edx
 529:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 52b:	8b 45 10             	mov    0x10(%ebp),%eax
 52e:	8d 50 ff             	lea    -0x1(%eax),%edx
 531:	89 55 10             	mov    %edx,0x10(%ebp)
 534:	85 c0                	test   %eax,%eax
 536:	7f dc                	jg     514 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 538:	8b 45 08             	mov    0x8(%ebp),%eax
}
 53b:	c9                   	leave  
 53c:	c3                   	ret    

0000053d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53d:	b8 01 00 00 00       	mov    $0x1,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <exit>:
SYSCALL(exit)
 545:	b8 02 00 00 00       	mov    $0x2,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <wait>:
SYSCALL(wait)
 54d:	b8 03 00 00 00       	mov    $0x3,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <pipe>:
SYSCALL(pipe)
 555:	b8 04 00 00 00       	mov    $0x4,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <read>:
SYSCALL(read)
 55d:	b8 05 00 00 00       	mov    $0x5,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <write>:
SYSCALL(write)
 565:	b8 10 00 00 00       	mov    $0x10,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <close>:
SYSCALL(close)
 56d:	b8 15 00 00 00       	mov    $0x15,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <kill>:
SYSCALL(kill)
 575:	b8 06 00 00 00       	mov    $0x6,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <exec>:
SYSCALL(exec)
 57d:	b8 07 00 00 00       	mov    $0x7,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <open>:
SYSCALL(open)
 585:	b8 0f 00 00 00       	mov    $0xf,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <mknod>:
SYSCALL(mknod)
 58d:	b8 11 00 00 00       	mov    $0x11,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <unlink>:
SYSCALL(unlink)
 595:	b8 12 00 00 00       	mov    $0x12,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <fstat>:
SYSCALL(fstat)
 59d:	b8 08 00 00 00       	mov    $0x8,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <link>:
SYSCALL(link)
 5a5:	b8 13 00 00 00       	mov    $0x13,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <mkdir>:
SYSCALL(mkdir)
 5ad:	b8 14 00 00 00       	mov    $0x14,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <chdir>:
SYSCALL(chdir)
 5b5:	b8 09 00 00 00       	mov    $0x9,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <dup>:
SYSCALL(dup)
 5bd:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <getpid>:
SYSCALL(getpid)
 5c5:	b8 0b 00 00 00       	mov    $0xb,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <sbrk>:
SYSCALL(sbrk)
 5cd:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <sleep>:
SYSCALL(sleep)
 5d5:	b8 0d 00 00 00       	mov    $0xd,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <uptime>:
SYSCALL(uptime)
 5dd:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <halt>:
SYSCALL(halt)
 5e5:	b8 16 00 00 00       	mov    $0x16,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <date>:
//Student Implementations 
SYSCALL(date)
 5ed:	b8 17 00 00 00       	mov    $0x17,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <getuid>:

SYSCALL(getuid)
 5f5:	b8 18 00 00 00       	mov    $0x18,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <getgid>:
SYSCALL(getgid)
 5fd:	b8 19 00 00 00       	mov    $0x19,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <getppid>:
SYSCALL(getppid)
 605:	b8 1a 00 00 00       	mov    $0x1a,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <setuid>:

SYSCALL(setuid)
 60d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <setgid>:
SYSCALL(setgid)
 615:	b8 1c 00 00 00       	mov    $0x1c,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <getprocs>:
SYSCALL(getprocs)
 61d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 625:	55                   	push   %ebp
 626:	89 e5                	mov    %esp,%ebp
 628:	83 ec 18             	sub    $0x18,%esp
 62b:	8b 45 0c             	mov    0xc(%ebp),%eax
 62e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 631:	83 ec 04             	sub    $0x4,%esp
 634:	6a 01                	push   $0x1
 636:	8d 45 f4             	lea    -0xc(%ebp),%eax
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 23 ff ff ff       	call   565 <write>
 642:	83 c4 10             	add    $0x10,%esp
}
 645:	90                   	nop
 646:	c9                   	leave  
 647:	c3                   	ret    

00000648 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	53                   	push   %ebx
 64c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 656:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 65a:	74 17                	je     673 <printint+0x2b>
 65c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 660:	79 11                	jns    673 <printint+0x2b>
    neg = 1;
 662:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 669:	8b 45 0c             	mov    0xc(%ebp),%eax
 66c:	f7 d8                	neg    %eax
 66e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 671:	eb 06                	jmp    679 <printint+0x31>
  } else {
    x = xx;
 673:	8b 45 0c             	mov    0xc(%ebp),%eax
 676:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 680:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 683:	8d 41 01             	lea    0x1(%ecx),%eax
 686:	89 45 f4             	mov    %eax,-0xc(%ebp)
 689:	8b 5d 10             	mov    0x10(%ebp),%ebx
 68c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68f:	ba 00 00 00 00       	mov    $0x0,%edx
 694:	f7 f3                	div    %ebx
 696:	89 d0                	mov    %edx,%eax
 698:	0f b6 80 5c 0d 00 00 	movzbl 0xd5c(%eax),%eax
 69f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a9:	ba 00 00 00 00       	mov    $0x0,%edx
 6ae:	f7 f3                	div    %ebx
 6b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b7:	75 c7                	jne    680 <printint+0x38>
  if(neg)
 6b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6bd:	74 2d                	je     6ec <printint+0xa4>
    buf[i++] = '-';
 6bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c2:	8d 50 01             	lea    0x1(%eax),%edx
 6c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6cd:	eb 1d                	jmp    6ec <printint+0xa4>
    putc(fd, buf[i]);
 6cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	0f b6 00             	movzbl (%eax),%eax
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	50                   	push   %eax
 6e1:	ff 75 08             	pushl  0x8(%ebp)
 6e4:	e8 3c ff ff ff       	call   625 <putc>
 6e9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ec:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f4:	79 d9                	jns    6cf <printint+0x87>
    putc(fd, buf[i]);
}
 6f6:	90                   	nop
 6f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6fa:	c9                   	leave  
 6fb:	c3                   	ret    

000006fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 702:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 709:	8d 45 0c             	lea    0xc(%ebp),%eax
 70c:	83 c0 04             	add    $0x4,%eax
 70f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 712:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 719:	e9 59 01 00 00       	jmp    877 <printf+0x17b>
    c = fmt[i] & 0xff;
 71e:	8b 55 0c             	mov    0xc(%ebp),%edx
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	01 d0                	add    %edx,%eax
 726:	0f b6 00             	movzbl (%eax),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	25 ff 00 00 00       	and    $0xff,%eax
 731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 734:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 738:	75 2c                	jne    766 <printf+0x6a>
      if(c == '%'){
 73a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73e:	75 0c                	jne    74c <printf+0x50>
        state = '%';
 740:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 747:	e9 27 01 00 00       	jmp    873 <printf+0x177>
      } else {
        putc(fd, c);
 74c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74f:	0f be c0             	movsbl %al,%eax
 752:	83 ec 08             	sub    $0x8,%esp
 755:	50                   	push   %eax
 756:	ff 75 08             	pushl  0x8(%ebp)
 759:	e8 c7 fe ff ff       	call   625 <putc>
 75e:	83 c4 10             	add    $0x10,%esp
 761:	e9 0d 01 00 00       	jmp    873 <printf+0x177>
      }
    } else if(state == '%'){
 766:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 76a:	0f 85 03 01 00 00    	jne    873 <printf+0x177>
      if(c == 'd'){
 770:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 774:	75 1e                	jne    794 <printf+0x98>
        printint(fd, *ap, 10, 1);
 776:	8b 45 e8             	mov    -0x18(%ebp),%eax
 779:	8b 00                	mov    (%eax),%eax
 77b:	6a 01                	push   $0x1
 77d:	6a 0a                	push   $0xa
 77f:	50                   	push   %eax
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 c0 fe ff ff       	call   648 <printint>
 788:	83 c4 10             	add    $0x10,%esp
        ap++;
 78b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78f:	e9 d8 00 00 00       	jmp    86c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 794:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 798:	74 06                	je     7a0 <printf+0xa4>
 79a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 79e:	75 1e                	jne    7be <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	6a 00                	push   $0x0
 7a7:	6a 10                	push   $0x10
 7a9:	50                   	push   %eax
 7aa:	ff 75 08             	pushl  0x8(%ebp)
 7ad:	e8 96 fe ff ff       	call   648 <printint>
 7b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b9:	e9 ae 00 00 00       	jmp    86c <printf+0x170>
      } else if(c == 's'){
 7be:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c2:	75 43                	jne    807 <printf+0x10b>
        s = (char*)*ap;
 7c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d4:	75 25                	jne    7fb <printf+0xff>
          s = "(null)";
 7d6:	c7 45 f4 e9 0a 00 00 	movl   $0xae9,-0xc(%ebp)
        while(*s != 0){
 7dd:	eb 1c                	jmp    7fb <printf+0xff>
          putc(fd, *s);
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	0f b6 00             	movzbl (%eax),%eax
 7e5:	0f be c0             	movsbl %al,%eax
 7e8:	83 ec 08             	sub    $0x8,%esp
 7eb:	50                   	push   %eax
 7ec:	ff 75 08             	pushl  0x8(%ebp)
 7ef:	e8 31 fe ff ff       	call   625 <putc>
 7f4:	83 c4 10             	add    $0x10,%esp
          s++;
 7f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	0f b6 00             	movzbl (%eax),%eax
 801:	84 c0                	test   %al,%al
 803:	75 da                	jne    7df <printf+0xe3>
 805:	eb 65                	jmp    86c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 807:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 80b:	75 1d                	jne    82a <printf+0x12e>
        putc(fd, *ap);
 80d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	0f be c0             	movsbl %al,%eax
 815:	83 ec 08             	sub    $0x8,%esp
 818:	50                   	push   %eax
 819:	ff 75 08             	pushl  0x8(%ebp)
 81c:	e8 04 fe ff ff       	call   625 <putc>
 821:	83 c4 10             	add    $0x10,%esp
        ap++;
 824:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 828:	eb 42                	jmp    86c <printf+0x170>
      } else if(c == '%'){
 82a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82e:	75 17                	jne    847 <printf+0x14b>
        putc(fd, c);
 830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 833:	0f be c0             	movsbl %al,%eax
 836:	83 ec 08             	sub    $0x8,%esp
 839:	50                   	push   %eax
 83a:	ff 75 08             	pushl  0x8(%ebp)
 83d:	e8 e3 fd ff ff       	call   625 <putc>
 842:	83 c4 10             	add    $0x10,%esp
 845:	eb 25                	jmp    86c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 847:	83 ec 08             	sub    $0x8,%esp
 84a:	6a 25                	push   $0x25
 84c:	ff 75 08             	pushl  0x8(%ebp)
 84f:	e8 d1 fd ff ff       	call   625 <putc>
 854:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85a:	0f be c0             	movsbl %al,%eax
 85d:	83 ec 08             	sub    $0x8,%esp
 860:	50                   	push   %eax
 861:	ff 75 08             	pushl  0x8(%ebp)
 864:	e8 bc fd ff ff       	call   625 <putc>
 869:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 86c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 873:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 877:	8b 55 0c             	mov    0xc(%ebp),%edx
 87a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87d:	01 d0                	add    %edx,%eax
 87f:	0f b6 00             	movzbl (%eax),%eax
 882:	84 c0                	test   %al,%al
 884:	0f 85 94 fe ff ff    	jne    71e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 88a:	90                   	nop
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88d:	55                   	push   %ebp
 88e:	89 e5                	mov    %esp,%ebp
 890:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 893:	8b 45 08             	mov    0x8(%ebp),%eax
 896:	83 e8 08             	sub    $0x8,%eax
 899:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	a1 78 0d 00 00       	mov    0xd78,%eax
 8a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a4:	eb 24                	jmp    8ca <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ae:	77 12                	ja     8c2 <free+0x35>
 8b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b6:	77 24                	ja     8dc <free+0x4f>
 8b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8c0:	77 1a                	ja     8dc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d0:	76 d4                	jbe    8a6 <free+0x19>
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 00                	mov    (%eax),%eax
 8d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8da:	76 ca                	jbe    8a6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ec:	01 c2                	add    %eax,%edx
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	39 c2                	cmp    %eax,%edx
 8f5:	75 24                	jne    91b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	8b 50 04             	mov    0x4(%eax),%edx
 8fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	8b 40 04             	mov    0x4(%eax),%eax
 905:	01 c2                	add    %eax,%edx
 907:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	8b 10                	mov    (%eax),%edx
 914:	8b 45 f8             	mov    -0x8(%ebp),%eax
 917:	89 10                	mov    %edx,(%eax)
 919:	eb 0a                	jmp    925 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	8b 10                	mov    (%eax),%edx
 920:	8b 45 f8             	mov    -0x8(%ebp),%eax
 923:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	01 d0                	add    %edx,%eax
 937:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93a:	75 20                	jne    95c <free+0xcf>
    p->s.size += bp->s.size;
 93c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93f:	8b 50 04             	mov    0x4(%eax),%edx
 942:	8b 45 f8             	mov    -0x8(%ebp),%eax
 945:	8b 40 04             	mov    0x4(%eax),%eax
 948:	01 c2                	add    %eax,%edx
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 950:	8b 45 f8             	mov    -0x8(%ebp),%eax
 953:	8b 10                	mov    (%eax),%edx
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	89 10                	mov    %edx,(%eax)
 95a:	eb 08                	jmp    964 <free+0xd7>
  } else
    p->s.ptr = bp;
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 962:	89 10                	mov    %edx,(%eax)
  freep = p;
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	a3 78 0d 00 00       	mov    %eax,0xd78
}
 96c:	90                   	nop
 96d:	c9                   	leave  
 96e:	c3                   	ret    

0000096f <morecore>:

static Header*
morecore(uint nu)
{
 96f:	55                   	push   %ebp
 970:	89 e5                	mov    %esp,%ebp
 972:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 975:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 97c:	77 07                	ja     985 <morecore+0x16>
    nu = 4096;
 97e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	c1 e0 03             	shl    $0x3,%eax
 98b:	83 ec 0c             	sub    $0xc,%esp
 98e:	50                   	push   %eax
 98f:	e8 39 fc ff ff       	call   5cd <sbrk>
 994:	83 c4 10             	add    $0x10,%esp
 997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 99a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99e:	75 07                	jne    9a7 <morecore+0x38>
    return 0;
 9a0:	b8 00 00 00 00       	mov    $0x0,%eax
 9a5:	eb 26                	jmp    9cd <morecore+0x5e>
  hp = (Header*)p;
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b0:	8b 55 08             	mov    0x8(%ebp),%edx
 9b3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b9:	83 c0 08             	add    $0x8,%eax
 9bc:	83 ec 0c             	sub    $0xc,%esp
 9bf:	50                   	push   %eax
 9c0:	e8 c8 fe ff ff       	call   88d <free>
 9c5:	83 c4 10             	add    $0x10,%esp
  return freep;
 9c8:	a1 78 0d 00 00       	mov    0xd78,%eax
}
 9cd:	c9                   	leave  
 9ce:	c3                   	ret    

000009cf <malloc>:

void*
malloc(uint nbytes)
{
 9cf:	55                   	push   %ebp
 9d0:	89 e5                	mov    %esp,%ebp
 9d2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	83 c0 07             	add    $0x7,%eax
 9db:	c1 e8 03             	shr    $0x3,%eax
 9de:	83 c0 01             	add    $0x1,%eax
 9e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e4:	a1 78 0d 00 00       	mov    0xd78,%eax
 9e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9f0:	75 23                	jne    a15 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9f2:	c7 45 f0 70 0d 00 00 	movl   $0xd70,-0x10(%ebp)
 9f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fc:	a3 78 0d 00 00       	mov    %eax,0xd78
 a01:	a1 78 0d 00 00       	mov    0xd78,%eax
 a06:	a3 70 0d 00 00       	mov    %eax,0xd70
    base.s.size = 0;
 a0b:	c7 05 74 0d 00 00 00 	movl   $0x0,0xd74
 a12:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a18:	8b 00                	mov    (%eax),%eax
 a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a20:	8b 40 04             	mov    0x4(%eax),%eax
 a23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a26:	72 4d                	jb     a75 <malloc+0xa6>
      if(p->s.size == nunits)
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 40 04             	mov    0x4(%eax),%eax
 a2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a31:	75 0c                	jne    a3f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 10                	mov    (%eax),%edx
 a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3b:	89 10                	mov    %edx,(%eax)
 a3d:	eb 26                	jmp    a65 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8b 40 04             	mov    0x4(%eax),%eax
 a45:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a48:	89 c2                	mov    %eax,%edx
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	8b 40 04             	mov    0x4(%eax),%eax
 a56:	c1 e0 03             	shl    $0x3,%eax
 a59:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a62:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a68:	a3 78 0d 00 00       	mov    %eax,0xd78
      return (void*)(p + 1);
 a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a70:	83 c0 08             	add    $0x8,%eax
 a73:	eb 3b                	jmp    ab0 <malloc+0xe1>
    }
    if(p == freep)
 a75:	a1 78 0d 00 00       	mov    0xd78,%eax
 a7a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a7d:	75 1e                	jne    a9d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a7f:	83 ec 0c             	sub    $0xc,%esp
 a82:	ff 75 ec             	pushl  -0x14(%ebp)
 a85:	e8 e5 fe ff ff       	call   96f <morecore>
 a8a:	83 c4 10             	add    $0x10,%esp
 a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a94:	75 07                	jne    a9d <malloc+0xce>
        return 0;
 a96:	b8 00 00 00 00       	mov    $0x0,%eax
 a9b:	eb 13                	jmp    ab0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa6:	8b 00                	mov    (%eax),%eax
 aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aab:	e9 6d ff ff ff       	jmp    a1d <malloc+0x4e>
}
 ab0:	c9                   	leave  
 ab1:	c3                   	ret    
