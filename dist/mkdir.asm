
_mkdir:     file format elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: mkdir files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 ce 0a 00 00       	push   $0xace
  21:	6a 02                	push   $0x2
  23:	e8 f0 06 00 00       	call   718 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 31 05 00 00       	call   561 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(mkdir(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 76 05 00 00       	call   5c9 <mkdir>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 e5 0a 00 00       	push   $0xae5
  74:	6a 02                	push   $0x2
  76:	e8 9d 06 00 00       	call   718 <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8b:	e8 d1 04 00 00       	call   561 <exit>

00000090 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b7 00             	movzwl (%eax),%eax
  9c:	98                   	cwtl   
  9d:	83 f8 02             	cmp    $0x2,%eax
  a0:	74 1e                	je     c0 <print_mode+0x30>
  a2:	83 f8 03             	cmp    $0x3,%eax
  a5:	74 2d                	je     d4 <print_mode+0x44>
  a7:	83 f8 01             	cmp    $0x1,%eax
  aa:	75 3c                	jne    e8 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 01 0b 00 00       	push   $0xb01
  b4:	6a 01                	push   $0x1
  b6:	e8 5d 06 00 00       	call   718 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 3a                	jmp    fa <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 03 0b 00 00       	push   $0xb03
  c8:	6a 01                	push   $0x1
  ca:	e8 49 06 00 00       	call   718 <printf>
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	eb 26                	jmp    fa <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 05 0b 00 00       	push   $0xb05
  dc:	6a 01                	push   $0x1
  de:	e8 35 06 00 00       	call   718 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	eb 12                	jmp    fa <print_mode+0x6a>
    default: printf(1, "?");
  e8:	83 ec 08             	sub    $0x8,%esp
  eb:	68 07 0b 00 00       	push   $0xb07
  f0:	6a 01                	push   $0x1
  f2:	e8 21 06 00 00       	call   718 <printf>
  f7:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 101:	83 e0 01             	and    $0x1,%eax
 104:	84 c0                	test   %al,%al
 106:	74 14                	je     11c <print_mode+0x8c>
    printf(1, "r");
 108:	83 ec 08             	sub    $0x8,%esp
 10b:	68 09 0b 00 00       	push   $0xb09
 110:	6a 01                	push   $0x1
 112:	e8 01 06 00 00       	call   718 <printf>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	eb 12                	jmp    12e <print_mode+0x9e>
  else
    printf(1, "-");
 11c:	83 ec 08             	sub    $0x8,%esp
 11f:	68 03 0b 00 00       	push   $0xb03
 124:	6a 01                	push   $0x1
 126:	e8 ed 05 00 00       	call   718 <printf>
 12b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 135:	83 e0 80             	and    $0xffffff80,%eax
 138:	84 c0                	test   %al,%al
 13a:	74 14                	je     150 <print_mode+0xc0>
    printf(1, "w");
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	68 0b 0b 00 00       	push   $0xb0b
 144:	6a 01                	push   $0x1
 146:	e8 cd 05 00 00       	call   718 <printf>
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	eb 12                	jmp    162 <print_mode+0xd2>
  else
    printf(1, "-");
 150:	83 ec 08             	sub    $0x8,%esp
 153:	68 03 0b 00 00       	push   $0xb03
 158:	6a 01                	push   $0x1
 15a:	e8 b9 05 00 00       	call   718 <printf>
 15f:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 169:	c0 e8 06             	shr    $0x6,%al
 16c:	83 e0 01             	and    $0x1,%eax
 16f:	0f b6 d0             	movzbl %al,%edx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 179:	d0 e8                	shr    %al
 17b:	83 e0 01             	and    $0x1,%eax
 17e:	0f b6 c0             	movzbl %al,%eax
 181:	21 d0                	and    %edx,%eax
 183:	85 c0                	test   %eax,%eax
 185:	74 14                	je     19b <print_mode+0x10b>
    printf(1, "S");
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	68 0d 0b 00 00       	push   $0xb0d
 18f:	6a 01                	push   $0x1
 191:	e8 82 05 00 00       	call   718 <printf>
 196:	83 c4 10             	add    $0x10,%esp
 199:	eb 34                	jmp    1cf <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1a2:	83 e0 40             	and    $0x40,%eax
 1a5:	84 c0                	test   %al,%al
 1a7:	74 14                	je     1bd <print_mode+0x12d>
    printf(1, "x");
 1a9:	83 ec 08             	sub    $0x8,%esp
 1ac:	68 0f 0b 00 00       	push   $0xb0f
 1b1:	6a 01                	push   $0x1
 1b3:	e8 60 05 00 00       	call   718 <printf>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	eb 12                	jmp    1cf <print_mode+0x13f>
  else
    printf(1, "-");
 1bd:	83 ec 08             	sub    $0x8,%esp
 1c0:	68 03 0b 00 00       	push   $0xb03
 1c5:	6a 01                	push   $0x1
 1c7:	e8 4c 05 00 00       	call   718 <printf>
 1cc:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1d6:	83 e0 20             	and    $0x20,%eax
 1d9:	84 c0                	test   %al,%al
 1db:	74 14                	je     1f1 <print_mode+0x161>
    printf(1, "r");
 1dd:	83 ec 08             	sub    $0x8,%esp
 1e0:	68 09 0b 00 00       	push   $0xb09
 1e5:	6a 01                	push   $0x1
 1e7:	e8 2c 05 00 00       	call   718 <printf>
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	eb 12                	jmp    203 <print_mode+0x173>
  else
    printf(1, "-");
 1f1:	83 ec 08             	sub    $0x8,%esp
 1f4:	68 03 0b 00 00       	push   $0xb03
 1f9:	6a 01                	push   $0x1
 1fb:	e8 18 05 00 00       	call   718 <printf>
 200:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 20a:	83 e0 10             	and    $0x10,%eax
 20d:	84 c0                	test   %al,%al
 20f:	74 14                	je     225 <print_mode+0x195>
    printf(1, "w");
 211:	83 ec 08             	sub    $0x8,%esp
 214:	68 0b 0b 00 00       	push   $0xb0b
 219:	6a 01                	push   $0x1
 21b:	e8 f8 04 00 00       	call   718 <printf>
 220:	83 c4 10             	add    $0x10,%esp
 223:	eb 12                	jmp    237 <print_mode+0x1a7>
  else
    printf(1, "-");
 225:	83 ec 08             	sub    $0x8,%esp
 228:	68 03 0b 00 00       	push   $0xb03
 22d:	6a 01                	push   $0x1
 22f:	e8 e4 04 00 00       	call   718 <printf>
 234:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 23e:	83 e0 08             	and    $0x8,%eax
 241:	84 c0                	test   %al,%al
 243:	74 14                	je     259 <print_mode+0x1c9>
    printf(1, "x");
 245:	83 ec 08             	sub    $0x8,%esp
 248:	68 0f 0b 00 00       	push   $0xb0f
 24d:	6a 01                	push   $0x1
 24f:	e8 c4 04 00 00       	call   718 <printf>
 254:	83 c4 10             	add    $0x10,%esp
 257:	eb 12                	jmp    26b <print_mode+0x1db>
  else
    printf(1, "-");
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	68 03 0b 00 00       	push   $0xb03
 261:	6a 01                	push   $0x1
 263:	e8 b0 04 00 00       	call   718 <printf>
 268:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 272:	83 e0 04             	and    $0x4,%eax
 275:	84 c0                	test   %al,%al
 277:	74 14                	je     28d <print_mode+0x1fd>
    printf(1, "r");
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	68 09 0b 00 00       	push   $0xb09
 281:	6a 01                	push   $0x1
 283:	e8 90 04 00 00       	call   718 <printf>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	eb 12                	jmp    29f <print_mode+0x20f>
  else
    printf(1, "-");
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	68 03 0b 00 00       	push   $0xb03
 295:	6a 01                	push   $0x1
 297:	e8 7c 04 00 00       	call   718 <printf>
 29c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2a6:	83 e0 02             	and    $0x2,%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 14                	je     2c1 <print_mode+0x231>
    printf(1, "w");
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	68 0b 0b 00 00       	push   $0xb0b
 2b5:	6a 01                	push   $0x1
 2b7:	e8 5c 04 00 00       	call   718 <printf>
 2bc:	83 c4 10             	add    $0x10,%esp
 2bf:	eb 12                	jmp    2d3 <print_mode+0x243>
  else
    printf(1, "-");
 2c1:	83 ec 08             	sub    $0x8,%esp
 2c4:	68 03 0b 00 00       	push   $0xb03
 2c9:	6a 01                	push   $0x1
 2cb:	e8 48 04 00 00       	call   718 <printf>
 2d0:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2da:	83 e0 01             	and    $0x1,%eax
 2dd:	84 c0                	test   %al,%al
 2df:	74 14                	je     2f5 <print_mode+0x265>
    printf(1, "x");
 2e1:	83 ec 08             	sub    $0x8,%esp
 2e4:	68 0f 0b 00 00       	push   $0xb0f
 2e9:	6a 01                	push   $0x1
 2eb:	e8 28 04 00 00       	call   718 <printf>
 2f0:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 2f3:	eb 13                	jmp    308 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	68 03 0b 00 00       	push   $0xb03
 2fd:	6a 01                	push   $0x1
 2ff:	e8 14 04 00 00       	call   718 <printf>
 304:	83 c4 10             	add    $0x10,%esp

  return;
 307:	90                   	nop
}
 308:	c9                   	leave  
 309:	c3                   	ret    

0000030a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	57                   	push   %edi
 30e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 30f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 312:	8b 55 10             	mov    0x10(%ebp),%edx
 315:	8b 45 0c             	mov    0xc(%ebp),%eax
 318:	89 cb                	mov    %ecx,%ebx
 31a:	89 df                	mov    %ebx,%edi
 31c:	89 d1                	mov    %edx,%ecx
 31e:	fc                   	cld    
 31f:	f3 aa                	rep stos %al,%es:(%edi)
 321:	89 ca                	mov    %ecx,%edx
 323:	89 fb                	mov    %edi,%ebx
 325:	89 5d 08             	mov    %ebx,0x8(%ebp)
 328:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 32b:	90                   	nop
 32c:	5b                   	pop    %ebx
 32d:	5f                   	pop    %edi
 32e:	5d                   	pop    %ebp
 32f:	c3                   	ret    

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 33c:	90                   	nop
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	8d 50 01             	lea    0x1(%eax),%edx
 343:	89 55 08             	mov    %edx,0x8(%ebp)
 346:	8b 55 0c             	mov    0xc(%ebp),%edx
 349:	8d 4a 01             	lea    0x1(%edx),%ecx
 34c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 34f:	0f b6 12             	movzbl (%edx),%edx
 352:	88 10                	mov    %dl,(%eax)
 354:	0f b6 00             	movzbl (%eax),%eax
 357:	84 c0                	test   %al,%al
 359:	75 e2                	jne    33d <strcpy+0xd>
    ;
  return os;
 35b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 363:	eb 08                	jmp    36d <strcmp+0xd>
    p++, q++;
 365:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 369:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	0f b6 00             	movzbl (%eax),%eax
 373:	84 c0                	test   %al,%al
 375:	74 10                	je     387 <strcmp+0x27>
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	0f b6 10             	movzbl (%eax),%edx
 37d:	8b 45 0c             	mov    0xc(%ebp),%eax
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	38 c2                	cmp    %al,%dl
 385:	74 de                	je     365 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	0f b6 00             	movzbl (%eax),%eax
 38d:	0f b6 d0             	movzbl %al,%edx
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	0f b6 c0             	movzbl %al,%eax
 399:	29 c2                	sub    %eax,%edx
 39b:	89 d0                	mov    %edx,%eax
}
 39d:	5d                   	pop    %ebp
 39e:	c3                   	ret    

