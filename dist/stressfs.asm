
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 90 0b 00 00       	push   $0xb90
  30:	6a 01                	push   $0x1
  32:	e8 a3 07 00 00       	call   7da <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 38 04 00 00       	call   488 <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 ba 05 00 00       	call   61b <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
    if(fork() > 0)
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	pushl  -0xc(%ebp)
  78:	68 a3 0b 00 00       	push   $0xba3
  7d:	6a 01                	push   $0x1
  7f:	e8 56 07 00 00       	call   7da <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 bd 05 00 00       	call   663 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	pushl  -0x10(%ebp)
  c7:	e8 77 05 00 00       	call   643 <write>
  cc:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	pushl  -0x10(%ebp)
  df:	e8 67 05 00 00       	call   64b <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 ad 0b 00 00       	push   $0xbad
  ef:	6a 01                	push   $0x1
  f1:	e8 e4 06 00 00       	call   7da <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 5c 05 00 00       	call   663 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	pushl  -0x10(%ebp)
 128:	e8 0e 05 00 00       	call   63b <read>
 12d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	pushl  -0x10(%ebp)
 140:	e8 06 05 00 00       	call   64b <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 de 04 00 00       	call   62b <wait>
  
  exit();
 14d:	e8 d1 04 00 00       	call   623 <exit>

