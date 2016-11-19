4200 struct file {
4201   enum { FD_NONE, FD_PIPE, FD_INODE } type;
4202   int ref; // reference count
4203   char readable;
4204   char writable;
4205   struct pipe *pipe;
4206   struct inode *ip;
4207   uint off;
4208 };
4209 
4210 
4211 // in-memory copy of an inode
4212 struct inode {
4213   uint dev;           // Device number
4214   uint inum;          // Inode number
4215   int ref;            // Reference count
4216   int flags;          // I_BUSY, I_VALID
4217 
4218   short type;         // copy of disk inode
4219   short major;
4220   short minor;
4221   short nlink;
4222   uint size;
4223   uint addrs[NDIRECT+1];
4224 };
4225 #define I_BUSY 0x1
4226 #define I_VALID 0x2
4227 
4228 // table mapping major device number to
4229 // device functions
4230 struct devsw {
4231   int (*read)(struct inode*, char*, int);
4232   int (*write)(struct inode*, char*, int);
4233 };
4234 
4235 extern struct devsw devsw[];
4236 
4237 #define CONSOLE 1
4238 
4239 // Blank page.
4240 
4241 
4242 
4243 
4244 
4245 
4246 
4247 
4248 
4249 
