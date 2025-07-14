
user/_threadtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <safe_print>:
#include "../kernel/proc.h"
#include "../user/user.h"

#define STACK_SIZE  100

void safe_print(const char *s, uint64 num) {
   0:	7159                	addi	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	1880                	addi	s0,sp,112
  char buf[64];
  int i = 0;
  for (const char *p = s; *p; p++)
   8:	00054703          	lbu	a4,0(a0)
   c:	cb31                	beqz	a4,60 <safe_print+0x60>
   e:	fb040693          	addi	a3,s0,-80
  12:	87aa                	mv	a5,a0
    buf[i++] = *p;
  14:	00e68023          	sb	a4,0(a3)
  for (const char *p = s; *p; p++)
  18:	863e                	mv	a2,a5
  1a:	0785                	addi	a5,a5,1
  1c:	0007c703          	lbu	a4,0(a5)
  20:	0685                	addi	a3,a3,1
  22:	fb6d                	bnez	a4,14 <safe_print+0x14>
    buf[i++] = *p;
  24:	9e09                	subw	a2,a2,a0
  26:	0016071b          	addiw	a4,a2,1
  if (num == 0) {
  2a:	ed8d                	bnez	a1,64 <safe_print+0x64>
    buf[i++] = '0';
  2c:	0017061b          	addiw	a2,a4,1
  30:	ff070793          	addi	a5,a4,-16
  34:	00878733          	add	a4,a5,s0
  38:	03000793          	li	a5,48
  3c:	fcf70023          	sb	a5,-64(a4)
      num /= 10;
    }
    while (t--)
      buf[i++] = tmp[t];
  }
  buf[i++] = '\n';
  40:	ff060793          	addi	a5,a2,-16
  44:	97a2                	add	a5,a5,s0
  46:	4729                	li	a4,10
  48:	fce78023          	sb	a4,-64(a5)
  write(1, buf, i);
  4c:	2605                	addiw	a2,a2,1
  4e:	fb040593          	addi	a1,s0,-80
  52:	4505                	li	a0,1
  54:	3e2000ef          	jal	436 <write>
}
  58:	70a6                	ld	ra,104(sp)
  5a:	7406                	ld	s0,96(sp)
  5c:	6165                	addi	sp,sp,112
  5e:	8082                	ret
  int i = 0;
  60:	4701                	li	a4,0
  62:	b7e1                	j	2a <safe_print+0x2a>
  64:	f9040513          	addi	a0,s0,-112
    int t = 0;
  68:	4681                	li	a3,0
      tmp[t++] = '0' + (num % 10);
  6a:	4829                	li	a6,10
    while (num) {
  6c:	48a5                	li	a7,9
      tmp[t++] = '0' + (num % 10);
  6e:	8636                	mv	a2,a3
  70:	2685                	addiw	a3,a3,1
  72:	0305f7b3          	remu	a5,a1,a6
  76:	0307879b          	addiw	a5,a5,48
  7a:	00f50023          	sb	a5,0(a0)
      num /= 10;
  7e:	87ae                	mv	a5,a1
  80:	0305d5b3          	divu	a1,a1,a6
    while (num) {
  84:	0505                	addi	a0,a0,1
  86:	fef8e4e3          	bltu	a7,a5,6e <safe_print+0x6e>
    while (t--)
  8a:	ca9d                	beqz	a3,c0 <safe_print+0xc0>
  8c:	f9040793          	addi	a5,s0,-112
  90:	00c786b3          	add	a3,a5,a2
  94:	fb040793          	addi	a5,s0,-80
  98:	97ba                	add	a5,a5,a4
  9a:	fb140593          	addi	a1,s0,-79
  9e:	00e58533          	add	a0,a1,a4
  a2:	02061593          	slli	a1,a2,0x20
  a6:	9181                	srli	a1,a1,0x20
  a8:	952e                	add	a0,a0,a1
      buf[i++] = tmp[t];
  aa:	0006c583          	lbu	a1,0(a3)
  ae:	00b78023          	sb	a1,0(a5)
    while (t--)
  b2:	16fd                	addi	a3,a3,-1
  b4:	0785                	addi	a5,a5,1
  b6:	fea79ae3          	bne	a5,a0,aa <safe_print+0xaa>
  ba:	2705                	addiw	a4,a4,1
  bc:	9e39                	addw	a2,a2,a4
  be:	b749                	j	40 <safe_print+0x40>
  c0:	863a                	mv	a2,a4
  c2:	bfbd                	j	40 <safe_print+0x40>

00000000000000c4 <my_thread>:

void *my_thread(void *arg) {
  c4:	7179                	addi	sp,sp,-48
  c6:	f406                	sd	ra,40(sp)
  c8:	f022                	sd	s0,32(sp)
  ca:	ec26                	sd	s1,24(sp)
  cc:	e84a                	sd	s2,16(sp)
  ce:	e44e                	sd	s3,8(sp)
  d0:	1800                	addi	s0,sp,48
  d2:	84aa                	mv	s1,a0
  uint64 number = (uint64)arg;
  for (int i = 0; i < 100; i++) {
  d4:	06450913          	addi	s2,a0,100
    number++;
    safe_print("thread: ", number);
  d8:	00001997          	auipc	s3,0x1
  dc:	92898993          	addi	s3,s3,-1752 # a00 <malloc+0x106>
    number++;
  e0:	0485                	addi	s1,s1,1
    safe_print("thread: ", number);
  e2:	85a6                	mv	a1,s1
  e4:	854e                	mv	a0,s3
  e6:	f1bff0ef          	jal	0 <safe_print>
  for (int i = 0; i < 100; i++) {
  ea:	ff249be3          	bne	s1,s2,e0 <my_thread+0x1c>
  }
  return (void *)number;
}
  ee:	854a                	mv	a0,s2
  f0:	70a2                	ld	ra,40(sp)
  f2:	7402                	ld	s0,32(sp)
  f4:	64e2                	ld	s1,24(sp)
  f6:	6942                	ld	s2,16(sp)
  f8:	69a2                	ld	s3,8(sp)
  fa:	6145                	addi	sp,sp,48
  fc:	8082                	ret

00000000000000fe <main>:

int main(int argc, char *argv[]) {
  fe:	b2010113          	addi	sp,sp,-1248
 102:	4c113c23          	sd	ra,1240(sp)
 106:	4c813823          	sd	s0,1232(sp)
 10a:	4c913423          	sd	s1,1224(sp)
 10e:	4d213023          	sd	s2,1216(sp)
 112:	4b313c23          	sd	s3,1208(sp)
 116:	4e010413          	addi	s0,sp,1248
  int sp1[STACK_SIZE], sp2[STACK_SIZE], sp3[STACK_SIZE];

  int ta = thread(my_thread, sp1 + STACK_SIZE, (void *)100);
 11a:	06400613          	li	a2,100
 11e:	fd040593          	addi	a1,s0,-48
 122:	00000517          	auipc	a0,0x0
 126:	fa250513          	addi	a0,a0,-94 # c4 <my_thread>
 12a:	394000ef          	jal	4be <thread>
 12e:	89aa                	mv	s3,a0
  safe_print("NEW THREAD CREATED ", ta);
 130:	85aa                	mv	a1,a0
 132:	00001517          	auipc	a0,0x1
 136:	8de50513          	addi	a0,a0,-1826 # a10 <malloc+0x116>
 13a:	ec7ff0ef          	jal	0 <safe_print>

  int tb = thread(my_thread, sp2 + STACK_SIZE, (void *)200);
 13e:	0c800613          	li	a2,200
 142:	e4040593          	addi	a1,s0,-448
 146:	00000517          	auipc	a0,0x0
 14a:	f7e50513          	addi	a0,a0,-130 # c4 <my_thread>
 14e:	370000ef          	jal	4be <thread>
 152:	892a                	mv	s2,a0
  safe_print("NEW THREAD CREATED ", tb);
 154:	85aa                	mv	a1,a0
 156:	00001517          	auipc	a0,0x1
 15a:	8ba50513          	addi	a0,a0,-1862 # a10 <malloc+0x116>
 15e:	ea3ff0ef          	jal	0 <safe_print>

  int tc = thread(my_thread, sp3 + STACK_SIZE, (void *)300);
 162:	12c00613          	li	a2,300
 166:	cb040593          	addi	a1,s0,-848
 16a:	00000517          	auipc	a0,0x0
 16e:	f5a50513          	addi	a0,a0,-166 # c4 <my_thread>
 172:	34c000ef          	jal	4be <thread>
 176:	84aa                	mv	s1,a0
  safe_print("NEW THREAD CREATED ", tc);
 178:	85aa                	mv	a1,a0
 17a:	00001517          	auipc	a0,0x1
 17e:	89650513          	addi	a0,a0,-1898 # a10 <malloc+0x116>
 182:	e7fff0ef          	jal	0 <safe_print>


  jointhread(ta);
 186:	854e                	mv	a0,s3
 188:	33e000ef          	jal	4c6 <jointhread>
  jointhread(tb);
 18c:	854a                	mv	a0,s2
 18e:	338000ef          	jal	4c6 <jointhread>
  jointhread(tc);
 192:	8526                	mv	a0,s1
 194:	332000ef          	jal	4c6 <jointhread>

  safe_print("DONE ", 0);
 198:	4581                	li	a1,0
 19a:	00001517          	auipc	a0,0x1
 19e:	88e50513          	addi	a0,a0,-1906 # a28 <malloc+0x12e>
 1a2:	e5fff0ef          	jal	0 <safe_print>
  exit(0);
 1a6:	4501                	li	a0,0
 1a8:	26e000ef          	jal	416 <exit>

00000000000001ac <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1b4:	f4bff0ef          	jal	fe <main>
  exit(0);
 1b8:	4501                	li	a0,0
 1ba:	25c000ef          	jal	416 <exit>

00000000000001be <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e422                	sd	s0,8(sp)
 1c2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c4:	87aa                	mv	a5,a0
 1c6:	0585                	addi	a1,a1,1
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff5c703          	lbu	a4,-1(a1)
 1ce:	fee78fa3          	sb	a4,-1(a5)
 1d2:	fb75                	bnez	a4,1c6 <strcpy+0x8>
    ;
  return os;
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	cb91                	beqz	a5,1f8 <strcmp+0x1e>
 1e6:	0005c703          	lbu	a4,0(a1)
 1ea:	00f71763          	bne	a4,a5,1f8 <strcmp+0x1e>
    p++, q++;
 1ee:	0505                	addi	a0,a0,1
 1f0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	fbe5                	bnez	a5,1e6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f8:	0005c503          	lbu	a0,0(a1)
}
 1fc:	40a7853b          	subw	a0,a5,a0
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <strlen>:

uint
strlen(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 20c:	00054783          	lbu	a5,0(a0)
 210:	cf91                	beqz	a5,22c <strlen+0x26>
 212:	0505                	addi	a0,a0,1
 214:	87aa                	mv	a5,a0
 216:	86be                	mv	a3,a5
 218:	0785                	addi	a5,a5,1
 21a:	fff7c703          	lbu	a4,-1(a5)
 21e:	ff65                	bnez	a4,216 <strlen+0x10>
 220:	40a6853b          	subw	a0,a3,a0
 224:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  for(n = 0; s[n]; n++)
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <strlen+0x20>

0000000000000230 <memset>:

void*
memset(void *dst, int c, uint n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 236:	ca19                	beqz	a2,24c <memset+0x1c>
 238:	87aa                	mv	a5,a0
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 242:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 246:	0785                	addi	a5,a5,1
 248:	fee79de3          	bne	a5,a4,242 <memset+0x12>
  }
  return dst;
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <strchr>:

char*
strchr(const char *s, char c)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  for(; *s; s++)
 258:	00054783          	lbu	a5,0(a0)
 25c:	cb99                	beqz	a5,272 <strchr+0x20>
    if(*s == c)
 25e:	00f58763          	beq	a1,a5,26c <strchr+0x1a>
  for(; *s; s++)
 262:	0505                	addi	a0,a0,1
 264:	00054783          	lbu	a5,0(a0)
 268:	fbfd                	bnez	a5,25e <strchr+0xc>
      return (char*)s;
  return 0;
 26a:	4501                	li	a0,0
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <strchr+0x1a>

0000000000000276 <gets>:

char*
gets(char *buf, int max)
{
 276:	711d                	addi	sp,sp,-96
 278:	ec86                	sd	ra,88(sp)
 27a:	e8a2                	sd	s0,80(sp)
 27c:	e4a6                	sd	s1,72(sp)
 27e:	e0ca                	sd	s2,64(sp)
 280:	fc4e                	sd	s3,56(sp)
 282:	f852                	sd	s4,48(sp)
 284:	f456                	sd	s5,40(sp)
 286:	f05a                	sd	s6,32(sp)
 288:	ec5e                	sd	s7,24(sp)
 28a:	1080                	addi	s0,sp,96
 28c:	8baa                	mv	s7,a0
 28e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 290:	892a                	mv	s2,a0
 292:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 294:	4aa9                	li	s5,10
 296:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 298:	89a6                	mv	s3,s1
 29a:	2485                	addiw	s1,s1,1
 29c:	0344d663          	bge	s1,s4,2c8 <gets+0x52>
    cc = read(0, &c, 1);
 2a0:	4605                	li	a2,1
 2a2:	faf40593          	addi	a1,s0,-81
 2a6:	4501                	li	a0,0
 2a8:	186000ef          	jal	42e <read>
    if(cc < 1)
 2ac:	00a05e63          	blez	a0,2c8 <gets+0x52>
    buf[i++] = c;
 2b0:	faf44783          	lbu	a5,-81(s0)
 2b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b8:	01578763          	beq	a5,s5,2c6 <gets+0x50>
 2bc:	0905                	addi	s2,s2,1
 2be:	fd679de3          	bne	a5,s6,298 <gets+0x22>
    buf[i++] = c;
 2c2:	89a6                	mv	s3,s1
 2c4:	a011                	j	2c8 <gets+0x52>
 2c6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2c8:	99de                	add	s3,s3,s7
 2ca:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ce:	855e                	mv	a0,s7
 2d0:	60e6                	ld	ra,88(sp)
 2d2:	6446                	ld	s0,80(sp)
 2d4:	64a6                	ld	s1,72(sp)
 2d6:	6906                	ld	s2,64(sp)
 2d8:	79e2                	ld	s3,56(sp)
 2da:	7a42                	ld	s4,48(sp)
 2dc:	7aa2                	ld	s5,40(sp)
 2de:	7b02                	ld	s6,32(sp)
 2e0:	6be2                	ld	s7,24(sp)
 2e2:	6125                	addi	sp,sp,96
 2e4:	8082                	ret

00000000000002e6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e6:	1101                	addi	sp,sp,-32
 2e8:	ec06                	sd	ra,24(sp)
 2ea:	e822                	sd	s0,16(sp)
 2ec:	e04a                	sd	s2,0(sp)
 2ee:	1000                	addi	s0,sp,32
 2f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f2:	4581                	li	a1,0
 2f4:	162000ef          	jal	456 <open>
  if(fd < 0)
 2f8:	02054263          	bltz	a0,31c <stat+0x36>
 2fc:	e426                	sd	s1,8(sp)
 2fe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 300:	85ca                	mv	a1,s2
 302:	16c000ef          	jal	46e <fstat>
 306:	892a                	mv	s2,a0
  close(fd);
 308:	8526                	mv	a0,s1
 30a:	134000ef          	jal	43e <close>
  return r;
 30e:	64a2                	ld	s1,8(sp)
}
 310:	854a                	mv	a0,s2
 312:	60e2                	ld	ra,24(sp)
 314:	6442                	ld	s0,16(sp)
 316:	6902                	ld	s2,0(sp)
 318:	6105                	addi	sp,sp,32
 31a:	8082                	ret
    return -1;
 31c:	597d                	li	s2,-1
 31e:	bfcd                	j	310 <stat+0x2a>

0000000000000320 <atoi>:

int
atoi(const char *s)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 326:	00054683          	lbu	a3,0(a0)
 32a:	fd06879b          	addiw	a5,a3,-48
 32e:	0ff7f793          	zext.b	a5,a5
 332:	4625                	li	a2,9
 334:	02f66863          	bltu	a2,a5,364 <atoi+0x44>
 338:	872a                	mv	a4,a0
  n = 0;
 33a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 33c:	0705                	addi	a4,a4,1
 33e:	0025179b          	slliw	a5,a0,0x2
 342:	9fa9                	addw	a5,a5,a0
 344:	0017979b          	slliw	a5,a5,0x1
 348:	9fb5                	addw	a5,a5,a3
 34a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34e:	00074683          	lbu	a3,0(a4)
 352:	fd06879b          	addiw	a5,a3,-48
 356:	0ff7f793          	zext.b	a5,a5
 35a:	fef671e3          	bgeu	a2,a5,33c <atoi+0x1c>
  return n;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  n = 0;
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <atoi+0x3e>

0000000000000368 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36e:	02b57463          	bgeu	a0,a1,396 <memmove+0x2e>
    while(n-- > 0)
 372:	00c05f63          	blez	a2,390 <memmove+0x28>
 376:	1602                	slli	a2,a2,0x20
 378:	9201                	srli	a2,a2,0x20
 37a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37e:	872a                	mv	a4,a0
      *dst++ = *src++;
 380:	0585                	addi	a1,a1,1
 382:	0705                	addi	a4,a4,1
 384:	fff5c683          	lbu	a3,-1(a1)
 388:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38c:	fef71ae3          	bne	a4,a5,380 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
    dst += n;
 396:	00c50733          	add	a4,a0,a2
    src += n;
 39a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 39c:	fec05ae3          	blez	a2,390 <memmove+0x28>
 3a0:	fff6079b          	addiw	a5,a2,-1
 3a4:	1782                	slli	a5,a5,0x20
 3a6:	9381                	srli	a5,a5,0x20
 3a8:	fff7c793          	not	a5,a5
 3ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ae:	15fd                	addi	a1,a1,-1
 3b0:	177d                	addi	a4,a4,-1
 3b2:	0005c683          	lbu	a3,0(a1)
 3b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ba:	fee79ae3          	bne	a5,a4,3ae <memmove+0x46>
 3be:	bfc9                	j	390 <memmove+0x28>

00000000000003c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c6:	ca05                	beqz	a2,3f6 <memcmp+0x36>
 3c8:	fff6069b          	addiw	a3,a2,-1
 3cc:	1682                	slli	a3,a3,0x20
 3ce:	9281                	srli	a3,a3,0x20
 3d0:	0685                	addi	a3,a3,1
 3d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d4:	00054783          	lbu	a5,0(a0)
 3d8:	0005c703          	lbu	a4,0(a1)
 3dc:	00e79863          	bne	a5,a4,3ec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e0:	0505                	addi	a0,a0,1
    p2++;
 3e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e4:	fed518e3          	bne	a0,a3,3d4 <memcmp+0x14>
  }
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	a019                	j	3f0 <memcmp+0x30>
      return *p1 - *p2;
 3ec:	40e7853b          	subw	a0,a5,a4
}
 3f0:	6422                	ld	s0,8(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret
  return 0;
 3f6:	4501                	li	a0,0
 3f8:	bfe5                	j	3f0 <memcmp+0x30>

00000000000003fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e406                	sd	ra,8(sp)
 3fe:	e022                	sd	s0,0(sp)
 400:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 402:	f67ff0ef          	jal	368 <memmove>
}
 406:	60a2                	ld	ra,8(sp)
 408:	6402                	ld	s0,0(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40e:	4885                	li	a7,1
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exit>:
.global exit
exit:
 li a7, SYS_exit
 416:	4889                	li	a7,2
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <wait>:
.global wait
wait:
 li a7, SYS_wait
 41e:	488d                	li	a7,3
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 426:	4891                	li	a7,4
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <read>:
.global read
read:
 li a7, SYS_read
 42e:	4895                	li	a7,5
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <write>:
.global write
write:
 li a7, SYS_write
 436:	48c1                	li	a7,16
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <close>:
.global close
close:
 li a7, SYS_close
 43e:	48d5                	li	a7,21
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <kill>:
.global kill
kill:
 li a7, SYS_kill
 446:	4899                	li	a7,6
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <exec>:
.global exec
exec:
 li a7, SYS_exec
 44e:	489d                	li	a7,7
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <open>:
.global open
open:
 li a7, SYS_open
 456:	48bd                	li	a7,15
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45e:	48c5                	li	a7,17
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 466:	48c9                	li	a7,18
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46e:	48a1                	li	a7,8
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <link>:
.global link
link:
 li a7, SYS_link
 476:	48cd                	li	a7,19
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47e:	48d1                	li	a7,20
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 486:	48a5                	li	a7,9
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <dup>:
.global dup
dup:
 li a7, SYS_dup
 48e:	48a9                	li	a7,10
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 496:	48ad                	li	a7,11
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49e:	48b1                	li	a7,12
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a6:	48b5                	li	a7,13
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ae:	48b9                	li	a7,14
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <trigger>:
.global trigger
trigger:
 li a7, SYS_trigger
 4b6:	48d9                	li	a7,22
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <thread>:
.global thread
thread:
 li a7, SYS_thread
 4be:	48dd                	li	a7,23
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
 4c6:	48e1                	li	a7,24
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
 4e0:	f57ff0ef          	jal	436 <write>
}
 4e4:	60e2                	ld	ra,24(sp)
 4e6:	6442                	ld	s0,16(sp)
 4e8:	6105                	addi	sp,sp,32
 4ea:	8082                	ret

00000000000004ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ec:	7139                	addi	sp,sp,-64
 4ee:	fc06                	sd	ra,56(sp)
 4f0:	f822                	sd	s0,48(sp)
 4f2:	f426                	sd	s1,40(sp)
 4f4:	0080                	addi	s0,sp,64
 4f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f8:	c299                	beqz	a3,4fe <printint+0x12>
 4fa:	0805c963          	bltz	a1,58c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fe:	2581                	sext.w	a1,a1
  neg = 0;
 500:	4881                	li	a7,0
 502:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 506:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 508:	2601                	sext.w	a2,a2
 50a:	00000517          	auipc	a0,0x0
 50e:	52e50513          	addi	a0,a0,1326 # a38 <digits>
 512:	883a                	mv	a6,a4
 514:	2705                	addiw	a4,a4,1
 516:	02c5f7bb          	remuw	a5,a1,a2
 51a:	1782                	slli	a5,a5,0x20
 51c:	9381                	srli	a5,a5,0x20
 51e:	97aa                	add	a5,a5,a0
 520:	0007c783          	lbu	a5,0(a5)
 524:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 528:	0005879b          	sext.w	a5,a1
 52c:	02c5d5bb          	divuw	a1,a1,a2
 530:	0685                	addi	a3,a3,1
 532:	fec7f0e3          	bgeu	a5,a2,512 <printint+0x26>
  if(neg)
 536:	00088c63          	beqz	a7,54e <printint+0x62>
    buf[i++] = '-';
 53a:	fd070793          	addi	a5,a4,-48
 53e:	00878733          	add	a4,a5,s0
 542:	02d00793          	li	a5,45
 546:	fef70823          	sb	a5,-16(a4)
 54a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 54e:	02e05a63          	blez	a4,582 <printint+0x96>
 552:	f04a                	sd	s2,32(sp)
 554:	ec4e                	sd	s3,24(sp)
 556:	fc040793          	addi	a5,s0,-64
 55a:	00e78933          	add	s2,a5,a4
 55e:	fff78993          	addi	s3,a5,-1
 562:	99ba                	add	s3,s3,a4
 564:	377d                	addiw	a4,a4,-1
 566:	1702                	slli	a4,a4,0x20
 568:	9301                	srli	a4,a4,0x20
 56a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 56e:	fff94583          	lbu	a1,-1(s2)
 572:	8526                	mv	a0,s1
 574:	f5bff0ef          	jal	4ce <putc>
  while(--i >= 0)
 578:	197d                	addi	s2,s2,-1
 57a:	ff391ae3          	bne	s2,s3,56e <printint+0x82>
 57e:	7902                	ld	s2,32(sp)
 580:	69e2                	ld	s3,24(sp)
}
 582:	70e2                	ld	ra,56(sp)
 584:	7442                	ld	s0,48(sp)
 586:	74a2                	ld	s1,40(sp)
 588:	6121                	addi	sp,sp,64
 58a:	8082                	ret
    x = -xx;
 58c:	40b005bb          	negw	a1,a1
    neg = 1;
 590:	4885                	li	a7,1
    x = -xx;
 592:	bf85                	j	502 <printint+0x16>

0000000000000594 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 594:	711d                	addi	sp,sp,-96
 596:	ec86                	sd	ra,88(sp)
 598:	e8a2                	sd	s0,80(sp)
 59a:	e0ca                	sd	s2,64(sp)
 59c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 59e:	0005c903          	lbu	s2,0(a1)
 5a2:	26090863          	beqz	s2,812 <vprintf+0x27e>
 5a6:	e4a6                	sd	s1,72(sp)
 5a8:	fc4e                	sd	s3,56(sp)
 5aa:	f852                	sd	s4,48(sp)
 5ac:	f456                	sd	s5,40(sp)
 5ae:	f05a                	sd	s6,32(sp)
 5b0:	ec5e                	sd	s7,24(sp)
 5b2:	e862                	sd	s8,16(sp)
 5b4:	e466                	sd	s9,8(sp)
 5b6:	8b2a                	mv	s6,a0
 5b8:	8a2e                	mv	s4,a1
 5ba:	8bb2                	mv	s7,a2
  state = 0;
 5bc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5be:	4481                	li	s1,0
 5c0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5c2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5c6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ca:	06c00c93          	li	s9,108
 5ce:	a005                	j	5ee <vprintf+0x5a>
        putc(fd, c0);
 5d0:	85ca                	mv	a1,s2
 5d2:	855a                	mv	a0,s6
 5d4:	efbff0ef          	jal	4ce <putc>
 5d8:	a019                	j	5de <vprintf+0x4a>
    } else if(state == '%'){
 5da:	03598263          	beq	s3,s5,5fe <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5de:	2485                	addiw	s1,s1,1
 5e0:	8726                	mv	a4,s1
 5e2:	009a07b3          	add	a5,s4,s1
 5e6:	0007c903          	lbu	s2,0(a5)
 5ea:	20090c63          	beqz	s2,802 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5ee:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5f2:	fe0994e3          	bnez	s3,5da <vprintf+0x46>
      if(c0 == '%'){
 5f6:	fd579de3          	bne	a5,s5,5d0 <vprintf+0x3c>
        state = '%';
 5fa:	89be                	mv	s3,a5
 5fc:	b7cd                	j	5de <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5fe:	00ea06b3          	add	a3,s4,a4
 602:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 606:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 608:	c681                	beqz	a3,610 <vprintf+0x7c>
 60a:	9752                	add	a4,a4,s4
 60c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 610:	03878f63          	beq	a5,s8,64e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 614:	05978963          	beq	a5,s9,666 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 618:	07500713          	li	a4,117
 61c:	0ee78363          	beq	a5,a4,702 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 620:	07800713          	li	a4,120
 624:	12e78563          	beq	a5,a4,74e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 628:	07000713          	li	a4,112
 62c:	14e78a63          	beq	a5,a4,780 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 630:	07300713          	li	a4,115
 634:	18e78a63          	beq	a5,a4,7c8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 638:	02500713          	li	a4,37
 63c:	04e79563          	bne	a5,a4,686 <vprintf+0xf2>
        putc(fd, '%');
 640:	02500593          	li	a1,37
 644:	855a                	mv	a0,s6
 646:	e89ff0ef          	jal	4ce <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 64a:	4981                	li	s3,0
 64c:	bf49                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 64e:	008b8913          	addi	s2,s7,8
 652:	4685                	li	a3,1
 654:	4629                	li	a2,10
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e91ff0ef          	jal	4ec <printint>
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	bfad                	j	5de <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 666:	06400793          	li	a5,100
 66a:	02f68963          	beq	a3,a5,69c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 66e:	06c00793          	li	a5,108
 672:	04f68263          	beq	a3,a5,6b6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 676:	07500793          	li	a5,117
 67a:	0af68063          	beq	a3,a5,71a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 67e:	07800793          	li	a5,120
 682:	0ef68263          	beq	a3,a5,766 <vprintf+0x1d2>
        putc(fd, '%');
 686:	02500593          	li	a1,37
 68a:	855a                	mv	a0,s6
 68c:	e43ff0ef          	jal	4ce <putc>
        putc(fd, c0);
 690:	85ca                	mv	a1,s2
 692:	855a                	mv	a0,s6
 694:	e3bff0ef          	jal	4ce <putc>
      state = 0;
 698:	4981                	li	s3,0
 69a:	b791                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	e43ff0ef          	jal	4ec <printint>
        i += 1;
 6ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 1;
 6b4:	b72d                	j	5de <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b6:	06400793          	li	a5,100
 6ba:	02f60763          	beq	a2,a5,6e8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6be:	07500793          	li	a5,117
 6c2:	06f60963          	beq	a2,a5,734 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c6:	07800793          	li	a5,120
 6ca:	faf61ee3          	bne	a2,a5,686 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	e11ff0ef          	jal	4ec <printint>
        i += 2;
 6e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	bde5                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4685                	li	a3,1
 6ee:	4629                	li	a2,10
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	df7ff0ef          	jal	4ec <printint>
        i += 2;
 6fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	bdf9                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 702:	008b8913          	addi	s2,s7,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	dddff0ef          	jal	4ec <printint>
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	b5d9                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4681                	li	a3,0
 720:	4629                	li	a2,10
 722:	000ba583          	lw	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	dc5ff0ef          	jal	4ec <printint>
        i += 1;
 72c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	8bca                	mv	s7,s2
      state = 0;
 730:	4981                	li	s3,0
        i += 1;
 732:	b575                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b8913          	addi	s2,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000ba583          	lw	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	dabff0ef          	jal	4ec <printint>
        i += 2;
 746:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	8bca                	mv	s7,s2
      state = 0;
 74a:	4981                	li	s3,0
        i += 2;
 74c:	bd49                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 74e:	008b8913          	addi	s2,s7,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000ba583          	lw	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	d91ff0ef          	jal	4ec <printint>
 760:	8bca                	mv	s7,s2
      state = 0;
 762:	4981                	li	s3,0
 764:	bdad                	j	5de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	008b8913          	addi	s2,s7,8
 76a:	4681                	li	a3,0
 76c:	4641                	li	a2,16
 76e:	000ba583          	lw	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	d79ff0ef          	jal	4ec <printint>
        i += 1;
 778:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
        i += 1;
 77e:	b585                	j	5de <vprintf+0x4a>
 780:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 782:	008b8d13          	addi	s10,s7,8
 786:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 78a:	03000593          	li	a1,48
 78e:	855a                	mv	a0,s6
 790:	d3fff0ef          	jal	4ce <putc>
  putc(fd, 'x');
 794:	07800593          	li	a1,120
 798:	855a                	mv	a0,s6
 79a:	d35ff0ef          	jal	4ce <putc>
 79e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a0:	00000b97          	auipc	s7,0x0
 7a4:	298b8b93          	addi	s7,s7,664 # a38 <digits>
 7a8:	03c9d793          	srli	a5,s3,0x3c
 7ac:	97de                	add	a5,a5,s7
 7ae:	0007c583          	lbu	a1,0(a5)
 7b2:	855a                	mv	a0,s6
 7b4:	d1bff0ef          	jal	4ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b8:	0992                	slli	s3,s3,0x4
 7ba:	397d                	addiw	s2,s2,-1
 7bc:	fe0916e3          	bnez	s2,7a8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7c0:	8bea                	mv	s7,s10
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	6d02                	ld	s10,0(sp)
 7c6:	bd21                	j	5de <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7c8:	008b8993          	addi	s3,s7,8
 7cc:	000bb903          	ld	s2,0(s7)
 7d0:	00090f63          	beqz	s2,7ee <vprintf+0x25a>
        for(; *s; s++)
 7d4:	00094583          	lbu	a1,0(s2)
 7d8:	c195                	beqz	a1,7fc <vprintf+0x268>
          putc(fd, *s);
 7da:	855a                	mv	a0,s6
 7dc:	cf3ff0ef          	jal	4ce <putc>
        for(; *s; s++)
 7e0:	0905                	addi	s2,s2,1
 7e2:	00094583          	lbu	a1,0(s2)
 7e6:	f9f5                	bnez	a1,7da <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7e8:	8bce                	mv	s7,s3
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	bbcd                	j	5de <vprintf+0x4a>
          s = "(null)";
 7ee:	00000917          	auipc	s2,0x0
 7f2:	24290913          	addi	s2,s2,578 # a30 <malloc+0x136>
        for(; *s; s++)
 7f6:	02800593          	li	a1,40
 7fa:	b7c5                	j	7da <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7fc:	8bce                	mv	s7,s3
      state = 0;
 7fe:	4981                	li	s3,0
 800:	bbf9                	j	5de <vprintf+0x4a>
 802:	64a6                	ld	s1,72(sp)
 804:	79e2                	ld	s3,56(sp)
 806:	7a42                	ld	s4,48(sp)
 808:	7aa2                	ld	s5,40(sp)
 80a:	7b02                	ld	s6,32(sp)
 80c:	6be2                	ld	s7,24(sp)
 80e:	6c42                	ld	s8,16(sp)
 810:	6ca2                	ld	s9,8(sp)
    }
  }
}
 812:	60e6                	ld	ra,88(sp)
 814:	6446                	ld	s0,80(sp)
 816:	6906                	ld	s2,64(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81c:	715d                	addi	sp,sp,-80
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e010                	sd	a2,0(s0)
 826:	e414                	sd	a3,8(s0)
 828:	e818                	sd	a4,16(s0)
 82a:	ec1c                	sd	a5,24(s0)
 82c:	03043023          	sd	a6,32(s0)
 830:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 838:	8622                	mv	a2,s0
 83a:	d5bff0ef          	jal	594 <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret

0000000000000846 <printf>:

void
printf(const char *fmt, ...)
{
 846:	711d                	addi	sp,sp,-96
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e40c                	sd	a1,8(s0)
 850:	e810                	sd	a2,16(s0)
 852:	ec14                	sd	a3,24(s0)
 854:	f018                	sd	a4,32(s0)
 856:	f41c                	sd	a5,40(s0)
 858:	03043823          	sd	a6,48(s0)
 85c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	00840613          	addi	a2,s0,8
 864:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 868:	85aa                	mv	a1,a0
 86a:	4505                	li	a0,1
 86c:	d29ff0ef          	jal	594 <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6125                	addi	sp,sp,96
 876:	8082                	ret

0000000000000878 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 878:	1141                	addi	sp,sp,-16
 87a:	e422                	sd	s0,8(sp)
 87c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 882:	00000797          	auipc	a5,0x0
 886:	77e7b783          	ld	a5,1918(a5) # 1000 <freep>
 88a:	a02d                	j	8b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 88c:	4618                	lw	a4,8(a2)
 88e:	9f2d                	addw	a4,a4,a1
 890:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	6310                	ld	a2,0(a4)
 898:	a83d                	j	8d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 89a:	ff852703          	lw	a4,-8(a0)
 89e:	9f31                	addw	a4,a4,a2
 8a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a2:	ff053683          	ld	a3,-16(a0)
 8a6:	a091                	j	8ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	6398                	ld	a4,0(a5)
 8aa:	00e7e463          	bltu	a5,a4,8b2 <free+0x3a>
 8ae:	00e6ea63          	bltu	a3,a4,8c2 <free+0x4a>
{
 8b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	fed7fae3          	bgeu	a5,a3,8a8 <free+0x30>
 8b8:	6398                	ld	a4,0(a5)
 8ba:	00e6e463          	bltu	a3,a4,8c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	fee7eae3          	bltu	a5,a4,8b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c2:	ff852583          	lw	a1,-8(a0)
 8c6:	6390                	ld	a2,0(a5)
 8c8:	02059813          	slli	a6,a1,0x20
 8cc:	01c85713          	srli	a4,a6,0x1c
 8d0:	9736                	add	a4,a4,a3
 8d2:	fae60de3          	beq	a2,a4,88c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8da:	4790                	lw	a2,8(a5)
 8dc:	02061593          	slli	a1,a2,0x20
 8e0:	01c5d713          	srli	a4,a1,0x1c
 8e4:	973e                	add	a4,a4,a5
 8e6:	fae68ae3          	beq	a3,a4,89a <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70f73a23          	sd	a5,1812(a4) # 1000 <freep>
}
 8f4:	6422                	ld	s0,8(sp)
 8f6:	0141                	addi	sp,sp,16
 8f8:	8082                	ret

00000000000008fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fa:	7139                	addi	sp,sp,-64
 8fc:	fc06                	sd	ra,56(sp)
 8fe:	f822                	sd	s0,48(sp)
 900:	f426                	sd	s1,40(sp)
 902:	ec4e                	sd	s3,24(sp)
 904:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 906:	02051493          	slli	s1,a0,0x20
 90a:	9081                	srli	s1,s1,0x20
 90c:	04bd                	addi	s1,s1,15
 90e:	8091                	srli	s1,s1,0x4
 910:	0014899b          	addiw	s3,s1,1
 914:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 916:	00000517          	auipc	a0,0x0
 91a:	6ea53503          	ld	a0,1770(a0) # 1000 <freep>
 91e:	c915                	beqz	a0,952 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	08977a63          	bgeu	a4,s1,9b8 <malloc+0xbe>
 928:	f04a                	sd	s2,32(sp)
 92a:	e852                	sd	s4,16(sp)
 92c:	e456                	sd	s5,8(sp)
 92e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 930:	8a4e                	mv	s4,s3
 932:	0009871b          	sext.w	a4,s3
 936:	6685                	lui	a3,0x1
 938:	00d77363          	bgeu	a4,a3,93e <malloc+0x44>
 93c:	6a05                	lui	s4,0x1
 93e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 942:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 946:	00000917          	auipc	s2,0x0
 94a:	6ba90913          	addi	s2,s2,1722 # 1000 <freep>
  if(p == (char*)-1)
 94e:	5afd                	li	s5,-1
 950:	a081                	j	990 <malloc+0x96>
 952:	f04a                	sd	s2,32(sp)
 954:	e852                	sd	s4,16(sp)
 956:	e456                	sd	s5,8(sp)
 958:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 95a:	00000797          	auipc	a5,0x0
 95e:	6b678793          	addi	a5,a5,1718 # 1010 <base>
 962:	00000717          	auipc	a4,0x0
 966:	68f73f23          	sd	a5,1694(a4) # 1000 <freep>
 96a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 970:	b7c1                	j	930 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 972:	6398                	ld	a4,0(a5)
 974:	e118                	sd	a4,0(a0)
 976:	a8a9                	j	9d0 <malloc+0xd6>
  hp->s.size = nu;
 978:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97c:	0541                	addi	a0,a0,16
 97e:	efbff0ef          	jal	878 <free>
  return freep;
 982:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 986:	c12d                	beqz	a0,9e8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 988:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98a:	4798                	lw	a4,8(a5)
 98c:	02977263          	bgeu	a4,s1,9b0 <malloc+0xb6>
    if(p == freep)
 990:	00093703          	ld	a4,0(s2)
 994:	853e                	mv	a0,a5
 996:	fef719e3          	bne	a4,a5,988 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 99a:	8552                	mv	a0,s4
 99c:	b03ff0ef          	jal	49e <sbrk>
  if(p == (char*)-1)
 9a0:	fd551ce3          	bne	a0,s5,978 <malloc+0x7e>
        return 0;
 9a4:	4501                	li	a0,0
 9a6:	7902                	ld	s2,32(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	a03d                	j	9dc <malloc+0xe2>
 9b0:	7902                	ld	s2,32(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b8:	fae48de3          	beq	s1,a4,972 <malloc+0x78>
        p->s.size -= nunits;
 9bc:	4137073b          	subw	a4,a4,s3
 9c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c2:	02071693          	slli	a3,a4,0x20
 9c6:	01c6d713          	srli	a4,a3,0x1c
 9ca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9cc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d0:	00000717          	auipc	a4,0x0
 9d4:	62a73823          	sd	a0,1584(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d8:	01078513          	addi	a0,a5,16
  }
}
 9dc:	70e2                	ld	ra,56(sp)
 9de:	7442                	ld	s0,48(sp)
 9e0:	74a2                	ld	s1,40(sp)
 9e2:	69e2                	ld	s3,24(sp)
 9e4:	6121                	addi	sp,sp,64
 9e6:	8082                	ret
 9e8:	7902                	ld	s2,32(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
 9f0:	b7f5                	j	9dc <malloc+0xe2>