00000152 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b7 00             	movzwl (%eax),%eax
 15e:	98                   	cwtl   
 15f:	83 f8 02             	cmp    $0x2,%eax
 162:	74 1e                	je     182 <print_mode+0x30>
 164:	83 f8 03             	cmp    $0x3,%eax
 167:	74 2d                	je     196 <print_mode+0x44>
 169:	83 f8 01             	cmp    $0x1,%eax
 16c:	75 3c                	jne    1aa <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 16e:	83 ec 08             	sub    $0x8,%esp
 171:	68 b3 0b 00 00       	push   $0xbb3
 176:	6a 01                	push   $0x1
 178:	e8 5d 06 00 00       	call   7da <printf>
 17d:	83 c4 10             	add    $0x10,%esp
 180:	eb 3a                	jmp    1bc <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 182:	83 ec 08             	sub    $0x8,%esp
 185:	68 b5 0b 00 00       	push   $0xbb5
 18a:	6a 01                	push   $0x1
 18c:	e8 49 06 00 00       	call   7da <printf>
 191:	83 c4 10             	add    $0x10,%esp
 194:	eb 26                	jmp    1bc <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 196:	83 ec 08             	sub    $0x8,%esp
 199:	68 b7 0b 00 00       	push   $0xbb7
 19e:	6a 01                	push   $0x1
 1a0:	e8 35 06 00 00       	call   7da <printf>
 1a5:	83 c4 10             	add    $0x10,%esp
 1a8:	eb 12                	jmp    1bc <print_mode+0x6a>
    default: printf(1, "?");
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	68 b9 0b 00 00       	push   $0xbb9
 1b2:	6a 01                	push   $0x1
 1b4:	e8 21 06 00 00       	call   7da <printf>
 1b9:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 1c3:	83 e0 01             	and    $0x1,%eax
 1c6:	84 c0                	test   %al,%al
 1c8:	74 14                	je     1de <print_mode+0x8c>
    printf(1, "r");
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	68 bb 0b 00 00       	push   $0xbbb
 1d2:	6a 01                	push   $0x1
 1d4:	e8 01 06 00 00       	call   7da <printf>
 1d9:	83 c4 10             	add    $0x10,%esp
 1dc:	eb 12                	jmp    1f0 <print_mode+0x9e>
  else
    printf(1, "-");
 1de:	83 ec 08             	sub    $0x8,%esp
 1e1:	68 b5 0b 00 00       	push   $0xbb5
 1e6:	6a 01                	push   $0x1
 1e8:	e8 ed 05 00 00       	call   7da <printf>
 1ed:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1f7:	83 e0 80             	and    $0xffffff80,%eax
 1fa:	84 c0                	test   %al,%al
 1fc:	74 14                	je     212 <print_mode+0xc0>
    printf(1, "w");
 1fe:	83 ec 08             	sub    $0x8,%esp
 201:	68 bd 0b 00 00       	push   $0xbbd
 206:	6a 01                	push   $0x1
 208:	e8 cd 05 00 00       	call   7da <printf>
 20d:	83 c4 10             	add    $0x10,%esp
 210:	eb 12                	jmp    224 <print_mode+0xd2>
  else
    printf(1, "-");
 212:	83 ec 08             	sub    $0x8,%esp
 215:	68 b5 0b 00 00       	push   $0xbb5
 21a:	6a 01                	push   $0x1
 21c:	e8 b9 05 00 00       	call   7da <printf>
 221:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 22b:	c0 e8 06             	shr    $0x6,%al
 22e:	83 e0 01             	and    $0x1,%eax
 231:	0f b6 d0             	movzbl %al,%edx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 23b:	d0 e8                	shr    %al
 23d:	83 e0 01             	and    $0x1,%eax
 240:	0f b6 c0             	movzbl %al,%eax
 243:	21 d0                	and    %edx,%eax
 245:	85 c0                	test   %eax,%eax
 247:	74 14                	je     25d <print_mode+0x10b>
    printf(1, "S");
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	68 bf 0b 00 00       	push   $0xbbf
 251:	6a 01                	push   $0x1
 253:	e8 82 05 00 00       	call   7da <printf>
 258:	83 c4 10             	add    $0x10,%esp
 25b:	eb 34                	jmp    291 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 264:	83 e0 40             	and    $0x40,%eax
 267:	84 c0                	test   %al,%al
 269:	74 14                	je     27f <print_mode+0x12d>
    printf(1, "x");
 26b:	83 ec 08             	sub    $0x8,%esp
 26e:	68 c1 0b 00 00       	push   $0xbc1
 273:	6a 01                	push   $0x1
 275:	e8 60 05 00 00       	call   7da <printf>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	eb 12                	jmp    291 <print_mode+0x13f>
  else
    printf(1, "-");
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	68 b5 0b 00 00       	push   $0xbb5
 287:	6a 01                	push   $0x1
 289:	e8 4c 05 00 00       	call   7da <printf>
 28e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 298:	83 e0 20             	and    $0x20,%eax
 29b:	84 c0                	test   %al,%al
 29d:	74 14                	je     2b3 <print_mode+0x161>
    printf(1, "r");
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	68 bb 0b 00 00       	push   $0xbbb
 2a7:	6a 01                	push   $0x1
 2a9:	e8 2c 05 00 00       	call   7da <printf>
 2ae:	83 c4 10             	add    $0x10,%esp
 2b1:	eb 12                	jmp    2c5 <print_mode+0x173>
  else
    printf(1, "-");
 2b3:	83 ec 08             	sub    $0x8,%esp
 2b6:	68 b5 0b 00 00       	push   $0xbb5
 2bb:	6a 01                	push   $0x1
 2bd:	e8 18 05 00 00       	call   7da <printf>
 2c2:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2cc:	83 e0 10             	and    $0x10,%eax
 2cf:	84 c0                	test   %al,%al
 2d1:	74 14                	je     2e7 <print_mode+0x195>
    printf(1, "w");
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	68 bd 0b 00 00       	push   $0xbbd
 2db:	6a 01                	push   $0x1
 2dd:	e8 f8 04 00 00       	call   7da <printf>
 2e2:	83 c4 10             	add    $0x10,%esp
 2e5:	eb 12                	jmp    2f9 <print_mode+0x1a7>
  else
    printf(1, "-");
 2e7:	83 ec 08             	sub    $0x8,%esp
 2ea:	68 b5 0b 00 00       	push   $0xbb5
 2ef:	6a 01                	push   $0x1
 2f1:	e8 e4 04 00 00       	call   7da <printf>
 2f6:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 300:	83 e0 08             	and    $0x8,%eax
 303:	84 c0                	test   %al,%al
 305:	74 14                	je     31b <print_mode+0x1c9>
    printf(1, "x");
 307:	83 ec 08             	sub    $0x8,%esp
 30a:	68 c1 0b 00 00       	push   $0xbc1
 30f:	6a 01                	push   $0x1
 311:	e8 c4 04 00 00       	call   7da <printf>
 316:	83 c4 10             	add    $0x10,%esp
 319:	eb 12                	jmp    32d <print_mode+0x1db>
  else
    printf(1, "-");
 31b:	83 ec 08             	sub    $0x8,%esp
 31e:	68 b5 0b 00 00       	push   $0xbb5
 323:	6a 01                	push   $0x1
 325:	e8 b0 04 00 00       	call   7da <printf>
 32a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 334:	83 e0 04             	and    $0x4,%eax
 337:	84 c0                	test   %al,%al
 339:	74 14                	je     34f <print_mode+0x1fd>
    printf(1, "r");
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	68 bb 0b 00 00       	push   $0xbbb
 343:	6a 01                	push   $0x1
 345:	e8 90 04 00 00       	call   7da <printf>
 34a:	83 c4 10             	add    $0x10,%esp
 34d:	eb 12                	jmp    361 <print_mode+0x20f>
  else
    printf(1, "-");
 34f:	83 ec 08             	sub    $0x8,%esp
 352:	68 b5 0b 00 00       	push   $0xbb5
 357:	6a 01                	push   $0x1
 359:	e8 7c 04 00 00       	call   7da <printf>
 35e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 368:	83 e0 02             	and    $0x2,%eax
 36b:	84 c0                	test   %al,%al
 36d:	74 14                	je     383 <print_mode+0x231>
    printf(1, "w");
 36f:	83 ec 08             	sub    $0x8,%esp
 372:	68 bd 0b 00 00       	push   $0xbbd
 377:	6a 01                	push   $0x1
 379:	e8 5c 04 00 00       	call   7da <printf>
 37e:	83 c4 10             	add    $0x10,%esp
 381:	eb 12                	jmp    395 <print_mode+0x243>
  else
    printf(1, "-");
 383:	83 ec 08             	sub    $0x8,%esp
 386:	68 b5 0b 00 00       	push   $0xbb5
 38b:	6a 01                	push   $0x1
 38d:	e8 48 04 00 00       	call   7da <printf>
 392:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 39c:	83 e0 01             	and    $0x1,%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 14                	je     3b7 <print_mode+0x265>
    printf(1, "x");
 3a3:	83 ec 08             	sub    $0x8,%esp
 3a6:	68 c1 0b 00 00       	push   $0xbc1
 3ab:	6a 01                	push   $0x1
 3ad:	e8 28 04 00 00       	call   7da <printf>
 3b2:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 3b5:	eb 13                	jmp    3ca <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 3b7:	83 ec 08             	sub    $0x8,%esp
 3ba:	68 b5 0b 00 00       	push   $0xbb5
 3bf:	6a 01                	push   $0x1
 3c1:	e8 14 04 00 00       	call   7da <printf>
 3c6:	83 c4 10             	add    $0x10,%esp

  return;
 3c9:	90                   	nop
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	57                   	push   %edi
 3d0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3d4:	8b 55 10             	mov    0x10(%ebp),%edx
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	89 cb                	mov    %ecx,%ebx
 3dc:	89 df                	mov    %ebx,%edi
 3de:	89 d1                	mov    %edx,%ecx
 3e0:	fc                   	cld    
 3e1:	f3 aa                	rep stos %al,%es:(%edi)
 3e3:	89 ca                	mov    %ecx,%edx
 3e5:	89 fb                	mov    %edi,%ebx
 3e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3ea:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3ed:	90                   	nop
 3ee:	5b                   	pop    %ebx
 3ef:	5f                   	pop    %edi
 3f0:	5d                   	pop    %ebp
 3f1:	c3                   	ret    

