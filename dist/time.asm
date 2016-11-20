
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
  1d:	68 1c 0b 00 00       	push   $0xb1c
  22:	6a 01                	push   $0x1
  24:	e8 3a 07 00 00       	call   763 <printf>
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
  6b:	68 6c 0b 00 00       	push   $0xb6c
  70:	6a 01                	push   $0x1
  72:	e8 ec 06 00 00       	call   763 <printf>
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
  c7:	68 78 0b 00 00       	push   $0xb78
  cc:	6a 01                	push   $0x1
  ce:	e8 90 06 00 00       	call   763 <printf>
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
  fa:	68 93 0b 00 00       	push   $0xb93
  ff:	6a 01                	push   $0x1
 101:	e8 5d 06 00 00       	call   763 <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	eb 3a                	jmp    145 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	68 95 0b 00 00       	push   $0xb95
 113:	6a 01                	push   $0x1
 115:	e8 49 06 00 00       	call   763 <printf>
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	eb 26                	jmp    145 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 11f:	83 ec 08             	sub    $0x8,%esp
 122:	68 97 0b 00 00       	push   $0xb97
 127:	6a 01                	push   $0x1
 129:	e8 35 06 00 00       	call   763 <printf>
 12e:	83 c4 10             	add    $0x10,%esp
 131:	eb 12                	jmp    145 <print_mode+0x6a>
    default: printf(1, "?");
 133:	83 ec 08             	sub    $0x8,%esp
 136:	68 99 0b 00 00       	push   $0xb99
 13b:	6a 01                	push   $0x1
 13d:	e8 21 06 00 00       	call   763 <printf>
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
 156:	68 9b 0b 00 00       	push   $0xb9b
 15b:	6a 01                	push   $0x1
 15d:	e8 01 06 00 00       	call   763 <printf>
 162:	83 c4 10             	add    $0x10,%esp
 165:	eb 12                	jmp    179 <print_mode+0x9e>
  else
    printf(1, "-");
 167:	83 ec 08             	sub    $0x8,%esp
 16a:	68 95 0b 00 00       	push   $0xb95
 16f:	6a 01                	push   $0x1
 171:	e8 ed 05 00 00       	call   763 <printf>
 176:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 180:	83 e0 80             	and    $0xffffff80,%eax
 183:	84 c0                	test   %al,%al
 185:	74 14                	je     19b <print_mode+0xc0>
    printf(1, "w");
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	68 9d 0b 00 00       	push   $0xb9d
 18f:	6a 01                	push   $0x1
 191:	e8 cd 05 00 00       	call   763 <printf>
 196:	83 c4 10             	add    $0x10,%esp
 199:	eb 12                	jmp    1ad <print_mode+0xd2>
  else
    printf(1, "-");
 19b:	83 ec 08             	sub    $0x8,%esp
 19e:	68 95 0b 00 00       	push   $0xb95
 1a3:	6a 01                	push   $0x1
 1a5:	e8 b9 05 00 00       	call   763 <printf>
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
 1d5:	68 9f 0b 00 00       	push   $0xb9f
 1da:	6a 01                	push   $0x1
 1dc:	e8 82 05 00 00       	call   763 <printf>
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
 1f7:	68 a1 0b 00 00       	push   $0xba1
 1fc:	6a 01                	push   $0x1
 1fe:	e8 60 05 00 00       	call   763 <printf>
 203:	83 c4 10             	add    $0x10,%esp
 206:	eb 12                	jmp    21a <print_mode+0x13f>
  else
    printf(1, "-");
 208:	83 ec 08             	sub    $0x8,%esp
 20b:	68 95 0b 00 00       	push   $0xb95
 210:	6a 01                	push   $0x1
 212:	e8 4c 05 00 00       	call   763 <printf>
 217:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 221:	83 e0 20             	and    $0x20,%eax
 224:	84 c0                	test   %al,%al
 226:	74 14                	je     23c <print_mode+0x161>
    printf(1, "r");
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	68 9b 0b 00 00       	push   $0xb9b
 230:	6a 01                	push   $0x1
 232:	e8 2c 05 00 00       	call   763 <printf>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	eb 12                	jmp    24e <print_mode+0x173>
  else
    printf(1, "-");
 23c:	83 ec 08             	sub    $0x8,%esp
 23f:	68 95 0b 00 00       	push   $0xb95
 244:	6a 01                	push   $0x1
 246:	e8 18 05 00 00       	call   763 <printf>
 24b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 255:	83 e0 10             	and    $0x10,%eax
 258:	84 c0                	test   %al,%al
 25a:	74 14                	je     270 <print_mode+0x195>
    printf(1, "w");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 9d 0b 00 00       	push   $0xb9d
 264:	6a 01                	push   $0x1
 266:	e8 f8 04 00 00       	call   763 <printf>
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	eb 12                	jmp    282 <print_mode+0x1a7>
  else
    printf(1, "-");
 270:	83 ec 08             	sub    $0x8,%esp
 273:	68 95 0b 00 00       	push   $0xb95
 278:	6a 01                	push   $0x1
 27a:	e8 e4 04 00 00       	call   763 <printf>
 27f:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 289:	83 e0 08             	and    $0x8,%eax
 28c:	84 c0                	test   %al,%al
 28e:	74 14                	je     2a4 <print_mode+0x1c9>
    printf(1, "x");
 290:	83 ec 08             	sub    $0x8,%esp
 293:	68 a1 0b 00 00       	push   $0xba1
 298:	6a 01                	push   $0x1
 29a:	e8 c4 04 00 00       	call   763 <printf>
 29f:	83 c4 10             	add    $0x10,%esp
 2a2:	eb 12                	jmp    2b6 <print_mode+0x1db>
  else
    printf(1, "-");
 2a4:	83 ec 08             	sub    $0x8,%esp
 2a7:	68 95 0b 00 00       	push   $0xb95
 2ac:	6a 01                	push   $0x1
 2ae:	e8 b0 04 00 00       	call   763 <printf>
 2b3:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2bd:	83 e0 04             	and    $0x4,%eax
 2c0:	84 c0                	test   %al,%al
 2c2:	74 14                	je     2d8 <print_mode+0x1fd>
    printf(1, "r");
 2c4:	83 ec 08             	sub    $0x8,%esp
 2c7:	68 9b 0b 00 00       	push   $0xb9b
 2cc:	6a 01                	push   $0x1
 2ce:	e8 90 04 00 00       	call   763 <printf>
 2d3:	83 c4 10             	add    $0x10,%esp
 2d6:	eb 12                	jmp    2ea <print_mode+0x20f>
  else
    printf(1, "-");
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	68 95 0b 00 00       	push   $0xb95
 2e0:	6a 01                	push   $0x1
 2e2:	e8 7c 04 00 00       	call   763 <printf>
 2e7:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2f1:	83 e0 02             	and    $0x2,%eax
 2f4:	84 c0                	test   %al,%al
 2f6:	74 14                	je     30c <print_mode+0x231>
    printf(1, "w");
 2f8:	83 ec 08             	sub    $0x8,%esp
 2fb:	68 9d 0b 00 00       	push   $0xb9d
 300:	6a 01                	push   $0x1
 302:	e8 5c 04 00 00       	call   763 <printf>
 307:	83 c4 10             	add    $0x10,%esp
 30a:	eb 12                	jmp    31e <print_mode+0x243>
  else
    printf(1, "-");
 30c:	83 ec 08             	sub    $0x8,%esp
 30f:	68 95 0b 00 00       	push   $0xb95
 314:	6a 01                	push   $0x1
 316:	e8 48 04 00 00       	call   763 <printf>
 31b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 325:	83 e0 01             	and    $0x1,%eax
 328:	84 c0                	test   %al,%al
 32a:	74 14                	je     340 <print_mode+0x265>
    printf(1, "x");
 32c:	83 ec 08             	sub    $0x8,%esp
 32f:	68 a1 0b 00 00       	push   $0xba1
 334:	6a 01                	push   $0x1
 336:	e8 28 04 00 00       	call   763 <printf>
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
 343:	68 95 0b 00 00       	push   $0xb95
 348:	6a 01                	push   $0x1
 34a:	e8 14 04 00 00       	call   763 <printf>
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

