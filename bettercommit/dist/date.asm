
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
  1b:	e8 6d 03 00 00       	call   38d <date>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	74 17                	je     3e <main+0x3e>

        printf(2, "Date_failed\n");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 5c 08 00 00       	push   $0x85c
  2f:	6a 02                	push   $0x2
  31:	e8 6e 04 00 00       	call   4a4 <printf>
  36:	83 c4 10             	add    $0x10,%esp
        exit();
  39:	e8 a7 02 00 00       	call   2e5 <exit>
    }

    if( date(&r) == 0){
  3e:	83 ec 0c             	sub    $0xc,%esp
  41:	8d 45 d0             	lea    -0x30(%ebp),%eax
  44:	50                   	push   %eax
  45:	e8 43 03 00 00       	call   38d <date>
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
  69:	68 6c 08 00 00       	push   $0x86c
  6e:	6a 01                	push   $0x1
  70:	e8 2f 04 00 00       	call   4a4 <printf>
  75:	83 c4 20             	add    $0x20,%esp
        exit();
  78:	e8 68 02 00 00       	call   2e5 <exit>
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

0000008e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	57                   	push   %edi
  92:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  96:	8b 55 10             	mov    0x10(%ebp),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	89 cb                	mov    %ecx,%ebx
  9e:	89 df                	mov    %ebx,%edi
  a0:	89 d1                	mov    %edx,%ecx
  a2:	fc                   	cld    
  a3:	f3 aa                	rep stos %al,%es:(%edi)
  a5:	89 ca                	mov    %ecx,%edx
  a7:	89 fb                	mov    %edi,%ebx
  a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ac:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  af:	90                   	nop
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c0:	90                   	nop
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	8d 50 01             	lea    0x1(%eax),%edx
  c7:	89 55 08             	mov    %edx,0x8(%ebp)
  ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d3:	0f b6 12             	movzbl (%edx),%edx
  d6:	88 10                	mov    %dl,(%eax)
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 e2                	jne    c1 <strcpy+0xd>
    ;
  return os;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e7:	eb 08                	jmp    f1 <strcmp+0xd>
    p++, q++;
  e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	84 c0                	test   %al,%al
  f9:	74 10                	je     10b <strcmp+0x27>
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 10             	movzbl (%eax),%edx
 101:	8b 45 0c             	mov    0xc(%ebp),%eax
 104:	0f b6 00             	movzbl (%eax),%eax
 107:	38 c2                	cmp    %al,%dl
 109:	74 de                	je     e9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	0f b6 d0             	movzbl %al,%edx
 114:	8b 45 0c             	mov    0xc(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	0f b6 c0             	movzbl %al,%eax
 11d:	29 c2                	sub    %eax,%edx
 11f:	89 d0                	mov    %edx,%eax
}
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    

00000123 <strlen>:

uint
strlen(char *s)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 130:	eb 04                	jmp    136 <strlen+0x13>
 132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 136:	8b 55 fc             	mov    -0x4(%ebp),%edx
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	01 d0                	add    %edx,%eax
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	84 c0                	test   %al,%al
 143:	75 ed                	jne    132 <strlen+0xf>
    ;
  return n;
 145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14d:	8b 45 10             	mov    0x10(%ebp),%eax
 150:	50                   	push   %eax
 151:	ff 75 0c             	pushl  0xc(%ebp)
 154:	ff 75 08             	pushl  0x8(%ebp)
 157:	e8 32 ff ff ff       	call   8e <stosb>
 15c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 162:	c9                   	leave  
 163:	c3                   	ret    

00000164 <strchr>:

char*
strchr(const char *s, char c)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	83 ec 04             	sub    $0x4,%esp
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 170:	eb 14                	jmp    186 <strchr+0x22>
    if(*s == c)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17b:	75 05                	jne    182 <strchr+0x1e>
      return (char*)s;
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	eb 13                	jmp    195 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 182:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	84 c0                	test   %al,%al
 18e:	75 e2                	jne    172 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 190:	b8 00 00 00 00       	mov    $0x0,%eax
}
 195:	c9                   	leave  
 196:	c3                   	ret    

