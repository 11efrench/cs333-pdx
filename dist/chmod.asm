
_chmod:     file format elf32-i386


Disassembly of section .text:

00000000 <convert>:
#include "types.h"
#include "user.h"
#include "stat.h"
int 
convert(char set, char owner, char group, char other)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
   7:	8b 5d 08             	mov    0x8(%ebp),%ebx
   a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
   d:	8b 55 10             	mov    0x10(%ebp),%edx
  10:	8b 45 14             	mov    0x14(%ebp),%eax
  13:	88 5d e4             	mov    %bl,-0x1c(%ebp)
  16:	88 4d e0             	mov    %cl,-0x20(%ebp)
  19:	88 55 dc             	mov    %dl,-0x24(%ebp)
  1c:	88 45 d8             	mov    %al,-0x28(%ebp)
    
    int nset, nowner, ngroup, nother;

    nset = atoi(&set);
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  25:	50                   	push   %eax
  26:	e8 12 06 00 00       	call   63d <atoi>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    nowner = atoi(&owner);
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	8d 45 e0             	lea    -0x20(%ebp),%eax
  37:	50                   	push   %eax
  38:	e8 00 06 00 00       	call   63d <atoi>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ngroup = atoi(&group);
  43:	83 ec 0c             	sub    $0xc,%esp
  46:	8d 45 dc             	lea    -0x24(%ebp),%eax
  49:	50                   	push   %eax
  4a:	e8 ee 05 00 00       	call   63d <atoi>
  4f:	83 c4 10             	add    $0x10,%esp
  52:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nother = atoi(&other);
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	8d 45 d8             	lea    -0x28(%ebp),%eax
  5b:	50                   	push   %eax
  5c:	e8 dc 05 00 00       	call   63d <atoi>
  61:	83 c4 10             	add    $0x10,%esp
  64:	89 45 e8             	mov    %eax,-0x18(%ebp)
    
    if(nset    < 0 || nset    > 1 || nowner  < 0 || nowner  > 7 || ngroup  < 0 || ngroup  > 7 || nother  < 0 || nother  > 7)
  67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  6b:	78 2a                	js     97 <convert+0x97>
  6d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  71:	7f 24                	jg     97 <convert+0x97>
  73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  77:	78 1e                	js     97 <convert+0x97>
  79:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
  7d:	7f 18                	jg     97 <convert+0x97>
  7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  83:	78 12                	js     97 <convert+0x97>
  85:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  89:	7f 0c                	jg     97 <convert+0x97>
  8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8f:	78 06                	js     97 <convert+0x97>
  91:	83 7d e8 07          	cmpl   $0x7,-0x18(%ebp)
  95:	7e 07                	jle    9e <convert+0x9e>
        return -1;
  97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  9c:	eb 18                	jmp    b6 <convert+0xb6>
    nset    = nset << 9;
  9e:	c1 65 f4 09          	shll   $0x9,-0xc(%ebp)
    nowner  = nowner << 6;
  a2:	c1 65 f0 06          	shll   $0x6,-0x10(%ebp)
    ngroup  = ngroup << 3;
  a6:	c1 65 ec 03          	shll   $0x3,-0x14(%ebp)

    return nset | nowner | ngroup | nother;
  aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ad:	0b 45 f0             	or     -0x10(%ebp),%eax
  b0:	0b 45 ec             	or     -0x14(%ebp),%eax
  b3:	0b 45 e8             	or     -0x18(%ebp),%eax
}
  b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <main>:

int
main(int argc, char* argv[])
{
  bb:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  bf:	83 e4 f0             	and    $0xfffffff0,%esp
  c2:	ff 71 fc             	pushl  -0x4(%ecx)
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	56                   	push   %esi
  c9:	53                   	push   %ebx
  ca:	51                   	push   %ecx
  cb:	83 ec 3c             	sub    $0x3c,%esp
  ce:	89 cb                	mov    %ecx,%ebx
    char * path;
    struct stat st;
    int fd;
    int mode;
    int rc;
    path = argv[2];
  d0:	8b 43 04             	mov    0x4(%ebx),%eax
  d3:	8b 40 08             	mov    0x8(%eax),%eax
  d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    
    if( (mode  = convert(argv[1][0], argv[1][1], argv[1][2], argv[1][3]))  < 0){
  d9:	8b 43 04             	mov    0x4(%ebx),%eax
  dc:	83 c0 04             	add    $0x4,%eax
  df:	8b 00                	mov    (%eax),%eax
  e1:	83 c0 03             	add    $0x3,%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	0f be f0             	movsbl %al,%esi
  ea:	8b 43 04             	mov    0x4(%ebx),%eax
  ed:	83 c0 04             	add    $0x4,%eax
  f0:	8b 00                	mov    (%eax),%eax
  f2:	83 c0 02             	add    $0x2,%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	0f be c8             	movsbl %al,%ecx
  fb:	8b 43 04             	mov    0x4(%ebx),%eax
  fe:	83 c0 04             	add    $0x4,%eax
 101:	8b 00                	mov    (%eax),%eax
 103:	83 c0 01             	add    $0x1,%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	0f be d0             	movsbl %al,%edx
 10c:	8b 43 04             	mov    0x4(%ebx),%eax
 10f:	83 c0 04             	add    $0x4,%eax
 112:	8b 00                	mov    (%eax),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	0f be c0             	movsbl %al,%eax
 11a:	56                   	push   %esi
 11b:	51                   	push   %ecx
 11c:	52                   	push   %edx
 11d:	50                   	push   %eax
 11e:	e8 dd fe ff ff       	call   0 <convert>
 123:	83 c4 10             	add    $0x10,%esp
 126:	89 45 e0             	mov    %eax,-0x20(%ebp)
 129:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 12d:	79 17                	jns    146 <main+0x8b>
        printf(1, "Bad mode\n");
 12f:	83 ec 08             	sub    $0x8,%esp
 132:	68 54 0c 00 00       	push   $0xc54
 137:	6a 01                	push   $0x1
 139:	e8 60 07 00 00       	call   89e <printf>
 13e:	83 c4 10             	add    $0x10,%esp
        exit();
 141:	e8 89 05 00 00       	call   6cf <exit>
    }

    if(argc < 3) {
 146:	83 3b 02             	cmpl   $0x2,(%ebx)
 149:	7f 17                	jg     162 <main+0xa7>
      printf(1, "Usage: change gid for file \n");
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	68 5e 0c 00 00       	push   $0xc5e
 153:	6a 01                	push   $0x1
 155:	e8 44 07 00 00       	call   89e <printf>
 15a:	83 c4 10             	add    $0x10,%esp
      exit();
 15d:	e8 6d 05 00 00       	call   6cf <exit>
    }

    if((fd = open(path,  0)) < 0 )
 162:	83 ec 08             	sub    $0x8,%esp
 165:	6a 00                	push   $0x0
 167:	ff 75 e4             	pushl  -0x1c(%ebp)
 16a:	e8 a0 05 00 00       	call   70f <open>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	89 45 dc             	mov    %eax,-0x24(%ebp)
 175:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 179:	79 17                	jns    192 <main+0xd7>
    {
      printf(1, "Failed to open specified file\n");
 17b:	83 ec 08             	sub    $0x8,%esp
 17e:	68 7c 0c 00 00       	push   $0xc7c
 183:	6a 01                	push   $0x1
 185:	e8 14 07 00 00       	call   89e <printf>
 18a:	83 c4 10             	add    $0x10,%esp
      exit();
 18d:	e8 3d 05 00 00       	call   6cf <exit>
    }
    
    if(fstat(fd, &st) < 0) 
 192:	83 ec 08             	sub    $0x8,%esp
 195:	8d 45 bc             	lea    -0x44(%ebp),%eax
 198:	50                   	push   %eax
 199:	ff 75 dc             	pushl  -0x24(%ebp)
 19c:	e8 86 05 00 00       	call   727 <fstat>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	85 c0                	test   %eax,%eax
 1a6:	79 17                	jns    1bf <main+0x104>
    {
        printf(1, "Cannot pull stat from specified file\n");
 1a8:	83 ec 08             	sub    $0x8,%esp
 1ab:	68 9c 0c 00 00       	push   $0xc9c
 1b0:	6a 01                	push   $0x1
 1b2:	e8 e7 06 00 00       	call   89e <printf>
 1b7:	83 c4 10             	add    $0x10,%esp
        exit();
 1ba:	e8 10 05 00 00       	call   6cf <exit>
    }
    close(fd);
 1bf:	83 ec 0c             	sub    $0xc,%esp
 1c2:	ff 75 dc             	pushl  -0x24(%ebp)
 1c5:	e8 2d 05 00 00       	call   6f7 <close>
 1ca:	83 c4 10             	add    $0x10,%esp
    
    rc = chmod(path, mode);
 1cd:	83 ec 08             	sub    $0x8,%esp
 1d0:	ff 75 e0             	pushl  -0x20(%ebp)
 1d3:	ff 75 e4             	pushl  -0x1c(%ebp)
 1d6:	e8 e4 05 00 00       	call   7bf <chmod>
 1db:	83 c4 10             	add    $0x10,%esp
 1de:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if(rc  < 0) 
 1e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
 1e5:	79 12                	jns    1f9 <main+0x13e>
        printf(1, "Change User Failed.\n");
 1e7:	83 ec 08             	sub    $0x8,%esp
 1ea:	68 c2 0c 00 00       	push   $0xcc2
 1ef:	6a 01                	push   $0x1
 1f1:	e8 a8 06 00 00       	call   89e <printf>
 1f6:	83 c4 10             	add    $0x10,%esp

    exit();
 1f9:	e8 d1 04 00 00       	call   6cf <exit>

000001fe <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	0f b7 00             	movzwl (%eax),%eax
 20a:	98                   	cwtl   
 20b:	83 f8 02             	cmp    $0x2,%eax
 20e:	74 1e                	je     22e <print_mode+0x30>
 210:	83 f8 03             	cmp    $0x3,%eax
 213:	74 2d                	je     242 <print_mode+0x44>
 215:	83 f8 01             	cmp    $0x1,%eax
 218:	75 3c                	jne    256 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 21a:	83 ec 08             	sub    $0x8,%esp
 21d:	68 d7 0c 00 00       	push   $0xcd7
 222:	6a 01                	push   $0x1
 224:	e8 75 06 00 00       	call   89e <printf>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	eb 3a                	jmp    268 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	68 d9 0c 00 00       	push   $0xcd9
 236:	6a 01                	push   $0x1
 238:	e8 61 06 00 00       	call   89e <printf>
 23d:	83 c4 10             	add    $0x10,%esp
 240:	eb 26                	jmp    268 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 242:	83 ec 08             	sub    $0x8,%esp
 245:	68 db 0c 00 00       	push   $0xcdb
 24a:	6a 01                	push   $0x1
 24c:	e8 4d 06 00 00       	call   89e <printf>
 251:	83 c4 10             	add    $0x10,%esp
 254:	eb 12                	jmp    268 <print_mode+0x6a>
    default: printf(1, "?");
 256:	83 ec 08             	sub    $0x8,%esp
 259:	68 dd 0c 00 00       	push   $0xcdd
 25e:	6a 01                	push   $0x1
 260:	e8 39 06 00 00       	call   89e <printf>
 265:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 26f:	83 e0 01             	and    $0x1,%eax
 272:	84 c0                	test   %al,%al
 274:	74 14                	je     28a <print_mode+0x8c>
    printf(1, "r");
 276:	83 ec 08             	sub    $0x8,%esp
 279:	68 df 0c 00 00       	push   $0xcdf
 27e:	6a 01                	push   $0x1
 280:	e8 19 06 00 00       	call   89e <printf>
 285:	83 c4 10             	add    $0x10,%esp
 288:	eb 12                	jmp    29c <print_mode+0x9e>
  else
    printf(1, "-");
 28a:	83 ec 08             	sub    $0x8,%esp
 28d:	68 d9 0c 00 00       	push   $0xcd9
 292:	6a 01                	push   $0x1
 294:	e8 05 06 00 00       	call   89e <printf>
 299:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2a3:	83 e0 80             	and    $0xffffff80,%eax
 2a6:	84 c0                	test   %al,%al
 2a8:	74 14                	je     2be <print_mode+0xc0>
    printf(1, "w");
 2aa:	83 ec 08             	sub    $0x8,%esp
 2ad:	68 e1 0c 00 00       	push   $0xce1
 2b2:	6a 01                	push   $0x1
 2b4:	e8 e5 05 00 00       	call   89e <printf>
 2b9:	83 c4 10             	add    $0x10,%esp
 2bc:	eb 12                	jmp    2d0 <print_mode+0xd2>
  else
    printf(1, "-");
 2be:	83 ec 08             	sub    $0x8,%esp
 2c1:	68 d9 0c 00 00       	push   $0xcd9
 2c6:	6a 01                	push   $0x1
 2c8:	e8 d1 05 00 00       	call   89e <printf>
 2cd:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2d7:	c0 e8 06             	shr    $0x6,%al
 2da:	83 e0 01             	and    $0x1,%eax
 2dd:	0f b6 d0             	movzbl %al,%edx
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 2e7:	d0 e8                	shr    %al
 2e9:	83 e0 01             	and    $0x1,%eax
 2ec:	0f b6 c0             	movzbl %al,%eax
 2ef:	21 d0                	and    %edx,%eax
 2f1:	85 c0                	test   %eax,%eax
 2f3:	74 14                	je     309 <print_mode+0x10b>
    printf(1, "S");
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	68 e3 0c 00 00       	push   $0xce3
 2fd:	6a 01                	push   $0x1
 2ff:	e8 9a 05 00 00       	call   89e <printf>
 304:	83 c4 10             	add    $0x10,%esp
 307:	eb 34                	jmp    33d <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 310:	83 e0 40             	and    $0x40,%eax
 313:	84 c0                	test   %al,%al
 315:	74 14                	je     32b <print_mode+0x12d>
    printf(1, "x");
 317:	83 ec 08             	sub    $0x8,%esp
 31a:	68 e5 0c 00 00       	push   $0xce5
 31f:	6a 01                	push   $0x1
 321:	e8 78 05 00 00       	call   89e <printf>
 326:	83 c4 10             	add    $0x10,%esp
 329:	eb 12                	jmp    33d <print_mode+0x13f>
  else
    printf(1, "-");
 32b:	83 ec 08             	sub    $0x8,%esp
 32e:	68 d9 0c 00 00       	push   $0xcd9
 333:	6a 01                	push   $0x1
 335:	e8 64 05 00 00       	call   89e <printf>
 33a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 344:	83 e0 20             	and    $0x20,%eax
 347:	84 c0                	test   %al,%al
 349:	74 14                	je     35f <print_mode+0x161>
    printf(1, "r");
 34b:	83 ec 08             	sub    $0x8,%esp
 34e:	68 df 0c 00 00       	push   $0xcdf
 353:	6a 01                	push   $0x1
 355:	e8 44 05 00 00       	call   89e <printf>
 35a:	83 c4 10             	add    $0x10,%esp
 35d:	eb 12                	jmp    371 <print_mode+0x173>
  else
    printf(1, "-");
 35f:	83 ec 08             	sub    $0x8,%esp
 362:	68 d9 0c 00 00       	push   $0xcd9
 367:	6a 01                	push   $0x1
 369:	e8 30 05 00 00       	call   89e <printf>
 36e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 378:	83 e0 10             	and    $0x10,%eax
 37b:	84 c0                	test   %al,%al
 37d:	74 14                	je     393 <print_mode+0x195>
    printf(1, "w");
 37f:	83 ec 08             	sub    $0x8,%esp
 382:	68 e1 0c 00 00       	push   $0xce1
 387:	6a 01                	push   $0x1
 389:	e8 10 05 00 00       	call   89e <printf>
 38e:	83 c4 10             	add    $0x10,%esp
 391:	eb 12                	jmp    3a5 <print_mode+0x1a7>
  else
    printf(1, "-");
 393:	83 ec 08             	sub    $0x8,%esp
 396:	68 d9 0c 00 00       	push   $0xcd9
 39b:	6a 01                	push   $0x1
 39d:	e8 fc 04 00 00       	call   89e <printf>
 3a2:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
 3a8:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3ac:	83 e0 08             	and    $0x8,%eax
 3af:	84 c0                	test   %al,%al
 3b1:	74 14                	je     3c7 <print_mode+0x1c9>
    printf(1, "x");
 3b3:	83 ec 08             	sub    $0x8,%esp
 3b6:	68 e5 0c 00 00       	push   $0xce5
 3bb:	6a 01                	push   $0x1
 3bd:	e8 dc 04 00 00       	call   89e <printf>
 3c2:	83 c4 10             	add    $0x10,%esp
 3c5:	eb 12                	jmp    3d9 <print_mode+0x1db>
  else
    printf(1, "-");
 3c7:	83 ec 08             	sub    $0x8,%esp
 3ca:	68 d9 0c 00 00       	push   $0xcd9
 3cf:	6a 01                	push   $0x1
 3d1:	e8 c8 04 00 00       	call   89e <printf>
 3d6:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 3e0:	83 e0 04             	and    $0x4,%eax
 3e3:	84 c0                	test   %al,%al
 3e5:	74 14                	je     3fb <print_mode+0x1fd>
    printf(1, "r");
 3e7:	83 ec 08             	sub    $0x8,%esp
 3ea:	68 df 0c 00 00       	push   $0xcdf
 3ef:	6a 01                	push   $0x1
 3f1:	e8 a8 04 00 00       	call   89e <printf>
 3f6:	83 c4 10             	add    $0x10,%esp
 3f9:	eb 12                	jmp    40d <print_mode+0x20f>
  else
    printf(1, "-");
 3fb:	83 ec 08             	sub    $0x8,%esp
 3fe:	68 d9 0c 00 00       	push   $0xcd9
 403:	6a 01                	push   $0x1
 405:	e8 94 04 00 00       	call   89e <printf>
 40a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 414:	83 e0 02             	and    $0x2,%eax
 417:	84 c0                	test   %al,%al
 419:	74 14                	je     42f <print_mode+0x231>
    printf(1, "w");
 41b:	83 ec 08             	sub    $0x8,%esp
 41e:	68 e1 0c 00 00       	push   $0xce1
 423:	6a 01                	push   $0x1
 425:	e8 74 04 00 00       	call   89e <printf>
 42a:	83 c4 10             	add    $0x10,%esp
 42d:	eb 12                	jmp    441 <print_mode+0x243>
  else
    printf(1, "-");
 42f:	83 ec 08             	sub    $0x8,%esp
 432:	68 d9 0c 00 00       	push   $0xcd9
 437:	6a 01                	push   $0x1
 439:	e8 60 04 00 00       	call   89e <printf>
 43e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 448:	83 e0 01             	and    $0x1,%eax
 44b:	84 c0                	test   %al,%al
 44d:	74 14                	je     463 <print_mode+0x265>
    printf(1, "x");
 44f:	83 ec 08             	sub    $0x8,%esp
 452:	68 e5 0c 00 00       	push   $0xce5
 457:	6a 01                	push   $0x1
 459:	e8 40 04 00 00       	call   89e <printf>
 45e:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 461:	eb 13                	jmp    476 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 463:	83 ec 08             	sub    $0x8,%esp
 466:	68 d9 0c 00 00       	push   $0xcd9
 46b:	6a 01                	push   $0x1
 46d:	e8 2c 04 00 00       	call   89e <printf>
 472:	83 c4 10             	add    $0x10,%esp

  return;
 475:	90                   	nop
}
 476:	c9                   	leave  
 477:	c3                   	ret    

