
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba a3 0a 00 00       	mov    $0xaa3,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba a5 0a 00 00       	mov    $0xaa5,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 a7 0a 00 00       	push   $0xaa7
  4b:	6a 01                	push   $0x1
  4d:	e8 9b 06 00 00       	call   6ed <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 d1 04 00 00       	call   536 <exit>

00000065 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  6b:	8b 45 08             	mov    0x8(%ebp),%eax
  6e:	0f b7 00             	movzwl (%eax),%eax
  71:	98                   	cwtl   
  72:	83 f8 02             	cmp    $0x2,%eax
  75:	74 1e                	je     95 <print_mode+0x30>
  77:	83 f8 03             	cmp    $0x3,%eax
  7a:	74 2d                	je     a9 <print_mode+0x44>
  7c:	83 f8 01             	cmp    $0x1,%eax
  7f:	75 3c                	jne    bd <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  81:	83 ec 08             	sub    $0x8,%esp
  84:	68 ac 0a 00 00       	push   $0xaac
  89:	6a 01                	push   $0x1
  8b:	e8 5d 06 00 00       	call   6ed <printf>
  90:	83 c4 10             	add    $0x10,%esp
  93:	eb 3a                	jmp    cf <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 ae 0a 00 00       	push   $0xaae
  9d:	6a 01                	push   $0x1
  9f:	e8 49 06 00 00       	call   6ed <printf>
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	eb 26                	jmp    cf <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  a9:	83 ec 08             	sub    $0x8,%esp
  ac:	68 b0 0a 00 00       	push   $0xab0
  b1:	6a 01                	push   $0x1
  b3:	e8 35 06 00 00       	call   6ed <printf>
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	eb 12                	jmp    cf <print_mode+0x6a>
    default: printf(1, "?");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 b2 0a 00 00       	push   $0xab2
  c5:	6a 01                	push   $0x1
  c7:	e8 21 06 00 00       	call   6ed <printf>
  cc:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  d6:	83 e0 01             	and    $0x1,%eax
  d9:	84 c0                	test   %al,%al
  db:	74 14                	je     f1 <print_mode+0x8c>
    printf(1, "r");
  dd:	83 ec 08             	sub    $0x8,%esp
  e0:	68 b4 0a 00 00       	push   $0xab4
  e5:	6a 01                	push   $0x1
  e7:	e8 01 06 00 00       	call   6ed <printf>
  ec:	83 c4 10             	add    $0x10,%esp
  ef:	eb 12                	jmp    103 <print_mode+0x9e>
  else
    printf(1, "-");
  f1:	83 ec 08             	sub    $0x8,%esp
  f4:	68 ae 0a 00 00       	push   $0xaae
  f9:	6a 01                	push   $0x1
  fb:	e8 ed 05 00 00       	call   6ed <printf>
 100:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 10a:	83 e0 80             	and    $0xffffff80,%eax
 10d:	84 c0                	test   %al,%al
 10f:	74 14                	je     125 <print_mode+0xc0>
    printf(1, "w");
 111:	83 ec 08             	sub    $0x8,%esp
 114:	68 b6 0a 00 00       	push   $0xab6
 119:	6a 01                	push   $0x1
 11b:	e8 cd 05 00 00       	call   6ed <printf>
 120:	83 c4 10             	add    $0x10,%esp
 123:	eb 12                	jmp    137 <print_mode+0xd2>
  else
    printf(1, "-");
 125:	83 ec 08             	sub    $0x8,%esp
 128:	68 ae 0a 00 00       	push   $0xaae
 12d:	6a 01                	push   $0x1
 12f:	e8 b9 05 00 00       	call   6ed <printf>
 134:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 13e:	c0 e8 06             	shr    $0x6,%al
 141:	83 e0 01             	and    $0x1,%eax
 144:	0f b6 d0             	movzbl %al,%edx
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 14e:	d0 e8                	shr    %al
 150:	83 e0 01             	and    $0x1,%eax
 153:	0f b6 c0             	movzbl %al,%eax
 156:	21 d0                	and    %edx,%eax
 158:	85 c0                	test   %eax,%eax
 15a:	74 14                	je     170 <print_mode+0x10b>
    printf(1, "S");
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	68 b8 0a 00 00       	push   $0xab8
 164:	6a 01                	push   $0x1
 166:	e8 82 05 00 00       	call   6ed <printf>
 16b:	83 c4 10             	add    $0x10,%esp
 16e:	eb 34                	jmp    1a4 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 177:	83 e0 40             	and    $0x40,%eax
 17a:	84 c0                	test   %al,%al
 17c:	74 14                	je     192 <print_mode+0x12d>
    printf(1, "x");
 17e:	83 ec 08             	sub    $0x8,%esp
 181:	68 ba 0a 00 00       	push   $0xaba
 186:	6a 01                	push   $0x1
 188:	e8 60 05 00 00       	call   6ed <printf>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	eb 12                	jmp    1a4 <print_mode+0x13f>
  else
    printf(1, "-");
 192:	83 ec 08             	sub    $0x8,%esp
 195:	68 ae 0a 00 00       	push   $0xaae
 19a:	6a 01                	push   $0x1
 19c:	e8 4c 05 00 00       	call   6ed <printf>
 1a1:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1ab:	83 e0 20             	and    $0x20,%eax
 1ae:	84 c0                	test   %al,%al
 1b0:	74 14                	je     1c6 <print_mode+0x161>
    printf(1, "r");
 1b2:	83 ec 08             	sub    $0x8,%esp
 1b5:	68 b4 0a 00 00       	push   $0xab4
 1ba:	6a 01                	push   $0x1
 1bc:	e8 2c 05 00 00       	call   6ed <printf>
 1c1:	83 c4 10             	add    $0x10,%esp
 1c4:	eb 12                	jmp    1d8 <print_mode+0x173>
  else
    printf(1, "-");
 1c6:	83 ec 08             	sub    $0x8,%esp
 1c9:	68 ae 0a 00 00       	push   $0xaae
 1ce:	6a 01                	push   $0x1
 1d0:	e8 18 05 00 00       	call   6ed <printf>
 1d5:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1df:	83 e0 10             	and    $0x10,%eax
 1e2:	84 c0                	test   %al,%al
 1e4:	74 14                	je     1fa <print_mode+0x195>
    printf(1, "w");
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	68 b6 0a 00 00       	push   $0xab6
 1ee:	6a 01                	push   $0x1
 1f0:	e8 f8 04 00 00       	call   6ed <printf>
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	eb 12                	jmp    20c <print_mode+0x1a7>
  else
    printf(1, "-");
 1fa:	83 ec 08             	sub    $0x8,%esp
 1fd:	68 ae 0a 00 00       	push   $0xaae
 202:	6a 01                	push   $0x1
 204:	e8 e4 04 00 00       	call   6ed <printf>
 209:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 213:	83 e0 08             	and    $0x8,%eax
 216:	84 c0                	test   %al,%al
 218:	74 14                	je     22e <print_mode+0x1c9>
    printf(1, "x");
 21a:	83 ec 08             	sub    $0x8,%esp
 21d:	68 ba 0a 00 00       	push   $0xaba
 222:	6a 01                	push   $0x1
 224:	e8 c4 04 00 00       	call   6ed <printf>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	eb 12                	jmp    240 <print_mode+0x1db>
  else
    printf(1, "-");
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	68 ae 0a 00 00       	push   $0xaae
 236:	6a 01                	push   $0x1
 238:	e8 b0 04 00 00       	call   6ed <printf>
 23d:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 247:	83 e0 04             	and    $0x4,%eax
 24a:	84 c0                	test   %al,%al
 24c:	74 14                	je     262 <print_mode+0x1fd>
    printf(1, "r");
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	68 b4 0a 00 00       	push   $0xab4
 256:	6a 01                	push   $0x1
 258:	e8 90 04 00 00       	call   6ed <printf>
 25d:	83 c4 10             	add    $0x10,%esp
 260:	eb 12                	jmp    274 <print_mode+0x20f>
  else
    printf(1, "-");
 262:	83 ec 08             	sub    $0x8,%esp
 265:	68 ae 0a 00 00       	push   $0xaae
 26a:	6a 01                	push   $0x1
 26c:	e8 7c 04 00 00       	call   6ed <printf>
 271:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 27b:	83 e0 02             	and    $0x2,%eax
 27e:	84 c0                	test   %al,%al
 280:	74 14                	je     296 <print_mode+0x231>
    printf(1, "w");
 282:	83 ec 08             	sub    $0x8,%esp
 285:	68 b6 0a 00 00       	push   $0xab6
 28a:	6a 01                	push   $0x1
 28c:	e8 5c 04 00 00       	call   6ed <printf>
 291:	83 c4 10             	add    $0x10,%esp
 294:	eb 12                	jmp    2a8 <print_mode+0x243>
  else
    printf(1, "-");
 296:	83 ec 08             	sub    $0x8,%esp
 299:	68 ae 0a 00 00       	push   $0xaae
 29e:	6a 01                	push   $0x1
 2a0:	e8 48 04 00 00       	call   6ed <printf>
 2a5:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2af:	83 e0 01             	and    $0x1,%eax
 2b2:	84 c0                	test   %al,%al
 2b4:	74 14                	je     2ca <print_mode+0x265>
    printf(1, "x");
 2b6:	83 ec 08             	sub    $0x8,%esp
 2b9:	68 ba 0a 00 00       	push   $0xaba
 2be:	6a 01                	push   $0x1
 2c0:	e8 28 04 00 00       	call   6ed <printf>
 2c5:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 2c8:	eb 13                	jmp    2dd <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 2ca:	83 ec 08             	sub    $0x8,%esp
 2cd:	68 ae 0a 00 00       	push   $0xaae
 2d2:	6a 01                	push   $0x1
 2d4:	e8 14 04 00 00       	call   6ed <printf>
 2d9:	83 c4 10             	add    $0x10,%esp

  return;
 2dc:	90                   	nop
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	57                   	push   %edi
 2e3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2e7:	8b 55 10             	mov    0x10(%ebp),%edx
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 cb                	mov    %ecx,%ebx
 2ef:	89 df                	mov    %ebx,%edi
 2f1:	89 d1                	mov    %edx,%ecx
 2f3:	fc                   	cld    
 2f4:	f3 aa                	rep stos %al,%es:(%edi)
 2f6:	89 ca                	mov    %ecx,%edx
 2f8:	89 fb                	mov    %edi,%ebx
 2fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2fd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 300:	90                   	nop
 301:	5b                   	pop    %ebx
 302:	5f                   	pop    %edi
 303:	5d                   	pop    %ebp
 304:	c3                   	ret    

