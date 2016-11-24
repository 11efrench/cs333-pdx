
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 80 0e 00 00       	push   $0xe80
  13:	6a 01                	push   $0x1
  15:	e8 e6 05 00 00       	call   600 <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 80 0e 00 00       	push   $0xe80
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 c6 05 00 00       	call   5f8 <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 65 0b 00 00       	push   $0xb65
  4c:	6a 01                	push   $0x1
  4e:	e8 5c 07 00 00       	call   7af <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 85 05 00 00       	call   5e0 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 57 05 00 00       	call   5e0 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 72 05 00 00       	call   620 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 76 0b 00 00       	push   $0xb76
  d4:	6a 01                	push   $0x1
  d6:	e8 d4 06 00 00       	call   7af <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 fd 04 00 00       	call   5e0 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 0c 05 00 00       	call   608 <close>
  fc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 10a:	e8 d1 04 00 00       	call   5e0 <exit>

0000010f <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	0f b7 00             	movzwl (%eax),%eax
 11b:	98                   	cwtl   
 11c:	83 f8 02             	cmp    $0x2,%eax
 11f:	74 1e                	je     13f <print_mode+0x30>
 121:	83 f8 03             	cmp    $0x3,%eax
 124:	74 2d                	je     153 <print_mode+0x44>
 126:	83 f8 01             	cmp    $0x1,%eax
 129:	75 3c                	jne    167 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 12b:	83 ec 08             	sub    $0x8,%esp
 12e:	68 8b 0b 00 00       	push   $0xb8b
 133:	6a 01                	push   $0x1
 135:	e8 75 06 00 00       	call   7af <printf>
 13a:	83 c4 10             	add    $0x10,%esp
 13d:	eb 3a                	jmp    179 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 13f:	83 ec 08             	sub    $0x8,%esp
 142:	68 8d 0b 00 00       	push   $0xb8d
 147:	6a 01                	push   $0x1
 149:	e8 61 06 00 00       	call   7af <printf>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	eb 26                	jmp    179 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 153:	83 ec 08             	sub    $0x8,%esp
 156:	68 8f 0b 00 00       	push   $0xb8f
 15b:	6a 01                	push   $0x1
 15d:	e8 4d 06 00 00       	call   7af <printf>
 162:	83 c4 10             	add    $0x10,%esp
 165:	eb 12                	jmp    179 <print_mode+0x6a>
    default: printf(1, "?");
 167:	83 ec 08             	sub    $0x8,%esp
 16a:	68 91 0b 00 00       	push   $0xb91
 16f:	6a 01                	push   $0x1
 171:	e8 39 06 00 00       	call   7af <printf>
 176:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 180:	83 e0 01             	and    $0x1,%eax
 183:	84 c0                	test   %al,%al
 185:	74 14                	je     19b <print_mode+0x8c>
    printf(1, "r");
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	68 93 0b 00 00       	push   $0xb93
 18f:	6a 01                	push   $0x1
 191:	e8 19 06 00 00       	call   7af <printf>
 196:	83 c4 10             	add    $0x10,%esp
 199:	eb 12                	jmp    1ad <print_mode+0x9e>
  else
    printf(1, "-");
 19b:	83 ec 08             	sub    $0x8,%esp
 19e:	68 8d 0b 00 00       	push   $0xb8d
 1a3:	6a 01                	push   $0x1
 1a5:	e8 05 06 00 00       	call   7af <printf>
 1aa:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1b4:	83 e0 80             	and    $0xffffff80,%eax
 1b7:	84 c0                	test   %al,%al
 1b9:	74 14                	je     1cf <print_mode+0xc0>
    printf(1, "w");
 1bb:	83 ec 08             	sub    $0x8,%esp
 1be:	68 95 0b 00 00       	push   $0xb95
 1c3:	6a 01                	push   $0x1
 1c5:	e8 e5 05 00 00       	call   7af <printf>
 1ca:	83 c4 10             	add    $0x10,%esp
 1cd:	eb 12                	jmp    1e1 <print_mode+0xd2>
  else
    printf(1, "-");
 1cf:	83 ec 08             	sub    $0x8,%esp
 1d2:	68 8d 0b 00 00       	push   $0xb8d
 1d7:	6a 01                	push   $0x1
 1d9:	e8 d1 05 00 00       	call   7af <printf>
 1de:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1e8:	c0 e8 06             	shr    $0x6,%al
 1eb:	83 e0 01             	and    $0x1,%eax
 1ee:	0f b6 d0             	movzbl %al,%edx
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 1f8:	d0 e8                	shr    %al
 1fa:	83 e0 01             	and    $0x1,%eax
 1fd:	0f b6 c0             	movzbl %al,%eax
 200:	21 d0                	and    %edx,%eax
 202:	85 c0                	test   %eax,%eax
 204:	74 14                	je     21a <print_mode+0x10b>
    printf(1, "S");
 206:	83 ec 08             	sub    $0x8,%esp
 209:	68 97 0b 00 00       	push   $0xb97
 20e:	6a 01                	push   $0x1
 210:	e8 9a 05 00 00       	call   7af <printf>
 215:	83 c4 10             	add    $0x10,%esp
 218:	eb 34                	jmp    24e <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 221:	83 e0 40             	and    $0x40,%eax
 224:	84 c0                	test   %al,%al
 226:	74 14                	je     23c <print_mode+0x12d>
    printf(1, "x");
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	68 99 0b 00 00       	push   $0xb99
 230:	6a 01                	push   $0x1
 232:	e8 78 05 00 00       	call   7af <printf>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	eb 12                	jmp    24e <print_mode+0x13f>
  else
    printf(1, "-");
 23c:	83 ec 08             	sub    $0x8,%esp
 23f:	68 8d 0b 00 00       	push   $0xb8d
 244:	6a 01                	push   $0x1
 246:	e8 64 05 00 00       	call   7af <printf>
 24b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 255:	83 e0 20             	and    $0x20,%eax
 258:	84 c0                	test   %al,%al
 25a:	74 14                	je     270 <print_mode+0x161>
    printf(1, "r");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 93 0b 00 00       	push   $0xb93
 264:	6a 01                	push   $0x1
 266:	e8 44 05 00 00       	call   7af <printf>
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	eb 12                	jmp    282 <print_mode+0x173>
  else
    printf(1, "-");
 270:	83 ec 08             	sub    $0x8,%esp
 273:	68 8d 0b 00 00       	push   $0xb8d
 278:	6a 01                	push   $0x1
 27a:	e8 30 05 00 00       	call   7af <printf>
 27f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 289:	83 e0 10             	and    $0x10,%eax
 28c:	84 c0                	test   %al,%al
 28e:	74 14                	je     2a4 <print_mode+0x195>
    printf(1, "w");
 290:	83 ec 08             	sub    $0x8,%esp
 293:	68 95 0b 00 00       	push   $0xb95
 298:	6a 01                	push   $0x1
 29a:	e8 10 05 00 00       	call   7af <printf>
 29f:	83 c4 10             	add    $0x10,%esp
 2a2:	eb 12                	jmp    2b6 <print_mode+0x1a7>
  else
    printf(1, "-");
 2a4:	83 ec 08             	sub    $0x8,%esp
 2a7:	68 8d 0b 00 00       	push   $0xb8d
 2ac:	6a 01                	push   $0x1
 2ae:	e8 fc 04 00 00       	call   7af <printf>
 2b3:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2bd:	83 e0 08             	and    $0x8,%eax
 2c0:	84 c0                	test   %al,%al
 2c2:	74 14                	je     2d8 <print_mode+0x1c9>
    printf(1, "x");
 2c4:	83 ec 08             	sub    $0x8,%esp
 2c7:	68 99 0b 00 00       	push   $0xb99
 2cc:	6a 01                	push   $0x1
 2ce:	e8 dc 04 00 00       	call   7af <printf>
 2d3:	83 c4 10             	add    $0x10,%esp
 2d6:	eb 12                	jmp    2ea <print_mode+0x1db>
  else
    printf(1, "-");
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	68 8d 0b 00 00       	push   $0xb8d
 2e0:	6a 01                	push   $0x1
 2e2:	e8 c8 04 00 00       	call   7af <printf>
 2e7:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2f1:	83 e0 04             	and    $0x4,%eax
 2f4:	84 c0                	test   %al,%al
 2f6:	74 14                	je     30c <print_mode+0x1fd>
    printf(1, "r");
 2f8:	83 ec 08             	sub    $0x8,%esp
 2fb:	68 93 0b 00 00       	push   $0xb93
 300:	6a 01                	push   $0x1
 302:	e8 a8 04 00 00       	call   7af <printf>
 307:	83 c4 10             	add    $0x10,%esp
 30a:	eb 12                	jmp    31e <print_mode+0x20f>
  else
    printf(1, "-");
 30c:	83 ec 08             	sub    $0x8,%esp
 30f:	68 8d 0b 00 00       	push   $0xb8d
 314:	6a 01                	push   $0x1
 316:	e8 94 04 00 00       	call   7af <printf>
 31b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 325:	83 e0 02             	and    $0x2,%eax
 328:	84 c0                	test   %al,%al
 32a:	74 14                	je     340 <print_mode+0x231>
    printf(1, "w");
 32c:	83 ec 08             	sub    $0x8,%esp
 32f:	68 95 0b 00 00       	push   $0xb95
 334:	6a 01                	push   $0x1
 336:	e8 74 04 00 00       	call   7af <printf>
 33b:	83 c4 10             	add    $0x10,%esp
 33e:	eb 12                	jmp    352 <print_mode+0x243>
  else
    printf(1, "-");
 340:	83 ec 08             	sub    $0x8,%esp
 343:	68 8d 0b 00 00       	push   $0xb8d
 348:	6a 01                	push   $0x1
 34a:	e8 60 04 00 00       	call   7af <printf>
 34f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 359:	83 e0 01             	and    $0x1,%eax
 35c:	84 c0                	test   %al,%al
 35e:	74 14                	je     374 <print_mode+0x265>
    printf(1, "x");
 360:	83 ec 08             	sub    $0x8,%esp
 363:	68 99 0b 00 00       	push   $0xb99
 368:	6a 01                	push   $0x1
 36a:	e8 40 04 00 00       	call   7af <printf>
 36f:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 372:	eb 13                	jmp    387 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 374:	83 ec 08             	sub    $0x8,%esp
 377:	68 8d 0b 00 00       	push   $0xb8d
 37c:	6a 01                	push   $0x1
 37e:	e8 2c 04 00 00       	call   7af <printf>
 383:	83 c4 10             	add    $0x10,%esp

  return;
 386:	90                   	nop
}
 387:	c9                   	leave  
 388:	c3                   	ret    

