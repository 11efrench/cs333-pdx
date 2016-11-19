8850 #include "asm.h"
8851 #include "memlayout.h"
8852 #include "mmu.h"
8853 
8854 # Start the first CPU: switch to 32-bit protected mode, jump into C.
8855 # The BIOS loads this code from the first sector of the hard disk into
8856 # memory at physical address 0x7c00 and starts executing in real mode
8857 # with %cs=0 %ip=7c00.
8858 
8859 .code16                       # Assemble for 16-bit mode
8860 .globl start
8861 start:
8862   cli                         # BIOS enabled interrupts; disable
8863 
8864   # Zero data segment registers DS, ES, and SS.
8865   xorw    %ax,%ax             # Set %ax to zero
8866   movw    %ax,%ds             # -> Data Segment
8867   movw    %ax,%es             # -> Extra Segment
8868   movw    %ax,%ss             # -> Stack Segment
8869 
8870   # Physical address line A20 is tied to zero so that the first PCs
8871   # with 2 MB would run software that assumed 1 MB.  Undo that.
8872 seta20.1:
8873   inb     $0x64,%al               # Wait for not busy
8874   testb   $0x2,%al
8875   jnz     seta20.1
8876 
8877   movb    $0xd1,%al               # 0xd1 -> port 0x64
8878   outb    %al,$0x64
8879 
8880 seta20.2:
8881   inb     $0x64,%al               # Wait for not busy
8882   testb   $0x2,%al
8883   jnz     seta20.2
8884 
8885   movb    $0xdf,%al               # 0xdf -> port 0x60
8886   outb    %al,$0x60
8887 
8888   # Switch from real to protected mode.  Use a bootstrap GDT that makes
8889   # virtual addresses map directly to physical addresses so that the
8890   # effective memory map doesn't change during the transition.
8891   lgdt    gdtdesc
8892   movl    %cr0, %eax
8893   orl     $CR0_PE, %eax
8894   movl    %eax, %cr0
8895 
8896   # Complete transition to 32-bit protected mode by using long jmp
8897   # to reload %cs and %eip.  The segment descriptors are set up with no
8898   # translation, so that the mapping is still the identity mapping.
8899   ljmp    $(SEG_KCODE<<3), $start32
8900 .code32  # Tell assembler to generate 32-bit code now.
8901 start32:
8902   # Set up the protected-mode data segment registers
8903   movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
8904   movw    %ax, %ds                # -> DS: Data Segment
8905   movw    %ax, %es                # -> ES: Extra Segment
8906   movw    %ax, %ss                # -> SS: Stack Segment
8907   movw    $0, %ax                 # Zero segments not ready for use
8908   movw    %ax, %fs                # -> FS
8909   movw    %ax, %gs                # -> GS
8910 
8911   # Set up the stack pointer and call into C.
8912   movl    $start, %esp
8913   call    bootmain
8914 
8915   # If bootmain returns (it shouldn't), trigger a Bochs
8916   # breakpoint if running under Bochs, then loop.
8917   movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
8918   movw    %ax, %dx
8919   outw    %ax, %dx
8920   movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
8921   outw    %ax, %dx
8922 spin:
8923   jmp     spin
8924 
8925 # Bootstrap GDT
8926 .p2align 2                                # force 4 byte alignment
8927 gdt:
8928   SEG_NULLASM                             # null seg
8929   SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)   # code seg
8930   SEG_ASM(STA_W, 0x0, 0xffffffff)         # data seg
8931 
8932 gdtdesc:
8933   .word   (gdtdesc - gdt - 1)             # sizeof(gdt) - 1
8934   .long   gdt                             # address gdt
8935 
8936 
8937 
8938 
8939 
8940 
8941 
8942 
8943 
8944 
8945 
8946 
8947 
8948 
8949 
