6750 // Multiprocessor support
6751 // Search memory for MP description structures.
6752 // http://developer.intel.com/design/pentium/datashts/24201606.pdf
6753 
6754 #include "types.h"
6755 #include "defs.h"
6756 #include "param.h"
6757 #include "memlayout.h"
6758 #include "mp.h"
6759 #include "x86.h"
6760 #include "mmu.h"
6761 #include "proc.h"
6762 
6763 struct cpu cpus[NCPU];
6764 static struct cpu *bcpu;
6765 int ismp;
6766 int ncpu;
6767 uchar ioapicid;
6768 
6769 int
6770 mpbcpu(void)
6771 {
6772   return bcpu-cpus;
6773 }
6774 
6775 static uchar
6776 sum(uchar *addr, int len)
6777 {
6778   int i, sum;
6779 
6780   sum = 0;
6781   for(i=0; i<len; i++)
6782     sum += addr[i];
6783   return sum;
6784 }
6785 
6786 // Look for an MP structure in the len bytes at addr.
6787 static struct mp*
6788 mpsearch1(uint a, int len)
6789 {
6790   uchar *e, *p, *addr;
6791 
6792   addr = p2v(a);
6793   e = addr+len;
6794   for(p = addr; p < e; p += sizeof(struct mp))
6795     if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
6796       return (struct mp*)p;
6797   return 0;
6798 }
6799 
6800 // Search for the MP Floating Pointer Structure, which according to the
6801 // spec is in one of the following three locations:
6802 // 1) in the first KB of the EBDA;
6803 // 2) in the last KB of system base memory;
6804 // 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
6805 static struct mp*
6806 mpsearch(void)
6807 {
6808   uchar *bda;
6809   uint p;
6810   struct mp *mp;
6811 
6812   bda = (uchar *) P2V(0x400);
6813   if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
6814     if((mp = mpsearch1(p, 1024)))
6815       return mp;
6816   } else {
6817     p = ((bda[0x14]<<8)|bda[0x13])*1024;
6818     if((mp = mpsearch1(p-1024, 1024)))
6819       return mp;
6820   }
6821   return mpsearch1(0xF0000, 0x10000);
6822 }
6823 
6824 // Search for an MP configuration table.  For now,
6825 // don't accept the default configurations (physaddr == 0).
6826 // Check for correct signature, calculate the checksum and,
6827 // if correct, check the version.
6828 // To do: check extended table checksum.
6829 static struct mpconf*
6830 mpconfig(struct mp **pmp)
6831 {
6832   struct mpconf *conf;
6833   struct mp *mp;
6834 
6835   if((mp = mpsearch()) == 0 || mp->physaddr == 0)
6836     return 0;
6837   conf = (struct mpconf*) p2v((uint) mp->physaddr);
6838   if(memcmp(conf, "PCMP", 4) != 0)
6839     return 0;
6840   if(conf->version != 1 && conf->version != 4)
6841     return 0;
6842   if(sum((uchar*)conf, conf->length) != 0)
6843     return 0;
6844   *pmp = mp;
6845   return conf;
6846 }
6847 
6848 
6849 
6850 void
6851 mpinit(void)
6852 {
6853   uchar *p, *e;
6854   struct mp *mp;
6855   struct mpconf *conf;
6856   struct mpproc *proc;
6857   struct mpioapic *ioapic;
6858 
6859   bcpu = &cpus[0];
6860   if((conf = mpconfig(&mp)) == 0)
6861     return;
6862   ismp = 1;
6863   lapic = (uint*)conf->lapicaddr;
6864   for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
6865     switch(*p){
6866     case MPPROC:
6867       proc = (struct mpproc*)p;
6868       if(ncpu != proc->apicid){
6869         cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
6870         ismp = 0;
6871       }
6872       if(proc->flags & MPBOOT)
6873         bcpu = &cpus[ncpu];
6874       cpus[ncpu].id = ncpu;
6875       ncpu++;
6876       p += sizeof(struct mpproc);
6877       continue;
6878     case MPIOAPIC:
6879       ioapic = (struct mpioapic*)p;
6880       ioapicid = ioapic->apicno;
6881       p += sizeof(struct mpioapic);
6882       continue;
6883     case MPBUS:
6884     case MPIOINTR:
6885     case MPLINTR:
6886       p += 8;
6887       continue;
6888     default:
6889       cprintf("mpinit: unknown config type %x\n", *p);
6890       ismp = 0;
6891     }
6892   }
6893   if(!ismp){
6894     // Didn't like what we found; fall back to no MP.
6895     ncpu = 1;
6896     lapic = 0;
6897     ioapicid = 0;
6898     return;
6899   }
6900   if(mp->imcrp){
6901     // Bochs doesn't support IMCR, so this doesn't run on Bochs.
6902     // But it would on real hardware.
6903     outb(0x22, 0x70);   // Select IMCR
6904     outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
6905   }
6906 }
6907 
6908 
6909 
6910 
6911 
6912 
6913 
6914 
6915 
6916 
6917 
6918 
6919 
6920 
6921 
6922 
6923 
6924 
6925 
6926 
6927 
6928 
6929 
6930 
6931 
6932 
6933 
6934 
6935 
6936 
6937 
6938 
6939 
6940 
6941 
6942 
6943 
6944 
6945 
6946 
6947 
6948 
6949 