0000068c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 68c:	55                   	push   %ebp
 68d:	89 e5                	mov    %esp,%ebp
 68f:	83 ec 18             	sub    $0x18,%esp
 692:	8b 45 0c             	mov    0xc(%ebp),%eax
 695:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 698:	83 ec 04             	sub    $0x4,%esp
 69b:	6a 01                	push   $0x1
 69d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6a0:	50                   	push   %eax
 6a1:	ff 75 08             	pushl  0x8(%ebp)
 6a4:	e8 23 ff ff ff       	call   5cc <write>
 6a9:	83 c4 10             	add    $0x10,%esp
}
 6ac:	90                   	nop
 6ad:	c9                   	leave  
 6ae:	c3                   	ret    

000006af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6af:	55                   	push   %ebp
 6b0:	89 e5                	mov    %esp,%ebp
 6b2:	53                   	push   %ebx
 6b3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6c1:	74 17                	je     6da <printint+0x2b>
 6c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6c7:	79 11                	jns    6da <printint+0x2b>
    neg = 1;
 6c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d3:	f7 d8                	neg    %eax
 6d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d8:	eb 06                	jmp    6e0 <printint+0x31>
  } else {
    x = xx;
 6da:	8b 45 0c             	mov    0xc(%ebp),%eax
 6dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6ea:	8d 41 01             	lea    0x1(%ecx),%eax
 6ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f6:	ba 00 00 00 00       	mov    $0x0,%edx
 6fb:	f7 f3                	div    %ebx
 6fd:	89 d0                	mov    %edx,%eax
 6ff:	0f b6 80 1c 0e 00 00 	movzbl 0xe1c(%eax),%eax
 706:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 70a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 70d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 710:	ba 00 00 00 00       	mov    $0x0,%edx
 715:	f7 f3                	div    %ebx
 717:	89 45 ec             	mov    %eax,-0x14(%ebp)
 71a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 71e:	75 c7                	jne    6e7 <printint+0x38>
  if(neg)
 720:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 724:	74 2d                	je     753 <printint+0xa4>
    buf[i++] = '-';
 726:	8b 45 f4             	mov    -0xc(%ebp),%eax
 729:	8d 50 01             	lea    0x1(%eax),%edx
 72c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 72f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 734:	eb 1d                	jmp    753 <printint+0xa4>
    putc(fd, buf[i]);
 736:	8d 55 dc             	lea    -0x24(%ebp),%edx
 739:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73c:	01 d0                	add    %edx,%eax
 73e:	0f b6 00             	movzbl (%eax),%eax
 741:	0f be c0             	movsbl %al,%eax
 744:	83 ec 08             	sub    $0x8,%esp
 747:	50                   	push   %eax
 748:	ff 75 08             	pushl  0x8(%ebp)
 74b:	e8 3c ff ff ff       	call   68c <putc>
 750:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 753:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 75b:	79 d9                	jns    736 <printint+0x87>
    putc(fd, buf[i]);
}
 75d:	90                   	nop
 75e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 761:	c9                   	leave  
 762:	c3                   	ret    