00000389 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	57                   	push   %edi
 38d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 38e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 391:	8b 55 10             	mov    0x10(%ebp),%edx
 394:	8b 45 0c             	mov    0xc(%ebp),%eax
 397:	89 cb                	mov    %ecx,%ebx
 399:	89 df                	mov    %ebx,%edi
 39b:	89 d1                	mov    %edx,%ecx
 39d:	fc                   	cld    
 39e:	f3 aa                	rep stos %al,%es:(%edi)
 3a0:	89 ca                	mov    %ecx,%edx
 3a2:	89 fb                	mov    %edi,%ebx
 3a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3a7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3aa:	90                   	nop
 3ab:	5b                   	pop    %ebx
 3ac:	5f                   	pop    %edi
 3ad:	5d                   	pop    %ebp
 3ae:	c3                   	ret    

000003af <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3bb:	90                   	nop
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	8d 50 01             	lea    0x1(%eax),%edx
 3c2:	89 55 08             	mov    %edx,0x8(%ebp)
 3c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 3c8:	8d 4a 01             	lea    0x1(%edx),%ecx
 3cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3ce:	0f b6 12             	movzbl (%edx),%edx
 3d1:	88 10                	mov    %dl,(%eax)
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	84 c0                	test   %al,%al
 3d8:	75 e2                	jne    3bc <strcpy+0xd>
    ;
  return os;
 3da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3dd:	c9                   	leave  
 3de:	c3                   	ret    