00000305 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 305:	55                   	push   %ebp
 306:	89 e5                	mov    %esp,%ebp
 308:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 311:	90                   	nop
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	8d 50 01             	lea    0x1(%eax),%edx
 318:	89 55 08             	mov    %edx,0x8(%ebp)
 31b:	8b 55 0c             	mov    0xc(%ebp),%edx
 31e:	8d 4a 01             	lea    0x1(%edx),%ecx
 321:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 324:	0f b6 12             	movzbl (%edx),%edx
 327:	88 10                	mov    %dl,(%eax)
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	84 c0                	test   %al,%al
 32e:	75 e2                	jne    312 <strcpy+0xd>
    ;
  return os;
 330:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 338:	eb 08                	jmp    342 <strcmp+0xd>
    p++, q++;
 33a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 33e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	84 c0                	test   %al,%al
 34a:	74 10                	je     35c <strcmp+0x27>
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	0f b6 10             	movzbl (%eax),%edx
 352:	8b 45 0c             	mov    0xc(%ebp),%eax
 355:	0f b6 00             	movzbl (%eax),%eax
 358:	38 c2                	cmp    %al,%dl
 35a:	74 de                	je     33a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	0f b6 00             	movzbl (%eax),%eax
 362:	0f b6 d0             	movzbl %al,%edx
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	0f b6 c0             	movzbl %al,%eax
 36e:	29 c2                	sub    %eax,%edx
 370:	89 d0                	mov    %edx,%eax
}
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    

