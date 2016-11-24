
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 40 0f 00 00       	add    $0xf40,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 40 0f 00 00       	add    $0xf40,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 13 0c 00 00       	push   $0xc13
  59:	e8 af 04 00 00       	call   50d <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 40 0f 00 00       	push   $0xf40
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 06 06 00 00       	call   6a6 <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 19 0c 00 00       	push   $0xc19
  be:	6a 01                	push   $0x1
  c0:	e8 98 07 00 00       	call   85d <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 c1 05 00 00       	call   68e <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 29 0c 00 00       	push   $0xc29
  e1:	6a 01                	push   $0x1
  e3:	e8 75 07 00 00       	call   85d <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 36 0c 00 00       	push   $0xc36
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 70 05 00 00       	call   68e <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 88 05 00 00       	call   6ce <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 37 0c 00 00       	push   $0xc37
 16c:	6a 01                	push   $0x1
 16e:	e8 ea 06 00 00       	call   85d <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 13 05 00 00       	call   68e <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 10 05 00 00       	call   6b6 <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b8:	e8 d1 04 00 00       	call   68e <exit>

000001bd <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b7 00             	movzwl (%eax),%eax
 1c9:	98                   	cwtl   
 1ca:	83 f8 02             	cmp    $0x2,%eax
 1cd:	74 1e                	je     1ed <print_mode+0x30>
 1cf:	83 f8 03             	cmp    $0x3,%eax
 1d2:	74 2d                	je     201 <print_mode+0x44>
 1d4:	83 f8 01             	cmp    $0x1,%eax
 1d7:	75 3c                	jne    215 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	68 4b 0c 00 00       	push   $0xc4b
 1e1:	6a 01                	push   $0x1
 1e3:	e8 75 06 00 00       	call   85d <printf>
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	eb 3a                	jmp    227 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 1ed:	83 ec 08             	sub    $0x8,%esp
 1f0:	68 4d 0c 00 00       	push   $0xc4d
 1f5:	6a 01                	push   $0x1
 1f7:	e8 61 06 00 00       	call   85d <printf>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 26                	jmp    227 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 201:	83 ec 08             	sub    $0x8,%esp
 204:	68 4f 0c 00 00       	push   $0xc4f
 209:	6a 01                	push   $0x1
 20b:	e8 4d 06 00 00       	call   85d <printf>
 210:	83 c4 10             	add    $0x10,%esp
 213:	eb 12                	jmp    227 <print_mode+0x6a>
    default: printf(1, "?");
 215:	83 ec 08             	sub    $0x8,%esp
 218:	68 51 0c 00 00       	push   $0xc51
 21d:	6a 01                	push   $0x1
 21f:	e8 39 06 00 00       	call   85d <printf>
 224:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 22e:	83 e0 01             	and    $0x1,%eax
 231:	84 c0                	test   %al,%al
 233:	74 14                	je     249 <print_mode+0x8c>
    printf(1, "r");
 235:	83 ec 08             	sub    $0x8,%esp
 238:	68 53 0c 00 00       	push   $0xc53
 23d:	6a 01                	push   $0x1
 23f:	e8 19 06 00 00       	call   85d <printf>
 244:	83 c4 10             	add    $0x10,%esp
 247:	eb 12                	jmp    25b <print_mode+0x9e>
  else
    printf(1, "-");
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	68 4d 0c 00 00       	push   $0xc4d
 251:	6a 01                	push   $0x1
 253:	e8 05 06 00 00       	call   85d <printf>
 258:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 262:	83 e0 80             	and    $0xffffff80,%eax
 265:	84 c0                	test   %al,%al
 267:	74 14                	je     27d <print_mode+0xc0>
    printf(1, "w");
 269:	83 ec 08             	sub    $0x8,%esp
 26c:	68 55 0c 00 00       	push   $0xc55
 271:	6a 01                	push   $0x1
 273:	e8 e5 05 00 00       	call   85d <printf>
 278:	83 c4 10             	add    $0x10,%esp
 27b:	eb 12                	jmp    28f <print_mode+0xd2>
  else
    printf(1, "-");
 27d:	83 ec 08             	sub    $0x8,%esp
 280:	68 4d 0c 00 00       	push   $0xc4d
 285:	6a 01                	push   $0x1
 287:	e8 d1 05 00 00       	call   85d <printf>
 28c:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 296:	c0 e8 06             	shr    $0x6,%al
 299:	83 e0 01             	and    $0x1,%eax
 29c:	0f b6 d0             	movzbl %al,%edx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 2a6:	d0 e8                	shr    %al
 2a8:	83 e0 01             	and    $0x1,%eax
 2ab:	0f b6 c0             	movzbl %al,%eax
 2ae:	21 d0                	and    %edx,%eax
 2b0:	85 c0                	test   %eax,%eax
 2b2:	74 14                	je     2c8 <print_mode+0x10b>
    printf(1, "S");
 2b4:	83 ec 08             	sub    $0x8,%esp
 2b7:	68 57 0c 00 00       	push   $0xc57
 2bc:	6a 01                	push   $0x1
 2be:	e8 9a 05 00 00       	call   85d <printf>
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	eb 34                	jmp    2fc <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2cf:	83 e0 40             	and    $0x40,%eax
 2d2:	84 c0                	test   %al,%al
 2d4:	74 14                	je     2ea <print_mode+0x12d>
    printf(1, "x");
 2d6:	83 ec 08             	sub    $0x8,%esp
 2d9:	68 59 0c 00 00       	push   $0xc59
 2de:	6a 01                	push   $0x1
 2e0:	e8 78 05 00 00       	call   85d <printf>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	eb 12                	jmp    2fc <print_mode+0x13f>
  else
    printf(1, "-");
 2ea:	83 ec 08             	sub    $0x8,%esp
 2ed:	68 4d 0c 00 00       	push   $0xc4d
 2f2:	6a 01                	push   $0x1
 2f4:	e8 64 05 00 00       	call   85d <printf>
 2f9:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 303:	83 e0 20             	and    $0x20,%eax
 306:	84 c0                	test   %al,%al
 308:	74 14                	je     31e <print_mode+0x161>
    printf(1, "r");
 30a:	83 ec 08             	sub    $0x8,%esp
 30d:	68 53 0c 00 00       	push   $0xc53
 312:	6a 01                	push   $0x1
 314:	e8 44 05 00 00       	call   85d <printf>
 319:	83 c4 10             	add    $0x10,%esp
 31c:	eb 12                	jmp    330 <print_mode+0x173>
  else
    printf(1, "-");
 31e:	83 ec 08             	sub    $0x8,%esp
 321:	68 4d 0c 00 00       	push   $0xc4d
 326:	6a 01                	push   $0x1
 328:	e8 30 05 00 00       	call   85d <printf>
 32d:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 337:	83 e0 10             	and    $0x10,%eax
 33a:	84 c0                	test   %al,%al
 33c:	74 14                	je     352 <print_mode+0x195>
    printf(1, "w");
 33e:	83 ec 08             	sub    $0x8,%esp
 341:	68 55 0c 00 00       	push   $0xc55
 346:	6a 01                	push   $0x1
 348:	e8 10 05 00 00       	call   85d <printf>
 34d:	83 c4 10             	add    $0x10,%esp
 350:	eb 12                	jmp    364 <print_mode+0x1a7>
  else
    printf(1, "-");
 352:	83 ec 08             	sub    $0x8,%esp
 355:	68 4d 0c 00 00       	push   $0xc4d
 35a:	6a 01                	push   $0x1
 35c:	e8 fc 04 00 00       	call   85d <printf>
 361:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 36b:	83 e0 08             	and    $0x8,%eax
 36e:	84 c0                	test   %al,%al
 370:	74 14                	je     386 <print_mode+0x1c9>
    printf(1, "x");
 372:	83 ec 08             	sub    $0x8,%esp
 375:	68 59 0c 00 00       	push   $0xc59
 37a:	6a 01                	push   $0x1
 37c:	e8 dc 04 00 00       	call   85d <printf>
 381:	83 c4 10             	add    $0x10,%esp
 384:	eb 12                	jmp    398 <print_mode+0x1db>
  else
    printf(1, "-");
 386:	83 ec 08             	sub    $0x8,%esp
 389:	68 4d 0c 00 00       	push   $0xc4d
 38e:	6a 01                	push   $0x1
 390:	e8 c8 04 00 00       	call   85d <printf>
 395:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 39f:	83 e0 04             	and    $0x4,%eax
 3a2:	84 c0                	test   %al,%al
 3a4:	74 14                	je     3ba <print_mode+0x1fd>
    printf(1, "r");
 3a6:	83 ec 08             	sub    $0x8,%esp
 3a9:	68 53 0c 00 00       	push   $0xc53
 3ae:	6a 01                	push   $0x1
 3b0:	e8 a8 04 00 00       	call   85d <printf>
 3b5:	83 c4 10             	add    $0x10,%esp
 3b8:	eb 12                	jmp    3cc <print_mode+0x20f>
  else
    printf(1, "-");
 3ba:	83 ec 08             	sub    $0x8,%esp
 3bd:	68 4d 0c 00 00       	push   $0xc4d
 3c2:	6a 01                	push   $0x1
 3c4:	e8 94 04 00 00       	call   85d <printf>
 3c9:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3d3:	83 e0 02             	and    $0x2,%eax
 3d6:	84 c0                	test   %al,%al
 3d8:	74 14                	je     3ee <print_mode+0x231>
    printf(1, "w");
 3da:	83 ec 08             	sub    $0x8,%esp
 3dd:	68 55 0c 00 00       	push   $0xc55
 3e2:	6a 01                	push   $0x1
 3e4:	e8 74 04 00 00       	call   85d <printf>
 3e9:	83 c4 10             	add    $0x10,%esp
 3ec:	eb 12                	jmp    400 <print_mode+0x243>
  else
    printf(1, "-");
 3ee:	83 ec 08             	sub    $0x8,%esp
 3f1:	68 4d 0c 00 00       	push   $0xc4d
 3f6:	6a 01                	push   $0x1
 3f8:	e8 60 04 00 00       	call   85d <printf>
 3fd:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 407:	83 e0 01             	and    $0x1,%eax
 40a:	84 c0                	test   %al,%al
 40c:	74 14                	je     422 <print_mode+0x265>
    printf(1, "x");
 40e:	83 ec 08             	sub    $0x8,%esp
 411:	68 59 0c 00 00       	push   $0xc59
 416:	6a 01                	push   $0x1
 418:	e8 40 04 00 00       	call   85d <printf>
 41d:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 420:	eb 13                	jmp    435 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 422:	83 ec 08             	sub    $0x8,%esp
 425:	68 4d 0c 00 00       	push   $0xc4d
 42a:	6a 01                	push   $0x1
 42c:	e8 2c 04 00 00       	call   85d <printf>
 431:	83 c4 10             	add    $0x10,%esp

  return;
 434:	90                   	nop
}
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	57                   	push   %edi
 43b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 43c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 43f:	8b 55 10             	mov    0x10(%ebp),%edx
 442:	8b 45 0c             	mov    0xc(%ebp),%eax
 445:	89 cb                	mov    %ecx,%ebx
 447:	89 df                	mov    %ebx,%edi
 449:	89 d1                	mov    %edx,%ecx
 44b:	fc                   	cld    
 44c:	f3 aa                	rep stos %al,%es:(%edi)
 44e:	89 ca                	mov    %ecx,%edx
 450:	89 fb                	mov    %edi,%ebx
 452:	89 5d 08             	mov    %ebx,0x8(%ebp)
 455:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 458:	90                   	nop
 459:	5b                   	pop    %ebx
 45a:	5f                   	pop    %edi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    

