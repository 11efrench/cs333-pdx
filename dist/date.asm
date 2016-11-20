
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "date.h"

//This is a SHELL PROGRAM that should only
//be used to EXECUTE SYSTEM CALLS

int main (int argc, char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
    
    //contains all the pieces of time
    //with resolution of one second
    struct rtcdate r;

    if (date(&r)) {
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1a:	50                   	push   %eax
  1b:	e8 e7 05 00 00       	call   607 <date>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	74 17                	je     3e <main+0x3e>

        printf(2, "Date_failed\n");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 cc 0a 00 00       	push   $0xacc
  2f:	6a 02                	push   $0x2
  31:	e8 e0 06 00 00       	call   716 <printf>
  36:	83 c4 10             	add    $0x10,%esp
        exit();
  39:	e8 21 05 00 00       	call   55f <exit>
    }

    if( date(&r) == 0){
  3e:	83 ec 0c             	sub    $0xc,%esp
  41:	8d 45 d0             	lea    -0x30(%ebp),%eax
  44:	50                   	push   %eax
  45:	e8 bd 05 00 00       	call   607 <date>
  4a:	83 c4 10             	add    $0x10,%esp
  4d:	85 c0                	test   %eax,%eax
  4f:	75 2c                	jne    7d <main+0x7d>
        printf(1, "day: %d month: %d year: %d \t hour: %d minute: %d second: %d \n", r.day, r.month, r.year, r.hour, r.minute, r.second);
  51:	8b 7d d0             	mov    -0x30(%ebp),%edi
  54:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  57:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  5a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  63:	57                   	push   %edi
  64:	56                   	push   %esi
  65:	53                   	push   %ebx
  66:	51                   	push   %ecx
  67:	52                   	push   %edx
  68:	50                   	push   %eax
  69:	68 dc 0a 00 00       	push   $0xadc
  6e:	6a 01                	push   $0x1
  70:	e8 a1 06 00 00       	call   716 <printf>
  75:	83 c4 20             	add    $0x20,%esp
        exit();
  78:	e8 e2 04 00 00       	call   55f <exit>
  7d:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  82:	8d 65 f0             	lea    -0x10(%ebp),%esp
  85:	59                   	pop    %ecx
  86:	5b                   	pop    %ebx
  87:	5e                   	pop    %esi
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	8d 61 fc             	lea    -0x4(%ecx),%esp
  8d:	c3                   	ret    

0000008e <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	0f b7 00             	movzwl (%eax),%eax
  9a:	98                   	cwtl   
  9b:	83 f8 02             	cmp    $0x2,%eax
  9e:	74 1e                	je     be <print_mode+0x30>
  a0:	83 f8 03             	cmp    $0x3,%eax
  a3:	74 2d                	je     d2 <print_mode+0x44>
  a5:	83 f8 01             	cmp    $0x1,%eax
  a8:	75 3c                	jne    e6 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  aa:	83 ec 08             	sub    $0x8,%esp
  ad:	68 1a 0b 00 00       	push   $0xb1a
  b2:	6a 01                	push   $0x1
  b4:	e8 5d 06 00 00       	call   716 <printf>
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	eb 3a                	jmp    f8 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  be:	83 ec 08             	sub    $0x8,%esp
  c1:	68 1c 0b 00 00       	push   $0xb1c
  c6:	6a 01                	push   $0x1
  c8:	e8 49 06 00 00       	call   716 <printf>
  cd:	83 c4 10             	add    $0x10,%esp
  d0:	eb 26                	jmp    f8 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 1e 0b 00 00       	push   $0xb1e
  da:	6a 01                	push   $0x1
  dc:	e8 35 06 00 00       	call   716 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
  e4:	eb 12                	jmp    f8 <print_mode+0x6a>
    default: printf(1, "?");
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	68 20 0b 00 00       	push   $0xb20
  ee:	6a 01                	push   $0x1
  f0:	e8 21 06 00 00       	call   716 <printf>
  f5:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	0f b6 40 19          	movzbl 0x19(%eax),%eax
  ff:	83 e0 01             	and    $0x1,%eax
 102:	84 c0                	test   %al,%al
 104:	74 14                	je     11a <print_mode+0x8c>
    printf(1, "r");
 106:	83 ec 08             	sub    $0x8,%esp
 109:	68 22 0b 00 00       	push   $0xb22
 10e:	6a 01                	push   $0x1
 110:	e8 01 06 00 00       	call   716 <printf>
 115:	83 c4 10             	add    $0x10,%esp
 118:	eb 12                	jmp    12c <print_mode+0x9e>
  else
    printf(1, "-");
 11a:	83 ec 08             	sub    $0x8,%esp
 11d:	68 1c 0b 00 00       	push   $0xb1c
 122:	6a 01                	push   $0x1
 124:	e8 ed 05 00 00       	call   716 <printf>
 129:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 133:	83 e0 80             	and    $0xffffff80,%eax
 136:	84 c0                	test   %al,%al
 138:	74 14                	je     14e <print_mode+0xc0>
    printf(1, "w");
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	68 24 0b 00 00       	push   $0xb24
 142:	6a 01                	push   $0x1
 144:	e8 cd 05 00 00       	call   716 <printf>
 149:	83 c4 10             	add    $0x10,%esp
 14c:	eb 12                	jmp    160 <print_mode+0xd2>
  else
    printf(1, "-");
 14e:	83 ec 08             	sub    $0x8,%esp
 151:	68 1c 0b 00 00       	push   $0xb1c
 156:	6a 01                	push   $0x1
 158:	e8 b9 05 00 00       	call   716 <printf>
 15d:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 167:	c0 e8 06             	shr    $0x6,%al
 16a:	83 e0 01             	and    $0x1,%eax
 16d:	0f b6 d0             	movzbl %al,%edx
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 177:	d0 e8                	shr    %al
 179:	83 e0 01             	and    $0x1,%eax
 17c:	0f b6 c0             	movzbl %al,%eax
 17f:	21 d0                	and    %edx,%eax
 181:	85 c0                	test   %eax,%eax
 183:	74 14                	je     199 <print_mode+0x10b>
    printf(1, "S");
 185:	83 ec 08             	sub    $0x8,%esp
 188:	68 26 0b 00 00       	push   $0xb26
 18d:	6a 01                	push   $0x1
 18f:	e8 82 05 00 00       	call   716 <printf>
 194:	83 c4 10             	add    $0x10,%esp
 197:	eb 34                	jmp    1cd <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1a0:	83 e0 40             	and    $0x40,%eax
 1a3:	84 c0                	test   %al,%al
 1a5:	74 14                	je     1bb <print_mode+0x12d>
    printf(1, "x");
 1a7:	83 ec 08             	sub    $0x8,%esp
 1aa:	68 28 0b 00 00       	push   $0xb28
 1af:	6a 01                	push   $0x1
 1b1:	e8 60 05 00 00       	call   716 <printf>
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	eb 12                	jmp    1cd <print_mode+0x13f>
  else
    printf(1, "-");
 1bb:	83 ec 08             	sub    $0x8,%esp
 1be:	68 1c 0b 00 00       	push   $0xb1c
 1c3:	6a 01                	push   $0x1
 1c5:	e8 4c 05 00 00       	call   716 <printf>
 1ca:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1d4:	83 e0 20             	and    $0x20,%eax
 1d7:	84 c0                	test   %al,%al
 1d9:	74 14                	je     1ef <print_mode+0x161>
    printf(1, "r");
 1db:	83 ec 08             	sub    $0x8,%esp
 1de:	68 22 0b 00 00       	push   $0xb22
 1e3:	6a 01                	push   $0x1
 1e5:	e8 2c 05 00 00       	call   716 <printf>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	eb 12                	jmp    201 <print_mode+0x173>
  else
    printf(1, "-");
 1ef:	83 ec 08             	sub    $0x8,%esp
 1f2:	68 1c 0b 00 00       	push   $0xb1c
 1f7:	6a 01                	push   $0x1
 1f9:	e8 18 05 00 00       	call   716 <printf>
 1fe:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 208:	83 e0 10             	and    $0x10,%eax
 20b:	84 c0                	test   %al,%al
 20d:	74 14                	je     223 <print_mode+0x195>
    printf(1, "w");
 20f:	83 ec 08             	sub    $0x8,%esp
 212:	68 24 0b 00 00       	push   $0xb24
 217:	6a 01                	push   $0x1
 219:	e8 f8 04 00 00       	call   716 <printf>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	eb 12                	jmp    235 <print_mode+0x1a7>
  else
    printf(1, "-");
 223:	83 ec 08             	sub    $0x8,%esp
 226:	68 1c 0b 00 00       	push   $0xb1c
 22b:	6a 01                	push   $0x1
 22d:	e8 e4 04 00 00       	call   716 <printf>
 232:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 23c:	83 e0 08             	and    $0x8,%eax
 23f:	84 c0                	test   %al,%al
 241:	74 14                	je     257 <print_mode+0x1c9>
    printf(1, "x");
 243:	83 ec 08             	sub    $0x8,%esp
 246:	68 28 0b 00 00       	push   $0xb28
 24b:	6a 01                	push   $0x1
 24d:	e8 c4 04 00 00       	call   716 <printf>
 252:	83 c4 10             	add    $0x10,%esp
 255:	eb 12                	jmp    269 <print_mode+0x1db>
  else
    printf(1, "-");
 257:	83 ec 08             	sub    $0x8,%esp
 25a:	68 1c 0b 00 00       	push   $0xb1c
 25f:	6a 01                	push   $0x1
 261:	e8 b0 04 00 00       	call   716 <printf>
 266:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 270:	83 e0 04             	and    $0x4,%eax
 273:	84 c0                	test   %al,%al
 275:	74 14                	je     28b <print_mode+0x1fd>
    printf(1, "r");
 277:	83 ec 08             	sub    $0x8,%esp
 27a:	68 22 0b 00 00       	push   $0xb22
 27f:	6a 01                	push   $0x1
 281:	e8 90 04 00 00       	call   716 <printf>
 286:	83 c4 10             	add    $0x10,%esp
 289:	eb 12                	jmp    29d <print_mode+0x20f>
  else
    printf(1, "-");
 28b:	83 ec 08             	sub    $0x8,%esp
 28e:	68 1c 0b 00 00       	push   $0xb1c
 293:	6a 01                	push   $0x1
 295:	e8 7c 04 00 00       	call   716 <printf>
 29a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2a4:	83 e0 02             	and    $0x2,%eax
 2a7:	84 c0                	test   %al,%al
 2a9:	74 14                	je     2bf <print_mode+0x231>
    printf(1, "w");
 2ab:	83 ec 08             	sub    $0x8,%esp
 2ae:	68 24 0b 00 00       	push   $0xb24
 2b3:	6a 01                	push   $0x1
 2b5:	e8 5c 04 00 00       	call   716 <printf>
 2ba:	83 c4 10             	add    $0x10,%esp
 2bd:	eb 12                	jmp    2d1 <print_mode+0x243>
  else
    printf(1, "-");
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	68 1c 0b 00 00       	push   $0xb1c
 2c7:	6a 01                	push   $0x1
 2c9:	e8 48 04 00 00       	call   716 <printf>
 2ce:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2d8:	83 e0 01             	and    $0x1,%eax
 2db:	84 c0                	test   %al,%al
 2dd:	74 14                	je     2f3 <print_mode+0x265>
    printf(1, "x");
 2df:	83 ec 08             	sub    $0x8,%esp
 2e2:	68 28 0b 00 00       	push   $0xb28
 2e7:	6a 01                	push   $0x1
 2e9:	e8 28 04 00 00       	call   716 <printf>
 2ee:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 2f1:	eb 13                	jmp    306 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 2f3:	83 ec 08             	sub    $0x8,%esp
 2f6:	68 1c 0b 00 00       	push   $0xb1c
 2fb:	6a 01                	push   $0x1
 2fd:	e8 14 04 00 00       	call   716 <printf>
 302:	83 c4 10             	add    $0x10,%esp

  return;
 305:	90                   	nop
}
 306:	c9                   	leave  
 307:	c3                   	ret    

00000308 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	57                   	push   %edi
 30c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 30d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 310:	8b 55 10             	mov    0x10(%ebp),%edx
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	89 cb                	mov    %ecx,%ebx
 318:	89 df                	mov    %ebx,%edi
 31a:	89 d1                	mov    %edx,%ecx
 31c:	fc                   	cld    
 31d:	f3 aa                	rep stos %al,%es:(%edi)
 31f:	89 ca                	mov    %ecx,%edx
 321:	89 fb                	mov    %edi,%ebx
 323:	89 5d 08             	mov    %ebx,0x8(%ebp)
 326:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 329:	90                   	nop
 32a:	5b                   	pop    %ebx
 32b:	5f                   	pop    %edi
 32c:	5d                   	pop    %ebp
 32d:	c3                   	ret    

0000032e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 33a:	90                   	nop
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	8d 50 01             	lea    0x1(%eax),%edx
 341:	89 55 08             	mov    %edx,0x8(%ebp)
 344:	8b 55 0c             	mov    0xc(%ebp),%edx
 347:	8d 4a 01             	lea    0x1(%edx),%ecx
 34a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 34d:	0f b6 12             	movzbl (%edx),%edx
 350:	88 10                	mov    %dl,(%eax)
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	84 c0                	test   %al,%al
 357:	75 e2                	jne    33b <strcpy+0xd>
    ;
  return os;
 359:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 361:	eb 08                	jmp    36b <strcmp+0xd>
    p++, q++;
 363:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 367:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	84 c0                	test   %al,%al
 373:	74 10                	je     385 <strcmp+0x27>
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	0f b6 10             	movzbl (%eax),%edx
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	38 c2                	cmp    %al,%dl
 383:	74 de                	je     363 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	0f b6 d0             	movzbl %al,%edx
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	0f b6 c0             	movzbl %al,%eax
 397:	29 c2                	sub    %eax,%edx
 399:	89 d0                	mov    %edx,%eax
}
 39b:	5d                   	pop    %ebp
 39c:	c3                   	ret    