00000374 <strlen>:

uint
strlen(char *s)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 37a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 381:	eb 04                	jmp    387 <strlen+0x13>
 383:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 387:	8b 55 fc             	mov    -0x4(%ebp),%edx
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	01 d0                	add    %edx,%eax
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	84 c0                	test   %al,%al
 394:	75 ed                	jne    383 <strlen+0xf>
    ;
  return n;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <memset>:

void*
memset(void *dst, int c, uint n)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 39e:	8b 45 10             	mov    0x10(%ebp),%eax
 3a1:	50                   	push   %eax
 3a2:	ff 75 0c             	pushl  0xc(%ebp)
 3a5:	ff 75 08             	pushl  0x8(%ebp)
 3a8:	e8 32 ff ff ff       	call   2df <stosb>
 3ad:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <strchr>:

char*
strchr(const char *s, char c)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 04             	sub    $0x4,%esp
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3c1:	eb 14                	jmp    3d7 <strchr+0x22>
    if(*s == c)
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3cc:	75 05                	jne    3d3 <strchr+0x1e>
      return (char*)s;
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	eb 13                	jmp    3e6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	84 c0                	test   %al,%al
 3df:	75 e2                	jne    3c3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    

000003e8 <gets>:

char*
gets(char *buf, int max)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3f5:	eb 42                	jmp    439 <gets+0x51>
    cc = read(0, &c, 1);
 3f7:	83 ec 04             	sub    $0x4,%esp
 3fa:	6a 01                	push   $0x1
 3fc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3ff:	50                   	push   %eax
 400:	6a 00                	push   $0x0
 402:	e8 47 01 00 00       	call   54e <read>
 407:	83 c4 10             	add    $0x10,%esp
 40a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 40d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 411:	7e 33                	jle    446 <gets+0x5e>
      break;
    buf[i++] = c;
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	8d 50 01             	lea    0x1(%eax),%edx
 419:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41c:	89 c2                	mov    %eax,%edx
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	01 c2                	add    %eax,%edx
 423:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 427:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 429:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 42d:	3c 0a                	cmp    $0xa,%al
 42f:	74 16                	je     447 <gets+0x5f>
 431:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 435:	3c 0d                	cmp    $0xd,%al
 437:	74 0e                	je     447 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 439:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43c:	83 c0 01             	add    $0x1,%eax
 43f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 442:	7c b3                	jl     3f7 <gets+0xf>
 444:	eb 01                	jmp    447 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 446:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 447:	8b 55 f4             	mov    -0xc(%ebp),%edx
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	01 d0                	add    %edx,%eax
 44f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 452:	8b 45 08             	mov    0x8(%ebp),%eax
}
 455:	c9                   	leave  
 456:	c3                   	ret    

