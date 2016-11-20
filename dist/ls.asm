
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:

extern void print_mode(struct stat* st);

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 a5 06 00 00       	call   6b7 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 71 06 00 00       	call   6b7 <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 59 06 00 00       	call   6b7 <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 44 11 00 00       	push   $0x1144
  6d:	e8 c2 07 00 00       	call   834 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 37 06 00 00       	call   6b7 <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 20 06 00 00       	call   6b7 <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 44 11 00 00       	add    $0x1144,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 33 06 00 00       	call   6de <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 44 11 00 00       	mov    $0x1144,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 e8 07 00 00       	call   8b9 <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 e8 0d 00 00       	push   $0xde8
  e8:	6a 02                	push   $0x2
  ea:	e8 41 09 00 00       	call   a30 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 45 02 00 00       	jmp    33c <ls+0x284>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 c8 07 00 00       	call   8d1 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 fc 0d 00 00       	push   $0xdfc
 11b:	6a 02                	push   $0x2
 11d:	e8 0e 09 00 00       	call   a30 <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 71 07 00 00       	call   8a1 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 04 02 00 00       	jmp    33c <ls+0x284>
  }

  #ifdef CS333_P4
  // Print Header
  printf(1, "MODE\t\tNAME\t\tUID\tGID\tINODE\tSIZE\n");
 138:	83 ec 08             	sub    $0x8,%esp
 13b:	68 10 0e 00 00       	push   $0xe10
 140:	6a 01                	push   $0x1
 142:	e8 e9 08 00 00       	call   a30 <printf>
 147:	83 c4 10             	add    $0x10,%esp
  #endif
 
  switch(st.type){
 14a:	0f b7 85 b4 fd ff ff 	movzwl -0x24c(%ebp),%eax
 151:	98                   	cwtl   
 152:	83 f8 01             	cmp    $0x1,%eax
 155:	74 70                	je     1c7 <ls+0x10f>
 157:	83 f8 02             	cmp    $0x2,%eax
 15a:	0f 85 ce 01 00 00    	jne    32e <ls+0x276>
  case T_FILE:
    #ifdef CS333_P4
    print_mode(&st);
 160:	83 ec 0c             	sub    $0xc,%esp
 163:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 169:	50                   	push   %eax
 16a:	e8 39 02 00 00       	call   3a8 <print_mode>
 16f:	83 c4 10             	add    $0x10,%esp
    printf(1, "\t%s\t%d\t%d\t%d\t%d\n", fmtname(path), st.uid, st.gid,  st.ino, st.size);
 172:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 178:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 17e:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 184:	0f b7 85 ca fd ff ff 	movzwl -0x236(%ebp),%eax
 18b:	0f b7 f0             	movzwl %ax,%esi
 18e:	0f b7 85 c8 fd ff ff 	movzwl -0x238(%ebp),%eax
 195:	0f b7 d8             	movzwl %ax,%ebx
 198:	83 ec 0c             	sub    $0xc,%esp
 19b:	ff 75 08             	pushl  0x8(%ebp)
 19e:	e8 5d fe ff ff       	call   0 <fmtname>
 1a3:	83 c4 10             	add    $0x10,%esp
 1a6:	83 ec 04             	sub    $0x4,%esp
 1a9:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 1af:	57                   	push   %edi
 1b0:	56                   	push   %esi
 1b1:	53                   	push   %ebx
 1b2:	50                   	push   %eax
 1b3:	68 30 0e 00 00       	push   $0xe30
 1b8:	6a 01                	push   $0x1
 1ba:	e8 71 08 00 00       	call   a30 <printf>
 1bf:	83 c4 20             	add    $0x20,%esp
    #else
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    #endif
    break;
 1c2:	e9 67 01 00 00       	jmp    32e <ls+0x276>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1c7:	83 ec 0c             	sub    $0xc,%esp
 1ca:	ff 75 08             	pushl  0x8(%ebp)
 1cd:	e8 e5 04 00 00       	call   6b7 <strlen>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	83 c0 10             	add    $0x10,%eax
 1d8:	3d 00 02 00 00       	cmp    $0x200,%eax
 1dd:	76 17                	jbe    1f6 <ls+0x13e>
      printf(1, "ls: path too long\n");
 1df:	83 ec 08             	sub    $0x8,%esp
 1e2:	68 41 0e 00 00       	push   $0xe41
 1e7:	6a 01                	push   $0x1
 1e9:	e8 42 08 00 00       	call   a30 <printf>
 1ee:	83 c4 10             	add    $0x10,%esp
      break;
 1f1:	e9 38 01 00 00       	jmp    32e <ls+0x276>
    }
    strcpy(buf, path);
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	ff 75 08             	pushl  0x8(%ebp)
 1fc:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 202:	50                   	push   %eax
 203:	e8 40 04 00 00       	call   648 <strcpy>
 208:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 20b:	83 ec 0c             	sub    $0xc,%esp
 20e:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 214:	50                   	push   %eax
 215:	e8 9d 04 00 00       	call   6b7 <strlen>
 21a:	83 c4 10             	add    $0x10,%esp
 21d:	89 c2                	mov    %eax,%edx
 21f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 225:	01 d0                	add    %edx,%eax
 227:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 22a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22d:	8d 50 01             	lea    0x1(%eax),%edx
 230:	89 55 e0             	mov    %edx,-0x20(%ebp)
 233:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 236:	e9 d2 00 00 00       	jmp    30d <ls+0x255>
      if(de.inum == 0)
 23b:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 242:	66 85 c0             	test   %ax,%ax
 245:	75 05                	jne    24c <ls+0x194>
        continue;
 247:	e9 c1 00 00 00       	jmp    30d <ls+0x255>
      memmove(p, de.name, DIRSIZ);
 24c:	83 ec 04             	sub    $0x4,%esp
 24f:	6a 0e                	push   $0xe
 251:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 257:	83 c0 02             	add    $0x2,%eax
 25a:	50                   	push   %eax
 25b:	ff 75 e0             	pushl  -0x20(%ebp)
 25e:	e8 d1 05 00 00       	call   834 <memmove>
 263:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 266:	8b 45 e0             	mov    -0x20(%ebp),%eax
 269:	83 c0 0e             	add    $0xe,%eax
 26c:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 26f:	83 ec 08             	sub    $0x8,%esp
 272:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 278:	50                   	push   %eax
 279:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 27f:	50                   	push   %eax
 280:	e8 15 05 00 00       	call   79a <stat>
 285:	83 c4 10             	add    $0x10,%esp
 288:	85 c0                	test   %eax,%eax
 28a:	79 1b                	jns    2a7 <ls+0x1ef>
        printf(1, "ls: cannot stat %s\n", buf);
 28c:	83 ec 04             	sub    $0x4,%esp
 28f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 295:	50                   	push   %eax
 296:	68 fc 0d 00 00       	push   $0xdfc
 29b:	6a 01                	push   $0x1
 29d:	e8 8e 07 00 00       	call   a30 <printf>
 2a2:	83 c4 10             	add    $0x10,%esp
        continue;
 2a5:	eb 66                	jmp    30d <ls+0x255>
      }
      #ifdef CS333_P4
      print_mode(&st);
 2a7:	83 ec 0c             	sub    $0xc,%esp
 2aa:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 2b0:	50                   	push   %eax
 2b1:	e8 f2 00 00 00       	call   3a8 <print_mode>
 2b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "\t%s\t%d\t%d\t%d\t%d\n", fmtname(buf), st.uid, st.gid,  st.ino, st.size);
 2b9:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 2bf:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 2c5:	8b bd bc fd ff ff    	mov    -0x244(%ebp),%edi
 2cb:	0f b7 85 ca fd ff ff 	movzwl -0x236(%ebp),%eax
 2d2:	0f b7 f0             	movzwl %ax,%esi
 2d5:	0f b7 85 c8 fd ff ff 	movzwl -0x238(%ebp),%eax
 2dc:	0f b7 d8             	movzwl %ax,%ebx
 2df:	83 ec 0c             	sub    $0xc,%esp
 2e2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 2e8:	50                   	push   %eax
 2e9:	e8 12 fd ff ff       	call   0 <fmtname>
 2ee:	83 c4 10             	add    $0x10,%esp
 2f1:	83 ec 04             	sub    $0x4,%esp
 2f4:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 2fa:	57                   	push   %edi
 2fb:	56                   	push   %esi
 2fc:	53                   	push   %ebx
 2fd:	50                   	push   %eax
 2fe:	68 30 0e 00 00       	push   $0xe30
 303:	6a 01                	push   $0x1
 305:	e8 26 07 00 00       	call   a30 <printf>
 30a:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 30d:	83 ec 04             	sub    $0x4,%esp
 310:	6a 10                	push   $0x10
 312:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 318:	50                   	push   %eax
 319:	ff 75 e4             	pushl  -0x1c(%ebp)
 31c:	e8 70 05 00 00       	call   891 <read>
 321:	83 c4 10             	add    $0x10,%esp
 324:	83 f8 10             	cmp    $0x10,%eax
 327:	0f 84 0e ff ff ff    	je     23b <ls+0x183>
      printf(1, "\t%s\t%d\t%d\t%d\t%d\n", fmtname(buf), st.uid, st.gid,  st.ino, st.size);
      #else
      printf(1, "\t%s\t%d\t%d\t%d\n", fmtname(buf), st.type, st.ino, st.size);
      #endif
    }
    break;
 32d:	90                   	nop
  }
  close(fd);
 32e:	83 ec 0c             	sub    $0xc,%esp
 331:	ff 75 e4             	pushl  -0x1c(%ebp)
 334:	e8 68 05 00 00       	call   8a1 <close>
 339:	83 c4 10             	add    $0x10,%esp
}
 33c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33f:	5b                   	pop    %ebx
 340:	5e                   	pop    %esi
 341:	5f                   	pop    %edi
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    

