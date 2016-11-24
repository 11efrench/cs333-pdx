
_chgrp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "stat.h"
int
main(int argc, char* argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 30             	sub    $0x30,%esp
  12:	89 cb                	mov    %ecx,%ebx
    char * path;
    struct stat st;
    int fd;
    int gid;
    int rc;
    path = argv[2];
  14:	8b 43 04             	mov    0x4(%ebx),%eax
  17:	8b 40 08             	mov    0x8(%eax),%eax
  1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    gid = atoi(argv[1]);
  1d:	8b 43 04             	mov    0x4(%ebx),%eax
  20:	83 c0 04             	add    $0x4,%eax
  23:	8b 00                	mov    (%eax),%eax
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	50                   	push   %eax
  29:	e8 fd 04 00 00       	call   52b <atoi>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    if(argc < 3) {
  34:	83 3b 02             	cmpl   $0x2,(%ebx)
  37:	7f 17                	jg     50 <main+0x50>
      printf(1, "Usage: change gid for file \n");
  39:	83 ec 08             	sub    $0x8,%esp
  3c:	68 44 0b 00 00       	push   $0xb44
  41:	6a 01                	push   $0x1
  43:	e8 44 07 00 00       	call   78c <printf>
  48:	83 c4 10             	add    $0x10,%esp
      exit();
  4b:	e8 6d 05 00 00       	call   5bd <exit>
    }

    if((fd = open(path,  0)) < 0 )
  50:	83 ec 08             	sub    $0x8,%esp
  53:	6a 00                	push   $0x0
  55:	ff 75 f4             	pushl  -0xc(%ebp)
  58:	e8 a0 05 00 00       	call   5fd <open>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  67:	79 17                	jns    80 <main+0x80>
    {
      printf(1, "Failed to open specified file\n");
  69:	83 ec 08             	sub    $0x8,%esp
  6c:	68 64 0b 00 00       	push   $0xb64
  71:	6a 01                	push   $0x1
  73:	e8 14 07 00 00       	call   78c <printf>
  78:	83 c4 10             	add    $0x10,%esp
      exit();
  7b:	e8 3d 05 00 00       	call   5bd <exit>
    }
    
    if(fstat(fd, &st) < 0) 
  80:	83 ec 08             	sub    $0x8,%esp
  83:	8d 45 cc             	lea    -0x34(%ebp),%eax
  86:	50                   	push   %eax
  87:	ff 75 ec             	pushl  -0x14(%ebp)
  8a:	e8 86 05 00 00       	call   615 <fstat>
  8f:	83 c4 10             	add    $0x10,%esp
  92:	85 c0                	test   %eax,%eax
  94:	79 17                	jns    ad <main+0xad>
    {
        printf(1, "Cannot pull stat from specified file\n");
  96:	83 ec 08             	sub    $0x8,%esp
  99:	68 84 0b 00 00       	push   $0xb84
  9e:	6a 01                	push   $0x1
  a0:	e8 e7 06 00 00       	call   78c <printf>
  a5:	83 c4 10             	add    $0x10,%esp
        exit();
  a8:	e8 10 05 00 00       	call   5bd <exit>
    }
    close(fd);
  ad:	83 ec 0c             	sub    $0xc,%esp
  b0:	ff 75 ec             	pushl  -0x14(%ebp)
  b3:	e8 2d 05 00 00       	call   5e5 <close>
  b8:	83 c4 10             	add    $0x10,%esp
    
    rc = chgrp(path, gid);
  bb:	83 ec 08             	sub    $0x8,%esp
  be:	ff 75 f0             	pushl  -0x10(%ebp)
  c1:	ff 75 f4             	pushl  -0xc(%ebp)
  c4:	e8 dc 05 00 00       	call   6a5 <chgrp>
  c9:	83 c4 10             	add    $0x10,%esp
  cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(rc  < 0) 
  cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  d3:	79 12                	jns    e7 <main+0xe7>
        printf(1, "Change User Failed.\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 aa 0b 00 00       	push   $0xbaa
  dd:	6a 01                	push   $0x1
  df:	e8 a8 06 00 00       	call   78c <printf>
  e4:	83 c4 10             	add    $0x10,%esp

    exit();
  e7:	e8 d1 04 00 00       	call   5bd <exit>

000000ec <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b7 00             	movzwl (%eax),%eax
  f8:	98                   	cwtl   
  f9:	83 f8 02             	cmp    $0x2,%eax
  fc:	74 1e                	je     11c <print_mode+0x30>
  fe:	83 f8 03             	cmp    $0x3,%eax
 101:	74 2d                	je     130 <print_mode+0x44>
 103:	83 f8 01             	cmp    $0x1,%eax
 106:	75 3c                	jne    144 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 108:	83 ec 08             	sub    $0x8,%esp
 10b:	68 bf 0b 00 00       	push   $0xbbf
 110:	6a 01                	push   $0x1
 112:	e8 75 06 00 00       	call   78c <printf>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	eb 3a                	jmp    156 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 11c:	83 ec 08             	sub    $0x8,%esp
 11f:	68 c1 0b 00 00       	push   $0xbc1
 124:	6a 01                	push   $0x1
 126:	e8 61 06 00 00       	call   78c <printf>
 12b:	83 c4 10             	add    $0x10,%esp
 12e:	eb 26                	jmp    156 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 130:	83 ec 08             	sub    $0x8,%esp
 133:	68 c3 0b 00 00       	push   $0xbc3
 138:	6a 01                	push   $0x1
 13a:	e8 4d 06 00 00       	call   78c <printf>
 13f:	83 c4 10             	add    $0x10,%esp
 142:	eb 12                	jmp    156 <print_mode+0x6a>
    default: printf(1, "?");
 144:	83 ec 08             	sub    $0x8,%esp
 147:	68 c5 0b 00 00       	push   $0xbc5
 14c:	6a 01                	push   $0x1
 14e:	e8 39 06 00 00       	call   78c <printf>
 153:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 15d:	83 e0 01             	and    $0x1,%eax
 160:	84 c0                	test   %al,%al
 162:	74 14                	je     178 <print_mode+0x8c>
    printf(1, "r");
 164:	83 ec 08             	sub    $0x8,%esp
 167:	68 c7 0b 00 00       	push   $0xbc7
 16c:	6a 01                	push   $0x1
 16e:	e8 19 06 00 00       	call   78c <printf>
 173:	83 c4 10             	add    $0x10,%esp
 176:	eb 12                	jmp    18a <print_mode+0x9e>
  else
    printf(1, "-");
 178:	83 ec 08             	sub    $0x8,%esp
 17b:	68 c1 0b 00 00       	push   $0xbc1
 180:	6a 01                	push   $0x1
 182:	e8 05 06 00 00       	call   78c <printf>
 187:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 191:	83 e0 80             	and    $0xffffff80,%eax
 194:	84 c0                	test   %al,%al
 196:	74 14                	je     1ac <print_mode+0xc0>
    printf(1, "w");
 198:	83 ec 08             	sub    $0x8,%esp
 19b:	68 c9 0b 00 00       	push   $0xbc9
 1a0:	6a 01                	push   $0x1
 1a2:	e8 e5 05 00 00       	call   78c <printf>
 1a7:	83 c4 10             	add    $0x10,%esp
 1aa:	eb 12                	jmp    1be <print_mode+0xd2>
  else
    printf(1, "-");
 1ac:	83 ec 08             	sub    $0x8,%esp
 1af:	68 c1 0b 00 00       	push   $0xbc1
 1b4:	6a 01                	push   $0x1
 1b6:	e8 d1 05 00 00       	call   78c <printf>
 1bb:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1c5:	c0 e8 06             	shr    $0x6,%al
 1c8:	83 e0 01             	and    $0x1,%eax
 1cb:	0f b6 d0             	movzbl %al,%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 1d5:	d0 e8                	shr    %al
 1d7:	83 e0 01             	and    $0x1,%eax
 1da:	0f b6 c0             	movzbl %al,%eax
 1dd:	21 d0                	and    %edx,%eax
 1df:	85 c0                	test   %eax,%eax
 1e1:	74 14                	je     1f7 <print_mode+0x10b>
    printf(1, "S");
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	68 cb 0b 00 00       	push   $0xbcb
 1eb:	6a 01                	push   $0x1
 1ed:	e8 9a 05 00 00       	call   78c <printf>
 1f2:	83 c4 10             	add    $0x10,%esp
 1f5:	eb 34                	jmp    22b <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1fe:	83 e0 40             	and    $0x40,%eax
 201:	84 c0                	test   %al,%al
 203:	74 14                	je     219 <print_mode+0x12d>
    printf(1, "x");
 205:	83 ec 08             	sub    $0x8,%esp
 208:	68 cd 0b 00 00       	push   $0xbcd
 20d:	6a 01                	push   $0x1
 20f:	e8 78 05 00 00       	call   78c <printf>
 214:	83 c4 10             	add    $0x10,%esp
 217:	eb 12                	jmp    22b <print_mode+0x13f>
  else
    printf(1, "-");
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	68 c1 0b 00 00       	push   $0xbc1
 221:	6a 01                	push   $0x1
 223:	e8 64 05 00 00       	call   78c <printf>
 228:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 232:	83 e0 20             	and    $0x20,%eax
 235:	84 c0                	test   %al,%al
 237:	74 14                	je     24d <print_mode+0x161>
    printf(1, "r");
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	68 c7 0b 00 00       	push   $0xbc7
 241:	6a 01                	push   $0x1
 243:	e8 44 05 00 00       	call   78c <printf>
 248:	83 c4 10             	add    $0x10,%esp
 24b:	eb 12                	jmp    25f <print_mode+0x173>
  else
    printf(1, "-");
 24d:	83 ec 08             	sub    $0x8,%esp
 250:	68 c1 0b 00 00       	push   $0xbc1
 255:	6a 01                	push   $0x1
 257:	e8 30 05 00 00       	call   78c <printf>
 25c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 266:	83 e0 10             	and    $0x10,%eax
 269:	84 c0                	test   %al,%al
 26b:	74 14                	je     281 <print_mode+0x195>
    printf(1, "w");
 26d:	83 ec 08             	sub    $0x8,%esp
 270:	68 c9 0b 00 00       	push   $0xbc9
 275:	6a 01                	push   $0x1
 277:	e8 10 05 00 00       	call   78c <printf>
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	eb 12                	jmp    293 <print_mode+0x1a7>
  else
    printf(1, "-");
 281:	83 ec 08             	sub    $0x8,%esp
 284:	68 c1 0b 00 00       	push   $0xbc1
 289:	6a 01                	push   $0x1
 28b:	e8 fc 04 00 00       	call   78c <printf>
 290:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 29a:	83 e0 08             	and    $0x8,%eax
 29d:	84 c0                	test   %al,%al
 29f:	74 14                	je     2b5 <print_mode+0x1c9>
    printf(1, "x");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 cd 0b 00 00       	push   $0xbcd
 2a9:	6a 01                	push   $0x1
 2ab:	e8 dc 04 00 00       	call   78c <printf>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	eb 12                	jmp    2c7 <print_mode+0x1db>
  else
    printf(1, "-");
 2b5:	83 ec 08             	sub    $0x8,%esp
 2b8:	68 c1 0b 00 00       	push   $0xbc1
 2bd:	6a 01                	push   $0x1
 2bf:	e8 c8 04 00 00       	call   78c <printf>
 2c4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2ce:	83 e0 04             	and    $0x4,%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	74 14                	je     2e9 <print_mode+0x1fd>
    printf(1, "r");
 2d5:	83 ec 08             	sub    $0x8,%esp
 2d8:	68 c7 0b 00 00       	push   $0xbc7
 2dd:	6a 01                	push   $0x1
 2df:	e8 a8 04 00 00       	call   78c <printf>
 2e4:	83 c4 10             	add    $0x10,%esp
 2e7:	eb 12                	jmp    2fb <print_mode+0x20f>
  else
    printf(1, "-");
 2e9:	83 ec 08             	sub    $0x8,%esp
 2ec:	68 c1 0b 00 00       	push   $0xbc1
 2f1:	6a 01                	push   $0x1
 2f3:	e8 94 04 00 00       	call   78c <printf>
 2f8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 302:	83 e0 02             	and    $0x2,%eax
 305:	84 c0                	test   %al,%al
 307:	74 14                	je     31d <print_mode+0x231>
    printf(1, "w");
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	68 c9 0b 00 00       	push   $0xbc9
 311:	6a 01                	push   $0x1
 313:	e8 74 04 00 00       	call   78c <printf>
 318:	83 c4 10             	add    $0x10,%esp
 31b:	eb 12                	jmp    32f <print_mode+0x243>
  else
    printf(1, "-");
 31d:	83 ec 08             	sub    $0x8,%esp
 320:	68 c1 0b 00 00       	push   $0xbc1
 325:	6a 01                	push   $0x1
 327:	e8 60 04 00 00       	call   78c <printf>
 32c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 336:	83 e0 01             	and    $0x1,%eax
 339:	84 c0                	test   %al,%al
 33b:	74 14                	je     351 <print_mode+0x265>
    printf(1, "x");
 33d:	83 ec 08             	sub    $0x8,%esp
 340:	68 cd 0b 00 00       	push   $0xbcd
 345:	6a 01                	push   $0x1
 347:	e8 40 04 00 00       	call   78c <printf>
 34c:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 34f:	eb 13                	jmp    364 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 351:	83 ec 08             	sub    $0x8,%esp
 354:	68 c1 0b 00 00       	push   $0xbc1
 359:	6a 01                	push   $0x1
 35b:	e8 2c 04 00 00       	call   78c <printf>
 360:	83 c4 10             	add    $0x10,%esp

  return;
 363:	90                   	nop
}
 364:	c9                   	leave  
 365:	c3                   	ret    

00000366 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	57                   	push   %edi
 36a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 36b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 36e:	8b 55 10             	mov    0x10(%ebp),%edx
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	89 cb                	mov    %ecx,%ebx
 376:	89 df                	mov    %ebx,%edi
 378:	89 d1                	mov    %edx,%ecx
 37a:	fc                   	cld    
 37b:	f3 aa                	rep stos %al,%es:(%edi)
 37d:	89 ca                	mov    %ecx,%edx
 37f:	89 fb                	mov    %edi,%ebx
 381:	89 5d 08             	mov    %ebx,0x8(%ebp)
 384:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 387:	90                   	nop
 388:	5b                   	pop    %ebx
 389:	5f                   	pop    %edi
 38a:	5d                   	pop    %ebp
 38b:	c3                   	ret    

0000038c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 398:	90                   	nop
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	8d 50 01             	lea    0x1(%eax),%edx
 39f:	89 55 08             	mov    %edx,0x8(%ebp)
 3a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 3a5:	8d 4a 01             	lea    0x1(%edx),%ecx
 3a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3ab:	0f b6 12             	movzbl (%edx),%edx
 3ae:	88 10                	mov    %dl,(%eax)
 3b0:	0f b6 00             	movzbl (%eax),%eax
 3b3:	84 c0                	test   %al,%al
 3b5:	75 e2                	jne    399 <strcpy+0xd>
    ;
  return os;
 3b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ba:	c9                   	leave  
 3bb:	c3                   	ret    

000003bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3bf:	eb 08                	jmp    3c9 <strcmp+0xd>
    p++, q++;
 3c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	84 c0                	test   %al,%al
 3d1:	74 10                	je     3e3 <strcmp+0x27>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 10             	movzbl (%eax),%edx
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	38 c2                	cmp    %al,%dl
 3e1:	74 de                	je     3c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	0f b6 d0             	movzbl %al,%edx
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	0f b6 c0             	movzbl %al,%eax
 3f5:	29 c2                	sub    %eax,%edx
 3f7:	89 d0                	mov    %edx,%eax
}
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    