000003f2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3fe:	90                   	nop
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	8d 50 01             	lea    0x1(%eax),%edx
 405:	89 55 08             	mov    %edx,0x8(%ebp)
 408:	8b 55 0c             	mov    0xc(%ebp),%edx
 40b:	8d 4a 01             	lea    0x1(%edx),%ecx
 40e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 411:	0f b6 12             	movzbl (%edx),%edx
 414:	88 10                	mov    %dl,(%eax)
 416:	0f b6 00             	movzbl (%eax),%eax
 419:	84 c0                	test   %al,%al
 41b:	75 e2                	jne    3ff <strcpy+0xd>
    ;
  return os;
 41d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 425:	eb 08                	jmp    42f <strcmp+0xd>
    p++, q++;
 427:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	0f b6 00             	movzbl (%eax),%eax
 435:	84 c0                	test   %al,%al
 437:	74 10                	je     449 <strcmp+0x27>
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	0f b6 10             	movzbl (%eax),%edx
 43f:	8b 45 0c             	mov    0xc(%ebp),%eax
 442:	0f b6 00             	movzbl (%eax),%eax
 445:	38 c2                	cmp    %al,%dl
 447:	74 de                	je     427 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	0f b6 00             	movzbl (%eax),%eax
 44f:	0f b6 d0             	movzbl %al,%edx
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	0f b6 00             	movzbl (%eax),%eax
 458:	0f b6 c0             	movzbl %al,%eax
 45b:	29 c2                	sub    %eax,%edx
 45d:	89 d0                	mov    %edx,%eax
}
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    

00000461 <strlen>:

uint
strlen(char *s)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 467:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 46e:	eb 04                	jmp    474 <strlen+0x13>
 470:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 474:	8b 55 fc             	mov    -0x4(%ebp),%edx
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	01 d0                	add    %edx,%eax
 47c:	0f b6 00             	movzbl (%eax),%eax
 47f:	84 c0                	test   %al,%al
 481:	75 ed                	jne    470 <strlen+0xf>
    ;
  return n;
 483:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 486:	c9                   	leave  
 487:	c3                   	ret    

00000488 <memset>:

void*
memset(void *dst, int c, uint n)
{
 488:	55                   	push   %ebp
 489:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 48b:	8b 45 10             	mov    0x10(%ebp),%eax
 48e:	50                   	push   %eax
 48f:	ff 75 0c             	pushl  0xc(%ebp)
 492:	ff 75 08             	pushl  0x8(%ebp)
 495:	e8 32 ff ff ff       	call   3cc <stosb>
 49a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a0:	c9                   	leave  
 4a1:	c3                   	ret    

000004a2 <strchr>:

char*
strchr(const char *s, char c)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 04             	sub    $0x4,%esp
 4a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ab:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4ae:	eb 14                	jmp    4c4 <strchr+0x22>
    if(*s == c)
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	0f b6 00             	movzbl (%eax),%eax
 4b6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4b9:	75 05                	jne    4c0 <strchr+0x1e>
      return (char*)s;
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	eb 13                	jmp    4d3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	0f b6 00             	movzbl (%eax),%eax
 4ca:	84 c0                	test   %al,%al
 4cc:	75 e2                	jne    4b0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 4ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4d3:	c9                   	leave  
 4d4:	c3                   	ret    

000004d5 <gets>:

char*
gets(char *buf, int max)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4e2:	eb 42                	jmp    526 <gets+0x51>
    cc = read(0, &c, 1);
 4e4:	83 ec 04             	sub    $0x4,%esp
 4e7:	6a 01                	push   $0x1
 4e9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4ec:	50                   	push   %eax
 4ed:	6a 00                	push   $0x0
 4ef:	e8 47 01 00 00       	call   63b <read>
 4f4:	83 c4 10             	add    $0x10,%esp
 4f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fe:	7e 33                	jle    533 <gets+0x5e>
      break;
    buf[i++] = c;
 500:	8b 45 f4             	mov    -0xc(%ebp),%eax
 503:	8d 50 01             	lea    0x1(%eax),%edx
 506:	89 55 f4             	mov    %edx,-0xc(%ebp)
 509:	89 c2                	mov    %eax,%edx
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	01 c2                	add    %eax,%edx
 510:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 514:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 516:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 51a:	3c 0a                	cmp    $0xa,%al
 51c:	74 16                	je     534 <gets+0x5f>
 51e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 522:	3c 0d                	cmp    $0xd,%al
 524:	74 0e                	je     534 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 526:	8b 45 f4             	mov    -0xc(%ebp),%eax
 529:	83 c0 01             	add    $0x1,%eax
 52c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 52f:	7c b3                	jl     4e4 <gets+0xf>
 531:	eb 01                	jmp    534 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 533:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 534:	8b 55 f4             	mov    -0xc(%ebp),%edx
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	01 d0                	add    %edx,%eax
 53c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 542:	c9                   	leave  
 543:	c3                   	ret    

00000544 <stat>:

int
stat(char *n, struct stat *st)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 54a:	83 ec 08             	sub    $0x8,%esp
 54d:	6a 00                	push   $0x0
 54f:	ff 75 08             	pushl  0x8(%ebp)
 552:	e8 0c 01 00 00       	call   663 <open>
 557:	83 c4 10             	add    $0x10,%esp
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 55d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 561:	79 07                	jns    56a <stat+0x26>
    return -1;
 563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 568:	eb 25                	jmp    58f <stat+0x4b>
  r = fstat(fd, st);
 56a:	83 ec 08             	sub    $0x8,%esp
 56d:	ff 75 0c             	pushl  0xc(%ebp)
 570:	ff 75 f4             	pushl  -0xc(%ebp)
 573:	e8 03 01 00 00       	call   67b <fstat>
 578:	83 c4 10             	add    $0x10,%esp
 57b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 57e:	83 ec 0c             	sub    $0xc,%esp
 581:	ff 75 f4             	pushl  -0xc(%ebp)
 584:	e8 c2 00 00 00       	call   64b <close>
 589:	83 c4 10             	add    $0x10,%esp
  return r;
 58c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 58f:	c9                   	leave  
 590:	c3                   	ret    

00000591 <atoi>:

int
atoi(const char *s)
{
 591:	55                   	push   %ebp
 592:	89 e5                	mov    %esp,%ebp
 594:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 59e:	eb 25                	jmp    5c5 <atoi+0x34>
    n = n*10 + *s++ - '0';
 5a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5a3:	89 d0                	mov    %edx,%eax
 5a5:	c1 e0 02             	shl    $0x2,%eax
 5a8:	01 d0                	add    %edx,%eax
 5aa:	01 c0                	add    %eax,%eax
 5ac:	89 c1                	mov    %eax,%ecx
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	8d 50 01             	lea    0x1(%eax),%edx
 5b4:	89 55 08             	mov    %edx,0x8(%ebp)
 5b7:	0f b6 00             	movzbl (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	01 c8                	add    %ecx,%eax
 5bf:	83 e8 30             	sub    $0x30,%eax
 5c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	3c 2f                	cmp    $0x2f,%al
 5cd:	7e 0a                	jle    5d9 <atoi+0x48>
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	0f b6 00             	movzbl (%eax),%eax
 5d5:	3c 39                	cmp    $0x39,%al
 5d7:	7e c7                	jle    5a0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 5d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5dc:	c9                   	leave  
 5dd:	c3                   	ret    

000005de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5de:	55                   	push   %ebp
 5df:	89 e5                	mov    %esp,%ebp
 5e1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5f0:	eb 17                	jmp    609 <memmove+0x2b>
    *dst++ = *src++;
 5f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f5:	8d 50 01             	lea    0x1(%eax),%edx
 5f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5fe:	8d 4a 01             	lea    0x1(%edx),%ecx
 601:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 604:	0f b6 12             	movzbl (%edx),%edx
 607:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 609:	8b 45 10             	mov    0x10(%ebp),%eax
 60c:	8d 50 ff             	lea    -0x1(%eax),%edx
 60f:	89 55 10             	mov    %edx,0x10(%ebp)
 612:	85 c0                	test   %eax,%eax
 614:	7f dc                	jg     5f2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 616:	8b 45 08             	mov    0x8(%ebp),%eax
}
 619:	c9                   	leave  
 61a:	c3                   	ret    

0000061b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 61b:	b8 01 00 00 00       	mov    $0x1,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <exit>:
SYSCALL(exit)
 623:	b8 02 00 00 00       	mov    $0x2,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <wait>:
SYSCALL(wait)
 62b:	b8 03 00 00 00       	mov    $0x3,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <pipe>:
SYSCALL(pipe)
 633:	b8 04 00 00 00       	mov    $0x4,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <read>:
SYSCALL(read)
 63b:	b8 05 00 00 00       	mov    $0x5,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <write>:
SYSCALL(write)
 643:	b8 10 00 00 00       	mov    $0x10,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <close>:
SYSCALL(close)
 64b:	b8 15 00 00 00       	mov    $0x15,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <kill>:
SYSCALL(kill)
 653:	b8 06 00 00 00       	mov    $0x6,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <exec>:
SYSCALL(exec)
 65b:	b8 07 00 00 00       	mov    $0x7,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <open>:
SYSCALL(open)
 663:	b8 0f 00 00 00       	mov    $0xf,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <mknod>:
SYSCALL(mknod)
 66b:	b8 11 00 00 00       	mov    $0x11,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <unlink>:
SYSCALL(unlink)
 673:	b8 12 00 00 00       	mov    $0x12,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <fstat>:
SYSCALL(fstat)
 67b:	b8 08 00 00 00       	mov    $0x8,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <link>:
SYSCALL(link)
 683:	b8 13 00 00 00       	mov    $0x13,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <mkdir>:
SYSCALL(mkdir)
 68b:	b8 14 00 00 00       	mov    $0x14,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <chdir>:
SYSCALL(chdir)
 693:	b8 09 00 00 00       	mov    $0x9,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <dup>:
SYSCALL(dup)
 69b:	b8 0a 00 00 00       	mov    $0xa,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <getpid>:
SYSCALL(getpid)
 6a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <sbrk>:
SYSCALL(sbrk)
 6ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <sleep>:
SYSCALL(sleep)
 6b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <uptime>:
SYSCALL(uptime)
 6bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <halt>:
SYSCALL(halt)
 6c3:	b8 16 00 00 00       	mov    $0x16,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <date>:
//Student Implementations 
SYSCALL(date)
 6cb:	b8 17 00 00 00       	mov    $0x17,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <getuid>:

SYSCALL(getuid)
 6d3:	b8 18 00 00 00       	mov    $0x18,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <getgid>:
SYSCALL(getgid)
 6db:	b8 19 00 00 00       	mov    $0x19,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <getppid>:
SYSCALL(getppid)
 6e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <setuid>:

SYSCALL(setuid)
 6eb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret    

000006f3 <setgid>:
SYSCALL(setgid)
 6f3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret    

000006fb <getprocs>:
SYSCALL(getprocs)
 6fb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret    

00000703 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 703:	55                   	push   %ebp
 704:	89 e5                	mov    %esp,%ebp
 706:	83 ec 18             	sub    $0x18,%esp
 709:	8b 45 0c             	mov    0xc(%ebp),%eax
 70c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 70f:	83 ec 04             	sub    $0x4,%esp
 712:	6a 01                	push   $0x1
 714:	8d 45 f4             	lea    -0xc(%ebp),%eax
 717:	50                   	push   %eax
 718:	ff 75 08             	pushl  0x8(%ebp)
 71b:	e8 23 ff ff ff       	call   643 <write>
 720:	83 c4 10             	add    $0x10,%esp
}
 723:	90                   	nop
 724:	c9                   	leave  
 725:	c3                   	ret    

00000726 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 726:	55                   	push   %ebp
 727:	89 e5                	mov    %esp,%ebp
 729:	53                   	push   %ebx
 72a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 72d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 734:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 738:	74 17                	je     751 <printint+0x2b>
 73a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 73e:	79 11                	jns    751 <printint+0x2b>
    neg = 1;
 740:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 747:	8b 45 0c             	mov    0xc(%ebp),%eax
 74a:	f7 d8                	neg    %eax
 74c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 74f:	eb 06                	jmp    757 <printint+0x31>
  } else {
    x = xx;
 751:	8b 45 0c             	mov    0xc(%ebp),%eax
 754:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 75e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 761:	8d 41 01             	lea    0x1(%ecx),%eax
 764:	89 45 f4             	mov    %eax,-0xc(%ebp)
 767:	8b 5d 10             	mov    0x10(%ebp),%ebx
 76a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 76d:	ba 00 00 00 00       	mov    $0x0,%edx
 772:	f7 f3                	div    %ebx
 774:	89 d0                	mov    %edx,%eax
 776:	0f b6 80 34 0e 00 00 	movzbl 0xe34(%eax),%eax
 77d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 781:	8b 5d 10             	mov    0x10(%ebp),%ebx
 784:	8b 45 ec             	mov    -0x14(%ebp),%eax
 787:	ba 00 00 00 00       	mov    $0x0,%edx
 78c:	f7 f3                	div    %ebx
 78e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 791:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 795:	75 c7                	jne    75e <printint+0x38>
  if(neg)
 797:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 79b:	74 2d                	je     7ca <printint+0xa4>
    buf[i++] = '-';
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	8d 50 01             	lea    0x1(%eax),%edx
 7a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7a6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7ab:	eb 1d                	jmp    7ca <printint+0xa4>
    putc(fd, buf[i]);
 7ad:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	01 d0                	add    %edx,%eax
 7b5:	0f b6 00             	movzbl (%eax),%eax
 7b8:	0f be c0             	movsbl %al,%eax
 7bb:	83 ec 08             	sub    $0x8,%esp
 7be:	50                   	push   %eax
 7bf:	ff 75 08             	pushl  0x8(%ebp)
 7c2:	e8 3c ff ff ff       	call   703 <putc>
 7c7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d2:	79 d9                	jns    7ad <printint+0x87>
    putc(fd, buf[i]);
}
 7d4:	90                   	nop
 7d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7d8:	c9                   	leave  
 7d9:	c3                   	ret    