00000457 <stat>:

int
stat(char *n, struct stat *st)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 45d:	83 ec 08             	sub    $0x8,%esp
 460:	6a 00                	push   $0x0
 462:	ff 75 08             	pushl  0x8(%ebp)
 465:	e8 0c 01 00 00       	call   576 <open>
 46a:	83 c4 10             	add    $0x10,%esp
 46d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 474:	79 07                	jns    47d <stat+0x26>
    return -1;
 476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 47b:	eb 25                	jmp    4a2 <stat+0x4b>
  r = fstat(fd, st);
 47d:	83 ec 08             	sub    $0x8,%esp
 480:	ff 75 0c             	pushl  0xc(%ebp)
 483:	ff 75 f4             	pushl  -0xc(%ebp)
 486:	e8 03 01 00 00       	call   58e <fstat>
 48b:	83 c4 10             	add    $0x10,%esp
 48e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 491:	83 ec 0c             	sub    $0xc,%esp
 494:	ff 75 f4             	pushl  -0xc(%ebp)
 497:	e8 c2 00 00 00       	call   55e <close>
 49c:	83 c4 10             	add    $0x10,%esp
  return r;
 49f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <atoi>:

int
atoi(const char *s)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4b1:	eb 25                	jmp    4d8 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	c1 e0 02             	shl    $0x2,%eax
 4bb:	01 d0                	add    %edx,%eax
 4bd:	01 c0                	add    %eax,%eax
 4bf:	89 c1                	mov    %eax,%ecx
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	8d 50 01             	lea    0x1(%eax),%edx
 4c7:	89 55 08             	mov    %edx,0x8(%ebp)
 4ca:	0f b6 00             	movzbl (%eax),%eax
 4cd:	0f be c0             	movsbl %al,%eax
 4d0:	01 c8                	add    %ecx,%eax
 4d2:	83 e8 30             	sub    $0x30,%eax
 4d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	0f b6 00             	movzbl (%eax),%eax
 4de:	3c 2f                	cmp    $0x2f,%al
 4e0:	7e 0a                	jle    4ec <atoi+0x48>
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	0f b6 00             	movzbl (%eax),%eax
 4e8:	3c 39                	cmp    $0x39,%al
 4ea:	7e c7                	jle    4b3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4ef:	c9                   	leave  
 4f0:	c3                   	ret    

000004f1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4f1:	55                   	push   %ebp
 4f2:	89 e5                	mov    %esp,%ebp
 4f4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 500:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 503:	eb 17                	jmp    51c <memmove+0x2b>
    *dst++ = *src++;
 505:	8b 45 fc             	mov    -0x4(%ebp),%eax
 508:	8d 50 01             	lea    0x1(%eax),%edx
 50b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 50e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 511:	8d 4a 01             	lea    0x1(%edx),%ecx
 514:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 517:	0f b6 12             	movzbl (%edx),%edx
 51a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 51c:	8b 45 10             	mov    0x10(%ebp),%eax
 51f:	8d 50 ff             	lea    -0x1(%eax),%edx
 522:	89 55 10             	mov    %edx,0x10(%ebp)
 525:	85 c0                	test   %eax,%eax
 527:	7f dc                	jg     505 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 529:	8b 45 08             	mov    0x8(%ebp),%eax
}
 52c:	c9                   	leave  
 52d:	c3                   	ret    

0000052e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 52e:	b8 01 00 00 00       	mov    $0x1,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <exit>:
SYSCALL(exit)
 536:	b8 02 00 00 00       	mov    $0x2,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <wait>:
