
_looptest:     file format elf32-i386


Disassembly of section .text:

00000000 <countForever>:
#define PrioCount 10
#define numChildren 10

void
countForever(int p)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int j;
 // unsigned long count = 0;

  j = getpid();
   6:	e8 54 03 00 00       	call   35f <getpid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //p = p%PrioCount;
  setpriority(j, p);
   e:	83 ec 08             	sub    $0x8,%esp
  11:	ff 75 08             	pushl  0x8(%ebp)
  14:	ff 75 f4             	pushl  -0xc(%ebp)
  17:	e8 a3 03 00 00       	call   3bf <setpriority>
  1c:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d: start prio %d\n", j, p);
  1f:	ff 75 08             	pushl  0x8(%ebp)
  22:	ff 75 f4             	pushl  -0xc(%ebp)
  25:	68 54 08 00 00       	push   $0x854
  2a:	6a 01                	push   $0x1
  2c:	e8 6d 04 00 00       	call   49e <printf>
  31:	83 c4 10             	add    $0x10,%esp
   // if ((count & 0xFFFFFFF) == 0) {
      //p = (p+1) % PrioCount;
      //setpriority(j, p);
      //printf(1, "%d: new prio %d\n", j, p);
    //}
  }
  34:	eb fe                	jmp    34 <countForever+0x34>

00000036 <main>:
}

