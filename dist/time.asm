
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

//This is a SHELL PROGRAM that should only
//be used to EXECUTE SYSTEM CALLS

int main (int argc, char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 1c             	sub    $0x1c,%esp
  13:	89 cb                	mov    %ecx,%ebx


  if( argc < 2) 
  15:	83 3b 01             	cmpl   $0x1,(%ebx)
  18:	7f 12                	jg     2c <main+0x2c>
      printf(1, "Usage: Report runtime of programs provided as arguments, no arguments provided\n");
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 34 0b 00 00       	push   $0xb34
  22:	6a 01                	push   $0x1
  24:	e8 52 07 00 00       	call   77b <printf>
  29:	83 c4 10             	add    $0x10,%esp

  
  uint start = (uint)uptime();
  2c:	e8 13 06 00 00       	call   644 <uptime>
  31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint finish = 0;
  34:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  uint pid = fork();
  3b:	e8 64 05 00 00       	call   5a4 <fork>
  40:	89 45 dc             	mov    %eax,-0x24(%ebp)

  if(pid == 0 ){
  43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  47:	75 36                	jne    7f <main+0x7f>

      if(exec(argv[1], argv +1)){
  49:	8b 43 04             	mov    0x4(%ebx),%eax
  4c:	8d 50 04             	lea    0x4(%eax),%edx
  4f:	8b 43 04             	mov    0x4(%ebx),%eax
  52:	83 c0 04             	add    $0x4,%eax
  55:	8b 00                	mov    (%eax),%eax
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	52                   	push   %edx
  5b:	50                   	push   %eax
  5c:	e8 83 05 00 00       	call   5e4 <exec>
  61:	83 c4 10             	add    $0x10,%esp
  64:	85 c0                	test   %eax,%eax
  66:	74 1c                	je     84 <main+0x84>
          printf(1, "Exec Failed");
  68:	83 ec 08             	sub    $0x8,%esp
  6b:	68 84 0b 00 00       	push   $0xb84
  70:	6a 01                	push   $0x1
  72:	e8 04 07 00 00       	call   77b <printf>
  77:	83 c4 10             	add    $0x10,%esp
          exit();
  7a:	e8 2d 05 00 00       	call   5ac <exit>
      }
  }
  else{
    wait();
  7f:	e8 30 05 00 00       	call   5b4 <wait>
  }

    finish  = (uint)uptime();
  84:	e8 bb 05 00 00       	call   644 <uptime>
  89:	89 45 e0             	mov    %eax,-0x20(%ebp)
    printf(1, "%s took %d.%d time to run\n", argv[1], (finish - start) / 100, (finish - start) % 100);
  8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  92:	89 c6                	mov    %eax,%esi
  94:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  99:	89 f0                	mov    %esi,%eax
  9b:	f7 e2                	mul    %edx
  9d:	89 d1                	mov    %edx,%ecx
  9f:	c1 e9 05             	shr    $0x5,%ecx
  a2:	6b c1 64             	imul   $0x64,%ecx,%eax
  a5:	29 c6                	sub    %eax,%esi
  a7:	89 f1                	mov    %esi,%ecx
  a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  ac:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  af:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  b4:	f7 e2                	mul    %edx
  b6:	c1 ea 05             	shr    $0x5,%edx
  b9:	8b 43 04             	mov    0x4(%ebx),%eax
  bc:	83 c0 04             	add    $0x4,%eax
  bf:	8b 00                	mov    (%eax),%eax
  c1:	83 ec 0c             	sub    $0xc,%esp
  c4:	51                   	push   %ecx
  c5:	52                   	push   %edx
  c6:	50                   	push   %eax
  c7:	68 90 0b 00 00       	push   $0xb90
  cc:	6a 01                	push   $0x1
  ce:	e8 a8 06 00 00       	call   77b <printf>
  d3:	83 c4 20             	add    $0x20,%esp
  
  exit();
  d6:	e8 d1 04 00 00       	call   5ac <exit>

000000db <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b7 00             	movzwl (%eax),%eax
  e7:	98                   	cwtl   
  e8:	83 f8 02             	cmp    $0x2,%eax
  eb:	74 1e                	je     10b <print_mode+0x30>
  ed:	83 f8 03             	cmp    $0x3,%eax
  f0:	74 2d                	je     11f <print_mode+0x44>
  f2:	83 f8 01             	cmp    $0x1,%eax
  f5:	75 3c                	jne    133 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 ab 0b 00 00       	push   $0xbab
  ff:	6a 01                	push   $0x1
 101:	e8 75 06 00 00       	call   77b <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	eb 3a                	jmp    145 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	68 ad 0b 00 00       	push   $0xbad
 113:	6a 01                	push   $0x1
 115:	e8 61 06 00 00       	call   77b <printf>
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	eb 26                	jmp    145 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 11f:	83 ec 08             	sub    $0x8,%esp
 122:	68 af 0b 00 00       	push   $0xbaf
 127:	6a 01                	push   $0x1
 129:	e8 4d 06 00 00       	call   77b <printf>
 12e:	83 c4 10             	add    $0x10,%esp
 131:	eb 12                	jmp    145 <print_mode+0x6a>
    default: printf(1, "?");
 133:	83 ec 08             	sub    $0x8,%esp
 136:	68 b1 0b 00 00       	push   $0xbb1
 13b:	6a 01                	push   $0x1
 13d:	e8 39 06 00 00       	call   77b <printf>
 142:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 14c:	83 e0 01             	and    $0x1,%eax
 14f:	84 c0                	test   %al,%al
 151:	74 14                	je     167 <print_mode+0x8c>
    printf(1, "r");
 153:	83 ec 08             	sub    $0x8,%esp
 156:	68 b3 0b 00 00       	push   $0xbb3
 15b:	6a 01                	push   $0x1
 15d:	e8 19 06 00 00       	call   77b <printf>
 162:	83 c4 10             	add    $0x10,%esp
 165:	eb 12                	jmp    179 <print_mode+0x9e>
  else
    printf(1, "-");
 167:	83 ec 08             	sub    $0x8,%esp
 16a:	68 ad 0b 00 00       	push   $0xbad
 16f:	6a 01                	push   $0x1
 171:	e8 05 06 00 00       	call   77b <printf>
 176:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 180:	83 e0 80             	and    $0xffffff80,%eax
 183:	84 c0                	test   %al,%al
 185:	74 14                	je     19b <print_mode+0xc0>
    printf(1, "w");
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	68 b5 0b 00 00       	push   $0xbb5
 18f:	6a 01                	push   $0x1
 191:	e8 e5 05 00 00       	call   77b <printf>
 196:	83 c4 10             	add    $0x10,%esp
 199:	eb 12                	jmp    1ad <print_mode+0xd2>
  else
    printf(1, "-");
 19b:	83 ec 08             	sub    $0x8,%esp
 19e:	68 ad 0b 00 00       	push   $0xbad
 1a3:	6a 01                	push   $0x1
 1a5:	e8 d1 05 00 00       	call   77b <printf>
 1aa:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1b4:	c0 e8 06             	shr    $0x6,%al
 1b7:	83 e0 01             	and    $0x1,%eax
 1ba:	0f b6 d0             	movzbl %al,%edx
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 1c4:	d0 e8                	shr    %al
 1c6:	83 e0 01             	and    $0x1,%eax
 1c9:	0f b6 c0             	movzbl %al,%eax
 1cc:	21 d0                	and    %edx,%eax
 1ce:	85 c0                	test   %eax,%eax
 1d0:	74 14                	je     1e6 <print_mode+0x10b>
    printf(1, "S");
 1d2:	83 ec 08             	sub    $0x8,%esp
 1d5:	68 b7 0b 00 00       	push   $0xbb7
 1da:	6a 01                	push   $0x1
 1dc:	e8 9a 05 00 00       	call   77b <printf>
 1e1:	83 c4 10             	add    $0x10,%esp
 1e4:	eb 34                	jmp    21a <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1ed:	83 e0 40             	and    $0x40,%eax
 1f0:	84 c0                	test   %al,%al
 1f2:	74 14                	je     208 <print_mode+0x12d>
    printf(1, "x");
 1f4:	83 ec 08             	sub    $0x8,%esp
 1f7:	68 b9 0b 00 00       	push   $0xbb9
 1fc:	6a 01                	push   $0x1
 1fe:	e8 78 05 00 00       	call   77b <printf>
 203:	83 c4 10             	add    $0x10,%esp
 206:	eb 12                	jmp    21a <print_mode+0x13f>
  else
    printf(1, "-");
 208:	83 ec 08             	sub    $0x8,%esp
 20b:	68 ad 0b 00 00       	push   $0xbad
 210:	6a 01                	push   $0x1
 212:	e8 64 05 00 00       	call   77b <printf>
 217:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 221:	83 e0 20             	and    $0x20,%eax
 224:	84 c0                	test   %al,%al
 226:	74 14                	je     23c <print_mode+0x161>
    printf(1, "r");
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	68 b3 0b 00 00       	push   $0xbb3
 230:	6a 01                	push   $0x1
 232:	e8 44 05 00 00       	call   77b <printf>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	eb 12                	jmp    24e <print_mode+0x173>
  else
    printf(1, "-");
 23c:	83 ec 08             	sub    $0x8,%esp
 23f:	68 ad 0b 00 00       	push   $0xbad
 244:	6a 01                	push   $0x1
 246:	e8 30 05 00 00       	call   77b <printf>
 24b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 255:	83 e0 10             	and    $0x10,%eax
 258:	84 c0                	test   %al,%al
 25a:	74 14                	je     270 <print_mode+0x195>
    printf(1, "w");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 b5 0b 00 00       	push   $0xbb5
 264:	6a 01                	push   $0x1
 266:	e8 10 05 00 00       	call   77b <printf>
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	eb 12                	jmp    282 <print_mode+0x1a7>
  else
    printf(1, "-");
 270:	83 ec 08             	sub    $0x8,%esp
 273:	68 ad 0b 00 00       	push   $0xbad
 278:	6a 01                	push   $0x1
 27a:	e8 fc 04 00 00       	call   77b <printf>
 27f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 289:	83 e0 08             	and    $0x8,%eax
 28c:	84 c0                	test   %al,%al
 28e:	74 14                	je     2a4 <print_mode+0x1c9>
    printf(1, "x");
 290:	83 ec 08             	sub    $0x8,%esp
 293:	68 b9 0b 00 00       	push   $0xbb9
 298:	6a 01                	push   $0x1
 29a:	e8 dc 04 00 00       	call   77b <printf>
 29f:	83 c4 10             	add    $0x10,%esp
 2a2:	eb 12                	jmp    2b6 <print_mode+0x1db>
  else
    printf(1, "-");
 2a4:	83 ec 08             	sub    $0x8,%esp
 2a7:	68 ad 0b 00 00       	push   $0xbad
 2ac:	6a 01                	push   $0x1
 2ae:	e8 c8 04 00 00       	call   77b <printf>
 2b3:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2bd:	83 e0 04             	and    $0x4,%eax
 2c0:	84 c0                	test   %al,%al
 2c2:	74 14                	je     2d8 <print_mode+0x1fd>
    printf(1, "r");
 2c4:	83 ec 08             	sub    $0x8,%esp
 2c7:	68 b3 0b 00 00       	push   $0xbb3
 2cc:	6a 01                	push   $0x1
 2ce:	e8 a8 04 00 00       	call   77b <printf>
 2d3:	83 c4 10             	add    $0x10,%esp
 2d6:	eb 12                	jmp    2ea <print_mode+0x20f>
  else
    printf(1, "-");
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	68 ad 0b 00 00       	push   $0xbad
 2e0:	6a 01                	push   $0x1
 2e2:	e8 94 04 00 00       	call   77b <printf>
 2e7:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2f1:	83 e0 02             	and    $0x2,%eax
 2f4:	84 c0                	test   %al,%al
 2f6:	74 14                	je     30c <print_mode+0x231>
    printf(1, "w");
 2f8:	83 ec 08             	sub    $0x8,%esp
 2fb:	68 b5 0b 00 00       	push   $0xbb5
 300:	6a 01                	push   $0x1
 302:	e8 74 04 00 00       	call   77b <printf>
 307:	83 c4 10             	add    $0x10,%esp
 30a:	eb 12                	jmp    31e <print_mode+0x243>
  else
    printf(1, "-");
 30c:	83 ec 08             	sub    $0x8,%esp
 30f:	68 ad 0b 00 00       	push   $0xbad
 314:	6a 01                	push   $0x1
 316:	e8 60 04 00 00       	call   77b <printf>
 31b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 325:	83 e0 01             	and    $0x1,%eax
 328:	84 c0                	test   %al,%al
 32a:	74 14                	je     340 <print_mode+0x265>
    printf(1, "x");
 32c:	83 ec 08             	sub    $0x8,%esp
 32f:	68 b9 0b 00 00       	push   $0xbb9
 334:	6a 01                	push   $0x1
 336:	e8 40 04 00 00       	call   77b <printf>
 33b:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 33e:	eb 13                	jmp    353 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 340:	83 ec 08             	sub    $0x8,%esp
 343:	68 ad 0b 00 00       	push   $0xbad
 348:	6a 01                	push   $0x1
 34a:	e8 2c 04 00 00       	call   77b <printf>
 34f:	83 c4 10             	add    $0x10,%esp

  return;
 352:	90                   	nop
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	57                   	push   %edi
 359:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 35a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35d:	8b 55 10             	mov    0x10(%ebp),%edx
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	89 cb                	mov    %ecx,%ebx
 365:	89 df                	mov    %ebx,%edi
 367:	89 d1                	mov    %edx,%ecx
 369:	fc                   	cld    
 36a:	f3 aa                	rep stos %al,%es:(%edi)
 36c:	89 ca                	mov    %ecx,%edx
 36e:	89 fb                	mov    %edi,%ebx
 370:	89 5d 08             	mov    %ebx,0x8(%ebp)
 373:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 376:	90                   	nop
 377:	5b                   	pop    %ebx
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    

0000037b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 387:	90                   	nop
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	8d 50 01             	lea    0x1(%eax),%edx
 38e:	89 55 08             	mov    %edx,0x8(%ebp)
 391:	8b 55 0c             	mov    0xc(%ebp),%edx
 394:	8d 4a 01             	lea    0x1(%edx),%ecx
 397:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 39a:	0f b6 12             	movzbl (%edx),%edx
 39d:	88 10                	mov    %dl,(%eax)
 39f:	0f b6 00             	movzbl (%eax),%eax
 3a2:	84 c0                	test   %al,%al
 3a4:	75 e2                	jne    388 <strcpy+0xd>
    ;
  return os;
 3a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a9:	c9                   	leave  
 3aa:	c3                   	ret    

000003ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3ae:	eb 08                	jmp    3b8 <strcmp+0xd>
    p++, q++;
 3b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	84 c0                	test   %al,%al
 3c0:	74 10                	je     3d2 <strcmp+0x27>
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 10             	movzbl (%eax),%edx
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	38 c2                	cmp    %al,%dl
 3d0:	74 de                	je     3b0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	0f b6 d0             	movzbl %al,%edx
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	0f b6 c0             	movzbl %al,%eax
 3e4:	29 c2                	sub    %eax,%edx
 3e6:	89 d0                	mov    %edx,%eax
}
 3e8:	5d                   	pop    %ebp
 3e9:	c3                   	ret    

