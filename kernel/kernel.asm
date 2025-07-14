
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	ab010113          	addi	sp,sp,-1360 # 80007ab0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb807>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	55d010ef          	jal	80001e56 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00010517          	auipc	a0,0x10
    80000158:	95c50513          	addi	a0,a0,-1700 # 8000fab0 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00010497          	auipc	s1,0x10
    80000164:	95048493          	addi	s1,s1,-1712 # 8000fab0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00010917          	auipc	s2,0x10
    8000016c:	9e090913          	addi	s2,s2,-1568 # 8000fb48 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	782010ef          	jal	80001902 <myproc>
    80000184:	45f010ef          	jal	80001de2 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	21d010ef          	jal	80001baa <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00010717          	auipc	a4,0x10
    800001a4:	91070713          	addi	a4,a4,-1776 # 8000fab0 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	43b010ef          	jal	80001e0c <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00010517          	auipc	a0,0x10
    800001ee:	8c650513          	addi	a0,a0,-1850 # 8000fab0 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00010717          	auipc	a4,0x10
    80000218:	92f72a23          	sw	a5,-1740(a4) # 8000fb48 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00010517          	auipc	a0,0x10
    8000022e:	88650513          	addi	a0,a0,-1914 # 8000fab0 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00010517          	auipc	a0,0x10
    80000282:	83250513          	addi	a0,a0,-1998 # 8000fab0 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	401010ef          	jal	80001ea0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00010517          	auipc	a0,0x10
    800002a8:	80c50513          	addi	a0,a0,-2036 # 8000fab0 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	0000f717          	auipc	a4,0xf
    800002c6:	7ee70713          	addi	a4,a4,2030 # 8000fab0 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	0000f797          	auipc	a5,0xf
    800002ec:	7c878793          	addi	a5,a5,1992 # 8000fab0 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	00010797          	auipc	a5,0x10
    8000031a:	8327a783          	lw	a5,-1998(a5) # 8000fb48 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	0000f717          	auipc	a4,0xf
    80000330:	78470713          	addi	a4,a4,1924 # 8000fab0 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	0000f497          	auipc	s1,0xf
    80000340:	77448493          	addi	s1,s1,1908 # 8000fab0 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	0000f717          	auipc	a4,0xf
    80000382:	73270713          	addi	a4,a4,1842 # 8000fab0 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	0000f717          	auipc	a4,0xf
    80000398:	7af72e23          	sw	a5,1980(a4) # 8000fb50 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	0000f797          	auipc	a5,0xf
    800003b6:	6fe78793          	addi	a5,a5,1790 # 8000fab0 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	0000f797          	auipc	a5,0xf
    800003da:	76c7ab23          	sw	a2,1910(a5) # 8000fb4c <cons+0x9c>
        wakeup(&cons.r);
    800003de:	0000f517          	auipc	a0,0xf
    800003e2:	76a50513          	addi	a0,a0,1898 # 8000fb48 <cons+0x98>
    800003e6:	011010ef          	jal	80001bf6 <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	0000f517          	auipc	a0,0xf
    80000400:	6b450513          	addi	a0,a0,1716 # 8000fab0 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00022797          	auipc	a5,0x22
    80000410:	a3c78793          	addi	a5,a5,-1476 # 80021e48 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	49260613          	addi	a2,a2,1170 # 800078d8 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	0000f797          	auipc	a5,0xf
    800004e4:	6907a783          	lw	a5,1680(a5) # 8000fb70 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	0000f517          	auipc	a0,0xf
    80000530:	62c50513          	addi	a0,a0,1580 # 8000fb58 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	1ecb8b93          	addi	s7,s7,492 # 800078d8 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	0000f517          	auipc	a0,0xf
    8000078a:	3d250513          	addi	a0,a0,978 # 8000fb58 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	0000f797          	auipc	a5,0xf
    800007a4:	3c07a823          	sw	zero,976(a5) # 8000fb70 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	00007717          	auipc	a4,0x7
    800007c8:	2af72623          	sw	a5,684(a4) # 80007a70 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	0000f497          	auipc	s1,0xf
    800007dc:	38048493          	addi	s1,s1,896 # 8000fb58 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	0000f517          	auipc	a0,0xf
    80000844:	33850513          	addi	a0,a0,824 # 8000fb78 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	00007797          	auipc	a5,0x7
    80000868:	20c7a783          	lw	a5,524(a5) # 80007a70 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	00007797          	auipc	a5,0x7
    8000089e:	1de7b783          	ld	a5,478(a5) # 80007a78 <uart_tx_r>
    800008a2:	00007717          	auipc	a4,0x7
    800008a6:	1de73703          	ld	a4,478(a4) # 80007a80 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	0000fa97          	auipc	s5,0xf
    800008cc:	2b0a8a93          	addi	s5,s5,688 # 8000fb78 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	00007497          	auipc	s1,0x7
    800008d4:	1a848493          	addi	s1,s1,424 # 80007a78 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	00007997          	auipc	s3,0x7
    800008e0:	1a498993          	addi	s3,s3,420 # 80007a80 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	2f8010ef          	jal	80001bf6 <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	0000f517          	auipc	a0,0xf
    80000950:	22c50513          	addi	a0,a0,556 # 8000fb78 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	00007797          	auipc	a5,0x7
    8000095c:	1187a783          	lw	a5,280(a5) # 80007a70 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	00007717          	auipc	a4,0x7
    80000966:	11e73703          	ld	a4,286(a4) # 80007a80 <uart_tx_w>
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	10e7b783          	ld	a5,270(a5) # 80007a78 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	0000f997          	auipc	s3,0xf
    8000097a:	20298993          	addi	s3,s3,514 # 8000fb78 <uart_tx_lock>
    8000097e:	00007497          	auipc	s1,0x7
    80000982:	0fa48493          	addi	s1,s1,250 # 80007a78 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00007917          	auipc	s2,0x7
    8000098a:	0fa90913          	addi	s2,s2,250 # 80007a80 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	214010ef          	jal	80001baa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	0000f497          	auipc	s1,0xf
    800009ac:	1d048493          	addi	s1,s1,464 # 8000fb78 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	00007797          	auipc	a5,0x7
    800009c0:	0ce7b223          	sd	a4,196(a5) # 80007a80 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	0000f497          	auipc	s1,0xf
    80000a24:	15848493          	addi	s1,s1,344 # 8000fb78 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00022797          	auipc	a5,0x22
    80000a5a:	5a278793          	addi	a5,a5,1442 # 80022ff8 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	0000f917          	auipc	s2,0xf
    80000a76:	13e90913          	addi	s2,s2,318 # 8000fbb0 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	0000f517          	auipc	a0,0xf
    80000b04:	0b050513          	addi	a0,a0,176 # 8000fbb0 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00022517          	auipc	a0,0x22
    80000b14:	4e850513          	addi	a0,a0,1256 # 80022ff8 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	0000f497          	auipc	s1,0xf
    80000b32:	08248493          	addi	s1,s1,130 # 8000fbb0 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	0000f517          	auipc	a0,0xf
    80000b46:	06e50513          	addi	a0,a0,110 # 8000fbb0 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	0000f517          	auipc	a0,0xf
    80000b6a:	04a50513          	addi	a0,a0,74 # 8000fbb0 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	549000ef          	jal	800018e6 <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	51b000ef          	jal	800018e6 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	513000ef          	jal	800018e6 <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	4ff000ef          	jal	800018e6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c1c:	4cb000ef          	jal	800018e6 <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	4a7000ef          	jal	800018e6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca6:	0f50000f          	fence	iorw,ow
    80000caa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdc009>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	26d000ef          	jal	800018d6 <cpuid>

    __sync_synchronize();
    started = 1;

  } else {
    while(started == 0)
    80000e6e:	00007717          	auipc	a4,0x7
    80000e72:	c1a70713          	addi	a4,a4,-998 # 80007a88 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e82:	255000ef          	jal	800018d6 <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	31050513          	addi	a0,a0,784 # 80007198 <etext+0x198>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	0aa000ef          	jal	80000f3e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	107010ef          	jal	8000279e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	03d040ef          	jal	800056d8 <plicinithart>
  }

  scheduler();        
    80000ea0:	718010ef          	jal	800025b8 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2f4000ef          	jal	800011c8 <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	066000ef          	jal	80000f3e <kvminithart>
    procinit();      // process table
    80000edc:	147000ef          	jal	80001822 <procinit>
    trapinit();      // trap vectors
    80000ee0:	09b010ef          	jal	8000277a <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	0bb010ef          	jal	8000279e <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	7d6040ef          	jal	800056be <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	7ec040ef          	jal	800056d8 <plicinithart>
    binit();         // buffer cache
    80000ef0:	793010ef          	jal	80002e82 <binit>
    iinit();         // inode table
    80000ef4:	584020ef          	jal	80003478 <iinit>
    fileinit();      // file table
    80000ef8:	330030ef          	jal	80004228 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	17f040ef          	jal	8000587a <virtio_disk_init>
    userinit();      // first user process
    80000f00:	18c010ef          	jal	8000208c <userinit>
    log_message(LOG_INFO, "Welcome to AUT MCS Principles of Operating Systems Course. This message is from a custom logger implemented by Dorsa Rezaei and Parnian Shamsa");
    80000f04:	00006597          	auipc	a1,0x6
    80000f08:	19458593          	addi	a1,a1,404 # 80007098 <etext+0x98>
    80000f0c:	4501                	li	a0,0
    80000f0e:	045040ef          	jal	80005752 <log_message>
    log_message(LOG_WARN, "This is a test warning message for the custom logger");
    80000f12:	00006597          	auipc	a1,0x6
    80000f16:	21658593          	addi	a1,a1,534 # 80007128 <etext+0x128>
    80000f1a:	4505                	li	a0,1
    80000f1c:	037040ef          	jal	80005752 <log_message>
    log_message(LOG_ERROR, "This is a test error message for the custom logger");
    80000f20:	00006597          	auipc	a1,0x6
    80000f24:	24058593          	addi	a1,a1,576 # 80007160 <etext+0x160>
    80000f28:	4509                	li	a0,2
    80000f2a:	029040ef          	jal	80005752 <log_message>
    __sync_synchronize();
    80000f2e:	0ff0000f          	fence
    started = 1;
    80000f32:	4785                	li	a5,1
    80000f34:	00007717          	auipc	a4,0x7
    80000f38:	b4f72a23          	sw	a5,-1196(a4) # 80007a88 <started>
    80000f3c:	b795                	j	80000ea0 <main+0x3e>

0000000080000f3e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f3e:	1141                	addi	sp,sp,-16
    80000f40:	e422                	sd	s0,8(sp)
    80000f42:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f44:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f48:	00007797          	auipc	a5,0x7
    80000f4c:	b487b783          	ld	a5,-1208(a5) # 80007a90 <kernel_pagetable>
    80000f50:	83b1                	srli	a5,a5,0xc
    80000f52:	577d                	li	a4,-1
    80000f54:	177e                	slli	a4,a4,0x3f
    80000f56:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f58:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f5c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f60:	6422                	ld	s0,8(sp)
    80000f62:	0141                	addi	sp,sp,16
    80000f64:	8082                	ret

0000000080000f66 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f66:	7139                	addi	sp,sp,-64
    80000f68:	fc06                	sd	ra,56(sp)
    80000f6a:	f822                	sd	s0,48(sp)
    80000f6c:	f426                	sd	s1,40(sp)
    80000f6e:	f04a                	sd	s2,32(sp)
    80000f70:	ec4e                	sd	s3,24(sp)
    80000f72:	e852                	sd	s4,16(sp)
    80000f74:	e456                	sd	s5,8(sp)
    80000f76:	e05a                	sd	s6,0(sp)
    80000f78:	0080                	addi	s0,sp,64
    80000f7a:	84aa                	mv	s1,a0
    80000f7c:	89ae                	mv	s3,a1
    80000f7e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f80:	57fd                	li	a5,-1
    80000f82:	83e9                	srli	a5,a5,0x1a
    80000f84:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f86:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f88:	02b7fc63          	bgeu	a5,a1,80000fc0 <walk+0x5a>
    panic("walk");
    80000f8c:	00006517          	auipc	a0,0x6
    80000f90:	22450513          	addi	a0,a0,548 # 800071b0 <etext+0x1b0>
    80000f94:	801ff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f98:	060a8263          	beqz	s5,80000ffc <walk+0x96>
    80000f9c:	b89ff0ef          	jal	80000b24 <kalloc>
    80000fa0:	84aa                	mv	s1,a0
    80000fa2:	c139                	beqz	a0,80000fe8 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fa4:	6605                	lui	a2,0x1
    80000fa6:	4581                	li	a1,0
    80000fa8:	d21ff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fac:	00c4d793          	srli	a5,s1,0xc
    80000fb0:	07aa                	slli	a5,a5,0xa
    80000fb2:	0017e793          	ori	a5,a5,1
    80000fb6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000fba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbfff>
    80000fbc:	036a0063          	beq	s4,s6,80000fdc <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fc0:	0149d933          	srl	s2,s3,s4
    80000fc4:	1ff97913          	andi	s2,s2,511
    80000fc8:	090e                	slli	s2,s2,0x3
    80000fca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fcc:	00093483          	ld	s1,0(s2)
    80000fd0:	0014f793          	andi	a5,s1,1
    80000fd4:	d3f1                	beqz	a5,80000f98 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fd6:	80a9                	srli	s1,s1,0xa
    80000fd8:	04b2                	slli	s1,s1,0xc
    80000fda:	b7c5                	j	80000fba <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fdc:	00c9d513          	srli	a0,s3,0xc
    80000fe0:	1ff57513          	andi	a0,a0,511
    80000fe4:	050e                	slli	a0,a0,0x3
    80000fe6:	9526                	add	a0,a0,s1
}
    80000fe8:	70e2                	ld	ra,56(sp)
    80000fea:	7442                	ld	s0,48(sp)
    80000fec:	74a2                	ld	s1,40(sp)
    80000fee:	7902                	ld	s2,32(sp)
    80000ff0:	69e2                	ld	s3,24(sp)
    80000ff2:	6a42                	ld	s4,16(sp)
    80000ff4:	6aa2                	ld	s5,8(sp)
    80000ff6:	6b02                	ld	s6,0(sp)
    80000ff8:	6121                	addi	sp,sp,64
    80000ffa:	8082                	ret
        return 0;
    80000ffc:	4501                	li	a0,0
    80000ffe:	b7ed                	j	80000fe8 <walk+0x82>

0000000080001000 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001000:	57fd                	li	a5,-1
    80001002:	83e9                	srli	a5,a5,0x1a
    80001004:	00b7f463          	bgeu	a5,a1,8000100c <walkaddr+0xc>
    return 0;
    80001008:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000100a:	8082                	ret
{
    8000100c:	1141                	addi	sp,sp,-16
    8000100e:	e406                	sd	ra,8(sp)
    80001010:	e022                	sd	s0,0(sp)
    80001012:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001014:	4601                	li	a2,0
    80001016:	f51ff0ef          	jal	80000f66 <walk>
  if(pte == 0)
    8000101a:	c105                	beqz	a0,8000103a <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000101c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000101e:	0117f693          	andi	a3,a5,17
    80001022:	4745                	li	a4,17
    return 0;
    80001024:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001026:	00e68663          	beq	a3,a4,80001032 <walkaddr+0x32>
}
    8000102a:	60a2                	ld	ra,8(sp)
    8000102c:	6402                	ld	s0,0(sp)
    8000102e:	0141                	addi	sp,sp,16
    80001030:	8082                	ret
  pa = PTE2PA(*pte);
    80001032:	83a9                	srli	a5,a5,0xa
    80001034:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001038:	bfcd                	j	8000102a <walkaddr+0x2a>
    return 0;
    8000103a:	4501                	li	a0,0
    8000103c:	b7fd                	j	8000102a <walkaddr+0x2a>

000000008000103e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000103e:	715d                	addi	sp,sp,-80
    80001040:	e486                	sd	ra,72(sp)
    80001042:	e0a2                	sd	s0,64(sp)
    80001044:	fc26                	sd	s1,56(sp)
    80001046:	f84a                	sd	s2,48(sp)
    80001048:	f44e                	sd	s3,40(sp)
    8000104a:	f052                	sd	s4,32(sp)
    8000104c:	ec56                	sd	s5,24(sp)
    8000104e:	e85a                	sd	s6,16(sp)
    80001050:	e45e                	sd	s7,8(sp)
    80001052:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001054:	03459793          	slli	a5,a1,0x34
    80001058:	e7a9                	bnez	a5,800010a2 <mappages+0x64>
    8000105a:	8aaa                	mv	s5,a0
    8000105c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000105e:	03461793          	slli	a5,a2,0x34
    80001062:	e7b1                	bnez	a5,800010ae <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001064:	ca39                	beqz	a2,800010ba <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001066:	77fd                	lui	a5,0xfffff
    80001068:	963e                	add	a2,a2,a5
    8000106a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000106e:	892e                	mv	s2,a1
    80001070:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001074:	6b85                	lui	s7,0x1
    80001076:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	4605                	li	a2,1
    8000107c:	85ca                	mv	a1,s2
    8000107e:	8556                	mv	a0,s5
    80001080:	ee7ff0ef          	jal	80000f66 <walk>
    80001084:	c539                	beqz	a0,800010d2 <mappages+0x94>
    if(*pte & PTE_V)
    80001086:	611c                	ld	a5,0(a0)
    80001088:	8b85                	andi	a5,a5,1
    8000108a:	ef95                	bnez	a5,800010c6 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000108c:	80b1                	srli	s1,s1,0xc
    8000108e:	04aa                	slli	s1,s1,0xa
    80001090:	0164e4b3          	or	s1,s1,s6
    80001094:	0014e493          	ori	s1,s1,1
    80001098:	e104                	sd	s1,0(a0)
    if(a == last)
    8000109a:	05390863          	beq	s2,s3,800010ea <mappages+0xac>
    a += PGSIZE;
    8000109e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a0:	bfd9                	j	80001076 <mappages+0x38>
    panic("mappages: va not aligned");
    800010a2:	00006517          	auipc	a0,0x6
    800010a6:	11650513          	addi	a0,a0,278 # 800071b8 <etext+0x1b8>
    800010aa:	eeaff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    800010ae:	00006517          	auipc	a0,0x6
    800010b2:	12a50513          	addi	a0,a0,298 # 800071d8 <etext+0x1d8>
    800010b6:	edeff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    800010ba:	00006517          	auipc	a0,0x6
    800010be:	13e50513          	addi	a0,a0,318 # 800071f8 <etext+0x1f8>
    800010c2:	ed2ff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    800010c6:	00006517          	auipc	a0,0x6
    800010ca:	14250513          	addi	a0,a0,322 # 80007208 <etext+0x208>
    800010ce:	ec6ff0ef          	jal	80000794 <panic>
      return -1;
    800010d2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010d4:	60a6                	ld	ra,72(sp)
    800010d6:	6406                	ld	s0,64(sp)
    800010d8:	74e2                	ld	s1,56(sp)
    800010da:	7942                	ld	s2,48(sp)
    800010dc:	79a2                	ld	s3,40(sp)
    800010de:	7a02                	ld	s4,32(sp)
    800010e0:	6ae2                	ld	s5,24(sp)
    800010e2:	6b42                	ld	s6,16(sp)
    800010e4:	6ba2                	ld	s7,8(sp)
    800010e6:	6161                	addi	sp,sp,80
    800010e8:	8082                	ret
  return 0;
    800010ea:	4501                	li	a0,0
    800010ec:	b7e5                	j	800010d4 <mappages+0x96>

00000000800010ee <kvmmap>:
{
    800010ee:	1141                	addi	sp,sp,-16
    800010f0:	e406                	sd	ra,8(sp)
    800010f2:	e022                	sd	s0,0(sp)
    800010f4:	0800                	addi	s0,sp,16
    800010f6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010f8:	86b2                	mv	a3,a2
    800010fa:	863e                	mv	a2,a5
    800010fc:	f43ff0ef          	jal	8000103e <mappages>
    80001100:	e509                	bnez	a0,8000110a <kvmmap+0x1c>
}
    80001102:	60a2                	ld	ra,8(sp)
    80001104:	6402                	ld	s0,0(sp)
    80001106:	0141                	addi	sp,sp,16
    80001108:	8082                	ret
    panic("kvmmap");
    8000110a:	00006517          	auipc	a0,0x6
    8000110e:	10e50513          	addi	a0,a0,270 # 80007218 <etext+0x218>
    80001112:	e82ff0ef          	jal	80000794 <panic>

0000000080001116 <kvmmake>:
{
    80001116:	1101                	addi	sp,sp,-32
    80001118:	ec06                	sd	ra,24(sp)
    8000111a:	e822                	sd	s0,16(sp)
    8000111c:	e426                	sd	s1,8(sp)
    8000111e:	e04a                	sd	s2,0(sp)
    80001120:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001122:	a03ff0ef          	jal	80000b24 <kalloc>
    80001126:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001128:	6605                	lui	a2,0x1
    8000112a:	4581                	li	a1,0
    8000112c:	b9dff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001130:	4719                	li	a4,6
    80001132:	6685                	lui	a3,0x1
    80001134:	10000637          	lui	a2,0x10000
    80001138:	100005b7          	lui	a1,0x10000
    8000113c:	8526                	mv	a0,s1
    8000113e:	fb1ff0ef          	jal	800010ee <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001142:	4719                	li	a4,6
    80001144:	6685                	lui	a3,0x1
    80001146:	10001637          	lui	a2,0x10001
    8000114a:	100015b7          	lui	a1,0x10001
    8000114e:	8526                	mv	a0,s1
    80001150:	f9fff0ef          	jal	800010ee <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001154:	4719                	li	a4,6
    80001156:	040006b7          	lui	a3,0x4000
    8000115a:	0c000637          	lui	a2,0xc000
    8000115e:	0c0005b7          	lui	a1,0xc000
    80001162:	8526                	mv	a0,s1
    80001164:	f8bff0ef          	jal	800010ee <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001168:	00006917          	auipc	s2,0x6
    8000116c:	e9890913          	addi	s2,s2,-360 # 80007000 <etext>
    80001170:	4729                	li	a4,10
    80001172:	80006697          	auipc	a3,0x80006
    80001176:	e8e68693          	addi	a3,a3,-370 # 7000 <_entry-0x7fff9000>
    8000117a:	4605                	li	a2,1
    8000117c:	067e                	slli	a2,a2,0x1f
    8000117e:	85b2                	mv	a1,a2
    80001180:	8526                	mv	a0,s1
    80001182:	f6dff0ef          	jal	800010ee <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001186:	46c5                	li	a3,17
    80001188:	06ee                	slli	a3,a3,0x1b
    8000118a:	4719                	li	a4,6
    8000118c:	412686b3          	sub	a3,a3,s2
    80001190:	864a                	mv	a2,s2
    80001192:	85ca                	mv	a1,s2
    80001194:	8526                	mv	a0,s1
    80001196:	f59ff0ef          	jal	800010ee <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000119a:	4729                	li	a4,10
    8000119c:	6685                	lui	a3,0x1
    8000119e:	00005617          	auipc	a2,0x5
    800011a2:	e6260613          	addi	a2,a2,-414 # 80006000 <_trampoline>
    800011a6:	040005b7          	lui	a1,0x4000
    800011aa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011ac:	05b2                	slli	a1,a1,0xc
    800011ae:	8526                	mv	a0,s1
    800011b0:	f3fff0ef          	jal	800010ee <kvmmap>
  proc_mapstacks(kpgtbl);
    800011b4:	8526                	mv	a0,s1
    800011b6:	5da000ef          	jal	80001790 <proc_mapstacks>
}
    800011ba:	8526                	mv	a0,s1
    800011bc:	60e2                	ld	ra,24(sp)
    800011be:	6442                	ld	s0,16(sp)
    800011c0:	64a2                	ld	s1,8(sp)
    800011c2:	6902                	ld	s2,0(sp)
    800011c4:	6105                	addi	sp,sp,32
    800011c6:	8082                	ret

00000000800011c8 <kvminit>:
{
    800011c8:	1141                	addi	sp,sp,-16
    800011ca:	e406                	sd	ra,8(sp)
    800011cc:	e022                	sd	s0,0(sp)
    800011ce:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011d0:	f47ff0ef          	jal	80001116 <kvmmake>
    800011d4:	00007797          	auipc	a5,0x7
    800011d8:	8aa7be23          	sd	a0,-1860(a5) # 80007a90 <kernel_pagetable>
}
    800011dc:	60a2                	ld	ra,8(sp)
    800011de:	6402                	ld	s0,0(sp)
    800011e0:	0141                	addi	sp,sp,16
    800011e2:	8082                	ret

00000000800011e4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e4:	715d                	addi	sp,sp,-80
    800011e6:	e486                	sd	ra,72(sp)
    800011e8:	e0a2                	sd	s0,64(sp)
    800011ea:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011ec:	03459793          	slli	a5,a1,0x34
    800011f0:	e39d                	bnez	a5,80001216 <uvmunmap+0x32>
    800011f2:	f84a                	sd	s2,48(sp)
    800011f4:	f44e                	sd	s3,40(sp)
    800011f6:	f052                	sd	s4,32(sp)
    800011f8:	ec56                	sd	s5,24(sp)
    800011fa:	e85a                	sd	s6,16(sp)
    800011fc:	e45e                	sd	s7,8(sp)
    800011fe:	8a2a                	mv	s4,a0
    80001200:	892e                	mv	s2,a1
    80001202:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001204:	0632                	slli	a2,a2,0xc
    80001206:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000120a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000120c:	6b05                	lui	s6,0x1
    8000120e:	0735ff63          	bgeu	a1,s3,8000128c <uvmunmap+0xa8>
    80001212:	fc26                	sd	s1,56(sp)
    80001214:	a0a9                	j	8000125e <uvmunmap+0x7a>
    80001216:	fc26                	sd	s1,56(sp)
    80001218:	f84a                	sd	s2,48(sp)
    8000121a:	f44e                	sd	s3,40(sp)
    8000121c:	f052                	sd	s4,32(sp)
    8000121e:	ec56                	sd	s5,24(sp)
    80001220:	e85a                	sd	s6,16(sp)
    80001222:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001224:	00006517          	auipc	a0,0x6
    80001228:	ffc50513          	addi	a0,a0,-4 # 80007220 <etext+0x220>
    8000122c:	d68ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001230:	00006517          	auipc	a0,0x6
    80001234:	00850513          	addi	a0,a0,8 # 80007238 <etext+0x238>
    80001238:	d5cff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    8000123c:	00006517          	auipc	a0,0x6
    80001240:	00c50513          	addi	a0,a0,12 # 80007248 <etext+0x248>
    80001244:	d50ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    80001248:	00006517          	auipc	a0,0x6
    8000124c:	01850513          	addi	a0,a0,24 # 80007260 <etext+0x260>
    80001250:	d44ff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001254:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001258:	995a                	add	s2,s2,s6
    8000125a:	03397863          	bgeu	s2,s3,8000128a <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000125e:	4601                	li	a2,0
    80001260:	85ca                	mv	a1,s2
    80001262:	8552                	mv	a0,s4
    80001264:	d03ff0ef          	jal	80000f66 <walk>
    80001268:	84aa                	mv	s1,a0
    8000126a:	d179                	beqz	a0,80001230 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000126c:	6108                	ld	a0,0(a0)
    8000126e:	00157793          	andi	a5,a0,1
    80001272:	d7e9                	beqz	a5,8000123c <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001274:	3ff57793          	andi	a5,a0,1023
    80001278:	fd7788e3          	beq	a5,s7,80001248 <uvmunmap+0x64>
    if(do_free){
    8000127c:	fc0a8ce3          	beqz	s5,80001254 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001280:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001282:	0532                	slli	a0,a0,0xc
    80001284:	fbeff0ef          	jal	80000a42 <kfree>
    80001288:	b7f1                	j	80001254 <uvmunmap+0x70>
    8000128a:	74e2                	ld	s1,56(sp)
    8000128c:	7942                	ld	s2,48(sp)
    8000128e:	79a2                	ld	s3,40(sp)
    80001290:	7a02                	ld	s4,32(sp)
    80001292:	6ae2                	ld	s5,24(sp)
    80001294:	6b42                	ld	s6,16(sp)
    80001296:	6ba2                	ld	s7,8(sp)
  }
}
    80001298:	60a6                	ld	ra,72(sp)
    8000129a:	6406                	ld	s0,64(sp)
    8000129c:	6161                	addi	sp,sp,80
    8000129e:	8082                	ret

00000000800012a0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800012a0:	1101                	addi	sp,sp,-32
    800012a2:	ec06                	sd	ra,24(sp)
    800012a4:	e822                	sd	s0,16(sp)
    800012a6:	e426                	sd	s1,8(sp)
    800012a8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012aa:	87bff0ef          	jal	80000b24 <kalloc>
    800012ae:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012b0:	c509                	beqz	a0,800012ba <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012b2:	6605                	lui	a2,0x1
    800012b4:	4581                	li	a1,0
    800012b6:	a13ff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    800012ba:	8526                	mv	a0,s1
    800012bc:	60e2                	ld	ra,24(sp)
    800012be:	6442                	ld	s0,16(sp)
    800012c0:	64a2                	ld	s1,8(sp)
    800012c2:	6105                	addi	sp,sp,32
    800012c4:	8082                	ret

00000000800012c6 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012c6:	7179                	addi	sp,sp,-48
    800012c8:	f406                	sd	ra,40(sp)
    800012ca:	f022                	sd	s0,32(sp)
    800012cc:	ec26                	sd	s1,24(sp)
    800012ce:	e84a                	sd	s2,16(sp)
    800012d0:	e44e                	sd	s3,8(sp)
    800012d2:	e052                	sd	s4,0(sp)
    800012d4:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012d6:	6785                	lui	a5,0x1
    800012d8:	04f67063          	bgeu	a2,a5,80001318 <uvmfirst+0x52>
    800012dc:	8a2a                	mv	s4,a0
    800012de:	89ae                	mv	s3,a1
    800012e0:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012e2:	843ff0ef          	jal	80000b24 <kalloc>
    800012e6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012e8:	6605                	lui	a2,0x1
    800012ea:	4581                	li	a1,0
    800012ec:	9ddff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012f0:	4779                	li	a4,30
    800012f2:	86ca                	mv	a3,s2
    800012f4:	6605                	lui	a2,0x1
    800012f6:	4581                	li	a1,0
    800012f8:	8552                	mv	a0,s4
    800012fa:	d45ff0ef          	jal	8000103e <mappages>
  memmove(mem, src, sz);
    800012fe:	8626                	mv	a2,s1
    80001300:	85ce                	mv	a1,s3
    80001302:	854a                	mv	a0,s2
    80001304:	a21ff0ef          	jal	80000d24 <memmove>
}
    80001308:	70a2                	ld	ra,40(sp)
    8000130a:	7402                	ld	s0,32(sp)
    8000130c:	64e2                	ld	s1,24(sp)
    8000130e:	6942                	ld	s2,16(sp)
    80001310:	69a2                	ld	s3,8(sp)
    80001312:	6a02                	ld	s4,0(sp)
    80001314:	6145                	addi	sp,sp,48
    80001316:	8082                	ret
    panic("uvmfirst: more than a page");
    80001318:	00006517          	auipc	a0,0x6
    8000131c:	f6050513          	addi	a0,a0,-160 # 80007278 <etext+0x278>
    80001320:	c74ff0ef          	jal	80000794 <panic>

0000000080001324 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001324:	1101                	addi	sp,sp,-32
    80001326:	ec06                	sd	ra,24(sp)
    80001328:	e822                	sd	s0,16(sp)
    8000132a:	e426                	sd	s1,8(sp)
    8000132c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000132e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001330:	00b67d63          	bgeu	a2,a1,8000134a <uvmdealloc+0x26>
    80001334:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001336:	6785                	lui	a5,0x1
    80001338:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000133a:	00f60733          	add	a4,a2,a5
    8000133e:	76fd                	lui	a3,0xfffff
    80001340:	8f75                	and	a4,a4,a3
    80001342:	97ae                	add	a5,a5,a1
    80001344:	8ff5                	and	a5,a5,a3
    80001346:	00f76863          	bltu	a4,a5,80001356 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001356:	8f99                	sub	a5,a5,a4
    80001358:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000135a:	4685                	li	a3,1
    8000135c:	0007861b          	sext.w	a2,a5
    80001360:	85ba                	mv	a1,a4
    80001362:	e83ff0ef          	jal	800011e4 <uvmunmap>
    80001366:	b7d5                	j	8000134a <uvmdealloc+0x26>

0000000080001368 <uvmalloc>:
  if(newsz < oldsz)
    80001368:	08b66f63          	bltu	a2,a1,80001406 <uvmalloc+0x9e>
{
    8000136c:	7139                	addi	sp,sp,-64
    8000136e:	fc06                	sd	ra,56(sp)
    80001370:	f822                	sd	s0,48(sp)
    80001372:	ec4e                	sd	s3,24(sp)
    80001374:	e852                	sd	s4,16(sp)
    80001376:	e456                	sd	s5,8(sp)
    80001378:	0080                	addi	s0,sp,64
    8000137a:	8aaa                	mv	s5,a0
    8000137c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000137e:	6785                	lui	a5,0x1
    80001380:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001382:	95be                	add	a1,a1,a5
    80001384:	77fd                	lui	a5,0xfffff
    80001386:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000138a:	08c9f063          	bgeu	s3,a2,8000140a <uvmalloc+0xa2>
    8000138e:	f426                	sd	s1,40(sp)
    80001390:	f04a                	sd	s2,32(sp)
    80001392:	e05a                	sd	s6,0(sp)
    80001394:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001396:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000139a:	f8aff0ef          	jal	80000b24 <kalloc>
    8000139e:	84aa                	mv	s1,a0
    if(mem == 0){
    800013a0:	c515                	beqz	a0,800013cc <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013a2:	6605                	lui	a2,0x1
    800013a4:	4581                	li	a1,0
    800013a6:	923ff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013aa:	875a                	mv	a4,s6
    800013ac:	86a6                	mv	a3,s1
    800013ae:	6605                	lui	a2,0x1
    800013b0:	85ca                	mv	a1,s2
    800013b2:	8556                	mv	a0,s5
    800013b4:	c8bff0ef          	jal	8000103e <mappages>
    800013b8:	e915                	bnez	a0,800013ec <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013ba:	6785                	lui	a5,0x1
    800013bc:	993e                	add	s2,s2,a5
    800013be:	fd496ee3          	bltu	s2,s4,8000139a <uvmalloc+0x32>
  return newsz;
    800013c2:	8552                	mv	a0,s4
    800013c4:	74a2                	ld	s1,40(sp)
    800013c6:	7902                	ld	s2,32(sp)
    800013c8:	6b02                	ld	s6,0(sp)
    800013ca:	a811                	j	800013de <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013cc:	864e                	mv	a2,s3
    800013ce:	85ca                	mv	a1,s2
    800013d0:	8556                	mv	a0,s5
    800013d2:	f53ff0ef          	jal	80001324 <uvmdealloc>
      return 0;
    800013d6:	4501                	li	a0,0
    800013d8:	74a2                	ld	s1,40(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	6b02                	ld	s6,0(sp)
}
    800013de:	70e2                	ld	ra,56(sp)
    800013e0:	7442                	ld	s0,48(sp)
    800013e2:	69e2                	ld	s3,24(sp)
    800013e4:	6a42                	ld	s4,16(sp)
    800013e6:	6aa2                	ld	s5,8(sp)
    800013e8:	6121                	addi	sp,sp,64
    800013ea:	8082                	ret
      kfree(mem);
    800013ec:	8526                	mv	a0,s1
    800013ee:	e54ff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013f2:	864e                	mv	a2,s3
    800013f4:	85ca                	mv	a1,s2
    800013f6:	8556                	mv	a0,s5
    800013f8:	f2dff0ef          	jal	80001324 <uvmdealloc>
      return 0;
    800013fc:	4501                	li	a0,0
    800013fe:	74a2                	ld	s1,40(sp)
    80001400:	7902                	ld	s2,32(sp)
    80001402:	6b02                	ld	s6,0(sp)
    80001404:	bfe9                	j	800013de <uvmalloc+0x76>
    return oldsz;
    80001406:	852e                	mv	a0,a1
}
    80001408:	8082                	ret
  return newsz;
    8000140a:	8532                	mv	a0,a2
    8000140c:	bfc9                	j	800013de <uvmalloc+0x76>

000000008000140e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000140e:	7179                	addi	sp,sp,-48
    80001410:	f406                	sd	ra,40(sp)
    80001412:	f022                	sd	s0,32(sp)
    80001414:	ec26                	sd	s1,24(sp)
    80001416:	e84a                	sd	s2,16(sp)
    80001418:	e44e                	sd	s3,8(sp)
    8000141a:	e052                	sd	s4,0(sp)
    8000141c:	1800                	addi	s0,sp,48
    8000141e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001420:	84aa                	mv	s1,a0
    80001422:	6905                	lui	s2,0x1
    80001424:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001426:	4985                	li	s3,1
    80001428:	a819                	j	8000143e <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000142a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000142c:	00c79513          	slli	a0,a5,0xc
    80001430:	fdfff0ef          	jal	8000140e <freewalk>
      pagetable[i] = 0;
    80001434:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001438:	04a1                	addi	s1,s1,8
    8000143a:	01248f63          	beq	s1,s2,80001458 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000143e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001440:	00f7f713          	andi	a4,a5,15
    80001444:	ff3703e3          	beq	a4,s3,8000142a <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001448:	8b85                	andi	a5,a5,1
    8000144a:	d7fd                	beqz	a5,80001438 <freewalk+0x2a>
      panic("freewalk: leaf");
    8000144c:	00006517          	auipc	a0,0x6
    80001450:	e4c50513          	addi	a0,a0,-436 # 80007298 <etext+0x298>
    80001454:	b40ff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    80001458:	8552                	mv	a0,s4
    8000145a:	de8ff0ef          	jal	80000a42 <kfree>
}
    8000145e:	70a2                	ld	ra,40(sp)
    80001460:	7402                	ld	s0,32(sp)
    80001462:	64e2                	ld	s1,24(sp)
    80001464:	6942                	ld	s2,16(sp)
    80001466:	69a2                	ld	s3,8(sp)
    80001468:	6a02                	ld	s4,0(sp)
    8000146a:	6145                	addi	sp,sp,48
    8000146c:	8082                	ret

000000008000146e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000146e:	1101                	addi	sp,sp,-32
    80001470:	ec06                	sd	ra,24(sp)
    80001472:	e822                	sd	s0,16(sp)
    80001474:	e426                	sd	s1,8(sp)
    80001476:	1000                	addi	s0,sp,32
    80001478:	84aa                	mv	s1,a0
  if(sz > 0)
    8000147a:	e989                	bnez	a1,8000148c <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000147c:	8526                	mv	a0,s1
    8000147e:	f91ff0ef          	jal	8000140e <freewalk>
}
    80001482:	60e2                	ld	ra,24(sp)
    80001484:	6442                	ld	s0,16(sp)
    80001486:	64a2                	ld	s1,8(sp)
    80001488:	6105                	addi	sp,sp,32
    8000148a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000148c:	6785                	lui	a5,0x1
    8000148e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001490:	95be                	add	a1,a1,a5
    80001492:	4685                	li	a3,1
    80001494:	00c5d613          	srli	a2,a1,0xc
    80001498:	4581                	li	a1,0
    8000149a:	d4bff0ef          	jal	800011e4 <uvmunmap>
    8000149e:	bff9                	j	8000147c <uvmfree+0xe>

00000000800014a0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014a0:	c65d                	beqz	a2,8000154e <uvmcopy+0xae>
{
    800014a2:	715d                	addi	sp,sp,-80
    800014a4:	e486                	sd	ra,72(sp)
    800014a6:	e0a2                	sd	s0,64(sp)
    800014a8:	fc26                	sd	s1,56(sp)
    800014aa:	f84a                	sd	s2,48(sp)
    800014ac:	f44e                	sd	s3,40(sp)
    800014ae:	f052                	sd	s4,32(sp)
    800014b0:	ec56                	sd	s5,24(sp)
    800014b2:	e85a                	sd	s6,16(sp)
    800014b4:	e45e                	sd	s7,8(sp)
    800014b6:	0880                	addi	s0,sp,80
    800014b8:	8b2a                	mv	s6,a0
    800014ba:	8aae                	mv	s5,a1
    800014bc:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014be:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014c0:	4601                	li	a2,0
    800014c2:	85ce                	mv	a1,s3
    800014c4:	855a                	mv	a0,s6
    800014c6:	aa1ff0ef          	jal	80000f66 <walk>
    800014ca:	c121                	beqz	a0,8000150a <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014cc:	6118                	ld	a4,0(a0)
    800014ce:	00177793          	andi	a5,a4,1
    800014d2:	c3b1                	beqz	a5,80001516 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014d4:	00a75593          	srli	a1,a4,0xa
    800014d8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014dc:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014e0:	e44ff0ef          	jal	80000b24 <kalloc>
    800014e4:	892a                	mv	s2,a0
    800014e6:	c129                	beqz	a0,80001528 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014e8:	6605                	lui	a2,0x1
    800014ea:	85de                	mv	a1,s7
    800014ec:	839ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014f0:	8726                	mv	a4,s1
    800014f2:	86ca                	mv	a3,s2
    800014f4:	6605                	lui	a2,0x1
    800014f6:	85ce                	mv	a1,s3
    800014f8:	8556                	mv	a0,s5
    800014fa:	b45ff0ef          	jal	8000103e <mappages>
    800014fe:	e115                	bnez	a0,80001522 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80001500:	6785                	lui	a5,0x1
    80001502:	99be                	add	s3,s3,a5
    80001504:	fb49eee3          	bltu	s3,s4,800014c0 <uvmcopy+0x20>
    80001508:	a805                	j	80001538 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    8000150a:	00006517          	auipc	a0,0x6
    8000150e:	d9e50513          	addi	a0,a0,-610 # 800072a8 <etext+0x2a8>
    80001512:	a82ff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    80001516:	00006517          	auipc	a0,0x6
    8000151a:	db250513          	addi	a0,a0,-590 # 800072c8 <etext+0x2c8>
    8000151e:	a76ff0ef          	jal	80000794 <panic>
      kfree(mem);
    80001522:	854a                	mv	a0,s2
    80001524:	d1eff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001528:	4685                	li	a3,1
    8000152a:	00c9d613          	srli	a2,s3,0xc
    8000152e:	4581                	li	a1,0
    80001530:	8556                	mv	a0,s5
    80001532:	cb3ff0ef          	jal	800011e4 <uvmunmap>
  return -1;
    80001536:	557d                	li	a0,-1
}
    80001538:	60a6                	ld	ra,72(sp)
    8000153a:	6406                	ld	s0,64(sp)
    8000153c:	74e2                	ld	s1,56(sp)
    8000153e:	7942                	ld	s2,48(sp)
    80001540:	79a2                	ld	s3,40(sp)
    80001542:	7a02                	ld	s4,32(sp)
    80001544:	6ae2                	ld	s5,24(sp)
    80001546:	6b42                	ld	s6,16(sp)
    80001548:	6ba2                	ld	s7,8(sp)
    8000154a:	6161                	addi	sp,sp,80
    8000154c:	8082                	ret
  return 0;
    8000154e:	4501                	li	a0,0
}
    80001550:	8082                	ret

0000000080001552 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001552:	1141                	addi	sp,sp,-16
    80001554:	e406                	sd	ra,8(sp)
    80001556:	e022                	sd	s0,0(sp)
    80001558:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000155a:	4601                	li	a2,0
    8000155c:	a0bff0ef          	jal	80000f66 <walk>
  if(pte == 0)
    80001560:	c901                	beqz	a0,80001570 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001562:	611c                	ld	a5,0(a0)
    80001564:	9bbd                	andi	a5,a5,-17
    80001566:	e11c                	sd	a5,0(a0)
}
    80001568:	60a2                	ld	ra,8(sp)
    8000156a:	6402                	ld	s0,0(sp)
    8000156c:	0141                	addi	sp,sp,16
    8000156e:	8082                	ret
    panic("uvmclear");
    80001570:	00006517          	auipc	a0,0x6
    80001574:	d7850513          	addi	a0,a0,-648 # 800072e8 <etext+0x2e8>
    80001578:	a1cff0ef          	jal	80000794 <panic>

000000008000157c <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    8000157c:	cad1                	beqz	a3,80001610 <copyout+0x94>
{
    8000157e:	711d                	addi	sp,sp,-96
    80001580:	ec86                	sd	ra,88(sp)
    80001582:	e8a2                	sd	s0,80(sp)
    80001584:	e4a6                	sd	s1,72(sp)
    80001586:	fc4e                	sd	s3,56(sp)
    80001588:	f456                	sd	s5,40(sp)
    8000158a:	f05a                	sd	s6,32(sp)
    8000158c:	ec5e                	sd	s7,24(sp)
    8000158e:	1080                	addi	s0,sp,96
    80001590:	8baa                	mv	s7,a0
    80001592:	8aae                	mv	s5,a1
    80001594:	8b32                	mv	s6,a2
    80001596:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001598:	74fd                	lui	s1,0xfffff
    8000159a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    8000159c:	57fd                	li	a5,-1
    8000159e:	83e9                	srli	a5,a5,0x1a
    800015a0:	0697ea63          	bltu	a5,s1,80001614 <copyout+0x98>
    800015a4:	e0ca                	sd	s2,64(sp)
    800015a6:	f852                	sd	s4,48(sp)
    800015a8:	e862                	sd	s8,16(sp)
    800015aa:	e466                	sd	s9,8(sp)
    800015ac:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ae:	4cd5                	li	s9,21
    800015b0:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800015b2:	8c3e                	mv	s8,a5
    800015b4:	a025                	j	800015dc <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800015b6:	83a9                	srli	a5,a5,0xa
    800015b8:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015ba:	409a8533          	sub	a0,s5,s1
    800015be:	0009061b          	sext.w	a2,s2
    800015c2:	85da                	mv	a1,s6
    800015c4:	953e                	add	a0,a0,a5
    800015c6:	f5eff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015ca:	412989b3          	sub	s3,s3,s2
    src += n;
    800015ce:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015d0:	02098963          	beqz	s3,80001602 <copyout+0x86>
    if(va0 >= MAXVA)
    800015d4:	054c6263          	bltu	s8,s4,80001618 <copyout+0x9c>
    800015d8:	84d2                	mv	s1,s4
    800015da:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015dc:	4601                	li	a2,0
    800015de:	85a6                	mv	a1,s1
    800015e0:	855e                	mv	a0,s7
    800015e2:	985ff0ef          	jal	80000f66 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015e6:	c121                	beqz	a0,80001626 <copyout+0xaa>
    800015e8:	611c                	ld	a5,0(a0)
    800015ea:	0157f713          	andi	a4,a5,21
    800015ee:	05971b63          	bne	a4,s9,80001644 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015f2:	01a48a33          	add	s4,s1,s10
    800015f6:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015fa:	fb29fee3          	bgeu	s3,s2,800015b6 <copyout+0x3a>
    800015fe:	894e                	mv	s2,s3
    80001600:	bf5d                	j	800015b6 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80001602:	4501                	li	a0,0
    80001604:	6906                	ld	s2,64(sp)
    80001606:	7a42                	ld	s4,48(sp)
    80001608:	6c42                	ld	s8,16(sp)
    8000160a:	6ca2                	ld	s9,8(sp)
    8000160c:	6d02                	ld	s10,0(sp)
    8000160e:	a015                	j	80001632 <copyout+0xb6>
    80001610:	4501                	li	a0,0
}
    80001612:	8082                	ret
      return -1;
    80001614:	557d                	li	a0,-1
    80001616:	a831                	j	80001632 <copyout+0xb6>
    80001618:	557d                	li	a0,-1
    8000161a:	6906                	ld	s2,64(sp)
    8000161c:	7a42                	ld	s4,48(sp)
    8000161e:	6c42                	ld	s8,16(sp)
    80001620:	6ca2                	ld	s9,8(sp)
    80001622:	6d02                	ld	s10,0(sp)
    80001624:	a039                	j	80001632 <copyout+0xb6>
      return -1;
    80001626:	557d                	li	a0,-1
    80001628:	6906                	ld	s2,64(sp)
    8000162a:	7a42                	ld	s4,48(sp)
    8000162c:	6c42                	ld	s8,16(sp)
    8000162e:	6ca2                	ld	s9,8(sp)
    80001630:	6d02                	ld	s10,0(sp)
}
    80001632:	60e6                	ld	ra,88(sp)
    80001634:	6446                	ld	s0,80(sp)
    80001636:	64a6                	ld	s1,72(sp)
    80001638:	79e2                	ld	s3,56(sp)
    8000163a:	7aa2                	ld	s5,40(sp)
    8000163c:	7b02                	ld	s6,32(sp)
    8000163e:	6be2                	ld	s7,24(sp)
    80001640:	6125                	addi	sp,sp,96
    80001642:	8082                	ret
      return -1;
    80001644:	557d                	li	a0,-1
    80001646:	6906                	ld	s2,64(sp)
    80001648:	7a42                	ld	s4,48(sp)
    8000164a:	6c42                	ld	s8,16(sp)
    8000164c:	6ca2                	ld	s9,8(sp)
    8000164e:	6d02                	ld	s10,0(sp)
    80001650:	b7cd                	j	80001632 <copyout+0xb6>

0000000080001652 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001652:	c6a5                	beqz	a3,800016ba <copyin+0x68>
{
    80001654:	715d                	addi	sp,sp,-80
    80001656:	e486                	sd	ra,72(sp)
    80001658:	e0a2                	sd	s0,64(sp)
    8000165a:	fc26                	sd	s1,56(sp)
    8000165c:	f84a                	sd	s2,48(sp)
    8000165e:	f44e                	sd	s3,40(sp)
    80001660:	f052                	sd	s4,32(sp)
    80001662:	ec56                	sd	s5,24(sp)
    80001664:	e85a                	sd	s6,16(sp)
    80001666:	e45e                	sd	s7,8(sp)
    80001668:	e062                	sd	s8,0(sp)
    8000166a:	0880                	addi	s0,sp,80
    8000166c:	8b2a                	mv	s6,a0
    8000166e:	8a2e                	mv	s4,a1
    80001670:	8c32                	mv	s8,a2
    80001672:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001674:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001676:	6a85                	lui	s5,0x1
    80001678:	a00d                	j	8000169a <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000167a:	018505b3          	add	a1,a0,s8
    8000167e:	0004861b          	sext.w	a2,s1
    80001682:	412585b3          	sub	a1,a1,s2
    80001686:	8552                	mv	a0,s4
    80001688:	e9cff0ef          	jal	80000d24 <memmove>

    len -= n;
    8000168c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001690:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001692:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001696:	02098063          	beqz	s3,800016b6 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    8000169a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000169e:	85ca                	mv	a1,s2
    800016a0:	855a                	mv	a0,s6
    800016a2:	95fff0ef          	jal	80001000 <walkaddr>
    if(pa0 == 0)
    800016a6:	cd01                	beqz	a0,800016be <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800016a8:	418904b3          	sub	s1,s2,s8
    800016ac:	94d6                	add	s1,s1,s5
    if(n > len)
    800016ae:	fc99f6e3          	bgeu	s3,s1,8000167a <copyin+0x28>
    800016b2:	84ce                	mv	s1,s3
    800016b4:	b7d9                	j	8000167a <copyin+0x28>
  }
  return 0;
    800016b6:	4501                	li	a0,0
    800016b8:	a021                	j	800016c0 <copyin+0x6e>
    800016ba:	4501                	li	a0,0
}
    800016bc:	8082                	ret
      return -1;
    800016be:	557d                	li	a0,-1
}
    800016c0:	60a6                	ld	ra,72(sp)
    800016c2:	6406                	ld	s0,64(sp)
    800016c4:	74e2                	ld	s1,56(sp)
    800016c6:	7942                	ld	s2,48(sp)
    800016c8:	79a2                	ld	s3,40(sp)
    800016ca:	7a02                	ld	s4,32(sp)
    800016cc:	6ae2                	ld	s5,24(sp)
    800016ce:	6b42                	ld	s6,16(sp)
    800016d0:	6ba2                	ld	s7,8(sp)
    800016d2:	6c02                	ld	s8,0(sp)
    800016d4:	6161                	addi	sp,sp,80
    800016d6:	8082                	ret

00000000800016d8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016d8:	c6dd                	beqz	a3,80001786 <copyinstr+0xae>
{
    800016da:	715d                	addi	sp,sp,-80
    800016dc:	e486                	sd	ra,72(sp)
    800016de:	e0a2                	sd	s0,64(sp)
    800016e0:	fc26                	sd	s1,56(sp)
    800016e2:	f84a                	sd	s2,48(sp)
    800016e4:	f44e                	sd	s3,40(sp)
    800016e6:	f052                	sd	s4,32(sp)
    800016e8:	ec56                	sd	s5,24(sp)
    800016ea:	e85a                	sd	s6,16(sp)
    800016ec:	e45e                	sd	s7,8(sp)
    800016ee:	0880                	addi	s0,sp,80
    800016f0:	8a2a                	mv	s4,a0
    800016f2:	8b2e                	mv	s6,a1
    800016f4:	8bb2                	mv	s7,a2
    800016f6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016f8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016fa:	6985                	lui	s3,0x1
    800016fc:	a825                	j	80001734 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016fe:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001702:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001704:	37fd                	addiw	a5,a5,-1
    80001706:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000170a:	60a6                	ld	ra,72(sp)
    8000170c:	6406                	ld	s0,64(sp)
    8000170e:	74e2                	ld	s1,56(sp)
    80001710:	7942                	ld	s2,48(sp)
    80001712:	79a2                	ld	s3,40(sp)
    80001714:	7a02                	ld	s4,32(sp)
    80001716:	6ae2                	ld	s5,24(sp)
    80001718:	6b42                	ld	s6,16(sp)
    8000171a:	6ba2                	ld	s7,8(sp)
    8000171c:	6161                	addi	sp,sp,80
    8000171e:	8082                	ret
    80001720:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001724:	9742                	add	a4,a4,a6
      --max;
    80001726:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    8000172a:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000172e:	04e58463          	beq	a1,a4,80001776 <copyinstr+0x9e>
{
    80001732:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001734:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001738:	85a6                	mv	a1,s1
    8000173a:	8552                	mv	a0,s4
    8000173c:	8c5ff0ef          	jal	80001000 <walkaddr>
    if(pa0 == 0)
    80001740:	cd0d                	beqz	a0,8000177a <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001742:	417486b3          	sub	a3,s1,s7
    80001746:	96ce                	add	a3,a3,s3
    if(n > max)
    80001748:	00d97363          	bgeu	s2,a3,8000174e <copyinstr+0x76>
    8000174c:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    8000174e:	955e                	add	a0,a0,s7
    80001750:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001752:	c695                	beqz	a3,8000177e <copyinstr+0xa6>
    80001754:	87da                	mv	a5,s6
    80001756:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001758:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000175c:	96da                	add	a3,a3,s6
    8000175e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001760:	00f60733          	add	a4,a2,a5
    80001764:	00074703          	lbu	a4,0(a4)
    80001768:	db59                	beqz	a4,800016fe <copyinstr+0x26>
        *dst = *p;
    8000176a:	00e78023          	sb	a4,0(a5)
      dst++;
    8000176e:	0785                	addi	a5,a5,1
    while(n > 0){
    80001770:	fed797e3          	bne	a5,a3,8000175e <copyinstr+0x86>
    80001774:	b775                	j	80001720 <copyinstr+0x48>
    80001776:	4781                	li	a5,0
    80001778:	b771                	j	80001704 <copyinstr+0x2c>
      return -1;
    8000177a:	557d                	li	a0,-1
    8000177c:	b779                	j	8000170a <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    8000177e:	6b85                	lui	s7,0x1
    80001780:	9ba6                	add	s7,s7,s1
    80001782:	87da                	mv	a5,s6
    80001784:	b77d                	j	80001732 <copyinstr+0x5a>
  int got_null = 0;
    80001786:	4781                	li	a5,0
  if(got_null){
    80001788:	37fd                	addiw	a5,a5,-1
    8000178a:	0007851b          	sext.w	a0,a5
}
    8000178e:	8082                	ret

0000000080001790 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001790:	7139                	addi	sp,sp,-64
    80001792:	fc06                	sd	ra,56(sp)
    80001794:	f822                	sd	s0,48(sp)
    80001796:	f426                	sd	s1,40(sp)
    80001798:	f04a                	sd	s2,32(sp)
    8000179a:	ec4e                	sd	s3,24(sp)
    8000179c:	e852                	sd	s4,16(sp)
    8000179e:	e456                	sd	s5,8(sp)
    800017a0:	e05a                	sd	s6,0(sp)
    800017a2:	0080                	addi	s0,sp,64
    800017a4:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a6:	0000f497          	auipc	s1,0xf
    800017aa:	85a48493          	addi	s1,s1,-1958 # 80010000 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017ae:	8b26                	mv	s6,s1
    800017b0:	bdef8937          	lui	s2,0xbdef8
    800017b4:	bdf90913          	addi	s2,s2,-1057 # ffffffffbdef7bdf <end+0xffffffff3ded4be7>
    800017b8:	093e                	slli	s2,s2,0xf
    800017ba:	bdf90913          	addi	s2,s2,-1057
    800017be:	093e                	slli	s2,s2,0xf
    800017c0:	bdf90913          	addi	s2,s2,-1057
    800017c4:	040009b7          	lui	s3,0x4000
    800017c8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017ca:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017cc:	00016a97          	auipc	s5,0x16
    800017d0:	434a8a93          	addi	s5,s5,1076 # 80017c00 <tickslock>
    char *pa = kalloc();
    800017d4:	b50ff0ef          	jal	80000b24 <kalloc>
    800017d8:	862a                	mv	a2,a0
    if(pa == 0)
    800017da:	cd15                	beqz	a0,80001816 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800017dc:	416485b3          	sub	a1,s1,s6
    800017e0:	8591                	srai	a1,a1,0x4
    800017e2:	032585b3          	mul	a1,a1,s2
    800017e6:	2585                	addiw	a1,a1,1
    800017e8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017ec:	4719                	li	a4,6
    800017ee:	6685                	lui	a3,0x1
    800017f0:	40b985b3          	sub	a1,s3,a1
    800017f4:	8552                	mv	a0,s4
    800017f6:	8f9ff0ef          	jal	800010ee <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017fa:	1f048493          	addi	s1,s1,496
    800017fe:	fd549be3          	bne	s1,s5,800017d4 <proc_mapstacks+0x44>
  }
}
    80001802:	70e2                	ld	ra,56(sp)
    80001804:	7442                	ld	s0,48(sp)
    80001806:	74a2                	ld	s1,40(sp)
    80001808:	7902                	ld	s2,32(sp)
    8000180a:	69e2                	ld	s3,24(sp)
    8000180c:	6a42                	ld	s4,16(sp)
    8000180e:	6aa2                	ld	s5,8(sp)
    80001810:	6b02                	ld	s6,0(sp)
    80001812:	6121                	addi	sp,sp,64
    80001814:	8082                	ret
      panic("kalloc");
    80001816:	00006517          	auipc	a0,0x6
    8000181a:	ae250513          	addi	a0,a0,-1310 # 800072f8 <etext+0x2f8>
    8000181e:	f77fe0ef          	jal	80000794 <panic>

0000000080001822 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001822:	7139                	addi	sp,sp,-64
    80001824:	fc06                	sd	ra,56(sp)
    80001826:	f822                	sd	s0,48(sp)
    80001828:	f426                	sd	s1,40(sp)
    8000182a:	f04a                	sd	s2,32(sp)
    8000182c:	ec4e                	sd	s3,24(sp)
    8000182e:	e852                	sd	s4,16(sp)
    80001830:	e456                	sd	s5,8(sp)
    80001832:	e05a                	sd	s6,0(sp)
    80001834:	0080                	addi	s0,sp,64
 

  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001836:	00006597          	auipc	a1,0x6
    8000183a:	aca58593          	addi	a1,a1,-1334 # 80007300 <etext+0x300>
    8000183e:	0000e517          	auipc	a0,0xe
    80001842:	39250513          	addi	a0,a0,914 # 8000fbd0 <pid_lock>
    80001846:	b2eff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000184a:	00006597          	auipc	a1,0x6
    8000184e:	abe58593          	addi	a1,a1,-1346 # 80007308 <etext+0x308>
    80001852:	0000e517          	auipc	a0,0xe
    80001856:	39650513          	addi	a0,a0,918 # 8000fbe8 <wait_lock>
    8000185a:	b1aff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185e:	0000e497          	auipc	s1,0xe
    80001862:	7a248493          	addi	s1,s1,1954 # 80010000 <proc>
      initlock(&p->lock, "proc");
    80001866:	00006b17          	auipc	s6,0x6
    8000186a:	ab2b0b13          	addi	s6,s6,-1358 # 80007318 <etext+0x318>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000186e:	8aa6                	mv	s5,s1
    80001870:	bdef8937          	lui	s2,0xbdef8
    80001874:	bdf90913          	addi	s2,s2,-1057 # ffffffffbdef7bdf <end+0xffffffff3ded4be7>
    80001878:	093e                	slli	s2,s2,0xf
    8000187a:	bdf90913          	addi	s2,s2,-1057
    8000187e:	093e                	slli	s2,s2,0xf
    80001880:	bdf90913          	addi	s2,s2,-1057
    80001884:	040009b7          	lui	s3,0x4000
    80001888:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000188a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188c:	00016a17          	auipc	s4,0x16
    80001890:	374a0a13          	addi	s4,s4,884 # 80017c00 <tickslock>
      initlock(&p->lock, "proc");
    80001894:	85da                	mv	a1,s6
    80001896:	8526                	mv	a0,s1
    80001898:	adcff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    8000189c:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018a0:	415487b3          	sub	a5,s1,s5
    800018a4:	8791                	srai	a5,a5,0x4
    800018a6:	032787b3          	mul	a5,a5,s2
    800018aa:	2785                	addiw	a5,a5,1
    800018ac:	00d7979b          	slliw	a5,a5,0xd
    800018b0:	40f987b3          	sub	a5,s3,a5
    800018b4:	e0bc                	sd	a5,64(s1)
      p->current_thread = 0; //Initialize current_thread to indicateno active thread
    800018b6:	1e04b423          	sd	zero,488(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ba:	1f048493          	addi	s1,s1,496
    800018be:	fd449be3          	bne	s1,s4,80001894 <procinit+0x72>
  }
}
    800018c2:	70e2                	ld	ra,56(sp)
    800018c4:	7442                	ld	s0,48(sp)
    800018c6:	74a2                	ld	s1,40(sp)
    800018c8:	7902                	ld	s2,32(sp)
    800018ca:	69e2                	ld	s3,24(sp)
    800018cc:	6a42                	ld	s4,16(sp)
    800018ce:	6aa2                	ld	s5,8(sp)
    800018d0:	6b02                	ld	s6,0(sp)
    800018d2:	6121                	addi	sp,sp,64
    800018d4:	8082                	ret

00000000800018d6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018d6:	1141                	addi	sp,sp,-16
    800018d8:	e422                	sd	s0,8(sp)
    800018da:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018dc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018de:	2501                	sext.w	a0,a0
    800018e0:	6422                	ld	s0,8(sp)
    800018e2:	0141                	addi	sp,sp,16
    800018e4:	8082                	ret

00000000800018e6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018e6:	1141                	addi	sp,sp,-16
    800018e8:	e422                	sd	s0,8(sp)
    800018ea:	0800                	addi	s0,sp,16
    800018ec:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018ee:	2781                	sext.w	a5,a5
    800018f0:	079e                	slli	a5,a5,0x7
  return c;
}
    800018f2:	0000e517          	auipc	a0,0xe
    800018f6:	30e50513          	addi	a0,a0,782 # 8000fc00 <cpus>
    800018fa:	953e                	add	a0,a0,a5
    800018fc:	6422                	ld	s0,8(sp)
    800018fe:	0141                	addi	sp,sp,16
    80001900:	8082                	ret

0000000080001902 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001902:	1101                	addi	sp,sp,-32
    80001904:	ec06                	sd	ra,24(sp)
    80001906:	e822                	sd	s0,16(sp)
    80001908:	e426                	sd	s1,8(sp)
    8000190a:	1000                	addi	s0,sp,32
  push_off();
    8000190c:	aa8ff0ef          	jal	80000bb4 <push_off>
    80001910:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001912:	2781                	sext.w	a5,a5
    80001914:	079e                	slli	a5,a5,0x7
    80001916:	0000e717          	auipc	a4,0xe
    8000191a:	2ba70713          	addi	a4,a4,698 # 8000fbd0 <pid_lock>
    8000191e:	97ba                	add	a5,a5,a4
    80001920:	7b84                	ld	s1,48(a5)
  pop_off();
    80001922:	b16ff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001926:	8526                	mv	a0,s1
    80001928:	60e2                	ld	ra,24(sp)
    8000192a:	6442                	ld	s0,16(sp)
    8000192c:	64a2                	ld	s1,8(sp)
    8000192e:	6105                	addi	sp,sp,32
    80001930:	8082                	ret

0000000080001932 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001932:	1141                	addi	sp,sp,-16
    80001934:	e406                	sd	ra,8(sp)
    80001936:	e022                	sd	s0,0(sp)
    80001938:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000193a:	fc9ff0ef          	jal	80001902 <myproc>
    8000193e:	b4eff0ef          	jal	80000c8c <release>

  if (first) {
    80001942:	00006797          	auipc	a5,0x6
    80001946:	0de7a783          	lw	a5,222(a5) # 80007a20 <first.1>
    8000194a:	e799                	bnez	a5,80001958 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000194c:	66b000ef          	jal	800027b6 <usertrapret>
}
    80001950:	60a2                	ld	ra,8(sp)
    80001952:	6402                	ld	s0,0(sp)
    80001954:	0141                	addi	sp,sp,16
    80001956:	8082                	ret
    fsinit(ROOTDEV);
    80001958:	4505                	li	a0,1
    8000195a:	2b3010ef          	jal	8000340c <fsinit>
    first = 0;
    8000195e:	00006797          	auipc	a5,0x6
    80001962:	0c07a123          	sw	zero,194(a5) # 80007a20 <first.1>
    __sync_synchronize();
    80001966:	0ff0000f          	fence
    8000196a:	b7cd                	j	8000194c <forkret+0x1a>

000000008000196c <allocpid>:
{
    8000196c:	1101                	addi	sp,sp,-32
    8000196e:	ec06                	sd	ra,24(sp)
    80001970:	e822                	sd	s0,16(sp)
    80001972:	e426                	sd	s1,8(sp)
    80001974:	e04a                	sd	s2,0(sp)
    80001976:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001978:	0000e917          	auipc	s2,0xe
    8000197c:	25890913          	addi	s2,s2,600 # 8000fbd0 <pid_lock>
    80001980:	854a                	mv	a0,s2
    80001982:	a72ff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    80001986:	00006797          	auipc	a5,0x6
    8000198a:	09e78793          	addi	a5,a5,158 # 80007a24 <nextpid>
    8000198e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001990:	0014871b          	addiw	a4,s1,1
    80001994:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001996:	854a                	mv	a0,s2
    80001998:	af4ff0ef          	jal	80000c8c <release>
}
    8000199c:	8526                	mv	a0,s1
    8000199e:	60e2                	ld	ra,24(sp)
    800019a0:	6442                	ld	s0,16(sp)
    800019a2:	64a2                	ld	s1,8(sp)
    800019a4:	6902                	ld	s2,0(sp)
    800019a6:	6105                	addi	sp,sp,32
    800019a8:	8082                	ret

00000000800019aa <proc_pagetable>:
{
    800019aa:	1101                	addi	sp,sp,-32
    800019ac:	ec06                	sd	ra,24(sp)
    800019ae:	e822                	sd	s0,16(sp)
    800019b0:	e426                	sd	s1,8(sp)
    800019b2:	e04a                	sd	s2,0(sp)
    800019b4:	1000                	addi	s0,sp,32
    800019b6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019b8:	8e9ff0ef          	jal	800012a0 <uvmcreate>
    800019bc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019be:	cd05                	beqz	a0,800019f6 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019c0:	4729                	li	a4,10
    800019c2:	00004697          	auipc	a3,0x4
    800019c6:	63e68693          	addi	a3,a3,1598 # 80006000 <_trampoline>
    800019ca:	6605                	lui	a2,0x1
    800019cc:	040005b7          	lui	a1,0x4000
    800019d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019d2:	05b2                	slli	a1,a1,0xc
    800019d4:	e6aff0ef          	jal	8000103e <mappages>
    800019d8:	02054663          	bltz	a0,80001a04 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019dc:	4719                	li	a4,6
    800019de:	05893683          	ld	a3,88(s2)
    800019e2:	6605                	lui	a2,0x1
    800019e4:	020005b7          	lui	a1,0x2000
    800019e8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019ea:	05b6                	slli	a1,a1,0xd
    800019ec:	8526                	mv	a0,s1
    800019ee:	e50ff0ef          	jal	8000103e <mappages>
    800019f2:	00054f63          	bltz	a0,80001a10 <proc_pagetable+0x66>
}
    800019f6:	8526                	mv	a0,s1
    800019f8:	60e2                	ld	ra,24(sp)
    800019fa:	6442                	ld	s0,16(sp)
    800019fc:	64a2                	ld	s1,8(sp)
    800019fe:	6902                	ld	s2,0(sp)
    80001a00:	6105                	addi	sp,sp,32
    80001a02:	8082                	ret
    uvmfree(pagetable, 0);
    80001a04:	4581                	li	a1,0
    80001a06:	8526                	mv	a0,s1
    80001a08:	a67ff0ef          	jal	8000146e <uvmfree>
    return 0;
    80001a0c:	4481                	li	s1,0
    80001a0e:	b7e5                	j	800019f6 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a10:	4681                	li	a3,0
    80001a12:	4605                	li	a2,1
    80001a14:	040005b7          	lui	a1,0x4000
    80001a18:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a1a:	05b2                	slli	a1,a1,0xc
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	fc6ff0ef          	jal	800011e4 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a22:	4581                	li	a1,0
    80001a24:	8526                	mv	a0,s1
    80001a26:	a49ff0ef          	jal	8000146e <uvmfree>
    return 0;
    80001a2a:	4481                	li	s1,0
    80001a2c:	b7e9                	j	800019f6 <proc_pagetable+0x4c>

0000000080001a2e <proc_freepagetable>:
{
    80001a2e:	1101                	addi	sp,sp,-32
    80001a30:	ec06                	sd	ra,24(sp)
    80001a32:	e822                	sd	s0,16(sp)
    80001a34:	e426                	sd	s1,8(sp)
    80001a36:	e04a                	sd	s2,0(sp)
    80001a38:	1000                	addi	s0,sp,32
    80001a3a:	84aa                	mv	s1,a0
    80001a3c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a3e:	4681                	li	a3,0
    80001a40:	4605                	li	a2,1
    80001a42:	040005b7          	lui	a1,0x4000
    80001a46:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a48:	05b2                	slli	a1,a1,0xc
    80001a4a:	f9aff0ef          	jal	800011e4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a4e:	4681                	li	a3,0
    80001a50:	4605                	li	a2,1
    80001a52:	020005b7          	lui	a1,0x2000
    80001a56:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a58:	05b6                	slli	a1,a1,0xd
    80001a5a:	8526                	mv	a0,s1
    80001a5c:	f88ff0ef          	jal	800011e4 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a60:	85ca                	mv	a1,s2
    80001a62:	8526                	mv	a0,s1
    80001a64:	a0bff0ef          	jal	8000146e <uvmfree>
}
    80001a68:	60e2                	ld	ra,24(sp)
    80001a6a:	6442                	ld	s0,16(sp)
    80001a6c:	64a2                	ld	s1,8(sp)
    80001a6e:	6902                	ld	s2,0(sp)
    80001a70:	6105                	addi	sp,sp,32
    80001a72:	8082                	ret

0000000080001a74 <growproc>:
{
    80001a74:	1101                	addi	sp,sp,-32
    80001a76:	ec06                	sd	ra,24(sp)
    80001a78:	e822                	sd	s0,16(sp)
    80001a7a:	e426                	sd	s1,8(sp)
    80001a7c:	e04a                	sd	s2,0(sp)
    80001a7e:	1000                	addi	s0,sp,32
    80001a80:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001a82:	e81ff0ef          	jal	80001902 <myproc>
    80001a86:	84aa                	mv	s1,a0
  sz = p->sz;
    80001a88:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001a8a:	01204c63          	bgtz	s2,80001aa2 <growproc+0x2e>
  } else if(n < 0){
    80001a8e:	02094463          	bltz	s2,80001ab6 <growproc+0x42>
  p->sz = sz;
    80001a92:	e4ac                	sd	a1,72(s1)
  return 0;
    80001a94:	4501                	li	a0,0
}
    80001a96:	60e2                	ld	ra,24(sp)
    80001a98:	6442                	ld	s0,16(sp)
    80001a9a:	64a2                	ld	s1,8(sp)
    80001a9c:	6902                	ld	s2,0(sp)
    80001a9e:	6105                	addi	sp,sp,32
    80001aa0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001aa2:	4691                	li	a3,4
    80001aa4:	00b90633          	add	a2,s2,a1
    80001aa8:	6928                	ld	a0,80(a0)
    80001aaa:	8bfff0ef          	jal	80001368 <uvmalloc>
    80001aae:	85aa                	mv	a1,a0
    80001ab0:	f16d                	bnez	a0,80001a92 <growproc+0x1e>
      return -1;
    80001ab2:	557d                	li	a0,-1
    80001ab4:	b7cd                	j	80001a96 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ab6:	00b90633          	add	a2,s2,a1
    80001aba:	6928                	ld	a0,80(a0)
    80001abc:	869ff0ef          	jal	80001324 <uvmdealloc>
    80001ac0:	85aa                	mv	a1,a0
    80001ac2:	bfc1                	j	80001a92 <growproc+0x1e>

0000000080001ac4 <sched>:
{
    80001ac4:	7179                	addi	sp,sp,-48
    80001ac6:	f406                	sd	ra,40(sp)
    80001ac8:	f022                	sd	s0,32(sp)
    80001aca:	ec26                	sd	s1,24(sp)
    80001acc:	e84a                	sd	s2,16(sp)
    80001ace:	e44e                	sd	s3,8(sp)
    80001ad0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001ad2:	e31ff0ef          	jal	80001902 <myproc>
    80001ad6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ad8:	8b2ff0ef          	jal	80000b8a <holding>
    80001adc:	c92d                	beqz	a0,80001b4e <sched+0x8a>
    80001ade:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ae0:	2781                	sext.w	a5,a5
    80001ae2:	079e                	slli	a5,a5,0x7
    80001ae4:	0000e717          	auipc	a4,0xe
    80001ae8:	0ec70713          	addi	a4,a4,236 # 8000fbd0 <pid_lock>
    80001aec:	97ba                	add	a5,a5,a4
    80001aee:	0a87a703          	lw	a4,168(a5)
    80001af2:	4785                	li	a5,1
    80001af4:	06f71363          	bne	a4,a5,80001b5a <sched+0x96>
  if(p->state == RUNNING)
    80001af8:	4c98                	lw	a4,24(s1)
    80001afa:	4791                	li	a5,4
    80001afc:	06f70563          	beq	a4,a5,80001b66 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b00:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b04:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001b06:	e7b5                	bnez	a5,80001b72 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b08:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001b0a:	0000e917          	auipc	s2,0xe
    80001b0e:	0c690913          	addi	s2,s2,198 # 8000fbd0 <pid_lock>
    80001b12:	2781                	sext.w	a5,a5
    80001b14:	079e                	slli	a5,a5,0x7
    80001b16:	97ca                	add	a5,a5,s2
    80001b18:	0ac7a983          	lw	s3,172(a5)
    80001b1c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001b1e:	2781                	sext.w	a5,a5
    80001b20:	079e                	slli	a5,a5,0x7
    80001b22:	0000e597          	auipc	a1,0xe
    80001b26:	0e658593          	addi	a1,a1,230 # 8000fc08 <cpus+0x8>
    80001b2a:	95be                	add	a1,a1,a5
    80001b2c:	06048513          	addi	a0,s1,96
    80001b30:	3e1000ef          	jal	80002710 <swtch>
    80001b34:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001b36:	2781                	sext.w	a5,a5
    80001b38:	079e                	slli	a5,a5,0x7
    80001b3a:	993e                	add	s2,s2,a5
    80001b3c:	0b392623          	sw	s3,172(s2)
}
    80001b40:	70a2                	ld	ra,40(sp)
    80001b42:	7402                	ld	s0,32(sp)
    80001b44:	64e2                	ld	s1,24(sp)
    80001b46:	6942                	ld	s2,16(sp)
    80001b48:	69a2                	ld	s3,8(sp)
    80001b4a:	6145                	addi	sp,sp,48
    80001b4c:	8082                	ret
    panic("sched p->lock");
    80001b4e:	00005517          	auipc	a0,0x5
    80001b52:	7d250513          	addi	a0,a0,2002 # 80007320 <etext+0x320>
    80001b56:	c3ffe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001b5a:	00005517          	auipc	a0,0x5
    80001b5e:	7d650513          	addi	a0,a0,2006 # 80007330 <etext+0x330>
    80001b62:	c33fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001b66:	00005517          	auipc	a0,0x5
    80001b6a:	7da50513          	addi	a0,a0,2010 # 80007340 <etext+0x340>
    80001b6e:	c27fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001b72:	00005517          	auipc	a0,0x5
    80001b76:	7de50513          	addi	a0,a0,2014 # 80007350 <etext+0x350>
    80001b7a:	c1bfe0ef          	jal	80000794 <panic>

0000000080001b7e <yield>:
{
    80001b7e:	1101                	addi	sp,sp,-32
    80001b80:	ec06                	sd	ra,24(sp)
    80001b82:	e822                	sd	s0,16(sp)
    80001b84:	e426                	sd	s1,8(sp)
    80001b86:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001b88:	d7bff0ef          	jal	80001902 <myproc>
    80001b8c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001b8e:	866ff0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001b92:	478d                	li	a5,3
    80001b94:	cc9c                	sw	a5,24(s1)
  sched();
    80001b96:	f2fff0ef          	jal	80001ac4 <sched>
  release(&p->lock);
    80001b9a:	8526                	mv	a0,s1
    80001b9c:	8f0ff0ef          	jal	80000c8c <release>
}
    80001ba0:	60e2                	ld	ra,24(sp)
    80001ba2:	6442                	ld	s0,16(sp)
    80001ba4:	64a2                	ld	s1,8(sp)
    80001ba6:	6105                	addi	sp,sp,32
    80001ba8:	8082                	ret

0000000080001baa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001baa:	7179                	addi	sp,sp,-48
    80001bac:	f406                	sd	ra,40(sp)
    80001bae:	f022                	sd	s0,32(sp)
    80001bb0:	ec26                	sd	s1,24(sp)
    80001bb2:	e84a                	sd	s2,16(sp)
    80001bb4:	e44e                	sd	s3,8(sp)
    80001bb6:	1800                	addi	s0,sp,48
    80001bb8:	89aa                	mv	s3,a0
    80001bba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001bbc:	d47ff0ef          	jal	80001902 <myproc>
    80001bc0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001bc2:	832ff0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001bc6:	854a                	mv	a0,s2
    80001bc8:	8c4ff0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001bcc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001bd0:	4789                	li	a5,2
    80001bd2:	cc9c                	sw	a5,24(s1)

  sched();
    80001bd4:	ef1ff0ef          	jal	80001ac4 <sched>

  // Tidy up.
  p->chan = 0;
    80001bd8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	8aeff0ef          	jal	80000c8c <release>
  acquire(lk);
    80001be2:	854a                	mv	a0,s2
    80001be4:	810ff0ef          	jal	80000bf4 <acquire>
}
    80001be8:	70a2                	ld	ra,40(sp)
    80001bea:	7402                	ld	s0,32(sp)
    80001bec:	64e2                	ld	s1,24(sp)
    80001bee:	6942                	ld	s2,16(sp)
    80001bf0:	69a2                	ld	s3,8(sp)
    80001bf2:	6145                	addi	sp,sp,48
    80001bf4:	8082                	ret

0000000080001bf6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001bf6:	7139                	addi	sp,sp,-64
    80001bf8:	fc06                	sd	ra,56(sp)
    80001bfa:	f822                	sd	s0,48(sp)
    80001bfc:	f426                	sd	s1,40(sp)
    80001bfe:	f04a                	sd	s2,32(sp)
    80001c00:	ec4e                	sd	s3,24(sp)
    80001c02:	e852                	sd	s4,16(sp)
    80001c04:	e456                	sd	s5,8(sp)
    80001c06:	0080                	addi	s0,sp,64
    80001c08:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001c0a:	0000e497          	auipc	s1,0xe
    80001c0e:	3f648493          	addi	s1,s1,1014 # 80010000 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001c12:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001c14:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c16:	00016917          	auipc	s2,0x16
    80001c1a:	fea90913          	addi	s2,s2,-22 # 80017c00 <tickslock>
    80001c1e:	a801                	j	80001c2e <wakeup+0x38>
      }
      release(&p->lock);
    80001c20:	8526                	mv	a0,s1
    80001c22:	86aff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c26:	1f048493          	addi	s1,s1,496
    80001c2a:	03248263          	beq	s1,s2,80001c4e <wakeup+0x58>
    if(p != myproc()){
    80001c2e:	cd5ff0ef          	jal	80001902 <myproc>
    80001c32:	fea48ae3          	beq	s1,a0,80001c26 <wakeup+0x30>
      acquire(&p->lock);
    80001c36:	8526                	mv	a0,s1
    80001c38:	fbdfe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001c3c:	4c9c                	lw	a5,24(s1)
    80001c3e:	ff3791e3          	bne	a5,s3,80001c20 <wakeup+0x2a>
    80001c42:	709c                	ld	a5,32(s1)
    80001c44:	fd479ee3          	bne	a5,s4,80001c20 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001c48:	0154ac23          	sw	s5,24(s1)
    80001c4c:	bfd1                	j	80001c20 <wakeup+0x2a>
    }
  }
}
    80001c4e:	70e2                	ld	ra,56(sp)
    80001c50:	7442                	ld	s0,48(sp)
    80001c52:	74a2                	ld	s1,40(sp)
    80001c54:	7902                	ld	s2,32(sp)
    80001c56:	69e2                	ld	s3,24(sp)
    80001c58:	6a42                	ld	s4,16(sp)
    80001c5a:	6aa2                	ld	s5,8(sp)
    80001c5c:	6121                	addi	sp,sp,64
    80001c5e:	8082                	ret

0000000080001c60 <reparent>:
{
    80001c60:	7179                	addi	sp,sp,-48
    80001c62:	f406                	sd	ra,40(sp)
    80001c64:	f022                	sd	s0,32(sp)
    80001c66:	ec26                	sd	s1,24(sp)
    80001c68:	e84a                	sd	s2,16(sp)
    80001c6a:	e44e                	sd	s3,8(sp)
    80001c6c:	e052                	sd	s4,0(sp)
    80001c6e:	1800                	addi	s0,sp,48
    80001c70:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001c72:	0000e497          	auipc	s1,0xe
    80001c76:	38e48493          	addi	s1,s1,910 # 80010000 <proc>
      pp->parent = initproc;
    80001c7a:	00006a17          	auipc	s4,0x6
    80001c7e:	e1ea0a13          	addi	s4,s4,-482 # 80007a98 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001c82:	00016997          	auipc	s3,0x16
    80001c86:	f7e98993          	addi	s3,s3,-130 # 80017c00 <tickslock>
    80001c8a:	a029                	j	80001c94 <reparent+0x34>
    80001c8c:	1f048493          	addi	s1,s1,496
    80001c90:	01348b63          	beq	s1,s3,80001ca6 <reparent+0x46>
    if(pp->parent == p){
    80001c94:	7c9c                	ld	a5,56(s1)
    80001c96:	ff279be3          	bne	a5,s2,80001c8c <reparent+0x2c>
      pp->parent = initproc;
    80001c9a:	000a3503          	ld	a0,0(s4)
    80001c9e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001ca0:	f57ff0ef          	jal	80001bf6 <wakeup>
    80001ca4:	b7e5                	j	80001c8c <reparent+0x2c>
}
    80001ca6:	70a2                	ld	ra,40(sp)
    80001ca8:	7402                	ld	s0,32(sp)
    80001caa:	64e2                	ld	s1,24(sp)
    80001cac:	6942                	ld	s2,16(sp)
    80001cae:	69a2                	ld	s3,8(sp)
    80001cb0:	6a02                	ld	s4,0(sp)
    80001cb2:	6145                	addi	sp,sp,48
    80001cb4:	8082                	ret

0000000080001cb6 <exit>:
{
    80001cb6:	7179                	addi	sp,sp,-48
    80001cb8:	f406                	sd	ra,40(sp)
    80001cba:	f022                	sd	s0,32(sp)
    80001cbc:	ec26                	sd	s1,24(sp)
    80001cbe:	e84a                	sd	s2,16(sp)
    80001cc0:	e44e                	sd	s3,8(sp)
    80001cc2:	e052                	sd	s4,0(sp)
    80001cc4:	1800                	addi	s0,sp,48
    80001cc6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001cc8:	c3bff0ef          	jal	80001902 <myproc>
    80001ccc:	89aa                	mv	s3,a0
  if(p == initproc)
    80001cce:	00006797          	auipc	a5,0x6
    80001cd2:	dca7b783          	ld	a5,-566(a5) # 80007a98 <initproc>
    80001cd6:	0d050493          	addi	s1,a0,208
    80001cda:	15050913          	addi	s2,a0,336
    80001cde:	00a79f63          	bne	a5,a0,80001cfc <exit+0x46>
    panic("init exiting");
    80001ce2:	00005517          	auipc	a0,0x5
    80001ce6:	68650513          	addi	a0,a0,1670 # 80007368 <etext+0x368>
    80001cea:	aabfe0ef          	jal	80000794 <panic>
      fileclose(f);
    80001cee:	602020ef          	jal	800042f0 <fileclose>
      p->ofile[fd] = 0;
    80001cf2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001cf6:	04a1                	addi	s1,s1,8
    80001cf8:	01248563          	beq	s1,s2,80001d02 <exit+0x4c>
    if(p->ofile[fd]){
    80001cfc:	6088                	ld	a0,0(s1)
    80001cfe:	f965                	bnez	a0,80001cee <exit+0x38>
    80001d00:	bfdd                	j	80001cf6 <exit+0x40>
  begin_op();
    80001d02:	1d4020ef          	jal	80003ed6 <begin_op>
  iput(p->cwd);
    80001d06:	1509b503          	ld	a0,336(s3)
    80001d0a:	2b9010ef          	jal	800037c2 <iput>
  end_op();
    80001d0e:	232020ef          	jal	80003f40 <end_op>
  p->cwd = 0;
    80001d12:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001d16:	0000e497          	auipc	s1,0xe
    80001d1a:	ed248493          	addi	s1,s1,-302 # 8000fbe8 <wait_lock>
    80001d1e:	8526                	mv	a0,s1
    80001d20:	ed5fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    80001d24:	854e                	mv	a0,s3
    80001d26:	f3bff0ef          	jal	80001c60 <reparent>
  wakeup(p->parent);
    80001d2a:	0389b503          	ld	a0,56(s3)
    80001d2e:	ec9ff0ef          	jal	80001bf6 <wakeup>
  acquire(&p->lock);
    80001d32:	854e                	mv	a0,s3
    80001d34:	ec1fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    80001d38:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001d3c:	4795                	li	a5,5
    80001d3e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001d42:	8526                	mv	a0,s1
    80001d44:	f49fe0ef          	jal	80000c8c <release>
  sched();
    80001d48:	d7dff0ef          	jal	80001ac4 <sched>
  panic("zombie exit");
    80001d4c:	00005517          	auipc	a0,0x5
    80001d50:	62c50513          	addi	a0,a0,1580 # 80007378 <etext+0x378>
    80001d54:	a41fe0ef          	jal	80000794 <panic>

0000000080001d58 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001d58:	7179                	addi	sp,sp,-48
    80001d5a:	f406                	sd	ra,40(sp)
    80001d5c:	f022                	sd	s0,32(sp)
    80001d5e:	ec26                	sd	s1,24(sp)
    80001d60:	e84a                	sd	s2,16(sp)
    80001d62:	e44e                	sd	s3,8(sp)
    80001d64:	1800                	addi	s0,sp,48
    80001d66:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001d68:	0000e497          	auipc	s1,0xe
    80001d6c:	29848493          	addi	s1,s1,664 # 80010000 <proc>
    80001d70:	00016997          	auipc	s3,0x16
    80001d74:	e9098993          	addi	s3,s3,-368 # 80017c00 <tickslock>
    acquire(&p->lock);
    80001d78:	8526                	mv	a0,s1
    80001d7a:	e7bfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    80001d7e:	589c                	lw	a5,48(s1)
    80001d80:	01278b63          	beq	a5,s2,80001d96 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001d84:	8526                	mv	a0,s1
    80001d86:	f07fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001d8a:	1f048493          	addi	s1,s1,496
    80001d8e:	ff3495e3          	bne	s1,s3,80001d78 <kill+0x20>
  }
  return -1;
    80001d92:	557d                	li	a0,-1
    80001d94:	a819                	j	80001daa <kill+0x52>
      p->killed = 1;
    80001d96:	4785                	li	a5,1
    80001d98:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001d9a:	4c98                	lw	a4,24(s1)
    80001d9c:	4789                	li	a5,2
    80001d9e:	00f70d63          	beq	a4,a5,80001db8 <kill+0x60>
      release(&p->lock);
    80001da2:	8526                	mv	a0,s1
    80001da4:	ee9fe0ef          	jal	80000c8c <release>
      return 0;
    80001da8:	4501                	li	a0,0
}
    80001daa:	70a2                	ld	ra,40(sp)
    80001dac:	7402                	ld	s0,32(sp)
    80001dae:	64e2                	ld	s1,24(sp)
    80001db0:	6942                	ld	s2,16(sp)
    80001db2:	69a2                	ld	s3,8(sp)
    80001db4:	6145                	addi	sp,sp,48
    80001db6:	8082                	ret
        p->state = RUNNABLE;
    80001db8:	478d                	li	a5,3
    80001dba:	cc9c                	sw	a5,24(s1)
    80001dbc:	b7dd                	j	80001da2 <kill+0x4a>

0000000080001dbe <setkilled>:

void
setkilled(struct proc *p)
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	1000                	addi	s0,sp,32
    80001dc8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001dca:	e2bfe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    80001dce:	4785                	li	a5,1
    80001dd0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001dd2:	8526                	mv	a0,s1
    80001dd4:	eb9fe0ef          	jal	80000c8c <release>
}
    80001dd8:	60e2                	ld	ra,24(sp)
    80001dda:	6442                	ld	s0,16(sp)
    80001ddc:	64a2                	ld	s1,8(sp)
    80001dde:	6105                	addi	sp,sp,32
    80001de0:	8082                	ret

0000000080001de2 <killed>:

int
killed(struct proc *p)
{
    80001de2:	1101                	addi	sp,sp,-32
    80001de4:	ec06                	sd	ra,24(sp)
    80001de6:	e822                	sd	s0,16(sp)
    80001de8:	e426                	sd	s1,8(sp)
    80001dea:	e04a                	sd	s2,0(sp)
    80001dec:	1000                	addi	s0,sp,32
    80001dee:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001df0:	e05fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80001df4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001df8:	8526                	mv	a0,s1
    80001dfa:	e93fe0ef          	jal	80000c8c <release>
  return k;
}
    80001dfe:	854a                	mv	a0,s2
    80001e00:	60e2                	ld	ra,24(sp)
    80001e02:	6442                	ld	s0,16(sp)
    80001e04:	64a2                	ld	s1,8(sp)
    80001e06:	6902                	ld	s2,0(sp)
    80001e08:	6105                	addi	sp,sp,32
    80001e0a:	8082                	ret

0000000080001e0c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001e0c:	7179                	addi	sp,sp,-48
    80001e0e:	f406                	sd	ra,40(sp)
    80001e10:	f022                	sd	s0,32(sp)
    80001e12:	ec26                	sd	s1,24(sp)
    80001e14:	e84a                	sd	s2,16(sp)
    80001e16:	e44e                	sd	s3,8(sp)
    80001e18:	e052                	sd	s4,0(sp)
    80001e1a:	1800                	addi	s0,sp,48
    80001e1c:	84aa                	mv	s1,a0
    80001e1e:	892e                	mv	s2,a1
    80001e20:	89b2                	mv	s3,a2
    80001e22:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001e24:	adfff0ef          	jal	80001902 <myproc>
  if(user_dst){
    80001e28:	cc99                	beqz	s1,80001e46 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001e2a:	86d2                	mv	a3,s4
    80001e2c:	864e                	mv	a2,s3
    80001e2e:	85ca                	mv	a1,s2
    80001e30:	6928                	ld	a0,80(a0)
    80001e32:	f4aff0ef          	jal	8000157c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001e36:	70a2                	ld	ra,40(sp)
    80001e38:	7402                	ld	s0,32(sp)
    80001e3a:	64e2                	ld	s1,24(sp)
    80001e3c:	6942                	ld	s2,16(sp)
    80001e3e:	69a2                	ld	s3,8(sp)
    80001e40:	6a02                	ld	s4,0(sp)
    80001e42:	6145                	addi	sp,sp,48
    80001e44:	8082                	ret
    memmove((char *)dst, src, len);
    80001e46:	000a061b          	sext.w	a2,s4
    80001e4a:	85ce                	mv	a1,s3
    80001e4c:	854a                	mv	a0,s2
    80001e4e:	ed7fe0ef          	jal	80000d24 <memmove>
    return 0;
    80001e52:	8526                	mv	a0,s1
    80001e54:	b7cd                	j	80001e36 <either_copyout+0x2a>

0000000080001e56 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001e56:	7179                	addi	sp,sp,-48
    80001e58:	f406                	sd	ra,40(sp)
    80001e5a:	f022                	sd	s0,32(sp)
    80001e5c:	ec26                	sd	s1,24(sp)
    80001e5e:	e84a                	sd	s2,16(sp)
    80001e60:	e44e                	sd	s3,8(sp)
    80001e62:	e052                	sd	s4,0(sp)
    80001e64:	1800                	addi	s0,sp,48
    80001e66:	892a                	mv	s2,a0
    80001e68:	84ae                	mv	s1,a1
    80001e6a:	89b2                	mv	s3,a2
    80001e6c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001e6e:	a95ff0ef          	jal	80001902 <myproc>
  if(user_src){
    80001e72:	cc99                	beqz	s1,80001e90 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001e74:	86d2                	mv	a3,s4
    80001e76:	864e                	mv	a2,s3
    80001e78:	85ca                	mv	a1,s2
    80001e7a:	6928                	ld	a0,80(a0)
    80001e7c:	fd6ff0ef          	jal	80001652 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001e80:	70a2                	ld	ra,40(sp)
    80001e82:	7402                	ld	s0,32(sp)
    80001e84:	64e2                	ld	s1,24(sp)
    80001e86:	6942                	ld	s2,16(sp)
    80001e88:	69a2                	ld	s3,8(sp)
    80001e8a:	6a02                	ld	s4,0(sp)
    80001e8c:	6145                	addi	sp,sp,48
    80001e8e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001e90:	000a061b          	sext.w	a2,s4
    80001e94:	85ce                	mv	a1,s3
    80001e96:	854a                	mv	a0,s2
    80001e98:	e8dfe0ef          	jal	80000d24 <memmove>
    return 0;
    80001e9c:	8526                	mv	a0,s1
    80001e9e:	b7cd                	j	80001e80 <either_copyin+0x2a>

0000000080001ea0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ea0:	715d                	addi	sp,sp,-80
    80001ea2:	e486                	sd	ra,72(sp)
    80001ea4:	e0a2                	sd	s0,64(sp)
    80001ea6:	fc26                	sd	s1,56(sp)
    80001ea8:	f84a                	sd	s2,48(sp)
    80001eaa:	f44e                	sd	s3,40(sp)
    80001eac:	f052                	sd	s4,32(sp)
    80001eae:	ec56                	sd	s5,24(sp)
    80001eb0:	e85a                	sd	s6,16(sp)
    80001eb2:	e45e                	sd	s7,8(sp)
    80001eb4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001eb6:	00005517          	auipc	a0,0x5
    80001eba:	1c250513          	addi	a0,a0,450 # 80007078 <etext+0x78>
    80001ebe:	e04fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ec2:	0000e497          	auipc	s1,0xe
    80001ec6:	29648493          	addi	s1,s1,662 # 80010158 <proc+0x158>
    80001eca:	00016917          	auipc	s2,0x16
    80001ece:	e8e90913          	addi	s2,s2,-370 # 80017d58 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ed2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ed4:	00005997          	auipc	s3,0x5
    80001ed8:	4b498993          	addi	s3,s3,1204 # 80007388 <etext+0x388>
    printf("%d %s %s", p->pid, state, p->name);
    80001edc:	00005a97          	auipc	s5,0x5
    80001ee0:	4b4a8a93          	addi	s5,s5,1204 # 80007390 <etext+0x390>
    printf("\n");
    80001ee4:	00005a17          	auipc	s4,0x5
    80001ee8:	194a0a13          	addi	s4,s4,404 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001eec:	00006b97          	auipc	s7,0x6
    80001ef0:	a04b8b93          	addi	s7,s7,-1532 # 800078f0 <states.0>
    80001ef4:	a829                	j	80001f0e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001ef6:	ed86a583          	lw	a1,-296(a3)
    80001efa:	8556                	mv	a0,s5
    80001efc:	dc6fe0ef          	jal	800004c2 <printf>
    printf("\n");
    80001f00:	8552                	mv	a0,s4
    80001f02:	dc0fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001f06:	1f048493          	addi	s1,s1,496
    80001f0a:	03248263          	beq	s1,s2,80001f2e <procdump+0x8e>
    if(p->state == UNUSED)
    80001f0e:	86a6                	mv	a3,s1
    80001f10:	ec04a783          	lw	a5,-320(s1)
    80001f14:	dbed                	beqz	a5,80001f06 <procdump+0x66>
      state = "???";
    80001f16:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001f18:	fcfb6fe3          	bltu	s6,a5,80001ef6 <procdump+0x56>
    80001f1c:	02079713          	slli	a4,a5,0x20
    80001f20:	01d75793          	srli	a5,a4,0x1d
    80001f24:	97de                	add	a5,a5,s7
    80001f26:	6390                	ld	a2,0(a5)
    80001f28:	f679                	bnez	a2,80001ef6 <procdump+0x56>
      state = "???";
    80001f2a:	864e                	mv	a2,s3
    80001f2c:	b7e9                	j	80001ef6 <procdump+0x56>
  }
}
    80001f2e:	60a6                	ld	ra,72(sp)
    80001f30:	6406                	ld	s0,64(sp)
    80001f32:	74e2                	ld	s1,56(sp)
    80001f34:	7942                	ld	s2,48(sp)
    80001f36:	79a2                	ld	s3,40(sp)
    80001f38:	7a02                	ld	s4,32(sp)
    80001f3a:	6ae2                	ld	s5,24(sp)
    80001f3c:	6b42                	ld	s6,16(sp)
    80001f3e:	6ba2                	ld	s7,8(sp)
    80001f40:	6161                	addi	sp,sp,80
    80001f42:	8082                	ret

0000000080001f44 <freethread>:
}
return 0;
}
void
freethread(struct thread *t)
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	1000                	addi	s0,sp,32
    80001f4e:	84aa                	mv	s1,a0
t->state = THREAD_UNUSED;
    80001f50:	00052023          	sw	zero,0(a0)
if (t->trapframe)
    80001f54:	6508                	ld	a0,8(a0)
    80001f56:	c119                	beqz	a0,80001f5c <freethread+0x18>
kfree((void*)t->trapframe);
    80001f58:	aebfe0ef          	jal	80000a42 <kfree>
t->trapframe = 0;
    80001f5c:	0004b423          	sd	zero,8(s1)
t->id = 0;
    80001f60:	0004a823          	sw	zero,16(s1)
t->join = 0;}
    80001f64:	0004aa23          	sw	zero,20(s1)
    80001f68:	60e2                	ld	ra,24(sp)
    80001f6a:	6442                	ld	s0,16(sp)
    80001f6c:	64a2                	ld	s1,8(sp)
    80001f6e:	6105                	addi	sp,sp,32
    80001f70:	8082                	ret

0000000080001f72 <freeproc>:
{
    80001f72:	1101                	addi	sp,sp,-32
    80001f74:	ec06                	sd	ra,24(sp)
    80001f76:	e822                	sd	s0,16(sp)
    80001f78:	e426                	sd	s1,8(sp)
    80001f7a:	1000                	addi	s0,sp,32
    80001f7c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001f7e:	6d28                	ld	a0,88(a0)
    80001f80:	c119                	beqz	a0,80001f86 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001f82:	ac1fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001f86:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001f8a:	68a8                	ld	a0,80(s1)
    80001f8c:	c501                	beqz	a0,80001f94 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001f8e:	64ac                	ld	a1,72(s1)
    80001f90:	a9fff0ef          	jal	80001a2e <proc_freepagetable>
  p->pagetable = 0;
    80001f94:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001f98:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001f9c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001fa0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001fa4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001fa8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001fac:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001fb0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001fb4:	0004ac23          	sw	zero,24(s1)
  p->current_thread = 0;
    80001fb8:	1e04b423          	sd	zero,488(s1)
  freethread(&p->threads[i]);
    80001fbc:	16848513          	addi	a0,s1,360
    80001fc0:	f85ff0ef          	jal	80001f44 <freethread>
    80001fc4:	18848513          	addi	a0,s1,392
    80001fc8:	f7dff0ef          	jal	80001f44 <freethread>
    80001fcc:	1a848513          	addi	a0,s1,424
    80001fd0:	f75ff0ef          	jal	80001f44 <freethread>
    80001fd4:	1c848513          	addi	a0,s1,456
    80001fd8:	f6dff0ef          	jal	80001f44 <freethread>
}
    80001fdc:	60e2                	ld	ra,24(sp)
    80001fde:	6442                	ld	s0,16(sp)
    80001fe0:	64a2                	ld	s1,8(sp)
    80001fe2:	6105                	addi	sp,sp,32
    80001fe4:	8082                	ret

0000000080001fe6 <allocproc>:
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	e04a                	sd	s2,0(sp)
    80001ff0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ff2:	0000e497          	auipc	s1,0xe
    80001ff6:	00e48493          	addi	s1,s1,14 # 80010000 <proc>
    80001ffa:	00016917          	auipc	s2,0x16
    80001ffe:	c0690913          	addi	s2,s2,-1018 # 80017c00 <tickslock>
    acquire(&p->lock);
    80002002:	8526                	mv	a0,s1
    80002004:	bf1fe0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80002008:	4c9c                	lw	a5,24(s1)
    8000200a:	cb91                	beqz	a5,8000201e <allocproc+0x38>
      release(&p->lock);
    8000200c:	8526                	mv	a0,s1
    8000200e:	c7ffe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002012:	1f048493          	addi	s1,s1,496
    80002016:	ff2496e3          	bne	s1,s2,80002002 <allocproc+0x1c>
  return 0;
    8000201a:	4481                	li	s1,0
    8000201c:	a089                	j	8000205e <allocproc+0x78>
  p->pid = allocpid();
    8000201e:	94fff0ef          	jal	8000196c <allocpid>
    80002022:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002024:	4785                	li	a5,1
    80002026:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002028:	afdfe0ef          	jal	80000b24 <kalloc>
    8000202c:	892a                	mv	s2,a0
    8000202e:	eca8                	sd	a0,88(s1)
    80002030:	cd15                	beqz	a0,8000206c <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80002032:	8526                	mv	a0,s1
    80002034:	977ff0ef          	jal	800019aa <proc_pagetable>
    80002038:	892a                	mv	s2,a0
    8000203a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000203c:	c121                	beqz	a0,8000207c <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    8000203e:	07000613          	li	a2,112
    80002042:	4581                	li	a1,0
    80002044:	06048513          	addi	a0,s1,96
    80002048:	c81fe0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    8000204c:	00000797          	auipc	a5,0x0
    80002050:	8e678793          	addi	a5,a5,-1818 # 80001932 <forkret>
    80002054:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002056:	60bc                	ld	a5,64(s1)
    80002058:	6705                	lui	a4,0x1
    8000205a:	97ba                	add	a5,a5,a4
    8000205c:	f4bc                	sd	a5,104(s1)
}
    8000205e:	8526                	mv	a0,s1
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6902                	ld	s2,0(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret
    freeproc(p);
    8000206c:	8526                	mv	a0,s1
    8000206e:	f05ff0ef          	jal	80001f72 <freeproc>
    release(&p->lock);
    80002072:	8526                	mv	a0,s1
    80002074:	c19fe0ef          	jal	80000c8c <release>
    return 0;
    80002078:	84ca                	mv	s1,s2
    8000207a:	b7d5                	j	8000205e <allocproc+0x78>
    freeproc(p);
    8000207c:	8526                	mv	a0,s1
    8000207e:	ef5ff0ef          	jal	80001f72 <freeproc>
    release(&p->lock);
    80002082:	8526                	mv	a0,s1
    80002084:	c09fe0ef          	jal	80000c8c <release>
    return 0;
    80002088:	84ca                	mv	s1,s2
    8000208a:	bfd1                	j	8000205e <allocproc+0x78>

000000008000208c <userinit>:
{
    8000208c:	1101                	addi	sp,sp,-32
    8000208e:	ec06                	sd	ra,24(sp)
    80002090:	e822                	sd	s0,16(sp)
    80002092:	e426                	sd	s1,8(sp)
    80002094:	1000                	addi	s0,sp,32
  p = allocproc();
    80002096:	f51ff0ef          	jal	80001fe6 <allocproc>
    8000209a:	84aa                	mv	s1,a0
  initproc = p;
    8000209c:	00006797          	auipc	a5,0x6
    800020a0:	9ea7be23          	sd	a0,-1540(a5) # 80007a98 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800020a4:	03400613          	li	a2,52
    800020a8:	00006597          	auipc	a1,0x6
    800020ac:	98858593          	addi	a1,a1,-1656 # 80007a30 <initcode>
    800020b0:	6928                	ld	a0,80(a0)
    800020b2:	a14ff0ef          	jal	800012c6 <uvmfirst>
  p->sz = PGSIZE;
    800020b6:	6785                	lui	a5,0x1
    800020b8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800020ba:	6cb8                	ld	a4,88(s1)
    800020bc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800020c0:	6cb8                	ld	a4,88(s1)
    800020c2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800020c4:	4641                	li	a2,16
    800020c6:	00005597          	auipc	a1,0x5
    800020ca:	2da58593          	addi	a1,a1,730 # 800073a0 <etext+0x3a0>
    800020ce:	15848513          	addi	a0,s1,344
    800020d2:	d35fe0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    800020d6:	00005517          	auipc	a0,0x5
    800020da:	2da50513          	addi	a0,a0,730 # 800073b0 <etext+0x3b0>
    800020de:	43d010ef          	jal	80003d1a <namei>
    800020e2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800020e6:	478d                	li	a5,3
    800020e8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800020ea:	8526                	mv	a0,s1
    800020ec:	ba1fe0ef          	jal	80000c8c <release>
}
    800020f0:	60e2                	ld	ra,24(sp)
    800020f2:	6442                	ld	s0,16(sp)
    800020f4:	64a2                	ld	s1,8(sp)
    800020f6:	6105                	addi	sp,sp,32
    800020f8:	8082                	ret

00000000800020fa <fork>:
{
    800020fa:	7139                	addi	sp,sp,-64
    800020fc:	fc06                	sd	ra,56(sp)
    800020fe:	f822                	sd	s0,48(sp)
    80002100:	f04a                	sd	s2,32(sp)
    80002102:	e456                	sd	s5,8(sp)
    80002104:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002106:	ffcff0ef          	jal	80001902 <myproc>
    8000210a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000210c:	edbff0ef          	jal	80001fe6 <allocproc>
    80002110:	0e050a63          	beqz	a0,80002204 <fork+0x10a>
    80002114:	e852                	sd	s4,16(sp)
    80002116:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002118:	048ab603          	ld	a2,72(s5)
    8000211c:	692c                	ld	a1,80(a0)
    8000211e:	050ab503          	ld	a0,80(s5)
    80002122:	b7eff0ef          	jal	800014a0 <uvmcopy>
    80002126:	04054a63          	bltz	a0,8000217a <fork+0x80>
    8000212a:	f426                	sd	s1,40(sp)
    8000212c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000212e:	048ab783          	ld	a5,72(s5)
    80002132:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002136:	058ab683          	ld	a3,88(s5)
    8000213a:	87b6                	mv	a5,a3
    8000213c:	058a3703          	ld	a4,88(s4)
    80002140:	12068693          	addi	a3,a3,288
    80002144:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002148:	6788                	ld	a0,8(a5)
    8000214a:	6b8c                	ld	a1,16(a5)
    8000214c:	6f90                	ld	a2,24(a5)
    8000214e:	01073023          	sd	a6,0(a4)
    80002152:	e708                	sd	a0,8(a4)
    80002154:	eb0c                	sd	a1,16(a4)
    80002156:	ef10                	sd	a2,24(a4)
    80002158:	02078793          	addi	a5,a5,32
    8000215c:	02070713          	addi	a4,a4,32
    80002160:	fed792e3          	bne	a5,a3,80002144 <fork+0x4a>
  np->trapframe->a0 = 0;
    80002164:	058a3783          	ld	a5,88(s4)
    80002168:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000216c:	0d0a8493          	addi	s1,s5,208
    80002170:	0d0a0913          	addi	s2,s4,208
    80002174:	150a8993          	addi	s3,s5,336
    80002178:	a831                	j	80002194 <fork+0x9a>
    freeproc(np);
    8000217a:	8552                	mv	a0,s4
    8000217c:	df7ff0ef          	jal	80001f72 <freeproc>
    release(&np->lock);
    80002180:	8552                	mv	a0,s4
    80002182:	b0bfe0ef          	jal	80000c8c <release>
    return -1;
    80002186:	597d                	li	s2,-1
    80002188:	6a42                	ld	s4,16(sp)
    8000218a:	a0b5                	j	800021f6 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000218c:	04a1                	addi	s1,s1,8
    8000218e:	0921                	addi	s2,s2,8
    80002190:	01348963          	beq	s1,s3,800021a2 <fork+0xa8>
    if(p->ofile[i])
    80002194:	6088                	ld	a0,0(s1)
    80002196:	d97d                	beqz	a0,8000218c <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80002198:	112020ef          	jal	800042aa <filedup>
    8000219c:	00a93023          	sd	a0,0(s2)
    800021a0:	b7f5                	j	8000218c <fork+0x92>
  np->cwd = idup(p->cwd);
    800021a2:	150ab503          	ld	a0,336(s5)
    800021a6:	464010ef          	jal	8000360a <idup>
    800021aa:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800021ae:	4641                	li	a2,16
    800021b0:	158a8593          	addi	a1,s5,344
    800021b4:	158a0513          	addi	a0,s4,344
    800021b8:	c4ffe0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    800021bc:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800021c0:	8552                	mv	a0,s4
    800021c2:	acbfe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    800021c6:	0000e497          	auipc	s1,0xe
    800021ca:	a2248493          	addi	s1,s1,-1502 # 8000fbe8 <wait_lock>
    800021ce:	8526                	mv	a0,s1
    800021d0:	a25fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    800021d4:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800021d8:	8526                	mv	a0,s1
    800021da:	ab3fe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    800021de:	8552                	mv	a0,s4
    800021e0:	a15fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    800021e4:	478d                	li	a5,3
    800021e6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800021ea:	8552                	mv	a0,s4
    800021ec:	aa1fe0ef          	jal	80000c8c <release>
  return pid;
    800021f0:	74a2                	ld	s1,40(sp)
    800021f2:	69e2                	ld	s3,24(sp)
    800021f4:	6a42                	ld	s4,16(sp)
}
    800021f6:	854a                	mv	a0,s2
    800021f8:	70e2                	ld	ra,56(sp)
    800021fa:	7442                	ld	s0,48(sp)
    800021fc:	7902                	ld	s2,32(sp)
    800021fe:	6aa2                	ld	s5,8(sp)
    80002200:	6121                	addi	sp,sp,64
    80002202:	8082                	ret
    return -1;
    80002204:	597d                	li	s2,-1
    80002206:	bfc5                	j	800021f6 <fork+0xfc>

0000000080002208 <wait>:
{
    80002208:	715d                	addi	sp,sp,-80
    8000220a:	e486                	sd	ra,72(sp)
    8000220c:	e0a2                	sd	s0,64(sp)
    8000220e:	fc26                	sd	s1,56(sp)
    80002210:	f84a                	sd	s2,48(sp)
    80002212:	f44e                	sd	s3,40(sp)
    80002214:	f052                	sd	s4,32(sp)
    80002216:	ec56                	sd	s5,24(sp)
    80002218:	e85a                	sd	s6,16(sp)
    8000221a:	e45e                	sd	s7,8(sp)
    8000221c:	e062                	sd	s8,0(sp)
    8000221e:	0880                	addi	s0,sp,80
    80002220:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002222:	ee0ff0ef          	jal	80001902 <myproc>
    80002226:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002228:	0000e517          	auipc	a0,0xe
    8000222c:	9c050513          	addi	a0,a0,-1600 # 8000fbe8 <wait_lock>
    80002230:	9c5fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80002234:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002236:	4a15                	li	s4,5
        havekids = 1;
    80002238:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000223a:	00016997          	auipc	s3,0x16
    8000223e:	9c698993          	addi	s3,s3,-1594 # 80017c00 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002242:	0000ec17          	auipc	s8,0xe
    80002246:	9a6c0c13          	addi	s8,s8,-1626 # 8000fbe8 <wait_lock>
    8000224a:	a871                	j	800022e6 <wait+0xde>
          pid = pp->pid;
    8000224c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002250:	000b0c63          	beqz	s6,80002268 <wait+0x60>
    80002254:	4691                	li	a3,4
    80002256:	02c48613          	addi	a2,s1,44
    8000225a:	85da                	mv	a1,s6
    8000225c:	05093503          	ld	a0,80(s2)
    80002260:	b1cff0ef          	jal	8000157c <copyout>
    80002264:	02054b63          	bltz	a0,8000229a <wait+0x92>
          freeproc(pp);
    80002268:	8526                	mv	a0,s1
    8000226a:	d09ff0ef          	jal	80001f72 <freeproc>
          release(&pp->lock);
    8000226e:	8526                	mv	a0,s1
    80002270:	a1dfe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    80002274:	0000e517          	auipc	a0,0xe
    80002278:	97450513          	addi	a0,a0,-1676 # 8000fbe8 <wait_lock>
    8000227c:	a11fe0ef          	jal	80000c8c <release>
}
    80002280:	854e                	mv	a0,s3
    80002282:	60a6                	ld	ra,72(sp)
    80002284:	6406                	ld	s0,64(sp)
    80002286:	74e2                	ld	s1,56(sp)
    80002288:	7942                	ld	s2,48(sp)
    8000228a:	79a2                	ld	s3,40(sp)
    8000228c:	7a02                	ld	s4,32(sp)
    8000228e:	6ae2                	ld	s5,24(sp)
    80002290:	6b42                	ld	s6,16(sp)
    80002292:	6ba2                	ld	s7,8(sp)
    80002294:	6c02                	ld	s8,0(sp)
    80002296:	6161                	addi	sp,sp,80
    80002298:	8082                	ret
            release(&pp->lock);
    8000229a:	8526                	mv	a0,s1
    8000229c:	9f1fe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    800022a0:	0000e517          	auipc	a0,0xe
    800022a4:	94850513          	addi	a0,a0,-1720 # 8000fbe8 <wait_lock>
    800022a8:	9e5fe0ef          	jal	80000c8c <release>
            return -1;
    800022ac:	59fd                	li	s3,-1
    800022ae:	bfc9                	j	80002280 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022b0:	1f048493          	addi	s1,s1,496
    800022b4:	03348063          	beq	s1,s3,800022d4 <wait+0xcc>
      if(pp->parent == p){
    800022b8:	7c9c                	ld	a5,56(s1)
    800022ba:	ff279be3          	bne	a5,s2,800022b0 <wait+0xa8>
        acquire(&pp->lock);
    800022be:	8526                	mv	a0,s1
    800022c0:	935fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    800022c4:	4c9c                	lw	a5,24(s1)
    800022c6:	f94783e3          	beq	a5,s4,8000224c <wait+0x44>
        release(&pp->lock);
    800022ca:	8526                	mv	a0,s1
    800022cc:	9c1fe0ef          	jal	80000c8c <release>
        havekids = 1;
    800022d0:	8756                	mv	a4,s5
    800022d2:	bff9                	j	800022b0 <wait+0xa8>
    if(!havekids || killed(p)){
    800022d4:	cf19                	beqz	a4,800022f2 <wait+0xea>
    800022d6:	854a                	mv	a0,s2
    800022d8:	b0bff0ef          	jal	80001de2 <killed>
    800022dc:	e919                	bnez	a0,800022f2 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800022de:	85e2                	mv	a1,s8
    800022e0:	854a                	mv	a0,s2
    800022e2:	8c9ff0ef          	jal	80001baa <sleep>
    havekids = 0;
    800022e6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e8:	0000e497          	auipc	s1,0xe
    800022ec:	d1848493          	addi	s1,s1,-744 # 80010000 <proc>
    800022f0:	b7e1                	j	800022b8 <wait+0xb0>
      release(&wait_lock);
    800022f2:	0000e517          	auipc	a0,0xe
    800022f6:	8f650513          	addi	a0,a0,-1802 # 8000fbe8 <wait_lock>
    800022fa:	993fe0ef          	jal	80000c8c <release>
      return -1;
    800022fe:	59fd                	li	s3,-1
    80002300:	b741                	j	80002280 <wait+0x78>

0000000080002302 <jointhread>:
}
freethread(p->current_thread);
if (!thread_schd(p))
setkilled(p);
}
int jointhread(uint join_id) {
    80002302:	1101                	addi	sp,sp,-32
    80002304:	ec06                	sd	ra,24(sp)
    80002306:	e822                	sd	s0,16(sp)
    80002308:	e426                	sd	s1,8(sp)
    8000230a:	1000                	addi	s0,sp,32
    8000230c:	84aa                	mv	s1,a0
struct proc *p = myproc();
    8000230e:	df4ff0ef          	jal	80001902 <myproc>
struct thread *t = p->current_thread;
    80002312:	1e853803          	ld	a6,488(a0)
if (!t)
    80002316:	04080c63          	beqz	a6,8000236e <jointhread+0x6c>
return -3;
int found = 0;
uint current_id = join_id;
    8000231a:	8626                	mv	a2,s1
int found = 0;
    8000231c:	4301                	li	t1,0
while (current_id != 0) {
if (current_id == t->id)
return -1; // deadlock
uint target_id = current_id;
current_id = 0;
for (int i = 0; i < NTHREAD; i++) {
    8000231e:	4881                	li	a7,0
    80002320:	4591                	li	a1,4
if (p->threads[i].id == target_id) {
current_id = p->threads[i].join;
found = 1;
    80002322:	4e05                	li	t3,1
    80002324:	a031                	j	80002330 <jointhread+0x2e>
current_id = p->threads[i].join;
    80002326:	0796                	slli	a5,a5,0x5
    80002328:	97aa                	add	a5,a5,a0
    8000232a:	17c7a603          	lw	a2,380(a5)
found = 1;
    8000232e:	8372                	mv	t1,t3
while (current_id != 0) {
    80002330:	c205                	beqz	a2,80002350 <jointhread+0x4e>
if (current_id == t->id)
    80002332:	01082783          	lw	a5,16(a6)
    80002336:	02c78e63          	beq	a5,a2,80002372 <jointhread+0x70>
    8000233a:	17850713          	addi	a4,a0,376
for (int i = 0; i < NTHREAD; i++) {
    8000233e:	87c6                	mv	a5,a7
if (p->threads[i].id == target_id) {
    80002340:	4314                	lw	a3,0(a4)
    80002342:	fec682e3          	beq	a3,a2,80002326 <jointhread+0x24>
for (int i = 0; i < NTHREAD; i++) {
    80002346:	2785                	addiw	a5,a5,1
    80002348:	02070713          	addi	a4,a4,32
    8000234c:	feb79ae3          	bne	a5,a1,80002340 <jointhread+0x3e>
break;
}
}
}
if (!found)
    80002350:	02030363          	beqz	t1,80002376 <jointhread+0x74>
return -2;
t->join = join_id;
    80002354:	00982a23          	sw	s1,20(a6)
t->state = THREAD_JOINED;
    80002358:	478d                	li	a5,3
    8000235a:	00f82023          	sw	a5,0(a6)
yield();
    8000235e:	821ff0ef          	jal	80001b7e <yield>
return 0;
    80002362:	4501                	li	a0,0
}
    80002364:	60e2                	ld	ra,24(sp)
    80002366:	6442                	ld	s0,16(sp)
    80002368:	64a2                	ld	s1,8(sp)
    8000236a:	6105                	addi	sp,sp,32
    8000236c:	8082                	ret
return -3;
    8000236e:	5575                	li	a0,-3
    80002370:	bfd5                	j	80002364 <jointhread+0x62>
return -1; // deadlock
    80002372:	557d                	li	a0,-1
    80002374:	bfc5                	j	80002364 <jointhread+0x62>
return -2;
    80002376:	5579                	li	a0,-2
    80002378:	b7f5                	j	80002364 <jointhread+0x62>

000000008000237a <initthread>:
t->state = THREAD_SLEEPING;
thread_schd(myproc());
}

struct thread *initthread(struct proc *p)
{
    8000237a:	7179                	addi	sp,sp,-48
    8000237c:	f406                	sd	ra,40(sp)
    8000237e:	f022                	sd	s0,32(sp)
    80002380:	ec26                	sd	s1,24(sp)
    80002382:	e84a                	sd	s2,16(sp)
    80002384:	1800                	addi	s0,sp,48
    80002386:	84aa                	mv	s1,a0
if (!p->current_thread) {
    80002388:	1e853783          	ld	a5,488(a0)
    8000238c:	cb91                	beqz	a5,800023a0 <initthread+0x26>
return 0;
}
t->state = THREAD_RUNNING;
p->current_thread = t;
}
return p->current_thread;
    8000238e:	1e84b903          	ld	s2,488(s1)
}
    80002392:	854a                	mv	a0,s2
    80002394:	70a2                	ld	ra,40(sp)
    80002396:	7402                	ld	s0,32(sp)
    80002398:	64e2                	ld	s1,24(sp)
    8000239a:	6942                	ld	s2,16(sp)
    8000239c:	6145                	addi	sp,sp,48
    8000239e:	8082                	ret
    800023a0:	e44e                	sd	s3,8(sp)
p->threads[i].trapframe = 0;
    800023a2:	16053823          	sd	zero,368(a0)
freethread(&p->threads[i]);
    800023a6:	16850993          	addi	s3,a0,360
    800023aa:	854e                	mv	a0,s3
    800023ac:	b99ff0ef          	jal	80001f44 <freethread>
p->threads[i].trapframe = 0;
    800023b0:	1804b823          	sd	zero,400(s1)
freethread(&p->threads[i]);
    800023b4:	18848513          	addi	a0,s1,392
    800023b8:	b8dff0ef          	jal	80001f44 <freethread>
p->threads[i].trapframe = 0;
    800023bc:	1a04b823          	sd	zero,432(s1)
freethread(&p->threads[i]);
    800023c0:	1a848513          	addi	a0,s1,424
    800023c4:	b81ff0ef          	jal	80001f44 <freethread>
p->threads[i].trapframe = 0;
    800023c8:	1c04b823          	sd	zero,464(s1)
freethread(&p->threads[i]);
    800023cc:	1c848513          	addi	a0,s1,456
    800023d0:	b75ff0ef          	jal	80001f44 <freethread>
t->id = p->pid;
    800023d4:	589c                	lw	a5,48(s1)
    800023d6:	16f4ac23          	sw	a5,376(s1)
if ((t->trapframe = (struct trapframe *)kalloc()) == 0) {
    800023da:	f4afe0ef          	jal	80000b24 <kalloc>
    800023de:	892a                	mv	s2,a0
    800023e0:	16a4b823          	sd	a0,368(s1)
    800023e4:	c901                	beqz	a0,800023f4 <initthread+0x7a>
t->state = THREAD_RUNNING;
    800023e6:	4789                	li	a5,2
    800023e8:	16f4a423          	sw	a5,360(s1)
p->current_thread = t;
    800023ec:	1f34b423          	sd	s3,488(s1)
    800023f0:	69a2                	ld	s3,8(sp)
    800023f2:	bf71                	j	8000238e <initthread+0x14>
freethread(t);
    800023f4:	854e                	mv	a0,s3
    800023f6:	b4fff0ef          	jal	80001f44 <freethread>
return 0;
    800023fa:	69a2                	ld	s3,8(sp)
    800023fc:	bf59                	j	80002392 <initthread+0x18>

00000000800023fe <allocthread>:
 {
    800023fe:	7139                	addi	sp,sp,-64
    80002400:	fc06                	sd	ra,56(sp)
    80002402:	f822                	sd	s0,48(sp)
    80002404:	f426                	sd	s1,40(sp)
    80002406:	f04a                	sd	s2,32(sp)
    80002408:	e852                	sd	s4,16(sp)
    8000240a:	e456                	sd	s5,8(sp)
    8000240c:	e05a                	sd	s6,0(sp)
    8000240e:	0080                	addi	s0,sp,64
    80002410:	8a2a                	mv	s4,a0
    80002412:	8b2e                	mv	s6,a1
    80002414:	8ab2                	mv	s5,a2
struct proc *p = myproc();
    80002416:	cecff0ef          	jal	80001902 <myproc>
    8000241a:	892a                	mv	s2,a0
if (!initthread(p))
    8000241c:	f5fff0ef          	jal	8000237a <initthread>
    80002420:	84aa                	mv	s1,a0
    80002422:	cd11                	beqz	a0,8000243e <allocthread+0x40>
for (struct thread *t = p->threads; t < p->threads + NTHREAD; t++) {
    80002424:	16890493          	addi	s1,s2,360
    80002428:	1e890713          	addi	a4,s2,488
    8000242c:	08e4f563          	bgeu	s1,a4,800024b6 <allocthread+0xb8>
if (t->state == THREAD_UNUSED) {
    80002430:	409c                	lw	a5,0(s1)
    80002432:	c385                	beqz	a5,80002452 <allocthread+0x54>
for (struct thread *t = p->threads; t < p->threads + NTHREAD; t++) {
    80002434:	02048493          	addi	s1,s1,32
    80002438:	fee49ce3          	bne	s1,a4,80002430 <allocthread+0x32>
return 0;
    8000243c:	4481                	li	s1,0
}
    8000243e:	8526                	mv	a0,s1
    80002440:	70e2                	ld	ra,56(sp)
    80002442:	7442                	ld	s0,48(sp)
    80002444:	74a2                	ld	s1,40(sp)
    80002446:	7902                	ld	s2,32(sp)
    80002448:	6a42                	ld	s4,16(sp)
    8000244a:	6aa2                	ld	s5,8(sp)
    8000244c:	6b02                	ld	s6,0(sp)
    8000244e:	6121                	addi	sp,sp,64
    80002450:	8082                	ret
    80002452:	ec4e                	sd	s3,24(sp)
t->id = allocpid();
    80002454:	d18ff0ef          	jal	8000196c <allocpid>
    80002458:	c888                	sw	a0,16(s1)
if ((t->trapframe = (struct trapframe *)kalloc()) == 0) {
    8000245a:	ecafe0ef          	jal	80000b24 <kalloc>
    8000245e:	89aa                	mv	s3,a0
    80002460:	e488                	sd	a0,8(s1)
    80002462:	c521                	beqz	a0,800024aa <allocthread+0xac>
t->state = THREAD_RUNNABLE;
    80002464:	4785                	li	a5,1
    80002466:	c09c                	sw	a5,0(s1)
*t->trapframe = *p->trapframe;
    80002468:	05893703          	ld	a4,88(s2)
    8000246c:	87aa                	mv	a5,a0
    8000246e:	12070813          	addi	a6,a4,288
    80002472:	6308                	ld	a0,0(a4)
    80002474:	670c                	ld	a1,8(a4)
    80002476:	6b10                	ld	a2,16(a4)
    80002478:	6f14                	ld	a3,24(a4)
    8000247a:	e388                	sd	a0,0(a5)
    8000247c:	e78c                	sd	a1,8(a5)
    8000247e:	eb90                	sd	a2,16(a5)
    80002480:	ef94                	sd	a3,24(a5)
    80002482:	02070713          	addi	a4,a4,32
    80002486:	02078793          	addi	a5,a5,32
    8000248a:	ff0714e3          	bne	a4,a6,80002472 <allocthread+0x74>
t->trapframe->sp = stack_address;
    8000248e:	649c                	ld	a5,8(s1)
    80002490:	0367b823          	sd	s6,48(a5)
t->trapframe->a0 = arg;
    80002494:	649c                	ld	a5,8(s1)
    80002496:	0757b823          	sd	s5,112(a5)
t->trapframe->ra = -1;
    8000249a:	649c                	ld	a5,8(s1)
    8000249c:	577d                	li	a4,-1
    8000249e:	f798                	sd	a4,40(a5)
t->trapframe->epc = (uint64) start_thread;
    800024a0:	649c                	ld	a5,8(s1)
    800024a2:	0147bc23          	sd	s4,24(a5)
return t;
    800024a6:	69e2                	ld	s3,24(sp)
    800024a8:	bf59                	j	8000243e <allocthread+0x40>
freethread(t);
    800024aa:	8526                	mv	a0,s1
    800024ac:	a99ff0ef          	jal	80001f44 <freethread>
return 0;
    800024b0:	84ce                	mv	s1,s3
break;
    800024b2:	69e2                	ld	s3,24(sp)
    800024b4:	b769                	j	8000243e <allocthread+0x40>
return 0;
    800024b6:	4481                	li	s1,0
    800024b8:	b759                	j	8000243e <allocthread+0x40>

00000000800024ba <thread_schd>:




int thread_schd(struct proc *p) {
if (!p->current_thread) {
    800024ba:	1e853783          	ld	a5,488(a0)
    800024be:	cbed                	beqz	a5,800025b0 <thread_schd+0xf6>
int thread_schd(struct proc *p) {
    800024c0:	1101                	addi	sp,sp,-32
    800024c2:	ec06                	sd	ra,24(sp)
    800024c4:	e822                	sd	s0,16(sp)
    800024c6:	e426                	sd	s1,8(sp)
    800024c8:	e04a                	sd	s2,0(sp)
    800024ca:	1000                	addi	s0,sp,32
    800024cc:	84aa                	mv	s1,a0
return 1;
}
if (p->current_thread->state == THREAD_RUNNING) {
    800024ce:	4394                	lw	a3,0(a5)
    800024d0:	4709                	li	a4,2
    800024d2:	02e68c63          	beq	a3,a4,8000250a <thread_schd+0x50>
p->current_thread->state = THREAD_RUNNABLE;
}
acquire(&tickslock);
    800024d6:	00015517          	auipc	a0,0x15
    800024da:	72a50513          	addi	a0,a0,1834 # 80017c00 <tickslock>
    800024de:	f16fe0ef          	jal	80000bf4 <acquire>
uint ticks0 = ticks;
    800024e2:	00005917          	auipc	s2,0x5
    800024e6:	5be92903          	lw	s2,1470(s2) # 80007aa0 <ticks>
release(&tickslock);
    800024ea:	00015517          	auipc	a0,0x15
    800024ee:	71650513          	addi	a0,a0,1814 # 80017c00 <tickslock>
    800024f2:	f9afe0ef          	jal	80000c8c <release>
struct thread *next = 0;
struct thread *t = p->current_thread + 1;
    800024f6:	1e84b803          	ld	a6,488(s1)
    800024fa:	02080793          	addi	a5,a6,32
    800024fe:	4711                	li	a4,4
for (int i = 0; i < NTHREAD; i++, t++) {
if (t >= p->threads + NTHREAD) {
    80002500:	1e848593          	addi	a1,s1,488
t = p->threads;
}
if (t->state == THREAD_RUNNABLE) {
    80002504:	4605                	li	a2,1
next = t;
break;
} else if (t->state == THREAD_SLEEPING && ticks0 - t->sleep_tick0 >= t->sleep_n) {
    80002506:	4511                	li	a0,4
    80002508:	a829                	j	80002522 <thread_schd+0x68>
p->current_thread->state = THREAD_RUNNABLE;
    8000250a:	4705                	li	a4,1
    8000250c:	c398                	sw	a4,0(a5)
    8000250e:	b7e1                	j	800024d6 <thread_schd+0x1c>
if (t->state == THREAD_RUNNABLE) {
    80002510:	4394                	lw	a3,0(a5)
    80002512:	02c68463          	beq	a3,a2,8000253a <thread_schd+0x80>
} else if (t->state == THREAD_SLEEPING && ticks0 - t->sleep_tick0 >= t->sleep_n) {
    80002516:	00a68b63          	beq	a3,a0,8000252c <thread_schd+0x72>
for (int i = 0; i < NTHREAD; i++, t++) {
    8000251a:	02078793          	addi	a5,a5,32
    8000251e:	377d                	addiw	a4,a4,-1
    80002520:	c349                	beqz	a4,800025a2 <thread_schd+0xe8>
if (t >= p->threads + NTHREAD) {
    80002522:	feb7e7e3          	bltu	a5,a1,80002510 <thread_schd+0x56>
t = p->threads;
    80002526:	16848793          	addi	a5,s1,360
    8000252a:	b7dd                	j	80002510 <thread_schd+0x56>
} else if (t->state == THREAD_SLEEPING && ticks0 - t->sleep_tick0 >= t->sleep_n) {
    8000252c:	4fd4                	lw	a3,28(a5)
    8000252e:	40d906bb          	subw	a3,s2,a3
    80002532:	0187a883          	lw	a7,24(a5)
    80002536:	ff16e2e3          	bltu	a3,a7,8000251a <thread_schd+0x60>
break;
}
}
if (next == 0) {
return 0;
} else if (p->current_thread != next) {
    8000253a:	06f80d63          	beq	a6,a5,800025b4 <thread_schd+0xfa>
next->state = THREAD_RUNNING;
    8000253e:	4709                	li	a4,2
    80002540:	c398                	sw	a4,0(a5)
struct thread *t = p->current_thread;
    80002542:	1e84b703          	ld	a4,488(s1)
p->current_thread = next;
    80002546:	1ef4b423          	sd	a5,488(s1)
if (t->trapframe) {
    8000254a:	6714                	ld	a3,8(a4)
    8000254c:	c685                	beqz	a3,80002574 <thread_schd+0xba>
*t->trapframe = *p->trapframe;
    8000254e:	6cb8                	ld	a4,88(s1)
    80002550:	12070893          	addi	a7,a4,288
    80002554:	00073803          	ld	a6,0(a4)
    80002558:	6708                	ld	a0,8(a4)
    8000255a:	6b0c                	ld	a1,16(a4)
    8000255c:	6f10                	ld	a2,24(a4)
    8000255e:	0106b023          	sd	a6,0(a3)
    80002562:	e688                	sd	a0,8(a3)
    80002564:	ea8c                	sd	a1,16(a3)
    80002566:	ee90                	sd	a2,24(a3)
    80002568:	02070713          	addi	a4,a4,32
    8000256c:	02068693          	addi	a3,a3,32
    80002570:	ff1712e3          	bne	a4,a7,80002554 <thread_schd+0x9a>
}
*p->trapframe = *next->trapframe;
    80002574:	6794                	ld	a3,8(a5)
    80002576:	87b6                	mv	a5,a3
    80002578:	6cb8                	ld	a4,88(s1)
    8000257a:	12068693          	addi	a3,a3,288
    8000257e:	0007b803          	ld	a6,0(a5)
    80002582:	6788                	ld	a0,8(a5)
    80002584:	6b8c                	ld	a1,16(a5)
    80002586:	6f90                	ld	a2,24(a5)
    80002588:	01073023          	sd	a6,0(a4)
    8000258c:	e708                	sd	a0,8(a4)
    8000258e:	eb0c                	sd	a1,16(a4)
    80002590:	ef10                	sd	a2,24(a4)
    80002592:	02078793          	addi	a5,a5,32
    80002596:	02070713          	addi	a4,a4,32
    8000259a:	fed792e3          	bne	a5,a3,8000257e <thread_schd+0xc4>
}
return 1;
    8000259e:	4505                	li	a0,1
    800025a0:	a011                	j	800025a4 <thread_schd+0xea>
return 0;
    800025a2:	4501                	li	a0,0
}
    800025a4:	60e2                	ld	ra,24(sp)
    800025a6:	6442                	ld	s0,16(sp)
    800025a8:	64a2                	ld	s1,8(sp)
    800025aa:	6902                	ld	s2,0(sp)
    800025ac:	6105                	addi	sp,sp,32
    800025ae:	8082                	ret
return 1;
    800025b0:	4505                	li	a0,1
}
    800025b2:	8082                	ret
return 1;
    800025b4:	4505                	li	a0,1
    800025b6:	b7fd                	j	800025a4 <thread_schd+0xea>

00000000800025b8 <scheduler>:
{
    800025b8:	715d                	addi	sp,sp,-80
    800025ba:	e486                	sd	ra,72(sp)
    800025bc:	e0a2                	sd	s0,64(sp)
    800025be:	fc26                	sd	s1,56(sp)
    800025c0:	f84a                	sd	s2,48(sp)
    800025c2:	f44e                	sd	s3,40(sp)
    800025c4:	f052                	sd	s4,32(sp)
    800025c6:	ec56                	sd	s5,24(sp)
    800025c8:	e85a                	sd	s6,16(sp)
    800025ca:	e45e                	sd	s7,8(sp)
    800025cc:	e062                	sd	s8,0(sp)
    800025ce:	0880                	addi	s0,sp,80
    800025d0:	8792                	mv	a5,tp
  int id = r_tp();
    800025d2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800025d4:	00779b13          	slli	s6,a5,0x7
    800025d8:	0000d717          	auipc	a4,0xd
    800025dc:	5f870713          	addi	a4,a4,1528 # 8000fbd0 <pid_lock>
    800025e0:	975a                	add	a4,a4,s6
    800025e2:	02073823          	sd	zero,48(a4)
    swtch(&c->context, &p->context);
    800025e6:	0000d717          	auipc	a4,0xd
    800025ea:	62270713          	addi	a4,a4,1570 # 8000fc08 <cpus+0x8>
    800025ee:	9b3a                	add	s6,s6,a4
    p->state = RUNNING;
    800025f0:	4c11                	li	s8,4
    c->proc = p;
    800025f2:	079e                	slli	a5,a5,0x7
    800025f4:	0000da17          	auipc	s4,0xd
    800025f8:	5dca0a13          	addi	s4,s4,1500 # 8000fbd0 <pid_lock>
    800025fc:	9a3e                	add	s4,s4,a5
    found = 1;
    800025fe:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80002600:	00015997          	auipc	s3,0x15
    80002604:	60098993          	addi	s3,s3,1536 # 80017c00 <tickslock>
    80002608:	a889                	j	8000265a <scheduler+0xa2>
      release(&p->lock);
    8000260a:	8526                	mv	a0,s1
    8000260c:	e80fe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002610:	1f048493          	addi	s1,s1,496
    80002614:	03348963          	beq	s1,s3,80002646 <scheduler+0x8e>
      acquire(&p->lock);
    80002618:	8526                	mv	a0,s1
    8000261a:	ddafe0ef          	jal	80000bf4 <acquire>
     if (p->state == RUNNABLE) {
    8000261e:	4c9c                	lw	a5,24(s1)
    80002620:	ff2795e3          	bne	a5,s2,8000260a <scheduler+0x52>
  if (thread_schd(p)) {
    80002624:	8526                	mv	a0,s1
    80002626:	e95ff0ef          	jal	800024ba <thread_schd>
    8000262a:	d165                	beqz	a0,8000260a <scheduler+0x52>
    p->state = RUNNING;
    8000262c:	0184ac23          	sw	s8,24(s1)
    c->proc = p;
    80002630:	029a3823          	sd	s1,48(s4)
    swtch(&c->context, &p->context);
    80002634:	06048593          	addi	a1,s1,96
    80002638:	855a                	mv	a0,s6
    8000263a:	0d6000ef          	jal	80002710 <swtch>
    c->proc = 0;
    8000263e:	020a3823          	sd	zero,48(s4)
    found = 1;
    80002642:	8ade                	mv	s5,s7
    80002644:	b7d9                	j	8000260a <scheduler+0x52>
    if(found == 0) {
    80002646:	000a9a63          	bnez	s5,8000265a <scheduler+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000264e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002652:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002656:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000265e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002662:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002666:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002668:	0000e497          	auipc	s1,0xe
    8000266c:	99848493          	addi	s1,s1,-1640 # 80010000 <proc>
     if (p->state == RUNNABLE) {
    80002670:	490d                	li	s2,3
    80002672:	b75d                	j	80002618 <scheduler+0x60>

0000000080002674 <exitthread>:
void exitthread() {
    80002674:	1101                	addi	sp,sp,-32
    80002676:	ec06                	sd	ra,24(sp)
    80002678:	e822                	sd	s0,16(sp)
    8000267a:	e426                	sd	s1,8(sp)
    8000267c:	1000                	addi	s0,sp,32
struct proc *p = myproc();
    8000267e:	a84ff0ef          	jal	80001902 <myproc>
    80002682:	84aa                	mv	s1,a0
for (struct thread *t = p->threads; t < p->threads + NTHREAD; t++) {
    80002684:	16850793          	addi	a5,a0,360
    80002688:	1e850693          	addi	a3,a0,488
    8000268c:	02d7f663          	bgeu	a5,a3,800026b8 <exitthread+0x44>
uint id = p->current_thread->id;
    80002690:	1e853703          	ld	a4,488(a0)
    80002694:	4b0c                	lw	a1,16(a4)
  if (t->state == THREAD_JOINED && t->join == id) {
    80002696:	460d                	li	a2,3
    80002698:	a029                	j	800026a2 <exitthread+0x2e>
for (struct thread *t = p->threads; t < p->threads + NTHREAD; t++) {
    8000269a:	02078793          	addi	a5,a5,32
    8000269e:	00d78d63          	beq	a5,a3,800026b8 <exitthread+0x44>
  if (t->state == THREAD_JOINED && t->join == id) {
    800026a2:	4398                	lw	a4,0(a5)
    800026a4:	fec71be3          	bne	a4,a2,8000269a <exitthread+0x26>
    800026a8:	4bd8                	lw	a4,20(a5)
    800026aa:	feb718e3          	bne	a4,a1,8000269a <exitthread+0x26>
t->join = 0;
    800026ae:	0007aa23          	sw	zero,20(a5)
t->state = THREAD_RUNNABLE;
    800026b2:	4705                	li	a4,1
    800026b4:	c398                	sw	a4,0(a5)
    800026b6:	b7d5                	j	8000269a <exitthread+0x26>
freethread(p->current_thread);
    800026b8:	1e84b503          	ld	a0,488(s1)
    800026bc:	889ff0ef          	jal	80001f44 <freethread>
if (!thread_schd(p))
    800026c0:	8526                	mv	a0,s1
    800026c2:	df9ff0ef          	jal	800024ba <thread_schd>
    800026c6:	c511                	beqz	a0,800026d2 <exitthread+0x5e>
}
    800026c8:	60e2                	ld	ra,24(sp)
    800026ca:	6442                	ld	s0,16(sp)
    800026cc:	64a2                	ld	s1,8(sp)
    800026ce:	6105                	addi	sp,sp,32
    800026d0:	8082                	ret
setkilled(p);
    800026d2:	8526                	mv	a0,s1
    800026d4:	eeaff0ef          	jal	80001dbe <setkilled>
}
    800026d8:	bfc5                	j	800026c8 <exitthread+0x54>

00000000800026da <sleepthread>:
void sleepthread(int n, uint ticks0) {
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	e04a                	sd	s2,0(sp)
    800026e4:	1000                	addi	s0,sp,32
    800026e6:	892a                	mv	s2,a0
    800026e8:	84ae                	mv	s1,a1
struct thread *t = myproc()->current_thread;
    800026ea:	a18ff0ef          	jal	80001902 <myproc>
    800026ee:	1e853783          	ld	a5,488(a0)
t->sleep_n = n;
    800026f2:	0127ac23          	sw	s2,24(a5)
t->sleep_tick0 = ticks0;
    800026f6:	cfc4                	sw	s1,28(a5)
t->state = THREAD_SLEEPING;
    800026f8:	4711                	li	a4,4
    800026fa:	c398                	sw	a4,0(a5)
thread_schd(myproc());
    800026fc:	a06ff0ef          	jal	80001902 <myproc>
    80002700:	dbbff0ef          	jal	800024ba <thread_schd>
}
    80002704:	60e2                	ld	ra,24(sp)
    80002706:	6442                	ld	s0,16(sp)
    80002708:	64a2                	ld	s1,8(sp)
    8000270a:	6902                	ld	s2,0(sp)
    8000270c:	6105                	addi	sp,sp,32
    8000270e:	8082                	ret

0000000080002710 <swtch>:
    80002710:	00153023          	sd	ra,0(a0)
    80002714:	00253423          	sd	sp,8(a0)
    80002718:	e900                	sd	s0,16(a0)
    8000271a:	ed04                	sd	s1,24(a0)
    8000271c:	03253023          	sd	s2,32(a0)
    80002720:	03353423          	sd	s3,40(a0)
    80002724:	03453823          	sd	s4,48(a0)
    80002728:	03553c23          	sd	s5,56(a0)
    8000272c:	05653023          	sd	s6,64(a0)
    80002730:	05753423          	sd	s7,72(a0)
    80002734:	05853823          	sd	s8,80(a0)
    80002738:	05953c23          	sd	s9,88(a0)
    8000273c:	07a53023          	sd	s10,96(a0)
    80002740:	07b53423          	sd	s11,104(a0)
    80002744:	0005b083          	ld	ra,0(a1)
    80002748:	0085b103          	ld	sp,8(a1)
    8000274c:	6980                	ld	s0,16(a1)
    8000274e:	6d84                	ld	s1,24(a1)
    80002750:	0205b903          	ld	s2,32(a1)
    80002754:	0285b983          	ld	s3,40(a1)
    80002758:	0305ba03          	ld	s4,48(a1)
    8000275c:	0385ba83          	ld	s5,56(a1)
    80002760:	0405bb03          	ld	s6,64(a1)
    80002764:	0485bb83          	ld	s7,72(a1)
    80002768:	0505bc03          	ld	s8,80(a1)
    8000276c:	0585bc83          	ld	s9,88(a1)
    80002770:	0605bd03          	ld	s10,96(a1)
    80002774:	0685bd83          	ld	s11,104(a1)
    80002778:	8082                	ret

000000008000277a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000277a:	1141                	addi	sp,sp,-16
    8000277c:	e406                	sd	ra,8(sp)
    8000277e:	e022                	sd	s0,0(sp)
    80002780:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002782:	00005597          	auipc	a1,0x5
    80002786:	c6658593          	addi	a1,a1,-922 # 800073e8 <etext+0x3e8>
    8000278a:	00015517          	auipc	a0,0x15
    8000278e:	47650513          	addi	a0,a0,1142 # 80017c00 <tickslock>
    80002792:	be2fe0ef          	jal	80000b74 <initlock>
}
    80002796:	60a2                	ld	ra,8(sp)
    80002798:	6402                	ld	s0,0(sp)
    8000279a:	0141                	addi	sp,sp,16
    8000279c:	8082                	ret

000000008000279e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000279e:	1141                	addi	sp,sp,-16
    800027a0:	e422                	sd	s0,8(sp)
    800027a2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027a4:	00003797          	auipc	a5,0x3
    800027a8:	ebc78793          	addi	a5,a5,-324 # 80005660 <kernelvec>
    800027ac:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027b0:	6422                	ld	s0,8(sp)
    800027b2:	0141                	addi	sp,sp,16
    800027b4:	8082                	ret

00000000800027b6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800027b6:	1141                	addi	sp,sp,-16
    800027b8:	e406                	sd	ra,8(sp)
    800027ba:	e022                	sd	s0,0(sp)
    800027bc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027be:	944ff0ef          	jal	80001902 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027c6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027c8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027cc:	00004697          	auipc	a3,0x4
    800027d0:	83468693          	addi	a3,a3,-1996 # 80006000 <_trampoline>
    800027d4:	00004717          	auipc	a4,0x4
    800027d8:	82c70713          	addi	a4,a4,-2004 # 80006000 <_trampoline>
    800027dc:	8f15                	sub	a4,a4,a3
    800027de:	040007b7          	lui	a5,0x4000
    800027e2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800027e4:	07b2                	slli	a5,a5,0xc
    800027e6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027e8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800027ec:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800027ee:	18002673          	csrr	a2,satp
    800027f2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800027f4:	6d30                	ld	a2,88(a0)
    800027f6:	6138                	ld	a4,64(a0)
    800027f8:	6585                	lui	a1,0x1
    800027fa:	972e                	add	a4,a4,a1
    800027fc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800027fe:	6d38                	ld	a4,88(a0)
    80002800:	00000617          	auipc	a2,0x0
    80002804:	11060613          	addi	a2,a2,272 # 80002910 <usertrap>
    80002808:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000280a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000280c:	8612                	mv	a2,tp
    8000280e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002810:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002814:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002818:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000281c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002820:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002822:	6f18                	ld	a4,24(a4)
    80002824:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002828:	6928                	ld	a0,80(a0)
    8000282a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000282c:	00004717          	auipc	a4,0x4
    80002830:	87070713          	addi	a4,a4,-1936 # 8000609c <userret>
    80002834:	8f15                	sub	a4,a4,a3
    80002836:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002838:	577d                	li	a4,-1
    8000283a:	177e                	slli	a4,a4,0x3f
    8000283c:	8d59                	or	a0,a0,a4
    8000283e:	9782                	jalr	a5
}
    80002840:	60a2                	ld	ra,8(sp)
    80002842:	6402                	ld	s0,0(sp)
    80002844:	0141                	addi	sp,sp,16
    80002846:	8082                	ret

0000000080002848 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002848:	1101                	addi	sp,sp,-32
    8000284a:	ec06                	sd	ra,24(sp)
    8000284c:	e822                	sd	s0,16(sp)
    8000284e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002850:	886ff0ef          	jal	800018d6 <cpuid>
    80002854:	cd11                	beqz	a0,80002870 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002856:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000285a:	000f4737          	lui	a4,0xf4
    8000285e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002862:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002864:	14d79073          	csrw	stimecmp,a5
}
    80002868:	60e2                	ld	ra,24(sp)
    8000286a:	6442                	ld	s0,16(sp)
    8000286c:	6105                	addi	sp,sp,32
    8000286e:	8082                	ret
    80002870:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002872:	00015497          	auipc	s1,0x15
    80002876:	38e48493          	addi	s1,s1,910 # 80017c00 <tickslock>
    8000287a:	8526                	mv	a0,s1
    8000287c:	b78fe0ef          	jal	80000bf4 <acquire>
    ticks++;
    80002880:	00005517          	auipc	a0,0x5
    80002884:	22050513          	addi	a0,a0,544 # 80007aa0 <ticks>
    80002888:	411c                	lw	a5,0(a0)
    8000288a:	2785                	addiw	a5,a5,1
    8000288c:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000288e:	b68ff0ef          	jal	80001bf6 <wakeup>
    release(&tickslock);
    80002892:	8526                	mv	a0,s1
    80002894:	bf8fe0ef          	jal	80000c8c <release>
    80002898:	64a2                	ld	s1,8(sp)
    8000289a:	bf75                	j	80002856 <clockintr+0xe>

000000008000289c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000289c:	1101                	addi	sp,sp,-32
    8000289e:	ec06                	sd	ra,24(sp)
    800028a0:	e822                	sd	s0,16(sp)
    800028a2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028a4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800028a8:	57fd                	li	a5,-1
    800028aa:	17fe                	slli	a5,a5,0x3f
    800028ac:	07a5                	addi	a5,a5,9
    800028ae:	00f70c63          	beq	a4,a5,800028c6 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800028b2:	57fd                	li	a5,-1
    800028b4:	17fe                	slli	a5,a5,0x3f
    800028b6:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800028b8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800028ba:	04f70763          	beq	a4,a5,80002908 <devintr+0x6c>
  }
}
    800028be:	60e2                	ld	ra,24(sp)
    800028c0:	6442                	ld	s0,16(sp)
    800028c2:	6105                	addi	sp,sp,32
    800028c4:	8082                	ret
    800028c6:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800028c8:	645020ef          	jal	8000570c <plic_claim>
    800028cc:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800028ce:	47a9                	li	a5,10
    800028d0:	00f50963          	beq	a0,a5,800028e2 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800028d4:	4785                	li	a5,1
    800028d6:	00f50963          	beq	a0,a5,800028e8 <devintr+0x4c>
    return 1;
    800028da:	4505                	li	a0,1
    } else if(irq){
    800028dc:	e889                	bnez	s1,800028ee <devintr+0x52>
    800028de:	64a2                	ld	s1,8(sp)
    800028e0:	bff9                	j	800028be <devintr+0x22>
      uartintr();
    800028e2:	924fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800028e6:	a819                	j	800028fc <devintr+0x60>
      virtio_disk_intr();
    800028e8:	39c030ef          	jal	80005c84 <virtio_disk_intr>
    if(irq)
    800028ec:	a801                	j	800028fc <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800028ee:	85a6                	mv	a1,s1
    800028f0:	00005517          	auipc	a0,0x5
    800028f4:	b0050513          	addi	a0,a0,-1280 # 800073f0 <etext+0x3f0>
    800028f8:	bcbfd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    800028fc:	8526                	mv	a0,s1
    800028fe:	62f020ef          	jal	8000572c <plic_complete>
    return 1;
    80002902:	4505                	li	a0,1
    80002904:	64a2                	ld	s1,8(sp)
    80002906:	bf65                	j	800028be <devintr+0x22>
    clockintr();
    80002908:	f41ff0ef          	jal	80002848 <clockintr>
    return 2;
    8000290c:	4509                	li	a0,2
    8000290e:	bf45                	j	800028be <devintr+0x22>

0000000080002910 <usertrap>:
{
    80002910:	1101                	addi	sp,sp,-32
    80002912:	ec06                	sd	ra,24(sp)
    80002914:	e822                	sd	s0,16(sp)
    80002916:	e426                	sd	s1,8(sp)
    80002918:	e04a                	sd	s2,0(sp)
    8000291a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000291c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002920:	1007f793          	andi	a5,a5,256
    80002924:	efb5                	bnez	a5,800029a0 <usertrap+0x90>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002926:	00003797          	auipc	a5,0x3
    8000292a:	d3a78793          	addi	a5,a5,-710 # 80005660 <kernelvec>
    8000292e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002932:	fd1fe0ef          	jal	80001902 <myproc>
    80002936:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002938:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000293a:	14102773          	csrr	a4,sepc
    8000293e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002940:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002944:	47a1                	li	a5,8
    80002946:	06f70363          	beq	a4,a5,800029ac <usertrap+0x9c>
  } else if((which_dev = devintr()) != 0){
    8000294a:	f53ff0ef          	jal	8000289c <devintr>
    8000294e:	892a                	mv	s2,a0
    80002950:	e14d                	bnez	a0,800029f2 <usertrap+0xe2>
  } else if (p->current_thread && p->current_thread->id != p->pid){
    80002952:	1e84b783          	ld	a5,488(s1)
    80002956:	cbd1                	beqz	a5,800029ea <usertrap+0xda>
    80002958:	5890                	lw	a2,48(s1)
    8000295a:	4b9c                	lw	a5,16(a5)
    8000295c:	08c78763          	beq	a5,a2,800029ea <usertrap+0xda>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002960:	141027f3          	csrr	a5,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002964:	14302773          	csrr	a4,stval
    if (r_sepc() != r_stval() || r_scause() != 0xc) {
    80002968:	00f71763          	bne	a4,a5,80002976 <usertrap+0x66>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000296c:	14202773          	csrr	a4,scause
    80002970:	47b1                	li	a5,12
    80002972:	02f70463          	beq	a4,a5,8000299a <usertrap+0x8a>
    80002976:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000297a:	00005517          	auipc	a0,0x5
    8000297e:	ab650513          	addi	a0,a0,-1354 # 80007430 <etext+0x430>
    80002982:	b41fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002986:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000298a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000298e:	00005517          	auipc	a0,0x5
    80002992:	ad250513          	addi	a0,a0,-1326 # 80007460 <etext+0x460>
    80002996:	b2dfd0ef          	jal	800004c2 <printf>
    exitthread();
    8000299a:	cdbff0ef          	jal	80002674 <exitthread>
    8000299e:	a035                	j	800029ca <usertrap+0xba>
    panic("usertrap: not from user mode");
    800029a0:	00005517          	auipc	a0,0x5
    800029a4:	a7050513          	addi	a0,a0,-1424 # 80007410 <etext+0x410>
    800029a8:	dedfd0ef          	jal	80000794 <panic>
    if(killed(p))
    800029ac:	c36ff0ef          	jal	80001de2 <killed>
    800029b0:	e90d                	bnez	a0,800029e2 <usertrap+0xd2>
    p->trapframe->epc += 4;
    800029b2:	6cb8                	ld	a4,88(s1)
    800029b4:	6f1c                	ld	a5,24(a4)
    800029b6:	0791                	addi	a5,a5,4
    800029b8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029be:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029c2:	10079073          	csrw	sstatus,a5
    syscall();
    800029c6:	22c000ef          	jal	80002bf2 <syscall>
  if(killed(p))
    800029ca:	8526                	mv	a0,s1
    800029cc:	c16ff0ef          	jal	80001de2 <killed>
    800029d0:	e515                	bnez	a0,800029fc <usertrap+0xec>
  usertrapret();
    800029d2:	de5ff0ef          	jal	800027b6 <usertrapret>
}
    800029d6:	60e2                	ld	ra,24(sp)
    800029d8:	6442                	ld	s0,16(sp)
    800029da:	64a2                	ld	s1,8(sp)
    800029dc:	6902                	ld	s2,0(sp)
    800029de:	6105                	addi	sp,sp,32
    800029e0:	8082                	ret
      exit(-1);
    800029e2:	557d                	li	a0,-1
    800029e4:	ad2ff0ef          	jal	80001cb6 <exit>
    800029e8:	b7e9                	j	800029b2 <usertrap+0xa2>
    setkilled(p);
    800029ea:	8526                	mv	a0,s1
    800029ec:	bd2ff0ef          	jal	80001dbe <setkilled>
    800029f0:	bfe9                	j	800029ca <usertrap+0xba>
  if(killed(p))
    800029f2:	8526                	mv	a0,s1
    800029f4:	beeff0ef          	jal	80001de2 <killed>
    800029f8:	c511                	beqz	a0,80002a04 <usertrap+0xf4>
    800029fa:	a011                	j	800029fe <usertrap+0xee>
    800029fc:	4901                	li	s2,0
    exit(-1);
    800029fe:	557d                	li	a0,-1
    80002a00:	ab6ff0ef          	jal	80001cb6 <exit>
  if(which_dev == 2)
    80002a04:	4789                	li	a5,2
    80002a06:	fcf916e3          	bne	s2,a5,800029d2 <usertrap+0xc2>
    yield();
    80002a0a:	974ff0ef          	jal	80001b7e <yield>
    80002a0e:	b7d1                	j	800029d2 <usertrap+0xc2>

0000000080002a10 <kerneltrap>:
{
    80002a10:	7179                	addi	sp,sp,-48
    80002a12:	f406                	sd	ra,40(sp)
    80002a14:	f022                	sd	s0,32(sp)
    80002a16:	ec26                	sd	s1,24(sp)
    80002a18:	e84a                	sd	s2,16(sp)
    80002a1a:	e44e                	sd	s3,8(sp)
    80002a1c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a1e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a22:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a26:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a2a:	1004f793          	andi	a5,s1,256
    80002a2e:	c795                	beqz	a5,80002a5a <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a30:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a34:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a36:	eb85                	bnez	a5,80002a66 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002a38:	e65ff0ef          	jal	8000289c <devintr>
    80002a3c:	c91d                	beqz	a0,80002a72 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002a3e:	4789                	li	a5,2
    80002a40:	04f50a63          	beq	a0,a5,80002a94 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a44:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a48:	10049073          	csrw	sstatus,s1
}
    80002a4c:	70a2                	ld	ra,40(sp)
    80002a4e:	7402                	ld	s0,32(sp)
    80002a50:	64e2                	ld	s1,24(sp)
    80002a52:	6942                	ld	s2,16(sp)
    80002a54:	69a2                	ld	s3,8(sp)
    80002a56:	6145                	addi	sp,sp,48
    80002a58:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a5a:	00005517          	auipc	a0,0x5
    80002a5e:	a2e50513          	addi	a0,a0,-1490 # 80007488 <etext+0x488>
    80002a62:	d33fd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a66:	00005517          	auipc	a0,0x5
    80002a6a:	a4a50513          	addi	a0,a0,-1462 # 800074b0 <etext+0x4b0>
    80002a6e:	d27fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a72:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a76:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002a7a:	85ce                	mv	a1,s3
    80002a7c:	00005517          	auipc	a0,0x5
    80002a80:	a5450513          	addi	a0,a0,-1452 # 800074d0 <etext+0x4d0>
    80002a84:	a3ffd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002a88:	00005517          	auipc	a0,0x5
    80002a8c:	a7050513          	addi	a0,a0,-1424 # 800074f8 <etext+0x4f8>
    80002a90:	d05fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002a94:	e6ffe0ef          	jal	80001902 <myproc>
    80002a98:	d555                	beqz	a0,80002a44 <kerneltrap+0x34>
    yield();
    80002a9a:	8e4ff0ef          	jal	80001b7e <yield>
    80002a9e:	b75d                	j	80002a44 <kerneltrap+0x34>

0000000080002aa0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002aa0:	1101                	addi	sp,sp,-32
    80002aa2:	ec06                	sd	ra,24(sp)
    80002aa4:	e822                	sd	s0,16(sp)
    80002aa6:	e426                	sd	s1,8(sp)
    80002aa8:	1000                	addi	s0,sp,32
    80002aaa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002aac:	e57fe0ef          	jal	80001902 <myproc>
  switch (n) {
    80002ab0:	4795                	li	a5,5
    80002ab2:	0497e163          	bltu	a5,s1,80002af4 <argraw+0x54>
    80002ab6:	048a                	slli	s1,s1,0x2
    80002ab8:	00005717          	auipc	a4,0x5
    80002abc:	e6870713          	addi	a4,a4,-408 # 80007920 <states.0+0x30>
    80002ac0:	94ba                	add	s1,s1,a4
    80002ac2:	409c                	lw	a5,0(s1)
    80002ac4:	97ba                	add	a5,a5,a4
    80002ac6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ac8:	6d3c                	ld	a5,88(a0)
    80002aca:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002acc:	60e2                	ld	ra,24(sp)
    80002ace:	6442                	ld	s0,16(sp)
    80002ad0:	64a2                	ld	s1,8(sp)
    80002ad2:	6105                	addi	sp,sp,32
    80002ad4:	8082                	ret
    return p->trapframe->a1;
    80002ad6:	6d3c                	ld	a5,88(a0)
    80002ad8:	7fa8                	ld	a0,120(a5)
    80002ada:	bfcd                	j	80002acc <argraw+0x2c>
    return p->trapframe->a2;
    80002adc:	6d3c                	ld	a5,88(a0)
    80002ade:	63c8                	ld	a0,128(a5)
    80002ae0:	b7f5                	j	80002acc <argraw+0x2c>
    return p->trapframe->a3;
    80002ae2:	6d3c                	ld	a5,88(a0)
    80002ae4:	67c8                	ld	a0,136(a5)
    80002ae6:	b7dd                	j	80002acc <argraw+0x2c>
    return p->trapframe->a4;
    80002ae8:	6d3c                	ld	a5,88(a0)
    80002aea:	6bc8                	ld	a0,144(a5)
    80002aec:	b7c5                	j	80002acc <argraw+0x2c>
    return p->trapframe->a5;
    80002aee:	6d3c                	ld	a5,88(a0)
    80002af0:	6fc8                	ld	a0,152(a5)
    80002af2:	bfe9                	j	80002acc <argraw+0x2c>
  panic("argraw");
    80002af4:	00005517          	auipc	a0,0x5
    80002af8:	a1450513          	addi	a0,a0,-1516 # 80007508 <etext+0x508>
    80002afc:	c99fd0ef          	jal	80000794 <panic>

0000000080002b00 <fetchaddr>:
{
    80002b00:	1101                	addi	sp,sp,-32
    80002b02:	ec06                	sd	ra,24(sp)
    80002b04:	e822                	sd	s0,16(sp)
    80002b06:	e426                	sd	s1,8(sp)
    80002b08:	e04a                	sd	s2,0(sp)
    80002b0a:	1000                	addi	s0,sp,32
    80002b0c:	84aa                	mv	s1,a0
    80002b0e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b10:	df3fe0ef          	jal	80001902 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b14:	653c                	ld	a5,72(a0)
    80002b16:	02f4f663          	bgeu	s1,a5,80002b42 <fetchaddr+0x42>
    80002b1a:	00848713          	addi	a4,s1,8
    80002b1e:	02e7e463          	bltu	a5,a4,80002b46 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b22:	46a1                	li	a3,8
    80002b24:	8626                	mv	a2,s1
    80002b26:	85ca                	mv	a1,s2
    80002b28:	6928                	ld	a0,80(a0)
    80002b2a:	b29fe0ef          	jal	80001652 <copyin>
    80002b2e:	00a03533          	snez	a0,a0
    80002b32:	40a00533          	neg	a0,a0
}
    80002b36:	60e2                	ld	ra,24(sp)
    80002b38:	6442                	ld	s0,16(sp)
    80002b3a:	64a2                	ld	s1,8(sp)
    80002b3c:	6902                	ld	s2,0(sp)
    80002b3e:	6105                	addi	sp,sp,32
    80002b40:	8082                	ret
    return -1;
    80002b42:	557d                	li	a0,-1
    80002b44:	bfcd                	j	80002b36 <fetchaddr+0x36>
    80002b46:	557d                	li	a0,-1
    80002b48:	b7fd                	j	80002b36 <fetchaddr+0x36>

0000000080002b4a <fetchstr>:
{
    80002b4a:	7179                	addi	sp,sp,-48
    80002b4c:	f406                	sd	ra,40(sp)
    80002b4e:	f022                	sd	s0,32(sp)
    80002b50:	ec26                	sd	s1,24(sp)
    80002b52:	e84a                	sd	s2,16(sp)
    80002b54:	e44e                	sd	s3,8(sp)
    80002b56:	1800                	addi	s0,sp,48
    80002b58:	892a                	mv	s2,a0
    80002b5a:	84ae                	mv	s1,a1
    80002b5c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b5e:	da5fe0ef          	jal	80001902 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b62:	86ce                	mv	a3,s3
    80002b64:	864a                	mv	a2,s2
    80002b66:	85a6                	mv	a1,s1
    80002b68:	6928                	ld	a0,80(a0)
    80002b6a:	b6ffe0ef          	jal	800016d8 <copyinstr>
    80002b6e:	00054c63          	bltz	a0,80002b86 <fetchstr+0x3c>
  return strlen(buf);
    80002b72:	8526                	mv	a0,s1
    80002b74:	ac4fe0ef          	jal	80000e38 <strlen>
}
    80002b78:	70a2                	ld	ra,40(sp)
    80002b7a:	7402                	ld	s0,32(sp)
    80002b7c:	64e2                	ld	s1,24(sp)
    80002b7e:	6942                	ld	s2,16(sp)
    80002b80:	69a2                	ld	s3,8(sp)
    80002b82:	6145                	addi	sp,sp,48
    80002b84:	8082                	ret
    return -1;
    80002b86:	557d                	li	a0,-1
    80002b88:	bfc5                	j	80002b78 <fetchstr+0x2e>

0000000080002b8a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b8a:	1101                	addi	sp,sp,-32
    80002b8c:	ec06                	sd	ra,24(sp)
    80002b8e:	e822                	sd	s0,16(sp)
    80002b90:	e426                	sd	s1,8(sp)
    80002b92:	1000                	addi	s0,sp,32
    80002b94:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b96:	f0bff0ef          	jal	80002aa0 <argraw>
    80002b9a:	c088                	sw	a0,0(s1)
}
    80002b9c:	60e2                	ld	ra,24(sp)
    80002b9e:	6442                	ld	s0,16(sp)
    80002ba0:	64a2                	ld	s1,8(sp)
    80002ba2:	6105                	addi	sp,sp,32
    80002ba4:	8082                	ret

0000000080002ba6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	1000                	addi	s0,sp,32
    80002bb0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bb2:	eefff0ef          	jal	80002aa0 <argraw>
    80002bb6:	e088                	sd	a0,0(s1)
}
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bc2:	7179                	addi	sp,sp,-48
    80002bc4:	f406                	sd	ra,40(sp)
    80002bc6:	f022                	sd	s0,32(sp)
    80002bc8:	ec26                	sd	s1,24(sp)
    80002bca:	e84a                	sd	s2,16(sp)
    80002bcc:	1800                	addi	s0,sp,48
    80002bce:	84ae                	mv	s1,a1
    80002bd0:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002bd2:	fd840593          	addi	a1,s0,-40
    80002bd6:	fd1ff0ef          	jal	80002ba6 <argaddr>
  return fetchstr(addr, buf, max);
    80002bda:	864a                	mv	a2,s2
    80002bdc:	85a6                	mv	a1,s1
    80002bde:	fd843503          	ld	a0,-40(s0)
    80002be2:	f69ff0ef          	jal	80002b4a <fetchstr>
}
    80002be6:	70a2                	ld	ra,40(sp)
    80002be8:	7402                	ld	s0,32(sp)
    80002bea:	64e2                	ld	s1,24(sp)
    80002bec:	6942                	ld	s2,16(sp)
    80002bee:	6145                	addi	sp,sp,48
    80002bf0:	8082                	ret

0000000080002bf2 <syscall>:

};

void
syscall(void)
{
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	e426                	sd	s1,8(sp)
    80002bfa:	e04a                	sd	s2,0(sp)
    80002bfc:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bfe:	d05fe0ef          	jal	80001902 <myproc>
    80002c02:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c04:	05853903          	ld	s2,88(a0)
    80002c08:	0a893783          	ld	a5,168(s2)
    80002c0c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c10:	37fd                	addiw	a5,a5,-1
    80002c12:	475d                	li	a4,23
    80002c14:	00f76f63          	bltu	a4,a5,80002c32 <syscall+0x40>
    80002c18:	00369713          	slli	a4,a3,0x3
    80002c1c:	00005797          	auipc	a5,0x5
    80002c20:	d1c78793          	addi	a5,a5,-740 # 80007938 <syscalls>
    80002c24:	97ba                	add	a5,a5,a4
    80002c26:	639c                	ld	a5,0(a5)
    80002c28:	c789                	beqz	a5,80002c32 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c2a:	9782                	jalr	a5
    80002c2c:	06a93823          	sd	a0,112(s2)
    80002c30:	a829                	j	80002c4a <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c32:	15848613          	addi	a2,s1,344
    80002c36:	588c                	lw	a1,48(s1)
    80002c38:	00005517          	auipc	a0,0x5
    80002c3c:	8d850513          	addi	a0,a0,-1832 # 80007510 <etext+0x510>
    80002c40:	883fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c44:	6cbc                	ld	a5,88(s1)
    80002c46:	577d                	li	a4,-1
    80002c48:	fbb8                	sd	a4,112(a5)
  }
}
    80002c4a:	60e2                	ld	ra,24(sp)
    80002c4c:	6442                	ld	s0,16(sp)
    80002c4e:	64a2                	ld	s1,8(sp)
    80002c50:	6902                	ld	s2,0(sp)
    80002c52:	6105                	addi	sp,sp,32
    80002c54:	8082                	ret

0000000080002c56 <sys_exit>:
#include "custom_logger.h"


uint64
sys_exit(void)
{
    80002c56:	1101                	addi	sp,sp,-32
    80002c58:	ec06                	sd	ra,24(sp)
    80002c5a:	e822                	sd	s0,16(sp)
    80002c5c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002c5e:	fec40593          	addi	a1,s0,-20
    80002c62:	4501                	li	a0,0
    80002c64:	f27ff0ef          	jal	80002b8a <argint>
  exit(n);
    80002c68:	fec42503          	lw	a0,-20(s0)
    80002c6c:	84aff0ef          	jal	80001cb6 <exit>
  return 0;  // not reached
}
    80002c70:	4501                	li	a0,0
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	6105                	addi	sp,sp,32
    80002c78:	8082                	ret

0000000080002c7a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c7a:	1141                	addi	sp,sp,-16
    80002c7c:	e406                	sd	ra,8(sp)
    80002c7e:	e022                	sd	s0,0(sp)
    80002c80:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c82:	c81fe0ef          	jal	80001902 <myproc>
}
    80002c86:	5908                	lw	a0,48(a0)
    80002c88:	60a2                	ld	ra,8(sp)
    80002c8a:	6402                	ld	s0,0(sp)
    80002c8c:	0141                	addi	sp,sp,16
    80002c8e:	8082                	ret

0000000080002c90 <sys_fork>:

uint64
sys_fork(void)
{
    80002c90:	1141                	addi	sp,sp,-16
    80002c92:	e406                	sd	ra,8(sp)
    80002c94:	e022                	sd	s0,0(sp)
    80002c96:	0800                	addi	s0,sp,16
  return fork();
    80002c98:	c62ff0ef          	jal	800020fa <fork>
}
    80002c9c:	60a2                	ld	ra,8(sp)
    80002c9e:	6402                	ld	s0,0(sp)
    80002ca0:	0141                	addi	sp,sp,16
    80002ca2:	8082                	ret

0000000080002ca4 <sys_wait>:

uint64
sys_wait(void)
{
    80002ca4:	1101                	addi	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002cac:	fe840593          	addi	a1,s0,-24
    80002cb0:	4501                	li	a0,0
    80002cb2:	ef5ff0ef          	jal	80002ba6 <argaddr>
  return wait(p);
    80002cb6:	fe843503          	ld	a0,-24(s0)
    80002cba:	d4eff0ef          	jal	80002208 <wait>
}
    80002cbe:	60e2                	ld	ra,24(sp)
    80002cc0:	6442                	ld	s0,16(sp)
    80002cc2:	6105                	addi	sp,sp,32
    80002cc4:	8082                	ret

0000000080002cc6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cc6:	7179                	addi	sp,sp,-48
    80002cc8:	f406                	sd	ra,40(sp)
    80002cca:	f022                	sd	s0,32(sp)
    80002ccc:	ec26                	sd	s1,24(sp)
    80002cce:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002cd0:	fdc40593          	addi	a1,s0,-36
    80002cd4:	4501                	li	a0,0
    80002cd6:	eb5ff0ef          	jal	80002b8a <argint>
  addr = myproc()->sz;
    80002cda:	c29fe0ef          	jal	80001902 <myproc>
    80002cde:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002ce0:	fdc42503          	lw	a0,-36(s0)
    80002ce4:	d91fe0ef          	jal	80001a74 <growproc>
    80002ce8:	00054863          	bltz	a0,80002cf8 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002cec:	8526                	mv	a0,s1
    80002cee:	70a2                	ld	ra,40(sp)
    80002cf0:	7402                	ld	s0,32(sp)
    80002cf2:	64e2                	ld	s1,24(sp)
    80002cf4:	6145                	addi	sp,sp,48
    80002cf6:	8082                	ret
    return -1;
    80002cf8:	54fd                	li	s1,-1
    80002cfa:	bfcd                	j	80002cec <sys_sbrk+0x26>

0000000080002cfc <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cfc:	7139                	addi	sp,sp,-64
    80002cfe:	fc06                	sd	ra,56(sp)
    80002d00:	f822                	sd	s0,48(sp)
    80002d02:	f04a                	sd	s2,32(sp)
    80002d04:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d06:	fcc40593          	addi	a1,s0,-52
    80002d0a:	4501                	li	a0,0
    80002d0c:	e7fff0ef          	jal	80002b8a <argint>
  if(n < 0)
    80002d10:	fcc42783          	lw	a5,-52(s0)
    80002d14:	0607c763          	bltz	a5,80002d82 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002d18:	00015517          	auipc	a0,0x15
    80002d1c:	ee850513          	addi	a0,a0,-280 # 80017c00 <tickslock>
    80002d20:	ed5fd0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002d24:	00005917          	auipc	s2,0x5
    80002d28:	d7c92903          	lw	s2,-644(s2) # 80007aa0 <ticks>
  while(ticks - ticks0 < n){
    80002d2c:	fcc42783          	lw	a5,-52(s0)
    80002d30:	cf8d                	beqz	a5,80002d6a <sys_sleep+0x6e>
    80002d32:	f426                	sd	s1,40(sp)
    80002d34:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d36:	00015997          	auipc	s3,0x15
    80002d3a:	eca98993          	addi	s3,s3,-310 # 80017c00 <tickslock>
    80002d3e:	00005497          	auipc	s1,0x5
    80002d42:	d6248493          	addi	s1,s1,-670 # 80007aa0 <ticks>
    if(killed(myproc())){
    80002d46:	bbdfe0ef          	jal	80001902 <myproc>
    80002d4a:	898ff0ef          	jal	80001de2 <killed>
    80002d4e:	ed0d                	bnez	a0,80002d88 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002d50:	85ce                	mv	a1,s3
    80002d52:	8526                	mv	a0,s1
    80002d54:	e57fe0ef          	jal	80001baa <sleep>
  while(ticks - ticks0 < n){
    80002d58:	409c                	lw	a5,0(s1)
    80002d5a:	412787bb          	subw	a5,a5,s2
    80002d5e:	fcc42703          	lw	a4,-52(s0)
    80002d62:	fee7e2e3          	bltu	a5,a4,80002d46 <sys_sleep+0x4a>
    80002d66:	74a2                	ld	s1,40(sp)
    80002d68:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002d6a:	00015517          	auipc	a0,0x15
    80002d6e:	e9650513          	addi	a0,a0,-362 # 80017c00 <tickslock>
    80002d72:	f1bfd0ef          	jal	80000c8c <release>
  return 0;
    80002d76:	4501                	li	a0,0
}
    80002d78:	70e2                	ld	ra,56(sp)
    80002d7a:	7442                	ld	s0,48(sp)
    80002d7c:	7902                	ld	s2,32(sp)
    80002d7e:	6121                	addi	sp,sp,64
    80002d80:	8082                	ret
    n = 0;
    80002d82:	fc042623          	sw	zero,-52(s0)
    80002d86:	bf49                	j	80002d18 <sys_sleep+0x1c>
      release(&tickslock);
    80002d88:	00015517          	auipc	a0,0x15
    80002d8c:	e7850513          	addi	a0,a0,-392 # 80017c00 <tickslock>
    80002d90:	efdfd0ef          	jal	80000c8c <release>
      return -1;
    80002d94:	557d                	li	a0,-1
    80002d96:	74a2                	ld	s1,40(sp)
    80002d98:	69e2                	ld	s3,24(sp)
    80002d9a:	bff9                	j	80002d78 <sys_sleep+0x7c>

0000000080002d9c <sys_kill>:

uint64
sys_kill(void)
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002da4:	fec40593          	addi	a1,s0,-20
    80002da8:	4501                	li	a0,0
    80002daa:	de1ff0ef          	jal	80002b8a <argint>
  return kill(pid);
    80002dae:	fec42503          	lw	a0,-20(s0)
    80002db2:	fa7fe0ef          	jal	80001d58 <kill>
}
    80002db6:	60e2                	ld	ra,24(sp)
    80002db8:	6442                	ld	s0,16(sp)
    80002dba:	6105                	addi	sp,sp,32
    80002dbc:	8082                	ret

0000000080002dbe <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002dbe:	1101                	addi	sp,sp,-32
    80002dc0:	ec06                	sd	ra,24(sp)
    80002dc2:	e822                	sd	s0,16(sp)
    80002dc4:	e426                	sd	s1,8(sp)
    80002dc6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dc8:	00015517          	auipc	a0,0x15
    80002dcc:	e3850513          	addi	a0,a0,-456 # 80017c00 <tickslock>
    80002dd0:	e25fd0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002dd4:	00005497          	auipc	s1,0x5
    80002dd8:	ccc4a483          	lw	s1,-820(s1) # 80007aa0 <ticks>
  release(&tickslock);
    80002ddc:	00015517          	auipc	a0,0x15
    80002de0:	e2450513          	addi	a0,a0,-476 # 80017c00 <tickslock>
    80002de4:	ea9fd0ef          	jal	80000c8c <release>
  return xticks;
}
    80002de8:	02049513          	slli	a0,s1,0x20
    80002dec:	9101                	srli	a0,a0,0x20
    80002dee:	60e2                	ld	ra,24(sp)
    80002df0:	6442                	ld	s0,16(sp)
    80002df2:	64a2                	ld	s1,8(sp)
    80002df4:	6105                	addi	sp,sp,32
    80002df6:	8082                	ret

0000000080002df8 <sys_trigger>:

uint64 
sys_trigger(void) 
{
    80002df8:	1141                	addi	sp,sp,-16
    80002dfa:	e406                	sd	ra,8(sp)
    80002dfc:	e022                	sd	s0,0(sp)
    80002dfe:	0800                	addi	s0,sp,16
  log_message(0, "INFO −  This is a log to test a new xv6 system call");
    80002e00:	00004597          	auipc	a1,0x4
    80002e04:	73058593          	addi	a1,a1,1840 # 80007530 <etext+0x530>
    80002e08:	4501                	li	a0,0
    80002e0a:	149020ef          	jal	80005752 <log_message>
  return 0;
}
    80002e0e:	4501                	li	a0,0
    80002e10:	60a2                	ld	ra,8(sp)
    80002e12:	6402                	ld	s0,0(sp)
    80002e14:	0141                	addi	sp,sp,16
    80002e16:	8082                	ret

0000000080002e18 <sys_thread>:

uint64
sys_thread(void) {
    80002e18:	7179                	addi	sp,sp,-48
    80002e1a:	f406                	sd	ra,40(sp)
    80002e1c:	f022                	sd	s0,32(sp)
    80002e1e:	1800                	addi	s0,sp,48
  uint64 start_thread, stack_address, arg;
  argaddr(0, &start_thread);
    80002e20:	fe840593          	addi	a1,s0,-24
    80002e24:	4501                	li	a0,0
    80002e26:	d81ff0ef          	jal	80002ba6 <argaddr>
  argaddr(1, &stack_address);
    80002e2a:	fe040593          	addi	a1,s0,-32
    80002e2e:	4505                	li	a0,1
    80002e30:	d77ff0ef          	jal	80002ba6 <argaddr>
  argaddr(2, &arg);
    80002e34:	fd840593          	addi	a1,s0,-40
    80002e38:	4509                	li	a0,2
    80002e3a:	d6dff0ef          	jal	80002ba6 <argaddr>
  struct thread *t = allocthread(start_thread, stack_address, arg);
    80002e3e:	fd843603          	ld	a2,-40(s0)
    80002e42:	fe043583          	ld	a1,-32(s0)
    80002e46:	fe843503          	ld	a0,-24(s0)
    80002e4a:	db4ff0ef          	jal	800023fe <allocthread>
    80002e4e:	87aa                	mv	a5,a0
  return t ? t->id : 0;
    80002e50:	4501                	li	a0,0
    80002e52:	c399                	beqz	a5,80002e58 <sys_thread+0x40>
    80002e54:	0107e503          	lwu	a0,16(a5)
}
    80002e58:	70a2                	ld	ra,40(sp)
    80002e5a:	7402                	ld	s0,32(sp)
    80002e5c:	6145                	addi	sp,sp,48
    80002e5e:	8082                	ret

0000000080002e60 <sys_jointhread>:

uint64
sys_jointhread(void) {
    80002e60:	1101                	addi	sp,sp,-32
    80002e62:	ec06                	sd	ra,24(sp)
    80002e64:	e822                	sd	s0,16(sp)
    80002e66:	1000                	addi	s0,sp,32
  int id;
  argint(0, &id);
    80002e68:	fec40593          	addi	a1,s0,-20
    80002e6c:	4501                	li	a0,0
    80002e6e:	d1dff0ef          	jal	80002b8a <argint>
  return jointhread(id);
    80002e72:	fec42503          	lw	a0,-20(s0)
    80002e76:	c8cff0ef          	jal	80002302 <jointhread>
}
    80002e7a:	60e2                	ld	ra,24(sp)
    80002e7c:	6442                	ld	s0,16(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret

0000000080002e82 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e82:	7179                	addi	sp,sp,-48
    80002e84:	f406                	sd	ra,40(sp)
    80002e86:	f022                	sd	s0,32(sp)
    80002e88:	ec26                	sd	s1,24(sp)
    80002e8a:	e84a                	sd	s2,16(sp)
    80002e8c:	e44e                	sd	s3,8(sp)
    80002e8e:	e052                	sd	s4,0(sp)
    80002e90:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e92:	00004597          	auipc	a1,0x4
    80002e96:	6d658593          	addi	a1,a1,1750 # 80007568 <etext+0x568>
    80002e9a:	00015517          	auipc	a0,0x15
    80002e9e:	d7e50513          	addi	a0,a0,-642 # 80017c18 <bcache>
    80002ea2:	cd3fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ea6:	0001d797          	auipc	a5,0x1d
    80002eaa:	d7278793          	addi	a5,a5,-654 # 8001fc18 <bcache+0x8000>
    80002eae:	0001d717          	auipc	a4,0x1d
    80002eb2:	fd270713          	addi	a4,a4,-46 # 8001fe80 <bcache+0x8268>
    80002eb6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002eba:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ebe:	00015497          	auipc	s1,0x15
    80002ec2:	d7248493          	addi	s1,s1,-654 # 80017c30 <bcache+0x18>
    b->next = bcache.head.next;
    80002ec6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ec8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002eca:	00004a17          	auipc	s4,0x4
    80002ece:	6a6a0a13          	addi	s4,s4,1702 # 80007570 <etext+0x570>
    b->next = bcache.head.next;
    80002ed2:	2b893783          	ld	a5,696(s2)
    80002ed6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002ed8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002edc:	85d2                	mv	a1,s4
    80002ede:	01048513          	addi	a0,s1,16
    80002ee2:	248010ef          	jal	8000412a <initsleeplock>
    bcache.head.next->prev = b;
    80002ee6:	2b893783          	ld	a5,696(s2)
    80002eea:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002eec:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ef0:	45848493          	addi	s1,s1,1112
    80002ef4:	fd349fe3          	bne	s1,s3,80002ed2 <binit+0x50>
  }
}
    80002ef8:	70a2                	ld	ra,40(sp)
    80002efa:	7402                	ld	s0,32(sp)
    80002efc:	64e2                	ld	s1,24(sp)
    80002efe:	6942                	ld	s2,16(sp)
    80002f00:	69a2                	ld	s3,8(sp)
    80002f02:	6a02                	ld	s4,0(sp)
    80002f04:	6145                	addi	sp,sp,48
    80002f06:	8082                	ret

0000000080002f08 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f08:	7179                	addi	sp,sp,-48
    80002f0a:	f406                	sd	ra,40(sp)
    80002f0c:	f022                	sd	s0,32(sp)
    80002f0e:	ec26                	sd	s1,24(sp)
    80002f10:	e84a                	sd	s2,16(sp)
    80002f12:	e44e                	sd	s3,8(sp)
    80002f14:	1800                	addi	s0,sp,48
    80002f16:	892a                	mv	s2,a0
    80002f18:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f1a:	00015517          	auipc	a0,0x15
    80002f1e:	cfe50513          	addi	a0,a0,-770 # 80017c18 <bcache>
    80002f22:	cd3fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f26:	0001d497          	auipc	s1,0x1d
    80002f2a:	faa4b483          	ld	s1,-86(s1) # 8001fed0 <bcache+0x82b8>
    80002f2e:	0001d797          	auipc	a5,0x1d
    80002f32:	f5278793          	addi	a5,a5,-174 # 8001fe80 <bcache+0x8268>
    80002f36:	02f48b63          	beq	s1,a5,80002f6c <bread+0x64>
    80002f3a:	873e                	mv	a4,a5
    80002f3c:	a021                	j	80002f44 <bread+0x3c>
    80002f3e:	68a4                	ld	s1,80(s1)
    80002f40:	02e48663          	beq	s1,a4,80002f6c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002f44:	449c                	lw	a5,8(s1)
    80002f46:	ff279ce3          	bne	a5,s2,80002f3e <bread+0x36>
    80002f4a:	44dc                	lw	a5,12(s1)
    80002f4c:	ff3799e3          	bne	a5,s3,80002f3e <bread+0x36>
      b->refcnt++;
    80002f50:	40bc                	lw	a5,64(s1)
    80002f52:	2785                	addiw	a5,a5,1
    80002f54:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f56:	00015517          	auipc	a0,0x15
    80002f5a:	cc250513          	addi	a0,a0,-830 # 80017c18 <bcache>
    80002f5e:	d2ffd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002f62:	01048513          	addi	a0,s1,16
    80002f66:	1fa010ef          	jal	80004160 <acquiresleep>
      return b;
    80002f6a:	a889                	j	80002fbc <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f6c:	0001d497          	auipc	s1,0x1d
    80002f70:	f5c4b483          	ld	s1,-164(s1) # 8001fec8 <bcache+0x82b0>
    80002f74:	0001d797          	auipc	a5,0x1d
    80002f78:	f0c78793          	addi	a5,a5,-244 # 8001fe80 <bcache+0x8268>
    80002f7c:	00f48863          	beq	s1,a5,80002f8c <bread+0x84>
    80002f80:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f82:	40bc                	lw	a5,64(s1)
    80002f84:	cb91                	beqz	a5,80002f98 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f86:	64a4                	ld	s1,72(s1)
    80002f88:	fee49de3          	bne	s1,a4,80002f82 <bread+0x7a>
  panic("bget: no buffers");
    80002f8c:	00004517          	auipc	a0,0x4
    80002f90:	5ec50513          	addi	a0,a0,1516 # 80007578 <etext+0x578>
    80002f94:	801fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002f98:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f9c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fa0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fa4:	4785                	li	a5,1
    80002fa6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fa8:	00015517          	auipc	a0,0x15
    80002fac:	c7050513          	addi	a0,a0,-912 # 80017c18 <bcache>
    80002fb0:	cddfd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002fb4:	01048513          	addi	a0,s1,16
    80002fb8:	1a8010ef          	jal	80004160 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002fbc:	409c                	lw	a5,0(s1)
    80002fbe:	cb89                	beqz	a5,80002fd0 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fc0:	8526                	mv	a0,s1
    80002fc2:	70a2                	ld	ra,40(sp)
    80002fc4:	7402                	ld	s0,32(sp)
    80002fc6:	64e2                	ld	s1,24(sp)
    80002fc8:	6942                	ld	s2,16(sp)
    80002fca:	69a2                	ld	s3,8(sp)
    80002fcc:	6145                	addi	sp,sp,48
    80002fce:	8082                	ret
    virtio_disk_rw(b, 0);
    80002fd0:	4581                	li	a1,0
    80002fd2:	8526                	mv	a0,s1
    80002fd4:	29f020ef          	jal	80005a72 <virtio_disk_rw>
    b->valid = 1;
    80002fd8:	4785                	li	a5,1
    80002fda:	c09c                	sw	a5,0(s1)
  return b;
    80002fdc:	b7d5                	j	80002fc0 <bread+0xb8>

0000000080002fde <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fde:	1101                	addi	sp,sp,-32
    80002fe0:	ec06                	sd	ra,24(sp)
    80002fe2:	e822                	sd	s0,16(sp)
    80002fe4:	e426                	sd	s1,8(sp)
    80002fe6:	1000                	addi	s0,sp,32
    80002fe8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fea:	0541                	addi	a0,a0,16
    80002fec:	1f2010ef          	jal	800041de <holdingsleep>
    80002ff0:	c911                	beqz	a0,80003004 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ff2:	4585                	li	a1,1
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	27d020ef          	jal	80005a72 <virtio_disk_rw>
}
    80002ffa:	60e2                	ld	ra,24(sp)
    80002ffc:	6442                	ld	s0,16(sp)
    80002ffe:	64a2                	ld	s1,8(sp)
    80003000:	6105                	addi	sp,sp,32
    80003002:	8082                	ret
    panic("bwrite");
    80003004:	00004517          	auipc	a0,0x4
    80003008:	58c50513          	addi	a0,a0,1420 # 80007590 <etext+0x590>
    8000300c:	f88fd0ef          	jal	80000794 <panic>

0000000080003010 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003010:	1101                	addi	sp,sp,-32
    80003012:	ec06                	sd	ra,24(sp)
    80003014:	e822                	sd	s0,16(sp)
    80003016:	e426                	sd	s1,8(sp)
    80003018:	e04a                	sd	s2,0(sp)
    8000301a:	1000                	addi	s0,sp,32
    8000301c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000301e:	01050913          	addi	s2,a0,16
    80003022:	854a                	mv	a0,s2
    80003024:	1ba010ef          	jal	800041de <holdingsleep>
    80003028:	c135                	beqz	a0,8000308c <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000302a:	854a                	mv	a0,s2
    8000302c:	17a010ef          	jal	800041a6 <releasesleep>

  acquire(&bcache.lock);
    80003030:	00015517          	auipc	a0,0x15
    80003034:	be850513          	addi	a0,a0,-1048 # 80017c18 <bcache>
    80003038:	bbdfd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    8000303c:	40bc                	lw	a5,64(s1)
    8000303e:	37fd                	addiw	a5,a5,-1
    80003040:	0007871b          	sext.w	a4,a5
    80003044:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003046:	e71d                	bnez	a4,80003074 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003048:	68b8                	ld	a4,80(s1)
    8000304a:	64bc                	ld	a5,72(s1)
    8000304c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000304e:	68b8                	ld	a4,80(s1)
    80003050:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003052:	0001d797          	auipc	a5,0x1d
    80003056:	bc678793          	addi	a5,a5,-1082 # 8001fc18 <bcache+0x8000>
    8000305a:	2b87b703          	ld	a4,696(a5)
    8000305e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003060:	0001d717          	auipc	a4,0x1d
    80003064:	e2070713          	addi	a4,a4,-480 # 8001fe80 <bcache+0x8268>
    80003068:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000306a:	2b87b703          	ld	a4,696(a5)
    8000306e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003070:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003074:	00015517          	auipc	a0,0x15
    80003078:	ba450513          	addi	a0,a0,-1116 # 80017c18 <bcache>
    8000307c:	c11fd0ef          	jal	80000c8c <release>
}
    80003080:	60e2                	ld	ra,24(sp)
    80003082:	6442                	ld	s0,16(sp)
    80003084:	64a2                	ld	s1,8(sp)
    80003086:	6902                	ld	s2,0(sp)
    80003088:	6105                	addi	sp,sp,32
    8000308a:	8082                	ret
    panic("brelse");
    8000308c:	00004517          	auipc	a0,0x4
    80003090:	50c50513          	addi	a0,a0,1292 # 80007598 <etext+0x598>
    80003094:	f00fd0ef          	jal	80000794 <panic>

0000000080003098 <bpin>:

void
bpin(struct buf *b) {
    80003098:	1101                	addi	sp,sp,-32
    8000309a:	ec06                	sd	ra,24(sp)
    8000309c:	e822                	sd	s0,16(sp)
    8000309e:	e426                	sd	s1,8(sp)
    800030a0:	1000                	addi	s0,sp,32
    800030a2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030a4:	00015517          	auipc	a0,0x15
    800030a8:	b7450513          	addi	a0,a0,-1164 # 80017c18 <bcache>
    800030ac:	b49fd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    800030b0:	40bc                	lw	a5,64(s1)
    800030b2:	2785                	addiw	a5,a5,1
    800030b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030b6:	00015517          	auipc	a0,0x15
    800030ba:	b6250513          	addi	a0,a0,-1182 # 80017c18 <bcache>
    800030be:	bcffd0ef          	jal	80000c8c <release>
}
    800030c2:	60e2                	ld	ra,24(sp)
    800030c4:	6442                	ld	s0,16(sp)
    800030c6:	64a2                	ld	s1,8(sp)
    800030c8:	6105                	addi	sp,sp,32
    800030ca:	8082                	ret

00000000800030cc <bunpin>:

void
bunpin(struct buf *b) {
    800030cc:	1101                	addi	sp,sp,-32
    800030ce:	ec06                	sd	ra,24(sp)
    800030d0:	e822                	sd	s0,16(sp)
    800030d2:	e426                	sd	s1,8(sp)
    800030d4:	1000                	addi	s0,sp,32
    800030d6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030d8:	00015517          	auipc	a0,0x15
    800030dc:	b4050513          	addi	a0,a0,-1216 # 80017c18 <bcache>
    800030e0:	b15fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    800030e4:	40bc                	lw	a5,64(s1)
    800030e6:	37fd                	addiw	a5,a5,-1
    800030e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030ea:	00015517          	auipc	a0,0x15
    800030ee:	b2e50513          	addi	a0,a0,-1234 # 80017c18 <bcache>
    800030f2:	b9bfd0ef          	jal	80000c8c <release>
}
    800030f6:	60e2                	ld	ra,24(sp)
    800030f8:	6442                	ld	s0,16(sp)
    800030fa:	64a2                	ld	s1,8(sp)
    800030fc:	6105                	addi	sp,sp,32
    800030fe:	8082                	ret

0000000080003100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003100:	1101                	addi	sp,sp,-32
    80003102:	ec06                	sd	ra,24(sp)
    80003104:	e822                	sd	s0,16(sp)
    80003106:	e426                	sd	s1,8(sp)
    80003108:	e04a                	sd	s2,0(sp)
    8000310a:	1000                	addi	s0,sp,32
    8000310c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000310e:	00d5d59b          	srliw	a1,a1,0xd
    80003112:	0001d797          	auipc	a5,0x1d
    80003116:	1e27a783          	lw	a5,482(a5) # 800202f4 <sb+0x1c>
    8000311a:	9dbd                	addw	a1,a1,a5
    8000311c:	dedff0ef          	jal	80002f08 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003120:	0074f713          	andi	a4,s1,7
    80003124:	4785                	li	a5,1
    80003126:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000312a:	14ce                	slli	s1,s1,0x33
    8000312c:	90d9                	srli	s1,s1,0x36
    8000312e:	00950733          	add	a4,a0,s1
    80003132:	05874703          	lbu	a4,88(a4)
    80003136:	00e7f6b3          	and	a3,a5,a4
    8000313a:	c29d                	beqz	a3,80003160 <bfree+0x60>
    8000313c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000313e:	94aa                	add	s1,s1,a0
    80003140:	fff7c793          	not	a5,a5
    80003144:	8f7d                	and	a4,a4,a5
    80003146:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000314a:	711000ef          	jal	8000405a <log_write>
  brelse(bp);
    8000314e:	854a                	mv	a0,s2
    80003150:	ec1ff0ef          	jal	80003010 <brelse>
}
    80003154:	60e2                	ld	ra,24(sp)
    80003156:	6442                	ld	s0,16(sp)
    80003158:	64a2                	ld	s1,8(sp)
    8000315a:	6902                	ld	s2,0(sp)
    8000315c:	6105                	addi	sp,sp,32
    8000315e:	8082                	ret
    panic("freeing free block");
    80003160:	00004517          	auipc	a0,0x4
    80003164:	44050513          	addi	a0,a0,1088 # 800075a0 <etext+0x5a0>
    80003168:	e2cfd0ef          	jal	80000794 <panic>

000000008000316c <balloc>:
{
    8000316c:	711d                	addi	sp,sp,-96
    8000316e:	ec86                	sd	ra,88(sp)
    80003170:	e8a2                	sd	s0,80(sp)
    80003172:	e4a6                	sd	s1,72(sp)
    80003174:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003176:	0001d797          	auipc	a5,0x1d
    8000317a:	1667a783          	lw	a5,358(a5) # 800202dc <sb+0x4>
    8000317e:	0e078f63          	beqz	a5,8000327c <balloc+0x110>
    80003182:	e0ca                	sd	s2,64(sp)
    80003184:	fc4e                	sd	s3,56(sp)
    80003186:	f852                	sd	s4,48(sp)
    80003188:	f456                	sd	s5,40(sp)
    8000318a:	f05a                	sd	s6,32(sp)
    8000318c:	ec5e                	sd	s7,24(sp)
    8000318e:	e862                	sd	s8,16(sp)
    80003190:	e466                	sd	s9,8(sp)
    80003192:	8baa                	mv	s7,a0
    80003194:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003196:	0001db17          	auipc	s6,0x1d
    8000319a:	142b0b13          	addi	s6,s6,322 # 800202d8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000319e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800031a0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031a2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031a4:	6c89                	lui	s9,0x2
    800031a6:	a0b5                	j	80003212 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800031a8:	97ca                	add	a5,a5,s2
    800031aa:	8e55                	or	a2,a2,a3
    800031ac:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800031b0:	854a                	mv	a0,s2
    800031b2:	6a9000ef          	jal	8000405a <log_write>
        brelse(bp);
    800031b6:	854a                	mv	a0,s2
    800031b8:	e59ff0ef          	jal	80003010 <brelse>
  bp = bread(dev, bno);
    800031bc:	85a6                	mv	a1,s1
    800031be:	855e                	mv	a0,s7
    800031c0:	d49ff0ef          	jal	80002f08 <bread>
    800031c4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031c6:	40000613          	li	a2,1024
    800031ca:	4581                	li	a1,0
    800031cc:	05850513          	addi	a0,a0,88
    800031d0:	af9fd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    800031d4:	854a                	mv	a0,s2
    800031d6:	685000ef          	jal	8000405a <log_write>
  brelse(bp);
    800031da:	854a                	mv	a0,s2
    800031dc:	e35ff0ef          	jal	80003010 <brelse>
}
    800031e0:	6906                	ld	s2,64(sp)
    800031e2:	79e2                	ld	s3,56(sp)
    800031e4:	7a42                	ld	s4,48(sp)
    800031e6:	7aa2                	ld	s5,40(sp)
    800031e8:	7b02                	ld	s6,32(sp)
    800031ea:	6be2                	ld	s7,24(sp)
    800031ec:	6c42                	ld	s8,16(sp)
    800031ee:	6ca2                	ld	s9,8(sp)
}
    800031f0:	8526                	mv	a0,s1
    800031f2:	60e6                	ld	ra,88(sp)
    800031f4:	6446                	ld	s0,80(sp)
    800031f6:	64a6                	ld	s1,72(sp)
    800031f8:	6125                	addi	sp,sp,96
    800031fa:	8082                	ret
    brelse(bp);
    800031fc:	854a                	mv	a0,s2
    800031fe:	e13ff0ef          	jal	80003010 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003202:	015c87bb          	addw	a5,s9,s5
    80003206:	00078a9b          	sext.w	s5,a5
    8000320a:	004b2703          	lw	a4,4(s6)
    8000320e:	04eaff63          	bgeu	s5,a4,8000326c <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003212:	41fad79b          	sraiw	a5,s5,0x1f
    80003216:	0137d79b          	srliw	a5,a5,0x13
    8000321a:	015787bb          	addw	a5,a5,s5
    8000321e:	40d7d79b          	sraiw	a5,a5,0xd
    80003222:	01cb2583          	lw	a1,28(s6)
    80003226:	9dbd                	addw	a1,a1,a5
    80003228:	855e                	mv	a0,s7
    8000322a:	cdfff0ef          	jal	80002f08 <bread>
    8000322e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003230:	004b2503          	lw	a0,4(s6)
    80003234:	000a849b          	sext.w	s1,s5
    80003238:	8762                	mv	a4,s8
    8000323a:	fca4f1e3          	bgeu	s1,a0,800031fc <balloc+0x90>
      m = 1 << (bi % 8);
    8000323e:	00777693          	andi	a3,a4,7
    80003242:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003246:	41f7579b          	sraiw	a5,a4,0x1f
    8000324a:	01d7d79b          	srliw	a5,a5,0x1d
    8000324e:	9fb9                	addw	a5,a5,a4
    80003250:	4037d79b          	sraiw	a5,a5,0x3
    80003254:	00f90633          	add	a2,s2,a5
    80003258:	05864603          	lbu	a2,88(a2)
    8000325c:	00c6f5b3          	and	a1,a3,a2
    80003260:	d5a1                	beqz	a1,800031a8 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003262:	2705                	addiw	a4,a4,1
    80003264:	2485                	addiw	s1,s1,1
    80003266:	fd471ae3          	bne	a4,s4,8000323a <balloc+0xce>
    8000326a:	bf49                	j	800031fc <balloc+0x90>
    8000326c:	6906                	ld	s2,64(sp)
    8000326e:	79e2                	ld	s3,56(sp)
    80003270:	7a42                	ld	s4,48(sp)
    80003272:	7aa2                	ld	s5,40(sp)
    80003274:	7b02                	ld	s6,32(sp)
    80003276:	6be2                	ld	s7,24(sp)
    80003278:	6c42                	ld	s8,16(sp)
    8000327a:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000327c:	00004517          	auipc	a0,0x4
    80003280:	33c50513          	addi	a0,a0,828 # 800075b8 <etext+0x5b8>
    80003284:	a3efd0ef          	jal	800004c2 <printf>
  return 0;
    80003288:	4481                	li	s1,0
    8000328a:	b79d                	j	800031f0 <balloc+0x84>

000000008000328c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000328c:	7179                	addi	sp,sp,-48
    8000328e:	f406                	sd	ra,40(sp)
    80003290:	f022                	sd	s0,32(sp)
    80003292:	ec26                	sd	s1,24(sp)
    80003294:	e84a                	sd	s2,16(sp)
    80003296:	e44e                	sd	s3,8(sp)
    80003298:	1800                	addi	s0,sp,48
    8000329a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000329c:	47ad                	li	a5,11
    8000329e:	02b7e663          	bltu	a5,a1,800032ca <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800032a2:	02059793          	slli	a5,a1,0x20
    800032a6:	01e7d593          	srli	a1,a5,0x1e
    800032aa:	00b504b3          	add	s1,a0,a1
    800032ae:	0504a903          	lw	s2,80(s1)
    800032b2:	06091a63          	bnez	s2,80003326 <bmap+0x9a>
      addr = balloc(ip->dev);
    800032b6:	4108                	lw	a0,0(a0)
    800032b8:	eb5ff0ef          	jal	8000316c <balloc>
    800032bc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800032c0:	06090363          	beqz	s2,80003326 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800032c4:	0524a823          	sw	s2,80(s1)
    800032c8:	a8b9                	j	80003326 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800032ca:	ff45849b          	addiw	s1,a1,-12
    800032ce:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800032d2:	0ff00793          	li	a5,255
    800032d6:	06e7ee63          	bltu	a5,a4,80003352 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800032da:	08052903          	lw	s2,128(a0)
    800032de:	00091d63          	bnez	s2,800032f8 <bmap+0x6c>
      addr = balloc(ip->dev);
    800032e2:	4108                	lw	a0,0(a0)
    800032e4:	e89ff0ef          	jal	8000316c <balloc>
    800032e8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800032ec:	02090d63          	beqz	s2,80003326 <bmap+0x9a>
    800032f0:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800032f2:	0929a023          	sw	s2,128(s3)
    800032f6:	a011                	j	800032fa <bmap+0x6e>
    800032f8:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800032fa:	85ca                	mv	a1,s2
    800032fc:	0009a503          	lw	a0,0(s3)
    80003300:	c09ff0ef          	jal	80002f08 <bread>
    80003304:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003306:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000330a:	02049713          	slli	a4,s1,0x20
    8000330e:	01e75593          	srli	a1,a4,0x1e
    80003312:	00b784b3          	add	s1,a5,a1
    80003316:	0004a903          	lw	s2,0(s1)
    8000331a:	00090e63          	beqz	s2,80003336 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000331e:	8552                	mv	a0,s4
    80003320:	cf1ff0ef          	jal	80003010 <brelse>
    return addr;
    80003324:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003326:	854a                	mv	a0,s2
    80003328:	70a2                	ld	ra,40(sp)
    8000332a:	7402                	ld	s0,32(sp)
    8000332c:	64e2                	ld	s1,24(sp)
    8000332e:	6942                	ld	s2,16(sp)
    80003330:	69a2                	ld	s3,8(sp)
    80003332:	6145                	addi	sp,sp,48
    80003334:	8082                	ret
      addr = balloc(ip->dev);
    80003336:	0009a503          	lw	a0,0(s3)
    8000333a:	e33ff0ef          	jal	8000316c <balloc>
    8000333e:	0005091b          	sext.w	s2,a0
      if(addr){
    80003342:	fc090ee3          	beqz	s2,8000331e <bmap+0x92>
        a[bn] = addr;
    80003346:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000334a:	8552                	mv	a0,s4
    8000334c:	50f000ef          	jal	8000405a <log_write>
    80003350:	b7f9                	j	8000331e <bmap+0x92>
    80003352:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003354:	00004517          	auipc	a0,0x4
    80003358:	27c50513          	addi	a0,a0,636 # 800075d0 <etext+0x5d0>
    8000335c:	c38fd0ef          	jal	80000794 <panic>

0000000080003360 <iget>:
{
    80003360:	7179                	addi	sp,sp,-48
    80003362:	f406                	sd	ra,40(sp)
    80003364:	f022                	sd	s0,32(sp)
    80003366:	ec26                	sd	s1,24(sp)
    80003368:	e84a                	sd	s2,16(sp)
    8000336a:	e44e                	sd	s3,8(sp)
    8000336c:	e052                	sd	s4,0(sp)
    8000336e:	1800                	addi	s0,sp,48
    80003370:	89aa                	mv	s3,a0
    80003372:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003374:	0001d517          	auipc	a0,0x1d
    80003378:	f8450513          	addi	a0,a0,-124 # 800202f8 <itable>
    8000337c:	879fd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80003380:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003382:	0001d497          	auipc	s1,0x1d
    80003386:	f8e48493          	addi	s1,s1,-114 # 80020310 <itable+0x18>
    8000338a:	0001f697          	auipc	a3,0x1f
    8000338e:	a1668693          	addi	a3,a3,-1514 # 80021da0 <log>
    80003392:	a039                	j	800033a0 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003394:	02090963          	beqz	s2,800033c6 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003398:	08848493          	addi	s1,s1,136
    8000339c:	02d48863          	beq	s1,a3,800033cc <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800033a0:	449c                	lw	a5,8(s1)
    800033a2:	fef059e3          	blez	a5,80003394 <iget+0x34>
    800033a6:	4098                	lw	a4,0(s1)
    800033a8:	ff3716e3          	bne	a4,s3,80003394 <iget+0x34>
    800033ac:	40d8                	lw	a4,4(s1)
    800033ae:	ff4713e3          	bne	a4,s4,80003394 <iget+0x34>
      ip->ref++;
    800033b2:	2785                	addiw	a5,a5,1
    800033b4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800033b6:	0001d517          	auipc	a0,0x1d
    800033ba:	f4250513          	addi	a0,a0,-190 # 800202f8 <itable>
    800033be:	8cffd0ef          	jal	80000c8c <release>
      return ip;
    800033c2:	8926                	mv	s2,s1
    800033c4:	a02d                	j	800033ee <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033c6:	fbe9                	bnez	a5,80003398 <iget+0x38>
      empty = ip;
    800033c8:	8926                	mv	s2,s1
    800033ca:	b7f9                	j	80003398 <iget+0x38>
  if(empty == 0)
    800033cc:	02090a63          	beqz	s2,80003400 <iget+0xa0>
  ip->dev = dev;
    800033d0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800033d4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800033d8:	4785                	li	a5,1
    800033da:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800033de:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800033e2:	0001d517          	auipc	a0,0x1d
    800033e6:	f1650513          	addi	a0,a0,-234 # 800202f8 <itable>
    800033ea:	8a3fd0ef          	jal	80000c8c <release>
}
    800033ee:	854a                	mv	a0,s2
    800033f0:	70a2                	ld	ra,40(sp)
    800033f2:	7402                	ld	s0,32(sp)
    800033f4:	64e2                	ld	s1,24(sp)
    800033f6:	6942                	ld	s2,16(sp)
    800033f8:	69a2                	ld	s3,8(sp)
    800033fa:	6a02                	ld	s4,0(sp)
    800033fc:	6145                	addi	sp,sp,48
    800033fe:	8082                	ret
    panic("iget: no inodes");
    80003400:	00004517          	auipc	a0,0x4
    80003404:	1e850513          	addi	a0,a0,488 # 800075e8 <etext+0x5e8>
    80003408:	b8cfd0ef          	jal	80000794 <panic>

000000008000340c <fsinit>:
fsinit(int dev) {
    8000340c:	7179                	addi	sp,sp,-48
    8000340e:	f406                	sd	ra,40(sp)
    80003410:	f022                	sd	s0,32(sp)
    80003412:	ec26                	sd	s1,24(sp)
    80003414:	e84a                	sd	s2,16(sp)
    80003416:	e44e                	sd	s3,8(sp)
    80003418:	1800                	addi	s0,sp,48
    8000341a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000341c:	4585                	li	a1,1
    8000341e:	aebff0ef          	jal	80002f08 <bread>
    80003422:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003424:	0001d997          	auipc	s3,0x1d
    80003428:	eb498993          	addi	s3,s3,-332 # 800202d8 <sb>
    8000342c:	02000613          	li	a2,32
    80003430:	05850593          	addi	a1,a0,88
    80003434:	854e                	mv	a0,s3
    80003436:	8effd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    8000343a:	8526                	mv	a0,s1
    8000343c:	bd5ff0ef          	jal	80003010 <brelse>
  if(sb.magic != FSMAGIC)
    80003440:	0009a703          	lw	a4,0(s3)
    80003444:	102037b7          	lui	a5,0x10203
    80003448:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000344c:	02f71063          	bne	a4,a5,8000346c <fsinit+0x60>
  initlog(dev, &sb);
    80003450:	0001d597          	auipc	a1,0x1d
    80003454:	e8858593          	addi	a1,a1,-376 # 800202d8 <sb>
    80003458:	854a                	mv	a0,s2
    8000345a:	1f9000ef          	jal	80003e52 <initlog>
}
    8000345e:	70a2                	ld	ra,40(sp)
    80003460:	7402                	ld	s0,32(sp)
    80003462:	64e2                	ld	s1,24(sp)
    80003464:	6942                	ld	s2,16(sp)
    80003466:	69a2                	ld	s3,8(sp)
    80003468:	6145                	addi	sp,sp,48
    8000346a:	8082                	ret
    panic("invalid file system");
    8000346c:	00004517          	auipc	a0,0x4
    80003470:	18c50513          	addi	a0,a0,396 # 800075f8 <etext+0x5f8>
    80003474:	b20fd0ef          	jal	80000794 <panic>

0000000080003478 <iinit>:
{
    80003478:	7179                	addi	sp,sp,-48
    8000347a:	f406                	sd	ra,40(sp)
    8000347c:	f022                	sd	s0,32(sp)
    8000347e:	ec26                	sd	s1,24(sp)
    80003480:	e84a                	sd	s2,16(sp)
    80003482:	e44e                	sd	s3,8(sp)
    80003484:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003486:	00004597          	auipc	a1,0x4
    8000348a:	18a58593          	addi	a1,a1,394 # 80007610 <etext+0x610>
    8000348e:	0001d517          	auipc	a0,0x1d
    80003492:	e6a50513          	addi	a0,a0,-406 # 800202f8 <itable>
    80003496:	edefd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000349a:	0001d497          	auipc	s1,0x1d
    8000349e:	e8648493          	addi	s1,s1,-378 # 80020320 <itable+0x28>
    800034a2:	0001f997          	auipc	s3,0x1f
    800034a6:	90e98993          	addi	s3,s3,-1778 # 80021db0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800034aa:	00004917          	auipc	s2,0x4
    800034ae:	16e90913          	addi	s2,s2,366 # 80007618 <etext+0x618>
    800034b2:	85ca                	mv	a1,s2
    800034b4:	8526                	mv	a0,s1
    800034b6:	475000ef          	jal	8000412a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800034ba:	08848493          	addi	s1,s1,136
    800034be:	ff349ae3          	bne	s1,s3,800034b2 <iinit+0x3a>
}
    800034c2:	70a2                	ld	ra,40(sp)
    800034c4:	7402                	ld	s0,32(sp)
    800034c6:	64e2                	ld	s1,24(sp)
    800034c8:	6942                	ld	s2,16(sp)
    800034ca:	69a2                	ld	s3,8(sp)
    800034cc:	6145                	addi	sp,sp,48
    800034ce:	8082                	ret

00000000800034d0 <ialloc>:
{
    800034d0:	7139                	addi	sp,sp,-64
    800034d2:	fc06                	sd	ra,56(sp)
    800034d4:	f822                	sd	s0,48(sp)
    800034d6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800034d8:	0001d717          	auipc	a4,0x1d
    800034dc:	e0c72703          	lw	a4,-500(a4) # 800202e4 <sb+0xc>
    800034e0:	4785                	li	a5,1
    800034e2:	06e7f063          	bgeu	a5,a4,80003542 <ialloc+0x72>
    800034e6:	f426                	sd	s1,40(sp)
    800034e8:	f04a                	sd	s2,32(sp)
    800034ea:	ec4e                	sd	s3,24(sp)
    800034ec:	e852                	sd	s4,16(sp)
    800034ee:	e456                	sd	s5,8(sp)
    800034f0:	e05a                	sd	s6,0(sp)
    800034f2:	8aaa                	mv	s5,a0
    800034f4:	8b2e                	mv	s6,a1
    800034f6:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800034f8:	0001da17          	auipc	s4,0x1d
    800034fc:	de0a0a13          	addi	s4,s4,-544 # 800202d8 <sb>
    80003500:	00495593          	srli	a1,s2,0x4
    80003504:	018a2783          	lw	a5,24(s4)
    80003508:	9dbd                	addw	a1,a1,a5
    8000350a:	8556                	mv	a0,s5
    8000350c:	9fdff0ef          	jal	80002f08 <bread>
    80003510:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003512:	05850993          	addi	s3,a0,88
    80003516:	00f97793          	andi	a5,s2,15
    8000351a:	079a                	slli	a5,a5,0x6
    8000351c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000351e:	00099783          	lh	a5,0(s3)
    80003522:	cb9d                	beqz	a5,80003558 <ialloc+0x88>
    brelse(bp);
    80003524:	aedff0ef          	jal	80003010 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003528:	0905                	addi	s2,s2,1
    8000352a:	00ca2703          	lw	a4,12(s4)
    8000352e:	0009079b          	sext.w	a5,s2
    80003532:	fce7e7e3          	bltu	a5,a4,80003500 <ialloc+0x30>
    80003536:	74a2                	ld	s1,40(sp)
    80003538:	7902                	ld	s2,32(sp)
    8000353a:	69e2                	ld	s3,24(sp)
    8000353c:	6a42                	ld	s4,16(sp)
    8000353e:	6aa2                	ld	s5,8(sp)
    80003540:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003542:	00004517          	auipc	a0,0x4
    80003546:	0de50513          	addi	a0,a0,222 # 80007620 <etext+0x620>
    8000354a:	f79fc0ef          	jal	800004c2 <printf>
  return 0;
    8000354e:	4501                	li	a0,0
}
    80003550:	70e2                	ld	ra,56(sp)
    80003552:	7442                	ld	s0,48(sp)
    80003554:	6121                	addi	sp,sp,64
    80003556:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003558:	04000613          	li	a2,64
    8000355c:	4581                	li	a1,0
    8000355e:	854e                	mv	a0,s3
    80003560:	f68fd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    80003564:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003568:	8526                	mv	a0,s1
    8000356a:	2f1000ef          	jal	8000405a <log_write>
      brelse(bp);
    8000356e:	8526                	mv	a0,s1
    80003570:	aa1ff0ef          	jal	80003010 <brelse>
      return iget(dev, inum);
    80003574:	0009059b          	sext.w	a1,s2
    80003578:	8556                	mv	a0,s5
    8000357a:	de7ff0ef          	jal	80003360 <iget>
    8000357e:	74a2                	ld	s1,40(sp)
    80003580:	7902                	ld	s2,32(sp)
    80003582:	69e2                	ld	s3,24(sp)
    80003584:	6a42                	ld	s4,16(sp)
    80003586:	6aa2                	ld	s5,8(sp)
    80003588:	6b02                	ld	s6,0(sp)
    8000358a:	b7d9                	j	80003550 <ialloc+0x80>

000000008000358c <iupdate>:
{
    8000358c:	1101                	addi	sp,sp,-32
    8000358e:	ec06                	sd	ra,24(sp)
    80003590:	e822                	sd	s0,16(sp)
    80003592:	e426                	sd	s1,8(sp)
    80003594:	e04a                	sd	s2,0(sp)
    80003596:	1000                	addi	s0,sp,32
    80003598:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000359a:	415c                	lw	a5,4(a0)
    8000359c:	0047d79b          	srliw	a5,a5,0x4
    800035a0:	0001d597          	auipc	a1,0x1d
    800035a4:	d505a583          	lw	a1,-688(a1) # 800202f0 <sb+0x18>
    800035a8:	9dbd                	addw	a1,a1,a5
    800035aa:	4108                	lw	a0,0(a0)
    800035ac:	95dff0ef          	jal	80002f08 <bread>
    800035b0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800035b2:	05850793          	addi	a5,a0,88
    800035b6:	40d8                	lw	a4,4(s1)
    800035b8:	8b3d                	andi	a4,a4,15
    800035ba:	071a                	slli	a4,a4,0x6
    800035bc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800035be:	04449703          	lh	a4,68(s1)
    800035c2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800035c6:	04649703          	lh	a4,70(s1)
    800035ca:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800035ce:	04849703          	lh	a4,72(s1)
    800035d2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800035d6:	04a49703          	lh	a4,74(s1)
    800035da:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800035de:	44f8                	lw	a4,76(s1)
    800035e0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800035e2:	03400613          	li	a2,52
    800035e6:	05048593          	addi	a1,s1,80
    800035ea:	00c78513          	addi	a0,a5,12
    800035ee:	f36fd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    800035f2:	854a                	mv	a0,s2
    800035f4:	267000ef          	jal	8000405a <log_write>
  brelse(bp);
    800035f8:	854a                	mv	a0,s2
    800035fa:	a17ff0ef          	jal	80003010 <brelse>
}
    800035fe:	60e2                	ld	ra,24(sp)
    80003600:	6442                	ld	s0,16(sp)
    80003602:	64a2                	ld	s1,8(sp)
    80003604:	6902                	ld	s2,0(sp)
    80003606:	6105                	addi	sp,sp,32
    80003608:	8082                	ret

000000008000360a <idup>:
{
    8000360a:	1101                	addi	sp,sp,-32
    8000360c:	ec06                	sd	ra,24(sp)
    8000360e:	e822                	sd	s0,16(sp)
    80003610:	e426                	sd	s1,8(sp)
    80003612:	1000                	addi	s0,sp,32
    80003614:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003616:	0001d517          	auipc	a0,0x1d
    8000361a:	ce250513          	addi	a0,a0,-798 # 800202f8 <itable>
    8000361e:	dd6fd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    80003622:	449c                	lw	a5,8(s1)
    80003624:	2785                	addiw	a5,a5,1
    80003626:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003628:	0001d517          	auipc	a0,0x1d
    8000362c:	cd050513          	addi	a0,a0,-816 # 800202f8 <itable>
    80003630:	e5cfd0ef          	jal	80000c8c <release>
}
    80003634:	8526                	mv	a0,s1
    80003636:	60e2                	ld	ra,24(sp)
    80003638:	6442                	ld	s0,16(sp)
    8000363a:	64a2                	ld	s1,8(sp)
    8000363c:	6105                	addi	sp,sp,32
    8000363e:	8082                	ret

0000000080003640 <ilock>:
{
    80003640:	1101                	addi	sp,sp,-32
    80003642:	ec06                	sd	ra,24(sp)
    80003644:	e822                	sd	s0,16(sp)
    80003646:	e426                	sd	s1,8(sp)
    80003648:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000364a:	cd19                	beqz	a0,80003668 <ilock+0x28>
    8000364c:	84aa                	mv	s1,a0
    8000364e:	451c                	lw	a5,8(a0)
    80003650:	00f05c63          	blez	a5,80003668 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003654:	0541                	addi	a0,a0,16
    80003656:	30b000ef          	jal	80004160 <acquiresleep>
  if(ip->valid == 0){
    8000365a:	40bc                	lw	a5,64(s1)
    8000365c:	cf89                	beqz	a5,80003676 <ilock+0x36>
}
    8000365e:	60e2                	ld	ra,24(sp)
    80003660:	6442                	ld	s0,16(sp)
    80003662:	64a2                	ld	s1,8(sp)
    80003664:	6105                	addi	sp,sp,32
    80003666:	8082                	ret
    80003668:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000366a:	00004517          	auipc	a0,0x4
    8000366e:	fce50513          	addi	a0,a0,-50 # 80007638 <etext+0x638>
    80003672:	922fd0ef          	jal	80000794 <panic>
    80003676:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003678:	40dc                	lw	a5,4(s1)
    8000367a:	0047d79b          	srliw	a5,a5,0x4
    8000367e:	0001d597          	auipc	a1,0x1d
    80003682:	c725a583          	lw	a1,-910(a1) # 800202f0 <sb+0x18>
    80003686:	9dbd                	addw	a1,a1,a5
    80003688:	4088                	lw	a0,0(s1)
    8000368a:	87fff0ef          	jal	80002f08 <bread>
    8000368e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003690:	05850593          	addi	a1,a0,88
    80003694:	40dc                	lw	a5,4(s1)
    80003696:	8bbd                	andi	a5,a5,15
    80003698:	079a                	slli	a5,a5,0x6
    8000369a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000369c:	00059783          	lh	a5,0(a1)
    800036a0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800036a4:	00259783          	lh	a5,2(a1)
    800036a8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800036ac:	00459783          	lh	a5,4(a1)
    800036b0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800036b4:	00659783          	lh	a5,6(a1)
    800036b8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800036bc:	459c                	lw	a5,8(a1)
    800036be:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800036c0:	03400613          	li	a2,52
    800036c4:	05b1                	addi	a1,a1,12
    800036c6:	05048513          	addi	a0,s1,80
    800036ca:	e5afd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    800036ce:	854a                	mv	a0,s2
    800036d0:	941ff0ef          	jal	80003010 <brelse>
    ip->valid = 1;
    800036d4:	4785                	li	a5,1
    800036d6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800036d8:	04449783          	lh	a5,68(s1)
    800036dc:	c399                	beqz	a5,800036e2 <ilock+0xa2>
    800036de:	6902                	ld	s2,0(sp)
    800036e0:	bfbd                	j	8000365e <ilock+0x1e>
      panic("ilock: no type");
    800036e2:	00004517          	auipc	a0,0x4
    800036e6:	f5e50513          	addi	a0,a0,-162 # 80007640 <etext+0x640>
    800036ea:	8aafd0ef          	jal	80000794 <panic>

00000000800036ee <iunlock>:
{
    800036ee:	1101                	addi	sp,sp,-32
    800036f0:	ec06                	sd	ra,24(sp)
    800036f2:	e822                	sd	s0,16(sp)
    800036f4:	e426                	sd	s1,8(sp)
    800036f6:	e04a                	sd	s2,0(sp)
    800036f8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036fa:	c505                	beqz	a0,80003722 <iunlock+0x34>
    800036fc:	84aa                	mv	s1,a0
    800036fe:	01050913          	addi	s2,a0,16
    80003702:	854a                	mv	a0,s2
    80003704:	2db000ef          	jal	800041de <holdingsleep>
    80003708:	cd09                	beqz	a0,80003722 <iunlock+0x34>
    8000370a:	449c                	lw	a5,8(s1)
    8000370c:	00f05b63          	blez	a5,80003722 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003710:	854a                	mv	a0,s2
    80003712:	295000ef          	jal	800041a6 <releasesleep>
}
    80003716:	60e2                	ld	ra,24(sp)
    80003718:	6442                	ld	s0,16(sp)
    8000371a:	64a2                	ld	s1,8(sp)
    8000371c:	6902                	ld	s2,0(sp)
    8000371e:	6105                	addi	sp,sp,32
    80003720:	8082                	ret
    panic("iunlock");
    80003722:	00004517          	auipc	a0,0x4
    80003726:	f2e50513          	addi	a0,a0,-210 # 80007650 <etext+0x650>
    8000372a:	86afd0ef          	jal	80000794 <panic>

000000008000372e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000372e:	7179                	addi	sp,sp,-48
    80003730:	f406                	sd	ra,40(sp)
    80003732:	f022                	sd	s0,32(sp)
    80003734:	ec26                	sd	s1,24(sp)
    80003736:	e84a                	sd	s2,16(sp)
    80003738:	e44e                	sd	s3,8(sp)
    8000373a:	1800                	addi	s0,sp,48
    8000373c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000373e:	05050493          	addi	s1,a0,80
    80003742:	08050913          	addi	s2,a0,128
    80003746:	a021                	j	8000374e <itrunc+0x20>
    80003748:	0491                	addi	s1,s1,4
    8000374a:	01248b63          	beq	s1,s2,80003760 <itrunc+0x32>
    if(ip->addrs[i]){
    8000374e:	408c                	lw	a1,0(s1)
    80003750:	dde5                	beqz	a1,80003748 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003752:	0009a503          	lw	a0,0(s3)
    80003756:	9abff0ef          	jal	80003100 <bfree>
      ip->addrs[i] = 0;
    8000375a:	0004a023          	sw	zero,0(s1)
    8000375e:	b7ed                	j	80003748 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003760:	0809a583          	lw	a1,128(s3)
    80003764:	ed89                	bnez	a1,8000377e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003766:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000376a:	854e                	mv	a0,s3
    8000376c:	e21ff0ef          	jal	8000358c <iupdate>
}
    80003770:	70a2                	ld	ra,40(sp)
    80003772:	7402                	ld	s0,32(sp)
    80003774:	64e2                	ld	s1,24(sp)
    80003776:	6942                	ld	s2,16(sp)
    80003778:	69a2                	ld	s3,8(sp)
    8000377a:	6145                	addi	sp,sp,48
    8000377c:	8082                	ret
    8000377e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003780:	0009a503          	lw	a0,0(s3)
    80003784:	f84ff0ef          	jal	80002f08 <bread>
    80003788:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000378a:	05850493          	addi	s1,a0,88
    8000378e:	45850913          	addi	s2,a0,1112
    80003792:	a021                	j	8000379a <itrunc+0x6c>
    80003794:	0491                	addi	s1,s1,4
    80003796:	01248963          	beq	s1,s2,800037a8 <itrunc+0x7a>
      if(a[j])
    8000379a:	408c                	lw	a1,0(s1)
    8000379c:	dde5                	beqz	a1,80003794 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000379e:	0009a503          	lw	a0,0(s3)
    800037a2:	95fff0ef          	jal	80003100 <bfree>
    800037a6:	b7fd                	j	80003794 <itrunc+0x66>
    brelse(bp);
    800037a8:	8552                	mv	a0,s4
    800037aa:	867ff0ef          	jal	80003010 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800037ae:	0809a583          	lw	a1,128(s3)
    800037b2:	0009a503          	lw	a0,0(s3)
    800037b6:	94bff0ef          	jal	80003100 <bfree>
    ip->addrs[NDIRECT] = 0;
    800037ba:	0809a023          	sw	zero,128(s3)
    800037be:	6a02                	ld	s4,0(sp)
    800037c0:	b75d                	j	80003766 <itrunc+0x38>

00000000800037c2 <iput>:
{
    800037c2:	1101                	addi	sp,sp,-32
    800037c4:	ec06                	sd	ra,24(sp)
    800037c6:	e822                	sd	s0,16(sp)
    800037c8:	e426                	sd	s1,8(sp)
    800037ca:	1000                	addi	s0,sp,32
    800037cc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037ce:	0001d517          	auipc	a0,0x1d
    800037d2:	b2a50513          	addi	a0,a0,-1238 # 800202f8 <itable>
    800037d6:	c1efd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037da:	4498                	lw	a4,8(s1)
    800037dc:	4785                	li	a5,1
    800037de:	02f70063          	beq	a4,a5,800037fe <iput+0x3c>
  ip->ref--;
    800037e2:	449c                	lw	a5,8(s1)
    800037e4:	37fd                	addiw	a5,a5,-1
    800037e6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037e8:	0001d517          	auipc	a0,0x1d
    800037ec:	b1050513          	addi	a0,a0,-1264 # 800202f8 <itable>
    800037f0:	c9cfd0ef          	jal	80000c8c <release>
}
    800037f4:	60e2                	ld	ra,24(sp)
    800037f6:	6442                	ld	s0,16(sp)
    800037f8:	64a2                	ld	s1,8(sp)
    800037fa:	6105                	addi	sp,sp,32
    800037fc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037fe:	40bc                	lw	a5,64(s1)
    80003800:	d3ed                	beqz	a5,800037e2 <iput+0x20>
    80003802:	04a49783          	lh	a5,74(s1)
    80003806:	fff1                	bnez	a5,800037e2 <iput+0x20>
    80003808:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000380a:	01048913          	addi	s2,s1,16
    8000380e:	854a                	mv	a0,s2
    80003810:	151000ef          	jal	80004160 <acquiresleep>
    release(&itable.lock);
    80003814:	0001d517          	auipc	a0,0x1d
    80003818:	ae450513          	addi	a0,a0,-1308 # 800202f8 <itable>
    8000381c:	c70fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    80003820:	8526                	mv	a0,s1
    80003822:	f0dff0ef          	jal	8000372e <itrunc>
    ip->type = 0;
    80003826:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000382a:	8526                	mv	a0,s1
    8000382c:	d61ff0ef          	jal	8000358c <iupdate>
    ip->valid = 0;
    80003830:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003834:	854a                	mv	a0,s2
    80003836:	171000ef          	jal	800041a6 <releasesleep>
    acquire(&itable.lock);
    8000383a:	0001d517          	auipc	a0,0x1d
    8000383e:	abe50513          	addi	a0,a0,-1346 # 800202f8 <itable>
    80003842:	bb2fd0ef          	jal	80000bf4 <acquire>
    80003846:	6902                	ld	s2,0(sp)
    80003848:	bf69                	j	800037e2 <iput+0x20>

000000008000384a <iunlockput>:
{
    8000384a:	1101                	addi	sp,sp,-32
    8000384c:	ec06                	sd	ra,24(sp)
    8000384e:	e822                	sd	s0,16(sp)
    80003850:	e426                	sd	s1,8(sp)
    80003852:	1000                	addi	s0,sp,32
    80003854:	84aa                	mv	s1,a0
  iunlock(ip);
    80003856:	e99ff0ef          	jal	800036ee <iunlock>
  iput(ip);
    8000385a:	8526                	mv	a0,s1
    8000385c:	f67ff0ef          	jal	800037c2 <iput>
}
    80003860:	60e2                	ld	ra,24(sp)
    80003862:	6442                	ld	s0,16(sp)
    80003864:	64a2                	ld	s1,8(sp)
    80003866:	6105                	addi	sp,sp,32
    80003868:	8082                	ret

000000008000386a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000386a:	1141                	addi	sp,sp,-16
    8000386c:	e422                	sd	s0,8(sp)
    8000386e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003870:	411c                	lw	a5,0(a0)
    80003872:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003874:	415c                	lw	a5,4(a0)
    80003876:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003878:	04451783          	lh	a5,68(a0)
    8000387c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003880:	04a51783          	lh	a5,74(a0)
    80003884:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003888:	04c56783          	lwu	a5,76(a0)
    8000388c:	e99c                	sd	a5,16(a1)
}
    8000388e:	6422                	ld	s0,8(sp)
    80003890:	0141                	addi	sp,sp,16
    80003892:	8082                	ret

0000000080003894 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003894:	457c                	lw	a5,76(a0)
    80003896:	0ed7eb63          	bltu	a5,a3,8000398c <readi+0xf8>
{
    8000389a:	7159                	addi	sp,sp,-112
    8000389c:	f486                	sd	ra,104(sp)
    8000389e:	f0a2                	sd	s0,96(sp)
    800038a0:	eca6                	sd	s1,88(sp)
    800038a2:	e0d2                	sd	s4,64(sp)
    800038a4:	fc56                	sd	s5,56(sp)
    800038a6:	f85a                	sd	s6,48(sp)
    800038a8:	f45e                	sd	s7,40(sp)
    800038aa:	1880                	addi	s0,sp,112
    800038ac:	8b2a                	mv	s6,a0
    800038ae:	8bae                	mv	s7,a1
    800038b0:	8a32                	mv	s4,a2
    800038b2:	84b6                	mv	s1,a3
    800038b4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800038b6:	9f35                	addw	a4,a4,a3
    return 0;
    800038b8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038ba:	0cd76063          	bltu	a4,a3,8000397a <readi+0xe6>
    800038be:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800038c0:	00e7f463          	bgeu	a5,a4,800038c8 <readi+0x34>
    n = ip->size - off;
    800038c4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038c8:	080a8f63          	beqz	s5,80003966 <readi+0xd2>
    800038cc:	e8ca                	sd	s2,80(sp)
    800038ce:	f062                	sd	s8,32(sp)
    800038d0:	ec66                	sd	s9,24(sp)
    800038d2:	e86a                	sd	s10,16(sp)
    800038d4:	e46e                	sd	s11,8(sp)
    800038d6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800038d8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038dc:	5c7d                	li	s8,-1
    800038de:	a80d                	j	80003910 <readi+0x7c>
    800038e0:	020d1d93          	slli	s11,s10,0x20
    800038e4:	020ddd93          	srli	s11,s11,0x20
    800038e8:	05890613          	addi	a2,s2,88
    800038ec:	86ee                	mv	a3,s11
    800038ee:	963a                	add	a2,a2,a4
    800038f0:	85d2                	mv	a1,s4
    800038f2:	855e                	mv	a0,s7
    800038f4:	d18fe0ef          	jal	80001e0c <either_copyout>
    800038f8:	05850763          	beq	a0,s8,80003946 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800038fc:	854a                	mv	a0,s2
    800038fe:	f12ff0ef          	jal	80003010 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003902:	013d09bb          	addw	s3,s10,s3
    80003906:	009d04bb          	addw	s1,s10,s1
    8000390a:	9a6e                	add	s4,s4,s11
    8000390c:	0559f763          	bgeu	s3,s5,8000395a <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003910:	00a4d59b          	srliw	a1,s1,0xa
    80003914:	855a                	mv	a0,s6
    80003916:	977ff0ef          	jal	8000328c <bmap>
    8000391a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000391e:	c5b1                	beqz	a1,8000396a <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003920:	000b2503          	lw	a0,0(s6)
    80003924:	de4ff0ef          	jal	80002f08 <bread>
    80003928:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000392a:	3ff4f713          	andi	a4,s1,1023
    8000392e:	40ec87bb          	subw	a5,s9,a4
    80003932:	413a86bb          	subw	a3,s5,s3
    80003936:	8d3e                	mv	s10,a5
    80003938:	2781                	sext.w	a5,a5
    8000393a:	0006861b          	sext.w	a2,a3
    8000393e:	faf671e3          	bgeu	a2,a5,800038e0 <readi+0x4c>
    80003942:	8d36                	mv	s10,a3
    80003944:	bf71                	j	800038e0 <readi+0x4c>
      brelse(bp);
    80003946:	854a                	mv	a0,s2
    80003948:	ec8ff0ef          	jal	80003010 <brelse>
      tot = -1;
    8000394c:	59fd                	li	s3,-1
      break;
    8000394e:	6946                	ld	s2,80(sp)
    80003950:	7c02                	ld	s8,32(sp)
    80003952:	6ce2                	ld	s9,24(sp)
    80003954:	6d42                	ld	s10,16(sp)
    80003956:	6da2                	ld	s11,8(sp)
    80003958:	a831                	j	80003974 <readi+0xe0>
    8000395a:	6946                	ld	s2,80(sp)
    8000395c:	7c02                	ld	s8,32(sp)
    8000395e:	6ce2                	ld	s9,24(sp)
    80003960:	6d42                	ld	s10,16(sp)
    80003962:	6da2                	ld	s11,8(sp)
    80003964:	a801                	j	80003974 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003966:	89d6                	mv	s3,s5
    80003968:	a031                	j	80003974 <readi+0xe0>
    8000396a:	6946                	ld	s2,80(sp)
    8000396c:	7c02                	ld	s8,32(sp)
    8000396e:	6ce2                	ld	s9,24(sp)
    80003970:	6d42                	ld	s10,16(sp)
    80003972:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003974:	0009851b          	sext.w	a0,s3
    80003978:	69a6                	ld	s3,72(sp)
}
    8000397a:	70a6                	ld	ra,104(sp)
    8000397c:	7406                	ld	s0,96(sp)
    8000397e:	64e6                	ld	s1,88(sp)
    80003980:	6a06                	ld	s4,64(sp)
    80003982:	7ae2                	ld	s5,56(sp)
    80003984:	7b42                	ld	s6,48(sp)
    80003986:	7ba2                	ld	s7,40(sp)
    80003988:	6165                	addi	sp,sp,112
    8000398a:	8082                	ret
    return 0;
    8000398c:	4501                	li	a0,0
}
    8000398e:	8082                	ret

0000000080003990 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003990:	457c                	lw	a5,76(a0)
    80003992:	10d7e063          	bltu	a5,a3,80003a92 <writei+0x102>
{
    80003996:	7159                	addi	sp,sp,-112
    80003998:	f486                	sd	ra,104(sp)
    8000399a:	f0a2                	sd	s0,96(sp)
    8000399c:	e8ca                	sd	s2,80(sp)
    8000399e:	e0d2                	sd	s4,64(sp)
    800039a0:	fc56                	sd	s5,56(sp)
    800039a2:	f85a                	sd	s6,48(sp)
    800039a4:	f45e                	sd	s7,40(sp)
    800039a6:	1880                	addi	s0,sp,112
    800039a8:	8aaa                	mv	s5,a0
    800039aa:	8bae                	mv	s7,a1
    800039ac:	8a32                	mv	s4,a2
    800039ae:	8936                	mv	s2,a3
    800039b0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039b2:	00e687bb          	addw	a5,a3,a4
    800039b6:	0ed7e063          	bltu	a5,a3,80003a96 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039ba:	00043737          	lui	a4,0x43
    800039be:	0cf76e63          	bltu	a4,a5,80003a9a <writei+0x10a>
    800039c2:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039c4:	0a0b0f63          	beqz	s6,80003a82 <writei+0xf2>
    800039c8:	eca6                	sd	s1,88(sp)
    800039ca:	f062                	sd	s8,32(sp)
    800039cc:	ec66                	sd	s9,24(sp)
    800039ce:	e86a                	sd	s10,16(sp)
    800039d0:	e46e                	sd	s11,8(sp)
    800039d2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800039d4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039d8:	5c7d                	li	s8,-1
    800039da:	a825                	j	80003a12 <writei+0x82>
    800039dc:	020d1d93          	slli	s11,s10,0x20
    800039e0:	020ddd93          	srli	s11,s11,0x20
    800039e4:	05848513          	addi	a0,s1,88
    800039e8:	86ee                	mv	a3,s11
    800039ea:	8652                	mv	a2,s4
    800039ec:	85de                	mv	a1,s7
    800039ee:	953a                	add	a0,a0,a4
    800039f0:	c66fe0ef          	jal	80001e56 <either_copyin>
    800039f4:	05850a63          	beq	a0,s8,80003a48 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800039f8:	8526                	mv	a0,s1
    800039fa:	660000ef          	jal	8000405a <log_write>
    brelse(bp);
    800039fe:	8526                	mv	a0,s1
    80003a00:	e10ff0ef          	jal	80003010 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a04:	013d09bb          	addw	s3,s10,s3
    80003a08:	012d093b          	addw	s2,s10,s2
    80003a0c:	9a6e                	add	s4,s4,s11
    80003a0e:	0569f063          	bgeu	s3,s6,80003a4e <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003a12:	00a9559b          	srliw	a1,s2,0xa
    80003a16:	8556                	mv	a0,s5
    80003a18:	875ff0ef          	jal	8000328c <bmap>
    80003a1c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003a20:	c59d                	beqz	a1,80003a4e <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003a22:	000aa503          	lw	a0,0(s5)
    80003a26:	ce2ff0ef          	jal	80002f08 <bread>
    80003a2a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a2c:	3ff97713          	andi	a4,s2,1023
    80003a30:	40ec87bb          	subw	a5,s9,a4
    80003a34:	413b06bb          	subw	a3,s6,s3
    80003a38:	8d3e                	mv	s10,a5
    80003a3a:	2781                	sext.w	a5,a5
    80003a3c:	0006861b          	sext.w	a2,a3
    80003a40:	f8f67ee3          	bgeu	a2,a5,800039dc <writei+0x4c>
    80003a44:	8d36                	mv	s10,a3
    80003a46:	bf59                	j	800039dc <writei+0x4c>
      brelse(bp);
    80003a48:	8526                	mv	a0,s1
    80003a4a:	dc6ff0ef          	jal	80003010 <brelse>
  }

  if(off > ip->size)
    80003a4e:	04caa783          	lw	a5,76(s5)
    80003a52:	0327fa63          	bgeu	a5,s2,80003a86 <writei+0xf6>
    ip->size = off;
    80003a56:	052aa623          	sw	s2,76(s5)
    80003a5a:	64e6                	ld	s1,88(sp)
    80003a5c:	7c02                	ld	s8,32(sp)
    80003a5e:	6ce2                	ld	s9,24(sp)
    80003a60:	6d42                	ld	s10,16(sp)
    80003a62:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003a64:	8556                	mv	a0,s5
    80003a66:	b27ff0ef          	jal	8000358c <iupdate>

  return tot;
    80003a6a:	0009851b          	sext.w	a0,s3
    80003a6e:	69a6                	ld	s3,72(sp)
}
    80003a70:	70a6                	ld	ra,104(sp)
    80003a72:	7406                	ld	s0,96(sp)
    80003a74:	6946                	ld	s2,80(sp)
    80003a76:	6a06                	ld	s4,64(sp)
    80003a78:	7ae2                	ld	s5,56(sp)
    80003a7a:	7b42                	ld	s6,48(sp)
    80003a7c:	7ba2                	ld	s7,40(sp)
    80003a7e:	6165                	addi	sp,sp,112
    80003a80:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a82:	89da                	mv	s3,s6
    80003a84:	b7c5                	j	80003a64 <writei+0xd4>
    80003a86:	64e6                	ld	s1,88(sp)
    80003a88:	7c02                	ld	s8,32(sp)
    80003a8a:	6ce2                	ld	s9,24(sp)
    80003a8c:	6d42                	ld	s10,16(sp)
    80003a8e:	6da2                	ld	s11,8(sp)
    80003a90:	bfd1                	j	80003a64 <writei+0xd4>
    return -1;
    80003a92:	557d                	li	a0,-1
}
    80003a94:	8082                	ret
    return -1;
    80003a96:	557d                	li	a0,-1
    80003a98:	bfe1                	j	80003a70 <writei+0xe0>
    return -1;
    80003a9a:	557d                	li	a0,-1
    80003a9c:	bfd1                	j	80003a70 <writei+0xe0>

0000000080003a9e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a9e:	1141                	addi	sp,sp,-16
    80003aa0:	e406                	sd	ra,8(sp)
    80003aa2:	e022                	sd	s0,0(sp)
    80003aa4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003aa6:	4639                	li	a2,14
    80003aa8:	aecfd0ef          	jal	80000d94 <strncmp>
}
    80003aac:	60a2                	ld	ra,8(sp)
    80003aae:	6402                	ld	s0,0(sp)
    80003ab0:	0141                	addi	sp,sp,16
    80003ab2:	8082                	ret

0000000080003ab4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ab4:	7139                	addi	sp,sp,-64
    80003ab6:	fc06                	sd	ra,56(sp)
    80003ab8:	f822                	sd	s0,48(sp)
    80003aba:	f426                	sd	s1,40(sp)
    80003abc:	f04a                	sd	s2,32(sp)
    80003abe:	ec4e                	sd	s3,24(sp)
    80003ac0:	e852                	sd	s4,16(sp)
    80003ac2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ac4:	04451703          	lh	a4,68(a0)
    80003ac8:	4785                	li	a5,1
    80003aca:	00f71a63          	bne	a4,a5,80003ade <dirlookup+0x2a>
    80003ace:	892a                	mv	s2,a0
    80003ad0:	89ae                	mv	s3,a1
    80003ad2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ad4:	457c                	lw	a5,76(a0)
    80003ad6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003ad8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ada:	e39d                	bnez	a5,80003b00 <dirlookup+0x4c>
    80003adc:	a095                	j	80003b40 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003ade:	00004517          	auipc	a0,0x4
    80003ae2:	b7a50513          	addi	a0,a0,-1158 # 80007658 <etext+0x658>
    80003ae6:	caffc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003aea:	00004517          	auipc	a0,0x4
    80003aee:	b8650513          	addi	a0,a0,-1146 # 80007670 <etext+0x670>
    80003af2:	ca3fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003af6:	24c1                	addiw	s1,s1,16
    80003af8:	04c92783          	lw	a5,76(s2)
    80003afc:	04f4f163          	bgeu	s1,a5,80003b3e <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b00:	4741                	li	a4,16
    80003b02:	86a6                	mv	a3,s1
    80003b04:	fc040613          	addi	a2,s0,-64
    80003b08:	4581                	li	a1,0
    80003b0a:	854a                	mv	a0,s2
    80003b0c:	d89ff0ef          	jal	80003894 <readi>
    80003b10:	47c1                	li	a5,16
    80003b12:	fcf51ce3          	bne	a0,a5,80003aea <dirlookup+0x36>
    if(de.inum == 0)
    80003b16:	fc045783          	lhu	a5,-64(s0)
    80003b1a:	dff1                	beqz	a5,80003af6 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003b1c:	fc240593          	addi	a1,s0,-62
    80003b20:	854e                	mv	a0,s3
    80003b22:	f7dff0ef          	jal	80003a9e <namecmp>
    80003b26:	f961                	bnez	a0,80003af6 <dirlookup+0x42>
      if(poff)
    80003b28:	000a0463          	beqz	s4,80003b30 <dirlookup+0x7c>
        *poff = off;
    80003b2c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b30:	fc045583          	lhu	a1,-64(s0)
    80003b34:	00092503          	lw	a0,0(s2)
    80003b38:	829ff0ef          	jal	80003360 <iget>
    80003b3c:	a011                	j	80003b40 <dirlookup+0x8c>
  return 0;
    80003b3e:	4501                	li	a0,0
}
    80003b40:	70e2                	ld	ra,56(sp)
    80003b42:	7442                	ld	s0,48(sp)
    80003b44:	74a2                	ld	s1,40(sp)
    80003b46:	7902                	ld	s2,32(sp)
    80003b48:	69e2                	ld	s3,24(sp)
    80003b4a:	6a42                	ld	s4,16(sp)
    80003b4c:	6121                	addi	sp,sp,64
    80003b4e:	8082                	ret

0000000080003b50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b50:	711d                	addi	sp,sp,-96
    80003b52:	ec86                	sd	ra,88(sp)
    80003b54:	e8a2                	sd	s0,80(sp)
    80003b56:	e4a6                	sd	s1,72(sp)
    80003b58:	e0ca                	sd	s2,64(sp)
    80003b5a:	fc4e                	sd	s3,56(sp)
    80003b5c:	f852                	sd	s4,48(sp)
    80003b5e:	f456                	sd	s5,40(sp)
    80003b60:	f05a                	sd	s6,32(sp)
    80003b62:	ec5e                	sd	s7,24(sp)
    80003b64:	e862                	sd	s8,16(sp)
    80003b66:	e466                	sd	s9,8(sp)
    80003b68:	1080                	addi	s0,sp,96
    80003b6a:	84aa                	mv	s1,a0
    80003b6c:	8b2e                	mv	s6,a1
    80003b6e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003b70:	00054703          	lbu	a4,0(a0)
    80003b74:	02f00793          	li	a5,47
    80003b78:	00f70e63          	beq	a4,a5,80003b94 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003b7c:	d87fd0ef          	jal	80001902 <myproc>
    80003b80:	15053503          	ld	a0,336(a0)
    80003b84:	a87ff0ef          	jal	8000360a <idup>
    80003b88:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003b8a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003b8e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003b90:	4b85                	li	s7,1
    80003b92:	a871                	j	80003c2e <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003b94:	4585                	li	a1,1
    80003b96:	4505                	li	a0,1
    80003b98:	fc8ff0ef          	jal	80003360 <iget>
    80003b9c:	8a2a                	mv	s4,a0
    80003b9e:	b7f5                	j	80003b8a <namex+0x3a>
      iunlockput(ip);
    80003ba0:	8552                	mv	a0,s4
    80003ba2:	ca9ff0ef          	jal	8000384a <iunlockput>
      return 0;
    80003ba6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003ba8:	8552                	mv	a0,s4
    80003baa:	60e6                	ld	ra,88(sp)
    80003bac:	6446                	ld	s0,80(sp)
    80003bae:	64a6                	ld	s1,72(sp)
    80003bb0:	6906                	ld	s2,64(sp)
    80003bb2:	79e2                	ld	s3,56(sp)
    80003bb4:	7a42                	ld	s4,48(sp)
    80003bb6:	7aa2                	ld	s5,40(sp)
    80003bb8:	7b02                	ld	s6,32(sp)
    80003bba:	6be2                	ld	s7,24(sp)
    80003bbc:	6c42                	ld	s8,16(sp)
    80003bbe:	6ca2                	ld	s9,8(sp)
    80003bc0:	6125                	addi	sp,sp,96
    80003bc2:	8082                	ret
      iunlock(ip);
    80003bc4:	8552                	mv	a0,s4
    80003bc6:	b29ff0ef          	jal	800036ee <iunlock>
      return ip;
    80003bca:	bff9                	j	80003ba8 <namex+0x58>
      iunlockput(ip);
    80003bcc:	8552                	mv	a0,s4
    80003bce:	c7dff0ef          	jal	8000384a <iunlockput>
      return 0;
    80003bd2:	8a4e                	mv	s4,s3
    80003bd4:	bfd1                	j	80003ba8 <namex+0x58>
  len = path - s;
    80003bd6:	40998633          	sub	a2,s3,s1
    80003bda:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003bde:	099c5063          	bge	s8,s9,80003c5e <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003be2:	4639                	li	a2,14
    80003be4:	85a6                	mv	a1,s1
    80003be6:	8556                	mv	a0,s5
    80003be8:	93cfd0ef          	jal	80000d24 <memmove>
    80003bec:	84ce                	mv	s1,s3
  while(*path == '/')
    80003bee:	0004c783          	lbu	a5,0(s1)
    80003bf2:	01279763          	bne	a5,s2,80003c00 <namex+0xb0>
    path++;
    80003bf6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003bf8:	0004c783          	lbu	a5,0(s1)
    80003bfc:	ff278de3          	beq	a5,s2,80003bf6 <namex+0xa6>
    ilock(ip);
    80003c00:	8552                	mv	a0,s4
    80003c02:	a3fff0ef          	jal	80003640 <ilock>
    if(ip->type != T_DIR){
    80003c06:	044a1783          	lh	a5,68(s4)
    80003c0a:	f9779be3          	bne	a5,s7,80003ba0 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003c0e:	000b0563          	beqz	s6,80003c18 <namex+0xc8>
    80003c12:	0004c783          	lbu	a5,0(s1)
    80003c16:	d7dd                	beqz	a5,80003bc4 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c18:	4601                	li	a2,0
    80003c1a:	85d6                	mv	a1,s5
    80003c1c:	8552                	mv	a0,s4
    80003c1e:	e97ff0ef          	jal	80003ab4 <dirlookup>
    80003c22:	89aa                	mv	s3,a0
    80003c24:	d545                	beqz	a0,80003bcc <namex+0x7c>
    iunlockput(ip);
    80003c26:	8552                	mv	a0,s4
    80003c28:	c23ff0ef          	jal	8000384a <iunlockput>
    ip = next;
    80003c2c:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003c2e:	0004c783          	lbu	a5,0(s1)
    80003c32:	01279763          	bne	a5,s2,80003c40 <namex+0xf0>
    path++;
    80003c36:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c38:	0004c783          	lbu	a5,0(s1)
    80003c3c:	ff278de3          	beq	a5,s2,80003c36 <namex+0xe6>
  if(*path == 0)
    80003c40:	cb8d                	beqz	a5,80003c72 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003c42:	0004c783          	lbu	a5,0(s1)
    80003c46:	89a6                	mv	s3,s1
  len = path - s;
    80003c48:	4c81                	li	s9,0
    80003c4a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003c4c:	01278963          	beq	a5,s2,80003c5e <namex+0x10e>
    80003c50:	d3d9                	beqz	a5,80003bd6 <namex+0x86>
    path++;
    80003c52:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003c54:	0009c783          	lbu	a5,0(s3)
    80003c58:	ff279ce3          	bne	a5,s2,80003c50 <namex+0x100>
    80003c5c:	bfad                	j	80003bd6 <namex+0x86>
    memmove(name, s, len);
    80003c5e:	2601                	sext.w	a2,a2
    80003c60:	85a6                	mv	a1,s1
    80003c62:	8556                	mv	a0,s5
    80003c64:	8c0fd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003c68:	9cd6                	add	s9,s9,s5
    80003c6a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003c6e:	84ce                	mv	s1,s3
    80003c70:	bfbd                	j	80003bee <namex+0x9e>
  if(nameiparent){
    80003c72:	f20b0be3          	beqz	s6,80003ba8 <namex+0x58>
    iput(ip);
    80003c76:	8552                	mv	a0,s4
    80003c78:	b4bff0ef          	jal	800037c2 <iput>
    return 0;
    80003c7c:	4a01                	li	s4,0
    80003c7e:	b72d                	j	80003ba8 <namex+0x58>

0000000080003c80 <dirlink>:
{
    80003c80:	7139                	addi	sp,sp,-64
    80003c82:	fc06                	sd	ra,56(sp)
    80003c84:	f822                	sd	s0,48(sp)
    80003c86:	f04a                	sd	s2,32(sp)
    80003c88:	ec4e                	sd	s3,24(sp)
    80003c8a:	e852                	sd	s4,16(sp)
    80003c8c:	0080                	addi	s0,sp,64
    80003c8e:	892a                	mv	s2,a0
    80003c90:	8a2e                	mv	s4,a1
    80003c92:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003c94:	4601                	li	a2,0
    80003c96:	e1fff0ef          	jal	80003ab4 <dirlookup>
    80003c9a:	e535                	bnez	a0,80003d06 <dirlink+0x86>
    80003c9c:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c9e:	04c92483          	lw	s1,76(s2)
    80003ca2:	c48d                	beqz	s1,80003ccc <dirlink+0x4c>
    80003ca4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ca6:	4741                	li	a4,16
    80003ca8:	86a6                	mv	a3,s1
    80003caa:	fc040613          	addi	a2,s0,-64
    80003cae:	4581                	li	a1,0
    80003cb0:	854a                	mv	a0,s2
    80003cb2:	be3ff0ef          	jal	80003894 <readi>
    80003cb6:	47c1                	li	a5,16
    80003cb8:	04f51b63          	bne	a0,a5,80003d0e <dirlink+0x8e>
    if(de.inum == 0)
    80003cbc:	fc045783          	lhu	a5,-64(s0)
    80003cc0:	c791                	beqz	a5,80003ccc <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cc2:	24c1                	addiw	s1,s1,16
    80003cc4:	04c92783          	lw	a5,76(s2)
    80003cc8:	fcf4efe3          	bltu	s1,a5,80003ca6 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003ccc:	4639                	li	a2,14
    80003cce:	85d2                	mv	a1,s4
    80003cd0:	fc240513          	addi	a0,s0,-62
    80003cd4:	8f6fd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003cd8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cdc:	4741                	li	a4,16
    80003cde:	86a6                	mv	a3,s1
    80003ce0:	fc040613          	addi	a2,s0,-64
    80003ce4:	4581                	li	a1,0
    80003ce6:	854a                	mv	a0,s2
    80003ce8:	ca9ff0ef          	jal	80003990 <writei>
    80003cec:	1541                	addi	a0,a0,-16
    80003cee:	00a03533          	snez	a0,a0
    80003cf2:	40a00533          	neg	a0,a0
    80003cf6:	74a2                	ld	s1,40(sp)
}
    80003cf8:	70e2                	ld	ra,56(sp)
    80003cfa:	7442                	ld	s0,48(sp)
    80003cfc:	7902                	ld	s2,32(sp)
    80003cfe:	69e2                	ld	s3,24(sp)
    80003d00:	6a42                	ld	s4,16(sp)
    80003d02:	6121                	addi	sp,sp,64
    80003d04:	8082                	ret
    iput(ip);
    80003d06:	abdff0ef          	jal	800037c2 <iput>
    return -1;
    80003d0a:	557d                	li	a0,-1
    80003d0c:	b7f5                	j	80003cf8 <dirlink+0x78>
      panic("dirlink read");
    80003d0e:	00004517          	auipc	a0,0x4
    80003d12:	97250513          	addi	a0,a0,-1678 # 80007680 <etext+0x680>
    80003d16:	a7ffc0ef          	jal	80000794 <panic>

0000000080003d1a <namei>:

struct inode*
namei(char *path)
{
    80003d1a:	1101                	addi	sp,sp,-32
    80003d1c:	ec06                	sd	ra,24(sp)
    80003d1e:	e822                	sd	s0,16(sp)
    80003d20:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003d22:	fe040613          	addi	a2,s0,-32
    80003d26:	4581                	li	a1,0
    80003d28:	e29ff0ef          	jal	80003b50 <namex>
}
    80003d2c:	60e2                	ld	ra,24(sp)
    80003d2e:	6442                	ld	s0,16(sp)
    80003d30:	6105                	addi	sp,sp,32
    80003d32:	8082                	ret

0000000080003d34 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003d34:	1141                	addi	sp,sp,-16
    80003d36:	e406                	sd	ra,8(sp)
    80003d38:	e022                	sd	s0,0(sp)
    80003d3a:	0800                	addi	s0,sp,16
    80003d3c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003d3e:	4585                	li	a1,1
    80003d40:	e11ff0ef          	jal	80003b50 <namex>
}
    80003d44:	60a2                	ld	ra,8(sp)
    80003d46:	6402                	ld	s0,0(sp)
    80003d48:	0141                	addi	sp,sp,16
    80003d4a:	8082                	ret

0000000080003d4c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003d4c:	1101                	addi	sp,sp,-32
    80003d4e:	ec06                	sd	ra,24(sp)
    80003d50:	e822                	sd	s0,16(sp)
    80003d52:	e426                	sd	s1,8(sp)
    80003d54:	e04a                	sd	s2,0(sp)
    80003d56:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003d58:	0001e917          	auipc	s2,0x1e
    80003d5c:	04890913          	addi	s2,s2,72 # 80021da0 <log>
    80003d60:	01892583          	lw	a1,24(s2)
    80003d64:	02892503          	lw	a0,40(s2)
    80003d68:	9a0ff0ef          	jal	80002f08 <bread>
    80003d6c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003d6e:	02c92603          	lw	a2,44(s2)
    80003d72:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003d74:	00c05f63          	blez	a2,80003d92 <write_head+0x46>
    80003d78:	0001e717          	auipc	a4,0x1e
    80003d7c:	05870713          	addi	a4,a4,88 # 80021dd0 <log+0x30>
    80003d80:	87aa                	mv	a5,a0
    80003d82:	060a                	slli	a2,a2,0x2
    80003d84:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003d86:	4314                	lw	a3,0(a4)
    80003d88:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003d8a:	0711                	addi	a4,a4,4
    80003d8c:	0791                	addi	a5,a5,4
    80003d8e:	fec79ce3          	bne	a5,a2,80003d86 <write_head+0x3a>
  }
  bwrite(buf);
    80003d92:	8526                	mv	a0,s1
    80003d94:	a4aff0ef          	jal	80002fde <bwrite>
  brelse(buf);
    80003d98:	8526                	mv	a0,s1
    80003d9a:	a76ff0ef          	jal	80003010 <brelse>
}
    80003d9e:	60e2                	ld	ra,24(sp)
    80003da0:	6442                	ld	s0,16(sp)
    80003da2:	64a2                	ld	s1,8(sp)
    80003da4:	6902                	ld	s2,0(sp)
    80003da6:	6105                	addi	sp,sp,32
    80003da8:	8082                	ret

0000000080003daa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003daa:	0001e797          	auipc	a5,0x1e
    80003dae:	0227a783          	lw	a5,34(a5) # 80021dcc <log+0x2c>
    80003db2:	08f05f63          	blez	a5,80003e50 <install_trans+0xa6>
{
    80003db6:	7139                	addi	sp,sp,-64
    80003db8:	fc06                	sd	ra,56(sp)
    80003dba:	f822                	sd	s0,48(sp)
    80003dbc:	f426                	sd	s1,40(sp)
    80003dbe:	f04a                	sd	s2,32(sp)
    80003dc0:	ec4e                	sd	s3,24(sp)
    80003dc2:	e852                	sd	s4,16(sp)
    80003dc4:	e456                	sd	s5,8(sp)
    80003dc6:	e05a                	sd	s6,0(sp)
    80003dc8:	0080                	addi	s0,sp,64
    80003dca:	8b2a                	mv	s6,a0
    80003dcc:	0001ea97          	auipc	s5,0x1e
    80003dd0:	004a8a93          	addi	s5,s5,4 # 80021dd0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dd4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003dd6:	0001e997          	auipc	s3,0x1e
    80003dda:	fca98993          	addi	s3,s3,-54 # 80021da0 <log>
    80003dde:	a829                	j	80003df8 <install_trans+0x4e>
    brelse(lbuf);
    80003de0:	854a                	mv	a0,s2
    80003de2:	a2eff0ef          	jal	80003010 <brelse>
    brelse(dbuf);
    80003de6:	8526                	mv	a0,s1
    80003de8:	a28ff0ef          	jal	80003010 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dec:	2a05                	addiw	s4,s4,1
    80003dee:	0a91                	addi	s5,s5,4
    80003df0:	02c9a783          	lw	a5,44(s3)
    80003df4:	04fa5463          	bge	s4,a5,80003e3c <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003df8:	0189a583          	lw	a1,24(s3)
    80003dfc:	014585bb          	addw	a1,a1,s4
    80003e00:	2585                	addiw	a1,a1,1
    80003e02:	0289a503          	lw	a0,40(s3)
    80003e06:	902ff0ef          	jal	80002f08 <bread>
    80003e0a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003e0c:	000aa583          	lw	a1,0(s5)
    80003e10:	0289a503          	lw	a0,40(s3)
    80003e14:	8f4ff0ef          	jal	80002f08 <bread>
    80003e18:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003e1a:	40000613          	li	a2,1024
    80003e1e:	05890593          	addi	a1,s2,88
    80003e22:	05850513          	addi	a0,a0,88
    80003e26:	efffc0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	9b2ff0ef          	jal	80002fde <bwrite>
    if(recovering == 0)
    80003e30:	fa0b18e3          	bnez	s6,80003de0 <install_trans+0x36>
      bunpin(dbuf);
    80003e34:	8526                	mv	a0,s1
    80003e36:	a96ff0ef          	jal	800030cc <bunpin>
    80003e3a:	b75d                	j	80003de0 <install_trans+0x36>
}
    80003e3c:	70e2                	ld	ra,56(sp)
    80003e3e:	7442                	ld	s0,48(sp)
    80003e40:	74a2                	ld	s1,40(sp)
    80003e42:	7902                	ld	s2,32(sp)
    80003e44:	69e2                	ld	s3,24(sp)
    80003e46:	6a42                	ld	s4,16(sp)
    80003e48:	6aa2                	ld	s5,8(sp)
    80003e4a:	6b02                	ld	s6,0(sp)
    80003e4c:	6121                	addi	sp,sp,64
    80003e4e:	8082                	ret
    80003e50:	8082                	ret

0000000080003e52 <initlog>:
{
    80003e52:	7179                	addi	sp,sp,-48
    80003e54:	f406                	sd	ra,40(sp)
    80003e56:	f022                	sd	s0,32(sp)
    80003e58:	ec26                	sd	s1,24(sp)
    80003e5a:	e84a                	sd	s2,16(sp)
    80003e5c:	e44e                	sd	s3,8(sp)
    80003e5e:	1800                	addi	s0,sp,48
    80003e60:	892a                	mv	s2,a0
    80003e62:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003e64:	0001e497          	auipc	s1,0x1e
    80003e68:	f3c48493          	addi	s1,s1,-196 # 80021da0 <log>
    80003e6c:	00004597          	auipc	a1,0x4
    80003e70:	82458593          	addi	a1,a1,-2012 # 80007690 <etext+0x690>
    80003e74:	8526                	mv	a0,s1
    80003e76:	cfffc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003e7a:	0149a583          	lw	a1,20(s3)
    80003e7e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003e80:	0109a783          	lw	a5,16(s3)
    80003e84:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003e86:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003e8a:	854a                	mv	a0,s2
    80003e8c:	87cff0ef          	jal	80002f08 <bread>
  log.lh.n = lh->n;
    80003e90:	4d30                	lw	a2,88(a0)
    80003e92:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003e94:	00c05f63          	blez	a2,80003eb2 <initlog+0x60>
    80003e98:	87aa                	mv	a5,a0
    80003e9a:	0001e717          	auipc	a4,0x1e
    80003e9e:	f3670713          	addi	a4,a4,-202 # 80021dd0 <log+0x30>
    80003ea2:	060a                	slli	a2,a2,0x2
    80003ea4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003ea6:	4ff4                	lw	a3,92(a5)
    80003ea8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003eaa:	0791                	addi	a5,a5,4
    80003eac:	0711                	addi	a4,a4,4
    80003eae:	fec79ce3          	bne	a5,a2,80003ea6 <initlog+0x54>
  brelse(buf);
    80003eb2:	95eff0ef          	jal	80003010 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003eb6:	4505                	li	a0,1
    80003eb8:	ef3ff0ef          	jal	80003daa <install_trans>
  log.lh.n = 0;
    80003ebc:	0001e797          	auipc	a5,0x1e
    80003ec0:	f007a823          	sw	zero,-240(a5) # 80021dcc <log+0x2c>
  write_head(); // clear the log
    80003ec4:	e89ff0ef          	jal	80003d4c <write_head>
}
    80003ec8:	70a2                	ld	ra,40(sp)
    80003eca:	7402                	ld	s0,32(sp)
    80003ecc:	64e2                	ld	s1,24(sp)
    80003ece:	6942                	ld	s2,16(sp)
    80003ed0:	69a2                	ld	s3,8(sp)
    80003ed2:	6145                	addi	sp,sp,48
    80003ed4:	8082                	ret

0000000080003ed6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003ed6:	1101                	addi	sp,sp,-32
    80003ed8:	ec06                	sd	ra,24(sp)
    80003eda:	e822                	sd	s0,16(sp)
    80003edc:	e426                	sd	s1,8(sp)
    80003ede:	e04a                	sd	s2,0(sp)
    80003ee0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ee2:	0001e517          	auipc	a0,0x1e
    80003ee6:	ebe50513          	addi	a0,a0,-322 # 80021da0 <log>
    80003eea:	d0bfc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003eee:	0001e497          	auipc	s1,0x1e
    80003ef2:	eb248493          	addi	s1,s1,-334 # 80021da0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ef6:	4979                	li	s2,30
    80003ef8:	a029                	j	80003f02 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003efa:	85a6                	mv	a1,s1
    80003efc:	8526                	mv	a0,s1
    80003efe:	cadfd0ef          	jal	80001baa <sleep>
    if(log.committing){
    80003f02:	50dc                	lw	a5,36(s1)
    80003f04:	fbfd                	bnez	a5,80003efa <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003f06:	5098                	lw	a4,32(s1)
    80003f08:	2705                	addiw	a4,a4,1
    80003f0a:	0027179b          	slliw	a5,a4,0x2
    80003f0e:	9fb9                	addw	a5,a5,a4
    80003f10:	0017979b          	slliw	a5,a5,0x1
    80003f14:	54d4                	lw	a3,44(s1)
    80003f16:	9fb5                	addw	a5,a5,a3
    80003f18:	00f95763          	bge	s2,a5,80003f26 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003f1c:	85a6                	mv	a1,s1
    80003f1e:	8526                	mv	a0,s1
    80003f20:	c8bfd0ef          	jal	80001baa <sleep>
    80003f24:	bff9                	j	80003f02 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003f26:	0001e517          	auipc	a0,0x1e
    80003f2a:	e7a50513          	addi	a0,a0,-390 # 80021da0 <log>
    80003f2e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003f30:	d5dfc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003f34:	60e2                	ld	ra,24(sp)
    80003f36:	6442                	ld	s0,16(sp)
    80003f38:	64a2                	ld	s1,8(sp)
    80003f3a:	6902                	ld	s2,0(sp)
    80003f3c:	6105                	addi	sp,sp,32
    80003f3e:	8082                	ret

0000000080003f40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003f40:	7139                	addi	sp,sp,-64
    80003f42:	fc06                	sd	ra,56(sp)
    80003f44:	f822                	sd	s0,48(sp)
    80003f46:	f426                	sd	s1,40(sp)
    80003f48:	f04a                	sd	s2,32(sp)
    80003f4a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003f4c:	0001e497          	auipc	s1,0x1e
    80003f50:	e5448493          	addi	s1,s1,-428 # 80021da0 <log>
    80003f54:	8526                	mv	a0,s1
    80003f56:	c9ffc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003f5a:	509c                	lw	a5,32(s1)
    80003f5c:	37fd                	addiw	a5,a5,-1
    80003f5e:	0007891b          	sext.w	s2,a5
    80003f62:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003f64:	50dc                	lw	a5,36(s1)
    80003f66:	ef9d                	bnez	a5,80003fa4 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003f68:	04091763          	bnez	s2,80003fb6 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003f6c:	0001e497          	auipc	s1,0x1e
    80003f70:	e3448493          	addi	s1,s1,-460 # 80021da0 <log>
    80003f74:	4785                	li	a5,1
    80003f76:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	d13fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003f7e:	54dc                	lw	a5,44(s1)
    80003f80:	04f04b63          	bgtz	a5,80003fd6 <end_op+0x96>
    acquire(&log.lock);
    80003f84:	0001e497          	auipc	s1,0x1e
    80003f88:	e1c48493          	addi	s1,s1,-484 # 80021da0 <log>
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	c67fc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003f92:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003f96:	8526                	mv	a0,s1
    80003f98:	c5ffd0ef          	jal	80001bf6 <wakeup>
    release(&log.lock);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	ceffc0ef          	jal	80000c8c <release>
}
    80003fa2:	a025                	j	80003fca <end_op+0x8a>
    80003fa4:	ec4e                	sd	s3,24(sp)
    80003fa6:	e852                	sd	s4,16(sp)
    80003fa8:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003faa:	00003517          	auipc	a0,0x3
    80003fae:	6ee50513          	addi	a0,a0,1774 # 80007698 <etext+0x698>
    80003fb2:	fe2fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003fb6:	0001e497          	auipc	s1,0x1e
    80003fba:	dea48493          	addi	s1,s1,-534 # 80021da0 <log>
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	c37fd0ef          	jal	80001bf6 <wakeup>
  release(&log.lock);
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	cc7fc0ef          	jal	80000c8c <release>
}
    80003fca:	70e2                	ld	ra,56(sp)
    80003fcc:	7442                	ld	s0,48(sp)
    80003fce:	74a2                	ld	s1,40(sp)
    80003fd0:	7902                	ld	s2,32(sp)
    80003fd2:	6121                	addi	sp,sp,64
    80003fd4:	8082                	ret
    80003fd6:	ec4e                	sd	s3,24(sp)
    80003fd8:	e852                	sd	s4,16(sp)
    80003fda:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fdc:	0001ea97          	auipc	s5,0x1e
    80003fe0:	df4a8a93          	addi	s5,s5,-524 # 80021dd0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003fe4:	0001ea17          	auipc	s4,0x1e
    80003fe8:	dbca0a13          	addi	s4,s4,-580 # 80021da0 <log>
    80003fec:	018a2583          	lw	a1,24(s4)
    80003ff0:	012585bb          	addw	a1,a1,s2
    80003ff4:	2585                	addiw	a1,a1,1
    80003ff6:	028a2503          	lw	a0,40(s4)
    80003ffa:	f0ffe0ef          	jal	80002f08 <bread>
    80003ffe:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004000:	000aa583          	lw	a1,0(s5)
    80004004:	028a2503          	lw	a0,40(s4)
    80004008:	f01fe0ef          	jal	80002f08 <bread>
    8000400c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000400e:	40000613          	li	a2,1024
    80004012:	05850593          	addi	a1,a0,88
    80004016:	05848513          	addi	a0,s1,88
    8000401a:	d0bfc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    8000401e:	8526                	mv	a0,s1
    80004020:	fbffe0ef          	jal	80002fde <bwrite>
    brelse(from);
    80004024:	854e                	mv	a0,s3
    80004026:	febfe0ef          	jal	80003010 <brelse>
    brelse(to);
    8000402a:	8526                	mv	a0,s1
    8000402c:	fe5fe0ef          	jal	80003010 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004030:	2905                	addiw	s2,s2,1
    80004032:	0a91                	addi	s5,s5,4
    80004034:	02ca2783          	lw	a5,44(s4)
    80004038:	faf94ae3          	blt	s2,a5,80003fec <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000403c:	d11ff0ef          	jal	80003d4c <write_head>
    install_trans(0); // Now install writes to home locations
    80004040:	4501                	li	a0,0
    80004042:	d69ff0ef          	jal	80003daa <install_trans>
    log.lh.n = 0;
    80004046:	0001e797          	auipc	a5,0x1e
    8000404a:	d807a323          	sw	zero,-634(a5) # 80021dcc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000404e:	cffff0ef          	jal	80003d4c <write_head>
    80004052:	69e2                	ld	s3,24(sp)
    80004054:	6a42                	ld	s4,16(sp)
    80004056:	6aa2                	ld	s5,8(sp)
    80004058:	b735                	j	80003f84 <end_op+0x44>

000000008000405a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000405a:	1101                	addi	sp,sp,-32
    8000405c:	ec06                	sd	ra,24(sp)
    8000405e:	e822                	sd	s0,16(sp)
    80004060:	e426                	sd	s1,8(sp)
    80004062:	e04a                	sd	s2,0(sp)
    80004064:	1000                	addi	s0,sp,32
    80004066:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004068:	0001e917          	auipc	s2,0x1e
    8000406c:	d3890913          	addi	s2,s2,-712 # 80021da0 <log>
    80004070:	854a                	mv	a0,s2
    80004072:	b83fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004076:	02c92603          	lw	a2,44(s2)
    8000407a:	47f5                	li	a5,29
    8000407c:	06c7c363          	blt	a5,a2,800040e2 <log_write+0x88>
    80004080:	0001e797          	auipc	a5,0x1e
    80004084:	d3c7a783          	lw	a5,-708(a5) # 80021dbc <log+0x1c>
    80004088:	37fd                	addiw	a5,a5,-1
    8000408a:	04f65c63          	bge	a2,a5,800040e2 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000408e:	0001e797          	auipc	a5,0x1e
    80004092:	d327a783          	lw	a5,-718(a5) # 80021dc0 <log+0x20>
    80004096:	04f05c63          	blez	a5,800040ee <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000409a:	4781                	li	a5,0
    8000409c:	04c05f63          	blez	a2,800040fa <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800040a0:	44cc                	lw	a1,12(s1)
    800040a2:	0001e717          	auipc	a4,0x1e
    800040a6:	d2e70713          	addi	a4,a4,-722 # 80021dd0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800040aa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800040ac:	4314                	lw	a3,0(a4)
    800040ae:	04b68663          	beq	a3,a1,800040fa <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800040b2:	2785                	addiw	a5,a5,1
    800040b4:	0711                	addi	a4,a4,4
    800040b6:	fef61be3          	bne	a2,a5,800040ac <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800040ba:	0621                	addi	a2,a2,8
    800040bc:	060a                	slli	a2,a2,0x2
    800040be:	0001e797          	auipc	a5,0x1e
    800040c2:	ce278793          	addi	a5,a5,-798 # 80021da0 <log>
    800040c6:	97b2                	add	a5,a5,a2
    800040c8:	44d8                	lw	a4,12(s1)
    800040ca:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800040cc:	8526                	mv	a0,s1
    800040ce:	fcbfe0ef          	jal	80003098 <bpin>
    log.lh.n++;
    800040d2:	0001e717          	auipc	a4,0x1e
    800040d6:	cce70713          	addi	a4,a4,-818 # 80021da0 <log>
    800040da:	575c                	lw	a5,44(a4)
    800040dc:	2785                	addiw	a5,a5,1
    800040de:	d75c                	sw	a5,44(a4)
    800040e0:	a80d                	j	80004112 <log_write+0xb8>
    panic("too big a transaction");
    800040e2:	00003517          	auipc	a0,0x3
    800040e6:	5c650513          	addi	a0,a0,1478 # 800076a8 <etext+0x6a8>
    800040ea:	eaafc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    800040ee:	00003517          	auipc	a0,0x3
    800040f2:	5d250513          	addi	a0,a0,1490 # 800076c0 <etext+0x6c0>
    800040f6:	e9efc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    800040fa:	00878693          	addi	a3,a5,8
    800040fe:	068a                	slli	a3,a3,0x2
    80004100:	0001e717          	auipc	a4,0x1e
    80004104:	ca070713          	addi	a4,a4,-864 # 80021da0 <log>
    80004108:	9736                	add	a4,a4,a3
    8000410a:	44d4                	lw	a3,12(s1)
    8000410c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000410e:	faf60fe3          	beq	a2,a5,800040cc <log_write+0x72>
  }
  release(&log.lock);
    80004112:	0001e517          	auipc	a0,0x1e
    80004116:	c8e50513          	addi	a0,a0,-882 # 80021da0 <log>
    8000411a:	b73fc0ef          	jal	80000c8c <release>
}
    8000411e:	60e2                	ld	ra,24(sp)
    80004120:	6442                	ld	s0,16(sp)
    80004122:	64a2                	ld	s1,8(sp)
    80004124:	6902                	ld	s2,0(sp)
    80004126:	6105                	addi	sp,sp,32
    80004128:	8082                	ret

000000008000412a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000412a:	1101                	addi	sp,sp,-32
    8000412c:	ec06                	sd	ra,24(sp)
    8000412e:	e822                	sd	s0,16(sp)
    80004130:	e426                	sd	s1,8(sp)
    80004132:	e04a                	sd	s2,0(sp)
    80004134:	1000                	addi	s0,sp,32
    80004136:	84aa                	mv	s1,a0
    80004138:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000413a:	00003597          	auipc	a1,0x3
    8000413e:	5a658593          	addi	a1,a1,1446 # 800076e0 <etext+0x6e0>
    80004142:	0521                	addi	a0,a0,8
    80004144:	a31fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80004148:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000414c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004150:	0204a423          	sw	zero,40(s1)
}
    80004154:	60e2                	ld	ra,24(sp)
    80004156:	6442                	ld	s0,16(sp)
    80004158:	64a2                	ld	s1,8(sp)
    8000415a:	6902                	ld	s2,0(sp)
    8000415c:	6105                	addi	sp,sp,32
    8000415e:	8082                	ret

0000000080004160 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004160:	1101                	addi	sp,sp,-32
    80004162:	ec06                	sd	ra,24(sp)
    80004164:	e822                	sd	s0,16(sp)
    80004166:	e426                	sd	s1,8(sp)
    80004168:	e04a                	sd	s2,0(sp)
    8000416a:	1000                	addi	s0,sp,32
    8000416c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000416e:	00850913          	addi	s2,a0,8
    80004172:	854a                	mv	a0,s2
    80004174:	a81fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80004178:	409c                	lw	a5,0(s1)
    8000417a:	c799                	beqz	a5,80004188 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000417c:	85ca                	mv	a1,s2
    8000417e:	8526                	mv	a0,s1
    80004180:	a2bfd0ef          	jal	80001baa <sleep>
  while (lk->locked) {
    80004184:	409c                	lw	a5,0(s1)
    80004186:	fbfd                	bnez	a5,8000417c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004188:	4785                	li	a5,1
    8000418a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000418c:	f76fd0ef          	jal	80001902 <myproc>
    80004190:	591c                	lw	a5,48(a0)
    80004192:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004194:	854a                	mv	a0,s2
    80004196:	af7fc0ef          	jal	80000c8c <release>
}
    8000419a:	60e2                	ld	ra,24(sp)
    8000419c:	6442                	ld	s0,16(sp)
    8000419e:	64a2                	ld	s1,8(sp)
    800041a0:	6902                	ld	s2,0(sp)
    800041a2:	6105                	addi	sp,sp,32
    800041a4:	8082                	ret

00000000800041a6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800041a6:	1101                	addi	sp,sp,-32
    800041a8:	ec06                	sd	ra,24(sp)
    800041aa:	e822                	sd	s0,16(sp)
    800041ac:	e426                	sd	s1,8(sp)
    800041ae:	e04a                	sd	s2,0(sp)
    800041b0:	1000                	addi	s0,sp,32
    800041b2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800041b4:	00850913          	addi	s2,a0,8
    800041b8:	854a                	mv	a0,s2
    800041ba:	a3bfc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    800041be:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800041c2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800041c6:	8526                	mv	a0,s1
    800041c8:	a2ffd0ef          	jal	80001bf6 <wakeup>
  release(&lk->lk);
    800041cc:	854a                	mv	a0,s2
    800041ce:	abffc0ef          	jal	80000c8c <release>
}
    800041d2:	60e2                	ld	ra,24(sp)
    800041d4:	6442                	ld	s0,16(sp)
    800041d6:	64a2                	ld	s1,8(sp)
    800041d8:	6902                	ld	s2,0(sp)
    800041da:	6105                	addi	sp,sp,32
    800041dc:	8082                	ret

00000000800041de <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800041de:	7179                	addi	sp,sp,-48
    800041e0:	f406                	sd	ra,40(sp)
    800041e2:	f022                	sd	s0,32(sp)
    800041e4:	ec26                	sd	s1,24(sp)
    800041e6:	e84a                	sd	s2,16(sp)
    800041e8:	1800                	addi	s0,sp,48
    800041ea:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800041ec:	00850913          	addi	s2,a0,8
    800041f0:	854a                	mv	a0,s2
    800041f2:	a03fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800041f6:	409c                	lw	a5,0(s1)
    800041f8:	ef81                	bnez	a5,80004210 <holdingsleep+0x32>
    800041fa:	4481                	li	s1,0
  release(&lk->lk);
    800041fc:	854a                	mv	a0,s2
    800041fe:	a8ffc0ef          	jal	80000c8c <release>
  return r;
}
    80004202:	8526                	mv	a0,s1
    80004204:	70a2                	ld	ra,40(sp)
    80004206:	7402                	ld	s0,32(sp)
    80004208:	64e2                	ld	s1,24(sp)
    8000420a:	6942                	ld	s2,16(sp)
    8000420c:	6145                	addi	sp,sp,48
    8000420e:	8082                	ret
    80004210:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004212:	0284a983          	lw	s3,40(s1)
    80004216:	eecfd0ef          	jal	80001902 <myproc>
    8000421a:	5904                	lw	s1,48(a0)
    8000421c:	413484b3          	sub	s1,s1,s3
    80004220:	0014b493          	seqz	s1,s1
    80004224:	69a2                	ld	s3,8(sp)
    80004226:	bfd9                	j	800041fc <holdingsleep+0x1e>

0000000080004228 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004228:	1141                	addi	sp,sp,-16
    8000422a:	e406                	sd	ra,8(sp)
    8000422c:	e022                	sd	s0,0(sp)
    8000422e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004230:	00003597          	auipc	a1,0x3
    80004234:	4c058593          	addi	a1,a1,1216 # 800076f0 <etext+0x6f0>
    80004238:	0001e517          	auipc	a0,0x1e
    8000423c:	cb050513          	addi	a0,a0,-848 # 80021ee8 <ftable>
    80004240:	935fc0ef          	jal	80000b74 <initlock>
}
    80004244:	60a2                	ld	ra,8(sp)
    80004246:	6402                	ld	s0,0(sp)
    80004248:	0141                	addi	sp,sp,16
    8000424a:	8082                	ret

000000008000424c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000424c:	1101                	addi	sp,sp,-32
    8000424e:	ec06                	sd	ra,24(sp)
    80004250:	e822                	sd	s0,16(sp)
    80004252:	e426                	sd	s1,8(sp)
    80004254:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004256:	0001e517          	auipc	a0,0x1e
    8000425a:	c9250513          	addi	a0,a0,-878 # 80021ee8 <ftable>
    8000425e:	997fc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004262:	0001e497          	auipc	s1,0x1e
    80004266:	c9e48493          	addi	s1,s1,-866 # 80021f00 <ftable+0x18>
    8000426a:	0001f717          	auipc	a4,0x1f
    8000426e:	c3670713          	addi	a4,a4,-970 # 80022ea0 <log_lock>
    if(f->ref == 0){
    80004272:	40dc                	lw	a5,4(s1)
    80004274:	cf89                	beqz	a5,8000428e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004276:	02848493          	addi	s1,s1,40
    8000427a:	fee49ce3          	bne	s1,a4,80004272 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000427e:	0001e517          	auipc	a0,0x1e
    80004282:	c6a50513          	addi	a0,a0,-918 # 80021ee8 <ftable>
    80004286:	a07fc0ef          	jal	80000c8c <release>
  return 0;
    8000428a:	4481                	li	s1,0
    8000428c:	a809                	j	8000429e <filealloc+0x52>
      f->ref = 1;
    8000428e:	4785                	li	a5,1
    80004290:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004292:	0001e517          	auipc	a0,0x1e
    80004296:	c5650513          	addi	a0,a0,-938 # 80021ee8 <ftable>
    8000429a:	9f3fc0ef          	jal	80000c8c <release>
}
    8000429e:	8526                	mv	a0,s1
    800042a0:	60e2                	ld	ra,24(sp)
    800042a2:	6442                	ld	s0,16(sp)
    800042a4:	64a2                	ld	s1,8(sp)
    800042a6:	6105                	addi	sp,sp,32
    800042a8:	8082                	ret

00000000800042aa <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800042aa:	1101                	addi	sp,sp,-32
    800042ac:	ec06                	sd	ra,24(sp)
    800042ae:	e822                	sd	s0,16(sp)
    800042b0:	e426                	sd	s1,8(sp)
    800042b2:	1000                	addi	s0,sp,32
    800042b4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800042b6:	0001e517          	auipc	a0,0x1e
    800042ba:	c3250513          	addi	a0,a0,-974 # 80021ee8 <ftable>
    800042be:	937fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    800042c2:	40dc                	lw	a5,4(s1)
    800042c4:	02f05063          	blez	a5,800042e4 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800042c8:	2785                	addiw	a5,a5,1
    800042ca:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800042cc:	0001e517          	auipc	a0,0x1e
    800042d0:	c1c50513          	addi	a0,a0,-996 # 80021ee8 <ftable>
    800042d4:	9b9fc0ef          	jal	80000c8c <release>
  return f;
}
    800042d8:	8526                	mv	a0,s1
    800042da:	60e2                	ld	ra,24(sp)
    800042dc:	6442                	ld	s0,16(sp)
    800042de:	64a2                	ld	s1,8(sp)
    800042e0:	6105                	addi	sp,sp,32
    800042e2:	8082                	ret
    panic("filedup");
    800042e4:	00003517          	auipc	a0,0x3
    800042e8:	41450513          	addi	a0,a0,1044 # 800076f8 <etext+0x6f8>
    800042ec:	ca8fc0ef          	jal	80000794 <panic>

00000000800042f0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800042f0:	7139                	addi	sp,sp,-64
    800042f2:	fc06                	sd	ra,56(sp)
    800042f4:	f822                	sd	s0,48(sp)
    800042f6:	f426                	sd	s1,40(sp)
    800042f8:	0080                	addi	s0,sp,64
    800042fa:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800042fc:	0001e517          	auipc	a0,0x1e
    80004300:	bec50513          	addi	a0,a0,-1044 # 80021ee8 <ftable>
    80004304:	8f1fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80004308:	40dc                	lw	a5,4(s1)
    8000430a:	04f05a63          	blez	a5,8000435e <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000430e:	37fd                	addiw	a5,a5,-1
    80004310:	0007871b          	sext.w	a4,a5
    80004314:	c0dc                	sw	a5,4(s1)
    80004316:	04e04e63          	bgtz	a4,80004372 <fileclose+0x82>
    8000431a:	f04a                	sd	s2,32(sp)
    8000431c:	ec4e                	sd	s3,24(sp)
    8000431e:	e852                	sd	s4,16(sp)
    80004320:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004322:	0004a903          	lw	s2,0(s1)
    80004326:	0094ca83          	lbu	s5,9(s1)
    8000432a:	0104ba03          	ld	s4,16(s1)
    8000432e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004332:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004336:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000433a:	0001e517          	auipc	a0,0x1e
    8000433e:	bae50513          	addi	a0,a0,-1106 # 80021ee8 <ftable>
    80004342:	94bfc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80004346:	4785                	li	a5,1
    80004348:	04f90063          	beq	s2,a5,80004388 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000434c:	3979                	addiw	s2,s2,-2
    8000434e:	4785                	li	a5,1
    80004350:	0527f563          	bgeu	a5,s2,8000439a <fileclose+0xaa>
    80004354:	7902                	ld	s2,32(sp)
    80004356:	69e2                	ld	s3,24(sp)
    80004358:	6a42                	ld	s4,16(sp)
    8000435a:	6aa2                	ld	s5,8(sp)
    8000435c:	a00d                	j	8000437e <fileclose+0x8e>
    8000435e:	f04a                	sd	s2,32(sp)
    80004360:	ec4e                	sd	s3,24(sp)
    80004362:	e852                	sd	s4,16(sp)
    80004364:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004366:	00003517          	auipc	a0,0x3
    8000436a:	39a50513          	addi	a0,a0,922 # 80007700 <etext+0x700>
    8000436e:	c26fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80004372:	0001e517          	auipc	a0,0x1e
    80004376:	b7650513          	addi	a0,a0,-1162 # 80021ee8 <ftable>
    8000437a:	913fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000437e:	70e2                	ld	ra,56(sp)
    80004380:	7442                	ld	s0,48(sp)
    80004382:	74a2                	ld	s1,40(sp)
    80004384:	6121                	addi	sp,sp,64
    80004386:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004388:	85d6                	mv	a1,s5
    8000438a:	8552                	mv	a0,s4
    8000438c:	336000ef          	jal	800046c2 <pipeclose>
    80004390:	7902                	ld	s2,32(sp)
    80004392:	69e2                	ld	s3,24(sp)
    80004394:	6a42                	ld	s4,16(sp)
    80004396:	6aa2                	ld	s5,8(sp)
    80004398:	b7dd                	j	8000437e <fileclose+0x8e>
    begin_op();
    8000439a:	b3dff0ef          	jal	80003ed6 <begin_op>
    iput(ff.ip);
    8000439e:	854e                	mv	a0,s3
    800043a0:	c22ff0ef          	jal	800037c2 <iput>
    end_op();
    800043a4:	b9dff0ef          	jal	80003f40 <end_op>
    800043a8:	7902                	ld	s2,32(sp)
    800043aa:	69e2                	ld	s3,24(sp)
    800043ac:	6a42                	ld	s4,16(sp)
    800043ae:	6aa2                	ld	s5,8(sp)
    800043b0:	b7f9                	j	8000437e <fileclose+0x8e>

00000000800043b2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800043b2:	715d                	addi	sp,sp,-80
    800043b4:	e486                	sd	ra,72(sp)
    800043b6:	e0a2                	sd	s0,64(sp)
    800043b8:	fc26                	sd	s1,56(sp)
    800043ba:	f44e                	sd	s3,40(sp)
    800043bc:	0880                	addi	s0,sp,80
    800043be:	84aa                	mv	s1,a0
    800043c0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800043c2:	d40fd0ef          	jal	80001902 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800043c6:	409c                	lw	a5,0(s1)
    800043c8:	37f9                	addiw	a5,a5,-2
    800043ca:	4705                	li	a4,1
    800043cc:	04f76063          	bltu	a4,a5,8000440c <filestat+0x5a>
    800043d0:	f84a                	sd	s2,48(sp)
    800043d2:	892a                	mv	s2,a0
    ilock(f->ip);
    800043d4:	6c88                	ld	a0,24(s1)
    800043d6:	a6aff0ef          	jal	80003640 <ilock>
    stati(f->ip, &st);
    800043da:	fb840593          	addi	a1,s0,-72
    800043de:	6c88                	ld	a0,24(s1)
    800043e0:	c8aff0ef          	jal	8000386a <stati>
    iunlock(f->ip);
    800043e4:	6c88                	ld	a0,24(s1)
    800043e6:	b08ff0ef          	jal	800036ee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800043ea:	46e1                	li	a3,24
    800043ec:	fb840613          	addi	a2,s0,-72
    800043f0:	85ce                	mv	a1,s3
    800043f2:	05093503          	ld	a0,80(s2)
    800043f6:	986fd0ef          	jal	8000157c <copyout>
    800043fa:	41f5551b          	sraiw	a0,a0,0x1f
    800043fe:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004400:	60a6                	ld	ra,72(sp)
    80004402:	6406                	ld	s0,64(sp)
    80004404:	74e2                	ld	s1,56(sp)
    80004406:	79a2                	ld	s3,40(sp)
    80004408:	6161                	addi	sp,sp,80
    8000440a:	8082                	ret
  return -1;
    8000440c:	557d                	li	a0,-1
    8000440e:	bfcd                	j	80004400 <filestat+0x4e>

0000000080004410 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004410:	7179                	addi	sp,sp,-48
    80004412:	f406                	sd	ra,40(sp)
    80004414:	f022                	sd	s0,32(sp)
    80004416:	e84a                	sd	s2,16(sp)
    80004418:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000441a:	00854783          	lbu	a5,8(a0)
    8000441e:	cfd1                	beqz	a5,800044ba <fileread+0xaa>
    80004420:	ec26                	sd	s1,24(sp)
    80004422:	e44e                	sd	s3,8(sp)
    80004424:	84aa                	mv	s1,a0
    80004426:	89ae                	mv	s3,a1
    80004428:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000442a:	411c                	lw	a5,0(a0)
    8000442c:	4705                	li	a4,1
    8000442e:	04e78363          	beq	a5,a4,80004474 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004432:	470d                	li	a4,3
    80004434:	04e78763          	beq	a5,a4,80004482 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004438:	4709                	li	a4,2
    8000443a:	06e79a63          	bne	a5,a4,800044ae <fileread+0x9e>
    ilock(f->ip);
    8000443e:	6d08                	ld	a0,24(a0)
    80004440:	a00ff0ef          	jal	80003640 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004444:	874a                	mv	a4,s2
    80004446:	5094                	lw	a3,32(s1)
    80004448:	864e                	mv	a2,s3
    8000444a:	4585                	li	a1,1
    8000444c:	6c88                	ld	a0,24(s1)
    8000444e:	c46ff0ef          	jal	80003894 <readi>
    80004452:	892a                	mv	s2,a0
    80004454:	00a05563          	blez	a0,8000445e <fileread+0x4e>
      f->off += r;
    80004458:	509c                	lw	a5,32(s1)
    8000445a:	9fa9                	addw	a5,a5,a0
    8000445c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000445e:	6c88                	ld	a0,24(s1)
    80004460:	a8eff0ef          	jal	800036ee <iunlock>
    80004464:	64e2                	ld	s1,24(sp)
    80004466:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004468:	854a                	mv	a0,s2
    8000446a:	70a2                	ld	ra,40(sp)
    8000446c:	7402                	ld	s0,32(sp)
    8000446e:	6942                	ld	s2,16(sp)
    80004470:	6145                	addi	sp,sp,48
    80004472:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004474:	6908                	ld	a0,16(a0)
    80004476:	388000ef          	jal	800047fe <piperead>
    8000447a:	892a                	mv	s2,a0
    8000447c:	64e2                	ld	s1,24(sp)
    8000447e:	69a2                	ld	s3,8(sp)
    80004480:	b7e5                	j	80004468 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004482:	02451783          	lh	a5,36(a0)
    80004486:	03079693          	slli	a3,a5,0x30
    8000448a:	92c1                	srli	a3,a3,0x30
    8000448c:	4725                	li	a4,9
    8000448e:	02d76863          	bltu	a4,a3,800044be <fileread+0xae>
    80004492:	0792                	slli	a5,a5,0x4
    80004494:	0001e717          	auipc	a4,0x1e
    80004498:	9b470713          	addi	a4,a4,-1612 # 80021e48 <devsw>
    8000449c:	97ba                	add	a5,a5,a4
    8000449e:	639c                	ld	a5,0(a5)
    800044a0:	c39d                	beqz	a5,800044c6 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800044a2:	4505                	li	a0,1
    800044a4:	9782                	jalr	a5
    800044a6:	892a                	mv	s2,a0
    800044a8:	64e2                	ld	s1,24(sp)
    800044aa:	69a2                	ld	s3,8(sp)
    800044ac:	bf75                	j	80004468 <fileread+0x58>
    panic("fileread");
    800044ae:	00003517          	auipc	a0,0x3
    800044b2:	26250513          	addi	a0,a0,610 # 80007710 <etext+0x710>
    800044b6:	adefc0ef          	jal	80000794 <panic>
    return -1;
    800044ba:	597d                	li	s2,-1
    800044bc:	b775                	j	80004468 <fileread+0x58>
      return -1;
    800044be:	597d                	li	s2,-1
    800044c0:	64e2                	ld	s1,24(sp)
    800044c2:	69a2                	ld	s3,8(sp)
    800044c4:	b755                	j	80004468 <fileread+0x58>
    800044c6:	597d                	li	s2,-1
    800044c8:	64e2                	ld	s1,24(sp)
    800044ca:	69a2                	ld	s3,8(sp)
    800044cc:	bf71                	j	80004468 <fileread+0x58>

00000000800044ce <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800044ce:	00954783          	lbu	a5,9(a0)
    800044d2:	10078b63          	beqz	a5,800045e8 <filewrite+0x11a>
{
    800044d6:	715d                	addi	sp,sp,-80
    800044d8:	e486                	sd	ra,72(sp)
    800044da:	e0a2                	sd	s0,64(sp)
    800044dc:	f84a                	sd	s2,48(sp)
    800044de:	f052                	sd	s4,32(sp)
    800044e0:	e85a                	sd	s6,16(sp)
    800044e2:	0880                	addi	s0,sp,80
    800044e4:	892a                	mv	s2,a0
    800044e6:	8b2e                	mv	s6,a1
    800044e8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800044ea:	411c                	lw	a5,0(a0)
    800044ec:	4705                	li	a4,1
    800044ee:	02e78763          	beq	a5,a4,8000451c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800044f2:	470d                	li	a4,3
    800044f4:	02e78863          	beq	a5,a4,80004524 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800044f8:	4709                	li	a4,2
    800044fa:	0ce79c63          	bne	a5,a4,800045d2 <filewrite+0x104>
    800044fe:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004500:	0ac05863          	blez	a2,800045b0 <filewrite+0xe2>
    80004504:	fc26                	sd	s1,56(sp)
    80004506:	ec56                	sd	s5,24(sp)
    80004508:	e45e                	sd	s7,8(sp)
    8000450a:	e062                	sd	s8,0(sp)
    int i = 0;
    8000450c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000450e:	6b85                	lui	s7,0x1
    80004510:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004514:	6c05                	lui	s8,0x1
    80004516:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000451a:	a8b5                	j	80004596 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000451c:	6908                	ld	a0,16(a0)
    8000451e:	1fc000ef          	jal	8000471a <pipewrite>
    80004522:	a04d                	j	800045c4 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004524:	02451783          	lh	a5,36(a0)
    80004528:	03079693          	slli	a3,a5,0x30
    8000452c:	92c1                	srli	a3,a3,0x30
    8000452e:	4725                	li	a4,9
    80004530:	0ad76e63          	bltu	a4,a3,800045ec <filewrite+0x11e>
    80004534:	0792                	slli	a5,a5,0x4
    80004536:	0001e717          	auipc	a4,0x1e
    8000453a:	91270713          	addi	a4,a4,-1774 # 80021e48 <devsw>
    8000453e:	97ba                	add	a5,a5,a4
    80004540:	679c                	ld	a5,8(a5)
    80004542:	c7dd                	beqz	a5,800045f0 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004544:	4505                	li	a0,1
    80004546:	9782                	jalr	a5
    80004548:	a8b5                	j	800045c4 <filewrite+0xf6>
      if(n1 > max)
    8000454a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000454e:	989ff0ef          	jal	80003ed6 <begin_op>
      ilock(f->ip);
    80004552:	01893503          	ld	a0,24(s2)
    80004556:	8eaff0ef          	jal	80003640 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000455a:	8756                	mv	a4,s5
    8000455c:	02092683          	lw	a3,32(s2)
    80004560:	01698633          	add	a2,s3,s6
    80004564:	4585                	li	a1,1
    80004566:	01893503          	ld	a0,24(s2)
    8000456a:	c26ff0ef          	jal	80003990 <writei>
    8000456e:	84aa                	mv	s1,a0
    80004570:	00a05763          	blez	a0,8000457e <filewrite+0xb0>
        f->off += r;
    80004574:	02092783          	lw	a5,32(s2)
    80004578:	9fa9                	addw	a5,a5,a0
    8000457a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000457e:	01893503          	ld	a0,24(s2)
    80004582:	96cff0ef          	jal	800036ee <iunlock>
      end_op();
    80004586:	9bbff0ef          	jal	80003f40 <end_op>

      if(r != n1){
    8000458a:	029a9563          	bne	s5,s1,800045b4 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000458e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004592:	0149da63          	bge	s3,s4,800045a6 <filewrite+0xd8>
      int n1 = n - i;
    80004596:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000459a:	0004879b          	sext.w	a5,s1
    8000459e:	fafbd6e3          	bge	s7,a5,8000454a <filewrite+0x7c>
    800045a2:	84e2                	mv	s1,s8
    800045a4:	b75d                	j	8000454a <filewrite+0x7c>
    800045a6:	74e2                	ld	s1,56(sp)
    800045a8:	6ae2                	ld	s5,24(sp)
    800045aa:	6ba2                	ld	s7,8(sp)
    800045ac:	6c02                	ld	s8,0(sp)
    800045ae:	a039                	j	800045bc <filewrite+0xee>
    int i = 0;
    800045b0:	4981                	li	s3,0
    800045b2:	a029                	j	800045bc <filewrite+0xee>
    800045b4:	74e2                	ld	s1,56(sp)
    800045b6:	6ae2                	ld	s5,24(sp)
    800045b8:	6ba2                	ld	s7,8(sp)
    800045ba:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800045bc:	033a1c63          	bne	s4,s3,800045f4 <filewrite+0x126>
    800045c0:	8552                	mv	a0,s4
    800045c2:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800045c4:	60a6                	ld	ra,72(sp)
    800045c6:	6406                	ld	s0,64(sp)
    800045c8:	7942                	ld	s2,48(sp)
    800045ca:	7a02                	ld	s4,32(sp)
    800045cc:	6b42                	ld	s6,16(sp)
    800045ce:	6161                	addi	sp,sp,80
    800045d0:	8082                	ret
    800045d2:	fc26                	sd	s1,56(sp)
    800045d4:	f44e                	sd	s3,40(sp)
    800045d6:	ec56                	sd	s5,24(sp)
    800045d8:	e45e                	sd	s7,8(sp)
    800045da:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800045dc:	00003517          	auipc	a0,0x3
    800045e0:	14450513          	addi	a0,a0,324 # 80007720 <etext+0x720>
    800045e4:	9b0fc0ef          	jal	80000794 <panic>
    return -1;
    800045e8:	557d                	li	a0,-1
}
    800045ea:	8082                	ret
      return -1;
    800045ec:	557d                	li	a0,-1
    800045ee:	bfd9                	j	800045c4 <filewrite+0xf6>
    800045f0:	557d                	li	a0,-1
    800045f2:	bfc9                	j	800045c4 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800045f4:	557d                	li	a0,-1
    800045f6:	79a2                	ld	s3,40(sp)
    800045f8:	b7f1                	j	800045c4 <filewrite+0xf6>

00000000800045fa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045fa:	7179                	addi	sp,sp,-48
    800045fc:	f406                	sd	ra,40(sp)
    800045fe:	f022                	sd	s0,32(sp)
    80004600:	ec26                	sd	s1,24(sp)
    80004602:	e052                	sd	s4,0(sp)
    80004604:	1800                	addi	s0,sp,48
    80004606:	84aa                	mv	s1,a0
    80004608:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000460a:	0005b023          	sd	zero,0(a1)
    8000460e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004612:	c3bff0ef          	jal	8000424c <filealloc>
    80004616:	e088                	sd	a0,0(s1)
    80004618:	c549                	beqz	a0,800046a2 <pipealloc+0xa8>
    8000461a:	c33ff0ef          	jal	8000424c <filealloc>
    8000461e:	00aa3023          	sd	a0,0(s4)
    80004622:	cd25                	beqz	a0,8000469a <pipealloc+0xa0>
    80004624:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004626:	cfefc0ef          	jal	80000b24 <kalloc>
    8000462a:	892a                	mv	s2,a0
    8000462c:	c12d                	beqz	a0,8000468e <pipealloc+0x94>
    8000462e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004630:	4985                	li	s3,1
    80004632:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004636:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000463a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000463e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004642:	00003597          	auipc	a1,0x3
    80004646:	0ee58593          	addi	a1,a1,238 # 80007730 <etext+0x730>
    8000464a:	d2afc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    8000464e:	609c                	ld	a5,0(s1)
    80004650:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004654:	609c                	ld	a5,0(s1)
    80004656:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000465a:	609c                	ld	a5,0(s1)
    8000465c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004660:	609c                	ld	a5,0(s1)
    80004662:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004666:	000a3783          	ld	a5,0(s4)
    8000466a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000466e:	000a3783          	ld	a5,0(s4)
    80004672:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004676:	000a3783          	ld	a5,0(s4)
    8000467a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000467e:	000a3783          	ld	a5,0(s4)
    80004682:	0127b823          	sd	s2,16(a5)
  return 0;
    80004686:	4501                	li	a0,0
    80004688:	6942                	ld	s2,16(sp)
    8000468a:	69a2                	ld	s3,8(sp)
    8000468c:	a01d                	j	800046b2 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000468e:	6088                	ld	a0,0(s1)
    80004690:	c119                	beqz	a0,80004696 <pipealloc+0x9c>
    80004692:	6942                	ld	s2,16(sp)
    80004694:	a029                	j	8000469e <pipealloc+0xa4>
    80004696:	6942                	ld	s2,16(sp)
    80004698:	a029                	j	800046a2 <pipealloc+0xa8>
    8000469a:	6088                	ld	a0,0(s1)
    8000469c:	c10d                	beqz	a0,800046be <pipealloc+0xc4>
    fileclose(*f0);
    8000469e:	c53ff0ef          	jal	800042f0 <fileclose>
  if(*f1)
    800046a2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800046a6:	557d                	li	a0,-1
  if(*f1)
    800046a8:	c789                	beqz	a5,800046b2 <pipealloc+0xb8>
    fileclose(*f1);
    800046aa:	853e                	mv	a0,a5
    800046ac:	c45ff0ef          	jal	800042f0 <fileclose>
  return -1;
    800046b0:	557d                	li	a0,-1
}
    800046b2:	70a2                	ld	ra,40(sp)
    800046b4:	7402                	ld	s0,32(sp)
    800046b6:	64e2                	ld	s1,24(sp)
    800046b8:	6a02                	ld	s4,0(sp)
    800046ba:	6145                	addi	sp,sp,48
    800046bc:	8082                	ret
  return -1;
    800046be:	557d                	li	a0,-1
    800046c0:	bfcd                	j	800046b2 <pipealloc+0xb8>

00000000800046c2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800046c2:	1101                	addi	sp,sp,-32
    800046c4:	ec06                	sd	ra,24(sp)
    800046c6:	e822                	sd	s0,16(sp)
    800046c8:	e426                	sd	s1,8(sp)
    800046ca:	e04a                	sd	s2,0(sp)
    800046cc:	1000                	addi	s0,sp,32
    800046ce:	84aa                	mv	s1,a0
    800046d0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800046d2:	d22fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    800046d6:	02090763          	beqz	s2,80004704 <pipeclose+0x42>
    pi->writeopen = 0;
    800046da:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800046de:	21848513          	addi	a0,s1,536
    800046e2:	d14fd0ef          	jal	80001bf6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800046e6:	2204b783          	ld	a5,544(s1)
    800046ea:	e785                	bnez	a5,80004712 <pipeclose+0x50>
    release(&pi->lock);
    800046ec:	8526                	mv	a0,s1
    800046ee:	d9efc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    800046f2:	8526                	mv	a0,s1
    800046f4:	b4efc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800046f8:	60e2                	ld	ra,24(sp)
    800046fa:	6442                	ld	s0,16(sp)
    800046fc:	64a2                	ld	s1,8(sp)
    800046fe:	6902                	ld	s2,0(sp)
    80004700:	6105                	addi	sp,sp,32
    80004702:	8082                	ret
    pi->readopen = 0;
    80004704:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004708:	21c48513          	addi	a0,s1,540
    8000470c:	ceafd0ef          	jal	80001bf6 <wakeup>
    80004710:	bfd9                	j	800046e6 <pipeclose+0x24>
    release(&pi->lock);
    80004712:	8526                	mv	a0,s1
    80004714:	d78fc0ef          	jal	80000c8c <release>
}
    80004718:	b7c5                	j	800046f8 <pipeclose+0x36>

000000008000471a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000471a:	711d                	addi	sp,sp,-96
    8000471c:	ec86                	sd	ra,88(sp)
    8000471e:	e8a2                	sd	s0,80(sp)
    80004720:	e4a6                	sd	s1,72(sp)
    80004722:	e0ca                	sd	s2,64(sp)
    80004724:	fc4e                	sd	s3,56(sp)
    80004726:	f852                	sd	s4,48(sp)
    80004728:	f456                	sd	s5,40(sp)
    8000472a:	1080                	addi	s0,sp,96
    8000472c:	84aa                	mv	s1,a0
    8000472e:	8aae                	mv	s5,a1
    80004730:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004732:	9d0fd0ef          	jal	80001902 <myproc>
    80004736:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004738:	8526                	mv	a0,s1
    8000473a:	cbafc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    8000473e:	0b405a63          	blez	s4,800047f2 <pipewrite+0xd8>
    80004742:	f05a                	sd	s6,32(sp)
    80004744:	ec5e                	sd	s7,24(sp)
    80004746:	e862                	sd	s8,16(sp)
  int i = 0;
    80004748:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000474a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000474c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004750:	21c48b93          	addi	s7,s1,540
    80004754:	a81d                	j	8000478a <pipewrite+0x70>
      release(&pi->lock);
    80004756:	8526                	mv	a0,s1
    80004758:	d34fc0ef          	jal	80000c8c <release>
      return -1;
    8000475c:	597d                	li	s2,-1
    8000475e:	7b02                	ld	s6,32(sp)
    80004760:	6be2                	ld	s7,24(sp)
    80004762:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004764:	854a                	mv	a0,s2
    80004766:	60e6                	ld	ra,88(sp)
    80004768:	6446                	ld	s0,80(sp)
    8000476a:	64a6                	ld	s1,72(sp)
    8000476c:	6906                	ld	s2,64(sp)
    8000476e:	79e2                	ld	s3,56(sp)
    80004770:	7a42                	ld	s4,48(sp)
    80004772:	7aa2                	ld	s5,40(sp)
    80004774:	6125                	addi	sp,sp,96
    80004776:	8082                	ret
      wakeup(&pi->nread);
    80004778:	8562                	mv	a0,s8
    8000477a:	c7cfd0ef          	jal	80001bf6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000477e:	85a6                	mv	a1,s1
    80004780:	855e                	mv	a0,s7
    80004782:	c28fd0ef          	jal	80001baa <sleep>
  while(i < n){
    80004786:	05495b63          	bge	s2,s4,800047dc <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000478a:	2204a783          	lw	a5,544(s1)
    8000478e:	d7e1                	beqz	a5,80004756 <pipewrite+0x3c>
    80004790:	854e                	mv	a0,s3
    80004792:	e50fd0ef          	jal	80001de2 <killed>
    80004796:	f161                	bnez	a0,80004756 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004798:	2184a783          	lw	a5,536(s1)
    8000479c:	21c4a703          	lw	a4,540(s1)
    800047a0:	2007879b          	addiw	a5,a5,512
    800047a4:	fcf70ae3          	beq	a4,a5,80004778 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800047a8:	4685                	li	a3,1
    800047aa:	01590633          	add	a2,s2,s5
    800047ae:	faf40593          	addi	a1,s0,-81
    800047b2:	0509b503          	ld	a0,80(s3)
    800047b6:	e9dfc0ef          	jal	80001652 <copyin>
    800047ba:	03650e63          	beq	a0,s6,800047f6 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800047be:	21c4a783          	lw	a5,540(s1)
    800047c2:	0017871b          	addiw	a4,a5,1
    800047c6:	20e4ae23          	sw	a4,540(s1)
    800047ca:	1ff7f793          	andi	a5,a5,511
    800047ce:	97a6                	add	a5,a5,s1
    800047d0:	faf44703          	lbu	a4,-81(s0)
    800047d4:	00e78c23          	sb	a4,24(a5)
      i++;
    800047d8:	2905                	addiw	s2,s2,1
    800047da:	b775                	j	80004786 <pipewrite+0x6c>
    800047dc:	7b02                	ld	s6,32(sp)
    800047de:	6be2                	ld	s7,24(sp)
    800047e0:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800047e2:	21848513          	addi	a0,s1,536
    800047e6:	c10fd0ef          	jal	80001bf6 <wakeup>
  release(&pi->lock);
    800047ea:	8526                	mv	a0,s1
    800047ec:	ca0fc0ef          	jal	80000c8c <release>
  return i;
    800047f0:	bf95                	j	80004764 <pipewrite+0x4a>
  int i = 0;
    800047f2:	4901                	li	s2,0
    800047f4:	b7fd                	j	800047e2 <pipewrite+0xc8>
    800047f6:	7b02                	ld	s6,32(sp)
    800047f8:	6be2                	ld	s7,24(sp)
    800047fa:	6c42                	ld	s8,16(sp)
    800047fc:	b7dd                	j	800047e2 <pipewrite+0xc8>

00000000800047fe <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800047fe:	715d                	addi	sp,sp,-80
    80004800:	e486                	sd	ra,72(sp)
    80004802:	e0a2                	sd	s0,64(sp)
    80004804:	fc26                	sd	s1,56(sp)
    80004806:	f84a                	sd	s2,48(sp)
    80004808:	f44e                	sd	s3,40(sp)
    8000480a:	f052                	sd	s4,32(sp)
    8000480c:	ec56                	sd	s5,24(sp)
    8000480e:	0880                	addi	s0,sp,80
    80004810:	84aa                	mv	s1,a0
    80004812:	892e                	mv	s2,a1
    80004814:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004816:	8ecfd0ef          	jal	80001902 <myproc>
    8000481a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000481c:	8526                	mv	a0,s1
    8000481e:	bd6fc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004822:	2184a703          	lw	a4,536(s1)
    80004826:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000482a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000482e:	02f71563          	bne	a4,a5,80004858 <piperead+0x5a>
    80004832:	2244a783          	lw	a5,548(s1)
    80004836:	cb85                	beqz	a5,80004866 <piperead+0x68>
    if(killed(pr)){
    80004838:	8552                	mv	a0,s4
    8000483a:	da8fd0ef          	jal	80001de2 <killed>
    8000483e:	ed19                	bnez	a0,8000485c <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004840:	85a6                	mv	a1,s1
    80004842:	854e                	mv	a0,s3
    80004844:	b66fd0ef          	jal	80001baa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004848:	2184a703          	lw	a4,536(s1)
    8000484c:	21c4a783          	lw	a5,540(s1)
    80004850:	fef701e3          	beq	a4,a5,80004832 <piperead+0x34>
    80004854:	e85a                	sd	s6,16(sp)
    80004856:	a809                	j	80004868 <piperead+0x6a>
    80004858:	e85a                	sd	s6,16(sp)
    8000485a:	a039                	j	80004868 <piperead+0x6a>
      release(&pi->lock);
    8000485c:	8526                	mv	a0,s1
    8000485e:	c2efc0ef          	jal	80000c8c <release>
      return -1;
    80004862:	59fd                	li	s3,-1
    80004864:	a8b1                	j	800048c0 <piperead+0xc2>
    80004866:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004868:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000486a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000486c:	05505263          	blez	s5,800048b0 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004870:	2184a783          	lw	a5,536(s1)
    80004874:	21c4a703          	lw	a4,540(s1)
    80004878:	02f70c63          	beq	a4,a5,800048b0 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000487c:	0017871b          	addiw	a4,a5,1
    80004880:	20e4ac23          	sw	a4,536(s1)
    80004884:	1ff7f793          	andi	a5,a5,511
    80004888:	97a6                	add	a5,a5,s1
    8000488a:	0187c783          	lbu	a5,24(a5)
    8000488e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004892:	4685                	li	a3,1
    80004894:	fbf40613          	addi	a2,s0,-65
    80004898:	85ca                	mv	a1,s2
    8000489a:	050a3503          	ld	a0,80(s4)
    8000489e:	cdffc0ef          	jal	8000157c <copyout>
    800048a2:	01650763          	beq	a0,s6,800048b0 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800048a6:	2985                	addiw	s3,s3,1
    800048a8:	0905                	addi	s2,s2,1
    800048aa:	fd3a93e3          	bne	s5,s3,80004870 <piperead+0x72>
    800048ae:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800048b0:	21c48513          	addi	a0,s1,540
    800048b4:	b42fd0ef          	jal	80001bf6 <wakeup>
  release(&pi->lock);
    800048b8:	8526                	mv	a0,s1
    800048ba:	bd2fc0ef          	jal	80000c8c <release>
    800048be:	6b42                	ld	s6,16(sp)
  return i;
}
    800048c0:	854e                	mv	a0,s3
    800048c2:	60a6                	ld	ra,72(sp)
    800048c4:	6406                	ld	s0,64(sp)
    800048c6:	74e2                	ld	s1,56(sp)
    800048c8:	7942                	ld	s2,48(sp)
    800048ca:	79a2                	ld	s3,40(sp)
    800048cc:	7a02                	ld	s4,32(sp)
    800048ce:	6ae2                	ld	s5,24(sp)
    800048d0:	6161                	addi	sp,sp,80
    800048d2:	8082                	ret

00000000800048d4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800048d4:	1141                	addi	sp,sp,-16
    800048d6:	e422                	sd	s0,8(sp)
    800048d8:	0800                	addi	s0,sp,16
    800048da:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800048dc:	8905                	andi	a0,a0,1
    800048de:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800048e0:	8b89                	andi	a5,a5,2
    800048e2:	c399                	beqz	a5,800048e8 <flags2perm+0x14>
      perm |= PTE_W;
    800048e4:	00456513          	ori	a0,a0,4
    return perm;
}
    800048e8:	6422                	ld	s0,8(sp)
    800048ea:	0141                	addi	sp,sp,16
    800048ec:	8082                	ret

00000000800048ee <exec>:

int
exec(char *path, char **argv)
{
    800048ee:	df010113          	addi	sp,sp,-528
    800048f2:	20113423          	sd	ra,520(sp)
    800048f6:	20813023          	sd	s0,512(sp)
    800048fa:	ffa6                	sd	s1,504(sp)
    800048fc:	fbca                	sd	s2,496(sp)
    800048fe:	0c00                	addi	s0,sp,528
    80004900:	892a                	mv	s2,a0
    80004902:	dea43c23          	sd	a0,-520(s0)
    80004906:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000490a:	ff9fc0ef          	jal	80001902 <myproc>
    8000490e:	84aa                	mv	s1,a0

  begin_op();
    80004910:	dc6ff0ef          	jal	80003ed6 <begin_op>

  if((ip = namei(path)) == 0){
    80004914:	854a                	mv	a0,s2
    80004916:	c04ff0ef          	jal	80003d1a <namei>
    8000491a:	c931                	beqz	a0,8000496e <exec+0x80>
    8000491c:	f3d2                	sd	s4,480(sp)
    8000491e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004920:	d21fe0ef          	jal	80003640 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004924:	04000713          	li	a4,64
    80004928:	4681                	li	a3,0
    8000492a:	e5040613          	addi	a2,s0,-432
    8000492e:	4581                	li	a1,0
    80004930:	8552                	mv	a0,s4
    80004932:	f63fe0ef          	jal	80003894 <readi>
    80004936:	04000793          	li	a5,64
    8000493a:	00f51a63          	bne	a0,a5,8000494e <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000493e:	e5042703          	lw	a4,-432(s0)
    80004942:	464c47b7          	lui	a5,0x464c4
    80004946:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000494a:	02f70663          	beq	a4,a5,80004976 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000494e:	8552                	mv	a0,s4
    80004950:	efbfe0ef          	jal	8000384a <iunlockput>
    end_op();
    80004954:	decff0ef          	jal	80003f40 <end_op>
  }
  return -1;
    80004958:	557d                	li	a0,-1
    8000495a:	7a1e                	ld	s4,480(sp)
}
    8000495c:	20813083          	ld	ra,520(sp)
    80004960:	20013403          	ld	s0,512(sp)
    80004964:	74fe                	ld	s1,504(sp)
    80004966:	795e                	ld	s2,496(sp)
    80004968:	21010113          	addi	sp,sp,528
    8000496c:	8082                	ret
    end_op();
    8000496e:	dd2ff0ef          	jal	80003f40 <end_op>
    return -1;
    80004972:	557d                	li	a0,-1
    80004974:	b7e5                	j	8000495c <exec+0x6e>
    80004976:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004978:	8526                	mv	a0,s1
    8000497a:	830fd0ef          	jal	800019aa <proc_pagetable>
    8000497e:	8b2a                	mv	s6,a0
    80004980:	2c050b63          	beqz	a0,80004c56 <exec+0x368>
    80004984:	f7ce                	sd	s3,488(sp)
    80004986:	efd6                	sd	s5,472(sp)
    80004988:	e7de                	sd	s7,456(sp)
    8000498a:	e3e2                	sd	s8,448(sp)
    8000498c:	ff66                	sd	s9,440(sp)
    8000498e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004990:	e7042d03          	lw	s10,-400(s0)
    80004994:	e8845783          	lhu	a5,-376(s0)
    80004998:	12078963          	beqz	a5,80004aca <exec+0x1dc>
    8000499c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000499e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800049a0:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800049a2:	6c85                	lui	s9,0x1
    800049a4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800049a8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800049ac:	6a85                	lui	s5,0x1
    800049ae:	a085                	j	80004a0e <exec+0x120>
      panic("loadseg: address should exist");
    800049b0:	00003517          	auipc	a0,0x3
    800049b4:	d8850513          	addi	a0,a0,-632 # 80007738 <etext+0x738>
    800049b8:	dddfb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    800049bc:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800049be:	8726                	mv	a4,s1
    800049c0:	012c06bb          	addw	a3,s8,s2
    800049c4:	4581                	li	a1,0
    800049c6:	8552                	mv	a0,s4
    800049c8:	ecdfe0ef          	jal	80003894 <readi>
    800049cc:	2501                	sext.w	a0,a0
    800049ce:	24a49a63          	bne	s1,a0,80004c22 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800049d2:	012a893b          	addw	s2,s5,s2
    800049d6:	03397363          	bgeu	s2,s3,800049fc <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800049da:	02091593          	slli	a1,s2,0x20
    800049de:	9181                	srli	a1,a1,0x20
    800049e0:	95de                	add	a1,a1,s7
    800049e2:	855a                	mv	a0,s6
    800049e4:	e1cfc0ef          	jal	80001000 <walkaddr>
    800049e8:	862a                	mv	a2,a0
    if(pa == 0)
    800049ea:	d179                	beqz	a0,800049b0 <exec+0xc2>
    if(sz - i < PGSIZE)
    800049ec:	412984bb          	subw	s1,s3,s2
    800049f0:	0004879b          	sext.w	a5,s1
    800049f4:	fcfcf4e3          	bgeu	s9,a5,800049bc <exec+0xce>
    800049f8:	84d6                	mv	s1,s5
    800049fa:	b7c9                	j	800049bc <exec+0xce>
    sz = sz1;
    800049fc:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a00:	2d85                	addiw	s11,s11,1
    80004a02:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004a06:	e8845783          	lhu	a5,-376(s0)
    80004a0a:	08fdd063          	bge	s11,a5,80004a8a <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004a0e:	2d01                	sext.w	s10,s10
    80004a10:	03800713          	li	a4,56
    80004a14:	86ea                	mv	a3,s10
    80004a16:	e1840613          	addi	a2,s0,-488
    80004a1a:	4581                	li	a1,0
    80004a1c:	8552                	mv	a0,s4
    80004a1e:	e77fe0ef          	jal	80003894 <readi>
    80004a22:	03800793          	li	a5,56
    80004a26:	1cf51663          	bne	a0,a5,80004bf2 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004a2a:	e1842783          	lw	a5,-488(s0)
    80004a2e:	4705                	li	a4,1
    80004a30:	fce798e3          	bne	a5,a4,80004a00 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004a34:	e4043483          	ld	s1,-448(s0)
    80004a38:	e3843783          	ld	a5,-456(s0)
    80004a3c:	1af4ef63          	bltu	s1,a5,80004bfa <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004a40:	e2843783          	ld	a5,-472(s0)
    80004a44:	94be                	add	s1,s1,a5
    80004a46:	1af4ee63          	bltu	s1,a5,80004c02 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004a4a:	df043703          	ld	a4,-528(s0)
    80004a4e:	8ff9                	and	a5,a5,a4
    80004a50:	1a079d63          	bnez	a5,80004c0a <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004a54:	e1c42503          	lw	a0,-484(s0)
    80004a58:	e7dff0ef          	jal	800048d4 <flags2perm>
    80004a5c:	86aa                	mv	a3,a0
    80004a5e:	8626                	mv	a2,s1
    80004a60:	85ca                	mv	a1,s2
    80004a62:	855a                	mv	a0,s6
    80004a64:	905fc0ef          	jal	80001368 <uvmalloc>
    80004a68:	e0a43423          	sd	a0,-504(s0)
    80004a6c:	1a050363          	beqz	a0,80004c12 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004a70:	e2843b83          	ld	s7,-472(s0)
    80004a74:	e2042c03          	lw	s8,-480(s0)
    80004a78:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004a7c:	00098463          	beqz	s3,80004a84 <exec+0x196>
    80004a80:	4901                	li	s2,0
    80004a82:	bfa1                	j	800049da <exec+0xec>
    sz = sz1;
    80004a84:	e0843903          	ld	s2,-504(s0)
    80004a88:	bfa5                	j	80004a00 <exec+0x112>
    80004a8a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004a8c:	8552                	mv	a0,s4
    80004a8e:	dbdfe0ef          	jal	8000384a <iunlockput>
  end_op();
    80004a92:	caeff0ef          	jal	80003f40 <end_op>
  p = myproc();
    80004a96:	e6dfc0ef          	jal	80001902 <myproc>
    80004a9a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004a9c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004aa0:	6985                	lui	s3,0x1
    80004aa2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004aa4:	99ca                	add	s3,s3,s2
    80004aa6:	77fd                	lui	a5,0xfffff
    80004aa8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004aac:	4691                	li	a3,4
    80004aae:	6609                	lui	a2,0x2
    80004ab0:	964e                	add	a2,a2,s3
    80004ab2:	85ce                	mv	a1,s3
    80004ab4:	855a                	mv	a0,s6
    80004ab6:	8b3fc0ef          	jal	80001368 <uvmalloc>
    80004aba:	892a                	mv	s2,a0
    80004abc:	e0a43423          	sd	a0,-504(s0)
    80004ac0:	e519                	bnez	a0,80004ace <exec+0x1e0>
  if(pagetable)
    80004ac2:	e1343423          	sd	s3,-504(s0)
    80004ac6:	4a01                	li	s4,0
    80004ac8:	aab1                	j	80004c24 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004aca:	4901                	li	s2,0
    80004acc:	b7c1                	j	80004a8c <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004ace:	75f9                	lui	a1,0xffffe
    80004ad0:	95aa                	add	a1,a1,a0
    80004ad2:	855a                	mv	a0,s6
    80004ad4:	a7ffc0ef          	jal	80001552 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004ad8:	7bfd                	lui	s7,0xfffff
    80004ada:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004adc:	e0043783          	ld	a5,-512(s0)
    80004ae0:	6388                	ld	a0,0(a5)
    80004ae2:	cd39                	beqz	a0,80004b40 <exec+0x252>
    80004ae4:	e9040993          	addi	s3,s0,-368
    80004ae8:	f9040c13          	addi	s8,s0,-112
    80004aec:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004aee:	b4afc0ef          	jal	80000e38 <strlen>
    80004af2:	0015079b          	addiw	a5,a0,1
    80004af6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004afa:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004afe:	11796e63          	bltu	s2,s7,80004c1a <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004b02:	e0043d03          	ld	s10,-512(s0)
    80004b06:	000d3a03          	ld	s4,0(s10)
    80004b0a:	8552                	mv	a0,s4
    80004b0c:	b2cfc0ef          	jal	80000e38 <strlen>
    80004b10:	0015069b          	addiw	a3,a0,1
    80004b14:	8652                	mv	a2,s4
    80004b16:	85ca                	mv	a1,s2
    80004b18:	855a                	mv	a0,s6
    80004b1a:	a63fc0ef          	jal	8000157c <copyout>
    80004b1e:	10054063          	bltz	a0,80004c1e <exec+0x330>
    ustack[argc] = sp;
    80004b22:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004b26:	0485                	addi	s1,s1,1
    80004b28:	008d0793          	addi	a5,s10,8
    80004b2c:	e0f43023          	sd	a5,-512(s0)
    80004b30:	008d3503          	ld	a0,8(s10)
    80004b34:	c909                	beqz	a0,80004b46 <exec+0x258>
    if(argc >= MAXARG)
    80004b36:	09a1                	addi	s3,s3,8
    80004b38:	fb899be3          	bne	s3,s8,80004aee <exec+0x200>
  ip = 0;
    80004b3c:	4a01                	li	s4,0
    80004b3e:	a0dd                	j	80004c24 <exec+0x336>
  sp = sz;
    80004b40:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004b44:	4481                	li	s1,0
  ustack[argc] = 0;
    80004b46:	00349793          	slli	a5,s1,0x3
    80004b4a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdbf98>
    80004b4e:	97a2                	add	a5,a5,s0
    80004b50:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004b54:	00148693          	addi	a3,s1,1
    80004b58:	068e                	slli	a3,a3,0x3
    80004b5a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004b5e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004b62:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004b66:	f5796ee3          	bltu	s2,s7,80004ac2 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004b6a:	e9040613          	addi	a2,s0,-368
    80004b6e:	85ca                	mv	a1,s2
    80004b70:	855a                	mv	a0,s6
    80004b72:	a0bfc0ef          	jal	8000157c <copyout>
    80004b76:	0e054263          	bltz	a0,80004c5a <exec+0x36c>
  p->trapframe->a1 = sp;
    80004b7a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004b7e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004b82:	df843783          	ld	a5,-520(s0)
    80004b86:	0007c703          	lbu	a4,0(a5)
    80004b8a:	cf11                	beqz	a4,80004ba6 <exec+0x2b8>
    80004b8c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004b8e:	02f00693          	li	a3,47
    80004b92:	a039                	j	80004ba0 <exec+0x2b2>
      last = s+1;
    80004b94:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004b98:	0785                	addi	a5,a5,1
    80004b9a:	fff7c703          	lbu	a4,-1(a5)
    80004b9e:	c701                	beqz	a4,80004ba6 <exec+0x2b8>
    if(*s == '/')
    80004ba0:	fed71ce3          	bne	a4,a3,80004b98 <exec+0x2aa>
    80004ba4:	bfc5                	j	80004b94 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ba6:	4641                	li	a2,16
    80004ba8:	df843583          	ld	a1,-520(s0)
    80004bac:	158a8513          	addi	a0,s5,344
    80004bb0:	a56fc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004bb4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004bb8:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004bbc:	e0843783          	ld	a5,-504(s0)
    80004bc0:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004bc4:	058ab783          	ld	a5,88(s5)
    80004bc8:	e6843703          	ld	a4,-408(s0)
    80004bcc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004bce:	058ab783          	ld	a5,88(s5)
    80004bd2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004bd6:	85e6                	mv	a1,s9
    80004bd8:	e57fc0ef          	jal	80001a2e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004bdc:	0004851b          	sext.w	a0,s1
    80004be0:	79be                	ld	s3,488(sp)
    80004be2:	7a1e                	ld	s4,480(sp)
    80004be4:	6afe                	ld	s5,472(sp)
    80004be6:	6b5e                	ld	s6,464(sp)
    80004be8:	6bbe                	ld	s7,456(sp)
    80004bea:	6c1e                	ld	s8,448(sp)
    80004bec:	7cfa                	ld	s9,440(sp)
    80004bee:	7d5a                	ld	s10,432(sp)
    80004bf0:	b3b5                	j	8000495c <exec+0x6e>
    80004bf2:	e1243423          	sd	s2,-504(s0)
    80004bf6:	7dba                	ld	s11,424(sp)
    80004bf8:	a035                	j	80004c24 <exec+0x336>
    80004bfa:	e1243423          	sd	s2,-504(s0)
    80004bfe:	7dba                	ld	s11,424(sp)
    80004c00:	a015                	j	80004c24 <exec+0x336>
    80004c02:	e1243423          	sd	s2,-504(s0)
    80004c06:	7dba                	ld	s11,424(sp)
    80004c08:	a831                	j	80004c24 <exec+0x336>
    80004c0a:	e1243423          	sd	s2,-504(s0)
    80004c0e:	7dba                	ld	s11,424(sp)
    80004c10:	a811                	j	80004c24 <exec+0x336>
    80004c12:	e1243423          	sd	s2,-504(s0)
    80004c16:	7dba                	ld	s11,424(sp)
    80004c18:	a031                	j	80004c24 <exec+0x336>
  ip = 0;
    80004c1a:	4a01                	li	s4,0
    80004c1c:	a021                	j	80004c24 <exec+0x336>
    80004c1e:	4a01                	li	s4,0
  if(pagetable)
    80004c20:	a011                	j	80004c24 <exec+0x336>
    80004c22:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004c24:	e0843583          	ld	a1,-504(s0)
    80004c28:	855a                	mv	a0,s6
    80004c2a:	e05fc0ef          	jal	80001a2e <proc_freepagetable>
  return -1;
    80004c2e:	557d                	li	a0,-1
  if(ip){
    80004c30:	000a1b63          	bnez	s4,80004c46 <exec+0x358>
    80004c34:	79be                	ld	s3,488(sp)
    80004c36:	7a1e                	ld	s4,480(sp)
    80004c38:	6afe                	ld	s5,472(sp)
    80004c3a:	6b5e                	ld	s6,464(sp)
    80004c3c:	6bbe                	ld	s7,456(sp)
    80004c3e:	6c1e                	ld	s8,448(sp)
    80004c40:	7cfa                	ld	s9,440(sp)
    80004c42:	7d5a                	ld	s10,432(sp)
    80004c44:	bb21                	j	8000495c <exec+0x6e>
    80004c46:	79be                	ld	s3,488(sp)
    80004c48:	6afe                	ld	s5,472(sp)
    80004c4a:	6b5e                	ld	s6,464(sp)
    80004c4c:	6bbe                	ld	s7,456(sp)
    80004c4e:	6c1e                	ld	s8,448(sp)
    80004c50:	7cfa                	ld	s9,440(sp)
    80004c52:	7d5a                	ld	s10,432(sp)
    80004c54:	b9ed                	j	8000494e <exec+0x60>
    80004c56:	6b5e                	ld	s6,464(sp)
    80004c58:	b9dd                	j	8000494e <exec+0x60>
  sz = sz1;
    80004c5a:	e0843983          	ld	s3,-504(s0)
    80004c5e:	b595                	j	80004ac2 <exec+0x1d4>

0000000080004c60 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004c60:	7179                	addi	sp,sp,-48
    80004c62:	f406                	sd	ra,40(sp)
    80004c64:	f022                	sd	s0,32(sp)
    80004c66:	ec26                	sd	s1,24(sp)
    80004c68:	e84a                	sd	s2,16(sp)
    80004c6a:	1800                	addi	s0,sp,48
    80004c6c:	892e                	mv	s2,a1
    80004c6e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004c70:	fdc40593          	addi	a1,s0,-36
    80004c74:	f17fd0ef          	jal	80002b8a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004c78:	fdc42703          	lw	a4,-36(s0)
    80004c7c:	47bd                	li	a5,15
    80004c7e:	02e7e963          	bltu	a5,a4,80004cb0 <argfd+0x50>
    80004c82:	c81fc0ef          	jal	80001902 <myproc>
    80004c86:	fdc42703          	lw	a4,-36(s0)
    80004c8a:	01a70793          	addi	a5,a4,26
    80004c8e:	078e                	slli	a5,a5,0x3
    80004c90:	953e                	add	a0,a0,a5
    80004c92:	611c                	ld	a5,0(a0)
    80004c94:	c385                	beqz	a5,80004cb4 <argfd+0x54>
    return -1;
  if(pfd)
    80004c96:	00090463          	beqz	s2,80004c9e <argfd+0x3e>
    *pfd = fd;
    80004c9a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004c9e:	4501                	li	a0,0
  if(pf)
    80004ca0:	c091                	beqz	s1,80004ca4 <argfd+0x44>
    *pf = f;
    80004ca2:	e09c                	sd	a5,0(s1)
}
    80004ca4:	70a2                	ld	ra,40(sp)
    80004ca6:	7402                	ld	s0,32(sp)
    80004ca8:	64e2                	ld	s1,24(sp)
    80004caa:	6942                	ld	s2,16(sp)
    80004cac:	6145                	addi	sp,sp,48
    80004cae:	8082                	ret
    return -1;
    80004cb0:	557d                	li	a0,-1
    80004cb2:	bfcd                	j	80004ca4 <argfd+0x44>
    80004cb4:	557d                	li	a0,-1
    80004cb6:	b7fd                	j	80004ca4 <argfd+0x44>

0000000080004cb8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004cb8:	1101                	addi	sp,sp,-32
    80004cba:	ec06                	sd	ra,24(sp)
    80004cbc:	e822                	sd	s0,16(sp)
    80004cbe:	e426                	sd	s1,8(sp)
    80004cc0:	1000                	addi	s0,sp,32
    80004cc2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004cc4:	c3ffc0ef          	jal	80001902 <myproc>
    80004cc8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004cca:	0d050793          	addi	a5,a0,208
    80004cce:	4501                	li	a0,0
    80004cd0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004cd2:	6398                	ld	a4,0(a5)
    80004cd4:	cb19                	beqz	a4,80004cea <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004cd6:	2505                	addiw	a0,a0,1
    80004cd8:	07a1                	addi	a5,a5,8
    80004cda:	fed51ce3          	bne	a0,a3,80004cd2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004cde:	557d                	li	a0,-1
}
    80004ce0:	60e2                	ld	ra,24(sp)
    80004ce2:	6442                	ld	s0,16(sp)
    80004ce4:	64a2                	ld	s1,8(sp)
    80004ce6:	6105                	addi	sp,sp,32
    80004ce8:	8082                	ret
      p->ofile[fd] = f;
    80004cea:	01a50793          	addi	a5,a0,26
    80004cee:	078e                	slli	a5,a5,0x3
    80004cf0:	963e                	add	a2,a2,a5
    80004cf2:	e204                	sd	s1,0(a2)
      return fd;
    80004cf4:	b7f5                	j	80004ce0 <fdalloc+0x28>

0000000080004cf6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004cf6:	715d                	addi	sp,sp,-80
    80004cf8:	e486                	sd	ra,72(sp)
    80004cfa:	e0a2                	sd	s0,64(sp)
    80004cfc:	fc26                	sd	s1,56(sp)
    80004cfe:	f84a                	sd	s2,48(sp)
    80004d00:	f44e                	sd	s3,40(sp)
    80004d02:	ec56                	sd	s5,24(sp)
    80004d04:	e85a                	sd	s6,16(sp)
    80004d06:	0880                	addi	s0,sp,80
    80004d08:	8b2e                	mv	s6,a1
    80004d0a:	89b2                	mv	s3,a2
    80004d0c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004d0e:	fb040593          	addi	a1,s0,-80
    80004d12:	822ff0ef          	jal	80003d34 <nameiparent>
    80004d16:	84aa                	mv	s1,a0
    80004d18:	10050a63          	beqz	a0,80004e2c <create+0x136>
    return 0;

  ilock(dp);
    80004d1c:	925fe0ef          	jal	80003640 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004d20:	4601                	li	a2,0
    80004d22:	fb040593          	addi	a1,s0,-80
    80004d26:	8526                	mv	a0,s1
    80004d28:	d8dfe0ef          	jal	80003ab4 <dirlookup>
    80004d2c:	8aaa                	mv	s5,a0
    80004d2e:	c129                	beqz	a0,80004d70 <create+0x7a>
    iunlockput(dp);
    80004d30:	8526                	mv	a0,s1
    80004d32:	b19fe0ef          	jal	8000384a <iunlockput>
    ilock(ip);
    80004d36:	8556                	mv	a0,s5
    80004d38:	909fe0ef          	jal	80003640 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004d3c:	4789                	li	a5,2
    80004d3e:	02fb1463          	bne	s6,a5,80004d66 <create+0x70>
    80004d42:	044ad783          	lhu	a5,68(s5)
    80004d46:	37f9                	addiw	a5,a5,-2
    80004d48:	17c2                	slli	a5,a5,0x30
    80004d4a:	93c1                	srli	a5,a5,0x30
    80004d4c:	4705                	li	a4,1
    80004d4e:	00f76c63          	bltu	a4,a5,80004d66 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004d52:	8556                	mv	a0,s5
    80004d54:	60a6                	ld	ra,72(sp)
    80004d56:	6406                	ld	s0,64(sp)
    80004d58:	74e2                	ld	s1,56(sp)
    80004d5a:	7942                	ld	s2,48(sp)
    80004d5c:	79a2                	ld	s3,40(sp)
    80004d5e:	6ae2                	ld	s5,24(sp)
    80004d60:	6b42                	ld	s6,16(sp)
    80004d62:	6161                	addi	sp,sp,80
    80004d64:	8082                	ret
    iunlockput(ip);
    80004d66:	8556                	mv	a0,s5
    80004d68:	ae3fe0ef          	jal	8000384a <iunlockput>
    return 0;
    80004d6c:	4a81                	li	s5,0
    80004d6e:	b7d5                	j	80004d52 <create+0x5c>
    80004d70:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004d72:	85da                	mv	a1,s6
    80004d74:	4088                	lw	a0,0(s1)
    80004d76:	f5afe0ef          	jal	800034d0 <ialloc>
    80004d7a:	8a2a                	mv	s4,a0
    80004d7c:	cd15                	beqz	a0,80004db8 <create+0xc2>
  ilock(ip);
    80004d7e:	8c3fe0ef          	jal	80003640 <ilock>
  ip->major = major;
    80004d82:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004d86:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004d8a:	4905                	li	s2,1
    80004d8c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004d90:	8552                	mv	a0,s4
    80004d92:	ffafe0ef          	jal	8000358c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004d96:	032b0763          	beq	s6,s2,80004dc4 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d9a:	004a2603          	lw	a2,4(s4)
    80004d9e:	fb040593          	addi	a1,s0,-80
    80004da2:	8526                	mv	a0,s1
    80004da4:	eddfe0ef          	jal	80003c80 <dirlink>
    80004da8:	06054563          	bltz	a0,80004e12 <create+0x11c>
  iunlockput(dp);
    80004dac:	8526                	mv	a0,s1
    80004dae:	a9dfe0ef          	jal	8000384a <iunlockput>
  return ip;
    80004db2:	8ad2                	mv	s5,s4
    80004db4:	7a02                	ld	s4,32(sp)
    80004db6:	bf71                	j	80004d52 <create+0x5c>
    iunlockput(dp);
    80004db8:	8526                	mv	a0,s1
    80004dba:	a91fe0ef          	jal	8000384a <iunlockput>
    return 0;
    80004dbe:	8ad2                	mv	s5,s4
    80004dc0:	7a02                	ld	s4,32(sp)
    80004dc2:	bf41                	j	80004d52 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004dc4:	004a2603          	lw	a2,4(s4)
    80004dc8:	00003597          	auipc	a1,0x3
    80004dcc:	99058593          	addi	a1,a1,-1648 # 80007758 <etext+0x758>
    80004dd0:	8552                	mv	a0,s4
    80004dd2:	eaffe0ef          	jal	80003c80 <dirlink>
    80004dd6:	02054e63          	bltz	a0,80004e12 <create+0x11c>
    80004dda:	40d0                	lw	a2,4(s1)
    80004ddc:	00003597          	auipc	a1,0x3
    80004de0:	98458593          	addi	a1,a1,-1660 # 80007760 <etext+0x760>
    80004de4:	8552                	mv	a0,s4
    80004de6:	e9bfe0ef          	jal	80003c80 <dirlink>
    80004dea:	02054463          	bltz	a0,80004e12 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004dee:	004a2603          	lw	a2,4(s4)
    80004df2:	fb040593          	addi	a1,s0,-80
    80004df6:	8526                	mv	a0,s1
    80004df8:	e89fe0ef          	jal	80003c80 <dirlink>
    80004dfc:	00054b63          	bltz	a0,80004e12 <create+0x11c>
    dp->nlink++;  // for ".."
    80004e00:	04a4d783          	lhu	a5,74(s1)
    80004e04:	2785                	addiw	a5,a5,1
    80004e06:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	f80fe0ef          	jal	8000358c <iupdate>
    80004e10:	bf71                	j	80004dac <create+0xb6>
  ip->nlink = 0;
    80004e12:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004e16:	8552                	mv	a0,s4
    80004e18:	f74fe0ef          	jal	8000358c <iupdate>
  iunlockput(ip);
    80004e1c:	8552                	mv	a0,s4
    80004e1e:	a2dfe0ef          	jal	8000384a <iunlockput>
  iunlockput(dp);
    80004e22:	8526                	mv	a0,s1
    80004e24:	a27fe0ef          	jal	8000384a <iunlockput>
  return 0;
    80004e28:	7a02                	ld	s4,32(sp)
    80004e2a:	b725                	j	80004d52 <create+0x5c>
    return 0;
    80004e2c:	8aaa                	mv	s5,a0
    80004e2e:	b715                	j	80004d52 <create+0x5c>

0000000080004e30 <sys_dup>:
{
    80004e30:	7179                	addi	sp,sp,-48
    80004e32:	f406                	sd	ra,40(sp)
    80004e34:	f022                	sd	s0,32(sp)
    80004e36:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004e38:	fd840613          	addi	a2,s0,-40
    80004e3c:	4581                	li	a1,0
    80004e3e:	4501                	li	a0,0
    80004e40:	e21ff0ef          	jal	80004c60 <argfd>
    return -1;
    80004e44:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004e46:	02054363          	bltz	a0,80004e6c <sys_dup+0x3c>
    80004e4a:	ec26                	sd	s1,24(sp)
    80004e4c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004e4e:	fd843903          	ld	s2,-40(s0)
    80004e52:	854a                	mv	a0,s2
    80004e54:	e65ff0ef          	jal	80004cb8 <fdalloc>
    80004e58:	84aa                	mv	s1,a0
    return -1;
    80004e5a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004e5c:	00054d63          	bltz	a0,80004e76 <sys_dup+0x46>
  filedup(f);
    80004e60:	854a                	mv	a0,s2
    80004e62:	c48ff0ef          	jal	800042aa <filedup>
  return fd;
    80004e66:	87a6                	mv	a5,s1
    80004e68:	64e2                	ld	s1,24(sp)
    80004e6a:	6942                	ld	s2,16(sp)
}
    80004e6c:	853e                	mv	a0,a5
    80004e6e:	70a2                	ld	ra,40(sp)
    80004e70:	7402                	ld	s0,32(sp)
    80004e72:	6145                	addi	sp,sp,48
    80004e74:	8082                	ret
    80004e76:	64e2                	ld	s1,24(sp)
    80004e78:	6942                	ld	s2,16(sp)
    80004e7a:	bfcd                	j	80004e6c <sys_dup+0x3c>

0000000080004e7c <sys_read>:
{
    80004e7c:	7179                	addi	sp,sp,-48
    80004e7e:	f406                	sd	ra,40(sp)
    80004e80:	f022                	sd	s0,32(sp)
    80004e82:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e84:	fd840593          	addi	a1,s0,-40
    80004e88:	4505                	li	a0,1
    80004e8a:	d1dfd0ef          	jal	80002ba6 <argaddr>
  argint(2, &n);
    80004e8e:	fe440593          	addi	a1,s0,-28
    80004e92:	4509                	li	a0,2
    80004e94:	cf7fd0ef          	jal	80002b8a <argint>
  if(argfd(0, 0, &f) < 0)
    80004e98:	fe840613          	addi	a2,s0,-24
    80004e9c:	4581                	li	a1,0
    80004e9e:	4501                	li	a0,0
    80004ea0:	dc1ff0ef          	jal	80004c60 <argfd>
    80004ea4:	87aa                	mv	a5,a0
    return -1;
    80004ea6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ea8:	0007ca63          	bltz	a5,80004ebc <sys_read+0x40>
  return fileread(f, p, n);
    80004eac:	fe442603          	lw	a2,-28(s0)
    80004eb0:	fd843583          	ld	a1,-40(s0)
    80004eb4:	fe843503          	ld	a0,-24(s0)
    80004eb8:	d58ff0ef          	jal	80004410 <fileread>
}
    80004ebc:	70a2                	ld	ra,40(sp)
    80004ebe:	7402                	ld	s0,32(sp)
    80004ec0:	6145                	addi	sp,sp,48
    80004ec2:	8082                	ret

0000000080004ec4 <sys_write>:
{
    80004ec4:	7179                	addi	sp,sp,-48
    80004ec6:	f406                	sd	ra,40(sp)
    80004ec8:	f022                	sd	s0,32(sp)
    80004eca:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004ecc:	fd840593          	addi	a1,s0,-40
    80004ed0:	4505                	li	a0,1
    80004ed2:	cd5fd0ef          	jal	80002ba6 <argaddr>
  argint(2, &n);
    80004ed6:	fe440593          	addi	a1,s0,-28
    80004eda:	4509                	li	a0,2
    80004edc:	caffd0ef          	jal	80002b8a <argint>
  if(argfd(0, 0, &f) < 0)
    80004ee0:	fe840613          	addi	a2,s0,-24
    80004ee4:	4581                	li	a1,0
    80004ee6:	4501                	li	a0,0
    80004ee8:	d79ff0ef          	jal	80004c60 <argfd>
    80004eec:	87aa                	mv	a5,a0
    return -1;
    80004eee:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ef0:	0007ca63          	bltz	a5,80004f04 <sys_write+0x40>
  return filewrite(f, p, n);
    80004ef4:	fe442603          	lw	a2,-28(s0)
    80004ef8:	fd843583          	ld	a1,-40(s0)
    80004efc:	fe843503          	ld	a0,-24(s0)
    80004f00:	dceff0ef          	jal	800044ce <filewrite>
}
    80004f04:	70a2                	ld	ra,40(sp)
    80004f06:	7402                	ld	s0,32(sp)
    80004f08:	6145                	addi	sp,sp,48
    80004f0a:	8082                	ret

0000000080004f0c <sys_close>:
{
    80004f0c:	1101                	addi	sp,sp,-32
    80004f0e:	ec06                	sd	ra,24(sp)
    80004f10:	e822                	sd	s0,16(sp)
    80004f12:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004f14:	fe040613          	addi	a2,s0,-32
    80004f18:	fec40593          	addi	a1,s0,-20
    80004f1c:	4501                	li	a0,0
    80004f1e:	d43ff0ef          	jal	80004c60 <argfd>
    return -1;
    80004f22:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004f24:	02054063          	bltz	a0,80004f44 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004f28:	9dbfc0ef          	jal	80001902 <myproc>
    80004f2c:	fec42783          	lw	a5,-20(s0)
    80004f30:	07e9                	addi	a5,a5,26
    80004f32:	078e                	slli	a5,a5,0x3
    80004f34:	953e                	add	a0,a0,a5
    80004f36:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004f3a:	fe043503          	ld	a0,-32(s0)
    80004f3e:	bb2ff0ef          	jal	800042f0 <fileclose>
  return 0;
    80004f42:	4781                	li	a5,0
}
    80004f44:	853e                	mv	a0,a5
    80004f46:	60e2                	ld	ra,24(sp)
    80004f48:	6442                	ld	s0,16(sp)
    80004f4a:	6105                	addi	sp,sp,32
    80004f4c:	8082                	ret

0000000080004f4e <sys_fstat>:
{
    80004f4e:	1101                	addi	sp,sp,-32
    80004f50:	ec06                	sd	ra,24(sp)
    80004f52:	e822                	sd	s0,16(sp)
    80004f54:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004f56:	fe040593          	addi	a1,s0,-32
    80004f5a:	4505                	li	a0,1
    80004f5c:	c4bfd0ef          	jal	80002ba6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004f60:	fe840613          	addi	a2,s0,-24
    80004f64:	4581                	li	a1,0
    80004f66:	4501                	li	a0,0
    80004f68:	cf9ff0ef          	jal	80004c60 <argfd>
    80004f6c:	87aa                	mv	a5,a0
    return -1;
    80004f6e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004f70:	0007c863          	bltz	a5,80004f80 <sys_fstat+0x32>
  return filestat(f, st);
    80004f74:	fe043583          	ld	a1,-32(s0)
    80004f78:	fe843503          	ld	a0,-24(s0)
    80004f7c:	c36ff0ef          	jal	800043b2 <filestat>
}
    80004f80:	60e2                	ld	ra,24(sp)
    80004f82:	6442                	ld	s0,16(sp)
    80004f84:	6105                	addi	sp,sp,32
    80004f86:	8082                	ret

0000000080004f88 <sys_link>:
{
    80004f88:	7169                	addi	sp,sp,-304
    80004f8a:	f606                	sd	ra,296(sp)
    80004f8c:	f222                	sd	s0,288(sp)
    80004f8e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f90:	08000613          	li	a2,128
    80004f94:	ed040593          	addi	a1,s0,-304
    80004f98:	4501                	li	a0,0
    80004f9a:	c29fd0ef          	jal	80002bc2 <argstr>
    return -1;
    80004f9e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004fa0:	0c054e63          	bltz	a0,8000507c <sys_link+0xf4>
    80004fa4:	08000613          	li	a2,128
    80004fa8:	f5040593          	addi	a1,s0,-176
    80004fac:	4505                	li	a0,1
    80004fae:	c15fd0ef          	jal	80002bc2 <argstr>
    return -1;
    80004fb2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004fb4:	0c054463          	bltz	a0,8000507c <sys_link+0xf4>
    80004fb8:	ee26                	sd	s1,280(sp)
  begin_op();
    80004fba:	f1dfe0ef          	jal	80003ed6 <begin_op>
  if((ip = namei(old)) == 0){
    80004fbe:	ed040513          	addi	a0,s0,-304
    80004fc2:	d59fe0ef          	jal	80003d1a <namei>
    80004fc6:	84aa                	mv	s1,a0
    80004fc8:	c53d                	beqz	a0,80005036 <sys_link+0xae>
  ilock(ip);
    80004fca:	e76fe0ef          	jal	80003640 <ilock>
  if(ip->type == T_DIR){
    80004fce:	04449703          	lh	a4,68(s1)
    80004fd2:	4785                	li	a5,1
    80004fd4:	06f70663          	beq	a4,a5,80005040 <sys_link+0xb8>
    80004fd8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004fda:	04a4d783          	lhu	a5,74(s1)
    80004fde:	2785                	addiw	a5,a5,1
    80004fe0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004fe4:	8526                	mv	a0,s1
    80004fe6:	da6fe0ef          	jal	8000358c <iupdate>
  iunlock(ip);
    80004fea:	8526                	mv	a0,s1
    80004fec:	f02fe0ef          	jal	800036ee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ff0:	fd040593          	addi	a1,s0,-48
    80004ff4:	f5040513          	addi	a0,s0,-176
    80004ff8:	d3dfe0ef          	jal	80003d34 <nameiparent>
    80004ffc:	892a                	mv	s2,a0
    80004ffe:	cd21                	beqz	a0,80005056 <sys_link+0xce>
  ilock(dp);
    80005000:	e40fe0ef          	jal	80003640 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005004:	00092703          	lw	a4,0(s2)
    80005008:	409c                	lw	a5,0(s1)
    8000500a:	04f71363          	bne	a4,a5,80005050 <sys_link+0xc8>
    8000500e:	40d0                	lw	a2,4(s1)
    80005010:	fd040593          	addi	a1,s0,-48
    80005014:	854a                	mv	a0,s2
    80005016:	c6bfe0ef          	jal	80003c80 <dirlink>
    8000501a:	02054b63          	bltz	a0,80005050 <sys_link+0xc8>
  iunlockput(dp);
    8000501e:	854a                	mv	a0,s2
    80005020:	82bfe0ef          	jal	8000384a <iunlockput>
  iput(ip);
    80005024:	8526                	mv	a0,s1
    80005026:	f9cfe0ef          	jal	800037c2 <iput>
  end_op();
    8000502a:	f17fe0ef          	jal	80003f40 <end_op>
  return 0;
    8000502e:	4781                	li	a5,0
    80005030:	64f2                	ld	s1,280(sp)
    80005032:	6952                	ld	s2,272(sp)
    80005034:	a0a1                	j	8000507c <sys_link+0xf4>
    end_op();
    80005036:	f0bfe0ef          	jal	80003f40 <end_op>
    return -1;
    8000503a:	57fd                	li	a5,-1
    8000503c:	64f2                	ld	s1,280(sp)
    8000503e:	a83d                	j	8000507c <sys_link+0xf4>
    iunlockput(ip);
    80005040:	8526                	mv	a0,s1
    80005042:	809fe0ef          	jal	8000384a <iunlockput>
    end_op();
    80005046:	efbfe0ef          	jal	80003f40 <end_op>
    return -1;
    8000504a:	57fd                	li	a5,-1
    8000504c:	64f2                	ld	s1,280(sp)
    8000504e:	a03d                	j	8000507c <sys_link+0xf4>
    iunlockput(dp);
    80005050:	854a                	mv	a0,s2
    80005052:	ff8fe0ef          	jal	8000384a <iunlockput>
  ilock(ip);
    80005056:	8526                	mv	a0,s1
    80005058:	de8fe0ef          	jal	80003640 <ilock>
  ip->nlink--;
    8000505c:	04a4d783          	lhu	a5,74(s1)
    80005060:	37fd                	addiw	a5,a5,-1
    80005062:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005066:	8526                	mv	a0,s1
    80005068:	d24fe0ef          	jal	8000358c <iupdate>
  iunlockput(ip);
    8000506c:	8526                	mv	a0,s1
    8000506e:	fdcfe0ef          	jal	8000384a <iunlockput>
  end_op();
    80005072:	ecffe0ef          	jal	80003f40 <end_op>
  return -1;
    80005076:	57fd                	li	a5,-1
    80005078:	64f2                	ld	s1,280(sp)
    8000507a:	6952                	ld	s2,272(sp)
}
    8000507c:	853e                	mv	a0,a5
    8000507e:	70b2                	ld	ra,296(sp)
    80005080:	7412                	ld	s0,288(sp)
    80005082:	6155                	addi	sp,sp,304
    80005084:	8082                	ret

0000000080005086 <sys_unlink>:
{
    80005086:	7151                	addi	sp,sp,-240
    80005088:	f586                	sd	ra,232(sp)
    8000508a:	f1a2                	sd	s0,224(sp)
    8000508c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000508e:	08000613          	li	a2,128
    80005092:	f3040593          	addi	a1,s0,-208
    80005096:	4501                	li	a0,0
    80005098:	b2bfd0ef          	jal	80002bc2 <argstr>
    8000509c:	16054063          	bltz	a0,800051fc <sys_unlink+0x176>
    800050a0:	eda6                	sd	s1,216(sp)
  begin_op();
    800050a2:	e35fe0ef          	jal	80003ed6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800050a6:	fb040593          	addi	a1,s0,-80
    800050aa:	f3040513          	addi	a0,s0,-208
    800050ae:	c87fe0ef          	jal	80003d34 <nameiparent>
    800050b2:	84aa                	mv	s1,a0
    800050b4:	c945                	beqz	a0,80005164 <sys_unlink+0xde>
  ilock(dp);
    800050b6:	d8afe0ef          	jal	80003640 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800050ba:	00002597          	auipc	a1,0x2
    800050be:	69e58593          	addi	a1,a1,1694 # 80007758 <etext+0x758>
    800050c2:	fb040513          	addi	a0,s0,-80
    800050c6:	9d9fe0ef          	jal	80003a9e <namecmp>
    800050ca:	10050e63          	beqz	a0,800051e6 <sys_unlink+0x160>
    800050ce:	00002597          	auipc	a1,0x2
    800050d2:	69258593          	addi	a1,a1,1682 # 80007760 <etext+0x760>
    800050d6:	fb040513          	addi	a0,s0,-80
    800050da:	9c5fe0ef          	jal	80003a9e <namecmp>
    800050de:	10050463          	beqz	a0,800051e6 <sys_unlink+0x160>
    800050e2:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800050e4:	f2c40613          	addi	a2,s0,-212
    800050e8:	fb040593          	addi	a1,s0,-80
    800050ec:	8526                	mv	a0,s1
    800050ee:	9c7fe0ef          	jal	80003ab4 <dirlookup>
    800050f2:	892a                	mv	s2,a0
    800050f4:	0e050863          	beqz	a0,800051e4 <sys_unlink+0x15e>
  ilock(ip);
    800050f8:	d48fe0ef          	jal	80003640 <ilock>
  if(ip->nlink < 1)
    800050fc:	04a91783          	lh	a5,74(s2)
    80005100:	06f05763          	blez	a5,8000516e <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005104:	04491703          	lh	a4,68(s2)
    80005108:	4785                	li	a5,1
    8000510a:	06f70963          	beq	a4,a5,8000517c <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000510e:	4641                	li	a2,16
    80005110:	4581                	li	a1,0
    80005112:	fc040513          	addi	a0,s0,-64
    80005116:	bb3fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000511a:	4741                	li	a4,16
    8000511c:	f2c42683          	lw	a3,-212(s0)
    80005120:	fc040613          	addi	a2,s0,-64
    80005124:	4581                	li	a1,0
    80005126:	8526                	mv	a0,s1
    80005128:	869fe0ef          	jal	80003990 <writei>
    8000512c:	47c1                	li	a5,16
    8000512e:	08f51b63          	bne	a0,a5,800051c4 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80005132:	04491703          	lh	a4,68(s2)
    80005136:	4785                	li	a5,1
    80005138:	08f70d63          	beq	a4,a5,800051d2 <sys_unlink+0x14c>
  iunlockput(dp);
    8000513c:	8526                	mv	a0,s1
    8000513e:	f0cfe0ef          	jal	8000384a <iunlockput>
  ip->nlink--;
    80005142:	04a95783          	lhu	a5,74(s2)
    80005146:	37fd                	addiw	a5,a5,-1
    80005148:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000514c:	854a                	mv	a0,s2
    8000514e:	c3efe0ef          	jal	8000358c <iupdate>
  iunlockput(ip);
    80005152:	854a                	mv	a0,s2
    80005154:	ef6fe0ef          	jal	8000384a <iunlockput>
  end_op();
    80005158:	de9fe0ef          	jal	80003f40 <end_op>
  return 0;
    8000515c:	4501                	li	a0,0
    8000515e:	64ee                	ld	s1,216(sp)
    80005160:	694e                	ld	s2,208(sp)
    80005162:	a849                	j	800051f4 <sys_unlink+0x16e>
    end_op();
    80005164:	dddfe0ef          	jal	80003f40 <end_op>
    return -1;
    80005168:	557d                	li	a0,-1
    8000516a:	64ee                	ld	s1,216(sp)
    8000516c:	a061                	j	800051f4 <sys_unlink+0x16e>
    8000516e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005170:	00002517          	auipc	a0,0x2
    80005174:	5f850513          	addi	a0,a0,1528 # 80007768 <etext+0x768>
    80005178:	e1cfb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000517c:	04c92703          	lw	a4,76(s2)
    80005180:	02000793          	li	a5,32
    80005184:	f8e7f5e3          	bgeu	a5,a4,8000510e <sys_unlink+0x88>
    80005188:	e5ce                	sd	s3,200(sp)
    8000518a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000518e:	4741                	li	a4,16
    80005190:	86ce                	mv	a3,s3
    80005192:	f1840613          	addi	a2,s0,-232
    80005196:	4581                	li	a1,0
    80005198:	854a                	mv	a0,s2
    8000519a:	efafe0ef          	jal	80003894 <readi>
    8000519e:	47c1                	li	a5,16
    800051a0:	00f51c63          	bne	a0,a5,800051b8 <sys_unlink+0x132>
    if(de.inum != 0)
    800051a4:	f1845783          	lhu	a5,-232(s0)
    800051a8:	efa1                	bnez	a5,80005200 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800051aa:	29c1                	addiw	s3,s3,16
    800051ac:	04c92783          	lw	a5,76(s2)
    800051b0:	fcf9efe3          	bltu	s3,a5,8000518e <sys_unlink+0x108>
    800051b4:	69ae                	ld	s3,200(sp)
    800051b6:	bfa1                	j	8000510e <sys_unlink+0x88>
      panic("isdirempty: readi");
    800051b8:	00002517          	auipc	a0,0x2
    800051bc:	5c850513          	addi	a0,a0,1480 # 80007780 <etext+0x780>
    800051c0:	dd4fb0ef          	jal	80000794 <panic>
    800051c4:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800051c6:	00002517          	auipc	a0,0x2
    800051ca:	5d250513          	addi	a0,a0,1490 # 80007798 <etext+0x798>
    800051ce:	dc6fb0ef          	jal	80000794 <panic>
    dp->nlink--;
    800051d2:	04a4d783          	lhu	a5,74(s1)
    800051d6:	37fd                	addiw	a5,a5,-1
    800051d8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800051dc:	8526                	mv	a0,s1
    800051de:	baefe0ef          	jal	8000358c <iupdate>
    800051e2:	bfa9                	j	8000513c <sys_unlink+0xb6>
    800051e4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800051e6:	8526                	mv	a0,s1
    800051e8:	e62fe0ef          	jal	8000384a <iunlockput>
  end_op();
    800051ec:	d55fe0ef          	jal	80003f40 <end_op>
  return -1;
    800051f0:	557d                	li	a0,-1
    800051f2:	64ee                	ld	s1,216(sp)
}
    800051f4:	70ae                	ld	ra,232(sp)
    800051f6:	740e                	ld	s0,224(sp)
    800051f8:	616d                	addi	sp,sp,240
    800051fa:	8082                	ret
    return -1;
    800051fc:	557d                	li	a0,-1
    800051fe:	bfdd                	j	800051f4 <sys_unlink+0x16e>
    iunlockput(ip);
    80005200:	854a                	mv	a0,s2
    80005202:	e48fe0ef          	jal	8000384a <iunlockput>
    goto bad;
    80005206:	694e                	ld	s2,208(sp)
    80005208:	69ae                	ld	s3,200(sp)
    8000520a:	bff1                	j	800051e6 <sys_unlink+0x160>

000000008000520c <sys_open>:

uint64
sys_open(void)
{
    8000520c:	7131                	addi	sp,sp,-192
    8000520e:	fd06                	sd	ra,184(sp)
    80005210:	f922                	sd	s0,176(sp)
    80005212:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005214:	f4c40593          	addi	a1,s0,-180
    80005218:	4505                	li	a0,1
    8000521a:	971fd0ef          	jal	80002b8a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000521e:	08000613          	li	a2,128
    80005222:	f5040593          	addi	a1,s0,-176
    80005226:	4501                	li	a0,0
    80005228:	99bfd0ef          	jal	80002bc2 <argstr>
    8000522c:	87aa                	mv	a5,a0
    return -1;
    8000522e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005230:	0a07c263          	bltz	a5,800052d4 <sys_open+0xc8>
    80005234:	f526                	sd	s1,168(sp)

  begin_op();
    80005236:	ca1fe0ef          	jal	80003ed6 <begin_op>

  if(omode & O_CREATE){
    8000523a:	f4c42783          	lw	a5,-180(s0)
    8000523e:	2007f793          	andi	a5,a5,512
    80005242:	c3d5                	beqz	a5,800052e6 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005244:	4681                	li	a3,0
    80005246:	4601                	li	a2,0
    80005248:	4589                	li	a1,2
    8000524a:	f5040513          	addi	a0,s0,-176
    8000524e:	aa9ff0ef          	jal	80004cf6 <create>
    80005252:	84aa                	mv	s1,a0
    if(ip == 0){
    80005254:	c541                	beqz	a0,800052dc <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005256:	04449703          	lh	a4,68(s1)
    8000525a:	478d                	li	a5,3
    8000525c:	00f71763          	bne	a4,a5,8000526a <sys_open+0x5e>
    80005260:	0464d703          	lhu	a4,70(s1)
    80005264:	47a5                	li	a5,9
    80005266:	0ae7ed63          	bltu	a5,a4,80005320 <sys_open+0x114>
    8000526a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000526c:	fe1fe0ef          	jal	8000424c <filealloc>
    80005270:	892a                	mv	s2,a0
    80005272:	c179                	beqz	a0,80005338 <sys_open+0x12c>
    80005274:	ed4e                	sd	s3,152(sp)
    80005276:	a43ff0ef          	jal	80004cb8 <fdalloc>
    8000527a:	89aa                	mv	s3,a0
    8000527c:	0a054a63          	bltz	a0,80005330 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005280:	04449703          	lh	a4,68(s1)
    80005284:	478d                	li	a5,3
    80005286:	0cf70263          	beq	a4,a5,8000534a <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000528a:	4789                	li	a5,2
    8000528c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005290:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005294:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005298:	f4c42783          	lw	a5,-180(s0)
    8000529c:	0017c713          	xori	a4,a5,1
    800052a0:	8b05                	andi	a4,a4,1
    800052a2:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800052a6:	0037f713          	andi	a4,a5,3
    800052aa:	00e03733          	snez	a4,a4
    800052ae:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800052b2:	4007f793          	andi	a5,a5,1024
    800052b6:	c791                	beqz	a5,800052c2 <sys_open+0xb6>
    800052b8:	04449703          	lh	a4,68(s1)
    800052bc:	4789                	li	a5,2
    800052be:	08f70d63          	beq	a4,a5,80005358 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800052c2:	8526                	mv	a0,s1
    800052c4:	c2afe0ef          	jal	800036ee <iunlock>
  end_op();
    800052c8:	c79fe0ef          	jal	80003f40 <end_op>

  return fd;
    800052cc:	854e                	mv	a0,s3
    800052ce:	74aa                	ld	s1,168(sp)
    800052d0:	790a                	ld	s2,160(sp)
    800052d2:	69ea                	ld	s3,152(sp)
}
    800052d4:	70ea                	ld	ra,184(sp)
    800052d6:	744a                	ld	s0,176(sp)
    800052d8:	6129                	addi	sp,sp,192
    800052da:	8082                	ret
      end_op();
    800052dc:	c65fe0ef          	jal	80003f40 <end_op>
      return -1;
    800052e0:	557d                	li	a0,-1
    800052e2:	74aa                	ld	s1,168(sp)
    800052e4:	bfc5                	j	800052d4 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800052e6:	f5040513          	addi	a0,s0,-176
    800052ea:	a31fe0ef          	jal	80003d1a <namei>
    800052ee:	84aa                	mv	s1,a0
    800052f0:	c11d                	beqz	a0,80005316 <sys_open+0x10a>
    ilock(ip);
    800052f2:	b4efe0ef          	jal	80003640 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800052f6:	04449703          	lh	a4,68(s1)
    800052fa:	4785                	li	a5,1
    800052fc:	f4f71de3          	bne	a4,a5,80005256 <sys_open+0x4a>
    80005300:	f4c42783          	lw	a5,-180(s0)
    80005304:	d3bd                	beqz	a5,8000526a <sys_open+0x5e>
      iunlockput(ip);
    80005306:	8526                	mv	a0,s1
    80005308:	d42fe0ef          	jal	8000384a <iunlockput>
      end_op();
    8000530c:	c35fe0ef          	jal	80003f40 <end_op>
      return -1;
    80005310:	557d                	li	a0,-1
    80005312:	74aa                	ld	s1,168(sp)
    80005314:	b7c1                	j	800052d4 <sys_open+0xc8>
      end_op();
    80005316:	c2bfe0ef          	jal	80003f40 <end_op>
      return -1;
    8000531a:	557d                	li	a0,-1
    8000531c:	74aa                	ld	s1,168(sp)
    8000531e:	bf5d                	j	800052d4 <sys_open+0xc8>
    iunlockput(ip);
    80005320:	8526                	mv	a0,s1
    80005322:	d28fe0ef          	jal	8000384a <iunlockput>
    end_op();
    80005326:	c1bfe0ef          	jal	80003f40 <end_op>
    return -1;
    8000532a:	557d                	li	a0,-1
    8000532c:	74aa                	ld	s1,168(sp)
    8000532e:	b75d                	j	800052d4 <sys_open+0xc8>
      fileclose(f);
    80005330:	854a                	mv	a0,s2
    80005332:	fbffe0ef          	jal	800042f0 <fileclose>
    80005336:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005338:	8526                	mv	a0,s1
    8000533a:	d10fe0ef          	jal	8000384a <iunlockput>
    end_op();
    8000533e:	c03fe0ef          	jal	80003f40 <end_op>
    return -1;
    80005342:	557d                	li	a0,-1
    80005344:	74aa                	ld	s1,168(sp)
    80005346:	790a                	ld	s2,160(sp)
    80005348:	b771                	j	800052d4 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000534a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000534e:	04649783          	lh	a5,70(s1)
    80005352:	02f91223          	sh	a5,36(s2)
    80005356:	bf3d                	j	80005294 <sys_open+0x88>
    itrunc(ip);
    80005358:	8526                	mv	a0,s1
    8000535a:	bd4fe0ef          	jal	8000372e <itrunc>
    8000535e:	b795                	j	800052c2 <sys_open+0xb6>

0000000080005360 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005360:	7175                	addi	sp,sp,-144
    80005362:	e506                	sd	ra,136(sp)
    80005364:	e122                	sd	s0,128(sp)
    80005366:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005368:	b6ffe0ef          	jal	80003ed6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000536c:	08000613          	li	a2,128
    80005370:	f7040593          	addi	a1,s0,-144
    80005374:	4501                	li	a0,0
    80005376:	84dfd0ef          	jal	80002bc2 <argstr>
    8000537a:	02054363          	bltz	a0,800053a0 <sys_mkdir+0x40>
    8000537e:	4681                	li	a3,0
    80005380:	4601                	li	a2,0
    80005382:	4585                	li	a1,1
    80005384:	f7040513          	addi	a0,s0,-144
    80005388:	96fff0ef          	jal	80004cf6 <create>
    8000538c:	c911                	beqz	a0,800053a0 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000538e:	cbcfe0ef          	jal	8000384a <iunlockput>
  end_op();
    80005392:	baffe0ef          	jal	80003f40 <end_op>
  return 0;
    80005396:	4501                	li	a0,0
}
    80005398:	60aa                	ld	ra,136(sp)
    8000539a:	640a                	ld	s0,128(sp)
    8000539c:	6149                	addi	sp,sp,144
    8000539e:	8082                	ret
    end_op();
    800053a0:	ba1fe0ef          	jal	80003f40 <end_op>
    return -1;
    800053a4:	557d                	li	a0,-1
    800053a6:	bfcd                	j	80005398 <sys_mkdir+0x38>

00000000800053a8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800053a8:	7135                	addi	sp,sp,-160
    800053aa:	ed06                	sd	ra,152(sp)
    800053ac:	e922                	sd	s0,144(sp)
    800053ae:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800053b0:	b27fe0ef          	jal	80003ed6 <begin_op>
  argint(1, &major);
    800053b4:	f6c40593          	addi	a1,s0,-148
    800053b8:	4505                	li	a0,1
    800053ba:	fd0fd0ef          	jal	80002b8a <argint>
  argint(2, &minor);
    800053be:	f6840593          	addi	a1,s0,-152
    800053c2:	4509                	li	a0,2
    800053c4:	fc6fd0ef          	jal	80002b8a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800053c8:	08000613          	li	a2,128
    800053cc:	f7040593          	addi	a1,s0,-144
    800053d0:	4501                	li	a0,0
    800053d2:	ff0fd0ef          	jal	80002bc2 <argstr>
    800053d6:	02054563          	bltz	a0,80005400 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800053da:	f6841683          	lh	a3,-152(s0)
    800053de:	f6c41603          	lh	a2,-148(s0)
    800053e2:	458d                	li	a1,3
    800053e4:	f7040513          	addi	a0,s0,-144
    800053e8:	90fff0ef          	jal	80004cf6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800053ec:	c911                	beqz	a0,80005400 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800053ee:	c5cfe0ef          	jal	8000384a <iunlockput>
  end_op();
    800053f2:	b4ffe0ef          	jal	80003f40 <end_op>
  return 0;
    800053f6:	4501                	li	a0,0
}
    800053f8:	60ea                	ld	ra,152(sp)
    800053fa:	644a                	ld	s0,144(sp)
    800053fc:	610d                	addi	sp,sp,160
    800053fe:	8082                	ret
    end_op();
    80005400:	b41fe0ef          	jal	80003f40 <end_op>
    return -1;
    80005404:	557d                	li	a0,-1
    80005406:	bfcd                	j	800053f8 <sys_mknod+0x50>

0000000080005408 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005408:	7135                	addi	sp,sp,-160
    8000540a:	ed06                	sd	ra,152(sp)
    8000540c:	e922                	sd	s0,144(sp)
    8000540e:	e14a                	sd	s2,128(sp)
    80005410:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005412:	cf0fc0ef          	jal	80001902 <myproc>
    80005416:	892a                	mv	s2,a0
  
  begin_op();
    80005418:	abffe0ef          	jal	80003ed6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000541c:	08000613          	li	a2,128
    80005420:	f6040593          	addi	a1,s0,-160
    80005424:	4501                	li	a0,0
    80005426:	f9cfd0ef          	jal	80002bc2 <argstr>
    8000542a:	04054363          	bltz	a0,80005470 <sys_chdir+0x68>
    8000542e:	e526                	sd	s1,136(sp)
    80005430:	f6040513          	addi	a0,s0,-160
    80005434:	8e7fe0ef          	jal	80003d1a <namei>
    80005438:	84aa                	mv	s1,a0
    8000543a:	c915                	beqz	a0,8000546e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000543c:	a04fe0ef          	jal	80003640 <ilock>
  if(ip->type != T_DIR){
    80005440:	04449703          	lh	a4,68(s1)
    80005444:	4785                	li	a5,1
    80005446:	02f71963          	bne	a4,a5,80005478 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000544a:	8526                	mv	a0,s1
    8000544c:	aa2fe0ef          	jal	800036ee <iunlock>
  iput(p->cwd);
    80005450:	15093503          	ld	a0,336(s2)
    80005454:	b6efe0ef          	jal	800037c2 <iput>
  end_op();
    80005458:	ae9fe0ef          	jal	80003f40 <end_op>
  p->cwd = ip;
    8000545c:	14993823          	sd	s1,336(s2)
  return 0;
    80005460:	4501                	li	a0,0
    80005462:	64aa                	ld	s1,136(sp)
}
    80005464:	60ea                	ld	ra,152(sp)
    80005466:	644a                	ld	s0,144(sp)
    80005468:	690a                	ld	s2,128(sp)
    8000546a:	610d                	addi	sp,sp,160
    8000546c:	8082                	ret
    8000546e:	64aa                	ld	s1,136(sp)
    end_op();
    80005470:	ad1fe0ef          	jal	80003f40 <end_op>
    return -1;
    80005474:	557d                	li	a0,-1
    80005476:	b7fd                	j	80005464 <sys_chdir+0x5c>
    iunlockput(ip);
    80005478:	8526                	mv	a0,s1
    8000547a:	bd0fe0ef          	jal	8000384a <iunlockput>
    end_op();
    8000547e:	ac3fe0ef          	jal	80003f40 <end_op>
    return -1;
    80005482:	557d                	li	a0,-1
    80005484:	64aa                	ld	s1,136(sp)
    80005486:	bff9                	j	80005464 <sys_chdir+0x5c>

0000000080005488 <sys_exec>:

uint64
sys_exec(void)
{
    80005488:	7121                	addi	sp,sp,-448
    8000548a:	ff06                	sd	ra,440(sp)
    8000548c:	fb22                	sd	s0,432(sp)
    8000548e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005490:	e4840593          	addi	a1,s0,-440
    80005494:	4505                	li	a0,1
    80005496:	f10fd0ef          	jal	80002ba6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000549a:	08000613          	li	a2,128
    8000549e:	f5040593          	addi	a1,s0,-176
    800054a2:	4501                	li	a0,0
    800054a4:	f1efd0ef          	jal	80002bc2 <argstr>
    800054a8:	87aa                	mv	a5,a0
    return -1;
    800054aa:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800054ac:	0c07c463          	bltz	a5,80005574 <sys_exec+0xec>
    800054b0:	f726                	sd	s1,424(sp)
    800054b2:	f34a                	sd	s2,416(sp)
    800054b4:	ef4e                	sd	s3,408(sp)
    800054b6:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800054b8:	10000613          	li	a2,256
    800054bc:	4581                	li	a1,0
    800054be:	e5040513          	addi	a0,s0,-432
    800054c2:	807fb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800054c6:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800054ca:	89a6                	mv	s3,s1
    800054cc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800054ce:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800054d2:	00391513          	slli	a0,s2,0x3
    800054d6:	e4040593          	addi	a1,s0,-448
    800054da:	e4843783          	ld	a5,-440(s0)
    800054de:	953e                	add	a0,a0,a5
    800054e0:	e20fd0ef          	jal	80002b00 <fetchaddr>
    800054e4:	02054663          	bltz	a0,80005510 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800054e8:	e4043783          	ld	a5,-448(s0)
    800054ec:	c3a9                	beqz	a5,8000552e <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800054ee:	e36fb0ef          	jal	80000b24 <kalloc>
    800054f2:	85aa                	mv	a1,a0
    800054f4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800054f8:	cd01                	beqz	a0,80005510 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800054fa:	6605                	lui	a2,0x1
    800054fc:	e4043503          	ld	a0,-448(s0)
    80005500:	e4afd0ef          	jal	80002b4a <fetchstr>
    80005504:	00054663          	bltz	a0,80005510 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005508:	0905                	addi	s2,s2,1
    8000550a:	09a1                	addi	s3,s3,8
    8000550c:	fd4913e3          	bne	s2,s4,800054d2 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005510:	f5040913          	addi	s2,s0,-176
    80005514:	6088                	ld	a0,0(s1)
    80005516:	c931                	beqz	a0,8000556a <sys_exec+0xe2>
    kfree(argv[i]);
    80005518:	d2afb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000551c:	04a1                	addi	s1,s1,8
    8000551e:	ff249be3          	bne	s1,s2,80005514 <sys_exec+0x8c>
  return -1;
    80005522:	557d                	li	a0,-1
    80005524:	74ba                	ld	s1,424(sp)
    80005526:	791a                	ld	s2,416(sp)
    80005528:	69fa                	ld	s3,408(sp)
    8000552a:	6a5a                	ld	s4,400(sp)
    8000552c:	a0a1                	j	80005574 <sys_exec+0xec>
      argv[i] = 0;
    8000552e:	0009079b          	sext.w	a5,s2
    80005532:	078e                	slli	a5,a5,0x3
    80005534:	fd078793          	addi	a5,a5,-48
    80005538:	97a2                	add	a5,a5,s0
    8000553a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000553e:	e5040593          	addi	a1,s0,-432
    80005542:	f5040513          	addi	a0,s0,-176
    80005546:	ba8ff0ef          	jal	800048ee <exec>
    8000554a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000554c:	f5040993          	addi	s3,s0,-176
    80005550:	6088                	ld	a0,0(s1)
    80005552:	c511                	beqz	a0,8000555e <sys_exec+0xd6>
    kfree(argv[i]);
    80005554:	ceefb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005558:	04a1                	addi	s1,s1,8
    8000555a:	ff349be3          	bne	s1,s3,80005550 <sys_exec+0xc8>
  return ret;
    8000555e:	854a                	mv	a0,s2
    80005560:	74ba                	ld	s1,424(sp)
    80005562:	791a                	ld	s2,416(sp)
    80005564:	69fa                	ld	s3,408(sp)
    80005566:	6a5a                	ld	s4,400(sp)
    80005568:	a031                	j	80005574 <sys_exec+0xec>
  return -1;
    8000556a:	557d                	li	a0,-1
    8000556c:	74ba                	ld	s1,424(sp)
    8000556e:	791a                	ld	s2,416(sp)
    80005570:	69fa                	ld	s3,408(sp)
    80005572:	6a5a                	ld	s4,400(sp)
}
    80005574:	70fa                	ld	ra,440(sp)
    80005576:	745a                	ld	s0,432(sp)
    80005578:	6139                	addi	sp,sp,448
    8000557a:	8082                	ret

000000008000557c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000557c:	7139                	addi	sp,sp,-64
    8000557e:	fc06                	sd	ra,56(sp)
    80005580:	f822                	sd	s0,48(sp)
    80005582:	f426                	sd	s1,40(sp)
    80005584:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005586:	b7cfc0ef          	jal	80001902 <myproc>
    8000558a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000558c:	fd840593          	addi	a1,s0,-40
    80005590:	4501                	li	a0,0
    80005592:	e14fd0ef          	jal	80002ba6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005596:	fc840593          	addi	a1,s0,-56
    8000559a:	fd040513          	addi	a0,s0,-48
    8000559e:	85cff0ef          	jal	800045fa <pipealloc>
    return -1;
    800055a2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800055a4:	0a054463          	bltz	a0,8000564c <sys_pipe+0xd0>
  fd0 = -1;
    800055a8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800055ac:	fd043503          	ld	a0,-48(s0)
    800055b0:	f08ff0ef          	jal	80004cb8 <fdalloc>
    800055b4:	fca42223          	sw	a0,-60(s0)
    800055b8:	08054163          	bltz	a0,8000563a <sys_pipe+0xbe>
    800055bc:	fc843503          	ld	a0,-56(s0)
    800055c0:	ef8ff0ef          	jal	80004cb8 <fdalloc>
    800055c4:	fca42023          	sw	a0,-64(s0)
    800055c8:	06054063          	bltz	a0,80005628 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055cc:	4691                	li	a3,4
    800055ce:	fc440613          	addi	a2,s0,-60
    800055d2:	fd843583          	ld	a1,-40(s0)
    800055d6:	68a8                	ld	a0,80(s1)
    800055d8:	fa5fb0ef          	jal	8000157c <copyout>
    800055dc:	00054e63          	bltz	a0,800055f8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800055e0:	4691                	li	a3,4
    800055e2:	fc040613          	addi	a2,s0,-64
    800055e6:	fd843583          	ld	a1,-40(s0)
    800055ea:	0591                	addi	a1,a1,4
    800055ec:	68a8                	ld	a0,80(s1)
    800055ee:	f8ffb0ef          	jal	8000157c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800055f2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055f4:	04055c63          	bgez	a0,8000564c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800055f8:	fc442783          	lw	a5,-60(s0)
    800055fc:	07e9                	addi	a5,a5,26
    800055fe:	078e                	slli	a5,a5,0x3
    80005600:	97a6                	add	a5,a5,s1
    80005602:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005606:	fc042783          	lw	a5,-64(s0)
    8000560a:	07e9                	addi	a5,a5,26
    8000560c:	078e                	slli	a5,a5,0x3
    8000560e:	94be                	add	s1,s1,a5
    80005610:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005614:	fd043503          	ld	a0,-48(s0)
    80005618:	cd9fe0ef          	jal	800042f0 <fileclose>
    fileclose(wf);
    8000561c:	fc843503          	ld	a0,-56(s0)
    80005620:	cd1fe0ef          	jal	800042f0 <fileclose>
    return -1;
    80005624:	57fd                	li	a5,-1
    80005626:	a01d                	j	8000564c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005628:	fc442783          	lw	a5,-60(s0)
    8000562c:	0007c763          	bltz	a5,8000563a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005630:	07e9                	addi	a5,a5,26
    80005632:	078e                	slli	a5,a5,0x3
    80005634:	97a6                	add	a5,a5,s1
    80005636:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000563a:	fd043503          	ld	a0,-48(s0)
    8000563e:	cb3fe0ef          	jal	800042f0 <fileclose>
    fileclose(wf);
    80005642:	fc843503          	ld	a0,-56(s0)
    80005646:	cabfe0ef          	jal	800042f0 <fileclose>
    return -1;
    8000564a:	57fd                	li	a5,-1
}
    8000564c:	853e                	mv	a0,a5
    8000564e:	70e2                	ld	ra,56(sp)
    80005650:	7442                	ld	s0,48(sp)
    80005652:	74a2                	ld	s1,40(sp)
    80005654:	6121                	addi	sp,sp,64
    80005656:	8082                	ret
	...

0000000080005660 <kernelvec>:
    80005660:	7111                	addi	sp,sp,-256
    80005662:	e006                	sd	ra,0(sp)
    80005664:	e40a                	sd	sp,8(sp)
    80005666:	e80e                	sd	gp,16(sp)
    80005668:	ec12                	sd	tp,24(sp)
    8000566a:	f016                	sd	t0,32(sp)
    8000566c:	f41a                	sd	t1,40(sp)
    8000566e:	f81e                	sd	t2,48(sp)
    80005670:	e4aa                	sd	a0,72(sp)
    80005672:	e8ae                	sd	a1,80(sp)
    80005674:	ecb2                	sd	a2,88(sp)
    80005676:	f0b6                	sd	a3,96(sp)
    80005678:	f4ba                	sd	a4,104(sp)
    8000567a:	f8be                	sd	a5,112(sp)
    8000567c:	fcc2                	sd	a6,120(sp)
    8000567e:	e146                	sd	a7,128(sp)
    80005680:	edf2                	sd	t3,216(sp)
    80005682:	f1f6                	sd	t4,224(sp)
    80005684:	f5fa                	sd	t5,232(sp)
    80005686:	f9fe                	sd	t6,240(sp)
    80005688:	b88fd0ef          	jal	80002a10 <kerneltrap>
    8000568c:	6082                	ld	ra,0(sp)
    8000568e:	6122                	ld	sp,8(sp)
    80005690:	61c2                	ld	gp,16(sp)
    80005692:	7282                	ld	t0,32(sp)
    80005694:	7322                	ld	t1,40(sp)
    80005696:	73c2                	ld	t2,48(sp)
    80005698:	6526                	ld	a0,72(sp)
    8000569a:	65c6                	ld	a1,80(sp)
    8000569c:	6666                	ld	a2,88(sp)
    8000569e:	7686                	ld	a3,96(sp)
    800056a0:	7726                	ld	a4,104(sp)
    800056a2:	77c6                	ld	a5,112(sp)
    800056a4:	7866                	ld	a6,120(sp)
    800056a6:	688a                	ld	a7,128(sp)
    800056a8:	6e6e                	ld	t3,216(sp)
    800056aa:	7e8e                	ld	t4,224(sp)
    800056ac:	7f2e                	ld	t5,232(sp)
    800056ae:	7fce                	ld	t6,240(sp)
    800056b0:	6111                	addi	sp,sp,256
    800056b2:	10200073          	sret
	...

00000000800056be <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800056be:	1141                	addi	sp,sp,-16
    800056c0:	e422                	sd	s0,8(sp)
    800056c2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800056c4:	0c0007b7          	lui	a5,0xc000
    800056c8:	4705                	li	a4,1
    800056ca:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800056cc:	0c0007b7          	lui	a5,0xc000
    800056d0:	c3d8                	sw	a4,4(a5)
}
    800056d2:	6422                	ld	s0,8(sp)
    800056d4:	0141                	addi	sp,sp,16
    800056d6:	8082                	ret

00000000800056d8 <plicinithart>:

void
plicinithart(void)
{
    800056d8:	1141                	addi	sp,sp,-16
    800056da:	e406                	sd	ra,8(sp)
    800056dc:	e022                	sd	s0,0(sp)
    800056de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056e0:	9f6fc0ef          	jal	800018d6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800056e4:	0085171b          	slliw	a4,a0,0x8
    800056e8:	0c0027b7          	lui	a5,0xc002
    800056ec:	97ba                	add	a5,a5,a4
    800056ee:	40200713          	li	a4,1026
    800056f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800056f6:	00d5151b          	slliw	a0,a0,0xd
    800056fa:	0c2017b7          	lui	a5,0xc201
    800056fe:	97aa                	add	a5,a5,a0
    80005700:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005704:	60a2                	ld	ra,8(sp)
    80005706:	6402                	ld	s0,0(sp)
    80005708:	0141                	addi	sp,sp,16
    8000570a:	8082                	ret

000000008000570c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000570c:	1141                	addi	sp,sp,-16
    8000570e:	e406                	sd	ra,8(sp)
    80005710:	e022                	sd	s0,0(sp)
    80005712:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005714:	9c2fc0ef          	jal	800018d6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005718:	00d5151b          	slliw	a0,a0,0xd
    8000571c:	0c2017b7          	lui	a5,0xc201
    80005720:	97aa                	add	a5,a5,a0
  return irq;
}
    80005722:	43c8                	lw	a0,4(a5)
    80005724:	60a2                	ld	ra,8(sp)
    80005726:	6402                	ld	s0,0(sp)
    80005728:	0141                	addi	sp,sp,16
    8000572a:	8082                	ret

000000008000572c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000572c:	1101                	addi	sp,sp,-32
    8000572e:	ec06                	sd	ra,24(sp)
    80005730:	e822                	sd	s0,16(sp)
    80005732:	e426                	sd	s1,8(sp)
    80005734:	1000                	addi	s0,sp,32
    80005736:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005738:	99efc0ef          	jal	800018d6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000573c:	00d5151b          	slliw	a0,a0,0xd
    80005740:	0c2017b7          	lui	a5,0xc201
    80005744:	97aa                	add	a5,a5,a0
    80005746:	c3c4                	sw	s1,4(a5)
}
    80005748:	60e2                	ld	ra,24(sp)
    8000574a:	6442                	ld	s0,16(sp)
    8000574c:	64a2                	ld	s1,8(sp)
    8000574e:	6105                	addi	sp,sp,32
    80005750:	8082                	ret

0000000080005752 <log_message>:

struct spinlock log_lock;
int log_lock_initialized = 0;

void log_message(log_level_t level, const char *message)
{
    80005752:	1101                	addi	sp,sp,-32
    80005754:	ec06                	sd	ra,24(sp)
    80005756:	e822                	sd	s0,16(sp)
    80005758:	e426                	sd	s1,8(sp)
    8000575a:	e04a                	sd	s2,0(sp)
    8000575c:	1000                	addi	s0,sp,32
    8000575e:	892a                	mv	s2,a0
    80005760:	84ae                	mv	s1,a1
  if (!log_lock_initialized) {
    80005762:	00002797          	auipc	a5,0x2
    80005766:	3427a783          	lw	a5,834(a5) # 80007aa4 <log_lock_initialized>
    8000576a:	c7b5                	beqz	a5,800057d6 <log_message+0x84>
    initlock(&log_lock, "log");
    log_lock_initialized = 1;
  }

  acquire(&log_lock);  
    8000576c:	0001d517          	auipc	a0,0x1d
    80005770:	73450513          	addi	a0,a0,1844 # 80022ea0 <log_lock>
    80005774:	c80fb0ef          	jal	80000bf4 <acquire>

  if (level < LOG_INFO || level > LOG_ERROR) {
    80005778:	4789                	li	a5,2
    8000577a:	0727ee63          	bltu	a5,s2,800057f6 <log_message+0xa4>
    release(&log_lock);
    return;
  }

  const char *prefix = log_level_strings[level];
    8000577e:	02091793          	slli	a5,s2,0x20
    80005782:	01d7d913          	srli	s2,a5,0x1d
    80005786:	00002797          	auipc	a5,0x2
    8000578a:	27a78793          	addi	a5,a5,634 # 80007a00 <log_level_strings>
    8000578e:	97ca                	add	a5,a5,s2
    80005790:	0007b903          	ld	s2,0(a5)
  while (*prefix)
    80005794:	00094503          	lbu	a0,0(s2)
    80005798:	c519                	beqz	a0,800057a6 <log_message+0x54>
    uartputc_sync(*prefix++);  
    8000579a:	0905                	addi	s2,s2,1
    8000579c:	8b8fb0ef          	jal	80000854 <uartputc_sync>
  while (*prefix)
    800057a0:	00094503          	lbu	a0,0(s2)
    800057a4:	f97d                	bnez	a0,8000579a <log_message+0x48>

  while (*message)
    800057a6:	0004c503          	lbu	a0,0(s1)
    800057aa:	c519                	beqz	a0,800057b8 <log_message+0x66>
    uartputc_sync(*message++);
    800057ac:	0485                	addi	s1,s1,1
    800057ae:	8a6fb0ef          	jal	80000854 <uartputc_sync>
  while (*message)
    800057b2:	0004c503          	lbu	a0,0(s1)
    800057b6:	f97d                	bnez	a0,800057ac <log_message+0x5a>

  uartputc_sync('\n');
    800057b8:	4529                	li	a0,10
    800057ba:	89afb0ef          	jal	80000854 <uartputc_sync>

  release(&log_lock);
    800057be:	0001d517          	auipc	a0,0x1d
    800057c2:	6e250513          	addi	a0,a0,1762 # 80022ea0 <log_lock>
    800057c6:	cc6fb0ef          	jal	80000c8c <release>
}
    800057ca:	60e2                	ld	ra,24(sp)
    800057cc:	6442                	ld	s0,16(sp)
    800057ce:	64a2                	ld	s1,8(sp)
    800057d0:	6902                	ld	s2,0(sp)
    800057d2:	6105                	addi	sp,sp,32
    800057d4:	8082                	ret
    initlock(&log_lock, "log");
    800057d6:	00002597          	auipc	a1,0x2
    800057da:	eba58593          	addi	a1,a1,-326 # 80007690 <etext+0x690>
    800057de:	0001d517          	auipc	a0,0x1d
    800057e2:	6c250513          	addi	a0,a0,1730 # 80022ea0 <log_lock>
    800057e6:	b8efb0ef          	jal	80000b74 <initlock>
    log_lock_initialized = 1;
    800057ea:	4785                	li	a5,1
    800057ec:	00002717          	auipc	a4,0x2
    800057f0:	2af72c23          	sw	a5,696(a4) # 80007aa4 <log_lock_initialized>
    800057f4:	bfa5                	j	8000576c <log_message+0x1a>
    release(&log_lock);
    800057f6:	0001d517          	auipc	a0,0x1d
    800057fa:	6aa50513          	addi	a0,a0,1706 # 80022ea0 <log_lock>
    800057fe:	c8efb0ef          	jal	80000c8c <release>
    return;
    80005802:	b7e1                	j	800057ca <log_message+0x78>

0000000080005804 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005804:	1141                	addi	sp,sp,-16
    80005806:	e406                	sd	ra,8(sp)
    80005808:	e022                	sd	s0,0(sp)
    8000580a:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000580c:	479d                	li	a5,7
    8000580e:	04a7ca63          	blt	a5,a0,80005862 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005812:	0001d797          	auipc	a5,0x1d
    80005816:	6a678793          	addi	a5,a5,1702 # 80022eb8 <disk>
    8000581a:	97aa                	add	a5,a5,a0
    8000581c:	0187c783          	lbu	a5,24(a5)
    80005820:	e7b9                	bnez	a5,8000586e <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005822:	00451693          	slli	a3,a0,0x4
    80005826:	0001d797          	auipc	a5,0x1d
    8000582a:	69278793          	addi	a5,a5,1682 # 80022eb8 <disk>
    8000582e:	6398                	ld	a4,0(a5)
    80005830:	9736                	add	a4,a4,a3
    80005832:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005836:	6398                	ld	a4,0(a5)
    80005838:	9736                	add	a4,a4,a3
    8000583a:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000583e:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005842:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005846:	97aa                	add	a5,a5,a0
    80005848:	4705                	li	a4,1
    8000584a:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000584e:	0001d517          	auipc	a0,0x1d
    80005852:	68250513          	addi	a0,a0,1666 # 80022ed0 <disk+0x18>
    80005856:	ba0fc0ef          	jal	80001bf6 <wakeup>
}
    8000585a:	60a2                	ld	ra,8(sp)
    8000585c:	6402                	ld	s0,0(sp)
    8000585e:	0141                	addi	sp,sp,16
    80005860:	8082                	ret
    panic("free_desc 1");
    80005862:	00002517          	auipc	a0,0x2
    80005866:	f7650513          	addi	a0,a0,-138 # 800077d8 <etext+0x7d8>
    8000586a:	f2bfa0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000586e:	00002517          	auipc	a0,0x2
    80005872:	f7a50513          	addi	a0,a0,-134 # 800077e8 <etext+0x7e8>
    80005876:	f1ffa0ef          	jal	80000794 <panic>

000000008000587a <virtio_disk_init>:
{
    8000587a:	1101                	addi	sp,sp,-32
    8000587c:	ec06                	sd	ra,24(sp)
    8000587e:	e822                	sd	s0,16(sp)
    80005880:	e426                	sd	s1,8(sp)
    80005882:	e04a                	sd	s2,0(sp)
    80005884:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005886:	00002597          	auipc	a1,0x2
    8000588a:	f7258593          	addi	a1,a1,-142 # 800077f8 <etext+0x7f8>
    8000588e:	0001d517          	auipc	a0,0x1d
    80005892:	75250513          	addi	a0,a0,1874 # 80022fe0 <disk+0x128>
    80005896:	adefb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000589a:	100017b7          	lui	a5,0x10001
    8000589e:	4398                	lw	a4,0(a5)
    800058a0:	2701                	sext.w	a4,a4
    800058a2:	747277b7          	lui	a5,0x74727
    800058a6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800058aa:	18f71063          	bne	a4,a5,80005a2a <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800058ae:	100017b7          	lui	a5,0x10001
    800058b2:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800058b4:	439c                	lw	a5,0(a5)
    800058b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058b8:	4709                	li	a4,2
    800058ba:	16e79863          	bne	a5,a4,80005a2a <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058be:	100017b7          	lui	a5,0x10001
    800058c2:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800058c4:	439c                	lw	a5,0(a5)
    800058c6:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800058c8:	16e79163          	bne	a5,a4,80005a2a <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800058cc:	100017b7          	lui	a5,0x10001
    800058d0:	47d8                	lw	a4,12(a5)
    800058d2:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058d4:	554d47b7          	lui	a5,0x554d4
    800058d8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800058dc:	14f71763          	bne	a4,a5,80005a2a <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058e0:	100017b7          	lui	a5,0x10001
    800058e4:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058e8:	4705                	li	a4,1
    800058ea:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800058ec:	470d                	li	a4,3
    800058ee:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800058f0:	10001737          	lui	a4,0x10001
    800058f4:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800058f6:	c7ffe737          	lui	a4,0xc7ffe
    800058fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb767>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800058fe:	8ef9                	and	a3,a3,a4
    80005900:	10001737          	lui	a4,0x10001
    80005904:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005906:	472d                	li	a4,11
    80005908:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000590a:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000590e:	439c                	lw	a5,0(a5)
    80005910:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005914:	8ba1                	andi	a5,a5,8
    80005916:	12078063          	beqz	a5,80005a36 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000591a:	100017b7          	lui	a5,0x10001
    8000591e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005922:	100017b7          	lui	a5,0x10001
    80005926:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    8000592a:	439c                	lw	a5,0(a5)
    8000592c:	2781                	sext.w	a5,a5
    8000592e:	10079a63          	bnez	a5,80005a42 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005932:	100017b7          	lui	a5,0x10001
    80005936:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000593a:	439c                	lw	a5,0(a5)
    8000593c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000593e:	10078863          	beqz	a5,80005a4e <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005942:	471d                	li	a4,7
    80005944:	10f77b63          	bgeu	a4,a5,80005a5a <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005948:	9dcfb0ef          	jal	80000b24 <kalloc>
    8000594c:	0001d497          	auipc	s1,0x1d
    80005950:	56c48493          	addi	s1,s1,1388 # 80022eb8 <disk>
    80005954:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005956:	9cefb0ef          	jal	80000b24 <kalloc>
    8000595a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000595c:	9c8fb0ef          	jal	80000b24 <kalloc>
    80005960:	87aa                	mv	a5,a0
    80005962:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005964:	6088                	ld	a0,0(s1)
    80005966:	10050063          	beqz	a0,80005a66 <virtio_disk_init+0x1ec>
    8000596a:	0001d717          	auipc	a4,0x1d
    8000596e:	55673703          	ld	a4,1366(a4) # 80022ec0 <disk+0x8>
    80005972:	0e070a63          	beqz	a4,80005a66 <virtio_disk_init+0x1ec>
    80005976:	0e078863          	beqz	a5,80005a66 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    8000597a:	6605                	lui	a2,0x1
    8000597c:	4581                	li	a1,0
    8000597e:	b4afb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005982:	0001d497          	auipc	s1,0x1d
    80005986:	53648493          	addi	s1,s1,1334 # 80022eb8 <disk>
    8000598a:	6605                	lui	a2,0x1
    8000598c:	4581                	li	a1,0
    8000598e:	6488                	ld	a0,8(s1)
    80005990:	b38fb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005994:	6605                	lui	a2,0x1
    80005996:	4581                	li	a1,0
    80005998:	6888                	ld	a0,16(s1)
    8000599a:	b2efb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000599e:	100017b7          	lui	a5,0x10001
    800059a2:	4721                	li	a4,8
    800059a4:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800059a6:	4098                	lw	a4,0(s1)
    800059a8:	100017b7          	lui	a5,0x10001
    800059ac:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800059b0:	40d8                	lw	a4,4(s1)
    800059b2:	100017b7          	lui	a5,0x10001
    800059b6:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800059ba:	649c                	ld	a5,8(s1)
    800059bc:	0007869b          	sext.w	a3,a5
    800059c0:	10001737          	lui	a4,0x10001
    800059c4:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800059c8:	9781                	srai	a5,a5,0x20
    800059ca:	10001737          	lui	a4,0x10001
    800059ce:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800059d2:	689c                	ld	a5,16(s1)
    800059d4:	0007869b          	sext.w	a3,a5
    800059d8:	10001737          	lui	a4,0x10001
    800059dc:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800059e0:	9781                	srai	a5,a5,0x20
    800059e2:	10001737          	lui	a4,0x10001
    800059e6:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800059ea:	10001737          	lui	a4,0x10001
    800059ee:	4785                	li	a5,1
    800059f0:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800059f2:	00f48c23          	sb	a5,24(s1)
    800059f6:	00f48ca3          	sb	a5,25(s1)
    800059fa:	00f48d23          	sb	a5,26(s1)
    800059fe:	00f48da3          	sb	a5,27(s1)
    80005a02:	00f48e23          	sb	a5,28(s1)
    80005a06:	00f48ea3          	sb	a5,29(s1)
    80005a0a:	00f48f23          	sb	a5,30(s1)
    80005a0e:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005a12:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a16:	100017b7          	lui	a5,0x10001
    80005a1a:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005a1e:	60e2                	ld	ra,24(sp)
    80005a20:	6442                	ld	s0,16(sp)
    80005a22:	64a2                	ld	s1,8(sp)
    80005a24:	6902                	ld	s2,0(sp)
    80005a26:	6105                	addi	sp,sp,32
    80005a28:	8082                	ret
    panic("could not find virtio disk");
    80005a2a:	00002517          	auipc	a0,0x2
    80005a2e:	dde50513          	addi	a0,a0,-546 # 80007808 <etext+0x808>
    80005a32:	d63fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005a36:	00002517          	auipc	a0,0x2
    80005a3a:	df250513          	addi	a0,a0,-526 # 80007828 <etext+0x828>
    80005a3e:	d57fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005a42:	00002517          	auipc	a0,0x2
    80005a46:	e0650513          	addi	a0,a0,-506 # 80007848 <etext+0x848>
    80005a4a:	d4bfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    80005a4e:	00002517          	auipc	a0,0x2
    80005a52:	e1a50513          	addi	a0,a0,-486 # 80007868 <etext+0x868>
    80005a56:	d3ffa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005a5a:	00002517          	auipc	a0,0x2
    80005a5e:	e2e50513          	addi	a0,a0,-466 # 80007888 <etext+0x888>
    80005a62:	d33fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005a66:	00002517          	auipc	a0,0x2
    80005a6a:	e4250513          	addi	a0,a0,-446 # 800078a8 <etext+0x8a8>
    80005a6e:	d27fa0ef          	jal	80000794 <panic>

0000000080005a72 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005a72:	7159                	addi	sp,sp,-112
    80005a74:	f486                	sd	ra,104(sp)
    80005a76:	f0a2                	sd	s0,96(sp)
    80005a78:	eca6                	sd	s1,88(sp)
    80005a7a:	e8ca                	sd	s2,80(sp)
    80005a7c:	e4ce                	sd	s3,72(sp)
    80005a7e:	e0d2                	sd	s4,64(sp)
    80005a80:	fc56                	sd	s5,56(sp)
    80005a82:	f85a                	sd	s6,48(sp)
    80005a84:	f45e                	sd	s7,40(sp)
    80005a86:	f062                	sd	s8,32(sp)
    80005a88:	ec66                	sd	s9,24(sp)
    80005a8a:	1880                	addi	s0,sp,112
    80005a8c:	8a2a                	mv	s4,a0
    80005a8e:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005a90:	00c52c83          	lw	s9,12(a0)
    80005a94:	001c9c9b          	slliw	s9,s9,0x1
    80005a98:	1c82                	slli	s9,s9,0x20
    80005a9a:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005a9e:	0001d517          	auipc	a0,0x1d
    80005aa2:	54250513          	addi	a0,a0,1346 # 80022fe0 <disk+0x128>
    80005aa6:	94efb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005aaa:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005aac:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005aae:	0001db17          	auipc	s6,0x1d
    80005ab2:	40ab0b13          	addi	s6,s6,1034 # 80022eb8 <disk>
  for(int i = 0; i < 3; i++){
    80005ab6:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ab8:	0001dc17          	auipc	s8,0x1d
    80005abc:	528c0c13          	addi	s8,s8,1320 # 80022fe0 <disk+0x128>
    80005ac0:	a8b9                	j	80005b1e <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005ac2:	00fb0733          	add	a4,s6,a5
    80005ac6:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005aca:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005acc:	0207c563          	bltz	a5,80005af6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005ad0:	2905                	addiw	s2,s2,1
    80005ad2:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005ad4:	05590963          	beq	s2,s5,80005b26 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005ad8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005ada:	0001d717          	auipc	a4,0x1d
    80005ade:	3de70713          	addi	a4,a4,990 # 80022eb8 <disk>
    80005ae2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005ae4:	01874683          	lbu	a3,24(a4)
    80005ae8:	fee9                	bnez	a3,80005ac2 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005aea:	2785                	addiw	a5,a5,1
    80005aec:	0705                	addi	a4,a4,1
    80005aee:	fe979be3          	bne	a5,s1,80005ae4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005af2:	57fd                	li	a5,-1
    80005af4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005af6:	01205d63          	blez	s2,80005b10 <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005afa:	f9042503          	lw	a0,-112(s0)
    80005afe:	d07ff0ef          	jal	80005804 <free_desc>
      for(int j = 0; j < i; j++)
    80005b02:	4785                	li	a5,1
    80005b04:	0127d663          	bge	a5,s2,80005b10 <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005b08:	f9442503          	lw	a0,-108(s0)
    80005b0c:	cf9ff0ef          	jal	80005804 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005b10:	85e2                	mv	a1,s8
    80005b12:	0001d517          	auipc	a0,0x1d
    80005b16:	3be50513          	addi	a0,a0,958 # 80022ed0 <disk+0x18>
    80005b1a:	890fc0ef          	jal	80001baa <sleep>
  for(int i = 0; i < 3; i++){
    80005b1e:	f9040613          	addi	a2,s0,-112
    80005b22:	894e                	mv	s2,s3
    80005b24:	bf55                	j	80005ad8 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b26:	f9042503          	lw	a0,-112(s0)
    80005b2a:	00451693          	slli	a3,a0,0x4

  if(write)
    80005b2e:	0001d797          	auipc	a5,0x1d
    80005b32:	38a78793          	addi	a5,a5,906 # 80022eb8 <disk>
    80005b36:	00a50713          	addi	a4,a0,10
    80005b3a:	0712                	slli	a4,a4,0x4
    80005b3c:	973e                	add	a4,a4,a5
    80005b3e:	01703633          	snez	a2,s7
    80005b42:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005b44:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005b48:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b4c:	6398                	ld	a4,0(a5)
    80005b4e:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b50:	0a868613          	addi	a2,a3,168
    80005b54:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b56:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005b58:	6390                	ld	a2,0(a5)
    80005b5a:	00d605b3          	add	a1,a2,a3
    80005b5e:	4741                	li	a4,16
    80005b60:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005b62:	4805                	li	a6,1
    80005b64:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005b68:	f9442703          	lw	a4,-108(s0)
    80005b6c:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b70:	0712                	slli	a4,a4,0x4
    80005b72:	963a                	add	a2,a2,a4
    80005b74:	058a0593          	addi	a1,s4,88
    80005b78:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b7a:	0007b883          	ld	a7,0(a5)
    80005b7e:	9746                	add	a4,a4,a7
    80005b80:	40000613          	li	a2,1024
    80005b84:	c710                	sw	a2,8(a4)
  if(write)
    80005b86:	001bb613          	seqz	a2,s7
    80005b8a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005b8e:	00166613          	ori	a2,a2,1
    80005b92:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005b96:	f9842583          	lw	a1,-104(s0)
    80005b9a:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005b9e:	00250613          	addi	a2,a0,2
    80005ba2:	0612                	slli	a2,a2,0x4
    80005ba4:	963e                	add	a2,a2,a5
    80005ba6:	577d                	li	a4,-1
    80005ba8:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005bac:	0592                	slli	a1,a1,0x4
    80005bae:	98ae                	add	a7,a7,a1
    80005bb0:	03068713          	addi	a4,a3,48
    80005bb4:	973e                	add	a4,a4,a5
    80005bb6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005bba:	6398                	ld	a4,0(a5)
    80005bbc:	972e                	add	a4,a4,a1
    80005bbe:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005bc2:	4689                	li	a3,2
    80005bc4:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005bc8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005bcc:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005bd0:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005bd4:	6794                	ld	a3,8(a5)
    80005bd6:	0026d703          	lhu	a4,2(a3)
    80005bda:	8b1d                	andi	a4,a4,7
    80005bdc:	0706                	slli	a4,a4,0x1
    80005bde:	96ba                	add	a3,a3,a4
    80005be0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005be4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005be8:	6798                	ld	a4,8(a5)
    80005bea:	00275783          	lhu	a5,2(a4)
    80005bee:	2785                	addiw	a5,a5,1
    80005bf0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005bf4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005bf8:	100017b7          	lui	a5,0x10001
    80005bfc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005c00:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005c04:	0001d917          	auipc	s2,0x1d
    80005c08:	3dc90913          	addi	s2,s2,988 # 80022fe0 <disk+0x128>
  while(b->disk == 1) {
    80005c0c:	4485                	li	s1,1
    80005c0e:	01079a63          	bne	a5,a6,80005c22 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005c12:	85ca                	mv	a1,s2
    80005c14:	8552                	mv	a0,s4
    80005c16:	f95fb0ef          	jal	80001baa <sleep>
  while(b->disk == 1) {
    80005c1a:	004a2783          	lw	a5,4(s4)
    80005c1e:	fe978ae3          	beq	a5,s1,80005c12 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005c22:	f9042903          	lw	s2,-112(s0)
    80005c26:	00290713          	addi	a4,s2,2
    80005c2a:	0712                	slli	a4,a4,0x4
    80005c2c:	0001d797          	auipc	a5,0x1d
    80005c30:	28c78793          	addi	a5,a5,652 # 80022eb8 <disk>
    80005c34:	97ba                	add	a5,a5,a4
    80005c36:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005c3a:	0001d997          	auipc	s3,0x1d
    80005c3e:	27e98993          	addi	s3,s3,638 # 80022eb8 <disk>
    80005c42:	00491713          	slli	a4,s2,0x4
    80005c46:	0009b783          	ld	a5,0(s3)
    80005c4a:	97ba                	add	a5,a5,a4
    80005c4c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c50:	854a                	mv	a0,s2
    80005c52:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c56:	bafff0ef          	jal	80005804 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c5a:	8885                	andi	s1,s1,1
    80005c5c:	f0fd                	bnez	s1,80005c42 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c5e:	0001d517          	auipc	a0,0x1d
    80005c62:	38250513          	addi	a0,a0,898 # 80022fe0 <disk+0x128>
    80005c66:	826fb0ef          	jal	80000c8c <release>
}
    80005c6a:	70a6                	ld	ra,104(sp)
    80005c6c:	7406                	ld	s0,96(sp)
    80005c6e:	64e6                	ld	s1,88(sp)
    80005c70:	6946                	ld	s2,80(sp)
    80005c72:	69a6                	ld	s3,72(sp)
    80005c74:	6a06                	ld	s4,64(sp)
    80005c76:	7ae2                	ld	s5,56(sp)
    80005c78:	7b42                	ld	s6,48(sp)
    80005c7a:	7ba2                	ld	s7,40(sp)
    80005c7c:	7c02                	ld	s8,32(sp)
    80005c7e:	6ce2                	ld	s9,24(sp)
    80005c80:	6165                	addi	sp,sp,112
    80005c82:	8082                	ret

0000000080005c84 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005c84:	1101                	addi	sp,sp,-32
    80005c86:	ec06                	sd	ra,24(sp)
    80005c88:	e822                	sd	s0,16(sp)
    80005c8a:	e426                	sd	s1,8(sp)
    80005c8c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005c8e:	0001d497          	auipc	s1,0x1d
    80005c92:	22a48493          	addi	s1,s1,554 # 80022eb8 <disk>
    80005c96:	0001d517          	auipc	a0,0x1d
    80005c9a:	34a50513          	addi	a0,a0,842 # 80022fe0 <disk+0x128>
    80005c9e:	f57fa0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ca2:	100017b7          	lui	a5,0x10001
    80005ca6:	53b8                	lw	a4,96(a5)
    80005ca8:	8b0d                	andi	a4,a4,3
    80005caa:	100017b7          	lui	a5,0x10001
    80005cae:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005cb0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005cb4:	689c                	ld	a5,16(s1)
    80005cb6:	0204d703          	lhu	a4,32(s1)
    80005cba:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005cbe:	04f70663          	beq	a4,a5,80005d0a <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005cc2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005cc6:	6898                	ld	a4,16(s1)
    80005cc8:	0204d783          	lhu	a5,32(s1)
    80005ccc:	8b9d                	andi	a5,a5,7
    80005cce:	078e                	slli	a5,a5,0x3
    80005cd0:	97ba                	add	a5,a5,a4
    80005cd2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005cd4:	00278713          	addi	a4,a5,2
    80005cd8:	0712                	slli	a4,a4,0x4
    80005cda:	9726                	add	a4,a4,s1
    80005cdc:	01074703          	lbu	a4,16(a4)
    80005ce0:	e321                	bnez	a4,80005d20 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ce2:	0789                	addi	a5,a5,2
    80005ce4:	0792                	slli	a5,a5,0x4
    80005ce6:	97a6                	add	a5,a5,s1
    80005ce8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005cea:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005cee:	f09fb0ef          	jal	80001bf6 <wakeup>

    disk.used_idx += 1;
    80005cf2:	0204d783          	lhu	a5,32(s1)
    80005cf6:	2785                	addiw	a5,a5,1
    80005cf8:	17c2                	slli	a5,a5,0x30
    80005cfa:	93c1                	srli	a5,a5,0x30
    80005cfc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d00:	6898                	ld	a4,16(s1)
    80005d02:	00275703          	lhu	a4,2(a4)
    80005d06:	faf71ee3          	bne	a4,a5,80005cc2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005d0a:	0001d517          	auipc	a0,0x1d
    80005d0e:	2d650513          	addi	a0,a0,726 # 80022fe0 <disk+0x128>
    80005d12:	f7bfa0ef          	jal	80000c8c <release>
}
    80005d16:	60e2                	ld	ra,24(sp)
    80005d18:	6442                	ld	s0,16(sp)
    80005d1a:	64a2                	ld	s1,8(sp)
    80005d1c:	6105                	addi	sp,sp,32
    80005d1e:	8082                	ret
      panic("virtio_disk_intr status");
    80005d20:	00002517          	auipc	a0,0x2
    80005d24:	ba050513          	addi	a0,a0,-1120 # 800078c0 <etext+0x8c0>
    80005d28:	a6dfa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