000003fb <strlen>:

uint
strlen(char *s)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 408:	eb 04                	jmp    40e <strlen+0x13>
 40a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 40e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	0f b6 00             	movzbl (%eax),%eax
 419:	84 c0                	test   %al,%al
 41b:	75 ed                	jne    40a <strlen+0xf>
    ;
  return n;
 41d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <memset>:

void*
memset(void *dst, int c, uint n)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 425:	8b 45 10             	mov    0x10(%ebp),%eax
 428:	50                   	push   %eax
 429:	ff 75 0c             	pushl  0xc(%ebp)
 42c:	ff 75 08             	pushl  0x8(%ebp)
 42f:	e8 32 ff ff ff       	call   366 <stosb>
 434:	83 c4 0c             	add    $0xc,%esp
  return dst;
 437:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43a:	c9                   	leave  
 43b:	c3                   	ret    

0000043c <strchr>:

char*
strchr(const char *s, char c)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	83 ec 04             	sub    $0x4,%esp
 442:	8b 45 0c             	mov    0xc(%ebp),%eax
 445:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 448:	eb 14                	jmp    45e <strchr+0x22>
    if(*s == c)
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	0f b6 00             	movzbl (%eax),%eax
 450:	3a 45 fc             	cmp    -0x4(%ebp),%al
 453:	75 05                	jne    45a <strchr+0x1e>
      return (char*)s;
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	eb 13                	jmp    46d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 45a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	0f b6 00             	movzbl (%eax),%eax
 464:	84 c0                	test   %al,%al
 466:	75 e2                	jne    44a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 468:	b8 00 00 00 00       	mov    $0x0,%eax
}
 46d:	c9                   	leave  
 46e:	c3                   	ret    