SYSCALL(wait)
 53e:	b8 03 00 00 00       	mov    $0x3,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <pipe>:
SYSCALL(pipe)
 546:	b8 04 00 00 00       	mov    $0x4,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <read>:
SYSCALL(read)
 54e:	b8 05 00 00 00       	mov    $0x5,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <write>:
SYSCALL(write)
 556:	b8 10 00 00 00       	mov    $0x10,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <close>:
SYSCALL(close)
 55e:	b8 15 00 00 00       	mov    $0x15,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <kill>:
SYSCALL(kill)
 566:	b8 06 00 00 00       	mov    $0x6,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <exec>:
SYSCALL(exec)
 56e:	b8 07 00 00 00       	mov    $0x7,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <open>:
SYSCALL(open)
 576:	b8 0f 00 00 00       	mov    $0xf,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <mknod>:
SYSCALL(mknod)
 57e:	b8 11 00 00 00       	mov    $0x11,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <unlink>:
SYSCALL(unlink)
 586:	b8 12 00 00 00       	mov    $0x12,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <fstat>:
SYSCALL(fstat)
 58e:	b8 08 00 00 00       	mov    $0x8,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <link>:
SYSCALL(link)
 596:	b8 13 00 00 00       	mov    $0x13,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <mkdir>:
SYSCALL(mkdir)
 59e:	b8 14 00 00 00       	mov    $0x14,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <chdir>:
SYSCALL(chdir)
 5a6:	b8 09 00 00 00       	mov    $0x9,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <dup>:
SYSCALL(dup)
 5ae:	b8 0a 00 00 00       	mov    $0xa,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <getpid>:
SYSCALL(getpid)
 5b6:	b8 0b 00 00 00       	mov    $0xb,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <sbrk>:
SYSCALL(sbrk)
 5be:	b8 0c 00 00 00       	mov    $0xc,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <sleep>:
SYSCALL(sleep)
 5c6:	b8 0d 00 00 00       	mov    $0xd,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <uptime>:
SYSCALL(uptime)
 5ce:	b8 0e 00 00 00       	mov    $0xe,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <halt>:
SYSCALL(halt)
 5d6:	b8 16 00 00 00       	mov    $0x16,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    

000005de <date>:
//Student Implementations 
SYSCALL(date)
 5de:	b8 17 00 00 00       	mov    $0x17,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <getuid>:

SYSCALL(getuid)
 5e6:	b8 18 00 00 00       	mov    $0x18,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <getgid>:
SYSCALL(getgid)
 5ee:	b8 19 00 00 00       	mov    $0x19,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <getppid>:
SYSCALL(getppid)
 5f6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <setuid>:

SYSCALL(setuid)
 5fe:	b8 1b 00 00 00       	mov    $0x1b,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <setgid>:
SYSCALL(setgid)
 606:	b8 1c 00 00 00       	mov    $0x1c,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <getprocs>:
SYSCALL(getprocs)
 60e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret    

00000616 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 616:	55                   	push   %ebp
 617:	89 e5                	mov    %esp,%ebp
 619:	83 ec 18             	sub    $0x18,%esp
 61c:	8b 45 0c             	mov    0xc(%ebp),%eax
 61f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 622:	83 ec 04             	sub    $0x4,%esp
 625:	6a 01                	push   $0x1
 627:	8d 45 f4             	lea    -0xc(%ebp),%eax
 62a:	50                   	push   %eax
 62b:	ff 75 08             	pushl  0x8(%ebp)
 62e:	e8 23 ff ff ff       	call   556 <write>
 633:	83 c4 10             	add    $0x10,%esp
}
 636:	90                   	nop
 637:	c9                   	leave  
 638:	c3                   	ret    