00000478 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	57                   	push   %edi
 47c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 47d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 480:	8b 55 10             	mov    0x10(%ebp),%edx
 483:	8b 45 0c             	mov    0xc(%ebp),%eax
 486:	89 cb                	mov    %ecx,%ebx
 488:	89 df                	mov    %ebx,%edi
 48a:	89 d1                	mov    %edx,%ecx
 48c:	fc                   	cld    
 48d:	f3 aa                	rep stos %al,%es:(%edi)
 48f:	89 ca                	mov    %ecx,%edx
 491:	89 fb                	mov    %edi,%ebx
 493:	89 5d 08             	mov    %ebx,0x8(%ebp)
 496:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 499:	90                   	nop
 49a:	5b                   	pop    %ebx
 49b:	5f                   	pop    %edi
 49c:	5d                   	pop    %ebp
 49d:	c3                   	ret    

0000049e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 49e:	55                   	push   %ebp
 49f:	89 e5                	mov    %esp,%ebp
 4a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 4aa:	90                   	nop
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	8d 50 01             	lea    0x1(%eax),%edx
 4b1:	89 55 08             	mov    %edx,0x8(%ebp)
 4b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b7:	8d 4a 01             	lea    0x1(%edx),%ecx
 4ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 4bd:	0f b6 12             	movzbl (%edx),%edx
 4c0:	88 10                	mov    %dl,(%eax)
 4c2:	0f b6 00             	movzbl (%eax),%eax
 4c5:	84 c0                	test   %al,%al
 4c7:	75 e2                	jne    4ab <strcpy+0xd>
    ;
  return os;
 4c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4cc:	c9                   	leave  
 4cd:	c3                   	ret    

