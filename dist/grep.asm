
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 00 11 00 00       	add    $0x1100,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 00 11 00 00 	movl   $0x1100,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 bd 07 00 00       	call   827 <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 03 06 00 00       	call   686 <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8f:	81 7d f0 00 11 00 00 	cmpl   $0x1100,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba 00 11 00 00       	mov    $0x1100,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	pushl  -0xc(%ebp)
  b8:	ff 75 f0             	pushl  -0x10(%ebp)
  bb:	68 00 11 00 00       	push   $0x1100
  c0:	e8 fd 06 00 00       	call   7c2 <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 00 11 00 00       	add    $0x1100,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	e8 34 07 00 00       	call   81f <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	pushl  -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 8c 0d 00 00       	push   $0xd8c
 11f:	6a 02                	push   $0x2
 121:	e8 b0 08 00 00       	call   9d6 <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 d9 06 00 00       	call   807 <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 b6 06 00 00       	call   807 <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 d1 06 00 00       	call   847 <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 ac 0d 00 00       	push   $0xdac
 19c:	6a 01                	push   $0x1
 19e:	e8 33 08 00 00       	call   9d6 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 5c 06 00 00       	call   807 <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	pushl  -0x14(%ebp)
 1b1:	ff 75 f0             	pushl  -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	pushl  -0x14(%ebp)
 1c2:	e8 68 06 00 00       	call   82f <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1d5:	e8 2d 06 00 00       	call   807 <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	pushl  0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 08             	pushl  0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	pushl  0x10(%ebp)
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	3b 45 08             	cmp    0x8(%ebp),%eax
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	0f b7 00             	movzwl (%eax),%eax
 342:	98                   	cwtl   
 343:	83 f8 02             	cmp    $0x2,%eax
 346:	74 1e                	je     366 <print_mode+0x30>
 348:	83 f8 03             	cmp    $0x3,%eax
 34b:	74 2d                	je     37a <print_mode+0x44>
 34d:	83 f8 01             	cmp    $0x1,%eax
 350:	75 3c                	jne    38e <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 352:	83 ec 08             	sub    $0x8,%esp
 355:	68 c2 0d 00 00       	push   $0xdc2
 35a:	6a 01                	push   $0x1
 35c:	e8 75 06 00 00       	call   9d6 <printf>
 361:	83 c4 10             	add    $0x10,%esp
 364:	eb 3a                	jmp    3a0 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 366:	83 ec 08             	sub    $0x8,%esp
 369:	68 c4 0d 00 00       	push   $0xdc4
 36e:	6a 01                	push   $0x1
 370:	e8 61 06 00 00       	call   9d6 <printf>
 375:	83 c4 10             	add    $0x10,%esp
 378:	eb 26                	jmp    3a0 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 37a:	83 ec 08             	sub    $0x8,%esp
 37d:	68 c6 0d 00 00       	push   $0xdc6
 382:	6a 01                	push   $0x1
 384:	e8 4d 06 00 00       	call   9d6 <printf>
 389:	83 c4 10             	add    $0x10,%esp
 38c:	eb 12                	jmp    3a0 <print_mode+0x6a>
    default: printf(1, "?");
 38e:	83 ec 08             	sub    $0x8,%esp
 391:	68 c8 0d 00 00       	push   $0xdc8
 396:	6a 01                	push   $0x1
 398:	e8 39 06 00 00       	call   9d6 <printf>
 39d:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 3a7:	83 e0 01             	and    $0x1,%eax
 3aa:	84 c0                	test   %al,%al
 3ac:	74 14                	je     3c2 <print_mode+0x8c>
    printf(1, "r");
 3ae:	83 ec 08             	sub    $0x8,%esp
 3b1:	68 ca 0d 00 00       	push   $0xdca
 3b6:	6a 01                	push   $0x1
 3b8:	e8 19 06 00 00       	call   9d6 <printf>
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	eb 12                	jmp    3d4 <print_mode+0x9e>
  else
    printf(1, "-");
 3c2:	83 ec 08             	sub    $0x8,%esp
 3c5:	68 c4 0d 00 00       	push   $0xdc4
 3ca:	6a 01                	push   $0x1
 3cc:	e8 05 06 00 00       	call   9d6 <printf>
 3d1:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3db:	83 e0 80             	and    $0xffffff80,%eax
 3de:	84 c0                	test   %al,%al
 3e0:	74 14                	je     3f6 <print_mode+0xc0>
    printf(1, "w");
 3e2:	83 ec 08             	sub    $0x8,%esp
 3e5:	68 cc 0d 00 00       	push   $0xdcc
 3ea:	6a 01                	push   $0x1
 3ec:	e8 e5 05 00 00       	call   9d6 <printf>
 3f1:	83 c4 10             	add    $0x10,%esp
 3f4:	eb 12                	jmp    408 <print_mode+0xd2>
  else
    printf(1, "-");
 3f6:	83 ec 08             	sub    $0x8,%esp
 3f9:	68 c4 0d 00 00       	push   $0xdc4
 3fe:	6a 01                	push   $0x1
 400:	e8 d1 05 00 00       	call   9d6 <printf>
 405:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 40f:	c0 e8 06             	shr    $0x6,%al
 412:	83 e0 01             	and    $0x1,%eax
 415:	0f b6 d0             	movzbl %al,%edx
 418:	8b 45 08             	mov    0x8(%ebp),%eax
 41b:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 41f:	d0 e8                	shr    %al
 421:	83 e0 01             	and    $0x1,%eax
 424:	0f b6 c0             	movzbl %al,%eax
 427:	21 d0                	and    %edx,%eax
 429:	85 c0                	test   %eax,%eax
 42b:	74 14                	je     441 <print_mode+0x10b>
    printf(1, "S");
 42d:	83 ec 08             	sub    $0x8,%esp
 430:	68 ce 0d 00 00       	push   $0xdce
 435:	6a 01                	push   $0x1
 437:	e8 9a 05 00 00       	call   9d6 <printf>
 43c:	83 c4 10             	add    $0x10,%esp
 43f:	eb 34                	jmp    475 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 448:	83 e0 40             	and    $0x40,%eax
 44b:	84 c0                	test   %al,%al
 44d:	74 14                	je     463 <print_mode+0x12d>
    printf(1, "x");
 44f:	83 ec 08             	sub    $0x8,%esp
 452:	68 d0 0d 00 00       	push   $0xdd0
 457:	6a 01                	push   $0x1
 459:	e8 78 05 00 00       	call   9d6 <printf>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	eb 12                	jmp    475 <print_mode+0x13f>
  else
    printf(1, "-");
 463:	83 ec 08             	sub    $0x8,%esp
 466:	68 c4 0d 00 00       	push   $0xdc4
 46b:	6a 01                	push   $0x1
 46d:	e8 64 05 00 00       	call   9d6 <printf>
 472:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 47c:	83 e0 20             	and    $0x20,%eax
 47f:	84 c0                	test   %al,%al
 481:	74 14                	je     497 <print_mode+0x161>
    printf(1, "r");
 483:	83 ec 08             	sub    $0x8,%esp
 486:	68 ca 0d 00 00       	push   $0xdca
 48b:	6a 01                	push   $0x1
 48d:	e8 44 05 00 00       	call   9d6 <printf>
 492:	83 c4 10             	add    $0x10,%esp
 495:	eb 12                	jmp    4a9 <print_mode+0x173>
  else
    printf(1, "-");
 497:	83 ec 08             	sub    $0x8,%esp
 49a:	68 c4 0d 00 00       	push   $0xdc4
 49f:	6a 01                	push   $0x1
 4a1:	e8 30 05 00 00       	call   9d6 <printf>
 4a6:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 4b0:	83 e0 10             	and    $0x10,%eax
 4b3:	84 c0                	test   %al,%al
 4b5:	74 14                	je     4cb <print_mode+0x195>
    printf(1, "w");
 4b7:	83 ec 08             	sub    $0x8,%esp
 4ba:	68 cc 0d 00 00       	push   $0xdcc
 4bf:	6a 01                	push   $0x1
 4c1:	e8 10 05 00 00       	call   9d6 <printf>
 4c6:	83 c4 10             	add    $0x10,%esp
 4c9:	eb 12                	jmp    4dd <print_mode+0x1a7>
  else
    printf(1, "-");
 4cb:	83 ec 08             	sub    $0x8,%esp
 4ce:	68 c4 0d 00 00       	push   $0xdc4
 4d3:	6a 01                	push   $0x1
 4d5:	e8 fc 04 00 00       	call   9d6 <printf>
 4da:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 4dd:	8b 45 08             	mov    0x8(%ebp),%eax
 4e0:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 4e4:	83 e0 08             	and    $0x8,%eax
 4e7:	84 c0                	test   %al,%al
 4e9:	74 14                	je     4ff <print_mode+0x1c9>
    printf(1, "x");
 4eb:	83 ec 08             	sub    $0x8,%esp
 4ee:	68 d0 0d 00 00       	push   $0xdd0
 4f3:	6a 01                	push   $0x1
 4f5:	e8 dc 04 00 00       	call   9d6 <printf>
 4fa:	83 c4 10             	add    $0x10,%esp
 4fd:	eb 12                	jmp    511 <print_mode+0x1db>
  else
    printf(1, "-");
 4ff:	83 ec 08             	sub    $0x8,%esp
 502:	68 c4 0d 00 00       	push   $0xdc4
 507:	6a 01                	push   $0x1
 509:	e8 c8 04 00 00       	call   9d6 <printf>
 50e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 518:	83 e0 04             	and    $0x4,%eax
 51b:	84 c0                	test   %al,%al
 51d:	74 14                	je     533 <print_mode+0x1fd>
    printf(1, "r");
 51f:	83 ec 08             	sub    $0x8,%esp
 522:	68 ca 0d 00 00       	push   $0xdca
 527:	6a 01                	push   $0x1
 529:	e8 a8 04 00 00       	call   9d6 <printf>
 52e:	83 c4 10             	add    $0x10,%esp
 531:	eb 12                	jmp    545 <print_mode+0x20f>
  else
    printf(1, "-");
 533:	83 ec 08             	sub    $0x8,%esp
 536:	68 c4 0d 00 00       	push   $0xdc4
 53b:	6a 01                	push   $0x1
 53d:	e8 94 04 00 00       	call   9d6 <printf>
 542:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 54c:	83 e0 02             	and    $0x2,%eax
 54f:	84 c0                	test   %al,%al
 551:	74 14                	je     567 <print_mode+0x231>
    printf(1, "w");
 553:	83 ec 08             	sub    $0x8,%esp
 556:	68 cc 0d 00 00       	push   $0xdcc
 55b:	6a 01                	push   $0x1
 55d:	e8 74 04 00 00       	call   9d6 <printf>
 562:	83 c4 10             	add    $0x10,%esp
 565:	eb 12                	jmp    579 <print_mode+0x243>
  else
    printf(1, "-");
 567:	83 ec 08             	sub    $0x8,%esp
 56a:	68 c4 0d 00 00       	push   $0xdc4
 56f:	6a 01                	push   $0x1
 571:	e8 60 04 00 00       	call   9d6 <printf>
 576:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 580:	83 e0 01             	and    $0x1,%eax
 583:	84 c0                	test   %al,%al
 585:	74 14                	je     59b <print_mode+0x265>
    printf(1, "x");
 587:	83 ec 08             	sub    $0x8,%esp
 58a:	68 d0 0d 00 00       	push   $0xdd0
 58f:	6a 01                	push   $0x1
 591:	e8 40 04 00 00       	call   9d6 <printf>
 596:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 599:	eb 13                	jmp    5ae <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	68 c4 0d 00 00       	push   $0xdc4
 5a3:	6a 01                	push   $0x1
 5a5:	e8 2c 04 00 00       	call   9d6 <printf>
 5aa:	83 c4 10             	add    $0x10,%esp

  return;
 5ad:	90                   	nop
}
 5ae:	c9                   	leave  
 5af:	c3                   	ret    