0000046f <gets>:

char*
gets(char *buf, int max)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 47c:	eb 42                	jmp    4c0 <gets+0x51>
    cc = read(0, &c, 1);
 47e:	83 ec 04             	sub    $0x4,%esp
 481:	6a 01                	push   $0x1
 483:	8d 45 ef             	lea    -0x11(%ebp),%eax
 486:	50                   	push   %eax
 487:	6a 00                	push   $0x0
 489:	e8 47 01 00 00       	call   5d5 <read>
 48e:	83 c4 10             	add    $0x10,%esp
 491:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 498:	7e 33                	jle    4cd <gets+0x5e>
      break;
    buf[i++] = c;
 49a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49d:	8d 50 01             	lea    0x1(%eax),%edx
 4a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a3:	89 c2                	mov    %eax,%edx
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	01 c2                	add    %eax,%edx
 4aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ae:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b4:	3c 0a                	cmp    $0xa,%al
 4b6:	74 16                	je     4ce <gets+0x5f>
 4b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bc:	3c 0d                	cmp    $0xd,%al
 4be:	74 0e                	je     4ce <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c3:	83 c0 01             	add    $0x1,%eax
 4c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4c9:	7c b3                	jl     47e <gets+0xf>
 4cb:	eb 01                	jmp    4ce <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4cd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	01 d0                	add    %edx,%eax
 4d6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4dc:	c9                   	leave  
 4dd:	c3                   	ret    