00000197 <gets>:

char*
gets(char *buf, int max)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a4:	eb 42                	jmp    1e8 <gets+0x51>
    cc = read(0, &c, 1);
 1a6:	83 ec 04             	sub    $0x4,%esp
 1a9:	6a 01                	push   $0x1
 1ab:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ae:	50                   	push   %eax
 1af:	6a 00                	push   $0x0
 1b1:	e8 47 01 00 00       	call   2fd <read>
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c0:	7e 33                	jle    1f5 <gets+0x5e>
      break;
    buf[i++] = c;
 1c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c5:	8d 50 01             	lea    0x1(%eax),%edx
 1c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cb:	89 c2                	mov    %eax,%edx
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	01 c2                	add    %eax,%edx
 1d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 16                	je     1f6 <gets+0x5f>
 1e0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e4:	3c 0d                	cmp    $0xd,%al
 1e6:	74 0e                	je     1f6 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1eb:	83 c0 01             	add    $0x1,%eax
 1ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f1:	7c b3                	jl     1a6 <gets+0xf>
 1f3:	eb 01                	jmp    1f6 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f5:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(char *n, struct stat *st)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 0c 01 00 00       	call   325 <open>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 223:	79 07                	jns    22c <stat+0x26>
    return -1;
 225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22a:	eb 25                	jmp    251 <stat+0x4b>
  r = fstat(fd, st);
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	ff 75 0c             	pushl  0xc(%ebp)
 232:	ff 75 f4             	pushl  -0xc(%ebp)
 235:	e8 03 01 00 00       	call   33d <fstat>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 240:	83 ec 0c             	sub    $0xc,%esp
 243:	ff 75 f4             	pushl  -0xc(%ebp)
 246:	e8 c2 00 00 00       	call   30d <close>
 24b:	83 c4 10             	add    $0x10,%esp
  return r;
 24e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <atoi>:

int
atoi(const char *s)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 260:	eb 25                	jmp    287 <atoi+0x34>
    n = n*10 + *s++ - '0';
 262:	8b 55 fc             	mov    -0x4(%ebp),%edx
 265:	89 d0                	mov    %edx,%eax
 267:	c1 e0 02             	shl    $0x2,%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	01 c0                	add    %eax,%eax
 26e:	89 c1                	mov    %eax,%ecx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8d 50 01             	lea    0x1(%eax),%edx
 276:	89 55 08             	mov    %edx,0x8(%ebp)
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	0f be c0             	movsbl %al,%eax
 27f:	01 c8                	add    %ecx,%eax
 281:	83 e8 30             	sub    $0x30,%eax
 284:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	3c 2f                	cmp    $0x2f,%al
 28f:	7e 0a                	jle    29b <atoi+0x48>
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 39                	cmp    $0x39,%al
 299:	7e c7                	jle    262 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b2:	eb 17                	jmp    2cb <memmove+0x2b>
    *dst++ = *src++;
 2b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b7:	8d 50 01             	lea    0x1(%eax),%edx
 2ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c0:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c6:	0f b6 12             	movzbl (%edx),%edx
 2c9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2cb:	8b 45 10             	mov    0x10(%ebp),%eax
 2ce:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d1:	89 55 10             	mov    %edx,0x10(%ebp)
 2d4:	85 c0                	test   %eax,%eax
 2d6:	7f dc                	jg     2b4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    

000002dd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2dd:	b8 01 00 00 00       	mov    $0x1,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <exit>:
SYSCALL(exit)
 2e5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <wait>:
SYSCALL(wait)
 2ed:	b8 03 00 00 00       	mov    $0x3,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <pipe>:
SYSCALL(pipe)
 2f5:	b8 04 00 00 00       	mov    $0x4,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <read>:
SYSCALL(read)
 2fd:	b8 05 00 00 00       	mov    $0x5,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <write>:
SYSCALL(write)
 305:	b8 10 00 00 00       	mov    $0x10,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <close>:
SYSCALL(close)
 30d:	b8 15 00 00 00       	mov    $0x15,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <kill>:
SYSCALL(kill)
 315:	b8 06 00 00 00       	mov    $0x6,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <exec>:
SYSCALL(exec)
 31d:	b8 07 00 00 00       	mov    $0x7,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <open>:
SYSCALL(open)
 325:	b8 0f 00 00 00       	mov    $0xf,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <mknod>:
SYSCALL(mknod)
 32d:	b8 11 00 00 00       	mov    $0x11,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <unlink>:
SYSCALL(unlink)
 335:	b8 12 00 00 00       	mov    $0x12,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <fstat>:
SYSCALL(fstat)
 33d:	b8 08 00 00 00       	mov    $0x8,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <link>:
SYSCALL(link)
 345:	b8 13 00 00 00       	mov    $0x13,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <mkdir>:
SYSCALL(mkdir)
 34d:	b8 14 00 00 00       	mov    $0x14,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <chdir>:
SYSCALL(chdir)
 355:	b8 09 00 00 00       	mov    $0x9,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <dup>:
SYSCALL(dup)
 35d:	b8 0a 00 00 00       	mov    $0xa,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <getpid>:
SYSCALL(getpid)
 365:	b8 0b 00 00 00       	mov    $0xb,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sbrk>:
SYSCALL(sbrk)
 36d:	b8 0c 00 00 00       	mov    $0xc,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <sleep>:
SYSCALL(sleep)
 375:	b8 0d 00 00 00       	mov    $0xd,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <uptime>:
SYSCALL(uptime)
 37d:	b8 0e 00 00 00       	mov    $0xe,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <halt>:
SYSCALL(halt)
 385:	b8 16 00 00 00       	mov    $0x16,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <date>:
//Student Implementations 
SYSCALL(date)
 38d:	b8 17 00 00 00       	mov    $0x17,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <getuid>:

SYSCALL(getuid)
 395:	b8 18 00 00 00       	mov    $0x18,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <getgid>:
SYSCALL(getgid)
 39d:	b8 19 00 00 00       	mov    $0x19,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <getppid>:
SYSCALL(getppid)
 3a5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <setuid>:

SYSCALL(setuid)
 3ad:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <setgid>:
SYSCALL(setgid)
 3b5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <getprocs>:
SYSCALL(getprocs)
 3bd:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <setpriority>:
// Project 3
SYSCALL(setpriority)
 3c5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	83 ec 18             	sub    $0x18,%esp
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d9:	83 ec 04             	sub    $0x4,%esp
 3dc:	6a 01                	push   $0x1
 3de:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e1:	50                   	push   %eax
 3e2:	ff 75 08             	pushl  0x8(%ebp)
 3e5:	e8 1b ff ff ff       	call   305 <write>
 3ea:	83 c4 10             	add    $0x10,%esp
}
 3ed:	90                   	nop
 3ee:	c9                   	leave  
 3ef:	c3                   	ret    