0000039d <strlen>:

uint
strlen(char *s)
{
 39d:	55                   	push   %ebp
 39e:	89 e5                	mov    %esp,%ebp
 3a0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3aa:	eb 04                	jmp    3b0 <strlen+0x13>
 3ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	01 d0                	add    %edx,%eax
 3b8:	0f b6 00             	movzbl (%eax),%eax
 3bb:	84 c0                	test   %al,%al
 3bd:	75 ed                	jne    3ac <strlen+0xf>
    ;
  return n;
 3bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c2:	c9                   	leave  
 3c3:	c3                   	ret    

000003c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3c7:	8b 45 10             	mov    0x10(%ebp),%eax
 3ca:	50                   	push   %eax
 3cb:	ff 75 0c             	pushl  0xc(%ebp)
 3ce:	ff 75 08             	pushl  0x8(%ebp)
 3d1:	e8 32 ff ff ff       	call   308 <stosb>
 3d6:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <strchr>:

char*
strchr(const char *s, char c)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	83 ec 04             	sub    $0x4,%esp
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3ea:	eb 14                	jmp    400 <strchr+0x22>
    if(*s == c)
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3f5:	75 05                	jne    3fc <strchr+0x1e>
      return (char*)s;
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	eb 13                	jmp    40f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	0f b6 00             	movzbl (%eax),%eax
 406:	84 c0                	test   %al,%al
 408:	75 e2                	jne    3ec <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 40a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    

00000411 <gets>:

char*
gets(char *buf, int max)
{
 411:	55                   	push   %ebp
 412:	89 e5                	mov    %esp,%ebp
 414:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 41e:	eb 42                	jmp    462 <gets+0x51>
    cc = read(0, &c, 1);
 420:	83 ec 04             	sub    $0x4,%esp
 423:	6a 01                	push   $0x1
 425:	8d 45 ef             	lea    -0x11(%ebp),%eax
 428:	50                   	push   %eax
 429:	6a 00                	push   $0x0
 42b:	e8 47 01 00 00       	call   577 <read>
 430:	83 c4 10             	add    $0x10,%esp
 433:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43a:	7e 33                	jle    46f <gets+0x5e>
      break;
    buf[i++] = c;
 43c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43f:	8d 50 01             	lea    0x1(%eax),%edx
 442:	89 55 f4             	mov    %edx,-0xc(%ebp)
 445:	89 c2                	mov    %eax,%edx
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	01 c2                	add    %eax,%edx
 44c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 450:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 452:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 456:	3c 0a                	cmp    $0xa,%al
 458:	74 16                	je     470 <gets+0x5f>
 45a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 45e:	3c 0d                	cmp    $0xd,%al
 460:	74 0e                	je     470 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 465:	83 c0 01             	add    $0x1,%eax
 468:	3b 45 0c             	cmp    0xc(%ebp),%eax
 46b:	7c b3                	jl     420 <gets+0xf>
 46d:	eb 01                	jmp    470 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 46f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 470:	8b 55 f4             	mov    -0xc(%ebp),%edx
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	01 d0                	add    %edx,%eax
 478:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 47e:	c9                   	leave  
 47f:	c3                   	ret    

00000480 <stat>:

int
stat(char *n, struct stat *st)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 486:	83 ec 08             	sub    $0x8,%esp
 489:	6a 00                	push   $0x0
 48b:	ff 75 08             	pushl  0x8(%ebp)
 48e:	e8 0c 01 00 00       	call   59f <open>
 493:	83 c4 10             	add    $0x10,%esp
 496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49d:	79 07                	jns    4a6 <stat+0x26>
    return -1;
 49f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4a4:	eb 25                	jmp    4cb <stat+0x4b>
  r = fstat(fd, st);
 4a6:	83 ec 08             	sub    $0x8,%esp
 4a9:	ff 75 0c             	pushl  0xc(%ebp)
 4ac:	ff 75 f4             	pushl  -0xc(%ebp)
 4af:	e8 03 01 00 00       	call   5b7 <fstat>
 4b4:	83 c4 10             	add    $0x10,%esp
 4b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4ba:	83 ec 0c             	sub    $0xc,%esp
 4bd:	ff 75 f4             	pushl  -0xc(%ebp)
 4c0:	e8 c2 00 00 00       	call   587 <close>
 4c5:	83 c4 10             	add    $0x10,%esp
  return r;
 4c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <atoi>:

int
atoi(const char *s)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4da:	eb 25                	jmp    501 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4df:	89 d0                	mov    %edx,%eax
 4e1:	c1 e0 02             	shl    $0x2,%eax
 4e4:	01 d0                	add    %edx,%eax
 4e6:	01 c0                	add    %eax,%eax
 4e8:	89 c1                	mov    %eax,%ecx
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	8d 50 01             	lea    0x1(%eax),%edx
 4f0:	89 55 08             	mov    %edx,0x8(%ebp)
 4f3:	0f b6 00             	movzbl (%eax),%eax
 4f6:	0f be c0             	movsbl %al,%eax
 4f9:	01 c8                	add    %ecx,%eax
 4fb:	83 e8 30             	sub    $0x30,%eax
 4fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	3c 2f                	cmp    $0x2f,%al
 509:	7e 0a                	jle    515 <atoi+0x48>
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	0f b6 00             	movzbl (%eax),%eax
 511:	3c 39                	cmp    $0x39,%al
 513:	7e c7                	jle    4dc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 515:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 51a:	55                   	push   %ebp
 51b:	89 e5                	mov    %esp,%ebp
 51d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 526:	8b 45 0c             	mov    0xc(%ebp),%eax
 529:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 52c:	eb 17                	jmp    545 <memmove+0x2b>
    *dst++ = *src++;
 52e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 531:	8d 50 01             	lea    0x1(%eax),%edx
 534:	89 55 fc             	mov    %edx,-0x4(%ebp)
 537:	8b 55 f8             	mov    -0x8(%ebp),%edx
 53a:	8d 4a 01             	lea    0x1(%edx),%ecx
 53d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 540:	0f b6 12             	movzbl (%edx),%edx
 543:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 545:	8b 45 10             	mov    0x10(%ebp),%eax
 548:	8d 50 ff             	lea    -0x1(%eax),%edx
 54b:	89 55 10             	mov    %edx,0x10(%ebp)
 54e:	85 c0                	test   %eax,%eax
 550:	7f dc                	jg     52e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 552:	8b 45 08             	mov    0x8(%ebp),%eax
}
 555:	c9                   	leave  
 556:	c3                   	ret    

00000557 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 557:	b8 01 00 00 00       	mov    $0x1,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <exit>:
SYSCALL(exit)
 55f:	b8 02 00 00 00       	mov    $0x2,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <wait>:
SYSCALL(wait)
 567:	b8 03 00 00 00       	mov    $0x3,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <pipe>:
SYSCALL(pipe)
 56f:	b8 04 00 00 00       	mov    $0x4,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <read>:
SYSCALL(read)
 577:	b8 05 00 00 00       	mov    $0x5,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <write>:
SYSCALL(write)
 57f:	b8 10 00 00 00       	mov    $0x10,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <close>:
SYSCALL(close)
 587:	b8 15 00 00 00       	mov    $0x15,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <kill>:
SYSCALL(kill)
 58f:	b8 06 00 00 00       	mov    $0x6,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <exec>:
SYSCALL(exec)
 597:	b8 07 00 00 00       	mov    $0x7,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <open>:
SYSCALL(open)
 59f:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <mknod>:
SYSCALL(mknod)
 5a7:	b8 11 00 00 00       	mov    $0x11,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <unlink>:
SYSCALL(unlink)
 5af:	b8 12 00 00 00       	mov    $0x12,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <fstat>:
SYSCALL(fstat)
 5b7:	b8 08 00 00 00       	mov    $0x8,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <link>:
SYSCALL(link)
 5bf:	b8 13 00 00 00       	mov    $0x13,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <mkdir>:
SYSCALL(mkdir)
 5c7:	b8 14 00 00 00       	mov    $0x14,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <chdir>:
SYSCALL(chdir)
 5cf:	b8 09 00 00 00       	mov    $0x9,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <dup>:
SYSCALL(dup)
 5d7:	b8 0a 00 00 00       	mov    $0xa,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <getpid>:
SYSCALL(getpid)
 5df:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <sbrk>:
SYSCALL(sbrk)
 5e7:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <sleep>:
SYSCALL(sleep)
 5ef:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <uptime>:
SYSCALL(uptime)
 5f7:	b8 0e 00 00 00       	mov    $0xe,%eax
 5fc:	cd 40                	int    $0x40
 5fe:	c3                   	ret    

000005ff <halt>:
SYSCALL(halt)
 5ff:	b8 16 00 00 00       	mov    $0x16,%eax
 604:	cd 40                	int    $0x40
 606:	c3                   	ret    

00000607 <date>:
//Student Implementations 
SYSCALL(date)
 607:	b8 17 00 00 00       	mov    $0x17,%eax
 60c:	cd 40                	int    $0x40
 60e:	c3                   	ret    

0000060f <getuid>:

SYSCALL(getuid)
 60f:	b8 18 00 00 00       	mov    $0x18,%eax
 614:	cd 40                	int    $0x40
 616:	c3                   	ret    

00000617 <getgid>:
SYSCALL(getgid)
 617:	b8 19 00 00 00       	mov    $0x19,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <getppid>:
SYSCALL(getppid)
 61f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <setuid>:

SYSCALL(setuid)
 627:	b8 1b 00 00 00       	mov    $0x1b,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <setgid>:
SYSCALL(setgid)
 62f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <getprocs>:
SYSCALL(getprocs)
 637:	b8 1d 00 00 00       	mov    $0x1d,%eax
 63c:	cd 40                	int    $0x40
 63e:	c3                   	ret    

0000063f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 63f:	55                   	push   %ebp
 640:	89 e5                	mov    %esp,%ebp
 642:	83 ec 18             	sub    $0x18,%esp
 645:	8b 45 0c             	mov    0xc(%ebp),%eax
 648:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64b:	83 ec 04             	sub    $0x4,%esp
 64e:	6a 01                	push   $0x1
 650:	8d 45 f4             	lea    -0xc(%ebp),%eax
 653:	50                   	push   %eax
 654:	ff 75 08             	pushl  0x8(%ebp)
 657:	e8 23 ff ff ff       	call   57f <write>
 65c:	83 c4 10             	add    $0x10,%esp
}
 65f:	90                   	nop
 660:	c9                   	leave  
 661:	c3                   	ret    