000007da <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7da:	55                   	push   %ebp
 7db:	89 e5                	mov    %esp,%ebp
 7dd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7e7:	8d 45 0c             	lea    0xc(%ebp),%eax
 7ea:	83 c0 04             	add    $0x4,%eax
 7ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7f7:	e9 59 01 00 00       	jmp    955 <printf+0x17b>
    c = fmt[i] & 0xff;
 7fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	01 d0                	add    %edx,%eax
 804:	0f b6 00             	movzbl (%eax),%eax
 807:	0f be c0             	movsbl %al,%eax
 80a:	25 ff 00 00 00       	and    $0xff,%eax
 80f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 812:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 816:	75 2c                	jne    844 <printf+0x6a>
      if(c == '%'){
 818:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 81c:	75 0c                	jne    82a <printf+0x50>
        state = '%';
 81e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 825:	e9 27 01 00 00       	jmp    951 <printf+0x177>
      } else {
        putc(fd, c);
 82a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 82d:	0f be c0             	movsbl %al,%eax
 830:	83 ec 08             	sub    $0x8,%esp
 833:	50                   	push   %eax
 834:	ff 75 08             	pushl  0x8(%ebp)
 837:	e8 c7 fe ff ff       	call   703 <putc>
 83c:	83 c4 10             	add    $0x10,%esp
 83f:	e9 0d 01 00 00       	jmp    951 <printf+0x177>
      }
    } else if(state == '%'){
 844:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 848:	0f 85 03 01 00 00    	jne    951 <printf+0x177>
      if(c == 'd'){
 84e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 852:	75 1e                	jne    872 <printf+0x98>
        printint(fd, *ap, 10, 1);
 854:	8b 45 e8             	mov    -0x18(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	6a 01                	push   $0x1
 85b:	6a 0a                	push   $0xa
 85d:	50                   	push   %eax
 85e:	ff 75 08             	pushl  0x8(%ebp)
 861:	e8 c0 fe ff ff       	call   726 <printint>
 866:	83 c4 10             	add    $0x10,%esp
        ap++;
 869:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 86d:	e9 d8 00 00 00       	jmp    94a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 872:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 876:	74 06                	je     87e <printf+0xa4>
 878:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 87c:	75 1e                	jne    89c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 87e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 881:	8b 00                	mov    (%eax),%eax
 883:	6a 00                	push   $0x0
 885:	6a 10                	push   $0x10
 887:	50                   	push   %eax
 888:	ff 75 08             	pushl  0x8(%ebp)
 88b:	e8 96 fe ff ff       	call   726 <printint>
 890:	83 c4 10             	add    $0x10,%esp
        ap++;
 893:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 897:	e9 ae 00 00 00       	jmp    94a <printf+0x170>
      } else if(c == 's'){
 89c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8a0:	75 43                	jne    8e5 <printf+0x10b>
        s = (char*)*ap;
 8a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a5:	8b 00                	mov    (%eax),%eax
 8a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b2:	75 25                	jne    8d9 <printf+0xff>
          s = "(null)";
 8b4:	c7 45 f4 c3 0b 00 00 	movl   $0xbc3,-0xc(%ebp)
        while(*s != 0){
 8bb:	eb 1c                	jmp    8d9 <printf+0xff>
          putc(fd, *s);
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	0f b6 00             	movzbl (%eax),%eax
 8c3:	0f be c0             	movsbl %al,%eax
 8c6:	83 ec 08             	sub    $0x8,%esp
 8c9:	50                   	push   %eax
 8ca:	ff 75 08             	pushl  0x8(%ebp)
 8cd:	e8 31 fe ff ff       	call   703 <putc>
 8d2:	83 c4 10             	add    $0x10,%esp
          s++;
 8d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	0f b6 00             	movzbl (%eax),%eax
 8df:	84 c0                	test   %al,%al
 8e1:	75 da                	jne    8bd <printf+0xe3>
 8e3:	eb 65                	jmp    94a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8e5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8e9:	75 1d                	jne    908 <printf+0x12e>
        putc(fd, *ap);
 8eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	0f be c0             	movsbl %al,%eax
 8f3:	83 ec 08             	sub    $0x8,%esp
 8f6:	50                   	push   %eax
 8f7:	ff 75 08             	pushl  0x8(%ebp)
 8fa:	e8 04 fe ff ff       	call   703 <putc>
 8ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 902:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 906:	eb 42                	jmp    94a <printf+0x170>
      } else if(c == '%'){
 908:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 90c:	75 17                	jne    925 <printf+0x14b>
        putc(fd, c);
 90e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 911:	0f be c0             	movsbl %al,%eax
 914:	83 ec 08             	sub    $0x8,%esp
 917:	50                   	push   %eax
 918:	ff 75 08             	pushl  0x8(%ebp)
 91b:	e8 e3 fd ff ff       	call   703 <putc>
 920:	83 c4 10             	add    $0x10,%esp
 923:	eb 25                	jmp    94a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 925:	83 ec 08             	sub    $0x8,%esp
 928:	6a 25                	push   $0x25
 92a:	ff 75 08             	pushl  0x8(%ebp)
 92d:	e8 d1 fd ff ff       	call   703 <putc>
 932:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 938:	0f be c0             	movsbl %al,%eax
 93b:	83 ec 08             	sub    $0x8,%esp
 93e:	50                   	push   %eax
 93f:	ff 75 08             	pushl  0x8(%ebp)
 942:	e8 bc fd ff ff       	call   703 <putc>
 947:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 94a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 951:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 955:	8b 55 0c             	mov    0xc(%ebp),%edx
 958:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95b:	01 d0                	add    %edx,%eax
 95d:	0f b6 00             	movzbl (%eax),%eax
 960:	84 c0                	test   %al,%al
 962:	0f 85 94 fe ff ff    	jne    7fc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 968:	90                   	nop
 969:	c9                   	leave  
 96a:	c3                   	ret    

0000096b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96b:	55                   	push   %ebp
 96c:	89 e5                	mov    %esp,%ebp
 96e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 971:	8b 45 08             	mov    0x8(%ebp),%eax
 974:	83 e8 08             	sub    $0x8,%eax
 977:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97a:	a1 50 0e 00 00       	mov    0xe50,%eax
 97f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 982:	eb 24                	jmp    9a8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	8b 00                	mov    (%eax),%eax
 989:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 98c:	77 12                	ja     9a0 <free+0x35>
 98e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 991:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 994:	77 24                	ja     9ba <free+0x4f>
 996:	8b 45 fc             	mov    -0x4(%ebp),%eax
 999:	8b 00                	mov    (%eax),%eax
 99b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 99e:	77 1a                	ja     9ba <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a3:	8b 00                	mov    (%eax),%eax
 9a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9ae:	76 d4                	jbe    984 <free+0x19>
 9b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b3:	8b 00                	mov    (%eax),%eax
 9b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b8:	76 ca                	jbe    984 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bd:	8b 40 04             	mov    0x4(%eax),%eax
 9c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ca:	01 c2                	add    %eax,%edx
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	8b 00                	mov    (%eax),%eax
 9d1:	39 c2                	cmp    %eax,%edx
 9d3:	75 24                	jne    9f9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d8:	8b 50 04             	mov    0x4(%eax),%edx
 9db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9de:	8b 00                	mov    (%eax),%eax
 9e0:	8b 40 04             	mov    0x4(%eax),%eax
 9e3:	01 c2                	add    %eax,%edx
 9e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ee:	8b 00                	mov    (%eax),%eax
 9f0:	8b 10                	mov    (%eax),%edx
 9f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f5:	89 10                	mov    %edx,(%eax)
 9f7:	eb 0a                	jmp    a03 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fc:	8b 10                	mov    (%eax),%edx
 9fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a01:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a06:	8b 40 04             	mov    0x4(%eax),%eax
 a09:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a13:	01 d0                	add    %edx,%eax
 a15:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a18:	75 20                	jne    a3a <free+0xcf>
    p->s.size += bp->s.size;
 a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1d:	8b 50 04             	mov    0x4(%eax),%edx
 a20:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a23:	8b 40 04             	mov    0x4(%eax),%eax
 a26:	01 c2                	add    %eax,%edx
 a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a31:	8b 10                	mov    (%eax),%edx
 a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a36:	89 10                	mov    %edx,(%eax)
 a38:	eb 08                	jmp    a42 <free+0xd7>
  } else
    p->s.ptr = bp;
 a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a40:	89 10                	mov    %edx,(%eax)
  freep = p;
 a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a45:	a3 50 0e 00 00       	mov    %eax,0xe50
}
 a4a:	90                   	nop
 a4b:	c9                   	leave  
 a4c:	c3                   	ret    

00000a4d <morecore>:

static Header*
morecore(uint nu)
{
 a4d:	55                   	push   %ebp
 a4e:	89 e5                	mov    %esp,%ebp
 a50:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a53:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a5a:	77 07                	ja     a63 <morecore+0x16>
    nu = 4096;
 a5c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a63:	8b 45 08             	mov    0x8(%ebp),%eax
 a66:	c1 e0 03             	shl    $0x3,%eax
 a69:	83 ec 0c             	sub    $0xc,%esp
 a6c:	50                   	push   %eax
 a6d:	e8 39 fc ff ff       	call   6ab <sbrk>
 a72:	83 c4 10             	add    $0x10,%esp
 a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a78:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a7c:	75 07                	jne    a85 <morecore+0x38>
    return 0;
 a7e:	b8 00 00 00 00       	mov    $0x0,%eax
 a83:	eb 26                	jmp    aab <morecore+0x5e>
  hp = (Header*)p;
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8e:	8b 55 08             	mov    0x8(%ebp),%edx
 a91:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a97:	83 c0 08             	add    $0x8,%eax
 a9a:	83 ec 0c             	sub    $0xc,%esp
 a9d:	50                   	push   %eax
 a9e:	e8 c8 fe ff ff       	call   96b <free>
 aa3:	83 c4 10             	add    $0x10,%esp
  return freep;
 aa6:	a1 50 0e 00 00       	mov    0xe50,%eax
}
 aab:	c9                   	leave  
 aac:	c3                   	ret    

00000aad <malloc>:

void*
malloc(uint nbytes)
{
 aad:	55                   	push   %ebp
 aae:	89 e5                	mov    %esp,%ebp
 ab0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab3:	8b 45 08             	mov    0x8(%ebp),%eax
 ab6:	83 c0 07             	add    $0x7,%eax
 ab9:	c1 e8 03             	shr    $0x3,%eax
 abc:	83 c0 01             	add    $0x1,%eax
 abf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ac2:	a1 50 0e 00 00       	mov    0xe50,%eax
 ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ace:	75 23                	jne    af3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 ad0:	c7 45 f0 48 0e 00 00 	movl   $0xe48,-0x10(%ebp)
 ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ada:	a3 50 0e 00 00       	mov    %eax,0xe50
 adf:	a1 50 0e 00 00       	mov    0xe50,%eax
 ae4:	a3 48 0e 00 00       	mov    %eax,0xe48
    base.s.size = 0;
 ae9:	c7 05 4c 0e 00 00 00 	movl   $0x0,0xe4c
 af0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af6:	8b 00                	mov    (%eax),%eax
 af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afe:	8b 40 04             	mov    0x4(%eax),%eax
 b01:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b04:	72 4d                	jb     b53 <malloc+0xa6>
      if(p->s.size == nunits)
 b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b09:	8b 40 04             	mov    0x4(%eax),%eax
 b0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b0f:	75 0c                	jne    b1d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b14:	8b 10                	mov    (%eax),%edx
 b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b19:	89 10                	mov    %edx,(%eax)
 b1b:	eb 26                	jmp    b43 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b20:	8b 40 04             	mov    0x4(%eax),%eax
 b23:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b26:	89 c2                	mov    %eax,%edx
 b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b31:	8b 40 04             	mov    0x4(%eax),%eax
 b34:	c1 e0 03             	shl    $0x3,%eax
 b37:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b40:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b46:	a3 50 0e 00 00       	mov    %eax,0xe50
      return (void*)(p + 1);
 b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4e:	83 c0 08             	add    $0x8,%eax
 b51:	eb 3b                	jmp    b8e <malloc+0xe1>
    }
    if(p == freep)
 b53:	a1 50 0e 00 00       	mov    0xe50,%eax
 b58:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b5b:	75 1e                	jne    b7b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b5d:	83 ec 0c             	sub    $0xc,%esp
 b60:	ff 75 ec             	pushl  -0x14(%ebp)
 b63:	e8 e5 fe ff ff       	call   a4d <morecore>
 b68:	83 c4 10             	add    $0x10,%esp
 b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b72:	75 07                	jne    b7b <malloc+0xce>
        return 0;
 b74:	b8 00 00 00 00       	mov    $0x0,%eax
 b79:	eb 13                	jmp    b8e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b84:	8b 00                	mov    (%eax),%eax
 b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b89:	e9 6d ff ff ff       	jmp    afb <malloc+0x4e>
}
 b8e:	c9                   	leave  
 b8f:	c3                   	ret    