0000045d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 45d:	55                   	push   %ebp
 45e:	89 e5                	mov    %esp,%ebp
 460:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 469:	90                   	nop
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 08             	mov    %edx,0x8(%ebp)
 473:	8b 55 0c             	mov    0xc(%ebp),%edx
 476:	8d 4a 01             	lea    0x1(%edx),%ecx
 479:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 47c:	0f b6 12             	movzbl (%edx),%edx
 47f:	88 10                	mov    %dl,(%eax)
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	84 c0                	test   %al,%al
 486:	75 e2                	jne    46a <strcpy+0xd>
    ;
  return os;
 488:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 48b:	c9                   	leave  
 48c:	c3                   	ret    

0000048d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 490:	eb 08                	jmp    49a <strcmp+0xd>
    p++, q++;
 492:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 496:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	84 c0                	test   %al,%al
 4a2:	74 10                	je     4b4 <strcmp+0x27>
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	0f b6 10             	movzbl (%eax),%edx
 4aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ad:	0f b6 00             	movzbl (%eax),%eax
 4b0:	38 c2                	cmp    %al,%dl
 4b2:	74 de                	je     492 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	0f b6 00             	movzbl (%eax),%eax
 4ba:	0f b6 d0             	movzbl %al,%edx
 4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c0:	0f b6 00             	movzbl (%eax),%eax
 4c3:	0f b6 c0             	movzbl %al,%eax
 4c6:	29 c2                	sub    %eax,%edx
 4c8:	89 d0                	mov    %edx,%eax
}
 4ca:	5d                   	pop    %ebp
 4cb:	c3                   	ret    

