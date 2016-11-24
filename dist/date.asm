
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
  2a:	68 e4 0a 00 00       	push   $0xae4
  2f:	6a 02                	push   $0x2
  31:	e8 f8 06 00 00       	call   72e <printf>
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
  69:	68 f4 0a 00 00       	push   $0xaf4
  6e:	6a 01                	push   $0x1
  70:	e8 b9 06 00 00       	call   72e <printf>
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
  ad:	68 32 0b 00 00       	push   $0xb32
  b2:	6a 01                	push   $0x1
  b4:	e8 75 06 00 00       	call   72e <printf>
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	eb 3a                	jmp    f8 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  be:	83 ec 08             	sub    $0x8,%esp
  c1:	68 34 0b 00 00       	push   $0xb34
  c6:	6a 01                	push   $0x1
  c8:	e8 61 06 00 00       	call   72e <printf>
  cd:	83 c4 10             	add    $0x10,%esp
  d0:	eb 26                	jmp    f8 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 36 0b 00 00       	push   $0xb36
  da:	6a 01                	push   $0x1
  dc:	e8 4d 06 00 00       	call   72e <printf>
  e1:	83 c4 10             	add    $0x10,%esp
  e4:	eb 12                	jmp    f8 <print_mode+0x6a>
    default: printf(1, "?");
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	68 38 0b 00 00       	push   $0xb38
  ee:	6a 01                	push   $0x1
  f0:	e8 39 06 00 00       	call   72e <printf>
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
 109:	68 3a 0b 00 00       	push   $0xb3a
 10e:	6a 01                	push   $0x1
 110:	e8 19 06 00 00       	call   72e <printf>
 115:	83 c4 10             	add    $0x10,%esp
 118:	eb 12                	jmp    12c <print_mode+0x9e>
  else
    printf(1, "-");
 11a:	83 ec 08             	sub    $0x8,%esp
 11d:	68 34 0b 00 00       	push   $0xb34
 122:	6a 01                	push   $0x1
 124:	e8 05 06 00 00       	call   72e <printf>
 129:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 133:	83 e0 80             	and    $0xffffff80,%eax
 136:	84 c0                	test   %al,%al
 138:	74 14                	je     14e <print_mode+0xc0>
    printf(1, "w");
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	68 3c 0b 00 00       	push   $0xb3c
 142:	6a 01                	push   $0x1
 144:	e8 e5 05 00 00       	call   72e <printf>
 149:	83 c4 10             	add    $0x10,%esp
 14c:	eb 12                	jmp    160 <print_mode+0xd2>
  else
    printf(1, "-");
 14e:	83 ec 08             	sub    $0x8,%esp
 151:	68 34 0b 00 00       	push   $0xb34
 156:	6a 01                	push   $0x1
 158:	e8 d1 05 00 00       	call   72e <printf>
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
 188:	68 3e 0b 00 00       	push   $0xb3e
 18d:	6a 01                	push   $0x1
 18f:	e8 9a 05 00 00       	call   72e <printf>
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
 1aa:	68 40 0b 00 00       	push   $0xb40
 1af:	6a 01                	push   $0x1
 1b1:	e8 78 05 00 00       	call   72e <printf>
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	eb 12                	jmp    1cd <print_mode+0x13f>
  else
    printf(1, "-");
 1bb:	83 ec 08             	sub    $0x8,%esp
 1be:	68 34 0b 00 00       	push   $0xb34
 1c3:	6a 01                	push   $0x1
 1c5:	e8 64 05 00 00       	call   72e <printf>
 1ca:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1d4:	83 e0 20             	and    $0x20,%eax
 1d7:	84 c0                	test   %al,%al
 1d9:	74 14                	je     1ef <print_mode+0x161>
    printf(1, "r");
 1db:	83 ec 08             	sub    $0x8,%esp
 1de:	68 3a 0b 00 00       	push   $0xb3a
 1e3:	6a 01                	push   $0x1
 1e5:	e8 44 05 00 00       	call   72e <printf>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	eb 12                	jmp    201 <print_mode+0x173>
  else
    printf(1, "-");
 1ef:	83 ec 08             	sub    $0x8,%esp
 1f2:	68 34 0b 00 00       	push   $0xb34
 1f7:	6a 01                	push   $0x1
 1f9:	e8 30 05 00 00       	call   72e <printf>
 1fe:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 208:	83 e0 10             	and    $0x10,%eax
 20b:	84 c0                	test   %al,%al
 20d:	74 14                	je     223 <print_mode+0x195>
    printf(1, "w");
 20f:	83 ec 08             	sub    $0x8,%esp
 212:	68 3c 0b 00 00       	push   $0xb3c
 217:	6a 01                	push   $0x1
 219:	e8 10 05 00 00       	call   72e <printf>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	eb 12                	jmp    235 <print_mode+0x1a7>
  else
    printf(1, "-");
 223:	83 ec 08             	sub    $0x8,%esp
 226:	68 34 0b 00 00       	push   $0xb34
 22b:	6a 01                	push   $0x1
 22d:	e8 fc 04 00 00       	call   72e <printf>
 232:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 23c:	83 e0 08             	and    $0x8,%eax
 23f:	84 c0                	test   %al,%al
 241:	74 14                	je     257 <print_mode+0x1c9>
    printf(1, "x");
 243:	83 ec 08             	sub    $0x8,%esp
 246:	68 40 0b 00 00       	push   $0xb40
 24b:	6a 01                	push   $0x1
 24d:	e8 dc 04 00 00       	call   72e <printf>
 252:	83 c4 10             	add    $0x10,%esp
 255:	eb 12                	jmp    269 <print_mode+0x1db>
  else
    printf(1, "-");
 257:	83 ec 08             	sub    $0x8,%esp
 25a:	68 34 0b 00 00       	push   $0xb34
 25f:	6a 01                	push   $0x1
 261:	e8 c8 04 00 00       	call   72e <printf>
 266:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 270:	83 e0 04             	and    $0x4,%eax
 273:	84 c0                	test   %al,%al
 275:	74 14                	je     28b <print_mode+0x1fd>
    printf(1, "r");
 277:	83 ec 08             	sub    $0x8,%esp
 27a:	68 3a 0b 00 00       	push   $0xb3a
 27f:	6a 01                	push   $0x1
 281:	e8 a8 04 00 00       	call   72e <printf>
 286:	83 c4 10             	add    $0x10,%esp
 289:	eb 12                	jmp    29d <print_mode+0x20f>
  else
    printf(1, "-");
 28b:	83 ec 08             	sub    $0x8,%esp
 28e:	68 34 0b 00 00       	push   $0xb34
 293:	6a 01                	push   $0x1
 295:	e8 94 04 00 00       	call   72e <printf>
 29a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2a4:	83 e0 02             	and    $0x2,%eax
 2a7:	84 c0                	test   %al,%al
 2a9:	74 14                	je     2bf <print_mode+0x231>
    printf(1, "w");
 2ab:	83 ec 08             	sub    $0x8,%esp
 2ae:	68 3c 0b 00 00       	push   $0xb3c
 2b3:	6a 01                	push   $0x1
 2b5:	e8 74 04 00 00       	call   72e <printf>
 2ba:	83 c4 10             	add    $0x10,%esp
 2bd:	eb 12                	jmp    2d1 <print_mode+0x243>
  else
    printf(1, "-");
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	68 34 0b 00 00       	push   $0xb34
 2c7:	6a 01                	push   $0x1
 2c9:	e8 60 04 00 00       	call   72e <printf>
 2ce:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2d8:	83 e0 01             	and    $0x1,%eax
 2db:	84 c0                	test   %al,%al
 2dd:	74 14                	je     2f3 <print_mode+0x265>
    printf(1, "x");
 2df:	83 ec 08             	sub    $0x8,%esp
 2e2:	68 40 0b 00 00       	push   $0xb40
 2e7:	6a 01                	push   $0x1
 2e9:	e8 40 04 00 00       	call   72e <printf>
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
 2f6:	68 34 0b 00 00       	push   $0xb34
 2fb:	6a 01                	push   $0x1
 2fd:	e8 2c 04 00 00       	call   72e <printf>
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

