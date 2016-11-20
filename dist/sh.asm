
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 56 14 00 00       	call   1467 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 00 1a 00 00 	mov    0x1a00(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 d4 19 00 00       	push   $0x19d4
      2c:	e8 83 06 00 00       	call   6b4 <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 1e 14 00 00       	call   1467 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 40 14 00 00       	call   149f <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 db 19 00 00       	push   $0x19db
      71:	6a 02                	push   $0x2
      73:	e8 a6 15 00 00       	call   161e <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c6 01 00 00       	jmp    246 <runcmd+0x246>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 fa 13 00 00       	call   148f <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 f9 13 00 00       	call   14a7 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 eb 19 00 00       	push   $0x19eb
      c4:	6a 02                	push   $0x2
      c6:	e8 53 15 00 00       	call   161e <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 94 13 00 00       	call   1467 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5c 01 00 00       	jmp    246 <runcmd+0x246>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 df 05 00 00       	call   6d4 <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 5f 13 00 00       	call   146f <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 1f 01 00 00       	jmp    246 <runcmd+0x246>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 3e 13 00 00       	call   1477 <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 fb 19 00 00       	push   $0x19fb
     148:	e8 67 05 00 00       	call   6b4 <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 7f 05 00 00       	call   6d4 <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 2c 13 00 00       	call   148f <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 6d 13 00 00       	call   14df <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 0e 13 00 00       	call   148f <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 ff 12 00 00       	call   148f <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 2a 05 00 00       	call   6d4 <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 d7 12 00 00       	call   148f <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 18 13 00 00       	call   14df <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 b9 12 00 00       	call   148f <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 aa 12 00 00       	call   148f <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 89 12 00 00       	call   148f <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 7a 12 00 00       	call   148f <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 52 12 00 00       	call   146f <wait>
    wait();
     21d:	e8 4d 12 00 00       	call   146f <wait>
    break;
     222:	eb 22                	jmp    246 <runcmd+0x246>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 a5 04 00 00       	call   6d4 <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 12                	jne    245 <runcmd+0x245>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	90                   	nop
  }
  exit();
     246:	e8 1c 12 00 00       	call   1467 <exit>

0000024b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24b:	55                   	push   %ebp
     24c:	89 e5                	mov    %esp,%ebp
     24e:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     251:	83 ec 08             	sub    $0x8,%esp
     254:	68 18 1a 00 00       	push   $0x1a18
     259:	6a 02                	push   $0x2
     25b:	e8 be 13 00 00       	call   161e <printf>
     260:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 ec 04             	sub    $0x4,%esp
     269:	50                   	push   %eax
     26a:	6a 00                	push   $0x0
     26c:	ff 75 08             	pushl  0x8(%ebp)
     26f:	e8 58 10 00 00       	call   12cc <memset>
     274:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     277:	83 ec 08             	sub    $0x8,%esp
     27a:	ff 75 0c             	pushl  0xc(%ebp)
     27d:	ff 75 08             	pushl  0x8(%ebp)
     280:	e8 94 10 00 00       	call   1319 <gets>
     285:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     288:	8b 45 08             	mov    0x8(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	75 07                	jne    299 <getcmd+0x4e>
    return -1;
     292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     297:	eb 05                	jmp    29e <getcmd+0x53>
  return 0;
     299:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29e:	c9                   	leave  
     29f:	c3                   	ret    

000002a0 <strncmp>:
#ifdef USE_BUILTINS
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
    while(n > 0 && *p && *p == *q)
     2a3:	eb 0c                	jmp    2b1 <strncmp+0x11>
      n--, p++, q++;
     2a5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     2a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     2ad:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
    while(n > 0 && *p && *p == *q)
     2b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2b5:	74 1a                	je     2d1 <strncmp+0x31>
     2b7:	8b 45 08             	mov    0x8(%ebp),%eax
     2ba:	0f b6 00             	movzbl (%eax),%eax
     2bd:	84 c0                	test   %al,%al
     2bf:	74 10                	je     2d1 <strncmp+0x31>
     2c1:	8b 45 08             	mov    0x8(%ebp),%eax
     2c4:	0f b6 10             	movzbl (%eax),%edx
     2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ca:	0f b6 00             	movzbl (%eax),%eax
     2cd:	38 c2                	cmp    %al,%dl
     2cf:	74 d4                	je     2a5 <strncmp+0x5>
      n--, p++, q++;
    if(n == 0)
     2d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2d5:	75 07                	jne    2de <strncmp+0x3e>
      return 0;
     2d7:	b8 00 00 00 00       	mov    $0x0,%eax
     2dc:	eb 16                	jmp    2f4 <strncmp+0x54>
    return (uchar)*p - (uchar)*q;
     2de:	8b 45 08             	mov    0x8(%ebp),%eax
     2e1:	0f b6 00             	movzbl (%eax),%eax
     2e4:	0f b6 d0             	movzbl %al,%edx
     2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ea:	0f b6 00             	movzbl (%eax),%eax
     2ed:	0f b6 c0             	movzbl %al,%eax
     2f0:	29 c2                	sub    %eax,%edx
     2f2:	89 d0                	mov    %edx,%eax
}
     2f4:	5d                   	pop    %ebp
     2f5:	c3                   	ret    

000002f6 <makeint>:

int
makeint(char *p)
{
     2f6:	55                   	push   %ebp
     2f7:	89 e5                	mov    %esp,%ebp
     2f9:	83 ec 10             	sub    $0x10,%esp
  int val = 0;
     2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  while ((*p >= '0') && (*p <= '9')) {
     303:	eb 23                	jmp    328 <makeint+0x32>
    val = 10*val + (*p-'0');
     305:	8b 55 fc             	mov    -0x4(%ebp),%edx
     308:	89 d0                	mov    %edx,%eax
     30a:	c1 e0 02             	shl    $0x2,%eax
     30d:	01 d0                	add    %edx,%eax
     30f:	01 c0                	add    %eax,%eax
     311:	89 c2                	mov    %eax,%edx
     313:	8b 45 08             	mov    0x8(%ebp),%eax
     316:	0f b6 00             	movzbl (%eax),%eax
     319:	0f be c0             	movsbl %al,%eax
     31c:	83 e8 30             	sub    $0x30,%eax
     31f:	01 d0                	add    %edx,%eax
     321:	89 45 fc             	mov    %eax,-0x4(%ebp)
    ++p;
     324:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
makeint(char *p)
{
  int val = 0;

  while ((*p >= '0') && (*p <= '9')) {
     328:	8b 45 08             	mov    0x8(%ebp),%eax
     32b:	0f b6 00             	movzbl (%eax),%eax
     32e:	3c 2f                	cmp    $0x2f,%al
     330:	7e 0a                	jle    33c <makeint+0x46>
     332:	8b 45 08             	mov    0x8(%ebp),%eax
     335:	0f b6 00             	movzbl (%eax),%eax
     338:	3c 39                	cmp    $0x39,%al
     33a:	7e c9                	jle    305 <makeint+0xf>
    val = 10*val + (*p-'0');
    ++p;
  }
  return val;
     33c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     33f:	c9                   	leave  
     340:	c3                   	ret    

00000341 <setbuiltin>:

int
setbuiltin(char *p)
{
     341:	55                   	push   %ebp
     342:	89 e5                	mov    %esp,%ebp
     344:	83 ec 18             	sub    $0x18,%esp
  int i;

  p += strlen("_set");
     347:	83 ec 0c             	sub    $0xc,%esp
     34a:	68 1b 1a 00 00       	push   $0x1a1b
     34f:	e8 51 0f 00 00       	call   12a5 <strlen>
     354:	83 c4 10             	add    $0x10,%esp
     357:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     35a:	eb 04                	jmp    360 <setbuiltin+0x1f>
     35c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     360:	83 ec 04             	sub    $0x4,%esp
     363:	6a 01                	push   $0x1
     365:	68 20 1a 00 00       	push   $0x1a20
     36a:	ff 75 08             	pushl  0x8(%ebp)
     36d:	e8 2e ff ff ff       	call   2a0 <strncmp>
     372:	83 c4 10             	add    $0x10,%esp
     375:	85 c0                	test   %eax,%eax
     377:	74 e3                	je     35c <setbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     379:	83 ec 04             	sub    $0x4,%esp
     37c:	6a 03                	push   $0x3
     37e:	ff 75 08             	pushl  0x8(%ebp)
     381:	68 22 1a 00 00       	push   $0x1a22
     386:	e8 15 ff ff ff       	call   2a0 <strncmp>
     38b:	83 c4 10             	add    $0x10,%esp
     38e:	85 c0                	test   %eax,%eax
     390:	75 57                	jne    3e9 <setbuiltin+0xa8>
    p += strlen("uid");
     392:	83 ec 0c             	sub    $0xc,%esp
     395:	68 22 1a 00 00       	push   $0x1a22
     39a:	e8 06 0f 00 00       	call   12a5 <strlen>
     39f:	83 c4 10             	add    $0x10,%esp
     3a2:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     3a5:	eb 04                	jmp    3ab <setbuiltin+0x6a>
     3a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3ab:	83 ec 04             	sub    $0x4,%esp
     3ae:	6a 01                	push   $0x1
     3b0:	68 20 1a 00 00       	push   $0x1a20
     3b5:	ff 75 08             	pushl  0x8(%ebp)
     3b8:	e8 e3 fe ff ff       	call   2a0 <strncmp>
     3bd:	83 c4 10             	add    $0x10,%esp
     3c0:	85 c0                	test   %eax,%eax
     3c2:	74 e3                	je     3a7 <setbuiltin+0x66>
    i = makeint(p); // ugly
     3c4:	83 ec 0c             	sub    $0xc,%esp
     3c7:	ff 75 08             	pushl  0x8(%ebp)
     3ca:	e8 27 ff ff ff       	call   2f6 <makeint>
     3cf:	83 c4 10             	add    $0x10,%esp
     3d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setuid(i));
     3d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d8:	83 ec 0c             	sub    $0xc,%esp
     3db:	50                   	push   %eax
     3dc:	e8 4e 11 00 00       	call   152f <setuid>
     3e1:	83 c4 10             	add    $0x10,%esp
     3e4:	e9 84 00 00 00       	jmp    46d <setbuiltin+0x12c>
  } else 
  if (strncmp("gid", p, 3) == 0) {
     3e9:	83 ec 04             	sub    $0x4,%esp
     3ec:	6a 03                	push   $0x3
     3ee:	ff 75 08             	pushl  0x8(%ebp)
     3f1:	68 26 1a 00 00       	push   $0x1a26
     3f6:	e8 a5 fe ff ff       	call   2a0 <strncmp>
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	85 c0                	test   %eax,%eax
     400:	75 54                	jne    456 <setbuiltin+0x115>
    p += strlen("gid");
     402:	83 ec 0c             	sub    $0xc,%esp
     405:	68 26 1a 00 00       	push   $0x1a26
     40a:	e8 96 0e 00 00       	call   12a5 <strlen>
     40f:	83 c4 10             	add    $0x10,%esp
     412:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     415:	eb 04                	jmp    41b <setbuiltin+0xda>
     417:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     41b:	83 ec 04             	sub    $0x4,%esp
     41e:	6a 01                	push   $0x1
     420:	68 20 1a 00 00       	push   $0x1a20
     425:	ff 75 08             	pushl  0x8(%ebp)
     428:	e8 73 fe ff ff       	call   2a0 <strncmp>
     42d:	83 c4 10             	add    $0x10,%esp
     430:	85 c0                	test   %eax,%eax
     432:	74 e3                	je     417 <setbuiltin+0xd6>
    i = makeint(p); // ugly
     434:	83 ec 0c             	sub    $0xc,%esp
     437:	ff 75 08             	pushl  0x8(%ebp)
     43a:	e8 b7 fe ff ff       	call   2f6 <makeint>
     43f:	83 c4 10             	add    $0x10,%esp
     442:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setgid(i));
     445:	8b 45 f4             	mov    -0xc(%ebp),%eax
     448:	83 ec 0c             	sub    $0xc,%esp
     44b:	50                   	push   %eax
     44c:	e8 e6 10 00 00       	call   1537 <setgid>
     451:	83 c4 10             	add    $0x10,%esp
     454:	eb 17                	jmp    46d <setbuiltin+0x12c>
  }
  printf(2, "Invalid _set parameter\n");
     456:	83 ec 08             	sub    $0x8,%esp
     459:	68 2a 1a 00 00       	push   $0x1a2a
     45e:	6a 02                	push   $0x2
     460:	e8 b9 11 00 00       	call   161e <printf>
     465:	83 c4 10             	add    $0x10,%esp
  return -1;
     468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     46d:	c9                   	leave  
     46e:	c3                   	ret    

0000046f <getbuiltin>:

int
getbuiltin(char *p)
{
     46f:	55                   	push   %ebp
     470:	89 e5                	mov    %esp,%ebp
     472:	83 ec 08             	sub    $0x8,%esp
  p += strlen("_get");
     475:	83 ec 0c             	sub    $0xc,%esp
     478:	68 42 1a 00 00       	push   $0x1a42
     47d:	e8 23 0e 00 00       	call   12a5 <strlen>
     482:	83 c4 10             	add    $0x10,%esp
     485:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     488:	eb 04                	jmp    48e <getbuiltin+0x1f>
     48a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     48e:	83 ec 04             	sub    $0x4,%esp
     491:	6a 01                	push   $0x1
     493:	68 20 1a 00 00       	push   $0x1a20
     498:	ff 75 08             	pushl  0x8(%ebp)
     49b:	e8 00 fe ff ff       	call   2a0 <strncmp>
     4a0:	83 c4 10             	add    $0x10,%esp
     4a3:	85 c0                	test   %eax,%eax
     4a5:	74 e3                	je     48a <getbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     4a7:	83 ec 04             	sub    $0x4,%esp
     4aa:	6a 03                	push   $0x3
     4ac:	ff 75 08             	pushl  0x8(%ebp)
     4af:	68 22 1a 00 00       	push   $0x1a22
     4b4:	e8 e7 fd ff ff       	call   2a0 <strncmp>
     4b9:	83 c4 10             	add    $0x10,%esp
     4bc:	85 c0                	test   %eax,%eax
     4be:	75 1f                	jne    4df <getbuiltin+0x70>
    printf(2, "%d\n", getuid());
     4c0:	e8 52 10 00 00       	call   1517 <getuid>
     4c5:	83 ec 04             	sub    $0x4,%esp
     4c8:	50                   	push   %eax
     4c9:	68 47 1a 00 00       	push   $0x1a47
     4ce:	6a 02                	push   $0x2
     4d0:	e8 49 11 00 00       	call   161e <printf>
     4d5:	83 c4 10             	add    $0x10,%esp
    return 0;
     4d8:	b8 00 00 00 00       	mov    $0x0,%eax
     4dd:	eb 4f                	jmp    52e <getbuiltin+0xbf>
  }
  if (strncmp("gid", p, 3) == 0) {
     4df:	83 ec 04             	sub    $0x4,%esp
     4e2:	6a 03                	push   $0x3
     4e4:	ff 75 08             	pushl  0x8(%ebp)
     4e7:	68 26 1a 00 00       	push   $0x1a26
     4ec:	e8 af fd ff ff       	call   2a0 <strncmp>
     4f1:	83 c4 10             	add    $0x10,%esp
     4f4:	85 c0                	test   %eax,%eax
     4f6:	75 1f                	jne    517 <getbuiltin+0xa8>
    printf(2, "%d\n", getgid());
     4f8:	e8 22 10 00 00       	call   151f <getgid>
     4fd:	83 ec 04             	sub    $0x4,%esp
     500:	50                   	push   %eax
     501:	68 47 1a 00 00       	push   $0x1a47
     506:	6a 02                	push   $0x2
     508:	e8 11 11 00 00       	call   161e <printf>
     50d:	83 c4 10             	add    $0x10,%esp
    return 0;
     510:	b8 00 00 00 00       	mov    $0x0,%eax
     515:	eb 17                	jmp    52e <getbuiltin+0xbf>
  }
  printf(2, "Invalid _get parameter\n");
     517:	83 ec 08             	sub    $0x8,%esp
     51a:	68 4b 1a 00 00       	push   $0x1a4b
     51f:	6a 02                	push   $0x2
     521:	e8 f8 10 00 00       	call   161e <printf>
     526:	83 c4 10             	add    $0x10,%esp
  return -1;
     529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     52e:	c9                   	leave  
     52f:	c3                   	ret    

00000530 <dobuiltin>:
  {"_get", getbuiltin}
};
int FDTcount = sizeof(fdt) / sizeof(fdt[0]); // # entris in FDT

