
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
  1b:	e8 58 03 00 00       	call   378 <date>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	74 17                	je     3e <main+0x3e>

        printf(2, "Date_failed\n");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 10 08 00 00       	push   $0x810
  2f:	6a 02                	push   $0x2
  31:	e8 21 04 00 00       	call   457 <printf>
  36:	83 c4 10             	add    $0x10,%esp
        exit();
  39:	e8 92 02 00 00       	call   2d0 <exit>
    }

     date(&r);
  3e:	83 ec 0c             	sub    $0xc,%esp
  41:	8d 45 d0             	lea    -0x30(%ebp),%eax
  44:	50                   	push   %eax
  45:	e8 2e 03 00 00       	call   378 <date>
  4a:	83 c4 10             	add    $0x10,%esp
    printf(1, "day: %d month: %d year: %d \t hour: %d minute: %d second: %d \n", r.day, r.month, r.year, r.hour, r.minute, r.second);
  4d:	8b 7d d0             	mov    -0x30(%ebp),%edi
  50:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  53:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  56:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  5f:	57                   	push   %edi
  60:	56                   	push   %esi
  61:	53                   	push   %ebx
  62:	51                   	push   %ecx
  63:	52                   	push   %edx
  64:	50                   	push   %eax
  65:	68 20 08 00 00       	push   $0x820
  6a:	6a 01                	push   $0x1
  6c:	e8 e6 03 00 00       	call   457 <printf>
  71:	83 c4 20             	add    $0x20,%esp

    exit();
  74:	e8 57 02 00 00       	call   2d0 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	90                   	nop
  9b:	5b                   	pop    %ebx
  9c:	5f                   	pop    %edi
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ab:	90                   	nop
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	8d 50 01             	lea    0x1(%eax),%edx
  b2:	89 55 08             	mov    %edx,0x8(%ebp)
  b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  bb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	88 10                	mov    %dl,(%eax)
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	84 c0                	test   %al,%al
  c8:	75 e2                	jne    ac <strcpy+0xd>
    ;
  return os;
  ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cd:	c9                   	leave  
  ce:	c3                   	ret    

000000cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d2:	eb 08                	jmp    dc <strcmp+0xd>
    p++, q++;
  d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 00             	movzbl (%eax),%eax
  e2:	84 c0                	test   %al,%al
  e4:	74 10                	je     f6 <strcmp+0x27>
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	0f b6 10             	movzbl (%eax),%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	38 c2                	cmp    %al,%dl
  f4:	74 de                	je     d4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	0f b6 d0             	movzbl %al,%edx
  ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	0f b6 c0             	movzbl %al,%eax
 108:	29 c2                	sub    %eax,%edx
 10a:	89 d0                	mov    %edx,%eax
}
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    

0000010e <strlen>:

uint
strlen(char *s)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
 111:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 114:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11b:	eb 04                	jmp    121 <strlen+0x13>
 11d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 121:	8b 55 fc             	mov    -0x4(%ebp),%edx
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	01 d0                	add    %edx,%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	84 c0                	test   %al,%al
 12e:	75 ed                	jne    11d <strlen+0xf>
    ;
  return n;
 130:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <memset>:

void*
memset(void *dst, int c, uint n)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 138:	8b 45 10             	mov    0x10(%ebp),%eax
 13b:	50                   	push   %eax
 13c:	ff 75 0c             	pushl  0xc(%ebp)
 13f:	ff 75 08             	pushl  0x8(%ebp)
 142:	e8 32 ff ff ff       	call   79 <stosb>
 147:	83 c4 0c             	add    $0xc,%esp
  return dst;
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <strchr>:

char*
strchr(const char *s, char c)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 04             	sub    $0x4,%esp
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15b:	eb 14                	jmp    171 <strchr+0x22>
    if(*s == c)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	3a 45 fc             	cmp    -0x4(%ebp),%al
 166:	75 05                	jne    16d <strchr+0x1e>
      return (char*)s;
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	eb 13                	jmp    180 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	75 e2                	jne    15d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 180:	c9                   	leave  
 181:	c3                   	ret    