00000344 <main>:

int
main(int argc, char *argv[])
{
 344:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 348:	83 e4 f0             	and    $0xfffffff0,%esp
 34b:	ff 71 fc             	pushl  -0x4(%ecx)
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	53                   	push   %ebx
 352:	51                   	push   %ecx
 353:	83 ec 10             	sub    $0x10,%esp
 356:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 358:	83 3b 01             	cmpl   $0x1,(%ebx)
 35b:	7f 15                	jg     372 <main+0x2e>
    ls(".");
 35d:	83 ec 0c             	sub    $0xc,%esp
 360:	68 54 0e 00 00       	push   $0xe54
 365:	e8 4e fd ff ff       	call   b8 <ls>
 36a:	83 c4 10             	add    $0x10,%esp
    exit();
 36d:	e8 07 05 00 00       	call   879 <exit>
  }
  for(i=1; i<argc; i++)
 372:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 379:	eb 21                	jmp    39c <main+0x58>
    ls(argv[i]);
 37b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 385:	8b 43 04             	mov    0x4(%ebx),%eax
 388:	01 d0                	add    %edx,%eax
 38a:	8b 00                	mov    (%eax),%eax
 38c:	83 ec 0c             	sub    $0xc,%esp
 38f:	50                   	push   %eax
 390:	e8 23 fd ff ff       	call   b8 <ls>
 395:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 398:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 39c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39f:	3b 03                	cmp    (%ebx),%eax
 3a1:	7c d8                	jl     37b <main+0x37>
    ls(argv[i]);
  exit();
 3a3:	e8 d1 04 00 00       	call   879 <exit>