int
main(int argc, char *argv[])
{
  36:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  3a:	83 e4 f0             	and    $0xfffffff0,%esp
  3d:	ff 71 fc             	pushl  -0x4(%ecx)
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	51                   	push   %ecx
  44:	83 ec 14             	sub    $0x14,%esp
  int i, rc;

  for (i=0; i<numChildren; i++) {
  47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4e:	eb 20                	jmp    70 <main+0x3a>
    rc = fork();
  50:	e8 82 02 00 00       	call   2d7 <fork>
  55:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!rc) { // child
  58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5c:	75 0e                	jne    6c <main+0x36>
      countForever(i);
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	ff 75 f4             	pushl  -0xc(%ebp)
  64:	e8 97 ff ff ff       	call   0 <countForever>
  69:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i, rc;

  for (i=0; i<numChildren; i++) {
  6c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  70:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  74:	7e da                	jle    50 <main+0x1a>
  }

  

  // what the heck, let's have the parent waste time as well!
  countForever(0);
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	6a 00                	push   $0x0
  7b:	e8 80 ff ff ff       	call   0 <countForever>
  80:	83 c4 10             	add    $0x10,%esp
  exit();
  83:	e8 57 02 00 00       	call   2df <exit>

00000088 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	57                   	push   %edi
  8c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  90:	8b 55 10             	mov    0x10(%ebp),%edx
  93:	8b 45 0c             	mov    0xc(%ebp),%eax
  96:	89 cb                	mov    %ecx,%ebx
  98:	89 df                	mov    %ebx,%edi
  9a:	89 d1                	mov    %edx,%ecx
  9c:	fc                   	cld    
  9d:	f3 aa                	rep stos %al,%es:(%edi)
  9f:	89 ca                	mov    %ecx,%edx
  a1:	89 fb                	mov    %edi,%ebx
  a3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a9:	90                   	nop
  aa:	5b                   	pop    %ebx
  ab:	5f                   	pop    %edi
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    

000000ae <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ba:	90                   	nop
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	8d 50 01             	lea    0x1(%eax),%edx
  c1:	89 55 08             	mov    %edx,0x8(%ebp)
  c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  cd:	0f b6 12             	movzbl (%edx),%edx
  d0:	88 10                	mov    %dl,(%eax)
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 e2                	jne    bb <strcpy+0xd>
    ;
  return os;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <strcmp>:

int
strcmp(const char *p, const char *q)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e1:	eb 08                	jmp    eb <strcmp+0xd>
    p++, q++;
  e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	84 c0                	test   %al,%al
  f3:	74 10                	je     105 <strcmp+0x27>
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 10             	movzbl (%eax),%edx
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	38 c2                	cmp    %al,%dl
 103:	74 de                	je     e3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	0f b6 d0             	movzbl %al,%edx
 10e:	8b 45 0c             	mov    0xc(%ebp),%eax
 111:	0f b6 00             	movzbl (%eax),%eax
 114:	0f b6 c0             	movzbl %al,%eax
 117:	29 c2                	sub    %eax,%edx
 119:	89 d0                	mov    %edx,%eax
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strlen>:

uint
strlen(char *s)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12a:	eb 04                	jmp    130 <strlen+0x13>
 12c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 130:	8b 55 fc             	mov    -0x4(%ebp),%edx
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	01 d0                	add    %edx,%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	84 c0                	test   %al,%al
 13d:	75 ed                	jne    12c <strlen+0xf>
    ;
  return n;
 13f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 147:	8b 45 10             	mov    0x10(%ebp),%eax
 14a:	50                   	push   %eax
 14b:	ff 75 0c             	pushl  0xc(%ebp)
 14e:	ff 75 08             	pushl  0x8(%ebp)
 151:	e8 32 ff ff ff       	call   88 <stosb>
 156:	83 c4 0c             	add    $0xc,%esp
  return dst;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 04             	sub    $0x4,%esp
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16a:	eb 14                	jmp    180 <strchr+0x22>
    if(*s == c)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	3a 45 fc             	cmp    -0x4(%ebp),%al
 175:	75 05                	jne    17c <strchr+0x1e>
      return (char*)s;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	eb 13                	jmp    18f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	75 e2                	jne    16c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <gets>:

char*
gets(char *buf, int max)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 197:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19e:	eb 42                	jmp    1e2 <gets+0x51>
    cc = read(0, &c, 1);
 1a0:	83 ec 04             	sub    $0x4,%esp
 1a3:	6a 01                	push   $0x1
 1a5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a8:	50                   	push   %eax
 1a9:	6a 00                	push   $0x0
 1ab:	e8 47 01 00 00       	call   2f7 <read>
 1b0:	83 c4 10             	add    $0x10,%esp
 1b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ba:	7e 33                	jle    1ef <gets+0x5e>
      break;
    buf[i++] = c;
 1bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bf:	8d 50 01             	lea    0x1(%eax),%edx
 1c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c5:	89 c2                	mov    %eax,%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 c2                	add    %eax,%edx
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d6:	3c 0a                	cmp    $0xa,%al
 1d8:	74 16                	je     1f0 <gets+0x5f>
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0d                	cmp    $0xd,%al
 1e0:	74 0e                	je     1f0 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e5:	83 c0 01             	add    $0x1,%eax
 1e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1eb:	7c b3                	jl     1a0 <gets+0xf>
 1ed:	eb 01                	jmp    1f0 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ef:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	01 d0                	add    %edx,%eax
 1f8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <stat>:

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	83 ec 08             	sub    $0x8,%esp
 209:	6a 00                	push   $0x0
 20b:	ff 75 08             	pushl  0x8(%ebp)
 20e:	e8 0c 01 00 00       	call   31f <open>
 213:	83 c4 10             	add    $0x10,%esp
 216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21d:	79 07                	jns    226 <stat+0x26>
    return -1;
 21f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 224:	eb 25                	jmp    24b <stat+0x4b>
  r = fstat(fd, st);
 226:	83 ec 08             	sub    $0x8,%esp
 229:	ff 75 0c             	pushl  0xc(%ebp)
 22c:	ff 75 f4             	pushl  -0xc(%ebp)
 22f:	e8 03 01 00 00       	call   337 <fstat>
 234:	83 c4 10             	add    $0x10,%esp
 237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23a:	83 ec 0c             	sub    $0xc,%esp
 23d:	ff 75 f4             	pushl  -0xc(%ebp)
 240:	e8 c2 00 00 00       	call   307 <close>
 245:	83 c4 10             	add    $0x10,%esp
  return r;
 248:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <atoi>:

int
atoi(const char *s)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25a:	eb 25                	jmp    281 <atoi+0x34>
    n = n*10 + *s++ - '0';
 25c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25f:	89 d0                	mov    %edx,%eax
 261:	c1 e0 02             	shl    $0x2,%eax
 264:	01 d0                	add    %edx,%eax
 266:	01 c0                	add    %eax,%eax
 268:	89 c1                	mov    %eax,%ecx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	8d 50 01             	lea    0x1(%eax),%edx
 270:	89 55 08             	mov    %edx,0x8(%ebp)
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	0f be c0             	movsbl %al,%eax
 279:	01 c8                	add    %ecx,%eax
 27b:	83 e8 30             	sub    $0x30,%eax
 27e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2f                	cmp    $0x2f,%al
 289:	7e 0a                	jle    295 <atoi+0x48>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 39                	cmp    $0x39,%al
 293:	7e c7                	jle    25c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ac:	eb 17                	jmp    2c5 <memmove+0x2b>
    *dst++ = *src++;
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b1:	8d 50 01             	lea    0x1(%eax),%edx
 2b4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2ba:	8d 4a 01             	lea    0x1(%edx),%ecx
 2bd:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c0:	0f b6 12             	movzbl (%edx),%edx
 2c3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c5:	8b 45 10             	mov    0x10(%ebp),%eax
 2c8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2cb:	89 55 10             	mov    %edx,0x10(%ebp)
 2ce:	85 c0                	test   %eax,%eax
 2d0:	7f dc                	jg     2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d5:	c9                   	leave  
 2d6:	c3                   	ret    

000002d7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d7:	b8 01 00 00 00       	mov    $0x1,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <exit>:
SYSCALL(exit)
 2df:	b8 02 00 00 00       	mov    $0x2,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <wait>:
SYSCALL(wait)
 2e7:	b8 03 00 00 00       	mov    $0x3,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <pipe>:
SYSCALL(pipe)
 2ef:	b8 04 00 00 00       	mov    $0x4,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <read>:
SYSCALL(read)
 2f7:	b8 05 00 00 00       	mov    $0x5,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <write>:
SYSCALL(write)
 2ff:	b8 10 00 00 00       	mov    $0x10,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <close>:
SYSCALL(close)
 307:	b8 15 00 00 00       	mov    $0x15,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <kill>:
SYSCALL(kill)
 30f:	b8 06 00 00 00       	mov    $0x6,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <exec>:
SYSCALL(exec)
 317:	b8 07 00 00 00       	mov    $0x7,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <open>:
SYSCALL(open)
 31f:	b8 0f 00 00 00       	mov    $0xf,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <mknod>:
SYSCALL(mknod)
 327:	b8 11 00 00 00       	mov    $0x11,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <unlink>:
SYSCALL(unlink)
 32f:	b8 12 00 00 00       	mov    $0x12,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <fstat>:
SYSCALL(fstat)
 337:	b8 08 00 00 00       	mov    $0x8,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <link>:
SYSCALL(link)
 33f:	b8 13 00 00 00       	mov    $0x13,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <mkdir>:
SYSCALL(mkdir)
 347:	b8 14 00 00 00       	mov    $0x14,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <chdir>:
SYSCALL(chdir)
 34f:	b8 09 00 00 00       	mov    $0x9,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <dup>:
SYSCALL(dup)
 357:	b8 0a 00 00 00       	mov    $0xa,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <getpid>:
SYSCALL(getpid)
 35f:	b8 0b 00 00 00       	mov    $0xb,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <sbrk>:
SYSCALL(sbrk)
 367:	b8 0c 00 00 00       	mov    $0xc,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <sleep>:
SYSCALL(sleep)
 36f:	b8 0d 00 00 00       	mov    $0xd,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <uptime>:
SYSCALL(uptime)
 377:	b8 0e 00 00 00       	mov    $0xe,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <halt>:
SYSCALL(halt)
 37f:	b8 16 00 00 00       	mov    $0x16,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <date>:
//Student Implementations 
SYSCALL(date)
 387:	b8 17 00 00 00       	mov    $0x17,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <getuid>:

SYSCALL(getuid)
 38f:	b8 18 00 00 00       	mov    $0x18,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <getgid>:
SYSCALL(getgid)
 397:	b8 19 00 00 00       	mov    $0x19,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <getppid>:
SYSCALL(getppid)
 39f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <setuid>:

SYSCALL(setuid)
 3a7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <setgid>:
SYSCALL(setgid)
 3af:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <getprocs>:
SYSCALL(getprocs)
 3b7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <setpriority>:
// Project 3
SYSCALL(setpriority)
 3bf:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	83 ec 18             	sub    $0x18,%esp
 3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d3:	83 ec 04             	sub    $0x4,%esp
 3d6:	6a 01                	push   $0x1
 3d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3db:	50                   	push   %eax
 3dc:	ff 75 08             	pushl  0x8(%ebp)
 3df:	e8 1b ff ff ff       	call   2ff <write>
 3e4:	83 c4 10             	add    $0x10,%esp
}
 3e7:	90                   	nop
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    

000003ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	53                   	push   %ebx
 3ee:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3fc:	74 17                	je     415 <printint+0x2b>
 3fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 402:	79 11                	jns    415 <printint+0x2b>
    neg = 1;
 404:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 40b:	8b 45 0c             	mov    0xc(%ebp),%eax
 40e:	f7 d8                	neg    %eax
 410:	89 45 ec             	mov    %eax,-0x14(%ebp)
 413:	eb 06                	jmp    41b <printint+0x31>
  } else {
    x = xx;
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 41b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 422:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 425:	8d 41 01             	lea    0x1(%ecx),%eax
 428:	89 45 f4             	mov    %eax,-0xc(%ebp)
 42b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 431:	ba 00 00 00 00       	mov    $0x0,%edx
 436:	f7 f3                	div    %ebx
 438:	89 d0                	mov    %edx,%eax
 43a:	0f b6 80 d4 0a 00 00 	movzbl 0xad4(%eax),%eax
 441:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 445:	8b 5d 10             	mov    0x10(%ebp),%ebx
 448:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44b:	ba 00 00 00 00       	mov    $0x0,%edx
 450:	f7 f3                	div    %ebx
 452:	89 45 ec             	mov    %eax,-0x14(%ebp)
 455:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 459:	75 c7                	jne    422 <printint+0x38>
  if(neg)
 45b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45f:	74 2d                	je     48e <printint+0xa4>
    buf[i++] = '-';
 461:	8b 45 f4             	mov    -0xc(%ebp),%eax
 464:	8d 50 01             	lea    0x1(%eax),%edx
 467:	89 55 f4             	mov    %edx,-0xc(%ebp)
 46a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 46f:	eb 1d                	jmp    48e <printint+0xa4>
    putc(fd, buf[i]);
 471:	8d 55 dc             	lea    -0x24(%ebp),%edx
 474:	8b 45 f4             	mov    -0xc(%ebp),%eax
 477:	01 d0                	add    %edx,%eax
 479:	0f b6 00             	movzbl (%eax),%eax
 47c:	0f be c0             	movsbl %al,%eax
 47f:	83 ec 08             	sub    $0x8,%esp
 482:	50                   	push   %eax
 483:	ff 75 08             	pushl  0x8(%ebp)
 486:	e8 3c ff ff ff       	call   3c7 <putc>
 48b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 48e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 496:	79 d9                	jns    471 <printint+0x87>
    putc(fd, buf[i]);
}
 498:	90                   	nop
 499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 49c:	c9                   	leave  
 49d:	c3                   	ret    