0000039f <strlen>:

uint
strlen(char *s)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ac:	eb 04                	jmp    3b2 <strlen+0x13>
 3ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	01 d0                	add    %edx,%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	84 c0                	test   %al,%al
 3bf:	75 ed                	jne    3ae <strlen+0xf>
    ;
  return n;
 3c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3c9:	8b 45 10             	mov    0x10(%ebp),%eax
 3cc:	50                   	push   %eax
 3cd:	ff 75 0c             	pushl  0xc(%ebp)
 3d0:	ff 75 08             	pushl  0x8(%ebp)
 3d3:	e8 32 ff ff ff       	call   30a <stosb>
 3d8:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3de:	c9                   	leave  
 3df:	c3                   	ret    

000003e0 <strchr>:

char*
strchr(const char *s, char c)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	83 ec 04             	sub    $0x4,%esp
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3ec:	eb 14                	jmp    402 <strchr+0x22>
    if(*s == c)
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3f7:	75 05                	jne    3fe <strchr+0x1e>
      return (char*)s;
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	eb 13                	jmp    411 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	0f b6 00             	movzbl (%eax),%eax
 408:	84 c0                	test   %al,%al
 40a:	75 e2                	jne    3ee <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 40c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <gets>:

char*
gets(char *buf, int max)
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 420:	eb 42                	jmp    464 <gets+0x51>
    cc = read(0, &c, 1);
 422:	83 ec 04             	sub    $0x4,%esp
 425:	6a 01                	push   $0x1
 427:	8d 45 ef             	lea    -0x11(%ebp),%eax
 42a:	50                   	push   %eax
 42b:	6a 00                	push   $0x0
 42d:	e8 47 01 00 00       	call   579 <read>
 432:	83 c4 10             	add    $0x10,%esp
 435:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 438:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43c:	7e 33                	jle    471 <gets+0x5e>
      break;
    buf[i++] = c;
 43e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 441:	8d 50 01             	lea    0x1(%eax),%edx
 444:	89 55 f4             	mov    %edx,-0xc(%ebp)
 447:	89 c2                	mov    %eax,%edx
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	01 c2                	add    %eax,%edx
 44e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 452:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 454:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 458:	3c 0a                	cmp    $0xa,%al
 45a:	74 16                	je     472 <gets+0x5f>
 45c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 460:	3c 0d                	cmp    $0xd,%al
 462:	74 0e                	je     472 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 464:	8b 45 f4             	mov    -0xc(%ebp),%eax
 467:	83 c0 01             	add    $0x1,%eax
 46a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 46d:	7c b3                	jl     422 <gets+0xf>
 46f:	eb 01                	jmp    472 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 471:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 472:	8b 55 f4             	mov    -0xc(%ebp),%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 d0                	add    %edx,%eax
 47a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 480:	c9                   	leave  
 481:	c3                   	ret    

