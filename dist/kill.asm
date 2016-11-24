
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 c8 0a 00 00       	push   $0xac8
  21:	6a 02                	push   $0x2
  23:	e8 ea 06 00 00       	call   712 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 13 05 00 00       	call   543 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 5e 04 00 00       	call   4b1 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 14 05 00 00       	call   573 <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 d1 04 00 00       	call   543 <exit>

00000072 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  78:	8b 45 08             	mov    0x8(%ebp),%eax
  7b:	0f b7 00             	movzwl (%eax),%eax
  7e:	98                   	cwtl   
  7f:	83 f8 02             	cmp    $0x2,%eax
  82:	74 1e                	je     a2 <print_mode+0x30>
  84:	83 f8 03             	cmp    $0x3,%eax
  87:	74 2d                	je     b6 <print_mode+0x44>
  89:	83 f8 01             	cmp    $0x1,%eax
  8c:	75 3c                	jne    ca <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  8e:	83 ec 08             	sub    $0x8,%esp
  91:	68 dc 0a 00 00       	push   $0xadc
  96:	6a 01                	push   $0x1
  98:	e8 75 06 00 00       	call   712 <printf>
  9d:	83 c4 10             	add    $0x10,%esp
  a0:	eb 3a                	jmp    dc <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	68 de 0a 00 00       	push   $0xade
  aa:	6a 01                	push   $0x1
  ac:	e8 61 06 00 00       	call   712 <printf>
  b1:	83 c4 10             	add    $0x10,%esp
  b4:	eb 26                	jmp    dc <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 e0 0a 00 00       	push   $0xae0
  be:	6a 01                	push   $0x1
  c0:	e8 4d 06 00 00       	call   712 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	eb 12                	jmp    dc <print_mode+0x6a>
    default: printf(1, "?");
  ca:	83 ec 08             	sub    $0x8,%esp
  cd:	68 e2 0a 00 00       	push   $0xae2
  d2:	6a 01                	push   $0x1
  d4:	e8 39 06 00 00       	call   712 <printf>
  d9:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  e3:	83 e0 01             	and    $0x1,%eax
  e6:	84 c0                	test   %al,%al
  e8:	74 14                	je     fe <print_mode+0x8c>
    printf(1, "r");
  ea:	83 ec 08             	sub    $0x8,%esp
  ed:	68 e4 0a 00 00       	push   $0xae4
  f2:	6a 01                	push   $0x1
  f4:	e8 19 06 00 00       	call   712 <printf>
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	eb 12                	jmp    110 <print_mode+0x9e>
  else
    printf(1, "-");
  fe:	83 ec 08             	sub    $0x8,%esp
 101:	68 de 0a 00 00       	push   $0xade
 106:	6a 01                	push   $0x1
 108:	e8 05 06 00 00       	call   712 <printf>
 10d:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 117:	83 e0 80             	and    $0xffffff80,%eax
 11a:	84 c0                	test   %al,%al
 11c:	74 14                	je     132 <print_mode+0xc0>
    printf(1, "w");
 11e:	83 ec 08             	sub    $0x8,%esp
 121:	68 e6 0a 00 00       	push   $0xae6
 126:	6a 01                	push   $0x1
 128:	e8 e5 05 00 00       	call   712 <printf>
 12d:	83 c4 10             	add    $0x10,%esp
 130:	eb 12                	jmp    144 <print_mode+0xd2>
  else
    printf(1, "-");
 132:	83 ec 08             	sub    $0x8,%esp
 135:	68 de 0a 00 00       	push   $0xade
 13a:	6a 01                	push   $0x1
 13c:	e8 d1 05 00 00       	call   712 <printf>
 141:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 14b:	c0 e8 06             	shr    $0x6,%al
 14e:	83 e0 01             	and    $0x1,%eax
 151:	0f b6 d0             	movzbl %al,%edx
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 15b:	d0 e8                	shr    %al
 15d:	83 e0 01             	and    $0x1,%eax
 160:	0f b6 c0             	movzbl %al,%eax
 163:	21 d0                	and    %edx,%eax
 165:	85 c0                	test   %eax,%eax
 167:	74 14                	je     17d <print_mode+0x10b>
    printf(1, "S");
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	68 e8 0a 00 00       	push   $0xae8
 171:	6a 01                	push   $0x1
 173:	e8 9a 05 00 00       	call   712 <printf>
 178:	83 c4 10             	add    $0x10,%esp
 17b:	eb 34                	jmp    1b1 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 184:	83 e0 40             	and    $0x40,%eax
 187:	84 c0                	test   %al,%al
 189:	74 14                	je     19f <print_mode+0x12d>
    printf(1, "x");
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	68 ea 0a 00 00       	push   $0xaea
 193:	6a 01                	push   $0x1
 195:	e8 78 05 00 00       	call   712 <printf>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	eb 12                	jmp    1b1 <print_mode+0x13f>
  else
    printf(1, "-");
 19f:	83 ec 08             	sub    $0x8,%esp
 1a2:	68 de 0a 00 00       	push   $0xade
 1a7:	6a 01                	push   $0x1
 1a9:	e8 64 05 00 00       	call   712 <printf>
 1ae:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1b8:	83 e0 20             	and    $0x20,%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 14                	je     1d3 <print_mode+0x161>
    printf(1, "r");
 1bf:	83 ec 08             	sub    $0x8,%esp
 1c2:	68 e4 0a 00 00       	push   $0xae4
 1c7:	6a 01                	push   $0x1
 1c9:	e8 44 05 00 00       	call   712 <printf>
 1ce:	83 c4 10             	add    $0x10,%esp
 1d1:	eb 12                	jmp    1e5 <print_mode+0x173>
  else
    printf(1, "-");
 1d3:	83 ec 08             	sub    $0x8,%esp
 1d6:	68 de 0a 00 00       	push   $0xade
 1db:	6a 01                	push   $0x1
 1dd:	e8 30 05 00 00       	call   712 <printf>
 1e2:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1ec:	83 e0 10             	and    $0x10,%eax
 1ef:	84 c0                	test   %al,%al
 1f1:	74 14                	je     207 <print_mode+0x195>
    printf(1, "w");
 1f3:	83 ec 08             	sub    $0x8,%esp
 1f6:	68 e6 0a 00 00       	push   $0xae6
 1fb:	6a 01                	push   $0x1
 1fd:	e8 10 05 00 00       	call   712 <printf>
 202:	83 c4 10             	add    $0x10,%esp
 205:	eb 12                	jmp    219 <print_mode+0x1a7>
  else
    printf(1, "-");
 207:	83 ec 08             	sub    $0x8,%esp
 20a:	68 de 0a 00 00       	push   $0xade
 20f:	6a 01                	push   $0x1
 211:	e8 fc 04 00 00       	call   712 <printf>
 216:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 220:	83 e0 08             	and    $0x8,%eax
 223:	84 c0                	test   %al,%al
 225:	74 14                	je     23b <print_mode+0x1c9>
    printf(1, "x");
 227:	83 ec 08             	sub    $0x8,%esp
 22a:	68 ea 0a 00 00       	push   $0xaea
 22f:	6a 01                	push   $0x1
 231:	e8 dc 04 00 00       	call   712 <printf>
 236:	83 c4 10             	add    $0x10,%esp
 239:	eb 12                	jmp    24d <print_mode+0x1db>
  else
    printf(1, "-");
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	68 de 0a 00 00       	push   $0xade
 243:	6a 01                	push   $0x1
 245:	e8 c8 04 00 00       	call   712 <printf>
 24a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 254:	83 e0 04             	and    $0x4,%eax
 257:	84 c0                	test   %al,%al
 259:	74 14                	je     26f <print_mode+0x1fd>
    printf(1, "r");
 25b:	83 ec 08             	sub    $0x8,%esp
 25e:	68 e4 0a 00 00       	push   $0xae4
 263:	6a 01                	push   $0x1
 265:	e8 a8 04 00 00       	call   712 <printf>
 26a:	83 c4 10             	add    $0x10,%esp
 26d:	eb 12                	jmp    281 <print_mode+0x20f>
  else
    printf(1, "-");
 26f:	83 ec 08             	sub    $0x8,%esp
 272:	68 de 0a 00 00       	push   $0xade
 277:	6a 01                	push   $0x1
 279:	e8 94 04 00 00       	call   712 <printf>
 27e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 288:	83 e0 02             	and    $0x2,%eax
 28b:	84 c0                	test   %al,%al
 28d:	74 14                	je     2a3 <print_mode+0x231>
    printf(1, "w");
 28f:	83 ec 08             	sub    $0x8,%esp
 292:	68 e6 0a 00 00       	push   $0xae6
 297:	6a 01                	push   $0x1
 299:	e8 74 04 00 00       	call   712 <printf>
 29e:	83 c4 10             	add    $0x10,%esp
 2a1:	eb 12                	jmp    2b5 <print_mode+0x243>
  else
    printf(1, "-");
 2a3:	83 ec 08             	sub    $0x8,%esp
 2a6:	68 de 0a 00 00       	push   $0xade
 2ab:	6a 01                	push   $0x1
 2ad:	e8 60 04 00 00       	call   712 <printf>
 2b2:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2bc:	83 e0 01             	and    $0x1,%eax
 2bf:	84 c0                	test   %al,%al
 2c1:	74 14                	je     2d7 <print_mode+0x265>
    printf(1, "x");
 2c3:	83 ec 08             	sub    $0x8,%esp
 2c6:	68 ea 0a 00 00       	push   $0xaea
 2cb:	6a 01                	push   $0x1
 2cd:	e8 40 04 00 00       	call   712 <printf>
 2d2:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 2d5:	eb 13                	jmp    2ea <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 2d7:	83 ec 08             	sub    $0x8,%esp
 2da:	68 de 0a 00 00       	push   $0xade
 2df:	6a 01                	push   $0x1
 2e1:	e8 2c 04 00 00       	call   712 <printf>
 2e6:	83 c4 10             	add    $0x10,%esp

  return;
 2e9:	90                   	nop
}
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    