0000063f <chown>:

SYSCALL(chown)
 63f:	b8 1e 00 00 00       	mov    $0x1e,%eax
 644:	cd 40                	int    $0x40
 646:	c3                   	ret    

00000647 <chgrp>:
SYSCALL(chgrp)
 647:	b8 1f 00 00 00       	mov    $0x1f,%eax
 64c:	cd 40                	int    $0x40
 64e:	c3                   	ret    

0000064f <chmod>:
SYSCALL(chmod)
 64f:	b8 20 00 00 00       	mov    $0x20,%eax
 654:	cd 40                	int    $0x40
 656:	c3                   	ret    

00000657 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 657:	55                   	push   %ebp
 658:	89 e5                	mov    %esp,%ebp
 65a:	83 ec 18             	sub    $0x18,%esp
 65d:	8b 45 0c             	mov    0xc(%ebp),%eax
 660:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 663:	83 ec 04             	sub    $0x4,%esp
 666:	6a 01                	push   $0x1
 668:	8d 45 f4             	lea    -0xc(%ebp),%eax
 66b:	50                   	push   %eax
 66c:	ff 75 08             	pushl  0x8(%ebp)
 66f:	e8 0b ff ff ff       	call   57f <write>
 674:	83 c4 10             	add    $0x10,%esp
}
 677:	90                   	nop
 678:	c9                   	leave  
 679:	c3                   	ret    