00000662 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 662:	55                   	push   %ebp
 663:	89 e5                	mov    %esp,%ebp
 665:	53                   	push   %ebx
 666:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 669:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 670:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 674:	74 17                	je     68d <printint+0x2b>
 676:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 67a:	79 11                	jns    68d <printint+0x2b>
    neg = 1;
 67c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 683:	8b 45 0c             	mov    0xc(%ebp),%eax
 686:	f7 d8                	neg    %eax
 688:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68b:	eb 06                	jmp    693 <printint+0x31>
  } else {
    x = xx;
 68d:	8b 45 0c             	mov    0xc(%ebp),%eax
 690:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 69a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 69d:	8d 41 01             	lea    0x1(%ecx),%eax
 6a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a9:	ba 00 00 00 00       	mov    $0x0,%edx
 6ae:	f7 f3                	div    %ebx
 6b0:	89 d0                	mov    %edx,%eax
 6b2:	0f b6 80 bc 0d 00 00 	movzbl 0xdbc(%eax),%eax
 6b9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c3:	ba 00 00 00 00       	mov    $0x0,%edx
 6c8:	f7 f3                	div    %ebx
 6ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d1:	75 c7                	jne    69a <printint+0x38>
  if(neg)
 6d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d7:	74 2d                	je     706 <printint+0xa4>
    buf[i++] = '-';
 6d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6dc:	8d 50 01             	lea    0x1(%eax),%edx
 6df:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6e7:	eb 1d                	jmp    706 <printint+0xa4>
    putc(fd, buf[i]);
 6e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	01 d0                	add    %edx,%eax
 6f1:	0f b6 00             	movzbl (%eax),%eax
 6f4:	0f be c0             	movsbl %al,%eax
 6f7:	83 ec 08             	sub    $0x8,%esp
 6fa:	50                   	push   %eax
 6fb:	ff 75 08             	pushl  0x8(%ebp)
 6fe:	e8 3c ff ff ff       	call   63f <putc>
 703:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 706:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 70a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 70e:	79 d9                	jns    6e9 <printint+0x87>
    putc(fd, buf[i]);
}
 710:	90                   	nop
 711:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 714:	c9                   	leave  
 715:	c3                   	ret    

