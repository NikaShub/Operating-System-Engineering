
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	64813103          	ld	sp,1608(sp) # 8000b648 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	712050ef          	jal	80005728 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	00025797          	auipc	a5,0x25
    8000002c:	b8878793          	addi	a5,a5,-1144 # 80024bb0 <end>
    80000030:	00f53733          	sltu	a4,a0,a5
    80000034:	47c5                	li	a5,17
    80000036:	07ee                	slli	a5,a5,0x1b
    80000038:	17fd                	addi	a5,a5,-1
    8000003a:	00a7b7b3          	sltu	a5,a5,a0
    8000003e:	8fd9                	or	a5,a5,a4
    80000040:	ef95                	bnez	a5,8000007c <kfree+0x60>
    80000042:	84aa                	mv	s1,a0
    80000044:	03451793          	slli	a5,a0,0x34
    80000048:	eb95                	bnez	a5,8000007c <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	110000ef          	jal	8000015e <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000052:	0000b917          	auipc	s2,0xb
    80000056:	63e90913          	addi	s2,s2,1598 # 8000b690 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	11a060ef          	jal	80006176 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	192060ef          	jal	800061fe <release>
}
    80000070:	60e2                	ld	ra,24(sp)
    80000072:	6442                	ld	s0,16(sp)
    80000074:	64a2                	ld	s1,8(sp)
    80000076:	6902                	ld	s2,0(sp)
    80000078:	6105                	addi	sp,sp,32
    8000007a:	8082                	ret
    panic("kfree");
    8000007c:	00008517          	auipc	a0,0x8
    80000080:	f8450513          	addi	a0,a0,-124 # 80008000 <etext>
    80000084:	681050ef          	jal	80005f04 <panic>

0000000080000088 <freerange>:
{
    80000088:	7179                	addi	sp,sp,-48
    8000008a:	f406                	sd	ra,40(sp)
    8000008c:	f022                	sd	s0,32(sp)
    8000008e:	ec26                	sd	s1,24(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	00e504b3          	add	s1,a0,a4
    8000009c:	777d                	lui	a4,0xfffff
    8000009e:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000a0:	94be                	add	s1,s1,a5
    800000a2:	0295e263          	bltu	a1,s1,800000c6 <freerange+0x3e>
    800000a6:	e84a                	sd	s2,16(sp)
    800000a8:	e44e                	sd	s3,8(sp)
    800000aa:	e052                	sd	s4,0(sp)
    800000ac:	892e                	mv	s2,a1
    kfree(p);
    800000ae:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000b0:	89be                	mv	s3,a5
    kfree(p);
    800000b2:	01448533          	add	a0,s1,s4
    800000b6:	f67ff0ef          	jal	8000001c <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000ba:	94ce                	add	s1,s1,s3
    800000bc:	fe997be3          	bgeu	s2,s1,800000b2 <freerange+0x2a>
    800000c0:	6942                	ld	s2,16(sp)
    800000c2:	69a2                	ld	s3,8(sp)
    800000c4:	6a02                	ld	s4,0(sp)
}
    800000c6:	70a2                	ld	ra,40(sp)
    800000c8:	7402                	ld	s0,32(sp)
    800000ca:	64e2                	ld	s1,24(sp)
    800000cc:	6145                	addi	sp,sp,48
    800000ce:	8082                	ret

00000000800000d0 <kinit>:
{
    800000d0:	1141                	addi	sp,sp,-16
    800000d2:	e406                	sd	ra,8(sp)
    800000d4:	e022                	sd	s0,0(sp)
    800000d6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d8:	00008597          	auipc	a1,0x8
    800000dc:	f3858593          	addi	a1,a1,-200 # 80008010 <etext+0x10>
    800000e0:	0000b517          	auipc	a0,0xb
    800000e4:	5b050513          	addi	a0,a0,1456 # 8000b690 <kmem>
    800000e8:	00e060ef          	jal	800060f6 <initlock>
  freerange(end, (void *)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00025517          	auipc	a0,0x25
    800000f4:	ac050513          	addi	a0,a0,-1344 # 80024bb0 <end>
    800000f8:	f91ff0ef          	jal	80000088 <freerange>
}
    800000fc:	60a2                	ld	ra,8(sp)
    800000fe:	6402                	ld	s0,0(sp)
    80000100:	0141                	addi	sp,sp,16
    80000102:	8082                	ret

0000000080000104 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000104:	1101                	addi	sp,sp,-32
    80000106:	ec06                	sd	ra,24(sp)
    80000108:	e822                	sd	s0,16(sp)
    8000010a:	e426                	sd	s1,8(sp)
    8000010c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000010e:	0000b517          	auipc	a0,0xb
    80000112:	58250513          	addi	a0,a0,1410 # 8000b690 <kmem>
    80000116:	060060ef          	jal	80006176 <acquire>
  r = kmem.freelist;
    8000011a:	0000b497          	auipc	s1,0xb
    8000011e:	58e4b483          	ld	s1,1422(s1) # 8000b6a8 <kmem+0x18>
  if (r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	0000b717          	auipc	a4,0xb
    8000012a:	58f73123          	sd	a5,1410(a4) # 8000b6a8 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	0000b517          	auipc	a0,0xb
    80000132:	56250513          	addi	a0,a0,1378 # 8000b690 <kmem>
    80000136:	0c8060ef          	jal	800061fe <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    8000013a:	6605                	lui	a2,0x1
    8000013c:	4595                	li	a1,5
    8000013e:	8526                	mv	a0,s1
    80000140:	01e000ef          	jal	8000015e <memset>
  return (void *)r;
}
    80000144:	8526                	mv	a0,s1
    80000146:	60e2                	ld	ra,24(sp)
    80000148:	6442                	ld	s0,16(sp)
    8000014a:	64a2                	ld	s1,8(sp)
    8000014c:	6105                	addi	sp,sp,32
    8000014e:	8082                	ret
  release(&kmem.lock);
    80000150:	0000b517          	auipc	a0,0xb
    80000154:	54050513          	addi	a0,a0,1344 # 8000b690 <kmem>
    80000158:	0a6060ef          	jal	800061fe <release>
  if (r)
    8000015c:	b7e5                	j	80000144 <kalloc+0x40>

000000008000015e <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    8000015e:	1141                	addi	sp,sp,-16
    80000160:	e406                	sd	ra,8(sp)
    80000162:	e022                	sd	s0,0(sp)
    80000164:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000166:	ca19                	beqz	a2,8000017c <memset+0x1e>
    80000168:	87aa                	mv	a5,a0
    8000016a:	1602                	slli	a2,a2,0x20
    8000016c:	9201                	srli	a2,a2,0x20
    8000016e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000172:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000176:	0785                	addi	a5,a5,1
    80000178:	fee79de3          	bne	a5,a4,80000172 <memset+0x14>
  }
  return dst;
}
    8000017c:	60a2                	ld	ra,8(sp)
    8000017e:	6402                	ld	s0,0(sp)
    80000180:	0141                	addi	sp,sp,16
    80000182:	8082                	ret

0000000080000184 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000184:	1141                	addi	sp,sp,-16
    80000186:	e406                	sd	ra,8(sp)
    80000188:	e022                	sd	s0,0(sp)
    8000018a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    8000018c:	c61d                	beqz	a2,800001ba <memcmp+0x36>
    8000018e:	1602                	slli	a2,a2,0x20
    80000190:	9201                	srli	a2,a2,0x20
    80000192:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000196:	00054783          	lbu	a5,0(a0)
    8000019a:	0005c703          	lbu	a4,0(a1)
    8000019e:	00e79863          	bne	a5,a4,800001ae <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    800001a2:	0505                	addi	a0,a0,1
    800001a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800001a6:	fed518e3          	bne	a0,a3,80000196 <memcmp+0x12>
  }

  return 0;
    800001aa:	4501                	li	a0,0
    800001ac:	a019                	j	800001b2 <memcmp+0x2e>
      return *s1 - *s2;
    800001ae:	40e7853b          	subw	a0,a5,a4
}
    800001b2:	60a2                	ld	ra,8(sp)
    800001b4:	6402                	ld	s0,0(sp)
    800001b6:	0141                	addi	sp,sp,16
    800001b8:	8082                	ret
  return 0;
    800001ba:	4501                	li	a0,0
    800001bc:	bfdd                	j	800001b2 <memcmp+0x2e>

00000000800001be <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    800001be:	1141                	addi	sp,sp,-16
    800001c0:	e406                	sd	ra,8(sp)
    800001c2:	e022                	sd	s0,0(sp)
    800001c4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    800001c6:	c205                	beqz	a2,800001e6 <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    800001c8:	02a5e363          	bltu	a1,a0,800001ee <memmove+0x30>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    800001cc:	1602                	slli	a2,a2,0x20
    800001ce:	9201                	srli	a2,a2,0x20
    800001d0:	00c587b3          	add	a5,a1,a2
{
    800001d4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001d6:	0585                	addi	a1,a1,1
    800001d8:	0705                	addi	a4,a4,1
    800001da:	fff5c683          	lbu	a3,-1(a1)
    800001de:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    800001e2:	feb79ae3          	bne	a5,a1,800001d6 <memmove+0x18>

  return dst;
}
    800001e6:	60a2                	ld	ra,8(sp)
    800001e8:	6402                	ld	s0,0(sp)
    800001ea:	0141                	addi	sp,sp,16
    800001ec:	8082                	ret
  if (s < d && s + n > d) {
    800001ee:	02061693          	slli	a3,a2,0x20
    800001f2:	9281                	srli	a3,a3,0x20
    800001f4:	00d58733          	add	a4,a1,a3
    800001f8:	fce57ae3          	bgeu	a0,a4,800001cc <memmove+0xe>
    d += n;
    800001fc:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    800001fe:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000202:	1782                	slli	a5,a5,0x20
    80000204:	9381                	srli	a5,a5,0x20
    80000206:	fff7c793          	not	a5,a5
    8000020a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000020c:	177d                	addi	a4,a4,-1
    8000020e:	16fd                	addi	a3,a3,-1
    80000210:	00074603          	lbu	a2,0(a4)
    80000214:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000218:	fee79ae3          	bne	a5,a4,8000020c <memmove+0x4e>
    8000021c:	b7e9                	j	800001e6 <memmove+0x28>

000000008000021e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    8000021e:	1141                	addi	sp,sp,-16
    80000220:	e406                	sd	ra,8(sp)
    80000222:	e022                	sd	s0,0(sp)
    80000224:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000226:	f99ff0ef          	jal	800001be <memmove>
}
    8000022a:	60a2                	ld	ra,8(sp)
    8000022c:	6402                	ld	s0,0(sp)
    8000022e:	0141                	addi	sp,sp,16
    80000230:	8082                	ret

0000000080000232 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    8000023a:	ce11                	beqz	a2,80000256 <strncmp+0x24>
    8000023c:	00054783          	lbu	a5,0(a0)
    80000240:	cf89                	beqz	a5,8000025a <strncmp+0x28>
    80000242:	0005c703          	lbu	a4,0(a1)
    80000246:	00f71a63          	bne	a4,a5,8000025a <strncmp+0x28>
    n--, p++, q++;
    8000024a:	367d                	addiw	a2,a2,-1
    8000024c:	0505                	addi	a0,a0,1
    8000024e:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000250:	f675                	bnez	a2,8000023c <strncmp+0xa>
  if (n == 0)
    return 0;
    80000252:	4501                	li	a0,0
    80000254:	a801                	j	80000264 <strncmp+0x32>
    80000256:	4501                	li	a0,0
    80000258:	a031                	j	80000264 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000025a:	00054503          	lbu	a0,0(a0)
    8000025e:	0005c783          	lbu	a5,0(a1)
    80000262:	9d1d                	subw	a0,a0,a5
}
    80000264:	60a2                	ld	ra,8(sp)
    80000266:	6402                	ld	s0,0(sp)
    80000268:	0141                	addi	sp,sp,16
    8000026a:	8082                	ret

000000008000026c <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    8000026c:	1141                	addi	sp,sp,-16
    8000026e:	e406                	sd	ra,8(sp)
    80000270:	e022                	sd	s0,0(sp)
    80000272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000274:	87aa                	mv	a5,a0
    80000276:	a011                	j	8000027a <strncpy+0xe>
    80000278:	8636                	mv	a2,a3
    8000027a:	02c05863          	blez	a2,800002aa <strncpy+0x3e>
    8000027e:	fff6069b          	addiw	a3,a2,-1
    80000282:	8836                	mv	a6,a3
    80000284:	0785                	addi	a5,a5,1
    80000286:	0005c703          	lbu	a4,0(a1)
    8000028a:	fee78fa3          	sb	a4,-1(a5)
    8000028e:	0585                	addi	a1,a1,1
    80000290:	f765                	bnez	a4,80000278 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000292:	873e                	mv	a4,a5
    80000294:	01005b63          	blez	a6,800002aa <strncpy+0x3e>
    80000298:	9fb1                	addw	a5,a5,a2
    8000029a:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    800002a2:	40e786bb          	subw	a3,a5,a4
    800002a6:	fed04be3          	bgtz	a3,8000029c <strncpy+0x30>
  return os;
}
    800002aa:	60a2                	ld	ra,8(sp)
    800002ac:	6402                	ld	s0,0(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret

00000000800002b2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e406                	sd	ra,8(sp)
    800002b6:	e022                	sd	s0,0(sp)
    800002b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    800002ba:	02c05363          	blez	a2,800002e0 <safestrcpy+0x2e>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	96ae                	add	a3,a3,a1
    800002c8:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    800002ca:	00d58963          	beq	a1,a3,800002dc <safestrcpy+0x2a>
    800002ce:	0585                	addi	a1,a1,1
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff5c703          	lbu	a4,-1(a1)
    800002d6:	fee78fa3          	sb	a4,-1(a5)
    800002da:	fb65                	bnez	a4,800002ca <safestrcpy+0x18>
    ;
  *s = 0;
    800002dc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e0:	60a2                	ld	ra,8(sp)
    800002e2:	6402                	ld	s0,0(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <strlen>:

int
strlen(const char *s)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    800002f0:	00054783          	lbu	a5,0(a0)
    800002f4:	cf91                	beqz	a5,80000310 <strlen+0x28>
    800002f6:	00150793          	addi	a5,a0,1
    800002fa:	86be                	mv	a3,a5
    800002fc:	0785                	addi	a5,a5,1
    800002fe:	fff7c703          	lbu	a4,-1(a5)
    80000302:	ff65                	bnez	a4,800002fa <strlen+0x12>
    80000304:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000308:	60a2                	ld	ra,8(sp)
    8000030a:	6402                	ld	s0,0(sp)
    8000030c:	0141                	addi	sp,sp,16
    8000030e:	8082                	ret
  for (n = 0; s[n]; n++)
    80000310:	4501                	li	a0,0
    80000312:	bfdd                	j	80000308 <strlen+0x20>

0000000080000314 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e406                	sd	ra,8(sp)
    80000318:	e022                	sd	s0,0(sp)
    8000031a:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    8000031c:	56f000ef          	jal	8000108a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000320:	0000b717          	auipc	a4,0xb
    80000324:	34070713          	addi	a4,a4,832 # 8000b660 <started>
  if (cpuid() == 0) {
    80000328:	c51d                	beqz	a0,80000356 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    8000032a:	431c                	lw	a5,0(a4)
    8000032c:	0230000f          	fence	r,rw
    80000330:	2781                	sext.w	a5,a5
    80000332:	dfe5                	beqz	a5,8000032a <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000334:	557000ef          	jal	8000108a <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00008517          	auipc	a0,0x8
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80008038 <etext+0x38>
    80000342:	099050ef          	jal	80005bda <printk>
    kvminithart();  // turn on paging
    80000346:	082000ef          	jal	800003c8 <kvminithart>
    trapinithart(); // install kernel trap vector
    8000034a:	173010ef          	jal	80001cbc <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    8000034e:	49b040ef          	jal	80004fe8 <plicinithart>
  }

  scheduler();
    80000352:	274010ef          	jal	800015c6 <scheduler>
    consoleinit();
    80000356:	7aa050ef          	jal	80005b00 <consoleinit>
    printkinit();
    8000035a:	3e7050ef          	jal	80005f40 <printkinit>
    printk("\n");
    8000035e:	00008517          	auipc	a0,0x8
    80000362:	cba50513          	addi	a0,a0,-838 # 80008018 <etext+0x18>
    80000366:	075050ef          	jal	80005bda <printk>
    printk("xv6 kernel is booting\n");
    8000036a:	00008517          	auipc	a0,0x8
    8000036e:	cb650513          	addi	a0,a0,-842 # 80008020 <etext+0x20>
    80000372:	069050ef          	jal	80005bda <printk>
    printk("\n");
    80000376:	00008517          	auipc	a0,0x8
    8000037a:	ca250513          	addi	a0,a0,-862 # 80008018 <etext+0x18>
    8000037e:	05d050ef          	jal	80005bda <printk>
    kinit();            // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();          // create kernel page table
    80000386:	5b0000ef          	jal	80000936 <kvminit>
    kvminithart();      // turn on paging
    8000038a:	03e000ef          	jal	800003c8 <kvminithart>
    procinit();         // process table
    8000038e:	449000ef          	jal	80000fd6 <procinit>
    trapinit();         // trap vectors
    80000392:	107010ef          	jal	80001c98 <trapinit>
    trapinithart();     // install kernel trap vector
    80000396:	127010ef          	jal	80001cbc <trapinithart>
    plicinit();         // set up interrupt controller
    8000039a:	435040ef          	jal	80004fce <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    8000039e:	44b040ef          	jal	80004fe8 <plicinithart>
    binit();            // buffer cache
    800003a2:	122020ef          	jal	800024c4 <binit>
    iinit();            // inode table
    800003a6:	674020ef          	jal	80002a1a <iinit>
    fileinit();         // file table
    800003aa:	694030ef          	jal	80003a3e <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	52b040ef          	jal	800050d8 <virtio_disk_init>
    userinit();         // first user process
    800003b2:	068010ef          	jal	8000141a <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    800003b6:	0000b797          	auipc	a5,0xb
    800003ba:	2aa78793          	addi	a5,a5,682 # 8000b660 <started>
    800003be:	4705                	li	a4,1
    800003c0:	0310000f          	fence	rw,w
    800003c4:	c398                	sw	a4,0(a5)
    800003c6:	b771                	j	80000352 <main+0x3e>

00000000800003c8 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    800003c8:	1141                	addi	sp,sp,-16
    800003ca:	e406                	sd	ra,8(sp)
    800003cc:	e022                	sd	s0,0(sp)
    800003ce:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    800003d0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003d4:	0000b797          	auipc	a5,0xb
    800003d8:	2947b783          	ld	a5,660(a5) # 8000b668 <kernel_pagetable>
    800003dc:	83b1                	srli	a5,a5,0xc
    800003de:	577d                	li	a4,-1
    800003e0:	177e                	slli	a4,a4,0x3f
    800003e2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    800003e4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    800003e8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003ec:	60a2                	ld	ra,8(sp)
    800003ee:	6402                	ld	s0,0(sp)
    800003f0:	0141                	addi	sp,sp,16
    800003f2:	8082                	ret

00000000800003f4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003f4:	7139                	addi	sp,sp,-64
    800003f6:	fc06                	sd	ra,56(sp)
    800003f8:	f822                	sd	s0,48(sp)
    800003fa:	f426                	sd	s1,40(sp)
    800003fc:	f04a                	sd	s2,32(sp)
    800003fe:	ec4e                	sd	s3,24(sp)
    80000400:	e852                	sd	s4,16(sp)
    80000402:	e456                	sd	s5,8(sp)
    80000404:	e05a                	sd	s6,0(sp)
    80000406:	0080                	addi	s0,sp,64
    80000408:	84aa                	mv	s1,a0
    8000040a:	89ae                	mv	s3,a1
    8000040c:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    8000040e:	57fd                	li	a5,-1
    80000410:	83e9                	srli	a5,a5,0x1a
    80000412:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000414:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000416:	04b7e763          	bltu	a5,a1,80000464 <walk+0x70>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041a:	0149d933          	srl	s2,s3,s4
    8000041e:	1ff97913          	andi	s2,s2,511
    80000422:	090e                	slli	s2,s2,0x3
    80000424:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000426:	00093483          	ld	s1,0(s2)
    8000042a:	0014f793          	andi	a5,s1,1
    8000042e:	c3a9                	beqz	a5,80000470 <walk+0x7c>
      pagetable = (pagetable_t)PTE2PA(*pte);
#ifdef LAB_PGTBL
      if (PTE_LEAF(*pte)) {
    80000430:	00e4f793          	andi	a5,s1,14
    80000434:	ef89                	bnez	a5,8000044e <walk+0x5a>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000436:	80a9                	srli	s1,s1,0xa
    80000438:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--) {
    8000043a:	3a5d                	addiw	s4,s4,-9
    8000043c:	fd5a1fe3          	bne	s4,s5,8000041a <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000440:	00c9d993          	srli	s3,s3,0xc
    80000444:	1ff9f993          	andi	s3,s3,511
    80000448:	098e                	slli	s3,s3,0x3
    8000044a:	01348933          	add	s2,s1,s3
}
    8000044e:	854a                	mv	a0,s2
    80000450:	70e2                	ld	ra,56(sp)
    80000452:	7442                	ld	s0,48(sp)
    80000454:	74a2                	ld	s1,40(sp)
    80000456:	7902                	ld	s2,32(sp)
    80000458:	69e2                	ld	s3,24(sp)
    8000045a:	6a42                	ld	s4,16(sp)
    8000045c:	6aa2                	ld	s5,8(sp)
    8000045e:	6b02                	ld	s6,0(sp)
    80000460:	6121                	addi	sp,sp,64
    80000462:	8082                	ret
    panic("walk");
    80000464:	00008517          	auipc	a0,0x8
    80000468:	bec50513          	addi	a0,a0,-1044 # 80008050 <etext+0x50>
    8000046c:	299050ef          	jal	80005f04 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000470:	020b0263          	beqz	s6,80000494 <walk+0xa0>
    80000474:	c91ff0ef          	jal	80000104 <kalloc>
    80000478:	84aa                	mv	s1,a0
    8000047a:	cd19                	beqz	a0,80000498 <walk+0xa4>
      memset(pagetable, 0, PGSIZE);
    8000047c:	6605                	lui	a2,0x1
    8000047e:	4581                	li	a1,0
    80000480:	cdfff0ef          	jal	8000015e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000484:	00c4d793          	srli	a5,s1,0xc
    80000488:	07aa                	slli	a5,a5,0xa
    8000048a:	0017e793          	ori	a5,a5,1
    8000048e:	00f93023          	sd	a5,0(s2)
    80000492:	b765                	j	8000043a <walk+0x46>
        return 0;
    80000494:	4901                	li	s2,0
    80000496:	bf65                	j	8000044e <walk+0x5a>
    80000498:	892a                	mv	s2,a0
    8000049a:	bf55                	j	8000044e <walk+0x5a>

000000008000049c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    8000049c:	57fd                	li	a5,-1
    8000049e:	83e9                	srli	a5,a5,0x1a
    800004a0:	00b7f463          	bgeu	a5,a1,800004a8 <walkaddr+0xc>
    return 0;
    800004a4:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004a6:	8082                	ret
{
    800004a8:	1141                	addi	sp,sp,-16
    800004aa:	e406                	sd	ra,8(sp)
    800004ac:	e022                	sd	s0,0(sp)
    800004ae:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004b0:	4601                	li	a2,0
    800004b2:	f43ff0ef          	jal	800003f4 <walk>
  if (pte == 0)
    800004b6:	c901                	beqz	a0,800004c6 <walkaddr+0x2a>
  if ((*pte & PTE_V) == 0)
    800004b8:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    800004ba:	0117f693          	andi	a3,a5,17
    800004be:	4745                	li	a4,17
    return 0;
    800004c0:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    800004c2:	00e68663          	beq	a3,a4,800004ce <walkaddr+0x32>
}
    800004c6:	60a2                	ld	ra,8(sp)
    800004c8:	6402                	ld	s0,0(sp)
    800004ca:	0141                	addi	sp,sp,16
    800004cc:	8082                	ret
  pa = PTE2PA(*pte);
    800004ce:	83a9                	srli	a5,a5,0xa
    800004d0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004d4:	bfcd                	j	800004c6 <walkaddr+0x2a>

00000000800004d6 <vmprintRec>:

#if defined(LAB_PGTBL) || defined(SOL_MMAP) || defined(SOL_COW)

void
vmprintRec(pagetable_t pagetable, int level, uint64 baseVa) {
    800004d6:	7159                	addi	sp,sp,-112
    800004d8:	f486                	sd	ra,104(sp)
    800004da:	f0a2                	sd	s0,96(sp)
    800004dc:	eca6                	sd	s1,88(sp)
    800004de:	e8ca                	sd	s2,80(sp)
    800004e0:	e4ce                	sd	s3,72(sp)
    800004e2:	e0d2                	sd	s4,64(sp)
    800004e4:	fc56                	sd	s5,56(sp)
    800004e6:	f85a                	sd	s6,48(sp)
    800004e8:	f45e                	sd	s7,40(sp)
    800004ea:	f062                	sd	s8,32(sp)
    800004ec:	ec66                	sd	s9,24(sp)
    800004ee:	e86a                	sd	s10,16(sp)
    800004f0:	e46e                	sd	s11,8(sp)
    800004f2:	1880                	addi	s0,sp,112
    800004f4:	8c2e                	mv	s8,a1
    800004f6:	8d32                	mv	s10,a2
    for (int i = 0; i < 512; i++) {
      pte_t pte = pagetable[i];
      if(pte & PTE_V) {

        uint64 va = baseVa | ((uint64)i << (12 + 9 * level));
    800004f8:	00359c9b          	slliw	s9,a1,0x3
    800004fc:	00bc8cbb          	addw	s9,s9,a1
    80000500:	2cb1                	addiw	s9,s9,12
    80000502:	8a2a                	mv	s4,a0
    80000504:	4981                	li	s3,0

        for(int j = 0; j < 3 - level; j++){
    80000506:	4d89                	li	s11,2
    80000508:	4b0d                	li	s6,3
    8000050a:	40bb0b3b          	subw	s6,s6,a1
    8000050e:	a0ad                	j	80000578 <vmprintRec+0xa2>

        printk("%p: pte %p pa %p", (void*)va, (void*)pte, (void*)PTE2PA(pte));

        if((pte & (PTE_R | PTE_W | PTE_X)) != 0) {
          printk(" ");
          if(pte & PTE_R) printk("R");
    80000510:	00008517          	auipc	a0,0x8
    80000514:	04050513          	addi	a0,a0,64 # 80008550 <etext+0x550>
    80000518:	6c2050ef          	jal	80005bda <printk>
    8000051c:	a865                	j	800005d4 <vmprintRec+0xfe>
          if(pte & PTE_W) printk("W");
    8000051e:	00008517          	auipc	a0,0x8
    80000522:	b6250513          	addi	a0,a0,-1182 # 80008080 <etext+0x80>
    80000526:	6b4050ef          	jal	80005bda <printk>
    8000052a:	a845                	j	800005da <vmprintRec+0x104>
          if(pte & PTE_X) printk("X");
    8000052c:	00008517          	auipc	a0,0x8
    80000530:	b5c50513          	addi	a0,a0,-1188 # 80008088 <etext+0x88>
    80000534:	6a6050ef          	jal	80005bda <printk>
    80000538:	a065                	j	800005e0 <vmprintRec+0x10a>
          if(pte & PTE_U) printk("U");
    8000053a:	00008517          	auipc	a0,0x8
    8000053e:	b5650513          	addi	a0,a0,-1194 # 80008090 <etext+0x90>
    80000542:	698050ef          	jal	80005bda <printk>
    80000546:	a04d                	j	800005e8 <vmprintRec+0x112>
        } else {
          printk(" ");
    80000548:	00008517          	auipc	a0,0x8
    8000054c:	b3050513          	addi	a0,a0,-1232 # 80008078 <etext+0x78>
    80000550:	68a050ef          	jal	80005bda <printk>
        }

        printk("\n");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	67e050ef          	jal	80005bda <printk>

        if((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
          uint64 child = PTE2PA(pte);
          vmprintRec((pagetable_t)child, level - 1, va);
    80000560:	865e                	mv	a2,s7
    80000562:	fffc059b          	addiw	a1,s8,-1
    80000566:	8526                	mv	a0,s1
    80000568:	f6fff0ef          	jal	800004d6 <vmprintRec>
    for (int i = 0; i < 512; i++) {
    8000056c:	0985                	addi	s3,s3,1
    8000056e:	0a21                	addi	s4,s4,8
    80000570:	20000793          	li	a5,512
    80000574:	08f98163          	beq	s3,a5,800005f6 <vmprintRec+0x120>
      pte_t pte = pagetable[i];
    80000578:	000a3903          	ld	s2,0(s4)
      if(pte & PTE_V) {
    8000057c:	00197793          	andi	a5,s2,1
    80000580:	d7f5                	beqz	a5,8000056c <vmprintRec+0x96>
        uint64 va = baseVa | ((uint64)i << (12 + 9 * level));
    80000582:	01999bb3          	sll	s7,s3,s9
    80000586:	01abebb3          	or	s7,s7,s10
        for(int j = 0; j < 3 - level; j++){
    8000058a:	018dcd63          	blt	s11,s8,800005a4 <vmprintRec+0xce>
    8000058e:	4481                	li	s1,0
           printk(" ..");
    80000590:	00008a97          	auipc	s5,0x8
    80000594:	ac8a8a93          	addi	s5,s5,-1336 # 80008058 <etext+0x58>
    80000598:	8556                	mv	a0,s5
    8000059a:	640050ef          	jal	80005bda <printk>
        for(int j = 0; j < 3 - level; j++){
    8000059e:	2485                	addiw	s1,s1,1
    800005a0:	ff64cce3          	blt	s1,s6,80000598 <vmprintRec+0xc2>
        printk("%p: pte %p pa %p", (void*)va, (void*)pte, (void*)PTE2PA(pte));
    800005a4:	00a95493          	srli	s1,s2,0xa
    800005a8:	04b2                	slli	s1,s1,0xc
    800005aa:	86a6                	mv	a3,s1
    800005ac:	864a                	mv	a2,s2
    800005ae:	85de                	mv	a1,s7
    800005b0:	00008517          	auipc	a0,0x8
    800005b4:	ab050513          	addi	a0,a0,-1360 # 80008060 <etext+0x60>
    800005b8:	622050ef          	jal	80005bda <printk>
        if((pte & (PTE_R | PTE_W | PTE_X)) != 0) {
    800005bc:	00e97793          	andi	a5,s2,14
    800005c0:	d7c1                	beqz	a5,80000548 <vmprintRec+0x72>
          printk(" ");
    800005c2:	00008517          	auipc	a0,0x8
    800005c6:	ab650513          	addi	a0,a0,-1354 # 80008078 <etext+0x78>
    800005ca:	610050ef          	jal	80005bda <printk>
          if(pte & PTE_R) printk("R");
    800005ce:	00297793          	andi	a5,s2,2
    800005d2:	ff9d                	bnez	a5,80000510 <vmprintRec+0x3a>
          if(pte & PTE_W) printk("W");
    800005d4:	00497793          	andi	a5,s2,4
    800005d8:	f3b9                	bnez	a5,8000051e <vmprintRec+0x48>
          if(pte & PTE_X) printk("X");
    800005da:	00897793          	andi	a5,s2,8
    800005de:	f7b9                	bnez	a5,8000052c <vmprintRec+0x56>
          if(pte & PTE_U) printk("U");
    800005e0:	01097913          	andi	s2,s2,16
    800005e4:	f4091be3          	bnez	s2,8000053a <vmprintRec+0x64>
        printk("\n");
    800005e8:	00008517          	auipc	a0,0x8
    800005ec:	a3050513          	addi	a0,a0,-1488 # 80008018 <etext+0x18>
    800005f0:	5ea050ef          	jal	80005bda <printk>
        if((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800005f4:	bfa5                	j	8000056c <vmprintRec+0x96>
        }
      }
    }
}
    800005f6:	70a6                	ld	ra,104(sp)
    800005f8:	7406                	ld	s0,96(sp)
    800005fa:	64e6                	ld	s1,88(sp)
    800005fc:	6946                	ld	s2,80(sp)
    800005fe:	69a6                	ld	s3,72(sp)
    80000600:	6a06                	ld	s4,64(sp)
    80000602:	7ae2                	ld	s5,56(sp)
    80000604:	7b42                	ld	s6,48(sp)
    80000606:	7ba2                	ld	s7,40(sp)
    80000608:	7c02                	ld	s8,32(sp)
    8000060a:	6ce2                	ld	s9,24(sp)
    8000060c:	6d42                	ld	s10,16(sp)
    8000060e:	6da2                	ld	s11,8(sp)
    80000610:	6165                	addi	sp,sp,112
    80000612:	8082                	ret

0000000080000614 <vmprint>:


void
vmprint(pagetable_t pagetable)
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	1000                	addi	s0,sp,32
    8000061e:	84aa                	mv	s1,a0
  printk("page table %p\n", pagetable);
    80000620:	85aa                	mv	a1,a0
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a7650513          	addi	a0,a0,-1418 # 80008098 <etext+0x98>
    8000062a:	5b0050ef          	jal	80005bda <printk>
  vmprintRec(pagetable, 2, 0);
    8000062e:	4601                	li	a2,0
    80000630:	4589                	li	a1,2
    80000632:	8526                	mv	a0,s1
    80000634:	ea3ff0ef          	jal	800004d6 <vmprintRec>
}
    80000638:	60e2                	ld	ra,24(sp)
    8000063a:	6442                	ld	s0,16(sp)
    8000063c:	64a2                	ld	s1,8(sp)
    8000063e:	6105                	addi	sp,sp,32
    80000640:	8082                	ret

0000000080000642 <kvmmappages>:




int
kvmmappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    80000642:	7119                	addi	sp,sp,-128
    80000644:	fc86                	sd	ra,120(sp)
    80000646:	f8a2                	sd	s0,112(sp)
    80000648:	f4a6                	sd	s1,104(sp)
    8000064a:	f0ca                	sd	s2,96(sp)
    8000064c:	ecce                	sd	s3,88(sp)
    8000064e:	e8d2                	sd	s4,80(sp)
    80000650:	e4d6                	sd	s5,72(sp)
    80000652:	e0da                	sd	s6,64(sp)
    80000654:	fc5e                	sd	s7,56(sp)
    80000656:	f862                	sd	s8,48(sp)
    80000658:	f466                	sd	s9,40(sp)
    8000065a:	f06a                	sd	s10,32(sp)
    8000065c:	ec6e                	sd	s11,24(sp)
    8000065e:	0100                	addi	s0,sp,128
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0) {
    80000660:	03459793          	slli	a5,a1,0x34
    80000664:	eb95                	bnez	a5,80000698 <kvmmappages+0x56>
    80000666:	8baa                	mv	s7,a0
    80000668:	84ae                	mv	s1,a1
    8000066a:	8936                	mv	s2,a3
    8000066c:	8c3a                	mv	s8,a4
    panic("kvmmappages: va not aligned");
  }

  if ((size % PGSIZE) != 0) {
    8000066e:	03461793          	slli	a5,a2,0x34
    80000672:	eb8d                	bnez	a5,800006a4 <kvmmappages+0x62>
    panic("kvmmappages: size not aligned");

  }  

  if (size == 0) {
    80000674:	ce15                	beqz	a2,800006b0 <kvmmappages+0x6e>
    panic("kvmmappages: size");
  }

  a = va;
  last = va + size - PGSIZE;
    80000676:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000067a:	80060613          	addi	a2,a2,-2048
    8000067e:	00b609b3          	add	s3,a2,a1

  for (;;) {
    if ((a % 0x200000) == 0 && (pa % 0x200000) == 0 && (last - a + PGSIZE) >= 0x200000) {
    80000682:	00200db7          	lui	s11,0x200
    80000686:	fffd8c93          	addi	s9,s11,-1 # 1fffff <_entry-0x7fe00001>
        *pte = PA2PTE(pa) | perm | PTE_V;

        a += 0x200000; 
        pa += 0x200000;
    } else {
      if ((pte = walk(pagetable, a, 1)) == 0) {
    8000068a:	4d05                	li	s10,1

      *pte = PA2PTE(pa) | perm | PTE_V;
      if (a == last) {
        break;
      }
      a += PGSIZE;
    8000068c:	6a85                	lui	s5,0x1
    if ((a % 0x200000) == 0 && (pa % 0x200000) == 0 && (last - a + PGSIZE) >= 0x200000) {
    8000068e:	015987b3          	add	a5,s3,s5
    80000692:	f8f43423          	sd	a5,-120(s0)
    80000696:	a041                	j	80000716 <kvmmappages+0xd4>
    panic("kvmmappages: va not aligned");
    80000698:	00008517          	auipc	a0,0x8
    8000069c:	a1050513          	addi	a0,a0,-1520 # 800080a8 <etext+0xa8>
    800006a0:	065050ef          	jal	80005f04 <panic>
    panic("kvmmappages: size not aligned");
    800006a4:	00008517          	auipc	a0,0x8
    800006a8:	a2450513          	addi	a0,a0,-1500 # 800080c8 <etext+0xc8>
    800006ac:	059050ef          	jal	80005f04 <panic>
    panic("kvmmappages: size");
    800006b0:	00008517          	auipc	a0,0x8
    800006b4:	a3850513          	addi	a0,a0,-1480 # 800080e8 <etext+0xe8>
    800006b8:	04d050ef          	jal	80005f04 <panic>
          if((l1 = (pde_t*)kalloc()) == 0) {
    800006bc:	a49ff0ef          	jal	80000104 <kalloc>
    800006c0:	8a2a                	mv	s4,a0
    800006c2:	cd71                	beqz	a0,8000079e <kvmmappages+0x15c>
          memset(l1, 0, PGSIZE);
    800006c4:	8656                	mv	a2,s5
    800006c6:	4581                	li	a1,0
    800006c8:	a97ff0ef          	jal	8000015e <memset>
          *pte2 = PA2PTE(l1) | PTE_V;
    800006cc:	00ca5793          	srli	a5,s4,0xc
    800006d0:	07aa                	slli	a5,a5,0xa
    800006d2:	0017e793          	ori	a5,a5,1
    800006d6:	00fb3023          	sd	a5,0(s6)
    800006da:	a0b5                	j	80000746 <kvmmappages+0x104>
          panic("kvmmappages: remap super");
    800006dc:	00008517          	auipc	a0,0x8
    800006e0:	a2450513          	addi	a0,a0,-1500 # 80008100 <etext+0x100>
    800006e4:	021050ef          	jal	80005f04 <panic>
      if ((pte = walk(pagetable, a, 1)) == 0) {
    800006e8:	866a                	mv	a2,s10
    800006ea:	85a6                	mv	a1,s1
    800006ec:	855e                	mv	a0,s7
    800006ee:	d07ff0ef          	jal	800003f4 <walk>
    800006f2:	c945                	beqz	a0,800007a2 <kvmmappages+0x160>
      if (*pte & PTE_V) {
    800006f4:	611c                	ld	a5,0(a0)
    800006f6:	8b85                	andi	a5,a5,1
    800006f8:	efad                	bnez	a5,80000772 <kvmmappages+0x130>
      *pte = PA2PTE(pa) | perm | PTE_V;
    800006fa:	00c95793          	srli	a5,s2,0xc
    800006fe:	07aa                	slli	a5,a5,0xa
    80000700:	0187e7b3          	or	a5,a5,s8
    80000704:	0017e793          	ori	a5,a5,1
    80000708:	e11c                	sd	a5,0(a0)
      if (a == last) {
    8000070a:	09348e63          	beq	s1,s3,800007a6 <kvmmappages+0x164>
      a += PGSIZE;
    8000070e:	94d6                	add	s1,s1,s5
      pa += PGSIZE;
    80000710:	9956                	add	s2,s2,s5
    }

    if (a > last) break;
    80000712:	0699e663          	bltu	s3,s1,8000077e <kvmmappages+0x13c>
    if ((a % 0x200000) == 0 && (pa % 0x200000) == 0 && (last - a + PGSIZE) >= 0x200000) {
    80000716:	009967b3          	or	a5,s2,s1
    8000071a:	0197f7b3          	and	a5,a5,s9
    8000071e:	f7e9                	bnez	a5,800006e8 <kvmmappages+0xa6>
    80000720:	f8843783          	ld	a5,-120(s0)
    80000724:	8f85                	sub	a5,a5,s1
    80000726:	fdb7e1e3          	bltu	a5,s11,800006e8 <kvmmappages+0xa6>
        pte_t *pte2 = &pagetable[PX(2, a)];
    8000072a:	01e4db13          	srli	s6,s1,0x1e
    8000072e:	1ffb7b13          	andi	s6,s6,511
    80000732:	0b0e                	slli	s6,s6,0x3
    80000734:	9b5e                	add	s6,s6,s7
        if(*pte2 & PTE_V){
    80000736:	000b3a03          	ld	s4,0(s6)
    8000073a:	001a7793          	andi	a5,s4,1
    8000073e:	dfbd                	beqz	a5,800006bc <kvmmappages+0x7a>
          l1 = (pagetable_t)PTE2PA(*pte2);
    80000740:	00aa5a13          	srli	s4,s4,0xa
    80000744:	0a32                	slli	s4,s4,0xc
        pte = &l1[PX(1, a)];
    80000746:	0154d793          	srli	a5,s1,0x15
    8000074a:	1ff7f793          	andi	a5,a5,511
    8000074e:	078e                	slli	a5,a5,0x3
    80000750:	9a3e                	add	s4,s4,a5
        if(*pte & PTE_V) {
    80000752:	000a3783          	ld	a5,0(s4)
    80000756:	8b85                	andi	a5,a5,1
    80000758:	f3d1                	bnez	a5,800006dc <kvmmappages+0x9a>
        *pte = PA2PTE(pa) | perm | PTE_V;
    8000075a:	00c95793          	srli	a5,s2,0xc
    8000075e:	07aa                	slli	a5,a5,0xa
    80000760:	0187e7b3          	or	a5,a5,s8
    80000764:	0017e793          	ori	a5,a5,1
    80000768:	00fa3023          	sd	a5,0(s4)
        a += 0x200000; 
    8000076c:	94ee                	add	s1,s1,s11
        pa += 0x200000;
    8000076e:	996e                	add	s2,s2,s11
    if ((a % 0x200000) == 0 && (pa % 0x200000) == 0 && (last - a + PGSIZE) >= 0x200000) {
    80000770:	b74d                	j	80000712 <kvmmappages+0xd0>
        panic("mappages: remap");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	9ae50513          	addi	a0,a0,-1618 # 80008120 <etext+0x120>
    8000077a:	78a050ef          	jal	80005f04 <panic>
  }
  return 0;
    8000077e:	4501                	li	a0,0
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	74a6                	ld	s1,104(sp)
    80000786:	7906                	ld	s2,96(sp)
    80000788:	69e6                	ld	s3,88(sp)
    8000078a:	6a46                	ld	s4,80(sp)
    8000078c:	6aa6                	ld	s5,72(sp)
    8000078e:	6b06                	ld	s6,64(sp)
    80000790:	7be2                	ld	s7,56(sp)
    80000792:	7c42                	ld	s8,48(sp)
    80000794:	7ca2                	ld	s9,40(sp)
    80000796:	7d02                	ld	s10,32(sp)
    80000798:	6de2                	ld	s11,24(sp)
    8000079a:	6109                	addi	sp,sp,128
    8000079c:	8082                	ret
            return -1;
    8000079e:	557d                	li	a0,-1
    800007a0:	b7c5                	j	80000780 <kvmmappages+0x13e>
        return -1;
    800007a2:	557d                	li	a0,-1
    800007a4:	bff1                	j	80000780 <kvmmappages+0x13e>
  return 0;
    800007a6:	4501                	li	a0,0
    800007a8:	bfe1                	j	80000780 <kvmmappages+0x13e>

00000000800007aa <mappages>:
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.

int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800007aa:	715d                	addi	sp,sp,-80
    800007ac:	e486                	sd	ra,72(sp)
    800007ae:	e0a2                	sd	s0,64(sp)
    800007b0:	fc26                	sd	s1,56(sp)
    800007b2:	f84a                	sd	s2,48(sp)
    800007b4:	f44e                	sd	s3,40(sp)
    800007b6:	f052                	sd	s4,32(sp)
    800007b8:	ec56                	sd	s5,24(sp)
    800007ba:	e85a                	sd	s6,16(sp)
    800007bc:	e45e                	sd	s7,8(sp)
    800007be:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800007c0:	03459793          	slli	a5,a1,0x34
    800007c4:	eba1                	bnez	a5,80000814 <mappages+0x6a>
    800007c6:	8a2a                	mv	s4,a0
    800007c8:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    800007ca:	03461793          	slli	a5,a2,0x34
    800007ce:	eba9                	bnez	a5,80000820 <mappages+0x76>
    panic("mappages: size not aligned");

  if (size == 0)
    800007d0:	ce31                	beqz	a2,8000082c <mappages+0x82>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    800007d2:	80060613          	addi	a2,a2,-2048
    800007d6:	80060613          	addi	a2,a2,-2048
    800007da:	00b60933          	add	s2,a2,a1
  a = va;
    800007de:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    800007e0:	4b05                	li	s6,1
    800007e2:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800007e6:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    800007e8:	865a                	mv	a2,s6
    800007ea:	85a6                	mv	a1,s1
    800007ec:	8552                	mv	a0,s4
    800007ee:	c07ff0ef          	jal	800003f4 <walk>
    800007f2:	c929                	beqz	a0,80000844 <mappages+0x9a>
    if (*pte & PTE_V)
    800007f4:	611c                	ld	a5,0(a0)
    800007f6:	8b85                	andi	a5,a5,1
    800007f8:	e3a1                	bnez	a5,80000838 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800007fa:	013487b3          	add	a5,s1,s3
    800007fe:	83b1                	srli	a5,a5,0xc
    80000800:	07aa                	slli	a5,a5,0xa
    80000802:	0157e7b3          	or	a5,a5,s5
    80000806:	0017e793          	ori	a5,a5,1
    8000080a:	e11c                	sd	a5,0(a0)
    if (a == last)
    8000080c:	05248863          	beq	s1,s2,8000085c <mappages+0xb2>
    a += PGSIZE;
    80000810:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80000812:	bfd9                	j	800007e8 <mappages+0x3e>
    panic("mappages: va not aligned");
    80000814:	00008517          	auipc	a0,0x8
    80000818:	91c50513          	addi	a0,a0,-1764 # 80008130 <etext+0x130>
    8000081c:	6e8050ef          	jal	80005f04 <panic>
    panic("mappages: size not aligned");
    80000820:	00008517          	auipc	a0,0x8
    80000824:	93050513          	addi	a0,a0,-1744 # 80008150 <etext+0x150>
    80000828:	6dc050ef          	jal	80005f04 <panic>
    panic("mappages: size");
    8000082c:	00008517          	auipc	a0,0x8
    80000830:	94450513          	addi	a0,a0,-1724 # 80008170 <etext+0x170>
    80000834:	6d0050ef          	jal	80005f04 <panic>
      panic("mappages: remap");
    80000838:	00008517          	auipc	a0,0x8
    8000083c:	8e850513          	addi	a0,a0,-1816 # 80008120 <etext+0x120>
    80000840:	6c4050ef          	jal	80005f04 <panic>
      return -1;
    80000844:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000846:	60a6                	ld	ra,72(sp)
    80000848:	6406                	ld	s0,64(sp)
    8000084a:	74e2                	ld	s1,56(sp)
    8000084c:	7942                	ld	s2,48(sp)
    8000084e:	79a2                	ld	s3,40(sp)
    80000850:	7a02                	ld	s4,32(sp)
    80000852:	6ae2                	ld	s5,24(sp)
    80000854:	6b42                	ld	s6,16(sp)
    80000856:	6ba2                	ld	s7,8(sp)
    80000858:	6161                	addi	sp,sp,80
    8000085a:	8082                	ret
  return 0;
    8000085c:	4501                	li	a0,0
    8000085e:	b7e5                	j	80000846 <mappages+0x9c>

0000000080000860 <kvmmap>:
// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
    80000868:	87b6                	mv	a5,a3
  if (kvmmappages(kpgtbl, va, sz, pa, perm) != 0)
    8000086a:	86b2                	mv	a3,a2
    8000086c:	863e                	mv	a2,a5
    8000086e:	dd5ff0ef          	jal	80000642 <kvmmappages>
    80000872:	e509                	bnez	a0,8000087c <kvmmap+0x1c>
    panic("kvmmap");
}
    80000874:	60a2                	ld	ra,8(sp)
    80000876:	6402                	ld	s0,0(sp)
    80000878:	0141                	addi	sp,sp,16
    8000087a:	8082                	ret
    panic("kvmmap");
    8000087c:	00008517          	auipc	a0,0x8
    80000880:	90450513          	addi	a0,a0,-1788 # 80008180 <etext+0x180>
    80000884:	680050ef          	jal	80005f04 <panic>

0000000080000888 <kvmmake>:
{
    80000888:	1101                	addi	sp,sp,-32
    8000088a:	ec06                	sd	ra,24(sp)
    8000088c:	e822                	sd	s0,16(sp)
    8000088e:	e426                	sd	s1,8(sp)
    80000890:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000892:	873ff0ef          	jal	80000104 <kalloc>
    80000896:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000898:	6605                	lui	a2,0x1
    8000089a:	4581                	li	a1,0
    8000089c:	8c3ff0ef          	jal	8000015e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800008a0:	4719                	li	a4,6
    800008a2:	6685                	lui	a3,0x1
    800008a4:	10000637          	lui	a2,0x10000
    800008a8:	85b2                	mv	a1,a2
    800008aa:	8526                	mv	a0,s1
    800008ac:	fb5ff0ef          	jal	80000860 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800008b0:	4719                	li	a4,6
    800008b2:	6685                	lui	a3,0x1
    800008b4:	10001637          	lui	a2,0x10001
    800008b8:	85b2                	mv	a1,a2
    800008ba:	8526                	mv	a0,s1
    800008bc:	fa5ff0ef          	jal	80000860 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800008c0:	4719                	li	a4,6
    800008c2:	040006b7          	lui	a3,0x4000
    800008c6:	0c000637          	lui	a2,0xc000
    800008ca:	85b2                	mv	a1,a2
    800008cc:	8526                	mv	a0,s1
    800008ce:	f93ff0ef          	jal	80000860 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800008d2:	4729                	li	a4,10
    800008d4:	80007697          	auipc	a3,0x80007
    800008d8:	72c68693          	addi	a3,a3,1836 # 8000 <_entry-0x7fff8000>
    800008dc:	4605                	li	a2,1
    800008de:	067e                	slli	a2,a2,0x1f
    800008e0:	85b2                	mv	a1,a2
    800008e2:	8526                	mv	a0,s1
    800008e4:	f7dff0ef          	jal	80000860 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800008e8:	4719                	li	a4,6
    800008ea:	00007697          	auipc	a3,0x7
    800008ee:	71668693          	addi	a3,a3,1814 # 80008000 <etext>
    800008f2:	47c5                	li	a5,17
    800008f4:	07ee                	slli	a5,a5,0x1b
    800008f6:	40d786b3          	sub	a3,a5,a3
    800008fa:	00007617          	auipc	a2,0x7
    800008fe:	70660613          	addi	a2,a2,1798 # 80008000 <etext>
    80000902:	85b2                	mv	a1,a2
    80000904:	8526                	mv	a0,s1
    80000906:	f5bff0ef          	jal	80000860 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000090a:	4729                	li	a4,10
    8000090c:	6685                	lui	a3,0x1
    8000090e:	00006617          	auipc	a2,0x6
    80000912:	6f260613          	addi	a2,a2,1778 # 80007000 <_trampoline>
    80000916:	040005b7          	lui	a1,0x4000
    8000091a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000091c:	05b2                	slli	a1,a1,0xc
    8000091e:	8526                	mv	a0,s1
    80000920:	f41ff0ef          	jal	80000860 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000924:	8526                	mv	a0,s1
    80000926:	60e000ef          	jal	80000f34 <proc_mapstacks>
}
    8000092a:	8526                	mv	a0,s1
    8000092c:	60e2                	ld	ra,24(sp)
    8000092e:	6442                	ld	s0,16(sp)
    80000930:	64a2                	ld	s1,8(sp)
    80000932:	6105                	addi	sp,sp,32
    80000934:	8082                	ret

0000000080000936 <kvminit>:
{
    80000936:	1141                	addi	sp,sp,-16
    80000938:	e406                	sd	ra,8(sp)
    8000093a:	e022                	sd	s0,0(sp)
    8000093c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000093e:	f4bff0ef          	jal	80000888 <kvmmake>
    80000942:	0000b797          	auipc	a5,0xb
    80000946:	d2a7b323          	sd	a0,-730(a5) # 8000b668 <kernel_pagetable>
}
    8000094a:	60a2                	ld	ra,8(sp)
    8000094c:	6402                	ld	s0,0(sp)
    8000094e:	0141                	addi	sp,sp,16
    80000950:	8082                	ret

0000000080000952 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000952:	1101                	addi	sp,sp,-32
    80000954:	ec06                	sd	ra,24(sp)
    80000956:	e822                	sd	s0,16(sp)
    80000958:	e426                	sd	s1,8(sp)
    8000095a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    8000095c:	fa8ff0ef          	jal	80000104 <kalloc>
    80000960:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000962:	c509                	beqz	a0,8000096c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000964:	6605                	lui	a2,0x1
    80000966:	4581                	li	a1,0
    80000968:	ff6ff0ef          	jal	8000015e <memset>
  return pagetable;
}
    8000096c:	8526                	mv	a0,s1
    8000096e:	60e2                	ld	ra,24(sp)
    80000970:	6442                	ld	s0,16(sp)
    80000972:	64a2                	ld	s1,8(sp)
    80000974:	6105                	addi	sp,sp,32
    80000976:	8082                	ret

0000000080000978 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000978:	715d                	addi	sp,sp,-80
    8000097a:	e486                	sd	ra,72(sp)
    8000097c:	e0a2                	sd	s0,64(sp)
    8000097e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if ((va % PGSIZE) != 0)
    80000980:	03459793          	slli	a5,a1,0x34
    80000984:	e39d                	bnez	a5,800009aa <uvmunmap+0x32>
    80000986:	f84a                	sd	s2,48(sp)
    80000988:	f44e                	sd	s3,40(sp)
    8000098a:	f052                	sd	s4,32(sp)
    8000098c:	ec56                	sd	s5,24(sp)
    8000098e:	e85a                	sd	s6,16(sp)
    80000990:	e45e                	sd	s7,8(sp)
    80000992:	8a2a                	mv	s4,a0
    80000994:	892e                	mv	s2,a1
    80000996:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += sz) {
    80000998:	0632                	slli	a2,a2,0xc
    8000099a:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if (PTE_FLAGS(*pte) == PTE_V)
    8000099e:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += sz) {
    800009a0:	6a85                	lui	s5,0x1
    800009a2:	0735f463          	bgeu	a1,s3,80000a0a <uvmunmap+0x92>
    800009a6:	fc26                	sd	s1,56(sp)
    800009a8:	a80d                	j	800009da <uvmunmap+0x62>
    800009aa:	fc26                	sd	s1,56(sp)
    800009ac:	f84a                	sd	s2,48(sp)
    800009ae:	f44e                	sd	s3,40(sp)
    800009b0:	f052                	sd	s4,32(sp)
    800009b2:	ec56                	sd	s5,24(sp)
    800009b4:	e85a                	sd	s6,16(sp)
    800009b6:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800009b8:	00007517          	auipc	a0,0x7
    800009bc:	7d050513          	addi	a0,a0,2000 # 80008188 <etext+0x188>
    800009c0:	544050ef          	jal	80005f04 <panic>
      panic("uvmunmap: not a leaf");
    800009c4:	00007517          	auipc	a0,0x7
    800009c8:	7dc50513          	addi	a0,a0,2012 # 800081a0 <etext+0x1a0>
    800009cc:	538050ef          	jal	80005f04 <panic>
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800009d0:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += sz) {
    800009d4:	9956                	add	s2,s2,s5
    800009d6:	03397963          	bgeu	s2,s3,80000a08 <uvmunmap+0x90>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800009da:	4601                	li	a2,0
    800009dc:	85ca                	mv	a1,s2
    800009de:	8552                	mv	a0,s4
    800009e0:	a15ff0ef          	jal	800003f4 <walk>
    800009e4:	84aa                	mv	s1,a0
    800009e6:	d57d                	beqz	a0,800009d4 <uvmunmap+0x5c>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    800009e8:	611c                	ld	a5,0(a0)
    800009ea:	0017f713          	andi	a4,a5,1
    800009ee:	d37d                	beqz	a4,800009d4 <uvmunmap+0x5c>
    if (PTE_FLAGS(*pte) == PTE_V)
    800009f0:	3ff7f713          	andi	a4,a5,1023
    800009f4:	fd7708e3          	beq	a4,s7,800009c4 <uvmunmap+0x4c>
    if (do_free) {
    800009f8:	fc0b0ce3          	beqz	s6,800009d0 <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    800009fc:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    800009fe:	00c79513          	slli	a0,a5,0xc
    80000a02:	e1aff0ef          	jal	8000001c <kfree>
    80000a06:	b7e9                	j	800009d0 <uvmunmap+0x58>
    80000a08:	74e2                	ld	s1,56(sp)
    80000a0a:	7942                	ld	s2,48(sp)
    80000a0c:	79a2                	ld	s3,40(sp)
    80000a0e:	7a02                	ld	s4,32(sp)
    80000a10:	6ae2                	ld	s5,24(sp)
    80000a12:	6b42                	ld	s6,16(sp)
    80000a14:	6ba2                	ld	s7,8(sp)
  }
}
    80000a16:	60a6                	ld	ra,72(sp)
    80000a18:	6406                	ld	s0,64(sp)
    80000a1a:	6161                	addi	sp,sp,80
    80000a1c:	8082                	ret

0000000080000a1e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a1e:	1101                	addi	sp,sp,-32
    80000a20:	ec06                	sd	ra,24(sp)
    80000a22:	e822                	sd	s0,16(sp)
    80000a24:	e426                	sd	s1,8(sp)
    80000a26:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80000a28:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80000a2a:	00b67d63          	bgeu	a2,a1,80000a44 <uvmdealloc+0x26>
    80000a2e:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000a30:	6785                	lui	a5,0x1
    80000a32:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a34:	00f60733          	add	a4,a2,a5
    80000a38:	76fd                	lui	a3,0xfffff
    80000a3a:	8f75                	and	a4,a4,a3
    80000a3c:	97ae                	add	a5,a5,a1
    80000a3e:	8ff5                	and	a5,a5,a3
    80000a40:	00f76863          	bltu	a4,a5,80000a50 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a44:	8526                	mv	a0,s1
    80000a46:	60e2                	ld	ra,24(sp)
    80000a48:	6442                	ld	s0,16(sp)
    80000a4a:	64a2                	ld	s1,8(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a50:	8f99                	sub	a5,a5,a4
    80000a52:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a54:	4685                	li	a3,1
    80000a56:	0007861b          	sext.w	a2,a5
    80000a5a:	85ba                	mv	a1,a4
    80000a5c:	f1dff0ef          	jal	80000978 <uvmunmap>
    80000a60:	b7d5                	j	80000a44 <uvmdealloc+0x26>

0000000080000a62 <uvmalloc>:
  if (newsz < oldsz)
    80000a62:	0ab66163          	bltu	a2,a1,80000b04 <uvmalloc+0xa2>
{
    80000a66:	715d                	addi	sp,sp,-80
    80000a68:	e486                	sd	ra,72(sp)
    80000a6a:	e0a2                	sd	s0,64(sp)
    80000a6c:	f84a                	sd	s2,48(sp)
    80000a6e:	f052                	sd	s4,32(sp)
    80000a70:	ec56                	sd	s5,24(sp)
    80000a72:	e45e                	sd	s7,8(sp)
    80000a74:	0880                	addi	s0,sp,80
    80000a76:	8aaa                	mv	s5,a0
    80000a78:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a7e:	95be                	add	a1,a1,a5
    80000a80:	77fd                	lui	a5,0xfffff
    80000a82:	00f5f933          	and	s2,a1,a5
    80000a86:	8bca                	mv	s7,s2
  for (a = oldsz; a < newsz; a += sz) {
    80000a88:	08c97063          	bgeu	s2,a2,80000b08 <uvmalloc+0xa6>
    80000a8c:	fc26                	sd	s1,56(sp)
    80000a8e:	f44e                	sd	s3,40(sp)
    80000a90:	e85a                	sd	s6,16(sp)
    memset(mem, 0, sz);
    80000a92:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, sz, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    80000a94:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000a98:	e6cff0ef          	jal	80000104 <kalloc>
    80000a9c:	84aa                	mv	s1,a0
    if (mem == 0) {
    80000a9e:	c50d                	beqz	a0,80000ac8 <uvmalloc+0x66>
    memset(mem, 0, sz);
    80000aa0:	864e                	mv	a2,s3
    80000aa2:	4581                	li	a1,0
    80000aa4:	ebaff0ef          	jal	8000015e <memset>
    if (mappages(pagetable, a, sz, (uint64)mem, PTE_R | PTE_U | xperm) != 0) {
    80000aa8:	875a                	mv	a4,s6
    80000aaa:	86a6                	mv	a3,s1
    80000aac:	864e                	mv	a2,s3
    80000aae:	85ca                	mv	a1,s2
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	cf9ff0ef          	jal	800007aa <mappages>
    80000ab6:	e915                	bnez	a0,80000aea <uvmalloc+0x88>
  for (a = oldsz; a < newsz; a += sz) {
    80000ab8:	994e                	add	s2,s2,s3
    80000aba:	fd496fe3          	bltu	s2,s4,80000a98 <uvmalloc+0x36>
  return newsz;
    80000abe:	8552                	mv	a0,s4
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	79a2                	ld	s3,40(sp)
    80000ac4:	6b42                	ld	s6,16(sp)
    80000ac6:	a811                	j	80000ada <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80000ac8:	865e                	mv	a2,s7
    80000aca:	85ca                	mv	a1,s2
    80000acc:	8556                	mv	a0,s5
    80000ace:	f51ff0ef          	jal	80000a1e <uvmdealloc>
      return 0;
    80000ad2:	4501                	li	a0,0
    80000ad4:	74e2                	ld	s1,56(sp)
    80000ad6:	79a2                	ld	s3,40(sp)
    80000ad8:	6b42                	ld	s6,16(sp)
}
    80000ada:	60a6                	ld	ra,72(sp)
    80000adc:	6406                	ld	s0,64(sp)
    80000ade:	7942                	ld	s2,48(sp)
    80000ae0:	7a02                	ld	s4,32(sp)
    80000ae2:	6ae2                	ld	s5,24(sp)
    80000ae4:	6ba2                	ld	s7,8(sp)
    80000ae6:	6161                	addi	sp,sp,80
    80000ae8:	8082                	ret
      kfree(mem);
    80000aea:	8526                	mv	a0,s1
    80000aec:	d30ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000af0:	865e                	mv	a2,s7
    80000af2:	85ca                	mv	a1,s2
    80000af4:	8556                	mv	a0,s5
    80000af6:	f29ff0ef          	jal	80000a1e <uvmdealloc>
      return 0;
    80000afa:	4501                	li	a0,0
    80000afc:	74e2                	ld	s1,56(sp)
    80000afe:	79a2                	ld	s3,40(sp)
    80000b00:	6b42                	ld	s6,16(sp)
    80000b02:	bfe1                	j	80000ada <uvmalloc+0x78>
    return oldsz;
    80000b04:	852e                	mv	a0,a1
}
    80000b06:	8082                	ret
  return newsz;
    80000b08:	8532                	mv	a0,a2
    80000b0a:	bfc1                	j	80000ada <uvmalloc+0x78>

0000000080000b0c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b0c:	7179                	addi	sp,sp,-48
    80000b0e:	f406                	sd	ra,40(sp)
    80000b10:	f022                	sd	s0,32(sp)
    80000b12:	ec26                	sd	s1,24(sp)
    80000b14:	e84a                	sd	s2,16(sp)
    80000b16:	e44e                	sd	s3,8(sp)
    80000b18:	1800                	addi	s0,sp,48
    80000b1a:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80000b1c:	84aa                	mv	s1,a0
    80000b1e:	6905                	lui	s2,0x1
    80000b20:	992a                	add	s2,s2,a0
    80000b22:	a811                	j	80000b36 <freewalk+0x2a>
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      // backtrace();
      panic("freewalk: leaf");
    80000b24:	00007517          	auipc	a0,0x7
    80000b28:	69450513          	addi	a0,a0,1684 # 800081b8 <etext+0x1b8>
    80000b2c:	3d8050ef          	jal	80005f04 <panic>
  for (int i = 0; i < 512; i++) {
    80000b30:	04a1                	addi	s1,s1,8
    80000b32:	03248163          	beq	s1,s2,80000b54 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000b36:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000b38:	0017f713          	andi	a4,a5,1
    80000b3c:	db75                	beqz	a4,80000b30 <freewalk+0x24>
    80000b3e:	00e7f713          	andi	a4,a5,14
    80000b42:	f36d                	bnez	a4,80000b24 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80000b44:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000b46:	00c79513          	slli	a0,a5,0xc
    80000b4a:	fc3ff0ef          	jal	80000b0c <freewalk>
      pagetable[i] = 0;
    80000b4e:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000b52:	bff9                	j	80000b30 <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    80000b54:	854e                	mv	a0,s3
    80000b56:	cc6ff0ef          	jal	8000001c <kfree>
}
    80000b5a:	70a2                	ld	ra,40(sp)
    80000b5c:	7402                	ld	s0,32(sp)
    80000b5e:	64e2                	ld	s1,24(sp)
    80000b60:	6942                	ld	s2,16(sp)
    80000b62:	69a2                	ld	s3,8(sp)
    80000b64:	6145                	addi	sp,sp,48
    80000b66:	8082                	ret

0000000080000b68 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b68:	1101                	addi	sp,sp,-32
    80000b6a:	ec06                	sd	ra,24(sp)
    80000b6c:	e822                	sd	s0,16(sp)
    80000b6e:	e426                	sd	s1,8(sp)
    80000b70:	1000                	addi	s0,sp,32
    80000b72:	84aa                	mv	s1,a0
  if (sz > 0)
    80000b74:	e989                	bnez	a1,80000b86 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000b76:	8526                	mv	a0,s1
    80000b78:	f95ff0ef          	jal	80000b0c <freewalk>
}
    80000b7c:	60e2                	ld	ra,24(sp)
    80000b7e:	6442                	ld	s0,16(sp)
    80000b80:	64a2                	ld	s1,8(sp)
    80000b82:	6105                	addi	sp,sp,32
    80000b84:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000b86:	6785                	lui	a5,0x1
    80000b88:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b8a:	95be                	add	a1,a1,a5
    80000b8c:	4685                	li	a3,1
    80000b8e:	00c5d613          	srli	a2,a1,0xc
    80000b92:	4581                	li	a1,0
    80000b94:	de5ff0ef          	jal	80000978 <uvmunmap>
    80000b98:	bff9                	j	80000b76 <uvmfree+0xe>

0000000080000b9a <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for (i = 0; i < sz; i += szinc) {
    80000b9a:	ca59                	beqz	a2,80000c30 <uvmcopy+0x96>
{
    80000b9c:	715d                	addi	sp,sp,-80
    80000b9e:	e486                	sd	ra,72(sp)
    80000ba0:	e0a2                	sd	s0,64(sp)
    80000ba2:	fc26                	sd	s1,56(sp)
    80000ba4:	f84a                	sd	s2,48(sp)
    80000ba6:	f44e                	sd	s3,40(sp)
    80000ba8:	f052                	sd	s4,32(sp)
    80000baa:	ec56                	sd	s5,24(sp)
    80000bac:	e85a                	sd	s6,16(sp)
    80000bae:	e45e                	sd	s7,8(sp)
    80000bb0:	0880                	addi	s0,sp,80
    80000bb2:	8b2a                	mv	s6,a0
    80000bb4:	8bae                	mv	s7,a1
    80000bb6:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += szinc) {
    80000bb8:	4481                	li	s1,0
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80000bba:	6a05                	lui	s4,0x1
    80000bbc:	a021                	j	80000bc4 <uvmcopy+0x2a>
  for (i = 0; i < sz; i += szinc) {
    80000bbe:	94d2                	add	s1,s1,s4
    80000bc0:	0554fc63          	bgeu	s1,s5,80000c18 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    80000bc4:	4601                	li	a2,0
    80000bc6:	85a6                	mv	a1,s1
    80000bc8:	855a                	mv	a0,s6
    80000bca:	82bff0ef          	jal	800003f4 <walk>
    80000bce:	d965                	beqz	a0,80000bbe <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0) {
    80000bd0:	00053983          	ld	s3,0(a0)
    80000bd4:	0019f793          	andi	a5,s3,1
    80000bd8:	d3fd                	beqz	a5,80000bbe <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80000bda:	d2aff0ef          	jal	80000104 <kalloc>
    80000bde:	892a                	mv	s2,a0
    80000be0:	c11d                	beqz	a0,80000c06 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    80000be2:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80000be6:	8652                	mv	a2,s4
    80000be8:	05b2                	slli	a1,a1,0xc
    80000bea:	dd4ff0ef          	jal	800001be <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000bee:	3ff9f713          	andi	a4,s3,1023
    80000bf2:	86ca                	mv	a3,s2
    80000bf4:	8652                	mv	a2,s4
    80000bf6:	85a6                	mv	a1,s1
    80000bf8:	855e                	mv	a0,s7
    80000bfa:	bb1ff0ef          	jal	800007aa <mappages>
    80000bfe:	d161                	beqz	a0,80000bbe <uvmcopy+0x24>
      kfree(mem);
    80000c00:	854a                	mv	a0,s2
    80000c02:	c1aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c06:	4685                	li	a3,1
    80000c08:	00c4d613          	srli	a2,s1,0xc
    80000c0c:	4581                	li	a1,0
    80000c0e:	855e                	mv	a0,s7
    80000c10:	d69ff0ef          	jal	80000978 <uvmunmap>
  return -1;
    80000c14:	557d                	li	a0,-1
    80000c16:	a011                	j	80000c1a <uvmcopy+0x80>
  return 0;
    80000c18:	4501                	li	a0,0
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6161                	addi	sp,sp,80
    80000c2e:	8082                	ret
  return 0;
    80000c30:	4501                	li	a0,0
}
    80000c32:	8082                	ret

0000000080000c34 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c34:	1141                	addi	sp,sp,-16
    80000c36:	e406                	sd	ra,8(sp)
    80000c38:	e022                	sd	s0,0(sp)
    80000c3a:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000c3c:	4601                	li	a2,0
    80000c3e:	fb6ff0ef          	jal	800003f4 <walk>
  if (pte == 0)
    80000c42:	c901                	beqz	a0,80000c52 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c44:	611c                	ld	a5,0(a0)
    80000c46:	9bbd                	andi	a5,a5,-17
    80000c48:	e11c                	sd	a5,0(a0)
}
    80000c4a:	60a2                	ld	ra,8(sp)
    80000c4c:	6402                	ld	s0,0(sp)
    80000c4e:	0141                	addi	sp,sp,16
    80000c50:	8082                	ret
    panic("uvmclear");
    80000c52:	00007517          	auipc	a0,0x7
    80000c56:	57650513          	addi	a0,a0,1398 # 800081c8 <etext+0x1c8>
    80000c5a:	2aa050ef          	jal	80005f04 <panic>

0000000080000c5e <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80000c5e:	1141                	addi	sp,sp,-16
    80000c60:	e406                	sd	ra,8(sp)
    80000c62:	e022                	sd	s0,0(sp)
    80000c64:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000c66:	4601                	li	a2,0
    80000c68:	f8cff0ef          	jal	800003f4 <walk>
  if (pte == 0) {
    80000c6c:	c119                	beqz	a0,80000c72 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    80000c6e:	6108                	ld	a0,0(a0)
    80000c70:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000c72:	60a2                	ld	ra,8(sp)
    80000c74:	6402                	ld	s0,0(sp)
    80000c76:	0141                	addi	sp,sp,16
    80000c78:	8082                	ret

0000000080000c7a <vmfault>:
{
    80000c7a:	7179                	addi	sp,sp,-48
    80000c7c:	f406                	sd	ra,40(sp)
    80000c7e:	f022                	sd	s0,32(sp)
    80000c80:	e052                	sd	s4,0(sp)
    80000c82:	1800                	addi	s0,sp,48
    return 0;
    80000c84:	4a01                	li	s4,0
  if (va >= psz)
    80000c86:	00b66863          	bltu	a2,a1,80000c96 <vmfault+0x1c>
}
    80000c8a:	8552                	mv	a0,s4
    80000c8c:	70a2                	ld	ra,40(sp)
    80000c8e:	7402                	ld	s0,32(sp)
    80000c90:	6a02                	ld	s4,0(sp)
    80000c92:	6145                	addi	sp,sp,48
    80000c94:	8082                	ret
    80000c96:	ec26                	sd	s1,24(sp)
    80000c98:	e44e                	sd	s3,8(sp)
    80000c9a:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000c9c:	77fd                	lui	a5,0xfffff
    80000c9e:	00f679b3          	and	s3,a2,a5
  if (ismapped(pagetable, va)) {
    80000ca2:	85ce                	mv	a1,s3
    80000ca4:	fbbff0ef          	jal	80000c5e <ismapped>
    return 0;
    80000ca8:	4a01                	li	s4,0
  if (ismapped(pagetable, va)) {
    80000caa:	c501                	beqz	a0,80000cb2 <vmfault+0x38>
    80000cac:	64e2                	ld	s1,24(sp)
    80000cae:	69a2                	ld	s3,8(sp)
    80000cb0:	bfe9                	j	80000c8a <vmfault+0x10>
    80000cb2:	e84a                	sd	s2,16(sp)
  mem = (uint64)kalloc();
    80000cb4:	c50ff0ef          	jal	80000104 <kalloc>
    80000cb8:	892a                	mv	s2,a0
  if (mem == 0)
    80000cba:	c915                	beqz	a0,80000cee <vmfault+0x74>
  mem = (uint64)kalloc();
    80000cbc:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    80000cbe:	6605                	lui	a2,0x1
    80000cc0:	4581                	li	a1,0
    80000cc2:	c9cff0ef          	jal	8000015e <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80000cc6:	4759                	li	a4,22
    80000cc8:	86ca                	mv	a3,s2
    80000cca:	6605                	lui	a2,0x1
    80000ccc:	85ce                	mv	a1,s3
    80000cce:	8526                	mv	a0,s1
    80000cd0:	adbff0ef          	jal	800007aa <mappages>
    80000cd4:	e509                	bnez	a0,80000cde <vmfault+0x64>
    80000cd6:	64e2                	ld	s1,24(sp)
    80000cd8:	6942                	ld	s2,16(sp)
    80000cda:	69a2                	ld	s3,8(sp)
    80000cdc:	b77d                	j	80000c8a <vmfault+0x10>
    kfree((void *)mem);
    80000cde:	854a                	mv	a0,s2
    80000ce0:	b3cff0ef          	jal	8000001c <kfree>
    return 0;
    80000ce4:	4a01                	li	s4,0
    80000ce6:	64e2                	ld	s1,24(sp)
    80000ce8:	6942                	ld	s2,16(sp)
    80000cea:	69a2                	ld	s3,8(sp)
    80000cec:	bf79                	j	80000c8a <vmfault+0x10>
    80000cee:	64e2                	ld	s1,24(sp)
    80000cf0:	6942                	ld	s2,16(sp)
    80000cf2:	69a2                	ld	s3,8(sp)
    80000cf4:	bf59                	j	80000c8a <vmfault+0x10>

0000000080000cf6 <copyout>:
  while (len > 0) {
    80000cf6:	cf51                	beqz	a4,80000d92 <copyout+0x9c>
{
    80000cf8:	7159                	addi	sp,sp,-112
    80000cfa:	f486                	sd	ra,104(sp)
    80000cfc:	f0a2                	sd	s0,96(sp)
    80000cfe:	eca6                	sd	s1,88(sp)
    80000d00:	e8ca                	sd	s2,80(sp)
    80000d02:	e4ce                	sd	s3,72(sp)
    80000d04:	e0d2                	sd	s4,64(sp)
    80000d06:	fc56                	sd	s5,56(sp)
    80000d08:	f85a                	sd	s6,48(sp)
    80000d0a:	f45e                	sd	s7,40(sp)
    80000d0c:	f062                	sd	s8,32(sp)
    80000d0e:	ec66                	sd	s9,24(sp)
    80000d10:	e86a                	sd	s10,16(sp)
    80000d12:	e46e                	sd	s11,8(sp)
    80000d14:	1880                	addi	s0,sp,112
    80000d16:	8baa                	mv	s7,a0
    80000d18:	8dae                	mv	s11,a1
    80000d1a:	8a32                	mv	s4,a2
    80000d1c:	8b36                	mv	s6,a3
    80000d1e:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    80000d20:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80000d22:	5cfd                	li	s9,-1
    80000d24:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000d28:	6c05                	lui	s8,0x1
    80000d2a:	a005                	j	80000d4a <copyout+0x54>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000d2c:	409a0533          	sub	a0,s4,s1
    80000d30:	0009061b          	sext.w	a2,s2
    80000d34:	85da                	mv	a1,s6
    80000d36:	954e                	add	a0,a0,s3
    80000d38:	c86ff0ef          	jal	800001be <memmove>
    len -= n;
    80000d3c:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000d40:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000d42:	01848a33          	add	s4,s1,s8
  while (len > 0) {
    80000d46:	040a8463          	beqz	s5,80000d8e <copyout+0x98>
    va0 = PGROUNDDOWN(dstva);
    80000d4a:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    80000d4e:	049ce463          	bltu	s9,s1,80000d96 <copyout+0xa0>
    pa0 = walkaddr(pagetable, va0);
    80000d52:	85a6                	mv	a1,s1
    80000d54:	855e                	mv	a0,s7
    80000d56:	f46ff0ef          	jal	8000049c <walkaddr>
    80000d5a:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    80000d5c:	e909                	bnez	a0,80000d6e <copyout+0x78>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    80000d5e:	4681                	li	a3,0
    80000d60:	8626                	mv	a2,s1
    80000d62:	85ee                	mv	a1,s11
    80000d64:	855e                	mv	a0,s7
    80000d66:	f15ff0ef          	jal	80000c7a <vmfault>
    80000d6a:	89aa                	mv	s3,a0
    80000d6c:	c529                	beqz	a0,80000db6 <copyout+0xc0>
    if ((pte = walk(pagetable, va0, 0)) == 0) {
    80000d6e:	4601                	li	a2,0
    80000d70:	85a6                	mv	a1,s1
    80000d72:	855e                	mv	a0,s7
    80000d74:	e80ff0ef          	jal	800003f4 <walk>
    80000d78:	c129                	beqz	a0,80000dba <copyout+0xc4>
    if ((*pte & PTE_W) == 0)
    80000d7a:	611c                	ld	a5,0(a0)
    80000d7c:	8b91                	andi	a5,a5,4
    80000d7e:	c3a1                	beqz	a5,80000dbe <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000d80:	41448933          	sub	s2,s1,s4
    80000d84:	9962                	add	s2,s2,s8
    if (n > len)
    80000d86:	fb2af3e3          	bgeu	s5,s2,80000d2c <copyout+0x36>
    80000d8a:	8956                	mv	s2,s5
    80000d8c:	b745                	j	80000d2c <copyout+0x36>
  return 0;
    80000d8e:	4501                	li	a0,0
    80000d90:	a021                	j	80000d98 <copyout+0xa2>
    80000d92:	4501                	li	a0,0
}
    80000d94:	8082                	ret
      return -1;
    80000d96:	557d                	li	a0,-1
}
    80000d98:	70a6                	ld	ra,104(sp)
    80000d9a:	7406                	ld	s0,96(sp)
    80000d9c:	64e6                	ld	s1,88(sp)
    80000d9e:	6946                	ld	s2,80(sp)
    80000da0:	69a6                	ld	s3,72(sp)
    80000da2:	6a06                	ld	s4,64(sp)
    80000da4:	7ae2                	ld	s5,56(sp)
    80000da6:	7b42                	ld	s6,48(sp)
    80000da8:	7ba2                	ld	s7,40(sp)
    80000daa:	7c02                	ld	s8,32(sp)
    80000dac:	6ce2                	ld	s9,24(sp)
    80000dae:	6d42                	ld	s10,16(sp)
    80000db0:	6da2                	ld	s11,8(sp)
    80000db2:	6165                	addi	sp,sp,112
    80000db4:	8082                	ret
        return -1;
    80000db6:	557d                	li	a0,-1
    80000db8:	b7c5                	j	80000d98 <copyout+0xa2>
      return -1;
    80000dba:	557d                	li	a0,-1
    80000dbc:	bff1                	j	80000d98 <copyout+0xa2>
      return -1;
    80000dbe:	557d                	li	a0,-1
    80000dc0:	bfe1                	j	80000d98 <copyout+0xa2>

0000000080000dc2 <copyin>:
  while (len > 0) {
    80000dc2:	cf41                	beqz	a4,80000e5a <copyin+0x98>
{
    80000dc4:	711d                	addi	sp,sp,-96
    80000dc6:	ec86                	sd	ra,88(sp)
    80000dc8:	e8a2                	sd	s0,80(sp)
    80000dca:	e4a6                	sd	s1,72(sp)
    80000dcc:	e0ca                	sd	s2,64(sp)
    80000dce:	fc4e                	sd	s3,56(sp)
    80000dd0:	f852                	sd	s4,48(sp)
    80000dd2:	f456                	sd	s5,40(sp)
    80000dd4:	f05a                	sd	s6,32(sp)
    80000dd6:	ec5e                	sd	s7,24(sp)
    80000dd8:	e862                	sd	s8,16(sp)
    80000dda:	e466                	sd	s9,8(sp)
    80000ddc:	e06a                	sd	s10,0(sp)
    80000dde:	1080                	addi	s0,sp,96
    80000de0:	8baa                	mv	s7,a0
    80000de2:	8cae                	mv	s9,a1
    80000de4:	8ab2                	mv	s5,a2
    80000de6:	8936                	mv	s2,a3
    80000de8:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    80000dea:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80000dec:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80000dee:	6b05                	lui	s6,0x1
    80000df0:	a035                	j	80000e1c <copyin+0x5a>
    80000df2:	412984b3          	sub	s1,s3,s2
    80000df6:	94da                	add	s1,s1,s6
    if (n > len)
    80000df8:	009a7363          	bgeu	s4,s1,80000dfe <copyin+0x3c>
    80000dfc:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000dfe:	413905b3          	sub	a1,s2,s3
    80000e02:	0004861b          	sext.w	a2,s1
    80000e06:	95aa                	add	a1,a1,a0
    80000e08:	8556                	mv	a0,s5
    80000e0a:	bb4ff0ef          	jal	800001be <memmove>
    len -= n;
    80000e0e:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000e12:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000e14:	01698933          	add	s2,s3,s6
  while (len > 0) {
    80000e18:	020a0263          	beqz	s4,80000e3c <copyin+0x7a>
    va0 = PGROUNDDOWN(srcva);
    80000e1c:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000e20:	85ce                	mv	a1,s3
    80000e22:	855e                	mv	a0,s7
    80000e24:	e78ff0ef          	jal	8000049c <walkaddr>
    if (pa0 == 0) {
    80000e28:	f569                	bnez	a0,80000df2 <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80000e2a:	86ea                	mv	a3,s10
    80000e2c:	864e                	mv	a2,s3
    80000e2e:	85e6                	mv	a1,s9
    80000e30:	855e                	mv	a0,s7
    80000e32:	e49ff0ef          	jal	80000c7a <vmfault>
    80000e36:	fd55                	bnez	a0,80000df2 <copyin+0x30>
        return -1;
    80000e38:	557d                	li	a0,-1
    80000e3a:	a011                	j	80000e3e <copyin+0x7c>
  return 0;
    80000e3c:	4501                	li	a0,0
}
    80000e3e:	60e6                	ld	ra,88(sp)
    80000e40:	6446                	ld	s0,80(sp)
    80000e42:	64a6                	ld	s1,72(sp)
    80000e44:	6906                	ld	s2,64(sp)
    80000e46:	79e2                	ld	s3,56(sp)
    80000e48:	7a42                	ld	s4,48(sp)
    80000e4a:	7aa2                	ld	s5,40(sp)
    80000e4c:	7b02                	ld	s6,32(sp)
    80000e4e:	6be2                	ld	s7,24(sp)
    80000e50:	6c42                	ld	s8,16(sp)
    80000e52:	6ca2                	ld	s9,8(sp)
    80000e54:	6d02                	ld	s10,0(sp)
    80000e56:	6125                	addi	sp,sp,96
    80000e58:	8082                	ret
  return 0;
    80000e5a:	4501                	li	a0,0
}
    80000e5c:	8082                	ret

0000000080000e5e <copyinstr>:
  while (got_null == 0 && max > 0) {
    80000e5e:	c769                	beqz	a4,80000f28 <copyinstr+0xca>
{
    80000e60:	711d                	addi	sp,sp,-96
    80000e62:	ec86                	sd	ra,88(sp)
    80000e64:	e8a2                	sd	s0,80(sp)
    80000e66:	e4a6                	sd	s1,72(sp)
    80000e68:	e0ca                	sd	s2,64(sp)
    80000e6a:	fc4e                	sd	s3,56(sp)
    80000e6c:	f852                	sd	s4,48(sp)
    80000e6e:	f456                	sd	s5,40(sp)
    80000e70:	f05a                	sd	s6,32(sp)
    80000e72:	ec5e                	sd	s7,24(sp)
    80000e74:	e862                	sd	s8,16(sp)
    80000e76:	e466                	sd	s9,8(sp)
    80000e78:	1080                	addi	s0,sp,96
    80000e7a:	8b2a                	mv	s6,a0
    80000e7c:	8c2e                	mv	s8,a1
    80000e7e:	89b2                	mv	s3,a2
    80000e80:	84b6                	mv	s1,a3
    80000e82:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    80000e84:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80000e86:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    80000e88:	6a85                	lui	s5,0x1
    80000e8a:	a881                	j	80000eda <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80000e8c:	86e6                	mv	a3,s9
    80000e8e:	864a                	mv	a2,s2
    80000e90:	85e2                	mv	a1,s8
    80000e92:	855a                	mv	a0,s6
    80000e94:	de7ff0ef          	jal	80000c7a <vmfault>
    80000e98:	e921                	bnez	a0,80000ee8 <copyinstr+0x8a>
        return -1;
    80000e9a:	557d                	li	a0,-1
    80000e9c:	a801                	j	80000eac <copyinstr+0x4e>
        *dst = '\0';
    80000e9e:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffda450>
        got_null = 1;
    80000ea2:	4785                	li	a5,1
  if (got_null) {
    80000ea4:	0017c793          	xori	a5,a5,1
    80000ea8:	40f0053b          	negw	a0,a5
}
    80000eac:	60e6                	ld	ra,88(sp)
    80000eae:	6446                	ld	s0,80(sp)
    80000eb0:	64a6                	ld	s1,72(sp)
    80000eb2:	6906                	ld	s2,64(sp)
    80000eb4:	79e2                	ld	s3,56(sp)
    80000eb6:	7a42                	ld	s4,48(sp)
    80000eb8:	7aa2                	ld	s5,40(sp)
    80000eba:	7b02                	ld	s6,32(sp)
    80000ebc:	6be2                	ld	s7,24(sp)
    80000ebe:	6c42                	ld	s8,16(sp)
    80000ec0:	6ca2                	ld	s9,8(sp)
    80000ec2:	6125                	addi	sp,sp,96
    80000ec4:	8082                	ret
    80000ec6:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80000eca:	974e                	add	a4,a4,s3
      --max;
    80000ecc:	40b70a33          	sub	s4,a4,a1
    srcva = va0 + PGSIZE;
    80000ed0:	015904b3          	add	s1,s2,s5
  while (got_null == 0 && max > 0) {
    80000ed4:	04e58463          	beq	a1,a4,80000f1c <copyinstr+0xbe>
{
    80000ed8:	89be                	mv	s3,a5
    va0 = PGROUNDDOWN(srcva);
    80000eda:	0174f933          	and	s2,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80000ede:	85ca                	mv	a1,s2
    80000ee0:	855a                	mv	a0,s6
    80000ee2:	dbaff0ef          	jal	8000049c <walkaddr>
    if (pa0 == 0) {
    80000ee6:	d15d                	beqz	a0,80000e8c <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    80000ee8:	40990633          	sub	a2,s2,s1
    80000eec:	9656                	add	a2,a2,s5
    if (n > max)
    80000eee:	00ca7363          	bgeu	s4,a2,80000ef4 <copyinstr+0x96>
    80000ef2:	8652                	mv	a2,s4
    while (n > 0) {
    80000ef4:	c615                	beqz	a2,80000f20 <copyinstr+0xc2>
    char *p = (char *)(pa0 + (srcva - va0));
    80000ef6:	412484b3          	sub	s1,s1,s2
    80000efa:	94aa                	add	s1,s1,a0
    80000efc:	87ce                	mv	a5,s3
      if (*p == '\0') {
    80000efe:	413484b3          	sub	s1,s1,s3
    while (n > 0) {
    80000f02:	964e                	add	a2,a2,s3
    80000f04:	85be                	mv	a1,a5
      if (*p == '\0') {
    80000f06:	00f48733          	add	a4,s1,a5
    80000f0a:	00074683          	lbu	a3,0(a4)
    80000f0e:	dac1                	beqz	a3,80000e9e <copyinstr+0x40>
        *dst = *p;
    80000f10:	00d78023          	sb	a3,0(a5)
      dst++;
    80000f14:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000f16:	fec797e3          	bne	a5,a2,80000f04 <copyinstr+0xa6>
    80000f1a:	b775                	j	80000ec6 <copyinstr+0x68>
    80000f1c:	4781                	li	a5,0
    80000f1e:	b759                	j	80000ea4 <copyinstr+0x46>
    srcva = va0 + PGSIZE;
    80000f20:	6485                	lui	s1,0x1
    80000f22:	94ca                	add	s1,s1,s2
    80000f24:	87ce                	mv	a5,s3
    80000f26:	bf4d                	j	80000ed8 <copyinstr+0x7a>
  int got_null = 0;
    80000f28:	4781                	li	a5,0
  if (got_null) {
    80000f2a:	0017c793          	xori	a5,a5,1
    80000f2e:	40f0053b          	negw	a0,a5
}
    80000f32:	8082                	ret

0000000080000f34 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000f34:	715d                	addi	sp,sp,-80
    80000f36:	e486                	sd	ra,72(sp)
    80000f38:	e0a2                	sd	s0,64(sp)
    80000f3a:	fc26                	sd	s1,56(sp)
    80000f3c:	f84a                	sd	s2,48(sp)
    80000f3e:	f44e                	sd	s3,40(sp)
    80000f40:	f052                	sd	s4,32(sp)
    80000f42:	ec56                	sd	s5,24(sp)
    80000f44:	e85a                	sd	s6,16(sp)
    80000f46:	e45e                	sd	s7,8(sp)
    80000f48:	e062                	sd	s8,0(sp)
    80000f4a:	0880                	addi	s0,sp,80
    80000f4c:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000f4e:	0000b497          	auipc	s1,0xb
    80000f52:	b9248493          	addi	s1,s1,-1134 # 8000bae0 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000f56:	8c26                	mv	s8,s1
    80000f58:	ff4df937          	lui	s2,0xff4df
    80000f5c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e0d>
    80000f60:	0936                	slli	s2,s2,0xd
    80000f62:	6f590913          	addi	s2,s2,1781
    80000f66:	0936                	slli	s2,s2,0xd
    80000f68:	bd390913          	addi	s2,s2,-1069
    80000f6c:	0932                	slli	s2,s2,0xc
    80000f6e:	7a790913          	addi	s2,s2,1959
    80000f72:	010009b7          	lui	s3,0x1000
    80000f76:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000f78:	09ba                	slli	s3,s3,0xe
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f7a:	4b99                	li	s7,6
    80000f7c:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    80000f7e:	00010a97          	auipc	s5,0x10
    80000f82:	762a8a93          	addi	s5,s5,1890 # 800116e0 <tickslock>
    char *pa = kalloc();
    80000f86:	97eff0ef          	jal	80000104 <kalloc>
    80000f8a:	862a                	mv	a2,a0
    if (pa == 0)
    80000f8c:	cd1d                	beqz	a0,80000fca <proc_mapstacks+0x96>
    uint64 va = KSTACK((int)(p - proc));
    80000f8e:	418485b3          	sub	a1,s1,s8
    80000f92:	8591                	srai	a1,a1,0x4
    80000f94:	032585b3          	mul	a1,a1,s2
    80000f98:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f9c:	875e                	mv	a4,s7
    80000f9e:	86da                	mv	a3,s6
    80000fa0:	40b985b3          	sub	a1,s3,a1
    80000fa4:	8552                	mv	a0,s4
    80000fa6:	8bbff0ef          	jal	80000860 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000faa:	17048493          	addi	s1,s1,368
    80000fae:	fd549ce3          	bne	s1,s5,80000f86 <proc_mapstacks+0x52>
  }
}
    80000fb2:	60a6                	ld	ra,72(sp)
    80000fb4:	6406                	ld	s0,64(sp)
    80000fb6:	74e2                	ld	s1,56(sp)
    80000fb8:	7942                	ld	s2,48(sp)
    80000fba:	79a2                	ld	s3,40(sp)
    80000fbc:	7a02                	ld	s4,32(sp)
    80000fbe:	6ae2                	ld	s5,24(sp)
    80000fc0:	6b42                	ld	s6,16(sp)
    80000fc2:	6ba2                	ld	s7,8(sp)
    80000fc4:	6c02                	ld	s8,0(sp)
    80000fc6:	6161                	addi	sp,sp,80
    80000fc8:	8082                	ret
      panic("kalloc");
    80000fca:	00007517          	auipc	a0,0x7
    80000fce:	20e50513          	addi	a0,a0,526 # 800081d8 <etext+0x1d8>
    80000fd2:	733040ef          	jal	80005f04 <panic>

0000000080000fd6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000fd6:	7139                	addi	sp,sp,-64
    80000fd8:	fc06                	sd	ra,56(sp)
    80000fda:	f822                	sd	s0,48(sp)
    80000fdc:	f426                	sd	s1,40(sp)
    80000fde:	f04a                	sd	s2,32(sp)
    80000fe0:	ec4e                	sd	s3,24(sp)
    80000fe2:	e852                	sd	s4,16(sp)
    80000fe4:	e456                	sd	s5,8(sp)
    80000fe6:	e05a                	sd	s6,0(sp)
    80000fe8:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000fea:	00007597          	auipc	a1,0x7
    80000fee:	1f658593          	addi	a1,a1,502 # 800081e0 <etext+0x1e0>
    80000ff2:	0000a517          	auipc	a0,0xa
    80000ff6:	6be50513          	addi	a0,a0,1726 # 8000b6b0 <pid_lock>
    80000ffa:	0fc050ef          	jal	800060f6 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ffe:	00007597          	auipc	a1,0x7
    80001002:	1ea58593          	addi	a1,a1,490 # 800081e8 <etext+0x1e8>
    80001006:	0000a517          	auipc	a0,0xa
    8000100a:	6c250513          	addi	a0,a0,1730 # 8000b6c8 <wait_lock>
    8000100e:	0e8050ef          	jal	800060f6 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001012:	0000b497          	auipc	s1,0xb
    80001016:	ace48493          	addi	s1,s1,-1330 # 8000bae0 <proc>
    initlock(&p->lock, "proc");
    8000101a:	00007a97          	auipc	s5,0x7
    8000101e:	1dea8a93          	addi	s5,s5,478 # 800081f8 <etext+0x1f8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001022:	8a26                	mv	s4,s1
    80001024:	ff4df937          	lui	s2,0xff4df
    80001028:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e0d>
    8000102c:	0936                	slli	s2,s2,0xd
    8000102e:	6f590913          	addi	s2,s2,1781
    80001032:	0936                	slli	s2,s2,0xd
    80001034:	bd390913          	addi	s2,s2,-1069
    80001038:	0932                	slli	s2,s2,0xc
    8000103a:	7a790913          	addi	s2,s2,1959
    8000103e:	010009b7          	lui	s3,0x1000
    80001042:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80001044:	09ba                	slli	s3,s3,0xe
  for (p = proc; p < &proc[NPROC]; p++) {
    80001046:	00010b17          	auipc	s6,0x10
    8000104a:	69ab0b13          	addi	s6,s6,1690 # 800116e0 <tickslock>
    initlock(&p->lock, "proc");
    8000104e:	85d6                	mv	a1,s5
    80001050:	8526                	mv	a0,s1
    80001052:	0a4050ef          	jal	800060f6 <initlock>
    p->state = UNUSED;
    80001056:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000105a:	414487b3          	sub	a5,s1,s4
    8000105e:	8791                	srai	a5,a5,0x4
    80001060:	032787b3          	mul	a5,a5,s2
    80001064:	00d7979b          	slliw	a5,a5,0xd
    80001068:	40f987b3          	sub	a5,s3,a5
    8000106c:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000106e:	17048493          	addi	s1,s1,368
    80001072:	fd649ee3          	bne	s1,s6,8000104e <procinit+0x78>
  }
}
    80001076:	70e2                	ld	ra,56(sp)
    80001078:	7442                	ld	s0,48(sp)
    8000107a:	74a2                	ld	s1,40(sp)
    8000107c:	7902                	ld	s2,32(sp)
    8000107e:	69e2                	ld	s3,24(sp)
    80001080:	6a42                	ld	s4,16(sp)
    80001082:	6aa2                	ld	s5,8(sp)
    80001084:	6b02                	ld	s6,0(sp)
    80001086:	6121                	addi	sp,sp,64
    80001088:	8082                	ret

000000008000108a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000108a:	1141                	addi	sp,sp,-16
    8000108c:	e406                	sd	ra,8(sp)
    8000108e:	e022                	sd	s0,0(sp)
    80001090:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001092:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001094:	2501                	sext.w	a0,a0
    80001096:	60a2                	ld	ra,8(sp)
    80001098:	6402                	ld	s0,0(sp)
    8000109a:	0141                	addi	sp,sp,16
    8000109c:	8082                	ret

000000008000109e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    8000109e:	1141                	addi	sp,sp,-16
    800010a0:	e406                	sd	ra,8(sp)
    800010a2:	e022                	sd	s0,0(sp)
    800010a4:	0800                	addi	s0,sp,16
    800010a6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800010a8:	2781                	sext.w	a5,a5
    800010aa:	079e                	slli	a5,a5,0x7
  return c;
}
    800010ac:	0000a517          	auipc	a0,0xa
    800010b0:	63450513          	addi	a0,a0,1588 # 8000b6e0 <cpus>
    800010b4:	953e                	add	a0,a0,a5
    800010b6:	60a2                	ld	ra,8(sp)
    800010b8:	6402                	ld	s0,0(sp)
    800010ba:	0141                	addi	sp,sp,16
    800010bc:	8082                	ret

00000000800010be <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800010be:	1101                	addi	sp,sp,-32
    800010c0:	ec06                	sd	ra,24(sp)
    800010c2:	e822                	sd	s0,16(sp)
    800010c4:	e426                	sd	s1,8(sp)
    800010c6:	1000                	addi	s0,sp,32
  push_off();
    800010c8:	074050ef          	jal	8000613c <push_off>
    800010cc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800010ce:	2781                	sext.w	a5,a5
    800010d0:	079e                	slli	a5,a5,0x7
    800010d2:	0000a717          	auipc	a4,0xa
    800010d6:	5de70713          	addi	a4,a4,1502 # 8000b6b0 <pid_lock>
    800010da:	97ba                	add	a5,a5,a4
    800010dc:	7b9c                	ld	a5,48(a5)
    800010de:	84be                	mv	s1,a5
  pop_off();
    800010e0:	0d6050ef          	jal	800061b6 <pop_off>
  return p;
}
    800010e4:	8526                	mv	a0,s1
    800010e6:	60e2                	ld	ra,24(sp)
    800010e8:	6442                	ld	s0,16(sp)
    800010ea:	64a2                	ld	s1,8(sp)
    800010ec:	6105                	addi	sp,sp,32
    800010ee:	8082                	ret

00000000800010f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010f0:	7179                	addi	sp,sp,-48
    800010f2:	f406                	sd	ra,40(sp)
    800010f4:	f022                	sd	s0,32(sp)
    800010f6:	ec26                	sd	s1,24(sp)
    800010f8:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    800010fa:	fc5ff0ef          	jal	800010be <myproc>
    800010fe:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001100:	0fe050ef          	jal	800061fe <release>

  if (__atomic_load_n(&first, __ATOMIC_ACQUIRE)) {
    80001104:	0000a797          	auipc	a5,0xa
    80001108:	52c78793          	addi	a5,a5,1324 # 8000b630 <first.1>
    8000110c:	439c                	lw	a5,0(a5)
    8000110e:	0230000f          	fence	r,rw
    80001112:	2781                	sext.w	a5,a5
    80001114:	c3a1                	beqz	a5,80001154 <forkret+0x64>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001116:	4505                	li	a0,1
    80001118:	607010ef          	jal	80002f1e <fsinit>

    // ensure other cores see first=0.
    __atomic_store_n(&first, 0, __ATOMIC_RELEASE);
    8000111c:	0000a797          	auipc	a5,0xa
    80001120:	51478793          	addi	a5,a5,1300 # 8000b630 <first.1>
    80001124:	0310000f          	fence	rw,w
    80001128:	0007a023          	sw	zero,0(a5)

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    8000112c:	00007797          	auipc	a5,0x7
    80001130:	0d478793          	addi	a5,a5,212 # 80008200 <etext+0x200>
    80001134:	fcf43823          	sd	a5,-48(s0)
    80001138:	fc043c23          	sd	zero,-40(s0)
    8000113c:	fd040593          	addi	a1,s0,-48
    80001140:	853e                	mv	a0,a5
    80001142:	05e030ef          	jal	800041a0 <kexec>
    80001146:	6cbc                	ld	a5,88(s1)
    80001148:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000114a:	6cbc                	ld	a5,88(s1)
    8000114c:	7bb8                	ld	a4,112(a5)
    8000114e:	57fd                	li	a5,-1
    80001150:	02f70d63          	beq	a4,a5,8000118a <forkret+0x9a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001154:	385000ef          	jal	80001cd8 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001158:	68a8                	ld	a0,80(s1)
    8000115a:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000115c:	04000737          	lui	a4,0x4000
    80001160:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001162:	0732                	slli	a4,a4,0xc
    80001164:	00006797          	auipc	a5,0x6
    80001168:	f3878793          	addi	a5,a5,-200 # 8000709c <userret>
    8000116c:	00006697          	auipc	a3,0x6
    80001170:	e9468693          	addi	a3,a3,-364 # 80007000 <_trampoline>
    80001174:	8f95                	sub	a5,a5,a3
    80001176:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001178:	577d                	li	a4,-1
    8000117a:	177e                	slli	a4,a4,0x3f
    8000117c:	8d59                	or	a0,a0,a4
    8000117e:	9782                	jalr	a5
}
    80001180:	70a2                	ld	ra,40(sp)
    80001182:	7402                	ld	s0,32(sp)
    80001184:	64e2                	ld	s1,24(sp)
    80001186:	6145                	addi	sp,sp,48
    80001188:	8082                	ret
      panic("exec");
    8000118a:	00007517          	auipc	a0,0x7
    8000118e:	07e50513          	addi	a0,a0,126 # 80008208 <etext+0x208>
    80001192:	573040ef          	jal	80005f04 <panic>

0000000080001196 <allocpid>:
{
    80001196:	1101                	addi	sp,sp,-32
    80001198:	ec06                	sd	ra,24(sp)
    8000119a:	e822                	sd	s0,16(sp)
    8000119c:	e426                	sd	s1,8(sp)
    8000119e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011a0:	0000a517          	auipc	a0,0xa
    800011a4:	51050513          	addi	a0,a0,1296 # 8000b6b0 <pid_lock>
    800011a8:	7cf040ef          	jal	80006176 <acquire>
  pid = nextpid;
    800011ac:	0000a797          	auipc	a5,0xa
    800011b0:	48878793          	addi	a5,a5,1160 # 8000b634 <nextpid>
    800011b4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011b6:	0014871b          	addiw	a4,s1,1
    800011ba:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011bc:	0000a517          	auipc	a0,0xa
    800011c0:	4f450513          	addi	a0,a0,1268 # 8000b6b0 <pid_lock>
    800011c4:	03a050ef          	jal	800061fe <release>
}
    800011c8:	8526                	mv	a0,s1
    800011ca:	60e2                	ld	ra,24(sp)
    800011cc:	6442                	ld	s0,16(sp)
    800011ce:	64a2                	ld	s1,8(sp)
    800011d0:	6105                	addi	sp,sp,32
    800011d2:	8082                	ret

00000000800011d4 <proc_pagetable>:
{
    800011d4:	1101                	addi	sp,sp,-32
    800011d6:	ec06                	sd	ra,24(sp)
    800011d8:	e822                	sd	s0,16(sp)
    800011da:	e426                	sd	s1,8(sp)
    800011dc:	e04a                	sd	s2,0(sp)
    800011de:	1000                	addi	s0,sp,32
    800011e0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800011e2:	f70ff0ef          	jal	80000952 <uvmcreate>
    800011e6:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011e8:	c929                	beqz	a0,8000123a <proc_pagetable+0x66>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800011ea:	4729                	li	a4,10
    800011ec:	00006697          	auipc	a3,0x6
    800011f0:	e1468693          	addi	a3,a3,-492 # 80007000 <_trampoline>
    800011f4:	6605                	lui	a2,0x1
    800011f6:	040005b7          	lui	a1,0x4000
    800011fa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011fc:	05b2                	slli	a1,a1,0xc
    800011fe:	dacff0ef          	jal	800007aa <mappages>
    80001202:	04054363          	bltz	a0,80001248 <proc_pagetable+0x74>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001206:	4719                	li	a4,6
    80001208:	05893683          	ld	a3,88(s2)
    8000120c:	6605                	lui	a2,0x1
    8000120e:	020005b7          	lui	a1,0x2000
    80001212:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001214:	05b6                	slli	a1,a1,0xd
    80001216:	8526                	mv	a0,s1
    80001218:	d92ff0ef          	jal	800007aa <mappages>
    8000121c:	02054c63          	bltz	a0,80001254 <proc_pagetable+0x80>
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usyscall), PTE_R | PTE_U) < 0){
    80001220:	4749                	li	a4,18
    80001222:	16893683          	ld	a3,360(s2)
    80001226:	6605                	lui	a2,0x1
    80001228:	040005b7          	lui	a1,0x4000
    8000122c:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000122e:	05b2                	slli	a1,a1,0xc
    80001230:	8526                	mv	a0,s1
    80001232:	d78ff0ef          	jal	800007aa <mappages>
    80001236:	02054e63          	bltz	a0,80001272 <proc_pagetable+0x9e>
}
    8000123a:	8526                	mv	a0,s1
    8000123c:	60e2                	ld	ra,24(sp)
    8000123e:	6442                	ld	s0,16(sp)
    80001240:	64a2                	ld	s1,8(sp)
    80001242:	6902                	ld	s2,0(sp)
    80001244:	6105                	addi	sp,sp,32
    80001246:	8082                	ret
    uvmfree(pagetable, 0);
    80001248:	4581                	li	a1,0
    8000124a:	8526                	mv	a0,s1
    8000124c:	91dff0ef          	jal	80000b68 <uvmfree>
    return 0;
    80001250:	4481                	li	s1,0
    80001252:	b7e5                	j	8000123a <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001254:	4681                	li	a3,0
    80001256:	4605                	li	a2,1
    80001258:	040005b7          	lui	a1,0x4000
    8000125c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000125e:	05b2                	slli	a1,a1,0xc
    80001260:	8526                	mv	a0,s1
    80001262:	f16ff0ef          	jal	80000978 <uvmunmap>
    uvmfree(pagetable, 0);
    80001266:	4581                	li	a1,0
    80001268:	8526                	mv	a0,s1
    8000126a:	8ffff0ef          	jal	80000b68 <uvmfree>
    return 0;
    8000126e:	4481                	li	s1,0
    80001270:	b7e9                	j	8000123a <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001272:	4681                	li	a3,0
    80001274:	4605                	li	a2,1
    80001276:	040005b7          	lui	a1,0x4000
    8000127a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000127c:	05b2                	slli	a1,a1,0xc
    8000127e:	8526                	mv	a0,s1
    80001280:	ef8ff0ef          	jal	80000978 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001284:	4681                	li	a3,0
    80001286:	4605                	li	a2,1
    80001288:	020005b7          	lui	a1,0x2000
    8000128c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000128e:	05b6                	slli	a1,a1,0xd
    80001290:	8526                	mv	a0,s1
    80001292:	ee6ff0ef          	jal	80000978 <uvmunmap>
    uvmfree(pagetable, 0);
    80001296:	4581                	li	a1,0
    80001298:	8526                	mv	a0,s1
    8000129a:	8cfff0ef          	jal	80000b68 <uvmfree>
    return 0;
    8000129e:	4481                	li	s1,0
    800012a0:	bf69                	j	8000123a <proc_pagetable+0x66>

00000000800012a2 <proc_freepagetable>:
{
    800012a2:	1101                	addi	sp,sp,-32
    800012a4:	ec06                	sd	ra,24(sp)
    800012a6:	e822                	sd	s0,16(sp)
    800012a8:	e426                	sd	s1,8(sp)
    800012aa:	e04a                	sd	s2,0(sp)
    800012ac:	1000                	addi	s0,sp,32
    800012ae:	84aa                	mv	s1,a0
    800012b0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012b2:	4681                	li	a3,0
    800012b4:	4605                	li	a2,1
    800012b6:	040005b7          	lui	a1,0x4000
    800012ba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012bc:	05b2                	slli	a1,a1,0xc
    800012be:	ebaff0ef          	jal	80000978 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800012c2:	4681                	li	a3,0
    800012c4:	4605                	li	a2,1
    800012c6:	020005b7          	lui	a1,0x2000
    800012ca:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800012cc:	05b6                	slli	a1,a1,0xd
    800012ce:	8526                	mv	a0,s1
    800012d0:	ea8ff0ef          	jal	80000978 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800012d4:	4681                	li	a3,0
    800012d6:	4605                	li	a2,1
    800012d8:	040005b7          	lui	a1,0x4000
    800012dc:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800012de:	05b2                	slli	a1,a1,0xc
    800012e0:	8526                	mv	a0,s1
    800012e2:	e96ff0ef          	jal	80000978 <uvmunmap>
  uvmfree(pagetable, sz);
    800012e6:	85ca                	mv	a1,s2
    800012e8:	8526                	mv	a0,s1
    800012ea:	87fff0ef          	jal	80000b68 <uvmfree>
}
    800012ee:	60e2                	ld	ra,24(sp)
    800012f0:	6442                	ld	s0,16(sp)
    800012f2:	64a2                	ld	s1,8(sp)
    800012f4:	6902                	ld	s2,0(sp)
    800012f6:	6105                	addi	sp,sp,32
    800012f8:	8082                	ret

00000000800012fa <freeproc>:
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
    80001304:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001306:	6d28                	ld	a0,88(a0)
    80001308:	c119                	beqz	a0,8000130e <freeproc+0x14>
    kfree((void *)p->trapframe);
    8000130a:	d13fe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    8000130e:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    80001312:	1684b503          	ld	a0,360(s1)
    80001316:	c119                	beqz	a0,8000131c <freeproc+0x22>
    kfree((void*)p->usyscall);
    80001318:	d05fe0ef          	jal	8000001c <kfree>
  p->usyscall = 0;
    8000131c:	1604b423          	sd	zero,360(s1)
  if (p->pagetable)
    80001320:	68a8                	ld	a0,80(s1)
    80001322:	c501                	beqz	a0,8000132a <freeproc+0x30>
    proc_freepagetable(p->pagetable, p->sz);
    80001324:	64ac                	ld	a1,72(s1)
    80001326:	f7dff0ef          	jal	800012a2 <proc_freepagetable>
  p->pagetable = 0;
    8000132a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000132e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001332:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001336:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000133a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000133e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001342:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001346:	0004ac23          	sw	zero,24(s1)
}
    8000134a:	60e2                	ld	ra,24(sp)
    8000134c:	6442                	ld	s0,16(sp)
    8000134e:	64a2                	ld	s1,8(sp)
    80001350:	6105                	addi	sp,sp,32
    80001352:	8082                	ret

0000000080001354 <allocproc>:
{
    80001354:	1101                	addi	sp,sp,-32
    80001356:	ec06                	sd	ra,24(sp)
    80001358:	e822                	sd	s0,16(sp)
    8000135a:	e426                	sd	s1,8(sp)
    8000135c:	e04a                	sd	s2,0(sp)
    8000135e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001360:	0000a497          	auipc	s1,0xa
    80001364:	78048493          	addi	s1,s1,1920 # 8000bae0 <proc>
    80001368:	00010917          	auipc	s2,0x10
    8000136c:	37890913          	addi	s2,s2,888 # 800116e0 <tickslock>
    acquire(&p->lock);
    80001370:	8526                	mv	a0,s1
    80001372:	605040ef          	jal	80006176 <acquire>
    if (p->state == UNUSED) {
    80001376:	4c9c                	lw	a5,24(s1)
    80001378:	cb91                	beqz	a5,8000138c <allocproc+0x38>
      release(&p->lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	683040ef          	jal	800061fe <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001380:	17048493          	addi	s1,s1,368
    80001384:	ff2496e3          	bne	s1,s2,80001370 <allocproc+0x1c>
  return 0;
    80001388:	4481                	li	s1,0
    8000138a:	a889                	j	800013dc <allocproc+0x88>
  p->pid = allocpid();
    8000138c:	e0bff0ef          	jal	80001196 <allocpid>
    80001390:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001392:	4785                	li	a5,1
    80001394:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001396:	d6ffe0ef          	jal	80000104 <kalloc>
    8000139a:	892a                	mv	s2,a0
    8000139c:	eca8                	sd	a0,88(s1)
    8000139e:	c531                	beqz	a0,800013ea <allocproc+0x96>
  if ((p->usyscall = (struct usyscall *)kalloc()) == 0) {
    800013a0:	d65fe0ef          	jal	80000104 <kalloc>
    800013a4:	892a                	mv	s2,a0
    800013a6:	16a4b423          	sd	a0,360(s1)
    800013aa:	c921                	beqz	a0,800013fa <allocproc+0xa6>
   p->usyscall->pid = p->pid;
    800013ac:	589c                	lw	a5,48(s1)
    800013ae:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    800013b0:	8526                	mv	a0,s1
    800013b2:	e23ff0ef          	jal	800011d4 <proc_pagetable>
    800013b6:	892a                	mv	s2,a0
    800013b8:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800013ba:	c921                	beqz	a0,8000140a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800013bc:	07000613          	li	a2,112
    800013c0:	4581                	li	a1,0
    800013c2:	06048513          	addi	a0,s1,96
    800013c6:	d99fe0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    800013ca:	00000797          	auipc	a5,0x0
    800013ce:	d2678793          	addi	a5,a5,-730 # 800010f0 <forkret>
    800013d2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800013d4:	60bc                	ld	a5,64(s1)
    800013d6:	6705                	lui	a4,0x1
    800013d8:	97ba                	add	a5,a5,a4
    800013da:	f4bc                	sd	a5,104(s1)
}
    800013dc:	8526                	mv	a0,s1
    800013de:	60e2                	ld	ra,24(sp)
    800013e0:	6442                	ld	s0,16(sp)
    800013e2:	64a2                	ld	s1,8(sp)
    800013e4:	6902                	ld	s2,0(sp)
    800013e6:	6105                	addi	sp,sp,32
    800013e8:	8082                	ret
    freeproc(p);
    800013ea:	8526                	mv	a0,s1
    800013ec:	f0fff0ef          	jal	800012fa <freeproc>
    release(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	60d040ef          	jal	800061fe <release>
    return 0;
    800013f6:	84ca                	mv	s1,s2
    800013f8:	b7d5                	j	800013dc <allocproc+0x88>
    freeproc(p);
    800013fa:	8526                	mv	a0,s1
    800013fc:	effff0ef          	jal	800012fa <freeproc>
    release(&p->lock);
    80001400:	8526                	mv	a0,s1
    80001402:	5fd040ef          	jal	800061fe <release>
    return 0;
    80001406:	84ca                	mv	s1,s2
    80001408:	bfd1                	j	800013dc <allocproc+0x88>
    freeproc(p);
    8000140a:	8526                	mv	a0,s1
    8000140c:	eefff0ef          	jal	800012fa <freeproc>
    release(&p->lock);
    80001410:	8526                	mv	a0,s1
    80001412:	5ed040ef          	jal	800061fe <release>
    return 0;
    80001416:	84ca                	mv	s1,s2
    80001418:	b7d1                	j	800013dc <allocproc+0x88>

000000008000141a <userinit>:
{
    8000141a:	1101                	addi	sp,sp,-32
    8000141c:	ec06                	sd	ra,24(sp)
    8000141e:	e822                	sd	s0,16(sp)
    80001420:	e426                	sd	s1,8(sp)
    80001422:	1000                	addi	s0,sp,32
  p = allocproc();
    80001424:	f31ff0ef          	jal	80001354 <allocproc>
    80001428:	84aa                	mv	s1,a0
  initproc = p;
    8000142a:	0000a797          	auipc	a5,0xa
    8000142e:	24a7b323          	sd	a0,582(a5) # 8000b670 <initproc>
  p->cwd = namei("/");
    80001432:	00007517          	auipc	a0,0x7
    80001436:	dde50513          	addi	a0,a0,-546 # 80008210 <etext+0x210>
    8000143a:	034020ef          	jal	8000346e <namei>
    8000143e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001442:	478d                	li	a5,3
    80001444:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001446:	8526                	mv	a0,s1
    80001448:	5b7040ef          	jal	800061fe <release>
}
    8000144c:	60e2                	ld	ra,24(sp)
    8000144e:	6442                	ld	s0,16(sp)
    80001450:	64a2                	ld	s1,8(sp)
    80001452:	6105                	addi	sp,sp,32
    80001454:	8082                	ret

0000000080001456 <growproc>:
{
    80001456:	1101                	addi	sp,sp,-32
    80001458:	ec06                	sd	ra,24(sp)
    8000145a:	e822                	sd	s0,16(sp)
    8000145c:	e426                	sd	s1,8(sp)
    8000145e:	e04a                	sd	s2,0(sp)
    80001460:	1000                	addi	s0,sp,32
    80001462:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001464:	c5bff0ef          	jal	800010be <myproc>
    80001468:	892a                	mv	s2,a0
  sz = p->sz;
    8000146a:	652c                	ld	a1,72(a0)
  if (n > 0) {
    8000146c:	02905963          	blez	s1,8000149e <growproc+0x48>
    if (sz + n > UTOP) {
    80001470:	00b48633          	add	a2,s1,a1
    80001474:	040007b7          	lui	a5,0x4000
    80001478:	17f5                	addi	a5,a5,-3 # 3fffffd <_entry-0x7c000003>
    8000147a:	07b2                	slli	a5,a5,0xc
    8000147c:	02c7ea63          	bltu	a5,a2,800014b0 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001480:	4691                	li	a3,4
    80001482:	6928                	ld	a0,80(a0)
    80001484:	ddeff0ef          	jal	80000a62 <uvmalloc>
    80001488:	85aa                	mv	a1,a0
    8000148a:	c50d                	beqz	a0,800014b4 <growproc+0x5e>
  p->sz = sz;
    8000148c:	04b93423          	sd	a1,72(s2)
  return 0;
    80001490:	4501                	li	a0,0
}
    80001492:	60e2                	ld	ra,24(sp)
    80001494:	6442                	ld	s0,16(sp)
    80001496:	64a2                	ld	s1,8(sp)
    80001498:	6902                	ld	s2,0(sp)
    8000149a:	6105                	addi	sp,sp,32
    8000149c:	8082                	ret
  } else if (n < 0) {
    8000149e:	fe04d7e3          	bgez	s1,8000148c <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800014a2:	00b48633          	add	a2,s1,a1
    800014a6:	6928                	ld	a0,80(a0)
    800014a8:	d76ff0ef          	jal	80000a1e <uvmdealloc>
    800014ac:	85aa                	mv	a1,a0
    800014ae:	bff9                	j	8000148c <growproc+0x36>
      return -1;
    800014b0:	557d                	li	a0,-1
    800014b2:	b7c5                	j	80001492 <growproc+0x3c>
      return -1;
    800014b4:	557d                	li	a0,-1
    800014b6:	bff1                	j	80001492 <growproc+0x3c>

00000000800014b8 <kfork>:
{
    800014b8:	7139                	addi	sp,sp,-64
    800014ba:	fc06                	sd	ra,56(sp)
    800014bc:	f822                	sd	s0,48(sp)
    800014be:	f426                	sd	s1,40(sp)
    800014c0:	e456                	sd	s5,8(sp)
    800014c2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800014c4:	bfbff0ef          	jal	800010be <myproc>
    800014c8:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800014ca:	e8bff0ef          	jal	80001354 <allocproc>
    800014ce:	0e050a63          	beqz	a0,800015c2 <kfork+0x10a>
    800014d2:	e852                	sd	s4,16(sp)
    800014d4:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800014d6:	048ab603          	ld	a2,72(s5)
    800014da:	692c                	ld	a1,80(a0)
    800014dc:	050ab503          	ld	a0,80(s5)
    800014e0:	ebaff0ef          	jal	80000b9a <uvmcopy>
    800014e4:	04054863          	bltz	a0,80001534 <kfork+0x7c>
    800014e8:	f04a                	sd	s2,32(sp)
    800014ea:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800014ec:	048ab783          	ld	a5,72(s5)
    800014f0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800014f4:	058ab683          	ld	a3,88(s5)
    800014f8:	87b6                	mv	a5,a3
    800014fa:	058a3703          	ld	a4,88(s4)
    800014fe:	12068693          	addi	a3,a3,288
    80001502:	6388                	ld	a0,0(a5)
    80001504:	678c                	ld	a1,8(a5)
    80001506:	6b90                	ld	a2,16(a5)
    80001508:	e308                	sd	a0,0(a4)
    8000150a:	e70c                	sd	a1,8(a4)
    8000150c:	eb10                	sd	a2,16(a4)
    8000150e:	6f90                	ld	a2,24(a5)
    80001510:	ef10                	sd	a2,24(a4)
    80001512:	02078793          	addi	a5,a5,32
    80001516:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000151a:	fed794e3          	bne	a5,a3,80001502 <kfork+0x4a>
  np->trapframe->a0 = 0;
    8000151e:	058a3783          	ld	a5,88(s4)
    80001522:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001526:	0d0a8493          	addi	s1,s5,208
    8000152a:	0d0a0913          	addi	s2,s4,208
    8000152e:	150a8993          	addi	s3,s5,336
    80001532:	a831                	j	8000154e <kfork+0x96>
    freeproc(np);
    80001534:	8552                	mv	a0,s4
    80001536:	dc5ff0ef          	jal	800012fa <freeproc>
    release(&np->lock);
    8000153a:	8552                	mv	a0,s4
    8000153c:	4c3040ef          	jal	800061fe <release>
    return -1;
    80001540:	54fd                	li	s1,-1
    80001542:	6a42                	ld	s4,16(sp)
    80001544:	a885                	j	800015b4 <kfork+0xfc>
  for (i = 0; i < NOFILE; i++)
    80001546:	04a1                	addi	s1,s1,8
    80001548:	0921                	addi	s2,s2,8
    8000154a:	01348963          	beq	s1,s3,8000155c <kfork+0xa4>
    if (p->ofile[i])
    8000154e:	6088                	ld	a0,0(s1)
    80001550:	d97d                	beqz	a0,80001546 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001552:	56e020ef          	jal	80003ac0 <filedup>
    80001556:	00a93023          	sd	a0,0(s2)
    8000155a:	b7f5                	j	80001546 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    8000155c:	150ab503          	ld	a0,336(s5)
    80001560:	64c010ef          	jal	80002bac <idup>
    80001564:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001568:	4641                	li	a2,16
    8000156a:	158a8593          	addi	a1,s5,344
    8000156e:	158a0513          	addi	a0,s4,344
    80001572:	d41fe0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    80001576:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    8000157a:	8552                	mv	a0,s4
    8000157c:	483040ef          	jal	800061fe <release>
  acquire(&wait_lock);
    80001580:	0000a517          	auipc	a0,0xa
    80001584:	14850513          	addi	a0,a0,328 # 8000b6c8 <wait_lock>
    80001588:	3ef040ef          	jal	80006176 <acquire>
  np->parent = p;
    8000158c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001590:	0000a517          	auipc	a0,0xa
    80001594:	13850513          	addi	a0,a0,312 # 8000b6c8 <wait_lock>
    80001598:	467040ef          	jal	800061fe <release>
  acquire(&np->lock);
    8000159c:	8552                	mv	a0,s4
    8000159e:	3d9040ef          	jal	80006176 <acquire>
  np->state = RUNNABLE;
    800015a2:	478d                	li	a5,3
    800015a4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800015a8:	8552                	mv	a0,s4
    800015aa:	455040ef          	jal	800061fe <release>
  return pid;
    800015ae:	7902                	ld	s2,32(sp)
    800015b0:	69e2                	ld	s3,24(sp)
    800015b2:	6a42                	ld	s4,16(sp)
}
    800015b4:	8526                	mv	a0,s1
    800015b6:	70e2                	ld	ra,56(sp)
    800015b8:	7442                	ld	s0,48(sp)
    800015ba:	74a2                	ld	s1,40(sp)
    800015bc:	6aa2                	ld	s5,8(sp)
    800015be:	6121                	addi	sp,sp,64
    800015c0:	8082                	ret
    return -1;
    800015c2:	54fd                	li	s1,-1
    800015c4:	bfc5                	j	800015b4 <kfork+0xfc>

00000000800015c6 <scheduler>:
{
    800015c6:	715d                	addi	sp,sp,-80
    800015c8:	e486                	sd	ra,72(sp)
    800015ca:	e0a2                	sd	s0,64(sp)
    800015cc:	fc26                	sd	s1,56(sp)
    800015ce:	f84a                	sd	s2,48(sp)
    800015d0:	f44e                	sd	s3,40(sp)
    800015d2:	f052                	sd	s4,32(sp)
    800015d4:	ec56                	sd	s5,24(sp)
    800015d6:	e85a                	sd	s6,16(sp)
    800015d8:	e45e                	sd	s7,8(sp)
    800015da:	e062                	sd	s8,0(sp)
    800015dc:	0880                	addi	s0,sp,80
    800015de:	8792                	mv	a5,tp
  int id = r_tp();
    800015e0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015e2:	00779b13          	slli	s6,a5,0x7
    800015e6:	0000a717          	auipc	a4,0xa
    800015ea:	0ca70713          	addi	a4,a4,202 # 8000b6b0 <pid_lock>
    800015ee:	975a                	add	a4,a4,s6
    800015f0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015f4:	0000a717          	auipc	a4,0xa
    800015f8:	0f470713          	addi	a4,a4,244 # 8000b6e8 <cpus+0x8>
    800015fc:	9b3a                	add	s6,s6,a4
      if (p->state == RUNNABLE) {
    800015fe:	4a0d                	li	s4,3
        p->state = RUNNING;
    80001600:	4c11                	li	s8,4
        c->proc = p;
    80001602:	0000ab97          	auipc	s7,0xa
    80001606:	0aeb8b93          	addi	s7,s7,174 # 8000b6b0 <pid_lock>
    8000160a:	079e                	slli	a5,a5,0x7
    8000160c:	00fb8ab3          	add	s5,s7,a5
    80001610:	a889                	j	80001662 <scheduler+0x9c>
      release(&p->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	3eb040ef          	jal	800061fe <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001618:	17048493          	addi	s1,s1,368
    8000161c:	03348c63          	beq	s1,s3,80001654 <scheduler+0x8e>
      acquire(&p->lock);
    80001620:	8526                	mv	a0,s1
    80001622:	355040ef          	jal	80006176 <acquire>
      if (p->state != UNUSED) {
    80001626:	4c9c                	lw	a5,24(s1)
    80001628:	d7ed                	beqz	a5,80001612 <scheduler+0x4c>
        nproc++;
    8000162a:	2905                	addiw	s2,s2,1
      if (p->state == RUNNABLE) {
    8000162c:	ff4793e3          	bne	a5,s4,80001612 <scheduler+0x4c>
        p->state = RUNNING;
    80001630:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001634:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    80001638:	06048593          	addi	a1,s1,96
    8000163c:	855a                	mv	a0,s6
    8000163e:	5f0000ef          	jal	80001c2e <swtch>
    80001642:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001644:	2781                	sext.w	a5,a5
    80001646:	079e                	slli	a5,a5,0x7
    80001648:	97de                	add	a5,a5,s7
    8000164a:	0a07a623          	sw	zero,172(a5)
        c->proc = 0;
    8000164e:	020ab823          	sd	zero,48(s5)
    80001652:	b7c1                	j	80001612 <scheduler+0x4c>
    if (nproc <= 2) { // only init and sh exist
    80001654:	4789                	li	a5,2
    80001656:	0127c663          	blt	a5,s2,80001662 <scheduler+0x9c>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    8000165a:	1007a073          	csrs	sstatus,a5
      asm volatile("wfi");
    8000165e:	10500073          	wfi
    80001662:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001666:	10017073          	csrci	sstatus,2
    int nproc = 0;
    8000166a:	4901                	li	s2,0
    for (p = proc; p < &proc[NPROC]; p++) {
    8000166c:	0000a497          	auipc	s1,0xa
    80001670:	47448493          	addi	s1,s1,1140 # 8000bae0 <proc>
    80001674:	00010997          	auipc	s3,0x10
    80001678:	06c98993          	addi	s3,s3,108 # 800116e0 <tickslock>
    8000167c:	b755                	j	80001620 <scheduler+0x5a>

000000008000167e <sched>:
{
    8000167e:	7179                	addi	sp,sp,-48
    80001680:	f406                	sd	ra,40(sp)
    80001682:	f022                	sd	s0,32(sp)
    80001684:	ec26                	sd	s1,24(sp)
    80001686:	e84a                	sd	s2,16(sp)
    80001688:	e44e                	sd	s3,8(sp)
    8000168a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000168c:	a33ff0ef          	jal	800010be <myproc>
    80001690:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001692:	27f040ef          	jal	80006110 <holding>
    80001696:	c935                	beqz	a0,8000170a <sched+0x8c>
  asm volatile("mv %0, tp" : "=r"(x));
    80001698:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000169a:	2781                	sext.w	a5,a5
    8000169c:	079e                	slli	a5,a5,0x7
    8000169e:	0000a717          	auipc	a4,0xa
    800016a2:	01270713          	addi	a4,a4,18 # 8000b6b0 <pid_lock>
    800016a6:	97ba                	add	a5,a5,a4
    800016a8:	0a87a703          	lw	a4,168(a5)
    800016ac:	4785                	li	a5,1
    800016ae:	06f71463          	bne	a4,a5,80001716 <sched+0x98>
  if (p->state == RUNNING)
    800016b2:	4c98                	lw	a4,24(s1)
    800016b4:	4791                	li	a5,4
    800016b6:	06f70663          	beq	a4,a5,80001722 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800016ba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800016be:	8b89                	andi	a5,a5,2
  if (intr_get())
    800016c0:	e7bd                	bnez	a5,8000172e <sched+0xb0>
  asm volatile("mv %0, tp" : "=r"(x));
    800016c2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800016c4:	0000a917          	auipc	s2,0xa
    800016c8:	fec90913          	addi	s2,s2,-20 # 8000b6b0 <pid_lock>
    800016cc:	2781                	sext.w	a5,a5
    800016ce:	079e                	slli	a5,a5,0x7
    800016d0:	97ca                	add	a5,a5,s2
    800016d2:	0ac7a983          	lw	s3,172(a5)
    800016d6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016d8:	2781                	sext.w	a5,a5
    800016da:	079e                	slli	a5,a5,0x7
    800016dc:	07a1                	addi	a5,a5,8
    800016de:	0000a597          	auipc	a1,0xa
    800016e2:	00258593          	addi	a1,a1,2 # 8000b6e0 <cpus>
    800016e6:	95be                	add	a1,a1,a5
    800016e8:	06048513          	addi	a0,s1,96
    800016ec:	542000ef          	jal	80001c2e <swtch>
    800016f0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016f2:	2781                	sext.w	a5,a5
    800016f4:	079e                	slli	a5,a5,0x7
    800016f6:	993e                	add	s2,s2,a5
    800016f8:	0b392623          	sw	s3,172(s2)
}
    800016fc:	70a2                	ld	ra,40(sp)
    800016fe:	7402                	ld	s0,32(sp)
    80001700:	64e2                	ld	s1,24(sp)
    80001702:	6942                	ld	s2,16(sp)
    80001704:	69a2                	ld	s3,8(sp)
    80001706:	6145                	addi	sp,sp,48
    80001708:	8082                	ret
    panic("sched p->lock");
    8000170a:	00007517          	auipc	a0,0x7
    8000170e:	b0e50513          	addi	a0,a0,-1266 # 80008218 <etext+0x218>
    80001712:	7f2040ef          	jal	80005f04 <panic>
    panic("sched locks");
    80001716:	00007517          	auipc	a0,0x7
    8000171a:	b1250513          	addi	a0,a0,-1262 # 80008228 <etext+0x228>
    8000171e:	7e6040ef          	jal	80005f04 <panic>
    panic("sched RUNNING");
    80001722:	00007517          	auipc	a0,0x7
    80001726:	b1650513          	addi	a0,a0,-1258 # 80008238 <etext+0x238>
    8000172a:	7da040ef          	jal	80005f04 <panic>
    panic("sched interruptible");
    8000172e:	00007517          	auipc	a0,0x7
    80001732:	b1a50513          	addi	a0,a0,-1254 # 80008248 <etext+0x248>
    80001736:	7ce040ef          	jal	80005f04 <panic>

000000008000173a <yield>:
{
    8000173a:	1101                	addi	sp,sp,-32
    8000173c:	ec06                	sd	ra,24(sp)
    8000173e:	e822                	sd	s0,16(sp)
    80001740:	e426                	sd	s1,8(sp)
    80001742:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001744:	97bff0ef          	jal	800010be <myproc>
    80001748:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000174a:	22d040ef          	jal	80006176 <acquire>
  p->state = RUNNABLE;
    8000174e:	478d                	li	a5,3
    80001750:	cc9c                	sw	a5,24(s1)
  sched();
    80001752:	f2dff0ef          	jal	8000167e <sched>
  release(&p->lock);
    80001756:	8526                	mv	a0,s1
    80001758:	2a7040ef          	jal	800061fe <release>
}
    8000175c:	60e2                	ld	ra,24(sp)
    8000175e:	6442                	ld	s0,16(sp)
    80001760:	64a2                	ld	s1,8(sp)
    80001762:	6105                	addi	sp,sp,32
    80001764:	8082                	ret

0000000080001766 <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80001766:	1101                	addi	sp,sp,-32
    80001768:	ec06                	sd	ra,24(sp)
    8000176a:	e822                	sd	s0,16(sp)
    8000176c:	e426                	sd	s1,8(sp)
    8000176e:	e04a                	sd	s2,0(sp)
    80001770:	1000                	addi	s0,sp,32
    80001772:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001774:	94bff0ef          	jal	800010be <myproc>
    80001778:	892a                	mv	s2,a0

  acquire(&p->lock);
    8000177a:	1fd040ef          	jal	80006176 <acquire>
  if (chan == 0)
    8000177e:	cc81                	beqz	s1,80001796 <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80001780:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80001784:	854a                	mv	a0,s2
    80001786:	279040ef          	jal	800061fe <release>
}
    8000178a:	60e2                	ld	ra,24(sp)
    8000178c:	6442                	ld	s0,16(sp)
    8000178e:	64a2                	ld	s1,8(sp)
    80001790:	6902                	ld	s2,0(sp)
    80001792:	6105                	addi	sp,sp,32
    80001794:	8082                	ret
    panic("sleep_prepare: zero chan");
    80001796:	00007517          	auipc	a0,0x7
    8000179a:	aca50513          	addi	a0,a0,-1334 # 80008260 <etext+0x260>
    8000179e:	766040ef          	jal	80005f04 <panic>

00000000800017a2 <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    800017a2:	1101                	addi	sp,sp,-32
    800017a4:	ec06                	sd	ra,24(sp)
    800017a6:	e822                	sd	s0,16(sp)
    800017a8:	e426                	sd	s1,8(sp)
    800017aa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800017ac:	913ff0ef          	jal	800010be <myproc>
    800017b0:	84aa                	mv	s1,a0

  acquire(&p->lock);
    800017b2:	1c5040ef          	jal	80006176 <acquire>
  if (p->chan != 0) {
    800017b6:	709c                	ld	a5,32(s1)
    800017b8:	c789                	beqz	a5,800017c2 <sleep+0x20>
    p->state = SLEEPING;
    800017ba:	4789                	li	a5,2
    800017bc:	cc9c                	sw	a5,24(s1)
    sched();
    800017be:	ec1ff0ef          	jal	8000167e <sched>
  }
  release(&p->lock);
    800017c2:	8526                	mv	a0,s1
    800017c4:	23b040ef          	jal	800061fe <release>
}
    800017c8:	60e2                	ld	ra,24(sp)
    800017ca:	6442                	ld	s0,16(sp)
    800017cc:	64a2                	ld	s1,8(sp)
    800017ce:	6105                	addi	sp,sp,32
    800017d0:	8082                	ret

00000000800017d2 <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    800017d2:	7139                	addi	sp,sp,-64
    800017d4:	fc06                	sd	ra,56(sp)
    800017d6:	f822                	sd	s0,48(sp)
    800017d8:	f426                	sd	s1,40(sp)
    800017da:	f04a                	sd	s2,32(sp)
    800017dc:	ec4e                	sd	s3,24(sp)
    800017de:	e852                	sd	s4,16(sp)
    800017e0:	e456                	sd	s5,8(sp)
    800017e2:	0080                	addi	s0,sp,64
    800017e4:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800017e6:	0000a497          	auipc	s1,0xa
    800017ea:	2fa48493          	addi	s1,s1,762 # 8000bae0 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    800017ee:	4a09                	li	s4,2
        p->state = RUNNABLE;
    800017f0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800017f2:	00010997          	auipc	s3,0x10
    800017f6:	eee98993          	addi	s3,s3,-274 # 800116e0 <tickslock>
    800017fa:	a801                	j	8000180a <wakeup+0x38>
      }
    }
    release(&p->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	201040ef          	jal	800061fe <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001802:	17048493          	addi	s1,s1,368
    80001806:	03348063          	beq	s1,s3,80001826 <wakeup+0x54>
    acquire(&p->lock);
    8000180a:	8526                	mv	a0,s1
    8000180c:	16b040ef          	jal	80006176 <acquire>
    if (p->chan == chan) {
    80001810:	709c                	ld	a5,32(s1)
    80001812:	ff2795e3          	bne	a5,s2,800017fc <wakeup+0x2a>
      p->chan = 0;
    80001816:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    8000181a:	4c9c                	lw	a5,24(s1)
    8000181c:	ff4790e3          	bne	a5,s4,800017fc <wakeup+0x2a>
        p->state = RUNNABLE;
    80001820:	0154ac23          	sw	s5,24(s1)
    80001824:	bfe1                	j	800017fc <wakeup+0x2a>
  }
}
    80001826:	70e2                	ld	ra,56(sp)
    80001828:	7442                	ld	s0,48(sp)
    8000182a:	74a2                	ld	s1,40(sp)
    8000182c:	7902                	ld	s2,32(sp)
    8000182e:	69e2                	ld	s3,24(sp)
    80001830:	6a42                	ld	s4,16(sp)
    80001832:	6aa2                	ld	s5,8(sp)
    80001834:	6121                	addi	sp,sp,64
    80001836:	8082                	ret

0000000080001838 <reparent>:
{
    80001838:	7179                	addi	sp,sp,-48
    8000183a:	f406                	sd	ra,40(sp)
    8000183c:	f022                	sd	s0,32(sp)
    8000183e:	ec26                	sd	s1,24(sp)
    80001840:	e84a                	sd	s2,16(sp)
    80001842:	e44e                	sd	s3,8(sp)
    80001844:	e052                	sd	s4,0(sp)
    80001846:	1800                	addi	s0,sp,48
    80001848:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000184a:	0000a497          	auipc	s1,0xa
    8000184e:	29648493          	addi	s1,s1,662 # 8000bae0 <proc>
      pp->parent = initproc;
    80001852:	0000aa17          	auipc	s4,0xa
    80001856:	e1ea0a13          	addi	s4,s4,-482 # 8000b670 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000185a:	00010997          	auipc	s3,0x10
    8000185e:	e8698993          	addi	s3,s3,-378 # 800116e0 <tickslock>
    80001862:	a029                	j	8000186c <reparent+0x34>
    80001864:	17048493          	addi	s1,s1,368
    80001868:	01348b63          	beq	s1,s3,8000187e <reparent+0x46>
    if (pp->parent == p) {
    8000186c:	7c9c                	ld	a5,56(s1)
    8000186e:	ff279be3          	bne	a5,s2,80001864 <reparent+0x2c>
      pp->parent = initproc;
    80001872:	000a3503          	ld	a0,0(s4)
    80001876:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001878:	f5bff0ef          	jal	800017d2 <wakeup>
    8000187c:	b7e5                	j	80001864 <reparent+0x2c>
}
    8000187e:	70a2                	ld	ra,40(sp)
    80001880:	7402                	ld	s0,32(sp)
    80001882:	64e2                	ld	s1,24(sp)
    80001884:	6942                	ld	s2,16(sp)
    80001886:	69a2                	ld	s3,8(sp)
    80001888:	6a02                	ld	s4,0(sp)
    8000188a:	6145                	addi	sp,sp,48
    8000188c:	8082                	ret

000000008000188e <kexit>:
{
    8000188e:	7179                	addi	sp,sp,-48
    80001890:	f406                	sd	ra,40(sp)
    80001892:	f022                	sd	s0,32(sp)
    80001894:	ec26                	sd	s1,24(sp)
    80001896:	e84a                	sd	s2,16(sp)
    80001898:	e44e                	sd	s3,8(sp)
    8000189a:	e052                	sd	s4,0(sp)
    8000189c:	1800                	addi	s0,sp,48
    8000189e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018a0:	81fff0ef          	jal	800010be <myproc>
    800018a4:	89aa                	mv	s3,a0
  if (p == initproc)
    800018a6:	0000a797          	auipc	a5,0xa
    800018aa:	dca7b783          	ld	a5,-566(a5) # 8000b670 <initproc>
    800018ae:	0d050493          	addi	s1,a0,208
    800018b2:	15050913          	addi	s2,a0,336
    800018b6:	00a79b63          	bne	a5,a0,800018cc <kexit+0x3e>
    panic("init exiting");
    800018ba:	00007517          	auipc	a0,0x7
    800018be:	9c650513          	addi	a0,a0,-1594 # 80008280 <etext+0x280>
    800018c2:	642040ef          	jal	80005f04 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    800018c6:	04a1                	addi	s1,s1,8
    800018c8:	01248963          	beq	s1,s2,800018da <kexit+0x4c>
    if (p->ofile[fd]) {
    800018cc:	6088                	ld	a0,0(s1)
    800018ce:	dd65                	beqz	a0,800018c6 <kexit+0x38>
      fileclose(f);
    800018d0:	236020ef          	jal	80003b06 <fileclose>
      p->ofile[fd] = 0;
    800018d4:	0004b023          	sd	zero,0(s1)
    800018d8:	b7fd                	j	800018c6 <kexit+0x38>
  begin_op();
    800018da:	573010ef          	jal	8000364c <begin_op>
  iput(p->cwd);
    800018de:	1509b503          	ld	a0,336(s3)
    800018e2:	482010ef          	jal	80002d64 <iput>
  end_op();
    800018e6:	5f3010ef          	jal	800036d8 <end_op>
  p->cwd = 0;
    800018ea:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018ee:	0000a517          	auipc	a0,0xa
    800018f2:	dda50513          	addi	a0,a0,-550 # 8000b6c8 <wait_lock>
    800018f6:	081040ef          	jal	80006176 <acquire>
  reparent(p);
    800018fa:	854e                	mv	a0,s3
    800018fc:	f3dff0ef          	jal	80001838 <reparent>
  wakeup(p->parent);
    80001900:	0389b503          	ld	a0,56(s3)
    80001904:	ecfff0ef          	jal	800017d2 <wakeup>
  acquire(&p->lock);
    80001908:	854e                	mv	a0,s3
    8000190a:	06d040ef          	jal	80006176 <acquire>
  p->xstate = status;
    8000190e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001912:	4795                	li	a5,5
    80001914:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001918:	0000a517          	auipc	a0,0xa
    8000191c:	db050513          	addi	a0,a0,-592 # 8000b6c8 <wait_lock>
    80001920:	0df040ef          	jal	800061fe <release>
  sched();
    80001924:	d5bff0ef          	jal	8000167e <sched>
  panic("zombie exit");
    80001928:	00007517          	auipc	a0,0x7
    8000192c:	96850513          	addi	a0,a0,-1688 # 80008290 <etext+0x290>
    80001930:	5d4040ef          	jal	80005f04 <panic>

0000000080001934 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001934:	7179                	addi	sp,sp,-48
    80001936:	f406                	sd	ra,40(sp)
    80001938:	f022                	sd	s0,32(sp)
    8000193a:	ec26                	sd	s1,24(sp)
    8000193c:	e84a                	sd	s2,16(sp)
    8000193e:	e44e                	sd	s3,8(sp)
    80001940:	1800                	addi	s0,sp,48
    80001942:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001944:	0000a497          	auipc	s1,0xa
    80001948:	19c48493          	addi	s1,s1,412 # 8000bae0 <proc>
    8000194c:	00010997          	auipc	s3,0x10
    80001950:	d9498993          	addi	s3,s3,-620 # 800116e0 <tickslock>
    acquire(&p->lock);
    80001954:	8526                	mv	a0,s1
    80001956:	021040ef          	jal	80006176 <acquire>
    if (p->pid == pid) {
    8000195a:	589c                	lw	a5,48(s1)
    8000195c:	01278b63          	beq	a5,s2,80001972 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001960:	8526                	mv	a0,s1
    80001962:	09d040ef          	jal	800061fe <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001966:	17048493          	addi	s1,s1,368
    8000196a:	ff3495e3          	bne	s1,s3,80001954 <kkill+0x20>
  }
  return -1;
    8000196e:	557d                	li	a0,-1
    80001970:	a819                	j	80001986 <kkill+0x52>
      p->killed = 1;
    80001972:	4785                	li	a5,1
    80001974:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001976:	4c98                	lw	a4,24(s1)
    80001978:	4789                	li	a5,2
    8000197a:	00f70d63          	beq	a4,a5,80001994 <kkill+0x60>
      release(&p->lock);
    8000197e:	8526                	mv	a0,s1
    80001980:	07f040ef          	jal	800061fe <release>
      return 0;
    80001984:	4501                	li	a0,0
}
    80001986:	70a2                	ld	ra,40(sp)
    80001988:	7402                	ld	s0,32(sp)
    8000198a:	64e2                	ld	s1,24(sp)
    8000198c:	6942                	ld	s2,16(sp)
    8000198e:	69a2                	ld	s3,8(sp)
    80001990:	6145                	addi	sp,sp,48
    80001992:	8082                	ret
        p->state = RUNNABLE;
    80001994:	478d                	li	a5,3
    80001996:	cc9c                	sw	a5,24(s1)
    80001998:	b7dd                	j	8000197e <kkill+0x4a>

000000008000199a <setkilled>:

void
setkilled(struct proc *p)
{
    8000199a:	1101                	addi	sp,sp,-32
    8000199c:	ec06                	sd	ra,24(sp)
    8000199e:	e822                	sd	s0,16(sp)
    800019a0:	e426                	sd	s1,8(sp)
    800019a2:	1000                	addi	s0,sp,32
    800019a4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019a6:	7d0040ef          	jal	80006176 <acquire>
  p->killed = 1;
    800019aa:	4785                	li	a5,1
    800019ac:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019ae:	8526                	mv	a0,s1
    800019b0:	04f040ef          	jal	800061fe <release>
}
    800019b4:	60e2                	ld	ra,24(sp)
    800019b6:	6442                	ld	s0,16(sp)
    800019b8:	64a2                	ld	s1,8(sp)
    800019ba:	6105                	addi	sp,sp,32
    800019bc:	8082                	ret

00000000800019be <killed>:

int
killed(struct proc *p)
{
    800019be:	1101                	addi	sp,sp,-32
    800019c0:	ec06                	sd	ra,24(sp)
    800019c2:	e822                	sd	s0,16(sp)
    800019c4:	e426                	sd	s1,8(sp)
    800019c6:	e04a                	sd	s2,0(sp)
    800019c8:	1000                	addi	s0,sp,32
    800019ca:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800019cc:	7aa040ef          	jal	80006176 <acquire>
  k = p->killed;
    800019d0:	549c                	lw	a5,40(s1)
    800019d2:	893e                	mv	s2,a5
  release(&p->lock);
    800019d4:	8526                	mv	a0,s1
    800019d6:	029040ef          	jal	800061fe <release>
  return k;
}
    800019da:	854a                	mv	a0,s2
    800019dc:	60e2                	ld	ra,24(sp)
    800019de:	6442                	ld	s0,16(sp)
    800019e0:	64a2                	ld	s1,8(sp)
    800019e2:	6902                	ld	s2,0(sp)
    800019e4:	6105                	addi	sp,sp,32
    800019e6:	8082                	ret

00000000800019e8 <kwait>:
{
    800019e8:	715d                	addi	sp,sp,-80
    800019ea:	e486                	sd	ra,72(sp)
    800019ec:	e0a2                	sd	s0,64(sp)
    800019ee:	fc26                	sd	s1,56(sp)
    800019f0:	f84a                	sd	s2,48(sp)
    800019f2:	f44e                	sd	s3,40(sp)
    800019f4:	f052                	sd	s4,32(sp)
    800019f6:	ec56                	sd	s5,24(sp)
    800019f8:	e85a                	sd	s6,16(sp)
    800019fa:	e45e                	sd	s7,8(sp)
    800019fc:	0880                	addi	s0,sp,80
    800019fe:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001a00:	ebeff0ef          	jal	800010be <myproc>
    80001a04:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a06:	0000a517          	auipc	a0,0xa
    80001a0a:	cc250513          	addi	a0,a0,-830 # 8000b6c8 <wait_lock>
    80001a0e:	768040ef          	jal	80006176 <acquire>
        if (pp->state == ZOMBIE) {
    80001a12:	4a15                	li	s4,5
        havekids = 1;
    80001a14:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001a16:	00010997          	auipc	s3,0x10
    80001a1a:	cca98993          	addi	s3,s3,-822 # 800116e0 <tickslock>
    release(&wait_lock);
    80001a1e:	0000ab17          	auipc	s6,0xa
    80001a22:	caab0b13          	addi	s6,s6,-854 # 8000b6c8 <wait_lock>
    80001a26:	a845                	j	80001ad6 <kwait+0xee>
          pid = pp->pid;
    80001a28:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    80001a2c:	000b8e63          	beqz	s7,80001a48 <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    80001a30:	4711                	li	a4,4
    80001a32:	02c48693          	addi	a3,s1,44
    80001a36:	865e                	mv	a2,s7
    80001a38:	04893583          	ld	a1,72(s2)
    80001a3c:	05093503          	ld	a0,80(s2)
    80001a40:	ab6ff0ef          	jal	80000cf6 <copyout>
          if (addr != 0 &&
    80001a44:	02054c63          	bltz	a0,80001a7c <kwait+0x94>
          pp->parent = 0;
    80001a48:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	8adff0ef          	jal	800012fa <freeproc>
          release(&pp->lock);
    80001a52:	8526                	mv	a0,s1
    80001a54:	7aa040ef          	jal	800061fe <release>
          release(&wait_lock);
    80001a58:	0000a517          	auipc	a0,0xa
    80001a5c:	c7050513          	addi	a0,a0,-912 # 8000b6c8 <wait_lock>
    80001a60:	79e040ef          	jal	800061fe <release>
}
    80001a64:	854e                	mv	a0,s3
    80001a66:	60a6                	ld	ra,72(sp)
    80001a68:	6406                	ld	s0,64(sp)
    80001a6a:	74e2                	ld	s1,56(sp)
    80001a6c:	7942                	ld	s2,48(sp)
    80001a6e:	79a2                	ld	s3,40(sp)
    80001a70:	7a02                	ld	s4,32(sp)
    80001a72:	6ae2                	ld	s5,24(sp)
    80001a74:	6b42                	ld	s6,16(sp)
    80001a76:	6ba2                	ld	s7,8(sp)
    80001a78:	6161                	addi	sp,sp,80
    80001a7a:	8082                	ret
            release(&pp->lock);
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	780040ef          	jal	800061fe <release>
            release(&wait_lock);
    80001a82:	0000a517          	auipc	a0,0xa
    80001a86:	c4650513          	addi	a0,a0,-954 # 8000b6c8 <wait_lock>
    80001a8a:	774040ef          	jal	800061fe <release>
            return -1;
    80001a8e:	59fd                	li	s3,-1
    80001a90:	bfd1                	j	80001a64 <kwait+0x7c>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001a92:	17048493          	addi	s1,s1,368
    80001a96:	03348063          	beq	s1,s3,80001ab6 <kwait+0xce>
      if (pp->parent == p) {
    80001a9a:	7c9c                	ld	a5,56(s1)
    80001a9c:	ff279be3          	bne	a5,s2,80001a92 <kwait+0xaa>
        acquire(&pp->lock);
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	6d4040ef          	jal	80006176 <acquire>
        if (pp->state == ZOMBIE) {
    80001aa6:	4c9c                	lw	a5,24(s1)
    80001aa8:	f94780e3          	beq	a5,s4,80001a28 <kwait+0x40>
        release(&pp->lock);
    80001aac:	8526                	mv	a0,s1
    80001aae:	750040ef          	jal	800061fe <release>
        havekids = 1;
    80001ab2:	8756                	mv	a4,s5
    80001ab4:	bff9                	j	80001a92 <kwait+0xaa>
    if (!havekids || killed(p)) {
    80001ab6:	c715                	beqz	a4,80001ae2 <kwait+0xfa>
    80001ab8:	854a                	mv	a0,s2
    80001aba:	f05ff0ef          	jal	800019be <killed>
    80001abe:	e115                	bnez	a0,80001ae2 <kwait+0xfa>
    sleep_prepare(p); //DOC: wait-sleep
    80001ac0:	854a                	mv	a0,s2
    80001ac2:	ca5ff0ef          	jal	80001766 <sleep_prepare>
    release(&wait_lock);
    80001ac6:	855a                	mv	a0,s6
    80001ac8:	736040ef          	jal	800061fe <release>
    sleep();
    80001acc:	cd7ff0ef          	jal	800017a2 <sleep>
    acquire(&wait_lock);
    80001ad0:	855a                	mv	a0,s6
    80001ad2:	6a4040ef          	jal	80006176 <acquire>
    havekids = 0;
    80001ad6:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001ad8:	0000a497          	auipc	s1,0xa
    80001adc:	00848493          	addi	s1,s1,8 # 8000bae0 <proc>
    80001ae0:	bf6d                	j	80001a9a <kwait+0xb2>
      release(&wait_lock);
    80001ae2:	0000a517          	auipc	a0,0xa
    80001ae6:	be650513          	addi	a0,a0,-1050 # 8000b6c8 <wait_lock>
    80001aea:	714040ef          	jal	800061fe <release>
      return -1;
    80001aee:	59fd                	li	s3,-1
    80001af0:	bf95                	j	80001a64 <kwait+0x7c>

0000000080001af2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001af2:	7179                	addi	sp,sp,-48
    80001af4:	f406                	sd	ra,40(sp)
    80001af6:	f022                	sd	s0,32(sp)
    80001af8:	ec26                	sd	s1,24(sp)
    80001afa:	e84a                	sd	s2,16(sp)
    80001afc:	e44e                	sd	s3,8(sp)
    80001afe:	e052                	sd	s4,0(sp)
    80001b00:	1800                	addi	s0,sp,48
    80001b02:	84aa                	mv	s1,a0
    80001b04:	8a2e                	mv	s4,a1
    80001b06:	89b2                	mv	s3,a2
    80001b08:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001b0a:	db4ff0ef          	jal	800010be <myproc>
  if (user_dst) {
    80001b0e:	c085                	beqz	s1,80001b2e <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    80001b10:	874a                	mv	a4,s2
    80001b12:	86ce                	mv	a3,s3
    80001b14:	8652                	mv	a2,s4
    80001b16:	652c                	ld	a1,72(a0)
    80001b18:	6928                	ld	a0,80(a0)
    80001b1a:	9dcff0ef          	jal	80000cf6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b1e:	70a2                	ld	ra,40(sp)
    80001b20:	7402                	ld	s0,32(sp)
    80001b22:	64e2                	ld	s1,24(sp)
    80001b24:	6942                	ld	s2,16(sp)
    80001b26:	69a2                	ld	s3,8(sp)
    80001b28:	6a02                	ld	s4,0(sp)
    80001b2a:	6145                	addi	sp,sp,48
    80001b2c:	8082                	ret
    memmove((char *)dst, src, len);
    80001b2e:	0009061b          	sext.w	a2,s2
    80001b32:	85ce                	mv	a1,s3
    80001b34:	8552                	mv	a0,s4
    80001b36:	e88fe0ef          	jal	800001be <memmove>
    return 0;
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	b7cd                	j	80001b1e <either_copyout+0x2c>

0000000080001b3e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b3e:	7179                	addi	sp,sp,-48
    80001b40:	f406                	sd	ra,40(sp)
    80001b42:	f022                	sd	s0,32(sp)
    80001b44:	ec26                	sd	s1,24(sp)
    80001b46:	e84a                	sd	s2,16(sp)
    80001b48:	e44e                	sd	s3,8(sp)
    80001b4a:	e052                	sd	s4,0(sp)
    80001b4c:	1800                	addi	s0,sp,48
    80001b4e:	8a2a                	mv	s4,a0
    80001b50:	84ae                	mv	s1,a1
    80001b52:	89b2                	mv	s3,a2
    80001b54:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001b56:	d68ff0ef          	jal	800010be <myproc>
  if (user_src) {
    80001b5a:	c085                	beqz	s1,80001b7a <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    80001b5c:	874a                	mv	a4,s2
    80001b5e:	86ce                	mv	a3,s3
    80001b60:	8652                	mv	a2,s4
    80001b62:	652c                	ld	a1,72(a0)
    80001b64:	6928                	ld	a0,80(a0)
    80001b66:	a5cff0ef          	jal	80000dc2 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001b6a:	70a2                	ld	ra,40(sp)
    80001b6c:	7402                	ld	s0,32(sp)
    80001b6e:	64e2                	ld	s1,24(sp)
    80001b70:	6942                	ld	s2,16(sp)
    80001b72:	69a2                	ld	s3,8(sp)
    80001b74:	6a02                	ld	s4,0(sp)
    80001b76:	6145                	addi	sp,sp,48
    80001b78:	8082                	ret
    memmove(dst, (char *)src, len);
    80001b7a:	0009061b          	sext.w	a2,s2
    80001b7e:	85ce                	mv	a1,s3
    80001b80:	8552                	mv	a0,s4
    80001b82:	e3cfe0ef          	jal	800001be <memmove>
    return 0;
    80001b86:	8526                	mv	a0,s1
    80001b88:	b7cd                	j	80001b6a <either_copyin+0x2c>

0000000080001b8a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b8a:	715d                	addi	sp,sp,-80
    80001b8c:	e486                	sd	ra,72(sp)
    80001b8e:	e0a2                	sd	s0,64(sp)
    80001b90:	fc26                	sd	s1,56(sp)
    80001b92:	f84a                	sd	s2,48(sp)
    80001b94:	f44e                	sd	s3,40(sp)
    80001b96:	f052                	sd	s4,32(sp)
    80001b98:	ec56                	sd	s5,24(sp)
    80001b9a:	e85a                	sd	s6,16(sp)
    80001b9c:	e45e                	sd	s7,8(sp)
    80001b9e:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    80001ba0:	00006517          	auipc	a0,0x6
    80001ba4:	47850513          	addi	a0,a0,1144 # 80008018 <etext+0x18>
    80001ba8:	032040ef          	jal	80005bda <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bac:	0000a497          	auipc	s1,0xa
    80001bb0:	08c48493          	addi	s1,s1,140 # 8000bc38 <proc+0x158>
    80001bb4:	00010917          	auipc	s2,0x10
    80001bb8:	c8490913          	addi	s2,s2,-892 # 80011838 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bbc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bbe:	00006997          	auipc	s3,0x6
    80001bc2:	6e298993          	addi	s3,s3,1762 # 800082a0 <etext+0x2a0>
    printk("%d %s %s", p->pid, state, p->name);
    80001bc6:	00006a97          	auipc	s5,0x6
    80001bca:	6e2a8a93          	addi	s5,s5,1762 # 800082a8 <etext+0x2a8>
    printk("\n");
    80001bce:	00006a17          	auipc	s4,0x6
    80001bd2:	44aa0a13          	addi	s4,s4,1098 # 80008018 <etext+0x18>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bd6:	00007b97          	auipc	s7,0x7
    80001bda:	c3ab8b93          	addi	s7,s7,-966 # 80008810 <states.0>
    80001bde:	a829                	j	80001bf8 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    80001be0:	ed86a583          	lw	a1,-296(a3)
    80001be4:	8556                	mv	a0,s5
    80001be6:	7f5030ef          	jal	80005bda <printk>
    printk("\n");
    80001bea:	8552                	mv	a0,s4
    80001bec:	7ef030ef          	jal	80005bda <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bf0:	17048493          	addi	s1,s1,368
    80001bf4:	03248263          	beq	s1,s2,80001c18 <procdump+0x8e>
    if (p->state == UNUSED)
    80001bf8:	86a6                	mv	a3,s1
    80001bfa:	ec04a783          	lw	a5,-320(s1)
    80001bfe:	dbed                	beqz	a5,80001bf0 <procdump+0x66>
      state = "???";
    80001c00:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c02:	fcfb6fe3          	bltu	s6,a5,80001be0 <procdump+0x56>
    80001c06:	02079713          	slli	a4,a5,0x20
    80001c0a:	01d75793          	srli	a5,a4,0x1d
    80001c0e:	97de                	add	a5,a5,s7
    80001c10:	6390                	ld	a2,0(a5)
    80001c12:	f679                	bnez	a2,80001be0 <procdump+0x56>
      state = "???";
    80001c14:	864e                	mv	a2,s3
    80001c16:	b7e9                	j	80001be0 <procdump+0x56>
  }
}
    80001c18:	60a6                	ld	ra,72(sp)
    80001c1a:	6406                	ld	s0,64(sp)
    80001c1c:	74e2                	ld	s1,56(sp)
    80001c1e:	7942                	ld	s2,48(sp)
    80001c20:	79a2                	ld	s3,40(sp)
    80001c22:	7a02                	ld	s4,32(sp)
    80001c24:	6ae2                	ld	s5,24(sp)
    80001c26:	6b42                	ld	s6,16(sp)
    80001c28:	6ba2                	ld	s7,8(sp)
    80001c2a:	6161                	addi	sp,sp,80
    80001c2c:	8082                	ret

0000000080001c2e <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001c2e:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001c32:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001c36:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001c38:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001c3a:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001c3e:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001c42:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001c46:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001c4a:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001c4e:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001c52:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001c56:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001c5a:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001c5e:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001c62:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001c66:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001c6a:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001c6c:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001c6e:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001c72:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001c76:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001c7a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001c7e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001c82:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001c86:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001c8a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001c8e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001c92:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001c96:	8082                	ret

0000000080001c98 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c98:	1141                	addi	sp,sp,-16
    80001c9a:	e406                	sd	ra,8(sp)
    80001c9c:	e022                	sd	s0,0(sp)
    80001c9e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ca0:	00006597          	auipc	a1,0x6
    80001ca4:	64858593          	addi	a1,a1,1608 # 800082e8 <etext+0x2e8>
    80001ca8:	00010517          	auipc	a0,0x10
    80001cac:	a3850513          	addi	a0,a0,-1480 # 800116e0 <tickslock>
    80001cb0:	446040ef          	jal	800060f6 <initlock>
}
    80001cb4:	60a2                	ld	ra,8(sp)
    80001cb6:	6402                	ld	s0,0(sp)
    80001cb8:	0141                	addi	sp,sp,16
    80001cba:	8082                	ret

0000000080001cbc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cbc:	1141                	addi	sp,sp,-16
    80001cbe:	e406                	sd	ra,8(sp)
    80001cc0:	e022                	sd	s0,0(sp)
    80001cc2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001cc4:	00003797          	auipc	a5,0x3
    80001cc8:	2ac78793          	addi	a5,a5,684 # 80004f70 <kernelvec>
    80001ccc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cd0:	60a2                	ld	ra,8(sp)
    80001cd2:	6402                	ld	s0,0(sp)
    80001cd4:	0141                	addi	sp,sp,16
    80001cd6:	8082                	ret

0000000080001cd8 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001cd8:	1141                	addi	sp,sp,-16
    80001cda:	e406                	sd	ra,8(sp)
    80001cdc:	e022                	sd	s0,0(sp)
    80001cde:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ce0:	bdeff0ef          	jal	800010be <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001ce4:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ce8:	04000737          	lui	a4,0x4000
    80001cec:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001cee:	0732                	slli	a4,a4,0xc
    80001cf0:	00005797          	auipc	a5,0x5
    80001cf4:	31078793          	addi	a5,a5,784 # 80007000 <_trampoline>
    80001cf8:	00005697          	auipc	a3,0x5
    80001cfc:	30868693          	addi	a3,a3,776 # 80007000 <_trampoline>
    80001d00:	8f95                	sub	a5,a5,a3
    80001d02:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001d04:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d08:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001d0a:	18002773          	csrr	a4,satp
    80001d0e:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d10:	6d38                	ld	a4,88(a0)
    80001d12:	613c                	ld	a5,64(a0)
    80001d14:	6685                	lui	a3,0x1
    80001d16:	97b6                	add	a5,a5,a3
    80001d18:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d1a:	6d3c                	ld	a5,88(a0)
    80001d1c:	00000717          	auipc	a4,0x0
    80001d20:	0fc70713          	addi	a4,a4,252 # 80001e18 <usertrap>
    80001d24:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001d26:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001d28:	8712                	mv	a4,tp
    80001d2a:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d2c:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d30:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d34:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001d38:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d3c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001d3e:	6f9c                	ld	a5,24(a5)
    80001d40:	14179073          	csrw	sepc,a5
}
    80001d44:	60a2                	ld	ra,8(sp)
    80001d46:	6402                	ld	s0,0(sp)
    80001d48:	0141                	addi	sp,sp,16
    80001d4a:	8082                	ret

0000000080001d4c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d4c:	1141                	addi	sp,sp,-16
    80001d4e:	e406                	sd	ra,8(sp)
    80001d50:	e022                	sd	s0,0(sp)
    80001d52:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80001d54:	b36ff0ef          	jal	8000108a <cpuid>
    80001d58:	cd11                	beqz	a0,80001d74 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    80001d5a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001d5e:	000f4737          	lui	a4,0xf4
    80001d62:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001d66:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    80001d68:	14d79073          	csrw	stimecmp,a5
}
    80001d6c:	60a2                	ld	ra,8(sp)
    80001d6e:	6402                	ld	s0,0(sp)
    80001d70:	0141                	addi	sp,sp,16
    80001d72:	8082                	ret
    acquire(&tickslock);
    80001d74:	00010517          	auipc	a0,0x10
    80001d78:	96c50513          	addi	a0,a0,-1684 # 800116e0 <tickslock>
    80001d7c:	3fa040ef          	jal	80006176 <acquire>
    ticks++;
    80001d80:	0000a717          	auipc	a4,0xa
    80001d84:	8f870713          	addi	a4,a4,-1800 # 8000b678 <ticks>
    80001d88:	431c                	lw	a5,0(a4)
    80001d8a:	2785                	addiw	a5,a5,1
    80001d8c:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001d8e:	853a                	mv	a0,a4
    80001d90:	a43ff0ef          	jal	800017d2 <wakeup>
    release(&tickslock);
    80001d94:	00010517          	auipc	a0,0x10
    80001d98:	94c50513          	addi	a0,a0,-1716 # 800116e0 <tickslock>
    80001d9c:	462040ef          	jal	800061fe <release>
    80001da0:	bf6d                	j	80001d5a <clockintr+0xe>

0000000080001da2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001da2:	1101                	addi	sp,sp,-32
    80001da4:	ec06                	sd	ra,24(sp)
    80001da6:	e822                	sd	s0,16(sp)
    80001da8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001daa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80001dae:	57fd                	li	a5,-1
    80001db0:	17fe                	slli	a5,a5,0x3f
    80001db2:	07a5                	addi	a5,a5,9
    80001db4:	00f70c63          	beq	a4,a5,80001dcc <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80001db8:	57fd                	li	a5,-1
    80001dba:	17fe                	slli	a5,a5,0x3f
    80001dbc:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001dbe:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    80001dc0:	04f70863          	beq	a4,a5,80001e10 <devintr+0x6e>
  }
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	6105                	addi	sp,sp,32
    80001dca:	8082                	ret
    80001dcc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001dce:	24e030ef          	jal	8000501c <plic_claim>
    80001dd2:	872a                	mv	a4,a0
    80001dd4:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001dd6:	47a9                	li	a5,10
    80001dd8:	00f50963          	beq	a0,a5,80001dea <devintr+0x48>
    } else if (irq == VIRTIO0_IRQ) {
    80001ddc:	4785                	li	a5,1
    80001dde:	00f50963          	beq	a0,a5,80001df0 <devintr+0x4e>
    return 1;
    80001de2:	4505                	li	a0,1
    } else if (irq) {
    80001de4:	eb09                	bnez	a4,80001df6 <devintr+0x54>
    80001de6:	64a2                	ld	s1,8(sp)
    80001de8:	bff1                	j	80001dc4 <devintr+0x22>
      uartintr();
    80001dea:	2b4040ef          	jal	8000609e <uartintr>
    if (irq)
    80001dee:	a819                	j	80001e04 <devintr+0x62>
      virtio_disk_intr();
    80001df0:	6e4030ef          	jal	800054d4 <virtio_disk_intr>
    if (irq)
    80001df4:	a801                	j	80001e04 <devintr+0x62>
      printk("unexpected interrupt irq=%d\n", irq);
    80001df6:	85ba                	mv	a1,a4
    80001df8:	00006517          	auipc	a0,0x6
    80001dfc:	4f850513          	addi	a0,a0,1272 # 800082f0 <etext+0x2f0>
    80001e00:	5db030ef          	jal	80005bda <printk>
      plic_complete(irq);
    80001e04:	8526                	mv	a0,s1
    80001e06:	236030ef          	jal	8000503c <plic_complete>
    return 1;
    80001e0a:	4505                	li	a0,1
    80001e0c:	64a2                	ld	s1,8(sp)
    80001e0e:	bf5d                	j	80001dc4 <devintr+0x22>
    clockintr();
    80001e10:	f3dff0ef          	jal	80001d4c <clockintr>
    return 2;
    80001e14:	4509                	li	a0,2
    80001e16:	b77d                	j	80001dc4 <devintr+0x22>

0000000080001e18 <usertrap>:
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	e04a                	sd	s2,0(sp)
    80001e22:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e24:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001e28:	1007f793          	andi	a5,a5,256
    80001e2c:	eba5                	bnez	a5,80001e9c <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001e2e:	00003797          	auipc	a5,0x3
    80001e32:	14278793          	addi	a5,a5,322 # 80004f70 <kernelvec>
    80001e36:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e3a:	a84ff0ef          	jal	800010be <myproc>
    80001e3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e40:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e42:	14102773          	csrr	a4,sepc
    80001e46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e48:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001e4c:	47a1                	li	a5,8
    80001e4e:	04f70d63          	beq	a4,a5,80001ea8 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    80001e52:	f51ff0ef          	jal	80001da2 <devintr>
    80001e56:	892a                	mv	s2,a0
    80001e58:	e54d                	bnez	a0,80001f02 <usertrap+0xea>
    80001e5a:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80001e5e:	47bd                	li	a5,15
    80001e60:	08f70463          	beq	a4,a5,80001ee8 <usertrap+0xd0>
    80001e64:	14202773          	csrr	a4,scause
    80001e68:	47b5                	li	a5,13
    80001e6a:	06f70f63          	beq	a4,a5,80001ee8 <usertrap+0xd0>
    80001e6e:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001e72:	5890                	lw	a2,48(s1)
    80001e74:	00006517          	auipc	a0,0x6
    80001e78:	4bc50513          	addi	a0,a0,1212 # 80008330 <etext+0x330>
    80001e7c:	55f030ef          	jal	80005bda <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001e84:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	4d850513          	addi	a0,a0,1240 # 80008360 <etext+0x360>
    80001e90:	54b030ef          	jal	80005bda <printk>
    setkilled(p);
    80001e94:	8526                	mv	a0,s1
    80001e96:	b05ff0ef          	jal	8000199a <setkilled>
    80001e9a:	a015                	j	80001ebe <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	47450513          	addi	a0,a0,1140 # 80008310 <etext+0x310>
    80001ea4:	060040ef          	jal	80005f04 <panic>
    if (killed(p))
    80001ea8:	b17ff0ef          	jal	800019be <killed>
    80001eac:	e915                	bnez	a0,80001ee0 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80001eae:	6cb8                	ld	a4,88(s1)
    80001eb0:	6f1c                	ld	a5,24(a4)
    80001eb2:	0791                	addi	a5,a5,4
    80001eb4:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001eb6:	10016073          	csrsi	sstatus,2
    syscall();
    80001eba:	244000ef          	jal	800020fe <syscall>
  if (killed(p))
    80001ebe:	8526                	mv	a0,s1
    80001ec0:	affff0ef          	jal	800019be <killed>
    80001ec4:	e521                	bnez	a0,80001f0c <usertrap+0xf4>
  prepare_return();
    80001ec6:	e13ff0ef          	jal	80001cd8 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001eca:	68a8                	ld	a0,80(s1)
    80001ecc:	8131                	srli	a0,a0,0xc
    80001ece:	57fd                	li	a5,-1
    80001ed0:	17fe                	slli	a5,a5,0x3f
    80001ed2:	8d5d                	or	a0,a0,a5
}
    80001ed4:	60e2                	ld	ra,24(sp)
    80001ed6:	6442                	ld	s0,16(sp)
    80001ed8:	64a2                	ld	s1,8(sp)
    80001eda:	6902                	ld	s2,0(sp)
    80001edc:	6105                	addi	sp,sp,32
    80001ede:	8082                	ret
      kexit(-1);
    80001ee0:	557d                	li	a0,-1
    80001ee2:	9adff0ef          	jal	8000188e <kexit>
    80001ee6:	b7e1                	j	80001eae <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    80001ee8:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80001eec:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80001ef0:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80001ef2:	0016b693          	seqz	a3,a3
    80001ef6:	64ac                	ld	a1,72(s1)
    80001ef8:	68a8                	ld	a0,80(s1)
    80001efa:	d81fe0ef          	jal	80000c7a <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80001efe:	f161                	bnez	a0,80001ebe <usertrap+0xa6>
    80001f00:	b7bd                	j	80001e6e <usertrap+0x56>
  if (killed(p))
    80001f02:	8526                	mv	a0,s1
    80001f04:	abbff0ef          	jal	800019be <killed>
    80001f08:	c511                	beqz	a0,80001f14 <usertrap+0xfc>
    80001f0a:	a011                	j	80001f0e <usertrap+0xf6>
    80001f0c:	4901                	li	s2,0
    kexit(-1);
    80001f0e:	557d                	li	a0,-1
    80001f10:	97fff0ef          	jal	8000188e <kexit>
  if (which_dev == 2)
    80001f14:	4789                	li	a5,2
    80001f16:	faf918e3          	bne	s2,a5,80001ec6 <usertrap+0xae>
    yield();
    80001f1a:	821ff0ef          	jal	8000173a <yield>
    80001f1e:	b765                	j	80001ec6 <usertrap+0xae>

0000000080001f20 <kerneltrap>:
{
    80001f20:	7179                	addi	sp,sp,-48
    80001f22:	f406                	sd	ra,40(sp)
    80001f24:	f022                	sd	s0,32(sp)
    80001f26:	ec26                	sd	s1,24(sp)
    80001f28:	e84a                	sd	s2,16(sp)
    80001f2a:	e44e                	sd	s3,8(sp)
    80001f2c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f2e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f32:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001f36:	142027f3          	csrr	a5,scause
    80001f3a:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    80001f3c:	1004f793          	andi	a5,s1,256
    80001f40:	c795                	beqz	a5,80001f6c <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f42:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f46:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001f48:	eb85                	bnez	a5,80001f78 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    80001f4a:	e59ff0ef          	jal	80001da2 <devintr>
    80001f4e:	c91d                	beqz	a0,80001f84 <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    80001f50:	4789                	li	a5,2
    80001f52:	04f50a63          	beq	a0,a5,80001fa6 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001f56:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001f5a:	10049073          	csrw	sstatus,s1
}
    80001f5e:	70a2                	ld	ra,40(sp)
    80001f60:	7402                	ld	s0,32(sp)
    80001f62:	64e2                	ld	s1,24(sp)
    80001f64:	6942                	ld	s2,16(sp)
    80001f66:	69a2                	ld	s3,8(sp)
    80001f68:	6145                	addi	sp,sp,48
    80001f6a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	41c50513          	addi	a0,a0,1052 # 80008388 <etext+0x388>
    80001f74:	791030ef          	jal	80005f04 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f78:	00006517          	auipc	a0,0x6
    80001f7c:	43850513          	addi	a0,a0,1080 # 800083b0 <etext+0x3b0>
    80001f80:	785030ef          	jal	80005f04 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001f84:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001f88:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80001f8c:	85ce                	mv	a1,s3
    80001f8e:	00006517          	auipc	a0,0x6
    80001f92:	44250513          	addi	a0,a0,1090 # 800083d0 <etext+0x3d0>
    80001f96:	445030ef          	jal	80005bda <printk>
    panic("kerneltrap");
    80001f9a:	00006517          	auipc	a0,0x6
    80001f9e:	45e50513          	addi	a0,a0,1118 # 800083f8 <etext+0x3f8>
    80001fa2:	763030ef          	jal	80005f04 <panic>
  if (which_dev == 2 && myproc() != 0)
    80001fa6:	918ff0ef          	jal	800010be <myproc>
    80001faa:	d555                	beqz	a0,80001f56 <kerneltrap+0x36>
    yield();
    80001fac:	f8eff0ef          	jal	8000173a <yield>
    80001fb0:	b75d                	j	80001f56 <kerneltrap+0x36>

0000000080001fb2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fb2:	1101                	addi	sp,sp,-32
    80001fb4:	ec06                	sd	ra,24(sp)
    80001fb6:	e822                	sd	s0,16(sp)
    80001fb8:	e426                	sd	s1,8(sp)
    80001fba:	1000                	addi	s0,sp,32
    80001fbc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fbe:	900ff0ef          	jal	800010be <myproc>
  switch (n) {
    80001fc2:	4795                	li	a5,5
    80001fc4:	0497e163          	bltu	a5,s1,80002006 <argraw+0x54>
    80001fc8:	048a                	slli	s1,s1,0x2
    80001fca:	00007717          	auipc	a4,0x7
    80001fce:	87670713          	addi	a4,a4,-1930 # 80008840 <states.0+0x30>
    80001fd2:	94ba                	add	s1,s1,a4
    80001fd4:	409c                	lw	a5,0(s1)
    80001fd6:	97ba                	add	a5,a5,a4
    80001fd8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fda:	6d3c                	ld	a5,88(a0)
    80001fdc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fde:	60e2                	ld	ra,24(sp)
    80001fe0:	6442                	ld	s0,16(sp)
    80001fe2:	64a2                	ld	s1,8(sp)
    80001fe4:	6105                	addi	sp,sp,32
    80001fe6:	8082                	ret
    return p->trapframe->a1;
    80001fe8:	6d3c                	ld	a5,88(a0)
    80001fea:	7fa8                	ld	a0,120(a5)
    80001fec:	bfcd                	j	80001fde <argraw+0x2c>
    return p->trapframe->a2;
    80001fee:	6d3c                	ld	a5,88(a0)
    80001ff0:	63c8                	ld	a0,128(a5)
    80001ff2:	b7f5                	j	80001fde <argraw+0x2c>
    return p->trapframe->a3;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	67c8                	ld	a0,136(a5)
    80001ff8:	b7dd                	j	80001fde <argraw+0x2c>
    return p->trapframe->a4;
    80001ffa:	6d3c                	ld	a5,88(a0)
    80001ffc:	6bc8                	ld	a0,144(a5)
    80001ffe:	b7c5                	j	80001fde <argraw+0x2c>
    return p->trapframe->a5;
    80002000:	6d3c                	ld	a5,88(a0)
    80002002:	6fc8                	ld	a0,152(a5)
    80002004:	bfe9                	j	80001fde <argraw+0x2c>
  panic("argraw");
    80002006:	00006517          	auipc	a0,0x6
    8000200a:	40250513          	addi	a0,a0,1026 # 80008408 <etext+0x408>
    8000200e:	6f7030ef          	jal	80005f04 <panic>

0000000080002012 <fetchaddr>:
{
    80002012:	1101                	addi	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	e04a                	sd	s2,0(sp)
    8000201c:	1000                	addi	s0,sp,32
    8000201e:	84aa                	mv	s1,a0
    80002020:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002022:	89cff0ef          	jal	800010be <myproc>
  if (addr >= p->sz ||
    80002026:	652c                	ld	a1,72(a0)
    80002028:	02b4f663          	bgeu	s1,a1,80002054 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000202c:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    80002030:	02f5e463          	bltu	a1,a5,80002058 <fetchaddr+0x46>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    80002034:	4721                	li	a4,8
    80002036:	86a6                	mv	a3,s1
    80002038:	864a                	mv	a2,s2
    8000203a:	6928                	ld	a0,80(a0)
    8000203c:	d87fe0ef          	jal	80000dc2 <copyin>
    80002040:	00a03533          	snez	a0,a0
    80002044:	40a0053b          	negw	a0,a0
}
    80002048:	60e2                	ld	ra,24(sp)
    8000204a:	6442                	ld	s0,16(sp)
    8000204c:	64a2                	ld	s1,8(sp)
    8000204e:	6902                	ld	s2,0(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret
    return -1;
    80002054:	557d                	li	a0,-1
    80002056:	bfcd                	j	80002048 <fetchaddr+0x36>
    80002058:	557d                	li	a0,-1
    8000205a:	b7fd                	j	80002048 <fetchaddr+0x36>

000000008000205c <fetchstr>:
{
    8000205c:	7179                	addi	sp,sp,-48
    8000205e:	f406                	sd	ra,40(sp)
    80002060:	f022                	sd	s0,32(sp)
    80002062:	ec26                	sd	s1,24(sp)
    80002064:	e84a                	sd	s2,16(sp)
    80002066:	e44e                	sd	s3,8(sp)
    80002068:	1800                	addi	s0,sp,48
    8000206a:	89aa                	mv	s3,a0
    8000206c:	84ae                	mv	s1,a1
    8000206e:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002070:	84eff0ef          	jal	800010be <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    80002074:	874a                	mv	a4,s2
    80002076:	86ce                	mv	a3,s3
    80002078:	8626                	mv	a2,s1
    8000207a:	652c                	ld	a1,72(a0)
    8000207c:	6928                	ld	a0,80(a0)
    8000207e:	de1fe0ef          	jal	80000e5e <copyinstr>
    80002082:	00054c63          	bltz	a0,8000209a <fetchstr+0x3e>
  return strlen(buf);
    80002086:	8526                	mv	a0,s1
    80002088:	a60fe0ef          	jal	800002e8 <strlen>
}
    8000208c:	70a2                	ld	ra,40(sp)
    8000208e:	7402                	ld	s0,32(sp)
    80002090:	64e2                	ld	s1,24(sp)
    80002092:	6942                	ld	s2,16(sp)
    80002094:	69a2                	ld	s3,8(sp)
    80002096:	6145                	addi	sp,sp,48
    80002098:	8082                	ret
    return -1;
    8000209a:	557d                	li	a0,-1
    8000209c:	bfc5                	j	8000208c <fetchstr+0x30>

000000008000209e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000209e:	1101                	addi	sp,sp,-32
    800020a0:	ec06                	sd	ra,24(sp)
    800020a2:	e822                	sd	s0,16(sp)
    800020a4:	e426                	sd	s1,8(sp)
    800020a6:	1000                	addi	s0,sp,32
    800020a8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020aa:	f09ff0ef          	jal	80001fb2 <argraw>
    800020ae:	c088                	sw	a0,0(s1)
}
    800020b0:	60e2                	ld	ra,24(sp)
    800020b2:	6442                	ld	s0,16(sp)
    800020b4:	64a2                	ld	s1,8(sp)
    800020b6:	6105                	addi	sp,sp,32
    800020b8:	8082                	ret

00000000800020ba <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020ba:	1101                	addi	sp,sp,-32
    800020bc:	ec06                	sd	ra,24(sp)
    800020be:	e822                	sd	s0,16(sp)
    800020c0:	e426                	sd	s1,8(sp)
    800020c2:	1000                	addi	s0,sp,32
    800020c4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020c6:	eedff0ef          	jal	80001fb2 <argraw>
    800020ca:	e088                	sd	a0,0(s1)
}
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	64a2                	ld	s1,8(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	e426                	sd	s1,8(sp)
    800020de:	e04a                	sd	s2,0(sp)
    800020e0:	1000                	addi	s0,sp,32
    800020e2:	892e                	mv	s2,a1
    800020e4:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800020e6:	ecdff0ef          	jal	80001fb2 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800020ea:	8626                	mv	a2,s1
    800020ec:	85ca                	mv	a1,s2
    800020ee:	f6fff0ef          	jal	8000205c <fetchstr>
}
    800020f2:	60e2                	ld	ra,24(sp)
    800020f4:	6442                	ld	s0,16(sp)
    800020f6:	64a2                	ld	s1,8(sp)
    800020f8:	6902                	ld	s2,0(sp)
    800020fa:	6105                	addi	sp,sp,32
    800020fc:	8082                	ret

00000000800020fe <syscall>:
};


void
syscall(void)
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	e426                	sd	s1,8(sp)
    80002106:	e04a                	sd	s2,0(sp)
    80002108:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000210a:	fb5fe0ef          	jal	800010be <myproc>
    8000210e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002110:	05853903          	ld	s2,88(a0)
    80002114:	0a893783          	ld	a5,168(s2)
    80002118:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000211c:	37fd                	addiw	a5,a5,-1
    8000211e:	02600713          	li	a4,38
    80002122:	00f76f63          	bltu	a4,a5,80002140 <syscall+0x42>
    80002126:	00369713          	slli	a4,a3,0x3
    8000212a:	00006797          	auipc	a5,0x6
    8000212e:	72e78793          	addi	a5,a5,1838 # 80008858 <syscalls>
    80002132:	97ba                	add	a5,a5,a4
    80002134:	639c                	ld	a5,0(a5)
    80002136:	c789                	beqz	a5,80002140 <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002138:	9782                	jalr	a5
    8000213a:	06a93823          	sd	a0,112(s2)
    8000213e:	a829                	j	80002158 <syscall+0x5a>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002140:	15848613          	addi	a2,s1,344
    80002144:	588c                	lw	a1,48(s1)
    80002146:	00006517          	auipc	a0,0x6
    8000214a:	2ca50513          	addi	a0,a0,714 # 80008410 <etext+0x410>
    8000214e:	28d030ef          	jal	80005bda <printk>
    p->trapframe->a0 = -1;
    80002152:	6cbc                	ld	a5,88(s1)
    80002154:	577d                	li	a4,-1
    80002156:	fbb8                	sd	a4,112(a5)
  }
}
    80002158:	60e2                	ld	ra,24(sp)
    8000215a:	6442                	ld	s0,16(sp)
    8000215c:	64a2                	ld	s1,8(sp)
    8000215e:	6902                	ld	s2,0(sp)
    80002160:	6105                	addi	sp,sp,32
    80002162:	8082                	ret

0000000080002164 <sys_exit>:
#endif
#include "vm.h"

uint64
sys_exit(void)
{
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000216c:	fec40593          	addi	a1,s0,-20
    80002170:	4501                	li	a0,0
    80002172:	f2dff0ef          	jal	8000209e <argint>
  kexit(n);
    80002176:	fec42503          	lw	a0,-20(s0)
    8000217a:	f14ff0ef          	jal	8000188e <kexit>
  return 0; // not reached
}
    8000217e:	4501                	li	a0,0
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	6105                	addi	sp,sp,32
    80002186:	8082                	ret

0000000080002188 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002188:	1141                	addi	sp,sp,-16
    8000218a:	e406                	sd	ra,8(sp)
    8000218c:	e022                	sd	s0,0(sp)
    8000218e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002190:	f2ffe0ef          	jal	800010be <myproc>
}
    80002194:	5908                	lw	a0,48(a0)
    80002196:	60a2                	ld	ra,8(sp)
    80002198:	6402                	ld	s0,0(sp)
    8000219a:	0141                	addi	sp,sp,16
    8000219c:	8082                	ret

000000008000219e <sys_fork>:

uint64
sys_fork(void)
{
    8000219e:	1141                	addi	sp,sp,-16
    800021a0:	e406                	sd	ra,8(sp)
    800021a2:	e022                	sd	s0,0(sp)
    800021a4:	0800                	addi	s0,sp,16
  return kfork();
    800021a6:	b12ff0ef          	jal	800014b8 <kfork>
}
    800021aa:	60a2                	ld	ra,8(sp)
    800021ac:	6402                	ld	s0,0(sp)
    800021ae:	0141                	addi	sp,sp,16
    800021b0:	8082                	ret

00000000800021b2 <sys_wait>:

uint64
sys_wait(void)
{
    800021b2:	1101                	addi	sp,sp,-32
    800021b4:	ec06                	sd	ra,24(sp)
    800021b6:	e822                	sd	s0,16(sp)
    800021b8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021ba:	fe840593          	addi	a1,s0,-24
    800021be:	4501                	li	a0,0
    800021c0:	efbff0ef          	jal	800020ba <argaddr>
  return kwait(p);
    800021c4:	fe843503          	ld	a0,-24(s0)
    800021c8:	821ff0ef          	jal	800019e8 <kwait>
}
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	6105                	addi	sp,sp,32
    800021d2:	8082                	ret

00000000800021d4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021d4:	7179                	addi	sp,sp,-48
    800021d6:	f406                	sd	ra,40(sp)
    800021d8:	f022                	sd	s0,32(sp)
    800021da:	ec26                	sd	s1,24(sp)
    800021dc:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800021de:	fd840593          	addi	a1,s0,-40
    800021e2:	4501                	li	a0,0
    800021e4:	ebbff0ef          	jal	8000209e <argint>
  argint(1, &t);
    800021e8:	fdc40593          	addi	a1,s0,-36
    800021ec:	4505                	li	a0,1
    800021ee:	eb1ff0ef          	jal	8000209e <argint>
  addr = myproc()->sz;
    800021f2:	ecdfe0ef          	jal	800010be <myproc>
    800021f6:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    800021f8:	fdc42703          	lw	a4,-36(s0)
    800021fc:	4785                	li	a5,1
    800021fe:	02f70763          	beq	a4,a5,8000222c <sys_sbrk+0x58>
    80002202:	fd842783          	lw	a5,-40(s0)
    80002206:	0207c363          	bltz	a5,8000222c <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    8000220a:	97a6                	add	a5,a5,s1
      return -1;
    if (addr + n > UTOP)
    8000220c:	04000737          	lui	a4,0x4000
    80002210:	1775                	addi	a4,a4,-3 # 3fffffd <_entry-0x7c000003>
    80002212:	0732                	slli	a4,a4,0xc
    80002214:	02f76a63          	bltu	a4,a5,80002248 <sys_sbrk+0x74>
    80002218:	0297e863          	bltu	a5,s1,80002248 <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    8000221c:	ea3fe0ef          	jal	800010be <myproc>
    80002220:	fd842703          	lw	a4,-40(s0)
    80002224:	653c                	ld	a5,72(a0)
    80002226:	97ba                	add	a5,a5,a4
    80002228:	e53c                	sd	a5,72(a0)
    8000222a:	a039                	j	80002238 <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    8000222c:	fd842503          	lw	a0,-40(s0)
    80002230:	a26ff0ef          	jal	80001456 <growproc>
    80002234:	00054863          	bltz	a0,80002244 <sys_sbrk+0x70>
  }
  return addr;
}
    80002238:	8526                	mv	a0,s1
    8000223a:	70a2                	ld	ra,40(sp)
    8000223c:	7402                	ld	s0,32(sp)
    8000223e:	64e2                	ld	s1,24(sp)
    80002240:	6145                	addi	sp,sp,48
    80002242:	8082                	ret
      return -1;
    80002244:	54fd                	li	s1,-1
    80002246:	bfcd                	j	80002238 <sys_sbrk+0x64>
      return -1;
    80002248:	54fd                	li	s1,-1
    8000224a:	b7fd                	j	80002238 <sys_sbrk+0x64>

000000008000224c <sys_pause>:

uint64
sys_pause(void)
{
    8000224c:	7139                	addi	sp,sp,-64
    8000224e:	fc06                	sd	ra,56(sp)
    80002250:	f822                	sd	s0,48(sp)
    80002252:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80002254:	fcc40593          	addi	a1,s0,-52
    80002258:	4501                	li	a0,0
    8000225a:	e45ff0ef          	jal	8000209e <argint>
  if (n < 0)
    8000225e:	fcc42783          	lw	a5,-52(s0)
    80002262:	0807c063          	bltz	a5,800022e2 <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002266:	0000f517          	auipc	a0,0xf
    8000226a:	47a50513          	addi	a0,a0,1146 # 800116e0 <tickslock>
    8000226e:	709030ef          	jal	80006176 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002272:	fcc42783          	lw	a5,-52(s0)
    80002276:	cbb9                	beqz	a5,800022cc <sys_pause+0x80>
    80002278:	f426                	sd	s1,40(sp)
    8000227a:	f04a                	sd	s2,32(sp)
    8000227c:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    8000227e:	00009997          	auipc	s3,0x9
    80002282:	3fa9a983          	lw	s3,1018(s3) # 8000b678 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002286:	00009917          	auipc	s2,0x9
    8000228a:	3f290913          	addi	s2,s2,1010 # 8000b678 <ticks>
    release(&tickslock);
    8000228e:	0000f497          	auipc	s1,0xf
    80002292:	45248493          	addi	s1,s1,1106 # 800116e0 <tickslock>
    if (killed(myproc())) {
    80002296:	e29fe0ef          	jal	800010be <myproc>
    8000229a:	f24ff0ef          	jal	800019be <killed>
    8000229e:	e529                	bnez	a0,800022e8 <sys_pause+0x9c>
    sleep_prepare(&ticks);
    800022a0:	854a                	mv	a0,s2
    800022a2:	cc4ff0ef          	jal	80001766 <sleep_prepare>
    release(&tickslock);
    800022a6:	8526                	mv	a0,s1
    800022a8:	757030ef          	jal	800061fe <release>
    sleep();
    800022ac:	cf6ff0ef          	jal	800017a2 <sleep>
    acquire(&tickslock);
    800022b0:	8526                	mv	a0,s1
    800022b2:	6c5030ef          	jal	80006176 <acquire>
  while (ticks - ticks0 < n) {
    800022b6:	00092783          	lw	a5,0(s2)
    800022ba:	413787bb          	subw	a5,a5,s3
    800022be:	fcc42703          	lw	a4,-52(s0)
    800022c2:	fce7eae3          	bltu	a5,a4,80002296 <sys_pause+0x4a>
    800022c6:	74a2                	ld	s1,40(sp)
    800022c8:	7902                	ld	s2,32(sp)
    800022ca:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800022cc:	0000f517          	auipc	a0,0xf
    800022d0:	41450513          	addi	a0,a0,1044 # 800116e0 <tickslock>
    800022d4:	72b030ef          	jal	800061fe <release>
  return 0;
    800022d8:	4501                	li	a0,0
}
    800022da:	70e2                	ld	ra,56(sp)
    800022dc:	7442                	ld	s0,48(sp)
    800022de:	6121                	addi	sp,sp,64
    800022e0:	8082                	ret
    n = 0;
    800022e2:	fc042623          	sw	zero,-52(s0)
    800022e6:	b741                	j	80002266 <sys_pause+0x1a>
      release(&tickslock);
    800022e8:	0000f517          	auipc	a0,0xf
    800022ec:	3f850513          	addi	a0,a0,1016 # 800116e0 <tickslock>
    800022f0:	70f030ef          	jal	800061fe <release>
      return -1;
    800022f4:	557d                	li	a0,-1
    800022f6:	74a2                	ld	s1,40(sp)
    800022f8:	7902                	ld	s2,32(sp)
    800022fa:	69e2                	ld	s3,24(sp)
    800022fc:	bff9                	j	800022da <sys_pause+0x8e>

00000000800022fe <sys_vmprint>:


#ifdef LAB_PGTBL
int
sys_vmprint(void)
{
    800022fe:	1141                	addi	sp,sp,-16
    80002300:	e406                	sd	ra,8(sp)
    80002302:	e022                	sd	s0,0(sp)
    80002304:	0800                	addi	s0,sp,16
  struct proc *p;

  p = myproc();
    80002306:	db9fe0ef          	jal	800010be <myproc>
  vmprint(p->pagetable);
    8000230a:	6928                	ld	a0,80(a0)
    8000230c:	b08fe0ef          	jal	80000614 <vmprint>
  return 0;
}
    80002310:	4501                	li	a0,0
    80002312:	60a2                	ld	ra,8(sp)
    80002314:	6402                	ld	s0,0(sp)
    80002316:	0141                	addi	sp,sp,16
    80002318:	8082                	ret

000000008000231a <sys_pgaccess>:
#endif

#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000231a:	711d                	addi	sp,sp,-96
    8000231c:	ec86                	sd	ra,88(sp)
    8000231e:	e8a2                	sd	s0,80(sp)
    80002320:	1080                	addi	s0,sp,96
  uint64 base;
  int length;
  uint64 mask_addr;

  argaddr(0, &base);
    80002322:	fb840593          	addi	a1,s0,-72
    80002326:	4501                	li	a0,0
    80002328:	d93ff0ef          	jal	800020ba <argaddr>
  argint(1, &length);
    8000232c:	fb440593          	addi	a1,s0,-76
    80002330:	4505                	li	a0,1
    80002332:	d6dff0ef          	jal	8000209e <argint>
  argaddr(2, &mask_addr);
    80002336:	fa840593          	addi	a1,s0,-88
    8000233a:	4509                	li	a0,2
    8000233c:	d7fff0ef          	jal	800020ba <argaddr>

  if(length < 0 || length > 4096) {
    80002340:	fb442703          	lw	a4,-76(s0)
    80002344:	6785                	lui	a5,0x1
    80002346:	10e7e663          	bltu	a5,a4,80002452 <sys_pgaccess+0x138>
    8000234a:	e0ca                	sd	s2,64(sp)
    return -1;
  }

  struct proc *p = myproc();
    8000234c:	d73fe0ef          	jal	800010be <myproc>
    80002350:	892a                	mv	s2,a0
  if(mask_addr >= p->sz) {
    80002352:	6538                	ld	a4,72(a0)
    80002354:	fa843783          	ld	a5,-88(s0)
    80002358:	0ee7ff63          	bgeu	a5,a4,80002456 <sys_pgaccess+0x13c>
    8000235c:	e4a6                	sd	s1,72(sp)
    8000235e:	fc4e                	sd	s3,56(sp)
    return -1;

  }  
  
  int nbytes = (length + 7) / 8;
    80002360:	fb442483          	lw	s1,-76(s0)
  char *kmask = kalloc(); 
    80002364:	da1fd0ef          	jal	80000104 <kalloc>
    80002368:	89aa                	mv	s3,a0
  if(kmask == 0) {
    8000236a:	0e050963          	beqz	a0,8000245c <sys_pgaccess+0x142>
    8000236e:	f456                	sd	s5,40(sp)
  int nbytes = (length + 7) / 8;
    80002370:	0074871b          	addiw	a4,s1,7
    80002374:	41f7579b          	sraiw	a5,a4,0x1f
    80002378:	01d7d79b          	srliw	a5,a5,0x1d
    8000237c:	9fb9                	addw	a5,a5,a4
    8000237e:	4037d79b          	sraiw	a5,a5,0x3
    80002382:	8abe                	mv	s5,a5
    return -1;
  }
  memset(kmask, 0, nbytes);
    80002384:	863e                	mv	a2,a5
    80002386:	4581                	li	a1,0
    80002388:	dd7fd0ef          	jal	8000015e <memset>

  for (int i = 0; i < length; i++) {
    8000238c:	fb442783          	lw	a5,-76(s0)
    80002390:	08f05363          	blez	a5,80002416 <sys_pgaccess+0xfc>
    80002394:	f852                	sd	s4,48(sp)
    80002396:	4481                	li	s1,0
      kfree(kmask);
      return -1;
    }

    if(*pte & PTE_A){
      kmask[i / 8] |= (1 << (i % 8)); 
    80002398:	4a05                	li	s4,1
    8000239a:	a02d                	j	800023c4 <sys_pgaccess+0xaa>
      kfree(kmask);
    8000239c:	854e                	mv	a0,s3
    8000239e:	c7ffd0ef          	jal	8000001c <kfree>
      return -1;
    800023a2:	557d                	li	a0,-1
    800023a4:	64a6                	ld	s1,72(sp)
    800023a6:	6906                	ld	s2,64(sp)
    800023a8:	79e2                	ld	s3,56(sp)
    800023aa:	7a42                	ld	s4,48(sp)
    800023ac:	7aa2                	ld	s5,40(sp)
    return -1;
  }

  kfree(kmask);
  return 0;
}
    800023ae:	60e6                	ld	ra,88(sp)
    800023b0:	6446                	ld	s0,80(sp)
    800023b2:	6125                	addi	sp,sp,96
    800023b4:	8082                	ret
  for (int i = 0; i < length; i++) {
    800023b6:	0485                	addi	s1,s1,1
    800023b8:	fb442703          	lw	a4,-76(s0)
    800023bc:	0004879b          	sext.w	a5,s1
    800023c0:	04e7da63          	bge	a5,a4,80002414 <sys_pgaccess+0xfa>
    uint64 va = base + i * PGSIZE;
    800023c4:	00c49593          	slli	a1,s1,0xc
    pte_t *pte = walk(p->pagetable, va, 0);
    800023c8:	4601                	li	a2,0
    800023ca:	fb843783          	ld	a5,-72(s0)
    800023ce:	95be                	add	a1,a1,a5
    800023d0:	05093503          	ld	a0,80(s2)
    800023d4:	820fe0ef          	jal	800003f4 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0){
    800023d8:	d171                	beqz	a0,8000239c <sys_pgaccess+0x82>
    800023da:	611c                	ld	a5,0(a0)
    800023dc:	0017f713          	andi	a4,a5,1
    800023e0:	df55                	beqz	a4,8000239c <sys_pgaccess+0x82>
    if(*pte & PTE_A){
    800023e2:	0407f793          	andi	a5,a5,64
    800023e6:	dbe1                	beqz	a5,800023b6 <sys_pgaccess+0x9c>
      kmask[i / 8] |= (1 << (i % 8)); 
    800023e8:	41f4d79b          	sraiw	a5,s1,0x1f
    800023ec:	01d7d79b          	srliw	a5,a5,0x1d
    800023f0:	9fa5                	addw	a5,a5,s1
    800023f2:	4037d79b          	sraiw	a5,a5,0x3
    800023f6:	97ce                	add	a5,a5,s3
    800023f8:	0074f713          	andi	a4,s1,7
    800023fc:	00ea173b          	sllw	a4,s4,a4
    80002400:	0007c683          	lbu	a3,0(a5) # 1000 <_entry-0x7ffff000>
    80002404:	8f55                	or	a4,a4,a3
    80002406:	00e78023          	sb	a4,0(a5)
      *pte &= ~PTE_A;
    8000240a:	611c                	ld	a5,0(a0)
    8000240c:	fbf7f793          	andi	a5,a5,-65
    80002410:	e11c                	sd	a5,0(a0)
    80002412:	b755                	j	800023b6 <sys_pgaccess+0x9c>
    80002414:	7a42                	ld	s4,48(sp)
  if(copyout(p->pagetable, p->sz, mask_addr, kmask, nbytes) < 0) {
    80002416:	8756                	mv	a4,s5
    80002418:	86ce                	mv	a3,s3
    8000241a:	fa843603          	ld	a2,-88(s0)
    8000241e:	04893583          	ld	a1,72(s2)
    80002422:	05093503          	ld	a0,80(s2)
    80002426:	8d1fe0ef          	jal	80000cf6 <copyout>
    8000242a:	00054b63          	bltz	a0,80002440 <sys_pgaccess+0x126>
  kfree(kmask);
    8000242e:	854e                	mv	a0,s3
    80002430:	bedfd0ef          	jal	8000001c <kfree>
  return 0;
    80002434:	4501                	li	a0,0
    80002436:	64a6                	ld	s1,72(sp)
    80002438:	6906                	ld	s2,64(sp)
    8000243a:	79e2                	ld	s3,56(sp)
    8000243c:	7aa2                	ld	s5,40(sp)
    8000243e:	bf85                	j	800023ae <sys_pgaccess+0x94>
    kfree(kmask);
    80002440:	854e                	mv	a0,s3
    80002442:	bdbfd0ef          	jal	8000001c <kfree>
    return -1;
    80002446:	557d                	li	a0,-1
    80002448:	64a6                	ld	s1,72(sp)
    8000244a:	6906                	ld	s2,64(sp)
    8000244c:	79e2                	ld	s3,56(sp)
    8000244e:	7aa2                	ld	s5,40(sp)
    80002450:	bfb9                	j	800023ae <sys_pgaccess+0x94>
    return -1;
    80002452:	557d                	li	a0,-1
    80002454:	bfa9                	j	800023ae <sys_pgaccess+0x94>
    return -1;
    80002456:	557d                	li	a0,-1
    80002458:	6906                	ld	s2,64(sp)
    8000245a:	bf91                	j	800023ae <sys_pgaccess+0x94>
    return -1;
    8000245c:	557d                	li	a0,-1
    8000245e:	64a6                	ld	s1,72(sp)
    80002460:	6906                	ld	s2,64(sp)
    80002462:	79e2                	ld	s3,56(sp)
    80002464:	b7a9                	j	800023ae <sys_pgaccess+0x94>

0000000080002466 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002466:	1101                	addi	sp,sp,-32
    80002468:	ec06                	sd	ra,24(sp)
    8000246a:	e822                	sd	s0,16(sp)
    8000246c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000246e:	fec40593          	addi	a1,s0,-20
    80002472:	4501                	li	a0,0
    80002474:	c2bff0ef          	jal	8000209e <argint>
  return kkill(pid);
    80002478:	fec42503          	lw	a0,-20(s0)
    8000247c:	cb8ff0ef          	jal	80001934 <kkill>
}
    80002480:	60e2                	ld	ra,24(sp)
    80002482:	6442                	ld	s0,16(sp)
    80002484:	6105                	addi	sp,sp,32
    80002486:	8082                	ret

0000000080002488 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002488:	1101                	addi	sp,sp,-32
    8000248a:	ec06                	sd	ra,24(sp)
    8000248c:	e822                	sd	s0,16(sp)
    8000248e:	e426                	sd	s1,8(sp)
    80002490:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002492:	0000f517          	auipc	a0,0xf
    80002496:	24e50513          	addi	a0,a0,590 # 800116e0 <tickslock>
    8000249a:	4dd030ef          	jal	80006176 <acquire>
  xticks = ticks;
    8000249e:	00009797          	auipc	a5,0x9
    800024a2:	1da7a783          	lw	a5,474(a5) # 8000b678 <ticks>
    800024a6:	84be                	mv	s1,a5
  release(&tickslock);
    800024a8:	0000f517          	auipc	a0,0xf
    800024ac:	23850513          	addi	a0,a0,568 # 800116e0 <tickslock>
    800024b0:	54f030ef          	jal	800061fe <release>
  return xticks;
}
    800024b4:	02049513          	slli	a0,s1,0x20
    800024b8:	9101                	srli	a0,a0,0x20
    800024ba:	60e2                	ld	ra,24(sp)
    800024bc:	6442                	ld	s0,16(sp)
    800024be:	64a2                	ld	s1,8(sp)
    800024c0:	6105                	addi	sp,sp,32
    800024c2:	8082                	ret

00000000800024c4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024c4:	7179                	addi	sp,sp,-48
    800024c6:	f406                	sd	ra,40(sp)
    800024c8:	f022                	sd	s0,32(sp)
    800024ca:	ec26                	sd	s1,24(sp)
    800024cc:	e84a                	sd	s2,16(sp)
    800024ce:	e44e                	sd	s3,8(sp)
    800024d0:	e052                	sd	s4,0(sp)
    800024d2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024d4:	00006597          	auipc	a1,0x6
    800024d8:	f5c58593          	addi	a1,a1,-164 # 80008430 <etext+0x430>
    800024dc:	0000f517          	auipc	a0,0xf
    800024e0:	21c50513          	addi	a0,a0,540 # 800116f8 <bcache>
    800024e4:	413030ef          	jal	800060f6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024e8:	00017797          	auipc	a5,0x17
    800024ec:	21078793          	addi	a5,a5,528 # 800196f8 <bcache+0x8000>
    800024f0:	00017717          	auipc	a4,0x17
    800024f4:	47070713          	addi	a4,a4,1136 # 80019960 <bcache+0x8268>
    800024f8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024fc:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002500:	0000f497          	auipc	s1,0xf
    80002504:	21048493          	addi	s1,s1,528 # 80011710 <bcache+0x18>
    b->next = bcache.head.next;
    80002508:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000250a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000250c:	00006a17          	auipc	s4,0x6
    80002510:	f2ca0a13          	addi	s4,s4,-212 # 80008438 <etext+0x438>
    b->next = bcache.head.next;
    80002514:	2b893783          	ld	a5,696(s2)
    80002518:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000251a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000251e:	85d2                	mv	a1,s4
    80002520:	01048513          	addi	a0,s1,16
    80002524:	40e010ef          	jal	80003932 <initsleeplock>
    bcache.head.next->prev = b;
    80002528:	2b893783          	ld	a5,696(s2)
    8000252c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000252e:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002532:	45848493          	addi	s1,s1,1112
    80002536:	fd349fe3          	bne	s1,s3,80002514 <binit+0x50>
  }
}
    8000253a:	70a2                	ld	ra,40(sp)
    8000253c:	7402                	ld	s0,32(sp)
    8000253e:	64e2                	ld	s1,24(sp)
    80002540:	6942                	ld	s2,16(sp)
    80002542:	69a2                	ld	s3,8(sp)
    80002544:	6a02                	ld	s4,0(sp)
    80002546:	6145                	addi	sp,sp,48
    80002548:	8082                	ret

000000008000254a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    8000254a:	7179                	addi	sp,sp,-48
    8000254c:	f406                	sd	ra,40(sp)
    8000254e:	f022                	sd	s0,32(sp)
    80002550:	ec26                	sd	s1,24(sp)
    80002552:	e84a                	sd	s2,16(sp)
    80002554:	e44e                	sd	s3,8(sp)
    80002556:	1800                	addi	s0,sp,48
    80002558:	892a                	mv	s2,a0
    8000255a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000255c:	0000f517          	auipc	a0,0xf
    80002560:	19c50513          	addi	a0,a0,412 # 800116f8 <bcache>
    80002564:	413030ef          	jal	80006176 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002568:	00017497          	auipc	s1,0x17
    8000256c:	4484b483          	ld	s1,1096(s1) # 800199b0 <bcache+0x82b8>
    80002570:	00017797          	auipc	a5,0x17
    80002574:	3f078793          	addi	a5,a5,1008 # 80019960 <bcache+0x8268>
    80002578:	02f48b63          	beq	s1,a5,800025ae <bread+0x64>
    8000257c:	873e                	mv	a4,a5
    8000257e:	a021                	j	80002586 <bread+0x3c>
    80002580:	68a4                	ld	s1,80(s1)
    80002582:	02e48663          	beq	s1,a4,800025ae <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002586:	449c                	lw	a5,8(s1)
    80002588:	ff279ce3          	bne	a5,s2,80002580 <bread+0x36>
    8000258c:	44dc                	lw	a5,12(s1)
    8000258e:	ff3799e3          	bne	a5,s3,80002580 <bread+0x36>
      b->refcnt++;
    80002592:	40bc                	lw	a5,64(s1)
    80002594:	2785                	addiw	a5,a5,1
    80002596:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002598:	0000f517          	auipc	a0,0xf
    8000259c:	16050513          	addi	a0,a0,352 # 800116f8 <bcache>
    800025a0:	45f030ef          	jal	800061fe <release>
      acquiresleep(&b->lock);
    800025a4:	01048513          	addi	a0,s1,16
    800025a8:	3c0010ef          	jal	80003968 <acquiresleep>
      return b;
    800025ac:	a889                	j	800025fe <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800025ae:	00017497          	auipc	s1,0x17
    800025b2:	3fa4b483          	ld	s1,1018(s1) # 800199a8 <bcache+0x82b0>
    800025b6:	00017797          	auipc	a5,0x17
    800025ba:	3aa78793          	addi	a5,a5,938 # 80019960 <bcache+0x8268>
    800025be:	00f48863          	beq	s1,a5,800025ce <bread+0x84>
    800025c2:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	cb91                	beqz	a5,800025da <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800025c8:	64a4                	ld	s1,72(s1)
    800025ca:	fee49de3          	bne	s1,a4,800025c4 <bread+0x7a>
  panic("bget: no buffers");
    800025ce:	00006517          	auipc	a0,0x6
    800025d2:	e7250513          	addi	a0,a0,-398 # 80008440 <etext+0x440>
    800025d6:	12f030ef          	jal	80005f04 <panic>
      b->dev = dev;
    800025da:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025de:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025e2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025e6:	4785                	li	a5,1
    800025e8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ea:	0000f517          	auipc	a0,0xf
    800025ee:	10e50513          	addi	a0,a0,270 # 800116f8 <bcache>
    800025f2:	40d030ef          	jal	800061fe <release>
      acquiresleep(&b->lock);
    800025f6:	01048513          	addi	a0,s1,16
    800025fa:	36e010ef          	jal	80003968 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    800025fe:	409c                	lw	a5,0(s1)
    80002600:	cb89                	beqz	a5,80002612 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002602:	8526                	mv	a0,s1
    80002604:	70a2                	ld	ra,40(sp)
    80002606:	7402                	ld	s0,32(sp)
    80002608:	64e2                	ld	s1,24(sp)
    8000260a:	6942                	ld	s2,16(sp)
    8000260c:	69a2                	ld	s3,8(sp)
    8000260e:	6145                	addi	sp,sp,48
    80002610:	8082                	ret
    virtio_disk_rw(b, 0);
    80002612:	4581                	li	a1,0
    80002614:	8526                	mv	a0,s1
    80002616:	48b020ef          	jal	800052a0 <virtio_disk_rw>
    b->valid = 1;
    8000261a:	4785                	li	a5,1
    8000261c:	c09c                	sw	a5,0(s1)
  return b;
    8000261e:	b7d5                	j	80002602 <bread+0xb8>

0000000080002620 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002620:	1101                	addi	sp,sp,-32
    80002622:	ec06                	sd	ra,24(sp)
    80002624:	e822                	sd	s0,16(sp)
    80002626:	e426                	sd	s1,8(sp)
    80002628:	1000                	addi	s0,sp,32
    8000262a:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    8000262c:	0541                	addi	a0,a0,16
    8000262e:	3c6010ef          	jal	800039f4 <holdingsleep>
    80002632:	c911                	beqz	a0,80002646 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002634:	4585                	li	a1,1
    80002636:	8526                	mv	a0,s1
    80002638:	469020ef          	jal	800052a0 <virtio_disk_rw>
}
    8000263c:	60e2                	ld	ra,24(sp)
    8000263e:	6442                	ld	s0,16(sp)
    80002640:	64a2                	ld	s1,8(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret
    panic("bwrite");
    80002646:	00006517          	auipc	a0,0x6
    8000264a:	e1250513          	addi	a0,a0,-494 # 80008458 <etext+0x458>
    8000264e:	0b7030ef          	jal	80005f04 <panic>

0000000080002652 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002652:	1101                	addi	sp,sp,-32
    80002654:	ec06                	sd	ra,24(sp)
    80002656:	e822                	sd	s0,16(sp)
    80002658:	e426                	sd	s1,8(sp)
    8000265a:	e04a                	sd	s2,0(sp)
    8000265c:	1000                	addi	s0,sp,32
    8000265e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002660:	01050913          	addi	s2,a0,16
    80002664:	854a                	mv	a0,s2
    80002666:	38e010ef          	jal	800039f4 <holdingsleep>
    8000266a:	c125                	beqz	a0,800026ca <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000266c:	854a                	mv	a0,s2
    8000266e:	34e010ef          	jal	800039bc <releasesleep>

  acquire(&bcache.lock);
    80002672:	0000f517          	auipc	a0,0xf
    80002676:	08650513          	addi	a0,a0,134 # 800116f8 <bcache>
    8000267a:	2fd030ef          	jal	80006176 <acquire>
  b->refcnt--;
    8000267e:	40bc                	lw	a5,64(s1)
    80002680:	37fd                	addiw	a5,a5,-1
    80002682:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002684:	e79d                	bnez	a5,800026b2 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002686:	68b8                	ld	a4,80(s1)
    80002688:	64bc                	ld	a5,72(s1)
    8000268a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000268c:	68b8                	ld	a4,80(s1)
    8000268e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002690:	00017797          	auipc	a5,0x17
    80002694:	06878793          	addi	a5,a5,104 # 800196f8 <bcache+0x8000>
    80002698:	2b87b703          	ld	a4,696(a5)
    8000269c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000269e:	00017717          	auipc	a4,0x17
    800026a2:	2c270713          	addi	a4,a4,706 # 80019960 <bcache+0x8268>
    800026a6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026a8:	2b87b703          	ld	a4,696(a5)
    800026ac:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026ae:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800026b2:	0000f517          	auipc	a0,0xf
    800026b6:	04650513          	addi	a0,a0,70 # 800116f8 <bcache>
    800026ba:	345030ef          	jal	800061fe <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6902                	ld	s2,0(sp)
    800026c6:	6105                	addi	sp,sp,32
    800026c8:	8082                	ret
    panic("brelse");
    800026ca:	00006517          	auipc	a0,0x6
    800026ce:	d9650513          	addi	a0,a0,-618 # 80008460 <etext+0x460>
    800026d2:	033030ef          	jal	80005f04 <panic>

00000000800026d6 <bpin>:

void
bpin(struct buf *b)
{
    800026d6:	1101                	addi	sp,sp,-32
    800026d8:	ec06                	sd	ra,24(sp)
    800026da:	e822                	sd	s0,16(sp)
    800026dc:	e426                	sd	s1,8(sp)
    800026de:	1000                	addi	s0,sp,32
    800026e0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e2:	0000f517          	auipc	a0,0xf
    800026e6:	01650513          	addi	a0,a0,22 # 800116f8 <bcache>
    800026ea:	28d030ef          	jal	80006176 <acquire>
  b->refcnt++;
    800026ee:	40bc                	lw	a5,64(s1)
    800026f0:	2785                	addiw	a5,a5,1
    800026f2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026f4:	0000f517          	auipc	a0,0xf
    800026f8:	00450513          	addi	a0,a0,4 # 800116f8 <bcache>
    800026fc:	303030ef          	jal	800061fe <release>
}
    80002700:	60e2                	ld	ra,24(sp)
    80002702:	6442                	ld	s0,16(sp)
    80002704:	64a2                	ld	s1,8(sp)
    80002706:	6105                	addi	sp,sp,32
    80002708:	8082                	ret

000000008000270a <bunpin>:

void
bunpin(struct buf *b)
{
    8000270a:	1101                	addi	sp,sp,-32
    8000270c:	ec06                	sd	ra,24(sp)
    8000270e:	e822                	sd	s0,16(sp)
    80002710:	e426                	sd	s1,8(sp)
    80002712:	1000                	addi	s0,sp,32
    80002714:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002716:	0000f517          	auipc	a0,0xf
    8000271a:	fe250513          	addi	a0,a0,-30 # 800116f8 <bcache>
    8000271e:	259030ef          	jal	80006176 <acquire>
  b->refcnt--;
    80002722:	40bc                	lw	a5,64(s1)
    80002724:	37fd                	addiw	a5,a5,-1
    80002726:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002728:	0000f517          	auipc	a0,0xf
    8000272c:	fd050513          	addi	a0,a0,-48 # 800116f8 <bcache>
    80002730:	2cf030ef          	jal	800061fe <release>
}
    80002734:	60e2                	ld	ra,24(sp)
    80002736:	6442                	ld	s0,16(sp)
    80002738:	64a2                	ld	s1,8(sp)
    8000273a:	6105                	addi	sp,sp,32
    8000273c:	8082                	ret

000000008000273e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000273e:	1101                	addi	sp,sp,-32
    80002740:	ec06                	sd	ra,24(sp)
    80002742:	e822                	sd	s0,16(sp)
    80002744:	e426                	sd	s1,8(sp)
    80002746:	e04a                	sd	s2,0(sp)
    80002748:	1000                	addi	s0,sp,32
    8000274a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000274c:	00d5d79b          	srliw	a5,a1,0xd
    80002750:	00017597          	auipc	a1,0x17
    80002754:	6845a583          	lw	a1,1668(a1) # 80019dd4 <sb+0x1c>
    80002758:	9dbd                	addw	a1,a1,a5
    8000275a:	df1ff0ef          	jal	8000254a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000275e:	0074f713          	andi	a4,s1,7
    80002762:	4785                	li	a5,1
    80002764:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002768:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    8000276a:	90d9                	srli	s1,s1,0x36
    8000276c:	00950733          	add	a4,a0,s1
    80002770:	05874703          	lbu	a4,88(a4)
    80002774:	00e7f6b3          	and	a3,a5,a4
    80002778:	c29d                	beqz	a3,8000279e <bfree+0x60>
    8000277a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    8000277c:	94aa                	add	s1,s1,a0
    8000277e:	fff7c793          	not	a5,a5
    80002782:	8f7d                	and	a4,a4,a5
    80002784:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002788:	072010ef          	jal	800037fa <log_write>
  brelse(bp);
    8000278c:	854a                	mv	a0,s2
    8000278e:	ec5ff0ef          	jal	80002652 <brelse>
}
    80002792:	60e2                	ld	ra,24(sp)
    80002794:	6442                	ld	s0,16(sp)
    80002796:	64a2                	ld	s1,8(sp)
    80002798:	6902                	ld	s2,0(sp)
    8000279a:	6105                	addi	sp,sp,32
    8000279c:	8082                	ret
    panic("freeing free block");
    8000279e:	00006517          	auipc	a0,0x6
    800027a2:	cca50513          	addi	a0,a0,-822 # 80008468 <etext+0x468>
    800027a6:	75e030ef          	jal	80005f04 <panic>

00000000800027aa <balloc>:
{
    800027aa:	715d                	addi	sp,sp,-80
    800027ac:	e486                	sd	ra,72(sp)
    800027ae:	e0a2                	sd	s0,64(sp)
    800027b0:	fc26                	sd	s1,56(sp)
    800027b2:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    800027b4:	00017797          	auipc	a5,0x17
    800027b8:	6087a783          	lw	a5,1544(a5) # 80019dbc <sb+0x4>
    800027bc:	0e078263          	beqz	a5,800028a0 <balloc+0xf6>
    800027c0:	f84a                	sd	s2,48(sp)
    800027c2:	f44e                	sd	s3,40(sp)
    800027c4:	f052                	sd	s4,32(sp)
    800027c6:	ec56                	sd	s5,24(sp)
    800027c8:	e85a                	sd	s6,16(sp)
    800027ca:	e45e                	sd	s7,8(sp)
    800027cc:	e062                	sd	s8,0(sp)
    800027ce:	8baa                	mv	s7,a0
    800027d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027d2:	00017b17          	auipc	s6,0x17
    800027d6:	5e6b0b13          	addi	s6,s6,1510 # 80019db8 <sb>
      m = 1 << (bi % 8);
    800027da:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027dc:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    800027de:	6c09                	lui	s8,0x2
    800027e0:	a09d                	j	80002846 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    800027e2:	97ca                	add	a5,a5,s2
    800027e4:	8e55                	or	a2,a2,a3
    800027e6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027ea:	854a                	mv	a0,s2
    800027ec:	00e010ef          	jal	800037fa <log_write>
        brelse(bp);
    800027f0:	854a                	mv	a0,s2
    800027f2:	e61ff0ef          	jal	80002652 <brelse>
  bp = bread(dev, bno);
    800027f6:	85a6                	mv	a1,s1
    800027f8:	855e                	mv	a0,s7
    800027fa:	d51ff0ef          	jal	8000254a <bread>
    800027fe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002800:	40000613          	li	a2,1024
    80002804:	4581                	li	a1,0
    80002806:	05850513          	addi	a0,a0,88
    8000280a:	955fd0ef          	jal	8000015e <memset>
  log_write(bp);
    8000280e:	854a                	mv	a0,s2
    80002810:	7eb000ef          	jal	800037fa <log_write>
  brelse(bp);
    80002814:	854a                	mv	a0,s2
    80002816:	e3dff0ef          	jal	80002652 <brelse>
}
    8000281a:	7942                	ld	s2,48(sp)
    8000281c:	79a2                	ld	s3,40(sp)
    8000281e:	7a02                	ld	s4,32(sp)
    80002820:	6ae2                	ld	s5,24(sp)
    80002822:	6b42                	ld	s6,16(sp)
    80002824:	6ba2                	ld	s7,8(sp)
    80002826:	6c02                	ld	s8,0(sp)
}
    80002828:	8526                	mv	a0,s1
    8000282a:	60a6                	ld	ra,72(sp)
    8000282c:	6406                	ld	s0,64(sp)
    8000282e:	74e2                	ld	s1,56(sp)
    80002830:	6161                	addi	sp,sp,80
    80002832:	8082                	ret
    brelse(bp);
    80002834:	854a                	mv	a0,s2
    80002836:	e1dff0ef          	jal	80002652 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    8000283a:	015c0abb          	addw	s5,s8,s5
    8000283e:	004b2783          	lw	a5,4(s6)
    80002842:	04faf863          	bgeu	s5,a5,80002892 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002846:	40dad59b          	sraiw	a1,s5,0xd
    8000284a:	01cb2783          	lw	a5,28(s6)
    8000284e:	9dbd                	addw	a1,a1,a5
    80002850:	855e                	mv	a0,s7
    80002852:	cf9ff0ef          	jal	8000254a <bread>
    80002856:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002858:	004b2503          	lw	a0,4(s6)
    8000285c:	84d6                	mv	s1,s5
    8000285e:	4701                	li	a4,0
    80002860:	fca4fae3          	bgeu	s1,a0,80002834 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002864:	00777693          	andi	a3,a4,7
    80002868:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    8000286c:	41f7579b          	sraiw	a5,a4,0x1f
    80002870:	01d7d79b          	srliw	a5,a5,0x1d
    80002874:	9fb9                	addw	a5,a5,a4
    80002876:	4037d79b          	sraiw	a5,a5,0x3
    8000287a:	00f90633          	add	a2,s2,a5
    8000287e:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002882:	00c6f5b3          	and	a1,a3,a2
    80002886:	ddb1                	beqz	a1,800027e2 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002888:	2705                	addiw	a4,a4,1
    8000288a:	2485                	addiw	s1,s1,1
    8000288c:	fd471ae3          	bne	a4,s4,80002860 <balloc+0xb6>
    80002890:	b755                	j	80002834 <balloc+0x8a>
    80002892:	7942                	ld	s2,48(sp)
    80002894:	79a2                	ld	s3,40(sp)
    80002896:	7a02                	ld	s4,32(sp)
    80002898:	6ae2                	ld	s5,24(sp)
    8000289a:	6b42                	ld	s6,16(sp)
    8000289c:	6ba2                	ld	s7,8(sp)
    8000289e:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	be050513          	addi	a0,a0,-1056 # 80008480 <etext+0x480>
    800028a8:	332030ef          	jal	80005bda <printk>
  return 0;
    800028ac:	4481                	li	s1,0
    800028ae:	bfad                	j	80002828 <balloc+0x7e>

00000000800028b0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800028b0:	7179                	addi	sp,sp,-48
    800028b2:	f406                	sd	ra,40(sp)
    800028b4:	f022                	sd	s0,32(sp)
    800028b6:	ec26                	sd	s1,24(sp)
    800028b8:	e84a                	sd	s2,16(sp)
    800028ba:	e44e                	sd	s3,8(sp)
    800028bc:	1800                	addi	s0,sp,48
    800028be:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    800028c0:	47ad                	li	a5,11
    800028c2:	02b7e363          	bltu	a5,a1,800028e8 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    800028c6:	02059793          	slli	a5,a1,0x20
    800028ca:	01e7d593          	srli	a1,a5,0x1e
    800028ce:	00b509b3          	add	s3,a0,a1
    800028d2:	0509a483          	lw	s1,80(s3)
    800028d6:	e0b5                	bnez	s1,8000293a <bmap+0x8a>
      addr = balloc(ip->dev);
    800028d8:	4108                	lw	a0,0(a0)
    800028da:	ed1ff0ef          	jal	800027aa <balloc>
    800028de:	84aa                	mv	s1,a0
      if (addr == 0)
    800028e0:	cd29                	beqz	a0,8000293a <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800028e2:	04a9a823          	sw	a0,80(s3)
    800028e6:	a891                	j	8000293a <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028e8:	ff45879b          	addiw	a5,a1,-12
    800028ec:	873e                	mv	a4,a5
    800028ee:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    800028f0:	0ff00793          	li	a5,255
    800028f4:	06e7e763          	bltu	a5,a4,80002962 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    800028f8:	08052483          	lw	s1,128(a0)
    800028fc:	e891                	bnez	s1,80002910 <bmap+0x60>
      addr = balloc(ip->dev);
    800028fe:	4108                	lw	a0,0(a0)
    80002900:	eabff0ef          	jal	800027aa <balloc>
    80002904:	84aa                	mv	s1,a0
      if (addr == 0)
    80002906:	c915                	beqz	a0,8000293a <bmap+0x8a>
    80002908:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000290a:	08a92023          	sw	a0,128(s2)
    8000290e:	a011                	j	80002912 <bmap+0x62>
    80002910:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002912:	85a6                	mv	a1,s1
    80002914:	00092503          	lw	a0,0(s2)
    80002918:	c33ff0ef          	jal	8000254a <bread>
    8000291c:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000291e:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002922:	02099713          	slli	a4,s3,0x20
    80002926:	01e75593          	srli	a1,a4,0x1e
    8000292a:	97ae                	add	a5,a5,a1
    8000292c:	89be                	mv	s3,a5
    8000292e:	4384                	lw	s1,0(a5)
    80002930:	cc89                	beqz	s1,8000294a <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002932:	8552                	mv	a0,s4
    80002934:	d1fff0ef          	jal	80002652 <brelse>
    return addr;
    80002938:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000293a:	8526                	mv	a0,s1
    8000293c:	70a2                	ld	ra,40(sp)
    8000293e:	7402                	ld	s0,32(sp)
    80002940:	64e2                	ld	s1,24(sp)
    80002942:	6942                	ld	s2,16(sp)
    80002944:	69a2                	ld	s3,8(sp)
    80002946:	6145                	addi	sp,sp,48
    80002948:	8082                	ret
      addr = balloc(ip->dev);
    8000294a:	00092503          	lw	a0,0(s2)
    8000294e:	e5dff0ef          	jal	800027aa <balloc>
    80002952:	84aa                	mv	s1,a0
      if (addr) {
    80002954:	dd79                	beqz	a0,80002932 <bmap+0x82>
        a[bn] = addr;
    80002956:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000295a:	8552                	mv	a0,s4
    8000295c:	69f000ef          	jal	800037fa <log_write>
    80002960:	bfc9                	j	80002932 <bmap+0x82>
    80002962:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002964:	00006517          	auipc	a0,0x6
    80002968:	b3450513          	addi	a0,a0,-1228 # 80008498 <etext+0x498>
    8000296c:	598030ef          	jal	80005f04 <panic>

0000000080002970 <iget>:
{
    80002970:	7179                	addi	sp,sp,-48
    80002972:	f406                	sd	ra,40(sp)
    80002974:	f022                	sd	s0,32(sp)
    80002976:	ec26                	sd	s1,24(sp)
    80002978:	e84a                	sd	s2,16(sp)
    8000297a:	e44e                	sd	s3,8(sp)
    8000297c:	e052                	sd	s4,0(sp)
    8000297e:	1800                	addi	s0,sp,48
    80002980:	892a                	mv	s2,a0
    80002982:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002984:	00017517          	auipc	a0,0x17
    80002988:	45450513          	addi	a0,a0,1108 # 80019dd8 <itable>
    8000298c:	7ea030ef          	jal	80006176 <acquire>
  empty = 0;
    80002990:	4981                	li	s3,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002992:	00017497          	auipc	s1,0x17
    80002996:	45e48493          	addi	s1,s1,1118 # 80019df0 <itable+0x18>
    8000299a:	00019697          	auipc	a3,0x19
    8000299e:	ee668693          	addi	a3,a3,-282 # 8001b880 <log>
    800029a2:	a809                	j	800029b4 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800029a4:	e781                	bnez	a5,800029ac <iget+0x3c>
    800029a6:	00099363          	bnez	s3,800029ac <iget+0x3c>
      empty = ip;
    800029aa:	89a6                	mv	s3,s1
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800029ac:	08848493          	addi	s1,s1,136
    800029b0:	02d48563          	beq	s1,a3,800029da <iget+0x6a>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    800029b4:	449c                	lw	a5,8(s1)
    800029b6:	fef057e3          	blez	a5,800029a4 <iget+0x34>
    800029ba:	4098                	lw	a4,0(s1)
    800029bc:	ff2718e3          	bne	a4,s2,800029ac <iget+0x3c>
    800029c0:	40d8                	lw	a4,4(s1)
    800029c2:	ff4715e3          	bne	a4,s4,800029ac <iget+0x3c>
      ip->ref++;
    800029c6:	2785                	addiw	a5,a5,1
    800029c8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029ca:	00017517          	auipc	a0,0x17
    800029ce:	40e50513          	addi	a0,a0,1038 # 80019dd8 <itable>
    800029d2:	02d030ef          	jal	800061fe <release>
      return ip;
    800029d6:	89a6                	mv	s3,s1
    800029d8:	a015                	j	800029fc <iget+0x8c>
  if (empty == 0)
    800029da:	02098a63          	beqz	s3,80002a0e <iget+0x9e>
  ip->dev = dev;
    800029de:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800029e2:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    800029e6:	4785                	li	a5,1
    800029e8:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800029ec:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    800029f0:	00017517          	auipc	a0,0x17
    800029f4:	3e850513          	addi	a0,a0,1000 # 80019dd8 <itable>
    800029f8:	007030ef          	jal	800061fe <release>
}
    800029fc:	854e                	mv	a0,s3
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6a02                	ld	s4,0(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
    panic("iget: no inodes");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	aa250513          	addi	a0,a0,-1374 # 800084b0 <etext+0x4b0>
    80002a16:	4ee030ef          	jal	80005f04 <panic>

0000000080002a1a <iinit>:
{
    80002a1a:	7179                	addi	sp,sp,-48
    80002a1c:	f406                	sd	ra,40(sp)
    80002a1e:	f022                	sd	s0,32(sp)
    80002a20:	ec26                	sd	s1,24(sp)
    80002a22:	e84a                	sd	s2,16(sp)
    80002a24:	e44e                	sd	s3,8(sp)
    80002a26:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a28:	00006597          	auipc	a1,0x6
    80002a2c:	a9858593          	addi	a1,a1,-1384 # 800084c0 <etext+0x4c0>
    80002a30:	00017517          	auipc	a0,0x17
    80002a34:	3a850513          	addi	a0,a0,936 # 80019dd8 <itable>
    80002a38:	6be030ef          	jal	800060f6 <initlock>
  for (i = 0; i < NINODE; i++) {
    80002a3c:	00017497          	auipc	s1,0x17
    80002a40:	3c448493          	addi	s1,s1,964 # 80019e00 <itable+0x28>
    80002a44:	00019997          	auipc	s3,0x19
    80002a48:	e4c98993          	addi	s3,s3,-436 # 8001b890 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a4c:	00006917          	auipc	s2,0x6
    80002a50:	a7c90913          	addi	s2,s2,-1412 # 800084c8 <etext+0x4c8>
    80002a54:	85ca                	mv	a1,s2
    80002a56:	8526                	mv	a0,s1
    80002a58:	6db000ef          	jal	80003932 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002a5c:	08848493          	addi	s1,s1,136
    80002a60:	ff349ae3          	bne	s1,s3,80002a54 <iinit+0x3a>
}
    80002a64:	70a2                	ld	ra,40(sp)
    80002a66:	7402                	ld	s0,32(sp)
    80002a68:	64e2                	ld	s1,24(sp)
    80002a6a:	6942                	ld	s2,16(sp)
    80002a6c:	69a2                	ld	s3,8(sp)
    80002a6e:	6145                	addi	sp,sp,48
    80002a70:	8082                	ret

0000000080002a72 <ialloc>:
{
    80002a72:	7139                	addi	sp,sp,-64
    80002a74:	fc06                	sd	ra,56(sp)
    80002a76:	f822                	sd	s0,48(sp)
    80002a78:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002a7a:	00017717          	auipc	a4,0x17
    80002a7e:	34a72703          	lw	a4,842(a4) # 80019dc4 <sb+0xc>
    80002a82:	4785                	li	a5,1
    80002a84:	06e7f063          	bgeu	a5,a4,80002ae4 <ialloc+0x72>
    80002a88:	f426                	sd	s1,40(sp)
    80002a8a:	f04a                	sd	s2,32(sp)
    80002a8c:	ec4e                	sd	s3,24(sp)
    80002a8e:	e852                	sd	s4,16(sp)
    80002a90:	e456                	sd	s5,8(sp)
    80002a92:	e05a                	sd	s6,0(sp)
    80002a94:	8aaa                	mv	s5,a0
    80002a96:	8b2e                	mv	s6,a1
    80002a98:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002a9a:	00017a17          	auipc	s4,0x17
    80002a9e:	31ea0a13          	addi	s4,s4,798 # 80019db8 <sb>
    80002aa2:	00495593          	srli	a1,s2,0x4
    80002aa6:	018a2783          	lw	a5,24(s4)
    80002aaa:	9dbd                	addw	a1,a1,a5
    80002aac:	8556                	mv	a0,s5
    80002aae:	a9dff0ef          	jal	8000254a <bread>
    80002ab2:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002ab4:	05850993          	addi	s3,a0,88
    80002ab8:	00f97793          	andi	a5,s2,15
    80002abc:	079a                	slli	a5,a5,0x6
    80002abe:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80002ac0:	00099783          	lh	a5,0(s3)
    80002ac4:	cb9d                	beqz	a5,80002afa <ialloc+0x88>
    brelse(bp);
    80002ac6:	b8dff0ef          	jal	80002652 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002aca:	0905                	addi	s2,s2,1
    80002acc:	00ca2703          	lw	a4,12(s4)
    80002ad0:	0009079b          	sext.w	a5,s2
    80002ad4:	fce7e7e3          	bltu	a5,a4,80002aa2 <ialloc+0x30>
    80002ad8:	74a2                	ld	s1,40(sp)
    80002ada:	7902                	ld	s2,32(sp)
    80002adc:	69e2                	ld	s3,24(sp)
    80002ade:	6a42                	ld	s4,16(sp)
    80002ae0:	6aa2                	ld	s5,8(sp)
    80002ae2:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	9ec50513          	addi	a0,a0,-1556 # 800084d0 <etext+0x4d0>
    80002aec:	0ee030ef          	jal	80005bda <printk>
  return 0;
    80002af0:	4501                	li	a0,0
}
    80002af2:	70e2                	ld	ra,56(sp)
    80002af4:	7442                	ld	s0,48(sp)
    80002af6:	6121                	addi	sp,sp,64
    80002af8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002afa:	04000613          	li	a2,64
    80002afe:	4581                	li	a1,0
    80002b00:	854e                	mv	a0,s3
    80002b02:	e5cfd0ef          	jal	8000015e <memset>
      dip->type = type;
    80002b06:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80002b0a:	8526                	mv	a0,s1
    80002b0c:	4ef000ef          	jal	800037fa <log_write>
      brelse(bp);
    80002b10:	8526                	mv	a0,s1
    80002b12:	b41ff0ef          	jal	80002652 <brelse>
      return iget(dev, inum);
    80002b16:	0009059b          	sext.w	a1,s2
    80002b1a:	8556                	mv	a0,s5
    80002b1c:	e55ff0ef          	jal	80002970 <iget>
    80002b20:	74a2                	ld	s1,40(sp)
    80002b22:	7902                	ld	s2,32(sp)
    80002b24:	69e2                	ld	s3,24(sp)
    80002b26:	6a42                	ld	s4,16(sp)
    80002b28:	6aa2                	ld	s5,8(sp)
    80002b2a:	6b02                	ld	s6,0(sp)
    80002b2c:	b7d9                	j	80002af2 <ialloc+0x80>

0000000080002b2e <iupdate>:
{
    80002b2e:	1101                	addi	sp,sp,-32
    80002b30:	ec06                	sd	ra,24(sp)
    80002b32:	e822                	sd	s0,16(sp)
    80002b34:	e426                	sd	s1,8(sp)
    80002b36:	e04a                	sd	s2,0(sp)
    80002b38:	1000                	addi	s0,sp,32
    80002b3a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b3c:	415c                	lw	a5,4(a0)
    80002b3e:	0047d79b          	srliw	a5,a5,0x4
    80002b42:	00017597          	auipc	a1,0x17
    80002b46:	28e5a583          	lw	a1,654(a1) # 80019dd0 <sb+0x18>
    80002b4a:	9dbd                	addw	a1,a1,a5
    80002b4c:	4108                	lw	a0,0(a0)
    80002b4e:	9fdff0ef          	jal	8000254a <bread>
    80002b52:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b54:	05850793          	addi	a5,a0,88
    80002b58:	40d8                	lw	a4,4(s1)
    80002b5a:	8b3d                	andi	a4,a4,15
    80002b5c:	071a                	slli	a4,a4,0x6
    80002b5e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b60:	04449703          	lh	a4,68(s1)
    80002b64:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b68:	04649703          	lh	a4,70(s1)
    80002b6c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b70:	04849703          	lh	a4,72(s1)
    80002b74:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b78:	04a49703          	lh	a4,74(s1)
    80002b7c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b80:	44f8                	lw	a4,76(s1)
    80002b82:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b84:	03400613          	li	a2,52
    80002b88:	05048593          	addi	a1,s1,80
    80002b8c:	00c78513          	addi	a0,a5,12
    80002b90:	e2efd0ef          	jal	800001be <memmove>
  log_write(bp);
    80002b94:	854a                	mv	a0,s2
    80002b96:	465000ef          	jal	800037fa <log_write>
  brelse(bp);
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	ab7ff0ef          	jal	80002652 <brelse>
}
    80002ba0:	60e2                	ld	ra,24(sp)
    80002ba2:	6442                	ld	s0,16(sp)
    80002ba4:	64a2                	ld	s1,8(sp)
    80002ba6:	6902                	ld	s2,0(sp)
    80002ba8:	6105                	addi	sp,sp,32
    80002baa:	8082                	ret

0000000080002bac <idup>:
{
    80002bac:	1101                	addi	sp,sp,-32
    80002bae:	ec06                	sd	ra,24(sp)
    80002bb0:	e822                	sd	s0,16(sp)
    80002bb2:	e426                	sd	s1,8(sp)
    80002bb4:	1000                	addi	s0,sp,32
    80002bb6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bb8:	00017517          	auipc	a0,0x17
    80002bbc:	22050513          	addi	a0,a0,544 # 80019dd8 <itable>
    80002bc0:	5b6030ef          	jal	80006176 <acquire>
  ip->ref++;
    80002bc4:	449c                	lw	a5,8(s1)
    80002bc6:	2785                	addiw	a5,a5,1
    80002bc8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bca:	00017517          	auipc	a0,0x17
    80002bce:	20e50513          	addi	a0,a0,526 # 80019dd8 <itable>
    80002bd2:	62c030ef          	jal	800061fe <release>
}
    80002bd6:	8526                	mv	a0,s1
    80002bd8:	60e2                	ld	ra,24(sp)
    80002bda:	6442                	ld	s0,16(sp)
    80002bdc:	64a2                	ld	s1,8(sp)
    80002bde:	6105                	addi	sp,sp,32
    80002be0:	8082                	ret

0000000080002be2 <ilock>:
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80002bec:	cd19                	beqz	a0,80002c0a <ilock+0x28>
    80002bee:	84aa                	mv	s1,a0
    80002bf0:	451c                	lw	a5,8(a0)
    80002bf2:	00f05c63          	blez	a5,80002c0a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002bf6:	0541                	addi	a0,a0,16
    80002bf8:	571000ef          	jal	80003968 <acquiresleep>
  if (ip->valid == 0) {
    80002bfc:	40bc                	lw	a5,64(s1)
    80002bfe:	cf89                	beqz	a5,80002c18 <ilock+0x36>
}
    80002c00:	60e2                	ld	ra,24(sp)
    80002c02:	6442                	ld	s0,16(sp)
    80002c04:	64a2                	ld	s1,8(sp)
    80002c06:	6105                	addi	sp,sp,32
    80002c08:	8082                	ret
    80002c0a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c0c:	00006517          	auipc	a0,0x6
    80002c10:	8dc50513          	addi	a0,a0,-1828 # 800084e8 <etext+0x4e8>
    80002c14:	2f0030ef          	jal	80005f04 <panic>
    80002c18:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c1a:	40dc                	lw	a5,4(s1)
    80002c1c:	0047d79b          	srliw	a5,a5,0x4
    80002c20:	00017597          	auipc	a1,0x17
    80002c24:	1b05a583          	lw	a1,432(a1) # 80019dd0 <sb+0x18>
    80002c28:	9dbd                	addw	a1,a1,a5
    80002c2a:	4088                	lw	a0,0(s1)
    80002c2c:	91fff0ef          	jal	8000254a <bread>
    80002c30:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c32:	05850593          	addi	a1,a0,88
    80002c36:	40dc                	lw	a5,4(s1)
    80002c38:	8bbd                	andi	a5,a5,15
    80002c3a:	079a                	slli	a5,a5,0x6
    80002c3c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c3e:	00059783          	lh	a5,0(a1)
    80002c42:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c46:	00259783          	lh	a5,2(a1)
    80002c4a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c4e:	00459783          	lh	a5,4(a1)
    80002c52:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c56:	00659783          	lh	a5,6(a1)
    80002c5a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c5e:	459c                	lw	a5,8(a1)
    80002c60:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c62:	03400613          	li	a2,52
    80002c66:	05b1                	addi	a1,a1,12
    80002c68:	05048513          	addi	a0,s1,80
    80002c6c:	d52fd0ef          	jal	800001be <memmove>
    brelse(bp);
    80002c70:	854a                	mv	a0,s2
    80002c72:	9e1ff0ef          	jal	80002652 <brelse>
    ip->valid = 1;
    80002c76:	4785                	li	a5,1
    80002c78:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80002c7a:	04449783          	lh	a5,68(s1)
    80002c7e:	c399                	beqz	a5,80002c84 <ilock+0xa2>
    80002c80:	6902                	ld	s2,0(sp)
    80002c82:	bfbd                	j	80002c00 <ilock+0x1e>
      panic("ilock: no type");
    80002c84:	00006517          	auipc	a0,0x6
    80002c88:	86c50513          	addi	a0,a0,-1940 # 800084f0 <etext+0x4f0>
    80002c8c:	278030ef          	jal	80005f04 <panic>

0000000080002c90 <iunlock>:
{
    80002c90:	1101                	addi	sp,sp,-32
    80002c92:	ec06                	sd	ra,24(sp)
    80002c94:	e822                	sd	s0,16(sp)
    80002c96:	e426                	sd	s1,8(sp)
    80002c98:	e04a                	sd	s2,0(sp)
    80002c9a:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c9c:	c505                	beqz	a0,80002cc4 <iunlock+0x34>
    80002c9e:	84aa                	mv	s1,a0
    80002ca0:	01050913          	addi	s2,a0,16
    80002ca4:	854a                	mv	a0,s2
    80002ca6:	54f000ef          	jal	800039f4 <holdingsleep>
    80002caa:	cd09                	beqz	a0,80002cc4 <iunlock+0x34>
    80002cac:	449c                	lw	a5,8(s1)
    80002cae:	00f05b63          	blez	a5,80002cc4 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002cb2:	854a                	mv	a0,s2
    80002cb4:	509000ef          	jal	800039bc <releasesleep>
}
    80002cb8:	60e2                	ld	ra,24(sp)
    80002cba:	6442                	ld	s0,16(sp)
    80002cbc:	64a2                	ld	s1,8(sp)
    80002cbe:	6902                	ld	s2,0(sp)
    80002cc0:	6105                	addi	sp,sp,32
    80002cc2:	8082                	ret
    panic("iunlock");
    80002cc4:	00006517          	auipc	a0,0x6
    80002cc8:	83c50513          	addi	a0,a0,-1988 # 80008500 <etext+0x500>
    80002ccc:	238030ef          	jal	80005f04 <panic>

0000000080002cd0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cd0:	7179                	addi	sp,sp,-48
    80002cd2:	f406                	sd	ra,40(sp)
    80002cd4:	f022                	sd	s0,32(sp)
    80002cd6:	ec26                	sd	s1,24(sp)
    80002cd8:	e84a                	sd	s2,16(sp)
    80002cda:	e44e                	sd	s3,8(sp)
    80002cdc:	1800                	addi	s0,sp,48
    80002cde:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002ce0:	05050493          	addi	s1,a0,80
    80002ce4:	08050913          	addi	s2,a0,128
    80002ce8:	a021                	j	80002cf0 <itrunc+0x20>
    80002cea:	0491                	addi	s1,s1,4
    80002cec:	01248b63          	beq	s1,s2,80002d02 <itrunc+0x32>
    if (ip->addrs[i]) {
    80002cf0:	408c                	lw	a1,0(s1)
    80002cf2:	dde5                	beqz	a1,80002cea <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002cf4:	0009a503          	lw	a0,0(s3)
    80002cf8:	a47ff0ef          	jal	8000273e <bfree>
      ip->addrs[i] = 0;
    80002cfc:	0004a023          	sw	zero,0(s1)
    80002d00:	b7ed                	j	80002cea <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002d02:	0809a583          	lw	a1,128(s3)
    80002d06:	ed89                	bnez	a1,80002d20 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d08:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d0c:	854e                	mv	a0,s3
    80002d0e:	e21ff0ef          	jal	80002b2e <iupdate>
}
    80002d12:	70a2                	ld	ra,40(sp)
    80002d14:	7402                	ld	s0,32(sp)
    80002d16:	64e2                	ld	s1,24(sp)
    80002d18:	6942                	ld	s2,16(sp)
    80002d1a:	69a2                	ld	s3,8(sp)
    80002d1c:	6145                	addi	sp,sp,48
    80002d1e:	8082                	ret
    80002d20:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d22:	0009a503          	lw	a0,0(s3)
    80002d26:	825ff0ef          	jal	8000254a <bread>
    80002d2a:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002d2c:	05850493          	addi	s1,a0,88
    80002d30:	45850913          	addi	s2,a0,1112
    80002d34:	a021                	j	80002d3c <itrunc+0x6c>
    80002d36:	0491                	addi	s1,s1,4
    80002d38:	01248963          	beq	s1,s2,80002d4a <itrunc+0x7a>
      if (a[j])
    80002d3c:	408c                	lw	a1,0(s1)
    80002d3e:	dde5                	beqz	a1,80002d36 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002d40:	0009a503          	lw	a0,0(s3)
    80002d44:	9fbff0ef          	jal	8000273e <bfree>
    80002d48:	b7fd                	j	80002d36 <itrunc+0x66>
    brelse(bp);
    80002d4a:	8552                	mv	a0,s4
    80002d4c:	907ff0ef          	jal	80002652 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d50:	0809a583          	lw	a1,128(s3)
    80002d54:	0009a503          	lw	a0,0(s3)
    80002d58:	9e7ff0ef          	jal	8000273e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d5c:	0809a023          	sw	zero,128(s3)
    80002d60:	6a02                	ld	s4,0(sp)
    80002d62:	b75d                	j	80002d08 <itrunc+0x38>

0000000080002d64 <iput>:
{
    80002d64:	7179                	addi	sp,sp,-48
    80002d66:	f406                	sd	ra,40(sp)
    80002d68:	f022                	sd	s0,32(sp)
    80002d6a:	ec26                	sd	s1,24(sp)
    80002d6c:	1800                	addi	s0,sp,48
    80002d6e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d70:	00017517          	auipc	a0,0x17
    80002d74:	06850513          	addi	a0,a0,104 # 80019dd8 <itable>
    80002d78:	3fe030ef          	jal	80006176 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80002d7c:	449c                	lw	a5,8(s1)
    80002d7e:	4705                	li	a4,1
    80002d80:	00e78f63          	beq	a5,a4,80002d9e <iput+0x3a>
  ip->ref--;
    80002d84:	37fd                	addiw	a5,a5,-1
    80002d86:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d88:	00017517          	auipc	a0,0x17
    80002d8c:	05050513          	addi	a0,a0,80 # 80019dd8 <itable>
    80002d90:	46e030ef          	jal	800061fe <release>
}
    80002d94:	70a2                	ld	ra,40(sp)
    80002d96:	7402                	ld	s0,32(sp)
    80002d98:	64e2                	ld	s1,24(sp)
    80002d9a:	6145                	addi	sp,sp,48
    80002d9c:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80002d9e:	40b8                	lw	a4,64(s1)
    80002da0:	d375                	beqz	a4,80002d84 <iput+0x20>
    80002da2:	e84a                	sd	s2,16(sp)
    80002da4:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80002da6:	0004aa03          	lw	s4,0(s1)
    80002daa:	0044a903          	lw	s2,4(s1)
  if (last) {
    80002dae:	04a49703          	lh	a4,74(s1)
    80002db2:	ef3d                	bnez	a4,80002e30 <iput+0xcc>
    80002db4:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80002db6:	01048793          	addi	a5,s1,16
    80002dba:	89be                	mv	s3,a5
    80002dbc:	853e                	mv	a0,a5
    80002dbe:	3ab000ef          	jal	80003968 <acquiresleep>
    release(&itable.lock);
    80002dc2:	00017517          	auipc	a0,0x17
    80002dc6:	01650513          	addi	a0,a0,22 # 80019dd8 <itable>
    80002dca:	434030ef          	jal	800061fe <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    80002dce:	8526                	mv	a0,s1
    80002dd0:	f01ff0ef          	jal	80002cd0 <itrunc>
    ip->valid = 0;
    80002dd4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dd8:	854e                	mv	a0,s3
    80002dda:	3e3000ef          	jal	800039bc <releasesleep>
    acquire(&itable.lock);
    80002dde:	00017517          	auipc	a0,0x17
    80002de2:	ffa50513          	addi	a0,a0,-6 # 80019dd8 <itable>
    80002de6:	390030ef          	jal	80006176 <acquire>
  ip->ref--;
    80002dea:	449c                	lw	a5,8(s1)
    80002dec:	37fd                	addiw	a5,a5,-1
    80002dee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002df0:	00017517          	auipc	a0,0x17
    80002df4:	fe850513          	addi	a0,a0,-24 # 80019dd8 <itable>
    80002df8:	406030ef          	jal	800061fe <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002dfc:	0049579b          	srliw	a5,s2,0x4
    80002e00:	00017597          	auipc	a1,0x17
    80002e04:	fd05a583          	lw	a1,-48(a1) # 80019dd0 <sb+0x18>
    80002e08:	9dbd                	addw	a1,a1,a5
    80002e0a:	8552                	mv	a0,s4
    80002e0c:	f3eff0ef          	jal	8000254a <bread>
    80002e10:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002e12:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    80002e16:	079a                	slli	a5,a5,0x6
    80002e18:	97aa                	add	a5,a5,a0
    80002e1a:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    80002e1e:	1dd000ef          	jal	800037fa <log_write>
  brelse(bp);
    80002e22:	8526                	mv	a0,s1
    80002e24:	82fff0ef          	jal	80002652 <brelse>
}
    80002e28:	6942                	ld	s2,16(sp)
    80002e2a:	69a2                	ld	s3,8(sp)
    80002e2c:	6a02                	ld	s4,0(sp)
    80002e2e:	b79d                	j	80002d94 <iput+0x30>
    80002e30:	6942                	ld	s2,16(sp)
    80002e32:	6a02                	ld	s4,0(sp)
    80002e34:	bf81                	j	80002d84 <iput+0x20>

0000000080002e36 <iunlockput>:
{
    80002e36:	1101                	addi	sp,sp,-32
    80002e38:	ec06                	sd	ra,24(sp)
    80002e3a:	e822                	sd	s0,16(sp)
    80002e3c:	e426                	sd	s1,8(sp)
    80002e3e:	1000                	addi	s0,sp,32
    80002e40:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e42:	e4fff0ef          	jal	80002c90 <iunlock>
  iput(ip);
    80002e46:	8526                	mv	a0,s1
    80002e48:	f1dff0ef          	jal	80002d64 <iput>
}
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	64a2                	ld	s1,8(sp)
    80002e52:	6105                	addi	sp,sp,32
    80002e54:	8082                	ret

0000000080002e56 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002e56:	00017717          	auipc	a4,0x17
    80002e5a:	f6e72703          	lw	a4,-146(a4) # 80019dc4 <sb+0xc>
    80002e5e:	4785                	li	a5,1
    80002e60:	0ae7fe63          	bgeu	a5,a4,80002f1c <ireclaim+0xc6>
{
    80002e64:	7139                	addi	sp,sp,-64
    80002e66:	fc06                	sd	ra,56(sp)
    80002e68:	f822                	sd	s0,48(sp)
    80002e6a:	f426                	sd	s1,40(sp)
    80002e6c:	f04a                	sd	s2,32(sp)
    80002e6e:	ec4e                	sd	s3,24(sp)
    80002e70:	e852                	sd	s4,16(sp)
    80002e72:	e456                	sd	s5,8(sp)
    80002e74:	e05a                	sd	s6,0(sp)
    80002e76:	0080                	addi	s0,sp,64
    80002e78:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002e7a:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002e7c:	00017a17          	auipc	s4,0x17
    80002e80:	f3ca0a13          	addi	s4,s4,-196 # 80019db8 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    80002e84:	00005b17          	auipc	s6,0x5
    80002e88:	684b0b13          	addi	s6,s6,1668 # 80008508 <etext+0x508>
    80002e8c:	a099                	j	80002ed2 <ireclaim+0x7c>
    80002e8e:	85ce                	mv	a1,s3
    80002e90:	855a                	mv	a0,s6
    80002e92:	549020ef          	jal	80005bda <printk>
      ip = iget(dev, inum);
    80002e96:	85ce                	mv	a1,s3
    80002e98:	8556                	mv	a0,s5
    80002e9a:	ad7ff0ef          	jal	80002970 <iget>
    80002e9e:	89aa                	mv	s3,a0
    brelse(bp);
    80002ea0:	854a                	mv	a0,s2
    80002ea2:	fb0ff0ef          	jal	80002652 <brelse>
    if (ip) {
    80002ea6:	00098f63          	beqz	s3,80002ec4 <ireclaim+0x6e>
      begin_op();
    80002eaa:	7a2000ef          	jal	8000364c <begin_op>
      ilock(ip);
    80002eae:	854e                	mv	a0,s3
    80002eb0:	d33ff0ef          	jal	80002be2 <ilock>
      iunlock(ip);
    80002eb4:	854e                	mv	a0,s3
    80002eb6:	ddbff0ef          	jal	80002c90 <iunlock>
      iput(ip);
    80002eba:	854e                	mv	a0,s3
    80002ebc:	ea9ff0ef          	jal	80002d64 <iput>
      end_op();
    80002ec0:	019000ef          	jal	800036d8 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002ec4:	0485                	addi	s1,s1,1
    80002ec6:	00ca2703          	lw	a4,12(s4)
    80002eca:	0004879b          	sext.w	a5,s1
    80002ece:	02e7fd63          	bgeu	a5,a4,80002f08 <ireclaim+0xb2>
    80002ed2:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002ed6:	0044d593          	srli	a1,s1,0x4
    80002eda:	018a2783          	lw	a5,24(s4)
    80002ede:	9dbd                	addw	a1,a1,a5
    80002ee0:	8556                	mv	a0,s5
    80002ee2:	e68ff0ef          	jal	8000254a <bread>
    80002ee6:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002ee8:	05850793          	addi	a5,a0,88
    80002eec:	00f9f713          	andi	a4,s3,15
    80002ef0:	071a                	slli	a4,a4,0x6
    80002ef2:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80002ef4:	00079703          	lh	a4,0(a5)
    80002ef8:	c701                	beqz	a4,80002f00 <ireclaim+0xaa>
    80002efa:	00679783          	lh	a5,6(a5)
    80002efe:	dbc1                	beqz	a5,80002e8e <ireclaim+0x38>
    brelse(bp);
    80002f00:	854a                	mv	a0,s2
    80002f02:	f50ff0ef          	jal	80002652 <brelse>
    if (ip) {
    80002f06:	bf7d                	j	80002ec4 <ireclaim+0x6e>
}
    80002f08:	70e2                	ld	ra,56(sp)
    80002f0a:	7442                	ld	s0,48(sp)
    80002f0c:	74a2                	ld	s1,40(sp)
    80002f0e:	7902                	ld	s2,32(sp)
    80002f10:	69e2                	ld	s3,24(sp)
    80002f12:	6a42                	ld	s4,16(sp)
    80002f14:	6aa2                	ld	s5,8(sp)
    80002f16:	6b02                	ld	s6,0(sp)
    80002f18:	6121                	addi	sp,sp,64
    80002f1a:	8082                	ret
    80002f1c:	8082                	ret

0000000080002f1e <fsinit>:
{
    80002f1e:	1101                	addi	sp,sp,-32
    80002f20:	ec06                	sd	ra,24(sp)
    80002f22:	e822                	sd	s0,16(sp)
    80002f24:	e426                	sd	s1,8(sp)
    80002f26:	e04a                	sd	s2,0(sp)
    80002f28:	1000                	addi	s0,sp,32
    80002f2a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002f2c:	4585                	li	a1,1
    80002f2e:	e1cff0ef          	jal	8000254a <bread>
    80002f32:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002f34:	02000613          	li	a2,32
    80002f38:	05850593          	addi	a1,a0,88
    80002f3c:	00017517          	auipc	a0,0x17
    80002f40:	e7c50513          	addi	a0,a0,-388 # 80019db8 <sb>
    80002f44:	a7afd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002f48:	8526                	mv	a0,s1
    80002f4a:	f08ff0ef          	jal	80002652 <brelse>
  if (sb.magic != FSMAGIC)
    80002f4e:	00017717          	auipc	a4,0x17
    80002f52:	e6a72703          	lw	a4,-406(a4) # 80019db8 <sb>
    80002f56:	102037b7          	lui	a5,0x10203
    80002f5a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f5e:	02f71263          	bne	a4,a5,80002f82 <fsinit+0x64>
  initlog(dev, &sb);
    80002f62:	00017597          	auipc	a1,0x17
    80002f66:	e5658593          	addi	a1,a1,-426 # 80019db8 <sb>
    80002f6a:	854a                	mv	a0,s2
    80002f6c:	65e000ef          	jal	800035ca <initlog>
  ireclaim(dev);
    80002f70:	854a                	mv	a0,s2
    80002f72:	ee5ff0ef          	jal	80002e56 <ireclaim>
}
    80002f76:	60e2                	ld	ra,24(sp)
    80002f78:	6442                	ld	s0,16(sp)
    80002f7a:	64a2                	ld	s1,8(sp)
    80002f7c:	6902                	ld	s2,0(sp)
    80002f7e:	6105                	addi	sp,sp,32
    80002f80:	8082                	ret
    panic("invalid file system");
    80002f82:	00005517          	auipc	a0,0x5
    80002f86:	5a650513          	addi	a0,a0,1446 # 80008528 <etext+0x528>
    80002f8a:	77b020ef          	jal	80005f04 <panic>

0000000080002f8e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f8e:	1141                	addi	sp,sp,-16
    80002f90:	e406                	sd	ra,8(sp)
    80002f92:	e022                	sd	s0,0(sp)
    80002f94:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f96:	411c                	lw	a5,0(a0)
    80002f98:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f9a:	415c                	lw	a5,4(a0)
    80002f9c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f9e:	04451783          	lh	a5,68(a0)
    80002fa2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fa6:	04a51783          	lh	a5,74(a0)
    80002faa:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fae:	04c56783          	lwu	a5,76(a0)
    80002fb2:	e99c                	sd	a5,16(a1)
}
    80002fb4:	60a2                	ld	ra,8(sp)
    80002fb6:	6402                	ld	s0,0(sp)
    80002fb8:	0141                	addi	sp,sp,16
    80002fba:	8082                	ret

0000000080002fbc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80002fbc:	457c                	lw	a5,76(a0)
    80002fbe:	0ed7e663          	bltu	a5,a3,800030aa <readi+0xee>
{
    80002fc2:	7159                	addi	sp,sp,-112
    80002fc4:	f486                	sd	ra,104(sp)
    80002fc6:	f0a2                	sd	s0,96(sp)
    80002fc8:	eca6                	sd	s1,88(sp)
    80002fca:	e0d2                	sd	s4,64(sp)
    80002fcc:	fc56                	sd	s5,56(sp)
    80002fce:	f85a                	sd	s6,48(sp)
    80002fd0:	f45e                	sd	s7,40(sp)
    80002fd2:	1880                	addi	s0,sp,112
    80002fd4:	8b2a                	mv	s6,a0
    80002fd6:	8bae                	mv	s7,a1
    80002fd8:	8a32                	mv	s4,a2
    80002fda:	84b6                	mv	s1,a3
    80002fdc:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80002fde:	9f35                	addw	a4,a4,a3
    return 0;
    80002fe0:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80002fe2:	0ad76b63          	bltu	a4,a3,80003098 <readi+0xdc>
    80002fe6:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80002fe8:	00e7f463          	bgeu	a5,a4,80002ff0 <readi+0x34>
    n = ip->size - off;
    80002fec:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002ff0:	080a8b63          	beqz	s5,80003086 <readi+0xca>
    80002ff4:	e8ca                	sd	s2,80(sp)
    80002ff6:	f062                	sd	s8,32(sp)
    80002ff8:	ec66                	sd	s9,24(sp)
    80002ffa:	e86a                	sd	s10,16(sp)
    80002ffc:	e46e                	sd	s11,8(sp)
    80002ffe:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003000:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003004:	5c7d                	li	s8,-1
    80003006:	a80d                	j	80003038 <readi+0x7c>
    80003008:	020d1d93          	slli	s11,s10,0x20
    8000300c:	020ddd93          	srli	s11,s11,0x20
    80003010:	05890613          	addi	a2,s2,88
    80003014:	86ee                	mv	a3,s11
    80003016:	963e                	add	a2,a2,a5
    80003018:	85d2                	mv	a1,s4
    8000301a:	855e                	mv	a0,s7
    8000301c:	ad7fe0ef          	jal	80001af2 <either_copyout>
    80003020:	05850363          	beq	a0,s8,80003066 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003024:	854a                	mv	a0,s2
    80003026:	e2cff0ef          	jal	80002652 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000302a:	013d09bb          	addw	s3,s10,s3
    8000302e:	009d04bb          	addw	s1,s10,s1
    80003032:	9a6e                	add	s4,s4,s11
    80003034:	0559f363          	bgeu	s3,s5,8000307a <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80003038:	00a4d59b          	srliw	a1,s1,0xa
    8000303c:	855a                	mv	a0,s6
    8000303e:	873ff0ef          	jal	800028b0 <bmap>
    80003042:	85aa                	mv	a1,a0
    if (addr == 0)
    80003044:	c139                	beqz	a0,8000308a <readi+0xce>
    bp = bread(ip->dev, addr);
    80003046:	000b2503          	lw	a0,0(s6)
    8000304a:	d00ff0ef          	jal	8000254a <bread>
    8000304e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003050:	3ff4f793          	andi	a5,s1,1023
    80003054:	40fc873b          	subw	a4,s9,a5
    80003058:	413a86bb          	subw	a3,s5,s3
    8000305c:	8d3a                	mv	s10,a4
    8000305e:	fae6f5e3          	bgeu	a3,a4,80003008 <readi+0x4c>
    80003062:	8d36                	mv	s10,a3
    80003064:	b755                	j	80003008 <readi+0x4c>
      brelse(bp);
    80003066:	854a                	mv	a0,s2
    80003068:	deaff0ef          	jal	80002652 <brelse>
      tot = -1;
    8000306c:	59fd                	li	s3,-1
      break;
    8000306e:	6946                	ld	s2,80(sp)
    80003070:	7c02                	ld	s8,32(sp)
    80003072:	6ce2                	ld	s9,24(sp)
    80003074:	6d42                	ld	s10,16(sp)
    80003076:	6da2                	ld	s11,8(sp)
    80003078:	a831                	j	80003094 <readi+0xd8>
    8000307a:	6946                	ld	s2,80(sp)
    8000307c:	7c02                	ld	s8,32(sp)
    8000307e:	6ce2                	ld	s9,24(sp)
    80003080:	6d42                	ld	s10,16(sp)
    80003082:	6da2                	ld	s11,8(sp)
    80003084:	a801                	j	80003094 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003086:	89d6                	mv	s3,s5
    80003088:	a031                	j	80003094 <readi+0xd8>
    8000308a:	6946                	ld	s2,80(sp)
    8000308c:	7c02                	ld	s8,32(sp)
    8000308e:	6ce2                	ld	s9,24(sp)
    80003090:	6d42                	ld	s10,16(sp)
    80003092:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003094:	854e                	mv	a0,s3
    80003096:	69a6                	ld	s3,72(sp)
}
    80003098:	70a6                	ld	ra,104(sp)
    8000309a:	7406                	ld	s0,96(sp)
    8000309c:	64e6                	ld	s1,88(sp)
    8000309e:	6a06                	ld	s4,64(sp)
    800030a0:	7ae2                	ld	s5,56(sp)
    800030a2:	7b42                	ld	s6,48(sp)
    800030a4:	7ba2                	ld	s7,40(sp)
    800030a6:	6165                	addi	sp,sp,112
    800030a8:	8082                	ret
    return 0;
    800030aa:	4501                	li	a0,0
}
    800030ac:	8082                	ret

00000000800030ae <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800030ae:	457c                	lw	a5,76(a0)
    800030b0:	0ed7ee63          	bltu	a5,a3,800031ac <writei+0xfe>
{
    800030b4:	7159                	addi	sp,sp,-112
    800030b6:	f486                	sd	ra,104(sp)
    800030b8:	f0a2                	sd	s0,96(sp)
    800030ba:	e8ca                	sd	s2,80(sp)
    800030bc:	e0d2                	sd	s4,64(sp)
    800030be:	fc56                	sd	s5,56(sp)
    800030c0:	f85a                	sd	s6,48(sp)
    800030c2:	f45e                	sd	s7,40(sp)
    800030c4:	1880                	addi	s0,sp,112
    800030c6:	8aaa                	mv	s5,a0
    800030c8:	8bae                	mv	s7,a1
    800030ca:	8a32                	mv	s4,a2
    800030cc:	8936                	mv	s2,a3
    800030ce:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    800030d0:	00e687bb          	addw	a5,a3,a4
    return -1;
  if (off + n > MAXFILE * BSIZE)
    800030d4:	00043737          	lui	a4,0x43
    800030d8:	0cf76c63          	bltu	a4,a5,800031b0 <writei+0x102>
    800030dc:	0cd7ea63          	bltu	a5,a3,800031b0 <writei+0x102>
    800030e0:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800030e2:	0a0b0d63          	beqz	s6,8000319c <writei+0xee>
    800030e6:	eca6                	sd	s1,88(sp)
    800030e8:	f062                	sd	s8,32(sp)
    800030ea:	ec66                	sd	s9,24(sp)
    800030ec:	e86a                	sd	s10,16(sp)
    800030ee:	e46e                	sd	s11,8(sp)
    800030f0:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800030f2:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030f6:	5c7d                	li	s8,-1
    800030f8:	a825                	j	80003130 <writei+0x82>
    800030fa:	020d1d93          	slli	s11,s10,0x20
    800030fe:	020ddd93          	srli	s11,s11,0x20
    80003102:	05848513          	addi	a0,s1,88
    80003106:	86ee                	mv	a3,s11
    80003108:	8652                	mv	a2,s4
    8000310a:	85de                	mv	a1,s7
    8000310c:	953e                	add	a0,a0,a5
    8000310e:	a31fe0ef          	jal	80001b3e <either_copyin>
    80003112:	05850663          	beq	a0,s8,8000315e <writei+0xb0>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80003116:	8526                	mv	a0,s1
    80003118:	6e2000ef          	jal	800037fa <log_write>
    brelse(bp);
    8000311c:	8526                	mv	a0,s1
    8000311e:	d34ff0ef          	jal	80002652 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003122:	013d09bb          	addw	s3,s10,s3
    80003126:	012d093b          	addw	s2,s10,s2
    8000312a:	9a6e                	add	s4,s4,s11
    8000312c:	0369ff63          	bgeu	s3,s6,8000316a <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    80003130:	00a9559b          	srliw	a1,s2,0xa
    80003134:	8556                	mv	a0,s5
    80003136:	f7aff0ef          	jal	800028b0 <bmap>
    8000313a:	85aa                	mv	a1,a0
    if (addr == 0)
    8000313c:	c51d                	beqz	a0,8000316a <writei+0xbc>
    bp = bread(ip->dev, addr);
    8000313e:	000aa503          	lw	a0,0(s5)
    80003142:	c08ff0ef          	jal	8000254a <bread>
    80003146:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003148:	3ff97793          	andi	a5,s2,1023
    8000314c:	40fc873b          	subw	a4,s9,a5
    80003150:	413b06bb          	subw	a3,s6,s3
    80003154:	8d3a                	mv	s10,a4
    80003156:	fae6f2e3          	bgeu	a3,a4,800030fa <writei+0x4c>
    8000315a:	8d36                	mv	s10,a3
    8000315c:	bf79                	j	800030fa <writei+0x4c>
      log_write(bp);
    8000315e:	8526                	mv	a0,s1
    80003160:	69a000ef          	jal	800037fa <log_write>
      brelse(bp);
    80003164:	8526                	mv	a0,s1
    80003166:	cecff0ef          	jal	80002652 <brelse>
  }

  if (off > ip->size)
    8000316a:	04caa783          	lw	a5,76(s5)
    8000316e:	0327f963          	bgeu	a5,s2,800031a0 <writei+0xf2>
    ip->size = off;
    80003172:	052aa623          	sw	s2,76(s5)
    80003176:	64e6                	ld	s1,88(sp)
    80003178:	7c02                	ld	s8,32(sp)
    8000317a:	6ce2                	ld	s9,24(sp)
    8000317c:	6d42                	ld	s10,16(sp)
    8000317e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003180:	8556                	mv	a0,s5
    80003182:	9adff0ef          	jal	80002b2e <iupdate>

  return tot;
    80003186:	854e                	mv	a0,s3
    80003188:	69a6                	ld	s3,72(sp)
}
    8000318a:	70a6                	ld	ra,104(sp)
    8000318c:	7406                	ld	s0,96(sp)
    8000318e:	6946                	ld	s2,80(sp)
    80003190:	6a06                	ld	s4,64(sp)
    80003192:	7ae2                	ld	s5,56(sp)
    80003194:	7b42                	ld	s6,48(sp)
    80003196:	7ba2                	ld	s7,40(sp)
    80003198:	6165                	addi	sp,sp,112
    8000319a:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000319c:	89da                	mv	s3,s6
    8000319e:	b7cd                	j	80003180 <writei+0xd2>
    800031a0:	64e6                	ld	s1,88(sp)
    800031a2:	7c02                	ld	s8,32(sp)
    800031a4:	6ce2                	ld	s9,24(sp)
    800031a6:	6d42                	ld	s10,16(sp)
    800031a8:	6da2                	ld	s11,8(sp)
    800031aa:	bfd9                	j	80003180 <writei+0xd2>
    return -1;
    800031ac:	557d                	li	a0,-1
}
    800031ae:	8082                	ret
    return -1;
    800031b0:	557d                	li	a0,-1
    800031b2:	bfe1                	j	8000318a <writei+0xdc>

00000000800031b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031b4:	1141                	addi	sp,sp,-16
    800031b6:	e406                	sd	ra,8(sp)
    800031b8:	e022                	sd	s0,0(sp)
    800031ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031bc:	4639                	li	a2,14
    800031be:	874fd0ef          	jal	80000232 <strncmp>
}
    800031c2:	60a2                	ld	ra,8(sp)
    800031c4:	6402                	ld	s0,0(sp)
    800031c6:	0141                	addi	sp,sp,16
    800031c8:	8082                	ret

00000000800031ca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031ca:	711d                	addi	sp,sp,-96
    800031cc:	ec86                	sd	ra,88(sp)
    800031ce:	e8a2                	sd	s0,80(sp)
    800031d0:	e4a6                	sd	s1,72(sp)
    800031d2:	e0ca                	sd	s2,64(sp)
    800031d4:	fc4e                	sd	s3,56(sp)
    800031d6:	f852                	sd	s4,48(sp)
    800031d8:	f456                	sd	s5,40(sp)
    800031da:	f05a                	sd	s6,32(sp)
    800031dc:	ec5e                	sd	s7,24(sp)
    800031de:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    800031e0:	04451703          	lh	a4,68(a0)
    800031e4:	4785                	li	a5,1
    800031e6:	00f71f63          	bne	a4,a5,80003204 <dirlookup+0x3a>
    800031ea:	892a                	mv	s2,a0
    800031ec:	8aae                	mv	s5,a1
    800031ee:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    800031f0:	457c                	lw	a5,76(a0)
    800031f2:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f4:	fa040a13          	addi	s4,s0,-96
    800031f8:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    800031fa:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031fe:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003200:	e39d                	bnez	a5,80003226 <dirlookup+0x5c>
    80003202:	a8b9                	j	80003260 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003204:	00005517          	auipc	a0,0x5
    80003208:	33c50513          	addi	a0,a0,828 # 80008540 <etext+0x540>
    8000320c:	4f9020ef          	jal	80005f04 <panic>
      panic("dirlookup read");
    80003210:	00005517          	auipc	a0,0x5
    80003214:	34850513          	addi	a0,a0,840 # 80008558 <etext+0x558>
    80003218:	4ed020ef          	jal	80005f04 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000321c:	24c1                	addiw	s1,s1,16
    8000321e:	04c92783          	lw	a5,76(s2)
    80003222:	02f4fe63          	bgeu	s1,a5,8000325e <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003226:	874e                	mv	a4,s3
    80003228:	86a6                	mv	a3,s1
    8000322a:	8652                	mv	a2,s4
    8000322c:	4581                	li	a1,0
    8000322e:	854a                	mv	a0,s2
    80003230:	d8dff0ef          	jal	80002fbc <readi>
    80003234:	fd351ee3          	bne	a0,s3,80003210 <dirlookup+0x46>
    if (de.inum == 0)
    80003238:	fa045783          	lhu	a5,-96(s0)
    8000323c:	d3e5                	beqz	a5,8000321c <dirlookup+0x52>
    if (namecmp(name, de.name) == 0) {
    8000323e:	85da                	mv	a1,s6
    80003240:	8556                	mv	a0,s5
    80003242:	f73ff0ef          	jal	800031b4 <namecmp>
    80003246:	f979                	bnez	a0,8000321c <dirlookup+0x52>
      if (poff)
    80003248:	000b8463          	beqz	s7,80003250 <dirlookup+0x86>
        *poff = off;
    8000324c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003250:	fa045583          	lhu	a1,-96(s0)
    80003254:	00092503          	lw	a0,0(s2)
    80003258:	f18ff0ef          	jal	80002970 <iget>
    8000325c:	a011                	j	80003260 <dirlookup+0x96>
  return 0;
    8000325e:	4501                	li	a0,0
}
    80003260:	60e6                	ld	ra,88(sp)
    80003262:	6446                	ld	s0,80(sp)
    80003264:	64a6                	ld	s1,72(sp)
    80003266:	6906                	ld	s2,64(sp)
    80003268:	79e2                	ld	s3,56(sp)
    8000326a:	7a42                	ld	s4,48(sp)
    8000326c:	7aa2                	ld	s5,40(sp)
    8000326e:	7b02                	ld	s6,32(sp)
    80003270:	6be2                	ld	s7,24(sp)
    80003272:	6125                	addi	sp,sp,96
    80003274:	8082                	ret

0000000080003276 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003276:	711d                	addi	sp,sp,-96
    80003278:	ec86                	sd	ra,88(sp)
    8000327a:	e8a2                	sd	s0,80(sp)
    8000327c:	e4a6                	sd	s1,72(sp)
    8000327e:	e0ca                	sd	s2,64(sp)
    80003280:	fc4e                	sd	s3,56(sp)
    80003282:	f852                	sd	s4,48(sp)
    80003284:	f456                	sd	s5,40(sp)
    80003286:	f05a                	sd	s6,32(sp)
    80003288:	ec5e                	sd	s7,24(sp)
    8000328a:	e862                	sd	s8,16(sp)
    8000328c:	e466                	sd	s9,8(sp)
    8000328e:	e06a                	sd	s10,0(sp)
    80003290:	1080                	addi	s0,sp,96
    80003292:	84aa                	mv	s1,a0
    80003294:	8b2e                	mv	s6,a1
    80003296:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003298:	00054703          	lbu	a4,0(a0)
    8000329c:	02f00793          	li	a5,47
    800032a0:	00f70f63          	beq	a4,a5,800032be <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032a4:	e1bfd0ef          	jal	800010be <myproc>
    800032a8:	15053503          	ld	a0,336(a0)
    800032ac:	901ff0ef          	jal	80002bac <idup>
    800032b0:	8a2a                	mv	s4,a0
  while (*path == '/')
    800032b2:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    800032b6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800032b8:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800032ba:	4b85                	li	s7,1
    800032bc:	a07d                	j	8000336a <namex+0xf4>
    ip = iget(ROOTDEV, ROOTINO);
    800032be:	4585                	li	a1,1
    800032c0:	852e                	mv	a0,a1
    800032c2:	eaeff0ef          	jal	80002970 <iget>
    800032c6:	8a2a                	mv	s4,a0
    800032c8:	b7ed                	j	800032b2 <namex+0x3c>
      iunlockput(ip);
    800032ca:	8552                	mv	a0,s4
    800032cc:	b6bff0ef          	jal	80002e36 <iunlockput>
      return 0;
    800032d0:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800032d2:	8552                	mv	a0,s4
    800032d4:	60e6                	ld	ra,88(sp)
    800032d6:	6446                	ld	s0,80(sp)
    800032d8:	64a6                	ld	s1,72(sp)
    800032da:	6906                	ld	s2,64(sp)
    800032dc:	79e2                	ld	s3,56(sp)
    800032de:	7a42                	ld	s4,48(sp)
    800032e0:	7aa2                	ld	s5,40(sp)
    800032e2:	7b02                	ld	s6,32(sp)
    800032e4:	6be2                	ld	s7,24(sp)
    800032e6:	6c42                	ld	s8,16(sp)
    800032e8:	6ca2                	ld	s9,8(sp)
    800032ea:	6d02                	ld	s10,0(sp)
    800032ec:	6125                	addi	sp,sp,96
    800032ee:	8082                	ret
      iunlockput(ip);
    800032f0:	8552                	mv	a0,s4
    800032f2:	b45ff0ef          	jal	80002e36 <iunlockput>
      return 0;
    800032f6:	4a01                	li	s4,0
    800032f8:	bfe9                	j	800032d2 <namex+0x5c>
      iunlock(ip);
    800032fa:	8552                	mv	a0,s4
    800032fc:	995ff0ef          	jal	80002c90 <iunlock>
      return ip;
    80003300:	bfc9                	j	800032d2 <namex+0x5c>
      iunlockput(ip);
    80003302:	8552                	mv	a0,s4
    80003304:	b33ff0ef          	jal	80002e36 <iunlockput>
      return 0;
    80003308:	8a4a                	mv	s4,s2
    8000330a:	b7e1                	j	800032d2 <namex+0x5c>
  len = path - s;
    8000330c:	40990633          	sub	a2,s2,s1
    80003310:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003314:	09ac5763          	bge	s8,s10,800033a2 <namex+0x12c>
    memmove(name, s, DIRSIZ);
    80003318:	8666                	mv	a2,s9
    8000331a:	85a6                	mv	a1,s1
    8000331c:	8556                	mv	a0,s5
    8000331e:	ea1fc0ef          	jal	800001be <memmove>
    80003322:	84ca                	mv	s1,s2
  while (*path == '/')
    80003324:	0004c783          	lbu	a5,0(s1)
    80003328:	01379763          	bne	a5,s3,80003336 <namex+0xc0>
    path++;
    8000332c:	0485                	addi	s1,s1,1
  while (*path == '/')
    8000332e:	0004c783          	lbu	a5,0(s1)
    80003332:	ff378de3          	beq	a5,s3,8000332c <namex+0xb6>
    ilock(ip);
    80003336:	8552                	mv	a0,s4
    80003338:	8abff0ef          	jal	80002be2 <ilock>
    if (ip->type != T_DIR) {
    8000333c:	044a1783          	lh	a5,68(s4)
    80003340:	f97795e3          	bne	a5,s7,800032ca <namex+0x54>
    if (ip->nlink == 0) {
    80003344:	04aa1783          	lh	a5,74(s4)
    80003348:	d7c5                	beqz	a5,800032f0 <namex+0x7a>
    if (nameiparent && *path == '\0') {
    8000334a:	000b0563          	beqz	s6,80003354 <namex+0xde>
    8000334e:	0004c783          	lbu	a5,0(s1)
    80003352:	d7c5                	beqz	a5,800032fa <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003354:	4601                	li	a2,0
    80003356:	85d6                	mv	a1,s5
    80003358:	8552                	mv	a0,s4
    8000335a:	e71ff0ef          	jal	800031ca <dirlookup>
    8000335e:	892a                	mv	s2,a0
    80003360:	d14d                	beqz	a0,80003302 <namex+0x8c>
    iunlockput(ip);
    80003362:	8552                	mv	a0,s4
    80003364:	ad3ff0ef          	jal	80002e36 <iunlockput>
    ip = next;
    80003368:	8a4a                	mv	s4,s2
  while (*path == '/')
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	01379763          	bne	a5,s3,8000337c <namex+0x106>
    path++;
    80003372:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003374:	0004c783          	lbu	a5,0(s1)
    80003378:	ff378de3          	beq	a5,s3,80003372 <namex+0xfc>
  if (*path == 0)
    8000337c:	cf8d                	beqz	a5,800033b6 <namex+0x140>
  while (*path != '/' && *path != 0)
    8000337e:	0004c783          	lbu	a5,0(s1)
    80003382:	fd178713          	addi	a4,a5,-47
    80003386:	cb19                	beqz	a4,8000339c <namex+0x126>
    80003388:	cb91                	beqz	a5,8000339c <namex+0x126>
    8000338a:	8926                	mv	s2,s1
    path++;
    8000338c:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    8000338e:	00094783          	lbu	a5,0(s2)
    80003392:	fd178713          	addi	a4,a5,-47
    80003396:	db3d                	beqz	a4,8000330c <namex+0x96>
    80003398:	fbf5                	bnez	a5,8000338c <namex+0x116>
    8000339a:	bf8d                	j	8000330c <namex+0x96>
    8000339c:	8926                	mv	s2,s1
  len = path - s;
    8000339e:	4d01                	li	s10,0
    800033a0:	4601                	li	a2,0
    memmove(name, s, len);
    800033a2:	2601                	sext.w	a2,a2
    800033a4:	85a6                	mv	a1,s1
    800033a6:	8556                	mv	a0,s5
    800033a8:	e17fc0ef          	jal	800001be <memmove>
    name[len] = 0;
    800033ac:	9d56                	add	s10,s10,s5
    800033ae:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffda450>
    800033b2:	84ca                	mv	s1,s2
    800033b4:	bf85                	j	80003324 <namex+0xae>
  if (nameiparent) {
    800033b6:	f00b0ee3          	beqz	s6,800032d2 <namex+0x5c>
    iput(ip);
    800033ba:	8552                	mv	a0,s4
    800033bc:	9a9ff0ef          	jal	80002d64 <iput>
    return 0;
    800033c0:	4a01                	li	s4,0
    800033c2:	bf01                	j	800032d2 <namex+0x5c>

00000000800033c4 <dirlink>:
{
    800033c4:	715d                	addi	sp,sp,-80
    800033c6:	e486                	sd	ra,72(sp)
    800033c8:	e0a2                	sd	s0,64(sp)
    800033ca:	f84a                	sd	s2,48(sp)
    800033cc:	ec56                	sd	s5,24(sp)
    800033ce:	e85a                	sd	s6,16(sp)
    800033d0:	0880                	addi	s0,sp,80
    800033d2:	892a                	mv	s2,a0
    800033d4:	8aae                	mv	s5,a1
    800033d6:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800033d8:	4601                	li	a2,0
    800033da:	df1ff0ef          	jal	800031ca <dirlookup>
    800033de:	ed1d                	bnez	a0,8000341c <dirlink+0x58>
    800033e0:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800033e2:	04c92483          	lw	s1,76(s2)
    800033e6:	c4b9                	beqz	s1,80003434 <dirlink+0x70>
    800033e8:	f44e                	sd	s3,40(sp)
    800033ea:	f052                	sd	s4,32(sp)
    800033ec:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ee:	fb040a13          	addi	s4,s0,-80
    800033f2:	49c1                	li	s3,16
    800033f4:	874e                	mv	a4,s3
    800033f6:	86a6                	mv	a3,s1
    800033f8:	8652                	mv	a2,s4
    800033fa:	4581                	li	a1,0
    800033fc:	854a                	mv	a0,s2
    800033fe:	bbfff0ef          	jal	80002fbc <readi>
    80003402:	03351163          	bne	a0,s3,80003424 <dirlink+0x60>
    if (de.inum == 0)
    80003406:	fb045783          	lhu	a5,-80(s0)
    8000340a:	c39d                	beqz	a5,80003430 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000340c:	24c1                	addiw	s1,s1,16
    8000340e:	04c92783          	lw	a5,76(s2)
    80003412:	fef4e1e3          	bltu	s1,a5,800033f4 <dirlink+0x30>
    80003416:	79a2                	ld	s3,40(sp)
    80003418:	7a02                	ld	s4,32(sp)
    8000341a:	a829                	j	80003434 <dirlink+0x70>
    iput(ip);
    8000341c:	949ff0ef          	jal	80002d64 <iput>
    return -1;
    80003420:	557d                	li	a0,-1
    80003422:	a83d                	j	80003460 <dirlink+0x9c>
      panic("dirlink read");
    80003424:	00005517          	auipc	a0,0x5
    80003428:	14450513          	addi	a0,a0,324 # 80008568 <etext+0x568>
    8000342c:	2d9020ef          	jal	80005f04 <panic>
    80003430:	79a2                	ld	s3,40(sp)
    80003432:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003434:	4639                	li	a2,14
    80003436:	85d6                	mv	a1,s5
    80003438:	fb240513          	addi	a0,s0,-78
    8000343c:	e31fc0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80003440:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003444:	4741                	li	a4,16
    80003446:	86a6                	mv	a3,s1
    80003448:	fb040613          	addi	a2,s0,-80
    8000344c:	4581                	li	a1,0
    8000344e:	854a                	mv	a0,s2
    80003450:	c5fff0ef          	jal	800030ae <writei>
    80003454:	1541                	addi	a0,a0,-16
    80003456:	00a03533          	snez	a0,a0
    8000345a:	40a0053b          	negw	a0,a0
    8000345e:	74e2                	ld	s1,56(sp)
}
    80003460:	60a6                	ld	ra,72(sp)
    80003462:	6406                	ld	s0,64(sp)
    80003464:	7942                	ld	s2,48(sp)
    80003466:	6ae2                	ld	s5,24(sp)
    80003468:	6b42                	ld	s6,16(sp)
    8000346a:	6161                	addi	sp,sp,80
    8000346c:	8082                	ret

000000008000346e <namei>:

struct inode *
namei(char *path)
{
    8000346e:	1101                	addi	sp,sp,-32
    80003470:	ec06                	sd	ra,24(sp)
    80003472:	e822                	sd	s0,16(sp)
    80003474:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003476:	fe040613          	addi	a2,s0,-32
    8000347a:	4581                	li	a1,0
    8000347c:	dfbff0ef          	jal	80003276 <namex>
}
    80003480:	60e2                	ld	ra,24(sp)
    80003482:	6442                	ld	s0,16(sp)
    80003484:	6105                	addi	sp,sp,32
    80003486:	8082                	ret

0000000080003488 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003488:	1141                	addi	sp,sp,-16
    8000348a:	e406                	sd	ra,8(sp)
    8000348c:	e022                	sd	s0,0(sp)
    8000348e:	0800                	addi	s0,sp,16
    80003490:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003492:	4585                	li	a1,1
    80003494:	de3ff0ef          	jal	80003276 <namex>
}
    80003498:	60a2                	ld	ra,8(sp)
    8000349a:	6402                	ld	s0,0(sp)
    8000349c:	0141                	addi	sp,sp,16
    8000349e:	8082                	ret

00000000800034a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034a0:	1101                	addi	sp,sp,-32
    800034a2:	ec06                	sd	ra,24(sp)
    800034a4:	e822                	sd	s0,16(sp)
    800034a6:	e426                	sd	s1,8(sp)
    800034a8:	e04a                	sd	s2,0(sp)
    800034aa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034ac:	00018917          	auipc	s2,0x18
    800034b0:	3d490913          	addi	s2,s2,980 # 8001b880 <log>
    800034b4:	01892583          	lw	a1,24(s2)
    800034b8:	02492503          	lw	a0,36(s2)
    800034bc:	88eff0ef          	jal	8000254a <bread>
    800034c0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    800034c2:	02c92603          	lw	a2,44(s2)
    800034c6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034c8:	00c05f63          	blez	a2,800034e6 <write_head+0x46>
    800034cc:	00018717          	auipc	a4,0x18
    800034d0:	3e470713          	addi	a4,a4,996 # 8001b8b0 <log+0x30>
    800034d4:	87aa                	mv	a5,a0
    800034d6:	060a                	slli	a2,a2,0x2
    800034d8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800034da:	4314                	lw	a3,0(a4)
    800034dc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034de:	0711                	addi	a4,a4,4
    800034e0:	0791                	addi	a5,a5,4
    800034e2:	fec79ce3          	bne	a5,a2,800034da <write_head+0x3a>
  }
  bwrite(buf);
    800034e6:	8526                	mv	a0,s1
    800034e8:	938ff0ef          	jal	80002620 <bwrite>
  brelse(buf);
    800034ec:	8526                	mv	a0,s1
    800034ee:	964ff0ef          	jal	80002652 <brelse>
}
    800034f2:	60e2                	ld	ra,24(sp)
    800034f4:	6442                	ld	s0,16(sp)
    800034f6:	64a2                	ld	s1,8(sp)
    800034f8:	6902                	ld	s2,0(sp)
    800034fa:	6105                	addi	sp,sp,32
    800034fc:	8082                	ret

00000000800034fe <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034fe:	00018797          	auipc	a5,0x18
    80003502:	3ae7a783          	lw	a5,942(a5) # 8001b8ac <log+0x2c>
    80003506:	0cf05163          	blez	a5,800035c8 <install_trans+0xca>
{
    8000350a:	715d                	addi	sp,sp,-80
    8000350c:	e486                	sd	ra,72(sp)
    8000350e:	e0a2                	sd	s0,64(sp)
    80003510:	fc26                	sd	s1,56(sp)
    80003512:	f84a                	sd	s2,48(sp)
    80003514:	f44e                	sd	s3,40(sp)
    80003516:	f052                	sd	s4,32(sp)
    80003518:	ec56                	sd	s5,24(sp)
    8000351a:	e85a                	sd	s6,16(sp)
    8000351c:	e45e                	sd	s7,8(sp)
    8000351e:	e062                	sd	s8,0(sp)
    80003520:	0880                	addi	s0,sp,80
    80003522:	8b2a                	mv	s6,a0
    80003524:	00018a97          	auipc	s5,0x18
    80003528:	38ca8a93          	addi	s5,s5,908 # 8001b8b0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352c:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000352e:	00005c17          	auipc	s8,0x5
    80003532:	04ac0c13          	addi	s8,s8,74 # 80008578 <etext+0x578>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003536:	00018a17          	auipc	s4,0x18
    8000353a:	34aa0a13          	addi	s4,s4,842 # 8001b880 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    8000353e:	40000b93          	li	s7,1024
    80003542:	a025                	j	8000356a <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003544:	000aa603          	lw	a2,0(s5)
    80003548:	85ce                	mv	a1,s3
    8000354a:	8562                	mv	a0,s8
    8000354c:	68e020ef          	jal	80005bda <printk>
    80003550:	a839                	j	8000356e <install_trans+0x70>
    brelse(lbuf);
    80003552:	854a                	mv	a0,s2
    80003554:	8feff0ef          	jal	80002652 <brelse>
    brelse(dbuf);
    80003558:	8526                	mv	a0,s1
    8000355a:	8f8ff0ef          	jal	80002652 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000355e:	2985                	addiw	s3,s3,1
    80003560:	0a91                	addi	s5,s5,4
    80003562:	02ca2783          	lw	a5,44(s4)
    80003566:	04f9d563          	bge	s3,a5,800035b0 <install_trans+0xb2>
    if (recovering) {
    8000356a:	fc0b1de3          	bnez	s6,80003544 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    8000356e:	018a2583          	lw	a1,24(s4)
    80003572:	013585bb          	addw	a1,a1,s3
    80003576:	2585                	addiw	a1,a1,1
    80003578:	024a2503          	lw	a0,36(s4)
    8000357c:	fcffe0ef          	jal	8000254a <bread>
    80003580:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003582:	000aa583          	lw	a1,0(s5)
    80003586:	024a2503          	lw	a0,36(s4)
    8000358a:	fc1fe0ef          	jal	8000254a <bread>
    8000358e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003590:	865e                	mv	a2,s7
    80003592:	05890593          	addi	a1,s2,88
    80003596:	05850513          	addi	a0,a0,88
    8000359a:	c25fc0ef          	jal	800001be <memmove>
    bwrite(dbuf);                           // write dst to disk
    8000359e:	8526                	mv	a0,s1
    800035a0:	880ff0ef          	jal	80002620 <bwrite>
    if (recovering == 0)
    800035a4:	fa0b17e3          	bnez	s6,80003552 <install_trans+0x54>
      bunpin(dbuf);
    800035a8:	8526                	mv	a0,s1
    800035aa:	960ff0ef          	jal	8000270a <bunpin>
    800035ae:	b755                	j	80003552 <install_trans+0x54>
}
    800035b0:	60a6                	ld	ra,72(sp)
    800035b2:	6406                	ld	s0,64(sp)
    800035b4:	74e2                	ld	s1,56(sp)
    800035b6:	7942                	ld	s2,48(sp)
    800035b8:	79a2                	ld	s3,40(sp)
    800035ba:	7a02                	ld	s4,32(sp)
    800035bc:	6ae2                	ld	s5,24(sp)
    800035be:	6b42                	ld	s6,16(sp)
    800035c0:	6ba2                	ld	s7,8(sp)
    800035c2:	6c02                	ld	s8,0(sp)
    800035c4:	6161                	addi	sp,sp,80
    800035c6:	8082                	ret
    800035c8:	8082                	ret

00000000800035ca <initlog>:
{
    800035ca:	7179                	addi	sp,sp,-48
    800035cc:	f406                	sd	ra,40(sp)
    800035ce:	f022                	sd	s0,32(sp)
    800035d0:	ec26                	sd	s1,24(sp)
    800035d2:	e84a                	sd	s2,16(sp)
    800035d4:	e44e                	sd	s3,8(sp)
    800035d6:	1800                	addi	s0,sp,48
    800035d8:	84aa                	mv	s1,a0
    800035da:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035dc:	00018917          	auipc	s2,0x18
    800035e0:	2a490913          	addi	s2,s2,676 # 8001b880 <log>
    800035e4:	00005597          	auipc	a1,0x5
    800035e8:	fb458593          	addi	a1,a1,-76 # 80008598 <etext+0x598>
    800035ec:	854a                	mv	a0,s2
    800035ee:	309020ef          	jal	800060f6 <initlock>
  log.start = sb->logstart;
    800035f2:	0149a583          	lw	a1,20(s3)
    800035f6:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    800035fa:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    800035fe:	8526                	mv	a0,s1
    80003600:	f4bfe0ef          	jal	8000254a <bread>
  log.lh.n = lh->n;
    80003604:	4d30                	lw	a2,88(a0)
    80003606:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    8000360a:	00c05f63          	blez	a2,80003628 <initlog+0x5e>
    8000360e:	87aa                	mv	a5,a0
    80003610:	00018717          	auipc	a4,0x18
    80003614:	2a070713          	addi	a4,a4,672 # 8001b8b0 <log+0x30>
    80003618:	060a                	slli	a2,a2,0x2
    8000361a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000361c:	4ff4                	lw	a3,92(a5)
    8000361e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003620:	0791                	addi	a5,a5,4
    80003622:	0711                	addi	a4,a4,4
    80003624:	fec79ce3          	bne	a5,a2,8000361c <initlog+0x52>
  brelse(buf);
    80003628:	82aff0ef          	jal	80002652 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000362c:	4505                	li	a0,1
    8000362e:	ed1ff0ef          	jal	800034fe <install_trans>
  log.lh.n = 0;
    80003632:	00018797          	auipc	a5,0x18
    80003636:	2607ad23          	sw	zero,634(a5) # 8001b8ac <log+0x2c>
  write_head(); // clear the log
    8000363a:	e67ff0ef          	jal	800034a0 <write_head>
}
    8000363e:	70a2                	ld	ra,40(sp)
    80003640:	7402                	ld	s0,32(sp)
    80003642:	64e2                	ld	s1,24(sp)
    80003644:	6942                	ld	s2,16(sp)
    80003646:	69a2                	ld	s3,8(sp)
    80003648:	6145                	addi	sp,sp,48
    8000364a:	8082                	ret

000000008000364c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000364c:	1101                	addi	sp,sp,-32
    8000364e:	ec06                	sd	ra,24(sp)
    80003650:	e822                	sd	s0,16(sp)
    80003652:	e426                	sd	s1,8(sp)
    80003654:	e04a                	sd	s2,0(sp)
    80003656:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003658:	00018517          	auipc	a0,0x18
    8000365c:	22850513          	addi	a0,a0,552 # 8001b880 <log>
    80003660:	317020ef          	jal	80006176 <acquire>
  while (1) {
    if (log.committing) {
    80003664:	00018497          	auipc	s1,0x18
    80003668:	21c48493          	addi	s1,s1,540 # 8001b880 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    8000366c:	4979                	li	s2,30
    8000366e:	a821                	j	80003686 <begin_op+0x3a>
      sleep_prepare(&log);
    80003670:	8526                	mv	a0,s1
    80003672:	8f4fe0ef          	jal	80001766 <sleep_prepare>
      release(&log.lock);
    80003676:	8526                	mv	a0,s1
    80003678:	387020ef          	jal	800061fe <release>
      sleep();
    8000367c:	926fe0ef          	jal	800017a2 <sleep>
      acquire(&log.lock);
    80003680:	8526                	mv	a0,s1
    80003682:	2f5020ef          	jal	80006176 <acquire>
    if (log.committing) {
    80003686:	509c                	lw	a5,32(s1)
    80003688:	f7e5                	bnez	a5,80003670 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    8000368a:	4cd8                	lw	a4,28(s1)
    8000368c:	2705                	addiw	a4,a4,1
    8000368e:	0027179b          	slliw	a5,a4,0x2
    80003692:	9fb9                	addw	a5,a5,a4
    80003694:	0017979b          	slliw	a5,a5,0x1
    80003698:	54d4                	lw	a3,44(s1)
    8000369a:	9fb5                	addw	a5,a5,a3
    8000369c:	00f95e63          	bge	s2,a5,800036b8 <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    800036a0:	8526                	mv	a0,s1
    800036a2:	8c4fe0ef          	jal	80001766 <sleep_prepare>
      release(&log.lock);
    800036a6:	8526                	mv	a0,s1
    800036a8:	357020ef          	jal	800061fe <release>
      sleep();
    800036ac:	8f6fe0ef          	jal	800017a2 <sleep>
      acquire(&log.lock);
    800036b0:	8526                	mv	a0,s1
    800036b2:	2c5020ef          	jal	80006176 <acquire>
    800036b6:	bfc1                	j	80003686 <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    800036b8:	00018797          	auipc	a5,0x18
    800036bc:	1ee7a223          	sw	a4,484(a5) # 8001b89c <log+0x1c>
      release(&log.lock);
    800036c0:	00018517          	auipc	a0,0x18
    800036c4:	1c050513          	addi	a0,a0,448 # 8001b880 <log>
    800036c8:	337020ef          	jal	800061fe <release>
      break;
    }
  }
}
    800036cc:	60e2                	ld	ra,24(sp)
    800036ce:	6442                	ld	s0,16(sp)
    800036d0:	64a2                	ld	s1,8(sp)
    800036d2:	6902                	ld	s2,0(sp)
    800036d4:	6105                	addi	sp,sp,32
    800036d6:	8082                	ret

00000000800036d8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036d8:	7139                	addi	sp,sp,-64
    800036da:	fc06                	sd	ra,56(sp)
    800036dc:	f822                	sd	s0,48(sp)
    800036de:	f426                	sd	s1,40(sp)
    800036e0:	f04a                	sd	s2,32(sp)
    800036e2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036e4:	00018497          	auipc	s1,0x18
    800036e8:	19c48493          	addi	s1,s1,412 # 8001b880 <log>
    800036ec:	8526                	mv	a0,s1
    800036ee:	289020ef          	jal	80006176 <acquire>
  log.outstanding -= 1;
    800036f2:	4cdc                	lw	a5,28(s1)
    800036f4:	37fd                	addiw	a5,a5,-1
    800036f6:	893e                	mv	s2,a5
    800036f8:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    800036fa:	509c                	lw	a5,32(s1)
    800036fc:	e3b1                	bnez	a5,80003740 <end_op+0x68>
    panic("log.committing");
  if (log.outstanding == 0) {
    800036fe:	04091a63          	bnez	s2,80003752 <end_op+0x7a>
    do_commit = 1;
    log.committing = 1;
    80003702:	00018497          	auipc	s1,0x18
    80003706:	17e48493          	addi	s1,s1,382 # 8001b880 <log>
    8000370a:	4785                	li	a5,1
    8000370c:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000370e:	8526                	mv	a0,s1
    80003710:	2ef020ef          	jal	800061fe <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003714:	54dc                	lw	a5,44(s1)
    80003716:	06f04063          	bgtz	a5,80003776 <end_op+0x9e>
    acquire(&log.lock);
    8000371a:	00018497          	auipc	s1,0x18
    8000371e:	16648493          	addi	s1,s1,358 # 8001b880 <log>
    80003722:	8526                	mv	a0,s1
    80003724:	253020ef          	jal	80006176 <acquire>
    log.committing = 0;
    80003728:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    8000372c:	549c                	lw	a5,40(s1)
    8000372e:	2785                	addiw	a5,a5,1
    80003730:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003732:	8526                	mv	a0,s1
    80003734:	89efe0ef          	jal	800017d2 <wakeup>
    release(&log.lock);
    80003738:	8526                	mv	a0,s1
    8000373a:	2c5020ef          	jal	800061fe <release>
}
    8000373e:	a035                	j	8000376a <end_op+0x92>
    80003740:	ec4e                	sd	s3,24(sp)
    80003742:	e852                	sd	s4,16(sp)
    80003744:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003746:	00005517          	auipc	a0,0x5
    8000374a:	e5a50513          	addi	a0,a0,-422 # 800085a0 <etext+0x5a0>
    8000374e:	7b6020ef          	jal	80005f04 <panic>
    wakeup(&log);
    80003752:	00018517          	auipc	a0,0x18
    80003756:	12e50513          	addi	a0,a0,302 # 8001b880 <log>
    8000375a:	878fe0ef          	jal	800017d2 <wakeup>
  release(&log.lock);
    8000375e:	00018517          	auipc	a0,0x18
    80003762:	12250513          	addi	a0,a0,290 # 8001b880 <log>
    80003766:	299020ef          	jal	800061fe <release>
}
    8000376a:	70e2                	ld	ra,56(sp)
    8000376c:	7442                	ld	s0,48(sp)
    8000376e:	74a2                	ld	s1,40(sp)
    80003770:	7902                	ld	s2,32(sp)
    80003772:	6121                	addi	sp,sp,64
    80003774:	8082                	ret
    80003776:	ec4e                	sd	s3,24(sp)
    80003778:	e852                	sd	s4,16(sp)
    8000377a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000377c:	00018a97          	auipc	s5,0x18
    80003780:	134a8a93          	addi	s5,s5,308 # 8001b8b0 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003784:	00018a17          	auipc	s4,0x18
    80003788:	0fca0a13          	addi	s4,s4,252 # 8001b880 <log>
    8000378c:	018a2583          	lw	a1,24(s4)
    80003790:	012585bb          	addw	a1,a1,s2
    80003794:	2585                	addiw	a1,a1,1
    80003796:	024a2503          	lw	a0,36(s4)
    8000379a:	db1fe0ef          	jal	8000254a <bread>
    8000379e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037a0:	000aa583          	lw	a1,0(s5)
    800037a4:	024a2503          	lw	a0,36(s4)
    800037a8:	da3fe0ef          	jal	8000254a <bread>
    800037ac:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037ae:	40000613          	li	a2,1024
    800037b2:	05850593          	addi	a1,a0,88
    800037b6:	05848513          	addi	a0,s1,88
    800037ba:	a05fc0ef          	jal	800001be <memmove>
    bwrite(to); // write the log
    800037be:	8526                	mv	a0,s1
    800037c0:	e61fe0ef          	jal	80002620 <bwrite>
    brelse(from);
    800037c4:	854e                	mv	a0,s3
    800037c6:	e8dfe0ef          	jal	80002652 <brelse>
    brelse(to);
    800037ca:	8526                	mv	a0,s1
    800037cc:	e87fe0ef          	jal	80002652 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037d0:	2905                	addiw	s2,s2,1
    800037d2:	0a91                	addi	s5,s5,4
    800037d4:	02ca2783          	lw	a5,44(s4)
    800037d8:	faf94ae3          	blt	s2,a5,8000378c <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    800037dc:	cc5ff0ef          	jal	800034a0 <write_head>
    install_trans(0); // Now install writes to home locations
    800037e0:	4501                	li	a0,0
    800037e2:	d1dff0ef          	jal	800034fe <install_trans>
    log.lh.n = 0;
    800037e6:	00018797          	auipc	a5,0x18
    800037ea:	0c07a323          	sw	zero,198(a5) # 8001b8ac <log+0x2c>
    write_head(); // Erase the transaction from the log
    800037ee:	cb3ff0ef          	jal	800034a0 <write_head>
    800037f2:	69e2                	ld	s3,24(sp)
    800037f4:	6a42                	ld	s4,16(sp)
    800037f6:	6aa2                	ld	s5,8(sp)
    800037f8:	b70d                	j	8000371a <end_op+0x42>

00000000800037fa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037fa:	1101                	addi	sp,sp,-32
    800037fc:	ec06                	sd	ra,24(sp)
    800037fe:	e822                	sd	s0,16(sp)
    80003800:	e426                	sd	s1,8(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003806:	00018517          	auipc	a0,0x18
    8000380a:	07a50513          	addi	a0,a0,122 # 8001b880 <log>
    8000380e:	169020ef          	jal	80006176 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003812:	00018617          	auipc	a2,0x18
    80003816:	09a62603          	lw	a2,154(a2) # 8001b8ac <log+0x2c>
    8000381a:	47f5                	li	a5,29
    8000381c:	04c7cd63          	blt	a5,a2,80003876 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003820:	00018797          	auipc	a5,0x18
    80003824:	07c7a783          	lw	a5,124(a5) # 8001b89c <log+0x1c>
    80003828:	04f05d63          	blez	a5,80003882 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000382c:	4781                	li	a5,0
    8000382e:	06c05063          	blez	a2,8000388e <log_write+0x94>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003832:	44cc                	lw	a1,12(s1)
    80003834:	00018717          	auipc	a4,0x18
    80003838:	07c70713          	addi	a4,a4,124 # 8001b8b0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000383c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    8000383e:	4314                	lw	a3,0(a4)
    80003840:	04b68763          	beq	a3,a1,8000388e <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003844:	2785                	addiw	a5,a5,1
    80003846:	0711                	addi	a4,a4,4
    80003848:	fef61be3          	bne	a2,a5,8000383e <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000384c:	060a                	slli	a2,a2,0x2
    8000384e:	02060613          	addi	a2,a2,32
    80003852:	00018797          	auipc	a5,0x18
    80003856:	02e78793          	addi	a5,a5,46 # 8001b880 <log>
    8000385a:	97b2                	add	a5,a5,a2
    8000385c:	44d8                	lw	a4,12(s1)
    8000385e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003860:	8526                	mv	a0,s1
    80003862:	e75fe0ef          	jal	800026d6 <bpin>
    log.lh.n++;
    80003866:	00018717          	auipc	a4,0x18
    8000386a:	01a70713          	addi	a4,a4,26 # 8001b880 <log>
    8000386e:	575c                	lw	a5,44(a4)
    80003870:	2785                	addiw	a5,a5,1
    80003872:	d75c                	sw	a5,44(a4)
    80003874:	a815                	j	800038a8 <log_write+0xae>
    panic("too big a transaction");
    80003876:	00005517          	auipc	a0,0x5
    8000387a:	d3a50513          	addi	a0,a0,-710 # 800085b0 <etext+0x5b0>
    8000387e:	686020ef          	jal	80005f04 <panic>
    panic("log_write outside of trans");
    80003882:	00005517          	auipc	a0,0x5
    80003886:	d4650513          	addi	a0,a0,-698 # 800085c8 <etext+0x5c8>
    8000388a:	67a020ef          	jal	80005f04 <panic>
  log.lh.block[i] = b->blockno;
    8000388e:	00279693          	slli	a3,a5,0x2
    80003892:	02068693          	addi	a3,a3,32
    80003896:	00018717          	auipc	a4,0x18
    8000389a:	fea70713          	addi	a4,a4,-22 # 8001b880 <log>
    8000389e:	9736                	add	a4,a4,a3
    800038a0:	44d4                	lw	a3,12(s1)
    800038a2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    800038a4:	faf60ee3          	beq	a2,a5,80003860 <log_write+0x66>
  }
  release(&log.lock);
    800038a8:	00018517          	auipc	a0,0x18
    800038ac:	fd850513          	addi	a0,a0,-40 # 8001b880 <log>
    800038b0:	14f020ef          	jal	800061fe <release>
}
    800038b4:	60e2                	ld	ra,24(sp)
    800038b6:	6442                	ld	s0,16(sp)
    800038b8:	64a2                	ld	s1,8(sp)
    800038ba:	6105                	addi	sp,sp,32
    800038bc:	8082                	ret

00000000800038be <sys_sync>:

uint64
sys_sync(void)
{
    800038be:	1101                	addi	sp,sp,-32
    800038c0:	ec06                	sd	ra,24(sp)
    800038c2:	e822                	sd	s0,16(sp)
    800038c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800038c6:	00018517          	auipc	a0,0x18
    800038ca:	fba50513          	addi	a0,a0,-70 # 8001b880 <log>
    800038ce:	0a9020ef          	jal	80006176 <acquire>
  if (log.committing || log.outstanding > 0) {
    800038d2:	00018797          	auipc	a5,0x18
    800038d6:	fce7a783          	lw	a5,-50(a5) # 8001b8a0 <log+0x20>
    800038da:	e799                	bnez	a5,800038e8 <sys_sync+0x2a>
    800038dc:	00018797          	auipc	a5,0x18
    800038e0:	fc07a783          	lw	a5,-64(a5) # 8001b89c <log+0x1c>
    800038e4:	02f05c63          	blez	a5,8000391c <sys_sync+0x5e>
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    800038ec:	00018917          	auipc	s2,0x18
    800038f0:	fbc92903          	lw	s2,-68(s2) # 8001b8a8 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    800038f4:	00018497          	auipc	s1,0x18
    800038f8:	f8c48493          	addi	s1,s1,-116 # 8001b880 <log>
    800038fc:	8526                	mv	a0,s1
    800038fe:	e69fd0ef          	jal	80001766 <sleep_prepare>
      release(&log.lock);
    80003902:	8526                	mv	a0,s1
    80003904:	0fb020ef          	jal	800061fe <release>
      sleep();
    80003908:	e9bfd0ef          	jal	800017a2 <sleep>
      acquire(&log.lock);
    8000390c:	8526                	mv	a0,s1
    8000390e:	069020ef          	jal	80006176 <acquire>
    while (log.ncommit < n) {
    80003912:	549c                	lw	a5,40(s1)
    80003914:	fef954e3          	bge	s2,a5,800038fc <sys_sync+0x3e>
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    8000391c:	00018517          	auipc	a0,0x18
    80003920:	f6450513          	addi	a0,a0,-156 # 8001b880 <log>
    80003924:	0db020ef          	jal	800061fe <release>
  return 0;
}
    80003928:	4501                	li	a0,0
    8000392a:	60e2                	ld	ra,24(sp)
    8000392c:	6442                	ld	s0,16(sp)
    8000392e:	6105                	addi	sp,sp,32
    80003930:	8082                	ret

0000000080003932 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003932:	1101                	addi	sp,sp,-32
    80003934:	ec06                	sd	ra,24(sp)
    80003936:	e822                	sd	s0,16(sp)
    80003938:	e426                	sd	s1,8(sp)
    8000393a:	e04a                	sd	s2,0(sp)
    8000393c:	1000                	addi	s0,sp,32
    8000393e:	84aa                	mv	s1,a0
    80003940:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003942:	00005597          	auipc	a1,0x5
    80003946:	ca658593          	addi	a1,a1,-858 # 800085e8 <etext+0x5e8>
    8000394a:	0521                	addi	a0,a0,8
    8000394c:	7aa020ef          	jal	800060f6 <initlock>
  lk->name = name;
    80003950:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003954:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003958:	0204a423          	sw	zero,40(s1)
}
    8000395c:	60e2                	ld	ra,24(sp)
    8000395e:	6442                	ld	s0,16(sp)
    80003960:	64a2                	ld	s1,8(sp)
    80003962:	6902                	ld	s2,0(sp)
    80003964:	6105                	addi	sp,sp,32
    80003966:	8082                	ret

0000000080003968 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003968:	1101                	addi	sp,sp,-32
    8000396a:	ec06                	sd	ra,24(sp)
    8000396c:	e822                	sd	s0,16(sp)
    8000396e:	e426                	sd	s1,8(sp)
    80003970:	e04a                	sd	s2,0(sp)
    80003972:	1000                	addi	s0,sp,32
    80003974:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003976:	00850913          	addi	s2,a0,8
    8000397a:	854a                	mv	a0,s2
    8000397c:	7fa020ef          	jal	80006176 <acquire>
  while (lk->locked) {
    80003980:	409c                	lw	a5,0(s1)
    80003982:	cf91                	beqz	a5,8000399e <acquiresleep+0x36>
    sleep_prepare(lk);
    80003984:	8526                	mv	a0,s1
    80003986:	de1fd0ef          	jal	80001766 <sleep_prepare>
    release(&lk->lk);
    8000398a:	854a                	mv	a0,s2
    8000398c:	073020ef          	jal	800061fe <release>
    sleep();
    80003990:	e13fd0ef          	jal	800017a2 <sleep>
    acquire(&lk->lk);
    80003994:	854a                	mv	a0,s2
    80003996:	7e0020ef          	jal	80006176 <acquire>
  while (lk->locked) {
    8000399a:	409c                	lw	a5,0(s1)
    8000399c:	f7e5                	bnez	a5,80003984 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000399e:	4785                	li	a5,1
    800039a0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039a2:	f1cfd0ef          	jal	800010be <myproc>
    800039a6:	591c                	lw	a5,48(a0)
    800039a8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039aa:	854a                	mv	a0,s2
    800039ac:	053020ef          	jal	800061fe <release>
}
    800039b0:	60e2                	ld	ra,24(sp)
    800039b2:	6442                	ld	s0,16(sp)
    800039b4:	64a2                	ld	s1,8(sp)
    800039b6:	6902                	ld	s2,0(sp)
    800039b8:	6105                	addi	sp,sp,32
    800039ba:	8082                	ret

00000000800039bc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039bc:	1101                	addi	sp,sp,-32
    800039be:	ec06                	sd	ra,24(sp)
    800039c0:	e822                	sd	s0,16(sp)
    800039c2:	e426                	sd	s1,8(sp)
    800039c4:	e04a                	sd	s2,0(sp)
    800039c6:	1000                	addi	s0,sp,32
    800039c8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ca:	00850913          	addi	s2,a0,8
    800039ce:	854a                	mv	a0,s2
    800039d0:	7a6020ef          	jal	80006176 <acquire>
  lk->locked = 0;
    800039d4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039d8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039dc:	8526                	mv	a0,s1
    800039de:	df5fd0ef          	jal	800017d2 <wakeup>
  release(&lk->lk);
    800039e2:	854a                	mv	a0,s2
    800039e4:	01b020ef          	jal	800061fe <release>
}
    800039e8:	60e2                	ld	ra,24(sp)
    800039ea:	6442                	ld	s0,16(sp)
    800039ec:	64a2                	ld	s1,8(sp)
    800039ee:	6902                	ld	s2,0(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret

00000000800039f4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039f4:	7179                	addi	sp,sp,-48
    800039f6:	f406                	sd	ra,40(sp)
    800039f8:	f022                	sd	s0,32(sp)
    800039fa:	ec26                	sd	s1,24(sp)
    800039fc:	e84a                	sd	s2,16(sp)
    800039fe:	1800                	addi	s0,sp,48
    80003a00:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003a02:	00850913          	addi	s2,a0,8
    80003a06:	854a                	mv	a0,s2
    80003a08:	76e020ef          	jal	80006176 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a0c:	409c                	lw	a5,0(s1)
    80003a0e:	ef81                	bnez	a5,80003a26 <holdingsleep+0x32>
    80003a10:	4481                	li	s1,0
  release(&lk->lk);
    80003a12:	854a                	mv	a0,s2
    80003a14:	7ea020ef          	jal	800061fe <release>
  return r;
}
    80003a18:	8526                	mv	a0,s1
    80003a1a:	70a2                	ld	ra,40(sp)
    80003a1c:	7402                	ld	s0,32(sp)
    80003a1e:	64e2                	ld	s1,24(sp)
    80003a20:	6942                	ld	s2,16(sp)
    80003a22:	6145                	addi	sp,sp,48
    80003a24:	8082                	ret
    80003a26:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a28:	0284a983          	lw	s3,40(s1)
    80003a2c:	e92fd0ef          	jal	800010be <myproc>
    80003a30:	5904                	lw	s1,48(a0)
    80003a32:	413484b3          	sub	s1,s1,s3
    80003a36:	0014b493          	seqz	s1,s1
    80003a3a:	69a2                	ld	s3,8(sp)
    80003a3c:	bfd9                	j	80003a12 <holdingsleep+0x1e>

0000000080003a3e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a3e:	1141                	addi	sp,sp,-16
    80003a40:	e406                	sd	ra,8(sp)
    80003a42:	e022                	sd	s0,0(sp)
    80003a44:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a46:	00005597          	auipc	a1,0x5
    80003a4a:	bb258593          	addi	a1,a1,-1102 # 800085f8 <etext+0x5f8>
    80003a4e:	00018517          	auipc	a0,0x18
    80003a52:	f7a50513          	addi	a0,a0,-134 # 8001b9c8 <ftable>
    80003a56:	6a0020ef          	jal	800060f6 <initlock>
}
    80003a5a:	60a2                	ld	ra,8(sp)
    80003a5c:	6402                	ld	s0,0(sp)
    80003a5e:	0141                	addi	sp,sp,16
    80003a60:	8082                	ret

0000000080003a62 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80003a62:	1101                	addi	sp,sp,-32
    80003a64:	ec06                	sd	ra,24(sp)
    80003a66:	e822                	sd	s0,16(sp)
    80003a68:	e426                	sd	s1,8(sp)
    80003a6a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a6c:	00018517          	auipc	a0,0x18
    80003a70:	f5c50513          	addi	a0,a0,-164 # 8001b9c8 <ftable>
    80003a74:	702020ef          	jal	80006176 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a78:	00018497          	auipc	s1,0x18
    80003a7c:	f6848493          	addi	s1,s1,-152 # 8001b9e0 <ftable+0x18>
    80003a80:	00019717          	auipc	a4,0x19
    80003a84:	f0070713          	addi	a4,a4,-256 # 8001c980 <disk>
    if (f->ref == 0) {
    80003a88:	40dc                	lw	a5,4(s1)
    80003a8a:	cf89                	beqz	a5,80003aa4 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a8c:	02848493          	addi	s1,s1,40
    80003a90:	fee49ce3          	bne	s1,a4,80003a88 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a94:	00018517          	auipc	a0,0x18
    80003a98:	f3450513          	addi	a0,a0,-204 # 8001b9c8 <ftable>
    80003a9c:	762020ef          	jal	800061fe <release>
  return 0;
    80003aa0:	4481                	li	s1,0
    80003aa2:	a809                	j	80003ab4 <filealloc+0x52>
      f->ref = 1;
    80003aa4:	4785                	li	a5,1
    80003aa6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aa8:	00018517          	auipc	a0,0x18
    80003aac:	f2050513          	addi	a0,a0,-224 # 8001b9c8 <ftable>
    80003ab0:	74e020ef          	jal	800061fe <release>
}
    80003ab4:	8526                	mv	a0,s1
    80003ab6:	60e2                	ld	ra,24(sp)
    80003ab8:	6442                	ld	s0,16(sp)
    80003aba:	64a2                	ld	s1,8(sp)
    80003abc:	6105                	addi	sp,sp,32
    80003abe:	8082                	ret

0000000080003ac0 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80003ac0:	1101                	addi	sp,sp,-32
    80003ac2:	ec06                	sd	ra,24(sp)
    80003ac4:	e822                	sd	s0,16(sp)
    80003ac6:	e426                	sd	s1,8(sp)
    80003ac8:	1000                	addi	s0,sp,32
    80003aca:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003acc:	00018517          	auipc	a0,0x18
    80003ad0:	efc50513          	addi	a0,a0,-260 # 8001b9c8 <ftable>
    80003ad4:	6a2020ef          	jal	80006176 <acquire>
  if (f->ref < 1)
    80003ad8:	40dc                	lw	a5,4(s1)
    80003ada:	02f05063          	blez	a5,80003afa <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003ade:	2785                	addiw	a5,a5,1
    80003ae0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ae2:	00018517          	auipc	a0,0x18
    80003ae6:	ee650513          	addi	a0,a0,-282 # 8001b9c8 <ftable>
    80003aea:	714020ef          	jal	800061fe <release>
  return f;
}
    80003aee:	8526                	mv	a0,s1
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6105                	addi	sp,sp,32
    80003af8:	8082                	ret
    panic("filedup");
    80003afa:	00005517          	auipc	a0,0x5
    80003afe:	b0650513          	addi	a0,a0,-1274 # 80008600 <etext+0x600>
    80003b02:	402020ef          	jal	80005f04 <panic>

0000000080003b06 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b06:	7139                	addi	sp,sp,-64
    80003b08:	fc06                	sd	ra,56(sp)
    80003b0a:	f822                	sd	s0,48(sp)
    80003b0c:	f426                	sd	s1,40(sp)
    80003b0e:	0080                	addi	s0,sp,64
    80003b10:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b12:	00018517          	auipc	a0,0x18
    80003b16:	eb650513          	addi	a0,a0,-330 # 8001b9c8 <ftable>
    80003b1a:	65c020ef          	jal	80006176 <acquire>
  if (f->ref < 1)
    80003b1e:	40dc                	lw	a5,4(s1)
    80003b20:	04f05a63          	blez	a5,80003b74 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    80003b24:	37fd                	addiw	a5,a5,-1
    80003b26:	c0dc                	sw	a5,4(s1)
    80003b28:	06f04063          	bgtz	a5,80003b88 <fileclose+0x82>
    80003b2c:	f04a                	sd	s2,32(sp)
    80003b2e:	ec4e                	sd	s3,24(sp)
    80003b30:	e852                	sd	s4,16(sp)
    80003b32:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b34:	0004a903          	lw	s2,0(s1)
    80003b38:	0094c783          	lbu	a5,9(s1)
    80003b3c:	89be                	mv	s3,a5
    80003b3e:	689c                	ld	a5,16(s1)
    80003b40:	8a3e                	mv	s4,a5
    80003b42:	6c9c                	ld	a5,24(s1)
    80003b44:	8abe                	mv	s5,a5
  f->ref = 0;
    80003b46:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b4a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b4e:	00018517          	auipc	a0,0x18
    80003b52:	e7a50513          	addi	a0,a0,-390 # 8001b9c8 <ftable>
    80003b56:	6a8020ef          	jal	800061fe <release>

  if (ff.type == FD_PIPE) {
    80003b5a:	4785                	li	a5,1
    80003b5c:	04f90163          	beq	s2,a5,80003b9e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003b60:	ffe9079b          	addiw	a5,s2,-2
    80003b64:	4705                	li	a4,1
    80003b66:	04f77563          	bgeu	a4,a5,80003bb0 <fileclose+0xaa>
    80003b6a:	7902                	ld	s2,32(sp)
    80003b6c:	69e2                	ld	s3,24(sp)
    80003b6e:	6a42                	ld	s4,16(sp)
    80003b70:	6aa2                	ld	s5,8(sp)
    80003b72:	a00d                	j	80003b94 <fileclose+0x8e>
    80003b74:	f04a                	sd	s2,32(sp)
    80003b76:	ec4e                	sd	s3,24(sp)
    80003b78:	e852                	sd	s4,16(sp)
    80003b7a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	a8c50513          	addi	a0,a0,-1396 # 80008608 <etext+0x608>
    80003b84:	380020ef          	jal	80005f04 <panic>
    release(&ftable.lock);
    80003b88:	00018517          	auipc	a0,0x18
    80003b8c:	e4050513          	addi	a0,a0,-448 # 8001b9c8 <ftable>
    80003b90:	66e020ef          	jal	800061fe <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b94:	70e2                	ld	ra,56(sp)
    80003b96:	7442                	ld	s0,48(sp)
    80003b98:	74a2                	ld	s1,40(sp)
    80003b9a:	6121                	addi	sp,sp,64
    80003b9c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b9e:	85ce                	mv	a1,s3
    80003ba0:	8552                	mv	a0,s4
    80003ba2:	360000ef          	jal	80003f02 <pipeclose>
    80003ba6:	7902                	ld	s2,32(sp)
    80003ba8:	69e2                	ld	s3,24(sp)
    80003baa:	6a42                	ld	s4,16(sp)
    80003bac:	6aa2                	ld	s5,8(sp)
    80003bae:	b7dd                	j	80003b94 <fileclose+0x8e>
    begin_op();
    80003bb0:	a9dff0ef          	jal	8000364c <begin_op>
    iput(ff.ip);
    80003bb4:	8556                	mv	a0,s5
    80003bb6:	9aeff0ef          	jal	80002d64 <iput>
    end_op();
    80003bba:	b1fff0ef          	jal	800036d8 <end_op>
    80003bbe:	7902                	ld	s2,32(sp)
    80003bc0:	69e2                	ld	s3,24(sp)
    80003bc2:	6a42                	ld	s4,16(sp)
    80003bc4:	6aa2                	ld	s5,8(sp)
    80003bc6:	b7f9                	j	80003b94 <fileclose+0x8e>

0000000080003bc8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bc8:	715d                	addi	sp,sp,-80
    80003bca:	e486                	sd	ra,72(sp)
    80003bcc:	e0a2                	sd	s0,64(sp)
    80003bce:	fc26                	sd	s1,56(sp)
    80003bd0:	f052                	sd	s4,32(sp)
    80003bd2:	0880                	addi	s0,sp,80
    80003bd4:	84aa                	mv	s1,a0
    80003bd6:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003bd8:	ce6fd0ef          	jal	800010be <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003bdc:	409c                	lw	a5,0(s1)
    80003bde:	37f9                	addiw	a5,a5,-2
    80003be0:	4705                	li	a4,1
    80003be2:	04f76463          	bltu	a4,a5,80003c2a <filestat+0x62>
    80003be6:	f84a                	sd	s2,48(sp)
    80003be8:	f44e                	sd	s3,40(sp)
    80003bea:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bec:	6c88                	ld	a0,24(s1)
    80003bee:	ff5fe0ef          	jal	80002be2 <ilock>
    stati(f->ip, &st);
    80003bf2:	fb840993          	addi	s3,s0,-72
    80003bf6:	85ce                	mv	a1,s3
    80003bf8:	6c88                	ld	a0,24(s1)
    80003bfa:	b94ff0ef          	jal	80002f8e <stati>
    iunlock(f->ip);
    80003bfe:	6c88                	ld	a0,24(s1)
    80003c00:	890ff0ef          	jal	80002c90 <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    80003c04:	4761                	li	a4,24
    80003c06:	86ce                	mv	a3,s3
    80003c08:	8652                	mv	a2,s4
    80003c0a:	04893583          	ld	a1,72(s2)
    80003c0e:	05093503          	ld	a0,80(s2)
    80003c12:	8e4fd0ef          	jal	80000cf6 <copyout>
    80003c16:	41f5551b          	sraiw	a0,a0,0x1f
    80003c1a:	7942                	ld	s2,48(sp)
    80003c1c:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c1e:	60a6                	ld	ra,72(sp)
    80003c20:	6406                	ld	s0,64(sp)
    80003c22:	74e2                	ld	s1,56(sp)
    80003c24:	7a02                	ld	s4,32(sp)
    80003c26:	6161                	addi	sp,sp,80
    80003c28:	8082                	ret
  return -1;
    80003c2a:	557d                	li	a0,-1
    80003c2c:	bfcd                	j	80003c1e <filestat+0x56>

0000000080003c2e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c2e:	7179                	addi	sp,sp,-48
    80003c30:	f406                	sd	ra,40(sp)
    80003c32:	f022                	sd	s0,32(sp)
    80003c34:	e84a                	sd	s2,16(sp)
    80003c36:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    80003c38:	00854783          	lbu	a5,8(a0)
    80003c3c:	c3dd                	beqz	a5,80003ce2 <fileread+0xb4>
    80003c3e:	ec26                	sd	s1,24(sp)
    80003c40:	e44e                	sd	s3,8(sp)
    80003c42:	84aa                	mv	s1,a0
    80003c44:	892e                	mv	s2,a1
    80003c46:	89b2                	mv	s3,a2
    80003c48:	01f6579b          	srliw	a5,a2,0x1f
    80003c4c:	ebc9                	bnez	a5,80003cde <fileread+0xb0>
    return -1;

  if (f->type == FD_PIPE) {
    80003c4e:	411c                	lw	a5,0(a0)
    80003c50:	4705                	li	a4,1
    80003c52:	04e78363          	beq	a5,a4,80003c98 <fileread+0x6a>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003c56:	470d                	li	a4,3
    80003c58:	04e78763          	beq	a5,a4,80003ca6 <fileread+0x78>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003c5c:	4709                	li	a4,2
    80003c5e:	06e79a63          	bne	a5,a4,80003cd2 <fileread+0xa4>
    ilock(f->ip);
    80003c62:	6d08                	ld	a0,24(a0)
    80003c64:	f7ffe0ef          	jal	80002be2 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c68:	874e                	mv	a4,s3
    80003c6a:	5094                	lw	a3,32(s1)
    80003c6c:	864a                	mv	a2,s2
    80003c6e:	4585                	li	a1,1
    80003c70:	6c88                	ld	a0,24(s1)
    80003c72:	b4aff0ef          	jal	80002fbc <readi>
    80003c76:	892a                	mv	s2,a0
    80003c78:	00a05563          	blez	a0,80003c82 <fileread+0x54>
      f->off += r;
    80003c7c:	509c                	lw	a5,32(s1)
    80003c7e:	9fa9                	addw	a5,a5,a0
    80003c80:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c82:	6c88                	ld	a0,24(s1)
    80003c84:	80cff0ef          	jal	80002c90 <iunlock>
    80003c88:	64e2                	ld	s1,24(sp)
    80003c8a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c8c:	854a                	mv	a0,s2
    80003c8e:	70a2                	ld	ra,40(sp)
    80003c90:	7402                	ld	s0,32(sp)
    80003c92:	6942                	ld	s2,16(sp)
    80003c94:	6145                	addi	sp,sp,48
    80003c96:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c98:	6908                	ld	a0,16(a0)
    80003c9a:	3e2000ef          	jal	8000407c <piperead>
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	64e2                	ld	s1,24(sp)
    80003ca2:	69a2                	ld	s3,8(sp)
    80003ca4:	b7e5                	j	80003c8c <fileread+0x5e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ca6:	02451783          	lh	a5,36(a0)
    80003caa:	03079693          	slli	a3,a5,0x30
    80003cae:	92c1                	srli	a3,a3,0x30
    80003cb0:	4725                	li	a4,9
    80003cb2:	02d76b63          	bltu	a4,a3,80003ce8 <fileread+0xba>
    80003cb6:	0792                	slli	a5,a5,0x4
    80003cb8:	00018717          	auipc	a4,0x18
    80003cbc:	c7070713          	addi	a4,a4,-912 # 8001b928 <devsw>
    80003cc0:	97ba                	add	a5,a5,a4
    80003cc2:	639c                	ld	a5,0(a5)
    80003cc4:	c79d                	beqz	a5,80003cf2 <fileread+0xc4>
    r = devsw[f->major].read(1, addr, n);
    80003cc6:	4505                	li	a0,1
    80003cc8:	9782                	jalr	a5
    80003cca:	892a                	mv	s2,a0
    80003ccc:	64e2                	ld	s1,24(sp)
    80003cce:	69a2                	ld	s3,8(sp)
    80003cd0:	bf75                	j	80003c8c <fileread+0x5e>
    panic("fileread");
    80003cd2:	00005517          	auipc	a0,0x5
    80003cd6:	94650513          	addi	a0,a0,-1722 # 80008618 <etext+0x618>
    80003cda:	22a020ef          	jal	80005f04 <panic>
    80003cde:	64e2                	ld	s1,24(sp)
    80003ce0:	69a2                	ld	s3,8(sp)
    return -1;
    80003ce2:	57fd                	li	a5,-1
    80003ce4:	893e                	mv	s2,a5
    80003ce6:	b75d                	j	80003c8c <fileread+0x5e>
      return -1;
    80003ce8:	57fd                	li	a5,-1
    80003cea:	893e                	mv	s2,a5
    80003cec:	64e2                	ld	s1,24(sp)
    80003cee:	69a2                	ld	s3,8(sp)
    80003cf0:	bf71                	j	80003c8c <fileread+0x5e>
    80003cf2:	57fd                	li	a5,-1
    80003cf4:	893e                	mv	s2,a5
    80003cf6:	64e2                	ld	s1,24(sp)
    80003cf8:	69a2                	ld	s3,8(sp)
    80003cfa:	bf49                	j	80003c8c <fileread+0x5e>

0000000080003cfc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    80003cfc:	00954783          	lbu	a5,9(a0)
    80003d00:	12078b63          	beqz	a5,80003e36 <filewrite+0x13a>
{
    80003d04:	711d                	addi	sp,sp,-96
    80003d06:	ec86                	sd	ra,88(sp)
    80003d08:	e8a2                	sd	s0,80(sp)
    80003d0a:	e0ca                	sd	s2,64(sp)
    80003d0c:	f456                	sd	s5,40(sp)
    80003d0e:	f05a                	sd	s6,32(sp)
    80003d10:	1080                	addi	s0,sp,96
    80003d12:	892a                	mv	s2,a0
    80003d14:	8b2e                	mv	s6,a1
    80003d16:	8ab2                	mv	s5,a2
  if (f->writable == 0 || n < 0)
    80003d18:	01f6579b          	srliw	a5,a2,0x1f
    80003d1c:	0e079d63          	bnez	a5,80003e16 <filewrite+0x11a>
    return -1;

  if (f->type == FD_PIPE) {
    80003d20:	411c                	lw	a5,0(a0)
    80003d22:	4705                	li	a4,1
    80003d24:	02e78a63          	beq	a5,a4,80003d58 <filewrite+0x5c>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003d28:	470d                	li	a4,3
    80003d2a:	02e78b63          	beq	a5,a4,80003d60 <filewrite+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003d2e:	4709                	li	a4,2
    80003d30:	0ce79763          	bne	a5,a4,80003dfe <filewrite+0x102>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003d34:	0ec05763          	blez	a2,80003e22 <filewrite+0x126>
    80003d38:	e4a6                	sd	s1,72(sp)
    80003d3a:	fc4e                	sd	s3,56(sp)
    80003d3c:	f852                	sd	s4,48(sp)
    80003d3e:	ec5e                	sd	s7,24(sp)
    80003d40:	e862                	sd	s8,16(sp)
    80003d42:	e466                	sd	s9,8(sp)
    int i = 0;
    80003d44:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    80003d46:	6b85                	lui	s7,0x1
    80003d48:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d4c:	6785                	lui	a5,0x1
    80003d4e:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80003d52:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d54:	4c05                	li	s8,1
    80003d56:	a8ad                	j	80003dd0 <filewrite+0xd4>
    ret = pipewrite(f->pipe, addr, n);
    80003d58:	6908                	ld	a0,16(a0)
    80003d5a:	206000ef          	jal	80003f60 <pipewrite>
    80003d5e:	a849                	j	80003df0 <filewrite+0xf4>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d60:	02451783          	lh	a5,36(a0)
    80003d64:	03079693          	slli	a3,a5,0x30
    80003d68:	92c1                	srli	a3,a3,0x30
    80003d6a:	4725                	li	a4,9
    80003d6c:	0ad76763          	bltu	a4,a3,80003e1a <filewrite+0x11e>
    80003d70:	0792                	slli	a5,a5,0x4
    80003d72:	00018717          	auipc	a4,0x18
    80003d76:	bb670713          	addi	a4,a4,-1098 # 8001b928 <devsw>
    80003d7a:	97ba                	add	a5,a5,a4
    80003d7c:	679c                	ld	a5,8(a5)
    80003d7e:	c3c5                	beqz	a5,80003e1e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003d80:	4505                	li	a0,1
    80003d82:	9782                	jalr	a5
    80003d84:	a0b5                	j	80003df0 <filewrite+0xf4>
      if (n1 > max)
    80003d86:	2981                	sext.w	s3,s3
      begin_op();
    80003d88:	8c5ff0ef          	jal	8000364c <begin_op>
      ilock(f->ip);
    80003d8c:	01893503          	ld	a0,24(s2)
    80003d90:	e53fe0ef          	jal	80002be2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d94:	874e                	mv	a4,s3
    80003d96:	02092683          	lw	a3,32(s2)
    80003d9a:	016a0633          	add	a2,s4,s6
    80003d9e:	85e2                	mv	a1,s8
    80003da0:	01893503          	ld	a0,24(s2)
    80003da4:	b0aff0ef          	jal	800030ae <writei>
    80003da8:	84aa                	mv	s1,a0
    80003daa:	00a05763          	blez	a0,80003db8 <filewrite+0xbc>
        f->off += r;
    80003dae:	02092783          	lw	a5,32(s2)
    80003db2:	9fa9                	addw	a5,a5,a0
    80003db4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003db8:	01893503          	ld	a0,24(s2)
    80003dbc:	ed5fe0ef          	jal	80002c90 <iunlock>
      end_op();
    80003dc0:	919ff0ef          	jal	800036d8 <end_op>

      if (r != n1) {
    80003dc4:	00999d63          	bne	s3,s1,80003dde <filewrite+0xe2>
        // error from writei
        break;
      }
      i += r;
    80003dc8:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    80003dcc:	015a5963          	bge	s4,s5,80003dde <filewrite+0xe2>
      int n1 = n - i;
    80003dd0:	414a87bb          	subw	a5,s5,s4
    80003dd4:	89be                	mv	s3,a5
      if (n1 > max)
    80003dd6:	fafbd8e3          	bge	s7,a5,80003d86 <filewrite+0x8a>
    80003dda:	89e6                	mv	s3,s9
    80003ddc:	b76d                	j	80003d86 <filewrite+0x8a>
    }
    ret = (i == n ? n : -1);
    80003dde:	054a9463          	bne	s5,s4,80003e26 <filewrite+0x12a>
    80003de2:	8556                	mv	a0,s5
    80003de4:	64a6                	ld	s1,72(sp)
    80003de6:	79e2                	ld	s3,56(sp)
    80003de8:	7a42                	ld	s4,48(sp)
    80003dea:	6be2                	ld	s7,24(sp)
    80003dec:	6c42                	ld	s8,16(sp)
    80003dee:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003df0:	60e6                	ld	ra,88(sp)
    80003df2:	6446                	ld	s0,80(sp)
    80003df4:	6906                	ld	s2,64(sp)
    80003df6:	7aa2                	ld	s5,40(sp)
    80003df8:	7b02                	ld	s6,32(sp)
    80003dfa:	6125                	addi	sp,sp,96
    80003dfc:	8082                	ret
    80003dfe:	e4a6                	sd	s1,72(sp)
    80003e00:	fc4e                	sd	s3,56(sp)
    80003e02:	f852                	sd	s4,48(sp)
    80003e04:	ec5e                	sd	s7,24(sp)
    80003e06:	e862                	sd	s8,16(sp)
    80003e08:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003e0a:	00005517          	auipc	a0,0x5
    80003e0e:	81e50513          	addi	a0,a0,-2018 # 80008628 <etext+0x628>
    80003e12:	0f2020ef          	jal	80005f04 <panic>
    return -1;
    80003e16:	557d                	li	a0,-1
    80003e18:	bfe1                	j	80003df0 <filewrite+0xf4>
      return -1;
    80003e1a:	557d                	li	a0,-1
    80003e1c:	bfd1                	j	80003df0 <filewrite+0xf4>
    80003e1e:	557d                	li	a0,-1
    80003e20:	bfc1                	j	80003df0 <filewrite+0xf4>
    ret = (i == n ? n : -1);
    80003e22:	8532                	mv	a0,a2
    80003e24:	b7f1                	j	80003df0 <filewrite+0xf4>
    80003e26:	557d                	li	a0,-1
    80003e28:	64a6                	ld	s1,72(sp)
    80003e2a:	79e2                	ld	s3,56(sp)
    80003e2c:	7a42                	ld	s4,48(sp)
    80003e2e:	6be2                	ld	s7,24(sp)
    80003e30:	6c42                	ld	s8,16(sp)
    80003e32:	6ca2                	ld	s9,8(sp)
    80003e34:	bf75                	j	80003df0 <filewrite+0xf4>
    return -1;
    80003e36:	557d                	li	a0,-1
}
    80003e38:	8082                	ret

0000000080003e3a <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e3a:	7179                	addi	sp,sp,-48
    80003e3c:	f406                	sd	ra,40(sp)
    80003e3e:	f022                	sd	s0,32(sp)
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e052                	sd	s4,0(sp)
    80003e44:	1800                	addi	s0,sp,48
    80003e46:	84aa                	mv	s1,a0
    80003e48:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e4a:	0005b023          	sd	zero,0(a1)
    80003e4e:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e52:	c11ff0ef          	jal	80003a62 <filealloc>
    80003e56:	e088                	sd	a0,0(s1)
    80003e58:	c549                	beqz	a0,80003ee2 <pipealloc+0xa8>
    80003e5a:	c09ff0ef          	jal	80003a62 <filealloc>
    80003e5e:	00aa3023          	sd	a0,0(s4)
    80003e62:	cd25                	beqz	a0,80003eda <pipealloc+0xa0>
    80003e64:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80003e66:	a9efc0ef          	jal	80000104 <kalloc>
    80003e6a:	892a                	mv	s2,a0
    80003e6c:	c12d                	beqz	a0,80003ece <pipealloc+0x94>
    80003e6e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e70:	4985                	li	s3,1
    80003e72:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e76:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e7a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e7e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e82:	00004597          	auipc	a1,0x4
    80003e86:	7b658593          	addi	a1,a1,1974 # 80008638 <etext+0x638>
    80003e8a:	26c020ef          	jal	800060f6 <initlock>
  (*f0)->type = FD_PIPE;
    80003e8e:	609c                	ld	a5,0(s1)
    80003e90:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e94:	609c                	ld	a5,0(s1)
    80003e96:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e9a:	609c                	ld	a5,0(s1)
    80003e9c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ea0:	609c                	ld	a5,0(s1)
    80003ea2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ea6:	000a3783          	ld	a5,0(s4)
    80003eaa:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eae:	000a3783          	ld	a5,0(s4)
    80003eb2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eb6:	000a3783          	ld	a5,0(s4)
    80003eba:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ebe:	000a3783          	ld	a5,0(s4)
    80003ec2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ec6:	4501                	li	a0,0
    80003ec8:	6942                	ld	s2,16(sp)
    80003eca:	69a2                	ld	s3,8(sp)
    80003ecc:	a01d                	j	80003ef2 <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80003ece:	6088                	ld	a0,0(s1)
    80003ed0:	c119                	beqz	a0,80003ed6 <pipealloc+0x9c>
    80003ed2:	6942                	ld	s2,16(sp)
    80003ed4:	a029                	j	80003ede <pipealloc+0xa4>
    80003ed6:	6942                	ld	s2,16(sp)
    80003ed8:	a029                	j	80003ee2 <pipealloc+0xa8>
    80003eda:	6088                	ld	a0,0(s1)
    80003edc:	c10d                	beqz	a0,80003efe <pipealloc+0xc4>
    fileclose(*f0);
    80003ede:	c29ff0ef          	jal	80003b06 <fileclose>
  if (*f1)
    80003ee2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ee6:	557d                	li	a0,-1
  if (*f1)
    80003ee8:	c789                	beqz	a5,80003ef2 <pipealloc+0xb8>
    fileclose(*f1);
    80003eea:	853e                	mv	a0,a5
    80003eec:	c1bff0ef          	jal	80003b06 <fileclose>
  return -1;
    80003ef0:	557d                	li	a0,-1
}
    80003ef2:	70a2                	ld	ra,40(sp)
    80003ef4:	7402                	ld	s0,32(sp)
    80003ef6:	64e2                	ld	s1,24(sp)
    80003ef8:	6a02                	ld	s4,0(sp)
    80003efa:	6145                	addi	sp,sp,48
    80003efc:	8082                	ret
  return -1;
    80003efe:	557d                	li	a0,-1
    80003f00:	bfcd                	j	80003ef2 <pipealloc+0xb8>

0000000080003f02 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f02:	1101                	addi	sp,sp,-32
    80003f04:	ec06                	sd	ra,24(sp)
    80003f06:	e822                	sd	s0,16(sp)
    80003f08:	e426                	sd	s1,8(sp)
    80003f0a:	e04a                	sd	s2,0(sp)
    80003f0c:	1000                	addi	s0,sp,32
    80003f0e:	84aa                	mv	s1,a0
    80003f10:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f12:	264020ef          	jal	80006176 <acquire>
  if (writable) {
    80003f16:	02090763          	beqz	s2,80003f44 <pipeclose+0x42>
    pi->writeopen = 0;
    80003f1a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f1e:	21848513          	addi	a0,s1,536
    80003f22:	8b1fd0ef          	jal	800017d2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80003f26:	2204a783          	lw	a5,544(s1)
    80003f2a:	e781                	bnez	a5,80003f32 <pipeclose+0x30>
    80003f2c:	2244a783          	lw	a5,548(s1)
    80003f30:	c38d                	beqz	a5,80003f52 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    80003f32:	8526                	mv	a0,s1
    80003f34:	2ca020ef          	jal	800061fe <release>
}
    80003f38:	60e2                	ld	ra,24(sp)
    80003f3a:	6442                	ld	s0,16(sp)
    80003f3c:	64a2                	ld	s1,8(sp)
    80003f3e:	6902                	ld	s2,0(sp)
    80003f40:	6105                	addi	sp,sp,32
    80003f42:	8082                	ret
    pi->readopen = 0;
    80003f44:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f48:	21c48513          	addi	a0,s1,540
    80003f4c:	887fd0ef          	jal	800017d2 <wakeup>
    80003f50:	bfd9                	j	80003f26 <pipeclose+0x24>
    release(&pi->lock);
    80003f52:	8526                	mv	a0,s1
    80003f54:	2aa020ef          	jal	800061fe <release>
    kfree((char *)pi);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	8c2fc0ef          	jal	8000001c <kfree>
    80003f5e:	bfe9                	j	80003f38 <pipeclose+0x36>

0000000080003f60 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f60:	7159                	addi	sp,sp,-112
    80003f62:	f486                	sd	ra,104(sp)
    80003f64:	f0a2                	sd	s0,96(sp)
    80003f66:	eca6                	sd	s1,88(sp)
    80003f68:	e8ca                	sd	s2,80(sp)
    80003f6a:	e4ce                	sd	s3,72(sp)
    80003f6c:	e0d2                	sd	s4,64(sp)
    80003f6e:	fc56                	sd	s5,56(sp)
    80003f70:	1880                	addi	s0,sp,112
    80003f72:	84aa                	mv	s1,a0
    80003f74:	8aae                	mv	s5,a1
    80003f76:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f78:	946fd0ef          	jal	800010be <myproc>
    80003f7c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	1f6020ef          	jal	80006176 <acquire>
  while (i < n) {
    80003f84:	0f405a63          	blez	s4,80004078 <pipewrite+0x118>
    80003f88:	f85a                	sd	s6,48(sp)
    80003f8a:	f45e                	sd	s7,40(sp)
    80003f8c:	f062                	sd	s8,32(sp)
    80003f8e:	ec66                	sd	s9,24(sp)
    80003f90:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003f92:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80003f94:	f9f40c13          	addi	s8,s0,-97
    80003f98:	4b85                	li	s7,1
    80003f9a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f9c:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    80003fa0:	21c48c93          	addi	s9,s1,540
    80003fa4:	a0a1                	j	80003fec <pipewrite+0x8c>
      release(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	256020ef          	jal	800061fe <release>
      return -1;
    80003fac:	597d                	li	s2,-1
    80003fae:	7b42                	ld	s6,48(sp)
    80003fb0:	7ba2                	ld	s7,40(sp)
    80003fb2:	7c02                	ld	s8,32(sp)
    80003fb4:	6ce2                	ld	s9,24(sp)
    80003fb6:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fb8:	854a                	mv	a0,s2
    80003fba:	70a6                	ld	ra,104(sp)
    80003fbc:	7406                	ld	s0,96(sp)
    80003fbe:	64e6                	ld	s1,88(sp)
    80003fc0:	6946                	ld	s2,80(sp)
    80003fc2:	69a6                	ld	s3,72(sp)
    80003fc4:	6a06                	ld	s4,64(sp)
    80003fc6:	7ae2                	ld	s5,56(sp)
    80003fc8:	6165                	addi	sp,sp,112
    80003fca:	8082                	ret
      wakeup(&pi->nread);
    80003fcc:	856a                	mv	a0,s10
    80003fce:	805fd0ef          	jal	800017d2 <wakeup>
      sleep_prepare(&pi->nwrite);
    80003fd2:	8566                	mv	a0,s9
    80003fd4:	f92fd0ef          	jal	80001766 <sleep_prepare>
      release(&pi->lock);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	224020ef          	jal	800061fe <release>
      sleep();
    80003fde:	fc4fd0ef          	jal	800017a2 <sleep>
      acquire(&pi->lock);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	192020ef          	jal	80006176 <acquire>
  while (i < n) {
    80003fe8:	07495b63          	bge	s2,s4,8000405e <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80003fec:	2204a783          	lw	a5,544(s1)
    80003ff0:	dbdd                	beqz	a5,80003fa6 <pipewrite+0x46>
    80003ff2:	854e                	mv	a0,s3
    80003ff4:	9cbfd0ef          	jal	800019be <killed>
    80003ff8:	f55d                	bnez	a0,80003fa6 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80003ffa:	2184a783          	lw	a5,536(s1)
    80003ffe:	21c4a703          	lw	a4,540(s1)
    80004002:	2007879b          	addiw	a5,a5,512
    80004006:	fcf703e3          	beq	a4,a5,80003fcc <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    8000400a:	875e                	mv	a4,s7
    8000400c:	015906b3          	add	a3,s2,s5
    80004010:	8662                	mv	a2,s8
    80004012:	0489b583          	ld	a1,72(s3)
    80004016:	0509b503          	ld	a0,80(s3)
    8000401a:	da9fc0ef          	jal	80000dc2 <copyin>
    8000401e:	03650163          	beq	a0,s6,80004040 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004022:	21c4a783          	lw	a5,540(s1)
    80004026:	0017871b          	addiw	a4,a5,1
    8000402a:	20e4ae23          	sw	a4,540(s1)
    8000402e:	1ff7f793          	andi	a5,a5,511
    80004032:	97a6                	add	a5,a5,s1
    80004034:	f9f44703          	lbu	a4,-97(s0)
    80004038:	00e78c23          	sb	a4,24(a5)
      i++;
    8000403c:	2905                	addiw	s2,s2,1
    8000403e:	b76d                	j	80003fe8 <pipewrite+0x88>
        if (i == 0)
    80004040:	00090863          	beqz	s2,80004050 <pipewrite+0xf0>
    80004044:	7b42                	ld	s6,48(sp)
    80004046:	7ba2                	ld	s7,40(sp)
    80004048:	7c02                	ld	s8,32(sp)
    8000404a:	6ce2                	ld	s9,24(sp)
    8000404c:	6d42                	ld	s10,16(sp)
    8000404e:	a829                	j	80004068 <pipewrite+0x108>
          i = -1;
    80004050:	892a                	mv	s2,a0
        break;
    80004052:	7b42                	ld	s6,48(sp)
    80004054:	7ba2                	ld	s7,40(sp)
    80004056:	7c02                	ld	s8,32(sp)
    80004058:	6ce2                	ld	s9,24(sp)
    8000405a:	6d42                	ld	s10,16(sp)
    8000405c:	a031                	j	80004068 <pipewrite+0x108>
    8000405e:	7b42                	ld	s6,48(sp)
    80004060:	7ba2                	ld	s7,40(sp)
    80004062:	7c02                	ld	s8,32(sp)
    80004064:	6ce2                	ld	s9,24(sp)
    80004066:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004068:	21848513          	addi	a0,s1,536
    8000406c:	f66fd0ef          	jal	800017d2 <wakeup>
  release(&pi->lock);
    80004070:	8526                	mv	a0,s1
    80004072:	18c020ef          	jal	800061fe <release>
  return i;
    80004076:	b789                	j	80003fb8 <pipewrite+0x58>
  int i = 0;
    80004078:	4901                	li	s2,0
    8000407a:	b7fd                	j	80004068 <pipewrite+0x108>

000000008000407c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000407c:	711d                	addi	sp,sp,-96
    8000407e:	ec86                	sd	ra,88(sp)
    80004080:	e8a2                	sd	s0,80(sp)
    80004082:	e4a6                	sd	s1,72(sp)
    80004084:	e0ca                	sd	s2,64(sp)
    80004086:	fc4e                	sd	s3,56(sp)
    80004088:	f852                	sd	s4,48(sp)
    8000408a:	f456                	sd	s5,40(sp)
    8000408c:	1080                	addi	s0,sp,96
    8000408e:	84aa                	mv	s1,a0
    80004090:	89ae                	mv	s3,a1
    80004092:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004094:	82afd0ef          	jal	800010be <myproc>
    80004098:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    8000409a:	8526                	mv	a0,s1
    8000409c:	0da020ef          	jal	80006176 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800040a0:	2184a703          	lw	a4,536(s1)
    800040a4:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800040a8:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800040ac:	02f71e63          	bne	a4,a5,800040e8 <piperead+0x6c>
    800040b0:	2244a783          	lw	a5,548(s1)
    800040b4:	c3b9                	beqz	a5,800040fa <piperead+0x7e>
    if (killed(pr)) {
    800040b6:	854a                	mv	a0,s2
    800040b8:	907fd0ef          	jal	800019be <killed>
    800040bc:	e915                	bnez	a0,800040f0 <piperead+0x74>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800040be:	8552                	mv	a0,s4
    800040c0:	ea6fd0ef          	jal	80001766 <sleep_prepare>
    release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	138020ef          	jal	800061fe <release>
    sleep();
    800040ca:	ed8fd0ef          	jal	800017a2 <sleep>
    acquire(&pi->lock);
    800040ce:	8526                	mv	a0,s1
    800040d0:	0a6020ef          	jal	80006176 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800040d4:	2184a703          	lw	a4,536(s1)
    800040d8:	21c4a783          	lw	a5,540(s1)
    800040dc:	fcf70ae3          	beq	a4,a5,800040b0 <piperead+0x34>
    800040e0:	f05a                	sd	s6,32(sp)
    800040e2:	ec5e                	sd	s7,24(sp)
    800040e4:	e862                	sd	s8,16(sp)
    800040e6:	a829                	j	80004100 <piperead+0x84>
    800040e8:	f05a                	sd	s6,32(sp)
    800040ea:	ec5e                	sd	s7,24(sp)
    800040ec:	e862                	sd	s8,16(sp)
    800040ee:	a809                	j	80004100 <piperead+0x84>
      release(&pi->lock);
    800040f0:	8526                	mv	a0,s1
    800040f2:	10c020ef          	jal	800061fe <release>
      return -1;
    800040f6:	5a7d                	li	s4,-1
    800040f8:	a0b5                	j	80004164 <piperead+0xe8>
    800040fa:	f05a                	sd	s6,32(sp)
    800040fc:	ec5e                	sd	s7,24(sp)
    800040fe:	e862                	sd	s8,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004100:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004102:	faf40c13          	addi	s8,s0,-81
    80004106:	4b85                	li	s7,1
    80004108:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000410a:	05505363          	blez	s5,80004150 <piperead+0xd4>
    if (pi->nread == pi->nwrite)
    8000410e:	2184a783          	lw	a5,536(s1)
    80004112:	21c4a703          	lw	a4,540(s1)
    80004116:	02f70d63          	beq	a4,a5,80004150 <piperead+0xd4>
    ch = pi->data[pi->nread % PIPESIZE];
    8000411a:	1ff7f793          	andi	a5,a5,511
    8000411e:	97a6                	add	a5,a5,s1
    80004120:	0187c783          	lbu	a5,24(a5)
    80004124:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004128:	875e                	mv	a4,s7
    8000412a:	86e2                	mv	a3,s8
    8000412c:	864e                	mv	a2,s3
    8000412e:	04893583          	ld	a1,72(s2)
    80004132:	05093503          	ld	a0,80(s2)
    80004136:	bc1fc0ef          	jal	80000cf6 <copyout>
    8000413a:	03650f63          	beq	a0,s6,80004178 <piperead+0xfc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000413e:	2184a783          	lw	a5,536(s1)
    80004142:	2785                	addiw	a5,a5,1
    80004144:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004148:	2a05                	addiw	s4,s4,1
    8000414a:	0985                	addi	s3,s3,1
    8000414c:	fd4a91e3          	bne	s5,s4,8000410e <piperead+0x92>
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    80004150:	21c48513          	addi	a0,s1,540
    80004154:	e7efd0ef          	jal	800017d2 <wakeup>
  release(&pi->lock);
    80004158:	8526                	mv	a0,s1
    8000415a:	0a4020ef          	jal	800061fe <release>
    8000415e:	7b02                	ld	s6,32(sp)
    80004160:	6be2                	ld	s7,24(sp)
    80004162:	6c42                	ld	s8,16(sp)
  return i;
}
    80004164:	8552                	mv	a0,s4
    80004166:	60e6                	ld	ra,88(sp)
    80004168:	6446                	ld	s0,80(sp)
    8000416a:	64a6                	ld	s1,72(sp)
    8000416c:	6906                	ld	s2,64(sp)
    8000416e:	79e2                	ld	s3,56(sp)
    80004170:	7a42                	ld	s4,48(sp)
    80004172:	7aa2                	ld	s5,40(sp)
    80004174:	6125                	addi	sp,sp,96
    80004176:	8082                	ret
      if (i == 0)
    80004178:	fc0a1ce3          	bnez	s4,80004150 <piperead+0xd4>
        i = -1;
    8000417c:	8a2a                	mv	s4,a0
    8000417e:	bfc9                	j	80004150 <piperead+0xd4>

0000000080004180 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    80004180:	1141                	addi	sp,sp,-16
    80004182:	e406                	sd	ra,8(sp)
    80004184:	e022                	sd	s0,0(sp)
    80004186:	0800                	addi	s0,sp,16
    80004188:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    8000418a:	0035151b          	slliw	a0,a0,0x3
    8000418e:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    80004190:	8b89                	andi	a5,a5,2
    80004192:	c399                	beqz	a5,80004198 <flags2perm+0x18>
    perm |= PTE_W;
    80004194:	00456513          	ori	a0,a0,4
  return perm;
}
    80004198:	60a2                	ld	ra,8(sp)
    8000419a:	6402                	ld	s0,0(sp)
    8000419c:	0141                	addi	sp,sp,16
    8000419e:	8082                	ret

00000000800041a0 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800041a0:	de010113          	addi	sp,sp,-544
    800041a4:	20113c23          	sd	ra,536(sp)
    800041a8:	20813823          	sd	s0,528(sp)
    800041ac:	20913423          	sd	s1,520(sp)
    800041b0:	21213023          	sd	s2,512(sp)
    800041b4:	1400                	addi	s0,sp,544
    800041b6:	892a                	mv	s2,a0
    800041b8:	dea43823          	sd	a0,-528(s0)
    800041bc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041c0:	efffc0ef          	jal	800010be <myproc>
    800041c4:	84aa                	mv	s1,a0

  begin_op();
    800041c6:	c86ff0ef          	jal	8000364c <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    800041ca:	854a                	mv	a0,s2
    800041cc:	aa2ff0ef          	jal	8000346e <namei>
    800041d0:	cd21                	beqz	a0,80004228 <kexec+0x88>
    800041d2:	fbd2                	sd	s4,496(sp)
    800041d4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041d6:	a0dfe0ef          	jal	80002be2 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041da:	04000713          	li	a4,64
    800041de:	4681                	li	a3,0
    800041e0:	e5040613          	addi	a2,s0,-432
    800041e4:	4581                	li	a1,0
    800041e6:	8552                	mv	a0,s4
    800041e8:	dd5fe0ef          	jal	80002fbc <readi>
    800041ec:	04000793          	li	a5,64
    800041f0:	00f51a63          	bne	a0,a5,80004204 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    800041f4:	e5042703          	lw	a4,-432(s0)
    800041f8:	464c47b7          	lui	a5,0x464c4
    800041fc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004200:	02f70863          	beq	a4,a5,80004230 <kexec+0x90>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004204:	8552                	mv	a0,s4
    80004206:	c31fe0ef          	jal	80002e36 <iunlockput>
    end_op();
    8000420a:	cceff0ef          	jal	800036d8 <end_op>
  }
  return -1;
    8000420e:	557d                	li	a0,-1
    80004210:	7a5e                	ld	s4,496(sp)
}
    80004212:	21813083          	ld	ra,536(sp)
    80004216:	21013403          	ld	s0,528(sp)
    8000421a:	20813483          	ld	s1,520(sp)
    8000421e:	20013903          	ld	s2,512(sp)
    80004222:	22010113          	addi	sp,sp,544
    80004226:	8082                	ret
    end_op();
    80004228:	cb0ff0ef          	jal	800036d8 <end_op>
    return -1;
    8000422c:	557d                	li	a0,-1
    8000422e:	b7d5                	j	80004212 <kexec+0x72>
    80004230:	f3da                	sd	s6,480(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80004232:	8526                	mv	a0,s1
    80004234:	fa1fc0ef          	jal	800011d4 <proc_pagetable>
    80004238:	8b2a                	mv	s6,a0
    8000423a:	26050e63          	beqz	a0,800044b6 <kexec+0x316>
    8000423e:	ffce                	sd	s3,504(sp)
    80004240:	f7d6                	sd	s5,488(sp)
    80004242:	efde                	sd	s7,472(sp)
    80004244:	ebe2                	sd	s8,464(sp)
    80004246:	e7e6                	sd	s9,456(sp)
    80004248:	e3ea                	sd	s10,448(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000424a:	e8845783          	lhu	a5,-376(s0)
    8000424e:	14078263          	beqz	a5,80004392 <kexec+0x1f2>
    80004252:	ff6e                	sd	s11,440(sp)
    80004254:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004258:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000425a:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000425c:	03800d93          	li	s11,56
    if (ph.vaddr % PGSIZE != 0)
    80004260:	6c85                	lui	s9,0x1
    80004262:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004266:	def43423          	sd	a5,-536(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    8000426a:	6a85                	lui	s5,0x1
    8000426c:	a085                	j	800042cc <kexec+0x12c>
      panic("loadseg: address should exist");
    8000426e:	00004517          	auipc	a0,0x4
    80004272:	3d250513          	addi	a0,a0,978 # 80008640 <etext+0x640>
    80004276:	48f010ef          	jal	80005f04 <panic>
    if (sz - i < PGSIZE)
    8000427a:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    8000427c:	874a                	mv	a4,s2
    8000427e:	009b86bb          	addw	a3,s7,s1
    80004282:	4581                	li	a1,0
    80004284:	8552                	mv	a0,s4
    80004286:	d37fe0ef          	jal	80002fbc <readi>
    8000428a:	22a91a63          	bne	s2,a0,800044be <kexec+0x31e>
  for (i = 0; i < sz; i += PGSIZE) {
    8000428e:	009a84bb          	addw	s1,s5,s1
    80004292:	0334f263          	bgeu	s1,s3,800042b6 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004296:	02049593          	slli	a1,s1,0x20
    8000429a:	9181                	srli	a1,a1,0x20
    8000429c:	95e2                	add	a1,a1,s8
    8000429e:	855a                	mv	a0,s6
    800042a0:	9fcfc0ef          	jal	8000049c <walkaddr>
    800042a4:	862a                	mv	a2,a0
    if (pa == 0)
    800042a6:	d561                	beqz	a0,8000426e <kexec+0xce>
    if (sz - i < PGSIZE)
    800042a8:	409987bb          	subw	a5,s3,s1
    800042ac:	893e                	mv	s2,a5
    800042ae:	fcfcf6e3          	bgeu	s9,a5,8000427a <kexec+0xda>
    800042b2:	8956                	mv	s2,s5
    800042b4:	b7d9                	j	8000427a <kexec+0xda>
    sz = sz1;
    800042b6:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800042ba:	2d05                	addiw	s10,s10,1
    800042bc:	e0843783          	ld	a5,-504(s0)
    800042c0:	0387869b          	addiw	a3,a5,56
    800042c4:	e8845783          	lhu	a5,-376(s0)
    800042c8:	06fd5d63          	bge	s10,a5,80004342 <kexec+0x1a2>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042cc:	e0d43423          	sd	a3,-504(s0)
    800042d0:	876e                	mv	a4,s11
    800042d2:	e1840613          	addi	a2,s0,-488
    800042d6:	4581                	li	a1,0
    800042d8:	8552                	mv	a0,s4
    800042da:	ce3fe0ef          	jal	80002fbc <readi>
    800042de:	1db51e63          	bne	a0,s11,800044ba <kexec+0x31a>
    if (ph.type != ELF_PROG_LOAD)
    800042e2:	e1842783          	lw	a5,-488(s0)
    800042e6:	4705                	li	a4,1
    800042e8:	fce799e3          	bne	a5,a4,800042ba <kexec+0x11a>
    if (ph.memsz < ph.filesz)
    800042ec:	e4043483          	ld	s1,-448(s0)
    800042f0:	e3843783          	ld	a5,-456(s0)
    800042f4:	1ef4e363          	bltu	s1,a5,800044da <kexec+0x33a>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800042f8:	e2843783          	ld	a5,-472(s0)
    800042fc:	94be                	add	s1,s1,a5
    800042fe:	1ef4e163          	bltu	s1,a5,800044e0 <kexec+0x340>
    if (ph.vaddr % PGSIZE != 0)
    80004302:	de843703          	ld	a4,-536(s0)
    80004306:	8ff9                	and	a5,a5,a4
    80004308:	1c079f63          	bnez	a5,800044e6 <kexec+0x346>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    8000430c:	e1c42503          	lw	a0,-484(s0)
    80004310:	e71ff0ef          	jal	80004180 <flags2perm>
    80004314:	86aa                	mv	a3,a0
    80004316:	8626                	mv	a2,s1
    80004318:	85ca                	mv	a1,s2
    8000431a:	855a                	mv	a0,s6
    8000431c:	f46fc0ef          	jal	80000a62 <uvmalloc>
    80004320:	dea43c23          	sd	a0,-520(s0)
    80004324:	1c050463          	beqz	a0,800044ec <kexec+0x34c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004328:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000432c:	00098863          	beqz	s3,8000433c <kexec+0x19c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004330:	e2843c03          	ld	s8,-472(s0)
    80004334:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004338:	4481                	li	s1,0
    8000433a:	bfb1                	j	80004296 <kexec+0xf6>
    sz = sz1;
    8000433c:	df843903          	ld	s2,-520(s0)
    80004340:	bfad                	j	800042ba <kexec+0x11a>
    80004342:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    80004344:	8552                	mv	a0,s4
    80004346:	af1fe0ef          	jal	80002e36 <iunlockput>
  end_op();
    8000434a:	b8eff0ef          	jal	800036d8 <end_op>
  p = myproc();
    8000434e:	d71fc0ef          	jal	800010be <myproc>
    80004352:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004354:	04853a83          	ld	s5,72(a0)
  sz = PGROUNDUP(sz);
    80004358:	6c05                	lui	s8,0x1
    8000435a:	1c7d                	addi	s8,s8,-1 # fff <_entry-0x7ffff001>
    8000435c:	9c4a                	add	s8,s8,s2
    8000435e:	77fd                	lui	a5,0xfffff
    80004360:	00fc7c33          	and	s8,s8,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004364:	4691                	li	a3,4
    80004366:	6609                	lui	a2,0x2
    80004368:	9662                	add	a2,a2,s8
    8000436a:	85e2                	mv	a1,s8
    8000436c:	855a                	mv	a0,s6
    8000436e:	ef4fc0ef          	jal	80000a62 <uvmalloc>
    80004372:	892a                	mv	s2,a0
    80004374:	e10d                	bnez	a0,80004396 <kexec+0x1f6>
    proc_freepagetable(pagetable, sz);
    80004376:	85e2                	mv	a1,s8
    80004378:	855a                	mv	a0,s6
    8000437a:	f29fc0ef          	jal	800012a2 <proc_freepagetable>
  return -1;
    8000437e:	557d                	li	a0,-1
    80004380:	79fe                	ld	s3,504(sp)
    80004382:	7a5e                	ld	s4,496(sp)
    80004384:	7abe                	ld	s5,488(sp)
    80004386:	7b1e                	ld	s6,480(sp)
    80004388:	6bfe                	ld	s7,472(sp)
    8000438a:	6c5e                	ld	s8,464(sp)
    8000438c:	6cbe                	ld	s9,456(sp)
    8000438e:	6d1e                	ld	s10,448(sp)
    80004390:	b549                	j	80004212 <kexec+0x72>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004392:	4901                	li	s2,0
    80004394:	bf45                	j	80004344 <kexec+0x1a4>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004396:	75f9                	lui	a1,0xffffe
    80004398:	95aa                	add	a1,a1,a0
    8000439a:	855a                	mv	a0,s6
    8000439c:	899fc0ef          	jal	80000c34 <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    800043a0:	80090a13          	addi	s4,s2,-2048
    800043a4:	800a0a13          	addi	s4,s4,-2048
  for (argc = 0; argv[argc]; argc++) {
    800043a8:	e0043783          	ld	a5,-512(s0)
    800043ac:	6388                	ld	a0,0(a5)
    800043ae:	c545                	beqz	a0,80004456 <kexec+0x2b6>
  sp = sz;
    800043b0:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    800043b2:	4481                	li	s1,0
    ustack[argc] = sp;
    800043b4:	e9040b93          	addi	s7,s0,-368
    sp -= strlen(argv[argc]) + 1;
    800043b8:	f31fb0ef          	jal	800002e8 <strlen>
    800043bc:	0015079b          	addiw	a5,a0,1
    800043c0:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043c4:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    800043c8:	134c6563          	bltu	s8,s4,800044f2 <kexec+0x352>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043cc:	e0043d03          	ld	s10,-512(s0)
    800043d0:	000d3c83          	ld	s9,0(s10)
    800043d4:	8566                	mv	a0,s9
    800043d6:	f13fb0ef          	jal	800002e8 <strlen>
    800043da:	0015071b          	addiw	a4,a0,1
    800043de:	86e6                	mv	a3,s9
    800043e0:	8662                	mv	a2,s8
    800043e2:	85ca                	mv	a1,s2
    800043e4:	855a                	mv	a0,s6
    800043e6:	911fc0ef          	jal	80000cf6 <copyout>
    800043ea:	10054663          	bltz	a0,800044f6 <kexec+0x356>
    ustack[argc] = sp;
    800043ee:	00349793          	slli	a5,s1,0x3
    800043f2:	97de                	add	a5,a5,s7
    800043f4:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffda450>
  for (argc = 0; argv[argc]; argc++) {
    800043f8:	0485                	addi	s1,s1,1
    800043fa:	008d0793          	addi	a5,s10,8
    800043fe:	e0f43023          	sd	a5,-512(s0)
    80004402:	008d3503          	ld	a0,8(s10)
    80004406:	f94d                	bnez	a0,800043b8 <kexec+0x218>
  ustack[argc] = 0;
    80004408:	00349793          	slli	a5,s1,0x3
    8000440c:	f9078793          	addi	a5,a5,-112
    80004410:	97a2                	add	a5,a5,s0
    80004412:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004416:	00349713          	slli	a4,s1,0x3
    8000441a:	0721                	addi	a4,a4,8
    8000441c:	40ec0bb3          	sub	s7,s8,a4
  sp -= sp % 16;
    80004420:	ff0bfb93          	andi	s7,s7,-16
  sz = sz1;
    80004424:	8c4a                	mv	s8,s2
  if (sp < stackbase)
    80004426:	f54be8e3          	bltu	s7,s4,80004376 <kexec+0x1d6>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    8000442a:	e9040693          	addi	a3,s0,-368
    8000442e:	865e                	mv	a2,s7
    80004430:	85ca                	mv	a1,s2
    80004432:	855a                	mv	a0,s6
    80004434:	8c3fc0ef          	jal	80000cf6 <copyout>
    80004438:	f2054fe3          	bltz	a0,80004376 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    8000443c:	0589b783          	ld	a5,88(s3)
    80004440:	0777bc23          	sd	s7,120(a5)
  for (last = s = path; *s; s++)
    80004444:	df043783          	ld	a5,-528(s0)
    80004448:	0007c703          	lbu	a4,0(a5)
    8000444c:	c30d                	beqz	a4,8000446e <kexec+0x2ce>
    8000444e:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004450:	02f00693          	li	a3,47
    80004454:	a801                	j	80004464 <kexec+0x2c4>
  sp = sz;
    80004456:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80004458:	4481                	li	s1,0
    8000445a:	b77d                	j	80004408 <kexec+0x268>
  for (last = s = path; *s; s++)
    8000445c:	0785                	addi	a5,a5,1
    8000445e:	fff7c703          	lbu	a4,-1(a5)
    80004462:	c711                	beqz	a4,8000446e <kexec+0x2ce>
    if (*s == '/')
    80004464:	fed71ce3          	bne	a4,a3,8000445c <kexec+0x2bc>
      last = s + 1;
    80004468:	def43823          	sd	a5,-528(s0)
    8000446c:	bfc5                	j	8000445c <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    8000446e:	4641                	li	a2,16
    80004470:	df043583          	ld	a1,-528(s0)
    80004474:	15898513          	addi	a0,s3,344
    80004478:	e3bfb0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000447c:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004480:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004484:	0529b423          	sd	s2,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004488:	0589b783          	ld	a5,88(s3)
    8000448c:	e6843703          	ld	a4,-408(s0)
    80004490:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004492:	0589b783          	ld	a5,88(s3)
    80004496:	0377b823          	sd	s7,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000449a:	85d6                	mv	a1,s5
    8000449c:	e07fc0ef          	jal	800012a2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044a0:	0004851b          	sext.w	a0,s1
    800044a4:	79fe                	ld	s3,504(sp)
    800044a6:	7a5e                	ld	s4,496(sp)
    800044a8:	7abe                	ld	s5,488(sp)
    800044aa:	7b1e                	ld	s6,480(sp)
    800044ac:	6bfe                	ld	s7,472(sp)
    800044ae:	6c5e                	ld	s8,464(sp)
    800044b0:	6cbe                	ld	s9,456(sp)
    800044b2:	6d1e                	ld	s10,448(sp)
    800044b4:	bbb9                	j	80004212 <kexec+0x72>
    800044b6:	7b1e                	ld	s6,480(sp)
    800044b8:	b3b1                	j	80004204 <kexec+0x64>
    800044ba:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044be:	df843583          	ld	a1,-520(s0)
    800044c2:	855a                	mv	a0,s6
    800044c4:	ddffc0ef          	jal	800012a2 <proc_freepagetable>
  if (ip) {
    800044c8:	79fe                	ld	s3,504(sp)
    800044ca:	7abe                	ld	s5,488(sp)
    800044cc:	7b1e                	ld	s6,480(sp)
    800044ce:	6bfe                	ld	s7,472(sp)
    800044d0:	6c5e                	ld	s8,464(sp)
    800044d2:	6cbe                	ld	s9,456(sp)
    800044d4:	6d1e                	ld	s10,448(sp)
    800044d6:	7dfa                	ld	s11,440(sp)
    800044d8:	b335                	j	80004204 <kexec+0x64>
    800044da:	df243c23          	sd	s2,-520(s0)
    800044de:	b7c5                	j	800044be <kexec+0x31e>
    800044e0:	df243c23          	sd	s2,-520(s0)
    800044e4:	bfe9                	j	800044be <kexec+0x31e>
    800044e6:	df243c23          	sd	s2,-520(s0)
    800044ea:	bfd1                	j	800044be <kexec+0x31e>
    800044ec:	df243c23          	sd	s2,-520(s0)
    800044f0:	b7f9                	j	800044be <kexec+0x31e>
  sz = sz1;
    800044f2:	8c4a                	mv	s8,s2
    800044f4:	b549                	j	80004376 <kexec+0x1d6>
    800044f6:	8c4a                	mv	s8,s2
    800044f8:	bdbd                	j	80004376 <kexec+0x1d6>

00000000800044fa <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044fa:	7179                	addi	sp,sp,-48
    800044fc:	f406                	sd	ra,40(sp)
    800044fe:	f022                	sd	s0,32(sp)
    80004500:	ec26                	sd	s1,24(sp)
    80004502:	e84a                	sd	s2,16(sp)
    80004504:	1800                	addi	s0,sp,48
    80004506:	892e                	mv	s2,a1
    80004508:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000450a:	fdc40593          	addi	a1,s0,-36
    8000450e:	b91fd0ef          	jal	8000209e <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004512:	fdc42703          	lw	a4,-36(s0)
    80004516:	47bd                	li	a5,15
    80004518:	02e7ea63          	bltu	a5,a4,8000454c <argfd+0x52>
    8000451c:	ba3fc0ef          	jal	800010be <myproc>
    80004520:	fdc42703          	lw	a4,-36(s0)
    80004524:	00371793          	slli	a5,a4,0x3
    80004528:	0d078793          	addi	a5,a5,208
    8000452c:	953e                	add	a0,a0,a5
    8000452e:	611c                	ld	a5,0(a0)
    80004530:	c385                	beqz	a5,80004550 <argfd+0x56>
    return -1;
  if (pfd)
    80004532:	00090463          	beqz	s2,8000453a <argfd+0x40>
    *pfd = fd;
    80004536:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    8000453a:	4501                	li	a0,0
  if (pf)
    8000453c:	c091                	beqz	s1,80004540 <argfd+0x46>
    *pf = f;
    8000453e:	e09c                	sd	a5,0(s1)
}
    80004540:	70a2                	ld	ra,40(sp)
    80004542:	7402                	ld	s0,32(sp)
    80004544:	64e2                	ld	s1,24(sp)
    80004546:	6942                	ld	s2,16(sp)
    80004548:	6145                	addi	sp,sp,48
    8000454a:	8082                	ret
    return -1;
    8000454c:	557d                	li	a0,-1
    8000454e:	bfcd                	j	80004540 <argfd+0x46>
    80004550:	557d                	li	a0,-1
    80004552:	b7fd                	j	80004540 <argfd+0x46>

0000000080004554 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004554:	1101                	addi	sp,sp,-32
    80004556:	ec06                	sd	ra,24(sp)
    80004558:	e822                	sd	s0,16(sp)
    8000455a:	e426                	sd	s1,8(sp)
    8000455c:	1000                	addi	s0,sp,32
    8000455e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004560:	b5ffc0ef          	jal	800010be <myproc>
    80004564:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004566:	0d050793          	addi	a5,a0,208
    8000456a:	4501                	li	a0,0
    8000456c:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    8000456e:	6398                	ld	a4,0(a5)
    80004570:	cb19                	beqz	a4,80004586 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004572:	2505                	addiw	a0,a0,1
    80004574:	07a1                	addi	a5,a5,8
    80004576:	fed51ce3          	bne	a0,a3,8000456e <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000457a:	557d                	li	a0,-1
}
    8000457c:	60e2                	ld	ra,24(sp)
    8000457e:	6442                	ld	s0,16(sp)
    80004580:	64a2                	ld	s1,8(sp)
    80004582:	6105                	addi	sp,sp,32
    80004584:	8082                	ret
      p->ofile[fd] = f;
    80004586:	00351793          	slli	a5,a0,0x3
    8000458a:	0d078793          	addi	a5,a5,208
    8000458e:	963e                	add	a2,a2,a5
    80004590:	e204                	sd	s1,0(a2)
      return fd;
    80004592:	b7ed                	j	8000457c <fdalloc+0x28>

0000000080004594 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004594:	715d                	addi	sp,sp,-80
    80004596:	e486                	sd	ra,72(sp)
    80004598:	e0a2                	sd	s0,64(sp)
    8000459a:	fc26                	sd	s1,56(sp)
    8000459c:	f84a                	sd	s2,48(sp)
    8000459e:	f052                	sd	s4,32(sp)
    800045a0:	ec56                	sd	s5,24(sp)
    800045a2:	e85a                	sd	s6,16(sp)
    800045a4:	0880                	addi	s0,sp,80
    800045a6:	8a2e                	mv	s4,a1
    800045a8:	8ab2                	mv	s5,a2
    800045aa:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800045ac:	fb040593          	addi	a1,s0,-80
    800045b0:	ed9fe0ef          	jal	80003488 <nameiparent>
    800045b4:	84aa                	mv	s1,a0
    800045b6:	12050f63          	beqz	a0,800046f4 <create+0x160>
    return 0;

  ilock(dp);
    800045ba:	e28fe0ef          	jal	80002be2 <ilock>

  if (dp->nlink == 0) {
    800045be:	04a49783          	lh	a5,74(s1)
    800045c2:	cbb9                	beqz	a5,80004618 <create+0x84>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    800045c4:	7761                	lui	a4,0xffff8
    800045c6:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd3451>
    800045c8:	97ba                	add	a5,a5,a4
    800045ca:	e781                	bnez	a5,800045d2 <create+0x3e>
    800045cc:	fffa0793          	addi	a5,s4,-1
    800045d0:	cba9                	beqz	a5,80004622 <create+0x8e>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800045d2:	4601                	li	a2,0
    800045d4:	fb040593          	addi	a1,s0,-80
    800045d8:	8526                	mv	a0,s1
    800045da:	bf1fe0ef          	jal	800031ca <dirlookup>
    800045de:	892a                	mv	s2,a0
    800045e0:	c939                	beqz	a0,80004636 <create+0xa2>
    iunlockput(dp);
    800045e2:	8526                	mv	a0,s1
    800045e4:	853fe0ef          	jal	80002e36 <iunlockput>
    ilock(ip);
    800045e8:	854a                	mv	a0,s2
    800045ea:	df8fe0ef          	jal	80002be2 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045ee:	4789                	li	a5,2
    800045f0:	02fa1e63          	bne	s4,a5,8000462c <create+0x98>
    800045f4:	04495783          	lhu	a5,68(s2)
    800045f8:	37f9                	addiw	a5,a5,-2
    800045fa:	17c2                	slli	a5,a5,0x30
    800045fc:	93c1                	srli	a5,a5,0x30
    800045fe:	4705                	li	a4,1
    80004600:	02f76663          	bltu	a4,a5,8000462c <create+0x98>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004604:	854a                	mv	a0,s2
    80004606:	60a6                	ld	ra,72(sp)
    80004608:	6406                	ld	s0,64(sp)
    8000460a:	74e2                	ld	s1,56(sp)
    8000460c:	7942                	ld	s2,48(sp)
    8000460e:	7a02                	ld	s4,32(sp)
    80004610:	6ae2                	ld	s5,24(sp)
    80004612:	6b42                	ld	s6,16(sp)
    80004614:	6161                	addi	sp,sp,80
    80004616:	8082                	ret
    iunlockput(dp);
    80004618:	8526                	mv	a0,s1
    8000461a:	81dfe0ef          	jal	80002e36 <iunlockput>
    return 0;
    8000461e:	4901                	li	s2,0
    80004620:	b7d5                	j	80004604 <create+0x70>
    iunlockput(dp);
    80004622:	8526                	mv	a0,s1
    80004624:	813fe0ef          	jal	80002e36 <iunlockput>
    return 0;
    80004628:	4901                	li	s2,0
    8000462a:	bfe9                	j	80004604 <create+0x70>
    iunlockput(ip);
    8000462c:	854a                	mv	a0,s2
    8000462e:	809fe0ef          	jal	80002e36 <iunlockput>
    return 0;
    80004632:	4901                	li	s2,0
    80004634:	bfc1                	j	80004604 <create+0x70>
    80004636:	f44e                	sd	s3,40(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004638:	85d2                	mv	a1,s4
    8000463a:	4088                	lw	a0,0(s1)
    8000463c:	c36fe0ef          	jal	80002a72 <ialloc>
    80004640:	89aa                	mv	s3,a0
    80004642:	cd1d                	beqz	a0,80004680 <create+0xec>
  ilock(ip);
    80004644:	d9efe0ef          	jal	80002be2 <ilock>
  ip->major = major;
    80004648:	05599323          	sh	s5,70(s3)
  ip->minor = minor;
    8000464c:	05699423          	sh	s6,72(s3)
  ip->nlink = 1;
    80004650:	4705                	li	a4,1
    80004652:	04e99523          	sh	a4,74(s3)
  iupdate(ip);
    80004656:	854e                	mv	a0,s3
    80004658:	cd6fe0ef          	jal	80002b2e <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    8000465c:	4705                	li	a4,1
    8000465e:	02ea0763          	beq	s4,a4,8000468c <create+0xf8>
  if (dirlink(dp, name, ip->inum) < 0)
    80004662:	0049a603          	lw	a2,4(s3)
    80004666:	fb040593          	addi	a1,s0,-80
    8000466a:	8526                	mv	a0,s1
    8000466c:	d59fe0ef          	jal	800033c4 <dirlink>
    80004670:	06054563          	bltz	a0,800046da <create+0x146>
  iunlockput(dp);
    80004674:	8526                	mv	a0,s1
    80004676:	fc0fe0ef          	jal	80002e36 <iunlockput>
  return ip;
    8000467a:	894e                	mv	s2,s3
    8000467c:	79a2                	ld	s3,40(sp)
    8000467e:	b759                	j	80004604 <create+0x70>
    iunlockput(dp);
    80004680:	8526                	mv	a0,s1
    80004682:	fb4fe0ef          	jal	80002e36 <iunlockput>
    return 0;
    80004686:	894e                	mv	s2,s3
    80004688:	79a2                	ld	s3,40(sp)
    8000468a:	bfad                	j	80004604 <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000468c:	0049a603          	lw	a2,4(s3)
    80004690:	00004597          	auipc	a1,0x4
    80004694:	fd058593          	addi	a1,a1,-48 # 80008660 <etext+0x660>
    80004698:	854e                	mv	a0,s3
    8000469a:	d2bfe0ef          	jal	800033c4 <dirlink>
    8000469e:	02054e63          	bltz	a0,800046da <create+0x146>
    800046a2:	40d0                	lw	a2,4(s1)
    800046a4:	00004597          	auipc	a1,0x4
    800046a8:	fc458593          	addi	a1,a1,-60 # 80008668 <etext+0x668>
    800046ac:	854e                	mv	a0,s3
    800046ae:	d17fe0ef          	jal	800033c4 <dirlink>
    800046b2:	02054463          	bltz	a0,800046da <create+0x146>
  if (dirlink(dp, name, ip->inum) < 0)
    800046b6:	0049a603          	lw	a2,4(s3)
    800046ba:	fb040593          	addi	a1,s0,-80
    800046be:	8526                	mv	a0,s1
    800046c0:	d05fe0ef          	jal	800033c4 <dirlink>
    800046c4:	00054b63          	bltz	a0,800046da <create+0x146>
    dp->nlink++; // for ".."
    800046c8:	04a4d783          	lhu	a5,74(s1)
    800046cc:	2785                	addiw	a5,a5,1
    800046ce:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046d2:	8526                	mv	a0,s1
    800046d4:	c5afe0ef          	jal	80002b2e <iupdate>
    800046d8:	bf71                	j	80004674 <create+0xe0>
  ip->nlink = 0;
    800046da:	04099523          	sh	zero,74(s3)
  iupdate(ip);
    800046de:	854e                	mv	a0,s3
    800046e0:	c4efe0ef          	jal	80002b2e <iupdate>
  iunlockput(ip);
    800046e4:	854e                	mv	a0,s3
    800046e6:	f50fe0ef          	jal	80002e36 <iunlockput>
  iunlockput(dp);
    800046ea:	8526                	mv	a0,s1
    800046ec:	f4afe0ef          	jal	80002e36 <iunlockput>
  return 0;
    800046f0:	79a2                	ld	s3,40(sp)
    800046f2:	bf09                	j	80004604 <create+0x70>
    return 0;
    800046f4:	892a                	mv	s2,a0
    800046f6:	b739                	j	80004604 <create+0x70>

00000000800046f8 <sys_dup>:
{
    800046f8:	7179                	addi	sp,sp,-48
    800046fa:	f406                	sd	ra,40(sp)
    800046fc:	f022                	sd	s0,32(sp)
    800046fe:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004700:	fd840613          	addi	a2,s0,-40
    80004704:	4581                	li	a1,0
    80004706:	4501                	li	a0,0
    80004708:	df3ff0ef          	jal	800044fa <argfd>
    return -1;
    8000470c:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    8000470e:	02054363          	bltz	a0,80004734 <sys_dup+0x3c>
    80004712:	ec26                	sd	s1,24(sp)
    80004714:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004716:	fd843483          	ld	s1,-40(s0)
    8000471a:	8526                	mv	a0,s1
    8000471c:	e39ff0ef          	jal	80004554 <fdalloc>
    80004720:	892a                	mv	s2,a0
    return -1;
    80004722:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004724:	00054d63          	bltz	a0,8000473e <sys_dup+0x46>
  filedup(f);
    80004728:	8526                	mv	a0,s1
    8000472a:	b96ff0ef          	jal	80003ac0 <filedup>
  return fd;
    8000472e:	87ca                	mv	a5,s2
    80004730:	64e2                	ld	s1,24(sp)
    80004732:	6942                	ld	s2,16(sp)
}
    80004734:	853e                	mv	a0,a5
    80004736:	70a2                	ld	ra,40(sp)
    80004738:	7402                	ld	s0,32(sp)
    8000473a:	6145                	addi	sp,sp,48
    8000473c:	8082                	ret
    8000473e:	64e2                	ld	s1,24(sp)
    80004740:	6942                	ld	s2,16(sp)
    80004742:	bfcd                	j	80004734 <sys_dup+0x3c>

0000000080004744 <sys_read>:
{
    80004744:	7179                	addi	sp,sp,-48
    80004746:	f406                	sd	ra,40(sp)
    80004748:	f022                	sd	s0,32(sp)
    8000474a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000474c:	fd840593          	addi	a1,s0,-40
    80004750:	4505                	li	a0,1
    80004752:	969fd0ef          	jal	800020ba <argaddr>
  argint(2, &n);
    80004756:	fe440593          	addi	a1,s0,-28
    8000475a:	4509                	li	a0,2
    8000475c:	943fd0ef          	jal	8000209e <argint>
  if (argfd(0, 0, &f) < 0)
    80004760:	fe840613          	addi	a2,s0,-24
    80004764:	4581                	li	a1,0
    80004766:	4501                	li	a0,0
    80004768:	d93ff0ef          	jal	800044fa <argfd>
    8000476c:	87aa                	mv	a5,a0
    return -1;
    8000476e:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004770:	0007ca63          	bltz	a5,80004784 <sys_read+0x40>
  return fileread(f, p, n);
    80004774:	fe442603          	lw	a2,-28(s0)
    80004778:	fd843583          	ld	a1,-40(s0)
    8000477c:	fe843503          	ld	a0,-24(s0)
    80004780:	caeff0ef          	jal	80003c2e <fileread>
}
    80004784:	70a2                	ld	ra,40(sp)
    80004786:	7402                	ld	s0,32(sp)
    80004788:	6145                	addi	sp,sp,48
    8000478a:	8082                	ret

000000008000478c <sys_write>:
{
    8000478c:	7179                	addi	sp,sp,-48
    8000478e:	f406                	sd	ra,40(sp)
    80004790:	f022                	sd	s0,32(sp)
    80004792:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004794:	fd840593          	addi	a1,s0,-40
    80004798:	4505                	li	a0,1
    8000479a:	921fd0ef          	jal	800020ba <argaddr>
  argint(2, &n);
    8000479e:	fe440593          	addi	a1,s0,-28
    800047a2:	4509                	li	a0,2
    800047a4:	8fbfd0ef          	jal	8000209e <argint>
  if (argfd(0, 0, &f) < 0)
    800047a8:	fe840613          	addi	a2,s0,-24
    800047ac:	4581                	li	a1,0
    800047ae:	4501                	li	a0,0
    800047b0:	d4bff0ef          	jal	800044fa <argfd>
    800047b4:	87aa                	mv	a5,a0
    return -1;
    800047b6:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800047b8:	0007ca63          	bltz	a5,800047cc <sys_write+0x40>
  return filewrite(f, p, n);
    800047bc:	fe442603          	lw	a2,-28(s0)
    800047c0:	fd843583          	ld	a1,-40(s0)
    800047c4:	fe843503          	ld	a0,-24(s0)
    800047c8:	d34ff0ef          	jal	80003cfc <filewrite>
}
    800047cc:	70a2                	ld	ra,40(sp)
    800047ce:	7402                	ld	s0,32(sp)
    800047d0:	6145                	addi	sp,sp,48
    800047d2:	8082                	ret

00000000800047d4 <sys_close>:
{
    800047d4:	1101                	addi	sp,sp,-32
    800047d6:	ec06                	sd	ra,24(sp)
    800047d8:	e822                	sd	s0,16(sp)
    800047da:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    800047dc:	fe040613          	addi	a2,s0,-32
    800047e0:	fec40593          	addi	a1,s0,-20
    800047e4:	4501                	li	a0,0
    800047e6:	d15ff0ef          	jal	800044fa <argfd>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    800047ec:	02054163          	bltz	a0,8000480e <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800047f0:	8cffc0ef          	jal	800010be <myproc>
    800047f4:	fec42783          	lw	a5,-20(s0)
    800047f8:	078e                	slli	a5,a5,0x3
    800047fa:	0d078793          	addi	a5,a5,208
    800047fe:	953e                	add	a0,a0,a5
    80004800:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004804:	fe043503          	ld	a0,-32(s0)
    80004808:	afeff0ef          	jal	80003b06 <fileclose>
  return 0;
    8000480c:	4781                	li	a5,0
}
    8000480e:	853e                	mv	a0,a5
    80004810:	60e2                	ld	ra,24(sp)
    80004812:	6442                	ld	s0,16(sp)
    80004814:	6105                	addi	sp,sp,32
    80004816:	8082                	ret

0000000080004818 <sys_fstat>:
{
    80004818:	1101                	addi	sp,sp,-32
    8000481a:	ec06                	sd	ra,24(sp)
    8000481c:	e822                	sd	s0,16(sp)
    8000481e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004820:	fe040593          	addi	a1,s0,-32
    80004824:	4505                	li	a0,1
    80004826:	895fd0ef          	jal	800020ba <argaddr>
  if (argfd(0, 0, &f) < 0)
    8000482a:	fe840613          	addi	a2,s0,-24
    8000482e:	4581                	li	a1,0
    80004830:	4501                	li	a0,0
    80004832:	cc9ff0ef          	jal	800044fa <argfd>
    80004836:	87aa                	mv	a5,a0
    return -1;
    80004838:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000483a:	0007c863          	bltz	a5,8000484a <sys_fstat+0x32>
  return filestat(f, st);
    8000483e:	fe043583          	ld	a1,-32(s0)
    80004842:	fe843503          	ld	a0,-24(s0)
    80004846:	b82ff0ef          	jal	80003bc8 <filestat>
}
    8000484a:	60e2                	ld	ra,24(sp)
    8000484c:	6442                	ld	s0,16(sp)
    8000484e:	6105                	addi	sp,sp,32
    80004850:	8082                	ret

0000000080004852 <sys_link>:
{
    80004852:	7169                	addi	sp,sp,-304
    80004854:	f606                	sd	ra,296(sp)
    80004856:	f222                	sd	s0,288(sp)
    80004858:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485a:	08000613          	li	a2,128
    8000485e:	ed040593          	addi	a1,s0,-304
    80004862:	4501                	li	a0,0
    80004864:	873fd0ef          	jal	800020d6 <argstr>
    return -1;
    80004868:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000486a:	10054163          	bltz	a0,8000496c <sys_link+0x11a>
    8000486e:	08000613          	li	a2,128
    80004872:	f5040593          	addi	a1,s0,-176
    80004876:	4505                	li	a0,1
    80004878:	85ffd0ef          	jal	800020d6 <argstr>
    return -1;
    8000487c:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000487e:	0e054763          	bltz	a0,8000496c <sys_link+0x11a>
    80004882:	ee26                	sd	s1,280(sp)
  begin_op();
    80004884:	dc9fe0ef          	jal	8000364c <begin_op>
  if ((ip = namei(old)) == 0) {
    80004888:	ed040513          	addi	a0,s0,-304
    8000488c:	be3fe0ef          	jal	8000346e <namei>
    80004890:	84aa                	mv	s1,a0
    80004892:	cd35                	beqz	a0,8000490e <sys_link+0xbc>
  ilock(ip);
    80004894:	b4efe0ef          	jal	80002be2 <ilock>
  if (ip->type == T_DIR) {
    80004898:	04449703          	lh	a4,68(s1)
    8000489c:	4785                	li	a5,1
    8000489e:	06f70d63          	beq	a4,a5,80004918 <sys_link+0xc6>
  if (ip->nlink >= NLINK_MAX) {
    800048a2:	04a49783          	lh	a5,74(s1)
    800048a6:	6721                	lui	a4,0x8
    800048a8:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    800048aa:	06e78f63          	beq	a5,a4,80004928 <sys_link+0xd6>
    800048ae:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800048b0:	2785                	addiw	a5,a5,1
    800048b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b6:	8526                	mv	a0,s1
    800048b8:	a76fe0ef          	jal	80002b2e <iupdate>
  iunlock(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	bd2fe0ef          	jal	80002c90 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    800048c2:	fd040593          	addi	a1,s0,-48
    800048c6:	f5040513          	addi	a0,s0,-176
    800048ca:	bbffe0ef          	jal	80003488 <nameiparent>
    800048ce:	892a                	mv	s2,a0
    800048d0:	c93d                	beqz	a0,80004946 <sys_link+0xf4>
  ilock(dp);
    800048d2:	b10fe0ef          	jal	80002be2 <ilock>
  if (dp->nlink == 0) {
    800048d6:	04a91783          	lh	a5,74(s2)
    800048da:	cfb9                	beqz	a5,80004938 <sys_link+0xe6>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    800048dc:	854a                	mv	a0,s2
    800048de:	00092703          	lw	a4,0(s2)
    800048e2:	409c                	lw	a5,0(s1)
    800048e4:	04f71e63          	bne	a4,a5,80004940 <sys_link+0xee>
    800048e8:	40d0                	lw	a2,4(s1)
    800048ea:	fd040593          	addi	a1,s0,-48
    800048ee:	ad7fe0ef          	jal	800033c4 <dirlink>
    800048f2:	04054763          	bltz	a0,80004940 <sys_link+0xee>
  iunlockput(dp);
    800048f6:	854a                	mv	a0,s2
    800048f8:	d3efe0ef          	jal	80002e36 <iunlockput>
  iput(ip);
    800048fc:	8526                	mv	a0,s1
    800048fe:	c66fe0ef          	jal	80002d64 <iput>
  end_op();
    80004902:	dd7fe0ef          	jal	800036d8 <end_op>
  return 0;
    80004906:	4781                	li	a5,0
    80004908:	64f2                	ld	s1,280(sp)
    8000490a:	6952                	ld	s2,272(sp)
    8000490c:	a085                	j	8000496c <sys_link+0x11a>
    end_op();
    8000490e:	dcbfe0ef          	jal	800036d8 <end_op>
    return -1;
    80004912:	57fd                	li	a5,-1
    80004914:	64f2                	ld	s1,280(sp)
    80004916:	a899                	j	8000496c <sys_link+0x11a>
    iunlockput(ip);
    80004918:	8526                	mv	a0,s1
    8000491a:	d1cfe0ef          	jal	80002e36 <iunlockput>
    end_op();
    8000491e:	dbbfe0ef          	jal	800036d8 <end_op>
    return -1;
    80004922:	57fd                	li	a5,-1
    80004924:	64f2                	ld	s1,280(sp)
    80004926:	a099                	j	8000496c <sys_link+0x11a>
    iunlockput(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	d0cfe0ef          	jal	80002e36 <iunlockput>
    end_op();
    8000492e:	dabfe0ef          	jal	800036d8 <end_op>
    return -1;
    80004932:	57fd                	li	a5,-1
    80004934:	64f2                	ld	s1,280(sp)
    80004936:	a81d                	j	8000496c <sys_link+0x11a>
    iunlockput(dp);
    80004938:	854a                	mv	a0,s2
    8000493a:	cfcfe0ef          	jal	80002e36 <iunlockput>
    goto bad;
    8000493e:	a021                	j	80004946 <sys_link+0xf4>
    iunlockput(dp);
    80004940:	854a                	mv	a0,s2
    80004942:	cf4fe0ef          	jal	80002e36 <iunlockput>
  ilock(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	a9afe0ef          	jal	80002be2 <ilock>
  ip->nlink--;
    8000494c:	04a4d783          	lhu	a5,74(s1)
    80004950:	37fd                	addiw	a5,a5,-1
    80004952:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004956:	8526                	mv	a0,s1
    80004958:	9d6fe0ef          	jal	80002b2e <iupdate>
  iunlockput(ip);
    8000495c:	8526                	mv	a0,s1
    8000495e:	cd8fe0ef          	jal	80002e36 <iunlockput>
  end_op();
    80004962:	d77fe0ef          	jal	800036d8 <end_op>
  return -1;
    80004966:	57fd                	li	a5,-1
    80004968:	64f2                	ld	s1,280(sp)
    8000496a:	6952                	ld	s2,272(sp)
}
    8000496c:	853e                	mv	a0,a5
    8000496e:	70b2                	ld	ra,296(sp)
    80004970:	7412                	ld	s0,288(sp)
    80004972:	6155                	addi	sp,sp,304
    80004974:	8082                	ret

0000000080004976 <sys_unlink>:
{
    80004976:	7151                	addi	sp,sp,-240
    80004978:	f586                	sd	ra,232(sp)
    8000497a:	f1a2                	sd	s0,224(sp)
    8000497c:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    8000497e:	08000613          	li	a2,128
    80004982:	f3040593          	addi	a1,s0,-208
    80004986:	4501                	li	a0,0
    80004988:	f4efd0ef          	jal	800020d6 <argstr>
    8000498c:	14054d63          	bltz	a0,80004ae6 <sys_unlink+0x170>
    80004990:	eda6                	sd	s1,216(sp)
  begin_op();
    80004992:	cbbfe0ef          	jal	8000364c <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004996:	fb040593          	addi	a1,s0,-80
    8000499a:	f3040513          	addi	a0,s0,-208
    8000499e:	aebfe0ef          	jal	80003488 <nameiparent>
    800049a2:	84aa                	mv	s1,a0
    800049a4:	c955                	beqz	a0,80004a58 <sys_unlink+0xe2>
  ilock(dp);
    800049a6:	a3cfe0ef          	jal	80002be2 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049aa:	00004597          	auipc	a1,0x4
    800049ae:	cb658593          	addi	a1,a1,-842 # 80008660 <etext+0x660>
    800049b2:	fb040513          	addi	a0,s0,-80
    800049b6:	ffefe0ef          	jal	800031b4 <namecmp>
    800049ba:	10050b63          	beqz	a0,80004ad0 <sys_unlink+0x15a>
    800049be:	00004597          	auipc	a1,0x4
    800049c2:	caa58593          	addi	a1,a1,-854 # 80008668 <etext+0x668>
    800049c6:	fb040513          	addi	a0,s0,-80
    800049ca:	feafe0ef          	jal	800031b4 <namecmp>
    800049ce:	10050163          	beqz	a0,80004ad0 <sys_unlink+0x15a>
    800049d2:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    800049d4:	f2c40613          	addi	a2,s0,-212
    800049d8:	fb040593          	addi	a1,s0,-80
    800049dc:	8526                	mv	a0,s1
    800049de:	fecfe0ef          	jal	800031ca <dirlookup>
    800049e2:	892a                	mv	s2,a0
    800049e4:	0e050563          	beqz	a0,80004ace <sys_unlink+0x158>
    800049e8:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800049ea:	9f8fe0ef          	jal	80002be2 <ilock>
  if (ip->nlink < 1)
    800049ee:	04a91783          	lh	a5,74(s2)
    800049f2:	06f05863          	blez	a5,80004a62 <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    800049f6:	04491703          	lh	a4,68(s2)
    800049fa:	4785                	li	a5,1
    800049fc:	06f70963          	beq	a4,a5,80004a6e <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004a00:	fc040993          	addi	s3,s0,-64
    80004a04:	4641                	li	a2,16
    80004a06:	4581                	li	a1,0
    80004a08:	854e                	mv	a0,s3
    80004a0a:	f54fb0ef          	jal	8000015e <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a0e:	4741                	li	a4,16
    80004a10:	f2c42683          	lw	a3,-212(s0)
    80004a14:	864e                	mv	a2,s3
    80004a16:	4581                	li	a1,0
    80004a18:	8526                	mv	a0,s1
    80004a1a:	e94fe0ef          	jal	800030ae <writei>
    80004a1e:	47c1                	li	a5,16
    80004a20:	08f51863          	bne	a0,a5,80004ab0 <sys_unlink+0x13a>
  if (ip->type == T_DIR) {
    80004a24:	04491703          	lh	a4,68(s2)
    80004a28:	4785                	li	a5,1
    80004a2a:	08f70963          	beq	a4,a5,80004abc <sys_unlink+0x146>
  iunlockput(dp);
    80004a2e:	8526                	mv	a0,s1
    80004a30:	c06fe0ef          	jal	80002e36 <iunlockput>
  ip->nlink--;
    80004a34:	04a95783          	lhu	a5,74(s2)
    80004a38:	37fd                	addiw	a5,a5,-1
    80004a3a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a3e:	854a                	mv	a0,s2
    80004a40:	8eefe0ef          	jal	80002b2e <iupdate>
  iunlockput(ip);
    80004a44:	854a                	mv	a0,s2
    80004a46:	bf0fe0ef          	jal	80002e36 <iunlockput>
  end_op();
    80004a4a:	c8ffe0ef          	jal	800036d8 <end_op>
  return 0;
    80004a4e:	4501                	li	a0,0
    80004a50:	64ee                	ld	s1,216(sp)
    80004a52:	694e                	ld	s2,208(sp)
    80004a54:	69ae                	ld	s3,200(sp)
    80004a56:	a061                	j	80004ade <sys_unlink+0x168>
    end_op();
    80004a58:	c81fe0ef          	jal	800036d8 <end_op>
    return -1;
    80004a5c:	557d                	li	a0,-1
    80004a5e:	64ee                	ld	s1,216(sp)
    80004a60:	a8bd                	j	80004ade <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004a62:	00004517          	auipc	a0,0x4
    80004a66:	c0e50513          	addi	a0,a0,-1010 # 80008670 <etext+0x670>
    80004a6a:	49a010ef          	jal	80005f04 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004a6e:	04c92703          	lw	a4,76(s2)
    80004a72:	02000793          	li	a5,32
    80004a76:	f8e7f5e3          	bgeu	a5,a4,80004a00 <sys_unlink+0x8a>
    80004a7a:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a7c:	4741                	li	a4,16
    80004a7e:	86ce                	mv	a3,s3
    80004a80:	f1840613          	addi	a2,s0,-232
    80004a84:	4581                	li	a1,0
    80004a86:	854a                	mv	a0,s2
    80004a88:	d34fe0ef          	jal	80002fbc <readi>
    80004a8c:	47c1                	li	a5,16
    80004a8e:	00f51b63          	bne	a0,a5,80004aa4 <sys_unlink+0x12e>
    if (de.inum != 0)
    80004a92:	f1845783          	lhu	a5,-232(s0)
    80004a96:	ebb1                	bnez	a5,80004aea <sys_unlink+0x174>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004a98:	29c1                	addiw	s3,s3,16
    80004a9a:	04c92783          	lw	a5,76(s2)
    80004a9e:	fcf9efe3          	bltu	s3,a5,80004a7c <sys_unlink+0x106>
    80004aa2:	bfb9                	j	80004a00 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004aa4:	00004517          	auipc	a0,0x4
    80004aa8:	be450513          	addi	a0,a0,-1052 # 80008688 <etext+0x688>
    80004aac:	458010ef          	jal	80005f04 <panic>
    panic("unlink: writei");
    80004ab0:	00004517          	auipc	a0,0x4
    80004ab4:	bf050513          	addi	a0,a0,-1040 # 800086a0 <etext+0x6a0>
    80004ab8:	44c010ef          	jal	80005f04 <panic>
    dp->nlink--;
    80004abc:	04a4d783          	lhu	a5,74(s1)
    80004ac0:	37fd                	addiw	a5,a5,-1
    80004ac2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	866fe0ef          	jal	80002b2e <iupdate>
    80004acc:	b78d                	j	80004a2e <sys_unlink+0xb8>
    80004ace:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	b64fe0ef          	jal	80002e36 <iunlockput>
  end_op();
    80004ad6:	c03fe0ef          	jal	800036d8 <end_op>
  return -1;
    80004ada:	557d                	li	a0,-1
    80004adc:	64ee                	ld	s1,216(sp)
}
    80004ade:	70ae                	ld	ra,232(sp)
    80004ae0:	740e                	ld	s0,224(sp)
    80004ae2:	616d                	addi	sp,sp,240
    80004ae4:	8082                	ret
    return -1;
    80004ae6:	557d                	li	a0,-1
    80004ae8:	bfdd                	j	80004ade <sys_unlink+0x168>
    iunlockput(ip);
    80004aea:	854a                	mv	a0,s2
    80004aec:	b4afe0ef          	jal	80002e36 <iunlockput>
    goto bad;
    80004af0:	694e                	ld	s2,208(sp)
    80004af2:	69ae                	ld	s3,200(sp)
    80004af4:	bff1                	j	80004ad0 <sys_unlink+0x15a>

0000000080004af6 <sys_open>:

uint64
sys_open(void)
{
    80004af6:	7131                	addi	sp,sp,-192
    80004af8:	fd06                	sd	ra,184(sp)
    80004afa:	f922                	sd	s0,176(sp)
    80004afc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004afe:	f4c40593          	addi	a1,s0,-180
    80004b02:	4505                	li	a0,1
    80004b04:	d9afd0ef          	jal	8000209e <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004b08:	08000613          	li	a2,128
    80004b0c:	f5040593          	addi	a1,s0,-176
    80004b10:	4501                	li	a0,0
    80004b12:	dc4fd0ef          	jal	800020d6 <argstr>
    80004b16:	87aa                	mv	a5,a0
    return -1;
    80004b18:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004b1a:	0a07c363          	bltz	a5,80004bc0 <sys_open+0xca>
    80004b1e:	f526                	sd	s1,168(sp)

  begin_op();
    80004b20:	b2dfe0ef          	jal	8000364c <begin_op>

  if (omode & O_CREATE) {
    80004b24:	f4c42783          	lw	a5,-180(s0)
    80004b28:	2007f793          	andi	a5,a5,512
    80004b2c:	c3dd                	beqz	a5,80004bd2 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004b2e:	4681                	li	a3,0
    80004b30:	4601                	li	a2,0
    80004b32:	4589                	li	a1,2
    80004b34:	f5040513          	addi	a0,s0,-176
    80004b38:	a5dff0ef          	jal	80004594 <create>
    80004b3c:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004b3e:	c549                	beqz	a0,80004bc8 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004b40:	04449703          	lh	a4,68(s1)
    80004b44:	478d                	li	a5,3
    80004b46:	00f71763          	bne	a4,a5,80004b54 <sys_open+0x5e>
    80004b4a:	0464d703          	lhu	a4,70(s1)
    80004b4e:	47a5                	li	a5,9
    80004b50:	0ae7ee63          	bltu	a5,a4,80004c0c <sys_open+0x116>
    80004b54:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004b56:	f0dfe0ef          	jal	80003a62 <filealloc>
    80004b5a:	892a                	mv	s2,a0
    80004b5c:	c561                	beqz	a0,80004c24 <sys_open+0x12e>
    80004b5e:	ed4e                	sd	s3,152(sp)
    80004b60:	9f5ff0ef          	jal	80004554 <fdalloc>
    80004b64:	89aa                	mv	s3,a0
    80004b66:	0a054b63          	bltz	a0,80004c1c <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004b6a:	04449703          	lh	a4,68(s1)
    80004b6e:	478d                	li	a5,3
    80004b70:	0cf70363          	beq	a4,a5,80004c36 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b74:	4789                	li	a5,2
    80004b76:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004b7a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004b7e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004b82:	f4c42783          	lw	a5,-180(s0)
    80004b86:	0017f713          	andi	a4,a5,1
    80004b8a:	00174713          	xori	a4,a4,1
    80004b8e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b92:	0037f713          	andi	a4,a5,3
    80004b96:	00e03733          	snez	a4,a4
    80004b9a:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004b9e:	4007f793          	andi	a5,a5,1024
    80004ba2:	c791                	beqz	a5,80004bae <sys_open+0xb8>
    80004ba4:	04449703          	lh	a4,68(s1)
    80004ba8:	4789                	li	a5,2
    80004baa:	08f70d63          	beq	a4,a5,80004c44 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	8e0fe0ef          	jal	80002c90 <iunlock>
  end_op();
    80004bb4:	b25fe0ef          	jal	800036d8 <end_op>

  return fd;
    80004bb8:	854e                	mv	a0,s3
    80004bba:	74aa                	ld	s1,168(sp)
    80004bbc:	790a                	ld	s2,160(sp)
    80004bbe:	69ea                	ld	s3,152(sp)
}
    80004bc0:	70ea                	ld	ra,184(sp)
    80004bc2:	744a                	ld	s0,176(sp)
    80004bc4:	6129                	addi	sp,sp,192
    80004bc6:	8082                	ret
      end_op();
    80004bc8:	b11fe0ef          	jal	800036d8 <end_op>
      return -1;
    80004bcc:	557d                	li	a0,-1
    80004bce:	74aa                	ld	s1,168(sp)
    80004bd0:	bfc5                	j	80004bc0 <sys_open+0xca>
    if ((ip = namei(path)) == 0) {
    80004bd2:	f5040513          	addi	a0,s0,-176
    80004bd6:	899fe0ef          	jal	8000346e <namei>
    80004bda:	84aa                	mv	s1,a0
    80004bdc:	c11d                	beqz	a0,80004c02 <sys_open+0x10c>
    ilock(ip);
    80004bde:	804fe0ef          	jal	80002be2 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004be2:	04449703          	lh	a4,68(s1)
    80004be6:	4785                	li	a5,1
    80004be8:	f4f71ce3          	bne	a4,a5,80004b40 <sys_open+0x4a>
    80004bec:	f4c42783          	lw	a5,-180(s0)
    80004bf0:	d3b5                	beqz	a5,80004b54 <sys_open+0x5e>
      iunlockput(ip);
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	a42fe0ef          	jal	80002e36 <iunlockput>
      end_op();
    80004bf8:	ae1fe0ef          	jal	800036d8 <end_op>
      return -1;
    80004bfc:	557d                	li	a0,-1
    80004bfe:	74aa                	ld	s1,168(sp)
    80004c00:	b7c1                	j	80004bc0 <sys_open+0xca>
      end_op();
    80004c02:	ad7fe0ef          	jal	800036d8 <end_op>
      return -1;
    80004c06:	557d                	li	a0,-1
    80004c08:	74aa                	ld	s1,168(sp)
    80004c0a:	bf5d                	j	80004bc0 <sys_open+0xca>
    iunlockput(ip);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	a28fe0ef          	jal	80002e36 <iunlockput>
    end_op();
    80004c12:	ac7fe0ef          	jal	800036d8 <end_op>
    return -1;
    80004c16:	557d                	li	a0,-1
    80004c18:	74aa                	ld	s1,168(sp)
    80004c1a:	b75d                	j	80004bc0 <sys_open+0xca>
      fileclose(f);
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	ee9fe0ef          	jal	80003b06 <fileclose>
    80004c22:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004c24:	8526                	mv	a0,s1
    80004c26:	a10fe0ef          	jal	80002e36 <iunlockput>
    end_op();
    80004c2a:	aaffe0ef          	jal	800036d8 <end_op>
    return -1;
    80004c2e:	557d                	li	a0,-1
    80004c30:	74aa                	ld	s1,168(sp)
    80004c32:	790a                	ld	s2,160(sp)
    80004c34:	b771                	j	80004bc0 <sys_open+0xca>
    f->type = FD_DEVICE;
    80004c36:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004c3a:	04649783          	lh	a5,70(s1)
    80004c3e:	02f91223          	sh	a5,36(s2)
    80004c42:	bf35                	j	80004b7e <sys_open+0x88>
    itrunc(ip);
    80004c44:	8526                	mv	a0,s1
    80004c46:	88afe0ef          	jal	80002cd0 <itrunc>
    80004c4a:	b795                	j	80004bae <sys_open+0xb8>

0000000080004c4c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c4c:	7175                	addi	sp,sp,-144
    80004c4e:	e506                	sd	ra,136(sp)
    80004c50:	e122                	sd	s0,128(sp)
    80004c52:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c54:	9f9fe0ef          	jal	8000364c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004c58:	08000613          	li	a2,128
    80004c5c:	f7040593          	addi	a1,s0,-144
    80004c60:	4501                	li	a0,0
    80004c62:	c74fd0ef          	jal	800020d6 <argstr>
    80004c66:	02054363          	bltz	a0,80004c8c <sys_mkdir+0x40>
    80004c6a:	4681                	li	a3,0
    80004c6c:	4601                	li	a2,0
    80004c6e:	4585                	li	a1,1
    80004c70:	f7040513          	addi	a0,s0,-144
    80004c74:	921ff0ef          	jal	80004594 <create>
    80004c78:	c911                	beqz	a0,80004c8c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c7a:	9bcfe0ef          	jal	80002e36 <iunlockput>
  end_op();
    80004c7e:	a5bfe0ef          	jal	800036d8 <end_op>
  return 0;
    80004c82:	4501                	li	a0,0
}
    80004c84:	60aa                	ld	ra,136(sp)
    80004c86:	640a                	ld	s0,128(sp)
    80004c88:	6149                	addi	sp,sp,144
    80004c8a:	8082                	ret
    end_op();
    80004c8c:	a4dfe0ef          	jal	800036d8 <end_op>
    return -1;
    80004c90:	557d                	li	a0,-1
    80004c92:	bfcd                	j	80004c84 <sys_mkdir+0x38>

0000000080004c94 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c94:	7135                	addi	sp,sp,-160
    80004c96:	ed06                	sd	ra,152(sp)
    80004c98:	e922                	sd	s0,144(sp)
    80004c9a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c9c:	9b1fe0ef          	jal	8000364c <begin_op>
  argint(1, &major);
    80004ca0:	f6c40593          	addi	a1,s0,-148
    80004ca4:	4505                	li	a0,1
    80004ca6:	bf8fd0ef          	jal	8000209e <argint>
  argint(2, &minor);
    80004caa:	f6840593          	addi	a1,s0,-152
    80004cae:	4509                	li	a0,2
    80004cb0:	beefd0ef          	jal	8000209e <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004cb4:	08000613          	li	a2,128
    80004cb8:	f7040593          	addi	a1,s0,-144
    80004cbc:	4501                	li	a0,0
    80004cbe:	c18fd0ef          	jal	800020d6 <argstr>
    80004cc2:	02054563          	bltz	a0,80004cec <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004cc6:	f6841683          	lh	a3,-152(s0)
    80004cca:	f6c41603          	lh	a2,-148(s0)
    80004cce:	458d                	li	a1,3
    80004cd0:	f7040513          	addi	a0,s0,-144
    80004cd4:	8c1ff0ef          	jal	80004594 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004cd8:	c911                	beqz	a0,80004cec <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cda:	95cfe0ef          	jal	80002e36 <iunlockput>
  end_op();
    80004cde:	9fbfe0ef          	jal	800036d8 <end_op>
  return 0;
    80004ce2:	4501                	li	a0,0
}
    80004ce4:	60ea                	ld	ra,152(sp)
    80004ce6:	644a                	ld	s0,144(sp)
    80004ce8:	610d                	addi	sp,sp,160
    80004cea:	8082                	ret
    end_op();
    80004cec:	9edfe0ef          	jal	800036d8 <end_op>
    return -1;
    80004cf0:	557d                	li	a0,-1
    80004cf2:	bfcd                	j	80004ce4 <sys_mknod+0x50>

0000000080004cf4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cf4:	7135                	addi	sp,sp,-160
    80004cf6:	ed06                	sd	ra,152(sp)
    80004cf8:	e922                	sd	s0,144(sp)
    80004cfa:	e14a                	sd	s2,128(sp)
    80004cfc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cfe:	bc0fc0ef          	jal	800010be <myproc>
    80004d02:	892a                	mv	s2,a0

  begin_op();
    80004d04:	949fe0ef          	jal	8000364c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004d08:	08000613          	li	a2,128
    80004d0c:	f6040593          	addi	a1,s0,-160
    80004d10:	4501                	li	a0,0
    80004d12:	bc4fd0ef          	jal	800020d6 <argstr>
    80004d16:	04054363          	bltz	a0,80004d5c <sys_chdir+0x68>
    80004d1a:	e526                	sd	s1,136(sp)
    80004d1c:	f6040513          	addi	a0,s0,-160
    80004d20:	f4efe0ef          	jal	8000346e <namei>
    80004d24:	84aa                	mv	s1,a0
    80004d26:	c915                	beqz	a0,80004d5a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d28:	ebbfd0ef          	jal	80002be2 <ilock>
  if (ip->type != T_DIR) {
    80004d2c:	04449703          	lh	a4,68(s1)
    80004d30:	4785                	li	a5,1
    80004d32:	02f71963          	bne	a4,a5,80004d64 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d36:	8526                	mv	a0,s1
    80004d38:	f59fd0ef          	jal	80002c90 <iunlock>
  iput(p->cwd);
    80004d3c:	15093503          	ld	a0,336(s2)
    80004d40:	824fe0ef          	jal	80002d64 <iput>
  end_op();
    80004d44:	995fe0ef          	jal	800036d8 <end_op>
  p->cwd = ip;
    80004d48:	14993823          	sd	s1,336(s2)
  return 0;
    80004d4c:	4501                	li	a0,0
    80004d4e:	64aa                	ld	s1,136(sp)
}
    80004d50:	60ea                	ld	ra,152(sp)
    80004d52:	644a                	ld	s0,144(sp)
    80004d54:	690a                	ld	s2,128(sp)
    80004d56:	610d                	addi	sp,sp,160
    80004d58:	8082                	ret
    80004d5a:	64aa                	ld	s1,136(sp)
    end_op();
    80004d5c:	97dfe0ef          	jal	800036d8 <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b7fd                	j	80004d50 <sys_chdir+0x5c>
    iunlockput(ip);
    80004d64:	8526                	mv	a0,s1
    80004d66:	8d0fe0ef          	jal	80002e36 <iunlockput>
    end_op();
    80004d6a:	96ffe0ef          	jal	800036d8 <end_op>
    return -1;
    80004d6e:	557d                	li	a0,-1
    80004d70:	64aa                	ld	s1,136(sp)
    80004d72:	bff9                	j	80004d50 <sys_chdir+0x5c>

0000000080004d74 <sys_exec>:

uint64
sys_exec(void)
{
    80004d74:	7105                	addi	sp,sp,-480
    80004d76:	ef86                	sd	ra,472(sp)
    80004d78:	eba2                	sd	s0,464(sp)
    80004d7a:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004d7c:	e2840593          	addi	a1,s0,-472
    80004d80:	4505                	li	a0,1
    80004d82:	b38fd0ef          	jal	800020ba <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80004d86:	08000613          	li	a2,128
    80004d8a:	f3040593          	addi	a1,s0,-208
    80004d8e:	4501                	li	a0,0
    80004d90:	b46fd0ef          	jal	800020d6 <argstr>
    80004d94:	87aa                	mv	a5,a0
    return -1;
    80004d96:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80004d98:	0e07c063          	bltz	a5,80004e78 <sys_exec+0x104>
    80004d9c:	e7a6                	sd	s1,456(sp)
    80004d9e:	e3ca                	sd	s2,448(sp)
    80004da0:	ff4e                	sd	s3,440(sp)
    80004da2:	fb52                	sd	s4,432(sp)
    80004da4:	f756                	sd	s5,424(sp)
    80004da6:	f35a                	sd	s6,416(sp)
    80004da8:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004daa:	e3040a13          	addi	s4,s0,-464
    80004dae:	10000613          	li	a2,256
    80004db2:	4581                	li	a1,0
    80004db4:	8552                	mv	a0,s4
    80004db6:	ba8fb0ef          	jal	8000015e <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80004dba:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004dbc:	89d2                	mv	s3,s4
    80004dbe:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004dc0:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004dc4:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    80004dc6:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004dca:	00391513          	slli	a0,s2,0x3
    80004dce:	85d6                	mv	a1,s5
    80004dd0:	e2843783          	ld	a5,-472(s0)
    80004dd4:	953e                	add	a0,a0,a5
    80004dd6:	a3cfd0ef          	jal	80002012 <fetchaddr>
    80004dda:	02054663          	bltz	a0,80004e06 <sys_exec+0x92>
    if (uarg == 0) {
    80004dde:	e2043783          	ld	a5,-480(s0)
    80004de2:	c7a1                	beqz	a5,80004e2a <sys_exec+0xb6>
    argv[i] = kalloc();
    80004de4:	b20fb0ef          	jal	80000104 <kalloc>
    80004de8:	85aa                	mv	a1,a0
    80004dea:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80004dee:	cd01                	beqz	a0,80004e06 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004df0:	865a                	mv	a2,s6
    80004df2:	e2043503          	ld	a0,-480(s0)
    80004df6:	a66fd0ef          	jal	8000205c <fetchstr>
    80004dfa:	00054663          	bltz	a0,80004e06 <sys_exec+0x92>
    if (i >= NELEM(argv)) {
    80004dfe:	0905                	addi	s2,s2,1
    80004e00:	09a1                	addi	s3,s3,8
    80004e02:	fd7914e3          	bne	s2,s7,80004dca <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e06:	100a0a13          	addi	s4,s4,256
    80004e0a:	6088                	ld	a0,0(s1)
    80004e0c:	cd31                	beqz	a0,80004e68 <sys_exec+0xf4>
    kfree(argv[i]);
    80004e0e:	a0efb0ef          	jal	8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e12:	04a1                	addi	s1,s1,8
    80004e14:	ff449be3          	bne	s1,s4,80004e0a <sys_exec+0x96>
  return -1;
    80004e18:	557d                	li	a0,-1
    80004e1a:	64be                	ld	s1,456(sp)
    80004e1c:	691e                	ld	s2,448(sp)
    80004e1e:	79fa                	ld	s3,440(sp)
    80004e20:	7a5a                	ld	s4,432(sp)
    80004e22:	7aba                	ld	s5,424(sp)
    80004e24:	7b1a                	ld	s6,416(sp)
    80004e26:	6bfa                	ld	s7,408(sp)
    80004e28:	a881                	j	80004e78 <sys_exec+0x104>
      argv[i] = 0;
    80004e2a:	0009079b          	sext.w	a5,s2
    80004e2e:	e3040593          	addi	a1,s0,-464
    80004e32:	078e                	slli	a5,a5,0x3
    80004e34:	97ae                	add	a5,a5,a1
    80004e36:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004e3a:	f3040513          	addi	a0,s0,-208
    80004e3e:	b62ff0ef          	jal	800041a0 <kexec>
    80004e42:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e44:	100a0a13          	addi	s4,s4,256
    80004e48:	6088                	ld	a0,0(s1)
    80004e4a:	c511                	beqz	a0,80004e56 <sys_exec+0xe2>
    kfree(argv[i]);
    80004e4c:	9d0fb0ef          	jal	8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e50:	04a1                	addi	s1,s1,8
    80004e52:	ff449be3          	bne	s1,s4,80004e48 <sys_exec+0xd4>
  return ret;
    80004e56:	854a                	mv	a0,s2
    80004e58:	64be                	ld	s1,456(sp)
    80004e5a:	691e                	ld	s2,448(sp)
    80004e5c:	79fa                	ld	s3,440(sp)
    80004e5e:	7a5a                	ld	s4,432(sp)
    80004e60:	7aba                	ld	s5,424(sp)
    80004e62:	7b1a                	ld	s6,416(sp)
    80004e64:	6bfa                	ld	s7,408(sp)
    80004e66:	a809                	j	80004e78 <sys_exec+0x104>
  return -1;
    80004e68:	557d                	li	a0,-1
    80004e6a:	64be                	ld	s1,456(sp)
    80004e6c:	691e                	ld	s2,448(sp)
    80004e6e:	79fa                	ld	s3,440(sp)
    80004e70:	7a5a                	ld	s4,432(sp)
    80004e72:	7aba                	ld	s5,424(sp)
    80004e74:	7b1a                	ld	s6,416(sp)
    80004e76:	6bfa                	ld	s7,408(sp)
}
    80004e78:	60fe                	ld	ra,472(sp)
    80004e7a:	645e                	ld	s0,464(sp)
    80004e7c:	613d                	addi	sp,sp,480
    80004e7e:	8082                	ret

0000000080004e80 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e80:	7139                	addi	sp,sp,-64
    80004e82:	fc06                	sd	ra,56(sp)
    80004e84:	f822                	sd	s0,48(sp)
    80004e86:	f426                	sd	s1,40(sp)
    80004e88:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e8a:	a34fc0ef          	jal	800010be <myproc>
    80004e8e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004e90:	fd840593          	addi	a1,s0,-40
    80004e94:	4501                	li	a0,0
    80004e96:	a24fd0ef          	jal	800020ba <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80004e9a:	fc840593          	addi	a1,s0,-56
    80004e9e:	fd040513          	addi	a0,s0,-48
    80004ea2:	f99fe0ef          	jal	80003e3a <pipealloc>
    return -1;
    80004ea6:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80004ea8:	0a054963          	bltz	a0,80004f5a <sys_pipe+0xda>
  fd0 = -1;
    80004eac:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80004eb0:	fd043503          	ld	a0,-48(s0)
    80004eb4:	ea0ff0ef          	jal	80004554 <fdalloc>
    80004eb8:	fca42223          	sw	a0,-60(s0)
    80004ebc:	08054663          	bltz	a0,80004f48 <sys_pipe+0xc8>
    80004ec0:	fc843503          	ld	a0,-56(s0)
    80004ec4:	e90ff0ef          	jal	80004554 <fdalloc>
    80004ec8:	fca42023          	sw	a0,-64(s0)
    80004ecc:	06054463          	bltz	a0,80004f34 <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004ed0:	4711                	li	a4,4
    80004ed2:	fc440693          	addi	a3,s0,-60
    80004ed6:	fd843603          	ld	a2,-40(s0)
    80004eda:	64ac                	ld	a1,72(s1)
    80004edc:	68a8                	ld	a0,80(s1)
    80004ede:	e19fb0ef          	jal	80000cf6 <copyout>
    80004ee2:	00054f63          	bltz	a0,80004f00 <sys_pipe+0x80>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80004ee6:	4711                	li	a4,4
    80004ee8:	fc040693          	addi	a3,s0,-64
    80004eec:	fd843603          	ld	a2,-40(s0)
    80004ef0:	963a                	add	a2,a2,a4
    80004ef2:	64ac                	ld	a1,72(s1)
    80004ef4:	68a8                	ld	a0,80(s1)
    80004ef6:	e01fb0ef          	jal	80000cf6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004efa:	4781                	li	a5,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004efc:	04055f63          	bgez	a0,80004f5a <sys_pipe+0xda>
    p->ofile[fd0] = 0;
    80004f00:	fc442783          	lw	a5,-60(s0)
    80004f04:	078e                	slli	a5,a5,0x3
    80004f06:	0d078793          	addi	a5,a5,208
    80004f0a:	97a6                	add	a5,a5,s1
    80004f0c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f10:	fc042783          	lw	a5,-64(s0)
    80004f14:	078e                	slli	a5,a5,0x3
    80004f16:	0d078793          	addi	a5,a5,208
    80004f1a:	94be                	add	s1,s1,a5
    80004f1c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f20:	fd043503          	ld	a0,-48(s0)
    80004f24:	be3fe0ef          	jal	80003b06 <fileclose>
    fileclose(wf);
    80004f28:	fc843503          	ld	a0,-56(s0)
    80004f2c:	bdbfe0ef          	jal	80003b06 <fileclose>
    return -1;
    80004f30:	57fd                	li	a5,-1
    80004f32:	a025                	j	80004f5a <sys_pipe+0xda>
    if (fd0 >= 0)
    80004f34:	fc442783          	lw	a5,-60(s0)
    80004f38:	0007c863          	bltz	a5,80004f48 <sys_pipe+0xc8>
      p->ofile[fd0] = 0;
    80004f3c:	078e                	slli	a5,a5,0x3
    80004f3e:	0d078793          	addi	a5,a5,208
    80004f42:	97a6                	add	a5,a5,s1
    80004f44:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f48:	fd043503          	ld	a0,-48(s0)
    80004f4c:	bbbfe0ef          	jal	80003b06 <fileclose>
    fileclose(wf);
    80004f50:	fc843503          	ld	a0,-56(s0)
    80004f54:	bb3fe0ef          	jal	80003b06 <fileclose>
    return -1;
    80004f58:	57fd                	li	a5,-1
}
    80004f5a:	853e                	mv	a0,a5
    80004f5c:	70e2                	ld	ra,56(sp)
    80004f5e:	7442                	ld	s0,48(sp)
    80004f60:	74a2                	ld	s1,40(sp)
    80004f62:	6121                	addi	sp,sp,64
    80004f64:	8082                	ret
	...

0000000080004f70 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004f70:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004f72:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004f74:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80004f76:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004f78:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004f7a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004f7c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004f7e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004f80:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004f82:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004f84:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004f86:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004f88:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004f8a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004f8c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004f8e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004f90:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004f92:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004f94:	f8dfc0ef          	jal	80001f20 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004f98:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004f9a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004f9c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004f9e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004fa0:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004fa2:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004fa4:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004fa6:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004fa8:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004faa:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004fac:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004fae:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004fb0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004fb2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004fb4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004fb6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004fb8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004fba:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004fbc:	10200073          	sret
    80004fc0:	0001                	nop
    80004fc2:	00000013          	nop
    80004fc6:	00000013          	nop
    80004fca:	00000013          	nop

0000000080004fce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004fce:	1141                	addi	sp,sp,-16
    80004fd0:	e406                	sd	ra,8(sp)
    80004fd2:	e022                	sd	s0,0(sp)
    80004fd4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80004fd6:	0c000737          	lui	a4,0xc000
    80004fda:	4785                	li	a5,1
    80004fdc:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80004fde:	c35c                	sw	a5,4(a4)
}
    80004fe0:	60a2                	ld	ra,8(sp)
    80004fe2:	6402                	ld	s0,0(sp)
    80004fe4:	0141                	addi	sp,sp,16
    80004fe6:	8082                	ret

0000000080004fe8 <plicinithart>:

void
plicinithart(void)
{
    80004fe8:	1141                	addi	sp,sp,-16
    80004fea:	e406                	sd	ra,8(sp)
    80004fec:	e022                	sd	s0,0(sp)
    80004fee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ff0:	89afc0ef          	jal	8000108a <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004ff4:	0085171b          	slliw	a4,a0,0x8
    80004ff8:	0c0027b7          	lui	a5,0xc002
    80004ffc:	97ba                	add	a5,a5,a4
    80004ffe:	40200713          	li	a4,1026
    80005002:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005006:	00d5151b          	slliw	a0,a0,0xd
    8000500a:	0c2017b7          	lui	a5,0xc201
    8000500e:	97aa                	add	a5,a5,a0
    80005010:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005014:	60a2                	ld	ra,8(sp)
    80005016:	6402                	ld	s0,0(sp)
    80005018:	0141                	addi	sp,sp,16
    8000501a:	8082                	ret

000000008000501c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000501c:	1141                	addi	sp,sp,-16
    8000501e:	e406                	sd	ra,8(sp)
    80005020:	e022                	sd	s0,0(sp)
    80005022:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005024:	866fc0ef          	jal	8000108a <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005028:	00d5151b          	slliw	a0,a0,0xd
    8000502c:	0c2017b7          	lui	a5,0xc201
    80005030:	97aa                	add	a5,a5,a0
  return irq;
}
    80005032:	43c8                	lw	a0,4(a5)
    80005034:	60a2                	ld	ra,8(sp)
    80005036:	6402                	ld	s0,0(sp)
    80005038:	0141                	addi	sp,sp,16
    8000503a:	8082                	ret

000000008000503c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000503c:	1101                	addi	sp,sp,-32
    8000503e:	ec06                	sd	ra,24(sp)
    80005040:	e822                	sd	s0,16(sp)
    80005042:	e426                	sd	s1,8(sp)
    80005044:	1000                	addi	s0,sp,32
    80005046:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005048:	842fc0ef          	jal	8000108a <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    8000504c:	00d5179b          	slliw	a5,a0,0xd
    80005050:	0c201737          	lui	a4,0xc201
    80005054:	97ba                	add	a5,a5,a4
    80005056:	c3c4                	sw	s1,4(a5)
}
    80005058:	60e2                	ld	ra,24(sp)
    8000505a:	6442                	ld	s0,16(sp)
    8000505c:	64a2                	ld	s1,8(sp)
    8000505e:	6105                	addi	sp,sp,32
    80005060:	8082                	ret

0000000080005062 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005062:	1141                	addi	sp,sp,-16
    80005064:	e406                	sd	ra,8(sp)
    80005066:	e022                	sd	s0,0(sp)
    80005068:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000506a:	479d                	li	a5,7
    8000506c:	04a7ca63          	blt	a5,a0,800050c0 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005070:	00018797          	auipc	a5,0x18
    80005074:	91078793          	addi	a5,a5,-1776 # 8001c980 <disk>
    80005078:	97aa                	add	a5,a5,a0
    8000507a:	0187c783          	lbu	a5,24(a5)
    8000507e:	e7b9                	bnez	a5,800050cc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005080:	00451693          	slli	a3,a0,0x4
    80005084:	00018797          	auipc	a5,0x18
    80005088:	8fc78793          	addi	a5,a5,-1796 # 8001c980 <disk>
    8000508c:	6398                	ld	a4,0(a5)
    8000508e:	9736                	add	a4,a4,a3
    80005090:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005094:	6398                	ld	a4,0(a5)
    80005096:	9736                	add	a4,a4,a3
    80005098:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000509c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800050a0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800050a4:	97aa                	add	a5,a5,a0
    800050a6:	4705                	li	a4,1
    800050a8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800050ac:	00018517          	auipc	a0,0x18
    800050b0:	8ec50513          	addi	a0,a0,-1812 # 8001c998 <disk+0x18>
    800050b4:	f1efc0ef          	jal	800017d2 <wakeup>
}
    800050b8:	60a2                	ld	ra,8(sp)
    800050ba:	6402                	ld	s0,0(sp)
    800050bc:	0141                	addi	sp,sp,16
    800050be:	8082                	ret
    panic("free_desc 1");
    800050c0:	00003517          	auipc	a0,0x3
    800050c4:	5f050513          	addi	a0,a0,1520 # 800086b0 <etext+0x6b0>
    800050c8:	63d000ef          	jal	80005f04 <panic>
    panic("free_desc 2");
    800050cc:	00003517          	auipc	a0,0x3
    800050d0:	5f450513          	addi	a0,a0,1524 # 800086c0 <etext+0x6c0>
    800050d4:	631000ef          	jal	80005f04 <panic>

00000000800050d8 <virtio_disk_init>:
{
    800050d8:	1101                	addi	sp,sp,-32
    800050da:	ec06                	sd	ra,24(sp)
    800050dc:	e822                	sd	s0,16(sp)
    800050de:	e426                	sd	s1,8(sp)
    800050e0:	e04a                	sd	s2,0(sp)
    800050e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800050e4:	00003597          	auipc	a1,0x3
    800050e8:	5ec58593          	addi	a1,a1,1516 # 800086d0 <etext+0x6d0>
    800050ec:	00018517          	auipc	a0,0x18
    800050f0:	9bc50513          	addi	a0,a0,-1604 # 8001caa8 <disk+0x128>
    800050f4:	002010ef          	jal	800060f6 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800050f8:	100017b7          	lui	a5,0x10001
    800050fc:	4398                	lw	a4,0(a5)
    800050fe:	2701                	sext.w	a4,a4
    80005100:	747277b7          	lui	a5,0x74727
    80005104:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005108:	14f71863          	bne	a4,a5,80005258 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000510c:	100017b7          	lui	a5,0x10001
    80005110:	43dc                	lw	a5,4(a5)
    80005112:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005114:	4709                	li	a4,2
    80005116:	14e79163          	bne	a5,a4,80005258 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000511a:	100017b7          	lui	a5,0x10001
    8000511e:	479c                	lw	a5,8(a5)
    80005120:	2781                	sext.w	a5,a5
    80005122:	12e79b63          	bne	a5,a4,80005258 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005126:	100017b7          	lui	a5,0x10001
    8000512a:	47d8                	lw	a4,12(a5)
    8000512c:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000512e:	554d47b7          	lui	a5,0x554d4
    80005132:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005136:	12f71163          	bne	a4,a5,80005258 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000513a:	100017b7          	lui	a5,0x10001
    8000513e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005142:	4705                	li	a4,1
    80005144:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005146:	470d                	li	a4,3
    80005148:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000514a:	10001737          	lui	a4,0x10001
    8000514e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005150:	c7ffe6b7          	lui	a3,0xc7ffe
    80005154:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fd99af>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005158:	8f75                	and	a4,a4,a3
    8000515a:	100016b7          	lui	a3,0x10001
    8000515e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005160:	472d                	li	a4,11
    80005162:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005164:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005168:	439c                	lw	a5,0(a5)
    8000516a:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000516e:	8ba1                	andi	a5,a5,8
    80005170:	0e078a63          	beqz	a5,80005264 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005174:	100017b7          	lui	a5,0x10001
    80005178:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000517c:	43fc                	lw	a5,68(a5)
    8000517e:	2781                	sext.w	a5,a5
    80005180:	0e079863          	bnez	a5,80005270 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005184:	100017b7          	lui	a5,0x10001
    80005188:	5bdc                	lw	a5,52(a5)
    8000518a:	2781                	sext.w	a5,a5
  if (max == 0)
    8000518c:	0e078863          	beqz	a5,8000527c <virtio_disk_init+0x1a4>
  if (max < NUM)
    80005190:	471d                	li	a4,7
    80005192:	0ef77b63          	bgeu	a4,a5,80005288 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005196:	f6ffa0ef          	jal	80000104 <kalloc>
    8000519a:	00017497          	auipc	s1,0x17
    8000519e:	7e648493          	addi	s1,s1,2022 # 8001c980 <disk>
    800051a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800051a4:	f61fa0ef          	jal	80000104 <kalloc>
    800051a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800051aa:	f5bfa0ef          	jal	80000104 <kalloc>
    800051ae:	87aa                	mv	a5,a0
    800051b0:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    800051b2:	6088                	ld	a0,0(s1)
    800051b4:	0e050063          	beqz	a0,80005294 <virtio_disk_init+0x1bc>
    800051b8:	00017717          	auipc	a4,0x17
    800051bc:	7d073703          	ld	a4,2000(a4) # 8001c988 <disk+0x8>
    800051c0:	cb71                	beqz	a4,80005294 <virtio_disk_init+0x1bc>
    800051c2:	cbe9                	beqz	a5,80005294 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800051c4:	6605                	lui	a2,0x1
    800051c6:	4581                	li	a1,0
    800051c8:	f97fa0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    800051cc:	00017497          	auipc	s1,0x17
    800051d0:	7b448493          	addi	s1,s1,1972 # 8001c980 <disk>
    800051d4:	6605                	lui	a2,0x1
    800051d6:	4581                	li	a1,0
    800051d8:	6488                	ld	a0,8(s1)
    800051da:	f85fa0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    800051de:	6605                	lui	a2,0x1
    800051e0:	4581                	li	a1,0
    800051e2:	6888                	ld	a0,16(s1)
    800051e4:	f7bfa0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800051e8:	100017b7          	lui	a5,0x10001
    800051ec:	4721                	li	a4,8
    800051ee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800051f0:	4098                	lw	a4,0(s1)
    800051f2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800051f6:	40d8                	lw	a4,4(s1)
    800051f8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800051fc:	649c                	ld	a5,8(s1)
    800051fe:	0007869b          	sext.w	a3,a5
    80005202:	10001737          	lui	a4,0x10001
    80005206:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000520a:	9781                	srai	a5,a5,0x20
    8000520c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005210:	689c                	ld	a5,16(s1)
    80005212:	0007869b          	sext.w	a3,a5
    80005216:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000521a:	9781                	srai	a5,a5,0x20
    8000521c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005220:	4785                	li	a5,1
    80005222:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005224:	00f48c23          	sb	a5,24(s1)
    80005228:	00f48ca3          	sb	a5,25(s1)
    8000522c:	00f48d23          	sb	a5,26(s1)
    80005230:	00f48da3          	sb	a5,27(s1)
    80005234:	00f48e23          	sb	a5,28(s1)
    80005238:	00f48ea3          	sb	a5,29(s1)
    8000523c:	00f48f23          	sb	a5,30(s1)
    80005240:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005244:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005248:	07272823          	sw	s2,112(a4)
}
    8000524c:	60e2                	ld	ra,24(sp)
    8000524e:	6442                	ld	s0,16(sp)
    80005250:	64a2                	ld	s1,8(sp)
    80005252:	6902                	ld	s2,0(sp)
    80005254:	6105                	addi	sp,sp,32
    80005256:	8082                	ret
    panic("could not find virtio disk");
    80005258:	00003517          	auipc	a0,0x3
    8000525c:	48850513          	addi	a0,a0,1160 # 800086e0 <etext+0x6e0>
    80005260:	4a5000ef          	jal	80005f04 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005264:	00003517          	auipc	a0,0x3
    80005268:	49c50513          	addi	a0,a0,1180 # 80008700 <etext+0x700>
    8000526c:	499000ef          	jal	80005f04 <panic>
    panic("virtio disk should not be ready");
    80005270:	00003517          	auipc	a0,0x3
    80005274:	4b050513          	addi	a0,a0,1200 # 80008720 <etext+0x720>
    80005278:	48d000ef          	jal	80005f04 <panic>
    panic("virtio disk has no queue 0");
    8000527c:	00003517          	auipc	a0,0x3
    80005280:	4c450513          	addi	a0,a0,1220 # 80008740 <etext+0x740>
    80005284:	481000ef          	jal	80005f04 <panic>
    panic("virtio disk max queue too short");
    80005288:	00003517          	auipc	a0,0x3
    8000528c:	4d850513          	addi	a0,a0,1240 # 80008760 <etext+0x760>
    80005290:	475000ef          	jal	80005f04 <panic>
    panic("virtio disk kalloc");
    80005294:	00003517          	auipc	a0,0x3
    80005298:	4ec50513          	addi	a0,a0,1260 # 80008780 <etext+0x780>
    8000529c:	469000ef          	jal	80005f04 <panic>

00000000800052a0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800052a0:	711d                	addi	sp,sp,-96
    800052a2:	ec86                	sd	ra,88(sp)
    800052a4:	e8a2                	sd	s0,80(sp)
    800052a6:	e4a6                	sd	s1,72(sp)
    800052a8:	e0ca                	sd	s2,64(sp)
    800052aa:	fc4e                	sd	s3,56(sp)
    800052ac:	f852                	sd	s4,48(sp)
    800052ae:	f456                	sd	s5,40(sp)
    800052b0:	f05a                	sd	s6,32(sp)
    800052b2:	ec5e                	sd	s7,24(sp)
    800052b4:	e862                	sd	s8,16(sp)
    800052b6:	1080                	addi	s0,sp,96
    800052b8:	89aa                	mv	s3,a0
    800052ba:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800052bc:	00c52b83          	lw	s7,12(a0)
    800052c0:	001b9b9b          	slliw	s7,s7,0x1
    800052c4:	1b82                	slli	s7,s7,0x20
    800052c6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800052ca:	00017517          	auipc	a0,0x17
    800052ce:	7de50513          	addi	a0,a0,2014 # 8001caa8 <disk+0x128>
    800052d2:	6a5000ef          	jal	80006176 <acquire>
  for (int i = 0; i < NUM; i++) {
    800052d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800052d8:	00017a97          	auipc	s5,0x17
    800052dc:	6a8a8a93          	addi	s5,s5,1704 # 8001c980 <disk>
  for (int i = 0; i < 3; i++) {
    800052e0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800052e2:	5c7d                	li	s8,-1
    800052e4:	a8a5                	j	8000535c <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800052e6:	00fa8733          	add	a4,s5,a5
    800052ea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800052ee:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800052f0:	0207c563          	bltz	a5,8000531a <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    800052f4:	2905                	addiw	s2,s2,1
    800052f6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800052f8:	07490663          	beq	s2,s4,80005364 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800052fc:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    800052fe:	00017717          	auipc	a4,0x17
    80005302:	68270713          	addi	a4,a4,1666 # 8001c980 <disk>
    80005306:	4781                	li	a5,0
    if (disk.free[i]) {
    80005308:	01874683          	lbu	a3,24(a4)
    8000530c:	fee9                	bnez	a3,800052e6 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    8000530e:	2785                	addiw	a5,a5,1
    80005310:	0705                	addi	a4,a4,1
    80005312:	fe979be3          	bne	a5,s1,80005308 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005316:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    8000531a:	01205d63          	blez	s2,80005334 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000531e:	fa042503          	lw	a0,-96(s0)
    80005322:	d41ff0ef          	jal	80005062 <free_desc>
      for (int j = 0; j < i; j++)
    80005326:	4785                	li	a5,1
    80005328:	0127d663          	bge	a5,s2,80005334 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000532c:	fa442503          	lw	a0,-92(s0)
    80005330:	d33ff0ef          	jal	80005062 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80005334:	00017517          	auipc	a0,0x17
    80005338:	66450513          	addi	a0,a0,1636 # 8001c998 <disk+0x18>
    8000533c:	c2afc0ef          	jal	80001766 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005340:	00017517          	auipc	a0,0x17
    80005344:	76850513          	addi	a0,a0,1896 # 8001caa8 <disk+0x128>
    80005348:	6b7000ef          	jal	800061fe <release>
    sleep();
    8000534c:	c56fc0ef          	jal	800017a2 <sleep>
    acquire(&disk.vdisk_lock);
    80005350:	00017517          	auipc	a0,0x17
    80005354:	75850513          	addi	a0,a0,1880 # 8001caa8 <disk+0x128>
    80005358:	61f000ef          	jal	80006176 <acquire>
  for (int i = 0; i < 3; i++) {
    8000535c:	fa040613          	addi	a2,s0,-96
    80005360:	4901                	li	s2,0
    80005362:	bf69                	j	800052fc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005364:	fa042503          	lw	a0,-96(s0)
    80005368:	00451693          	slli	a3,a0,0x4

  if (write)
    8000536c:	00017797          	auipc	a5,0x17
    80005370:	61478793          	addi	a5,a5,1556 # 8001c980 <disk>
    80005374:	00451713          	slli	a4,a0,0x4
    80005378:	0a070713          	addi	a4,a4,160
    8000537c:	973e                	add	a4,a4,a5
    8000537e:	01603633          	snez	a2,s6
    80005382:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005384:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005388:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    8000538c:	6398                	ld	a4,0(a5)
    8000538e:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005390:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005394:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005396:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005398:	6390                	ld	a2,0(a5)
    8000539a:	00d60833          	add	a6,a2,a3
    8000539e:	4741                	li	a4,16
    800053a0:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800053a4:	4585                	li	a1,1
    800053a6:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    800053aa:	fa442703          	lw	a4,-92(s0)
    800053ae:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800053b2:	0712                	slli	a4,a4,0x4
    800053b4:	963a                	add	a2,a2,a4
    800053b6:	05898813          	addi	a6,s3,88
    800053ba:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800053be:	0007b883          	ld	a7,0(a5)
    800053c2:	9746                	add	a4,a4,a7
    800053c4:	40000613          	li	a2,1024
    800053c8:	c710                	sw	a2,8(a4)
  if (write)
    800053ca:	001b3613          	seqz	a2,s6
    800053ce:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800053d2:	8e4d                	or	a2,a2,a1
    800053d4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800053d8:	fa842603          	lw	a2,-88(s0)
    800053dc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800053e0:	00451813          	slli	a6,a0,0x4
    800053e4:	02080813          	addi	a6,a6,32
    800053e8:	983e                	add	a6,a6,a5
    800053ea:	577d                	li	a4,-1
    800053ec:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800053f0:	0612                	slli	a2,a2,0x4
    800053f2:	98b2                	add	a7,a7,a2
    800053f4:	03068713          	addi	a4,a3,48
    800053f8:	973e                	add	a4,a4,a5
    800053fa:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800053fe:	6398                	ld	a4,0(a5)
    80005400:	9732                	add	a4,a4,a2
    80005402:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005404:	4689                	li	a3,2
    80005406:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000540a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000540e:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005412:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005416:	6794                	ld	a3,8(a5)
    80005418:	0026d703          	lhu	a4,2(a3)
    8000541c:	8b1d                	andi	a4,a4,7
    8000541e:	0706                	slli	a4,a4,0x1
    80005420:	96ba                	add	a3,a3,a4
    80005422:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005426:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000542a:	6798                	ld	a4,8(a5)
    8000542c:	00275783          	lhu	a5,2(a4)
    80005430:	2785                	addiw	a5,a5,1
    80005432:	00f71123          	sh	a5,2(a4)
    80005436:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000543a:	100017b7          	lui	a5,0x10001
    8000543e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005442:	0049a783          	lw	a5,4(s3)
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005446:	00017497          	auipc	s1,0x17
    8000544a:	66248493          	addi	s1,s1,1634 # 8001caa8 <disk+0x128>
  while (b->disk == 1) {
    8000544e:	892e                	mv	s2,a1
    80005450:	02b79163          	bne	a5,a1,80005472 <virtio_disk_rw+0x1d2>
    sleep_prepare(b);
    80005454:	854e                	mv	a0,s3
    80005456:	b10fc0ef          	jal	80001766 <sleep_prepare>
    release(&disk.vdisk_lock);
    8000545a:	8526                	mv	a0,s1
    8000545c:	5a3000ef          	jal	800061fe <release>
    sleep();
    80005460:	b42fc0ef          	jal	800017a2 <sleep>
    acquire(&disk.vdisk_lock);
    80005464:	8526                	mv	a0,s1
    80005466:	511000ef          	jal	80006176 <acquire>
  while (b->disk == 1) {
    8000546a:	0049a783          	lw	a5,4(s3)
    8000546e:	ff2783e3          	beq	a5,s2,80005454 <virtio_disk_rw+0x1b4>
  }

  disk.info[idx[0]].b = 0;
    80005472:	fa042903          	lw	s2,-96(s0)
    80005476:	00491713          	slli	a4,s2,0x4
    8000547a:	02070713          	addi	a4,a4,32
    8000547e:	00017797          	auipc	a5,0x17
    80005482:	50278793          	addi	a5,a5,1282 # 8001c980 <disk>
    80005486:	97ba                	add	a5,a5,a4
    80005488:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000548c:	00017997          	auipc	s3,0x17
    80005490:	4f498993          	addi	s3,s3,1268 # 8001c980 <disk>
    80005494:	00491713          	slli	a4,s2,0x4
    80005498:	0009b783          	ld	a5,0(s3)
    8000549c:	97ba                	add	a5,a5,a4
    8000549e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800054a2:	854a                	mv	a0,s2
    800054a4:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800054a8:	bbbff0ef          	jal	80005062 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800054ac:	8885                	andi	s1,s1,1
    800054ae:	f0fd                	bnez	s1,80005494 <virtio_disk_rw+0x1f4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800054b0:	00017517          	auipc	a0,0x17
    800054b4:	5f850513          	addi	a0,a0,1528 # 8001caa8 <disk+0x128>
    800054b8:	547000ef          	jal	800061fe <release>
}
    800054bc:	60e6                	ld	ra,88(sp)
    800054be:	6446                	ld	s0,80(sp)
    800054c0:	64a6                	ld	s1,72(sp)
    800054c2:	6906                	ld	s2,64(sp)
    800054c4:	79e2                	ld	s3,56(sp)
    800054c6:	7a42                	ld	s4,48(sp)
    800054c8:	7aa2                	ld	s5,40(sp)
    800054ca:	7b02                	ld	s6,32(sp)
    800054cc:	6be2                	ld	s7,24(sp)
    800054ce:	6c42                	ld	s8,16(sp)
    800054d0:	6125                	addi	sp,sp,96
    800054d2:	8082                	ret

00000000800054d4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800054d4:	1101                	addi	sp,sp,-32
    800054d6:	ec06                	sd	ra,24(sp)
    800054d8:	e822                	sd	s0,16(sp)
    800054da:	e426                	sd	s1,8(sp)
    800054dc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800054de:	00017497          	auipc	s1,0x17
    800054e2:	4a248493          	addi	s1,s1,1186 # 8001c980 <disk>
    800054e6:	00017517          	auipc	a0,0x17
    800054ea:	5c250513          	addi	a0,a0,1474 # 8001caa8 <disk+0x128>
    800054ee:	489000ef          	jal	80006176 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800054f2:	100017b7          	lui	a5,0x10001
    800054f6:	53bc                	lw	a5,96(a5)
    800054f8:	8b8d                	andi	a5,a5,3
    800054fa:	10001737          	lui	a4,0x10001
    800054fe:	d37c                	sw	a5,100(a4)
    80005500:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005504:	689c                	ld	a5,16(s1)
    80005506:	0204d703          	lhu	a4,32(s1)
    8000550a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000550e:	04f70863          	beq	a4,a5,8000555e <virtio_disk_intr+0x8a>
    80005512:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005516:	6898                	ld	a4,16(s1)
    80005518:	0204d783          	lhu	a5,32(s1)
    8000551c:	8b9d                	andi	a5,a5,7
    8000551e:	078e                	slli	a5,a5,0x3
    80005520:	97ba                	add	a5,a5,a4
    80005522:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005524:	00479713          	slli	a4,a5,0x4
    80005528:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000552c:	9726                	add	a4,a4,s1
    8000552e:	01074703          	lbu	a4,16(a4)
    80005532:	e329                	bnez	a4,80005574 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005534:	0792                	slli	a5,a5,0x4
    80005536:	02078793          	addi	a5,a5,32
    8000553a:	97a6                	add	a5,a5,s1
    8000553c:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    8000553e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005542:	a90fc0ef          	jal	800017d2 <wakeup>

    disk.used_idx += 1;
    80005546:	0204d783          	lhu	a5,32(s1)
    8000554a:	2785                	addiw	a5,a5,1
    8000554c:	17c2                	slli	a5,a5,0x30
    8000554e:	93c1                	srli	a5,a5,0x30
    80005550:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005554:	6898                	ld	a4,16(s1)
    80005556:	00275703          	lhu	a4,2(a4)
    8000555a:	faf71ce3          	bne	a4,a5,80005512 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000555e:	00017517          	auipc	a0,0x17
    80005562:	54a50513          	addi	a0,a0,1354 # 8001caa8 <disk+0x128>
    80005566:	499000ef          	jal	800061fe <release>
}
    8000556a:	60e2                	ld	ra,24(sp)
    8000556c:	6442                	ld	s0,16(sp)
    8000556e:	64a2                	ld	s1,8(sp)
    80005570:	6105                	addi	sp,sp,32
    80005572:	8082                	ret
      panic("virtio_disk_intr status");
    80005574:	00003517          	auipc	a0,0x3
    80005578:	22450513          	addi	a0,a0,548 # 80008798 <etext+0x798>
    8000557c:	189000ef          	jal	80005f04 <panic>

0000000080005580 <pgpte>:

extern pagetable_t kernel_pagetable;

pte_t *
pgpte(pagetable_t pagetable, uint64 va)
{
    80005580:	1141                	addi	sp,sp,-16
    80005582:	e406                	sd	ra,8(sp)
    80005584:	e022                	sd	s0,0(sp)
    80005586:	0800                	addi	s0,sp,16
  return walk(pagetable, va, 0);
    80005588:	4601                	li	a2,0
    8000558a:	e6bfa0ef          	jal	800003f4 <walk>
}
    8000558e:	60a2                	ld	ra,8(sp)
    80005590:	6402                	ld	s0,0(sp)
    80005592:	0141                	addi	sp,sp,16
    80005594:	8082                	ret

0000000080005596 <sys_pgpte>:

int
sys_pgpte(void)
{
    80005596:	7179                	addi	sp,sp,-48
    80005598:	f406                	sd	ra,40(sp)
    8000559a:	f022                	sd	s0,32(sp)
    8000559c:	ec26                	sd	s1,24(sp)
    8000559e:	1800                	addi	s0,sp,48
  uint64 va;
  struct proc *p;

  p = myproc();
    800055a0:	b1ffb0ef          	jal	800010be <myproc>
    800055a4:	84aa                	mv	s1,a0
  argaddr(0, &va);
    800055a6:	fd840593          	addi	a1,s0,-40
    800055aa:	4501                	li	a0,0
    800055ac:	b0ffc0ef          	jal	800020ba <argaddr>
  pte_t *pte = pgpte(p->pagetable, va);
    800055b0:	fd843583          	ld	a1,-40(s0)
    800055b4:	68a8                	ld	a0,80(s1)
    800055b6:	fcbff0ef          	jal	80005580 <pgpte>
    800055ba:	87aa                	mv	a5,a0
  if (pte != 0) {
    return (uint64)*pte;
  }
  return 0;
    800055bc:	4501                	li	a0,0
  if (pte != 0) {
    800055be:	c391                	beqz	a5,800055c2 <sys_pgpte+0x2c>
    return (uint64)*pte;
    800055c0:	4388                	lw	a0,0(a5)
}
    800055c2:	70a2                	ld	ra,40(sp)
    800055c4:	7402                	ld	s0,32(sp)
    800055c6:	64e2                	ld	s1,24(sp)
    800055c8:	6145                	addi	sp,sp,48
    800055ca:	8082                	ret

00000000800055cc <cnt_level>:


void
cnt_level(pagetable_t pagetable, uint64 *nsuper, uint64 *n2, uint64 va_start, int level)
{
    800055cc:	715d                	addi	sp,sp,-80
    800055ce:	e486                	sd	ra,72(sp)
    800055d0:	e0a2                	sd	s0,64(sp)
    800055d2:	fc26                	sd	s1,56(sp)
    800055d4:	f84a                	sd	s2,48(sp)
    800055d6:	f44e                	sd	s3,40(sp)
    800055d8:	f052                	sd	s4,32(sp)
    800055da:	ec56                	sd	s5,24(sp)
    800055dc:	e85a                	sd	s6,16(sp)
    800055de:	e45e                	sd	s7,8(sp)
    800055e0:	e062                	sd	s8,0(sp)
    800055e2:	0880                	addi	s0,sp,80
    800055e4:	84aa                	mv	s1,a0
    800055e6:	8b2e                	mv	s6,a1
    800055e8:	8ab2                	mv	s5,a2
    800055ea:	8bb6                	mv	s7,a3
    800055ec:	89ba                	mv	s3,a4
  uint64 va;
  int n = (level == 3) ? 1 : 512;
    800055ee:	478d                	li	a5,3
    800055f0:	20000a13          	li	s4,512
    800055f4:	00f70a63          	beq	a4,a5,80005608 <cnt_level+0x3c>

  for (int i = 0; i < n; i++) {
    pte_t pte = pagetable[i];
    if (pte & PTE_V) {
      va = (((uint64)i) << PXSHIFT(level)) + va_start;
    800055f8:	0039979b          	slliw	a5,s3,0x3
    800055fc:	013787bb          	addw	a5,a5,s3
    80005600:	27b1                	addiw	a5,a5,12
    80005602:	8c3e                	mv	s8,a5
    80005604:	4901                	li	s2,0
    80005606:	a805                	j	80005636 <cnt_level+0x6a>
  int n = (level == 3) ? 1 : 512;
    80005608:	4a05                	li	s4,1
    8000560a:	b7fd                	j	800055f8 <cnt_level+0x2c>
      va = (((uint64)i) << PXSHIFT(level)) + va_start;
    8000560c:	018916b3          	sll	a3,s2,s8
      uint64 child = PTE2PA(pte);
    80005610:	8129                	srli	a0,a0,0xa
      if (level > 0) {
        if (!PTE_LEAF(pte)) {
          cnt_level((pagetable_t)child, nsuper, n2, va, level-1);
    80005612:	fff9871b          	addiw	a4,s3,-1
    80005616:	96de                	add	a3,a3,s7
    80005618:	8656                	mv	a2,s5
    8000561a:	85da                	mv	a1,s6
    8000561c:	0532                	slli	a0,a0,0xc
    8000561e:	fafff0ef          	jal	800055cc <cnt_level>
    80005622:	a031                	j	8000562e <cnt_level+0x62>
        } else {
          *nsuper += 1;
        }
      } else {
        *n2 += 1;
    80005624:	000ab783          	ld	a5,0(s5)
    80005628:	0785                	addi	a5,a5,1
    8000562a:	00fab023          	sd	a5,0(s5)
  for (int i = 0; i < n; i++) {
    8000562e:	0905                	addi	s2,s2,1
    80005630:	04a1                	addi	s1,s1,8
    80005632:	03490163          	beq	s2,s4,80005654 <cnt_level+0x88>
    pte_t pte = pagetable[i];
    80005636:	6088                	ld	a0,0(s1)
    if (pte & PTE_V) {
    80005638:	00157793          	andi	a5,a0,1
    8000563c:	dbed                	beqz	a5,8000562e <cnt_level+0x62>
      if (level > 0) {
    8000563e:	ff3053e3          	blez	s3,80005624 <cnt_level+0x58>
        if (!PTE_LEAF(pte)) {
    80005642:	00e57793          	andi	a5,a0,14
    80005646:	d3f9                	beqz	a5,8000560c <cnt_level+0x40>
          *nsuper += 1;
    80005648:	000b3783          	ld	a5,0(s6) # 1000 <_entry-0x7ffff000>
    8000564c:	0785                	addi	a5,a5,1
    8000564e:	00fb3023          	sd	a5,0(s6)
    80005652:	bff1                	j	8000562e <cnt_level+0x62>
      }
    }
  }
}
    80005654:	60a6                	ld	ra,72(sp)
    80005656:	6406                	ld	s0,64(sp)
    80005658:	74e2                	ld	s1,56(sp)
    8000565a:	7942                	ld	s2,48(sp)
    8000565c:	79a2                	ld	s3,40(sp)
    8000565e:	7a02                	ld	s4,32(sp)
    80005660:	6ae2                	ld	s5,24(sp)
    80005662:	6b42                	ld	s6,16(sp)
    80005664:	6ba2                	ld	s7,8(sp)
    80005666:	6c02                	ld	s8,0(sp)
    80005668:	6161                	addi	sp,sp,80
    8000566a:	8082                	ret

000000008000566c <sys_ksupernpte>:

uint64
sys_ksupernpte() {
    8000566c:	7139                	addi	sp,sp,-64
    8000566e:	fc06                	sd	ra,56(sp)
    80005670:	f822                	sd	s0,48(sp)
    80005672:	f426                	sd	s1,40(sp)
    80005674:	f04a                	sd	s2,32(sp)
    80005676:	0080                	addi	s0,sp,64
  struct proc *p;
  uint64 as, an;
  uint64 s = 0, n = 0;
    80005678:	fc043423          	sd	zero,-56(s0)
    8000567c:	fc043023          	sd	zero,-64(s0)

  cnt_level(kernel_pagetable, &s, &n, 0, 2);
    80005680:	fc840913          	addi	s2,s0,-56
    80005684:	4709                	li	a4,2
    80005686:	4681                	li	a3,0
    80005688:	fc040613          	addi	a2,s0,-64
    8000568c:	85ca                	mv	a1,s2
    8000568e:	00006517          	auipc	a0,0x6
    80005692:	fda53503          	ld	a0,-38(a0) # 8000b668 <kernel_pagetable>
    80005696:	f37ff0ef          	jal	800055cc <cnt_level>

  p = myproc();
    8000569a:	a25fb0ef          	jal	800010be <myproc>
    8000569e:	84aa                	mv	s1,a0
  argaddr(0, &as);
    800056a0:	fd840593          	addi	a1,s0,-40
    800056a4:	4501                	li	a0,0
    800056a6:	a15fc0ef          	jal	800020ba <argaddr>
  argaddr(1, &an);
    800056aa:	fd040593          	addi	a1,s0,-48
    800056ae:	4505                	li	a0,1
    800056b0:	a0bfc0ef          	jal	800020ba <argaddr>

  if (copyout(p->pagetable, p->sz, as, (char *)&s, sizeof(uint64)) < 0) {
    800056b4:	4721                	li	a4,8
    800056b6:	86ca                	mv	a3,s2
    800056b8:	fd843603          	ld	a2,-40(s0)
    800056bc:	64ac                	ld	a1,72(s1)
    800056be:	68a8                	ld	a0,80(s1)
    800056c0:	e36fb0ef          	jal	80000cf6 <copyout>
    800056c4:	87aa                	mv	a5,a0
    return -1;
    800056c6:	557d                	li	a0,-1
  if (copyout(p->pagetable, p->sz, as, (char *)&s, sizeof(uint64)) < 0) {
    800056c8:	0007cc63          	bltz	a5,800056e0 <sys_ksupernpte+0x74>
  }
  if (copyout(p->pagetable, p->sz, an, (char *)&n, sizeof(uint64)) < 0) {
    800056cc:	4721                	li	a4,8
    800056ce:	fc040693          	addi	a3,s0,-64
    800056d2:	fd043603          	ld	a2,-48(s0)
    800056d6:	64ac                	ld	a1,72(s1)
    800056d8:	68a8                	ld	a0,80(s1)
    800056da:	e1cfb0ef          	jal	80000cf6 <copyout>
    800056de:	957d                	srai	a0,a0,0x3f
    return -1;
  }

  return 0;
}
    800056e0:	70e2                	ld	ra,56(sp)
    800056e2:	7442                	ld	s0,48(sp)
    800056e4:	74a2                	ld	s1,40(sp)
    800056e6:	7902                	ld	s2,32(sp)
    800056e8:	6121                	addi	sp,sp,64
    800056ea:	8082                	ret

00000000800056ec <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800056ec:	1141                	addi	sp,sp,-16
    800056ee:	e406                	sd	ra,8(sp)
    800056f0:	e022                	sd	s0,0(sp)
    800056f2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800056f4:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    800056f8:	577d                	li	a4,-1
    800056fa:	177e                	slli	a4,a4,0x3f
    800056fc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800056fe:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80005702:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005706:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000570a:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r"(x));
    8000570e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005712:	000f4737          	lui	a4,0xf4
    80005716:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000571a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000571c:	14d79073          	csrw	stimecmp,a5
}
    80005720:	60a2                	ld	ra,8(sp)
    80005722:	6402                	ld	s0,0(sp)
    80005724:	0141                	addi	sp,sp,16
    80005726:	8082                	ret

0000000080005728 <start>:
{
    80005728:	1141                	addi	sp,sp,-16
    8000572a:	e406                	sd	ra,8(sp)
    8000572c:	e022                	sd	s0,0(sp)
    8000572e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005730:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005734:	7779                	lui	a4,0xffffe
    80005736:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9c4f>
    8000573a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000573c:	6705                	lui	a4,0x1
    8000573e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005742:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005744:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005748:	ffffb797          	auipc	a5,0xffffb
    8000574c:	bcc78793          	addi	a5,a5,-1076 # 80000314 <main>
    80005750:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005754:	4781                	li	a5,0
    80005756:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000575a:	67c1                	lui	a5,0x10
    8000575c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000575e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005762:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005766:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000576a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000576e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005772:	57fd                	li	a5,-1
    80005774:	83a9                	srli	a5,a5,0xa
    80005776:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    8000577a:	47bd                	li	a5,15
    8000577c:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80005780:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    80005784:	4705                	li	a4,1
    80005786:	1776                	slli	a4,a4,0x3d
    80005788:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000578a:	30a79073          	csrw	0x30a,a5
  timerinit();
    8000578e:	f5fff0ef          	jal	800056ec <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005792:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005796:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r"(x));
    80005798:	823e                	mv	tp,a5
  asm volatile("mret");
    8000579a:	30200073          	mret
}
    8000579e:	60a2                	ld	ra,8(sp)
    800057a0:	6402                	ld	s0,0(sp)
    800057a2:	0141                	addi	sp,sp,16
    800057a4:	8082                	ret

00000000800057a6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057a6:	7119                	addi	sp,sp,-128
    800057a8:	fc86                	sd	ra,120(sp)
    800057aa:	f8a2                	sd	s0,112(sp)
    800057ac:	f4a6                	sd	s1,104(sp)
    800057ae:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800057b0:	06c05b63          	blez	a2,80005826 <consolewrite+0x80>
    800057b4:	f0ca                	sd	s2,96(sp)
    800057b6:	ecce                	sd	s3,88(sp)
    800057b8:	e8d2                	sd	s4,80(sp)
    800057ba:	e4d6                	sd	s5,72(sp)
    800057bc:	e0da                	sd	s6,64(sp)
    800057be:	fc5e                	sd	s7,56(sp)
    800057c0:	f862                	sd	s8,48(sp)
    800057c2:	f466                	sd	s9,40(sp)
    800057c4:	f06a                	sd	s10,32(sp)
    800057c6:	8b2a                	mv	s6,a0
    800057c8:	8bae                	mv	s7,a1
    800057ca:	8a32                	mv	s4,a2
  int i = 0;
    800057cc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800057ce:	02000c93          	li	s9,32
    800057d2:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    800057d6:	f8040a93          	addi	s5,s0,-128
    800057da:	5c7d                	li	s8,-1
    800057dc:	a025                	j	80005804 <consolewrite+0x5e>
    if (nn > n - i)
    800057de:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    800057e2:	86ce                	mv	a3,s3
    800057e4:	01748633          	add	a2,s1,s7
    800057e8:	85da                	mv	a1,s6
    800057ea:	8556                	mv	a0,s5
    800057ec:	b52fc0ef          	jal	80001b3e <either_copyin>
    800057f0:	03850d63          	beq	a0,s8,8000582a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    800057f4:	85ce                	mv	a1,s3
    800057f6:	8556                	mv	a0,s5
    800057f8:	7c2000ef          	jal	80005fba <uartwrite>
    i += nn;
    800057fc:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80005800:	0144d963          	bge	s1,s4,80005812 <consolewrite+0x6c>
    if (nn > n - i)
    80005804:	409a07bb          	subw	a5,s4,s1
    80005808:	893e                	mv	s2,a5
    8000580a:	fcfcdae3          	bge	s9,a5,800057de <consolewrite+0x38>
    8000580e:	896a                	mv	s2,s10
    80005810:	b7f9                	j	800057de <consolewrite+0x38>
    80005812:	7906                	ld	s2,96(sp)
    80005814:	69e6                	ld	s3,88(sp)
    80005816:	6a46                	ld	s4,80(sp)
    80005818:	6aa6                	ld	s5,72(sp)
    8000581a:	6b06                	ld	s6,64(sp)
    8000581c:	7be2                	ld	s7,56(sp)
    8000581e:	7c42                	ld	s8,48(sp)
    80005820:	7ca2                	ld	s9,40(sp)
    80005822:	7d02                	ld	s10,32(sp)
    80005824:	a821                	j	8000583c <consolewrite+0x96>
  int i = 0;
    80005826:	4481                	li	s1,0
    80005828:	a811                	j	8000583c <consolewrite+0x96>
    8000582a:	7906                	ld	s2,96(sp)
    8000582c:	69e6                	ld	s3,88(sp)
    8000582e:	6a46                	ld	s4,80(sp)
    80005830:	6aa6                	ld	s5,72(sp)
    80005832:	6b06                	ld	s6,64(sp)
    80005834:	7be2                	ld	s7,56(sp)
    80005836:	7c42                	ld	s8,48(sp)
    80005838:	7ca2                	ld	s9,40(sp)
    8000583a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000583c:	8526                	mv	a0,s1
    8000583e:	70e6                	ld	ra,120(sp)
    80005840:	7446                	ld	s0,112(sp)
    80005842:	74a6                	ld	s1,104(sp)
    80005844:	6109                	addi	sp,sp,128
    80005846:	8082                	ret

0000000080005848 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005848:	711d                	addi	sp,sp,-96
    8000584a:	ec86                	sd	ra,88(sp)
    8000584c:	e8a2                	sd	s0,80(sp)
    8000584e:	e4a6                	sd	s1,72(sp)
    80005850:	e0ca                	sd	s2,64(sp)
    80005852:	fc4e                	sd	s3,56(sp)
    80005854:	f852                	sd	s4,48(sp)
    80005856:	f05a                	sd	s6,32(sp)
    80005858:	ec5e                	sd	s7,24(sp)
    8000585a:	1080                	addi	s0,sp,96
    8000585c:	8b2a                	mv	s6,a0
    8000585e:	8a2e                	mv	s4,a1
    80005860:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005862:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005864:	0001f517          	auipc	a0,0x1f
    80005868:	25c50513          	addi	a0,a0,604 # 80024ac0 <cons>
    8000586c:	10b000ef          	jal	80006176 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005870:	0001f497          	auipc	s1,0x1f
    80005874:	25048493          	addi	s1,s1,592 # 80024ac0 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    80005878:	0001f917          	auipc	s2,0x1f
    8000587c:	2e090913          	addi	s2,s2,736 # 80024b58 <cons+0x98>
  while (n > 0) {
    80005880:	0d305263          	blez	s3,80005944 <consoleread+0xfc>
    while (cons.r == cons.w) {
    80005884:	0984a783          	lw	a5,152(s1)
    80005888:	09c4a703          	lw	a4,156(s1)
    8000588c:	0af71763          	bne	a4,a5,8000593a <consoleread+0xf2>
      if (killed(myproc())) {
    80005890:	82ffb0ef          	jal	800010be <myproc>
    80005894:	92afc0ef          	jal	800019be <killed>
    80005898:	e925                	bnez	a0,80005908 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    8000589a:	854a                	mv	a0,s2
    8000589c:	ecbfb0ef          	jal	80001766 <sleep_prepare>
      release(&cons.lock);
    800058a0:	8526                	mv	a0,s1
    800058a2:	15d000ef          	jal	800061fe <release>
      sleep();
    800058a6:	efdfb0ef          	jal	800017a2 <sleep>
      acquire(&cons.lock);
    800058aa:	8526                	mv	a0,s1
    800058ac:	0cb000ef          	jal	80006176 <acquire>
    while (cons.r == cons.w) {
    800058b0:	0984a783          	lw	a5,152(s1)
    800058b4:	09c4a703          	lw	a4,156(s1)
    800058b8:	fcf70ce3          	beq	a4,a5,80005890 <consoleread+0x48>
    800058bc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800058be:	0001f717          	auipc	a4,0x1f
    800058c2:	20270713          	addi	a4,a4,514 # 80024ac0 <cons>
    800058c6:	0017869b          	addiw	a3,a5,1
    800058ca:	08d72c23          	sw	a3,152(a4)
    800058ce:	07f7f693          	andi	a3,a5,127
    800058d2:	9736                	add	a4,a4,a3
    800058d4:	01874703          	lbu	a4,24(a4)
    800058d8:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    800058dc:	4691                	li	a3,4
    800058de:	04da8663          	beq	s5,a3,8000592a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800058e2:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058e6:	4685                	li	a3,1
    800058e8:	faf40613          	addi	a2,s0,-81
    800058ec:	85d2                	mv	a1,s4
    800058ee:	855a                	mv	a0,s6
    800058f0:	a02fc0ef          	jal	80001af2 <either_copyout>
    800058f4:	57fd                	li	a5,-1
    800058f6:	04f50663          	beq	a0,a5,80005942 <consoleread+0xfa>
      break;

    dst++;
    800058fa:	0a05                	addi	s4,s4,1
    --n;
    800058fc:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    800058fe:	47a9                	li	a5,10
    80005900:	04fa8b63          	beq	s5,a5,80005956 <consoleread+0x10e>
    80005904:	7aa2                	ld	s5,40(sp)
    80005906:	bfad                	j	80005880 <consoleread+0x38>
        release(&cons.lock);
    80005908:	0001f517          	auipc	a0,0x1f
    8000590c:	1b850513          	addi	a0,a0,440 # 80024ac0 <cons>
    80005910:	0ef000ef          	jal	800061fe <release>
        return -1;
    80005914:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005916:	60e6                	ld	ra,88(sp)
    80005918:	6446                	ld	s0,80(sp)
    8000591a:	64a6                	ld	s1,72(sp)
    8000591c:	6906                	ld	s2,64(sp)
    8000591e:	79e2                	ld	s3,56(sp)
    80005920:	7a42                	ld	s4,48(sp)
    80005922:	7b02                	ld	s6,32(sp)
    80005924:	6be2                	ld	s7,24(sp)
    80005926:	6125                	addi	sp,sp,96
    80005928:	8082                	ret
      if (n < target) {
    8000592a:	0179fa63          	bgeu	s3,s7,8000593e <consoleread+0xf6>
        cons.r--;
    8000592e:	0001f717          	auipc	a4,0x1f
    80005932:	22f72523          	sw	a5,554(a4) # 80024b58 <cons+0x98>
    80005936:	7aa2                	ld	s5,40(sp)
    80005938:	a031                	j	80005944 <consoleread+0xfc>
    8000593a:	f456                	sd	s5,40(sp)
    8000593c:	b749                	j	800058be <consoleread+0x76>
    8000593e:	7aa2                	ld	s5,40(sp)
    80005940:	a011                	j	80005944 <consoleread+0xfc>
    80005942:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005944:	0001f517          	auipc	a0,0x1f
    80005948:	17c50513          	addi	a0,a0,380 # 80024ac0 <cons>
    8000594c:	0b3000ef          	jal	800061fe <release>
  return target - n;
    80005950:	413b853b          	subw	a0,s7,s3
    80005954:	b7c9                	j	80005916 <consoleread+0xce>
    80005956:	7aa2                	ld	s5,40(sp)
    80005958:	b7f5                	j	80005944 <consoleread+0xfc>

000000008000595a <consputc>:
{
    8000595a:	1141                	addi	sp,sp,-16
    8000595c:	e406                	sd	ra,8(sp)
    8000595e:	e022                	sd	s0,0(sp)
    80005960:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005962:	10000793          	li	a5,256
    80005966:	00f50863          	beq	a0,a5,80005976 <consputc+0x1c>
    uartputc_sync(c);
    8000596a:	6d6000ef          	jal	80006040 <uartputc_sync>
}
    8000596e:	60a2                	ld	ra,8(sp)
    80005970:	6402                	ld	s0,0(sp)
    80005972:	0141                	addi	sp,sp,16
    80005974:	8082                	ret
    uartputc_sync('\b');
    80005976:	4521                	li	a0,8
    80005978:	6c8000ef          	jal	80006040 <uartputc_sync>
    uartputc_sync(' ');
    8000597c:	02000513          	li	a0,32
    80005980:	6c0000ef          	jal	80006040 <uartputc_sync>
    uartputc_sync('\b');
    80005984:	4521                	li	a0,8
    80005986:	6ba000ef          	jal	80006040 <uartputc_sync>
    8000598a:	b7d5                	j	8000596e <consputc+0x14>

000000008000598c <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000598c:	1101                	addi	sp,sp,-32
    8000598e:	ec06                	sd	ra,24(sp)
    80005990:	e822                	sd	s0,16(sp)
    80005992:	e426                	sd	s1,8(sp)
    80005994:	1000                	addi	s0,sp,32
    80005996:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005998:	0001f517          	auipc	a0,0x1f
    8000599c:	12850513          	addi	a0,a0,296 # 80024ac0 <cons>
    800059a0:	7d6000ef          	jal	80006176 <acquire>

  switch (c) {
    800059a4:	47d5                	li	a5,21
    800059a6:	08f48d63          	beq	s1,a5,80005a40 <consoleintr+0xb4>
    800059aa:	0297c563          	blt	a5,s1,800059d4 <consoleintr+0x48>
    800059ae:	47a1                	li	a5,8
    800059b0:	0ef48263          	beq	s1,a5,80005a94 <consoleintr+0x108>
    800059b4:	47c1                	li	a5,16
    800059b6:	10f49363          	bne	s1,a5,80005abc <consoleintr+0x130>
  case C('P'): // Print process list.
    procdump();
    800059ba:	9d0fc0ef          	jal	80001b8a <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800059be:	0001f517          	auipc	a0,0x1f
    800059c2:	10250513          	addi	a0,a0,258 # 80024ac0 <cons>
    800059c6:	039000ef          	jal	800061fe <release>
}
    800059ca:	60e2                	ld	ra,24(sp)
    800059cc:	6442                	ld	s0,16(sp)
    800059ce:	64a2                	ld	s1,8(sp)
    800059d0:	6105                	addi	sp,sp,32
    800059d2:	8082                	ret
  switch (c) {
    800059d4:	07f00793          	li	a5,127
    800059d8:	0af48e63          	beq	s1,a5,80005a94 <consoleintr+0x108>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800059dc:	0001f717          	auipc	a4,0x1f
    800059e0:	0e470713          	addi	a4,a4,228 # 80024ac0 <cons>
    800059e4:	0a072783          	lw	a5,160(a4)
    800059e8:	09872703          	lw	a4,152(a4)
    800059ec:	9f99                	subw	a5,a5,a4
    800059ee:	07f00713          	li	a4,127
    800059f2:	fcf766e3          	bltu	a4,a5,800059be <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800059f6:	47b5                	li	a5,13
    800059f8:	0cf48563          	beq	s1,a5,80005ac2 <consoleintr+0x136>
      consputc(c);
    800059fc:	8526                	mv	a0,s1
    800059fe:	f5dff0ef          	jal	8000595a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a02:	0001f717          	auipc	a4,0x1f
    80005a06:	0be70713          	addi	a4,a4,190 # 80024ac0 <cons>
    80005a0a:	0a072683          	lw	a3,160(a4)
    80005a0e:	0016879b          	addiw	a5,a3,1
    80005a12:	863e                	mv	a2,a5
    80005a14:	0af72023          	sw	a5,160(a4)
    80005a18:	07f6f693          	andi	a3,a3,127
    80005a1c:	9736                	add	a4,a4,a3
    80005a1e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005a22:	ff648713          	addi	a4,s1,-10
    80005a26:	c371                	beqz	a4,80005aea <consoleintr+0x15e>
    80005a28:	14f1                	addi	s1,s1,-4
    80005a2a:	c0e1                	beqz	s1,80005aea <consoleintr+0x15e>
    80005a2c:	0001f717          	auipc	a4,0x1f
    80005a30:	12c72703          	lw	a4,300(a4) # 80024b58 <cons+0x98>
    80005a34:	9f99                	subw	a5,a5,a4
    80005a36:	08000713          	li	a4,128
    80005a3a:	f8e792e3          	bne	a5,a4,800059be <consoleintr+0x32>
    80005a3e:	a075                	j	80005aea <consoleintr+0x15e>
    80005a40:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    80005a42:	0001f717          	auipc	a4,0x1f
    80005a46:	07e70713          	addi	a4,a4,126 # 80024ac0 <cons>
    80005a4a:	0a072783          	lw	a5,160(a4)
    80005a4e:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005a52:	0001f497          	auipc	s1,0x1f
    80005a56:	06e48493          	addi	s1,s1,110 # 80024ac0 <cons>
    while (cons.e != cons.w &&
    80005a5a:	4929                	li	s2,10
    80005a5c:	02f70863          	beq	a4,a5,80005a8c <consoleintr+0x100>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005a60:	37fd                	addiw	a5,a5,-1
    80005a62:	07f7f713          	andi	a4,a5,127
    80005a66:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    80005a68:	01874703          	lbu	a4,24(a4)
    80005a6c:	03270263          	beq	a4,s2,80005a90 <consoleintr+0x104>
      cons.e--;
    80005a70:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a74:	10000513          	li	a0,256
    80005a78:	ee3ff0ef          	jal	8000595a <consputc>
    while (cons.e != cons.w &&
    80005a7c:	0a04a783          	lw	a5,160(s1)
    80005a80:	09c4a703          	lw	a4,156(s1)
    80005a84:	fcf71ee3          	bne	a4,a5,80005a60 <consoleintr+0xd4>
    80005a88:	6902                	ld	s2,0(sp)
    80005a8a:	bf15                	j	800059be <consoleintr+0x32>
    80005a8c:	6902                	ld	s2,0(sp)
    80005a8e:	bf05                	j	800059be <consoleintr+0x32>
    80005a90:	6902                	ld	s2,0(sp)
    80005a92:	b735                	j	800059be <consoleintr+0x32>
    if (cons.e != cons.w) {
    80005a94:	0001f717          	auipc	a4,0x1f
    80005a98:	02c70713          	addi	a4,a4,44 # 80024ac0 <cons>
    80005a9c:	0a072783          	lw	a5,160(a4)
    80005aa0:	09c72703          	lw	a4,156(a4)
    80005aa4:	f0f70de3          	beq	a4,a5,800059be <consoleintr+0x32>
      cons.e--;
    80005aa8:	37fd                	addiw	a5,a5,-1
    80005aaa:	0001f717          	auipc	a4,0x1f
    80005aae:	0af72b23          	sw	a5,182(a4) # 80024b60 <cons+0xa0>
      consputc(BACKSPACE);
    80005ab2:	10000513          	li	a0,256
    80005ab6:	ea5ff0ef          	jal	8000595a <consputc>
    80005aba:	b711                	j	800059be <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005abc:	f00481e3          	beqz	s1,800059be <consoleintr+0x32>
    80005ac0:	bf31                	j	800059dc <consoleintr+0x50>
      consputc(c);
    80005ac2:	4529                	li	a0,10
    80005ac4:	e97ff0ef          	jal	8000595a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ac8:	0001f797          	auipc	a5,0x1f
    80005acc:	ff878793          	addi	a5,a5,-8 # 80024ac0 <cons>
    80005ad0:	0a07a703          	lw	a4,160(a5)
    80005ad4:	0017069b          	addiw	a3,a4,1
    80005ad8:	8636                	mv	a2,a3
    80005ada:	0ad7a023          	sw	a3,160(a5)
    80005ade:	07f77713          	andi	a4,a4,127
    80005ae2:	97ba                	add	a5,a5,a4
    80005ae4:	4729                	li	a4,10
    80005ae6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005aea:	0001f797          	auipc	a5,0x1f
    80005aee:	06c7a923          	sw	a2,114(a5) # 80024b5c <cons+0x9c>
        wakeup(&cons.r);
    80005af2:	0001f517          	auipc	a0,0x1f
    80005af6:	06650513          	addi	a0,a0,102 # 80024b58 <cons+0x98>
    80005afa:	cd9fb0ef          	jal	800017d2 <wakeup>
    80005afe:	b5c1                	j	800059be <consoleintr+0x32>

0000000080005b00 <consoleinit>:

void
consoleinit(void)
{
    80005b00:	1141                	addi	sp,sp,-16
    80005b02:	e406                	sd	ra,8(sp)
    80005b04:	e022                	sd	s0,0(sp)
    80005b06:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b08:	00003597          	auipc	a1,0x3
    80005b0c:	ca858593          	addi	a1,a1,-856 # 800087b0 <etext+0x7b0>
    80005b10:	0001f517          	auipc	a0,0x1f
    80005b14:	fb050513          	addi	a0,a0,-80 # 80024ac0 <cons>
    80005b18:	5de000ef          	jal	800060f6 <initlock>

  uartinit();
    80005b1c:	448000ef          	jal	80005f64 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b20:	00016797          	auipc	a5,0x16
    80005b24:	e0878793          	addi	a5,a5,-504 # 8001b928 <devsw>
    80005b28:	00000717          	auipc	a4,0x0
    80005b2c:	d2070713          	addi	a4,a4,-736 # 80005848 <consoleread>
    80005b30:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b32:	00000717          	auipc	a4,0x0
    80005b36:	c7470713          	addi	a4,a4,-908 # 800057a6 <consolewrite>
    80005b3a:	ef98                	sd	a4,24(a5)
}
    80005b3c:	60a2                	ld	ra,8(sp)
    80005b3e:	6402                	ld	s0,0(sp)
    80005b40:	0141                	addi	sp,sp,16
    80005b42:	8082                	ret

0000000080005b44 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005b44:	7139                	addi	sp,sp,-64
    80005b46:	fc06                	sd	ra,56(sp)
    80005b48:	f822                	sd	s0,48(sp)
    80005b4a:	f04a                	sd	s2,32(sp)
    80005b4c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80005b4e:	c219                	beqz	a2,80005b54 <printint+0x10>
    80005b50:	08054163          	bltz	a0,80005bd2 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005b54:	4301                	li	t1,0

  i = 0;
    80005b56:	fc840913          	addi	s2,s0,-56
    x = xx;
    80005b5a:	86ca                	mv	a3,s2
  i = 0;
    80005b5c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b5e:	00003817          	auipc	a6,0x3
    80005b62:	e3a80813          	addi	a6,a6,-454 # 80008998 <digits>
    80005b66:	88ba                	mv	a7,a4
    80005b68:	0017061b          	addiw	a2,a4,1
    80005b6c:	8732                	mv	a4,a2
    80005b6e:	02b577b3          	remu	a5,a0,a1
    80005b72:	97c2                	add	a5,a5,a6
    80005b74:	0007c783          	lbu	a5,0(a5)
    80005b78:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005b7c:	87aa                	mv	a5,a0
    80005b7e:	02b55533          	divu	a0,a0,a1
    80005b82:	0685                	addi	a3,a3,1
    80005b84:	feb7f1e3          	bgeu	a5,a1,80005b66 <printint+0x22>

  if (sign)
    80005b88:	00030c63          	beqz	t1,80005ba0 <printint+0x5c>
    buf[i++] = '-';
    80005b8c:	fe060793          	addi	a5,a2,-32
    80005b90:	00878633          	add	a2,a5,s0
    80005b94:	02d00793          	li	a5,45
    80005b98:	fef60423          	sb	a5,-24(a2)
    80005b9c:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    80005ba0:	02e05463          	blez	a4,80005bc8 <printint+0x84>
    80005ba4:	f426                	sd	s1,40(sp)
    80005ba6:	377d                	addiw	a4,a4,-1
    80005ba8:	00e904b3          	add	s1,s2,a4
    80005bac:	197d                	addi	s2,s2,-1
    80005bae:	993a                	add	s2,s2,a4
    80005bb0:	1702                	slli	a4,a4,0x20
    80005bb2:	9301                	srli	a4,a4,0x20
    80005bb4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bb8:	0004c503          	lbu	a0,0(s1)
    80005bbc:	d9fff0ef          	jal	8000595a <consputc>
  while (--i >= 0)
    80005bc0:	14fd                	addi	s1,s1,-1
    80005bc2:	ff249be3          	bne	s1,s2,80005bb8 <printint+0x74>
    80005bc6:	74a2                	ld	s1,40(sp)
}
    80005bc8:	70e2                	ld	ra,56(sp)
    80005bca:	7442                	ld	s0,48(sp)
    80005bcc:	7902                	ld	s2,32(sp)
    80005bce:	6121                	addi	sp,sp,64
    80005bd0:	8082                	ret
    x = -xx;
    80005bd2:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    80005bd6:	4305                	li	t1,1
    x = -xx;
    80005bd8:	bfbd                	j	80005b56 <printint+0x12>

0000000080005bda <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    80005bda:	7131                	addi	sp,sp,-192
    80005bdc:	fc86                	sd	ra,120(sp)
    80005bde:	f8a2                	sd	s0,112(sp)
    80005be0:	f0ca                	sd	s2,96(sp)
    80005be2:	0100                	addi	s0,sp,128
    80005be4:	892a                	mv	s2,a0
    80005be6:	e40c                	sd	a1,8(s0)
    80005be8:	e810                	sd	a2,16(s0)
    80005bea:	ec14                	sd	a3,24(s0)
    80005bec:	f018                	sd	a4,32(s0)
    80005bee:	f41c                	sd	a5,40(s0)
    80005bf0:	03043823          	sd	a6,48(s0)
    80005bf4:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    80005bf8:	00006797          	auipc	a5,0x6
    80005bfc:	a887a783          	lw	a5,-1400(a5) # 8000b680 <panicking>
    80005c00:	cf9d                	beqz	a5,80005c3e <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005c02:	00840793          	addi	a5,s0,8
    80005c06:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80005c0a:	00094503          	lbu	a0,0(s2)
    80005c0e:	22050663          	beqz	a0,80005e3a <printk+0x260>
    80005c12:	f4a6                	sd	s1,104(sp)
    80005c14:	ecce                	sd	s3,88(sp)
    80005c16:	e8d2                	sd	s4,80(sp)
    80005c18:	e4d6                	sd	s5,72(sp)
    80005c1a:	e0da                	sd	s6,64(sp)
    80005c1c:	fc5e                	sd	s7,56(sp)
    80005c1e:	f862                	sd	s8,48(sp)
    80005c20:	f06a                	sd	s10,32(sp)
    80005c22:	ec6e                	sd	s11,24(sp)
    80005c24:	4a01                	li	s4,0
    if (cx != '%') {
    80005c26:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80005c2a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80005c2e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80005c32:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005c36:	4b29                	li	s6,10
    if (c0 == 'd') {
    80005c38:	06400b93          	li	s7,100
    80005c3c:	a015                	j	80005c60 <printk+0x86>
    acquire(&pr.lock);
    80005c3e:	0001f517          	auipc	a0,0x1f
    80005c42:	f2a50513          	addi	a0,a0,-214 # 80024b68 <pr>
    80005c46:	530000ef          	jal	80006176 <acquire>
    80005c4a:	bf65                	j	80005c02 <printk+0x28>
      consputc(cx);
    80005c4c:	d0fff0ef          	jal	8000595a <consputc>
      continue;
    80005c50:	84d2                	mv	s1,s4
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80005c52:	2485                	addiw	s1,s1,1
    80005c54:	8a26                	mv	s4,s1
    80005c56:	94ca                	add	s1,s1,s2
    80005c58:	0004c503          	lbu	a0,0(s1)
    80005c5c:	1c050663          	beqz	a0,80005e28 <printk+0x24e>
    if (cx != '%') {
    80005c60:	ff3516e3          	bne	a0,s3,80005c4c <printk+0x72>
    i++;
    80005c64:	001a079b          	addiw	a5,s4,1
    80005c68:	84be                	mv	s1,a5
    c0 = fmt[i + 0] & 0xff;
    80005c6a:	00f90733          	add	a4,s2,a5
    80005c6e:	00074a83          	lbu	s5,0(a4)
    if (c0)
    80005c72:	200a8963          	beqz	s5,80005e84 <printk+0x2aa>
      c1 = fmt[i + 1] & 0xff;
    80005c76:	00174683          	lbu	a3,1(a4)
    if (c1)
    80005c7a:	1e068c63          	beqz	a3,80005e72 <printk+0x298>
    if (c0 == 'd') {
    80005c7e:	037a8863          	beq	s5,s7,80005cae <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    80005c82:	f94a8713          	addi	a4,s5,-108
    80005c86:	00173713          	seqz	a4,a4
    80005c8a:	f9c68613          	addi	a2,a3,-100
    80005c8e:	ee05                	bnez	a2,80005cc6 <printk+0xec>
    80005c90:	cb1d                	beqz	a4,80005cc6 <printk+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    80005c92:	f8843783          	ld	a5,-120(s0)
    80005c96:	00878713          	addi	a4,a5,8
    80005c9a:	f8e43423          	sd	a4,-120(s0)
    80005c9e:	4605                	li	a2,1
    80005ca0:	85da                	mv	a1,s6
    80005ca2:	6388                	ld	a0,0(a5)
    80005ca4:	ea1ff0ef          	jal	80005b44 <printint>
      i += 1;
    80005ca8:	002a049b          	addiw	s1,s4,2
    80005cac:	b75d                	j	80005c52 <printk+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005cae:	f8843783          	ld	a5,-120(s0)
    80005cb2:	00878713          	addi	a4,a5,8
    80005cb6:	f8e43423          	sd	a4,-120(s0)
    80005cba:	4605                	li	a2,1
    80005cbc:	85da                	mv	a1,s6
    80005cbe:	4388                	lw	a0,0(a5)
    80005cc0:	e85ff0ef          	jal	80005b44 <printint>
    80005cc4:	b779                	j	80005c52 <printk+0x78>
      c2 = fmt[i + 2] & 0xff;
    80005cc6:	97ca                	add	a5,a5,s2
    80005cc8:	8636                	mv	a2,a3
    80005cca:	0027c683          	lbu	a3,2(a5)
    80005cce:	a2c9                	j	80005e90 <printk+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005cd0:	f8843783          	ld	a5,-120(s0)
    80005cd4:	00878713          	addi	a4,a5,8
    80005cd8:	f8e43423          	sd	a4,-120(s0)
    80005cdc:	4605                	li	a2,1
    80005cde:	45a9                	li	a1,10
    80005ce0:	6388                	ld	a0,0(a5)
    80005ce2:	e63ff0ef          	jal	80005b44 <printint>
      i += 2;
    80005ce6:	003a049b          	addiw	s1,s4,3
    80005cea:	b7a5                	j	80005c52 <printk+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    80005cec:	f8843783          	ld	a5,-120(s0)
    80005cf0:	00878713          	addi	a4,a5,8
    80005cf4:	f8e43423          	sd	a4,-120(s0)
    80005cf8:	4601                	li	a2,0
    80005cfa:	85da                	mv	a1,s6
    80005cfc:	0007e503          	lwu	a0,0(a5)
    80005d00:	e45ff0ef          	jal	80005b44 <printint>
    80005d04:	b7b9                	j	80005c52 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005d06:	f8843783          	ld	a5,-120(s0)
    80005d0a:	00878713          	addi	a4,a5,8
    80005d0e:	f8e43423          	sd	a4,-120(s0)
    80005d12:	4601                	li	a2,0
    80005d14:	85da                	mv	a1,s6
    80005d16:	6388                	ld	a0,0(a5)
    80005d18:	e2dff0ef          	jal	80005b44 <printint>
      i += 1;
    80005d1c:	002a049b          	addiw	s1,s4,2
    80005d20:	bf0d                	j	80005c52 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005d22:	f8843783          	ld	a5,-120(s0)
    80005d26:	00878713          	addi	a4,a5,8
    80005d2a:	f8e43423          	sd	a4,-120(s0)
    80005d2e:	4601                	li	a2,0
    80005d30:	45a9                	li	a1,10
    80005d32:	6388                	ld	a0,0(a5)
    80005d34:	e11ff0ef          	jal	80005b44 <printint>
      i += 2;
    80005d38:	003a049b          	addiw	s1,s4,3
    80005d3c:	bf19                	j	80005c52 <printk+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005d3e:	f8843783          	ld	a5,-120(s0)
    80005d42:	00878713          	addi	a4,a5,8
    80005d46:	f8e43423          	sd	a4,-120(s0)
    80005d4a:	4601                	li	a2,0
    80005d4c:	45c1                	li	a1,16
    80005d4e:	0007e503          	lwu	a0,0(a5)
    80005d52:	df3ff0ef          	jal	80005b44 <printint>
    80005d56:	bdf5                	j	80005c52 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005d58:	f8843783          	ld	a5,-120(s0)
    80005d5c:	00878713          	addi	a4,a5,8
    80005d60:	f8e43423          	sd	a4,-120(s0)
    80005d64:	45c1                	li	a1,16
    80005d66:	6388                	ld	a0,0(a5)
    80005d68:	dddff0ef          	jal	80005b44 <printint>
      i += 1;
    80005d6c:	002a049b          	addiw	s1,s4,2
    80005d70:	b5cd                	j	80005c52 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005d72:	f8843783          	ld	a5,-120(s0)
    80005d76:	00878713          	addi	a4,a5,8
    80005d7a:	f8e43423          	sd	a4,-120(s0)
    80005d7e:	4601                	li	a2,0
    80005d80:	45c1                	li	a1,16
    80005d82:	6388                	ld	a0,0(a5)
    80005d84:	dc1ff0ef          	jal	80005b44 <printint>
      i += 2;
    80005d88:	003a049b          	addiw	s1,s4,3
    80005d8c:	b5d9                	j	80005c52 <printk+0x78>
    80005d8e:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005d90:	f8843783          	ld	a5,-120(s0)
    80005d94:	00878713          	addi	a4,a5,8
    80005d98:	f8e43423          	sd	a4,-120(s0)
    80005d9c:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005da0:	03000513          	li	a0,48
    80005da4:	bb7ff0ef          	jal	8000595a <consputc>
  consputc('x');
    80005da8:	07800513          	li	a0,120
    80005dac:	bafff0ef          	jal	8000595a <consputc>
    80005db0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005db2:	00003c97          	auipc	s9,0x3
    80005db6:	be6c8c93          	addi	s9,s9,-1050 # 80008998 <digits>
    80005dba:	03cad793          	srli	a5,s5,0x3c
    80005dbe:	97e6                	add	a5,a5,s9
    80005dc0:	0007c503          	lbu	a0,0(a5)
    80005dc4:	b97ff0ef          	jal	8000595a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dc8:	0a92                	slli	s5,s5,0x4
    80005dca:	3a7d                	addiw	s4,s4,-1
    80005dcc:	fe0a17e3          	bnez	s4,80005dba <printk+0x1e0>
    80005dd0:	7ca2                	ld	s9,40(sp)
    80005dd2:	b541                	j	80005c52 <printk+0x78>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80005dd4:	f8843783          	ld	a5,-120(s0)
    80005dd8:	00878713          	addi	a4,a5,8
    80005ddc:	f8e43423          	sd	a4,-120(s0)
    80005de0:	4388                	lw	a0,0(a5)
    80005de2:	b79ff0ef          	jal	8000595a <consputc>
    80005de6:	b5b5                	j	80005c52 <printk+0x78>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80005de8:	f8843783          	ld	a5,-120(s0)
    80005dec:	00878713          	addi	a4,a5,8
    80005df0:	f8e43423          	sd	a4,-120(s0)
    80005df4:	0007ba03          	ld	s4,0(a5)
    80005df8:	000a0d63          	beqz	s4,80005e12 <printk+0x238>
        s = "(null)";
      for (; *s; s++)
    80005dfc:	000a4503          	lbu	a0,0(s4)
    80005e00:	e40509e3          	beqz	a0,80005c52 <printk+0x78>
        consputc(*s);
    80005e04:	b57ff0ef          	jal	8000595a <consputc>
      for (; *s; s++)
    80005e08:	0a05                	addi	s4,s4,1
    80005e0a:	000a4503          	lbu	a0,0(s4)
    80005e0e:	f97d                	bnez	a0,80005e04 <printk+0x22a>
    80005e10:	b589                	j	80005c52 <printk+0x78>
        s = "(null)";
    80005e12:	00003a17          	auipc	s4,0x3
    80005e16:	9a6a0a13          	addi	s4,s4,-1626 # 800087b8 <etext+0x7b8>
      for (; *s; s++)
    80005e1a:	02800513          	li	a0,40
    80005e1e:	b7dd                	j	80005e04 <printk+0x22a>
    } else if (c0 == '%') {
      consputc('%');
    80005e20:	8556                	mv	a0,s5
    80005e22:	b39ff0ef          	jal	8000595a <consputc>
    80005e26:	b535                	j	80005c52 <printk+0x78>
    80005e28:	74a6                	ld	s1,104(sp)
    80005e2a:	69e6                	ld	s3,88(sp)
    80005e2c:	6a46                	ld	s4,80(sp)
    80005e2e:	6aa6                	ld	s5,72(sp)
    80005e30:	6b06                	ld	s6,64(sp)
    80005e32:	7be2                	ld	s7,56(sp)
    80005e34:	7c42                	ld	s8,48(sp)
    80005e36:	7d02                	ld	s10,32(sp)
    80005e38:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    80005e3a:	00006797          	auipc	a5,0x6
    80005e3e:	8467a783          	lw	a5,-1978(a5) # 8000b680 <panicking>
    80005e42:	c38d                	beqz	a5,80005e64 <printk+0x28a>
    release(&pr.lock);

  return 0;
}
    80005e44:	4501                	li	a0,0
    80005e46:	70e6                	ld	ra,120(sp)
    80005e48:	7446                	ld	s0,112(sp)
    80005e4a:	7906                	ld	s2,96(sp)
    80005e4c:	6129                	addi	sp,sp,192
    80005e4e:	8082                	ret
    80005e50:	74a6                	ld	s1,104(sp)
    80005e52:	69e6                	ld	s3,88(sp)
    80005e54:	6a46                	ld	s4,80(sp)
    80005e56:	6aa6                	ld	s5,72(sp)
    80005e58:	6b06                	ld	s6,64(sp)
    80005e5a:	7be2                	ld	s7,56(sp)
    80005e5c:	7c42                	ld	s8,48(sp)
    80005e5e:	7d02                	ld	s10,32(sp)
    80005e60:	6de2                	ld	s11,24(sp)
    80005e62:	bfe1                	j	80005e3a <printk+0x260>
    release(&pr.lock);
    80005e64:	0001f517          	auipc	a0,0x1f
    80005e68:	d0450513          	addi	a0,a0,-764 # 80024b68 <pr>
    80005e6c:	392000ef          	jal	800061fe <release>
  return 0;
    80005e70:	bfd1                	j	80005e44 <printk+0x26a>
    if (c0 == 'd') {
    80005e72:	e37a8ee3          	beq	s5,s7,80005cae <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    80005e76:	f94a8713          	addi	a4,s5,-108
    80005e7a:	00173713          	seqz	a4,a4
    80005e7e:	8636                	mv	a2,a3
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80005e80:	4781                	li	a5,0
    80005e82:	a00d                	j	80005ea4 <printk+0x2ca>
    } else if (c0 == 'l' && c1 == 'd') {
    80005e84:	f94a8713          	addi	a4,s5,-108
    80005e88:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    80005e8c:	8656                	mv	a2,s5
    80005e8e:	86d6                	mv	a3,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80005e90:	f9460793          	addi	a5,a2,-108
    80005e94:	0017b793          	seqz	a5,a5
    80005e98:	8ff9                	and	a5,a5,a4
    80005e9a:	f9c68593          	addi	a1,a3,-100
    80005e9e:	e199                	bnez	a1,80005ea4 <printk+0x2ca>
    80005ea0:	e20798e3          	bnez	a5,80005cd0 <printk+0xf6>
    } else if (c0 == 'u') {
    80005ea4:	e58a84e3          	beq	s5,s8,80005cec <printk+0x112>
    } else if (c0 == 'l' && c1 == 'u') {
    80005ea8:	f8b60593          	addi	a1,a2,-117
    80005eac:	e199                	bnez	a1,80005eb2 <printk+0x2d8>
    80005eae:	e4071ce3          	bnez	a4,80005d06 <printk+0x12c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    80005eb2:	f8b68593          	addi	a1,a3,-117
    80005eb6:	e199                	bnez	a1,80005ebc <printk+0x2e2>
    80005eb8:	e60795e3          	bnez	a5,80005d22 <printk+0x148>
    } else if (c0 == 'x') {
    80005ebc:	e9aa81e3          	beq	s5,s10,80005d3e <printk+0x164>
    } else if (c0 == 'l' && c1 == 'x') {
    80005ec0:	f8860613          	addi	a2,a2,-120
    80005ec4:	e219                	bnez	a2,80005eca <printk+0x2f0>
    80005ec6:	e80719e3          	bnez	a4,80005d58 <printk+0x17e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    80005eca:	f8868693          	addi	a3,a3,-120
    80005ece:	e299                	bnez	a3,80005ed4 <printk+0x2fa>
    80005ed0:	ea0791e3          	bnez	a5,80005d72 <printk+0x198>
    } else if (c0 == 'p') {
    80005ed4:	ebba8de3          	beq	s5,s11,80005d8e <printk+0x1b4>
    } else if (c0 == 'c') {
    80005ed8:	06300793          	li	a5,99
    80005edc:	eefa8ce3          	beq	s5,a5,80005dd4 <printk+0x1fa>
    } else if (c0 == 's') {
    80005ee0:	07300793          	li	a5,115
    80005ee4:	f0fa82e3          	beq	s5,a5,80005de8 <printk+0x20e>
    } else if (c0 == '%') {
    80005ee8:	02500793          	li	a5,37
    80005eec:	f2fa8ae3          	beq	s5,a5,80005e20 <printk+0x246>
    } else if (c0 == 0) {
    80005ef0:	f60a80e3          	beqz	s5,80005e50 <printk+0x276>
      consputc('%');
    80005ef4:	02500513          	li	a0,37
    80005ef8:	a63ff0ef          	jal	8000595a <consputc>
      consputc(c0);
    80005efc:	8556                	mv	a0,s5
    80005efe:	a5dff0ef          	jal	8000595a <consputc>
    80005f02:	bb81                	j	80005c52 <printk+0x78>

0000000080005f04 <panic>:

void
panic(char *s)
{
    80005f04:	1101                	addi	sp,sp,-32
    80005f06:	ec06                	sd	ra,24(sp)
    80005f08:	e822                	sd	s0,16(sp)
    80005f0a:	e426                	sd	s1,8(sp)
    80005f0c:	e04a                	sd	s2,0(sp)
    80005f0e:	1000                	addi	s0,sp,32
    80005f10:	892a                	mv	s2,a0
  panicking = 1;
    80005f12:	4485                	li	s1,1
    80005f14:	00005797          	auipc	a5,0x5
    80005f18:	7697a623          	sw	s1,1900(a5) # 8000b680 <panicking>
  printk("panic: ");
    80005f1c:	00003517          	auipc	a0,0x3
    80005f20:	8a450513          	addi	a0,a0,-1884 # 800087c0 <etext+0x7c0>
    80005f24:	cb7ff0ef          	jal	80005bda <printk>
  printk("%s\n", s);
    80005f28:	85ca                	mv	a1,s2
    80005f2a:	00003517          	auipc	a0,0x3
    80005f2e:	89e50513          	addi	a0,a0,-1890 # 800087c8 <etext+0x7c8>
    80005f32:	ca9ff0ef          	jal	80005bda <printk>
  panicked = 1; // freeze uart output from other CPUs
    80005f36:	00005797          	auipc	a5,0x5
    80005f3a:	7497a323          	sw	s1,1862(a5) # 8000b67c <panicked>
  for (;;)
    80005f3e:	a001                	j	80005f3e <panic+0x3a>

0000000080005f40 <printkinit>:
    ;
}

void
printkinit(void)
{
    80005f40:	1141                	addi	sp,sp,-16
    80005f42:	e406                	sd	ra,8(sp)
    80005f44:	e022                	sd	s0,0(sp)
    80005f46:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005f48:	00003597          	auipc	a1,0x3
    80005f4c:	88858593          	addi	a1,a1,-1912 # 800087d0 <etext+0x7d0>
    80005f50:	0001f517          	auipc	a0,0x1f
    80005f54:	c1850513          	addi	a0,a0,-1000 # 80024b68 <pr>
    80005f58:	19e000ef          	jal	800060f6 <initlock>
}
    80005f5c:	60a2                	ld	ra,8(sp)
    80005f5e:	6402                	ld	s0,0(sp)
    80005f60:	0141                	addi	sp,sp,16
    80005f62:	8082                	ret

0000000080005f64 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    80005f64:	1141                	addi	sp,sp,-16
    80005f66:	e406                	sd	ra,8(sp)
    80005f68:	e022                	sd	s0,0(sp)
    80005f6a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f6c:	100007b7          	lui	a5,0x10000
    80005f70:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f74:	10000737          	lui	a4,0x10000
    80005f78:	f8000693          	li	a3,-128
    80005f7c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f80:	468d                	li	a3,3
    80005f82:	10000637          	lui	a2,0x10000
    80005f86:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f8a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f8e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f92:	8732                	mv	a4,a2
    80005f94:	461d                	li	a2,7
    80005f96:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f9a:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    80005f9e:	00003597          	auipc	a1,0x3
    80005fa2:	83a58593          	addi	a1,a1,-1990 # 800087d8 <etext+0x7d8>
    80005fa6:	0001f517          	auipc	a0,0x1f
    80005faa:	bda50513          	addi	a0,a0,-1062 # 80024b80 <tx_lock>
    80005fae:	985fd0ef          	jal	80003932 <initsleeplock>
}
    80005fb2:	60a2                	ld	ra,8(sp)
    80005fb4:	6402                	ld	s0,0(sp)
    80005fb6:	0141                	addi	sp,sp,16
    80005fb8:	8082                	ret

0000000080005fba <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005fba:	7139                	addi	sp,sp,-64
    80005fbc:	fc06                	sd	ra,56(sp)
    80005fbe:	f822                	sd	s0,48(sp)
    80005fc0:	f04a                	sd	s2,32(sp)
    80005fc2:	e456                	sd	s5,8(sp)
    80005fc4:	0080                	addi	s0,sp,64
    80005fc6:	8aaa                	mv	s5,a0
    80005fc8:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    80005fca:	0001f517          	auipc	a0,0x1f
    80005fce:	bb650513          	addi	a0,a0,-1098 # 80024b80 <tx_lock>
    80005fd2:	997fd0ef          	jal	80003968 <acquiresleep>

  int i = 0;
  while (i < n) {
    80005fd6:	05205963          	blez	s2,80006028 <uartwrite+0x6e>
    80005fda:	f426                	sd	s1,40(sp)
    80005fdc:	ec4e                	sd	s3,24(sp)
    80005fde:	e852                	sd	s4,16(sp)
    80005fe0:	e05a                	sd	s6,0(sp)
  int i = 0;
    80005fe2:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80005fe4:	00005a17          	auipc	s4,0x5
    80005fe8:	6a0a0a13          	addi	s4,s4,1696 # 8000b684 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80005fec:	100009b7          	lui	s3,0x10000
    80005ff0:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80005ff2:	10000b37          	lui	s6,0x10000
    80005ff6:	a029                	j	80006000 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    80005ff8:	faafb0ef          	jal	800017a2 <sleep>
  while (i < n) {
    80005ffc:	0324d263          	bge	s1,s2,80006020 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80006000:	8552                	mv	a0,s4
    80006002:	f64fb0ef          	jal	80001766 <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80006006:	0009c783          	lbu	a5,0(s3)
    8000600a:	0207f793          	andi	a5,a5,32
    8000600e:	d7ed                	beqz	a5,80005ff8 <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80006010:	009a87b3          	add	a5,s5,s1
    80006014:	0007c783          	lbu	a5,0(a5)
    80006018:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    8000601c:	2485                	addiw	s1,s1,1
    8000601e:	bff9                	j	80005ffc <uartwrite+0x42>
    80006020:	74a2                	ld	s1,40(sp)
    80006022:	69e2                	ld	s3,24(sp)
    80006024:	6a42                	ld	s4,16(sp)
    80006026:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    80006028:	0001f517          	auipc	a0,0x1f
    8000602c:	b5850513          	addi	a0,a0,-1192 # 80024b80 <tx_lock>
    80006030:	98dfd0ef          	jal	800039bc <releasesleep>
}
    80006034:	70e2                	ld	ra,56(sp)
    80006036:	7442                	ld	s0,48(sp)
    80006038:	7902                	ld	s2,32(sp)
    8000603a:	6aa2                	ld	s5,8(sp)
    8000603c:	6121                	addi	sp,sp,64
    8000603e:	8082                	ret

0000000080006040 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006040:	1101                	addi	sp,sp,-32
    80006042:	ec06                	sd	ra,24(sp)
    80006044:	e822                	sd	s0,16(sp)
    80006046:	e426                	sd	s1,8(sp)
    80006048:	1000                	addi	s0,sp,32
    8000604a:	84aa                	mv	s1,a0
  if (panicking == 0)
    8000604c:	00005797          	auipc	a5,0x5
    80006050:	6347a783          	lw	a5,1588(a5) # 8000b680 <panicking>
    80006054:	cf95                	beqz	a5,80006090 <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80006056:	00005797          	auipc	a5,0x5
    8000605a:	6267a783          	lw	a5,1574(a5) # 8000b67c <panicked>
    8000605e:	ef85                	bnez	a5,80006096 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006060:	10000737          	lui	a4,0x10000
    80006064:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006066:	00074783          	lbu	a5,0(a4)
    8000606a:	0207f793          	andi	a5,a5,32
    8000606e:	dfe5                	beqz	a5,80006066 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80006070:	0ff4f513          	zext.b	a0,s1
    80006074:	100007b7          	lui	a5,0x10000
    80006078:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    8000607c:	00005797          	auipc	a5,0x5
    80006080:	6047a783          	lw	a5,1540(a5) # 8000b680 <panicking>
    80006084:	cb91                	beqz	a5,80006098 <uartputc_sync+0x58>
    pop_off();
}
    80006086:	60e2                	ld	ra,24(sp)
    80006088:	6442                	ld	s0,16(sp)
    8000608a:	64a2                	ld	s1,8(sp)
    8000608c:	6105                	addi	sp,sp,32
    8000608e:	8082                	ret
    push_off();
    80006090:	0ac000ef          	jal	8000613c <push_off>
    80006094:	b7c9                	j	80006056 <uartputc_sync+0x16>
    for (;;)
    80006096:	a001                	j	80006096 <uartputc_sync+0x56>
    pop_off();
    80006098:	11e000ef          	jal	800061b6 <pop_off>
}
    8000609c:	b7ed                	j	80006086 <uartputc_sync+0x46>

000000008000609e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000609e:	1101                	addi	sp,sp,-32
    800060a0:	ec06                	sd	ra,24(sp)
    800060a2:	e822                	sd	s0,16(sp)
    800060a4:	e426                	sd	s1,8(sp)
    800060a6:	e04a                	sd	s2,0(sp)
    800060a8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800060aa:	100007b7          	lui	a5,0x10000
    800060ae:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800060b2:	100007b7          	lui	a5,0x10000
    800060b6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060ba:	0207f793          	andi	a5,a5,32
    800060be:	ef99                	bnez	a5,800060dc <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800060c0:	100004b7          	lui	s1,0x10000
    800060c4:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    800060c6:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    800060ca:	0004c783          	lbu	a5,0(s1)
    800060ce:	8b85                	andi	a5,a5,1
    800060d0:	cf89                	beqz	a5,800060ea <uartintr+0x4c>
    return ReadReg(RHR);
    800060d2:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    800060d6:	8b7ff0ef          	jal	8000598c <consoleintr>
  while (1) {
    800060da:	bfc5                	j	800060ca <uartintr+0x2c>
    wakeup(&tx_chan);
    800060dc:	00005517          	auipc	a0,0x5
    800060e0:	5a850513          	addi	a0,a0,1448 # 8000b684 <tx_chan>
    800060e4:	eeefb0ef          	jal	800017d2 <wakeup>
    800060e8:	bfe1                	j	800060c0 <uartintr+0x22>
  }
}
    800060ea:	60e2                	ld	ra,24(sp)
    800060ec:	6442                	ld	s0,16(sp)
    800060ee:	64a2                	ld	s1,8(sp)
    800060f0:	6902                	ld	s2,0(sp)
    800060f2:	6105                	addi	sp,sp,32
    800060f4:	8082                	ret

00000000800060f6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060f6:	1141                	addi	sp,sp,-16
    800060f8:	e406                	sd	ra,8(sp)
    800060fa:	e022                	sd	s0,0(sp)
    800060fc:	0800                	addi	s0,sp,16
  lk->name = name;
    800060fe:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006100:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006104:	00053823          	sd	zero,16(a0)
}
    80006108:	60a2                	ld	ra,8(sp)
    8000610a:	6402                	ld	s0,0(sp)
    8000610c:	0141                	addi	sp,sp,16
    8000610e:	8082                	ret

0000000080006110 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006110:	411c                	lw	a5,0(a0)
    80006112:	e399                	bnez	a5,80006118 <holding+0x8>
    80006114:	4501                	li	a0,0
  return r;
}
    80006116:	8082                	ret
{
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006122:	691c                	ld	a5,16(a0)
    80006124:	84be                	mv	s1,a5
    80006126:	f79fa0ef          	jal	8000109e <mycpu>
    8000612a:	40a48533          	sub	a0,s1,a0
    8000612e:	00153513          	seqz	a0,a0
}
    80006132:	60e2                	ld	ra,24(sp)
    80006134:	6442                	ld	s0,16(sp)
    80006136:	64a2                	ld	s1,8(sp)
    80006138:	6105                	addi	sp,sp,32
    8000613a:	8082                	ret

000000008000613c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000613c:	1101                	addi	sp,sp,-32
    8000613e:	ec06                	sd	ra,24(sp)
    80006140:	e822                	sd	s0,16(sp)
    80006142:	e426                	sd	s1,8(sp)
    80006144:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80006146:	100177f3          	csrrci	a5,sstatus,2
    8000614a:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    8000614c:	f53fa0ef          	jal	8000109e <mycpu>
    80006150:	5d3c                	lw	a5,120(a0)
    80006152:	cb99                	beqz	a5,80006168 <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006154:	f4bfa0ef          	jal	8000109e <mycpu>
    80006158:	5d3c                	lw	a5,120(a0)
    8000615a:	2785                	addiw	a5,a5,1
    8000615c:	dd3c                	sw	a5,120(a0)
}
    8000615e:	60e2                	ld	ra,24(sp)
    80006160:	6442                	ld	s0,16(sp)
    80006162:	64a2                	ld	s1,8(sp)
    80006164:	6105                	addi	sp,sp,32
    80006166:	8082                	ret
    mycpu()->intena = old;
    80006168:	f37fa0ef          	jal	8000109e <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    8000616c:	0014d793          	srli	a5,s1,0x1
    80006170:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80006172:	dd7c                	sw	a5,124(a0)
    80006174:	b7c5                	j	80006154 <push_off+0x18>

0000000080006176 <acquire>:
{
    80006176:	1101                	addi	sp,sp,-32
    80006178:	ec06                	sd	ra,24(sp)
    8000617a:	e822                	sd	s0,16(sp)
    8000617c:	e426                	sd	s1,8(sp)
    8000617e:	1000                	addi	s0,sp,32
    80006180:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006182:	fbbff0ef          	jal	8000613c <push_off>
  if (holding(lk))
    80006186:	8526                	mv	a0,s1
    80006188:	f89ff0ef          	jal	80006110 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    8000618c:	4705                	li	a4,1
  if (holding(lk))
    8000618e:	ed11                	bnez	a0,800061aa <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80006190:	87ba                	mv	a5,a4
    80006192:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006196:	2781                	sext.w	a5,a5
    80006198:	ffe5                	bnez	a5,80006190 <acquire+0x1a>
  lk->cpu = mycpu();
    8000619a:	f05fa0ef          	jal	8000109e <mycpu>
    8000619e:	e888                	sd	a0,16(s1)
}
    800061a0:	60e2                	ld	ra,24(sp)
    800061a2:	6442                	ld	s0,16(sp)
    800061a4:	64a2                	ld	s1,8(sp)
    800061a6:	6105                	addi	sp,sp,32
    800061a8:	8082                	ret
    panic("acquire");
    800061aa:	00002517          	auipc	a0,0x2
    800061ae:	63650513          	addi	a0,a0,1590 # 800087e0 <etext+0x7e0>
    800061b2:	d53ff0ef          	jal	80005f04 <panic>

00000000800061b6 <pop_off>:

void
pop_off(void)
{
    800061b6:	1141                	addi	sp,sp,-16
    800061b8:	e406                	sd	ra,8(sp)
    800061ba:	e022                	sd	s0,0(sp)
    800061bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061be:	ee1fa0ef          	jal	8000109e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800061c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061c6:	8b89                	andi	a5,a5,2
  if (intr_get())
    800061c8:	ef99                	bnez	a5,800061e6 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    800061ca:	5d3c                	lw	a5,120(a0)
    800061cc:	02f05363          	blez	a5,800061f2 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    800061d0:	37fd                	addiw	a5,a5,-1
    800061d2:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    800061d4:	e789                	bnez	a5,800061de <pop_off+0x28>
    800061d6:	5d7c                	lw	a5,124(a0)
    800061d8:	c399                	beqz	a5,800061de <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    800061da:	10016073          	csrsi	sstatus,2
    intr_on();
}
    800061de:	60a2                	ld	ra,8(sp)
    800061e0:	6402                	ld	s0,0(sp)
    800061e2:	0141                	addi	sp,sp,16
    800061e4:	8082                	ret
    panic("pop_off - interruptible");
    800061e6:	00002517          	auipc	a0,0x2
    800061ea:	60250513          	addi	a0,a0,1538 # 800087e8 <etext+0x7e8>
    800061ee:	d17ff0ef          	jal	80005f04 <panic>
    panic("pop_off");
    800061f2:	00002517          	auipc	a0,0x2
    800061f6:	60e50513          	addi	a0,a0,1550 # 80008800 <etext+0x800>
    800061fa:	d0bff0ef          	jal	80005f04 <panic>

00000000800061fe <release>:
{
    800061fe:	1101                	addi	sp,sp,-32
    80006200:	ec06                	sd	ra,24(sp)
    80006202:	e822                	sd	s0,16(sp)
    80006204:	e426                	sd	s1,8(sp)
    80006206:	1000                	addi	s0,sp,32
    80006208:	84aa                	mv	s1,a0
  if (!holding(lk))
    8000620a:	f07ff0ef          	jal	80006110 <holding>
    8000620e:	cd11                	beqz	a0,8000622a <release+0x2c>
  lk->cpu = 0;
    80006210:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80006214:	0310000f          	fence	rw,w
    80006218:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000621c:	f9bff0ef          	jal	800061b6 <pop_off>
}
    80006220:	60e2                	ld	ra,24(sp)
    80006222:	6442                	ld	s0,16(sp)
    80006224:	64a2                	ld	s1,8(sp)
    80006226:	6105                	addi	sp,sp,32
    80006228:	8082                	ret
    panic("release");
    8000622a:	00002517          	auipc	a0,0x2
    8000622e:	5de50513          	addi	a0,a0,1502 # 80008808 <etext+0x808>
    80006232:	cd3ff0ef          	jal	80005f04 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	0000100f          	fence.i
    800070a0:	12000073          	sfence.vma
    800070a4:	18051073          	csrw	satp,a0
    800070a8:	12000073          	sfence.vma
    800070ac:	02000537          	lui	a0,0x2000
    800070b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070b2:	0536                	slli	a0,a0,0xd
    800070b4:	02853083          	ld	ra,40(a0)
    800070b8:	03053103          	ld	sp,48(a0)
    800070bc:	03853183          	ld	gp,56(a0)
    800070c0:	04053203          	ld	tp,64(a0)
    800070c4:	04853283          	ld	t0,72(a0)
    800070c8:	05053303          	ld	t1,80(a0)
    800070cc:	05853383          	ld	t2,88(a0)
    800070d0:	7120                	ld	s0,96(a0)
    800070d2:	7524                	ld	s1,104(a0)
    800070d4:	7d2c                	ld	a1,120(a0)
    800070d6:	6150                	ld	a2,128(a0)
    800070d8:	6554                	ld	a3,136(a0)
    800070da:	6958                	ld	a4,144(a0)
    800070dc:	6d5c                	ld	a5,152(a0)
    800070de:	0a053803          	ld	a6,160(a0)
    800070e2:	0a853883          	ld	a7,168(a0)
    800070e6:	0b053903          	ld	s2,176(a0)
    800070ea:	0b853983          	ld	s3,184(a0)
    800070ee:	0c053a03          	ld	s4,192(a0)
    800070f2:	0c853a83          	ld	s5,200(a0)
    800070f6:	0d053b03          	ld	s6,208(a0)
    800070fa:	0d853b83          	ld	s7,216(a0)
    800070fe:	0e053c03          	ld	s8,224(a0)
    80007102:	0e853c83          	ld	s9,232(a0)
    80007106:	0f053d03          	ld	s10,240(a0)
    8000710a:	0f853d83          	ld	s11,248(a0)
    8000710e:	10053e03          	ld	t3,256(a0)
    80007112:	10853e83          	ld	t4,264(a0)
    80007116:	11053f03          	ld	t5,272(a0)
    8000711a:	11853f83          	ld	t6,280(a0)
    8000711e:	7928                	ld	a0,112(a0)
    80007120:	10200073          	sret
	...