00000639 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 639:	55                   	push   %ebp
 63a:	89 e5                	mov    %esp,%ebp
 63c:	53                   	push   %ebx
 63d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 640:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 647:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 64b:	74 17                	je     664 <printint+0x2b>
 64d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 651:	79 11                	jns    664 <printint+0x2b>
    neg = 1;
 653:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 65a:	8b 45 0c             	mov    0xc(%ebp),%eax
 65d:	f7 d8                	neg    %eax
 65f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 662:	eb 06                	jmp    66a <printint+0x31>
  } else {
    x = xx;
 664:	8b 45 0c             	mov    0xc(%ebp),%eax
 667:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 66a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 671:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 674:	8d 41 01             	lea    0x1(%ecx),%eax
 677:	89 45 f4             	mov    %eax,-0xc(%ebp)
 67a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 67d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 680:	ba 00 00 00 00       	mov    $0x0,%edx
 685:	f7 f3                	div    %ebx
 687:	89 d0                	mov    %edx,%eax
 689:	0f b6 80 30 0d 00 00 	movzbl 0xd30(%eax),%eax
 690:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 694:	8b 5d 10             	mov    0x10(%ebp),%ebx
 697:	8b 45 ec             	mov    -0x14(%ebp),%eax
 69a:	ba 00 00 00 00       	mov    $0x0,%edx
 69f:	f7 f3                	div    %ebx
 6a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6a8:	75 c7                	jne    671 <printint+0x38>
  if(neg)
 6aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ae:	74 2d                	je     6dd <printint+0xa4>
    buf[i++] = '-';
 6b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b3:	8d 50 01             	lea    0x1(%eax),%edx
 6b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6b9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6be:	eb 1d                	jmp    6dd <printint+0xa4>
    putc(fd, buf[i]);
 6c0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	0f be c0             	movsbl %al,%eax
 6ce:	83 ec 08             	sub    $0x8,%esp
 6d1:	50                   	push   %eax
 6d2:	ff 75 08             	pushl  0x8(%ebp)
 6d5:	e8 3c ff ff ff       	call   616 <putc>
 6da:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e5:	79 d9                	jns    6c0 <printint+0x87>
    putc(fd, buf[i]);
}
 6e7:	90                   	nop
 6e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6eb:	c9                   	leave  
 6ec:	c3                   	ret    