000003ea <strlen>:

uint
strlen(char *s)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f7:	eb 04                	jmp    3fd <strlen+0x13>
 3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	01 d0                	add    %edx,%eax
 405:	0f b6 00             	movzbl (%eax),%eax
 408:	84 c0                	test   %al,%al
 40a:	75 ed                	jne    3f9 <strlen+0xf>
    ;
  return n;
 40c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    

00000411 <memset>:

void*
memset(void *dst, int c, uint n)
{
 411:	55                   	push   %ebp
 412:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 414:	8b 45 10             	mov    0x10(%ebp),%eax
 417:	50                   	push   %eax
 418:	ff 75 0c             	pushl  0xc(%ebp)
 41b:	ff 75 08             	pushl  0x8(%ebp)
 41e:	e8 32 ff ff ff       	call   355 <stosb>
 423:	83 c4 0c             	add    $0xc,%esp
  return dst;
 426:	8b 45 08             	mov    0x8(%ebp),%eax
}
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <strchr>:

char*
strchr(const char *s, char c)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
 42e:	83 ec 04             	sub    $0x4,%esp
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 437:	eb 14                	jmp    44d <strchr+0x22>
    if(*s == c)
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	0f b6 00             	movzbl (%eax),%eax
 43f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 442:	75 05                	jne    449 <strchr+0x1e>
      return (char*)s;
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	eb 13                	jmp    45c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 449:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	84 c0                	test   %al,%al
 455:	75 e2                	jne    439 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 457:	b8 00 00 00 00       	mov    $0x0,%eax
}
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <gets>:

char*
gets(char *buf, int max)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 464:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 46b:	eb 42                	jmp    4af <gets+0x51>
    cc = read(0, &c, 1);
 46d:	83 ec 04             	sub    $0x4,%esp
 470:	6a 01                	push   $0x1
 472:	8d 45 ef             	lea    -0x11(%ebp),%eax
 475:	50                   	push   %eax
 476:	6a 00                	push   $0x0
 478:	e8 47 01 00 00       	call   5c4 <read>
 47d:	83 c4 10             	add    $0x10,%esp
 480:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 483:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 487:	7e 33                	jle    4bc <gets+0x5e>
      break;
    buf[i++] = c;
 489:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48c:	8d 50 01             	lea    0x1(%eax),%edx
 48f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 492:	89 c2                	mov    %eax,%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	01 c2                	add    %eax,%edx
 499:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 49f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a3:	3c 0a                	cmp    $0xa,%al
 4a5:	74 16                	je     4bd <gets+0x5f>
 4a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ab:	3c 0d                	cmp    $0xd,%al
 4ad:	74 0e                	je     4bd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b2:	83 c0 01             	add    $0x1,%eax
 4b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4b8:	7c b3                	jl     46d <gets+0xf>
 4ba:	eb 01                	jmp    4bd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4bc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	01 d0                	add    %edx,%eax
 4c5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <stat>:

int
stat(char *n, struct stat *st)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d3:	83 ec 08             	sub    $0x8,%esp
 4d6:	6a 00                	push   $0x0
 4d8:	ff 75 08             	pushl  0x8(%ebp)
 4db:	e8 0c 01 00 00       	call   5ec <open>
 4e0:	83 c4 10             	add    $0x10,%esp
 4e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ea:	79 07                	jns    4f3 <stat+0x26>
    return -1;
 4ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f1:	eb 25                	jmp    518 <stat+0x4b>
  r = fstat(fd, st);
 4f3:	83 ec 08             	sub    $0x8,%esp
 4f6:	ff 75 0c             	pushl  0xc(%ebp)
 4f9:	ff 75 f4             	pushl  -0xc(%ebp)
 4fc:	e8 03 01 00 00       	call   604 <fstat>
 501:	83 c4 10             	add    $0x10,%esp
 504:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 507:	83 ec 0c             	sub    $0xc,%esp
 50a:	ff 75 f4             	pushl  -0xc(%ebp)
 50d:	e8 c2 00 00 00       	call   5d4 <close>
 512:	83 c4 10             	add    $0x10,%esp
  return r;
 515:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <atoi>:

int
atoi(const char *s)
{
 51a:	55                   	push   %ebp
 51b:	89 e5                	mov    %esp,%ebp
 51d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 520:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 527:	eb 25                	jmp    54e <atoi+0x34>
    n = n*10 + *s++ - '0';
 529:	8b 55 fc             	mov    -0x4(%ebp),%edx
 52c:	89 d0                	mov    %edx,%eax
 52e:	c1 e0 02             	shl    $0x2,%eax
 531:	01 d0                	add    %edx,%eax
 533:	01 c0                	add    %eax,%eax
 535:	89 c1                	mov    %eax,%ecx
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	8d 50 01             	lea    0x1(%eax),%edx
 53d:	89 55 08             	mov    %edx,0x8(%ebp)
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	0f be c0             	movsbl %al,%eax
 546:	01 c8                	add    %ecx,%eax
 548:	83 e8 30             	sub    $0x30,%eax
 54b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	0f b6 00             	movzbl (%eax),%eax
 554:	3c 2f                	cmp    $0x2f,%al
 556:	7e 0a                	jle    562 <atoi+0x48>
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	3c 39                	cmp    $0x39,%al
 560:	7e c7                	jle    529 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 562:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 565:	c9                   	leave  
 566:	c3                   	ret    

00000567 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 567:	55                   	push   %ebp
 568:	89 e5                	mov    %esp,%ebp
 56a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 573:	8b 45 0c             	mov    0xc(%ebp),%eax
 576:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 579:	eb 17                	jmp    592 <memmove+0x2b>
    *dst++ = *src++;
 57b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 57e:	8d 50 01             	lea    0x1(%eax),%edx
 581:	89 55 fc             	mov    %edx,-0x4(%ebp)
 584:	8b 55 f8             	mov    -0x8(%ebp),%edx
 587:	8d 4a 01             	lea    0x1(%edx),%ecx
 58a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 58d:	0f b6 12             	movzbl (%edx),%edx
 590:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 592:	8b 45 10             	mov    0x10(%ebp),%eax
 595:	8d 50 ff             	lea    -0x1(%eax),%edx
 598:	89 55 10             	mov    %edx,0x10(%ebp)
 59b:	85 c0                	test   %eax,%eax
 59d:	7f dc                	jg     57b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 59f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5a2:	c9                   	leave  
 5a3:	c3                   	ret    

000005a4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5a4:	b8 01 00 00 00       	mov    $0x1,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <exit>:
SYSCALL(exit)
 5ac:	b8 02 00 00 00       	mov    $0x2,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <wait>:
SYSCALL(wait)
 5b4:	b8 03 00 00 00       	mov    $0x3,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <pipe>:
SYSCALL(pipe)
 5bc:	b8 04 00 00 00       	mov    $0x4,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <read>:
SYSCALL(read)
 5c4:	b8 05 00 00 00       	mov    $0x5,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <write>:
SYSCALL(write)
 5cc:	b8 10 00 00 00       	mov    $0x10,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <close>:
SYSCALL(close)
 5d4:	b8 15 00 00 00       	mov    $0x15,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <kill>:
SYSCALL(kill)
 5dc:	b8 06 00 00 00       	mov    $0x6,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <exec>:
SYSCALL(exec)
 5e4:	b8 07 00 00 00       	mov    $0x7,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <open>:
SYSCALL(open)
 5ec:	b8 0f 00 00 00       	mov    $0xf,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <mknod>:
SYSCALL(mknod)
 5f4:	b8 11 00 00 00       	mov    $0x11,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <unlink>:
SYSCALL(unlink)
 5fc:	b8 12 00 00 00       	mov    $0x12,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <fstat>:
SYSCALL(fstat)
 604:	b8 08 00 00 00       	mov    $0x8,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <link>:
SYSCALL(link)
 60c:	b8 13 00 00 00       	mov    $0x13,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <mkdir>:
SYSCALL(mkdir)
 614:	b8 14 00 00 00       	mov    $0x14,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <chdir>:
SYSCALL(chdir)
 61c:	b8 09 00 00 00       	mov    $0x9,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <dup>:
SYSCALL(dup)
 624:	b8 0a 00 00 00       	mov    $0xa,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <getpid>:
SYSCALL(getpid)
 62c:	b8 0b 00 00 00       	mov    $0xb,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <sbrk>:
SYSCALL(sbrk)
 634:	b8 0c 00 00 00       	mov    $0xc,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <sleep>:
SYSCALL(sleep)
 63c:	b8 0d 00 00 00       	mov    $0xd,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <uptime>:
SYSCALL(uptime)
 644:	b8 0e 00 00 00       	mov    $0xe,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <halt>:
SYSCALL(halt)
 64c:	b8 16 00 00 00       	mov    $0x16,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <date>:
//Student Implementations 
SYSCALL(date)
 654:	b8 17 00 00 00       	mov    $0x17,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <getuid>:

SYSCALL(getuid)
 65c:	b8 18 00 00 00       	mov    $0x18,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <getgid>:
SYSCALL(getgid)
 664:	b8 19 00 00 00       	mov    $0x19,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <getppid>:
SYSCALL(getppid)
 66c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <setuid>:

SYSCALL(setuid)
 674:	b8 1b 00 00 00       	mov    $0x1b,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <setgid>:
SYSCALL(setgid)
 67c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <getprocs>:
SYSCALL(getprocs)
 684:	b8 1d 00 00 00       	mov    $0x1d,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <chown>:

SYSCALL(chown)
 68c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <chgrp>:
SYSCALL(chgrp)
 694:	b8 1f 00 00 00       	mov    $0x1f,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <chmod>:
SYSCALL(chmod)
 69c:	b8 20 00 00 00       	mov    $0x20,%eax
 6a1:	cd 40                	int    $0x40
 6a3:	c3                   	ret    

000006a4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	83 ec 18             	sub    $0x18,%esp
 6aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ad:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6b0:	83 ec 04             	sub    $0x4,%esp
 6b3:	6a 01                	push   $0x1
 6b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6b8:	50                   	push   %eax
 6b9:	ff 75 08             	pushl  0x8(%ebp)
 6bc:	e8 0b ff ff ff       	call   5cc <write>
 6c1:	83 c4 10             	add    $0x10,%esp
}
 6c4:	90                   	nop
 6c5:	c9                   	leave  
 6c6:	c3                   	ret    