000004cc <strlen>:

uint
strlen(char *s)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4d9:	eb 04                	jmp    4df <strlen+0x13>
 4db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4df:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	01 d0                	add    %edx,%eax
 4e7:	0f b6 00             	movzbl (%eax),%eax
 4ea:	84 c0                	test   %al,%al
 4ec:	75 ed                	jne    4db <strlen+0xf>
    ;
  return n;
 4ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4f1:	c9                   	leave  
 4f2:	c3                   	ret    

000004f3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4f3:	55                   	push   %ebp
 4f4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 4f6:	8b 45 10             	mov    0x10(%ebp),%eax
 4f9:	50                   	push   %eax
 4fa:	ff 75 0c             	pushl  0xc(%ebp)
 4fd:	ff 75 08             	pushl  0x8(%ebp)
 500:	e8 32 ff ff ff       	call   437 <stosb>
 505:	83 c4 0c             	add    $0xc,%esp
  return dst;
 508:	8b 45 08             	mov    0x8(%ebp),%eax
}
 50b:	c9                   	leave  
 50c:	c3                   	ret    

0000050d <strchr>:

char*
strchr(const char *s, char c)
{
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	83 ec 04             	sub    $0x4,%esp
 513:	8b 45 0c             	mov    0xc(%ebp),%eax
 516:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 519:	eb 14                	jmp    52f <strchr+0x22>
    if(*s == c)
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	0f b6 00             	movzbl (%eax),%eax
 521:	3a 45 fc             	cmp    -0x4(%ebp),%al
 524:	75 05                	jne    52b <strchr+0x1e>
      return (char*)s;
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	eb 13                	jmp    53e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 52b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	84 c0                	test   %al,%al
 537:	75 e2                	jne    51b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 539:	b8 00 00 00 00       	mov    $0x0,%eax
}
 53e:	c9                   	leave  
 53f:	c3                   	ret    

00000540 <gets>:

char*
gets(char *buf, int max)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 54d:	eb 42                	jmp    591 <gets+0x51>
    cc = read(0, &c, 1);
 54f:	83 ec 04             	sub    $0x4,%esp
 552:	6a 01                	push   $0x1
 554:	8d 45 ef             	lea    -0x11(%ebp),%eax
 557:	50                   	push   %eax
 558:	6a 00                	push   $0x0
 55a:	e8 47 01 00 00       	call   6a6 <read>
 55f:	83 c4 10             	add    $0x10,%esp
 562:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 565:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 569:	7e 33                	jle    59e <gets+0x5e>
      break;
    buf[i++] = c;
 56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56e:	8d 50 01             	lea    0x1(%eax),%edx
 571:	89 55 f4             	mov    %edx,-0xc(%ebp)
 574:	89 c2                	mov    %eax,%edx
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	01 c2                	add    %eax,%edx
 57b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 57f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 581:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 585:	3c 0a                	cmp    $0xa,%al
 587:	74 16                	je     59f <gets+0x5f>
 589:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 58d:	3c 0d                	cmp    $0xd,%al
 58f:	74 0e                	je     59f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	83 c0 01             	add    $0x1,%eax
 597:	3b 45 0c             	cmp    0xc(%ebp),%eax
 59a:	7c b3                	jl     54f <gets+0xf>
 59c:	eb 01                	jmp    59f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 59e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 59f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	01 d0                	add    %edx,%eax
 5a7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ad:	c9                   	leave  
 5ae:	c3                   	ret    

000005af <stat>:

int
stat(char *n, struct stat *st)
{
 5af:	55                   	push   %ebp
 5b0:	89 e5                	mov    %esp,%ebp
 5b2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	6a 00                	push   $0x0
 5ba:	ff 75 08             	pushl  0x8(%ebp)
 5bd:	e8 0c 01 00 00       	call   6ce <open>
 5c2:	83 c4 10             	add    $0x10,%esp
 5c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cc:	79 07                	jns    5d5 <stat+0x26>
    return -1;
 5ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5d3:	eb 25                	jmp    5fa <stat+0x4b>
  r = fstat(fd, st);
 5d5:	83 ec 08             	sub    $0x8,%esp
 5d8:	ff 75 0c             	pushl  0xc(%ebp)
 5db:	ff 75 f4             	pushl  -0xc(%ebp)
 5de:	e8 03 01 00 00       	call   6e6 <fstat>
 5e3:	83 c4 10             	add    $0x10,%esp
 5e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5e9:	83 ec 0c             	sub    $0xc,%esp
 5ec:	ff 75 f4             	pushl  -0xc(%ebp)
 5ef:	e8 c2 00 00 00       	call   6b6 <close>
 5f4:	83 c4 10             	add    $0x10,%esp
  return r;
 5f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 5fa:	c9                   	leave  
 5fb:	c3                   	ret    

000005fc <atoi>:

int
atoi(const char *s)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 609:	eb 25                	jmp    630 <atoi+0x34>
    n = n*10 + *s++ - '0';
 60b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 60e:	89 d0                	mov    %edx,%eax
 610:	c1 e0 02             	shl    $0x2,%eax
 613:	01 d0                	add    %edx,%eax
 615:	01 c0                	add    %eax,%eax
 617:	89 c1                	mov    %eax,%ecx
 619:	8b 45 08             	mov    0x8(%ebp),%eax
 61c:	8d 50 01             	lea    0x1(%eax),%edx
 61f:	89 55 08             	mov    %edx,0x8(%ebp)
 622:	0f b6 00             	movzbl (%eax),%eax
 625:	0f be c0             	movsbl %al,%eax
 628:	01 c8                	add    %ecx,%eax
 62a:	83 e8 30             	sub    $0x30,%eax
 62d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	3c 2f                	cmp    $0x2f,%al
 638:	7e 0a                	jle    644 <atoi+0x48>
 63a:	8b 45 08             	mov    0x8(%ebp),%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	3c 39                	cmp    $0x39,%al
 642:	7e c7                	jle    60b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 647:	c9                   	leave  
 648:	c3                   	ret    

00000649 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 649:	55                   	push   %ebp
 64a:	89 e5                	mov    %esp,%ebp
 64c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 64f:	8b 45 08             	mov    0x8(%ebp),%eax
 652:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 655:	8b 45 0c             	mov    0xc(%ebp),%eax
 658:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 65b:	eb 17                	jmp    674 <memmove+0x2b>
    *dst++ = *src++;
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8d 50 01             	lea    0x1(%eax),%edx
 663:	89 55 fc             	mov    %edx,-0x4(%ebp)
 666:	8b 55 f8             	mov    -0x8(%ebp),%edx
 669:	8d 4a 01             	lea    0x1(%edx),%ecx
 66c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 66f:	0f b6 12             	movzbl (%edx),%edx
 672:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 674:	8b 45 10             	mov    0x10(%ebp),%eax
 677:	8d 50 ff             	lea    -0x1(%eax),%edx
 67a:	89 55 10             	mov    %edx,0x10(%ebp)
 67d:	85 c0                	test   %eax,%eax
 67f:	7f dc                	jg     65d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 681:	8b 45 08             	mov    0x8(%ebp),%eax
}
 684:	c9                   	leave  
 685:	c3                   	ret    

00000686 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 686:	b8 01 00 00 00       	mov    $0x1,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <exit>:
SYSCALL(exit)
 68e:	b8 02 00 00 00       	mov    $0x2,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <wait>:
SYSCALL(wait)
 696:	b8 03 00 00 00       	mov    $0x3,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <pipe>:
SYSCALL(pipe)
 69e:	b8 04 00 00 00       	mov    $0x4,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <read>:
SYSCALL(read)
 6a6:	b8 05 00 00 00       	mov    $0x5,%eax
 6ab:	cd 40                	int    $0x40
 6ad:	c3                   	ret    

000006ae <write>:
SYSCALL(write)
 6ae:	b8 10 00 00 00       	mov    $0x10,%eax
 6b3:	cd 40                	int    $0x40
 6b5:	c3                   	ret    