00000763 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 763:	55                   	push   %ebp
 764:	89 e5                	mov    %esp,%ebp
 766:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 769:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 770:	8d 45 0c             	lea    0xc(%ebp),%eax
 773:	83 c0 04             	add    $0x4,%eax
 776:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 779:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 780:	e9 59 01 00 00       	jmp    8de <printf+0x17b>
    c = fmt[i] & 0xff;
 785:	8b 55 0c             	mov    0xc(%ebp),%edx
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	01 d0                	add    %edx,%eax
 78d:	0f b6 00             	movzbl (%eax),%eax
 790:	0f be c0             	movsbl %al,%eax
 793:	25 ff 00 00 00       	and    $0xff,%eax
 798:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 79b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 79f:	75 2c                	jne    7cd <printf+0x6a>
      if(c == '%'){
 7a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a5:	75 0c                	jne    7b3 <printf+0x50>
        state = '%';
 7a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7ae:	e9 27 01 00 00       	jmp    8da <printf+0x177>
      } else {
        putc(fd, c);
 7b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b6:	0f be c0             	movsbl %al,%eax
 7b9:	83 ec 08             	sub    $0x8,%esp
 7bc:	50                   	push   %eax
 7bd:	ff 75 08             	pushl  0x8(%ebp)
 7c0:	e8 c7 fe ff ff       	call   68c <putc>
 7c5:	83 c4 10             	add    $0x10,%esp
 7c8:	e9 0d 01 00 00       	jmp    8da <printf+0x177>
      }
    } else if(state == '%'){
 7cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7d1:	0f 85 03 01 00 00    	jne    8da <printf+0x177>
      if(c == 'd'){
 7d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7db:	75 1e                	jne    7fb <printf+0x98>
        printint(fd, *ap, 10, 1);
 7dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e0:	8b 00                	mov    (%eax),%eax
 7e2:	6a 01                	push   $0x1
 7e4:	6a 0a                	push   $0xa
 7e6:	50                   	push   %eax
 7e7:	ff 75 08             	pushl  0x8(%ebp)
 7ea:	e8 c0 fe ff ff       	call   6af <printint>
 7ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 7f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7f6:	e9 d8 00 00 00       	jmp    8d3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7fb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ff:	74 06                	je     807 <printf+0xa4>
 801:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 805:	75 1e                	jne    825 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 807:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	6a 00                	push   $0x0
 80e:	6a 10                	push   $0x10
 810:	50                   	push   %eax
 811:	ff 75 08             	pushl  0x8(%ebp)
 814:	e8 96 fe ff ff       	call   6af <printint>
 819:	83 c4 10             	add    $0x10,%esp
        ap++;
 81c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 820:	e9 ae 00 00 00       	jmp    8d3 <printf+0x170>
      } else if(c == 's'){
 825:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 829:	75 43                	jne    86e <printf+0x10b>
        s = (char*)*ap;
 82b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 833:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83b:	75 25                	jne    862 <printf+0xff>
          s = "(null)";
 83d:	c7 45 f4 a3 0b 00 00 	movl   $0xba3,-0xc(%ebp)
        while(*s != 0){
 844:	eb 1c                	jmp    862 <printf+0xff>
          putc(fd, *s);
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	0f b6 00             	movzbl (%eax),%eax
 84c:	0f be c0             	movsbl %al,%eax
 84f:	83 ec 08             	sub    $0x8,%esp
 852:	50                   	push   %eax
 853:	ff 75 08             	pushl  0x8(%ebp)
 856:	e8 31 fe ff ff       	call   68c <putc>
 85b:	83 c4 10             	add    $0x10,%esp
          s++;
 85e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	0f b6 00             	movzbl (%eax),%eax
 868:	84 c0                	test   %al,%al
 86a:	75 da                	jne    846 <printf+0xe3>
 86c:	eb 65                	jmp    8d3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 86e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 872:	75 1d                	jne    891 <printf+0x12e>
        putc(fd, *ap);
 874:	8b 45 e8             	mov    -0x18(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	0f be c0             	movsbl %al,%eax
 87c:	83 ec 08             	sub    $0x8,%esp
 87f:	50                   	push   %eax
 880:	ff 75 08             	pushl  0x8(%ebp)
 883:	e8 04 fe ff ff       	call   68c <putc>
 888:	83 c4 10             	add    $0x10,%esp
        ap++;
 88b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 88f:	eb 42                	jmp    8d3 <printf+0x170>
      } else if(c == '%'){
 891:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 895:	75 17                	jne    8ae <printf+0x14b>
        putc(fd, c);
 897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 89a:	0f be c0             	movsbl %al,%eax
 89d:	83 ec 08             	sub    $0x8,%esp
 8a0:	50                   	push   %eax
 8a1:	ff 75 08             	pushl  0x8(%ebp)
 8a4:	e8 e3 fd ff ff       	call   68c <putc>
 8a9:	83 c4 10             	add    $0x10,%esp
 8ac:	eb 25                	jmp    8d3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ae:	83 ec 08             	sub    $0x8,%esp
 8b1:	6a 25                	push   $0x25
 8b3:	ff 75 08             	pushl  0x8(%ebp)
 8b6:	e8 d1 fd ff ff       	call   68c <putc>
 8bb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c1:	0f be c0             	movsbl %al,%eax
 8c4:	83 ec 08             	sub    $0x8,%esp
 8c7:	50                   	push   %eax
 8c8:	ff 75 08             	pushl  0x8(%ebp)
 8cb:	e8 bc fd ff ff       	call   68c <putc>
 8d0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8de:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	01 d0                	add    %edx,%eax
 8e6:	0f b6 00             	movzbl (%eax),%eax
 8e9:	84 c0                	test   %al,%al
 8eb:	0f 85 94 fe ff ff    	jne    785 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f1:	90                   	nop
 8f2:	c9                   	leave  
 8f3:	c3                   	ret    

000008f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fa:	8b 45 08             	mov    0x8(%ebp),%eax
 8fd:	83 e8 08             	sub    $0x8,%eax
 900:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 903:	a1 38 0e 00 00       	mov    0xe38,%eax
 908:	89 45 fc             	mov    %eax,-0x4(%ebp)
 90b:	eb 24                	jmp    931 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 915:	77 12                	ja     929 <free+0x35>
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91d:	77 24                	ja     943 <free+0x4f>
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 927:	77 1a                	ja     943 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 931:	8b 45 f8             	mov    -0x8(%ebp),%eax
 934:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 937:	76 d4                	jbe    90d <free+0x19>
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 941:	76 ca                	jbe    90d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 943:	8b 45 f8             	mov    -0x8(%ebp),%eax
 946:	8b 40 04             	mov    0x4(%eax),%eax
 949:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 950:	8b 45 f8             	mov    -0x8(%ebp),%eax
 953:	01 c2                	add    %eax,%edx
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	8b 00                	mov    (%eax),%eax
 95a:	39 c2                	cmp    %eax,%edx
 95c:	75 24                	jne    982 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	8b 50 04             	mov    0x4(%eax),%edx
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	8b 40 04             	mov    0x4(%eax),%eax
 96c:	01 c2                	add    %eax,%edx
 96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 971:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 974:	8b 45 fc             	mov    -0x4(%ebp),%eax
 977:	8b 00                	mov    (%eax),%eax
 979:	8b 10                	mov    (%eax),%edx
 97b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97e:	89 10                	mov    %edx,(%eax)
 980:	eb 0a                	jmp    98c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 982:	8b 45 fc             	mov    -0x4(%ebp),%eax
 985:	8b 10                	mov    (%eax),%edx
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 98c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98f:	8b 40 04             	mov    0x4(%eax),%eax
 992:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 999:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99c:	01 d0                	add    %edx,%eax
 99e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9a1:	75 20                	jne    9c3 <free+0xcf>
    p->s.size += bp->s.size;
 9a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a6:	8b 50 04             	mov    0x4(%eax),%edx
 9a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ac:	8b 40 04             	mov    0x4(%eax),%eax
 9af:	01 c2                	add    %eax,%edx
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ba:	8b 10                	mov    (%eax),%edx
 9bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bf:	89 10                	mov    %edx,(%eax)
 9c1:	eb 08                	jmp    9cb <free+0xd7>
  } else
    p->s.ptr = bp;
 9c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9c9:	89 10                	mov    %edx,(%eax)
  freep = p;
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	a3 38 0e 00 00       	mov    %eax,0xe38
}
 9d3:	90                   	nop
 9d4:	c9                   	leave  
 9d5:	c3                   	ret    

000009d6 <morecore>:

static Header*
morecore(uint nu)
{
 9d6:	55                   	push   %ebp
 9d7:	89 e5                	mov    %esp,%ebp
 9d9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9e3:	77 07                	ja     9ec <morecore+0x16>
    nu = 4096;
 9e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9ec:	8b 45 08             	mov    0x8(%ebp),%eax
 9ef:	c1 e0 03             	shl    $0x3,%eax
 9f2:	83 ec 0c             	sub    $0xc,%esp
 9f5:	50                   	push   %eax
 9f6:	e8 39 fc ff ff       	call   634 <sbrk>
 9fb:	83 c4 10             	add    $0x10,%esp
 9fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a01:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a05:	75 07                	jne    a0e <morecore+0x38>
    return 0;
 a07:	b8 00 00 00 00       	mov    $0x0,%eax
 a0c:	eb 26                	jmp    a34 <morecore+0x5e>
  hp = (Header*)p;
 a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a17:	8b 55 08             	mov    0x8(%ebp),%edx
 a1a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a20:	83 c0 08             	add    $0x8,%eax
 a23:	83 ec 0c             	sub    $0xc,%esp
 a26:	50                   	push   %eax
 a27:	e8 c8 fe ff ff       	call   8f4 <free>
 a2c:	83 c4 10             	add    $0x10,%esp
  return freep;
 a2f:	a1 38 0e 00 00       	mov    0xe38,%eax
}
 a34:	c9                   	leave  
 a35:	c3                   	ret    

00000a36 <malloc>:

void*
malloc(uint nbytes)
{
 a36:	55                   	push   %ebp
 a37:	89 e5                	mov    %esp,%ebp
 a39:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3c:	8b 45 08             	mov    0x8(%ebp),%eax
 a3f:	83 c0 07             	add    $0x7,%eax
 a42:	c1 e8 03             	shr    $0x3,%eax
 a45:	83 c0 01             	add    $0x1,%eax
 a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a4b:	a1 38 0e 00 00       	mov    0xe38,%eax
 a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a57:	75 23                	jne    a7c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a59:	c7 45 f0 30 0e 00 00 	movl   $0xe30,-0x10(%ebp)
 a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a63:	a3 38 0e 00 00       	mov    %eax,0xe38
 a68:	a1 38 0e 00 00       	mov    0xe38,%eax
 a6d:	a3 30 0e 00 00       	mov    %eax,0xe30
    base.s.size = 0;
 a72:	c7 05 34 0e 00 00 00 	movl   $0x0,0xe34
 a79:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7f:	8b 00                	mov    (%eax),%eax
 a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a87:	8b 40 04             	mov    0x4(%eax),%eax
 a8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a8d:	72 4d                	jb     adc <malloc+0xa6>
      if(p->s.size == nunits)
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 40 04             	mov    0x4(%eax),%eax
 a95:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a98:	75 0c                	jne    aa6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	8b 10                	mov    (%eax),%edx
 a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa2:	89 10                	mov    %edx,(%eax)
 aa4:	eb 26                	jmp    acc <malloc+0x96>
      else {
        p->s.size -= nunits;
 aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa9:	8b 40 04             	mov    0x4(%eax),%eax
 aac:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aaf:	89 c2                	mov    %eax,%edx
 ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	8b 40 04             	mov    0x4(%eax),%eax
 abd:	c1 e0 03             	shl    $0x3,%eax
 ac0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ac9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acf:	a3 38 0e 00 00       	mov    %eax,0xe38
      return (void*)(p + 1);
 ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad7:	83 c0 08             	add    $0x8,%eax
 ada:	eb 3b                	jmp    b17 <malloc+0xe1>
    }
    if(p == freep)
 adc:	a1 38 0e 00 00       	mov    0xe38,%eax
 ae1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ae4:	75 1e                	jne    b04 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ae6:	83 ec 0c             	sub    $0xc,%esp
 ae9:	ff 75 ec             	pushl  -0x14(%ebp)
 aec:	e8 e5 fe ff ff       	call   9d6 <morecore>
 af1:	83 c4 10             	add    $0x10,%esp
 af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 afb:	75 07                	jne    b04 <malloc+0xce>
        return 0;
 afd:	b8 00 00 00 00       	mov    $0x0,%eax
 b02:	eb 13                	jmp    b17 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0d:	8b 00                	mov    (%eax),%eax
 b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b12:	e9 6d ff ff ff       	jmp    a84 <malloc+0x4e>
}
 b17:	c9                   	leave  
 b18:	c3                   	ret    