000003f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	53                   	push   %ebx
 3f4:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3fe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 402:	74 17                	je     41b <printint+0x2b>
 404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 408:	79 11                	jns    41b <printint+0x2b>
    neg = 1;
 40a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 411:	8b 45 0c             	mov    0xc(%ebp),%eax
 414:	f7 d8                	neg    %eax
 416:	89 45 ec             	mov    %eax,-0x14(%ebp)
 419:	eb 06                	jmp    421 <printint+0x31>
  } else {
    x = xx;
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 421:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 428:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 42b:	8d 41 01             	lea    0x1(%ecx),%eax
 42e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 431:	8b 5d 10             	mov    0x10(%ebp),%ebx
 434:	8b 45 ec             	mov    -0x14(%ebp),%eax
 437:	ba 00 00 00 00       	mov    $0x0,%edx
 43c:	f7 f3                	div    %ebx
 43e:	89 d0                	mov    %edx,%eax
 440:	0f b6 80 1c 0b 00 00 	movzbl 0xb1c(%eax),%eax
 447:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 44b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f3                	div    %ebx
 458:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45f:	75 c7                	jne    428 <printint+0x38>
  if(neg)
 461:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 465:	74 2d                	je     494 <printint+0xa4>
    buf[i++] = '-';
 467:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46a:	8d 50 01             	lea    0x1(%eax),%edx
 46d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 470:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 475:	eb 1d                	jmp    494 <printint+0xa4>
    putc(fd, buf[i]);
 477:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	01 d0                	add    %edx,%eax
 47f:	0f b6 00             	movzbl (%eax),%eax
 482:	0f be c0             	movsbl %al,%eax
 485:	83 ec 08             	sub    $0x8,%esp
 488:	50                   	push   %eax
 489:	ff 75 08             	pushl  0x8(%ebp)
 48c:	e8 3c ff ff ff       	call   3cd <putc>
 491:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 494:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 498:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49c:	79 d9                	jns    477 <printint+0x87>
    putc(fd, buf[i]);
}
 49e:	90                   	nop
 49f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b4:	83 c0 04             	add    $0x4,%eax
 4b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c1:	e9 59 01 00 00       	jmp    61f <printf+0x17b>
    c = fmt[i] & 0xff;
 4c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	0f b6 00             	movzbl (%eax),%eax
 4d1:	0f be c0             	movsbl %al,%eax
 4d4:	25 ff 00 00 00       	and    $0xff,%eax
 4d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e0:	75 2c                	jne    50e <printf+0x6a>
      if(c == '%'){
 4e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e6:	75 0c                	jne    4f4 <printf+0x50>
        state = '%';
 4e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ef:	e9 27 01 00 00       	jmp    61b <printf+0x177>
      } else {
        putc(fd, c);
 4f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f7:	0f be c0             	movsbl %al,%eax
 4fa:	83 ec 08             	sub    $0x8,%esp
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 c7 fe ff ff       	call   3cd <putc>
 506:	83 c4 10             	add    $0x10,%esp
 509:	e9 0d 01 00 00       	jmp    61b <printf+0x177>
      }
    } else if(state == '%'){
 50e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 512:	0f 85 03 01 00 00    	jne    61b <printf+0x177>
      if(c == 'd'){
 518:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51c:	75 1e                	jne    53c <printf+0x98>
        printint(fd, *ap, 10, 1);
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	6a 01                	push   $0x1
 525:	6a 0a                	push   $0xa
 527:	50                   	push   %eax
 528:	ff 75 08             	pushl  0x8(%ebp)
 52b:	e8 c0 fe ff ff       	call   3f0 <printint>
 530:	83 c4 10             	add    $0x10,%esp
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	e9 d8 00 00 00       	jmp    614 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 53c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 540:	74 06                	je     548 <printf+0xa4>
 542:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 546:	75 1e                	jne    566 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 548:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	6a 00                	push   $0x0
 54f:	6a 10                	push   $0x10
 551:	50                   	push   %eax
 552:	ff 75 08             	pushl  0x8(%ebp)
 555:	e8 96 fe ff ff       	call   3f0 <printint>
 55a:	83 c4 10             	add    $0x10,%esp
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 561:	e9 ae 00 00 00       	jmp    614 <printf+0x170>
      } else if(c == 's'){
 566:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56a:	75 43                	jne    5af <printf+0x10b>
        s = (char*)*ap;
 56c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56f:	8b 00                	mov    (%eax),%eax
 571:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57c:	75 25                	jne    5a3 <printf+0xff>
          s = "(null)";
 57e:	c7 45 f4 aa 08 00 00 	movl   $0x8aa,-0xc(%ebp)
        while(*s != 0){
 585:	eb 1c                	jmp    5a3 <printf+0xff>
          putc(fd, *s);
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 31 fe ff ff       	call   3cd <putc>
 59c:	83 c4 10             	add    $0x10,%esp
          s++;
 59f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a6:	0f b6 00             	movzbl (%eax),%eax
 5a9:	84 c0                	test   %al,%al
 5ab:	75 da                	jne    587 <printf+0xe3>
 5ad:	eb 65                	jmp    614 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b3:	75 1d                	jne    5d2 <printf+0x12e>
        putc(fd, *ap);
 5b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 04 fe ff ff       	call   3cd <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d0:	eb 42                	jmp    614 <printf+0x170>
      } else if(c == '%'){
 5d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d6:	75 17                	jne    5ef <printf+0x14b>
        putc(fd, c);
 5d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	83 ec 08             	sub    $0x8,%esp
 5e1:	50                   	push   %eax
 5e2:	ff 75 08             	pushl  0x8(%ebp)
 5e5:	e8 e3 fd ff ff       	call   3cd <putc>
 5ea:	83 c4 10             	add    $0x10,%esp
 5ed:	eb 25                	jmp    614 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ef:	83 ec 08             	sub    $0x8,%esp
 5f2:	6a 25                	push   $0x25
 5f4:	ff 75 08             	pushl  0x8(%ebp)
 5f7:	e8 d1 fd ff ff       	call   3cd <putc>
 5fc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 602:	0f be c0             	movsbl %al,%eax
 605:	83 ec 08             	sub    $0x8,%esp
 608:	50                   	push   %eax
 609:	ff 75 08             	pushl  0x8(%ebp)
 60c:	e8 bc fd ff ff       	call   3cd <putc>
 611:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 614:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 61f:	8b 55 0c             	mov    0xc(%ebp),%edx
 622:	8b 45 f0             	mov    -0x10(%ebp),%eax
 625:	01 d0                	add    %edx,%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	84 c0                	test   %al,%al
 62c:	0f 85 94 fe ff ff    	jne    4c6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 632:	90                   	nop
 633:	c9                   	leave  
 634:	c3                   	ret    

00000635 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 635:	55                   	push   %ebp
 636:	89 e5                	mov    %esp,%ebp
 638:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	83 e8 08             	sub    $0x8,%eax
 641:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 644:	a1 38 0b 00 00       	mov    0xb38,%eax
 649:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64c:	eb 24                	jmp    672 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 656:	77 12                	ja     66a <free+0x35>
 658:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65e:	77 24                	ja     684 <free+0x4f>
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 668:	77 1a                	ja     684 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 678:	76 d4                	jbe    64e <free+0x19>
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 682:	76 ca                	jbe    64e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	8b 40 04             	mov    0x4(%eax),%eax
 68a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	01 c2                	add    %eax,%edx
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 00                	mov    (%eax),%eax
 69b:	39 c2                	cmp    %eax,%edx
 69d:	75 24                	jne    6c3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 50 04             	mov    0x4(%eax),%edx
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	8b 40 04             	mov    0x4(%eax),%eax
 6ad:	01 c2                	add    %eax,%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	8b 10                	mov    (%eax),%edx
 6bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bf:	89 10                	mov    %edx,(%eax)
 6c1:	eb 0a                	jmp    6cd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 10                	mov    (%eax),%edx
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 40 04             	mov    0x4(%eax),%eax
 6d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	01 d0                	add    %edx,%eax
 6df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e2:	75 20                	jne    704 <free+0xcf>
    p->s.size += bp->s.size;
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 50 04             	mov    0x4(%eax),%edx
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	8b 40 04             	mov    0x4(%eax),%eax
 6f0:	01 c2                	add    %eax,%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	8b 10                	mov    (%eax),%edx
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	89 10                	mov    %edx,(%eax)
 702:	eb 08                	jmp    70c <free+0xd7>
  } else
    p->s.ptr = bp;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70a:	89 10                	mov    %edx,(%eax)
  freep = p;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	a3 38 0b 00 00       	mov    %eax,0xb38
}
 714:	90                   	nop
 715:	c9                   	leave  
 716:	c3                   	ret    

00000717 <morecore>:

static Header*
morecore(uint nu)
{
 717:	55                   	push   %ebp
 718:	89 e5                	mov    %esp,%ebp
 71a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 724:	77 07                	ja     72d <morecore+0x16>
    nu = 4096;
 726:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72d:	8b 45 08             	mov    0x8(%ebp),%eax
 730:	c1 e0 03             	shl    $0x3,%eax
 733:	83 ec 0c             	sub    $0xc,%esp
 736:	50                   	push   %eax
 737:	e8 31 fc ff ff       	call   36d <sbrk>
 73c:	83 c4 10             	add    $0x10,%esp
 73f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 742:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 746:	75 07                	jne    74f <morecore+0x38>
    return 0;
 748:	b8 00 00 00 00       	mov    $0x0,%eax
 74d:	eb 26                	jmp    775 <morecore+0x5e>
  hp = (Header*)p;
 74f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	8b 55 08             	mov    0x8(%ebp),%edx
 75b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 761:	83 c0 08             	add    $0x8,%eax
 764:	83 ec 0c             	sub    $0xc,%esp
 767:	50                   	push   %eax
 768:	e8 c8 fe ff ff       	call   635 <free>
 76d:	83 c4 10             	add    $0x10,%esp
  return freep;
 770:	a1 38 0b 00 00       	mov    0xb38,%eax
}
 775:	c9                   	leave  
 776:	c3                   	ret    

00000777 <malloc>:

void*
malloc(uint nbytes)
{
 777:	55                   	push   %ebp
 778:	89 e5                	mov    %esp,%ebp
 77a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	83 c0 07             	add    $0x7,%eax
 783:	c1 e8 03             	shr    $0x3,%eax
 786:	83 c0 01             	add    $0x1,%eax
 789:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78c:	a1 38 0b 00 00       	mov    0xb38,%eax
 791:	89 45 f0             	mov    %eax,-0x10(%ebp)
 794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 798:	75 23                	jne    7bd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 79a:	c7 45 f0 30 0b 00 00 	movl   $0xb30,-0x10(%ebp)
 7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a4:	a3 38 0b 00 00       	mov    %eax,0xb38
 7a9:	a1 38 0b 00 00       	mov    0xb38,%eax
 7ae:	a3 30 0b 00 00       	mov    %eax,0xb30
    base.s.size = 0;
 7b3:	c7 05 34 0b 00 00 00 	movl   $0x0,0xb34
 7ba:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ce:	72 4d                	jb     81d <malloc+0xa6>
      if(p->s.size == nunits)
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d9:	75 0c                	jne    7e7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 10                	mov    (%eax),%edx
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	89 10                	mov    %edx,(%eax)
 7e5:	eb 26                	jmp    80d <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f0:	89 c2                	mov    %eax,%edx
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	c1 e0 03             	shl    $0x3,%eax
 801:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 810:	a3 38 0b 00 00       	mov    %eax,0xb38
      return (void*)(p + 1);
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	83 c0 08             	add    $0x8,%eax
 81b:	eb 3b                	jmp    858 <malloc+0xe1>
    }
    if(p == freep)
 81d:	a1 38 0b 00 00       	mov    0xb38,%eax
 822:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 825:	75 1e                	jne    845 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 827:	83 ec 0c             	sub    $0xc,%esp
 82a:	ff 75 ec             	pushl  -0x14(%ebp)
 82d:	e8 e5 fe ff ff       	call   717 <morecore>
 832:	83 c4 10             	add    $0x10,%esp
 835:	89 45 f4             	mov    %eax,-0xc(%ebp)
 838:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83c:	75 07                	jne    845 <malloc+0xce>
        return 0;
 83e:	b8 00 00 00 00       	mov    $0x0,%eax
 843:	eb 13                	jmp    858 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 00                	mov    (%eax),%eax
 850:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 853:	e9 6d ff ff ff       	jmp    7c5 <malloc+0x4e>
}
 858:	c9                   	leave  
 859:	c3                   	ret    