00000482 <stat>:

int
stat(char *n, struct stat *st)
{
 482:	55                   	push   %ebp
 483:	89 e5                	mov    %esp,%ebp
 485:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 488:	83 ec 08             	sub    $0x8,%esp
 48b:	6a 00                	push   $0x0
 48d:	ff 75 08             	pushl  0x8(%ebp)
 490:	e8 0c 01 00 00       	call   5a1 <open>
 495:	83 c4 10             	add    $0x10,%esp
 498:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 49b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49f:	79 07                	jns    4a8 <stat+0x26>
    return -1;
 4a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4a6:	eb 25                	jmp    4cd <stat+0x4b>
  r = fstat(fd, st);
 4a8:	83 ec 08             	sub    $0x8,%esp
 4ab:	ff 75 0c             	pushl  0xc(%ebp)
 4ae:	ff 75 f4             	pushl  -0xc(%ebp)
 4b1:	e8 03 01 00 00       	call   5b9 <fstat>
 4b6:	83 c4 10             	add    $0x10,%esp
 4b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4bc:	83 ec 0c             	sub    $0xc,%esp
 4bf:	ff 75 f4             	pushl  -0xc(%ebp)
 4c2:	e8 c2 00 00 00       	call   589 <close>
 4c7:	83 c4 10             	add    $0x10,%esp
  return r;
 4ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4cd:	c9                   	leave  
 4ce:	c3                   	ret    

000004cf <atoi>:

int
atoi(const char *s)
{
 4cf:	55                   	push   %ebp
 4d0:	89 e5                	mov    %esp,%ebp
 4d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4dc:	eb 25                	jmp    503 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4e1:	89 d0                	mov    %edx,%eax
 4e3:	c1 e0 02             	shl    $0x2,%eax
 4e6:	01 d0                	add    %edx,%eax
 4e8:	01 c0                	add    %eax,%eax
 4ea:	89 c1                	mov    %eax,%ecx
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
 4ef:	8d 50 01             	lea    0x1(%eax),%edx
 4f2:	89 55 08             	mov    %edx,0x8(%ebp)
 4f5:	0f b6 00             	movzbl (%eax),%eax
 4f8:	0f be c0             	movsbl %al,%eax
 4fb:	01 c8                	add    %ecx,%eax
 4fd:	83 e8 30             	sub    $0x30,%eax
 500:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	0f b6 00             	movzbl (%eax),%eax
 509:	3c 2f                	cmp    $0x2f,%al
 50b:	7e 0a                	jle    517 <atoi+0x48>
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	0f b6 00             	movzbl (%eax),%eax
 513:	3c 39                	cmp    $0x39,%al
 515:	7e c7                	jle    4de <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 517:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 51a:	c9                   	leave  
 51b:	c3                   	ret    

0000051c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 51c:	55                   	push   %ebp
 51d:	89 e5                	mov    %esp,%ebp
 51f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 528:	8b 45 0c             	mov    0xc(%ebp),%eax
 52b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 52e:	eb 17                	jmp    547 <memmove+0x2b>
    *dst++ = *src++;
 530:	8b 45 fc             	mov    -0x4(%ebp),%eax
 533:	8d 50 01             	lea    0x1(%eax),%edx
 536:	89 55 fc             	mov    %edx,-0x4(%ebp)
 539:	8b 55 f8             	mov    -0x8(%ebp),%edx
 53c:	8d 4a 01             	lea    0x1(%edx),%ecx
 53f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 542:	0f b6 12             	movzbl (%edx),%edx
 545:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 547:	8b 45 10             	mov    0x10(%ebp),%eax
 54a:	8d 50 ff             	lea    -0x1(%eax),%edx
 54d:	89 55 10             	mov    %edx,0x10(%ebp)
 550:	85 c0                	test   %eax,%eax
 552:	7f dc                	jg     530 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 554:	8b 45 08             	mov    0x8(%ebp),%eax
}
 557:	c9                   	leave  
 558:	c3                   	ret    

00000559 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 559:	b8 01 00 00 00       	mov    $0x1,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <exit>:
SYSCALL(exit)
 561:	b8 02 00 00 00       	mov    $0x2,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <wait>:
SYSCALL(wait)
 569:	b8 03 00 00 00       	mov    $0x3,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <pipe>:
SYSCALL(pipe)
 571:	b8 04 00 00 00       	mov    $0x4,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <read>:
SYSCALL(read)
 579:	b8 05 00 00 00       	mov    $0x5,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <write>:
SYSCALL(write)
 581:	b8 10 00 00 00       	mov    $0x10,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <close>:
SYSCALL(close)
 589:	b8 15 00 00 00       	mov    $0x15,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <kill>:
SYSCALL(kill)
 591:	b8 06 00 00 00       	mov    $0x6,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <exec>:
SYSCALL(exec)
 599:	b8 07 00 00 00       	mov    $0x7,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <open>:
SYSCALL(open)
 5a1:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <mknod>:
SYSCALL(mknod)
 5a9:	b8 11 00 00 00       	mov    $0x11,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <unlink>:
SYSCALL(unlink)
 5b1:	b8 12 00 00 00       	mov    $0x12,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <fstat>:
SYSCALL(fstat)
 5b9:	b8 08 00 00 00       	mov    $0x8,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <link>:
SYSCALL(link)
 5c1:	b8 13 00 00 00       	mov    $0x13,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <mkdir>:
SYSCALL(mkdir)
 5c9:	b8 14 00 00 00       	mov    $0x14,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <chdir>:
SYSCALL(chdir)
 5d1:	b8 09 00 00 00       	mov    $0x9,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <dup>:
SYSCALL(dup)
 5d9:	b8 0a 00 00 00       	mov    $0xa,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <getpid>:
SYSCALL(getpid)
 5e1:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <sbrk>:
SYSCALL(sbrk)
 5e9:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <sleep>:
SYSCALL(sleep)
 5f1:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <uptime>:
SYSCALL(uptime)
 5f9:	b8 0e 00 00 00       	mov    $0xe,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <halt>:
SYSCALL(halt)
 601:	b8 16 00 00 00       	mov    $0x16,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <date>:
//Student Implementations 
SYSCALL(date)
 609:	b8 17 00 00 00       	mov    $0x17,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <getuid>:

SYSCALL(getuid)
 611:	b8 18 00 00 00       	mov    $0x18,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <getgid>:
SYSCALL(getgid)
 619:	b8 19 00 00 00       	mov    $0x19,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <getppid>:
SYSCALL(getppid)
 621:	b8 1a 00 00 00       	mov    $0x1a,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <setuid>:

SYSCALL(setuid)
 629:	b8 1b 00 00 00       	mov    $0x1b,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <setgid>:
SYSCALL(setgid)
 631:	b8 1c 00 00 00       	mov    $0x1c,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <getprocs>:
SYSCALL(getprocs)
 639:	b8 1d 00 00 00       	mov    $0x1d,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 641:	55                   	push   %ebp
 642:	89 e5                	mov    %esp,%ebp
 644:	83 ec 18             	sub    $0x18,%esp
 647:	8b 45 0c             	mov    0xc(%ebp),%eax
 64a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64d:	83 ec 04             	sub    $0x4,%esp
 650:	6a 01                	push   $0x1
 652:	8d 45 f4             	lea    -0xc(%ebp),%eax
 655:	50                   	push   %eax
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 23 ff ff ff       	call   581 <write>
 65e:	83 c4 10             	add    $0x10,%esp
}
 661:	90                   	nop
 662:	c9                   	leave  
 663:	c3                   	ret    