000004de <stat>:

int
stat(char *n, struct stat *st)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e4:	83 ec 08             	sub    $0x8,%esp
 4e7:	6a 00                	push   $0x0
 4e9:	ff 75 08             	pushl  0x8(%ebp)
 4ec:	e8 0c 01 00 00       	call   5fd <open>
 4f1:	83 c4 10             	add    $0x10,%esp
 4f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fb:	79 07                	jns    504 <stat+0x26>
    return -1;
 4fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 502:	eb 25                	jmp    529 <stat+0x4b>
  r = fstat(fd, st);
 504:	83 ec 08             	sub    $0x8,%esp
 507:	ff 75 0c             	pushl  0xc(%ebp)
 50a:	ff 75 f4             	pushl  -0xc(%ebp)
 50d:	e8 03 01 00 00       	call   615 <fstat>
 512:	83 c4 10             	add    $0x10,%esp
 515:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 518:	83 ec 0c             	sub    $0xc,%esp
 51b:	ff 75 f4             	pushl  -0xc(%ebp)
 51e:	e8 c2 00 00 00       	call   5e5 <close>
 523:	83 c4 10             	add    $0x10,%esp
  return r;
 526:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 529:	c9                   	leave  
 52a:	c3                   	ret    

0000052b <atoi>:

int
atoi(const char *s)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 538:	eb 25                	jmp    55f <atoi+0x34>
    n = n*10 + *s++ - '0';
 53a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 53d:	89 d0                	mov    %edx,%eax
 53f:	c1 e0 02             	shl    $0x2,%eax
 542:	01 d0                	add    %edx,%eax
 544:	01 c0                	add    %eax,%eax
 546:	89 c1                	mov    %eax,%ecx
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	8d 50 01             	lea    0x1(%eax),%edx
 54e:	89 55 08             	mov    %edx,0x8(%ebp)
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	01 c8                	add    %ecx,%eax
 559:	83 e8 30             	sub    $0x30,%eax
 55c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	3c 2f                	cmp    $0x2f,%al
 567:	7e 0a                	jle    573 <atoi+0x48>
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	0f b6 00             	movzbl (%eax),%eax
 56f:	3c 39                	cmp    $0x39,%al
 571:	7e c7                	jle    53a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 573:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 576:	c9                   	leave  
 577:	c3                   	ret    