000005b0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 5b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5b8:	8b 55 10             	mov    0x10(%ebp),%edx
 5bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5be:	89 cb                	mov    %ecx,%ebx
 5c0:	89 df                	mov    %ebx,%edi
 5c2:	89 d1                	mov    %edx,%ecx
 5c4:	fc                   	cld    
 5c5:	f3 aa                	rep stos %al,%es:(%edi)
 5c7:	89 ca                	mov    %ecx,%edx
 5c9:	89 fb                	mov    %edi,%ebx
 5cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
 5ce:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 5d1:	90                   	nop
 5d2:	5b                   	pop    %ebx
 5d3:	5f                   	pop    %edi
 5d4:	5d                   	pop    %ebp
 5d5:	c3                   	ret    

000005d6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 5d6:	55                   	push   %ebp
 5d7:	89 e5                	mov    %esp,%ebp
 5d9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 5dc:	8b 45 08             	mov    0x8(%ebp),%eax
 5df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 5e2:	90                   	nop
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	8d 50 01             	lea    0x1(%eax),%edx
 5e9:	89 55 08             	mov    %edx,0x8(%ebp)
 5ec:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ef:	8d 4a 01             	lea    0x1(%edx),%ecx
 5f2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 5f5:	0f b6 12             	movzbl (%edx),%edx
 5f8:	88 10                	mov    %dl,(%eax)
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	84 c0                	test   %al,%al
 5ff:	75 e2                	jne    5e3 <strcpy+0xd>
    ;
  return os;
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 604:	c9                   	leave  
 605:	c3                   	ret    

