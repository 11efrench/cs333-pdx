8200 // Shell.
8201 // 2015-12-21. Added very simple processing for builtin commands
8202 
8203 #include "types.h"
8204 #include "user.h"
8205 #include "fcntl.h"
8206 
8207 // Parsed command representation
8208 #define EXEC  1
8209 #define REDIR 2
8210 #define PIPE  3
8211 #define LIST  4
8212 #define BACK  5
8213 
8214 #define MAXARGS 10
8215 
8216 struct cmd {
8217   int type;
8218 };
8219 
8220 struct execcmd {
8221   int type;
8222   char *argv[MAXARGS];
8223   char *eargv[MAXARGS];
8224 };
8225 
8226 struct redircmd {
8227   int type;
8228   struct cmd *cmd;
8229   char *file;
8230   char *efile;
8231   int mode;
8232   int fd;
8233 };
8234 
8235 struct pipecmd {
8236   int type;
8237   struct cmd *left;
8238   struct cmd *right;
8239 };
8240 
8241 struct listcmd {
8242   int type;
8243   struct cmd *left;
8244   struct cmd *right;
8245 };
8246 
8247 
8248 
8249 
8250 struct backcmd {
8251   int type;
8252   struct cmd *cmd;
8253 };
8254 
8255 int fork1(void);  // Fork but panics on failure.
8256 void panic(char*);
8257 struct cmd *parsecmd(char*);
8258 
8259 // Execute cmd.  Never returns.
8260 void
8261 runcmd(struct cmd *cmd)
8262 {
8263   int p[2];
8264   struct backcmd *bcmd;
8265   struct execcmd *ecmd;
8266   struct listcmd *lcmd;
8267   struct pipecmd *pcmd;
8268   struct redircmd *rcmd;
8269 
8270   if(cmd == 0)
8271     exit();
8272 
8273   switch(cmd->type){
8274   default:
8275     panic("runcmd");
8276 
8277   case EXEC:
8278     ecmd = (struct execcmd*)cmd;
8279     if(ecmd->argv[0] == 0)
8280       exit();
8281     exec(ecmd->argv[0], ecmd->argv);
8282     printf(2, "exec %s failed\n", ecmd->argv[0]);
8283     break;
8284 
8285   case REDIR:
8286     rcmd = (struct redircmd*)cmd;
8287     close(rcmd->fd);
8288     if(open(rcmd->file, rcmd->mode) < 0){
8289       printf(2, "open %s failed\n", rcmd->file);
8290       exit();
8291     }
8292     runcmd(rcmd->cmd);
8293     break;
8294 
8295   case LIST:
8296     lcmd = (struct listcmd*)cmd;
8297     if(fork1() == 0)
8298       runcmd(lcmd->left);
8299     wait();
8300     runcmd(lcmd->right);
8301     break;
8302 
8303   case PIPE:
8304     pcmd = (struct pipecmd*)cmd;
8305     if(pipe(p) < 0)
8306       panic("pipe");
8307     if(fork1() == 0){
8308       close(1);
8309       dup(p[1]);
8310       close(p[0]);
8311       close(p[1]);
8312       runcmd(pcmd->left);
8313     }
8314     if(fork1() == 0){
8315       close(0);
8316       dup(p[0]);
8317       close(p[0]);
8318       close(p[1]);
8319       runcmd(pcmd->right);
8320     }
8321     close(p[0]);
8322     close(p[1]);
8323     wait();
8324     wait();
8325     break;
8326 
8327   case BACK:
8328     bcmd = (struct backcmd*)cmd;
8329     if(fork1() == 0)
8330       runcmd(bcmd->cmd);
8331     break;
8332   }
8333   exit();
8334 }
8335 
8336 int
8337 getcmd(char *buf, int nbuf)
8338 {
8339   printf(2, "$ ");
8340   memset(buf, 0, nbuf);
8341   gets(buf, nbuf);
8342   if(buf[0] == 0) // EOF
8343     return -1;
8344   return 0;
8345 }
8346 
8347 
8348 
8349 
8350 #ifdef USE_BUILTINS
8351 // ***** processing for shell builtins begins here *****
8352 
8353 int
8354 strncmp(const char *p, const char *q, uint n)
8355 {
8356     while(n > 0 && *p && *p == *q)
8357       n--, p++, q++;
8358     if(n == 0)
8359       return 0;
8360     return (uchar)*p - (uchar)*q;
8361 }
8362 
8363 int
8364 makeint(char *p)
8365 {
8366   int val = 0;
8367 
8368   while ((*p >= '0') && (*p <= '9')) {
8369     val = 10*val + (*p-'0');
8370     ++p;
8371   }
8372   return val;
8373 }
8374 
8375 int
8376 setbuiltin(char *p)
8377 {
8378   int i;
8379 
8380   p += strlen("_set");
8381   while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
8382   if (strncmp("uid", p, 3) == 0) {
8383     p += strlen("uid");
8384     while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
8385     i = makeint(p); // ugly
8386     return (setuid(i));
8387   } else
8388   if (strncmp("gid", p, 3) == 0) {
8389     p += strlen("gid");
8390     while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
8391     i = makeint(p); // ugly
8392     return (setgid(i));
8393   }
8394   printf(2, "Invalid _set parameter\n");
8395   return -1;
8396 }
8397 
8398 
8399 
8400 int
8401 getbuiltin(char *p)
8402 {
8403   p += strlen("_get");
8404   while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
8405   if (strncmp("uid", p, 3) == 0) {
8406     printf(2, "%d\n", getuid());
8407     return 0;
8408   }
8409   if (strncmp("gid", p, 3) == 0) {
8410     printf(2, "%d\n", getgid());
8411     return 0;
8412   }
8413   printf(2, "Invalid _get parameter\n");
8414   return -1;
8415 }
8416 
8417 typedef int funcPtr_t(char *);
8418 typedef struct {
8419   char       *cmd;
8420   funcPtr_t  *name;
8421 } dispatchTableEntry_t;
8422 
8423 // Use a simple function dispatch table (FDT) to process builtin commands
8424 dispatchTableEntry_t fdt[] = {
8425   {"_set", setbuiltin},
8426   {"_get", getbuiltin}
8427 };
8428 int FDTcount = sizeof(fdt) / sizeof(fdt[0]); // # entris in FDT
8429 
8430 void
8431 dobuiltin(char *cmd) {
8432   int i;
8433 
8434   for (i=0; i<FDTcount; i++)
8435     if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0)
8436      (*fdt[i].name)(cmd);
8437 }
8438 
8439 
8440 
8441 
8442 
8443 
8444 
8445 
8446 
8447 
8448 
8449 
8450 // ***** processing for shell builtins ends here *****
8451 #endif
8452 
8453 int
8454 main(void)
8455 {
8456   static char buf[100];
8457   int fd;
8458 
8459   // Assumes three file descriptors open.
8460   while((fd = open("console", O_RDWR)) >= 0){
8461     if(fd >= 3){
8462       close(fd);
8463       break;
8464     }
8465   }
8466 
8467   // Read and run input commands.
8468   while(getcmd(buf, sizeof(buf)) >= 0){
8469 // add support for built-ins here. cd is a built-in
8470     if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
8471       // Clumsy but will have to do for now.
8472       // Chdir has no effect on the parent if run in the child.
8473       buf[strlen(buf)-1] = 0;  // chop \n
8474       if(chdir(buf+3) < 0)
8475         printf(2, "cannot cd %s\n", buf+3);
8476       continue;
8477     }
8478 #ifdef USE_BUILTINS
8479     if (buf[0]=='_') {     // assume it is a builtin command
8480       dobuiltin(buf);
8481       continue;
8482     }
8483 #endif
8484     if(fork1() == 0)
8485       runcmd(parsecmd(buf));
8486     wait();
8487   }
8488   exit();
8489 }
8490 
8491 void
8492 panic(char *s)
8493 {
8494   printf(2, "%s\n", s);
8495   exit();
8496 }
8497 
8498 
8499 
8500 int
8501 fork1(void)
8502 {
8503   int pid;
8504 
8505   pid = fork();
8506   if(pid == -1)
8507     panic("fork");
8508   return pid;
8509 }
8510 
8511 // Constructors
8512 
8513 struct cmd*
8514 execcmd(void)
8515 {
8516   struct execcmd *cmd;
8517 
8518   cmd = malloc(sizeof(*cmd));
8519   memset(cmd, 0, sizeof(*cmd));
8520   cmd->type = EXEC;
8521   return (struct cmd*)cmd;
8522 }
8523 
8524 struct cmd*
8525 redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
8526 {
8527   struct redircmd *cmd;
8528 
8529   cmd = malloc(sizeof(*cmd));
8530   memset(cmd, 0, sizeof(*cmd));
8531   cmd->type = REDIR;
8532   cmd->cmd = subcmd;
8533   cmd->file = file;
8534   cmd->efile = efile;
8535   cmd->mode = mode;
8536   cmd->fd = fd;
8537   return (struct cmd*)cmd;
8538 }
8539 
8540 
8541 
8542 
8543 
8544 
8545 
8546 
8547 
8548 
8549 
8550 struct cmd*
8551 pipecmd(struct cmd *left, struct cmd *right)
8552 {
8553   struct pipecmd *cmd;
8554 
8555   cmd = malloc(sizeof(*cmd));
8556   memset(cmd, 0, sizeof(*cmd));
8557   cmd->type = PIPE;
8558   cmd->left = left;
8559   cmd->right = right;
8560   return (struct cmd*)cmd;
8561 }
8562 
8563 struct cmd*
8564 listcmd(struct cmd *left, struct cmd *right)
8565 {
8566   struct listcmd *cmd;
8567 
8568   cmd = malloc(sizeof(*cmd));
8569   memset(cmd, 0, sizeof(*cmd));
8570   cmd->type = LIST;
8571   cmd->left = left;
8572   cmd->right = right;
8573   return (struct cmd*)cmd;
8574 }
8575 
8576 struct cmd*
8577 backcmd(struct cmd *subcmd)
8578 {
8579   struct backcmd *cmd;
8580 
8581   cmd = malloc(sizeof(*cmd));
8582   memset(cmd, 0, sizeof(*cmd));
8583   cmd->type = BACK;
8584   cmd->cmd = subcmd;
8585   return (struct cmd*)cmd;
8586 }
8587 
8588 
8589 
8590 
8591 
8592 
8593 
8594 
8595 
8596 
8597 
8598 
8599 
8600 // Parsing
8601 
8602 char whitespace[] = " \t\r\n\v";
8603 char symbols[] = "<|>&;()";
8604 
8605 int
8606 gettoken(char **ps, char *es, char **q, char **eq)
8607 {
8608   char *s;
8609   int ret;
8610 
8611   s = *ps;
8612   while(s < es && strchr(whitespace, *s))
8613     s++;
8614   if(q)
8615     *q = s;
8616   ret = *s;
8617   switch(*s){
8618   case 0:
8619     break;
8620   case '|':
8621   case '(':
8622   case ')':
8623   case ';':
8624   case '&':
8625   case '<':
8626     s++;
8627     break;
8628   case '>':
8629     s++;
8630     if(*s == '>'){
8631       ret = '+';
8632       s++;
8633     }
8634     break;
8635   default:
8636     ret = 'a';
8637     while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
8638       s++;
8639     break;
8640   }
8641   if(eq)
8642     *eq = s;
8643 
8644   while(s < es && strchr(whitespace, *s))
8645     s++;
8646   *ps = s;
8647   return ret;
8648 }
8649 
8650 int
8651 peek(char **ps, char *es, char *toks)
8652 {
8653   char *s;
8654 
8655   s = *ps;
8656   while(s < es && strchr(whitespace, *s))
8657     s++;
8658   *ps = s;
8659   return *s && strchr(toks, *s);
8660 }
8661 
8662 struct cmd *parseline(char**, char*);
8663 struct cmd *parsepipe(char**, char*);
8664 struct cmd *parseexec(char**, char*);
8665 struct cmd *nulterminate(struct cmd*);
8666 
8667 struct cmd*
8668 parsecmd(char *s)
8669 {
8670   char *es;
8671   struct cmd *cmd;
8672 
8673   es = s + strlen(s);
8674   cmd = parseline(&s, es);
8675   peek(&s, es, "");
8676   if(s != es){
8677     printf(2, "leftovers: %s\n", s);
8678     panic("syntax");
8679   }
8680   nulterminate(cmd);
8681   return cmd;
8682 }
8683 
8684 struct cmd*
8685 parseline(char **ps, char *es)
8686 {
8687   struct cmd *cmd;
8688 
8689   cmd = parsepipe(ps, es);
8690   while(peek(ps, es, "&")){
8691     gettoken(ps, es, 0, 0);
8692     cmd = backcmd(cmd);
8693   }
8694   if(peek(ps, es, ";")){
8695     gettoken(ps, es, 0, 0);
8696     cmd = listcmd(cmd, parseline(ps, es));
8697   }
8698   return cmd;
8699 }
8700 struct cmd*
8701 parsepipe(char **ps, char *es)
8702 {
8703   struct cmd *cmd;
8704 
8705   cmd = parseexec(ps, es);
8706   if(peek(ps, es, "|")){
8707     gettoken(ps, es, 0, 0);
8708     cmd = pipecmd(cmd, parsepipe(ps, es));
8709   }
8710   return cmd;
8711 }
8712 
8713 struct cmd*
8714 parseredirs(struct cmd *cmd, char **ps, char *es)
8715 {
8716   int tok;
8717   char *q, *eq;
8718 
8719   while(peek(ps, es, "<>")){
8720     tok = gettoken(ps, es, 0, 0);
8721     if(gettoken(ps, es, &q, &eq) != 'a')
8722       panic("missing file for redirection");
8723     switch(tok){
8724     case '<':
8725       cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
8726       break;
8727     case '>':
8728       cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
8729       break;
8730     case '+':  // >>
8731       cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
8732       break;
8733     }
8734   }
8735   return cmd;
8736 }
8737 
8738 
8739 
8740 
8741 
8742 
8743 
8744 
8745 
8746 
8747 
8748 
8749 
8750 struct cmd*
8751 parseblock(char **ps, char *es)
8752 {
8753   struct cmd *cmd;
8754 
8755   if(!peek(ps, es, "("))
8756     panic("parseblock");
8757   gettoken(ps, es, 0, 0);
8758   cmd = parseline(ps, es);
8759   if(!peek(ps, es, ")"))
8760     panic("syntax - missing )");
8761   gettoken(ps, es, 0, 0);
8762   cmd = parseredirs(cmd, ps, es);
8763   return cmd;
8764 }
8765 
8766 struct cmd*
8767 parseexec(char **ps, char *es)
8768 {
8769   char *q, *eq;
8770   int tok, argc;
8771   struct execcmd *cmd;
8772   struct cmd *ret;
8773 
8774   if(peek(ps, es, "("))
8775     return parseblock(ps, es);
8776 
8777   ret = execcmd();
8778   cmd = (struct execcmd*)ret;
8779 
8780   argc = 0;
8781   ret = parseredirs(ret, ps, es);
8782   while(!peek(ps, es, "|)&;")){
8783     if((tok=gettoken(ps, es, &q, &eq)) == 0)
8784       break;
8785     if(tok != 'a')
8786       panic("syntax");
8787     cmd->argv[argc] = q;
8788     cmd->eargv[argc] = eq;
8789     argc++;
8790     if(argc >= MAXARGS)
8791       panic("too many args");
8792     ret = parseredirs(ret, ps, es);
8793   }
8794   cmd->argv[argc] = 0;
8795   cmd->eargv[argc] = 0;
8796   return ret;
8797 }
8798 
8799 
8800 // NUL-terminate all the counted strings.
8801 struct cmd*
8802 nulterminate(struct cmd *cmd)
8803 {
8804   int i;
8805   struct backcmd *bcmd;
8806   struct execcmd *ecmd;
8807   struct listcmd *lcmd;
8808   struct pipecmd *pcmd;
8809   struct redircmd *rcmd;
8810 
8811   if(cmd == 0)
8812     return 0;
8813 
8814   switch(cmd->type){
8815   case EXEC:
8816     ecmd = (struct execcmd*)cmd;
8817     for(i=0; ecmd->argv[i]; i++)
8818       *ecmd->eargv[i] = 0;
8819     break;
8820 
8821   case REDIR:
8822     rcmd = (struct redircmd*)cmd;
8823     nulterminate(rcmd->cmd);
8824     *rcmd->efile = 0;
8825     break;
8826 
8827   case PIPE:
8828     pcmd = (struct pipecmd*)cmd;
8829     nulterminate(pcmd->left);
8830     nulterminate(pcmd->right);
8831     break;
8832 
8833   case LIST:
8834     lcmd = (struct listcmd*)cmd;
8835     nulterminate(lcmd->left);
8836     nulterminate(lcmd->right);
8837     break;
8838 
8839   case BACK:
8840     bcmd = (struct backcmd*)cmd;
8841     nulterminate(bcmd->cmd);
8842     break;
8843   }
8844   return cmd;
8845 }
8846 
8847 
8848 
8849 