000003df <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3df:	55                   	push   %ebp
 3e0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3e2:	eb 08                	jmp    3ec <strcmp+0xd>
    p++, q++;
 3e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	84 c0                	test   %al,%al
 3f4:	74 10                	je     406 <strcmp+0x27>
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	0f b6 10             	movzbl (%eax),%edx
 3fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ff:	0f b6 00             	movzbl (%eax),%eax
 402:	38 c2                	cmp    %al,%dl
 404:	74 de                	je     3e4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	0f b6 d0             	movzbl %al,%edx
 40f:	8b 45 0c             	mov    0xc(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	0f b6 c0             	movzbl %al,%eax
 418:	29 c2                	sub    %eax,%edx
 41a:	89 d0                	mov    %edx,%eax
}
 41c:	5d                   	pop    %ebp
 41d:	c3                   	ret    

0000041e <strlen>:

uint
strlen(char *s)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 42b:	eb 04                	jmp    431 <strlen+0x13>
 42d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 431:	8b 55 fc             	mov    -0x4(%ebp),%edx
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	01 d0                	add    %edx,%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	84 c0                	test   %al,%al
 43e:	75 ed                	jne    42d <strlen+0xf>
    ;
  return n;
 440:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <memset>:

void*
memset(void *dst, int c, uint n)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 448:	8b 45 10             	mov    0x10(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	ff 75 0c             	pushl  0xc(%ebp)
 44f:	ff 75 08             	pushl  0x8(%ebp)
 452:	e8 32 ff ff ff       	call   389 <stosb>
 457:	83 c4 0c             	add    $0xc,%esp
  return dst;
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 45d:	c9                   	leave  
 45e:	c3                   	ret    

0000045f <strchr>:

char*
strchr(const char *s, char c)
{
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	83 ec 04             	sub    $0x4,%esp
 465:	8b 45 0c             	mov    0xc(%ebp),%eax
 468:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 46b:	eb 14                	jmp    481 <strchr+0x22>
    if(*s == c)
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	0f b6 00             	movzbl (%eax),%eax
 473:	3a 45 fc             	cmp    -0x4(%ebp),%al
 476:	75 05                	jne    47d <strchr+0x1e>
      return (char*)s;
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	eb 13                	jmp    490 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 47d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	84 c0                	test   %al,%al
 489:	75 e2                	jne    46d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 48b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <gets>:

char*
gets(char *buf, int max)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 498:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 49f:	eb 42                	jmp    4e3 <gets+0x51>
    cc = read(0, &c, 1);
 4a1:	83 ec 04             	sub    $0x4,%esp
 4a4:	6a 01                	push   $0x1
 4a6:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4a9:	50                   	push   %eax
 4aa:	6a 00                	push   $0x0
 4ac:	e8 47 01 00 00       	call   5f8 <read>
 4b1:	83 c4 10             	add    $0x10,%esp
 4b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bb:	7e 33                	jle    4f0 <gets+0x5e>
      break;
    buf[i++] = c;
 4bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c0:	8d 50 01             	lea    0x1(%eax),%edx
 4c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c6:	89 c2                	mov    %eax,%edx
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	01 c2                	add    %eax,%edx
 4cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4d1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4d7:	3c 0a                	cmp    $0xa,%al
 4d9:	74 16                	je     4f1 <gets+0x5f>
 4db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4df:	3c 0d                	cmp    $0xd,%al
 4e1:	74 0e                	je     4f1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e6:	83 c0 01             	add    $0x1,%eax
 4e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4ec:	7c b3                	jl     4a1 <gets+0xf>
 4ee:	eb 01                	jmp    4f1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4f0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	01 d0                	add    %edx,%eax
 4f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ff:	c9                   	leave  
 500:	c3                   	ret    

00000501 <stat>:

int
stat(char *n, struct stat *st)
{
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 507:	83 ec 08             	sub    $0x8,%esp
 50a:	6a 00                	push   $0x0
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 0c 01 00 00       	call   620 <open>
 514:	83 c4 10             	add    $0x10,%esp
 517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 51a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51e:	79 07                	jns    527 <stat+0x26>
    return -1;
 520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 525:	eb 25                	jmp    54c <stat+0x4b>
  r = fstat(fd, st);
 527:	83 ec 08             	sub    $0x8,%esp
 52a:	ff 75 0c             	pushl  0xc(%ebp)
 52d:	ff 75 f4             	pushl  -0xc(%ebp)
 530:	e8 03 01 00 00       	call   638 <fstat>
 535:	83 c4 10             	add    $0x10,%esp
 538:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 53b:	83 ec 0c             	sub    $0xc,%esp
 53e:	ff 75 f4             	pushl  -0xc(%ebp)
 541:	e8 c2 00 00 00       	call   608 <close>
 546:	83 c4 10             	add    $0x10,%esp
  return r;
 549:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 54c:	c9                   	leave  
 54d:	c3                   	ret    

0000054e <atoi>:

int
atoi(const char *s)
{
 54e:	55                   	push   %ebp
 54f:	89 e5                	mov    %esp,%ebp
 551:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 55b:	eb 25                	jmp    582 <atoi+0x34>
    n = n*10 + *s++ - '0';
 55d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 560:	89 d0                	mov    %edx,%eax
 562:	c1 e0 02             	shl    $0x2,%eax
 565:	01 d0                	add    %edx,%eax
 567:	01 c0                	add    %eax,%eax
 569:	89 c1                	mov    %eax,%ecx
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	8d 50 01             	lea    0x1(%eax),%edx
 571:	89 55 08             	mov    %edx,0x8(%ebp)
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	0f be c0             	movsbl %al,%eax
 57a:	01 c8                	add    %ecx,%eax
 57c:	83 e8 30             	sub    $0x30,%eax
 57f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	3c 2f                	cmp    $0x2f,%al
 58a:	7e 0a                	jle    596 <atoi+0x48>
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	0f b6 00             	movzbl (%eax),%eax
 592:	3c 39                	cmp    $0x39,%al
 594:	7e c7                	jle    55d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 596:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 599:	c9                   	leave  
 59a:	c3                   	ret    

0000059b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 59b:	55                   	push   %ebp
 59c:	89 e5                	mov    %esp,%ebp
 59e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5ad:	eb 17                	jmp    5c6 <memmove+0x2b>
    *dst++ = *src++;
 5af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b2:	8d 50 01             	lea    0x1(%eax),%edx
 5b5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5bb:	8d 4a 01             	lea    0x1(%edx),%ecx
 5be:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5c1:	0f b6 12             	movzbl (%edx),%edx
 5c4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5c6:	8b 45 10             	mov    0x10(%ebp),%eax
 5c9:	8d 50 ff             	lea    -0x1(%eax),%edx
 5cc:	89 55 10             	mov    %edx,0x10(%ebp)
 5cf:	85 c0                	test   %eax,%eax
 5d1:	7f dc                	jg     5af <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5d6:	c9                   	leave  
 5d7:	c3                   	ret    

000005d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5d8:	b8 01 00 00 00       	mov    $0x1,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <exit>:
SYSCALL(exit)
 5e0:	b8 02 00 00 00       	mov    $0x2,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <wait>:
SYSCALL(wait)
 5e8:	b8 03 00 00 00       	mov    $0x3,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <pipe>:
SYSCALL(pipe)
 5f0:	b8 04 00 00 00       	mov    $0x4,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <read>:
SYSCALL(read)
 5f8:	b8 05 00 00 00       	mov    $0x5,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <write>:
SYSCALL(write)
 600:	b8 10 00 00 00       	mov    $0x10,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <close>:
SYSCALL(close)
 608:	b8 15 00 00 00       	mov    $0x15,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <kill>:
SYSCALL(kill)
 610:	b8 06 00 00 00       	mov    $0x6,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <exec>:
SYSCALL(exec)
 618:	b8 07 00 00 00       	mov    $0x7,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <open>:
SYSCALL(open)
 620:	b8 0f 00 00 00       	mov    $0xf,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <mknod>:
SYSCALL(mknod)
 628:	b8 11 00 00 00       	mov    $0x11,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <unlink>:
SYSCALL(unlink)
 630:	b8 12 00 00 00       	mov    $0x12,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <fstat>:
SYSCALL(fstat)
 638:	b8 08 00 00 00       	mov    $0x8,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <link>:
SYSCALL(link)
 640:	b8 13 00 00 00       	mov    $0x13,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <mkdir>:
SYSCALL(mkdir)
 648:	b8 14 00 00 00       	mov    $0x14,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <chdir>:
SYSCALL(chdir)
 650:	b8 09 00 00 00       	mov    $0x9,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <dup>:
SYSCALL(dup)
 658:	b8 0a 00 00 00       	mov    $0xa,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <getpid>:
SYSCALL(getpid)
 660:	b8 0b 00 00 00       	mov    $0xb,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <sbrk>:
SYSCALL(sbrk)
 668:	b8 0c 00 00 00       	mov    $0xc,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <sleep>:
SYSCALL(sleep)
 670:	b8 0d 00 00 00       	mov    $0xd,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <uptime>:
SYSCALL(uptime)
 678:	b8 0e 00 00 00       	mov    $0xe,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <halt>:
SYSCALL(halt)
 680:	b8 16 00 00 00       	mov    $0x16,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <date>:
//Student Implementations 
SYSCALL(date)
 688:	b8 17 00 00 00       	mov    $0x17,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <getuid>:

SYSCALL(getuid)
 690:	b8 18 00 00 00       	mov    $0x18,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <getgid>:
SYSCALL(getgid)
 698:	b8 19 00 00 00       	mov    $0x19,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <getppid>:
SYSCALL(getppid)
 6a0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <setuid>:

SYSCALL(setuid)
 6a8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <setgid>:
SYSCALL(setgid)
 6b0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <getprocs>:
SYSCALL(getprocs)
 6b8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <chown>:

SYSCALL(chown)
 6c0:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <chgrp>:
SYSCALL(chgrp)
 6c8:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <chmod>:
SYSCALL(chmod)
 6d0:	b8 20 00 00 00       	mov    $0x20,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	83 ec 18             	sub    $0x18,%esp
 6de:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6e4:	83 ec 04             	sub    $0x4,%esp
 6e7:	6a 01                	push   $0x1
 6e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6ec:	50                   	push   %eax
 6ed:	ff 75 08             	pushl  0x8(%ebp)
 6f0:	e8 0b ff ff ff       	call   600 <write>
 6f5:	83 c4 10             	add    $0x10,%esp
}
 6f8:	90                   	nop
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	53                   	push   %ebx
 6ff:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 702:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 709:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 70d:	74 17                	je     726 <printint+0x2b>
 70f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 713:	79 11                	jns    726 <printint+0x2b>
    neg = 1;
 715:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 71c:	8b 45 0c             	mov    0xc(%ebp),%eax
 71f:	f7 d8                	neg    %eax
 721:	89 45 ec             	mov    %eax,-0x14(%ebp)
 724:	eb 06                	jmp    72c <printint+0x31>
  } else {
    x = xx;
 726:	8b 45 0c             	mov    0xc(%ebp),%eax
 729:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 72c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 733:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 736:	8d 41 01             	lea    0x1(%ecx),%eax
 739:	89 45 f4             	mov    %eax,-0xc(%ebp)
 73c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 73f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 742:	ba 00 00 00 00       	mov    $0x0,%edx
 747:	f7 f3                	div    %ebx
 749:	89 d0                	mov    %edx,%eax
 74b:	0f b6 80 30 0e 00 00 	movzbl 0xe30(%eax),%eax
 752:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 756:	8b 5d 10             	mov    0x10(%ebp),%ebx
 759:	8b 45 ec             	mov    -0x14(%ebp),%eax
 75c:	ba 00 00 00 00       	mov    $0x0,%edx
 761:	f7 f3                	div    %ebx
 763:	89 45 ec             	mov    %eax,-0x14(%ebp)
 766:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 76a:	75 c7                	jne    733 <printint+0x38>
  if(neg)
 76c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 770:	74 2d                	je     79f <printint+0xa4>
    buf[i++] = '-';
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	8d 50 01             	lea    0x1(%eax),%edx
 778:	89 55 f4             	mov    %edx,-0xc(%ebp)
 77b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 780:	eb 1d                	jmp    79f <printint+0xa4>
    putc(fd, buf[i]);
 782:	8d 55 dc             	lea    -0x24(%ebp),%edx
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	01 d0                	add    %edx,%eax
 78a:	0f b6 00             	movzbl (%eax),%eax
 78d:	0f be c0             	movsbl %al,%eax
 790:	83 ec 08             	sub    $0x8,%esp
 793:	50                   	push   %eax
 794:	ff 75 08             	pushl  0x8(%ebp)
 797:	e8 3c ff ff ff       	call   6d8 <putc>
 79c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 79f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a7:	79 d9                	jns    782 <printint+0x87>
    putc(fd, buf[i]);
}
 7a9:	90                   	nop
 7aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7bc:	8d 45 0c             	lea    0xc(%ebp),%eax
 7bf:	83 c0 04             	add    $0x4,%eax
 7c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7cc:	e9 59 01 00 00       	jmp    92a <printf+0x17b>
    c = fmt[i] & 0xff;
 7d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	01 d0                	add    %edx,%eax
 7d9:	0f b6 00             	movzbl (%eax),%eax
 7dc:	0f be c0             	movsbl %al,%eax
 7df:	25 ff 00 00 00       	and    $0xff,%eax
 7e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7eb:	75 2c                	jne    819 <printf+0x6a>
      if(c == '%'){
 7ed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7f1:	75 0c                	jne    7ff <printf+0x50>
        state = '%';
 7f3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7fa:	e9 27 01 00 00       	jmp    926 <printf+0x177>
      } else {
        putc(fd, c);
 7ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 802:	0f be c0             	movsbl %al,%eax
 805:	83 ec 08             	sub    $0x8,%esp
 808:	50                   	push   %eax
 809:	ff 75 08             	pushl  0x8(%ebp)
 80c:	e8 c7 fe ff ff       	call   6d8 <putc>
 811:	83 c4 10             	add    $0x10,%esp
 814:	e9 0d 01 00 00       	jmp    926 <printf+0x177>
      }
    } else if(state == '%'){
 819:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 81d:	0f 85 03 01 00 00    	jne    926 <printf+0x177>
      if(c == 'd'){
 823:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 827:	75 1e                	jne    847 <printf+0x98>
        printint(fd, *ap, 10, 1);
 829:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	6a 01                	push   $0x1
 830:	6a 0a                	push   $0xa
 832:	50                   	push   %eax
 833:	ff 75 08             	pushl  0x8(%ebp)
 836:	e8 c0 fe ff ff       	call   6fb <printint>
 83b:	83 c4 10             	add    $0x10,%esp
        ap++;
 83e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 842:	e9 d8 00 00 00       	jmp    91f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 847:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 84b:	74 06                	je     853 <printf+0xa4>
 84d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 851:	75 1e                	jne    871 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 853:	8b 45 e8             	mov    -0x18(%ebp),%eax
 856:	8b 00                	mov    (%eax),%eax
 858:	6a 00                	push   $0x0
 85a:	6a 10                	push   $0x10
 85c:	50                   	push   %eax
 85d:	ff 75 08             	pushl  0x8(%ebp)
 860:	e8 96 fe ff ff       	call   6fb <printint>
 865:	83 c4 10             	add    $0x10,%esp
        ap++;
 868:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 86c:	e9 ae 00 00 00       	jmp    91f <printf+0x170>
      } else if(c == 's'){
 871:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 875:	75 43                	jne    8ba <printf+0x10b>
        s = (char*)*ap;
 877:	8b 45 e8             	mov    -0x18(%ebp),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 87f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 887:	75 25                	jne    8ae <printf+0xff>
          s = "(null)";
 889:	c7 45 f4 9b 0b 00 00 	movl   $0xb9b,-0xc(%ebp)
        while(*s != 0){
 890:	eb 1c                	jmp    8ae <printf+0xff>
          putc(fd, *s);
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	0f b6 00             	movzbl (%eax),%eax
 898:	0f be c0             	movsbl %al,%eax
 89b:	83 ec 08             	sub    $0x8,%esp
 89e:	50                   	push   %eax
 89f:	ff 75 08             	pushl  0x8(%ebp)
 8a2:	e8 31 fe ff ff       	call   6d8 <putc>
 8a7:	83 c4 10             	add    $0x10,%esp
          s++;
 8aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	0f b6 00             	movzbl (%eax),%eax
 8b4:	84 c0                	test   %al,%al
 8b6:	75 da                	jne    892 <printf+0xe3>
 8b8:	eb 65                	jmp    91f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8ba:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8be:	75 1d                	jne    8dd <printf+0x12e>
        putc(fd, *ap);
 8c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8c3:	8b 00                	mov    (%eax),%eax
 8c5:	0f be c0             	movsbl %al,%eax
 8c8:	83 ec 08             	sub    $0x8,%esp
 8cb:	50                   	push   %eax
 8cc:	ff 75 08             	pushl  0x8(%ebp)
 8cf:	e8 04 fe ff ff       	call   6d8 <putc>
 8d4:	83 c4 10             	add    $0x10,%esp
        ap++;
 8d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8db:	eb 42                	jmp    91f <printf+0x170>
      } else if(c == '%'){
 8dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8e1:	75 17                	jne    8fa <printf+0x14b>
        putc(fd, c);
 8e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e6:	0f be c0             	movsbl %al,%eax
 8e9:	83 ec 08             	sub    $0x8,%esp
 8ec:	50                   	push   %eax
 8ed:	ff 75 08             	pushl  0x8(%ebp)
 8f0:	e8 e3 fd ff ff       	call   6d8 <putc>
 8f5:	83 c4 10             	add    $0x10,%esp
 8f8:	eb 25                	jmp    91f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8fa:	83 ec 08             	sub    $0x8,%esp
 8fd:	6a 25                	push   $0x25
 8ff:	ff 75 08             	pushl  0x8(%ebp)
 902:	e8 d1 fd ff ff       	call   6d8 <putc>
 907:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 90a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 90d:	0f be c0             	movsbl %al,%eax
 910:	83 ec 08             	sub    $0x8,%esp
 913:	50                   	push   %eax
 914:	ff 75 08             	pushl  0x8(%ebp)
 917:	e8 bc fd ff ff       	call   6d8 <putc>
 91c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 91f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 926:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 92a:	8b 55 0c             	mov    0xc(%ebp),%edx
 92d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 930:	01 d0                	add    %edx,%eax
 932:	0f b6 00             	movzbl (%eax),%eax
 935:	84 c0                	test   %al,%al
 937:	0f 85 94 fe ff ff    	jne    7d1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 93d:	90                   	nop
 93e:	c9                   	leave  
 93f:	c3                   	ret    

00000940 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 946:	8b 45 08             	mov    0x8(%ebp),%eax
 949:	83 e8 08             	sub    $0x8,%eax
 94c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94f:	a1 68 0e 00 00       	mov    0xe68,%eax
 954:	89 45 fc             	mov    %eax,-0x4(%ebp)
 957:	eb 24                	jmp    97d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	8b 00                	mov    (%eax),%eax
 95e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 961:	77 12                	ja     975 <free+0x35>
 963:	8b 45 f8             	mov    -0x8(%ebp),%eax
 966:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 969:	77 24                	ja     98f <free+0x4f>
 96b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96e:	8b 00                	mov    (%eax),%eax
 970:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 973:	77 1a                	ja     98f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	8b 00                	mov    (%eax),%eax
 97a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 97d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 980:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 983:	76 d4                	jbe    959 <free+0x19>
 985:	8b 45 fc             	mov    -0x4(%ebp),%eax
 988:	8b 00                	mov    (%eax),%eax
 98a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 98d:	76 ca                	jbe    959 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 98f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 99c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99f:	01 c2                	add    %eax,%edx
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	8b 00                	mov    (%eax),%eax
 9a6:	39 c2                	cmp    %eax,%edx
 9a8:	75 24                	jne    9ce <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ad:	8b 50 04             	mov    0x4(%eax),%edx
 9b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b3:	8b 00                	mov    (%eax),%eax
 9b5:	8b 40 04             	mov    0x4(%eax),%eax
 9b8:	01 c2                	add    %eax,%edx
 9ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c3:	8b 00                	mov    (%eax),%eax
 9c5:	8b 10                	mov    (%eax),%edx
 9c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ca:	89 10                	mov    %edx,(%eax)
 9cc:	eb 0a                	jmp    9d8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d1:	8b 10                	mov    (%eax),%edx
 9d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9db:	8b 40 04             	mov    0x4(%eax),%eax
 9de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e8:	01 d0                	add    %edx,%eax
 9ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ed:	75 20                	jne    a0f <free+0xcf>
    p->s.size += bp->s.size;
 9ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f2:	8b 50 04             	mov    0x4(%eax),%edx
 9f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f8:	8b 40 04             	mov    0x4(%eax),%eax
 9fb:	01 c2                	add    %eax,%edx
 9fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a00:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a03:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a06:	8b 10                	mov    (%eax),%edx
 a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0b:	89 10                	mov    %edx,(%eax)
 a0d:	eb 08                	jmp    a17 <free+0xd7>
  } else
    p->s.ptr = bp;
 a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a12:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a15:	89 10                	mov    %edx,(%eax)
  freep = p;
 a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1a:	a3 68 0e 00 00       	mov    %eax,0xe68
}
 a1f:	90                   	nop
 a20:	c9                   	leave  
 a21:	c3                   	ret    

00000a22 <morecore>:

static Header*
morecore(uint nu)
{
 a22:	55                   	push   %ebp
 a23:	89 e5                	mov    %esp,%ebp
 a25:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a28:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a2f:	77 07                	ja     a38 <morecore+0x16>
    nu = 4096;
 a31:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a38:	8b 45 08             	mov    0x8(%ebp),%eax
 a3b:	c1 e0 03             	shl    $0x3,%eax
 a3e:	83 ec 0c             	sub    $0xc,%esp
 a41:	50                   	push   %eax
 a42:	e8 21 fc ff ff       	call   668 <sbrk>
 a47:	83 c4 10             	add    $0x10,%esp
 a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a4d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a51:	75 07                	jne    a5a <morecore+0x38>
    return 0;
 a53:	b8 00 00 00 00       	mov    $0x0,%eax
 a58:	eb 26                	jmp    a80 <morecore+0x5e>
  hp = (Header*)p;
 a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a63:	8b 55 08             	mov    0x8(%ebp),%edx
 a66:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6c:	83 c0 08             	add    $0x8,%eax
 a6f:	83 ec 0c             	sub    $0xc,%esp
 a72:	50                   	push   %eax
 a73:	e8 c8 fe ff ff       	call   940 <free>
 a78:	83 c4 10             	add    $0x10,%esp
  return freep;
 a7b:	a1 68 0e 00 00       	mov    0xe68,%eax
}
 a80:	c9                   	leave  
 a81:	c3                   	ret    

00000a82 <malloc>:

void*
malloc(uint nbytes)
{
 a82:	55                   	push   %ebp
 a83:	89 e5                	mov    %esp,%ebp
 a85:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a88:	8b 45 08             	mov    0x8(%ebp),%eax
 a8b:	83 c0 07             	add    $0x7,%eax
 a8e:	c1 e8 03             	shr    $0x3,%eax
 a91:	83 c0 01             	add    $0x1,%eax
 a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a97:	a1 68 0e 00 00       	mov    0xe68,%eax
 a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 aa3:	75 23                	jne    ac8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 aa5:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
 aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaf:	a3 68 0e 00 00       	mov    %eax,0xe68
 ab4:	a1 68 0e 00 00       	mov    0xe68,%eax
 ab9:	a3 60 0e 00 00       	mov    %eax,0xe60
    base.s.size = 0;
 abe:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 ac5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acb:	8b 00                	mov    (%eax),%eax
 acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad3:	8b 40 04             	mov    0x4(%eax),%eax
 ad6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ad9:	72 4d                	jb     b28 <malloc+0xa6>
      if(p->s.size == nunits)
 adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ade:	8b 40 04             	mov    0x4(%eax),%eax
 ae1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ae4:	75 0c                	jne    af2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae9:	8b 10                	mov    (%eax),%edx
 aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aee:	89 10                	mov    %edx,(%eax)
 af0:	eb 26                	jmp    b18 <malloc+0x96>
      else {
        p->s.size -= nunits;
 af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af5:	8b 40 04             	mov    0x4(%eax),%eax
 af8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 afb:	89 c2                	mov    %eax,%edx
 afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b00:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b06:	8b 40 04             	mov    0x4(%eax),%eax
 b09:	c1 e0 03             	shl    $0x3,%eax
 b0c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b12:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b15:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b1b:	a3 68 0e 00 00       	mov    %eax,0xe68
      return (void*)(p + 1);
 b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b23:	83 c0 08             	add    $0x8,%eax
 b26:	eb 3b                	jmp    b63 <malloc+0xe1>
    }
    if(p == freep)
 b28:	a1 68 0e 00 00       	mov    0xe68,%eax
 b2d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b30:	75 1e                	jne    b50 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b32:	83 ec 0c             	sub    $0xc,%esp
 b35:	ff 75 ec             	pushl  -0x14(%ebp)
 b38:	e8 e5 fe ff ff       	call   a22 <morecore>
 b3d:	83 c4 10             	add    $0x10,%esp
 b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b47:	75 07                	jne    b50 <malloc+0xce>
        return 0;
 b49:	b8 00 00 00 00       	mov    $0x0,%eax
 b4e:	eb 13                	jmp    b63 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b59:	8b 00                	mov    (%eax),%eax
 b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b5e:	e9 6d ff ff ff       	jmp    ad0 <malloc+0x4e>
}
 b63:	c9                   	leave  
 b64:	c3                   	ret    