00000182 <gets>:

char*
gets(char *buf, int max)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18f:	eb 42                	jmp    1d3 <gets+0x51>
    cc = read(0, &c, 1);
 191:	83 ec 04             	sub    $0x4,%esp
 194:	6a 01                	push   $0x1
 196:	8d 45 ef             	lea    -0x11(%ebp),%eax
 199:	50                   	push   %eax
 19a:	6a 00                	push   $0x0
 19c:	e8 47 01 00 00       	call   2e8 <read>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ab:	7e 33                	jle    1e0 <gets+0x5e>
      break;
    buf[i++] = c;
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	8d 50 01             	lea    0x1(%eax),%edx
 1b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b6:	89 c2                	mov    %eax,%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 c2                	add    %eax,%edx
 1bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	3c 0a                	cmp    $0xa,%al
 1c9:	74 16                	je     1e1 <gets+0x5f>
 1cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cf:	3c 0d                	cmp    $0xd,%al
 1d1:	74 0e                	je     1e1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	83 c0 01             	add    $0x1,%eax
 1d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dc:	7c b3                	jl     191 <gets+0xf>
 1de:	eb 01                	jmp    1e1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	01 d0                	add    %edx,%eax
 1e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <stat>:

int
stat(char *n, struct stat *st)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f7:	83 ec 08             	sub    $0x8,%esp
 1fa:	6a 00                	push   $0x0
 1fc:	ff 75 08             	pushl  0x8(%ebp)
 1ff:	e8 0c 01 00 00       	call   310 <open>
 204:	83 c4 10             	add    $0x10,%esp
 207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20e:	79 07                	jns    217 <stat+0x26>
    return -1;
 210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 215:	eb 25                	jmp    23c <stat+0x4b>
  r = fstat(fd, st);
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	ff 75 0c             	pushl  0xc(%ebp)
 21d:	ff 75 f4             	pushl  -0xc(%ebp)
 220:	e8 03 01 00 00       	call   328 <fstat>
 225:	83 c4 10             	add    $0x10,%esp
 228:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22b:	83 ec 0c             	sub    $0xc,%esp
 22e:	ff 75 f4             	pushl  -0xc(%ebp)
 231:	e8 c2 00 00 00       	call   2f8 <close>
 236:	83 c4 10             	add    $0x10,%esp
  return r;
 239:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <atoi>:

int
atoi(const char *s)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24b:	eb 25                	jmp    272 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 250:	89 d0                	mov    %edx,%eax
 252:	c1 e0 02             	shl    $0x2,%eax
 255:	01 d0                	add    %edx,%eax
 257:	01 c0                	add    %eax,%eax
 259:	89 c1                	mov    %eax,%ecx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 01             	lea    0x1(%eax),%edx
 261:	89 55 08             	mov    %edx,0x8(%ebp)
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	01 c8                	add    %ecx,%eax
 26c:	83 e8 30             	sub    $0x30,%eax
 26f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	3c 2f                	cmp    $0x2f,%al
 27a:	7e 0a                	jle    286 <atoi+0x48>
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 39                	cmp    $0x39,%al
 284:	7e c7                	jle    24d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 286:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29d:	eb 17                	jmp    2b6 <memmove+0x2b>
    *dst++ = *src++;
 29f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a2:	8d 50 01             	lea    0x1(%eax),%edx
 2a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2ab:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ae:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b1:	0f b6 12             	movzbl (%edx),%edx
 2b4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b6:	8b 45 10             	mov    0x10(%ebp),%eax
 2b9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bc:	89 55 10             	mov    %edx,0x10(%ebp)
 2bf:	85 c0                	test   %eax,%eax
 2c1:	7f dc                	jg     29f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c6:	c9                   	leave  
 2c7:	c3                   	ret    