000004ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 4d1:	eb 08                	jmp    4db <strcmp+0xd>
    p++, q++;
 4d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	0f b6 00             	movzbl (%eax),%eax
 4e1:	84 c0                	test   %al,%al
 4e3:	74 10                	je     4f5 <strcmp+0x27>
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	0f b6 10             	movzbl (%eax),%edx
 4eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ee:	0f b6 00             	movzbl (%eax),%eax
 4f1:	38 c2                	cmp    %al,%dl
 4f3:	74 de                	je     4d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	0f b6 00             	movzbl (%eax),%eax
 4fb:	0f b6 d0             	movzbl %al,%edx
 4fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 501:	0f b6 00             	movzbl (%eax),%eax
 504:	0f b6 c0             	movzbl %al,%eax
 507:	29 c2                	sub    %eax,%edx
 509:	89 d0                	mov    %edx,%eax
}
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    

0000050d <strlen>:

uint
strlen(char *s)
{
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 513:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 51a:	eb 04                	jmp    520 <strlen+0x13>
 51c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 520:	8b 55 fc             	mov    -0x4(%ebp),%edx
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	01 d0                	add    %edx,%eax
 528:	0f b6 00             	movzbl (%eax),%eax
 52b:	84 c0                	test   %al,%al
 52d:	75 ed                	jne    51c <strlen+0xf>
    ;
  return n;
 52f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <memset>:

void*
memset(void *dst, int c, uint n)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 537:	8b 45 10             	mov    0x10(%ebp),%eax
 53a:	50                   	push   %eax
 53b:	ff 75 0c             	pushl  0xc(%ebp)
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 32 ff ff ff       	call   478 <stosb>
 546:	83 c4 0c             	add    $0xc,%esp
  return dst;
 549:	8b 45 08             	mov    0x8(%ebp),%eax
}
 54c:	c9                   	leave  
 54d:	c3                   	ret    

0000054e <strchr>:

char*
strchr(const char *s, char c)
{
 54e:	55                   	push   %ebp
 54f:	89 e5                	mov    %esp,%ebp
 551:	83 ec 04             	sub    $0x4,%esp
 554:	8b 45 0c             	mov    0xc(%ebp),%eax
 557:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 55a:	eb 14                	jmp    570 <strchr+0x22>
    if(*s == c)
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	3a 45 fc             	cmp    -0x4(%ebp),%al
 565:	75 05                	jne    56c <strchr+0x1e>
      return (char*)s;
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	eb 13                	jmp    57f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 56c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	84 c0                	test   %al,%al
 578:	75 e2                	jne    55c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 57a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 57f:	c9                   	leave  
 580:	c3                   	ret    

00000581 <gets>:

char*
gets(char *buf, int max)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 587:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 58e:	eb 42                	jmp    5d2 <gets+0x51>
    cc = read(0, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	6a 01                	push   $0x1
 595:	8d 45 ef             	lea    -0x11(%ebp),%eax
 598:	50                   	push   %eax
 599:	6a 00                	push   $0x0
 59b:	e8 47 01 00 00       	call   6e7 <read>
 5a0:	83 c4 10             	add    $0x10,%esp
 5a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5aa:	7e 33                	jle    5df <gets+0x5e>
      break;
    buf[i++] = c;
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	8d 50 01             	lea    0x1(%eax),%edx
 5b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b5:	89 c2                	mov    %eax,%edx
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	01 c2                	add    %eax,%edx
 5bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5c0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 5c2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5c6:	3c 0a                	cmp    $0xa,%al
 5c8:	74 16                	je     5e0 <gets+0x5f>
 5ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5ce:	3c 0d                	cmp    $0xd,%al
 5d0:	74 0e                	je     5e0 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d5:	83 c0 01             	add    $0x1,%eax
 5d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5db:	7c b3                	jl     590 <gets+0xf>
 5dd:	eb 01                	jmp    5e0 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 5df:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	01 d0                	add    %edx,%eax
 5e8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ee:	c9                   	leave  
 5ef:	c3                   	ret    

000005f0 <stat>:

int
stat(char *n, struct stat *st)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f6:	83 ec 08             	sub    $0x8,%esp
 5f9:	6a 00                	push   $0x0
 5fb:	ff 75 08             	pushl  0x8(%ebp)
 5fe:	e8 0c 01 00 00       	call   70f <open>
 603:	83 c4 10             	add    $0x10,%esp
 606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60d:	79 07                	jns    616 <stat+0x26>
    return -1;
 60f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 614:	eb 25                	jmp    63b <stat+0x4b>
  r = fstat(fd, st);
 616:	83 ec 08             	sub    $0x8,%esp
 619:	ff 75 0c             	pushl  0xc(%ebp)
 61c:	ff 75 f4             	pushl  -0xc(%ebp)
 61f:	e8 03 01 00 00       	call   727 <fstat>
 624:	83 c4 10             	add    $0x10,%esp
 627:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 62a:	83 ec 0c             	sub    $0xc,%esp
 62d:	ff 75 f4             	pushl  -0xc(%ebp)
 630:	e8 c2 00 00 00       	call   6f7 <close>
 635:	83 c4 10             	add    $0x10,%esp
  return r;
 638:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <atoi>:

int
atoi(const char *s)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 643:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 64a:	eb 25                	jmp    671 <atoi+0x34>
    n = n*10 + *s++ - '0';
 64c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 64f:	89 d0                	mov    %edx,%eax
 651:	c1 e0 02             	shl    $0x2,%eax
 654:	01 d0                	add    %edx,%eax
 656:	01 c0                	add    %eax,%eax
 658:	89 c1                	mov    %eax,%ecx
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	8d 50 01             	lea    0x1(%eax),%edx
 660:	89 55 08             	mov    %edx,0x8(%ebp)
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	01 c8                	add    %ecx,%eax
 66b:	83 e8 30             	sub    $0x30,%eax
 66e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 671:	8b 45 08             	mov    0x8(%ebp),%eax
 674:	0f b6 00             	movzbl (%eax),%eax
 677:	3c 2f                	cmp    $0x2f,%al
 679:	7e 0a                	jle    685 <atoi+0x48>
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	0f b6 00             	movzbl (%eax),%eax
 681:	3c 39                	cmp    $0x39,%al
 683:	7e c7                	jle    64c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 688:	c9                   	leave  
 689:	c3                   	ret    

0000068a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 68a:	55                   	push   %ebp
 68b:	89 e5                	mov    %esp,%ebp
 68d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 696:	8b 45 0c             	mov    0xc(%ebp),%eax
 699:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 69c:	eb 17                	jmp    6b5 <memmove+0x2b>
    *dst++ = *src++;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8d 50 01             	lea    0x1(%eax),%edx
 6a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 6ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6b0:	0f b6 12             	movzbl (%edx),%edx
 6b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6b5:	8b 45 10             	mov    0x10(%ebp),%eax
 6b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 6bb:	89 55 10             	mov    %edx,0x10(%ebp)
 6be:	85 c0                	test   %eax,%eax
 6c0:	7f dc                	jg     69e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6c5:	c9                   	leave  
 6c6:	c3                   	ret    

000006c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6c7:	b8 01 00 00 00       	mov    $0x1,%eax
 6cc:	cd 40                	int    $0x40
 6ce:	c3                   	ret    

000006cf <exit>:
SYSCALL(exit)
 6cf:	b8 02 00 00 00       	mov    $0x2,%eax
 6d4:	cd 40                	int    $0x40
 6d6:	c3                   	ret    

000006d7 <wait>:
SYSCALL(wait)
 6d7:	b8 03 00 00 00       	mov    $0x3,%eax
 6dc:	cd 40                	int    $0x40
 6de:	c3                   	ret    

000006df <pipe>:
SYSCALL(pipe)
 6df:	b8 04 00 00 00       	mov    $0x4,%eax
 6e4:	cd 40                	int    $0x40
 6e6:	c3                   	ret    

000006e7 <read>:
SYSCALL(read)
 6e7:	b8 05 00 00 00       	mov    $0x5,%eax
 6ec:	cd 40                	int    $0x40
 6ee:	c3                   	ret    

000006ef <write>:
SYSCALL(write)
 6ef:	b8 10 00 00 00       	mov    $0x10,%eax
 6f4:	cd 40                	int    $0x40
 6f6:	c3                   	ret    

000006f7 <close>:
SYSCALL(close)
 6f7:	b8 15 00 00 00       	mov    $0x15,%eax
 6fc:	cd 40                	int    $0x40
 6fe:	c3                   	ret    

000006ff <kill>:
SYSCALL(kill)
 6ff:	b8 06 00 00 00       	mov    $0x6,%eax
 704:	cd 40                	int    $0x40
 706:	c3                   	ret    

00000707 <exec>:
SYSCALL(exec)
 707:	b8 07 00 00 00       	mov    $0x7,%eax
 70c:	cd 40                	int    $0x40
 70e:	c3                   	ret    

0000070f <open>:
SYSCALL(open)
 70f:	b8 0f 00 00 00       	mov    $0xf,%eax
 714:	cd 40                	int    $0x40
 716:	c3                   	ret    

00000717 <mknod>:
SYSCALL(mknod)
 717:	b8 11 00 00 00       	mov    $0x11,%eax
 71c:	cd 40                	int    $0x40
 71e:	c3                   	ret    

0000071f <unlink>:
SYSCALL(unlink)
 71f:	b8 12 00 00 00       	mov    $0x12,%eax
 724:	cd 40                	int    $0x40
 726:	c3                   	ret    

00000727 <fstat>:
SYSCALL(fstat)
 727:	b8 08 00 00 00       	mov    $0x8,%eax
 72c:	cd 40                	int    $0x40
 72e:	c3                   	ret    

0000072f <link>:
SYSCALL(link)
 72f:	b8 13 00 00 00       	mov    $0x13,%eax
 734:	cd 40                	int    $0x40
 736:	c3                   	ret    

00000737 <mkdir>:
SYSCALL(mkdir)
 737:	b8 14 00 00 00       	mov    $0x14,%eax
 73c:	cd 40                	int    $0x40
 73e:	c3                   	ret    

0000073f <chdir>:
SYSCALL(chdir)
 73f:	b8 09 00 00 00       	mov    $0x9,%eax
 744:	cd 40                	int    $0x40
 746:	c3                   	ret    

00000747 <dup>:
SYSCALL(dup)
 747:	b8 0a 00 00 00       	mov    $0xa,%eax
 74c:	cd 40                	int    $0x40
 74e:	c3                   	ret    

0000074f <getpid>:
SYSCALL(getpid)
 74f:	b8 0b 00 00 00       	mov    $0xb,%eax
 754:	cd 40                	int    $0x40
 756:	c3                   	ret    

00000757 <sbrk>:
SYSCALL(sbrk)
 757:	b8 0c 00 00 00       	mov    $0xc,%eax
 75c:	cd 40                	int    $0x40
 75e:	c3                   	ret    

0000075f <sleep>:
SYSCALL(sleep)
 75f:	b8 0d 00 00 00       	mov    $0xd,%eax
 764:	cd 40                	int    $0x40
 766:	c3                   	ret    

00000767 <uptime>:
SYSCALL(uptime)
 767:	b8 0e 00 00 00       	mov    $0xe,%eax
 76c:	cd 40                	int    $0x40
 76e:	c3                   	ret    

0000076f <halt>:
SYSCALL(halt)
 76f:	b8 16 00 00 00       	mov    $0x16,%eax
 774:	cd 40                	int    $0x40
 776:	c3                   	ret    

00000777 <date>:
//Student Implementations 
SYSCALL(date)
 777:	b8 17 00 00 00       	mov    $0x17,%eax
 77c:	cd 40                	int    $0x40
 77e:	c3                   	ret    

0000077f <getuid>:

SYSCALL(getuid)
 77f:	b8 18 00 00 00       	mov    $0x18,%eax
 784:	cd 40                	int    $0x40
 786:	c3                   	ret    

00000787 <getgid>:
SYSCALL(getgid)
 787:	b8 19 00 00 00       	mov    $0x19,%eax
 78c:	cd 40                	int    $0x40
 78e:	c3                   	ret    

0000078f <getppid>:
SYSCALL(getppid)
 78f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 794:	cd 40                	int    $0x40
 796:	c3                   	ret    

00000797 <setuid>:

SYSCALL(setuid)
 797:	b8 1b 00 00 00       	mov    $0x1b,%eax
 79c:	cd 40                	int    $0x40
 79e:	c3                   	ret    

0000079f <setgid>:
SYSCALL(setgid)
 79f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 7a4:	cd 40                	int    $0x40
 7a6:	c3                   	ret    

000007a7 <getprocs>:
SYSCALL(getprocs)
 7a7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 7ac:	cd 40                	int    $0x40
 7ae:	c3                   	ret    

000007af <chown>:

SYSCALL(chown)
 7af:	b8 1e 00 00 00       	mov    $0x1e,%eax
 7b4:	cd 40                	int    $0x40
 7b6:	c3                   	ret    

000007b7 <chgrp>:
SYSCALL(chgrp)
 7b7:	b8 1f 00 00 00       	mov    $0x1f,%eax
 7bc:	cd 40                	int    $0x40
 7be:	c3                   	ret    

000007bf <chmod>:
SYSCALL(chmod)
 7bf:	b8 20 00 00 00       	mov    $0x20,%eax
 7c4:	cd 40                	int    $0x40
 7c6:	c3                   	ret    

000007c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7c7:	55                   	push   %ebp
 7c8:	89 e5                	mov    %esp,%ebp
 7ca:	83 ec 18             	sub    $0x18,%esp
 7cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7d3:	83 ec 04             	sub    $0x4,%esp
 7d6:	6a 01                	push   $0x1
 7d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7db:	50                   	push   %eax
 7dc:	ff 75 08             	pushl  0x8(%ebp)
 7df:	e8 0b ff ff ff       	call   6ef <write>
 7e4:	83 c4 10             	add    $0x10,%esp
}
 7e7:	90                   	nop
 7e8:	c9                   	leave  
 7e9:	c3                   	ret    

000007ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7ea:	55                   	push   %ebp
 7eb:	89 e5                	mov    %esp,%ebp
 7ed:	53                   	push   %ebx
 7ee:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7f8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7fc:	74 17                	je     815 <printint+0x2b>
 7fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 802:	79 11                	jns    815 <printint+0x2b>
    neg = 1;
 804:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 80b:	8b 45 0c             	mov    0xc(%ebp),%eax
 80e:	f7 d8                	neg    %eax
 810:	89 45 ec             	mov    %eax,-0x14(%ebp)
 813:	eb 06                	jmp    81b <printint+0x31>
  } else {
    x = xx;
 815:	8b 45 0c             	mov    0xc(%ebp),%eax
 818:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 81b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 822:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 825:	8d 41 01             	lea    0x1(%ecx),%eax
 828:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 82e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 831:	ba 00 00 00 00       	mov    $0x0,%edx
 836:	f7 f3                	div    %ebx
 838:	89 d0                	mov    %edx,%eax
 83a:	0f b6 80 84 0f 00 00 	movzbl 0xf84(%eax),%eax
 841:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 845:	8b 5d 10             	mov    0x10(%ebp),%ebx
 848:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84b:	ba 00 00 00 00       	mov    $0x0,%edx
 850:	f7 f3                	div    %ebx
 852:	89 45 ec             	mov    %eax,-0x14(%ebp)
 855:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 859:	75 c7                	jne    822 <printint+0x38>
  if(neg)
 85b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85f:	74 2d                	je     88e <printint+0xa4>
    buf[i++] = '-';
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8d 50 01             	lea    0x1(%eax),%edx
 867:	89 55 f4             	mov    %edx,-0xc(%ebp)
 86a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 86f:	eb 1d                	jmp    88e <printint+0xa4>
    putc(fd, buf[i]);
 871:	8d 55 dc             	lea    -0x24(%ebp),%edx
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	01 d0                	add    %edx,%eax
 879:	0f b6 00             	movzbl (%eax),%eax
 87c:	0f be c0             	movsbl %al,%eax
 87f:	83 ec 08             	sub    $0x8,%esp
 882:	50                   	push   %eax
 883:	ff 75 08             	pushl  0x8(%ebp)
 886:	e8 3c ff ff ff       	call   7c7 <putc>
 88b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 88e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 892:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 896:	79 d9                	jns    871 <printint+0x87>
    putc(fd, buf[i]);
}
 898:	90                   	nop
 899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 89c:	c9                   	leave  
 89d:	c3                   	ret    