000002ec <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	57                   	push   %edi
 2f0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f4:	8b 55 10             	mov    0x10(%ebp),%edx
 2f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fa:	89 cb                	mov    %ecx,%ebx
 2fc:	89 df                	mov    %ebx,%edi
 2fe:	89 d1                	mov    %edx,%ecx
 300:	fc                   	cld    
 301:	f3 aa                	rep stos %al,%es:(%edi)
 303:	89 ca                	mov    %ecx,%edx
 305:	89 fb                	mov    %edi,%ebx
 307:	89 5d 08             	mov    %ebx,0x8(%ebp)
 30a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 30d:	90                   	nop
 30e:	5b                   	pop    %ebx
 30f:	5f                   	pop    %edi
 310:	5d                   	pop    %ebp
 311:	c3                   	ret    

00000312 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 31e:	90                   	nop
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	8d 50 01             	lea    0x1(%eax),%edx
 325:	89 55 08             	mov    %edx,0x8(%ebp)
 328:	8b 55 0c             	mov    0xc(%ebp),%edx
 32b:	8d 4a 01             	lea    0x1(%edx),%ecx
 32e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 331:	0f b6 12             	movzbl (%edx),%edx
 334:	88 10                	mov    %dl,(%eax)
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	84 c0                	test   %al,%al
 33b:	75 e2                	jne    31f <strcpy+0xd>
    ;
  return os;
 33d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 340:	c9                   	leave  
 341:	c3                   	ret    

