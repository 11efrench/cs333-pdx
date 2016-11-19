4850 // File system implementation.  Five layers:
4851 //   + Blocks: allocator for raw disk blocks.
4852 //   + Log: crash recovery for multi-step updates.
4853 //   + Files: inode allocator, reading, writing, metadata.
4854 //   + Directories: inode with special contents (list of other inodes!)
4855 //   + Names: paths like /usr/rtm/xv6/fs.c for convenient naming.
4856 //
4857 // This file contains the low-level file system manipulation
4858 // routines.  The (higher-level) system call implementations
4859 // are in sysfile.c.
4860 
4861 #include "types.h"
4862 #include "defs.h"
4863 #include "param.h"
4864 #include "stat.h"
4865 #include "mmu.h"
4866 #include "proc.h"
4867 #include "spinlock.h"
4868 #include "fs.h"
4869 #include "buf.h"
4870 #include "file.h"
4871 
4872 #define min(a, b) ((a) < (b) ? (a) : (b))
4873 static void itrunc(struct inode*);
4874 struct superblock sb;   // there should be one per dev, but we run with one dev
4875 
4876 // Read the super block.
4877 void
4878 readsb(int dev, struct superblock *sb)
4879 {
4880   struct buf *bp;
4881 
4882   bp = bread(dev, 1);
4883   memmove(sb, bp->data, sizeof(*sb));
4884   brelse(bp);
4885 }
4886 
4887 // Zero a block.
4888 static void
4889 bzero(int dev, int bno)
4890 {
4891   struct buf *bp;
4892 
4893   bp = bread(dev, bno);
4894   memset(bp->data, 0, BSIZE);
4895   log_write(bp);
4896   brelse(bp);
4897 }
4898 
4899 
4900 // Blocks.
4901 
4902 // Allocate a zeroed disk block.
4903 static uint
4904 balloc(uint dev)
4905 {
4906   int b, bi, m;
4907   struct buf *bp;
4908 
4909   bp = 0;
4910   for(b = 0; b < sb.size; b += BPB){
4911     bp = bread(dev, BBLOCK(b, sb));
4912     for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
4913       m = 1 << (bi % 8);
4914       if((bp->data[bi/8] & m) == 0){  // Is block free?
4915         bp->data[bi/8] |= m;  // Mark block in use.
4916         log_write(bp);
4917         brelse(bp);
4918         bzero(dev, b + bi);
4919         return b + bi;
4920       }
4921     }
4922     brelse(bp);
4923   }
4924   panic("balloc: out of blocks");
4925 }
4926 
4927 // Free a disk block.
4928 static void
4929 bfree(int dev, uint b)
4930 {
4931   struct buf *bp;
4932   int bi, m;
4933 
4934   readsb(dev, &sb);
4935   bp = bread(dev, BBLOCK(b, sb));
4936   bi = b % BPB;
4937   m = 1 << (bi % 8);
4938   if((bp->data[bi/8] & m) == 0)
4939     panic("freeing free block");
4940   bp->data[bi/8] &= ~m;
4941   log_write(bp);
4942   brelse(bp);
4943 }
4944 
4945 
4946 
4947 
4948 
4949 
4950 // Inodes.
4951 //
4952 // An inode describes a single unnamed file.
4953 // The inode disk structure holds metadata: the file's type,
4954 // its size, the number of links referring to it, and the
4955 // list of blocks holding the file's content.
4956 //
4957 // The inodes are laid out sequentially on disk at
4958 // sb.startinode. Each inode has a number, indicating its
4959 // position on the disk.
4960 //
4961 // The kernel keeps a cache of in-use inodes in memory
4962 // to provide a place for synchronizing access
4963 // to inodes used by multiple processes. The cached
4964 // inodes include book-keeping information that is
4965 // not stored on disk: ip->ref and ip->flags.
4966 //
4967 // An inode and its in-memory represtative go through a
4968 // sequence of states before they can be used by the
4969 // rest of the file system code.
4970 //
4971 // * Allocation: an inode is allocated if its type (on disk)
4972 //   is non-zero. ialloc() allocates, iput() frees if
4973 //   the link count has fallen to zero.
4974 //
4975 // * Referencing in cache: an entry in the inode cache
4976 //   is free if ip->ref is zero. Otherwise ip->ref tracks
4977 //   the number of in-memory pointers to the entry (open
4978 //   files and current directories). iget() to find or
4979 //   create a cache entry and increment its ref, iput()
4980 //   to decrement ref.
4981 //
4982 // * Valid: the information (type, size, &c) in an inode
4983 //   cache entry is only correct when the I_VALID bit
4984 //   is set in ip->flags. ilock() reads the inode from
4985 //   the disk and sets I_VALID, while iput() clears
4986 //   I_VALID if ip->ref has fallen to zero.
4987 //
4988 // * Locked: file system code may only examine and modify
4989 //   the information in an inode and its content if it
4990 //   has first locked the inode. The I_BUSY flag indicates
4991 //   that the inode is locked. ilock() sets I_BUSY,
4992 //   while iunlock clears it.
4993 //
4994 // Thus a typical sequence is:
4995 //   ip = iget(dev, inum)
4996 //   ilock(ip)
4997 //   ... examine and modify ip->xxx ...
4998 //   iunlock(ip)
4999 //   iput(ip)
5000 //
5001 // ilock() is separate from iget() so that system calls can
5002 // get a long-term reference to an inode (as for an open file)
5003 // and only lock it for short periods (e.g., in read()).
5004 // The separation also helps avoid deadlock and races during
5005 // pathname lookup. iget() increments ip->ref so that the inode
5006 // stays cached and pointers to it remain valid.
5007 //
5008 // Many internal file system functions expect the caller to
5009 // have locked the inodes involved; this lets callers create
5010 // multi-step atomic operations.
5011 
5012 struct {
5013   struct spinlock lock;
5014   struct inode inode[NINODE];
5015 } icache;
5016 
5017 void
5018 iinit(int dev)
5019 {
5020   initlock(&icache.lock, "icache");
5021   readsb(dev, &sb);
5022   cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
5023           sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
5024 }
5025 
5026 static struct inode* iget(uint dev, uint inum);
5027 
5028 // Allocate a new inode with the given type on device dev.
5029 // A free inode has a type of zero.
5030 struct inode*
5031 ialloc(uint dev, short type)
5032 {
5033   int inum;
5034   struct buf *bp;
5035   struct dinode *dip;
5036 
5037   for(inum = 1; inum < sb.ninodes; inum++){
5038     bp = bread(dev, IBLOCK(inum, sb));
5039     dip = (struct dinode*)bp->data + inum%IPB;
5040     if(dip->type == 0){  // a free inode
5041       memset(dip, 0, sizeof(*dip));
5042       dip->type = type;
5043       log_write(bp);   // mark it allocated on the disk
5044       brelse(bp);
5045       return iget(dev, inum);
5046     }
5047     brelse(bp);
5048   }
5049   panic("ialloc: no inodes");
5050 }
5051 
5052 // Copy a modified in-memory inode to disk.
5053 void
5054 iupdate(struct inode *ip)
5055 {
5056   struct buf *bp;
5057   struct dinode *dip;
5058 
5059   bp = bread(ip->dev, IBLOCK(ip->inum, sb));
5060   dip = (struct dinode*)bp->data + ip->inum%IPB;
5061   dip->type = ip->type;
5062   dip->major = ip->major;
5063   dip->minor = ip->minor;
5064   dip->nlink = ip->nlink;
5065   dip->size = ip->size;
5066   memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
5067   log_write(bp);
5068   brelse(bp);
5069 }
5070 
5071 // Find the inode with number inum on device dev
5072 // and return the in-memory copy. Does not lock
5073 // the inode and does not read it from disk.
5074 static struct inode*
5075 iget(uint dev, uint inum)
5076 {
5077   struct inode *ip, *empty;
5078 
5079   acquire(&icache.lock);
5080 
5081   // Is the inode already cached?
5082   empty = 0;
5083   for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
5084     if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
5085       ip->ref++;
5086       release(&icache.lock);
5087       return ip;
5088     }
5089     if(empty == 0 && ip->ref == 0)    // Remember empty slot.
5090       empty = ip;
5091   }
5092 
5093   // Recycle an inode cache entry.
5094   if(empty == 0)
5095     panic("iget: no inodes");
5096 
5097 
5098 
5099 
5100   ip = empty;
5101   ip->dev = dev;
5102   ip->inum = inum;
5103   ip->ref = 1;
5104   ip->flags = 0;
5105   release(&icache.lock);
5106 
5107   return ip;
5108 }
5109 
5110 // Increment reference count for ip.
5111 // Returns ip to enable ip = idup(ip1) idiom.
5112 struct inode*
5113 idup(struct inode *ip)
5114 {
5115   acquire(&icache.lock);
5116   ip->ref++;
5117   release(&icache.lock);
5118   return ip;
5119 }
5120 
5121 // Lock the given inode.
5122 // Reads the inode from disk if necessary.
5123 void
5124 ilock(struct inode *ip)
5125 {
5126   struct buf *bp;
5127   struct dinode *dip;
5128 
5129   if(ip == 0 || ip->ref < 1)
5130     panic("ilock");
5131 
5132   acquire(&icache.lock);
5133   while(ip->flags & I_BUSY)
5134     sleep(ip, &icache.lock);
5135   ip->flags |= I_BUSY;
5136   release(&icache.lock);
5137 
5138   if(!(ip->flags & I_VALID)){
5139     bp = bread(ip->dev, IBLOCK(ip->inum, sb));
5140     dip = (struct dinode*)bp->data + ip->inum%IPB;
5141     ip->type = dip->type;
5142     ip->major = dip->major;
5143     ip->minor = dip->minor;
5144     ip->nlink = dip->nlink;
5145     ip->size = dip->size;
5146     memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
5147     brelse(bp);
5148     ip->flags |= I_VALID;
5149     if(ip->type == 0)
5150       panic("ilock: no type");
5151   }
5152 }
5153 
5154 // Unlock the given inode.
5155 void
5156 iunlock(struct inode *ip)
5157 {
5158   if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
5159     panic("iunlock");
5160 
5161   acquire(&icache.lock);
5162   ip->flags &= ~I_BUSY;
5163   wakeup(ip);
5164   release(&icache.lock);
5165 }
5166 
5167 // Drop a reference to an in-memory inode.
5168 // If that was the last reference, the inode cache entry can
5169 // be recycled.
5170 // If that was the last reference and the inode has no links
5171 // to it, free the inode (and its content) on disk.
5172 // All calls to iput() must be inside a transaction in
5173 // case it has to free the inode.
5174 void
5175 iput(struct inode *ip)
5176 {
5177   acquire(&icache.lock);
5178   if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
5179     // inode has no links and no other references: truncate and free.
5180     if(ip->flags & I_BUSY)
5181       panic("iput busy");
5182     ip->flags |= I_BUSY;
5183     release(&icache.lock);
5184     itrunc(ip);
5185     ip->type = 0;
5186     iupdate(ip);
5187     acquire(&icache.lock);
5188     ip->flags = 0;
5189     wakeup(ip);
5190   }
5191   ip->ref--;
5192   release(&icache.lock);
5193 }
5194 
5195 
5196 
5197 
5198 
5199 
5200 // Common idiom: unlock, then put.
5201 void
5202 iunlockput(struct inode *ip)
5203 {
5204   iunlock(ip);
5205   iput(ip);
5206 }
5207 
5208 // Inode content
5209 //
5210 // The content (data) associated with each inode is stored
5211 // in blocks on the disk. The first NDIRECT block numbers
5212 // are listed in ip->addrs[].  The next NINDIRECT blocks are
5213 // listed in block ip->addrs[NDIRECT].
5214 
5215 // Return the disk block address of the nth block in inode ip.
5216 // If there is no such block, bmap allocates one.
5217 static uint
5218 bmap(struct inode *ip, uint bn)
5219 {
5220   uint addr, *a;
5221   struct buf *bp;
5222 
5223   if(bn < NDIRECT){
5224     if((addr = ip->addrs[bn]) == 0)
5225       ip->addrs[bn] = addr = balloc(ip->dev);
5226     return addr;
5227   }
5228   bn -= NDIRECT;
5229 
5230   if(bn < NINDIRECT){
5231     // Load indirect block, allocating if necessary.
5232     if((addr = ip->addrs[NDIRECT]) == 0)
5233       ip->addrs[NDIRECT] = addr = balloc(ip->dev);
5234     bp = bread(ip->dev, addr);
5235     a = (uint*)bp->data;
5236     if((addr = a[bn]) == 0){
5237       a[bn] = addr = balloc(ip->dev);
5238       log_write(bp);
5239     }
5240     brelse(bp);
5241     return addr;
5242   }
5243 
5244   panic("bmap: out of range");
5245 }
5246 
5247 
5248 
5249 
5250 // Truncate inode (discard contents).
5251 // Only called when the inode has no links
5252 // to it (no directory entries referring to it)
5253 // and has no in-memory reference to it (is
5254 // not an open file or current directory).
5255 static void
5256 itrunc(struct inode *ip)
5257 {
5258   int i, j;
5259   struct buf *bp;
5260   uint *a;
5261 
5262   for(i = 0; i < NDIRECT; i++){
5263     if(ip->addrs[i]){
5264       bfree(ip->dev, ip->addrs[i]);
5265       ip->addrs[i] = 0;
5266     }
5267   }
5268 
5269   if(ip->addrs[NDIRECT]){
5270     bp = bread(ip->dev, ip->addrs[NDIRECT]);
5271     a = (uint*)bp->data;
5272     for(j = 0; j < NINDIRECT; j++){
5273       if(a[j])
5274         bfree(ip->dev, a[j]);
5275     }
5276     brelse(bp);
5277     bfree(ip->dev, ip->addrs[NDIRECT]);
5278     ip->addrs[NDIRECT] = 0;
5279   }
5280 
5281   ip->size = 0;
5282   iupdate(ip);
5283 }
5284 
5285 // Copy stat information from inode.
5286 void
5287 stati(struct inode *ip, struct stat *st)
5288 {
5289   st->dev = ip->dev;
5290   st->ino = ip->inum;
5291   st->type = ip->type;
5292   st->nlink = ip->nlink;
5293   st->size = ip->size;
5294 }
5295 
5296 
5297 
5298 
5299 
5300 // Read data from inode.
5301 int
5302 readi(struct inode *ip, char *dst, uint off, uint n)
5303 {
5304   uint tot, m;
5305   struct buf *bp;
5306 
5307   if(ip->type == T_DEV){
5308     if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
5309       return -1;
5310     return devsw[ip->major].read(ip, dst, n);
5311   }
5312 
5313   if(off > ip->size || off + n < off)
5314     return -1;
5315   if(off + n > ip->size)
5316     n = ip->size - off;
5317 
5318   for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
5319     bp = bread(ip->dev, bmap(ip, off/BSIZE));
5320     m = min(n - tot, BSIZE - off%BSIZE);
5321     memmove(dst, bp->data + off%BSIZE, m);
5322     brelse(bp);
5323   }
5324   return n;
5325 }
5326 
5327 // Write data to inode.
5328 int
5329 writei(struct inode *ip, char *src, uint off, uint n)
5330 {
5331   uint tot, m;
5332   struct buf *bp;
5333 
5334   if(ip->type == T_DEV){
5335     if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
5336       return -1;
5337     return devsw[ip->major].write(ip, src, n);
5338   }
5339 
5340   if(off > ip->size || off + n < off)
5341     return -1;
5342   if(off + n > MAXFILE*BSIZE)
5343     return -1;
5344 
5345   for(tot=0; tot<n; tot+=m, off+=m, src+=m){
5346     bp = bread(ip->dev, bmap(ip, off/BSIZE));
5347     m = min(n - tot, BSIZE - off%BSIZE);
5348     memmove(bp->data + off%BSIZE, src, m);
5349     log_write(bp);
5350     brelse(bp);
5351   }
5352 
5353   if(n > 0 && off > ip->size){
5354     ip->size = off;
5355     iupdate(ip);
5356   }
5357   return n;
5358 }
5359 
5360 // Directories
5361 
5362 int
5363 namecmp(const char *s, const char *t)
5364 {
5365   return strncmp(s, t, DIRSIZ);
5366 }
5367 
5368 // Look for a directory entry in a directory.
5369 // If found, set *poff to byte offset of entry.
5370 struct inode*
5371 dirlookup(struct inode *dp, char *name, uint *poff)
5372 {
5373   uint off, inum;
5374   struct dirent de;
5375 
5376   if(dp->type != T_DIR)
5377     panic("dirlookup not DIR");
5378 
5379   for(off = 0; off < dp->size; off += sizeof(de)){
5380     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5381       panic("dirlink read");
5382     if(de.inum == 0)
5383       continue;
5384     if(namecmp(name, de.name) == 0){
5385       // entry matches path element
5386       if(poff)
5387         *poff = off;
5388       inum = de.inum;
5389       return iget(dp->dev, inum);
5390     }
5391   }
5392 
5393   return 0;
5394 }
5395 
5396 
5397 
5398 
5399 
5400 // Write a new directory entry (name, inum) into the directory dp.
5401 int
5402 dirlink(struct inode *dp, char *name, uint inum)
5403 {
5404   int off;
5405   struct dirent de;
5406   struct inode *ip;
5407 
5408   // Check that name is not present.
5409   if((ip = dirlookup(dp, name, 0)) != 0){
5410     iput(ip);
5411     return -1;
5412   }
5413 
5414   // Look for an empty dirent.
5415   for(off = 0; off < dp->size; off += sizeof(de)){
5416     if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5417       panic("dirlink read");
5418     if(de.inum == 0)
5419       break;
5420   }
5421 
5422   strncpy(de.name, name, DIRSIZ);
5423   de.inum = inum;
5424   if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
5425     panic("dirlink");
5426 
5427   return 0;
5428 }
5429 
5430 // Paths
5431 
5432 // Copy the next path element from path into name.
5433 // Return a pointer to the element following the copied one.
5434 // The returned path has no leading slashes,
5435 // so the caller can check *path=='\0' to see if the name is the last one.
5436 // If no name to remove, return 0.
5437 //
5438 // Examples:
5439 //   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
5440 //   skipelem("///a//bb", name) = "bb", setting name = "a"
5441 //   skipelem("a", name) = "", setting name = "a"
5442 //   skipelem("", name) = skipelem("////", name) = 0
5443 //
5444 static char*
5445 skipelem(char *path, char *name)
5446 {
5447   char *s;
5448   int len;
5449 
5450   while(*path == '/')
5451     path++;
5452   if(*path == 0)
5453     return 0;
5454   s = path;
5455   while(*path != '/' && *path != 0)
5456     path++;
5457   len = path - s;
5458   if(len >= DIRSIZ)
5459     memmove(name, s, DIRSIZ);
5460   else {
5461     memmove(name, s, len);
5462     name[len] = 0;
5463   }
5464   while(*path == '/')
5465     path++;
5466   return path;
5467 }
5468 
5469 // Look up and return the inode for a path name.
5470 // If parent != 0, return the inode for the parent and copy the final
5471 // path element into name, which must have room for DIRSIZ bytes.
5472 // Must be called inside a transaction since it calls iput().
5473 static struct inode*
5474 namex(char *path, int nameiparent, char *name)
5475 {
5476   struct inode *ip, *next;
5477 
5478   if(*path == '/')
5479     ip = iget(ROOTDEV, ROOTINO);
5480   else
5481     ip = idup(proc->cwd);
5482 
5483   while((path = skipelem(path, name)) != 0){
5484     ilock(ip);
5485     if(ip->type != T_DIR){
5486       iunlockput(ip);
5487       return 0;
5488     }
5489     if(nameiparent && *path == '\0'){
5490       // Stop one level early.
5491       iunlock(ip);
5492       return ip;
5493     }
5494     if((next = dirlookup(ip, name, 0)) == 0){
5495       iunlockput(ip);
5496       return 0;
5497     }
5498     iunlockput(ip);
5499     ip = next;
5500   }
5501   if(nameiparent){
5502     iput(ip);
5503     return 0;
5504   }
5505   return ip;
5506 }
5507 
5508 struct inode*
5509 namei(char *path)
5510 {
5511   char name[DIRSIZ];
5512   return namex(path, 0, name);
5513 }
5514 
5515 struct inode*
5516 nameiparent(char *path, char *name)
5517 {
5518   return namex(path, 1, name);
5519 }
5520 
5521 
5522 
5523 
5524 
5525 
5526 
5527 
5528 
5529 
5530 
5531 
5532 
5533 
5534 
5535 
5536 
5537 
5538 
5539 
5540 
5541 
5542 
5543 
5544 
5545 
5546 
5547 
5548 
5549 