void
dobuiltin(char *cmd) {
     530:	55                   	push   %ebp
     531:	89 e5                	mov    %esp,%ebp
     533:	83 ec 18             	sub    $0x18,%esp
  int i;

  for (i=0; i<FDTcount; i++) 
     536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     53d:	eb 4f                	jmp    58e <dobuiltin+0x5e>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     542:	8b 04 c5 68 20 00 00 	mov    0x2068(,%eax,8),%eax
     549:	83 ec 0c             	sub    $0xc,%esp
     54c:	50                   	push   %eax
     54d:	e8 53 0d 00 00       	call   12a5 <strlen>
     552:	83 c4 10             	add    $0x10,%esp
     555:	89 c2                	mov    %eax,%edx
     557:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55a:	8b 04 c5 68 20 00 00 	mov    0x2068(,%eax,8),%eax
     561:	83 ec 04             	sub    $0x4,%esp
     564:	52                   	push   %edx
     565:	50                   	push   %eax
     566:	ff 75 08             	pushl  0x8(%ebp)
     569:	e8 32 fd ff ff       	call   2a0 <strncmp>
     56e:	83 c4 10             	add    $0x10,%esp
     571:	85 c0                	test   %eax,%eax
     573:	75 15                	jne    58a <dobuiltin+0x5a>
     (*fdt[i].name)(cmd);
     575:	8b 45 f4             	mov    -0xc(%ebp),%eax
     578:	8b 04 c5 6c 20 00 00 	mov    0x206c(,%eax,8),%eax
     57f:	83 ec 0c             	sub    $0xc,%esp
     582:	ff 75 08             	pushl  0x8(%ebp)
     585:	ff d0                	call   *%eax
     587:	83 c4 10             	add    $0x10,%esp

void
dobuiltin(char *cmd) {
  int i;

  for (i=0; i<FDTcount; i++) 
     58a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     58e:	a1 78 20 00 00       	mov    0x2078,%eax
     593:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     596:	7c a7                	jl     53f <dobuiltin+0xf>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     (*fdt[i].name)(cmd);
}
     598:	90                   	nop
     599:	c9                   	leave  
     59a:	c3                   	ret    

0000059b <main>:
// ***** processing for shell builtins ends here *****
#endif

int
main(void)
{
     59b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     59f:	83 e4 f0             	and    $0xfffffff0,%esp
     5a2:	ff 71 fc             	pushl  -0x4(%ecx)
     5a5:	55                   	push   %ebp
     5a6:	89 e5                	mov    %esp,%ebp
     5a8:	51                   	push   %ecx
     5a9:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     5ac:	eb 16                	jmp    5c4 <main+0x29>
    if(fd >= 3){
     5ae:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     5b2:	7e 10                	jle    5c4 <main+0x29>
      close(fd);
     5b4:	83 ec 0c             	sub    $0xc,%esp
     5b7:	ff 75 f4             	pushl  -0xc(%ebp)
     5ba:	e8 d0 0e 00 00       	call   148f <close>
     5bf:	83 c4 10             	add    $0x10,%esp
      break;
     5c2:	eb 1b                	jmp    5df <main+0x44>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     5c4:	83 ec 08             	sub    $0x8,%esp
     5c7:	6a 02                	push   $0x2
     5c9:	68 63 1a 00 00       	push   $0x1a63
     5ce:	e8 d4 0e 00 00       	call   14a7 <open>
     5d3:	83 c4 10             	add    $0x10,%esp
     5d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     5d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5dd:	79 cf                	jns    5ae <main+0x13>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     5df:	e9 b1 00 00 00       	jmp    695 <main+0xfa>
// add support for built-ins here. cd is a built-in
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     5e4:	0f b6 05 a0 20 00 00 	movzbl 0x20a0,%eax
     5eb:	3c 63                	cmp    $0x63,%al
     5ed:	75 5f                	jne    64e <main+0xb3>
     5ef:	0f b6 05 a1 20 00 00 	movzbl 0x20a1,%eax
     5f6:	3c 64                	cmp    $0x64,%al
     5f8:	75 54                	jne    64e <main+0xb3>
     5fa:	0f b6 05 a2 20 00 00 	movzbl 0x20a2,%eax
     601:	3c 20                	cmp    $0x20,%al
     603:	75 49                	jne    64e <main+0xb3>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     605:	83 ec 0c             	sub    $0xc,%esp
     608:	68 a0 20 00 00       	push   $0x20a0
     60d:	e8 93 0c 00 00       	call   12a5 <strlen>
     612:	83 c4 10             	add    $0x10,%esp
     615:	83 e8 01             	sub    $0x1,%eax
     618:	c6 80 a0 20 00 00 00 	movb   $0x0,0x20a0(%eax)
      if(chdir(buf+3) < 0)
     61f:	b8 a3 20 00 00       	mov    $0x20a3,%eax
     624:	83 ec 0c             	sub    $0xc,%esp
     627:	50                   	push   %eax
     628:	e8 aa 0e 00 00       	call   14d7 <chdir>
     62d:	83 c4 10             	add    $0x10,%esp
     630:	85 c0                	test   %eax,%eax
     632:	79 61                	jns    695 <main+0xfa>
        printf(2, "cannot cd %s\n", buf+3);
     634:	b8 a3 20 00 00       	mov    $0x20a3,%eax
     639:	83 ec 04             	sub    $0x4,%esp
     63c:	50                   	push   %eax
     63d:	68 6b 1a 00 00       	push   $0x1a6b
     642:	6a 02                	push   $0x2
     644:	e8 d5 0f 00 00       	call   161e <printf>
     649:	83 c4 10             	add    $0x10,%esp
      continue;
     64c:	eb 47                	jmp    695 <main+0xfa>
    }
#ifdef USE_BUILTINS
    if (buf[0]=='_') {     // assume it is a builtin command
     64e:	0f b6 05 a0 20 00 00 	movzbl 0x20a0,%eax
     655:	3c 5f                	cmp    $0x5f,%al
     657:	75 12                	jne    66b <main+0xd0>
      dobuiltin(buf);
     659:	83 ec 0c             	sub    $0xc,%esp
     65c:	68 a0 20 00 00       	push   $0x20a0
     661:	e8 ca fe ff ff       	call   530 <dobuiltin>
     666:	83 c4 10             	add    $0x10,%esp
      continue;
     669:	eb 2a                	jmp    695 <main+0xfa>
    }
#endif
    if(fork1() == 0)
     66b:	e8 64 00 00 00       	call   6d4 <fork1>
     670:	85 c0                	test   %eax,%eax
     672:	75 1c                	jne    690 <main+0xf5>
      runcmd(parsecmd(buf));
     674:	83 ec 0c             	sub    $0xc,%esp
     677:	68 a0 20 00 00       	push   $0x20a0
     67c:	e8 ab 03 00 00       	call   a2c <parsecmd>
     681:	83 c4 10             	add    $0x10,%esp
     684:	83 ec 0c             	sub    $0xc,%esp
     687:	50                   	push   %eax
     688:	e8 73 f9 ff ff       	call   0 <runcmd>
     68d:	83 c4 10             	add    $0x10,%esp
    wait();
     690:	e8 da 0d 00 00       	call   146f <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     695:	83 ec 08             	sub    $0x8,%esp
     698:	6a 64                	push   $0x64
     69a:	68 a0 20 00 00       	push   $0x20a0
     69f:	e8 a7 fb ff ff       	call   24b <getcmd>
     6a4:	83 c4 10             	add    $0x10,%esp
     6a7:	85 c0                	test   %eax,%eax
     6a9:	0f 89 35 ff ff ff    	jns    5e4 <main+0x49>
#endif
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     6af:	e8 b3 0d 00 00       	call   1467 <exit>

000006b4 <panic>:
}

void
panic(char *s)
{
     6b4:	55                   	push   %ebp
     6b5:	89 e5                	mov    %esp,%ebp
     6b7:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     6ba:	83 ec 04             	sub    $0x4,%esp
     6bd:	ff 75 08             	pushl  0x8(%ebp)
     6c0:	68 79 1a 00 00       	push   $0x1a79
     6c5:	6a 02                	push   $0x2
     6c7:	e8 52 0f 00 00       	call   161e <printf>
     6cc:	83 c4 10             	add    $0x10,%esp
  exit();
     6cf:	e8 93 0d 00 00       	call   1467 <exit>

000006d4 <fork1>:
}

int
fork1(void)
{
     6d4:	55                   	push   %ebp
     6d5:	89 e5                	mov    %esp,%ebp
     6d7:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     6da:	e8 80 0d 00 00       	call   145f <fork>
     6df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     6e2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     6e6:	75 10                	jne    6f8 <fork1+0x24>
    panic("fork");
     6e8:	83 ec 0c             	sub    $0xc,%esp
     6eb:	68 7d 1a 00 00       	push   $0x1a7d
     6f0:	e8 bf ff ff ff       	call   6b4 <panic>
     6f5:	83 c4 10             	add    $0x10,%esp
  return pid;
     6f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6fb:	c9                   	leave  
     6fc:	c3                   	ret    

000006fd <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     6fd:	55                   	push   %ebp
     6fe:	89 e5                	mov    %esp,%ebp
     700:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     703:	83 ec 0c             	sub    $0xc,%esp
     706:	6a 54                	push   $0x54
     708:	e8 e4 11 00 00       	call   18f1 <malloc>
     70d:	83 c4 10             	add    $0x10,%esp
     710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     713:	83 ec 04             	sub    $0x4,%esp
     716:	6a 54                	push   $0x54
     718:	6a 00                	push   $0x0
     71a:	ff 75 f4             	pushl  -0xc(%ebp)
     71d:	e8 aa 0b 00 00       	call   12cc <memset>
     722:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     725:	8b 45 f4             	mov    -0xc(%ebp),%eax
     728:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     731:	c9                   	leave  
     732:	c3                   	ret    

00000733 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     733:	55                   	push   %ebp
     734:	89 e5                	mov    %esp,%ebp
     736:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     739:	83 ec 0c             	sub    $0xc,%esp
     73c:	6a 18                	push   $0x18
     73e:	e8 ae 11 00 00       	call   18f1 <malloc>
     743:	83 c4 10             	add    $0x10,%esp
     746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     749:	83 ec 04             	sub    $0x4,%esp
     74c:	6a 18                	push   $0x18
     74e:	6a 00                	push   $0x0
     750:	ff 75 f4             	pushl  -0xc(%ebp)
     753:	e8 74 0b 00 00       	call   12cc <memset>
     758:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     764:	8b 45 f4             	mov    -0xc(%ebp),%eax
     767:	8b 55 08             	mov    0x8(%ebp),%edx
     76a:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     770:	8b 55 0c             	mov    0xc(%ebp),%edx
     773:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     776:	8b 45 f4             	mov    -0xc(%ebp),%eax
     779:	8b 55 10             	mov    0x10(%ebp),%edx
     77c:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     782:	8b 55 14             	mov    0x14(%ebp),%edx
     785:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     788:	8b 45 f4             	mov    -0xc(%ebp),%eax
     78b:	8b 55 18             	mov    0x18(%ebp),%edx
     78e:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     791:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     794:	c9                   	leave  
     795:	c3                   	ret    

00000796 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     796:	55                   	push   %ebp
     797:	89 e5                	mov    %esp,%ebp
     799:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     79c:	83 ec 0c             	sub    $0xc,%esp
     79f:	6a 0c                	push   $0xc
     7a1:	e8 4b 11 00 00       	call   18f1 <malloc>
     7a6:	83 c4 10             	add    $0x10,%esp
     7a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7ac:	83 ec 04             	sub    $0x4,%esp
     7af:	6a 0c                	push   $0xc
     7b1:	6a 00                	push   $0x0
     7b3:	ff 75 f4             	pushl  -0xc(%ebp)
     7b6:	e8 11 0b 00 00       	call   12cc <memset>
     7bb:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c1:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ca:	8b 55 08             	mov    0x8(%ebp),%edx
     7cd:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d3:	8b 55 0c             	mov    0xc(%ebp),%edx
     7d6:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7dc:	c9                   	leave  
     7dd:	c3                   	ret    

000007de <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     7de:	55                   	push   %ebp
     7df:	89 e5                	mov    %esp,%ebp
     7e1:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7e4:	83 ec 0c             	sub    $0xc,%esp
     7e7:	6a 0c                	push   $0xc
     7e9:	e8 03 11 00 00       	call   18f1 <malloc>
     7ee:	83 c4 10             	add    $0x10,%esp
     7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7f4:	83 ec 04             	sub    $0x4,%esp
     7f7:	6a 0c                	push   $0xc
     7f9:	6a 00                	push   $0x0
     7fb:	ff 75 f4             	pushl  -0xc(%ebp)
     7fe:	e8 c9 0a 00 00       	call   12cc <memset>
     803:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     806:	8b 45 f4             	mov    -0xc(%ebp),%eax
     809:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     812:	8b 55 08             	mov    0x8(%ebp),%edx
     815:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     818:	8b 45 f4             	mov    -0xc(%ebp),%eax
     81b:	8b 55 0c             	mov    0xc(%ebp),%edx
     81e:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     821:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     824:	c9                   	leave  
     825:	c3                   	ret    

00000826 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     826:	55                   	push   %ebp
     827:	89 e5                	mov    %esp,%ebp
     829:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     82c:	83 ec 0c             	sub    $0xc,%esp
     82f:	6a 08                	push   $0x8
     831:	e8 bb 10 00 00       	call   18f1 <malloc>
     836:	83 c4 10             	add    $0x10,%esp
     839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     83c:	83 ec 04             	sub    $0x4,%esp
     83f:	6a 08                	push   $0x8
     841:	6a 00                	push   $0x0
     843:	ff 75 f4             	pushl  -0xc(%ebp)
     846:	e8 81 0a 00 00       	call   12cc <memset>
     84b:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     851:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     857:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85a:	8b 55 08             	mov    0x8(%ebp),%edx
     85d:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     860:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     863:	c9                   	leave  
     864:	c3                   	ret    

00000865 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     865:	55                   	push   %ebp
     866:	89 e5                	mov    %esp,%ebp
     868:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     86b:	8b 45 08             	mov    0x8(%ebp),%eax
     86e:	8b 00                	mov    (%eax),%eax
     870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     873:	eb 04                	jmp    879 <gettoken+0x14>
    s++;
     875:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     879:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     87f:	73 1e                	jae    89f <gettoken+0x3a>
     881:	8b 45 f4             	mov    -0xc(%ebp),%eax
     884:	0f b6 00             	movzbl (%eax),%eax
     887:	0f be c0             	movsbl %al,%eax
     88a:	83 ec 08             	sub    $0x8,%esp
     88d:	50                   	push   %eax
     88e:	68 7c 20 00 00       	push   $0x207c
     893:	e8 4e 0a 00 00       	call   12e6 <strchr>
     898:	83 c4 10             	add    $0x10,%esp
     89b:	85 c0                	test   %eax,%eax
     89d:	75 d6                	jne    875 <gettoken+0x10>
    s++;
  if(q)
     89f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     8a3:	74 08                	je     8ad <gettoken+0x48>
    *q = s;
     8a5:	8b 45 10             	mov    0x10(%ebp),%eax
     8a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8ab:	89 10                	mov    %edx,(%eax)
  ret = *s;
     8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b0:	0f b6 00             	movzbl (%eax),%eax
     8b3:	0f be c0             	movsbl %al,%eax
     8b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8bc:	0f b6 00             	movzbl (%eax),%eax
     8bf:	0f be c0             	movsbl %al,%eax
     8c2:	83 f8 29             	cmp    $0x29,%eax
     8c5:	7f 14                	jg     8db <gettoken+0x76>
     8c7:	83 f8 28             	cmp    $0x28,%eax
     8ca:	7d 28                	jge    8f4 <gettoken+0x8f>
     8cc:	85 c0                	test   %eax,%eax
     8ce:	0f 84 94 00 00 00    	je     968 <gettoken+0x103>
     8d4:	83 f8 26             	cmp    $0x26,%eax
     8d7:	74 1b                	je     8f4 <gettoken+0x8f>
     8d9:	eb 3a                	jmp    915 <gettoken+0xb0>
     8db:	83 f8 3e             	cmp    $0x3e,%eax
     8de:	74 1a                	je     8fa <gettoken+0x95>
     8e0:	83 f8 3e             	cmp    $0x3e,%eax
     8e3:	7f 0a                	jg     8ef <gettoken+0x8a>
     8e5:	83 e8 3b             	sub    $0x3b,%eax
     8e8:	83 f8 01             	cmp    $0x1,%eax
     8eb:	77 28                	ja     915 <gettoken+0xb0>
     8ed:	eb 05                	jmp    8f4 <gettoken+0x8f>
     8ef:	83 f8 7c             	cmp    $0x7c,%eax
     8f2:	75 21                	jne    915 <gettoken+0xb0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     8f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     8f8:	eb 75                	jmp    96f <gettoken+0x10a>
  case '>':
    s++;
     8fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     901:	0f b6 00             	movzbl (%eax),%eax
     904:	3c 3e                	cmp    $0x3e,%al
     906:	75 63                	jne    96b <gettoken+0x106>
      ret = '+';
     908:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     90f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     913:	eb 56                	jmp    96b <gettoken+0x106>
  default:
    ret = 'a';
     915:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     91c:	eb 04                	jmp    922 <gettoken+0xbd>
      s++;
     91e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     922:	8b 45 f4             	mov    -0xc(%ebp),%eax
     925:	3b 45 0c             	cmp    0xc(%ebp),%eax
     928:	73 44                	jae    96e <gettoken+0x109>
     92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92d:	0f b6 00             	movzbl (%eax),%eax
     930:	0f be c0             	movsbl %al,%eax
     933:	83 ec 08             	sub    $0x8,%esp
     936:	50                   	push   %eax
     937:	68 7c 20 00 00       	push   $0x207c
     93c:	e8 a5 09 00 00       	call   12e6 <strchr>
     941:	83 c4 10             	add    $0x10,%esp
     944:	85 c0                	test   %eax,%eax
     946:	75 26                	jne    96e <gettoken+0x109>
     948:	8b 45 f4             	mov    -0xc(%ebp),%eax
     94b:	0f b6 00             	movzbl (%eax),%eax
     94e:	0f be c0             	movsbl %al,%eax
     951:	83 ec 08             	sub    $0x8,%esp
     954:	50                   	push   %eax
     955:	68 84 20 00 00       	push   $0x2084
     95a:	e8 87 09 00 00       	call   12e6 <strchr>
     95f:	83 c4 10             	add    $0x10,%esp
     962:	85 c0                	test   %eax,%eax
     964:	74 b8                	je     91e <gettoken+0xb9>
      s++;
    break;
     966:	eb 06                	jmp    96e <gettoken+0x109>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     968:	90                   	nop
     969:	eb 04                	jmp    96f <gettoken+0x10a>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     96b:	90                   	nop
     96c:	eb 01                	jmp    96f <gettoken+0x10a>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     96e:	90                   	nop
  }
  if(eq)
     96f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     973:	74 0e                	je     983 <gettoken+0x11e>
    *eq = s;
     975:	8b 45 14             	mov    0x14(%ebp),%eax
     978:	8b 55 f4             	mov    -0xc(%ebp),%edx
     97b:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     97d:	eb 04                	jmp    983 <gettoken+0x11e>
    s++;
     97f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     983:	8b 45 f4             	mov    -0xc(%ebp),%eax
     986:	3b 45 0c             	cmp    0xc(%ebp),%eax
     989:	73 1e                	jae    9a9 <gettoken+0x144>
     98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     98e:	0f b6 00             	movzbl (%eax),%eax
     991:	0f be c0             	movsbl %al,%eax
     994:	83 ec 08             	sub    $0x8,%esp
     997:	50                   	push   %eax
     998:	68 7c 20 00 00       	push   $0x207c
     99d:	e8 44 09 00 00       	call   12e6 <strchr>
     9a2:	83 c4 10             	add    $0x10,%esp
     9a5:	85 c0                	test   %eax,%eax
     9a7:	75 d6                	jne    97f <gettoken+0x11a>
    s++;
  *ps = s;
     9a9:	8b 45 08             	mov    0x8(%ebp),%eax
     9ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9af:	89 10                	mov    %edx,(%eax)
  return ret;
     9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     9b4:	c9                   	leave  
     9b5:	c3                   	ret    

000009b6 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     9b6:	55                   	push   %ebp
     9b7:	89 e5                	mov    %esp,%ebp
     9b9:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     9bc:	8b 45 08             	mov    0x8(%ebp),%eax
     9bf:	8b 00                	mov    (%eax),%eax
     9c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     9c4:	eb 04                	jmp    9ca <peek+0x14>
    s++;
     9c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     9ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9d0:	73 1e                	jae    9f0 <peek+0x3a>
     9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d5:	0f b6 00             	movzbl (%eax),%eax
     9d8:	0f be c0             	movsbl %al,%eax
     9db:	83 ec 08             	sub    $0x8,%esp
     9de:	50                   	push   %eax
     9df:	68 7c 20 00 00       	push   $0x207c
     9e4:	e8 fd 08 00 00       	call   12e6 <strchr>
     9e9:	83 c4 10             	add    $0x10,%esp
     9ec:	85 c0                	test   %eax,%eax
     9ee:	75 d6                	jne    9c6 <peek+0x10>
    s++;
  *ps = s;
     9f0:	8b 45 08             	mov    0x8(%ebp),%eax
     9f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9f6:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9fb:	0f b6 00             	movzbl (%eax),%eax
     9fe:	84 c0                	test   %al,%al
     a00:	74 23                	je     a25 <peek+0x6f>
     a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a05:	0f b6 00             	movzbl (%eax),%eax
     a08:	0f be c0             	movsbl %al,%eax
     a0b:	83 ec 08             	sub    $0x8,%esp
     a0e:	50                   	push   %eax
     a0f:	ff 75 10             	pushl  0x10(%ebp)
     a12:	e8 cf 08 00 00       	call   12e6 <strchr>
     a17:	83 c4 10             	add    $0x10,%esp
     a1a:	85 c0                	test   %eax,%eax
     a1c:	74 07                	je     a25 <peek+0x6f>
     a1e:	b8 01 00 00 00       	mov    $0x1,%eax
     a23:	eb 05                	jmp    a2a <peek+0x74>
     a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a2a:	c9                   	leave  
     a2b:	c3                   	ret    

00000a2c <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     a2c:	55                   	push   %ebp
     a2d:	89 e5                	mov    %esp,%ebp
     a2f:	53                   	push   %ebx
     a30:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     a33:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a36:	8b 45 08             	mov    0x8(%ebp),%eax
     a39:	83 ec 0c             	sub    $0xc,%esp
     a3c:	50                   	push   %eax
     a3d:	e8 63 08 00 00       	call   12a5 <strlen>
     a42:	83 c4 10             	add    $0x10,%esp
     a45:	01 d8                	add    %ebx,%eax
     a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     a4a:	83 ec 08             	sub    $0x8,%esp
     a4d:	ff 75 f4             	pushl  -0xc(%ebp)
     a50:	8d 45 08             	lea    0x8(%ebp),%eax
     a53:	50                   	push   %eax
     a54:	e8 61 00 00 00       	call   aba <parseline>
     a59:	83 c4 10             	add    $0x10,%esp
     a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     a5f:	83 ec 04             	sub    $0x4,%esp
     a62:	68 82 1a 00 00       	push   $0x1a82
     a67:	ff 75 f4             	pushl  -0xc(%ebp)
     a6a:	8d 45 08             	lea    0x8(%ebp),%eax
     a6d:	50                   	push   %eax
     a6e:	e8 43 ff ff ff       	call   9b6 <peek>
     a73:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     a76:	8b 45 08             	mov    0x8(%ebp),%eax
     a79:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     a7c:	74 26                	je     aa4 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     a7e:	8b 45 08             	mov    0x8(%ebp),%eax
     a81:	83 ec 04             	sub    $0x4,%esp
     a84:	50                   	push   %eax
     a85:	68 83 1a 00 00       	push   $0x1a83
     a8a:	6a 02                	push   $0x2
     a8c:	e8 8d 0b 00 00       	call   161e <printf>
     a91:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     a94:	83 ec 0c             	sub    $0xc,%esp
     a97:	68 92 1a 00 00       	push   $0x1a92
     a9c:	e8 13 fc ff ff       	call   6b4 <panic>
     aa1:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     aa4:	83 ec 0c             	sub    $0xc,%esp
     aa7:	ff 75 f0             	pushl  -0x10(%ebp)
     aaa:	e8 eb 03 00 00       	call   e9a <nulterminate>
     aaf:	83 c4 10             	add    $0x10,%esp
  return cmd;
     ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ab8:	c9                   	leave  
     ab9:	c3                   	ret    

00000aba <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     aba:	55                   	push   %ebp
     abb:	89 e5                	mov    %esp,%ebp
     abd:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     ac0:	83 ec 08             	sub    $0x8,%esp
     ac3:	ff 75 0c             	pushl  0xc(%ebp)
     ac6:	ff 75 08             	pushl  0x8(%ebp)
     ac9:	e8 99 00 00 00       	call   b67 <parsepipe>
     ace:	83 c4 10             	add    $0x10,%esp
     ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     ad4:	eb 23                	jmp    af9 <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     ad6:	6a 00                	push   $0x0
     ad8:	6a 00                	push   $0x0
     ada:	ff 75 0c             	pushl  0xc(%ebp)
     add:	ff 75 08             	pushl  0x8(%ebp)
     ae0:	e8 80 fd ff ff       	call   865 <gettoken>
     ae5:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     ae8:	83 ec 0c             	sub    $0xc,%esp
     aeb:	ff 75 f4             	pushl  -0xc(%ebp)
     aee:	e8 33 fd ff ff       	call   826 <backcmd>
     af3:	83 c4 10             	add    $0x10,%esp
     af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     af9:	83 ec 04             	sub    $0x4,%esp
     afc:	68 99 1a 00 00       	push   $0x1a99
     b01:	ff 75 0c             	pushl  0xc(%ebp)
     b04:	ff 75 08             	pushl  0x8(%ebp)
     b07:	e8 aa fe ff ff       	call   9b6 <peek>
     b0c:	83 c4 10             	add    $0x10,%esp
     b0f:	85 c0                	test   %eax,%eax
     b11:	75 c3                	jne    ad6 <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     b13:	83 ec 04             	sub    $0x4,%esp
     b16:	68 9b 1a 00 00       	push   $0x1a9b
     b1b:	ff 75 0c             	pushl  0xc(%ebp)
     b1e:	ff 75 08             	pushl  0x8(%ebp)
     b21:	e8 90 fe ff ff       	call   9b6 <peek>
     b26:	83 c4 10             	add    $0x10,%esp
     b29:	85 c0                	test   %eax,%eax
     b2b:	74 35                	je     b62 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     b2d:	6a 00                	push   $0x0
     b2f:	6a 00                	push   $0x0
     b31:	ff 75 0c             	pushl  0xc(%ebp)
     b34:	ff 75 08             	pushl  0x8(%ebp)
     b37:	e8 29 fd ff ff       	call   865 <gettoken>
     b3c:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     b3f:	83 ec 08             	sub    $0x8,%esp
     b42:	ff 75 0c             	pushl  0xc(%ebp)
     b45:	ff 75 08             	pushl  0x8(%ebp)
     b48:	e8 6d ff ff ff       	call   aba <parseline>
     b4d:	83 c4 10             	add    $0x10,%esp
     b50:	83 ec 08             	sub    $0x8,%esp
     b53:	50                   	push   %eax
     b54:	ff 75 f4             	pushl  -0xc(%ebp)
     b57:	e8 82 fc ff ff       	call   7de <listcmd>
     b5c:	83 c4 10             	add    $0x10,%esp
     b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b65:	c9                   	leave  
     b66:	c3                   	ret    

00000b67 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     b67:	55                   	push   %ebp
     b68:	89 e5                	mov    %esp,%ebp
     b6a:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     b6d:	83 ec 08             	sub    $0x8,%esp
     b70:	ff 75 0c             	pushl  0xc(%ebp)
     b73:	ff 75 08             	pushl  0x8(%ebp)
     b76:	e8 ec 01 00 00       	call   d67 <parseexec>
     b7b:	83 c4 10             	add    $0x10,%esp
     b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     b81:	83 ec 04             	sub    $0x4,%esp
     b84:	68 9d 1a 00 00       	push   $0x1a9d
     b89:	ff 75 0c             	pushl  0xc(%ebp)
     b8c:	ff 75 08             	pushl  0x8(%ebp)
     b8f:	e8 22 fe ff ff       	call   9b6 <peek>
     b94:	83 c4 10             	add    $0x10,%esp
     b97:	85 c0                	test   %eax,%eax
     b99:	74 35                	je     bd0 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     b9b:	6a 00                	push   $0x0
     b9d:	6a 00                	push   $0x0
     b9f:	ff 75 0c             	pushl  0xc(%ebp)
     ba2:	ff 75 08             	pushl  0x8(%ebp)
     ba5:	e8 bb fc ff ff       	call   865 <gettoken>
     baa:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     bad:	83 ec 08             	sub    $0x8,%esp
     bb0:	ff 75 0c             	pushl  0xc(%ebp)
     bb3:	ff 75 08             	pushl  0x8(%ebp)
     bb6:	e8 ac ff ff ff       	call   b67 <parsepipe>
     bbb:	83 c4 10             	add    $0x10,%esp
     bbe:	83 ec 08             	sub    $0x8,%esp
     bc1:	50                   	push   %eax
     bc2:	ff 75 f4             	pushl  -0xc(%ebp)
     bc5:	e8 cc fb ff ff       	call   796 <pipecmd>
     bca:	83 c4 10             	add    $0x10,%esp
     bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     bd3:	c9                   	leave  
     bd4:	c3                   	ret    

00000bd5 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     bd5:	55                   	push   %ebp
     bd6:	89 e5                	mov    %esp,%ebp
     bd8:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     bdb:	e9 b6 00 00 00       	jmp    c96 <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     be0:	6a 00                	push   $0x0
     be2:	6a 00                	push   $0x0
     be4:	ff 75 10             	pushl  0x10(%ebp)
     be7:	ff 75 0c             	pushl  0xc(%ebp)
     bea:	e8 76 fc ff ff       	call   865 <gettoken>
     bef:	83 c4 10             	add    $0x10,%esp
     bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     bf5:	8d 45 ec             	lea    -0x14(%ebp),%eax
     bf8:	50                   	push   %eax
     bf9:	8d 45 f0             	lea    -0x10(%ebp),%eax
     bfc:	50                   	push   %eax
     bfd:	ff 75 10             	pushl  0x10(%ebp)
     c00:	ff 75 0c             	pushl  0xc(%ebp)
     c03:	e8 5d fc ff ff       	call   865 <gettoken>
     c08:	83 c4 10             	add    $0x10,%esp
     c0b:	83 f8 61             	cmp    $0x61,%eax
     c0e:	74 10                	je     c20 <parseredirs+0x4b>
      panic("missing file for redirection");
     c10:	83 ec 0c             	sub    $0xc,%esp
     c13:	68 9f 1a 00 00       	push   $0x1a9f
     c18:	e8 97 fa ff ff       	call   6b4 <panic>
     c1d:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c23:	83 f8 3c             	cmp    $0x3c,%eax
     c26:	74 0c                	je     c34 <parseredirs+0x5f>
     c28:	83 f8 3e             	cmp    $0x3e,%eax
     c2b:	74 26                	je     c53 <parseredirs+0x7e>
     c2d:	83 f8 2b             	cmp    $0x2b,%eax
     c30:	74 43                	je     c75 <parseredirs+0xa0>
     c32:	eb 62                	jmp    c96 <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c3a:	83 ec 0c             	sub    $0xc,%esp
     c3d:	6a 00                	push   $0x0
     c3f:	6a 00                	push   $0x0
     c41:	52                   	push   %edx
     c42:	50                   	push   %eax
     c43:	ff 75 08             	pushl  0x8(%ebp)
     c46:	e8 e8 fa ff ff       	call   733 <redircmd>
     c4b:	83 c4 20             	add    $0x20,%esp
     c4e:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c51:	eb 43                	jmp    c96 <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c59:	83 ec 0c             	sub    $0xc,%esp
     c5c:	6a 01                	push   $0x1
     c5e:	68 01 02 00 00       	push   $0x201
     c63:	52                   	push   %edx
     c64:	50                   	push   %eax
     c65:	ff 75 08             	pushl  0x8(%ebp)
     c68:	e8 c6 fa ff ff       	call   733 <redircmd>
     c6d:	83 c4 20             	add    $0x20,%esp
     c70:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c73:	eb 21                	jmp    c96 <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c75:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c7b:	83 ec 0c             	sub    $0xc,%esp
     c7e:	6a 01                	push   $0x1
     c80:	68 01 02 00 00       	push   $0x201
     c85:	52                   	push   %edx
     c86:	50                   	push   %eax
     c87:	ff 75 08             	pushl  0x8(%ebp)
     c8a:	e8 a4 fa ff ff       	call   733 <redircmd>
     c8f:	83 c4 20             	add    $0x20,%esp
     c92:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c95:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     c96:	83 ec 04             	sub    $0x4,%esp
     c99:	68 bc 1a 00 00       	push   $0x1abc
     c9e:	ff 75 10             	pushl  0x10(%ebp)
     ca1:	ff 75 0c             	pushl  0xc(%ebp)
     ca4:	e8 0d fd ff ff       	call   9b6 <peek>
     ca9:	83 c4 10             	add    $0x10,%esp
     cac:	85 c0                	test   %eax,%eax
     cae:	0f 85 2c ff ff ff    	jne    be0 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     cb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cb7:	c9                   	leave  
     cb8:	c3                   	ret    

00000cb9 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     cb9:	55                   	push   %ebp
     cba:	89 e5                	mov    %esp,%ebp
     cbc:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     cbf:	83 ec 04             	sub    $0x4,%esp
     cc2:	68 bf 1a 00 00       	push   $0x1abf
     cc7:	ff 75 0c             	pushl  0xc(%ebp)
     cca:	ff 75 08             	pushl  0x8(%ebp)
     ccd:	e8 e4 fc ff ff       	call   9b6 <peek>
     cd2:	83 c4 10             	add    $0x10,%esp
     cd5:	85 c0                	test   %eax,%eax
     cd7:	75 10                	jne    ce9 <parseblock+0x30>
    panic("parseblock");
     cd9:	83 ec 0c             	sub    $0xc,%esp
     cdc:	68 c1 1a 00 00       	push   $0x1ac1
     ce1:	e8 ce f9 ff ff       	call   6b4 <panic>
     ce6:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     ce9:	6a 00                	push   $0x0
     ceb:	6a 00                	push   $0x0
     ced:	ff 75 0c             	pushl  0xc(%ebp)
     cf0:	ff 75 08             	pushl  0x8(%ebp)
     cf3:	e8 6d fb ff ff       	call   865 <gettoken>
     cf8:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     cfb:	83 ec 08             	sub    $0x8,%esp
     cfe:	ff 75 0c             	pushl  0xc(%ebp)
     d01:	ff 75 08             	pushl  0x8(%ebp)
     d04:	e8 b1 fd ff ff       	call   aba <parseline>
     d09:	83 c4 10             	add    $0x10,%esp
     d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     d0f:	83 ec 04             	sub    $0x4,%esp
     d12:	68 cc 1a 00 00       	push   $0x1acc
     d17:	ff 75 0c             	pushl  0xc(%ebp)
     d1a:	ff 75 08             	pushl  0x8(%ebp)
     d1d:	e8 94 fc ff ff       	call   9b6 <peek>
     d22:	83 c4 10             	add    $0x10,%esp
     d25:	85 c0                	test   %eax,%eax
     d27:	75 10                	jne    d39 <parseblock+0x80>
    panic("syntax - missing )");
     d29:	83 ec 0c             	sub    $0xc,%esp
     d2c:	68 ce 1a 00 00       	push   $0x1ace
     d31:	e8 7e f9 ff ff       	call   6b4 <panic>
     d36:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     d39:	6a 00                	push   $0x0
     d3b:	6a 00                	push   $0x0
     d3d:	ff 75 0c             	pushl  0xc(%ebp)
     d40:	ff 75 08             	pushl  0x8(%ebp)
     d43:	e8 1d fb ff ff       	call   865 <gettoken>
     d48:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     d4b:	83 ec 04             	sub    $0x4,%esp
     d4e:	ff 75 0c             	pushl  0xc(%ebp)
     d51:	ff 75 08             	pushl  0x8(%ebp)
     d54:	ff 75 f4             	pushl  -0xc(%ebp)
     d57:	e8 79 fe ff ff       	call   bd5 <parseredirs>
     d5c:	83 c4 10             	add    $0x10,%esp
     d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d65:	c9                   	leave  
     d66:	c3                   	ret    

00000d67 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     d67:	55                   	push   %ebp
     d68:	89 e5                	mov    %esp,%ebp
     d6a:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     d6d:	83 ec 04             	sub    $0x4,%esp
     d70:	68 bf 1a 00 00       	push   $0x1abf
     d75:	ff 75 0c             	pushl  0xc(%ebp)
     d78:	ff 75 08             	pushl  0x8(%ebp)
     d7b:	e8 36 fc ff ff       	call   9b6 <peek>
     d80:	83 c4 10             	add    $0x10,%esp
     d83:	85 c0                	test   %eax,%eax
     d85:	74 16                	je     d9d <parseexec+0x36>
    return parseblock(ps, es);
     d87:	83 ec 08             	sub    $0x8,%esp
     d8a:	ff 75 0c             	pushl  0xc(%ebp)
     d8d:	ff 75 08             	pushl  0x8(%ebp)
     d90:	e8 24 ff ff ff       	call   cb9 <parseblock>
     d95:	83 c4 10             	add    $0x10,%esp
     d98:	e9 fb 00 00 00       	jmp    e98 <parseexec+0x131>

  ret = execcmd();
     d9d:	e8 5b f9 ff ff       	call   6fd <execcmd>
     da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     da8:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     dab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     db2:	83 ec 04             	sub    $0x4,%esp
     db5:	ff 75 0c             	pushl  0xc(%ebp)
     db8:	ff 75 08             	pushl  0x8(%ebp)
     dbb:	ff 75 f0             	pushl  -0x10(%ebp)
     dbe:	e8 12 fe ff ff       	call   bd5 <parseredirs>
     dc3:	83 c4 10             	add    $0x10,%esp
     dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     dc9:	e9 87 00 00 00       	jmp    e55 <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     dce:	8d 45 e0             	lea    -0x20(%ebp),%eax
     dd1:	50                   	push   %eax
     dd2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     dd5:	50                   	push   %eax
     dd6:	ff 75 0c             	pushl  0xc(%ebp)
     dd9:	ff 75 08             	pushl  0x8(%ebp)
     ddc:	e8 84 fa ff ff       	call   865 <gettoken>
     de1:	83 c4 10             	add    $0x10,%esp
     de4:	89 45 e8             	mov    %eax,-0x18(%ebp)
     de7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     deb:	0f 84 84 00 00 00    	je     e75 <parseexec+0x10e>
      break;
    if(tok != 'a')
     df1:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     df5:	74 10                	je     e07 <parseexec+0xa0>
      panic("syntax");
     df7:	83 ec 0c             	sub    $0xc,%esp
     dfa:	68 92 1a 00 00       	push   $0x1a92
     dff:	e8 b0 f8 ff ff       	call   6b4 <panic>
     e04:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     e07:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e10:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     e14:	8b 55 e0             	mov    -0x20(%ebp),%edx
     e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e1a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     e1d:	83 c1 08             	add    $0x8,%ecx
     e20:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     e24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     e28:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     e2c:	7e 10                	jle    e3e <parseexec+0xd7>
      panic("too many args");
     e2e:	83 ec 0c             	sub    $0xc,%esp
     e31:	68 e1 1a 00 00       	push   $0x1ae1
     e36:	e8 79 f8 ff ff       	call   6b4 <panic>
     e3b:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     e3e:	83 ec 04             	sub    $0x4,%esp
     e41:	ff 75 0c             	pushl  0xc(%ebp)
     e44:	ff 75 08             	pushl  0x8(%ebp)
     e47:	ff 75 f0             	pushl  -0x10(%ebp)
     e4a:	e8 86 fd ff ff       	call   bd5 <parseredirs>
     e4f:	83 c4 10             	add    $0x10,%esp
     e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     e55:	83 ec 04             	sub    $0x4,%esp
     e58:	68 ef 1a 00 00       	push   $0x1aef
     e5d:	ff 75 0c             	pushl  0xc(%ebp)
     e60:	ff 75 08             	pushl  0x8(%ebp)
     e63:	e8 4e fb ff ff       	call   9b6 <peek>
     e68:	83 c4 10             	add    $0x10,%esp
     e6b:	85 c0                	test   %eax,%eax
     e6d:	0f 84 5b ff ff ff    	je     dce <parseexec+0x67>
     e73:	eb 01                	jmp    e76 <parseexec+0x10f>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     e75:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e7c:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     e83:	00 
  cmd->eargv[argc] = 0;
     e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e8a:	83 c2 08             	add    $0x8,%edx
     e8d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     e94:	00 
  return ret;
     e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e98:	c9                   	leave  
     e99:	c3                   	ret    

00000e9a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e9a:	55                   	push   %ebp
     e9b:	89 e5                	mov    %esp,%ebp
     e9d:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     ea0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     ea4:	75 0a                	jne    eb0 <nulterminate+0x16>
    return 0;
     ea6:	b8 00 00 00 00       	mov    $0x0,%eax
     eab:	e9 e4 00 00 00       	jmp    f94 <nulterminate+0xfa>
  
  switch(cmd->type){
     eb0:	8b 45 08             	mov    0x8(%ebp),%eax
     eb3:	8b 00                	mov    (%eax),%eax
     eb5:	83 f8 05             	cmp    $0x5,%eax
     eb8:	0f 87 d3 00 00 00    	ja     f91 <nulterminate+0xf7>
     ebe:	8b 04 85 f4 1a 00 00 	mov    0x1af4(,%eax,4),%eax
     ec5:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     ec7:	8b 45 08             	mov    0x8(%ebp),%eax
     eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ed4:	eb 14                	jmp    eea <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     edc:	83 c2 08             	add    $0x8,%edx
     edf:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     ee3:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     ee6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ef0:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     ef4:	85 c0                	test   %eax,%eax
     ef6:	75 de                	jne    ed6 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     ef8:	e9 94 00 00 00       	jmp    f91 <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     efd:	8b 45 08             	mov    0x8(%ebp),%eax
     f00:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f06:	8b 40 04             	mov    0x4(%eax),%eax
     f09:	83 ec 0c             	sub    $0xc,%esp
     f0c:	50                   	push   %eax
     f0d:	e8 88 ff ff ff       	call   e9a <nulterminate>
     f12:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f18:	8b 40 0c             	mov    0xc(%eax),%eax
     f1b:	c6 00 00             	movb   $0x0,(%eax)
    break;
     f1e:	eb 71                	jmp    f91 <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     f20:	8b 45 08             	mov    0x8(%ebp),%eax
     f23:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f29:	8b 40 04             	mov    0x4(%eax),%eax
     f2c:	83 ec 0c             	sub    $0xc,%esp
     f2f:	50                   	push   %eax
     f30:	e8 65 ff ff ff       	call   e9a <nulterminate>
     f35:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f3b:	8b 40 08             	mov    0x8(%eax),%eax
     f3e:	83 ec 0c             	sub    $0xc,%esp
     f41:	50                   	push   %eax
     f42:	e8 53 ff ff ff       	call   e9a <nulterminate>
     f47:	83 c4 10             	add    $0x10,%esp
    break;
     f4a:	eb 45                	jmp    f91 <nulterminate+0xf7>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     f4c:	8b 45 08             	mov    0x8(%ebp),%eax
     f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f55:	8b 40 04             	mov    0x4(%eax),%eax
     f58:	83 ec 0c             	sub    $0xc,%esp
     f5b:	50                   	push   %eax
     f5c:	e8 39 ff ff ff       	call   e9a <nulterminate>
     f61:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f67:	8b 40 08             	mov    0x8(%eax),%eax
     f6a:	83 ec 0c             	sub    $0xc,%esp
     f6d:	50                   	push   %eax
     f6e:	e8 27 ff ff ff       	call   e9a <nulterminate>
     f73:	83 c4 10             	add    $0x10,%esp
    break;
     f76:	eb 19                	jmp    f91 <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     f78:	8b 45 08             	mov    0x8(%ebp),%eax
     f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f81:	8b 40 04             	mov    0x4(%eax),%eax
     f84:	83 ec 0c             	sub    $0xc,%esp
     f87:	50                   	push   %eax
     f88:	e8 0d ff ff ff       	call   e9a <nulterminate>
     f8d:	83 c4 10             	add    $0x10,%esp
    break;
     f90:	90                   	nop
  }
  return cmd;
     f91:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f94:	c9                   	leave  
     f95:	c3                   	ret    

00000f96 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
     f96:	55                   	push   %ebp
     f97:	89 e5                	mov    %esp,%ebp
     f99:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
     f9c:	8b 45 08             	mov    0x8(%ebp),%eax
     f9f:	0f b7 00             	movzwl (%eax),%eax
     fa2:	98                   	cwtl   
     fa3:	83 f8 02             	cmp    $0x2,%eax
     fa6:	74 1e                	je     fc6 <print_mode+0x30>
     fa8:	83 f8 03             	cmp    $0x3,%eax
     fab:	74 2d                	je     fda <print_mode+0x44>
     fad:	83 f8 01             	cmp    $0x1,%eax
     fb0:	75 3c                	jne    fee <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
     fb2:	83 ec 08             	sub    $0x8,%esp
     fb5:	68 0c 1b 00 00       	push   $0x1b0c
     fba:	6a 01                	push   $0x1
     fbc:	e8 5d 06 00 00       	call   161e <printf>
     fc1:	83 c4 10             	add    $0x10,%esp
     fc4:	eb 3a                	jmp    1000 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
     fc6:	83 ec 08             	sub    $0x8,%esp
     fc9:	68 0e 1b 00 00       	push   $0x1b0e
     fce:	6a 01                	push   $0x1
     fd0:	e8 49 06 00 00       	call   161e <printf>
     fd5:	83 c4 10             	add    $0x10,%esp
     fd8:	eb 26                	jmp    1000 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
     fda:	83 ec 08             	sub    $0x8,%esp
     fdd:	68 10 1b 00 00       	push   $0x1b10
     fe2:	6a 01                	push   $0x1
     fe4:	e8 35 06 00 00       	call   161e <printf>
     fe9:	83 c4 10             	add    $0x10,%esp
     fec:	eb 12                	jmp    1000 <print_mode+0x6a>
    default: printf(1, "?");
     fee:	83 ec 08             	sub    $0x8,%esp
     ff1:	68 12 1b 00 00       	push   $0x1b12
     ff6:	6a 01                	push   $0x1
     ff8:	e8 21 06 00 00       	call   161e <printf>
     ffd:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
    1000:	8b 45 08             	mov    0x8(%ebp),%eax
    1003:	0f b6 40 19          	movzbl 0x19(%eax),%eax
    1007:	83 e0 01             	and    $0x1,%eax
    100a:	84 c0                	test   %al,%al
    100c:	74 14                	je     1022 <print_mode+0x8c>
    printf(1, "r");
    100e:	83 ec 08             	sub    $0x8,%esp
    1011:	68 14 1b 00 00       	push   $0x1b14
    1016:	6a 01                	push   $0x1
    1018:	e8 01 06 00 00       	call   161e <printf>
    101d:	83 c4 10             	add    $0x10,%esp
    1020:	eb 12                	jmp    1034 <print_mode+0x9e>
  else
    printf(1, "-");
    1022:	83 ec 08             	sub    $0x8,%esp
    1025:	68 0e 1b 00 00       	push   $0x1b0e
    102a:	6a 01                	push   $0x1
    102c:	e8 ed 05 00 00       	call   161e <printf>
    1031:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
    1034:	8b 45 08             	mov    0x8(%ebp),%eax
    1037:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    103b:	83 e0 80             	and    $0xffffff80,%eax
    103e:	84 c0                	test   %al,%al
    1040:	74 14                	je     1056 <print_mode+0xc0>
    printf(1, "w");
    1042:	83 ec 08             	sub    $0x8,%esp
    1045:	68 16 1b 00 00       	push   $0x1b16
    104a:	6a 01                	push   $0x1
    104c:	e8 cd 05 00 00       	call   161e <printf>
    1051:	83 c4 10             	add    $0x10,%esp
    1054:	eb 12                	jmp    1068 <print_mode+0xd2>
  else
    printf(1, "-");
    1056:	83 ec 08             	sub    $0x8,%esp
    1059:	68 0e 1b 00 00       	push   $0x1b0e
    105e:	6a 01                	push   $0x1
    1060:	e8 b9 05 00 00       	call   161e <printf>
    1065:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
    1068:	8b 45 08             	mov    0x8(%ebp),%eax
    106b:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    106f:	c0 e8 06             	shr    $0x6,%al
    1072:	83 e0 01             	and    $0x1,%eax
    1075:	0f b6 d0             	movzbl %al,%edx
    1078:	8b 45 08             	mov    0x8(%ebp),%eax
    107b:	0f b6 40 19          	movzbl 0x19(%eax),%eax
    107f:	d0 e8                	shr    %al
    1081:	83 e0 01             	and    $0x1,%eax
    1084:	0f b6 c0             	movzbl %al,%eax
    1087:	21 d0                	and    %edx,%eax
    1089:	85 c0                	test   %eax,%eax
    108b:	74 14                	je     10a1 <print_mode+0x10b>
    printf(1, "S");
    108d:	83 ec 08             	sub    $0x8,%esp
    1090:	68 18 1b 00 00       	push   $0x1b18
    1095:	6a 01                	push   $0x1
    1097:	e8 82 05 00 00       	call   161e <printf>
    109c:	83 c4 10             	add    $0x10,%esp
    109f:	eb 34                	jmp    10d5 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
    10a1:	8b 45 08             	mov    0x8(%ebp),%eax
    10a4:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    10a8:	83 e0 40             	and    $0x40,%eax
    10ab:	84 c0                	test   %al,%al
    10ad:	74 14                	je     10c3 <print_mode+0x12d>
    printf(1, "x");
    10af:	83 ec 08             	sub    $0x8,%esp
    10b2:	68 1a 1b 00 00       	push   $0x1b1a
    10b7:	6a 01                	push   $0x1
    10b9:	e8 60 05 00 00       	call   161e <printf>
    10be:	83 c4 10             	add    $0x10,%esp
    10c1:	eb 12                	jmp    10d5 <print_mode+0x13f>
  else
    printf(1, "-");
    10c3:	83 ec 08             	sub    $0x8,%esp
    10c6:	68 0e 1b 00 00       	push   $0x1b0e
    10cb:	6a 01                	push   $0x1
    10cd:	e8 4c 05 00 00       	call   161e <printf>
    10d2:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    10dc:	83 e0 20             	and    $0x20,%eax
    10df:	84 c0                	test   %al,%al
    10e1:	74 14                	je     10f7 <print_mode+0x161>
    printf(1, "r");
    10e3:	83 ec 08             	sub    $0x8,%esp
    10e6:	68 14 1b 00 00       	push   $0x1b14
    10eb:	6a 01                	push   $0x1
    10ed:	e8 2c 05 00 00       	call   161e <printf>
    10f2:	83 c4 10             	add    $0x10,%esp
    10f5:	eb 12                	jmp    1109 <print_mode+0x173>
  else
    printf(1, "-");
    10f7:	83 ec 08             	sub    $0x8,%esp
    10fa:	68 0e 1b 00 00       	push   $0x1b0e
    10ff:	6a 01                	push   $0x1
    1101:	e8 18 05 00 00       	call   161e <printf>
    1106:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
    110c:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    1110:	83 e0 10             	and    $0x10,%eax
    1113:	84 c0                	test   %al,%al
    1115:	74 14                	je     112b <print_mode+0x195>
    printf(1, "w");
    1117:	83 ec 08             	sub    $0x8,%esp
    111a:	68 16 1b 00 00       	push   $0x1b16
    111f:	6a 01                	push   $0x1
    1121:	e8 f8 04 00 00       	call   161e <printf>
    1126:	83 c4 10             	add    $0x10,%esp
    1129:	eb 12                	jmp    113d <print_mode+0x1a7>
  else
    printf(1, "-");
    112b:	83 ec 08             	sub    $0x8,%esp
    112e:	68 0e 1b 00 00       	push   $0x1b0e
    1133:	6a 01                	push   $0x1
    1135:	e8 e4 04 00 00       	call   161e <printf>
    113a:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
    113d:	8b 45 08             	mov    0x8(%ebp),%eax
    1140:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    1144:	83 e0 08             	and    $0x8,%eax
    1147:	84 c0                	test   %al,%al
    1149:	74 14                	je     115f <print_mode+0x1c9>
    printf(1, "x");
    114b:	83 ec 08             	sub    $0x8,%esp
    114e:	68 1a 1b 00 00       	push   $0x1b1a
    1153:	6a 01                	push   $0x1
    1155:	e8 c4 04 00 00       	call   161e <printf>
    115a:	83 c4 10             	add    $0x10,%esp
    115d:	eb 12                	jmp    1171 <print_mode+0x1db>
  else
    printf(1, "-");
    115f:	83 ec 08             	sub    $0x8,%esp
    1162:	68 0e 1b 00 00       	push   $0x1b0e
    1167:	6a 01                	push   $0x1
    1169:	e8 b0 04 00 00       	call   161e <printf>
    116e:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    1178:	83 e0 04             	and    $0x4,%eax
    117b:	84 c0                	test   %al,%al
    117d:	74 14                	je     1193 <print_mode+0x1fd>
    printf(1, "r");
    117f:	83 ec 08             	sub    $0x8,%esp
    1182:	68 14 1b 00 00       	push   $0x1b14
    1187:	6a 01                	push   $0x1
    1189:	e8 90 04 00 00       	call   161e <printf>
    118e:	83 c4 10             	add    $0x10,%esp
    1191:	eb 12                	jmp    11a5 <print_mode+0x20f>
  else
    printf(1, "-");
    1193:	83 ec 08             	sub    $0x8,%esp
    1196:	68 0e 1b 00 00       	push   $0x1b0e
    119b:	6a 01                	push   $0x1
    119d:	e8 7c 04 00 00       	call   161e <printf>
    11a2:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
    11a5:	8b 45 08             	mov    0x8(%ebp),%eax
    11a8:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    11ac:	83 e0 02             	and    $0x2,%eax
    11af:	84 c0                	test   %al,%al
    11b1:	74 14                	je     11c7 <print_mode+0x231>
    printf(1, "w");
    11b3:	83 ec 08             	sub    $0x8,%esp
    11b6:	68 16 1b 00 00       	push   $0x1b16
    11bb:	6a 01                	push   $0x1
    11bd:	e8 5c 04 00 00       	call   161e <printf>
    11c2:	83 c4 10             	add    $0x10,%esp
    11c5:	eb 12                	jmp    11d9 <print_mode+0x243>
  else
    printf(1, "-");
    11c7:	83 ec 08             	sub    $0x8,%esp
    11ca:	68 0e 1b 00 00       	push   $0x1b0e
    11cf:	6a 01                	push   $0x1
    11d1:	e8 48 04 00 00       	call   161e <printf>
    11d6:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
    11d9:	8b 45 08             	mov    0x8(%ebp),%eax
    11dc:	0f b6 40 18          	movzbl 0x18(%eax),%eax
    11e0:	83 e0 01             	and    $0x1,%eax
    11e3:	84 c0                	test   %al,%al
    11e5:	74 14                	je     11fb <print_mode+0x265>
    printf(1, "x");
    11e7:	83 ec 08             	sub    $0x8,%esp
    11ea:	68 1a 1b 00 00       	push   $0x1b1a
    11ef:	6a 01                	push   $0x1
    11f1:	e8 28 04 00 00       	call   161e <printf>
    11f6:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
    11f9:	eb 13                	jmp    120e <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
    11fb:	83 ec 08             	sub    $0x8,%esp
    11fe:	68 0e 1b 00 00       	push   $0x1b0e
    1203:	6a 01                	push   $0x1
    1205:	e8 14 04 00 00       	call   161e <printf>
    120a:	83 c4 10             	add    $0x10,%esp

  return;
    120d:	90                   	nop
}
    120e:	c9                   	leave  
    120f:	c3                   	ret    