000002c8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c8:	b8 01 00 00 00       	mov    $0x1,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <exit>:
SYSCALL(exit)
 2d0:	b8 02 00 00 00       	mov    $0x2,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <wait>:
SYSCALL(wait)
 2d8:	b8 03 00 00 00       	mov    $0x3,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <pipe>:
SYSCALL(pipe)
 2e0:	b8 04 00 00 00       	mov    $0x4,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <read>:
SYSCALL(read)
 2e8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <write>:
SYSCALL(write)
 2f0:	b8 10 00 00 00       	mov    $0x10,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <close>:
SYSCALL(close)
 2f8:	b8 15 00 00 00       	mov    $0x15,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <kill>:
SYSCALL(kill)
 300:	b8 06 00 00 00       	mov    $0x6,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <exec>:
SYSCALL(exec)
 308:	b8 07 00 00 00       	mov    $0x7,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <open>:
SYSCALL(open)
 310:	b8 0f 00 00 00       	mov    $0xf,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <mknod>:
SYSCALL(mknod)
 318:	b8 11 00 00 00       	mov    $0x11,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <unlink>:
SYSCALL(unlink)
 320:	b8 12 00 00 00       	mov    $0x12,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <fstat>:
SYSCALL(fstat)
 328:	b8 08 00 00 00       	mov    $0x8,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <link>:
SYSCALL(link)
 330:	b8 13 00 00 00       	mov    $0x13,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <mkdir>:
SYSCALL(mkdir)
 338:	b8 14 00 00 00       	mov    $0x14,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <chdir>:
SYSCALL(chdir)
 340:	b8 09 00 00 00       	mov    $0x9,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <dup>:
SYSCALL(dup)
 348:	b8 0a 00 00 00       	mov    $0xa,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <getpid>:
SYSCALL(getpid)
 350:	b8 0b 00 00 00       	mov    $0xb,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sbrk>:
SYSCALL(sbrk)
 358:	b8 0c 00 00 00       	mov    $0xc,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <sleep>:
SYSCALL(sleep)
 360:	b8 0d 00 00 00       	mov    $0xd,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <uptime>:
SYSCALL(uptime)
 368:	b8 0e 00 00 00       	mov    $0xe,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <halt>:
SYSCALL(halt)
 370:	b8 16 00 00 00       	mov    $0x16,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <date>:
//Student Implementations 
SYSCALL(date)
 378:	b8 17 00 00 00       	mov    $0x17,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 18             	sub    $0x18,%esp
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38c:	83 ec 04             	sub    $0x4,%esp
 38f:	6a 01                	push   $0x1
 391:	8d 45 f4             	lea    -0xc(%ebp),%eax
 394:	50                   	push   %eax
 395:	ff 75 08             	pushl  0x8(%ebp)
 398:	e8 53 ff ff ff       	call   2f0 <write>
 39d:	83 c4 10             	add    $0x10,%esp
}
 3a0:	90                   	nop
 3a1:	c9                   	leave  
 3a2:	c3                   	ret    