000006ed <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6ed:	55                   	push   %ebp
 6ee:	89 e5                	mov    %esp,%ebp
 6f0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6fa:	8d 45 0c             	lea    0xc(%ebp),%eax
 6fd:	83 c0 04             	add    $0x4,%eax
 700:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 703:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 70a:	e9 59 01 00 00       	jmp    868 <printf+0x17b>
    c = fmt[i] & 0xff;
 70f:	8b 55 0c             	mov    0xc(%ebp),%edx
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	01 d0                	add    %edx,%eax
 717:	0f b6 00             	movzbl (%eax),%eax
 71a:	0f be c0             	movsbl %al,%eax
 71d:	25 ff 00 00 00       	and    $0xff,%eax
 722:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 725:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 729:	75 2c                	jne    757 <printf+0x6a>
      if(c == '%'){
 72b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 72f:	75 0c                	jne    73d <printf+0x50>
        state = '%';
 731:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 738:	e9 27 01 00 00       	jmp    864 <printf+0x177>
      } else {
        putc(fd, c);
 73d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	83 ec 08             	sub    $0x8,%esp
 746:	50                   	push   %eax
 747:	ff 75 08             	pushl  0x8(%ebp)
 74a:	e8 c7 fe ff ff       	call   616 <putc>
 74f:	83 c4 10             	add    $0x10,%esp
 752:	e9 0d 01 00 00       	jmp    864 <printf+0x177>
      }
    } else if(state == '%'){
 757:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 75b:	0f 85 03 01 00 00    	jne    864 <printf+0x177>
      if(c == 'd'){
 761:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 765:	75 1e                	jne    785 <printf+0x98>
        printint(fd, *ap, 10, 1);
 767:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	6a 01                	push   $0x1
 76e:	6a 0a                	push   $0xa
 770:	50                   	push   %eax
 771:	ff 75 08             	pushl  0x8(%ebp)
 774:	e8 c0 fe ff ff       	call   639 <printint>
 779:	83 c4 10             	add    $0x10,%esp
        ap++;
 77c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 780:	e9 d8 00 00 00       	jmp    85d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 785:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 789:	74 06                	je     791 <printf+0xa4>
 78b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 78f:	75 1e                	jne    7af <printf+0xc2>
        printint(fd, *ap, 16, 0);
 791:	8b 45 e8             	mov    -0x18(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	6a 00                	push   $0x0
 798:	6a 10                	push   $0x10
 79a:	50                   	push   %eax
 79b:	ff 75 08             	pushl  0x8(%ebp)
 79e:	e8 96 fe ff ff       	call   639 <printint>
 7a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7aa:	e9 ae 00 00 00       	jmp    85d <printf+0x170>
      } else if(c == 's'){
 7af:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7b3:	75 43                	jne    7f8 <printf+0x10b>
        s = (char*)*ap;
 7b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c5:	75 25                	jne    7ec <printf+0xff>
          s = "(null)";
 7c7:	c7 45 f4 bc 0a 00 00 	movl   $0xabc,-0xc(%ebp)
        while(*s != 0){
 7ce:	eb 1c                	jmp    7ec <printf+0xff>
          putc(fd, *s);
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	0f b6 00             	movzbl (%eax),%eax
 7d6:	0f be c0             	movsbl %al,%eax
 7d9:	83 ec 08             	sub    $0x8,%esp
 7dc:	50                   	push   %eax
 7dd:	ff 75 08             	pushl  0x8(%ebp)
 7e0:	e8 31 fe ff ff       	call   616 <putc>
 7e5:	83 c4 10             	add    $0x10,%esp
          s++;
 7e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	0f b6 00             	movzbl (%eax),%eax
 7f2:	84 c0                	test   %al,%al
 7f4:	75 da                	jne    7d0 <printf+0xe3>
 7f6:	eb 65                	jmp    85d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7f8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7fc:	75 1d                	jne    81b <printf+0x12e>
        putc(fd, *ap);
 7fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	0f be c0             	movsbl %al,%eax
 806:	83 ec 08             	sub    $0x8,%esp
 809:	50                   	push   %eax
 80a:	ff 75 08             	pushl  0x8(%ebp)
 80d:	e8 04 fe ff ff       	call   616 <putc>
 812:	83 c4 10             	add    $0x10,%esp
        ap++;
 815:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 819:	eb 42                	jmp    85d <printf+0x170>
      } else if(c == '%'){
 81b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 81f:	75 17                	jne    838 <printf+0x14b>
        putc(fd, c);
 821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 824:	0f be c0             	movsbl %al,%eax
 827:	83 ec 08             	sub    $0x8,%esp
 82a:	50                   	push   %eax
 82b:	ff 75 08             	pushl  0x8(%ebp)
 82e:	e8 e3 fd ff ff       	call   616 <putc>
 833:	83 c4 10             	add    $0x10,%esp
 836:	eb 25                	jmp    85d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 838:	83 ec 08             	sub    $0x8,%esp
 83b:	6a 25                	push   $0x25
 83d:	ff 75 08             	pushl  0x8(%ebp)
 840:	e8 d1 fd ff ff       	call   616 <putc>
 845:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 84b:	0f be c0             	movsbl %al,%eax
 84e:	83 ec 08             	sub    $0x8,%esp
 851:	50                   	push   %eax
 852:	ff 75 08             	pushl  0x8(%ebp)
 855:	e8 bc fd ff ff       	call   616 <putc>
 85a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 85d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 864:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 868:	8b 55 0c             	mov    0xc(%ebp),%edx
 86b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86e:	01 d0                	add    %edx,%eax
 870:	0f b6 00             	movzbl (%eax),%eax
 873:	84 c0                	test   %al,%al
 875:	0f 85 94 fe ff ff    	jne    70f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 87b:	90                   	nop
 87c:	c9                   	leave  
 87d:	c3                   	ret    

0000087e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87e:	55                   	push   %ebp
 87f:	89 e5                	mov    %esp,%ebp
 881:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 884:	8b 45 08             	mov    0x8(%ebp),%eax
 887:	83 e8 08             	sub    $0x8,%eax
 88a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88d:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 892:	89 45 fc             	mov    %eax,-0x4(%ebp)
 895:	eb 24                	jmp    8bb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 897:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 89f:	77 12                	ja     8b3 <free+0x35>
 8a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8a7:	77 24                	ja     8cd <free+0x4f>
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b1:	77 1a                	ja     8cd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c1:	76 d4                	jbe    897 <free+0x19>
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	8b 00                	mov    (%eax),%eax
 8c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8cb:	76 ca                	jbe    897 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dd:	01 c2                	add    %eax,%edx
 8df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	39 c2                	cmp    %eax,%edx
 8e6:	75 24                	jne    90c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8eb:	8b 50 04             	mov    0x4(%eax),%edx
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	8b 40 04             	mov    0x4(%eax),%eax
 8f6:	01 c2                	add    %eax,%edx
 8f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	8b 00                	mov    (%eax),%eax
 903:	8b 10                	mov    (%eax),%edx
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	89 10                	mov    %edx,(%eax)
 90a:	eb 0a                	jmp    916 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 10                	mov    (%eax),%edx
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 916:	8b 45 fc             	mov    -0x4(%ebp),%eax
 919:	8b 40 04             	mov    0x4(%eax),%eax
 91c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 923:	8b 45 fc             	mov    -0x4(%ebp),%eax
 926:	01 d0                	add    %edx,%eax
 928:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 92b:	75 20                	jne    94d <free+0xcf>
    p->s.size += bp->s.size;
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	8b 50 04             	mov    0x4(%eax),%edx
 933:	8b 45 f8             	mov    -0x8(%ebp),%eax
 936:	8b 40 04             	mov    0x4(%eax),%eax
 939:	01 c2                	add    %eax,%edx
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 941:	8b 45 f8             	mov    -0x8(%ebp),%eax
 944:	8b 10                	mov    (%eax),%edx
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	89 10                	mov    %edx,(%eax)
 94b:	eb 08                	jmp    955 <free+0xd7>
  } else
    p->s.ptr = bp;
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 55 f8             	mov    -0x8(%ebp),%edx
 953:	89 10                	mov    %edx,(%eax)
  freep = p;
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	a3 4c 0d 00 00       	mov    %eax,0xd4c
}
 95d:	90                   	nop
 95e:	c9                   	leave  
 95f:	c3                   	ret    

00000960 <morecore>:

static Header*
morecore(uint nu)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 966:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 96d:	77 07                	ja     976 <morecore+0x16>
    nu = 4096;
 96f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 976:	8b 45 08             	mov    0x8(%ebp),%eax
 979:	c1 e0 03             	shl    $0x3,%eax
 97c:	83 ec 0c             	sub    $0xc,%esp
 97f:	50                   	push   %eax
 980:	e8 39 fc ff ff       	call   5be <sbrk>
 985:	83 c4 10             	add    $0x10,%esp
 988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 98b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 98f:	75 07                	jne    998 <morecore+0x38>
    return 0;
 991:	b8 00 00 00 00       	mov    $0x0,%eax
 996:	eb 26                	jmp    9be <morecore+0x5e>
  hp = (Header*)p;
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 99e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a1:	8b 55 08             	mov    0x8(%ebp),%edx
 9a4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9aa:	83 c0 08             	add    $0x8,%eax
 9ad:	83 ec 0c             	sub    $0xc,%esp
 9b0:	50                   	push   %eax
 9b1:	e8 c8 fe ff ff       	call   87e <free>
 9b6:	83 c4 10             	add    $0x10,%esp
  return freep;
 9b9:	a1 4c 0d 00 00       	mov    0xd4c,%eax
}
 9be:	c9                   	leave  
 9bf:	c3                   	ret    

000009c0 <malloc>:

void*
malloc(uint nbytes)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c6:	8b 45 08             	mov    0x8(%ebp),%eax
 9c9:	83 c0 07             	add    $0x7,%eax
 9cc:	c1 e8 03             	shr    $0x3,%eax
 9cf:	83 c0 01             	add    $0x1,%eax
 9d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9d5:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 9da:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9e1:	75 23                	jne    a06 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9e3:	c7 45 f0 44 0d 00 00 	movl   $0xd44,-0x10(%ebp)
 9ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ed:	a3 4c 0d 00 00       	mov    %eax,0xd4c
 9f2:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 9f7:	a3 44 0d 00 00       	mov    %eax,0xd44
    base.s.size = 0;
 9fc:	c7 05 48 0d 00 00 00 	movl   $0x0,0xd48
 a03:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a09:	8b 00                	mov    (%eax),%eax
 a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a11:	8b 40 04             	mov    0x4(%eax),%eax
 a14:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a17:	72 4d                	jb     a66 <malloc+0xa6>
      if(p->s.size == nunits)
 a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1c:	8b 40 04             	mov    0x4(%eax),%eax
 a1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a22:	75 0c                	jne    a30 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a27:	8b 10                	mov    (%eax),%edx
 a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2c:	89 10                	mov    %edx,(%eax)
 a2e:	eb 26                	jmp    a56 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a33:	8b 40 04             	mov    0x4(%eax),%eax
 a36:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a39:	89 c2                	mov    %eax,%edx
 a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a44:	8b 40 04             	mov    0x4(%eax),%eax
 a47:	c1 e0 03             	shl    $0x3,%eax
 a4a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a53:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a59:	a3 4c 0d 00 00       	mov    %eax,0xd4c
      return (void*)(p + 1);
 a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a61:	83 c0 08             	add    $0x8,%eax
 a64:	eb 3b                	jmp    aa1 <malloc+0xe1>
    }
    if(p == freep)
 a66:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 a6b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a6e:	75 1e                	jne    a8e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a70:	83 ec 0c             	sub    $0xc,%esp
 a73:	ff 75 ec             	pushl  -0x14(%ebp)
 a76:	e8 e5 fe ff ff       	call   960 <morecore>
 a7b:	83 c4 10             	add    $0x10,%esp
 a7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a85:	75 07                	jne    a8e <malloc+0xce>
        return 0;
 a87:	b8 00 00 00 00       	mov    $0x0,%eax
 a8c:	eb 13                	jmp    aa1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a97:	8b 00                	mov    (%eax),%eax
 a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a9c:	e9 6d ff ff ff       	jmp    a0e <malloc+0x4e>
}
 aa1:	c9                   	leave  
 aa2:	c3                   	ret    