00000578 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 57e:	8b 45 08             	mov    0x8(%ebp),%eax
 581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 584:	8b 45 0c             	mov    0xc(%ebp),%eax
 587:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 58a:	eb 17                	jmp    5a3 <memmove+0x2b>
    *dst++ = *src++;
 58c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 58f:	8d 50 01             	lea    0x1(%eax),%edx
 592:	89 55 fc             	mov    %edx,-0x4(%ebp)
 595:	8b 55 f8             	mov    -0x8(%ebp),%edx
 598:	8d 4a 01             	lea    0x1(%edx),%ecx
 59b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 59e:	0f b6 12             	movzbl (%edx),%edx
 5a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a3:	8b 45 10             	mov    0x10(%ebp),%eax
 5a6:	8d 50 ff             	lea    -0x1(%eax),%edx
 5a9:	89 55 10             	mov    %edx,0x10(%ebp)
 5ac:	85 c0                	test   %eax,%eax
 5ae:	7f dc                	jg     58c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b3:	c9                   	leave  
 5b4:	c3                   	ret    

000005b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5b5:	b8 01 00 00 00       	mov    $0x1,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <exit>:
SYSCALL(exit)
 5bd:	b8 02 00 00 00       	mov    $0x2,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <wait>:
SYSCALL(wait)
 5c5:	b8 03 00 00 00       	mov    $0x3,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <pipe>:
SYSCALL(pipe)
 5cd:	b8 04 00 00 00       	mov    $0x4,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <read>:
SYSCALL(read)
 5d5:	b8 05 00 00 00       	mov    $0x5,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <write>:
SYSCALL(write)
 5dd:	b8 10 00 00 00       	mov    $0x10,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <close>:
SYSCALL(close)
 5e5:	b8 15 00 00 00       	mov    $0x15,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <kill>:
SYSCALL(kill)
 5ed:	b8 06 00 00 00       	mov    $0x6,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <exec>:
SYSCALL(exec)
 5f5:	b8 07 00 00 00       	mov    $0x7,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <open>:
SYSCALL(open)
 5fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <mknod>:
SYSCALL(mknod)
 605:	b8 11 00 00 00       	mov    $0x11,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <unlink>:
SYSCALL(unlink)
 60d:	b8 12 00 00 00       	mov    $0x12,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <fstat>:
SYSCALL(fstat)
 615:	b8 08 00 00 00       	mov    $0x8,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <link>:
SYSCALL(link)
 61d:	b8 13 00 00 00       	mov    $0x13,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <mkdir>:
SYSCALL(mkdir)
 625:	b8 14 00 00 00       	mov    $0x14,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <chdir>:
SYSCALL(chdir)
 62d:	b8 09 00 00 00       	mov    $0x9,%eax
 632:	cd 40                	int    $0x40
 634:	c3                   	ret    

00000635 <dup>:
SYSCALL(dup)
 635:	b8 0a 00 00 00       	mov    $0xa,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <getpid>:
SYSCALL(getpid)
 63d:	b8 0b 00 00 00       	mov    $0xb,%eax
 642:	cd 40                	int    $0x40
 644:	c3                   	ret    

00000645 <sbrk>:
SYSCALL(sbrk)
 645:	b8 0c 00 00 00       	mov    $0xc,%eax
 64a:	cd 40                	int    $0x40
 64c:	c3                   	ret    

0000064d <sleep>:
SYSCALL(sleep)
 64d:	b8 0d 00 00 00       	mov    $0xd,%eax
 652:	cd 40                	int    $0x40
 654:	c3                   	ret    

00000655 <uptime>:
SYSCALL(uptime)
 655:	b8 0e 00 00 00       	mov    $0xe,%eax
 65a:	cd 40                	int    $0x40
 65c:	c3                   	ret    

0000065d <halt>:
SYSCALL(halt)
 65d:	b8 16 00 00 00       	mov    $0x16,%eax
 662:	cd 40                	int    $0x40
 664:	c3                   	ret    

00000665 <date>:
//Student Implementations 
SYSCALL(date)
 665:	b8 17 00 00 00       	mov    $0x17,%eax
 66a:	cd 40                	int    $0x40
 66c:	c3                   	ret    

0000066d <getuid>:

SYSCALL(getuid)
 66d:	b8 18 00 00 00       	mov    $0x18,%eax
 672:	cd 40                	int    $0x40
 674:	c3                   	ret    

00000675 <getgid>:
SYSCALL(getgid)
 675:	b8 19 00 00 00       	mov    $0x19,%eax
 67a:	cd 40                	int    $0x40
 67c:	c3                   	ret    

0000067d <getppid>:
SYSCALL(getppid)
 67d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 682:	cd 40                	int    $0x40
 684:	c3                   	ret    

00000685 <setuid>:

SYSCALL(setuid)
 685:	b8 1b 00 00 00       	mov    $0x1b,%eax
 68a:	cd 40                	int    $0x40
 68c:	c3                   	ret    

0000068d <setgid>:
SYSCALL(setgid)
 68d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 692:	cd 40                	int    $0x40
 694:	c3                   	ret    

00000695 <getprocs>:
SYSCALL(getprocs)
 695:	b8 1d 00 00 00       	mov    $0x1d,%eax
 69a:	cd 40                	int    $0x40
 69c:	c3                   	ret    

0000069d <chown>:

SYSCALL(chown)
 69d:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6a2:	cd 40                	int    $0x40
 6a4:	c3                   	ret    

000006a5 <chgrp>:
SYSCALL(chgrp)
 6a5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6aa:	cd 40                	int    $0x40
 6ac:	c3                   	ret    

000006ad <chmod>:
SYSCALL(chmod)
 6ad:	b8 20 00 00 00       	mov    $0x20,%eax
 6b2:	cd 40                	int    $0x40
 6b4:	c3                   	ret    

