
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
80100028:	bc 90 d6 10 80       	mov    $0x8010d690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 eb 39 10 80       	mov    $0x801039eb,%eax
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
8010003d:	68 78 8d 10 80       	push   $0x80108d78
80100042:	68 a0 d6 10 80       	push   $0x8010d6a0
80100047:	e8 c0 54 00 00       	call   8010550c <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 15 11 80 a4 	movl   $0x801115a4,0x801115b0
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 15 11 80 a4 	movl   $0x801115a4,0x801115b4
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 d6 10 80 	movl   $0x8010d6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 15 11 80    	mov    0x801115b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 15 11 80 	movl   $0x801115a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 15 11 80       	mov    %eax,0x801115b4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 15 11 80       	mov    $0x801115a4,%eax
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
801000bc:	68 a0 d6 10 80       	push   $0x8010d6a0
801000c1:	e8 68 54 00 00       	call   8010552e <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 15 11 80       	mov    0x801115b4,%eax
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
80100107:	68 a0 d6 10 80       	push   $0x8010d6a0
8010010c:	e8 84 54 00 00       	call   80105595 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 d6 10 80       	push   $0x8010d6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 6b 4e 00 00       	call   80104f97 <sleep>
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
8010013a:	81 7d f4 a4 15 11 80 	cmpl   $0x801115a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 15 11 80       	mov    0x801115b0,%eax
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
80100183:	68 a0 d6 10 80       	push   $0x8010d6a0
80100188:	e8 08 54 00 00       	call   80105595 <release>
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
8010019e:	81 7d f4 a4 15 11 80 	cmpl   $0x801115a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 7f 8d 10 80       	push   $0x80108d7f
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
801001e2:	e8 82 28 00 00       	call   80102a69 <iderw>
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
80100204:	68 90 8d 10 80       	push   $0x80108d90
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
80100223:	e8 41 28 00 00       	call   80102a69 <iderw>
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
80100243:	68 97 8d 10 80       	push   $0x80108d97
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 d6 10 80       	push   $0x8010d6a0
80100255:	e8 d4 52 00 00       	call   8010552e <acquire>
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
8010027b:	8b 15 b4 15 11 80    	mov    0x801115b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 15 11 80 	movl   $0x801115a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 15 11 80       	mov    %eax,0x801115b4

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
801002b9:	e8 c7 4d 00 00       	call   80105085 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 d6 10 80       	push   $0x8010d6a0
801002c9:	e8 c7 52 00 00       	call   80105595 <release>
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
801003cc:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 c6 10 80       	push   $0x8010c600
801003e2:	e8 47 51 00 00       	call   8010552e <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 9e 8d 10 80       	push   $0x80108d9e
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
801004cd:	c7 45 ec a7 8d 10 80 	movl   $0x80108da7,-0x14(%ebp)
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
80100556:	68 00 c6 10 80       	push   $0x8010c600
8010055b:	e8 35 50 00 00       	call   80105595 <release>
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
80100571:	c7 05 34 c6 10 80 00 	movl   $0x0,0x8010c634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 ae 8d 10 80       	push   $0x80108dae
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
801005aa:	68 bd 8d 10 80       	push   $0x80108dbd
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 20 50 00 00       	call   801055e7 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 bf 8d 10 80       	push   $0x80108dbf
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
801005f5:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
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
801006ca:	68 c3 8d 10 80       	push   $0x80108dc3
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
801006f7:	e8 54 51 00 00       	call   80105850 <memmove>
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
80100721:	e8 6b 50 00 00       	call   80105791 <memset>
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
80100798:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
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
801007b6:	e8 44 6c 00 00       	call   801073ff <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 37 6c 00 00       	call   801073ff <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 2a 6c 00 00       	call   801073ff <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 1a 6c 00 00       	call   801073ff <uartputc>
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
80100809:	68 00 c6 10 80       	push   $0x8010c600
8010080e:	e8 1b 4d 00 00       	call   8010552e <acquire>
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
8010084d:	a1 48 18 11 80       	mov    0x80111848,%eax
80100852:	83 e8 01             	sub    $0x1,%eax
80100855:	a3 48 18 11 80       	mov    %eax,0x80111848
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
8010086a:	8b 15 48 18 11 80    	mov    0x80111848,%edx
80100870:	a1 44 18 11 80       	mov    0x80111844,%eax
80100875:	39 c2                	cmp    %eax,%edx
80100877:	0f 84 e2 00 00 00    	je     8010095f <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010087d:	a1 48 18 11 80       	mov    0x80111848,%eax
80100882:	83 e8 01             	sub    $0x1,%eax
80100885:	83 e0 7f             	and    $0x7f,%eax
80100888:	0f b6 80 c0 17 11 80 	movzbl -0x7feee840(%eax),%eax
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
80100898:	8b 15 48 18 11 80    	mov    0x80111848,%edx
8010089e:	a1 44 18 11 80       	mov    0x80111844,%eax
801008a3:	39 c2                	cmp    %eax,%edx
801008a5:	0f 84 b4 00 00 00    	je     8010095f <consoleintr+0x166>
        input.e--;
801008ab:	a1 48 18 11 80       	mov    0x80111848,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 48 18 11 80       	mov    %eax,0x80111848
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
801008d7:	8b 15 48 18 11 80    	mov    0x80111848,%edx
801008dd:	a1 40 18 11 80       	mov    0x80111840,%eax
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
801008fe:	a1 48 18 11 80       	mov    0x80111848,%eax
80100903:	8d 50 01             	lea    0x1(%eax),%edx
80100906:	89 15 48 18 11 80    	mov    %edx,0x80111848
8010090c:	83 e0 7f             	and    $0x7f,%eax
8010090f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100912:	88 90 c0 17 11 80    	mov    %dl,-0x7feee840(%eax)
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
80100932:	a1 48 18 11 80       	mov    0x80111848,%eax
80100937:	8b 15 40 18 11 80    	mov    0x80111840,%edx
8010093d:	83 ea 80             	sub    $0xffffff80,%edx
80100940:	39 d0                	cmp    %edx,%eax
80100942:	75 1a                	jne    8010095e <consoleintr+0x165>
          input.w = input.e;
80100944:	a1 48 18 11 80       	mov    0x80111848,%eax
80100949:	a3 44 18 11 80       	mov    %eax,0x80111844
          wakeup(&input.r);
8010094e:	83 ec 0c             	sub    $0xc,%esp
80100951:	68 40 18 11 80       	push   $0x80111840
80100956:	e8 2a 47 00 00       	call   80105085 <wakeup>
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
80100974:	68 00 c6 10 80       	push   $0x8010c600
80100979:	e8 17 4c 00 00       	call   80105595 <release>
8010097e:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100985:	74 05                	je     8010098c <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
80100987:	e8 b9 47 00 00       	call   80105145 <procdump>
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
8010099b:	e8 5c 12 00 00       	call   80101bfc <iunlock>
801009a0:	83 c4 10             	add    $0x10,%esp
  target = n;
801009a3:	8b 45 10             	mov    0x10(%ebp),%eax
801009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009a9:	83 ec 0c             	sub    $0xc,%esp
801009ac:	68 00 c6 10 80       	push   $0x8010c600
801009b1:	e8 78 4b 00 00       	call   8010552e <acquire>
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
801009ce:	68 00 c6 10 80       	push   $0x8010c600
801009d3:	e8 bd 4b 00 00       	call   80105595 <release>
801009d8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009db:	83 ec 0c             	sub    $0xc,%esp
801009de:	ff 75 08             	pushl  0x8(%ebp)
801009e1:	e8 90 10 00 00       	call   80101a76 <ilock>
801009e6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ee:	e9 ab 00 00 00       	jmp    80100a9e <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
801009f3:	83 ec 08             	sub    $0x8,%esp
801009f6:	68 00 c6 10 80       	push   $0x8010c600
801009fb:	68 40 18 11 80       	push   $0x80111840
80100a00:	e8 92 45 00 00       	call   80104f97 <sleep>
80100a05:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a08:	8b 15 40 18 11 80    	mov    0x80111840,%edx
80100a0e:	a1 44 18 11 80       	mov    0x80111844,%eax
80100a13:	39 c2                	cmp    %eax,%edx
80100a15:	74 a7                	je     801009be <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a17:	a1 40 18 11 80       	mov    0x80111840,%eax
80100a1c:	8d 50 01             	lea    0x1(%eax),%edx
80100a1f:	89 15 40 18 11 80    	mov    %edx,0x80111840
80100a25:	83 e0 7f             	and    $0x7f,%eax
80100a28:	0f b6 80 c0 17 11 80 	movzbl -0x7feee840(%eax),%eax
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
80100a43:	a1 40 18 11 80       	mov    0x80111840,%eax
80100a48:	83 e8 01             	sub    $0x1,%eax
80100a4b:	a3 40 18 11 80       	mov    %eax,0x80111840
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
80100a79:	68 00 c6 10 80       	push   $0x8010c600
80100a7e:	e8 12 4b 00 00       	call   80105595 <release>
80100a83:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	ff 75 08             	pushl  0x8(%ebp)
80100a8c:	e8 e5 0f 00 00       	call   80101a76 <ilock>
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
80100aac:	e8 4b 11 00 00       	call   80101bfc <iunlock>
80100ab1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ab4:	83 ec 0c             	sub    $0xc,%esp
80100ab7:	68 00 c6 10 80       	push   $0x8010c600
80100abc:	e8 6d 4a 00 00       	call   8010552e <acquire>
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
80100af9:	68 00 c6 10 80       	push   $0x8010c600
80100afe:	e8 92 4a 00 00       	call   80105595 <release>
80100b03:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	ff 75 08             	pushl  0x8(%ebp)
80100b0c:	e8 65 0f 00 00       	call   80101a76 <ilock>
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
80100b22:	68 d6 8d 10 80       	push   $0x80108dd6
80100b27:	68 00 c6 10 80       	push   $0x8010c600
80100b2c:	e8 db 49 00 00       	call   8010550c <initlock>
80100b31:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b34:	c7 05 0c 22 11 80 a0 	movl   $0x80100aa0,0x8011220c
80100b3b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b3e:	c7 05 08 22 11 80 8f 	movl   $0x8010098f,0x80112208
80100b45:	09 10 80 
  cons.locking = 1;
80100b48:	c7 05 34 c6 10 80 01 	movl   $0x1,0x8010c634
80100b4f:	00 00 00 

  picenable(IRQ_KBD);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	6a 01                	push   $0x1
80100b57:	e8 2b 35 00 00       	call   80104087 <picenable>
80100b5c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b5f:	83 ec 08             	sub    $0x8,%esp
80100b62:	6a 00                	push   $0x0
80100b64:	6a 01                	push   $0x1
80100b66:	e8 cb 20 00 00       	call   80102c36 <ioapicenable>
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
80100b7a:	e8 2a 2b 00 00       	call   801036a9 <begin_op>
  if((ip = namei(path)) == 0){
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	ff 75 08             	pushl  0x8(%ebp)
80100b85:	e8 fa 1a 00 00       	call   80102684 <namei>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b94:	75 0f                	jne    80100ba5 <exec+0x34>
    end_op();
80100b96:	e8 9a 2b 00 00       	call   80103735 <end_op>
    return -1;
80100b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba0:	e9 ce 03 00 00       	jmp    80100f73 <exec+0x402>
  }
  ilock(ip);
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	ff 75 d8             	pushl  -0x28(%ebp)
80100bab:	e8 c6 0e 00 00       	call   80101a76 <ilock>
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
80100bc8:	e8 67 14 00 00       	call   80102034 <readi>
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
80100bea:	e8 65 79 00 00       	call   80108554 <setupkvm>
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
80100c28:	e8 07 14 00 00       	call   80102034 <readi>
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
80100c70:	e8 86 7c 00 00       	call   801088fb <allocuvm>
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
80100ca3:	e8 7c 7b 00 00       	call   80108824 <loaduvm>
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
80100cdc:	e8 7d 10 00 00       	call   80101d5e <iunlockput>
80100ce1:	83 c4 10             	add    $0x10,%esp
  end_op();
80100ce4:	e8 4c 2a 00 00       	call   80103735 <end_op>
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
80100d12:	e8 e4 7b 00 00       	call   801088fb <allocuvm>
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
80100d36:	e8 e6 7d 00 00       	call   80108b21 <clearpteu>
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
80100d6f:	e8 6a 4c 00 00       	call   801059de <strlen>
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
80100d9c:	e8 3d 4c 00 00       	call   801059de <strlen>
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
80100dc2:	e8 11 7f 00 00       	call   80108cd8 <copyout>
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
80100e5e:	e8 75 7e 00 00       	call   80108cd8 <copyout>
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
80100eaf:	e8 e0 4a 00 00       	call   80105994 <safestrcpy>
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
80100f05:	e8 31 77 00 00       	call   8010863b <switchuvm>
80100f0a:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f0d:	83 ec 0c             	sub    $0xc,%esp
80100f10:	ff 75 d0             	pushl  -0x30(%ebp)
80100f13:	e8 69 7b 00 00       	call   80108a81 <freevm>
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
80100f4d:	e8 2f 7b 00 00       	call   80108a81 <freevm>
80100f52:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f55:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f59:	74 13                	je     80100f6e <exec+0x3fd>
    iunlockput(ip);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 d8             	pushl  -0x28(%ebp)
80100f61:	e8 f8 0d 00 00       	call   80101d5e <iunlockput>
80100f66:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f69:	e8 c7 27 00 00       	call   80103735 <end_op>
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
80100f7e:	68 de 8d 10 80       	push   $0x80108dde
80100f83:	68 60 18 11 80       	push   $0x80111860
80100f88:	e8 7f 45 00 00       	call   8010550c <initlock>
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
80100f9c:	68 60 18 11 80       	push   $0x80111860
80100fa1:	e8 88 45 00 00       	call   8010552e <acquire>
80100fa6:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa9:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
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
80100fc9:	68 60 18 11 80       	push   $0x80111860
80100fce:	e8 c2 45 00 00       	call   80105595 <release>
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
80100fdf:	b8 f4 21 11 80       	mov    $0x801121f4,%eax
80100fe4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fe7:	72 c9                	jb     80100fb2 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fe9:	83 ec 0c             	sub    $0xc,%esp
80100fec:	68 60 18 11 80       	push   $0x80111860
80100ff1:	e8 9f 45 00 00       	call   80105595 <release>
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
80101009:	68 60 18 11 80       	push   $0x80111860
8010100e:	e8 1b 45 00 00       	call   8010552e <acquire>
80101013:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	7f 0d                	jg     8010102d <filedup+0x2d>
    panic("filedup");
80101020:	83 ec 0c             	sub    $0xc,%esp
80101023:	68 e5 8d 10 80       	push   $0x80108de5
80101028:	e8 39 f5 ff ff       	call   80100566 <panic>
  f->ref++;
8010102d:	8b 45 08             	mov    0x8(%ebp),%eax
80101030:	8b 40 04             	mov    0x4(%eax),%eax
80101033:	8d 50 01             	lea    0x1(%eax),%edx
80101036:	8b 45 08             	mov    0x8(%ebp),%eax
80101039:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 60 18 11 80       	push   $0x80111860
80101044:	e8 4c 45 00 00       	call   80105595 <release>
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
8010105a:	68 60 18 11 80       	push   $0x80111860
8010105f:	e8 ca 44 00 00       	call   8010552e <acquire>
80101064:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101067:	8b 45 08             	mov    0x8(%ebp),%eax
8010106a:	8b 40 04             	mov    0x4(%eax),%eax
8010106d:	85 c0                	test   %eax,%eax
8010106f:	7f 0d                	jg     8010107e <fileclose+0x2d>
    panic("fileclose");
80101071:	83 ec 0c             	sub    $0xc,%esp
80101074:	68 ed 8d 10 80       	push   $0x80108ded
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
8010109a:	68 60 18 11 80       	push   $0x80111860
8010109f:	e8 f1 44 00 00       	call   80105595 <release>
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
801010e8:	68 60 18 11 80       	push   $0x80111860
801010ed:	e8 a3 44 00 00       	call   80105595 <release>
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
8010110c:	e8 df 31 00 00       	call   801042f0 <pipeclose>
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	eb 21                	jmp    80101137 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101116:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101119:	83 f8 02             	cmp    $0x2,%eax
8010111c:	75 19                	jne    80101137 <fileclose+0xe6>
    begin_op();
8010111e:	e8 86 25 00 00       	call   801036a9 <begin_op>
    iput(ff.ip);
80101123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101126:	83 ec 0c             	sub    $0xc,%esp
80101129:	50                   	push   %eax
8010112a:	e8 3f 0b 00 00       	call   80101c6e <iput>
8010112f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101132:	e8 fe 25 00 00       	call   80103735 <end_op>
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
80101153:	e8 1e 09 00 00       	call   80101a76 <ilock>
80101158:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010115b:	8b 45 08             	mov    0x8(%ebp),%eax
8010115e:	8b 40 10             	mov    0x10(%eax),%eax
80101161:	83 ec 08             	sub    $0x8,%esp
80101164:	ff 75 0c             	pushl  0xc(%ebp)
80101167:	50                   	push   %eax
80101168:	e8 59 0e 00 00       	call   80101fc6 <stati>
8010116d:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 40 10             	mov    0x10(%eax),%eax
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	50                   	push   %eax
8010117a:	e8 7d 0a 00 00       	call   80101bfc <iunlock>
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
801011c5:	e8 ce 32 00 00       	call   80104498 <piperead>
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
801011e3:	e8 8e 08 00 00       	call   80101a76 <ilock>
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
80101200:	e8 2f 0e 00 00       	call   80102034 <readi>
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
8010122c:	e8 cb 09 00 00       	call   80101bfc <iunlock>
80101231:	83 c4 10             	add    $0x10,%esp
    return r;
80101234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101237:	eb 0d                	jmp    80101246 <fileread+0xb6>
  }
  panic("fileread");
80101239:	83 ec 0c             	sub    $0xc,%esp
8010123c:	68 f7 8d 10 80       	push   $0x80108df7
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
8010127e:	e8 17 31 00 00       	call   8010439a <pipewrite>
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
801012c3:	e8 e1 23 00 00       	call   801036a9 <begin_op>
      ilock(f->ip);
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 40 10             	mov    0x10(%eax),%eax
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	50                   	push   %eax
801012d2:	e8 9f 07 00 00       	call   80101a76 <ilock>
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
801012f5:	e8 91 0e 00 00       	call   8010218b <writei>
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
80101321:	e8 d6 08 00 00       	call   80101bfc <iunlock>
80101326:	83 c4 10             	add    $0x10,%esp
      end_op();
80101329:	e8 07 24 00 00       	call   80103735 <end_op>

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
8010133f:	68 00 8e 10 80       	push   $0x80108e00
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
80101375:	68 10 8e 10 80       	push   $0x80108e10
8010137a:	e8 e7 f1 ff ff       	call   80100566 <panic>
}
8010137f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101382:	c9                   	leave  
80101383:	c3                   	ret    

80101384 <changeowner>:

int
changeowner(struct inode* ip,  int nuid)
{
80101384:	55                   	push   %ebp
80101385:	89 e5                	mov    %esp,%ebp
80101387:	83 ec 08             	sub    $0x8,%esp

    begin_op();       // Lock up inode, check for validation, copy and update
8010138a:	e8 1a 23 00 00       	call   801036a9 <begin_op>
    ilock(ip);
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	ff 75 08             	pushl  0x8(%ebp)
80101395:	e8 dc 06 00 00       	call   80101a76 <ilock>
8010139a:	83 c4 10             	add    $0x10,%esp
    ip->uid = nuid;
8010139d:	8b 45 0c             	mov    0xc(%ebp),%eax
801013a0:	89 c2                	mov    %eax,%edx
801013a2:	8b 45 08             	mov    0x8(%ebp),%eax
801013a5:	66 89 50 48          	mov    %dx,0x48(%eax)
    iupdate(ip);
801013a9:	83 ec 0c             	sub    $0xc,%esp
801013ac:	ff 75 08             	pushl  0x8(%ebp)
801013af:	e8 c0 04 00 00       	call   80101874 <iupdate>
801013b4:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801013b7:	83 ec 0c             	sub    $0xc,%esp
801013ba:	ff 75 08             	pushl  0x8(%ebp)
801013bd:	e8 9c 09 00 00       	call   80101d5e <iunlockput>
801013c2:	83 c4 10             	add    $0x10,%esp
    end_op();
801013c5:	e8 6b 23 00 00       	call   80103735 <end_op>
    return 0;
801013ca:	b8 00 00 00 00       	mov    $0x0,%eax


}
801013cf:	c9                   	leave  
801013d0:	c3                   	ret    

801013d1 <changegroup>:

int
changegroup(struct inode* ip, int ngid)
{
801013d1:	55                   	push   %ebp
801013d2:	89 e5                	mov    %esp,%ebp
801013d4:	83 ec 08             	sub    $0x8,%esp
    begin_op();       // Lock up inode, check for validation, copy and update
801013d7:	e8 cd 22 00 00       	call   801036a9 <begin_op>
    ilock(ip);
801013dc:	83 ec 0c             	sub    $0xc,%esp
801013df:	ff 75 08             	pushl  0x8(%ebp)
801013e2:	e8 8f 06 00 00       	call   80101a76 <ilock>
801013e7:	83 c4 10             	add    $0x10,%esp
    ip->gid = ngid;
801013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801013ed:	89 c2                	mov    %eax,%edx
801013ef:	8b 45 08             	mov    0x8(%ebp),%eax
801013f2:	66 89 50 4a          	mov    %dx,0x4a(%eax)
    iupdate(ip);
801013f6:	83 ec 0c             	sub    $0xc,%esp
801013f9:	ff 75 08             	pushl  0x8(%ebp)
801013fc:	e8 73 04 00 00       	call   80101874 <iupdate>
80101401:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80101404:	83 ec 0c             	sub    $0xc,%esp
80101407:	ff 75 08             	pushl  0x8(%ebp)
8010140a:	e8 4f 09 00 00       	call   80101d5e <iunlockput>
8010140f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101412:	e8 1e 23 00 00       	call   80103735 <end_op>
    return 0;
80101417:	b8 00 00 00 00       	mov    $0x0,%eax

}
8010141c:	c9                   	leave  
8010141d:	c3                   	ret    

8010141e <changemode>:

int
changemode(struct inode* ip,  int mode)
{
8010141e:	55                   	push   %ebp
8010141f:	89 e5                	mov    %esp,%ebp
80101421:	83 ec 08             	sub    $0x8,%esp
    begin_op();       // Lock up inode, check for validation, copy and update
80101424:	e8 80 22 00 00       	call   801036a9 <begin_op>
    ilock(ip);
80101429:	83 ec 0c             	sub    $0xc,%esp
8010142c:	ff 75 08             	pushl  0x8(%ebp)
8010142f:	e8 42 06 00 00       	call   80101a76 <ilock>
80101434:	83 c4 10             	add    $0x10,%esp
    ip->mode.asInt = mode;
80101437:	8b 55 0c             	mov    0xc(%ebp),%edx
8010143a:	8b 45 08             	mov    0x8(%ebp),%eax
8010143d:	89 50 4c             	mov    %edx,0x4c(%eax)
    iupdate(ip);
80101440:	83 ec 0c             	sub    $0xc,%esp
80101443:	ff 75 08             	pushl  0x8(%ebp)
80101446:	e8 29 04 00 00       	call   80101874 <iupdate>
8010144b:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010144e:	83 ec 0c             	sub    $0xc,%esp
80101451:	ff 75 08             	pushl  0x8(%ebp)
80101454:	e8 05 09 00 00       	call   80101d5e <iunlockput>
80101459:	83 c4 10             	add    $0x10,%esp
    end_op();
8010145c:	e8 d4 22 00 00       	call   80103735 <end_op>
    return 0;
80101461:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101466:	c9                   	leave  
80101467:	c3                   	ret    

80101468 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101468:	55                   	push   %ebp
80101469:	89 e5                	mov    %esp,%ebp
8010146b:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010146e:	8b 45 08             	mov    0x8(%ebp),%eax
80101471:	83 ec 08             	sub    $0x8,%esp
80101474:	6a 01                	push   $0x1
80101476:	50                   	push   %eax
80101477:	e8 3a ed ff ff       	call   801001b6 <bread>
8010147c:	83 c4 10             	add    $0x10,%esp
8010147f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101485:	83 c0 18             	add    $0x18,%eax
80101488:	83 ec 04             	sub    $0x4,%esp
8010148b:	6a 1c                	push   $0x1c
8010148d:	50                   	push   %eax
8010148e:	ff 75 0c             	pushl  0xc(%ebp)
80101491:	e8 ba 43 00 00       	call   80105850 <memmove>
80101496:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101499:	83 ec 0c             	sub    $0xc,%esp
8010149c:	ff 75 f4             	pushl  -0xc(%ebp)
8010149f:	e8 8a ed ff ff       	call   8010022e <brelse>
801014a4:	83 c4 10             	add    $0x10,%esp
}
801014a7:	90                   	nop
801014a8:	c9                   	leave  
801014a9:	c3                   	ret    

801014aa <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801014aa:	55                   	push   %ebp
801014ab:	89 e5                	mov    %esp,%ebp
801014ad:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801014b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801014b3:	8b 45 08             	mov    0x8(%ebp),%eax
801014b6:	83 ec 08             	sub    $0x8,%esp
801014b9:	52                   	push   %edx
801014ba:	50                   	push   %eax
801014bb:	e8 f6 ec ff ff       	call   801001b6 <bread>
801014c0:	83 c4 10             	add    $0x10,%esp
801014c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801014c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014c9:	83 c0 18             	add    $0x18,%eax
801014cc:	83 ec 04             	sub    $0x4,%esp
801014cf:	68 00 02 00 00       	push   $0x200
801014d4:	6a 00                	push   $0x0
801014d6:	50                   	push   %eax
801014d7:	e8 b5 42 00 00       	call   80105791 <memset>
801014dc:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	ff 75 f4             	pushl  -0xc(%ebp)
801014e5:	e8 f7 23 00 00       	call   801038e1 <log_write>
801014ea:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014ed:	83 ec 0c             	sub    $0xc,%esp
801014f0:	ff 75 f4             	pushl  -0xc(%ebp)
801014f3:	e8 36 ed ff ff       	call   8010022e <brelse>
801014f8:	83 c4 10             	add    $0x10,%esp
}
801014fb:	90                   	nop
801014fc:	c9                   	leave  
801014fd:	c3                   	ret    

801014fe <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014fe:	55                   	push   %ebp
801014ff:	89 e5                	mov    %esp,%ebp
80101501:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101504:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010150b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101512:	e9 13 01 00 00       	jmp    8010162a <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010151a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101520:	85 c0                	test   %eax,%eax
80101522:	0f 48 c2             	cmovs  %edx,%eax
80101525:	c1 f8 0c             	sar    $0xc,%eax
80101528:	89 c2                	mov    %eax,%edx
8010152a:	a1 78 22 11 80       	mov    0x80112278,%eax
8010152f:	01 d0                	add    %edx,%eax
80101531:	83 ec 08             	sub    $0x8,%esp
80101534:	50                   	push   %eax
80101535:	ff 75 08             	pushl  0x8(%ebp)
80101538:	e8 79 ec ff ff       	call   801001b6 <bread>
8010153d:	83 c4 10             	add    $0x10,%esp
80101540:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010154a:	e9 a6 00 00 00       	jmp    801015f5 <balloc+0xf7>
      m = 1 << (bi % 8);
8010154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101552:	99                   	cltd   
80101553:	c1 ea 1d             	shr    $0x1d,%edx
80101556:	01 d0                	add    %edx,%eax
80101558:	83 e0 07             	and    $0x7,%eax
8010155b:	29 d0                	sub    %edx,%eax
8010155d:	ba 01 00 00 00       	mov    $0x1,%edx
80101562:	89 c1                	mov    %eax,%ecx
80101564:	d3 e2                	shl    %cl,%edx
80101566:	89 d0                	mov    %edx,%eax
80101568:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156e:	8d 50 07             	lea    0x7(%eax),%edx
80101571:	85 c0                	test   %eax,%eax
80101573:	0f 48 c2             	cmovs  %edx,%eax
80101576:	c1 f8 03             	sar    $0x3,%eax
80101579:	89 c2                	mov    %eax,%edx
8010157b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010157e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101583:	0f b6 c0             	movzbl %al,%eax
80101586:	23 45 e8             	and    -0x18(%ebp),%eax
80101589:	85 c0                	test   %eax,%eax
8010158b:	75 64                	jne    801015f1 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101590:	8d 50 07             	lea    0x7(%eax),%edx
80101593:	85 c0                	test   %eax,%eax
80101595:	0f 48 c2             	cmovs  %edx,%eax
80101598:	c1 f8 03             	sar    $0x3,%eax
8010159b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010159e:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015a3:	89 d1                	mov    %edx,%ecx
801015a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
801015a8:	09 ca                	or     %ecx,%edx
801015aa:	89 d1                	mov    %edx,%ecx
801015ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015af:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801015b3:	83 ec 0c             	sub    $0xc,%esp
801015b6:	ff 75 ec             	pushl  -0x14(%ebp)
801015b9:	e8 23 23 00 00       	call   801038e1 <log_write>
801015be:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	ff 75 ec             	pushl  -0x14(%ebp)
801015c7:	e8 62 ec ff ff       	call   8010022e <brelse>
801015cc:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801015cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d5:	01 c2                	add    %eax,%edx
801015d7:	8b 45 08             	mov    0x8(%ebp),%eax
801015da:	83 ec 08             	sub    $0x8,%esp
801015dd:	52                   	push   %edx
801015de:	50                   	push   %eax
801015df:	e8 c6 fe ff ff       	call   801014aa <bzero>
801015e4:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ed:	01 d0                	add    %edx,%eax
801015ef:	eb 57                	jmp    80101648 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015f1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015f5:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015fc:	7f 17                	jg     80101615 <balloc+0x117>
801015fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101601:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101604:	01 d0                	add    %edx,%eax
80101606:	89 c2                	mov    %eax,%edx
80101608:	a1 60 22 11 80       	mov    0x80112260,%eax
8010160d:	39 c2                	cmp    %eax,%edx
8010160f:	0f 82 3a ff ff ff    	jb     8010154f <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101615:	83 ec 0c             	sub    $0xc,%esp
80101618:	ff 75 ec             	pushl  -0x14(%ebp)
8010161b:	e8 0e ec ff ff       	call   8010022e <brelse>
80101620:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101623:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010162a:	8b 15 60 22 11 80    	mov    0x80112260,%edx
80101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101633:	39 c2                	cmp    %eax,%edx
80101635:	0f 87 dc fe ff ff    	ja     80101517 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010163b:	83 ec 0c             	sub    $0xc,%esp
8010163e:	68 1c 8e 10 80       	push   $0x80108e1c
80101643:	e8 1e ef ff ff       	call   80100566 <panic>
}
80101648:	c9                   	leave  
80101649:	c3                   	ret    

8010164a <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010164a:	55                   	push   %ebp
8010164b:	89 e5                	mov    %esp,%ebp
8010164d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	68 60 22 11 80       	push   $0x80112260
80101658:	ff 75 08             	pushl  0x8(%ebp)
8010165b:	e8 08 fe ff ff       	call   80101468 <readsb>
80101660:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101663:	8b 45 0c             	mov    0xc(%ebp),%eax
80101666:	c1 e8 0c             	shr    $0xc,%eax
80101669:	89 c2                	mov    %eax,%edx
8010166b:	a1 78 22 11 80       	mov    0x80112278,%eax
80101670:	01 c2                	add    %eax,%edx
80101672:	8b 45 08             	mov    0x8(%ebp),%eax
80101675:	83 ec 08             	sub    $0x8,%esp
80101678:	52                   	push   %edx
80101679:	50                   	push   %eax
8010167a:	e8 37 eb ff ff       	call   801001b6 <bread>
8010167f:	83 c4 10             	add    $0x10,%esp
80101682:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101685:	8b 45 0c             	mov    0xc(%ebp),%eax
80101688:	25 ff 0f 00 00       	and    $0xfff,%eax
8010168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101690:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101693:	99                   	cltd   
80101694:	c1 ea 1d             	shr    $0x1d,%edx
80101697:	01 d0                	add    %edx,%eax
80101699:	83 e0 07             	and    $0x7,%eax
8010169c:	29 d0                	sub    %edx,%eax
8010169e:	ba 01 00 00 00       	mov    $0x1,%edx
801016a3:	89 c1                	mov    %eax,%ecx
801016a5:	d3 e2                	shl    %cl,%edx
801016a7:	89 d0                	mov    %edx,%eax
801016a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801016ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016af:	8d 50 07             	lea    0x7(%eax),%edx
801016b2:	85 c0                	test   %eax,%eax
801016b4:	0f 48 c2             	cmovs  %edx,%eax
801016b7:	c1 f8 03             	sar    $0x3,%eax
801016ba:	89 c2                	mov    %eax,%edx
801016bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016bf:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801016c4:	0f b6 c0             	movzbl %al,%eax
801016c7:	23 45 ec             	and    -0x14(%ebp),%eax
801016ca:	85 c0                	test   %eax,%eax
801016cc:	75 0d                	jne    801016db <bfree+0x91>
    panic("freeing free block");
801016ce:	83 ec 0c             	sub    $0xc,%esp
801016d1:	68 32 8e 10 80       	push   $0x80108e32
801016d6:	e8 8b ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016de:	8d 50 07             	lea    0x7(%eax),%edx
801016e1:	85 c0                	test   %eax,%eax
801016e3:	0f 48 c2             	cmovs  %edx,%eax
801016e6:	c1 f8 03             	sar    $0x3,%eax
801016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ec:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016f1:	89 d1                	mov    %edx,%ecx
801016f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016f6:	f7 d2                	not    %edx
801016f8:	21 ca                	and    %ecx,%edx
801016fa:	89 d1                	mov    %edx,%ecx
801016fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ff:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101703:	83 ec 0c             	sub    $0xc,%esp
80101706:	ff 75 f4             	pushl  -0xc(%ebp)
80101709:	e8 d3 21 00 00       	call   801038e1 <log_write>
8010170e:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101711:	83 ec 0c             	sub    $0xc,%esp
80101714:	ff 75 f4             	pushl  -0xc(%ebp)
80101717:	e8 12 eb ff ff       	call   8010022e <brelse>
8010171c:	83 c4 10             	add    $0x10,%esp
}
8010171f:	90                   	nop
80101720:	c9                   	leave  
80101721:	c3                   	ret    

80101722 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101722:	55                   	push   %ebp
80101723:	89 e5                	mov    %esp,%ebp
80101725:	57                   	push   %edi
80101726:	56                   	push   %esi
80101727:	53                   	push   %ebx
80101728:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
8010172b:	83 ec 08             	sub    $0x8,%esp
8010172e:	68 45 8e 10 80       	push   $0x80108e45
80101733:	68 80 22 11 80       	push   $0x80112280
80101738:	e8 cf 3d 00 00       	call   8010550c <initlock>
8010173d:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101740:	83 ec 08             	sub    $0x8,%esp
80101743:	68 60 22 11 80       	push   $0x80112260
80101748:	ff 75 08             	pushl  0x8(%ebp)
8010174b:	e8 18 fd ff ff       	call   80101468 <readsb>
80101750:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101753:	a1 78 22 11 80       	mov    0x80112278,%eax
80101758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010175b:	8b 3d 74 22 11 80    	mov    0x80112274,%edi
80101761:	8b 35 70 22 11 80    	mov    0x80112270,%esi
80101767:	8b 1d 6c 22 11 80    	mov    0x8011226c,%ebx
8010176d:	8b 0d 68 22 11 80    	mov    0x80112268,%ecx
80101773:	8b 15 64 22 11 80    	mov    0x80112264,%edx
80101779:	a1 60 22 11 80       	mov    0x80112260,%eax
8010177e:	ff 75 e4             	pushl  -0x1c(%ebp)
80101781:	57                   	push   %edi
80101782:	56                   	push   %esi
80101783:	53                   	push   %ebx
80101784:	51                   	push   %ecx
80101785:	52                   	push   %edx
80101786:	50                   	push   %eax
80101787:	68 4c 8e 10 80       	push   $0x80108e4c
8010178c:	e8 35 ec ff ff       	call   801003c6 <cprintf>
80101791:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101794:	90                   	nop
80101795:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5f                   	pop    %edi
8010179b:	5d                   	pop    %ebp
8010179c:	c3                   	ret    

8010179d <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010179d:	55                   	push   %ebp
8010179e:	89 e5                	mov    %esp,%ebp
801017a0:	83 ec 28             	sub    $0x28,%esp
801017a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801017a6:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801017b1:	e9 9e 00 00 00       	jmp    80101854 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b9:	c1 e8 03             	shr    $0x3,%eax
801017bc:	89 c2                	mov    %eax,%edx
801017be:	a1 74 22 11 80       	mov    0x80112274,%eax
801017c3:	01 d0                	add    %edx,%eax
801017c5:	83 ec 08             	sub    $0x8,%esp
801017c8:	50                   	push   %eax
801017c9:	ff 75 08             	pushl  0x8(%ebp)
801017cc:	e8 e5 e9 ff ff       	call   801001b6 <bread>
801017d1:	83 c4 10             	add    $0x10,%esp
801017d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017da:	8d 50 18             	lea    0x18(%eax),%edx
801017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e0:	83 e0 07             	and    $0x7,%eax
801017e3:	c1 e0 06             	shl    $0x6,%eax
801017e6:	01 d0                	add    %edx,%eax
801017e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ee:	0f b7 00             	movzwl (%eax),%eax
801017f1:	66 85 c0             	test   %ax,%ax
801017f4:	75 4c                	jne    80101842 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017f6:	83 ec 04             	sub    $0x4,%esp
801017f9:	6a 40                	push   $0x40
801017fb:	6a 00                	push   $0x0
801017fd:	ff 75 ec             	pushl  -0x14(%ebp)
80101800:	e8 8c 3f 00 00       	call   80105791 <memset>
80101805:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101808:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010180b:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010180f:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101812:	83 ec 0c             	sub    $0xc,%esp
80101815:	ff 75 f0             	pushl  -0x10(%ebp)
80101818:	e8 c4 20 00 00       	call   801038e1 <log_write>
8010181d:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101820:	83 ec 0c             	sub    $0xc,%esp
80101823:	ff 75 f0             	pushl  -0x10(%ebp)
80101826:	e8 03 ea ff ff       	call   8010022e <brelse>
8010182b:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101831:	83 ec 08             	sub    $0x8,%esp
80101834:	50                   	push   %eax
80101835:	ff 75 08             	pushl  0x8(%ebp)
80101838:	e8 20 01 00 00       	call   8010195d <iget>
8010183d:	83 c4 10             	add    $0x10,%esp
80101840:	eb 30                	jmp    80101872 <ialloc+0xd5>
    }
    brelse(bp);
80101842:	83 ec 0c             	sub    $0xc,%esp
80101845:	ff 75 f0             	pushl  -0x10(%ebp)
80101848:	e8 e1 e9 ff ff       	call   8010022e <brelse>
8010184d:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101850:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101854:	8b 15 68 22 11 80    	mov    0x80112268,%edx
8010185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185d:	39 c2                	cmp    %eax,%edx
8010185f:	0f 87 51 ff ff ff    	ja     801017b6 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101865:	83 ec 0c             	sub    $0xc,%esp
80101868:	68 9f 8e 10 80       	push   $0x80108e9f
8010186d:	e8 f4 ec ff ff       	call   80100566 <panic>
}
80101872:	c9                   	leave  
80101873:	c3                   	ret    

80101874 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101874:	55                   	push   %ebp
80101875:	89 e5                	mov    %esp,%ebp
80101877:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010187a:	8b 45 08             	mov    0x8(%ebp),%eax
8010187d:	8b 40 04             	mov    0x4(%eax),%eax
80101880:	c1 e8 03             	shr    $0x3,%eax
80101883:	89 c2                	mov    %eax,%edx
80101885:	a1 74 22 11 80       	mov    0x80112274,%eax
8010188a:	01 c2                	add    %eax,%edx
8010188c:	8b 45 08             	mov    0x8(%ebp),%eax
8010188f:	8b 00                	mov    (%eax),%eax
80101891:	83 ec 08             	sub    $0x8,%esp
80101894:	52                   	push   %edx
80101895:	50                   	push   %eax
80101896:	e8 1b e9 ff ff       	call   801001b6 <bread>
8010189b:	83 c4 10             	add    $0x10,%esp
8010189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a4:	8d 50 18             	lea    0x18(%eax),%edx
801018a7:	8b 45 08             	mov    0x8(%ebp),%eax
801018aa:	8b 40 04             	mov    0x4(%eax),%eax
801018ad:	83 e0 07             	and    $0x7,%eax
801018b0:	c1 e0 06             	shl    $0x6,%eax
801018b3:	01 d0                	add    %edx,%eax
801018b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801018b8:	8b 45 08             	mov    0x8(%ebp),%eax
801018bb:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801018bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c2:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018c5:	8b 45 08             	mov    0x8(%ebp),%eax
801018c8:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018cf:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801018d3:	8b 45 08             	mov    0x8(%ebp),%eax
801018d6:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801018da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018dd:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018e1:	8b 45 08             	mov    0x8(%ebp),%eax
801018e4:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018eb:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018ef:	8b 45 08             	mov    0x8(%ebp),%eax
801018f2:	8b 50 18             	mov    0x18(%eax),%edx
801018f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f8:	89 50 08             	mov    %edx,0x8(%eax)
  #ifdef CS333_P4
  dip->uid = ip->uid;
801018fb:	8b 45 08             	mov    0x8(%ebp),%eax
801018fe:	0f b7 50 48          	movzwl 0x48(%eax),%edx
80101902:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101905:	66 89 50 38          	mov    %dx,0x38(%eax)
  dip->gid = ip->gid;
80101909:	8b 45 08             	mov    0x8(%ebp),%eax
8010190c:	0f b7 50 4a          	movzwl 0x4a(%eax),%edx
80101910:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101913:	66 89 50 3a          	mov    %dx,0x3a(%eax)
  dip->mode.asInt = ip->mode.asInt;
80101917:	8b 45 08             	mov    0x8(%ebp),%eax
8010191a:	8b 50 4c             	mov    0x4c(%eax),%edx
8010191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101920:	89 50 3c             	mov    %edx,0x3c(%eax)
  #endif 
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101923:	8b 45 08             	mov    0x8(%ebp),%eax
80101926:	8d 50 1c             	lea    0x1c(%eax),%edx
80101929:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192c:	83 c0 0c             	add    $0xc,%eax
8010192f:	83 ec 04             	sub    $0x4,%esp
80101932:	6a 2c                	push   $0x2c
80101934:	52                   	push   %edx
80101935:	50                   	push   %eax
80101936:	e8 15 3f 00 00       	call   80105850 <memmove>
8010193b:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010193e:	83 ec 0c             	sub    $0xc,%esp
80101941:	ff 75 f4             	pushl  -0xc(%ebp)
80101944:	e8 98 1f 00 00       	call   801038e1 <log_write>
80101949:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010194c:	83 ec 0c             	sub    $0xc,%esp
8010194f:	ff 75 f4             	pushl  -0xc(%ebp)
80101952:	e8 d7 e8 ff ff       	call   8010022e <brelse>
80101957:	83 c4 10             	add    $0x10,%esp
}
8010195a:	90                   	nop
8010195b:	c9                   	leave  
8010195c:	c3                   	ret    

8010195d <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010195d:	55                   	push   %ebp
8010195e:	89 e5                	mov    %esp,%ebp
80101960:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101963:	83 ec 0c             	sub    $0xc,%esp
80101966:	68 80 22 11 80       	push   $0x80112280
8010196b:	e8 be 3b 00 00       	call   8010552e <acquire>
80101970:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010197a:	c7 45 f4 b4 22 11 80 	movl   $0x801122b4,-0xc(%ebp)
80101981:	eb 5d                	jmp    801019e0 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101986:	8b 40 08             	mov    0x8(%eax),%eax
80101989:	85 c0                	test   %eax,%eax
8010198b:	7e 39                	jle    801019c6 <iget+0x69>
8010198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101990:	8b 00                	mov    (%eax),%eax
80101992:	3b 45 08             	cmp    0x8(%ebp),%eax
80101995:	75 2f                	jne    801019c6 <iget+0x69>
80101997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199a:	8b 40 04             	mov    0x4(%eax),%eax
8010199d:	3b 45 0c             	cmp    0xc(%ebp),%eax
801019a0:	75 24                	jne    801019c6 <iget+0x69>
      ip->ref++;
801019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a5:	8b 40 08             	mov    0x8(%eax),%eax
801019a8:	8d 50 01             	lea    0x1(%eax),%edx
801019ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ae:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801019b1:	83 ec 0c             	sub    $0xc,%esp
801019b4:	68 80 22 11 80       	push   $0x80112280
801019b9:	e8 d7 3b 00 00       	call   80105595 <release>
801019be:	83 c4 10             	add    $0x10,%esp
      return ip;
801019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c4:	eb 74                	jmp    80101a3a <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801019c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019ca:	75 10                	jne    801019dc <iget+0x7f>
801019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019cf:	8b 40 08             	mov    0x8(%eax),%eax
801019d2:	85 c0                	test   %eax,%eax
801019d4:	75 06                	jne    801019dc <iget+0x7f>
      empty = ip;
801019d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019dc:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801019e0:	81 7d f4 54 32 11 80 	cmpl   $0x80113254,-0xc(%ebp)
801019e7:	72 9a                	jb     80101983 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801019e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019ed:	75 0d                	jne    801019fc <iget+0x9f>
    panic("iget: no inodes");
801019ef:	83 ec 0c             	sub    $0xc,%esp
801019f2:	68 b1 8e 10 80       	push   $0x80108eb1
801019f7:	e8 6a eb ff ff       	call   80100566 <panic>

  ip = empty;
801019fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a05:	8b 55 08             	mov    0x8(%ebp),%edx
80101a08:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a10:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a16:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101a27:	83 ec 0c             	sub    $0xc,%esp
80101a2a:	68 80 22 11 80       	push   $0x80112280
80101a2f:	e8 61 3b 00 00       	call   80105595 <release>
80101a34:	83 c4 10             	add    $0x10,%esp

  return ip;
80101a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101a3a:	c9                   	leave  
80101a3b:	c3                   	ret    

80101a3c <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a3c:	55                   	push   %ebp
80101a3d:	89 e5                	mov    %esp,%ebp
80101a3f:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101a42:	83 ec 0c             	sub    $0xc,%esp
80101a45:	68 80 22 11 80       	push   $0x80112280
80101a4a:	e8 df 3a 00 00       	call   8010552e <acquire>
80101a4f:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101a52:	8b 45 08             	mov    0x8(%ebp),%eax
80101a55:	8b 40 08             	mov    0x8(%eax),%eax
80101a58:	8d 50 01             	lea    0x1(%eax),%edx
80101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a61:	83 ec 0c             	sub    $0xc,%esp
80101a64:	68 80 22 11 80       	push   $0x80112280
80101a69:	e8 27 3b 00 00       	call   80105595 <release>
80101a6e:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a74:	c9                   	leave  
80101a75:	c3                   	ret    

80101a76 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a76:	55                   	push   %ebp
80101a77:	89 e5                	mov    %esp,%ebp
80101a79:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a80:	74 0a                	je     80101a8c <ilock+0x16>
80101a82:	8b 45 08             	mov    0x8(%ebp),%eax
80101a85:	8b 40 08             	mov    0x8(%eax),%eax
80101a88:	85 c0                	test   %eax,%eax
80101a8a:	7f 0d                	jg     80101a99 <ilock+0x23>
    panic("ilock");
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	68 c1 8e 10 80       	push   $0x80108ec1
80101a94:	e8 cd ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a99:	83 ec 0c             	sub    $0xc,%esp
80101a9c:	68 80 22 11 80       	push   $0x80112280
80101aa1:	e8 88 3a 00 00       	call   8010552e <acquire>
80101aa6:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101aa9:	eb 13                	jmp    80101abe <ilock+0x48>
    sleep(ip, &icache.lock);
80101aab:	83 ec 08             	sub    $0x8,%esp
80101aae:	68 80 22 11 80       	push   $0x80112280
80101ab3:	ff 75 08             	pushl  0x8(%ebp)
80101ab6:	e8 dc 34 00 00       	call   80104f97 <sleep>
80101abb:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101abe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac1:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac4:	83 e0 01             	and    $0x1,%eax
80101ac7:	85 c0                	test   %eax,%eax
80101ac9:	75 e0                	jne    80101aab <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101acb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ace:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad1:	83 c8 01             	or     $0x1,%eax
80101ad4:	89 c2                	mov    %eax,%edx
80101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad9:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101adc:	83 ec 0c             	sub    $0xc,%esp
80101adf:	68 80 22 11 80       	push   $0x80112280
80101ae4:	e8 ac 3a 00 00       	call   80105595 <release>
80101ae9:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101aec:	8b 45 08             	mov    0x8(%ebp),%eax
80101aef:	8b 40 0c             	mov    0xc(%eax),%eax
80101af2:	83 e0 02             	and    $0x2,%eax
80101af5:	85 c0                	test   %eax,%eax
80101af7:	0f 85 fc 00 00 00    	jne    80101bf9 <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	8b 40 04             	mov    0x4(%eax),%eax
80101b03:	c1 e8 03             	shr    $0x3,%eax
80101b06:	89 c2                	mov    %eax,%edx
80101b08:	a1 74 22 11 80       	mov    0x80112274,%eax
80101b0d:	01 c2                	add    %eax,%edx
80101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b12:	8b 00                	mov    (%eax),%eax
80101b14:	83 ec 08             	sub    $0x8,%esp
80101b17:	52                   	push   %edx
80101b18:	50                   	push   %eax
80101b19:	e8 98 e6 ff ff       	call   801001b6 <bread>
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b27:	8d 50 18             	lea    0x18(%eax),%edx
80101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2d:	8b 40 04             	mov    0x4(%eax),%eax
80101b30:	83 e0 07             	and    $0x7,%eax
80101b33:	c1 e0 06             	shl    $0x6,%eax
80101b36:	01 d0                	add    %edx,%eax
80101b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b3e:	0f b7 10             	movzwl (%eax),%edx
80101b41:	8b 45 08             	mov    0x8(%ebp),%eax
80101b44:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b4b:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b52:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b59:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b60:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b67:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6e:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b75:	8b 50 08             	mov    0x8(%eax),%edx
80101b78:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7b:	89 50 18             	mov    %edx,0x18(%eax)
    #ifdef CS333_P4
    ip->uid = dip->uid;
80101b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b81:	0f b7 50 38          	movzwl 0x38(%eax),%edx
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	66 89 50 48          	mov    %dx,0x48(%eax)
    ip->gid = dip->gid;
80101b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b8f:	0f b7 50 3a          	movzwl 0x3a(%eax),%edx
80101b93:	8b 45 08             	mov    0x8(%ebp),%eax
80101b96:	66 89 50 4a          	mov    %dx,0x4a(%eax)
    ip->mode = dip->mode;
80101b9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101ba0:	8b 52 3c             	mov    0x3c(%edx),%edx
80101ba3:	89 50 4c             	mov    %edx,0x4c(%eax)
    #endif 
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba9:	8d 50 0c             	lea    0xc(%eax),%edx
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	83 c0 1c             	add    $0x1c,%eax
80101bb2:	83 ec 04             	sub    $0x4,%esp
80101bb5:	6a 2c                	push   $0x2c
80101bb7:	52                   	push   %edx
80101bb8:	50                   	push   %eax
80101bb9:	e8 92 3c 00 00       	call   80105850 <memmove>
80101bbe:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101bc1:	83 ec 0c             	sub    $0xc,%esp
80101bc4:	ff 75 f4             	pushl  -0xc(%ebp)
80101bc7:	e8 62 e6 ff ff       	call   8010022e <brelse>
80101bcc:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd2:	8b 40 0c             	mov    0xc(%eax),%eax
80101bd5:	83 c8 02             	or     $0x2,%eax
80101bd8:	89 c2                	mov    %eax,%edx
80101bda:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdd:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101be0:	8b 45 08             	mov    0x8(%ebp),%eax
80101be3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101be7:	66 85 c0             	test   %ax,%ax
80101bea:	75 0d                	jne    80101bf9 <ilock+0x183>
      panic("ilock: no type");
80101bec:	83 ec 0c             	sub    $0xc,%esp
80101bef:	68 c7 8e 10 80       	push   $0x80108ec7
80101bf4:	e8 6d e9 ff ff       	call   80100566 <panic>
  }
}
80101bf9:	90                   	nop
80101bfa:	c9                   	leave  
80101bfb:	c3                   	ret    

80101bfc <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101bfc:	55                   	push   %ebp
80101bfd:	89 e5                	mov    %esp,%ebp
80101bff:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101c02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c06:	74 17                	je     80101c1f <iunlock+0x23>
80101c08:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0b:	8b 40 0c             	mov    0xc(%eax),%eax
80101c0e:	83 e0 01             	and    $0x1,%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 0a                	je     80101c1f <iunlock+0x23>
80101c15:	8b 45 08             	mov    0x8(%ebp),%eax
80101c18:	8b 40 08             	mov    0x8(%eax),%eax
80101c1b:	85 c0                	test   %eax,%eax
80101c1d:	7f 0d                	jg     80101c2c <iunlock+0x30>
    panic("iunlock");
80101c1f:	83 ec 0c             	sub    $0xc,%esp
80101c22:	68 d6 8e 10 80       	push   $0x80108ed6
80101c27:	e8 3a e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101c2c:	83 ec 0c             	sub    $0xc,%esp
80101c2f:	68 80 22 11 80       	push   $0x80112280
80101c34:	e8 f5 38 00 00       	call   8010552e <acquire>
80101c39:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3f:	8b 40 0c             	mov    0xc(%eax),%eax
80101c42:	83 e0 fe             	and    $0xfffffffe,%eax
80101c45:	89 c2                	mov    %eax,%edx
80101c47:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4a:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101c4d:	83 ec 0c             	sub    $0xc,%esp
80101c50:	ff 75 08             	pushl  0x8(%ebp)
80101c53:	e8 2d 34 00 00       	call   80105085 <wakeup>
80101c58:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101c5b:	83 ec 0c             	sub    $0xc,%esp
80101c5e:	68 80 22 11 80       	push   $0x80112280
80101c63:	e8 2d 39 00 00       	call   80105595 <release>
80101c68:	83 c4 10             	add    $0x10,%esp
}
80101c6b:	90                   	nop
80101c6c:	c9                   	leave  
80101c6d:	c3                   	ret    

80101c6e <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c6e:	55                   	push   %ebp
80101c6f:	89 e5                	mov    %esp,%ebp
80101c71:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101c74:	83 ec 0c             	sub    $0xc,%esp
80101c77:	68 80 22 11 80       	push   $0x80112280
80101c7c:	e8 ad 38 00 00       	call   8010552e <acquire>
80101c81:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101c84:	8b 45 08             	mov    0x8(%ebp),%eax
80101c87:	8b 40 08             	mov    0x8(%eax),%eax
80101c8a:	83 f8 01             	cmp    $0x1,%eax
80101c8d:	0f 85 a9 00 00 00    	jne    80101d3c <iput+0xce>
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 40 0c             	mov    0xc(%eax),%eax
80101c99:	83 e0 02             	and    $0x2,%eax
80101c9c:	85 c0                	test   %eax,%eax
80101c9e:	0f 84 98 00 00 00    	je     80101d3c <iput+0xce>
80101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101cab:	66 85 c0             	test   %ax,%ax
80101cae:	0f 85 88 00 00 00    	jne    80101d3c <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb7:	8b 40 0c             	mov    0xc(%eax),%eax
80101cba:	83 e0 01             	and    $0x1,%eax
80101cbd:	85 c0                	test   %eax,%eax
80101cbf:	74 0d                	je     80101cce <iput+0x60>
      panic("iput busy");
80101cc1:	83 ec 0c             	sub    $0xc,%esp
80101cc4:	68 de 8e 10 80       	push   $0x80108ede
80101cc9:	e8 98 e8 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 40 0c             	mov    0xc(%eax),%eax
80101cd4:	83 c8 01             	or     $0x1,%eax
80101cd7:	89 c2                	mov    %eax,%edx
80101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdc:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 80 22 11 80       	push   $0x80112280
80101ce7:	e8 a9 38 00 00       	call   80105595 <release>
80101cec:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	ff 75 08             	pushl  0x8(%ebp)
80101cf5:	e8 a8 01 00 00       	call   80101ea2 <itrunc>
80101cfa:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101d06:	83 ec 0c             	sub    $0xc,%esp
80101d09:	ff 75 08             	pushl  0x8(%ebp)
80101d0c:	e8 63 fb ff ff       	call   80101874 <iupdate>
80101d11:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101d14:	83 ec 0c             	sub    $0xc,%esp
80101d17:	68 80 22 11 80       	push   $0x80112280
80101d1c:	e8 0d 38 00 00       	call   8010552e <acquire>
80101d21:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101d24:	8b 45 08             	mov    0x8(%ebp),%eax
80101d27:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101d2e:	83 ec 0c             	sub    $0xc,%esp
80101d31:	ff 75 08             	pushl  0x8(%ebp)
80101d34:	e8 4c 33 00 00       	call   80105085 <wakeup>
80101d39:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3f:	8b 40 08             	mov    0x8(%eax),%eax
80101d42:	8d 50 ff             	lea    -0x1(%eax),%edx
80101d45:	8b 45 08             	mov    0x8(%ebp),%eax
80101d48:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d4b:	83 ec 0c             	sub    $0xc,%esp
80101d4e:	68 80 22 11 80       	push   $0x80112280
80101d53:	e8 3d 38 00 00       	call   80105595 <release>
80101d58:	83 c4 10             	add    $0x10,%esp
}
80101d5b:	90                   	nop
80101d5c:	c9                   	leave  
80101d5d:	c3                   	ret    

80101d5e <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d5e:	55                   	push   %ebp
80101d5f:	89 e5                	mov    %esp,%ebp
80101d61:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	ff 75 08             	pushl  0x8(%ebp)
80101d6a:	e8 8d fe ff ff       	call   80101bfc <iunlock>
80101d6f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101d72:	83 ec 0c             	sub    $0xc,%esp
80101d75:	ff 75 08             	pushl  0x8(%ebp)
80101d78:	e8 f1 fe ff ff       	call   80101c6e <iput>
80101d7d:	83 c4 10             	add    $0x10,%esp
}
80101d80:	90                   	nop
80101d81:	c9                   	leave  
80101d82:	c3                   	ret    

80101d83 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d83:	55                   	push   %ebp
80101d84:	89 e5                	mov    %esp,%ebp
80101d86:	53                   	push   %ebx
80101d87:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d8a:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101d8e:	77 42                	ja     80101dd2 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101d90:	8b 45 08             	mov    0x8(%ebp),%eax
80101d93:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d96:	83 c2 04             	add    $0x4,%edx
80101d99:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101da0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101da4:	75 24                	jne    80101dca <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101da6:	8b 45 08             	mov    0x8(%ebp),%eax
80101da9:	8b 00                	mov    (%eax),%eax
80101dab:	83 ec 0c             	sub    $0xc,%esp
80101dae:	50                   	push   %eax
80101daf:	e8 4a f7 ff ff       	call   801014fe <balloc>
80101db4:	83 c4 10             	add    $0x10,%esp
80101db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dba:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dc0:	8d 4a 04             	lea    0x4(%edx),%ecx
80101dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dc6:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dcd:	e9 cb 00 00 00       	jmp    80101e9d <bmap+0x11a>
  }
  bn -= NDIRECT;
80101dd2:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101dd6:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101dda:	0f 87 b0 00 00 00    	ja     80101e90 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101de0:	8b 45 08             	mov    0x8(%ebp),%eax
80101de3:	8b 40 44             	mov    0x44(%eax),%eax
80101de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ded:	75 1d                	jne    80101e0c <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101def:	8b 45 08             	mov    0x8(%ebp),%eax
80101df2:	8b 00                	mov    (%eax),%eax
80101df4:	83 ec 0c             	sub    $0xc,%esp
80101df7:	50                   	push   %eax
80101df8:	e8 01 f7 ff ff       	call   801014fe <balloc>
80101dfd:	83 c4 10             	add    $0x10,%esp
80101e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e03:	8b 45 08             	mov    0x8(%ebp),%eax
80101e06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e09:	89 50 44             	mov    %edx,0x44(%eax)
    bp = bread(ip->dev, addr);
80101e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0f:	8b 00                	mov    (%eax),%eax
80101e11:	83 ec 08             	sub    $0x8,%esp
80101e14:	ff 75 f4             	pushl  -0xc(%ebp)
80101e17:	50                   	push   %eax
80101e18:	e8 99 e3 ff ff       	call   801001b6 <bread>
80101e1d:	83 c4 10             	add    $0x10,%esp
80101e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e26:	83 c0 18             	add    $0x18,%eax
80101e29:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e39:	01 d0                	add    %edx,%eax
80101e3b:	8b 00                	mov    (%eax),%eax
80101e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e44:	75 37                	jne    80101e7d <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e53:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101e56:	8b 45 08             	mov    0x8(%ebp),%eax
80101e59:	8b 00                	mov    (%eax),%eax
80101e5b:	83 ec 0c             	sub    $0xc,%esp
80101e5e:	50                   	push   %eax
80101e5f:	e8 9a f6 ff ff       	call   801014fe <balloc>
80101e64:	83 c4 10             	add    $0x10,%esp
80101e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e6d:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101e6f:	83 ec 0c             	sub    $0xc,%esp
80101e72:	ff 75 f0             	pushl  -0x10(%ebp)
80101e75:	e8 67 1a 00 00       	call   801038e1 <log_write>
80101e7a:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101e7d:	83 ec 0c             	sub    $0xc,%esp
80101e80:	ff 75 f0             	pushl  -0x10(%ebp)
80101e83:	e8 a6 e3 ff ff       	call   8010022e <brelse>
80101e88:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e8e:	eb 0d                	jmp    80101e9d <bmap+0x11a>
  }

  panic("bmap: out of range");
80101e90:	83 ec 0c             	sub    $0xc,%esp
80101e93:	68 e8 8e 10 80       	push   $0x80108ee8
80101e98:	e8 c9 e6 ff ff       	call   80100566 <panic>
}
80101e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ea0:	c9                   	leave  
80101ea1:	c3                   	ret    

80101ea2 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101ea2:	55                   	push   %ebp
80101ea3:	89 e5                	mov    %esp,%ebp
80101ea5:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ea8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101eaf:	eb 45                	jmp    80101ef6 <itrunc+0x54>
    if(ip->addrs[i]){
80101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eb7:	83 c2 04             	add    $0x4,%edx
80101eba:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ebe:	85 c0                	test   %eax,%eax
80101ec0:	74 30                	je     80101ef2 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101ec2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ec8:	83 c2 04             	add    $0x4,%edx
80101ecb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ecf:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed2:	8b 12                	mov    (%edx),%edx
80101ed4:	83 ec 08             	sub    $0x8,%esp
80101ed7:	50                   	push   %eax
80101ed8:	52                   	push   %edx
80101ed9:	e8 6c f7 ff ff       	call   8010164a <bfree>
80101ede:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ee7:	83 c2 04             	add    $0x4,%edx
80101eea:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101ef1:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ef2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ef6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101efa:	7e b5                	jle    80101eb1 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101efc:	8b 45 08             	mov    0x8(%ebp),%eax
80101eff:	8b 40 44             	mov    0x44(%eax),%eax
80101f02:	85 c0                	test   %eax,%eax
80101f04:	0f 84 a1 00 00 00    	je     80101fab <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0d:	8b 50 44             	mov    0x44(%eax),%edx
80101f10:	8b 45 08             	mov    0x8(%ebp),%eax
80101f13:	8b 00                	mov    (%eax),%eax
80101f15:	83 ec 08             	sub    $0x8,%esp
80101f18:	52                   	push   %edx
80101f19:	50                   	push   %eax
80101f1a:	e8 97 e2 ff ff       	call   801001b6 <bread>
80101f1f:	83 c4 10             	add    $0x10,%esp
80101f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f28:	83 c0 18             	add    $0x18,%eax
80101f2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f35:	eb 3c                	jmp    80101f73 <itrunc+0xd1>
      if(a[j])
80101f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f44:	01 d0                	add    %edx,%eax
80101f46:	8b 00                	mov    (%eax),%eax
80101f48:	85 c0                	test   %eax,%eax
80101f4a:	74 23                	je     80101f6f <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f59:	01 d0                	add    %edx,%eax
80101f5b:	8b 00                	mov    (%eax),%eax
80101f5d:	8b 55 08             	mov    0x8(%ebp),%edx
80101f60:	8b 12                	mov    (%edx),%edx
80101f62:	83 ec 08             	sub    $0x8,%esp
80101f65:	50                   	push   %eax
80101f66:	52                   	push   %edx
80101f67:	e8 de f6 ff ff       	call   8010164a <bfree>
80101f6c:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101f6f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f76:	83 f8 7f             	cmp    $0x7f,%eax
80101f79:	76 bc                	jbe    80101f37 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101f7b:	83 ec 0c             	sub    $0xc,%esp
80101f7e:	ff 75 ec             	pushl  -0x14(%ebp)
80101f81:	e8 a8 e2 ff ff       	call   8010022e <brelse>
80101f86:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f89:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8c:	8b 40 44             	mov    0x44(%eax),%eax
80101f8f:	8b 55 08             	mov    0x8(%ebp),%edx
80101f92:	8b 12                	mov    (%edx),%edx
80101f94:	83 ec 08             	sub    $0x8,%esp
80101f97:	50                   	push   %eax
80101f98:	52                   	push   %edx
80101f99:	e8 ac f6 ff ff       	call   8010164a <bfree>
80101f9e:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
  }

  ip->size = 0;
80101fab:	8b 45 08             	mov    0x8(%ebp),%eax
80101fae:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	ff 75 08             	pushl  0x8(%ebp)
80101fbb:	e8 b4 f8 ff ff       	call   80101874 <iupdate>
80101fc0:	83 c4 10             	add    $0x10,%esp
}
80101fc3:	90                   	nop
80101fc4:	c9                   	leave  
80101fc5:	c3                   	ret    

80101fc6 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101fc6:	55                   	push   %ebp
80101fc7:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	8b 00                	mov    (%eax),%eax
80101fce:	89 c2                	mov    %eax,%edx
80101fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd3:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd9:	8b 50 04             	mov    0x4(%eax),%edx
80101fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdf:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe5:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fec:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101fef:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff2:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff9:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80102000:	8b 50 18             	mov    0x18(%eax),%edx
80102003:	8b 45 0c             	mov    0xc(%ebp),%eax
80102006:	89 50 10             	mov    %edx,0x10(%eax)
  #ifdef CS333_P4
  st->uid = ip->uid;
80102009:	8b 45 08             	mov    0x8(%ebp),%eax
8010200c:	0f b7 50 48          	movzwl 0x48(%eax),%edx
80102010:	8b 45 0c             	mov    0xc(%ebp),%eax
80102013:	66 89 50 14          	mov    %dx,0x14(%eax)
  st->gid = ip->gid;
80102017:	8b 45 08             	mov    0x8(%ebp),%eax
8010201a:	0f b7 50 4a          	movzwl 0x4a(%eax),%edx
8010201e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102021:	66 89 50 16          	mov    %dx,0x16(%eax)
  st->mode.asInt = ip->mode.asInt;
80102025:	8b 45 08             	mov    0x8(%ebp),%eax
80102028:	8b 50 4c             	mov    0x4c(%eax),%edx
8010202b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010202e:	89 50 18             	mov    %edx,0x18(%eax)
  #endif
}
80102031:	90                   	nop
80102032:	5d                   	pop    %ebp
80102033:	c3                   	ret    

80102034 <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102034:	55                   	push   %ebp
80102035:	89 e5                	mov    %esp,%ebp
80102037:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010203a:	8b 45 08             	mov    0x8(%ebp),%eax
8010203d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102041:	66 83 f8 03          	cmp    $0x3,%ax
80102045:	75 5c                	jne    801020a3 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102047:	8b 45 08             	mov    0x8(%ebp),%eax
8010204a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010204e:	66 85 c0             	test   %ax,%ax
80102051:	78 20                	js     80102073 <readi+0x3f>
80102053:	8b 45 08             	mov    0x8(%ebp),%eax
80102056:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010205a:	66 83 f8 09          	cmp    $0x9,%ax
8010205e:	7f 13                	jg     80102073 <readi+0x3f>
80102060:	8b 45 08             	mov    0x8(%ebp),%eax
80102063:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102067:	98                   	cwtl   
80102068:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
8010206f:	85 c0                	test   %eax,%eax
80102071:	75 0a                	jne    8010207d <readi+0x49>
      return -1;
80102073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102078:	e9 0c 01 00 00       	jmp    80102189 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
8010207d:	8b 45 08             	mov    0x8(%ebp),%eax
80102080:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102084:	98                   	cwtl   
80102085:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
8010208c:	8b 55 14             	mov    0x14(%ebp),%edx
8010208f:	83 ec 04             	sub    $0x4,%esp
80102092:	52                   	push   %edx
80102093:	ff 75 0c             	pushl  0xc(%ebp)
80102096:	ff 75 08             	pushl  0x8(%ebp)
80102099:	ff d0                	call   *%eax
8010209b:	83 c4 10             	add    $0x10,%esp
8010209e:	e9 e6 00 00 00       	jmp    80102189 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
801020a3:	8b 45 08             	mov    0x8(%ebp),%eax
801020a6:	8b 40 18             	mov    0x18(%eax),%eax
801020a9:	3b 45 10             	cmp    0x10(%ebp),%eax
801020ac:	72 0d                	jb     801020bb <readi+0x87>
801020ae:	8b 55 10             	mov    0x10(%ebp),%edx
801020b1:	8b 45 14             	mov    0x14(%ebp),%eax
801020b4:	01 d0                	add    %edx,%eax
801020b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801020b9:	73 0a                	jae    801020c5 <readi+0x91>
    return -1;
801020bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c0:	e9 c4 00 00 00       	jmp    80102189 <readi+0x155>
  if(off + n > ip->size)
801020c5:	8b 55 10             	mov    0x10(%ebp),%edx
801020c8:	8b 45 14             	mov    0x14(%ebp),%eax
801020cb:	01 c2                	add    %eax,%edx
801020cd:	8b 45 08             	mov    0x8(%ebp),%eax
801020d0:	8b 40 18             	mov    0x18(%eax),%eax
801020d3:	39 c2                	cmp    %eax,%edx
801020d5:	76 0c                	jbe    801020e3 <readi+0xaf>
    n = ip->size - off;
801020d7:	8b 45 08             	mov    0x8(%ebp),%eax
801020da:	8b 40 18             	mov    0x18(%eax),%eax
801020dd:	2b 45 10             	sub    0x10(%ebp),%eax
801020e0:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020ea:	e9 8b 00 00 00       	jmp    8010217a <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020ef:	8b 45 10             	mov    0x10(%ebp),%eax
801020f2:	c1 e8 09             	shr    $0x9,%eax
801020f5:	83 ec 08             	sub    $0x8,%esp
801020f8:	50                   	push   %eax
801020f9:	ff 75 08             	pushl  0x8(%ebp)
801020fc:	e8 82 fc ff ff       	call   80101d83 <bmap>
80102101:	83 c4 10             	add    $0x10,%esp
80102104:	89 c2                	mov    %eax,%edx
80102106:	8b 45 08             	mov    0x8(%ebp),%eax
80102109:	8b 00                	mov    (%eax),%eax
8010210b:	83 ec 08             	sub    $0x8,%esp
8010210e:	52                   	push   %edx
8010210f:	50                   	push   %eax
80102110:	e8 a1 e0 ff ff       	call   801001b6 <bread>
80102115:	83 c4 10             	add    $0x10,%esp
80102118:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010211b:	8b 45 10             	mov    0x10(%ebp),%eax
8010211e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102123:	ba 00 02 00 00       	mov    $0x200,%edx
80102128:	29 c2                	sub    %eax,%edx
8010212a:	8b 45 14             	mov    0x14(%ebp),%eax
8010212d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102130:	39 c2                	cmp    %eax,%edx
80102132:	0f 46 c2             	cmovbe %edx,%eax
80102135:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102138:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010213b:	8d 50 18             	lea    0x18(%eax),%edx
8010213e:	8b 45 10             	mov    0x10(%ebp),%eax
80102141:	25 ff 01 00 00       	and    $0x1ff,%eax
80102146:	01 d0                	add    %edx,%eax
80102148:	83 ec 04             	sub    $0x4,%esp
8010214b:	ff 75 ec             	pushl  -0x14(%ebp)
8010214e:	50                   	push   %eax
8010214f:	ff 75 0c             	pushl  0xc(%ebp)
80102152:	e8 f9 36 00 00       	call   80105850 <memmove>
80102157:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010215a:	83 ec 0c             	sub    $0xc,%esp
8010215d:	ff 75 f0             	pushl  -0x10(%ebp)
80102160:	e8 c9 e0 ff ff       	call   8010022e <brelse>
80102165:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102168:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010216e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102171:	01 45 10             	add    %eax,0x10(%ebp)
80102174:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102177:	01 45 0c             	add    %eax,0xc(%ebp)
8010217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010217d:	3b 45 14             	cmp    0x14(%ebp),%eax
80102180:	0f 82 69 ff ff ff    	jb     801020ef <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102186:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102189:	c9                   	leave  
8010218a:	c3                   	ret    

8010218b <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010218b:	55                   	push   %ebp
8010218c:	89 e5                	mov    %esp,%ebp
8010218e:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102191:	8b 45 08             	mov    0x8(%ebp),%eax
80102194:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102198:	66 83 f8 03          	cmp    $0x3,%ax
8010219c:	75 5c                	jne    801021fa <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010219e:	8b 45 08             	mov    0x8(%ebp),%eax
801021a1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801021a5:	66 85 c0             	test   %ax,%ax
801021a8:	78 20                	js     801021ca <writei+0x3f>
801021aa:	8b 45 08             	mov    0x8(%ebp),%eax
801021ad:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801021b1:	66 83 f8 09          	cmp    $0x9,%ax
801021b5:	7f 13                	jg     801021ca <writei+0x3f>
801021b7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ba:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801021be:	98                   	cwtl   
801021bf:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
801021c6:	85 c0                	test   %eax,%eax
801021c8:	75 0a                	jne    801021d4 <writei+0x49>
      return -1;
801021ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021cf:	e9 3d 01 00 00       	jmp    80102311 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801021d4:	8b 45 08             	mov    0x8(%ebp),%eax
801021d7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801021db:	98                   	cwtl   
801021dc:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
801021e3:	8b 55 14             	mov    0x14(%ebp),%edx
801021e6:	83 ec 04             	sub    $0x4,%esp
801021e9:	52                   	push   %edx
801021ea:	ff 75 0c             	pushl  0xc(%ebp)
801021ed:	ff 75 08             	pushl  0x8(%ebp)
801021f0:	ff d0                	call   *%eax
801021f2:	83 c4 10             	add    $0x10,%esp
801021f5:	e9 17 01 00 00       	jmp    80102311 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801021fa:	8b 45 08             	mov    0x8(%ebp),%eax
801021fd:	8b 40 18             	mov    0x18(%eax),%eax
80102200:	3b 45 10             	cmp    0x10(%ebp),%eax
80102203:	72 0d                	jb     80102212 <writei+0x87>
80102205:	8b 55 10             	mov    0x10(%ebp),%edx
80102208:	8b 45 14             	mov    0x14(%ebp),%eax
8010220b:	01 d0                	add    %edx,%eax
8010220d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102210:	73 0a                	jae    8010221c <writei+0x91>
    return -1;
80102212:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102217:	e9 f5 00 00 00       	jmp    80102311 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010221c:	8b 55 10             	mov    0x10(%ebp),%edx
8010221f:	8b 45 14             	mov    0x14(%ebp),%eax
80102222:	01 d0                	add    %edx,%eax
80102224:	3d 00 14 01 00       	cmp    $0x11400,%eax
80102229:	76 0a                	jbe    80102235 <writei+0xaa>
    return -1;
8010222b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102230:	e9 dc 00 00 00       	jmp    80102311 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010223c:	e9 99 00 00 00       	jmp    801022da <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102241:	8b 45 10             	mov    0x10(%ebp),%eax
80102244:	c1 e8 09             	shr    $0x9,%eax
80102247:	83 ec 08             	sub    $0x8,%esp
8010224a:	50                   	push   %eax
8010224b:	ff 75 08             	pushl  0x8(%ebp)
8010224e:	e8 30 fb ff ff       	call   80101d83 <bmap>
80102253:	83 c4 10             	add    $0x10,%esp
80102256:	89 c2                	mov    %eax,%edx
80102258:	8b 45 08             	mov    0x8(%ebp),%eax
8010225b:	8b 00                	mov    (%eax),%eax
8010225d:	83 ec 08             	sub    $0x8,%esp
80102260:	52                   	push   %edx
80102261:	50                   	push   %eax
80102262:	e8 4f df ff ff       	call   801001b6 <bread>
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010226d:	8b 45 10             	mov    0x10(%ebp),%eax
80102270:	25 ff 01 00 00       	and    $0x1ff,%eax
80102275:	ba 00 02 00 00       	mov    $0x200,%edx
8010227a:	29 c2                	sub    %eax,%edx
8010227c:	8b 45 14             	mov    0x14(%ebp),%eax
8010227f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102282:	39 c2                	cmp    %eax,%edx
80102284:	0f 46 c2             	cmovbe %edx,%eax
80102287:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010228a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010228d:	8d 50 18             	lea    0x18(%eax),%edx
80102290:	8b 45 10             	mov    0x10(%ebp),%eax
80102293:	25 ff 01 00 00       	and    $0x1ff,%eax
80102298:	01 d0                	add    %edx,%eax
8010229a:	83 ec 04             	sub    $0x4,%esp
8010229d:	ff 75 ec             	pushl  -0x14(%ebp)
801022a0:	ff 75 0c             	pushl  0xc(%ebp)
801022a3:	50                   	push   %eax
801022a4:	e8 a7 35 00 00       	call   80105850 <memmove>
801022a9:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801022ac:	83 ec 0c             	sub    $0xc,%esp
801022af:	ff 75 f0             	pushl  -0x10(%ebp)
801022b2:	e8 2a 16 00 00       	call   801038e1 <log_write>
801022b7:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801022ba:	83 ec 0c             	sub    $0xc,%esp
801022bd:	ff 75 f0             	pushl  -0x10(%ebp)
801022c0:	e8 69 df ff ff       	call   8010022e <brelse>
801022c5:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022cb:	01 45 f4             	add    %eax,-0xc(%ebp)
801022ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022d1:	01 45 10             	add    %eax,0x10(%ebp)
801022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022d7:	01 45 0c             	add    %eax,0xc(%ebp)
801022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022dd:	3b 45 14             	cmp    0x14(%ebp),%eax
801022e0:	0f 82 5b ff ff ff    	jb     80102241 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801022e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801022ea:	74 22                	je     8010230e <writei+0x183>
801022ec:	8b 45 08             	mov    0x8(%ebp),%eax
801022ef:	8b 40 18             	mov    0x18(%eax),%eax
801022f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801022f5:	73 17                	jae    8010230e <writei+0x183>
    ip->size = off;
801022f7:	8b 45 08             	mov    0x8(%ebp),%eax
801022fa:	8b 55 10             	mov    0x10(%ebp),%edx
801022fd:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	ff 75 08             	pushl  0x8(%ebp)
80102306:	e8 69 f5 ff ff       	call   80101874 <iupdate>
8010230b:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010230e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102311:	c9                   	leave  
80102312:	c3                   	ret    

80102313 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80102313:	55                   	push   %ebp
80102314:	89 e5                	mov    %esp,%ebp
80102316:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102319:	83 ec 04             	sub    $0x4,%esp
8010231c:	6a 0e                	push   $0xe
8010231e:	ff 75 0c             	pushl  0xc(%ebp)
80102321:	ff 75 08             	pushl  0x8(%ebp)
80102324:	e8 bd 35 00 00       	call   801058e6 <strncmp>
80102329:	83 c4 10             	add    $0x10,%esp
}
8010232c:	c9                   	leave  
8010232d:	c3                   	ret    

8010232e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010232e:	55                   	push   %ebp
8010232f:	89 e5                	mov    %esp,%ebp
80102331:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102334:	8b 45 08             	mov    0x8(%ebp),%eax
80102337:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010233b:	66 83 f8 01          	cmp    $0x1,%ax
8010233f:	74 0d                	je     8010234e <dirlookup+0x20>
    panic("dirlookup not DIR");
80102341:	83 ec 0c             	sub    $0xc,%esp
80102344:	68 fb 8e 10 80       	push   $0x80108efb
80102349:	e8 18 e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010234e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102355:	eb 7b                	jmp    801023d2 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102357:	6a 10                	push   $0x10
80102359:	ff 75 f4             	pushl  -0xc(%ebp)
8010235c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010235f:	50                   	push   %eax
80102360:	ff 75 08             	pushl  0x8(%ebp)
80102363:	e8 cc fc ff ff       	call   80102034 <readi>
80102368:	83 c4 10             	add    $0x10,%esp
8010236b:	83 f8 10             	cmp    $0x10,%eax
8010236e:	74 0d                	je     8010237d <dirlookup+0x4f>
      panic("dirlink read");
80102370:	83 ec 0c             	sub    $0xc,%esp
80102373:	68 0d 8f 10 80       	push   $0x80108f0d
80102378:	e8 e9 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010237d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102381:	66 85 c0             	test   %ax,%ax
80102384:	74 47                	je     801023cd <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102386:	83 ec 08             	sub    $0x8,%esp
80102389:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010238c:	83 c0 02             	add    $0x2,%eax
8010238f:	50                   	push   %eax
80102390:	ff 75 0c             	pushl  0xc(%ebp)
80102393:	e8 7b ff ff ff       	call   80102313 <namecmp>
80102398:	83 c4 10             	add    $0x10,%esp
8010239b:	85 c0                	test   %eax,%eax
8010239d:	75 2f                	jne    801023ce <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010239f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801023a3:	74 08                	je     801023ad <dirlookup+0x7f>
        *poff = off;
801023a5:	8b 45 10             	mov    0x10(%ebp),%eax
801023a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801023ab:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801023ad:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023b1:	0f b7 c0             	movzwl %ax,%eax
801023b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801023b7:	8b 45 08             	mov    0x8(%ebp),%eax
801023ba:	8b 00                	mov    (%eax),%eax
801023bc:	83 ec 08             	sub    $0x8,%esp
801023bf:	ff 75 f0             	pushl  -0x10(%ebp)
801023c2:	50                   	push   %eax
801023c3:	e8 95 f5 ff ff       	call   8010195d <iget>
801023c8:	83 c4 10             	add    $0x10,%esp
801023cb:	eb 19                	jmp    801023e6 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801023cd:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801023ce:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801023d2:	8b 45 08             	mov    0x8(%ebp),%eax
801023d5:	8b 40 18             	mov    0x18(%eax),%eax
801023d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801023db:	0f 87 76 ff ff ff    	ja     80102357 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801023e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023e6:	c9                   	leave  
801023e7:	c3                   	ret    

801023e8 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023e8:	55                   	push   %ebp
801023e9:	89 e5                	mov    %esp,%ebp
801023eb:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023ee:	83 ec 04             	sub    $0x4,%esp
801023f1:	6a 00                	push   $0x0
801023f3:	ff 75 0c             	pushl  0xc(%ebp)
801023f6:	ff 75 08             	pushl  0x8(%ebp)
801023f9:	e8 30 ff ff ff       	call   8010232e <dirlookup>
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102404:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102408:	74 18                	je     80102422 <dirlink+0x3a>
    iput(ip);
8010240a:	83 ec 0c             	sub    $0xc,%esp
8010240d:	ff 75 f0             	pushl  -0x10(%ebp)
80102410:	e8 59 f8 ff ff       	call   80101c6e <iput>
80102415:	83 c4 10             	add    $0x10,%esp
    return -1;
80102418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010241d:	e9 9c 00 00 00       	jmp    801024be <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102429:	eb 39                	jmp    80102464 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010242e:	6a 10                	push   $0x10
80102430:	50                   	push   %eax
80102431:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102434:	50                   	push   %eax
80102435:	ff 75 08             	pushl  0x8(%ebp)
80102438:	e8 f7 fb ff ff       	call   80102034 <readi>
8010243d:	83 c4 10             	add    $0x10,%esp
80102440:	83 f8 10             	cmp    $0x10,%eax
80102443:	74 0d                	je     80102452 <dirlink+0x6a>
      panic("dirlink read");
80102445:	83 ec 0c             	sub    $0xc,%esp
80102448:	68 0d 8f 10 80       	push   $0x80108f0d
8010244d:	e8 14 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102452:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102456:	66 85 c0             	test   %ax,%ax
80102459:	74 18                	je     80102473 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245e:	83 c0 10             	add    $0x10,%eax
80102461:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102464:	8b 45 08             	mov    0x8(%ebp),%eax
80102467:	8b 50 18             	mov    0x18(%eax),%edx
8010246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010246d:	39 c2                	cmp    %eax,%edx
8010246f:	77 ba                	ja     8010242b <dirlink+0x43>
80102471:	eb 01                	jmp    80102474 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102473:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102474:	83 ec 04             	sub    $0x4,%esp
80102477:	6a 0e                	push   $0xe
80102479:	ff 75 0c             	pushl  0xc(%ebp)
8010247c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010247f:	83 c0 02             	add    $0x2,%eax
80102482:	50                   	push   %eax
80102483:	e8 b4 34 00 00       	call   8010593c <strncpy>
80102488:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010248b:	8b 45 10             	mov    0x10(%ebp),%eax
8010248e:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102495:	6a 10                	push   $0x10
80102497:	50                   	push   %eax
80102498:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010249b:	50                   	push   %eax
8010249c:	ff 75 08             	pushl  0x8(%ebp)
8010249f:	e8 e7 fc ff ff       	call   8010218b <writei>
801024a4:	83 c4 10             	add    $0x10,%esp
801024a7:	83 f8 10             	cmp    $0x10,%eax
801024aa:	74 0d                	je     801024b9 <dirlink+0xd1>
    panic("dirlink");
801024ac:	83 ec 0c             	sub    $0xc,%esp
801024af:	68 1a 8f 10 80       	push   $0x80108f1a
801024b4:	e8 ad e0 ff ff       	call   80100566 <panic>
  
  return 0;
801024b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024be:	c9                   	leave  
801024bf:	c3                   	ret    

801024c0 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801024c6:	eb 04                	jmp    801024cc <skipelem+0xc>
    path++;
801024c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801024cc:	8b 45 08             	mov    0x8(%ebp),%eax
801024cf:	0f b6 00             	movzbl (%eax),%eax
801024d2:	3c 2f                	cmp    $0x2f,%al
801024d4:	74 f2                	je     801024c8 <skipelem+0x8>
    path++;
  if(*path == 0)
801024d6:	8b 45 08             	mov    0x8(%ebp),%eax
801024d9:	0f b6 00             	movzbl (%eax),%eax
801024dc:	84 c0                	test   %al,%al
801024de:	75 07                	jne    801024e7 <skipelem+0x27>
    return 0;
801024e0:	b8 00 00 00 00       	mov    $0x0,%eax
801024e5:	eb 7b                	jmp    80102562 <skipelem+0xa2>
  s = path;
801024e7:	8b 45 08             	mov    0x8(%ebp),%eax
801024ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024ed:	eb 04                	jmp    801024f3 <skipelem+0x33>
    path++;
801024ef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801024f3:	8b 45 08             	mov    0x8(%ebp),%eax
801024f6:	0f b6 00             	movzbl (%eax),%eax
801024f9:	3c 2f                	cmp    $0x2f,%al
801024fb:	74 0a                	je     80102507 <skipelem+0x47>
801024fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102500:	0f b6 00             	movzbl (%eax),%eax
80102503:	84 c0                	test   %al,%al
80102505:	75 e8                	jne    801024ef <skipelem+0x2f>
    path++;
  len = path - s;
80102507:	8b 55 08             	mov    0x8(%ebp),%edx
8010250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010250d:	29 c2                	sub    %eax,%edx
8010250f:	89 d0                	mov    %edx,%eax
80102511:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102514:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102518:	7e 15                	jle    8010252f <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010251a:	83 ec 04             	sub    $0x4,%esp
8010251d:	6a 0e                	push   $0xe
8010251f:	ff 75 f4             	pushl  -0xc(%ebp)
80102522:	ff 75 0c             	pushl  0xc(%ebp)
80102525:	e8 26 33 00 00       	call   80105850 <memmove>
8010252a:	83 c4 10             	add    $0x10,%esp
8010252d:	eb 26                	jmp    80102555 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102532:	83 ec 04             	sub    $0x4,%esp
80102535:	50                   	push   %eax
80102536:	ff 75 f4             	pushl  -0xc(%ebp)
80102539:	ff 75 0c             	pushl  0xc(%ebp)
8010253c:	e8 0f 33 00 00       	call   80105850 <memmove>
80102541:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102544:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102547:	8b 45 0c             	mov    0xc(%ebp),%eax
8010254a:	01 d0                	add    %edx,%eax
8010254c:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010254f:	eb 04                	jmp    80102555 <skipelem+0x95>
    path++;
80102551:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102555:	8b 45 08             	mov    0x8(%ebp),%eax
80102558:	0f b6 00             	movzbl (%eax),%eax
8010255b:	3c 2f                	cmp    $0x2f,%al
8010255d:	74 f2                	je     80102551 <skipelem+0x91>
    path++;
  return path;
8010255f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102562:	c9                   	leave  
80102563:	c3                   	ret    

80102564 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010256a:	8b 45 08             	mov    0x8(%ebp),%eax
8010256d:	0f b6 00             	movzbl (%eax),%eax
80102570:	3c 2f                	cmp    $0x2f,%al
80102572:	75 17                	jne    8010258b <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102574:	83 ec 08             	sub    $0x8,%esp
80102577:	6a 01                	push   $0x1
80102579:	6a 01                	push   $0x1
8010257b:	e8 dd f3 ff ff       	call   8010195d <iget>
80102580:	83 c4 10             	add    $0x10,%esp
80102583:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102586:	e9 bb 00 00 00       	jmp    80102646 <namex+0xe2>
  else
    ip = idup(proc->cwd);
8010258b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102591:	8b 40 68             	mov    0x68(%eax),%eax
80102594:	83 ec 0c             	sub    $0xc,%esp
80102597:	50                   	push   %eax
80102598:	e8 9f f4 ff ff       	call   80101a3c <idup>
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801025a3:	e9 9e 00 00 00       	jmp    80102646 <namex+0xe2>
    ilock(ip);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	ff 75 f4             	pushl  -0xc(%ebp)
801025ae:	e8 c3 f4 ff ff       	call   80101a76 <ilock>
801025b3:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025b9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801025bd:	66 83 f8 01          	cmp    $0x1,%ax
801025c1:	74 18                	je     801025db <namex+0x77>
      iunlockput(ip);
801025c3:	83 ec 0c             	sub    $0xc,%esp
801025c6:	ff 75 f4             	pushl  -0xc(%ebp)
801025c9:	e8 90 f7 ff ff       	call   80101d5e <iunlockput>
801025ce:	83 c4 10             	add    $0x10,%esp
      return 0;
801025d1:	b8 00 00 00 00       	mov    $0x0,%eax
801025d6:	e9 a7 00 00 00       	jmp    80102682 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
801025db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025df:	74 20                	je     80102601 <namex+0x9d>
801025e1:	8b 45 08             	mov    0x8(%ebp),%eax
801025e4:	0f b6 00             	movzbl (%eax),%eax
801025e7:	84 c0                	test   %al,%al
801025e9:	75 16                	jne    80102601 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
801025eb:	83 ec 0c             	sub    $0xc,%esp
801025ee:	ff 75 f4             	pushl  -0xc(%ebp)
801025f1:	e8 06 f6 ff ff       	call   80101bfc <iunlock>
801025f6:	83 c4 10             	add    $0x10,%esp
      return ip;
801025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025fc:	e9 81 00 00 00       	jmp    80102682 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102601:	83 ec 04             	sub    $0x4,%esp
80102604:	6a 00                	push   $0x0
80102606:	ff 75 10             	pushl  0x10(%ebp)
80102609:	ff 75 f4             	pushl  -0xc(%ebp)
8010260c:	e8 1d fd ff ff       	call   8010232e <dirlookup>
80102611:	83 c4 10             	add    $0x10,%esp
80102614:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102617:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010261b:	75 15                	jne    80102632 <namex+0xce>
      iunlockput(ip);
8010261d:	83 ec 0c             	sub    $0xc,%esp
80102620:	ff 75 f4             	pushl  -0xc(%ebp)
80102623:	e8 36 f7 ff ff       	call   80101d5e <iunlockput>
80102628:	83 c4 10             	add    $0x10,%esp
      return 0;
8010262b:	b8 00 00 00 00       	mov    $0x0,%eax
80102630:	eb 50                	jmp    80102682 <namex+0x11e>
    }
    iunlockput(ip);
80102632:	83 ec 0c             	sub    $0xc,%esp
80102635:	ff 75 f4             	pushl  -0xc(%ebp)
80102638:	e8 21 f7 ff ff       	call   80101d5e <iunlockput>
8010263d:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102640:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102646:	83 ec 08             	sub    $0x8,%esp
80102649:	ff 75 10             	pushl  0x10(%ebp)
8010264c:	ff 75 08             	pushl  0x8(%ebp)
8010264f:	e8 6c fe ff ff       	call   801024c0 <skipelem>
80102654:	83 c4 10             	add    $0x10,%esp
80102657:	89 45 08             	mov    %eax,0x8(%ebp)
8010265a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010265e:	0f 85 44 ff ff ff    	jne    801025a8 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102668:	74 15                	je     8010267f <namex+0x11b>
    iput(ip);
8010266a:	83 ec 0c             	sub    $0xc,%esp
8010266d:	ff 75 f4             	pushl  -0xc(%ebp)
80102670:	e8 f9 f5 ff ff       	call   80101c6e <iput>
80102675:	83 c4 10             	add    $0x10,%esp
    return 0;
80102678:	b8 00 00 00 00       	mov    $0x0,%eax
8010267d:	eb 03                	jmp    80102682 <namex+0x11e>
  }
  return ip;
8010267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102682:	c9                   	leave  
80102683:	c3                   	ret    

80102684 <namei>:

struct inode*
namei(char *path)
{
80102684:	55                   	push   %ebp
80102685:	89 e5                	mov    %esp,%ebp
80102687:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010268a:	83 ec 04             	sub    $0x4,%esp
8010268d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102690:	50                   	push   %eax
80102691:	6a 00                	push   $0x0
80102693:	ff 75 08             	pushl  0x8(%ebp)
80102696:	e8 c9 fe ff ff       	call   80102564 <namex>
8010269b:	83 c4 10             	add    $0x10,%esp
}
8010269e:	c9                   	leave  
8010269f:	c3                   	ret    

801026a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801026a6:	83 ec 04             	sub    $0x4,%esp
801026a9:	ff 75 0c             	pushl  0xc(%ebp)
801026ac:	6a 01                	push   $0x1
801026ae:	ff 75 08             	pushl  0x8(%ebp)
801026b1:	e8 ae fe ff ff       	call   80102564 <namex>
801026b6:	83 c4 10             	add    $0x10,%esp
}
801026b9:	c9                   	leave  
801026ba:	c3                   	ret    

801026bb <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801026bb:	55                   	push   %ebp
801026bc:	89 e5                	mov    %esp,%ebp
801026be:	83 ec 14             	sub    $0x14,%esp
801026c1:	8b 45 08             	mov    0x8(%ebp),%eax
801026c4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801026cc:	89 c2                	mov    %eax,%edx
801026ce:	ec                   	in     (%dx),%al
801026cf:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801026d2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801026d6:	c9                   	leave  
801026d7:	c3                   	ret    

801026d8 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801026d8:	55                   	push   %ebp
801026d9:	89 e5                	mov    %esp,%ebp
801026db:	57                   	push   %edi
801026dc:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801026dd:	8b 55 08             	mov    0x8(%ebp),%edx
801026e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026e3:	8b 45 10             	mov    0x10(%ebp),%eax
801026e6:	89 cb                	mov    %ecx,%ebx
801026e8:	89 df                	mov    %ebx,%edi
801026ea:	89 c1                	mov    %eax,%ecx
801026ec:	fc                   	cld    
801026ed:	f3 6d                	rep insl (%dx),%es:(%edi)
801026ef:	89 c8                	mov    %ecx,%eax
801026f1:	89 fb                	mov    %edi,%ebx
801026f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026f6:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801026f9:	90                   	nop
801026fa:	5b                   	pop    %ebx
801026fb:	5f                   	pop    %edi
801026fc:	5d                   	pop    %ebp
801026fd:	c3                   	ret    

801026fe <outb>:

static inline void
outb(ushort port, uchar data)
{
801026fe:	55                   	push   %ebp
801026ff:	89 e5                	mov    %esp,%ebp
80102701:	83 ec 08             	sub    $0x8,%esp
80102704:	8b 55 08             	mov    0x8(%ebp),%edx
80102707:	8b 45 0c             	mov    0xc(%ebp),%eax
8010270a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010270e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102711:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102715:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102719:	ee                   	out    %al,(%dx)
}
8010271a:	90                   	nop
8010271b:	c9                   	leave  
8010271c:	c3                   	ret    

8010271d <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010271d:	55                   	push   %ebp
8010271e:	89 e5                	mov    %esp,%ebp
80102720:	56                   	push   %esi
80102721:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102722:	8b 55 08             	mov    0x8(%ebp),%edx
80102725:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102728:	8b 45 10             	mov    0x10(%ebp),%eax
8010272b:	89 cb                	mov    %ecx,%ebx
8010272d:	89 de                	mov    %ebx,%esi
8010272f:	89 c1                	mov    %eax,%ecx
80102731:	fc                   	cld    
80102732:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102734:	89 c8                	mov    %ecx,%eax
80102736:	89 f3                	mov    %esi,%ebx
80102738:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010273b:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010273e:	90                   	nop
8010273f:	5b                   	pop    %ebx
80102740:	5e                   	pop    %esi
80102741:	5d                   	pop    %ebp
80102742:	c3                   	ret    

80102743 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102743:	55                   	push   %ebp
80102744:	89 e5                	mov    %esp,%ebp
80102746:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102749:	90                   	nop
8010274a:	68 f7 01 00 00       	push   $0x1f7
8010274f:	e8 67 ff ff ff       	call   801026bb <inb>
80102754:	83 c4 04             	add    $0x4,%esp
80102757:	0f b6 c0             	movzbl %al,%eax
8010275a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010275d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102760:	25 c0 00 00 00       	and    $0xc0,%eax
80102765:	83 f8 40             	cmp    $0x40,%eax
80102768:	75 e0                	jne    8010274a <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010276a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010276e:	74 11                	je     80102781 <idewait+0x3e>
80102770:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102773:	83 e0 21             	and    $0x21,%eax
80102776:	85 c0                	test   %eax,%eax
80102778:	74 07                	je     80102781 <idewait+0x3e>
    return -1;
8010277a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010277f:	eb 05                	jmp    80102786 <idewait+0x43>
  return 0;
80102781:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102786:	c9                   	leave  
80102787:	c3                   	ret    

80102788 <ideinit>:

void
ideinit(void)
{
80102788:	55                   	push   %ebp
80102789:	89 e5                	mov    %esp,%ebp
8010278b:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
8010278e:	83 ec 08             	sub    $0x8,%esp
80102791:	68 22 8f 10 80       	push   $0x80108f22
80102796:	68 40 c6 10 80       	push   $0x8010c640
8010279b:	e8 6c 2d 00 00       	call   8010550c <initlock>
801027a0:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801027a3:	83 ec 0c             	sub    $0xc,%esp
801027a6:	6a 0e                	push   $0xe
801027a8:	e8 da 18 00 00       	call   80104087 <picenable>
801027ad:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801027b0:	a1 80 39 11 80       	mov    0x80113980,%eax
801027b5:	83 e8 01             	sub    $0x1,%eax
801027b8:	83 ec 08             	sub    $0x8,%esp
801027bb:	50                   	push   %eax
801027bc:	6a 0e                	push   $0xe
801027be:	e8 73 04 00 00       	call   80102c36 <ioapicenable>
801027c3:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801027c6:	83 ec 0c             	sub    $0xc,%esp
801027c9:	6a 00                	push   $0x0
801027cb:	e8 73 ff ff ff       	call   80102743 <idewait>
801027d0:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801027d3:	83 ec 08             	sub    $0x8,%esp
801027d6:	68 f0 00 00 00       	push   $0xf0
801027db:	68 f6 01 00 00       	push   $0x1f6
801027e0:	e8 19 ff ff ff       	call   801026fe <outb>
801027e5:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801027e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027ef:	eb 24                	jmp    80102815 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801027f1:	83 ec 0c             	sub    $0xc,%esp
801027f4:	68 f7 01 00 00       	push   $0x1f7
801027f9:	e8 bd fe ff ff       	call   801026bb <inb>
801027fe:	83 c4 10             	add    $0x10,%esp
80102801:	84 c0                	test   %al,%al
80102803:	74 0c                	je     80102811 <ideinit+0x89>
      havedisk1 = 1;
80102805:	c7 05 78 c6 10 80 01 	movl   $0x1,0x8010c678
8010280c:	00 00 00 
      break;
8010280f:	eb 0d                	jmp    8010281e <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102811:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102815:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010281c:	7e d3                	jle    801027f1 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010281e:	83 ec 08             	sub    $0x8,%esp
80102821:	68 e0 00 00 00       	push   $0xe0
80102826:	68 f6 01 00 00       	push   $0x1f6
8010282b:	e8 ce fe ff ff       	call   801026fe <outb>
80102830:	83 c4 10             	add    $0x10,%esp
}
80102833:	90                   	nop
80102834:	c9                   	leave  
80102835:	c3                   	ret    

80102836 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102836:	55                   	push   %ebp
80102837:	89 e5                	mov    %esp,%ebp
80102839:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010283c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102840:	75 0d                	jne    8010284f <idestart+0x19>
    panic("idestart");
80102842:	83 ec 0c             	sub    $0xc,%esp
80102845:	68 26 8f 10 80       	push   $0x80108f26
8010284a:	e8 17 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
8010284f:	8b 45 08             	mov    0x8(%ebp),%eax
80102852:	8b 40 08             	mov    0x8(%eax),%eax
80102855:	3d cf 07 00 00       	cmp    $0x7cf,%eax
8010285a:	76 0d                	jbe    80102869 <idestart+0x33>
    panic("incorrect blockno");
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	68 2f 8f 10 80       	push   $0x80108f2f
80102864:	e8 fd dc ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102869:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102870:	8b 45 08             	mov    0x8(%ebp),%eax
80102873:	8b 50 08             	mov    0x8(%eax),%edx
80102876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102879:	0f af c2             	imul   %edx,%eax
8010287c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010287f:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102883:	7e 0d                	jle    80102892 <idestart+0x5c>
80102885:	83 ec 0c             	sub    $0xc,%esp
80102888:	68 26 8f 10 80       	push   $0x80108f26
8010288d:	e8 d4 dc ff ff       	call   80100566 <panic>
  
  idewait(0);
80102892:	83 ec 0c             	sub    $0xc,%esp
80102895:	6a 00                	push   $0x0
80102897:	e8 a7 fe ff ff       	call   80102743 <idewait>
8010289c:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
8010289f:	83 ec 08             	sub    $0x8,%esp
801028a2:	6a 00                	push   $0x0
801028a4:	68 f6 03 00 00       	push   $0x3f6
801028a9:	e8 50 fe ff ff       	call   801026fe <outb>
801028ae:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b4:	0f b6 c0             	movzbl %al,%eax
801028b7:	83 ec 08             	sub    $0x8,%esp
801028ba:	50                   	push   %eax
801028bb:	68 f2 01 00 00       	push   $0x1f2
801028c0:	e8 39 fe ff ff       	call   801026fe <outb>
801028c5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028cb:	0f b6 c0             	movzbl %al,%eax
801028ce:	83 ec 08             	sub    $0x8,%esp
801028d1:	50                   	push   %eax
801028d2:	68 f3 01 00 00       	push   $0x1f3
801028d7:	e8 22 fe ff ff       	call   801026fe <outb>
801028dc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028e2:	c1 f8 08             	sar    $0x8,%eax
801028e5:	0f b6 c0             	movzbl %al,%eax
801028e8:	83 ec 08             	sub    $0x8,%esp
801028eb:	50                   	push   %eax
801028ec:	68 f4 01 00 00       	push   $0x1f4
801028f1:	e8 08 fe ff ff       	call   801026fe <outb>
801028f6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028fc:	c1 f8 10             	sar    $0x10,%eax
801028ff:	0f b6 c0             	movzbl %al,%eax
80102902:	83 ec 08             	sub    $0x8,%esp
80102905:	50                   	push   %eax
80102906:	68 f5 01 00 00       	push   $0x1f5
8010290b:	e8 ee fd ff ff       	call   801026fe <outb>
80102910:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102913:	8b 45 08             	mov    0x8(%ebp),%eax
80102916:	8b 40 04             	mov    0x4(%eax),%eax
80102919:	83 e0 01             	and    $0x1,%eax
8010291c:	c1 e0 04             	shl    $0x4,%eax
8010291f:	89 c2                	mov    %eax,%edx
80102921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102924:	c1 f8 18             	sar    $0x18,%eax
80102927:	83 e0 0f             	and    $0xf,%eax
8010292a:	09 d0                	or     %edx,%eax
8010292c:	83 c8 e0             	or     $0xffffffe0,%eax
8010292f:	0f b6 c0             	movzbl %al,%eax
80102932:	83 ec 08             	sub    $0x8,%esp
80102935:	50                   	push   %eax
80102936:	68 f6 01 00 00       	push   $0x1f6
8010293b:	e8 be fd ff ff       	call   801026fe <outb>
80102940:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102943:	8b 45 08             	mov    0x8(%ebp),%eax
80102946:	8b 00                	mov    (%eax),%eax
80102948:	83 e0 04             	and    $0x4,%eax
8010294b:	85 c0                	test   %eax,%eax
8010294d:	74 30                	je     8010297f <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
8010294f:	83 ec 08             	sub    $0x8,%esp
80102952:	6a 30                	push   $0x30
80102954:	68 f7 01 00 00       	push   $0x1f7
80102959:	e8 a0 fd ff ff       	call   801026fe <outb>
8010295e:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102961:	8b 45 08             	mov    0x8(%ebp),%eax
80102964:	83 c0 18             	add    $0x18,%eax
80102967:	83 ec 04             	sub    $0x4,%esp
8010296a:	68 80 00 00 00       	push   $0x80
8010296f:	50                   	push   %eax
80102970:	68 f0 01 00 00       	push   $0x1f0
80102975:	e8 a3 fd ff ff       	call   8010271d <outsl>
8010297a:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
8010297d:	eb 12                	jmp    80102991 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010297f:	83 ec 08             	sub    $0x8,%esp
80102982:	6a 20                	push   $0x20
80102984:	68 f7 01 00 00       	push   $0x1f7
80102989:	e8 70 fd ff ff       	call   801026fe <outb>
8010298e:	83 c4 10             	add    $0x10,%esp
  }
}
80102991:	90                   	nop
80102992:	c9                   	leave  
80102993:	c3                   	ret    

80102994 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102994:	55                   	push   %ebp
80102995:	89 e5                	mov    %esp,%ebp
80102997:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010299a:	83 ec 0c             	sub    $0xc,%esp
8010299d:	68 40 c6 10 80       	push   $0x8010c640
801029a2:	e8 87 2b 00 00       	call   8010552e <acquire>
801029a7:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801029aa:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801029af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801029b6:	75 15                	jne    801029cd <ideintr+0x39>
    release(&idelock);
801029b8:	83 ec 0c             	sub    $0xc,%esp
801029bb:	68 40 c6 10 80       	push   $0x8010c640
801029c0:	e8 d0 2b 00 00       	call   80105595 <release>
801029c5:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801029c8:	e9 9a 00 00 00       	jmp    80102a67 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d0:	8b 40 14             	mov    0x14(%eax),%eax
801029d3:	a3 74 c6 10 80       	mov    %eax,0x8010c674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029db:	8b 00                	mov    (%eax),%eax
801029dd:	83 e0 04             	and    $0x4,%eax
801029e0:	85 c0                	test   %eax,%eax
801029e2:	75 2d                	jne    80102a11 <ideintr+0x7d>
801029e4:	83 ec 0c             	sub    $0xc,%esp
801029e7:	6a 01                	push   $0x1
801029e9:	e8 55 fd ff ff       	call   80102743 <idewait>
801029ee:	83 c4 10             	add    $0x10,%esp
801029f1:	85 c0                	test   %eax,%eax
801029f3:	78 1c                	js     80102a11 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f8:	83 c0 18             	add    $0x18,%eax
801029fb:	83 ec 04             	sub    $0x4,%esp
801029fe:	68 80 00 00 00       	push   $0x80
80102a03:	50                   	push   %eax
80102a04:	68 f0 01 00 00       	push   $0x1f0
80102a09:	e8 ca fc ff ff       	call   801026d8 <insl>
80102a0e:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a14:	8b 00                	mov    (%eax),%eax
80102a16:	83 c8 02             	or     $0x2,%eax
80102a19:	89 c2                	mov    %eax,%edx
80102a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a1e:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a23:	8b 00                	mov    (%eax),%eax
80102a25:	83 e0 fb             	and    $0xfffffffb,%eax
80102a28:	89 c2                	mov    %eax,%edx
80102a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2d:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a2f:	83 ec 0c             	sub    $0xc,%esp
80102a32:	ff 75 f4             	pushl  -0xc(%ebp)
80102a35:	e8 4b 26 00 00       	call   80105085 <wakeup>
80102a3a:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a3d:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102a42:	85 c0                	test   %eax,%eax
80102a44:	74 11                	je     80102a57 <ideintr+0xc3>
    idestart(idequeue);
80102a46:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102a4b:	83 ec 0c             	sub    $0xc,%esp
80102a4e:	50                   	push   %eax
80102a4f:	e8 e2 fd ff ff       	call   80102836 <idestart>
80102a54:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102a57:	83 ec 0c             	sub    $0xc,%esp
80102a5a:	68 40 c6 10 80       	push   $0x8010c640
80102a5f:	e8 31 2b 00 00       	call   80105595 <release>
80102a64:	83 c4 10             	add    $0x10,%esp
}
80102a67:	c9                   	leave  
80102a68:	c3                   	ret    

80102a69 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a69:	55                   	push   %ebp
80102a6a:	89 e5                	mov    %esp,%ebp
80102a6c:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a72:	8b 00                	mov    (%eax),%eax
80102a74:	83 e0 01             	and    $0x1,%eax
80102a77:	85 c0                	test   %eax,%eax
80102a79:	75 0d                	jne    80102a88 <iderw+0x1f>
    panic("iderw: buf not busy");
80102a7b:	83 ec 0c             	sub    $0xc,%esp
80102a7e:	68 41 8f 10 80       	push   $0x80108f41
80102a83:	e8 de da ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102a88:	8b 45 08             	mov    0x8(%ebp),%eax
80102a8b:	8b 00                	mov    (%eax),%eax
80102a8d:	83 e0 06             	and    $0x6,%eax
80102a90:	83 f8 02             	cmp    $0x2,%eax
80102a93:	75 0d                	jne    80102aa2 <iderw+0x39>
    panic("iderw: nothing to do");
80102a95:	83 ec 0c             	sub    $0xc,%esp
80102a98:	68 55 8f 10 80       	push   $0x80108f55
80102a9d:	e8 c4 da ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa5:	8b 40 04             	mov    0x4(%eax),%eax
80102aa8:	85 c0                	test   %eax,%eax
80102aaa:	74 16                	je     80102ac2 <iderw+0x59>
80102aac:	a1 78 c6 10 80       	mov    0x8010c678,%eax
80102ab1:	85 c0                	test   %eax,%eax
80102ab3:	75 0d                	jne    80102ac2 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102ab5:	83 ec 0c             	sub    $0xc,%esp
80102ab8:	68 6a 8f 10 80       	push   $0x80108f6a
80102abd:	e8 a4 da ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102ac2:	83 ec 0c             	sub    $0xc,%esp
80102ac5:	68 40 c6 10 80       	push   $0x8010c640
80102aca:	e8 5f 2a 00 00       	call   8010552e <acquire>
80102acf:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102adc:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80102ae3:	eb 0b                	jmp    80102af0 <iderw+0x87>
80102ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae8:	8b 00                	mov    (%eax),%eax
80102aea:	83 c0 14             	add    $0x14,%eax
80102aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102af3:	8b 00                	mov    (%eax),%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	75 ec                	jne    80102ae5 <iderw+0x7c>
    ;
  *pp = b;
80102af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afc:	8b 55 08             	mov    0x8(%ebp),%edx
80102aff:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102b01:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102b06:	3b 45 08             	cmp    0x8(%ebp),%eax
80102b09:	75 23                	jne    80102b2e <iderw+0xc5>
    idestart(b);
80102b0b:	83 ec 0c             	sub    $0xc,%esp
80102b0e:	ff 75 08             	pushl  0x8(%ebp)
80102b11:	e8 20 fd ff ff       	call   80102836 <idestart>
80102b16:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b19:	eb 13                	jmp    80102b2e <iderw+0xc5>
    sleep(b, &idelock);
80102b1b:	83 ec 08             	sub    $0x8,%esp
80102b1e:	68 40 c6 10 80       	push   $0x8010c640
80102b23:	ff 75 08             	pushl  0x8(%ebp)
80102b26:	e8 6c 24 00 00       	call   80104f97 <sleep>
80102b2b:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b31:	8b 00                	mov    (%eax),%eax
80102b33:	83 e0 06             	and    $0x6,%eax
80102b36:	83 f8 02             	cmp    $0x2,%eax
80102b39:	75 e0                	jne    80102b1b <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102b3b:	83 ec 0c             	sub    $0xc,%esp
80102b3e:	68 40 c6 10 80       	push   $0x8010c640
80102b43:	e8 4d 2a 00 00       	call   80105595 <release>
80102b48:	83 c4 10             	add    $0x10,%esp
}
80102b4b:	90                   	nop
80102b4c:	c9                   	leave  
80102b4d:	c3                   	ret    

80102b4e <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102b4e:	55                   	push   %ebp
80102b4f:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b51:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b56:	8b 55 08             	mov    0x8(%ebp),%edx
80102b59:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102b5b:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b60:	8b 40 10             	mov    0x10(%eax),%eax
}
80102b63:	5d                   	pop    %ebp
80102b64:	c3                   	ret    

80102b65 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102b65:	55                   	push   %ebp
80102b66:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b68:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b6d:	8b 55 08             	mov    0x8(%ebp),%edx
80102b70:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102b72:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b77:	8b 55 0c             	mov    0xc(%ebp),%edx
80102b7a:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b7d:	90                   	nop
80102b7e:	5d                   	pop    %ebp
80102b7f:	c3                   	ret    

80102b80 <ioapicinit>:

void
ioapicinit(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102b86:	a1 84 33 11 80       	mov    0x80113384,%eax
80102b8b:	85 c0                	test   %eax,%eax
80102b8d:	0f 84 a0 00 00 00    	je     80102c33 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102b93:	c7 05 54 32 11 80 00 	movl   $0xfec00000,0x80113254
80102b9a:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102b9d:	6a 01                	push   $0x1
80102b9f:	e8 aa ff ff ff       	call   80102b4e <ioapicread>
80102ba4:	83 c4 04             	add    $0x4,%esp
80102ba7:	c1 e8 10             	shr    $0x10,%eax
80102baa:	25 ff 00 00 00       	and    $0xff,%eax
80102baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102bb2:	6a 00                	push   $0x0
80102bb4:	e8 95 ff ff ff       	call   80102b4e <ioapicread>
80102bb9:	83 c4 04             	add    $0x4,%esp
80102bbc:	c1 e8 18             	shr    $0x18,%eax
80102bbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102bc2:	0f b6 05 80 33 11 80 	movzbl 0x80113380,%eax
80102bc9:	0f b6 c0             	movzbl %al,%eax
80102bcc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102bcf:	74 10                	je     80102be1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102bd1:	83 ec 0c             	sub    $0xc,%esp
80102bd4:	68 88 8f 10 80       	push   $0x80108f88
80102bd9:	e8 e8 d7 ff ff       	call   801003c6 <cprintf>
80102bde:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102be8:	eb 3f                	jmp    80102c29 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bed:	83 c0 20             	add    $0x20,%eax
80102bf0:	0d 00 00 01 00       	or     $0x10000,%eax
80102bf5:	89 c2                	mov    %eax,%edx
80102bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfa:	83 c0 08             	add    $0x8,%eax
80102bfd:	01 c0                	add    %eax,%eax
80102bff:	83 ec 08             	sub    $0x8,%esp
80102c02:	52                   	push   %edx
80102c03:	50                   	push   %eax
80102c04:	e8 5c ff ff ff       	call   80102b65 <ioapicwrite>
80102c09:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0f:	83 c0 08             	add    $0x8,%eax
80102c12:	01 c0                	add    %eax,%eax
80102c14:	83 c0 01             	add    $0x1,%eax
80102c17:	83 ec 08             	sub    $0x8,%esp
80102c1a:	6a 00                	push   $0x0
80102c1c:	50                   	push   %eax
80102c1d:	e8 43 ff ff ff       	call   80102b65 <ioapicwrite>
80102c22:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c25:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102c2f:	7e b9                	jle    80102bea <ioapicinit+0x6a>
80102c31:	eb 01                	jmp    80102c34 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102c33:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    

80102c36 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c36:	55                   	push   %ebp
80102c37:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102c39:	a1 84 33 11 80       	mov    0x80113384,%eax
80102c3e:	85 c0                	test   %eax,%eax
80102c40:	74 39                	je     80102c7b <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c42:	8b 45 08             	mov    0x8(%ebp),%eax
80102c45:	83 c0 20             	add    $0x20,%eax
80102c48:	89 c2                	mov    %eax,%edx
80102c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80102c4d:	83 c0 08             	add    $0x8,%eax
80102c50:	01 c0                	add    %eax,%eax
80102c52:	52                   	push   %edx
80102c53:	50                   	push   %eax
80102c54:	e8 0c ff ff ff       	call   80102b65 <ioapicwrite>
80102c59:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c5f:	c1 e0 18             	shl    $0x18,%eax
80102c62:	89 c2                	mov    %eax,%edx
80102c64:	8b 45 08             	mov    0x8(%ebp),%eax
80102c67:	83 c0 08             	add    $0x8,%eax
80102c6a:	01 c0                	add    %eax,%eax
80102c6c:	83 c0 01             	add    $0x1,%eax
80102c6f:	52                   	push   %edx
80102c70:	50                   	push   %eax
80102c71:	e8 ef fe ff ff       	call   80102b65 <ioapicwrite>
80102c76:	83 c4 08             	add    $0x8,%esp
80102c79:	eb 01                	jmp    80102c7c <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102c7b:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102c7c:	c9                   	leave  
80102c7d:	c3                   	ret    

80102c7e <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102c7e:	55                   	push   %ebp
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	8b 45 08             	mov    0x8(%ebp),%eax
80102c84:	05 00 00 00 80       	add    $0x80000000,%eax
80102c89:	5d                   	pop    %ebp
80102c8a:	c3                   	ret    

80102c8b <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102c8b:	55                   	push   %ebp
80102c8c:	89 e5                	mov    %esp,%ebp
80102c8e:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102c91:	83 ec 08             	sub    $0x8,%esp
80102c94:	68 ba 8f 10 80       	push   $0x80108fba
80102c99:	68 60 32 11 80       	push   $0x80113260
80102c9e:	e8 69 28 00 00       	call   8010550c <initlock>
80102ca3:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ca6:	c7 05 94 32 11 80 00 	movl   $0x0,0x80113294
80102cad:	00 00 00 
  freerange(vstart, vend);
80102cb0:	83 ec 08             	sub    $0x8,%esp
80102cb3:	ff 75 0c             	pushl  0xc(%ebp)
80102cb6:	ff 75 08             	pushl  0x8(%ebp)
80102cb9:	e8 2a 00 00 00       	call   80102ce8 <freerange>
80102cbe:	83 c4 10             	add    $0x10,%esp
}
80102cc1:	90                   	nop
80102cc2:	c9                   	leave  
80102cc3:	c3                   	ret    

80102cc4 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102cc4:	55                   	push   %ebp
80102cc5:	89 e5                	mov    %esp,%ebp
80102cc7:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102cca:	83 ec 08             	sub    $0x8,%esp
80102ccd:	ff 75 0c             	pushl  0xc(%ebp)
80102cd0:	ff 75 08             	pushl  0x8(%ebp)
80102cd3:	e8 10 00 00 00       	call   80102ce8 <freerange>
80102cd8:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102cdb:	c7 05 94 32 11 80 01 	movl   $0x1,0x80113294
80102ce2:	00 00 00 
}
80102ce5:	90                   	nop
80102ce6:	c9                   	leave  
80102ce7:	c3                   	ret    

80102ce8 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ce8:	55                   	push   %ebp
80102ce9:	89 e5                	mov    %esp,%ebp
80102ceb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102cee:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf1:	05 ff 0f 00 00       	add    $0xfff,%eax
80102cf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cfe:	eb 15                	jmp    80102d15 <freerange+0x2d>
    kfree(p);
80102d00:	83 ec 0c             	sub    $0xc,%esp
80102d03:	ff 75 f4             	pushl  -0xc(%ebp)
80102d06:	e8 1a 00 00 00       	call   80102d25 <kfree>
80102d0b:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d0e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d18:	05 00 10 00 00       	add    $0x1000,%eax
80102d1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102d20:	76 de                	jbe    80102d00 <freerange+0x18>
    kfree(p);
}
80102d22:	90                   	nop
80102d23:	c9                   	leave  
80102d24:	c3                   	ret    

80102d25 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d25:	55                   	push   %ebp
80102d26:	89 e5                	mov    %esp,%ebp
80102d28:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80102d2e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d33:	85 c0                	test   %eax,%eax
80102d35:	75 1b                	jne    80102d52 <kfree+0x2d>
80102d37:	81 7d 08 7c 66 11 80 	cmpl   $0x8011667c,0x8(%ebp)
80102d3e:	72 12                	jb     80102d52 <kfree+0x2d>
80102d40:	ff 75 08             	pushl  0x8(%ebp)
80102d43:	e8 36 ff ff ff       	call   80102c7e <v2p>
80102d48:	83 c4 04             	add    $0x4,%esp
80102d4b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d50:	76 0d                	jbe    80102d5f <kfree+0x3a>
    panic("kfree");
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	68 bf 8f 10 80       	push   $0x80108fbf
80102d5a:	e8 07 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d5f:	83 ec 04             	sub    $0x4,%esp
80102d62:	68 00 10 00 00       	push   $0x1000
80102d67:	6a 01                	push   $0x1
80102d69:	ff 75 08             	pushl  0x8(%ebp)
80102d6c:	e8 20 2a 00 00       	call   80105791 <memset>
80102d71:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102d74:	a1 94 32 11 80       	mov    0x80113294,%eax
80102d79:	85 c0                	test   %eax,%eax
80102d7b:	74 10                	je     80102d8d <kfree+0x68>
    acquire(&kmem.lock);
80102d7d:	83 ec 0c             	sub    $0xc,%esp
80102d80:	68 60 32 11 80       	push   $0x80113260
80102d85:	e8 a4 27 00 00       	call   8010552e <acquire>
80102d8a:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80102d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102d93:	8b 15 98 32 11 80    	mov    0x80113298,%edx
80102d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d9c:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da1:	a3 98 32 11 80       	mov    %eax,0x80113298
  if(kmem.use_lock)
80102da6:	a1 94 32 11 80       	mov    0x80113294,%eax
80102dab:	85 c0                	test   %eax,%eax
80102dad:	74 10                	je     80102dbf <kfree+0x9a>
    release(&kmem.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
80102db2:	68 60 32 11 80       	push   $0x80113260
80102db7:	e8 d9 27 00 00       	call   80105595 <release>
80102dbc:	83 c4 10             	add    $0x10,%esp
}
80102dbf:	90                   	nop
80102dc0:	c9                   	leave  
80102dc1:	c3                   	ret    

80102dc2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102dc2:	55                   	push   %ebp
80102dc3:	89 e5                	mov    %esp,%ebp
80102dc5:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102dc8:	a1 94 32 11 80       	mov    0x80113294,%eax
80102dcd:	85 c0                	test   %eax,%eax
80102dcf:	74 10                	je     80102de1 <kalloc+0x1f>
    acquire(&kmem.lock);
80102dd1:	83 ec 0c             	sub    $0xc,%esp
80102dd4:	68 60 32 11 80       	push   $0x80113260
80102dd9:	e8 50 27 00 00       	call   8010552e <acquire>
80102dde:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102de1:	a1 98 32 11 80       	mov    0x80113298,%eax
80102de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ded:	74 0a                	je     80102df9 <kalloc+0x37>
    kmem.freelist = r->next;
80102def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df2:	8b 00                	mov    (%eax),%eax
80102df4:	a3 98 32 11 80       	mov    %eax,0x80113298
  if(kmem.use_lock)
80102df9:	a1 94 32 11 80       	mov    0x80113294,%eax
80102dfe:	85 c0                	test   %eax,%eax
80102e00:	74 10                	je     80102e12 <kalloc+0x50>
    release(&kmem.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 60 32 11 80       	push   $0x80113260
80102e0a:	e8 86 27 00 00       	call   80105595 <release>
80102e0f:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e15:	c9                   	leave  
80102e16:	c3                   	ret    

80102e17 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e17:	55                   	push   %ebp
80102e18:	89 e5                	mov    %esp,%ebp
80102e1a:	83 ec 14             	sub    $0x14,%esp
80102e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80102e20:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e24:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e28:	89 c2                	mov    %eax,%edx
80102e2a:	ec                   	in     (%dx),%al
80102e2b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e2e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e32:	c9                   	leave  
80102e33:	c3                   	ret    

80102e34 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e34:	55                   	push   %ebp
80102e35:	89 e5                	mov    %esp,%ebp
80102e37:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e3a:	6a 64                	push   $0x64
80102e3c:	e8 d6 ff ff ff       	call   80102e17 <inb>
80102e41:	83 c4 04             	add    $0x4,%esp
80102e44:	0f b6 c0             	movzbl %al,%eax
80102e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e4d:	83 e0 01             	and    $0x1,%eax
80102e50:	85 c0                	test   %eax,%eax
80102e52:	75 0a                	jne    80102e5e <kbdgetc+0x2a>
    return -1;
80102e54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e59:	e9 23 01 00 00       	jmp    80102f81 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102e5e:	6a 60                	push   $0x60
80102e60:	e8 b2 ff ff ff       	call   80102e17 <inb>
80102e65:	83 c4 04             	add    $0x4,%esp
80102e68:	0f b6 c0             	movzbl %al,%eax
80102e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102e6e:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102e75:	75 17                	jne    80102e8e <kbdgetc+0x5a>
    shift |= E0ESC;
80102e77:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e7c:	83 c8 40             	or     $0x40,%eax
80102e7f:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102e84:	b8 00 00 00 00       	mov    $0x0,%eax
80102e89:	e9 f3 00 00 00       	jmp    80102f81 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e91:	25 80 00 00 00       	and    $0x80,%eax
80102e96:	85 c0                	test   %eax,%eax
80102e98:	74 45                	je     80102edf <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102e9a:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102e9f:	83 e0 40             	and    $0x40,%eax
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	75 08                	jne    80102eae <kbdgetc+0x7a>
80102ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ea9:	83 e0 7f             	and    $0x7f,%eax
80102eac:	eb 03                	jmp    80102eb1 <kbdgetc+0x7d>
80102eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eb7:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ebc:	0f b6 00             	movzbl (%eax),%eax
80102ebf:	83 c8 40             	or     $0x40,%eax
80102ec2:	0f b6 c0             	movzbl %al,%eax
80102ec5:	f7 d0                	not    %eax
80102ec7:	89 c2                	mov    %eax,%edx
80102ec9:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ece:	21 d0                	and    %edx,%eax
80102ed0:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102ed5:	b8 00 00 00 00       	mov    $0x0,%eax
80102eda:	e9 a2 00 00 00       	jmp    80102f81 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102edf:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ee4:	83 e0 40             	and    $0x40,%eax
80102ee7:	85 c0                	test   %eax,%eax
80102ee9:	74 14                	je     80102eff <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102eeb:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102ef2:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ef7:	83 e0 bf             	and    $0xffffffbf,%eax
80102efa:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  }

  shift |= shiftcode[data];
80102eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f02:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f07:	0f b6 00             	movzbl (%eax),%eax
80102f0a:	0f b6 d0             	movzbl %al,%edx
80102f0d:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102f12:	09 d0                	or     %edx,%eax
80102f14:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  shift ^= togglecode[data];
80102f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f1c:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102f21:	0f b6 00             	movzbl (%eax),%eax
80102f24:	0f b6 d0             	movzbl %al,%edx
80102f27:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102f2c:	31 d0                	xor    %edx,%eax
80102f2e:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f33:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102f38:	83 e0 03             	and    $0x3,%eax
80102f3b:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f45:	01 d0                	add    %edx,%eax
80102f47:	0f b6 00             	movzbl (%eax),%eax
80102f4a:	0f b6 c0             	movzbl %al,%eax
80102f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102f50:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102f55:	83 e0 08             	and    $0x8,%eax
80102f58:	85 c0                	test   %eax,%eax
80102f5a:	74 22                	je     80102f7e <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102f5c:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102f60:	76 0c                	jbe    80102f6e <kbdgetc+0x13a>
80102f62:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102f66:	77 06                	ja     80102f6e <kbdgetc+0x13a>
      c += 'A' - 'a';
80102f68:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102f6c:	eb 10                	jmp    80102f7e <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102f6e:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102f72:	76 0a                	jbe    80102f7e <kbdgetc+0x14a>
80102f74:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102f78:	77 04                	ja     80102f7e <kbdgetc+0x14a>
      c += 'a' - 'A';
80102f7a:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102f81:	c9                   	leave  
80102f82:	c3                   	ret    

80102f83 <kbdintr>:

void
kbdintr(void)
{
80102f83:	55                   	push   %ebp
80102f84:	89 e5                	mov    %esp,%ebp
80102f86:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102f89:	83 ec 0c             	sub    $0xc,%esp
80102f8c:	68 34 2e 10 80       	push   $0x80102e34
80102f91:	e8 63 d8 ff ff       	call   801007f9 <consoleintr>
80102f96:	83 c4 10             	add    $0x10,%esp
}
80102f99:	90                   	nop
80102f9a:	c9                   	leave  
80102f9b:	c3                   	ret    

80102f9c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102f9c:	55                   	push   %ebp
80102f9d:	89 e5                	mov    %esp,%ebp
80102f9f:	83 ec 14             	sub    $0x14,%esp
80102fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80102fa5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fa9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102fad:	89 c2                	mov    %eax,%edx
80102faf:	ec                   	in     (%dx),%al
80102fb0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102fb3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102fb7:	c9                   	leave  
80102fb8:	c3                   	ret    

80102fb9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102fb9:	55                   	push   %ebp
80102fba:	89 e5                	mov    %esp,%ebp
80102fbc:	83 ec 08             	sub    $0x8,%esp
80102fbf:	8b 55 08             	mov    0x8(%ebp),%edx
80102fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fc5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102fc9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fcc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102fd0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102fd4:	ee                   	out    %al,(%dx)
}
80102fd5:	90                   	nop
80102fd6:	c9                   	leave  
80102fd7:	c3                   	ret    

80102fd8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102fd8:	55                   	push   %ebp
80102fd9:	89 e5                	mov    %esp,%ebp
80102fdb:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102fde:	9c                   	pushf  
80102fdf:	58                   	pop    %eax
80102fe0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102fe3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102fe6:	c9                   	leave  
80102fe7:	c3                   	ret    

80102fe8 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102fe8:	55                   	push   %ebp
80102fe9:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102feb:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80102ff0:	8b 55 08             	mov    0x8(%ebp),%edx
80102ff3:	c1 e2 02             	shl    $0x2,%edx
80102ff6:	01 c2                	add    %eax,%edx
80102ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ffb:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ffd:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103002:	83 c0 20             	add    $0x20,%eax
80103005:	8b 00                	mov    (%eax),%eax
}
80103007:	90                   	nop
80103008:	5d                   	pop    %ebp
80103009:	c3                   	ret    

8010300a <lapicinit>:

void
lapicinit(void)
{
8010300a:	55                   	push   %ebp
8010300b:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
8010300d:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103012:	85 c0                	test   %eax,%eax
80103014:	0f 84 0b 01 00 00    	je     80103125 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010301a:	68 3f 01 00 00       	push   $0x13f
8010301f:	6a 3c                	push   $0x3c
80103021:	e8 c2 ff ff ff       	call   80102fe8 <lapicw>
80103026:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103029:	6a 0b                	push   $0xb
8010302b:	68 f8 00 00 00       	push   $0xf8
80103030:	e8 b3 ff ff ff       	call   80102fe8 <lapicw>
80103035:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103038:	68 20 00 02 00       	push   $0x20020
8010303d:	68 c8 00 00 00       	push   $0xc8
80103042:	e8 a1 ff ff ff       	call   80102fe8 <lapicw>
80103047:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
8010304a:	68 80 96 98 00       	push   $0x989680
8010304f:	68 e0 00 00 00       	push   $0xe0
80103054:	e8 8f ff ff ff       	call   80102fe8 <lapicw>
80103059:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010305c:	68 00 00 01 00       	push   $0x10000
80103061:	68 d4 00 00 00       	push   $0xd4
80103066:	e8 7d ff ff ff       	call   80102fe8 <lapicw>
8010306b:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
8010306e:	68 00 00 01 00       	push   $0x10000
80103073:	68 d8 00 00 00       	push   $0xd8
80103078:	e8 6b ff ff ff       	call   80102fe8 <lapicw>
8010307d:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103080:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103085:	83 c0 30             	add    $0x30,%eax
80103088:	8b 00                	mov    (%eax),%eax
8010308a:	c1 e8 10             	shr    $0x10,%eax
8010308d:	0f b6 c0             	movzbl %al,%eax
80103090:	83 f8 03             	cmp    $0x3,%eax
80103093:	76 12                	jbe    801030a7 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80103095:	68 00 00 01 00       	push   $0x10000
8010309a:	68 d0 00 00 00       	push   $0xd0
8010309f:	e8 44 ff ff ff       	call   80102fe8 <lapicw>
801030a4:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801030a7:	6a 33                	push   $0x33
801030a9:	68 dc 00 00 00       	push   $0xdc
801030ae:	e8 35 ff ff ff       	call   80102fe8 <lapicw>
801030b3:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801030b6:	6a 00                	push   $0x0
801030b8:	68 a0 00 00 00       	push   $0xa0
801030bd:	e8 26 ff ff ff       	call   80102fe8 <lapicw>
801030c2:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801030c5:	6a 00                	push   $0x0
801030c7:	68 a0 00 00 00       	push   $0xa0
801030cc:	e8 17 ff ff ff       	call   80102fe8 <lapicw>
801030d1:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801030d4:	6a 00                	push   $0x0
801030d6:	6a 2c                	push   $0x2c
801030d8:	e8 0b ff ff ff       	call   80102fe8 <lapicw>
801030dd:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801030e0:	6a 00                	push   $0x0
801030e2:	68 c4 00 00 00       	push   $0xc4
801030e7:	e8 fc fe ff ff       	call   80102fe8 <lapicw>
801030ec:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801030ef:	68 00 85 08 00       	push   $0x88500
801030f4:	68 c0 00 00 00       	push   $0xc0
801030f9:	e8 ea fe ff ff       	call   80102fe8 <lapicw>
801030fe:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103101:	90                   	nop
80103102:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103107:	05 00 03 00 00       	add    $0x300,%eax
8010310c:	8b 00                	mov    (%eax),%eax
8010310e:	25 00 10 00 00       	and    $0x1000,%eax
80103113:	85 c0                	test   %eax,%eax
80103115:	75 eb                	jne    80103102 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103117:	6a 00                	push   $0x0
80103119:	6a 20                	push   $0x20
8010311b:	e8 c8 fe ff ff       	call   80102fe8 <lapicw>
80103120:	83 c4 08             	add    $0x8,%esp
80103123:	eb 01                	jmp    80103126 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103125:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103126:	c9                   	leave  
80103127:	c3                   	ret    

80103128 <cpunum>:

int
cpunum(void)
{
80103128:	55                   	push   %ebp
80103129:	89 e5                	mov    %esp,%ebp
8010312b:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010312e:	e8 a5 fe ff ff       	call   80102fd8 <readeflags>
80103133:	25 00 02 00 00       	and    $0x200,%eax
80103138:	85 c0                	test   %eax,%eax
8010313a:	74 26                	je     80103162 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010313c:	a1 80 c6 10 80       	mov    0x8010c680,%eax
80103141:	8d 50 01             	lea    0x1(%eax),%edx
80103144:	89 15 80 c6 10 80    	mov    %edx,0x8010c680
8010314a:	85 c0                	test   %eax,%eax
8010314c:	75 14                	jne    80103162 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010314e:	8b 45 04             	mov    0x4(%ebp),%eax
80103151:	83 ec 08             	sub    $0x8,%esp
80103154:	50                   	push   %eax
80103155:	68 c8 8f 10 80       	push   $0x80108fc8
8010315a:	e8 67 d2 ff ff       	call   801003c6 <cprintf>
8010315f:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103162:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103167:	85 c0                	test   %eax,%eax
80103169:	74 0f                	je     8010317a <cpunum+0x52>
    return lapic[ID]>>24;
8010316b:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103170:	83 c0 20             	add    $0x20,%eax
80103173:	8b 00                	mov    (%eax),%eax
80103175:	c1 e8 18             	shr    $0x18,%eax
80103178:	eb 05                	jmp    8010317f <cpunum+0x57>
  return 0;
8010317a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010317f:	c9                   	leave  
80103180:	c3                   	ret    

80103181 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103181:	55                   	push   %ebp
80103182:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103184:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103189:	85 c0                	test   %eax,%eax
8010318b:	74 0c                	je     80103199 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010318d:	6a 00                	push   $0x0
8010318f:	6a 2c                	push   $0x2c
80103191:	e8 52 fe ff ff       	call   80102fe8 <lapicw>
80103196:	83 c4 08             	add    $0x8,%esp
}
80103199:	90                   	nop
8010319a:	c9                   	leave  
8010319b:	c3                   	ret    

8010319c <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010319c:	55                   	push   %ebp
8010319d:	89 e5                	mov    %esp,%ebp
}
8010319f:	90                   	nop
801031a0:	5d                   	pop    %ebp
801031a1:	c3                   	ret    

801031a2 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031a2:	55                   	push   %ebp
801031a3:	89 e5                	mov    %esp,%ebp
801031a5:	83 ec 14             	sub    $0x14,%esp
801031a8:	8b 45 08             	mov    0x8(%ebp),%eax
801031ab:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801031ae:	6a 0f                	push   $0xf
801031b0:	6a 70                	push   $0x70
801031b2:	e8 02 fe ff ff       	call   80102fb9 <outb>
801031b7:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801031ba:	6a 0a                	push   $0xa
801031bc:	6a 71                	push   $0x71
801031be:	e8 f6 fd ff ff       	call   80102fb9 <outb>
801031c3:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801031c6:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801031cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031d0:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801031d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031d8:	83 c0 02             	add    $0x2,%eax
801031db:	8b 55 0c             	mov    0xc(%ebp),%edx
801031de:	c1 ea 04             	shr    $0x4,%edx
801031e1:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031e4:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801031e8:	c1 e0 18             	shl    $0x18,%eax
801031eb:	50                   	push   %eax
801031ec:	68 c4 00 00 00       	push   $0xc4
801031f1:	e8 f2 fd ff ff       	call   80102fe8 <lapicw>
801031f6:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801031f9:	68 00 c5 00 00       	push   $0xc500
801031fe:	68 c0 00 00 00       	push   $0xc0
80103203:	e8 e0 fd ff ff       	call   80102fe8 <lapicw>
80103208:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010320b:	68 c8 00 00 00       	push   $0xc8
80103210:	e8 87 ff ff ff       	call   8010319c <microdelay>
80103215:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103218:	68 00 85 00 00       	push   $0x8500
8010321d:	68 c0 00 00 00       	push   $0xc0
80103222:	e8 c1 fd ff ff       	call   80102fe8 <lapicw>
80103227:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010322a:	6a 64                	push   $0x64
8010322c:	e8 6b ff ff ff       	call   8010319c <microdelay>
80103231:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010323b:	eb 3d                	jmp    8010327a <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010323d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103241:	c1 e0 18             	shl    $0x18,%eax
80103244:	50                   	push   %eax
80103245:	68 c4 00 00 00       	push   $0xc4
8010324a:	e8 99 fd ff ff       	call   80102fe8 <lapicw>
8010324f:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103252:	8b 45 0c             	mov    0xc(%ebp),%eax
80103255:	c1 e8 0c             	shr    $0xc,%eax
80103258:	80 cc 06             	or     $0x6,%ah
8010325b:	50                   	push   %eax
8010325c:	68 c0 00 00 00       	push   $0xc0
80103261:	e8 82 fd ff ff       	call   80102fe8 <lapicw>
80103266:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103269:	68 c8 00 00 00       	push   $0xc8
8010326e:	e8 29 ff ff ff       	call   8010319c <microdelay>
80103273:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103276:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010327a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010327e:	7e bd                	jle    8010323d <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103280:	90                   	nop
80103281:	c9                   	leave  
80103282:	c3                   	ret    

80103283 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103283:	55                   	push   %ebp
80103284:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103286:	8b 45 08             	mov    0x8(%ebp),%eax
80103289:	0f b6 c0             	movzbl %al,%eax
8010328c:	50                   	push   %eax
8010328d:	6a 70                	push   $0x70
8010328f:	e8 25 fd ff ff       	call   80102fb9 <outb>
80103294:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103297:	68 c8 00 00 00       	push   $0xc8
8010329c:	e8 fb fe ff ff       	call   8010319c <microdelay>
801032a1:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801032a4:	6a 71                	push   $0x71
801032a6:	e8 f1 fc ff ff       	call   80102f9c <inb>
801032ab:	83 c4 04             	add    $0x4,%esp
801032ae:	0f b6 c0             	movzbl %al,%eax
}
801032b1:	c9                   	leave  
801032b2:	c3                   	ret    

801032b3 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801032b3:	55                   	push   %ebp
801032b4:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801032b6:	6a 00                	push   $0x0
801032b8:	e8 c6 ff ff ff       	call   80103283 <cmos_read>
801032bd:	83 c4 04             	add    $0x4,%esp
801032c0:	89 c2                	mov    %eax,%edx
801032c2:	8b 45 08             	mov    0x8(%ebp),%eax
801032c5:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801032c7:	6a 02                	push   $0x2
801032c9:	e8 b5 ff ff ff       	call   80103283 <cmos_read>
801032ce:	83 c4 04             	add    $0x4,%esp
801032d1:	89 c2                	mov    %eax,%edx
801032d3:	8b 45 08             	mov    0x8(%ebp),%eax
801032d6:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801032d9:	6a 04                	push   $0x4
801032db:	e8 a3 ff ff ff       	call   80103283 <cmos_read>
801032e0:	83 c4 04             	add    $0x4,%esp
801032e3:	89 c2                	mov    %eax,%edx
801032e5:	8b 45 08             	mov    0x8(%ebp),%eax
801032e8:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801032eb:	6a 07                	push   $0x7
801032ed:	e8 91 ff ff ff       	call   80103283 <cmos_read>
801032f2:	83 c4 04             	add    $0x4,%esp
801032f5:	89 c2                	mov    %eax,%edx
801032f7:	8b 45 08             	mov    0x8(%ebp),%eax
801032fa:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801032fd:	6a 08                	push   $0x8
801032ff:	e8 7f ff ff ff       	call   80103283 <cmos_read>
80103304:	83 c4 04             	add    $0x4,%esp
80103307:	89 c2                	mov    %eax,%edx
80103309:	8b 45 08             	mov    0x8(%ebp),%eax
8010330c:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010330f:	6a 09                	push   $0x9
80103311:	e8 6d ff ff ff       	call   80103283 <cmos_read>
80103316:	83 c4 04             	add    $0x4,%esp
80103319:	89 c2                	mov    %eax,%edx
8010331b:	8b 45 08             	mov    0x8(%ebp),%eax
8010331e:	89 50 14             	mov    %edx,0x14(%eax)
}
80103321:	90                   	nop
80103322:	c9                   	leave  
80103323:	c3                   	ret    

80103324 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103324:	55                   	push   %ebp
80103325:	89 e5                	mov    %esp,%ebp
80103327:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010332a:	6a 0b                	push   $0xb
8010332c:	e8 52 ff ff ff       	call   80103283 <cmos_read>
80103331:	83 c4 04             	add    $0x4,%esp
80103334:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010333a:	83 e0 04             	and    $0x4,%eax
8010333d:	85 c0                	test   %eax,%eax
8010333f:	0f 94 c0             	sete   %al
80103342:	0f b6 c0             	movzbl %al,%eax
80103345:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103348:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010334b:	50                   	push   %eax
8010334c:	e8 62 ff ff ff       	call   801032b3 <fill_rtcdate>
80103351:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103354:	6a 0a                	push   $0xa
80103356:	e8 28 ff ff ff       	call   80103283 <cmos_read>
8010335b:	83 c4 04             	add    $0x4,%esp
8010335e:	25 80 00 00 00       	and    $0x80,%eax
80103363:	85 c0                	test   %eax,%eax
80103365:	75 27                	jne    8010338e <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103367:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010336a:	50                   	push   %eax
8010336b:	e8 43 ff ff ff       	call   801032b3 <fill_rtcdate>
80103370:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103373:	83 ec 04             	sub    $0x4,%esp
80103376:	6a 18                	push   $0x18
80103378:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010337b:	50                   	push   %eax
8010337c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010337f:	50                   	push   %eax
80103380:	e8 73 24 00 00       	call   801057f8 <memcmp>
80103385:	83 c4 10             	add    $0x10,%esp
80103388:	85 c0                	test   %eax,%eax
8010338a:	74 05                	je     80103391 <cmostime+0x6d>
8010338c:	eb ba                	jmp    80103348 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
8010338e:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010338f:	eb b7                	jmp    80103348 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103391:	90                   	nop
  }

  // convert
  if (bcd) {
80103392:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103396:	0f 84 b4 00 00 00    	je     80103450 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010339c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010339f:	c1 e8 04             	shr    $0x4,%eax
801033a2:	89 c2                	mov    %eax,%edx
801033a4:	89 d0                	mov    %edx,%eax
801033a6:	c1 e0 02             	shl    $0x2,%eax
801033a9:	01 d0                	add    %edx,%eax
801033ab:	01 c0                	add    %eax,%eax
801033ad:	89 c2                	mov    %eax,%edx
801033af:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033b2:	83 e0 0f             	and    $0xf,%eax
801033b5:	01 d0                	add    %edx,%eax
801033b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801033ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033bd:	c1 e8 04             	shr    $0x4,%eax
801033c0:	89 c2                	mov    %eax,%edx
801033c2:	89 d0                	mov    %edx,%eax
801033c4:	c1 e0 02             	shl    $0x2,%eax
801033c7:	01 d0                	add    %edx,%eax
801033c9:	01 c0                	add    %eax,%eax
801033cb:	89 c2                	mov    %eax,%edx
801033cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033d0:	83 e0 0f             	and    $0xf,%eax
801033d3:	01 d0                	add    %edx,%eax
801033d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801033d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033db:	c1 e8 04             	shr    $0x4,%eax
801033de:	89 c2                	mov    %eax,%edx
801033e0:	89 d0                	mov    %edx,%eax
801033e2:	c1 e0 02             	shl    $0x2,%eax
801033e5:	01 d0                	add    %edx,%eax
801033e7:	01 c0                	add    %eax,%eax
801033e9:	89 c2                	mov    %eax,%edx
801033eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033ee:	83 e0 0f             	and    $0xf,%eax
801033f1:	01 d0                	add    %edx,%eax
801033f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801033f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033f9:	c1 e8 04             	shr    $0x4,%eax
801033fc:	89 c2                	mov    %eax,%edx
801033fe:	89 d0                	mov    %edx,%eax
80103400:	c1 e0 02             	shl    $0x2,%eax
80103403:	01 d0                	add    %edx,%eax
80103405:	01 c0                	add    %eax,%eax
80103407:	89 c2                	mov    %eax,%edx
80103409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010340c:	83 e0 0f             	and    $0xf,%eax
8010340f:	01 d0                	add    %edx,%eax
80103411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103414:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103417:	c1 e8 04             	shr    $0x4,%eax
8010341a:	89 c2                	mov    %eax,%edx
8010341c:	89 d0                	mov    %edx,%eax
8010341e:	c1 e0 02             	shl    $0x2,%eax
80103421:	01 d0                	add    %edx,%eax
80103423:	01 c0                	add    %eax,%eax
80103425:	89 c2                	mov    %eax,%edx
80103427:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010342a:	83 e0 0f             	and    $0xf,%eax
8010342d:	01 d0                	add    %edx,%eax
8010342f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103432:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103435:	c1 e8 04             	shr    $0x4,%eax
80103438:	89 c2                	mov    %eax,%edx
8010343a:	89 d0                	mov    %edx,%eax
8010343c:	c1 e0 02             	shl    $0x2,%eax
8010343f:	01 d0                	add    %edx,%eax
80103441:	01 c0                	add    %eax,%eax
80103443:	89 c2                	mov    %eax,%edx
80103445:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103448:	83 e0 0f             	and    $0xf,%eax
8010344b:	01 d0                	add    %edx,%eax
8010344d:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103450:	8b 45 08             	mov    0x8(%ebp),%eax
80103453:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103456:	89 10                	mov    %edx,(%eax)
80103458:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010345b:	89 50 04             	mov    %edx,0x4(%eax)
8010345e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103461:	89 50 08             	mov    %edx,0x8(%eax)
80103464:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103467:	89 50 0c             	mov    %edx,0xc(%eax)
8010346a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010346d:	89 50 10             	mov    %edx,0x10(%eax)
80103470:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103473:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103476:	8b 45 08             	mov    0x8(%ebp),%eax
80103479:	8b 40 14             	mov    0x14(%eax),%eax
8010347c:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103482:	8b 45 08             	mov    0x8(%ebp),%eax
80103485:	89 50 14             	mov    %edx,0x14(%eax)
}
80103488:	90                   	nop
80103489:	c9                   	leave  
8010348a:	c3                   	ret    

8010348b <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010348b:	55                   	push   %ebp
8010348c:	89 e5                	mov    %esp,%ebp
8010348e:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103491:	83 ec 08             	sub    $0x8,%esp
80103494:	68 f4 8f 10 80       	push   $0x80108ff4
80103499:	68 a0 32 11 80       	push   $0x801132a0
8010349e:	e8 69 20 00 00       	call   8010550c <initlock>
801034a3:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801034a6:	83 ec 08             	sub    $0x8,%esp
801034a9:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034ac:	50                   	push   %eax
801034ad:	ff 75 08             	pushl  0x8(%ebp)
801034b0:	e8 b3 df ff ff       	call   80101468 <readsb>
801034b5:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801034b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034bb:	a3 d4 32 11 80       	mov    %eax,0x801132d4
  log.size = sb.nlog;
801034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801034c3:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  log.dev = dev;
801034c8:	8b 45 08             	mov    0x8(%ebp),%eax
801034cb:	a3 e4 32 11 80       	mov    %eax,0x801132e4
  recover_from_log();
801034d0:	e8 b2 01 00 00       	call   80103687 <recover_from_log>
}
801034d5:	90                   	nop
801034d6:	c9                   	leave  
801034d7:	c3                   	ret    

801034d8 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801034d8:	55                   	push   %ebp
801034d9:	89 e5                	mov    %esp,%ebp
801034db:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034e5:	e9 95 00 00 00       	jmp    8010357f <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801034ea:	8b 15 d4 32 11 80    	mov    0x801132d4,%edx
801034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f3:	01 d0                	add    %edx,%eax
801034f5:	83 c0 01             	add    $0x1,%eax
801034f8:	89 c2                	mov    %eax,%edx
801034fa:	a1 e4 32 11 80       	mov    0x801132e4,%eax
801034ff:	83 ec 08             	sub    $0x8,%esp
80103502:	52                   	push   %edx
80103503:	50                   	push   %eax
80103504:	e8 ad cc ff ff       	call   801001b6 <bread>
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103512:	83 c0 10             	add    $0x10,%eax
80103515:	8b 04 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%eax
8010351c:	89 c2                	mov    %eax,%edx
8010351e:	a1 e4 32 11 80       	mov    0x801132e4,%eax
80103523:	83 ec 08             	sub    $0x8,%esp
80103526:	52                   	push   %edx
80103527:	50                   	push   %eax
80103528:	e8 89 cc ff ff       	call   801001b6 <bread>
8010352d:	83 c4 10             	add    $0x10,%esp
80103530:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103533:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103536:	8d 50 18             	lea    0x18(%eax),%edx
80103539:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010353c:	83 c0 18             	add    $0x18,%eax
8010353f:	83 ec 04             	sub    $0x4,%esp
80103542:	68 00 02 00 00       	push   $0x200
80103547:	52                   	push   %edx
80103548:	50                   	push   %eax
80103549:	e8 02 23 00 00       	call   80105850 <memmove>
8010354e:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103551:	83 ec 0c             	sub    $0xc,%esp
80103554:	ff 75 ec             	pushl  -0x14(%ebp)
80103557:	e8 93 cc ff ff       	call   801001ef <bwrite>
8010355c:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010355f:	83 ec 0c             	sub    $0xc,%esp
80103562:	ff 75 f0             	pushl  -0x10(%ebp)
80103565:	e8 c4 cc ff ff       	call   8010022e <brelse>
8010356a:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010356d:	83 ec 0c             	sub    $0xc,%esp
80103570:	ff 75 ec             	pushl  -0x14(%ebp)
80103573:	e8 b6 cc ff ff       	call   8010022e <brelse>
80103578:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010357b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010357f:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103584:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103587:	0f 8f 5d ff ff ff    	jg     801034ea <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010358d:	90                   	nop
8010358e:	c9                   	leave  
8010358f:	c3                   	ret    

80103590 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103596:	a1 d4 32 11 80       	mov    0x801132d4,%eax
8010359b:	89 c2                	mov    %eax,%edx
8010359d:	a1 e4 32 11 80       	mov    0x801132e4,%eax
801035a2:	83 ec 08             	sub    $0x8,%esp
801035a5:	52                   	push   %edx
801035a6:	50                   	push   %eax
801035a7:	e8 0a cc ff ff       	call   801001b6 <bread>
801035ac:	83 c4 10             	add    $0x10,%esp
801035af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801035b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035b5:	83 c0 18             	add    $0x18,%eax
801035b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801035bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035be:	8b 00                	mov    (%eax),%eax
801035c0:	a3 e8 32 11 80       	mov    %eax,0x801132e8
  for (i = 0; i < log.lh.n; i++) {
801035c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035cc:	eb 1b                	jmp    801035e9 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801035ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035d4:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801035d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035db:	83 c2 10             	add    $0x10,%edx
801035de:	89 04 95 ac 32 11 80 	mov    %eax,-0x7feecd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801035e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035e9:	a1 e8 32 11 80       	mov    0x801132e8,%eax
801035ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035f1:	7f db                	jg     801035ce <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801035f3:	83 ec 0c             	sub    $0xc,%esp
801035f6:	ff 75 f0             	pushl  -0x10(%ebp)
801035f9:	e8 30 cc ff ff       	call   8010022e <brelse>
801035fe:	83 c4 10             	add    $0x10,%esp
}
80103601:	90                   	nop
80103602:	c9                   	leave  
80103603:	c3                   	ret    

80103604 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010360a:	a1 d4 32 11 80       	mov    0x801132d4,%eax
8010360f:	89 c2                	mov    %eax,%edx
80103611:	a1 e4 32 11 80       	mov    0x801132e4,%eax
80103616:	83 ec 08             	sub    $0x8,%esp
80103619:	52                   	push   %edx
8010361a:	50                   	push   %eax
8010361b:	e8 96 cb ff ff       	call   801001b6 <bread>
80103620:	83 c4 10             	add    $0x10,%esp
80103623:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103626:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103629:	83 c0 18             	add    $0x18,%eax
8010362c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010362f:	8b 15 e8 32 11 80    	mov    0x801132e8,%edx
80103635:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103638:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010363a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103641:	eb 1b                	jmp    8010365e <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103646:	83 c0 10             	add    $0x10,%eax
80103649:	8b 0c 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%ecx
80103650:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103653:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103656:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010365a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010365e:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103663:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103666:	7f db                	jg     80103643 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	ff 75 f0             	pushl  -0x10(%ebp)
8010366e:	e8 7c cb ff ff       	call   801001ef <bwrite>
80103673:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	ff 75 f0             	pushl  -0x10(%ebp)
8010367c:	e8 ad cb ff ff       	call   8010022e <brelse>
80103681:	83 c4 10             	add    $0x10,%esp
}
80103684:	90                   	nop
80103685:	c9                   	leave  
80103686:	c3                   	ret    

80103687 <recover_from_log>:

static void
recover_from_log(void)
{
80103687:	55                   	push   %ebp
80103688:	89 e5                	mov    %esp,%ebp
8010368a:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010368d:	e8 fe fe ff ff       	call   80103590 <read_head>
  install_trans(); // if committed, copy from log to disk
80103692:	e8 41 fe ff ff       	call   801034d8 <install_trans>
  log.lh.n = 0;
80103697:	c7 05 e8 32 11 80 00 	movl   $0x0,0x801132e8
8010369e:	00 00 00 
  write_head(); // clear the log
801036a1:	e8 5e ff ff ff       	call   80103604 <write_head>
}
801036a6:	90                   	nop
801036a7:	c9                   	leave  
801036a8:	c3                   	ret    

801036a9 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801036a9:	55                   	push   %ebp
801036aa:	89 e5                	mov    %esp,%ebp
801036ac:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801036af:	83 ec 0c             	sub    $0xc,%esp
801036b2:	68 a0 32 11 80       	push   $0x801132a0
801036b7:	e8 72 1e 00 00       	call   8010552e <acquire>
801036bc:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801036bf:	a1 e0 32 11 80       	mov    0x801132e0,%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	74 17                	je     801036df <begin_op+0x36>
      sleep(&log, &log.lock);
801036c8:	83 ec 08             	sub    $0x8,%esp
801036cb:	68 a0 32 11 80       	push   $0x801132a0
801036d0:	68 a0 32 11 80       	push   $0x801132a0
801036d5:	e8 bd 18 00 00       	call   80104f97 <sleep>
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb e0                	jmp    801036bf <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801036df:	8b 0d e8 32 11 80    	mov    0x801132e8,%ecx
801036e5:	a1 dc 32 11 80       	mov    0x801132dc,%eax
801036ea:	8d 50 01             	lea    0x1(%eax),%edx
801036ed:	89 d0                	mov    %edx,%eax
801036ef:	c1 e0 02             	shl    $0x2,%eax
801036f2:	01 d0                	add    %edx,%eax
801036f4:	01 c0                	add    %eax,%eax
801036f6:	01 c8                	add    %ecx,%eax
801036f8:	83 f8 1e             	cmp    $0x1e,%eax
801036fb:	7e 17                	jle    80103714 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801036fd:	83 ec 08             	sub    $0x8,%esp
80103700:	68 a0 32 11 80       	push   $0x801132a0
80103705:	68 a0 32 11 80       	push   $0x801132a0
8010370a:	e8 88 18 00 00       	call   80104f97 <sleep>
8010370f:	83 c4 10             	add    $0x10,%esp
80103712:	eb ab                	jmp    801036bf <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103714:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80103719:	83 c0 01             	add    $0x1,%eax
8010371c:	a3 dc 32 11 80       	mov    %eax,0x801132dc
      release(&log.lock);
80103721:	83 ec 0c             	sub    $0xc,%esp
80103724:	68 a0 32 11 80       	push   $0x801132a0
80103729:	e8 67 1e 00 00       	call   80105595 <release>
8010372e:	83 c4 10             	add    $0x10,%esp
      break;
80103731:	90                   	nop
    }
  }
}
80103732:	90                   	nop
80103733:	c9                   	leave  
80103734:	c3                   	ret    

80103735 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103735:	55                   	push   %ebp
80103736:	89 e5                	mov    %esp,%ebp
80103738:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010373b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103742:	83 ec 0c             	sub    $0xc,%esp
80103745:	68 a0 32 11 80       	push   $0x801132a0
8010374a:	e8 df 1d 00 00       	call   8010552e <acquire>
8010374f:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103752:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80103757:	83 e8 01             	sub    $0x1,%eax
8010375a:	a3 dc 32 11 80       	mov    %eax,0x801132dc
  if(log.committing)
8010375f:	a1 e0 32 11 80       	mov    0x801132e0,%eax
80103764:	85 c0                	test   %eax,%eax
80103766:	74 0d                	je     80103775 <end_op+0x40>
    panic("log.committing");
80103768:	83 ec 0c             	sub    $0xc,%esp
8010376b:	68 f8 8f 10 80       	push   $0x80108ff8
80103770:	e8 f1 cd ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103775:	a1 dc 32 11 80       	mov    0x801132dc,%eax
8010377a:	85 c0                	test   %eax,%eax
8010377c:	75 13                	jne    80103791 <end_op+0x5c>
    do_commit = 1;
8010377e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103785:	c7 05 e0 32 11 80 01 	movl   $0x1,0x801132e0
8010378c:	00 00 00 
8010378f:	eb 10                	jmp    801037a1 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103791:	83 ec 0c             	sub    $0xc,%esp
80103794:	68 a0 32 11 80       	push   $0x801132a0
80103799:	e8 e7 18 00 00       	call   80105085 <wakeup>
8010379e:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801037a1:	83 ec 0c             	sub    $0xc,%esp
801037a4:	68 a0 32 11 80       	push   $0x801132a0
801037a9:	e8 e7 1d 00 00       	call   80105595 <release>
801037ae:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801037b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037b5:	74 3f                	je     801037f6 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801037b7:	e8 f5 00 00 00       	call   801038b1 <commit>
    acquire(&log.lock);
801037bc:	83 ec 0c             	sub    $0xc,%esp
801037bf:	68 a0 32 11 80       	push   $0x801132a0
801037c4:	e8 65 1d 00 00       	call   8010552e <acquire>
801037c9:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801037cc:	c7 05 e0 32 11 80 00 	movl   $0x0,0x801132e0
801037d3:	00 00 00 
    wakeup(&log);
801037d6:	83 ec 0c             	sub    $0xc,%esp
801037d9:	68 a0 32 11 80       	push   $0x801132a0
801037de:	e8 a2 18 00 00       	call   80105085 <wakeup>
801037e3:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801037e6:	83 ec 0c             	sub    $0xc,%esp
801037e9:	68 a0 32 11 80       	push   $0x801132a0
801037ee:	e8 a2 1d 00 00       	call   80105595 <release>
801037f3:	83 c4 10             	add    $0x10,%esp
  }
}
801037f6:	90                   	nop
801037f7:	c9                   	leave  
801037f8:	c3                   	ret    

801037f9 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801037f9:	55                   	push   %ebp
801037fa:	89 e5                	mov    %esp,%ebp
801037fc:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103806:	e9 95 00 00 00       	jmp    801038a0 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010380b:	8b 15 d4 32 11 80    	mov    0x801132d4,%edx
80103811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103814:	01 d0                	add    %edx,%eax
80103816:	83 c0 01             	add    $0x1,%eax
80103819:	89 c2                	mov    %eax,%edx
8010381b:	a1 e4 32 11 80       	mov    0x801132e4,%eax
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	52                   	push   %edx
80103824:	50                   	push   %eax
80103825:	e8 8c c9 ff ff       	call   801001b6 <bread>
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103833:	83 c0 10             	add    $0x10,%eax
80103836:	8b 04 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%eax
8010383d:	89 c2                	mov    %eax,%edx
8010383f:	a1 e4 32 11 80       	mov    0x801132e4,%eax
80103844:	83 ec 08             	sub    $0x8,%esp
80103847:	52                   	push   %edx
80103848:	50                   	push   %eax
80103849:	e8 68 c9 ff ff       	call   801001b6 <bread>
8010384e:	83 c4 10             	add    $0x10,%esp
80103851:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103854:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103857:	8d 50 18             	lea    0x18(%eax),%edx
8010385a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010385d:	83 c0 18             	add    $0x18,%eax
80103860:	83 ec 04             	sub    $0x4,%esp
80103863:	68 00 02 00 00       	push   $0x200
80103868:	52                   	push   %edx
80103869:	50                   	push   %eax
8010386a:	e8 e1 1f 00 00       	call   80105850 <memmove>
8010386f:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103872:	83 ec 0c             	sub    $0xc,%esp
80103875:	ff 75 f0             	pushl  -0x10(%ebp)
80103878:	e8 72 c9 ff ff       	call   801001ef <bwrite>
8010387d:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	ff 75 ec             	pushl  -0x14(%ebp)
80103886:	e8 a3 c9 ff ff       	call   8010022e <brelse>
8010388b:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010388e:	83 ec 0c             	sub    $0xc,%esp
80103891:	ff 75 f0             	pushl  -0x10(%ebp)
80103894:	e8 95 c9 ff ff       	call   8010022e <brelse>
80103899:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010389c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038a0:	a1 e8 32 11 80       	mov    0x801132e8,%eax
801038a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038a8:	0f 8f 5d ff ff ff    	jg     8010380b <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801038ae:	90                   	nop
801038af:	c9                   	leave  
801038b0:	c3                   	ret    

801038b1 <commit>:

static void
commit()
{
801038b1:	55                   	push   %ebp
801038b2:	89 e5                	mov    %esp,%ebp
801038b4:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801038b7:	a1 e8 32 11 80       	mov    0x801132e8,%eax
801038bc:	85 c0                	test   %eax,%eax
801038be:	7e 1e                	jle    801038de <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801038c0:	e8 34 ff ff ff       	call   801037f9 <write_log>
    write_head();    // Write header to disk -- the real commit
801038c5:	e8 3a fd ff ff       	call   80103604 <write_head>
    install_trans(); // Now install writes to home locations
801038ca:	e8 09 fc ff ff       	call   801034d8 <install_trans>
    log.lh.n = 0; 
801038cf:	c7 05 e8 32 11 80 00 	movl   $0x0,0x801132e8
801038d6:	00 00 00 
    write_head();    // Erase the transaction from the log
801038d9:	e8 26 fd ff ff       	call   80103604 <write_head>
  }
}
801038de:	90                   	nop
801038df:	c9                   	leave  
801038e0:	c3                   	ret    

801038e1 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801038e1:	55                   	push   %ebp
801038e2:	89 e5                	mov    %esp,%ebp
801038e4:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038e7:	a1 e8 32 11 80       	mov    0x801132e8,%eax
801038ec:	83 f8 1d             	cmp    $0x1d,%eax
801038ef:	7f 12                	jg     80103903 <log_write+0x22>
801038f1:	a1 e8 32 11 80       	mov    0x801132e8,%eax
801038f6:	8b 15 d8 32 11 80    	mov    0x801132d8,%edx
801038fc:	83 ea 01             	sub    $0x1,%edx
801038ff:	39 d0                	cmp    %edx,%eax
80103901:	7c 0d                	jl     80103910 <log_write+0x2f>
    panic("too big a transaction");
80103903:	83 ec 0c             	sub    $0xc,%esp
80103906:	68 07 90 10 80       	push   $0x80109007
8010390b:	e8 56 cc ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103910:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80103915:	85 c0                	test   %eax,%eax
80103917:	7f 0d                	jg     80103926 <log_write+0x45>
    panic("log_write outside of trans");
80103919:	83 ec 0c             	sub    $0xc,%esp
8010391c:	68 1d 90 10 80       	push   $0x8010901d
80103921:	e8 40 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103926:	83 ec 0c             	sub    $0xc,%esp
80103929:	68 a0 32 11 80       	push   $0x801132a0
8010392e:	e8 fb 1b 00 00       	call   8010552e <acquire>
80103933:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010393d:	eb 1d                	jmp    8010395c <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103942:	83 c0 10             	add    $0x10,%eax
80103945:	8b 04 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%eax
8010394c:	89 c2                	mov    %eax,%edx
8010394e:	8b 45 08             	mov    0x8(%ebp),%eax
80103951:	8b 40 08             	mov    0x8(%eax),%eax
80103954:	39 c2                	cmp    %eax,%edx
80103956:	74 10                	je     80103968 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103958:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010395c:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103961:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103964:	7f d9                	jg     8010393f <log_write+0x5e>
80103966:	eb 01                	jmp    80103969 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103968:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103969:	8b 45 08             	mov    0x8(%ebp),%eax
8010396c:	8b 40 08             	mov    0x8(%eax),%eax
8010396f:	89 c2                	mov    %eax,%edx
80103971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103974:	83 c0 10             	add    $0x10,%eax
80103977:	89 14 85 ac 32 11 80 	mov    %edx,-0x7feecd54(,%eax,4)
  if (i == log.lh.n)
8010397e:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103983:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103986:	75 0d                	jne    80103995 <log_write+0xb4>
    log.lh.n++;
80103988:	a1 e8 32 11 80       	mov    0x801132e8,%eax
8010398d:	83 c0 01             	add    $0x1,%eax
80103990:	a3 e8 32 11 80       	mov    %eax,0x801132e8
  b->flags |= B_DIRTY; // prevent eviction
80103995:	8b 45 08             	mov    0x8(%ebp),%eax
80103998:	8b 00                	mov    (%eax),%eax
8010399a:	83 c8 04             	or     $0x4,%eax
8010399d:	89 c2                	mov    %eax,%edx
8010399f:	8b 45 08             	mov    0x8(%ebp),%eax
801039a2:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801039a4:	83 ec 0c             	sub    $0xc,%esp
801039a7:	68 a0 32 11 80       	push   $0x801132a0
801039ac:	e8 e4 1b 00 00       	call   80105595 <release>
801039b1:	83 c4 10             	add    $0x10,%esp
}
801039b4:	90                   	nop
801039b5:	c9                   	leave  
801039b6:	c3                   	ret    

801039b7 <v2p>:
801039b7:	55                   	push   %ebp
801039b8:	89 e5                	mov    %esp,%ebp
801039ba:	8b 45 08             	mov    0x8(%ebp),%eax
801039bd:	05 00 00 00 80       	add    $0x80000000,%eax
801039c2:	5d                   	pop    %ebp
801039c3:	c3                   	ret    

801039c4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801039c4:	55                   	push   %ebp
801039c5:	89 e5                	mov    %esp,%ebp
801039c7:	8b 45 08             	mov    0x8(%ebp),%eax
801039ca:	05 00 00 00 80       	add    $0x80000000,%eax
801039cf:	5d                   	pop    %ebp
801039d0:	c3                   	ret    

801039d1 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801039d1:	55                   	push   %ebp
801039d2:	89 e5                	mov    %esp,%ebp
801039d4:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801039d7:	8b 55 08             	mov    0x8(%ebp),%edx
801039da:	8b 45 0c             	mov    0xc(%ebp),%eax
801039dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
801039e0:	f0 87 02             	lock xchg %eax,(%edx)
801039e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801039e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801039e9:	c9                   	leave  
801039ea:	c3                   	ret    

801039eb <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801039eb:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801039ef:	83 e4 f0             	and    $0xfffffff0,%esp
801039f2:	ff 71 fc             	pushl  -0x4(%ecx)
801039f5:	55                   	push   %ebp
801039f6:	89 e5                	mov    %esp,%ebp
801039f8:	51                   	push   %ecx
801039f9:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801039fc:	83 ec 08             	sub    $0x8,%esp
801039ff:	68 00 00 40 80       	push   $0x80400000
80103a04:	68 7c 66 11 80       	push   $0x8011667c
80103a09:	e8 7d f2 ff ff       	call   80102c8b <kinit1>
80103a0e:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103a11:	e8 f0 4b 00 00       	call   80108606 <kvmalloc>
  mpinit();        // collect info about this machine
80103a16:	e8 43 04 00 00       	call   80103e5e <mpinit>
  lapicinit();
80103a1b:	e8 ea f5 ff ff       	call   8010300a <lapicinit>
  seginit();       // set up segments
80103a20:	e8 8a 45 00 00       	call   80107faf <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103a25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a2b:	0f b6 00             	movzbl (%eax),%eax
80103a2e:	0f b6 c0             	movzbl %al,%eax
80103a31:	83 ec 08             	sub    $0x8,%esp
80103a34:	50                   	push   %eax
80103a35:	68 38 90 10 80       	push   $0x80109038
80103a3a:	e8 87 c9 ff ff       	call   801003c6 <cprintf>
80103a3f:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103a42:	e8 6d 06 00 00       	call   801040b4 <picinit>
  ioapicinit();    // another interrupt controller
80103a47:	e8 34 f1 ff ff       	call   80102b80 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103a4c:	e8 c8 d0 ff ff       	call   80100b19 <consoleinit>
  uartinit();      // serial port
80103a51:	e8 b5 38 00 00       	call   8010730b <uartinit>
  pinit();         // process table
80103a56:	e8 56 0b 00 00       	call   801045b1 <pinit>
  tvinit();        // trap vectors
80103a5b:	e8 75 34 00 00       	call   80106ed5 <tvinit>
  binit();         // buffer cache
80103a60:	e8 cf c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a65:	e8 0b d5 ff ff       	call   80100f75 <fileinit>
  ideinit();       // disk
80103a6a:	e8 19 ed ff ff       	call   80102788 <ideinit>
  if(!ismp)
80103a6f:	a1 84 33 11 80       	mov    0x80113384,%eax
80103a74:	85 c0                	test   %eax,%eax
80103a76:	75 05                	jne    80103a7d <main+0x92>
    timerinit();   // uniprocessor timer
80103a78:	e8 b5 33 00 00       	call   80106e32 <timerinit>
  startothers();   // start other processors
80103a7d:	e8 7f 00 00 00       	call   80103b01 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a82:	83 ec 08             	sub    $0x8,%esp
80103a85:	68 00 00 00 8e       	push   $0x8e000000
80103a8a:	68 00 00 40 80       	push   $0x80400000
80103a8f:	e8 30 f2 ff ff       	call   80102cc4 <kinit2>
80103a94:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103a97:	e8 87 0c 00 00       	call   80104723 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103a9c:	e8 1a 00 00 00       	call   80103abb <mpmain>

80103aa1 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103aa1:	55                   	push   %ebp
80103aa2:	89 e5                	mov    %esp,%ebp
80103aa4:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103aa7:	e8 72 4b 00 00       	call   8010861e <switchkvm>
  seginit();
80103aac:	e8 fe 44 00 00       	call   80107faf <seginit>
  lapicinit();
80103ab1:	e8 54 f5 ff ff       	call   8010300a <lapicinit>
  mpmain();
80103ab6:	e8 00 00 00 00       	call   80103abb <mpmain>

80103abb <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103abb:	55                   	push   %ebp
80103abc:	89 e5                	mov    %esp,%ebp
80103abe:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103ac1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ac7:	0f b6 00             	movzbl (%eax),%eax
80103aca:	0f b6 c0             	movzbl %al,%eax
80103acd:	83 ec 08             	sub    $0x8,%esp
80103ad0:	50                   	push   %eax
80103ad1:	68 4f 90 10 80       	push   $0x8010904f
80103ad6:	e8 eb c8 ff ff       	call   801003c6 <cprintf>
80103adb:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103ade:	e8 68 35 00 00       	call   8010704b <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103ae3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ae9:	05 a8 00 00 00       	add    $0xa8,%eax
80103aee:	83 ec 08             	sub    $0x8,%esp
80103af1:	6a 01                	push   $0x1
80103af3:	50                   	push   %eax
80103af4:	e8 d8 fe ff ff       	call   801039d1 <xchg>
80103af9:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103afc:	e8 17 12 00 00       	call   80104d18 <scheduler>

80103b01 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b01:	55                   	push   %ebp
80103b02:	89 e5                	mov    %esp,%ebp
80103b04:	53                   	push   %ebx
80103b05:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103b08:	68 00 70 00 00       	push   $0x7000
80103b0d:	e8 b2 fe ff ff       	call   801039c4 <p2v>
80103b12:	83 c4 04             	add    $0x4,%esp
80103b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b18:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b1d:	83 ec 04             	sub    $0x4,%esp
80103b20:	50                   	push   %eax
80103b21:	68 4c c5 10 80       	push   $0x8010c54c
80103b26:	ff 75 f0             	pushl  -0x10(%ebp)
80103b29:	e8 22 1d 00 00       	call   80105850 <memmove>
80103b2e:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103b31:	c7 45 f4 a0 33 11 80 	movl   $0x801133a0,-0xc(%ebp)
80103b38:	e9 90 00 00 00       	jmp    80103bcd <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103b3d:	e8 e6 f5 ff ff       	call   80103128 <cpunum>
80103b42:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b48:	05 a0 33 11 80       	add    $0x801133a0,%eax
80103b4d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b50:	74 73                	je     80103bc5 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b52:	e8 6b f2 ff ff       	call   80102dc2 <kalloc>
80103b57:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5d:	83 e8 04             	sub    $0x4,%eax
80103b60:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b63:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b69:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6e:	83 e8 08             	sub    $0x8,%eax
80103b71:	c7 00 a1 3a 10 80    	movl   $0x80103aa1,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7a:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103b7d:	83 ec 0c             	sub    $0xc,%esp
80103b80:	68 00 b0 10 80       	push   $0x8010b000
80103b85:	e8 2d fe ff ff       	call   801039b7 <v2p>
80103b8a:	83 c4 10             	add    $0x10,%esp
80103b8d:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103b8f:	83 ec 0c             	sub    $0xc,%esp
80103b92:	ff 75 f0             	pushl  -0x10(%ebp)
80103b95:	e8 1d fe ff ff       	call   801039b7 <v2p>
80103b9a:	83 c4 10             	add    $0x10,%esp
80103b9d:	89 c2                	mov    %eax,%edx
80103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba2:	0f b6 00             	movzbl (%eax),%eax
80103ba5:	0f b6 c0             	movzbl %al,%eax
80103ba8:	83 ec 08             	sub    $0x8,%esp
80103bab:	52                   	push   %edx
80103bac:	50                   	push   %eax
80103bad:	e8 f0 f5 ff ff       	call   801031a2 <lapicstartap>
80103bb2:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103bb5:	90                   	nop
80103bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb9:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103bbf:	85 c0                	test   %eax,%eax
80103bc1:	74 f3                	je     80103bb6 <startothers+0xb5>
80103bc3:	eb 01                	jmp    80103bc6 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103bc5:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103bc6:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103bcd:	a1 80 39 11 80       	mov    0x80113980,%eax
80103bd2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103bd8:	05 a0 33 11 80       	add    $0x801133a0,%eax
80103bdd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103be0:	0f 87 57 ff ff ff    	ja     80103b3d <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103be6:	90                   	nop
80103be7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bea:	c9                   	leave  
80103beb:	c3                   	ret    

80103bec <p2v>:
80103bec:	55                   	push   %ebp
80103bed:	89 e5                	mov    %esp,%ebp
80103bef:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf2:	05 00 00 00 80       	add    $0x80000000,%eax
80103bf7:	5d                   	pop    %ebp
80103bf8:	c3                   	ret    

80103bf9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103bf9:	55                   	push   %ebp
80103bfa:	89 e5                	mov    %esp,%ebp
80103bfc:	83 ec 14             	sub    $0x14,%esp
80103bff:	8b 45 08             	mov    0x8(%ebp),%eax
80103c02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c06:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103c0a:	89 c2                	mov    %eax,%edx
80103c0c:	ec                   	in     (%dx),%al
80103c0d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103c10:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c14:	c9                   	leave  
80103c15:	c3                   	ret    

80103c16 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103c16:	55                   	push   %ebp
80103c17:	89 e5                	mov    %esp,%ebp
80103c19:	83 ec 08             	sub    $0x8,%esp
80103c1c:	8b 55 08             	mov    0x8(%ebp),%edx
80103c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c22:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103c26:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c29:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c2d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c31:	ee                   	out    %al,(%dx)
}
80103c32:	90                   	nop
80103c33:	c9                   	leave  
80103c34:	c3                   	ret    

80103c35 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103c35:	55                   	push   %ebp
80103c36:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103c38:	a1 84 c6 10 80       	mov    0x8010c684,%eax
80103c3d:	89 c2                	mov    %eax,%edx
80103c3f:	b8 a0 33 11 80       	mov    $0x801133a0,%eax
80103c44:	29 c2                	sub    %eax,%edx
80103c46:	89 d0                	mov    %edx,%eax
80103c48:	c1 f8 02             	sar    $0x2,%eax
80103c4b:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103c51:	5d                   	pop    %ebp
80103c52:	c3                   	ret    

80103c53 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103c53:	55                   	push   %ebp
80103c54:	89 e5                	mov    %esp,%ebp
80103c56:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103c59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c67:	eb 15                	jmp    80103c7e <sum+0x2b>
    sum += addr[i];
80103c69:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c6f:	01 d0                	add    %edx,%eax
80103c71:	0f b6 00             	movzbl (%eax),%eax
80103c74:	0f b6 c0             	movzbl %al,%eax
80103c77:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103c7a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c81:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c84:	7c e3                	jl     80103c69 <sum+0x16>
    sum += addr[i];
  return sum;
80103c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c89:	c9                   	leave  
80103c8a:	c3                   	ret    

80103c8b <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c8b:	55                   	push   %ebp
80103c8c:	89 e5                	mov    %esp,%ebp
80103c8e:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103c91:	ff 75 08             	pushl  0x8(%ebp)
80103c94:	e8 53 ff ff ff       	call   80103bec <p2v>
80103c99:	83 c4 04             	add    $0x4,%esp
80103c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca5:	01 d0                	add    %edx,%eax
80103ca7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cb0:	eb 36                	jmp    80103ce8 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103cb2:	83 ec 04             	sub    $0x4,%esp
80103cb5:	6a 04                	push   $0x4
80103cb7:	68 60 90 10 80       	push   $0x80109060
80103cbc:	ff 75 f4             	pushl  -0xc(%ebp)
80103cbf:	e8 34 1b 00 00       	call   801057f8 <memcmp>
80103cc4:	83 c4 10             	add    $0x10,%esp
80103cc7:	85 c0                	test   %eax,%eax
80103cc9:	75 19                	jne    80103ce4 <mpsearch1+0x59>
80103ccb:	83 ec 08             	sub    $0x8,%esp
80103cce:	6a 10                	push   $0x10
80103cd0:	ff 75 f4             	pushl  -0xc(%ebp)
80103cd3:	e8 7b ff ff ff       	call   80103c53 <sum>
80103cd8:	83 c4 10             	add    $0x10,%esp
80103cdb:	84 c0                	test   %al,%al
80103cdd:	75 05                	jne    80103ce4 <mpsearch1+0x59>
      return (struct mp*)p;
80103cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce2:	eb 11                	jmp    80103cf5 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ce4:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cee:	72 c2                	jb     80103cb2 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103cf5:	c9                   	leave  
80103cf6:	c3                   	ret    

80103cf7 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103cf7:	55                   	push   %ebp
80103cf8:	89 e5                	mov    %esp,%ebp
80103cfa:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103cfd:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d07:	83 c0 0f             	add    $0xf,%eax
80103d0a:	0f b6 00             	movzbl (%eax),%eax
80103d0d:	0f b6 c0             	movzbl %al,%eax
80103d10:	c1 e0 08             	shl    $0x8,%eax
80103d13:	89 c2                	mov    %eax,%edx
80103d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d18:	83 c0 0e             	add    $0xe,%eax
80103d1b:	0f b6 00             	movzbl (%eax),%eax
80103d1e:	0f b6 c0             	movzbl %al,%eax
80103d21:	09 d0                	or     %edx,%eax
80103d23:	c1 e0 04             	shl    $0x4,%eax
80103d26:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d2d:	74 21                	je     80103d50 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103d2f:	83 ec 08             	sub    $0x8,%esp
80103d32:	68 00 04 00 00       	push   $0x400
80103d37:	ff 75 f0             	pushl  -0x10(%ebp)
80103d3a:	e8 4c ff ff ff       	call   80103c8b <mpsearch1>
80103d3f:	83 c4 10             	add    $0x10,%esp
80103d42:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d49:	74 51                	je     80103d9c <mpsearch+0xa5>
      return mp;
80103d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d4e:	eb 61                	jmp    80103db1 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d53:	83 c0 14             	add    $0x14,%eax
80103d56:	0f b6 00             	movzbl (%eax),%eax
80103d59:	0f b6 c0             	movzbl %al,%eax
80103d5c:	c1 e0 08             	shl    $0x8,%eax
80103d5f:	89 c2                	mov    %eax,%edx
80103d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d64:	83 c0 13             	add    $0x13,%eax
80103d67:	0f b6 00             	movzbl (%eax),%eax
80103d6a:	0f b6 c0             	movzbl %al,%eax
80103d6d:	09 d0                	or     %edx,%eax
80103d6f:	c1 e0 0a             	shl    $0xa,%eax
80103d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d78:	2d 00 04 00 00       	sub    $0x400,%eax
80103d7d:	83 ec 08             	sub    $0x8,%esp
80103d80:	68 00 04 00 00       	push   $0x400
80103d85:	50                   	push   %eax
80103d86:	e8 00 ff ff ff       	call   80103c8b <mpsearch1>
80103d8b:	83 c4 10             	add    $0x10,%esp
80103d8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d95:	74 05                	je     80103d9c <mpsearch+0xa5>
      return mp;
80103d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d9a:	eb 15                	jmp    80103db1 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d9c:	83 ec 08             	sub    $0x8,%esp
80103d9f:	68 00 00 01 00       	push   $0x10000
80103da4:	68 00 00 0f 00       	push   $0xf0000
80103da9:	e8 dd fe ff ff       	call   80103c8b <mpsearch1>
80103dae:	83 c4 10             	add    $0x10,%esp
}
80103db1:	c9                   	leave  
80103db2:	c3                   	ret    

80103db3 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103db3:	55                   	push   %ebp
80103db4:	89 e5                	mov    %esp,%ebp
80103db6:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103db9:	e8 39 ff ff ff       	call   80103cf7 <mpsearch>
80103dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dc5:	74 0a                	je     80103dd1 <mpconfig+0x1e>
80103dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dca:	8b 40 04             	mov    0x4(%eax),%eax
80103dcd:	85 c0                	test   %eax,%eax
80103dcf:	75 0a                	jne    80103ddb <mpconfig+0x28>
    return 0;
80103dd1:	b8 00 00 00 00       	mov    $0x0,%eax
80103dd6:	e9 81 00 00 00       	jmp    80103e5c <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dde:	8b 40 04             	mov    0x4(%eax),%eax
80103de1:	83 ec 0c             	sub    $0xc,%esp
80103de4:	50                   	push   %eax
80103de5:	e8 02 fe ff ff       	call   80103bec <p2v>
80103dea:	83 c4 10             	add    $0x10,%esp
80103ded:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103df0:	83 ec 04             	sub    $0x4,%esp
80103df3:	6a 04                	push   $0x4
80103df5:	68 65 90 10 80       	push   $0x80109065
80103dfa:	ff 75 f0             	pushl  -0x10(%ebp)
80103dfd:	e8 f6 19 00 00       	call   801057f8 <memcmp>
80103e02:	83 c4 10             	add    $0x10,%esp
80103e05:	85 c0                	test   %eax,%eax
80103e07:	74 07                	je     80103e10 <mpconfig+0x5d>
    return 0;
80103e09:	b8 00 00 00 00       	mov    $0x0,%eax
80103e0e:	eb 4c                	jmp    80103e5c <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e13:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e17:	3c 01                	cmp    $0x1,%al
80103e19:	74 12                	je     80103e2d <mpconfig+0x7a>
80103e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e1e:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e22:	3c 04                	cmp    $0x4,%al
80103e24:	74 07                	je     80103e2d <mpconfig+0x7a>
    return 0;
80103e26:	b8 00 00 00 00       	mov    $0x0,%eax
80103e2b:	eb 2f                	jmp    80103e5c <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e30:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e34:	0f b7 c0             	movzwl %ax,%eax
80103e37:	83 ec 08             	sub    $0x8,%esp
80103e3a:	50                   	push   %eax
80103e3b:	ff 75 f0             	pushl  -0x10(%ebp)
80103e3e:	e8 10 fe ff ff       	call   80103c53 <sum>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	84 c0                	test   %al,%al
80103e48:	74 07                	je     80103e51 <mpconfig+0x9e>
    return 0;
80103e4a:	b8 00 00 00 00       	mov    $0x0,%eax
80103e4f:	eb 0b                	jmp    80103e5c <mpconfig+0xa9>
  *pmp = mp;
80103e51:	8b 45 08             	mov    0x8(%ebp),%eax
80103e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e57:	89 10                	mov    %edx,(%eax)
  return conf;
80103e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e5c:	c9                   	leave  
80103e5d:	c3                   	ret    

80103e5e <mpinit>:

void
mpinit(void)
{
80103e5e:	55                   	push   %ebp
80103e5f:	89 e5                	mov    %esp,%ebp
80103e61:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103e64:	c7 05 84 c6 10 80 a0 	movl   $0x801133a0,0x8010c684
80103e6b:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103e6e:	83 ec 0c             	sub    $0xc,%esp
80103e71:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103e74:	50                   	push   %eax
80103e75:	e8 39 ff ff ff       	call   80103db3 <mpconfig>
80103e7a:	83 c4 10             	add    $0x10,%esp
80103e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103e80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e84:	0f 84 96 01 00 00    	je     80104020 <mpinit+0x1c2>
    return;
  ismp = 1;
80103e8a:	c7 05 84 33 11 80 01 	movl   $0x1,0x80113384
80103e91:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e97:	8b 40 24             	mov    0x24(%eax),%eax
80103e9a:	a3 9c 32 11 80       	mov    %eax,0x8011329c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ea2:	83 c0 2c             	add    $0x2c,%eax
80103ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103eab:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103eaf:	0f b7 d0             	movzwl %ax,%edx
80103eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103eb5:	01 d0                	add    %edx,%eax
80103eb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103eba:	e9 f2 00 00 00       	jmp    80103fb1 <mpinit+0x153>
    switch(*p){
80103ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec2:	0f b6 00             	movzbl (%eax),%eax
80103ec5:	0f b6 c0             	movzbl %al,%eax
80103ec8:	83 f8 04             	cmp    $0x4,%eax
80103ecb:	0f 87 bc 00 00 00    	ja     80103f8d <mpinit+0x12f>
80103ed1:	8b 04 85 a8 90 10 80 	mov    -0x7fef6f58(,%eax,4),%eax
80103ed8:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103edd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103ee0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ee3:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ee7:	0f b6 d0             	movzbl %al,%edx
80103eea:	a1 80 39 11 80       	mov    0x80113980,%eax
80103eef:	39 c2                	cmp    %eax,%edx
80103ef1:	74 2b                	je     80103f1e <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ef6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103efa:	0f b6 d0             	movzbl %al,%edx
80103efd:	a1 80 39 11 80       	mov    0x80113980,%eax
80103f02:	83 ec 04             	sub    $0x4,%esp
80103f05:	52                   	push   %edx
80103f06:	50                   	push   %eax
80103f07:	68 6a 90 10 80       	push   $0x8010906a
80103f0c:	e8 b5 c4 ff ff       	call   801003c6 <cprintf>
80103f11:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103f14:	c7 05 84 33 11 80 00 	movl   $0x0,0x80113384
80103f1b:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f21:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103f25:	0f b6 c0             	movzbl %al,%eax
80103f28:	83 e0 02             	and    $0x2,%eax
80103f2b:	85 c0                	test   %eax,%eax
80103f2d:	74 15                	je     80103f44 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103f2f:	a1 80 39 11 80       	mov    0x80113980,%eax
80103f34:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f3a:	05 a0 33 11 80       	add    $0x801133a0,%eax
80103f3f:	a3 84 c6 10 80       	mov    %eax,0x8010c684
      cpus[ncpu].id = ncpu;
80103f44:	a1 80 39 11 80       	mov    0x80113980,%eax
80103f49:	8b 15 80 39 11 80    	mov    0x80113980,%edx
80103f4f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f55:	05 a0 33 11 80       	add    $0x801133a0,%eax
80103f5a:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103f5c:	a1 80 39 11 80       	mov    0x80113980,%eax
80103f61:	83 c0 01             	add    $0x1,%eax
80103f64:	a3 80 39 11 80       	mov    %eax,0x80113980
      p += sizeof(struct mpproc);
80103f69:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103f6d:	eb 42                	jmp    80103fb1 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f78:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f7c:	a2 80 33 11 80       	mov    %al,0x80113380
      p += sizeof(struct mpioapic);
80103f81:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f85:	eb 2a                	jmp    80103fb1 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f87:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f8b:	eb 24                	jmp    80103fb1 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f90:	0f b6 00             	movzbl (%eax),%eax
80103f93:	0f b6 c0             	movzbl %al,%eax
80103f96:	83 ec 08             	sub    $0x8,%esp
80103f99:	50                   	push   %eax
80103f9a:	68 88 90 10 80       	push   $0x80109088
80103f9f:	e8 22 c4 ff ff       	call   801003c6 <cprintf>
80103fa4:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103fa7:	c7 05 84 33 11 80 00 	movl   $0x0,0x80113384
80103fae:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103fb7:	0f 82 02 ff ff ff    	jb     80103ebf <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103fbd:	a1 84 33 11 80       	mov    0x80113384,%eax
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	75 1d                	jne    80103fe3 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103fc6:	c7 05 80 39 11 80 01 	movl   $0x1,0x80113980
80103fcd:	00 00 00 
    lapic = 0;
80103fd0:	c7 05 9c 32 11 80 00 	movl   $0x0,0x8011329c
80103fd7:	00 00 00 
    ioapicid = 0;
80103fda:	c6 05 80 33 11 80 00 	movb   $0x0,0x80113380
    return;
80103fe1:	eb 3e                	jmp    80104021 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103fe3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103fe6:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103fea:	84 c0                	test   %al,%al
80103fec:	74 33                	je     80104021 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103fee:	83 ec 08             	sub    $0x8,%esp
80103ff1:	6a 70                	push   $0x70
80103ff3:	6a 22                	push   $0x22
80103ff5:	e8 1c fc ff ff       	call   80103c16 <outb>
80103ffa:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	6a 23                	push   $0x23
80104002:	e8 f2 fb ff ff       	call   80103bf9 <inb>
80104007:	83 c4 10             	add    $0x10,%esp
8010400a:	83 c8 01             	or     $0x1,%eax
8010400d:	0f b6 c0             	movzbl %al,%eax
80104010:	83 ec 08             	sub    $0x8,%esp
80104013:	50                   	push   %eax
80104014:	6a 23                	push   $0x23
80104016:	e8 fb fb ff ff       	call   80103c16 <outb>
8010401b:	83 c4 10             	add    $0x10,%esp
8010401e:	eb 01                	jmp    80104021 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80104020:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80104021:	c9                   	leave  
80104022:	c3                   	ret    

80104023 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80104023:	55                   	push   %ebp
80104024:	89 e5                	mov    %esp,%ebp
80104026:	83 ec 08             	sub    $0x8,%esp
80104029:	8b 55 08             	mov    0x8(%ebp),%edx
8010402c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010402f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104033:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104036:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010403a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010403e:	ee                   	out    %al,(%dx)
}
8010403f:	90                   	nop
80104040:	c9                   	leave  
80104041:	c3                   	ret    

80104042 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104042:	55                   	push   %ebp
80104043:	89 e5                	mov    %esp,%ebp
80104045:	83 ec 04             	sub    $0x4,%esp
80104048:	8b 45 08             	mov    0x8(%ebp),%eax
8010404b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
8010404f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104053:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80104059:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010405d:	0f b6 c0             	movzbl %al,%eax
80104060:	50                   	push   %eax
80104061:	6a 21                	push   $0x21
80104063:	e8 bb ff ff ff       	call   80104023 <outb>
80104068:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
8010406b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010406f:	66 c1 e8 08          	shr    $0x8,%ax
80104073:	0f b6 c0             	movzbl %al,%eax
80104076:	50                   	push   %eax
80104077:	68 a1 00 00 00       	push   $0xa1
8010407c:	e8 a2 ff ff ff       	call   80104023 <outb>
80104081:	83 c4 08             	add    $0x8,%esp
}
80104084:	90                   	nop
80104085:	c9                   	leave  
80104086:	c3                   	ret    

80104087 <picenable>:

void
picenable(int irq)
{
80104087:	55                   	push   %ebp
80104088:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010408a:	8b 45 08             	mov    0x8(%ebp),%eax
8010408d:	ba 01 00 00 00       	mov    $0x1,%edx
80104092:	89 c1                	mov    %eax,%ecx
80104094:	d3 e2                	shl    %cl,%edx
80104096:	89 d0                	mov    %edx,%eax
80104098:	f7 d0                	not    %eax
8010409a:	89 c2                	mov    %eax,%edx
8010409c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040a3:	21 d0                	and    %edx,%eax
801040a5:	0f b7 c0             	movzwl %ax,%eax
801040a8:	50                   	push   %eax
801040a9:	e8 94 ff ff ff       	call   80104042 <picsetmask>
801040ae:	83 c4 04             	add    $0x4,%esp
}
801040b1:	90                   	nop
801040b2:	c9                   	leave  
801040b3:	c3                   	ret    

801040b4 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801040b4:	55                   	push   %ebp
801040b5:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
801040b7:	68 ff 00 00 00       	push   $0xff
801040bc:	6a 21                	push   $0x21
801040be:	e8 60 ff ff ff       	call   80104023 <outb>
801040c3:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
801040c6:	68 ff 00 00 00       	push   $0xff
801040cb:	68 a1 00 00 00       	push   $0xa1
801040d0:	e8 4e ff ff ff       	call   80104023 <outb>
801040d5:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801040d8:	6a 11                	push   $0x11
801040da:	6a 20                	push   $0x20
801040dc:	e8 42 ff ff ff       	call   80104023 <outb>
801040e1:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801040e4:	6a 20                	push   $0x20
801040e6:	6a 21                	push   $0x21
801040e8:	e8 36 ff ff ff       	call   80104023 <outb>
801040ed:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801040f0:	6a 04                	push   $0x4
801040f2:	6a 21                	push   $0x21
801040f4:	e8 2a ff ff ff       	call   80104023 <outb>
801040f9:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801040fc:	6a 03                	push   $0x3
801040fe:	6a 21                	push   $0x21
80104100:	e8 1e ff ff ff       	call   80104023 <outb>
80104105:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104108:	6a 11                	push   $0x11
8010410a:	68 a0 00 00 00       	push   $0xa0
8010410f:	e8 0f ff ff ff       	call   80104023 <outb>
80104114:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104117:	6a 28                	push   $0x28
80104119:	68 a1 00 00 00       	push   $0xa1
8010411e:	e8 00 ff ff ff       	call   80104023 <outb>
80104123:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104126:	6a 02                	push   $0x2
80104128:	68 a1 00 00 00       	push   $0xa1
8010412d:	e8 f1 fe ff ff       	call   80104023 <outb>
80104132:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104135:	6a 03                	push   $0x3
80104137:	68 a1 00 00 00       	push   $0xa1
8010413c:	e8 e2 fe ff ff       	call   80104023 <outb>
80104141:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104144:	6a 68                	push   $0x68
80104146:	6a 20                	push   $0x20
80104148:	e8 d6 fe ff ff       	call   80104023 <outb>
8010414d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104150:	6a 0a                	push   $0xa
80104152:	6a 20                	push   $0x20
80104154:	e8 ca fe ff ff       	call   80104023 <outb>
80104159:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010415c:	6a 68                	push   $0x68
8010415e:	68 a0 00 00 00       	push   $0xa0
80104163:	e8 bb fe ff ff       	call   80104023 <outb>
80104168:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
8010416b:	6a 0a                	push   $0xa
8010416d:	68 a0 00 00 00       	push   $0xa0
80104172:	e8 ac fe ff ff       	call   80104023 <outb>
80104177:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
8010417a:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104181:	66 83 f8 ff          	cmp    $0xffff,%ax
80104185:	74 13                	je     8010419a <picinit+0xe6>
    picsetmask(irqmask);
80104187:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
8010418e:	0f b7 c0             	movzwl %ax,%eax
80104191:	50                   	push   %eax
80104192:	e8 ab fe ff ff       	call   80104042 <picsetmask>
80104197:	83 c4 04             	add    $0x4,%esp
}
8010419a:	90                   	nop
8010419b:	c9                   	leave  
8010419c:	c3                   	ret    

8010419d <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010419d:	55                   	push   %ebp
8010419e:	89 e5                	mov    %esp,%ebp
801041a0:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801041a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801041aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801041ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801041b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b6:	8b 10                	mov    (%eax),%edx
801041b8:	8b 45 08             	mov    0x8(%ebp),%eax
801041bb:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801041bd:	e8 d1 cd ff ff       	call   80100f93 <filealloc>
801041c2:	89 c2                	mov    %eax,%edx
801041c4:	8b 45 08             	mov    0x8(%ebp),%eax
801041c7:	89 10                	mov    %edx,(%eax)
801041c9:	8b 45 08             	mov    0x8(%ebp),%eax
801041cc:	8b 00                	mov    (%eax),%eax
801041ce:	85 c0                	test   %eax,%eax
801041d0:	0f 84 cb 00 00 00    	je     801042a1 <pipealloc+0x104>
801041d6:	e8 b8 cd ff ff       	call   80100f93 <filealloc>
801041db:	89 c2                	mov    %eax,%edx
801041dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801041e0:	89 10                	mov    %edx,(%eax)
801041e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801041e5:	8b 00                	mov    (%eax),%eax
801041e7:	85 c0                	test   %eax,%eax
801041e9:	0f 84 b2 00 00 00    	je     801042a1 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801041ef:	e8 ce eb ff ff       	call   80102dc2 <kalloc>
801041f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041fb:	0f 84 9f 00 00 00    	je     801042a0 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104204:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010420b:	00 00 00 
  p->writeopen = 1;
8010420e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104211:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104218:	00 00 00 
  p->nwrite = 0;
8010421b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010421e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104225:	00 00 00 
  p->nread = 0;
80104228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104232:	00 00 00 
  initlock(&p->lock, "pipe");
80104235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104238:	83 ec 08             	sub    $0x8,%esp
8010423b:	68 bc 90 10 80       	push   $0x801090bc
80104240:	50                   	push   %eax
80104241:	e8 c6 12 00 00       	call   8010550c <initlock>
80104246:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104249:	8b 45 08             	mov    0x8(%ebp),%eax
8010424c:	8b 00                	mov    (%eax),%eax
8010424e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104254:	8b 45 08             	mov    0x8(%ebp),%eax
80104257:	8b 00                	mov    (%eax),%eax
80104259:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010425d:	8b 45 08             	mov    0x8(%ebp),%eax
80104260:	8b 00                	mov    (%eax),%eax
80104262:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104266:	8b 45 08             	mov    0x8(%ebp),%eax
80104269:	8b 00                	mov    (%eax),%eax
8010426b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010426e:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104271:	8b 45 0c             	mov    0xc(%ebp),%eax
80104274:	8b 00                	mov    (%eax),%eax
80104276:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010427c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010427f:	8b 00                	mov    (%eax),%eax
80104281:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104285:	8b 45 0c             	mov    0xc(%ebp),%eax
80104288:	8b 00                	mov    (%eax),%eax
8010428a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010428e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104291:	8b 00                	mov    (%eax),%eax
80104293:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104296:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104299:	b8 00 00 00 00       	mov    $0x0,%eax
8010429e:	eb 4e                	jmp    801042ee <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801042a0:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
801042a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042a5:	74 0e                	je     801042b5 <pipealloc+0x118>
    kfree((char*)p);
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	ff 75 f4             	pushl  -0xc(%ebp)
801042ad:	e8 73 ea ff ff       	call   80102d25 <kfree>
801042b2:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801042b5:	8b 45 08             	mov    0x8(%ebp),%eax
801042b8:	8b 00                	mov    (%eax),%eax
801042ba:	85 c0                	test   %eax,%eax
801042bc:	74 11                	je     801042cf <pipealloc+0x132>
    fileclose(*f0);
801042be:	8b 45 08             	mov    0x8(%ebp),%eax
801042c1:	8b 00                	mov    (%eax),%eax
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	50                   	push   %eax
801042c7:	e8 85 cd ff ff       	call   80101051 <fileclose>
801042cc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801042cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801042d2:	8b 00                	mov    (%eax),%eax
801042d4:	85 c0                	test   %eax,%eax
801042d6:	74 11                	je     801042e9 <pipealloc+0x14c>
    fileclose(*f1);
801042d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801042db:	8b 00                	mov    (%eax),%eax
801042dd:	83 ec 0c             	sub    $0xc,%esp
801042e0:	50                   	push   %eax
801042e1:	e8 6b cd ff ff       	call   80101051 <fileclose>
801042e6:	83 c4 10             	add    $0x10,%esp
  return -1;
801042e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042ee:	c9                   	leave  
801042ef:	c3                   	ret    

801042f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801042f6:	8b 45 08             	mov    0x8(%ebp),%eax
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	50                   	push   %eax
801042fd:	e8 2c 12 00 00       	call   8010552e <acquire>
80104302:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104305:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104309:	74 23                	je     8010432e <pipeclose+0x3e>
    p->writeopen = 0;
8010430b:	8b 45 08             	mov    0x8(%ebp),%eax
8010430e:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104315:	00 00 00 
    wakeup(&p->nread);
80104318:	8b 45 08             	mov    0x8(%ebp),%eax
8010431b:	05 34 02 00 00       	add    $0x234,%eax
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	50                   	push   %eax
80104324:	e8 5c 0d 00 00       	call   80105085 <wakeup>
80104329:	83 c4 10             	add    $0x10,%esp
8010432c:	eb 21                	jmp    8010434f <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010432e:	8b 45 08             	mov    0x8(%ebp),%eax
80104331:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104338:	00 00 00 
    wakeup(&p->nwrite);
8010433b:	8b 45 08             	mov    0x8(%ebp),%eax
8010433e:	05 38 02 00 00       	add    $0x238,%eax
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	50                   	push   %eax
80104347:	e8 39 0d 00 00       	call   80105085 <wakeup>
8010434c:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010434f:	8b 45 08             	mov    0x8(%ebp),%eax
80104352:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104358:	85 c0                	test   %eax,%eax
8010435a:	75 2c                	jne    80104388 <pipeclose+0x98>
8010435c:	8b 45 08             	mov    0x8(%ebp),%eax
8010435f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104365:	85 c0                	test   %eax,%eax
80104367:	75 1f                	jne    80104388 <pipeclose+0x98>
    release(&p->lock);
80104369:	8b 45 08             	mov    0x8(%ebp),%eax
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	50                   	push   %eax
80104370:	e8 20 12 00 00       	call   80105595 <release>
80104375:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	ff 75 08             	pushl  0x8(%ebp)
8010437e:	e8 a2 e9 ff ff       	call   80102d25 <kfree>
80104383:	83 c4 10             	add    $0x10,%esp
80104386:	eb 0f                	jmp    80104397 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104388:	8b 45 08             	mov    0x8(%ebp),%eax
8010438b:	83 ec 0c             	sub    $0xc,%esp
8010438e:	50                   	push   %eax
8010438f:	e8 01 12 00 00       	call   80105595 <release>
80104394:	83 c4 10             	add    $0x10,%esp
}
80104397:	90                   	nop
80104398:	c9                   	leave  
80104399:	c3                   	ret    

8010439a <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
8010439a:	55                   	push   %ebp
8010439b:	89 e5                	mov    %esp,%ebp
8010439d:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801043a0:	8b 45 08             	mov    0x8(%ebp),%eax
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	50                   	push   %eax
801043a7:	e8 82 11 00 00       	call   8010552e <acquire>
801043ac:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801043af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801043b6:	e9 ad 00 00 00       	jmp    80104468 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801043bb:	8b 45 08             	mov    0x8(%ebp),%eax
801043be:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801043c4:	85 c0                	test   %eax,%eax
801043c6:	74 0d                	je     801043d5 <pipewrite+0x3b>
801043c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ce:	8b 40 24             	mov    0x24(%eax),%eax
801043d1:	85 c0                	test   %eax,%eax
801043d3:	74 19                	je     801043ee <pipewrite+0x54>
        release(&p->lock);
801043d5:	8b 45 08             	mov    0x8(%ebp),%eax
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	50                   	push   %eax
801043dc:	e8 b4 11 00 00       	call   80105595 <release>
801043e1:	83 c4 10             	add    $0x10,%esp
        return -1;
801043e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e9:	e9 a8 00 00 00       	jmp    80104496 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801043ee:	8b 45 08             	mov    0x8(%ebp),%eax
801043f1:	05 34 02 00 00       	add    $0x234,%eax
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	50                   	push   %eax
801043fa:	e8 86 0c 00 00       	call   80105085 <wakeup>
801043ff:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104402:	8b 45 08             	mov    0x8(%ebp),%eax
80104405:	8b 55 08             	mov    0x8(%ebp),%edx
80104408:	81 c2 38 02 00 00    	add    $0x238,%edx
8010440e:	83 ec 08             	sub    $0x8,%esp
80104411:	50                   	push   %eax
80104412:	52                   	push   %edx
80104413:	e8 7f 0b 00 00       	call   80104f97 <sleep>
80104418:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010441b:	8b 45 08             	mov    0x8(%ebp),%eax
8010441e:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104424:	8b 45 08             	mov    0x8(%ebp),%eax
80104427:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010442d:	05 00 02 00 00       	add    $0x200,%eax
80104432:	39 c2                	cmp    %eax,%edx
80104434:	74 85                	je     801043bb <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104436:	8b 45 08             	mov    0x8(%ebp),%eax
80104439:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010443f:	8d 48 01             	lea    0x1(%eax),%ecx
80104442:	8b 55 08             	mov    0x8(%ebp),%edx
80104445:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010444b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104450:	89 c1                	mov    %eax,%ecx
80104452:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104455:	8b 45 0c             	mov    0xc(%ebp),%eax
80104458:	01 d0                	add    %edx,%eax
8010445a:	0f b6 10             	movzbl (%eax),%edx
8010445d:	8b 45 08             	mov    0x8(%ebp),%eax
80104460:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104464:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010446e:	7c ab                	jl     8010441b <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104470:	8b 45 08             	mov    0x8(%ebp),%eax
80104473:	05 34 02 00 00       	add    $0x234,%eax
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	50                   	push   %eax
8010447c:	e8 04 0c 00 00       	call   80105085 <wakeup>
80104481:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104484:	8b 45 08             	mov    0x8(%ebp),%eax
80104487:	83 ec 0c             	sub    $0xc,%esp
8010448a:	50                   	push   %eax
8010448b:	e8 05 11 00 00       	call   80105595 <release>
80104490:	83 c4 10             	add    $0x10,%esp
  return n;
80104493:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104496:	c9                   	leave  
80104497:	c3                   	ret    

80104498 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104498:	55                   	push   %ebp
80104499:	89 e5                	mov    %esp,%ebp
8010449b:	53                   	push   %ebx
8010449c:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010449f:	8b 45 08             	mov    0x8(%ebp),%eax
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	50                   	push   %eax
801044a6:	e8 83 10 00 00       	call   8010552e <acquire>
801044ab:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801044ae:	eb 3f                	jmp    801044ef <piperead+0x57>
    if(proc->killed){
801044b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b6:	8b 40 24             	mov    0x24(%eax),%eax
801044b9:	85 c0                	test   %eax,%eax
801044bb:	74 19                	je     801044d6 <piperead+0x3e>
      release(&p->lock);
801044bd:	8b 45 08             	mov    0x8(%ebp),%eax
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	50                   	push   %eax
801044c4:	e8 cc 10 00 00       	call   80105595 <release>
801044c9:	83 c4 10             	add    $0x10,%esp
      return -1;
801044cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044d1:	e9 bf 00 00 00       	jmp    80104595 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
801044d9:	8b 55 08             	mov    0x8(%ebp),%edx
801044dc:	81 c2 34 02 00 00    	add    $0x234,%edx
801044e2:	83 ec 08             	sub    $0x8,%esp
801044e5:	50                   	push   %eax
801044e6:	52                   	push   %edx
801044e7:	e8 ab 0a 00 00       	call   80104f97 <sleep>
801044ec:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801044ef:	8b 45 08             	mov    0x8(%ebp),%eax
801044f2:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801044f8:	8b 45 08             	mov    0x8(%ebp),%eax
801044fb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104501:	39 c2                	cmp    %eax,%edx
80104503:	75 0d                	jne    80104512 <piperead+0x7a>
80104505:	8b 45 08             	mov    0x8(%ebp),%eax
80104508:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010450e:	85 c0                	test   %eax,%eax
80104510:	75 9e                	jne    801044b0 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104519:	eb 49                	jmp    80104564 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010451b:	8b 45 08             	mov    0x8(%ebp),%eax
8010451e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104524:	8b 45 08             	mov    0x8(%ebp),%eax
80104527:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010452d:	39 c2                	cmp    %eax,%edx
8010452f:	74 3d                	je     8010456e <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104531:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104534:	8b 45 0c             	mov    0xc(%ebp),%eax
80104537:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010453a:	8b 45 08             	mov    0x8(%ebp),%eax
8010453d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104543:	8d 48 01             	lea    0x1(%eax),%ecx
80104546:	8b 55 08             	mov    0x8(%ebp),%edx
80104549:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010454f:	25 ff 01 00 00       	and    $0x1ff,%eax
80104554:	89 c2                	mov    %eax,%edx
80104556:	8b 45 08             	mov    0x8(%ebp),%eax
80104559:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010455e:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104567:	3b 45 10             	cmp    0x10(%ebp),%eax
8010456a:	7c af                	jl     8010451b <piperead+0x83>
8010456c:	eb 01                	jmp    8010456f <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010456e:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010456f:	8b 45 08             	mov    0x8(%ebp),%eax
80104572:	05 38 02 00 00       	add    $0x238,%eax
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	50                   	push   %eax
8010457b:	e8 05 0b 00 00       	call   80105085 <wakeup>
80104580:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104583:	8b 45 08             	mov    0x8(%ebp),%eax
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	50                   	push   %eax
8010458a:	e8 06 10 00 00       	call   80105595 <release>
8010458f:	83 c4 10             	add    $0x10,%esp
  return i;
80104592:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104598:	c9                   	leave  
80104599:	c3                   	ret    

8010459a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010459a:	55                   	push   %ebp
8010459b:	89 e5                	mov    %esp,%ebp
8010459d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045a0:	9c                   	pushf  
801045a1:	58                   	pop    %eax
801045a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801045a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801045a8:	c9                   	leave  
801045a9:	c3                   	ret    

801045aa <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801045aa:	55                   	push   %ebp
801045ab:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801045ad:	fb                   	sti    
}
801045ae:	90                   	nop
801045af:	5d                   	pop    %ebp
801045b0:	c3                   	ret    

801045b1 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801045b1:	55                   	push   %ebp
801045b2:	89 e5                	mov    %esp,%ebp
801045b4:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801045b7:	83 ec 08             	sub    $0x8,%esp
801045ba:	68 c1 90 10 80       	push   $0x801090c1
801045bf:	68 a0 39 11 80       	push   $0x801139a0
801045c4:	e8 43 0f 00 00       	call   8010550c <initlock>
801045c9:	83 c4 10             	add    $0x10,%esp
}
801045cc:	90                   	nop
801045cd:	c9                   	leave  
801045ce:	c3                   	ret    

801045cf <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801045cf:	55                   	push   %ebp
801045d0:	89 e5                	mov    %esp,%ebp
801045d2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801045d5:	83 ec 0c             	sub    $0xc,%esp
801045d8:	68 a0 39 11 80       	push   $0x801139a0
801045dd:	e8 4c 0f 00 00       	call   8010552e <acquire>
801045e2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045e5:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
801045ec:	eb 11                	jmp    801045ff <allocproc+0x30>
    if(p->state == UNUSED)
801045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f1:	8b 40 0c             	mov    0xc(%eax),%eax
801045f4:	85 c0                	test   %eax,%eax
801045f6:	74 2a                	je     80104622 <allocproc+0x53>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045f8:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801045ff:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104606:	72 e6                	jb     801045ee <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	68 a0 39 11 80       	push   $0x801139a0
80104610:	e8 80 0f 00 00       	call   80105595 <release>
80104615:	83 c4 10             	add    $0x10,%esp
  return 0;
80104618:	b8 00 00 00 00       	mov    $0x0,%eax
8010461d:	e9 ff 00 00 00       	jmp    80104721 <allocproc+0x152>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104622:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104626:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010462d:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104632:	8d 50 01             	lea    0x1(%eax),%edx
80104635:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010463b:	89 c2                	mov    %eax,%edx
8010463d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104640:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104643:	83 ec 0c             	sub    $0xc,%esp
80104646:	68 a0 39 11 80       	push   $0x801139a0
8010464b:	e8 45 0f 00 00       	call   80105595 <release>
80104650:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104653:	e8 6a e7 ff ff       	call   80102dc2 <kalloc>
80104658:	89 c2                	mov    %eax,%edx
8010465a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465d:	89 50 08             	mov    %edx,0x8(%eax)
80104660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104663:	8b 40 08             	mov    0x8(%eax),%eax
80104666:	85 c0                	test   %eax,%eax
80104668:	75 14                	jne    8010467e <allocproc+0xaf>
    p->state = UNUSED;
8010466a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104674:	b8 00 00 00 00       	mov    $0x0,%eax
80104679:	e9 a3 00 00 00       	jmp    80104721 <allocproc+0x152>
  }
  sp = p->kstack + KSTACKSIZE;
8010467e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104681:	8b 40 08             	mov    0x8(%eax),%eax
80104684:	05 00 10 00 00       	add    $0x1000,%eax
80104689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010468c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104693:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104696:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104699:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010469d:	ba 8f 6e 10 80       	mov    $0x80106e8f,%edx
801046a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046a5:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801046a7:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801046ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046b1:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801046b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b7:	8b 40 1c             	mov    0x1c(%eax),%eax
801046ba:	83 ec 04             	sub    $0x4,%esp
801046bd:	6a 14                	push   $0x14
801046bf:	6a 00                	push   $0x0
801046c1:	50                   	push   %eax
801046c2:	e8 ca 10 00 00       	call   80105791 <memset>
801046c7:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801046ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046cd:	8b 40 1c             	mov    0x1c(%eax),%eax
801046d0:	ba 51 4f 10 80       	mov    $0x80104f51,%edx
801046d5:	89 50 10             	mov    %edx,0x10(%eax)

  // STUDENT CODE
  // Grab Start Time 
  acquire(&tickslock);
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 e0 5d 11 80       	push   $0x80115de0
801046e0:	e8 49 0e 00 00       	call   8010552e <acquire>
801046e5:	83 c4 10             	add    $0x10,%esp
  p->start_ticks = (uint)ticks;
801046e8:	8b 15 20 66 11 80    	mov    0x80116620,%edx
801046ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f1:	89 50 7c             	mov    %edx,0x7c(%eax)
  release(&tickslock);
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	68 e0 5d 11 80       	push   $0x80115de0
801046fc:	e8 94 0e 00 00       	call   80105595 <release>
80104701:	83 c4 10             	add    $0x10,%esp

  p->cpu_ticks_total = 0;
80104704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104707:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010470e:	00 00 00 
  p->cpu_ticks_in = 0;
80104711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104714:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010471b:	00 00 00 
  return p;
8010471e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104721:	c9                   	leave  
80104722:	c3                   	ret    

80104723 <userinit>:

// Set up first user process.
void
userinit(void)
{
80104723:	55                   	push   %ebp
80104724:	89 e5                	mov    %esp,%ebp
80104726:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104729:	e8 a1 fe ff ff       	call   801045cf <allocproc>
8010472e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104734:	a3 88 c6 10 80       	mov    %eax,0x8010c688
  if((p->pgdir = setupkvm()) == 0)
80104739:	e8 16 3e 00 00       	call   80108554 <setupkvm>
8010473e:	89 c2                	mov    %eax,%edx
80104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104743:	89 50 04             	mov    %edx,0x4(%eax)
80104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104749:	8b 40 04             	mov    0x4(%eax),%eax
8010474c:	85 c0                	test   %eax,%eax
8010474e:	75 0d                	jne    8010475d <userinit+0x3a>
    panic("userinit: out of memory?");
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	68 c8 90 10 80       	push   $0x801090c8
80104758:	e8 09 be ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010475d:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104765:	8b 40 04             	mov    0x4(%eax),%eax
80104768:	83 ec 04             	sub    $0x4,%esp
8010476b:	52                   	push   %edx
8010476c:	68 20 c5 10 80       	push   $0x8010c520
80104771:	50                   	push   %eax
80104772:	e8 37 40 00 00       	call   801087ae <inituvm>
80104777:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010477a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477d:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104786:	8b 40 18             	mov    0x18(%eax),%eax
80104789:	83 ec 04             	sub    $0x4,%esp
8010478c:	6a 4c                	push   $0x4c
8010478e:	6a 00                	push   $0x0
80104790:	50                   	push   %eax
80104791:	e8 fb 0f 00 00       	call   80105791 <memset>
80104796:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479c:	8b 40 18             	mov    0x18(%eax),%eax
8010479f:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a8:	8b 40 18             	mov    0x18(%eax),%eax
801047ab:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b4:	8b 40 18             	mov    0x18(%eax),%eax
801047b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047ba:	8b 52 18             	mov    0x18(%edx),%edx
801047bd:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047c1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801047c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c8:	8b 40 18             	mov    0x18(%eax),%eax
801047cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047ce:	8b 52 18             	mov    0x18(%edx),%edx
801047d1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047d5:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801047d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047dc:	8b 40 18             	mov    0x18(%eax),%eax
801047df:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e9:	8b 40 18             	mov    0x18(%eax),%eax
801047ec:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f6:	8b 40 18             	mov    0x18(%eax),%eax
801047f9:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104803:	83 c0 6c             	add    $0x6c,%eax
80104806:	83 ec 04             	sub    $0x4,%esp
80104809:	6a 10                	push   $0x10
8010480b:	68 e1 90 10 80       	push   $0x801090e1
80104810:	50                   	push   %eax
80104811:	e8 7e 11 00 00       	call   80105994 <safestrcpy>
80104816:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104819:	83 ec 0c             	sub    $0xc,%esp
8010481c:	68 ea 90 10 80       	push   $0x801090ea
80104821:	e8 5e de ff ff       	call   80102684 <namei>
80104826:	83 c4 10             	add    $0x10,%esp
80104829:	89 c2                	mov    %eax,%edx
8010482b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482e:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104834:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
 
  p->uid = INITUID;
8010483b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483e:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80104845:	00 00 00 
  p->gid = INITGID;
80104848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484b:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
80104852:	00 00 00 
}
80104855:	90                   	nop
80104856:	c9                   	leave  
80104857:	c3                   	ret    

80104858 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104858:	55                   	push   %ebp
80104859:	89 e5                	mov    %esp,%ebp
8010485b:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010485e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104864:	8b 00                	mov    (%eax),%eax
80104866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104869:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010486d:	7e 31                	jle    801048a0 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010486f:	8b 55 08             	mov    0x8(%ebp),%edx
80104872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104875:	01 c2                	add    %eax,%edx
80104877:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487d:	8b 40 04             	mov    0x4(%eax),%eax
80104880:	83 ec 04             	sub    $0x4,%esp
80104883:	52                   	push   %edx
80104884:	ff 75 f4             	pushl  -0xc(%ebp)
80104887:	50                   	push   %eax
80104888:	e8 6e 40 00 00       	call   801088fb <allocuvm>
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104897:	75 3e                	jne    801048d7 <growproc+0x7f>
      return -1;
80104899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010489e:	eb 59                	jmp    801048f9 <growproc+0xa1>
  } else if(n < 0){
801048a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048a4:	79 31                	jns    801048d7 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801048a6:	8b 55 08             	mov    0x8(%ebp),%edx
801048a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ac:	01 c2                	add    %eax,%edx
801048ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b4:	8b 40 04             	mov    0x4(%eax),%eax
801048b7:	83 ec 04             	sub    $0x4,%esp
801048ba:	52                   	push   %edx
801048bb:	ff 75 f4             	pushl  -0xc(%ebp)
801048be:	50                   	push   %eax
801048bf:	e8 00 41 00 00       	call   801089c4 <deallocuvm>
801048c4:	83 c4 10             	add    $0x10,%esp
801048c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048ce:	75 07                	jne    801048d7 <growproc+0x7f>
      return -1;
801048d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d5:	eb 22                	jmp    801048f9 <growproc+0xa1>
  }
  proc->sz = sz;
801048d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048e0:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801048e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	50                   	push   %eax
801048ec:	e8 4a 3d 00 00       	call   8010863b <switchuvm>
801048f1:	83 c4 10             	add    $0x10,%esp
  return 0;
801048f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801048f9:	c9                   	leave  
801048fa:	c3                   	ret    

801048fb <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801048fb:	55                   	push   %ebp
801048fc:	89 e5                	mov    %esp,%ebp
801048fe:	57                   	push   %edi
801048ff:	56                   	push   %esi
80104900:	53                   	push   %ebx
80104901:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104904:	e8 c6 fc ff ff       	call   801045cf <allocproc>
80104909:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010490c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104910:	75 0a                	jne    8010491c <fork+0x21>
    return -1;
80104912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104917:	e9 92 01 00 00       	jmp    80104aae <fork+0x1b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010491c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104922:	8b 10                	mov    (%eax),%edx
80104924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492a:	8b 40 04             	mov    0x4(%eax),%eax
8010492d:	83 ec 08             	sub    $0x8,%esp
80104930:	52                   	push   %edx
80104931:	50                   	push   %eax
80104932:	e8 2b 42 00 00       	call   80108b62 <copyuvm>
80104937:	83 c4 10             	add    $0x10,%esp
8010493a:	89 c2                	mov    %eax,%edx
8010493c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010493f:	89 50 04             	mov    %edx,0x4(%eax)
80104942:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104945:	8b 40 04             	mov    0x4(%eax),%eax
80104948:	85 c0                	test   %eax,%eax
8010494a:	75 30                	jne    8010497c <fork+0x81>
    kfree(np->kstack);
8010494c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010494f:	8b 40 08             	mov    0x8(%eax),%eax
80104952:	83 ec 0c             	sub    $0xc,%esp
80104955:	50                   	push   %eax
80104956:	e8 ca e3 ff ff       	call   80102d25 <kfree>
8010495b:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010495e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104961:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104968:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010496b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104972:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104977:	e9 32 01 00 00       	jmp    80104aae <fork+0x1b3>
  }
  np->sz = proc->sz;
8010497c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104982:	8b 10                	mov    (%eax),%edx
80104984:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104987:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104989:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104990:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104993:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104996:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104999:	8b 50 18             	mov    0x18(%eax),%edx
8010499c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a2:	8b 40 18             	mov    0x18(%eax),%eax
801049a5:	89 c3                	mov    %eax,%ebx
801049a7:	b8 13 00 00 00       	mov    $0x13,%eax
801049ac:	89 d7                	mov    %edx,%edi
801049ae:	89 de                	mov    %ebx,%esi
801049b0:	89 c1                	mov    %eax,%ecx
801049b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801049b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b7:	8b 40 18             	mov    0x18(%eax),%eax
801049ba:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801049c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801049c8:	eb 43                	jmp    80104a0d <fork+0x112>
    if(proc->ofile[i])
801049ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049d3:	83 c2 08             	add    $0x8,%edx
801049d6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049da:	85 c0                	test   %eax,%eax
801049dc:	74 2b                	je     80104a09 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
801049de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049e7:	83 c2 08             	add    $0x8,%edx
801049ea:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049ee:	83 ec 0c             	sub    $0xc,%esp
801049f1:	50                   	push   %eax
801049f2:	e8 09 c6 ff ff       	call   80101000 <filedup>
801049f7:	83 c4 10             	add    $0x10,%esp
801049fa:	89 c1                	mov    %eax,%ecx
801049fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a02:	83 c2 08             	add    $0x8,%edx
80104a05:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104a09:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104a0d:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a11:	7e b7                	jle    801049ca <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104a13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a19:	8b 40 68             	mov    0x68(%eax),%eax
80104a1c:	83 ec 0c             	sub    $0xc,%esp
80104a1f:	50                   	push   %eax
80104a20:	e8 17 d0 ff ff       	call   80101a3c <idup>
80104a25:	83 c4 10             	add    $0x10,%esp
80104a28:	89 c2                	mov    %eax,%edx
80104a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a2d:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104a30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a36:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a3c:	83 c0 6c             	add    $0x6c,%eax
80104a3f:	83 ec 04             	sub    $0x4,%esp
80104a42:	6a 10                	push   $0x10
80104a44:	52                   	push   %edx
80104a45:	50                   	push   %eax
80104a46:	e8 49 0f 00 00       	call   80105994 <safestrcpy>
80104a4b:	83 c4 10             	add    $0x10,%esp
 
  //STUDENT CODE copy all ids
  pid = np->pid;
80104a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a51:	8b 40 10             	mov    0x10(%eax),%eax
80104a54:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->uid = proc->uid;
80104a57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a5d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a66:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
80104a6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a72:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a7b:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  
  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104a81:	83 ec 0c             	sub    $0xc,%esp
80104a84:	68 a0 39 11 80       	push   $0x801139a0
80104a89:	e8 a0 0a 00 00       	call   8010552e <acquire>
80104a8e:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a94:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	68 a0 39 11 80       	push   $0x801139a0
80104aa3:	e8 ed 0a 00 00       	call   80105595 <release>
80104aa8:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ab1:	5b                   	pop    %ebx
80104ab2:	5e                   	pop    %esi
80104ab3:	5f                   	pop    %edi
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    

80104ab6 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104ab6:	55                   	push   %ebp
80104ab7:	89 e5                	mov    %esp,%ebp
80104ab9:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104abc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ac3:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104ac8:	39 c2                	cmp    %eax,%edx
80104aca:	75 0d                	jne    80104ad9 <exit+0x23>
    panic("init exiting");
80104acc:	83 ec 0c             	sub    $0xc,%esp
80104acf:	68 ec 90 10 80       	push   $0x801090ec
80104ad4:	e8 8d ba ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104ad9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104ae0:	eb 48                	jmp    80104b2a <exit+0x74>
    if(proc->ofile[fd]){
80104ae2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104aeb:	83 c2 08             	add    $0x8,%edx
80104aee:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104af2:	85 c0                	test   %eax,%eax
80104af4:	74 30                	je     80104b26 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104af6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104afc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104aff:	83 c2 08             	add    $0x8,%edx
80104b02:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b06:	83 ec 0c             	sub    $0xc,%esp
80104b09:	50                   	push   %eax
80104b0a:	e8 42 c5 ff ff       	call   80101051 <fileclose>
80104b0f:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104b12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b18:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b1b:	83 c2 08             	add    $0x8,%edx
80104b1e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104b25:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b26:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104b2a:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104b2e:	7e b2                	jle    80104ae2 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104b30:	e8 74 eb ff ff       	call   801036a9 <begin_op>
  iput(proc->cwd);
80104b35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3b:	8b 40 68             	mov    0x68(%eax),%eax
80104b3e:	83 ec 0c             	sub    $0xc,%esp
80104b41:	50                   	push   %eax
80104b42:	e8 27 d1 ff ff       	call   80101c6e <iput>
80104b47:	83 c4 10             	add    $0x10,%esp
  end_op();
80104b4a:	e8 e6 eb ff ff       	call   80103735 <end_op>
  proc->cwd = 0;
80104b4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b55:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104b5c:	83 ec 0c             	sub    $0xc,%esp
80104b5f:	68 a0 39 11 80       	push   $0x801139a0
80104b64:	e8 c5 09 00 00       	call   8010552e <acquire>
80104b69:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104b6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b72:	8b 40 14             	mov    0x14(%eax),%eax
80104b75:	83 ec 0c             	sub    $0xc,%esp
80104b78:	50                   	push   %eax
80104b79:	e8 c5 04 00 00       	call   80105043 <wakeup1>
80104b7e:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b81:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80104b88:	eb 3f                	jmp    80104bc9 <exit+0x113>
    if(p->parent == proc){
80104b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8d:	8b 50 14             	mov    0x14(%eax),%edx
80104b90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b96:	39 c2                	cmp    %eax,%edx
80104b98:	75 28                	jne    80104bc2 <exit+0x10c>
      p->parent = initproc;
80104b9a:	8b 15 88 c6 10 80    	mov    0x8010c688,%edx
80104ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba3:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba9:	8b 40 0c             	mov    0xc(%eax),%eax
80104bac:	83 f8 05             	cmp    $0x5,%eax
80104baf:	75 11                	jne    80104bc2 <exit+0x10c>
        wakeup1(initproc);
80104bb1:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104bb6:	83 ec 0c             	sub    $0xc,%esp
80104bb9:	50                   	push   %eax
80104bba:	e8 84 04 00 00       	call   80105043 <wakeup1>
80104bbf:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc2:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104bc9:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104bd0:	72 b8                	jb     80104b8a <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104bd2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd8:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104bdf:	e8 1b 02 00 00       	call   80104dff <sched>
  panic("zombie exit");
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	68 f9 90 10 80       	push   $0x801090f9
80104bec:	e8 75 b9 ff ff       	call   80100566 <panic>

80104bf1 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104bf1:	55                   	push   %ebp
80104bf2:	89 e5                	mov    %esp,%ebp
80104bf4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104bf7:	83 ec 0c             	sub    $0xc,%esp
80104bfa:	68 a0 39 11 80       	push   $0x801139a0
80104bff:	e8 2a 09 00 00       	call   8010552e <acquire>
80104c04:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104c07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c0e:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80104c15:	e9 a9 00 00 00       	jmp    80104cc3 <wait+0xd2>
      if(p->parent != proc)
80104c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1d:	8b 50 14             	mov    0x14(%eax),%edx
80104c20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c26:	39 c2                	cmp    %eax,%edx
80104c28:	0f 85 8d 00 00 00    	jne    80104cbb <wait+0xca>
        continue;
      havekids = 1;
80104c2e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c38:	8b 40 0c             	mov    0xc(%eax),%eax
80104c3b:	83 f8 05             	cmp    $0x5,%eax
80104c3e:	75 7c                	jne    80104cbc <wait+0xcb>
        // Found one.
        pid = p->pid;
80104c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c43:	8b 40 10             	mov    0x10(%eax),%eax
80104c46:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c4c:	8b 40 08             	mov    0x8(%eax),%eax
80104c4f:	83 ec 0c             	sub    $0xc,%esp
80104c52:	50                   	push   %eax
80104c53:	e8 cd e0 ff ff       	call   80102d25 <kfree>
80104c58:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c68:	8b 40 04             	mov    0x4(%eax),%eax
80104c6b:	83 ec 0c             	sub    $0xc,%esp
80104c6e:	50                   	push   %eax
80104c6f:	e8 0d 3e 00 00       	call   80108a81 <freevm>
80104c74:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c84:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c98:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c9f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	68 a0 39 11 80       	push   $0x801139a0
80104cae:	e8 e2 08 00 00       	call   80105595 <release>
80104cb3:	83 c4 10             	add    $0x10,%esp
        return pid;
80104cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cb9:	eb 5b                	jmp    80104d16 <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104cbb:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cbc:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104cc3:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104cca:	0f 82 4a ff ff ff    	jb     80104c1a <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104cd4:	74 0d                	je     80104ce3 <wait+0xf2>
80104cd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cdc:	8b 40 24             	mov    0x24(%eax),%eax
80104cdf:	85 c0                	test   %eax,%eax
80104ce1:	74 17                	je     80104cfa <wait+0x109>
      release(&ptable.lock);
80104ce3:	83 ec 0c             	sub    $0xc,%esp
80104ce6:	68 a0 39 11 80       	push   $0x801139a0
80104ceb:	e8 a5 08 00 00       	call   80105595 <release>
80104cf0:	83 c4 10             	add    $0x10,%esp
      return -1;
80104cf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf8:	eb 1c                	jmp    80104d16 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104cfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d00:	83 ec 08             	sub    $0x8,%esp
80104d03:	68 a0 39 11 80       	push   $0x801139a0
80104d08:	50                   	push   %eax
80104d09:	e8 89 02 00 00       	call   80104f97 <sleep>
80104d0e:	83 c4 10             	add    $0x10,%esp
  }
80104d11:	e9 f1 fe ff ff       	jmp    80104c07 <wait+0x16>
}
80104d16:	c9                   	leave  
80104d17:	c3                   	ret    

80104d18 <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3
// original xv6 scheduler. Use if CS333_P3 NOT defined.
void
scheduler(void)
{
80104d18:	55                   	push   %ebp
80104d19:	89 e5                	mov    %esp,%ebp
80104d1b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  uint now;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104d1e:	e8 87 f8 ff ff       	call   801045aa <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104d23:	83 ec 0c             	sub    $0xc,%esp
80104d26:	68 a0 39 11 80       	push   $0x801139a0
80104d2b:	e8 fe 07 00 00       	call   8010552e <acquire>
80104d30:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d33:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80104d3a:	e9 9e 00 00 00       	jmp    80104ddd <scheduler+0xc5>
      if(p->state != RUNNABLE)
80104d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d42:	8b 40 0c             	mov    0xc(%eax),%eax
80104d45:	83 f8 03             	cmp    $0x3,%eax
80104d48:	0f 85 87 00 00 00    	jne    80104dd5 <scheduler+0xbd>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d51:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104d57:	83 ec 0c             	sub    $0xc,%esp
80104d5a:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5d:	e8 d9 38 00 00       	call   8010863b <switchuvm>
80104d62:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d68:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      
      acquire(&tickslock);
80104d6f:	83 ec 0c             	sub    $0xc,%esp
80104d72:	68 e0 5d 11 80       	push   $0x80115de0
80104d77:	e8 b2 07 00 00       	call   8010552e <acquire>
80104d7c:	83 c4 10             	add    $0x10,%esp
      now = (uint)ticks;
80104d7f:	a1 20 66 11 80       	mov    0x80116620,%eax
80104d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
      release(&tickslock);
80104d87:	83 ec 0c             	sub    $0xc,%esp
80104d8a:	68 e0 5d 11 80       	push   $0x80115de0
80104d8f:	e8 01 08 00 00       	call   80105595 <release>
80104d94:	83 c4 10             	add    $0x10,%esp
      p->cpu_ticks_in = now;
80104d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d9d:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

      swtch(&cpu->scheduler, proc->context);
80104da3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da9:	8b 40 1c             	mov    0x1c(%eax),%eax
80104dac:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104db3:	83 c2 04             	add    $0x4,%edx
80104db6:	83 ec 08             	sub    $0x8,%esp
80104db9:	50                   	push   %eax
80104dba:	52                   	push   %edx
80104dbb:	e8 45 0c 00 00       	call   80105a05 <swtch>
80104dc0:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104dc3:	e8 56 38 00 00       	call   8010861e <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104dc8:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104dcf:	00 00 00 00 
80104dd3:	eb 01                	jmp    80104dd6 <scheduler+0xbe>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104dd5:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dd6:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104ddd:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104de4:	0f 82 55 ff ff ff    	jb     80104d3f <scheduler+0x27>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104dea:	83 ec 0c             	sub    $0xc,%esp
80104ded:	68 a0 39 11 80       	push   $0x801139a0
80104df2:	e8 9e 07 00 00       	call   80105595 <release>
80104df7:	83 c4 10             	add    $0x10,%esp

  }
80104dfa:	e9 1f ff ff ff       	jmp    80104d1e <scheduler+0x6>

80104dff <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104dff:	55                   	push   %ebp
80104e00:	89 e5                	mov    %esp,%ebp
80104e02:	53                   	push   %ebx
80104e03:	83 ec 14             	sub    $0x14,%esp
  int intena;
  uint now;

  if(!holding(&ptable.lock))
80104e06:	83 ec 0c             	sub    $0xc,%esp
80104e09:	68 a0 39 11 80       	push   $0x801139a0
80104e0e:	e8 4e 08 00 00       	call   80105661 <holding>
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	85 c0                	test   %eax,%eax
80104e18:	75 0d                	jne    80104e27 <sched+0x28>
    panic("sched ptable.lock");
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	68 05 91 10 80       	push   $0x80109105
80104e22:	e8 3f b7 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104e27:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e2d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e33:	83 f8 01             	cmp    $0x1,%eax
80104e36:	74 0d                	je     80104e45 <sched+0x46>
    panic("sched locks");
80104e38:	83 ec 0c             	sub    $0xc,%esp
80104e3b:	68 17 91 10 80       	push   $0x80109117
80104e40:	e8 21 b7 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104e45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e4b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e4e:	83 f8 04             	cmp    $0x4,%eax
80104e51:	75 0d                	jne    80104e60 <sched+0x61>
    panic("sched running");
80104e53:	83 ec 0c             	sub    $0xc,%esp
80104e56:	68 23 91 10 80       	push   $0x80109123
80104e5b:	e8 06 b7 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104e60:	e8 35 f7 ff ff       	call   8010459a <readeflags>
80104e65:	25 00 02 00 00       	and    $0x200,%eax
80104e6a:	85 c0                	test   %eax,%eax
80104e6c:	74 0d                	je     80104e7b <sched+0x7c>
    panic("sched interruptible");
80104e6e:	83 ec 0c             	sub    $0xc,%esp
80104e71:	68 31 91 10 80       	push   $0x80109131
80104e76:	e8 eb b6 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104e7b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e81:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e87:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&tickslock);
80104e8a:	83 ec 0c             	sub    $0xc,%esp
80104e8d:	68 e0 5d 11 80       	push   $0x80115de0
80104e92:	e8 97 06 00 00       	call   8010552e <acquire>
80104e97:	83 c4 10             	add    $0x10,%esp
  now = (uint)ticks;
80104e9a:	a1 20 66 11 80       	mov    0x80116620,%eax
80104e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  release(&tickslock);
80104ea2:	83 ec 0c             	sub    $0xc,%esp
80104ea5:	68 e0 5d 11 80       	push   $0x80115de0
80104eaa:	e8 e6 06 00 00       	call   80105595 <release>
80104eaf:	83 c4 10             	add    $0x10,%esp

  proc->cpu_ticks_total = proc->cpu_ticks_total + (now - proc->cpu_ticks_in);
80104eb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ebf:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104ec5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ecc:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80104ed2:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80104ed5:	29 d3                	sub    %edx,%ebx
80104ed7:	89 da                	mov    %ebx,%edx
80104ed9:	01 ca                	add    %ecx,%edx
80104edb:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  
  swtch(&proc->context, cpu->scheduler);
80104ee1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ee7:	8b 40 04             	mov    0x4(%eax),%eax
80104eea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ef1:	83 c2 1c             	add    $0x1c,%edx
80104ef4:	83 ec 08             	sub    $0x8,%esp
80104ef7:	50                   	push   %eax
80104ef8:	52                   	push   %edx
80104ef9:	e8 07 0b 00 00       	call   80105a05 <swtch>
80104efe:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104f01:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f0a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104f10:	90                   	nop
80104f11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f14:	c9                   	leave  
80104f15:	c3                   	ret    

80104f16 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104f16:	55                   	push   %ebp
80104f17:	89 e5                	mov    %esp,%ebp
80104f19:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	68 a0 39 11 80       	push   $0x801139a0
80104f24:	e8 05 06 00 00       	call   8010552e <acquire>
80104f29:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104f2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f32:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104f39:	e8 c1 fe ff ff       	call   80104dff <sched>
  release(&ptable.lock);
80104f3e:	83 ec 0c             	sub    $0xc,%esp
80104f41:	68 a0 39 11 80       	push   $0x801139a0
80104f46:	e8 4a 06 00 00       	call   80105595 <release>
80104f4b:	83 c4 10             	add    $0x10,%esp
}
80104f4e:	90                   	nop
80104f4f:	c9                   	leave  
80104f50:	c3                   	ret    

80104f51 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104f51:	55                   	push   %ebp
80104f52:	89 e5                	mov    %esp,%ebp
80104f54:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104f57:	83 ec 0c             	sub    $0xc,%esp
80104f5a:	68 a0 39 11 80       	push   $0x801139a0
80104f5f:	e8 31 06 00 00       	call   80105595 <release>
80104f64:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104f67:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104f6c:	85 c0                	test   %eax,%eax
80104f6e:	74 24                	je     80104f94 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104f70:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104f77:	00 00 00 
    iinit(ROOTDEV);
80104f7a:	83 ec 0c             	sub    $0xc,%esp
80104f7d:	6a 01                	push   $0x1
80104f7f:	e8 9e c7 ff ff       	call   80101722 <iinit>
80104f84:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104f87:	83 ec 0c             	sub    $0xc,%esp
80104f8a:	6a 01                	push   $0x1
80104f8c:	e8 fa e4 ff ff       	call   8010348b <initlog>
80104f91:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104f94:	90                   	nop
80104f95:	c9                   	leave  
80104f96:	c3                   	ret    

80104f97 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104f97:	55                   	push   %ebp
80104f98:	89 e5                	mov    %esp,%ebp
80104f9a:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104f9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa3:	85 c0                	test   %eax,%eax
80104fa5:	75 0d                	jne    80104fb4 <sleep+0x1d>
    panic("sleep");
80104fa7:	83 ec 0c             	sub    $0xc,%esp
80104faa:	68 45 91 10 80       	push   $0x80109145
80104faf:	e8 b2 b5 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104fb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104fb8:	75 0d                	jne    80104fc7 <sleep+0x30>
    panic("sleep without lk");
80104fba:	83 ec 0c             	sub    $0xc,%esp
80104fbd:	68 4b 91 10 80       	push   $0x8010914b
80104fc2:	e8 9f b5 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104fc7:	81 7d 0c a0 39 11 80 	cmpl   $0x801139a0,0xc(%ebp)
80104fce:	74 1e                	je     80104fee <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104fd0:	83 ec 0c             	sub    $0xc,%esp
80104fd3:	68 a0 39 11 80       	push   $0x801139a0
80104fd8:	e8 51 05 00 00       	call   8010552e <acquire>
80104fdd:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
80104fe3:	ff 75 0c             	pushl  0xc(%ebp)
80104fe6:	e8 aa 05 00 00       	call   80105595 <release>
80104feb:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104fee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ff7:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104ffa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105000:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80105007:	e8 f3 fd ff ff       	call   80104dff <sched>

  // Tidy up.
  proc->chan = 0;
8010500c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105012:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80105019:	81 7d 0c a0 39 11 80 	cmpl   $0x801139a0,0xc(%ebp)
80105020:	74 1e                	je     80105040 <sleep+0xa9>
    release(&ptable.lock);
80105022:	83 ec 0c             	sub    $0xc,%esp
80105025:	68 a0 39 11 80       	push   $0x801139a0
8010502a:	e8 66 05 00 00       	call   80105595 <release>
8010502f:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80105032:	83 ec 0c             	sub    $0xc,%esp
80105035:	ff 75 0c             	pushl  0xc(%ebp)
80105038:	e8 f1 04 00 00       	call   8010552e <acquire>
8010503d:	83 c4 10             	add    $0x10,%esp
  }
}
80105040:	90                   	nop
80105041:	c9                   	leave  
80105042:	c3                   	ret    

80105043 <wakeup1>:

// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80105043:	55                   	push   %ebp
80105044:	89 e5                	mov    %esp,%ebp
80105046:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105049:	c7 45 fc d4 39 11 80 	movl   $0x801139d4,-0x4(%ebp)
80105050:	eb 27                	jmp    80105079 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80105052:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105055:	8b 40 0c             	mov    0xc(%eax),%eax
80105058:	83 f8 02             	cmp    $0x2,%eax
8010505b:	75 15                	jne    80105072 <wakeup1+0x2f>
8010505d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105060:	8b 40 20             	mov    0x20(%eax),%eax
80105063:	3b 45 08             	cmp    0x8(%ebp),%eax
80105066:	75 0a                	jne    80105072 <wakeup1+0x2f>
      p->state = RUNNABLE;
80105068:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010506b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105072:	81 45 fc 90 00 00 00 	addl   $0x90,-0x4(%ebp)
80105079:	81 7d fc d4 5d 11 80 	cmpl   $0x80115dd4,-0x4(%ebp)
80105080:	72 d0                	jb     80105052 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80105082:	90                   	nop
80105083:	c9                   	leave  
80105084:	c3                   	ret    

80105085 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105085:	55                   	push   %ebp
80105086:	89 e5                	mov    %esp,%ebp
80105088:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010508b:	83 ec 0c             	sub    $0xc,%esp
8010508e:	68 a0 39 11 80       	push   $0x801139a0
80105093:	e8 96 04 00 00       	call   8010552e <acquire>
80105098:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010509b:	83 ec 0c             	sub    $0xc,%esp
8010509e:	ff 75 08             	pushl  0x8(%ebp)
801050a1:	e8 9d ff ff ff       	call   80105043 <wakeup1>
801050a6:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801050a9:	83 ec 0c             	sub    $0xc,%esp
801050ac:	68 a0 39 11 80       	push   $0x801139a0
801050b1:	e8 df 04 00 00       	call   80105595 <release>
801050b6:	83 c4 10             	add    $0x10,%esp
}
801050b9:	90                   	nop
801050ba:	c9                   	leave  
801050bb:	c3                   	ret    

801050bc <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801050bc:	55                   	push   %ebp
801050bd:	89 e5                	mov    %esp,%ebp
801050bf:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801050c2:	83 ec 0c             	sub    $0xc,%esp
801050c5:	68 a0 39 11 80       	push   $0x801139a0
801050ca:	e8 5f 04 00 00       	call   8010552e <acquire>
801050cf:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050d2:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
801050d9:	eb 4a                	jmp    80105125 <kill+0x69>
    if(p->pid == pid){
801050db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050de:	8b 50 10             	mov    0x10(%eax),%edx
801050e1:	8b 45 08             	mov    0x8(%ebp),%eax
801050e4:	39 c2                	cmp    %eax,%edx
801050e6:	75 36                	jne    8010511e <kill+0x62>
      p->killed = 1;
801050e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050eb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801050f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f5:	8b 40 0c             	mov    0xc(%eax),%eax
801050f8:	83 f8 02             	cmp    $0x2,%eax
801050fb:	75 0a                	jne    80105107 <kill+0x4b>
        p->state = RUNNABLE;
801050fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105100:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105107:	83 ec 0c             	sub    $0xc,%esp
8010510a:	68 a0 39 11 80       	push   $0x801139a0
8010510f:	e8 81 04 00 00       	call   80105595 <release>
80105114:	83 c4 10             	add    $0x10,%esp
      return 0;
80105117:	b8 00 00 00 00       	mov    $0x0,%eax
8010511c:	eb 25                	jmp    80105143 <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010511e:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80105125:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
8010512c:	72 ad                	jb     801050db <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
8010512e:	83 ec 0c             	sub    $0xc,%esp
80105131:	68 a0 39 11 80       	push   $0x801139a0
80105136:	e8 5a 04 00 00       	call   80105595 <release>
8010513b:	83 c4 10             	add    $0x10,%esp
  return -1;
8010513e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105143:	c9                   	leave  
80105144:	c3                   	ret    

80105145 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105145:	55                   	push   %ebp
80105146:	89 e5                	mov    %esp,%ebp
80105148:	57                   	push   %edi
80105149:	56                   	push   %esi
8010514a:	53                   	push   %ebx
8010514b:	83 ec 4c             	sub    $0x4c,%esp
  char *state;
  uint pc[10];
  
  uint now;         //Snag the current ticks and cast

  acquire(&tickslock);
8010514e:	83 ec 0c             	sub    $0xc,%esp
80105151:	68 e0 5d 11 80       	push   $0x80115de0
80105156:	e8 d3 03 00 00       	call   8010552e <acquire>
8010515b:	83 c4 10             	add    $0x10,%esp
  now = (uint)ticks;
8010515e:	a1 20 66 11 80       	mov    0x80116620,%eax
80105163:	89 45 d8             	mov    %eax,-0x28(%ebp)
  release(&tickslock);
80105166:	83 ec 0c             	sub    $0xc,%esp
80105169:	68 e0 5d 11 80       	push   $0x80115de0
8010516e:	e8 22 04 00 00       	call   80105595 <release>
80105173:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105176:	c7 45 e0 d4 39 11 80 	movl   $0x801139d4,-0x20(%ebp)
8010517d:	e9 4c 01 00 00       	jmp    801052ce <procdump+0x189>
    if(p->state == UNUSED)
80105182:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105185:	8b 40 0c             	mov    0xc(%eax),%eax
80105188:	85 c0                	test   %eax,%eax
8010518a:	0f 84 36 01 00 00    	je     801052c6 <procdump+0x181>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105190:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105193:	8b 40 0c             	mov    0xc(%eax),%eax
80105196:	83 f8 05             	cmp    $0x5,%eax
80105199:	77 23                	ja     801051be <procdump+0x79>
8010519b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010519e:	8b 40 0c             	mov    0xc(%eax),%eax
801051a1:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801051a8:	85 c0                	test   %eax,%eax
801051aa:	74 12                	je     801051be <procdump+0x79>
      state = states[p->state];
801051ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051af:	8b 40 0c             	mov    0xc(%eax),%eax
801051b2:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801051b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801051bc:	eb 07                	jmp    801051c5 <procdump+0x80>
    else
      state = "???";
801051be:	c7 45 dc 5c 91 10 80 	movl   $0x8010915c,-0x24(%ebp)
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
             p->cpu_ticks_total % 100);
801051c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051c8:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
801051ce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801051d3:	89 c8                	mov    %ecx,%eax
801051d5:	f7 e2                	mul    %edx
801051d7:	89 d3                	mov    %edx,%ebx
801051d9:	c1 eb 05             	shr    $0x5,%ebx
801051dc:	6b c3 64             	imul   $0x64,%ebx,%eax
801051df:	29 c1                	sub    %eax,%ecx
801051e1:	89 cb                	mov    %ecx,%ebx
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
801051e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051e6:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
801051ec:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801051f1:	f7 e2                	mul    %edx
801051f3:	89 d7                	mov    %edx,%edi
801051f5:	c1 ef 05             	shr    $0x5,%edi
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
801051f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051fb:	8b 40 7c             	mov    0x7c(%eax),%eax
801051fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
80105201:	89 d6                	mov    %edx,%esi
80105203:	29 c6                	sub    %eax,%esi
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
80105205:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010520a:	89 f0                	mov    %esi,%eax
8010520c:	f7 e2                	mul    %edx
8010520e:	89 d1                	mov    %edx,%ecx
80105210:	c1 e9 05             	shr    $0x5,%ecx
80105213:	6b c1 64             	imul   $0x64,%ecx,%eax
80105216:	29 c6                	sub    %eax,%esi
80105218:	89 f1                	mov    %esi,%ecx
            (now - p->start_ticks) / 100, 
8010521a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010521d:	8b 40 7c             	mov    0x7c(%eax),%eax
80105220:	8b 55 d8             	mov    -0x28(%ebp),%edx
80105223:	29 c2                	sub    %eax,%edx
80105225:	89 d0                	mov    %edx,%eax
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s %d.%d %d.%d", p->pid, state, p->name, 
80105227:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010522c:	f7 e2                	mul    %edx
8010522e:	89 d6                	mov    %edx,%esi
80105230:	c1 ee 05             	shr    $0x5,%esi
80105233:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105236:	8d 50 6c             	lea    0x6c(%eax),%edx
80105239:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010523c:	8b 40 10             	mov    0x10(%eax),%eax
8010523f:	53                   	push   %ebx
80105240:	57                   	push   %edi
80105241:	51                   	push   %ecx
80105242:	56                   	push   %esi
80105243:	52                   	push   %edx
80105244:	ff 75 dc             	pushl  -0x24(%ebp)
80105247:	50                   	push   %eax
80105248:	68 60 91 10 80       	push   $0x80109160
8010524d:	e8 74 b1 ff ff       	call   801003c6 <cprintf>
80105252:	83 c4 20             	add    $0x20,%esp
            (now - p->start_ticks) / 100, 
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
             p->cpu_ticks_total % 100);
    if(p->state == SLEEPING){
80105255:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105258:	8b 40 0c             	mov    0xc(%eax),%eax
8010525b:	83 f8 02             	cmp    $0x2,%eax
8010525e:	75 54                	jne    801052b4 <procdump+0x16f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105260:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105263:	8b 40 1c             	mov    0x1c(%eax),%eax
80105266:	8b 40 0c             	mov    0xc(%eax),%eax
80105269:	83 c0 08             	add    $0x8,%eax
8010526c:	89 c2                	mov    %eax,%edx
8010526e:	83 ec 08             	sub    $0x8,%esp
80105271:	8d 45 b0             	lea    -0x50(%ebp),%eax
80105274:	50                   	push   %eax
80105275:	52                   	push   %edx
80105276:	e8 6c 03 00 00       	call   801055e7 <getcallerpcs>
8010527b:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010527e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105285:	eb 1c                	jmp    801052a3 <procdump+0x15e>
        cprintf(" %p", pc[i]);
80105287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010528a:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
8010528e:	83 ec 08             	sub    $0x8,%esp
80105291:	50                   	push   %eax
80105292:	68 75 91 10 80       	push   $0x80109175
80105297:	e8 2a b1 ff ff       	call   801003c6 <cprintf>
8010529c:	83 c4 10             	add    $0x10,%esp
            (now - p->start_ticks) % 100,
             p->cpu_ticks_total / 100,
             p->cpu_ticks_total % 100);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010529f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801052a3:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
801052a7:	7f 0b                	jg     801052b4 <procdump+0x16f>
801052a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801052ac:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
801052b0:	85 c0                	test   %eax,%eax
801052b2:	75 d3                	jne    80105287 <procdump+0x142>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	68 79 91 10 80       	push   $0x80109179
801052bc:	e8 05 b1 ff ff       	call   801003c6 <cprintf>
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	eb 01                	jmp    801052c7 <procdump+0x182>
  now = (uint)ticks;
  release(&tickslock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801052c6:	90                   	nop

  acquire(&tickslock);
  now = (uint)ticks;
  release(&tickslock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052c7:	81 45 e0 90 00 00 00 	addl   $0x90,-0x20(%ebp)
801052ce:	81 7d e0 d4 5d 11 80 	cmpl   $0x80115dd4,-0x20(%ebp)
801052d5:	0f 82 a7 fe ff ff    	jb     80105182 <procdump+0x3d>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801052db:	90                   	nop
801052dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052df:	5b                   	pop    %ebx
801052e0:	5e                   	pop    %esi
801052e1:	5f                   	pop    %edi
801052e2:	5d                   	pop    %ebp
801052e3:	c3                   	ret    

801052e4 <sys_getprocs>:


int
sys_getprocs(void)
{  
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	83 ec 28             	sub    $0x28,%esp
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };

  uint now;
  acquire(&tickslock);
801052ea:	83 ec 0c             	sub    $0xc,%esp
801052ed:	68 e0 5d 11 80       	push   $0x80115de0
801052f2:	e8 37 02 00 00       	call   8010552e <acquire>
801052f7:	83 c4 10             	add    $0x10,%esp
  now = (uint)ticks;
801052fa:	a1 20 66 11 80       	mov    0x80116620,%eax
801052ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  release(&tickslock);
80105302:	83 ec 0c             	sub    $0xc,%esp
80105305:	68 e0 5d 11 80       	push   $0x80115de0
8010530a:	e8 86 02 00 00       	call   80105595 <release>
8010530f:	83 c4 10             	add    $0x10,%esp


    struct proc* p;
    struct uproc* up;
    int MAX = 0;
80105312:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    int i = 0;
80105319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    if( argint(0, &MAX) == -1)
80105320:	83 ec 08             	sub    $0x8,%esp
80105323:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105326:	50                   	push   %eax
80105327:	6a 00                	push   $0x0
80105329:	e8 88 07 00 00       	call   80105ab6 <argint>
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	83 f8 ff             	cmp    $0xffffffff,%eax
80105334:	75 0a                	jne    80105340 <sys_getprocs+0x5c>
        return -1;
80105336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533b:	e9 92 01 00 00       	jmp    801054d2 <sys_getprocs+0x1ee>

    if(argptr(1, (char**)&up, sizeof(*up)) < 0)
80105340:	83 ec 04             	sub    $0x4,%esp
80105343:	6a 5c                	push   $0x5c
80105345:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105348:	50                   	push   %eax
80105349:	6a 01                	push   $0x1
8010534b:	e8 8e 07 00 00       	call   80105ade <argptr>
80105350:	83 c4 10             	add    $0x10,%esp
80105353:	85 c0                	test   %eax,%eax
80105355:	79 0a                	jns    80105361 <sys_getprocs+0x7d>
        return -1;
80105357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535c:	e9 71 01 00 00       	jmp    801054d2 <sys_getprocs+0x1ee>
 
  acquire(&ptable.lock);
80105361:	83 ec 0c             	sub    $0xc,%esp
80105364:	68 a0 39 11 80       	push   $0x801139a0
80105369:	e8 c0 01 00 00       	call   8010552e <acquire>
8010536e:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105371:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80105378:	e9 35 01 00 00       	jmp    801054b2 <sys_getprocs+0x1ce>
  {

        if( p->state && i < MAX){ 
8010537d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105380:	8b 40 0c             	mov    0xc(%eax),%eax
80105383:	85 c0                	test   %eax,%eax
80105385:	0f 84 20 01 00 00    	je     801054ab <sys_getprocs+0x1c7>
8010538b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010538e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80105391:	0f 8d 14 01 00 00    	jge    801054ab <sys_getprocs+0x1c7>

            up[i].pid = p->pid;
80105397:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010539a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010539d:	6b c0 5c             	imul   $0x5c,%eax,%eax
801053a0:	01 c2                	add    %eax,%edx
801053a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a5:	8b 40 10             	mov    0x10(%eax),%eax
801053a8:	89 02                	mov    %eax,(%edx)
            up[i].uid = p->uid;
801053aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
801053ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053b0:	6b c0 5c             	imul   $0x5c,%eax,%eax
801053b3:	01 c2                	add    %eax,%edx
801053b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b8:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801053be:	89 42 04             	mov    %eax,0x4(%edx)
            up[i].gid = p->gid;
801053c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801053c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053c7:	6b c0 5c             	imul   $0x5c,%eax,%eax
801053ca:	01 c2                	add    %eax,%edx
801053cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801053d5:	89 42 08             	mov    %eax,0x8(%edx)
            up[i].CPU_total_ticks = p->cpu_ticks_total;
801053d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801053db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053de:	6b c0 5c             	imul   $0x5c,%eax,%eax
801053e1:	01 c2                	add    %eax,%edx
801053e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e6:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801053ec:	89 42 14             	mov    %eax,0x14(%edx)
            up[i].elapsed_ticks = now - p->start_ticks;
801053ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
801053f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f5:	6b c0 5c             	imul   $0x5c,%eax,%eax
801053f8:	01 c2                	add    %eax,%edx
801053fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053fd:	8b 40 7c             	mov    0x7c(%eax),%eax
80105400:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80105403:	29 c1                	sub    %eax,%ecx
80105405:	89 c8                	mov    %ecx,%eax
80105407:	89 42 10             	mov    %eax,0x10(%edx)
            up[i].size = p->sz;
8010540a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010540d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105410:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105413:	01 c2                	add    %eax,%edx
80105415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105418:	8b 00                	mov    (%eax),%eax
8010541a:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(up[i].name, p->name, sizeof(p->name));
8010541d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105420:	8d 50 6c             	lea    0x6c(%eax),%edx
80105423:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80105426:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105429:	6b c0 5c             	imul   $0x5c,%eax,%eax
8010542c:	01 c8                	add    %ecx,%eax
8010542e:	83 c0 3c             	add    $0x3c,%eax
80105431:	83 ec 04             	sub    $0x4,%esp
80105434:	6a 10                	push   $0x10
80105436:	52                   	push   %edx
80105437:	50                   	push   %eax
80105438:	e8 57 05 00 00       	call   80105994 <safestrcpy>
8010543d:	83 c4 10             	add    $0x10,%esp
            safestrcpy(up[i].state, states[p->state], sizeof(p->state));
80105440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105443:	8b 40 0c             	mov    0xc(%eax),%eax
80105446:	8b 04 85 24 c0 10 80 	mov    -0x7fef3fdc(,%eax,4),%eax
8010544d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
80105450:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105453:	6b d2 5c             	imul   $0x5c,%edx,%edx
80105456:	01 ca                	add    %ecx,%edx
80105458:	83 c2 18             	add    $0x18,%edx
8010545b:	83 ec 04             	sub    $0x4,%esp
8010545e:	6a 04                	push   $0x4
80105460:	50                   	push   %eax
80105461:	52                   	push   %edx
80105462:	e8 2d 05 00 00       	call   80105994 <safestrcpy>
80105467:	83 c4 10             	add    $0x10,%esp
            if(up[i].pid == 1)
8010546a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010546d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105470:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105473:	01 d0                	add    %edx,%eax
80105475:	8b 00                	mov    (%eax),%eax
80105477:	83 f8 01             	cmp    $0x1,%eax
8010547a:	75 14                	jne    80105490 <sys_getprocs+0x1ac>
                up[i].ppid = 1;
8010547c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010547f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105482:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105485:	01 d0                	add    %edx,%eax
80105487:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
8010548e:	eb 17                	jmp    801054a7 <sys_getprocs+0x1c3>
            else
                up[i].ppid = p->parent->pid;
80105490:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105496:	6b c0 5c             	imul   $0x5c,%eax,%eax
80105499:	01 c2                	add    %eax,%edx
8010549b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010549e:	8b 40 14             	mov    0x14(%eax),%eax
801054a1:	8b 40 10             	mov    0x10(%eax),%eax
801054a4:	89 42 0c             	mov    %eax,0xc(%edx)
            i++;
801054a7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(argptr(1, (char**)&up, sizeof(*up)) < 0)
        return -1;
 
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801054ab:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801054b2:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
801054b9:	0f 82 be fe ff ff    	jb     8010537d <sys_getprocs+0x99>
            else
                up[i].ppid = p->parent->pid;
            i++;
        }
  }
  release(&ptable.lock);
801054bf:	83 ec 0c             	sub    $0xc,%esp
801054c2:	68 a0 39 11 80       	push   $0x801139a0
801054c7:	e8 c9 00 00 00       	call   80105595 <release>
801054cc:	83 c4 10             	add    $0x10,%esp
  return i;
801054cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801054d2:	c9                   	leave  
801054d3:	c3                   	ret    

801054d4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801054d4:	55                   	push   %ebp
801054d5:	89 e5                	mov    %esp,%ebp
801054d7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801054da:	9c                   	pushf  
801054db:	58                   	pop    %eax
801054dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801054df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054e2:	c9                   	leave  
801054e3:	c3                   	ret    

801054e4 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801054e7:	fa                   	cli    
}
801054e8:	90                   	nop
801054e9:	5d                   	pop    %ebp
801054ea:	c3                   	ret    

801054eb <sti>:

static inline void
sti(void)
{
801054eb:	55                   	push   %ebp
801054ec:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801054ee:	fb                   	sti    
}
801054ef:	90                   	nop
801054f0:	5d                   	pop    %ebp
801054f1:	c3                   	ret    

801054f2 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801054f2:	55                   	push   %ebp
801054f3:	89 e5                	mov    %esp,%ebp
801054f5:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801054f8:	8b 55 08             	mov    0x8(%ebp),%edx
801054fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801054fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105501:	f0 87 02             	lock xchg %eax,(%edx)
80105504:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105507:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010550a:	c9                   	leave  
8010550b:	c3                   	ret    

8010550c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010550c:	55                   	push   %ebp
8010550d:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010550f:	8b 45 08             	mov    0x8(%ebp),%eax
80105512:	8b 55 0c             	mov    0xc(%ebp),%edx
80105515:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105518:	8b 45 08             	mov    0x8(%ebp),%eax
8010551b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105521:	8b 45 08             	mov    0x8(%ebp),%eax
80105524:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010552b:	90                   	nop
8010552c:	5d                   	pop    %ebp
8010552d:	c3                   	ret    

8010552e <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010552e:	55                   	push   %ebp
8010552f:	89 e5                	mov    %esp,%ebp
80105531:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105534:	e8 52 01 00 00       	call   8010568b <pushcli>
  if(holding(lk))
80105539:	8b 45 08             	mov    0x8(%ebp),%eax
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	50                   	push   %eax
80105540:	e8 1c 01 00 00       	call   80105661 <holding>
80105545:	83 c4 10             	add    $0x10,%esp
80105548:	85 c0                	test   %eax,%eax
8010554a:	74 0d                	je     80105559 <acquire+0x2b>
    panic("acquire");
8010554c:	83 ec 0c             	sub    $0xc,%esp
8010554f:	68 a5 91 10 80       	push   $0x801091a5
80105554:	e8 0d b0 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105559:	90                   	nop
8010555a:	8b 45 08             	mov    0x8(%ebp),%eax
8010555d:	83 ec 08             	sub    $0x8,%esp
80105560:	6a 01                	push   $0x1
80105562:	50                   	push   %eax
80105563:	e8 8a ff ff ff       	call   801054f2 <xchg>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	85 c0                	test   %eax,%eax
8010556d:	75 eb                	jne    8010555a <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010556f:	8b 45 08             	mov    0x8(%ebp),%eax
80105572:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105579:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010557c:	8b 45 08             	mov    0x8(%ebp),%eax
8010557f:	83 c0 0c             	add    $0xc,%eax
80105582:	83 ec 08             	sub    $0x8,%esp
80105585:	50                   	push   %eax
80105586:	8d 45 08             	lea    0x8(%ebp),%eax
80105589:	50                   	push   %eax
8010558a:	e8 58 00 00 00       	call   801055e7 <getcallerpcs>
8010558f:	83 c4 10             	add    $0x10,%esp
}
80105592:	90                   	nop
80105593:	c9                   	leave  
80105594:	c3                   	ret    

80105595 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105595:	55                   	push   %ebp
80105596:	89 e5                	mov    %esp,%ebp
80105598:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010559b:	83 ec 0c             	sub    $0xc,%esp
8010559e:	ff 75 08             	pushl  0x8(%ebp)
801055a1:	e8 bb 00 00 00       	call   80105661 <holding>
801055a6:	83 c4 10             	add    $0x10,%esp
801055a9:	85 c0                	test   %eax,%eax
801055ab:	75 0d                	jne    801055ba <release+0x25>
    panic("release");
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	68 ad 91 10 80       	push   $0x801091ad
801055b5:	e8 ac af ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801055ba:	8b 45 08             	mov    0x8(%ebp),%eax
801055bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801055c4:	8b 45 08             	mov    0x8(%ebp),%eax
801055c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801055ce:	8b 45 08             	mov    0x8(%ebp),%eax
801055d1:	83 ec 08             	sub    $0x8,%esp
801055d4:	6a 00                	push   $0x0
801055d6:	50                   	push   %eax
801055d7:	e8 16 ff ff ff       	call   801054f2 <xchg>
801055dc:	83 c4 10             	add    $0x10,%esp

  popcli();
801055df:	e8 ec 00 00 00       	call   801056d0 <popcli>
}
801055e4:	90                   	nop
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    

801055e7 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801055e7:	55                   	push   %ebp
801055e8:	89 e5                	mov    %esp,%ebp
801055ea:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801055ed:	8b 45 08             	mov    0x8(%ebp),%eax
801055f0:	83 e8 08             	sub    $0x8,%eax
801055f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801055f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801055fd:	eb 38                	jmp    80105637 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801055ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105603:	74 53                	je     80105658 <getcallerpcs+0x71>
80105605:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010560c:	76 4a                	jbe    80105658 <getcallerpcs+0x71>
8010560e:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105612:	74 44                	je     80105658 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105614:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105617:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010561e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105621:	01 c2                	add    %eax,%edx
80105623:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105626:	8b 40 04             	mov    0x4(%eax),%eax
80105629:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010562b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010562e:	8b 00                	mov    (%eax),%eax
80105630:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105633:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105637:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010563b:	7e c2                	jle    801055ff <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010563d:	eb 19                	jmp    80105658 <getcallerpcs+0x71>
    pcs[i] = 0;
8010563f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105649:	8b 45 0c             	mov    0xc(%ebp),%eax
8010564c:	01 d0                	add    %edx,%eax
8010564e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105654:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105658:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010565c:	7e e1                	jle    8010563f <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010565e:	90                   	nop
8010565f:	c9                   	leave  
80105660:	c3                   	ret    

80105661 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105661:	55                   	push   %ebp
80105662:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105664:	8b 45 08             	mov    0x8(%ebp),%eax
80105667:	8b 00                	mov    (%eax),%eax
80105669:	85 c0                	test   %eax,%eax
8010566b:	74 17                	je     80105684 <holding+0x23>
8010566d:	8b 45 08             	mov    0x8(%ebp),%eax
80105670:	8b 50 08             	mov    0x8(%eax),%edx
80105673:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105679:	39 c2                	cmp    %eax,%edx
8010567b:	75 07                	jne    80105684 <holding+0x23>
8010567d:	b8 01 00 00 00       	mov    $0x1,%eax
80105682:	eb 05                	jmp    80105689 <holding+0x28>
80105684:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105689:	5d                   	pop    %ebp
8010568a:	c3                   	ret    

8010568b <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010568b:	55                   	push   %ebp
8010568c:	89 e5                	mov    %esp,%ebp
8010568e:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105691:	e8 3e fe ff ff       	call   801054d4 <readeflags>
80105696:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105699:	e8 46 fe ff ff       	call   801054e4 <cli>
  if(cpu->ncli++ == 0)
8010569e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801056a5:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801056ab:	8d 48 01             	lea    0x1(%eax),%ecx
801056ae:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801056b4:	85 c0                	test   %eax,%eax
801056b6:	75 15                	jne    801056cd <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801056b8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056be:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056c1:	81 e2 00 02 00 00    	and    $0x200,%edx
801056c7:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801056cd:	90                   	nop
801056ce:	c9                   	leave  
801056cf:	c3                   	ret    

801056d0 <popcli>:

void
popcli(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801056d6:	e8 f9 fd ff ff       	call   801054d4 <readeflags>
801056db:	25 00 02 00 00       	and    $0x200,%eax
801056e0:	85 c0                	test   %eax,%eax
801056e2:	74 0d                	je     801056f1 <popcli+0x21>
    panic("popcli - interruptible");
801056e4:	83 ec 0c             	sub    $0xc,%esp
801056e7:	68 b5 91 10 80       	push   $0x801091b5
801056ec:	e8 75 ae ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801056f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056f7:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801056fd:	83 ea 01             	sub    $0x1,%edx
80105700:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105706:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010570c:	85 c0                	test   %eax,%eax
8010570e:	79 0d                	jns    8010571d <popcli+0x4d>
    panic("popcli");
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	68 cc 91 10 80       	push   $0x801091cc
80105718:	e8 49 ae ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010571d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105723:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105729:	85 c0                	test   %eax,%eax
8010572b:	75 15                	jne    80105742 <popcli+0x72>
8010572d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105733:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105739:	85 c0                	test   %eax,%eax
8010573b:	74 05                	je     80105742 <popcli+0x72>
    sti();
8010573d:	e8 a9 fd ff ff       	call   801054eb <sti>
}
80105742:	90                   	nop
80105743:	c9                   	leave  
80105744:	c3                   	ret    

80105745 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105745:	55                   	push   %ebp
80105746:	89 e5                	mov    %esp,%ebp
80105748:	57                   	push   %edi
80105749:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010574a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010574d:	8b 55 10             	mov    0x10(%ebp),%edx
80105750:	8b 45 0c             	mov    0xc(%ebp),%eax
80105753:	89 cb                	mov    %ecx,%ebx
80105755:	89 df                	mov    %ebx,%edi
80105757:	89 d1                	mov    %edx,%ecx
80105759:	fc                   	cld    
8010575a:	f3 aa                	rep stos %al,%es:(%edi)
8010575c:	89 ca                	mov    %ecx,%edx
8010575e:	89 fb                	mov    %edi,%ebx
80105760:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105763:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105766:	90                   	nop
80105767:	5b                   	pop    %ebx
80105768:	5f                   	pop    %edi
80105769:	5d                   	pop    %ebp
8010576a:	c3                   	ret    

8010576b <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010576b:	55                   	push   %ebp
8010576c:	89 e5                	mov    %esp,%ebp
8010576e:	57                   	push   %edi
8010576f:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105770:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105773:	8b 55 10             	mov    0x10(%ebp),%edx
80105776:	8b 45 0c             	mov    0xc(%ebp),%eax
80105779:	89 cb                	mov    %ecx,%ebx
8010577b:	89 df                	mov    %ebx,%edi
8010577d:	89 d1                	mov    %edx,%ecx
8010577f:	fc                   	cld    
80105780:	f3 ab                	rep stos %eax,%es:(%edi)
80105782:	89 ca                	mov    %ecx,%edx
80105784:	89 fb                	mov    %edi,%ebx
80105786:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105789:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010578c:	90                   	nop
8010578d:	5b                   	pop    %ebx
8010578e:	5f                   	pop    %edi
8010578f:	5d                   	pop    %ebp
80105790:	c3                   	ret    

80105791 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105791:	55                   	push   %ebp
80105792:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105794:	8b 45 08             	mov    0x8(%ebp),%eax
80105797:	83 e0 03             	and    $0x3,%eax
8010579a:	85 c0                	test   %eax,%eax
8010579c:	75 43                	jne    801057e1 <memset+0x50>
8010579e:	8b 45 10             	mov    0x10(%ebp),%eax
801057a1:	83 e0 03             	and    $0x3,%eax
801057a4:	85 c0                	test   %eax,%eax
801057a6:	75 39                	jne    801057e1 <memset+0x50>
    c &= 0xFF;
801057a8:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801057af:	8b 45 10             	mov    0x10(%ebp),%eax
801057b2:	c1 e8 02             	shr    $0x2,%eax
801057b5:	89 c1                	mov    %eax,%ecx
801057b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ba:	c1 e0 18             	shl    $0x18,%eax
801057bd:	89 c2                	mov    %eax,%edx
801057bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c2:	c1 e0 10             	shl    $0x10,%eax
801057c5:	09 c2                	or     %eax,%edx
801057c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ca:	c1 e0 08             	shl    $0x8,%eax
801057cd:	09 d0                	or     %edx,%eax
801057cf:	0b 45 0c             	or     0xc(%ebp),%eax
801057d2:	51                   	push   %ecx
801057d3:	50                   	push   %eax
801057d4:	ff 75 08             	pushl  0x8(%ebp)
801057d7:	e8 8f ff ff ff       	call   8010576b <stosl>
801057dc:	83 c4 0c             	add    $0xc,%esp
801057df:	eb 12                	jmp    801057f3 <memset+0x62>
  } else
    stosb(dst, c, n);
801057e1:	8b 45 10             	mov    0x10(%ebp),%eax
801057e4:	50                   	push   %eax
801057e5:	ff 75 0c             	pushl  0xc(%ebp)
801057e8:	ff 75 08             	pushl  0x8(%ebp)
801057eb:	e8 55 ff ff ff       	call   80105745 <stosb>
801057f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
801057f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801057f6:	c9                   	leave  
801057f7:	c3                   	ret    

801057f8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801057f8:	55                   	push   %ebp
801057f9:	89 e5                	mov    %esp,%ebp
801057fb:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801057fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105801:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105804:	8b 45 0c             	mov    0xc(%ebp),%eax
80105807:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010580a:	eb 30                	jmp    8010583c <memcmp+0x44>
    if(*s1 != *s2)
8010580c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010580f:	0f b6 10             	movzbl (%eax),%edx
80105812:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105815:	0f b6 00             	movzbl (%eax),%eax
80105818:	38 c2                	cmp    %al,%dl
8010581a:	74 18                	je     80105834 <memcmp+0x3c>
      return *s1 - *s2;
8010581c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010581f:	0f b6 00             	movzbl (%eax),%eax
80105822:	0f b6 d0             	movzbl %al,%edx
80105825:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105828:	0f b6 00             	movzbl (%eax),%eax
8010582b:	0f b6 c0             	movzbl %al,%eax
8010582e:	29 c2                	sub    %eax,%edx
80105830:	89 d0                	mov    %edx,%eax
80105832:	eb 1a                	jmp    8010584e <memcmp+0x56>
    s1++, s2++;
80105834:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105838:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010583c:	8b 45 10             	mov    0x10(%ebp),%eax
8010583f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105842:	89 55 10             	mov    %edx,0x10(%ebp)
80105845:	85 c0                	test   %eax,%eax
80105847:	75 c3                	jne    8010580c <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105849:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010584e:	c9                   	leave  
8010584f:	c3                   	ret    

80105850 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105856:	8b 45 0c             	mov    0xc(%ebp),%eax
80105859:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010585c:	8b 45 08             	mov    0x8(%ebp),%eax
8010585f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105862:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105865:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105868:	73 54                	jae    801058be <memmove+0x6e>
8010586a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010586d:	8b 45 10             	mov    0x10(%ebp),%eax
80105870:	01 d0                	add    %edx,%eax
80105872:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105875:	76 47                	jbe    801058be <memmove+0x6e>
    s += n;
80105877:	8b 45 10             	mov    0x10(%ebp),%eax
8010587a:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010587d:	8b 45 10             	mov    0x10(%ebp),%eax
80105880:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105883:	eb 13                	jmp    80105898 <memmove+0x48>
      *--d = *--s;
80105885:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105889:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010588d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105890:	0f b6 10             	movzbl (%eax),%edx
80105893:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105896:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105898:	8b 45 10             	mov    0x10(%ebp),%eax
8010589b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010589e:	89 55 10             	mov    %edx,0x10(%ebp)
801058a1:	85 c0                	test   %eax,%eax
801058a3:	75 e0                	jne    80105885 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801058a5:	eb 24                	jmp    801058cb <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801058a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058aa:	8d 50 01             	lea    0x1(%eax),%edx
801058ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
801058b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058b3:	8d 4a 01             	lea    0x1(%edx),%ecx
801058b6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801058b9:	0f b6 12             	movzbl (%edx),%edx
801058bc:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801058be:	8b 45 10             	mov    0x10(%ebp),%eax
801058c1:	8d 50 ff             	lea    -0x1(%eax),%edx
801058c4:	89 55 10             	mov    %edx,0x10(%ebp)
801058c7:	85 c0                	test   %eax,%eax
801058c9:	75 dc                	jne    801058a7 <memmove+0x57>
      *d++ = *s++;

  return dst;
801058cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801058ce:	c9                   	leave  
801058cf:	c3                   	ret    

801058d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801058d3:	ff 75 10             	pushl  0x10(%ebp)
801058d6:	ff 75 0c             	pushl  0xc(%ebp)
801058d9:	ff 75 08             	pushl  0x8(%ebp)
801058dc:	e8 6f ff ff ff       	call   80105850 <memmove>
801058e1:	83 c4 0c             	add    $0xc,%esp
}
801058e4:	c9                   	leave  
801058e5:	c3                   	ret    

801058e6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801058e6:	55                   	push   %ebp
801058e7:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801058e9:	eb 0c                	jmp    801058f7 <strncmp+0x11>
    n--, p++, q++;
801058eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058ef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801058f3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801058f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058fb:	74 1a                	je     80105917 <strncmp+0x31>
801058fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105900:	0f b6 00             	movzbl (%eax),%eax
80105903:	84 c0                	test   %al,%al
80105905:	74 10                	je     80105917 <strncmp+0x31>
80105907:	8b 45 08             	mov    0x8(%ebp),%eax
8010590a:	0f b6 10             	movzbl (%eax),%edx
8010590d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105910:	0f b6 00             	movzbl (%eax),%eax
80105913:	38 c2                	cmp    %al,%dl
80105915:	74 d4                	je     801058eb <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105917:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010591b:	75 07                	jne    80105924 <strncmp+0x3e>
    return 0;
8010591d:	b8 00 00 00 00       	mov    $0x0,%eax
80105922:	eb 16                	jmp    8010593a <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105924:	8b 45 08             	mov    0x8(%ebp),%eax
80105927:	0f b6 00             	movzbl (%eax),%eax
8010592a:	0f b6 d0             	movzbl %al,%edx
8010592d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105930:	0f b6 00             	movzbl (%eax),%eax
80105933:	0f b6 c0             	movzbl %al,%eax
80105936:	29 c2                	sub    %eax,%edx
80105938:	89 d0                	mov    %edx,%eax
}
8010593a:	5d                   	pop    %ebp
8010593b:	c3                   	ret    

8010593c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010593c:	55                   	push   %ebp
8010593d:	89 e5                	mov    %esp,%ebp
8010593f:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105942:	8b 45 08             	mov    0x8(%ebp),%eax
80105945:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105948:	90                   	nop
80105949:	8b 45 10             	mov    0x10(%ebp),%eax
8010594c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010594f:	89 55 10             	mov    %edx,0x10(%ebp)
80105952:	85 c0                	test   %eax,%eax
80105954:	7e 2c                	jle    80105982 <strncpy+0x46>
80105956:	8b 45 08             	mov    0x8(%ebp),%eax
80105959:	8d 50 01             	lea    0x1(%eax),%edx
8010595c:	89 55 08             	mov    %edx,0x8(%ebp)
8010595f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105962:	8d 4a 01             	lea    0x1(%edx),%ecx
80105965:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105968:	0f b6 12             	movzbl (%edx),%edx
8010596b:	88 10                	mov    %dl,(%eax)
8010596d:	0f b6 00             	movzbl (%eax),%eax
80105970:	84 c0                	test   %al,%al
80105972:	75 d5                	jne    80105949 <strncpy+0xd>
    ;
  while(n-- > 0)
80105974:	eb 0c                	jmp    80105982 <strncpy+0x46>
    *s++ = 0;
80105976:	8b 45 08             	mov    0x8(%ebp),%eax
80105979:	8d 50 01             	lea    0x1(%eax),%edx
8010597c:	89 55 08             	mov    %edx,0x8(%ebp)
8010597f:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105982:	8b 45 10             	mov    0x10(%ebp),%eax
80105985:	8d 50 ff             	lea    -0x1(%eax),%edx
80105988:	89 55 10             	mov    %edx,0x10(%ebp)
8010598b:	85 c0                	test   %eax,%eax
8010598d:	7f e7                	jg     80105976 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010598f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105992:	c9                   	leave  
80105993:	c3                   	ret    

80105994 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010599a:	8b 45 08             	mov    0x8(%ebp),%eax
8010599d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801059a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059a4:	7f 05                	jg     801059ab <safestrcpy+0x17>
    return os;
801059a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059a9:	eb 31                	jmp    801059dc <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801059ab:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801059af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059b3:	7e 1e                	jle    801059d3 <safestrcpy+0x3f>
801059b5:	8b 45 08             	mov    0x8(%ebp),%eax
801059b8:	8d 50 01             	lea    0x1(%eax),%edx
801059bb:	89 55 08             	mov    %edx,0x8(%ebp)
801059be:	8b 55 0c             	mov    0xc(%ebp),%edx
801059c1:	8d 4a 01             	lea    0x1(%edx),%ecx
801059c4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801059c7:	0f b6 12             	movzbl (%edx),%edx
801059ca:	88 10                	mov    %dl,(%eax)
801059cc:	0f b6 00             	movzbl (%eax),%eax
801059cf:	84 c0                	test   %al,%al
801059d1:	75 d8                	jne    801059ab <safestrcpy+0x17>
    ;
  *s = 0;
801059d3:	8b 45 08             	mov    0x8(%ebp),%eax
801059d6:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801059d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059dc:	c9                   	leave  
801059dd:	c3                   	ret    

801059de <strlen>:

int
strlen(const char *s)
{
801059de:	55                   	push   %ebp
801059df:	89 e5                	mov    %esp,%ebp
801059e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801059e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801059eb:	eb 04                	jmp    801059f1 <strlen+0x13>
801059ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801059f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059f4:	8b 45 08             	mov    0x8(%ebp),%eax
801059f7:	01 d0                	add    %edx,%eax
801059f9:	0f b6 00             	movzbl (%eax),%eax
801059fc:	84 c0                	test   %al,%al
801059fe:	75 ed                	jne    801059ed <strlen+0xf>
    ;
  return n;
80105a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a03:	c9                   	leave  
80105a04:	c3                   	ret    

80105a05 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a05:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105a09:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105a0d:	55                   	push   %ebp
  pushl %ebx
80105a0e:	53                   	push   %ebx
  pushl %esi
80105a0f:	56                   	push   %esi
  pushl %edi
80105a10:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105a11:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105a13:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105a15:	5f                   	pop    %edi
  popl %esi
80105a16:	5e                   	pop    %esi
  popl %ebx
80105a17:	5b                   	pop    %ebx
  popl %ebp
80105a18:	5d                   	pop    %ebp
  ret
80105a19:	c3                   	ret    

80105a1a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a1a:	55                   	push   %ebp
80105a1b:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105a1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a23:	8b 00                	mov    (%eax),%eax
80105a25:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a28:	76 12                	jbe    80105a3c <fetchint+0x22>
80105a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a2d:	8d 50 04             	lea    0x4(%eax),%edx
80105a30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a36:	8b 00                	mov    (%eax),%eax
80105a38:	39 c2                	cmp    %eax,%edx
80105a3a:	76 07                	jbe    80105a43 <fetchint+0x29>
    return -1;
80105a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a41:	eb 0f                	jmp    80105a52 <fetchint+0x38>
  *ip = *(int*)(addr);
80105a43:	8b 45 08             	mov    0x8(%ebp),%eax
80105a46:	8b 10                	mov    (%eax),%edx
80105a48:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a4b:	89 10                	mov    %edx,(%eax)
  return 0;
80105a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a52:	5d                   	pop    %ebp
80105a53:	c3                   	ret    

80105a54 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a54:	55                   	push   %ebp
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105a5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a60:	8b 00                	mov    (%eax),%eax
80105a62:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a65:	77 07                	ja     80105a6e <fetchstr+0x1a>
    return -1;
80105a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6c:	eb 46                	jmp    80105ab4 <fetchstr+0x60>
  *pp = (char*)addr;
80105a6e:	8b 55 08             	mov    0x8(%ebp),%edx
80105a71:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a74:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105a76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a7c:	8b 00                	mov    (%eax),%eax
80105a7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a84:	8b 00                	mov    (%eax),%eax
80105a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105a89:	eb 1c                	jmp    80105aa7 <fetchstr+0x53>
    if(*s == 0)
80105a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a8e:	0f b6 00             	movzbl (%eax),%eax
80105a91:	84 c0                	test   %al,%al
80105a93:	75 0e                	jne    80105aa3 <fetchstr+0x4f>
      return s - *pp;
80105a95:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a98:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a9b:	8b 00                	mov    (%eax),%eax
80105a9d:	29 c2                	sub    %eax,%edx
80105a9f:	89 d0                	mov    %edx,%eax
80105aa1:	eb 11                	jmp    80105ab4 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105aa3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aaa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105aad:	72 dc                	jb     80105a8b <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105aaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab4:	c9                   	leave  
80105ab5:	c3                   	ret    

80105ab6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105ab6:	55                   	push   %ebp
80105ab7:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105ab9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105abf:	8b 40 18             	mov    0x18(%eax),%eax
80105ac2:	8b 40 44             	mov    0x44(%eax),%eax
80105ac5:	8b 55 08             	mov    0x8(%ebp),%edx
80105ac8:	c1 e2 02             	shl    $0x2,%edx
80105acb:	01 d0                	add    %edx,%eax
80105acd:	83 c0 04             	add    $0x4,%eax
80105ad0:	ff 75 0c             	pushl  0xc(%ebp)
80105ad3:	50                   	push   %eax
80105ad4:	e8 41 ff ff ff       	call   80105a1a <fetchint>
80105ad9:	83 c4 08             	add    $0x8,%esp
}
80105adc:	c9                   	leave  
80105add:	c3                   	ret    

80105ade <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105ade:	55                   	push   %ebp
80105adf:	89 e5                	mov    %esp,%ebp
80105ae1:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105ae4:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105ae7:	50                   	push   %eax
80105ae8:	ff 75 08             	pushl  0x8(%ebp)
80105aeb:	e8 c6 ff ff ff       	call   80105ab6 <argint>
80105af0:	83 c4 08             	add    $0x8,%esp
80105af3:	85 c0                	test   %eax,%eax
80105af5:	79 07                	jns    80105afe <argptr+0x20>
    return -1;
80105af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afc:	eb 3b                	jmp    80105b39 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105afe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b04:	8b 00                	mov    (%eax),%eax
80105b06:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b09:	39 d0                	cmp    %edx,%eax
80105b0b:	76 16                	jbe    80105b23 <argptr+0x45>
80105b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b10:	89 c2                	mov    %eax,%edx
80105b12:	8b 45 10             	mov    0x10(%ebp),%eax
80105b15:	01 c2                	add    %eax,%edx
80105b17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b1d:	8b 00                	mov    (%eax),%eax
80105b1f:	39 c2                	cmp    %eax,%edx
80105b21:	76 07                	jbe    80105b2a <argptr+0x4c>
    return -1;
80105b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b28:	eb 0f                	jmp    80105b39 <argptr+0x5b>
  *pp = (char*)i;
80105b2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b2d:	89 c2                	mov    %eax,%edx
80105b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b32:	89 10                	mov    %edx,(%eax)
  return 0;
80105b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b39:	c9                   	leave  
80105b3a:	c3                   	ret    

80105b3b <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105b3b:	55                   	push   %ebp
80105b3c:	89 e5                	mov    %esp,%ebp
80105b3e:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105b41:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b44:	50                   	push   %eax
80105b45:	ff 75 08             	pushl  0x8(%ebp)
80105b48:	e8 69 ff ff ff       	call   80105ab6 <argint>
80105b4d:	83 c4 08             	add    $0x8,%esp
80105b50:	85 c0                	test   %eax,%eax
80105b52:	79 07                	jns    80105b5b <argstr+0x20>
    return -1;
80105b54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b59:	eb 0f                	jmp    80105b6a <argstr+0x2f>
  return fetchstr(addr, pp);
80105b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b5e:	ff 75 0c             	pushl  0xc(%ebp)
80105b61:	50                   	push   %eax
80105b62:	e8 ed fe ff ff       	call   80105a54 <fetchstr>
80105b67:	83 c4 08             	add    $0x8,%esp
}
80105b6a:	c9                   	leave  
80105b6b:	c3                   	ret    

80105b6c <syscall>:
#endif


void
syscall(void)
{
80105b6c:	55                   	push   %ebp
80105b6d:	89 e5                	mov    %esp,%ebp
80105b6f:	53                   	push   %ebx
80105b70:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105b73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b79:	8b 40 18             	mov    0x18(%eax),%eax
80105b7c:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b86:	7e 30                	jle    80105bb8 <syscall+0x4c>
80105b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8b:	83 f8 20             	cmp    $0x20,%eax
80105b8e:	77 28                	ja     80105bb8 <syscall+0x4c>
80105b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b93:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b9a:	85 c0                	test   %eax,%eax
80105b9c:	74 1a                	je     80105bb8 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105b9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ba4:	8b 58 18             	mov    0x18(%eax),%ebx
80105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baa:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105bb1:	ff d0                	call   *%eax
80105bb3:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105bb6:	eb 34                	jmp    80105bec <syscall+0x80>
    cprintf("\n \t \t \t  %s -> %d \n", sysname[num], proc->tf->eax );
    #endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105bb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bbe:	8d 50 6c             	lea    0x6c(%eax),%edx
80105bc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    #ifdef PRINT_SYSCALLS
    cprintf("\n \t \t \t  %s -> %d \n", sysname[num], proc->tf->eax );
    #endif

  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105bc7:	8b 40 10             	mov    0x10(%eax),%eax
80105bca:	ff 75 f4             	pushl  -0xc(%ebp)
80105bcd:	52                   	push   %edx
80105bce:	50                   	push   %eax
80105bcf:	68 d3 91 10 80       	push   $0x801091d3
80105bd4:	e8 ed a7 ff ff       	call   801003c6 <cprintf>
80105bd9:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105bdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105be2:	8b 40 18             	mov    0x18(%eax),%eax
80105be5:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105bec:	90                   	nop
80105bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bf0:	c9                   	leave  
80105bf1:	c3                   	ret    

80105bf2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105bf2:	55                   	push   %ebp
80105bf3:	89 e5                	mov    %esp,%ebp
80105bf5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105bf8:	83 ec 08             	sub    $0x8,%esp
80105bfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bfe:	50                   	push   %eax
80105bff:	ff 75 08             	pushl  0x8(%ebp)
80105c02:	e8 af fe ff ff       	call   80105ab6 <argint>
80105c07:	83 c4 10             	add    $0x10,%esp
80105c0a:	85 c0                	test   %eax,%eax
80105c0c:	79 07                	jns    80105c15 <argfd+0x23>
    return -1;
80105c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c13:	eb 50                	jmp    80105c65 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	78 21                	js     80105c3d <argfd+0x4b>
80105c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1f:	83 f8 0f             	cmp    $0xf,%eax
80105c22:	7f 19                	jg     80105c3d <argfd+0x4b>
80105c24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c2d:	83 c2 08             	add    $0x8,%edx
80105c30:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c3b:	75 07                	jne    80105c44 <argfd+0x52>
    return -1;
80105c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c42:	eb 21                	jmp    80105c65 <argfd+0x73>
  if(pfd)
80105c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c48:	74 08                	je     80105c52 <argfd+0x60>
    *pfd = fd;
80105c4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c50:	89 10                	mov    %edx,(%eax)
  if(pf)
80105c52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c56:	74 08                	je     80105c60 <argfd+0x6e>
    *pf = f;
80105c58:	8b 45 10             	mov    0x10(%ebp),%eax
80105c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c5e:	89 10                	mov    %edx,(%eax)
  return 0;
80105c60:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c65:	c9                   	leave  
80105c66:	c3                   	ret    

80105c67 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105c67:	55                   	push   %ebp
80105c68:	89 e5                	mov    %esp,%ebp
80105c6a:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c74:	eb 30                	jmp    80105ca6 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105c76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c7f:	83 c2 08             	add    $0x8,%edx
80105c82:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c86:	85 c0                	test   %eax,%eax
80105c88:	75 18                	jne    80105ca2 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105c8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c90:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c93:	8d 4a 08             	lea    0x8(%edx),%ecx
80105c96:	8b 55 08             	mov    0x8(%ebp),%edx
80105c99:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ca0:	eb 0f                	jmp    80105cb1 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105ca2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105ca6:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105caa:	7e ca                	jle    80105c76 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb1:	c9                   	leave  
80105cb2:	c3                   	ret    

80105cb3 <sys_dup>:

int
sys_dup(void)
{
80105cb3:	55                   	push   %ebp
80105cb4:	89 e5                	mov    %esp,%ebp
80105cb6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105cb9:	83 ec 04             	sub    $0x4,%esp
80105cbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cbf:	50                   	push   %eax
80105cc0:	6a 00                	push   $0x0
80105cc2:	6a 00                	push   $0x0
80105cc4:	e8 29 ff ff ff       	call   80105bf2 <argfd>
80105cc9:	83 c4 10             	add    $0x10,%esp
80105ccc:	85 c0                	test   %eax,%eax
80105cce:	79 07                	jns    80105cd7 <sys_dup+0x24>
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd5:	eb 31                	jmp    80105d08 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cda:	83 ec 0c             	sub    $0xc,%esp
80105cdd:	50                   	push   %eax
80105cde:	e8 84 ff ff ff       	call   80105c67 <fdalloc>
80105ce3:	83 c4 10             	add    $0x10,%esp
80105ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ced:	79 07                	jns    80105cf6 <sys_dup+0x43>
    return -1;
80105cef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf4:	eb 12                	jmp    80105d08 <sys_dup+0x55>
  filedup(f);
80105cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf9:	83 ec 0c             	sub    $0xc,%esp
80105cfc:	50                   	push   %eax
80105cfd:	e8 fe b2 ff ff       	call   80101000 <filedup>
80105d02:	83 c4 10             	add    $0x10,%esp
  return fd;
80105d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d08:	c9                   	leave  
80105d09:	c3                   	ret    

80105d0a <sys_read>:

int
sys_read(void)
{
80105d0a:	55                   	push   %ebp
80105d0b:	89 e5                	mov    %esp,%ebp
80105d0d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d10:	83 ec 04             	sub    $0x4,%esp
80105d13:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d16:	50                   	push   %eax
80105d17:	6a 00                	push   $0x0
80105d19:	6a 00                	push   $0x0
80105d1b:	e8 d2 fe ff ff       	call   80105bf2 <argfd>
80105d20:	83 c4 10             	add    $0x10,%esp
80105d23:	85 c0                	test   %eax,%eax
80105d25:	78 2e                	js     80105d55 <sys_read+0x4b>
80105d27:	83 ec 08             	sub    $0x8,%esp
80105d2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d2d:	50                   	push   %eax
80105d2e:	6a 02                	push   $0x2
80105d30:	e8 81 fd ff ff       	call   80105ab6 <argint>
80105d35:	83 c4 10             	add    $0x10,%esp
80105d38:	85 c0                	test   %eax,%eax
80105d3a:	78 19                	js     80105d55 <sys_read+0x4b>
80105d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d3f:	83 ec 04             	sub    $0x4,%esp
80105d42:	50                   	push   %eax
80105d43:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d46:	50                   	push   %eax
80105d47:	6a 01                	push   $0x1
80105d49:	e8 90 fd ff ff       	call   80105ade <argptr>
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	85 c0                	test   %eax,%eax
80105d53:	79 07                	jns    80105d5c <sys_read+0x52>
    return -1;
80105d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5a:	eb 17                	jmp    80105d73 <sys_read+0x69>
  return fileread(f, p, n);
80105d5c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d65:	83 ec 04             	sub    $0x4,%esp
80105d68:	51                   	push   %ecx
80105d69:	52                   	push   %edx
80105d6a:	50                   	push   %eax
80105d6b:	e8 20 b4 ff ff       	call   80101190 <fileread>
80105d70:	83 c4 10             	add    $0x10,%esp
}
80105d73:	c9                   	leave  
80105d74:	c3                   	ret    

80105d75 <sys_write>:

int
sys_write(void)
{
80105d75:	55                   	push   %ebp
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d7b:	83 ec 04             	sub    $0x4,%esp
80105d7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d81:	50                   	push   %eax
80105d82:	6a 00                	push   $0x0
80105d84:	6a 00                	push   $0x0
80105d86:	e8 67 fe ff ff       	call   80105bf2 <argfd>
80105d8b:	83 c4 10             	add    $0x10,%esp
80105d8e:	85 c0                	test   %eax,%eax
80105d90:	78 2e                	js     80105dc0 <sys_write+0x4b>
80105d92:	83 ec 08             	sub    $0x8,%esp
80105d95:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d98:	50                   	push   %eax
80105d99:	6a 02                	push   $0x2
80105d9b:	e8 16 fd ff ff       	call   80105ab6 <argint>
80105da0:	83 c4 10             	add    $0x10,%esp
80105da3:	85 c0                	test   %eax,%eax
80105da5:	78 19                	js     80105dc0 <sys_write+0x4b>
80105da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105daa:	83 ec 04             	sub    $0x4,%esp
80105dad:	50                   	push   %eax
80105dae:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105db1:	50                   	push   %eax
80105db2:	6a 01                	push   $0x1
80105db4:	e8 25 fd ff ff       	call   80105ade <argptr>
80105db9:	83 c4 10             	add    $0x10,%esp
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	79 07                	jns    80105dc7 <sys_write+0x52>
    return -1;
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc5:	eb 17                	jmp    80105dde <sys_write+0x69>
  return filewrite(f, p, n);
80105dc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105dca:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd0:	83 ec 04             	sub    $0x4,%esp
80105dd3:	51                   	push   %ecx
80105dd4:	52                   	push   %edx
80105dd5:	50                   	push   %eax
80105dd6:	e8 6d b4 ff ff       	call   80101248 <filewrite>
80105ddb:	83 c4 10             	add    $0x10,%esp
}
80105dde:	c9                   	leave  
80105ddf:	c3                   	ret    

80105de0 <sys_close>:

int
sys_close(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105de6:	83 ec 04             	sub    $0x4,%esp
80105de9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dec:	50                   	push   %eax
80105ded:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105df0:	50                   	push   %eax
80105df1:	6a 00                	push   $0x0
80105df3:	e8 fa fd ff ff       	call   80105bf2 <argfd>
80105df8:	83 c4 10             	add    $0x10,%esp
80105dfb:	85 c0                	test   %eax,%eax
80105dfd:	79 07                	jns    80105e06 <sys_close+0x26>
    return -1;
80105dff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e04:	eb 28                	jmp    80105e2e <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105e06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e0f:	83 c2 08             	add    $0x8,%edx
80105e12:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e19:	00 
  fileclose(f);
80105e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	50                   	push   %eax
80105e21:	e8 2b b2 ff ff       	call   80101051 <fileclose>
80105e26:	83 c4 10             	add    $0x10,%esp
  return 0;
80105e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e2e:	c9                   	leave  
80105e2f:	c3                   	ret    

80105e30 <sys_fstat>:

int
sys_fstat(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e36:	83 ec 04             	sub    $0x4,%esp
80105e39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e3c:	50                   	push   %eax
80105e3d:	6a 00                	push   $0x0
80105e3f:	6a 00                	push   $0x0
80105e41:	e8 ac fd ff ff       	call   80105bf2 <argfd>
80105e46:	83 c4 10             	add    $0x10,%esp
80105e49:	85 c0                	test   %eax,%eax
80105e4b:	78 17                	js     80105e64 <sys_fstat+0x34>
80105e4d:	83 ec 04             	sub    $0x4,%esp
80105e50:	6a 1c                	push   $0x1c
80105e52:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e55:	50                   	push   %eax
80105e56:	6a 01                	push   $0x1
80105e58:	e8 81 fc ff ff       	call   80105ade <argptr>
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	85 c0                	test   %eax,%eax
80105e62:	79 07                	jns    80105e6b <sys_fstat+0x3b>
    return -1;
80105e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e69:	eb 13                	jmp    80105e7e <sys_fstat+0x4e>
  return filestat(f, st);
80105e6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e71:	83 ec 08             	sub    $0x8,%esp
80105e74:	52                   	push   %edx
80105e75:	50                   	push   %eax
80105e76:	e8 be b2 ff ff       	call   80101139 <filestat>
80105e7b:	83 c4 10             	add    $0x10,%esp
}
80105e7e:	c9                   	leave  
80105e7f:	c3                   	ret    

80105e80 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105e86:	83 ec 08             	sub    $0x8,%esp
80105e89:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105e8c:	50                   	push   %eax
80105e8d:	6a 00                	push   $0x0
80105e8f:	e8 a7 fc ff ff       	call   80105b3b <argstr>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	85 c0                	test   %eax,%eax
80105e99:	78 15                	js     80105eb0 <sys_link+0x30>
80105e9b:	83 ec 08             	sub    $0x8,%esp
80105e9e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105ea1:	50                   	push   %eax
80105ea2:	6a 01                	push   $0x1
80105ea4:	e8 92 fc ff ff       	call   80105b3b <argstr>
80105ea9:	83 c4 10             	add    $0x10,%esp
80105eac:	85 c0                	test   %eax,%eax
80105eae:	79 0a                	jns    80105eba <sys_link+0x3a>
    return -1;
80105eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb5:	e9 68 01 00 00       	jmp    80106022 <sys_link+0x1a2>

  begin_op();
80105eba:	e8 ea d7 ff ff       	call   801036a9 <begin_op>
  if((ip = namei(old)) == 0){
80105ebf:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105ec2:	83 ec 0c             	sub    $0xc,%esp
80105ec5:	50                   	push   %eax
80105ec6:	e8 b9 c7 ff ff       	call   80102684 <namei>
80105ecb:	83 c4 10             	add    $0x10,%esp
80105ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ed5:	75 0f                	jne    80105ee6 <sys_link+0x66>
    end_op();
80105ed7:	e8 59 d8 ff ff       	call   80103735 <end_op>
    return -1;
80105edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee1:	e9 3c 01 00 00       	jmp    80106022 <sys_link+0x1a2>
  }

  ilock(ip);
80105ee6:	83 ec 0c             	sub    $0xc,%esp
80105ee9:	ff 75 f4             	pushl  -0xc(%ebp)
80105eec:	e8 85 bb ff ff       	call   80101a76 <ilock>
80105ef1:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105efb:	66 83 f8 01          	cmp    $0x1,%ax
80105eff:	75 1d                	jne    80105f1e <sys_link+0x9e>
    iunlockput(ip);
80105f01:	83 ec 0c             	sub    $0xc,%esp
80105f04:	ff 75 f4             	pushl  -0xc(%ebp)
80105f07:	e8 52 be ff ff       	call   80101d5e <iunlockput>
80105f0c:	83 c4 10             	add    $0x10,%esp
    end_op();
80105f0f:	e8 21 d8 ff ff       	call   80103735 <end_op>
    return -1;
80105f14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f19:	e9 04 01 00 00       	jmp    80106022 <sys_link+0x1a2>
  }

  ip->nlink++;
80105f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f21:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f25:	83 c0 01             	add    $0x1,%eax
80105f28:	89 c2                	mov    %eax,%edx
80105f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f31:	83 ec 0c             	sub    $0xc,%esp
80105f34:	ff 75 f4             	pushl  -0xc(%ebp)
80105f37:	e8 38 b9 ff ff       	call   80101874 <iupdate>
80105f3c:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105f3f:	83 ec 0c             	sub    $0xc,%esp
80105f42:	ff 75 f4             	pushl  -0xc(%ebp)
80105f45:	e8 b2 bc ff ff       	call   80101bfc <iunlock>
80105f4a:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105f4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f50:	83 ec 08             	sub    $0x8,%esp
80105f53:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105f56:	52                   	push   %edx
80105f57:	50                   	push   %eax
80105f58:	e8 43 c7 ff ff       	call   801026a0 <nameiparent>
80105f5d:	83 c4 10             	add    $0x10,%esp
80105f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f67:	74 71                	je     80105fda <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105f69:	83 ec 0c             	sub    $0xc,%esp
80105f6c:	ff 75 f0             	pushl  -0x10(%ebp)
80105f6f:	e8 02 bb ff ff       	call   80101a76 <ilock>
80105f74:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7a:	8b 10                	mov    (%eax),%edx
80105f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f7f:	8b 00                	mov    (%eax),%eax
80105f81:	39 c2                	cmp    %eax,%edx
80105f83:	75 1d                	jne    80105fa2 <sys_link+0x122>
80105f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f88:	8b 40 04             	mov    0x4(%eax),%eax
80105f8b:	83 ec 04             	sub    $0x4,%esp
80105f8e:	50                   	push   %eax
80105f8f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105f92:	50                   	push   %eax
80105f93:	ff 75 f0             	pushl  -0x10(%ebp)
80105f96:	e8 4d c4 ff ff       	call   801023e8 <dirlink>
80105f9b:	83 c4 10             	add    $0x10,%esp
80105f9e:	85 c0                	test   %eax,%eax
80105fa0:	79 10                	jns    80105fb2 <sys_link+0x132>
    iunlockput(dp);
80105fa2:	83 ec 0c             	sub    $0xc,%esp
80105fa5:	ff 75 f0             	pushl  -0x10(%ebp)
80105fa8:	e8 b1 bd ff ff       	call   80101d5e <iunlockput>
80105fad:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105fb0:	eb 29                	jmp    80105fdb <sys_link+0x15b>
  }
  iunlockput(dp);
80105fb2:	83 ec 0c             	sub    $0xc,%esp
80105fb5:	ff 75 f0             	pushl  -0x10(%ebp)
80105fb8:	e8 a1 bd ff ff       	call   80101d5e <iunlockput>
80105fbd:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	ff 75 f4             	pushl  -0xc(%ebp)
80105fc6:	e8 a3 bc ff ff       	call   80101c6e <iput>
80105fcb:	83 c4 10             	add    $0x10,%esp

  end_op();
80105fce:	e8 62 d7 ff ff       	call   80103735 <end_op>

  return 0;
80105fd3:	b8 00 00 00 00       	mov    $0x0,%eax
80105fd8:	eb 48                	jmp    80106022 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105fda:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105fdb:	83 ec 0c             	sub    $0xc,%esp
80105fde:	ff 75 f4             	pushl  -0xc(%ebp)
80105fe1:	e8 90 ba ff ff       	call   80101a76 <ilock>
80105fe6:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fec:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ff0:	83 e8 01             	sub    $0x1,%eax
80105ff3:	89 c2                	mov    %eax,%edx
80105ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff8:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ffc:	83 ec 0c             	sub    $0xc,%esp
80105fff:	ff 75 f4             	pushl  -0xc(%ebp)
80106002:	e8 6d b8 ff ff       	call   80101874 <iupdate>
80106007:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010600a:	83 ec 0c             	sub    $0xc,%esp
8010600d:	ff 75 f4             	pushl  -0xc(%ebp)
80106010:	e8 49 bd ff ff       	call   80101d5e <iunlockput>
80106015:	83 c4 10             	add    $0x10,%esp
  end_op();
80106018:	e8 18 d7 ff ff       	call   80103735 <end_op>
  return -1;
8010601d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106022:	c9                   	leave  
80106023:	c3                   	ret    

80106024 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
80106027:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010602a:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106031:	eb 40                	jmp    80106073 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106036:	6a 10                	push   $0x10
80106038:	50                   	push   %eax
80106039:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010603c:	50                   	push   %eax
8010603d:	ff 75 08             	pushl  0x8(%ebp)
80106040:	e8 ef bf ff ff       	call   80102034 <readi>
80106045:	83 c4 10             	add    $0x10,%esp
80106048:	83 f8 10             	cmp    $0x10,%eax
8010604b:	74 0d                	je     8010605a <isdirempty+0x36>
      panic("isdirempty: readi");
8010604d:	83 ec 0c             	sub    $0xc,%esp
80106050:	68 ef 91 10 80       	push   $0x801091ef
80106055:	e8 0c a5 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010605a:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010605e:	66 85 c0             	test   %ax,%ax
80106061:	74 07                	je     8010606a <isdirempty+0x46>
      return 0;
80106063:	b8 00 00 00 00       	mov    $0x0,%eax
80106068:	eb 1b                	jmp    80106085 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010606a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606d:	83 c0 10             	add    $0x10,%eax
80106070:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106073:	8b 45 08             	mov    0x8(%ebp),%eax
80106076:	8b 50 18             	mov    0x18(%eax),%edx
80106079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607c:	39 c2                	cmp    %eax,%edx
8010607e:	77 b3                	ja     80106033 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106080:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106085:	c9                   	leave  
80106086:	c3                   	ret    

80106087 <sys_unlink>:

int
sys_unlink(void)
{
80106087:	55                   	push   %ebp
80106088:	89 e5                	mov    %esp,%ebp
8010608a:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010608d:	83 ec 08             	sub    $0x8,%esp
80106090:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106093:	50                   	push   %eax
80106094:	6a 00                	push   $0x0
80106096:	e8 a0 fa ff ff       	call   80105b3b <argstr>
8010609b:	83 c4 10             	add    $0x10,%esp
8010609e:	85 c0                	test   %eax,%eax
801060a0:	79 0a                	jns    801060ac <sys_unlink+0x25>
    return -1;
801060a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a7:	e9 bc 01 00 00       	jmp    80106268 <sys_unlink+0x1e1>

  begin_op();
801060ac:	e8 f8 d5 ff ff       	call   801036a9 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801060b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801060b4:	83 ec 08             	sub    $0x8,%esp
801060b7:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801060ba:	52                   	push   %edx
801060bb:	50                   	push   %eax
801060bc:	e8 df c5 ff ff       	call   801026a0 <nameiparent>
801060c1:	83 c4 10             	add    $0x10,%esp
801060c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060cb:	75 0f                	jne    801060dc <sys_unlink+0x55>
    end_op();
801060cd:	e8 63 d6 ff ff       	call   80103735 <end_op>
    return -1;
801060d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d7:	e9 8c 01 00 00       	jmp    80106268 <sys_unlink+0x1e1>
  }

  ilock(dp);
801060dc:	83 ec 0c             	sub    $0xc,%esp
801060df:	ff 75 f4             	pushl  -0xc(%ebp)
801060e2:	e8 8f b9 ff ff       	call   80101a76 <ilock>
801060e7:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801060ea:	83 ec 08             	sub    $0x8,%esp
801060ed:	68 01 92 10 80       	push   $0x80109201
801060f2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801060f5:	50                   	push   %eax
801060f6:	e8 18 c2 ff ff       	call   80102313 <namecmp>
801060fb:	83 c4 10             	add    $0x10,%esp
801060fe:	85 c0                	test   %eax,%eax
80106100:	0f 84 4a 01 00 00    	je     80106250 <sys_unlink+0x1c9>
80106106:	83 ec 08             	sub    $0x8,%esp
80106109:	68 03 92 10 80       	push   $0x80109203
8010610e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106111:	50                   	push   %eax
80106112:	e8 fc c1 ff ff       	call   80102313 <namecmp>
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	85 c0                	test   %eax,%eax
8010611c:	0f 84 2e 01 00 00    	je     80106250 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106122:	83 ec 04             	sub    $0x4,%esp
80106125:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106128:	50                   	push   %eax
80106129:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010612c:	50                   	push   %eax
8010612d:	ff 75 f4             	pushl  -0xc(%ebp)
80106130:	e8 f9 c1 ff ff       	call   8010232e <dirlookup>
80106135:	83 c4 10             	add    $0x10,%esp
80106138:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010613b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010613f:	0f 84 0a 01 00 00    	je     8010624f <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106145:	83 ec 0c             	sub    $0xc,%esp
80106148:	ff 75 f0             	pushl  -0x10(%ebp)
8010614b:	e8 26 b9 ff ff       	call   80101a76 <ilock>
80106150:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106153:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106156:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010615a:	66 85 c0             	test   %ax,%ax
8010615d:	7f 0d                	jg     8010616c <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
8010615f:	83 ec 0c             	sub    $0xc,%esp
80106162:	68 06 92 10 80       	push   $0x80109206
80106167:	e8 fa a3 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010616c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106173:	66 83 f8 01          	cmp    $0x1,%ax
80106177:	75 25                	jne    8010619e <sys_unlink+0x117>
80106179:	83 ec 0c             	sub    $0xc,%esp
8010617c:	ff 75 f0             	pushl  -0x10(%ebp)
8010617f:	e8 a0 fe ff ff       	call   80106024 <isdirempty>
80106184:	83 c4 10             	add    $0x10,%esp
80106187:	85 c0                	test   %eax,%eax
80106189:	75 13                	jne    8010619e <sys_unlink+0x117>
    iunlockput(ip);
8010618b:	83 ec 0c             	sub    $0xc,%esp
8010618e:	ff 75 f0             	pushl  -0x10(%ebp)
80106191:	e8 c8 bb ff ff       	call   80101d5e <iunlockput>
80106196:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106199:	e9 b2 00 00 00       	jmp    80106250 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
8010619e:	83 ec 04             	sub    $0x4,%esp
801061a1:	6a 10                	push   $0x10
801061a3:	6a 00                	push   $0x0
801061a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061a8:	50                   	push   %eax
801061a9:	e8 e3 f5 ff ff       	call   80105791 <memset>
801061ae:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801061b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
801061b4:	6a 10                	push   $0x10
801061b6:	50                   	push   %eax
801061b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061ba:	50                   	push   %eax
801061bb:	ff 75 f4             	pushl  -0xc(%ebp)
801061be:	e8 c8 bf ff ff       	call   8010218b <writei>
801061c3:	83 c4 10             	add    $0x10,%esp
801061c6:	83 f8 10             	cmp    $0x10,%eax
801061c9:	74 0d                	je     801061d8 <sys_unlink+0x151>
    panic("unlink: writei");
801061cb:	83 ec 0c             	sub    $0xc,%esp
801061ce:	68 18 92 10 80       	push   $0x80109218
801061d3:	e8 8e a3 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801061d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061db:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061df:	66 83 f8 01          	cmp    $0x1,%ax
801061e3:	75 21                	jne    80106206 <sys_unlink+0x17f>
    dp->nlink--;
801061e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801061ec:	83 e8 01             	sub    $0x1,%eax
801061ef:	89 c2                	mov    %eax,%edx
801061f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f4:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801061f8:	83 ec 0c             	sub    $0xc,%esp
801061fb:	ff 75 f4             	pushl  -0xc(%ebp)
801061fe:	e8 71 b6 ff ff       	call   80101874 <iupdate>
80106203:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106206:	83 ec 0c             	sub    $0xc,%esp
80106209:	ff 75 f4             	pushl  -0xc(%ebp)
8010620c:	e8 4d bb ff ff       	call   80101d5e <iunlockput>
80106211:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106214:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106217:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010621b:	83 e8 01             	sub    $0x1,%eax
8010621e:	89 c2                	mov    %eax,%edx
80106220:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106223:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106227:	83 ec 0c             	sub    $0xc,%esp
8010622a:	ff 75 f0             	pushl  -0x10(%ebp)
8010622d:	e8 42 b6 ff ff       	call   80101874 <iupdate>
80106232:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106235:	83 ec 0c             	sub    $0xc,%esp
80106238:	ff 75 f0             	pushl  -0x10(%ebp)
8010623b:	e8 1e bb ff ff       	call   80101d5e <iunlockput>
80106240:	83 c4 10             	add    $0x10,%esp

  end_op();
80106243:	e8 ed d4 ff ff       	call   80103735 <end_op>

  return 0;
80106248:	b8 00 00 00 00       	mov    $0x0,%eax
8010624d:	eb 19                	jmp    80106268 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010624f:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	ff 75 f4             	pushl  -0xc(%ebp)
80106256:	e8 03 bb ff ff       	call   80101d5e <iunlockput>
8010625b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010625e:	e8 d2 d4 ff ff       	call   80103735 <end_op>
  return -1;
80106263:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106268:	c9                   	leave  
80106269:	c3                   	ret    

8010626a <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010626a:	55                   	push   %ebp
8010626b:	89 e5                	mov    %esp,%ebp
8010626d:	83 ec 38             	sub    $0x38,%esp
80106270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106273:	8b 55 10             	mov    0x10(%ebp),%edx
80106276:	8b 45 14             	mov    0x14(%ebp),%eax
80106279:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010627d:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106281:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106285:	83 ec 08             	sub    $0x8,%esp
80106288:	8d 45 de             	lea    -0x22(%ebp),%eax
8010628b:	50                   	push   %eax
8010628c:	ff 75 08             	pushl  0x8(%ebp)
8010628f:	e8 0c c4 ff ff       	call   801026a0 <nameiparent>
80106294:	83 c4 10             	add    $0x10,%esp
80106297:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010629a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010629e:	75 0a                	jne    801062aa <create+0x40>
    return 0;
801062a0:	b8 00 00 00 00       	mov    $0x0,%eax
801062a5:	e9 90 01 00 00       	jmp    8010643a <create+0x1d0>
  ilock(dp);
801062aa:	83 ec 0c             	sub    $0xc,%esp
801062ad:	ff 75 f4             	pushl  -0xc(%ebp)
801062b0:	e8 c1 b7 ff ff       	call   80101a76 <ilock>
801062b5:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801062b8:	83 ec 04             	sub    $0x4,%esp
801062bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062be:	50                   	push   %eax
801062bf:	8d 45 de             	lea    -0x22(%ebp),%eax
801062c2:	50                   	push   %eax
801062c3:	ff 75 f4             	pushl  -0xc(%ebp)
801062c6:	e8 63 c0 ff ff       	call   8010232e <dirlookup>
801062cb:	83 c4 10             	add    $0x10,%esp
801062ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062d5:	74 50                	je     80106327 <create+0xbd>
    iunlockput(dp);
801062d7:	83 ec 0c             	sub    $0xc,%esp
801062da:	ff 75 f4             	pushl  -0xc(%ebp)
801062dd:	e8 7c ba ff ff       	call   80101d5e <iunlockput>
801062e2:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801062e5:	83 ec 0c             	sub    $0xc,%esp
801062e8:	ff 75 f0             	pushl  -0x10(%ebp)
801062eb:	e8 86 b7 ff ff       	call   80101a76 <ilock>
801062f0:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801062f3:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801062f8:	75 15                	jne    8010630f <create+0xa5>
801062fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106301:	66 83 f8 02          	cmp    $0x2,%ax
80106305:	75 08                	jne    8010630f <create+0xa5>
      return ip;
80106307:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630a:	e9 2b 01 00 00       	jmp    8010643a <create+0x1d0>
    iunlockput(ip);
8010630f:	83 ec 0c             	sub    $0xc,%esp
80106312:	ff 75 f0             	pushl  -0x10(%ebp)
80106315:	e8 44 ba ff ff       	call   80101d5e <iunlockput>
8010631a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010631d:	b8 00 00 00 00       	mov    $0x0,%eax
80106322:	e9 13 01 00 00       	jmp    8010643a <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106327:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010632b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632e:	8b 00                	mov    (%eax),%eax
80106330:	83 ec 08             	sub    $0x8,%esp
80106333:	52                   	push   %edx
80106334:	50                   	push   %eax
80106335:	e8 63 b4 ff ff       	call   8010179d <ialloc>
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106340:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106344:	75 0d                	jne    80106353 <create+0xe9>
    panic("create: ialloc");
80106346:	83 ec 0c             	sub    $0xc,%esp
80106349:	68 27 92 10 80       	push   $0x80109227
8010634e:	e8 13 a2 ff ff       	call   80100566 <panic>

  ilock(ip);
80106353:	83 ec 0c             	sub    $0xc,%esp
80106356:	ff 75 f0             	pushl  -0x10(%ebp)
80106359:	e8 18 b7 ff ff       	call   80101a76 <ilock>
8010635e:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106361:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106364:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106368:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010636c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636f:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106373:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010637a:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106380:	83 ec 0c             	sub    $0xc,%esp
80106383:	ff 75 f0             	pushl  -0x10(%ebp)
80106386:	e8 e9 b4 ff ff       	call   80101874 <iupdate>
8010638b:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010638e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106393:	75 6a                	jne    801063ff <create+0x195>
    dp->nlink++;  // for ".."
80106395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106398:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010639c:	83 c0 01             	add    $0x1,%eax
8010639f:	89 c2                	mov    %eax,%edx
801063a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a4:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801063a8:	83 ec 0c             	sub    $0xc,%esp
801063ab:	ff 75 f4             	pushl  -0xc(%ebp)
801063ae:	e8 c1 b4 ff ff       	call   80101874 <iupdate>
801063b3:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801063b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b9:	8b 40 04             	mov    0x4(%eax),%eax
801063bc:	83 ec 04             	sub    $0x4,%esp
801063bf:	50                   	push   %eax
801063c0:	68 01 92 10 80       	push   $0x80109201
801063c5:	ff 75 f0             	pushl  -0x10(%ebp)
801063c8:	e8 1b c0 ff ff       	call   801023e8 <dirlink>
801063cd:	83 c4 10             	add    $0x10,%esp
801063d0:	85 c0                	test   %eax,%eax
801063d2:	78 1e                	js     801063f2 <create+0x188>
801063d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d7:	8b 40 04             	mov    0x4(%eax),%eax
801063da:	83 ec 04             	sub    $0x4,%esp
801063dd:	50                   	push   %eax
801063de:	68 03 92 10 80       	push   $0x80109203
801063e3:	ff 75 f0             	pushl  -0x10(%ebp)
801063e6:	e8 fd bf ff ff       	call   801023e8 <dirlink>
801063eb:	83 c4 10             	add    $0x10,%esp
801063ee:	85 c0                	test   %eax,%eax
801063f0:	79 0d                	jns    801063ff <create+0x195>
      panic("create dots");
801063f2:	83 ec 0c             	sub    $0xc,%esp
801063f5:	68 36 92 10 80       	push   $0x80109236
801063fa:	e8 67 a1 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801063ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106402:	8b 40 04             	mov    0x4(%eax),%eax
80106405:	83 ec 04             	sub    $0x4,%esp
80106408:	50                   	push   %eax
80106409:	8d 45 de             	lea    -0x22(%ebp),%eax
8010640c:	50                   	push   %eax
8010640d:	ff 75 f4             	pushl  -0xc(%ebp)
80106410:	e8 d3 bf ff ff       	call   801023e8 <dirlink>
80106415:	83 c4 10             	add    $0x10,%esp
80106418:	85 c0                	test   %eax,%eax
8010641a:	79 0d                	jns    80106429 <create+0x1bf>
    panic("create: dirlink");
8010641c:	83 ec 0c             	sub    $0xc,%esp
8010641f:	68 42 92 10 80       	push   $0x80109242
80106424:	e8 3d a1 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106429:	83 ec 0c             	sub    $0xc,%esp
8010642c:	ff 75 f4             	pushl  -0xc(%ebp)
8010642f:	e8 2a b9 ff ff       	call   80101d5e <iunlockput>
80106434:	83 c4 10             	add    $0x10,%esp

  return ip;
80106437:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010643a:	c9                   	leave  
8010643b:	c3                   	ret    

8010643c <sys_open>:

int
sys_open(void)
{
8010643c:	55                   	push   %ebp
8010643d:	89 e5                	mov    %esp,%ebp
8010643f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106442:	83 ec 08             	sub    $0x8,%esp
80106445:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106448:	50                   	push   %eax
80106449:	6a 00                	push   $0x0
8010644b:	e8 eb f6 ff ff       	call   80105b3b <argstr>
80106450:	83 c4 10             	add    $0x10,%esp
80106453:	85 c0                	test   %eax,%eax
80106455:	78 15                	js     8010646c <sys_open+0x30>
80106457:	83 ec 08             	sub    $0x8,%esp
8010645a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010645d:	50                   	push   %eax
8010645e:	6a 01                	push   $0x1
80106460:	e8 51 f6 ff ff       	call   80105ab6 <argint>
80106465:	83 c4 10             	add    $0x10,%esp
80106468:	85 c0                	test   %eax,%eax
8010646a:	79 0a                	jns    80106476 <sys_open+0x3a>
    return -1;
8010646c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106471:	e9 61 01 00 00       	jmp    801065d7 <sys_open+0x19b>

  begin_op();
80106476:	e8 2e d2 ff ff       	call   801036a9 <begin_op>

  if(omode & O_CREATE){
8010647b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010647e:	25 00 02 00 00       	and    $0x200,%eax
80106483:	85 c0                	test   %eax,%eax
80106485:	74 2a                	je     801064b1 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106487:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010648a:	6a 00                	push   $0x0
8010648c:	6a 00                	push   $0x0
8010648e:	6a 02                	push   $0x2
80106490:	50                   	push   %eax
80106491:	e8 d4 fd ff ff       	call   8010626a <create>
80106496:	83 c4 10             	add    $0x10,%esp
80106499:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010649c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064a0:	75 75                	jne    80106517 <sys_open+0xdb>
      end_op();
801064a2:	e8 8e d2 ff ff       	call   80103735 <end_op>
      return -1;
801064a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ac:	e9 26 01 00 00       	jmp    801065d7 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801064b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064b4:	83 ec 0c             	sub    $0xc,%esp
801064b7:	50                   	push   %eax
801064b8:	e8 c7 c1 ff ff       	call   80102684 <namei>
801064bd:	83 c4 10             	add    $0x10,%esp
801064c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064c7:	75 0f                	jne    801064d8 <sys_open+0x9c>
      end_op();
801064c9:	e8 67 d2 ff ff       	call   80103735 <end_op>
      return -1;
801064ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d3:	e9 ff 00 00 00       	jmp    801065d7 <sys_open+0x19b>
    }
    ilock(ip);
801064d8:	83 ec 0c             	sub    $0xc,%esp
801064db:	ff 75 f4             	pushl  -0xc(%ebp)
801064de:	e8 93 b5 ff ff       	call   80101a76 <ilock>
801064e3:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801064e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064ed:	66 83 f8 01          	cmp    $0x1,%ax
801064f1:	75 24                	jne    80106517 <sys_open+0xdb>
801064f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064f6:	85 c0                	test   %eax,%eax
801064f8:	74 1d                	je     80106517 <sys_open+0xdb>
      iunlockput(ip);
801064fa:	83 ec 0c             	sub    $0xc,%esp
801064fd:	ff 75 f4             	pushl  -0xc(%ebp)
80106500:	e8 59 b8 ff ff       	call   80101d5e <iunlockput>
80106505:	83 c4 10             	add    $0x10,%esp
      end_op();
80106508:	e8 28 d2 ff ff       	call   80103735 <end_op>
      return -1;
8010650d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106512:	e9 c0 00 00 00       	jmp    801065d7 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106517:	e8 77 aa ff ff       	call   80100f93 <filealloc>
8010651c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010651f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106523:	74 17                	je     8010653c <sys_open+0x100>
80106525:	83 ec 0c             	sub    $0xc,%esp
80106528:	ff 75 f0             	pushl  -0x10(%ebp)
8010652b:	e8 37 f7 ff ff       	call   80105c67 <fdalloc>
80106530:	83 c4 10             	add    $0x10,%esp
80106533:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106536:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010653a:	79 2e                	jns    8010656a <sys_open+0x12e>
    if(f)
8010653c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106540:	74 0e                	je     80106550 <sys_open+0x114>
      fileclose(f);
80106542:	83 ec 0c             	sub    $0xc,%esp
80106545:	ff 75 f0             	pushl  -0x10(%ebp)
80106548:	e8 04 ab ff ff       	call   80101051 <fileclose>
8010654d:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106550:	83 ec 0c             	sub    $0xc,%esp
80106553:	ff 75 f4             	pushl  -0xc(%ebp)
80106556:	e8 03 b8 ff ff       	call   80101d5e <iunlockput>
8010655b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010655e:	e8 d2 d1 ff ff       	call   80103735 <end_op>
    return -1;
80106563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106568:	eb 6d                	jmp    801065d7 <sys_open+0x19b>
  }
  iunlock(ip);
8010656a:	83 ec 0c             	sub    $0xc,%esp
8010656d:	ff 75 f4             	pushl  -0xc(%ebp)
80106570:	e8 87 b6 ff ff       	call   80101bfc <iunlock>
80106575:	83 c4 10             	add    $0x10,%esp
  end_op();
80106578:	e8 b8 d1 ff ff       	call   80103735 <end_op>

  f->type = FD_INODE;
8010657d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106580:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106586:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010658c:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010658f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106592:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010659c:	83 e0 01             	and    $0x1,%eax
8010659f:	85 c0                	test   %eax,%eax
801065a1:	0f 94 c0             	sete   %al
801065a4:	89 c2                	mov    %eax,%edx
801065a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a9:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065af:	83 e0 01             	and    $0x1,%eax
801065b2:	85 c0                	test   %eax,%eax
801065b4:	75 0a                	jne    801065c0 <sys_open+0x184>
801065b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065b9:	83 e0 02             	and    $0x2,%eax
801065bc:	85 c0                	test   %eax,%eax
801065be:	74 07                	je     801065c7 <sys_open+0x18b>
801065c0:	b8 01 00 00 00       	mov    $0x1,%eax
801065c5:	eb 05                	jmp    801065cc <sys_open+0x190>
801065c7:	b8 00 00 00 00       	mov    $0x0,%eax
801065cc:	89 c2                	mov    %eax,%edx
801065ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065d1:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801065d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801065d7:	c9                   	leave  
801065d8:	c3                   	ret    

801065d9 <sys_mkdir>:

int
sys_mkdir(void)
{
801065d9:	55                   	push   %ebp
801065da:	89 e5                	mov    %esp,%ebp
801065dc:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065df:	e8 c5 d0 ff ff       	call   801036a9 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065e4:	83 ec 08             	sub    $0x8,%esp
801065e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065ea:	50                   	push   %eax
801065eb:	6a 00                	push   $0x0
801065ed:	e8 49 f5 ff ff       	call   80105b3b <argstr>
801065f2:	83 c4 10             	add    $0x10,%esp
801065f5:	85 c0                	test   %eax,%eax
801065f7:	78 1b                	js     80106614 <sys_mkdir+0x3b>
801065f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065fc:	6a 00                	push   $0x0
801065fe:	6a 00                	push   $0x0
80106600:	6a 01                	push   $0x1
80106602:	50                   	push   %eax
80106603:	e8 62 fc ff ff       	call   8010626a <create>
80106608:	83 c4 10             	add    $0x10,%esp
8010660b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010660e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106612:	75 0c                	jne    80106620 <sys_mkdir+0x47>
    end_op();
80106614:	e8 1c d1 ff ff       	call   80103735 <end_op>
    return -1;
80106619:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010661e:	eb 18                	jmp    80106638 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	ff 75 f4             	pushl  -0xc(%ebp)
80106626:	e8 33 b7 ff ff       	call   80101d5e <iunlockput>
8010662b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010662e:	e8 02 d1 ff ff       	call   80103735 <end_op>
  return 0;
80106633:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106638:	c9                   	leave  
80106639:	c3                   	ret    

8010663a <sys_mknod>:

int
sys_mknod(void)
{
8010663a:	55                   	push   %ebp
8010663b:	89 e5                	mov    %esp,%ebp
8010663d:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106640:	e8 64 d0 ff ff       	call   801036a9 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106645:	83 ec 08             	sub    $0x8,%esp
80106648:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010664b:	50                   	push   %eax
8010664c:	6a 00                	push   $0x0
8010664e:	e8 e8 f4 ff ff       	call   80105b3b <argstr>
80106653:	83 c4 10             	add    $0x10,%esp
80106656:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010665d:	78 4f                	js     801066ae <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010665f:	83 ec 08             	sub    $0x8,%esp
80106662:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106665:	50                   	push   %eax
80106666:	6a 01                	push   $0x1
80106668:	e8 49 f4 ff ff       	call   80105ab6 <argint>
8010666d:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106670:	85 c0                	test   %eax,%eax
80106672:	78 3a                	js     801066ae <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106674:	83 ec 08             	sub    $0x8,%esp
80106677:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010667a:	50                   	push   %eax
8010667b:	6a 02                	push   $0x2
8010667d:	e8 34 f4 ff ff       	call   80105ab6 <argint>
80106682:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106685:	85 c0                	test   %eax,%eax
80106687:	78 25                	js     801066ae <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010668c:	0f bf c8             	movswl %ax,%ecx
8010668f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106692:	0f bf d0             	movswl %ax,%edx
80106695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106698:	51                   	push   %ecx
80106699:	52                   	push   %edx
8010669a:	6a 03                	push   $0x3
8010669c:	50                   	push   %eax
8010669d:	e8 c8 fb ff ff       	call   8010626a <create>
801066a2:	83 c4 10             	add    $0x10,%esp
801066a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066ac:	75 0c                	jne    801066ba <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801066ae:	e8 82 d0 ff ff       	call   80103735 <end_op>
    return -1;
801066b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b8:	eb 18                	jmp    801066d2 <sys_mknod+0x98>
  }
  iunlockput(ip);
801066ba:	83 ec 0c             	sub    $0xc,%esp
801066bd:	ff 75 f0             	pushl  -0x10(%ebp)
801066c0:	e8 99 b6 ff ff       	call   80101d5e <iunlockput>
801066c5:	83 c4 10             	add    $0x10,%esp
  end_op();
801066c8:	e8 68 d0 ff ff       	call   80103735 <end_op>
  return 0;
801066cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066d2:	c9                   	leave  
801066d3:	c3                   	ret    

801066d4 <sys_chdir>:

int
sys_chdir(void)
{
801066d4:	55                   	push   %ebp
801066d5:	89 e5                	mov    %esp,%ebp
801066d7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801066da:	e8 ca cf ff ff       	call   801036a9 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066df:	83 ec 08             	sub    $0x8,%esp
801066e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066e5:	50                   	push   %eax
801066e6:	6a 00                	push   $0x0
801066e8:	e8 4e f4 ff ff       	call   80105b3b <argstr>
801066ed:	83 c4 10             	add    $0x10,%esp
801066f0:	85 c0                	test   %eax,%eax
801066f2:	78 18                	js     8010670c <sys_chdir+0x38>
801066f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066f7:	83 ec 0c             	sub    $0xc,%esp
801066fa:	50                   	push   %eax
801066fb:	e8 84 bf ff ff       	call   80102684 <namei>
80106700:	83 c4 10             	add    $0x10,%esp
80106703:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010670a:	75 0c                	jne    80106718 <sys_chdir+0x44>
    end_op();
8010670c:	e8 24 d0 ff ff       	call   80103735 <end_op>
    return -1;
80106711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106716:	eb 6e                	jmp    80106786 <sys_chdir+0xb2>
  }
  ilock(ip);
80106718:	83 ec 0c             	sub    $0xc,%esp
8010671b:	ff 75 f4             	pushl  -0xc(%ebp)
8010671e:	e8 53 b3 ff ff       	call   80101a76 <ilock>
80106723:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106729:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010672d:	66 83 f8 01          	cmp    $0x1,%ax
80106731:	74 1a                	je     8010674d <sys_chdir+0x79>
    iunlockput(ip);
80106733:	83 ec 0c             	sub    $0xc,%esp
80106736:	ff 75 f4             	pushl  -0xc(%ebp)
80106739:	e8 20 b6 ff ff       	call   80101d5e <iunlockput>
8010673e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106741:	e8 ef cf ff ff       	call   80103735 <end_op>
    return -1;
80106746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674b:	eb 39                	jmp    80106786 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010674d:	83 ec 0c             	sub    $0xc,%esp
80106750:	ff 75 f4             	pushl  -0xc(%ebp)
80106753:	e8 a4 b4 ff ff       	call   80101bfc <iunlock>
80106758:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010675b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106761:	8b 40 68             	mov    0x68(%eax),%eax
80106764:	83 ec 0c             	sub    $0xc,%esp
80106767:	50                   	push   %eax
80106768:	e8 01 b5 ff ff       	call   80101c6e <iput>
8010676d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106770:	e8 c0 cf ff ff       	call   80103735 <end_op>
  proc->cwd = ip;
80106775:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010677b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010677e:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106781:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106786:	c9                   	leave  
80106787:	c3                   	ret    

80106788 <sys_exec>:

int
sys_exec(void)
{
80106788:	55                   	push   %ebp
80106789:	89 e5                	mov    %esp,%ebp
8010678b:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106791:	83 ec 08             	sub    $0x8,%esp
80106794:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106797:	50                   	push   %eax
80106798:	6a 00                	push   $0x0
8010679a:	e8 9c f3 ff ff       	call   80105b3b <argstr>
8010679f:	83 c4 10             	add    $0x10,%esp
801067a2:	85 c0                	test   %eax,%eax
801067a4:	78 18                	js     801067be <sys_exec+0x36>
801067a6:	83 ec 08             	sub    $0x8,%esp
801067a9:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801067af:	50                   	push   %eax
801067b0:	6a 01                	push   $0x1
801067b2:	e8 ff f2 ff ff       	call   80105ab6 <argint>
801067b7:	83 c4 10             	add    $0x10,%esp
801067ba:	85 c0                	test   %eax,%eax
801067bc:	79 0a                	jns    801067c8 <sys_exec+0x40>
    return -1;
801067be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c3:	e9 c6 00 00 00       	jmp    8010688e <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801067c8:	83 ec 04             	sub    $0x4,%esp
801067cb:	68 80 00 00 00       	push   $0x80
801067d0:	6a 00                	push   $0x0
801067d2:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801067d8:	50                   	push   %eax
801067d9:	e8 b3 ef ff ff       	call   80105791 <memset>
801067de:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801067e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801067e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067eb:	83 f8 1f             	cmp    $0x1f,%eax
801067ee:	76 0a                	jbe    801067fa <sys_exec+0x72>
      return -1;
801067f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f5:	e9 94 00 00 00       	jmp    8010688e <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067fd:	c1 e0 02             	shl    $0x2,%eax
80106800:	89 c2                	mov    %eax,%edx
80106802:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106808:	01 c2                	add    %eax,%edx
8010680a:	83 ec 08             	sub    $0x8,%esp
8010680d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106813:	50                   	push   %eax
80106814:	52                   	push   %edx
80106815:	e8 00 f2 ff ff       	call   80105a1a <fetchint>
8010681a:	83 c4 10             	add    $0x10,%esp
8010681d:	85 c0                	test   %eax,%eax
8010681f:	79 07                	jns    80106828 <sys_exec+0xa0>
      return -1;
80106821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106826:	eb 66                	jmp    8010688e <sys_exec+0x106>
    if(uarg == 0){
80106828:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010682e:	85 c0                	test   %eax,%eax
80106830:	75 27                	jne    80106859 <sys_exec+0xd1>
      argv[i] = 0;
80106832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106835:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010683c:	00 00 00 00 
      break;
80106840:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106844:	83 ec 08             	sub    $0x8,%esp
80106847:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010684d:	52                   	push   %edx
8010684e:	50                   	push   %eax
8010684f:	e8 1d a3 ff ff       	call   80100b71 <exec>
80106854:	83 c4 10             	add    $0x10,%esp
80106857:	eb 35                	jmp    8010688e <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106859:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010685f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106862:	c1 e2 02             	shl    $0x2,%edx
80106865:	01 c2                	add    %eax,%edx
80106867:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010686d:	83 ec 08             	sub    $0x8,%esp
80106870:	52                   	push   %edx
80106871:	50                   	push   %eax
80106872:	e8 dd f1 ff ff       	call   80105a54 <fetchstr>
80106877:	83 c4 10             	add    $0x10,%esp
8010687a:	85 c0                	test   %eax,%eax
8010687c:	79 07                	jns    80106885 <sys_exec+0xfd>
      return -1;
8010687e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106883:	eb 09                	jmp    8010688e <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106885:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106889:	e9 5a ff ff ff       	jmp    801067e8 <sys_exec+0x60>
  return exec(path, argv);
}
8010688e:	c9                   	leave  
8010688f:	c3                   	ret    

80106890 <sys_pipe>:

int
sys_pipe(void)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106896:	83 ec 04             	sub    $0x4,%esp
80106899:	6a 08                	push   $0x8
8010689b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010689e:	50                   	push   %eax
8010689f:	6a 00                	push   $0x0
801068a1:	e8 38 f2 ff ff       	call   80105ade <argptr>
801068a6:	83 c4 10             	add    $0x10,%esp
801068a9:	85 c0                	test   %eax,%eax
801068ab:	79 0a                	jns    801068b7 <sys_pipe+0x27>
    return -1;
801068ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b2:	e9 af 00 00 00       	jmp    80106966 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801068b7:	83 ec 08             	sub    $0x8,%esp
801068ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068bd:	50                   	push   %eax
801068be:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068c1:	50                   	push   %eax
801068c2:	e8 d6 d8 ff ff       	call   8010419d <pipealloc>
801068c7:	83 c4 10             	add    $0x10,%esp
801068ca:	85 c0                	test   %eax,%eax
801068cc:	79 0a                	jns    801068d8 <sys_pipe+0x48>
    return -1;
801068ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d3:	e9 8e 00 00 00       	jmp    80106966 <sys_pipe+0xd6>
  fd0 = -1;
801068d8:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068e2:	83 ec 0c             	sub    $0xc,%esp
801068e5:	50                   	push   %eax
801068e6:	e8 7c f3 ff ff       	call   80105c67 <fdalloc>
801068eb:	83 c4 10             	add    $0x10,%esp
801068ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068f5:	78 18                	js     8010690f <sys_pipe+0x7f>
801068f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068fa:	83 ec 0c             	sub    $0xc,%esp
801068fd:	50                   	push   %eax
801068fe:	e8 64 f3 ff ff       	call   80105c67 <fdalloc>
80106903:	83 c4 10             	add    $0x10,%esp
80106906:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106909:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010690d:	79 3f                	jns    8010694e <sys_pipe+0xbe>
    if(fd0 >= 0)
8010690f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106913:	78 14                	js     80106929 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106915:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010691b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010691e:	83 c2 08             	add    $0x8,%edx
80106921:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106928:	00 
    fileclose(rf);
80106929:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010692c:	83 ec 0c             	sub    $0xc,%esp
8010692f:	50                   	push   %eax
80106930:	e8 1c a7 ff ff       	call   80101051 <fileclose>
80106935:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010693b:	83 ec 0c             	sub    $0xc,%esp
8010693e:	50                   	push   %eax
8010693f:	e8 0d a7 ff ff       	call   80101051 <fileclose>
80106944:	83 c4 10             	add    $0x10,%esp
    return -1;
80106947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694c:	eb 18                	jmp    80106966 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010694e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106951:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106954:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106956:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106959:	8d 50 04             	lea    0x4(%eax),%edx
8010695c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010695f:	89 02                	mov    %eax,(%edx)
  return 0;
80106961:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106966:	c9                   	leave  
80106967:	c3                   	ret    

80106968 <sys_chown>:

#ifdef CS333_P4
int
sys_chown(void)
{
80106968:	55                   	push   %ebp
80106969:	89 e5                	mov    %esp,%ebp
8010696b:	83 ec 18             	sub    $0x18,%esp
    char* path;
    struct inode* ip;
    int nuid;
    
    // error checking
    if(argstr(0, &path) < 0)
8010696e:	83 ec 08             	sub    $0x8,%esp
80106971:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106974:	50                   	push   %eax
80106975:	6a 00                	push   $0x0
80106977:	e8 bf f1 ff ff       	call   80105b3b <argstr>
8010697c:	83 c4 10             	add    $0x10,%esp
8010697f:	85 c0                	test   %eax,%eax
80106981:	79 07                	jns    8010698a <sys_chown+0x22>
        return -1;
80106983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106988:	eb 65                	jmp    801069ef <sys_chown+0x87>
    if(argint(1, &nuid) < 0 || argint(1, &nuid) > 32767)
8010698a:	83 ec 08             	sub    $0x8,%esp
8010698d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106990:	50                   	push   %eax
80106991:	6a 01                	push   $0x1
80106993:	e8 1e f1 ff ff       	call   80105ab6 <argint>
80106998:	83 c4 10             	add    $0x10,%esp
8010699b:	85 c0                	test   %eax,%eax
8010699d:	78 18                	js     801069b7 <sys_chown+0x4f>
8010699f:	83 ec 08             	sub    $0x8,%esp
801069a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069a5:	50                   	push   %eax
801069a6:	6a 01                	push   $0x1
801069a8:	e8 09 f1 ff ff       	call   80105ab6 <argint>
801069ad:	83 c4 10             	add    $0x10,%esp
801069b0:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801069b5:	7e 07                	jle    801069be <sys_chown+0x56>
        return -1;
801069b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069bc:	eb 31                	jmp    801069ef <sys_chown+0x87>
    ip = namei(path);
801069be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069c1:	83 ec 0c             	sub    $0xc,%esp
801069c4:	50                   	push   %eax
801069c5:	e8 ba bc ff ff       	call   80102684 <namei>
801069ca:	83 c4 10             	add    $0x10,%esp
801069cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801069d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069d4:	75 07                	jne    801069dd <sys_chown+0x75>
      return -1;
801069d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069db:	eb 12                	jmp    801069ef <sys_chown+0x87>
    }
    return changeowner(ip, nuid);
801069dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801069e0:	83 ec 08             	sub    $0x8,%esp
801069e3:	50                   	push   %eax
801069e4:	ff 75 f4             	pushl  -0xc(%ebp)
801069e7:	e8 98 a9 ff ff       	call   80101384 <changeowner>
801069ec:	83 c4 10             	add    $0x10,%esp
}
801069ef:	c9                   	leave  
801069f0:	c3                   	ret    

801069f1 <sys_chgrp>:

int
sys_chgrp(void)
{ 
801069f1:	55                   	push   %ebp
801069f2:	89 e5                	mov    %esp,%ebp
801069f4:	83 ec 18             	sub    $0x18,%esp
    char* path;
    struct inode* ip;
    int ngid;
    
    // error checking
    if(argstr(0, &path) < 0)
801069f7:	83 ec 08             	sub    $0x8,%esp
801069fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069fd:	50                   	push   %eax
801069fe:	6a 00                	push   $0x0
80106a00:	e8 36 f1 ff ff       	call   80105b3b <argstr>
80106a05:	83 c4 10             	add    $0x10,%esp
80106a08:	85 c0                	test   %eax,%eax
80106a0a:	79 07                	jns    80106a13 <sys_chgrp+0x22>
        return -1;
80106a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a11:	eb 65                	jmp    80106a78 <sys_chgrp+0x87>
    if(argint(1, &ngid) < 0 || argint(1, &ngid) > 32767)
80106a13:	83 ec 08             	sub    $0x8,%esp
80106a16:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a19:	50                   	push   %eax
80106a1a:	6a 01                	push   $0x1
80106a1c:	e8 95 f0 ff ff       	call   80105ab6 <argint>
80106a21:	83 c4 10             	add    $0x10,%esp
80106a24:	85 c0                	test   %eax,%eax
80106a26:	78 18                	js     80106a40 <sys_chgrp+0x4f>
80106a28:	83 ec 08             	sub    $0x8,%esp
80106a2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a2e:	50                   	push   %eax
80106a2f:	6a 01                	push   $0x1
80106a31:	e8 80 f0 ff ff       	call   80105ab6 <argint>
80106a36:	83 c4 10             	add    $0x10,%esp
80106a39:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106a3e:	7e 07                	jle    80106a47 <sys_chgrp+0x56>
        return -1;
80106a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a45:	eb 31                	jmp    80106a78 <sys_chgrp+0x87>
    ip = namei(path);
80106a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a4a:	83 ec 0c             	sub    $0xc,%esp
80106a4d:	50                   	push   %eax
80106a4e:	e8 31 bc ff ff       	call   80102684 <namei>
80106a53:	83 c4 10             	add    $0x10,%esp
80106a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a5d:	75 07                	jne    80106a66 <sys_chgrp+0x75>
      return -1;
80106a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a64:	eb 12                	jmp    80106a78 <sys_chgrp+0x87>
    }
    return changegroup(ip, ngid);
80106a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a69:	83 ec 08             	sub    $0x8,%esp
80106a6c:	50                   	push   %eax
80106a6d:	ff 75 f4             	pushl  -0xc(%ebp)
80106a70:	e8 5c a9 ff ff       	call   801013d1 <changegroup>
80106a75:	83 c4 10             	add    $0x10,%esp

}
80106a78:	c9                   	leave  
80106a79:	c3                   	ret    

80106a7a <sys_chmod>:

int
sys_chmod(void)
{
80106a7a:	55                   	push   %ebp
80106a7b:	89 e5                	mov    %esp,%ebp
80106a7d:	83 ec 18             	sub    $0x18,%esp
    char* path;
    struct inode* ip;
    int mode;
    
    // error checking
    if(argstr(0, &path) < 0)
80106a80:	83 ec 08             	sub    $0x8,%esp
80106a83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a86:	50                   	push   %eax
80106a87:	6a 00                	push   $0x0
80106a89:	e8 ad f0 ff ff       	call   80105b3b <argstr>
80106a8e:	83 c4 10             	add    $0x10,%esp
80106a91:	85 c0                	test   %eax,%eax
80106a93:	79 07                	jns    80106a9c <sys_chmod+0x22>
        return -1;
80106a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9a:	eb 65                	jmp    80106b01 <sys_chmod+0x87>
    if(argint(1, &mode) < 0 || argint(1, &mode) > 01755 )
80106a9c:	83 ec 08             	sub    $0x8,%esp
80106a9f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106aa2:	50                   	push   %eax
80106aa3:	6a 01                	push   $0x1
80106aa5:	e8 0c f0 ff ff       	call   80105ab6 <argint>
80106aaa:	83 c4 10             	add    $0x10,%esp
80106aad:	85 c0                	test   %eax,%eax
80106aaf:	78 18                	js     80106ac9 <sys_chmod+0x4f>
80106ab1:	83 ec 08             	sub    $0x8,%esp
80106ab4:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ab7:	50                   	push   %eax
80106ab8:	6a 01                	push   $0x1
80106aba:	e8 f7 ef ff ff       	call   80105ab6 <argint>
80106abf:	83 c4 10             	add    $0x10,%esp
80106ac2:	3d ed 03 00 00       	cmp    $0x3ed,%eax
80106ac7:	7e 07                	jle    80106ad0 <sys_chmod+0x56>
        return -1;
80106ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ace:	eb 31                	jmp    80106b01 <sys_chmod+0x87>
    
    ip = namei(path);
80106ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ad3:	83 ec 0c             	sub    $0xc,%esp
80106ad6:	50                   	push   %eax
80106ad7:	e8 a8 bb ff ff       	call   80102684 <namei>
80106adc:	83 c4 10             	add    $0x10,%esp
80106adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ae6:	75 07                	jne    80106aef <sys_chmod+0x75>
      return -1;
80106ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aed:	eb 12                	jmp    80106b01 <sys_chmod+0x87>
    }
    return changemode(ip, mode);
80106aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106af2:	83 ec 08             	sub    $0x8,%esp
80106af5:	50                   	push   %eax
80106af6:	ff 75 f4             	pushl  -0xc(%ebp)
80106af9:	e8 20 a9 ff ff       	call   8010141e <changemode>
80106afe:	83 c4 10             	add    $0x10,%esp
    
}
80106b01:	c9                   	leave  
80106b02:	c3                   	ret    

80106b03 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80106b03:	55                   	push   %ebp
80106b04:	89 e5                	mov    %esp,%ebp
80106b06:	83 ec 08             	sub    $0x8,%esp
80106b09:	8b 55 08             	mov    0x8(%ebp),%edx
80106b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b0f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b13:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b17:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106b1b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b1f:	66 ef                	out    %ax,(%dx)
}
80106b21:	90                   	nop
80106b22:	c9                   	leave  
80106b23:	c3                   	ret    

80106b24 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106b24:	55                   	push   %ebp
80106b25:	89 e5                	mov    %esp,%ebp
80106b27:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106b2a:	e8 cc dd ff ff       	call   801048fb <fork>
}
80106b2f:	c9                   	leave  
80106b30:	c3                   	ret    

80106b31 <sys_exit>:

int
sys_exit(void)
{
80106b31:	55                   	push   %ebp
80106b32:	89 e5                	mov    %esp,%ebp
80106b34:	83 ec 08             	sub    $0x8,%esp
  exit();
80106b37:	e8 7a df ff ff       	call   80104ab6 <exit>
  return 0;  // not reached
80106b3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b41:	c9                   	leave  
80106b42:	c3                   	ret    

80106b43 <sys_wait>:

int
sys_wait(void)
{
80106b43:	55                   	push   %ebp
80106b44:	89 e5                	mov    %esp,%ebp
80106b46:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106b49:	e8 a3 e0 ff ff       	call   80104bf1 <wait>
}
80106b4e:	c9                   	leave  
80106b4f:	c3                   	ret    

80106b50 <sys_kill>:

int
sys_kill(void)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b56:	83 ec 08             	sub    $0x8,%esp
80106b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b5c:	50                   	push   %eax
80106b5d:	6a 00                	push   $0x0
80106b5f:	e8 52 ef ff ff       	call   80105ab6 <argint>
80106b64:	83 c4 10             	add    $0x10,%esp
80106b67:	85 c0                	test   %eax,%eax
80106b69:	79 07                	jns    80106b72 <sys_kill+0x22>
    return -1;
80106b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b70:	eb 0f                	jmp    80106b81 <sys_kill+0x31>
  return kill(pid);
80106b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b75:	83 ec 0c             	sub    $0xc,%esp
80106b78:	50                   	push   %eax
80106b79:	e8 3e e5 ff ff       	call   801050bc <kill>
80106b7e:	83 c4 10             	add    $0x10,%esp
}
80106b81:	c9                   	leave  
80106b82:	c3                   	ret    

80106b83 <sys_getpid>:

int
sys_getpid(void)
{
80106b83:	55                   	push   %ebp
80106b84:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106b86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b8c:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b8f:	5d                   	pop    %ebp
80106b90:	c3                   	ret    

80106b91 <sys_sbrk>:

int
sys_sbrk(void)
{
80106b91:	55                   	push   %ebp
80106b92:	89 e5                	mov    %esp,%ebp
80106b94:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106b97:	83 ec 08             	sub    $0x8,%esp
80106b9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b9d:	50                   	push   %eax
80106b9e:	6a 00                	push   $0x0
80106ba0:	e8 11 ef ff ff       	call   80105ab6 <argint>
80106ba5:	83 c4 10             	add    $0x10,%esp
80106ba8:	85 c0                	test   %eax,%eax
80106baa:	79 07                	jns    80106bb3 <sys_sbrk+0x22>
    return -1;
80106bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb1:	eb 28                	jmp    80106bdb <sys_sbrk+0x4a>
  addr = proc->sz;
80106bb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bb9:	8b 00                	mov    (%eax),%eax
80106bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bc1:	83 ec 0c             	sub    $0xc,%esp
80106bc4:	50                   	push   %eax
80106bc5:	e8 8e dc ff ff       	call   80104858 <growproc>
80106bca:	83 c4 10             	add    $0x10,%esp
80106bcd:	85 c0                	test   %eax,%eax
80106bcf:	79 07                	jns    80106bd8 <sys_sbrk+0x47>
    return -1;
80106bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bd6:	eb 03                	jmp    80106bdb <sys_sbrk+0x4a>
  return addr;
80106bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106bdb:	c9                   	leave  
80106bdc:	c3                   	ret    

80106bdd <sys_sleep>:

int
sys_sleep(void)
{
80106bdd:	55                   	push   %ebp
80106bde:	89 e5                	mov    %esp,%ebp
80106be0:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106be3:	83 ec 08             	sub    $0x8,%esp
80106be6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106be9:	50                   	push   %eax
80106bea:	6a 00                	push   $0x0
80106bec:	e8 c5 ee ff ff       	call   80105ab6 <argint>
80106bf1:	83 c4 10             	add    $0x10,%esp
80106bf4:	85 c0                	test   %eax,%eax
80106bf6:	79 07                	jns    80106bff <sys_sleep+0x22>
    return -1;
80106bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bfd:	eb 77                	jmp    80106c76 <sys_sleep+0x99>
  acquire(&tickslock);
80106bff:	83 ec 0c             	sub    $0xc,%esp
80106c02:	68 e0 5d 11 80       	push   $0x80115de0
80106c07:	e8 22 e9 ff ff       	call   8010552e <acquire>
80106c0c:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106c0f:	a1 20 66 11 80       	mov    0x80116620,%eax
80106c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106c17:	eb 39                	jmp    80106c52 <sys_sleep+0x75>
    if(proc->killed){
80106c19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c1f:	8b 40 24             	mov    0x24(%eax),%eax
80106c22:	85 c0                	test   %eax,%eax
80106c24:	74 17                	je     80106c3d <sys_sleep+0x60>
      release(&tickslock);
80106c26:	83 ec 0c             	sub    $0xc,%esp
80106c29:	68 e0 5d 11 80       	push   $0x80115de0
80106c2e:	e8 62 e9 ff ff       	call   80105595 <release>
80106c33:	83 c4 10             	add    $0x10,%esp
      return -1;
80106c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c3b:	eb 39                	jmp    80106c76 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106c3d:	83 ec 08             	sub    $0x8,%esp
80106c40:	68 e0 5d 11 80       	push   $0x80115de0
80106c45:	68 20 66 11 80       	push   $0x80116620
80106c4a:	e8 48 e3 ff ff       	call   80104f97 <sleep>
80106c4f:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106c52:	a1 20 66 11 80       	mov    0x80116620,%eax
80106c57:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106c5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c5d:	39 d0                	cmp    %edx,%eax
80106c5f:	72 b8                	jb     80106c19 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106c61:	83 ec 0c             	sub    $0xc,%esp
80106c64:	68 e0 5d 11 80       	push   $0x80115de0
80106c69:	e8 27 e9 ff ff       	call   80105595 <release>
80106c6e:	83 c4 10             	add    $0x10,%esp
  return 0;
80106c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c76:	c9                   	leave  
80106c77:	c3                   	ret    

80106c78 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c78:	55                   	push   %ebp
80106c79:	89 e5                	mov    %esp,%ebp
80106c7b:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106c7e:	83 ec 0c             	sub    $0xc,%esp
80106c81:	68 e0 5d 11 80       	push   $0x80115de0
80106c86:	e8 a3 e8 ff ff       	call   8010552e <acquire>
80106c8b:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106c8e:	a1 20 66 11 80       	mov    0x80116620,%eax
80106c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106c96:	83 ec 0c             	sub    $0xc,%esp
80106c99:	68 e0 5d 11 80       	push   $0x80115de0
80106c9e:	e8 f2 e8 ff ff       	call   80105595 <release>
80106ca3:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106ca9:	c9                   	leave  
80106caa:	c3                   	ret    

80106cab <sys_halt>:

//Turn of the computer
int sys_halt(void){
80106cab:	55                   	push   %ebp
80106cac:	89 e5                	mov    %esp,%ebp
80106cae:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80106cb1:	83 ec 0c             	sub    $0xc,%esp
80106cb4:	68 52 92 10 80       	push   $0x80109252
80106cb9:	e8 08 97 ff ff       	call   801003c6 <cprintf>
80106cbe:	83 c4 10             	add    $0x10,%esp
  outw (0xB004, 0x0 | 0x2000);
80106cc1:	83 ec 08             	sub    $0x8,%esp
80106cc4:	68 00 20 00 00       	push   $0x2000
80106cc9:	68 04 b0 00 00       	push   $0xb004
80106cce:	e8 30 fe ff ff       	call   80106b03 <outw>
80106cd3:	83 c4 10             	add    $0x10,%esp
  return 0;
80106cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cdb:	c9                   	leave  
80106cdc:	c3                   	ret    

80106cdd <sys_date>:

int sys_date(void){
80106cdd:	55                   	push   %ebp
80106cde:	89 e5                	mov    %esp,%ebp
80106ce0:	83 ec 18             	sub    $0x18,%esp

    struct rtcdate* d;

    if(argptr(0, (char**)&d, sizeof(*d)) <0) 
80106ce3:	83 ec 04             	sub    $0x4,%esp
80106ce6:	6a 18                	push   $0x18
80106ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ceb:	50                   	push   %eax
80106cec:	6a 00                	push   $0x0
80106cee:	e8 eb ed ff ff       	call   80105ade <argptr>
80106cf3:	83 c4 10             	add    $0x10,%esp
80106cf6:	85 c0                	test   %eax,%eax
80106cf8:	79 07                	jns    80106d01 <sys_date+0x24>
        return -1;
80106cfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cff:	eb 14                	jmp    80106d15 <sys_date+0x38>
   
    cmostime(d);
80106d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d04:	83 ec 0c             	sub    $0xc,%esp
80106d07:	50                   	push   %eax
80106d08:	e8 17 c6 ff ff       	call   80103324 <cmostime>
80106d0d:	83 c4 10             	add    $0x10,%esp
    return 0;
80106d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d15:	c9                   	leave  
80106d16:	c3                   	ret    

80106d17 <sys_getuid>:


uint
sys_getuid(void)
{
80106d17:	55                   	push   %ebp
80106d18:	89 e5                	mov    %esp,%ebp
    return proc->uid;
80106d1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d20:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80106d26:	5d                   	pop    %ebp
80106d27:	c3                   	ret    

80106d28 <sys_getgid>:

uint
sys_getgid(void)
{ 
80106d28:	55                   	push   %ebp
80106d29:	89 e5                	mov    %esp,%ebp
    return proc->gid;
80106d2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d31:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106d37:	5d                   	pop    %ebp
80106d38:	c3                   	ret    

80106d39 <sys_getppid>:

uint
sys_getppid(void)
{
80106d39:	55                   	push   %ebp
80106d3a:	89 e5                	mov    %esp,%ebp

    if(proc->pid == 1)
80106d3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d42:	8b 40 10             	mov    0x10(%eax),%eax
80106d45:	83 f8 01             	cmp    $0x1,%eax
80106d48:	75 07                	jne    80106d51 <sys_getppid+0x18>
        return 1;
80106d4a:	b8 01 00 00 00       	mov    $0x1,%eax
80106d4f:	eb 0c                	jmp    80106d5d <sys_getppid+0x24>
    return proc->parent->pid;
80106d51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d57:	8b 40 14             	mov    0x14(%eax),%eax
80106d5a:	8b 40 10             	mov    0x10(%eax),%eax
}
80106d5d:	5d                   	pop    %ebp
80106d5e:	c3                   	ret    

80106d5f <sys_setuid>:

int
sys_setuid(void)
{
80106d5f:	55                   	push   %ebp
80106d60:	89 e5                	mov    %esp,%ebp
80106d62:	83 ec 08             	sub    $0x8,%esp
    

    if(argint(0, (int*)&proc->uid)) 
80106d65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d6b:	83 e8 80             	sub    $0xffffff80,%eax
80106d6e:	83 ec 08             	sub    $0x8,%esp
80106d71:	50                   	push   %eax
80106d72:	6a 00                	push   $0x0
80106d74:	e8 3d ed ff ff       	call   80105ab6 <argint>
80106d79:	83 c4 10             	add    $0x10,%esp
80106d7c:	85 c0                	test   %eax,%eax
80106d7e:	74 07                	je     80106d87 <sys_setuid+0x28>
        return -1;
80106d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d85:	eb 2f                	jmp    80106db6 <sys_setuid+0x57>
    
    if(proc->uid < 0 || proc->uid > 32767){
80106d87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d8d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106d93:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106d98:	76 17                	jbe    80106db1 <sys_setuid+0x52>
        proc->uid = 0;
80106d9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106da0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106da7:	00 00 00 
        return -1;
80106daa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106daf:	eb 05                	jmp    80106db6 <sys_setuid+0x57>
    }
    else
        return 0;
80106db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106db6:	c9                   	leave  
80106db7:	c3                   	ret    

80106db8 <sys_setgid>:

int
sys_setgid(void)
{
80106db8:	55                   	push   %ebp
80106db9:	89 e5                	mov    %esp,%ebp
80106dbb:	83 ec 08             	sub    $0x8,%esp

    if(argint(0, (int*)&proc->gid) )
80106dbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc4:	05 84 00 00 00       	add    $0x84,%eax
80106dc9:	83 ec 08             	sub    $0x8,%esp
80106dcc:	50                   	push   %eax
80106dcd:	6a 00                	push   $0x0
80106dcf:	e8 e2 ec ff ff       	call   80105ab6 <argint>
80106dd4:	83 c4 10             	add    $0x10,%esp
80106dd7:	85 c0                	test   %eax,%eax
80106dd9:	74 07                	je     80106de2 <sys_setgid+0x2a>
        return -1;
80106ddb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106de0:	eb 2f                	jmp    80106e11 <sys_setgid+0x59>
    if(proc->gid < 0 || proc -> gid > 32767){
80106de2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106de8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80106dee:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106df3:	76 17                	jbe    80106e0c <sys_setgid+0x54>
        proc->gid = 0;
80106df5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dfb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80106e02:	00 00 00 
        return -1;
80106e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e0a:	eb 05                	jmp    80106e11 <sys_setgid+0x59>
    }
    else 
        return 0;
80106e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e11:	c9                   	leave  
80106e12:	c3                   	ret    

80106e13 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106e13:	55                   	push   %ebp
80106e14:	89 e5                	mov    %esp,%ebp
80106e16:	83 ec 08             	sub    $0x8,%esp
80106e19:	8b 55 08             	mov    0x8(%ebp),%edx
80106e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e1f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106e23:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e26:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106e2a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106e2e:	ee                   	out    %al,(%dx)
}
80106e2f:	90                   	nop
80106e30:	c9                   	leave  
80106e31:	c3                   	ret    

80106e32 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106e32:	55                   	push   %ebp
80106e33:	89 e5                	mov    %esp,%ebp
80106e35:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106e38:	6a 34                	push   $0x34
80106e3a:	6a 43                	push   $0x43
80106e3c:	e8 d2 ff ff ff       	call   80106e13 <outb>
80106e41:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106e44:	68 9c 00 00 00       	push   $0x9c
80106e49:	6a 40                	push   $0x40
80106e4b:	e8 c3 ff ff ff       	call   80106e13 <outb>
80106e50:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106e53:	6a 2e                	push   $0x2e
80106e55:	6a 40                	push   $0x40
80106e57:	e8 b7 ff ff ff       	call   80106e13 <outb>
80106e5c:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106e5f:	83 ec 0c             	sub    $0xc,%esp
80106e62:	6a 00                	push   $0x0
80106e64:	e8 1e d2 ff ff       	call   80104087 <picenable>
80106e69:	83 c4 10             	add    $0x10,%esp
}
80106e6c:	90                   	nop
80106e6d:	c9                   	leave  
80106e6e:	c3                   	ret    

80106e6f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106e6f:	1e                   	push   %ds
  pushl %es
80106e70:	06                   	push   %es
  pushl %fs
80106e71:	0f a0                	push   %fs
  pushl %gs
80106e73:	0f a8                	push   %gs
  pushal
80106e75:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106e76:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106e7a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106e7c:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106e7e:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106e82:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106e84:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106e86:	54                   	push   %esp
  call trap
80106e87:	e8 d7 01 00 00       	call   80107063 <trap>
  addl $4, %esp
80106e8c:	83 c4 04             	add    $0x4,%esp

80106e8f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106e8f:	61                   	popa   
  popl %gs
80106e90:	0f a9                	pop    %gs
  popl %fs
80106e92:	0f a1                	pop    %fs
  popl %es
80106e94:	07                   	pop    %es
  popl %ds
80106e95:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106e96:	83 c4 08             	add    $0x8,%esp
  iret
80106e99:	cf                   	iret   

80106e9a <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106e9a:	55                   	push   %ebp
80106e9b:	89 e5                	mov    %esp,%ebp
80106e9d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ea3:	83 e8 01             	sub    $0x1,%eax
80106ea6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80106ead:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106eb1:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb4:	c1 e8 10             	shr    $0x10,%eax
80106eb7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106ebb:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ebe:	0f 01 18             	lidtl  (%eax)
}
80106ec1:	90                   	nop
80106ec2:	c9                   	leave  
80106ec3:	c3                   	ret    

80106ec4 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106ec4:	55                   	push   %ebp
80106ec5:	89 e5                	mov    %esp,%ebp
80106ec7:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106eca:	0f 20 d0             	mov    %cr2,%eax
80106ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106ed3:	c9                   	leave  
80106ed4:	c3                   	ret    

80106ed5 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106ed5:	55                   	push   %ebp
80106ed6:	89 e5                	mov    %esp,%ebp
80106ed8:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ee2:	e9 c3 00 00 00       	jmp    80106faa <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eea:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106ef1:	89 c2                	mov    %eax,%edx
80106ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ef6:	66 89 14 c5 20 5e 11 	mov    %dx,-0x7feea1e0(,%eax,8)
80106efd:	80 
80106efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f01:	66 c7 04 c5 22 5e 11 	movw   $0x8,-0x7feea1de(,%eax,8)
80106f08:	80 08 00 
80106f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f0e:	0f b6 14 c5 24 5e 11 	movzbl -0x7feea1dc(,%eax,8),%edx
80106f15:	80 
80106f16:	83 e2 e0             	and    $0xffffffe0,%edx
80106f19:	88 14 c5 24 5e 11 80 	mov    %dl,-0x7feea1dc(,%eax,8)
80106f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f23:	0f b6 14 c5 24 5e 11 	movzbl -0x7feea1dc(,%eax,8),%edx
80106f2a:	80 
80106f2b:	83 e2 1f             	and    $0x1f,%edx
80106f2e:	88 14 c5 24 5e 11 80 	mov    %dl,-0x7feea1dc(,%eax,8)
80106f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f38:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
80106f3f:	80 
80106f40:	83 e2 f0             	and    $0xfffffff0,%edx
80106f43:	83 ca 0e             	or     $0xe,%edx
80106f46:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
80106f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f50:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
80106f57:	80 
80106f58:	83 e2 ef             	and    $0xffffffef,%edx
80106f5b:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
80106f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f65:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
80106f6c:	80 
80106f6d:	83 e2 9f             	and    $0xffffff9f,%edx
80106f70:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
80106f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f7a:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
80106f81:	80 
80106f82:	83 ca 80             	or     $0xffffff80,%edx
80106f85:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
80106f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f8f:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106f96:	c1 e8 10             	shr    $0x10,%eax
80106f99:	89 c2                	mov    %eax,%edx
80106f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f9e:	66 89 14 c5 26 5e 11 	mov    %dx,-0x7feea1da(,%eax,8)
80106fa5:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106fa6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106faa:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106fb1:	0f 8e 30 ff ff ff    	jle    80106ee7 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106fb7:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80106fbc:	66 a3 20 60 11 80    	mov    %ax,0x80116020
80106fc2:	66 c7 05 22 60 11 80 	movw   $0x8,0x80116022
80106fc9:	08 00 
80106fcb:	0f b6 05 24 60 11 80 	movzbl 0x80116024,%eax
80106fd2:	83 e0 e0             	and    $0xffffffe0,%eax
80106fd5:	a2 24 60 11 80       	mov    %al,0x80116024
80106fda:	0f b6 05 24 60 11 80 	movzbl 0x80116024,%eax
80106fe1:	83 e0 1f             	and    $0x1f,%eax
80106fe4:	a2 24 60 11 80       	mov    %al,0x80116024
80106fe9:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
80106ff0:	83 c8 0f             	or     $0xf,%eax
80106ff3:	a2 25 60 11 80       	mov    %al,0x80116025
80106ff8:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
80106fff:	83 e0 ef             	and    $0xffffffef,%eax
80107002:	a2 25 60 11 80       	mov    %al,0x80116025
80107007:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
8010700e:	83 c8 60             	or     $0x60,%eax
80107011:	a2 25 60 11 80       	mov    %al,0x80116025
80107016:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
8010701d:	83 c8 80             	or     $0xffffff80,%eax
80107020:	a2 25 60 11 80       	mov    %al,0x80116025
80107025:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
8010702a:	c1 e8 10             	shr    $0x10,%eax
8010702d:	66 a3 26 60 11 80    	mov    %ax,0x80116026
  
  initlock(&tickslock, "time");
80107033:	83 ec 08             	sub    $0x8,%esp
80107036:	68 68 92 10 80       	push   $0x80109268
8010703b:	68 e0 5d 11 80       	push   $0x80115de0
80107040:	e8 c7 e4 ff ff       	call   8010550c <initlock>
80107045:	83 c4 10             	add    $0x10,%esp
}
80107048:	90                   	nop
80107049:	c9                   	leave  
8010704a:	c3                   	ret    

8010704b <idtinit>:

void
idtinit(void)
{
8010704b:	55                   	push   %ebp
8010704c:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010704e:	68 00 08 00 00       	push   $0x800
80107053:	68 20 5e 11 80       	push   $0x80115e20
80107058:	e8 3d fe ff ff       	call   80106e9a <lidt>
8010705d:	83 c4 08             	add    $0x8,%esp
}
80107060:	90                   	nop
80107061:	c9                   	leave  
80107062:	c3                   	ret    

80107063 <trap>:

void
trap(struct trapframe *tf)
{
80107063:	55                   	push   %ebp
80107064:	89 e5                	mov    %esp,%ebp
80107066:	57                   	push   %edi
80107067:	56                   	push   %esi
80107068:	53                   	push   %ebx
80107069:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010706c:	8b 45 08             	mov    0x8(%ebp),%eax
8010706f:	8b 40 30             	mov    0x30(%eax),%eax
80107072:	83 f8 40             	cmp    $0x40,%eax
80107075:	75 3e                	jne    801070b5 <trap+0x52>
    if(proc->killed)
80107077:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010707d:	8b 40 24             	mov    0x24(%eax),%eax
80107080:	85 c0                	test   %eax,%eax
80107082:	74 05                	je     80107089 <trap+0x26>
      exit();
80107084:	e8 2d da ff ff       	call   80104ab6 <exit>
    proc->tf = tf;
80107089:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010708f:	8b 55 08             	mov    0x8(%ebp),%edx
80107092:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107095:	e8 d2 ea ff ff       	call   80105b6c <syscall>
    if(proc->killed)
8010709a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070a0:	8b 40 24             	mov    0x24(%eax),%eax
801070a3:	85 c0                	test   %eax,%eax
801070a5:	0f 84 1b 02 00 00    	je     801072c6 <trap+0x263>
      exit();
801070ab:	e8 06 da ff ff       	call   80104ab6 <exit>
    return;
801070b0:	e9 11 02 00 00       	jmp    801072c6 <trap+0x263>
  }

  switch(tf->trapno){
801070b5:	8b 45 08             	mov    0x8(%ebp),%eax
801070b8:	8b 40 30             	mov    0x30(%eax),%eax
801070bb:	83 e8 20             	sub    $0x20,%eax
801070be:	83 f8 1f             	cmp    $0x1f,%eax
801070c1:	0f 87 c0 00 00 00    	ja     80107187 <trap+0x124>
801070c7:	8b 04 85 10 93 10 80 	mov    -0x7fef6cf0(,%eax,4),%eax
801070ce:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801070d0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070d6:	0f b6 00             	movzbl (%eax),%eax
801070d9:	84 c0                	test   %al,%al
801070db:	75 3d                	jne    8010711a <trap+0xb7>
      acquire(&tickslock);
801070dd:	83 ec 0c             	sub    $0xc,%esp
801070e0:	68 e0 5d 11 80       	push   $0x80115de0
801070e5:	e8 44 e4 ff ff       	call   8010552e <acquire>
801070ea:	83 c4 10             	add    $0x10,%esp
      ticks++;
801070ed:	a1 20 66 11 80       	mov    0x80116620,%eax
801070f2:	83 c0 01             	add    $0x1,%eax
801070f5:	a3 20 66 11 80       	mov    %eax,0x80116620
      release(&tickslock);    // NOTE: MarkM has reversed these two lines.
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	68 e0 5d 11 80       	push   $0x80115de0
80107102:	e8 8e e4 ff ff       	call   80105595 <release>
80107107:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);         // wakeup() should not require the tickslock to be held
8010710a:	83 ec 0c             	sub    $0xc,%esp
8010710d:	68 20 66 11 80       	push   $0x80116620
80107112:	e8 6e df ff ff       	call   80105085 <wakeup>
80107117:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010711a:	e8 62 c0 ff ff       	call   80103181 <lapiceoi>
    break;
8010711f:	e9 1c 01 00 00       	jmp    80107240 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107124:	e8 6b b8 ff ff       	call   80102994 <ideintr>
    lapiceoi();
80107129:	e8 53 c0 ff ff       	call   80103181 <lapiceoi>
    break;
8010712e:	e9 0d 01 00 00       	jmp    80107240 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107133:	e8 4b be ff ff       	call   80102f83 <kbdintr>
    lapiceoi();
80107138:	e8 44 c0 ff ff       	call   80103181 <lapiceoi>
    break;
8010713d:	e9 fe 00 00 00       	jmp    80107240 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107142:	e8 60 03 00 00       	call   801074a7 <uartintr>
    lapiceoi();
80107147:	e8 35 c0 ff ff       	call   80103181 <lapiceoi>
    break;
8010714c:	e9 ef 00 00 00       	jmp    80107240 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107151:	8b 45 08             	mov    0x8(%ebp),%eax
80107154:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107157:	8b 45 08             	mov    0x8(%ebp),%eax
8010715a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010715e:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107161:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107167:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010716a:	0f b6 c0             	movzbl %al,%eax
8010716d:	51                   	push   %ecx
8010716e:	52                   	push   %edx
8010716f:	50                   	push   %eax
80107170:	68 70 92 10 80       	push   $0x80109270
80107175:	e8 4c 92 ff ff       	call   801003c6 <cprintf>
8010717a:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010717d:	e8 ff bf ff ff       	call   80103181 <lapiceoi>
    break;
80107182:	e9 b9 00 00 00       	jmp    80107240 <trap+0x1dd>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107187:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010718d:	85 c0                	test   %eax,%eax
8010718f:	74 11                	je     801071a2 <trap+0x13f>
80107191:	8b 45 08             	mov    0x8(%ebp),%eax
80107194:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107198:	0f b7 c0             	movzwl %ax,%eax
8010719b:	83 e0 03             	and    $0x3,%eax
8010719e:	85 c0                	test   %eax,%eax
801071a0:	75 40                	jne    801071e2 <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071a2:	e8 1d fd ff ff       	call   80106ec4 <rcr2>
801071a7:	89 c3                	mov    %eax,%ebx
801071a9:	8b 45 08             	mov    0x8(%ebp),%eax
801071ac:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801071af:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071b5:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071b8:	0f b6 d0             	movzbl %al,%edx
801071bb:	8b 45 08             	mov    0x8(%ebp),%eax
801071be:	8b 40 30             	mov    0x30(%eax),%eax
801071c1:	83 ec 0c             	sub    $0xc,%esp
801071c4:	53                   	push   %ebx
801071c5:	51                   	push   %ecx
801071c6:	52                   	push   %edx
801071c7:	50                   	push   %eax
801071c8:	68 94 92 10 80       	push   $0x80109294
801071cd:	e8 f4 91 ff ff       	call   801003c6 <cprintf>
801071d2:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801071d5:	83 ec 0c             	sub    $0xc,%esp
801071d8:	68 c6 92 10 80       	push   $0x801092c6
801071dd:	e8 84 93 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071e2:	e8 dd fc ff ff       	call   80106ec4 <rcr2>
801071e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071ea:	8b 45 08             	mov    0x8(%ebp),%eax
801071ed:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071f6:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071f9:	0f b6 d8             	movzbl %al,%ebx
801071fc:	8b 45 08             	mov    0x8(%ebp),%eax
801071ff:	8b 48 34             	mov    0x34(%eax),%ecx
80107202:	8b 45 08             	mov    0x8(%ebp),%eax
80107205:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107208:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010720e:	8d 78 6c             	lea    0x6c(%eax),%edi
80107211:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107217:	8b 40 10             	mov    0x10(%eax),%eax
8010721a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010721d:	56                   	push   %esi
8010721e:	53                   	push   %ebx
8010721f:	51                   	push   %ecx
80107220:	52                   	push   %edx
80107221:	57                   	push   %edi
80107222:	50                   	push   %eax
80107223:	68 cc 92 10 80       	push   $0x801092cc
80107228:	e8 99 91 ff ff       	call   801003c6 <cprintf>
8010722d:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107230:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107236:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010723d:	eb 01                	jmp    80107240 <trap+0x1dd>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010723f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107240:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107246:	85 c0                	test   %eax,%eax
80107248:	74 24                	je     8010726e <trap+0x20b>
8010724a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107250:	8b 40 24             	mov    0x24(%eax),%eax
80107253:	85 c0                	test   %eax,%eax
80107255:	74 17                	je     8010726e <trap+0x20b>
80107257:	8b 45 08             	mov    0x8(%ebp),%eax
8010725a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010725e:	0f b7 c0             	movzwl %ax,%eax
80107261:	83 e0 03             	and    $0x3,%eax
80107264:	83 f8 03             	cmp    $0x3,%eax
80107267:	75 05                	jne    8010726e <trap+0x20b>
    exit();
80107269:	e8 48 d8 ff ff       	call   80104ab6 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010726e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107274:	85 c0                	test   %eax,%eax
80107276:	74 1e                	je     80107296 <trap+0x233>
80107278:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010727e:	8b 40 0c             	mov    0xc(%eax),%eax
80107281:	83 f8 04             	cmp    $0x4,%eax
80107284:	75 10                	jne    80107296 <trap+0x233>
80107286:	8b 45 08             	mov    0x8(%ebp),%eax
80107289:	8b 40 30             	mov    0x30(%eax),%eax
8010728c:	83 f8 20             	cmp    $0x20,%eax
8010728f:	75 05                	jne    80107296 <trap+0x233>
    yield();
80107291:	e8 80 dc ff ff       	call   80104f16 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107296:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010729c:	85 c0                	test   %eax,%eax
8010729e:	74 27                	je     801072c7 <trap+0x264>
801072a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072a6:	8b 40 24             	mov    0x24(%eax),%eax
801072a9:	85 c0                	test   %eax,%eax
801072ab:	74 1a                	je     801072c7 <trap+0x264>
801072ad:	8b 45 08             	mov    0x8(%ebp),%eax
801072b0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801072b4:	0f b7 c0             	movzwl %ax,%eax
801072b7:	83 e0 03             	and    $0x3,%eax
801072ba:	83 f8 03             	cmp    $0x3,%eax
801072bd:	75 08                	jne    801072c7 <trap+0x264>
    exit();
801072bf:	e8 f2 d7 ff ff       	call   80104ab6 <exit>
801072c4:	eb 01                	jmp    801072c7 <trap+0x264>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801072c6:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801072c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ca:	5b                   	pop    %ebx
801072cb:	5e                   	pop    %esi
801072cc:	5f                   	pop    %edi
801072cd:	5d                   	pop    %ebp
801072ce:	c3                   	ret    

801072cf <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801072cf:	55                   	push   %ebp
801072d0:	89 e5                	mov    %esp,%ebp
801072d2:	83 ec 14             	sub    $0x14,%esp
801072d5:	8b 45 08             	mov    0x8(%ebp),%eax
801072d8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801072dc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801072e0:	89 c2                	mov    %eax,%edx
801072e2:	ec                   	in     (%dx),%al
801072e3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801072e6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801072ea:	c9                   	leave  
801072eb:	c3                   	ret    

801072ec <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801072ec:	55                   	push   %ebp
801072ed:	89 e5                	mov    %esp,%ebp
801072ef:	83 ec 08             	sub    $0x8,%esp
801072f2:	8b 55 08             	mov    0x8(%ebp),%edx
801072f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072f8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801072fc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801072ff:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107303:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107307:	ee                   	out    %al,(%dx)
}
80107308:	90                   	nop
80107309:	c9                   	leave  
8010730a:	c3                   	ret    

8010730b <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010730b:	55                   	push   %ebp
8010730c:	89 e5                	mov    %esp,%ebp
8010730e:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107311:	6a 00                	push   $0x0
80107313:	68 fa 03 00 00       	push   $0x3fa
80107318:	e8 cf ff ff ff       	call   801072ec <outb>
8010731d:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107320:	68 80 00 00 00       	push   $0x80
80107325:	68 fb 03 00 00       	push   $0x3fb
8010732a:	e8 bd ff ff ff       	call   801072ec <outb>
8010732f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107332:	6a 0c                	push   $0xc
80107334:	68 f8 03 00 00       	push   $0x3f8
80107339:	e8 ae ff ff ff       	call   801072ec <outb>
8010733e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107341:	6a 00                	push   $0x0
80107343:	68 f9 03 00 00       	push   $0x3f9
80107348:	e8 9f ff ff ff       	call   801072ec <outb>
8010734d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107350:	6a 03                	push   $0x3
80107352:	68 fb 03 00 00       	push   $0x3fb
80107357:	e8 90 ff ff ff       	call   801072ec <outb>
8010735c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010735f:	6a 00                	push   $0x0
80107361:	68 fc 03 00 00       	push   $0x3fc
80107366:	e8 81 ff ff ff       	call   801072ec <outb>
8010736b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010736e:	6a 01                	push   $0x1
80107370:	68 f9 03 00 00       	push   $0x3f9
80107375:	e8 72 ff ff ff       	call   801072ec <outb>
8010737a:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010737d:	68 fd 03 00 00       	push   $0x3fd
80107382:	e8 48 ff ff ff       	call   801072cf <inb>
80107387:	83 c4 04             	add    $0x4,%esp
8010738a:	3c ff                	cmp    $0xff,%al
8010738c:	74 6e                	je     801073fc <uartinit+0xf1>
    return;
  uart = 1;
8010738e:	c7 05 8c c6 10 80 01 	movl   $0x1,0x8010c68c
80107395:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107398:	68 fa 03 00 00       	push   $0x3fa
8010739d:	e8 2d ff ff ff       	call   801072cf <inb>
801073a2:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801073a5:	68 f8 03 00 00       	push   $0x3f8
801073aa:	e8 20 ff ff ff       	call   801072cf <inb>
801073af:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801073b2:	83 ec 0c             	sub    $0xc,%esp
801073b5:	6a 04                	push   $0x4
801073b7:	e8 cb cc ff ff       	call   80104087 <picenable>
801073bc:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801073bf:	83 ec 08             	sub    $0x8,%esp
801073c2:	6a 00                	push   $0x0
801073c4:	6a 04                	push   $0x4
801073c6:	e8 6b b8 ff ff       	call   80102c36 <ioapicenable>
801073cb:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801073ce:	c7 45 f4 90 93 10 80 	movl   $0x80109390,-0xc(%ebp)
801073d5:	eb 19                	jmp    801073f0 <uartinit+0xe5>
    uartputc(*p);
801073d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073da:	0f b6 00             	movzbl (%eax),%eax
801073dd:	0f be c0             	movsbl %al,%eax
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	50                   	push   %eax
801073e4:	e8 16 00 00 00       	call   801073ff <uartputc>
801073e9:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801073ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801073f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f3:	0f b6 00             	movzbl (%eax),%eax
801073f6:	84 c0                	test   %al,%al
801073f8:	75 dd                	jne    801073d7 <uartinit+0xcc>
801073fa:	eb 01                	jmp    801073fd <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801073fc:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801073fd:	c9                   	leave  
801073fe:	c3                   	ret    

801073ff <uartputc>:

void
uartputc(int c)
{
801073ff:	55                   	push   %ebp
80107400:	89 e5                	mov    %esp,%ebp
80107402:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107405:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
8010740a:	85 c0                	test   %eax,%eax
8010740c:	74 53                	je     80107461 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010740e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107415:	eb 11                	jmp    80107428 <uartputc+0x29>
    microdelay(10);
80107417:	83 ec 0c             	sub    $0xc,%esp
8010741a:	6a 0a                	push   $0xa
8010741c:	e8 7b bd ff ff       	call   8010319c <microdelay>
80107421:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107424:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107428:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010742c:	7f 1a                	jg     80107448 <uartputc+0x49>
8010742e:	83 ec 0c             	sub    $0xc,%esp
80107431:	68 fd 03 00 00       	push   $0x3fd
80107436:	e8 94 fe ff ff       	call   801072cf <inb>
8010743b:	83 c4 10             	add    $0x10,%esp
8010743e:	0f b6 c0             	movzbl %al,%eax
80107441:	83 e0 20             	and    $0x20,%eax
80107444:	85 c0                	test   %eax,%eax
80107446:	74 cf                	je     80107417 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107448:	8b 45 08             	mov    0x8(%ebp),%eax
8010744b:	0f b6 c0             	movzbl %al,%eax
8010744e:	83 ec 08             	sub    $0x8,%esp
80107451:	50                   	push   %eax
80107452:	68 f8 03 00 00       	push   $0x3f8
80107457:	e8 90 fe ff ff       	call   801072ec <outb>
8010745c:	83 c4 10             	add    $0x10,%esp
8010745f:	eb 01                	jmp    80107462 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107461:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107462:	c9                   	leave  
80107463:	c3                   	ret    

80107464 <uartgetc>:

static int
uartgetc(void)
{
80107464:	55                   	push   %ebp
80107465:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107467:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
8010746c:	85 c0                	test   %eax,%eax
8010746e:	75 07                	jne    80107477 <uartgetc+0x13>
    return -1;
80107470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107475:	eb 2e                	jmp    801074a5 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107477:	68 fd 03 00 00       	push   $0x3fd
8010747c:	e8 4e fe ff ff       	call   801072cf <inb>
80107481:	83 c4 04             	add    $0x4,%esp
80107484:	0f b6 c0             	movzbl %al,%eax
80107487:	83 e0 01             	and    $0x1,%eax
8010748a:	85 c0                	test   %eax,%eax
8010748c:	75 07                	jne    80107495 <uartgetc+0x31>
    return -1;
8010748e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107493:	eb 10                	jmp    801074a5 <uartgetc+0x41>
  return inb(COM1+0);
80107495:	68 f8 03 00 00       	push   $0x3f8
8010749a:	e8 30 fe ff ff       	call   801072cf <inb>
8010749f:	83 c4 04             	add    $0x4,%esp
801074a2:	0f b6 c0             	movzbl %al,%eax
}
801074a5:	c9                   	leave  
801074a6:	c3                   	ret    

801074a7 <uartintr>:

void
uartintr(void)
{
801074a7:	55                   	push   %ebp
801074a8:	89 e5                	mov    %esp,%ebp
801074aa:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801074ad:	83 ec 0c             	sub    $0xc,%esp
801074b0:	68 64 74 10 80       	push   $0x80107464
801074b5:	e8 3f 93 ff ff       	call   801007f9 <consoleintr>
801074ba:	83 c4 10             	add    $0x10,%esp
}
801074bd:	90                   	nop
801074be:	c9                   	leave  
801074bf:	c3                   	ret    

801074c0 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $0
801074c2:	6a 00                	push   $0x0
  jmp alltraps
801074c4:	e9 a6 f9 ff ff       	jmp    80106e6f <alltraps>

801074c9 <vector1>:
.globl vector1
vector1:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $1
801074cb:	6a 01                	push   $0x1
  jmp alltraps
801074cd:	e9 9d f9 ff ff       	jmp    80106e6f <alltraps>

801074d2 <vector2>:
.globl vector2
vector2:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $2
801074d4:	6a 02                	push   $0x2
  jmp alltraps
801074d6:	e9 94 f9 ff ff       	jmp    80106e6f <alltraps>

801074db <vector3>:
.globl vector3
vector3:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $3
801074dd:	6a 03                	push   $0x3
  jmp alltraps
801074df:	e9 8b f9 ff ff       	jmp    80106e6f <alltraps>

801074e4 <vector4>:
.globl vector4
vector4:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $4
801074e6:	6a 04                	push   $0x4
  jmp alltraps
801074e8:	e9 82 f9 ff ff       	jmp    80106e6f <alltraps>

801074ed <vector5>:
.globl vector5
vector5:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $5
801074ef:	6a 05                	push   $0x5
  jmp alltraps
801074f1:	e9 79 f9 ff ff       	jmp    80106e6f <alltraps>

801074f6 <vector6>:
.globl vector6
vector6:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $6
801074f8:	6a 06                	push   $0x6
  jmp alltraps
801074fa:	e9 70 f9 ff ff       	jmp    80106e6f <alltraps>

801074ff <vector7>:
.globl vector7
vector7:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $7
80107501:	6a 07                	push   $0x7
  jmp alltraps
80107503:	e9 67 f9 ff ff       	jmp    80106e6f <alltraps>

80107508 <vector8>:
.globl vector8
vector8:
  pushl $8
80107508:	6a 08                	push   $0x8
  jmp alltraps
8010750a:	e9 60 f9 ff ff       	jmp    80106e6f <alltraps>

8010750f <vector9>:
.globl vector9
vector9:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $9
80107511:	6a 09                	push   $0x9
  jmp alltraps
80107513:	e9 57 f9 ff ff       	jmp    80106e6f <alltraps>

80107518 <vector10>:
.globl vector10
vector10:
  pushl $10
80107518:	6a 0a                	push   $0xa
  jmp alltraps
8010751a:	e9 50 f9 ff ff       	jmp    80106e6f <alltraps>

8010751f <vector11>:
.globl vector11
vector11:
  pushl $11
8010751f:	6a 0b                	push   $0xb
  jmp alltraps
80107521:	e9 49 f9 ff ff       	jmp    80106e6f <alltraps>

80107526 <vector12>:
.globl vector12
vector12:
  pushl $12
80107526:	6a 0c                	push   $0xc
  jmp alltraps
80107528:	e9 42 f9 ff ff       	jmp    80106e6f <alltraps>

8010752d <vector13>:
.globl vector13
vector13:
  pushl $13
8010752d:	6a 0d                	push   $0xd
  jmp alltraps
8010752f:	e9 3b f9 ff ff       	jmp    80106e6f <alltraps>

80107534 <vector14>:
.globl vector14
vector14:
  pushl $14
80107534:	6a 0e                	push   $0xe
  jmp alltraps
80107536:	e9 34 f9 ff ff       	jmp    80106e6f <alltraps>

8010753b <vector15>:
.globl vector15
vector15:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $15
8010753d:	6a 0f                	push   $0xf
  jmp alltraps
8010753f:	e9 2b f9 ff ff       	jmp    80106e6f <alltraps>

80107544 <vector16>:
.globl vector16
vector16:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $16
80107546:	6a 10                	push   $0x10
  jmp alltraps
80107548:	e9 22 f9 ff ff       	jmp    80106e6f <alltraps>

8010754d <vector17>:
.globl vector17
vector17:
  pushl $17
8010754d:	6a 11                	push   $0x11
  jmp alltraps
8010754f:	e9 1b f9 ff ff       	jmp    80106e6f <alltraps>

80107554 <vector18>:
.globl vector18
vector18:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $18
80107556:	6a 12                	push   $0x12
  jmp alltraps
80107558:	e9 12 f9 ff ff       	jmp    80106e6f <alltraps>

8010755d <vector19>:
.globl vector19
vector19:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $19
8010755f:	6a 13                	push   $0x13
  jmp alltraps
80107561:	e9 09 f9 ff ff       	jmp    80106e6f <alltraps>

80107566 <vector20>:
.globl vector20
vector20:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $20
80107568:	6a 14                	push   $0x14
  jmp alltraps
8010756a:	e9 00 f9 ff ff       	jmp    80106e6f <alltraps>

8010756f <vector21>:
.globl vector21
vector21:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $21
80107571:	6a 15                	push   $0x15
  jmp alltraps
80107573:	e9 f7 f8 ff ff       	jmp    80106e6f <alltraps>

80107578 <vector22>:
.globl vector22
vector22:
  pushl $0
80107578:	6a 00                	push   $0x0
  pushl $22
8010757a:	6a 16                	push   $0x16
  jmp alltraps
8010757c:	e9 ee f8 ff ff       	jmp    80106e6f <alltraps>

80107581 <vector23>:
.globl vector23
vector23:
  pushl $0
80107581:	6a 00                	push   $0x0
  pushl $23
80107583:	6a 17                	push   $0x17
  jmp alltraps
80107585:	e9 e5 f8 ff ff       	jmp    80106e6f <alltraps>

8010758a <vector24>:
.globl vector24
vector24:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $24
8010758c:	6a 18                	push   $0x18
  jmp alltraps
8010758e:	e9 dc f8 ff ff       	jmp    80106e6f <alltraps>

80107593 <vector25>:
.globl vector25
vector25:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $25
80107595:	6a 19                	push   $0x19
  jmp alltraps
80107597:	e9 d3 f8 ff ff       	jmp    80106e6f <alltraps>

8010759c <vector26>:
.globl vector26
vector26:
  pushl $0
8010759c:	6a 00                	push   $0x0
  pushl $26
8010759e:	6a 1a                	push   $0x1a
  jmp alltraps
801075a0:	e9 ca f8 ff ff       	jmp    80106e6f <alltraps>

801075a5 <vector27>:
.globl vector27
vector27:
  pushl $0
801075a5:	6a 00                	push   $0x0
  pushl $27
801075a7:	6a 1b                	push   $0x1b
  jmp alltraps
801075a9:	e9 c1 f8 ff ff       	jmp    80106e6f <alltraps>

801075ae <vector28>:
.globl vector28
vector28:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $28
801075b0:	6a 1c                	push   $0x1c
  jmp alltraps
801075b2:	e9 b8 f8 ff ff       	jmp    80106e6f <alltraps>

801075b7 <vector29>:
.globl vector29
vector29:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $29
801075b9:	6a 1d                	push   $0x1d
  jmp alltraps
801075bb:	e9 af f8 ff ff       	jmp    80106e6f <alltraps>

801075c0 <vector30>:
.globl vector30
vector30:
  pushl $0
801075c0:	6a 00                	push   $0x0
  pushl $30
801075c2:	6a 1e                	push   $0x1e
  jmp alltraps
801075c4:	e9 a6 f8 ff ff       	jmp    80106e6f <alltraps>

801075c9 <vector31>:
.globl vector31
vector31:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $31
801075cb:	6a 1f                	push   $0x1f
  jmp alltraps
801075cd:	e9 9d f8 ff ff       	jmp    80106e6f <alltraps>

801075d2 <vector32>:
.globl vector32
vector32:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $32
801075d4:	6a 20                	push   $0x20
  jmp alltraps
801075d6:	e9 94 f8 ff ff       	jmp    80106e6f <alltraps>

801075db <vector33>:
.globl vector33
vector33:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $33
801075dd:	6a 21                	push   $0x21
  jmp alltraps
801075df:	e9 8b f8 ff ff       	jmp    80106e6f <alltraps>

801075e4 <vector34>:
.globl vector34
vector34:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $34
801075e6:	6a 22                	push   $0x22
  jmp alltraps
801075e8:	e9 82 f8 ff ff       	jmp    80106e6f <alltraps>

801075ed <vector35>:
.globl vector35
vector35:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $35
801075ef:	6a 23                	push   $0x23
  jmp alltraps
801075f1:	e9 79 f8 ff ff       	jmp    80106e6f <alltraps>

801075f6 <vector36>:
.globl vector36
vector36:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $36
801075f8:	6a 24                	push   $0x24
  jmp alltraps
801075fa:	e9 70 f8 ff ff       	jmp    80106e6f <alltraps>

801075ff <vector37>:
.globl vector37
vector37:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $37
80107601:	6a 25                	push   $0x25
  jmp alltraps
80107603:	e9 67 f8 ff ff       	jmp    80106e6f <alltraps>

80107608 <vector38>:
.globl vector38
vector38:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $38
8010760a:	6a 26                	push   $0x26
  jmp alltraps
8010760c:	e9 5e f8 ff ff       	jmp    80106e6f <alltraps>

80107611 <vector39>:
.globl vector39
vector39:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $39
80107613:	6a 27                	push   $0x27
  jmp alltraps
80107615:	e9 55 f8 ff ff       	jmp    80106e6f <alltraps>

8010761a <vector40>:
.globl vector40
vector40:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $40
8010761c:	6a 28                	push   $0x28
  jmp alltraps
8010761e:	e9 4c f8 ff ff       	jmp    80106e6f <alltraps>

80107623 <vector41>:
.globl vector41
vector41:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $41
80107625:	6a 29                	push   $0x29
  jmp alltraps
80107627:	e9 43 f8 ff ff       	jmp    80106e6f <alltraps>

8010762c <vector42>:
.globl vector42
vector42:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $42
8010762e:	6a 2a                	push   $0x2a
  jmp alltraps
80107630:	e9 3a f8 ff ff       	jmp    80106e6f <alltraps>

80107635 <vector43>:
.globl vector43
vector43:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $43
80107637:	6a 2b                	push   $0x2b
  jmp alltraps
80107639:	e9 31 f8 ff ff       	jmp    80106e6f <alltraps>

8010763e <vector44>:
.globl vector44
vector44:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $44
80107640:	6a 2c                	push   $0x2c
  jmp alltraps
80107642:	e9 28 f8 ff ff       	jmp    80106e6f <alltraps>

80107647 <vector45>:
.globl vector45
vector45:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $45
80107649:	6a 2d                	push   $0x2d
  jmp alltraps
8010764b:	e9 1f f8 ff ff       	jmp    80106e6f <alltraps>

80107650 <vector46>:
.globl vector46
vector46:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $46
80107652:	6a 2e                	push   $0x2e
  jmp alltraps
80107654:	e9 16 f8 ff ff       	jmp    80106e6f <alltraps>

80107659 <vector47>:
.globl vector47
vector47:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $47
8010765b:	6a 2f                	push   $0x2f
  jmp alltraps
8010765d:	e9 0d f8 ff ff       	jmp    80106e6f <alltraps>

80107662 <vector48>:
.globl vector48
vector48:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $48
80107664:	6a 30                	push   $0x30
  jmp alltraps
80107666:	e9 04 f8 ff ff       	jmp    80106e6f <alltraps>

8010766b <vector49>:
.globl vector49
vector49:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $49
8010766d:	6a 31                	push   $0x31
  jmp alltraps
8010766f:	e9 fb f7 ff ff       	jmp    80106e6f <alltraps>

80107674 <vector50>:
.globl vector50
vector50:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $50
80107676:	6a 32                	push   $0x32
  jmp alltraps
80107678:	e9 f2 f7 ff ff       	jmp    80106e6f <alltraps>

8010767d <vector51>:
.globl vector51
vector51:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $51
8010767f:	6a 33                	push   $0x33
  jmp alltraps
80107681:	e9 e9 f7 ff ff       	jmp    80106e6f <alltraps>

80107686 <vector52>:
.globl vector52
vector52:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $52
80107688:	6a 34                	push   $0x34
  jmp alltraps
8010768a:	e9 e0 f7 ff ff       	jmp    80106e6f <alltraps>

8010768f <vector53>:
.globl vector53
vector53:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $53
80107691:	6a 35                	push   $0x35
  jmp alltraps
80107693:	e9 d7 f7 ff ff       	jmp    80106e6f <alltraps>

80107698 <vector54>:
.globl vector54
vector54:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $54
8010769a:	6a 36                	push   $0x36
  jmp alltraps
8010769c:	e9 ce f7 ff ff       	jmp    80106e6f <alltraps>

801076a1 <vector55>:
.globl vector55
vector55:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $55
801076a3:	6a 37                	push   $0x37
  jmp alltraps
801076a5:	e9 c5 f7 ff ff       	jmp    80106e6f <alltraps>

801076aa <vector56>:
.globl vector56
vector56:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $56
801076ac:	6a 38                	push   $0x38
  jmp alltraps
801076ae:	e9 bc f7 ff ff       	jmp    80106e6f <alltraps>

801076b3 <vector57>:
.globl vector57
vector57:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $57
801076b5:	6a 39                	push   $0x39
  jmp alltraps
801076b7:	e9 b3 f7 ff ff       	jmp    80106e6f <alltraps>

801076bc <vector58>:
.globl vector58
vector58:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $58
801076be:	6a 3a                	push   $0x3a
  jmp alltraps
801076c0:	e9 aa f7 ff ff       	jmp    80106e6f <alltraps>

801076c5 <vector59>:
.globl vector59
vector59:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $59
801076c7:	6a 3b                	push   $0x3b
  jmp alltraps
801076c9:	e9 a1 f7 ff ff       	jmp    80106e6f <alltraps>

801076ce <vector60>:
.globl vector60
vector60:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $60
801076d0:	6a 3c                	push   $0x3c
  jmp alltraps
801076d2:	e9 98 f7 ff ff       	jmp    80106e6f <alltraps>

801076d7 <vector61>:
.globl vector61
vector61:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $61
801076d9:	6a 3d                	push   $0x3d
  jmp alltraps
801076db:	e9 8f f7 ff ff       	jmp    80106e6f <alltraps>

801076e0 <vector62>:
.globl vector62
vector62:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $62
801076e2:	6a 3e                	push   $0x3e
  jmp alltraps
801076e4:	e9 86 f7 ff ff       	jmp    80106e6f <alltraps>

801076e9 <vector63>:
.globl vector63
vector63:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $63
801076eb:	6a 3f                	push   $0x3f
  jmp alltraps
801076ed:	e9 7d f7 ff ff       	jmp    80106e6f <alltraps>

801076f2 <vector64>:
.globl vector64
vector64:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $64
801076f4:	6a 40                	push   $0x40
  jmp alltraps
801076f6:	e9 74 f7 ff ff       	jmp    80106e6f <alltraps>

801076fb <vector65>:
.globl vector65
vector65:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $65
801076fd:	6a 41                	push   $0x41
  jmp alltraps
801076ff:	e9 6b f7 ff ff       	jmp    80106e6f <alltraps>

80107704 <vector66>:
.globl vector66
vector66:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $66
80107706:	6a 42                	push   $0x42
  jmp alltraps
80107708:	e9 62 f7 ff ff       	jmp    80106e6f <alltraps>

8010770d <vector67>:
.globl vector67
vector67:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $67
8010770f:	6a 43                	push   $0x43
  jmp alltraps
80107711:	e9 59 f7 ff ff       	jmp    80106e6f <alltraps>

80107716 <vector68>:
.globl vector68
vector68:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $68
80107718:	6a 44                	push   $0x44
  jmp alltraps
8010771a:	e9 50 f7 ff ff       	jmp    80106e6f <alltraps>

8010771f <vector69>:
.globl vector69
vector69:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $69
80107721:	6a 45                	push   $0x45
  jmp alltraps
80107723:	e9 47 f7 ff ff       	jmp    80106e6f <alltraps>

80107728 <vector70>:
.globl vector70
vector70:
  pushl $0
80107728:	6a 00                	push   $0x0
  pushl $70
8010772a:	6a 46                	push   $0x46
  jmp alltraps
8010772c:	e9 3e f7 ff ff       	jmp    80106e6f <alltraps>

80107731 <vector71>:
.globl vector71
vector71:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $71
80107733:	6a 47                	push   $0x47
  jmp alltraps
80107735:	e9 35 f7 ff ff       	jmp    80106e6f <alltraps>

8010773a <vector72>:
.globl vector72
vector72:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $72
8010773c:	6a 48                	push   $0x48
  jmp alltraps
8010773e:	e9 2c f7 ff ff       	jmp    80106e6f <alltraps>

80107743 <vector73>:
.globl vector73
vector73:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $73
80107745:	6a 49                	push   $0x49
  jmp alltraps
80107747:	e9 23 f7 ff ff       	jmp    80106e6f <alltraps>

8010774c <vector74>:
.globl vector74
vector74:
  pushl $0
8010774c:	6a 00                	push   $0x0
  pushl $74
8010774e:	6a 4a                	push   $0x4a
  jmp alltraps
80107750:	e9 1a f7 ff ff       	jmp    80106e6f <alltraps>

80107755 <vector75>:
.globl vector75
vector75:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $75
80107757:	6a 4b                	push   $0x4b
  jmp alltraps
80107759:	e9 11 f7 ff ff       	jmp    80106e6f <alltraps>

8010775e <vector76>:
.globl vector76
vector76:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $76
80107760:	6a 4c                	push   $0x4c
  jmp alltraps
80107762:	e9 08 f7 ff ff       	jmp    80106e6f <alltraps>

80107767 <vector77>:
.globl vector77
vector77:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $77
80107769:	6a 4d                	push   $0x4d
  jmp alltraps
8010776b:	e9 ff f6 ff ff       	jmp    80106e6f <alltraps>

80107770 <vector78>:
.globl vector78
vector78:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $78
80107772:	6a 4e                	push   $0x4e
  jmp alltraps
80107774:	e9 f6 f6 ff ff       	jmp    80106e6f <alltraps>

80107779 <vector79>:
.globl vector79
vector79:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $79
8010777b:	6a 4f                	push   $0x4f
  jmp alltraps
8010777d:	e9 ed f6 ff ff       	jmp    80106e6f <alltraps>

80107782 <vector80>:
.globl vector80
vector80:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $80
80107784:	6a 50                	push   $0x50
  jmp alltraps
80107786:	e9 e4 f6 ff ff       	jmp    80106e6f <alltraps>

8010778b <vector81>:
.globl vector81
vector81:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $81
8010778d:	6a 51                	push   $0x51
  jmp alltraps
8010778f:	e9 db f6 ff ff       	jmp    80106e6f <alltraps>

80107794 <vector82>:
.globl vector82
vector82:
  pushl $0
80107794:	6a 00                	push   $0x0
  pushl $82
80107796:	6a 52                	push   $0x52
  jmp alltraps
80107798:	e9 d2 f6 ff ff       	jmp    80106e6f <alltraps>

8010779d <vector83>:
.globl vector83
vector83:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $83
8010779f:	6a 53                	push   $0x53
  jmp alltraps
801077a1:	e9 c9 f6 ff ff       	jmp    80106e6f <alltraps>

801077a6 <vector84>:
.globl vector84
vector84:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $84
801077a8:	6a 54                	push   $0x54
  jmp alltraps
801077aa:	e9 c0 f6 ff ff       	jmp    80106e6f <alltraps>

801077af <vector85>:
.globl vector85
vector85:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $85
801077b1:	6a 55                	push   $0x55
  jmp alltraps
801077b3:	e9 b7 f6 ff ff       	jmp    80106e6f <alltraps>

801077b8 <vector86>:
.globl vector86
vector86:
  pushl $0
801077b8:	6a 00                	push   $0x0
  pushl $86
801077ba:	6a 56                	push   $0x56
  jmp alltraps
801077bc:	e9 ae f6 ff ff       	jmp    80106e6f <alltraps>

801077c1 <vector87>:
.globl vector87
vector87:
  pushl $0
801077c1:	6a 00                	push   $0x0
  pushl $87
801077c3:	6a 57                	push   $0x57
  jmp alltraps
801077c5:	e9 a5 f6 ff ff       	jmp    80106e6f <alltraps>

801077ca <vector88>:
.globl vector88
vector88:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $88
801077cc:	6a 58                	push   $0x58
  jmp alltraps
801077ce:	e9 9c f6 ff ff       	jmp    80106e6f <alltraps>

801077d3 <vector89>:
.globl vector89
vector89:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $89
801077d5:	6a 59                	push   $0x59
  jmp alltraps
801077d7:	e9 93 f6 ff ff       	jmp    80106e6f <alltraps>

801077dc <vector90>:
.globl vector90
vector90:
  pushl $0
801077dc:	6a 00                	push   $0x0
  pushl $90
801077de:	6a 5a                	push   $0x5a
  jmp alltraps
801077e0:	e9 8a f6 ff ff       	jmp    80106e6f <alltraps>

801077e5 <vector91>:
.globl vector91
vector91:
  pushl $0
801077e5:	6a 00                	push   $0x0
  pushl $91
801077e7:	6a 5b                	push   $0x5b
  jmp alltraps
801077e9:	e9 81 f6 ff ff       	jmp    80106e6f <alltraps>

801077ee <vector92>:
.globl vector92
vector92:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $92
801077f0:	6a 5c                	push   $0x5c
  jmp alltraps
801077f2:	e9 78 f6 ff ff       	jmp    80106e6f <alltraps>

801077f7 <vector93>:
.globl vector93
vector93:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $93
801077f9:	6a 5d                	push   $0x5d
  jmp alltraps
801077fb:	e9 6f f6 ff ff       	jmp    80106e6f <alltraps>

80107800 <vector94>:
.globl vector94
vector94:
  pushl $0
80107800:	6a 00                	push   $0x0
  pushl $94
80107802:	6a 5e                	push   $0x5e
  jmp alltraps
80107804:	e9 66 f6 ff ff       	jmp    80106e6f <alltraps>

80107809 <vector95>:
.globl vector95
vector95:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $95
8010780b:	6a 5f                	push   $0x5f
  jmp alltraps
8010780d:	e9 5d f6 ff ff       	jmp    80106e6f <alltraps>

80107812 <vector96>:
.globl vector96
vector96:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $96
80107814:	6a 60                	push   $0x60
  jmp alltraps
80107816:	e9 54 f6 ff ff       	jmp    80106e6f <alltraps>

8010781b <vector97>:
.globl vector97
vector97:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $97
8010781d:	6a 61                	push   $0x61
  jmp alltraps
8010781f:	e9 4b f6 ff ff       	jmp    80106e6f <alltraps>

80107824 <vector98>:
.globl vector98
vector98:
  pushl $0
80107824:	6a 00                	push   $0x0
  pushl $98
80107826:	6a 62                	push   $0x62
  jmp alltraps
80107828:	e9 42 f6 ff ff       	jmp    80106e6f <alltraps>

8010782d <vector99>:
.globl vector99
vector99:
  pushl $0
8010782d:	6a 00                	push   $0x0
  pushl $99
8010782f:	6a 63                	push   $0x63
  jmp alltraps
80107831:	e9 39 f6 ff ff       	jmp    80106e6f <alltraps>

80107836 <vector100>:
.globl vector100
vector100:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $100
80107838:	6a 64                	push   $0x64
  jmp alltraps
8010783a:	e9 30 f6 ff ff       	jmp    80106e6f <alltraps>

8010783f <vector101>:
.globl vector101
vector101:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $101
80107841:	6a 65                	push   $0x65
  jmp alltraps
80107843:	e9 27 f6 ff ff       	jmp    80106e6f <alltraps>

80107848 <vector102>:
.globl vector102
vector102:
  pushl $0
80107848:	6a 00                	push   $0x0
  pushl $102
8010784a:	6a 66                	push   $0x66
  jmp alltraps
8010784c:	e9 1e f6 ff ff       	jmp    80106e6f <alltraps>

80107851 <vector103>:
.globl vector103
vector103:
  pushl $0
80107851:	6a 00                	push   $0x0
  pushl $103
80107853:	6a 67                	push   $0x67
  jmp alltraps
80107855:	e9 15 f6 ff ff       	jmp    80106e6f <alltraps>

8010785a <vector104>:
.globl vector104
vector104:
  pushl $0
8010785a:	6a 00                	push   $0x0
  pushl $104
8010785c:	6a 68                	push   $0x68
  jmp alltraps
8010785e:	e9 0c f6 ff ff       	jmp    80106e6f <alltraps>

80107863 <vector105>:
.globl vector105
vector105:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $105
80107865:	6a 69                	push   $0x69
  jmp alltraps
80107867:	e9 03 f6 ff ff       	jmp    80106e6f <alltraps>

8010786c <vector106>:
.globl vector106
vector106:
  pushl $0
8010786c:	6a 00                	push   $0x0
  pushl $106
8010786e:	6a 6a                	push   $0x6a
  jmp alltraps
80107870:	e9 fa f5 ff ff       	jmp    80106e6f <alltraps>

80107875 <vector107>:
.globl vector107
vector107:
  pushl $0
80107875:	6a 00                	push   $0x0
  pushl $107
80107877:	6a 6b                	push   $0x6b
  jmp alltraps
80107879:	e9 f1 f5 ff ff       	jmp    80106e6f <alltraps>

8010787e <vector108>:
.globl vector108
vector108:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $108
80107880:	6a 6c                	push   $0x6c
  jmp alltraps
80107882:	e9 e8 f5 ff ff       	jmp    80106e6f <alltraps>

80107887 <vector109>:
.globl vector109
vector109:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $109
80107889:	6a 6d                	push   $0x6d
  jmp alltraps
8010788b:	e9 df f5 ff ff       	jmp    80106e6f <alltraps>

80107890 <vector110>:
.globl vector110
vector110:
  pushl $0
80107890:	6a 00                	push   $0x0
  pushl $110
80107892:	6a 6e                	push   $0x6e
  jmp alltraps
80107894:	e9 d6 f5 ff ff       	jmp    80106e6f <alltraps>

80107899 <vector111>:
.globl vector111
vector111:
  pushl $0
80107899:	6a 00                	push   $0x0
  pushl $111
8010789b:	6a 6f                	push   $0x6f
  jmp alltraps
8010789d:	e9 cd f5 ff ff       	jmp    80106e6f <alltraps>

801078a2 <vector112>:
.globl vector112
vector112:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $112
801078a4:	6a 70                	push   $0x70
  jmp alltraps
801078a6:	e9 c4 f5 ff ff       	jmp    80106e6f <alltraps>

801078ab <vector113>:
.globl vector113
vector113:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $113
801078ad:	6a 71                	push   $0x71
  jmp alltraps
801078af:	e9 bb f5 ff ff       	jmp    80106e6f <alltraps>

801078b4 <vector114>:
.globl vector114
vector114:
  pushl $0
801078b4:	6a 00                	push   $0x0
  pushl $114
801078b6:	6a 72                	push   $0x72
  jmp alltraps
801078b8:	e9 b2 f5 ff ff       	jmp    80106e6f <alltraps>

801078bd <vector115>:
.globl vector115
vector115:
  pushl $0
801078bd:	6a 00                	push   $0x0
  pushl $115
801078bf:	6a 73                	push   $0x73
  jmp alltraps
801078c1:	e9 a9 f5 ff ff       	jmp    80106e6f <alltraps>

801078c6 <vector116>:
.globl vector116
vector116:
  pushl $0
801078c6:	6a 00                	push   $0x0
  pushl $116
801078c8:	6a 74                	push   $0x74
  jmp alltraps
801078ca:	e9 a0 f5 ff ff       	jmp    80106e6f <alltraps>

801078cf <vector117>:
.globl vector117
vector117:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $117
801078d1:	6a 75                	push   $0x75
  jmp alltraps
801078d3:	e9 97 f5 ff ff       	jmp    80106e6f <alltraps>

801078d8 <vector118>:
.globl vector118
vector118:
  pushl $0
801078d8:	6a 00                	push   $0x0
  pushl $118
801078da:	6a 76                	push   $0x76
  jmp alltraps
801078dc:	e9 8e f5 ff ff       	jmp    80106e6f <alltraps>

801078e1 <vector119>:
.globl vector119
vector119:
  pushl $0
801078e1:	6a 00                	push   $0x0
  pushl $119
801078e3:	6a 77                	push   $0x77
  jmp alltraps
801078e5:	e9 85 f5 ff ff       	jmp    80106e6f <alltraps>

801078ea <vector120>:
.globl vector120
vector120:
  pushl $0
801078ea:	6a 00                	push   $0x0
  pushl $120
801078ec:	6a 78                	push   $0x78
  jmp alltraps
801078ee:	e9 7c f5 ff ff       	jmp    80106e6f <alltraps>

801078f3 <vector121>:
.globl vector121
vector121:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $121
801078f5:	6a 79                	push   $0x79
  jmp alltraps
801078f7:	e9 73 f5 ff ff       	jmp    80106e6f <alltraps>

801078fc <vector122>:
.globl vector122
vector122:
  pushl $0
801078fc:	6a 00                	push   $0x0
  pushl $122
801078fe:	6a 7a                	push   $0x7a
  jmp alltraps
80107900:	e9 6a f5 ff ff       	jmp    80106e6f <alltraps>

80107905 <vector123>:
.globl vector123
vector123:
  pushl $0
80107905:	6a 00                	push   $0x0
  pushl $123
80107907:	6a 7b                	push   $0x7b
  jmp alltraps
80107909:	e9 61 f5 ff ff       	jmp    80106e6f <alltraps>

8010790e <vector124>:
.globl vector124
vector124:
  pushl $0
8010790e:	6a 00                	push   $0x0
  pushl $124
80107910:	6a 7c                	push   $0x7c
  jmp alltraps
80107912:	e9 58 f5 ff ff       	jmp    80106e6f <alltraps>

80107917 <vector125>:
.globl vector125
vector125:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $125
80107919:	6a 7d                	push   $0x7d
  jmp alltraps
8010791b:	e9 4f f5 ff ff       	jmp    80106e6f <alltraps>

80107920 <vector126>:
.globl vector126
vector126:
  pushl $0
80107920:	6a 00                	push   $0x0
  pushl $126
80107922:	6a 7e                	push   $0x7e
  jmp alltraps
80107924:	e9 46 f5 ff ff       	jmp    80106e6f <alltraps>

80107929 <vector127>:
.globl vector127
vector127:
  pushl $0
80107929:	6a 00                	push   $0x0
  pushl $127
8010792b:	6a 7f                	push   $0x7f
  jmp alltraps
8010792d:	e9 3d f5 ff ff       	jmp    80106e6f <alltraps>

80107932 <vector128>:
.globl vector128
vector128:
  pushl $0
80107932:	6a 00                	push   $0x0
  pushl $128
80107934:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107939:	e9 31 f5 ff ff       	jmp    80106e6f <alltraps>

8010793e <vector129>:
.globl vector129
vector129:
  pushl $0
8010793e:	6a 00                	push   $0x0
  pushl $129
80107940:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107945:	e9 25 f5 ff ff       	jmp    80106e6f <alltraps>

8010794a <vector130>:
.globl vector130
vector130:
  pushl $0
8010794a:	6a 00                	push   $0x0
  pushl $130
8010794c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107951:	e9 19 f5 ff ff       	jmp    80106e6f <alltraps>

80107956 <vector131>:
.globl vector131
vector131:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $131
80107958:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010795d:	e9 0d f5 ff ff       	jmp    80106e6f <alltraps>

80107962 <vector132>:
.globl vector132
vector132:
  pushl $0
80107962:	6a 00                	push   $0x0
  pushl $132
80107964:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107969:	e9 01 f5 ff ff       	jmp    80106e6f <alltraps>

8010796e <vector133>:
.globl vector133
vector133:
  pushl $0
8010796e:	6a 00                	push   $0x0
  pushl $133
80107970:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107975:	e9 f5 f4 ff ff       	jmp    80106e6f <alltraps>

8010797a <vector134>:
.globl vector134
vector134:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $134
8010797c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107981:	e9 e9 f4 ff ff       	jmp    80106e6f <alltraps>

80107986 <vector135>:
.globl vector135
vector135:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $135
80107988:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010798d:	e9 dd f4 ff ff       	jmp    80106e6f <alltraps>

80107992 <vector136>:
.globl vector136
vector136:
  pushl $0
80107992:	6a 00                	push   $0x0
  pushl $136
80107994:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107999:	e9 d1 f4 ff ff       	jmp    80106e6f <alltraps>

8010799e <vector137>:
.globl vector137
vector137:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $137
801079a0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801079a5:	e9 c5 f4 ff ff       	jmp    80106e6f <alltraps>

801079aa <vector138>:
.globl vector138
vector138:
  pushl $0
801079aa:	6a 00                	push   $0x0
  pushl $138
801079ac:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801079b1:	e9 b9 f4 ff ff       	jmp    80106e6f <alltraps>

801079b6 <vector139>:
.globl vector139
vector139:
  pushl $0
801079b6:	6a 00                	push   $0x0
  pushl $139
801079b8:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801079bd:	e9 ad f4 ff ff       	jmp    80106e6f <alltraps>

801079c2 <vector140>:
.globl vector140
vector140:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $140
801079c4:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801079c9:	e9 a1 f4 ff ff       	jmp    80106e6f <alltraps>

801079ce <vector141>:
.globl vector141
vector141:
  pushl $0
801079ce:	6a 00                	push   $0x0
  pushl $141
801079d0:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801079d5:	e9 95 f4 ff ff       	jmp    80106e6f <alltraps>

801079da <vector142>:
.globl vector142
vector142:
  pushl $0
801079da:	6a 00                	push   $0x0
  pushl $142
801079dc:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801079e1:	e9 89 f4 ff ff       	jmp    80106e6f <alltraps>

801079e6 <vector143>:
.globl vector143
vector143:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $143
801079e8:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801079ed:	e9 7d f4 ff ff       	jmp    80106e6f <alltraps>

801079f2 <vector144>:
.globl vector144
vector144:
  pushl $0
801079f2:	6a 00                	push   $0x0
  pushl $144
801079f4:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801079f9:	e9 71 f4 ff ff       	jmp    80106e6f <alltraps>

801079fe <vector145>:
.globl vector145
vector145:
  pushl $0
801079fe:	6a 00                	push   $0x0
  pushl $145
80107a00:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107a05:	e9 65 f4 ff ff       	jmp    80106e6f <alltraps>

80107a0a <vector146>:
.globl vector146
vector146:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $146
80107a0c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107a11:	e9 59 f4 ff ff       	jmp    80106e6f <alltraps>

80107a16 <vector147>:
.globl vector147
vector147:
  pushl $0
80107a16:	6a 00                	push   $0x0
  pushl $147
80107a18:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107a1d:	e9 4d f4 ff ff       	jmp    80106e6f <alltraps>

80107a22 <vector148>:
.globl vector148
vector148:
  pushl $0
80107a22:	6a 00                	push   $0x0
  pushl $148
80107a24:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107a29:	e9 41 f4 ff ff       	jmp    80106e6f <alltraps>

80107a2e <vector149>:
.globl vector149
vector149:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $149
80107a30:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107a35:	e9 35 f4 ff ff       	jmp    80106e6f <alltraps>

80107a3a <vector150>:
.globl vector150
vector150:
  pushl $0
80107a3a:	6a 00                	push   $0x0
  pushl $150
80107a3c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107a41:	e9 29 f4 ff ff       	jmp    80106e6f <alltraps>

80107a46 <vector151>:
.globl vector151
vector151:
  pushl $0
80107a46:	6a 00                	push   $0x0
  pushl $151
80107a48:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107a4d:	e9 1d f4 ff ff       	jmp    80106e6f <alltraps>

80107a52 <vector152>:
.globl vector152
vector152:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $152
80107a54:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107a59:	e9 11 f4 ff ff       	jmp    80106e6f <alltraps>

80107a5e <vector153>:
.globl vector153
vector153:
  pushl $0
80107a5e:	6a 00                	push   $0x0
  pushl $153
80107a60:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107a65:	e9 05 f4 ff ff       	jmp    80106e6f <alltraps>

80107a6a <vector154>:
.globl vector154
vector154:
  pushl $0
80107a6a:	6a 00                	push   $0x0
  pushl $154
80107a6c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107a71:	e9 f9 f3 ff ff       	jmp    80106e6f <alltraps>

80107a76 <vector155>:
.globl vector155
vector155:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $155
80107a78:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107a7d:	e9 ed f3 ff ff       	jmp    80106e6f <alltraps>

80107a82 <vector156>:
.globl vector156
vector156:
  pushl $0
80107a82:	6a 00                	push   $0x0
  pushl $156
80107a84:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107a89:	e9 e1 f3 ff ff       	jmp    80106e6f <alltraps>

80107a8e <vector157>:
.globl vector157
vector157:
  pushl $0
80107a8e:	6a 00                	push   $0x0
  pushl $157
80107a90:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107a95:	e9 d5 f3 ff ff       	jmp    80106e6f <alltraps>

80107a9a <vector158>:
.globl vector158
vector158:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $158
80107a9c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107aa1:	e9 c9 f3 ff ff       	jmp    80106e6f <alltraps>

80107aa6 <vector159>:
.globl vector159
vector159:
  pushl $0
80107aa6:	6a 00                	push   $0x0
  pushl $159
80107aa8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107aad:	e9 bd f3 ff ff       	jmp    80106e6f <alltraps>

80107ab2 <vector160>:
.globl vector160
vector160:
  pushl $0
80107ab2:	6a 00                	push   $0x0
  pushl $160
80107ab4:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107ab9:	e9 b1 f3 ff ff       	jmp    80106e6f <alltraps>

80107abe <vector161>:
.globl vector161
vector161:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $161
80107ac0:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107ac5:	e9 a5 f3 ff ff       	jmp    80106e6f <alltraps>

80107aca <vector162>:
.globl vector162
vector162:
  pushl $0
80107aca:	6a 00                	push   $0x0
  pushl $162
80107acc:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107ad1:	e9 99 f3 ff ff       	jmp    80106e6f <alltraps>

80107ad6 <vector163>:
.globl vector163
vector163:
  pushl $0
80107ad6:	6a 00                	push   $0x0
  pushl $163
80107ad8:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107add:	e9 8d f3 ff ff       	jmp    80106e6f <alltraps>

80107ae2 <vector164>:
.globl vector164
vector164:
  pushl $0
80107ae2:	6a 00                	push   $0x0
  pushl $164
80107ae4:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107ae9:	e9 81 f3 ff ff       	jmp    80106e6f <alltraps>

80107aee <vector165>:
.globl vector165
vector165:
  pushl $0
80107aee:	6a 00                	push   $0x0
  pushl $165
80107af0:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107af5:	e9 75 f3 ff ff       	jmp    80106e6f <alltraps>

80107afa <vector166>:
.globl vector166
vector166:
  pushl $0
80107afa:	6a 00                	push   $0x0
  pushl $166
80107afc:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107b01:	e9 69 f3 ff ff       	jmp    80106e6f <alltraps>

80107b06 <vector167>:
.globl vector167
vector167:
  pushl $0
80107b06:	6a 00                	push   $0x0
  pushl $167
80107b08:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107b0d:	e9 5d f3 ff ff       	jmp    80106e6f <alltraps>

80107b12 <vector168>:
.globl vector168
vector168:
  pushl $0
80107b12:	6a 00                	push   $0x0
  pushl $168
80107b14:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107b19:	e9 51 f3 ff ff       	jmp    80106e6f <alltraps>

80107b1e <vector169>:
.globl vector169
vector169:
  pushl $0
80107b1e:	6a 00                	push   $0x0
  pushl $169
80107b20:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107b25:	e9 45 f3 ff ff       	jmp    80106e6f <alltraps>

80107b2a <vector170>:
.globl vector170
vector170:
  pushl $0
80107b2a:	6a 00                	push   $0x0
  pushl $170
80107b2c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107b31:	e9 39 f3 ff ff       	jmp    80106e6f <alltraps>

80107b36 <vector171>:
.globl vector171
vector171:
  pushl $0
80107b36:	6a 00                	push   $0x0
  pushl $171
80107b38:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107b3d:	e9 2d f3 ff ff       	jmp    80106e6f <alltraps>

80107b42 <vector172>:
.globl vector172
vector172:
  pushl $0
80107b42:	6a 00                	push   $0x0
  pushl $172
80107b44:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107b49:	e9 21 f3 ff ff       	jmp    80106e6f <alltraps>

80107b4e <vector173>:
.globl vector173
vector173:
  pushl $0
80107b4e:	6a 00                	push   $0x0
  pushl $173
80107b50:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107b55:	e9 15 f3 ff ff       	jmp    80106e6f <alltraps>

80107b5a <vector174>:
.globl vector174
vector174:
  pushl $0
80107b5a:	6a 00                	push   $0x0
  pushl $174
80107b5c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107b61:	e9 09 f3 ff ff       	jmp    80106e6f <alltraps>

80107b66 <vector175>:
.globl vector175
vector175:
  pushl $0
80107b66:	6a 00                	push   $0x0
  pushl $175
80107b68:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107b6d:	e9 fd f2 ff ff       	jmp    80106e6f <alltraps>

80107b72 <vector176>:
.globl vector176
vector176:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $176
80107b74:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107b79:	e9 f1 f2 ff ff       	jmp    80106e6f <alltraps>

80107b7e <vector177>:
.globl vector177
vector177:
  pushl $0
80107b7e:	6a 00                	push   $0x0
  pushl $177
80107b80:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107b85:	e9 e5 f2 ff ff       	jmp    80106e6f <alltraps>

80107b8a <vector178>:
.globl vector178
vector178:
  pushl $0
80107b8a:	6a 00                	push   $0x0
  pushl $178
80107b8c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107b91:	e9 d9 f2 ff ff       	jmp    80106e6f <alltraps>

80107b96 <vector179>:
.globl vector179
vector179:
  pushl $0
80107b96:	6a 00                	push   $0x0
  pushl $179
80107b98:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107b9d:	e9 cd f2 ff ff       	jmp    80106e6f <alltraps>

80107ba2 <vector180>:
.globl vector180
vector180:
  pushl $0
80107ba2:	6a 00                	push   $0x0
  pushl $180
80107ba4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107ba9:	e9 c1 f2 ff ff       	jmp    80106e6f <alltraps>

80107bae <vector181>:
.globl vector181
vector181:
  pushl $0
80107bae:	6a 00                	push   $0x0
  pushl $181
80107bb0:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107bb5:	e9 b5 f2 ff ff       	jmp    80106e6f <alltraps>

80107bba <vector182>:
.globl vector182
vector182:
  pushl $0
80107bba:	6a 00                	push   $0x0
  pushl $182
80107bbc:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107bc1:	e9 a9 f2 ff ff       	jmp    80106e6f <alltraps>

80107bc6 <vector183>:
.globl vector183
vector183:
  pushl $0
80107bc6:	6a 00                	push   $0x0
  pushl $183
80107bc8:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107bcd:	e9 9d f2 ff ff       	jmp    80106e6f <alltraps>

80107bd2 <vector184>:
.globl vector184
vector184:
  pushl $0
80107bd2:	6a 00                	push   $0x0
  pushl $184
80107bd4:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107bd9:	e9 91 f2 ff ff       	jmp    80106e6f <alltraps>

80107bde <vector185>:
.globl vector185
vector185:
  pushl $0
80107bde:	6a 00                	push   $0x0
  pushl $185
80107be0:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107be5:	e9 85 f2 ff ff       	jmp    80106e6f <alltraps>

80107bea <vector186>:
.globl vector186
vector186:
  pushl $0
80107bea:	6a 00                	push   $0x0
  pushl $186
80107bec:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107bf1:	e9 79 f2 ff ff       	jmp    80106e6f <alltraps>

80107bf6 <vector187>:
.globl vector187
vector187:
  pushl $0
80107bf6:	6a 00                	push   $0x0
  pushl $187
80107bf8:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107bfd:	e9 6d f2 ff ff       	jmp    80106e6f <alltraps>

80107c02 <vector188>:
.globl vector188
vector188:
  pushl $0
80107c02:	6a 00                	push   $0x0
  pushl $188
80107c04:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107c09:	e9 61 f2 ff ff       	jmp    80106e6f <alltraps>

80107c0e <vector189>:
.globl vector189
vector189:
  pushl $0
80107c0e:	6a 00                	push   $0x0
  pushl $189
80107c10:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107c15:	e9 55 f2 ff ff       	jmp    80106e6f <alltraps>

80107c1a <vector190>:
.globl vector190
vector190:
  pushl $0
80107c1a:	6a 00                	push   $0x0
  pushl $190
80107c1c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107c21:	e9 49 f2 ff ff       	jmp    80106e6f <alltraps>

80107c26 <vector191>:
.globl vector191
vector191:
  pushl $0
80107c26:	6a 00                	push   $0x0
  pushl $191
80107c28:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107c2d:	e9 3d f2 ff ff       	jmp    80106e6f <alltraps>

80107c32 <vector192>:
.globl vector192
vector192:
  pushl $0
80107c32:	6a 00                	push   $0x0
  pushl $192
80107c34:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107c39:	e9 31 f2 ff ff       	jmp    80106e6f <alltraps>

80107c3e <vector193>:
.globl vector193
vector193:
  pushl $0
80107c3e:	6a 00                	push   $0x0
  pushl $193
80107c40:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107c45:	e9 25 f2 ff ff       	jmp    80106e6f <alltraps>

80107c4a <vector194>:
.globl vector194
vector194:
  pushl $0
80107c4a:	6a 00                	push   $0x0
  pushl $194
80107c4c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107c51:	e9 19 f2 ff ff       	jmp    80106e6f <alltraps>

80107c56 <vector195>:
.globl vector195
vector195:
  pushl $0
80107c56:	6a 00                	push   $0x0
  pushl $195
80107c58:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107c5d:	e9 0d f2 ff ff       	jmp    80106e6f <alltraps>

80107c62 <vector196>:
.globl vector196
vector196:
  pushl $0
80107c62:	6a 00                	push   $0x0
  pushl $196
80107c64:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107c69:	e9 01 f2 ff ff       	jmp    80106e6f <alltraps>

80107c6e <vector197>:
.globl vector197
vector197:
  pushl $0
80107c6e:	6a 00                	push   $0x0
  pushl $197
80107c70:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107c75:	e9 f5 f1 ff ff       	jmp    80106e6f <alltraps>

80107c7a <vector198>:
.globl vector198
vector198:
  pushl $0
80107c7a:	6a 00                	push   $0x0
  pushl $198
80107c7c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107c81:	e9 e9 f1 ff ff       	jmp    80106e6f <alltraps>

80107c86 <vector199>:
.globl vector199
vector199:
  pushl $0
80107c86:	6a 00                	push   $0x0
  pushl $199
80107c88:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107c8d:	e9 dd f1 ff ff       	jmp    80106e6f <alltraps>

80107c92 <vector200>:
.globl vector200
vector200:
  pushl $0
80107c92:	6a 00                	push   $0x0
  pushl $200
80107c94:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107c99:	e9 d1 f1 ff ff       	jmp    80106e6f <alltraps>

80107c9e <vector201>:
.globl vector201
vector201:
  pushl $0
80107c9e:	6a 00                	push   $0x0
  pushl $201
80107ca0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107ca5:	e9 c5 f1 ff ff       	jmp    80106e6f <alltraps>

80107caa <vector202>:
.globl vector202
vector202:
  pushl $0
80107caa:	6a 00                	push   $0x0
  pushl $202
80107cac:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107cb1:	e9 b9 f1 ff ff       	jmp    80106e6f <alltraps>

80107cb6 <vector203>:
.globl vector203
vector203:
  pushl $0
80107cb6:	6a 00                	push   $0x0
  pushl $203
80107cb8:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107cbd:	e9 ad f1 ff ff       	jmp    80106e6f <alltraps>

80107cc2 <vector204>:
.globl vector204
vector204:
  pushl $0
80107cc2:	6a 00                	push   $0x0
  pushl $204
80107cc4:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107cc9:	e9 a1 f1 ff ff       	jmp    80106e6f <alltraps>

80107cce <vector205>:
.globl vector205
vector205:
  pushl $0
80107cce:	6a 00                	push   $0x0
  pushl $205
80107cd0:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107cd5:	e9 95 f1 ff ff       	jmp    80106e6f <alltraps>

80107cda <vector206>:
.globl vector206
vector206:
  pushl $0
80107cda:	6a 00                	push   $0x0
  pushl $206
80107cdc:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107ce1:	e9 89 f1 ff ff       	jmp    80106e6f <alltraps>

80107ce6 <vector207>:
.globl vector207
vector207:
  pushl $0
80107ce6:	6a 00                	push   $0x0
  pushl $207
80107ce8:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107ced:	e9 7d f1 ff ff       	jmp    80106e6f <alltraps>

80107cf2 <vector208>:
.globl vector208
vector208:
  pushl $0
80107cf2:	6a 00                	push   $0x0
  pushl $208
80107cf4:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107cf9:	e9 71 f1 ff ff       	jmp    80106e6f <alltraps>

80107cfe <vector209>:
.globl vector209
vector209:
  pushl $0
80107cfe:	6a 00                	push   $0x0
  pushl $209
80107d00:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107d05:	e9 65 f1 ff ff       	jmp    80106e6f <alltraps>

80107d0a <vector210>:
.globl vector210
vector210:
  pushl $0
80107d0a:	6a 00                	push   $0x0
  pushl $210
80107d0c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107d11:	e9 59 f1 ff ff       	jmp    80106e6f <alltraps>

80107d16 <vector211>:
.globl vector211
vector211:
  pushl $0
80107d16:	6a 00                	push   $0x0
  pushl $211
80107d18:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107d1d:	e9 4d f1 ff ff       	jmp    80106e6f <alltraps>

80107d22 <vector212>:
.globl vector212
vector212:
  pushl $0
80107d22:	6a 00                	push   $0x0
  pushl $212
80107d24:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107d29:	e9 41 f1 ff ff       	jmp    80106e6f <alltraps>

80107d2e <vector213>:
.globl vector213
vector213:
  pushl $0
80107d2e:	6a 00                	push   $0x0
  pushl $213
80107d30:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107d35:	e9 35 f1 ff ff       	jmp    80106e6f <alltraps>

80107d3a <vector214>:
.globl vector214
vector214:
  pushl $0
80107d3a:	6a 00                	push   $0x0
  pushl $214
80107d3c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107d41:	e9 29 f1 ff ff       	jmp    80106e6f <alltraps>

80107d46 <vector215>:
.globl vector215
vector215:
  pushl $0
80107d46:	6a 00                	push   $0x0
  pushl $215
80107d48:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107d4d:	e9 1d f1 ff ff       	jmp    80106e6f <alltraps>

80107d52 <vector216>:
.globl vector216
vector216:
  pushl $0
80107d52:	6a 00                	push   $0x0
  pushl $216
80107d54:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107d59:	e9 11 f1 ff ff       	jmp    80106e6f <alltraps>

80107d5e <vector217>:
.globl vector217
vector217:
  pushl $0
80107d5e:	6a 00                	push   $0x0
  pushl $217
80107d60:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107d65:	e9 05 f1 ff ff       	jmp    80106e6f <alltraps>

80107d6a <vector218>:
.globl vector218
vector218:
  pushl $0
80107d6a:	6a 00                	push   $0x0
  pushl $218
80107d6c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107d71:	e9 f9 f0 ff ff       	jmp    80106e6f <alltraps>

80107d76 <vector219>:
.globl vector219
vector219:
  pushl $0
80107d76:	6a 00                	push   $0x0
  pushl $219
80107d78:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107d7d:	e9 ed f0 ff ff       	jmp    80106e6f <alltraps>

80107d82 <vector220>:
.globl vector220
vector220:
  pushl $0
80107d82:	6a 00                	push   $0x0
  pushl $220
80107d84:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107d89:	e9 e1 f0 ff ff       	jmp    80106e6f <alltraps>

80107d8e <vector221>:
.globl vector221
vector221:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $221
80107d90:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107d95:	e9 d5 f0 ff ff       	jmp    80106e6f <alltraps>

80107d9a <vector222>:
.globl vector222
vector222:
  pushl $0
80107d9a:	6a 00                	push   $0x0
  pushl $222
80107d9c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107da1:	e9 c9 f0 ff ff       	jmp    80106e6f <alltraps>

80107da6 <vector223>:
.globl vector223
vector223:
  pushl $0
80107da6:	6a 00                	push   $0x0
  pushl $223
80107da8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107dad:	e9 bd f0 ff ff       	jmp    80106e6f <alltraps>

80107db2 <vector224>:
.globl vector224
vector224:
  pushl $0
80107db2:	6a 00                	push   $0x0
  pushl $224
80107db4:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107db9:	e9 b1 f0 ff ff       	jmp    80106e6f <alltraps>

80107dbe <vector225>:
.globl vector225
vector225:
  pushl $0
80107dbe:	6a 00                	push   $0x0
  pushl $225
80107dc0:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107dc5:	e9 a5 f0 ff ff       	jmp    80106e6f <alltraps>

80107dca <vector226>:
.globl vector226
vector226:
  pushl $0
80107dca:	6a 00                	push   $0x0
  pushl $226
80107dcc:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107dd1:	e9 99 f0 ff ff       	jmp    80106e6f <alltraps>

80107dd6 <vector227>:
.globl vector227
vector227:
  pushl $0
80107dd6:	6a 00                	push   $0x0
  pushl $227
80107dd8:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107ddd:	e9 8d f0 ff ff       	jmp    80106e6f <alltraps>

80107de2 <vector228>:
.globl vector228
vector228:
  pushl $0
80107de2:	6a 00                	push   $0x0
  pushl $228
80107de4:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107de9:	e9 81 f0 ff ff       	jmp    80106e6f <alltraps>

80107dee <vector229>:
.globl vector229
vector229:
  pushl $0
80107dee:	6a 00                	push   $0x0
  pushl $229
80107df0:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107df5:	e9 75 f0 ff ff       	jmp    80106e6f <alltraps>

80107dfa <vector230>:
.globl vector230
vector230:
  pushl $0
80107dfa:	6a 00                	push   $0x0
  pushl $230
80107dfc:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107e01:	e9 69 f0 ff ff       	jmp    80106e6f <alltraps>

80107e06 <vector231>:
.globl vector231
vector231:
  pushl $0
80107e06:	6a 00                	push   $0x0
  pushl $231
80107e08:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107e0d:	e9 5d f0 ff ff       	jmp    80106e6f <alltraps>

80107e12 <vector232>:
.globl vector232
vector232:
  pushl $0
80107e12:	6a 00                	push   $0x0
  pushl $232
80107e14:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107e19:	e9 51 f0 ff ff       	jmp    80106e6f <alltraps>

80107e1e <vector233>:
.globl vector233
vector233:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $233
80107e20:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107e25:	e9 45 f0 ff ff       	jmp    80106e6f <alltraps>

80107e2a <vector234>:
.globl vector234
vector234:
  pushl $0
80107e2a:	6a 00                	push   $0x0
  pushl $234
80107e2c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107e31:	e9 39 f0 ff ff       	jmp    80106e6f <alltraps>

80107e36 <vector235>:
.globl vector235
vector235:
  pushl $0
80107e36:	6a 00                	push   $0x0
  pushl $235
80107e38:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107e3d:	e9 2d f0 ff ff       	jmp    80106e6f <alltraps>

80107e42 <vector236>:
.globl vector236
vector236:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $236
80107e44:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107e49:	e9 21 f0 ff ff       	jmp    80106e6f <alltraps>

80107e4e <vector237>:
.globl vector237
vector237:
  pushl $0
80107e4e:	6a 00                	push   $0x0
  pushl $237
80107e50:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107e55:	e9 15 f0 ff ff       	jmp    80106e6f <alltraps>

80107e5a <vector238>:
.globl vector238
vector238:
  pushl $0
80107e5a:	6a 00                	push   $0x0
  pushl $238
80107e5c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107e61:	e9 09 f0 ff ff       	jmp    80106e6f <alltraps>

80107e66 <vector239>:
.globl vector239
vector239:
  pushl $0
80107e66:	6a 00                	push   $0x0
  pushl $239
80107e68:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107e6d:	e9 fd ef ff ff       	jmp    80106e6f <alltraps>

80107e72 <vector240>:
.globl vector240
vector240:
  pushl $0
80107e72:	6a 00                	push   $0x0
  pushl $240
80107e74:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107e79:	e9 f1 ef ff ff       	jmp    80106e6f <alltraps>

80107e7e <vector241>:
.globl vector241
vector241:
  pushl $0
80107e7e:	6a 00                	push   $0x0
  pushl $241
80107e80:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107e85:	e9 e5 ef ff ff       	jmp    80106e6f <alltraps>

80107e8a <vector242>:
.globl vector242
vector242:
  pushl $0
80107e8a:	6a 00                	push   $0x0
  pushl $242
80107e8c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107e91:	e9 d9 ef ff ff       	jmp    80106e6f <alltraps>

80107e96 <vector243>:
.globl vector243
vector243:
  pushl $0
80107e96:	6a 00                	push   $0x0
  pushl $243
80107e98:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107e9d:	e9 cd ef ff ff       	jmp    80106e6f <alltraps>

80107ea2 <vector244>:
.globl vector244
vector244:
  pushl $0
80107ea2:	6a 00                	push   $0x0
  pushl $244
80107ea4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ea9:	e9 c1 ef ff ff       	jmp    80106e6f <alltraps>

80107eae <vector245>:
.globl vector245
vector245:
  pushl $0
80107eae:	6a 00                	push   $0x0
  pushl $245
80107eb0:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107eb5:	e9 b5 ef ff ff       	jmp    80106e6f <alltraps>

80107eba <vector246>:
.globl vector246
vector246:
  pushl $0
80107eba:	6a 00                	push   $0x0
  pushl $246
80107ebc:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107ec1:	e9 a9 ef ff ff       	jmp    80106e6f <alltraps>

80107ec6 <vector247>:
.globl vector247
vector247:
  pushl $0
80107ec6:	6a 00                	push   $0x0
  pushl $247
80107ec8:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107ecd:	e9 9d ef ff ff       	jmp    80106e6f <alltraps>

80107ed2 <vector248>:
.globl vector248
vector248:
  pushl $0
80107ed2:	6a 00                	push   $0x0
  pushl $248
80107ed4:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107ed9:	e9 91 ef ff ff       	jmp    80106e6f <alltraps>

80107ede <vector249>:
.globl vector249
vector249:
  pushl $0
80107ede:	6a 00                	push   $0x0
  pushl $249
80107ee0:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107ee5:	e9 85 ef ff ff       	jmp    80106e6f <alltraps>

80107eea <vector250>:
.globl vector250
vector250:
  pushl $0
80107eea:	6a 00                	push   $0x0
  pushl $250
80107eec:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107ef1:	e9 79 ef ff ff       	jmp    80106e6f <alltraps>

80107ef6 <vector251>:
.globl vector251
vector251:
  pushl $0
80107ef6:	6a 00                	push   $0x0
  pushl $251
80107ef8:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107efd:	e9 6d ef ff ff       	jmp    80106e6f <alltraps>

80107f02 <vector252>:
.globl vector252
vector252:
  pushl $0
80107f02:	6a 00                	push   $0x0
  pushl $252
80107f04:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107f09:	e9 61 ef ff ff       	jmp    80106e6f <alltraps>

80107f0e <vector253>:
.globl vector253
vector253:
  pushl $0
80107f0e:	6a 00                	push   $0x0
  pushl $253
80107f10:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107f15:	e9 55 ef ff ff       	jmp    80106e6f <alltraps>

80107f1a <vector254>:
.globl vector254
vector254:
  pushl $0
80107f1a:	6a 00                	push   $0x0
  pushl $254
80107f1c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107f21:	e9 49 ef ff ff       	jmp    80106e6f <alltraps>

80107f26 <vector255>:
.globl vector255
vector255:
  pushl $0
80107f26:	6a 00                	push   $0x0
  pushl $255
80107f28:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107f2d:	e9 3d ef ff ff       	jmp    80106e6f <alltraps>

80107f32 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107f32:	55                   	push   %ebp
80107f33:	89 e5                	mov    %esp,%ebp
80107f35:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107f38:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f3b:	83 e8 01             	sub    $0x1,%eax
80107f3e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107f42:	8b 45 08             	mov    0x8(%ebp),%eax
80107f45:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f49:	8b 45 08             	mov    0x8(%ebp),%eax
80107f4c:	c1 e8 10             	shr    $0x10,%eax
80107f4f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107f53:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f56:	0f 01 10             	lgdtl  (%eax)
}
80107f59:	90                   	nop
80107f5a:	c9                   	leave  
80107f5b:	c3                   	ret    

80107f5c <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107f5c:	55                   	push   %ebp
80107f5d:	89 e5                	mov    %esp,%ebp
80107f5f:	83 ec 04             	sub    $0x4,%esp
80107f62:	8b 45 08             	mov    0x8(%ebp),%eax
80107f65:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107f69:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f6d:	0f 00 d8             	ltr    %ax
}
80107f70:	90                   	nop
80107f71:	c9                   	leave  
80107f72:	c3                   	ret    

80107f73 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107f73:	55                   	push   %ebp
80107f74:	89 e5                	mov    %esp,%ebp
80107f76:	83 ec 04             	sub    $0x4,%esp
80107f79:	8b 45 08             	mov    0x8(%ebp),%eax
80107f7c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107f80:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f84:	8e e8                	mov    %eax,%gs
}
80107f86:	90                   	nop
80107f87:	c9                   	leave  
80107f88:	c3                   	ret    

80107f89 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107f89:	55                   	push   %ebp
80107f8a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8f:	0f 22 d8             	mov    %eax,%cr3
}
80107f92:	90                   	nop
80107f93:	5d                   	pop    %ebp
80107f94:	c3                   	ret    

80107f95 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107f95:	55                   	push   %ebp
80107f96:	89 e5                	mov    %esp,%ebp
80107f98:	8b 45 08             	mov    0x8(%ebp),%eax
80107f9b:	05 00 00 00 80       	add    $0x80000000,%eax
80107fa0:	5d                   	pop    %ebp
80107fa1:	c3                   	ret    

80107fa2 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107fa2:	55                   	push   %ebp
80107fa3:	89 e5                	mov    %esp,%ebp
80107fa5:	8b 45 08             	mov    0x8(%ebp),%eax
80107fa8:	05 00 00 00 80       	add    $0x80000000,%eax
80107fad:	5d                   	pop    %ebp
80107fae:	c3                   	ret    

80107faf <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107faf:	55                   	push   %ebp
80107fb0:	89 e5                	mov    %esp,%ebp
80107fb2:	53                   	push   %ebx
80107fb3:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107fb6:	e8 6d b1 ff ff       	call   80103128 <cpunum>
80107fbb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107fc1:	05 a0 33 11 80       	add    $0x801133a0,%eax
80107fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcc:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd5:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107fe9:	83 e2 f0             	and    $0xfffffff0,%edx
80107fec:	83 ca 0a             	or     $0xa,%edx
80107fef:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ff9:	83 ca 10             	or     $0x10,%edx
80107ffc:	88 50 7d             	mov    %dl,0x7d(%eax)
80107fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108002:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108006:	83 e2 9f             	and    $0xffffff9f,%edx
80108009:	88 50 7d             	mov    %dl,0x7d(%eax)
8010800c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108013:	83 ca 80             	or     $0xffffff80,%edx
80108016:	88 50 7d             	mov    %dl,0x7d(%eax)
80108019:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108020:	83 ca 0f             	or     $0xf,%edx
80108023:	88 50 7e             	mov    %dl,0x7e(%eax)
80108026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108029:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010802d:	83 e2 ef             	and    $0xffffffef,%edx
80108030:	88 50 7e             	mov    %dl,0x7e(%eax)
80108033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108036:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010803a:	83 e2 df             	and    $0xffffffdf,%edx
8010803d:	88 50 7e             	mov    %dl,0x7e(%eax)
80108040:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108043:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108047:	83 ca 40             	or     $0x40,%edx
8010804a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010804d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108050:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108054:	83 ca 80             	or     $0xffffff80,%edx
80108057:	88 50 7e             	mov    %dl,0x7e(%eax)
8010805a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805d:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108064:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010806b:	ff ff 
8010806d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108070:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108077:	00 00 
80108079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108086:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010808d:	83 e2 f0             	and    $0xfffffff0,%edx
80108090:	83 ca 02             	or     $0x2,%edx
80108093:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080a3:	83 ca 10             	or     $0x10,%edx
801080a6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080af:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080b6:	83 e2 9f             	and    $0xffffff9f,%edx
801080b9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080c9:	83 ca 80             	or     $0xffffff80,%edx
801080cc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080dc:	83 ca 0f             	or     $0xf,%edx
801080df:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080ef:	83 e2 ef             	and    $0xffffffef,%edx
801080f2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108102:	83 e2 df             	and    $0xffffffdf,%edx
80108105:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010810b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108115:	83 ca 40             	or     $0x40,%edx
80108118:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010811e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108121:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108128:	83 ca 80             	or     $0xffffff80,%edx
8010812b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108134:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010813b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108145:	ff ff 
80108147:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108151:	00 00 
80108153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108156:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010815d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108160:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108167:	83 e2 f0             	and    $0xfffffff0,%edx
8010816a:	83 ca 0a             	or     $0xa,%edx
8010816d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108176:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010817d:	83 ca 10             	or     $0x10,%edx
80108180:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108189:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108190:	83 ca 60             	or     $0x60,%edx
80108193:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081a3:	83 ca 80             	or     $0xffffff80,%edx
801081a6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081af:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081b6:	83 ca 0f             	or     $0xf,%edx
801081b9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081c9:	83 e2 ef             	and    $0xffffffef,%edx
801081cc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081dc:	83 e2 df             	and    $0xffffffdf,%edx
801081df:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081ef:	83 ca 40             	or     $0x40,%edx
801081f2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108202:	83 ca 80             	or     $0xffffff80,%edx
80108205:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010820b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108218:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010821f:	ff ff 
80108221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108224:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010822b:	00 00 
8010822d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108230:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108237:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108241:	83 e2 f0             	and    $0xfffffff0,%edx
80108244:	83 ca 02             	or     $0x2,%edx
80108247:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010824d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108250:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108257:	83 ca 10             	or     $0x10,%edx
8010825a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108260:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108263:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010826a:	83 ca 60             	or     $0x60,%edx
8010826d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108276:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010827d:	83 ca 80             	or     $0xffffff80,%edx
80108280:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108286:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108289:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108290:	83 ca 0f             	or     $0xf,%edx
80108293:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082a3:	83 e2 ef             	and    $0xffffffef,%edx
801082a6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082af:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082b6:	83 e2 df             	and    $0xffffffdf,%edx
801082b9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082c9:	83 ca 40             	or     $0x40,%edx
801082cc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082dc:	83 ca 80             	or     $0xffffff80,%edx
801082df:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e8:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801082ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f2:	05 b4 00 00 00       	add    $0xb4,%eax
801082f7:	89 c3                	mov    %eax,%ebx
801082f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082fc:	05 b4 00 00 00       	add    $0xb4,%eax
80108301:	c1 e8 10             	shr    $0x10,%eax
80108304:	89 c2                	mov    %eax,%edx
80108306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108309:	05 b4 00 00 00       	add    $0xb4,%eax
8010830e:	c1 e8 18             	shr    $0x18,%eax
80108311:	89 c1                	mov    %eax,%ecx
80108313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108316:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010831d:	00 00 
8010831f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108322:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832c:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108335:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010833c:	83 e2 f0             	and    $0xfffffff0,%edx
8010833f:	83 ca 02             	or     $0x2,%edx
80108342:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108352:	83 ca 10             	or     $0x10,%edx
80108355:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010835b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108365:	83 e2 9f             	and    $0xffffff9f,%edx
80108368:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010836e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108371:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108378:	83 ca 80             	or     $0xffffff80,%edx
8010837b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108384:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010838b:	83 e2 f0             	and    $0xfffffff0,%edx
8010838e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108397:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010839e:	83 e2 ef             	and    $0xffffffef,%edx
801083a1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083aa:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083b1:	83 e2 df             	and    $0xffffffdf,%edx
801083b4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083c4:	83 ca 40             	or     $0x40,%edx
801083c7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083d7:	83 ca 80             	or     $0xffffff80,%edx
801083da:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e3:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801083e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ec:	83 c0 70             	add    $0x70,%eax
801083ef:	83 ec 08             	sub    $0x8,%esp
801083f2:	6a 38                	push   $0x38
801083f4:	50                   	push   %eax
801083f5:	e8 38 fb ff ff       	call   80107f32 <lgdt>
801083fa:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801083fd:	83 ec 0c             	sub    $0xc,%esp
80108400:	6a 18                	push   $0x18
80108402:	e8 6c fb ff ff       	call   80107f73 <loadgs>
80108407:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010840a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840d:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108413:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010841a:	00 00 00 00 
}
8010841e:	90                   	nop
8010841f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108422:	c9                   	leave  
80108423:	c3                   	ret    

80108424 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108424:	55                   	push   %ebp
80108425:	89 e5                	mov    %esp,%ebp
80108427:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010842a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010842d:	c1 e8 16             	shr    $0x16,%eax
80108430:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108437:	8b 45 08             	mov    0x8(%ebp),%eax
8010843a:	01 d0                	add    %edx,%eax
8010843c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010843f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108442:	8b 00                	mov    (%eax),%eax
80108444:	83 e0 01             	and    $0x1,%eax
80108447:	85 c0                	test   %eax,%eax
80108449:	74 18                	je     80108463 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010844b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010844e:	8b 00                	mov    (%eax),%eax
80108450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108455:	50                   	push   %eax
80108456:	e8 47 fb ff ff       	call   80107fa2 <p2v>
8010845b:	83 c4 04             	add    $0x4,%esp
8010845e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108461:	eb 48                	jmp    801084ab <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108463:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108467:	74 0e                	je     80108477 <walkpgdir+0x53>
80108469:	e8 54 a9 ff ff       	call   80102dc2 <kalloc>
8010846e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108475:	75 07                	jne    8010847e <walkpgdir+0x5a>
      return 0;
80108477:	b8 00 00 00 00       	mov    $0x0,%eax
8010847c:	eb 44                	jmp    801084c2 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010847e:	83 ec 04             	sub    $0x4,%esp
80108481:	68 00 10 00 00       	push   $0x1000
80108486:	6a 00                	push   $0x0
80108488:	ff 75 f4             	pushl  -0xc(%ebp)
8010848b:	e8 01 d3 ff ff       	call   80105791 <memset>
80108490:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108493:	83 ec 0c             	sub    $0xc,%esp
80108496:	ff 75 f4             	pushl  -0xc(%ebp)
80108499:	e8 f7 fa ff ff       	call   80107f95 <v2p>
8010849e:	83 c4 10             	add    $0x10,%esp
801084a1:	83 c8 07             	or     $0x7,%eax
801084a4:	89 c2                	mov    %eax,%edx
801084a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084a9:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801084ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801084ae:	c1 e8 0c             	shr    $0xc,%eax
801084b1:	25 ff 03 00 00       	and    $0x3ff,%eax
801084b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801084bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c0:	01 d0                	add    %edx,%eax
}
801084c2:	c9                   	leave  
801084c3:	c3                   	ret    

801084c4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801084c4:	55                   	push   %ebp
801084c5:	89 e5                	mov    %esp,%ebp
801084c7:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801084ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801084cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801084d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801084d8:	8b 45 10             	mov    0x10(%ebp),%eax
801084db:	01 d0                	add    %edx,%eax
801084dd:	83 e8 01             	sub    $0x1,%eax
801084e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801084e8:	83 ec 04             	sub    $0x4,%esp
801084eb:	6a 01                	push   $0x1
801084ed:	ff 75 f4             	pushl  -0xc(%ebp)
801084f0:	ff 75 08             	pushl  0x8(%ebp)
801084f3:	e8 2c ff ff ff       	call   80108424 <walkpgdir>
801084f8:	83 c4 10             	add    $0x10,%esp
801084fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108502:	75 07                	jne    8010850b <mappages+0x47>
      return -1;
80108504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108509:	eb 47                	jmp    80108552 <mappages+0x8e>
    if(*pte & PTE_P)
8010850b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850e:	8b 00                	mov    (%eax),%eax
80108510:	83 e0 01             	and    $0x1,%eax
80108513:	85 c0                	test   %eax,%eax
80108515:	74 0d                	je     80108524 <mappages+0x60>
      panic("remap");
80108517:	83 ec 0c             	sub    $0xc,%esp
8010851a:	68 98 93 10 80       	push   $0x80109398
8010851f:	e8 42 80 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108524:	8b 45 18             	mov    0x18(%ebp),%eax
80108527:	0b 45 14             	or     0x14(%ebp),%eax
8010852a:	83 c8 01             	or     $0x1,%eax
8010852d:	89 c2                	mov    %eax,%edx
8010852f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108532:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108537:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010853a:	74 10                	je     8010854c <mappages+0x88>
      break;
    a += PGSIZE;
8010853c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108543:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010854a:	eb 9c                	jmp    801084e8 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010854c:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010854d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108552:	c9                   	leave  
80108553:	c3                   	ret    

80108554 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108554:	55                   	push   %ebp
80108555:	89 e5                	mov    %esp,%ebp
80108557:	53                   	push   %ebx
80108558:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010855b:	e8 62 a8 ff ff       	call   80102dc2 <kalloc>
80108560:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108563:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108567:	75 0a                	jne    80108573 <setupkvm+0x1f>
    return 0;
80108569:	b8 00 00 00 00       	mov    $0x0,%eax
8010856e:	e9 8e 00 00 00       	jmp    80108601 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108573:	83 ec 04             	sub    $0x4,%esp
80108576:	68 00 10 00 00       	push   $0x1000
8010857b:	6a 00                	push   $0x0
8010857d:	ff 75 f0             	pushl  -0x10(%ebp)
80108580:	e8 0c d2 ff ff       	call   80105791 <memset>
80108585:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108588:	83 ec 0c             	sub    $0xc,%esp
8010858b:	68 00 00 00 0e       	push   $0xe000000
80108590:	e8 0d fa ff ff       	call   80107fa2 <p2v>
80108595:	83 c4 10             	add    $0x10,%esp
80108598:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010859d:	76 0d                	jbe    801085ac <setupkvm+0x58>
    panic("PHYSTOP too high");
8010859f:	83 ec 0c             	sub    $0xc,%esp
801085a2:	68 9e 93 10 80       	push   $0x8010939e
801085a7:	e8 ba 7f ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085ac:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
801085b3:	eb 40                	jmp    801085f5 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b8:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801085bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085be:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c4:	8b 58 08             	mov    0x8(%eax),%ebx
801085c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ca:	8b 40 04             	mov    0x4(%eax),%eax
801085cd:	29 c3                	sub    %eax,%ebx
801085cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d2:	8b 00                	mov    (%eax),%eax
801085d4:	83 ec 0c             	sub    $0xc,%esp
801085d7:	51                   	push   %ecx
801085d8:	52                   	push   %edx
801085d9:	53                   	push   %ebx
801085da:	50                   	push   %eax
801085db:	ff 75 f0             	pushl  -0x10(%ebp)
801085de:	e8 e1 fe ff ff       	call   801084c4 <mappages>
801085e3:	83 c4 20             	add    $0x20,%esp
801085e6:	85 c0                	test   %eax,%eax
801085e8:	79 07                	jns    801085f1 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801085ea:	b8 00 00 00 00       	mov    $0x0,%eax
801085ef:	eb 10                	jmp    80108601 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085f1:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801085f5:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
801085fc:	72 b7                	jb     801085b5 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801085fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108604:	c9                   	leave  
80108605:	c3                   	ret    

80108606 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108606:	55                   	push   %ebp
80108607:	89 e5                	mov    %esp,%ebp
80108609:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010860c:	e8 43 ff ff ff       	call   80108554 <setupkvm>
80108611:	a3 78 66 11 80       	mov    %eax,0x80116678
  switchkvm();
80108616:	e8 03 00 00 00       	call   8010861e <switchkvm>
}
8010861b:	90                   	nop
8010861c:	c9                   	leave  
8010861d:	c3                   	ret    

8010861e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010861e:	55                   	push   %ebp
8010861f:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108621:	a1 78 66 11 80       	mov    0x80116678,%eax
80108626:	50                   	push   %eax
80108627:	e8 69 f9 ff ff       	call   80107f95 <v2p>
8010862c:	83 c4 04             	add    $0x4,%esp
8010862f:	50                   	push   %eax
80108630:	e8 54 f9 ff ff       	call   80107f89 <lcr3>
80108635:	83 c4 04             	add    $0x4,%esp
}
80108638:	90                   	nop
80108639:	c9                   	leave  
8010863a:	c3                   	ret    

8010863b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010863b:	55                   	push   %ebp
8010863c:	89 e5                	mov    %esp,%ebp
8010863e:	56                   	push   %esi
8010863f:	53                   	push   %ebx
  pushcli();
80108640:	e8 46 d0 ff ff       	call   8010568b <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108645:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010864b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108652:	83 c2 08             	add    $0x8,%edx
80108655:	89 d6                	mov    %edx,%esi
80108657:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010865e:	83 c2 08             	add    $0x8,%edx
80108661:	c1 ea 10             	shr    $0x10,%edx
80108664:	89 d3                	mov    %edx,%ebx
80108666:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010866d:	83 c2 08             	add    $0x8,%edx
80108670:	c1 ea 18             	shr    $0x18,%edx
80108673:	89 d1                	mov    %edx,%ecx
80108675:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010867c:	67 00 
8010867e:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108685:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010868b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108692:	83 e2 f0             	and    $0xfffffff0,%edx
80108695:	83 ca 09             	or     $0x9,%edx
80108698:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010869e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086a5:	83 ca 10             	or     $0x10,%edx
801086a8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086ae:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086b5:	83 e2 9f             	and    $0xffffff9f,%edx
801086b8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086be:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086c5:	83 ca 80             	or     $0xffffff80,%edx
801086c8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086ce:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801086d5:	83 e2 f0             	and    $0xfffffff0,%edx
801086d8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086de:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801086e5:	83 e2 ef             	and    $0xffffffef,%edx
801086e8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086ee:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801086f5:	83 e2 df             	and    $0xffffffdf,%edx
801086f8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086fe:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108705:	83 ca 40             	or     $0x40,%edx
80108708:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010870e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108715:	83 e2 7f             	and    $0x7f,%edx
80108718:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010871e:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108724:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010872a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108731:	83 e2 ef             	and    $0xffffffef,%edx
80108734:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010873a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108740:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108746:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010874c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108753:	8b 52 08             	mov    0x8(%edx),%edx
80108756:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010875c:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010875f:	83 ec 0c             	sub    $0xc,%esp
80108762:	6a 30                	push   $0x30
80108764:	e8 f3 f7 ff ff       	call   80107f5c <ltr>
80108769:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010876c:	8b 45 08             	mov    0x8(%ebp),%eax
8010876f:	8b 40 04             	mov    0x4(%eax),%eax
80108772:	85 c0                	test   %eax,%eax
80108774:	75 0d                	jne    80108783 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108776:	83 ec 0c             	sub    $0xc,%esp
80108779:	68 af 93 10 80       	push   $0x801093af
8010877e:	e8 e3 7d ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108783:	8b 45 08             	mov    0x8(%ebp),%eax
80108786:	8b 40 04             	mov    0x4(%eax),%eax
80108789:	83 ec 0c             	sub    $0xc,%esp
8010878c:	50                   	push   %eax
8010878d:	e8 03 f8 ff ff       	call   80107f95 <v2p>
80108792:	83 c4 10             	add    $0x10,%esp
80108795:	83 ec 0c             	sub    $0xc,%esp
80108798:	50                   	push   %eax
80108799:	e8 eb f7 ff ff       	call   80107f89 <lcr3>
8010879e:	83 c4 10             	add    $0x10,%esp
  popcli();
801087a1:	e8 2a cf ff ff       	call   801056d0 <popcli>
}
801087a6:	90                   	nop
801087a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801087aa:	5b                   	pop    %ebx
801087ab:	5e                   	pop    %esi
801087ac:	5d                   	pop    %ebp
801087ad:	c3                   	ret    

801087ae <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801087ae:	55                   	push   %ebp
801087af:	89 e5                	mov    %esp,%ebp
801087b1:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801087b4:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801087bb:	76 0d                	jbe    801087ca <inituvm+0x1c>
    panic("inituvm: more than a page");
801087bd:	83 ec 0c             	sub    $0xc,%esp
801087c0:	68 c3 93 10 80       	push   $0x801093c3
801087c5:	e8 9c 7d ff ff       	call   80100566 <panic>
  mem = kalloc();
801087ca:	e8 f3 a5 ff ff       	call   80102dc2 <kalloc>
801087cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801087d2:	83 ec 04             	sub    $0x4,%esp
801087d5:	68 00 10 00 00       	push   $0x1000
801087da:	6a 00                	push   $0x0
801087dc:	ff 75 f4             	pushl  -0xc(%ebp)
801087df:	e8 ad cf ff ff       	call   80105791 <memset>
801087e4:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801087e7:	83 ec 0c             	sub    $0xc,%esp
801087ea:	ff 75 f4             	pushl  -0xc(%ebp)
801087ed:	e8 a3 f7 ff ff       	call   80107f95 <v2p>
801087f2:	83 c4 10             	add    $0x10,%esp
801087f5:	83 ec 0c             	sub    $0xc,%esp
801087f8:	6a 06                	push   $0x6
801087fa:	50                   	push   %eax
801087fb:	68 00 10 00 00       	push   $0x1000
80108800:	6a 00                	push   $0x0
80108802:	ff 75 08             	pushl  0x8(%ebp)
80108805:	e8 ba fc ff ff       	call   801084c4 <mappages>
8010880a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010880d:	83 ec 04             	sub    $0x4,%esp
80108810:	ff 75 10             	pushl  0x10(%ebp)
80108813:	ff 75 0c             	pushl  0xc(%ebp)
80108816:	ff 75 f4             	pushl  -0xc(%ebp)
80108819:	e8 32 d0 ff ff       	call   80105850 <memmove>
8010881e:	83 c4 10             	add    $0x10,%esp
}
80108821:	90                   	nop
80108822:	c9                   	leave  
80108823:	c3                   	ret    

80108824 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108824:	55                   	push   %ebp
80108825:	89 e5                	mov    %esp,%ebp
80108827:	53                   	push   %ebx
80108828:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010882b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010882e:	25 ff 0f 00 00       	and    $0xfff,%eax
80108833:	85 c0                	test   %eax,%eax
80108835:	74 0d                	je     80108844 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108837:	83 ec 0c             	sub    $0xc,%esp
8010883a:	68 e0 93 10 80       	push   $0x801093e0
8010883f:	e8 22 7d ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108844:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010884b:	e9 95 00 00 00       	jmp    801088e5 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108850:	8b 55 0c             	mov    0xc(%ebp),%edx
80108853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108856:	01 d0                	add    %edx,%eax
80108858:	83 ec 04             	sub    $0x4,%esp
8010885b:	6a 00                	push   $0x0
8010885d:	50                   	push   %eax
8010885e:	ff 75 08             	pushl  0x8(%ebp)
80108861:	e8 be fb ff ff       	call   80108424 <walkpgdir>
80108866:	83 c4 10             	add    $0x10,%esp
80108869:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010886c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108870:	75 0d                	jne    8010887f <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108872:	83 ec 0c             	sub    $0xc,%esp
80108875:	68 03 94 10 80       	push   $0x80109403
8010887a:	e8 e7 7c ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010887f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108882:	8b 00                	mov    (%eax),%eax
80108884:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108889:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010888c:	8b 45 18             	mov    0x18(%ebp),%eax
8010888f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108892:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108897:	77 0b                	ja     801088a4 <loaduvm+0x80>
      n = sz - i;
80108899:	8b 45 18             	mov    0x18(%ebp),%eax
8010889c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010889f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088a2:	eb 07                	jmp    801088ab <loaduvm+0x87>
    else
      n = PGSIZE;
801088a4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801088ab:	8b 55 14             	mov    0x14(%ebp),%edx
801088ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801088b4:	83 ec 0c             	sub    $0xc,%esp
801088b7:	ff 75 e8             	pushl  -0x18(%ebp)
801088ba:	e8 e3 f6 ff ff       	call   80107fa2 <p2v>
801088bf:	83 c4 10             	add    $0x10,%esp
801088c2:	ff 75 f0             	pushl  -0x10(%ebp)
801088c5:	53                   	push   %ebx
801088c6:	50                   	push   %eax
801088c7:	ff 75 10             	pushl  0x10(%ebp)
801088ca:	e8 65 97 ff ff       	call   80102034 <readi>
801088cf:	83 c4 10             	add    $0x10,%esp
801088d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801088d5:	74 07                	je     801088de <loaduvm+0xba>
      return -1;
801088d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088dc:	eb 18                	jmp    801088f6 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801088de:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e8:	3b 45 18             	cmp    0x18(%ebp),%eax
801088eb:	0f 82 5f ff ff ff    	jb     80108850 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801088f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801088f9:	c9                   	leave  
801088fa:	c3                   	ret    

801088fb <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801088fb:	55                   	push   %ebp
801088fc:	89 e5                	mov    %esp,%ebp
801088fe:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108901:	8b 45 10             	mov    0x10(%ebp),%eax
80108904:	85 c0                	test   %eax,%eax
80108906:	79 0a                	jns    80108912 <allocuvm+0x17>
    return 0;
80108908:	b8 00 00 00 00       	mov    $0x0,%eax
8010890d:	e9 b0 00 00 00       	jmp    801089c2 <allocuvm+0xc7>
  if(newsz < oldsz)
80108912:	8b 45 10             	mov    0x10(%ebp),%eax
80108915:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108918:	73 08                	jae    80108922 <allocuvm+0x27>
    return oldsz;
8010891a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010891d:	e9 a0 00 00 00       	jmp    801089c2 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108922:	8b 45 0c             	mov    0xc(%ebp),%eax
80108925:	05 ff 0f 00 00       	add    $0xfff,%eax
8010892a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010892f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108932:	eb 7f                	jmp    801089b3 <allocuvm+0xb8>
    mem = kalloc();
80108934:	e8 89 a4 ff ff       	call   80102dc2 <kalloc>
80108939:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010893c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108940:	75 2b                	jne    8010896d <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108942:	83 ec 0c             	sub    $0xc,%esp
80108945:	68 21 94 10 80       	push   $0x80109421
8010894a:	e8 77 7a ff ff       	call   801003c6 <cprintf>
8010894f:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108952:	83 ec 04             	sub    $0x4,%esp
80108955:	ff 75 0c             	pushl  0xc(%ebp)
80108958:	ff 75 10             	pushl  0x10(%ebp)
8010895b:	ff 75 08             	pushl  0x8(%ebp)
8010895e:	e8 61 00 00 00       	call   801089c4 <deallocuvm>
80108963:	83 c4 10             	add    $0x10,%esp
      return 0;
80108966:	b8 00 00 00 00       	mov    $0x0,%eax
8010896b:	eb 55                	jmp    801089c2 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010896d:	83 ec 04             	sub    $0x4,%esp
80108970:	68 00 10 00 00       	push   $0x1000
80108975:	6a 00                	push   $0x0
80108977:	ff 75 f0             	pushl  -0x10(%ebp)
8010897a:	e8 12 ce ff ff       	call   80105791 <memset>
8010897f:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108982:	83 ec 0c             	sub    $0xc,%esp
80108985:	ff 75 f0             	pushl  -0x10(%ebp)
80108988:	e8 08 f6 ff ff       	call   80107f95 <v2p>
8010898d:	83 c4 10             	add    $0x10,%esp
80108990:	89 c2                	mov    %eax,%edx
80108992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108995:	83 ec 0c             	sub    $0xc,%esp
80108998:	6a 06                	push   $0x6
8010899a:	52                   	push   %edx
8010899b:	68 00 10 00 00       	push   $0x1000
801089a0:	50                   	push   %eax
801089a1:	ff 75 08             	pushl  0x8(%ebp)
801089a4:	e8 1b fb ff ff       	call   801084c4 <mappages>
801089a9:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801089ac:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801089b9:	0f 82 75 ff ff ff    	jb     80108934 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801089bf:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089c2:	c9                   	leave  
801089c3:	c3                   	ret    

801089c4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801089c4:	55                   	push   %ebp
801089c5:	89 e5                	mov    %esp,%ebp
801089c7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801089ca:	8b 45 10             	mov    0x10(%ebp),%eax
801089cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089d0:	72 08                	jb     801089da <deallocuvm+0x16>
    return oldsz;
801089d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801089d5:	e9 a5 00 00 00       	jmp    80108a7f <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801089da:	8b 45 10             	mov    0x10(%ebp),%eax
801089dd:	05 ff 0f 00 00       	add    $0xfff,%eax
801089e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801089ea:	e9 81 00 00 00       	jmp    80108a70 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801089ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f2:	83 ec 04             	sub    $0x4,%esp
801089f5:	6a 00                	push   $0x0
801089f7:	50                   	push   %eax
801089f8:	ff 75 08             	pushl  0x8(%ebp)
801089fb:	e8 24 fa ff ff       	call   80108424 <walkpgdir>
80108a00:	83 c4 10             	add    $0x10,%esp
80108a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108a06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a0a:	75 09                	jne    80108a15 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108a0c:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108a13:	eb 54                	jmp    80108a69 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a18:	8b 00                	mov    (%eax),%eax
80108a1a:	83 e0 01             	and    $0x1,%eax
80108a1d:	85 c0                	test   %eax,%eax
80108a1f:	74 48                	je     80108a69 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a24:	8b 00                	mov    (%eax),%eax
80108a26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108a2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a32:	75 0d                	jne    80108a41 <deallocuvm+0x7d>
        panic("kfree");
80108a34:	83 ec 0c             	sub    $0xc,%esp
80108a37:	68 39 94 10 80       	push   $0x80109439
80108a3c:	e8 25 7b ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108a41:	83 ec 0c             	sub    $0xc,%esp
80108a44:	ff 75 ec             	pushl  -0x14(%ebp)
80108a47:	e8 56 f5 ff ff       	call   80107fa2 <p2v>
80108a4c:	83 c4 10             	add    $0x10,%esp
80108a4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108a52:	83 ec 0c             	sub    $0xc,%esp
80108a55:	ff 75 e8             	pushl  -0x18(%ebp)
80108a58:	e8 c8 a2 ff ff       	call   80102d25 <kfree>
80108a5d:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108a69:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a73:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a76:	0f 82 73 ff ff ff    	jb     801089ef <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a7f:	c9                   	leave  
80108a80:	c3                   	ret    

80108a81 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108a81:	55                   	push   %ebp
80108a82:	89 e5                	mov    %esp,%ebp
80108a84:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a8b:	75 0d                	jne    80108a9a <freevm+0x19>
    panic("freevm: no pgdir");
80108a8d:	83 ec 0c             	sub    $0xc,%esp
80108a90:	68 3f 94 10 80       	push   $0x8010943f
80108a95:	e8 cc 7a ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a9a:	83 ec 04             	sub    $0x4,%esp
80108a9d:	6a 00                	push   $0x0
80108a9f:	68 00 00 00 80       	push   $0x80000000
80108aa4:	ff 75 08             	pushl  0x8(%ebp)
80108aa7:	e8 18 ff ff ff       	call   801089c4 <deallocuvm>
80108aac:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108aaf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ab6:	eb 4f                	jmp    80108b07 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80108ac5:	01 d0                	add    %edx,%eax
80108ac7:	8b 00                	mov    (%eax),%eax
80108ac9:	83 e0 01             	and    $0x1,%eax
80108acc:	85 c0                	test   %eax,%eax
80108ace:	74 33                	je     80108b03 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ada:	8b 45 08             	mov    0x8(%ebp),%eax
80108add:	01 d0                	add    %edx,%eax
80108adf:	8b 00                	mov    (%eax),%eax
80108ae1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ae6:	83 ec 0c             	sub    $0xc,%esp
80108ae9:	50                   	push   %eax
80108aea:	e8 b3 f4 ff ff       	call   80107fa2 <p2v>
80108aef:	83 c4 10             	add    $0x10,%esp
80108af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108af5:	83 ec 0c             	sub    $0xc,%esp
80108af8:	ff 75 f0             	pushl  -0x10(%ebp)
80108afb:	e8 25 a2 ff ff       	call   80102d25 <kfree>
80108b00:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108b03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b07:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108b0e:	76 a8                	jbe    80108ab8 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108b10:	83 ec 0c             	sub    $0xc,%esp
80108b13:	ff 75 08             	pushl  0x8(%ebp)
80108b16:	e8 0a a2 ff ff       	call   80102d25 <kfree>
80108b1b:	83 c4 10             	add    $0x10,%esp
}
80108b1e:	90                   	nop
80108b1f:	c9                   	leave  
80108b20:	c3                   	ret    

80108b21 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108b21:	55                   	push   %ebp
80108b22:	89 e5                	mov    %esp,%ebp
80108b24:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b27:	83 ec 04             	sub    $0x4,%esp
80108b2a:	6a 00                	push   $0x0
80108b2c:	ff 75 0c             	pushl  0xc(%ebp)
80108b2f:	ff 75 08             	pushl  0x8(%ebp)
80108b32:	e8 ed f8 ff ff       	call   80108424 <walkpgdir>
80108b37:	83 c4 10             	add    $0x10,%esp
80108b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b41:	75 0d                	jne    80108b50 <clearpteu+0x2f>
    panic("clearpteu");
80108b43:	83 ec 0c             	sub    $0xc,%esp
80108b46:	68 50 94 10 80       	push   $0x80109450
80108b4b:	e8 16 7a ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b53:	8b 00                	mov    (%eax),%eax
80108b55:	83 e0 fb             	and    $0xfffffffb,%eax
80108b58:	89 c2                	mov    %eax,%edx
80108b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5d:	89 10                	mov    %edx,(%eax)
}
80108b5f:	90                   	nop
80108b60:	c9                   	leave  
80108b61:	c3                   	ret    

80108b62 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b62:	55                   	push   %ebp
80108b63:	89 e5                	mov    %esp,%ebp
80108b65:	53                   	push   %ebx
80108b66:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b69:	e8 e6 f9 ff ff       	call   80108554 <setupkvm>
80108b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b75:	75 0a                	jne    80108b81 <copyuvm+0x1f>
    return 0;
80108b77:	b8 00 00 00 00       	mov    $0x0,%eax
80108b7c:	e9 f8 00 00 00       	jmp    80108c79 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108b81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b88:	e9 c4 00 00 00       	jmp    80108c51 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b90:	83 ec 04             	sub    $0x4,%esp
80108b93:	6a 00                	push   $0x0
80108b95:	50                   	push   %eax
80108b96:	ff 75 08             	pushl  0x8(%ebp)
80108b99:	e8 86 f8 ff ff       	call   80108424 <walkpgdir>
80108b9e:	83 c4 10             	add    $0x10,%esp
80108ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108ba4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ba8:	75 0d                	jne    80108bb7 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108baa:	83 ec 0c             	sub    $0xc,%esp
80108bad:	68 5a 94 10 80       	push   $0x8010945a
80108bb2:	e8 af 79 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bba:	8b 00                	mov    (%eax),%eax
80108bbc:	83 e0 01             	and    $0x1,%eax
80108bbf:	85 c0                	test   %eax,%eax
80108bc1:	75 0d                	jne    80108bd0 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108bc3:	83 ec 0c             	sub    $0xc,%esp
80108bc6:	68 74 94 10 80       	push   $0x80109474
80108bcb:	e8 96 79 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bd3:	8b 00                	mov    (%eax),%eax
80108bd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bda:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108be0:	8b 00                	mov    (%eax),%eax
80108be2:	25 ff 0f 00 00       	and    $0xfff,%eax
80108be7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108bea:	e8 d3 a1 ff ff       	call   80102dc2 <kalloc>
80108bef:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108bf2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108bf6:	74 6a                	je     80108c62 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108bf8:	83 ec 0c             	sub    $0xc,%esp
80108bfb:	ff 75 e8             	pushl  -0x18(%ebp)
80108bfe:	e8 9f f3 ff ff       	call   80107fa2 <p2v>
80108c03:	83 c4 10             	add    $0x10,%esp
80108c06:	83 ec 04             	sub    $0x4,%esp
80108c09:	68 00 10 00 00       	push   $0x1000
80108c0e:	50                   	push   %eax
80108c0f:	ff 75 e0             	pushl  -0x20(%ebp)
80108c12:	e8 39 cc ff ff       	call   80105850 <memmove>
80108c17:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108c1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108c1d:	83 ec 0c             	sub    $0xc,%esp
80108c20:	ff 75 e0             	pushl  -0x20(%ebp)
80108c23:	e8 6d f3 ff ff       	call   80107f95 <v2p>
80108c28:	83 c4 10             	add    $0x10,%esp
80108c2b:	89 c2                	mov    %eax,%edx
80108c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c30:	83 ec 0c             	sub    $0xc,%esp
80108c33:	53                   	push   %ebx
80108c34:	52                   	push   %edx
80108c35:	68 00 10 00 00       	push   $0x1000
80108c3a:	50                   	push   %eax
80108c3b:	ff 75 f0             	pushl  -0x10(%ebp)
80108c3e:	e8 81 f8 ff ff       	call   801084c4 <mappages>
80108c43:	83 c4 20             	add    $0x20,%esp
80108c46:	85 c0                	test   %eax,%eax
80108c48:	78 1b                	js     80108c65 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108c4a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c54:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c57:	0f 82 30 ff ff ff    	jb     80108b8d <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c60:	eb 17                	jmp    80108c79 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108c62:	90                   	nop
80108c63:	eb 01                	jmp    80108c66 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108c65:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108c66:	83 ec 0c             	sub    $0xc,%esp
80108c69:	ff 75 f0             	pushl  -0x10(%ebp)
80108c6c:	e8 10 fe ff ff       	call   80108a81 <freevm>
80108c71:	83 c4 10             	add    $0x10,%esp
  return 0;
80108c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108c7c:	c9                   	leave  
80108c7d:	c3                   	ret    

80108c7e <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108c7e:	55                   	push   %ebp
80108c7f:	89 e5                	mov    %esp,%ebp
80108c81:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108c84:	83 ec 04             	sub    $0x4,%esp
80108c87:	6a 00                	push   $0x0
80108c89:	ff 75 0c             	pushl  0xc(%ebp)
80108c8c:	ff 75 08             	pushl  0x8(%ebp)
80108c8f:	e8 90 f7 ff ff       	call   80108424 <walkpgdir>
80108c94:	83 c4 10             	add    $0x10,%esp
80108c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9d:	8b 00                	mov    (%eax),%eax
80108c9f:	83 e0 01             	and    $0x1,%eax
80108ca2:	85 c0                	test   %eax,%eax
80108ca4:	75 07                	jne    80108cad <uva2ka+0x2f>
    return 0;
80108ca6:	b8 00 00 00 00       	mov    $0x0,%eax
80108cab:	eb 29                	jmp    80108cd6 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb0:	8b 00                	mov    (%eax),%eax
80108cb2:	83 e0 04             	and    $0x4,%eax
80108cb5:	85 c0                	test   %eax,%eax
80108cb7:	75 07                	jne    80108cc0 <uva2ka+0x42>
    return 0;
80108cb9:	b8 00 00 00 00       	mov    $0x0,%eax
80108cbe:	eb 16                	jmp    80108cd6 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc3:	8b 00                	mov    (%eax),%eax
80108cc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cca:	83 ec 0c             	sub    $0xc,%esp
80108ccd:	50                   	push   %eax
80108cce:	e8 cf f2 ff ff       	call   80107fa2 <p2v>
80108cd3:	83 c4 10             	add    $0x10,%esp
}
80108cd6:	c9                   	leave  
80108cd7:	c3                   	ret    

80108cd8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108cd8:	55                   	push   %ebp
80108cd9:	89 e5                	mov    %esp,%ebp
80108cdb:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108cde:	8b 45 10             	mov    0x10(%ebp),%eax
80108ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108ce4:	eb 7f                	jmp    80108d65 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ce9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cf4:	83 ec 08             	sub    $0x8,%esp
80108cf7:	50                   	push   %eax
80108cf8:	ff 75 08             	pushl  0x8(%ebp)
80108cfb:	e8 7e ff ff ff       	call   80108c7e <uva2ka>
80108d00:	83 c4 10             	add    $0x10,%esp
80108d03:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d06:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108d0a:	75 07                	jne    80108d13 <copyout+0x3b>
      return -1;
80108d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d11:	eb 61                	jmp    80108d74 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d16:	2b 45 0c             	sub    0xc(%ebp),%eax
80108d19:	05 00 10 00 00       	add    $0x1000,%eax
80108d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d24:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d27:	76 06                	jbe    80108d2f <copyout+0x57>
      n = len;
80108d29:	8b 45 14             	mov    0x14(%ebp),%eax
80108d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d32:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108d35:	89 c2                	mov    %eax,%edx
80108d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d3a:	01 d0                	add    %edx,%eax
80108d3c:	83 ec 04             	sub    $0x4,%esp
80108d3f:	ff 75 f0             	pushl  -0x10(%ebp)
80108d42:	ff 75 f4             	pushl  -0xc(%ebp)
80108d45:	50                   	push   %eax
80108d46:	e8 05 cb ff ff       	call   80105850 <memmove>
80108d4b:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d51:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d57:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d5d:	05 00 10 00 00       	add    $0x1000,%eax
80108d62:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108d65:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108d69:	0f 85 77 ff ff ff    	jne    80108ce6 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d74:	c9                   	leave  
80108d75:	c3                   	ret    