00000716 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 716:	55                   	push   %ebp
 717:	89 e5                	mov    %esp,%ebp
 719:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 71c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 723:	8d 45 0c             	lea    0xc(%ebp),%eax
 726:	83 c0 04             	add    $0x4,%eax
 729:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 72c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 733:	e9 59 01 00 00       	jmp    891 <printf+0x17b>
    c = fmt[i] & 0xff;
 738:	8b 55 0c             	mov    0xc(%ebp),%edx
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	01 d0                	add    %edx,%eax
 740:	0f b6 00             	movzbl (%eax),%eax
 743:	0f be c0             	movsbl %al,%eax
 746:	25 ff 00 00 00       	and    $0xff,%eax
 74b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 74e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 752:	75 2c                	jne    780 <printf+0x6a>
      if(c == '%'){
 754:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 758:	75 0c                	jne    766 <printf+0x50>
        state = '%';
 75a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 761:	e9 27 01 00 00       	jmp    88d <printf+0x177>
      } else {
        putc(fd, c);
 766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 769:	0f be c0             	movsbl %al,%eax
 76c:	83 ec 08             	sub    $0x8,%esp
 76f:	50                   	push   %eax
 770:	ff 75 08             	pushl  0x8(%ebp)
 773:	e8 c7 fe ff ff       	call   63f <putc>
 778:	83 c4 10             	add    $0x10,%esp
 77b:	e9 0d 01 00 00       	jmp    88d <printf+0x177>
      }
    } else if(state == '%'){
 780:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 784:	0f 85 03 01 00 00    	jne    88d <printf+0x177>
      if(c == 'd'){
 78a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 78e:	75 1e                	jne    7ae <printf+0x98>
        printint(fd, *ap, 10, 1);
 790:	8b 45 e8             	mov    -0x18(%ebp),%eax
 793:	8b 00                	mov    (%eax),%eax
 795:	6a 01                	push   $0x1
 797:	6a 0a                	push   $0xa
 799:	50                   	push   %eax
 79a:	ff 75 08             	pushl  0x8(%ebp)
 79d:	e8 c0 fe ff ff       	call   662 <printint>
 7a2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a9:	e9 d8 00 00 00       	jmp    886 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7ae:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b2:	74 06                	je     7ba <printf+0xa4>
 7b4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b8:	75 1e                	jne    7d8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	6a 00                	push   $0x0
 7c1:	6a 10                	push   $0x10
 7c3:	50                   	push   %eax
 7c4:	ff 75 08             	pushl  0x8(%ebp)
 7c7:	e8 96 fe ff ff       	call   662 <printint>
 7cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 7cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d3:	e9 ae 00 00 00       	jmp    886 <printf+0x170>
      } else if(c == 's'){
 7d8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7dc:	75 43                	jne    821 <printf+0x10b>
        s = (char*)*ap;
 7de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e1:	8b 00                	mov    (%eax),%eax
 7e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ee:	75 25                	jne    815 <printf+0xff>
          s = "(null)";
 7f0:	c7 45 f4 2a 0b 00 00 	movl   $0xb2a,-0xc(%ebp)
        while(*s != 0){
 7f7:	eb 1c                	jmp    815 <printf+0xff>
          putc(fd, *s);
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	0f b6 00             	movzbl (%eax),%eax
 7ff:	0f be c0             	movsbl %al,%eax
 802:	83 ec 08             	sub    $0x8,%esp
 805:	50                   	push   %eax
 806:	ff 75 08             	pushl  0x8(%ebp)
 809:	e8 31 fe ff ff       	call   63f <putc>
 80e:	83 c4 10             	add    $0x10,%esp
          s++;
 811:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	0f b6 00             	movzbl (%eax),%eax
 81b:	84 c0                	test   %al,%al
 81d:	75 da                	jne    7f9 <printf+0xe3>
 81f:	eb 65                	jmp    886 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 821:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 825:	75 1d                	jne    844 <printf+0x12e>
        putc(fd, *ap);
 827:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82a:	8b 00                	mov    (%eax),%eax
 82c:	0f be c0             	movsbl %al,%eax
 82f:	83 ec 08             	sub    $0x8,%esp
 832:	50                   	push   %eax
 833:	ff 75 08             	pushl  0x8(%ebp)
 836:	e8 04 fe ff ff       	call   63f <putc>
 83b:	83 c4 10             	add    $0x10,%esp
        ap++;
 83e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 842:	eb 42                	jmp    886 <printf+0x170>
      } else if(c == '%'){
 844:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 848:	75 17                	jne    861 <printf+0x14b>
        putc(fd, c);
 84a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 84d:	0f be c0             	movsbl %al,%eax
 850:	83 ec 08             	sub    $0x8,%esp
 853:	50                   	push   %eax
 854:	ff 75 08             	pushl  0x8(%ebp)
 857:	e8 e3 fd ff ff       	call   63f <putc>
 85c:	83 c4 10             	add    $0x10,%esp
 85f:	eb 25                	jmp    886 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 861:	83 ec 08             	sub    $0x8,%esp
 864:	6a 25                	push   $0x25
 866:	ff 75 08             	pushl  0x8(%ebp)
 869:	e8 d1 fd ff ff       	call   63f <putc>
 86e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 874:	0f be c0             	movsbl %al,%eax
 877:	83 ec 08             	sub    $0x8,%esp
 87a:	50                   	push   %eax
 87b:	ff 75 08             	pushl  0x8(%ebp)
 87e:	e8 bc fd ff ff       	call   63f <putc>
 883:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 886:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 88d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 891:	8b 55 0c             	mov    0xc(%ebp),%edx
 894:	8b 45 f0             	mov    -0x10(%ebp),%eax
 897:	01 d0                	add    %edx,%eax
 899:	0f b6 00             	movzbl (%eax),%eax
 89c:	84 c0                	test   %al,%al
 89e:	0f 85 94 fe ff ff    	jne    738 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8a4:	90                   	nop
 8a5:	c9                   	leave  
 8a6:	c3                   	ret    

000008a7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a7:	55                   	push   %ebp
 8a8:	89 e5                	mov    %esp,%ebp
 8aa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ad:	8b 45 08             	mov    0x8(%ebp),%eax
 8b0:	83 e8 08             	sub    $0x8,%eax
 8b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 8bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8be:	eb 24                	jmp    8e4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	8b 00                	mov    (%eax),%eax
 8c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c8:	77 12                	ja     8dc <free+0x35>
 8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d0:	77 24                	ja     8f6 <free+0x4f>
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 00                	mov    (%eax),%eax
 8d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8da:	77 1a                	ja     8f6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ea:	76 d4                	jbe    8c0 <free+0x19>
 8ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f4:	76 ca                	jbe    8c0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f9:	8b 40 04             	mov    0x4(%eax),%eax
 8fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 903:	8b 45 f8             	mov    -0x8(%ebp),%eax
 906:	01 c2                	add    %eax,%edx
 908:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90b:	8b 00                	mov    (%eax),%eax
 90d:	39 c2                	cmp    %eax,%edx
 90f:	75 24                	jne    935 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 911:	8b 45 f8             	mov    -0x8(%ebp),%eax
 914:	8b 50 04             	mov    0x4(%eax),%edx
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	8b 40 04             	mov    0x4(%eax),%eax
 91f:	01 c2                	add    %eax,%edx
 921:	8b 45 f8             	mov    -0x8(%ebp),%eax
 924:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	8b 10                	mov    (%eax),%edx
 92e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 931:	89 10                	mov    %edx,(%eax)
 933:	eb 0a                	jmp    93f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 10                	mov    (%eax),%edx
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94f:	01 d0                	add    %edx,%eax
 951:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 954:	75 20                	jne    976 <free+0xcf>
    p->s.size += bp->s.size;
 956:	8b 45 fc             	mov    -0x4(%ebp),%eax
 959:	8b 50 04             	mov    0x4(%eax),%edx
 95c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95f:	8b 40 04             	mov    0x4(%eax),%eax
 962:	01 c2                	add    %eax,%edx
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	8b 10                	mov    (%eax),%edx
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	89 10                	mov    %edx,(%eax)
 974:	eb 08                	jmp    97e <free+0xd7>
  } else
    p->s.ptr = bp;
 976:	8b 45 fc             	mov    -0x4(%ebp),%eax
 979:	8b 55 f8             	mov    -0x8(%ebp),%edx
 97c:	89 10                	mov    %edx,(%eax)
  freep = p;
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	a3 d8 0d 00 00       	mov    %eax,0xdd8
}
 986:	90                   	nop
 987:	c9                   	leave  
 988:	c3                   	ret    

00000989 <morecore>:

static Header*
morecore(uint nu)
{
 989:	55                   	push   %ebp
 98a:	89 e5                	mov    %esp,%ebp
 98c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 98f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 996:	77 07                	ja     99f <morecore+0x16>
    nu = 4096;
 998:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 99f:	8b 45 08             	mov    0x8(%ebp),%eax
 9a2:	c1 e0 03             	shl    $0x3,%eax
 9a5:	83 ec 0c             	sub    $0xc,%esp
 9a8:	50                   	push   %eax
 9a9:	e8 39 fc ff ff       	call   5e7 <sbrk>
 9ae:	83 c4 10             	add    $0x10,%esp
 9b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b8:	75 07                	jne    9c1 <morecore+0x38>
    return 0;
 9ba:	b8 00 00 00 00       	mov    $0x0,%eax
 9bf:	eb 26                	jmp    9e7 <morecore+0x5e>
  hp = (Header*)p;
 9c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ca:	8b 55 08             	mov    0x8(%ebp),%edx
 9cd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d3:	83 c0 08             	add    $0x8,%eax
 9d6:	83 ec 0c             	sub    $0xc,%esp
 9d9:	50                   	push   %eax
 9da:	e8 c8 fe ff ff       	call   8a7 <free>
 9df:	83 c4 10             	add    $0x10,%esp
  return freep;
 9e2:	a1 d8 0d 00 00       	mov    0xdd8,%eax
}
 9e7:	c9                   	leave  
 9e8:	c3                   	ret    

000009e9 <malloc>:

void*
malloc(uint nbytes)
{
 9e9:	55                   	push   %ebp
 9ea:	89 e5                	mov    %esp,%ebp
 9ec:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ef:	8b 45 08             	mov    0x8(%ebp),%eax
 9f2:	83 c0 07             	add    $0x7,%eax
 9f5:	c1 e8 03             	shr    $0x3,%eax
 9f8:	83 c0 01             	add    $0x1,%eax
 9fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9fe:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a0a:	75 23                	jne    a2f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a0c:	c7 45 f0 d0 0d 00 00 	movl   $0xdd0,-0x10(%ebp)
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	a3 d8 0d 00 00       	mov    %eax,0xdd8
 a1b:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 a20:	a3 d0 0d 00 00       	mov    %eax,0xdd0
    base.s.size = 0;
 a25:	c7 05 d4 0d 00 00 00 	movl   $0x0,0xdd4
 a2c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a32:	8b 00                	mov    (%eax),%eax
 a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	8b 40 04             	mov    0x4(%eax),%eax
 a3d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a40:	72 4d                	jb     a8f <malloc+0xa6>
      if(p->s.size == nunits)
 a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a45:	8b 40 04             	mov    0x4(%eax),%eax
 a48:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a4b:	75 0c                	jne    a59 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 10                	mov    (%eax),%edx
 a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a55:	89 10                	mov    %edx,(%eax)
 a57:	eb 26                	jmp    a7f <malloc+0x96>
      else {
        p->s.size -= nunits;
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	8b 40 04             	mov    0x4(%eax),%eax
 a5f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a62:	89 c2                	mov    %eax,%edx
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	8b 40 04             	mov    0x4(%eax),%eax
 a70:	c1 e0 03             	shl    $0x3,%eax
 a73:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a79:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a7c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a82:	a3 d8 0d 00 00       	mov    %eax,0xdd8
      return (void*)(p + 1);
 a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8a:	83 c0 08             	add    $0x8,%eax
 a8d:	eb 3b                	jmp    aca <malloc+0xe1>
    }
    if(p == freep)
 a8f:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 a94:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a97:	75 1e                	jne    ab7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a99:	83 ec 0c             	sub    $0xc,%esp
 a9c:	ff 75 ec             	pushl  -0x14(%ebp)
 a9f:	e8 e5 fe ff ff       	call   989 <morecore>
 aa4:	83 c4 10             	add    $0x10,%esp
 aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aae:	75 07                	jne    ab7 <malloc+0xce>
        return 0;
 ab0:	b8 00 00 00 00       	mov    $0x0,%eax
 ab5:	eb 13                	jmp    aca <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8b 00                	mov    (%eax),%eax
 ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ac5:	e9 6d ff ff ff       	jmp    a37 <malloc+0x4e>
}
 aca:	c9                   	leave  
 acb:	c3                   	ret    
