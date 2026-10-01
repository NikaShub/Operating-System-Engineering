
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for (i = 1; i < argc; i++) {
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if (i + 1 < argc) {
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	97cb0b13          	addi	s6,s6,-1668 # 9b0 <malloc+0xfe>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	328000ef          	jal	36c <write>
  for (i = 1; i < argc; i++) {
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	088000ef          	jal	dc <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	30e000ef          	jal	36c <write>
    if (i + 1 < argc) {
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	95058593          	addi	a1,a1,-1712 # 9b8 <malloc+0x106>
  70:	8532                	mv	a0,a2
  72:	2fa000ef          	jal	36c <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	2d4000ef          	jal	34c <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  84:	f7dff0ef          	jal	0 <main>
  exit(r);
  88:	2c4000ef          	jal	34c <exit>

000000000000008c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0xa>
    ;
  return os;
}
  a4:	60a2                	ld	ra,8(sp)
  a6:	6402                	ld	s0,0(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x20>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x20>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x28>
  ea:	00150793          	addi	a5,a0,1
  ee:	86be                	mv	a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x12>
  f8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret
  for (n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfdd                	j	fc <strlen+0x20>

0000000000000108 <memset>:

void *
memset(void *dst, int c, uint n)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 110:	ca19                	beqz	a2,126 <memset+0x1e>
 112:	87aa                	mv	a5,a0
 114:	1602                	slli	a2,a2,0x20
 116:	9201                	srli	a2,a2,0x20
 118:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x14>
  }
  return dst;
}
 126:	60a2                	ld	ra,8(sp)
 128:	6402                	ld	s0,0(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char *
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  for (; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cf81                	beqz	a5,152 <strchr+0x24>
    if (*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1c>
  for (; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xe>
      return (char *)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret
  return 0;
 152:	4501                	li	a0,0
 154:	bfdd                	j	14a <strchr+0x1c>

0000000000000156 <gets>:

char *
gets(char *buf, int max)
{
 156:	711d                	addi	sp,sp,-96
 158:	ec86                	sd	ra,88(sp)
 15a:	e8a2                	sd	s0,80(sp)
 15c:	e4a6                	sd	s1,72(sp)
 15e:	e0ca                	sd	s2,64(sp)
 160:	fc4e                	sd	s3,56(sp)
 162:	f852                	sd	s4,48(sp)
 164:	f456                	sd	s5,40(sp)
 166:	f05a                	sd	s6,32(sp)
 168:	ec5e                	sd	s7,24(sp)
 16a:	e862                	sd	s8,16(sp)
 16c:	1080                	addi	s0,sp,96
 16e:	8baa                	mv	s7,a0
 170:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 172:	892a                	mv	s2,a0
 174:	4481                	li	s1,0
    cc = read(0, &c, 1);
 176:	faf40b13          	addi	s6,s0,-81
 17a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 17c:	8c26                	mv	s8,s1
 17e:	0014899b          	addiw	s3,s1,1
 182:	84ce                	mv	s1,s3
 184:	0349d463          	bge	s3,s4,1ac <gets+0x56>
    cc = read(0, &c, 1);
 188:	8656                	mv	a2,s5
 18a:	85da                	mv	a1,s6
 18c:	4501                	li	a0,0
 18e:	1d6000ef          	jal	364 <read>
    if (cc < 1)
 192:	00a05d63          	blez	a0,1ac <gets+0x56>
      break;
    buf[i++] = c;
 196:	faf44783          	lbu	a5,-81(s0)
 19a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 19e:	0905                	addi	s2,s2,1
 1a0:	ff678713          	addi	a4,a5,-10
 1a4:	c319                	beqz	a4,1aa <gets+0x54>
 1a6:	17cd                	addi	a5,a5,-13
 1a8:	fbf1                	bnez	a5,17c <gets+0x26>
    buf[i++] = c;
 1aa:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ac:	9c5e                	add	s8,s8,s7
 1ae:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b2:	855e                	mv	a0,s7
 1b4:	60e6                	ld	ra,88(sp)
 1b6:	6446                	ld	s0,80(sp)
 1b8:	64a6                	ld	s1,72(sp)
 1ba:	6906                	ld	s2,64(sp)
 1bc:	79e2                	ld	s3,56(sp)
 1be:	7a42                	ld	s4,48(sp)
 1c0:	7aa2                	ld	s5,40(sp)
 1c2:	7b02                	ld	s6,32(sp)
 1c4:	6be2                	ld	s7,24(sp)
 1c6:	6c42                	ld	s8,16(sp)
 1c8:	6125                	addi	sp,sp,96
 1ca:	8082                	ret

00000000000001cc <stat>:

int
stat(const char *n, struct stat *st)
{
 1cc:	1101                	addi	sp,sp,-32
 1ce:	ec06                	sd	ra,24(sp)
 1d0:	e822                	sd	s0,16(sp)
 1d2:	e04a                	sd	s2,0(sp)
 1d4:	1000                	addi	s0,sp,32
 1d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d8:	4581                	li	a1,0
 1da:	1b2000ef          	jal	38c <open>
  if (fd < 0)
 1de:	02054263          	bltz	a0,202 <stat+0x36>
 1e2:	e426                	sd	s1,8(sp)
 1e4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e6:	85ca                	mv	a1,s2
 1e8:	1bc000ef          	jal	3a4 <fstat>
 1ec:	892a                	mv	s2,a0
  close(fd);
 1ee:	8526                	mv	a0,s1
 1f0:	184000ef          	jal	374 <close>
  return r;
 1f4:	64a2                	ld	s1,8(sp)
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	6902                	ld	s2,0(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret
    return -1;
 202:	57fd                	li	a5,-1
 204:	893e                	mv	s2,a5
 206:	bfc5                	j	1f6 <stat+0x2a>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66963          	bltu	a2,a5,250 <atoi+0x48>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1e>
  return n;
}
 248:	60a2                	ld	ra,8(sp)
 24a:	6402                	ld	s0,0(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  n = 0;
 250:	4501                	li	a0,0
 252:	bfdd                	j	248 <atoi+0x40>

0000000000000254 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25c:	02b57563          	bgeu	a0,a1,286 <memmove+0x32>
    while (n-- > 0)
 260:	00c05f63          	blez	a2,27e <memmove+0x2a>
 264:	1602                	slli	a2,a2,0x20
 266:	9201                	srli	a2,a2,0x20
 268:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26c:	872a                	mv	a4,a0
      *dst++ = *src++;
 26e:	0585                	addi	a1,a1,1
 270:	0705                	addi	a4,a4,1
 272:	fff5c683          	lbu	a3,-1(a1)
 276:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    while (n-- > 0)
 286:	fec05ce3          	blez	a2,27e <memmove+0x2a>
    dst += n;
 28a:	00c50733          	add	a4,a0,a2
    src += n;
 28e:	95b2                	add	a1,a1,a2
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2aa:	fef71ae3          	bne	a4,a5,29e <memmove+0x4a>
 2ae:	bfc1                	j	27e <memmove+0x2a>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b8:	c61d                	beqz	a2,2e6 <memcmp+0x36>
 2ba:	1602                	slli	a2,a2,0x20
 2bc:	9201                	srli	a2,a2,0x20
 2be:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00e79863          	bne	a5,a4,2da <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ce:	0505                	addi	a0,a0,1
    p2++;
 2d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d2:	fed518e3          	bne	a0,a3,2c2 <memcmp+0x12>
  }
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	a019                	j	2de <memcmp+0x2e>
      return *p1 - *p2;
 2da:	40e7853b          	subw	a0,a5,a4
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfdd                	j	2de <memcmp+0x2e>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	f63ff0ef          	jal	254 <memmove>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrk>:

char *
sbrk(int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 306:	4585                	li	a1,1
 308:	0cc000ef          	jal	3d4 <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <sbrklazy>:

char *
sbrklazy(int n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 31c:	4589                	li	a1,2
 31e:	0b6000ef          	jal	3d4 <sys_sbrk>
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 332:	040007b7          	lui	a5,0x4000
 336:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefed>
 338:	07b2                	slli	a5,a5,0xc
}
 33a:	4388                	lw	a0,0(a5)
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 344:	4885                	li	a7,1
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exit>:
.global exit
exit:
 li a7, SYS_exit
 34c:	4889                	li	a7,2
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <wait>:
.global wait
wait:
 li a7, SYS_wait
 354:	488d                	li	a7,3
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35c:	4891                	li	a7,4
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <read>:
.global read
read:
 li a7, SYS_read
 364:	4895                	li	a7,5
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <write>:
.global write
write:
 li a7, SYS_write
 36c:	48c1                	li	a7,16
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <close>:
.global close
close:
 li a7, SYS_close
 374:	48d5                	li	a7,21
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <kill>:
.global kill
kill:
 li a7, SYS_kill
 37c:	4899                	li	a7,6
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exec>:
.global exec
exec:
 li a7, SYS_exec
 384:	489d                	li	a7,7
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <open>:
.global open
open:
 li a7, SYS_open
 38c:	48bd                	li	a7,15
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 394:	48c5                	li	a7,17
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39c:	48c9                	li	a7,18
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a4:	48a1                	li	a7,8
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <link>:
.global link
link:
 li a7, SYS_link
 3ac:	48cd                	li	a7,19
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b4:	48d1                	li	a7,20
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3bc:	48a5                	li	a7,9
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c4:	48a9                	li	a7,10
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3cc:	48ad                	li	a7,11
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3d4:	48b1                	li	a7,12
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <pause>:
.global pause
pause:
 li a7, SYS_pause
 3dc:	48b5                	li	a7,13
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e4:	48b9                	li	a7,14
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <sync>:
.global sync
sync:
 li a7, SYS_sync
 3ec:	48d9                	li	a7,22
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3f4:	48f9                	li	a7,30
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 3fc:	48fd                	li	a7,31
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <send>:
.global send
send:
 li a7, SYS_send
 404:	02000893          	li	a7,32
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <recv>:
.global recv
recv:
 li a7, SYS_recv
 40e:	02100893          	li	a7,33
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 418:	02200893          	li	a7,34
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <vmprint>:
.global vmprint
vmprint:
 li a7, SYS_vmprint
 422:	02300893          	li	a7,35
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 42c:	02400893          	li	a7,36
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 436:	02500893          	li	a7,37
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 440:	02600893          	li	a7,38
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <ksupernpte>:
.global ksupernpte
ksupernpte:
 li a7, SYS_ksupernpte
 44a:	02700893          	li	a7,39
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 460:	4605                	li	a2,1
 462:	fef40593          	addi	a1,s0,-17
 466:	f07ff0ef          	jal	36c <write>
}
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6105                	addi	sp,sp,32
 470:	8082                	ret

0000000000000472 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 472:	715d                	addi	sp,sp,-80
 474:	e486                	sd	ra,72(sp)
 476:	e0a2                	sd	s0,64(sp)
 478:	f84a                	sd	s2,48(sp)
 47a:	f44e                	sd	s3,40(sp)
 47c:	0880                	addi	s0,sp,80
 47e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 480:	c6d1                	beqz	a3,50c <printint+0x9a>
 482:	0805d563          	bgez	a1,50c <printint+0x9a>
    neg = 1;
    x = -xx;
 486:	40b005b3          	neg	a1,a1
    neg = 1;
 48a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 48c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 490:	86ce                	mv	a3,s3
  i = 0;
 492:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 494:	00000817          	auipc	a6,0x0
 498:	53480813          	addi	a6,a6,1332 # 9c8 <digits>
 49c:	88ba                	mv	a7,a4
 49e:	0017051b          	addiw	a0,a4,1
 4a2:	872a                	mv	a4,a0
 4a4:	02c5f7b3          	remu	a5,a1,a2
 4a8:	97c2                	add	a5,a5,a6
 4aa:	0007c783          	lbu	a5,0(a5)
 4ae:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4b2:	87ae                	mv	a5,a1
 4b4:	02c5d5b3          	divu	a1,a1,a2
 4b8:	0685                	addi	a3,a3,1
 4ba:	fec7f1e3          	bgeu	a5,a2,49c <printint+0x2a>
  if (neg)
 4be:	00030c63          	beqz	t1,4d6 <printint+0x64>
    buf[i++] = '-';
 4c2:	fd050793          	addi	a5,a0,-48
 4c6:	00878533          	add	a0,a5,s0
 4ca:	02d00793          	li	a5,45
 4ce:	fef50423          	sb	a5,-24(a0)
 4d2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4d6:	02e05563          	blez	a4,500 <printint+0x8e>
 4da:	fc26                	sd	s1,56(sp)
 4dc:	377d                	addiw	a4,a4,-1
 4de:	00e984b3          	add	s1,s3,a4
 4e2:	19fd                	addi	s3,s3,-1
 4e4:	99ba                	add	s3,s3,a4
 4e6:	1702                	slli	a4,a4,0x20
 4e8:	9301                	srli	a4,a4,0x20
 4ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ee:	0004c583          	lbu	a1,0(s1)
 4f2:	854a                	mv	a0,s2
 4f4:	f61ff0ef          	jal	454 <putc>
  while (--i >= 0)
 4f8:	14fd                	addi	s1,s1,-1
 4fa:	ff349ae3          	bne	s1,s3,4ee <printint+0x7c>
 4fe:	74e2                	ld	s1,56(sp)
}
 500:	60a6                	ld	ra,72(sp)
 502:	6406                	ld	s0,64(sp)
 504:	7942                	ld	s2,48(sp)
 506:	79a2                	ld	s3,40(sp)
 508:	6161                	addi	sp,sp,80
 50a:	8082                	ret
  neg = 0;
 50c:	4301                	li	t1,0
 50e:	bfbd                	j	48c <printint+0x1a>

0000000000000510 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 510:	711d                	addi	sp,sp,-96
 512:	ec86                	sd	ra,88(sp)
 514:	e8a2                	sd	s0,80(sp)
 516:	e4a6                	sd	s1,72(sp)
 518:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 51a:	0005c483          	lbu	s1,0(a1)
 51e:	22048363          	beqz	s1,744 <vprintf+0x234>
 522:	e0ca                	sd	s2,64(sp)
 524:	fc4e                	sd	s3,56(sp)
 526:	f852                	sd	s4,48(sp)
 528:	f456                	sd	s5,40(sp)
 52a:	f05a                	sd	s6,32(sp)
 52c:	ec5e                	sd	s7,24(sp)
 52e:	e862                	sd	s8,16(sp)
 530:	8b2a                	mv	s6,a0
 532:	8a2e                	mv	s4,a1
 534:	8bb2                	mv	s7,a2
  state = 0;
 536:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 538:	4901                	li	s2,0
 53a:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 53c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 540:	06400c13          	li	s8,100
 544:	a00d                	j	566 <vprintf+0x56>
        putc(fd, c0);
 546:	85a6                	mv	a1,s1
 548:	855a                	mv	a0,s6
 54a:	f0bff0ef          	jal	454 <putc>
 54e:	a019                	j	554 <vprintf+0x44>
    } else if (state == '%') {
 550:	03598363          	beq	s3,s5,576 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 554:	0019079b          	addiw	a5,s2,1
 558:	893e                	mv	s2,a5
 55a:	873e                	mv	a4,a5
 55c:	97d2                	add	a5,a5,s4
 55e:	0007c483          	lbu	s1,0(a5)
 562:	1c048a63          	beqz	s1,736 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 566:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 56a:	fe0993e3          	bnez	s3,550 <vprintf+0x40>
      if (c0 == '%') {
 56e:	fd579ce3          	bne	a5,s5,546 <vprintf+0x36>
        state = '%';
 572:	89be                	mv	s3,a5
 574:	b7c5                	j	554 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 576:	00ea06b3          	add	a3,s4,a4
 57a:	0016c603          	lbu	a2,1(a3)
      if (c1)
 57e:	1c060863          	beqz	a2,74e <vprintf+0x23e>
      if (c0 == 'd') {
 582:	03878763          	beq	a5,s8,5b0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 586:	f9478693          	addi	a3,a5,-108
 58a:	0016b693          	seqz	a3,a3
 58e:	f9c60593          	addi	a1,a2,-100
 592:	e99d                	bnez	a1,5c8 <vprintf+0xb8>
 594:	ca95                	beqz	a3,5c8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	008b8493          	addi	s1,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000bb583          	ld	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	ecfff0ef          	jal	472 <printint>
        i += 1;
 5a8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b75d                	j	554 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8493          	addi	s1,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	eb5ff0ef          	jal	472 <printint>
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b779                	j	554 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 5c8:	9752                	add	a4,a4,s4
 5ca:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5ce:	f9460713          	addi	a4,a2,-108
 5d2:	00173713          	seqz	a4,a4
 5d6:	8f75                	and	a4,a4,a3
 5d8:	f9c58513          	addi	a0,a1,-100
 5dc:	18051363          	bnez	a0,762 <vprintf+0x252>
 5e0:	18070163          	beqz	a4,762 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e81ff0ef          	jal	472 <printint>
        i += 2;
 5f6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	8ba6                	mv	s7,s1
      state = 0;
 5fa:	4981                	li	s3,0
        i += 2;
 5fc:	bfa1                	j	554 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5fe:	008b8493          	addi	s1,s7,8
 602:	4681                	li	a3,0
 604:	4629                	li	a2,10
 606:	000be583          	lwu	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e67ff0ef          	jal	472 <printint>
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
 614:	b781                	j	554 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	008b8493          	addi	s1,s7,8
 61a:	4681                	li	a3,0
 61c:	4629                	li	a2,10
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e4fff0ef          	jal	472 <printint>
        i += 1;
 628:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b71d                	j	554 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	008b8493          	addi	s1,s7,8
 634:	4681                	li	a3,0
 636:	4629                	li	a2,10
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e35ff0ef          	jal	472 <printint>
        i += 2;
 642:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	b731                	j	554 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 64a:	008b8493          	addi	s1,s7,8
 64e:	4681                	li	a3,0
 650:	4641                	li	a2,16
 652:	000be583          	lwu	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	e1bff0ef          	jal	472 <printint>
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
 660:	bdd5                	j	554 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4681                	li	a3,0
 668:	4641                	li	a2,16
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e03ff0ef          	jal	472 <printint>
        i += 1;
 674:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
 67a:	bde9                	j	554 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	008b8493          	addi	s1,s7,8
 680:	4681                	li	a3,0
 682:	4641                	li	a2,16
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	de9ff0ef          	jal	472 <printint>
        i += 2;
 68e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	b5c1                	j	554 <vprintf+0x44>
 696:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 698:	008b8793          	addi	a5,s7,8
 69c:	8cbe                	mv	s9,a5
 69e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a2:	03000593          	li	a1,48
 6a6:	855a                	mv	a0,s6
 6a8:	dadff0ef          	jal	454 <putc>
  putc(fd, 'x');
 6ac:	07800593          	li	a1,120
 6b0:	855a                	mv	a0,s6
 6b2:	da3ff0ef          	jal	454 <putc>
 6b6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b8:	00000b97          	auipc	s7,0x0
 6bc:	310b8b93          	addi	s7,s7,784 # 9c8 <digits>
 6c0:	03c9d793          	srli	a5,s3,0x3c
 6c4:	97de                	add	a5,a5,s7
 6c6:	0007c583          	lbu	a1,0(a5)
 6ca:	855a                	mv	a0,s6
 6cc:	d89ff0ef          	jal	454 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d0:	0992                	slli	s3,s3,0x4
 6d2:	34fd                	addiw	s1,s1,-1
 6d4:	f4f5                	bnez	s1,6c0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6d6:	8be6                	mv	s7,s9
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	6ca2                	ld	s9,8(sp)
 6dc:	bda5                	j	554 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6de:	008b8493          	addi	s1,s7,8
 6e2:	000bc583          	lbu	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	d6dff0ef          	jal	454 <putc>
 6ec:	8ba6                	mv	s7,s1
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b595                	j	554 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6f2:	008b8993          	addi	s3,s7,8
 6f6:	000bb483          	ld	s1,0(s7)
 6fa:	cc91                	beqz	s1,716 <vprintf+0x206>
        for (; *s; s++)
 6fc:	0004c583          	lbu	a1,0(s1)
 700:	c985                	beqz	a1,730 <vprintf+0x220>
          putc(fd, *s);
 702:	855a                	mv	a0,s6
 704:	d51ff0ef          	jal	454 <putc>
        for (; *s; s++)
 708:	0485                	addi	s1,s1,1
 70a:	0004c583          	lbu	a1,0(s1)
 70e:	f9f5                	bnez	a1,702 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 710:	8bce                	mv	s7,s3
      state = 0;
 712:	4981                	li	s3,0
 714:	b581                	j	554 <vprintf+0x44>
          s = "(null)";
 716:	00000497          	auipc	s1,0x0
 71a:	2aa48493          	addi	s1,s1,682 # 9c0 <malloc+0x10e>
        for (; *s; s++)
 71e:	02800593          	li	a1,40
 722:	b7c5                	j	702 <vprintf+0x1f2>
        putc(fd, '%');
 724:	85be                	mv	a1,a5
 726:	855a                	mv	a0,s6
 728:	d2dff0ef          	jal	454 <putc>
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b51d                	j	554 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 730:	8bce                	mv	s7,s3
      state = 0;
 732:	4981                	li	s3,0
 734:	b505                	j	554 <vprintf+0x44>
 736:	6906                	ld	s2,64(sp)
 738:	79e2                	ld	s3,56(sp)
 73a:	7a42                	ld	s4,48(sp)
 73c:	7aa2                	ld	s5,40(sp)
 73e:	7b02                	ld	s6,32(sp)
 740:	6be2                	ld	s7,24(sp)
 742:	6c42                	ld	s8,16(sp)
    }
  }
}
 744:	60e6                	ld	ra,88(sp)
 746:	6446                	ld	s0,80(sp)
 748:	64a6                	ld	s1,72(sp)
 74a:	6125                	addi	sp,sp,96
 74c:	8082                	ret
      if (c0 == 'd') {
 74e:	06400713          	li	a4,100
 752:	e4e78fe3          	beq	a5,a4,5b0 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 756:	f9478693          	addi	a3,a5,-108
 75a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 75e:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 760:	4701                	li	a4,0
      } else if (c0 == 'u') {
 762:	07500513          	li	a0,117
 766:	e8a78ce3          	beq	a5,a0,5fe <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 76a:	f8b60513          	addi	a0,a2,-117
 76e:	e119                	bnez	a0,774 <vprintf+0x264>
 770:	ea0693e3          	bnez	a3,616 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 774:	f8b58513          	addi	a0,a1,-117
 778:	e119                	bnez	a0,77e <vprintf+0x26e>
 77a:	ea071be3          	bnez	a4,630 <vprintf+0x120>
      } else if (c0 == 'x') {
 77e:	07800513          	li	a0,120
 782:	eca784e3          	beq	a5,a0,64a <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 786:	f8860613          	addi	a2,a2,-120
 78a:	e219                	bnez	a2,790 <vprintf+0x280>
 78c:	ec069be3          	bnez	a3,662 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 790:	f8858593          	addi	a1,a1,-120
 794:	e199                	bnez	a1,79a <vprintf+0x28a>
 796:	ee0713e3          	bnez	a4,67c <vprintf+0x16c>
      } else if (c0 == 'p') {
 79a:	07000713          	li	a4,112
 79e:	eee78ce3          	beq	a5,a4,696 <vprintf+0x186>
      } else if (c0 == 'c') {
 7a2:	06300713          	li	a4,99
 7a6:	f2e78ce3          	beq	a5,a4,6de <vprintf+0x1ce>
      } else if (c0 == 's') {
 7aa:	07300713          	li	a4,115
 7ae:	f4e782e3          	beq	a5,a4,6f2 <vprintf+0x1e2>
      } else if (c0 == '%') {
 7b2:	02500713          	li	a4,37
 7b6:	f6e787e3          	beq	a5,a4,724 <vprintf+0x214>
        putc(fd, '%');
 7ba:	02500593          	li	a1,37
 7be:	855a                	mv	a0,s6
 7c0:	c95ff0ef          	jal	454 <putc>
        putc(fd, c0);
 7c4:	85a6                	mv	a1,s1
 7c6:	855a                	mv	a0,s6
 7c8:	c8dff0ef          	jal	454 <putc>
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b359                	j	554 <vprintf+0x44>

00000000000007d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d0:	715d                	addi	sp,sp,-80
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e010                	sd	a2,0(s0)
 7da:	e414                	sd	a3,8(s0)
 7dc:	e818                	sd	a4,16(s0)
 7de:	ec1c                	sd	a5,24(s0)
 7e0:	03043023          	sd	a6,32(s0)
 7e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	8622                	mv	a2,s0
 7ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ee:	d23ff0ef          	jal	510 <vprintf>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6161                	addi	sp,sp,80
 7f8:	8082                	ret

00000000000007fa <printf>:

void
printf(const char *fmt, ...)
{
 7fa:	711d                	addi	sp,sp,-96
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e40c                	sd	a1,8(s0)
 804:	e810                	sd	a2,16(s0)
 806:	ec14                	sd	a3,24(s0)
 808:	f018                	sd	a4,32(s0)
 80a:	f41c                	sd	a5,40(s0)
 80c:	03043823          	sd	a6,48(s0)
 810:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	00840613          	addi	a2,s0,8
 818:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81c:	85aa                	mv	a1,a0
 81e:	4505                	li	a0,1
 820:	cf1ff0ef          	jal	510 <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6125                	addi	sp,sp,96
 82a:	8082                	ret

000000000000082c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82c:	1141                	addi	sp,sp,-16
 82e:	e406                	sd	ra,8(sp)
 830:	e022                	sd	s0,0(sp)
 832:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 834:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 838:	00000797          	auipc	a5,0x0
 83c:	7c87b783          	ld	a5,1992(a5) # 1000 <freep>
 840:	a039                	j	84e <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 842:	6398                	ld	a4,0(a5)
 844:	00e7e463          	bltu	a5,a4,84c <free+0x20>
 848:	00e6ea63          	bltu	a3,a4,85c <free+0x30>
{
 84c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84e:	fed7fae3          	bgeu	a5,a3,842 <free+0x16>
 852:	6398                	ld	a4,0(a5)
 854:	00e6e463          	bltu	a3,a4,85c <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 858:	fee7eae3          	bltu	a5,a4,84c <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 85c:	ff852583          	lw	a1,-8(a0)
 860:	6390                	ld	a2,0(a5)
 862:	02059813          	slli	a6,a1,0x20
 866:	01c85713          	srli	a4,a6,0x1c
 86a:	9736                	add	a4,a4,a3
 86c:	02e60563          	beq	a2,a4,896 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 870:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 874:	4790                	lw	a2,8(a5)
 876:	02061593          	slli	a1,a2,0x20
 87a:	01c5d713          	srli	a4,a1,0x1c
 87e:	973e                	add	a4,a4,a5
 880:	02e68263          	beq	a3,a4,8a4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 884:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 886:	00000717          	auipc	a4,0x0
 88a:	76f73d23          	sd	a5,1914(a4) # 1000 <freep>
}
 88e:	60a2                	ld	ra,8(sp)
 890:	6402                	ld	s0,0(sp)
 892:	0141                	addi	sp,sp,16
 894:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 896:	4618                	lw	a4,8(a2)
 898:	9f2d                	addw	a4,a4,a1
 89a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	6310                	ld	a2,0(a4)
 8a2:	b7f9                	j	870 <free+0x44>
    p->s.size += bp->s.size;
 8a4:	ff852703          	lw	a4,-8(a0)
 8a8:	9f31                	addw	a4,a4,a2
 8aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ac:	ff053683          	ld	a3,-16(a0)
 8b0:	bfd1                	j	884 <free+0x58>

00000000000008b2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8b2:	7139                	addi	sp,sp,-64
 8b4:	fc06                	sd	ra,56(sp)
 8b6:	f822                	sd	s0,48(sp)
 8b8:	f04a                	sd	s2,32(sp)
 8ba:	ec4e                	sd	s3,24(sp)
 8bc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8be:	02051993          	slli	s3,a0,0x20
 8c2:	0209d993          	srli	s3,s3,0x20
 8c6:	09bd                	addi	s3,s3,15
 8c8:	0049d993          	srli	s3,s3,0x4
 8cc:	2985                	addiw	s3,s3,1
 8ce:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8d0:	00000517          	auipc	a0,0x0
 8d4:	73053503          	ld	a0,1840(a0) # 1000 <freep>
 8d8:	c905                	beqz	a0,908 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8da:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8dc:	4798                	lw	a4,8(a5)
 8de:	09377663          	bgeu	a4,s3,96a <malloc+0xb8>
 8e2:	f426                	sd	s1,40(sp)
 8e4:	e852                	sd	s4,16(sp)
 8e6:	e456                	sd	s5,8(sp)
 8e8:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8ea:	8a4e                	mv	s4,s3
 8ec:	6705                	lui	a4,0x1
 8ee:	00e9f363          	bgeu	s3,a4,8f4 <malloc+0x42>
 8f2:	6a05                	lui	s4,0x1
 8f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8fc:	00000497          	auipc	s1,0x0
 900:	70448493          	addi	s1,s1,1796 # 1000 <freep>
  if (p == SBRK_ERROR)
 904:	5afd                	li	s5,-1
 906:	a83d                	j	944 <malloc+0x92>
 908:	f426                	sd	s1,40(sp)
 90a:	e852                	sd	s4,16(sp)
 90c:	e456                	sd	s5,8(sp)
 90e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 910:	00000797          	auipc	a5,0x0
 914:	70078793          	addi	a5,a5,1792 # 1010 <base>
 918:	00000717          	auipc	a4,0x0
 91c:	6ef73423          	sd	a5,1768(a4) # 1000 <freep>
 920:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 922:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 926:	b7d1                	j	8ea <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 928:	6398                	ld	a4,0(a5)
 92a:	e118                	sd	a4,0(a0)
 92c:	a899                	j	982 <malloc+0xd0>
  hp->s.size = nu;
 92e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 932:	0541                	addi	a0,a0,16
 934:	ef9ff0ef          	jal	82c <free>
  return freep;
 938:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 93a:	c125                	beqz	a0,99a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 93c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 93e:	4798                	lw	a4,8(a5)
 940:	03277163          	bgeu	a4,s2,962 <malloc+0xb0>
    if (p == freep)
 944:	6098                	ld	a4,0(s1)
 946:	853e                	mv	a0,a5
 948:	fef71ae3          	bne	a4,a5,93c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 94c:	8552                	mv	a0,s4
 94e:	9b1ff0ef          	jal	2fe <sbrk>
  if (p == SBRK_ERROR)
 952:	fd551ee3          	bne	a0,s5,92e <malloc+0x7c>
        return 0;
 956:	4501                	li	a0,0
 958:	74a2                	ld	s1,40(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	a03d                	j	98e <malloc+0xdc>
 962:	74a2                	ld	s1,40(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 96a:	fae90fe3          	beq	s2,a4,928 <malloc+0x76>
        p->s.size -= nunits;
 96e:	4137073b          	subw	a4,a4,s3
 972:	c798                	sw	a4,8(a5)
        p += p->s.size;
 974:	02071693          	slli	a3,a4,0x20
 978:	01c6d713          	srli	a4,a3,0x1c
 97c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 982:	00000717          	auipc	a4,0x0
 986:	66a73f23          	sd	a0,1662(a4) # 1000 <freep>
      return (void *)(p + 1);
 98a:	01078513          	addi	a0,a5,16
  }
}
 98e:	70e2                	ld	ra,56(sp)
 990:	7442                	ld	s0,48(sp)
 992:	7902                	ld	s2,32(sp)
 994:	69e2                	ld	s3,24(sp)
 996:	6121                	addi	sp,sp,64
 998:	8082                	ret
 99a:	74a2                	ld	s1,40(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
 9a2:	b7f5                	j	98e <malloc+0xdc>