00001210 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1210:	55                   	push   %ebp
    1211:	89 e5                	mov    %esp,%ebp
    1213:	57                   	push   %edi
    1214:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1215:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1218:	8b 55 10             	mov    0x10(%ebp),%edx
    121b:	8b 45 0c             	mov    0xc(%ebp),%eax
    121e:	89 cb                	mov    %ecx,%ebx
    1220:	89 df                	mov    %ebx,%edi
    1222:	89 d1                	mov    %edx,%ecx
    1224:	fc                   	cld    
    1225:	f3 aa                	rep stos %al,%es:(%edi)
    1227:	89 ca                	mov    %ecx,%edx
    1229:	89 fb                	mov    %edi,%ebx
    122b:	89 5d 08             	mov    %ebx,0x8(%ebp)
    122e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1231:	90                   	nop
    1232:	5b                   	pop    %ebx
    1233:	5f                   	pop    %edi
    1234:	5d                   	pop    %ebp
    1235:	c3                   	ret    

00001236 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1236:	55                   	push   %ebp
    1237:	89 e5                	mov    %esp,%ebp
    1239:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    123c:	8b 45 08             	mov    0x8(%ebp),%eax
    123f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1242:	90                   	nop
    1243:	8b 45 08             	mov    0x8(%ebp),%eax
    1246:	8d 50 01             	lea    0x1(%eax),%edx
    1249:	89 55 08             	mov    %edx,0x8(%ebp)
    124c:	8b 55 0c             	mov    0xc(%ebp),%edx
    124f:	8d 4a 01             	lea    0x1(%edx),%ecx
    1252:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1255:	0f b6 12             	movzbl (%edx),%edx
    1258:	88 10                	mov    %dl,(%eax)
    125a:	0f b6 00             	movzbl (%eax),%eax
    125d:	84 c0                	test   %al,%al
    125f:	75 e2                	jne    1243 <strcpy+0xd>
    ;
  return os;
    1261:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1264:	c9                   	leave  
    1265:	c3                   	ret    