000006b6 <close>:
SYSCALL(close)
 6b6:	b8 15 00 00 00       	mov    $0x15,%eax
 6bb:	cd 40                	int    $0x40
 6bd:	c3                   	ret    

000006be <kill>:
SYSCALL(kill)
 6be:	b8 06 00 00 00       	mov    $0x6,%eax
 6c3:	cd 40                	int    $0x40
 6c5:	c3                   	ret    

000006c6 <exec>:
SYSCALL(exec)
 6c6:	b8 07 00 00 00       	mov    $0x7,%eax
 6cb:	cd 40                	int    $0x40
 6cd:	c3                   	ret    

000006ce <open>:
SYSCALL(open)
 6ce:	b8 0f 00 00 00       	mov    $0xf,%eax
 6d3:	cd 40                	int    $0x40
 6d5:	c3                   	ret    

000006d6 <mknod>:
SYSCALL(mknod)
 6d6:	b8 11 00 00 00       	mov    $0x11,%eax
 6db:	cd 40                	int    $0x40
 6dd:	c3                   	ret    

000006de <unlink>:
SYSCALL(unlink)
 6de:	b8 12 00 00 00       	mov    $0x12,%eax
 6e3:	cd 40                	int    $0x40
 6e5:	c3                   	ret    

000006e6 <fstat>:
SYSCALL(fstat)
 6e6:	b8 08 00 00 00       	mov    $0x8,%eax
 6eb:	cd 40                	int    $0x40
 6ed:	c3                   	ret    

000006ee <link>:
SYSCALL(link)
 6ee:	b8 13 00 00 00       	mov    $0x13,%eax
 6f3:	cd 40                	int    $0x40
 6f5:	c3                   	ret    

000006f6 <mkdir>:
SYSCALL(mkdir)
 6f6:	b8 14 00 00 00       	mov    $0x14,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <chdir>:
SYSCALL(chdir)
 6fe:	b8 09 00 00 00       	mov    $0x9,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <dup>:
SYSCALL(dup)
 706:	b8 0a 00 00 00       	mov    $0xa,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <getpid>:
SYSCALL(getpid)
 70e:	b8 0b 00 00 00       	mov    $0xb,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <sbrk>:
SYSCALL(sbrk)
 716:	b8 0c 00 00 00       	mov    $0xc,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <sleep>:
SYSCALL(sleep)
 71e:	b8 0d 00 00 00       	mov    $0xd,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <uptime>:
SYSCALL(uptime)
 726:	b8 0e 00 00 00       	mov    $0xe,%eax
 72b:	cd 40                	int    $0x40
 72d:	c3                   	ret    

0000072e <halt>:
SYSCALL(halt)
 72e:	b8 16 00 00 00       	mov    $0x16,%eax
 733:	cd 40                	int    $0x40
 735:	c3                   	ret    

00000736 <date>:
//Student Implementations 
SYSCALL(date)
 736:	b8 17 00 00 00       	mov    $0x17,%eax
 73b:	cd 40                	int    $0x40
 73d:	c3                   	ret    

0000073e <getuid>:

SYSCALL(getuid)
 73e:	b8 18 00 00 00       	mov    $0x18,%eax
 743:	cd 40                	int    $0x40
 745:	c3                   	ret    

00000746 <getgid>:
SYSCALL(getgid)
 746:	b8 19 00 00 00       	mov    $0x19,%eax
 74b:	cd 40                	int    $0x40
 74d:	c3                   	ret    

0000074e <getppid>:
SYSCALL(getppid)
 74e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 753:	cd 40                	int    $0x40
 755:	c3                   	ret    

00000756 <setuid>:

SYSCALL(setuid)
 756:	b8 1b 00 00 00       	mov    $0x1b,%eax
 75b:	cd 40                	int    $0x40
 75d:	c3                   	ret    

0000075e <setgid>:
SYSCALL(setgid)
 75e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 763:	cd 40                	int    $0x40
 765:	c3                   	ret    

00000766 <getprocs>:
SYSCALL(getprocs)
 766:	b8 1d 00 00 00       	mov    $0x1d,%eax
 76b:	cd 40                	int    $0x40
 76d:	c3                   	ret    

0000076e <chown>:

SYSCALL(chown)
 76e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 773:	cd 40                	int    $0x40
 775:	c3                   	ret    

00000776 <chgrp>:
SYSCALL(chgrp)
 776:	b8 1f 00 00 00       	mov    $0x1f,%eax
 77b:	cd 40                	int    $0x40
 77d:	c3                   	ret    

0000077e <chmod>:
SYSCALL(chmod)
 77e:	b8 20 00 00 00       	mov    $0x20,%eax
 783:	cd 40                	int    $0x40
 785:	c3                   	ret    

00000786 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 786:	55                   	push   %ebp
 787:	89 e5                	mov    %esp,%ebp
 789:	83 ec 18             	sub    $0x18,%esp
 78c:	8b 45 0c             	mov    0xc(%ebp),%eax
 78f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 792:	83 ec 04             	sub    $0x4,%esp
 795:	6a 01                	push   $0x1
 797:	8d 45 f4             	lea    -0xc(%ebp),%eax
 79a:	50                   	push   %eax
 79b:	ff 75 08             	pushl  0x8(%ebp)
 79e:	e8 0b ff ff ff       	call   6ae <write>
 7a3:	83 c4 10             	add    $0x10,%esp
}
 7a6:	90                   	nop
 7a7:	c9                   	leave  
 7a8:	c3                   	ret    

