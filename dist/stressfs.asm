
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
  2b:	68 a8 0b 00 00       	push   $0xba8
  30:	6a 01                	push   $0x1
  32:	e8 bb 07 00 00       	call   7f2 <printf>
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
  78:	68 bb 0b 00 00       	push   $0xbbb
  7d:	6a 01                	push   $0x1
  7f:	e8 6e 07 00 00       	call   7f2 <printf>
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
  ea:	68 c5 0b 00 00       	push   $0xbc5
  ef:	6a 01                	push   $0x1
  f1:	e8 fc 06 00 00       	call   7f2 <printf>
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
 171:	68 cb 0b 00 00       	push   $0xbcb
 176:	6a 01                	push   $0x1
 178:	e8 75 06 00 00       	call   7f2 <printf>
 17d:	83 c4 10             	add    $0x10,%esp
 180:	eb 3a                	jmp    1bc <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 182:	83 ec 08             	sub    $0x8,%esp
 185:	68 cd 0b 00 00       	push   $0xbcd
 18a:	6a 01                	push   $0x1
 18c:	e8 61 06 00 00       	call   7f2 <printf>
 191:	83 c4 10             	add    $0x10,%esp
 194:	eb 26                	jmp    1bc <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 196:	83 ec 08             	sub    $0x8,%esp
 199:	68 cf 0b 00 00       	push   $0xbcf
 19e:	6a 01                	push   $0x1
 1a0:	e8 4d 06 00 00       	call   7f2 <printf>
 1a5:	83 c4 10             	add    $0x10,%esp
 1a8:	eb 12                	jmp    1bc <print_mode+0x6a>
    default: printf(1, "?");
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	68 d1 0b 00 00       	push   $0xbd1
 1b2:	6a 01                	push   $0x1
 1b4:	e8 39 06 00 00       	call   7f2 <printf>
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
 1cd:	68 d3 0b 00 00       	push   $0xbd3
 1d2:	6a 01                	push   $0x1
 1d4:	e8 19 06 00 00       	call   7f2 <printf>
 1d9:	83 c4 10             	add    $0x10,%esp
 1dc:	eb 12                	jmp    1f0 <print_mode+0x9e>
  else
    printf(1, "-");
 1de:	83 ec 08             	sub    $0x8,%esp
 1e1:	68 cd 0b 00 00       	push   $0xbcd
 1e6:	6a 01                	push   $0x1
 1e8:	e8 05 06 00 00       	call   7f2 <printf>
 1ed:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 1f7:	83 e0 80             	and    $0xffffff80,%eax
 1fa:	84 c0                	test   %al,%al
 1fc:	74 14                	je     212 <print_mode+0xc0>
    printf(1, "w");
 1fe:	83 ec 08             	sub    $0x8,%esp
 201:	68 d5 0b 00 00       	push   $0xbd5
 206:	6a 01                	push   $0x1
 208:	e8 e5 05 00 00       	call   7f2 <printf>
 20d:	83 c4 10             	add    $0x10,%esp
 210:	eb 12                	jmp    224 <print_mode+0xd2>
  else
    printf(1, "-");
 212:	83 ec 08             	sub    $0x8,%esp
 215:	68 cd 0b 00 00       	push   $0xbcd
 21a:	6a 01                	push   $0x1
 21c:	e8 d1 05 00 00       	call   7f2 <printf>
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
 24c:	68 d7 0b 00 00       	push   $0xbd7
 251:	6a 01                	push   $0x1
 253:	e8 9a 05 00 00       	call   7f2 <printf>
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
 26e:	68 d9 0b 00 00       	push   $0xbd9
 273:	6a 01                	push   $0x1
 275:	e8 78 05 00 00       	call   7f2 <printf>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	eb 12                	jmp    291 <print_mode+0x13f>
  else
    printf(1, "-");
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	68 cd 0b 00 00       	push   $0xbcd
 287:	6a 01                	push   $0x1
 289:	e8 64 05 00 00       	call   7f2 <printf>
 28e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 298:	83 e0 20             	and    $0x20,%eax
 29b:	84 c0                	test   %al,%al
 29d:	74 14                	je     2b3 <print_mode+0x161>
    printf(1, "r");
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	68 d3 0b 00 00       	push   $0xbd3
 2a7:	6a 01                	push   $0x1
 2a9:	e8 44 05 00 00       	call   7f2 <printf>
 2ae:	83 c4 10             	add    $0x10,%esp
 2b1:	eb 12                	jmp    2c5 <print_mode+0x173>
  else
    printf(1, "-");
 2b3:	83 ec 08             	sub    $0x8,%esp
 2b6:	68 cd 0b 00 00       	push   $0xbcd
 2bb:	6a 01                	push   $0x1
 2bd:	e8 30 05 00 00       	call   7f2 <printf>
 2c2:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 2cc:	83 e0 10             	and    $0x10,%eax
 2cf:	84 c0                	test   %al,%al
 2d1:	74 14                	je     2e7 <print_mode+0x195>
    printf(1, "w");
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	68 d5 0b 00 00       	push   $0xbd5
 2db:	6a 01                	push   $0x1
 2dd:	e8 10 05 00 00       	call   7f2 <printf>
 2e2:	83 c4 10             	add    $0x10,%esp
 2e5:	eb 12                	jmp    2f9 <print_mode+0x1a7>
  else
    printf(1, "-");
 2e7:	83 ec 08             	sub    $0x8,%esp
 2ea:	68 cd 0b 00 00       	push   $0xbcd
 2ef:	6a 01                	push   $0x1
 2f1:	e8 fc 04 00 00       	call   7f2 <printf>
 2f6:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 300:	83 e0 08             	and    $0x8,%eax
 303:	84 c0                	test   %al,%al
 305:	74 14                	je     31b <print_mode+0x1c9>
    printf(1, "x");
 307:	83 ec 08             	sub    $0x8,%esp
 30a:	68 d9 0b 00 00       	push   $0xbd9
 30f:	6a 01                	push   $0x1
 311:	e8 dc 04 00 00       	call   7f2 <printf>
 316:	83 c4 10             	add    $0x10,%esp
 319:	eb 12                	jmp    32d <print_mode+0x1db>
  else
    printf(1, "-");
 31b:	83 ec 08             	sub    $0x8,%esp
 31e:	68 cd 0b 00 00       	push   $0xbcd
 323:	6a 01                	push   $0x1
 325:	e8 c8 04 00 00       	call   7f2 <printf>
 32a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 334:	83 e0 04             	and    $0x4,%eax
 337:	84 c0                	test   %al,%al
 339:	74 14                	je     34f <print_mode+0x1fd>
    printf(1, "r");
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	68 d3 0b 00 00       	push   $0xbd3
 343:	6a 01                	push   $0x1
 345:	e8 a8 04 00 00       	call   7f2 <printf>
 34a:	83 c4 10             	add    $0x10,%esp
 34d:	eb 12                	jmp    361 <print_mode+0x20f>
  else
    printf(1, "-");
 34f:	83 ec 08             	sub    $0x8,%esp
 352:	68 cd 0b 00 00       	push   $0xbcd
 357:	6a 01                	push   $0x1
 359:	e8 94 04 00 00       	call   7f2 <printf>
 35e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 368:	83 e0 02             	and    $0x2,%eax
 36b:	84 c0                	test   %al,%al
 36d:	74 14                	je     383 <print_mode+0x231>
    printf(1, "w");
 36f:	83 ec 08             	sub    $0x8,%esp
 372:	68 d5 0b 00 00       	push   $0xbd5
 377:	6a 01                	push   $0x1
 379:	e8 74 04 00 00       	call   7f2 <printf>
 37e:	83 c4 10             	add    $0x10,%esp
 381:	eb 12                	jmp    395 <print_mode+0x243>
  else
    printf(1, "-");
 383:	83 ec 08             	sub    $0x8,%esp
 386:	68 cd 0b 00 00       	push   $0xbcd
 38b:	6a 01                	push   $0x1
 38d:	e8 60 04 00 00       	call   7f2 <printf>
 392:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 39c:	83 e0 01             	and    $0x1,%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 14                	je     3b7 <print_mode+0x265>
    printf(1, "x");
 3a3:	83 ec 08             	sub    $0x8,%esp
 3a6:	68 d9 0b 00 00       	push   $0xbd9
 3ab:	6a 01                	push   $0x1
 3ad:	e8 40 04 00 00       	call   7f2 <printf>
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
 3ba:	68 cd 0b 00 00       	push   $0xbcd
 3bf:	6a 01                	push   $0x1
 3c1:	e8 2c 04 00 00       	call   7f2 <printf>
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