00000342 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 345:	eb 08                	jmp    34f <strcmp+0xd>
    p++, q++;
 347:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	84 c0                	test   %al,%al
 357:	74 10                	je     369 <strcmp+0x27>
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	0f b6 10             	movzbl (%eax),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	0f b6 00             	movzbl (%eax),%eax
 365:	38 c2                	cmp    %al,%dl
 367:	74 de                	je     347 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	0f b6 d0             	movzbl %al,%edx
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	0f b6 c0             	movzbl %al,%eax
 37b:	29 c2                	sub    %eax,%edx
 37d:	89 d0                	mov    %edx,%eax
}
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    

00000381 <strlen>:

uint
strlen(char *s)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 387:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 38e:	eb 04                	jmp    394 <strlen+0x13>
 390:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 394:	8b 55 fc             	mov    -0x4(%ebp),%edx
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	01 d0                	add    %edx,%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	75 ed                	jne    390 <strlen+0xf>
    ;
  return n;
 3a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ab:	8b 45 10             	mov    0x10(%ebp),%eax
 3ae:	50                   	push   %eax
 3af:	ff 75 0c             	pushl  0xc(%ebp)
 3b2:	ff 75 08             	pushl  0x8(%ebp)
 3b5:	e8 32 ff ff ff       	call   2ec <stosb>
 3ba:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c0:	c9                   	leave  
 3c1:	c3                   	ret    

000003c2 <strchr>:

char*
strchr(const char *s, char c)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
 3c5:	83 ec 04             	sub    $0x4,%esp
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3ce:	eb 14                	jmp    3e4 <strchr+0x22>
    if(*s == c)
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3d9:	75 05                	jne    3e0 <strchr+0x1e>
      return (char*)s;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	eb 13                	jmp    3f3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	84 c0                	test   %al,%al
 3ec:	75 e2                	jne    3d0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3f3:	c9                   	leave  
 3f4:	c3                   	ret    

000003f5 <gets>:

char*
gets(char *buf, int max)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 402:	eb 42                	jmp    446 <gets+0x51>
    cc = read(0, &c, 1);
 404:	83 ec 04             	sub    $0x4,%esp
 407:	6a 01                	push   $0x1
 409:	8d 45 ef             	lea    -0x11(%ebp),%eax
 40c:	50                   	push   %eax
 40d:	6a 00                	push   $0x0
 40f:	e8 47 01 00 00       	call   55b <read>
 414:	83 c4 10             	add    $0x10,%esp
 417:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 41a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41e:	7e 33                	jle    453 <gets+0x5e>
      break;
    buf[i++] = c;
 420:	8b 45 f4             	mov    -0xc(%ebp),%eax
 423:	8d 50 01             	lea    0x1(%eax),%edx
 426:	89 55 f4             	mov    %edx,-0xc(%ebp)
 429:	89 c2                	mov    %eax,%edx
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	01 c2                	add    %eax,%edx
 430:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 434:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 436:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 43a:	3c 0a                	cmp    $0xa,%al
 43c:	74 16                	je     454 <gets+0x5f>
 43e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 442:	3c 0d                	cmp    $0xd,%al
 444:	74 0e                	je     454 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 446:	8b 45 f4             	mov    -0xc(%ebp),%eax
 449:	83 c0 01             	add    $0x1,%eax
 44c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 44f:	7c b3                	jl     404 <gets+0xf>
 451:	eb 01                	jmp    454 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 453:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 454:	8b 55 f4             	mov    -0xc(%ebp),%edx
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	01 d0                	add    %edx,%eax
 45c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 462:	c9                   	leave  
 463:	c3                   	ret    

00000464 <stat>:

int
stat(char *n, struct stat *st)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 46a:	83 ec 08             	sub    $0x8,%esp
 46d:	6a 00                	push   $0x0
 46f:	ff 75 08             	pushl  0x8(%ebp)
 472:	e8 0c 01 00 00       	call   583 <open>
 477:	83 c4 10             	add    $0x10,%esp
 47a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 47d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 481:	79 07                	jns    48a <stat+0x26>
    return -1;
 483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 488:	eb 25                	jmp    4af <stat+0x4b>
  r = fstat(fd, st);
 48a:	83 ec 08             	sub    $0x8,%esp
 48d:	ff 75 0c             	pushl  0xc(%ebp)
 490:	ff 75 f4             	pushl  -0xc(%ebp)
 493:	e8 03 01 00 00       	call   59b <fstat>
 498:	83 c4 10             	add    $0x10,%esp
 49b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 49e:	83 ec 0c             	sub    $0xc,%esp
 4a1:	ff 75 f4             	pushl  -0xc(%ebp)
 4a4:	e8 c2 00 00 00       	call   56b <close>
 4a9:	83 c4 10             	add    $0x10,%esp
  return r;
 4ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4af:	c9                   	leave  
 4b0:	c3                   	ret    

000004b1 <atoi>:

int
atoi(const char *s)
{
 4b1:	55                   	push   %ebp
 4b2:	89 e5                	mov    %esp,%ebp
 4b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4be:	eb 25                	jmp    4e5 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c3:	89 d0                	mov    %edx,%eax
 4c5:	c1 e0 02             	shl    $0x2,%eax
 4c8:	01 d0                	add    %edx,%eax
 4ca:	01 c0                	add    %eax,%eax
 4cc:	89 c1                	mov    %eax,%ecx
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	8d 50 01             	lea    0x1(%eax),%edx
 4d4:	89 55 08             	mov    %edx,0x8(%ebp)
 4d7:	0f b6 00             	movzbl (%eax),%eax
 4da:	0f be c0             	movsbl %al,%eax
 4dd:	01 c8                	add    %ecx,%eax
 4df:	83 e8 30             	sub    $0x30,%eax
 4e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	0f b6 00             	movzbl (%eax),%eax
 4eb:	3c 2f                	cmp    $0x2f,%al
 4ed:	7e 0a                	jle    4f9 <atoi+0x48>
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	0f b6 00             	movzbl (%eax),%eax
 4f5:	3c 39                	cmp    $0x39,%al
 4f7:	7e c7                	jle    4c0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4fc:	c9                   	leave  
 4fd:	c3                   	ret    

000004fe <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4fe:	55                   	push   %ebp
 4ff:	89 e5                	mov    %esp,%ebp
 501:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 50a:	8b 45 0c             	mov    0xc(%ebp),%eax
 50d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 510:	eb 17                	jmp    529 <memmove+0x2b>
    *dst++ = *src++;
 512:	8b 45 fc             	mov    -0x4(%ebp),%eax
 515:	8d 50 01             	lea    0x1(%eax),%edx
 518:	89 55 fc             	mov    %edx,-0x4(%ebp)
 51b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 51e:	8d 4a 01             	lea    0x1(%edx),%ecx
 521:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 524:	0f b6 12             	movzbl (%edx),%edx
 527:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 529:	8b 45 10             	mov    0x10(%ebp),%eax
 52c:	8d 50 ff             	lea    -0x1(%eax),%edx
 52f:	89 55 10             	mov    %edx,0x10(%ebp)
 532:	85 c0                	test   %eax,%eax
 534:	7f dc                	jg     512 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 536:	8b 45 08             	mov    0x8(%ebp),%eax
}
 539:	c9                   	leave  
 53a:	c3                   	ret    

0000053b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53b:	b8 01 00 00 00       	mov    $0x1,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <exit>:
SYSCALL(exit)
 543:	b8 02 00 00 00       	mov    $0x2,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <wait>:
SYSCALL(wait)
 54b:	b8 03 00 00 00       	mov    $0x3,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <pipe>:
SYSCALL(pipe)
 553:	b8 04 00 00 00       	mov    $0x4,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <read>:
SYSCALL(read)
 55b:	b8 05 00 00 00       	mov    $0x5,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <write>:
SYSCALL(write)
 563:	b8 10 00 00 00       	mov    $0x10,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <close>:
SYSCALL(close)
 56b:	b8 15 00 00 00       	mov    $0x15,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <kill>:
SYSCALL(kill)
 573:	b8 06 00 00 00       	mov    $0x6,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <exec>:
SYSCALL(exec)
 57b:	b8 07 00 00 00       	mov    $0x7,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <open>:
SYSCALL(open)
 583:	b8 0f 00 00 00       	mov    $0xf,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <mknod>:
SYSCALL(mknod)
 58b:	b8 11 00 00 00       	mov    $0x11,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <unlink>:
SYSCALL(unlink)
 593:	b8 12 00 00 00       	mov    $0x12,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <fstat>:
SYSCALL(fstat)
 59b:	b8 08 00 00 00       	mov    $0x8,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <link>:
SYSCALL(link)
 5a3:	b8 13 00 00 00       	mov    $0x13,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <mkdir>:
SYSCALL(mkdir)
 5ab:	b8 14 00 00 00       	mov    $0x14,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <chdir>:
SYSCALL(chdir)
 5b3:	b8 09 00 00 00       	mov    $0x9,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <dup>:
SYSCALL(dup)
 5bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <getpid>:
SYSCALL(getpid)
 5c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <sbrk>:
SYSCALL(sbrk)
 5cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <sleep>:
SYSCALL(sleep)
 5d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <uptime>:
SYSCALL(uptime)
 5db:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <halt>:
SYSCALL(halt)
 5e3:	b8 16 00 00 00       	mov    $0x16,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <date>:
//Student Implementations 
SYSCALL(date)
 5eb:	b8 17 00 00 00       	mov    $0x17,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <getuid>:

SYSCALL(getuid)
 5f3:	b8 18 00 00 00       	mov    $0x18,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <getgid>:
SYSCALL(getgid)
 5fb:	b8 19 00 00 00       	mov    $0x19,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <getppid>:
SYSCALL(getppid)
 603:	b8 1a 00 00 00       	mov    $0x1a,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <setuid>:

SYSCALL(setuid)
 60b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <setgid>:
SYSCALL(setgid)
 613:	b8 1c 00 00 00       	mov    $0x1c,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <getprocs>:
SYSCALL(getprocs)
 61b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <chown>:

SYSCALL(chown)
 623:	b8 1e 00 00 00       	mov    $0x1e,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <chgrp>:
SYSCALL(chgrp)
 62b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <chmod>:
SYSCALL(chmod)
 633:	b8 20 00 00 00       	mov    $0x20,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 63b:	55                   	push   %ebp
 63c:	89 e5                	mov    %esp,%ebp
 63e:	83 ec 18             	sub    $0x18,%esp
 641:	8b 45 0c             	mov    0xc(%ebp),%eax
 644:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 647:	83 ec 04             	sub    $0x4,%esp
 64a:	6a 01                	push   $0x1
 64c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 64f:	50                   	push   %eax
 650:	ff 75 08             	pushl  0x8(%ebp)
 653:	e8 0b ff ff ff       	call   563 <write>
 658:	83 c4 10             	add    $0x10,%esp
}
 65b:	90                   	nop
 65c:	c9                   	leave  
 65d:	c3                   	ret    