000006b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b5:	55                   	push   %ebp
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	83 ec 18             	sub    $0x18,%esp
 6bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6be:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6c1:	83 ec 04             	sub    $0x4,%esp
 6c4:	6a 01                	push   $0x1
 6c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6c9:	50                   	push   %eax
 6ca:	ff 75 08             	pushl  0x8(%ebp)
 6cd:	e8 0b ff ff ff       	call   5dd <write>
 6d2:	83 c4 10             	add    $0x10,%esp
}
 6d5:	90                   	nop
 6d6:	c9                   	leave  
 6d7:	c3                   	ret    

000006d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	53                   	push   %ebx
 6dc:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ea:	74 17                	je     703 <printint+0x2b>
 6ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6f0:	79 11                	jns    703 <printint+0x2b>
    neg = 1;
 6f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fc:	f7 d8                	neg    %eax
 6fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
 701:	eb 06                	jmp    709 <printint+0x31>
  } else {
    x = xx;
 703:	8b 45 0c             	mov    0xc(%ebp),%eax
 706:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 709:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 710:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 713:	8d 41 01             	lea    0x1(%ecx),%eax
 716:	89 45 f4             	mov    %eax,-0xc(%ebp)
 719:	8b 5d 10             	mov    0x10(%ebp),%ebx
 71c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71f:	ba 00 00 00 00       	mov    $0x0,%edx
 724:	f7 f3                	div    %ebx
 726:	89 d0                	mov    %edx,%eax
 728:	0f b6 80 44 0e 00 00 	movzbl 0xe44(%eax),%eax
 72f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 733:	8b 5d 10             	mov    0x10(%ebp),%ebx
 736:	8b 45 ec             	mov    -0x14(%ebp),%eax
 739:	ba 00 00 00 00       	mov    $0x0,%edx
 73e:	f7 f3                	div    %ebx
 740:	89 45 ec             	mov    %eax,-0x14(%ebp)
 743:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 747:	75 c7                	jne    710 <printint+0x38>
  if(neg)
 749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74d:	74 2d                	je     77c <printint+0xa4>
    buf[i++] = '-';
 74f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 752:	8d 50 01             	lea    0x1(%eax),%edx
 755:	89 55 f4             	mov    %edx,-0xc(%ebp)
 758:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 75d:	eb 1d                	jmp    77c <printint+0xa4>
    putc(fd, buf[i]);
 75f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	01 d0                	add    %edx,%eax
 767:	0f b6 00             	movzbl (%eax),%eax
 76a:	0f be c0             	movsbl %al,%eax
 76d:	83 ec 08             	sub    $0x8,%esp
 770:	50                   	push   %eax
 771:	ff 75 08             	pushl  0x8(%ebp)
 774:	e8 3c ff ff ff       	call   6b5 <putc>
 779:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 77c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 784:	79 d9                	jns    75f <printint+0x87>
    putc(fd, buf[i]);
}
 786:	90                   	nop
 787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 78a:	c9                   	leave  
 78b:	c3                   	ret    