0000049e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 49e:	55                   	push   %ebp
 49f:	89 e5                	mov    %esp,%ebp
 4a1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ab:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ae:	83 c0 04             	add    $0x4,%eax
 4b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4bb:	e9 59 01 00 00       	jmp    619 <printf+0x17b>
    c = fmt[i] & 0xff;
 4c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c6:	01 d0                	add    %edx,%eax
 4c8:	0f b6 00             	movzbl (%eax),%eax
 4cb:	0f be c0             	movsbl %al,%eax
 4ce:	25 ff 00 00 00       	and    $0xff,%eax
 4d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4da:	75 2c                	jne    508 <printf+0x6a>
      if(c == '%'){
 4dc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e0:	75 0c                	jne    4ee <printf+0x50>
        state = '%';
 4e2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e9:	e9 27 01 00 00       	jmp    615 <printf+0x177>
      } else {
        putc(fd, c);
 4ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f1:	0f be c0             	movsbl %al,%eax
 4f4:	83 ec 08             	sub    $0x8,%esp
 4f7:	50                   	push   %eax
 4f8:	ff 75 08             	pushl  0x8(%ebp)
 4fb:	e8 c7 fe ff ff       	call   3c7 <putc>
 500:	83 c4 10             	add    $0x10,%esp
 503:	e9 0d 01 00 00       	jmp    615 <printf+0x177>
      }
    } else if(state == '%'){
 508:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 50c:	0f 85 03 01 00 00    	jne    615 <printf+0x177>
      if(c == 'd'){
 512:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 516:	75 1e                	jne    536 <printf+0x98>
        printint(fd, *ap, 10, 1);
 518:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51b:	8b 00                	mov    (%eax),%eax
 51d:	6a 01                	push   $0x1
 51f:	6a 0a                	push   $0xa
 521:	50                   	push   %eax
 522:	ff 75 08             	pushl  0x8(%ebp)
 525:	e8 c0 fe ff ff       	call   3ea <printint>
 52a:	83 c4 10             	add    $0x10,%esp
        ap++;
 52d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 531:	e9 d8 00 00 00       	jmp    60e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 536:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 53a:	74 06                	je     542 <printf+0xa4>
 53c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 540:	75 1e                	jne    560 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 00                	mov    (%eax),%eax
 547:	6a 00                	push   $0x0
 549:	6a 10                	push   $0x10
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 96 fe ff ff       	call   3ea <printint>
 554:	83 c4 10             	add    $0x10,%esp
        ap++;
 557:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55b:	e9 ae 00 00 00       	jmp    60e <printf+0x170>
      } else if(c == 's'){
 560:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 564:	75 43                	jne    5a9 <printf+0x10b>
        s = (char*)*ap;
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	8b 00                	mov    (%eax),%eax
 56b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 576:	75 25                	jne    59d <printf+0xff>
          s = "(null)";
 578:	c7 45 f4 67 08 00 00 	movl   $0x867,-0xc(%ebp)
        while(*s != 0){
 57f:	eb 1c                	jmp    59d <printf+0xff>
          putc(fd, *s);
 581:	8b 45 f4             	mov    -0xc(%ebp),%eax
 584:	0f b6 00             	movzbl (%eax),%eax
 587:	0f be c0             	movsbl %al,%eax
 58a:	83 ec 08             	sub    $0x8,%esp
 58d:	50                   	push   %eax
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 31 fe ff ff       	call   3c7 <putc>
 596:	83 c4 10             	add    $0x10,%esp
          s++;
 599:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 59d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a0:	0f b6 00             	movzbl (%eax),%eax
 5a3:	84 c0                	test   %al,%al
 5a5:	75 da                	jne    581 <printf+0xe3>
 5a7:	eb 65                	jmp    60e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ad:	75 1d                	jne    5cc <printf+0x12e>
        putc(fd, *ap);
 5af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	0f be c0             	movsbl %al,%eax
 5b7:	83 ec 08             	sub    $0x8,%esp
 5ba:	50                   	push   %eax
 5bb:	ff 75 08             	pushl  0x8(%ebp)
 5be:	e8 04 fe ff ff       	call   3c7 <putc>
 5c3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ca:	eb 42                	jmp    60e <printf+0x170>
      } else if(c == '%'){
 5cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d0:	75 17                	jne    5e9 <printf+0x14b>
        putc(fd, c);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 e3 fd ff ff       	call   3c7 <putc>
 5e4:	83 c4 10             	add    $0x10,%esp
 5e7:	eb 25                	jmp    60e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	6a 25                	push   $0x25
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 d1 fd ff ff       	call   3c7 <putc>
 5f6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	83 ec 08             	sub    $0x8,%esp
 602:	50                   	push   %eax
 603:	ff 75 08             	pushl  0x8(%ebp)
 606:	e8 bc fd ff ff       	call   3c7 <putc>
 60b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 60e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 615:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 619:	8b 55 0c             	mov    0xc(%ebp),%edx
 61c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61f:	01 d0                	add    %edx,%eax
 621:	0f b6 00             	movzbl (%eax),%eax
 624:	84 c0                	test   %al,%al
 626:	0f 85 94 fe ff ff    	jne    4c0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 62c:	90                   	nop
 62d:	c9                   	leave  
 62e:	c3                   	ret    

0000062f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	83 e8 08             	sub    $0x8,%eax
 63b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63e:	a1 f0 0a 00 00       	mov    0xaf0,%eax
 643:	89 45 fc             	mov    %eax,-0x4(%ebp)
 646:	eb 24                	jmp    66c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 650:	77 12                	ja     664 <free+0x35>
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 658:	77 24                	ja     67e <free+0x4f>
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 662:	77 1a                	ja     67e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 672:	76 d4                	jbe    648 <free+0x19>
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67c:	76 ca                	jbe    648 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	01 c2                	add    %eax,%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	39 c2                	cmp    %eax,%edx
 697:	75 24                	jne    6bd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 50 04             	mov    0x4(%eax),%edx
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	8b 40 04             	mov    0x4(%eax),%eax
 6a7:	01 c2                	add    %eax,%edx
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	8b 10                	mov    (%eax),%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	89 10                	mov    %edx,(%eax)
 6bb:	eb 0a                	jmp    6c7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 10                	mov    (%eax),%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	01 d0                	add    %edx,%eax
 6d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6dc:	75 20                	jne    6fe <free+0xcf>
    p->s.size += bp->s.size;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 50 04             	mov    0x4(%eax),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	8b 40 04             	mov    0x4(%eax),%eax
 6ea:	01 c2                	add    %eax,%edx
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
 6fc:	eb 08                	jmp    706 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 55 f8             	mov    -0x8(%ebp),%edx
 704:	89 10                	mov    %edx,(%eax)
  freep = p;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	a3 f0 0a 00 00       	mov    %eax,0xaf0
}
 70e:	90                   	nop
 70f:	c9                   	leave  
 710:	c3                   	ret    

00000711 <morecore>:

static Header*
morecore(uint nu)
{
 711:	55                   	push   %ebp
 712:	89 e5                	mov    %esp,%ebp
 714:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 717:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71e:	77 07                	ja     727 <morecore+0x16>
    nu = 4096;
 720:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	c1 e0 03             	shl    $0x3,%eax
 72d:	83 ec 0c             	sub    $0xc,%esp
 730:	50                   	push   %eax
 731:	e8 31 fc ff ff       	call   367 <sbrk>
 736:	83 c4 10             	add    $0x10,%esp
 739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 73c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 740:	75 07                	jne    749 <morecore+0x38>
    return 0;
 742:	b8 00 00 00 00       	mov    $0x0,%eax
 747:	eb 26                	jmp    76f <morecore+0x5e>
  hp = (Header*)p;
 749:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	8b 55 08             	mov    0x8(%ebp),%edx
 755:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 758:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75b:	83 c0 08             	add    $0x8,%eax
 75e:	83 ec 0c             	sub    $0xc,%esp
 761:	50                   	push   %eax
 762:	e8 c8 fe ff ff       	call   62f <free>
 767:	83 c4 10             	add    $0x10,%esp
  return freep;
 76a:	a1 f0 0a 00 00       	mov    0xaf0,%eax
}
 76f:	c9                   	leave  
 770:	c3                   	ret    

00000771 <malloc>:

void*
malloc(uint nbytes)
{
 771:	55                   	push   %ebp
 772:	89 e5                	mov    %esp,%ebp
 774:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	83 c0 07             	add    $0x7,%eax
 77d:	c1 e8 03             	shr    $0x3,%eax
 780:	83 c0 01             	add    $0x1,%eax
 783:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 786:	a1 f0 0a 00 00       	mov    0xaf0,%eax
 78b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 792:	75 23                	jne    7b7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 794:	c7 45 f0 e8 0a 00 00 	movl   $0xae8,-0x10(%ebp)
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79e:	a3 f0 0a 00 00       	mov    %eax,0xaf0
 7a3:	a1 f0 0a 00 00       	mov    0xaf0,%eax
 7a8:	a3 e8 0a 00 00       	mov    %eax,0xae8
    base.s.size = 0;
 7ad:	c7 05 ec 0a 00 00 00 	movl   $0x0,0xaec
 7b4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 40 04             	mov    0x4(%eax),%eax
 7c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c8:	72 4d                	jb     817 <malloc+0xa6>
      if(p->s.size == nunits)
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d3:	75 0c                	jne    7e1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 10                	mov    (%eax),%edx
 7da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dd:	89 10                	mov    %edx,(%eax)
 7df:	eb 26                	jmp    807 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ea:	89 c2                	mov    %eax,%edx
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	c1 e0 03             	shl    $0x3,%eax
 7fb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 807:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80a:	a3 f0 0a 00 00       	mov    %eax,0xaf0
      return (void*)(p + 1);
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	83 c0 08             	add    $0x8,%eax
 815:	eb 3b                	jmp    852 <malloc+0xe1>
    }
    if(p == freep)
 817:	a1 f0 0a 00 00       	mov    0xaf0,%eax
 81c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81f:	75 1e                	jne    83f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 821:	83 ec 0c             	sub    $0xc,%esp
 824:	ff 75 ec             	pushl  -0x14(%ebp)
 827:	e8 e5 fe ff ff       	call   711 <morecore>
 82c:	83 c4 10             	add    $0x10,%esp
 82f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 836:	75 07                	jne    83f <malloc+0xce>
        return 0;
 838:	b8 00 00 00 00       	mov    $0x0,%eax
 83d:	eb 13                	jmp    852 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	89 45 f0             	mov    %eax,-0x10(%ebp)
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 84d:	e9 6d ff ff ff       	jmp    7bf <malloc+0x4e>
}
 852:	c9                   	leave  
 853:	c3                   	ret    