0000089e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 89e:	55                   	push   %ebp
 89f:	89 e5                	mov    %esp,%ebp
 8a1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8ab:	8d 45 0c             	lea    0xc(%ebp),%eax
 8ae:	83 c0 04             	add    $0x4,%eax
 8b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8bb:	e9 59 01 00 00       	jmp    a19 <printf+0x17b>
    c = fmt[i] & 0xff;
 8c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c6:	01 d0                	add    %edx,%eax
 8c8:	0f b6 00             	movzbl (%eax),%eax
 8cb:	0f be c0             	movsbl %al,%eax
 8ce:	25 ff 00 00 00       	and    $0xff,%eax
 8d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8da:	75 2c                	jne    908 <printf+0x6a>
      if(c == '%'){
 8dc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8e0:	75 0c                	jne    8ee <printf+0x50>
        state = '%';
 8e2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8e9:	e9 27 01 00 00       	jmp    a15 <printf+0x177>
      } else {
        putc(fd, c);
 8ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f1:	0f be c0             	movsbl %al,%eax
 8f4:	83 ec 08             	sub    $0x8,%esp
 8f7:	50                   	push   %eax
 8f8:	ff 75 08             	pushl  0x8(%ebp)
 8fb:	e8 c7 fe ff ff       	call   7c7 <putc>
 900:	83 c4 10             	add    $0x10,%esp
 903:	e9 0d 01 00 00       	jmp    a15 <printf+0x177>
      }
    } else if(state == '%'){
 908:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 90c:	0f 85 03 01 00 00    	jne    a15 <printf+0x177>
      if(c == 'd'){
 912:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 916:	75 1e                	jne    936 <printf+0x98>
        printint(fd, *ap, 10, 1);
 918:	8b 45 e8             	mov    -0x18(%ebp),%eax
 91b:	8b 00                	mov    (%eax),%eax
 91d:	6a 01                	push   $0x1
 91f:	6a 0a                	push   $0xa
 921:	50                   	push   %eax
 922:	ff 75 08             	pushl  0x8(%ebp)
 925:	e8 c0 fe ff ff       	call   7ea <printint>
 92a:	83 c4 10             	add    $0x10,%esp
        ap++;
 92d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 931:	e9 d8 00 00 00       	jmp    a0e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 936:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 93a:	74 06                	je     942 <printf+0xa4>
 93c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 940:	75 1e                	jne    960 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 942:	8b 45 e8             	mov    -0x18(%ebp),%eax
 945:	8b 00                	mov    (%eax),%eax
 947:	6a 00                	push   $0x0
 949:	6a 10                	push   $0x10
 94b:	50                   	push   %eax
 94c:	ff 75 08             	pushl  0x8(%ebp)
 94f:	e8 96 fe ff ff       	call   7ea <printint>
 954:	83 c4 10             	add    $0x10,%esp
        ap++;
 957:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 95b:	e9 ae 00 00 00       	jmp    a0e <printf+0x170>
      } else if(c == 's'){
 960:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 964:	75 43                	jne    9a9 <printf+0x10b>
        s = (char*)*ap;
 966:	8b 45 e8             	mov    -0x18(%ebp),%eax
 969:	8b 00                	mov    (%eax),%eax
 96b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 96e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 976:	75 25                	jne    99d <printf+0xff>
          s = "(null)";
 978:	c7 45 f4 e7 0c 00 00 	movl   $0xce7,-0xc(%ebp)
        while(*s != 0){
 97f:	eb 1c                	jmp    99d <printf+0xff>
          putc(fd, *s);
 981:	8b 45 f4             	mov    -0xc(%ebp),%eax
 984:	0f b6 00             	movzbl (%eax),%eax
 987:	0f be c0             	movsbl %al,%eax
 98a:	83 ec 08             	sub    $0x8,%esp
 98d:	50                   	push   %eax
 98e:	ff 75 08             	pushl  0x8(%ebp)
 991:	e8 31 fe ff ff       	call   7c7 <putc>
 996:	83 c4 10             	add    $0x10,%esp
          s++;
 999:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a0:	0f b6 00             	movzbl (%eax),%eax
 9a3:	84 c0                	test   %al,%al
 9a5:	75 da                	jne    981 <printf+0xe3>
 9a7:	eb 65                	jmp    a0e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9a9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9ad:	75 1d                	jne    9cc <printf+0x12e>
        putc(fd, *ap);
 9af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9b2:	8b 00                	mov    (%eax),%eax
 9b4:	0f be c0             	movsbl %al,%eax
 9b7:	83 ec 08             	sub    $0x8,%esp
 9ba:	50                   	push   %eax
 9bb:	ff 75 08             	pushl  0x8(%ebp)
 9be:	e8 04 fe ff ff       	call   7c7 <putc>
 9c3:	83 c4 10             	add    $0x10,%esp
        ap++;
 9c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9ca:	eb 42                	jmp    a0e <printf+0x170>
      } else if(c == '%'){
 9cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9d0:	75 17                	jne    9e9 <printf+0x14b>
        putc(fd, c);
 9d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9d5:	0f be c0             	movsbl %al,%eax
 9d8:	83 ec 08             	sub    $0x8,%esp
 9db:	50                   	push   %eax
 9dc:	ff 75 08             	pushl  0x8(%ebp)
 9df:	e8 e3 fd ff ff       	call   7c7 <putc>
 9e4:	83 c4 10             	add    $0x10,%esp
 9e7:	eb 25                	jmp    a0e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9e9:	83 ec 08             	sub    $0x8,%esp
 9ec:	6a 25                	push   $0x25
 9ee:	ff 75 08             	pushl  0x8(%ebp)
 9f1:	e8 d1 fd ff ff       	call   7c7 <putc>
 9f6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 9f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9fc:	0f be c0             	movsbl %al,%eax
 9ff:	83 ec 08             	sub    $0x8,%esp
 a02:	50                   	push   %eax
 a03:	ff 75 08             	pushl  0x8(%ebp)
 a06:	e8 bc fd ff ff       	call   7c7 <putc>
 a0b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a0e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a15:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a19:	8b 55 0c             	mov    0xc(%ebp),%edx
 a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1f:	01 d0                	add    %edx,%eax
 a21:	0f b6 00             	movzbl (%eax),%eax
 a24:	84 c0                	test   %al,%al
 a26:	0f 85 94 fe ff ff    	jne    8c0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a2c:	90                   	nop
 a2d:	c9                   	leave  
 a2e:	c3                   	ret    

00000a2f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a2f:	55                   	push   %ebp
 a30:	89 e5                	mov    %esp,%ebp
 a32:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a35:	8b 45 08             	mov    0x8(%ebp),%eax
 a38:	83 e8 08             	sub    $0x8,%eax
 a3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a3e:	a1 a0 0f 00 00       	mov    0xfa0,%eax
 a43:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a46:	eb 24                	jmp    a6c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4b:	8b 00                	mov    (%eax),%eax
 a4d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a50:	77 12                	ja     a64 <free+0x35>
 a52:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a55:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a58:	77 24                	ja     a7e <free+0x4f>
 a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5d:	8b 00                	mov    (%eax),%eax
 a5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a62:	77 1a                	ja     a7e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a67:	8b 00                	mov    (%eax),%eax
 a69:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a72:	76 d4                	jbe    a48 <free+0x19>
 a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a77:	8b 00                	mov    (%eax),%eax
 a79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a7c:	76 ca                	jbe    a48 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a81:	8b 40 04             	mov    0x4(%eax),%eax
 a84:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a8e:	01 c2                	add    %eax,%edx
 a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a93:	8b 00                	mov    (%eax),%eax
 a95:	39 c2                	cmp    %eax,%edx
 a97:	75 24                	jne    abd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a99:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a9c:	8b 50 04             	mov    0x4(%eax),%edx
 a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa2:	8b 00                	mov    (%eax),%eax
 aa4:	8b 40 04             	mov    0x4(%eax),%eax
 aa7:	01 c2                	add    %eax,%edx
 aa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aac:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab2:	8b 00                	mov    (%eax),%eax
 ab4:	8b 10                	mov    (%eax),%edx
 ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab9:	89 10                	mov    %edx,(%eax)
 abb:	eb 0a                	jmp    ac7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac0:	8b 10                	mov    (%eax),%edx
 ac2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 ac7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aca:	8b 40 04             	mov    0x4(%eax),%eax
 acd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ad4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad7:	01 d0                	add    %edx,%eax
 ad9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 adc:	75 20                	jne    afe <free+0xcf>
    p->s.size += bp->s.size;
 ade:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae1:	8b 50 04             	mov    0x4(%eax),%edx
 ae4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae7:	8b 40 04             	mov    0x4(%eax),%eax
 aea:	01 c2                	add    %eax,%edx
 aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 af2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af5:	8b 10                	mov    (%eax),%edx
 af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afa:	89 10                	mov    %edx,(%eax)
 afc:	eb 08                	jmp    b06 <free+0xd7>
  } else
    p->s.ptr = bp;
 afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b01:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b04:	89 10                	mov    %edx,(%eax)
  freep = p;
 b06:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b09:	a3 a0 0f 00 00       	mov    %eax,0xfa0
}
 b0e:	90                   	nop
 b0f:	c9                   	leave  
 b10:	c3                   	ret    

00000b11 <morecore>:

static Header*
morecore(uint nu)
{
 b11:	55                   	push   %ebp
 b12:	89 e5                	mov    %esp,%ebp
 b14:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b17:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b1e:	77 07                	ja     b27 <morecore+0x16>
    nu = 4096;
 b20:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b27:	8b 45 08             	mov    0x8(%ebp),%eax
 b2a:	c1 e0 03             	shl    $0x3,%eax
 b2d:	83 ec 0c             	sub    $0xc,%esp
 b30:	50                   	push   %eax
 b31:	e8 21 fc ff ff       	call   757 <sbrk>
 b36:	83 c4 10             	add    $0x10,%esp
 b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b3c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b40:	75 07                	jne    b49 <morecore+0x38>
    return 0;
 b42:	b8 00 00 00 00       	mov    $0x0,%eax
 b47:	eb 26                	jmp    b6f <morecore+0x5e>
  hp = (Header*)p;
 b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b52:	8b 55 08             	mov    0x8(%ebp),%edx
 b55:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b5b:	83 c0 08             	add    $0x8,%eax
 b5e:	83 ec 0c             	sub    $0xc,%esp
 b61:	50                   	push   %eax
 b62:	e8 c8 fe ff ff       	call   a2f <free>
 b67:	83 c4 10             	add    $0x10,%esp
  return freep;
 b6a:	a1 a0 0f 00 00       	mov    0xfa0,%eax
}
 b6f:	c9                   	leave  
 b70:	c3                   	ret    

00000b71 <malloc>:

void*
malloc(uint nbytes)
{
 b71:	55                   	push   %ebp
 b72:	89 e5                	mov    %esp,%ebp
 b74:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b77:	8b 45 08             	mov    0x8(%ebp),%eax
 b7a:	83 c0 07             	add    $0x7,%eax
 b7d:	c1 e8 03             	shr    $0x3,%eax
 b80:	83 c0 01             	add    $0x1,%eax
 b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b86:	a1 a0 0f 00 00       	mov    0xfa0,%eax
 b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b92:	75 23                	jne    bb7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b94:	c7 45 f0 98 0f 00 00 	movl   $0xf98,-0x10(%ebp)
 b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9e:	a3 a0 0f 00 00       	mov    %eax,0xfa0
 ba3:	a1 a0 0f 00 00       	mov    0xfa0,%eax
 ba8:	a3 98 0f 00 00       	mov    %eax,0xf98
    base.s.size = 0;
 bad:	c7 05 9c 0f 00 00 00 	movl   $0x0,0xf9c
 bb4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bba:	8b 00                	mov    (%eax),%eax
 bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc2:	8b 40 04             	mov    0x4(%eax),%eax
 bc5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bc8:	72 4d                	jb     c17 <malloc+0xa6>
      if(p->s.size == nunits)
 bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bcd:	8b 40 04             	mov    0x4(%eax),%eax
 bd0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bd3:	75 0c                	jne    be1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd8:	8b 10                	mov    (%eax),%edx
 bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bdd:	89 10                	mov    %edx,(%eax)
 bdf:	eb 26                	jmp    c07 <malloc+0x96>
      else {
        p->s.size -= nunits;
 be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be4:	8b 40 04             	mov    0x4(%eax),%eax
 be7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bea:	89 c2                	mov    %eax,%edx
 bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf5:	8b 40 04             	mov    0x4(%eax),%eax
 bf8:	c1 e0 03             	shl    $0x3,%eax
 bfb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c01:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c04:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0a:	a3 a0 0f 00 00       	mov    %eax,0xfa0
      return (void*)(p + 1);
 c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c12:	83 c0 08             	add    $0x8,%eax
 c15:	eb 3b                	jmp    c52 <malloc+0xe1>
    }
    if(p == freep)
 c17:	a1 a0 0f 00 00       	mov    0xfa0,%eax
 c1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c1f:	75 1e                	jne    c3f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 c21:	83 ec 0c             	sub    $0xc,%esp
 c24:	ff 75 ec             	pushl  -0x14(%ebp)
 c27:	e8 e5 fe ff ff       	call   b11 <morecore>
 c2c:	83 c4 10             	add    $0x10,%esp
 c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c36:	75 07                	jne    c3f <malloc+0xce>
        return 0;
 c38:	b8 00 00 00 00       	mov    $0x0,%eax
 c3d:	eb 13                	jmp    c52 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c48:	8b 00                	mov    (%eax),%eax
 c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c4d:	e9 6d ff ff ff       	jmp    bbf <malloc+0x4e>
}
 c52:	c9                   	leave  
 c53:	c3                   	ret    