000003a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a3:	55                   	push   %ebp
 3a4:	89 e5                	mov    %esp,%ebp
 3a6:	53                   	push   %ebx
 3a7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b5:	74 17                	je     3ce <printint+0x2b>
 3b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3bb:	79 11                	jns    3ce <printint+0x2b>
    neg = 1;
 3bd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	f7 d8                	neg    %eax
 3c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cc:	eb 06                	jmp    3d4 <printint+0x31>
  } else {
    x = xx;
 3ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3db:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3de:	8d 41 01             	lea    0x1(%ecx),%eax
 3e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ea:	ba 00 00 00 00       	mov    $0x0,%edx
 3ef:	f7 f3                	div    %ebx
 3f1:	89 d0                	mov    %edx,%eax
 3f3:	0f b6 80 bc 0a 00 00 	movzbl 0xabc(%eax),%eax
 3fa:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
 401:	8b 45 ec             	mov    -0x14(%ebp),%eax
 404:	ba 00 00 00 00       	mov    $0x0,%edx
 409:	f7 f3                	div    %ebx
 40b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 412:	75 c7                	jne    3db <printint+0x38>
  if(neg)
 414:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 418:	74 2d                	je     447 <printint+0xa4>
    buf[i++] = '-';
 41a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41d:	8d 50 01             	lea    0x1(%eax),%edx
 420:	89 55 f4             	mov    %edx,-0xc(%ebp)
 423:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 428:	eb 1d                	jmp    447 <printint+0xa4>
    putc(fd, buf[i]);
 42a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 430:	01 d0                	add    %edx,%eax
 432:	0f b6 00             	movzbl (%eax),%eax
 435:	0f be c0             	movsbl %al,%eax
 438:	83 ec 08             	sub    $0x8,%esp
 43b:	50                   	push   %eax
 43c:	ff 75 08             	pushl  0x8(%ebp)
 43f:	e8 3c ff ff ff       	call   380 <putc>
 444:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 447:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44f:	79 d9                	jns    42a <printint+0x87>
    putc(fd, buf[i]);
}
 451:	90                   	nop
 452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 455:	c9                   	leave  
 456:	c3                   	ret    