00000606 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 606:	55                   	push   %ebp
 607:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 609:	eb 08                	jmp    613 <strcmp+0xd>
    p++, q++;
 60b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 60f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	0f b6 00             	movzbl (%eax),%eax
 619:	84 c0                	test   %al,%al
 61b:	74 10                	je     62d <strcmp+0x27>
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	0f b6 10             	movzbl (%eax),%edx
 623:	8b 45 0c             	mov    0xc(%ebp),%eax
 626:	0f b6 00             	movzbl (%eax),%eax
 629:	38 c2                	cmp    %al,%dl
 62b:	74 de                	je     60b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	0f b6 00             	movzbl (%eax),%eax
 633:	0f b6 d0             	movzbl %al,%edx
 636:	8b 45 0c             	mov    0xc(%ebp),%eax
 639:	0f b6 00             	movzbl (%eax),%eax
 63c:	0f b6 c0             	movzbl %al,%eax
 63f:	29 c2                	sub    %eax,%edx
 641:	89 d0                	mov    %edx,%eax
}
 643:	5d                   	pop    %ebp
 644:	c3                   	ret    

00000645 <strlen>:

uint
strlen(char *s)
{
 645:	55                   	push   %ebp
 646:	89 e5                	mov    %esp,%ebp
 648:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 64b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 652:	eb 04                	jmp    658 <strlen+0x13>
 654:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 658:	8b 55 fc             	mov    -0x4(%ebp),%edx
 65b:	8b 45 08             	mov    0x8(%ebp),%eax
 65e:	01 d0                	add    %edx,%eax
 660:	0f b6 00             	movzbl (%eax),%eax
 663:	84 c0                	test   %al,%al
 665:	75 ed                	jne    654 <strlen+0xf>
    ;
  return n;
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 66a:	c9                   	leave  
 66b:	c3                   	ret    

0000066c <memset>:

void*
memset(void *dst, int c, uint n)
{
 66c:	55                   	push   %ebp
 66d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 66f:	8b 45 10             	mov    0x10(%ebp),%eax
 672:	50                   	push   %eax
 673:	ff 75 0c             	pushl  0xc(%ebp)
 676:	ff 75 08             	pushl  0x8(%ebp)
 679:	e8 32 ff ff ff       	call   5b0 <stosb>
 67e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 681:	8b 45 08             	mov    0x8(%ebp),%eax
}
 684:	c9                   	leave  
 685:	c3                   	ret    

00000686 <strchr>:

char*
strchr(const char *s, char c)
{
 686:	55                   	push   %ebp
 687:	89 e5                	mov    %esp,%ebp
 689:	83 ec 04             	sub    $0x4,%esp
 68c:	8b 45 0c             	mov    0xc(%ebp),%eax
 68f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 692:	eb 14                	jmp    6a8 <strchr+0x22>
    if(*s == c)
 694:	8b 45 08             	mov    0x8(%ebp),%eax
 697:	0f b6 00             	movzbl (%eax),%eax
 69a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 69d:	75 05                	jne    6a4 <strchr+0x1e>
      return (char*)s;
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	eb 13                	jmp    6b7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 6a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 6a8:	8b 45 08             	mov    0x8(%ebp),%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	84 c0                	test   %al,%al
 6b0:	75 e2                	jne    694 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 6b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 6b7:	c9                   	leave  
 6b8:	c3                   	ret    

000006b9 <gets>:

char*
gets(char *buf, int max)
{
 6b9:	55                   	push   %ebp
 6ba:	89 e5                	mov    %esp,%ebp
 6bc:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6c6:	eb 42                	jmp    70a <gets+0x51>
    cc = read(0, &c, 1);
 6c8:	83 ec 04             	sub    $0x4,%esp
 6cb:	6a 01                	push   $0x1
 6cd:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6d0:	50                   	push   %eax
 6d1:	6a 00                	push   $0x0
 6d3:	e8 47 01 00 00       	call   81f <read>
 6d8:	83 c4 10             	add    $0x10,%esp
 6db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e2:	7e 33                	jle    717 <gets+0x5e>
      break;
    buf[i++] = c;
 6e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e7:	8d 50 01             	lea    0x1(%eax),%edx
 6ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6ed:	89 c2                	mov    %eax,%edx
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	01 c2                	add    %eax,%edx
 6f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6f8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6fe:	3c 0a                	cmp    $0xa,%al
 700:	74 16                	je     718 <gets+0x5f>
 702:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 706:	3c 0d                	cmp    $0xd,%al
 708:	74 0e                	je     718 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 70a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70d:	83 c0 01             	add    $0x1,%eax
 710:	3b 45 0c             	cmp    0xc(%ebp),%eax
 713:	7c b3                	jl     6c8 <gets+0xf>
 715:	eb 01                	jmp    718 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 717:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 718:	8b 55 f4             	mov    -0xc(%ebp),%edx
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	01 d0                	add    %edx,%eax
 720:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 723:	8b 45 08             	mov    0x8(%ebp),%eax
}
 726:	c9                   	leave  
 727:	c3                   	ret    

00000728 <stat>:

int
stat(char *n, struct stat *st)
{
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 72e:	83 ec 08             	sub    $0x8,%esp
 731:	6a 00                	push   $0x0
 733:	ff 75 08             	pushl  0x8(%ebp)
 736:	e8 0c 01 00 00       	call   847 <open>
 73b:	83 c4 10             	add    $0x10,%esp
 73e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 745:	79 07                	jns    74e <stat+0x26>
    return -1;
 747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 74c:	eb 25                	jmp    773 <stat+0x4b>
  r = fstat(fd, st);
 74e:	83 ec 08             	sub    $0x8,%esp
 751:	ff 75 0c             	pushl  0xc(%ebp)
 754:	ff 75 f4             	pushl  -0xc(%ebp)
 757:	e8 03 01 00 00       	call   85f <fstat>
 75c:	83 c4 10             	add    $0x10,%esp
 75f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 762:	83 ec 0c             	sub    $0xc,%esp
 765:	ff 75 f4             	pushl  -0xc(%ebp)
 768:	e8 c2 00 00 00       	call   82f <close>
 76d:	83 c4 10             	add    $0x10,%esp
  return r;
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 773:	c9                   	leave  
 774:	c3                   	ret    

00000775 <atoi>:

int
atoi(const char *s)
{
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 77b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 782:	eb 25                	jmp    7a9 <atoi+0x34>
    n = n*10 + *s++ - '0';
 784:	8b 55 fc             	mov    -0x4(%ebp),%edx
 787:	89 d0                	mov    %edx,%eax
 789:	c1 e0 02             	shl    $0x2,%eax
 78c:	01 d0                	add    %edx,%eax
 78e:	01 c0                	add    %eax,%eax
 790:	89 c1                	mov    %eax,%ecx
 792:	8b 45 08             	mov    0x8(%ebp),%eax
 795:	8d 50 01             	lea    0x1(%eax),%edx
 798:	89 55 08             	mov    %edx,0x8(%ebp)
 79b:	0f b6 00             	movzbl (%eax),%eax
 79e:	0f be c0             	movsbl %al,%eax
 7a1:	01 c8                	add    %ecx,%eax
 7a3:	83 e8 30             	sub    $0x30,%eax
 7a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	0f b6 00             	movzbl (%eax),%eax
 7af:	3c 2f                	cmp    $0x2f,%al
 7b1:	7e 0a                	jle    7bd <atoi+0x48>
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	0f b6 00             	movzbl (%eax),%eax
 7b9:	3c 39                	cmp    $0x39,%al
 7bb:	7e c7                	jle    784 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7c0:	c9                   	leave  
 7c1:	c3                   	ret    

000007c2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7c2:	55                   	push   %ebp
 7c3:	89 e5                	mov    %esp,%ebp
 7c5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 7c8:	8b 45 08             	mov    0x8(%ebp),%eax
 7cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7d4:	eb 17                	jmp    7ed <memmove+0x2b>
    *dst++ = *src++;
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8d 50 01             	lea    0x1(%eax),%edx
 7dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7df:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e2:	8d 4a 01             	lea    0x1(%edx),%ecx
 7e5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7e8:	0f b6 12             	movzbl (%edx),%edx
 7eb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7ed:	8b 45 10             	mov    0x10(%ebp),%eax
 7f0:	8d 50 ff             	lea    -0x1(%eax),%edx
 7f3:	89 55 10             	mov    %edx,0x10(%ebp)
 7f6:	85 c0                	test   %eax,%eax
 7f8:	7f dc                	jg     7d6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7fd:	c9                   	leave  
 7fe:	c3                   	ret    

000007ff <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7ff:	b8 01 00 00 00       	mov    $0x1,%eax
 804:	cd 40                	int    $0x40
 806:	c3                   	ret    

00000807 <exit>:
SYSCALL(exit)
 807:	b8 02 00 00 00       	mov    $0x2,%eax
 80c:	cd 40                	int    $0x40
 80e:	c3                   	ret    

0000080f <wait>:
SYSCALL(wait)
 80f:	b8 03 00 00 00       	mov    $0x3,%eax
 814:	cd 40                	int    $0x40
 816:	c3                   	ret    

00000817 <pipe>:
SYSCALL(pipe)
 817:	b8 04 00 00 00       	mov    $0x4,%eax
 81c:	cd 40                	int    $0x40
 81e:	c3                   	ret    

0000081f <read>:
SYSCALL(read)
 81f:	b8 05 00 00 00       	mov    $0x5,%eax
 824:	cd 40                	int    $0x40
 826:	c3                   	ret    

00000827 <write>:
SYSCALL(write)
 827:	b8 10 00 00 00       	mov    $0x10,%eax
 82c:	cd 40                	int    $0x40
 82e:	c3                   	ret    

0000082f <close>:
SYSCALL(close)
 82f:	b8 15 00 00 00       	mov    $0x15,%eax
 834:	cd 40                	int    $0x40
 836:	c3                   	ret    

00000837 <kill>:
SYSCALL(kill)
 837:	b8 06 00 00 00       	mov    $0x6,%eax
 83c:	cd 40                	int    $0x40
 83e:	c3                   	ret    

0000083f <exec>:
SYSCALL(exec)
 83f:	b8 07 00 00 00       	mov    $0x7,%eax
 844:	cd 40                	int    $0x40
 846:	c3                   	ret    

00000847 <open>:
SYSCALL(open)
 847:	b8 0f 00 00 00       	mov    $0xf,%eax
 84c:	cd 40                	int    $0x40
 84e:	c3                   	ret    

0000084f <mknod>:
SYSCALL(mknod)
 84f:	b8 11 00 00 00       	mov    $0x11,%eax
 854:	cd 40                	int    $0x40
 856:	c3                   	ret    

00000857 <unlink>:
SYSCALL(unlink)
 857:	b8 12 00 00 00       	mov    $0x12,%eax
 85c:	cd 40                	int    $0x40
 85e:	c3                   	ret    

0000085f <fstat>:
SYSCALL(fstat)
 85f:	b8 08 00 00 00       	mov    $0x8,%eax
 864:	cd 40                	int    $0x40
 866:	c3                   	ret    

00000867 <link>:
SYSCALL(link)
 867:	b8 13 00 00 00       	mov    $0x13,%eax
 86c:	cd 40                	int    $0x40
 86e:	c3                   	ret    

0000086f <mkdir>:
SYSCALL(mkdir)
 86f:	b8 14 00 00 00       	mov    $0x14,%eax
 874:	cd 40                	int    $0x40
 876:	c3                   	ret    

00000877 <chdir>:
SYSCALL(chdir)
 877:	b8 09 00 00 00       	mov    $0x9,%eax
 87c:	cd 40                	int    $0x40
 87e:	c3                   	ret    

0000087f <dup>:
SYSCALL(dup)
 87f:	b8 0a 00 00 00       	mov    $0xa,%eax
 884:	cd 40                	int    $0x40
 886:	c3                   	ret    

00000887 <getpid>:
SYSCALL(getpid)
 887:	b8 0b 00 00 00       	mov    $0xb,%eax
 88c:	cd 40                	int    $0x40
 88e:	c3                   	ret    

0000088f <sbrk>:
SYSCALL(sbrk)
 88f:	b8 0c 00 00 00       	mov    $0xc,%eax
 894:	cd 40                	int    $0x40
 896:	c3                   	ret    

00000897 <sleep>:
SYSCALL(sleep)
 897:	b8 0d 00 00 00       	mov    $0xd,%eax
 89c:	cd 40                	int    $0x40
 89e:	c3                   	ret    

0000089f <uptime>:
SYSCALL(uptime)
 89f:	b8 0e 00 00 00       	mov    $0xe,%eax
 8a4:	cd 40                	int    $0x40
 8a6:	c3                   	ret    

000008a7 <halt>:
SYSCALL(halt)
 8a7:	b8 16 00 00 00       	mov    $0x16,%eax
 8ac:	cd 40                	int    $0x40
 8ae:	c3                   	ret    

000008af <date>:
//Student Implementations 
SYSCALL(date)
 8af:	b8 17 00 00 00       	mov    $0x17,%eax
 8b4:	cd 40                	int    $0x40
 8b6:	c3                   	ret    

000008b7 <getuid>:

SYSCALL(getuid)
 8b7:	b8 18 00 00 00       	mov    $0x18,%eax
 8bc:	cd 40                	int    $0x40
 8be:	c3                   	ret    

000008bf <getgid>:
SYSCALL(getgid)
 8bf:	b8 19 00 00 00       	mov    $0x19,%eax
 8c4:	cd 40                	int    $0x40
 8c6:	c3                   	ret    

000008c7 <getppid>:
SYSCALL(getppid)
 8c7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 8cc:	cd 40                	int    $0x40
 8ce:	c3                   	ret    

000008cf <setuid>:

SYSCALL(setuid)
 8cf:	b8 1b 00 00 00       	mov    $0x1b,%eax
 8d4:	cd 40                	int    $0x40
 8d6:	c3                   	ret    

000008d7 <setgid>:
SYSCALL(setgid)
 8d7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 8dc:	cd 40                	int    $0x40
 8de:	c3                   	ret    

000008df <getprocs>:
SYSCALL(getprocs)
 8df:	b8 1d 00 00 00       	mov    $0x1d,%eax
 8e4:	cd 40                	int    $0x40
 8e6:	c3                   	ret    

000008e7 <chown>:

SYSCALL(chown)
 8e7:	b8 1e 00 00 00       	mov    $0x1e,%eax
 8ec:	cd 40                	int    $0x40
 8ee:	c3                   	ret    

000008ef <chgrp>:
SYSCALL(chgrp)
 8ef:	b8 1f 00 00 00       	mov    $0x1f,%eax
 8f4:	cd 40                	int    $0x40
 8f6:	c3                   	ret    

000008f7 <chmod>:
SYSCALL(chmod)
 8f7:	b8 20 00 00 00       	mov    $0x20,%eax
 8fc:	cd 40                	int    $0x40
 8fe:	c3                   	ret    

000008ff <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8ff:	55                   	push   %ebp
 900:	89 e5                	mov    %esp,%ebp
 902:	83 ec 18             	sub    $0x18,%esp
 905:	8b 45 0c             	mov    0xc(%ebp),%eax
 908:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 90b:	83 ec 04             	sub    $0x4,%esp
 90e:	6a 01                	push   $0x1
 910:	8d 45 f4             	lea    -0xc(%ebp),%eax
 913:	50                   	push   %eax
 914:	ff 75 08             	pushl  0x8(%ebp)
 917:	e8 0b ff ff ff       	call   827 <write>
 91c:	83 c4 10             	add    $0x10,%esp
}
 91f:	90                   	nop
 920:	c9                   	leave  
 921:	c3                   	ret    

00000922 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 922:	55                   	push   %ebp
 923:	89 e5                	mov    %esp,%ebp
 925:	53                   	push   %ebx
 926:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 929:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 930:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 934:	74 17                	je     94d <printint+0x2b>
 936:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 93a:	79 11                	jns    94d <printint+0x2b>
    neg = 1;
 93c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 943:	8b 45 0c             	mov    0xc(%ebp),%eax
 946:	f7 d8                	neg    %eax
 948:	89 45 ec             	mov    %eax,-0x14(%ebp)
 94b:	eb 06                	jmp    953 <printint+0x31>
  } else {
    x = xx;
 94d:	8b 45 0c             	mov    0xc(%ebp),%eax
 950:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 953:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 95a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 95d:	8d 41 01             	lea    0x1(%ecx),%eax
 960:	89 45 f4             	mov    %eax,-0xc(%ebp)
 963:	8b 5d 10             	mov    0x10(%ebp),%ebx
 966:	8b 45 ec             	mov    -0x14(%ebp),%eax
 969:	ba 00 00 00 00       	mov    $0x0,%edx
 96e:	f7 f3                	div    %ebx
 970:	89 d0                	mov    %edx,%eax
 972:	0f b6 80 c8 10 00 00 	movzbl 0x10c8(%eax),%eax
 979:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 97d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 980:	8b 45 ec             	mov    -0x14(%ebp),%eax
 983:	ba 00 00 00 00       	mov    $0x0,%edx
 988:	f7 f3                	div    %ebx
 98a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 98d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 991:	75 c7                	jne    95a <printint+0x38>
  if(neg)
 993:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 997:	74 2d                	je     9c6 <printint+0xa4>
    buf[i++] = '-';
 999:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99c:	8d 50 01             	lea    0x1(%eax),%edx
 99f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9a2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9a7:	eb 1d                	jmp    9c6 <printint+0xa4>
    putc(fd, buf[i]);
 9a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9af:	01 d0                	add    %edx,%eax
 9b1:	0f b6 00             	movzbl (%eax),%eax
 9b4:	0f be c0             	movsbl %al,%eax
 9b7:	83 ec 08             	sub    $0x8,%esp
 9ba:	50                   	push   %eax
 9bb:	ff 75 08             	pushl  0x8(%ebp)
 9be:	e8 3c ff ff ff       	call   8ff <putc>
 9c3:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 9ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ce:	79 d9                	jns    9a9 <printint+0x87>
    putc(fd, buf[i]);
}
 9d0:	90                   	nop
 9d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9d4:	c9                   	leave  
 9d5:	c3                   	ret    

000009d6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9d6:	55                   	push   %ebp
 9d7:	89 e5                	mov    %esp,%ebp
 9d9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9e3:	8d 45 0c             	lea    0xc(%ebp),%eax
 9e6:	83 c0 04             	add    $0x4,%eax
 9e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9f3:	e9 59 01 00 00       	jmp    b51 <printf+0x17b>
    c = fmt[i] & 0xff;
 9f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 9fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fe:	01 d0                	add    %edx,%eax
 a00:	0f b6 00             	movzbl (%eax),%eax
 a03:	0f be c0             	movsbl %al,%eax
 a06:	25 ff 00 00 00       	and    $0xff,%eax
 a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a12:	75 2c                	jne    a40 <printf+0x6a>
      if(c == '%'){
 a14:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a18:	75 0c                	jne    a26 <printf+0x50>
        state = '%';
 a1a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a21:	e9 27 01 00 00       	jmp    b4d <printf+0x177>
      } else {
        putc(fd, c);
 a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a29:	0f be c0             	movsbl %al,%eax
 a2c:	83 ec 08             	sub    $0x8,%esp
 a2f:	50                   	push   %eax
 a30:	ff 75 08             	pushl  0x8(%ebp)
 a33:	e8 c7 fe ff ff       	call   8ff <putc>
 a38:	83 c4 10             	add    $0x10,%esp
 a3b:	e9 0d 01 00 00       	jmp    b4d <printf+0x177>
      }
    } else if(state == '%'){
 a40:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a44:	0f 85 03 01 00 00    	jne    b4d <printf+0x177>
      if(c == 'd'){
 a4a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a4e:	75 1e                	jne    a6e <printf+0x98>
        printint(fd, *ap, 10, 1);
 a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a53:	8b 00                	mov    (%eax),%eax
 a55:	6a 01                	push   $0x1
 a57:	6a 0a                	push   $0xa
 a59:	50                   	push   %eax
 a5a:	ff 75 08             	pushl  0x8(%ebp)
 a5d:	e8 c0 fe ff ff       	call   922 <printint>
 a62:	83 c4 10             	add    $0x10,%esp
        ap++;
 a65:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a69:	e9 d8 00 00 00       	jmp    b46 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 a6e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a72:	74 06                	je     a7a <printf+0xa4>
 a74:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a78:	75 1e                	jne    a98 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a7d:	8b 00                	mov    (%eax),%eax
 a7f:	6a 00                	push   $0x0
 a81:	6a 10                	push   $0x10
 a83:	50                   	push   %eax
 a84:	ff 75 08             	pushl  0x8(%ebp)
 a87:	e8 96 fe ff ff       	call   922 <printint>
 a8c:	83 c4 10             	add    $0x10,%esp
        ap++;
 a8f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a93:	e9 ae 00 00 00       	jmp    b46 <printf+0x170>
      } else if(c == 's'){
 a98:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a9c:	75 43                	jne    ae1 <printf+0x10b>
        s = (char*)*ap;
 a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aa1:	8b 00                	mov    (%eax),%eax
 aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 aa6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aae:	75 25                	jne    ad5 <printf+0xff>
          s = "(null)";
 ab0:	c7 45 f4 d2 0d 00 00 	movl   $0xdd2,-0xc(%ebp)
        while(*s != 0){
 ab7:	eb 1c                	jmp    ad5 <printf+0xff>
          putc(fd, *s);
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	0f b6 00             	movzbl (%eax),%eax
 abf:	0f be c0             	movsbl %al,%eax
 ac2:	83 ec 08             	sub    $0x8,%esp
 ac5:	50                   	push   %eax
 ac6:	ff 75 08             	pushl  0x8(%ebp)
 ac9:	e8 31 fe ff ff       	call   8ff <putc>
 ace:	83 c4 10             	add    $0x10,%esp
          s++;
 ad1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad8:	0f b6 00             	movzbl (%eax),%eax
 adb:	84 c0                	test   %al,%al
 add:	75 da                	jne    ab9 <printf+0xe3>
 adf:	eb 65                	jmp    b46 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ae1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ae5:	75 1d                	jne    b04 <printf+0x12e>
        putc(fd, *ap);
 ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aea:	8b 00                	mov    (%eax),%eax
 aec:	0f be c0             	movsbl %al,%eax
 aef:	83 ec 08             	sub    $0x8,%esp
 af2:	50                   	push   %eax
 af3:	ff 75 08             	pushl  0x8(%ebp)
 af6:	e8 04 fe ff ff       	call   8ff <putc>
 afb:	83 c4 10             	add    $0x10,%esp
        ap++;
 afe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b02:	eb 42                	jmp    b46 <printf+0x170>
      } else if(c == '%'){
 b04:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b08:	75 17                	jne    b21 <printf+0x14b>
        putc(fd, c);
 b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b0d:	0f be c0             	movsbl %al,%eax
 b10:	83 ec 08             	sub    $0x8,%esp
 b13:	50                   	push   %eax
 b14:	ff 75 08             	pushl  0x8(%ebp)
 b17:	e8 e3 fd ff ff       	call   8ff <putc>
 b1c:	83 c4 10             	add    $0x10,%esp
 b1f:	eb 25                	jmp    b46 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b21:	83 ec 08             	sub    $0x8,%esp
 b24:	6a 25                	push   $0x25
 b26:	ff 75 08             	pushl  0x8(%ebp)
 b29:	e8 d1 fd ff ff       	call   8ff <putc>
 b2e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b34:	0f be c0             	movsbl %al,%eax
 b37:	83 ec 08             	sub    $0x8,%esp
 b3a:	50                   	push   %eax
 b3b:	ff 75 08             	pushl  0x8(%ebp)
 b3e:	e8 bc fd ff ff       	call   8ff <putc>
 b43:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 b46:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b4d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 b51:	8b 55 0c             	mov    0xc(%ebp),%edx
 b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b57:	01 d0                	add    %edx,%eax
 b59:	0f b6 00             	movzbl (%eax),%eax
 b5c:	84 c0                	test   %al,%al
 b5e:	0f 85 94 fe ff ff    	jne    9f8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b64:	90                   	nop
 b65:	c9                   	leave  
 b66:	c3                   	ret    

00000b67 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b67:	55                   	push   %ebp
 b68:	89 e5                	mov    %esp,%ebp
 b6a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b6d:	8b 45 08             	mov    0x8(%ebp),%eax
 b70:	83 e8 08             	sub    $0x8,%eax
 b73:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b76:	a1 e8 10 00 00       	mov    0x10e8,%eax
 b7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b7e:	eb 24                	jmp    ba4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b83:	8b 00                	mov    (%eax),%eax
 b85:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b88:	77 12                	ja     b9c <free+0x35>
 b8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b8d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b90:	77 24                	ja     bb6 <free+0x4f>
 b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b95:	8b 00                	mov    (%eax),%eax
 b97:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b9a:	77 1a                	ja     bb6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b9f:	8b 00                	mov    (%eax),%eax
 ba1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ba4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ba7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 baa:	76 d4                	jbe    b80 <free+0x19>
 bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 baf:	8b 00                	mov    (%eax),%eax
 bb1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bb4:	76 ca                	jbe    b80 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bb9:	8b 40 04             	mov    0x4(%eax),%eax
 bbc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bc6:	01 c2                	add    %eax,%edx
 bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bcb:	8b 00                	mov    (%eax),%eax
 bcd:	39 c2                	cmp    %eax,%edx
 bcf:	75 24                	jne    bf5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd4:	8b 50 04             	mov    0x4(%eax),%edx
 bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bda:	8b 00                	mov    (%eax),%eax
 bdc:	8b 40 04             	mov    0x4(%eax),%eax
 bdf:	01 c2                	add    %eax,%edx
 be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bea:	8b 00                	mov    (%eax),%eax
 bec:	8b 10                	mov    (%eax),%edx
 bee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf1:	89 10                	mov    %edx,(%eax)
 bf3:	eb 0a                	jmp    bff <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf8:	8b 10                	mov    (%eax),%edx
 bfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bfd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c02:	8b 40 04             	mov    0x4(%eax),%eax
 c05:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0f:	01 d0                	add    %edx,%eax
 c11:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c14:	75 20                	jne    c36 <free+0xcf>
    p->s.size += bp->s.size;
 c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c19:	8b 50 04             	mov    0x4(%eax),%edx
 c1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c1f:	8b 40 04             	mov    0x4(%eax),%eax
 c22:	01 c2                	add    %eax,%edx
 c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c27:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2d:	8b 10                	mov    (%eax),%edx
 c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c32:	89 10                	mov    %edx,(%eax)
 c34:	eb 08                	jmp    c3e <free+0xd7>
  } else
    p->s.ptr = bp;
 c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c39:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c3c:	89 10                	mov    %edx,(%eax)
  freep = p;
 c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c41:	a3 e8 10 00 00       	mov    %eax,0x10e8
}
 c46:	90                   	nop
 c47:	c9                   	leave  
 c48:	c3                   	ret    

00000c49 <morecore>:

static Header*
morecore(uint nu)
{
 c49:	55                   	push   %ebp
 c4a:	89 e5                	mov    %esp,%ebp
 c4c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c4f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c56:	77 07                	ja     c5f <morecore+0x16>
    nu = 4096;
 c58:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c5f:	8b 45 08             	mov    0x8(%ebp),%eax
 c62:	c1 e0 03             	shl    $0x3,%eax
 c65:	83 ec 0c             	sub    $0xc,%esp
 c68:	50                   	push   %eax
 c69:	e8 21 fc ff ff       	call   88f <sbrk>
 c6e:	83 c4 10             	add    $0x10,%esp
 c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c74:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c78:	75 07                	jne    c81 <morecore+0x38>
    return 0;
 c7a:	b8 00 00 00 00       	mov    $0x0,%eax
 c7f:	eb 26                	jmp    ca7 <morecore+0x5e>
  hp = (Header*)p;
 c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c8a:	8b 55 08             	mov    0x8(%ebp),%edx
 c8d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c93:	83 c0 08             	add    $0x8,%eax
 c96:	83 ec 0c             	sub    $0xc,%esp
 c99:	50                   	push   %eax
 c9a:	e8 c8 fe ff ff       	call   b67 <free>
 c9f:	83 c4 10             	add    $0x10,%esp
  return freep;
 ca2:	a1 e8 10 00 00       	mov    0x10e8,%eax
}
 ca7:	c9                   	leave  
 ca8:	c3                   	ret    

00000ca9 <malloc>:

void*
malloc(uint nbytes)
{
 ca9:	55                   	push   %ebp
 caa:	89 e5                	mov    %esp,%ebp
 cac:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 caf:	8b 45 08             	mov    0x8(%ebp),%eax
 cb2:	83 c0 07             	add    $0x7,%eax
 cb5:	c1 e8 03             	shr    $0x3,%eax
 cb8:	83 c0 01             	add    $0x1,%eax
 cbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 cbe:	a1 e8 10 00 00       	mov    0x10e8,%eax
 cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cca:	75 23                	jne    cef <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 ccc:	c7 45 f0 e0 10 00 00 	movl   $0x10e0,-0x10(%ebp)
 cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cd6:	a3 e8 10 00 00       	mov    %eax,0x10e8
 cdb:	a1 e8 10 00 00       	mov    0x10e8,%eax
 ce0:	a3 e0 10 00 00       	mov    %eax,0x10e0
    base.s.size = 0;
 ce5:	c7 05 e4 10 00 00 00 	movl   $0x0,0x10e4
 cec:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf2:	8b 00                	mov    (%eax),%eax
 cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfa:	8b 40 04             	mov    0x4(%eax),%eax
 cfd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d00:	72 4d                	jb     d4f <malloc+0xa6>
      if(p->s.size == nunits)
 d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d05:	8b 40 04             	mov    0x4(%eax),%eax
 d08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d0b:	75 0c                	jne    d19 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d10:	8b 10                	mov    (%eax),%edx
 d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d15:	89 10                	mov    %edx,(%eax)
 d17:	eb 26                	jmp    d3f <malloc+0x96>
      else {
        p->s.size -= nunits;
 d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1c:	8b 40 04             	mov    0x4(%eax),%eax
 d1f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d22:	89 c2                	mov    %eax,%edx
 d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d27:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2d:	8b 40 04             	mov    0x4(%eax),%eax
 d30:	c1 e0 03             	shl    $0x3,%eax
 d33:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d39:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d3c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d42:	a3 e8 10 00 00       	mov    %eax,0x10e8
      return (void*)(p + 1);
 d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4a:	83 c0 08             	add    $0x8,%eax
 d4d:	eb 3b                	jmp    d8a <malloc+0xe1>
    }
    if(p == freep)
 d4f:	a1 e8 10 00 00       	mov    0x10e8,%eax
 d54:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d57:	75 1e                	jne    d77 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 d59:	83 ec 0c             	sub    $0xc,%esp
 d5c:	ff 75 ec             	pushl  -0x14(%ebp)
 d5f:	e8 e5 fe ff ff       	call   c49 <morecore>
 d64:	83 c4 10             	add    $0x10,%esp
 d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d6e:	75 07                	jne    d77 <malloc+0xce>
        return 0;
 d70:	b8 00 00 00 00       	mov    $0x0,%eax
 d75:	eb 13                	jmp    d8a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d80:	8b 00                	mov    (%eax),%eax
 d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d85:	e9 6d ff ff ff       	jmp    cf7 <malloc+0x4e>
}
 d8a:	c9                   	leave  
 d8b:	c3                   	ret    