00000664 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	53                   	push   %ebx
 668:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 672:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 676:	74 17                	je     68f <printint+0x2b>
 678:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 67c:	79 11                	jns    68f <printint+0x2b>
    neg = 1;
 67e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 685:	8b 45 0c             	mov    0xc(%ebp),%eax
 688:	f7 d8                	neg    %eax
 68a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68d:	eb 06                	jmp    695 <printint+0x31>
  } else {
    x = xx;
 68f:	8b 45 0c             	mov    0xc(%ebp),%eax
 692:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 695:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 69c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 69f:	8d 41 01             	lea    0x1(%ecx),%eax
 6a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ab:	ba 00 00 00 00       	mov    $0x0,%edx
 6b0:	f7 f3                	div    %ebx
 6b2:	89 d0                	mov    %edx,%eax
 6b4:	0f b6 80 84 0d 00 00 	movzbl 0xd84(%eax),%eax
 6bb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c5:	ba 00 00 00 00       	mov    $0x0,%edx
 6ca:	f7 f3                	div    %ebx
 6cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d3:	75 c7                	jne    69c <printint+0x38>
  if(neg)
 6d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d9:	74 2d                	je     708 <printint+0xa4>
    buf[i++] = '-';
 6db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6de:	8d 50 01             	lea    0x1(%eax),%edx
 6e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6e9:	eb 1d                	jmp    708 <printint+0xa4>
    putc(fd, buf[i]);
 6eb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f1:	01 d0                	add    %edx,%eax
 6f3:	0f b6 00             	movzbl (%eax),%eax
 6f6:	0f be c0             	movsbl %al,%eax
 6f9:	83 ec 08             	sub    $0x8,%esp
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	pushl  0x8(%ebp)
 700:	e8 3c ff ff ff       	call   641 <putc>
 705:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 708:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 70c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 710:	79 d9                	jns    6eb <printint+0x87>
    putc(fd, buf[i]);
}
 712:	90                   	nop
 713:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 716:	c9                   	leave  
 717:	c3                   	ret    