0000065e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65e:	55                   	push   %ebp
 65f:	89 e5                	mov    %esp,%ebp
 661:	53                   	push   %ebx
 662:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 665:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 66c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 670:	74 17                	je     689 <printint+0x2b>
 672:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 676:	79 11                	jns    689 <printint+0x2b>
    neg = 1;
 678:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 67f:	8b 45 0c             	mov    0xc(%ebp),%eax
 682:	f7 d8                	neg    %eax
 684:	89 45 ec             	mov    %eax,-0x14(%ebp)
 687:	eb 06                	jmp    68f <printint+0x31>
  } else {
    x = xx;
 689:	8b 45 0c             	mov    0xc(%ebp),%eax
 68c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 68f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 696:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 699:	8d 41 01             	lea    0x1(%ecx),%eax
 69c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 69f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a5:	ba 00 00 00 00       	mov    $0x0,%edx
 6aa:	f7 f3                	div    %ebx
 6ac:	89 d0                	mov    %edx,%eax
 6ae:	0f b6 80 60 0d 00 00 	movzbl 0xd60(%eax),%eax
 6b5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6bf:	ba 00 00 00 00       	mov    $0x0,%edx
 6c4:	f7 f3                	div    %ebx
 6c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6cd:	75 c7                	jne    696 <printint+0x38>
  if(neg)
 6cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d3:	74 2d                	je     702 <printint+0xa4>
    buf[i++] = '-';
 6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d8:	8d 50 01             	lea    0x1(%eax),%edx
 6db:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6de:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6e3:	eb 1d                	jmp    702 <printint+0xa4>
    putc(fd, buf[i]);
 6e5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6eb:	01 d0                	add    %edx,%eax
 6ed:	0f b6 00             	movzbl (%eax),%eax
 6f0:	0f be c0             	movsbl %al,%eax
 6f3:	83 ec 08             	sub    $0x8,%esp
 6f6:	50                   	push   %eax
 6f7:	ff 75 08             	pushl  0x8(%ebp)
 6fa:	e8 3c ff ff ff       	call   63b <putc>
 6ff:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 702:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 70a:	79 d9                	jns    6e5 <printint+0x87>
    putc(fd, buf[i]);
}
 70c:	90                   	nop
 70d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 710:	c9                   	leave  
 711:	c3                   	ret    