0000067a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 67a:	55                   	push   %ebp
 67b:	89 e5                	mov    %esp,%ebp
 67d:	53                   	push   %ebx
 67e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 688:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 68c:	74 17                	je     6a5 <printint+0x2b>
 68e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 692:	79 11                	jns    6a5 <printint+0x2b>
    neg = 1;
 694:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 69b:	8b 45 0c             	mov    0xc(%ebp),%eax
 69e:	f7 d8                	neg    %eax
 6a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6a3:	eb 06                	jmp    6ab <printint+0x31>
  } else {
    x = xx;
 6a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6b2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6b5:	8d 41 01             	lea    0x1(%ecx),%eax
 6b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c1:	ba 00 00 00 00       	mov    $0x0,%edx
 6c6:	f7 f3                	div    %ebx
 6c8:	89 d0                	mov    %edx,%eax
 6ca:	0f b6 80 d4 0d 00 00 	movzbl 0xdd4(%eax),%eax
 6d1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6db:	ba 00 00 00 00       	mov    $0x0,%edx
 6e0:	f7 f3                	div    %ebx
 6e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e9:	75 c7                	jne    6b2 <printint+0x38>
  if(neg)
 6eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ef:	74 2d                	je     71e <printint+0xa4>
    buf[i++] = '-';
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	8d 50 01             	lea    0x1(%eax),%edx
 6f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6fa:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ff:	eb 1d                	jmp    71e <printint+0xa4>
    putc(fd, buf[i]);
 701:	8d 55 dc             	lea    -0x24(%ebp),%edx
 704:	8b 45 f4             	mov    -0xc(%ebp),%eax
 707:	01 d0                	add    %edx,%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	0f be c0             	movsbl %al,%eax
 70f:	83 ec 08             	sub    $0x8,%esp
 712:	50                   	push   %eax
 713:	ff 75 08             	pushl  0x8(%ebp)
 716:	e8 3c ff ff ff       	call   657 <putc>
 71b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 71e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 722:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 726:	79 d9                	jns    701 <printint+0x87>
    putc(fd, buf[i]);
}
 728:	90                   	nop
 729:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 72c:	c9                   	leave  
 72d:	c3                   	ret    

