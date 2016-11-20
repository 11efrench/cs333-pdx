
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 df 38 10 80       	mov    $0x801038df,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 d0 8a 10 80       	push   $0x80108ad0
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 b4 53 00 00       	call   80105400 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 5c 53 00 00       	call   80105422 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 78 53 00 00       	call   80105489 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 5f 4d 00 00       	call   80104e8b <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 fc 52 00 00       	call   80105489 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 d7 8a 10 80       	push   $0x80108ad7
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 76 27 00 00       	call   8010295d <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 e8 8a 10 80       	push   $0x80108ae8
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 35 27 00 00       	call   8010295d <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 ef 8a 10 80       	push   $0x80108aef
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 c8 51 00 00       	call   80105422 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 bb 4c 00 00       	call   80104f79 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 bb 51 00 00       	call   80105489 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 3b 50 00 00       	call   80105422 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 f6 8a 10 80       	push   $0x80108af6
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec ff 8a 10 80 	movl   $0x80108aff,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 29 4f 00 00       	call   80105489 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 06 8b 10 80       	push   $0x80108b06
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 15 8b 10 80       	push   $0x80108b15
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 14 4f 00 00       	call   801054db <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 17 8b 10 80       	push   $0x80108b17
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 1b 8b 10 80       	push   $0x80108b1b
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 48 50 00 00       	call   80105744 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 5f 4f 00 00       	call   80105685 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 9d 69 00 00       	call   80107158 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 90 69 00 00       	call   80107158 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 83 69 00 00       	call   80107158 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 73 69 00 00       	call   80107158 <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100806:	83 ec 0c             	sub    $0xc,%esp
80100809:	68 e0 c5 10 80       	push   $0x8010c5e0
8010080e:	e8 0f 4c 00 00       	call   80105422 <acquire>
80100813:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100816:	e9 44 01 00 00       	jmp    8010095f <consoleintr+0x166>
    switch(c){
8010081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010081e:	83 f8 10             	cmp    $0x10,%eax
80100821:	74 1e                	je     80100841 <consoleintr+0x48>
80100823:	83 f8 10             	cmp    $0x10,%eax
80100826:	7f 0a                	jg     80100832 <consoleintr+0x39>
80100828:	83 f8 08             	cmp    $0x8,%eax
8010082b:	74 6b                	je     80100898 <consoleintr+0x9f>
8010082d:	e9 9b 00 00 00       	jmp    801008cd <consoleintr+0xd4>
80100832:	83 f8 15             	cmp    $0x15,%eax
80100835:	74 33                	je     8010086a <consoleintr+0x71>
80100837:	83 f8 7f             	cmp    $0x7f,%eax
8010083a:	74 5c                	je     80100898 <consoleintr+0x9f>
8010083c:	e9 8c 00 00 00       	jmp    801008cd <consoleintr+0xd4>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100841:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100848:	e9 12 01 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010084d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100852:	83 e8 01             	sub    $0x1,%eax
80100855:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
8010085a:	83 ec 0c             	sub    $0xc,%esp
8010085d:	68 00 01 00 00       	push   $0x100
80100862:	e8 2b ff ff ff       	call   80100792 <consputc>
80100867:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100870:	a1 24 18 11 80       	mov    0x80111824,%eax
80100875:	39 c2                	cmp    %eax,%edx
80100877:	0f 84 e2 00 00 00    	je     8010095f <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010087d:	a1 28 18 11 80       	mov    0x80111828,%eax
80100882:	83 e8 01             	sub    $0x1,%eax
80100885:	83 e0 7f             	and    $0x7f,%eax
80100888:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010088f:	3c 0a                	cmp    $0xa,%al
80100891:	75 ba                	jne    8010084d <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100893:	e9 c7 00 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100898:	8b 15 28 18 11 80    	mov    0x80111828,%edx
8010089e:	a1 24 18 11 80       	mov    0x80111824,%eax
801008a3:	39 c2                	cmp    %eax,%edx
801008a5:	0f 84 b4 00 00 00    	je     8010095f <consoleintr+0x166>
        input.e--;
801008ab:	a1 28 18 11 80       	mov    0x80111828,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	68 00 01 00 00       	push   $0x100
801008c0:	e8 cd fe ff ff       	call   80100792 <consputc>
801008c5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008c8:	e9 92 00 00 00       	jmp    8010095f <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008d1:	0f 84 87 00 00 00    	je     8010095e <consoleintr+0x165>
801008d7:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008dd:	a1 20 18 11 80       	mov    0x80111820,%eax
801008e2:	29 c2                	sub    %eax,%edx
801008e4:	89 d0                	mov    %edx,%eax
801008e6:	83 f8 7f             	cmp    $0x7f,%eax
801008e9:	77 73                	ja     8010095e <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
801008eb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008ef:	74 05                	je     801008f6 <consoleintr+0xfd>
801008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f4:	eb 05                	jmp    801008fb <consoleintr+0x102>
801008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
801008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008fe:	a1 28 18 11 80       	mov    0x80111828,%eax
80100903:	8d 50 01             	lea    0x1(%eax),%edx
80100906:	89 15 28 18 11 80    	mov    %edx,0x80111828
8010090c:	83 e0 7f             	and    $0x7f,%eax
8010090f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100912:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
        consputc(c);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	ff 75 f0             	pushl  -0x10(%ebp)
8010091e:	e8 6f fe ff ff       	call   80100792 <consputc>
80100923:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100926:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010092a:	74 18                	je     80100944 <consoleintr+0x14b>
8010092c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100930:	74 12                	je     80100944 <consoleintr+0x14b>
80100932:	a1 28 18 11 80       	mov    0x80111828,%eax
80100937:	8b 15 20 18 11 80    	mov    0x80111820,%edx
8010093d:	83 ea 80             	sub    $0xffffff80,%edx
80100940:	39 d0                	cmp    %edx,%eax
80100942:	75 1a                	jne    8010095e <consoleintr+0x165>
          input.w = input.e;
80100944:	a1 28 18 11 80       	mov    0x80111828,%eax
80100949:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
8010094e:	83 ec 0c             	sub    $0xc,%esp
80100951:	68 20 18 11 80       	push   $0x80111820
80100956:	e8 1e 46 00 00       	call   80104f79 <wakeup>
8010095b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010095e:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010095f:	8b 45 08             	mov    0x8(%ebp),%eax
80100962:	ff d0                	call   *%eax
80100964:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010096b:	0f 89 aa fe ff ff    	jns    8010081b <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100971:	83 ec 0c             	sub    $0xc,%esp
80100974:	68 e0 c5 10 80       	push   $0x8010c5e0
80100979:	e8 0b 4b 00 00       	call   80105489 <release>
8010097e:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100985:	74 05                	je     8010098c <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
80100987:	e8 ad 46 00 00       	call   80105039 <procdump>
  }
}
8010098c:	90                   	nop
8010098d:	c9                   	leave  
8010098e:	c3                   	ret    

8010098f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010098f:	55                   	push   %ebp
80100990:	89 e5                	mov    %esp,%ebp
80100992:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100995:	83 ec 0c             	sub    $0xc,%esp
80100998:	ff 75 08             	pushl  0x8(%ebp)
8010099b:	e8 50 11 00 00       	call   80101af0 <iunlock>
801009a0:	83 c4 10             	add    $0x10,%esp
  target = n;
801009a3:	8b 45 10             	mov    0x10(%ebp),%eax
801009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009a9:	83 ec 0c             	sub    $0xc,%esp
801009ac:	68 e0 c5 10 80       	push   $0x8010c5e0
801009b1:	e8 6c 4a 00 00       	call   80105422 <acquire>
801009b6:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009b9:	e9 ac 00 00 00       	jmp    80100a6a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009c4:	8b 40 24             	mov    0x24(%eax),%eax
801009c7:	85 c0                	test   %eax,%eax
801009c9:	74 28                	je     801009f3 <consoleread+0x64>
        release(&cons.lock);
801009cb:	83 ec 0c             	sub    $0xc,%esp
801009ce:	68 e0 c5 10 80       	push   $0x8010c5e0
801009d3:	e8 b1 4a 00 00       	call   80105489 <release>
801009d8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009db:	83 ec 0c             	sub    $0xc,%esp
801009de:	ff 75 08             	pushl  0x8(%ebp)
801009e1:	e8 84 0f 00 00       	call   8010196a <ilock>
801009e6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ee:	e9 ab 00 00 00       	jmp    80100a9e <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
801009f3:	83 ec 08             	sub    $0x8,%esp
801009f6:	68 e0 c5 10 80       	push   $0x8010c5e0
801009fb:	68 20 18 11 80       	push   $0x80111820
80100a00:	e8 86 44 00 00       	call   80104e8b <sleep>
80100a05:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a08:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100a0e:	a1 24 18 11 80       	mov    0x80111824,%eax
80100a13:	39 c2                	cmp    %eax,%edx
80100a15:	74 a7                	je     801009be <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a17:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a1c:	8d 50 01             	lea    0x1(%eax),%edx
80100a1f:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100a25:	83 e0 7f             	and    $0x7f,%eax
80100a28:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80100a2f:	0f be c0             	movsbl %al,%eax
80100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a35:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a39:	75 17                	jne    80100a52 <consoleread+0xc3>
      if(n < target){
80100a3b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a41:	73 2f                	jae    80100a72 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a43:	a1 20 18 11 80       	mov    0x80111820,%eax
80100a48:	83 e8 01             	sub    $0x1,%eax
80100a4b:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
80100a50:	eb 20                	jmp    80100a72 <consoleread+0xe3>
    }
    *dst++ = c;
80100a52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a55:	8d 50 01             	lea    0x1(%eax),%edx
80100a58:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a5e:	88 10                	mov    %dl,(%eax)
    --n;
80100a60:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a64:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a68:	74 0b                	je     80100a75 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a6e:	7f 98                	jg     80100a08 <consoleread+0x79>
80100a70:	eb 04                	jmp    80100a76 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a72:	90                   	nop
80100a73:	eb 01                	jmp    80100a76 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a75:	90                   	nop
  }
  release(&cons.lock);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a7e:	e8 06 4a 00 00       	call   80105489 <release>
80100a83:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	ff 75 08             	pushl  0x8(%ebp)
80100a8c:	e8 d9 0e 00 00       	call   8010196a <ilock>
80100a91:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a94:	8b 45 10             	mov    0x10(%ebp),%eax
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	29 c2                	sub    %eax,%edx
80100a9c:	89 d0                	mov    %edx,%eax
}
80100a9e:	c9                   	leave  
80100a9f:	c3                   	ret    

80100aa0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100aa6:	83 ec 0c             	sub    $0xc,%esp
80100aa9:	ff 75 08             	pushl  0x8(%ebp)
80100aac:	e8 3f 10 00 00       	call   80101af0 <iunlock>
80100ab1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ab4:	83 ec 0c             	sub    $0xc,%esp
80100ab7:	68 e0 c5 10 80       	push   $0x8010c5e0
80100abc:	e8 61 49 00 00       	call   80105422 <acquire>
80100ac1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100acb:	eb 21                	jmp    80100aee <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad3:	01 d0                	add    %edx,%eax
80100ad5:	0f b6 00             	movzbl (%eax),%eax
80100ad8:	0f be c0             	movsbl %al,%eax
80100adb:	0f b6 c0             	movzbl %al,%eax
80100ade:	83 ec 0c             	sub    $0xc,%esp
80100ae1:	50                   	push   %eax
80100ae2:	e8 ab fc ff ff       	call   80100792 <consputc>
80100ae7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100af1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100af4:	7c d7                	jl     80100acd <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afe:	e8 86 49 00 00       	call   80105489 <release>
80100b03:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	ff 75 08             	pushl  0x8(%ebp)
80100b0c:	e8 59 0e 00 00       	call   8010196a <ilock>
80100b11:	83 c4 10             	add    $0x10,%esp

  return n;
80100b14:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b17:	c9                   	leave  
80100b18:	c3                   	ret    

80100b19 <consoleinit>:

void
consoleinit(void)
{
80100b19:	55                   	push   %ebp
80100b1a:	89 e5                	mov    %esp,%ebp
80100b1c:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b1f:	83 ec 08             	sub    $0x8,%esp
80100b22:	68 2e 8b 10 80       	push   $0x80108b2e
80100b27:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b2c:	e8 cf 48 00 00       	call   80105400 <initlock>
80100b31:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b34:	c7 05 ec 21 11 80 a0 	movl   $0x80100aa0,0x801121ec
80100b3b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b3e:	c7 05 e8 21 11 80 8f 	movl   $0x8010098f,0x801121e8
80100b45:	09 10 80 
  cons.locking = 1;
80100b48:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b4f:	00 00 00 

  picenable(IRQ_KBD);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	6a 01                	push   $0x1
80100b57:	e8 1f 34 00 00       	call   80103f7b <picenable>
80100b5c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b5f:	83 ec 08             	sub    $0x8,%esp
80100b62:	6a 00                	push   $0x0
80100b64:	6a 01                	push   $0x1
80100b66:	e8 bf 1f 00 00       	call   80102b2a <ioapicenable>
80100b6b:	83 c4 10             	add    $0x10,%esp
}
80100b6e:	90                   	nop
80100b6f:	c9                   	leave  
80100b70:	c3                   	ret    

80100b71 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b71:	55                   	push   %ebp
80100b72:	89 e5                	mov    %esp,%ebp
80100b74:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b7a:	e8 1e 2a 00 00       	call   8010359d <begin_op>
  if((ip = namei(path)) == 0){
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	ff 75 08             	pushl  0x8(%ebp)
80100b85:	e8 ee 19 00 00       	call   80102578 <namei>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b94:	75 0f                	jne    80100ba5 <exec+0x34>
    end_op();
80100b96:	e8 8e 2a 00 00       	call   80103629 <end_op>
    return -1;
80100b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba0:	e9 ce 03 00 00       	jmp    80100f73 <exec+0x402>
  }
  ilock(ip);
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	ff 75 d8             	pushl  -0x28(%ebp)
80100bab:	e8 ba 0d 00 00       	call   8010196a <ilock>
80100bb0:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bb3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bba:	6a 34                	push   $0x34
80100bbc:	6a 00                	push   $0x0
80100bbe:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bc4:	50                   	push   %eax
80100bc5:	ff 75 d8             	pushl  -0x28(%ebp)
80100bc8:	e8 5b 13 00 00       	call   80101f28 <readi>
80100bcd:	83 c4 10             	add    $0x10,%esp
80100bd0:	83 f8 33             	cmp    $0x33,%eax
80100bd3:	0f 86 49 03 00 00    	jbe    80100f22 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bd9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bdf:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100be4:	0f 85 3b 03 00 00    	jne    80100f25 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bea:	e8 be 76 00 00       	call   801082ad <setupkvm>
80100bef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bf6:	0f 84 2c 03 00 00    	je     80100f28 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100bfc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c03:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c0a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c10:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c13:	e9 ab 00 00 00       	jmp    80100cc3 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c18:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c1b:	6a 20                	push   $0x20
80100c1d:	50                   	push   %eax
80100c1e:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c24:	50                   	push   %eax
80100c25:	ff 75 d8             	pushl  -0x28(%ebp)
80100c28:	e8 fb 12 00 00       	call   80101f28 <readi>
80100c2d:	83 c4 10             	add    $0x10,%esp
80100c30:	83 f8 20             	cmp    $0x20,%eax
80100c33:	0f 85 f2 02 00 00    	jne    80100f2b <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c39:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c3f:	83 f8 01             	cmp    $0x1,%eax
80100c42:	75 71                	jne    80100cb5 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c44:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c4a:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c50:	39 c2                	cmp    %eax,%edx
80100c52:	0f 82 d6 02 00 00    	jb     80100f2e <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c58:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c5e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c64:	01 d0                	add    %edx,%eax
80100c66:	83 ec 04             	sub    $0x4,%esp
80100c69:	50                   	push   %eax
80100c6a:	ff 75 e0             	pushl  -0x20(%ebp)
80100c6d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c70:	e8 df 79 00 00       	call   80108654 <allocuvm>
80100c75:	83 c4 10             	add    $0x10,%esp
80100c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c7f:	0f 84 ac 02 00 00    	je     80100f31 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c85:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c8b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c91:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c97:	83 ec 0c             	sub    $0xc,%esp
80100c9a:	52                   	push   %edx
80100c9b:	50                   	push   %eax
80100c9c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c9f:	51                   	push   %ecx
80100ca0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ca3:	e8 d5 78 00 00       	call   8010857d <loaduvm>
80100ca8:	83 c4 20             	add    $0x20,%esp
80100cab:	85 c0                	test   %eax,%eax
80100cad:	0f 88 81 02 00 00    	js     80100f34 <exec+0x3c3>
80100cb3:	eb 01                	jmp    80100cb6 <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100cb5:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cb6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cbd:	83 c0 20             	add    $0x20,%eax
80100cc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cc3:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cca:	0f b7 c0             	movzwl %ax,%eax
80100ccd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cd0:	0f 8f 42 ff ff ff    	jg     80100c18 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cd6:	83 ec 0c             	sub    $0xc,%esp
80100cd9:	ff 75 d8             	pushl  -0x28(%ebp)
80100cdc:	e8 71 0f 00 00       	call   80101c52 <iunlockput>
80100ce1:	83 c4 10             	add    $0x10,%esp
  end_op();
80100ce4:	e8 40 29 00 00       	call   80103629 <end_op>
  ip = 0;
80100ce9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf3:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d03:	05 00 20 00 00       	add    $0x2000,%eax
80100d08:	83 ec 04             	sub    $0x4,%esp
80100d0b:	50                   	push   %eax
80100d0c:	ff 75 e0             	pushl  -0x20(%ebp)
80100d0f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d12:	e8 3d 79 00 00       	call   80108654 <allocuvm>
80100d17:	83 c4 10             	add    $0x10,%esp
80100d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d21:	0f 84 10 02 00 00    	je     80100f37 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d2f:	83 ec 08             	sub    $0x8,%esp
80100d32:	50                   	push   %eax
80100d33:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d36:	e8 3f 7b 00 00       	call   8010887a <clearpteu>
80100d3b:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d41:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d4b:	e9 96 00 00 00       	jmp    80100de6 <exec+0x275>
    if(argc >= MAXARG)
80100d50:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d54:	0f 87 e0 01 00 00    	ja     80100f3a <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d67:	01 d0                	add    %edx,%eax
80100d69:	8b 00                	mov    (%eax),%eax
80100d6b:	83 ec 0c             	sub    $0xc,%esp
80100d6e:	50                   	push   %eax
80100d6f:	e8 5e 4b 00 00       	call   801058d2 <strlen>
80100d74:	83 c4 10             	add    $0x10,%esp
80100d77:	89 c2                	mov    %eax,%edx
80100d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d7c:	29 d0                	sub    %edx,%eax
80100d7e:	83 e8 01             	sub    $0x1,%eax
80100d81:	83 e0 fc             	and    $0xfffffffc,%eax
80100d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d94:	01 d0                	add    %edx,%eax
80100d96:	8b 00                	mov    (%eax),%eax
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	50                   	push   %eax
80100d9c:	e8 31 4b 00 00       	call   801058d2 <strlen>
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	83 c0 01             	add    $0x1,%eax
80100da7:	89 c1                	mov    %eax,%ecx
80100da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db6:	01 d0                	add    %edx,%eax
80100db8:	8b 00                	mov    (%eax),%eax
80100dba:	51                   	push   %ecx
80100dbb:	50                   	push   %eax
80100dbc:	ff 75 dc             	pushl  -0x24(%ebp)
80100dbf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dc2:	e8 6a 7c 00 00       	call   80108a31 <copyout>
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	85 c0                	test   %eax,%eax
80100dcc:	0f 88 6b 01 00 00    	js     80100f3d <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd5:	8d 50 03             	lea    0x3(%eax),%edx
80100dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ddb:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df3:	01 d0                	add    %edx,%eax
80100df5:	8b 00                	mov    (%eax),%eax
80100df7:	85 c0                	test   %eax,%eax
80100df9:	0f 85 51 ff ff ff    	jne    80100d50 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	83 c0 03             	add    $0x3,%eax
80100e05:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e0c:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e10:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e17:	ff ff ff 
  ustack[1] = argc;
80100e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1d:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 01             	add    $0x1,%eax
80100e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e33:	29 d0                	sub    %edx,%eax
80100e35:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3e:	83 c0 04             	add    $0x4,%eax
80100e41:	c1 e0 02             	shl    $0x2,%eax
80100e44:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 04             	add    $0x4,%eax
80100e4d:	c1 e0 02             	shl    $0x2,%eax
80100e50:	50                   	push   %eax
80100e51:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e57:	50                   	push   %eax
80100e58:	ff 75 dc             	pushl  -0x24(%ebp)
80100e5b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e5e:	e8 ce 7b 00 00       	call   80108a31 <copyout>
80100e63:	83 c4 10             	add    $0x10,%esp
80100e66:	85 c0                	test   %eax,%eax
80100e68:	0f 88 d2 00 00 00    	js     80100f40 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80100e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e7a:	eb 17                	jmp    80100e93 <exec+0x322>
    if(*s == '/')
80100e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7f:	0f b6 00             	movzbl (%eax),%eax
80100e82:	3c 2f                	cmp    $0x2f,%al
80100e84:	75 09                	jne    80100e8f <exec+0x31e>
      last = s+1;
80100e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e89:	83 c0 01             	add    $0x1,%eax
80100e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e96:	0f b6 00             	movzbl (%eax),%eax
80100e99:	84 c0                	test   %al,%al
80100e9b:	75 df                	jne    80100e7c <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea3:	83 c0 6c             	add    $0x6c,%eax
80100ea6:	83 ec 04             	sub    $0x4,%esp
80100ea9:	6a 10                	push   $0x10
80100eab:	ff 75 f0             	pushl  -0x10(%ebp)
80100eae:	50                   	push   %eax
80100eaf:	e8 d4 49 00 00       	call   80105888 <safestrcpy>
80100eb4:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 40 04             	mov    0x4(%eax),%eax
80100ec0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ec3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ecc:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed8:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100eda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee0:	8b 40 18             	mov    0x18(%eax),%eax
80100ee3:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ee9:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef2:	8b 40 18             	mov    0x18(%eax),%eax
80100ef5:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ef8:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100efb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f01:	83 ec 0c             	sub    $0xc,%esp
80100f04:	50                   	push   %eax
80100f05:	e8 8a 74 00 00       	call   80108394 <switchuvm>
80100f0a:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f0d:	83 ec 0c             	sub    $0xc,%esp
80100f10:	ff 75 d0             	pushl  -0x30(%ebp)
80100f13:	e8 c2 78 00 00       	call   801087da <freevm>
80100f18:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f1b:	b8 00 00 00 00       	mov    $0x0,%eax
80100f20:	eb 51                	jmp    80100f73 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f22:	90                   	nop
80100f23:	eb 1c                	jmp    80100f41 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f25:	90                   	nop
80100f26:	eb 19                	jmp    80100f41 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f28:	90                   	nop
80100f29:	eb 16                	jmp    80100f41 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f2b:	90                   	nop
80100f2c:	eb 13                	jmp    80100f41 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f2e:	90                   	nop
80100f2f:	eb 10                	jmp    80100f41 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f31:	90                   	nop
80100f32:	eb 0d                	jmp    80100f41 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f34:	90                   	nop
80100f35:	eb 0a                	jmp    80100f41 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f37:	90                   	nop
80100f38:	eb 07                	jmp    80100f41 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f3a:	90                   	nop
80100f3b:	eb 04                	jmp    80100f41 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f3d:	90                   	nop
80100f3e:	eb 01                	jmp    80100f41 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f40:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f41:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f45:	74 0e                	je     80100f55 <exec+0x3e4>
    freevm(pgdir);
80100f47:	83 ec 0c             	sub    $0xc,%esp
80100f4a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f4d:	e8 88 78 00 00       	call   801087da <freevm>
80100f52:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f55:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f59:	74 13                	je     80100f6e <exec+0x3fd>
    iunlockput(ip);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 d8             	pushl  -0x28(%ebp)
80100f61:	e8 ec 0c 00 00       	call   80101c52 <iunlockput>
80100f66:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f69:	e8 bb 26 00 00       	call   80103629 <end_op>
  }
  return -1;
80100f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f73:	c9                   	leave  
80100f74:	c3                   	ret    

80100f75 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f75:	55                   	push   %ebp
80100f76:	89 e5                	mov    %esp,%ebp
80100f78:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f7b:	83 ec 08             	sub    $0x8,%esp
80100f7e:	68 36 8b 10 80       	push   $0x80108b36
80100f83:	68 40 18 11 80       	push   $0x80111840
80100f88:	e8 73 44 00 00       	call   80105400 <initlock>
80100f8d:	83 c4 10             	add    $0x10,%esp
}
80100f90:	90                   	nop
80100f91:	c9                   	leave  
80100f92:	c3                   	ret    

80100f93 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f93:	55                   	push   %ebp
80100f94:	89 e5                	mov    %esp,%ebp
80100f96:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 40 18 11 80       	push   $0x80111840
80100fa1:	e8 7c 44 00 00       	call   80105422 <acquire>
80100fa6:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa9:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80100fb0:	eb 2d                	jmp    80100fdf <filealloc+0x4c>
    if(f->ref == 0){
80100fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb5:	8b 40 04             	mov    0x4(%eax),%eax
80100fb8:	85 c0                	test   %eax,%eax
80100fba:	75 1f                	jne    80100fdb <filealloc+0x48>
      f->ref = 1;
80100fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbf:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fc6:	83 ec 0c             	sub    $0xc,%esp
80100fc9:	68 40 18 11 80       	push   $0x80111840
80100fce:	e8 b6 44 00 00       	call   80105489 <release>
80100fd3:	83 c4 10             	add    $0x10,%esp
      return f;
80100fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fd9:	eb 23                	jmp    80100ffe <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fdb:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fdf:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
80100fe4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fe7:	72 c9                	jb     80100fb2 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fe9:	83 ec 0c             	sub    $0xc,%esp
80100fec:	68 40 18 11 80       	push   $0x80111840
80100ff1:	e8 93 44 00 00       	call   80105489 <release>
80100ff6:	83 c4 10             	add    $0x10,%esp
  return 0;
80100ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100ffe:	c9                   	leave  
80100fff:	c3                   	ret    

80101000 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101006:	83 ec 0c             	sub    $0xc,%esp
80101009:	68 40 18 11 80       	push   $0x80111840
8010100e:	e8 0f 44 00 00       	call   80105422 <acquire>
80101013:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	7f 0d                	jg     8010102d <filedup+0x2d>
    panic("filedup");
80101020:	83 ec 0c             	sub    $0xc,%esp
80101023:	68 3d 8b 10 80       	push   $0x80108b3d
80101028:	e8 39 f5 ff ff       	call   80100566 <panic>
  f->ref++;
8010102d:	8b 45 08             	mov    0x8(%ebp),%eax
80101030:	8b 40 04             	mov    0x4(%eax),%eax
80101033:	8d 50 01             	lea    0x1(%eax),%edx
80101036:	8b 45 08             	mov    0x8(%ebp),%eax
80101039:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 40 18 11 80       	push   $0x80111840
80101044:	e8 40 44 00 00       	call   80105489 <release>
80101049:	83 c4 10             	add    $0x10,%esp
  return f;
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010104f:	c9                   	leave  
80101050:	c3                   	ret    

80101051 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101051:	55                   	push   %ebp
80101052:	89 e5                	mov    %esp,%ebp
80101054:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101057:	83 ec 0c             	sub    $0xc,%esp
8010105a:	68 40 18 11 80       	push   $0x80111840
8010105f:	e8 be 43 00 00       	call   80105422 <acquire>
80101064:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101067:	8b 45 08             	mov    0x8(%ebp),%eax
8010106a:	8b 40 04             	mov    0x4(%eax),%eax
8010106d:	85 c0                	test   %eax,%eax
8010106f:	7f 0d                	jg     8010107e <fileclose+0x2d>
    panic("fileclose");
80101071:	83 ec 0c             	sub    $0xc,%esp
80101074:	68 45 8b 10 80       	push   $0x80108b45
80101079:	e8 e8 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010107e:	8b 45 08             	mov    0x8(%ebp),%eax
80101081:	8b 40 04             	mov    0x4(%eax),%eax
80101084:	8d 50 ff             	lea    -0x1(%eax),%edx
80101087:	8b 45 08             	mov    0x8(%ebp),%eax
8010108a:	89 50 04             	mov    %edx,0x4(%eax)
8010108d:	8b 45 08             	mov    0x8(%ebp),%eax
80101090:	8b 40 04             	mov    0x4(%eax),%eax
80101093:	85 c0                	test   %eax,%eax
80101095:	7e 15                	jle    801010ac <fileclose+0x5b>
    release(&ftable.lock);
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	68 40 18 11 80       	push   $0x80111840
8010109f:	e8 e5 43 00 00       	call   80105489 <release>
801010a4:	83 c4 10             	add    $0x10,%esp
801010a7:	e9 8b 00 00 00       	jmp    80101137 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
801010af:	8b 10                	mov    (%eax),%edx
801010b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010b4:	8b 50 04             	mov    0x4(%eax),%edx
801010b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010ba:	8b 50 08             	mov    0x8(%eax),%edx
801010bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010c0:	8b 50 0c             	mov    0xc(%eax),%edx
801010c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010c6:	8b 50 10             	mov    0x10(%eax),%edx
801010c9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010cc:	8b 40 14             	mov    0x14(%eax),%eax
801010cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010dc:	8b 45 08             	mov    0x8(%ebp),%eax
801010df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010e5:	83 ec 0c             	sub    $0xc,%esp
801010e8:	68 40 18 11 80       	push   $0x80111840
801010ed:	e8 97 43 00 00       	call   80105489 <release>
801010f2:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f8:	83 f8 01             	cmp    $0x1,%eax
801010fb:	75 19                	jne    80101116 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010fd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101101:	0f be d0             	movsbl %al,%edx
80101104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101107:	83 ec 08             	sub    $0x8,%esp
8010110a:	52                   	push   %edx
8010110b:	50                   	push   %eax
8010110c:	e8 d3 30 00 00       	call   801041e4 <pipeclose>
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	eb 21                	jmp    80101137 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101116:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101119:	83 f8 02             	cmp    $0x2,%eax
8010111c:	75 19                	jne    80101137 <fileclose+0xe6>
    begin_op();
8010111e:	e8 7a 24 00 00       	call   8010359d <begin_op>
    iput(ff.ip);
80101123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101126:	83 ec 0c             	sub    $0xc,%esp
80101129:	50                   	push   %eax
8010112a:	e8 33 0a 00 00       	call   80101b62 <iput>
8010112f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101132:	e8 f2 24 00 00       	call   80103629 <end_op>
  }
}
80101137:	c9                   	leave  
80101138:	c3                   	ret    

80101139 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101139:	55                   	push   %ebp
8010113a:	89 e5                	mov    %esp,%ebp
8010113c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010113f:	8b 45 08             	mov    0x8(%ebp),%eax
80101142:	8b 00                	mov    (%eax),%eax
80101144:	83 f8 02             	cmp    $0x2,%eax
80101147:	75 40                	jne    80101189 <filestat+0x50>
    ilock(f->ip);
80101149:	8b 45 08             	mov    0x8(%ebp),%eax
8010114c:	8b 40 10             	mov    0x10(%eax),%eax
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	50                   	push   %eax
80101153:	e8 12 08 00 00       	call   8010196a <ilock>
80101158:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010115b:	8b 45 08             	mov    0x8(%ebp),%eax
8010115e:	8b 40 10             	mov    0x10(%eax),%eax
80101161:	83 ec 08             	sub    $0x8,%esp
80101164:	ff 75 0c             	pushl  0xc(%ebp)
80101167:	50                   	push   %eax
80101168:	e8 4d 0d 00 00       	call   80101eba <stati>
8010116d:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 40 10             	mov    0x10(%eax),%eax
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	50                   	push   %eax
8010117a:	e8 71 09 00 00       	call   80101af0 <iunlock>
8010117f:	83 c4 10             	add    $0x10,%esp
    return 0;
80101182:	b8 00 00 00 00       	mov    $0x0,%eax
80101187:	eb 05                	jmp    8010118e <filestat+0x55>
  }
  return -1;
80101189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010118e:	c9                   	leave  
8010118f:	c3                   	ret    

80101190 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010119d:	84 c0                	test   %al,%al
8010119f:	75 0a                	jne    801011ab <fileread+0x1b>
    return -1;
801011a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011a6:	e9 9b 00 00 00       	jmp    80101246 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	8b 00                	mov    (%eax),%eax
801011b0:	83 f8 01             	cmp    $0x1,%eax
801011b3:	75 1a                	jne    801011cf <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 40 0c             	mov    0xc(%eax),%eax
801011bb:	83 ec 04             	sub    $0x4,%esp
801011be:	ff 75 10             	pushl  0x10(%ebp)
801011c1:	ff 75 0c             	pushl  0xc(%ebp)
801011c4:	50                   	push   %eax
801011c5:	e8 c2 31 00 00       	call   8010438c <piperead>
801011ca:	83 c4 10             	add    $0x10,%esp
801011cd:	eb 77                	jmp    80101246 <fileread+0xb6>
  if(f->type == FD_INODE){
801011cf:	8b 45 08             	mov    0x8(%ebp),%eax
801011d2:	8b 00                	mov    (%eax),%eax
801011d4:	83 f8 02             	cmp    $0x2,%eax
801011d7:	75 60                	jne    80101239 <fileread+0xa9>
    ilock(f->ip);
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	8b 40 10             	mov    0x10(%eax),%eax
801011df:	83 ec 0c             	sub    $0xc,%esp
801011e2:	50                   	push   %eax
801011e3:	e8 82 07 00 00       	call   8010196a <ilock>
801011e8:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 50 14             	mov    0x14(%eax),%edx
801011f4:	8b 45 08             	mov    0x8(%ebp),%eax
801011f7:	8b 40 10             	mov    0x10(%eax),%eax
801011fa:	51                   	push   %ecx
801011fb:	52                   	push   %edx
801011fc:	ff 75 0c             	pushl  0xc(%ebp)
801011ff:	50                   	push   %eax
80101200:	e8 23 0d 00 00       	call   80101f28 <readi>
80101205:	83 c4 10             	add    $0x10,%esp
80101208:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010120b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010120f:	7e 11                	jle    80101222 <fileread+0x92>
      f->off += r;
80101211:	8b 45 08             	mov    0x8(%ebp),%eax
80101214:	8b 50 14             	mov    0x14(%eax),%edx
80101217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121a:	01 c2                	add    %eax,%edx
8010121c:	8b 45 08             	mov    0x8(%ebp),%eax
8010121f:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101222:	8b 45 08             	mov    0x8(%ebp),%eax
80101225:	8b 40 10             	mov    0x10(%eax),%eax
80101228:	83 ec 0c             	sub    $0xc,%esp
8010122b:	50                   	push   %eax
8010122c:	e8 bf 08 00 00       	call   80101af0 <iunlock>
80101231:	83 c4 10             	add    $0x10,%esp
    return r;
80101234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101237:	eb 0d                	jmp    80101246 <fileread+0xb6>
  }
  panic("fileread");
80101239:	83 ec 0c             	sub    $0xc,%esp
8010123c:	68 4f 8b 10 80       	push   $0x80108b4f
80101241:	e8 20 f3 ff ff       	call   80100566 <panic>
}
80101246:	c9                   	leave  
80101247:	c3                   	ret    

80101248 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101248:	55                   	push   %ebp
80101249:	89 e5                	mov    %esp,%ebp
8010124b:	53                   	push   %ebx
8010124c:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101256:	84 c0                	test   %al,%al
80101258:	75 0a                	jne    80101264 <filewrite+0x1c>
    return -1;
8010125a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010125f:	e9 1b 01 00 00       	jmp    8010137f <filewrite+0x137>
  if(f->type == FD_PIPE)
80101264:	8b 45 08             	mov    0x8(%ebp),%eax
80101267:	8b 00                	mov    (%eax),%eax
80101269:	83 f8 01             	cmp    $0x1,%eax
8010126c:	75 1d                	jne    8010128b <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	8b 40 0c             	mov    0xc(%eax),%eax
80101274:	83 ec 04             	sub    $0x4,%esp
80101277:	ff 75 10             	pushl  0x10(%ebp)
8010127a:	ff 75 0c             	pushl  0xc(%ebp)
8010127d:	50                   	push   %eax
8010127e:	e8 0b 30 00 00       	call   8010428e <pipewrite>
80101283:	83 c4 10             	add    $0x10,%esp
80101286:	e9 f4 00 00 00       	jmp    8010137f <filewrite+0x137>
  if(f->type == FD_INODE){
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8b 00                	mov    (%eax),%eax
80101290:	83 f8 02             	cmp    $0x2,%eax
80101293:	0f 85 d9 00 00 00    	jne    80101372 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101299:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012a7:	e9 a3 00 00 00       	jmp    8010134f <filewrite+0x107>
      int n1 = n - i;
801012ac:	8b 45 10             	mov    0x10(%ebp),%eax
801012af:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012bb:	7e 06                	jle    801012c3 <filewrite+0x7b>
        n1 = max;
801012bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012c0:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012c3:	e8 d5 22 00 00       	call   8010359d <begin_op>
      ilock(f->ip);
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 40 10             	mov    0x10(%eax),%eax
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	50                   	push   %eax
801012d2:	e8 93 06 00 00       	call   8010196a <ilock>
801012d7:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012da:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012dd:	8b 45 08             	mov    0x8(%ebp),%eax
801012e0:	8b 50 14             	mov    0x14(%eax),%edx
801012e3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801012e9:	01 c3                	add    %eax,%ebx
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 40 10             	mov    0x10(%eax),%eax
801012f1:	51                   	push   %ecx
801012f2:	52                   	push   %edx
801012f3:	53                   	push   %ebx
801012f4:	50                   	push   %eax
801012f5:	e8 85 0d 00 00       	call   8010207f <writei>
801012fa:	83 c4 10             	add    $0x10,%esp
801012fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101300:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101304:	7e 11                	jle    80101317 <filewrite+0xcf>
        f->off += r;
80101306:	8b 45 08             	mov    0x8(%ebp),%eax
80101309:	8b 50 14             	mov    0x14(%eax),%edx
8010130c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010130f:	01 c2                	add    %eax,%edx
80101311:	8b 45 08             	mov    0x8(%ebp),%eax
80101314:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101317:	8b 45 08             	mov    0x8(%ebp),%eax
8010131a:	8b 40 10             	mov    0x10(%eax),%eax
8010131d:	83 ec 0c             	sub    $0xc,%esp
80101320:	50                   	push   %eax
80101321:	e8 ca 07 00 00       	call   80101af0 <iunlock>
80101326:	83 c4 10             	add    $0x10,%esp
      end_op();
80101329:	e8 fb 22 00 00       	call   80103629 <end_op>

      if(r < 0)
8010132e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101332:	78 29                	js     8010135d <filewrite+0x115>
        break;
      if(r != n1)
80101334:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101337:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010133a:	74 0d                	je     80101349 <filewrite+0x101>
        panic("short filewrite");
8010133c:	83 ec 0c             	sub    $0xc,%esp
8010133f:	68 58 8b 10 80       	push   $0x80108b58
80101344:	e8 1d f2 ff ff       	call   80100566 <panic>
      i += r;
80101349:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010134c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101352:	3b 45 10             	cmp    0x10(%ebp),%eax
80101355:	0f 8c 51 ff ff ff    	jl     801012ac <filewrite+0x64>
8010135b:	eb 01                	jmp    8010135e <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
8010135d:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101361:	3b 45 10             	cmp    0x10(%ebp),%eax
80101364:	75 05                	jne    8010136b <filewrite+0x123>
80101366:	8b 45 10             	mov    0x10(%ebp),%eax
80101369:	eb 14                	jmp    8010137f <filewrite+0x137>
8010136b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101370:	eb 0d                	jmp    8010137f <filewrite+0x137>
  }
  panic("filewrite");
80101372:	83 ec 0c             	sub    $0xc,%esp
80101375:	68 68 8b 10 80       	push   $0x80108b68
8010137a:	e8 e7 f1 ff ff       	call   80100566 <panic>
}
8010137f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101382:	c9                   	leave  
80101383:	c3                   	ret    

80101384 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101384:	55                   	push   %ebp
80101385:	89 e5                	mov    %esp,%ebp
80101387:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010138a:	8b 45 08             	mov    0x8(%ebp),%eax
8010138d:	83 ec 08             	sub    $0x8,%esp
80101390:	6a 01                	push   $0x1
80101392:	50                   	push   %eax
80101393:	e8 1e ee ff ff       	call   801001b6 <bread>
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a1:	83 c0 18             	add    $0x18,%eax
801013a4:	83 ec 04             	sub    $0x4,%esp
801013a7:	6a 1c                	push   $0x1c
801013a9:	50                   	push   %eax
801013aa:	ff 75 0c             	pushl  0xc(%ebp)
801013ad:	e8 92 43 00 00       	call   80105744 <memmove>
801013b2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
801013b8:	ff 75 f4             	pushl  -0xc(%ebp)
801013bb:	e8 6e ee ff ff       	call   8010022e <brelse>
801013c0:	83 c4 10             	add    $0x10,%esp
}
801013c3:	90                   	nop
801013c4:	c9                   	leave  
801013c5:	c3                   	ret    

801013c6 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013c6:	55                   	push   %ebp
801013c7:	89 e5                	mov    %esp,%ebp
801013c9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	83 ec 08             	sub    $0x8,%esp
801013d5:	52                   	push   %edx
801013d6:	50                   	push   %eax
801013d7:	e8 da ed ff ff       	call   801001b6 <bread>
801013dc:	83 c4 10             	add    $0x10,%esp
801013df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e5:	83 c0 18             	add    $0x18,%eax
801013e8:	83 ec 04             	sub    $0x4,%esp
801013eb:	68 00 02 00 00       	push   $0x200
801013f0:	6a 00                	push   $0x0
801013f2:	50                   	push   %eax
801013f3:	e8 8d 42 00 00       	call   80105685 <memset>
801013f8:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013fb:	83 ec 0c             	sub    $0xc,%esp
801013fe:	ff 75 f4             	pushl  -0xc(%ebp)
80101401:	e8 cf 23 00 00       	call   801037d5 <log_write>
80101406:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101409:	83 ec 0c             	sub    $0xc,%esp
8010140c:	ff 75 f4             	pushl  -0xc(%ebp)
8010140f:	e8 1a ee ff ff       	call   8010022e <brelse>
80101414:	83 c4 10             	add    $0x10,%esp
}
80101417:	90                   	nop
80101418:	c9                   	leave  
80101419:	c3                   	ret    

8010141a <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010141a:	55                   	push   %ebp
8010141b:	89 e5                	mov    %esp,%ebp
8010141d:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101420:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010142e:	e9 13 01 00 00       	jmp    80101546 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101436:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010143c:	85 c0                	test   %eax,%eax
8010143e:	0f 48 c2             	cmovs  %edx,%eax
80101441:	c1 f8 0c             	sar    $0xc,%eax
80101444:	89 c2                	mov    %eax,%edx
80101446:	a1 58 22 11 80       	mov    0x80112258,%eax
8010144b:	01 d0                	add    %edx,%eax
8010144d:	83 ec 08             	sub    $0x8,%esp
80101450:	50                   	push   %eax
80101451:	ff 75 08             	pushl  0x8(%ebp)
80101454:	e8 5d ed ff ff       	call   801001b6 <bread>
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101466:	e9 a6 00 00 00       	jmp    80101511 <balloc+0xf7>
      m = 1 << (bi % 8);
8010146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146e:	99                   	cltd   
8010146f:	c1 ea 1d             	shr    $0x1d,%edx
80101472:	01 d0                	add    %edx,%eax
80101474:	83 e0 07             	and    $0x7,%eax
80101477:	29 d0                	sub    %edx,%eax
80101479:	ba 01 00 00 00       	mov    $0x1,%edx
8010147e:	89 c1                	mov    %eax,%ecx
80101480:	d3 e2                	shl    %cl,%edx
80101482:	89 d0                	mov    %edx,%eax
80101484:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148a:	8d 50 07             	lea    0x7(%eax),%edx
8010148d:	85 c0                	test   %eax,%eax
8010148f:	0f 48 c2             	cmovs  %edx,%eax
80101492:	c1 f8 03             	sar    $0x3,%eax
80101495:	89 c2                	mov    %eax,%edx
80101497:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149a:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010149f:	0f b6 c0             	movzbl %al,%eax
801014a2:	23 45 e8             	and    -0x18(%ebp),%eax
801014a5:	85 c0                	test   %eax,%eax
801014a7:	75 64                	jne    8010150d <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ac:	8d 50 07             	lea    0x7(%eax),%edx
801014af:	85 c0                	test   %eax,%eax
801014b1:	0f 48 c2             	cmovs  %edx,%eax
801014b4:	c1 f8 03             	sar    $0x3,%eax
801014b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014ba:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014bf:	89 d1                	mov    %edx,%ecx
801014c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c4:	09 ca                	or     %ecx,%edx
801014c6:	89 d1                	mov    %edx,%ecx
801014c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014cb:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	ff 75 ec             	pushl  -0x14(%ebp)
801014d5:	e8 fb 22 00 00       	call   801037d5 <log_write>
801014da:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014dd:	83 ec 0c             	sub    $0xc,%esp
801014e0:	ff 75 ec             	pushl  -0x14(%ebp)
801014e3:	e8 46 ed ff ff       	call   8010022e <brelse>
801014e8:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f1:	01 c2                	add    %eax,%edx
801014f3:	8b 45 08             	mov    0x8(%ebp),%eax
801014f6:	83 ec 08             	sub    $0x8,%esp
801014f9:	52                   	push   %edx
801014fa:	50                   	push   %eax
801014fb:	e8 c6 fe ff ff       	call   801013c6 <bzero>
80101500:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101503:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101509:	01 d0                	add    %edx,%eax
8010150b:	eb 57                	jmp    80101564 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010150d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101511:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101518:	7f 17                	jg     80101531 <balloc+0x117>
8010151a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101520:	01 d0                	add    %edx,%eax
80101522:	89 c2                	mov    %eax,%edx
80101524:	a1 40 22 11 80       	mov    0x80112240,%eax
80101529:	39 c2                	cmp    %eax,%edx
8010152b:	0f 82 3a ff ff ff    	jb     8010146b <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	ff 75 ec             	pushl  -0x14(%ebp)
80101537:	e8 f2 ec ff ff       	call   8010022e <brelse>
8010153c:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010153f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101546:	8b 15 40 22 11 80    	mov    0x80112240,%edx
8010154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010154f:	39 c2                	cmp    %eax,%edx
80101551:	0f 87 dc fe ff ff    	ja     80101433 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101557:	83 ec 0c             	sub    $0xc,%esp
8010155a:	68 74 8b 10 80       	push   $0x80108b74
8010155f:	e8 02 f0 ff ff       	call   80100566 <panic>
}
80101564:	c9                   	leave  
80101565:	c3                   	ret    

80101566 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101566:	55                   	push   %ebp
80101567:	89 e5                	mov    %esp,%ebp
80101569:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010156c:	83 ec 08             	sub    $0x8,%esp
8010156f:	68 40 22 11 80       	push   $0x80112240
80101574:	ff 75 08             	pushl  0x8(%ebp)
80101577:	e8 08 fe ff ff       	call   80101384 <readsb>
8010157c:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010157f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101582:	c1 e8 0c             	shr    $0xc,%eax
80101585:	89 c2                	mov    %eax,%edx
80101587:	a1 58 22 11 80       	mov    0x80112258,%eax
8010158c:	01 c2                	add    %eax,%edx
8010158e:	8b 45 08             	mov    0x8(%ebp),%eax
80101591:	83 ec 08             	sub    $0x8,%esp
80101594:	52                   	push   %edx
80101595:	50                   	push   %eax
80101596:	e8 1b ec ff ff       	call   801001b6 <bread>
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a4:	25 ff 0f 00 00       	and    $0xfff,%eax
801015a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015af:	99                   	cltd   
801015b0:	c1 ea 1d             	shr    $0x1d,%edx
801015b3:	01 d0                	add    %edx,%eax
801015b5:	83 e0 07             	and    $0x7,%eax
801015b8:	29 d0                	sub    %edx,%eax
801015ba:	ba 01 00 00 00       	mov    $0x1,%edx
801015bf:	89 c1                	mov    %eax,%ecx
801015c1:	d3 e2                	shl    %cl,%edx
801015c3:	89 d0                	mov    %edx,%eax
801015c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015cb:	8d 50 07             	lea    0x7(%eax),%edx
801015ce:	85 c0                	test   %eax,%eax
801015d0:	0f 48 c2             	cmovs  %edx,%eax
801015d3:	c1 f8 03             	sar    $0x3,%eax
801015d6:	89 c2                	mov    %eax,%edx
801015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015db:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015e0:	0f b6 c0             	movzbl %al,%eax
801015e3:	23 45 ec             	and    -0x14(%ebp),%eax
801015e6:	85 c0                	test   %eax,%eax
801015e8:	75 0d                	jne    801015f7 <bfree+0x91>
    panic("freeing free block");
801015ea:	83 ec 0c             	sub    $0xc,%esp
801015ed:	68 8a 8b 10 80       	push   $0x80108b8a
801015f2:	e8 6f ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fa:	8d 50 07             	lea    0x7(%eax),%edx
801015fd:	85 c0                	test   %eax,%eax
801015ff:	0f 48 c2             	cmovs  %edx,%eax
80101602:	c1 f8 03             	sar    $0x3,%eax
80101605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101608:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010160d:	89 d1                	mov    %edx,%ecx
8010160f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101612:	f7 d2                	not    %edx
80101614:	21 ca                	and    %ecx,%edx
80101616:	89 d1                	mov    %edx,%ecx
80101618:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010161b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	ff 75 f4             	pushl  -0xc(%ebp)
80101625:	e8 ab 21 00 00       	call   801037d5 <log_write>
8010162a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	ff 75 f4             	pushl  -0xc(%ebp)
80101633:	e8 f6 eb ff ff       	call   8010022e <brelse>
80101638:	83 c4 10             	add    $0x10,%esp
}
8010163b:	90                   	nop
8010163c:	c9                   	leave  
8010163d:	c3                   	ret    

8010163e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010163e:	55                   	push   %ebp
8010163f:	89 e5                	mov    %esp,%ebp
80101641:	57                   	push   %edi
80101642:	56                   	push   %esi
80101643:	53                   	push   %ebx
80101644:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101647:	83 ec 08             	sub    $0x8,%esp
8010164a:	68 9d 8b 10 80       	push   $0x80108b9d
8010164f:	68 60 22 11 80       	push   $0x80112260
80101654:	e8 a7 3d 00 00       	call   80105400 <initlock>
80101659:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010165c:	83 ec 08             	sub    $0x8,%esp
8010165f:	68 40 22 11 80       	push   $0x80112240
80101664:	ff 75 08             	pushl  0x8(%ebp)
80101667:	e8 18 fd ff ff       	call   80101384 <readsb>
8010166c:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010166f:	a1 58 22 11 80       	mov    0x80112258,%eax
80101674:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101677:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
8010167d:	8b 35 50 22 11 80    	mov    0x80112250,%esi
80101683:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
80101689:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
8010168f:	8b 15 44 22 11 80    	mov    0x80112244,%edx
80101695:	a1 40 22 11 80       	mov    0x80112240,%eax
8010169a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010169d:	57                   	push   %edi
8010169e:	56                   	push   %esi
8010169f:	53                   	push   %ebx
801016a0:	51                   	push   %ecx
801016a1:	52                   	push   %edx
801016a2:	50                   	push   %eax
801016a3:	68 a4 8b 10 80       	push   $0x80108ba4
801016a8:	e8 19 ed ff ff       	call   801003c6 <cprintf>
801016ad:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016b0:	90                   	nop
801016b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5f                   	pop    %edi
801016b7:	5d                   	pop    %ebp
801016b8:	c3                   	ret    

801016b9 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016b9:	55                   	push   %ebp
801016ba:	89 e5                	mov    %esp,%ebp
801016bc:	83 ec 28             	sub    $0x28,%esp
801016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801016c2:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016c6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016cd:	e9 9e 00 00 00       	jmp    80101770 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d5:	c1 e8 03             	shr    $0x3,%eax
801016d8:	89 c2                	mov    %eax,%edx
801016da:	a1 54 22 11 80       	mov    0x80112254,%eax
801016df:	01 d0                	add    %edx,%eax
801016e1:	83 ec 08             	sub    $0x8,%esp
801016e4:	50                   	push   %eax
801016e5:	ff 75 08             	pushl  0x8(%ebp)
801016e8:	e8 c9 ea ff ff       	call   801001b6 <bread>
801016ed:	83 c4 10             	add    $0x10,%esp
801016f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f6:	8d 50 18             	lea    0x18(%eax),%edx
801016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016fc:	83 e0 07             	and    $0x7,%eax
801016ff:	c1 e0 06             	shl    $0x6,%eax
80101702:	01 d0                	add    %edx,%eax
80101704:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101707:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010170a:	0f b7 00             	movzwl (%eax),%eax
8010170d:	66 85 c0             	test   %ax,%ax
80101710:	75 4c                	jne    8010175e <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101712:	83 ec 04             	sub    $0x4,%esp
80101715:	6a 40                	push   $0x40
80101717:	6a 00                	push   $0x0
80101719:	ff 75 ec             	pushl  -0x14(%ebp)
8010171c:	e8 64 3f 00 00       	call   80105685 <memset>
80101721:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101724:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101727:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010172b:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010172e:	83 ec 0c             	sub    $0xc,%esp
80101731:	ff 75 f0             	pushl  -0x10(%ebp)
80101734:	e8 9c 20 00 00       	call   801037d5 <log_write>
80101739:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010173c:	83 ec 0c             	sub    $0xc,%esp
8010173f:	ff 75 f0             	pushl  -0x10(%ebp)
80101742:	e8 e7 ea ff ff       	call   8010022e <brelse>
80101747:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174d:	83 ec 08             	sub    $0x8,%esp
80101750:	50                   	push   %eax
80101751:	ff 75 08             	pushl  0x8(%ebp)
80101754:	e8 f8 00 00 00       	call   80101851 <iget>
80101759:	83 c4 10             	add    $0x10,%esp
8010175c:	eb 30                	jmp    8010178e <ialloc+0xd5>
    }
    brelse(bp);
8010175e:	83 ec 0c             	sub    $0xc,%esp
80101761:	ff 75 f0             	pushl  -0x10(%ebp)
80101764:	e8 c5 ea ff ff       	call   8010022e <brelse>
80101769:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010176c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101770:	8b 15 48 22 11 80    	mov    0x80112248,%edx
80101776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101779:	39 c2                	cmp    %eax,%edx
8010177b:	0f 87 51 ff ff ff    	ja     801016d2 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101781:	83 ec 0c             	sub    $0xc,%esp
80101784:	68 f7 8b 10 80       	push   $0x80108bf7
80101789:	e8 d8 ed ff ff       	call   80100566 <panic>
}
8010178e:	c9                   	leave  
8010178f:	c3                   	ret    

80101790 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101796:	8b 45 08             	mov    0x8(%ebp),%eax
80101799:	8b 40 04             	mov    0x4(%eax),%eax
8010179c:	c1 e8 03             	shr    $0x3,%eax
8010179f:	89 c2                	mov    %eax,%edx
801017a1:	a1 54 22 11 80       	mov    0x80112254,%eax
801017a6:	01 c2                	add    %eax,%edx
801017a8:	8b 45 08             	mov    0x8(%ebp),%eax
801017ab:	8b 00                	mov    (%eax),%eax
801017ad:	83 ec 08             	sub    $0x8,%esp
801017b0:	52                   	push   %edx
801017b1:	50                   	push   %eax
801017b2:	e8 ff e9 ff ff       	call   801001b6 <bread>
801017b7:	83 c4 10             	add    $0x10,%esp
801017ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c0:	8d 50 18             	lea    0x18(%eax),%edx
801017c3:	8b 45 08             	mov    0x8(%ebp),%eax
801017c6:	8b 40 04             	mov    0x4(%eax),%eax
801017c9:	83 e0 07             	and    $0x7,%eax
801017cc:	c1 e0 06             	shl    $0x6,%eax
801017cf:	01 d0                	add    %edx,%eax
801017d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017d4:	8b 45 08             	mov    0x8(%ebp),%eax
801017d7:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017de:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017e1:	8b 45 08             	mov    0x8(%ebp),%eax
801017e4:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017eb:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017ef:	8b 45 08             	mov    0x8(%ebp),%eax
801017f2:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f9:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101800:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101807:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010180b:	8b 45 08             	mov    0x8(%ebp),%eax
8010180e:	8b 50 18             	mov    0x18(%eax),%edx
80101811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101814:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101817:	8b 45 08             	mov    0x8(%ebp),%eax
8010181a:	8d 50 1c             	lea    0x1c(%eax),%edx
8010181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101820:	83 c0 0c             	add    $0xc,%eax
80101823:	83 ec 04             	sub    $0x4,%esp
80101826:	6a 2c                	push   $0x2c
80101828:	52                   	push   %edx
80101829:	50                   	push   %eax
8010182a:	e8 15 3f 00 00       	call   80105744 <memmove>
8010182f:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101832:	83 ec 0c             	sub    $0xc,%esp
80101835:	ff 75 f4             	pushl  -0xc(%ebp)
80101838:	e8 98 1f 00 00       	call   801037d5 <log_write>
8010183d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101840:	83 ec 0c             	sub    $0xc,%esp
80101843:	ff 75 f4             	pushl  -0xc(%ebp)
80101846:	e8 e3 e9 ff ff       	call   8010022e <brelse>
8010184b:	83 c4 10             	add    $0x10,%esp
}
8010184e:	90                   	nop
8010184f:	c9                   	leave  
80101850:	c3                   	ret    

80101851 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101851:	55                   	push   %ebp
80101852:	89 e5                	mov    %esp,%ebp
80101854:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 60 22 11 80       	push   $0x80112260
8010185f:	e8 be 3b 00 00       	call   80105422 <acquire>
80101864:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101867:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186e:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
80101875:	eb 5d                	jmp    801018d4 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	8b 40 08             	mov    0x8(%eax),%eax
8010187d:	85 c0                	test   %eax,%eax
8010187f:	7e 39                	jle    801018ba <iget+0x69>
80101881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101884:	8b 00                	mov    (%eax),%eax
80101886:	3b 45 08             	cmp    0x8(%ebp),%eax
80101889:	75 2f                	jne    801018ba <iget+0x69>
8010188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188e:	8b 40 04             	mov    0x4(%eax),%eax
80101891:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101894:	75 24                	jne    801018ba <iget+0x69>
      ip->ref++;
80101896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101899:	8b 40 08             	mov    0x8(%eax),%eax
8010189c:	8d 50 01             	lea    0x1(%eax),%edx
8010189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a2:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018a5:	83 ec 0c             	sub    $0xc,%esp
801018a8:	68 60 22 11 80       	push   $0x80112260
801018ad:	e8 d7 3b 00 00       	call   80105489 <release>
801018b2:	83 c4 10             	add    $0x10,%esp
      return ip;
801018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b8:	eb 74                	jmp    8010192e <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018be:	75 10                	jne    801018d0 <iget+0x7f>
801018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c3:	8b 40 08             	mov    0x8(%eax),%eax
801018c6:	85 c0                	test   %eax,%eax
801018c8:	75 06                	jne    801018d0 <iget+0x7f>
      empty = ip;
801018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018d0:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801018d4:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
801018db:	72 9a                	jb     80101877 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018e1:	75 0d                	jne    801018f0 <iget+0x9f>
    panic("iget: no inodes");
801018e3:	83 ec 0c             	sub    $0xc,%esp
801018e6:	68 09 8c 10 80       	push   $0x80108c09
801018eb:	e8 76 ec ff ff       	call   80100566 <panic>

  ip = empty;
801018f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f9:	8b 55 08             	mov    0x8(%ebp),%edx
801018fc:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101901:	8b 55 0c             	mov    0xc(%ebp),%edx
80101904:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101914:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010191b:	83 ec 0c             	sub    $0xc,%esp
8010191e:	68 60 22 11 80       	push   $0x80112260
80101923:	e8 61 3b 00 00       	call   80105489 <release>
80101928:	83 c4 10             	add    $0x10,%esp

  return ip;
8010192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010192e:	c9                   	leave  
8010192f:	c3                   	ret    

80101930 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101936:	83 ec 0c             	sub    $0xc,%esp
80101939:	68 60 22 11 80       	push   $0x80112260
8010193e:	e8 df 3a 00 00       	call   80105422 <acquire>
80101943:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101946:	8b 45 08             	mov    0x8(%ebp),%eax
80101949:	8b 40 08             	mov    0x8(%eax),%eax
8010194c:	8d 50 01             	lea    0x1(%eax),%edx
8010194f:	8b 45 08             	mov    0x8(%ebp),%eax
80101952:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101955:	83 ec 0c             	sub    $0xc,%esp
80101958:	68 60 22 11 80       	push   $0x80112260
8010195d:	e8 27 3b 00 00       	call   80105489 <release>
80101962:	83 c4 10             	add    $0x10,%esp
  return ip;
80101965:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101968:	c9                   	leave  
80101969:	c3                   	ret    

8010196a <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010196a:	55                   	push   %ebp
8010196b:	89 e5                	mov    %esp,%ebp
8010196d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101970:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101974:	74 0a                	je     80101980 <ilock+0x16>
80101976:	8b 45 08             	mov    0x8(%ebp),%eax
80101979:	8b 40 08             	mov    0x8(%eax),%eax
8010197c:	85 c0                	test   %eax,%eax
8010197e:	7f 0d                	jg     8010198d <ilock+0x23>
    panic("ilock");
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	68 19 8c 10 80       	push   $0x80108c19
80101988:	e8 d9 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010198d:	83 ec 0c             	sub    $0xc,%esp
80101990:	68 60 22 11 80       	push   $0x80112260
80101995:	e8 88 3a 00 00       	call   80105422 <acquire>
8010199a:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010199d:	eb 13                	jmp    801019b2 <ilock+0x48>
    sleep(ip, &icache.lock);
8010199f:	83 ec 08             	sub    $0x8,%esp
801019a2:	68 60 22 11 80       	push   $0x80112260
801019a7:	ff 75 08             	pushl  0x8(%ebp)
801019aa:	e8 dc 34 00 00       	call   80104e8b <sleep>
801019af:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801019b2:	8b 45 08             	mov    0x8(%ebp),%eax
801019b5:	8b 40 0c             	mov    0xc(%eax),%eax
801019b8:	83 e0 01             	and    $0x1,%eax
801019bb:	85 c0                	test   %eax,%eax
801019bd:	75 e0                	jne    8010199f <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801019bf:	8b 45 08             	mov    0x8(%ebp),%eax
801019c2:	8b 40 0c             	mov    0xc(%eax),%eax
801019c5:	83 c8 01             	or     $0x1,%eax
801019c8:	89 c2                	mov    %eax,%edx
801019ca:	8b 45 08             	mov    0x8(%ebp),%eax
801019cd:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	68 60 22 11 80       	push   $0x80112260
801019d8:	e8 ac 3a 00 00       	call   80105489 <release>
801019dd:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019e0:	8b 45 08             	mov    0x8(%ebp),%eax
801019e3:	8b 40 0c             	mov    0xc(%eax),%eax
801019e6:	83 e0 02             	and    $0x2,%eax
801019e9:	85 c0                	test   %eax,%eax
801019eb:	0f 85 fc 00 00 00    	jne    80101aed <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019f1:	8b 45 08             	mov    0x8(%ebp),%eax
801019f4:	8b 40 04             	mov    0x4(%eax),%eax
801019f7:	c1 e8 03             	shr    $0x3,%eax
801019fa:	89 c2                	mov    %eax,%edx
801019fc:	a1 54 22 11 80       	mov    0x80112254,%eax
80101a01:	01 c2                	add    %eax,%edx
80101a03:	8b 45 08             	mov    0x8(%ebp),%eax
80101a06:	8b 00                	mov    (%eax),%eax
80101a08:	83 ec 08             	sub    $0x8,%esp
80101a0b:	52                   	push   %edx
80101a0c:	50                   	push   %eax
80101a0d:	e8 a4 e7 ff ff       	call   801001b6 <bread>
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a1b:	8d 50 18             	lea    0x18(%eax),%edx
80101a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a21:	8b 40 04             	mov    0x4(%eax),%eax
80101a24:	83 e0 07             	and    $0x7,%eax
80101a27:	c1 e0 06             	shl    $0x6,%eax
80101a2a:	01 d0                	add    %edx,%eax
80101a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a32:	0f b7 10             	movzwl (%eax),%edx
80101a35:	8b 45 08             	mov    0x8(%ebp),%eax
80101a38:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a3f:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a43:	8b 45 08             	mov    0x8(%ebp),%eax
80101a46:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a4d:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a5b:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a62:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a69:	8b 50 08             	mov    0x8(%eax),%edx
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	89 50 18             	mov    %edx,0x18(%eax)
    #ifdef CS333_P4
    ip->uid = dip->uid;
80101a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a75:	0f b7 50 38          	movzwl 0x38(%eax),%edx
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	66 89 50 48          	mov    %dx,0x48(%eax)
    ip->gid = dip->gid;
80101a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a83:	0f b7 50 3a          	movzwl 0x3a(%eax),%edx
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	66 89 50 4a          	mov    %dx,0x4a(%eax)
    ip->mode = dip->mode;
80101a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a94:	8b 52 3c             	mov    0x3c(%edx),%edx
80101a97:	89 50 4c             	mov    %edx,0x4c(%eax)
    #endif 
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a9d:	8d 50 0c             	lea    0xc(%eax),%edx
80101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa3:	83 c0 1c             	add    $0x1c,%eax
80101aa6:	83 ec 04             	sub    $0x4,%esp
80101aa9:	6a 2c                	push   $0x2c
80101aab:	52                   	push   %edx
80101aac:	50                   	push   %eax
80101aad:	e8 92 3c 00 00       	call   80105744 <memmove>
80101ab2:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ab5:	83 ec 0c             	sub    $0xc,%esp
80101ab8:	ff 75 f4             	pushl  -0xc(%ebp)
80101abb:	e8 6e e7 ff ff       	call   8010022e <brelse>
80101ac0:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac9:	83 c8 02             	or     $0x2,%eax
80101acc:	89 c2                	mov    %eax,%edx
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101adb:	66 85 c0             	test   %ax,%ax
80101ade:	75 0d                	jne    80101aed <ilock+0x183>
      panic("ilock: no type");
80101ae0:	83 ec 0c             	sub    $0xc,%esp
80101ae3:	68 1f 8c 10 80       	push   $0x80108c1f
80101ae8:	e8 79 ea ff ff       	call   80100566 <panic>
  }
}
80101aed:	90                   	nop
80101aee:	c9                   	leave  
80101aef:	c3                   	ret    

80101af0 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101af6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101afa:	74 17                	je     80101b13 <iunlock+0x23>
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	8b 40 0c             	mov    0xc(%eax),%eax
80101b02:	83 e0 01             	and    $0x1,%eax
80101b05:	85 c0                	test   %eax,%eax
80101b07:	74 0a                	je     80101b13 <iunlock+0x23>
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 40 08             	mov    0x8(%eax),%eax
80101b0f:	85 c0                	test   %eax,%eax
80101b11:	7f 0d                	jg     80101b20 <iunlock+0x30>
    panic("iunlock");
80101b13:	83 ec 0c             	sub    $0xc,%esp
80101b16:	68 2e 8c 10 80       	push   $0x80108c2e
80101b1b:	e8 46 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b20:	83 ec 0c             	sub    $0xc,%esp
80101b23:	68 60 22 11 80       	push   $0x80112260
80101b28:	e8 f5 38 00 00       	call   80105422 <acquire>
80101b2d:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	8b 40 0c             	mov    0xc(%eax),%eax
80101b36:	83 e0 fe             	and    $0xfffffffe,%eax
80101b39:	89 c2                	mov    %eax,%edx
80101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3e:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	ff 75 08             	pushl  0x8(%ebp)
80101b47:	e8 2d 34 00 00       	call   80104f79 <wakeup>
80101b4c:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b4f:	83 ec 0c             	sub    $0xc,%esp
80101b52:	68 60 22 11 80       	push   $0x80112260
80101b57:	e8 2d 39 00 00       	call   80105489 <release>
80101b5c:	83 c4 10             	add    $0x10,%esp
}
80101b5f:	90                   	nop
80101b60:	c9                   	leave  
80101b61:	c3                   	ret    

80101b62 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b62:	55                   	push   %ebp
80101b63:	89 e5                	mov    %esp,%ebp
80101b65:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b68:	83 ec 0c             	sub    $0xc,%esp
80101b6b:	68 60 22 11 80       	push   $0x80112260
80101b70:	e8 ad 38 00 00       	call   80105422 <acquire>
80101b75:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b78:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7b:	8b 40 08             	mov    0x8(%eax),%eax
80101b7e:	83 f8 01             	cmp    $0x1,%eax
80101b81:	0f 85 a9 00 00 00    	jne    80101c30 <iput+0xce>
80101b87:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8a:	8b 40 0c             	mov    0xc(%eax),%eax
80101b8d:	83 e0 02             	and    $0x2,%eax
80101b90:	85 c0                	test   %eax,%eax
80101b92:	0f 84 98 00 00 00    	je     80101c30 <iput+0xce>
80101b98:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b9f:	66 85 c0             	test   %ax,%ax
80101ba2:	0f 85 88 00 00 00    	jne    80101c30 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bab:	8b 40 0c             	mov    0xc(%eax),%eax
80101bae:	83 e0 01             	and    $0x1,%eax
80101bb1:	85 c0                	test   %eax,%eax
80101bb3:	74 0d                	je     80101bc2 <iput+0x60>
      panic("iput busy");
80101bb5:	83 ec 0c             	sub    $0xc,%esp
80101bb8:	68 36 8c 10 80       	push   $0x80108c36
80101bbd:	e8 a4 e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc5:	8b 40 0c             	mov    0xc(%eax),%eax
80101bc8:	83 c8 01             	or     $0x1,%eax
80101bcb:	89 c2                	mov    %eax,%edx
80101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd0:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101bd3:	83 ec 0c             	sub    $0xc,%esp
80101bd6:	68 60 22 11 80       	push   $0x80112260
80101bdb:	e8 a9 38 00 00       	call   80105489 <release>
80101be0:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101be3:	83 ec 0c             	sub    $0xc,%esp
80101be6:	ff 75 08             	pushl  0x8(%ebp)
80101be9:	e8 a8 01 00 00       	call   80101d96 <itrunc>
80101bee:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf4:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101bfa:	83 ec 0c             	sub    $0xc,%esp
80101bfd:	ff 75 08             	pushl  0x8(%ebp)
80101c00:	e8 8b fb ff ff       	call   80101790 <iupdate>
80101c05:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c08:	83 ec 0c             	sub    $0xc,%esp
80101c0b:	68 60 22 11 80       	push   $0x80112260
80101c10:	e8 0d 38 00 00       	call   80105422 <acquire>
80101c15:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c18:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c22:	83 ec 0c             	sub    $0xc,%esp
80101c25:	ff 75 08             	pushl  0x8(%ebp)
80101c28:	e8 4c 33 00 00       	call   80104f79 <wakeup>
80101c2d:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c30:	8b 45 08             	mov    0x8(%ebp),%eax
80101c33:	8b 40 08             	mov    0x8(%eax),%eax
80101c36:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 60 22 11 80       	push   $0x80112260
80101c47:	e8 3d 38 00 00       	call   80105489 <release>
80101c4c:	83 c4 10             	add    $0x10,%esp
}
80101c4f:	90                   	nop
80101c50:	c9                   	leave  
80101c51:	c3                   	ret    

80101c52 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c52:	55                   	push   %ebp
80101c53:	89 e5                	mov    %esp,%ebp
80101c55:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c58:	83 ec 0c             	sub    $0xc,%esp
80101c5b:	ff 75 08             	pushl  0x8(%ebp)
80101c5e:	e8 8d fe ff ff       	call   80101af0 <iunlock>
80101c63:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c66:	83 ec 0c             	sub    $0xc,%esp
80101c69:	ff 75 08             	pushl  0x8(%ebp)
80101c6c:	e8 f1 fe ff ff       	call   80101b62 <iput>
80101c71:	83 c4 10             	add    $0x10,%esp
}
80101c74:	90                   	nop
80101c75:	c9                   	leave  
80101c76:	c3                   	ret    

80101c77 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c77:	55                   	push   %ebp
80101c78:	89 e5                	mov    %esp,%ebp
80101c7a:	53                   	push   %ebx
80101c7b:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c7e:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101c82:	77 42                	ja     80101cc6 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c84:	8b 45 08             	mov    0x8(%ebp),%eax
80101c87:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c8a:	83 c2 04             	add    $0x4,%edx
80101c8d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c98:	75 24                	jne    80101cbe <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9d:	8b 00                	mov    (%eax),%eax
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	50                   	push   %eax
80101ca3:	e8 72 f7 ff ff       	call   8010141a <balloc>
80101ca8:	83 c4 10             	add    $0x10,%esp
80101cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cb4:	8d 4a 04             	lea    0x4(%edx),%ecx
80101cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cba:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cc1:	e9 cb 00 00 00       	jmp    80101d91 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101cc6:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101cca:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cce:	0f 87 b0 00 00 00    	ja     80101d84 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd7:	8b 40 44             	mov    0x44(%eax),%eax
80101cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ce1:	75 1d                	jne    80101d00 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce6:	8b 00                	mov    (%eax),%eax
80101ce8:	83 ec 0c             	sub    $0xc,%esp
80101ceb:	50                   	push   %eax
80101cec:	e8 29 f7 ff ff       	call   8010141a <balloc>
80101cf1:	83 c4 10             	add    $0x10,%esp
80101cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cfd:	89 50 44             	mov    %edx,0x44(%eax)
    bp = bread(ip->dev, addr);
80101d00:	8b 45 08             	mov    0x8(%ebp),%eax
80101d03:	8b 00                	mov    (%eax),%eax
80101d05:	83 ec 08             	sub    $0x8,%esp
80101d08:	ff 75 f4             	pushl  -0xc(%ebp)
80101d0b:	50                   	push   %eax
80101d0c:	e8 a5 e4 ff ff       	call   801001b6 <bread>
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d1a:	83 c0 18             	add    $0x18,%eax
80101d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d2d:	01 d0                	add    %edx,%eax
80101d2f:	8b 00                	mov    (%eax),%eax
80101d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d38:	75 37                	jne    80101d71 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d47:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4d:	8b 00                	mov    (%eax),%eax
80101d4f:	83 ec 0c             	sub    $0xc,%esp
80101d52:	50                   	push   %eax
80101d53:	e8 c2 f6 ff ff       	call   8010141a <balloc>
80101d58:	83 c4 10             	add    $0x10,%esp
80101d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d61:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d63:	83 ec 0c             	sub    $0xc,%esp
80101d66:	ff 75 f0             	pushl  -0x10(%ebp)
80101d69:	e8 67 1a 00 00       	call   801037d5 <log_write>
80101d6e:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d71:	83 ec 0c             	sub    $0xc,%esp
80101d74:	ff 75 f0             	pushl  -0x10(%ebp)
80101d77:	e8 b2 e4 ff ff       	call   8010022e <brelse>
80101d7c:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d82:	eb 0d                	jmp    80101d91 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d84:	83 ec 0c             	sub    $0xc,%esp
80101d87:	68 40 8c 10 80       	push   $0x80108c40
80101d8c:	e8 d5 e7 ff ff       	call   80100566 <panic>
}
80101d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d94:	c9                   	leave  
80101d95:	c3                   	ret    

80101d96 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d96:	55                   	push   %ebp
80101d97:	89 e5                	mov    %esp,%ebp
80101d99:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101da3:	eb 45                	jmp    80101dea <itrunc+0x54>
    if(ip->addrs[i]){
80101da5:	8b 45 08             	mov    0x8(%ebp),%eax
80101da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dab:	83 c2 04             	add    $0x4,%edx
80101dae:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	74 30                	je     80101de6 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101db6:	8b 45 08             	mov    0x8(%ebp),%eax
80101db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dbc:	83 c2 04             	add    $0x4,%edx
80101dbf:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dc3:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc6:	8b 12                	mov    (%edx),%edx
80101dc8:	83 ec 08             	sub    $0x8,%esp
80101dcb:	50                   	push   %eax
80101dcc:	52                   	push   %edx
80101dcd:	e8 94 f7 ff ff       	call   80101566 <bfree>
80101dd2:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ddb:	83 c2 04             	add    $0x4,%edx
80101dde:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101de5:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101de6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dea:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101dee:	7e b5                	jle    80101da5 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	8b 40 44             	mov    0x44(%eax),%eax
80101df6:	85 c0                	test   %eax,%eax
80101df8:	0f 84 a1 00 00 00    	je     80101e9f <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80101e01:	8b 50 44             	mov    0x44(%eax),%edx
80101e04:	8b 45 08             	mov    0x8(%ebp),%eax
80101e07:	8b 00                	mov    (%eax),%eax
80101e09:	83 ec 08             	sub    $0x8,%esp
80101e0c:	52                   	push   %edx
80101e0d:	50                   	push   %eax
80101e0e:	e8 a3 e3 ff ff       	call   801001b6 <bread>
80101e13:	83 c4 10             	add    $0x10,%esp
80101e16:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e1c:	83 c0 18             	add    $0x18,%eax
80101e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e29:	eb 3c                	jmp    80101e67 <itrunc+0xd1>
      if(a[j])
80101e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e38:	01 d0                	add    %edx,%eax
80101e3a:	8b 00                	mov    (%eax),%eax
80101e3c:	85 c0                	test   %eax,%eax
80101e3e:	74 23                	je     80101e63 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e4d:	01 d0                	add    %edx,%eax
80101e4f:	8b 00                	mov    (%eax),%eax
80101e51:	8b 55 08             	mov    0x8(%ebp),%edx
80101e54:	8b 12                	mov    (%edx),%edx
80101e56:	83 ec 08             	sub    $0x8,%esp
80101e59:	50                   	push   %eax
80101e5a:	52                   	push   %edx
80101e5b:	e8 06 f7 ff ff       	call   80101566 <bfree>
80101e60:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e63:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6a:	83 f8 7f             	cmp    $0x7f,%eax
80101e6d:	76 bc                	jbe    80101e2b <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e6f:	83 ec 0c             	sub    $0xc,%esp
80101e72:	ff 75 ec             	pushl  -0x14(%ebp)
80101e75:	e8 b4 e3 ff ff       	call   8010022e <brelse>
80101e7a:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	8b 40 44             	mov    0x44(%eax),%eax
80101e83:	8b 55 08             	mov    0x8(%ebp),%edx
80101e86:	8b 12                	mov    (%edx),%edx
80101e88:	83 ec 08             	sub    $0x8,%esp
80101e8b:	50                   	push   %eax
80101e8c:	52                   	push   %edx
80101e8d:	e8 d4 f6 ff ff       	call   80101566 <bfree>
80101e92:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e95:	8b 45 08             	mov    0x8(%ebp),%eax
80101e98:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
  }

  ip->size = 0;
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101ea9:	83 ec 0c             	sub    $0xc,%esp
80101eac:	ff 75 08             	pushl  0x8(%ebp)
80101eaf:	e8 dc f8 ff ff       	call   80101790 <iupdate>
80101eb4:	83 c4 10             	add    $0x10,%esp
}
80101eb7:	90                   	nop
80101eb8:	c9                   	leave  
80101eb9:	c3                   	ret    

80101eba <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101eba:	55                   	push   %ebp
80101ebb:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec0:	8b 00                	mov    (%eax),%eax
80101ec2:	89 c2                	mov    %eax,%edx
80101ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec7:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101eca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecd:	8b 50 04             	mov    0x4(%eax),%edx
80101ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed3:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ed6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed9:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101edd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee0:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee6:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eed:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef4:	8b 50 18             	mov    0x18(%eax),%edx
80101ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101efa:	89 50 10             	mov    %edx,0x10(%eax)
  #ifdef CS333_P4
  st->uid = ip->uid;
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	0f b7 50 48          	movzwl 0x48(%eax),%edx
80101f04:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f07:	66 89 50 14          	mov    %dx,0x14(%eax)
  st->gid = ip->gid;
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0e:	0f b7 50 4a          	movzwl 0x4a(%eax),%edx
80101f12:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f15:	66 89 50 16          	mov    %dx,0x16(%eax)
  st->mode.asInt = ip->mode.asInt;
80101f19:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1c:	8b 50 4c             	mov    0x4c(%eax),%edx
80101f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f22:	89 50 18             	mov    %edx,0x18(%eax)
  #endif
}
80101f25:	90                   	nop
80101f26:	5d                   	pop    %ebp
80101f27:	c3                   	ret    

80101f28 <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f28:	55                   	push   %ebp
80101f29:	89 e5                	mov    %esp,%ebp
80101f2b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f31:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f35:	66 83 f8 03          	cmp    $0x3,%ax
80101f39:	75 5c                	jne    80101f97 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f42:	66 85 c0             	test   %ax,%ax
80101f45:	78 20                	js     80101f67 <readi+0x3f>
80101f47:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f4e:	66 83 f8 09          	cmp    $0x9,%ax
80101f52:	7f 13                	jg     80101f67 <readi+0x3f>
80101f54:	8b 45 08             	mov    0x8(%ebp),%eax
80101f57:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f5b:	98                   	cwtl   
80101f5c:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101f63:	85 c0                	test   %eax,%eax
80101f65:	75 0a                	jne    80101f71 <readi+0x49>
      return -1;
80101f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6c:	e9 0c 01 00 00       	jmp    8010207d <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f71:	8b 45 08             	mov    0x8(%ebp),%eax
80101f74:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f78:	98                   	cwtl   
80101f79:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101f80:	8b 55 14             	mov    0x14(%ebp),%edx
80101f83:	83 ec 04             	sub    $0x4,%esp
80101f86:	52                   	push   %edx
80101f87:	ff 75 0c             	pushl  0xc(%ebp)
80101f8a:	ff 75 08             	pushl  0x8(%ebp)
80101f8d:	ff d0                	call   *%eax
80101f8f:	83 c4 10             	add    $0x10,%esp
80101f92:	e9 e6 00 00 00       	jmp    8010207d <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f97:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9a:	8b 40 18             	mov    0x18(%eax),%eax
80101f9d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fa0:	72 0d                	jb     80101faf <readi+0x87>
80101fa2:	8b 55 10             	mov    0x10(%ebp),%edx
80101fa5:	8b 45 14             	mov    0x14(%ebp),%eax
80101fa8:	01 d0                	add    %edx,%eax
80101faa:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fad:	73 0a                	jae    80101fb9 <readi+0x91>
    return -1;
80101faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb4:	e9 c4 00 00 00       	jmp    8010207d <readi+0x155>
  if(off + n > ip->size)
80101fb9:	8b 55 10             	mov    0x10(%ebp),%edx
80101fbc:	8b 45 14             	mov    0x14(%ebp),%eax
80101fbf:	01 c2                	add    %eax,%edx
80101fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc4:	8b 40 18             	mov    0x18(%eax),%eax
80101fc7:	39 c2                	cmp    %eax,%edx
80101fc9:	76 0c                	jbe    80101fd7 <readi+0xaf>
    n = ip->size - off;
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fce:	8b 40 18             	mov    0x18(%eax),%eax
80101fd1:	2b 45 10             	sub    0x10(%ebp),%eax
80101fd4:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fde:	e9 8b 00 00 00       	jmp    8010206e <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fe3:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe6:	c1 e8 09             	shr    $0x9,%eax
80101fe9:	83 ec 08             	sub    $0x8,%esp
80101fec:	50                   	push   %eax
80101fed:	ff 75 08             	pushl  0x8(%ebp)
80101ff0:	e8 82 fc ff ff       	call   80101c77 <bmap>
80101ff5:	83 c4 10             	add    $0x10,%esp
80101ff8:	89 c2                	mov    %eax,%edx
80101ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffd:	8b 00                	mov    (%eax),%eax
80101fff:	83 ec 08             	sub    $0x8,%esp
80102002:	52                   	push   %edx
80102003:	50                   	push   %eax
80102004:	e8 ad e1 ff ff       	call   801001b6 <bread>
80102009:	83 c4 10             	add    $0x10,%esp
8010200c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010200f:	8b 45 10             	mov    0x10(%ebp),%eax
80102012:	25 ff 01 00 00       	and    $0x1ff,%eax
80102017:	ba 00 02 00 00       	mov    $0x200,%edx
8010201c:	29 c2                	sub    %eax,%edx
8010201e:	8b 45 14             	mov    0x14(%ebp),%eax
80102021:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102024:	39 c2                	cmp    %eax,%edx
80102026:	0f 46 c2             	cmovbe %edx,%eax
80102029:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202f:	8d 50 18             	lea    0x18(%eax),%edx
80102032:	8b 45 10             	mov    0x10(%ebp),%eax
80102035:	25 ff 01 00 00       	and    $0x1ff,%eax
8010203a:	01 d0                	add    %edx,%eax
8010203c:	83 ec 04             	sub    $0x4,%esp
8010203f:	ff 75 ec             	pushl  -0x14(%ebp)
80102042:	50                   	push   %eax
80102043:	ff 75 0c             	pushl  0xc(%ebp)
80102046:	e8 f9 36 00 00       	call   80105744 <memmove>
8010204b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010204e:	83 ec 0c             	sub    $0xc,%esp
80102051:	ff 75 f0             	pushl  -0x10(%ebp)
80102054:	e8 d5 e1 ff ff       	call   8010022e <brelse>
80102059:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010205c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010205f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102062:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102065:	01 45 10             	add    %eax,0x10(%ebp)
80102068:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010206b:	01 45 0c             	add    %eax,0xc(%ebp)
8010206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102071:	3b 45 14             	cmp    0x14(%ebp),%eax
80102074:	0f 82 69 ff ff ff    	jb     80101fe3 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010207a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010207d:	c9                   	leave  
8010207e:	c3                   	ret    

8010207f <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010207f:	55                   	push   %ebp
80102080:	89 e5                	mov    %esp,%ebp
80102082:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102085:	8b 45 08             	mov    0x8(%ebp),%eax
80102088:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010208c:	66 83 f8 03          	cmp    $0x3,%ax
80102090:	75 5c                	jne    801020ee <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102092:	8b 45 08             	mov    0x8(%ebp),%eax
80102095:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102099:	66 85 c0             	test   %ax,%ax
8010209c:	78 20                	js     801020be <writei+0x3f>
8010209e:	8b 45 08             	mov    0x8(%ebp),%eax
801020a1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020a5:	66 83 f8 09          	cmp    $0x9,%ax
801020a9:	7f 13                	jg     801020be <writei+0x3f>
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
801020ae:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020b2:	98                   	cwtl   
801020b3:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
801020ba:	85 c0                	test   %eax,%eax
801020bc:	75 0a                	jne    801020c8 <writei+0x49>
      return -1;
801020be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c3:	e9 3d 01 00 00       	jmp    80102205 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020cf:	98                   	cwtl   
801020d0:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
801020d7:	8b 55 14             	mov    0x14(%ebp),%edx
801020da:	83 ec 04             	sub    $0x4,%esp
801020dd:	52                   	push   %edx
801020de:	ff 75 0c             	pushl  0xc(%ebp)
801020e1:	ff 75 08             	pushl  0x8(%ebp)
801020e4:	ff d0                	call   *%eax
801020e6:	83 c4 10             	add    $0x10,%esp
801020e9:	e9 17 01 00 00       	jmp    80102205 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020ee:	8b 45 08             	mov    0x8(%ebp),%eax
801020f1:	8b 40 18             	mov    0x18(%eax),%eax
801020f4:	3b 45 10             	cmp    0x10(%ebp),%eax
801020f7:	72 0d                	jb     80102106 <writei+0x87>
801020f9:	8b 55 10             	mov    0x10(%ebp),%edx
801020fc:	8b 45 14             	mov    0x14(%ebp),%eax
801020ff:	01 d0                	add    %edx,%eax
80102101:	3b 45 10             	cmp    0x10(%ebp),%eax
80102104:	73 0a                	jae    80102110 <writei+0x91>
    return -1;
80102106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010210b:	e9 f5 00 00 00       	jmp    80102205 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102110:	8b 55 10             	mov    0x10(%ebp),%edx
80102113:	8b 45 14             	mov    0x14(%ebp),%eax
80102116:	01 d0                	add    %edx,%eax
80102118:	3d 00 14 01 00       	cmp    $0x11400,%eax
8010211d:	76 0a                	jbe    80102129 <writei+0xaa>
    return -1;
8010211f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102124:	e9 dc 00 00 00       	jmp    80102205 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102129:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102130:	e9 99 00 00 00       	jmp    801021ce <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102135:	8b 45 10             	mov    0x10(%ebp),%eax
80102138:	c1 e8 09             	shr    $0x9,%eax
8010213b:	83 ec 08             	sub    $0x8,%esp
8010213e:	50                   	push   %eax
8010213f:	ff 75 08             	pushl  0x8(%ebp)
80102142:	e8 30 fb ff ff       	call   80101c77 <bmap>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	89 c2                	mov    %eax,%edx
8010214c:	8b 45 08             	mov    0x8(%ebp),%eax
8010214f:	8b 00                	mov    (%eax),%eax
80102151:	83 ec 08             	sub    $0x8,%esp
80102154:	52                   	push   %edx
80102155:	50                   	push   %eax
80102156:	e8 5b e0 ff ff       	call   801001b6 <bread>
8010215b:	83 c4 10             	add    $0x10,%esp
8010215e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102161:	8b 45 10             	mov    0x10(%ebp),%eax
80102164:	25 ff 01 00 00       	and    $0x1ff,%eax
80102169:	ba 00 02 00 00       	mov    $0x200,%edx
8010216e:	29 c2                	sub    %eax,%edx
80102170:	8b 45 14             	mov    0x14(%ebp),%eax
80102173:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102176:	39 c2                	cmp    %eax,%edx
80102178:	0f 46 c2             	cmovbe %edx,%eax
8010217b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010217e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102181:	8d 50 18             	lea    0x18(%eax),%edx
80102184:	8b 45 10             	mov    0x10(%ebp),%eax
80102187:	25 ff 01 00 00       	and    $0x1ff,%eax
8010218c:	01 d0                	add    %edx,%eax
8010218e:	83 ec 04             	sub    $0x4,%esp
80102191:	ff 75 ec             	pushl  -0x14(%ebp)
80102194:	ff 75 0c             	pushl  0xc(%ebp)
80102197:	50                   	push   %eax
80102198:	e8 a7 35 00 00       	call   80105744 <memmove>
8010219d:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	ff 75 f0             	pushl  -0x10(%ebp)
801021a6:	e8 2a 16 00 00       	call   801037d5 <log_write>
801021ab:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021ae:	83 ec 0c             	sub    $0xc,%esp
801021b1:	ff 75 f0             	pushl  -0x10(%ebp)
801021b4:	e8 75 e0 ff ff       	call   8010022e <brelse>
801021b9:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021bf:	01 45 f4             	add    %eax,-0xc(%ebp)
801021c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021c5:	01 45 10             	add    %eax,0x10(%ebp)
801021c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021cb:	01 45 0c             	add    %eax,0xc(%ebp)
801021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021d1:	3b 45 14             	cmp    0x14(%ebp),%eax
801021d4:	0f 82 5b ff ff ff    	jb     80102135 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801021da:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021de:	74 22                	je     80102202 <writei+0x183>
801021e0:	8b 45 08             	mov    0x8(%ebp),%eax
801021e3:	8b 40 18             	mov    0x18(%eax),%eax
801021e6:	3b 45 10             	cmp    0x10(%ebp),%eax
801021e9:	73 17                	jae    80102202 <writei+0x183>
    ip->size = off;
801021eb:	8b 45 08             	mov    0x8(%ebp),%eax
801021ee:	8b 55 10             	mov    0x10(%ebp),%edx
801021f1:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801021f4:	83 ec 0c             	sub    $0xc,%esp
801021f7:	ff 75 08             	pushl  0x8(%ebp)
801021fa:	e8 91 f5 ff ff       	call   80101790 <iupdate>
801021ff:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102202:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102205:	c9                   	leave  
80102206:	c3                   	ret    

80102207 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80102207:	55                   	push   %ebp
80102208:	89 e5                	mov    %esp,%ebp
8010220a:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010220d:	83 ec 04             	sub    $0x4,%esp
80102210:	6a 0e                	push   $0xe
80102212:	ff 75 0c             	pushl  0xc(%ebp)
80102215:	ff 75 08             	pushl  0x8(%ebp)
80102218:	e8 bd 35 00 00       	call   801057da <strncmp>
8010221d:	83 c4 10             	add    $0x10,%esp
}
80102220:	c9                   	leave  
80102221:	c3                   	ret    

80102222 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102222:	55                   	push   %ebp
80102223:	89 e5                	mov    %esp,%ebp
80102225:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102228:	8b 45 08             	mov    0x8(%ebp),%eax
8010222b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010222f:	66 83 f8 01          	cmp    $0x1,%ax
80102233:	74 0d                	je     80102242 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 53 8c 10 80       	push   $0x80108c53
8010223d:	e8 24 e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102242:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102249:	eb 7b                	jmp    801022c6 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010224b:	6a 10                	push   $0x10
8010224d:	ff 75 f4             	pushl  -0xc(%ebp)
80102250:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102253:	50                   	push   %eax
80102254:	ff 75 08             	pushl  0x8(%ebp)
80102257:	e8 cc fc ff ff       	call   80101f28 <readi>
8010225c:	83 c4 10             	add    $0x10,%esp
8010225f:	83 f8 10             	cmp    $0x10,%eax
80102262:	74 0d                	je     80102271 <dirlookup+0x4f>
      panic("dirlink read");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 65 8c 10 80       	push   $0x80108c65
8010226c:	e8 f5 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102271:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102275:	66 85 c0             	test   %ax,%ax
80102278:	74 47                	je     801022c1 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010227a:	83 ec 08             	sub    $0x8,%esp
8010227d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102280:	83 c0 02             	add    $0x2,%eax
80102283:	50                   	push   %eax
80102284:	ff 75 0c             	pushl  0xc(%ebp)
80102287:	e8 7b ff ff ff       	call   80102207 <namecmp>
8010228c:	83 c4 10             	add    $0x10,%esp
8010228f:	85 c0                	test   %eax,%eax
80102291:	75 2f                	jne    801022c2 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102293:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102297:	74 08                	je     801022a1 <dirlookup+0x7f>
        *poff = off;
80102299:	8b 45 10             	mov    0x10(%ebp),%eax
8010229c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010229f:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022a1:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022a5:	0f b7 c0             	movzwl %ax,%eax
801022a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022ab:	8b 45 08             	mov    0x8(%ebp),%eax
801022ae:	8b 00                	mov    (%eax),%eax
801022b0:	83 ec 08             	sub    $0x8,%esp
801022b3:	ff 75 f0             	pushl  -0x10(%ebp)
801022b6:	50                   	push   %eax
801022b7:	e8 95 f5 ff ff       	call   80101851 <iget>
801022bc:	83 c4 10             	add    $0x10,%esp
801022bf:	eb 19                	jmp    801022da <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801022c1:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801022c2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022c6:	8b 45 08             	mov    0x8(%ebp),%eax
801022c9:	8b 40 18             	mov    0x18(%eax),%eax
801022cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022cf:	0f 87 76 ff ff ff    	ja     8010224b <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801022d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022da:	c9                   	leave  
801022db:	c3                   	ret    

801022dc <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022dc:	55                   	push   %ebp
801022dd:	89 e5                	mov    %esp,%ebp
801022df:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022e2:	83 ec 04             	sub    $0x4,%esp
801022e5:	6a 00                	push   $0x0
801022e7:	ff 75 0c             	pushl  0xc(%ebp)
801022ea:	ff 75 08             	pushl  0x8(%ebp)
801022ed:	e8 30 ff ff ff       	call   80102222 <dirlookup>
801022f2:	83 c4 10             	add    $0x10,%esp
801022f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022fc:	74 18                	je     80102316 <dirlink+0x3a>
    iput(ip);
801022fe:	83 ec 0c             	sub    $0xc,%esp
80102301:	ff 75 f0             	pushl  -0x10(%ebp)
80102304:	e8 59 f8 ff ff       	call   80101b62 <iput>
80102309:	83 c4 10             	add    $0x10,%esp
    return -1;
8010230c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102311:	e9 9c 00 00 00       	jmp    801023b2 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102316:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010231d:	eb 39                	jmp    80102358 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102322:	6a 10                	push   $0x10
80102324:	50                   	push   %eax
80102325:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102328:	50                   	push   %eax
80102329:	ff 75 08             	pushl  0x8(%ebp)
8010232c:	e8 f7 fb ff ff       	call   80101f28 <readi>
80102331:	83 c4 10             	add    $0x10,%esp
80102334:	83 f8 10             	cmp    $0x10,%eax
80102337:	74 0d                	je     80102346 <dirlink+0x6a>
      panic("dirlink read");
80102339:	83 ec 0c             	sub    $0xc,%esp
8010233c:	68 65 8c 10 80       	push   $0x80108c65
80102341:	e8 20 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102346:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010234a:	66 85 c0             	test   %ax,%ax
8010234d:	74 18                	je     80102367 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102352:	83 c0 10             	add    $0x10,%eax
80102355:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102358:	8b 45 08             	mov    0x8(%ebp),%eax
8010235b:	8b 50 18             	mov    0x18(%eax),%edx
8010235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102361:	39 c2                	cmp    %eax,%edx
80102363:	77 ba                	ja     8010231f <dirlink+0x43>
80102365:	eb 01                	jmp    80102368 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102367:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102368:	83 ec 04             	sub    $0x4,%esp
8010236b:	6a 0e                	push   $0xe
8010236d:	ff 75 0c             	pushl  0xc(%ebp)
80102370:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102373:	83 c0 02             	add    $0x2,%eax
80102376:	50                   	push   %eax
80102377:	e8 b4 34 00 00       	call   80105830 <strncpy>
8010237c:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010237f:	8b 45 10             	mov    0x10(%ebp),%eax
80102382:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102389:	6a 10                	push   $0x10
8010238b:	50                   	push   %eax
8010238c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010238f:	50                   	push   %eax
80102390:	ff 75 08             	pushl  0x8(%ebp)
80102393:	e8 e7 fc ff ff       	call   8010207f <writei>
80102398:	83 c4 10             	add    $0x10,%esp
8010239b:	83 f8 10             	cmp    $0x10,%eax
8010239e:	74 0d                	je     801023ad <dirlink+0xd1>
    panic("dirlink");
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 72 8c 10 80       	push   $0x80108c72
801023a8:	e8 b9 e1 ff ff       	call   80100566 <panic>
  
  return 0;
801023ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023b2:	c9                   	leave  
801023b3:	c3                   	ret    

801023b4 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801023b4:	55                   	push   %ebp
801023b5:	89 e5                	mov    %esp,%ebp
801023b7:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801023ba:	eb 04                	jmp    801023c0 <skipelem+0xc>
    path++;
801023bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801023c0:	8b 45 08             	mov    0x8(%ebp),%eax
801023c3:	0f b6 00             	movzbl (%eax),%eax
801023c6:	3c 2f                	cmp    $0x2f,%al
801023c8:	74 f2                	je     801023bc <skipelem+0x8>
    path++;
  if(*path == 0)
801023ca:	8b 45 08             	mov    0x8(%ebp),%eax
801023cd:	0f b6 00             	movzbl (%eax),%eax
801023d0:	84 c0                	test   %al,%al
801023d2:	75 07                	jne    801023db <skipelem+0x27>
    return 0;
801023d4:	b8 00 00 00 00       	mov    $0x0,%eax
801023d9:	eb 7b                	jmp    80102456 <skipelem+0xa2>
  s = path;
801023db:	8b 45 08             	mov    0x8(%ebp),%eax
801023de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023e1:	eb 04                	jmp    801023e7 <skipelem+0x33>
    path++;
801023e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023e7:	8b 45 08             	mov    0x8(%ebp),%eax
801023ea:	0f b6 00             	movzbl (%eax),%eax
801023ed:	3c 2f                	cmp    $0x2f,%al
801023ef:	74 0a                	je     801023fb <skipelem+0x47>
801023f1:	8b 45 08             	mov    0x8(%ebp),%eax
801023f4:	0f b6 00             	movzbl (%eax),%eax
801023f7:	84 c0                	test   %al,%al
801023f9:	75 e8                	jne    801023e3 <skipelem+0x2f>
    path++;
  len = path - s;
801023fb:	8b 55 08             	mov    0x8(%ebp),%edx
801023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102401:	29 c2                	sub    %eax,%edx
80102403:	89 d0                	mov    %edx,%eax
80102405:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102408:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010240c:	7e 15                	jle    80102423 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010240e:	83 ec 04             	sub    $0x4,%esp
80102411:	6a 0e                	push   $0xe
80102413:	ff 75 f4             	pushl  -0xc(%ebp)
80102416:	ff 75 0c             	pushl  0xc(%ebp)
80102419:	e8 26 33 00 00       	call   80105744 <memmove>
8010241e:	83 c4 10             	add    $0x10,%esp
80102421:	eb 26                	jmp    80102449 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102423:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102426:	83 ec 04             	sub    $0x4,%esp
80102429:	50                   	push   %eax
8010242a:	ff 75 f4             	pushl  -0xc(%ebp)
8010242d:	ff 75 0c             	pushl  0xc(%ebp)
80102430:	e8 0f 33 00 00       	call   80105744 <memmove>
80102435:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102438:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010243b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010243e:	01 d0                	add    %edx,%eax
80102440:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102443:	eb 04                	jmp    80102449 <skipelem+0x95>
    path++;
80102445:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102449:	8b 45 08             	mov    0x8(%ebp),%eax
8010244c:	0f b6 00             	movzbl (%eax),%eax
8010244f:	3c 2f                	cmp    $0x2f,%al
80102451:	74 f2                	je     80102445 <skipelem+0x91>
    path++;
  return path;
80102453:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102456:	c9                   	leave  
80102457:	c3                   	ret    

80102458 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102458:	55                   	push   %ebp
80102459:	89 e5                	mov    %esp,%ebp
8010245b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010245e:	8b 45 08             	mov    0x8(%ebp),%eax
80102461:	0f b6 00             	movzbl (%eax),%eax
80102464:	3c 2f                	cmp    $0x2f,%al
80102466:	75 17                	jne    8010247f <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102468:	83 ec 08             	sub    $0x8,%esp
8010246b:	6a 01                	push   $0x1
8010246d:	6a 01                	push   $0x1
8010246f:	e8 dd f3 ff ff       	call   80101851 <iget>
80102474:	83 c4 10             	add    $0x10,%esp
80102477:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010247a:	e9 bb 00 00 00       	jmp    8010253a <namex+0xe2>
  else
    ip = idup(proc->cwd);
8010247f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102485:	8b 40 68             	mov    0x68(%eax),%eax
80102488:	83 ec 0c             	sub    $0xc,%esp
8010248b:	50                   	push   %eax
8010248c:	e8 9f f4 ff ff       	call   80101930 <idup>
80102491:	83 c4 10             	add    $0x10,%esp
80102494:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102497:	e9 9e 00 00 00       	jmp    8010253a <namex+0xe2>
    ilock(ip);
8010249c:	83 ec 0c             	sub    $0xc,%esp
8010249f:	ff 75 f4             	pushl  -0xc(%ebp)
801024a2:	e8 c3 f4 ff ff       	call   8010196a <ilock>
801024a7:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024ad:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024b1:	66 83 f8 01          	cmp    $0x1,%ax
801024b5:	74 18                	je     801024cf <namex+0x77>
      iunlockput(ip);
801024b7:	83 ec 0c             	sub    $0xc,%esp
801024ba:	ff 75 f4             	pushl  -0xc(%ebp)
801024bd:	e8 90 f7 ff ff       	call   80101c52 <iunlockput>
801024c2:	83 c4 10             	add    $0x10,%esp
      return 0;
801024c5:	b8 00 00 00 00       	mov    $0x0,%eax
801024ca:	e9 a7 00 00 00       	jmp    80102576 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
801024cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024d3:	74 20                	je     801024f5 <namex+0x9d>
801024d5:	8b 45 08             	mov    0x8(%ebp),%eax
801024d8:	0f b6 00             	movzbl (%eax),%eax
801024db:	84 c0                	test   %al,%al
801024dd:	75 16                	jne    801024f5 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
801024df:	83 ec 0c             	sub    $0xc,%esp
801024e2:	ff 75 f4             	pushl  -0xc(%ebp)
801024e5:	e8 06 f6 ff ff       	call   80101af0 <iunlock>
801024ea:	83 c4 10             	add    $0x10,%esp
      return ip;
801024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f0:	e9 81 00 00 00       	jmp    80102576 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024f5:	83 ec 04             	sub    $0x4,%esp
801024f8:	6a 00                	push   $0x0
801024fa:	ff 75 10             	pushl  0x10(%ebp)
801024fd:	ff 75 f4             	pushl  -0xc(%ebp)
80102500:	e8 1d fd ff ff       	call   80102222 <dirlookup>
80102505:	83 c4 10             	add    $0x10,%esp
80102508:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010250b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010250f:	75 15                	jne    80102526 <namex+0xce>
      iunlockput(ip);
80102511:	83 ec 0c             	sub    $0xc,%esp
80102514:	ff 75 f4             	pushl  -0xc(%ebp)
80102517:	e8 36 f7 ff ff       	call   80101c52 <iunlockput>
8010251c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010251f:	b8 00 00 00 00       	mov    $0x0,%eax
80102524:	eb 50                	jmp    80102576 <namex+0x11e>
    }
    iunlockput(ip);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	ff 75 f4             	pushl  -0xc(%ebp)
8010252c:	e8 21 f7 ff ff       	call   80101c52 <iunlockput>
80102531:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102534:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010253a:	83 ec 08             	sub    $0x8,%esp
8010253d:	ff 75 10             	pushl  0x10(%ebp)
80102540:	ff 75 08             	pushl  0x8(%ebp)
80102543:	e8 6c fe ff ff       	call   801023b4 <skipelem>
80102548:	83 c4 10             	add    $0x10,%esp
8010254b:	89 45 08             	mov    %eax,0x8(%ebp)
8010254e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102552:	0f 85 44 ff ff ff    	jne    8010249c <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102558:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010255c:	74 15                	je     80102573 <namex+0x11b>
    iput(ip);
8010255e:	83 ec 0c             	sub    $0xc,%esp
80102561:	ff 75 f4             	pushl  -0xc(%ebp)
80102564:	e8 f9 f5 ff ff       	call   80101b62 <iput>
80102569:	83 c4 10             	add    $0x10,%esp
    return 0;
8010256c:	b8 00 00 00 00       	mov    $0x0,%eax
80102571:	eb 03                	jmp    80102576 <namex+0x11e>
  }
  return ip;
80102573:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102576:	c9                   	leave  
80102577:	c3                   	ret    

80102578 <namei>:

struct inode*
namei(char *path)
{
80102578:	55                   	push   %ebp
80102579:	89 e5                	mov    %esp,%ebp
8010257b:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010257e:	83 ec 04             	sub    $0x4,%esp
80102581:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102584:	50                   	push   %eax
80102585:	6a 00                	push   $0x0
80102587:	ff 75 08             	pushl  0x8(%ebp)
8010258a:	e8 c9 fe ff ff       	call   80102458 <namex>
8010258f:	83 c4 10             	add    $0x10,%esp
}
80102592:	c9                   	leave  
80102593:	c3                   	ret    

80102594 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102594:	55                   	push   %ebp
80102595:	89 e5                	mov    %esp,%ebp
80102597:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010259a:	83 ec 04             	sub    $0x4,%esp
8010259d:	ff 75 0c             	pushl  0xc(%ebp)
801025a0:	6a 01                	push   $0x1
801025a2:	ff 75 08             	pushl  0x8(%ebp)
801025a5:	e8 ae fe ff ff       	call   80102458 <namex>
801025aa:	83 c4 10             	add    $0x10,%esp
}
801025ad:	c9                   	leave  
801025ae:	c3                   	ret    

801025af <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801025af:	55                   	push   %ebp
801025b0:	89 e5                	mov    %esp,%ebp
801025b2:	83 ec 14             	sub    $0x14,%esp
801025b5:	8b 45 08             	mov    0x8(%ebp),%eax
801025b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801025c0:	89 c2                	mov    %eax,%edx
801025c2:	ec                   	in     (%dx),%al
801025c3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801025c6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025ca:	c9                   	leave  
801025cb:	c3                   	ret    

801025cc <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801025cc:	55                   	push   %ebp
801025cd:	89 e5                	mov    %esp,%ebp
801025cf:	57                   	push   %edi
801025d0:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025d1:	8b 55 08             	mov    0x8(%ebp),%edx
801025d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025d7:	8b 45 10             	mov    0x10(%ebp),%eax
801025da:	89 cb                	mov    %ecx,%ebx
801025dc:	89 df                	mov    %ebx,%edi
801025de:	89 c1                	mov    %eax,%ecx
801025e0:	fc                   	cld    
801025e1:	f3 6d                	rep insl (%dx),%es:(%edi)
801025e3:	89 c8                	mov    %ecx,%eax
801025e5:	89 fb                	mov    %edi,%ebx
801025e7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025ea:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801025ed:	90                   	nop
801025ee:	5b                   	pop    %ebx
801025ef:	5f                   	pop    %edi
801025f0:	5d                   	pop    %ebp
801025f1:	c3                   	ret    

801025f2 <outb>:

static inline void
outb(ushort port, uchar data)
{
801025f2:	55                   	push   %ebp
801025f3:	89 e5                	mov    %esp,%ebp
801025f5:	83 ec 08             	sub    $0x8,%esp
801025f8:	8b 55 08             	mov    0x8(%ebp),%edx
801025fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801025fe:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102602:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102605:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102609:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010260d:	ee                   	out    %al,(%dx)
}
8010260e:	90                   	nop
8010260f:	c9                   	leave  
80102610:	c3                   	ret    

80102611 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102611:	55                   	push   %ebp
80102612:	89 e5                	mov    %esp,%ebp
80102614:	56                   	push   %esi
80102615:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102616:	8b 55 08             	mov    0x8(%ebp),%edx
80102619:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010261c:	8b 45 10             	mov    0x10(%ebp),%eax
8010261f:	89 cb                	mov    %ecx,%ebx
80102621:	89 de                	mov    %ebx,%esi
80102623:	89 c1                	mov    %eax,%ecx
80102625:	fc                   	cld    
80102626:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102628:	89 c8                	mov    %ecx,%eax
8010262a:	89 f3                	mov    %esi,%ebx
8010262c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010262f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102632:	90                   	nop
80102633:	5b                   	pop    %ebx
80102634:	5e                   	pop    %esi
80102635:	5d                   	pop    %ebp
80102636:	c3                   	ret    

80102637 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102637:	55                   	push   %ebp
80102638:	89 e5                	mov    %esp,%ebp
8010263a:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010263d:	90                   	nop
8010263e:	68 f7 01 00 00       	push   $0x1f7
80102643:	e8 67 ff ff ff       	call   801025af <inb>
80102648:	83 c4 04             	add    $0x4,%esp
8010264b:	0f b6 c0             	movzbl %al,%eax
8010264e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102651:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102654:	25 c0 00 00 00       	and    $0xc0,%eax
80102659:	83 f8 40             	cmp    $0x40,%eax
8010265c:	75 e0                	jne    8010263e <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010265e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102662:	74 11                	je     80102675 <idewait+0x3e>
80102664:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102667:	83 e0 21             	and    $0x21,%eax
8010266a:	85 c0                	test   %eax,%eax
8010266c:	74 07                	je     80102675 <idewait+0x3e>
    return -1;
8010266e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102673:	eb 05                	jmp    8010267a <idewait+0x43>
  return 0;
80102675:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010267a:	c9                   	leave  
8010267b:	c3                   	ret    

8010267c <ideinit>:

void
ideinit(void)
{
8010267c:	55                   	push   %ebp
8010267d:	89 e5                	mov    %esp,%ebp
8010267f:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102682:	83 ec 08             	sub    $0x8,%esp
80102685:	68 7a 8c 10 80       	push   $0x80108c7a
8010268a:	68 20 c6 10 80       	push   $0x8010c620
8010268f:	e8 6c 2d 00 00       	call   80105400 <initlock>
80102694:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102697:	83 ec 0c             	sub    $0xc,%esp
8010269a:	6a 0e                	push   $0xe
8010269c:	e8 da 18 00 00       	call   80103f7b <picenable>
801026a1:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026a4:	a1 60 39 11 80       	mov    0x80113960,%eax
801026a9:	83 e8 01             	sub    $0x1,%eax
801026ac:	83 ec 08             	sub    $0x8,%esp
801026af:	50                   	push   %eax
801026b0:	6a 0e                	push   $0xe
801026b2:	e8 73 04 00 00       	call   80102b2a <ioapicenable>
801026b7:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801026ba:	83 ec 0c             	sub    $0xc,%esp
801026bd:	6a 00                	push   $0x0
801026bf:	e8 73 ff ff ff       	call   80102637 <idewait>
801026c4:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801026c7:	83 ec 08             	sub    $0x8,%esp
801026ca:	68 f0 00 00 00       	push   $0xf0
801026cf:	68 f6 01 00 00       	push   $0x1f6
801026d4:	e8 19 ff ff ff       	call   801025f2 <outb>
801026d9:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026e3:	eb 24                	jmp    80102709 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801026e5:	83 ec 0c             	sub    $0xc,%esp
801026e8:	68 f7 01 00 00       	push   $0x1f7
801026ed:	e8 bd fe ff ff       	call   801025af <inb>
801026f2:	83 c4 10             	add    $0x10,%esp
801026f5:	84 c0                	test   %al,%al
801026f7:	74 0c                	je     80102705 <ideinit+0x89>
      havedisk1 = 1;
801026f9:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102700:	00 00 00 
      break;
80102703:	eb 0d                	jmp    80102712 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102705:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102709:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102710:	7e d3                	jle    801026e5 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102712:	83 ec 08             	sub    $0x8,%esp
80102715:	68 e0 00 00 00       	push   $0xe0
8010271a:	68 f6 01 00 00       	push   $0x1f6
8010271f:	e8 ce fe ff ff       	call   801025f2 <outb>
80102724:	83 c4 10             	add    $0x10,%esp
}
80102727:	90                   	nop
80102728:	c9                   	leave  
80102729:	c3                   	ret    

8010272a <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010272a:	55                   	push   %ebp
8010272b:	89 e5                	mov    %esp,%ebp
8010272d:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102730:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102734:	75 0d                	jne    80102743 <idestart+0x19>
    panic("idestart");
80102736:	83 ec 0c             	sub    $0xc,%esp
80102739:	68 7e 8c 10 80       	push   $0x80108c7e
8010273e:	e8 23 de ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102743:	8b 45 08             	mov    0x8(%ebp),%eax
80102746:	8b 40 08             	mov    0x8(%eax),%eax
80102749:	3d cf 07 00 00       	cmp    $0x7cf,%eax
8010274e:	76 0d                	jbe    8010275d <idestart+0x33>
    panic("incorrect blockno");
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	68 87 8c 10 80       	push   $0x80108c87
80102758:	e8 09 de ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010275d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102764:	8b 45 08             	mov    0x8(%ebp),%eax
80102767:	8b 50 08             	mov    0x8(%eax),%edx
8010276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276d:	0f af c2             	imul   %edx,%eax
80102770:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102773:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102777:	7e 0d                	jle    80102786 <idestart+0x5c>
80102779:	83 ec 0c             	sub    $0xc,%esp
8010277c:	68 7e 8c 10 80       	push   $0x80108c7e
80102781:	e8 e0 dd ff ff       	call   80100566 <panic>
  
  idewait(0);
80102786:	83 ec 0c             	sub    $0xc,%esp
80102789:	6a 00                	push   $0x0
8010278b:	e8 a7 fe ff ff       	call   80102637 <idewait>
80102790:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102793:	83 ec 08             	sub    $0x8,%esp
80102796:	6a 00                	push   $0x0
80102798:	68 f6 03 00 00       	push   $0x3f6
8010279d:	e8 50 fe ff ff       	call   801025f2 <outb>
801027a2:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a8:	0f b6 c0             	movzbl %al,%eax
801027ab:	83 ec 08             	sub    $0x8,%esp
801027ae:	50                   	push   %eax
801027af:	68 f2 01 00 00       	push   $0x1f2
801027b4:	e8 39 fe ff ff       	call   801025f2 <outb>
801027b9:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027bf:	0f b6 c0             	movzbl %al,%eax
801027c2:	83 ec 08             	sub    $0x8,%esp
801027c5:	50                   	push   %eax
801027c6:	68 f3 01 00 00       	push   $0x1f3
801027cb:	e8 22 fe ff ff       	call   801025f2 <outb>
801027d0:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027d6:	c1 f8 08             	sar    $0x8,%eax
801027d9:	0f b6 c0             	movzbl %al,%eax
801027dc:	83 ec 08             	sub    $0x8,%esp
801027df:	50                   	push   %eax
801027e0:	68 f4 01 00 00       	push   $0x1f4
801027e5:	e8 08 fe ff ff       	call   801025f2 <outb>
801027ea:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027f0:	c1 f8 10             	sar    $0x10,%eax
801027f3:	0f b6 c0             	movzbl %al,%eax
801027f6:	83 ec 08             	sub    $0x8,%esp
801027f9:	50                   	push   %eax
801027fa:	68 f5 01 00 00       	push   $0x1f5
801027ff:	e8 ee fd ff ff       	call   801025f2 <outb>
80102804:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102807:	8b 45 08             	mov    0x8(%ebp),%eax
8010280a:	8b 40 04             	mov    0x4(%eax),%eax
8010280d:	83 e0 01             	and    $0x1,%eax
80102810:	c1 e0 04             	shl    $0x4,%eax
80102813:	89 c2                	mov    %eax,%edx
80102815:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102818:	c1 f8 18             	sar    $0x18,%eax
8010281b:	83 e0 0f             	and    $0xf,%eax
8010281e:	09 d0                	or     %edx,%eax
80102820:	83 c8 e0             	or     $0xffffffe0,%eax
80102823:	0f b6 c0             	movzbl %al,%eax
80102826:	83 ec 08             	sub    $0x8,%esp
80102829:	50                   	push   %eax
8010282a:	68 f6 01 00 00       	push   $0x1f6
8010282f:	e8 be fd ff ff       	call   801025f2 <outb>
80102834:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102837:	8b 45 08             	mov    0x8(%ebp),%eax
8010283a:	8b 00                	mov    (%eax),%eax
8010283c:	83 e0 04             	and    $0x4,%eax
8010283f:	85 c0                	test   %eax,%eax
80102841:	74 30                	je     80102873 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102843:	83 ec 08             	sub    $0x8,%esp
80102846:	6a 30                	push   $0x30
80102848:	68 f7 01 00 00       	push   $0x1f7
8010284d:	e8 a0 fd ff ff       	call   801025f2 <outb>
80102852:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102855:	8b 45 08             	mov    0x8(%ebp),%eax
80102858:	83 c0 18             	add    $0x18,%eax
8010285b:	83 ec 04             	sub    $0x4,%esp
8010285e:	68 80 00 00 00       	push   $0x80
80102863:	50                   	push   %eax
80102864:	68 f0 01 00 00       	push   $0x1f0
80102869:	e8 a3 fd ff ff       	call   80102611 <outsl>
8010286e:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102871:	eb 12                	jmp    80102885 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102873:	83 ec 08             	sub    $0x8,%esp
80102876:	6a 20                	push   $0x20
80102878:	68 f7 01 00 00       	push   $0x1f7
8010287d:	e8 70 fd ff ff       	call   801025f2 <outb>
80102882:	83 c4 10             	add    $0x10,%esp
  }
}
80102885:	90                   	nop
80102886:	c9                   	leave  
80102887:	c3                   	ret    

80102888 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102888:	55                   	push   %ebp
80102889:	89 e5                	mov    %esp,%ebp
8010288b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010288e:	83 ec 0c             	sub    $0xc,%esp
80102891:	68 20 c6 10 80       	push   $0x8010c620
80102896:	e8 87 2b 00 00       	call   80105422 <acquire>
8010289b:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
8010289e:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028aa:	75 15                	jne    801028c1 <ideintr+0x39>
    release(&idelock);
801028ac:	83 ec 0c             	sub    $0xc,%esp
801028af:	68 20 c6 10 80       	push   $0x8010c620
801028b4:	e8 d0 2b 00 00       	call   80105489 <release>
801028b9:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801028bc:	e9 9a 00 00 00       	jmp    8010295b <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c4:	8b 40 14             	mov    0x14(%eax),%eax
801028c7:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cf:	8b 00                	mov    (%eax),%eax
801028d1:	83 e0 04             	and    $0x4,%eax
801028d4:	85 c0                	test   %eax,%eax
801028d6:	75 2d                	jne    80102905 <ideintr+0x7d>
801028d8:	83 ec 0c             	sub    $0xc,%esp
801028db:	6a 01                	push   $0x1
801028dd:	e8 55 fd ff ff       	call   80102637 <idewait>
801028e2:	83 c4 10             	add    $0x10,%esp
801028e5:	85 c0                	test   %eax,%eax
801028e7:	78 1c                	js     80102905 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ec:	83 c0 18             	add    $0x18,%eax
801028ef:	83 ec 04             	sub    $0x4,%esp
801028f2:	68 80 00 00 00       	push   $0x80
801028f7:	50                   	push   %eax
801028f8:	68 f0 01 00 00       	push   $0x1f0
801028fd:	e8 ca fc ff ff       	call   801025cc <insl>
80102902:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102908:	8b 00                	mov    (%eax),%eax
8010290a:	83 c8 02             	or     $0x2,%eax
8010290d:	89 c2                	mov    %eax,%edx
8010290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102912:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102917:	8b 00                	mov    (%eax),%eax
80102919:	83 e0 fb             	and    $0xfffffffb,%eax
8010291c:	89 c2                	mov    %eax,%edx
8010291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102921:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102923:	83 ec 0c             	sub    $0xc,%esp
80102926:	ff 75 f4             	pushl  -0xc(%ebp)
80102929:	e8 4b 26 00 00       	call   80104f79 <wakeup>
8010292e:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102931:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102936:	85 c0                	test   %eax,%eax
80102938:	74 11                	je     8010294b <ideintr+0xc3>
    idestart(idequeue);
8010293a:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010293f:	83 ec 0c             	sub    $0xc,%esp
80102942:	50                   	push   %eax
80102943:	e8 e2 fd ff ff       	call   8010272a <idestart>
80102948:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010294b:	83 ec 0c             	sub    $0xc,%esp
8010294e:	68 20 c6 10 80       	push   $0x8010c620
80102953:	e8 31 2b 00 00       	call   80105489 <release>
80102958:	83 c4 10             	add    $0x10,%esp
}
8010295b:	c9                   	leave  
8010295c:	c3                   	ret    

8010295d <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010295d:	55                   	push   %ebp
8010295e:	89 e5                	mov    %esp,%ebp
80102960:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102963:	8b 45 08             	mov    0x8(%ebp),%eax
80102966:	8b 00                	mov    (%eax),%eax
80102968:	83 e0 01             	and    $0x1,%eax
8010296b:	85 c0                	test   %eax,%eax
8010296d:	75 0d                	jne    8010297c <iderw+0x1f>
    panic("iderw: buf not busy");
8010296f:	83 ec 0c             	sub    $0xc,%esp
80102972:	68 99 8c 10 80       	push   $0x80108c99
80102977:	e8 ea db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010297c:	8b 45 08             	mov    0x8(%ebp),%eax
8010297f:	8b 00                	mov    (%eax),%eax
80102981:	83 e0 06             	and    $0x6,%eax
80102984:	83 f8 02             	cmp    $0x2,%eax
80102987:	75 0d                	jne    80102996 <iderw+0x39>
    panic("iderw: nothing to do");
80102989:	83 ec 0c             	sub    $0xc,%esp
8010298c:	68 ad 8c 10 80       	push   $0x80108cad
80102991:	e8 d0 db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102996:	8b 45 08             	mov    0x8(%ebp),%eax
80102999:	8b 40 04             	mov    0x4(%eax),%eax
8010299c:	85 c0                	test   %eax,%eax
8010299e:	74 16                	je     801029b6 <iderw+0x59>
801029a0:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	75 0d                	jne    801029b6 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029a9:	83 ec 0c             	sub    $0xc,%esp
801029ac:	68 c2 8c 10 80       	push   $0x80108cc2
801029b1:	e8 b0 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029b6:	83 ec 0c             	sub    $0xc,%esp
801029b9:	68 20 c6 10 80       	push   $0x8010c620
801029be:	e8 5f 2a 00 00       	call   80105422 <acquire>
801029c3:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029c6:	8b 45 08             	mov    0x8(%ebp),%eax
801029c9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029d0:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801029d7:	eb 0b                	jmp    801029e4 <iderw+0x87>
801029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029dc:	8b 00                	mov    (%eax),%eax
801029de:	83 c0 14             	add    $0x14,%eax
801029e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e7:	8b 00                	mov    (%eax),%eax
801029e9:	85 c0                	test   %eax,%eax
801029eb:	75 ec                	jne    801029d9 <iderw+0x7c>
    ;
  *pp = b;
801029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f0:	8b 55 08             	mov    0x8(%ebp),%edx
801029f3:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801029f5:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801029fa:	3b 45 08             	cmp    0x8(%ebp),%eax
801029fd:	75 23                	jne    80102a22 <iderw+0xc5>
    idestart(b);
801029ff:	83 ec 0c             	sub    $0xc,%esp
80102a02:	ff 75 08             	pushl  0x8(%ebp)
80102a05:	e8 20 fd ff ff       	call   8010272a <idestart>
80102a0a:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a0d:	eb 13                	jmp    80102a22 <iderw+0xc5>
    sleep(b, &idelock);
80102a0f:	83 ec 08             	sub    $0x8,%esp
80102a12:	68 20 c6 10 80       	push   $0x8010c620
80102a17:	ff 75 08             	pushl  0x8(%ebp)
80102a1a:	e8 6c 24 00 00       	call   80104e8b <sleep>
80102a1f:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a22:	8b 45 08             	mov    0x8(%ebp),%eax
80102a25:	8b 00                	mov    (%eax),%eax
80102a27:	83 e0 06             	and    $0x6,%eax
80102a2a:	83 f8 02             	cmp    $0x2,%eax
80102a2d:	75 e0                	jne    80102a0f <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a2f:	83 ec 0c             	sub    $0xc,%esp
80102a32:	68 20 c6 10 80       	push   $0x8010c620
80102a37:	e8 4d 2a 00 00       	call   80105489 <release>
80102a3c:	83 c4 10             	add    $0x10,%esp
}
80102a3f:	90                   	nop
80102a40:	c9                   	leave  
80102a41:	c3                   	ret    

80102a42 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a42:	55                   	push   %ebp
80102a43:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a45:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a4a:	8b 55 08             	mov    0x8(%ebp),%edx
80102a4d:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a4f:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a54:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a57:	5d                   	pop    %ebp
80102a58:	c3                   	ret    

80102a59 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a59:	55                   	push   %ebp
80102a5a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a5c:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a61:	8b 55 08             	mov    0x8(%ebp),%edx
80102a64:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a66:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a6e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a71:	90                   	nop
80102a72:	5d                   	pop    %ebp
80102a73:	c3                   	ret    

80102a74 <ioapicinit>:

void
ioapicinit(void)
{
80102a74:	55                   	push   %ebp
80102a75:	89 e5                	mov    %esp,%ebp
80102a77:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102a7a:	a1 64 33 11 80       	mov    0x80113364,%eax
80102a7f:	85 c0                	test   %eax,%eax
80102a81:	0f 84 a0 00 00 00    	je     80102b27 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a87:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
80102a8e:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a91:	6a 01                	push   $0x1
80102a93:	e8 aa ff ff ff       	call   80102a42 <ioapicread>
80102a98:	83 c4 04             	add    $0x4,%esp
80102a9b:	c1 e8 10             	shr    $0x10,%eax
80102a9e:	25 ff 00 00 00       	and    $0xff,%eax
80102aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102aa6:	6a 00                	push   $0x0
80102aa8:	e8 95 ff ff ff       	call   80102a42 <ioapicread>
80102aad:	83 c4 04             	add    $0x4,%esp
80102ab0:	c1 e8 18             	shr    $0x18,%eax
80102ab3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ab6:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102abd:	0f b6 c0             	movzbl %al,%eax
80102ac0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102ac3:	74 10                	je     80102ad5 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ac5:	83 ec 0c             	sub    $0xc,%esp
80102ac8:	68 e0 8c 10 80       	push   $0x80108ce0
80102acd:	e8 f4 d8 ff ff       	call   801003c6 <cprintf>
80102ad2:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102adc:	eb 3f                	jmp    80102b1d <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae1:	83 c0 20             	add    $0x20,%eax
80102ae4:	0d 00 00 01 00       	or     $0x10000,%eax
80102ae9:	89 c2                	mov    %eax,%edx
80102aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aee:	83 c0 08             	add    $0x8,%eax
80102af1:	01 c0                	add    %eax,%eax
80102af3:	83 ec 08             	sub    $0x8,%esp
80102af6:	52                   	push   %edx
80102af7:	50                   	push   %eax
80102af8:	e8 5c ff ff ff       	call   80102a59 <ioapicwrite>
80102afd:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b03:	83 c0 08             	add    $0x8,%eax
80102b06:	01 c0                	add    %eax,%eax
80102b08:	83 c0 01             	add    $0x1,%eax
80102b0b:	83 ec 08             	sub    $0x8,%esp
80102b0e:	6a 00                	push   $0x0
80102b10:	50                   	push   %eax
80102b11:	e8 43 ff ff ff       	call   80102a59 <ioapicwrite>
80102b16:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b20:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b23:	7e b9                	jle    80102ade <ioapicinit+0x6a>
80102b25:	eb 01                	jmp    80102b28 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b27:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b28:	c9                   	leave  
80102b29:	c3                   	ret    

80102b2a <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b2a:	55                   	push   %ebp
80102b2b:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b2d:	a1 64 33 11 80       	mov    0x80113364,%eax
80102b32:	85 c0                	test   %eax,%eax
80102b34:	74 39                	je     80102b6f <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b36:	8b 45 08             	mov    0x8(%ebp),%eax
80102b39:	83 c0 20             	add    $0x20,%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b41:	83 c0 08             	add    $0x8,%eax
80102b44:	01 c0                	add    %eax,%eax
80102b46:	52                   	push   %edx
80102b47:	50                   	push   %eax
80102b48:	e8 0c ff ff ff       	call   80102a59 <ioapicwrite>
80102b4d:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b50:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b53:	c1 e0 18             	shl    $0x18,%eax
80102b56:	89 c2                	mov    %eax,%edx
80102b58:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5b:	83 c0 08             	add    $0x8,%eax
80102b5e:	01 c0                	add    %eax,%eax
80102b60:	83 c0 01             	add    $0x1,%eax
80102b63:	52                   	push   %edx
80102b64:	50                   	push   %eax
80102b65:	e8 ef fe ff ff       	call   80102a59 <ioapicwrite>
80102b6a:	83 c4 08             	add    $0x8,%esp
80102b6d:	eb 01                	jmp    80102b70 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102b6f:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102b70:	c9                   	leave  
80102b71:	c3                   	ret    

80102b72 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b72:	55                   	push   %ebp
80102b73:	89 e5                	mov    %esp,%ebp
80102b75:	8b 45 08             	mov    0x8(%ebp),%eax
80102b78:	05 00 00 00 80       	add    $0x80000000,%eax
80102b7d:	5d                   	pop    %ebp
80102b7e:	c3                   	ret    

80102b7f <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b7f:	55                   	push   %ebp
80102b80:	89 e5                	mov    %esp,%ebp
80102b82:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b85:	83 ec 08             	sub    $0x8,%esp
80102b88:	68 12 8d 10 80       	push   $0x80108d12
80102b8d:	68 40 32 11 80       	push   $0x80113240
80102b92:	e8 69 28 00 00       	call   80105400 <initlock>
80102b97:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b9a:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102ba1:	00 00 00 
  freerange(vstart, vend);
80102ba4:	83 ec 08             	sub    $0x8,%esp
80102ba7:	ff 75 0c             	pushl  0xc(%ebp)
80102baa:	ff 75 08             	pushl  0x8(%ebp)
80102bad:	e8 2a 00 00 00       	call   80102bdc <freerange>
80102bb2:	83 c4 10             	add    $0x10,%esp
}
80102bb5:	90                   	nop
80102bb6:	c9                   	leave  
80102bb7:	c3                   	ret    

80102bb8 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102bb8:	55                   	push   %ebp
80102bb9:	89 e5                	mov    %esp,%ebp
80102bbb:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102bbe:	83 ec 08             	sub    $0x8,%esp
80102bc1:	ff 75 0c             	pushl  0xc(%ebp)
80102bc4:	ff 75 08             	pushl  0x8(%ebp)
80102bc7:	e8 10 00 00 00       	call   80102bdc <freerange>
80102bcc:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bcf:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102bd6:	00 00 00 
}
80102bd9:	90                   	nop
80102bda:	c9                   	leave  
80102bdb:	c3                   	ret    

80102bdc <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bdc:	55                   	push   %ebp
80102bdd:	89 e5                	mov    %esp,%ebp
80102bdf:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102be2:	8b 45 08             	mov    0x8(%ebp),%eax
80102be5:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bf2:	eb 15                	jmp    80102c09 <freerange+0x2d>
    kfree(p);
80102bf4:	83 ec 0c             	sub    $0xc,%esp
80102bf7:	ff 75 f4             	pushl  -0xc(%ebp)
80102bfa:	e8 1a 00 00 00       	call   80102c19 <kfree>
80102bff:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c02:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0c:	05 00 10 00 00       	add    $0x1000,%eax
80102c11:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c14:	76 de                	jbe    80102bf4 <freerange+0x18>
    kfree(p);
}
80102c16:	90                   	nop
80102c17:	c9                   	leave  
80102c18:	c3                   	ret    

80102c19 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c19:	55                   	push   %ebp
80102c1a:	89 e5                	mov    %esp,%ebp
80102c1c:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c22:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c27:	85 c0                	test   %eax,%eax
80102c29:	75 1b                	jne    80102c46 <kfree+0x2d>
80102c2b:	81 7d 08 5c 66 11 80 	cmpl   $0x8011665c,0x8(%ebp)
80102c32:	72 12                	jb     80102c46 <kfree+0x2d>
80102c34:	ff 75 08             	pushl  0x8(%ebp)
80102c37:	e8 36 ff ff ff       	call   80102b72 <v2p>
80102c3c:	83 c4 04             	add    $0x4,%esp
80102c3f:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c44:	76 0d                	jbe    80102c53 <kfree+0x3a>
    panic("kfree");
80102c46:	83 ec 0c             	sub    $0xc,%esp
80102c49:	68 17 8d 10 80       	push   $0x80108d17
80102c4e:	e8 13 d9 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c53:	83 ec 04             	sub    $0x4,%esp
80102c56:	68 00 10 00 00       	push   $0x1000
80102c5b:	6a 01                	push   $0x1
80102c5d:	ff 75 08             	pushl  0x8(%ebp)
80102c60:	e8 20 2a 00 00       	call   80105685 <memset>
80102c65:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c68:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c6d:	85 c0                	test   %eax,%eax
80102c6f:	74 10                	je     80102c81 <kfree+0x68>
    acquire(&kmem.lock);
80102c71:	83 ec 0c             	sub    $0xc,%esp
80102c74:	68 40 32 11 80       	push   $0x80113240
80102c79:	e8 a4 27 00 00       	call   80105422 <acquire>
80102c7e:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c81:	8b 45 08             	mov    0x8(%ebp),%eax
80102c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c87:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c90:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c95:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102c9a:	a1 74 32 11 80       	mov    0x80113274,%eax
80102c9f:	85 c0                	test   %eax,%eax
80102ca1:	74 10                	je     80102cb3 <kfree+0x9a>
    release(&kmem.lock);
80102ca3:	83 ec 0c             	sub    $0xc,%esp
80102ca6:	68 40 32 11 80       	push   $0x80113240
80102cab:	e8 d9 27 00 00       	call   80105489 <release>
80102cb0:	83 c4 10             	add    $0x10,%esp
}
80102cb3:	90                   	nop
80102cb4:	c9                   	leave  
80102cb5:	c3                   	ret    

80102cb6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102cb6:	55                   	push   %ebp
80102cb7:	89 e5                	mov    %esp,%ebp
80102cb9:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102cbc:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cc1:	85 c0                	test   %eax,%eax
80102cc3:	74 10                	je     80102cd5 <kalloc+0x1f>
    acquire(&kmem.lock);
80102cc5:	83 ec 0c             	sub    $0xc,%esp
80102cc8:	68 40 32 11 80       	push   $0x80113240
80102ccd:	e8 50 27 00 00       	call   80105422 <acquire>
80102cd2:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102cd5:	a1 78 32 11 80       	mov    0x80113278,%eax
80102cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ce1:	74 0a                	je     80102ced <kalloc+0x37>
    kmem.freelist = r->next;
80102ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce6:	8b 00                	mov    (%eax),%eax
80102ce8:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102ced:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cf2:	85 c0                	test   %eax,%eax
80102cf4:	74 10                	je     80102d06 <kalloc+0x50>
    release(&kmem.lock);
80102cf6:	83 ec 0c             	sub    $0xc,%esp
80102cf9:	68 40 32 11 80       	push   $0x80113240
80102cfe:	e8 86 27 00 00       	call   80105489 <release>
80102d03:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d09:	c9                   	leave  
80102d0a:	c3                   	ret    

80102d0b <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d0b:	55                   	push   %ebp
80102d0c:	89 e5                	mov    %esp,%ebp
80102d0e:	83 ec 14             	sub    $0x14,%esp
80102d11:	8b 45 08             	mov    0x8(%ebp),%eax
80102d14:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d18:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d1c:	89 c2                	mov    %eax,%edx
80102d1e:	ec                   	in     (%dx),%al
80102d1f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d22:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d26:	c9                   	leave  
80102d27:	c3                   	ret    

80102d28 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d28:	55                   	push   %ebp
80102d29:	89 e5                	mov    %esp,%ebp
80102d2b:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d2e:	6a 64                	push   $0x64
80102d30:	e8 d6 ff ff ff       	call   80102d0b <inb>
80102d35:	83 c4 04             	add    $0x4,%esp
80102d38:	0f b6 c0             	movzbl %al,%eax
80102d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d41:	83 e0 01             	and    $0x1,%eax
80102d44:	85 c0                	test   %eax,%eax
80102d46:	75 0a                	jne    80102d52 <kbdgetc+0x2a>
    return -1;
80102d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d4d:	e9 23 01 00 00       	jmp    80102e75 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d52:	6a 60                	push   $0x60
80102d54:	e8 b2 ff ff ff       	call   80102d0b <inb>
80102d59:	83 c4 04             	add    $0x4,%esp
80102d5c:	0f b6 c0             	movzbl %al,%eax
80102d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d62:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d69:	75 17                	jne    80102d82 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d6b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d70:	83 c8 40             	or     $0x40,%eax
80102d73:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102d78:	b8 00 00 00 00       	mov    $0x0,%eax
80102d7d:	e9 f3 00 00 00       	jmp    80102e75 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d85:	25 80 00 00 00       	and    $0x80,%eax
80102d8a:	85 c0                	test   %eax,%eax
80102d8c:	74 45                	je     80102dd3 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d8e:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d93:	83 e0 40             	and    $0x40,%eax
80102d96:	85 c0                	test   %eax,%eax
80102d98:	75 08                	jne    80102da2 <kbdgetc+0x7a>
80102d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d9d:	83 e0 7f             	and    $0x7f,%eax
80102da0:	eb 03                	jmp    80102da5 <kbdgetc+0x7d>
80102da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dab:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102db0:	0f b6 00             	movzbl (%eax),%eax
80102db3:	83 c8 40             	or     $0x40,%eax
80102db6:	0f b6 c0             	movzbl %al,%eax
80102db9:	f7 d0                	not    %eax
80102dbb:	89 c2                	mov    %eax,%edx
80102dbd:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dc2:	21 d0                	and    %edx,%eax
80102dc4:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102dc9:	b8 00 00 00 00       	mov    $0x0,%eax
80102dce:	e9 a2 00 00 00       	jmp    80102e75 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102dd3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dd8:	83 e0 40             	and    $0x40,%eax
80102ddb:	85 c0                	test   %eax,%eax
80102ddd:	74 14                	je     80102df3 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ddf:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102de6:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102deb:	83 e0 bf             	and    $0xffffffbf,%eax
80102dee:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df6:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102dfb:	0f b6 00             	movzbl (%eax),%eax
80102dfe:	0f b6 d0             	movzbl %al,%edx
80102e01:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e06:	09 d0                	or     %edx,%eax
80102e08:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e10:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e15:	0f b6 00             	movzbl (%eax),%eax
80102e18:	0f b6 d0             	movzbl %al,%edx
80102e1b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e20:	31 d0                	xor    %edx,%eax
80102e22:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e27:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e2c:	83 e0 03             	and    $0x3,%eax
80102e2f:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e39:	01 d0                	add    %edx,%eax
80102e3b:	0f b6 00             	movzbl (%eax),%eax
80102e3e:	0f b6 c0             	movzbl %al,%eax
80102e41:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e44:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e49:	83 e0 08             	and    $0x8,%eax
80102e4c:	85 c0                	test   %eax,%eax
80102e4e:	74 22                	je     80102e72 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e50:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e54:	76 0c                	jbe    80102e62 <kbdgetc+0x13a>
80102e56:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e5a:	77 06                	ja     80102e62 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e5c:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e60:	eb 10                	jmp    80102e72 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e62:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e66:	76 0a                	jbe    80102e72 <kbdgetc+0x14a>
80102e68:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e6c:	77 04                	ja     80102e72 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e6e:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e75:	c9                   	leave  
80102e76:	c3                   	ret    

80102e77 <kbdintr>:

void
kbdintr(void)
{
80102e77:	55                   	push   %ebp
80102e78:	89 e5                	mov    %esp,%ebp
80102e7a:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e7d:	83 ec 0c             	sub    $0xc,%esp
80102e80:	68 28 2d 10 80       	push   $0x80102d28
80102e85:	e8 6f d9 ff ff       	call   801007f9 <consoleintr>
80102e8a:	83 c4 10             	add    $0x10,%esp
}
80102e8d:	90                   	nop
80102e8e:	c9                   	leave  
80102e8f:	c3                   	ret    

80102e90 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 14             	sub    $0x14,%esp
80102e96:	8b 45 08             	mov    0x8(%ebp),%eax
80102e99:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ea1:	89 c2                	mov    %eax,%edx
80102ea3:	ec                   	in     (%dx),%al
80102ea4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ea7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102eab:	c9                   	leave  
80102eac:	c3                   	ret    

80102ead <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ead:	55                   	push   %ebp
80102eae:	89 e5                	mov    %esp,%ebp
80102eb0:	83 ec 08             	sub    $0x8,%esp
80102eb3:	8b 55 08             	mov    0x8(%ebp),%edx
80102eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eb9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102ebd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ec4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ec8:	ee                   	out    %al,(%dx)
}
80102ec9:	90                   	nop
80102eca:	c9                   	leave  
80102ecb:	c3                   	ret    

80102ecc <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102ecc:	55                   	push   %ebp
80102ecd:	89 e5                	mov    %esp,%ebp
80102ecf:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ed2:	9c                   	pushf  
80102ed3:	58                   	pop    %eax
80102ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102eda:	c9                   	leave  
80102edb:	c3                   	ret    

80102edc <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102edc:	55                   	push   %ebp
80102edd:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102edf:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ee4:	8b 55 08             	mov    0x8(%ebp),%edx
80102ee7:	c1 e2 02             	shl    $0x2,%edx
80102eea:	01 c2                	add    %eax,%edx
80102eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eef:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ef1:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ef6:	83 c0 20             	add    $0x20,%eax
80102ef9:	8b 00                	mov    (%eax),%eax
}
80102efb:	90                   	nop
80102efc:	5d                   	pop    %ebp
80102efd:	c3                   	ret    

80102efe <lapicinit>:

void
lapicinit(void)
{
80102efe:	55                   	push   %ebp
80102eff:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f01:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f06:	85 c0                	test   %eax,%eax
80102f08:	0f 84 0b 01 00 00    	je     80103019 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f0e:	68 3f 01 00 00       	push   $0x13f
80102f13:	6a 3c                	push   $0x3c
80102f15:	e8 c2 ff ff ff       	call   80102edc <lapicw>
80102f1a:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f1d:	6a 0b                	push   $0xb
80102f1f:	68 f8 00 00 00       	push   $0xf8
80102f24:	e8 b3 ff ff ff       	call   80102edc <lapicw>
80102f29:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f2c:	68 20 00 02 00       	push   $0x20020
80102f31:	68 c8 00 00 00       	push   $0xc8
80102f36:	e8 a1 ff ff ff       	call   80102edc <lapicw>
80102f3b:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102f3e:	68 80 96 98 00       	push   $0x989680
80102f43:	68 e0 00 00 00       	push   $0xe0
80102f48:	e8 8f ff ff ff       	call   80102edc <lapicw>
80102f4d:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f50:	68 00 00 01 00       	push   $0x10000
80102f55:	68 d4 00 00 00       	push   $0xd4
80102f5a:	e8 7d ff ff ff       	call   80102edc <lapicw>
80102f5f:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f62:	68 00 00 01 00       	push   $0x10000
80102f67:	68 d8 00 00 00       	push   $0xd8
80102f6c:	e8 6b ff ff ff       	call   80102edc <lapicw>
80102f71:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f74:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f79:	83 c0 30             	add    $0x30,%eax
80102f7c:	8b 00                	mov    (%eax),%eax
80102f7e:	c1 e8 10             	shr    $0x10,%eax
80102f81:	0f b6 c0             	movzbl %al,%eax
80102f84:	83 f8 03             	cmp    $0x3,%eax
80102f87:	76 12                	jbe    80102f9b <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f89:	68 00 00 01 00       	push   $0x10000
80102f8e:	68 d0 00 00 00       	push   $0xd0
80102f93:	e8 44 ff ff ff       	call   80102edc <lapicw>
80102f98:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f9b:	6a 33                	push   $0x33
80102f9d:	68 dc 00 00 00       	push   $0xdc
80102fa2:	e8 35 ff ff ff       	call   80102edc <lapicw>
80102fa7:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102faa:	6a 00                	push   $0x0
80102fac:	68 a0 00 00 00       	push   $0xa0
80102fb1:	e8 26 ff ff ff       	call   80102edc <lapicw>
80102fb6:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102fb9:	6a 00                	push   $0x0
80102fbb:	68 a0 00 00 00       	push   $0xa0
80102fc0:	e8 17 ff ff ff       	call   80102edc <lapicw>
80102fc5:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102fc8:	6a 00                	push   $0x0
80102fca:	6a 2c                	push   $0x2c
80102fcc:	e8 0b ff ff ff       	call   80102edc <lapicw>
80102fd1:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fd4:	6a 00                	push   $0x0
80102fd6:	68 c4 00 00 00       	push   $0xc4
80102fdb:	e8 fc fe ff ff       	call   80102edc <lapicw>
80102fe0:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fe3:	68 00 85 08 00       	push   $0x88500
80102fe8:	68 c0 00 00 00       	push   $0xc0
80102fed:	e8 ea fe ff ff       	call   80102edc <lapicw>
80102ff2:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ff5:	90                   	nop
80102ff6:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ffb:	05 00 03 00 00       	add    $0x300,%eax
80103000:	8b 00                	mov    (%eax),%eax
80103002:	25 00 10 00 00       	and    $0x1000,%eax
80103007:	85 c0                	test   %eax,%eax
80103009:	75 eb                	jne    80102ff6 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010300b:	6a 00                	push   $0x0
8010300d:	6a 20                	push   $0x20
8010300f:	e8 c8 fe ff ff       	call   80102edc <lapicw>
80103014:	83 c4 08             	add    $0x8,%esp
80103017:	eb 01                	jmp    8010301a <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103019:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
8010301a:	c9                   	leave  
8010301b:	c3                   	ret    

8010301c <cpunum>:

int
cpunum(void)
{
8010301c:	55                   	push   %ebp
8010301d:	89 e5                	mov    %esp,%ebp
8010301f:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103022:	e8 a5 fe ff ff       	call   80102ecc <readeflags>
80103027:	25 00 02 00 00       	and    $0x200,%eax
8010302c:	85 c0                	test   %eax,%eax
8010302e:	74 26                	je     80103056 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103030:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80103035:	8d 50 01             	lea    0x1(%eax),%edx
80103038:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
8010303e:	85 c0                	test   %eax,%eax
80103040:	75 14                	jne    80103056 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103042:	8b 45 04             	mov    0x4(%ebp),%eax
80103045:	83 ec 08             	sub    $0x8,%esp
80103048:	50                   	push   %eax
80103049:	68 20 8d 10 80       	push   $0x80108d20
8010304e:	e8 73 d3 ff ff       	call   801003c6 <cprintf>
80103053:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103056:	a1 7c 32 11 80       	mov    0x8011327c,%eax
8010305b:	85 c0                	test   %eax,%eax
8010305d:	74 0f                	je     8010306e <cpunum+0x52>
    return lapic[ID]>>24;
8010305f:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103064:	83 c0 20             	add    $0x20,%eax
80103067:	8b 00                	mov    (%eax),%eax
80103069:	c1 e8 18             	shr    $0x18,%eax
8010306c:	eb 05                	jmp    80103073 <cpunum+0x57>
  return 0;
8010306e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103073:	c9                   	leave  
80103074:	c3                   	ret    

80103075 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103075:	55                   	push   %ebp
80103076:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103078:	a1 7c 32 11 80       	mov    0x8011327c,%eax
8010307d:	85 c0                	test   %eax,%eax
8010307f:	74 0c                	je     8010308d <lapiceoi+0x18>
    lapicw(EOI, 0);
80103081:	6a 00                	push   $0x0
80103083:	6a 2c                	push   $0x2c
80103085:	e8 52 fe ff ff       	call   80102edc <lapicw>
8010308a:	83 c4 08             	add    $0x8,%esp
}
8010308d:	90                   	nop
8010308e:	c9                   	leave  
8010308f:	c3                   	ret    

80103090 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
}
80103093:	90                   	nop
80103094:	5d                   	pop    %ebp
80103095:	c3                   	ret    

80103096 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103096:	55                   	push   %ebp
80103097:	89 e5                	mov    %esp,%ebp
80103099:	83 ec 14             	sub    $0x14,%esp
8010309c:	8b 45 08             	mov    0x8(%ebp),%eax
8010309f:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030a2:	6a 0f                	push   $0xf
801030a4:	6a 70                	push   $0x70
801030a6:	e8 02 fe ff ff       	call   80102ead <outb>
801030ab:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801030ae:	6a 0a                	push   $0xa
801030b0:	6a 71                	push   $0x71
801030b2:	e8 f6 fd ff ff       	call   80102ead <outb>
801030b7:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801030ba:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801030c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030c4:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030cc:	83 c0 02             	add    $0x2,%eax
801030cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801030d2:	c1 ea 04             	shr    $0x4,%edx
801030d5:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030d8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030dc:	c1 e0 18             	shl    $0x18,%eax
801030df:	50                   	push   %eax
801030e0:	68 c4 00 00 00       	push   $0xc4
801030e5:	e8 f2 fd ff ff       	call   80102edc <lapicw>
801030ea:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801030ed:	68 00 c5 00 00       	push   $0xc500
801030f2:	68 c0 00 00 00       	push   $0xc0
801030f7:	e8 e0 fd ff ff       	call   80102edc <lapicw>
801030fc:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030ff:	68 c8 00 00 00       	push   $0xc8
80103104:	e8 87 ff ff ff       	call   80103090 <microdelay>
80103109:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010310c:	68 00 85 00 00       	push   $0x8500
80103111:	68 c0 00 00 00       	push   $0xc0
80103116:	e8 c1 fd ff ff       	call   80102edc <lapicw>
8010311b:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010311e:	6a 64                	push   $0x64
80103120:	e8 6b ff ff ff       	call   80103090 <microdelay>
80103125:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103128:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010312f:	eb 3d                	jmp    8010316e <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103131:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103135:	c1 e0 18             	shl    $0x18,%eax
80103138:	50                   	push   %eax
80103139:	68 c4 00 00 00       	push   $0xc4
8010313e:	e8 99 fd ff ff       	call   80102edc <lapicw>
80103143:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103146:	8b 45 0c             	mov    0xc(%ebp),%eax
80103149:	c1 e8 0c             	shr    $0xc,%eax
8010314c:	80 cc 06             	or     $0x6,%ah
8010314f:	50                   	push   %eax
80103150:	68 c0 00 00 00       	push   $0xc0
80103155:	e8 82 fd ff ff       	call   80102edc <lapicw>
8010315a:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010315d:	68 c8 00 00 00       	push   $0xc8
80103162:	e8 29 ff ff ff       	call   80103090 <microdelay>
80103167:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010316a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010316e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103172:	7e bd                	jle    80103131 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103174:	90                   	nop
80103175:	c9                   	leave  
80103176:	c3                   	ret    

80103177 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103177:	55                   	push   %ebp
80103178:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010317a:	8b 45 08             	mov    0x8(%ebp),%eax
8010317d:	0f b6 c0             	movzbl %al,%eax
80103180:	50                   	push   %eax
80103181:	6a 70                	push   $0x70
80103183:	e8 25 fd ff ff       	call   80102ead <outb>
80103188:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010318b:	68 c8 00 00 00       	push   $0xc8
80103190:	e8 fb fe ff ff       	call   80103090 <microdelay>
80103195:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103198:	6a 71                	push   $0x71
8010319a:	e8 f1 fc ff ff       	call   80102e90 <inb>
8010319f:	83 c4 04             	add    $0x4,%esp
801031a2:	0f b6 c0             	movzbl %al,%eax
}
801031a5:	c9                   	leave  
801031a6:	c3                   	ret    

801031a7 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031a7:	55                   	push   %ebp
801031a8:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801031aa:	6a 00                	push   $0x0
801031ac:	e8 c6 ff ff ff       	call   80103177 <cmos_read>
801031b1:	83 c4 04             	add    $0x4,%esp
801031b4:	89 c2                	mov    %eax,%edx
801031b6:	8b 45 08             	mov    0x8(%ebp),%eax
801031b9:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801031bb:	6a 02                	push   $0x2
801031bd:	e8 b5 ff ff ff       	call   80103177 <cmos_read>
801031c2:	83 c4 04             	add    $0x4,%esp
801031c5:	89 c2                	mov    %eax,%edx
801031c7:	8b 45 08             	mov    0x8(%ebp),%eax
801031ca:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801031cd:	6a 04                	push   $0x4
801031cf:	e8 a3 ff ff ff       	call   80103177 <cmos_read>
801031d4:	83 c4 04             	add    $0x4,%esp
801031d7:	89 c2                	mov    %eax,%edx
801031d9:	8b 45 08             	mov    0x8(%ebp),%eax
801031dc:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801031df:	6a 07                	push   $0x7
801031e1:	e8 91 ff ff ff       	call   80103177 <cmos_read>
801031e6:	83 c4 04             	add    $0x4,%esp
801031e9:	89 c2                	mov    %eax,%edx
801031eb:	8b 45 08             	mov    0x8(%ebp),%eax
801031ee:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801031f1:	6a 08                	push   $0x8
801031f3:	e8 7f ff ff ff       	call   80103177 <cmos_read>
801031f8:	83 c4 04             	add    $0x4,%esp
801031fb:	89 c2                	mov    %eax,%edx
801031fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103200:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103203:	6a 09                	push   $0x9
80103205:	e8 6d ff ff ff       	call   80103177 <cmos_read>
8010320a:	83 c4 04             	add    $0x4,%esp
8010320d:	89 c2                	mov    %eax,%edx
8010320f:	8b 45 08             	mov    0x8(%ebp),%eax
80103212:	89 50 14             	mov    %edx,0x14(%eax)
}
80103215:	90                   	nop
80103216:	c9                   	leave  
80103217:	c3                   	ret    

80103218 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103218:	55                   	push   %ebp
80103219:	89 e5                	mov    %esp,%ebp
8010321b:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010321e:	6a 0b                	push   $0xb
80103220:	e8 52 ff ff ff       	call   80103177 <cmos_read>
80103225:	83 c4 04             	add    $0x4,%esp
80103228:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010322e:	83 e0 04             	and    $0x4,%eax
80103231:	85 c0                	test   %eax,%eax
80103233:	0f 94 c0             	sete   %al
80103236:	0f b6 c0             	movzbl %al,%eax
80103239:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010323c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010323f:	50                   	push   %eax
80103240:	e8 62 ff ff ff       	call   801031a7 <fill_rtcdate>
80103245:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103248:	6a 0a                	push   $0xa
8010324a:	e8 28 ff ff ff       	call   80103177 <cmos_read>
8010324f:	83 c4 04             	add    $0x4,%esp
80103252:	25 80 00 00 00       	and    $0x80,%eax
80103257:	85 c0                	test   %eax,%eax
80103259:	75 27                	jne    80103282 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010325b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010325e:	50                   	push   %eax
8010325f:	e8 43 ff ff ff       	call   801031a7 <fill_rtcdate>
80103264:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103267:	83 ec 04             	sub    $0x4,%esp
8010326a:	6a 18                	push   $0x18
8010326c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010326f:	50                   	push   %eax
80103270:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103273:	50                   	push   %eax
80103274:	e8 73 24 00 00       	call   801056ec <memcmp>
80103279:	83 c4 10             	add    $0x10,%esp
8010327c:	85 c0                	test   %eax,%eax
8010327e:	74 05                	je     80103285 <cmostime+0x6d>
80103280:	eb ba                	jmp    8010323c <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103282:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103283:	eb b7                	jmp    8010323c <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103285:	90                   	nop
  }

  // convert
  if (bcd) {
80103286:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010328a:	0f 84 b4 00 00 00    	je     80103344 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103290:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103293:	c1 e8 04             	shr    $0x4,%eax
80103296:	89 c2                	mov    %eax,%edx
80103298:	89 d0                	mov    %edx,%eax
8010329a:	c1 e0 02             	shl    $0x2,%eax
8010329d:	01 d0                	add    %edx,%eax
8010329f:	01 c0                	add    %eax,%eax
801032a1:	89 c2                	mov    %eax,%edx
801032a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032a6:	83 e0 0f             	and    $0xf,%eax
801032a9:	01 d0                	add    %edx,%eax
801032ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801032ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032b1:	c1 e8 04             	shr    $0x4,%eax
801032b4:	89 c2                	mov    %eax,%edx
801032b6:	89 d0                	mov    %edx,%eax
801032b8:	c1 e0 02             	shl    $0x2,%eax
801032bb:	01 d0                	add    %edx,%eax
801032bd:	01 c0                	add    %eax,%eax
801032bf:	89 c2                	mov    %eax,%edx
801032c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032c4:	83 e0 0f             	and    $0xf,%eax
801032c7:	01 d0                	add    %edx,%eax
801032c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801032cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032cf:	c1 e8 04             	shr    $0x4,%eax
801032d2:	89 c2                	mov    %eax,%edx
801032d4:	89 d0                	mov    %edx,%eax
801032d6:	c1 e0 02             	shl    $0x2,%eax
801032d9:	01 d0                	add    %edx,%eax
801032db:	01 c0                	add    %eax,%eax
801032dd:	89 c2                	mov    %eax,%edx
801032df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032e2:	83 e0 0f             	and    $0xf,%eax
801032e5:	01 d0                	add    %edx,%eax
801032e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801032ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032ed:	c1 e8 04             	shr    $0x4,%eax
801032f0:	89 c2                	mov    %eax,%edx
801032f2:	89 d0                	mov    %edx,%eax
801032f4:	c1 e0 02             	shl    $0x2,%eax
801032f7:	01 d0                	add    %edx,%eax
801032f9:	01 c0                	add    %eax,%eax
801032fb:	89 c2                	mov    %eax,%edx
801032fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103300:	83 e0 0f             	and    $0xf,%eax
80103303:	01 d0                	add    %edx,%eax
80103305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103308:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010330b:	c1 e8 04             	shr    $0x4,%eax
8010330e:	89 c2                	mov    %eax,%edx
80103310:	89 d0                	mov    %edx,%eax
80103312:	c1 e0 02             	shl    $0x2,%eax
80103315:	01 d0                	add    %edx,%eax
80103317:	01 c0                	add    %eax,%eax
80103319:	89 c2                	mov    %eax,%edx
8010331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010331e:	83 e0 0f             	and    $0xf,%eax
80103321:	01 d0                	add    %edx,%eax
80103323:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103326:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103329:	c1 e8 04             	shr    $0x4,%eax
8010332c:	89 c2                	mov    %eax,%edx
8010332e:	89 d0                	mov    %edx,%eax
80103330:	c1 e0 02             	shl    $0x2,%eax
80103333:	01 d0                	add    %edx,%eax
80103335:	01 c0                	add    %eax,%eax
80103337:	89 c2                	mov    %eax,%edx
80103339:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010333c:	83 e0 0f             	and    $0xf,%eax
8010333f:	01 d0                	add    %edx,%eax
80103341:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103344:	8b 45 08             	mov    0x8(%ebp),%eax
80103347:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010334a:	89 10                	mov    %edx,(%eax)
8010334c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010334f:	89 50 04             	mov    %edx,0x4(%eax)
80103352:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103355:	89 50 08             	mov    %edx,0x8(%eax)
80103358:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010335b:	89 50 0c             	mov    %edx,0xc(%eax)
8010335e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103361:	89 50 10             	mov    %edx,0x10(%eax)
80103364:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103367:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010336a:	8b 45 08             	mov    0x8(%ebp),%eax
8010336d:	8b 40 14             	mov    0x14(%eax),%eax
80103370:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103376:	8b 45 08             	mov    0x8(%ebp),%eax
80103379:	89 50 14             	mov    %edx,0x14(%eax)
}
8010337c:	90                   	nop
8010337d:	c9                   	leave  
8010337e:	c3                   	ret    

8010337f <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010337f:	55                   	push   %ebp
80103380:	89 e5                	mov    %esp,%ebp
80103382:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103385:	83 ec 08             	sub    $0x8,%esp
80103388:	68 4c 8d 10 80       	push   $0x80108d4c
8010338d:	68 80 32 11 80       	push   $0x80113280
80103392:	e8 69 20 00 00       	call   80105400 <initlock>
80103397:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010339a:	83 ec 08             	sub    $0x8,%esp
8010339d:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033a0:	50                   	push   %eax
801033a1:	ff 75 08             	pushl  0x8(%ebp)
801033a4:	e8 db df ff ff       	call   80101384 <readsb>
801033a9:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801033ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033af:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
801033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033b7:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
801033bc:	8b 45 08             	mov    0x8(%ebp),%eax
801033bf:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
801033c4:	e8 b2 01 00 00       	call   8010357b <recover_from_log>
}
801033c9:	90                   	nop
801033ca:	c9                   	leave  
801033cb:	c3                   	ret    

801033cc <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801033cc:	55                   	push   %ebp
801033cd:	89 e5                	mov    %esp,%ebp
801033cf:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d9:	e9 95 00 00 00       	jmp    80103473 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033de:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033e7:	01 d0                	add    %edx,%eax
801033e9:	83 c0 01             	add    $0x1,%eax
801033ec:	89 c2                	mov    %eax,%edx
801033ee:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033f3:	83 ec 08             	sub    $0x8,%esp
801033f6:	52                   	push   %edx
801033f7:	50                   	push   %eax
801033f8:	e8 b9 cd ff ff       	call   801001b6 <bread>
801033fd:	83 c4 10             	add    $0x10,%esp
80103400:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103406:	83 c0 10             	add    $0x10,%eax
80103409:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103410:	89 c2                	mov    %eax,%edx
80103412:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103417:	83 ec 08             	sub    $0x8,%esp
8010341a:	52                   	push   %edx
8010341b:	50                   	push   %eax
8010341c:	e8 95 cd ff ff       	call   801001b6 <bread>
80103421:	83 c4 10             	add    $0x10,%esp
80103424:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010342a:	8d 50 18             	lea    0x18(%eax),%edx
8010342d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103430:	83 c0 18             	add    $0x18,%eax
80103433:	83 ec 04             	sub    $0x4,%esp
80103436:	68 00 02 00 00       	push   $0x200
8010343b:	52                   	push   %edx
8010343c:	50                   	push   %eax
8010343d:	e8 02 23 00 00       	call   80105744 <memmove>
80103442:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103445:	83 ec 0c             	sub    $0xc,%esp
80103448:	ff 75 ec             	pushl  -0x14(%ebp)
8010344b:	e8 9f cd ff ff       	call   801001ef <bwrite>
80103450:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103453:	83 ec 0c             	sub    $0xc,%esp
80103456:	ff 75 f0             	pushl  -0x10(%ebp)
80103459:	e8 d0 cd ff ff       	call   8010022e <brelse>
8010345e:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103461:	83 ec 0c             	sub    $0xc,%esp
80103464:	ff 75 ec             	pushl  -0x14(%ebp)
80103467:	e8 c2 cd ff ff       	call   8010022e <brelse>
8010346c:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010346f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103473:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103478:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010347b:	0f 8f 5d ff ff ff    	jg     801033de <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103481:	90                   	nop
80103482:	c9                   	leave  
80103483:	c3                   	ret    

80103484 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103484:	55                   	push   %ebp
80103485:	89 e5                	mov    %esp,%ebp
80103487:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010348a:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010348f:	89 c2                	mov    %eax,%edx
80103491:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103496:	83 ec 08             	sub    $0x8,%esp
80103499:	52                   	push   %edx
8010349a:	50                   	push   %eax
8010349b:	e8 16 cd ff ff       	call   801001b6 <bread>
801034a0:	83 c4 10             	add    $0x10,%esp
801034a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a9:	83 c0 18             	add    $0x18,%eax
801034ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801034af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b2:	8b 00                	mov    (%eax),%eax
801034b4:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
801034b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034c0:	eb 1b                	jmp    801034dd <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801034c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034c8:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801034cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034cf:	83 c2 10             	add    $0x10,%edx
801034d2:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801034d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034dd:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801034e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034e5:	7f db                	jg     801034c2 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801034e7:	83 ec 0c             	sub    $0xc,%esp
801034ea:	ff 75 f0             	pushl  -0x10(%ebp)
801034ed:	e8 3c cd ff ff       	call   8010022e <brelse>
801034f2:	83 c4 10             	add    $0x10,%esp
}
801034f5:	90                   	nop
801034f6:	c9                   	leave  
801034f7:	c3                   	ret    

801034f8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034f8:	55                   	push   %ebp
801034f9:	89 e5                	mov    %esp,%ebp
801034fb:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034fe:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103503:	89 c2                	mov    %eax,%edx
80103505:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010350a:	83 ec 08             	sub    $0x8,%esp
8010350d:	52                   	push   %edx
8010350e:	50                   	push   %eax
8010350f:	e8 a2 cc ff ff       	call   801001b6 <bread>
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010351a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010351d:	83 c0 18             	add    $0x18,%eax
80103520:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103523:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
80103529:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010352c:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010352e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103535:	eb 1b                	jmp    80103552 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010353a:	83 c0 10             	add    $0x10,%eax
8010353d:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
80103544:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103547:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010354a:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010354e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103552:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103557:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010355a:	7f db                	jg     80103537 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010355c:	83 ec 0c             	sub    $0xc,%esp
8010355f:	ff 75 f0             	pushl  -0x10(%ebp)
80103562:	e8 88 cc ff ff       	call   801001ef <bwrite>
80103567:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010356a:	83 ec 0c             	sub    $0xc,%esp
8010356d:	ff 75 f0             	pushl  -0x10(%ebp)
80103570:	e8 b9 cc ff ff       	call   8010022e <brelse>
80103575:	83 c4 10             	add    $0x10,%esp
}
80103578:	90                   	nop
80103579:	c9                   	leave  
8010357a:	c3                   	ret    

8010357b <recover_from_log>:

static void
recover_from_log(void)
{
8010357b:	55                   	push   %ebp
8010357c:	89 e5                	mov    %esp,%ebp
8010357e:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103581:	e8 fe fe ff ff       	call   80103484 <read_head>
  install_trans(); // if committed, copy from log to disk
80103586:	e8 41 fe ff ff       	call   801033cc <install_trans>
  log.lh.n = 0;
8010358b:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103592:	00 00 00 
  write_head(); // clear the log
80103595:	e8 5e ff ff ff       	call   801034f8 <write_head>
}
8010359a:	90                   	nop
8010359b:	c9                   	leave  
8010359c:	c3                   	ret    

8010359d <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010359d:	55                   	push   %ebp
8010359e:	89 e5                	mov    %esp,%ebp
801035a0:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035a3:	83 ec 0c             	sub    $0xc,%esp
801035a6:	68 80 32 11 80       	push   $0x80113280
801035ab:	e8 72 1e 00 00       	call   80105422 <acquire>
801035b0:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801035b3:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801035b8:	85 c0                	test   %eax,%eax
801035ba:	74 17                	je     801035d3 <begin_op+0x36>
      sleep(&log, &log.lock);
801035bc:	83 ec 08             	sub    $0x8,%esp
801035bf:	68 80 32 11 80       	push   $0x80113280
801035c4:	68 80 32 11 80       	push   $0x80113280
801035c9:	e8 bd 18 00 00       	call   80104e8b <sleep>
801035ce:	83 c4 10             	add    $0x10,%esp
801035d1:	eb e0                	jmp    801035b3 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035d3:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
801035d9:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801035de:	8d 50 01             	lea    0x1(%eax),%edx
801035e1:	89 d0                	mov    %edx,%eax
801035e3:	c1 e0 02             	shl    $0x2,%eax
801035e6:	01 d0                	add    %edx,%eax
801035e8:	01 c0                	add    %eax,%eax
801035ea:	01 c8                	add    %ecx,%eax
801035ec:	83 f8 1e             	cmp    $0x1e,%eax
801035ef:	7e 17                	jle    80103608 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035f1:	83 ec 08             	sub    $0x8,%esp
801035f4:	68 80 32 11 80       	push   $0x80113280
801035f9:	68 80 32 11 80       	push   $0x80113280
801035fe:	e8 88 18 00 00       	call   80104e8b <sleep>
80103603:	83 c4 10             	add    $0x10,%esp
80103606:	eb ab                	jmp    801035b3 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103608:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010360d:	83 c0 01             	add    $0x1,%eax
80103610:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
80103615:	83 ec 0c             	sub    $0xc,%esp
80103618:	68 80 32 11 80       	push   $0x80113280
8010361d:	e8 67 1e 00 00       	call   80105489 <release>
80103622:	83 c4 10             	add    $0x10,%esp
      break;
80103625:	90                   	nop
    }
  }
}
80103626:	90                   	nop
80103627:	c9                   	leave  
80103628:	c3                   	ret    

80103629 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103629:	55                   	push   %ebp
8010362a:	89 e5                	mov    %esp,%ebp
8010362c:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010362f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103636:	83 ec 0c             	sub    $0xc,%esp
80103639:	68 80 32 11 80       	push   $0x80113280
8010363e:	e8 df 1d 00 00       	call   80105422 <acquire>
80103643:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103646:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010364b:	83 e8 01             	sub    $0x1,%eax
8010364e:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
80103653:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103658:	85 c0                	test   %eax,%eax
8010365a:	74 0d                	je     80103669 <end_op+0x40>
    panic("log.committing");
8010365c:	83 ec 0c             	sub    $0xc,%esp
8010365f:	68 50 8d 10 80       	push   $0x80108d50
80103664:	e8 fd ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103669:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010366e:	85 c0                	test   %eax,%eax
80103670:	75 13                	jne    80103685 <end_op+0x5c>
    do_commit = 1;
80103672:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103679:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
80103680:	00 00 00 
80103683:	eb 10                	jmp    80103695 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103685:	83 ec 0c             	sub    $0xc,%esp
80103688:	68 80 32 11 80       	push   $0x80113280
8010368d:	e8 e7 18 00 00       	call   80104f79 <wakeup>
80103692:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103695:	83 ec 0c             	sub    $0xc,%esp
80103698:	68 80 32 11 80       	push   $0x80113280
8010369d:	e8 e7 1d 00 00       	call   80105489 <release>
801036a2:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036a9:	74 3f                	je     801036ea <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801036ab:	e8 f5 00 00 00       	call   801037a5 <commit>
    acquire(&log.lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	68 80 32 11 80       	push   $0x80113280
801036b8:	e8 65 1d 00 00       	call   80105422 <acquire>
801036bd:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801036c0:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
801036c7:	00 00 00 
    wakeup(&log);
801036ca:	83 ec 0c             	sub    $0xc,%esp
801036cd:	68 80 32 11 80       	push   $0x80113280
801036d2:	e8 a2 18 00 00       	call   80104f79 <wakeup>
801036d7:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801036da:	83 ec 0c             	sub    $0xc,%esp
801036dd:	68 80 32 11 80       	push   $0x80113280
801036e2:	e8 a2 1d 00 00       	call   80105489 <release>
801036e7:	83 c4 10             	add    $0x10,%esp
  }
}
801036ea:	90                   	nop
801036eb:	c9                   	leave  
801036ec:	c3                   	ret    

801036ed <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801036ed:	55                   	push   %ebp
801036ee:	89 e5                	mov    %esp,%ebp
801036f0:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036fa:	e9 95 00 00 00       	jmp    80103794 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036ff:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103708:	01 d0                	add    %edx,%eax
8010370a:	83 c0 01             	add    $0x1,%eax
8010370d:	89 c2                	mov    %eax,%edx
8010370f:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103714:	83 ec 08             	sub    $0x8,%esp
80103717:	52                   	push   %edx
80103718:	50                   	push   %eax
80103719:	e8 98 ca ff ff       	call   801001b6 <bread>
8010371e:	83 c4 10             	add    $0x10,%esp
80103721:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103727:	83 c0 10             	add    $0x10,%eax
8010372a:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103731:	89 c2                	mov    %eax,%edx
80103733:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103738:	83 ec 08             	sub    $0x8,%esp
8010373b:	52                   	push   %edx
8010373c:	50                   	push   %eax
8010373d:	e8 74 ca ff ff       	call   801001b6 <bread>
80103742:	83 c4 10             	add    $0x10,%esp
80103745:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103748:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010374b:	8d 50 18             	lea    0x18(%eax),%edx
8010374e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103751:	83 c0 18             	add    $0x18,%eax
80103754:	83 ec 04             	sub    $0x4,%esp
80103757:	68 00 02 00 00       	push   $0x200
8010375c:	52                   	push   %edx
8010375d:	50                   	push   %eax
8010375e:	e8 e1 1f 00 00       	call   80105744 <memmove>
80103763:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103766:	83 ec 0c             	sub    $0xc,%esp
80103769:	ff 75 f0             	pushl  -0x10(%ebp)
8010376c:	e8 7e ca ff ff       	call   801001ef <bwrite>
80103771:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103774:	83 ec 0c             	sub    $0xc,%esp
80103777:	ff 75 ec             	pushl  -0x14(%ebp)
8010377a:	e8 af ca ff ff       	call   8010022e <brelse>
8010377f:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103782:	83 ec 0c             	sub    $0xc,%esp
80103785:	ff 75 f0             	pushl  -0x10(%ebp)
80103788:	e8 a1 ca ff ff       	call   8010022e <brelse>
8010378d:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103790:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103794:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103799:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010379c:	0f 8f 5d ff ff ff    	jg     801036ff <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037a2:	90                   	nop
801037a3:	c9                   	leave  
801037a4:	c3                   	ret    

801037a5 <commit>:

static void
commit()
{
801037a5:	55                   	push   %ebp
801037a6:	89 e5                	mov    %esp,%ebp
801037a8:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801037ab:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037b0:	85 c0                	test   %eax,%eax
801037b2:	7e 1e                	jle    801037d2 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801037b4:	e8 34 ff ff ff       	call   801036ed <write_log>
    write_head();    // Write header to disk -- the real commit
801037b9:	e8 3a fd ff ff       	call   801034f8 <write_head>
    install_trans(); // Now install writes to home locations
801037be:	e8 09 fc ff ff       	call   801033cc <install_trans>
    log.lh.n = 0; 
801037c3:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801037ca:	00 00 00 
    write_head();    // Erase the transaction from the log
801037cd:	e8 26 fd ff ff       	call   801034f8 <write_head>
  }
}
801037d2:	90                   	nop
801037d3:	c9                   	leave  
801037d4:	c3                   	ret    

801037d5 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037d5:	55                   	push   %ebp
801037d6:	89 e5                	mov    %esp,%ebp
801037d8:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037db:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037e0:	83 f8 1d             	cmp    $0x1d,%eax
801037e3:	7f 12                	jg     801037f7 <log_write+0x22>
801037e5:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037ea:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
801037f0:	83 ea 01             	sub    $0x1,%edx
801037f3:	39 d0                	cmp    %edx,%eax
801037f5:	7c 0d                	jl     80103804 <log_write+0x2f>
    panic("too big a transaction");
801037f7:	83 ec 0c             	sub    $0xc,%esp
801037fa:	68 5f 8d 10 80       	push   $0x80108d5f
801037ff:	e8 62 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103804:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103809:	85 c0                	test   %eax,%eax
8010380b:	7f 0d                	jg     8010381a <log_write+0x45>
    panic("log_write outside of trans");
8010380d:	83 ec 0c             	sub    $0xc,%esp
80103810:	68 75 8d 10 80       	push   $0x80108d75
80103815:	e8 4c cd ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	68 80 32 11 80       	push   $0x80113280
80103822:	e8 fb 1b 00 00       	call   80105422 <acquire>
80103827:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010382a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103831:	eb 1d                	jmp    80103850 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103836:	83 c0 10             	add    $0x10,%eax
80103839:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103840:	89 c2                	mov    %eax,%edx
80103842:	8b 45 08             	mov    0x8(%ebp),%eax
80103845:	8b 40 08             	mov    0x8(%eax),%eax
80103848:	39 c2                	cmp    %eax,%edx
8010384a:	74 10                	je     8010385c <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010384c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103850:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103855:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103858:	7f d9                	jg     80103833 <log_write+0x5e>
8010385a:	eb 01                	jmp    8010385d <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
8010385c:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010385d:	8b 45 08             	mov    0x8(%ebp),%eax
80103860:	8b 40 08             	mov    0x8(%eax),%eax
80103863:	89 c2                	mov    %eax,%edx
80103865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103868:	83 c0 10             	add    $0x10,%eax
8010386b:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
80103872:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103877:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010387a:	75 0d                	jne    80103889 <log_write+0xb4>
    log.lh.n++;
8010387c:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103881:	83 c0 01             	add    $0x1,%eax
80103884:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
80103889:	8b 45 08             	mov    0x8(%ebp),%eax
8010388c:	8b 00                	mov    (%eax),%eax
8010388e:	83 c8 04             	or     $0x4,%eax
80103891:	89 c2                	mov    %eax,%edx
80103893:	8b 45 08             	mov    0x8(%ebp),%eax
80103896:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103898:	83 ec 0c             	sub    $0xc,%esp
8010389b:	68 80 32 11 80       	push   $0x80113280
801038a0:	e8 e4 1b 00 00       	call   80105489 <release>
801038a5:	83 c4 10             	add    $0x10,%esp
}
801038a8:	90                   	nop
801038a9:	c9                   	leave  
801038aa:	c3                   	ret    

801038ab <v2p>:
801038ab:	55                   	push   %ebp
801038ac:	89 e5                	mov    %esp,%ebp
801038ae:	8b 45 08             	mov    0x8(%ebp),%eax
801038b1:	05 00 00 00 80       	add    $0x80000000,%eax
801038b6:	5d                   	pop    %ebp
801038b7:	c3                   	ret    

801038b8 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801038b8:	55                   	push   %ebp
801038b9:	89 e5                	mov    %esp,%ebp
801038bb:	8b 45 08             	mov    0x8(%ebp),%eax
801038be:	05 00 00 00 80       	add    $0x80000000,%eax
801038c3:	5d                   	pop    %ebp
801038c4:	c3                   	ret    

801038c5 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801038c5:	55                   	push   %ebp
801038c6:	89 e5                	mov    %esp,%ebp
801038c8:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038cb:	8b 55 08             	mov    0x8(%ebp),%edx
801038ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801038d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801038d4:	f0 87 02             	lock xchg %eax,(%edx)
801038d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801038da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801038dd:	c9                   	leave  
801038de:	c3                   	ret    

801038df <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801038df:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038e3:	83 e4 f0             	and    $0xfffffff0,%esp
801038e6:	ff 71 fc             	pushl  -0x4(%ecx)
801038e9:	55                   	push   %ebp
801038ea:	89 e5                	mov    %esp,%ebp
801038ec:	51                   	push   %ecx
801038ed:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038f0:	83 ec 08             	sub    $0x8,%esp
801038f3:	68 00 00 40 80       	push   $0x80400000
801038f8:	68 5c 66 11 80       	push   $0x8011665c
801038fd:	e8 7d f2 ff ff       	call   80102b7f <kinit1>
80103902:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103905:	e8 55 4a 00 00       	call   8010835f <kvmalloc>
  mpinit();        // collect info about this machine
8010390a:	e8 43 04 00 00       	call   80103d52 <mpinit>
  lapicinit();
8010390f:	e8 ea f5 ff ff       	call   80102efe <lapicinit>
  seginit();       // set up segments
80103914:	e8 ef 43 00 00       	call   80107d08 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103919:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010391f:	0f b6 00             	movzbl (%eax),%eax
80103922:	0f b6 c0             	movzbl %al,%eax
80103925:	83 ec 08             	sub    $0x8,%esp
80103928:	50                   	push   %eax
80103929:	68 90 8d 10 80       	push   $0x80108d90
8010392e:	e8 93 ca ff ff       	call   801003c6 <cprintf>
80103933:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103936:	e8 6d 06 00 00       	call   80103fa8 <picinit>
  ioapicinit();    // another interrupt controller
8010393b:	e8 34 f1 ff ff       	call   80102a74 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103940:	e8 d4 d1 ff ff       	call   80100b19 <consoleinit>
  uartinit();      // serial port
80103945:	e8 1a 37 00 00       	call   80107064 <uartinit>
  pinit();         // process table
8010394a:	e8 56 0b 00 00       	call   801044a5 <pinit>
  tvinit();        // trap vectors
8010394f:	e8 da 32 00 00       	call   80106c2e <tvinit>
  binit();         // buffer cache
80103954:	e8 db c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103959:	e8 17 d6 ff ff       	call   80100f75 <fileinit>
  ideinit();       // disk
8010395e:	e8 19 ed ff ff       	call   8010267c <ideinit>
  if(!ismp)
80103963:	a1 64 33 11 80       	mov    0x80113364,%eax
80103968:	85 c0                	test   %eax,%eax
8010396a:	75 05                	jne    80103971 <main+0x92>
    timerinit();   // uniprocessor timer
8010396c:	e8 1a 32 00 00       	call   80106b8b <timerinit>
  startothers();   // start other processors
80103971:	e8 7f 00 00 00       	call   801039f5 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103976:	83 ec 08             	sub    $0x8,%esp
80103979:	68 00 00 00 8e       	push   $0x8e000000
8010397e:	68 00 00 40 80       	push   $0x80400000
80103983:	e8 30 f2 ff ff       	call   80102bb8 <kinit2>
80103988:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010398b:	e8 87 0c 00 00       	call   80104617 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103990:	e8 1a 00 00 00       	call   801039af <mpmain>

80103995 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103995:	55                   	push   %ebp
80103996:	89 e5                	mov    %esp,%ebp
80103998:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010399b:	e8 d7 49 00 00       	call   80108377 <switchkvm>
  seginit();
801039a0:	e8 63 43 00 00       	call   80107d08 <seginit>
  lapicinit();
801039a5:	e8 54 f5 ff ff       	call   80102efe <lapicinit>
  mpmain();
801039aa:	e8 00 00 00 00       	call   801039af <mpmain>

801039af <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039af:	55                   	push   %ebp
801039b0:	89 e5                	mov    %esp,%ebp
801039b2:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801039b5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039bb:	0f b6 00             	movzbl (%eax),%eax
801039be:	0f b6 c0             	movzbl %al,%eax
801039c1:	83 ec 08             	sub    $0x8,%esp
801039c4:	50                   	push   %eax
801039c5:	68 a7 8d 10 80       	push   $0x80108da7
801039ca:	e8 f7 c9 ff ff       	call   801003c6 <cprintf>
801039cf:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801039d2:	e8 cd 33 00 00       	call   80106da4 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039d7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039dd:	05 a8 00 00 00       	add    $0xa8,%eax
801039e2:	83 ec 08             	sub    $0x8,%esp
801039e5:	6a 01                	push   $0x1
801039e7:	50                   	push   %eax
801039e8:	e8 d8 fe ff ff       	call   801038c5 <xchg>
801039ed:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039f0:	e8 17 12 00 00       	call   80104c0c <scheduler>

801039f5 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039f5:	55                   	push   %ebp
801039f6:	89 e5                	mov    %esp,%ebp
801039f8:	53                   	push   %ebx
801039f9:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801039fc:	68 00 70 00 00       	push   $0x7000
80103a01:	e8 b2 fe ff ff       	call   801038b8 <p2v>
80103a06:	83 c4 04             	add    $0x4,%esp
80103a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a0c:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a11:	83 ec 04             	sub    $0x4,%esp
80103a14:	50                   	push   %eax
80103a15:	68 2c c5 10 80       	push   $0x8010c52c
80103a1a:	ff 75 f0             	pushl  -0x10(%ebp)
80103a1d:	e8 22 1d 00 00       	call   80105744 <memmove>
80103a22:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a25:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103a2c:	e9 90 00 00 00       	jmp    80103ac1 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a31:	e8 e6 f5 ff ff       	call   8010301c <cpunum>
80103a36:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a3c:	05 80 33 11 80       	add    $0x80113380,%eax
80103a41:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a44:	74 73                	je     80103ab9 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a46:	e8 6b f2 ff ff       	call   80102cb6 <kalloc>
80103a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a51:	83 e8 04             	sub    $0x4,%eax
80103a54:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a57:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a5d:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a62:	83 e8 08             	sub    $0x8,%eax
80103a65:	c7 00 95 39 10 80    	movl   $0x80103995,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a6e:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103a71:	83 ec 0c             	sub    $0xc,%esp
80103a74:	68 00 b0 10 80       	push   $0x8010b000
80103a79:	e8 2d fe ff ff       	call   801038ab <v2p>
80103a7e:	83 c4 10             	add    $0x10,%esp
80103a81:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103a83:	83 ec 0c             	sub    $0xc,%esp
80103a86:	ff 75 f0             	pushl  -0x10(%ebp)
80103a89:	e8 1d fe ff ff       	call   801038ab <v2p>
80103a8e:	83 c4 10             	add    $0x10,%esp
80103a91:	89 c2                	mov    %eax,%edx
80103a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a96:	0f b6 00             	movzbl (%eax),%eax
80103a99:	0f b6 c0             	movzbl %al,%eax
80103a9c:	83 ec 08             	sub    $0x8,%esp
80103a9f:	52                   	push   %edx
80103aa0:	50                   	push   %eax
80103aa1:	e8 f0 f5 ff ff       	call   80103096 <lapicstartap>
80103aa6:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103aa9:	90                   	nop
80103aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aad:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103ab3:	85 c0                	test   %eax,%eax
80103ab5:	74 f3                	je     80103aaa <startothers+0xb5>
80103ab7:	eb 01                	jmp    80103aba <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103ab9:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103aba:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103ac1:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ac6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103acc:	05 80 33 11 80       	add    $0x80113380,%eax
80103ad1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ad4:	0f 87 57 ff ff ff    	ja     80103a31 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103ada:	90                   	nop
80103adb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ade:	c9                   	leave  
80103adf:	c3                   	ret    

80103ae0 <p2v>:
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ae6:	05 00 00 00 80       	add    $0x80000000,%eax
80103aeb:	5d                   	pop    %ebp
80103aec:	c3                   	ret    

80103aed <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103aed:	55                   	push   %ebp
80103aee:	89 e5                	mov    %esp,%ebp
80103af0:	83 ec 14             	sub    $0x14,%esp
80103af3:	8b 45 08             	mov    0x8(%ebp),%eax
80103af6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103afa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103afe:	89 c2                	mov    %eax,%edx
80103b00:	ec                   	in     (%dx),%al
80103b01:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b04:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b08:	c9                   	leave  
80103b09:	c3                   	ret    

80103b0a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b0a:	55                   	push   %ebp
80103b0b:	89 e5                	mov    %esp,%ebp
80103b0d:	83 ec 08             	sub    $0x8,%esp
80103b10:	8b 55 08             	mov    0x8(%ebp),%edx
80103b13:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b16:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b1a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b1d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b21:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b25:	ee                   	out    %al,(%dx)
}
80103b26:	90                   	nop
80103b27:	c9                   	leave  
80103b28:	c3                   	ret    

80103b29 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b29:	55                   	push   %ebp
80103b2a:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b2c:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103b31:	89 c2                	mov    %eax,%edx
80103b33:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103b38:	29 c2                	sub    %eax,%edx
80103b3a:	89 d0                	mov    %edx,%eax
80103b3c:	c1 f8 02             	sar    $0x2,%eax
80103b3f:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b45:	5d                   	pop    %ebp
80103b46:	c3                   	ret    

80103b47 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b47:	55                   	push   %ebp
80103b48:	89 e5                	mov    %esp,%ebp
80103b4a:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b5b:	eb 15                	jmp    80103b72 <sum+0x2b>
    sum += addr[i];
80103b5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b60:	8b 45 08             	mov    0x8(%ebp),%eax
80103b63:	01 d0                	add    %edx,%eax
80103b65:	0f b6 00             	movzbl (%eax),%eax
80103b68:	0f b6 c0             	movzbl %al,%eax
80103b6b:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103b6e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b75:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b78:	7c e3                	jl     80103b5d <sum+0x16>
    sum += addr[i];
  return sum;
80103b7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b7d:	c9                   	leave  
80103b7e:	c3                   	ret    

80103b7f <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b7f:	55                   	push   %ebp
80103b80:	89 e5                	mov    %esp,%ebp
80103b82:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103b85:	ff 75 08             	pushl  0x8(%ebp)
80103b88:	e8 53 ff ff ff       	call   80103ae0 <p2v>
80103b8d:	83 c4 04             	add    $0x4,%esp
80103b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b93:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b99:	01 d0                	add    %edx,%eax
80103b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ba4:	eb 36                	jmp    80103bdc <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ba6:	83 ec 04             	sub    $0x4,%esp
80103ba9:	6a 04                	push   $0x4
80103bab:	68 b8 8d 10 80       	push   $0x80108db8
80103bb0:	ff 75 f4             	pushl  -0xc(%ebp)
80103bb3:	e8 34 1b 00 00       	call   801056ec <memcmp>
80103bb8:	83 c4 10             	add    $0x10,%esp
80103bbb:	85 c0                	test   %eax,%eax
80103bbd:	75 19                	jne    80103bd8 <mpsearch1+0x59>
80103bbf:	83 ec 08             	sub    $0x8,%esp
80103bc2:	6a 10                	push   $0x10
80103bc4:	ff 75 f4             	pushl  -0xc(%ebp)
80103bc7:	e8 7b ff ff ff       	call   80103b47 <sum>
80103bcc:	83 c4 10             	add    $0x10,%esp
80103bcf:	84 c0                	test   %al,%al
80103bd1:	75 05                	jne    80103bd8 <mpsearch1+0x59>
      return (struct mp*)p;
80103bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd6:	eb 11                	jmp    80103be9 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103bd8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bdf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103be2:	72 c2                	jb     80103ba6 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103be9:	c9                   	leave  
80103bea:	c3                   	ret    

80103beb <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103beb:	55                   	push   %ebp
80103bec:	89 e5                	mov    %esp,%ebp
80103bee:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103bf1:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfb:	83 c0 0f             	add    $0xf,%eax
80103bfe:	0f b6 00             	movzbl (%eax),%eax
80103c01:	0f b6 c0             	movzbl %al,%eax
80103c04:	c1 e0 08             	shl    $0x8,%eax
80103c07:	89 c2                	mov    %eax,%edx
80103c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0c:	83 c0 0e             	add    $0xe,%eax
80103c0f:	0f b6 00             	movzbl (%eax),%eax
80103c12:	0f b6 c0             	movzbl %al,%eax
80103c15:	09 d0                	or     %edx,%eax
80103c17:	c1 e0 04             	shl    $0x4,%eax
80103c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c21:	74 21                	je     80103c44 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c23:	83 ec 08             	sub    $0x8,%esp
80103c26:	68 00 04 00 00       	push   $0x400
80103c2b:	ff 75 f0             	pushl  -0x10(%ebp)
80103c2e:	e8 4c ff ff ff       	call   80103b7f <mpsearch1>
80103c33:	83 c4 10             	add    $0x10,%esp
80103c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c3d:	74 51                	je     80103c90 <mpsearch+0xa5>
      return mp;
80103c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c42:	eb 61                	jmp    80103ca5 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c47:	83 c0 14             	add    $0x14,%eax
80103c4a:	0f b6 00             	movzbl (%eax),%eax
80103c4d:	0f b6 c0             	movzbl %al,%eax
80103c50:	c1 e0 08             	shl    $0x8,%eax
80103c53:	89 c2                	mov    %eax,%edx
80103c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c58:	83 c0 13             	add    $0x13,%eax
80103c5b:	0f b6 00             	movzbl (%eax),%eax
80103c5e:	0f b6 c0             	movzbl %al,%eax
80103c61:	09 d0                	or     %edx,%eax
80103c63:	c1 e0 0a             	shl    $0xa,%eax
80103c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6c:	2d 00 04 00 00       	sub    $0x400,%eax
80103c71:	83 ec 08             	sub    $0x8,%esp
80103c74:	68 00 04 00 00       	push   $0x400
80103c79:	50                   	push   %eax
80103c7a:	e8 00 ff ff ff       	call   80103b7f <mpsearch1>
80103c7f:	83 c4 10             	add    $0x10,%esp
80103c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c89:	74 05                	je     80103c90 <mpsearch+0xa5>
      return mp;
80103c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c8e:	eb 15                	jmp    80103ca5 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c90:	83 ec 08             	sub    $0x8,%esp
80103c93:	68 00 00 01 00       	push   $0x10000
80103c98:	68 00 00 0f 00       	push   $0xf0000
80103c9d:	e8 dd fe ff ff       	call   80103b7f <mpsearch1>
80103ca2:	83 c4 10             	add    $0x10,%esp
}
80103ca5:	c9                   	leave  
80103ca6:	c3                   	ret    

80103ca7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ca7:	55                   	push   %ebp
80103ca8:	89 e5                	mov    %esp,%ebp
80103caa:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103cad:	e8 39 ff ff ff       	call   80103beb <mpsearch>
80103cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cb9:	74 0a                	je     80103cc5 <mpconfig+0x1e>
80103cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cbe:	8b 40 04             	mov    0x4(%eax),%eax
80103cc1:	85 c0                	test   %eax,%eax
80103cc3:	75 0a                	jne    80103ccf <mpconfig+0x28>
    return 0;
80103cc5:	b8 00 00 00 00       	mov    $0x0,%eax
80103cca:	e9 81 00 00 00       	jmp    80103d50 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd2:	8b 40 04             	mov    0x4(%eax),%eax
80103cd5:	83 ec 0c             	sub    $0xc,%esp
80103cd8:	50                   	push   %eax
80103cd9:	e8 02 fe ff ff       	call   80103ae0 <p2v>
80103cde:	83 c4 10             	add    $0x10,%esp
80103ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ce4:	83 ec 04             	sub    $0x4,%esp
80103ce7:	6a 04                	push   $0x4
80103ce9:	68 bd 8d 10 80       	push   $0x80108dbd
80103cee:	ff 75 f0             	pushl  -0x10(%ebp)
80103cf1:	e8 f6 19 00 00       	call   801056ec <memcmp>
80103cf6:	83 c4 10             	add    $0x10,%esp
80103cf9:	85 c0                	test   %eax,%eax
80103cfb:	74 07                	je     80103d04 <mpconfig+0x5d>
    return 0;
80103cfd:	b8 00 00 00 00       	mov    $0x0,%eax
80103d02:	eb 4c                	jmp    80103d50 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d07:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d0b:	3c 01                	cmp    $0x1,%al
80103d0d:	74 12                	je     80103d21 <mpconfig+0x7a>
80103d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d12:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d16:	3c 04                	cmp    $0x4,%al
80103d18:	74 07                	je     80103d21 <mpconfig+0x7a>
    return 0;
80103d1a:	b8 00 00 00 00       	mov    $0x0,%eax
80103d1f:	eb 2f                	jmp    80103d50 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d24:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d28:	0f b7 c0             	movzwl %ax,%eax
80103d2b:	83 ec 08             	sub    $0x8,%esp
80103d2e:	50                   	push   %eax
80103d2f:	ff 75 f0             	pushl  -0x10(%ebp)
80103d32:	e8 10 fe ff ff       	call   80103b47 <sum>
80103d37:	83 c4 10             	add    $0x10,%esp
80103d3a:	84 c0                	test   %al,%al
80103d3c:	74 07                	je     80103d45 <mpconfig+0x9e>
    return 0;
80103d3e:	b8 00 00 00 00       	mov    $0x0,%eax
80103d43:	eb 0b                	jmp    80103d50 <mpconfig+0xa9>
  *pmp = mp;
80103d45:	8b 45 08             	mov    0x8(%ebp),%eax
80103d48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d4b:	89 10                	mov    %edx,(%eax)
  return conf;
80103d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d50:	c9                   	leave  
80103d51:	c3                   	ret    

80103d52 <mpinit>:

void
mpinit(void)
{
80103d52:	55                   	push   %ebp
80103d53:	89 e5                	mov    %esp,%ebp
80103d55:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103d58:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103d5f:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103d62:	83 ec 0c             	sub    $0xc,%esp
80103d65:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103d68:	50                   	push   %eax
80103d69:	e8 39 ff ff ff       	call   80103ca7 <mpconfig>
80103d6e:	83 c4 10             	add    $0x10,%esp
80103d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d78:	0f 84 96 01 00 00    	je     80103f14 <mpinit+0x1c2>
    return;
  ismp = 1;
80103d7e:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103d85:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d8b:	8b 40 24             	mov    0x24(%eax),%eax
80103d8e:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d96:	83 c0 2c             	add    $0x2c,%eax
80103d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d9f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103da3:	0f b7 d0             	movzwl %ax,%edx
80103da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103da9:	01 d0                	add    %edx,%eax
80103dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103dae:	e9 f2 00 00 00       	jmp    80103ea5 <mpinit+0x153>
    switch(*p){
80103db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db6:	0f b6 00             	movzbl (%eax),%eax
80103db9:	0f b6 c0             	movzbl %al,%eax
80103dbc:	83 f8 04             	cmp    $0x4,%eax
80103dbf:	0f 87 bc 00 00 00    	ja     80103e81 <mpinit+0x12f>
80103dc5:	8b 04 85 00 8e 10 80 	mov    -0x7fef7200(,%eax,4),%eax
80103dcc:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dd7:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ddb:	0f b6 d0             	movzbl %al,%edx
80103dde:	a1 60 39 11 80       	mov    0x80113960,%eax
80103de3:	39 c2                	cmp    %eax,%edx
80103de5:	74 2b                	je     80103e12 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103de7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dea:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dee:	0f b6 d0             	movzbl %al,%edx
80103df1:	a1 60 39 11 80       	mov    0x80113960,%eax
80103df6:	83 ec 04             	sub    $0x4,%esp
80103df9:	52                   	push   %edx
80103dfa:	50                   	push   %eax
80103dfb:	68 c2 8d 10 80       	push   $0x80108dc2
80103e00:	e8 c1 c5 ff ff       	call   801003c6 <cprintf>
80103e05:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e08:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103e0f:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e12:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e15:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e19:	0f b6 c0             	movzbl %al,%eax
80103e1c:	83 e0 02             	and    $0x2,%eax
80103e1f:	85 c0                	test   %eax,%eax
80103e21:	74 15                	je     80103e38 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e23:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e28:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e2e:	05 80 33 11 80       	add    $0x80113380,%eax
80103e33:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103e38:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e3d:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103e43:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e49:	05 80 33 11 80       	add    $0x80113380,%eax
80103e4e:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e50:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e55:	83 c0 01             	add    $0x1,%eax
80103e58:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103e5d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e61:	eb 42                	jmp    80103ea5 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e6c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e70:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103e75:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e79:	eb 2a                	jmp    80103ea5 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e7b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e7f:	eb 24                	jmp    80103ea5 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e84:	0f b6 00             	movzbl (%eax),%eax
80103e87:	0f b6 c0             	movzbl %al,%eax
80103e8a:	83 ec 08             	sub    $0x8,%esp
80103e8d:	50                   	push   %eax
80103e8e:	68 e0 8d 10 80       	push   $0x80108de0
80103e93:	e8 2e c5 ff ff       	call   801003c6 <cprintf>
80103e98:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e9b:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103ea2:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103eab:	0f 82 02 ff ff ff    	jb     80103db3 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103eb1:	a1 64 33 11 80       	mov    0x80113364,%eax
80103eb6:	85 c0                	test   %eax,%eax
80103eb8:	75 1d                	jne    80103ed7 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103eba:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103ec1:	00 00 00 
    lapic = 0;
80103ec4:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103ecb:	00 00 00 
    ioapicid = 0;
80103ece:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103ed5:	eb 3e                	jmp    80103f15 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103ed7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eda:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ede:	84 c0                	test   %al,%al
80103ee0:	74 33                	je     80103f15 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ee2:	83 ec 08             	sub    $0x8,%esp
80103ee5:	6a 70                	push   $0x70
80103ee7:	6a 22                	push   $0x22
80103ee9:	e8 1c fc ff ff       	call   80103b0a <outb>
80103eee:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ef1:	83 ec 0c             	sub    $0xc,%esp
80103ef4:	6a 23                	push   $0x23
80103ef6:	e8 f2 fb ff ff       	call   80103aed <inb>
80103efb:	83 c4 10             	add    $0x10,%esp
80103efe:	83 c8 01             	or     $0x1,%eax
80103f01:	0f b6 c0             	movzbl %al,%eax
80103f04:	83 ec 08             	sub    $0x8,%esp
80103f07:	50                   	push   %eax
80103f08:	6a 23                	push   $0x23
80103f0a:	e8 fb fb ff ff       	call   80103b0a <outb>
80103f0f:	83 c4 10             	add    $0x10,%esp
80103f12:	eb 01                	jmp    80103f15 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f14:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f15:	c9                   	leave  
80103f16:	c3                   	ret    

80103f17 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f17:	55                   	push   %ebp
80103f18:	89 e5                	mov    %esp,%ebp
80103f1a:	83 ec 08             	sub    $0x8,%esp
80103f1d:	8b 55 08             	mov    0x8(%ebp),%edx
80103f20:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f23:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f27:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f2a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f2e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f32:	ee                   	out    %al,(%dx)
}
80103f33:	90                   	nop
80103f34:	c9                   	leave  
80103f35:	c3                   	ret    

80103f36 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f36:	55                   	push   %ebp
80103f37:	89 e5                	mov    %esp,%ebp
80103f39:	83 ec 04             	sub    $0x4,%esp
80103f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f43:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f47:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103f4d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f51:	0f b6 c0             	movzbl %al,%eax
80103f54:	50                   	push   %eax
80103f55:	6a 21                	push   $0x21
80103f57:	e8 bb ff ff ff       	call   80103f17 <outb>
80103f5c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103f5f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f63:	66 c1 e8 08          	shr    $0x8,%ax
80103f67:	0f b6 c0             	movzbl %al,%eax
80103f6a:	50                   	push   %eax
80103f6b:	68 a1 00 00 00       	push   $0xa1
80103f70:	e8 a2 ff ff ff       	call   80103f17 <outb>
80103f75:	83 c4 08             	add    $0x8,%esp
}
80103f78:	90                   	nop
80103f79:	c9                   	leave  
80103f7a:	c3                   	ret    

80103f7b <picenable>:

void
picenable(int irq)
{
80103f7b:	55                   	push   %ebp
80103f7c:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103f7e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f81:	ba 01 00 00 00       	mov    $0x1,%edx
80103f86:	89 c1                	mov    %eax,%ecx
80103f88:	d3 e2                	shl    %cl,%edx
80103f8a:	89 d0                	mov    %edx,%eax
80103f8c:	f7 d0                	not    %eax
80103f8e:	89 c2                	mov    %eax,%edx
80103f90:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f97:	21 d0                	and    %edx,%eax
80103f99:	0f b7 c0             	movzwl %ax,%eax
80103f9c:	50                   	push   %eax
80103f9d:	e8 94 ff ff ff       	call   80103f36 <picsetmask>
80103fa2:	83 c4 04             	add    $0x4,%esp
}
80103fa5:	90                   	nop
80103fa6:	c9                   	leave  
80103fa7:	c3                   	ret    

80103fa8 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103fa8:	55                   	push   %ebp
80103fa9:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103fab:	68 ff 00 00 00       	push   $0xff
80103fb0:	6a 21                	push   $0x21
80103fb2:	e8 60 ff ff ff       	call   80103f17 <outb>
80103fb7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103fba:	68 ff 00 00 00       	push   $0xff
80103fbf:	68 a1 00 00 00       	push   $0xa1
80103fc4:	e8 4e ff ff ff       	call   80103f17 <outb>
80103fc9:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103fcc:	6a 11                	push   $0x11
80103fce:	6a 20                	push   $0x20
80103fd0:	e8 42 ff ff ff       	call   80103f17 <outb>
80103fd5:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103fd8:	6a 20                	push   $0x20
80103fda:	6a 21                	push   $0x21
80103fdc:	e8 36 ff ff ff       	call   80103f17 <outb>
80103fe1:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103fe4:	6a 04                	push   $0x4
80103fe6:	6a 21                	push   $0x21
80103fe8:	e8 2a ff ff ff       	call   80103f17 <outb>
80103fed:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103ff0:	6a 03                	push   $0x3
80103ff2:	6a 21                	push   $0x21
80103ff4:	e8 1e ff ff ff       	call   80103f17 <outb>
80103ff9:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ffc:	6a 11                	push   $0x11
80103ffe:	68 a0 00 00 00       	push   $0xa0
80104003:	e8 0f ff ff ff       	call   80103f17 <outb>
80104008:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
8010400b:	6a 28                	push   $0x28
8010400d:	68 a1 00 00 00       	push   $0xa1
80104012:	e8 00 ff ff ff       	call   80103f17 <outb>
80104017:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
8010401a:	6a 02                	push   $0x2
8010401c:	68 a1 00 00 00       	push   $0xa1
80104021:	e8 f1 fe ff ff       	call   80103f17 <outb>
80104026:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104029:	6a 03                	push   $0x3
8010402b:	68 a1 00 00 00       	push   $0xa1
80104030:	e8 e2 fe ff ff       	call   80103f17 <outb>
80104035:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104038:	6a 68                	push   $0x68
8010403a:	6a 20                	push   $0x20
8010403c:	e8 d6 fe ff ff       	call   80103f17 <outb>
80104041:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104044:	6a 0a                	push   $0xa
80104046:	6a 20                	push   $0x20
80104048:	e8 ca fe ff ff       	call   80103f17 <outb>
8010404d:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104050:	6a 68                	push   $0x68
80104052:	68 a0 00 00 00       	push   $0xa0
80104057:	e8 bb fe ff ff       	call   80103f17 <outb>
8010405c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
8010405f:	6a 0a                	push   $0xa
80104061:	68 a0 00 00 00       	push   $0xa0
80104066:	e8 ac fe ff ff       	call   80103f17 <outb>
8010406b:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
8010406e:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104075:	66 83 f8 ff          	cmp    $0xffff,%ax
80104079:	74 13                	je     8010408e <picinit+0xe6>
    picsetmask(irqmask);
8010407b:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104082:	0f b7 c0             	movzwl %ax,%eax
80104085:	50                   	push   %eax
80104086:	e8 ab fe ff ff       	call   80103f36 <picsetmask>
8010408b:	83 c4 04             	add    $0x4,%esp
}
8010408e:	90                   	nop
8010408f:	c9                   	leave  
80104090:	c3                   	ret    

80104091 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104091:	55                   	push   %ebp
80104092:	89 e5                	mov    %esp,%ebp
80104094:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104097:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010409e:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801040aa:	8b 10                	mov    (%eax),%edx
801040ac:	8b 45 08             	mov    0x8(%ebp),%eax
801040af:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801040b1:	e8 dd ce ff ff       	call   80100f93 <filealloc>
801040b6:	89 c2                	mov    %eax,%edx
801040b8:	8b 45 08             	mov    0x8(%ebp),%eax
801040bb:	89 10                	mov    %edx,(%eax)
801040bd:	8b 45 08             	mov    0x8(%ebp),%eax
801040c0:	8b 00                	mov    (%eax),%eax
801040c2:	85 c0                	test   %eax,%eax
801040c4:	0f 84 cb 00 00 00    	je     80104195 <pipealloc+0x104>
801040ca:	e8 c4 ce ff ff       	call   80100f93 <filealloc>
801040cf:	89 c2                	mov    %eax,%edx
801040d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d4:	89 10                	mov    %edx,(%eax)
801040d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d9:	8b 00                	mov    (%eax),%eax
801040db:	85 c0                	test   %eax,%eax
801040dd:	0f 84 b2 00 00 00    	je     80104195 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801040e3:	e8 ce eb ff ff       	call   80102cb6 <kalloc>
801040e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040ef:	0f 84 9f 00 00 00    	je     80104194 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801040f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801040ff:	00 00 00 
  p->writeopen = 1;
80104102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104105:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010410c:	00 00 00 
  p->nwrite = 0;
8010410f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104112:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104119:	00 00 00 
  p->nread = 0;
8010411c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411f:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104126:	00 00 00 
  initlock(&p->lock, "pipe");
80104129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412c:	83 ec 08             	sub    $0x8,%esp
8010412f:	68 14 8e 10 80       	push   $0x80108e14
80104134:	50                   	push   %eax
80104135:	e8 c6 12 00 00       	call   80105400 <initlock>
8010413a:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010413d:	8b 45 08             	mov    0x8(%ebp),%eax
80104140:	8b 00                	mov    (%eax),%eax
80104142:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104148:	8b 45 08             	mov    0x8(%ebp),%eax
8010414b:	8b 00                	mov    (%eax),%eax
8010414d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104151:	8b 45 08             	mov    0x8(%ebp),%eax
80104154:	8b 00                	mov    (%eax),%eax
80104156:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010415a:	8b 45 08             	mov    0x8(%ebp),%eax
8010415d:	8b 00                	mov    (%eax),%eax
8010415f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104162:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104165:	8b 45 0c             	mov    0xc(%ebp),%eax
80104168:	8b 00                	mov    (%eax),%eax
8010416a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104170:	8b 45 0c             	mov    0xc(%ebp),%eax
80104173:	8b 00                	mov    (%eax),%eax
80104175:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104179:	8b 45 0c             	mov    0xc(%ebp),%eax
8010417c:	8b 00                	mov    (%eax),%eax
8010417e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104182:	8b 45 0c             	mov    0xc(%ebp),%eax
80104185:	8b 00                	mov    (%eax),%eax
80104187:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010418a:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010418d:	b8 00 00 00 00       	mov    $0x0,%eax
80104192:	eb 4e                	jmp    801041e2 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104194:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
80104195:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104199:	74 0e                	je     801041a9 <pipealloc+0x118>
    kfree((char*)p);
8010419b:	83 ec 0c             	sub    $0xc,%esp
8010419e:	ff 75 f4             	pushl  -0xc(%ebp)
801041a1:	e8 73 ea ff ff       	call   80102c19 <kfree>
801041a6:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041a9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ac:	8b 00                	mov    (%eax),%eax
801041ae:	85 c0                	test   %eax,%eax
801041b0:	74 11                	je     801041c3 <pipealloc+0x132>
    fileclose(*f0);
801041b2:	8b 45 08             	mov    0x8(%ebp),%eax
801041b5:	8b 00                	mov    (%eax),%eax
801041b7:	83 ec 0c             	sub    $0xc,%esp
801041ba:	50                   	push   %eax
801041bb:	e8 91 ce ff ff       	call   80101051 <fileclose>
801041c0:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801041c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c6:	8b 00                	mov    (%eax),%eax
801041c8:	85 c0                	test   %eax,%eax
801041ca:	74 11                	je     801041dd <pipealloc+0x14c>
    fileclose(*f1);
801041cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801041cf:	8b 00                	mov    (%eax),%eax
801041d1:	83 ec 0c             	sub    $0xc,%esp
801041d4:	50                   	push   %eax
801041d5:	e8 77 ce ff ff       	call   80101051 <fileclose>
801041da:	83 c4 10             	add    $0x10,%esp
  return -1;
801041dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e2:	c9                   	leave  
801041e3:	c3                   	ret    

801041e4 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801041e4:	55                   	push   %ebp
801041e5:	89 e5                	mov    %esp,%ebp
801041e7:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801041ea:	8b 45 08             	mov    0x8(%ebp),%eax
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	50                   	push   %eax
801041f1:	e8 2c 12 00 00       	call   80105422 <acquire>
801041f6:	83 c4 10             	add    $0x10,%esp
  if(writable){
801041f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801041fd:	74 23                	je     80104222 <pipeclose+0x3e>
    p->writeopen = 0;
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104209:	00 00 00 
    wakeup(&p->nread);
8010420c:	8b 45 08             	mov    0x8(%ebp),%eax
8010420f:	05 34 02 00 00       	add    $0x234,%eax
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	50                   	push   %eax
80104218:	e8 5c 0d 00 00       	call   80104f79 <wakeup>
8010421d:	83 c4 10             	add    $0x10,%esp
80104220:	eb 21                	jmp    80104243 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104222:	8b 45 08             	mov    0x8(%ebp),%eax
80104225:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010422c:	00 00 00 
    wakeup(&p->nwrite);
8010422f:	8b 45 08             	mov    0x8(%ebp),%eax
80104232:	05 38 02 00 00       	add    $0x238,%eax
80104237:	83 ec 0c             	sub    $0xc,%esp
8010423a:	50                   	push   %eax
8010423b:	e8 39 0d 00 00       	call   80104f79 <wakeup>
80104240:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104243:	8b 45 08             	mov    0x8(%ebp),%eax
80104246:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010424c:	85 c0                	test   %eax,%eax
8010424e:	75 2c                	jne    8010427c <pipeclose+0x98>
80104250:	8b 45 08             	mov    0x8(%ebp),%eax
80104253:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104259:	85 c0                	test   %eax,%eax
8010425b:	75 1f                	jne    8010427c <pipeclose+0x98>
    release(&p->lock);
8010425d:	8b 45 08             	mov    0x8(%ebp),%eax
80104260:	83 ec 0c             	sub    $0xc,%esp
80104263:	50                   	push   %eax
80104264:	e8 20 12 00 00       	call   80105489 <release>
80104269:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010426c:	83 ec 0c             	sub    $0xc,%esp
8010426f:	ff 75 08             	pushl  0x8(%ebp)
80104272:	e8 a2 e9 ff ff       	call   80102c19 <kfree>
80104277:	83 c4 10             	add    $0x10,%esp
8010427a:	eb 0f                	jmp    8010428b <pipeclose+0xa7>
  } else
    release(&p->lock);
8010427c:	8b 45 08             	mov    0x8(%ebp),%eax
8010427f:	83 ec 0c             	sub    $0xc,%esp
80104282:	50                   	push   %eax
80104283:	e8 01 12 00 00       	call   80105489 <release>
80104288:	83 c4 10             	add    $0x10,%esp
}
8010428b:	90                   	nop
8010428c:	c9                   	leave  
8010428d:	c3                   	ret    

8010428e <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
8010428e:	55                   	push   %ebp
8010428f:	89 e5                	mov    %esp,%ebp
80104291:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104294:	8b 45 08             	mov    0x8(%ebp),%eax
80104297:	83 ec 0c             	sub    $0xc,%esp
8010429a:	50                   	push   %eax
8010429b:	e8 82 11 00 00       	call   80105422 <acquire>
801042a0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042aa:	e9 ad 00 00 00       	jmp    8010435c <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801042af:	8b 45 08             	mov    0x8(%ebp),%eax
801042b2:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042b8:	85 c0                	test   %eax,%eax
801042ba:	74 0d                	je     801042c9 <pipewrite+0x3b>
801042bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c2:	8b 40 24             	mov    0x24(%eax),%eax
801042c5:	85 c0                	test   %eax,%eax
801042c7:	74 19                	je     801042e2 <pipewrite+0x54>
        release(&p->lock);
801042c9:	8b 45 08             	mov    0x8(%ebp),%eax
801042cc:	83 ec 0c             	sub    $0xc,%esp
801042cf:	50                   	push   %eax
801042d0:	e8 b4 11 00 00       	call   80105489 <release>
801042d5:	83 c4 10             	add    $0x10,%esp
        return -1;
801042d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042dd:	e9 a8 00 00 00       	jmp    8010438a <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801042e2:	8b 45 08             	mov    0x8(%ebp),%eax
801042e5:	05 34 02 00 00       	add    $0x234,%eax
801042ea:	83 ec 0c             	sub    $0xc,%esp
801042ed:	50                   	push   %eax
801042ee:	e8 86 0c 00 00       	call   80104f79 <wakeup>
801042f3:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801042f6:	8b 45 08             	mov    0x8(%ebp),%eax
801042f9:	8b 55 08             	mov    0x8(%ebp),%edx
801042fc:	81 c2 38 02 00 00    	add    $0x238,%edx
80104302:	83 ec 08             	sub    $0x8,%esp
80104305:	50                   	push   %eax
80104306:	52                   	push   %edx
80104307:	e8 7f 0b 00 00       	call   80104e8b <sleep>
8010430c:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010430f:	8b 45 08             	mov    0x8(%ebp),%eax
80104312:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104318:	8b 45 08             	mov    0x8(%ebp),%eax
8010431b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104321:	05 00 02 00 00       	add    $0x200,%eax
80104326:	39 c2                	cmp    %eax,%edx
80104328:	74 85                	je     801042af <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010432a:	8b 45 08             	mov    0x8(%ebp),%eax
8010432d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104333:	8d 48 01             	lea    0x1(%eax),%ecx
80104336:	8b 55 08             	mov    0x8(%ebp),%edx
80104339:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010433f:	25 ff 01 00 00       	and    $0x1ff,%eax
80104344:	89 c1                	mov    %eax,%ecx
80104346:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010434c:	01 d0                	add    %edx,%eax
8010434e:	0f b6 10             	movzbl (%eax),%edx
80104351:	8b 45 08             	mov    0x8(%ebp),%eax
80104354:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104358:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010435c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435f:	3b 45 10             	cmp    0x10(%ebp),%eax
80104362:	7c ab                	jl     8010430f <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
80104367:	05 34 02 00 00       	add    $0x234,%eax
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	50                   	push   %eax
80104370:	e8 04 0c 00 00       	call   80104f79 <wakeup>
80104375:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	50                   	push   %eax
8010437f:	e8 05 11 00 00       	call   80105489 <release>
80104384:	83 c4 10             	add    $0x10,%esp
  return n;
80104387:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010438a:	c9                   	leave  
8010438b:	c3                   	ret    

8010438c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010438c:	55                   	push   %ebp
8010438d:	89 e5                	mov    %esp,%ebp
8010438f:	53                   	push   %ebx
80104390:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104393:	8b 45 08             	mov    0x8(%ebp),%eax
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	50                   	push   %eax
8010439a:	e8 83 10 00 00       	call   80105422 <acquire>
8010439f:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043a2:	eb 3f                	jmp    801043e3 <piperead+0x57>
    if(proc->killed){
801043a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043aa:	8b 40 24             	mov    0x24(%eax),%eax
801043ad:	85 c0                	test   %eax,%eax
801043af:	74 19                	je     801043ca <piperead+0x3e>
      release(&p->lock);
801043b1:	8b 45 08             	mov    0x8(%ebp),%eax
801043b4:	83 ec 0c             	sub    $0xc,%esp
801043b7:	50                   	push   %eax
801043b8:	e8 cc 10 00 00       	call   80105489 <release>
801043bd:	83 c4 10             	add    $0x10,%esp
      return -1;
801043c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c5:	e9 bf 00 00 00       	jmp    80104489 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801043ca:	8b 45 08             	mov    0x8(%ebp),%eax
801043cd:	8b 55 08             	mov    0x8(%ebp),%edx
801043d0:	81 c2 34 02 00 00    	add    $0x234,%edx
801043d6:	83 ec 08             	sub    $0x8,%esp
801043d9:	50                   	push   %eax
801043da:	52                   	push   %edx
801043db:	e8 ab 0a 00 00       	call   80104e8b <sleep>
801043e0:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043e3:	8b 45 08             	mov    0x8(%ebp),%eax
801043e6:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043ec:	8b 45 08             	mov    0x8(%ebp),%eax
801043ef:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043f5:	39 c2                	cmp    %eax,%edx
801043f7:	75 0d                	jne    80104406 <piperead+0x7a>
801043f9:	8b 45 08             	mov    0x8(%ebp),%eax
801043fc:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104402:	85 c0                	test   %eax,%eax
80104404:	75 9e                	jne    801043a4 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010440d:	eb 49                	jmp    80104458 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010440f:	8b 45 08             	mov    0x8(%ebp),%eax
80104412:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104418:	8b 45 08             	mov    0x8(%ebp),%eax
8010441b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104421:	39 c2                	cmp    %eax,%edx
80104423:	74 3d                	je     80104462 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104425:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104428:	8b 45 0c             	mov    0xc(%ebp),%eax
8010442b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010442e:	8b 45 08             	mov    0x8(%ebp),%eax
80104431:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104437:	8d 48 01             	lea    0x1(%eax),%ecx
8010443a:	8b 55 08             	mov    0x8(%ebp),%edx
8010443d:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104443:	25 ff 01 00 00       	and    $0x1ff,%eax
80104448:	89 c2                	mov    %eax,%edx
8010444a:	8b 45 08             	mov    0x8(%ebp),%eax
8010444d:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104452:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104454:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010445e:	7c af                	jl     8010440f <piperead+0x83>
80104460:	eb 01                	jmp    80104463 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104462:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
80104466:	05 38 02 00 00       	add    $0x238,%eax
8010446b:	83 ec 0c             	sub    $0xc,%esp
8010446e:	50                   	push   %eax
8010446f:	e8 05 0b 00 00       	call   80104f79 <wakeup>
80104474:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104477:	8b 45 08             	mov    0x8(%ebp),%eax
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	50                   	push   %eax
8010447e:	e8 06 10 00 00       	call   80105489 <release>
80104483:	83 c4 10             	add    $0x10,%esp
  return i;
80104486:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010448c:	c9                   	leave  
8010448d:	c3                   	ret    

8010448e <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010448e:	55                   	push   %ebp
8010448f:	89 e5                	mov    %esp,%ebp
80104491:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104494:	9c                   	pushf  
80104495:	58                   	pop    %eax
80104496:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104499:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010449c:	c9                   	leave  
8010449d:	c3                   	ret    

8010449e <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010449e:	55                   	push   %ebp
8010449f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044a1:	fb                   	sti    
}
801044a2:	90                   	nop
801044a3:	5d                   	pop    %ebp
801044a4:	c3                   	ret    

801044a5 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801044a5:	55                   	push   %ebp
801044a6:	89 e5                	mov    %esp,%ebp
801044a8:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801044ab:	83 ec 08             	sub    $0x8,%esp
801044ae:	68 19 8e 10 80       	push   $0x80108e19
801044b3:	68 80 39 11 80       	push   $0x80113980
801044b8:	e8 43 0f 00 00       	call   80105400 <initlock>
801044bd:	83 c4 10             	add    $0x10,%esp
}
801044c0:	90                   	nop
801044c1:	c9                   	leave  
801044c2:	c3                   	ret    

801044c3 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801044c3:	55                   	push   %ebp
801044c4:	89 e5                	mov    %esp,%ebp
801044c6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801044c9:	83 ec 0c             	sub    $0xc,%esp
801044cc:	68 80 39 11 80       	push   $0x80113980
801044d1:	e8 4c 0f 00 00       	call   80105422 <acquire>
801044d6:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d9:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801044e0:	eb 11                	jmp    801044f3 <allocproc+0x30>
    if(p->state == UNUSED)
801044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e5:	8b 40 0c             	mov    0xc(%eax),%eax
801044e8:	85 c0                	test   %eax,%eax
801044ea:	74 2a                	je     80104516 <allocproc+0x53>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ec:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801044f3:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
801044fa:	72 e6                	jb     801044e2 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801044fc:	83 ec 0c             	sub    $0xc,%esp
801044ff:	68 80 39 11 80       	push   $0x80113980
80104504:	e8 80 0f 00 00       	call   80105489 <release>
80104509:	83 c4 10             	add    $0x10,%esp
  return 0;
8010450c:	b8 00 00 00 00       	mov    $0x0,%eax
80104511:	e9 ff 00 00 00       	jmp    80104615 <allocproc+0x152>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104516:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104521:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104526:	8d 50 01             	lea    0x1(%eax),%edx
80104529:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010452f:	89 c2                	mov    %eax,%edx
80104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104534:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104537:	83 ec 0c             	sub    $0xc,%esp
8010453a:	68 80 39 11 80       	push   $0x80113980
8010453f:	e8 45 0f 00 00       	call   80105489 <release>
80104544:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104547:	e8 6a e7 ff ff       	call   80102cb6 <kalloc>
8010454c:	89 c2                	mov    %eax,%edx
8010454e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104551:	89 50 08             	mov    %edx,0x8(%eax)
80104554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104557:	8b 40 08             	mov    0x8(%eax),%eax
8010455a:	85 c0                	test   %eax,%eax
8010455c:	75 14                	jne    80104572 <allocproc+0xaf>
    p->state = UNUSED;
8010455e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104561:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104568:	b8 00 00 00 00       	mov    $0x0,%eax
8010456d:	e9 a3 00 00 00       	jmp    80104615 <allocproc+0x152>
  }
  sp = p->kstack + KSTACKSIZE;
80104572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104575:	8b 40 08             	mov    0x8(%eax),%eax
80104578:	05 00 10 00 00       	add    $0x1000,%eax
8010457d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104580:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010458a:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010458d:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104591:	ba e8 6b 10 80       	mov    $0x80106be8,%edx
80104596:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104599:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010459b:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045a5:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801045a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ab:	8b 40 1c             	mov    0x1c(%eax),%eax
801045ae:	83 ec 04             	sub    $0x4,%esp
801045b1:	6a 14                	push   $0x14
801045b3:	6a 00                	push   $0x0
801045b5:	50                   	push   %eax
801045b6:	e8 ca 10 00 00       	call   80105685 <memset>
801045bb:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c1:	8b 40 1c             	mov    0x1c(%eax),%eax
801045c4:	ba 45 4e 10 80       	mov    $0x80104e45,%edx
801045c9:	89 50 10             	mov    %edx,0x10(%eax)

  // STUDENT CODE
  // Grab Start Time 
  acquire(&tickslock);
801045cc:	83 ec 0c             	sub    $0xc,%esp
801045cf:	68 c0 5d 11 80       	push   $0x80115dc0
801045d4:	e8 49 0e 00 00       	call   80105422 <acquire>
801045d9:	83 c4 10             	add    $0x10,%esp
  p->start_ticks = (uint)ticks;
801045dc:	8b 15 00 66 11 80    	mov    0x80116600,%edx
801045e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e5:	89 50 7c             	mov    %edx,0x7c(%eax)
  release(&tickslock);
801045e8:	83 ec 0c             	sub    $0xc,%esp
801045eb:	68 c0 5d 11 80       	push   $0x80115dc0
801045f0:	e8 94 0e 00 00       	call   80105489 <release>
801045f5:	83 c4 10             	add    $0x10,%esp

  p->cpu_ticks_total = 0;
801045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fb:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104602:	00 00 00 
  p->cpu_ticks_in = 0;
80104605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104608:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010460f:	00 00 00 
  return p;
80104612:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104615:	c9                   	leave  
80104616:	c3                   	ret    

80104617 <userinit>:

// Set up first user process.
void
userinit(void)
{
80104617:	55                   	push   %ebp
80104618:	89 e5                	mov    %esp,%ebp
8010461a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010461d:	e8 a1 fe ff ff       	call   801044c3 <allocproc>
80104622:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104628:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
8010462d:	e8 7b 3c 00 00       	call   801082ad <setupkvm>
80104632:	89 c2                	mov    %eax,%edx
80104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104637:	89 50 04             	mov    %edx,0x4(%eax)
8010463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463d:	8b 40 04             	mov    0x4(%eax),%eax
80104640:	85 c0                	test   %eax,%eax
80104642:	75 0d                	jne    80104651 <userinit+0x3a>
    panic("userinit: out of memory?");
80104644:	83 ec 0c             	sub    $0xc,%esp
80104647:	68 20 8e 10 80       	push   $0x80108e20
8010464c:	e8 15 bf ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104651:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104659:	8b 40 04             	mov    0x4(%eax),%eax
8010465c:	83 ec 04             	sub    $0x4,%esp
8010465f:	52                   	push   %edx
80104660:	68 00 c5 10 80       	push   $0x8010c500
80104665:	50                   	push   %eax
80104666:	e8 9c 3e 00 00       	call   80108507 <inituvm>
8010466b:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010466e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104671:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467a:	8b 40 18             	mov    0x18(%eax),%eax
8010467d:	83 ec 04             	sub    $0x4,%esp
80104680:	6a 4c                	push   $0x4c
80104682:	6a 00                	push   $0x0
80104684:	50                   	push   %eax
80104685:	e8 fb 0f 00 00       	call   80105685 <memset>
8010468a:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104690:	8b 40 18             	mov    0x18(%eax),%eax
80104693:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469c:	8b 40 18             	mov    0x18(%eax),%eax
8010469f:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801046a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a8:	8b 40 18             	mov    0x18(%eax),%eax
801046ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046ae:	8b 52 18             	mov    0x18(%edx),%edx
801046b1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046b5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801046b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bc:	8b 40 18             	mov    0x18(%eax),%eax
801046bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046c2:	8b 52 18             	mov    0x18(%edx),%edx
801046c5:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046c9:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801046cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d0:	8b 40 18             	mov    0x18(%eax),%eax
801046d3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046dd:	8b 40 18             	mov    0x18(%eax),%eax
801046e0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801046e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ea:	8b 40 18             	mov    0x18(%eax),%eax
801046ed:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f7:	83 c0 6c             	add    $0x6c,%eax
801046fa:	83 ec 04             	sub    $0x4,%esp
801046fd:	6a 10                	push   $0x10
801046ff:	68 39 8e 10 80       	push   $0x80108e39
80104704:	50                   	push   %eax
80104705:	e8 7e 11 00 00       	call   80105888 <safestrcpy>
8010470a:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010470d:	83 ec 0c             	sub    $0xc,%esp
80104710:	68 42 8e 10 80       	push   $0x80108e42
80104715:	e8 5e de ff ff       	call   80102578 <namei>
8010471a:	83 c4 10             	add    $0x10,%esp
8010471d:	89 c2                	mov    %eax,%edx
8010471f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104722:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104728:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
 
  p->uid = INITUID;
8010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104732:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104739:	00 00 00 
  p->gid = INITGID;
8010473c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104746:	00 00 00 
}
80104749:	90                   	nop
8010474a:	c9                   	leave  
8010474b:	c3                   	ret    

8010474c <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010474c:	55                   	push   %ebp
8010474d:	89 e5                	mov    %esp,%ebp
8010474f:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104752:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104758:	8b 00                	mov    (%eax),%eax
8010475a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010475d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104761:	7e 31                	jle    80104794 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104763:	8b 55 08             	mov    0x8(%ebp),%edx
80104766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104769:	01 c2                	add    %eax,%edx
8010476b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104771:	8b 40 04             	mov    0x4(%eax),%eax
80104774:	83 ec 04             	sub    $0x4,%esp
80104777:	52                   	push   %edx
80104778:	ff 75 f4             	pushl  -0xc(%ebp)
8010477b:	50                   	push   %eax
8010477c:	e8 d3 3e 00 00       	call   80108654 <allocuvm>
80104781:	83 c4 10             	add    $0x10,%esp
80104784:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010478b:	75 3e                	jne    801047cb <growproc+0x7f>
      return -1;
8010478d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104792:	eb 59                	jmp    801047ed <growproc+0xa1>
  } else if(n < 0){
80104794:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104798:	79 31                	jns    801047cb <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010479a:	8b 55 08             	mov    0x8(%ebp),%edx
8010479d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a0:	01 c2                	add    %eax,%edx
801047a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a8:	8b 40 04             	mov    0x4(%eax),%eax
801047ab:	83 ec 04             	sub    $0x4,%esp
801047ae:	52                   	push   %edx
801047af:	ff 75 f4             	pushl  -0xc(%ebp)
801047b2:	50                   	push   %eax
801047b3:	e8 65 3f 00 00       	call   8010871d <deallocuvm>
801047b8:	83 c4 10             	add    $0x10,%esp
801047bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047c2:	75 07                	jne    801047cb <growproc+0x7f>
      return -1;
801047c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047c9:	eb 22                	jmp    801047ed <growproc+0xa1>
  }
  proc->sz = sz;
801047cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047d4:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801047d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047dc:	83 ec 0c             	sub    $0xc,%esp
801047df:	50                   	push   %eax
801047e0:	e8 af 3b 00 00       	call   80108394 <switchuvm>
801047e5:	83 c4 10             	add    $0x10,%esp
  return 0;
801047e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047ed:	c9                   	leave  
801047ee:	c3                   	ret    

801047ef <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801047ef:	55                   	push   %ebp
801047f0:	89 e5                	mov    %esp,%ebp
801047f2:	57                   	push   %edi
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801047f8:	e8 c6 fc ff ff       	call   801044c3 <allocproc>
801047fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104800:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104804:	75 0a                	jne    80104810 <fork+0x21>
    return -1;
80104806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010480b:	e9 92 01 00 00       	jmp    801049a2 <fork+0x1b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104810:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104816:	8b 10                	mov    (%eax),%edx
80104818:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010481e:	8b 40 04             	mov    0x4(%eax),%eax
80104821:	83 ec 08             	sub    $0x8,%esp
80104824:	52                   	push   %edx
80104825:	50                   	push   %eax
80104826:	e8 90 40 00 00       	call   801088bb <copyuvm>
8010482b:	83 c4 10             	add    $0x10,%esp
8010482e:	89 c2                	mov    %eax,%edx
80104830:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104833:	89 50 04             	mov    %edx,0x4(%eax)
80104836:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104839:	8b 40 04             	mov    0x4(%eax),%eax
8010483c:	85 c0                	test   %eax,%eax
8010483e:	75 30                	jne    80104870 <fork+0x81>
    kfree(np->kstack);
80104840:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104843:	8b 40 08             	mov    0x8(%eax),%eax
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	50                   	push   %eax
8010484a:	e8 ca e3 ff ff       	call   80102c19 <kfree>
8010484f:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104852:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104855:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010485c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010485f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104866:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010486b:	e9 32 01 00 00       	jmp    801049a2 <fork+0x1b3>
  }
  np->sz = proc->sz;
80104870:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104876:	8b 10                	mov    (%eax),%edx
80104878:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010487b:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010487d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104884:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104887:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010488a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010488d:	8b 50 18             	mov    0x18(%eax),%edx
80104890:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104896:	8b 40 18             	mov    0x18(%eax),%eax
80104899:	89 c3                	mov    %eax,%ebx
8010489b:	b8 13 00 00 00       	mov    $0x13,%eax
801048a0:	89 d7                	mov    %edx,%edi
801048a2:	89 de                	mov    %ebx,%esi
801048a4:	89 c1                	mov    %eax,%ecx
801048a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801048a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ab:	8b 40 18             	mov    0x18(%eax),%eax
801048ae:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801048b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801048bc:	eb 43                	jmp    80104901 <fork+0x112>
    if(proc->ofile[i])
801048be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048c7:	83 c2 08             	add    $0x8,%edx
801048ca:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048ce:	85 c0                	test   %eax,%eax
801048d0:	74 2b                	je     801048fd <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
801048d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048db:	83 c2 08             	add    $0x8,%edx
801048de:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048e2:	83 ec 0c             	sub    $0xc,%esp
801048e5:	50                   	push   %eax
801048e6:	e8 15 c7 ff ff       	call   80101000 <filedup>
801048eb:	83 c4 10             	add    $0x10,%esp
801048ee:	89 c1                	mov    %eax,%ecx
801048f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048f6:	83 c2 08             	add    $0x8,%edx
801048f9:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801048fd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104901:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104905:	7e b7                	jle    801048be <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104907:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010490d:	8b 40 68             	mov    0x68(%eax),%eax
80104910:	83 ec 0c             	sub    $0xc,%esp
80104913:	50                   	push   %eax
80104914:	e8 17 d0 ff ff       	call   80101930 <idup>
80104919:	83 c4 10             	add    $0x10,%esp
8010491c:	89 c2                	mov    %eax,%edx
8010491e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104921:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010492d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104930:	83 c0 6c             	add    $0x6c,%eax
80104933:	83 ec 04             	sub    $0x4,%esp
80104936:	6a 10                	push   $0x10
80104938:	52                   	push   %edx
80104939:	50                   	push   %eax
8010493a:	e8 49 0f 00 00       	call   80105888 <safestrcpy>
8010493f:	83 c4 10             	add    $0x10,%esp
 
  //STUDENT CODE copy all ids
  pid = np->pid;
80104942:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104945:	8b 40 10             	mov    0x10(%eax),%eax
80104948:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->uid = proc->uid;
8010494b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104951:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104957:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010495a:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
80104960:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104966:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
8010496c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010496f:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  
  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104975:	83 ec 0c             	sub    $0xc,%esp
80104978:	68 80 39 11 80       	push   $0x80113980
8010497d:	e8 a0 0a 00 00       	call   80105422 <acquire>
80104982:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104985:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104988:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
8010498f:	83 ec 0c             	sub    $0xc,%esp
80104992:	68 80 39 11 80       	push   $0x80113980
80104997:	e8 ed 0a 00 00       	call   80105489 <release>
8010499c:	83 c4 10             	add    $0x10,%esp
  
  return pid;
8010499f:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049a5:	5b                   	pop    %ebx
801049a6:	5e                   	pop    %esi
801049a7:	5f                   	pop    %edi
801049a8:	5d                   	pop    %ebp
801049a9:	c3                   	ret    

801049aa <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049aa:	55                   	push   %ebp
801049ab:	89 e5                	mov    %esp,%ebp
801049ad:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801049b0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049b7:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049bc:	39 c2                	cmp    %eax,%edx
801049be:	75 0d                	jne    801049cd <exit+0x23>
    panic("init exiting");
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	68 44 8e 10 80       	push   $0x80108e44
801049c8:	e8 99 bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049d4:	eb 48                	jmp    80104a1e <exit+0x74>
    if(proc->ofile[fd]){
801049d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049df:	83 c2 08             	add    $0x8,%edx
801049e2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049e6:	85 c0                	test   %eax,%eax
801049e8:	74 30                	je     80104a1a <exit+0x70>
      fileclose(proc->ofile[fd]);
801049ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049f3:	83 c2 08             	add    $0x8,%edx
801049f6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049fa:	83 ec 0c             	sub    $0xc,%esp
801049fd:	50                   	push   %eax
801049fe:	e8 4e c6 ff ff       	call   80101051 <fileclose>
80104a03:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a0f:	83 c2 08             	add    $0x8,%edx
80104a12:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a19:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a1a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a1e:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a22:	7e b2                	jle    801049d6 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a24:	e8 74 eb ff ff       	call   8010359d <begin_op>
  iput(proc->cwd);
80104a29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a2f:	8b 40 68             	mov    0x68(%eax),%eax
80104a32:	83 ec 0c             	sub    $0xc,%esp
80104a35:	50                   	push   %eax
80104a36:	e8 27 d1 ff ff       	call   80101b62 <iput>
80104a3b:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a3e:	e8 e6 eb ff ff       	call   80103629 <end_op>
  proc->cwd = 0;
80104a43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a49:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	68 80 39 11 80       	push   $0x80113980
80104a58:	e8 c5 09 00 00       	call   80105422 <acquire>
80104a5d:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a66:	8b 40 14             	mov    0x14(%eax),%eax
80104a69:	83 ec 0c             	sub    $0xc,%esp
80104a6c:	50                   	push   %eax
80104a6d:	e8 c5 04 00 00       	call   80104f37 <wakeup1>
80104a72:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a75:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104a7c:	eb 3f                	jmp    80104abd <exit+0x113>
    if(p->parent == proc){
80104a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a81:	8b 50 14             	mov    0x14(%eax),%edx
80104a84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8a:	39 c2                	cmp    %eax,%edx
80104a8c:	75 28                	jne    80104ab6 <exit+0x10c>
      p->parent = initproc;
80104a8e:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a97:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9d:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa0:	83 f8 05             	cmp    $0x5,%eax
80104aa3:	75 11                	jne    80104ab6 <exit+0x10c>
        wakeup1(initproc);
80104aa5:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104aaa:	83 ec 0c             	sub    $0xc,%esp
80104aad:	50                   	push   %eax
80104aae:	e8 84 04 00 00       	call   80104f37 <wakeup1>
80104ab3:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ab6:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104abd:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80104ac4:	72 b8                	jb     80104a7e <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104ac6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104acc:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104ad3:	e8 1b 02 00 00       	call   80104cf3 <sched>
  panic("zombie exit");
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	68 51 8e 10 80       	push   $0x80108e51
80104ae0:	e8 81 ba ff ff       	call   80100566 <panic>

80104ae5 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104ae5:	55                   	push   %ebp
80104ae6:	89 e5                	mov    %esp,%ebp
80104ae8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104aeb:	83 ec 0c             	sub    $0xc,%esp
80104aee:	68 80 39 11 80       	push   $0x80113980
80104af3:	e8 2a 09 00 00       	call   80105422 <acquire>
80104af8:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104afb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b02:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104b09:	e9 a9 00 00 00       	jmp    80104bb7 <wait+0xd2>
      if(p->parent != proc)
80104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b11:	8b 50 14             	mov    0x14(%eax),%edx
80104b14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b1a:	39 c2                	cmp    %eax,%edx
80104b1c:	0f 85 8d 00 00 00    	jne    80104baf <wait+0xca>
        continue;
      havekids = 1;
80104b22:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2c:	8b 40 0c             	mov    0xc(%eax),%eax
80104b2f:	83 f8 05             	cmp    $0x5,%eax
80104b32:	75 7c                	jne    80104bb0 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b37:	8b 40 10             	mov    0x10(%eax),%eax
80104b3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b40:	8b 40 08             	mov    0x8(%eax),%eax
80104b43:	83 ec 0c             	sub    $0xc,%esp
80104b46:	50                   	push   %eax
80104b47:	e8 cd e0 ff ff       	call   80102c19 <kfree>
80104b4c:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5c:	8b 40 04             	mov    0x4(%eax),%eax
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	50                   	push   %eax
80104b63:	e8 72 3c 00 00       	call   801087da <freevm>
80104b68:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b78:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b82:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b93:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	68 80 39 11 80       	push   $0x80113980
80104ba2:	e8 e2 08 00 00       	call   80105489 <release>
80104ba7:	83 c4 10             	add    $0x10,%esp
        return pid;
80104baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bad:	eb 5b                	jmp    80104c0a <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104baf:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb0:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104bb7:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80104bbe:	0f 82 4a ff ff ff    	jb     80104b0e <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104bc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bc8:	74 0d                	je     80104bd7 <wait+0xf2>
80104bca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd0:	8b 40 24             	mov    0x24(%eax),%eax
80104bd3:	85 c0                	test   %eax,%eax
80104bd5:	74 17                	je     80104bee <wait+0x109>
      release(&ptable.lock);
80104bd7:	83 ec 0c             	sub    $0xc,%esp
80104bda:	68 80 39 11 80       	push   $0x80113980
80104bdf:	e8 a5 08 00 00       	call   80105489 <release>
80104be4:	83 c4 10             	add    $0x10,%esp
      return -1;
80104be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bec:	eb 1c                	jmp    80104c0a <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104bee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	68 80 39 11 80       	push   $0x80113980
80104bfc:	50                   	push   %eax
80104bfd:	e8 89 02 00 00       	call   80104e8b <sleep>
80104c02:	83 c4 10             	add    $0x10,%esp
  }
80104c05:	e9 f1 fe ff ff       	jmp    80104afb <wait+0x16>
}
80104c0a:	c9                   	leave  
80104c0b:	c3                   	ret    

80104c0c <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3
// original xv6 scheduler. Use if CS333_P3 NOT defined.
void
scheduler(void)
{
80104c0c:	55                   	push   %ebp
80104c0d:	89 e5                	mov    %esp,%ebp
80104c0f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  uint now;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c12:	e8 87 f8 ff ff       	call   8010449e <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c17:	83 ec 0c             	sub    $0xc,%esp
80104c1a:	68 80 39 11 80       	push   $0x80113980
80104c1f:	e8 fe 07 00 00       	call   80105422 <acquire>
80104c24:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c27:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c2e:	e9 9e 00 00 00       	jmp    80104cd1 <scheduler+0xc5>
      if(p->state != RUNNABLE)
80104c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c36:	8b 40 0c             	mov    0xc(%eax),%eax
80104c39:	83 f8 03             	cmp    $0x3,%eax
80104c3c:	0f 85 87 00 00 00    	jne    80104cc9 <scheduler+0xbd>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c45:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104c4b:	83 ec 0c             	sub    $0xc,%esp
80104c4e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c51:	e8 3e 37 00 00       	call   80108394 <switchuvm>
80104c56:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5c:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      
      acquire(&tickslock);
80104c63:	83 ec 0c             	sub    $0xc,%esp
80104c66:	68 c0 5d 11 80       	push   $0x80115dc0
80104c6b:	e8 b2 07 00 00       	call   80105422 <acquire>
80104c70:	83 c4 10             	add    $0x10,%esp
      now = (uint)ticks;
80104c73:	a1 00 66 11 80       	mov    0x80116600,%eax
80104c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
      release(&tickslock);
80104c7b:	83 ec 0c             	sub    $0xc,%esp
80104c7e:	68 c0 5d 11 80       	push   $0x80115dc0
80104c83:	e8 01 08 00 00       	call   80105489 <release>
80104c88:	83 c4 10             	add    $0x10,%esp
      p->cpu_ticks_in = now;
80104c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c91:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

      swtch(&cpu->scheduler, proc->context);
80104c97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ca0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ca7:	83 c2 04             	add    $0x4,%edx
80104caa:	83 ec 08             	sub    $0x8,%esp
80104cad:	50                   	push   %eax
80104cae:	52                   	push   %edx
80104caf:	e8 45 0c 00 00       	call   801058f9 <swtch>
80104cb4:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104cb7:	e8 bb 36 00 00       	call   80108377 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104cbc:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cc3:	00 00 00 00 
80104cc7:	eb 01                	jmp    80104cca <scheduler+0xbe>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104cc9:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cca:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104cd1:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80104cd8:	0f 82 55 ff ff ff    	jb     80104c33 <scheduler+0x27>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104cde:	83 ec 0c             	sub    $0xc,%esp
80104ce1:	68 80 39 11 80       	push   $0x80113980
80104ce6:	e8 9e 07 00 00       	call   80105489 <release>
80104ceb:	83 c4 10             	add    $0x10,%esp

  }
80104cee:	e9 1f ff ff ff       	jmp    80104c12 <scheduler+0x6>

80104cf3 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104cf3:	55                   	push   %ebp
80104cf4:	89 e5                	mov    %esp,%ebp
80104cf6:	53                   	push   %ebx
80104cf7:	83 ec 14             	sub    $0x14,%esp
  int intena;
  uint now;

  if(!holding(&ptable.lock))
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	68 80 39 11 80       	push   $0x80113980
80104d02:	e8 4e 08 00 00       	call   80105555 <holding>
80104d07:	83 c4 10             	add    $0x10,%esp
80104d0a:	85 c0                	test   %eax,%eax
80104d0c:	75 0d                	jne    80104d1b <sched+0x28>
    panic("sched ptable.lock");
80104d0e:	83 ec 0c             	sub    $0xc,%esp
80104d11:	68 5d 8e 10 80       	push   $0x80108e5d
80104d16:	e8 4b b8 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d1b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d21:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d27:	83 f8 01             	cmp    $0x1,%eax
80104d2a:	74 0d                	je     80104d39 <sched+0x46>
    panic("sched locks");
80104d2c:	83 ec 0c             	sub    $0xc,%esp
80104d2f:	68 6f 8e 10 80       	push   $0x80108e6f
80104d34:	e8 2d b8 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d3f:	8b 40 0c             	mov    0xc(%eax),%eax
80104d42:	83 f8 04             	cmp    $0x4,%eax
80104d45:	75 0d                	jne    80104d54 <sched+0x61>
    panic("sched running");
80104d47:	83 ec 0c             	sub    $0xc,%esp
80104d4a:	68 7b 8e 10 80       	push   $0x80108e7b
80104d4f:	e8 12 b8 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104d54:	e8 35 f7 ff ff       	call   8010448e <readeflags>
80104d59:	25 00 02 00 00       	and    $0x200,%eax
80104d5e:	85 c0                	test   %eax,%eax
80104d60:	74 0d                	je     80104d6f <sched+0x7c>
    panic("sched interruptible");
80104d62:	83 ec 0c             	sub    $0xc,%esp
80104d65:	68 89 8e 10 80       	push   $0x80108e89
80104d6a:	e8 f7 b7 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104d6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d75:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&tickslock);
80104d7e:	83 ec 0c             	sub    $0xc,%esp
80104d81:	68 c0 5d 11 80       	push   $0x80115dc0
80104d86:	e8 97 06 00 00       	call   80105422 <acquire>
80104d8b:	83 c4 10             	add    $0x10,%esp
  now = (uint)ticks;
80104d8e:	a1 00 66 11 80       	mov    0x80116600,%eax
80104d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  release(&tickslock);
80104d96:	83 ec 0c             	sub    $0xc,%esp
80104d99:	68 c0 5d 11 80       	push   $0x80115dc0
80104d9e:	e8 e6 06 00 00       	call   80105489 <release>
80104da3:	83 c4 10             	add    $0x10,%esp

  proc->cpu_ticks_total = proc->cpu_ticks_total + (now - proc->cpu_ticks_in);
80104da6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dac:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104db3:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104db9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104dc0:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80104dc6:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80104dc9:	29 d3                	sub    %edx,%ebx
80104dcb:	89 da                	mov    %ebx,%edx
80104dcd:	01 ca                	add    %ecx,%edx
80104dcf:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  
  swtch(&proc->context, cpu->scheduler);
80104dd5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ddb:	8b 40 04             	mov    0x4(%eax),%eax
80104dde:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104de5:	83 c2 1c             	add    $0x1c,%edx
80104de8:	83 ec 08             	sub    $0x8,%esp
80104deb:	50                   	push   %eax
80104dec:	52                   	push   %edx
80104ded:	e8 07 0b 00 00       	call   801058f9 <swtch>
80104df2:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104df5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dfe:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e04:	90                   	nop
80104e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e08:	c9                   	leave  
80104e09:	c3                   	ret    

80104e0a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e0a:	55                   	push   %ebp
80104e0b:	89 e5                	mov    %esp,%ebp
80104e0d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e10:	83 ec 0c             	sub    $0xc,%esp
80104e13:	68 80 39 11 80       	push   $0x80113980
80104e18:	e8 05 06 00 00       	call   80105422 <acquire>
80104e1d:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e26:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104e2d:	e8 c1 fe ff ff       	call   80104cf3 <sched>
  release(&ptable.lock);
80104e32:	83 ec 0c             	sub    $0xc,%esp
80104e35:	68 80 39 11 80       	push   $0x80113980
80104e3a:	e8 4a 06 00 00       	call   80105489 <release>
80104e3f:	83 c4 10             	add    $0x10,%esp
}
80104e42:	90                   	nop
80104e43:	c9                   	leave  
80104e44:	c3                   	ret    

80104e45 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e45:	55                   	push   %ebp
80104e46:	89 e5                	mov    %esp,%ebp
80104e48:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e4b:	83 ec 0c             	sub    $0xc,%esp
80104e4e:	68 80 39 11 80       	push   $0x80113980
80104e53:	e8 31 06 00 00       	call   80105489 <release>
80104e58:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e5b:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104e60:	85 c0                	test   %eax,%eax
80104e62:	74 24                	je     80104e88 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104e64:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104e6b:	00 00 00 
    iinit(ROOTDEV);
80104e6e:	83 ec 0c             	sub    $0xc,%esp
80104e71:	6a 01                	push   $0x1
80104e73:	e8 c6 c7 ff ff       	call   8010163e <iinit>
80104e78:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104e7b:	83 ec 0c             	sub    $0xc,%esp
80104e7e:	6a 01                	push   $0x1
80104e80:	e8 fa e4 ff ff       	call   8010337f <initlog>
80104e85:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104e88:	90                   	nop
80104e89:	c9                   	leave  
80104e8a:	c3                   	ret    

80104e8b <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e8b:	55                   	push   %ebp
80104e8c:	89 e5                	mov    %esp,%ebp
80104e8e:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e97:	85 c0                	test   %eax,%eax
80104e99:	75 0d                	jne    80104ea8 <sleep+0x1d>
    panic("sleep");
80104e9b:	83 ec 0c             	sub    $0xc,%esp
80104e9e:	68 9d 8e 10 80       	push   $0x80108e9d
80104ea3:	e8 be b6 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104ea8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104eac:	75 0d                	jne    80104ebb <sleep+0x30>
    panic("sleep without lk");
80104eae:	83 ec 0c             	sub    $0xc,%esp
80104eb1:	68 a3 8e 10 80       	push   $0x80108ea3
80104eb6:	e8 ab b6 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ebb:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104ec2:	74 1e                	je     80104ee2 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	68 80 39 11 80       	push   $0x80113980
80104ecc:	e8 51 05 00 00       	call   80105422 <acquire>
80104ed1:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104ed4:	83 ec 0c             	sub    $0xc,%esp
80104ed7:	ff 75 0c             	pushl  0xc(%ebp)
80104eda:	e8 aa 05 00 00       	call   80105489 <release>
80104edf:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ee2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee8:	8b 55 08             	mov    0x8(%ebp),%edx
80104eeb:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104eee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104efb:	e8 f3 fd ff ff       	call   80104cf3 <sched>

  // Tidy up.
  proc->chan = 0;
80104f00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f06:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104f0d:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104f14:	74 1e                	je     80104f34 <sleep+0xa9>
    release(&ptable.lock);
80104f16:	83 ec 0c             	sub    $0xc,%esp
80104f19:	68 80 39 11 80       	push   $0x80113980
80104f1e:	e8 66 05 00 00       	call   80105489 <release>
80104f23:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104f26:	83 ec 0c             	sub    $0xc,%esp
80104f29:	ff 75 0c             	pushl  0xc(%ebp)
80104f2c:	e8 f1 04 00 00       	call   80105422 <acquire>
80104f31:	83 c4 10             	add    $0x10,%esp
  }
}
80104f34:	90                   	nop
80104f35:	c9                   	leave  
80104f36:	c3                   	ret    

80104f37 <wakeup1>:

// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f37:	55                   	push   %ebp
80104f38:	89 e5                	mov    %esp,%ebp
80104f3a:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f3d:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104f44:	eb 27                	jmp    80104f6d <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f49:	8b 40 0c             	mov    0xc(%eax),%eax
80104f4c:	83 f8 02             	cmp    $0x2,%eax
80104f4f:	75 15                	jne    80104f66 <wakeup1+0x2f>
80104f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f54:	8b 40 20             	mov    0x20(%eax),%eax
80104f57:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f5a:	75 0a                	jne    80104f66 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f5f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f66:	81 45 fc 90 00 00 00 	addl   $0x90,-0x4(%ebp)
80104f6d:	81 7d fc b4 5d 11 80 	cmpl   $0x80115db4,-0x4(%ebp)
80104f74:	72 d0                	jb     80104f46 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f76:	90                   	nop
80104f77:	c9                   	leave  
80104f78:	c3                   	ret    

80104f79 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f79:	55                   	push   %ebp
80104f7a:	89 e5                	mov    %esp,%ebp
80104f7c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	68 80 39 11 80       	push   $0x80113980
80104f87:	e8 96 04 00 00       	call   80105422 <acquire>
80104f8c:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f8f:	83 ec 0c             	sub    $0xc,%esp
80104f92:	ff 75 08             	pushl  0x8(%ebp)
80104f95:	e8 9d ff ff ff       	call   80104f37 <wakeup1>
80104f9a:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f9d:	83 ec 0c             	sub    $0xc,%esp
80104fa0:	68 80 39 11 80       	push   $0x80113980
80104fa5:	e8 df 04 00 00       	call   80105489 <release>
80104faa:	83 c4 10             	add    $0x10,%esp
}
80104fad:	90                   	nop
80104fae:	c9                   	leave  
80104faf:	c3                   	ret    

80104fb0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104fb6:	83 ec 0c             	sub    $0xc,%esp
80104fb9:	68 80 39 11 80       	push   $0x80113980
80104fbe:	e8 5f 04 00 00       	call   80105422 <acquire>
80104fc3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fc6:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104fcd:	eb 4a                	jmp    80105019 <kill+0x69>
    if(p->pid == pid){
80104fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd2:	8b 50 10             	mov    0x10(%eax),%edx
80104fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd8:	39 c2                	cmp    %eax,%edx
80104fda:	75 36                	jne    80105012 <kill+0x62>
      p->killed = 1;
80104fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fdf:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe9:	8b 40 0c             	mov    0xc(%eax),%eax
80104fec:	83 f8 02             	cmp    $0x2,%eax
80104fef:	75 0a                	jne    80104ffb <kill+0x4b>
        p->state = RUNNABLE;
80104ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104ffb:	83 ec 0c             	sub    $0xc,%esp
80104ffe:	68 80 39 11 80       	push   $0x80113980
80105003:	e8 81 04 00 00       	call   80105489 <release>
80105008:	83 c4 10             	add    $0x10,%esp
      return 0;
8010500b:	b8 00 00 00 00       	mov    $0x0,%eax
80105010:	eb 25                	jmp    80105037 <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105012:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80105019:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
80105020:	72 ad                	jb     80104fcf <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105022:	83 ec 0c             	sub    $0xc,%esp
80105025:	68 80 39 11 80       	push   $0x80113980
8010502a:	e8 5a 04 00 00       	call   80105489 <release>
8010502f:	83 c4 10             	add    $0x10,%esp
  return -1;
80105032:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105037:	c9                   	leave  
80105038:	c3                   	ret    

80105039 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105039:	55                   	push   %ebp
8010503a:	89 e5                	mov    %esp,%ebp
8010503c:	57                   	push   %edi
8010503d:	56                   	push   %esi
8010503e:	53                   	push   %ebx
8010503f:	83 ec 4c             	sub    $0x4c,%esp
  char *state;
  uint pc[10];
  
  uint now;         //Snag the current ticks and cast

  acquire(&tickslock);
80105042:	83 ec 0c             	sub    $0xc,%esp
80105045:	68 c0 5d 11 80       	push   $0x80115dc0
8010504a:	e8 d3 03 00 00       	call   80105422 <acquire>
8010504f:	83 c4 10             	add    $0x10,%esp
  now = (uint)ticks;
80105052:	a1 00 66 11 80       	mov    0x80116600,%eax
80105057:	89 45 d8             	mov    %eax,-0x28(%ebp)
  release(&tickslock);
8010505a:	83 ec 0c             	sub    $0xc,%esp
8010505d:	68 c0 5d 11 80       	push   $0x80115dc0
80105062:	e8 22 04 00 00       	call   80105489 <release>
80105067:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010506a:	c7 45 e0 b4 39 11 80 	movl   $0x801139b4,-0x20(%ebp)
80105071:	e9 4c 01 00 00       	jmp    801051c2 <procdump+0x189>
    if(p->state == UNUSED)
80105076:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105079:	8b 40 0c             	mov    0xc(%eax),%eax
8010507c:	85 c0                	test   %eax,%eax
8010507e:	0f 84 36 01 00 00    	je     801051ba <procdump+0x181>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105084:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105087:	8b 40 0c             	mov    0xc(%eax),%eax
8010508a:	83 f8 05             	cmp    $0x5,%eax
8010508d:	77 23                	ja     801050b2 <procdump+0x79>
8010508f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105092:	8b 40 0c             	mov    0xc(%eax),%eax
80105095:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010509c:	85 c0                	test   %eax,%eax
8010509e:	74 12                	je     801050b2 <procdump+0x79>
      state = states[p->state];
801050a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050a3:	8b 40 0c             	mov    0xc(%eax),%eax
801050a6:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801050ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801050b0:	eb 07                	jmp    801050b9 <procdump+0x80>
    else
      state = "???";
801050b2:	c7 45 dc b4 8e 10 80 	movl   $0x80108eb4,-0x24(%ebp)
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
             p->cpu_ticks_total % 100);
801050b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050bc:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
801050c2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801050c7:	89 c8                	mov    %ecx,%eax
801050c9:	f7 e2                	mul    %edx
801050cb:	89 d3                	mov    %edx,%ebx
801050cd:	c1 eb 05             	shr    $0x5,%ebx
801050d0:	6b c3 64             	imul   $0x64,%ebx,%eax
801050d3:	29 c1                	sub    %eax,%ecx
801050d5:	89 cb                	mov    %ecx,%ebx
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
801050d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050da:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
801050e0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801050e5:	f7 e2                	mul    %edx
801050e7:	89 d7                	mov    %edx,%edi
801050e9:	c1 ef 05             	shr    $0x5,%edi
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
801050ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050ef:	8b 40 7c             	mov    0x7c(%eax),%eax
801050f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
801050f5:	89 d6                	mov    %edx,%esi
801050f7:	29 c6                	sub    %eax,%esi
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
801050f9:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801050fe:	89 f0                	mov    %esi,%eax
80105100:	f7 e2                	mul    %edx
80105102:	89 d1                	mov    %edx,%ecx
80105104:	c1 e9 05             	shr    $0x5,%ecx
80105107:	6b c1 64             	imul   $0x64,%ecx,%eax
8010510a:	29 c6                	sub    %eax,%esi
8010510c:	89 f1                	mov    %esi,%ecx
            (now - p->start_ticks) / 100, 
8010510e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105111:	8b 40 7c             	mov    0x7c(%eax),%eax
80105114:	8b 55 d8             	mov    -0x28(%ebp),%edx
80105117:	29 c2                	sub    %eax,%edx
80105119:	89 d0                	mov    %edx,%eax
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
8010511b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105120:	f7 e2                	mul    %edx
80105122:	89 d6                	mov    %edx,%esi
80105124:	c1 ee 05             	shr    $0x5,%esi
80105127:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010512a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010512d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105130:	8b 40 10             	mov    0x10(%eax),%eax
80105133:	53                   	push   %ebx
80105134:	57                   	push   %edi
80105135:	51                   	push   %ecx
80105136:	56                   	push   %esi
80105137:	52                   	push   %edx
80105138:	ff 75 dc             	pushl  -0x24(%ebp)
8010513b:	50                   	push   %eax
8010513c:	68 b8 8e 10 80       	push   $0x80108eb8
80105141:	e8 80 b2 ff ff       	call   801003c6 <cprintf>
80105146:	83 c4 20             	add    $0x20,%esp
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
             p->cpu_ticks_total % 100);
    if(p->state == SLEEPING){
80105149:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010514c:	8b 40 0c             	mov    0xc(%eax),%eax
8010514f:	83 f8 02             	cmp    $0x2,%eax
80105152:	75 54                	jne    801051a8 <procdump+0x16f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105154:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105157:	8b 40 1c             	mov    0x1c(%eax),%eax
8010515a:	8b 40 0c             	mov    0xc(%eax),%eax
8010515d:	83 c0 08             	add    $0x8,%eax
80105160:	89 c2                	mov    %eax,%edx
80105162:	83 ec 08             	sub    $0x8,%esp
80105165:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105168:	50                   	push   %eax
80105169:	52                   	push   %edx
8010516a:	e8 6c 03 00 00       	call   801054db <getcallerpcs>
8010516f:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105172:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105179:	eb 1c                	jmp    80105197 <procdump+0x15e>
        cprintf(" %p", pc[i]);
8010517b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010517e:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
80105182:	83 ec 08             	sub    $0x8,%esp
80105185:	50                   	push   %eax
80105186:	68 cd 8e 10 80       	push   $0x80108ecd
8010518b:	e8 36 b2 ff ff       	call   801003c6 <cprintf>
80105190:	83 c4 10             	add    $0x10,%esp
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
             p->cpu_ticks_total % 100);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105193:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105197:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
8010519b:	7f 0b                	jg     801051a8 <procdump+0x16f>
8010519d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051a0:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
801051a4:	85 c0                	test   %eax,%eax
801051a6:	75 d3                	jne    8010517b <procdump+0x142>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	68 d1 8e 10 80       	push   $0x80108ed1
801051b0:	e8 11 b2 ff ff       	call   801003c6 <cprintf>
801051b5:	83 c4 10             	add    $0x10,%esp
801051b8:	eb 01                	jmp    801051bb <procdump+0x182>
  now = (uint)ticks;
  release(&tickslock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801051ba:	90                   	nop

  acquire(&tickslock);
  now = (uint)ticks;
  release(&tickslock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051bb:	81 45 e0 90 00 00 00 	addl   $0x90,-0x20(%ebp)
801051c2:	81 7d e0 b4 5d 11 80 	cmpl   $0x80115db4,-0x20(%ebp)
801051c9:	0f 82 a7 fe ff ff    	jb     80105076 <procdump+0x3d>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801051cf:	90                   	nop
801051d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d3:	5b                   	pop    %ebx
801051d4:	5e                   	pop    %esi
801051d5:	5f                   	pop    %edi
801051d6:	5d                   	pop    %ebp
801051d7:	c3                   	ret    

801051d8 <sys_getprocs>:


int
sys_getprocs(void)
{  
801051d8:	55                   	push   %ebp
801051d9:	89 e5                	mov    %esp,%ebp
801051db:	83 ec 28             	sub    $0x28,%esp
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };

  uint now;
  acquire(&tickslock);
801051de:	83 ec 0c             	sub    $0xc,%esp
801051e1:	68 c0 5d 11 80       	push   $0x80115dc0
801051e6:	e8 37 02 00 00       	call   80105422 <acquire>
801051eb:	83 c4 10             	add    $0x10,%esp
  now = (uint)ticks;
801051ee:	a1 00 66 11 80       	mov    0x80116600,%eax
801051f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  release(&tickslock);
801051f6:	83 ec 0c             	sub    $0xc,%esp
801051f9:	68 c0 5d 11 80       	push   $0x80115dc0
801051fe:	e8 86 02 00 00       	call   80105489 <release>
80105203:	83 c4 10             	add    $0x10,%esp


    struct proc* p;
    struct uproc* up;
    int MAX = 0;
80105206:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    int i = 0;
8010520d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    if( argint(0, &MAX) == -1)
80105214:	83 ec 08             	sub    $0x8,%esp
80105217:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010521a:	50                   	push   %eax
8010521b:	6a 00                	push   $0x0
8010521d:	e8 88 07 00 00       	call   801059aa <argint>
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	83 f8 ff             	cmp    $0xffffffff,%eax
80105228:	75 0a                	jne    80105234 <sys_getprocs+0x5c>
        return -1;
8010522a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522f:	e9 92 01 00 00       	jmp    801053c6 <sys_getprocs+0x1ee>

    if(argptr(1, (char**)&up, sizeof(*up)) < 0)
80105234:	83 ec 04             	sub    $0x4,%esp
80105237:	6a 5c                	push   $0x5c
80105239:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010523c:	50                   	push   %eax
8010523d:	6a 01                	push   $0x1
8010523f:	e8 8e 07 00 00       	call   801059d2 <argptr>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	79 0a                	jns    80105255 <sys_getprocs+0x7d>
        return -1;
8010524b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105250:	e9 71 01 00 00       	jmp    801053c6 <sys_getprocs+0x1ee>
 
  acquire(&ptable.lock);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	68 80 39 11 80       	push   $0x80113980
8010525d:	e8 c0 01 00 00       	call   80105422 <acquire>
80105262:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105265:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010526c:	e9 35 01 00 00       	jmp    801053a6 <sys_getprocs+0x1ce>
  {

        if( p->state && i < MAX){ 
80105271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105274:	8b 40 0c             	mov    0xc(%eax),%eax
80105277:	85 c0                	test   %eax,%eax
80105279:	0f 84 20 01 00 00    	je     8010539f <sys_getprocs+0x1c7>
8010527f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105282:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80105285:	0f 8d 14 01 00 00    	jge    8010539f <sys_getprocs+0x1c7>

            up[i].pid = p->pid;
8010528b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010528e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105291:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105294:	01 c2                	add    %eax,%edx
80105296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105299:	8b 40 10             	mov    0x10(%eax),%eax
8010529c:	89 02                	mov    %eax,(%edx)
            up[i].uid = p->uid;
8010529e:	8b 55 e8             	mov    -0x18(%ebp),%edx
801052a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052a4:	6b c0 5c             	imul   $0x5c,%eax,%eax
801052a7:	01 c2                	add    %eax,%edx
801052a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ac:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801052b2:	89 42 04             	mov    %eax,0x4(%edx)
            up[i].gid = p->gid;
801052b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
801052b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052bb:	6b c0 5c             	imul   $0x5c,%eax,%eax
801052be:	01 c2                	add    %eax,%edx
801052c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801052c9:	89 42 08             	mov    %eax,0x8(%edx)
            up[i].CPU_total_ticks = p->cpu_ticks_total;
801052cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
801052cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052d2:	6b c0 5c             	imul   $0x5c,%eax,%eax
801052d5:	01 c2                	add    %eax,%edx
801052d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052da:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801052e0:	89 42 14             	mov    %eax,0x14(%edx)
            up[i].elapsed_ticks = now - p->start_ticks;
801052e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801052e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e9:	6b c0 5c             	imul   $0x5c,%eax,%eax
801052ec:	01 c2                	add    %eax,%edx
801052ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f1:	8b 40 7c             	mov    0x7c(%eax),%eax
801052f4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801052f7:	29 c1                	sub    %eax,%ecx
801052f9:	89 c8                	mov    %ecx,%eax
801052fb:	89 42 10             	mov    %eax,0x10(%edx)
            up[i].size = p->sz;
801052fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105301:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105304:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105307:	01 c2                	add    %eax,%edx
80105309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010530c:	8b 00                	mov    (%eax),%eax
8010530e:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(up[i].name, p->name, sizeof(p->name));
80105311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105314:	8d 50 6c             	lea    0x6c(%eax),%edx
80105317:	8b 4d e8             	mov    -0x18(%ebp),%ecx
8010531a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010531d:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105320:	01 c8                	add    %ecx,%eax
80105322:	83 c0 3c             	add    $0x3c,%eax
80105325:	83 ec 04             	sub    $0x4,%esp
80105328:	6a 10                	push   $0x10
8010532a:	52                   	push   %edx
8010532b:	50                   	push   %eax
8010532c:	e8 57 05 00 00       	call   80105888 <safestrcpy>
80105331:	83 c4 10             	add    $0x10,%esp
            safestrcpy(up[i].state, states[p->state], sizeof(p->state));
80105334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105337:	8b 40 0c             	mov    0xc(%eax),%eax
8010533a:	8b 04 85 24 c0 10 80 	mov    -0x7fef3fdc(,%eax,4),%eax
80105341:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80105344:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105347:	6b d2 5c             	imul   $0x5c,%edx,%edx
8010534a:	01 ca                	add    %ecx,%edx
8010534c:	83 c2 18             	add    $0x18,%edx
8010534f:	83 ec 04             	sub    $0x4,%esp
80105352:	6a 04                	push   $0x4
80105354:	50                   	push   %eax
80105355:	52                   	push   %edx
80105356:	e8 2d 05 00 00       	call   80105888 <safestrcpy>
8010535b:	83 c4 10             	add    $0x10,%esp
            if(up[i].pid == 1)
8010535e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105361:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105364:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105367:	01 d0                	add    %edx,%eax
80105369:	8b 00                	mov    (%eax),%eax
8010536b:	83 f8 01             	cmp    $0x1,%eax
8010536e:	75 14                	jne    80105384 <sys_getprocs+0x1ac>
                up[i].ppid = 1;
80105370:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105376:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105379:	01 d0                	add    %edx,%eax
8010537b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105382:	eb 17                	jmp    8010539b <sys_getprocs+0x1c3>
            else
                up[i].ppid = p->parent->pid;
80105384:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538a:	6b c0 5c             	imul   $0x5c,%eax,%eax
8010538d:	01 c2                	add    %eax,%edx
8010538f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105392:	8b 40 14             	mov    0x14(%eax),%eax
80105395:	8b 40 10             	mov    0x10(%eax),%eax
80105398:	89 42 0c             	mov    %eax,0xc(%edx)
            i++;
8010539b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(argptr(1, (char**)&up, sizeof(*up)) < 0)
        return -1;
 
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010539f:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801053a6:	81 7d f4 b4 5d 11 80 	cmpl   $0x80115db4,-0xc(%ebp)
801053ad:	0f 82 be fe ff ff    	jb     80105271 <sys_getprocs+0x99>
            else
                up[i].ppid = p->parent->pid;
            i++;
        }
  }
  release(&ptable.lock);
801053b3:	83 ec 0c             	sub    $0xc,%esp
801053b6:	68 80 39 11 80       	push   $0x80113980
801053bb:	e8 c9 00 00 00       	call   80105489 <release>
801053c0:	83 c4 10             	add    $0x10,%esp
  return i;
801053c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801053c6:	c9                   	leave  
801053c7:	c3                   	ret    

801053c8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801053c8:	55                   	push   %ebp
801053c9:	89 e5                	mov    %esp,%ebp
801053cb:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801053ce:	9c                   	pushf  
801053cf:	58                   	pop    %eax
801053d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801053d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053d6:	c9                   	leave  
801053d7:	c3                   	ret    

801053d8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801053d8:	55                   	push   %ebp
801053d9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801053db:	fa                   	cli    
}
801053dc:	90                   	nop
801053dd:	5d                   	pop    %ebp
801053de:	c3                   	ret    

801053df <sti>:

static inline void
sti(void)
{
801053df:	55                   	push   %ebp
801053e0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801053e2:	fb                   	sti    
}
801053e3:	90                   	nop
801053e4:	5d                   	pop    %ebp
801053e5:	c3                   	ret    

801053e6 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801053e6:	55                   	push   %ebp
801053e7:	89 e5                	mov    %esp,%ebp
801053e9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801053ec:	8b 55 08             	mov    0x8(%ebp),%edx
801053ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053f5:	f0 87 02             	lock xchg %eax,(%edx)
801053f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801053fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053fe:	c9                   	leave  
801053ff:	c3                   	ret    

80105400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105403:	8b 45 08             	mov    0x8(%ebp),%eax
80105406:	8b 55 0c             	mov    0xc(%ebp),%edx
80105409:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010540c:	8b 45 08             	mov    0x8(%ebp),%eax
8010540f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010541f:	90                   	nop
80105420:	5d                   	pop    %ebp
80105421:	c3                   	ret    

80105422 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105422:	55                   	push   %ebp
80105423:	89 e5                	mov    %esp,%ebp
80105425:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105428:	e8 52 01 00 00       	call   8010557f <pushcli>
  if(holding(lk))
8010542d:	8b 45 08             	mov    0x8(%ebp),%eax
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	50                   	push   %eax
80105434:	e8 1c 01 00 00       	call   80105555 <holding>
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	85 c0                	test   %eax,%eax
8010543e:	74 0d                	je     8010544d <acquire+0x2b>
    panic("acquire");
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	68 fd 8e 10 80       	push   $0x80108efd
80105448:	e8 19 b1 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010544d:	90                   	nop
8010544e:	8b 45 08             	mov    0x8(%ebp),%eax
80105451:	83 ec 08             	sub    $0x8,%esp
80105454:	6a 01                	push   $0x1
80105456:	50                   	push   %eax
80105457:	e8 8a ff ff ff       	call   801053e6 <xchg>
8010545c:	83 c4 10             	add    $0x10,%esp
8010545f:	85 c0                	test   %eax,%eax
80105461:	75 eb                	jne    8010544e <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105463:	8b 45 08             	mov    0x8(%ebp),%eax
80105466:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010546d:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105470:	8b 45 08             	mov    0x8(%ebp),%eax
80105473:	83 c0 0c             	add    $0xc,%eax
80105476:	83 ec 08             	sub    $0x8,%esp
80105479:	50                   	push   %eax
8010547a:	8d 45 08             	lea    0x8(%ebp),%eax
8010547d:	50                   	push   %eax
8010547e:	e8 58 00 00 00       	call   801054db <getcallerpcs>
80105483:	83 c4 10             	add    $0x10,%esp
}
80105486:	90                   	nop
80105487:	c9                   	leave  
80105488:	c3                   	ret    

80105489 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105489:	55                   	push   %ebp
8010548a:	89 e5                	mov    %esp,%ebp
8010548c:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010548f:	83 ec 0c             	sub    $0xc,%esp
80105492:	ff 75 08             	pushl  0x8(%ebp)
80105495:	e8 bb 00 00 00       	call   80105555 <holding>
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	85 c0                	test   %eax,%eax
8010549f:	75 0d                	jne    801054ae <release+0x25>
    panic("release");
801054a1:	83 ec 0c             	sub    $0xc,%esp
801054a4:	68 05 8f 10 80       	push   $0x80108f05
801054a9:	e8 b8 b0 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801054ae:	8b 45 08             	mov    0x8(%ebp),%eax
801054b1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801054b8:	8b 45 08             	mov    0x8(%ebp),%eax
801054bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801054c2:	8b 45 08             	mov    0x8(%ebp),%eax
801054c5:	83 ec 08             	sub    $0x8,%esp
801054c8:	6a 00                	push   $0x0
801054ca:	50                   	push   %eax
801054cb:	e8 16 ff ff ff       	call   801053e6 <xchg>
801054d0:	83 c4 10             	add    $0x10,%esp

  popcli();
801054d3:	e8 ec 00 00 00       	call   801055c4 <popcli>
}
801054d8:	90                   	nop
801054d9:	c9                   	leave  
801054da:	c3                   	ret    

801054db <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801054db:	55                   	push   %ebp
801054dc:	89 e5                	mov    %esp,%ebp
801054de:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801054e1:	8b 45 08             	mov    0x8(%ebp),%eax
801054e4:	83 e8 08             	sub    $0x8,%eax
801054e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801054ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801054f1:	eb 38                	jmp    8010552b <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801054f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801054f7:	74 53                	je     8010554c <getcallerpcs+0x71>
801054f9:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105500:	76 4a                	jbe    8010554c <getcallerpcs+0x71>
80105502:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105506:	74 44                	je     8010554c <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105508:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010550b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105512:	8b 45 0c             	mov    0xc(%ebp),%eax
80105515:	01 c2                	add    %eax,%edx
80105517:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010551a:	8b 40 04             	mov    0x4(%eax),%eax
8010551d:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010551f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105522:	8b 00                	mov    (%eax),%eax
80105524:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105527:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010552b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010552f:	7e c2                	jle    801054f3 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105531:	eb 19                	jmp    8010554c <getcallerpcs+0x71>
    pcs[i] = 0;
80105533:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105536:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010553d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105540:	01 d0                	add    %edx,%eax
80105542:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105548:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010554c:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105550:	7e e1                	jle    80105533 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105552:	90                   	nop
80105553:	c9                   	leave  
80105554:	c3                   	ret    

80105555 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105555:	55                   	push   %ebp
80105556:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105558:	8b 45 08             	mov    0x8(%ebp),%eax
8010555b:	8b 00                	mov    (%eax),%eax
8010555d:	85 c0                	test   %eax,%eax
8010555f:	74 17                	je     80105578 <holding+0x23>
80105561:	8b 45 08             	mov    0x8(%ebp),%eax
80105564:	8b 50 08             	mov    0x8(%eax),%edx
80105567:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010556d:	39 c2                	cmp    %eax,%edx
8010556f:	75 07                	jne    80105578 <holding+0x23>
80105571:	b8 01 00 00 00       	mov    $0x1,%eax
80105576:	eb 05                	jmp    8010557d <holding+0x28>
80105578:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010557d:	5d                   	pop    %ebp
8010557e:	c3                   	ret    

8010557f <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010557f:	55                   	push   %ebp
80105580:	89 e5                	mov    %esp,%ebp
80105582:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105585:	e8 3e fe ff ff       	call   801053c8 <readeflags>
8010558a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010558d:	e8 46 fe ff ff       	call   801053d8 <cli>
  if(cpu->ncli++ == 0)
80105592:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105599:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010559f:	8d 48 01             	lea    0x1(%eax),%ecx
801055a2:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801055a8:	85 c0                	test   %eax,%eax
801055aa:	75 15                	jne    801055c1 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801055ac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055b5:	81 e2 00 02 00 00    	and    $0x200,%edx
801055bb:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801055c1:	90                   	nop
801055c2:	c9                   	leave  
801055c3:	c3                   	ret    

801055c4 <popcli>:

void
popcli(void)
{
801055c4:	55                   	push   %ebp
801055c5:	89 e5                	mov    %esp,%ebp
801055c7:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801055ca:	e8 f9 fd ff ff       	call   801053c8 <readeflags>
801055cf:	25 00 02 00 00       	and    $0x200,%eax
801055d4:	85 c0                	test   %eax,%eax
801055d6:	74 0d                	je     801055e5 <popcli+0x21>
    panic("popcli - interruptible");
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	68 0d 8f 10 80       	push   $0x80108f0d
801055e0:	e8 81 af ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801055e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055eb:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801055f1:	83 ea 01             	sub    $0x1,%edx
801055f4:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801055fa:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105600:	85 c0                	test   %eax,%eax
80105602:	79 0d                	jns    80105611 <popcli+0x4d>
    panic("popcli");
80105604:	83 ec 0c             	sub    $0xc,%esp
80105607:	68 24 8f 10 80       	push   $0x80108f24
8010560c:	e8 55 af ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105611:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105617:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010561d:	85 c0                	test   %eax,%eax
8010561f:	75 15                	jne    80105636 <popcli+0x72>
80105621:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105627:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010562d:	85 c0                	test   %eax,%eax
8010562f:	74 05                	je     80105636 <popcli+0x72>
    sti();
80105631:	e8 a9 fd ff ff       	call   801053df <sti>
}
80105636:	90                   	nop
80105637:	c9                   	leave  
80105638:	c3                   	ret    

80105639 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105639:	55                   	push   %ebp
8010563a:	89 e5                	mov    %esp,%ebp
8010563c:	57                   	push   %edi
8010563d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010563e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105641:	8b 55 10             	mov    0x10(%ebp),%edx
80105644:	8b 45 0c             	mov    0xc(%ebp),%eax
80105647:	89 cb                	mov    %ecx,%ebx
80105649:	89 df                	mov    %ebx,%edi
8010564b:	89 d1                	mov    %edx,%ecx
8010564d:	fc                   	cld    
8010564e:	f3 aa                	rep stos %al,%es:(%edi)
80105650:	89 ca                	mov    %ecx,%edx
80105652:	89 fb                	mov    %edi,%ebx
80105654:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105657:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010565a:	90                   	nop
8010565b:	5b                   	pop    %ebx
8010565c:	5f                   	pop    %edi
8010565d:	5d                   	pop    %ebp
8010565e:	c3                   	ret    

8010565f <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010565f:	55                   	push   %ebp
80105660:	89 e5                	mov    %esp,%ebp
80105662:	57                   	push   %edi
80105663:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105664:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105667:	8b 55 10             	mov    0x10(%ebp),%edx
8010566a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010566d:	89 cb                	mov    %ecx,%ebx
8010566f:	89 df                	mov    %ebx,%edi
80105671:	89 d1                	mov    %edx,%ecx
80105673:	fc                   	cld    
80105674:	f3 ab                	rep stos %eax,%es:(%edi)
80105676:	89 ca                	mov    %ecx,%edx
80105678:	89 fb                	mov    %edi,%ebx
8010567a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010567d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105680:	90                   	nop
80105681:	5b                   	pop    %ebx
80105682:	5f                   	pop    %edi
80105683:	5d                   	pop    %ebp
80105684:	c3                   	ret    

80105685 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105685:	55                   	push   %ebp
80105686:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105688:	8b 45 08             	mov    0x8(%ebp),%eax
8010568b:	83 e0 03             	and    $0x3,%eax
8010568e:	85 c0                	test   %eax,%eax
80105690:	75 43                	jne    801056d5 <memset+0x50>
80105692:	8b 45 10             	mov    0x10(%ebp),%eax
80105695:	83 e0 03             	and    $0x3,%eax
80105698:	85 c0                	test   %eax,%eax
8010569a:	75 39                	jne    801056d5 <memset+0x50>
    c &= 0xFF;
8010569c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801056a3:	8b 45 10             	mov    0x10(%ebp),%eax
801056a6:	c1 e8 02             	shr    $0x2,%eax
801056a9:	89 c1                	mov    %eax,%ecx
801056ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ae:	c1 e0 18             	shl    $0x18,%eax
801056b1:	89 c2                	mov    %eax,%edx
801056b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b6:	c1 e0 10             	shl    $0x10,%eax
801056b9:	09 c2                	or     %eax,%edx
801056bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801056be:	c1 e0 08             	shl    $0x8,%eax
801056c1:	09 d0                	or     %edx,%eax
801056c3:	0b 45 0c             	or     0xc(%ebp),%eax
801056c6:	51                   	push   %ecx
801056c7:	50                   	push   %eax
801056c8:	ff 75 08             	pushl  0x8(%ebp)
801056cb:	e8 8f ff ff ff       	call   8010565f <stosl>
801056d0:	83 c4 0c             	add    $0xc,%esp
801056d3:	eb 12                	jmp    801056e7 <memset+0x62>
  } else
    stosb(dst, c, n);
801056d5:	8b 45 10             	mov    0x10(%ebp),%eax
801056d8:	50                   	push   %eax
801056d9:	ff 75 0c             	pushl  0xc(%ebp)
801056dc:	ff 75 08             	pushl  0x8(%ebp)
801056df:	e8 55 ff ff ff       	call   80105639 <stosb>
801056e4:	83 c4 0c             	add    $0xc,%esp
  return dst;
801056e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    

801056ec <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801056ec:	55                   	push   %ebp
801056ed:	89 e5                	mov    %esp,%ebp
801056ef:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801056f2:	8b 45 08             	mov    0x8(%ebp),%eax
801056f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801056f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801056fe:	eb 30                	jmp    80105730 <memcmp+0x44>
    if(*s1 != *s2)
80105700:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105703:	0f b6 10             	movzbl (%eax),%edx
80105706:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105709:	0f b6 00             	movzbl (%eax),%eax
8010570c:	38 c2                	cmp    %al,%dl
8010570e:	74 18                	je     80105728 <memcmp+0x3c>
      return *s1 - *s2;
80105710:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105713:	0f b6 00             	movzbl (%eax),%eax
80105716:	0f b6 d0             	movzbl %al,%edx
80105719:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010571c:	0f b6 00             	movzbl (%eax),%eax
8010571f:	0f b6 c0             	movzbl %al,%eax
80105722:	29 c2                	sub    %eax,%edx
80105724:	89 d0                	mov    %edx,%eax
80105726:	eb 1a                	jmp    80105742 <memcmp+0x56>
    s1++, s2++;
80105728:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010572c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105730:	8b 45 10             	mov    0x10(%ebp),%eax
80105733:	8d 50 ff             	lea    -0x1(%eax),%edx
80105736:	89 55 10             	mov    %edx,0x10(%ebp)
80105739:	85 c0                	test   %eax,%eax
8010573b:	75 c3                	jne    80105700 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010573d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105742:	c9                   	leave  
80105743:	c3                   	ret    

80105744 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010574a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105750:	8b 45 08             	mov    0x8(%ebp),%eax
80105753:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105756:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105759:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010575c:	73 54                	jae    801057b2 <memmove+0x6e>
8010575e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105761:	8b 45 10             	mov    0x10(%ebp),%eax
80105764:	01 d0                	add    %edx,%eax
80105766:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105769:	76 47                	jbe    801057b2 <memmove+0x6e>
    s += n;
8010576b:	8b 45 10             	mov    0x10(%ebp),%eax
8010576e:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105771:	8b 45 10             	mov    0x10(%ebp),%eax
80105774:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105777:	eb 13                	jmp    8010578c <memmove+0x48>
      *--d = *--s;
80105779:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010577d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105781:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105784:	0f b6 10             	movzbl (%eax),%edx
80105787:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010578a:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010578c:	8b 45 10             	mov    0x10(%ebp),%eax
8010578f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105792:	89 55 10             	mov    %edx,0x10(%ebp)
80105795:	85 c0                	test   %eax,%eax
80105797:	75 e0                	jne    80105779 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105799:	eb 24                	jmp    801057bf <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010579b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010579e:	8d 50 01             	lea    0x1(%eax),%edx
801057a1:	89 55 f8             	mov    %edx,-0x8(%ebp)
801057a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057a7:	8d 4a 01             	lea    0x1(%edx),%ecx
801057aa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801057ad:	0f b6 12             	movzbl (%edx),%edx
801057b0:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801057b2:	8b 45 10             	mov    0x10(%ebp),%eax
801057b5:	8d 50 ff             	lea    -0x1(%eax),%edx
801057b8:	89 55 10             	mov    %edx,0x10(%ebp)
801057bb:	85 c0                	test   %eax,%eax
801057bd:	75 dc                	jne    8010579b <memmove+0x57>
      *d++ = *s++;

  return dst;
801057bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801057c2:	c9                   	leave  
801057c3:	c3                   	ret    

801057c4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801057c7:	ff 75 10             	pushl  0x10(%ebp)
801057ca:	ff 75 0c             	pushl  0xc(%ebp)
801057cd:	ff 75 08             	pushl  0x8(%ebp)
801057d0:	e8 6f ff ff ff       	call   80105744 <memmove>
801057d5:	83 c4 0c             	add    $0xc,%esp
}
801057d8:	c9                   	leave  
801057d9:	c3                   	ret    

801057da <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801057da:	55                   	push   %ebp
801057db:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801057dd:	eb 0c                	jmp    801057eb <strncmp+0x11>
    n--, p++, q++;
801057df:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801057e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801057e7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801057eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057ef:	74 1a                	je     8010580b <strncmp+0x31>
801057f1:	8b 45 08             	mov    0x8(%ebp),%eax
801057f4:	0f b6 00             	movzbl (%eax),%eax
801057f7:	84 c0                	test   %al,%al
801057f9:	74 10                	je     8010580b <strncmp+0x31>
801057fb:	8b 45 08             	mov    0x8(%ebp),%eax
801057fe:	0f b6 10             	movzbl (%eax),%edx
80105801:	8b 45 0c             	mov    0xc(%ebp),%eax
80105804:	0f b6 00             	movzbl (%eax),%eax
80105807:	38 c2                	cmp    %al,%dl
80105809:	74 d4                	je     801057df <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010580b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010580f:	75 07                	jne    80105818 <strncmp+0x3e>
    return 0;
80105811:	b8 00 00 00 00       	mov    $0x0,%eax
80105816:	eb 16                	jmp    8010582e <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105818:	8b 45 08             	mov    0x8(%ebp),%eax
8010581b:	0f b6 00             	movzbl (%eax),%eax
8010581e:	0f b6 d0             	movzbl %al,%edx
80105821:	8b 45 0c             	mov    0xc(%ebp),%eax
80105824:	0f b6 00             	movzbl (%eax),%eax
80105827:	0f b6 c0             	movzbl %al,%eax
8010582a:	29 c2                	sub    %eax,%edx
8010582c:	89 d0                	mov    %edx,%eax
}
8010582e:	5d                   	pop    %ebp
8010582f:	c3                   	ret    

80105830 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105836:	8b 45 08             	mov    0x8(%ebp),%eax
80105839:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010583c:	90                   	nop
8010583d:	8b 45 10             	mov    0x10(%ebp),%eax
80105840:	8d 50 ff             	lea    -0x1(%eax),%edx
80105843:	89 55 10             	mov    %edx,0x10(%ebp)
80105846:	85 c0                	test   %eax,%eax
80105848:	7e 2c                	jle    80105876 <strncpy+0x46>
8010584a:	8b 45 08             	mov    0x8(%ebp),%eax
8010584d:	8d 50 01             	lea    0x1(%eax),%edx
80105850:	89 55 08             	mov    %edx,0x8(%ebp)
80105853:	8b 55 0c             	mov    0xc(%ebp),%edx
80105856:	8d 4a 01             	lea    0x1(%edx),%ecx
80105859:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010585c:	0f b6 12             	movzbl (%edx),%edx
8010585f:	88 10                	mov    %dl,(%eax)
80105861:	0f b6 00             	movzbl (%eax),%eax
80105864:	84 c0                	test   %al,%al
80105866:	75 d5                	jne    8010583d <strncpy+0xd>
    ;
  while(n-- > 0)
80105868:	eb 0c                	jmp    80105876 <strncpy+0x46>
    *s++ = 0;
8010586a:	8b 45 08             	mov    0x8(%ebp),%eax
8010586d:	8d 50 01             	lea    0x1(%eax),%edx
80105870:	89 55 08             	mov    %edx,0x8(%ebp)
80105873:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105876:	8b 45 10             	mov    0x10(%ebp),%eax
80105879:	8d 50 ff             	lea    -0x1(%eax),%edx
8010587c:	89 55 10             	mov    %edx,0x10(%ebp)
8010587f:	85 c0                	test   %eax,%eax
80105881:	7f e7                	jg     8010586a <strncpy+0x3a>
    *s++ = 0;
  return os;
80105883:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105886:	c9                   	leave  
80105887:	c3                   	ret    

80105888 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105888:	55                   	push   %ebp
80105889:	89 e5                	mov    %esp,%ebp
8010588b:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010588e:	8b 45 08             	mov    0x8(%ebp),%eax
80105891:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105894:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105898:	7f 05                	jg     8010589f <safestrcpy+0x17>
    return os;
8010589a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010589d:	eb 31                	jmp    801058d0 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010589f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058a7:	7e 1e                	jle    801058c7 <safestrcpy+0x3f>
801058a9:	8b 45 08             	mov    0x8(%ebp),%eax
801058ac:	8d 50 01             	lea    0x1(%eax),%edx
801058af:	89 55 08             	mov    %edx,0x8(%ebp)
801058b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801058b5:	8d 4a 01             	lea    0x1(%edx),%ecx
801058b8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801058bb:	0f b6 12             	movzbl (%edx),%edx
801058be:	88 10                	mov    %dl,(%eax)
801058c0:	0f b6 00             	movzbl (%eax),%eax
801058c3:	84 c0                	test   %al,%al
801058c5:	75 d8                	jne    8010589f <safestrcpy+0x17>
    ;
  *s = 0;
801058c7:	8b 45 08             	mov    0x8(%ebp),%eax
801058ca:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801058cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058d0:	c9                   	leave  
801058d1:	c3                   	ret    

801058d2 <strlen>:

int
strlen(const char *s)
{
801058d2:	55                   	push   %ebp
801058d3:	89 e5                	mov    %esp,%ebp
801058d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801058d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801058df:	eb 04                	jmp    801058e5 <strlen+0x13>
801058e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058e8:	8b 45 08             	mov    0x8(%ebp),%eax
801058eb:	01 d0                	add    %edx,%eax
801058ed:	0f b6 00             	movzbl (%eax),%eax
801058f0:	84 c0                	test   %al,%al
801058f2:	75 ed                	jne    801058e1 <strlen+0xf>
    ;
  return n;
801058f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058f7:	c9                   	leave  
801058f8:	c3                   	ret    

801058f9 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801058f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801058fd:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105901:	55                   	push   %ebp
  pushl %ebx
80105902:	53                   	push   %ebx
  pushl %esi
80105903:	56                   	push   %esi
  pushl %edi
80105904:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105905:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105907:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105909:	5f                   	pop    %edi
  popl %esi
8010590a:	5e                   	pop    %esi
  popl %ebx
8010590b:	5b                   	pop    %ebx
  popl %ebp
8010590c:	5d                   	pop    %ebp
  ret
8010590d:	c3                   	ret    

8010590e <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010590e:	55                   	push   %ebp
8010590f:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105911:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105917:	8b 00                	mov    (%eax),%eax
80105919:	3b 45 08             	cmp    0x8(%ebp),%eax
8010591c:	76 12                	jbe    80105930 <fetchint+0x22>
8010591e:	8b 45 08             	mov    0x8(%ebp),%eax
80105921:	8d 50 04             	lea    0x4(%eax),%edx
80105924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010592a:	8b 00                	mov    (%eax),%eax
8010592c:	39 c2                	cmp    %eax,%edx
8010592e:	76 07                	jbe    80105937 <fetchint+0x29>
    return -1;
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105935:	eb 0f                	jmp    80105946 <fetchint+0x38>
  *ip = *(int*)(addr);
80105937:	8b 45 08             	mov    0x8(%ebp),%eax
8010593a:	8b 10                	mov    (%eax),%edx
8010593c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010593f:	89 10                	mov    %edx,(%eax)
  return 0;
80105941:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105946:	5d                   	pop    %ebp
80105947:	c3                   	ret    

80105948 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105948:	55                   	push   %ebp
80105949:	89 e5                	mov    %esp,%ebp
8010594b:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010594e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105954:	8b 00                	mov    (%eax),%eax
80105956:	3b 45 08             	cmp    0x8(%ebp),%eax
80105959:	77 07                	ja     80105962 <fetchstr+0x1a>
    return -1;
8010595b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105960:	eb 46                	jmp    801059a8 <fetchstr+0x60>
  *pp = (char*)addr;
80105962:	8b 55 08             	mov    0x8(%ebp),%edx
80105965:	8b 45 0c             	mov    0xc(%ebp),%eax
80105968:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010596a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105970:	8b 00                	mov    (%eax),%eax
80105972:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105975:	8b 45 0c             	mov    0xc(%ebp),%eax
80105978:	8b 00                	mov    (%eax),%eax
8010597a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010597d:	eb 1c                	jmp    8010599b <fetchstr+0x53>
    if(*s == 0)
8010597f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105982:	0f b6 00             	movzbl (%eax),%eax
80105985:	84 c0                	test   %al,%al
80105987:	75 0e                	jne    80105997 <fetchstr+0x4f>
      return s - *pp;
80105989:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010598c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010598f:	8b 00                	mov    (%eax),%eax
80105991:	29 c2                	sub    %eax,%edx
80105993:	89 d0                	mov    %edx,%eax
80105995:	eb 11                	jmp    801059a8 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105997:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010599b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010599e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801059a1:	72 dc                	jb     8010597f <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801059a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a8:	c9                   	leave  
801059a9:	c3                   	ret    

801059aa <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801059aa:	55                   	push   %ebp
801059ab:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801059ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b3:	8b 40 18             	mov    0x18(%eax),%eax
801059b6:	8b 40 44             	mov    0x44(%eax),%eax
801059b9:	8b 55 08             	mov    0x8(%ebp),%edx
801059bc:	c1 e2 02             	shl    $0x2,%edx
801059bf:	01 d0                	add    %edx,%eax
801059c1:	83 c0 04             	add    $0x4,%eax
801059c4:	ff 75 0c             	pushl  0xc(%ebp)
801059c7:	50                   	push   %eax
801059c8:	e8 41 ff ff ff       	call   8010590e <fetchint>
801059cd:	83 c4 08             	add    $0x8,%esp
}
801059d0:	c9                   	leave  
801059d1:	c3                   	ret    

801059d2 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801059d2:	55                   	push   %ebp
801059d3:	89 e5                	mov    %esp,%ebp
801059d5:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801059d8:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059db:	50                   	push   %eax
801059dc:	ff 75 08             	pushl  0x8(%ebp)
801059df:	e8 c6 ff ff ff       	call   801059aa <argint>
801059e4:	83 c4 08             	add    $0x8,%esp
801059e7:	85 c0                	test   %eax,%eax
801059e9:	79 07                	jns    801059f2 <argptr+0x20>
    return -1;
801059eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f0:	eb 3b                	jmp    80105a2d <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801059f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f8:	8b 00                	mov    (%eax),%eax
801059fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059fd:	39 d0                	cmp    %edx,%eax
801059ff:	76 16                	jbe    80105a17 <argptr+0x45>
80105a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a04:	89 c2                	mov    %eax,%edx
80105a06:	8b 45 10             	mov    0x10(%ebp),%eax
80105a09:	01 c2                	add    %eax,%edx
80105a0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a11:	8b 00                	mov    (%eax),%eax
80105a13:	39 c2                	cmp    %eax,%edx
80105a15:	76 07                	jbe    80105a1e <argptr+0x4c>
    return -1;
80105a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1c:	eb 0f                	jmp    80105a2d <argptr+0x5b>
  *pp = (char*)i;
80105a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a21:	89 c2                	mov    %eax,%edx
80105a23:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a26:	89 10                	mov    %edx,(%eax)
  return 0;
80105a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a2d:	c9                   	leave  
80105a2e:	c3                   	ret    

80105a2f <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105a2f:	55                   	push   %ebp
80105a30:	89 e5                	mov    %esp,%ebp
80105a32:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105a35:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105a38:	50                   	push   %eax
80105a39:	ff 75 08             	pushl  0x8(%ebp)
80105a3c:	e8 69 ff ff ff       	call   801059aa <argint>
80105a41:	83 c4 08             	add    $0x8,%esp
80105a44:	85 c0                	test   %eax,%eax
80105a46:	79 07                	jns    80105a4f <argstr+0x20>
    return -1;
80105a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4d:	eb 0f                	jmp    80105a5e <argstr+0x2f>
  return fetchstr(addr, pp);
80105a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a52:	ff 75 0c             	pushl  0xc(%ebp)
80105a55:	50                   	push   %eax
80105a56:	e8 ed fe ff ff       	call   80105948 <fetchstr>
80105a5b:	83 c4 08             	add    $0x8,%esp
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <syscall>:
#endif


void
syscall(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
80105a64:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105a67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a6d:	8b 40 18             	mov    0x18(%eax),%eax
80105a70:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a7a:	7e 30                	jle    80105aac <syscall+0x4c>
80105a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7f:	83 f8 1d             	cmp    $0x1d,%eax
80105a82:	77 28                	ja     80105aac <syscall+0x4c>
80105a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a87:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	74 1a                	je     80105aac <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105a92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a98:	8b 58 18             	mov    0x18(%eax),%ebx
80105a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9e:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105aa5:	ff d0                	call   *%eax
80105aa7:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105aaa:	eb 34                	jmp    80105ae0 <syscall+0x80>
    cprintf("\n \t \t \t  %s -> %d \n", sysname[num], proc->tf->eax );
    #endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105aac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ab2:	8d 50 6c             	lea    0x6c(%eax),%edx
80105ab5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    #ifdef PRINT_SYSCALLS
    cprintf("\n \t \t \t  %s -> %d \n", sysname[num], proc->tf->eax );
    #endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105abb:	8b 40 10             	mov    0x10(%eax),%eax
80105abe:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac1:	52                   	push   %edx
80105ac2:	50                   	push   %eax
80105ac3:	68 2b 8f 10 80       	push   $0x80108f2b
80105ac8:	e8 f9 a8 ff ff       	call   801003c6 <cprintf>
80105acd:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105ad0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ad6:	8b 40 18             	mov    0x18(%eax),%eax
80105ad9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105ae0:	90                   	nop
80105ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae4:	c9                   	leave  
80105ae5:	c3                   	ret    

80105ae6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105ae6:	55                   	push   %ebp
80105ae7:	89 e5                	mov    %esp,%ebp
80105ae9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105aec:	83 ec 08             	sub    $0x8,%esp
80105aef:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105af2:	50                   	push   %eax
80105af3:	ff 75 08             	pushl  0x8(%ebp)
80105af6:	e8 af fe ff ff       	call   801059aa <argint>
80105afb:	83 c4 10             	add    $0x10,%esp
80105afe:	85 c0                	test   %eax,%eax
80105b00:	79 07                	jns    80105b09 <argfd+0x23>
    return -1;
80105b02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b07:	eb 50                	jmp    80105b59 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b0c:	85 c0                	test   %eax,%eax
80105b0e:	78 21                	js     80105b31 <argfd+0x4b>
80105b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b13:	83 f8 0f             	cmp    $0xf,%eax
80105b16:	7f 19                	jg     80105b31 <argfd+0x4b>
80105b18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b21:	83 c2 08             	add    $0x8,%edx
80105b24:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b2f:	75 07                	jne    80105b38 <argfd+0x52>
    return -1;
80105b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b36:	eb 21                	jmp    80105b59 <argfd+0x73>
  if(pfd)
80105b38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105b3c:	74 08                	je     80105b46 <argfd+0x60>
    *pfd = fd;
80105b3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b41:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b44:	89 10                	mov    %edx,(%eax)
  if(pf)
80105b46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b4a:	74 08                	je     80105b54 <argfd+0x6e>
    *pf = f;
80105b4c:	8b 45 10             	mov    0x10(%ebp),%eax
80105b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b52:	89 10                	mov    %edx,(%eax)
  return 0;
80105b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b59:	c9                   	leave  
80105b5a:	c3                   	ret    

80105b5b <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105b5b:	55                   	push   %ebp
80105b5c:	89 e5                	mov    %esp,%ebp
80105b5e:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b68:	eb 30                	jmp    80105b9a <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105b6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b70:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b73:	83 c2 08             	add    $0x8,%edx
80105b76:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b7a:	85 c0                	test   %eax,%eax
80105b7c:	75 18                	jne    80105b96 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105b7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b84:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b87:	8d 4a 08             	lea    0x8(%edx),%ecx
80105b8a:	8b 55 08             	mov    0x8(%ebp),%edx
80105b8d:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b94:	eb 0f                	jmp    80105ba5 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b96:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b9a:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105b9e:	7e ca                	jle    80105b6a <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba5:	c9                   	leave  
80105ba6:	c3                   	ret    

80105ba7 <sys_dup>:

int
sys_dup(void)
{
80105ba7:	55                   	push   %ebp
80105ba8:	89 e5                	mov    %esp,%ebp
80105baa:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105bad:	83 ec 04             	sub    $0x4,%esp
80105bb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb3:	50                   	push   %eax
80105bb4:	6a 00                	push   $0x0
80105bb6:	6a 00                	push   $0x0
80105bb8:	e8 29 ff ff ff       	call   80105ae6 <argfd>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	79 07                	jns    80105bcb <sys_dup+0x24>
    return -1;
80105bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc9:	eb 31                	jmp    80105bfc <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bce:	83 ec 0c             	sub    $0xc,%esp
80105bd1:	50                   	push   %eax
80105bd2:	e8 84 ff ff ff       	call   80105b5b <fdalloc>
80105bd7:	83 c4 10             	add    $0x10,%esp
80105bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105be1:	79 07                	jns    80105bea <sys_dup+0x43>
    return -1;
80105be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be8:	eb 12                	jmp    80105bfc <sys_dup+0x55>
  filedup(f);
80105bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	50                   	push   %eax
80105bf1:	e8 0a b4 ff ff       	call   80101000 <filedup>
80105bf6:	83 c4 10             	add    $0x10,%esp
  return fd;
80105bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105bfc:	c9                   	leave  
80105bfd:	c3                   	ret    

80105bfe <sys_read>:

int
sys_read(void)
{
80105bfe:	55                   	push   %ebp
80105bff:	89 e5                	mov    %esp,%ebp
80105c01:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c04:	83 ec 04             	sub    $0x4,%esp
80105c07:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0a:	50                   	push   %eax
80105c0b:	6a 00                	push   $0x0
80105c0d:	6a 00                	push   $0x0
80105c0f:	e8 d2 fe ff ff       	call   80105ae6 <argfd>
80105c14:	83 c4 10             	add    $0x10,%esp
80105c17:	85 c0                	test   %eax,%eax
80105c19:	78 2e                	js     80105c49 <sys_read+0x4b>
80105c1b:	83 ec 08             	sub    $0x8,%esp
80105c1e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c21:	50                   	push   %eax
80105c22:	6a 02                	push   $0x2
80105c24:	e8 81 fd ff ff       	call   801059aa <argint>
80105c29:	83 c4 10             	add    $0x10,%esp
80105c2c:	85 c0                	test   %eax,%eax
80105c2e:	78 19                	js     80105c49 <sys_read+0x4b>
80105c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c33:	83 ec 04             	sub    $0x4,%esp
80105c36:	50                   	push   %eax
80105c37:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c3a:	50                   	push   %eax
80105c3b:	6a 01                	push   $0x1
80105c3d:	e8 90 fd ff ff       	call   801059d2 <argptr>
80105c42:	83 c4 10             	add    $0x10,%esp
80105c45:	85 c0                	test   %eax,%eax
80105c47:	79 07                	jns    80105c50 <sys_read+0x52>
    return -1;
80105c49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c4e:	eb 17                	jmp    80105c67 <sys_read+0x69>
  return fileread(f, p, n);
80105c50:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c59:	83 ec 04             	sub    $0x4,%esp
80105c5c:	51                   	push   %ecx
80105c5d:	52                   	push   %edx
80105c5e:	50                   	push   %eax
80105c5f:	e8 2c b5 ff ff       	call   80101190 <fileread>
80105c64:	83 c4 10             	add    $0x10,%esp
}
80105c67:	c9                   	leave  
80105c68:	c3                   	ret    

80105c69 <sys_write>:

int
sys_write(void)
{
80105c69:	55                   	push   %ebp
80105c6a:	89 e5                	mov    %esp,%ebp
80105c6c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c6f:	83 ec 04             	sub    $0x4,%esp
80105c72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c75:	50                   	push   %eax
80105c76:	6a 00                	push   $0x0
80105c78:	6a 00                	push   $0x0
80105c7a:	e8 67 fe ff ff       	call   80105ae6 <argfd>
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	85 c0                	test   %eax,%eax
80105c84:	78 2e                	js     80105cb4 <sys_write+0x4b>
80105c86:	83 ec 08             	sub    $0x8,%esp
80105c89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c8c:	50                   	push   %eax
80105c8d:	6a 02                	push   $0x2
80105c8f:	e8 16 fd ff ff       	call   801059aa <argint>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	85 c0                	test   %eax,%eax
80105c99:	78 19                	js     80105cb4 <sys_write+0x4b>
80105c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9e:	83 ec 04             	sub    $0x4,%esp
80105ca1:	50                   	push   %eax
80105ca2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ca5:	50                   	push   %eax
80105ca6:	6a 01                	push   $0x1
80105ca8:	e8 25 fd ff ff       	call   801059d2 <argptr>
80105cad:	83 c4 10             	add    $0x10,%esp
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	79 07                	jns    80105cbb <sys_write+0x52>
    return -1;
80105cb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb9:	eb 17                	jmp    80105cd2 <sys_write+0x69>
  return filewrite(f, p, n);
80105cbb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105cbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc4:	83 ec 04             	sub    $0x4,%esp
80105cc7:	51                   	push   %ecx
80105cc8:	52                   	push   %edx
80105cc9:	50                   	push   %eax
80105cca:	e8 79 b5 ff ff       	call   80101248 <filewrite>
80105ccf:	83 c4 10             	add    $0x10,%esp
}
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    

80105cd4 <sys_close>:

int
sys_close(void)
{
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105cda:	83 ec 04             	sub    $0x4,%esp
80105cdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce0:	50                   	push   %eax
80105ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce4:	50                   	push   %eax
80105ce5:	6a 00                	push   $0x0
80105ce7:	e8 fa fd ff ff       	call   80105ae6 <argfd>
80105cec:	83 c4 10             	add    $0x10,%esp
80105cef:	85 c0                	test   %eax,%eax
80105cf1:	79 07                	jns    80105cfa <sys_close+0x26>
    return -1;
80105cf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf8:	eb 28                	jmp    80105d22 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105cfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d03:	83 c2 08             	add    $0x8,%edx
80105d06:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105d0d:	00 
  fileclose(f);
80105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d11:	83 ec 0c             	sub    $0xc,%esp
80105d14:	50                   	push   %eax
80105d15:	e8 37 b3 ff ff       	call   80101051 <fileclose>
80105d1a:	83 c4 10             	add    $0x10,%esp
  return 0;
80105d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d22:	c9                   	leave  
80105d23:	c3                   	ret    

80105d24 <sys_fstat>:

int
sys_fstat(void)
{
80105d24:	55                   	push   %ebp
80105d25:	89 e5                	mov    %esp,%ebp
80105d27:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d2a:	83 ec 04             	sub    $0x4,%esp
80105d2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d30:	50                   	push   %eax
80105d31:	6a 00                	push   $0x0
80105d33:	6a 00                	push   $0x0
80105d35:	e8 ac fd ff ff       	call   80105ae6 <argfd>
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	78 17                	js     80105d58 <sys_fstat+0x34>
80105d41:	83 ec 04             	sub    $0x4,%esp
80105d44:	6a 1c                	push   $0x1c
80105d46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d49:	50                   	push   %eax
80105d4a:	6a 01                	push   $0x1
80105d4c:	e8 81 fc ff ff       	call   801059d2 <argptr>
80105d51:	83 c4 10             	add    $0x10,%esp
80105d54:	85 c0                	test   %eax,%eax
80105d56:	79 07                	jns    80105d5f <sys_fstat+0x3b>
    return -1;
80105d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5d:	eb 13                	jmp    80105d72 <sys_fstat+0x4e>
  return filestat(f, st);
80105d5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d65:	83 ec 08             	sub    $0x8,%esp
80105d68:	52                   	push   %edx
80105d69:	50                   	push   %eax
80105d6a:	e8 ca b3 ff ff       	call   80101139 <filestat>
80105d6f:	83 c4 10             	add    $0x10,%esp
}
80105d72:	c9                   	leave  
80105d73:	c3                   	ret    

80105d74 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d7a:	83 ec 08             	sub    $0x8,%esp
80105d7d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d80:	50                   	push   %eax
80105d81:	6a 00                	push   $0x0
80105d83:	e8 a7 fc ff ff       	call   80105a2f <argstr>
80105d88:	83 c4 10             	add    $0x10,%esp
80105d8b:	85 c0                	test   %eax,%eax
80105d8d:	78 15                	js     80105da4 <sys_link+0x30>
80105d8f:	83 ec 08             	sub    $0x8,%esp
80105d92:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105d95:	50                   	push   %eax
80105d96:	6a 01                	push   $0x1
80105d98:	e8 92 fc ff ff       	call   80105a2f <argstr>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	79 0a                	jns    80105dae <sys_link+0x3a>
    return -1;
80105da4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da9:	e9 68 01 00 00       	jmp    80105f16 <sys_link+0x1a2>

  begin_op();
80105dae:	e8 ea d7 ff ff       	call   8010359d <begin_op>
  if((ip = namei(old)) == 0){
80105db3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105db6:	83 ec 0c             	sub    $0xc,%esp
80105db9:	50                   	push   %eax
80105dba:	e8 b9 c7 ff ff       	call   80102578 <namei>
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dc9:	75 0f                	jne    80105dda <sys_link+0x66>
    end_op();
80105dcb:	e8 59 d8 ff ff       	call   80103629 <end_op>
    return -1;
80105dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd5:	e9 3c 01 00 00       	jmp    80105f16 <sys_link+0x1a2>
  }

  ilock(ip);
80105dda:	83 ec 0c             	sub    $0xc,%esp
80105ddd:	ff 75 f4             	pushl  -0xc(%ebp)
80105de0:	e8 85 bb ff ff       	call   8010196a <ilock>
80105de5:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105deb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105def:	66 83 f8 01          	cmp    $0x1,%ax
80105df3:	75 1d                	jne    80105e12 <sys_link+0x9e>
    iunlockput(ip);
80105df5:	83 ec 0c             	sub    $0xc,%esp
80105df8:	ff 75 f4             	pushl  -0xc(%ebp)
80105dfb:	e8 52 be ff ff       	call   80101c52 <iunlockput>
80105e00:	83 c4 10             	add    $0x10,%esp
    end_op();
80105e03:	e8 21 d8 ff ff       	call   80103629 <end_op>
    return -1;
80105e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e0d:	e9 04 01 00 00       	jmp    80105f16 <sys_link+0x1a2>
  }

  ip->nlink++;
80105e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e15:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e19:	83 c0 01             	add    $0x1,%eax
80105e1c:	89 c2                	mov    %eax,%edx
80105e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e21:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e25:	83 ec 0c             	sub    $0xc,%esp
80105e28:	ff 75 f4             	pushl  -0xc(%ebp)
80105e2b:	e8 60 b9 ff ff       	call   80101790 <iupdate>
80105e30:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105e33:	83 ec 0c             	sub    $0xc,%esp
80105e36:	ff 75 f4             	pushl  -0xc(%ebp)
80105e39:	e8 b2 bc ff ff       	call   80101af0 <iunlock>
80105e3e:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e44:	83 ec 08             	sub    $0x8,%esp
80105e47:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105e4a:	52                   	push   %edx
80105e4b:	50                   	push   %eax
80105e4c:	e8 43 c7 ff ff       	call   80102594 <nameiparent>
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e5b:	74 71                	je     80105ece <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	ff 75 f0             	pushl  -0x10(%ebp)
80105e63:	e8 02 bb ff ff       	call   8010196a <ilock>
80105e68:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e6e:	8b 10                	mov    (%eax),%edx
80105e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e73:	8b 00                	mov    (%eax),%eax
80105e75:	39 c2                	cmp    %eax,%edx
80105e77:	75 1d                	jne    80105e96 <sys_link+0x122>
80105e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7c:	8b 40 04             	mov    0x4(%eax),%eax
80105e7f:	83 ec 04             	sub    $0x4,%esp
80105e82:	50                   	push   %eax
80105e83:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e86:	50                   	push   %eax
80105e87:	ff 75 f0             	pushl  -0x10(%ebp)
80105e8a:	e8 4d c4 ff ff       	call   801022dc <dirlink>
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	85 c0                	test   %eax,%eax
80105e94:	79 10                	jns    80105ea6 <sys_link+0x132>
    iunlockput(dp);
80105e96:	83 ec 0c             	sub    $0xc,%esp
80105e99:	ff 75 f0             	pushl  -0x10(%ebp)
80105e9c:	e8 b1 bd ff ff       	call   80101c52 <iunlockput>
80105ea1:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105ea4:	eb 29                	jmp    80105ecf <sys_link+0x15b>
  }
  iunlockput(dp);
80105ea6:	83 ec 0c             	sub    $0xc,%esp
80105ea9:	ff 75 f0             	pushl  -0x10(%ebp)
80105eac:	e8 a1 bd ff ff       	call   80101c52 <iunlockput>
80105eb1:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105eb4:	83 ec 0c             	sub    $0xc,%esp
80105eb7:	ff 75 f4             	pushl  -0xc(%ebp)
80105eba:	e8 a3 bc ff ff       	call   80101b62 <iput>
80105ebf:	83 c4 10             	add    $0x10,%esp

  end_op();
80105ec2:	e8 62 d7 ff ff       	call   80103629 <end_op>

  return 0;
80105ec7:	b8 00 00 00 00       	mov    $0x0,%eax
80105ecc:	eb 48                	jmp    80105f16 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105ece:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105ecf:	83 ec 0c             	sub    $0xc,%esp
80105ed2:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed5:	e8 90 ba ff ff       	call   8010196a <ilock>
80105eda:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ee4:	83 e8 01             	sub    $0x1,%eax
80105ee7:	89 c2                	mov    %eax,%edx
80105ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eec:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ef6:	e8 95 b8 ff ff       	call   80101790 <iupdate>
80105efb:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105efe:	83 ec 0c             	sub    $0xc,%esp
80105f01:	ff 75 f4             	pushl  -0xc(%ebp)
80105f04:	e8 49 bd ff ff       	call   80101c52 <iunlockput>
80105f09:	83 c4 10             	add    $0x10,%esp
  end_op();
80105f0c:	e8 18 d7 ff ff       	call   80103629 <end_op>
  return -1;
80105f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f16:	c9                   	leave  
80105f17:	c3                   	ret    

80105f18 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105f18:	55                   	push   %ebp
80105f19:	89 e5                	mov    %esp,%ebp
80105f1b:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f1e:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105f25:	eb 40                	jmp    80105f67 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2a:	6a 10                	push   $0x10
80105f2c:	50                   	push   %eax
80105f2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f30:	50                   	push   %eax
80105f31:	ff 75 08             	pushl  0x8(%ebp)
80105f34:	e8 ef bf ff ff       	call   80101f28 <readi>
80105f39:	83 c4 10             	add    $0x10,%esp
80105f3c:	83 f8 10             	cmp    $0x10,%eax
80105f3f:	74 0d                	je     80105f4e <isdirempty+0x36>
      panic("isdirempty: readi");
80105f41:	83 ec 0c             	sub    $0xc,%esp
80105f44:	68 47 8f 10 80       	push   $0x80108f47
80105f49:	e8 18 a6 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105f4e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105f52:	66 85 c0             	test   %ax,%ax
80105f55:	74 07                	je     80105f5e <isdirempty+0x46>
      return 0;
80105f57:	b8 00 00 00 00       	mov    $0x0,%eax
80105f5c:	eb 1b                	jmp    80105f79 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f61:	83 c0 10             	add    $0x10,%eax
80105f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f67:	8b 45 08             	mov    0x8(%ebp),%eax
80105f6a:	8b 50 18             	mov    0x18(%eax),%edx
80105f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f70:	39 c2                	cmp    %eax,%edx
80105f72:	77 b3                	ja     80105f27 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105f74:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f79:	c9                   	leave  
80105f7a:	c3                   	ret    

80105f7b <sys_unlink>:

int
sys_unlink(void)
{
80105f7b:	55                   	push   %ebp
80105f7c:	89 e5                	mov    %esp,%ebp
80105f7e:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f81:	83 ec 08             	sub    $0x8,%esp
80105f84:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105f87:	50                   	push   %eax
80105f88:	6a 00                	push   $0x0
80105f8a:	e8 a0 fa ff ff       	call   80105a2f <argstr>
80105f8f:	83 c4 10             	add    $0x10,%esp
80105f92:	85 c0                	test   %eax,%eax
80105f94:	79 0a                	jns    80105fa0 <sys_unlink+0x25>
    return -1;
80105f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9b:	e9 bc 01 00 00       	jmp    8010615c <sys_unlink+0x1e1>

  begin_op();
80105fa0:	e8 f8 d5 ff ff       	call   8010359d <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105fa5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105fa8:	83 ec 08             	sub    $0x8,%esp
80105fab:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105fae:	52                   	push   %edx
80105faf:	50                   	push   %eax
80105fb0:	e8 df c5 ff ff       	call   80102594 <nameiparent>
80105fb5:	83 c4 10             	add    $0x10,%esp
80105fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fbf:	75 0f                	jne    80105fd0 <sys_unlink+0x55>
    end_op();
80105fc1:	e8 63 d6 ff ff       	call   80103629 <end_op>
    return -1;
80105fc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcb:	e9 8c 01 00 00       	jmp    8010615c <sys_unlink+0x1e1>
  }

  ilock(dp);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd6:	e8 8f b9 ff ff       	call   8010196a <ilock>
80105fdb:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105fde:	83 ec 08             	sub    $0x8,%esp
80105fe1:	68 59 8f 10 80       	push   $0x80108f59
80105fe6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fe9:	50                   	push   %eax
80105fea:	e8 18 c2 ff ff       	call   80102207 <namecmp>
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	85 c0                	test   %eax,%eax
80105ff4:	0f 84 4a 01 00 00    	je     80106144 <sys_unlink+0x1c9>
80105ffa:	83 ec 08             	sub    $0x8,%esp
80105ffd:	68 5b 8f 10 80       	push   $0x80108f5b
80106002:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106005:	50                   	push   %eax
80106006:	e8 fc c1 ff ff       	call   80102207 <namecmp>
8010600b:	83 c4 10             	add    $0x10,%esp
8010600e:	85 c0                	test   %eax,%eax
80106010:	0f 84 2e 01 00 00    	je     80106144 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106016:	83 ec 04             	sub    $0x4,%esp
80106019:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010601c:	50                   	push   %eax
8010601d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106020:	50                   	push   %eax
80106021:	ff 75 f4             	pushl  -0xc(%ebp)
80106024:	e8 f9 c1 ff ff       	call   80102222 <dirlookup>
80106029:	83 c4 10             	add    $0x10,%esp
8010602c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010602f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106033:	0f 84 0a 01 00 00    	je     80106143 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106039:	83 ec 0c             	sub    $0xc,%esp
8010603c:	ff 75 f0             	pushl  -0x10(%ebp)
8010603f:	e8 26 b9 ff ff       	call   8010196a <ilock>
80106044:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106047:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010604e:	66 85 c0             	test   %ax,%ax
80106051:	7f 0d                	jg     80106060 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106053:	83 ec 0c             	sub    $0xc,%esp
80106056:	68 5e 8f 10 80       	push   $0x80108f5e
8010605b:	e8 06 a5 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106060:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106063:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106067:	66 83 f8 01          	cmp    $0x1,%ax
8010606b:	75 25                	jne    80106092 <sys_unlink+0x117>
8010606d:	83 ec 0c             	sub    $0xc,%esp
80106070:	ff 75 f0             	pushl  -0x10(%ebp)
80106073:	e8 a0 fe ff ff       	call   80105f18 <isdirempty>
80106078:	83 c4 10             	add    $0x10,%esp
8010607b:	85 c0                	test   %eax,%eax
8010607d:	75 13                	jne    80106092 <sys_unlink+0x117>
    iunlockput(ip);
8010607f:	83 ec 0c             	sub    $0xc,%esp
80106082:	ff 75 f0             	pushl  -0x10(%ebp)
80106085:	e8 c8 bb ff ff       	call   80101c52 <iunlockput>
8010608a:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010608d:	e9 b2 00 00 00       	jmp    80106144 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106092:	83 ec 04             	sub    $0x4,%esp
80106095:	6a 10                	push   $0x10
80106097:	6a 00                	push   $0x0
80106099:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010609c:	50                   	push   %eax
8010609d:	e8 e3 f5 ff ff       	call   80105685 <memset>
801060a2:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801060a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801060a8:	6a 10                	push   $0x10
801060aa:	50                   	push   %eax
801060ab:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060ae:	50                   	push   %eax
801060af:	ff 75 f4             	pushl  -0xc(%ebp)
801060b2:	e8 c8 bf ff ff       	call   8010207f <writei>
801060b7:	83 c4 10             	add    $0x10,%esp
801060ba:	83 f8 10             	cmp    $0x10,%eax
801060bd:	74 0d                	je     801060cc <sys_unlink+0x151>
    panic("unlink: writei");
801060bf:	83 ec 0c             	sub    $0xc,%esp
801060c2:	68 70 8f 10 80       	push   $0x80108f70
801060c7:	e8 9a a4 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801060cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cf:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060d3:	66 83 f8 01          	cmp    $0x1,%ax
801060d7:	75 21                	jne    801060fa <sys_unlink+0x17f>
    dp->nlink--;
801060d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060dc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060e0:	83 e8 01             	sub    $0x1,%eax
801060e3:	89 c2                	mov    %eax,%edx
801060e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e8:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	ff 75 f4             	pushl  -0xc(%ebp)
801060f2:	e8 99 b6 ff ff       	call   80101790 <iupdate>
801060f7:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801060fa:	83 ec 0c             	sub    $0xc,%esp
801060fd:	ff 75 f4             	pushl  -0xc(%ebp)
80106100:	e8 4d bb ff ff       	call   80101c52 <iunlockput>
80106105:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010610f:	83 e8 01             	sub    $0x1,%eax
80106112:	89 c2                	mov    %eax,%edx
80106114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106117:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010611b:	83 ec 0c             	sub    $0xc,%esp
8010611e:	ff 75 f0             	pushl  -0x10(%ebp)
80106121:	e8 6a b6 ff ff       	call   80101790 <iupdate>
80106126:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106129:	83 ec 0c             	sub    $0xc,%esp
8010612c:	ff 75 f0             	pushl  -0x10(%ebp)
8010612f:	e8 1e bb ff ff       	call   80101c52 <iunlockput>
80106134:	83 c4 10             	add    $0x10,%esp

  end_op();
80106137:	e8 ed d4 ff ff       	call   80103629 <end_op>

  return 0;
8010613c:	b8 00 00 00 00       	mov    $0x0,%eax
80106141:	eb 19                	jmp    8010615c <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106143:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106144:	83 ec 0c             	sub    $0xc,%esp
80106147:	ff 75 f4             	pushl  -0xc(%ebp)
8010614a:	e8 03 bb ff ff       	call   80101c52 <iunlockput>
8010614f:	83 c4 10             	add    $0x10,%esp
  end_op();
80106152:	e8 d2 d4 ff ff       	call   80103629 <end_op>
  return -1;
80106157:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010615c:	c9                   	leave  
8010615d:	c3                   	ret    

8010615e <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010615e:	55                   	push   %ebp
8010615f:	89 e5                	mov    %esp,%ebp
80106161:	83 ec 38             	sub    $0x38,%esp
80106164:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106167:	8b 55 10             	mov    0x10(%ebp),%edx
8010616a:	8b 45 14             	mov    0x14(%ebp),%eax
8010616d:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106171:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106175:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106179:	83 ec 08             	sub    $0x8,%esp
8010617c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010617f:	50                   	push   %eax
80106180:	ff 75 08             	pushl  0x8(%ebp)
80106183:	e8 0c c4 ff ff       	call   80102594 <nameiparent>
80106188:	83 c4 10             	add    $0x10,%esp
8010618b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010618e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106192:	75 0a                	jne    8010619e <create+0x40>
    return 0;
80106194:	b8 00 00 00 00       	mov    $0x0,%eax
80106199:	e9 90 01 00 00       	jmp    8010632e <create+0x1d0>
  ilock(dp);
8010619e:	83 ec 0c             	sub    $0xc,%esp
801061a1:	ff 75 f4             	pushl  -0xc(%ebp)
801061a4:	e8 c1 b7 ff ff       	call   8010196a <ilock>
801061a9:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801061ac:	83 ec 04             	sub    $0x4,%esp
801061af:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061b2:	50                   	push   %eax
801061b3:	8d 45 de             	lea    -0x22(%ebp),%eax
801061b6:	50                   	push   %eax
801061b7:	ff 75 f4             	pushl  -0xc(%ebp)
801061ba:	e8 63 c0 ff ff       	call   80102222 <dirlookup>
801061bf:	83 c4 10             	add    $0x10,%esp
801061c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c9:	74 50                	je     8010621b <create+0xbd>
    iunlockput(dp);
801061cb:	83 ec 0c             	sub    $0xc,%esp
801061ce:	ff 75 f4             	pushl  -0xc(%ebp)
801061d1:	e8 7c ba ff ff       	call   80101c52 <iunlockput>
801061d6:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801061d9:	83 ec 0c             	sub    $0xc,%esp
801061dc:	ff 75 f0             	pushl  -0x10(%ebp)
801061df:	e8 86 b7 ff ff       	call   8010196a <ilock>
801061e4:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801061e7:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801061ec:	75 15                	jne    80106203 <create+0xa5>
801061ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061f5:	66 83 f8 02          	cmp    $0x2,%ax
801061f9:	75 08                	jne    80106203 <create+0xa5>
      return ip;
801061fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061fe:	e9 2b 01 00 00       	jmp    8010632e <create+0x1d0>
    iunlockput(ip);
80106203:	83 ec 0c             	sub    $0xc,%esp
80106206:	ff 75 f0             	pushl  -0x10(%ebp)
80106209:	e8 44 ba ff ff       	call   80101c52 <iunlockput>
8010620e:	83 c4 10             	add    $0x10,%esp
    return 0;
80106211:	b8 00 00 00 00       	mov    $0x0,%eax
80106216:	e9 13 01 00 00       	jmp    8010632e <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010621b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010621f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106222:	8b 00                	mov    (%eax),%eax
80106224:	83 ec 08             	sub    $0x8,%esp
80106227:	52                   	push   %edx
80106228:	50                   	push   %eax
80106229:	e8 8b b4 ff ff       	call   801016b9 <ialloc>
8010622e:	83 c4 10             	add    $0x10,%esp
80106231:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106234:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106238:	75 0d                	jne    80106247 <create+0xe9>
    panic("create: ialloc");
8010623a:	83 ec 0c             	sub    $0xc,%esp
8010623d:	68 7f 8f 10 80       	push   $0x80108f7f
80106242:	e8 1f a3 ff ff       	call   80100566 <panic>

  ilock(ip);
80106247:	83 ec 0c             	sub    $0xc,%esp
8010624a:	ff 75 f0             	pushl  -0x10(%ebp)
8010624d:	e8 18 b7 ff ff       	call   8010196a <ilock>
80106252:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106255:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106258:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010625c:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106260:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106263:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106267:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010626b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010626e:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106274:	83 ec 0c             	sub    $0xc,%esp
80106277:	ff 75 f0             	pushl  -0x10(%ebp)
8010627a:	e8 11 b5 ff ff       	call   80101790 <iupdate>
8010627f:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106282:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106287:	75 6a                	jne    801062f3 <create+0x195>
    dp->nlink++;  // for ".."
80106289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010628c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106290:	83 c0 01             	add    $0x1,%eax
80106293:	89 c2                	mov    %eax,%edx
80106295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106298:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010629c:	83 ec 0c             	sub    $0xc,%esp
8010629f:	ff 75 f4             	pushl  -0xc(%ebp)
801062a2:	e8 e9 b4 ff ff       	call   80101790 <iupdate>
801062a7:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801062aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ad:	8b 40 04             	mov    0x4(%eax),%eax
801062b0:	83 ec 04             	sub    $0x4,%esp
801062b3:	50                   	push   %eax
801062b4:	68 59 8f 10 80       	push   $0x80108f59
801062b9:	ff 75 f0             	pushl  -0x10(%ebp)
801062bc:	e8 1b c0 ff ff       	call   801022dc <dirlink>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	85 c0                	test   %eax,%eax
801062c6:	78 1e                	js     801062e6 <create+0x188>
801062c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062cb:	8b 40 04             	mov    0x4(%eax),%eax
801062ce:	83 ec 04             	sub    $0x4,%esp
801062d1:	50                   	push   %eax
801062d2:	68 5b 8f 10 80       	push   $0x80108f5b
801062d7:	ff 75 f0             	pushl  -0x10(%ebp)
801062da:	e8 fd bf ff ff       	call   801022dc <dirlink>
801062df:	83 c4 10             	add    $0x10,%esp
801062e2:	85 c0                	test   %eax,%eax
801062e4:	79 0d                	jns    801062f3 <create+0x195>
      panic("create dots");
801062e6:	83 ec 0c             	sub    $0xc,%esp
801062e9:	68 8e 8f 10 80       	push   $0x80108f8e
801062ee:	e8 73 a2 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801062f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f6:	8b 40 04             	mov    0x4(%eax),%eax
801062f9:	83 ec 04             	sub    $0x4,%esp
801062fc:	50                   	push   %eax
801062fd:	8d 45 de             	lea    -0x22(%ebp),%eax
80106300:	50                   	push   %eax
80106301:	ff 75 f4             	pushl  -0xc(%ebp)
80106304:	e8 d3 bf ff ff       	call   801022dc <dirlink>
80106309:	83 c4 10             	add    $0x10,%esp
8010630c:	85 c0                	test   %eax,%eax
8010630e:	79 0d                	jns    8010631d <create+0x1bf>
    panic("create: dirlink");
80106310:	83 ec 0c             	sub    $0xc,%esp
80106313:	68 9a 8f 10 80       	push   $0x80108f9a
80106318:	e8 49 a2 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010631d:	83 ec 0c             	sub    $0xc,%esp
80106320:	ff 75 f4             	pushl  -0xc(%ebp)
80106323:	e8 2a b9 ff ff       	call   80101c52 <iunlockput>
80106328:	83 c4 10             	add    $0x10,%esp

  return ip;
8010632b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010632e:	c9                   	leave  
8010632f:	c3                   	ret    

80106330 <sys_open>:

int
sys_open(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106336:	83 ec 08             	sub    $0x8,%esp
80106339:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010633c:	50                   	push   %eax
8010633d:	6a 00                	push   $0x0
8010633f:	e8 eb f6 ff ff       	call   80105a2f <argstr>
80106344:	83 c4 10             	add    $0x10,%esp
80106347:	85 c0                	test   %eax,%eax
80106349:	78 15                	js     80106360 <sys_open+0x30>
8010634b:	83 ec 08             	sub    $0x8,%esp
8010634e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106351:	50                   	push   %eax
80106352:	6a 01                	push   $0x1
80106354:	e8 51 f6 ff ff       	call   801059aa <argint>
80106359:	83 c4 10             	add    $0x10,%esp
8010635c:	85 c0                	test   %eax,%eax
8010635e:	79 0a                	jns    8010636a <sys_open+0x3a>
    return -1;
80106360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106365:	e9 61 01 00 00       	jmp    801064cb <sys_open+0x19b>

  begin_op();
8010636a:	e8 2e d2 ff ff       	call   8010359d <begin_op>

  if(omode & O_CREATE){
8010636f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106372:	25 00 02 00 00       	and    $0x200,%eax
80106377:	85 c0                	test   %eax,%eax
80106379:	74 2a                	je     801063a5 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010637b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010637e:	6a 00                	push   $0x0
80106380:	6a 00                	push   $0x0
80106382:	6a 02                	push   $0x2
80106384:	50                   	push   %eax
80106385:	e8 d4 fd ff ff       	call   8010615e <create>
8010638a:	83 c4 10             	add    $0x10,%esp
8010638d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106394:	75 75                	jne    8010640b <sys_open+0xdb>
      end_op();
80106396:	e8 8e d2 ff ff       	call   80103629 <end_op>
      return -1;
8010639b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a0:	e9 26 01 00 00       	jmp    801064cb <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801063a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063a8:	83 ec 0c             	sub    $0xc,%esp
801063ab:	50                   	push   %eax
801063ac:	e8 c7 c1 ff ff       	call   80102578 <namei>
801063b1:	83 c4 10             	add    $0x10,%esp
801063b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063bb:	75 0f                	jne    801063cc <sys_open+0x9c>
      end_op();
801063bd:	e8 67 d2 ff ff       	call   80103629 <end_op>
      return -1;
801063c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c7:	e9 ff 00 00 00       	jmp    801064cb <sys_open+0x19b>
    }
    ilock(ip);
801063cc:	83 ec 0c             	sub    $0xc,%esp
801063cf:	ff 75 f4             	pushl  -0xc(%ebp)
801063d2:	e8 93 b5 ff ff       	call   8010196a <ilock>
801063d7:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801063da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063dd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063e1:	66 83 f8 01          	cmp    $0x1,%ax
801063e5:	75 24                	jne    8010640b <sys_open+0xdb>
801063e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063ea:	85 c0                	test   %eax,%eax
801063ec:	74 1d                	je     8010640b <sys_open+0xdb>
      iunlockput(ip);
801063ee:	83 ec 0c             	sub    $0xc,%esp
801063f1:	ff 75 f4             	pushl  -0xc(%ebp)
801063f4:	e8 59 b8 ff ff       	call   80101c52 <iunlockput>
801063f9:	83 c4 10             	add    $0x10,%esp
      end_op();
801063fc:	e8 28 d2 ff ff       	call   80103629 <end_op>
      return -1;
80106401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106406:	e9 c0 00 00 00       	jmp    801064cb <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010640b:	e8 83 ab ff ff       	call   80100f93 <filealloc>
80106410:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106417:	74 17                	je     80106430 <sys_open+0x100>
80106419:	83 ec 0c             	sub    $0xc,%esp
8010641c:	ff 75 f0             	pushl  -0x10(%ebp)
8010641f:	e8 37 f7 ff ff       	call   80105b5b <fdalloc>
80106424:	83 c4 10             	add    $0x10,%esp
80106427:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010642a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010642e:	79 2e                	jns    8010645e <sys_open+0x12e>
    if(f)
80106430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106434:	74 0e                	je     80106444 <sys_open+0x114>
      fileclose(f);
80106436:	83 ec 0c             	sub    $0xc,%esp
80106439:	ff 75 f0             	pushl  -0x10(%ebp)
8010643c:	e8 10 ac ff ff       	call   80101051 <fileclose>
80106441:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106444:	83 ec 0c             	sub    $0xc,%esp
80106447:	ff 75 f4             	pushl  -0xc(%ebp)
8010644a:	e8 03 b8 ff ff       	call   80101c52 <iunlockput>
8010644f:	83 c4 10             	add    $0x10,%esp
    end_op();
80106452:	e8 d2 d1 ff ff       	call   80103629 <end_op>
    return -1;
80106457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645c:	eb 6d                	jmp    801064cb <sys_open+0x19b>
  }
  iunlock(ip);
8010645e:	83 ec 0c             	sub    $0xc,%esp
80106461:	ff 75 f4             	pushl  -0xc(%ebp)
80106464:	e8 87 b6 ff ff       	call   80101af0 <iunlock>
80106469:	83 c4 10             	add    $0x10,%esp
  end_op();
8010646c:	e8 b8 d1 ff ff       	call   80103629 <end_op>

  f->type = FD_INODE;
80106471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106474:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010647a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010647d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106480:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106483:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106486:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010648d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106490:	83 e0 01             	and    $0x1,%eax
80106493:	85 c0                	test   %eax,%eax
80106495:	0f 94 c0             	sete   %al
80106498:	89 c2                	mov    %eax,%edx
8010649a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649d:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801064a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a3:	83 e0 01             	and    $0x1,%eax
801064a6:	85 c0                	test   %eax,%eax
801064a8:	75 0a                	jne    801064b4 <sys_open+0x184>
801064aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064ad:	83 e0 02             	and    $0x2,%eax
801064b0:	85 c0                	test   %eax,%eax
801064b2:	74 07                	je     801064bb <sys_open+0x18b>
801064b4:	b8 01 00 00 00       	mov    $0x1,%eax
801064b9:	eb 05                	jmp    801064c0 <sys_open+0x190>
801064bb:	b8 00 00 00 00       	mov    $0x0,%eax
801064c0:	89 c2                	mov    %eax,%edx
801064c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c5:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801064c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801064cb:	c9                   	leave  
801064cc:	c3                   	ret    

801064cd <sys_mkdir>:

int
sys_mkdir(void)
{
801064cd:	55                   	push   %ebp
801064ce:	89 e5                	mov    %esp,%ebp
801064d0:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801064d3:	e8 c5 d0 ff ff       	call   8010359d <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801064d8:	83 ec 08             	sub    $0x8,%esp
801064db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064de:	50                   	push   %eax
801064df:	6a 00                	push   $0x0
801064e1:	e8 49 f5 ff ff       	call   80105a2f <argstr>
801064e6:	83 c4 10             	add    $0x10,%esp
801064e9:	85 c0                	test   %eax,%eax
801064eb:	78 1b                	js     80106508 <sys_mkdir+0x3b>
801064ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f0:	6a 00                	push   $0x0
801064f2:	6a 00                	push   $0x0
801064f4:	6a 01                	push   $0x1
801064f6:	50                   	push   %eax
801064f7:	e8 62 fc ff ff       	call   8010615e <create>
801064fc:	83 c4 10             	add    $0x10,%esp
801064ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106506:	75 0c                	jne    80106514 <sys_mkdir+0x47>
    end_op();
80106508:	e8 1c d1 ff ff       	call   80103629 <end_op>
    return -1;
8010650d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106512:	eb 18                	jmp    8010652c <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106514:	83 ec 0c             	sub    $0xc,%esp
80106517:	ff 75 f4             	pushl  -0xc(%ebp)
8010651a:	e8 33 b7 ff ff       	call   80101c52 <iunlockput>
8010651f:	83 c4 10             	add    $0x10,%esp
  end_op();
80106522:	e8 02 d1 ff ff       	call   80103629 <end_op>
  return 0;
80106527:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010652c:	c9                   	leave  
8010652d:	c3                   	ret    

8010652e <sys_mknod>:

int
sys_mknod(void)
{
8010652e:	55                   	push   %ebp
8010652f:	89 e5                	mov    %esp,%ebp
80106531:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106534:	e8 64 d0 ff ff       	call   8010359d <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106539:	83 ec 08             	sub    $0x8,%esp
8010653c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010653f:	50                   	push   %eax
80106540:	6a 00                	push   $0x0
80106542:	e8 e8 f4 ff ff       	call   80105a2f <argstr>
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010654d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106551:	78 4f                	js     801065a2 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106553:	83 ec 08             	sub    $0x8,%esp
80106556:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106559:	50                   	push   %eax
8010655a:	6a 01                	push   $0x1
8010655c:	e8 49 f4 ff ff       	call   801059aa <argint>
80106561:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106564:	85 c0                	test   %eax,%eax
80106566:	78 3a                	js     801065a2 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106568:	83 ec 08             	sub    $0x8,%esp
8010656b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010656e:	50                   	push   %eax
8010656f:	6a 02                	push   $0x2
80106571:	e8 34 f4 ff ff       	call   801059aa <argint>
80106576:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106579:	85 c0                	test   %eax,%eax
8010657b:	78 25                	js     801065a2 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010657d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106580:	0f bf c8             	movswl %ax,%ecx
80106583:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106586:	0f bf d0             	movswl %ax,%edx
80106589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010658c:	51                   	push   %ecx
8010658d:	52                   	push   %edx
8010658e:	6a 03                	push   $0x3
80106590:	50                   	push   %eax
80106591:	e8 c8 fb ff ff       	call   8010615e <create>
80106596:	83 c4 10             	add    $0x10,%esp
80106599:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010659c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065a0:	75 0c                	jne    801065ae <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801065a2:	e8 82 d0 ff ff       	call   80103629 <end_op>
    return -1;
801065a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ac:	eb 18                	jmp    801065c6 <sys_mknod+0x98>
  }
  iunlockput(ip);
801065ae:	83 ec 0c             	sub    $0xc,%esp
801065b1:	ff 75 f0             	pushl  -0x10(%ebp)
801065b4:	e8 99 b6 ff ff       	call   80101c52 <iunlockput>
801065b9:	83 c4 10             	add    $0x10,%esp
  end_op();
801065bc:	e8 68 d0 ff ff       	call   80103629 <end_op>
  return 0;
801065c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065c6:	c9                   	leave  
801065c7:	c3                   	ret    

801065c8 <sys_chdir>:

int
sys_chdir(void)
{
801065c8:	55                   	push   %ebp
801065c9:	89 e5                	mov    %esp,%ebp
801065cb:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065ce:	e8 ca cf ff ff       	call   8010359d <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801065d3:	83 ec 08             	sub    $0x8,%esp
801065d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065d9:	50                   	push   %eax
801065da:	6a 00                	push   $0x0
801065dc:	e8 4e f4 ff ff       	call   80105a2f <argstr>
801065e1:	83 c4 10             	add    $0x10,%esp
801065e4:	85 c0                	test   %eax,%eax
801065e6:	78 18                	js     80106600 <sys_chdir+0x38>
801065e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065eb:	83 ec 0c             	sub    $0xc,%esp
801065ee:	50                   	push   %eax
801065ef:	e8 84 bf ff ff       	call   80102578 <namei>
801065f4:	83 c4 10             	add    $0x10,%esp
801065f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065fe:	75 0c                	jne    8010660c <sys_chdir+0x44>
    end_op();
80106600:	e8 24 d0 ff ff       	call   80103629 <end_op>
    return -1;
80106605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660a:	eb 6e                	jmp    8010667a <sys_chdir+0xb2>
  }
  ilock(ip);
8010660c:	83 ec 0c             	sub    $0xc,%esp
8010660f:	ff 75 f4             	pushl  -0xc(%ebp)
80106612:	e8 53 b3 ff ff       	call   8010196a <ilock>
80106617:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010661a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106621:	66 83 f8 01          	cmp    $0x1,%ax
80106625:	74 1a                	je     80106641 <sys_chdir+0x79>
    iunlockput(ip);
80106627:	83 ec 0c             	sub    $0xc,%esp
8010662a:	ff 75 f4             	pushl  -0xc(%ebp)
8010662d:	e8 20 b6 ff ff       	call   80101c52 <iunlockput>
80106632:	83 c4 10             	add    $0x10,%esp
    end_op();
80106635:	e8 ef cf ff ff       	call   80103629 <end_op>
    return -1;
8010663a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663f:	eb 39                	jmp    8010667a <sys_chdir+0xb2>
  }
  iunlock(ip);
80106641:	83 ec 0c             	sub    $0xc,%esp
80106644:	ff 75 f4             	pushl  -0xc(%ebp)
80106647:	e8 a4 b4 ff ff       	call   80101af0 <iunlock>
8010664c:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010664f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106655:	8b 40 68             	mov    0x68(%eax),%eax
80106658:	83 ec 0c             	sub    $0xc,%esp
8010665b:	50                   	push   %eax
8010665c:	e8 01 b5 ff ff       	call   80101b62 <iput>
80106661:	83 c4 10             	add    $0x10,%esp
  end_op();
80106664:	e8 c0 cf ff ff       	call   80103629 <end_op>
  proc->cwd = ip;
80106669:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010666f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106672:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106675:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010667a:	c9                   	leave  
8010667b:	c3                   	ret    

8010667c <sys_exec>:

int
sys_exec(void)
{
8010667c:	55                   	push   %ebp
8010667d:	89 e5                	mov    %esp,%ebp
8010667f:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106685:	83 ec 08             	sub    $0x8,%esp
80106688:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010668b:	50                   	push   %eax
8010668c:	6a 00                	push   $0x0
8010668e:	e8 9c f3 ff ff       	call   80105a2f <argstr>
80106693:	83 c4 10             	add    $0x10,%esp
80106696:	85 c0                	test   %eax,%eax
80106698:	78 18                	js     801066b2 <sys_exec+0x36>
8010669a:	83 ec 08             	sub    $0x8,%esp
8010669d:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801066a3:	50                   	push   %eax
801066a4:	6a 01                	push   $0x1
801066a6:	e8 ff f2 ff ff       	call   801059aa <argint>
801066ab:	83 c4 10             	add    $0x10,%esp
801066ae:	85 c0                	test   %eax,%eax
801066b0:	79 0a                	jns    801066bc <sys_exec+0x40>
    return -1;
801066b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b7:	e9 c6 00 00 00       	jmp    80106782 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801066bc:	83 ec 04             	sub    $0x4,%esp
801066bf:	68 80 00 00 00       	push   $0x80
801066c4:	6a 00                	push   $0x0
801066c6:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801066cc:	50                   	push   %eax
801066cd:	e8 b3 ef ff ff       	call   80105685 <memset>
801066d2:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801066d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801066dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066df:	83 f8 1f             	cmp    $0x1f,%eax
801066e2:	76 0a                	jbe    801066ee <sys_exec+0x72>
      return -1;
801066e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e9:	e9 94 00 00 00       	jmp    80106782 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801066ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066f1:	c1 e0 02             	shl    $0x2,%eax
801066f4:	89 c2                	mov    %eax,%edx
801066f6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801066fc:	01 c2                	add    %eax,%edx
801066fe:	83 ec 08             	sub    $0x8,%esp
80106701:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106707:	50                   	push   %eax
80106708:	52                   	push   %edx
80106709:	e8 00 f2 ff ff       	call   8010590e <fetchint>
8010670e:	83 c4 10             	add    $0x10,%esp
80106711:	85 c0                	test   %eax,%eax
80106713:	79 07                	jns    8010671c <sys_exec+0xa0>
      return -1;
80106715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671a:	eb 66                	jmp    80106782 <sys_exec+0x106>
    if(uarg == 0){
8010671c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106722:	85 c0                	test   %eax,%eax
80106724:	75 27                	jne    8010674d <sys_exec+0xd1>
      argv[i] = 0;
80106726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106729:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106730:	00 00 00 00 
      break;
80106734:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106735:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106738:	83 ec 08             	sub    $0x8,%esp
8010673b:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106741:	52                   	push   %edx
80106742:	50                   	push   %eax
80106743:	e8 29 a4 ff ff       	call   80100b71 <exec>
80106748:	83 c4 10             	add    $0x10,%esp
8010674b:	eb 35                	jmp    80106782 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010674d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106753:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106756:	c1 e2 02             	shl    $0x2,%edx
80106759:	01 c2                	add    %eax,%edx
8010675b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106761:	83 ec 08             	sub    $0x8,%esp
80106764:	52                   	push   %edx
80106765:	50                   	push   %eax
80106766:	e8 dd f1 ff ff       	call   80105948 <fetchstr>
8010676b:	83 c4 10             	add    $0x10,%esp
8010676e:	85 c0                	test   %eax,%eax
80106770:	79 07                	jns    80106779 <sys_exec+0xfd>
      return -1;
80106772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106777:	eb 09                	jmp    80106782 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106779:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010677d:	e9 5a ff ff ff       	jmp    801066dc <sys_exec+0x60>
  return exec(path, argv);
}
80106782:	c9                   	leave  
80106783:	c3                   	ret    

80106784 <sys_pipe>:

int
sys_pipe(void)
{
80106784:	55                   	push   %ebp
80106785:	89 e5                	mov    %esp,%ebp
80106787:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010678a:	83 ec 04             	sub    $0x4,%esp
8010678d:	6a 08                	push   $0x8
8010678f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106792:	50                   	push   %eax
80106793:	6a 00                	push   $0x0
80106795:	e8 38 f2 ff ff       	call   801059d2 <argptr>
8010679a:	83 c4 10             	add    $0x10,%esp
8010679d:	85 c0                	test   %eax,%eax
8010679f:	79 0a                	jns    801067ab <sys_pipe+0x27>
    return -1;
801067a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a6:	e9 af 00 00 00       	jmp    8010685a <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801067ab:	83 ec 08             	sub    $0x8,%esp
801067ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067b1:	50                   	push   %eax
801067b2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067b5:	50                   	push   %eax
801067b6:	e8 d6 d8 ff ff       	call   80104091 <pipealloc>
801067bb:	83 c4 10             	add    $0x10,%esp
801067be:	85 c0                	test   %eax,%eax
801067c0:	79 0a                	jns    801067cc <sys_pipe+0x48>
    return -1;
801067c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c7:	e9 8e 00 00 00       	jmp    8010685a <sys_pipe+0xd6>
  fd0 = -1;
801067cc:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801067d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067d6:	83 ec 0c             	sub    $0xc,%esp
801067d9:	50                   	push   %eax
801067da:	e8 7c f3 ff ff       	call   80105b5b <fdalloc>
801067df:	83 c4 10             	add    $0x10,%esp
801067e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067e9:	78 18                	js     80106803 <sys_pipe+0x7f>
801067eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ee:	83 ec 0c             	sub    $0xc,%esp
801067f1:	50                   	push   %eax
801067f2:	e8 64 f3 ff ff       	call   80105b5b <fdalloc>
801067f7:	83 c4 10             	add    $0x10,%esp
801067fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106801:	79 3f                	jns    80106842 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106803:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106807:	78 14                	js     8010681d <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106809:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010680f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106812:	83 c2 08             	add    $0x8,%edx
80106815:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010681c:	00 
    fileclose(rf);
8010681d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106820:	83 ec 0c             	sub    $0xc,%esp
80106823:	50                   	push   %eax
80106824:	e8 28 a8 ff ff       	call   80101051 <fileclose>
80106829:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010682c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010682f:	83 ec 0c             	sub    $0xc,%esp
80106832:	50                   	push   %eax
80106833:	e8 19 a8 ff ff       	call   80101051 <fileclose>
80106838:	83 c4 10             	add    $0x10,%esp
    return -1;
8010683b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106840:	eb 18                	jmp    8010685a <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106842:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106848:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010684a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010684d:	8d 50 04             	lea    0x4(%eax),%edx
80106850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106853:	89 02                	mov    %eax,(%edx)
  return 0;
80106855:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010685a:	c9                   	leave  
8010685b:	c3                   	ret    

8010685c <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010685c:	55                   	push   %ebp
8010685d:	89 e5                	mov    %esp,%ebp
8010685f:	83 ec 08             	sub    $0x8,%esp
80106862:	8b 55 08             	mov    0x8(%ebp),%edx
80106865:	8b 45 0c             	mov    0xc(%ebp),%eax
80106868:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010686c:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106870:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106874:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106878:	66 ef                	out    %ax,(%dx)
}
8010687a:	90                   	nop
8010687b:	c9                   	leave  
8010687c:	c3                   	ret    

8010687d <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010687d:	55                   	push   %ebp
8010687e:	89 e5                	mov    %esp,%ebp
80106880:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106883:	e8 67 df ff ff       	call   801047ef <fork>
}
80106888:	c9                   	leave  
80106889:	c3                   	ret    

8010688a <sys_exit>:

int
sys_exit(void)
{
8010688a:	55                   	push   %ebp
8010688b:	89 e5                	mov    %esp,%ebp
8010688d:	83 ec 08             	sub    $0x8,%esp
  exit();
80106890:	e8 15 e1 ff ff       	call   801049aa <exit>
  return 0;  // not reached
80106895:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010689a:	c9                   	leave  
8010689b:	c3                   	ret    

8010689c <sys_wait>:

int
sys_wait(void)
{
8010689c:	55                   	push   %ebp
8010689d:	89 e5                	mov    %esp,%ebp
8010689f:	83 ec 08             	sub    $0x8,%esp
  return wait();
801068a2:	e8 3e e2 ff ff       	call   80104ae5 <wait>
}
801068a7:	c9                   	leave  
801068a8:	c3                   	ret    

801068a9 <sys_kill>:

int
sys_kill(void)
{
801068a9:	55                   	push   %ebp
801068aa:	89 e5                	mov    %esp,%ebp
801068ac:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801068af:	83 ec 08             	sub    $0x8,%esp
801068b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068b5:	50                   	push   %eax
801068b6:	6a 00                	push   $0x0
801068b8:	e8 ed f0 ff ff       	call   801059aa <argint>
801068bd:	83 c4 10             	add    $0x10,%esp
801068c0:	85 c0                	test   %eax,%eax
801068c2:	79 07                	jns    801068cb <sys_kill+0x22>
    return -1;
801068c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c9:	eb 0f                	jmp    801068da <sys_kill+0x31>
  return kill(pid);
801068cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ce:	83 ec 0c             	sub    $0xc,%esp
801068d1:	50                   	push   %eax
801068d2:	e8 d9 e6 ff ff       	call   80104fb0 <kill>
801068d7:	83 c4 10             	add    $0x10,%esp
}
801068da:	c9                   	leave  
801068db:	c3                   	ret    

801068dc <sys_getpid>:

int
sys_getpid(void)
{
801068dc:	55                   	push   %ebp
801068dd:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801068df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e5:	8b 40 10             	mov    0x10(%eax),%eax
}
801068e8:	5d                   	pop    %ebp
801068e9:	c3                   	ret    

801068ea <sys_sbrk>:

int
sys_sbrk(void)
{
801068ea:	55                   	push   %ebp
801068eb:	89 e5                	mov    %esp,%ebp
801068ed:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801068f0:	83 ec 08             	sub    $0x8,%esp
801068f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068f6:	50                   	push   %eax
801068f7:	6a 00                	push   $0x0
801068f9:	e8 ac f0 ff ff       	call   801059aa <argint>
801068fe:	83 c4 10             	add    $0x10,%esp
80106901:	85 c0                	test   %eax,%eax
80106903:	79 07                	jns    8010690c <sys_sbrk+0x22>
    return -1;
80106905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690a:	eb 28                	jmp    80106934 <sys_sbrk+0x4a>
  addr = proc->sz;
8010690c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106912:	8b 00                	mov    (%eax),%eax
80106914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106917:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010691a:	83 ec 0c             	sub    $0xc,%esp
8010691d:	50                   	push   %eax
8010691e:	e8 29 de ff ff       	call   8010474c <growproc>
80106923:	83 c4 10             	add    $0x10,%esp
80106926:	85 c0                	test   %eax,%eax
80106928:	79 07                	jns    80106931 <sys_sbrk+0x47>
    return -1;
8010692a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010692f:	eb 03                	jmp    80106934 <sys_sbrk+0x4a>
  return addr;
80106931:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106934:	c9                   	leave  
80106935:	c3                   	ret    

80106936 <sys_sleep>:

int
sys_sleep(void)
{
80106936:	55                   	push   %ebp
80106937:	89 e5                	mov    %esp,%ebp
80106939:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010693c:	83 ec 08             	sub    $0x8,%esp
8010693f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106942:	50                   	push   %eax
80106943:	6a 00                	push   $0x0
80106945:	e8 60 f0 ff ff       	call   801059aa <argint>
8010694a:	83 c4 10             	add    $0x10,%esp
8010694d:	85 c0                	test   %eax,%eax
8010694f:	79 07                	jns    80106958 <sys_sleep+0x22>
    return -1;
80106951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106956:	eb 77                	jmp    801069cf <sys_sleep+0x99>
  acquire(&tickslock);
80106958:	83 ec 0c             	sub    $0xc,%esp
8010695b:	68 c0 5d 11 80       	push   $0x80115dc0
80106960:	e8 bd ea ff ff       	call   80105422 <acquire>
80106965:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106968:	a1 00 66 11 80       	mov    0x80116600,%eax
8010696d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106970:	eb 39                	jmp    801069ab <sys_sleep+0x75>
    if(proc->killed){
80106972:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106978:	8b 40 24             	mov    0x24(%eax),%eax
8010697b:	85 c0                	test   %eax,%eax
8010697d:	74 17                	je     80106996 <sys_sleep+0x60>
      release(&tickslock);
8010697f:	83 ec 0c             	sub    $0xc,%esp
80106982:	68 c0 5d 11 80       	push   $0x80115dc0
80106987:	e8 fd ea ff ff       	call   80105489 <release>
8010698c:	83 c4 10             	add    $0x10,%esp
      return -1;
8010698f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106994:	eb 39                	jmp    801069cf <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106996:	83 ec 08             	sub    $0x8,%esp
80106999:	68 c0 5d 11 80       	push   $0x80115dc0
8010699e:	68 00 66 11 80       	push   $0x80116600
801069a3:	e8 e3 e4 ff ff       	call   80104e8b <sleep>
801069a8:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801069ab:	a1 00 66 11 80       	mov    0x80116600,%eax
801069b0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801069b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069b6:	39 d0                	cmp    %edx,%eax
801069b8:	72 b8                	jb     80106972 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801069ba:	83 ec 0c             	sub    $0xc,%esp
801069bd:	68 c0 5d 11 80       	push   $0x80115dc0
801069c2:	e8 c2 ea ff ff       	call   80105489 <release>
801069c7:	83 c4 10             	add    $0x10,%esp
  return 0;
801069ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069cf:	c9                   	leave  
801069d0:	c3                   	ret    

801069d1 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069d1:	55                   	push   %ebp
801069d2:	89 e5                	mov    %esp,%ebp
801069d4:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801069d7:	83 ec 0c             	sub    $0xc,%esp
801069da:	68 c0 5d 11 80       	push   $0x80115dc0
801069df:	e8 3e ea ff ff       	call   80105422 <acquire>
801069e4:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801069e7:	a1 00 66 11 80       	mov    0x80116600,%eax
801069ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801069ef:	83 ec 0c             	sub    $0xc,%esp
801069f2:	68 c0 5d 11 80       	push   $0x80115dc0
801069f7:	e8 8d ea ff ff       	call   80105489 <release>
801069fc:	83 c4 10             	add    $0x10,%esp
  return xticks;
801069ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a02:	c9                   	leave  
80106a03:	c3                   	ret    

80106a04 <sys_halt>:

//Turn of the computer
int sys_halt(void){
80106a04:	55                   	push   %ebp
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80106a0a:	83 ec 0c             	sub    $0xc,%esp
80106a0d:	68 aa 8f 10 80       	push   $0x80108faa
80106a12:	e8 af 99 ff ff       	call   801003c6 <cprintf>
80106a17:	83 c4 10             	add    $0x10,%esp
  outw (0xB004, 0x0 | 0x2000);
80106a1a:	83 ec 08             	sub    $0x8,%esp
80106a1d:	68 00 20 00 00       	push   $0x2000
80106a22:	68 04 b0 00 00       	push   $0xb004
80106a27:	e8 30 fe ff ff       	call   8010685c <outw>
80106a2c:	83 c4 10             	add    $0x10,%esp
  return 0;
80106a2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a34:	c9                   	leave  
80106a35:	c3                   	ret    

80106a36 <sys_date>:

int sys_date(void){
80106a36:	55                   	push   %ebp
80106a37:	89 e5                	mov    %esp,%ebp
80106a39:	83 ec 18             	sub    $0x18,%esp

    struct rtcdate* d;

    if(argptr(0, (char**)&d, sizeof(*d)) <0) //void * is a security issue
80106a3c:	83 ec 04             	sub    $0x4,%esp
80106a3f:	6a 18                	push   $0x18
80106a41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a44:	50                   	push   %eax
80106a45:	6a 00                	push   $0x0
80106a47:	e8 86 ef ff ff       	call   801059d2 <argptr>
80106a4c:	83 c4 10             	add    $0x10,%esp
80106a4f:	85 c0                	test   %eax,%eax
80106a51:	79 07                	jns    80106a5a <sys_date+0x24>
        return -1;
80106a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a58:	eb 14                	jmp    80106a6e <sys_date+0x38>
   
    cmostime(d);
80106a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a5d:	83 ec 0c             	sub    $0xc,%esp
80106a60:	50                   	push   %eax
80106a61:	e8 b2 c7 ff ff       	call   80103218 <cmostime>
80106a66:	83 c4 10             	add    $0x10,%esp
    return 0;
80106a69:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a6e:	c9                   	leave  
80106a6f:	c3                   	ret    

80106a70 <sys_getuid>:


uint
sys_getuid(void)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
    return proc->uid;
80106a73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a79:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80106a7f:	5d                   	pop    %ebp
80106a80:	c3                   	ret    

80106a81 <sys_getgid>:

uint
sys_getgid(void)
{ 
80106a81:	55                   	push   %ebp
80106a82:	89 e5                	mov    %esp,%ebp
    return proc->gid;
80106a84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a8a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106a90:	5d                   	pop    %ebp
80106a91:	c3                   	ret    

80106a92 <sys_getppid>:

uint
sys_getppid(void)
{
80106a92:	55                   	push   %ebp
80106a93:	89 e5                	mov    %esp,%ebp

    if(proc->pid == 1)
80106a95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a9b:	8b 40 10             	mov    0x10(%eax),%eax
80106a9e:	83 f8 01             	cmp    $0x1,%eax
80106aa1:	75 07                	jne    80106aaa <sys_getppid+0x18>
        return 1;
80106aa3:	b8 01 00 00 00       	mov    $0x1,%eax
80106aa8:	eb 0c                	jmp    80106ab6 <sys_getppid+0x24>
    return proc->parent->pid;
80106aaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ab0:	8b 40 14             	mov    0x14(%eax),%eax
80106ab3:	8b 40 10             	mov    0x10(%eax),%eax
}
80106ab6:	5d                   	pop    %ebp
80106ab7:	c3                   	ret    

80106ab8 <sys_setuid>:

int
sys_setuid(void)
{
80106ab8:	55                   	push   %ebp
80106ab9:	89 e5                	mov    %esp,%ebp
80106abb:	83 ec 08             	sub    $0x8,%esp
    

    if(argint(0, (int*)&proc->uid)) 
80106abe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ac4:	83 e8 80             	sub    $0xffffff80,%eax
80106ac7:	83 ec 08             	sub    $0x8,%esp
80106aca:	50                   	push   %eax
80106acb:	6a 00                	push   $0x0
80106acd:	e8 d8 ee ff ff       	call   801059aa <argint>
80106ad2:	83 c4 10             	add    $0x10,%esp
80106ad5:	85 c0                	test   %eax,%eax
80106ad7:	74 07                	je     80106ae0 <sys_setuid+0x28>
        return -1;
80106ad9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ade:	eb 2f                	jmp    80106b0f <sys_setuid+0x57>
    
    if(proc->uid < 0 || proc->uid > 32767){
80106ae0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ae6:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106aec:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106af1:	76 17                	jbe    80106b0a <sys_setuid+0x52>
        proc->uid = 0;
80106af3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106af9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106b00:	00 00 00 
        return -1;
80106b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b08:	eb 05                	jmp    80106b0f <sys_setuid+0x57>
    }
    else
        return 0;
80106b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b0f:	c9                   	leave  
80106b10:	c3                   	ret    

80106b11 <sys_setgid>:

int
sys_setgid(void)
{
80106b11:	55                   	push   %ebp
80106b12:	89 e5                	mov    %esp,%ebp
80106b14:	83 ec 08             	sub    $0x8,%esp

    if(argint(0, (int*)&proc->gid) )
80106b17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b1d:	05 84 00 00 00       	add    $0x84,%eax
80106b22:	83 ec 08             	sub    $0x8,%esp
80106b25:	50                   	push   %eax
80106b26:	6a 00                	push   $0x0
80106b28:	e8 7d ee ff ff       	call   801059aa <argint>
80106b2d:	83 c4 10             	add    $0x10,%esp
80106b30:	85 c0                	test   %eax,%eax
80106b32:	74 07                	je     80106b3b <sys_setgid+0x2a>
        return -1;
80106b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b39:	eb 2f                	jmp    80106b6a <sys_setgid+0x59>
    if(proc->gid < 0 || proc -> gid > 32767){
80106b3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b41:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80106b47:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106b4c:	76 17                	jbe    80106b65 <sys_setgid+0x54>
        proc->gid = 0;
80106b4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b54:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80106b5b:	00 00 00 
        return -1;
80106b5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b63:	eb 05                	jmp    80106b6a <sys_setgid+0x59>
    }
    else 
        return 0;
80106b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b6a:	c9                   	leave  
80106b6b:	c3                   	ret    

80106b6c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106b6c:	55                   	push   %ebp
80106b6d:	89 e5                	mov    %esp,%ebp
80106b6f:	83 ec 08             	sub    $0x8,%esp
80106b72:	8b 55 08             	mov    0x8(%ebp),%edx
80106b75:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b78:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b7c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b7f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106b83:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b87:	ee                   	out    %al,(%dx)
}
80106b88:	90                   	nop
80106b89:	c9                   	leave  
80106b8a:	c3                   	ret    

80106b8b <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106b8b:	55                   	push   %ebp
80106b8c:	89 e5                	mov    %esp,%ebp
80106b8e:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106b91:	6a 34                	push   $0x34
80106b93:	6a 43                	push   $0x43
80106b95:	e8 d2 ff ff ff       	call   80106b6c <outb>
80106b9a:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106b9d:	68 9c 00 00 00       	push   $0x9c
80106ba2:	6a 40                	push   $0x40
80106ba4:	e8 c3 ff ff ff       	call   80106b6c <outb>
80106ba9:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106bac:	6a 2e                	push   $0x2e
80106bae:	6a 40                	push   $0x40
80106bb0:	e8 b7 ff ff ff       	call   80106b6c <outb>
80106bb5:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106bb8:	83 ec 0c             	sub    $0xc,%esp
80106bbb:	6a 00                	push   $0x0
80106bbd:	e8 b9 d3 ff ff       	call   80103f7b <picenable>
80106bc2:	83 c4 10             	add    $0x10,%esp
}
80106bc5:	90                   	nop
80106bc6:	c9                   	leave  
80106bc7:	c3                   	ret    

80106bc8 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106bc8:	1e                   	push   %ds
  pushl %es
80106bc9:	06                   	push   %es
  pushl %fs
80106bca:	0f a0                	push   %fs
  pushl %gs
80106bcc:	0f a8                	push   %gs
  pushal
80106bce:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106bcf:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106bd3:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106bd5:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106bd7:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106bdb:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106bdd:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106bdf:	54                   	push   %esp
  call trap
80106be0:	e8 d7 01 00 00       	call   80106dbc <trap>
  addl $4, %esp
80106be5:	83 c4 04             	add    $0x4,%esp

80106be8 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106be8:	61                   	popa   
  popl %gs
80106be9:	0f a9                	pop    %gs
  popl %fs
80106beb:	0f a1                	pop    %fs
  popl %es
80106bed:	07                   	pop    %es
  popl %ds
80106bee:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106bef:	83 c4 08             	add    $0x8,%esp
  iret
80106bf2:	cf                   	iret   

80106bf3 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106bf3:	55                   	push   %ebp
80106bf4:	89 e5                	mov    %esp,%ebp
80106bf6:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bfc:	83 e8 01             	sub    $0x1,%eax
80106bff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106c03:	8b 45 08             	mov    0x8(%ebp),%eax
80106c06:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0d:	c1 e8 10             	shr    $0x10,%eax
80106c10:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106c14:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106c17:	0f 01 18             	lidtl  (%eax)
}
80106c1a:	90                   	nop
80106c1b:	c9                   	leave  
80106c1c:	c3                   	ret    

80106c1d <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106c1d:	55                   	push   %ebp
80106c1e:	89 e5                	mov    %esp,%ebp
80106c20:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106c23:	0f 20 d0             	mov    %cr2,%eax
80106c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106c2c:	c9                   	leave  
80106c2d:	c3                   	ret    

80106c2e <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106c2e:	55                   	push   %ebp
80106c2f:	89 e5                	mov    %esp,%ebp
80106c31:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106c34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c3b:	e9 c3 00 00 00       	jmp    80106d03 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c43:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106c4a:	89 c2                	mov    %eax,%edx
80106c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c4f:	66 89 14 c5 00 5e 11 	mov    %dx,-0x7feea200(,%eax,8)
80106c56:	80 
80106c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c5a:	66 c7 04 c5 02 5e 11 	movw   $0x8,-0x7feea1fe(,%eax,8)
80106c61:	80 08 00 
80106c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c67:	0f b6 14 c5 04 5e 11 	movzbl -0x7feea1fc(,%eax,8),%edx
80106c6e:	80 
80106c6f:	83 e2 e0             	and    $0xffffffe0,%edx
80106c72:	88 14 c5 04 5e 11 80 	mov    %dl,-0x7feea1fc(,%eax,8)
80106c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c7c:	0f b6 14 c5 04 5e 11 	movzbl -0x7feea1fc(,%eax,8),%edx
80106c83:	80 
80106c84:	83 e2 1f             	and    $0x1f,%edx
80106c87:	88 14 c5 04 5e 11 80 	mov    %dl,-0x7feea1fc(,%eax,8)
80106c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c91:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106c98:	80 
80106c99:	83 e2 f0             	and    $0xfffffff0,%edx
80106c9c:	83 ca 0e             	or     $0xe,%edx
80106c9f:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ca9:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106cb0:	80 
80106cb1:	83 e2 ef             	and    $0xffffffef,%edx
80106cb4:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cbe:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106cc5:	80 
80106cc6:	83 e2 9f             	and    $0xffffff9f,%edx
80106cc9:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd3:	0f b6 14 c5 05 5e 11 	movzbl -0x7feea1fb(,%eax,8),%edx
80106cda:	80 
80106cdb:	83 ca 80             	or     $0xffffff80,%edx
80106cde:	88 14 c5 05 5e 11 80 	mov    %dl,-0x7feea1fb(,%eax,8)
80106ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ce8:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106cef:	c1 e8 10             	shr    $0x10,%eax
80106cf2:	89 c2                	mov    %eax,%edx
80106cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf7:	66 89 14 c5 06 5e 11 	mov    %dx,-0x7feea1fa(,%eax,8)
80106cfe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106cff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d03:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106d0a:	0f 8e 30 ff ff ff    	jle    80106c40 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106d10:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106d15:	66 a3 00 60 11 80    	mov    %ax,0x80116000
80106d1b:	66 c7 05 02 60 11 80 	movw   $0x8,0x80116002
80106d22:	08 00 
80106d24:	0f b6 05 04 60 11 80 	movzbl 0x80116004,%eax
80106d2b:	83 e0 e0             	and    $0xffffffe0,%eax
80106d2e:	a2 04 60 11 80       	mov    %al,0x80116004
80106d33:	0f b6 05 04 60 11 80 	movzbl 0x80116004,%eax
80106d3a:	83 e0 1f             	and    $0x1f,%eax
80106d3d:	a2 04 60 11 80       	mov    %al,0x80116004
80106d42:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
80106d49:	83 c8 0f             	or     $0xf,%eax
80106d4c:	a2 05 60 11 80       	mov    %al,0x80116005
80106d51:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
80106d58:	83 e0 ef             	and    $0xffffffef,%eax
80106d5b:	a2 05 60 11 80       	mov    %al,0x80116005
80106d60:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
80106d67:	83 c8 60             	or     $0x60,%eax
80106d6a:	a2 05 60 11 80       	mov    %al,0x80116005
80106d6f:	0f b6 05 05 60 11 80 	movzbl 0x80116005,%eax
80106d76:	83 c8 80             	or     $0xffffff80,%eax
80106d79:	a2 05 60 11 80       	mov    %al,0x80116005
80106d7e:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106d83:	c1 e8 10             	shr    $0x10,%eax
80106d86:	66 a3 06 60 11 80    	mov    %ax,0x80116006
  
  initlock(&tickslock, "time");
80106d8c:	83 ec 08             	sub    $0x8,%esp
80106d8f:	68 c0 8f 10 80       	push   $0x80108fc0
80106d94:	68 c0 5d 11 80       	push   $0x80115dc0
80106d99:	e8 62 e6 ff ff       	call   80105400 <initlock>
80106d9e:	83 c4 10             	add    $0x10,%esp
}
80106da1:	90                   	nop
80106da2:	c9                   	leave  
80106da3:	c3                   	ret    

80106da4 <idtinit>:

void
idtinit(void)
{
80106da4:	55                   	push   %ebp
80106da5:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106da7:	68 00 08 00 00       	push   $0x800
80106dac:	68 00 5e 11 80       	push   $0x80115e00
80106db1:	e8 3d fe ff ff       	call   80106bf3 <lidt>
80106db6:	83 c4 08             	add    $0x8,%esp
}
80106db9:	90                   	nop
80106dba:	c9                   	leave  
80106dbb:	c3                   	ret    

80106dbc <trap>:

void
trap(struct trapframe *tf)
{
80106dbc:	55                   	push   %ebp
80106dbd:	89 e5                	mov    %esp,%ebp
80106dbf:	57                   	push   %edi
80106dc0:	56                   	push   %esi
80106dc1:	53                   	push   %ebx
80106dc2:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc8:	8b 40 30             	mov    0x30(%eax),%eax
80106dcb:	83 f8 40             	cmp    $0x40,%eax
80106dce:	75 3e                	jne    80106e0e <trap+0x52>
    if(proc->killed)
80106dd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dd6:	8b 40 24             	mov    0x24(%eax),%eax
80106dd9:	85 c0                	test   %eax,%eax
80106ddb:	74 05                	je     80106de2 <trap+0x26>
      exit();
80106ddd:	e8 c8 db ff ff       	call   801049aa <exit>
    proc->tf = tf;
80106de2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106de8:	8b 55 08             	mov    0x8(%ebp),%edx
80106deb:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106dee:	e8 6d ec ff ff       	call   80105a60 <syscall>
    if(proc->killed)
80106df3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106df9:	8b 40 24             	mov    0x24(%eax),%eax
80106dfc:	85 c0                	test   %eax,%eax
80106dfe:	0f 84 1b 02 00 00    	je     8010701f <trap+0x263>
      exit();
80106e04:	e8 a1 db ff ff       	call   801049aa <exit>
    return;
80106e09:	e9 11 02 00 00       	jmp    8010701f <trap+0x263>
  }

  switch(tf->trapno){
80106e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80106e11:	8b 40 30             	mov    0x30(%eax),%eax
80106e14:	83 e8 20             	sub    $0x20,%eax
80106e17:	83 f8 1f             	cmp    $0x1f,%eax
80106e1a:	0f 87 c0 00 00 00    	ja     80106ee0 <trap+0x124>
80106e20:	8b 04 85 68 90 10 80 	mov    -0x7fef6f98(,%eax,4),%eax
80106e27:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106e29:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e2f:	0f b6 00             	movzbl (%eax),%eax
80106e32:	84 c0                	test   %al,%al
80106e34:	75 3d                	jne    80106e73 <trap+0xb7>
      acquire(&tickslock);
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	68 c0 5d 11 80       	push   $0x80115dc0
80106e3e:	e8 df e5 ff ff       	call   80105422 <acquire>
80106e43:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106e46:	a1 00 66 11 80       	mov    0x80116600,%eax
80106e4b:	83 c0 01             	add    $0x1,%eax
80106e4e:	a3 00 66 11 80       	mov    %eax,0x80116600
      release(&tickslock);    // NOTE: MarkM has reversed these two lines.
80106e53:	83 ec 0c             	sub    $0xc,%esp
80106e56:	68 c0 5d 11 80       	push   $0x80115dc0
80106e5b:	e8 29 e6 ff ff       	call   80105489 <release>
80106e60:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);         // wakeup() should not require the tickslock to be held
80106e63:	83 ec 0c             	sub    $0xc,%esp
80106e66:	68 00 66 11 80       	push   $0x80116600
80106e6b:	e8 09 e1 ff ff       	call   80104f79 <wakeup>
80106e70:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106e73:	e8 fd c1 ff ff       	call   80103075 <lapiceoi>
    break;
80106e78:	e9 1c 01 00 00       	jmp    80106f99 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106e7d:	e8 06 ba ff ff       	call   80102888 <ideintr>
    lapiceoi();
80106e82:	e8 ee c1 ff ff       	call   80103075 <lapiceoi>
    break;
80106e87:	e9 0d 01 00 00       	jmp    80106f99 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106e8c:	e8 e6 bf ff ff       	call   80102e77 <kbdintr>
    lapiceoi();
80106e91:	e8 df c1 ff ff       	call   80103075 <lapiceoi>
    break;
80106e96:	e9 fe 00 00 00       	jmp    80106f99 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106e9b:	e8 60 03 00 00       	call   80107200 <uartintr>
    lapiceoi();
80106ea0:	e8 d0 c1 ff ff       	call   80103075 <lapiceoi>
    break;
80106ea5:	e9 ef 00 00 00       	jmp    80106f99 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80106ead:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106eb7:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106eba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ec0:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ec3:	0f b6 c0             	movzbl %al,%eax
80106ec6:	51                   	push   %ecx
80106ec7:	52                   	push   %edx
80106ec8:	50                   	push   %eax
80106ec9:	68 c8 8f 10 80       	push   $0x80108fc8
80106ece:	e8 f3 94 ff ff       	call   801003c6 <cprintf>
80106ed3:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106ed6:	e8 9a c1 ff ff       	call   80103075 <lapiceoi>
    break;
80106edb:	e9 b9 00 00 00       	jmp    80106f99 <trap+0x1dd>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106ee0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ee6:	85 c0                	test   %eax,%eax
80106ee8:	74 11                	je     80106efb <trap+0x13f>
80106eea:	8b 45 08             	mov    0x8(%ebp),%eax
80106eed:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ef1:	0f b7 c0             	movzwl %ax,%eax
80106ef4:	83 e0 03             	and    $0x3,%eax
80106ef7:	85 c0                	test   %eax,%eax
80106ef9:	75 40                	jne    80106f3b <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106efb:	e8 1d fd ff ff       	call   80106c1d <rcr2>
80106f00:	89 c3                	mov    %eax,%ebx
80106f02:	8b 45 08             	mov    0x8(%ebp),%eax
80106f05:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106f08:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f0e:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f11:	0f b6 d0             	movzbl %al,%edx
80106f14:	8b 45 08             	mov    0x8(%ebp),%eax
80106f17:	8b 40 30             	mov    0x30(%eax),%eax
80106f1a:	83 ec 0c             	sub    $0xc,%esp
80106f1d:	53                   	push   %ebx
80106f1e:	51                   	push   %ecx
80106f1f:	52                   	push   %edx
80106f20:	50                   	push   %eax
80106f21:	68 ec 8f 10 80       	push   $0x80108fec
80106f26:	e8 9b 94 ff ff       	call   801003c6 <cprintf>
80106f2b:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106f2e:	83 ec 0c             	sub    $0xc,%esp
80106f31:	68 1e 90 10 80       	push   $0x8010901e
80106f36:	e8 2b 96 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f3b:	e8 dd fc ff ff       	call   80106c1d <rcr2>
80106f40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f43:	8b 45 08             	mov    0x8(%ebp),%eax
80106f46:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106f49:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f4f:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f52:	0f b6 d8             	movzbl %al,%ebx
80106f55:	8b 45 08             	mov    0x8(%ebp),%eax
80106f58:	8b 48 34             	mov    0x34(%eax),%ecx
80106f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5e:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106f61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f67:	8d 78 6c             	lea    0x6c(%eax),%edi
80106f6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f70:	8b 40 10             	mov    0x10(%eax),%eax
80106f73:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f76:	56                   	push   %esi
80106f77:	53                   	push   %ebx
80106f78:	51                   	push   %ecx
80106f79:	52                   	push   %edx
80106f7a:	57                   	push   %edi
80106f7b:	50                   	push   %eax
80106f7c:	68 24 90 10 80       	push   $0x80109024
80106f81:	e8 40 94 ff ff       	call   801003c6 <cprintf>
80106f86:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106f89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f8f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106f96:	eb 01                	jmp    80106f99 <trap+0x1dd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106f98:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f9f:	85 c0                	test   %eax,%eax
80106fa1:	74 24                	je     80106fc7 <trap+0x20b>
80106fa3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fa9:	8b 40 24             	mov    0x24(%eax),%eax
80106fac:	85 c0                	test   %eax,%eax
80106fae:	74 17                	je     80106fc7 <trap+0x20b>
80106fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106fb3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106fb7:	0f b7 c0             	movzwl %ax,%eax
80106fba:	83 e0 03             	and    $0x3,%eax
80106fbd:	83 f8 03             	cmp    $0x3,%eax
80106fc0:	75 05                	jne    80106fc7 <trap+0x20b>
    exit();
80106fc2:	e8 e3 d9 ff ff       	call   801049aa <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106fc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fcd:	85 c0                	test   %eax,%eax
80106fcf:	74 1e                	je     80106fef <trap+0x233>
80106fd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd7:	8b 40 0c             	mov    0xc(%eax),%eax
80106fda:	83 f8 04             	cmp    $0x4,%eax
80106fdd:	75 10                	jne    80106fef <trap+0x233>
80106fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe2:	8b 40 30             	mov    0x30(%eax),%eax
80106fe5:	83 f8 20             	cmp    $0x20,%eax
80106fe8:	75 05                	jne    80106fef <trap+0x233>
    yield();
80106fea:	e8 1b de ff ff       	call   80104e0a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106fef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ff5:	85 c0                	test   %eax,%eax
80106ff7:	74 27                	je     80107020 <trap+0x264>
80106ff9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fff:	8b 40 24             	mov    0x24(%eax),%eax
80107002:	85 c0                	test   %eax,%eax
80107004:	74 1a                	je     80107020 <trap+0x264>
80107006:	8b 45 08             	mov    0x8(%ebp),%eax
80107009:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010700d:	0f b7 c0             	movzwl %ax,%eax
80107010:	83 e0 03             	and    $0x3,%eax
80107013:	83 f8 03             	cmp    $0x3,%eax
80107016:	75 08                	jne    80107020 <trap+0x264>
    exit();
80107018:	e8 8d d9 ff ff       	call   801049aa <exit>
8010701d:	eb 01                	jmp    80107020 <trap+0x264>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
8010701f:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107023:	5b                   	pop    %ebx
80107024:	5e                   	pop    %esi
80107025:	5f                   	pop    %edi
80107026:	5d                   	pop    %ebp
80107027:	c3                   	ret    

80107028 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107028:	55                   	push   %ebp
80107029:	89 e5                	mov    %esp,%ebp
8010702b:	83 ec 14             	sub    $0x14,%esp
8010702e:	8b 45 08             	mov    0x8(%ebp),%eax
80107031:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107035:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107039:	89 c2                	mov    %eax,%edx
8010703b:	ec                   	in     (%dx),%al
8010703c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010703f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107043:	c9                   	leave  
80107044:	c3                   	ret    

80107045 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107045:	55                   	push   %ebp
80107046:	89 e5                	mov    %esp,%ebp
80107048:	83 ec 08             	sub    $0x8,%esp
8010704b:	8b 55 08             	mov    0x8(%ebp),%edx
8010704e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107051:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107055:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107058:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010705c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107060:	ee                   	out    %al,(%dx)
}
80107061:	90                   	nop
80107062:	c9                   	leave  
80107063:	c3                   	ret    

80107064 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107064:	55                   	push   %ebp
80107065:	89 e5                	mov    %esp,%ebp
80107067:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010706a:	6a 00                	push   $0x0
8010706c:	68 fa 03 00 00       	push   $0x3fa
80107071:	e8 cf ff ff ff       	call   80107045 <outb>
80107076:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107079:	68 80 00 00 00       	push   $0x80
8010707e:	68 fb 03 00 00       	push   $0x3fb
80107083:	e8 bd ff ff ff       	call   80107045 <outb>
80107088:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010708b:	6a 0c                	push   $0xc
8010708d:	68 f8 03 00 00       	push   $0x3f8
80107092:	e8 ae ff ff ff       	call   80107045 <outb>
80107097:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010709a:	6a 00                	push   $0x0
8010709c:	68 f9 03 00 00       	push   $0x3f9
801070a1:	e8 9f ff ff ff       	call   80107045 <outb>
801070a6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801070a9:	6a 03                	push   $0x3
801070ab:	68 fb 03 00 00       	push   $0x3fb
801070b0:	e8 90 ff ff ff       	call   80107045 <outb>
801070b5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801070b8:	6a 00                	push   $0x0
801070ba:	68 fc 03 00 00       	push   $0x3fc
801070bf:	e8 81 ff ff ff       	call   80107045 <outb>
801070c4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801070c7:	6a 01                	push   $0x1
801070c9:	68 f9 03 00 00       	push   $0x3f9
801070ce:	e8 72 ff ff ff       	call   80107045 <outb>
801070d3:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801070d6:	68 fd 03 00 00       	push   $0x3fd
801070db:	e8 48 ff ff ff       	call   80107028 <inb>
801070e0:	83 c4 04             	add    $0x4,%esp
801070e3:	3c ff                	cmp    $0xff,%al
801070e5:	74 6e                	je     80107155 <uartinit+0xf1>
    return;
  uart = 1;
801070e7:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
801070ee:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801070f1:	68 fa 03 00 00       	push   $0x3fa
801070f6:	e8 2d ff ff ff       	call   80107028 <inb>
801070fb:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801070fe:	68 f8 03 00 00       	push   $0x3f8
80107103:	e8 20 ff ff ff       	call   80107028 <inb>
80107108:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010710b:	83 ec 0c             	sub    $0xc,%esp
8010710e:	6a 04                	push   $0x4
80107110:	e8 66 ce ff ff       	call   80103f7b <picenable>
80107115:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107118:	83 ec 08             	sub    $0x8,%esp
8010711b:	6a 00                	push   $0x0
8010711d:	6a 04                	push   $0x4
8010711f:	e8 06 ba ff ff       	call   80102b2a <ioapicenable>
80107124:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107127:	c7 45 f4 e8 90 10 80 	movl   $0x801090e8,-0xc(%ebp)
8010712e:	eb 19                	jmp    80107149 <uartinit+0xe5>
    uartputc(*p);
80107130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107133:	0f b6 00             	movzbl (%eax),%eax
80107136:	0f be c0             	movsbl %al,%eax
80107139:	83 ec 0c             	sub    $0xc,%esp
8010713c:	50                   	push   %eax
8010713d:	e8 16 00 00 00       	call   80107158 <uartputc>
80107142:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107145:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010714c:	0f b6 00             	movzbl (%eax),%eax
8010714f:	84 c0                	test   %al,%al
80107151:	75 dd                	jne    80107130 <uartinit+0xcc>
80107153:	eb 01                	jmp    80107156 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107155:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107156:	c9                   	leave  
80107157:	c3                   	ret    

80107158 <uartputc>:

void
uartputc(int c)
{
80107158:	55                   	push   %ebp
80107159:	89 e5                	mov    %esp,%ebp
8010715b:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010715e:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107163:	85 c0                	test   %eax,%eax
80107165:	74 53                	je     801071ba <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107167:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010716e:	eb 11                	jmp    80107181 <uartputc+0x29>
    microdelay(10);
80107170:	83 ec 0c             	sub    $0xc,%esp
80107173:	6a 0a                	push   $0xa
80107175:	e8 16 bf ff ff       	call   80103090 <microdelay>
8010717a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010717d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107181:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107185:	7f 1a                	jg     801071a1 <uartputc+0x49>
80107187:	83 ec 0c             	sub    $0xc,%esp
8010718a:	68 fd 03 00 00       	push   $0x3fd
8010718f:	e8 94 fe ff ff       	call   80107028 <inb>
80107194:	83 c4 10             	add    $0x10,%esp
80107197:	0f b6 c0             	movzbl %al,%eax
8010719a:	83 e0 20             	and    $0x20,%eax
8010719d:	85 c0                	test   %eax,%eax
8010719f:	74 cf                	je     80107170 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801071a1:	8b 45 08             	mov    0x8(%ebp),%eax
801071a4:	0f b6 c0             	movzbl %al,%eax
801071a7:	83 ec 08             	sub    $0x8,%esp
801071aa:	50                   	push   %eax
801071ab:	68 f8 03 00 00       	push   $0x3f8
801071b0:	e8 90 fe ff ff       	call   80107045 <outb>
801071b5:	83 c4 10             	add    $0x10,%esp
801071b8:	eb 01                	jmp    801071bb <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801071ba:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801071bb:	c9                   	leave  
801071bc:	c3                   	ret    

801071bd <uartgetc>:

static int
uartgetc(void)
{
801071bd:	55                   	push   %ebp
801071be:	89 e5                	mov    %esp,%ebp
  if(!uart)
801071c0:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801071c5:	85 c0                	test   %eax,%eax
801071c7:	75 07                	jne    801071d0 <uartgetc+0x13>
    return -1;
801071c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071ce:	eb 2e                	jmp    801071fe <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801071d0:	68 fd 03 00 00       	push   $0x3fd
801071d5:	e8 4e fe ff ff       	call   80107028 <inb>
801071da:	83 c4 04             	add    $0x4,%esp
801071dd:	0f b6 c0             	movzbl %al,%eax
801071e0:	83 e0 01             	and    $0x1,%eax
801071e3:	85 c0                	test   %eax,%eax
801071e5:	75 07                	jne    801071ee <uartgetc+0x31>
    return -1;
801071e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071ec:	eb 10                	jmp    801071fe <uartgetc+0x41>
  return inb(COM1+0);
801071ee:	68 f8 03 00 00       	push   $0x3f8
801071f3:	e8 30 fe ff ff       	call   80107028 <inb>
801071f8:	83 c4 04             	add    $0x4,%esp
801071fb:	0f b6 c0             	movzbl %al,%eax
}
801071fe:	c9                   	leave  
801071ff:	c3                   	ret    

80107200 <uartintr>:

void
uartintr(void)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	68 bd 71 10 80       	push   $0x801071bd
8010720e:	e8 e6 95 ff ff       	call   801007f9 <consoleintr>
80107213:	83 c4 10             	add    $0x10,%esp
}
80107216:	90                   	nop
80107217:	c9                   	leave  
80107218:	c3                   	ret    

80107219 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $0
8010721b:	6a 00                	push   $0x0
  jmp alltraps
8010721d:	e9 a6 f9 ff ff       	jmp    80106bc8 <alltraps>

80107222 <vector1>:
.globl vector1
vector1:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $1
80107224:	6a 01                	push   $0x1
  jmp alltraps
80107226:	e9 9d f9 ff ff       	jmp    80106bc8 <alltraps>

8010722b <vector2>:
.globl vector2
vector2:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $2
8010722d:	6a 02                	push   $0x2
  jmp alltraps
8010722f:	e9 94 f9 ff ff       	jmp    80106bc8 <alltraps>

80107234 <vector3>:
.globl vector3
vector3:
  pushl $0
80107234:	6a 00                	push   $0x0
  pushl $3
80107236:	6a 03                	push   $0x3
  jmp alltraps
80107238:	e9 8b f9 ff ff       	jmp    80106bc8 <alltraps>

8010723d <vector4>:
.globl vector4
vector4:
  pushl $0
8010723d:	6a 00                	push   $0x0
  pushl $4
8010723f:	6a 04                	push   $0x4
  jmp alltraps
80107241:	e9 82 f9 ff ff       	jmp    80106bc8 <alltraps>

80107246 <vector5>:
.globl vector5
vector5:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $5
80107248:	6a 05                	push   $0x5
  jmp alltraps
8010724a:	e9 79 f9 ff ff       	jmp    80106bc8 <alltraps>

8010724f <vector6>:
.globl vector6
vector6:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $6
80107251:	6a 06                	push   $0x6
  jmp alltraps
80107253:	e9 70 f9 ff ff       	jmp    80106bc8 <alltraps>

80107258 <vector7>:
.globl vector7
vector7:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $7
8010725a:	6a 07                	push   $0x7
  jmp alltraps
8010725c:	e9 67 f9 ff ff       	jmp    80106bc8 <alltraps>

80107261 <vector8>:
.globl vector8
vector8:
  pushl $8
80107261:	6a 08                	push   $0x8
  jmp alltraps
80107263:	e9 60 f9 ff ff       	jmp    80106bc8 <alltraps>

80107268 <vector9>:
.globl vector9
vector9:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $9
8010726a:	6a 09                	push   $0x9
  jmp alltraps
8010726c:	e9 57 f9 ff ff       	jmp    80106bc8 <alltraps>

80107271 <vector10>:
.globl vector10
vector10:
  pushl $10
80107271:	6a 0a                	push   $0xa
  jmp alltraps
80107273:	e9 50 f9 ff ff       	jmp    80106bc8 <alltraps>

80107278 <vector11>:
.globl vector11
vector11:
  pushl $11
80107278:	6a 0b                	push   $0xb
  jmp alltraps
8010727a:	e9 49 f9 ff ff       	jmp    80106bc8 <alltraps>

8010727f <vector12>:
.globl vector12
vector12:
  pushl $12
8010727f:	6a 0c                	push   $0xc
  jmp alltraps
80107281:	e9 42 f9 ff ff       	jmp    80106bc8 <alltraps>

80107286 <vector13>:
.globl vector13
vector13:
  pushl $13
80107286:	6a 0d                	push   $0xd
  jmp alltraps
80107288:	e9 3b f9 ff ff       	jmp    80106bc8 <alltraps>

8010728d <vector14>:
.globl vector14
vector14:
  pushl $14
8010728d:	6a 0e                	push   $0xe
  jmp alltraps
8010728f:	e9 34 f9 ff ff       	jmp    80106bc8 <alltraps>

80107294 <vector15>:
.globl vector15
vector15:
  pushl $0
80107294:	6a 00                	push   $0x0
  pushl $15
80107296:	6a 0f                	push   $0xf
  jmp alltraps
80107298:	e9 2b f9 ff ff       	jmp    80106bc8 <alltraps>

8010729d <vector16>:
.globl vector16
vector16:
  pushl $0
8010729d:	6a 00                	push   $0x0
  pushl $16
8010729f:	6a 10                	push   $0x10
  jmp alltraps
801072a1:	e9 22 f9 ff ff       	jmp    80106bc8 <alltraps>

801072a6 <vector17>:
.globl vector17
vector17:
  pushl $17
801072a6:	6a 11                	push   $0x11
  jmp alltraps
801072a8:	e9 1b f9 ff ff       	jmp    80106bc8 <alltraps>

801072ad <vector18>:
.globl vector18
vector18:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $18
801072af:	6a 12                	push   $0x12
  jmp alltraps
801072b1:	e9 12 f9 ff ff       	jmp    80106bc8 <alltraps>

801072b6 <vector19>:
.globl vector19
vector19:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $19
801072b8:	6a 13                	push   $0x13
  jmp alltraps
801072ba:	e9 09 f9 ff ff       	jmp    80106bc8 <alltraps>

801072bf <vector20>:
.globl vector20
vector20:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $20
801072c1:	6a 14                	push   $0x14
  jmp alltraps
801072c3:	e9 00 f9 ff ff       	jmp    80106bc8 <alltraps>

801072c8 <vector21>:
.globl vector21
vector21:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $21
801072ca:	6a 15                	push   $0x15
  jmp alltraps
801072cc:	e9 f7 f8 ff ff       	jmp    80106bc8 <alltraps>

801072d1 <vector22>:
.globl vector22
vector22:
  pushl $0
801072d1:	6a 00                	push   $0x0
  pushl $22
801072d3:	6a 16                	push   $0x16
  jmp alltraps
801072d5:	e9 ee f8 ff ff       	jmp    80106bc8 <alltraps>

801072da <vector23>:
.globl vector23
vector23:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $23
801072dc:	6a 17                	push   $0x17
  jmp alltraps
801072de:	e9 e5 f8 ff ff       	jmp    80106bc8 <alltraps>

801072e3 <vector24>:
.globl vector24
vector24:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $24
801072e5:	6a 18                	push   $0x18
  jmp alltraps
801072e7:	e9 dc f8 ff ff       	jmp    80106bc8 <alltraps>

801072ec <vector25>:
.globl vector25
vector25:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $25
801072ee:	6a 19                	push   $0x19
  jmp alltraps
801072f0:	e9 d3 f8 ff ff       	jmp    80106bc8 <alltraps>

801072f5 <vector26>:
.globl vector26
vector26:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $26
801072f7:	6a 1a                	push   $0x1a
  jmp alltraps
801072f9:	e9 ca f8 ff ff       	jmp    80106bc8 <alltraps>

801072fe <vector27>:
.globl vector27
vector27:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $27
80107300:	6a 1b                	push   $0x1b
  jmp alltraps
80107302:	e9 c1 f8 ff ff       	jmp    80106bc8 <alltraps>

80107307 <vector28>:
.globl vector28
vector28:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $28
80107309:	6a 1c                	push   $0x1c
  jmp alltraps
8010730b:	e9 b8 f8 ff ff       	jmp    80106bc8 <alltraps>

80107310 <vector29>:
.globl vector29
vector29:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $29
80107312:	6a 1d                	push   $0x1d
  jmp alltraps
80107314:	e9 af f8 ff ff       	jmp    80106bc8 <alltraps>

80107319 <vector30>:
.globl vector30
vector30:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $30
8010731b:	6a 1e                	push   $0x1e
  jmp alltraps
8010731d:	e9 a6 f8 ff ff       	jmp    80106bc8 <alltraps>

80107322 <vector31>:
.globl vector31
vector31:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $31
80107324:	6a 1f                	push   $0x1f
  jmp alltraps
80107326:	e9 9d f8 ff ff       	jmp    80106bc8 <alltraps>

8010732b <vector32>:
.globl vector32
vector32:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $32
8010732d:	6a 20                	push   $0x20
  jmp alltraps
8010732f:	e9 94 f8 ff ff       	jmp    80106bc8 <alltraps>

80107334 <vector33>:
.globl vector33
vector33:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $33
80107336:	6a 21                	push   $0x21
  jmp alltraps
80107338:	e9 8b f8 ff ff       	jmp    80106bc8 <alltraps>

8010733d <vector34>:
.globl vector34
vector34:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $34
8010733f:	6a 22                	push   $0x22
  jmp alltraps
80107341:	e9 82 f8 ff ff       	jmp    80106bc8 <alltraps>

80107346 <vector35>:
.globl vector35
vector35:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $35
80107348:	6a 23                	push   $0x23
  jmp alltraps
8010734a:	e9 79 f8 ff ff       	jmp    80106bc8 <alltraps>

8010734f <vector36>:
.globl vector36
vector36:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $36
80107351:	6a 24                	push   $0x24
  jmp alltraps
80107353:	e9 70 f8 ff ff       	jmp    80106bc8 <alltraps>

80107358 <vector37>:
.globl vector37
vector37:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $37
8010735a:	6a 25                	push   $0x25
  jmp alltraps
8010735c:	e9 67 f8 ff ff       	jmp    80106bc8 <alltraps>

80107361 <vector38>:
.globl vector38
vector38:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $38
80107363:	6a 26                	push   $0x26
  jmp alltraps
80107365:	e9 5e f8 ff ff       	jmp    80106bc8 <alltraps>

8010736a <vector39>:
.globl vector39
vector39:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $39
8010736c:	6a 27                	push   $0x27
  jmp alltraps
8010736e:	e9 55 f8 ff ff       	jmp    80106bc8 <alltraps>

80107373 <vector40>:
.globl vector40
vector40:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $40
80107375:	6a 28                	push   $0x28
  jmp alltraps
80107377:	e9 4c f8 ff ff       	jmp    80106bc8 <alltraps>

8010737c <vector41>:
.globl vector41
vector41:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $41
8010737e:	6a 29                	push   $0x29
  jmp alltraps
80107380:	e9 43 f8 ff ff       	jmp    80106bc8 <alltraps>

80107385 <vector42>:
.globl vector42
vector42:
  pushl $0
80107385:	6a 00                	push   $0x0
  pushl $42
80107387:	6a 2a                	push   $0x2a
  jmp alltraps
80107389:	e9 3a f8 ff ff       	jmp    80106bc8 <alltraps>

8010738e <vector43>:
.globl vector43
vector43:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $43
80107390:	6a 2b                	push   $0x2b
  jmp alltraps
80107392:	e9 31 f8 ff ff       	jmp    80106bc8 <alltraps>

80107397 <vector44>:
.globl vector44
vector44:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $44
80107399:	6a 2c                	push   $0x2c
  jmp alltraps
8010739b:	e9 28 f8 ff ff       	jmp    80106bc8 <alltraps>

801073a0 <vector45>:
.globl vector45
vector45:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $45
801073a2:	6a 2d                	push   $0x2d
  jmp alltraps
801073a4:	e9 1f f8 ff ff       	jmp    80106bc8 <alltraps>

801073a9 <vector46>:
.globl vector46
vector46:
  pushl $0
801073a9:	6a 00                	push   $0x0
  pushl $46
801073ab:	6a 2e                	push   $0x2e
  jmp alltraps
801073ad:	e9 16 f8 ff ff       	jmp    80106bc8 <alltraps>

801073b2 <vector47>:
.globl vector47
vector47:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $47
801073b4:	6a 2f                	push   $0x2f
  jmp alltraps
801073b6:	e9 0d f8 ff ff       	jmp    80106bc8 <alltraps>

801073bb <vector48>:
.globl vector48
vector48:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $48
801073bd:	6a 30                	push   $0x30
  jmp alltraps
801073bf:	e9 04 f8 ff ff       	jmp    80106bc8 <alltraps>

801073c4 <vector49>:
.globl vector49
vector49:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $49
801073c6:	6a 31                	push   $0x31
  jmp alltraps
801073c8:	e9 fb f7 ff ff       	jmp    80106bc8 <alltraps>

801073cd <vector50>:
.globl vector50
vector50:
  pushl $0
801073cd:	6a 00                	push   $0x0
  pushl $50
801073cf:	6a 32                	push   $0x32
  jmp alltraps
801073d1:	e9 f2 f7 ff ff       	jmp    80106bc8 <alltraps>

801073d6 <vector51>:
.globl vector51
vector51:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $51
801073d8:	6a 33                	push   $0x33
  jmp alltraps
801073da:	e9 e9 f7 ff ff       	jmp    80106bc8 <alltraps>

801073df <vector52>:
.globl vector52
vector52:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $52
801073e1:	6a 34                	push   $0x34
  jmp alltraps
801073e3:	e9 e0 f7 ff ff       	jmp    80106bc8 <alltraps>

801073e8 <vector53>:
.globl vector53
vector53:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $53
801073ea:	6a 35                	push   $0x35
  jmp alltraps
801073ec:	e9 d7 f7 ff ff       	jmp    80106bc8 <alltraps>

801073f1 <vector54>:
.globl vector54
vector54:
  pushl $0
801073f1:	6a 00                	push   $0x0
  pushl $54
801073f3:	6a 36                	push   $0x36
  jmp alltraps
801073f5:	e9 ce f7 ff ff       	jmp    80106bc8 <alltraps>

801073fa <vector55>:
.globl vector55
vector55:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $55
801073fc:	6a 37                	push   $0x37
  jmp alltraps
801073fe:	e9 c5 f7 ff ff       	jmp    80106bc8 <alltraps>

80107403 <vector56>:
.globl vector56
vector56:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $56
80107405:	6a 38                	push   $0x38
  jmp alltraps
80107407:	e9 bc f7 ff ff       	jmp    80106bc8 <alltraps>

8010740c <vector57>:
.globl vector57
vector57:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $57
8010740e:	6a 39                	push   $0x39
  jmp alltraps
80107410:	e9 b3 f7 ff ff       	jmp    80106bc8 <alltraps>

80107415 <vector58>:
.globl vector58
vector58:
  pushl $0
80107415:	6a 00                	push   $0x0
  pushl $58
80107417:	6a 3a                	push   $0x3a
  jmp alltraps
80107419:	e9 aa f7 ff ff       	jmp    80106bc8 <alltraps>

8010741e <vector59>:
.globl vector59
vector59:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $59
80107420:	6a 3b                	push   $0x3b
  jmp alltraps
80107422:	e9 a1 f7 ff ff       	jmp    80106bc8 <alltraps>

80107427 <vector60>:
.globl vector60
vector60:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $60
80107429:	6a 3c                	push   $0x3c
  jmp alltraps
8010742b:	e9 98 f7 ff ff       	jmp    80106bc8 <alltraps>

80107430 <vector61>:
.globl vector61
vector61:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $61
80107432:	6a 3d                	push   $0x3d
  jmp alltraps
80107434:	e9 8f f7 ff ff       	jmp    80106bc8 <alltraps>

80107439 <vector62>:
.globl vector62
vector62:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $62
8010743b:	6a 3e                	push   $0x3e
  jmp alltraps
8010743d:	e9 86 f7 ff ff       	jmp    80106bc8 <alltraps>

80107442 <vector63>:
.globl vector63
vector63:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $63
80107444:	6a 3f                	push   $0x3f
  jmp alltraps
80107446:	e9 7d f7 ff ff       	jmp    80106bc8 <alltraps>

8010744b <vector64>:
.globl vector64
vector64:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $64
8010744d:	6a 40                	push   $0x40
  jmp alltraps
8010744f:	e9 74 f7 ff ff       	jmp    80106bc8 <alltraps>

80107454 <vector65>:
.globl vector65
vector65:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $65
80107456:	6a 41                	push   $0x41
  jmp alltraps
80107458:	e9 6b f7 ff ff       	jmp    80106bc8 <alltraps>

8010745d <vector66>:
.globl vector66
vector66:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $66
8010745f:	6a 42                	push   $0x42
  jmp alltraps
80107461:	e9 62 f7 ff ff       	jmp    80106bc8 <alltraps>

80107466 <vector67>:
.globl vector67
vector67:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $67
80107468:	6a 43                	push   $0x43
  jmp alltraps
8010746a:	e9 59 f7 ff ff       	jmp    80106bc8 <alltraps>

8010746f <vector68>:
.globl vector68
vector68:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $68
80107471:	6a 44                	push   $0x44
  jmp alltraps
80107473:	e9 50 f7 ff ff       	jmp    80106bc8 <alltraps>

80107478 <vector69>:
.globl vector69
vector69:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $69
8010747a:	6a 45                	push   $0x45
  jmp alltraps
8010747c:	e9 47 f7 ff ff       	jmp    80106bc8 <alltraps>

80107481 <vector70>:
.globl vector70
vector70:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $70
80107483:	6a 46                	push   $0x46
  jmp alltraps
80107485:	e9 3e f7 ff ff       	jmp    80106bc8 <alltraps>

8010748a <vector71>:
.globl vector71
vector71:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $71
8010748c:	6a 47                	push   $0x47
  jmp alltraps
8010748e:	e9 35 f7 ff ff       	jmp    80106bc8 <alltraps>

80107493 <vector72>:
.globl vector72
vector72:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $72
80107495:	6a 48                	push   $0x48
  jmp alltraps
80107497:	e9 2c f7 ff ff       	jmp    80106bc8 <alltraps>

8010749c <vector73>:
.globl vector73
vector73:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $73
8010749e:	6a 49                	push   $0x49
  jmp alltraps
801074a0:	e9 23 f7 ff ff       	jmp    80106bc8 <alltraps>

801074a5 <vector74>:
.globl vector74
vector74:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $74
801074a7:	6a 4a                	push   $0x4a
  jmp alltraps
801074a9:	e9 1a f7 ff ff       	jmp    80106bc8 <alltraps>

801074ae <vector75>:
.globl vector75
vector75:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $75
801074b0:	6a 4b                	push   $0x4b
  jmp alltraps
801074b2:	e9 11 f7 ff ff       	jmp    80106bc8 <alltraps>

801074b7 <vector76>:
.globl vector76
vector76:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $76
801074b9:	6a 4c                	push   $0x4c
  jmp alltraps
801074bb:	e9 08 f7 ff ff       	jmp    80106bc8 <alltraps>

801074c0 <vector77>:
.globl vector77
vector77:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $77
801074c2:	6a 4d                	push   $0x4d
  jmp alltraps
801074c4:	e9 ff f6 ff ff       	jmp    80106bc8 <alltraps>

801074c9 <vector78>:
.globl vector78
vector78:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $78
801074cb:	6a 4e                	push   $0x4e
  jmp alltraps
801074cd:	e9 f6 f6 ff ff       	jmp    80106bc8 <alltraps>

801074d2 <vector79>:
.globl vector79
vector79:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $79
801074d4:	6a 4f                	push   $0x4f
  jmp alltraps
801074d6:	e9 ed f6 ff ff       	jmp    80106bc8 <alltraps>

801074db <vector80>:
.globl vector80
vector80:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $80
801074dd:	6a 50                	push   $0x50
  jmp alltraps
801074df:	e9 e4 f6 ff ff       	jmp    80106bc8 <alltraps>

801074e4 <vector81>:
.globl vector81
vector81:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $81
801074e6:	6a 51                	push   $0x51
  jmp alltraps
801074e8:	e9 db f6 ff ff       	jmp    80106bc8 <alltraps>

801074ed <vector82>:
.globl vector82
vector82:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $82
801074ef:	6a 52                	push   $0x52
  jmp alltraps
801074f1:	e9 d2 f6 ff ff       	jmp    80106bc8 <alltraps>

801074f6 <vector83>:
.globl vector83
vector83:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $83
801074f8:	6a 53                	push   $0x53
  jmp alltraps
801074fa:	e9 c9 f6 ff ff       	jmp    80106bc8 <alltraps>

801074ff <vector84>:
.globl vector84
vector84:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $84
80107501:	6a 54                	push   $0x54
  jmp alltraps
80107503:	e9 c0 f6 ff ff       	jmp    80106bc8 <alltraps>

80107508 <vector85>:
.globl vector85
vector85:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $85
8010750a:	6a 55                	push   $0x55
  jmp alltraps
8010750c:	e9 b7 f6 ff ff       	jmp    80106bc8 <alltraps>

80107511 <vector86>:
.globl vector86
vector86:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $86
80107513:	6a 56                	push   $0x56
  jmp alltraps
80107515:	e9 ae f6 ff ff       	jmp    80106bc8 <alltraps>

8010751a <vector87>:
.globl vector87
vector87:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $87
8010751c:	6a 57                	push   $0x57
  jmp alltraps
8010751e:	e9 a5 f6 ff ff       	jmp    80106bc8 <alltraps>

80107523 <vector88>:
.globl vector88
vector88:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $88
80107525:	6a 58                	push   $0x58
  jmp alltraps
80107527:	e9 9c f6 ff ff       	jmp    80106bc8 <alltraps>

8010752c <vector89>:
.globl vector89
vector89:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $89
8010752e:	6a 59                	push   $0x59
  jmp alltraps
80107530:	e9 93 f6 ff ff       	jmp    80106bc8 <alltraps>

80107535 <vector90>:
.globl vector90
vector90:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $90
80107537:	6a 5a                	push   $0x5a
  jmp alltraps
80107539:	e9 8a f6 ff ff       	jmp    80106bc8 <alltraps>

8010753e <vector91>:
.globl vector91
vector91:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $91
80107540:	6a 5b                	push   $0x5b
  jmp alltraps
80107542:	e9 81 f6 ff ff       	jmp    80106bc8 <alltraps>

80107547 <vector92>:
.globl vector92
vector92:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $92
80107549:	6a 5c                	push   $0x5c
  jmp alltraps
8010754b:	e9 78 f6 ff ff       	jmp    80106bc8 <alltraps>

80107550 <vector93>:
.globl vector93
vector93:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $93
80107552:	6a 5d                	push   $0x5d
  jmp alltraps
80107554:	e9 6f f6 ff ff       	jmp    80106bc8 <alltraps>

80107559 <vector94>:
.globl vector94
vector94:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $94
8010755b:	6a 5e                	push   $0x5e
  jmp alltraps
8010755d:	e9 66 f6 ff ff       	jmp    80106bc8 <alltraps>

80107562 <vector95>:
.globl vector95
vector95:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $95
80107564:	6a 5f                	push   $0x5f
  jmp alltraps
80107566:	e9 5d f6 ff ff       	jmp    80106bc8 <alltraps>

8010756b <vector96>:
.globl vector96
vector96:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $96
8010756d:	6a 60                	push   $0x60
  jmp alltraps
8010756f:	e9 54 f6 ff ff       	jmp    80106bc8 <alltraps>

80107574 <vector97>:
.globl vector97
vector97:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $97
80107576:	6a 61                	push   $0x61
  jmp alltraps
80107578:	e9 4b f6 ff ff       	jmp    80106bc8 <alltraps>

8010757d <vector98>:
.globl vector98
vector98:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $98
8010757f:	6a 62                	push   $0x62
  jmp alltraps
80107581:	e9 42 f6 ff ff       	jmp    80106bc8 <alltraps>

80107586 <vector99>:
.globl vector99
vector99:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $99
80107588:	6a 63                	push   $0x63
  jmp alltraps
8010758a:	e9 39 f6 ff ff       	jmp    80106bc8 <alltraps>

8010758f <vector100>:
.globl vector100
vector100:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $100
80107591:	6a 64                	push   $0x64
  jmp alltraps
80107593:	e9 30 f6 ff ff       	jmp    80106bc8 <alltraps>

80107598 <vector101>:
.globl vector101
vector101:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $101
8010759a:	6a 65                	push   $0x65
  jmp alltraps
8010759c:	e9 27 f6 ff ff       	jmp    80106bc8 <alltraps>

801075a1 <vector102>:
.globl vector102
vector102:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $102
801075a3:	6a 66                	push   $0x66
  jmp alltraps
801075a5:	e9 1e f6 ff ff       	jmp    80106bc8 <alltraps>

801075aa <vector103>:
.globl vector103
vector103:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $103
801075ac:	6a 67                	push   $0x67
  jmp alltraps
801075ae:	e9 15 f6 ff ff       	jmp    80106bc8 <alltraps>

801075b3 <vector104>:
.globl vector104
vector104:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $104
801075b5:	6a 68                	push   $0x68
  jmp alltraps
801075b7:	e9 0c f6 ff ff       	jmp    80106bc8 <alltraps>

801075bc <vector105>:
.globl vector105
vector105:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $105
801075be:	6a 69                	push   $0x69
  jmp alltraps
801075c0:	e9 03 f6 ff ff       	jmp    80106bc8 <alltraps>

801075c5 <vector106>:
.globl vector106
vector106:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $106
801075c7:	6a 6a                	push   $0x6a
  jmp alltraps
801075c9:	e9 fa f5 ff ff       	jmp    80106bc8 <alltraps>

801075ce <vector107>:
.globl vector107
vector107:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $107
801075d0:	6a 6b                	push   $0x6b
  jmp alltraps
801075d2:	e9 f1 f5 ff ff       	jmp    80106bc8 <alltraps>

801075d7 <vector108>:
.globl vector108
vector108:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $108
801075d9:	6a 6c                	push   $0x6c
  jmp alltraps
801075db:	e9 e8 f5 ff ff       	jmp    80106bc8 <alltraps>

801075e0 <vector109>:
.globl vector109
vector109:
  pushl $0
801075e0:	6a 00                	push   $0x0
  pushl $109
801075e2:	6a 6d                	push   $0x6d
  jmp alltraps
801075e4:	e9 df f5 ff ff       	jmp    80106bc8 <alltraps>

801075e9 <vector110>:
.globl vector110
vector110:
  pushl $0
801075e9:	6a 00                	push   $0x0
  pushl $110
801075eb:	6a 6e                	push   $0x6e
  jmp alltraps
801075ed:	e9 d6 f5 ff ff       	jmp    80106bc8 <alltraps>

801075f2 <vector111>:
.globl vector111
vector111:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $111
801075f4:	6a 6f                	push   $0x6f
  jmp alltraps
801075f6:	e9 cd f5 ff ff       	jmp    80106bc8 <alltraps>

801075fb <vector112>:
.globl vector112
vector112:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $112
801075fd:	6a 70                	push   $0x70
  jmp alltraps
801075ff:	e9 c4 f5 ff ff       	jmp    80106bc8 <alltraps>

80107604 <vector113>:
.globl vector113
vector113:
  pushl $0
80107604:	6a 00                	push   $0x0
  pushl $113
80107606:	6a 71                	push   $0x71
  jmp alltraps
80107608:	e9 bb f5 ff ff       	jmp    80106bc8 <alltraps>

8010760d <vector114>:
.globl vector114
vector114:
  pushl $0
8010760d:	6a 00                	push   $0x0
  pushl $114
8010760f:	6a 72                	push   $0x72
  jmp alltraps
80107611:	e9 b2 f5 ff ff       	jmp    80106bc8 <alltraps>

80107616 <vector115>:
.globl vector115
vector115:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $115
80107618:	6a 73                	push   $0x73
  jmp alltraps
8010761a:	e9 a9 f5 ff ff       	jmp    80106bc8 <alltraps>

8010761f <vector116>:
.globl vector116
vector116:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $116
80107621:	6a 74                	push   $0x74
  jmp alltraps
80107623:	e9 a0 f5 ff ff       	jmp    80106bc8 <alltraps>

80107628 <vector117>:
.globl vector117
vector117:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $117
8010762a:	6a 75                	push   $0x75
  jmp alltraps
8010762c:	e9 97 f5 ff ff       	jmp    80106bc8 <alltraps>

80107631 <vector118>:
.globl vector118
vector118:
  pushl $0
80107631:	6a 00                	push   $0x0
  pushl $118
80107633:	6a 76                	push   $0x76
  jmp alltraps
80107635:	e9 8e f5 ff ff       	jmp    80106bc8 <alltraps>

8010763a <vector119>:
.globl vector119
vector119:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $119
8010763c:	6a 77                	push   $0x77
  jmp alltraps
8010763e:	e9 85 f5 ff ff       	jmp    80106bc8 <alltraps>

80107643 <vector120>:
.globl vector120
vector120:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $120
80107645:	6a 78                	push   $0x78
  jmp alltraps
80107647:	e9 7c f5 ff ff       	jmp    80106bc8 <alltraps>

8010764c <vector121>:
.globl vector121
vector121:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $121
8010764e:	6a 79                	push   $0x79
  jmp alltraps
80107650:	e9 73 f5 ff ff       	jmp    80106bc8 <alltraps>

80107655 <vector122>:
.globl vector122
vector122:
  pushl $0
80107655:	6a 00                	push   $0x0
  pushl $122
80107657:	6a 7a                	push   $0x7a
  jmp alltraps
80107659:	e9 6a f5 ff ff       	jmp    80106bc8 <alltraps>

8010765e <vector123>:
.globl vector123
vector123:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $123
80107660:	6a 7b                	push   $0x7b
  jmp alltraps
80107662:	e9 61 f5 ff ff       	jmp    80106bc8 <alltraps>

80107667 <vector124>:
.globl vector124
vector124:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $124
80107669:	6a 7c                	push   $0x7c
  jmp alltraps
8010766b:	e9 58 f5 ff ff       	jmp    80106bc8 <alltraps>

80107670 <vector125>:
.globl vector125
vector125:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $125
80107672:	6a 7d                	push   $0x7d
  jmp alltraps
80107674:	e9 4f f5 ff ff       	jmp    80106bc8 <alltraps>

80107679 <vector126>:
.globl vector126
vector126:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $126
8010767b:	6a 7e                	push   $0x7e
  jmp alltraps
8010767d:	e9 46 f5 ff ff       	jmp    80106bc8 <alltraps>

80107682 <vector127>:
.globl vector127
vector127:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $127
80107684:	6a 7f                	push   $0x7f
  jmp alltraps
80107686:	e9 3d f5 ff ff       	jmp    80106bc8 <alltraps>

8010768b <vector128>:
.globl vector128
vector128:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $128
8010768d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107692:	e9 31 f5 ff ff       	jmp    80106bc8 <alltraps>

80107697 <vector129>:
.globl vector129
vector129:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $129
80107699:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010769e:	e9 25 f5 ff ff       	jmp    80106bc8 <alltraps>

801076a3 <vector130>:
.globl vector130
vector130:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $130
801076a5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801076aa:	e9 19 f5 ff ff       	jmp    80106bc8 <alltraps>

801076af <vector131>:
.globl vector131
vector131:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $131
801076b1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801076b6:	e9 0d f5 ff ff       	jmp    80106bc8 <alltraps>

801076bb <vector132>:
.globl vector132
vector132:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $132
801076bd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801076c2:	e9 01 f5 ff ff       	jmp    80106bc8 <alltraps>

801076c7 <vector133>:
.globl vector133
vector133:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $133
801076c9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801076ce:	e9 f5 f4 ff ff       	jmp    80106bc8 <alltraps>

801076d3 <vector134>:
.globl vector134
vector134:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $134
801076d5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801076da:	e9 e9 f4 ff ff       	jmp    80106bc8 <alltraps>

801076df <vector135>:
.globl vector135
vector135:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $135
801076e1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801076e6:	e9 dd f4 ff ff       	jmp    80106bc8 <alltraps>

801076eb <vector136>:
.globl vector136
vector136:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $136
801076ed:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801076f2:	e9 d1 f4 ff ff       	jmp    80106bc8 <alltraps>

801076f7 <vector137>:
.globl vector137
vector137:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $137
801076f9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801076fe:	e9 c5 f4 ff ff       	jmp    80106bc8 <alltraps>

80107703 <vector138>:
.globl vector138
vector138:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $138
80107705:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010770a:	e9 b9 f4 ff ff       	jmp    80106bc8 <alltraps>

8010770f <vector139>:
.globl vector139
vector139:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $139
80107711:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107716:	e9 ad f4 ff ff       	jmp    80106bc8 <alltraps>

8010771b <vector140>:
.globl vector140
vector140:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $140
8010771d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107722:	e9 a1 f4 ff ff       	jmp    80106bc8 <alltraps>

80107727 <vector141>:
.globl vector141
vector141:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $141
80107729:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010772e:	e9 95 f4 ff ff       	jmp    80106bc8 <alltraps>

80107733 <vector142>:
.globl vector142
vector142:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $142
80107735:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010773a:	e9 89 f4 ff ff       	jmp    80106bc8 <alltraps>

8010773f <vector143>:
.globl vector143
vector143:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $143
80107741:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107746:	e9 7d f4 ff ff       	jmp    80106bc8 <alltraps>

8010774b <vector144>:
.globl vector144
vector144:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $144
8010774d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107752:	e9 71 f4 ff ff       	jmp    80106bc8 <alltraps>

80107757 <vector145>:
.globl vector145
vector145:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $145
80107759:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010775e:	e9 65 f4 ff ff       	jmp    80106bc8 <alltraps>

80107763 <vector146>:
.globl vector146
vector146:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $146
80107765:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010776a:	e9 59 f4 ff ff       	jmp    80106bc8 <alltraps>

8010776f <vector147>:
.globl vector147
vector147:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $147
80107771:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107776:	e9 4d f4 ff ff       	jmp    80106bc8 <alltraps>

8010777b <vector148>:
.globl vector148
vector148:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $148
8010777d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107782:	e9 41 f4 ff ff       	jmp    80106bc8 <alltraps>

80107787 <vector149>:
.globl vector149
vector149:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $149
80107789:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010778e:	e9 35 f4 ff ff       	jmp    80106bc8 <alltraps>

80107793 <vector150>:
.globl vector150
vector150:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $150
80107795:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010779a:	e9 29 f4 ff ff       	jmp    80106bc8 <alltraps>

8010779f <vector151>:
.globl vector151
vector151:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $151
801077a1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801077a6:	e9 1d f4 ff ff       	jmp    80106bc8 <alltraps>

801077ab <vector152>:
.globl vector152
vector152:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $152
801077ad:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801077b2:	e9 11 f4 ff ff       	jmp    80106bc8 <alltraps>

801077b7 <vector153>:
.globl vector153
vector153:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $153
801077b9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801077be:	e9 05 f4 ff ff       	jmp    80106bc8 <alltraps>

801077c3 <vector154>:
.globl vector154
vector154:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $154
801077c5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801077ca:	e9 f9 f3 ff ff       	jmp    80106bc8 <alltraps>

801077cf <vector155>:
.globl vector155
vector155:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $155
801077d1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801077d6:	e9 ed f3 ff ff       	jmp    80106bc8 <alltraps>

801077db <vector156>:
.globl vector156
vector156:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $156
801077dd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801077e2:	e9 e1 f3 ff ff       	jmp    80106bc8 <alltraps>

801077e7 <vector157>:
.globl vector157
vector157:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $157
801077e9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801077ee:	e9 d5 f3 ff ff       	jmp    80106bc8 <alltraps>

801077f3 <vector158>:
.globl vector158
vector158:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $158
801077f5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801077fa:	e9 c9 f3 ff ff       	jmp    80106bc8 <alltraps>

801077ff <vector159>:
.globl vector159
vector159:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $159
80107801:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107806:	e9 bd f3 ff ff       	jmp    80106bc8 <alltraps>

8010780b <vector160>:
.globl vector160
vector160:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $160
8010780d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107812:	e9 b1 f3 ff ff       	jmp    80106bc8 <alltraps>

80107817 <vector161>:
.globl vector161
vector161:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $161
80107819:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010781e:	e9 a5 f3 ff ff       	jmp    80106bc8 <alltraps>

80107823 <vector162>:
.globl vector162
vector162:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $162
80107825:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010782a:	e9 99 f3 ff ff       	jmp    80106bc8 <alltraps>

8010782f <vector163>:
.globl vector163
vector163:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $163
80107831:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107836:	e9 8d f3 ff ff       	jmp    80106bc8 <alltraps>

8010783b <vector164>:
.globl vector164
vector164:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $164
8010783d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107842:	e9 81 f3 ff ff       	jmp    80106bc8 <alltraps>

80107847 <vector165>:
.globl vector165
vector165:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $165
80107849:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010784e:	e9 75 f3 ff ff       	jmp    80106bc8 <alltraps>

80107853 <vector166>:
.globl vector166
vector166:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $166
80107855:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010785a:	e9 69 f3 ff ff       	jmp    80106bc8 <alltraps>

8010785f <vector167>:
.globl vector167
vector167:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $167
80107861:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107866:	e9 5d f3 ff ff       	jmp    80106bc8 <alltraps>

8010786b <vector168>:
.globl vector168
vector168:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $168
8010786d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107872:	e9 51 f3 ff ff       	jmp    80106bc8 <alltraps>

80107877 <vector169>:
.globl vector169
vector169:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $169
80107879:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010787e:	e9 45 f3 ff ff       	jmp    80106bc8 <alltraps>

80107883 <vector170>:
.globl vector170
vector170:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $170
80107885:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010788a:	e9 39 f3 ff ff       	jmp    80106bc8 <alltraps>

8010788f <vector171>:
.globl vector171
vector171:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $171
80107891:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107896:	e9 2d f3 ff ff       	jmp    80106bc8 <alltraps>

8010789b <vector172>:
.globl vector172
vector172:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $172
8010789d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801078a2:	e9 21 f3 ff ff       	jmp    80106bc8 <alltraps>

801078a7 <vector173>:
.globl vector173
vector173:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $173
801078a9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801078ae:	e9 15 f3 ff ff       	jmp    80106bc8 <alltraps>

801078b3 <vector174>:
.globl vector174
vector174:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $174
801078b5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801078ba:	e9 09 f3 ff ff       	jmp    80106bc8 <alltraps>

801078bf <vector175>:
.globl vector175
vector175:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $175
801078c1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801078c6:	e9 fd f2 ff ff       	jmp    80106bc8 <alltraps>

801078cb <vector176>:
.globl vector176
vector176:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $176
801078cd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801078d2:	e9 f1 f2 ff ff       	jmp    80106bc8 <alltraps>

801078d7 <vector177>:
.globl vector177
vector177:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $177
801078d9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801078de:	e9 e5 f2 ff ff       	jmp    80106bc8 <alltraps>

801078e3 <vector178>:
.globl vector178
vector178:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $178
801078e5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801078ea:	e9 d9 f2 ff ff       	jmp    80106bc8 <alltraps>

801078ef <vector179>:
.globl vector179
vector179:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $179
801078f1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801078f6:	e9 cd f2 ff ff       	jmp    80106bc8 <alltraps>

801078fb <vector180>:
.globl vector180
vector180:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $180
801078fd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107902:	e9 c1 f2 ff ff       	jmp    80106bc8 <alltraps>

80107907 <vector181>:
.globl vector181
vector181:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $181
80107909:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010790e:	e9 b5 f2 ff ff       	jmp    80106bc8 <alltraps>

80107913 <vector182>:
.globl vector182
vector182:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $182
80107915:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010791a:	e9 a9 f2 ff ff       	jmp    80106bc8 <alltraps>

8010791f <vector183>:
.globl vector183
vector183:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $183
80107921:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107926:	e9 9d f2 ff ff       	jmp    80106bc8 <alltraps>

8010792b <vector184>:
.globl vector184
vector184:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $184
8010792d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107932:	e9 91 f2 ff ff       	jmp    80106bc8 <alltraps>

80107937 <vector185>:
.globl vector185
vector185:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $185
80107939:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010793e:	e9 85 f2 ff ff       	jmp    80106bc8 <alltraps>

80107943 <vector186>:
.globl vector186
vector186:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $186
80107945:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010794a:	e9 79 f2 ff ff       	jmp    80106bc8 <alltraps>

8010794f <vector187>:
.globl vector187
vector187:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $187
80107951:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107956:	e9 6d f2 ff ff       	jmp    80106bc8 <alltraps>

8010795b <vector188>:
.globl vector188
vector188:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $188
8010795d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107962:	e9 61 f2 ff ff       	jmp    80106bc8 <alltraps>

80107967 <vector189>:
.globl vector189
vector189:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $189
80107969:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010796e:	e9 55 f2 ff ff       	jmp    80106bc8 <alltraps>

80107973 <vector190>:
.globl vector190
vector190:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $190
80107975:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010797a:	e9 49 f2 ff ff       	jmp    80106bc8 <alltraps>

8010797f <vector191>:
.globl vector191
vector191:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $191
80107981:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107986:	e9 3d f2 ff ff       	jmp    80106bc8 <alltraps>

8010798b <vector192>:
.globl vector192
vector192:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $192
8010798d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107992:	e9 31 f2 ff ff       	jmp    80106bc8 <alltraps>

80107997 <vector193>:
.globl vector193
vector193:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $193
80107999:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010799e:	e9 25 f2 ff ff       	jmp    80106bc8 <alltraps>

801079a3 <vector194>:
.globl vector194
vector194:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $194
801079a5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801079aa:	e9 19 f2 ff ff       	jmp    80106bc8 <alltraps>

801079af <vector195>:
.globl vector195
vector195:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $195
801079b1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801079b6:	e9 0d f2 ff ff       	jmp    80106bc8 <alltraps>

801079bb <vector196>:
.globl vector196
vector196:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $196
801079bd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801079c2:	e9 01 f2 ff ff       	jmp    80106bc8 <alltraps>

801079c7 <vector197>:
.globl vector197
vector197:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $197
801079c9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801079ce:	e9 f5 f1 ff ff       	jmp    80106bc8 <alltraps>

801079d3 <vector198>:
.globl vector198
vector198:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $198
801079d5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801079da:	e9 e9 f1 ff ff       	jmp    80106bc8 <alltraps>

801079df <vector199>:
.globl vector199
vector199:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $199
801079e1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801079e6:	e9 dd f1 ff ff       	jmp    80106bc8 <alltraps>

801079eb <vector200>:
.globl vector200
vector200:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $200
801079ed:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801079f2:	e9 d1 f1 ff ff       	jmp    80106bc8 <alltraps>

801079f7 <vector201>:
.globl vector201
vector201:
  pushl $0
801079f7:	6a 00                	push   $0x0
  pushl $201
801079f9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801079fe:	e9 c5 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a03 <vector202>:
.globl vector202
vector202:
  pushl $0
80107a03:	6a 00                	push   $0x0
  pushl $202
80107a05:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107a0a:	e9 b9 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a0f <vector203>:
.globl vector203
vector203:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $203
80107a11:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107a16:	e9 ad f1 ff ff       	jmp    80106bc8 <alltraps>

80107a1b <vector204>:
.globl vector204
vector204:
  pushl $0
80107a1b:	6a 00                	push   $0x0
  pushl $204
80107a1d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107a22:	e9 a1 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a27 <vector205>:
.globl vector205
vector205:
  pushl $0
80107a27:	6a 00                	push   $0x0
  pushl $205
80107a29:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107a2e:	e9 95 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a33 <vector206>:
.globl vector206
vector206:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $206
80107a35:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107a3a:	e9 89 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a3f <vector207>:
.globl vector207
vector207:
  pushl $0
80107a3f:	6a 00                	push   $0x0
  pushl $207
80107a41:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107a46:	e9 7d f1 ff ff       	jmp    80106bc8 <alltraps>

80107a4b <vector208>:
.globl vector208
vector208:
  pushl $0
80107a4b:	6a 00                	push   $0x0
  pushl $208
80107a4d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107a52:	e9 71 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a57 <vector209>:
.globl vector209
vector209:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $209
80107a59:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107a5e:	e9 65 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a63 <vector210>:
.globl vector210
vector210:
  pushl $0
80107a63:	6a 00                	push   $0x0
  pushl $210
80107a65:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107a6a:	e9 59 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a6f <vector211>:
.globl vector211
vector211:
  pushl $0
80107a6f:	6a 00                	push   $0x0
  pushl $211
80107a71:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107a76:	e9 4d f1 ff ff       	jmp    80106bc8 <alltraps>

80107a7b <vector212>:
.globl vector212
vector212:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $212
80107a7d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107a82:	e9 41 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a87 <vector213>:
.globl vector213
vector213:
  pushl $0
80107a87:	6a 00                	push   $0x0
  pushl $213
80107a89:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a8e:	e9 35 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a93 <vector214>:
.globl vector214
vector214:
  pushl $0
80107a93:	6a 00                	push   $0x0
  pushl $214
80107a95:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a9a:	e9 29 f1 ff ff       	jmp    80106bc8 <alltraps>

80107a9f <vector215>:
.globl vector215
vector215:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $215
80107aa1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107aa6:	e9 1d f1 ff ff       	jmp    80106bc8 <alltraps>

80107aab <vector216>:
.globl vector216
vector216:
  pushl $0
80107aab:	6a 00                	push   $0x0
  pushl $216
80107aad:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107ab2:	e9 11 f1 ff ff       	jmp    80106bc8 <alltraps>

80107ab7 <vector217>:
.globl vector217
vector217:
  pushl $0
80107ab7:	6a 00                	push   $0x0
  pushl $217
80107ab9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107abe:	e9 05 f1 ff ff       	jmp    80106bc8 <alltraps>

80107ac3 <vector218>:
.globl vector218
vector218:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $218
80107ac5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107aca:	e9 f9 f0 ff ff       	jmp    80106bc8 <alltraps>

80107acf <vector219>:
.globl vector219
vector219:
  pushl $0
80107acf:	6a 00                	push   $0x0
  pushl $219
80107ad1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107ad6:	e9 ed f0 ff ff       	jmp    80106bc8 <alltraps>

80107adb <vector220>:
.globl vector220
vector220:
  pushl $0
80107adb:	6a 00                	push   $0x0
  pushl $220
80107add:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107ae2:	e9 e1 f0 ff ff       	jmp    80106bc8 <alltraps>

80107ae7 <vector221>:
.globl vector221
vector221:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $221
80107ae9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107aee:	e9 d5 f0 ff ff       	jmp    80106bc8 <alltraps>

80107af3 <vector222>:
.globl vector222
vector222:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $222
80107af5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107afa:	e9 c9 f0 ff ff       	jmp    80106bc8 <alltraps>

80107aff <vector223>:
.globl vector223
vector223:
  pushl $0
80107aff:	6a 00                	push   $0x0
  pushl $223
80107b01:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107b06:	e9 bd f0 ff ff       	jmp    80106bc8 <alltraps>

80107b0b <vector224>:
.globl vector224
vector224:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $224
80107b0d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107b12:	e9 b1 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b17 <vector225>:
.globl vector225
vector225:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $225
80107b19:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107b1e:	e9 a5 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b23 <vector226>:
.globl vector226
vector226:
  pushl $0
80107b23:	6a 00                	push   $0x0
  pushl $226
80107b25:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107b2a:	e9 99 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b2f <vector227>:
.globl vector227
vector227:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $227
80107b31:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107b36:	e9 8d f0 ff ff       	jmp    80106bc8 <alltraps>

80107b3b <vector228>:
.globl vector228
vector228:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $228
80107b3d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107b42:	e9 81 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b47 <vector229>:
.globl vector229
vector229:
  pushl $0
80107b47:	6a 00                	push   $0x0
  pushl $229
80107b49:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107b4e:	e9 75 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b53 <vector230>:
.globl vector230
vector230:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $230
80107b55:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107b5a:	e9 69 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b5f <vector231>:
.globl vector231
vector231:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $231
80107b61:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107b66:	e9 5d f0 ff ff       	jmp    80106bc8 <alltraps>

80107b6b <vector232>:
.globl vector232
vector232:
  pushl $0
80107b6b:	6a 00                	push   $0x0
  pushl $232
80107b6d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107b72:	e9 51 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b77 <vector233>:
.globl vector233
vector233:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $233
80107b79:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107b7e:	e9 45 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b83 <vector234>:
.globl vector234
vector234:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $234
80107b85:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b8a:	e9 39 f0 ff ff       	jmp    80106bc8 <alltraps>

80107b8f <vector235>:
.globl vector235
vector235:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $235
80107b91:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b96:	e9 2d f0 ff ff       	jmp    80106bc8 <alltraps>

80107b9b <vector236>:
.globl vector236
vector236:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $236
80107b9d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107ba2:	e9 21 f0 ff ff       	jmp    80106bc8 <alltraps>

80107ba7 <vector237>:
.globl vector237
vector237:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $237
80107ba9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107bae:	e9 15 f0 ff ff       	jmp    80106bc8 <alltraps>

80107bb3 <vector238>:
.globl vector238
vector238:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $238
80107bb5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107bba:	e9 09 f0 ff ff       	jmp    80106bc8 <alltraps>

80107bbf <vector239>:
.globl vector239
vector239:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $239
80107bc1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107bc6:	e9 fd ef ff ff       	jmp    80106bc8 <alltraps>

80107bcb <vector240>:
.globl vector240
vector240:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $240
80107bcd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107bd2:	e9 f1 ef ff ff       	jmp    80106bc8 <alltraps>

80107bd7 <vector241>:
.globl vector241
vector241:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $241
80107bd9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107bde:	e9 e5 ef ff ff       	jmp    80106bc8 <alltraps>

80107be3 <vector242>:
.globl vector242
vector242:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $242
80107be5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107bea:	e9 d9 ef ff ff       	jmp    80106bc8 <alltraps>

80107bef <vector243>:
.globl vector243
vector243:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $243
80107bf1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107bf6:	e9 cd ef ff ff       	jmp    80106bc8 <alltraps>

80107bfb <vector244>:
.globl vector244
vector244:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $244
80107bfd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107c02:	e9 c1 ef ff ff       	jmp    80106bc8 <alltraps>

80107c07 <vector245>:
.globl vector245
vector245:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $245
80107c09:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107c0e:	e9 b5 ef ff ff       	jmp    80106bc8 <alltraps>

80107c13 <vector246>:
.globl vector246
vector246:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $246
80107c15:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107c1a:	e9 a9 ef ff ff       	jmp    80106bc8 <alltraps>

80107c1f <vector247>:
.globl vector247
vector247:
  pushl $0
80107c1f:	6a 00                	push   $0x0
  pushl $247
80107c21:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107c26:	e9 9d ef ff ff       	jmp    80106bc8 <alltraps>

80107c2b <vector248>:
.globl vector248
vector248:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $248
80107c2d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107c32:	e9 91 ef ff ff       	jmp    80106bc8 <alltraps>

80107c37 <vector249>:
.globl vector249
vector249:
  pushl $0
80107c37:	6a 00                	push   $0x0
  pushl $249
80107c39:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107c3e:	e9 85 ef ff ff       	jmp    80106bc8 <alltraps>

80107c43 <vector250>:
.globl vector250
vector250:
  pushl $0
80107c43:	6a 00                	push   $0x0
  pushl $250
80107c45:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107c4a:	e9 79 ef ff ff       	jmp    80106bc8 <alltraps>

80107c4f <vector251>:
.globl vector251
vector251:
  pushl $0
80107c4f:	6a 00                	push   $0x0
  pushl $251
80107c51:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107c56:	e9 6d ef ff ff       	jmp    80106bc8 <alltraps>

80107c5b <vector252>:
.globl vector252
vector252:
  pushl $0
80107c5b:	6a 00                	push   $0x0
  pushl $252
80107c5d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107c62:	e9 61 ef ff ff       	jmp    80106bc8 <alltraps>

80107c67 <vector253>:
.globl vector253
vector253:
  pushl $0
80107c67:	6a 00                	push   $0x0
  pushl $253
80107c69:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107c6e:	e9 55 ef ff ff       	jmp    80106bc8 <alltraps>

80107c73 <vector254>:
.globl vector254
vector254:
  pushl $0
80107c73:	6a 00                	push   $0x0
  pushl $254
80107c75:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107c7a:	e9 49 ef ff ff       	jmp    80106bc8 <alltraps>

80107c7f <vector255>:
.globl vector255
vector255:
  pushl $0
80107c7f:	6a 00                	push   $0x0
  pushl $255
80107c81:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c86:	e9 3d ef ff ff       	jmp    80106bc8 <alltraps>

80107c8b <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107c8b:	55                   	push   %ebp
80107c8c:	89 e5                	mov    %esp,%ebp
80107c8e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107c91:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c94:	83 e8 01             	sub    $0x1,%eax
80107c97:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c9e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca5:	c1 e8 10             	shr    $0x10,%eax
80107ca8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107cac:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107caf:	0f 01 10             	lgdtl  (%eax)
}
80107cb2:	90                   	nop
80107cb3:	c9                   	leave  
80107cb4:	c3                   	ret    

80107cb5 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107cb5:	55                   	push   %ebp
80107cb6:	89 e5                	mov    %esp,%ebp
80107cb8:	83 ec 04             	sub    $0x4,%esp
80107cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107cbe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107cc2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107cc6:	0f 00 d8             	ltr    %ax
}
80107cc9:	90                   	nop
80107cca:	c9                   	leave  
80107ccb:	c3                   	ret    

80107ccc <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107ccc:	55                   	push   %ebp
80107ccd:	89 e5                	mov    %esp,%ebp
80107ccf:	83 ec 04             	sub    $0x4,%esp
80107cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107cd9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107cdd:	8e e8                	mov    %eax,%gs
}
80107cdf:	90                   	nop
80107ce0:	c9                   	leave  
80107ce1:	c3                   	ret    

80107ce2 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107ce2:	55                   	push   %ebp
80107ce3:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ce8:	0f 22 d8             	mov    %eax,%cr3
}
80107ceb:	90                   	nop
80107cec:	5d                   	pop    %ebp
80107ced:	c3                   	ret    

80107cee <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107cee:	55                   	push   %ebp
80107cef:	89 e5                	mov    %esp,%ebp
80107cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf4:	05 00 00 00 80       	add    $0x80000000,%eax
80107cf9:	5d                   	pop    %ebp
80107cfa:	c3                   	ret    

80107cfb <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107cfb:	55                   	push   %ebp
80107cfc:	89 e5                	mov    %esp,%ebp
80107cfe:	8b 45 08             	mov    0x8(%ebp),%eax
80107d01:	05 00 00 00 80       	add    $0x80000000,%eax
80107d06:	5d                   	pop    %ebp
80107d07:	c3                   	ret    

80107d08 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107d08:	55                   	push   %ebp
80107d09:	89 e5                	mov    %esp,%ebp
80107d0b:	53                   	push   %ebx
80107d0c:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107d0f:	e8 08 b3 ff ff       	call   8010301c <cpunum>
80107d14:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107d1a:	05 80 33 11 80       	add    $0x80113380,%eax
80107d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d25:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d37:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d42:	83 e2 f0             	and    $0xfffffff0,%edx
80107d45:	83 ca 0a             	or     $0xa,%edx
80107d48:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d52:	83 ca 10             	or     $0x10,%edx
80107d55:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d5f:	83 e2 9f             	and    $0xffffff9f,%edx
80107d62:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d68:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d6c:	83 ca 80             	or     $0xffffff80,%edx
80107d6f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d75:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d79:	83 ca 0f             	or     $0xf,%edx
80107d7c:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d82:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d86:	83 e2 ef             	and    $0xffffffef,%edx
80107d89:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d93:	83 e2 df             	and    $0xffffffdf,%edx
80107d96:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107da0:	83 ca 40             	or     $0x40,%edx
80107da3:	88 50 7e             	mov    %dl,0x7e(%eax)
80107da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107dad:	83 ca 80             	or     $0xffffff80,%edx
80107db0:	88 50 7e             	mov    %dl,0x7e(%eax)
80107db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db6:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbd:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107dc4:	ff ff 
80107dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107dd0:	00 00 
80107dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd5:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ddf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107de6:	83 e2 f0             	and    $0xfffffff0,%edx
80107de9:	83 ca 02             	or     $0x2,%edx
80107dec:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107dfc:	83 ca 10             	or     $0x10,%edx
80107dff:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e08:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e0f:	83 e2 9f             	and    $0xffffff9f,%edx
80107e12:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e22:	83 ca 80             	or     $0xffffff80,%edx
80107e25:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e35:	83 ca 0f             	or     $0xf,%edx
80107e38:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e41:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e48:	83 e2 ef             	and    $0xffffffef,%edx
80107e4b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e54:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e5b:	83 e2 df             	and    $0xffffffdf,%edx
80107e5e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e67:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e6e:	83 ca 40             	or     $0x40,%edx
80107e71:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e81:	83 ca 80             	or     $0xffffff80,%edx
80107e84:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8d:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e97:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107e9e:	ff ff 
80107ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107eaa:	00 00 
80107eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eaf:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ec0:	83 e2 f0             	and    $0xfffffff0,%edx
80107ec3:	83 ca 0a             	or     $0xa,%edx
80107ec6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ed6:	83 ca 10             	or     $0x10,%edx
80107ed9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ee9:	83 ca 60             	or     $0x60,%edx
80107eec:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107efc:	83 ca 80             	or     $0xffffff80,%edx
80107eff:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f08:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f0f:	83 ca 0f             	or     $0xf,%edx
80107f12:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f22:	83 e2 ef             	and    $0xffffffef,%edx
80107f25:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f35:	83 e2 df             	and    $0xffffffdf,%edx
80107f38:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f41:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f48:	83 ca 40             	or     $0x40,%edx
80107f4b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f54:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107f5b:	83 ca 80             	or     $0xffffff80,%edx
80107f5e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f67:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f71:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107f78:	ff ff 
80107f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107f84:	00 00 
80107f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f89:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f93:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f9a:	83 e2 f0             	and    $0xfffffff0,%edx
80107f9d:	83 ca 02             	or     $0x2,%edx
80107fa0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107fb0:	83 ca 10             	or     $0x10,%edx
80107fb3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107fc3:	83 ca 60             	or     $0x60,%edx
80107fc6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcf:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107fd6:	83 ca 80             	or     $0xffffff80,%edx
80107fd9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fe9:	83 ca 0f             	or     $0xf,%edx
80107fec:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ffc:	83 e2 ef             	and    $0xffffffef,%edx
80107fff:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108008:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010800f:	83 e2 df             	and    $0xffffffdf,%edx
80108012:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108022:	83 ca 40             	or     $0x40,%edx
80108025:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010802b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108035:	83 ca 80             	or     $0xffffff80,%edx
80108038:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010803e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108041:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	05 b4 00 00 00       	add    $0xb4,%eax
80108050:	89 c3                	mov    %eax,%ebx
80108052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108055:	05 b4 00 00 00       	add    $0xb4,%eax
8010805a:	c1 e8 10             	shr    $0x10,%eax
8010805d:	89 c2                	mov    %eax,%edx
8010805f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108062:	05 b4 00 00 00       	add    $0xb4,%eax
80108067:	c1 e8 18             	shr    $0x18,%eax
8010806a:	89 c1                	mov    %eax,%ecx
8010806c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108076:	00 00 
80108078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807b:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108085:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010808b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108095:	83 e2 f0             	and    $0xfffffff0,%edx
80108098:	83 ca 02             	or     $0x2,%edx
8010809b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080ab:	83 ca 10             	or     $0x10,%edx
801080ae:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b7:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080be:	83 e2 9f             	and    $0xffffff9f,%edx
801080c1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ca:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080d1:	83 ca 80             	or     $0xffffff80,%edx
801080d4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080e4:	83 e2 f0             	and    $0xfffffff0,%edx
801080e7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080f7:	83 e2 ef             	and    $0xffffffef,%edx
801080fa:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108103:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010810a:	83 e2 df             	and    $0xffffffdf,%edx
8010810d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108116:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010811d:	83 ca 40             	or     $0x40,%edx
80108120:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108129:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108130:	83 ca 80             	or     $0xffffff80,%edx
80108133:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813c:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108145:	83 c0 70             	add    $0x70,%eax
80108148:	83 ec 08             	sub    $0x8,%esp
8010814b:	6a 38                	push   $0x38
8010814d:	50                   	push   %eax
8010814e:	e8 38 fb ff ff       	call   80107c8b <lgdt>
80108153:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108156:	83 ec 0c             	sub    $0xc,%esp
80108159:	6a 18                	push   $0x18
8010815b:	e8 6c fb ff ff       	call   80107ccc <loadgs>
80108160:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108166:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010816c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108173:	00 00 00 00 
}
80108177:	90                   	nop
80108178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010817b:	c9                   	leave  
8010817c:	c3                   	ret    

8010817d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010817d:	55                   	push   %ebp
8010817e:	89 e5                	mov    %esp,%ebp
80108180:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108183:	8b 45 0c             	mov    0xc(%ebp),%eax
80108186:	c1 e8 16             	shr    $0x16,%eax
80108189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108190:	8b 45 08             	mov    0x8(%ebp),%eax
80108193:	01 d0                	add    %edx,%eax
80108195:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108198:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010819b:	8b 00                	mov    (%eax),%eax
8010819d:	83 e0 01             	and    $0x1,%eax
801081a0:	85 c0                	test   %eax,%eax
801081a2:	74 18                	je     801081bc <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801081a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081a7:	8b 00                	mov    (%eax),%eax
801081a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081ae:	50                   	push   %eax
801081af:	e8 47 fb ff ff       	call   80107cfb <p2v>
801081b4:	83 c4 04             	add    $0x4,%esp
801081b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081ba:	eb 48                	jmp    80108204 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801081bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801081c0:	74 0e                	je     801081d0 <walkpgdir+0x53>
801081c2:	e8 ef aa ff ff       	call   80102cb6 <kalloc>
801081c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801081ce:	75 07                	jne    801081d7 <walkpgdir+0x5a>
      return 0;
801081d0:	b8 00 00 00 00       	mov    $0x0,%eax
801081d5:	eb 44                	jmp    8010821b <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801081d7:	83 ec 04             	sub    $0x4,%esp
801081da:	68 00 10 00 00       	push   $0x1000
801081df:	6a 00                	push   $0x0
801081e1:	ff 75 f4             	pushl  -0xc(%ebp)
801081e4:	e8 9c d4 ff ff       	call   80105685 <memset>
801081e9:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801081ec:	83 ec 0c             	sub    $0xc,%esp
801081ef:	ff 75 f4             	pushl  -0xc(%ebp)
801081f2:	e8 f7 fa ff ff       	call   80107cee <v2p>
801081f7:	83 c4 10             	add    $0x10,%esp
801081fa:	83 c8 07             	or     $0x7,%eax
801081fd:	89 c2                	mov    %eax,%edx
801081ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108202:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108204:	8b 45 0c             	mov    0xc(%ebp),%eax
80108207:	c1 e8 0c             	shr    $0xc,%eax
8010820a:	25 ff 03 00 00       	and    $0x3ff,%eax
8010820f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108219:	01 d0                	add    %edx,%eax
}
8010821b:	c9                   	leave  
8010821c:	c3                   	ret    

8010821d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010821d:	55                   	push   %ebp
8010821e:	89 e5                	mov    %esp,%ebp
80108220:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108223:	8b 45 0c             	mov    0xc(%ebp),%eax
80108226:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010822b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010822e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108231:	8b 45 10             	mov    0x10(%ebp),%eax
80108234:	01 d0                	add    %edx,%eax
80108236:	83 e8 01             	sub    $0x1,%eax
80108239:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010823e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108241:	83 ec 04             	sub    $0x4,%esp
80108244:	6a 01                	push   $0x1
80108246:	ff 75 f4             	pushl  -0xc(%ebp)
80108249:	ff 75 08             	pushl  0x8(%ebp)
8010824c:	e8 2c ff ff ff       	call   8010817d <walkpgdir>
80108251:	83 c4 10             	add    $0x10,%esp
80108254:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108257:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010825b:	75 07                	jne    80108264 <mappages+0x47>
      return -1;
8010825d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108262:	eb 47                	jmp    801082ab <mappages+0x8e>
    if(*pte & PTE_P)
80108264:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108267:	8b 00                	mov    (%eax),%eax
80108269:	83 e0 01             	and    $0x1,%eax
8010826c:	85 c0                	test   %eax,%eax
8010826e:	74 0d                	je     8010827d <mappages+0x60>
      panic("remap");
80108270:	83 ec 0c             	sub    $0xc,%esp
80108273:	68 f0 90 10 80       	push   $0x801090f0
80108278:	e8 e9 82 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010827d:	8b 45 18             	mov    0x18(%ebp),%eax
80108280:	0b 45 14             	or     0x14(%ebp),%eax
80108283:	83 c8 01             	or     $0x1,%eax
80108286:	89 c2                	mov    %eax,%edx
80108288:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010828b:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010828d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108293:	74 10                	je     801082a5 <mappages+0x88>
      break;
    a += PGSIZE;
80108295:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010829c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801082a3:	eb 9c                	jmp    80108241 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801082a5:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801082a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082ab:	c9                   	leave  
801082ac:	c3                   	ret    

801082ad <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801082ad:	55                   	push   %ebp
801082ae:	89 e5                	mov    %esp,%ebp
801082b0:	53                   	push   %ebx
801082b1:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801082b4:	e8 fd a9 ff ff       	call   80102cb6 <kalloc>
801082b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082c0:	75 0a                	jne    801082cc <setupkvm+0x1f>
    return 0;
801082c2:	b8 00 00 00 00       	mov    $0x0,%eax
801082c7:	e9 8e 00 00 00       	jmp    8010835a <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801082cc:	83 ec 04             	sub    $0x4,%esp
801082cf:	68 00 10 00 00       	push   $0x1000
801082d4:	6a 00                	push   $0x0
801082d6:	ff 75 f0             	pushl  -0x10(%ebp)
801082d9:	e8 a7 d3 ff ff       	call   80105685 <memset>
801082de:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801082e1:	83 ec 0c             	sub    $0xc,%esp
801082e4:	68 00 00 00 0e       	push   $0xe000000
801082e9:	e8 0d fa ff ff       	call   80107cfb <p2v>
801082ee:	83 c4 10             	add    $0x10,%esp
801082f1:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801082f6:	76 0d                	jbe    80108305 <setupkvm+0x58>
    panic("PHYSTOP too high");
801082f8:	83 ec 0c             	sub    $0xc,%esp
801082fb:	68 f6 90 10 80       	push   $0x801090f6
80108300:	e8 61 82 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108305:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
8010830c:	eb 40                	jmp    8010834e <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010830e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108311:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108317:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010831a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010831d:	8b 58 08             	mov    0x8(%eax),%ebx
80108320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108323:	8b 40 04             	mov    0x4(%eax),%eax
80108326:	29 c3                	sub    %eax,%ebx
80108328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832b:	8b 00                	mov    (%eax),%eax
8010832d:	83 ec 0c             	sub    $0xc,%esp
80108330:	51                   	push   %ecx
80108331:	52                   	push   %edx
80108332:	53                   	push   %ebx
80108333:	50                   	push   %eax
80108334:	ff 75 f0             	pushl  -0x10(%ebp)
80108337:	e8 e1 fe ff ff       	call   8010821d <mappages>
8010833c:	83 c4 20             	add    $0x20,%esp
8010833f:	85 c0                	test   %eax,%eax
80108341:	79 07                	jns    8010834a <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108343:	b8 00 00 00 00       	mov    $0x0,%eax
80108348:	eb 10                	jmp    8010835a <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010834a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010834e:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108355:	72 b7                	jb     8010830e <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108357:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010835a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010835d:	c9                   	leave  
8010835e:	c3                   	ret    

8010835f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010835f:	55                   	push   %ebp
80108360:	89 e5                	mov    %esp,%ebp
80108362:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108365:	e8 43 ff ff ff       	call   801082ad <setupkvm>
8010836a:	a3 58 66 11 80       	mov    %eax,0x80116658
  switchkvm();
8010836f:	e8 03 00 00 00       	call   80108377 <switchkvm>
}
80108374:	90                   	nop
80108375:	c9                   	leave  
80108376:	c3                   	ret    

80108377 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108377:	55                   	push   %ebp
80108378:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010837a:	a1 58 66 11 80       	mov    0x80116658,%eax
8010837f:	50                   	push   %eax
80108380:	e8 69 f9 ff ff       	call   80107cee <v2p>
80108385:	83 c4 04             	add    $0x4,%esp
80108388:	50                   	push   %eax
80108389:	e8 54 f9 ff ff       	call   80107ce2 <lcr3>
8010838e:	83 c4 04             	add    $0x4,%esp
}
80108391:	90                   	nop
80108392:	c9                   	leave  
80108393:	c3                   	ret    

80108394 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108394:	55                   	push   %ebp
80108395:	89 e5                	mov    %esp,%ebp
80108397:	56                   	push   %esi
80108398:	53                   	push   %ebx
  pushcli();
80108399:	e8 e1 d1 ff ff       	call   8010557f <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010839e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083a4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801083ab:	83 c2 08             	add    $0x8,%edx
801083ae:	89 d6                	mov    %edx,%esi
801083b0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801083b7:	83 c2 08             	add    $0x8,%edx
801083ba:	c1 ea 10             	shr    $0x10,%edx
801083bd:	89 d3                	mov    %edx,%ebx
801083bf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801083c6:	83 c2 08             	add    $0x8,%edx
801083c9:	c1 ea 18             	shr    $0x18,%edx
801083cc:	89 d1                	mov    %edx,%ecx
801083ce:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801083d5:	67 00 
801083d7:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801083de:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801083e4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083eb:	83 e2 f0             	and    $0xfffffff0,%edx
801083ee:	83 ca 09             	or     $0x9,%edx
801083f1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801083f7:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083fe:	83 ca 10             	or     $0x10,%edx
80108401:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108407:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010840e:	83 e2 9f             	and    $0xffffff9f,%edx
80108411:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108417:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010841e:	83 ca 80             	or     $0xffffff80,%edx
80108421:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108427:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010842e:	83 e2 f0             	and    $0xfffffff0,%edx
80108431:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108437:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010843e:	83 e2 ef             	and    $0xffffffef,%edx
80108441:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108447:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010844e:	83 e2 df             	and    $0xffffffdf,%edx
80108451:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108457:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010845e:	83 ca 40             	or     $0x40,%edx
80108461:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108467:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010846e:	83 e2 7f             	and    $0x7f,%edx
80108471:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108477:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010847d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108483:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010848a:	83 e2 ef             	and    $0xffffffef,%edx
8010848d:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108493:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108499:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010849f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084a5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801084ac:	8b 52 08             	mov    0x8(%edx),%edx
801084af:	81 c2 00 10 00 00    	add    $0x1000,%edx
801084b5:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801084b8:	83 ec 0c             	sub    $0xc,%esp
801084bb:	6a 30                	push   $0x30
801084bd:	e8 f3 f7 ff ff       	call   80107cb5 <ltr>
801084c2:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801084c5:	8b 45 08             	mov    0x8(%ebp),%eax
801084c8:	8b 40 04             	mov    0x4(%eax),%eax
801084cb:	85 c0                	test   %eax,%eax
801084cd:	75 0d                	jne    801084dc <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801084cf:	83 ec 0c             	sub    $0xc,%esp
801084d2:	68 07 91 10 80       	push   $0x80109107
801084d7:	e8 8a 80 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801084dc:	8b 45 08             	mov    0x8(%ebp),%eax
801084df:	8b 40 04             	mov    0x4(%eax),%eax
801084e2:	83 ec 0c             	sub    $0xc,%esp
801084e5:	50                   	push   %eax
801084e6:	e8 03 f8 ff ff       	call   80107cee <v2p>
801084eb:	83 c4 10             	add    $0x10,%esp
801084ee:	83 ec 0c             	sub    $0xc,%esp
801084f1:	50                   	push   %eax
801084f2:	e8 eb f7 ff ff       	call   80107ce2 <lcr3>
801084f7:	83 c4 10             	add    $0x10,%esp
  popcli();
801084fa:	e8 c5 d0 ff ff       	call   801055c4 <popcli>
}
801084ff:	90                   	nop
80108500:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108503:	5b                   	pop    %ebx
80108504:	5e                   	pop    %esi
80108505:	5d                   	pop    %ebp
80108506:	c3                   	ret    

80108507 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108507:	55                   	push   %ebp
80108508:	89 e5                	mov    %esp,%ebp
8010850a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010850d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108514:	76 0d                	jbe    80108523 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108516:	83 ec 0c             	sub    $0xc,%esp
80108519:	68 1b 91 10 80       	push   $0x8010911b
8010851e:	e8 43 80 ff ff       	call   80100566 <panic>
  mem = kalloc();
80108523:	e8 8e a7 ff ff       	call   80102cb6 <kalloc>
80108528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010852b:	83 ec 04             	sub    $0x4,%esp
8010852e:	68 00 10 00 00       	push   $0x1000
80108533:	6a 00                	push   $0x0
80108535:	ff 75 f4             	pushl  -0xc(%ebp)
80108538:	e8 48 d1 ff ff       	call   80105685 <memset>
8010853d:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108540:	83 ec 0c             	sub    $0xc,%esp
80108543:	ff 75 f4             	pushl  -0xc(%ebp)
80108546:	e8 a3 f7 ff ff       	call   80107cee <v2p>
8010854b:	83 c4 10             	add    $0x10,%esp
8010854e:	83 ec 0c             	sub    $0xc,%esp
80108551:	6a 06                	push   $0x6
80108553:	50                   	push   %eax
80108554:	68 00 10 00 00       	push   $0x1000
80108559:	6a 00                	push   $0x0
8010855b:	ff 75 08             	pushl  0x8(%ebp)
8010855e:	e8 ba fc ff ff       	call   8010821d <mappages>
80108563:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108566:	83 ec 04             	sub    $0x4,%esp
80108569:	ff 75 10             	pushl  0x10(%ebp)
8010856c:	ff 75 0c             	pushl  0xc(%ebp)
8010856f:	ff 75 f4             	pushl  -0xc(%ebp)
80108572:	e8 cd d1 ff ff       	call   80105744 <memmove>
80108577:	83 c4 10             	add    $0x10,%esp
}
8010857a:	90                   	nop
8010857b:	c9                   	leave  
8010857c:	c3                   	ret    

8010857d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010857d:	55                   	push   %ebp
8010857e:	89 e5                	mov    %esp,%ebp
80108580:	53                   	push   %ebx
80108581:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108584:	8b 45 0c             	mov    0xc(%ebp),%eax
80108587:	25 ff 0f 00 00       	and    $0xfff,%eax
8010858c:	85 c0                	test   %eax,%eax
8010858e:	74 0d                	je     8010859d <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108590:	83 ec 0c             	sub    $0xc,%esp
80108593:	68 38 91 10 80       	push   $0x80109138
80108598:	e8 c9 7f ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010859d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085a4:	e9 95 00 00 00       	jmp    8010863e <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801085a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801085ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085af:	01 d0                	add    %edx,%eax
801085b1:	83 ec 04             	sub    $0x4,%esp
801085b4:	6a 00                	push   $0x0
801085b6:	50                   	push   %eax
801085b7:	ff 75 08             	pushl  0x8(%ebp)
801085ba:	e8 be fb ff ff       	call   8010817d <walkpgdir>
801085bf:	83 c4 10             	add    $0x10,%esp
801085c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801085c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801085c9:	75 0d                	jne    801085d8 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801085cb:	83 ec 0c             	sub    $0xc,%esp
801085ce:	68 5b 91 10 80       	push   $0x8010915b
801085d3:	e8 8e 7f ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801085d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085db:	8b 00                	mov    (%eax),%eax
801085dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801085e5:	8b 45 18             	mov    0x18(%ebp),%eax
801085e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801085eb:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801085f0:	77 0b                	ja     801085fd <loaduvm+0x80>
      n = sz - i;
801085f2:	8b 45 18             	mov    0x18(%ebp),%eax
801085f5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801085f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085fb:	eb 07                	jmp    80108604 <loaduvm+0x87>
    else
      n = PGSIZE;
801085fd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108604:	8b 55 14             	mov    0x14(%ebp),%edx
80108607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010860d:	83 ec 0c             	sub    $0xc,%esp
80108610:	ff 75 e8             	pushl  -0x18(%ebp)
80108613:	e8 e3 f6 ff ff       	call   80107cfb <p2v>
80108618:	83 c4 10             	add    $0x10,%esp
8010861b:	ff 75 f0             	pushl  -0x10(%ebp)
8010861e:	53                   	push   %ebx
8010861f:	50                   	push   %eax
80108620:	ff 75 10             	pushl  0x10(%ebp)
80108623:	e8 00 99 ff ff       	call   80101f28 <readi>
80108628:	83 c4 10             	add    $0x10,%esp
8010862b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010862e:	74 07                	je     80108637 <loaduvm+0xba>
      return -1;
80108630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108635:	eb 18                	jmp    8010864f <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108637:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010863e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108641:	3b 45 18             	cmp    0x18(%ebp),%eax
80108644:	0f 82 5f ff ff ff    	jb     801085a9 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010864a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010864f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108652:	c9                   	leave  
80108653:	c3                   	ret    

80108654 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108654:	55                   	push   %ebp
80108655:	89 e5                	mov    %esp,%ebp
80108657:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010865a:	8b 45 10             	mov    0x10(%ebp),%eax
8010865d:	85 c0                	test   %eax,%eax
8010865f:	79 0a                	jns    8010866b <allocuvm+0x17>
    return 0;
80108661:	b8 00 00 00 00       	mov    $0x0,%eax
80108666:	e9 b0 00 00 00       	jmp    8010871b <allocuvm+0xc7>
  if(newsz < oldsz)
8010866b:	8b 45 10             	mov    0x10(%ebp),%eax
8010866e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108671:	73 08                	jae    8010867b <allocuvm+0x27>
    return oldsz;
80108673:	8b 45 0c             	mov    0xc(%ebp),%eax
80108676:	e9 a0 00 00 00       	jmp    8010871b <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010867b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010867e:	05 ff 0f 00 00       	add    $0xfff,%eax
80108683:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010868b:	eb 7f                	jmp    8010870c <allocuvm+0xb8>
    mem = kalloc();
8010868d:	e8 24 a6 ff ff       	call   80102cb6 <kalloc>
80108692:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108695:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108699:	75 2b                	jne    801086c6 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010869b:	83 ec 0c             	sub    $0xc,%esp
8010869e:	68 79 91 10 80       	push   $0x80109179
801086a3:	e8 1e 7d ff ff       	call   801003c6 <cprintf>
801086a8:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801086ab:	83 ec 04             	sub    $0x4,%esp
801086ae:	ff 75 0c             	pushl  0xc(%ebp)
801086b1:	ff 75 10             	pushl  0x10(%ebp)
801086b4:	ff 75 08             	pushl  0x8(%ebp)
801086b7:	e8 61 00 00 00       	call   8010871d <deallocuvm>
801086bc:	83 c4 10             	add    $0x10,%esp
      return 0;
801086bf:	b8 00 00 00 00       	mov    $0x0,%eax
801086c4:	eb 55                	jmp    8010871b <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801086c6:	83 ec 04             	sub    $0x4,%esp
801086c9:	68 00 10 00 00       	push   $0x1000
801086ce:	6a 00                	push   $0x0
801086d0:	ff 75 f0             	pushl  -0x10(%ebp)
801086d3:	e8 ad cf ff ff       	call   80105685 <memset>
801086d8:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801086db:	83 ec 0c             	sub    $0xc,%esp
801086de:	ff 75 f0             	pushl  -0x10(%ebp)
801086e1:	e8 08 f6 ff ff       	call   80107cee <v2p>
801086e6:	83 c4 10             	add    $0x10,%esp
801086e9:	89 c2                	mov    %eax,%edx
801086eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ee:	83 ec 0c             	sub    $0xc,%esp
801086f1:	6a 06                	push   $0x6
801086f3:	52                   	push   %edx
801086f4:	68 00 10 00 00       	push   $0x1000
801086f9:	50                   	push   %eax
801086fa:	ff 75 08             	pushl  0x8(%ebp)
801086fd:	e8 1b fb ff ff       	call   8010821d <mappages>
80108702:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108705:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010870c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010870f:	3b 45 10             	cmp    0x10(%ebp),%eax
80108712:	0f 82 75 ff ff ff    	jb     8010868d <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108718:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010871b:	c9                   	leave  
8010871c:	c3                   	ret    

8010871d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010871d:	55                   	push   %ebp
8010871e:	89 e5                	mov    %esp,%ebp
80108720:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108723:	8b 45 10             	mov    0x10(%ebp),%eax
80108726:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108729:	72 08                	jb     80108733 <deallocuvm+0x16>
    return oldsz;
8010872b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010872e:	e9 a5 00 00 00       	jmp    801087d8 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108733:	8b 45 10             	mov    0x10(%ebp),%eax
80108736:	05 ff 0f 00 00       	add    $0xfff,%eax
8010873b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108743:	e9 81 00 00 00       	jmp    801087c9 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874b:	83 ec 04             	sub    $0x4,%esp
8010874e:	6a 00                	push   $0x0
80108750:	50                   	push   %eax
80108751:	ff 75 08             	pushl  0x8(%ebp)
80108754:	e8 24 fa ff ff       	call   8010817d <walkpgdir>
80108759:	83 c4 10             	add    $0x10,%esp
8010875c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010875f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108763:	75 09                	jne    8010876e <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108765:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010876c:	eb 54                	jmp    801087c2 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010876e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108771:	8b 00                	mov    (%eax),%eax
80108773:	83 e0 01             	and    $0x1,%eax
80108776:	85 c0                	test   %eax,%eax
80108778:	74 48                	je     801087c2 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
8010877a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010877d:	8b 00                	mov    (%eax),%eax
8010877f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108784:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108787:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010878b:	75 0d                	jne    8010879a <deallocuvm+0x7d>
        panic("kfree");
8010878d:	83 ec 0c             	sub    $0xc,%esp
80108790:	68 91 91 10 80       	push   $0x80109191
80108795:	e8 cc 7d ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
8010879a:	83 ec 0c             	sub    $0xc,%esp
8010879d:	ff 75 ec             	pushl  -0x14(%ebp)
801087a0:	e8 56 f5 ff ff       	call   80107cfb <p2v>
801087a5:	83 c4 10             	add    $0x10,%esp
801087a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801087ab:	83 ec 0c             	sub    $0xc,%esp
801087ae:	ff 75 e8             	pushl  -0x18(%ebp)
801087b1:	e8 63 a4 ff ff       	call   80102c19 <kfree>
801087b6:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801087b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801087c2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801087cf:	0f 82 73 ff ff ff    	jb     80108748 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801087d5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801087d8:	c9                   	leave  
801087d9:	c3                   	ret    

801087da <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801087da:	55                   	push   %ebp
801087db:	89 e5                	mov    %esp,%ebp
801087dd:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801087e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801087e4:	75 0d                	jne    801087f3 <freevm+0x19>
    panic("freevm: no pgdir");
801087e6:	83 ec 0c             	sub    $0xc,%esp
801087e9:	68 97 91 10 80       	push   $0x80109197
801087ee:	e8 73 7d ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801087f3:	83 ec 04             	sub    $0x4,%esp
801087f6:	6a 00                	push   $0x0
801087f8:	68 00 00 00 80       	push   $0x80000000
801087fd:	ff 75 08             	pushl  0x8(%ebp)
80108800:	e8 18 ff ff ff       	call   8010871d <deallocuvm>
80108805:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010880f:	eb 4f                	jmp    80108860 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108814:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010881b:	8b 45 08             	mov    0x8(%ebp),%eax
8010881e:	01 d0                	add    %edx,%eax
80108820:	8b 00                	mov    (%eax),%eax
80108822:	83 e0 01             	and    $0x1,%eax
80108825:	85 c0                	test   %eax,%eax
80108827:	74 33                	je     8010885c <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108833:	8b 45 08             	mov    0x8(%ebp),%eax
80108836:	01 d0                	add    %edx,%eax
80108838:	8b 00                	mov    (%eax),%eax
8010883a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010883f:	83 ec 0c             	sub    $0xc,%esp
80108842:	50                   	push   %eax
80108843:	e8 b3 f4 ff ff       	call   80107cfb <p2v>
80108848:	83 c4 10             	add    $0x10,%esp
8010884b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010884e:	83 ec 0c             	sub    $0xc,%esp
80108851:	ff 75 f0             	pushl  -0x10(%ebp)
80108854:	e8 c0 a3 ff ff       	call   80102c19 <kfree>
80108859:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010885c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108860:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108867:	76 a8                	jbe    80108811 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108869:	83 ec 0c             	sub    $0xc,%esp
8010886c:	ff 75 08             	pushl  0x8(%ebp)
8010886f:	e8 a5 a3 ff ff       	call   80102c19 <kfree>
80108874:	83 c4 10             	add    $0x10,%esp
}
80108877:	90                   	nop
80108878:	c9                   	leave  
80108879:	c3                   	ret    

8010887a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010887a:	55                   	push   %ebp
8010887b:	89 e5                	mov    %esp,%ebp
8010887d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108880:	83 ec 04             	sub    $0x4,%esp
80108883:	6a 00                	push   $0x0
80108885:	ff 75 0c             	pushl  0xc(%ebp)
80108888:	ff 75 08             	pushl  0x8(%ebp)
8010888b:	e8 ed f8 ff ff       	call   8010817d <walkpgdir>
80108890:	83 c4 10             	add    $0x10,%esp
80108893:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010889a:	75 0d                	jne    801088a9 <clearpteu+0x2f>
    panic("clearpteu");
8010889c:	83 ec 0c             	sub    $0xc,%esp
8010889f:	68 a8 91 10 80       	push   $0x801091a8
801088a4:	e8 bd 7c ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801088a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ac:	8b 00                	mov    (%eax),%eax
801088ae:	83 e0 fb             	and    $0xfffffffb,%eax
801088b1:	89 c2                	mov    %eax,%edx
801088b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b6:	89 10                	mov    %edx,(%eax)
}
801088b8:	90                   	nop
801088b9:	c9                   	leave  
801088ba:	c3                   	ret    

801088bb <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801088bb:	55                   	push   %ebp
801088bc:	89 e5                	mov    %esp,%ebp
801088be:	53                   	push   %ebx
801088bf:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801088c2:	e8 e6 f9 ff ff       	call   801082ad <setupkvm>
801088c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088ce:	75 0a                	jne    801088da <copyuvm+0x1f>
    return 0;
801088d0:	b8 00 00 00 00       	mov    $0x0,%eax
801088d5:	e9 f8 00 00 00       	jmp    801089d2 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801088da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801088e1:	e9 c4 00 00 00       	jmp    801089aa <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801088e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e9:	83 ec 04             	sub    $0x4,%esp
801088ec:	6a 00                	push   $0x0
801088ee:	50                   	push   %eax
801088ef:	ff 75 08             	pushl  0x8(%ebp)
801088f2:	e8 86 f8 ff ff       	call   8010817d <walkpgdir>
801088f7:	83 c4 10             	add    $0x10,%esp
801088fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
801088fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108901:	75 0d                	jne    80108910 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108903:	83 ec 0c             	sub    $0xc,%esp
80108906:	68 b2 91 10 80       	push   $0x801091b2
8010890b:	e8 56 7c ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108910:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108913:	8b 00                	mov    (%eax),%eax
80108915:	83 e0 01             	and    $0x1,%eax
80108918:	85 c0                	test   %eax,%eax
8010891a:	75 0d                	jne    80108929 <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010891c:	83 ec 0c             	sub    $0xc,%esp
8010891f:	68 cc 91 10 80       	push   $0x801091cc
80108924:	e8 3d 7c ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108929:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010892c:	8b 00                	mov    (%eax),%eax
8010892e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108933:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108936:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108939:	8b 00                	mov    (%eax),%eax
8010893b:	25 ff 0f 00 00       	and    $0xfff,%eax
80108940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108943:	e8 6e a3 ff ff       	call   80102cb6 <kalloc>
80108948:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010894b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010894f:	74 6a                	je     801089bb <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108951:	83 ec 0c             	sub    $0xc,%esp
80108954:	ff 75 e8             	pushl  -0x18(%ebp)
80108957:	e8 9f f3 ff ff       	call   80107cfb <p2v>
8010895c:	83 c4 10             	add    $0x10,%esp
8010895f:	83 ec 04             	sub    $0x4,%esp
80108962:	68 00 10 00 00       	push   $0x1000
80108967:	50                   	push   %eax
80108968:	ff 75 e0             	pushl  -0x20(%ebp)
8010896b:	e8 d4 cd ff ff       	call   80105744 <memmove>
80108970:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108973:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108976:	83 ec 0c             	sub    $0xc,%esp
80108979:	ff 75 e0             	pushl  -0x20(%ebp)
8010897c:	e8 6d f3 ff ff       	call   80107cee <v2p>
80108981:	83 c4 10             	add    $0x10,%esp
80108984:	89 c2                	mov    %eax,%edx
80108986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108989:	83 ec 0c             	sub    $0xc,%esp
8010898c:	53                   	push   %ebx
8010898d:	52                   	push   %edx
8010898e:	68 00 10 00 00       	push   $0x1000
80108993:	50                   	push   %eax
80108994:	ff 75 f0             	pushl  -0x10(%ebp)
80108997:	e8 81 f8 ff ff       	call   8010821d <mappages>
8010899c:	83 c4 20             	add    $0x20,%esp
8010899f:	85 c0                	test   %eax,%eax
801089a1:	78 1b                	js     801089be <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801089a3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089b0:	0f 82 30 ff ff ff    	jb     801088e6 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801089b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089b9:	eb 17                	jmp    801089d2 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801089bb:	90                   	nop
801089bc:	eb 01                	jmp    801089bf <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801089be:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801089bf:	83 ec 0c             	sub    $0xc,%esp
801089c2:	ff 75 f0             	pushl  -0x10(%ebp)
801089c5:	e8 10 fe ff ff       	call   801087da <freevm>
801089ca:	83 c4 10             	add    $0x10,%esp
  return 0;
801089cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801089d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801089d5:	c9                   	leave  
801089d6:	c3                   	ret    

801089d7 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801089d7:	55                   	push   %ebp
801089d8:	89 e5                	mov    %esp,%ebp
801089da:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801089dd:	83 ec 04             	sub    $0x4,%esp
801089e0:	6a 00                	push   $0x0
801089e2:	ff 75 0c             	pushl  0xc(%ebp)
801089e5:	ff 75 08             	pushl  0x8(%ebp)
801089e8:	e8 90 f7 ff ff       	call   8010817d <walkpgdir>
801089ed:	83 c4 10             	add    $0x10,%esp
801089f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801089f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f6:	8b 00                	mov    (%eax),%eax
801089f8:	83 e0 01             	and    $0x1,%eax
801089fb:	85 c0                	test   %eax,%eax
801089fd:	75 07                	jne    80108a06 <uva2ka+0x2f>
    return 0;
801089ff:	b8 00 00 00 00       	mov    $0x0,%eax
80108a04:	eb 29                	jmp    80108a2f <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a09:	8b 00                	mov    (%eax),%eax
80108a0b:	83 e0 04             	and    $0x4,%eax
80108a0e:	85 c0                	test   %eax,%eax
80108a10:	75 07                	jne    80108a19 <uva2ka+0x42>
    return 0;
80108a12:	b8 00 00 00 00       	mov    $0x0,%eax
80108a17:	eb 16                	jmp    80108a2f <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a1c:	8b 00                	mov    (%eax),%eax
80108a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a23:	83 ec 0c             	sub    $0xc,%esp
80108a26:	50                   	push   %eax
80108a27:	e8 cf f2 ff ff       	call   80107cfb <p2v>
80108a2c:	83 c4 10             	add    $0x10,%esp
}
80108a2f:	c9                   	leave  
80108a30:	c3                   	ret    

80108a31 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108a31:	55                   	push   %ebp
80108a32:	89 e5                	mov    %esp,%ebp
80108a34:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108a37:	8b 45 10             	mov    0x10(%ebp),%eax
80108a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108a3d:	eb 7f                	jmp    80108abe <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a4d:	83 ec 08             	sub    $0x8,%esp
80108a50:	50                   	push   %eax
80108a51:	ff 75 08             	pushl  0x8(%ebp)
80108a54:	e8 7e ff ff ff       	call   801089d7 <uva2ka>
80108a59:	83 c4 10             	add    $0x10,%esp
80108a5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108a5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108a63:	75 07                	jne    80108a6c <copyout+0x3b>
      return -1;
80108a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a6a:	eb 61                	jmp    80108acd <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a6f:	2b 45 0c             	sub    0xc(%ebp),%eax
80108a72:	05 00 10 00 00       	add    $0x1000,%eax
80108a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a7d:	3b 45 14             	cmp    0x14(%ebp),%eax
80108a80:	76 06                	jbe    80108a88 <copyout+0x57>
      n = len;
80108a82:	8b 45 14             	mov    0x14(%ebp),%eax
80108a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108a88:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a8b:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108a8e:	89 c2                	mov    %eax,%edx
80108a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a93:	01 d0                	add    %edx,%eax
80108a95:	83 ec 04             	sub    $0x4,%esp
80108a98:	ff 75 f0             	pushl  -0x10(%ebp)
80108a9b:	ff 75 f4             	pushl  -0xc(%ebp)
80108a9e:	50                   	push   %eax
80108a9f:	e8 a0 cc ff ff       	call   80105744 <memmove>
80108aa4:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aaa:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ab0:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ab6:	05 00 10 00 00       	add    $0x1000,%eax
80108abb:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108abe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108ac2:	0f 85 77 ff ff ff    	jne    80108a3f <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108acd:	c9                   	leave  
80108ace:	c3                   	ret    