00000712 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 712:	55                   	push   %ebp
 713:	89 e5                	mov    %esp,%ebp
 715:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 718:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 71f:	8d 45 0c             	lea    0xc(%ebp),%eax
 722:	83 c0 04             	add    $0x4,%eax
 725:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 728:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 72f:	e9 59 01 00 00       	jmp    88d <printf+0x17b>
    c = fmt[i] & 0xff;
 734:	8b 55 0c             	mov    0xc(%ebp),%edx
 737:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73a:	01 d0                	add    %edx,%eax
 73c:	0f b6 00             	movzbl (%eax),%eax
 73f:	0f be c0             	movsbl %al,%eax
 742:	25 ff 00 00 00       	and    $0xff,%eax
 747:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 74a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 74e:	75 2c                	jne    77c <printf+0x6a>
      if(c == '%'){
 750:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 754:	75 0c                	jne    762 <printf+0x50>
        state = '%';
 756:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 75d:	e9 27 01 00 00       	jmp    889 <printf+0x177>
      } else {
        putc(fd, c);
 762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 765:	0f be c0             	movsbl %al,%eax
 768:	83 ec 08             	sub    $0x8,%esp
 76b:	50                   	push   %eax
 76c:	ff 75 08             	pushl  0x8(%ebp)
 76f:	e8 c7 fe ff ff       	call   63b <putc>
 774:	83 c4 10             	add    $0x10,%esp
 777:	e9 0d 01 00 00       	jmp    889 <printf+0x177>
      }
    } else if(state == '%'){
 77c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 780:	0f 85 03 01 00 00    	jne    889 <printf+0x177>
      if(c == 'd'){
 786:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 78a:	75 1e                	jne    7aa <printf+0x98>
        printint(fd, *ap, 10, 1);
 78c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	6a 01                	push   $0x1
 793:	6a 0a                	push   $0xa
 795:	50                   	push   %eax
 796:	ff 75 08             	pushl  0x8(%ebp)
 799:	e8 c0 fe ff ff       	call   65e <printint>
 79e:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a5:	e9 d8 00 00 00       	jmp    882 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7aa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ae:	74 06                	je     7b6 <printf+0xa4>
 7b0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b4:	75 1e                	jne    7d4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	6a 00                	push   $0x0
 7bd:	6a 10                	push   $0x10
 7bf:	50                   	push   %eax
 7c0:	ff 75 08             	pushl  0x8(%ebp)
 7c3:	e8 96 fe ff ff       	call   65e <printint>
 7c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 7cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7cf:	e9 ae 00 00 00       	jmp    882 <printf+0x170>
      } else if(c == 's'){
 7d4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7d8:	75 43                	jne    81d <printf+0x10b>
        s = (char*)*ap;
 7da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ea:	75 25                	jne    811 <printf+0xff>
          s = "(null)";
 7ec:	c7 45 f4 ec 0a 00 00 	movl   $0xaec,-0xc(%ebp)
        while(*s != 0){
 7f3:	eb 1c                	jmp    811 <printf+0xff>
          putc(fd, *s);
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	0f b6 00             	movzbl (%eax),%eax
 7fb:	0f be c0             	movsbl %al,%eax
 7fe:	83 ec 08             	sub    $0x8,%esp
 801:	50                   	push   %eax
 802:	ff 75 08             	pushl  0x8(%ebp)
 805:	e8 31 fe ff ff       	call   63b <putc>
 80a:	83 c4 10             	add    $0x10,%esp
          s++;
 80d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	0f b6 00             	movzbl (%eax),%eax
 817:	84 c0                	test   %al,%al
 819:	75 da                	jne    7f5 <printf+0xe3>
 81b:	eb 65                	jmp    882 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 81d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 821:	75 1d                	jne    840 <printf+0x12e>
        putc(fd, *ap);
 823:	8b 45 e8             	mov    -0x18(%ebp),%eax
 826:	8b 00                	mov    (%eax),%eax
 828:	0f be c0             	movsbl %al,%eax
 82b:	83 ec 08             	sub    $0x8,%esp
 82e:	50                   	push   %eax
 82f:	ff 75 08             	pushl  0x8(%ebp)
 832:	e8 04 fe ff ff       	call   63b <putc>
 837:	83 c4 10             	add    $0x10,%esp
        ap++;
 83a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83e:	eb 42                	jmp    882 <printf+0x170>
      } else if(c == '%'){
 840:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 844:	75 17                	jne    85d <printf+0x14b>
        putc(fd, c);
 846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 849:	0f be c0             	movsbl %al,%eax
 84c:	83 ec 08             	sub    $0x8,%esp
 84f:	50                   	push   %eax
 850:	ff 75 08             	pushl  0x8(%ebp)
 853:	e8 e3 fd ff ff       	call   63b <putc>
 858:	83 c4 10             	add    $0x10,%esp
 85b:	eb 25                	jmp    882 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 85d:	83 ec 08             	sub    $0x8,%esp
 860:	6a 25                	push   $0x25
 862:	ff 75 08             	pushl  0x8(%ebp)
 865:	e8 d1 fd ff ff       	call   63b <putc>
 86a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 86d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 870:	0f be c0             	movsbl %al,%eax
 873:	83 ec 08             	sub    $0x8,%esp
 876:	50                   	push   %eax
 877:	ff 75 08             	pushl  0x8(%ebp)
 87a:	e8 bc fd ff ff       	call   63b <putc>
 87f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 882:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 889:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 88d:	8b 55 0c             	mov    0xc(%ebp),%edx
 890:	8b 45 f0             	mov    -0x10(%ebp),%eax
 893:	01 d0                	add    %edx,%eax
 895:	0f b6 00             	movzbl (%eax),%eax
 898:	84 c0                	test   %al,%al
 89a:	0f 85 94 fe ff ff    	jne    734 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8a0:	90                   	nop
 8a1:	c9                   	leave  
 8a2:	c3                   	ret    

000008a3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a3:	55                   	push   %ebp
 8a4:	89 e5                	mov    %esp,%ebp
 8a6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
 8ac:	83 e8 08             	sub    $0x8,%eax
 8af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 8b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ba:	eb 24                	jmp    8e0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c4:	77 12                	ja     8d8 <free+0x35>
 8c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8cc:	77 24                	ja     8f2 <free+0x4f>
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8b 00                	mov    (%eax),%eax
 8d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d6:	77 1a                	ja     8f2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e6:	76 d4                	jbe    8bc <free+0x19>
 8e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8eb:	8b 00                	mov    (%eax),%eax
 8ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f0:	76 ca                	jbe    8bc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f5:	8b 40 04             	mov    0x4(%eax),%eax
 8f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 902:	01 c2                	add    %eax,%edx
 904:	8b 45 fc             	mov    -0x4(%ebp),%eax
 907:	8b 00                	mov    (%eax),%eax
 909:	39 c2                	cmp    %eax,%edx
 90b:	75 24                	jne    931 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 90d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 910:	8b 50 04             	mov    0x4(%eax),%edx
 913:	8b 45 fc             	mov    -0x4(%ebp),%eax
 916:	8b 00                	mov    (%eax),%eax
 918:	8b 40 04             	mov    0x4(%eax),%eax
 91b:	01 c2                	add    %eax,%edx
 91d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 920:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 923:	8b 45 fc             	mov    -0x4(%ebp),%eax
 926:	8b 00                	mov    (%eax),%eax
 928:	8b 10                	mov    (%eax),%edx
 92a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92d:	89 10                	mov    %edx,(%eax)
 92f:	eb 0a                	jmp    93b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 10                	mov    (%eax),%edx
 936:	8b 45 f8             	mov    -0x8(%ebp),%eax
 939:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 40 04             	mov    0x4(%eax),%eax
 941:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 948:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94b:	01 d0                	add    %edx,%eax
 94d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 950:	75 20                	jne    972 <free+0xcf>
    p->s.size += bp->s.size;
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	8b 50 04             	mov    0x4(%eax),%edx
 958:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95b:	8b 40 04             	mov    0x4(%eax),%eax
 95e:	01 c2                	add    %eax,%edx
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 966:	8b 45 f8             	mov    -0x8(%ebp),%eax
 969:	8b 10                	mov    (%eax),%edx
 96b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96e:	89 10                	mov    %edx,(%eax)
 970:	eb 08                	jmp    97a <free+0xd7>
  } else
    p->s.ptr = bp;
 972:	8b 45 fc             	mov    -0x4(%ebp),%eax
 975:	8b 55 f8             	mov    -0x8(%ebp),%edx
 978:	89 10                	mov    %edx,(%eax)
  freep = p;
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	a3 7c 0d 00 00       	mov    %eax,0xd7c
}
 982:	90                   	nop
 983:	c9                   	leave  
 984:	c3                   	ret    

00000985 <morecore>:

static Header*
morecore(uint nu)
{
 985:	55                   	push   %ebp
 986:	89 e5                	mov    %esp,%ebp
 988:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 98b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 992:	77 07                	ja     99b <morecore+0x16>
    nu = 4096;
 994:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 99b:	8b 45 08             	mov    0x8(%ebp),%eax
 99e:	c1 e0 03             	shl    $0x3,%eax
 9a1:	83 ec 0c             	sub    $0xc,%esp
 9a4:	50                   	push   %eax
 9a5:	e8 21 fc ff ff       	call   5cb <sbrk>
 9aa:	83 c4 10             	add    $0x10,%esp
 9ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b4:	75 07                	jne    9bd <morecore+0x38>
    return 0;
 9b6:	b8 00 00 00 00       	mov    $0x0,%eax
 9bb:	eb 26                	jmp    9e3 <morecore+0x5e>
  hp = (Header*)p;
 9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c6:	8b 55 08             	mov    0x8(%ebp),%edx
 9c9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cf:	83 c0 08             	add    $0x8,%eax
 9d2:	83 ec 0c             	sub    $0xc,%esp
 9d5:	50                   	push   %eax
 9d6:	e8 c8 fe ff ff       	call   8a3 <free>
 9db:	83 c4 10             	add    $0x10,%esp
  return freep;
 9de:	a1 7c 0d 00 00       	mov    0xd7c,%eax
}
 9e3:	c9                   	leave  
 9e4:	c3                   	ret    

000009e5 <malloc>:

void*
malloc(uint nbytes)
{
 9e5:	55                   	push   %ebp
 9e6:	89 e5                	mov    %esp,%ebp
 9e8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9eb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ee:	83 c0 07             	add    $0x7,%eax
 9f1:	c1 e8 03             	shr    $0x3,%eax
 9f4:	83 c0 01             	add    $0x1,%eax
 9f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9fa:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 9ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a06:	75 23                	jne    a2b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a08:	c7 45 f0 74 0d 00 00 	movl   $0xd74,-0x10(%ebp)
 a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a12:	a3 7c 0d 00 00       	mov    %eax,0xd7c
 a17:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 a1c:	a3 74 0d 00 00       	mov    %eax,0xd74
    base.s.size = 0;
 a21:	c7 05 78 0d 00 00 00 	movl   $0x0,0xd78
 a28:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2e:	8b 00                	mov    (%eax),%eax
 a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 40 04             	mov    0x4(%eax),%eax
 a39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a3c:	72 4d                	jb     a8b <malloc+0xa6>
      if(p->s.size == nunits)
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 40 04             	mov    0x4(%eax),%eax
 a44:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a47:	75 0c                	jne    a55 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	8b 10                	mov    (%eax),%edx
 a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a51:	89 10                	mov    %edx,(%eax)
 a53:	eb 26                	jmp    a7b <malloc+0x96>
      else {
        p->s.size -= nunits;
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	8b 40 04             	mov    0x4(%eax),%eax
 a5b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a5e:	89 c2                	mov    %eax,%edx
 a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a63:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a69:	8b 40 04             	mov    0x4(%eax),%eax
 a6c:	c1 e0 03             	shl    $0x3,%eax
 a6f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a75:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a78:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7e:	a3 7c 0d 00 00       	mov    %eax,0xd7c
      return (void*)(p + 1);
 a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a86:	83 c0 08             	add    $0x8,%eax
 a89:	eb 3b                	jmp    ac6 <malloc+0xe1>
    }
    if(p == freep)
 a8b:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 a90:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a93:	75 1e                	jne    ab3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a95:	83 ec 0c             	sub    $0xc,%esp
 a98:	ff 75 ec             	pushl  -0x14(%ebp)
 a9b:	e8 e5 fe ff ff       	call   985 <morecore>
 aa0:	83 c4 10             	add    $0x10,%esp
 aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aaa:	75 07                	jne    ab3 <malloc+0xce>
        return 0;
 aac:	b8 00 00 00 00       	mov    $0x0,%eax
 ab1:	eb 13                	jmp    ac6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	8b 00                	mov    (%eax),%eax
 abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ac1:	e9 6d ff ff ff       	jmp    a33 <malloc+0x4e>
}
 ac6:	c9                   	leave  
 ac7:	c3                   	ret    