00001266 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1266:	55                   	push   %ebp
    1267:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1269:	eb 08                	jmp    1273 <strcmp+0xd>
    p++, q++;
    126b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    126f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1273:	8b 45 08             	mov    0x8(%ebp),%eax
    1276:	0f b6 00             	movzbl (%eax),%eax
    1279:	84 c0                	test   %al,%al
    127b:	74 10                	je     128d <strcmp+0x27>
    127d:	8b 45 08             	mov    0x8(%ebp),%eax
    1280:	0f b6 10             	movzbl (%eax),%edx
    1283:	8b 45 0c             	mov    0xc(%ebp),%eax
    1286:	0f b6 00             	movzbl (%eax),%eax
    1289:	38 c2                	cmp    %al,%dl
    128b:	74 de                	je     126b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    128d:	8b 45 08             	mov    0x8(%ebp),%eax
    1290:	0f b6 00             	movzbl (%eax),%eax
    1293:	0f b6 d0             	movzbl %al,%edx
    1296:	8b 45 0c             	mov    0xc(%ebp),%eax
    1299:	0f b6 00             	movzbl (%eax),%eax
    129c:	0f b6 c0             	movzbl %al,%eax
    129f:	29 c2                	sub    %eax,%edx
    12a1:	89 d0                	mov    %edx,%eax
}
    12a3:	5d                   	pop    %ebp
    12a4:	c3                   	ret    