000003a8 <print_mode>:
#include "types.h"
#include "stat.h"
#include "user.h"
void
print_mode(struct stat* st)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
 3b1:	0f b7 00             	movzwl (%eax),%eax
 3b4:	98                   	cwtl   
 3b5:	83 f8 02             	cmp    $0x2,%eax
 3b8:	74 1e                	je     3d8 <print_mode+0x30>
 3ba:	83 f8 03             	cmp    $0x3,%eax
 3bd:	74 2d                	je     3ec <print_mode+0x44>
 3bf:	83 f8 01             	cmp    $0x1,%eax
 3c2:	75 3c                	jne    400 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
 3c4:	83 ec 08             	sub    $0x8,%esp
 3c7:	68 56 0e 00 00       	push   $0xe56
 3cc:	6a 01                	push   $0x1
 3ce:	e8 5d 06 00 00       	call   a30 <printf>
 3d3:	83 c4 10             	add    $0x10,%esp
 3d6:	eb 3a                	jmp    412 <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
 3d8:	83 ec 08             	sub    $0x8,%esp
 3db:	68 58 0e 00 00       	push   $0xe58
 3e0:	6a 01                	push   $0x1
 3e2:	e8 49 06 00 00       	call   a30 <printf>
 3e7:	83 c4 10             	add    $0x10,%esp
 3ea:	eb 26                	jmp    412 <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
 3ec:	83 ec 08             	sub    $0x8,%esp
 3ef:	68 5a 0e 00 00       	push   $0xe5a
 3f4:	6a 01                	push   $0x1
 3f6:	e8 35 06 00 00       	call   a30 <printf>
 3fb:	83 c4 10             	add    $0x10,%esp
 3fe:	eb 12                	jmp    412 <print_mode+0x6a>
    default: printf(1, "?");
 400:	83 ec 08             	sub    $0x8,%esp
 403:	68 5c 0e 00 00       	push   $0xe5c
 408:	6a 01                	push   $0x1
 40a:	e8 21 06 00 00       	call   a30 <printf>
 40f:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 419:	83 e0 01             	and    $0x1,%eax
 41c:	84 c0                	test   %al,%al
 41e:	74 14                	je     434 <print_mode+0x8c>
    printf(1, "r");
 420:	83 ec 08             	sub    $0x8,%esp
 423:	68 5e 0e 00 00       	push   $0xe5e
 428:	6a 01                	push   $0x1
 42a:	e8 01 06 00 00       	call   a30 <printf>
 42f:	83 c4 10             	add    $0x10,%esp
 432:	eb 12                	jmp    446 <print_mode+0x9e>
  else
    printf(1, "-");
 434:	83 ec 08             	sub    $0x8,%esp
 437:	68 58 0e 00 00       	push   $0xe58
 43c:	6a 01                	push   $0x1
 43e:	e8 ed 05 00 00       	call   a30 <printf>
 443:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 44d:	83 e0 80             	and    $0xffffff80,%eax
 450:	84 c0                	test   %al,%al
 452:	74 14                	je     468 <print_mode+0xc0>
    printf(1, "w");
 454:	83 ec 08             	sub    $0x8,%esp
 457:	68 60 0e 00 00       	push   $0xe60
 45c:	6a 01                	push   $0x1
 45e:	e8 cd 05 00 00       	call   a30 <printf>
 463:	83 c4 10             	add    $0x10,%esp
 466:	eb 12                	jmp    47a <print_mode+0xd2>
  else
    printf(1, "-");
 468:	83 ec 08             	sub    $0x8,%esp
 46b:	68 58 0e 00 00       	push   $0xe58
 470:	6a 01                	push   $0x1
 472:	e8 b9 05 00 00       	call   a30 <printf>
 477:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 481:	c0 e8 06             	shr    $0x6,%al
 484:	83 e0 01             	and    $0x1,%eax
 487:	0f b6 d0             	movzbl %al,%edx
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	0f b6 40 19          	movzbl 0x19(%eax),%eax
 491:	d0 e8                	shr    %al
 493:	83 e0 01             	and    $0x1,%eax
 496:	0f b6 c0             	movzbl %al,%eax
 499:	21 d0                	and    %edx,%eax
 49b:	85 c0                	test   %eax,%eax
 49d:	74 14                	je     4b3 <print_mode+0x10b>
    printf(1, "S");
 49f:	83 ec 08             	sub    $0x8,%esp
 4a2:	68 62 0e 00 00       	push   $0xe62
 4a7:	6a 01                	push   $0x1
 4a9:	e8 82 05 00 00       	call   a30 <printf>
 4ae:	83 c4 10             	add    $0x10,%esp
 4b1:	eb 34                	jmp    4e7 <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 4ba:	83 e0 40             	and    $0x40,%eax
 4bd:	84 c0                	test   %al,%al
 4bf:	74 14                	je     4d5 <print_mode+0x12d>
    printf(1, "x");
 4c1:	83 ec 08             	sub    $0x8,%esp
 4c4:	68 64 0e 00 00       	push   $0xe64
 4c9:	6a 01                	push   $0x1
 4cb:	e8 60 05 00 00       	call   a30 <printf>
 4d0:	83 c4 10             	add    $0x10,%esp
 4d3:	eb 12                	jmp    4e7 <print_mode+0x13f>
  else
    printf(1, "-");
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	68 58 0e 00 00       	push   $0xe58
 4dd:	6a 01                	push   $0x1
 4df:	e8 4c 05 00 00       	call   a30 <printf>
 4e4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 4ee:	83 e0 20             	and    $0x20,%eax
 4f1:	84 c0                	test   %al,%al
 4f3:	74 14                	je     509 <print_mode+0x161>
    printf(1, "r");
 4f5:	83 ec 08             	sub    $0x8,%esp
 4f8:	68 5e 0e 00 00       	push   $0xe5e
 4fd:	6a 01                	push   $0x1
 4ff:	e8 2c 05 00 00       	call   a30 <printf>
 504:	83 c4 10             	add    $0x10,%esp
 507:	eb 12                	jmp    51b <print_mode+0x173>
  else
    printf(1, "-");
 509:	83 ec 08             	sub    $0x8,%esp
 50c:	68 58 0e 00 00       	push   $0xe58
 511:	6a 01                	push   $0x1
 513:	e8 18 05 00 00       	call   a30 <printf>
 518:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 522:	83 e0 10             	and    $0x10,%eax
 525:	84 c0                	test   %al,%al
 527:	74 14                	je     53d <print_mode+0x195>
    printf(1, "w");
 529:	83 ec 08             	sub    $0x8,%esp
 52c:	68 60 0e 00 00       	push   $0xe60
 531:	6a 01                	push   $0x1
 533:	e8 f8 04 00 00       	call   a30 <printf>
 538:	83 c4 10             	add    $0x10,%esp
 53b:	eb 12                	jmp    54f <print_mode+0x1a7>
  else
    printf(1, "-");
 53d:	83 ec 08             	sub    $0x8,%esp
 540:	68 58 0e 00 00       	push   $0xe58
 545:	6a 01                	push   $0x1
 547:	e8 e4 04 00 00       	call   a30 <printf>
 54c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 556:	83 e0 08             	and    $0x8,%eax
 559:	84 c0                	test   %al,%al
 55b:	74 14                	je     571 <print_mode+0x1c9>
    printf(1, "x");
 55d:	83 ec 08             	sub    $0x8,%esp
 560:	68 64 0e 00 00       	push   $0xe64
 565:	6a 01                	push   $0x1
 567:	e8 c4 04 00 00       	call   a30 <printf>
 56c:	83 c4 10             	add    $0x10,%esp
 56f:	eb 12                	jmp    583 <print_mode+0x1db>
  else
    printf(1, "-");
 571:	83 ec 08             	sub    $0x8,%esp
 574:	68 58 0e 00 00       	push   $0xe58
 579:	6a 01                	push   $0x1
 57b:	e8 b0 04 00 00       	call   a30 <printf>
 580:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 58a:	83 e0 04             	and    $0x4,%eax
 58d:	84 c0                	test   %al,%al
 58f:	74 14                	je     5a5 <print_mode+0x1fd>
    printf(1, "r");
 591:	83 ec 08             	sub    $0x8,%esp
 594:	68 5e 0e 00 00       	push   $0xe5e
 599:	6a 01                	push   $0x1
 59b:	e8 90 04 00 00       	call   a30 <printf>
 5a0:	83 c4 10             	add    $0x10,%esp
 5a3:	eb 12                	jmp    5b7 <print_mode+0x20f>
  else
    printf(1, "-");
 5a5:	83 ec 08             	sub    $0x8,%esp
 5a8:	68 58 0e 00 00       	push   $0xe58
 5ad:	6a 01                	push   $0x1
 5af:	e8 7c 04 00 00       	call   a30 <printf>
 5b4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 5be:	83 e0 02             	and    $0x2,%eax
 5c1:	84 c0                	test   %al,%al
 5c3:	74 14                	je     5d9 <print_mode+0x231>
    printf(1, "w");
 5c5:	83 ec 08             	sub    $0x8,%esp
 5c8:	68 60 0e 00 00       	push   $0xe60
 5cd:	6a 01                	push   $0x1
 5cf:	e8 5c 04 00 00       	call   a30 <printf>
 5d4:	83 c4 10             	add    $0x10,%esp
 5d7:	eb 12                	jmp    5eb <print_mode+0x243>
  else
    printf(1, "-");
 5d9:	83 ec 08             	sub    $0x8,%esp
 5dc:	68 58 0e 00 00       	push   $0xe58
 5e1:	6a 01                	push   $0x1
 5e3:	e8 48 04 00 00       	call   a30 <printf>
 5e8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	0f b6 40 18          	movzbl 0x18(%eax),%eax
 5f2:	83 e0 01             	and    $0x1,%eax
 5f5:	84 c0                	test   %al,%al
 5f7:	74 14                	je     60d <print_mode+0x265>
    printf(1, "x");
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	68 64 0e 00 00       	push   $0xe64
 601:	6a 01                	push   $0x1
 603:	e8 28 04 00 00       	call   a30 <printf>
 608:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 60b:	eb 13                	jmp    620 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 60d:	83 ec 08             	sub    $0x8,%esp
 610:	68 58 0e 00 00       	push   $0xe58
 615:	6a 01                	push   $0x1
 617:	e8 14 04 00 00       	call   a30 <printf>
 61c:	83 c4 10             	add    $0x10,%esp

  return;
 61f:	90                   	nop
}
 620:	c9                   	leave  
 621:	c3                   	ret    

