
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	ff890913          	addi	s2,s2,-8 # 1010 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	3b6000ef          	jal	3de <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	3ae000ef          	jal	3e6 <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	9e058593          	addi	a1,a1,-1568 # a20 <malloc+0xf4>
  48:	4509                	li	a0,2
  4a:	001000ef          	jal	84a <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	376000ef          	jal	3c6 <exit>
    }
  }
  if (n < 0) {
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	9ce58593          	addi	a1,a1,-1586 # a38 <malloc+0x10c>
  72:	4509                	li	a0,2
  74:	7d6000ef          	jal	84a <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	34c000ef          	jal	3c6 <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	35a000ef          	jal	406 <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	332000ef          	jal	3ee <close>
  for (i = 1; i < argc; i++) {
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2fe000ef          	jal	3c6 <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2ec000ef          	jal	3c6 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	96e58593          	addi	a1,a1,-1682 # a50 <malloc+0x124>
  ea:	4509                	li	a0,2
  ec:	75e000ef          	jal	84a <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2d4000ef          	jal	3c6 <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fe:	f81ff0ef          	jal	7e <main>
  exit(r);
 102:	2c4000ef          	jal	3c6 <exit>

0000000000000106 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0xa>
    ;
  return os;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x20>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x20>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x28>
 164:	00150793          	addi	a5,a0,1
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x12>
 172:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for (n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfdd                	j	176 <strlen+0x20>

0000000000000182 <memset>:

void *
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 18a:	ca19                	beqz	a2,1a0 <memset+0x1e>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x14>
  }
  return dst;
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char *
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e406                	sd	ra,8(sp)
 1ac:	e022                	sd	s0,0(sp)
 1ae:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf81                	beqz	a5,1cc <strchr+0x24>
    if (*s == c)
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1c>
  for (; *s; s++)
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xe>
      return (char *)s;
  return 0;
 1c2:	4501                	li	a0,0
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  return 0;
 1cc:	4501                	li	a0,0
 1ce:	bfdd                	j	1c4 <strchr+0x1c>

00000000000001d0 <gets>:

char *
gets(char *buf, int max)
{
 1d0:	711d                	addi	sp,sp,-96
 1d2:	ec86                	sd	ra,88(sp)
 1d4:	e8a2                	sd	s0,80(sp)
 1d6:	e4a6                	sd	s1,72(sp)
 1d8:	e0ca                	sd	s2,64(sp)
 1da:	fc4e                	sd	s3,56(sp)
 1dc:	f852                	sd	s4,48(sp)
 1de:	f456                	sd	s5,40(sp)
 1e0:	f05a                	sd	s6,32(sp)
 1e2:	ec5e                	sd	s7,24(sp)
 1e4:	e862                	sd	s8,16(sp)
 1e6:	1080                	addi	s0,sp,96
 1e8:	8baa                	mv	s7,a0
 1ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1ec:	892a                	mv	s2,a0
 1ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f0:	faf40b13          	addi	s6,s0,-81
 1f4:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1f6:	8c26                	mv	s8,s1
 1f8:	0014899b          	addiw	s3,s1,1
 1fc:	84ce                	mv	s1,s3
 1fe:	0349d463          	bge	s3,s4,226 <gets+0x56>
    cc = read(0, &c, 1);
 202:	8656                	mv	a2,s5
 204:	85da                	mv	a1,s6
 206:	4501                	li	a0,0
 208:	1d6000ef          	jal	3de <read>
    if (cc < 1)
 20c:	00a05d63          	blez	a0,226 <gets+0x56>
      break;
    buf[i++] = c;
 210:	faf44783          	lbu	a5,-81(s0)
 214:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 218:	0905                	addi	s2,s2,1
 21a:	ff678713          	addi	a4,a5,-10
 21e:	c319                	beqz	a4,224 <gets+0x54>
 220:	17cd                	addi	a5,a5,-13
 222:	fbf1                	bnez	a5,1f6 <gets+0x26>
    buf[i++] = c;
 224:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 226:	9c5e                	add	s8,s8,s7
 228:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22c:	855e                	mv	a0,s7
 22e:	60e6                	ld	ra,88(sp)
 230:	6446                	ld	s0,80(sp)
 232:	64a6                	ld	s1,72(sp)
 234:	6906                	ld	s2,64(sp)
 236:	79e2                	ld	s3,56(sp)
 238:	7a42                	ld	s4,48(sp)
 23a:	7aa2                	ld	s5,40(sp)
 23c:	7b02                	ld	s6,32(sp)
 23e:	6be2                	ld	s7,24(sp)
 240:	6c42                	ld	s8,16(sp)
 242:	6125                	addi	sp,sp,96
 244:	8082                	ret

0000000000000246 <stat>:

int
stat(const char *n, struct stat *st)
{
 246:	1101                	addi	sp,sp,-32
 248:	ec06                	sd	ra,24(sp)
 24a:	e822                	sd	s0,16(sp)
 24c:	e04a                	sd	s2,0(sp)
 24e:	1000                	addi	s0,sp,32
 250:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	4581                	li	a1,0
 254:	1b2000ef          	jal	406 <open>
  if (fd < 0)
 258:	02054263          	bltz	a0,27c <stat+0x36>
 25c:	e426                	sd	s1,8(sp)
 25e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 260:	85ca                	mv	a1,s2
 262:	1bc000ef          	jal	41e <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	184000ef          	jal	3ee <close>
  return r;
 26e:	64a2                	ld	s1,8(sp)
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	6902                	ld	s2,0(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    return -1;
 27c:	57fd                	li	a5,-1
 27e:	893e                	mv	s2,a5
 280:	bfc5                	j	270 <stat+0x2a>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66963          	bltu	a2,a5,2ca <atoi+0x48>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1e>
  return n;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <atoi+0x40>

00000000000002ce <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d6:	02b57563          	bgeu	a0,a1,300 <memmove+0x32>
    while (n-- > 0)
 2da:	00c05f63          	blez	a2,2f8 <memmove+0x2a>
 2de:	1602                	slli	a2,a2,0x20
 2e0:	9201                	srli	a2,a2,0x20
 2e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0705                	addi	a4,a4,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
    while (n-- > 0)
 300:	fec05ce3          	blez	a2,2f8 <memmove+0x2a>
    dst += n;
 304:	00c50733          	add	a4,a0,a2
    src += n;
 308:	95b2                	add	a1,a1,a2
 30a:	fff6079b          	addiw	a5,a2,-1
 30e:	1782                	slli	a5,a5,0x20
 310:	9381                	srli	a5,a5,0x20
 312:	fff7c793          	not	a5,a5
 316:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 318:	15fd                	addi	a1,a1,-1
 31a:	177d                	addi	a4,a4,-1
 31c:	0005c683          	lbu	a3,0(a1)
 320:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 324:	fef71ae3          	bne	a4,a5,318 <memmove+0x4a>
 328:	bfc1                	j	2f8 <memmove+0x2a>

000000000000032a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 332:	c61d                	beqz	a2,360 <memcmp+0x36>
 334:	1602                	slli	a2,a2,0x20
 336:	9201                	srli	a2,a2,0x20
 338:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 33c:	00054783          	lbu	a5,0(a0)
 340:	0005c703          	lbu	a4,0(a1)
 344:	00e79863          	bne	a5,a4,354 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 348:	0505                	addi	a0,a0,1
    p2++;
 34a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34c:	fed518e3          	bne	a0,a3,33c <memcmp+0x12>
  }
  return 0;
 350:	4501                	li	a0,0
 352:	a019                	j	358 <memcmp+0x2e>
      return *p1 - *p2;
 354:	40e7853b          	subw	a0,a5,a4
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  return 0;
 360:	4501                	li	a0,0
 362:	bfdd                	j	358 <memcmp+0x2e>

0000000000000364 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36c:	f63ff0ef          	jal	2ce <memmove>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <sbrk>:

char *
sbrk(int n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 380:	4585                	li	a1,1
 382:	0cc000ef          	jal	44e <sys_sbrk>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <sbrklazy>:

char *
sbrklazy(int n)
{
 38e:	1141                	addi	sp,sp,-16
 390:	e406                	sd	ra,8(sp)
 392:	e022                	sd	s0,0(sp)
 394:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 396:	4589                	li	a1,2
 398:	0b6000ef          	jal	44e <sys_sbrk>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e406                	sd	ra,8(sp)
 3a8:	e022                	sd	s0,0(sp)
 3aa:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 3ac:	040007b7          	lui	a5,0x4000
 3b0:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffeded>
 3b2:	07b2                	slli	a5,a5,0xc
}
 3b4:	4388                	lw	a0,0(a5)
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3be:	4885                	li	a7,1
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c6:	4889                	li	a7,2
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ce:	488d                	li	a7,3
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d6:	4891                	li	a7,4
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <read>:
.global read
read:
 li a7, SYS_read
 3de:	4895                	li	a7,5
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <write>:
.global write
write:
 li a7, SYS_write
 3e6:	48c1                	li	a7,16
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <close>:
.global close
close:
 li a7, SYS_close
 3ee:	48d5                	li	a7,21
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f6:	4899                	li	a7,6
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fe:	489d                	li	a7,7
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <open>:
.global open
open:
 li a7, SYS_open
 406:	48bd                	li	a7,15
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40e:	48c5                	li	a7,17
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 416:	48c9                	li	a7,18
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41e:	48a1                	li	a7,8
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <link>:
.global link
link:
 li a7, SYS_link
 426:	48cd                	li	a7,19
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42e:	48d1                	li	a7,20
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 436:	48a5                	li	a7,9
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <dup>:
.global dup
dup:
 li a7, SYS_dup
 43e:	48a9                	li	a7,10
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 446:	48ad                	li	a7,11
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 44e:	48b1                	li	a7,12
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <pause>:
.global pause
pause:
 li a7, SYS_pause
 456:	48b5                	li	a7,13
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45e:	48b9                	li	a7,14
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sync>:
.global sync
sync:
 li a7, SYS_sync
 466:	48d9                	li	a7,22
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <bind>:
.global bind
bind:
 li a7, SYS_bind
 46e:	48f9                	li	a7,30
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 476:	48fd                	li	a7,31
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <send>:
.global send
send:
 li a7, SYS_send
 47e:	02000893          	li	a7,32
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <recv>:
.global recv
recv:
 li a7, SYS_recv
 488:	02100893          	li	a7,33
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 492:	02200893          	li	a7,34
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <vmprint>:
.global vmprint
vmprint:
 li a7, SYS_vmprint
 49c:	02300893          	li	a7,35
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 4a6:	02400893          	li	a7,36
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 4b0:	02500893          	li	a7,37
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4ba:	02600893          	li	a7,38
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <ksupernpte>:
.global ksupernpte
ksupernpte:
 li a7, SYS_ksupernpte
 4c4:	02700893          	li	a7,39
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ce:	1101                	addi	sp,sp,-32
 4d0:	ec06                	sd	ra,24(sp)
 4d2:	e822                	sd	s0,16(sp)
 4d4:	1000                	addi	s0,sp,32
 4d6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4da:	4605                	li	a2,1
 4dc:	fef40593          	addi	a1,s0,-17
 4e0:	f07ff0ef          	jal	3e6 <write>
}
 4e4:	60e2                	ld	ra,24(sp)
 4e6:	6442                	ld	s0,16(sp)
 4e8:	6105                	addi	sp,sp,32
 4ea:	8082                	ret

00000000000004ec <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4ec:	715d                	addi	sp,sp,-80
 4ee:	e486                	sd	ra,72(sp)
 4f0:	e0a2                	sd	s0,64(sp)
 4f2:	f84a                	sd	s2,48(sp)
 4f4:	f44e                	sd	s3,40(sp)
 4f6:	0880                	addi	s0,sp,80
 4f8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4fa:	c6d1                	beqz	a3,586 <printint+0x9a>
 4fc:	0805d563          	bgez	a1,586 <printint+0x9a>
    neg = 1;
    x = -xx;
 500:	40b005b3          	neg	a1,a1
    neg = 1;
 504:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 506:	fb840993          	addi	s3,s0,-72
  neg = 0;
 50a:	86ce                	mv	a3,s3
  i = 0;
 50c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 50e:	00000817          	auipc	a6,0x0
 512:	56280813          	addi	a6,a6,1378 # a70 <digits>
 516:	88ba                	mv	a7,a4
 518:	0017051b          	addiw	a0,a4,1
 51c:	872a                	mv	a4,a0
 51e:	02c5f7b3          	remu	a5,a1,a2
 522:	97c2                	add	a5,a5,a6
 524:	0007c783          	lbu	a5,0(a5)
 528:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 52c:	87ae                	mv	a5,a1
 52e:	02c5d5b3          	divu	a1,a1,a2
 532:	0685                	addi	a3,a3,1
 534:	fec7f1e3          	bgeu	a5,a2,516 <printint+0x2a>
  if (neg)
 538:	00030c63          	beqz	t1,550 <printint+0x64>
    buf[i++] = '-';
 53c:	fd050793          	addi	a5,a0,-48
 540:	00878533          	add	a0,a5,s0
 544:	02d00793          	li	a5,45
 548:	fef50423          	sb	a5,-24(a0)
 54c:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 550:	02e05563          	blez	a4,57a <printint+0x8e>
 554:	fc26                	sd	s1,56(sp)
 556:	377d                	addiw	a4,a4,-1
 558:	00e984b3          	add	s1,s3,a4
 55c:	19fd                	addi	s3,s3,-1
 55e:	99ba                	add	s3,s3,a4
 560:	1702                	slli	a4,a4,0x20
 562:	9301                	srli	a4,a4,0x20
 564:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 568:	0004c583          	lbu	a1,0(s1)
 56c:	854a                	mv	a0,s2
 56e:	f61ff0ef          	jal	4ce <putc>
  while (--i >= 0)
 572:	14fd                	addi	s1,s1,-1
 574:	ff349ae3          	bne	s1,s3,568 <printint+0x7c>
 578:	74e2                	ld	s1,56(sp)
}
 57a:	60a6                	ld	ra,72(sp)
 57c:	6406                	ld	s0,64(sp)
 57e:	7942                	ld	s2,48(sp)
 580:	79a2                	ld	s3,40(sp)
 582:	6161                	addi	sp,sp,80
 584:	8082                	ret
  neg = 0;
 586:	4301                	li	t1,0
 588:	bfbd                	j	506 <printint+0x1a>

000000000000058a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58a:	711d                	addi	sp,sp,-96
 58c:	ec86                	sd	ra,88(sp)
 58e:	e8a2                	sd	s0,80(sp)
 590:	e4a6                	sd	s1,72(sp)
 592:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 594:	0005c483          	lbu	s1,0(a1)
 598:	22048363          	beqz	s1,7be <vprintf+0x234>
 59c:	e0ca                	sd	s2,64(sp)
 59e:	fc4e                	sd	s3,56(sp)
 5a0:	f852                	sd	s4,48(sp)
 5a2:	f456                	sd	s5,40(sp)
 5a4:	f05a                	sd	s6,32(sp)
 5a6:	ec5e                	sd	s7,24(sp)
 5a8:	e862                	sd	s8,16(sp)
 5aa:	8b2a                	mv	s6,a0
 5ac:	8a2e                	mv	s4,a1
 5ae:	8bb2                	mv	s7,a2
  state = 0;
 5b0:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5b2:	4901                	li	s2,0
 5b4:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 5b6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 5ba:	06400c13          	li	s8,100
 5be:	a00d                	j	5e0 <vprintf+0x56>
        putc(fd, c0);
 5c0:	85a6                	mv	a1,s1
 5c2:	855a                	mv	a0,s6
 5c4:	f0bff0ef          	jal	4ce <putc>
 5c8:	a019                	j	5ce <vprintf+0x44>
    } else if (state == '%') {
 5ca:	03598363          	beq	s3,s5,5f0 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 5ce:	0019079b          	addiw	a5,s2,1
 5d2:	893e                	mv	s2,a5
 5d4:	873e                	mv	a4,a5
 5d6:	97d2                	add	a5,a5,s4
 5d8:	0007c483          	lbu	s1,0(a5)
 5dc:	1c048a63          	beqz	s1,7b0 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5e0:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5e4:	fe0993e3          	bnez	s3,5ca <vprintf+0x40>
      if (c0 == '%') {
 5e8:	fd579ce3          	bne	a5,s5,5c0 <vprintf+0x36>
        state = '%';
 5ec:	89be                	mv	s3,a5
 5ee:	b7c5                	j	5ce <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 5f0:	00ea06b3          	add	a3,s4,a4
 5f4:	0016c603          	lbu	a2,1(a3)
      if (c1)
 5f8:	1c060863          	beqz	a2,7c8 <vprintf+0x23e>
      if (c0 == 'd') {
 5fc:	03878763          	beq	a5,s8,62a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 600:	f9478693          	addi	a3,a5,-108
 604:	0016b693          	seqz	a3,a3
 608:	f9c60593          	addi	a1,a2,-100
 60c:	e99d                	bnez	a1,642 <vprintf+0xb8>
 60e:	ca95                	beqz	a3,642 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 610:	008b8493          	addi	s1,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	ecfff0ef          	jal	4ec <printint>
        i += 1;
 622:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 626:	4981                	li	s3,0
 628:	b75d                	j	5ce <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	eb5ff0ef          	jal	4ec <printint>
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
 640:	b779                	j	5ce <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 642:	9752                	add	a4,a4,s4
 644:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 648:	f9460713          	addi	a4,a2,-108
 64c:	00173713          	seqz	a4,a4
 650:	8f75                	and	a4,a4,a3
 652:	f9c58513          	addi	a0,a1,-100
 656:	18051363          	bnez	a0,7dc <vprintf+0x252>
 65a:	18070163          	beqz	a4,7dc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e81ff0ef          	jal	4ec <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	bfa1                	j	5ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000be583          	lwu	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	e67ff0ef          	jal	4ec <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b781                	j	5ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4629                	li	a2,10
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	e4fff0ef          	jal	4ec <printint>
        i += 1;
 6a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b71d                	j	5ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e35ff0ef          	jal	4ec <printint>
        i += 2;
 6bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
        i += 2;
 6c2:	b731                	j	5ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000be583          	lwu	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	e1bff0ef          	jal	4ec <printint>
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bdd5                	j	5ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4641                	li	a2,16
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	e03ff0ef          	jal	4ec <printint>
        i += 1;
 6ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bde9                	j	5ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4641                	li	a2,16
 6fe:	000bb583          	ld	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	de9ff0ef          	jal	4ec <printint>
        i += 2;
 708:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
        i += 2;
 70e:	b5c1                	j	5ce <vprintf+0x44>
 710:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 712:	008b8793          	addi	a5,s7,8
 716:	8cbe                	mv	s9,a5
 718:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 71c:	03000593          	li	a1,48
 720:	855a                	mv	a0,s6
 722:	dadff0ef          	jal	4ce <putc>
  putc(fd, 'x');
 726:	07800593          	li	a1,120
 72a:	855a                	mv	a0,s6
 72c:	da3ff0ef          	jal	4ce <putc>
 730:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 732:	00000b97          	auipc	s7,0x0
 736:	33eb8b93          	addi	s7,s7,830 # a70 <digits>
 73a:	03c9d793          	srli	a5,s3,0x3c
 73e:	97de                	add	a5,a5,s7
 740:	0007c583          	lbu	a1,0(a5)
 744:	855a                	mv	a0,s6
 746:	d89ff0ef          	jal	4ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74a:	0992                	slli	s3,s3,0x4
 74c:	34fd                	addiw	s1,s1,-1
 74e:	f4f5                	bnez	s1,73a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 750:	8be6                	mv	s7,s9
      state = 0;
 752:	4981                	li	s3,0
 754:	6ca2                	ld	s9,8(sp)
 756:	bda5                	j	5ce <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 758:	008b8493          	addi	s1,s7,8
 75c:	000bc583          	lbu	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	d6dff0ef          	jal	4ce <putc>
 766:	8ba6                	mv	s7,s1
      state = 0;
 768:	4981                	li	s3,0
 76a:	b595                	j	5ce <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 76c:	008b8993          	addi	s3,s7,8
 770:	000bb483          	ld	s1,0(s7)
 774:	cc91                	beqz	s1,790 <vprintf+0x206>
        for (; *s; s++)
 776:	0004c583          	lbu	a1,0(s1)
 77a:	c985                	beqz	a1,7aa <vprintf+0x220>
          putc(fd, *s);
 77c:	855a                	mv	a0,s6
 77e:	d51ff0ef          	jal	4ce <putc>
        for (; *s; s++)
 782:	0485                	addi	s1,s1,1
 784:	0004c583          	lbu	a1,0(s1)
 788:	f9f5                	bnez	a1,77c <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 78a:	8bce                	mv	s7,s3
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b581                	j	5ce <vprintf+0x44>
          s = "(null)";
 790:	00000497          	auipc	s1,0x0
 794:	2d848493          	addi	s1,s1,728 # a68 <malloc+0x13c>
        for (; *s; s++)
 798:	02800593          	li	a1,40
 79c:	b7c5                	j	77c <vprintf+0x1f2>
        putc(fd, '%');
 79e:	85be                	mv	a1,a5
 7a0:	855a                	mv	a0,s6
 7a2:	d2dff0ef          	jal	4ce <putc>
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b51d                	j	5ce <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 7aa:	8bce                	mv	s7,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b505                	j	5ce <vprintf+0x44>
 7b0:	6906                	ld	s2,64(sp)
 7b2:	79e2                	ld	s3,56(sp)
 7b4:	7a42                	ld	s4,48(sp)
 7b6:	7aa2                	ld	s5,40(sp)
 7b8:	7b02                	ld	s6,32(sp)
 7ba:	6be2                	ld	s7,24(sp)
 7bc:	6c42                	ld	s8,16(sp)
    }
  }
}
 7be:	60e6                	ld	ra,88(sp)
 7c0:	6446                	ld	s0,80(sp)
 7c2:	64a6                	ld	s1,72(sp)
 7c4:	6125                	addi	sp,sp,96
 7c6:	8082                	ret
      if (c0 == 'd') {
 7c8:	06400713          	li	a4,100
 7cc:	e4e78fe3          	beq	a5,a4,62a <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 7d0:	f9478693          	addi	a3,a5,-108
 7d4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7d8:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7da:	4701                	li	a4,0
      } else if (c0 == 'u') {
 7dc:	07500513          	li	a0,117
 7e0:	e8a78ce3          	beq	a5,a0,678 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 7e4:	f8b60513          	addi	a0,a2,-117
 7e8:	e119                	bnez	a0,7ee <vprintf+0x264>
 7ea:	ea0693e3          	bnez	a3,690 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 7ee:	f8b58513          	addi	a0,a1,-117
 7f2:	e119                	bnez	a0,7f8 <vprintf+0x26e>
 7f4:	ea071be3          	bnez	a4,6aa <vprintf+0x120>
      } else if (c0 == 'x') {
 7f8:	07800513          	li	a0,120
 7fc:	eca784e3          	beq	a5,a0,6c4 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 800:	f8860613          	addi	a2,a2,-120
 804:	e219                	bnez	a2,80a <vprintf+0x280>
 806:	ec069be3          	bnez	a3,6dc <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 80a:	f8858593          	addi	a1,a1,-120
 80e:	e199                	bnez	a1,814 <vprintf+0x28a>
 810:	ee0713e3          	bnez	a4,6f6 <vprintf+0x16c>
      } else if (c0 == 'p') {
 814:	07000713          	li	a4,112
 818:	eee78ce3          	beq	a5,a4,710 <vprintf+0x186>
      } else if (c0 == 'c') {
 81c:	06300713          	li	a4,99
 820:	f2e78ce3          	beq	a5,a4,758 <vprintf+0x1ce>
      } else if (c0 == 's') {
 824:	07300713          	li	a4,115
 828:	f4e782e3          	beq	a5,a4,76c <vprintf+0x1e2>
      } else if (c0 == '%') {
 82c:	02500713          	li	a4,37
 830:	f6e787e3          	beq	a5,a4,79e <vprintf+0x214>
        putc(fd, '%');
 834:	02500593          	li	a1,37
 838:	855a                	mv	a0,s6
 83a:	c95ff0ef          	jal	4ce <putc>
        putc(fd, c0);
 83e:	85a6                	mv	a1,s1
 840:	855a                	mv	a0,s6
 842:	c8dff0ef          	jal	4ce <putc>
      state = 0;
 846:	4981                	li	s3,0
 848:	b359                	j	5ce <vprintf+0x44>

000000000000084a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84a:	715d                	addi	sp,sp,-80
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	e010                	sd	a2,0(s0)
 854:	e414                	sd	a3,8(s0)
 856:	e818                	sd	a4,16(s0)
 858:	ec1c                	sd	a5,24(s0)
 85a:	03043023          	sd	a6,32(s0)
 85e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 862:	8622                	mv	a2,s0
 864:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 868:	d23ff0ef          	jal	58a <vprintf>
}
 86c:	60e2                	ld	ra,24(sp)
 86e:	6442                	ld	s0,16(sp)
 870:	6161                	addi	sp,sp,80
 872:	8082                	ret

0000000000000874 <printf>:

void
printf(const char *fmt, ...)
{
 874:	711d                	addi	sp,sp,-96
 876:	ec06                	sd	ra,24(sp)
 878:	e822                	sd	s0,16(sp)
 87a:	1000                	addi	s0,sp,32
 87c:	e40c                	sd	a1,8(s0)
 87e:	e810                	sd	a2,16(s0)
 880:	ec14                	sd	a3,24(s0)
 882:	f018                	sd	a4,32(s0)
 884:	f41c                	sd	a5,40(s0)
 886:	03043823          	sd	a6,48(s0)
 88a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 88e:	00840613          	addi	a2,s0,8
 892:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 896:	85aa                	mv	a1,a0
 898:	4505                	li	a0,1
 89a:	cf1ff0ef          	jal	58a <vprintf>
}
 89e:	60e2                	ld	ra,24(sp)
 8a0:	6442                	ld	s0,16(sp)
 8a2:	6125                	addi	sp,sp,96
 8a4:	8082                	ret

00000000000008a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a6:	1141                	addi	sp,sp,-16
 8a8:	e406                	sd	ra,8(sp)
 8aa:	e022                	sd	s0,0(sp)
 8ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 8ae:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	00000797          	auipc	a5,0x0
 8b6:	74e7b783          	ld	a5,1870(a5) # 1000 <freep>
 8ba:	a039                	j	8c8 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	6398                	ld	a4,0(a5)
 8be:	00e7e463          	bltu	a5,a4,8c6 <free+0x20>
 8c2:	00e6ea63          	bltu	a3,a4,8d6 <free+0x30>
{
 8c6:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c8:	fed7fae3          	bgeu	a5,a3,8bc <free+0x16>
 8cc:	6398                	ld	a4,0(a5)
 8ce:	00e6e463          	bltu	a3,a4,8d6 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d2:	fee7eae3          	bltu	a5,a4,8c6 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 8d6:	ff852583          	lw	a1,-8(a0)
 8da:	6390                	ld	a2,0(a5)
 8dc:	02059813          	slli	a6,a1,0x20
 8e0:	01c85713          	srli	a4,a6,0x1c
 8e4:	9736                	add	a4,a4,a3
 8e6:	02e60563          	beq	a2,a4,910 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8ea:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 8ee:	4790                	lw	a2,8(a5)
 8f0:	02061593          	slli	a1,a2,0x20
 8f4:	01c5d713          	srli	a4,a1,0x1c
 8f8:	973e                	add	a4,a4,a5
 8fa:	02e68263          	beq	a3,a4,91e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8fe:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 900:	00000717          	auipc	a4,0x0
 904:	70f73023          	sd	a5,1792(a4) # 1000 <freep>
}
 908:	60a2                	ld	ra,8(sp)
 90a:	6402                	ld	s0,0(sp)
 90c:	0141                	addi	sp,sp,16
 90e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 910:	4618                	lw	a4,8(a2)
 912:	9f2d                	addw	a4,a4,a1
 914:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	6310                	ld	a2,0(a4)
 91c:	b7f9                	j	8ea <free+0x44>
    p->s.size += bp->s.size;
 91e:	ff852703          	lw	a4,-8(a0)
 922:	9f31                	addw	a4,a4,a2
 924:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 926:	ff053683          	ld	a3,-16(a0)
 92a:	bfd1                	j	8fe <free+0x58>

000000000000092c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 92c:	7139                	addi	sp,sp,-64
 92e:	fc06                	sd	ra,56(sp)
 930:	f822                	sd	s0,48(sp)
 932:	f04a                	sd	s2,32(sp)
 934:	ec4e                	sd	s3,24(sp)
 936:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 938:	02051993          	slli	s3,a0,0x20
 93c:	0209d993          	srli	s3,s3,0x20
 940:	09bd                	addi	s3,s3,15
 942:	0049d993          	srli	s3,s3,0x4
 946:	2985                	addiw	s3,s3,1
 948:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 94a:	00000517          	auipc	a0,0x0
 94e:	6b653503          	ld	a0,1718(a0) # 1000 <freep>
 952:	c905                	beqz	a0,982 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 954:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 956:	4798                	lw	a4,8(a5)
 958:	09377663          	bgeu	a4,s3,9e4 <malloc+0xb8>
 95c:	f426                	sd	s1,40(sp)
 95e:	e852                	sd	s4,16(sp)
 960:	e456                	sd	s5,8(sp)
 962:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 964:	8a4e                	mv	s4,s3
 966:	6705                	lui	a4,0x1
 968:	00e9f363          	bgeu	s3,a4,96e <malloc+0x42>
 96c:	6a05                	lui	s4,0x1
 96e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 972:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 976:	00000497          	auipc	s1,0x0
 97a:	68a48493          	addi	s1,s1,1674 # 1000 <freep>
  if (p == SBRK_ERROR)
 97e:	5afd                	li	s5,-1
 980:	a83d                	j	9be <malloc+0x92>
 982:	f426                	sd	s1,40(sp)
 984:	e852                	sd	s4,16(sp)
 986:	e456                	sd	s5,8(sp)
 988:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 98a:	00001797          	auipc	a5,0x1
 98e:	88678793          	addi	a5,a5,-1914 # 1210 <base>
 992:	00000717          	auipc	a4,0x0
 996:	66f73723          	sd	a5,1646(a4) # 1000 <freep>
 99a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 9a0:	b7d1                	j	964 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9a2:	6398                	ld	a4,0(a5)
 9a4:	e118                	sd	a4,0(a0)
 9a6:	a899                	j	9fc <malloc+0xd0>
  hp->s.size = nu;
 9a8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 9ac:	0541                	addi	a0,a0,16
 9ae:	ef9ff0ef          	jal	8a6 <free>
  return freep;
 9b2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 9b4:	c125                	beqz	a0,a14 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9b6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9b8:	4798                	lw	a4,8(a5)
 9ba:	03277163          	bgeu	a4,s2,9dc <malloc+0xb0>
    if (p == freep)
 9be:	6098                	ld	a4,0(s1)
 9c0:	853e                	mv	a0,a5
 9c2:	fef71ae3          	bne	a4,a5,9b6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9c6:	8552                	mv	a0,s4
 9c8:	9b1ff0ef          	jal	378 <sbrk>
  if (p == SBRK_ERROR)
 9cc:	fd551ee3          	bne	a0,s5,9a8 <malloc+0x7c>
        return 0;
 9d0:	4501                	li	a0,0
 9d2:	74a2                	ld	s1,40(sp)
 9d4:	6a42                	ld	s4,16(sp)
 9d6:	6aa2                	ld	s5,8(sp)
 9d8:	6b02                	ld	s6,0(sp)
 9da:	a03d                	j	a08 <malloc+0xdc>
 9dc:	74a2                	ld	s1,40(sp)
 9de:	6a42                	ld	s4,16(sp)
 9e0:	6aa2                	ld	s5,8(sp)
 9e2:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9e4:	fae90fe3          	beq	s2,a4,9a2 <malloc+0x76>
        p->s.size -= nunits;
 9e8:	4137073b          	subw	a4,a4,s3
 9ec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ee:	02071693          	slli	a3,a4,0x20
 9f2:	01c6d713          	srli	a4,a3,0x1c
 9f6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9f8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9fc:	00000717          	auipc	a4,0x0
 a00:	60a73223          	sd	a0,1540(a4) # 1000 <freep>
      return (void *)(p + 1);
 a04:	01078513          	addi	a0,a5,16
  }
}
 a08:	70e2                	ld	ra,56(sp)
 a0a:	7442                	ld	s0,48(sp)
 a0c:	7902                	ld	s2,32(sp)
 a0e:	69e2                	ld	s3,24(sp)
 a10:	6121                	addi	sp,sp,64
 a12:	8082                	ret
 a14:	74a2                	ld	s1,40(sp)
 a16:	6a42                	ld	s4,16(sp)
 a18:	6aa2                	ld	s5,8(sp)
 a1a:	6b02                	ld	s6,0(sp)
 a1c:	b7f5                	j	a08 <malloc+0xdc>