000006c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c7:	55                   	push   %ebp
 6c8:	89 e5                	mov    %esp,%ebp
 6ca:	53                   	push   %ebx
 6cb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6d5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6d9:	74 17                	je     6f2 <printint+0x2b>
 6db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6df:	79 11                	jns    6f2 <printint+0x2b>
    neg = 1;
 6e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6eb:	f7 d8                	neg    %eax
 6ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f0:	eb 06                	jmp    6f8 <printint+0x31>
  } else {
    x = xx;
 6f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6ff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 702:	8d 41 01             	lea    0x1(%ecx),%eax
 705:	89 45 f4             	mov    %eax,-0xc(%ebp)
 708:	8b 5d 10             	mov    0x10(%ebp),%ebx
 70b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 70e:	ba 00 00 00 00       	mov    $0x0,%edx
 713:	f7 f3                	div    %ebx
 715:	89 d0                	mov    %edx,%eax
 717:	0f b6 80 34 0e 00 00 	movzbl 0xe34(%eax),%eax
 71e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 722:	8b 5d 10             	mov    0x10(%ebp),%ebx
 725:	8b 45 ec             	mov    -0x14(%ebp),%eax
 728:	ba 00 00 00 00       	mov    $0x0,%edx
 72d:	f7 f3                	div    %ebx
 72f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 732:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 736:	75 c7                	jne    6ff <printint+0x38>
  if(neg)
 738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73c:	74 2d                	je     76b <printint+0xa4>
    buf[i++] = '-';
 73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 741:	8d 50 01             	lea    0x1(%eax),%edx
 744:	89 55 f4             	mov    %edx,-0xc(%ebp)
 747:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 74c:	eb 1d                	jmp    76b <printint+0xa4>
    putc(fd, buf[i]);
 74e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	01 d0                	add    %edx,%eax
 756:	0f b6 00             	movzbl (%eax),%eax
 759:	0f be c0             	movsbl %al,%eax
 75c:	83 ec 08             	sub    $0x8,%esp
 75f:	50                   	push   %eax
 760:	ff 75 08             	pushl  0x8(%ebp)
 763:	e8 3c ff ff ff       	call   6a4 <putc>
 768:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 76b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 76f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 773:	79 d9                	jns    74e <printint+0x87>
    putc(fd, buf[i]);
}
 775:	90                   	nop
 776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 779:	c9                   	leave  
 77a:	c3                   	ret    