00000703 <chown>:

SYSCALL(chown)
 703:	b8 1e 00 00 00       	mov    $0x1e,%eax
 708:	cd 40                	int    $0x40
 70a:	c3                   	ret    

0000070b <chgrp>:
SYSCALL(chgrp)
 70b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret    

00000713 <chmod>:
SYSCALL(chmod)
 713:	b8 20 00 00 00       	mov    $0x20,%eax
 718:	cd 40                	int    $0x40
 71a:	c3                   	ret    

0000071b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 71b:	55                   	push   %ebp
 71c:	89 e5                	mov    %esp,%ebp
 71e:	83 ec 18             	sub    $0x18,%esp
 721:	8b 45 0c             	mov    0xc(%ebp),%eax
 724:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 727:	83 ec 04             	sub    $0x4,%esp
 72a:	6a 01                	push   $0x1
 72c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 72f:	50                   	push   %eax
 730:	ff 75 08             	pushl  0x8(%ebp)
 733:	e8 0b ff ff ff       	call   643 <write>
 738:	83 c4 10             	add    $0x10,%esp
}
 73b:	90                   	nop
 73c:	c9                   	leave  
 73d:	c3                   	ret    

0000073e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 73e:	55                   	push   %ebp
 73f:	89 e5                	mov    %esp,%ebp
 741:	53                   	push   %ebx
 742:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 745:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 74c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 750:	74 17                	je     769 <printint+0x2b>
 752:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 756:	79 11                	jns    769 <printint+0x2b>
    neg = 1;
 758:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 75f:	8b 45 0c             	mov    0xc(%ebp),%eax
 762:	f7 d8                	neg    %eax
 764:	89 45 ec             	mov    %eax,-0x14(%ebp)
 767:	eb 06                	jmp    76f <printint+0x31>
  } else {
    x = xx;
 769:	8b 45 0c             	mov    0xc(%ebp),%eax
 76c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 76f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 776:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 779:	8d 41 01             	lea    0x1(%ecx),%eax
 77c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 77f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 782:	8b 45 ec             	mov    -0x14(%ebp),%eax
 785:	ba 00 00 00 00       	mov    $0x0,%edx
 78a:	f7 f3                	div    %ebx
 78c:	89 d0                	mov    %edx,%eax
 78e:	0f b6 80 4c 0e 00 00 	movzbl 0xe4c(%eax),%eax
 795:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 799:	8b 5d 10             	mov    0x10(%ebp),%ebx
 79c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79f:	ba 00 00 00 00       	mov    $0x0,%edx
 7a4:	f7 f3                	div    %ebx
 7a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ad:	75 c7                	jne    776 <printint+0x38>
  if(neg)
 7af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b3:	74 2d                	je     7e2 <printint+0xa4>
    buf[i++] = '-';
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8d 50 01             	lea    0x1(%eax),%edx
 7bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7be:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7c3:	eb 1d                	jmp    7e2 <printint+0xa4>
    putc(fd, buf[i]);
 7c5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	01 d0                	add    %edx,%eax
 7cd:	0f b6 00             	movzbl (%eax),%eax
 7d0:	0f be c0             	movsbl %al,%eax
 7d3:	83 ec 08             	sub    $0x8,%esp
 7d6:	50                   	push   %eax
 7d7:	ff 75 08             	pushl  0x8(%ebp)
 7da:	e8 3c ff ff ff       	call   71b <putc>
 7df:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ea:	79 d9                	jns    7c5 <printint+0x87>
    putc(fd, buf[i]);
}
 7ec:	90                   	nop
 7ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    