0000072e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 72e:	55                   	push   %ebp
 72f:	89 e5                	mov    %esp,%ebp
 731:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 734:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 73b:	8d 45 0c             	lea    0xc(%ebp),%eax
 73e:	83 c0 04             	add    $0x4,%eax
 741:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 744:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 74b:	e9 59 01 00 00       	jmp    8a9 <printf+0x17b>
    c = fmt[i] & 0xff;
 750:	8b 55 0c             	mov    0xc(%ebp),%edx
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	01 d0                	add    %edx,%eax
 758:	0f b6 00             	movzbl (%eax),%eax
 75b:	0f be c0             	movsbl %al,%eax
 75e:	25 ff 00 00 00       	and    $0xff,%eax
 763:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 766:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 76a:	75 2c                	jne    798 <printf+0x6a>
      if(c == '%'){
 76c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 770:	75 0c                	jne    77e <printf+0x50>
        state = '%';
 772:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 779:	e9 27 01 00 00       	jmp    8a5 <printf+0x177>
      } else {
        putc(fd, c);
 77e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 781:	0f be c0             	movsbl %al,%eax
 784:	83 ec 08             	sub    $0x8,%esp
 787:	50                   	push   %eax
 788:	ff 75 08             	pushl  0x8(%ebp)
 78b:	e8 c7 fe ff ff       	call   657 <putc>
 790:	83 c4 10             	add    $0x10,%esp
 793:	e9 0d 01 00 00       	jmp    8a5 <printf+0x177>
      }
    } else if(state == '%'){
 798:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 79c:	0f 85 03 01 00 00    	jne    8a5 <printf+0x177>
      if(c == 'd'){
 7a2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7a6:	75 1e                	jne    7c6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	6a 01                	push   $0x1
 7af:	6a 0a                	push   $0xa
 7b1:	50                   	push   %eax
 7b2:	ff 75 08             	pushl  0x8(%ebp)
 7b5:	e8 c0 fe ff ff       	call   67a <printint>
 7ba:	83 c4 10             	add    $0x10,%esp
        ap++;
 7bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c1:	e9 d8 00 00 00       	jmp    89e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7c6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ca:	74 06                	je     7d2 <printf+0xa4>
 7cc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7d0:	75 1e                	jne    7f0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d5:	8b 00                	mov    (%eax),%eax
 7d7:	6a 00                	push   $0x0
 7d9:	6a 10                	push   $0x10
 7db:	50                   	push   %eax
 7dc:	ff 75 08             	pushl  0x8(%ebp)
 7df:	e8 96 fe ff ff       	call   67a <printint>
 7e4:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7eb:	e9 ae 00 00 00       	jmp    89e <printf+0x170>
      } else if(c == 's'){
 7f0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7f4:	75 43                	jne    839 <printf+0x10b>
        s = (char*)*ap;
 7f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f9:	8b 00                	mov    (%eax),%eax
 7fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 806:	75 25                	jne    82d <printf+0xff>
          s = "(null)";
 808:	c7 45 f4 42 0b 00 00 	movl   $0xb42,-0xc(%ebp)
        while(*s != 0){
 80f:	eb 1c                	jmp    82d <printf+0xff>
          putc(fd, *s);
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	0f b6 00             	movzbl (%eax),%eax
 817:	0f be c0             	movsbl %al,%eax
 81a:	83 ec 08             	sub    $0x8,%esp
 81d:	50                   	push   %eax
 81e:	ff 75 08             	pushl  0x8(%ebp)
 821:	e8 31 fe ff ff       	call   657 <putc>
 826:	83 c4 10             	add    $0x10,%esp
          s++;
 829:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	0f b6 00             	movzbl (%eax),%eax
 833:	84 c0                	test   %al,%al
 835:	75 da                	jne    811 <printf+0xe3>
 837:	eb 65                	jmp    89e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 839:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 83d:	75 1d                	jne    85c <printf+0x12e>
        putc(fd, *ap);
 83f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	0f be c0             	movsbl %al,%eax
 847:	83 ec 08             	sub    $0x8,%esp
 84a:	50                   	push   %eax
 84b:	ff 75 08             	pushl  0x8(%ebp)
 84e:	e8 04 fe ff ff       	call   657 <putc>
 853:	83 c4 10             	add    $0x10,%esp
        ap++;
 856:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 85a:	eb 42                	jmp    89e <printf+0x170>
      } else if(c == '%'){
 85c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 860:	75 17                	jne    879 <printf+0x14b>
        putc(fd, c);
 862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 865:	0f be c0             	movsbl %al,%eax
 868:	83 ec 08             	sub    $0x8,%esp
 86b:	50                   	push   %eax
 86c:	ff 75 08             	pushl  0x8(%ebp)
 86f:	e8 e3 fd ff ff       	call   657 <putc>
 874:	83 c4 10             	add    $0x10,%esp
 877:	eb 25                	jmp    89e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 879:	83 ec 08             	sub    $0x8,%esp
 87c:	6a 25                	push   $0x25
 87e:	ff 75 08             	pushl  0x8(%ebp)
 881:	e8 d1 fd ff ff       	call   657 <putc>
 886:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 88c:	0f be c0             	movsbl %al,%eax
 88f:	83 ec 08             	sub    $0x8,%esp
 892:	50                   	push   %eax
 893:	ff 75 08             	pushl  0x8(%ebp)
 896:	e8 bc fd ff ff       	call   657 <putc>
 89b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 89e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8a5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8af:	01 d0                	add    %edx,%eax
 8b1:	0f b6 00             	movzbl (%eax),%eax
 8b4:	84 c0                	test   %al,%al
 8b6:	0f 85 94 fe ff ff    	jne    750 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8bc:	90                   	nop
 8bd:	c9                   	leave  
 8be:	c3                   	ret    

000008bf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8bf:	55                   	push   %ebp
 8c0:	89 e5                	mov    %esp,%ebp
 8c2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	83 e8 08             	sub    $0x8,%eax
 8cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 8d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d6:	eb 24                	jmp    8fc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e0:	77 12                	ja     8f4 <free+0x35>
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e8:	77 24                	ja     90e <free+0x4f>
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f2:	77 1a                	ja     90e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f7:	8b 00                	mov    (%eax),%eax
 8f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 902:	76 d4                	jbe    8d8 <free+0x19>
 904:	8b 45 fc             	mov    -0x4(%ebp),%eax
 907:	8b 00                	mov    (%eax),%eax
 909:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90c:	76 ca                	jbe    8d8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 90e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 91b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91e:	01 c2                	add    %eax,%edx
 920:	8b 45 fc             	mov    -0x4(%ebp),%eax
 923:	8b 00                	mov    (%eax),%eax
 925:	39 c2                	cmp    %eax,%edx
 927:	75 24                	jne    94d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 929:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92c:	8b 50 04             	mov    0x4(%eax),%edx
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	8b 00                	mov    (%eax),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	01 c2                	add    %eax,%edx
 939:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 00                	mov    (%eax),%eax
 944:	8b 10                	mov    (%eax),%edx
 946:	8b 45 f8             	mov    -0x8(%ebp),%eax
 949:	89 10                	mov    %edx,(%eax)
 94b:	eb 0a                	jmp    957 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 10                	mov    (%eax),%edx
 952:	8b 45 f8             	mov    -0x8(%ebp),%eax
 955:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 957:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	01 d0                	add    %edx,%eax
 969:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96c:	75 20                	jne    98e <free+0xcf>
    p->s.size += bp->s.size;
 96e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 971:	8b 50 04             	mov    0x4(%eax),%edx
 974:	8b 45 f8             	mov    -0x8(%ebp),%eax
 977:	8b 40 04             	mov    0x4(%eax),%eax
 97a:	01 c2                	add    %eax,%edx
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 982:	8b 45 f8             	mov    -0x8(%ebp),%eax
 985:	8b 10                	mov    (%eax),%edx
 987:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98a:	89 10                	mov    %edx,(%eax)
 98c:	eb 08                	jmp    996 <free+0xd7>
  } else
    p->s.ptr = bp;
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 55 f8             	mov    -0x8(%ebp),%edx
 994:	89 10                	mov    %edx,(%eax)
  freep = p;
 996:	8b 45 fc             	mov    -0x4(%ebp),%eax
 999:	a3 f0 0d 00 00       	mov    %eax,0xdf0
}
 99e:	90                   	nop
 99f:	c9                   	leave  
 9a0:	c3                   	ret    

000009a1 <morecore>:

static Header*
morecore(uint nu)
{
 9a1:	55                   	push   %ebp
 9a2:	89 e5                	mov    %esp,%ebp
 9a4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9a7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ae:	77 07                	ja     9b7 <morecore+0x16>
    nu = 4096;
 9b0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	c1 e0 03             	shl    $0x3,%eax
 9bd:	83 ec 0c             	sub    $0xc,%esp
 9c0:	50                   	push   %eax
 9c1:	e8 21 fc ff ff       	call   5e7 <sbrk>
 9c6:	83 c4 10             	add    $0x10,%esp
 9c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9d0:	75 07                	jne    9d9 <morecore+0x38>
    return 0;
 9d2:	b8 00 00 00 00       	mov    $0x0,%eax
 9d7:	eb 26                	jmp    9ff <morecore+0x5e>
  hp = (Header*)p;
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e2:	8b 55 08             	mov    0x8(%ebp),%edx
 9e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9eb:	83 c0 08             	add    $0x8,%eax
 9ee:	83 ec 0c             	sub    $0xc,%esp
 9f1:	50                   	push   %eax
 9f2:	e8 c8 fe ff ff       	call   8bf <free>
 9f7:	83 c4 10             	add    $0x10,%esp
  return freep;
 9fa:	a1 f0 0d 00 00       	mov    0xdf0,%eax
}
 9ff:	c9                   	leave  
 a00:	c3                   	ret    

00000a01 <malloc>:

void*
malloc(uint nbytes)
{
 a01:	55                   	push   %ebp
 a02:	89 e5                	mov    %esp,%ebp
 a04:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	83 c0 07             	add    $0x7,%eax
 a0d:	c1 e8 03             	shr    $0x3,%eax
 a10:	83 c0 01             	add    $0x1,%eax
 a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a16:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a22:	75 23                	jne    a47 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a24:	c7 45 f0 e8 0d 00 00 	movl   $0xde8,-0x10(%ebp)
 a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2e:	a3 f0 0d 00 00       	mov    %eax,0xdf0
 a33:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 a38:	a3 e8 0d 00 00       	mov    %eax,0xde8
    base.s.size = 0;
 a3d:	c7 05 ec 0d 00 00 00 	movl   $0x0,0xdec
 a44:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4a:	8b 00                	mov    (%eax),%eax
 a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a52:	8b 40 04             	mov    0x4(%eax),%eax
 a55:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a58:	72 4d                	jb     aa7 <malloc+0xa6>
      if(p->s.size == nunits)
 a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5d:	8b 40 04             	mov    0x4(%eax),%eax
 a60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a63:	75 0c                	jne    a71 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a68:	8b 10                	mov    (%eax),%edx
 a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6d:	89 10                	mov    %edx,(%eax)
 a6f:	eb 26                	jmp    a97 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	8b 40 04             	mov    0x4(%eax),%eax
 a77:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a7a:	89 c2                	mov    %eax,%edx
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a85:	8b 40 04             	mov    0x4(%eax),%eax
 a88:	c1 e0 03             	shl    $0x3,%eax
 a8b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a91:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a94:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9a:	a3 f0 0d 00 00       	mov    %eax,0xdf0
      return (void*)(p + 1);
 a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa2:	83 c0 08             	add    $0x8,%eax
 aa5:	eb 3b                	jmp    ae2 <malloc+0xe1>
    }
    if(p == freep)
 aa7:	a1 f0 0d 00 00       	mov    0xdf0,%eax
 aac:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aaf:	75 1e                	jne    acf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ab1:	83 ec 0c             	sub    $0xc,%esp
 ab4:	ff 75 ec             	pushl  -0x14(%ebp)
 ab7:	e8 e5 fe ff ff       	call   9a1 <morecore>
 abc:	83 c4 10             	add    $0x10,%esp
 abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac6:	75 07                	jne    acf <malloc+0xce>
        return 0;
 ac8:	b8 00 00 00 00       	mov    $0x0,%eax
 acd:	eb 13                	jmp    ae2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad8:	8b 00                	mov    (%eax),%eax
 ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 add:	e9 6d ff ff ff       	jmp    a4f <malloc+0x4e>
}
 ae2:	c9                   	leave  
 ae3:	c3                   	ret    