000012a5 <strlen>:

uint
strlen(char *s)
{
    12a5:	55                   	push   %ebp
    12a6:	89 e5                	mov    %esp,%ebp
    12a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    12ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    12b2:	eb 04                	jmp    12b8 <strlen+0x13>
    12b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    12b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12bb:	8b 45 08             	mov    0x8(%ebp),%eax
    12be:	01 d0                	add    %edx,%eax
    12c0:	0f b6 00             	movzbl (%eax),%eax
    12c3:	84 c0                	test   %al,%al
    12c5:	75 ed                	jne    12b4 <strlen+0xf>
    ;
  return n;
    12c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12ca:	c9                   	leave  
    12cb:	c3                   	ret    

000012cc <memset>:

void*
memset(void *dst, int c, uint n)
{
    12cc:	55                   	push   %ebp
    12cd:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    12cf:	8b 45 10             	mov    0x10(%ebp),%eax
    12d2:	50                   	push   %eax
    12d3:	ff 75 0c             	pushl  0xc(%ebp)
    12d6:	ff 75 08             	pushl  0x8(%ebp)
    12d9:	e8 32 ff ff ff       	call   1210 <stosb>
    12de:	83 c4 0c             	add    $0xc,%esp
  return dst;
    12e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12e4:	c9                   	leave  
    12e5:	c3                   	ret    

000012e6 <strchr>:

char*
strchr(const char *s, char c)
{
    12e6:	55                   	push   %ebp
    12e7:	89 e5                	mov    %esp,%ebp
    12e9:	83 ec 04             	sub    $0x4,%esp
    12ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ef:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    12f2:	eb 14                	jmp    1308 <strchr+0x22>
    if(*s == c)
    12f4:	8b 45 08             	mov    0x8(%ebp),%eax
    12f7:	0f b6 00             	movzbl (%eax),%eax
    12fa:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12fd:	75 05                	jne    1304 <strchr+0x1e>
      return (char*)s;
    12ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1302:	eb 13                	jmp    1317 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1304:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1308:	8b 45 08             	mov    0x8(%ebp),%eax
    130b:	0f b6 00             	movzbl (%eax),%eax
    130e:	84 c0                	test   %al,%al
    1310:	75 e2                	jne    12f4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1312:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1317:	c9                   	leave  
    1318:	c3                   	ret    

00001319 <gets>:

char*
gets(char *buf, int max)
{
    1319:	55                   	push   %ebp
    131a:	89 e5                	mov    %esp,%ebp
    131c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    131f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1326:	eb 42                	jmp    136a <gets+0x51>
    cc = read(0, &c, 1);
    1328:	83 ec 04             	sub    $0x4,%esp
    132b:	6a 01                	push   $0x1
    132d:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1330:	50                   	push   %eax
    1331:	6a 00                	push   $0x0
    1333:	e8 47 01 00 00       	call   147f <read>
    1338:	83 c4 10             	add    $0x10,%esp
    133b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    133e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1342:	7e 33                	jle    1377 <gets+0x5e>
      break;
    buf[i++] = c;
    1344:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1347:	8d 50 01             	lea    0x1(%eax),%edx
    134a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    134d:	89 c2                	mov    %eax,%edx
    134f:	8b 45 08             	mov    0x8(%ebp),%eax
    1352:	01 c2                	add    %eax,%edx
    1354:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1358:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    135a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    135e:	3c 0a                	cmp    $0xa,%al
    1360:	74 16                	je     1378 <gets+0x5f>
    1362:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1366:	3c 0d                	cmp    $0xd,%al
    1368:	74 0e                	je     1378 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136d:	83 c0 01             	add    $0x1,%eax
    1370:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1373:	7c b3                	jl     1328 <gets+0xf>
    1375:	eb 01                	jmp    1378 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1377:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1378:	8b 55 f4             	mov    -0xc(%ebp),%edx
    137b:	8b 45 08             	mov    0x8(%ebp),%eax
    137e:	01 d0                	add    %edx,%eax
    1380:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1383:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1386:	c9                   	leave  
    1387:	c3                   	ret    

00001388 <stat>:

int
stat(char *n, struct stat *st)
{
    1388:	55                   	push   %ebp
    1389:	89 e5                	mov    %esp,%ebp
    138b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    138e:	83 ec 08             	sub    $0x8,%esp
    1391:	6a 00                	push   $0x0
    1393:	ff 75 08             	pushl  0x8(%ebp)
    1396:	e8 0c 01 00 00       	call   14a7 <open>
    139b:	83 c4 10             	add    $0x10,%esp
    139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    13a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13a5:	79 07                	jns    13ae <stat+0x26>
    return -1;
    13a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13ac:	eb 25                	jmp    13d3 <stat+0x4b>
  r = fstat(fd, st);
    13ae:	83 ec 08             	sub    $0x8,%esp
    13b1:	ff 75 0c             	pushl  0xc(%ebp)
    13b4:	ff 75 f4             	pushl  -0xc(%ebp)
    13b7:	e8 03 01 00 00       	call   14bf <fstat>
    13bc:	83 c4 10             	add    $0x10,%esp
    13bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    13c2:	83 ec 0c             	sub    $0xc,%esp
    13c5:	ff 75 f4             	pushl  -0xc(%ebp)
    13c8:	e8 c2 00 00 00       	call   148f <close>
    13cd:	83 c4 10             	add    $0x10,%esp
  return r;
    13d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    13d3:	c9                   	leave  
    13d4:	c3                   	ret    

000013d5 <atoi>:

int
atoi(const char *s)
{
    13d5:	55                   	push   %ebp
    13d6:	89 e5                	mov    %esp,%ebp
    13d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    13db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    13e2:	eb 25                	jmp    1409 <atoi+0x34>
    n = n*10 + *s++ - '0';
    13e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13e7:	89 d0                	mov    %edx,%eax
    13e9:	c1 e0 02             	shl    $0x2,%eax
    13ec:	01 d0                	add    %edx,%eax
    13ee:	01 c0                	add    %eax,%eax
    13f0:	89 c1                	mov    %eax,%ecx
    13f2:	8b 45 08             	mov    0x8(%ebp),%eax
    13f5:	8d 50 01             	lea    0x1(%eax),%edx
    13f8:	89 55 08             	mov    %edx,0x8(%ebp)
    13fb:	0f b6 00             	movzbl (%eax),%eax
    13fe:	0f be c0             	movsbl %al,%eax
    1401:	01 c8                	add    %ecx,%eax
    1403:	83 e8 30             	sub    $0x30,%eax
    1406:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1409:	8b 45 08             	mov    0x8(%ebp),%eax
    140c:	0f b6 00             	movzbl (%eax),%eax
    140f:	3c 2f                	cmp    $0x2f,%al
    1411:	7e 0a                	jle    141d <atoi+0x48>
    1413:	8b 45 08             	mov    0x8(%ebp),%eax
    1416:	0f b6 00             	movzbl (%eax),%eax
    1419:	3c 39                	cmp    $0x39,%al
    141b:	7e c7                	jle    13e4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    141d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1420:	c9                   	leave  
    1421:	c3                   	ret    

00001422 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1422:	55                   	push   %ebp
    1423:	89 e5                	mov    %esp,%ebp
    1425:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1428:	8b 45 08             	mov    0x8(%ebp),%eax
    142b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    142e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1431:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1434:	eb 17                	jmp    144d <memmove+0x2b>
    *dst++ = *src++;
    1436:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1439:	8d 50 01             	lea    0x1(%eax),%edx
    143c:	89 55 fc             	mov    %edx,-0x4(%ebp)
    143f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1442:	8d 4a 01             	lea    0x1(%edx),%ecx
    1445:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1448:	0f b6 12             	movzbl (%edx),%edx
    144b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    144d:	8b 45 10             	mov    0x10(%ebp),%eax
    1450:	8d 50 ff             	lea    -0x1(%eax),%edx
    1453:	89 55 10             	mov    %edx,0x10(%ebp)
    1456:	85 c0                	test   %eax,%eax
    1458:	7f dc                	jg     1436 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    145a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    145d:	c9                   	leave  
    145e:	c3                   	ret    

0000145f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    145f:	b8 01 00 00 00       	mov    $0x1,%eax
    1464:	cd 40                	int    $0x40
    1466:	c3                   	ret    

00001467 <exit>:
SYSCALL(exit)
    1467:	b8 02 00 00 00       	mov    $0x2,%eax
    146c:	cd 40                	int    $0x40
    146e:	c3                   	ret    

0000146f <wait>:
SYSCALL(wait)
    146f:	b8 03 00 00 00       	mov    $0x3,%eax
    1474:	cd 40                	int    $0x40
    1476:	c3                   	ret    

00001477 <pipe>:
SYSCALL(pipe)
    1477:	b8 04 00 00 00       	mov    $0x4,%eax
    147c:	cd 40                	int    $0x40
    147e:	c3                   	ret    

0000147f <read>:
SYSCALL(read)
    147f:	b8 05 00 00 00       	mov    $0x5,%eax
    1484:	cd 40                	int    $0x40
    1486:	c3                   	ret    

00001487 <write>:
SYSCALL(write)
    1487:	b8 10 00 00 00       	mov    $0x10,%eax
    148c:	cd 40                	int    $0x40
    148e:	c3                   	ret    

0000148f <close>:
SYSCALL(close)
    148f:	b8 15 00 00 00       	mov    $0x15,%eax
    1494:	cd 40                	int    $0x40
    1496:	c3                   	ret    

00001497 <kill>:
SYSCALL(kill)
    1497:	b8 06 00 00 00       	mov    $0x6,%eax
    149c:	cd 40                	int    $0x40
    149e:	c3                   	ret    

0000149f <exec>:
SYSCALL(exec)
    149f:	b8 07 00 00 00       	mov    $0x7,%eax
    14a4:	cd 40                	int    $0x40
    14a6:	c3                   	ret    

000014a7 <open>:
SYSCALL(open)
    14a7:	b8 0f 00 00 00       	mov    $0xf,%eax
    14ac:	cd 40                	int    $0x40
    14ae:	c3                   	ret    

000014af <mknod>:
SYSCALL(mknod)
    14af:	b8 11 00 00 00       	mov    $0x11,%eax
    14b4:	cd 40                	int    $0x40
    14b6:	c3                   	ret    

000014b7 <unlink>:
SYSCALL(unlink)
    14b7:	b8 12 00 00 00       	mov    $0x12,%eax
    14bc:	cd 40                	int    $0x40
    14be:	c3                   	ret    

000014bf <fstat>:
SYSCALL(fstat)
    14bf:	b8 08 00 00 00       	mov    $0x8,%eax
    14c4:	cd 40                	int    $0x40
    14c6:	c3                   	ret    

000014c7 <link>:
SYSCALL(link)
    14c7:	b8 13 00 00 00       	mov    $0x13,%eax
    14cc:	cd 40                	int    $0x40
    14ce:	c3                   	ret    

000014cf <mkdir>:
SYSCALL(mkdir)
    14cf:	b8 14 00 00 00       	mov    $0x14,%eax
    14d4:	cd 40                	int    $0x40
    14d6:	c3                   	ret    

000014d7 <chdir>:
SYSCALL(chdir)
    14d7:	b8 09 00 00 00       	mov    $0x9,%eax
    14dc:	cd 40                	int    $0x40
    14de:	c3                   	ret    

000014df <dup>:
SYSCALL(dup)
    14df:	b8 0a 00 00 00       	mov    $0xa,%eax
    14e4:	cd 40                	int    $0x40
    14e6:	c3                   	ret    

000014e7 <getpid>:
SYSCALL(getpid)
    14e7:	b8 0b 00 00 00       	mov    $0xb,%eax
    14ec:	cd 40                	int    $0x40
    14ee:	c3                   	ret    

000014ef <sbrk>:
SYSCALL(sbrk)
    14ef:	b8 0c 00 00 00       	mov    $0xc,%eax
    14f4:	cd 40                	int    $0x40
    14f6:	c3                   	ret    

000014f7 <sleep>:
SYSCALL(sleep)
    14f7:	b8 0d 00 00 00       	mov    $0xd,%eax
    14fc:	cd 40                	int    $0x40
    14fe:	c3                   	ret    

000014ff <uptime>:
SYSCALL(uptime)
    14ff:	b8 0e 00 00 00       	mov    $0xe,%eax
    1504:	cd 40                	int    $0x40
    1506:	c3                   	ret    

00001507 <halt>:
SYSCALL(halt)
    1507:	b8 16 00 00 00       	mov    $0x16,%eax
    150c:	cd 40                	int    $0x40
    150e:	c3                   	ret    

0000150f <date>:
//Student Implementations 
SYSCALL(date)
    150f:	b8 17 00 00 00       	mov    $0x17,%eax
    1514:	cd 40                	int    $0x40
    1516:	c3                   	ret    

00001517 <getuid>:

SYSCALL(getuid)
    1517:	b8 18 00 00 00       	mov    $0x18,%eax
    151c:	cd 40                	int    $0x40
    151e:	c3                   	ret    

0000151f <getgid>:
SYSCALL(getgid)
    151f:	b8 19 00 00 00       	mov    $0x19,%eax
    1524:	cd 40                	int    $0x40
    1526:	c3                   	ret    

00001527 <getppid>:
SYSCALL(getppid)
    1527:	b8 1a 00 00 00       	mov    $0x1a,%eax
    152c:	cd 40                	int    $0x40
    152e:	c3                   	ret    

0000152f <setuid>:

SYSCALL(setuid)
    152f:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1534:	cd 40                	int    $0x40
    1536:	c3                   	ret    

00001537 <setgid>:
SYSCALL(setgid)
    1537:	b8 1c 00 00 00       	mov    $0x1c,%eax
    153c:	cd 40                	int    $0x40
    153e:	c3                   	ret    

0000153f <getprocs>:
SYSCALL(getprocs)
    153f:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1544:	cd 40                	int    $0x40
    1546:	c3                   	ret    

00001547 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1547:	55                   	push   %ebp
    1548:	89 e5                	mov    %esp,%ebp
    154a:	83 ec 18             	sub    $0x18,%esp
    154d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1550:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1553:	83 ec 04             	sub    $0x4,%esp
    1556:	6a 01                	push   $0x1
    1558:	8d 45 f4             	lea    -0xc(%ebp),%eax
    155b:	50                   	push   %eax
    155c:	ff 75 08             	pushl  0x8(%ebp)
    155f:	e8 23 ff ff ff       	call   1487 <write>
    1564:	83 c4 10             	add    $0x10,%esp
}
    1567:	90                   	nop
    1568:	c9                   	leave  
    1569:	c3                   	ret    

0000156a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    156a:	55                   	push   %ebp
    156b:	89 e5                	mov    %esp,%ebp
    156d:	53                   	push   %ebx
    156e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1578:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    157c:	74 17                	je     1595 <printint+0x2b>
    157e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1582:	79 11                	jns    1595 <printint+0x2b>
    neg = 1;
    1584:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    158b:	8b 45 0c             	mov    0xc(%ebp),%eax
    158e:	f7 d8                	neg    %eax
    1590:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1593:	eb 06                	jmp    159b <printint+0x31>
  } else {
    x = xx;
    1595:	8b 45 0c             	mov    0xc(%ebp),%eax
    1598:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    159b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    15a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    15a5:	8d 41 01             	lea    0x1(%ecx),%eax
    15a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    15ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
    15ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15b1:	ba 00 00 00 00       	mov    $0x0,%edx
    15b6:	f7 f3                	div    %ebx
    15b8:	89 d0                	mov    %edx,%eax
    15ba:	0f b6 80 8c 20 00 00 	movzbl 0x208c(%eax),%eax
    15c1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    15c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    15c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15cb:	ba 00 00 00 00       	mov    $0x0,%edx
    15d0:	f7 f3                	div    %ebx
    15d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    15d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15d9:	75 c7                	jne    15a2 <printint+0x38>
  if(neg)
    15db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    15df:	74 2d                	je     160e <printint+0xa4>
    buf[i++] = '-';
    15e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e4:	8d 50 01             	lea    0x1(%eax),%edx
    15e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
    15ea:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    15ef:	eb 1d                	jmp    160e <printint+0xa4>
    putc(fd, buf[i]);
    15f1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    15f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f7:	01 d0                	add    %edx,%eax
    15f9:	0f b6 00             	movzbl (%eax),%eax
    15fc:	0f be c0             	movsbl %al,%eax
    15ff:	83 ec 08             	sub    $0x8,%esp
    1602:	50                   	push   %eax
    1603:	ff 75 08             	pushl  0x8(%ebp)
    1606:	e8 3c ff ff ff       	call   1547 <putc>
    160b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    160e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1616:	79 d9                	jns    15f1 <printint+0x87>
    putc(fd, buf[i]);
}
    1618:	90                   	nop
    1619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    161c:	c9                   	leave  
    161d:	c3                   	ret    

0000161e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    161e:	55                   	push   %ebp
    161f:	89 e5                	mov    %esp,%ebp
    1621:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1624:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    162b:	8d 45 0c             	lea    0xc(%ebp),%eax
    162e:	83 c0 04             	add    $0x4,%eax
    1631:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1634:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    163b:	e9 59 01 00 00       	jmp    1799 <printf+0x17b>
    c = fmt[i] & 0xff;
    1640:	8b 55 0c             	mov    0xc(%ebp),%edx
    1643:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1646:	01 d0                	add    %edx,%eax
    1648:	0f b6 00             	movzbl (%eax),%eax
    164b:	0f be c0             	movsbl %al,%eax
    164e:	25 ff 00 00 00       	and    $0xff,%eax
    1653:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1656:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    165a:	75 2c                	jne    1688 <printf+0x6a>
      if(c == '%'){
    165c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1660:	75 0c                	jne    166e <printf+0x50>
        state = '%';
    1662:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1669:	e9 27 01 00 00       	jmp    1795 <printf+0x177>
      } else {
        putc(fd, c);
    166e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1671:	0f be c0             	movsbl %al,%eax
    1674:	83 ec 08             	sub    $0x8,%esp
    1677:	50                   	push   %eax
    1678:	ff 75 08             	pushl  0x8(%ebp)
    167b:	e8 c7 fe ff ff       	call   1547 <putc>
    1680:	83 c4 10             	add    $0x10,%esp
    1683:	e9 0d 01 00 00       	jmp    1795 <printf+0x177>
      }
    } else if(state == '%'){
    1688:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    168c:	0f 85 03 01 00 00    	jne    1795 <printf+0x177>
      if(c == 'd'){
    1692:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1696:	75 1e                	jne    16b6 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1698:	8b 45 e8             	mov    -0x18(%ebp),%eax
    169b:	8b 00                	mov    (%eax),%eax
    169d:	6a 01                	push   $0x1
    169f:	6a 0a                	push   $0xa
    16a1:	50                   	push   %eax
    16a2:	ff 75 08             	pushl  0x8(%ebp)
    16a5:	e8 c0 fe ff ff       	call   156a <printint>
    16aa:	83 c4 10             	add    $0x10,%esp
        ap++;
    16ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16b1:	e9 d8 00 00 00       	jmp    178e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    16b6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    16ba:	74 06                	je     16c2 <printf+0xa4>
    16bc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    16c0:	75 1e                	jne    16e0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    16c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16c5:	8b 00                	mov    (%eax),%eax
    16c7:	6a 00                	push   $0x0
    16c9:	6a 10                	push   $0x10
    16cb:	50                   	push   %eax
    16cc:	ff 75 08             	pushl  0x8(%ebp)
    16cf:	e8 96 fe ff ff       	call   156a <printint>
    16d4:	83 c4 10             	add    $0x10,%esp
        ap++;
    16d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16db:	e9 ae 00 00 00       	jmp    178e <printf+0x170>
      } else if(c == 's'){
    16e0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16e4:	75 43                	jne    1729 <printf+0x10b>
        s = (char*)*ap;
    16e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16e9:	8b 00                	mov    (%eax),%eax
    16eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16f6:	75 25                	jne    171d <printf+0xff>
          s = "(null)";
    16f8:	c7 45 f4 1c 1b 00 00 	movl   $0x1b1c,-0xc(%ebp)
        while(*s != 0){
    16ff:	eb 1c                	jmp    171d <printf+0xff>
          putc(fd, *s);
    1701:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1704:	0f b6 00             	movzbl (%eax),%eax
    1707:	0f be c0             	movsbl %al,%eax
    170a:	83 ec 08             	sub    $0x8,%esp
    170d:	50                   	push   %eax
    170e:	ff 75 08             	pushl  0x8(%ebp)
    1711:	e8 31 fe ff ff       	call   1547 <putc>
    1716:	83 c4 10             	add    $0x10,%esp
          s++;
    1719:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1720:	0f b6 00             	movzbl (%eax),%eax
    1723:	84 c0                	test   %al,%al
    1725:	75 da                	jne    1701 <printf+0xe3>
    1727:	eb 65                	jmp    178e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1729:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    172d:	75 1d                	jne    174c <printf+0x12e>
        putc(fd, *ap);
    172f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1732:	8b 00                	mov    (%eax),%eax
    1734:	0f be c0             	movsbl %al,%eax
    1737:	83 ec 08             	sub    $0x8,%esp
    173a:	50                   	push   %eax
    173b:	ff 75 08             	pushl  0x8(%ebp)
    173e:	e8 04 fe ff ff       	call   1547 <putc>
    1743:	83 c4 10             	add    $0x10,%esp
        ap++;
    1746:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    174a:	eb 42                	jmp    178e <printf+0x170>
      } else if(c == '%'){
    174c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1750:	75 17                	jne    1769 <printf+0x14b>
        putc(fd, c);
    1752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1755:	0f be c0             	movsbl %al,%eax
    1758:	83 ec 08             	sub    $0x8,%esp
    175b:	50                   	push   %eax
    175c:	ff 75 08             	pushl  0x8(%ebp)
    175f:	e8 e3 fd ff ff       	call   1547 <putc>
    1764:	83 c4 10             	add    $0x10,%esp
    1767:	eb 25                	jmp    178e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1769:	83 ec 08             	sub    $0x8,%esp
    176c:	6a 25                	push   $0x25
    176e:	ff 75 08             	pushl  0x8(%ebp)
    1771:	e8 d1 fd ff ff       	call   1547 <putc>
    1776:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    177c:	0f be c0             	movsbl %al,%eax
    177f:	83 ec 08             	sub    $0x8,%esp
    1782:	50                   	push   %eax
    1783:	ff 75 08             	pushl  0x8(%ebp)
    1786:	e8 bc fd ff ff       	call   1547 <putc>
    178b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    178e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1795:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1799:	8b 55 0c             	mov    0xc(%ebp),%edx
    179c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    179f:	01 d0                	add    %edx,%eax
    17a1:	0f b6 00             	movzbl (%eax),%eax
    17a4:	84 c0                	test   %al,%al
    17a6:	0f 85 94 fe ff ff    	jne    1640 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    17ac:	90                   	nop
    17ad:	c9                   	leave  
    17ae:	c3                   	ret    

000017af <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17af:	55                   	push   %ebp
    17b0:	89 e5                	mov    %esp,%ebp
    17b2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17b5:	8b 45 08             	mov    0x8(%ebp),%eax
    17b8:	83 e8 08             	sub    $0x8,%eax
    17bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17be:	a1 0c 21 00 00       	mov    0x210c,%eax
    17c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17c6:	eb 24                	jmp    17ec <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17cb:	8b 00                	mov    (%eax),%eax
    17cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17d0:	77 12                	ja     17e4 <free+0x35>
    17d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17d8:	77 24                	ja     17fe <free+0x4f>
    17da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17dd:	8b 00                	mov    (%eax),%eax
    17df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17e2:	77 1a                	ja     17fe <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e7:	8b 00                	mov    (%eax),%eax
    17e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17f2:	76 d4                	jbe    17c8 <free+0x19>
    17f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f7:	8b 00                	mov    (%eax),%eax
    17f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17fc:	76 ca                	jbe    17c8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1801:	8b 40 04             	mov    0x4(%eax),%eax
    1804:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    180e:	01 c2                	add    %eax,%edx
    1810:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1813:	8b 00                	mov    (%eax),%eax
    1815:	39 c2                	cmp    %eax,%edx
    1817:	75 24                	jne    183d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1819:	8b 45 f8             	mov    -0x8(%ebp),%eax
    181c:	8b 50 04             	mov    0x4(%eax),%edx
    181f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1822:	8b 00                	mov    (%eax),%eax
    1824:	8b 40 04             	mov    0x4(%eax),%eax
    1827:	01 c2                	add    %eax,%edx
    1829:	8b 45 f8             	mov    -0x8(%ebp),%eax
    182c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1832:	8b 00                	mov    (%eax),%eax
    1834:	8b 10                	mov    (%eax),%edx
    1836:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1839:	89 10                	mov    %edx,(%eax)
    183b:	eb 0a                	jmp    1847 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    183d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1840:	8b 10                	mov    (%eax),%edx
    1842:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1845:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1847:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184a:	8b 40 04             	mov    0x4(%eax),%eax
    184d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1854:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1857:	01 d0                	add    %edx,%eax
    1859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    185c:	75 20                	jne    187e <free+0xcf>
    p->s.size += bp->s.size;
    185e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1861:	8b 50 04             	mov    0x4(%eax),%edx
    1864:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1867:	8b 40 04             	mov    0x4(%eax),%eax
    186a:	01 c2                	add    %eax,%edx
    186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    186f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1872:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1875:	8b 10                	mov    (%eax),%edx
    1877:	8b 45 fc             	mov    -0x4(%ebp),%eax
    187a:	89 10                	mov    %edx,(%eax)
    187c:	eb 08                	jmp    1886 <free+0xd7>
  } else
    p->s.ptr = bp;
    187e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1881:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1884:	89 10                	mov    %edx,(%eax)
  freep = p;
    1886:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1889:	a3 0c 21 00 00       	mov    %eax,0x210c
}
    188e:	90                   	nop
    188f:	c9                   	leave  
    1890:	c3                   	ret    

00001891 <morecore>:

static Header*
morecore(uint nu)
{
    1891:	55                   	push   %ebp
    1892:	89 e5                	mov    %esp,%ebp
    1894:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1897:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    189e:	77 07                	ja     18a7 <morecore+0x16>
    nu = 4096;
    18a0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    18a7:	8b 45 08             	mov    0x8(%ebp),%eax
    18aa:	c1 e0 03             	shl    $0x3,%eax
    18ad:	83 ec 0c             	sub    $0xc,%esp
    18b0:	50                   	push   %eax
    18b1:	e8 39 fc ff ff       	call   14ef <sbrk>
    18b6:	83 c4 10             	add    $0x10,%esp
    18b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    18bc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    18c0:	75 07                	jne    18c9 <morecore+0x38>
    return 0;
    18c2:	b8 00 00 00 00       	mov    $0x0,%eax
    18c7:	eb 26                	jmp    18ef <morecore+0x5e>
  hp = (Header*)p;
    18c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    18cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18d2:	8b 55 08             	mov    0x8(%ebp),%edx
    18d5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    18d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18db:	83 c0 08             	add    $0x8,%eax
    18de:	83 ec 0c             	sub    $0xc,%esp
    18e1:	50                   	push   %eax
    18e2:	e8 c8 fe ff ff       	call   17af <free>
    18e7:	83 c4 10             	add    $0x10,%esp
  return freep;
    18ea:	a1 0c 21 00 00       	mov    0x210c,%eax
}
    18ef:	c9                   	leave  
    18f0:	c3                   	ret    

000018f1 <malloc>:

void*
malloc(uint nbytes)
{
    18f1:	55                   	push   %ebp
    18f2:	89 e5                	mov    %esp,%ebp
    18f4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18f7:	8b 45 08             	mov    0x8(%ebp),%eax
    18fa:	83 c0 07             	add    $0x7,%eax
    18fd:	c1 e8 03             	shr    $0x3,%eax
    1900:	83 c0 01             	add    $0x1,%eax
    1903:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1906:	a1 0c 21 00 00       	mov    0x210c,%eax
    190b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    190e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1912:	75 23                	jne    1937 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1914:	c7 45 f0 04 21 00 00 	movl   $0x2104,-0x10(%ebp)
    191b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    191e:	a3 0c 21 00 00       	mov    %eax,0x210c
    1923:	a1 0c 21 00 00       	mov    0x210c,%eax
    1928:	a3 04 21 00 00       	mov    %eax,0x2104
    base.s.size = 0;
    192d:	c7 05 08 21 00 00 00 	movl   $0x0,0x2108
    1934:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1937:	8b 45 f0             	mov    -0x10(%ebp),%eax
    193a:	8b 00                	mov    (%eax),%eax
    193c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1942:	8b 40 04             	mov    0x4(%eax),%eax
    1945:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1948:	72 4d                	jb     1997 <malloc+0xa6>
      if(p->s.size == nunits)
    194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194d:	8b 40 04             	mov    0x4(%eax),%eax
    1950:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1953:	75 0c                	jne    1961 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1955:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1958:	8b 10                	mov    (%eax),%edx
    195a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    195d:	89 10                	mov    %edx,(%eax)
    195f:	eb 26                	jmp    1987 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1961:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1964:	8b 40 04             	mov    0x4(%eax),%eax
    1967:	2b 45 ec             	sub    -0x14(%ebp),%eax
    196a:	89 c2                	mov    %eax,%edx
    196c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1972:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1975:	8b 40 04             	mov    0x4(%eax),%eax
    1978:	c1 e0 03             	shl    $0x3,%eax
    197b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1981:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1984:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1987:	8b 45 f0             	mov    -0x10(%ebp),%eax
    198a:	a3 0c 21 00 00       	mov    %eax,0x210c
      return (void*)(p + 1);
    198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1992:	83 c0 08             	add    $0x8,%eax
    1995:	eb 3b                	jmp    19d2 <malloc+0xe1>
    }
    if(p == freep)
    1997:	a1 0c 21 00 00       	mov    0x210c,%eax
    199c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    199f:	75 1e                	jne    19bf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    19a1:	83 ec 0c             	sub    $0xc,%esp
    19a4:	ff 75 ec             	pushl  -0x14(%ebp)
    19a7:	e8 e5 fe ff ff       	call   1891 <morecore>
    19ac:	83 c4 10             	add    $0x10,%esp
    19af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    19b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19b6:	75 07                	jne    19bf <malloc+0xce>
        return 0;
    19b8:	b8 00 00 00 00       	mov    $0x0,%eax
    19bd:	eb 13                	jmp    19d2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    19c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19c8:	8b 00                	mov    (%eax),%eax
    19ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    19cd:	e9 6d ff ff ff       	jmp    193f <malloc+0x4e>
}
    19d2:	c9                   	leave  
    19d3:	c3                   	ret    