0000077b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 781:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 788:	8d 45 0c             	lea    0xc(%ebp),%eax
 78b:	83 c0 04             	add    $0x4,%eax
 78e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 791:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 798:	e9 59 01 00 00       	jmp    8f6 <printf+0x17b>
    c = fmt[i] & 0xff;
 79d:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	01 d0                	add    %edx,%eax
 7a5:	0f b6 00             	movzbl (%eax),%eax
 7a8:	0f be c0             	movsbl %al,%eax
 7ab:	25 ff 00 00 00       	and    $0xff,%eax
 7b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7b7:	75 2c                	jne    7e5 <printf+0x6a>
      if(c == '%'){
 7b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7bd:	75 0c                	jne    7cb <printf+0x50>
        state = '%';
 7bf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7c6:	e9 27 01 00 00       	jmp    8f2 <printf+0x177>
      } else {
        putc(fd, c);
 7cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	83 ec 08             	sub    $0x8,%esp
 7d4:	50                   	push   %eax
 7d5:	ff 75 08             	pushl  0x8(%ebp)
 7d8:	e8 c7 fe ff ff       	call   6a4 <putc>
 7dd:	83 c4 10             	add    $0x10,%esp
 7e0:	e9 0d 01 00 00       	jmp    8f2 <printf+0x177>
      }
    } else if(state == '%'){
 7e5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7e9:	0f 85 03 01 00 00    	jne    8f2 <printf+0x177>
      if(c == 'd'){
 7ef:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7f3:	75 1e                	jne    813 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	6a 01                	push   $0x1
 7fc:	6a 0a                	push   $0xa
 7fe:	50                   	push   %eax
 7ff:	ff 75 08             	pushl  0x8(%ebp)
 802:	e8 c0 fe ff ff       	call   6c7 <printint>
 807:	83 c4 10             	add    $0x10,%esp
        ap++;
 80a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80e:	e9 d8 00 00 00       	jmp    8eb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 813:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 817:	74 06                	je     81f <printf+0xa4>
 819:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 81d:	75 1e                	jne    83d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 81f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	6a 00                	push   $0x0
 826:	6a 10                	push   $0x10
 828:	50                   	push   %eax
 829:	ff 75 08             	pushl  0x8(%ebp)
 82c:	e8 96 fe ff ff       	call   6c7 <printint>
 831:	83 c4 10             	add    $0x10,%esp
        ap++;
 834:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 838:	e9 ae 00 00 00       	jmp    8eb <printf+0x170>
      } else if(c == 's'){
 83d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 841:	75 43                	jne    886 <printf+0x10b>
        s = (char*)*ap;
 843:	8b 45 e8             	mov    -0x18(%ebp),%eax
 846:	8b 00                	mov    (%eax),%eax
 848:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 84b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 84f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 853:	75 25                	jne    87a <printf+0xff>
          s = "(null)";
 855:	c7 45 f4 bb 0b 00 00 	movl   $0xbbb,-0xc(%ebp)
        while(*s != 0){
 85c:	eb 1c                	jmp    87a <printf+0xff>
          putc(fd, *s);
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	0f b6 00             	movzbl (%eax),%eax
 864:	0f be c0             	movsbl %al,%eax
 867:	83 ec 08             	sub    $0x8,%esp
 86a:	50                   	push   %eax
 86b:	ff 75 08             	pushl  0x8(%ebp)
 86e:	e8 31 fe ff ff       	call   6a4 <putc>
 873:	83 c4 10             	add    $0x10,%esp
          s++;
 876:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	84 c0                	test   %al,%al
 882:	75 da                	jne    85e <printf+0xe3>
 884:	eb 65                	jmp    8eb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 886:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 88a:	75 1d                	jne    8a9 <printf+0x12e>
        putc(fd, *ap);
 88c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	0f be c0             	movsbl %al,%eax
 894:	83 ec 08             	sub    $0x8,%esp
 897:	50                   	push   %eax
 898:	ff 75 08             	pushl  0x8(%ebp)
 89b:	e8 04 fe ff ff       	call   6a4 <putc>
 8a0:	83 c4 10             	add    $0x10,%esp
        ap++;
 8a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a7:	eb 42                	jmp    8eb <printf+0x170>
      } else if(c == '%'){
 8a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ad:	75 17                	jne    8c6 <printf+0x14b>
        putc(fd, c);
 8af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b2:	0f be c0             	movsbl %al,%eax
 8b5:	83 ec 08             	sub    $0x8,%esp
 8b8:	50                   	push   %eax
 8b9:	ff 75 08             	pushl  0x8(%ebp)
 8bc:	e8 e3 fd ff ff       	call   6a4 <putc>
 8c1:	83 c4 10             	add    $0x10,%esp
 8c4:	eb 25                	jmp    8eb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c6:	83 ec 08             	sub    $0x8,%esp
 8c9:	6a 25                	push   $0x25
 8cb:	ff 75 08             	pushl  0x8(%ebp)
 8ce:	e8 d1 fd ff ff       	call   6a4 <putc>
 8d3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d9:	0f be c0             	movsbl %al,%eax
 8dc:	83 ec 08             	sub    $0x8,%esp
 8df:	50                   	push   %eax
 8e0:	ff 75 08             	pushl  0x8(%ebp)
 8e3:	e8 bc fd ff ff       	call   6a4 <putc>
 8e8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fc:	01 d0                	add    %edx,%eax
 8fe:	0f b6 00             	movzbl (%eax),%eax
 901:	84 c0                	test   %al,%al
 903:	0f 85 94 fe ff ff    	jne    79d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 909:	90                   	nop
 90a:	c9                   	leave  
 90b:	c3                   	ret    

0000090c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90c:	55                   	push   %ebp
 90d:	89 e5                	mov    %esp,%ebp
 90f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 912:	8b 45 08             	mov    0x8(%ebp),%eax
 915:	83 e8 08             	sub    $0x8,%eax
 918:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91b:	a1 50 0e 00 00       	mov    0xe50,%eax
 920:	89 45 fc             	mov    %eax,-0x4(%ebp)
 923:	eb 24                	jmp    949 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92d:	77 12                	ja     941 <free+0x35>
 92f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 932:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 935:	77 24                	ja     95b <free+0x4f>
 937:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93a:	8b 00                	mov    (%eax),%eax
 93c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93f:	77 1a                	ja     95b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	8b 00                	mov    (%eax),%eax
 946:	89 45 fc             	mov    %eax,-0x4(%ebp)
 949:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 94f:	76 d4                	jbe    925 <free+0x19>
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 959:	76 ca                	jbe    925 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 95b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95e:	8b 40 04             	mov    0x4(%eax),%eax
 961:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 968:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96b:	01 c2                	add    %eax,%edx
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	8b 00                	mov    (%eax),%eax
 972:	39 c2                	cmp    %eax,%edx
 974:	75 24                	jne    99a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 976:	8b 45 f8             	mov    -0x8(%ebp),%eax
 979:	8b 50 04             	mov    0x4(%eax),%edx
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	8b 00                	mov    (%eax),%eax
 981:	8b 40 04             	mov    0x4(%eax),%eax
 984:	01 c2                	add    %eax,%edx
 986:	8b 45 f8             	mov    -0x8(%ebp),%eax
 989:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 98c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98f:	8b 00                	mov    (%eax),%eax
 991:	8b 10                	mov    (%eax),%edx
 993:	8b 45 f8             	mov    -0x8(%ebp),%eax
 996:	89 10                	mov    %edx,(%eax)
 998:	eb 0a                	jmp    9a4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	8b 10                	mov    (%eax),%edx
 99f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a7:	8b 40 04             	mov    0x4(%eax),%eax
 9aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	01 d0                	add    %edx,%eax
 9b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b9:	75 20                	jne    9db <free+0xcf>
    p->s.size += bp->s.size;
 9bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9be:	8b 50 04             	mov    0x4(%eax),%edx
 9c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c4:	8b 40 04             	mov    0x4(%eax),%eax
 9c7:	01 c2                	add    %eax,%edx
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d2:	8b 10                	mov    (%eax),%edx
 9d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d7:	89 10                	mov    %edx,(%eax)
 9d9:	eb 08                	jmp    9e3 <free+0xd7>
  } else
    p->s.ptr = bp;
 9db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9e1:	89 10                	mov    %edx,(%eax)
  freep = p;
 9e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e6:	a3 50 0e 00 00       	mov    %eax,0xe50
}
 9eb:	90                   	nop
 9ec:	c9                   	leave  
 9ed:	c3                   	ret    

000009ee <morecore>:

static Header*
morecore(uint nu)
{
 9ee:	55                   	push   %ebp
 9ef:	89 e5                	mov    %esp,%ebp
 9f1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9f4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9fb:	77 07                	ja     a04 <morecore+0x16>
    nu = 4096;
 9fd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a04:	8b 45 08             	mov    0x8(%ebp),%eax
 a07:	c1 e0 03             	shl    $0x3,%eax
 a0a:	83 ec 0c             	sub    $0xc,%esp
 a0d:	50                   	push   %eax
 a0e:	e8 21 fc ff ff       	call   634 <sbrk>
 a13:	83 c4 10             	add    $0x10,%esp
 a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a19:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a1d:	75 07                	jne    a26 <morecore+0x38>
    return 0;
 a1f:	b8 00 00 00 00       	mov    $0x0,%eax
 a24:	eb 26                	jmp    a4c <morecore+0x5e>
  hp = (Header*)p;
 a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2f:	8b 55 08             	mov    0x8(%ebp),%edx
 a32:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	83 c0 08             	add    $0x8,%eax
 a3b:	83 ec 0c             	sub    $0xc,%esp
 a3e:	50                   	push   %eax
 a3f:	e8 c8 fe ff ff       	call   90c <free>
 a44:	83 c4 10             	add    $0x10,%esp
  return freep;
 a47:	a1 50 0e 00 00       	mov    0xe50,%eax
}
 a4c:	c9                   	leave  
 a4d:	c3                   	ret    

00000a4e <malloc>:

void*
malloc(uint nbytes)
{
 a4e:	55                   	push   %ebp
 a4f:	89 e5                	mov    %esp,%ebp
 a51:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a54:	8b 45 08             	mov    0x8(%ebp),%eax
 a57:	83 c0 07             	add    $0x7,%eax
 a5a:	c1 e8 03             	shr    $0x3,%eax
 a5d:	83 c0 01             	add    $0x1,%eax
 a60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a63:	a1 50 0e 00 00       	mov    0xe50,%eax
 a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a6f:	75 23                	jne    a94 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a71:	c7 45 f0 48 0e 00 00 	movl   $0xe48,-0x10(%ebp)
 a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7b:	a3 50 0e 00 00       	mov    %eax,0xe50
 a80:	a1 50 0e 00 00       	mov    0xe50,%eax
 a85:	a3 48 0e 00 00       	mov    %eax,0xe48
    base.s.size = 0;
 a8a:	c7 05 4c 0e 00 00 00 	movl   $0x0,0xe4c
 a91:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a97:	8b 00                	mov    (%eax),%eax
 a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9f:	8b 40 04             	mov    0x4(%eax),%eax
 aa2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa5:	72 4d                	jb     af4 <malloc+0xa6>
      if(p->s.size == nunits)
 aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaa:	8b 40 04             	mov    0x4(%eax),%eax
 aad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab0:	75 0c                	jne    abe <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab5:	8b 10                	mov    (%eax),%edx
 ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aba:	89 10                	mov    %edx,(%eax)
 abc:	eb 26                	jmp    ae4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac1:	8b 40 04             	mov    0x4(%eax),%eax
 ac4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ac7:	89 c2                	mov    %eax,%edx
 ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	8b 40 04             	mov    0x4(%eax),%eax
 ad5:	c1 e0 03             	shl    $0x3,%eax
 ad8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ade:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ae1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae7:	a3 50 0e 00 00       	mov    %eax,0xe50
      return (void*)(p + 1);
 aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aef:	83 c0 08             	add    $0x8,%eax
 af2:	eb 3b                	jmp    b2f <malloc+0xe1>
    }
    if(p == freep)
 af4:	a1 50 0e 00 00       	mov    0xe50,%eax
 af9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 afc:	75 1e                	jne    b1c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 afe:	83 ec 0c             	sub    $0xc,%esp
 b01:	ff 75 ec             	pushl  -0x14(%ebp)
 b04:	e8 e5 fe ff ff       	call   9ee <morecore>
 b09:	83 c4 10             	add    $0x10,%esp
 b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b13:	75 07                	jne    b1c <malloc+0xce>
        return 0;
 b15:	b8 00 00 00 00       	mov    $0x0,%eax
 b1a:	eb 13                	jmp    b2f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b25:	8b 00                	mov    (%eax),%eax
 b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b2a:	e9 6d ff ff ff       	jmp    a9c <malloc+0x4e>
}
 b2f:	c9                   	leave  
 b30:	c3                   	ret    