000007a9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7a9:	55                   	push   %ebp
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	53                   	push   %ebx
 7ad:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7b7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7bb:	74 17                	je     7d4 <printint+0x2b>
 7bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7c1:	79 11                	jns    7d4 <printint+0x2b>
    neg = 1;
 7c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 7cd:	f7 d8                	neg    %eax
 7cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7d2:	eb 06                	jmp    7da <printint+0x31>
  } else {
    x = xx;
 7d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7e4:	8d 41 01             	lea    0x1(%ecx),%eax
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f0:	ba 00 00 00 00       	mov    $0x0,%edx
 7f5:	f7 f3                	div    %ebx
 7f7:	89 d0                	mov    %edx,%eax
 7f9:	0f b6 80 f0 0e 00 00 	movzbl 0xef0(%eax),%eax
 800:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 804:	8b 5d 10             	mov    0x10(%ebp),%ebx
 807:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80a:	ba 00 00 00 00       	mov    $0x0,%edx
 80f:	f7 f3                	div    %ebx
 811:	89 45 ec             	mov    %eax,-0x14(%ebp)
 814:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 818:	75 c7                	jne    7e1 <printint+0x38>
  if(neg)
 81a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81e:	74 2d                	je     84d <printint+0xa4>
    buf[i++] = '-';
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8d 50 01             	lea    0x1(%eax),%edx
 826:	89 55 f4             	mov    %edx,-0xc(%ebp)
 829:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 82e:	eb 1d                	jmp    84d <printint+0xa4>
    putc(fd, buf[i]);
 830:	8d 55 dc             	lea    -0x24(%ebp),%edx
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	01 d0                	add    %edx,%eax
 838:	0f b6 00             	movzbl (%eax),%eax
 83b:	0f be c0             	movsbl %al,%eax
 83e:	83 ec 08             	sub    $0x8,%esp
 841:	50                   	push   %eax
 842:	ff 75 08             	pushl  0x8(%ebp)
 845:	e8 3c ff ff ff       	call   786 <putc>
 84a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 84d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 855:	79 d9                	jns    830 <printint+0x87>
    putc(fd, buf[i]);
}
 857:	90                   	nop
 858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 85b:	c9                   	leave  
 85c:	c3                   	ret    