00000622 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 622:	55                   	push   %ebp
 623:	89 e5                	mov    %esp,%ebp
 625:	57                   	push   %edi
 626:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 627:	8b 4d 08             	mov    0x8(%ebp),%ecx
 62a:	8b 55 10             	mov    0x10(%ebp),%edx
 62d:	8b 45 0c             	mov    0xc(%ebp),%eax
 630:	89 cb                	mov    %ecx,%ebx
 632:	89 df                	mov    %ebx,%edi
 634:	89 d1                	mov    %edx,%ecx
 636:	fc                   	cld    
 637:	f3 aa                	rep stos %al,%es:(%edi)
 639:	89 ca                	mov    %ecx,%edx
 63b:	89 fb                	mov    %edi,%ebx
 63d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 640:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 643:	90                   	nop
 644:	5b                   	pop    %ebx
 645:	5f                   	pop    %edi
 646:	5d                   	pop    %ebp
 647:	c3                   	ret    

00000648 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 64e:	8b 45 08             	mov    0x8(%ebp),%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 654:	90                   	nop
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	8d 50 01             	lea    0x1(%eax),%edx
 65b:	89 55 08             	mov    %edx,0x8(%ebp)
 65e:	8b 55 0c             	mov    0xc(%ebp),%edx
 661:	8d 4a 01             	lea    0x1(%edx),%ecx
 664:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 667:	0f b6 12             	movzbl (%edx),%edx
 66a:	88 10                	mov    %dl,(%eax)
 66c:	0f b6 00             	movzbl (%eax),%eax
 66f:	84 c0                	test   %al,%al
 671:	75 e2                	jne    655 <strcpy+0xd>
    ;
  return os;
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 676:	c9                   	leave  
 677:	c3                   	ret    

00000678 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 67b:	eb 08                	jmp    685 <strcmp+0xd>
    p++, q++;
 67d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 681:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 685:	8b 45 08             	mov    0x8(%ebp),%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	84 c0                	test   %al,%al
 68d:	74 10                	je     69f <strcmp+0x27>
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	0f b6 10             	movzbl (%eax),%edx
 695:	8b 45 0c             	mov    0xc(%ebp),%eax
 698:	0f b6 00             	movzbl (%eax),%eax
 69b:	38 c2                	cmp    %al,%dl
 69d:	74 de                	je     67d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	0f b6 d0             	movzbl %al,%edx
 6a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	0f b6 c0             	movzbl %al,%eax
 6b1:	29 c2                	sub    %eax,%edx
 6b3:	89 d0                	mov    %edx,%eax
}
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret    

000006b7 <strlen>:

uint
strlen(char *s)
{
 6b7:	55                   	push   %ebp
 6b8:	89 e5                	mov    %esp,%ebp
 6ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6c4:	eb 04                	jmp    6ca <strlen+0x13>
 6c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	01 d0                	add    %edx,%eax
 6d2:	0f b6 00             	movzbl (%eax),%eax
 6d5:	84 c0                	test   %al,%al
 6d7:	75 ed                	jne    6c6 <strlen+0xf>
    ;
  return n;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6dc:	c9                   	leave  
 6dd:	c3                   	ret    

000006de <memset>:

void*
memset(void *dst, int c, uint n)
{
 6de:	55                   	push   %ebp
 6df:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 6e1:	8b 45 10             	mov    0x10(%ebp),%eax
 6e4:	50                   	push   %eax
 6e5:	ff 75 0c             	pushl  0xc(%ebp)
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 32 ff ff ff       	call   622 <stosb>
 6f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 6f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6f6:	c9                   	leave  
 6f7:	c3                   	ret    

000006f8 <strchr>:

char*
strchr(const char *s, char c)
{
 6f8:	55                   	push   %ebp
 6f9:	89 e5                	mov    %esp,%ebp
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 701:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 704:	eb 14                	jmp    71a <strchr+0x22>
    if(*s == c)
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 70f:	75 05                	jne    716 <strchr+0x1e>
      return (char*)s;
 711:	8b 45 08             	mov    0x8(%ebp),%eax
 714:	eb 13                	jmp    729 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 716:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	0f b6 00             	movzbl (%eax),%eax
 720:	84 c0                	test   %al,%al
 722:	75 e2                	jne    706 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 724:	b8 00 00 00 00       	mov    $0x0,%eax
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <gets>:

char*
gets(char *buf, int max)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 738:	eb 42                	jmp    77c <gets+0x51>
    cc = read(0, &c, 1);
 73a:	83 ec 04             	sub    $0x4,%esp
 73d:	6a 01                	push   $0x1
 73f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 742:	50                   	push   %eax
 743:	6a 00                	push   $0x0
 745:	e8 47 01 00 00       	call   891 <read>
 74a:	83 c4 10             	add    $0x10,%esp
 74d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 750:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 754:	7e 33                	jle    789 <gets+0x5e>
      break;
    buf[i++] = c;
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	8d 50 01             	lea    0x1(%eax),%edx
 75c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75f:	89 c2                	mov    %eax,%edx
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	01 c2                	add    %eax,%edx
 766:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 76a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 76c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 770:	3c 0a                	cmp    $0xa,%al
 772:	74 16                	je     78a <gets+0x5f>
 774:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 778:	3c 0d                	cmp    $0xd,%al
 77a:	74 0e                	je     78a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	83 c0 01             	add    $0x1,%eax
 782:	3b 45 0c             	cmp    0xc(%ebp),%eax
 785:	7c b3                	jl     73a <gets+0xf>
 787:	eb 01                	jmp    78a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 789:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 78a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	01 d0                	add    %edx,%eax
 792:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 795:	8b 45 08             	mov    0x8(%ebp),%eax
}
 798:	c9                   	leave  
 799:	c3                   	ret    

0000079a <stat>:

int
stat(char *n, struct stat *st)
{
 79a:	55                   	push   %ebp
 79b:	89 e5                	mov    %esp,%ebp
 79d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7a0:	83 ec 08             	sub    $0x8,%esp
 7a3:	6a 00                	push   $0x0
 7a5:	ff 75 08             	pushl  0x8(%ebp)
 7a8:	e8 0c 01 00 00       	call   8b9 <open>
 7ad:	83 c4 10             	add    $0x10,%esp
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b7:	79 07                	jns    7c0 <stat+0x26>
    return -1;
 7b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7be:	eb 25                	jmp    7e5 <stat+0x4b>
  r = fstat(fd, st);
 7c0:	83 ec 08             	sub    $0x8,%esp
 7c3:	ff 75 0c             	pushl  0xc(%ebp)
 7c6:	ff 75 f4             	pushl  -0xc(%ebp)
 7c9:	e8 03 01 00 00       	call   8d1 <fstat>
 7ce:	83 c4 10             	add    $0x10,%esp
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7d4:	83 ec 0c             	sub    $0xc,%esp
 7d7:	ff 75 f4             	pushl  -0xc(%ebp)
 7da:	e8 c2 00 00 00       	call   8a1 <close>
 7df:	83 c4 10             	add    $0x10,%esp
  return r;
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    

000007e7 <atoi>:

int
atoi(const char *s)
{
 7e7:	55                   	push   %ebp
 7e8:	89 e5                	mov    %esp,%ebp
 7ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7f4:	eb 25                	jmp    81b <atoi+0x34>
    n = n*10 + *s++ - '0';
 7f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7f9:	89 d0                	mov    %edx,%eax
 7fb:	c1 e0 02             	shl    $0x2,%eax
 7fe:	01 d0                	add    %edx,%eax
 800:	01 c0                	add    %eax,%eax
 802:	89 c1                	mov    %eax,%ecx
 804:	8b 45 08             	mov    0x8(%ebp),%eax
 807:	8d 50 01             	lea    0x1(%eax),%edx
 80a:	89 55 08             	mov    %edx,0x8(%ebp)
 80d:	0f b6 00             	movzbl (%eax),%eax
 810:	0f be c0             	movsbl %al,%eax
 813:	01 c8                	add    %ecx,%eax
 815:	83 e8 30             	sub    $0x30,%eax
 818:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 81b:	8b 45 08             	mov    0x8(%ebp),%eax
 81e:	0f b6 00             	movzbl (%eax),%eax
 821:	3c 2f                	cmp    $0x2f,%al
 823:	7e 0a                	jle    82f <atoi+0x48>
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	0f b6 00             	movzbl (%eax),%eax
 82b:	3c 39                	cmp    $0x39,%al
 82d:	7e c7                	jle    7f6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 832:	c9                   	leave  
 833:	c3                   	ret    

00000834 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 834:	55                   	push   %ebp
 835:	89 e5                	mov    %esp,%ebp
 837:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 83a:	8b 45 08             	mov    0x8(%ebp),%eax
 83d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 840:	8b 45 0c             	mov    0xc(%ebp),%eax
 843:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 846:	eb 17                	jmp    85f <memmove+0x2b>
    *dst++ = *src++;
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8d 50 01             	lea    0x1(%eax),%edx
 84e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 851:	8b 55 f8             	mov    -0x8(%ebp),%edx
 854:	8d 4a 01             	lea    0x1(%edx),%ecx
 857:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 85a:	0f b6 12             	movzbl (%edx),%edx
 85d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 85f:	8b 45 10             	mov    0x10(%ebp),%eax
 862:	8d 50 ff             	lea    -0x1(%eax),%edx
 865:	89 55 10             	mov    %edx,0x10(%ebp)
 868:	85 c0                	test   %eax,%eax
 86a:	7f dc                	jg     848 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 86f:	c9                   	leave  
 870:	c3                   	ret    

00000871 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 871:	b8 01 00 00 00       	mov    $0x1,%eax
 876:	cd 40                	int    $0x40
 878:	c3                   	ret    

00000879 <exit>:
SYSCALL(exit)
 879:	b8 02 00 00 00       	mov    $0x2,%eax
 87e:	cd 40                	int    $0x40
 880:	c3                   	ret    

00000881 <wait>:
SYSCALL(wait)
 881:	b8 03 00 00 00       	mov    $0x3,%eax
 886:	cd 40                	int    $0x40
 888:	c3                   	ret    

00000889 <pipe>:
SYSCALL(pipe)
 889:	b8 04 00 00 00       	mov    $0x4,%eax
 88e:	cd 40                	int    $0x40
 890:	c3                   	ret    

00000891 <read>:
SYSCALL(read)
 891:	b8 05 00 00 00       	mov    $0x5,%eax
 896:	cd 40                	int    $0x40
 898:	c3                   	ret    

00000899 <write>:
SYSCALL(write)
 899:	b8 10 00 00 00       	mov    $0x10,%eax
 89e:	cd 40                	int    $0x40
 8a0:	c3                   	ret    

000008a1 <close>:
SYSCALL(close)
 8a1:	b8 15 00 00 00       	mov    $0x15,%eax
 8a6:	cd 40                	int    $0x40
 8a8:	c3                   	ret    

000008a9 <kill>:
SYSCALL(kill)
 8a9:	b8 06 00 00 00       	mov    $0x6,%eax
 8ae:	cd 40                	int    $0x40
 8b0:	c3                   	ret    

000008b1 <exec>:
SYSCALL(exec)
 8b1:	b8 07 00 00 00       	mov    $0x7,%eax
 8b6:	cd 40                	int    $0x40
 8b8:	c3                   	ret    

000008b9 <open>:
SYSCALL(open)
 8b9:	b8 0f 00 00 00       	mov    $0xf,%eax
 8be:	cd 40                	int    $0x40
 8c0:	c3                   	ret    

000008c1 <mknod>:
SYSCALL(mknod)
 8c1:	b8 11 00 00 00       	mov    $0x11,%eax
 8c6:	cd 40                	int    $0x40
 8c8:	c3                   	ret    

000008c9 <unlink>:
SYSCALL(unlink)
 8c9:	b8 12 00 00 00       	mov    $0x12,%eax
 8ce:	cd 40                	int    $0x40
 8d0:	c3                   	ret    

000008d1 <fstat>:
SYSCALL(fstat)
 8d1:	b8 08 00 00 00       	mov    $0x8,%eax
 8d6:	cd 40                	int    $0x40
 8d8:	c3                   	ret    

000008d9 <link>:
SYSCALL(link)
 8d9:	b8 13 00 00 00       	mov    $0x13,%eax
 8de:	cd 40                	int    $0x40
 8e0:	c3                   	ret    

000008e1 <mkdir>:
SYSCALL(mkdir)
 8e1:	b8 14 00 00 00       	mov    $0x14,%eax
 8e6:	cd 40                	int    $0x40
 8e8:	c3                   	ret    

000008e9 <chdir>:
SYSCALL(chdir)
 8e9:	b8 09 00 00 00       	mov    $0x9,%eax
 8ee:	cd 40                	int    $0x40
 8f0:	c3                   	ret    

000008f1 <dup>:
SYSCALL(dup)
 8f1:	b8 0a 00 00 00       	mov    $0xa,%eax
 8f6:	cd 40                	int    $0x40
 8f8:	c3                   	ret    

000008f9 <getpid>:
SYSCALL(getpid)
 8f9:	b8 0b 00 00 00       	mov    $0xb,%eax
 8fe:	cd 40                	int    $0x40
 900:	c3                   	ret    

00000901 <sbrk>:
SYSCALL(sbrk)
 901:	b8 0c 00 00 00       	mov    $0xc,%eax
 906:	cd 40                	int    $0x40
 908:	c3                   	ret    

00000909 <sleep>:
SYSCALL(sleep)
 909:	b8 0d 00 00 00       	mov    $0xd,%eax
 90e:	cd 40                	int    $0x40
 910:	c3                   	ret    

00000911 <uptime>:
SYSCALL(uptime)
 911:	b8 0e 00 00 00       	mov    $0xe,%eax
 916:	cd 40                	int    $0x40
 918:	c3                   	ret    

00000919 <halt>:
SYSCALL(halt)
 919:	b8 16 00 00 00       	mov    $0x16,%eax
 91e:	cd 40                	int    $0x40
 920:	c3                   	ret    

00000921 <date>:
//Student Implementations 
SYSCALL(date)
 921:	b8 17 00 00 00       	mov    $0x17,%eax
 926:	cd 40                	int    $0x40
 928:	c3                   	ret    

00000929 <getuid>:

SYSCALL(getuid)
 929:	b8 18 00 00 00       	mov    $0x18,%eax
 92e:	cd 40                	int    $0x40
 930:	c3                   	ret    

00000931 <getgid>:
SYSCALL(getgid)
 931:	b8 19 00 00 00       	mov    $0x19,%eax
 936:	cd 40                	int    $0x40
 938:	c3                   	ret    

00000939 <getppid>:
SYSCALL(getppid)
 939:	b8 1a 00 00 00       	mov    $0x1a,%eax
 93e:	cd 40                	int    $0x40
 940:	c3                   	ret    

00000941 <setuid>:

SYSCALL(setuid)
 941:	b8 1b 00 00 00       	mov    $0x1b,%eax
 946:	cd 40                	int    $0x40
 948:	c3                   	ret    

00000949 <setgid>:
SYSCALL(setgid)
 949:	b8 1c 00 00 00       	mov    $0x1c,%eax
 94e:	cd 40                	int    $0x40
 950:	c3                   	ret    

00000951 <getprocs>:
SYSCALL(getprocs)
 951:	b8 1d 00 00 00       	mov    $0x1d,%eax
 956:	cd 40                	int    $0x40
 958:	c3                   	ret    

00000959 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 959:	55                   	push   %ebp
 95a:	89 e5                	mov    %esp,%ebp
 95c:	83 ec 18             	sub    $0x18,%esp
 95f:	8b 45 0c             	mov    0xc(%ebp),%eax
 962:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 965:	83 ec 04             	sub    $0x4,%esp
 968:	6a 01                	push   $0x1
 96a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 96d:	50                   	push   %eax
 96e:	ff 75 08             	pushl  0x8(%ebp)
 971:	e8 23 ff ff ff       	call   899 <write>
 976:	83 c4 10             	add    $0x10,%esp
}
 979:	90                   	nop
 97a:	c9                   	leave  
 97b:	c3                   	ret    

0000097c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 97c:	55                   	push   %ebp
 97d:	89 e5                	mov    %esp,%ebp
 97f:	53                   	push   %ebx
 980:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 983:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 98a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 98e:	74 17                	je     9a7 <printint+0x2b>
 990:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 994:	79 11                	jns    9a7 <printint+0x2b>
    neg = 1;
 996:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 99d:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a0:	f7 d8                	neg    %eax
 9a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9a5:	eb 06                	jmp    9ad <printint+0x31>
  } else {
    x = xx;
 9a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 9aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9b7:	8d 41 01             	lea    0x1(%ecx),%eax
 9ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9c3:	ba 00 00 00 00       	mov    $0x0,%edx
 9c8:	f7 f3                	div    %ebx
 9ca:	89 d0                	mov    %edx,%eax
 9cc:	0f b6 80 30 11 00 00 	movzbl 0x1130(%eax),%eax
 9d3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9dd:	ba 00 00 00 00       	mov    $0x0,%edx
 9e2:	f7 f3                	div    %ebx
 9e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9eb:	75 c7                	jne    9b4 <printint+0x38>
  if(neg)
 9ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9f1:	74 2d                	je     a20 <printint+0xa4>
    buf[i++] = '-';
 9f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f6:	8d 50 01             	lea    0x1(%eax),%edx
 9f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a01:	eb 1d                	jmp    a20 <printint+0xa4>
    putc(fd, buf[i]);
 a03:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	01 d0                	add    %edx,%eax
 a0b:	0f b6 00             	movzbl (%eax),%eax
 a0e:	0f be c0             	movsbl %al,%eax
 a11:	83 ec 08             	sub    $0x8,%esp
 a14:	50                   	push   %eax
 a15:	ff 75 08             	pushl  0x8(%ebp)
 a18:	e8 3c ff ff ff       	call   959 <putc>
 a1d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a20:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a28:	79 d9                	jns    a03 <printint+0x87>
    putc(fd, buf[i]);
}
 a2a:	90                   	nop
 a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 a2e:	c9                   	leave  
 a2f:	c3                   	ret    

00000a30 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a3d:	8d 45 0c             	lea    0xc(%ebp),%eax
 a40:	83 c0 04             	add    $0x4,%eax
 a43:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a46:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a4d:	e9 59 01 00 00       	jmp    bab <printf+0x17b>
    c = fmt[i] & 0xff;
 a52:	8b 55 0c             	mov    0xc(%ebp),%edx
 a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a58:	01 d0                	add    %edx,%eax
 a5a:	0f b6 00             	movzbl (%eax),%eax
 a5d:	0f be c0             	movsbl %al,%eax
 a60:	25 ff 00 00 00       	and    $0xff,%eax
 a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a6c:	75 2c                	jne    a9a <printf+0x6a>
      if(c == '%'){
 a6e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a72:	75 0c                	jne    a80 <printf+0x50>
        state = '%';
 a74:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a7b:	e9 27 01 00 00       	jmp    ba7 <printf+0x177>
      } else {
        putc(fd, c);
 a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a83:	0f be c0             	movsbl %al,%eax
 a86:	83 ec 08             	sub    $0x8,%esp
 a89:	50                   	push   %eax
 a8a:	ff 75 08             	pushl  0x8(%ebp)
 a8d:	e8 c7 fe ff ff       	call   959 <putc>
 a92:	83 c4 10             	add    $0x10,%esp
 a95:	e9 0d 01 00 00       	jmp    ba7 <printf+0x177>
      }
    } else if(state == '%'){
 a9a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a9e:	0f 85 03 01 00 00    	jne    ba7 <printf+0x177>
      if(c == 'd'){
 aa4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 aa8:	75 1e                	jne    ac8 <printf+0x98>
        printint(fd, *ap, 10, 1);
 aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aad:	8b 00                	mov    (%eax),%eax
 aaf:	6a 01                	push   $0x1
 ab1:	6a 0a                	push   $0xa
 ab3:	50                   	push   %eax
 ab4:	ff 75 08             	pushl  0x8(%ebp)
 ab7:	e8 c0 fe ff ff       	call   97c <printint>
 abc:	83 c4 10             	add    $0x10,%esp
        ap++;
 abf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ac3:	e9 d8 00 00 00       	jmp    ba0 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 ac8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 acc:	74 06                	je     ad4 <printf+0xa4>
 ace:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 ad2:	75 1e                	jne    af2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ad7:	8b 00                	mov    (%eax),%eax
 ad9:	6a 00                	push   $0x0
 adb:	6a 10                	push   $0x10
 add:	50                   	push   %eax
 ade:	ff 75 08             	pushl  0x8(%ebp)
 ae1:	e8 96 fe ff ff       	call   97c <printint>
 ae6:	83 c4 10             	add    $0x10,%esp
        ap++;
 ae9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aed:	e9 ae 00 00 00       	jmp    ba0 <printf+0x170>
      } else if(c == 's'){
 af2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 af6:	75 43                	jne    b3b <printf+0x10b>
        s = (char*)*ap;
 af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 afb:	8b 00                	mov    (%eax),%eax
 afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b00:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b08:	75 25                	jne    b2f <printf+0xff>
          s = "(null)";
 b0a:	c7 45 f4 66 0e 00 00 	movl   $0xe66,-0xc(%ebp)
        while(*s != 0){
 b11:	eb 1c                	jmp    b2f <printf+0xff>
          putc(fd, *s);
 b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b16:	0f b6 00             	movzbl (%eax),%eax
 b19:	0f be c0             	movsbl %al,%eax
 b1c:	83 ec 08             	sub    $0x8,%esp
 b1f:	50                   	push   %eax
 b20:	ff 75 08             	pushl  0x8(%ebp)
 b23:	e8 31 fe ff ff       	call   959 <putc>
 b28:	83 c4 10             	add    $0x10,%esp
          s++;
 b2b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b32:	0f b6 00             	movzbl (%eax),%eax
 b35:	84 c0                	test   %al,%al
 b37:	75 da                	jne    b13 <printf+0xe3>
 b39:	eb 65                	jmp    ba0 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b3b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b3f:	75 1d                	jne    b5e <printf+0x12e>
        putc(fd, *ap);
 b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b44:	8b 00                	mov    (%eax),%eax
 b46:	0f be c0             	movsbl %al,%eax
 b49:	83 ec 08             	sub    $0x8,%esp
 b4c:	50                   	push   %eax
 b4d:	ff 75 08             	pushl  0x8(%ebp)
 b50:	e8 04 fe ff ff       	call   959 <putc>
 b55:	83 c4 10             	add    $0x10,%esp
        ap++;
 b58:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b5c:	eb 42                	jmp    ba0 <printf+0x170>
      } else if(c == '%'){
 b5e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b62:	75 17                	jne    b7b <printf+0x14b>
        putc(fd, c);
 b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b67:	0f be c0             	movsbl %al,%eax
 b6a:	83 ec 08             	sub    $0x8,%esp
 b6d:	50                   	push   %eax
 b6e:	ff 75 08             	pushl  0x8(%ebp)
 b71:	e8 e3 fd ff ff       	call   959 <putc>
 b76:	83 c4 10             	add    $0x10,%esp
 b79:	eb 25                	jmp    ba0 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b7b:	83 ec 08             	sub    $0x8,%esp
 b7e:	6a 25                	push   $0x25
 b80:	ff 75 08             	pushl  0x8(%ebp)
 b83:	e8 d1 fd ff ff       	call   959 <putc>
 b88:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 b8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b8e:	0f be c0             	movsbl %al,%eax
 b91:	83 ec 08             	sub    $0x8,%esp
 b94:	50                   	push   %eax
 b95:	ff 75 08             	pushl  0x8(%ebp)
 b98:	e8 bc fd ff ff       	call   959 <putc>
 b9d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 ba0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ba7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 bab:	8b 55 0c             	mov    0xc(%ebp),%edx
 bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb1:	01 d0                	add    %edx,%eax
 bb3:	0f b6 00             	movzbl (%eax),%eax
 bb6:	84 c0                	test   %al,%al
 bb8:	0f 85 94 fe ff ff    	jne    a52 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bbe:	90                   	nop
 bbf:	c9                   	leave  
 bc0:	c3                   	ret    

00000bc1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bc1:	55                   	push   %ebp
 bc2:	89 e5                	mov    %esp,%ebp
 bc4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bc7:	8b 45 08             	mov    0x8(%ebp),%eax
 bca:	83 e8 08             	sub    $0x8,%eax
 bcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd0:	a1 5c 11 00 00       	mov    0x115c,%eax
 bd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bd8:	eb 24                	jmp    bfe <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdd:	8b 00                	mov    (%eax),%eax
 bdf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 be2:	77 12                	ja     bf6 <free+0x35>
 be4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bea:	77 24                	ja     c10 <free+0x4f>
 bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bef:	8b 00                	mov    (%eax),%eax
 bf1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bf4:	77 1a                	ja     c10 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf9:	8b 00                	mov    (%eax),%eax
 bfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c01:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c04:	76 d4                	jbe    bda <free+0x19>
 c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c09:	8b 00                	mov    (%eax),%eax
 c0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c0e:	76 ca                	jbe    bda <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c13:	8b 40 04             	mov    0x4(%eax),%eax
 c16:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c20:	01 c2                	add    %eax,%edx
 c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c25:	8b 00                	mov    (%eax),%eax
 c27:	39 c2                	cmp    %eax,%edx
 c29:	75 24                	jne    c4f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2e:	8b 50 04             	mov    0x4(%eax),%edx
 c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c34:	8b 00                	mov    (%eax),%eax
 c36:	8b 40 04             	mov    0x4(%eax),%eax
 c39:	01 c2                	add    %eax,%edx
 c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c44:	8b 00                	mov    (%eax),%eax
 c46:	8b 10                	mov    (%eax),%edx
 c48:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4b:	89 10                	mov    %edx,(%eax)
 c4d:	eb 0a                	jmp    c59 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c52:	8b 10                	mov    (%eax),%edx
 c54:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c57:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5c:	8b 40 04             	mov    0x4(%eax),%eax
 c5f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c69:	01 d0                	add    %edx,%eax
 c6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c6e:	75 20                	jne    c90 <free+0xcf>
    p->s.size += bp->s.size;
 c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c73:	8b 50 04             	mov    0x4(%eax),%edx
 c76:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c79:	8b 40 04             	mov    0x4(%eax),%eax
 c7c:	01 c2                	add    %eax,%edx
 c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c81:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c87:	8b 10                	mov    (%eax),%edx
 c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c8c:	89 10                	mov    %edx,(%eax)
 c8e:	eb 08                	jmp    c98 <free+0xd7>
  } else
    p->s.ptr = bp;
 c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c93:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c96:	89 10                	mov    %edx,(%eax)
  freep = p;
 c98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9b:	a3 5c 11 00 00       	mov    %eax,0x115c
}
 ca0:	90                   	nop
 ca1:	c9                   	leave  
 ca2:	c3                   	ret    

00000ca3 <morecore>:

static Header*
morecore(uint nu)
{
 ca3:	55                   	push   %ebp
 ca4:	89 e5                	mov    %esp,%ebp
 ca6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ca9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cb0:	77 07                	ja     cb9 <morecore+0x16>
    nu = 4096;
 cb2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 cb9:	8b 45 08             	mov    0x8(%ebp),%eax
 cbc:	c1 e0 03             	shl    $0x3,%eax
 cbf:	83 ec 0c             	sub    $0xc,%esp
 cc2:	50                   	push   %eax
 cc3:	e8 39 fc ff ff       	call   901 <sbrk>
 cc8:	83 c4 10             	add    $0x10,%esp
 ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cce:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cd2:	75 07                	jne    cdb <morecore+0x38>
    return 0;
 cd4:	b8 00 00 00 00       	mov    $0x0,%eax
 cd9:	eb 26                	jmp    d01 <morecore+0x5e>
  hp = (Header*)p;
 cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce4:	8b 55 08             	mov    0x8(%ebp),%edx
 ce7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ced:	83 c0 08             	add    $0x8,%eax
 cf0:	83 ec 0c             	sub    $0xc,%esp
 cf3:	50                   	push   %eax
 cf4:	e8 c8 fe ff ff       	call   bc1 <free>
 cf9:	83 c4 10             	add    $0x10,%esp
  return freep;
 cfc:	a1 5c 11 00 00       	mov    0x115c,%eax
}
 d01:	c9                   	leave  
 d02:	c3                   	ret    

00000d03 <malloc>:

void*
malloc(uint nbytes)
{
 d03:	55                   	push   %ebp
 d04:	89 e5                	mov    %esp,%ebp
 d06:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d09:	8b 45 08             	mov    0x8(%ebp),%eax
 d0c:	83 c0 07             	add    $0x7,%eax
 d0f:	c1 e8 03             	shr    $0x3,%eax
 d12:	83 c0 01             	add    $0x1,%eax
 d15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d18:	a1 5c 11 00 00       	mov    0x115c,%eax
 d1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d24:	75 23                	jne    d49 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 d26:	c7 45 f0 54 11 00 00 	movl   $0x1154,-0x10(%ebp)
 d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d30:	a3 5c 11 00 00       	mov    %eax,0x115c
 d35:	a1 5c 11 00 00       	mov    0x115c,%eax
 d3a:	a3 54 11 00 00       	mov    %eax,0x1154
    base.s.size = 0;
 d3f:	c7 05 58 11 00 00 00 	movl   $0x0,0x1158
 d46:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d4c:	8b 00                	mov    (%eax),%eax
 d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d54:	8b 40 04             	mov    0x4(%eax),%eax
 d57:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d5a:	72 4d                	jb     da9 <malloc+0xa6>
      if(p->s.size == nunits)
 d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5f:	8b 40 04             	mov    0x4(%eax),%eax
 d62:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d65:	75 0c                	jne    d73 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6a:	8b 10                	mov    (%eax),%edx
 d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d6f:	89 10                	mov    %edx,(%eax)
 d71:	eb 26                	jmp    d99 <malloc+0x96>
      else {
        p->s.size -= nunits;
 d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d76:	8b 40 04             	mov    0x4(%eax),%eax
 d79:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d7c:	89 c2                	mov    %eax,%edx
 d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d81:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d87:	8b 40 04             	mov    0x4(%eax),%eax
 d8a:	c1 e0 03             	shl    $0x3,%eax
 d8d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d93:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d96:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d9c:	a3 5c 11 00 00       	mov    %eax,0x115c
      return (void*)(p + 1);
 da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da4:	83 c0 08             	add    $0x8,%eax
 da7:	eb 3b                	jmp    de4 <malloc+0xe1>
    }
    if(p == freep)
 da9:	a1 5c 11 00 00       	mov    0x115c,%eax
 dae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 db1:	75 1e                	jne    dd1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 db3:	83 ec 0c             	sub    $0xc,%esp
 db6:	ff 75 ec             	pushl  -0x14(%ebp)
 db9:	e8 e5 fe ff ff       	call   ca3 <morecore>
 dbe:	83 c4 10             	add    $0x10,%esp
 dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 dc8:	75 07                	jne    dd1 <malloc+0xce>
        return 0;
 dca:	b8 00 00 00 00       	mov    $0x0,%eax
 dcf:	eb 13                	jmp    de4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dda:	8b 00                	mov    (%eax),%eax
 ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ddf:	e9 6d ff ff ff       	jmp    d51 <malloc+0x4e>
}
 de4:	c9                   	leave  
 de5:	c3                   	ret    