000007f2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7f2:	55                   	push   %ebp
 7f3:	89 e5                	mov    %esp,%ebp
 7f5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7ff:	8d 45 0c             	lea    0xc(%ebp),%eax
 802:	83 c0 04             	add    $0x4,%eax
 805:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80f:	e9 59 01 00 00       	jmp    96d <printf+0x17b>
    c = fmt[i] & 0xff;
 814:	8b 55 0c             	mov    0xc(%ebp),%edx
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	01 d0                	add    %edx,%eax
 81c:	0f b6 00             	movzbl (%eax),%eax
 81f:	0f be c0             	movsbl %al,%eax
 822:	25 ff 00 00 00       	and    $0xff,%eax
 827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 82a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 82e:	75 2c                	jne    85c <printf+0x6a>
      if(c == '%'){
 830:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 834:	75 0c                	jne    842 <printf+0x50>
        state = '%';
 836:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 83d:	e9 27 01 00 00       	jmp    969 <printf+0x177>
      } else {
        putc(fd, c);
 842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 845:	0f be c0             	movsbl %al,%eax
 848:	83 ec 08             	sub    $0x8,%esp
 84b:	50                   	push   %eax
 84c:	ff 75 08             	pushl  0x8(%ebp)
 84f:	e8 c7 fe ff ff       	call   71b <putc>
 854:	83 c4 10             	add    $0x10,%esp
 857:	e9 0d 01 00 00       	jmp    969 <printf+0x177>
      }
    } else if(state == '%'){
 85c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 860:	0f 85 03 01 00 00    	jne    969 <printf+0x177>
      if(c == 'd'){
 866:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 86a:	75 1e                	jne    88a <printf+0x98>
        printint(fd, *ap, 10, 1);
 86c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	6a 01                	push   $0x1
 873:	6a 0a                	push   $0xa
 875:	50                   	push   %eax
 876:	ff 75 08             	pushl  0x8(%ebp)
 879:	e8 c0 fe ff ff       	call   73e <printint>
 87e:	83 c4 10             	add    $0x10,%esp
        ap++;
 881:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 885:	e9 d8 00 00 00       	jmp    962 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 88a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 88e:	74 06                	je     896 <printf+0xa4>
 890:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 894:	75 1e                	jne    8b4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 896:	8b 45 e8             	mov    -0x18(%ebp),%eax
 899:	8b 00                	mov    (%eax),%eax
 89b:	6a 00                	push   $0x0
 89d:	6a 10                	push   $0x10
 89f:	50                   	push   %eax
 8a0:	ff 75 08             	pushl  0x8(%ebp)
 8a3:	e8 96 fe ff ff       	call   73e <printint>
 8a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 8ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8af:	e9 ae 00 00 00       	jmp    962 <printf+0x170>
      } else if(c == 's'){
 8b4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8b8:	75 43                	jne    8fd <printf+0x10b>
        s = (char*)*ap;
 8ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ca:	75 25                	jne    8f1 <printf+0xff>
          s = "(null)";
 8cc:	c7 45 f4 db 0b 00 00 	movl   $0xbdb,-0xc(%ebp)
        while(*s != 0){
 8d3:	eb 1c                	jmp    8f1 <printf+0xff>
          putc(fd, *s);
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	0f b6 00             	movzbl (%eax),%eax
 8db:	0f be c0             	movsbl %al,%eax
 8de:	83 ec 08             	sub    $0x8,%esp
 8e1:	50                   	push   %eax
 8e2:	ff 75 08             	pushl  0x8(%ebp)
 8e5:	e8 31 fe ff ff       	call   71b <putc>
 8ea:	83 c4 10             	add    $0x10,%esp
          s++;
 8ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	0f b6 00             	movzbl (%eax),%eax
 8f7:	84 c0                	test   %al,%al
 8f9:	75 da                	jne    8d5 <printf+0xe3>
 8fb:	eb 65                	jmp    962 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 901:	75 1d                	jne    920 <printf+0x12e>
        putc(fd, *ap);
 903:	8b 45 e8             	mov    -0x18(%ebp),%eax
 906:	8b 00                	mov    (%eax),%eax
 908:	0f be c0             	movsbl %al,%eax
 90b:	83 ec 08             	sub    $0x8,%esp
 90e:	50                   	push   %eax
 90f:	ff 75 08             	pushl  0x8(%ebp)
 912:	e8 04 fe ff ff       	call   71b <putc>
 917:	83 c4 10             	add    $0x10,%esp
        ap++;
 91a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 91e:	eb 42                	jmp    962 <printf+0x170>
      } else if(c == '%'){
 920:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 924:	75 17                	jne    93d <printf+0x14b>
        putc(fd, c);
 926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 929:	0f be c0             	movsbl %al,%eax
 92c:	83 ec 08             	sub    $0x8,%esp
 92f:	50                   	push   %eax
 930:	ff 75 08             	pushl  0x8(%ebp)
 933:	e8 e3 fd ff ff       	call   71b <putc>
 938:	83 c4 10             	add    $0x10,%esp
 93b:	eb 25                	jmp    962 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 93d:	83 ec 08             	sub    $0x8,%esp
 940:	6a 25                	push   $0x25
 942:	ff 75 08             	pushl  0x8(%ebp)
 945:	e8 d1 fd ff ff       	call   71b <putc>
 94a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 94d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 950:	0f be c0             	movsbl %al,%eax
 953:	83 ec 08             	sub    $0x8,%esp
 956:	50                   	push   %eax
 957:	ff 75 08             	pushl  0x8(%ebp)
 95a:	e8 bc fd ff ff       	call   71b <putc>
 95f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 962:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 969:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 96d:	8b 55 0c             	mov    0xc(%ebp),%edx
 970:	8b 45 f0             	mov    -0x10(%ebp),%eax
 973:	01 d0                	add    %edx,%eax
 975:	0f b6 00             	movzbl (%eax),%eax
 978:	84 c0                	test   %al,%al
 97a:	0f 85 94 fe ff ff    	jne    814 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 980:	90                   	nop
 981:	c9                   	leave  
 982:	c3                   	ret    

00000983 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 983:	55                   	push   %ebp
 984:	89 e5                	mov    %esp,%ebp
 986:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 989:	8b 45 08             	mov    0x8(%ebp),%eax
 98c:	83 e8 08             	sub    $0x8,%eax
 98f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 992:	a1 68 0e 00 00       	mov    0xe68,%eax
 997:	89 45 fc             	mov    %eax,-0x4(%ebp)
 99a:	eb 24                	jmp    9c0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9a4:	77 12                	ja     9b8 <free+0x35>
 9a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9ac:	77 24                	ja     9d2 <free+0x4f>
 9ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b1:	8b 00                	mov    (%eax),%eax
 9b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b6:	77 1a                	ja     9d2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bb:	8b 00                	mov    (%eax),%eax
 9bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c6:	76 d4                	jbe    99c <free+0x19>
 9c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cb:	8b 00                	mov    (%eax),%eax
 9cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d0:	76 ca                	jbe    99c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e2:	01 c2                	add    %eax,%edx
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	8b 00                	mov    (%eax),%eax
 9e9:	39 c2                	cmp    %eax,%edx
 9eb:	75 24                	jne    a11 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f0:	8b 50 04             	mov    0x4(%eax),%edx
 9f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f6:	8b 00                	mov    (%eax),%eax
 9f8:	8b 40 04             	mov    0x4(%eax),%eax
 9fb:	01 c2                	add    %eax,%edx
 9fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a00:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a06:	8b 00                	mov    (%eax),%eax
 a08:	8b 10                	mov    (%eax),%edx
 a0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0d:	89 10                	mov    %edx,(%eax)
 a0f:	eb 0a                	jmp    a1b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a14:	8b 10                	mov    (%eax),%edx
 a16:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a19:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1e:	8b 40 04             	mov    0x4(%eax),%eax
 a21:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2b:	01 d0                	add    %edx,%eax
 a2d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a30:	75 20                	jne    a52 <free+0xcf>
    p->s.size += bp->s.size;
 a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a35:	8b 50 04             	mov    0x4(%eax),%edx
 a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3b:	8b 40 04             	mov    0x4(%eax),%eax
 a3e:	01 c2                	add    %eax,%edx
 a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a43:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a49:	8b 10                	mov    (%eax),%edx
 a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4e:	89 10                	mov    %edx,(%eax)
 a50:	eb 08                	jmp    a5a <free+0xd7>
  } else
    p->s.ptr = bp;
 a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a55:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a58:	89 10                	mov    %edx,(%eax)
  freep = p;
 a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5d:	a3 68 0e 00 00       	mov    %eax,0xe68
}
 a62:	90                   	nop
 a63:	c9                   	leave  
 a64:	c3                   	ret    

00000a65 <morecore>:

static Header*
morecore(uint nu)
{
 a65:	55                   	push   %ebp
 a66:	89 e5                	mov    %esp,%ebp
 a68:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a6b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a72:	77 07                	ja     a7b <morecore+0x16>
    nu = 4096;
 a74:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a7b:	8b 45 08             	mov    0x8(%ebp),%eax
 a7e:	c1 e0 03             	shl    $0x3,%eax
 a81:	83 ec 0c             	sub    $0xc,%esp
 a84:	50                   	push   %eax
 a85:	e8 21 fc ff ff       	call   6ab <sbrk>
 a8a:	83 c4 10             	add    $0x10,%esp
 a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a90:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a94:	75 07                	jne    a9d <morecore+0x38>
    return 0;
 a96:	b8 00 00 00 00       	mov    $0x0,%eax
 a9b:	eb 26                	jmp    ac3 <morecore+0x5e>
  hp = (Header*)p;
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa6:	8b 55 08             	mov    0x8(%ebp),%edx
 aa9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaf:	83 c0 08             	add    $0x8,%eax
 ab2:	83 ec 0c             	sub    $0xc,%esp
 ab5:	50                   	push   %eax
 ab6:	e8 c8 fe ff ff       	call   983 <free>
 abb:	83 c4 10             	add    $0x10,%esp
  return freep;
 abe:	a1 68 0e 00 00       	mov    0xe68,%eax
}
 ac3:	c9                   	leave  
 ac4:	c3                   	ret    

00000ac5 <malloc>:

void*
malloc(uint nbytes)
{
 ac5:	55                   	push   %ebp
 ac6:	89 e5                	mov    %esp,%ebp
 ac8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 acb:	8b 45 08             	mov    0x8(%ebp),%eax
 ace:	83 c0 07             	add    $0x7,%eax
 ad1:	c1 e8 03             	shr    $0x3,%eax
 ad4:	83 c0 01             	add    $0x1,%eax
 ad7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ada:	a1 68 0e 00 00       	mov    0xe68,%eax
 adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae6:	75 23                	jne    b0b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 ae8:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
 aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af2:	a3 68 0e 00 00       	mov    %eax,0xe68
 af7:	a1 68 0e 00 00       	mov    0xe68,%eax
 afc:	a3 60 0e 00 00       	mov    %eax,0xe60
    base.s.size = 0;
 b01:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 b08:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0e:	8b 00                	mov    (%eax),%eax
 b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b16:	8b 40 04             	mov    0x4(%eax),%eax
 b19:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b1c:	72 4d                	jb     b6b <malloc+0xa6>
      if(p->s.size == nunits)
 b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b21:	8b 40 04             	mov    0x4(%eax),%eax
 b24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b27:	75 0c                	jne    b35 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2c:	8b 10                	mov    (%eax),%edx
 b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b31:	89 10                	mov    %edx,(%eax)
 b33:	eb 26                	jmp    b5b <malloc+0x96>
      else {
        p->s.size -= nunits;
 b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b38:	8b 40 04             	mov    0x4(%eax),%eax
 b3b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b3e:	89 c2                	mov    %eax,%edx
 b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b43:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b49:	8b 40 04             	mov    0x4(%eax),%eax
 b4c:	c1 e0 03             	shl    $0x3,%eax
 b4f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b55:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b58:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b5e:	a3 68 0e 00 00       	mov    %eax,0xe68
      return (void*)(p + 1);
 b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b66:	83 c0 08             	add    $0x8,%eax
 b69:	eb 3b                	jmp    ba6 <malloc+0xe1>
    }
    if(p == freep)
 b6b:	a1 68 0e 00 00       	mov    0xe68,%eax
 b70:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b73:	75 1e                	jne    b93 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b75:	83 ec 0c             	sub    $0xc,%esp
 b78:	ff 75 ec             	pushl  -0x14(%ebp)
 b7b:	e8 e5 fe ff ff       	call   a65 <morecore>
 b80:	83 c4 10             	add    $0x10,%esp
 b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b8a:	75 07                	jne    b93 <malloc+0xce>
        return 0;
 b8c:	b8 00 00 00 00       	mov    $0x0,%eax
 b91:	eb 13                	jmp    ba6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9c:	8b 00                	mov    (%eax),%eax
 b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ba1:	e9 6d ff ff ff       	jmp    b13 <malloc+0x4e>
}
 ba6:	c9                   	leave  
 ba7:	c3                   	ret    