0000085d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 85d:	55                   	push   %ebp
 85e:	89 e5                	mov    %esp,%ebp
 860:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 863:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 86a:	8d 45 0c             	lea    0xc(%ebp),%eax
 86d:	83 c0 04             	add    $0x4,%eax
 870:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 873:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 87a:	e9 59 01 00 00       	jmp    9d8 <printf+0x17b>
    c = fmt[i] & 0xff;
 87f:	8b 55 0c             	mov    0xc(%ebp),%edx
 882:	8b 45 f0             	mov    -0x10(%ebp),%eax
 885:	01 d0                	add    %edx,%eax
 887:	0f b6 00             	movzbl (%eax),%eax
 88a:	0f be c0             	movsbl %al,%eax
 88d:	25 ff 00 00 00       	and    $0xff,%eax
 892:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 895:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 899:	75 2c                	jne    8c7 <printf+0x6a>
      if(c == '%'){
 89b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 89f:	75 0c                	jne    8ad <printf+0x50>
        state = '%';
 8a1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8a8:	e9 27 01 00 00       	jmp    9d4 <printf+0x177>
      } else {
        putc(fd, c);
 8ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b0:	0f be c0             	movsbl %al,%eax
 8b3:	83 ec 08             	sub    $0x8,%esp
 8b6:	50                   	push   %eax
 8b7:	ff 75 08             	pushl  0x8(%ebp)
 8ba:	e8 c7 fe ff ff       	call   786 <putc>
 8bf:	83 c4 10             	add    $0x10,%esp
 8c2:	e9 0d 01 00 00       	jmp    9d4 <printf+0x177>
      }
    } else if(state == '%'){
 8c7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8cb:	0f 85 03 01 00 00    	jne    9d4 <printf+0x177>
      if(c == 'd'){
 8d1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8d5:	75 1e                	jne    8f5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 8d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8da:	8b 00                	mov    (%eax),%eax
 8dc:	6a 01                	push   $0x1
 8de:	6a 0a                	push   $0xa
 8e0:	50                   	push   %eax
 8e1:	ff 75 08             	pushl  0x8(%ebp)
 8e4:	e8 c0 fe ff ff       	call   7a9 <printint>
 8e9:	83 c4 10             	add    $0x10,%esp
        ap++;
 8ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f0:	e9 d8 00 00 00       	jmp    9cd <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 8f5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8f9:	74 06                	je     901 <printf+0xa4>
 8fb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8ff:	75 1e                	jne    91f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 901:	8b 45 e8             	mov    -0x18(%ebp),%eax
 904:	8b 00                	mov    (%eax),%eax
 906:	6a 00                	push   $0x0
 908:	6a 10                	push   $0x10
 90a:	50                   	push   %eax
 90b:	ff 75 08             	pushl  0x8(%ebp)
 90e:	e8 96 fe ff ff       	call   7a9 <printint>
 913:	83 c4 10             	add    $0x10,%esp
        ap++;
 916:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 91a:	e9 ae 00 00 00       	jmp    9cd <printf+0x170>
      } else if(c == 's'){
 91f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 923:	75 43                	jne    968 <printf+0x10b>
        s = (char*)*ap;
 925:	8b 45 e8             	mov    -0x18(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 92d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 935:	75 25                	jne    95c <printf+0xff>
          s = "(null)";
 937:	c7 45 f4 5b 0c 00 00 	movl   $0xc5b,-0xc(%ebp)
        while(*s != 0){
 93e:	eb 1c                	jmp    95c <printf+0xff>
          putc(fd, *s);
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	0f b6 00             	movzbl (%eax),%eax
 946:	0f be c0             	movsbl %al,%eax
 949:	83 ec 08             	sub    $0x8,%esp
 94c:	50                   	push   %eax
 94d:	ff 75 08             	pushl  0x8(%ebp)
 950:	e8 31 fe ff ff       	call   786 <putc>
 955:	83 c4 10             	add    $0x10,%esp
          s++;
 958:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	0f b6 00             	movzbl (%eax),%eax
 962:	84 c0                	test   %al,%al
 964:	75 da                	jne    940 <printf+0xe3>
 966:	eb 65                	jmp    9cd <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 968:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 96c:	75 1d                	jne    98b <printf+0x12e>
        putc(fd, *ap);
 96e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 971:	8b 00                	mov    (%eax),%eax
 973:	0f be c0             	movsbl %al,%eax
 976:	83 ec 08             	sub    $0x8,%esp
 979:	50                   	push   %eax
 97a:	ff 75 08             	pushl  0x8(%ebp)
 97d:	e8 04 fe ff ff       	call   786 <putc>
 982:	83 c4 10             	add    $0x10,%esp
        ap++;
 985:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 989:	eb 42                	jmp    9cd <printf+0x170>
      } else if(c == '%'){
 98b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 98f:	75 17                	jne    9a8 <printf+0x14b>
        putc(fd, c);
 991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 994:	0f be c0             	movsbl %al,%eax
 997:	83 ec 08             	sub    $0x8,%esp
 99a:	50                   	push   %eax
 99b:	ff 75 08             	pushl  0x8(%ebp)
 99e:	e8 e3 fd ff ff       	call   786 <putc>
 9a3:	83 c4 10             	add    $0x10,%esp
 9a6:	eb 25                	jmp    9cd <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9a8:	83 ec 08             	sub    $0x8,%esp
 9ab:	6a 25                	push   $0x25
 9ad:	ff 75 08             	pushl  0x8(%ebp)
 9b0:	e8 d1 fd ff ff       	call   786 <putc>
 9b5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 9b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9bb:	0f be c0             	movsbl %al,%eax
 9be:	83 ec 08             	sub    $0x8,%esp
 9c1:	50                   	push   %eax
 9c2:	ff 75 08             	pushl  0x8(%ebp)
 9c5:	e8 bc fd ff ff       	call   786 <putc>
 9ca:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9d8:	8b 55 0c             	mov    0xc(%ebp),%edx
 9db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9de:	01 d0                	add    %edx,%eax
 9e0:	0f b6 00             	movzbl (%eax),%eax
 9e3:	84 c0                	test   %al,%al
 9e5:	0f 85 94 fe ff ff    	jne    87f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9eb:	90                   	nop
 9ec:	c9                   	leave  
 9ed:	c3                   	ret    

000009ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ee:	55                   	push   %ebp
 9ef:	89 e5                	mov    %esp,%ebp
 9f1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f4:	8b 45 08             	mov    0x8(%ebp),%eax
 9f7:	83 e8 08             	sub    $0x8,%eax
 9fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fd:	a1 28 0f 00 00       	mov    0xf28,%eax
 a02:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a05:	eb 24                	jmp    a2b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0a:	8b 00                	mov    (%eax),%eax
 a0c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a0f:	77 12                	ja     a23 <free+0x35>
 a11:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a14:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a17:	77 24                	ja     a3d <free+0x4f>
 a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1c:	8b 00                	mov    (%eax),%eax
 a1e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a21:	77 1a                	ja     a3d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a26:	8b 00                	mov    (%eax),%eax
 a28:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a31:	76 d4                	jbe    a07 <free+0x19>
 a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a36:	8b 00                	mov    (%eax),%eax
 a38:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a3b:	76 ca                	jbe    a07 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a40:	8b 40 04             	mov    0x4(%eax),%eax
 a43:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4d:	01 c2                	add    %eax,%edx
 a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a52:	8b 00                	mov    (%eax),%eax
 a54:	39 c2                	cmp    %eax,%edx
 a56:	75 24                	jne    a7c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a58:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5b:	8b 50 04             	mov    0x4(%eax),%edx
 a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a61:	8b 00                	mov    (%eax),%eax
 a63:	8b 40 04             	mov    0x4(%eax),%eax
 a66:	01 c2                	add    %eax,%edx
 a68:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a71:	8b 00                	mov    (%eax),%eax
 a73:	8b 10                	mov    (%eax),%edx
 a75:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a78:	89 10                	mov    %edx,(%eax)
 a7a:	eb 0a                	jmp    a86 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7f:	8b 10                	mov    (%eax),%edx
 a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a84:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a86:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a89:	8b 40 04             	mov    0x4(%eax),%eax
 a8c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a96:	01 d0                	add    %edx,%eax
 a98:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a9b:	75 20                	jne    abd <free+0xcf>
    p->s.size += bp->s.size;
 a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa0:	8b 50 04             	mov    0x4(%eax),%edx
 aa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa6:	8b 40 04             	mov    0x4(%eax),%eax
 aa9:	01 c2                	add    %eax,%edx
 aab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ab1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab4:	8b 10                	mov    (%eax),%edx
 ab6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab9:	89 10                	mov    %edx,(%eax)
 abb:	eb 08                	jmp    ac5 <free+0xd7>
  } else
    p->s.ptr = bp;
 abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ac3:	89 10                	mov    %edx,(%eax)
  freep = p;
 ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac8:	a3 28 0f 00 00       	mov    %eax,0xf28
}
 acd:	90                   	nop
 ace:	c9                   	leave  
 acf:	c3                   	ret    

00000ad0 <morecore>:

static Header*
morecore(uint nu)
{
 ad0:	55                   	push   %ebp
 ad1:	89 e5                	mov    %esp,%ebp
 ad3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ad6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 add:	77 07                	ja     ae6 <morecore+0x16>
    nu = 4096;
 adf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ae6:	8b 45 08             	mov    0x8(%ebp),%eax
 ae9:	c1 e0 03             	shl    $0x3,%eax
 aec:	83 ec 0c             	sub    $0xc,%esp
 aef:	50                   	push   %eax
 af0:	e8 21 fc ff ff       	call   716 <sbrk>
 af5:	83 c4 10             	add    $0x10,%esp
 af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 afb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aff:	75 07                	jne    b08 <morecore+0x38>
    return 0;
 b01:	b8 00 00 00 00       	mov    $0x0,%eax
 b06:	eb 26                	jmp    b2e <morecore+0x5e>
  hp = (Header*)p;
 b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b11:	8b 55 08             	mov    0x8(%ebp),%edx
 b14:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b1a:	83 c0 08             	add    $0x8,%eax
 b1d:	83 ec 0c             	sub    $0xc,%esp
 b20:	50                   	push   %eax
 b21:	e8 c8 fe ff ff       	call   9ee <free>
 b26:	83 c4 10             	add    $0x10,%esp
  return freep;
 b29:	a1 28 0f 00 00       	mov    0xf28,%eax
}
 b2e:	c9                   	leave  
 b2f:	c3                   	ret    

00000b30 <malloc>:

void*
malloc(uint nbytes)
{
 b30:	55                   	push   %ebp
 b31:	89 e5                	mov    %esp,%ebp
 b33:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b36:	8b 45 08             	mov    0x8(%ebp),%eax
 b39:	83 c0 07             	add    $0x7,%eax
 b3c:	c1 e8 03             	shr    $0x3,%eax
 b3f:	83 c0 01             	add    $0x1,%eax
 b42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b45:	a1 28 0f 00 00       	mov    0xf28,%eax
 b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b51:	75 23                	jne    b76 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b53:	c7 45 f0 20 0f 00 00 	movl   $0xf20,-0x10(%ebp)
 b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b5d:	a3 28 0f 00 00       	mov    %eax,0xf28
 b62:	a1 28 0f 00 00       	mov    0xf28,%eax
 b67:	a3 20 0f 00 00       	mov    %eax,0xf20
    base.s.size = 0;
 b6c:	c7 05 24 0f 00 00 00 	movl   $0x0,0xf24
 b73:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b79:	8b 00                	mov    (%eax),%eax
 b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b81:	8b 40 04             	mov    0x4(%eax),%eax
 b84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b87:	72 4d                	jb     bd6 <malloc+0xa6>
      if(p->s.size == nunits)
 b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8c:	8b 40 04             	mov    0x4(%eax),%eax
 b8f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b92:	75 0c                	jne    ba0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b97:	8b 10                	mov    (%eax),%edx
 b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9c:	89 10                	mov    %edx,(%eax)
 b9e:	eb 26                	jmp    bc6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba3:	8b 40 04             	mov    0x4(%eax),%eax
 ba6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ba9:	89 c2                	mov    %eax,%edx
 bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bae:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb4:	8b 40 04             	mov    0x4(%eax),%eax
 bb7:	c1 e0 03             	shl    $0x3,%eax
 bba:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bc3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc9:	a3 28 0f 00 00       	mov    %eax,0xf28
      return (void*)(p + 1);
 bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd1:	83 c0 08             	add    $0x8,%eax
 bd4:	eb 3b                	jmp    c11 <malloc+0xe1>
    }
    if(p == freep)
 bd6:	a1 28 0f 00 00       	mov    0xf28,%eax
 bdb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bde:	75 1e                	jne    bfe <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 be0:	83 ec 0c             	sub    $0xc,%esp
 be3:	ff 75 ec             	pushl  -0x14(%ebp)
 be6:	e8 e5 fe ff ff       	call   ad0 <morecore>
 beb:	83 c4 10             	add    $0x10,%esp
 bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bf5:	75 07                	jne    bfe <malloc+0xce>
        return 0;
 bf7:	b8 00 00 00 00       	mov    $0x0,%eax
 bfc:	eb 13                	jmp    c11 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c07:	8b 00                	mov    (%eax),%eax
 c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c0c:	e9 6d ff ff ff       	jmp    b7e <malloc+0x4e>
}
 c11:	c9                   	leave  
 c12:	c3                   	ret    