0000078c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 78c:	55                   	push   %ebp
 78d:	89 e5                	mov    %esp,%ebp
 78f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 792:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 799:	8d 45 0c             	lea    0xc(%ebp),%eax
 79c:	83 c0 04             	add    $0x4,%eax
 79f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a9:	e9 59 01 00 00       	jmp    907 <printf+0x17b>
    c = fmt[i] & 0xff;
 7ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	01 d0                	add    %edx,%eax
 7b6:	0f b6 00             	movzbl (%eax),%eax
 7b9:	0f be c0             	movsbl %al,%eax
 7bc:	25 ff 00 00 00       	and    $0xff,%eax
 7c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c8:	75 2c                	jne    7f6 <printf+0x6a>
      if(c == '%'){
 7ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ce:	75 0c                	jne    7dc <printf+0x50>
        state = '%';
 7d0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d7:	e9 27 01 00 00       	jmp    903 <printf+0x177>
      } else {
        putc(fd, c);
 7dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7df:	0f be c0             	movsbl %al,%eax
 7e2:	83 ec 08             	sub    $0x8,%esp
 7e5:	50                   	push   %eax
 7e6:	ff 75 08             	pushl  0x8(%ebp)
 7e9:	e8 c7 fe ff ff       	call   6b5 <putc>
 7ee:	83 c4 10             	add    $0x10,%esp
 7f1:	e9 0d 01 00 00       	jmp    903 <printf+0x177>
      }
    } else if(state == '%'){
 7f6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7fa:	0f 85 03 01 00 00    	jne    903 <printf+0x177>
      if(c == 'd'){
 800:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 804:	75 1e                	jne    824 <printf+0x98>
        printint(fd, *ap, 10, 1);
 806:	8b 45 e8             	mov    -0x18(%ebp),%eax
 809:	8b 00                	mov    (%eax),%eax
 80b:	6a 01                	push   $0x1
 80d:	6a 0a                	push   $0xa
 80f:	50                   	push   %eax
 810:	ff 75 08             	pushl  0x8(%ebp)
 813:	e8 c0 fe ff ff       	call   6d8 <printint>
 818:	83 c4 10             	add    $0x10,%esp
        ap++;
 81b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81f:	e9 d8 00 00 00       	jmp    8fc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 824:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 828:	74 06                	je     830 <printf+0xa4>
 82a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 82e:	75 1e                	jne    84e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 830:	8b 45 e8             	mov    -0x18(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	6a 00                	push   $0x0
 837:	6a 10                	push   $0x10
 839:	50                   	push   %eax
 83a:	ff 75 08             	pushl  0x8(%ebp)
 83d:	e8 96 fe ff ff       	call   6d8 <printint>
 842:	83 c4 10             	add    $0x10,%esp
        ap++;
 845:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 849:	e9 ae 00 00 00       	jmp    8fc <printf+0x170>
      } else if(c == 's'){
 84e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 852:	75 43                	jne    897 <printf+0x10b>
        s = (char*)*ap;
 854:	8b 45 e8             	mov    -0x18(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 85c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 864:	75 25                	jne    88b <printf+0xff>
          s = "(null)";
 866:	c7 45 f4 cf 0b 00 00 	movl   $0xbcf,-0xc(%ebp)
        while(*s != 0){
 86d:	eb 1c                	jmp    88b <printf+0xff>
          putc(fd, *s);
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	0f b6 00             	movzbl (%eax),%eax
 875:	0f be c0             	movsbl %al,%eax
 878:	83 ec 08             	sub    $0x8,%esp
 87b:	50                   	push   %eax
 87c:	ff 75 08             	pushl  0x8(%ebp)
 87f:	e8 31 fe ff ff       	call   6b5 <putc>
 884:	83 c4 10             	add    $0x10,%esp
          s++;
 887:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	0f b6 00             	movzbl (%eax),%eax
 891:	84 c0                	test   %al,%al
 893:	75 da                	jne    86f <printf+0xe3>
 895:	eb 65                	jmp    8fc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 897:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 89b:	75 1d                	jne    8ba <printf+0x12e>
        putc(fd, *ap);
 89d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	0f be c0             	movsbl %al,%eax
 8a5:	83 ec 08             	sub    $0x8,%esp
 8a8:	50                   	push   %eax
 8a9:	ff 75 08             	pushl  0x8(%ebp)
 8ac:	e8 04 fe ff ff       	call   6b5 <putc>
 8b1:	83 c4 10             	add    $0x10,%esp
        ap++;
 8b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b8:	eb 42                	jmp    8fc <printf+0x170>
      } else if(c == '%'){
 8ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8be:	75 17                	jne    8d7 <printf+0x14b>
        putc(fd, c);
 8c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c3:	0f be c0             	movsbl %al,%eax
 8c6:	83 ec 08             	sub    $0x8,%esp
 8c9:	50                   	push   %eax
 8ca:	ff 75 08             	pushl  0x8(%ebp)
 8cd:	e8 e3 fd ff ff       	call   6b5 <putc>
 8d2:	83 c4 10             	add    $0x10,%esp
 8d5:	eb 25                	jmp    8fc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d7:	83 ec 08             	sub    $0x8,%esp
 8da:	6a 25                	push   $0x25
 8dc:	ff 75 08             	pushl  0x8(%ebp)
 8df:	e8 d1 fd ff ff       	call   6b5 <putc>
 8e4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ea:	0f be c0             	movsbl %al,%eax
 8ed:	83 ec 08             	sub    $0x8,%esp
 8f0:	50                   	push   %eax
 8f1:	ff 75 08             	pushl  0x8(%ebp)
 8f4:	e8 bc fd ff ff       	call   6b5 <putc>
 8f9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 903:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 907:	8b 55 0c             	mov    0xc(%ebp),%edx
 90a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90d:	01 d0                	add    %edx,%eax
 90f:	0f b6 00             	movzbl (%eax),%eax
 912:	84 c0                	test   %al,%al
 914:	0f 85 94 fe ff ff    	jne    7ae <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 91a:	90                   	nop
 91b:	c9                   	leave  
 91c:	c3                   	ret    

0000091d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91d:	55                   	push   %ebp
 91e:	89 e5                	mov    %esp,%ebp
 920:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 923:	8b 45 08             	mov    0x8(%ebp),%eax
 926:	83 e8 08             	sub    $0x8,%eax
 929:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	a1 60 0e 00 00       	mov    0xe60,%eax
 931:	89 45 fc             	mov    %eax,-0x4(%ebp)
 934:	eb 24                	jmp    95a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
 939:	8b 00                	mov    (%eax),%eax
 93b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93e:	77 12                	ja     952 <free+0x35>
 940:	8b 45 f8             	mov    -0x8(%ebp),%eax
 943:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 946:	77 24                	ja     96c <free+0x4f>
 948:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94b:	8b 00                	mov    (%eax),%eax
 94d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 950:	77 1a                	ja     96c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	8b 00                	mov    (%eax),%eax
 957:	89 45 fc             	mov    %eax,-0x4(%ebp)
 95a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 960:	76 d4                	jbe    936 <free+0x19>
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	8b 00                	mov    (%eax),%eax
 967:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96a:	76 ca                	jbe    936 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 96c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96f:	8b 40 04             	mov    0x4(%eax),%eax
 972:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 979:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97c:	01 c2                	add    %eax,%edx
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	39 c2                	cmp    %eax,%edx
 985:	75 24                	jne    9ab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	8b 50 04             	mov    0x4(%eax),%edx
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	8b 00                	mov    (%eax),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	01 c2                	add    %eax,%edx
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 99d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a0:	8b 00                	mov    (%eax),%eax
 9a2:	8b 10                	mov    (%eax),%edx
 9a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a7:	89 10                	mov    %edx,(%eax)
 9a9:	eb 0a                	jmp    9b5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ae:	8b 10                	mov    (%eax),%edx
 9b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	8b 40 04             	mov    0x4(%eax),%eax
 9bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	01 d0                	add    %edx,%eax
 9c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ca:	75 20                	jne    9ec <free+0xcf>
    p->s.size += bp->s.size;
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	8b 50 04             	mov    0x4(%eax),%edx
 9d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	01 c2                	add    %eax,%edx
 9da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e3:	8b 10                	mov    (%eax),%edx
 9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e8:	89 10                	mov    %edx,(%eax)
 9ea:	eb 08                	jmp    9f4 <free+0xd7>
  } else
    p->s.ptr = bp;
 9ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9f2:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f7:	a3 60 0e 00 00       	mov    %eax,0xe60
}
 9fc:	90                   	nop
 9fd:	c9                   	leave  
 9fe:	c3                   	ret    

000009ff <morecore>:

static Header*
morecore(uint nu)
{
 9ff:	55                   	push   %ebp
 a00:	89 e5                	mov    %esp,%ebp
 a02:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a05:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a0c:	77 07                	ja     a15 <morecore+0x16>
    nu = 4096;
 a0e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a15:	8b 45 08             	mov    0x8(%ebp),%eax
 a18:	c1 e0 03             	shl    $0x3,%eax
 a1b:	83 ec 0c             	sub    $0xc,%esp
 a1e:	50                   	push   %eax
 a1f:	e8 21 fc ff ff       	call   645 <sbrk>
 a24:	83 c4 10             	add    $0x10,%esp
 a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a2a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a2e:	75 07                	jne    a37 <morecore+0x38>
    return 0;
 a30:	b8 00 00 00 00       	mov    $0x0,%eax
 a35:	eb 26                	jmp    a5d <morecore+0x5e>
  hp = (Header*)p;
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a40:	8b 55 08             	mov    0x8(%ebp),%edx
 a43:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a49:	83 c0 08             	add    $0x8,%eax
 a4c:	83 ec 0c             	sub    $0xc,%esp
 a4f:	50                   	push   %eax
 a50:	e8 c8 fe ff ff       	call   91d <free>
 a55:	83 c4 10             	add    $0x10,%esp
  return freep;
 a58:	a1 60 0e 00 00       	mov    0xe60,%eax
}
 a5d:	c9                   	leave  
 a5e:	c3                   	ret    

00000a5f <malloc>:

void*
malloc(uint nbytes)
{
 a5f:	55                   	push   %ebp
 a60:	89 e5                	mov    %esp,%ebp
 a62:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a65:	8b 45 08             	mov    0x8(%ebp),%eax
 a68:	83 c0 07             	add    $0x7,%eax
 a6b:	c1 e8 03             	shr    $0x3,%eax
 a6e:	83 c0 01             	add    $0x1,%eax
 a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a74:	a1 60 0e 00 00       	mov    0xe60,%eax
 a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a80:	75 23                	jne    aa5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a82:	c7 45 f0 58 0e 00 00 	movl   $0xe58,-0x10(%ebp)
 a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8c:	a3 60 0e 00 00       	mov    %eax,0xe60
 a91:	a1 60 0e 00 00       	mov    0xe60,%eax
 a96:	a3 58 0e 00 00       	mov    %eax,0xe58
    base.s.size = 0;
 a9b:	c7 05 5c 0e 00 00 00 	movl   $0x0,0xe5c
 aa2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa8:	8b 00                	mov    (%eax),%eax
 aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab0:	8b 40 04             	mov    0x4(%eax),%eax
 ab3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab6:	72 4d                	jb     b05 <malloc+0xa6>
      if(p->s.size == nunits)
 ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abb:	8b 40 04             	mov    0x4(%eax),%eax
 abe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ac1:	75 0c                	jne    acf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac6:	8b 10                	mov    (%eax),%edx
 ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acb:	89 10                	mov    %edx,(%eax)
 acd:	eb 26                	jmp    af5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	8b 40 04             	mov    0x4(%eax),%eax
 ad5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ad8:	89 c2                	mov    %eax,%edx
 ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
 add:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae3:	8b 40 04             	mov    0x4(%eax),%eax
 ae6:	c1 e0 03             	shl    $0x3,%eax
 ae9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aef:	8b 55 ec             	mov    -0x14(%ebp),%edx
 af2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af8:	a3 60 0e 00 00       	mov    %eax,0xe60
      return (void*)(p + 1);
 afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b00:	83 c0 08             	add    $0x8,%eax
 b03:	eb 3b                	jmp    b40 <malloc+0xe1>
    }
    if(p == freep)
 b05:	a1 60 0e 00 00       	mov    0xe60,%eax
 b0a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b0d:	75 1e                	jne    b2d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b0f:	83 ec 0c             	sub    $0xc,%esp
 b12:	ff 75 ec             	pushl  -0x14(%ebp)
 b15:	e8 e5 fe ff ff       	call   9ff <morecore>
 b1a:	83 c4 10             	add    $0x10,%esp
 b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b24:	75 07                	jne    b2d <malloc+0xce>
        return 0;
 b26:	b8 00 00 00 00       	mov    $0x0,%eax
 b2b:	eb 13                	jmp    b40 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b36:	8b 00                	mov    (%eax),%eax
 b38:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b3b:	e9 6d ff ff ff       	jmp    aad <malloc+0x4e>
}
 b40:	c9                   	leave  
 b41:	c3                   	ret    
