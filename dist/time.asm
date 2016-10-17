
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
  1d:	68 a0 08 00 00       	push   $0x8a0
  22:	6a 01                	push   $0x1
  24:	e8 c0 04 00 00       	call   4e9 <printf>
  29:	83 c4 10             	add    $0x10,%esp

  
  uint start = (uint)uptime();
  2c:	e8 99 03 00 00       	call   3ca <uptime>
  31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint finish = 0;
  34:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  uint pid = fork();
  3b:	e8 ea 02 00 00       	call   32a <fork>
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
  5c:	e8 09 03 00 00       	call   36a <exec>
  61:	83 c4 10             	add    $0x10,%esp
  64:	85 c0                	test   %eax,%eax
  66:	74 1c                	je     84 <main+0x84>
          printf(1, "Exec Failed");
  68:	83 ec 08             	sub    $0x8,%esp
  6b:	68 f0 08 00 00       	push   $0x8f0
  70:	6a 01                	push   $0x1
  72:	e8 72 04 00 00       	call   4e9 <printf>
  77:	83 c4 10             	add    $0x10,%esp
          exit();
  7a:	e8 b3 02 00 00       	call   332 <exit>
      }
  }
  else{
    wait();
  7f:	e8 b6 02 00 00       	call   33a <wait>
  }

    finish  = (uint)uptime();
  84:	e8 41 03 00 00       	call   3ca <uptime>
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
  c7:	68 fc 08 00 00       	push   $0x8fc
  cc:	6a 01                	push   $0x1
  ce:	e8 16 04 00 00       	call   4e9 <printf>
  d3:	83 c4 20             	add    $0x20,%esp
  
  exit();
  d6:	e8 57 02 00 00       	call   332 <exit>

000000db <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e3:	8b 55 10             	mov    0x10(%ebp),%edx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	89 cb                	mov    %ecx,%ebx
  eb:	89 df                	mov    %ebx,%edi
  ed:	89 d1                	mov    %edx,%ecx
  ef:	fc                   	cld    
  f0:	f3 aa                	rep stos %al,%es:(%edi)
  f2:	89 ca                	mov    %ecx,%edx
  f4:	89 fb                	mov    %edi,%ebx
  f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  fc:	90                   	nop
  fd:	5b                   	pop    %ebx
  fe:	5f                   	pop    %edi
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    

00000101 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 10d:	90                   	nop
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	8d 50 01             	lea    0x1(%eax),%edx
 114:	89 55 08             	mov    %edx,0x8(%ebp)
 117:	8b 55 0c             	mov    0xc(%ebp),%edx
 11a:	8d 4a 01             	lea    0x1(%edx),%ecx
 11d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 120:	0f b6 12             	movzbl (%edx),%edx
 123:	88 10                	mov    %dl,(%eax)
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	84 c0                	test   %al,%al
 12a:	75 e2                	jne    10e <strcpy+0xd>
    ;
  return os;
 12c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 134:	eb 08                	jmp    13e <strcmp+0xd>
    p++, q++;
 136:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
 141:	0f b6 00             	movzbl (%eax),%eax
 144:	84 c0                	test   %al,%al
 146:	74 10                	je     158 <strcmp+0x27>
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	0f b6 10             	movzbl (%eax),%edx
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	0f b6 00             	movzbl (%eax),%eax
 154:	38 c2                	cmp    %al,%dl
 156:	74 de                	je     136 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	0f b6 d0             	movzbl %al,%edx
 161:	8b 45 0c             	mov    0xc(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	0f b6 c0             	movzbl %al,%eax
 16a:	29 c2                	sub    %eax,%edx
 16c:	89 d0                	mov    %edx,%eax
}
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <strlen>:

uint
strlen(char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 17d:	eb 04                	jmp    183 <strlen+0x13>
 17f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 183:	8b 55 fc             	mov    -0x4(%ebp),%edx
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	01 d0                	add    %edx,%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 ed                	jne    17f <strlen+0xf>
    ;
  return n;
 192:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 195:	c9                   	leave  
 196:	c3                   	ret    

00000197 <memset>:

void*
memset(void *dst, int c, uint n)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 19a:	8b 45 10             	mov    0x10(%ebp),%eax
 19d:	50                   	push   %eax
 19e:	ff 75 0c             	pushl  0xc(%ebp)
 1a1:	ff 75 08             	pushl  0x8(%ebp)
 1a4:	e8 32 ff ff ff       	call   db <stosb>
 1a9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1af:	c9                   	leave  
 1b0:	c3                   	ret    

000001b1 <strchr>:

char*
strchr(const char *s, char c)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 04             	sub    $0x4,%esp
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1bd:	eb 14                	jmp    1d3 <strchr+0x22>
    if(*s == c)
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 00             	movzbl (%eax),%eax
 1c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c8:	75 05                	jne    1cf <strchr+0x1e>
      return (char*)s;
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	eb 13                	jmp    1e2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 00             	movzbl (%eax),%eax
 1d9:	84 c0                	test   %al,%al
 1db:	75 e2                	jne    1bf <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1e2:	c9                   	leave  
 1e3:	c3                   	ret    

000001e4 <gets>:

char*
gets(char *buf, int max)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1f1:	eb 42                	jmp    235 <gets+0x51>
    cc = read(0, &c, 1);
 1f3:	83 ec 04             	sub    $0x4,%esp
 1f6:	6a 01                	push   $0x1
 1f8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1fb:	50                   	push   %eax
 1fc:	6a 00                	push   $0x0
 1fe:	e8 47 01 00 00       	call   34a <read>
 203:	83 c4 10             	add    $0x10,%esp
 206:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 209:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20d:	7e 33                	jle    242 <gets+0x5e>
      break;
    buf[i++] = c;
 20f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 212:	8d 50 01             	lea    0x1(%eax),%edx
 215:	89 55 f4             	mov    %edx,-0xc(%ebp)
 218:	89 c2                	mov    %eax,%edx
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	01 c2                	add    %eax,%edx
 21f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 223:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 225:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 229:	3c 0a                	cmp    $0xa,%al
 22b:	74 16                	je     243 <gets+0x5f>
 22d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 231:	3c 0d                	cmp    $0xd,%al
 233:	74 0e                	je     243 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	83 c0 01             	add    $0x1,%eax
 23b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 23e:	7c b3                	jl     1f3 <gets+0xf>
 240:	eb 01                	jmp    243 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 242:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 243:	8b 55 f4             	mov    -0xc(%ebp),%edx
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	01 d0                	add    %edx,%eax
 24b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <stat>:

int
stat(char *n, struct stat *st)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	6a 00                	push   $0x0
 25e:	ff 75 08             	pushl  0x8(%ebp)
 261:	e8 0c 01 00 00       	call   372 <open>
 266:	83 c4 10             	add    $0x10,%esp
 269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 26c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 270:	79 07                	jns    279 <stat+0x26>
    return -1;
 272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 277:	eb 25                	jmp    29e <stat+0x4b>
  r = fstat(fd, st);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	ff 75 0c             	pushl  0xc(%ebp)
 27f:	ff 75 f4             	pushl  -0xc(%ebp)
 282:	e8 03 01 00 00       	call   38a <fstat>
 287:	83 c4 10             	add    $0x10,%esp
 28a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 28d:	83 ec 0c             	sub    $0xc,%esp
 290:	ff 75 f4             	pushl  -0xc(%ebp)
 293:	e8 c2 00 00 00       	call   35a <close>
 298:	83 c4 10             	add    $0x10,%esp
  return r;
 29b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <atoi>:

int
atoi(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ad:	eb 25                	jmp    2d4 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2af:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b2:	89 d0                	mov    %edx,%eax
 2b4:	c1 e0 02             	shl    $0x2,%eax
 2b7:	01 d0                	add    %edx,%eax
 2b9:	01 c0                	add    %eax,%eax
 2bb:	89 c1                	mov    %eax,%ecx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	8d 50 01             	lea    0x1(%eax),%edx
 2c3:	89 55 08             	mov    %edx,0x8(%ebp)
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	0f be c0             	movsbl %al,%eax
 2cc:	01 c8                	add    %ecx,%eax
 2ce:	83 e8 30             	sub    $0x30,%eax
 2d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3c 2f                	cmp    $0x2f,%al
 2dc:	7e 0a                	jle    2e8 <atoi+0x48>
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	3c 39                	cmp    $0x39,%al
 2e6:	7e c7                	jle    2af <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ff:	eb 17                	jmp    318 <memmove+0x2b>
    *dst++ = *src++;
 301:	8b 45 fc             	mov    -0x4(%ebp),%eax
 304:	8d 50 01             	lea    0x1(%eax),%edx
 307:	89 55 fc             	mov    %edx,-0x4(%ebp)
 30a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30d:	8d 4a 01             	lea    0x1(%edx),%ecx
 310:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 313:	0f b6 12             	movzbl (%edx),%edx
 316:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	8d 50 ff             	lea    -0x1(%eax),%edx
 31e:	89 55 10             	mov    %edx,0x10(%ebp)
 321:	85 c0                	test   %eax,%eax
 323:	7f dc                	jg     301 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 325:	8b 45 08             	mov    0x8(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32a:	b8 01 00 00 00       	mov    $0x1,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <exit>:
SYSCALL(exit)
 332:	b8 02 00 00 00       	mov    $0x2,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <wait>:
SYSCALL(wait)
 33a:	b8 03 00 00 00       	mov    $0x3,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <pipe>:
SYSCALL(pipe)
 342:	b8 04 00 00 00       	mov    $0x4,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <read>:
SYSCALL(read)
 34a:	b8 05 00 00 00       	mov    $0x5,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <write>:
SYSCALL(write)
 352:	b8 10 00 00 00       	mov    $0x10,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <close>:
SYSCALL(close)
 35a:	b8 15 00 00 00       	mov    $0x15,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <kill>:
SYSCALL(kill)
 362:	b8 06 00 00 00       	mov    $0x6,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <exec>:
SYSCALL(exec)
 36a:	b8 07 00 00 00       	mov    $0x7,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <open>:
SYSCALL(open)
 372:	b8 0f 00 00 00       	mov    $0xf,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mknod>:
SYSCALL(mknod)
 37a:	b8 11 00 00 00       	mov    $0x11,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <unlink>:
SYSCALL(unlink)
 382:	b8 12 00 00 00       	mov    $0x12,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <fstat>:
SYSCALL(fstat)
 38a:	b8 08 00 00 00       	mov    $0x8,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <link>:
SYSCALL(link)
 392:	b8 13 00 00 00       	mov    $0x13,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mkdir>:
SYSCALL(mkdir)
 39a:	b8 14 00 00 00       	mov    $0x14,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <chdir>:
SYSCALL(chdir)
 3a2:	b8 09 00 00 00       	mov    $0x9,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <dup>:
SYSCALL(dup)
 3aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <getpid>:
SYSCALL(getpid)
 3b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <sbrk>:
SYSCALL(sbrk)
 3ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <sleep>:
SYSCALL(sleep)
 3c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <uptime>:
SYSCALL(uptime)
 3ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <halt>:
SYSCALL(halt)
 3d2:	b8 16 00 00 00       	mov    $0x16,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <date>:
//Student Implementations 
SYSCALL(date)
 3da:	b8 17 00 00 00       	mov    $0x17,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <getuid>:

SYSCALL(getuid)
 3e2:	b8 18 00 00 00       	mov    $0x18,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <getgid>:
SYSCALL(getgid)
 3ea:	b8 19 00 00 00       	mov    $0x19,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getppid>:
SYSCALL(getppid)
 3f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <setuid>:

SYSCALL(setuid)
 3fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <setgid>:
SYSCALL(setgid)
 402:	b8 1c 00 00 00       	mov    $0x1c,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <getprocs>:
SYSCALL(getprocs)
 40a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	83 ec 18             	sub    $0x18,%esp
 418:	8b 45 0c             	mov    0xc(%ebp),%eax
 41b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 41e:	83 ec 04             	sub    $0x4,%esp
 421:	6a 01                	push   $0x1
 423:	8d 45 f4             	lea    -0xc(%ebp),%eax
 426:	50                   	push   %eax
 427:	ff 75 08             	pushl  0x8(%ebp)
 42a:	e8 23 ff ff ff       	call   352 <write>
 42f:	83 c4 10             	add    $0x10,%esp
}
 432:	90                   	nop
 433:	c9                   	leave  
 434:	c3                   	ret    

00000435 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 435:	55                   	push   %ebp
 436:	89 e5                	mov    %esp,%ebp
 438:	53                   	push   %ebx
 439:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 443:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 447:	74 17                	je     460 <printint+0x2b>
 449:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44d:	79 11                	jns    460 <printint+0x2b>
    neg = 1;
 44f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	f7 d8                	neg    %eax
 45b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45e:	eb 06                	jmp    466 <printint+0x31>
  } else {
    x = xx;
 460:	8b 45 0c             	mov    0xc(%ebp),%eax
 463:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 470:	8d 41 01             	lea    0x1(%ecx),%eax
 473:	89 45 f4             	mov    %eax,-0xc(%ebp)
 476:	8b 5d 10             	mov    0x10(%ebp),%ebx
 479:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47c:	ba 00 00 00 00       	mov    $0x0,%edx
 481:	f7 f3                	div    %ebx
 483:	89 d0                	mov    %edx,%eax
 485:	0f b6 80 70 0b 00 00 	movzbl 0xb70(%eax),%eax
 48c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 490:	8b 5d 10             	mov    0x10(%ebp),%ebx
 493:	8b 45 ec             	mov    -0x14(%ebp),%eax
 496:	ba 00 00 00 00       	mov    $0x0,%edx
 49b:	f7 f3                	div    %ebx
 49d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a4:	75 c7                	jne    46d <printint+0x38>
  if(neg)
 4a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4aa:	74 2d                	je     4d9 <printint+0xa4>
    buf[i++] = '-';
 4ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4af:	8d 50 01             	lea    0x1(%eax),%edx
 4b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ba:	eb 1d                	jmp    4d9 <printint+0xa4>
    putc(fd, buf[i]);
 4bc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c2:	01 d0                	add    %edx,%eax
 4c4:	0f b6 00             	movzbl (%eax),%eax
 4c7:	0f be c0             	movsbl %al,%eax
 4ca:	83 ec 08             	sub    $0x8,%esp
 4cd:	50                   	push   %eax
 4ce:	ff 75 08             	pushl  0x8(%ebp)
 4d1:	e8 3c ff ff ff       	call   412 <putc>
 4d6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e1:	79 d9                	jns    4bc <printint+0x87>
    putc(fd, buf[i]);
}
 4e3:	90                   	nop
 4e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e7:	c9                   	leave  
 4e8:	c3                   	ret    

000004e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e9:	55                   	push   %ebp
 4ea:	89 e5                	mov    %esp,%ebp
 4ec:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f6:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f9:	83 c0 04             	add    $0x4,%eax
 4fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 506:	e9 59 01 00 00       	jmp    664 <printf+0x17b>
    c = fmt[i] & 0xff;
 50b:	8b 55 0c             	mov    0xc(%ebp),%edx
 50e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 511:	01 d0                	add    %edx,%eax
 513:	0f b6 00             	movzbl (%eax),%eax
 516:	0f be c0             	movsbl %al,%eax
 519:	25 ff 00 00 00       	and    $0xff,%eax
 51e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 525:	75 2c                	jne    553 <printf+0x6a>
      if(c == '%'){
 527:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52b:	75 0c                	jne    539 <printf+0x50>
        state = '%';
 52d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 534:	e9 27 01 00 00       	jmp    660 <printf+0x177>
      } else {
        putc(fd, c);
 539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	83 ec 08             	sub    $0x8,%esp
 542:	50                   	push   %eax
 543:	ff 75 08             	pushl  0x8(%ebp)
 546:	e8 c7 fe ff ff       	call   412 <putc>
 54b:	83 c4 10             	add    $0x10,%esp
 54e:	e9 0d 01 00 00       	jmp    660 <printf+0x177>
      }
    } else if(state == '%'){
 553:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 557:	0f 85 03 01 00 00    	jne    660 <printf+0x177>
      if(c == 'd'){
 55d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 561:	75 1e                	jne    581 <printf+0x98>
        printint(fd, *ap, 10, 1);
 563:	8b 45 e8             	mov    -0x18(%ebp),%eax
 566:	8b 00                	mov    (%eax),%eax
 568:	6a 01                	push   $0x1
 56a:	6a 0a                	push   $0xa
 56c:	50                   	push   %eax
 56d:	ff 75 08             	pushl  0x8(%ebp)
 570:	e8 c0 fe ff ff       	call   435 <printint>
 575:	83 c4 10             	add    $0x10,%esp
        ap++;
 578:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57c:	e9 d8 00 00 00       	jmp    659 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 581:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 585:	74 06                	je     58d <printf+0xa4>
 587:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 58b:	75 1e                	jne    5ab <printf+0xc2>
        printint(fd, *ap, 16, 0);
 58d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 590:	8b 00                	mov    (%eax),%eax
 592:	6a 00                	push   $0x0
 594:	6a 10                	push   $0x10
 596:	50                   	push   %eax
 597:	ff 75 08             	pushl  0x8(%ebp)
 59a:	e8 96 fe ff ff       	call   435 <printint>
 59f:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a6:	e9 ae 00 00 00       	jmp    659 <printf+0x170>
      } else if(c == 's'){
 5ab:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5af:	75 43                	jne    5f4 <printf+0x10b>
        s = (char*)*ap;
 5b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b4:	8b 00                	mov    (%eax),%eax
 5b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c1:	75 25                	jne    5e8 <printf+0xff>
          s = "(null)";
 5c3:	c7 45 f4 17 09 00 00 	movl   $0x917,-0xc(%ebp)
        while(*s != 0){
 5ca:	eb 1c                	jmp    5e8 <printf+0xff>
          putc(fd, *s);
 5cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cf:	0f b6 00             	movzbl (%eax),%eax
 5d2:	0f be c0             	movsbl %al,%eax
 5d5:	83 ec 08             	sub    $0x8,%esp
 5d8:	50                   	push   %eax
 5d9:	ff 75 08             	pushl  0x8(%ebp)
 5dc:	e8 31 fe ff ff       	call   412 <putc>
 5e1:	83 c4 10             	add    $0x10,%esp
          s++;
 5e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5eb:	0f b6 00             	movzbl (%eax),%eax
 5ee:	84 c0                	test   %al,%al
 5f0:	75 da                	jne    5cc <printf+0xe3>
 5f2:	eb 65                	jmp    659 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f8:	75 1d                	jne    617 <printf+0x12e>
        putc(fd, *ap);
 5fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fd:	8b 00                	mov    (%eax),%eax
 5ff:	0f be c0             	movsbl %al,%eax
 602:	83 ec 08             	sub    $0x8,%esp
 605:	50                   	push   %eax
 606:	ff 75 08             	pushl  0x8(%ebp)
 609:	e8 04 fe ff ff       	call   412 <putc>
 60e:	83 c4 10             	add    $0x10,%esp
        ap++;
 611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 615:	eb 42                	jmp    659 <printf+0x170>
      } else if(c == '%'){
 617:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 61b:	75 17                	jne    634 <printf+0x14b>
        putc(fd, c);
 61d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 620:	0f be c0             	movsbl %al,%eax
 623:	83 ec 08             	sub    $0x8,%esp
 626:	50                   	push   %eax
 627:	ff 75 08             	pushl  0x8(%ebp)
 62a:	e8 e3 fd ff ff       	call   412 <putc>
 62f:	83 c4 10             	add    $0x10,%esp
 632:	eb 25                	jmp    659 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 634:	83 ec 08             	sub    $0x8,%esp
 637:	6a 25                	push   $0x25
 639:	ff 75 08             	pushl  0x8(%ebp)
 63c:	e8 d1 fd ff ff       	call   412 <putc>
 641:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 647:	0f be c0             	movsbl %al,%eax
 64a:	83 ec 08             	sub    $0x8,%esp
 64d:	50                   	push   %eax
 64e:	ff 75 08             	pushl  0x8(%ebp)
 651:	e8 bc fd ff ff       	call   412 <putc>
 656:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 659:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 660:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 664:	8b 55 0c             	mov    0xc(%ebp),%edx
 667:	8b 45 f0             	mov    -0x10(%ebp),%eax
 66a:	01 d0                	add    %edx,%eax
 66c:	0f b6 00             	movzbl (%eax),%eax
 66f:	84 c0                	test   %al,%al
 671:	0f 85 94 fe ff ff    	jne    50b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 677:	90                   	nop
 678:	c9                   	leave  
 679:	c3                   	ret    

0000067a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67a:	55                   	push   %ebp
 67b:	89 e5                	mov    %esp,%ebp
 67d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	83 e8 08             	sub    $0x8,%eax
 686:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 689:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 68e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 691:	eb 24                	jmp    6b7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69b:	77 12                	ja     6af <free+0x35>
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a3:	77 24                	ja     6c9 <free+0x4f>
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ad:	77 1a                	ja     6c9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bd:	76 d4                	jbe    693 <free+0x19>
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c7:	76 ca                	jbe    693 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	8b 40 04             	mov    0x4(%eax),%eax
 6cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	01 c2                	add    %eax,%edx
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	39 c2                	cmp    %eax,%edx
 6e2:	75 24                	jne    708 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	8b 50 04             	mov    0x4(%eax),%edx
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	8b 40 04             	mov    0x4(%eax),%eax
 6f2:	01 c2                	add    %eax,%edx
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 00                	mov    (%eax),%eax
 6ff:	8b 10                	mov    (%eax),%edx
 701:	8b 45 f8             	mov    -0x8(%ebp),%eax
 704:	89 10                	mov    %edx,(%eax)
 706:	eb 0a                	jmp    712 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 10                	mov    (%eax),%edx
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 727:	75 20                	jne    749 <free+0xcf>
    p->s.size += bp->s.size;
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 50 04             	mov    0x4(%eax),%edx
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	8b 40 04             	mov    0x4(%eax),%eax
 735:	01 c2                	add    %eax,%edx
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	8b 10                	mov    (%eax),%edx
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	89 10                	mov    %edx,(%eax)
 747:	eb 08                	jmp    751 <free+0xd7>
  } else
    p->s.ptr = bp;
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74f:	89 10                	mov    %edx,(%eax)
  freep = p;
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	a3 8c 0b 00 00       	mov    %eax,0xb8c
}
 759:	90                   	nop
 75a:	c9                   	leave  
 75b:	c3                   	ret    

0000075c <morecore>:

static Header*
morecore(uint nu)
{
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 762:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 769:	77 07                	ja     772 <morecore+0x16>
    nu = 4096;
 76b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 772:	8b 45 08             	mov    0x8(%ebp),%eax
 775:	c1 e0 03             	shl    $0x3,%eax
 778:	83 ec 0c             	sub    $0xc,%esp
 77b:	50                   	push   %eax
 77c:	e8 39 fc ff ff       	call   3ba <sbrk>
 781:	83 c4 10             	add    $0x10,%esp
 784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 787:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 78b:	75 07                	jne    794 <morecore+0x38>
    return 0;
 78d:	b8 00 00 00 00       	mov    $0x0,%eax
 792:	eb 26                	jmp    7ba <morecore+0x5e>
  hp = (Header*)p;
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	8b 55 08             	mov    0x8(%ebp),%edx
 7a0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a6:	83 c0 08             	add    $0x8,%eax
 7a9:	83 ec 0c             	sub    $0xc,%esp
 7ac:	50                   	push   %eax
 7ad:	e8 c8 fe ff ff       	call   67a <free>
 7b2:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b5:	a1 8c 0b 00 00       	mov    0xb8c,%eax
}
 7ba:	c9                   	leave  
 7bb:	c3                   	ret    

000007bc <malloc>:

void*
malloc(uint nbytes)
{
 7bc:	55                   	push   %ebp
 7bd:	89 e5                	mov    %esp,%ebp
 7bf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	83 c0 07             	add    $0x7,%eax
 7c8:	c1 e8 03             	shr    $0x3,%eax
 7cb:	83 c0 01             	add    $0x1,%eax
 7ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d1:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 7d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7dd:	75 23                	jne    802 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7df:	c7 45 f0 84 0b 00 00 	movl   $0xb84,-0x10(%ebp)
 7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e9:	a3 8c 0b 00 00       	mov    %eax,0xb8c
 7ee:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 7f3:	a3 84 0b 00 00       	mov    %eax,0xb84
    base.s.size = 0;
 7f8:	c7 05 88 0b 00 00 00 	movl   $0x0,0xb88
 7ff:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 813:	72 4d                	jb     862 <malloc+0xa6>
      if(p->s.size == nunits)
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	8b 40 04             	mov    0x4(%eax),%eax
 81b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81e:	75 0c                	jne    82c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 10                	mov    (%eax),%edx
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	89 10                	mov    %edx,(%eax)
 82a:	eb 26                	jmp    852 <malloc+0x96>
      else {
        p->s.size -= nunits;
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 40 04             	mov    0x4(%eax),%eax
 832:	2b 45 ec             	sub    -0x14(%ebp),%eax
 835:	89 c2                	mov    %eax,%edx
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	8b 40 04             	mov    0x4(%eax),%eax
 843:	c1 e0 03             	shl    $0x3,%eax
 846:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 84f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	a3 8c 0b 00 00       	mov    %eax,0xb8c
      return (void*)(p + 1);
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	83 c0 08             	add    $0x8,%eax
 860:	eb 3b                	jmp    89d <malloc+0xe1>
    }
    if(p == freep)
 862:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 867:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86a:	75 1e                	jne    88a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 86c:	83 ec 0c             	sub    $0xc,%esp
 86f:	ff 75 ec             	pushl  -0x14(%ebp)
 872:	e8 e5 fe ff ff       	call   75c <morecore>
 877:	83 c4 10             	add    $0x10,%esp
 87a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 881:	75 07                	jne    88a <malloc+0xce>
        return 0;
 883:	b8 00 00 00 00       	mov    $0x0,%eax
 888:	eb 13                	jmp    89d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 00                	mov    (%eax),%eax
 895:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 898:	e9 6d ff ff ff       	jmp    80a <malloc+0x4e>
}
 89d:	c9                   	leave  
 89e:	c3                   	ret    
