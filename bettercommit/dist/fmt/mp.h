6650 // See MultiProcessor Specification Version 1.[14]
6651 
6652 struct mp {             // floating pointer
6653   uchar signature[4];           // "_MP_"
6654   void *physaddr;               // phys addr of MP config table
6655   uchar length;                 // 1
6656   uchar specrev;                // [14]
6657   uchar checksum;               // all bytes must add up to 0
6658   uchar type;                   // MP system config type
6659   uchar imcrp;
6660   uchar reserved[3];
6661 };
6662 
6663 struct mpconf {         // configuration table header
6664   uchar signature[4];           // "PCMP"
6665   ushort length;                // total table length
6666   uchar version;                // [14]
6667   uchar checksum;               // all bytes must add up to 0
6668   uchar product[20];            // product id
6669   uint *oemtable;               // OEM table pointer
6670   ushort oemlength;             // OEM table length
6671   ushort entry;                 // entry count
6672   uint *lapicaddr;              // address of local APIC
6673   ushort xlength;               // extended table length
6674   uchar xchecksum;              // extended table checksum
6675   uchar reserved;
6676 };
6677 
6678 struct mpproc {         // processor table entry
6679   uchar type;                   // entry type (0)
6680   uchar apicid;                 // local APIC id
6681   uchar version;                // local APIC verison
6682   uchar flags;                  // CPU flags
6683     #define MPBOOT 0x02           // This proc is the bootstrap processor.
6684   uchar signature[4];           // CPU signature
6685   uint feature;                 // feature flags from CPUID instruction
6686   uchar reserved[8];
6687 };
6688 
6689 struct mpioapic {       // I/O APIC table entry
6690   uchar type;                   // entry type (2)
6691   uchar apicno;                 // I/O APIC id
6692   uchar version;                // I/O APIC version
6693   uchar flags;                  // I/O APIC flags
6694   uint *addr;                  // I/O APIC address
6695 };
6696 
6697 
6698 
6699 
6700 // Table entry types
6701 #define MPPROC    0x00  // One per processor
6702 #define MPBUS     0x01  // One per bus
6703 #define MPIOAPIC  0x02  // One per I/O APIC
6704 #define MPIOINTR  0x03  // One per bus interrupt source
6705 #define MPLINTR   0x04  // One per system interrupt source
6706 
6707 // Blank page.
6708 
6709 
6710 
6711 
6712 
6713 
6714 
6715 
6716 
6717 
6718 
6719 
6720 
6721 
6722 
6723 
6724 
6725 
6726 
6727 
6728 
6729 
6730 
6731 
6732 
6733 
6734 
6735 
6736 
6737 
6738 
6739 
6740 
6741 
6742 
6743 
6744 
6745 
6746 
6747 
6748 
6749 
