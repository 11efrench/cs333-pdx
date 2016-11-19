5750 //
5751 // File-system system calls.
5752 // Mostly argument checking, since we don't trust
5753 // user code, and calls into file.c and fs.c.
5754 //
5755 
5756 #include "types.h"
5757 #include "defs.h"
5758 #include "param.h"
5759 #include "stat.h"
5760 #include "mmu.h"
5761 #include "proc.h"
5762 #include "fs.h"
5763 #include "file.h"
5764 #include "fcntl.h"
5765 
5766 // Fetch the nth word-sized system call argument as a file descriptor
5767 // and return both the descriptor and the corresponding struct file.
5768 static int
5769 argfd(int n, int *pfd, struct file **pf)
5770 {
5771   int fd;
5772   struct file *f;
5773 
5774   if(argint(n, &fd) < 0)
5775     return -1;
5776   if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
5777     return -1;
5778   if(pfd)
5779     *pfd = fd;
5780   if(pf)
5781     *pf = f;
5782   return 0;
5783 }
5784 
5785 // Allocate a file descriptor for the given file.
5786 // Takes over file reference from caller on success.
5787 static int
5788 fdalloc(struct file *f)
5789 {
5790   int fd;
5791 
5792   for(fd = 0; fd < NOFILE; fd++){
5793     if(proc->ofile[fd] == 0){
5794       proc->ofile[fd] = f;
5795       return fd;
5796     }
5797   }
5798   return -1;
5799 }
5800 int
5801 sys_dup(void)
5802 {
5803   struct file *f;
5804   int fd;
5805 
5806   if(argfd(0, 0, &f) < 0)
5807     return -1;
5808   if((fd=fdalloc(f)) < 0)
5809     return -1;
5810   filedup(f);
5811   return fd;
5812 }
5813 
5814 int
5815 sys_read(void)
5816 {
5817   struct file *f;
5818   int n;
5819   char *p;
5820 
5821   if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
5822     return -1;
5823   return fileread(f, p, n);
5824 }
5825 
5826 int
5827 sys_write(void)
5828 {
5829   struct file *f;
5830   int n;
5831   char *p;
5832 
5833   if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
5834     return -1;
5835   return filewrite(f, p, n);
5836 }
5837 
5838 int
5839 sys_close(void)
5840 {
5841   int fd;
5842   struct file *f;
5843 
5844   if(argfd(0, &fd, &f) < 0)
5845     return -1;
5846   proc->ofile[fd] = 0;
5847   fileclose(f);
5848   return 0;
5849 }
5850 int
5851 sys_fstat(void)
5852 {
5853   struct file *f;
5854   struct stat *st;
5855 
5856   if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
5857     return -1;
5858   return filestat(f, st);
5859 }
5860 
5861 // Create the path new as a link to the same inode as old.
5862 int
5863 sys_link(void)
5864 {
5865   char name[DIRSIZ], *new, *old;
5866   struct inode *dp, *ip;
5867 
5868   if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
5869     return -1;
5870 
5871   begin_op();
5872   if((ip = namei(old)) == 0){
5873     end_op();
5874     return -1;
5875   }
5876 
5877   ilock(ip);
5878   if(ip->type == T_DIR){
5879     iunlockput(ip);
5880     end_op();
5881     return -1;
5882   }
5883 
5884   ip->nlink++;
5885   iupdate(ip);
5886   iunlock(ip);
5887 
5888   if((dp = nameiparent(new, name)) == 0)
5889     goto bad;
5890   ilock(dp);
5891   if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
5892     iunlockput(dp);
5893     goto bad;
5894   }
5895   iunlockput(dp);
5896   iput(ip);
5897 
5898   end_op();
5899 
5900   return 0;
5901 
5902 bad:
5903   ilock(ip);
5904   ip->nlink--;
5905   iupdate(ip);
5906   iunlockput(ip);
5907   end_op();
5908   return -1;
5909 }
5910 
5911 // Is the directory dp empty except for "." and ".." ?
5912 static int
5913 isdirempty(struct inode *dp)
5914 {
5915   int off;
5916   struct dirent de;
5917 
5918   for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
5919     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5920       panic("isdirempty: readi");
5921     if(de.inum != 0)
5922       return 0;
5923   }
5924   return 1;
5925 }
5926 
5927 int
5928 sys_unlink(void)
5929 {
5930   struct inode *ip, *dp;
5931   struct dirent de;
5932   char name[DIRSIZ], *path;
5933   uint off;
5934 
5935   if(argstr(0, &path) < 0)
5936     return -1;
5937 
5938   begin_op();
5939   if((dp = nameiparent(path, name)) == 0){
5940     end_op();
5941     return -1;
5942   }
5943 
5944   ilock(dp);
5945 
5946   // Cannot unlink "." or "..".
5947   if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
5948     goto bad;
5949 
5950   if((ip = dirlookup(dp, name, &off)) == 0)
5951     goto bad;
5952   ilock(ip);
5953 
5954   if(ip->nlink < 1)
5955     panic("unlink: nlink < 1");
5956   if(ip->type == T_DIR && !isdirempty(ip)){
5957     iunlockput(ip);
5958     goto bad;
5959   }
5960 
5961   memset(&de, 0, sizeof(de));
5962   if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5963     panic("unlink: writei");
5964   if(ip->type == T_DIR){
5965     dp->nlink--;
5966     iupdate(dp);
5967   }
5968   iunlockput(dp);
5969 
5970   ip->nlink--;
5971   iupdate(ip);
5972   iunlockput(ip);
5973 
5974   end_op();
5975 
5976   return 0;
5977 
5978 bad:
5979   iunlockput(dp);
5980   end_op();
5981   return -1;
5982 }
5983 
5984 static struct inode*
5985 create(char *path, short type, short major, short minor)
5986 {
5987   uint off;
5988   struct inode *ip, *dp;
5989   char name[DIRSIZ];
5990 
5991   if((dp = nameiparent(path, name)) == 0)
5992     return 0;
5993   ilock(dp);
5994 
5995   if((ip = dirlookup(dp, name, &off)) != 0){
5996     iunlockput(dp);
5997     ilock(ip);
5998     if(type == T_FILE && ip->type == T_FILE)
5999       return ip;
6000     iunlockput(ip);
6001     return 0;
6002   }
6003 
6004   if((ip = ialloc(dp->dev, type)) == 0)
6005     panic("create: ialloc");
6006 
6007   ilock(ip);
6008   ip->major = major;
6009   ip->minor = minor;
6010   ip->nlink = 1;
6011   iupdate(ip);
6012 
6013   if(type == T_DIR){  // Create . and .. entries.
6014     dp->nlink++;  // for ".."
6015     iupdate(dp);
6016     // No ip->nlink++ for ".": avoid cyclic ref count.
6017     if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
6018       panic("create dots");
6019   }
6020 
6021   if(dirlink(dp, name, ip->inum) < 0)
6022     panic("create: dirlink");
6023 
6024   iunlockput(dp);
6025 
6026   return ip;
6027 }
6028 
6029 int
6030 sys_open(void)
6031 {
6032   char *path;
6033   int fd, omode;
6034   struct file *f;
6035   struct inode *ip;
6036 
6037   if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
6038     return -1;
6039 
6040   begin_op();
6041 
6042   if(omode & O_CREATE){
6043     ip = create(path, T_FILE, 0, 0);
6044     if(ip == 0){
6045       end_op();
6046       return -1;
6047     }
6048   } else {
6049     if((ip = namei(path)) == 0){
6050       end_op();
6051       return -1;
6052     }
6053     ilock(ip);
6054     if(ip->type == T_DIR && omode != O_RDONLY){
6055       iunlockput(ip);
6056       end_op();
6057       return -1;
6058     }
6059   }
6060 
6061   if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
6062     if(f)
6063       fileclose(f);
6064     iunlockput(ip);
6065     end_op();
6066     return -1;
6067   }
6068   iunlock(ip);
6069   end_op();
6070 
6071   f->type = FD_INODE;
6072   f->ip = ip;
6073   f->off = 0;
6074   f->readable = !(omode & O_WRONLY);
6075   f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
6076   return fd;
6077 }
6078 
6079 int
6080 sys_mkdir(void)
6081 {
6082   char *path;
6083   struct inode *ip;
6084 
6085   begin_op();
6086   if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
6087     end_op();
6088     return -1;
6089   }
6090   iunlockput(ip);
6091   end_op();
6092   return 0;
6093 }
6094 
6095 
6096 
6097 
6098 
6099 
6100 int
6101 sys_mknod(void)
6102 {
6103   struct inode *ip;
6104   char *path;
6105   int len;
6106   int major, minor;
6107 
6108   begin_op();
6109   if((len=argstr(0, &path)) < 0 ||
6110      argint(1, &major) < 0 ||
6111      argint(2, &minor) < 0 ||
6112      (ip = create(path, T_DEV, major, minor)) == 0){
6113     end_op();
6114     return -1;
6115   }
6116   iunlockput(ip);
6117   end_op();
6118   return 0;
6119 }
6120 
6121 int
6122 sys_chdir(void)
6123 {
6124   char *path;
6125   struct inode *ip;
6126 
6127   begin_op();
6128   if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
6129     end_op();
6130     return -1;
6131   }
6132   ilock(ip);
6133   if(ip->type != T_DIR){
6134     iunlockput(ip);
6135     end_op();
6136     return -1;
6137   }
6138   iunlock(ip);
6139   iput(proc->cwd);
6140   end_op();
6141   proc->cwd = ip;
6142   return 0;
6143 }
6144 
6145 
6146 
6147 
6148 
6149 
6150 int
6151 sys_exec(void)
6152 {
6153   char *path, *argv[MAXARG];
6154   int i;
6155   uint uargv, uarg;
6156 
6157   if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
6158     return -1;
6159   }
6160   memset(argv, 0, sizeof(argv));
6161   for(i=0;; i++){
6162     if(i >= NELEM(argv))
6163       return -1;
6164     if(fetchint(uargv+4*i, (int*)&uarg) < 0)
6165       return -1;
6166     if(uarg == 0){
6167       argv[i] = 0;
6168       break;
6169     }
6170     if(fetchstr(uarg, &argv[i]) < 0)
6171       return -1;
6172   }
6173   return exec(path, argv);
6174 }
6175 
6176 int
6177 sys_pipe(void)
6178 {
6179   int *fd;
6180   struct file *rf, *wf;
6181   int fd0, fd1;
6182 
6183   if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
6184     return -1;
6185   if(pipealloc(&rf, &wf) < 0)
6186     return -1;
6187   fd0 = -1;
6188   if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
6189     if(fd0 >= 0)
6190       proc->ofile[fd0] = 0;
6191     fileclose(rf);
6192     fileclose(wf);
6193     return -1;
6194   }
6195   fd[0] = fd0;
6196   fd[1] = fd1;
6197   return 0;
6198 }
6199 