00000718 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 718:	55                   	push   %ebp
 719:	89 e5                	mov    %esp,%ebp
 71b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 71e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 725:	8d 45 0c             	lea    0xc(%ebp),%eax
 728:	83 c0 04             	add    $0x4,%eax
 72b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 72e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 735:	e9 59 01 00 00       	jmp    893 <printf+0x17b>
    c = fmt[i] & 0xff;
 73a:	8b 55 0c             	mov    0xc(%ebp),%edx
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	01 d0                	add    %edx,%eax
 742:	0f b6 00             	movzbl (%eax),%eax
 745:	0f be c0             	movsbl %al,%eax
 748:	25 ff 00 00 00       	and    $0xff,%eax
 74d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 750:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 754:	75 2c                	jne    782 <printf+0x6a>
      if(c == '%'){
 756:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75a:	75 0c                	jne    768 <printf+0x50>
        state = '%';
 75c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 763:	e9 27 01 00 00       	jmp    88f <printf+0x177>
      } else {
        putc(fd, c);
 768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76b:	0f be c0             	movsbl %al,%eax
 76e:	83 ec 08             	sub    $0x8,%esp
 771:	50                   	push   %eax
 772:	ff 75 08             	pushl  0x8(%ebp)
 775:	e8 c7 fe ff ff       	call   641 <putc>
 77a:	83 c4 10             	add    $0x10,%esp
 77d:	e9 0d 01 00 00       	jmp    88f <printf+0x177>
      }
    } else if(state == '%'){
 782:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 786:	0f 85 03 01 00 00    	jne    88f <printf+0x177>
      if(c == 'd'){
 78c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 790:	75 1e                	jne    7b0 <printf+0x98>
        printint(fd, *ap, 10, 1);
 792:	8b 45 e8             	mov    -0x18(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	6a 01                	push   $0x1
 799:	6a 0a                	push   $0xa
 79b:	50                   	push   %eax
 79c:	ff 75 08             	pushl  0x8(%ebp)
 79f:	e8 c0 fe ff ff       	call   664 <printint>
 7a4:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ab:	e9 d8 00 00 00       	jmp    888 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7b0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b4:	74 06                	je     7bc <printf+0xa4>
 7b6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ba:	75 1e                	jne    7da <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	6a 00                	push   $0x0
 7c3:	6a 10                	push   $0x10
 7c5:	50                   	push   %eax
 7c6:	ff 75 08             	pushl  0x8(%ebp)
 7c9:	e8 96 fe ff ff       	call   664 <printint>
 7ce:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d5:	e9 ae 00 00 00       	jmp    888 <printf+0x170>
      } else if(c == 's'){
 7da:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7de:	75 43                	jne    823 <printf+0x10b>
        s = (char*)*ap;
 7e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 25                	jne    817 <printf+0xff>
          s = "(null)";
 7f2:	c7 45 f4 11 0b 00 00 	movl   $0xb11,-0xc(%ebp)
        while(*s != 0){
 7f9:	eb 1c                	jmp    817 <printf+0xff>
          putc(fd, *s);
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	0f b6 00             	movzbl (%eax),%eax
 801:	0f be c0             	movsbl %al,%eax
 804:	83 ec 08             	sub    $0x8,%esp
 807:	50                   	push   %eax
 808:	ff 75 08             	pushl  0x8(%ebp)
 80b:	e8 31 fe ff ff       	call   641 <putc>
 810:	83 c4 10             	add    $0x10,%esp
          s++;
 813:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	0f b6 00             	movzbl (%eax),%eax
 81d:	84 c0                	test   %al,%al
 81f:	75 da                	jne    7fb <printf+0xe3>
 821:	eb 65                	jmp    888 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 823:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 827:	75 1d                	jne    846 <printf+0x12e>
        putc(fd, *ap);
 829:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	0f be c0             	movsbl %al,%eax
 831:	83 ec 08             	sub    $0x8,%esp
 834:	50                   	push   %eax
 835:	ff 75 08             	pushl  0x8(%ebp)
 838:	e8 04 fe ff ff       	call   641 <putc>
 83d:	83 c4 10             	add    $0x10,%esp
        ap++;
 840:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 844:	eb 42                	jmp    888 <printf+0x170>
      } else if(c == '%'){
 846:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 84a:	75 17                	jne    863 <printf+0x14b>
        putc(fd, c);
 84c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 84f:	0f be c0             	movsbl %al,%eax
 852:	83 ec 08             	sub    $0x8,%esp
 855:	50                   	push   %eax
 856:	ff 75 08             	pushl  0x8(%ebp)
 859:	e8 e3 fd ff ff       	call   641 <putc>
 85e:	83 c4 10             	add    $0x10,%esp
 861:	eb 25                	jmp    888 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 863:	83 ec 08             	sub    $0x8,%esp
 866:	6a 25                	push   $0x25
 868:	ff 75 08             	pushl  0x8(%ebp)
 86b:	e8 d1 fd ff ff       	call   641 <putc>
 870:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 876:	0f be c0             	movsbl %al,%eax
 879:	83 ec 08             	sub    $0x8,%esp
 87c:	50                   	push   %eax
 87d:	ff 75 08             	pushl  0x8(%ebp)
 880:	e8 bc fd ff ff       	call   641 <putc>
 885:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 888:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 88f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 893:	8b 55 0c             	mov    0xc(%ebp),%edx
 896:	8b 45 f0             	mov    -0x10(%ebp),%eax
 899:	01 d0                	add    %edx,%eax
 89b:	0f b6 00             	movzbl (%eax),%eax
 89e:	84 c0                	test   %al,%al
 8a0:	0f 85 94 fe ff ff    	jne    73a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8a6:	90                   	nop
 8a7:	c9                   	leave  
 8a8:	c3                   	ret    

000008a9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a9:	55                   	push   %ebp
 8aa:	89 e5                	mov    %esp,%ebp
 8ac:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8af:	8b 45 08             	mov    0x8(%ebp),%eax
 8b2:	83 e8 08             	sub    $0x8,%eax
 8b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b8:	a1 a0 0d 00 00       	mov    0xda0,%eax
 8bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c0:	eb 24                	jmp    8e6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ca:	77 12                	ja     8de <free+0x35>
 8cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d2:	77 24                	ja     8f8 <free+0x4f>
 8d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8dc:	77 1a                	ja     8f8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	8b 00                	mov    (%eax),%eax
 8e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ec:	76 d4                	jbe    8c2 <free+0x19>
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f6:	76 ca                	jbe    8c2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fb:	8b 40 04             	mov    0x4(%eax),%eax
 8fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	01 c2                	add    %eax,%edx
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	39 c2                	cmp    %eax,%edx
 911:	75 24                	jne    937 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	8b 50 04             	mov    0x4(%eax),%edx
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	8b 40 04             	mov    0x4(%eax),%eax
 921:	01 c2                	add    %eax,%edx
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	8b 10                	mov    (%eax),%edx
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
 933:	89 10                	mov    %edx,(%eax)
 935:	eb 0a                	jmp    941 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 937:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93a:	8b 10                	mov    (%eax),%edx
 93c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	01 d0                	add    %edx,%eax
 953:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 956:	75 20                	jne    978 <free+0xcf>
    p->s.size += bp->s.size;
 958:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95b:	8b 50 04             	mov    0x4(%eax),%edx
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	01 c2                	add    %eax,%edx
 966:	8b 45 fc             	mov    -0x4(%ebp),%eax
 969:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96f:	8b 10                	mov    (%eax),%edx
 971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 974:	89 10                	mov    %edx,(%eax)
 976:	eb 08                	jmp    980 <free+0xd7>
  } else
    p->s.ptr = bp;
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 97e:	89 10                	mov    %edx,(%eax)
  freep = p;
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	a3 a0 0d 00 00       	mov    %eax,0xda0
}
 988:	90                   	nop
 989:	c9                   	leave  
 98a:	c3                   	ret    

0000098b <morecore>:

static Header*
morecore(uint nu)
{
 98b:	55                   	push   %ebp
 98c:	89 e5                	mov    %esp,%ebp
 98e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 991:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 998:	77 07                	ja     9a1 <morecore+0x16>
    nu = 4096;
 99a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9a1:	8b 45 08             	mov    0x8(%ebp),%eax
 9a4:	c1 e0 03             	shl    $0x3,%eax
 9a7:	83 ec 0c             	sub    $0xc,%esp
 9aa:	50                   	push   %eax
 9ab:	e8 39 fc ff ff       	call   5e9 <sbrk>
 9b0:	83 c4 10             	add    $0x10,%esp
 9b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9ba:	75 07                	jne    9c3 <morecore+0x38>
    return 0;
 9bc:	b8 00 00 00 00       	mov    $0x0,%eax
 9c1:	eb 26                	jmp    9e9 <morecore+0x5e>
  hp = (Header*)p;
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cc:	8b 55 08             	mov    0x8(%ebp),%edx
 9cf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d5:	83 c0 08             	add    $0x8,%eax
 9d8:	83 ec 0c             	sub    $0xc,%esp
 9db:	50                   	push   %eax
 9dc:	e8 c8 fe ff ff       	call   8a9 <free>
 9e1:	83 c4 10             	add    $0x10,%esp
  return freep;
 9e4:	a1 a0 0d 00 00       	mov    0xda0,%eax
}
 9e9:	c9                   	leave  
 9ea:	c3                   	ret    

000009eb <malloc>:

void*
malloc(uint nbytes)
{
 9eb:	55                   	push   %ebp
 9ec:	89 e5                	mov    %esp,%ebp
 9ee:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f1:	8b 45 08             	mov    0x8(%ebp),%eax
 9f4:	83 c0 07             	add    $0x7,%eax
 9f7:	c1 e8 03             	shr    $0x3,%eax
 9fa:	83 c0 01             	add    $0x1,%eax
 9fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a00:	a1 a0 0d 00 00       	mov    0xda0,%eax
 a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a0c:	75 23                	jne    a31 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a0e:	c7 45 f0 98 0d 00 00 	movl   $0xd98,-0x10(%ebp)
 a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a18:	a3 a0 0d 00 00       	mov    %eax,0xda0
 a1d:	a1 a0 0d 00 00       	mov    0xda0,%eax
 a22:	a3 98 0d 00 00       	mov    %eax,0xd98
    base.s.size = 0;
 a27:	c7 05 9c 0d 00 00 00 	movl   $0x0,0xd9c
 a2e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a34:	8b 00                	mov    (%eax),%eax
 a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3c:	8b 40 04             	mov    0x4(%eax),%eax
 a3f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a42:	72 4d                	jb     a91 <malloc+0xa6>
      if(p->s.size == nunits)
 a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a47:	8b 40 04             	mov    0x4(%eax),%eax
 a4a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a4d:	75 0c                	jne    a5b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a52:	8b 10                	mov    (%eax),%edx
 a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a57:	89 10                	mov    %edx,(%eax)
 a59:	eb 26                	jmp    a81 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a64:	89 c2                	mov    %eax,%edx
 a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a69:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6f:	8b 40 04             	mov    0x4(%eax),%eax
 a72:	c1 e0 03             	shl    $0x3,%eax
 a75:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a7e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a84:	a3 a0 0d 00 00       	mov    %eax,0xda0
      return (void*)(p + 1);
 a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8c:	83 c0 08             	add    $0x8,%eax
 a8f:	eb 3b                	jmp    acc <malloc+0xe1>
    }
    if(p == freep)
 a91:	a1 a0 0d 00 00       	mov    0xda0,%eax
 a96:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a99:	75 1e                	jne    ab9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a9b:	83 ec 0c             	sub    $0xc,%esp
 a9e:	ff 75 ec             	pushl  -0x14(%ebp)
 aa1:	e8 e5 fe ff ff       	call   98b <morecore>
 aa6:	83 c4 10             	add    $0x10,%esp
 aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ab0:	75 07                	jne    ab9 <malloc+0xce>
        return 0;
 ab2:	b8 00 00 00 00       	mov    $0x0,%eax
 ab7:	eb 13                	jmp    acc <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac2:	8b 00                	mov    (%eax),%eax
 ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ac7:	e9 6d ff ff ff       	jmp    a39 <malloc+0x4e>
}
 acc:	c9                   	leave  
 acd:	c3                   	ret    