00000457 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 464:	8d 45 0c             	lea    0xc(%ebp),%eax
 467:	83 c0 04             	add    $0x4,%eax
 46a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 474:	e9 59 01 00 00       	jmp    5d2 <printf+0x17b>
    c = fmt[i] & 0xff;
 479:	8b 55 0c             	mov    0xc(%ebp),%edx
 47c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47f:	01 d0                	add    %edx,%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	0f be c0             	movsbl %al,%eax
 487:	25 ff 00 00 00       	and    $0xff,%eax
 48c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 493:	75 2c                	jne    4c1 <printf+0x6a>
      if(c == '%'){
 495:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 499:	75 0c                	jne    4a7 <printf+0x50>
        state = '%';
 49b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a2:	e9 27 01 00 00       	jmp    5ce <printf+0x177>
      } else {
        putc(fd, c);
 4a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4aa:	0f be c0             	movsbl %al,%eax
 4ad:	83 ec 08             	sub    $0x8,%esp
 4b0:	50                   	push   %eax
 4b1:	ff 75 08             	pushl  0x8(%ebp)
 4b4:	e8 c7 fe ff ff       	call   380 <putc>
 4b9:	83 c4 10             	add    $0x10,%esp
 4bc:	e9 0d 01 00 00       	jmp    5ce <printf+0x177>
      }
    } else if(state == '%'){
 4c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c5:	0f 85 03 01 00 00    	jne    5ce <printf+0x177>
      if(c == 'd'){
 4cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cf:	75 1e                	jne    4ef <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d4:	8b 00                	mov    (%eax),%eax
 4d6:	6a 01                	push   $0x1
 4d8:	6a 0a                	push   $0xa
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 c0 fe ff ff       	call   3a3 <printint>
 4e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ea:	e9 d8 00 00 00       	jmp    5c7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ef:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f3:	74 06                	je     4fb <printf+0xa4>
 4f5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f9:	75 1e                	jne    519 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	6a 00                	push   $0x0
 502:	6a 10                	push   $0x10
 504:	50                   	push   %eax
 505:	ff 75 08             	pushl  0x8(%ebp)
 508:	e8 96 fe ff ff       	call   3a3 <printint>
 50d:	83 c4 10             	add    $0x10,%esp
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 ae 00 00 00       	jmp    5c7 <printf+0x170>
      } else if(c == 's'){
 519:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51d:	75 43                	jne    562 <printf+0x10b>
        s = (char*)*ap;
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52f:	75 25                	jne    556 <printf+0xff>
          s = "(null)";
 531:	c7 45 f4 5e 08 00 00 	movl   $0x85e,-0xc(%ebp)
        while(*s != 0){
 538:	eb 1c                	jmp    556 <printf+0xff>
          putc(fd, *s);
 53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53d:	0f b6 00             	movzbl (%eax),%eax
 540:	0f be c0             	movsbl %al,%eax
 543:	83 ec 08             	sub    $0x8,%esp
 546:	50                   	push   %eax
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 31 fe ff ff       	call   380 <putc>
 54f:	83 c4 10             	add    $0x10,%esp
          s++;
 552:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	84 c0                	test   %al,%al
 55e:	75 da                	jne    53a <printf+0xe3>
 560:	eb 65                	jmp    5c7 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 562:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 566:	75 1d                	jne    585 <printf+0x12e>
        putc(fd, *ap);
 568:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56b:	8b 00                	mov    (%eax),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	83 ec 08             	sub    $0x8,%esp
 573:	50                   	push   %eax
 574:	ff 75 08             	pushl  0x8(%ebp)
 577:	e8 04 fe ff ff       	call   380 <putc>
 57c:	83 c4 10             	add    $0x10,%esp
        ap++;
 57f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 583:	eb 42                	jmp    5c7 <printf+0x170>
      } else if(c == '%'){
 585:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 589:	75 17                	jne    5a2 <printf+0x14b>
        putc(fd, c);
 58b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	83 ec 08             	sub    $0x8,%esp
 594:	50                   	push   %eax
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 e3 fd ff ff       	call   380 <putc>
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	eb 25                	jmp    5c7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	6a 25                	push   $0x25
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 d1 fd ff ff       	call   380 <putc>
 5af:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	83 ec 08             	sub    $0x8,%esp
 5bb:	50                   	push   %eax
 5bc:	ff 75 08             	pushl  0x8(%ebp)
 5bf:	e8 bc fd ff ff       	call   380 <putc>
 5c4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d8:	01 d0                	add    %edx,%eax
 5da:	0f b6 00             	movzbl (%eax),%eax
 5dd:	84 c0                	test   %al,%al
 5df:	0f 85 94 fe ff ff    	jne    479 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e5:	90                   	nop
 5e6:	c9                   	leave  
 5e7:	c3                   	ret    

000005e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	83 e8 08             	sub    $0x8,%eax
 5f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f7:	a1 d8 0a 00 00       	mov    0xad8,%eax
 5fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ff:	eb 24                	jmp    625 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	77 12                	ja     61d <free+0x35>
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 611:	77 24                	ja     637 <free+0x4f>
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61b:	77 1a                	ja     637 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	89 45 fc             	mov    %eax,-0x4(%ebp)
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	76 d4                	jbe    601 <free+0x19>
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 635:	76 ca                	jbe    601 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 40 04             	mov    0x4(%eax),%eax
 63d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	01 c2                	add    %eax,%edx
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	39 c2                	cmp    %eax,%edx
 650:	75 24                	jne    676 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	01 c2                	add    %eax,%edx
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
 674:	eb 0a                	jmp    680 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 10                	mov    (%eax),%edx
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 40 04             	mov    0x4(%eax),%eax
 686:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	01 d0                	add    %edx,%eax
 692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 695:	75 20                	jne    6b7 <free+0xcf>
    p->s.size += bp->s.size;
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 50 04             	mov    0x4(%eax),%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	8b 40 04             	mov    0x4(%eax),%eax
 6a3:	01 c2                	add    %eax,%edx
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
 6b5:	eb 08                	jmp    6bf <free+0xd7>
  } else
    p->s.ptr = bp;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6bd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	a3 d8 0a 00 00       	mov    %eax,0xad8
}
 6c7:	90                   	nop
 6c8:	c9                   	leave  
 6c9:	c3                   	ret    

000006ca <morecore>:

static Header*
morecore(uint nu)
{
 6ca:	55                   	push   %ebp
 6cb:	89 e5                	mov    %esp,%ebp
 6cd:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d7:	77 07                	ja     6e0 <morecore+0x16>
    nu = 4096;
 6d9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	c1 e0 03             	shl    $0x3,%eax
 6e6:	83 ec 0c             	sub    $0xc,%esp
 6e9:	50                   	push   %eax
 6ea:	e8 69 fc ff ff       	call   358 <sbrk>
 6ef:	83 c4 10             	add    $0x10,%esp
 6f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f9:	75 07                	jne    702 <morecore+0x38>
    return 0;
 6fb:	b8 00 00 00 00       	mov    $0x0,%eax
 700:	eb 26                	jmp    728 <morecore+0x5e>
  hp = (Header*)p;
 702:	8b 45 f4             	mov    -0xc(%ebp),%eax
 705:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 708:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70b:	8b 55 08             	mov    0x8(%ebp),%edx
 70e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	83 c0 08             	add    $0x8,%eax
 717:	83 ec 0c             	sub    $0xc,%esp
 71a:	50                   	push   %eax
 71b:	e8 c8 fe ff ff       	call   5e8 <free>
 720:	83 c4 10             	add    $0x10,%esp
  return freep;
 723:	a1 d8 0a 00 00       	mov    0xad8,%eax
}
 728:	c9                   	leave  
 729:	c3                   	ret    

0000072a <malloc>:

void*
malloc(uint nbytes)
{
 72a:	55                   	push   %ebp
 72b:	89 e5                	mov    %esp,%ebp
 72d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	83 c0 07             	add    $0x7,%eax
 736:	c1 e8 03             	shr    $0x3,%eax
 739:	83 c0 01             	add    $0x1,%eax
 73c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 73f:	a1 d8 0a 00 00       	mov    0xad8,%eax
 744:	89 45 f0             	mov    %eax,-0x10(%ebp)
 747:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74b:	75 23                	jne    770 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74d:	c7 45 f0 d0 0a 00 00 	movl   $0xad0,-0x10(%ebp)
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	a3 d8 0a 00 00       	mov    %eax,0xad8
 75c:	a1 d8 0a 00 00       	mov    0xad8,%eax
 761:	a3 d0 0a 00 00       	mov    %eax,0xad0
    base.s.size = 0;
 766:	c7 05 d4 0a 00 00 00 	movl   $0x0,0xad4
 76d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 781:	72 4d                	jb     7d0 <malloc+0xa6>
      if(p->s.size == nunits)
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78c:	75 0c                	jne    79a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 10                	mov    (%eax),%edx
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	89 10                	mov    %edx,(%eax)
 798:	eb 26                	jmp    7c0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a3:	89 c2                	mov    %eax,%edx
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	c1 e0 03             	shl    $0x3,%eax
 7b4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7bd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c3:	a3 d8 0a 00 00       	mov    %eax,0xad8
      return (void*)(p + 1);
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	83 c0 08             	add    $0x8,%eax
 7ce:	eb 3b                	jmp    80b <malloc+0xe1>
    }
    if(p == freep)
 7d0:	a1 d8 0a 00 00       	mov    0xad8,%eax
 7d5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d8:	75 1e                	jne    7f8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7da:	83 ec 0c             	sub    $0xc,%esp
 7dd:	ff 75 ec             	pushl  -0x14(%ebp)
 7e0:	e8 e5 fe ff ff       	call   6ca <morecore>
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ef:	75 07                	jne    7f8 <malloc+0xce>
        return 0;
 7f1:	b8 00 00 00 00       	mov    $0x0,%eax
 7f6:	eb 13                	jmp    80b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 806:	e9 6d ff ff ff       	jmp    778 <malloc+0x4e>
}
 80b:	c9                   	leave  
 80c:	c3                   	ret    
