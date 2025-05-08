
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	a6010113          	addi	sp,sp,-1440 # 80007a60 <stack0>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdda57>
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
    800000fa:	184020ef          	jal	8000227e <either_copyin>
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
    80000158:	90c50513          	addi	a0,a0,-1780 # 8000fa60 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00010497          	auipc	s1,0x10
    80000164:	90048493          	addi	s1,s1,-1792 # 8000fa60 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00010917          	auipc	s2,0x10
    8000016c:	99090913          	addi	s2,s2,-1648 # 8000faf8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	78a010ef          	jal	8000190a <myproc>
    80000184:	78d010ef          	jal	80002110 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	54b010ef          	jal	80001ed8 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00010717          	auipc	a4,0x10
    800001a4:	8c070713          	addi	a4,a4,-1856 # 8000fa60 <cons>
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
    800001d2:	062020ef          	jal	80002234 <either_copyout>
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
    800001ee:	87650513          	addi	a0,a0,-1930 # 8000fa60 <cons>
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
    80000218:	8ef72223          	sw	a5,-1820(a4) # 8000faf8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00010517          	auipc	a0,0x10
    8000022e:	83650513          	addi	a0,a0,-1994 # 8000fa60 <cons>
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
    8000027e:	0000f517          	auipc	a0,0xf
    80000282:	7e250513          	addi	a0,a0,2018 # 8000fa60 <cons>
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
    800002a0:	028020ef          	jal	800022c8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	0000f517          	auipc	a0,0xf
    800002a8:	7bc50513          	addi	a0,a0,1980 # 8000fa60 <cons>
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
    800002c6:	79e70713          	addi	a4,a4,1950 # 8000fa60 <cons>
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
    800002ec:	77878793          	addi	a5,a5,1912 # 8000fa60 <cons>
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
    80000316:	0000f797          	auipc	a5,0xf
    8000031a:	7e27a783          	lw	a5,2018(a5) # 8000faf8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	0000f717          	auipc	a4,0xf
    80000330:	73470713          	addi	a4,a4,1844 # 8000fa60 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	0000f497          	auipc	s1,0xf
    80000340:	72448493          	addi	s1,s1,1828 # 8000fa60 <cons>
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
    80000382:	6e270713          	addi	a4,a4,1762 # 8000fa60 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	0000f717          	auipc	a4,0xf
    80000398:	76f72623          	sw	a5,1900(a4) # 8000fb00 <cons+0xa0>
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
    800003b6:	6ae78793          	addi	a5,a5,1710 # 8000fa60 <cons>
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
    800003da:	72c7a323          	sw	a2,1830(a5) # 8000fafc <cons+0x9c>
        wakeup(&cons.r);
    800003de:	0000f517          	auipc	a0,0xf
    800003e2:	71a50513          	addi	a0,a0,1818 # 8000faf8 <cons+0x98>
    800003e6:	33f010ef          	jal	80001f24 <wakeup>
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
    80000400:	66450513          	addi	a0,a0,1636 # 8000fa60 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	0001f797          	auipc	a5,0x1f
    80000410:	7ec78793          	addi	a5,a5,2028 # 8001fbf8 <devsw>
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
    8000044a:	45a60613          	addi	a2,a2,1114 # 800078a0 <digits>
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
    800004e4:	6407a783          	lw	a5,1600(a5) # 8000fb20 <pr+0x18>
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
    80000530:	5dc50513          	addi	a0,a0,1500 # 8000fb08 <pr>
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
    800006f0:	1b4b8b93          	addi	s7,s7,436 # 800078a0 <digits>
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
    8000078a:	38250513          	addi	a0,a0,898 # 8000fb08 <pr>
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
    800007a4:	3807a023          	sw	zero,896(a5) # 8000fb20 <pr+0x18>
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
    800007c8:	24f72e23          	sw	a5,604(a4) # 80007a20 <panicked>
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
    800007dc:	33048493          	addi	s1,s1,816 # 8000fb08 <pr>
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
    80000844:	2e850513          	addi	a0,a0,744 # 8000fb28 <uart_tx_lock>
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
    80000868:	1bc7a783          	lw	a5,444(a5) # 80007a20 <panicked>
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
    8000089e:	18e7b783          	ld	a5,398(a5) # 80007a28 <uart_tx_r>
    800008a2:	00007717          	auipc	a4,0x7
    800008a6:	18e73703          	ld	a4,398(a4) # 80007a30 <uart_tx_w>
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
    800008cc:	260a8a93          	addi	s5,s5,608 # 8000fb28 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	00007497          	auipc	s1,0x7
    800008d4:	15848493          	addi	s1,s1,344 # 80007a28 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	00007997          	auipc	s3,0x7
    800008e0:	15498993          	addi	s3,s3,340 # 80007a30 <uart_tx_w>
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
    800008fe:	626010ef          	jal	80001f24 <wakeup>
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
    80000950:	1dc50513          	addi	a0,a0,476 # 8000fb28 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	00007797          	auipc	a5,0x7
    8000095c:	0c87a783          	lw	a5,200(a5) # 80007a20 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	00007717          	auipc	a4,0x7
    80000966:	0ce73703          	ld	a4,206(a4) # 80007a30 <uart_tx_w>
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	0be7b783          	ld	a5,190(a5) # 80007a28 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	0000f997          	auipc	s3,0xf
    8000097a:	1b298993          	addi	s3,s3,434 # 8000fb28 <uart_tx_lock>
    8000097e:	00007497          	auipc	s1,0x7
    80000982:	0aa48493          	addi	s1,s1,170 # 80007a28 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00007917          	auipc	s2,0x7
    8000098a:	0aa90913          	addi	s2,s2,170 # 80007a30 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	542010ef          	jal	80001ed8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	0000f497          	auipc	s1,0xf
    800009ac:	18048493          	addi	s1,s1,384 # 8000fb28 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	00007797          	auipc	a5,0x7
    800009c0:	06e7ba23          	sd	a4,116(a5) # 80007a30 <uart_tx_w>
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
    80000a24:	10848493          	addi	s1,s1,264 # 8000fb28 <uart_tx_lock>
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
    80000a56:	00020797          	auipc	a5,0x20
    80000a5a:	35278793          	addi	a5,a5,850 # 80020da8 <end>
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
    80000a76:	0ee90913          	addi	s2,s2,238 # 8000fb60 <kmem>
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
    80000b04:	06050513          	addi	a0,a0,96 # 8000fb60 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00020517          	auipc	a0,0x20
    80000b14:	29850513          	addi	a0,a0,664 # 80020da8 <end>
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
    80000b32:	03248493          	addi	s1,s1,50 # 8000fb60 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	0000f517          	auipc	a0,0xf
    80000b46:	01e50513          	addi	a0,a0,30 # 8000fb60 <kmem>
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
    80000b6a:	ffa50513          	addi	a0,a0,-6 # 8000fb60 <kmem>
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
    80000b9e:	551000ef          	jal	800018ee <mycpu>
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
    80000bcc:	523000ef          	jal	800018ee <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	51b000ef          	jal	800018ee <mycpu>
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
    80000be8:	507000ef          	jal	800018ee <mycpu>
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
    80000c1c:	4d3000ef          	jal	800018ee <mycpu>
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
    80000c40:	4af000ef          	jal	800018ee <mycpu>
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
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde259>
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
    80000e6a:	275000ef          	jal	800018de <cpuid>

    __sync_synchronize();
    started = 1;

  } else {
    while(started == 0)
    80000e6e:	00007717          	auipc	a4,0x7
    80000e72:	bca70713          	addi	a4,a4,-1078 # 80007a38 <started>
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
    80000e82:	25d000ef          	jal	800018de <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	31050513          	addi	a0,a0,784 # 80007198 <etext+0x198>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	0aa000ef          	jal	80000f3e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	562010ef          	jal	800023fa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	3ec040ef          	jal	80005288 <plicinithart>
  }

  scheduler();        
    80000ea0:	69f000ef          	jal	80001d3e <scheduler>
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
    80000edc:	14d000ef          	jal	80001828 <procinit>
    trapinit();      // trap vectors
    80000ee0:	4f6010ef          	jal	800023d6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	516010ef          	jal	800023fa <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	386040ef          	jal	8000526e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	39c040ef          	jal	80005288 <plicinithart>
    binit();         // buffer cache
    80000ef0:	33d010ef          	jal	80002a2c <binit>
    iinit();         // inode table
    80000ef4:	12e020ef          	jal	80003022 <iinit>
    fileinit();      // file table
    80000ef8:	6db020ef          	jal	80003dd2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	52e040ef          	jal	8000542a <virtio_disk_init>
    userinit();      // first user process
    80000f00:	473000ef          	jal	80001b72 <userinit>
    log_message(LOG_INFO, "Welcome to AUT MCS Principles of Operating Systems Course. This message is from a custom logger implemented by Dorsa Rezaei and Parnian Shamsa");
    80000f04:	00006597          	auipc	a1,0x6
    80000f08:	19458593          	addi	a1,a1,404 # 80007098 <etext+0x98>
    80000f0c:	4501                	li	a0,0
    80000f0e:	3f4040ef          	jal	80005302 <log_message>
    log_message(LOG_WARN, "This is a test warning message for the custom logger");
    80000f12:	00006597          	auipc	a1,0x6
    80000f16:	21658593          	addi	a1,a1,534 # 80007128 <etext+0x128>
    80000f1a:	4505                	li	a0,1
    80000f1c:	3e6040ef          	jal	80005302 <log_message>
    log_message(LOG_ERROR, "This is a test error message for the custom logger");
    80000f20:	00006597          	auipc	a1,0x6
    80000f24:	24058593          	addi	a1,a1,576 # 80007160 <etext+0x160>
    80000f28:	4509                	li	a0,2
    80000f2a:	3d8040ef          	jal	80005302 <log_message>
    __sync_synchronize();
    80000f2e:	0ff0000f          	fence
    started = 1;
    80000f32:	4785                	li	a5,1
    80000f34:	00007717          	auipc	a4,0x7
    80000f38:	b0f72223          	sw	a5,-1276(a4) # 80007a38 <started>
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
    80000f4c:	af87b783          	ld	a5,-1288(a5) # 80007a40 <kernel_pagetable>
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
    80000fba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde24f>
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
    800011d8:	86a7b623          	sd	a0,-1940(a5) # 80007a40 <kernel_pagetable>
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
    800017aa:	80a48493          	addi	s1,s1,-2038 # 8000ffb0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017ae:	8b26                	mv	s6,s1
    800017b0:	04fa5937          	lui	s2,0x4fa5
    800017b4:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800017b8:	0932                	slli	s2,s2,0xc
    800017ba:	fa590913          	addi	s2,s2,-91
    800017be:	0932                	slli	s2,s2,0xc
    800017c0:	fa590913          	addi	s2,s2,-91
    800017c4:	0932                	slli	s2,s2,0xc
    800017c6:	fa590913          	addi	s2,s2,-91
    800017ca:	040009b7          	lui	s3,0x4000
    800017ce:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017d0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d2:	00014a97          	auipc	s5,0x14
    800017d6:	1dea8a93          	addi	s5,s5,478 # 800159b0 <tickslock>
    char *pa = kalloc();
    800017da:	b4aff0ef          	jal	80000b24 <kalloc>
    800017de:	862a                	mv	a2,a0
    if(pa == 0)
    800017e0:	cd15                	beqz	a0,8000181c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017e2:	416485b3          	sub	a1,s1,s6
    800017e6:	858d                	srai	a1,a1,0x3
    800017e8:	032585b3          	mul	a1,a1,s2
    800017ec:	2585                	addiw	a1,a1,1
    800017ee:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017f2:	4719                	li	a4,6
    800017f4:	6685                	lui	a3,0x1
    800017f6:	40b985b3          	sub	a1,s3,a1
    800017fa:	8552                	mv	a0,s4
    800017fc:	8f3ff0ef          	jal	800010ee <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001800:	16848493          	addi	s1,s1,360
    80001804:	fd549be3          	bne	s1,s5,800017da <proc_mapstacks+0x4a>
  }
}
    80001808:	70e2                	ld	ra,56(sp)
    8000180a:	7442                	ld	s0,48(sp)
    8000180c:	74a2                	ld	s1,40(sp)
    8000180e:	7902                	ld	s2,32(sp)
    80001810:	69e2                	ld	s3,24(sp)
    80001812:	6a42                	ld	s4,16(sp)
    80001814:	6aa2                	ld	s5,8(sp)
    80001816:	6b02                	ld	s6,0(sp)
    80001818:	6121                	addi	sp,sp,64
    8000181a:	8082                	ret
      panic("kalloc");
    8000181c:	00006517          	auipc	a0,0x6
    80001820:	adc50513          	addi	a0,a0,-1316 # 800072f8 <etext+0x2f8>
    80001824:	f71fe0ef          	jal	80000794 <panic>

0000000080001828 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001828:	7139                	addi	sp,sp,-64
    8000182a:	fc06                	sd	ra,56(sp)
    8000182c:	f822                	sd	s0,48(sp)
    8000182e:	f426                	sd	s1,40(sp)
    80001830:	f04a                	sd	s2,32(sp)
    80001832:	ec4e                	sd	s3,24(sp)
    80001834:	e852                	sd	s4,16(sp)
    80001836:	e456                	sd	s5,8(sp)
    80001838:	e05a                	sd	s6,0(sp)
    8000183a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000183c:	00006597          	auipc	a1,0x6
    80001840:	ac458593          	addi	a1,a1,-1340 # 80007300 <etext+0x300>
    80001844:	0000e517          	auipc	a0,0xe
    80001848:	33c50513          	addi	a0,a0,828 # 8000fb80 <pid_lock>
    8000184c:	b28ff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001850:	00006597          	auipc	a1,0x6
    80001854:	ab858593          	addi	a1,a1,-1352 # 80007308 <etext+0x308>
    80001858:	0000e517          	auipc	a0,0xe
    8000185c:	34050513          	addi	a0,a0,832 # 8000fb98 <wait_lock>
    80001860:	b14ff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001864:	0000e497          	auipc	s1,0xe
    80001868:	74c48493          	addi	s1,s1,1868 # 8000ffb0 <proc>
      initlock(&p->lock, "proc");
    8000186c:	00006b17          	auipc	s6,0x6
    80001870:	aacb0b13          	addi	s6,s6,-1364 # 80007318 <etext+0x318>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001874:	8aa6                	mv	s5,s1
    80001876:	04fa5937          	lui	s2,0x4fa5
    8000187a:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000187e:	0932                	slli	s2,s2,0xc
    80001880:	fa590913          	addi	s2,s2,-91
    80001884:	0932                	slli	s2,s2,0xc
    80001886:	fa590913          	addi	s2,s2,-91
    8000188a:	0932                	slli	s2,s2,0xc
    8000188c:	fa590913          	addi	s2,s2,-91
    80001890:	040009b7          	lui	s3,0x4000
    80001894:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001896:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001898:	00014a17          	auipc	s4,0x14
    8000189c:	118a0a13          	addi	s4,s4,280 # 800159b0 <tickslock>
      initlock(&p->lock, "proc");
    800018a0:	85da                	mv	a1,s6
    800018a2:	8526                	mv	a0,s1
    800018a4:	ad0ff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    800018a8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018ac:	415487b3          	sub	a5,s1,s5
    800018b0:	878d                	srai	a5,a5,0x3
    800018b2:	032787b3          	mul	a5,a5,s2
    800018b6:	2785                	addiw	a5,a5,1
    800018b8:	00d7979b          	slliw	a5,a5,0xd
    800018bc:	40f987b3          	sub	a5,s3,a5
    800018c0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c2:	16848493          	addi	s1,s1,360
    800018c6:	fd449de3          	bne	s1,s4,800018a0 <procinit+0x78>
  }
}
    800018ca:	70e2                	ld	ra,56(sp)
    800018cc:	7442                	ld	s0,48(sp)
    800018ce:	74a2                	ld	s1,40(sp)
    800018d0:	7902                	ld	s2,32(sp)
    800018d2:	69e2                	ld	s3,24(sp)
    800018d4:	6a42                	ld	s4,16(sp)
    800018d6:	6aa2                	ld	s5,8(sp)
    800018d8:	6b02                	ld	s6,0(sp)
    800018da:	6121                	addi	sp,sp,64
    800018dc:	8082                	ret

00000000800018de <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018de:	1141                	addi	sp,sp,-16
    800018e0:	e422                	sd	s0,8(sp)
    800018e2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018e4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018e6:	2501                	sext.w	a0,a0
    800018e8:	6422                	ld	s0,8(sp)
    800018ea:	0141                	addi	sp,sp,16
    800018ec:	8082                	ret

00000000800018ee <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018ee:	1141                	addi	sp,sp,-16
    800018f0:	e422                	sd	s0,8(sp)
    800018f2:	0800                	addi	s0,sp,16
    800018f4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018f6:	2781                	sext.w	a5,a5
    800018f8:	079e                	slli	a5,a5,0x7
  return c;
}
    800018fa:	0000e517          	auipc	a0,0xe
    800018fe:	2b650513          	addi	a0,a0,694 # 8000fbb0 <cpus>
    80001902:	953e                	add	a0,a0,a5
    80001904:	6422                	ld	s0,8(sp)
    80001906:	0141                	addi	sp,sp,16
    80001908:	8082                	ret

000000008000190a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000190a:	1101                	addi	sp,sp,-32
    8000190c:	ec06                	sd	ra,24(sp)
    8000190e:	e822                	sd	s0,16(sp)
    80001910:	e426                	sd	s1,8(sp)
    80001912:	1000                	addi	s0,sp,32
  push_off();
    80001914:	aa0ff0ef          	jal	80000bb4 <push_off>
    80001918:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000191a:	2781                	sext.w	a5,a5
    8000191c:	079e                	slli	a5,a5,0x7
    8000191e:	0000e717          	auipc	a4,0xe
    80001922:	26270713          	addi	a4,a4,610 # 8000fb80 <pid_lock>
    80001926:	97ba                	add	a5,a5,a4
    80001928:	7b84                	ld	s1,48(a5)
  pop_off();
    8000192a:	b0eff0ef          	jal	80000c38 <pop_off>
  return p;
}
    8000192e:	8526                	mv	a0,s1
    80001930:	60e2                	ld	ra,24(sp)
    80001932:	6442                	ld	s0,16(sp)
    80001934:	64a2                	ld	s1,8(sp)
    80001936:	6105                	addi	sp,sp,32
    80001938:	8082                	ret

000000008000193a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000193a:	1141                	addi	sp,sp,-16
    8000193c:	e406                	sd	ra,8(sp)
    8000193e:	e022                	sd	s0,0(sp)
    80001940:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001942:	fc9ff0ef          	jal	8000190a <myproc>
    80001946:	b46ff0ef          	jal	80000c8c <release>

  if (first) {
    8000194a:	00006797          	auipc	a5,0x6
    8000194e:	0867a783          	lw	a5,134(a5) # 800079d0 <first.1>
    80001952:	e799                	bnez	a5,80001960 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001954:	2bf000ef          	jal	80002412 <usertrapret>
}
    80001958:	60a2                	ld	ra,8(sp)
    8000195a:	6402                	ld	s0,0(sp)
    8000195c:	0141                	addi	sp,sp,16
    8000195e:	8082                	ret
    fsinit(ROOTDEV);
    80001960:	4505                	li	a0,1
    80001962:	654010ef          	jal	80002fb6 <fsinit>
    first = 0;
    80001966:	00006797          	auipc	a5,0x6
    8000196a:	0607a523          	sw	zero,106(a5) # 800079d0 <first.1>
    __sync_synchronize();
    8000196e:	0ff0000f          	fence
    80001972:	b7cd                	j	80001954 <forkret+0x1a>

0000000080001974 <allocpid>:
{
    80001974:	1101                	addi	sp,sp,-32
    80001976:	ec06                	sd	ra,24(sp)
    80001978:	e822                	sd	s0,16(sp)
    8000197a:	e426                	sd	s1,8(sp)
    8000197c:	e04a                	sd	s2,0(sp)
    8000197e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001980:	0000e917          	auipc	s2,0xe
    80001984:	20090913          	addi	s2,s2,512 # 8000fb80 <pid_lock>
    80001988:	854a                	mv	a0,s2
    8000198a:	a6aff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    8000198e:	00006797          	auipc	a5,0x6
    80001992:	04678793          	addi	a5,a5,70 # 800079d4 <nextpid>
    80001996:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001998:	0014871b          	addiw	a4,s1,1
    8000199c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000199e:	854a                	mv	a0,s2
    800019a0:	aecff0ef          	jal	80000c8c <release>
}
    800019a4:	8526                	mv	a0,s1
    800019a6:	60e2                	ld	ra,24(sp)
    800019a8:	6442                	ld	s0,16(sp)
    800019aa:	64a2                	ld	s1,8(sp)
    800019ac:	6902                	ld	s2,0(sp)
    800019ae:	6105                	addi	sp,sp,32
    800019b0:	8082                	ret

00000000800019b2 <proc_pagetable>:
{
    800019b2:	1101                	addi	sp,sp,-32
    800019b4:	ec06                	sd	ra,24(sp)
    800019b6:	e822                	sd	s0,16(sp)
    800019b8:	e426                	sd	s1,8(sp)
    800019ba:	e04a                	sd	s2,0(sp)
    800019bc:	1000                	addi	s0,sp,32
    800019be:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019c0:	8e1ff0ef          	jal	800012a0 <uvmcreate>
    800019c4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019c6:	cd05                	beqz	a0,800019fe <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019c8:	4729                	li	a4,10
    800019ca:	00004697          	auipc	a3,0x4
    800019ce:	63668693          	addi	a3,a3,1590 # 80006000 <_trampoline>
    800019d2:	6605                	lui	a2,0x1
    800019d4:	040005b7          	lui	a1,0x4000
    800019d8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019da:	05b2                	slli	a1,a1,0xc
    800019dc:	e62ff0ef          	jal	8000103e <mappages>
    800019e0:	02054663          	bltz	a0,80001a0c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019e4:	4719                	li	a4,6
    800019e6:	05893683          	ld	a3,88(s2)
    800019ea:	6605                	lui	a2,0x1
    800019ec:	020005b7          	lui	a1,0x2000
    800019f0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019f2:	05b6                	slli	a1,a1,0xd
    800019f4:	8526                	mv	a0,s1
    800019f6:	e48ff0ef          	jal	8000103e <mappages>
    800019fa:	00054f63          	bltz	a0,80001a18 <proc_pagetable+0x66>
}
    800019fe:	8526                	mv	a0,s1
    80001a00:	60e2                	ld	ra,24(sp)
    80001a02:	6442                	ld	s0,16(sp)
    80001a04:	64a2                	ld	s1,8(sp)
    80001a06:	6902                	ld	s2,0(sp)
    80001a08:	6105                	addi	sp,sp,32
    80001a0a:	8082                	ret
    uvmfree(pagetable, 0);
    80001a0c:	4581                	li	a1,0
    80001a0e:	8526                	mv	a0,s1
    80001a10:	a5fff0ef          	jal	8000146e <uvmfree>
    return 0;
    80001a14:	4481                	li	s1,0
    80001a16:	b7e5                	j	800019fe <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a18:	4681                	li	a3,0
    80001a1a:	4605                	li	a2,1
    80001a1c:	040005b7          	lui	a1,0x4000
    80001a20:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a22:	05b2                	slli	a1,a1,0xc
    80001a24:	8526                	mv	a0,s1
    80001a26:	fbeff0ef          	jal	800011e4 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a2a:	4581                	li	a1,0
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	a41ff0ef          	jal	8000146e <uvmfree>
    return 0;
    80001a32:	4481                	li	s1,0
    80001a34:	b7e9                	j	800019fe <proc_pagetable+0x4c>

0000000080001a36 <proc_freepagetable>:
{
    80001a36:	1101                	addi	sp,sp,-32
    80001a38:	ec06                	sd	ra,24(sp)
    80001a3a:	e822                	sd	s0,16(sp)
    80001a3c:	e426                	sd	s1,8(sp)
    80001a3e:	e04a                	sd	s2,0(sp)
    80001a40:	1000                	addi	s0,sp,32
    80001a42:	84aa                	mv	s1,a0
    80001a44:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a46:	4681                	li	a3,0
    80001a48:	4605                	li	a2,1
    80001a4a:	040005b7          	lui	a1,0x4000
    80001a4e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a50:	05b2                	slli	a1,a1,0xc
    80001a52:	f92ff0ef          	jal	800011e4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a56:	4681                	li	a3,0
    80001a58:	4605                	li	a2,1
    80001a5a:	020005b7          	lui	a1,0x2000
    80001a5e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a60:	05b6                	slli	a1,a1,0xd
    80001a62:	8526                	mv	a0,s1
    80001a64:	f80ff0ef          	jal	800011e4 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a68:	85ca                	mv	a1,s2
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	a03ff0ef          	jal	8000146e <uvmfree>
}
    80001a70:	60e2                	ld	ra,24(sp)
    80001a72:	6442                	ld	s0,16(sp)
    80001a74:	64a2                	ld	s1,8(sp)
    80001a76:	6902                	ld	s2,0(sp)
    80001a78:	6105                	addi	sp,sp,32
    80001a7a:	8082                	ret

0000000080001a7c <freeproc>:
{
    80001a7c:	1101                	addi	sp,sp,-32
    80001a7e:	ec06                	sd	ra,24(sp)
    80001a80:	e822                	sd	s0,16(sp)
    80001a82:	e426                	sd	s1,8(sp)
    80001a84:	1000                	addi	s0,sp,32
    80001a86:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a88:	6d28                	ld	a0,88(a0)
    80001a8a:	c119                	beqz	a0,80001a90 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a8c:	fb7fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001a90:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a94:	68a8                	ld	a0,80(s1)
    80001a96:	c501                	beqz	a0,80001a9e <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a98:	64ac                	ld	a1,72(s1)
    80001a9a:	f9dff0ef          	jal	80001a36 <proc_freepagetable>
  p->pagetable = 0;
    80001a9e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001aa2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001aa6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001aaa:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001aae:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ab2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ab6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001aba:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001abe:	0004ac23          	sw	zero,24(s1)
}
    80001ac2:	60e2                	ld	ra,24(sp)
    80001ac4:	6442                	ld	s0,16(sp)
    80001ac6:	64a2                	ld	s1,8(sp)
    80001ac8:	6105                	addi	sp,sp,32
    80001aca:	8082                	ret

0000000080001acc <allocproc>:
{
    80001acc:	1101                	addi	sp,sp,-32
    80001ace:	ec06                	sd	ra,24(sp)
    80001ad0:	e822                	sd	s0,16(sp)
    80001ad2:	e426                	sd	s1,8(sp)
    80001ad4:	e04a                	sd	s2,0(sp)
    80001ad6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ad8:	0000e497          	auipc	s1,0xe
    80001adc:	4d848493          	addi	s1,s1,1240 # 8000ffb0 <proc>
    80001ae0:	00014917          	auipc	s2,0x14
    80001ae4:	ed090913          	addi	s2,s2,-304 # 800159b0 <tickslock>
    acquire(&p->lock);
    80001ae8:	8526                	mv	a0,s1
    80001aea:	90aff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001aee:	4c9c                	lw	a5,24(s1)
    80001af0:	cb91                	beqz	a5,80001b04 <allocproc+0x38>
      release(&p->lock);
    80001af2:	8526                	mv	a0,s1
    80001af4:	998ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001af8:	16848493          	addi	s1,s1,360
    80001afc:	ff2496e3          	bne	s1,s2,80001ae8 <allocproc+0x1c>
  return 0;
    80001b00:	4481                	li	s1,0
    80001b02:	a089                	j	80001b44 <allocproc+0x78>
  p->pid = allocpid();
    80001b04:	e71ff0ef          	jal	80001974 <allocpid>
    80001b08:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b0a:	4785                	li	a5,1
    80001b0c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b0e:	816ff0ef          	jal	80000b24 <kalloc>
    80001b12:	892a                	mv	s2,a0
    80001b14:	eca8                	sd	a0,88(s1)
    80001b16:	cd15                	beqz	a0,80001b52 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b18:	8526                	mv	a0,s1
    80001b1a:	e99ff0ef          	jal	800019b2 <proc_pagetable>
    80001b1e:	892a                	mv	s2,a0
    80001b20:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b22:	c121                	beqz	a0,80001b62 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b24:	07000613          	li	a2,112
    80001b28:	4581                	li	a1,0
    80001b2a:	06048513          	addi	a0,s1,96
    80001b2e:	99aff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001b32:	00000797          	auipc	a5,0x0
    80001b36:	e0878793          	addi	a5,a5,-504 # 8000193a <forkret>
    80001b3a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b3c:	60bc                	ld	a5,64(s1)
    80001b3e:	6705                	lui	a4,0x1
    80001b40:	97ba                	add	a5,a5,a4
    80001b42:	f4bc                	sd	a5,104(s1)
}
    80001b44:	8526                	mv	a0,s1
    80001b46:	60e2                	ld	ra,24(sp)
    80001b48:	6442                	ld	s0,16(sp)
    80001b4a:	64a2                	ld	s1,8(sp)
    80001b4c:	6902                	ld	s2,0(sp)
    80001b4e:	6105                	addi	sp,sp,32
    80001b50:	8082                	ret
    freeproc(p);
    80001b52:	8526                	mv	a0,s1
    80001b54:	f29ff0ef          	jal	80001a7c <freeproc>
    release(&p->lock);
    80001b58:	8526                	mv	a0,s1
    80001b5a:	932ff0ef          	jal	80000c8c <release>
    return 0;
    80001b5e:	84ca                	mv	s1,s2
    80001b60:	b7d5                	j	80001b44 <allocproc+0x78>
    freeproc(p);
    80001b62:	8526                	mv	a0,s1
    80001b64:	f19ff0ef          	jal	80001a7c <freeproc>
    release(&p->lock);
    80001b68:	8526                	mv	a0,s1
    80001b6a:	922ff0ef          	jal	80000c8c <release>
    return 0;
    80001b6e:	84ca                	mv	s1,s2
    80001b70:	bfd1                	j	80001b44 <allocproc+0x78>

0000000080001b72 <userinit>:
{
    80001b72:	1101                	addi	sp,sp,-32
    80001b74:	ec06                	sd	ra,24(sp)
    80001b76:	e822                	sd	s0,16(sp)
    80001b78:	e426                	sd	s1,8(sp)
    80001b7a:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b7c:	f51ff0ef          	jal	80001acc <allocproc>
    80001b80:	84aa                	mv	s1,a0
  initproc = p;
    80001b82:	00006797          	auipc	a5,0x6
    80001b86:	eca7b323          	sd	a0,-314(a5) # 80007a48 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b8a:	03400613          	li	a2,52
    80001b8e:	00006597          	auipc	a1,0x6
    80001b92:	e5258593          	addi	a1,a1,-430 # 800079e0 <initcode>
    80001b96:	6928                	ld	a0,80(a0)
    80001b98:	f2eff0ef          	jal	800012c6 <uvmfirst>
  p->sz = PGSIZE;
    80001b9c:	6785                	lui	a5,0x1
    80001b9e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ba0:	6cb8                	ld	a4,88(s1)
    80001ba2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ba6:	6cb8                	ld	a4,88(s1)
    80001ba8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001baa:	4641                	li	a2,16
    80001bac:	00005597          	auipc	a1,0x5
    80001bb0:	77458593          	addi	a1,a1,1908 # 80007320 <etext+0x320>
    80001bb4:	15848513          	addi	a0,s1,344
    80001bb8:	a4eff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001bbc:	00005517          	auipc	a0,0x5
    80001bc0:	77450513          	addi	a0,a0,1908 # 80007330 <etext+0x330>
    80001bc4:	501010ef          	jal	800038c4 <namei>
    80001bc8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bcc:	478d                	li	a5,3
    80001bce:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	8baff0ef          	jal	80000c8c <release>
}
    80001bd6:	60e2                	ld	ra,24(sp)
    80001bd8:	6442                	ld	s0,16(sp)
    80001bda:	64a2                	ld	s1,8(sp)
    80001bdc:	6105                	addi	sp,sp,32
    80001bde:	8082                	ret

0000000080001be0 <growproc>:
{
    80001be0:	1101                	addi	sp,sp,-32
    80001be2:	ec06                	sd	ra,24(sp)
    80001be4:	e822                	sd	s0,16(sp)
    80001be6:	e426                	sd	s1,8(sp)
    80001be8:	e04a                	sd	s2,0(sp)
    80001bea:	1000                	addi	s0,sp,32
    80001bec:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bee:	d1dff0ef          	jal	8000190a <myproc>
    80001bf2:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bf4:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bf6:	01204c63          	bgtz	s2,80001c0e <growproc+0x2e>
  } else if(n < 0){
    80001bfa:	02094463          	bltz	s2,80001c22 <growproc+0x42>
  p->sz = sz;
    80001bfe:	e4ac                	sd	a1,72(s1)
  return 0;
    80001c00:	4501                	li	a0,0
}
    80001c02:	60e2                	ld	ra,24(sp)
    80001c04:	6442                	ld	s0,16(sp)
    80001c06:	64a2                	ld	s1,8(sp)
    80001c08:	6902                	ld	s2,0(sp)
    80001c0a:	6105                	addi	sp,sp,32
    80001c0c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c0e:	4691                	li	a3,4
    80001c10:	00b90633          	add	a2,s2,a1
    80001c14:	6928                	ld	a0,80(a0)
    80001c16:	f52ff0ef          	jal	80001368 <uvmalloc>
    80001c1a:	85aa                	mv	a1,a0
    80001c1c:	f16d                	bnez	a0,80001bfe <growproc+0x1e>
      return -1;
    80001c1e:	557d                	li	a0,-1
    80001c20:	b7cd                	j	80001c02 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c22:	00b90633          	add	a2,s2,a1
    80001c26:	6928                	ld	a0,80(a0)
    80001c28:	efcff0ef          	jal	80001324 <uvmdealloc>
    80001c2c:	85aa                	mv	a1,a0
    80001c2e:	bfc1                	j	80001bfe <growproc+0x1e>

0000000080001c30 <fork>:
{
    80001c30:	7139                	addi	sp,sp,-64
    80001c32:	fc06                	sd	ra,56(sp)
    80001c34:	f822                	sd	s0,48(sp)
    80001c36:	f04a                	sd	s2,32(sp)
    80001c38:	e456                	sd	s5,8(sp)
    80001c3a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c3c:	ccfff0ef          	jal	8000190a <myproc>
    80001c40:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c42:	e8bff0ef          	jal	80001acc <allocproc>
    80001c46:	0e050a63          	beqz	a0,80001d3a <fork+0x10a>
    80001c4a:	e852                	sd	s4,16(sp)
    80001c4c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c4e:	048ab603          	ld	a2,72(s5)
    80001c52:	692c                	ld	a1,80(a0)
    80001c54:	050ab503          	ld	a0,80(s5)
    80001c58:	849ff0ef          	jal	800014a0 <uvmcopy>
    80001c5c:	04054a63          	bltz	a0,80001cb0 <fork+0x80>
    80001c60:	f426                	sd	s1,40(sp)
    80001c62:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c64:	048ab783          	ld	a5,72(s5)
    80001c68:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c6c:	058ab683          	ld	a3,88(s5)
    80001c70:	87b6                	mv	a5,a3
    80001c72:	058a3703          	ld	a4,88(s4)
    80001c76:	12068693          	addi	a3,a3,288
    80001c7a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c7e:	6788                	ld	a0,8(a5)
    80001c80:	6b8c                	ld	a1,16(a5)
    80001c82:	6f90                	ld	a2,24(a5)
    80001c84:	01073023          	sd	a6,0(a4)
    80001c88:	e708                	sd	a0,8(a4)
    80001c8a:	eb0c                	sd	a1,16(a4)
    80001c8c:	ef10                	sd	a2,24(a4)
    80001c8e:	02078793          	addi	a5,a5,32
    80001c92:	02070713          	addi	a4,a4,32
    80001c96:	fed792e3          	bne	a5,a3,80001c7a <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c9a:	058a3783          	ld	a5,88(s4)
    80001c9e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001ca2:	0d0a8493          	addi	s1,s5,208
    80001ca6:	0d0a0913          	addi	s2,s4,208
    80001caa:	150a8993          	addi	s3,s5,336
    80001cae:	a831                	j	80001cca <fork+0x9a>
    freeproc(np);
    80001cb0:	8552                	mv	a0,s4
    80001cb2:	dcbff0ef          	jal	80001a7c <freeproc>
    release(&np->lock);
    80001cb6:	8552                	mv	a0,s4
    80001cb8:	fd5fe0ef          	jal	80000c8c <release>
    return -1;
    80001cbc:	597d                	li	s2,-1
    80001cbe:	6a42                	ld	s4,16(sp)
    80001cc0:	a0b5                	j	80001d2c <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001cc2:	04a1                	addi	s1,s1,8
    80001cc4:	0921                	addi	s2,s2,8
    80001cc6:	01348963          	beq	s1,s3,80001cd8 <fork+0xa8>
    if(p->ofile[i])
    80001cca:	6088                	ld	a0,0(s1)
    80001ccc:	d97d                	beqz	a0,80001cc2 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cce:	186020ef          	jal	80003e54 <filedup>
    80001cd2:	00a93023          	sd	a0,0(s2)
    80001cd6:	b7f5                	j	80001cc2 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cd8:	150ab503          	ld	a0,336(s5)
    80001cdc:	4d8010ef          	jal	800031b4 <idup>
    80001ce0:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ce4:	4641                	li	a2,16
    80001ce6:	158a8593          	addi	a1,s5,344
    80001cea:	158a0513          	addi	a0,s4,344
    80001cee:	918ff0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80001cf2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001cf6:	8552                	mv	a0,s4
    80001cf8:	f95fe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80001cfc:	0000e497          	auipc	s1,0xe
    80001d00:	e9c48493          	addi	s1,s1,-356 # 8000fb98 <wait_lock>
    80001d04:	8526                	mv	a0,s1
    80001d06:	eeffe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80001d0a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d0e:	8526                	mv	a0,s1
    80001d10:	f7dfe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80001d14:	8552                	mv	a0,s4
    80001d16:	edffe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80001d1a:	478d                	li	a5,3
    80001d1c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d20:	8552                	mv	a0,s4
    80001d22:	f6bfe0ef          	jal	80000c8c <release>
  return pid;
    80001d26:	74a2                	ld	s1,40(sp)
    80001d28:	69e2                	ld	s3,24(sp)
    80001d2a:	6a42                	ld	s4,16(sp)
}
    80001d2c:	854a                	mv	a0,s2
    80001d2e:	70e2                	ld	ra,56(sp)
    80001d30:	7442                	ld	s0,48(sp)
    80001d32:	7902                	ld	s2,32(sp)
    80001d34:	6aa2                	ld	s5,8(sp)
    80001d36:	6121                	addi	sp,sp,64
    80001d38:	8082                	ret
    return -1;
    80001d3a:	597d                	li	s2,-1
    80001d3c:	bfc5                	j	80001d2c <fork+0xfc>

0000000080001d3e <scheduler>:
{
    80001d3e:	715d                	addi	sp,sp,-80
    80001d40:	e486                	sd	ra,72(sp)
    80001d42:	e0a2                	sd	s0,64(sp)
    80001d44:	fc26                	sd	s1,56(sp)
    80001d46:	f84a                	sd	s2,48(sp)
    80001d48:	f44e                	sd	s3,40(sp)
    80001d4a:	f052                	sd	s4,32(sp)
    80001d4c:	ec56                	sd	s5,24(sp)
    80001d4e:	e85a                	sd	s6,16(sp)
    80001d50:	e45e                	sd	s7,8(sp)
    80001d52:	e062                	sd	s8,0(sp)
    80001d54:	0880                	addi	s0,sp,80
    80001d56:	8792                	mv	a5,tp
  int id = r_tp();
    80001d58:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d5a:	00779b13          	slli	s6,a5,0x7
    80001d5e:	0000e717          	auipc	a4,0xe
    80001d62:	e2270713          	addi	a4,a4,-478 # 8000fb80 <pid_lock>
    80001d66:	975a                	add	a4,a4,s6
    80001d68:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d6c:	0000e717          	auipc	a4,0xe
    80001d70:	e4c70713          	addi	a4,a4,-436 # 8000fbb8 <cpus+0x8>
    80001d74:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d76:	4c11                	li	s8,4
        c->proc = p;
    80001d78:	079e                	slli	a5,a5,0x7
    80001d7a:	0000ea17          	auipc	s4,0xe
    80001d7e:	e06a0a13          	addi	s4,s4,-506 # 8000fb80 <pid_lock>
    80001d82:	9a3e                	add	s4,s4,a5
        found = 1;
    80001d84:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d86:	00014997          	auipc	s3,0x14
    80001d8a:	c2a98993          	addi	s3,s3,-982 # 800159b0 <tickslock>
    80001d8e:	a0a9                	j	80001dd8 <scheduler+0x9a>
      release(&p->lock);
    80001d90:	8526                	mv	a0,s1
    80001d92:	efbfe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d96:	16848493          	addi	s1,s1,360
    80001d9a:	03348563          	beq	s1,s3,80001dc4 <scheduler+0x86>
      acquire(&p->lock);
    80001d9e:	8526                	mv	a0,s1
    80001da0:	e55fe0ef          	jal	80000bf4 <acquire>
      if(p->state == RUNNABLE) {
    80001da4:	4c9c                	lw	a5,24(s1)
    80001da6:	ff2795e3          	bne	a5,s2,80001d90 <scheduler+0x52>
        p->state = RUNNING;
    80001daa:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dae:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001db2:	06048593          	addi	a1,s1,96
    80001db6:	855a                	mv	a0,s6
    80001db8:	5b4000ef          	jal	8000236c <swtch>
        c->proc = 0;
    80001dbc:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001dc0:	8ade                	mv	s5,s7
    80001dc2:	b7f9                	j	80001d90 <scheduler+0x52>
    if(found == 0) {
    80001dc4:	000a9a63          	bnez	s5,80001dd8 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dcc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd0:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001dd4:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ddc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de0:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001de4:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001de6:	0000e497          	auipc	s1,0xe
    80001dea:	1ca48493          	addi	s1,s1,458 # 8000ffb0 <proc>
      if(p->state == RUNNABLE) {
    80001dee:	490d                	li	s2,3
    80001df0:	b77d                	j	80001d9e <scheduler+0x60>

0000000080001df2 <sched>:
{
    80001df2:	7179                	addi	sp,sp,-48
    80001df4:	f406                	sd	ra,40(sp)
    80001df6:	f022                	sd	s0,32(sp)
    80001df8:	ec26                	sd	s1,24(sp)
    80001dfa:	e84a                	sd	s2,16(sp)
    80001dfc:	e44e                	sd	s3,8(sp)
    80001dfe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e00:	b0bff0ef          	jal	8000190a <myproc>
    80001e04:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e06:	d85fe0ef          	jal	80000b8a <holding>
    80001e0a:	c92d                	beqz	a0,80001e7c <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e0c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e0e:	2781                	sext.w	a5,a5
    80001e10:	079e                	slli	a5,a5,0x7
    80001e12:	0000e717          	auipc	a4,0xe
    80001e16:	d6e70713          	addi	a4,a4,-658 # 8000fb80 <pid_lock>
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	0a87a703          	lw	a4,168(a5)
    80001e20:	4785                	li	a5,1
    80001e22:	06f71363          	bne	a4,a5,80001e88 <sched+0x96>
  if(p->state == RUNNING)
    80001e26:	4c98                	lw	a4,24(s1)
    80001e28:	4791                	li	a5,4
    80001e2a:	06f70563          	beq	a4,a5,80001e94 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e32:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e34:	e7b5                	bnez	a5,80001ea0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e36:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e38:	0000e917          	auipc	s2,0xe
    80001e3c:	d4890913          	addi	s2,s2,-696 # 8000fb80 <pid_lock>
    80001e40:	2781                	sext.w	a5,a5
    80001e42:	079e                	slli	a5,a5,0x7
    80001e44:	97ca                	add	a5,a5,s2
    80001e46:	0ac7a983          	lw	s3,172(a5)
    80001e4a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e4c:	2781                	sext.w	a5,a5
    80001e4e:	079e                	slli	a5,a5,0x7
    80001e50:	0000e597          	auipc	a1,0xe
    80001e54:	d6858593          	addi	a1,a1,-664 # 8000fbb8 <cpus+0x8>
    80001e58:	95be                	add	a1,a1,a5
    80001e5a:	06048513          	addi	a0,s1,96
    80001e5e:	50e000ef          	jal	8000236c <swtch>
    80001e62:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e64:	2781                	sext.w	a5,a5
    80001e66:	079e                	slli	a5,a5,0x7
    80001e68:	993e                	add	s2,s2,a5
    80001e6a:	0b392623          	sw	s3,172(s2)
}
    80001e6e:	70a2                	ld	ra,40(sp)
    80001e70:	7402                	ld	s0,32(sp)
    80001e72:	64e2                	ld	s1,24(sp)
    80001e74:	6942                	ld	s2,16(sp)
    80001e76:	69a2                	ld	s3,8(sp)
    80001e78:	6145                	addi	sp,sp,48
    80001e7a:	8082                	ret
    panic("sched p->lock");
    80001e7c:	00005517          	auipc	a0,0x5
    80001e80:	4bc50513          	addi	a0,a0,1212 # 80007338 <etext+0x338>
    80001e84:	911fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001e88:	00005517          	auipc	a0,0x5
    80001e8c:	4c050513          	addi	a0,a0,1216 # 80007348 <etext+0x348>
    80001e90:	905fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001e94:	00005517          	auipc	a0,0x5
    80001e98:	4c450513          	addi	a0,a0,1220 # 80007358 <etext+0x358>
    80001e9c:	8f9fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001ea0:	00005517          	auipc	a0,0x5
    80001ea4:	4c850513          	addi	a0,a0,1224 # 80007368 <etext+0x368>
    80001ea8:	8edfe0ef          	jal	80000794 <panic>

0000000080001eac <yield>:
{
    80001eac:	1101                	addi	sp,sp,-32
    80001eae:	ec06                	sd	ra,24(sp)
    80001eb0:	e822                	sd	s0,16(sp)
    80001eb2:	e426                	sd	s1,8(sp)
    80001eb4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001eb6:	a55ff0ef          	jal	8000190a <myproc>
    80001eba:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ebc:	d39fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001ec0:	478d                	li	a5,3
    80001ec2:	cc9c                	sw	a5,24(s1)
  sched();
    80001ec4:	f2fff0ef          	jal	80001df2 <sched>
  release(&p->lock);
    80001ec8:	8526                	mv	a0,s1
    80001eca:	dc3fe0ef          	jal	80000c8c <release>
}
    80001ece:	60e2                	ld	ra,24(sp)
    80001ed0:	6442                	ld	s0,16(sp)
    80001ed2:	64a2                	ld	s1,8(sp)
    80001ed4:	6105                	addi	sp,sp,32
    80001ed6:	8082                	ret

0000000080001ed8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ed8:	7179                	addi	sp,sp,-48
    80001eda:	f406                	sd	ra,40(sp)
    80001edc:	f022                	sd	s0,32(sp)
    80001ede:	ec26                	sd	s1,24(sp)
    80001ee0:	e84a                	sd	s2,16(sp)
    80001ee2:	e44e                	sd	s3,8(sp)
    80001ee4:	1800                	addi	s0,sp,48
    80001ee6:	89aa                	mv	s3,a0
    80001ee8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eea:	a21ff0ef          	jal	8000190a <myproc>
    80001eee:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001ef0:	d05fe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001ef4:	854a                	mv	a0,s2
    80001ef6:	d97fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001efa:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001efe:	4789                	li	a5,2
    80001f00:	cc9c                	sw	a5,24(s1)

  sched();
    80001f02:	ef1ff0ef          	jal	80001df2 <sched>

  // Tidy up.
  p->chan = 0;
    80001f06:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	d81fe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001f10:	854a                	mv	a0,s2
    80001f12:	ce3fe0ef          	jal	80000bf4 <acquire>
}
    80001f16:	70a2                	ld	ra,40(sp)
    80001f18:	7402                	ld	s0,32(sp)
    80001f1a:	64e2                	ld	s1,24(sp)
    80001f1c:	6942                	ld	s2,16(sp)
    80001f1e:	69a2                	ld	s3,8(sp)
    80001f20:	6145                	addi	sp,sp,48
    80001f22:	8082                	ret

0000000080001f24 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001f24:	7139                	addi	sp,sp,-64
    80001f26:	fc06                	sd	ra,56(sp)
    80001f28:	f822                	sd	s0,48(sp)
    80001f2a:	f426                	sd	s1,40(sp)
    80001f2c:	f04a                	sd	s2,32(sp)
    80001f2e:	ec4e                	sd	s3,24(sp)
    80001f30:	e852                	sd	s4,16(sp)
    80001f32:	e456                	sd	s5,8(sp)
    80001f34:	0080                	addi	s0,sp,64
    80001f36:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f38:	0000e497          	auipc	s1,0xe
    80001f3c:	07848493          	addi	s1,s1,120 # 8000ffb0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f40:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f42:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f44:	00014917          	auipc	s2,0x14
    80001f48:	a6c90913          	addi	s2,s2,-1428 # 800159b0 <tickslock>
    80001f4c:	a801                	j	80001f5c <wakeup+0x38>
      }
      release(&p->lock);
    80001f4e:	8526                	mv	a0,s1
    80001f50:	d3dfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f54:	16848493          	addi	s1,s1,360
    80001f58:	03248263          	beq	s1,s2,80001f7c <wakeup+0x58>
    if(p != myproc()){
    80001f5c:	9afff0ef          	jal	8000190a <myproc>
    80001f60:	fea48ae3          	beq	s1,a0,80001f54 <wakeup+0x30>
      acquire(&p->lock);
    80001f64:	8526                	mv	a0,s1
    80001f66:	c8ffe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f6a:	4c9c                	lw	a5,24(s1)
    80001f6c:	ff3791e3          	bne	a5,s3,80001f4e <wakeup+0x2a>
    80001f70:	709c                	ld	a5,32(s1)
    80001f72:	fd479ee3          	bne	a5,s4,80001f4e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f76:	0154ac23          	sw	s5,24(s1)
    80001f7a:	bfd1                	j	80001f4e <wakeup+0x2a>
    }
  }
}
    80001f7c:	70e2                	ld	ra,56(sp)
    80001f7e:	7442                	ld	s0,48(sp)
    80001f80:	74a2                	ld	s1,40(sp)
    80001f82:	7902                	ld	s2,32(sp)
    80001f84:	69e2                	ld	s3,24(sp)
    80001f86:	6a42                	ld	s4,16(sp)
    80001f88:	6aa2                	ld	s5,8(sp)
    80001f8a:	6121                	addi	sp,sp,64
    80001f8c:	8082                	ret

0000000080001f8e <reparent>:
{
    80001f8e:	7179                	addi	sp,sp,-48
    80001f90:	f406                	sd	ra,40(sp)
    80001f92:	f022                	sd	s0,32(sp)
    80001f94:	ec26                	sd	s1,24(sp)
    80001f96:	e84a                	sd	s2,16(sp)
    80001f98:	e44e                	sd	s3,8(sp)
    80001f9a:	e052                	sd	s4,0(sp)
    80001f9c:	1800                	addi	s0,sp,48
    80001f9e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fa0:	0000e497          	auipc	s1,0xe
    80001fa4:	01048493          	addi	s1,s1,16 # 8000ffb0 <proc>
      pp->parent = initproc;
    80001fa8:	00006a17          	auipc	s4,0x6
    80001fac:	aa0a0a13          	addi	s4,s4,-1376 # 80007a48 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fb0:	00014997          	auipc	s3,0x14
    80001fb4:	a0098993          	addi	s3,s3,-1536 # 800159b0 <tickslock>
    80001fb8:	a029                	j	80001fc2 <reparent+0x34>
    80001fba:	16848493          	addi	s1,s1,360
    80001fbe:	01348b63          	beq	s1,s3,80001fd4 <reparent+0x46>
    if(pp->parent == p){
    80001fc2:	7c9c                	ld	a5,56(s1)
    80001fc4:	ff279be3          	bne	a5,s2,80001fba <reparent+0x2c>
      pp->parent = initproc;
    80001fc8:	000a3503          	ld	a0,0(s4)
    80001fcc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fce:	f57ff0ef          	jal	80001f24 <wakeup>
    80001fd2:	b7e5                	j	80001fba <reparent+0x2c>
}
    80001fd4:	70a2                	ld	ra,40(sp)
    80001fd6:	7402                	ld	s0,32(sp)
    80001fd8:	64e2                	ld	s1,24(sp)
    80001fda:	6942                	ld	s2,16(sp)
    80001fdc:	69a2                	ld	s3,8(sp)
    80001fde:	6a02                	ld	s4,0(sp)
    80001fe0:	6145                	addi	sp,sp,48
    80001fe2:	8082                	ret

0000000080001fe4 <exit>:
{
    80001fe4:	7179                	addi	sp,sp,-48
    80001fe6:	f406                	sd	ra,40(sp)
    80001fe8:	f022                	sd	s0,32(sp)
    80001fea:	ec26                	sd	s1,24(sp)
    80001fec:	e84a                	sd	s2,16(sp)
    80001fee:	e44e                	sd	s3,8(sp)
    80001ff0:	e052                	sd	s4,0(sp)
    80001ff2:	1800                	addi	s0,sp,48
    80001ff4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001ff6:	915ff0ef          	jal	8000190a <myproc>
    80001ffa:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ffc:	00006797          	auipc	a5,0x6
    80002000:	a4c7b783          	ld	a5,-1460(a5) # 80007a48 <initproc>
    80002004:	0d050493          	addi	s1,a0,208
    80002008:	15050913          	addi	s2,a0,336
    8000200c:	00a79f63          	bne	a5,a0,8000202a <exit+0x46>
    panic("init exiting");
    80002010:	00005517          	auipc	a0,0x5
    80002014:	37050513          	addi	a0,a0,880 # 80007380 <etext+0x380>
    80002018:	f7cfe0ef          	jal	80000794 <panic>
      fileclose(f);
    8000201c:	67f010ef          	jal	80003e9a <fileclose>
      p->ofile[fd] = 0;
    80002020:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002024:	04a1                	addi	s1,s1,8
    80002026:	01248563          	beq	s1,s2,80002030 <exit+0x4c>
    if(p->ofile[fd]){
    8000202a:	6088                	ld	a0,0(s1)
    8000202c:	f965                	bnez	a0,8000201c <exit+0x38>
    8000202e:	bfdd                	j	80002024 <exit+0x40>
  begin_op();
    80002030:	251010ef          	jal	80003a80 <begin_op>
  iput(p->cwd);
    80002034:	1509b503          	ld	a0,336(s3)
    80002038:	334010ef          	jal	8000336c <iput>
  end_op();
    8000203c:	2af010ef          	jal	80003aea <end_op>
  p->cwd = 0;
    80002040:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002044:	0000e497          	auipc	s1,0xe
    80002048:	b5448493          	addi	s1,s1,-1196 # 8000fb98 <wait_lock>
    8000204c:	8526                	mv	a0,s1
    8000204e:	ba7fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    80002052:	854e                	mv	a0,s3
    80002054:	f3bff0ef          	jal	80001f8e <reparent>
  wakeup(p->parent);
    80002058:	0389b503          	ld	a0,56(s3)
    8000205c:	ec9ff0ef          	jal	80001f24 <wakeup>
  acquire(&p->lock);
    80002060:	854e                	mv	a0,s3
    80002062:	b93fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    80002066:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000206a:	4795                	li	a5,5
    8000206c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002070:	8526                	mv	a0,s1
    80002072:	c1bfe0ef          	jal	80000c8c <release>
  sched();
    80002076:	d7dff0ef          	jal	80001df2 <sched>
  panic("zombie exit");
    8000207a:	00005517          	auipc	a0,0x5
    8000207e:	31650513          	addi	a0,a0,790 # 80007390 <etext+0x390>
    80002082:	f12fe0ef          	jal	80000794 <panic>

0000000080002086 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002086:	7179                	addi	sp,sp,-48
    80002088:	f406                	sd	ra,40(sp)
    8000208a:	f022                	sd	s0,32(sp)
    8000208c:	ec26                	sd	s1,24(sp)
    8000208e:	e84a                	sd	s2,16(sp)
    80002090:	e44e                	sd	s3,8(sp)
    80002092:	1800                	addi	s0,sp,48
    80002094:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002096:	0000e497          	auipc	s1,0xe
    8000209a:	f1a48493          	addi	s1,s1,-230 # 8000ffb0 <proc>
    8000209e:	00014997          	auipc	s3,0x14
    800020a2:	91298993          	addi	s3,s3,-1774 # 800159b0 <tickslock>
    acquire(&p->lock);
    800020a6:	8526                	mv	a0,s1
    800020a8:	b4dfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    800020ac:	589c                	lw	a5,48(s1)
    800020ae:	01278b63          	beq	a5,s2,800020c4 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020b2:	8526                	mv	a0,s1
    800020b4:	bd9fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800020b8:	16848493          	addi	s1,s1,360
    800020bc:	ff3495e3          	bne	s1,s3,800020a6 <kill+0x20>
  }
  return -1;
    800020c0:	557d                	li	a0,-1
    800020c2:	a819                	j	800020d8 <kill+0x52>
      p->killed = 1;
    800020c4:	4785                	li	a5,1
    800020c6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800020c8:	4c98                	lw	a4,24(s1)
    800020ca:	4789                	li	a5,2
    800020cc:	00f70d63          	beq	a4,a5,800020e6 <kill+0x60>
      release(&p->lock);
    800020d0:	8526                	mv	a0,s1
    800020d2:	bbbfe0ef          	jal	80000c8c <release>
      return 0;
    800020d6:	4501                	li	a0,0
}
    800020d8:	70a2                	ld	ra,40(sp)
    800020da:	7402                	ld	s0,32(sp)
    800020dc:	64e2                	ld	s1,24(sp)
    800020de:	6942                	ld	s2,16(sp)
    800020e0:	69a2                	ld	s3,8(sp)
    800020e2:	6145                	addi	sp,sp,48
    800020e4:	8082                	ret
        p->state = RUNNABLE;
    800020e6:	478d                	li	a5,3
    800020e8:	cc9c                	sw	a5,24(s1)
    800020ea:	b7dd                	j	800020d0 <kill+0x4a>

00000000800020ec <setkilled>:

void
setkilled(struct proc *p)
{
    800020ec:	1101                	addi	sp,sp,-32
    800020ee:	ec06                	sd	ra,24(sp)
    800020f0:	e822                	sd	s0,16(sp)
    800020f2:	e426                	sd	s1,8(sp)
    800020f4:	1000                	addi	s0,sp,32
    800020f6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020f8:	afdfe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    800020fc:	4785                	li	a5,1
    800020fe:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	b8bfe0ef          	jal	80000c8c <release>
}
    80002106:	60e2                	ld	ra,24(sp)
    80002108:	6442                	ld	s0,16(sp)
    8000210a:	64a2                	ld	s1,8(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret

0000000080002110 <killed>:

int
killed(struct proc *p)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	e426                	sd	s1,8(sp)
    80002118:	e04a                	sd	s2,0(sp)
    8000211a:	1000                	addi	s0,sp,32
    8000211c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000211e:	ad7fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80002122:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002126:	8526                	mv	a0,s1
    80002128:	b65fe0ef          	jal	80000c8c <release>
  return k;
}
    8000212c:	854a                	mv	a0,s2
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	64a2                	ld	s1,8(sp)
    80002134:	6902                	ld	s2,0(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret

000000008000213a <wait>:
{
    8000213a:	715d                	addi	sp,sp,-80
    8000213c:	e486                	sd	ra,72(sp)
    8000213e:	e0a2                	sd	s0,64(sp)
    80002140:	fc26                	sd	s1,56(sp)
    80002142:	f84a                	sd	s2,48(sp)
    80002144:	f44e                	sd	s3,40(sp)
    80002146:	f052                	sd	s4,32(sp)
    80002148:	ec56                	sd	s5,24(sp)
    8000214a:	e85a                	sd	s6,16(sp)
    8000214c:	e45e                	sd	s7,8(sp)
    8000214e:	e062                	sd	s8,0(sp)
    80002150:	0880                	addi	s0,sp,80
    80002152:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002154:	fb6ff0ef          	jal	8000190a <myproc>
    80002158:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000215a:	0000e517          	auipc	a0,0xe
    8000215e:	a3e50513          	addi	a0,a0,-1474 # 8000fb98 <wait_lock>
    80002162:	a93fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80002166:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002168:	4a15                	li	s4,5
        havekids = 1;
    8000216a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000216c:	00014997          	auipc	s3,0x14
    80002170:	84498993          	addi	s3,s3,-1980 # 800159b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002174:	0000ec17          	auipc	s8,0xe
    80002178:	a24c0c13          	addi	s8,s8,-1500 # 8000fb98 <wait_lock>
    8000217c:	a871                	j	80002218 <wait+0xde>
          pid = pp->pid;
    8000217e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002182:	000b0c63          	beqz	s6,8000219a <wait+0x60>
    80002186:	4691                	li	a3,4
    80002188:	02c48613          	addi	a2,s1,44
    8000218c:	85da                	mv	a1,s6
    8000218e:	05093503          	ld	a0,80(s2)
    80002192:	beaff0ef          	jal	8000157c <copyout>
    80002196:	02054b63          	bltz	a0,800021cc <wait+0x92>
          freeproc(pp);
    8000219a:	8526                	mv	a0,s1
    8000219c:	8e1ff0ef          	jal	80001a7c <freeproc>
          release(&pp->lock);
    800021a0:	8526                	mv	a0,s1
    800021a2:	aebfe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    800021a6:	0000e517          	auipc	a0,0xe
    800021aa:	9f250513          	addi	a0,a0,-1550 # 8000fb98 <wait_lock>
    800021ae:	adffe0ef          	jal	80000c8c <release>
}
    800021b2:	854e                	mv	a0,s3
    800021b4:	60a6                	ld	ra,72(sp)
    800021b6:	6406                	ld	s0,64(sp)
    800021b8:	74e2                	ld	s1,56(sp)
    800021ba:	7942                	ld	s2,48(sp)
    800021bc:	79a2                	ld	s3,40(sp)
    800021be:	7a02                	ld	s4,32(sp)
    800021c0:	6ae2                	ld	s5,24(sp)
    800021c2:	6b42                	ld	s6,16(sp)
    800021c4:	6ba2                	ld	s7,8(sp)
    800021c6:	6c02                	ld	s8,0(sp)
    800021c8:	6161                	addi	sp,sp,80
    800021ca:	8082                	ret
            release(&pp->lock);
    800021cc:	8526                	mv	a0,s1
    800021ce:	abffe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    800021d2:	0000e517          	auipc	a0,0xe
    800021d6:	9c650513          	addi	a0,a0,-1594 # 8000fb98 <wait_lock>
    800021da:	ab3fe0ef          	jal	80000c8c <release>
            return -1;
    800021de:	59fd                	li	s3,-1
    800021e0:	bfc9                	j	800021b2 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021e2:	16848493          	addi	s1,s1,360
    800021e6:	03348063          	beq	s1,s3,80002206 <wait+0xcc>
      if(pp->parent == p){
    800021ea:	7c9c                	ld	a5,56(s1)
    800021ec:	ff279be3          	bne	a5,s2,800021e2 <wait+0xa8>
        acquire(&pp->lock);
    800021f0:	8526                	mv	a0,s1
    800021f2:	a03fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    800021f6:	4c9c                	lw	a5,24(s1)
    800021f8:	f94783e3          	beq	a5,s4,8000217e <wait+0x44>
        release(&pp->lock);
    800021fc:	8526                	mv	a0,s1
    800021fe:	a8ffe0ef          	jal	80000c8c <release>
        havekids = 1;
    80002202:	8756                	mv	a4,s5
    80002204:	bff9                	j	800021e2 <wait+0xa8>
    if(!havekids || killed(p)){
    80002206:	cf19                	beqz	a4,80002224 <wait+0xea>
    80002208:	854a                	mv	a0,s2
    8000220a:	f07ff0ef          	jal	80002110 <killed>
    8000220e:	e919                	bnez	a0,80002224 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002210:	85e2                	mv	a1,s8
    80002212:	854a                	mv	a0,s2
    80002214:	cc5ff0ef          	jal	80001ed8 <sleep>
    havekids = 0;
    80002218:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000221a:	0000e497          	auipc	s1,0xe
    8000221e:	d9648493          	addi	s1,s1,-618 # 8000ffb0 <proc>
    80002222:	b7e1                	j	800021ea <wait+0xb0>
      release(&wait_lock);
    80002224:	0000e517          	auipc	a0,0xe
    80002228:	97450513          	addi	a0,a0,-1676 # 8000fb98 <wait_lock>
    8000222c:	a61fe0ef          	jal	80000c8c <release>
      return -1;
    80002230:	59fd                	li	s3,-1
    80002232:	b741                	j	800021b2 <wait+0x78>

0000000080002234 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002234:	7179                	addi	sp,sp,-48
    80002236:	f406                	sd	ra,40(sp)
    80002238:	f022                	sd	s0,32(sp)
    8000223a:	ec26                	sd	s1,24(sp)
    8000223c:	e84a                	sd	s2,16(sp)
    8000223e:	e44e                	sd	s3,8(sp)
    80002240:	e052                	sd	s4,0(sp)
    80002242:	1800                	addi	s0,sp,48
    80002244:	84aa                	mv	s1,a0
    80002246:	892e                	mv	s2,a1
    80002248:	89b2                	mv	s3,a2
    8000224a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000224c:	ebeff0ef          	jal	8000190a <myproc>
  if(user_dst){
    80002250:	cc99                	beqz	s1,8000226e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002252:	86d2                	mv	a3,s4
    80002254:	864e                	mv	a2,s3
    80002256:	85ca                	mv	a1,s2
    80002258:	6928                	ld	a0,80(a0)
    8000225a:	b22ff0ef          	jal	8000157c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000225e:	70a2                	ld	ra,40(sp)
    80002260:	7402                	ld	s0,32(sp)
    80002262:	64e2                	ld	s1,24(sp)
    80002264:	6942                	ld	s2,16(sp)
    80002266:	69a2                	ld	s3,8(sp)
    80002268:	6a02                	ld	s4,0(sp)
    8000226a:	6145                	addi	sp,sp,48
    8000226c:	8082                	ret
    memmove((char *)dst, src, len);
    8000226e:	000a061b          	sext.w	a2,s4
    80002272:	85ce                	mv	a1,s3
    80002274:	854a                	mv	a0,s2
    80002276:	aaffe0ef          	jal	80000d24 <memmove>
    return 0;
    8000227a:	8526                	mv	a0,s1
    8000227c:	b7cd                	j	8000225e <either_copyout+0x2a>

000000008000227e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000227e:	7179                	addi	sp,sp,-48
    80002280:	f406                	sd	ra,40(sp)
    80002282:	f022                	sd	s0,32(sp)
    80002284:	ec26                	sd	s1,24(sp)
    80002286:	e84a                	sd	s2,16(sp)
    80002288:	e44e                	sd	s3,8(sp)
    8000228a:	e052                	sd	s4,0(sp)
    8000228c:	1800                	addi	s0,sp,48
    8000228e:	892a                	mv	s2,a0
    80002290:	84ae                	mv	s1,a1
    80002292:	89b2                	mv	s3,a2
    80002294:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002296:	e74ff0ef          	jal	8000190a <myproc>
  if(user_src){
    8000229a:	cc99                	beqz	s1,800022b8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000229c:	86d2                	mv	a3,s4
    8000229e:	864e                	mv	a2,s3
    800022a0:	85ca                	mv	a1,s2
    800022a2:	6928                	ld	a0,80(a0)
    800022a4:	baeff0ef          	jal	80001652 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022a8:	70a2                	ld	ra,40(sp)
    800022aa:	7402                	ld	s0,32(sp)
    800022ac:	64e2                	ld	s1,24(sp)
    800022ae:	6942                	ld	s2,16(sp)
    800022b0:	69a2                	ld	s3,8(sp)
    800022b2:	6a02                	ld	s4,0(sp)
    800022b4:	6145                	addi	sp,sp,48
    800022b6:	8082                	ret
    memmove(dst, (char*)src, len);
    800022b8:	000a061b          	sext.w	a2,s4
    800022bc:	85ce                	mv	a1,s3
    800022be:	854a                	mv	a0,s2
    800022c0:	a65fe0ef          	jal	80000d24 <memmove>
    return 0;
    800022c4:	8526                	mv	a0,s1
    800022c6:	b7cd                	j	800022a8 <either_copyin+0x2a>

00000000800022c8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022c8:	715d                	addi	sp,sp,-80
    800022ca:	e486                	sd	ra,72(sp)
    800022cc:	e0a2                	sd	s0,64(sp)
    800022ce:	fc26                	sd	s1,56(sp)
    800022d0:	f84a                	sd	s2,48(sp)
    800022d2:	f44e                	sd	s3,40(sp)
    800022d4:	f052                	sd	s4,32(sp)
    800022d6:	ec56                	sd	s5,24(sp)
    800022d8:	e85a                	sd	s6,16(sp)
    800022da:	e45e                	sd	s7,8(sp)
    800022dc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800022de:	00005517          	auipc	a0,0x5
    800022e2:	d9a50513          	addi	a0,a0,-614 # 80007078 <etext+0x78>
    800022e6:	9dcfe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022ea:	0000e497          	auipc	s1,0xe
    800022ee:	e1e48493          	addi	s1,s1,-482 # 80010108 <proc+0x158>
    800022f2:	00014917          	auipc	s2,0x14
    800022f6:	81690913          	addi	s2,s2,-2026 # 80015b08 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022fa:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022fc:	00005997          	auipc	s3,0x5
    80002300:	0a498993          	addi	s3,s3,164 # 800073a0 <etext+0x3a0>
    printf("%d %s %s", p->pid, state, p->name);
    80002304:	00005a97          	auipc	s5,0x5
    80002308:	0a4a8a93          	addi	s5,s5,164 # 800073a8 <etext+0x3a8>
    printf("\n");
    8000230c:	00005a17          	auipc	s4,0x5
    80002310:	d6ca0a13          	addi	s4,s4,-660 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002314:	00005b97          	auipc	s7,0x5
    80002318:	5a4b8b93          	addi	s7,s7,1444 # 800078b8 <states.0>
    8000231c:	a829                	j	80002336 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000231e:	ed86a583          	lw	a1,-296(a3)
    80002322:	8556                	mv	a0,s5
    80002324:	99efe0ef          	jal	800004c2 <printf>
    printf("\n");
    80002328:	8552                	mv	a0,s4
    8000232a:	998fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000232e:	16848493          	addi	s1,s1,360
    80002332:	03248263          	beq	s1,s2,80002356 <procdump+0x8e>
    if(p->state == UNUSED)
    80002336:	86a6                	mv	a3,s1
    80002338:	ec04a783          	lw	a5,-320(s1)
    8000233c:	dbed                	beqz	a5,8000232e <procdump+0x66>
      state = "???";
    8000233e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002340:	fcfb6fe3          	bltu	s6,a5,8000231e <procdump+0x56>
    80002344:	02079713          	slli	a4,a5,0x20
    80002348:	01d75793          	srli	a5,a4,0x1d
    8000234c:	97de                	add	a5,a5,s7
    8000234e:	6390                	ld	a2,0(a5)
    80002350:	f679                	bnez	a2,8000231e <procdump+0x56>
      state = "???";
    80002352:	864e                	mv	a2,s3
    80002354:	b7e9                	j	8000231e <procdump+0x56>
  }
}
    80002356:	60a6                	ld	ra,72(sp)
    80002358:	6406                	ld	s0,64(sp)
    8000235a:	74e2                	ld	s1,56(sp)
    8000235c:	7942                	ld	s2,48(sp)
    8000235e:	79a2                	ld	s3,40(sp)
    80002360:	7a02                	ld	s4,32(sp)
    80002362:	6ae2                	ld	s5,24(sp)
    80002364:	6b42                	ld	s6,16(sp)
    80002366:	6ba2                	ld	s7,8(sp)
    80002368:	6161                	addi	sp,sp,80
    8000236a:	8082                	ret

000000008000236c <swtch>:
    8000236c:	00153023          	sd	ra,0(a0)
    80002370:	00253423          	sd	sp,8(a0)
    80002374:	e900                	sd	s0,16(a0)
    80002376:	ed04                	sd	s1,24(a0)
    80002378:	03253023          	sd	s2,32(a0)
    8000237c:	03353423          	sd	s3,40(a0)
    80002380:	03453823          	sd	s4,48(a0)
    80002384:	03553c23          	sd	s5,56(a0)
    80002388:	05653023          	sd	s6,64(a0)
    8000238c:	05753423          	sd	s7,72(a0)
    80002390:	05853823          	sd	s8,80(a0)
    80002394:	05953c23          	sd	s9,88(a0)
    80002398:	07a53023          	sd	s10,96(a0)
    8000239c:	07b53423          	sd	s11,104(a0)
    800023a0:	0005b083          	ld	ra,0(a1)
    800023a4:	0085b103          	ld	sp,8(a1)
    800023a8:	6980                	ld	s0,16(a1)
    800023aa:	6d84                	ld	s1,24(a1)
    800023ac:	0205b903          	ld	s2,32(a1)
    800023b0:	0285b983          	ld	s3,40(a1)
    800023b4:	0305ba03          	ld	s4,48(a1)
    800023b8:	0385ba83          	ld	s5,56(a1)
    800023bc:	0405bb03          	ld	s6,64(a1)
    800023c0:	0485bb83          	ld	s7,72(a1)
    800023c4:	0505bc03          	ld	s8,80(a1)
    800023c8:	0585bc83          	ld	s9,88(a1)
    800023cc:	0605bd03          	ld	s10,96(a1)
    800023d0:	0685bd83          	ld	s11,104(a1)
    800023d4:	8082                	ret

00000000800023d6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023d6:	1141                	addi	sp,sp,-16
    800023d8:	e406                	sd	ra,8(sp)
    800023da:	e022                	sd	s0,0(sp)
    800023dc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023de:	00005597          	auipc	a1,0x5
    800023e2:	00a58593          	addi	a1,a1,10 # 800073e8 <etext+0x3e8>
    800023e6:	00013517          	auipc	a0,0x13
    800023ea:	5ca50513          	addi	a0,a0,1482 # 800159b0 <tickslock>
    800023ee:	f86fe0ef          	jal	80000b74 <initlock>
}
    800023f2:	60a2                	ld	ra,8(sp)
    800023f4:	6402                	ld	s0,0(sp)
    800023f6:	0141                	addi	sp,sp,16
    800023f8:	8082                	ret

00000000800023fa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023fa:	1141                	addi	sp,sp,-16
    800023fc:	e422                	sd	s0,8(sp)
    800023fe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002400:	00003797          	auipc	a5,0x3
    80002404:	e1078793          	addi	a5,a5,-496 # 80005210 <kernelvec>
    80002408:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000240c:	6422                	ld	s0,8(sp)
    8000240e:	0141                	addi	sp,sp,16
    80002410:	8082                	ret

0000000080002412 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002412:	1141                	addi	sp,sp,-16
    80002414:	e406                	sd	ra,8(sp)
    80002416:	e022                	sd	s0,0(sp)
    80002418:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000241a:	cf0ff0ef          	jal	8000190a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000241e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002422:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002424:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002428:	00004697          	auipc	a3,0x4
    8000242c:	bd868693          	addi	a3,a3,-1064 # 80006000 <_trampoline>
    80002430:	00004717          	auipc	a4,0x4
    80002434:	bd070713          	addi	a4,a4,-1072 # 80006000 <_trampoline>
    80002438:	8f15                	sub	a4,a4,a3
    8000243a:	040007b7          	lui	a5,0x4000
    8000243e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002440:	07b2                	slli	a5,a5,0xc
    80002442:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002444:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002448:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000244a:	18002673          	csrr	a2,satp
    8000244e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002450:	6d30                	ld	a2,88(a0)
    80002452:	6138                	ld	a4,64(a0)
    80002454:	6585                	lui	a1,0x1
    80002456:	972e                	add	a4,a4,a1
    80002458:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000245a:	6d38                	ld	a4,88(a0)
    8000245c:	00000617          	auipc	a2,0x0
    80002460:	11060613          	addi	a2,a2,272 # 8000256c <usertrap>
    80002464:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002466:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002468:	8612                	mv	a2,tp
    8000246a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000246c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002470:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002474:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002478:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000247c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000247e:	6f18                	ld	a4,24(a4)
    80002480:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002484:	6928                	ld	a0,80(a0)
    80002486:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002488:	00004717          	auipc	a4,0x4
    8000248c:	c1470713          	addi	a4,a4,-1004 # 8000609c <userret>
    80002490:	8f15                	sub	a4,a4,a3
    80002492:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002494:	577d                	li	a4,-1
    80002496:	177e                	slli	a4,a4,0x3f
    80002498:	8d59                	or	a0,a0,a4
    8000249a:	9782                	jalr	a5
}
    8000249c:	60a2                	ld	ra,8(sp)
    8000249e:	6402                	ld	s0,0(sp)
    800024a0:	0141                	addi	sp,sp,16
    800024a2:	8082                	ret

00000000800024a4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024a4:	1101                	addi	sp,sp,-32
    800024a6:	ec06                	sd	ra,24(sp)
    800024a8:	e822                	sd	s0,16(sp)
    800024aa:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800024ac:	c32ff0ef          	jal	800018de <cpuid>
    800024b0:	cd11                	beqz	a0,800024cc <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024b2:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024b6:	000f4737          	lui	a4,0xf4
    800024ba:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024be:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024c0:	14d79073          	csrw	stimecmp,a5
}
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	6105                	addi	sp,sp,32
    800024ca:	8082                	ret
    800024cc:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800024ce:	00013497          	auipc	s1,0x13
    800024d2:	4e248493          	addi	s1,s1,1250 # 800159b0 <tickslock>
    800024d6:	8526                	mv	a0,s1
    800024d8:	f1cfe0ef          	jal	80000bf4 <acquire>
    ticks++;
    800024dc:	00005517          	auipc	a0,0x5
    800024e0:	57450513          	addi	a0,a0,1396 # 80007a50 <ticks>
    800024e4:	411c                	lw	a5,0(a0)
    800024e6:	2785                	addiw	a5,a5,1
    800024e8:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800024ea:	a3bff0ef          	jal	80001f24 <wakeup>
    release(&tickslock);
    800024ee:	8526                	mv	a0,s1
    800024f0:	f9cfe0ef          	jal	80000c8c <release>
    800024f4:	64a2                	ld	s1,8(sp)
    800024f6:	bf75                	j	800024b2 <clockintr+0xe>

00000000800024f8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024f8:	1101                	addi	sp,sp,-32
    800024fa:	ec06                	sd	ra,24(sp)
    800024fc:	e822                	sd	s0,16(sp)
    800024fe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002500:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002504:	57fd                	li	a5,-1
    80002506:	17fe                	slli	a5,a5,0x3f
    80002508:	07a5                	addi	a5,a5,9
    8000250a:	00f70c63          	beq	a4,a5,80002522 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000250e:	57fd                	li	a5,-1
    80002510:	17fe                	slli	a5,a5,0x3f
    80002512:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002514:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002516:	04f70763          	beq	a4,a5,80002564 <devintr+0x6c>
  }
}
    8000251a:	60e2                	ld	ra,24(sp)
    8000251c:	6442                	ld	s0,16(sp)
    8000251e:	6105                	addi	sp,sp,32
    80002520:	8082                	ret
    80002522:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002524:	599020ef          	jal	800052bc <plic_claim>
    80002528:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000252a:	47a9                	li	a5,10
    8000252c:	00f50963          	beq	a0,a5,8000253e <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002530:	4785                	li	a5,1
    80002532:	00f50963          	beq	a0,a5,80002544 <devintr+0x4c>
    return 1;
    80002536:	4505                	li	a0,1
    } else if(irq){
    80002538:	e889                	bnez	s1,8000254a <devintr+0x52>
    8000253a:	64a2                	ld	s1,8(sp)
    8000253c:	bff9                	j	8000251a <devintr+0x22>
      uartintr();
    8000253e:	cc8fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    80002542:	a819                	j	80002558 <devintr+0x60>
      virtio_disk_intr();
    80002544:	2f0030ef          	jal	80005834 <virtio_disk_intr>
    if(irq)
    80002548:	a801                	j	80002558 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000254a:	85a6                	mv	a1,s1
    8000254c:	00005517          	auipc	a0,0x5
    80002550:	ea450513          	addi	a0,a0,-348 # 800073f0 <etext+0x3f0>
    80002554:	f6ffd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    80002558:	8526                	mv	a0,s1
    8000255a:	583020ef          	jal	800052dc <plic_complete>
    return 1;
    8000255e:	4505                	li	a0,1
    80002560:	64a2                	ld	s1,8(sp)
    80002562:	bf65                	j	8000251a <devintr+0x22>
    clockintr();
    80002564:	f41ff0ef          	jal	800024a4 <clockintr>
    return 2;
    80002568:	4509                	li	a0,2
    8000256a:	bf45                	j	8000251a <devintr+0x22>

000000008000256c <usertrap>:
{
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	e426                	sd	s1,8(sp)
    80002574:	e04a                	sd	s2,0(sp)
    80002576:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002578:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000257c:	1007f793          	andi	a5,a5,256
    80002580:	ef85                	bnez	a5,800025b8 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002582:	00003797          	auipc	a5,0x3
    80002586:	c8e78793          	addi	a5,a5,-882 # 80005210 <kernelvec>
    8000258a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000258e:	b7cff0ef          	jal	8000190a <myproc>
    80002592:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002594:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002596:	14102773          	csrr	a4,sepc
    8000259a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000259c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025a0:	47a1                	li	a5,8
    800025a2:	02f70163          	beq	a4,a5,800025c4 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800025a6:	f53ff0ef          	jal	800024f8 <devintr>
    800025aa:	892a                	mv	s2,a0
    800025ac:	c135                	beqz	a0,80002610 <usertrap+0xa4>
  if(killed(p))
    800025ae:	8526                	mv	a0,s1
    800025b0:	b61ff0ef          	jal	80002110 <killed>
    800025b4:	cd1d                	beqz	a0,800025f2 <usertrap+0x86>
    800025b6:	a81d                	j	800025ec <usertrap+0x80>
    panic("usertrap: not from user mode");
    800025b8:	00005517          	auipc	a0,0x5
    800025bc:	e5850513          	addi	a0,a0,-424 # 80007410 <etext+0x410>
    800025c0:	9d4fe0ef          	jal	80000794 <panic>
    if(killed(p))
    800025c4:	b4dff0ef          	jal	80002110 <killed>
    800025c8:	e121                	bnez	a0,80002608 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800025ca:	6cb8                	ld	a4,88(s1)
    800025cc:	6f1c                	ld	a5,24(a4)
    800025ce:	0791                	addi	a5,a5,4
    800025d0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025d6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025da:	10079073          	csrw	sstatus,a5
    syscall();
    800025de:	248000ef          	jal	80002826 <syscall>
  if(killed(p))
    800025e2:	8526                	mv	a0,s1
    800025e4:	b2dff0ef          	jal	80002110 <killed>
    800025e8:	c901                	beqz	a0,800025f8 <usertrap+0x8c>
    800025ea:	4901                	li	s2,0
    exit(-1);
    800025ec:	557d                	li	a0,-1
    800025ee:	9f7ff0ef          	jal	80001fe4 <exit>
  if(which_dev == 2)
    800025f2:	4789                	li	a5,2
    800025f4:	04f90563          	beq	s2,a5,8000263e <usertrap+0xd2>
  usertrapret();
    800025f8:	e1bff0ef          	jal	80002412 <usertrapret>
}
    800025fc:	60e2                	ld	ra,24(sp)
    800025fe:	6442                	ld	s0,16(sp)
    80002600:	64a2                	ld	s1,8(sp)
    80002602:	6902                	ld	s2,0(sp)
    80002604:	6105                	addi	sp,sp,32
    80002606:	8082                	ret
      exit(-1);
    80002608:	557d                	li	a0,-1
    8000260a:	9dbff0ef          	jal	80001fe4 <exit>
    8000260e:	bf75                	j	800025ca <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002610:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002614:	5890                	lw	a2,48(s1)
    80002616:	00005517          	auipc	a0,0x5
    8000261a:	e1a50513          	addi	a0,a0,-486 # 80007430 <etext+0x430>
    8000261e:	ea5fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002622:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002626:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000262a:	00005517          	auipc	a0,0x5
    8000262e:	e3650513          	addi	a0,a0,-458 # 80007460 <etext+0x460>
    80002632:	e91fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    80002636:	8526                	mv	a0,s1
    80002638:	ab5ff0ef          	jal	800020ec <setkilled>
    8000263c:	b75d                	j	800025e2 <usertrap+0x76>
    yield();
    8000263e:	86fff0ef          	jal	80001eac <yield>
    80002642:	bf5d                	j	800025f8 <usertrap+0x8c>

0000000080002644 <kerneltrap>:
{
    80002644:	7179                	addi	sp,sp,-48
    80002646:	f406                	sd	ra,40(sp)
    80002648:	f022                	sd	s0,32(sp)
    8000264a:	ec26                	sd	s1,24(sp)
    8000264c:	e84a                	sd	s2,16(sp)
    8000264e:	e44e                	sd	s3,8(sp)
    80002650:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002652:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002656:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000265a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000265e:	1004f793          	andi	a5,s1,256
    80002662:	c795                	beqz	a5,8000268e <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002664:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002668:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000266a:	eb85                	bnez	a5,8000269a <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000266c:	e8dff0ef          	jal	800024f8 <devintr>
    80002670:	c91d                	beqz	a0,800026a6 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002672:	4789                	li	a5,2
    80002674:	04f50a63          	beq	a0,a5,800026c8 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002678:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000267c:	10049073          	csrw	sstatus,s1
}
    80002680:	70a2                	ld	ra,40(sp)
    80002682:	7402                	ld	s0,32(sp)
    80002684:	64e2                	ld	s1,24(sp)
    80002686:	6942                	ld	s2,16(sp)
    80002688:	69a2                	ld	s3,8(sp)
    8000268a:	6145                	addi	sp,sp,48
    8000268c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000268e:	00005517          	auipc	a0,0x5
    80002692:	dfa50513          	addi	a0,a0,-518 # 80007488 <etext+0x488>
    80002696:	8fefe0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    8000269a:	00005517          	auipc	a0,0x5
    8000269e:	e1650513          	addi	a0,a0,-490 # 800074b0 <etext+0x4b0>
    800026a2:	8f2fe0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026a6:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026aa:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800026ae:	85ce                	mv	a1,s3
    800026b0:	00005517          	auipc	a0,0x5
    800026b4:	e2050513          	addi	a0,a0,-480 # 800074d0 <etext+0x4d0>
    800026b8:	e0bfd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    800026bc:	00005517          	auipc	a0,0x5
    800026c0:	e3c50513          	addi	a0,a0,-452 # 800074f8 <etext+0x4f8>
    800026c4:	8d0fe0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    800026c8:	a42ff0ef          	jal	8000190a <myproc>
    800026cc:	d555                	beqz	a0,80002678 <kerneltrap+0x34>
    yield();
    800026ce:	fdeff0ef          	jal	80001eac <yield>
    800026d2:	b75d                	j	80002678 <kerneltrap+0x34>

00000000800026d4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026d4:	1101                	addi	sp,sp,-32
    800026d6:	ec06                	sd	ra,24(sp)
    800026d8:	e822                	sd	s0,16(sp)
    800026da:	e426                	sd	s1,8(sp)
    800026dc:	1000                	addi	s0,sp,32
    800026de:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026e0:	a2aff0ef          	jal	8000190a <myproc>
  switch (n) {
    800026e4:	4795                	li	a5,5
    800026e6:	0497e163          	bltu	a5,s1,80002728 <argraw+0x54>
    800026ea:	048a                	slli	s1,s1,0x2
    800026ec:	00005717          	auipc	a4,0x5
    800026f0:	1fc70713          	addi	a4,a4,508 # 800078e8 <states.0+0x30>
    800026f4:	94ba                	add	s1,s1,a4
    800026f6:	409c                	lw	a5,0(s1)
    800026f8:	97ba                	add	a5,a5,a4
    800026fa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800026fc:	6d3c                	ld	a5,88(a0)
    800026fe:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002700:	60e2                	ld	ra,24(sp)
    80002702:	6442                	ld	s0,16(sp)
    80002704:	64a2                	ld	s1,8(sp)
    80002706:	6105                	addi	sp,sp,32
    80002708:	8082                	ret
    return p->trapframe->a1;
    8000270a:	6d3c                	ld	a5,88(a0)
    8000270c:	7fa8                	ld	a0,120(a5)
    8000270e:	bfcd                	j	80002700 <argraw+0x2c>
    return p->trapframe->a2;
    80002710:	6d3c                	ld	a5,88(a0)
    80002712:	63c8                	ld	a0,128(a5)
    80002714:	b7f5                	j	80002700 <argraw+0x2c>
    return p->trapframe->a3;
    80002716:	6d3c                	ld	a5,88(a0)
    80002718:	67c8                	ld	a0,136(a5)
    8000271a:	b7dd                	j	80002700 <argraw+0x2c>
    return p->trapframe->a4;
    8000271c:	6d3c                	ld	a5,88(a0)
    8000271e:	6bc8                	ld	a0,144(a5)
    80002720:	b7c5                	j	80002700 <argraw+0x2c>
    return p->trapframe->a5;
    80002722:	6d3c                	ld	a5,88(a0)
    80002724:	6fc8                	ld	a0,152(a5)
    80002726:	bfe9                	j	80002700 <argraw+0x2c>
  panic("argraw");
    80002728:	00005517          	auipc	a0,0x5
    8000272c:	de050513          	addi	a0,a0,-544 # 80007508 <etext+0x508>
    80002730:	864fe0ef          	jal	80000794 <panic>

0000000080002734 <fetchaddr>:
{
    80002734:	1101                	addi	sp,sp,-32
    80002736:	ec06                	sd	ra,24(sp)
    80002738:	e822                	sd	s0,16(sp)
    8000273a:	e426                	sd	s1,8(sp)
    8000273c:	e04a                	sd	s2,0(sp)
    8000273e:	1000                	addi	s0,sp,32
    80002740:	84aa                	mv	s1,a0
    80002742:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002744:	9c6ff0ef          	jal	8000190a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002748:	653c                	ld	a5,72(a0)
    8000274a:	02f4f663          	bgeu	s1,a5,80002776 <fetchaddr+0x42>
    8000274e:	00848713          	addi	a4,s1,8
    80002752:	02e7e463          	bltu	a5,a4,8000277a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002756:	46a1                	li	a3,8
    80002758:	8626                	mv	a2,s1
    8000275a:	85ca                	mv	a1,s2
    8000275c:	6928                	ld	a0,80(a0)
    8000275e:	ef5fe0ef          	jal	80001652 <copyin>
    80002762:	00a03533          	snez	a0,a0
    80002766:	40a00533          	neg	a0,a0
}
    8000276a:	60e2                	ld	ra,24(sp)
    8000276c:	6442                	ld	s0,16(sp)
    8000276e:	64a2                	ld	s1,8(sp)
    80002770:	6902                	ld	s2,0(sp)
    80002772:	6105                	addi	sp,sp,32
    80002774:	8082                	ret
    return -1;
    80002776:	557d                	li	a0,-1
    80002778:	bfcd                	j	8000276a <fetchaddr+0x36>
    8000277a:	557d                	li	a0,-1
    8000277c:	b7fd                	j	8000276a <fetchaddr+0x36>

000000008000277e <fetchstr>:
{
    8000277e:	7179                	addi	sp,sp,-48
    80002780:	f406                	sd	ra,40(sp)
    80002782:	f022                	sd	s0,32(sp)
    80002784:	ec26                	sd	s1,24(sp)
    80002786:	e84a                	sd	s2,16(sp)
    80002788:	e44e                	sd	s3,8(sp)
    8000278a:	1800                	addi	s0,sp,48
    8000278c:	892a                	mv	s2,a0
    8000278e:	84ae                	mv	s1,a1
    80002790:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002792:	978ff0ef          	jal	8000190a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002796:	86ce                	mv	a3,s3
    80002798:	864a                	mv	a2,s2
    8000279a:	85a6                	mv	a1,s1
    8000279c:	6928                	ld	a0,80(a0)
    8000279e:	f3bfe0ef          	jal	800016d8 <copyinstr>
    800027a2:	00054c63          	bltz	a0,800027ba <fetchstr+0x3c>
  return strlen(buf);
    800027a6:	8526                	mv	a0,s1
    800027a8:	e90fe0ef          	jal	80000e38 <strlen>
}
    800027ac:	70a2                	ld	ra,40(sp)
    800027ae:	7402                	ld	s0,32(sp)
    800027b0:	64e2                	ld	s1,24(sp)
    800027b2:	6942                	ld	s2,16(sp)
    800027b4:	69a2                	ld	s3,8(sp)
    800027b6:	6145                	addi	sp,sp,48
    800027b8:	8082                	ret
    return -1;
    800027ba:	557d                	li	a0,-1
    800027bc:	bfc5                	j	800027ac <fetchstr+0x2e>

00000000800027be <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027be:	1101                	addi	sp,sp,-32
    800027c0:	ec06                	sd	ra,24(sp)
    800027c2:	e822                	sd	s0,16(sp)
    800027c4:	e426                	sd	s1,8(sp)
    800027c6:	1000                	addi	s0,sp,32
    800027c8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027ca:	f0bff0ef          	jal	800026d4 <argraw>
    800027ce:	c088                	sw	a0,0(s1)
}
    800027d0:	60e2                	ld	ra,24(sp)
    800027d2:	6442                	ld	s0,16(sp)
    800027d4:	64a2                	ld	s1,8(sp)
    800027d6:	6105                	addi	sp,sp,32
    800027d8:	8082                	ret

00000000800027da <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027da:	1101                	addi	sp,sp,-32
    800027dc:	ec06                	sd	ra,24(sp)
    800027de:	e822                	sd	s0,16(sp)
    800027e0:	e426                	sd	s1,8(sp)
    800027e2:	1000                	addi	s0,sp,32
    800027e4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027e6:	eefff0ef          	jal	800026d4 <argraw>
    800027ea:	e088                	sd	a0,0(s1)
}
    800027ec:	60e2                	ld	ra,24(sp)
    800027ee:	6442                	ld	s0,16(sp)
    800027f0:	64a2                	ld	s1,8(sp)
    800027f2:	6105                	addi	sp,sp,32
    800027f4:	8082                	ret

00000000800027f6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027f6:	7179                	addi	sp,sp,-48
    800027f8:	f406                	sd	ra,40(sp)
    800027fa:	f022                	sd	s0,32(sp)
    800027fc:	ec26                	sd	s1,24(sp)
    800027fe:	e84a                	sd	s2,16(sp)
    80002800:	1800                	addi	s0,sp,48
    80002802:	84ae                	mv	s1,a1
    80002804:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002806:	fd840593          	addi	a1,s0,-40
    8000280a:	fd1ff0ef          	jal	800027da <argaddr>
  return fetchstr(addr, buf, max);
    8000280e:	864a                	mv	a2,s2
    80002810:	85a6                	mv	a1,s1
    80002812:	fd843503          	ld	a0,-40(s0)
    80002816:	f69ff0ef          	jal	8000277e <fetchstr>
}
    8000281a:	70a2                	ld	ra,40(sp)
    8000281c:	7402                	ld	s0,32(sp)
    8000281e:	64e2                	ld	s1,24(sp)
    80002820:	6942                	ld	s2,16(sp)
    80002822:	6145                	addi	sp,sp,48
    80002824:	8082                	ret

0000000080002826 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002826:	1101                	addi	sp,sp,-32
    80002828:	ec06                	sd	ra,24(sp)
    8000282a:	e822                	sd	s0,16(sp)
    8000282c:	e426                	sd	s1,8(sp)
    8000282e:	e04a                	sd	s2,0(sp)
    80002830:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002832:	8d8ff0ef          	jal	8000190a <myproc>
    80002836:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002838:	05853903          	ld	s2,88(a0)
    8000283c:	0a893783          	ld	a5,168(s2)
    80002840:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002844:	37fd                	addiw	a5,a5,-1
    80002846:	4751                	li	a4,20
    80002848:	00f76f63          	bltu	a4,a5,80002866 <syscall+0x40>
    8000284c:	00369713          	slli	a4,a3,0x3
    80002850:	00005797          	auipc	a5,0x5
    80002854:	0b078793          	addi	a5,a5,176 # 80007900 <syscalls>
    80002858:	97ba                	add	a5,a5,a4
    8000285a:	639c                	ld	a5,0(a5)
    8000285c:	c789                	beqz	a5,80002866 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000285e:	9782                	jalr	a5
    80002860:	06a93823          	sd	a0,112(s2)
    80002864:	a829                	j	8000287e <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002866:	15848613          	addi	a2,s1,344
    8000286a:	588c                	lw	a1,48(s1)
    8000286c:	00005517          	auipc	a0,0x5
    80002870:	ca450513          	addi	a0,a0,-860 # 80007510 <etext+0x510>
    80002874:	c4ffd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002878:	6cbc                	ld	a5,88(s1)
    8000287a:	577d                	li	a4,-1
    8000287c:	fbb8                	sd	a4,112(a5)
  }
}
    8000287e:	60e2                	ld	ra,24(sp)
    80002880:	6442                	ld	s0,16(sp)
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	6902                	ld	s2,0(sp)
    80002886:	6105                	addi	sp,sp,32
    80002888:	8082                	ret

000000008000288a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000288a:	1101                	addi	sp,sp,-32
    8000288c:	ec06                	sd	ra,24(sp)
    8000288e:	e822                	sd	s0,16(sp)
    80002890:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002892:	fec40593          	addi	a1,s0,-20
    80002896:	4501                	li	a0,0
    80002898:	f27ff0ef          	jal	800027be <argint>
  exit(n);
    8000289c:	fec42503          	lw	a0,-20(s0)
    800028a0:	f44ff0ef          	jal	80001fe4 <exit>
  return 0;  // not reached
}
    800028a4:	4501                	li	a0,0
    800028a6:	60e2                	ld	ra,24(sp)
    800028a8:	6442                	ld	s0,16(sp)
    800028aa:	6105                	addi	sp,sp,32
    800028ac:	8082                	ret

00000000800028ae <sys_getpid>:

uint64
sys_getpid(void)
{
    800028ae:	1141                	addi	sp,sp,-16
    800028b0:	e406                	sd	ra,8(sp)
    800028b2:	e022                	sd	s0,0(sp)
    800028b4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028b6:	854ff0ef          	jal	8000190a <myproc>
}
    800028ba:	5908                	lw	a0,48(a0)
    800028bc:	60a2                	ld	ra,8(sp)
    800028be:	6402                	ld	s0,0(sp)
    800028c0:	0141                	addi	sp,sp,16
    800028c2:	8082                	ret

00000000800028c4 <sys_fork>:

uint64
sys_fork(void)
{
    800028c4:	1141                	addi	sp,sp,-16
    800028c6:	e406                	sd	ra,8(sp)
    800028c8:	e022                	sd	s0,0(sp)
    800028ca:	0800                	addi	s0,sp,16
  return fork();
    800028cc:	b64ff0ef          	jal	80001c30 <fork>
}
    800028d0:	60a2                	ld	ra,8(sp)
    800028d2:	6402                	ld	s0,0(sp)
    800028d4:	0141                	addi	sp,sp,16
    800028d6:	8082                	ret

00000000800028d8 <sys_wait>:

uint64
sys_wait(void)
{
    800028d8:	1101                	addi	sp,sp,-32
    800028da:	ec06                	sd	ra,24(sp)
    800028dc:	e822                	sd	s0,16(sp)
    800028de:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800028e0:	fe840593          	addi	a1,s0,-24
    800028e4:	4501                	li	a0,0
    800028e6:	ef5ff0ef          	jal	800027da <argaddr>
  return wait(p);
    800028ea:	fe843503          	ld	a0,-24(s0)
    800028ee:	84dff0ef          	jal	8000213a <wait>
}
    800028f2:	60e2                	ld	ra,24(sp)
    800028f4:	6442                	ld	s0,16(sp)
    800028f6:	6105                	addi	sp,sp,32
    800028f8:	8082                	ret

00000000800028fa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800028fa:	7179                	addi	sp,sp,-48
    800028fc:	f406                	sd	ra,40(sp)
    800028fe:	f022                	sd	s0,32(sp)
    80002900:	ec26                	sd	s1,24(sp)
    80002902:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002904:	fdc40593          	addi	a1,s0,-36
    80002908:	4501                	li	a0,0
    8000290a:	eb5ff0ef          	jal	800027be <argint>
  addr = myproc()->sz;
    8000290e:	ffdfe0ef          	jal	8000190a <myproc>
    80002912:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002914:	fdc42503          	lw	a0,-36(s0)
    80002918:	ac8ff0ef          	jal	80001be0 <growproc>
    8000291c:	00054863          	bltz	a0,8000292c <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002920:	8526                	mv	a0,s1
    80002922:	70a2                	ld	ra,40(sp)
    80002924:	7402                	ld	s0,32(sp)
    80002926:	64e2                	ld	s1,24(sp)
    80002928:	6145                	addi	sp,sp,48
    8000292a:	8082                	ret
    return -1;
    8000292c:	54fd                	li	s1,-1
    8000292e:	bfcd                	j	80002920 <sys_sbrk+0x26>

0000000080002930 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002930:	7139                	addi	sp,sp,-64
    80002932:	fc06                	sd	ra,56(sp)
    80002934:	f822                	sd	s0,48(sp)
    80002936:	f04a                	sd	s2,32(sp)
    80002938:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000293a:	fcc40593          	addi	a1,s0,-52
    8000293e:	4501                	li	a0,0
    80002940:	e7fff0ef          	jal	800027be <argint>
  if(n < 0)
    80002944:	fcc42783          	lw	a5,-52(s0)
    80002948:	0607c763          	bltz	a5,800029b6 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000294c:	00013517          	auipc	a0,0x13
    80002950:	06450513          	addi	a0,a0,100 # 800159b0 <tickslock>
    80002954:	aa0fe0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002958:	00005917          	auipc	s2,0x5
    8000295c:	0f892903          	lw	s2,248(s2) # 80007a50 <ticks>
  while(ticks - ticks0 < n){
    80002960:	fcc42783          	lw	a5,-52(s0)
    80002964:	cf8d                	beqz	a5,8000299e <sys_sleep+0x6e>
    80002966:	f426                	sd	s1,40(sp)
    80002968:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000296a:	00013997          	auipc	s3,0x13
    8000296e:	04698993          	addi	s3,s3,70 # 800159b0 <tickslock>
    80002972:	00005497          	auipc	s1,0x5
    80002976:	0de48493          	addi	s1,s1,222 # 80007a50 <ticks>
    if(killed(myproc())){
    8000297a:	f91fe0ef          	jal	8000190a <myproc>
    8000297e:	f92ff0ef          	jal	80002110 <killed>
    80002982:	ed0d                	bnez	a0,800029bc <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002984:	85ce                	mv	a1,s3
    80002986:	8526                	mv	a0,s1
    80002988:	d50ff0ef          	jal	80001ed8 <sleep>
  while(ticks - ticks0 < n){
    8000298c:	409c                	lw	a5,0(s1)
    8000298e:	412787bb          	subw	a5,a5,s2
    80002992:	fcc42703          	lw	a4,-52(s0)
    80002996:	fee7e2e3          	bltu	a5,a4,8000297a <sys_sleep+0x4a>
    8000299a:	74a2                	ld	s1,40(sp)
    8000299c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000299e:	00013517          	auipc	a0,0x13
    800029a2:	01250513          	addi	a0,a0,18 # 800159b0 <tickslock>
    800029a6:	ae6fe0ef          	jal	80000c8c <release>
  return 0;
    800029aa:	4501                	li	a0,0
}
    800029ac:	70e2                	ld	ra,56(sp)
    800029ae:	7442                	ld	s0,48(sp)
    800029b0:	7902                	ld	s2,32(sp)
    800029b2:	6121                	addi	sp,sp,64
    800029b4:	8082                	ret
    n = 0;
    800029b6:	fc042623          	sw	zero,-52(s0)
    800029ba:	bf49                	j	8000294c <sys_sleep+0x1c>
      release(&tickslock);
    800029bc:	00013517          	auipc	a0,0x13
    800029c0:	ff450513          	addi	a0,a0,-12 # 800159b0 <tickslock>
    800029c4:	ac8fe0ef          	jal	80000c8c <release>
      return -1;
    800029c8:	557d                	li	a0,-1
    800029ca:	74a2                	ld	s1,40(sp)
    800029cc:	69e2                	ld	s3,24(sp)
    800029ce:	bff9                	j	800029ac <sys_sleep+0x7c>

00000000800029d0 <sys_kill>:

uint64
sys_kill(void)
{
    800029d0:	1101                	addi	sp,sp,-32
    800029d2:	ec06                	sd	ra,24(sp)
    800029d4:	e822                	sd	s0,16(sp)
    800029d6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800029d8:	fec40593          	addi	a1,s0,-20
    800029dc:	4501                	li	a0,0
    800029de:	de1ff0ef          	jal	800027be <argint>
  return kill(pid);
    800029e2:	fec42503          	lw	a0,-20(s0)
    800029e6:	ea0ff0ef          	jal	80002086 <kill>
}
    800029ea:	60e2                	ld	ra,24(sp)
    800029ec:	6442                	ld	s0,16(sp)
    800029ee:	6105                	addi	sp,sp,32
    800029f0:	8082                	ret

00000000800029f2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800029f2:	1101                	addi	sp,sp,-32
    800029f4:	ec06                	sd	ra,24(sp)
    800029f6:	e822                	sd	s0,16(sp)
    800029f8:	e426                	sd	s1,8(sp)
    800029fa:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800029fc:	00013517          	auipc	a0,0x13
    80002a00:	fb450513          	addi	a0,a0,-76 # 800159b0 <tickslock>
    80002a04:	9f0fe0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002a08:	00005497          	auipc	s1,0x5
    80002a0c:	0484a483          	lw	s1,72(s1) # 80007a50 <ticks>
  release(&tickslock);
    80002a10:	00013517          	auipc	a0,0x13
    80002a14:	fa050513          	addi	a0,a0,-96 # 800159b0 <tickslock>
    80002a18:	a74fe0ef          	jal	80000c8c <release>
  return xticks;
}
    80002a1c:	02049513          	slli	a0,s1,0x20
    80002a20:	9101                	srli	a0,a0,0x20
    80002a22:	60e2                	ld	ra,24(sp)
    80002a24:	6442                	ld	s0,16(sp)
    80002a26:	64a2                	ld	s1,8(sp)
    80002a28:	6105                	addi	sp,sp,32
    80002a2a:	8082                	ret

0000000080002a2c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002a2c:	7179                	addi	sp,sp,-48
    80002a2e:	f406                	sd	ra,40(sp)
    80002a30:	f022                	sd	s0,32(sp)
    80002a32:	ec26                	sd	s1,24(sp)
    80002a34:	e84a                	sd	s2,16(sp)
    80002a36:	e44e                	sd	s3,8(sp)
    80002a38:	e052                	sd	s4,0(sp)
    80002a3a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002a3c:	00005597          	auipc	a1,0x5
    80002a40:	af458593          	addi	a1,a1,-1292 # 80007530 <etext+0x530>
    80002a44:	00013517          	auipc	a0,0x13
    80002a48:	f8450513          	addi	a0,a0,-124 # 800159c8 <bcache>
    80002a4c:	928fe0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002a50:	0001b797          	auipc	a5,0x1b
    80002a54:	f7878793          	addi	a5,a5,-136 # 8001d9c8 <bcache+0x8000>
    80002a58:	0001b717          	auipc	a4,0x1b
    80002a5c:	1d870713          	addi	a4,a4,472 # 8001dc30 <bcache+0x8268>
    80002a60:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002a64:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a68:	00013497          	auipc	s1,0x13
    80002a6c:	f7848493          	addi	s1,s1,-136 # 800159e0 <bcache+0x18>
    b->next = bcache.head.next;
    80002a70:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002a72:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002a74:	00005a17          	auipc	s4,0x5
    80002a78:	ac4a0a13          	addi	s4,s4,-1340 # 80007538 <etext+0x538>
    b->next = bcache.head.next;
    80002a7c:	2b893783          	ld	a5,696(s2)
    80002a80:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002a82:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002a86:	85d2                	mv	a1,s4
    80002a88:	01048513          	addi	a0,s1,16
    80002a8c:	248010ef          	jal	80003cd4 <initsleeplock>
    bcache.head.next->prev = b;
    80002a90:	2b893783          	ld	a5,696(s2)
    80002a94:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002a96:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a9a:	45848493          	addi	s1,s1,1112
    80002a9e:	fd349fe3          	bne	s1,s3,80002a7c <binit+0x50>
  }
}
    80002aa2:	70a2                	ld	ra,40(sp)
    80002aa4:	7402                	ld	s0,32(sp)
    80002aa6:	64e2                	ld	s1,24(sp)
    80002aa8:	6942                	ld	s2,16(sp)
    80002aaa:	69a2                	ld	s3,8(sp)
    80002aac:	6a02                	ld	s4,0(sp)
    80002aae:	6145                	addi	sp,sp,48
    80002ab0:	8082                	ret

0000000080002ab2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002ab2:	7179                	addi	sp,sp,-48
    80002ab4:	f406                	sd	ra,40(sp)
    80002ab6:	f022                	sd	s0,32(sp)
    80002ab8:	ec26                	sd	s1,24(sp)
    80002aba:	e84a                	sd	s2,16(sp)
    80002abc:	e44e                	sd	s3,8(sp)
    80002abe:	1800                	addi	s0,sp,48
    80002ac0:	892a                	mv	s2,a0
    80002ac2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002ac4:	00013517          	auipc	a0,0x13
    80002ac8:	f0450513          	addi	a0,a0,-252 # 800159c8 <bcache>
    80002acc:	928fe0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ad0:	0001b497          	auipc	s1,0x1b
    80002ad4:	1b04b483          	ld	s1,432(s1) # 8001dc80 <bcache+0x82b8>
    80002ad8:	0001b797          	auipc	a5,0x1b
    80002adc:	15878793          	addi	a5,a5,344 # 8001dc30 <bcache+0x8268>
    80002ae0:	02f48b63          	beq	s1,a5,80002b16 <bread+0x64>
    80002ae4:	873e                	mv	a4,a5
    80002ae6:	a021                	j	80002aee <bread+0x3c>
    80002ae8:	68a4                	ld	s1,80(s1)
    80002aea:	02e48663          	beq	s1,a4,80002b16 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002aee:	449c                	lw	a5,8(s1)
    80002af0:	ff279ce3          	bne	a5,s2,80002ae8 <bread+0x36>
    80002af4:	44dc                	lw	a5,12(s1)
    80002af6:	ff3799e3          	bne	a5,s3,80002ae8 <bread+0x36>
      b->refcnt++;
    80002afa:	40bc                	lw	a5,64(s1)
    80002afc:	2785                	addiw	a5,a5,1
    80002afe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b00:	00013517          	auipc	a0,0x13
    80002b04:	ec850513          	addi	a0,a0,-312 # 800159c8 <bcache>
    80002b08:	984fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002b0c:	01048513          	addi	a0,s1,16
    80002b10:	1fa010ef          	jal	80003d0a <acquiresleep>
      return b;
    80002b14:	a889                	j	80002b66 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b16:	0001b497          	auipc	s1,0x1b
    80002b1a:	1624b483          	ld	s1,354(s1) # 8001dc78 <bcache+0x82b0>
    80002b1e:	0001b797          	auipc	a5,0x1b
    80002b22:	11278793          	addi	a5,a5,274 # 8001dc30 <bcache+0x8268>
    80002b26:	00f48863          	beq	s1,a5,80002b36 <bread+0x84>
    80002b2a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002b2c:	40bc                	lw	a5,64(s1)
    80002b2e:	cb91                	beqz	a5,80002b42 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002b30:	64a4                	ld	s1,72(s1)
    80002b32:	fee49de3          	bne	s1,a4,80002b2c <bread+0x7a>
  panic("bget: no buffers");
    80002b36:	00005517          	auipc	a0,0x5
    80002b3a:	a0a50513          	addi	a0,a0,-1526 # 80007540 <etext+0x540>
    80002b3e:	c57fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002b42:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002b46:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002b4a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002b4e:	4785                	li	a5,1
    80002b50:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002b52:	00013517          	auipc	a0,0x13
    80002b56:	e7650513          	addi	a0,a0,-394 # 800159c8 <bcache>
    80002b5a:	932fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002b5e:	01048513          	addi	a0,s1,16
    80002b62:	1a8010ef          	jal	80003d0a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002b66:	409c                	lw	a5,0(s1)
    80002b68:	cb89                	beqz	a5,80002b7a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002b6a:	8526                	mv	a0,s1
    80002b6c:	70a2                	ld	ra,40(sp)
    80002b6e:	7402                	ld	s0,32(sp)
    80002b70:	64e2                	ld	s1,24(sp)
    80002b72:	6942                	ld	s2,16(sp)
    80002b74:	69a2                	ld	s3,8(sp)
    80002b76:	6145                	addi	sp,sp,48
    80002b78:	8082                	ret
    virtio_disk_rw(b, 0);
    80002b7a:	4581                	li	a1,0
    80002b7c:	8526                	mv	a0,s1
    80002b7e:	2a5020ef          	jal	80005622 <virtio_disk_rw>
    b->valid = 1;
    80002b82:	4785                	li	a5,1
    80002b84:	c09c                	sw	a5,0(s1)
  return b;
    80002b86:	b7d5                	j	80002b6a <bread+0xb8>

0000000080002b88 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002b88:	1101                	addi	sp,sp,-32
    80002b8a:	ec06                	sd	ra,24(sp)
    80002b8c:	e822                	sd	s0,16(sp)
    80002b8e:	e426                	sd	s1,8(sp)
    80002b90:	1000                	addi	s0,sp,32
    80002b92:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b94:	0541                	addi	a0,a0,16
    80002b96:	1f2010ef          	jal	80003d88 <holdingsleep>
    80002b9a:	c911                	beqz	a0,80002bae <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002b9c:	4585                	li	a1,1
    80002b9e:	8526                	mv	a0,s1
    80002ba0:	283020ef          	jal	80005622 <virtio_disk_rw>
}
    80002ba4:	60e2                	ld	ra,24(sp)
    80002ba6:	6442                	ld	s0,16(sp)
    80002ba8:	64a2                	ld	s1,8(sp)
    80002baa:	6105                	addi	sp,sp,32
    80002bac:	8082                	ret
    panic("bwrite");
    80002bae:	00005517          	auipc	a0,0x5
    80002bb2:	9aa50513          	addi	a0,a0,-1622 # 80007558 <etext+0x558>
    80002bb6:	bdffd0ef          	jal	80000794 <panic>

0000000080002bba <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002bba:	1101                	addi	sp,sp,-32
    80002bbc:	ec06                	sd	ra,24(sp)
    80002bbe:	e822                	sd	s0,16(sp)
    80002bc0:	e426                	sd	s1,8(sp)
    80002bc2:	e04a                	sd	s2,0(sp)
    80002bc4:	1000                	addi	s0,sp,32
    80002bc6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002bc8:	01050913          	addi	s2,a0,16
    80002bcc:	854a                	mv	a0,s2
    80002bce:	1ba010ef          	jal	80003d88 <holdingsleep>
    80002bd2:	c135                	beqz	a0,80002c36 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002bd4:	854a                	mv	a0,s2
    80002bd6:	17a010ef          	jal	80003d50 <releasesleep>

  acquire(&bcache.lock);
    80002bda:	00013517          	auipc	a0,0x13
    80002bde:	dee50513          	addi	a0,a0,-530 # 800159c8 <bcache>
    80002be2:	812fe0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002be6:	40bc                	lw	a5,64(s1)
    80002be8:	37fd                	addiw	a5,a5,-1
    80002bea:	0007871b          	sext.w	a4,a5
    80002bee:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002bf0:	e71d                	bnez	a4,80002c1e <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002bf2:	68b8                	ld	a4,80(s1)
    80002bf4:	64bc                	ld	a5,72(s1)
    80002bf6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002bf8:	68b8                	ld	a4,80(s1)
    80002bfa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002bfc:	0001b797          	auipc	a5,0x1b
    80002c00:	dcc78793          	addi	a5,a5,-564 # 8001d9c8 <bcache+0x8000>
    80002c04:	2b87b703          	ld	a4,696(a5)
    80002c08:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002c0a:	0001b717          	auipc	a4,0x1b
    80002c0e:	02670713          	addi	a4,a4,38 # 8001dc30 <bcache+0x8268>
    80002c12:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002c14:	2b87b703          	ld	a4,696(a5)
    80002c18:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002c1a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002c1e:	00013517          	auipc	a0,0x13
    80002c22:	daa50513          	addi	a0,a0,-598 # 800159c8 <bcache>
    80002c26:	866fe0ef          	jal	80000c8c <release>
}
    80002c2a:	60e2                	ld	ra,24(sp)
    80002c2c:	6442                	ld	s0,16(sp)
    80002c2e:	64a2                	ld	s1,8(sp)
    80002c30:	6902                	ld	s2,0(sp)
    80002c32:	6105                	addi	sp,sp,32
    80002c34:	8082                	ret
    panic("brelse");
    80002c36:	00005517          	auipc	a0,0x5
    80002c3a:	92a50513          	addi	a0,a0,-1750 # 80007560 <etext+0x560>
    80002c3e:	b57fd0ef          	jal	80000794 <panic>

0000000080002c42 <bpin>:

void
bpin(struct buf *b) {
    80002c42:	1101                	addi	sp,sp,-32
    80002c44:	ec06                	sd	ra,24(sp)
    80002c46:	e822                	sd	s0,16(sp)
    80002c48:	e426                	sd	s1,8(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c4e:	00013517          	auipc	a0,0x13
    80002c52:	d7a50513          	addi	a0,a0,-646 # 800159c8 <bcache>
    80002c56:	f9ffd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80002c5a:	40bc                	lw	a5,64(s1)
    80002c5c:	2785                	addiw	a5,a5,1
    80002c5e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c60:	00013517          	auipc	a0,0x13
    80002c64:	d6850513          	addi	a0,a0,-664 # 800159c8 <bcache>
    80002c68:	824fe0ef          	jal	80000c8c <release>
}
    80002c6c:	60e2                	ld	ra,24(sp)
    80002c6e:	6442                	ld	s0,16(sp)
    80002c70:	64a2                	ld	s1,8(sp)
    80002c72:	6105                	addi	sp,sp,32
    80002c74:	8082                	ret

0000000080002c76 <bunpin>:

void
bunpin(struct buf *b) {
    80002c76:	1101                	addi	sp,sp,-32
    80002c78:	ec06                	sd	ra,24(sp)
    80002c7a:	e822                	sd	s0,16(sp)
    80002c7c:	e426                	sd	s1,8(sp)
    80002c7e:	1000                	addi	s0,sp,32
    80002c80:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c82:	00013517          	auipc	a0,0x13
    80002c86:	d4650513          	addi	a0,a0,-698 # 800159c8 <bcache>
    80002c8a:	f6bfd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002c8e:	40bc                	lw	a5,64(s1)
    80002c90:	37fd                	addiw	a5,a5,-1
    80002c92:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c94:	00013517          	auipc	a0,0x13
    80002c98:	d3450513          	addi	a0,a0,-716 # 800159c8 <bcache>
    80002c9c:	ff1fd0ef          	jal	80000c8c <release>
}
    80002ca0:	60e2                	ld	ra,24(sp)
    80002ca2:	6442                	ld	s0,16(sp)
    80002ca4:	64a2                	ld	s1,8(sp)
    80002ca6:	6105                	addi	sp,sp,32
    80002ca8:	8082                	ret

0000000080002caa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002caa:	1101                	addi	sp,sp,-32
    80002cac:	ec06                	sd	ra,24(sp)
    80002cae:	e822                	sd	s0,16(sp)
    80002cb0:	e426                	sd	s1,8(sp)
    80002cb2:	e04a                	sd	s2,0(sp)
    80002cb4:	1000                	addi	s0,sp,32
    80002cb6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002cb8:	00d5d59b          	srliw	a1,a1,0xd
    80002cbc:	0001b797          	auipc	a5,0x1b
    80002cc0:	3e87a783          	lw	a5,1000(a5) # 8001e0a4 <sb+0x1c>
    80002cc4:	9dbd                	addw	a1,a1,a5
    80002cc6:	dedff0ef          	jal	80002ab2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002cca:	0074f713          	andi	a4,s1,7
    80002cce:	4785                	li	a5,1
    80002cd0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002cd4:	14ce                	slli	s1,s1,0x33
    80002cd6:	90d9                	srli	s1,s1,0x36
    80002cd8:	00950733          	add	a4,a0,s1
    80002cdc:	05874703          	lbu	a4,88(a4)
    80002ce0:	00e7f6b3          	and	a3,a5,a4
    80002ce4:	c29d                	beqz	a3,80002d0a <bfree+0x60>
    80002ce6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002ce8:	94aa                	add	s1,s1,a0
    80002cea:	fff7c793          	not	a5,a5
    80002cee:	8f7d                	and	a4,a4,a5
    80002cf0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002cf4:	711000ef          	jal	80003c04 <log_write>
  brelse(bp);
    80002cf8:	854a                	mv	a0,s2
    80002cfa:	ec1ff0ef          	jal	80002bba <brelse>
}
    80002cfe:	60e2                	ld	ra,24(sp)
    80002d00:	6442                	ld	s0,16(sp)
    80002d02:	64a2                	ld	s1,8(sp)
    80002d04:	6902                	ld	s2,0(sp)
    80002d06:	6105                	addi	sp,sp,32
    80002d08:	8082                	ret
    panic("freeing free block");
    80002d0a:	00005517          	auipc	a0,0x5
    80002d0e:	85e50513          	addi	a0,a0,-1954 # 80007568 <etext+0x568>
    80002d12:	a83fd0ef          	jal	80000794 <panic>

0000000080002d16 <balloc>:
{
    80002d16:	711d                	addi	sp,sp,-96
    80002d18:	ec86                	sd	ra,88(sp)
    80002d1a:	e8a2                	sd	s0,80(sp)
    80002d1c:	e4a6                	sd	s1,72(sp)
    80002d1e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002d20:	0001b797          	auipc	a5,0x1b
    80002d24:	36c7a783          	lw	a5,876(a5) # 8001e08c <sb+0x4>
    80002d28:	0e078f63          	beqz	a5,80002e26 <balloc+0x110>
    80002d2c:	e0ca                	sd	s2,64(sp)
    80002d2e:	fc4e                	sd	s3,56(sp)
    80002d30:	f852                	sd	s4,48(sp)
    80002d32:	f456                	sd	s5,40(sp)
    80002d34:	f05a                	sd	s6,32(sp)
    80002d36:	ec5e                	sd	s7,24(sp)
    80002d38:	e862                	sd	s8,16(sp)
    80002d3a:	e466                	sd	s9,8(sp)
    80002d3c:	8baa                	mv	s7,a0
    80002d3e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002d40:	0001bb17          	auipc	s6,0x1b
    80002d44:	348b0b13          	addi	s6,s6,840 # 8001e088 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d48:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002d4a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d4c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002d4e:	6c89                	lui	s9,0x2
    80002d50:	a0b5                	j	80002dbc <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002d52:	97ca                	add	a5,a5,s2
    80002d54:	8e55                	or	a2,a2,a3
    80002d56:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002d5a:	854a                	mv	a0,s2
    80002d5c:	6a9000ef          	jal	80003c04 <log_write>
        brelse(bp);
    80002d60:	854a                	mv	a0,s2
    80002d62:	e59ff0ef          	jal	80002bba <brelse>
  bp = bread(dev, bno);
    80002d66:	85a6                	mv	a1,s1
    80002d68:	855e                	mv	a0,s7
    80002d6a:	d49ff0ef          	jal	80002ab2 <bread>
    80002d6e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002d70:	40000613          	li	a2,1024
    80002d74:	4581                	li	a1,0
    80002d76:	05850513          	addi	a0,a0,88
    80002d7a:	f4ffd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80002d7e:	854a                	mv	a0,s2
    80002d80:	685000ef          	jal	80003c04 <log_write>
  brelse(bp);
    80002d84:	854a                	mv	a0,s2
    80002d86:	e35ff0ef          	jal	80002bba <brelse>
}
    80002d8a:	6906                	ld	s2,64(sp)
    80002d8c:	79e2                	ld	s3,56(sp)
    80002d8e:	7a42                	ld	s4,48(sp)
    80002d90:	7aa2                	ld	s5,40(sp)
    80002d92:	7b02                	ld	s6,32(sp)
    80002d94:	6be2                	ld	s7,24(sp)
    80002d96:	6c42                	ld	s8,16(sp)
    80002d98:	6ca2                	ld	s9,8(sp)
}
    80002d9a:	8526                	mv	a0,s1
    80002d9c:	60e6                	ld	ra,88(sp)
    80002d9e:	6446                	ld	s0,80(sp)
    80002da0:	64a6                	ld	s1,72(sp)
    80002da2:	6125                	addi	sp,sp,96
    80002da4:	8082                	ret
    brelse(bp);
    80002da6:	854a                	mv	a0,s2
    80002da8:	e13ff0ef          	jal	80002bba <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002dac:	015c87bb          	addw	a5,s9,s5
    80002db0:	00078a9b          	sext.w	s5,a5
    80002db4:	004b2703          	lw	a4,4(s6)
    80002db8:	04eaff63          	bgeu	s5,a4,80002e16 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002dbc:	41fad79b          	sraiw	a5,s5,0x1f
    80002dc0:	0137d79b          	srliw	a5,a5,0x13
    80002dc4:	015787bb          	addw	a5,a5,s5
    80002dc8:	40d7d79b          	sraiw	a5,a5,0xd
    80002dcc:	01cb2583          	lw	a1,28(s6)
    80002dd0:	9dbd                	addw	a1,a1,a5
    80002dd2:	855e                	mv	a0,s7
    80002dd4:	cdfff0ef          	jal	80002ab2 <bread>
    80002dd8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dda:	004b2503          	lw	a0,4(s6)
    80002dde:	000a849b          	sext.w	s1,s5
    80002de2:	8762                	mv	a4,s8
    80002de4:	fca4f1e3          	bgeu	s1,a0,80002da6 <balloc+0x90>
      m = 1 << (bi % 8);
    80002de8:	00777693          	andi	a3,a4,7
    80002dec:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002df0:	41f7579b          	sraiw	a5,a4,0x1f
    80002df4:	01d7d79b          	srliw	a5,a5,0x1d
    80002df8:	9fb9                	addw	a5,a5,a4
    80002dfa:	4037d79b          	sraiw	a5,a5,0x3
    80002dfe:	00f90633          	add	a2,s2,a5
    80002e02:	05864603          	lbu	a2,88(a2)
    80002e06:	00c6f5b3          	and	a1,a3,a2
    80002e0a:	d5a1                	beqz	a1,80002d52 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e0c:	2705                	addiw	a4,a4,1
    80002e0e:	2485                	addiw	s1,s1,1
    80002e10:	fd471ae3          	bne	a4,s4,80002de4 <balloc+0xce>
    80002e14:	bf49                	j	80002da6 <balloc+0x90>
    80002e16:	6906                	ld	s2,64(sp)
    80002e18:	79e2                	ld	s3,56(sp)
    80002e1a:	7a42                	ld	s4,48(sp)
    80002e1c:	7aa2                	ld	s5,40(sp)
    80002e1e:	7b02                	ld	s6,32(sp)
    80002e20:	6be2                	ld	s7,24(sp)
    80002e22:	6c42                	ld	s8,16(sp)
    80002e24:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002e26:	00004517          	auipc	a0,0x4
    80002e2a:	75a50513          	addi	a0,a0,1882 # 80007580 <etext+0x580>
    80002e2e:	e94fd0ef          	jal	800004c2 <printf>
  return 0;
    80002e32:	4481                	li	s1,0
    80002e34:	b79d                	j	80002d9a <balloc+0x84>

0000000080002e36 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002e36:	7179                	addi	sp,sp,-48
    80002e38:	f406                	sd	ra,40(sp)
    80002e3a:	f022                	sd	s0,32(sp)
    80002e3c:	ec26                	sd	s1,24(sp)
    80002e3e:	e84a                	sd	s2,16(sp)
    80002e40:	e44e                	sd	s3,8(sp)
    80002e42:	1800                	addi	s0,sp,48
    80002e44:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002e46:	47ad                	li	a5,11
    80002e48:	02b7e663          	bltu	a5,a1,80002e74 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002e4c:	02059793          	slli	a5,a1,0x20
    80002e50:	01e7d593          	srli	a1,a5,0x1e
    80002e54:	00b504b3          	add	s1,a0,a1
    80002e58:	0504a903          	lw	s2,80(s1)
    80002e5c:	06091a63          	bnez	s2,80002ed0 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002e60:	4108                	lw	a0,0(a0)
    80002e62:	eb5ff0ef          	jal	80002d16 <balloc>
    80002e66:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e6a:	06090363          	beqz	s2,80002ed0 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002e6e:	0524a823          	sw	s2,80(s1)
    80002e72:	a8b9                	j	80002ed0 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002e74:	ff45849b          	addiw	s1,a1,-12
    80002e78:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002e7c:	0ff00793          	li	a5,255
    80002e80:	06e7ee63          	bltu	a5,a4,80002efc <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002e84:	08052903          	lw	s2,128(a0)
    80002e88:	00091d63          	bnez	s2,80002ea2 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002e8c:	4108                	lw	a0,0(a0)
    80002e8e:	e89ff0ef          	jal	80002d16 <balloc>
    80002e92:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e96:	02090d63          	beqz	s2,80002ed0 <bmap+0x9a>
    80002e9a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002e9c:	0929a023          	sw	s2,128(s3)
    80002ea0:	a011                	j	80002ea4 <bmap+0x6e>
    80002ea2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002ea4:	85ca                	mv	a1,s2
    80002ea6:	0009a503          	lw	a0,0(s3)
    80002eaa:	c09ff0ef          	jal	80002ab2 <bread>
    80002eae:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002eb0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002eb4:	02049713          	slli	a4,s1,0x20
    80002eb8:	01e75593          	srli	a1,a4,0x1e
    80002ebc:	00b784b3          	add	s1,a5,a1
    80002ec0:	0004a903          	lw	s2,0(s1)
    80002ec4:	00090e63          	beqz	s2,80002ee0 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002ec8:	8552                	mv	a0,s4
    80002eca:	cf1ff0ef          	jal	80002bba <brelse>
    return addr;
    80002ece:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002ed0:	854a                	mv	a0,s2
    80002ed2:	70a2                	ld	ra,40(sp)
    80002ed4:	7402                	ld	s0,32(sp)
    80002ed6:	64e2                	ld	s1,24(sp)
    80002ed8:	6942                	ld	s2,16(sp)
    80002eda:	69a2                	ld	s3,8(sp)
    80002edc:	6145                	addi	sp,sp,48
    80002ede:	8082                	ret
      addr = balloc(ip->dev);
    80002ee0:	0009a503          	lw	a0,0(s3)
    80002ee4:	e33ff0ef          	jal	80002d16 <balloc>
    80002ee8:	0005091b          	sext.w	s2,a0
      if(addr){
    80002eec:	fc090ee3          	beqz	s2,80002ec8 <bmap+0x92>
        a[bn] = addr;
    80002ef0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ef4:	8552                	mv	a0,s4
    80002ef6:	50f000ef          	jal	80003c04 <log_write>
    80002efa:	b7f9                	j	80002ec8 <bmap+0x92>
    80002efc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002efe:	00004517          	auipc	a0,0x4
    80002f02:	69a50513          	addi	a0,a0,1690 # 80007598 <etext+0x598>
    80002f06:	88ffd0ef          	jal	80000794 <panic>

0000000080002f0a <iget>:
{
    80002f0a:	7179                	addi	sp,sp,-48
    80002f0c:	f406                	sd	ra,40(sp)
    80002f0e:	f022                	sd	s0,32(sp)
    80002f10:	ec26                	sd	s1,24(sp)
    80002f12:	e84a                	sd	s2,16(sp)
    80002f14:	e44e                	sd	s3,8(sp)
    80002f16:	e052                	sd	s4,0(sp)
    80002f18:	1800                	addi	s0,sp,48
    80002f1a:	89aa                	mv	s3,a0
    80002f1c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f1e:	0001b517          	auipc	a0,0x1b
    80002f22:	18a50513          	addi	a0,a0,394 # 8001e0a8 <itable>
    80002f26:	ccffd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80002f2a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f2c:	0001b497          	auipc	s1,0x1b
    80002f30:	19448493          	addi	s1,s1,404 # 8001e0c0 <itable+0x18>
    80002f34:	0001d697          	auipc	a3,0x1d
    80002f38:	c1c68693          	addi	a3,a3,-996 # 8001fb50 <log>
    80002f3c:	a039                	j	80002f4a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002f3e:	02090963          	beqz	s2,80002f70 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002f42:	08848493          	addi	s1,s1,136
    80002f46:	02d48863          	beq	s1,a3,80002f76 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002f4a:	449c                	lw	a5,8(s1)
    80002f4c:	fef059e3          	blez	a5,80002f3e <iget+0x34>
    80002f50:	4098                	lw	a4,0(s1)
    80002f52:	ff3716e3          	bne	a4,s3,80002f3e <iget+0x34>
    80002f56:	40d8                	lw	a4,4(s1)
    80002f58:	ff4713e3          	bne	a4,s4,80002f3e <iget+0x34>
      ip->ref++;
    80002f5c:	2785                	addiw	a5,a5,1
    80002f5e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002f60:	0001b517          	auipc	a0,0x1b
    80002f64:	14850513          	addi	a0,a0,328 # 8001e0a8 <itable>
    80002f68:	d25fd0ef          	jal	80000c8c <release>
      return ip;
    80002f6c:	8926                	mv	s2,s1
    80002f6e:	a02d                	j	80002f98 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002f70:	fbe9                	bnez	a5,80002f42 <iget+0x38>
      empty = ip;
    80002f72:	8926                	mv	s2,s1
    80002f74:	b7f9                	j	80002f42 <iget+0x38>
  if(empty == 0)
    80002f76:	02090a63          	beqz	s2,80002faa <iget+0xa0>
  ip->dev = dev;
    80002f7a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002f7e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002f82:	4785                	li	a5,1
    80002f84:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002f88:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002f8c:	0001b517          	auipc	a0,0x1b
    80002f90:	11c50513          	addi	a0,a0,284 # 8001e0a8 <itable>
    80002f94:	cf9fd0ef          	jal	80000c8c <release>
}
    80002f98:	854a                	mv	a0,s2
    80002f9a:	70a2                	ld	ra,40(sp)
    80002f9c:	7402                	ld	s0,32(sp)
    80002f9e:	64e2                	ld	s1,24(sp)
    80002fa0:	6942                	ld	s2,16(sp)
    80002fa2:	69a2                	ld	s3,8(sp)
    80002fa4:	6a02                	ld	s4,0(sp)
    80002fa6:	6145                	addi	sp,sp,48
    80002fa8:	8082                	ret
    panic("iget: no inodes");
    80002faa:	00004517          	auipc	a0,0x4
    80002fae:	60650513          	addi	a0,a0,1542 # 800075b0 <etext+0x5b0>
    80002fb2:	fe2fd0ef          	jal	80000794 <panic>

0000000080002fb6 <fsinit>:
fsinit(int dev) {
    80002fb6:	7179                	addi	sp,sp,-48
    80002fb8:	f406                	sd	ra,40(sp)
    80002fba:	f022                	sd	s0,32(sp)
    80002fbc:	ec26                	sd	s1,24(sp)
    80002fbe:	e84a                	sd	s2,16(sp)
    80002fc0:	e44e                	sd	s3,8(sp)
    80002fc2:	1800                	addi	s0,sp,48
    80002fc4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002fc6:	4585                	li	a1,1
    80002fc8:	aebff0ef          	jal	80002ab2 <bread>
    80002fcc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002fce:	0001b997          	auipc	s3,0x1b
    80002fd2:	0ba98993          	addi	s3,s3,186 # 8001e088 <sb>
    80002fd6:	02000613          	li	a2,32
    80002fda:	05850593          	addi	a1,a0,88
    80002fde:	854e                	mv	a0,s3
    80002fe0:	d45fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	bd5ff0ef          	jal	80002bba <brelse>
  if(sb.magic != FSMAGIC)
    80002fea:	0009a703          	lw	a4,0(s3)
    80002fee:	102037b7          	lui	a5,0x10203
    80002ff2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ff6:	02f71063          	bne	a4,a5,80003016 <fsinit+0x60>
  initlog(dev, &sb);
    80002ffa:	0001b597          	auipc	a1,0x1b
    80002ffe:	08e58593          	addi	a1,a1,142 # 8001e088 <sb>
    80003002:	854a                	mv	a0,s2
    80003004:	1f9000ef          	jal	800039fc <initlog>
}
    80003008:	70a2                	ld	ra,40(sp)
    8000300a:	7402                	ld	s0,32(sp)
    8000300c:	64e2                	ld	s1,24(sp)
    8000300e:	6942                	ld	s2,16(sp)
    80003010:	69a2                	ld	s3,8(sp)
    80003012:	6145                	addi	sp,sp,48
    80003014:	8082                	ret
    panic("invalid file system");
    80003016:	00004517          	auipc	a0,0x4
    8000301a:	5aa50513          	addi	a0,a0,1450 # 800075c0 <etext+0x5c0>
    8000301e:	f76fd0ef          	jal	80000794 <panic>

0000000080003022 <iinit>:
{
    80003022:	7179                	addi	sp,sp,-48
    80003024:	f406                	sd	ra,40(sp)
    80003026:	f022                	sd	s0,32(sp)
    80003028:	ec26                	sd	s1,24(sp)
    8000302a:	e84a                	sd	s2,16(sp)
    8000302c:	e44e                	sd	s3,8(sp)
    8000302e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003030:	00004597          	auipc	a1,0x4
    80003034:	5a858593          	addi	a1,a1,1448 # 800075d8 <etext+0x5d8>
    80003038:	0001b517          	auipc	a0,0x1b
    8000303c:	07050513          	addi	a0,a0,112 # 8001e0a8 <itable>
    80003040:	b35fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003044:	0001b497          	auipc	s1,0x1b
    80003048:	08c48493          	addi	s1,s1,140 # 8001e0d0 <itable+0x28>
    8000304c:	0001d997          	auipc	s3,0x1d
    80003050:	b1498993          	addi	s3,s3,-1260 # 8001fb60 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003054:	00004917          	auipc	s2,0x4
    80003058:	58c90913          	addi	s2,s2,1420 # 800075e0 <etext+0x5e0>
    8000305c:	85ca                	mv	a1,s2
    8000305e:	8526                	mv	a0,s1
    80003060:	475000ef          	jal	80003cd4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003064:	08848493          	addi	s1,s1,136
    80003068:	ff349ae3          	bne	s1,s3,8000305c <iinit+0x3a>
}
    8000306c:	70a2                	ld	ra,40(sp)
    8000306e:	7402                	ld	s0,32(sp)
    80003070:	64e2                	ld	s1,24(sp)
    80003072:	6942                	ld	s2,16(sp)
    80003074:	69a2                	ld	s3,8(sp)
    80003076:	6145                	addi	sp,sp,48
    80003078:	8082                	ret

000000008000307a <ialloc>:
{
    8000307a:	7139                	addi	sp,sp,-64
    8000307c:	fc06                	sd	ra,56(sp)
    8000307e:	f822                	sd	s0,48(sp)
    80003080:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003082:	0001b717          	auipc	a4,0x1b
    80003086:	01272703          	lw	a4,18(a4) # 8001e094 <sb+0xc>
    8000308a:	4785                	li	a5,1
    8000308c:	06e7f063          	bgeu	a5,a4,800030ec <ialloc+0x72>
    80003090:	f426                	sd	s1,40(sp)
    80003092:	f04a                	sd	s2,32(sp)
    80003094:	ec4e                	sd	s3,24(sp)
    80003096:	e852                	sd	s4,16(sp)
    80003098:	e456                	sd	s5,8(sp)
    8000309a:	e05a                	sd	s6,0(sp)
    8000309c:	8aaa                	mv	s5,a0
    8000309e:	8b2e                	mv	s6,a1
    800030a0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800030a2:	0001ba17          	auipc	s4,0x1b
    800030a6:	fe6a0a13          	addi	s4,s4,-26 # 8001e088 <sb>
    800030aa:	00495593          	srli	a1,s2,0x4
    800030ae:	018a2783          	lw	a5,24(s4)
    800030b2:	9dbd                	addw	a1,a1,a5
    800030b4:	8556                	mv	a0,s5
    800030b6:	9fdff0ef          	jal	80002ab2 <bread>
    800030ba:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800030bc:	05850993          	addi	s3,a0,88
    800030c0:	00f97793          	andi	a5,s2,15
    800030c4:	079a                	slli	a5,a5,0x6
    800030c6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800030c8:	00099783          	lh	a5,0(s3)
    800030cc:	cb9d                	beqz	a5,80003102 <ialloc+0x88>
    brelse(bp);
    800030ce:	aedff0ef          	jal	80002bba <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800030d2:	0905                	addi	s2,s2,1
    800030d4:	00ca2703          	lw	a4,12(s4)
    800030d8:	0009079b          	sext.w	a5,s2
    800030dc:	fce7e7e3          	bltu	a5,a4,800030aa <ialloc+0x30>
    800030e0:	74a2                	ld	s1,40(sp)
    800030e2:	7902                	ld	s2,32(sp)
    800030e4:	69e2                	ld	s3,24(sp)
    800030e6:	6a42                	ld	s4,16(sp)
    800030e8:	6aa2                	ld	s5,8(sp)
    800030ea:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800030ec:	00004517          	auipc	a0,0x4
    800030f0:	4fc50513          	addi	a0,a0,1276 # 800075e8 <etext+0x5e8>
    800030f4:	bcefd0ef          	jal	800004c2 <printf>
  return 0;
    800030f8:	4501                	li	a0,0
}
    800030fa:	70e2                	ld	ra,56(sp)
    800030fc:	7442                	ld	s0,48(sp)
    800030fe:	6121                	addi	sp,sp,64
    80003100:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003102:	04000613          	li	a2,64
    80003106:	4581                	li	a1,0
    80003108:	854e                	mv	a0,s3
    8000310a:	bbffd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    8000310e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003112:	8526                	mv	a0,s1
    80003114:	2f1000ef          	jal	80003c04 <log_write>
      brelse(bp);
    80003118:	8526                	mv	a0,s1
    8000311a:	aa1ff0ef          	jal	80002bba <brelse>
      return iget(dev, inum);
    8000311e:	0009059b          	sext.w	a1,s2
    80003122:	8556                	mv	a0,s5
    80003124:	de7ff0ef          	jal	80002f0a <iget>
    80003128:	74a2                	ld	s1,40(sp)
    8000312a:	7902                	ld	s2,32(sp)
    8000312c:	69e2                	ld	s3,24(sp)
    8000312e:	6a42                	ld	s4,16(sp)
    80003130:	6aa2                	ld	s5,8(sp)
    80003132:	6b02                	ld	s6,0(sp)
    80003134:	b7d9                	j	800030fa <ialloc+0x80>

0000000080003136 <iupdate>:
{
    80003136:	1101                	addi	sp,sp,-32
    80003138:	ec06                	sd	ra,24(sp)
    8000313a:	e822                	sd	s0,16(sp)
    8000313c:	e426                	sd	s1,8(sp)
    8000313e:	e04a                	sd	s2,0(sp)
    80003140:	1000                	addi	s0,sp,32
    80003142:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003144:	415c                	lw	a5,4(a0)
    80003146:	0047d79b          	srliw	a5,a5,0x4
    8000314a:	0001b597          	auipc	a1,0x1b
    8000314e:	f565a583          	lw	a1,-170(a1) # 8001e0a0 <sb+0x18>
    80003152:	9dbd                	addw	a1,a1,a5
    80003154:	4108                	lw	a0,0(a0)
    80003156:	95dff0ef          	jal	80002ab2 <bread>
    8000315a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000315c:	05850793          	addi	a5,a0,88
    80003160:	40d8                	lw	a4,4(s1)
    80003162:	8b3d                	andi	a4,a4,15
    80003164:	071a                	slli	a4,a4,0x6
    80003166:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003168:	04449703          	lh	a4,68(s1)
    8000316c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003170:	04649703          	lh	a4,70(s1)
    80003174:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003178:	04849703          	lh	a4,72(s1)
    8000317c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003180:	04a49703          	lh	a4,74(s1)
    80003184:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003188:	44f8                	lw	a4,76(s1)
    8000318a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000318c:	03400613          	li	a2,52
    80003190:	05048593          	addi	a1,s1,80
    80003194:	00c78513          	addi	a0,a5,12
    80003198:	b8dfd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    8000319c:	854a                	mv	a0,s2
    8000319e:	267000ef          	jal	80003c04 <log_write>
  brelse(bp);
    800031a2:	854a                	mv	a0,s2
    800031a4:	a17ff0ef          	jal	80002bba <brelse>
}
    800031a8:	60e2                	ld	ra,24(sp)
    800031aa:	6442                	ld	s0,16(sp)
    800031ac:	64a2                	ld	s1,8(sp)
    800031ae:	6902                	ld	s2,0(sp)
    800031b0:	6105                	addi	sp,sp,32
    800031b2:	8082                	ret

00000000800031b4 <idup>:
{
    800031b4:	1101                	addi	sp,sp,-32
    800031b6:	ec06                	sd	ra,24(sp)
    800031b8:	e822                	sd	s0,16(sp)
    800031ba:	e426                	sd	s1,8(sp)
    800031bc:	1000                	addi	s0,sp,32
    800031be:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800031c0:	0001b517          	auipc	a0,0x1b
    800031c4:	ee850513          	addi	a0,a0,-280 # 8001e0a8 <itable>
    800031c8:	a2dfd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    800031cc:	449c                	lw	a5,8(s1)
    800031ce:	2785                	addiw	a5,a5,1
    800031d0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800031d2:	0001b517          	auipc	a0,0x1b
    800031d6:	ed650513          	addi	a0,a0,-298 # 8001e0a8 <itable>
    800031da:	ab3fd0ef          	jal	80000c8c <release>
}
    800031de:	8526                	mv	a0,s1
    800031e0:	60e2                	ld	ra,24(sp)
    800031e2:	6442                	ld	s0,16(sp)
    800031e4:	64a2                	ld	s1,8(sp)
    800031e6:	6105                	addi	sp,sp,32
    800031e8:	8082                	ret

00000000800031ea <ilock>:
{
    800031ea:	1101                	addi	sp,sp,-32
    800031ec:	ec06                	sd	ra,24(sp)
    800031ee:	e822                	sd	s0,16(sp)
    800031f0:	e426                	sd	s1,8(sp)
    800031f2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800031f4:	cd19                	beqz	a0,80003212 <ilock+0x28>
    800031f6:	84aa                	mv	s1,a0
    800031f8:	451c                	lw	a5,8(a0)
    800031fa:	00f05c63          	blez	a5,80003212 <ilock+0x28>
  acquiresleep(&ip->lock);
    800031fe:	0541                	addi	a0,a0,16
    80003200:	30b000ef          	jal	80003d0a <acquiresleep>
  if(ip->valid == 0){
    80003204:	40bc                	lw	a5,64(s1)
    80003206:	cf89                	beqz	a5,80003220 <ilock+0x36>
}
    80003208:	60e2                	ld	ra,24(sp)
    8000320a:	6442                	ld	s0,16(sp)
    8000320c:	64a2                	ld	s1,8(sp)
    8000320e:	6105                	addi	sp,sp,32
    80003210:	8082                	ret
    80003212:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003214:	00004517          	auipc	a0,0x4
    80003218:	3ec50513          	addi	a0,a0,1004 # 80007600 <etext+0x600>
    8000321c:	d78fd0ef          	jal	80000794 <panic>
    80003220:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003222:	40dc                	lw	a5,4(s1)
    80003224:	0047d79b          	srliw	a5,a5,0x4
    80003228:	0001b597          	auipc	a1,0x1b
    8000322c:	e785a583          	lw	a1,-392(a1) # 8001e0a0 <sb+0x18>
    80003230:	9dbd                	addw	a1,a1,a5
    80003232:	4088                	lw	a0,0(s1)
    80003234:	87fff0ef          	jal	80002ab2 <bread>
    80003238:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000323a:	05850593          	addi	a1,a0,88
    8000323e:	40dc                	lw	a5,4(s1)
    80003240:	8bbd                	andi	a5,a5,15
    80003242:	079a                	slli	a5,a5,0x6
    80003244:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003246:	00059783          	lh	a5,0(a1)
    8000324a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000324e:	00259783          	lh	a5,2(a1)
    80003252:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003256:	00459783          	lh	a5,4(a1)
    8000325a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000325e:	00659783          	lh	a5,6(a1)
    80003262:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003266:	459c                	lw	a5,8(a1)
    80003268:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000326a:	03400613          	li	a2,52
    8000326e:	05b1                	addi	a1,a1,12
    80003270:	05048513          	addi	a0,s1,80
    80003274:	ab1fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    80003278:	854a                	mv	a0,s2
    8000327a:	941ff0ef          	jal	80002bba <brelse>
    ip->valid = 1;
    8000327e:	4785                	li	a5,1
    80003280:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003282:	04449783          	lh	a5,68(s1)
    80003286:	c399                	beqz	a5,8000328c <ilock+0xa2>
    80003288:	6902                	ld	s2,0(sp)
    8000328a:	bfbd                	j	80003208 <ilock+0x1e>
      panic("ilock: no type");
    8000328c:	00004517          	auipc	a0,0x4
    80003290:	37c50513          	addi	a0,a0,892 # 80007608 <etext+0x608>
    80003294:	d00fd0ef          	jal	80000794 <panic>

0000000080003298 <iunlock>:
{
    80003298:	1101                	addi	sp,sp,-32
    8000329a:	ec06                	sd	ra,24(sp)
    8000329c:	e822                	sd	s0,16(sp)
    8000329e:	e426                	sd	s1,8(sp)
    800032a0:	e04a                	sd	s2,0(sp)
    800032a2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032a4:	c505                	beqz	a0,800032cc <iunlock+0x34>
    800032a6:	84aa                	mv	s1,a0
    800032a8:	01050913          	addi	s2,a0,16
    800032ac:	854a                	mv	a0,s2
    800032ae:	2db000ef          	jal	80003d88 <holdingsleep>
    800032b2:	cd09                	beqz	a0,800032cc <iunlock+0x34>
    800032b4:	449c                	lw	a5,8(s1)
    800032b6:	00f05b63          	blez	a5,800032cc <iunlock+0x34>
  releasesleep(&ip->lock);
    800032ba:	854a                	mv	a0,s2
    800032bc:	295000ef          	jal	80003d50 <releasesleep>
}
    800032c0:	60e2                	ld	ra,24(sp)
    800032c2:	6442                	ld	s0,16(sp)
    800032c4:	64a2                	ld	s1,8(sp)
    800032c6:	6902                	ld	s2,0(sp)
    800032c8:	6105                	addi	sp,sp,32
    800032ca:	8082                	ret
    panic("iunlock");
    800032cc:	00004517          	auipc	a0,0x4
    800032d0:	34c50513          	addi	a0,a0,844 # 80007618 <etext+0x618>
    800032d4:	cc0fd0ef          	jal	80000794 <panic>

00000000800032d8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800032d8:	7179                	addi	sp,sp,-48
    800032da:	f406                	sd	ra,40(sp)
    800032dc:	f022                	sd	s0,32(sp)
    800032de:	ec26                	sd	s1,24(sp)
    800032e0:	e84a                	sd	s2,16(sp)
    800032e2:	e44e                	sd	s3,8(sp)
    800032e4:	1800                	addi	s0,sp,48
    800032e6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800032e8:	05050493          	addi	s1,a0,80
    800032ec:	08050913          	addi	s2,a0,128
    800032f0:	a021                	j	800032f8 <itrunc+0x20>
    800032f2:	0491                	addi	s1,s1,4
    800032f4:	01248b63          	beq	s1,s2,8000330a <itrunc+0x32>
    if(ip->addrs[i]){
    800032f8:	408c                	lw	a1,0(s1)
    800032fa:	dde5                	beqz	a1,800032f2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800032fc:	0009a503          	lw	a0,0(s3)
    80003300:	9abff0ef          	jal	80002caa <bfree>
      ip->addrs[i] = 0;
    80003304:	0004a023          	sw	zero,0(s1)
    80003308:	b7ed                	j	800032f2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000330a:	0809a583          	lw	a1,128(s3)
    8000330e:	ed89                	bnez	a1,80003328 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003310:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003314:	854e                	mv	a0,s3
    80003316:	e21ff0ef          	jal	80003136 <iupdate>
}
    8000331a:	70a2                	ld	ra,40(sp)
    8000331c:	7402                	ld	s0,32(sp)
    8000331e:	64e2                	ld	s1,24(sp)
    80003320:	6942                	ld	s2,16(sp)
    80003322:	69a2                	ld	s3,8(sp)
    80003324:	6145                	addi	sp,sp,48
    80003326:	8082                	ret
    80003328:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000332a:	0009a503          	lw	a0,0(s3)
    8000332e:	f84ff0ef          	jal	80002ab2 <bread>
    80003332:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003334:	05850493          	addi	s1,a0,88
    80003338:	45850913          	addi	s2,a0,1112
    8000333c:	a021                	j	80003344 <itrunc+0x6c>
    8000333e:	0491                	addi	s1,s1,4
    80003340:	01248963          	beq	s1,s2,80003352 <itrunc+0x7a>
      if(a[j])
    80003344:	408c                	lw	a1,0(s1)
    80003346:	dde5                	beqz	a1,8000333e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003348:	0009a503          	lw	a0,0(s3)
    8000334c:	95fff0ef          	jal	80002caa <bfree>
    80003350:	b7fd                	j	8000333e <itrunc+0x66>
    brelse(bp);
    80003352:	8552                	mv	a0,s4
    80003354:	867ff0ef          	jal	80002bba <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003358:	0809a583          	lw	a1,128(s3)
    8000335c:	0009a503          	lw	a0,0(s3)
    80003360:	94bff0ef          	jal	80002caa <bfree>
    ip->addrs[NDIRECT] = 0;
    80003364:	0809a023          	sw	zero,128(s3)
    80003368:	6a02                	ld	s4,0(sp)
    8000336a:	b75d                	j	80003310 <itrunc+0x38>

000000008000336c <iput>:
{
    8000336c:	1101                	addi	sp,sp,-32
    8000336e:	ec06                	sd	ra,24(sp)
    80003370:	e822                	sd	s0,16(sp)
    80003372:	e426                	sd	s1,8(sp)
    80003374:	1000                	addi	s0,sp,32
    80003376:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003378:	0001b517          	auipc	a0,0x1b
    8000337c:	d3050513          	addi	a0,a0,-720 # 8001e0a8 <itable>
    80003380:	875fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003384:	4498                	lw	a4,8(s1)
    80003386:	4785                	li	a5,1
    80003388:	02f70063          	beq	a4,a5,800033a8 <iput+0x3c>
  ip->ref--;
    8000338c:	449c                	lw	a5,8(s1)
    8000338e:	37fd                	addiw	a5,a5,-1
    80003390:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003392:	0001b517          	auipc	a0,0x1b
    80003396:	d1650513          	addi	a0,a0,-746 # 8001e0a8 <itable>
    8000339a:	8f3fd0ef          	jal	80000c8c <release>
}
    8000339e:	60e2                	ld	ra,24(sp)
    800033a0:	6442                	ld	s0,16(sp)
    800033a2:	64a2                	ld	s1,8(sp)
    800033a4:	6105                	addi	sp,sp,32
    800033a6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033a8:	40bc                	lw	a5,64(s1)
    800033aa:	d3ed                	beqz	a5,8000338c <iput+0x20>
    800033ac:	04a49783          	lh	a5,74(s1)
    800033b0:	fff1                	bnez	a5,8000338c <iput+0x20>
    800033b2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800033b4:	01048913          	addi	s2,s1,16
    800033b8:	854a                	mv	a0,s2
    800033ba:	151000ef          	jal	80003d0a <acquiresleep>
    release(&itable.lock);
    800033be:	0001b517          	auipc	a0,0x1b
    800033c2:	cea50513          	addi	a0,a0,-790 # 8001e0a8 <itable>
    800033c6:	8c7fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    800033ca:	8526                	mv	a0,s1
    800033cc:	f0dff0ef          	jal	800032d8 <itrunc>
    ip->type = 0;
    800033d0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800033d4:	8526                	mv	a0,s1
    800033d6:	d61ff0ef          	jal	80003136 <iupdate>
    ip->valid = 0;
    800033da:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800033de:	854a                	mv	a0,s2
    800033e0:	171000ef          	jal	80003d50 <releasesleep>
    acquire(&itable.lock);
    800033e4:	0001b517          	auipc	a0,0x1b
    800033e8:	cc450513          	addi	a0,a0,-828 # 8001e0a8 <itable>
    800033ec:	809fd0ef          	jal	80000bf4 <acquire>
    800033f0:	6902                	ld	s2,0(sp)
    800033f2:	bf69                	j	8000338c <iput+0x20>

00000000800033f4 <iunlockput>:
{
    800033f4:	1101                	addi	sp,sp,-32
    800033f6:	ec06                	sd	ra,24(sp)
    800033f8:	e822                	sd	s0,16(sp)
    800033fa:	e426                	sd	s1,8(sp)
    800033fc:	1000                	addi	s0,sp,32
    800033fe:	84aa                	mv	s1,a0
  iunlock(ip);
    80003400:	e99ff0ef          	jal	80003298 <iunlock>
  iput(ip);
    80003404:	8526                	mv	a0,s1
    80003406:	f67ff0ef          	jal	8000336c <iput>
}
    8000340a:	60e2                	ld	ra,24(sp)
    8000340c:	6442                	ld	s0,16(sp)
    8000340e:	64a2                	ld	s1,8(sp)
    80003410:	6105                	addi	sp,sp,32
    80003412:	8082                	ret

0000000080003414 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003414:	1141                	addi	sp,sp,-16
    80003416:	e422                	sd	s0,8(sp)
    80003418:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000341a:	411c                	lw	a5,0(a0)
    8000341c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000341e:	415c                	lw	a5,4(a0)
    80003420:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003422:	04451783          	lh	a5,68(a0)
    80003426:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000342a:	04a51783          	lh	a5,74(a0)
    8000342e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003432:	04c56783          	lwu	a5,76(a0)
    80003436:	e99c                	sd	a5,16(a1)
}
    80003438:	6422                	ld	s0,8(sp)
    8000343a:	0141                	addi	sp,sp,16
    8000343c:	8082                	ret

000000008000343e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000343e:	457c                	lw	a5,76(a0)
    80003440:	0ed7eb63          	bltu	a5,a3,80003536 <readi+0xf8>
{
    80003444:	7159                	addi	sp,sp,-112
    80003446:	f486                	sd	ra,104(sp)
    80003448:	f0a2                	sd	s0,96(sp)
    8000344a:	eca6                	sd	s1,88(sp)
    8000344c:	e0d2                	sd	s4,64(sp)
    8000344e:	fc56                	sd	s5,56(sp)
    80003450:	f85a                	sd	s6,48(sp)
    80003452:	f45e                	sd	s7,40(sp)
    80003454:	1880                	addi	s0,sp,112
    80003456:	8b2a                	mv	s6,a0
    80003458:	8bae                	mv	s7,a1
    8000345a:	8a32                	mv	s4,a2
    8000345c:	84b6                	mv	s1,a3
    8000345e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003460:	9f35                	addw	a4,a4,a3
    return 0;
    80003462:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003464:	0cd76063          	bltu	a4,a3,80003524 <readi+0xe6>
    80003468:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000346a:	00e7f463          	bgeu	a5,a4,80003472 <readi+0x34>
    n = ip->size - off;
    8000346e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003472:	080a8f63          	beqz	s5,80003510 <readi+0xd2>
    80003476:	e8ca                	sd	s2,80(sp)
    80003478:	f062                	sd	s8,32(sp)
    8000347a:	ec66                	sd	s9,24(sp)
    8000347c:	e86a                	sd	s10,16(sp)
    8000347e:	e46e                	sd	s11,8(sp)
    80003480:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003482:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003486:	5c7d                	li	s8,-1
    80003488:	a80d                	j	800034ba <readi+0x7c>
    8000348a:	020d1d93          	slli	s11,s10,0x20
    8000348e:	020ddd93          	srli	s11,s11,0x20
    80003492:	05890613          	addi	a2,s2,88
    80003496:	86ee                	mv	a3,s11
    80003498:	963a                	add	a2,a2,a4
    8000349a:	85d2                	mv	a1,s4
    8000349c:	855e                	mv	a0,s7
    8000349e:	d97fe0ef          	jal	80002234 <either_copyout>
    800034a2:	05850763          	beq	a0,s8,800034f0 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800034a6:	854a                	mv	a0,s2
    800034a8:	f12ff0ef          	jal	80002bba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800034ac:	013d09bb          	addw	s3,s10,s3
    800034b0:	009d04bb          	addw	s1,s10,s1
    800034b4:	9a6e                	add	s4,s4,s11
    800034b6:	0559f763          	bgeu	s3,s5,80003504 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800034ba:	00a4d59b          	srliw	a1,s1,0xa
    800034be:	855a                	mv	a0,s6
    800034c0:	977ff0ef          	jal	80002e36 <bmap>
    800034c4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034c8:	c5b1                	beqz	a1,80003514 <readi+0xd6>
    bp = bread(ip->dev, addr);
    800034ca:	000b2503          	lw	a0,0(s6)
    800034ce:	de4ff0ef          	jal	80002ab2 <bread>
    800034d2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034d4:	3ff4f713          	andi	a4,s1,1023
    800034d8:	40ec87bb          	subw	a5,s9,a4
    800034dc:	413a86bb          	subw	a3,s5,s3
    800034e0:	8d3e                	mv	s10,a5
    800034e2:	2781                	sext.w	a5,a5
    800034e4:	0006861b          	sext.w	a2,a3
    800034e8:	faf671e3          	bgeu	a2,a5,8000348a <readi+0x4c>
    800034ec:	8d36                	mv	s10,a3
    800034ee:	bf71                	j	8000348a <readi+0x4c>
      brelse(bp);
    800034f0:	854a                	mv	a0,s2
    800034f2:	ec8ff0ef          	jal	80002bba <brelse>
      tot = -1;
    800034f6:	59fd                	li	s3,-1
      break;
    800034f8:	6946                	ld	s2,80(sp)
    800034fa:	7c02                	ld	s8,32(sp)
    800034fc:	6ce2                	ld	s9,24(sp)
    800034fe:	6d42                	ld	s10,16(sp)
    80003500:	6da2                	ld	s11,8(sp)
    80003502:	a831                	j	8000351e <readi+0xe0>
    80003504:	6946                	ld	s2,80(sp)
    80003506:	7c02                	ld	s8,32(sp)
    80003508:	6ce2                	ld	s9,24(sp)
    8000350a:	6d42                	ld	s10,16(sp)
    8000350c:	6da2                	ld	s11,8(sp)
    8000350e:	a801                	j	8000351e <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003510:	89d6                	mv	s3,s5
    80003512:	a031                	j	8000351e <readi+0xe0>
    80003514:	6946                	ld	s2,80(sp)
    80003516:	7c02                	ld	s8,32(sp)
    80003518:	6ce2                	ld	s9,24(sp)
    8000351a:	6d42                	ld	s10,16(sp)
    8000351c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000351e:	0009851b          	sext.w	a0,s3
    80003522:	69a6                	ld	s3,72(sp)
}
    80003524:	70a6                	ld	ra,104(sp)
    80003526:	7406                	ld	s0,96(sp)
    80003528:	64e6                	ld	s1,88(sp)
    8000352a:	6a06                	ld	s4,64(sp)
    8000352c:	7ae2                	ld	s5,56(sp)
    8000352e:	7b42                	ld	s6,48(sp)
    80003530:	7ba2                	ld	s7,40(sp)
    80003532:	6165                	addi	sp,sp,112
    80003534:	8082                	ret
    return 0;
    80003536:	4501                	li	a0,0
}
    80003538:	8082                	ret

000000008000353a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000353a:	457c                	lw	a5,76(a0)
    8000353c:	10d7e063          	bltu	a5,a3,8000363c <writei+0x102>
{
    80003540:	7159                	addi	sp,sp,-112
    80003542:	f486                	sd	ra,104(sp)
    80003544:	f0a2                	sd	s0,96(sp)
    80003546:	e8ca                	sd	s2,80(sp)
    80003548:	e0d2                	sd	s4,64(sp)
    8000354a:	fc56                	sd	s5,56(sp)
    8000354c:	f85a                	sd	s6,48(sp)
    8000354e:	f45e                	sd	s7,40(sp)
    80003550:	1880                	addi	s0,sp,112
    80003552:	8aaa                	mv	s5,a0
    80003554:	8bae                	mv	s7,a1
    80003556:	8a32                	mv	s4,a2
    80003558:	8936                	mv	s2,a3
    8000355a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000355c:	00e687bb          	addw	a5,a3,a4
    80003560:	0ed7e063          	bltu	a5,a3,80003640 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003564:	00043737          	lui	a4,0x43
    80003568:	0cf76e63          	bltu	a4,a5,80003644 <writei+0x10a>
    8000356c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000356e:	0a0b0f63          	beqz	s6,8000362c <writei+0xf2>
    80003572:	eca6                	sd	s1,88(sp)
    80003574:	f062                	sd	s8,32(sp)
    80003576:	ec66                	sd	s9,24(sp)
    80003578:	e86a                	sd	s10,16(sp)
    8000357a:	e46e                	sd	s11,8(sp)
    8000357c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000357e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003582:	5c7d                	li	s8,-1
    80003584:	a825                	j	800035bc <writei+0x82>
    80003586:	020d1d93          	slli	s11,s10,0x20
    8000358a:	020ddd93          	srli	s11,s11,0x20
    8000358e:	05848513          	addi	a0,s1,88
    80003592:	86ee                	mv	a3,s11
    80003594:	8652                	mv	a2,s4
    80003596:	85de                	mv	a1,s7
    80003598:	953a                	add	a0,a0,a4
    8000359a:	ce5fe0ef          	jal	8000227e <either_copyin>
    8000359e:	05850a63          	beq	a0,s8,800035f2 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800035a2:	8526                	mv	a0,s1
    800035a4:	660000ef          	jal	80003c04 <log_write>
    brelse(bp);
    800035a8:	8526                	mv	a0,s1
    800035aa:	e10ff0ef          	jal	80002bba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800035ae:	013d09bb          	addw	s3,s10,s3
    800035b2:	012d093b          	addw	s2,s10,s2
    800035b6:	9a6e                	add	s4,s4,s11
    800035b8:	0569f063          	bgeu	s3,s6,800035f8 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800035bc:	00a9559b          	srliw	a1,s2,0xa
    800035c0:	8556                	mv	a0,s5
    800035c2:	875ff0ef          	jal	80002e36 <bmap>
    800035c6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800035ca:	c59d                	beqz	a1,800035f8 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800035cc:	000aa503          	lw	a0,0(s5)
    800035d0:	ce2ff0ef          	jal	80002ab2 <bread>
    800035d4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800035d6:	3ff97713          	andi	a4,s2,1023
    800035da:	40ec87bb          	subw	a5,s9,a4
    800035de:	413b06bb          	subw	a3,s6,s3
    800035e2:	8d3e                	mv	s10,a5
    800035e4:	2781                	sext.w	a5,a5
    800035e6:	0006861b          	sext.w	a2,a3
    800035ea:	f8f67ee3          	bgeu	a2,a5,80003586 <writei+0x4c>
    800035ee:	8d36                	mv	s10,a3
    800035f0:	bf59                	j	80003586 <writei+0x4c>
      brelse(bp);
    800035f2:	8526                	mv	a0,s1
    800035f4:	dc6ff0ef          	jal	80002bba <brelse>
  }

  if(off > ip->size)
    800035f8:	04caa783          	lw	a5,76(s5)
    800035fc:	0327fa63          	bgeu	a5,s2,80003630 <writei+0xf6>
    ip->size = off;
    80003600:	052aa623          	sw	s2,76(s5)
    80003604:	64e6                	ld	s1,88(sp)
    80003606:	7c02                	ld	s8,32(sp)
    80003608:	6ce2                	ld	s9,24(sp)
    8000360a:	6d42                	ld	s10,16(sp)
    8000360c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000360e:	8556                	mv	a0,s5
    80003610:	b27ff0ef          	jal	80003136 <iupdate>

  return tot;
    80003614:	0009851b          	sext.w	a0,s3
    80003618:	69a6                	ld	s3,72(sp)
}
    8000361a:	70a6                	ld	ra,104(sp)
    8000361c:	7406                	ld	s0,96(sp)
    8000361e:	6946                	ld	s2,80(sp)
    80003620:	6a06                	ld	s4,64(sp)
    80003622:	7ae2                	ld	s5,56(sp)
    80003624:	7b42                	ld	s6,48(sp)
    80003626:	7ba2                	ld	s7,40(sp)
    80003628:	6165                	addi	sp,sp,112
    8000362a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000362c:	89da                	mv	s3,s6
    8000362e:	b7c5                	j	8000360e <writei+0xd4>
    80003630:	64e6                	ld	s1,88(sp)
    80003632:	7c02                	ld	s8,32(sp)
    80003634:	6ce2                	ld	s9,24(sp)
    80003636:	6d42                	ld	s10,16(sp)
    80003638:	6da2                	ld	s11,8(sp)
    8000363a:	bfd1                	j	8000360e <writei+0xd4>
    return -1;
    8000363c:	557d                	li	a0,-1
}
    8000363e:	8082                	ret
    return -1;
    80003640:	557d                	li	a0,-1
    80003642:	bfe1                	j	8000361a <writei+0xe0>
    return -1;
    80003644:	557d                	li	a0,-1
    80003646:	bfd1                	j	8000361a <writei+0xe0>

0000000080003648 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003648:	1141                	addi	sp,sp,-16
    8000364a:	e406                	sd	ra,8(sp)
    8000364c:	e022                	sd	s0,0(sp)
    8000364e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003650:	4639                	li	a2,14
    80003652:	f42fd0ef          	jal	80000d94 <strncmp>
}
    80003656:	60a2                	ld	ra,8(sp)
    80003658:	6402                	ld	s0,0(sp)
    8000365a:	0141                	addi	sp,sp,16
    8000365c:	8082                	ret

000000008000365e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000365e:	7139                	addi	sp,sp,-64
    80003660:	fc06                	sd	ra,56(sp)
    80003662:	f822                	sd	s0,48(sp)
    80003664:	f426                	sd	s1,40(sp)
    80003666:	f04a                	sd	s2,32(sp)
    80003668:	ec4e                	sd	s3,24(sp)
    8000366a:	e852                	sd	s4,16(sp)
    8000366c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000366e:	04451703          	lh	a4,68(a0)
    80003672:	4785                	li	a5,1
    80003674:	00f71a63          	bne	a4,a5,80003688 <dirlookup+0x2a>
    80003678:	892a                	mv	s2,a0
    8000367a:	89ae                	mv	s3,a1
    8000367c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000367e:	457c                	lw	a5,76(a0)
    80003680:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003682:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003684:	e39d                	bnez	a5,800036aa <dirlookup+0x4c>
    80003686:	a095                	j	800036ea <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003688:	00004517          	auipc	a0,0x4
    8000368c:	f9850513          	addi	a0,a0,-104 # 80007620 <etext+0x620>
    80003690:	904fd0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003694:	00004517          	auipc	a0,0x4
    80003698:	fa450513          	addi	a0,a0,-92 # 80007638 <etext+0x638>
    8000369c:	8f8fd0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036a0:	24c1                	addiw	s1,s1,16
    800036a2:	04c92783          	lw	a5,76(s2)
    800036a6:	04f4f163          	bgeu	s1,a5,800036e8 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036aa:	4741                	li	a4,16
    800036ac:	86a6                	mv	a3,s1
    800036ae:	fc040613          	addi	a2,s0,-64
    800036b2:	4581                	li	a1,0
    800036b4:	854a                	mv	a0,s2
    800036b6:	d89ff0ef          	jal	8000343e <readi>
    800036ba:	47c1                	li	a5,16
    800036bc:	fcf51ce3          	bne	a0,a5,80003694 <dirlookup+0x36>
    if(de.inum == 0)
    800036c0:	fc045783          	lhu	a5,-64(s0)
    800036c4:	dff1                	beqz	a5,800036a0 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800036c6:	fc240593          	addi	a1,s0,-62
    800036ca:	854e                	mv	a0,s3
    800036cc:	f7dff0ef          	jal	80003648 <namecmp>
    800036d0:	f961                	bnez	a0,800036a0 <dirlookup+0x42>
      if(poff)
    800036d2:	000a0463          	beqz	s4,800036da <dirlookup+0x7c>
        *poff = off;
    800036d6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800036da:	fc045583          	lhu	a1,-64(s0)
    800036de:	00092503          	lw	a0,0(s2)
    800036e2:	829ff0ef          	jal	80002f0a <iget>
    800036e6:	a011                	j	800036ea <dirlookup+0x8c>
  return 0;
    800036e8:	4501                	li	a0,0
}
    800036ea:	70e2                	ld	ra,56(sp)
    800036ec:	7442                	ld	s0,48(sp)
    800036ee:	74a2                	ld	s1,40(sp)
    800036f0:	7902                	ld	s2,32(sp)
    800036f2:	69e2                	ld	s3,24(sp)
    800036f4:	6a42                	ld	s4,16(sp)
    800036f6:	6121                	addi	sp,sp,64
    800036f8:	8082                	ret

00000000800036fa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800036fa:	711d                	addi	sp,sp,-96
    800036fc:	ec86                	sd	ra,88(sp)
    800036fe:	e8a2                	sd	s0,80(sp)
    80003700:	e4a6                	sd	s1,72(sp)
    80003702:	e0ca                	sd	s2,64(sp)
    80003704:	fc4e                	sd	s3,56(sp)
    80003706:	f852                	sd	s4,48(sp)
    80003708:	f456                	sd	s5,40(sp)
    8000370a:	f05a                	sd	s6,32(sp)
    8000370c:	ec5e                	sd	s7,24(sp)
    8000370e:	e862                	sd	s8,16(sp)
    80003710:	e466                	sd	s9,8(sp)
    80003712:	1080                	addi	s0,sp,96
    80003714:	84aa                	mv	s1,a0
    80003716:	8b2e                	mv	s6,a1
    80003718:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000371a:	00054703          	lbu	a4,0(a0)
    8000371e:	02f00793          	li	a5,47
    80003722:	00f70e63          	beq	a4,a5,8000373e <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003726:	9e4fe0ef          	jal	8000190a <myproc>
    8000372a:	15053503          	ld	a0,336(a0)
    8000372e:	a87ff0ef          	jal	800031b4 <idup>
    80003732:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003734:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003738:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000373a:	4b85                	li	s7,1
    8000373c:	a871                	j	800037d8 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    8000373e:	4585                	li	a1,1
    80003740:	4505                	li	a0,1
    80003742:	fc8ff0ef          	jal	80002f0a <iget>
    80003746:	8a2a                	mv	s4,a0
    80003748:	b7f5                	j	80003734 <namex+0x3a>
      iunlockput(ip);
    8000374a:	8552                	mv	a0,s4
    8000374c:	ca9ff0ef          	jal	800033f4 <iunlockput>
      return 0;
    80003750:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003752:	8552                	mv	a0,s4
    80003754:	60e6                	ld	ra,88(sp)
    80003756:	6446                	ld	s0,80(sp)
    80003758:	64a6                	ld	s1,72(sp)
    8000375a:	6906                	ld	s2,64(sp)
    8000375c:	79e2                	ld	s3,56(sp)
    8000375e:	7a42                	ld	s4,48(sp)
    80003760:	7aa2                	ld	s5,40(sp)
    80003762:	7b02                	ld	s6,32(sp)
    80003764:	6be2                	ld	s7,24(sp)
    80003766:	6c42                	ld	s8,16(sp)
    80003768:	6ca2                	ld	s9,8(sp)
    8000376a:	6125                	addi	sp,sp,96
    8000376c:	8082                	ret
      iunlock(ip);
    8000376e:	8552                	mv	a0,s4
    80003770:	b29ff0ef          	jal	80003298 <iunlock>
      return ip;
    80003774:	bff9                	j	80003752 <namex+0x58>
      iunlockput(ip);
    80003776:	8552                	mv	a0,s4
    80003778:	c7dff0ef          	jal	800033f4 <iunlockput>
      return 0;
    8000377c:	8a4e                	mv	s4,s3
    8000377e:	bfd1                	j	80003752 <namex+0x58>
  len = path - s;
    80003780:	40998633          	sub	a2,s3,s1
    80003784:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003788:	099c5063          	bge	s8,s9,80003808 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    8000378c:	4639                	li	a2,14
    8000378e:	85a6                	mv	a1,s1
    80003790:	8556                	mv	a0,s5
    80003792:	d92fd0ef          	jal	80000d24 <memmove>
    80003796:	84ce                	mv	s1,s3
  while(*path == '/')
    80003798:	0004c783          	lbu	a5,0(s1)
    8000379c:	01279763          	bne	a5,s2,800037aa <namex+0xb0>
    path++;
    800037a0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800037a2:	0004c783          	lbu	a5,0(s1)
    800037a6:	ff278de3          	beq	a5,s2,800037a0 <namex+0xa6>
    ilock(ip);
    800037aa:	8552                	mv	a0,s4
    800037ac:	a3fff0ef          	jal	800031ea <ilock>
    if(ip->type != T_DIR){
    800037b0:	044a1783          	lh	a5,68(s4)
    800037b4:	f9779be3          	bne	a5,s7,8000374a <namex+0x50>
    if(nameiparent && *path == '\0'){
    800037b8:	000b0563          	beqz	s6,800037c2 <namex+0xc8>
    800037bc:	0004c783          	lbu	a5,0(s1)
    800037c0:	d7dd                	beqz	a5,8000376e <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800037c2:	4601                	li	a2,0
    800037c4:	85d6                	mv	a1,s5
    800037c6:	8552                	mv	a0,s4
    800037c8:	e97ff0ef          	jal	8000365e <dirlookup>
    800037cc:	89aa                	mv	s3,a0
    800037ce:	d545                	beqz	a0,80003776 <namex+0x7c>
    iunlockput(ip);
    800037d0:	8552                	mv	a0,s4
    800037d2:	c23ff0ef          	jal	800033f4 <iunlockput>
    ip = next;
    800037d6:	8a4e                	mv	s4,s3
  while(*path == '/')
    800037d8:	0004c783          	lbu	a5,0(s1)
    800037dc:	01279763          	bne	a5,s2,800037ea <namex+0xf0>
    path++;
    800037e0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800037e2:	0004c783          	lbu	a5,0(s1)
    800037e6:	ff278de3          	beq	a5,s2,800037e0 <namex+0xe6>
  if(*path == 0)
    800037ea:	cb8d                	beqz	a5,8000381c <namex+0x122>
  while(*path != '/' && *path != 0)
    800037ec:	0004c783          	lbu	a5,0(s1)
    800037f0:	89a6                	mv	s3,s1
  len = path - s;
    800037f2:	4c81                	li	s9,0
    800037f4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800037f6:	01278963          	beq	a5,s2,80003808 <namex+0x10e>
    800037fa:	d3d9                	beqz	a5,80003780 <namex+0x86>
    path++;
    800037fc:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800037fe:	0009c783          	lbu	a5,0(s3)
    80003802:	ff279ce3          	bne	a5,s2,800037fa <namex+0x100>
    80003806:	bfad                	j	80003780 <namex+0x86>
    memmove(name, s, len);
    80003808:	2601                	sext.w	a2,a2
    8000380a:	85a6                	mv	a1,s1
    8000380c:	8556                	mv	a0,s5
    8000380e:	d16fd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003812:	9cd6                	add	s9,s9,s5
    80003814:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003818:	84ce                	mv	s1,s3
    8000381a:	bfbd                	j	80003798 <namex+0x9e>
  if(nameiparent){
    8000381c:	f20b0be3          	beqz	s6,80003752 <namex+0x58>
    iput(ip);
    80003820:	8552                	mv	a0,s4
    80003822:	b4bff0ef          	jal	8000336c <iput>
    return 0;
    80003826:	4a01                	li	s4,0
    80003828:	b72d                	j	80003752 <namex+0x58>

000000008000382a <dirlink>:
{
    8000382a:	7139                	addi	sp,sp,-64
    8000382c:	fc06                	sd	ra,56(sp)
    8000382e:	f822                	sd	s0,48(sp)
    80003830:	f04a                	sd	s2,32(sp)
    80003832:	ec4e                	sd	s3,24(sp)
    80003834:	e852                	sd	s4,16(sp)
    80003836:	0080                	addi	s0,sp,64
    80003838:	892a                	mv	s2,a0
    8000383a:	8a2e                	mv	s4,a1
    8000383c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000383e:	4601                	li	a2,0
    80003840:	e1fff0ef          	jal	8000365e <dirlookup>
    80003844:	e535                	bnez	a0,800038b0 <dirlink+0x86>
    80003846:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003848:	04c92483          	lw	s1,76(s2)
    8000384c:	c48d                	beqz	s1,80003876 <dirlink+0x4c>
    8000384e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003850:	4741                	li	a4,16
    80003852:	86a6                	mv	a3,s1
    80003854:	fc040613          	addi	a2,s0,-64
    80003858:	4581                	li	a1,0
    8000385a:	854a                	mv	a0,s2
    8000385c:	be3ff0ef          	jal	8000343e <readi>
    80003860:	47c1                	li	a5,16
    80003862:	04f51b63          	bne	a0,a5,800038b8 <dirlink+0x8e>
    if(de.inum == 0)
    80003866:	fc045783          	lhu	a5,-64(s0)
    8000386a:	c791                	beqz	a5,80003876 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000386c:	24c1                	addiw	s1,s1,16
    8000386e:	04c92783          	lw	a5,76(s2)
    80003872:	fcf4efe3          	bltu	s1,a5,80003850 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003876:	4639                	li	a2,14
    80003878:	85d2                	mv	a1,s4
    8000387a:	fc240513          	addi	a0,s0,-62
    8000387e:	d4cfd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003882:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003886:	4741                	li	a4,16
    80003888:	86a6                	mv	a3,s1
    8000388a:	fc040613          	addi	a2,s0,-64
    8000388e:	4581                	li	a1,0
    80003890:	854a                	mv	a0,s2
    80003892:	ca9ff0ef          	jal	8000353a <writei>
    80003896:	1541                	addi	a0,a0,-16
    80003898:	00a03533          	snez	a0,a0
    8000389c:	40a00533          	neg	a0,a0
    800038a0:	74a2                	ld	s1,40(sp)
}
    800038a2:	70e2                	ld	ra,56(sp)
    800038a4:	7442                	ld	s0,48(sp)
    800038a6:	7902                	ld	s2,32(sp)
    800038a8:	69e2                	ld	s3,24(sp)
    800038aa:	6a42                	ld	s4,16(sp)
    800038ac:	6121                	addi	sp,sp,64
    800038ae:	8082                	ret
    iput(ip);
    800038b0:	abdff0ef          	jal	8000336c <iput>
    return -1;
    800038b4:	557d                	li	a0,-1
    800038b6:	b7f5                	j	800038a2 <dirlink+0x78>
      panic("dirlink read");
    800038b8:	00004517          	auipc	a0,0x4
    800038bc:	d9050513          	addi	a0,a0,-624 # 80007648 <etext+0x648>
    800038c0:	ed5fc0ef          	jal	80000794 <panic>

00000000800038c4 <namei>:

struct inode*
namei(char *path)
{
    800038c4:	1101                	addi	sp,sp,-32
    800038c6:	ec06                	sd	ra,24(sp)
    800038c8:	e822                	sd	s0,16(sp)
    800038ca:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800038cc:	fe040613          	addi	a2,s0,-32
    800038d0:	4581                	li	a1,0
    800038d2:	e29ff0ef          	jal	800036fa <namex>
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	6105                	addi	sp,sp,32
    800038dc:	8082                	ret

00000000800038de <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800038de:	1141                	addi	sp,sp,-16
    800038e0:	e406                	sd	ra,8(sp)
    800038e2:	e022                	sd	s0,0(sp)
    800038e4:	0800                	addi	s0,sp,16
    800038e6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800038e8:	4585                	li	a1,1
    800038ea:	e11ff0ef          	jal	800036fa <namex>
}
    800038ee:	60a2                	ld	ra,8(sp)
    800038f0:	6402                	ld	s0,0(sp)
    800038f2:	0141                	addi	sp,sp,16
    800038f4:	8082                	ret

00000000800038f6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800038f6:	1101                	addi	sp,sp,-32
    800038f8:	ec06                	sd	ra,24(sp)
    800038fa:	e822                	sd	s0,16(sp)
    800038fc:	e426                	sd	s1,8(sp)
    800038fe:	e04a                	sd	s2,0(sp)
    80003900:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003902:	0001c917          	auipc	s2,0x1c
    80003906:	24e90913          	addi	s2,s2,590 # 8001fb50 <log>
    8000390a:	01892583          	lw	a1,24(s2)
    8000390e:	02892503          	lw	a0,40(s2)
    80003912:	9a0ff0ef          	jal	80002ab2 <bread>
    80003916:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003918:	02c92603          	lw	a2,44(s2)
    8000391c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000391e:	00c05f63          	blez	a2,8000393c <write_head+0x46>
    80003922:	0001c717          	auipc	a4,0x1c
    80003926:	25e70713          	addi	a4,a4,606 # 8001fb80 <log+0x30>
    8000392a:	87aa                	mv	a5,a0
    8000392c:	060a                	slli	a2,a2,0x2
    8000392e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003930:	4314                	lw	a3,0(a4)
    80003932:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003934:	0711                	addi	a4,a4,4
    80003936:	0791                	addi	a5,a5,4
    80003938:	fec79ce3          	bne	a5,a2,80003930 <write_head+0x3a>
  }
  bwrite(buf);
    8000393c:	8526                	mv	a0,s1
    8000393e:	a4aff0ef          	jal	80002b88 <bwrite>
  brelse(buf);
    80003942:	8526                	mv	a0,s1
    80003944:	a76ff0ef          	jal	80002bba <brelse>
}
    80003948:	60e2                	ld	ra,24(sp)
    8000394a:	6442                	ld	s0,16(sp)
    8000394c:	64a2                	ld	s1,8(sp)
    8000394e:	6902                	ld	s2,0(sp)
    80003950:	6105                	addi	sp,sp,32
    80003952:	8082                	ret

0000000080003954 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003954:	0001c797          	auipc	a5,0x1c
    80003958:	2287a783          	lw	a5,552(a5) # 8001fb7c <log+0x2c>
    8000395c:	08f05f63          	blez	a5,800039fa <install_trans+0xa6>
{
    80003960:	7139                	addi	sp,sp,-64
    80003962:	fc06                	sd	ra,56(sp)
    80003964:	f822                	sd	s0,48(sp)
    80003966:	f426                	sd	s1,40(sp)
    80003968:	f04a                	sd	s2,32(sp)
    8000396a:	ec4e                	sd	s3,24(sp)
    8000396c:	e852                	sd	s4,16(sp)
    8000396e:	e456                	sd	s5,8(sp)
    80003970:	e05a                	sd	s6,0(sp)
    80003972:	0080                	addi	s0,sp,64
    80003974:	8b2a                	mv	s6,a0
    80003976:	0001ca97          	auipc	s5,0x1c
    8000397a:	20aa8a93          	addi	s5,s5,522 # 8001fb80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000397e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003980:	0001c997          	auipc	s3,0x1c
    80003984:	1d098993          	addi	s3,s3,464 # 8001fb50 <log>
    80003988:	a829                	j	800039a2 <install_trans+0x4e>
    brelse(lbuf);
    8000398a:	854a                	mv	a0,s2
    8000398c:	a2eff0ef          	jal	80002bba <brelse>
    brelse(dbuf);
    80003990:	8526                	mv	a0,s1
    80003992:	a28ff0ef          	jal	80002bba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003996:	2a05                	addiw	s4,s4,1
    80003998:	0a91                	addi	s5,s5,4
    8000399a:	02c9a783          	lw	a5,44(s3)
    8000399e:	04fa5463          	bge	s4,a5,800039e6 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800039a2:	0189a583          	lw	a1,24(s3)
    800039a6:	014585bb          	addw	a1,a1,s4
    800039aa:	2585                	addiw	a1,a1,1
    800039ac:	0289a503          	lw	a0,40(s3)
    800039b0:	902ff0ef          	jal	80002ab2 <bread>
    800039b4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800039b6:	000aa583          	lw	a1,0(s5)
    800039ba:	0289a503          	lw	a0,40(s3)
    800039be:	8f4ff0ef          	jal	80002ab2 <bread>
    800039c2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800039c4:	40000613          	li	a2,1024
    800039c8:	05890593          	addi	a1,s2,88
    800039cc:	05850513          	addi	a0,a0,88
    800039d0:	b54fd0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    800039d4:	8526                	mv	a0,s1
    800039d6:	9b2ff0ef          	jal	80002b88 <bwrite>
    if(recovering == 0)
    800039da:	fa0b18e3          	bnez	s6,8000398a <install_trans+0x36>
      bunpin(dbuf);
    800039de:	8526                	mv	a0,s1
    800039e0:	a96ff0ef          	jal	80002c76 <bunpin>
    800039e4:	b75d                	j	8000398a <install_trans+0x36>
}
    800039e6:	70e2                	ld	ra,56(sp)
    800039e8:	7442                	ld	s0,48(sp)
    800039ea:	74a2                	ld	s1,40(sp)
    800039ec:	7902                	ld	s2,32(sp)
    800039ee:	69e2                	ld	s3,24(sp)
    800039f0:	6a42                	ld	s4,16(sp)
    800039f2:	6aa2                	ld	s5,8(sp)
    800039f4:	6b02                	ld	s6,0(sp)
    800039f6:	6121                	addi	sp,sp,64
    800039f8:	8082                	ret
    800039fa:	8082                	ret

00000000800039fc <initlog>:
{
    800039fc:	7179                	addi	sp,sp,-48
    800039fe:	f406                	sd	ra,40(sp)
    80003a00:	f022                	sd	s0,32(sp)
    80003a02:	ec26                	sd	s1,24(sp)
    80003a04:	e84a                	sd	s2,16(sp)
    80003a06:	e44e                	sd	s3,8(sp)
    80003a08:	1800                	addi	s0,sp,48
    80003a0a:	892a                	mv	s2,a0
    80003a0c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003a0e:	0001c497          	auipc	s1,0x1c
    80003a12:	14248493          	addi	s1,s1,322 # 8001fb50 <log>
    80003a16:	00004597          	auipc	a1,0x4
    80003a1a:	c4258593          	addi	a1,a1,-958 # 80007658 <etext+0x658>
    80003a1e:	8526                	mv	a0,s1
    80003a20:	954fd0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003a24:	0149a583          	lw	a1,20(s3)
    80003a28:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003a2a:	0109a783          	lw	a5,16(s3)
    80003a2e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003a30:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003a34:	854a                	mv	a0,s2
    80003a36:	87cff0ef          	jal	80002ab2 <bread>
  log.lh.n = lh->n;
    80003a3a:	4d30                	lw	a2,88(a0)
    80003a3c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003a3e:	00c05f63          	blez	a2,80003a5c <initlog+0x60>
    80003a42:	87aa                	mv	a5,a0
    80003a44:	0001c717          	auipc	a4,0x1c
    80003a48:	13c70713          	addi	a4,a4,316 # 8001fb80 <log+0x30>
    80003a4c:	060a                	slli	a2,a2,0x2
    80003a4e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003a50:	4ff4                	lw	a3,92(a5)
    80003a52:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003a54:	0791                	addi	a5,a5,4
    80003a56:	0711                	addi	a4,a4,4
    80003a58:	fec79ce3          	bne	a5,a2,80003a50 <initlog+0x54>
  brelse(buf);
    80003a5c:	95eff0ef          	jal	80002bba <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003a60:	4505                	li	a0,1
    80003a62:	ef3ff0ef          	jal	80003954 <install_trans>
  log.lh.n = 0;
    80003a66:	0001c797          	auipc	a5,0x1c
    80003a6a:	1007ab23          	sw	zero,278(a5) # 8001fb7c <log+0x2c>
  write_head(); // clear the log
    80003a6e:	e89ff0ef          	jal	800038f6 <write_head>
}
    80003a72:	70a2                	ld	ra,40(sp)
    80003a74:	7402                	ld	s0,32(sp)
    80003a76:	64e2                	ld	s1,24(sp)
    80003a78:	6942                	ld	s2,16(sp)
    80003a7a:	69a2                	ld	s3,8(sp)
    80003a7c:	6145                	addi	sp,sp,48
    80003a7e:	8082                	ret

0000000080003a80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003a80:	1101                	addi	sp,sp,-32
    80003a82:	ec06                	sd	ra,24(sp)
    80003a84:	e822                	sd	s0,16(sp)
    80003a86:	e426                	sd	s1,8(sp)
    80003a88:	e04a                	sd	s2,0(sp)
    80003a8a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003a8c:	0001c517          	auipc	a0,0x1c
    80003a90:	0c450513          	addi	a0,a0,196 # 8001fb50 <log>
    80003a94:	960fd0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003a98:	0001c497          	auipc	s1,0x1c
    80003a9c:	0b848493          	addi	s1,s1,184 # 8001fb50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003aa0:	4979                	li	s2,30
    80003aa2:	a029                	j	80003aac <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003aa4:	85a6                	mv	a1,s1
    80003aa6:	8526                	mv	a0,s1
    80003aa8:	c30fe0ef          	jal	80001ed8 <sleep>
    if(log.committing){
    80003aac:	50dc                	lw	a5,36(s1)
    80003aae:	fbfd                	bnez	a5,80003aa4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ab0:	5098                	lw	a4,32(s1)
    80003ab2:	2705                	addiw	a4,a4,1
    80003ab4:	0027179b          	slliw	a5,a4,0x2
    80003ab8:	9fb9                	addw	a5,a5,a4
    80003aba:	0017979b          	slliw	a5,a5,0x1
    80003abe:	54d4                	lw	a3,44(s1)
    80003ac0:	9fb5                	addw	a5,a5,a3
    80003ac2:	00f95763          	bge	s2,a5,80003ad0 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003ac6:	85a6                	mv	a1,s1
    80003ac8:	8526                	mv	a0,s1
    80003aca:	c0efe0ef          	jal	80001ed8 <sleep>
    80003ace:	bff9                	j	80003aac <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003ad0:	0001c517          	auipc	a0,0x1c
    80003ad4:	08050513          	addi	a0,a0,128 # 8001fb50 <log>
    80003ad8:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003ada:	9b2fd0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003ade:	60e2                	ld	ra,24(sp)
    80003ae0:	6442                	ld	s0,16(sp)
    80003ae2:	64a2                	ld	s1,8(sp)
    80003ae4:	6902                	ld	s2,0(sp)
    80003ae6:	6105                	addi	sp,sp,32
    80003ae8:	8082                	ret

0000000080003aea <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003aea:	7139                	addi	sp,sp,-64
    80003aec:	fc06                	sd	ra,56(sp)
    80003aee:	f822                	sd	s0,48(sp)
    80003af0:	f426                	sd	s1,40(sp)
    80003af2:	f04a                	sd	s2,32(sp)
    80003af4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003af6:	0001c497          	auipc	s1,0x1c
    80003afa:	05a48493          	addi	s1,s1,90 # 8001fb50 <log>
    80003afe:	8526                	mv	a0,s1
    80003b00:	8f4fd0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003b04:	509c                	lw	a5,32(s1)
    80003b06:	37fd                	addiw	a5,a5,-1
    80003b08:	0007891b          	sext.w	s2,a5
    80003b0c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003b0e:	50dc                	lw	a5,36(s1)
    80003b10:	ef9d                	bnez	a5,80003b4e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003b12:	04091763          	bnez	s2,80003b60 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003b16:	0001c497          	auipc	s1,0x1c
    80003b1a:	03a48493          	addi	s1,s1,58 # 8001fb50 <log>
    80003b1e:	4785                	li	a5,1
    80003b20:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003b22:	8526                	mv	a0,s1
    80003b24:	968fd0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003b28:	54dc                	lw	a5,44(s1)
    80003b2a:	04f04b63          	bgtz	a5,80003b80 <end_op+0x96>
    acquire(&log.lock);
    80003b2e:	0001c497          	auipc	s1,0x1c
    80003b32:	02248493          	addi	s1,s1,34 # 8001fb50 <log>
    80003b36:	8526                	mv	a0,s1
    80003b38:	8bcfd0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003b3c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b40:	8526                	mv	a0,s1
    80003b42:	be2fe0ef          	jal	80001f24 <wakeup>
    release(&log.lock);
    80003b46:	8526                	mv	a0,s1
    80003b48:	944fd0ef          	jal	80000c8c <release>
}
    80003b4c:	a025                	j	80003b74 <end_op+0x8a>
    80003b4e:	ec4e                	sd	s3,24(sp)
    80003b50:	e852                	sd	s4,16(sp)
    80003b52:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003b54:	00004517          	auipc	a0,0x4
    80003b58:	b0c50513          	addi	a0,a0,-1268 # 80007660 <etext+0x660>
    80003b5c:	c39fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003b60:	0001c497          	auipc	s1,0x1c
    80003b64:	ff048493          	addi	s1,s1,-16 # 8001fb50 <log>
    80003b68:	8526                	mv	a0,s1
    80003b6a:	bbafe0ef          	jal	80001f24 <wakeup>
  release(&log.lock);
    80003b6e:	8526                	mv	a0,s1
    80003b70:	91cfd0ef          	jal	80000c8c <release>
}
    80003b74:	70e2                	ld	ra,56(sp)
    80003b76:	7442                	ld	s0,48(sp)
    80003b78:	74a2                	ld	s1,40(sp)
    80003b7a:	7902                	ld	s2,32(sp)
    80003b7c:	6121                	addi	sp,sp,64
    80003b7e:	8082                	ret
    80003b80:	ec4e                	sd	s3,24(sp)
    80003b82:	e852                	sd	s4,16(sp)
    80003b84:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b86:	0001ca97          	auipc	s5,0x1c
    80003b8a:	ffaa8a93          	addi	s5,s5,-6 # 8001fb80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003b8e:	0001ca17          	auipc	s4,0x1c
    80003b92:	fc2a0a13          	addi	s4,s4,-62 # 8001fb50 <log>
    80003b96:	018a2583          	lw	a1,24(s4)
    80003b9a:	012585bb          	addw	a1,a1,s2
    80003b9e:	2585                	addiw	a1,a1,1
    80003ba0:	028a2503          	lw	a0,40(s4)
    80003ba4:	f0ffe0ef          	jal	80002ab2 <bread>
    80003ba8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003baa:	000aa583          	lw	a1,0(s5)
    80003bae:	028a2503          	lw	a0,40(s4)
    80003bb2:	f01fe0ef          	jal	80002ab2 <bread>
    80003bb6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003bb8:	40000613          	li	a2,1024
    80003bbc:	05850593          	addi	a1,a0,88
    80003bc0:	05848513          	addi	a0,s1,88
    80003bc4:	960fd0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003bc8:	8526                	mv	a0,s1
    80003bca:	fbffe0ef          	jal	80002b88 <bwrite>
    brelse(from);
    80003bce:	854e                	mv	a0,s3
    80003bd0:	febfe0ef          	jal	80002bba <brelse>
    brelse(to);
    80003bd4:	8526                	mv	a0,s1
    80003bd6:	fe5fe0ef          	jal	80002bba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bda:	2905                	addiw	s2,s2,1
    80003bdc:	0a91                	addi	s5,s5,4
    80003bde:	02ca2783          	lw	a5,44(s4)
    80003be2:	faf94ae3          	blt	s2,a5,80003b96 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003be6:	d11ff0ef          	jal	800038f6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003bea:	4501                	li	a0,0
    80003bec:	d69ff0ef          	jal	80003954 <install_trans>
    log.lh.n = 0;
    80003bf0:	0001c797          	auipc	a5,0x1c
    80003bf4:	f807a623          	sw	zero,-116(a5) # 8001fb7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003bf8:	cffff0ef          	jal	800038f6 <write_head>
    80003bfc:	69e2                	ld	s3,24(sp)
    80003bfe:	6a42                	ld	s4,16(sp)
    80003c00:	6aa2                	ld	s5,8(sp)
    80003c02:	b735                	j	80003b2e <end_op+0x44>

0000000080003c04 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003c04:	1101                	addi	sp,sp,-32
    80003c06:	ec06                	sd	ra,24(sp)
    80003c08:	e822                	sd	s0,16(sp)
    80003c0a:	e426                	sd	s1,8(sp)
    80003c0c:	e04a                	sd	s2,0(sp)
    80003c0e:	1000                	addi	s0,sp,32
    80003c10:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003c12:	0001c917          	auipc	s2,0x1c
    80003c16:	f3e90913          	addi	s2,s2,-194 # 8001fb50 <log>
    80003c1a:	854a                	mv	a0,s2
    80003c1c:	fd9fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003c20:	02c92603          	lw	a2,44(s2)
    80003c24:	47f5                	li	a5,29
    80003c26:	06c7c363          	blt	a5,a2,80003c8c <log_write+0x88>
    80003c2a:	0001c797          	auipc	a5,0x1c
    80003c2e:	f427a783          	lw	a5,-190(a5) # 8001fb6c <log+0x1c>
    80003c32:	37fd                	addiw	a5,a5,-1
    80003c34:	04f65c63          	bge	a2,a5,80003c8c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003c38:	0001c797          	auipc	a5,0x1c
    80003c3c:	f387a783          	lw	a5,-200(a5) # 8001fb70 <log+0x20>
    80003c40:	04f05c63          	blez	a5,80003c98 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003c44:	4781                	li	a5,0
    80003c46:	04c05f63          	blez	a2,80003ca4 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c4a:	44cc                	lw	a1,12(s1)
    80003c4c:	0001c717          	auipc	a4,0x1c
    80003c50:	f3470713          	addi	a4,a4,-204 # 8001fb80 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003c54:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003c56:	4314                	lw	a3,0(a4)
    80003c58:	04b68663          	beq	a3,a1,80003ca4 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003c5c:	2785                	addiw	a5,a5,1
    80003c5e:	0711                	addi	a4,a4,4
    80003c60:	fef61be3          	bne	a2,a5,80003c56 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003c64:	0621                	addi	a2,a2,8
    80003c66:	060a                	slli	a2,a2,0x2
    80003c68:	0001c797          	auipc	a5,0x1c
    80003c6c:	ee878793          	addi	a5,a5,-280 # 8001fb50 <log>
    80003c70:	97b2                	add	a5,a5,a2
    80003c72:	44d8                	lw	a4,12(s1)
    80003c74:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003c76:	8526                	mv	a0,s1
    80003c78:	fcbfe0ef          	jal	80002c42 <bpin>
    log.lh.n++;
    80003c7c:	0001c717          	auipc	a4,0x1c
    80003c80:	ed470713          	addi	a4,a4,-300 # 8001fb50 <log>
    80003c84:	575c                	lw	a5,44(a4)
    80003c86:	2785                	addiw	a5,a5,1
    80003c88:	d75c                	sw	a5,44(a4)
    80003c8a:	a80d                	j	80003cbc <log_write+0xb8>
    panic("too big a transaction");
    80003c8c:	00004517          	auipc	a0,0x4
    80003c90:	9e450513          	addi	a0,a0,-1564 # 80007670 <etext+0x670>
    80003c94:	b01fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003c98:	00004517          	auipc	a0,0x4
    80003c9c:	9f050513          	addi	a0,a0,-1552 # 80007688 <etext+0x688>
    80003ca0:	af5fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003ca4:	00878693          	addi	a3,a5,8
    80003ca8:	068a                	slli	a3,a3,0x2
    80003caa:	0001c717          	auipc	a4,0x1c
    80003cae:	ea670713          	addi	a4,a4,-346 # 8001fb50 <log>
    80003cb2:	9736                	add	a4,a4,a3
    80003cb4:	44d4                	lw	a3,12(s1)
    80003cb6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003cb8:	faf60fe3          	beq	a2,a5,80003c76 <log_write+0x72>
  }
  release(&log.lock);
    80003cbc:	0001c517          	auipc	a0,0x1c
    80003cc0:	e9450513          	addi	a0,a0,-364 # 8001fb50 <log>
    80003cc4:	fc9fc0ef          	jal	80000c8c <release>
}
    80003cc8:	60e2                	ld	ra,24(sp)
    80003cca:	6442                	ld	s0,16(sp)
    80003ccc:	64a2                	ld	s1,8(sp)
    80003cce:	6902                	ld	s2,0(sp)
    80003cd0:	6105                	addi	sp,sp,32
    80003cd2:	8082                	ret

0000000080003cd4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003cd4:	1101                	addi	sp,sp,-32
    80003cd6:	ec06                	sd	ra,24(sp)
    80003cd8:	e822                	sd	s0,16(sp)
    80003cda:	e426                	sd	s1,8(sp)
    80003cdc:	e04a                	sd	s2,0(sp)
    80003cde:	1000                	addi	s0,sp,32
    80003ce0:	84aa                	mv	s1,a0
    80003ce2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ce4:	00004597          	auipc	a1,0x4
    80003ce8:	9c458593          	addi	a1,a1,-1596 # 800076a8 <etext+0x6a8>
    80003cec:	0521                	addi	a0,a0,8
    80003cee:	e87fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80003cf2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003cf6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003cfa:	0204a423          	sw	zero,40(s1)
}
    80003cfe:	60e2                	ld	ra,24(sp)
    80003d00:	6442                	ld	s0,16(sp)
    80003d02:	64a2                	ld	s1,8(sp)
    80003d04:	6902                	ld	s2,0(sp)
    80003d06:	6105                	addi	sp,sp,32
    80003d08:	8082                	ret

0000000080003d0a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003d0a:	1101                	addi	sp,sp,-32
    80003d0c:	ec06                	sd	ra,24(sp)
    80003d0e:	e822                	sd	s0,16(sp)
    80003d10:	e426                	sd	s1,8(sp)
    80003d12:	e04a                	sd	s2,0(sp)
    80003d14:	1000                	addi	s0,sp,32
    80003d16:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d18:	00850913          	addi	s2,a0,8
    80003d1c:	854a                	mv	a0,s2
    80003d1e:	ed7fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80003d22:	409c                	lw	a5,0(s1)
    80003d24:	c799                	beqz	a5,80003d32 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003d26:	85ca                	mv	a1,s2
    80003d28:	8526                	mv	a0,s1
    80003d2a:	9aefe0ef          	jal	80001ed8 <sleep>
  while (lk->locked) {
    80003d2e:	409c                	lw	a5,0(s1)
    80003d30:	fbfd                	bnez	a5,80003d26 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003d32:	4785                	li	a5,1
    80003d34:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003d36:	bd5fd0ef          	jal	8000190a <myproc>
    80003d3a:	591c                	lw	a5,48(a0)
    80003d3c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003d3e:	854a                	mv	a0,s2
    80003d40:	f4dfc0ef          	jal	80000c8c <release>
}
    80003d44:	60e2                	ld	ra,24(sp)
    80003d46:	6442                	ld	s0,16(sp)
    80003d48:	64a2                	ld	s1,8(sp)
    80003d4a:	6902                	ld	s2,0(sp)
    80003d4c:	6105                	addi	sp,sp,32
    80003d4e:	8082                	ret

0000000080003d50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003d50:	1101                	addi	sp,sp,-32
    80003d52:	ec06                	sd	ra,24(sp)
    80003d54:	e822                	sd	s0,16(sp)
    80003d56:	e426                	sd	s1,8(sp)
    80003d58:	e04a                	sd	s2,0(sp)
    80003d5a:	1000                	addi	s0,sp,32
    80003d5c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d5e:	00850913          	addi	s2,a0,8
    80003d62:	854a                	mv	a0,s2
    80003d64:	e91fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80003d68:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d6c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003d70:	8526                	mv	a0,s1
    80003d72:	9b2fe0ef          	jal	80001f24 <wakeup>
  release(&lk->lk);
    80003d76:	854a                	mv	a0,s2
    80003d78:	f15fc0ef          	jal	80000c8c <release>
}
    80003d7c:	60e2                	ld	ra,24(sp)
    80003d7e:	6442                	ld	s0,16(sp)
    80003d80:	64a2                	ld	s1,8(sp)
    80003d82:	6902                	ld	s2,0(sp)
    80003d84:	6105                	addi	sp,sp,32
    80003d86:	8082                	ret

0000000080003d88 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003d88:	7179                	addi	sp,sp,-48
    80003d8a:	f406                	sd	ra,40(sp)
    80003d8c:	f022                	sd	s0,32(sp)
    80003d8e:	ec26                	sd	s1,24(sp)
    80003d90:	e84a                	sd	s2,16(sp)
    80003d92:	1800                	addi	s0,sp,48
    80003d94:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003d96:	00850913          	addi	s2,a0,8
    80003d9a:	854a                	mv	a0,s2
    80003d9c:	e59fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003da0:	409c                	lw	a5,0(s1)
    80003da2:	ef81                	bnez	a5,80003dba <holdingsleep+0x32>
    80003da4:	4481                	li	s1,0
  release(&lk->lk);
    80003da6:	854a                	mv	a0,s2
    80003da8:	ee5fc0ef          	jal	80000c8c <release>
  return r;
}
    80003dac:	8526                	mv	a0,s1
    80003dae:	70a2                	ld	ra,40(sp)
    80003db0:	7402                	ld	s0,32(sp)
    80003db2:	64e2                	ld	s1,24(sp)
    80003db4:	6942                	ld	s2,16(sp)
    80003db6:	6145                	addi	sp,sp,48
    80003db8:	8082                	ret
    80003dba:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003dbc:	0284a983          	lw	s3,40(s1)
    80003dc0:	b4bfd0ef          	jal	8000190a <myproc>
    80003dc4:	5904                	lw	s1,48(a0)
    80003dc6:	413484b3          	sub	s1,s1,s3
    80003dca:	0014b493          	seqz	s1,s1
    80003dce:	69a2                	ld	s3,8(sp)
    80003dd0:	bfd9                	j	80003da6 <holdingsleep+0x1e>

0000000080003dd2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003dd2:	1141                	addi	sp,sp,-16
    80003dd4:	e406                	sd	ra,8(sp)
    80003dd6:	e022                	sd	s0,0(sp)
    80003dd8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003dda:	00004597          	auipc	a1,0x4
    80003dde:	8de58593          	addi	a1,a1,-1826 # 800076b8 <etext+0x6b8>
    80003de2:	0001c517          	auipc	a0,0x1c
    80003de6:	eb650513          	addi	a0,a0,-330 # 8001fc98 <ftable>
    80003dea:	d8bfc0ef          	jal	80000b74 <initlock>
}
    80003dee:	60a2                	ld	ra,8(sp)
    80003df0:	6402                	ld	s0,0(sp)
    80003df2:	0141                	addi	sp,sp,16
    80003df4:	8082                	ret

0000000080003df6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003df6:	1101                	addi	sp,sp,-32
    80003df8:	ec06                	sd	ra,24(sp)
    80003dfa:	e822                	sd	s0,16(sp)
    80003dfc:	e426                	sd	s1,8(sp)
    80003dfe:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003e00:	0001c517          	auipc	a0,0x1c
    80003e04:	e9850513          	addi	a0,a0,-360 # 8001fc98 <ftable>
    80003e08:	dedfc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e0c:	0001c497          	auipc	s1,0x1c
    80003e10:	ea448493          	addi	s1,s1,-348 # 8001fcb0 <ftable+0x18>
    80003e14:	0001d717          	auipc	a4,0x1d
    80003e18:	e3c70713          	addi	a4,a4,-452 # 80020c50 <log_lock>
    if(f->ref == 0){
    80003e1c:	40dc                	lw	a5,4(s1)
    80003e1e:	cf89                	beqz	a5,80003e38 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003e20:	02848493          	addi	s1,s1,40
    80003e24:	fee49ce3          	bne	s1,a4,80003e1c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003e28:	0001c517          	auipc	a0,0x1c
    80003e2c:	e7050513          	addi	a0,a0,-400 # 8001fc98 <ftable>
    80003e30:	e5dfc0ef          	jal	80000c8c <release>
  return 0;
    80003e34:	4481                	li	s1,0
    80003e36:	a809                	j	80003e48 <filealloc+0x52>
      f->ref = 1;
    80003e38:	4785                	li	a5,1
    80003e3a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003e3c:	0001c517          	auipc	a0,0x1c
    80003e40:	e5c50513          	addi	a0,a0,-420 # 8001fc98 <ftable>
    80003e44:	e49fc0ef          	jal	80000c8c <release>
}
    80003e48:	8526                	mv	a0,s1
    80003e4a:	60e2                	ld	ra,24(sp)
    80003e4c:	6442                	ld	s0,16(sp)
    80003e4e:	64a2                	ld	s1,8(sp)
    80003e50:	6105                	addi	sp,sp,32
    80003e52:	8082                	ret

0000000080003e54 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003e54:	1101                	addi	sp,sp,-32
    80003e56:	ec06                	sd	ra,24(sp)
    80003e58:	e822                	sd	s0,16(sp)
    80003e5a:	e426                	sd	s1,8(sp)
    80003e5c:	1000                	addi	s0,sp,32
    80003e5e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003e60:	0001c517          	auipc	a0,0x1c
    80003e64:	e3850513          	addi	a0,a0,-456 # 8001fc98 <ftable>
    80003e68:	d8dfc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003e6c:	40dc                	lw	a5,4(s1)
    80003e6e:	02f05063          	blez	a5,80003e8e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003e72:	2785                	addiw	a5,a5,1
    80003e74:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003e76:	0001c517          	auipc	a0,0x1c
    80003e7a:	e2250513          	addi	a0,a0,-478 # 8001fc98 <ftable>
    80003e7e:	e0ffc0ef          	jal	80000c8c <release>
  return f;
}
    80003e82:	8526                	mv	a0,s1
    80003e84:	60e2                	ld	ra,24(sp)
    80003e86:	6442                	ld	s0,16(sp)
    80003e88:	64a2                	ld	s1,8(sp)
    80003e8a:	6105                	addi	sp,sp,32
    80003e8c:	8082                	ret
    panic("filedup");
    80003e8e:	00004517          	auipc	a0,0x4
    80003e92:	83250513          	addi	a0,a0,-1998 # 800076c0 <etext+0x6c0>
    80003e96:	8fffc0ef          	jal	80000794 <panic>

0000000080003e9a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003e9a:	7139                	addi	sp,sp,-64
    80003e9c:	fc06                	sd	ra,56(sp)
    80003e9e:	f822                	sd	s0,48(sp)
    80003ea0:	f426                	sd	s1,40(sp)
    80003ea2:	0080                	addi	s0,sp,64
    80003ea4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ea6:	0001c517          	auipc	a0,0x1c
    80003eaa:	df250513          	addi	a0,a0,-526 # 8001fc98 <ftable>
    80003eae:	d47fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003eb2:	40dc                	lw	a5,4(s1)
    80003eb4:	04f05a63          	blez	a5,80003f08 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003eb8:	37fd                	addiw	a5,a5,-1
    80003eba:	0007871b          	sext.w	a4,a5
    80003ebe:	c0dc                	sw	a5,4(s1)
    80003ec0:	04e04e63          	bgtz	a4,80003f1c <fileclose+0x82>
    80003ec4:	f04a                	sd	s2,32(sp)
    80003ec6:	ec4e                	sd	s3,24(sp)
    80003ec8:	e852                	sd	s4,16(sp)
    80003eca:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ecc:	0004a903          	lw	s2,0(s1)
    80003ed0:	0094ca83          	lbu	s5,9(s1)
    80003ed4:	0104ba03          	ld	s4,16(s1)
    80003ed8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003edc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ee0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ee4:	0001c517          	auipc	a0,0x1c
    80003ee8:	db450513          	addi	a0,a0,-588 # 8001fc98 <ftable>
    80003eec:	da1fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80003ef0:	4785                	li	a5,1
    80003ef2:	04f90063          	beq	s2,a5,80003f32 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ef6:	3979                	addiw	s2,s2,-2
    80003ef8:	4785                	li	a5,1
    80003efa:	0527f563          	bgeu	a5,s2,80003f44 <fileclose+0xaa>
    80003efe:	7902                	ld	s2,32(sp)
    80003f00:	69e2                	ld	s3,24(sp)
    80003f02:	6a42                	ld	s4,16(sp)
    80003f04:	6aa2                	ld	s5,8(sp)
    80003f06:	a00d                	j	80003f28 <fileclose+0x8e>
    80003f08:	f04a                	sd	s2,32(sp)
    80003f0a:	ec4e                	sd	s3,24(sp)
    80003f0c:	e852                	sd	s4,16(sp)
    80003f0e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003f10:	00003517          	auipc	a0,0x3
    80003f14:	7b850513          	addi	a0,a0,1976 # 800076c8 <etext+0x6c8>
    80003f18:	87dfc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80003f1c:	0001c517          	auipc	a0,0x1c
    80003f20:	d7c50513          	addi	a0,a0,-644 # 8001fc98 <ftable>
    80003f24:	d69fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003f28:	70e2                	ld	ra,56(sp)
    80003f2a:	7442                	ld	s0,48(sp)
    80003f2c:	74a2                	ld	s1,40(sp)
    80003f2e:	6121                	addi	sp,sp,64
    80003f30:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003f32:	85d6                	mv	a1,s5
    80003f34:	8552                	mv	a0,s4
    80003f36:	336000ef          	jal	8000426c <pipeclose>
    80003f3a:	7902                	ld	s2,32(sp)
    80003f3c:	69e2                	ld	s3,24(sp)
    80003f3e:	6a42                	ld	s4,16(sp)
    80003f40:	6aa2                	ld	s5,8(sp)
    80003f42:	b7dd                	j	80003f28 <fileclose+0x8e>
    begin_op();
    80003f44:	b3dff0ef          	jal	80003a80 <begin_op>
    iput(ff.ip);
    80003f48:	854e                	mv	a0,s3
    80003f4a:	c22ff0ef          	jal	8000336c <iput>
    end_op();
    80003f4e:	b9dff0ef          	jal	80003aea <end_op>
    80003f52:	7902                	ld	s2,32(sp)
    80003f54:	69e2                	ld	s3,24(sp)
    80003f56:	6a42                	ld	s4,16(sp)
    80003f58:	6aa2                	ld	s5,8(sp)
    80003f5a:	b7f9                	j	80003f28 <fileclose+0x8e>

0000000080003f5c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003f5c:	715d                	addi	sp,sp,-80
    80003f5e:	e486                	sd	ra,72(sp)
    80003f60:	e0a2                	sd	s0,64(sp)
    80003f62:	fc26                	sd	s1,56(sp)
    80003f64:	f44e                	sd	s3,40(sp)
    80003f66:	0880                	addi	s0,sp,80
    80003f68:	84aa                	mv	s1,a0
    80003f6a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003f6c:	99ffd0ef          	jal	8000190a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003f70:	409c                	lw	a5,0(s1)
    80003f72:	37f9                	addiw	a5,a5,-2
    80003f74:	4705                	li	a4,1
    80003f76:	04f76063          	bltu	a4,a5,80003fb6 <filestat+0x5a>
    80003f7a:	f84a                	sd	s2,48(sp)
    80003f7c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003f7e:	6c88                	ld	a0,24(s1)
    80003f80:	a6aff0ef          	jal	800031ea <ilock>
    stati(f->ip, &st);
    80003f84:	fb840593          	addi	a1,s0,-72
    80003f88:	6c88                	ld	a0,24(s1)
    80003f8a:	c8aff0ef          	jal	80003414 <stati>
    iunlock(f->ip);
    80003f8e:	6c88                	ld	a0,24(s1)
    80003f90:	b08ff0ef          	jal	80003298 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003f94:	46e1                	li	a3,24
    80003f96:	fb840613          	addi	a2,s0,-72
    80003f9a:	85ce                	mv	a1,s3
    80003f9c:	05093503          	ld	a0,80(s2)
    80003fa0:	ddcfd0ef          	jal	8000157c <copyout>
    80003fa4:	41f5551b          	sraiw	a0,a0,0x1f
    80003fa8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003faa:	60a6                	ld	ra,72(sp)
    80003fac:	6406                	ld	s0,64(sp)
    80003fae:	74e2                	ld	s1,56(sp)
    80003fb0:	79a2                	ld	s3,40(sp)
    80003fb2:	6161                	addi	sp,sp,80
    80003fb4:	8082                	ret
  return -1;
    80003fb6:	557d                	li	a0,-1
    80003fb8:	bfcd                	j	80003faa <filestat+0x4e>

0000000080003fba <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003fba:	7179                	addi	sp,sp,-48
    80003fbc:	f406                	sd	ra,40(sp)
    80003fbe:	f022                	sd	s0,32(sp)
    80003fc0:	e84a                	sd	s2,16(sp)
    80003fc2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003fc4:	00854783          	lbu	a5,8(a0)
    80003fc8:	cfd1                	beqz	a5,80004064 <fileread+0xaa>
    80003fca:	ec26                	sd	s1,24(sp)
    80003fcc:	e44e                	sd	s3,8(sp)
    80003fce:	84aa                	mv	s1,a0
    80003fd0:	89ae                	mv	s3,a1
    80003fd2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003fd4:	411c                	lw	a5,0(a0)
    80003fd6:	4705                	li	a4,1
    80003fd8:	04e78363          	beq	a5,a4,8000401e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003fdc:	470d                	li	a4,3
    80003fde:	04e78763          	beq	a5,a4,8000402c <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fe2:	4709                	li	a4,2
    80003fe4:	06e79a63          	bne	a5,a4,80004058 <fileread+0x9e>
    ilock(f->ip);
    80003fe8:	6d08                	ld	a0,24(a0)
    80003fea:	a00ff0ef          	jal	800031ea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003fee:	874a                	mv	a4,s2
    80003ff0:	5094                	lw	a3,32(s1)
    80003ff2:	864e                	mv	a2,s3
    80003ff4:	4585                	li	a1,1
    80003ff6:	6c88                	ld	a0,24(s1)
    80003ff8:	c46ff0ef          	jal	8000343e <readi>
    80003ffc:	892a                	mv	s2,a0
    80003ffe:	00a05563          	blez	a0,80004008 <fileread+0x4e>
      f->off += r;
    80004002:	509c                	lw	a5,32(s1)
    80004004:	9fa9                	addw	a5,a5,a0
    80004006:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004008:	6c88                	ld	a0,24(s1)
    8000400a:	a8eff0ef          	jal	80003298 <iunlock>
    8000400e:	64e2                	ld	s1,24(sp)
    80004010:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004012:	854a                	mv	a0,s2
    80004014:	70a2                	ld	ra,40(sp)
    80004016:	7402                	ld	s0,32(sp)
    80004018:	6942                	ld	s2,16(sp)
    8000401a:	6145                	addi	sp,sp,48
    8000401c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000401e:	6908                	ld	a0,16(a0)
    80004020:	388000ef          	jal	800043a8 <piperead>
    80004024:	892a                	mv	s2,a0
    80004026:	64e2                	ld	s1,24(sp)
    80004028:	69a2                	ld	s3,8(sp)
    8000402a:	b7e5                	j	80004012 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000402c:	02451783          	lh	a5,36(a0)
    80004030:	03079693          	slli	a3,a5,0x30
    80004034:	92c1                	srli	a3,a3,0x30
    80004036:	4725                	li	a4,9
    80004038:	02d76863          	bltu	a4,a3,80004068 <fileread+0xae>
    8000403c:	0792                	slli	a5,a5,0x4
    8000403e:	0001c717          	auipc	a4,0x1c
    80004042:	bba70713          	addi	a4,a4,-1094 # 8001fbf8 <devsw>
    80004046:	97ba                	add	a5,a5,a4
    80004048:	639c                	ld	a5,0(a5)
    8000404a:	c39d                	beqz	a5,80004070 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000404c:	4505                	li	a0,1
    8000404e:	9782                	jalr	a5
    80004050:	892a                	mv	s2,a0
    80004052:	64e2                	ld	s1,24(sp)
    80004054:	69a2                	ld	s3,8(sp)
    80004056:	bf75                	j	80004012 <fileread+0x58>
    panic("fileread");
    80004058:	00003517          	auipc	a0,0x3
    8000405c:	68050513          	addi	a0,a0,1664 # 800076d8 <etext+0x6d8>
    80004060:	f34fc0ef          	jal	80000794 <panic>
    return -1;
    80004064:	597d                	li	s2,-1
    80004066:	b775                	j	80004012 <fileread+0x58>
      return -1;
    80004068:	597d                	li	s2,-1
    8000406a:	64e2                	ld	s1,24(sp)
    8000406c:	69a2                	ld	s3,8(sp)
    8000406e:	b755                	j	80004012 <fileread+0x58>
    80004070:	597d                	li	s2,-1
    80004072:	64e2                	ld	s1,24(sp)
    80004074:	69a2                	ld	s3,8(sp)
    80004076:	bf71                	j	80004012 <fileread+0x58>

0000000080004078 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004078:	00954783          	lbu	a5,9(a0)
    8000407c:	10078b63          	beqz	a5,80004192 <filewrite+0x11a>
{
    80004080:	715d                	addi	sp,sp,-80
    80004082:	e486                	sd	ra,72(sp)
    80004084:	e0a2                	sd	s0,64(sp)
    80004086:	f84a                	sd	s2,48(sp)
    80004088:	f052                	sd	s4,32(sp)
    8000408a:	e85a                	sd	s6,16(sp)
    8000408c:	0880                	addi	s0,sp,80
    8000408e:	892a                	mv	s2,a0
    80004090:	8b2e                	mv	s6,a1
    80004092:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004094:	411c                	lw	a5,0(a0)
    80004096:	4705                	li	a4,1
    80004098:	02e78763          	beq	a5,a4,800040c6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000409c:	470d                	li	a4,3
    8000409e:	02e78863          	beq	a5,a4,800040ce <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800040a2:	4709                	li	a4,2
    800040a4:	0ce79c63          	bne	a5,a4,8000417c <filewrite+0x104>
    800040a8:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800040aa:	0ac05863          	blez	a2,8000415a <filewrite+0xe2>
    800040ae:	fc26                	sd	s1,56(sp)
    800040b0:	ec56                	sd	s5,24(sp)
    800040b2:	e45e                	sd	s7,8(sp)
    800040b4:	e062                	sd	s8,0(sp)
    int i = 0;
    800040b6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800040b8:	6b85                	lui	s7,0x1
    800040ba:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800040be:	6c05                	lui	s8,0x1
    800040c0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800040c4:	a8b5                	j	80004140 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800040c6:	6908                	ld	a0,16(a0)
    800040c8:	1fc000ef          	jal	800042c4 <pipewrite>
    800040cc:	a04d                	j	8000416e <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800040ce:	02451783          	lh	a5,36(a0)
    800040d2:	03079693          	slli	a3,a5,0x30
    800040d6:	92c1                	srli	a3,a3,0x30
    800040d8:	4725                	li	a4,9
    800040da:	0ad76e63          	bltu	a4,a3,80004196 <filewrite+0x11e>
    800040de:	0792                	slli	a5,a5,0x4
    800040e0:	0001c717          	auipc	a4,0x1c
    800040e4:	b1870713          	addi	a4,a4,-1256 # 8001fbf8 <devsw>
    800040e8:	97ba                	add	a5,a5,a4
    800040ea:	679c                	ld	a5,8(a5)
    800040ec:	c7dd                	beqz	a5,8000419a <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800040ee:	4505                	li	a0,1
    800040f0:	9782                	jalr	a5
    800040f2:	a8b5                	j	8000416e <filewrite+0xf6>
      if(n1 > max)
    800040f4:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800040f8:	989ff0ef          	jal	80003a80 <begin_op>
      ilock(f->ip);
    800040fc:	01893503          	ld	a0,24(s2)
    80004100:	8eaff0ef          	jal	800031ea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004104:	8756                	mv	a4,s5
    80004106:	02092683          	lw	a3,32(s2)
    8000410a:	01698633          	add	a2,s3,s6
    8000410e:	4585                	li	a1,1
    80004110:	01893503          	ld	a0,24(s2)
    80004114:	c26ff0ef          	jal	8000353a <writei>
    80004118:	84aa                	mv	s1,a0
    8000411a:	00a05763          	blez	a0,80004128 <filewrite+0xb0>
        f->off += r;
    8000411e:	02092783          	lw	a5,32(s2)
    80004122:	9fa9                	addw	a5,a5,a0
    80004124:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004128:	01893503          	ld	a0,24(s2)
    8000412c:	96cff0ef          	jal	80003298 <iunlock>
      end_op();
    80004130:	9bbff0ef          	jal	80003aea <end_op>

      if(r != n1){
    80004134:	029a9563          	bne	s5,s1,8000415e <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004138:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000413c:	0149da63          	bge	s3,s4,80004150 <filewrite+0xd8>
      int n1 = n - i;
    80004140:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004144:	0004879b          	sext.w	a5,s1
    80004148:	fafbd6e3          	bge	s7,a5,800040f4 <filewrite+0x7c>
    8000414c:	84e2                	mv	s1,s8
    8000414e:	b75d                	j	800040f4 <filewrite+0x7c>
    80004150:	74e2                	ld	s1,56(sp)
    80004152:	6ae2                	ld	s5,24(sp)
    80004154:	6ba2                	ld	s7,8(sp)
    80004156:	6c02                	ld	s8,0(sp)
    80004158:	a039                	j	80004166 <filewrite+0xee>
    int i = 0;
    8000415a:	4981                	li	s3,0
    8000415c:	a029                	j	80004166 <filewrite+0xee>
    8000415e:	74e2                	ld	s1,56(sp)
    80004160:	6ae2                	ld	s5,24(sp)
    80004162:	6ba2                	ld	s7,8(sp)
    80004164:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004166:	033a1c63          	bne	s4,s3,8000419e <filewrite+0x126>
    8000416a:	8552                	mv	a0,s4
    8000416c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000416e:	60a6                	ld	ra,72(sp)
    80004170:	6406                	ld	s0,64(sp)
    80004172:	7942                	ld	s2,48(sp)
    80004174:	7a02                	ld	s4,32(sp)
    80004176:	6b42                	ld	s6,16(sp)
    80004178:	6161                	addi	sp,sp,80
    8000417a:	8082                	ret
    8000417c:	fc26                	sd	s1,56(sp)
    8000417e:	f44e                	sd	s3,40(sp)
    80004180:	ec56                	sd	s5,24(sp)
    80004182:	e45e                	sd	s7,8(sp)
    80004184:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004186:	00003517          	auipc	a0,0x3
    8000418a:	56250513          	addi	a0,a0,1378 # 800076e8 <etext+0x6e8>
    8000418e:	e06fc0ef          	jal	80000794 <panic>
    return -1;
    80004192:	557d                	li	a0,-1
}
    80004194:	8082                	ret
      return -1;
    80004196:	557d                	li	a0,-1
    80004198:	bfd9                	j	8000416e <filewrite+0xf6>
    8000419a:	557d                	li	a0,-1
    8000419c:	bfc9                	j	8000416e <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000419e:	557d                	li	a0,-1
    800041a0:	79a2                	ld	s3,40(sp)
    800041a2:	b7f1                	j	8000416e <filewrite+0xf6>

00000000800041a4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800041a4:	7179                	addi	sp,sp,-48
    800041a6:	f406                	sd	ra,40(sp)
    800041a8:	f022                	sd	s0,32(sp)
    800041aa:	ec26                	sd	s1,24(sp)
    800041ac:	e052                	sd	s4,0(sp)
    800041ae:	1800                	addi	s0,sp,48
    800041b0:	84aa                	mv	s1,a0
    800041b2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800041b4:	0005b023          	sd	zero,0(a1)
    800041b8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800041bc:	c3bff0ef          	jal	80003df6 <filealloc>
    800041c0:	e088                	sd	a0,0(s1)
    800041c2:	c549                	beqz	a0,8000424c <pipealloc+0xa8>
    800041c4:	c33ff0ef          	jal	80003df6 <filealloc>
    800041c8:	00aa3023          	sd	a0,0(s4)
    800041cc:	cd25                	beqz	a0,80004244 <pipealloc+0xa0>
    800041ce:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800041d0:	955fc0ef          	jal	80000b24 <kalloc>
    800041d4:	892a                	mv	s2,a0
    800041d6:	c12d                	beqz	a0,80004238 <pipealloc+0x94>
    800041d8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800041da:	4985                	li	s3,1
    800041dc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800041e0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800041e4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800041e8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800041ec:	00003597          	auipc	a1,0x3
    800041f0:	50c58593          	addi	a1,a1,1292 # 800076f8 <etext+0x6f8>
    800041f4:	981fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    800041f8:	609c                	ld	a5,0(s1)
    800041fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800041fe:	609c                	ld	a5,0(s1)
    80004200:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004204:	609c                	ld	a5,0(s1)
    80004206:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000420a:	609c                	ld	a5,0(s1)
    8000420c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004210:	000a3783          	ld	a5,0(s4)
    80004214:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004218:	000a3783          	ld	a5,0(s4)
    8000421c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004220:	000a3783          	ld	a5,0(s4)
    80004224:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004228:	000a3783          	ld	a5,0(s4)
    8000422c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004230:	4501                	li	a0,0
    80004232:	6942                	ld	s2,16(sp)
    80004234:	69a2                	ld	s3,8(sp)
    80004236:	a01d                	j	8000425c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004238:	6088                	ld	a0,0(s1)
    8000423a:	c119                	beqz	a0,80004240 <pipealloc+0x9c>
    8000423c:	6942                	ld	s2,16(sp)
    8000423e:	a029                	j	80004248 <pipealloc+0xa4>
    80004240:	6942                	ld	s2,16(sp)
    80004242:	a029                	j	8000424c <pipealloc+0xa8>
    80004244:	6088                	ld	a0,0(s1)
    80004246:	c10d                	beqz	a0,80004268 <pipealloc+0xc4>
    fileclose(*f0);
    80004248:	c53ff0ef          	jal	80003e9a <fileclose>
  if(*f1)
    8000424c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004250:	557d                	li	a0,-1
  if(*f1)
    80004252:	c789                	beqz	a5,8000425c <pipealloc+0xb8>
    fileclose(*f1);
    80004254:	853e                	mv	a0,a5
    80004256:	c45ff0ef          	jal	80003e9a <fileclose>
  return -1;
    8000425a:	557d                	li	a0,-1
}
    8000425c:	70a2                	ld	ra,40(sp)
    8000425e:	7402                	ld	s0,32(sp)
    80004260:	64e2                	ld	s1,24(sp)
    80004262:	6a02                	ld	s4,0(sp)
    80004264:	6145                	addi	sp,sp,48
    80004266:	8082                	ret
  return -1;
    80004268:	557d                	li	a0,-1
    8000426a:	bfcd                	j	8000425c <pipealloc+0xb8>

000000008000426c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000426c:	1101                	addi	sp,sp,-32
    8000426e:	ec06                	sd	ra,24(sp)
    80004270:	e822                	sd	s0,16(sp)
    80004272:	e426                	sd	s1,8(sp)
    80004274:	e04a                	sd	s2,0(sp)
    80004276:	1000                	addi	s0,sp,32
    80004278:	84aa                	mv	s1,a0
    8000427a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000427c:	979fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    80004280:	02090763          	beqz	s2,800042ae <pipeclose+0x42>
    pi->writeopen = 0;
    80004284:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004288:	21848513          	addi	a0,s1,536
    8000428c:	c99fd0ef          	jal	80001f24 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004290:	2204b783          	ld	a5,544(s1)
    80004294:	e785                	bnez	a5,800042bc <pipeclose+0x50>
    release(&pi->lock);
    80004296:	8526                	mv	a0,s1
    80004298:	9f5fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    8000429c:	8526                	mv	a0,s1
    8000429e:	fa4fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800042a2:	60e2                	ld	ra,24(sp)
    800042a4:	6442                	ld	s0,16(sp)
    800042a6:	64a2                	ld	s1,8(sp)
    800042a8:	6902                	ld	s2,0(sp)
    800042aa:	6105                	addi	sp,sp,32
    800042ac:	8082                	ret
    pi->readopen = 0;
    800042ae:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800042b2:	21c48513          	addi	a0,s1,540
    800042b6:	c6ffd0ef          	jal	80001f24 <wakeup>
    800042ba:	bfd9                	j	80004290 <pipeclose+0x24>
    release(&pi->lock);
    800042bc:	8526                	mv	a0,s1
    800042be:	9cffc0ef          	jal	80000c8c <release>
}
    800042c2:	b7c5                	j	800042a2 <pipeclose+0x36>

00000000800042c4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800042c4:	711d                	addi	sp,sp,-96
    800042c6:	ec86                	sd	ra,88(sp)
    800042c8:	e8a2                	sd	s0,80(sp)
    800042ca:	e4a6                	sd	s1,72(sp)
    800042cc:	e0ca                	sd	s2,64(sp)
    800042ce:	fc4e                	sd	s3,56(sp)
    800042d0:	f852                	sd	s4,48(sp)
    800042d2:	f456                	sd	s5,40(sp)
    800042d4:	1080                	addi	s0,sp,96
    800042d6:	84aa                	mv	s1,a0
    800042d8:	8aae                	mv	s5,a1
    800042da:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800042dc:	e2efd0ef          	jal	8000190a <myproc>
    800042e0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800042e2:	8526                	mv	a0,s1
    800042e4:	911fc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    800042e8:	0b405a63          	blez	s4,8000439c <pipewrite+0xd8>
    800042ec:	f05a                	sd	s6,32(sp)
    800042ee:	ec5e                	sd	s7,24(sp)
    800042f0:	e862                	sd	s8,16(sp)
  int i = 0;
    800042f2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042f4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800042f6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800042fa:	21c48b93          	addi	s7,s1,540
    800042fe:	a81d                	j	80004334 <pipewrite+0x70>
      release(&pi->lock);
    80004300:	8526                	mv	a0,s1
    80004302:	98bfc0ef          	jal	80000c8c <release>
      return -1;
    80004306:	597d                	li	s2,-1
    80004308:	7b02                	ld	s6,32(sp)
    8000430a:	6be2                	ld	s7,24(sp)
    8000430c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000430e:	854a                	mv	a0,s2
    80004310:	60e6                	ld	ra,88(sp)
    80004312:	6446                	ld	s0,80(sp)
    80004314:	64a6                	ld	s1,72(sp)
    80004316:	6906                	ld	s2,64(sp)
    80004318:	79e2                	ld	s3,56(sp)
    8000431a:	7a42                	ld	s4,48(sp)
    8000431c:	7aa2                	ld	s5,40(sp)
    8000431e:	6125                	addi	sp,sp,96
    80004320:	8082                	ret
      wakeup(&pi->nread);
    80004322:	8562                	mv	a0,s8
    80004324:	c01fd0ef          	jal	80001f24 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004328:	85a6                	mv	a1,s1
    8000432a:	855e                	mv	a0,s7
    8000432c:	badfd0ef          	jal	80001ed8 <sleep>
  while(i < n){
    80004330:	05495b63          	bge	s2,s4,80004386 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004334:	2204a783          	lw	a5,544(s1)
    80004338:	d7e1                	beqz	a5,80004300 <pipewrite+0x3c>
    8000433a:	854e                	mv	a0,s3
    8000433c:	dd5fd0ef          	jal	80002110 <killed>
    80004340:	f161                	bnez	a0,80004300 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004342:	2184a783          	lw	a5,536(s1)
    80004346:	21c4a703          	lw	a4,540(s1)
    8000434a:	2007879b          	addiw	a5,a5,512
    8000434e:	fcf70ae3          	beq	a4,a5,80004322 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004352:	4685                	li	a3,1
    80004354:	01590633          	add	a2,s2,s5
    80004358:	faf40593          	addi	a1,s0,-81
    8000435c:	0509b503          	ld	a0,80(s3)
    80004360:	af2fd0ef          	jal	80001652 <copyin>
    80004364:	03650e63          	beq	a0,s6,800043a0 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004368:	21c4a783          	lw	a5,540(s1)
    8000436c:	0017871b          	addiw	a4,a5,1
    80004370:	20e4ae23          	sw	a4,540(s1)
    80004374:	1ff7f793          	andi	a5,a5,511
    80004378:	97a6                	add	a5,a5,s1
    8000437a:	faf44703          	lbu	a4,-81(s0)
    8000437e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004382:	2905                	addiw	s2,s2,1
    80004384:	b775                	j	80004330 <pipewrite+0x6c>
    80004386:	7b02                	ld	s6,32(sp)
    80004388:	6be2                	ld	s7,24(sp)
    8000438a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000438c:	21848513          	addi	a0,s1,536
    80004390:	b95fd0ef          	jal	80001f24 <wakeup>
  release(&pi->lock);
    80004394:	8526                	mv	a0,s1
    80004396:	8f7fc0ef          	jal	80000c8c <release>
  return i;
    8000439a:	bf95                	j	8000430e <pipewrite+0x4a>
  int i = 0;
    8000439c:	4901                	li	s2,0
    8000439e:	b7fd                	j	8000438c <pipewrite+0xc8>
    800043a0:	7b02                	ld	s6,32(sp)
    800043a2:	6be2                	ld	s7,24(sp)
    800043a4:	6c42                	ld	s8,16(sp)
    800043a6:	b7dd                	j	8000438c <pipewrite+0xc8>

00000000800043a8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800043a8:	715d                	addi	sp,sp,-80
    800043aa:	e486                	sd	ra,72(sp)
    800043ac:	e0a2                	sd	s0,64(sp)
    800043ae:	fc26                	sd	s1,56(sp)
    800043b0:	f84a                	sd	s2,48(sp)
    800043b2:	f44e                	sd	s3,40(sp)
    800043b4:	f052                	sd	s4,32(sp)
    800043b6:	ec56                	sd	s5,24(sp)
    800043b8:	0880                	addi	s0,sp,80
    800043ba:	84aa                	mv	s1,a0
    800043bc:	892e                	mv	s2,a1
    800043be:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800043c0:	d4afd0ef          	jal	8000190a <myproc>
    800043c4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800043c6:	8526                	mv	a0,s1
    800043c8:	82dfc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043cc:	2184a703          	lw	a4,536(s1)
    800043d0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043d4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043d8:	02f71563          	bne	a4,a5,80004402 <piperead+0x5a>
    800043dc:	2244a783          	lw	a5,548(s1)
    800043e0:	cb85                	beqz	a5,80004410 <piperead+0x68>
    if(killed(pr)){
    800043e2:	8552                	mv	a0,s4
    800043e4:	d2dfd0ef          	jal	80002110 <killed>
    800043e8:	ed19                	bnez	a0,80004406 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800043ea:	85a6                	mv	a1,s1
    800043ec:	854e                	mv	a0,s3
    800043ee:	aebfd0ef          	jal	80001ed8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043f2:	2184a703          	lw	a4,536(s1)
    800043f6:	21c4a783          	lw	a5,540(s1)
    800043fa:	fef701e3          	beq	a4,a5,800043dc <piperead+0x34>
    800043fe:	e85a                	sd	s6,16(sp)
    80004400:	a809                	j	80004412 <piperead+0x6a>
    80004402:	e85a                	sd	s6,16(sp)
    80004404:	a039                	j	80004412 <piperead+0x6a>
      release(&pi->lock);
    80004406:	8526                	mv	a0,s1
    80004408:	885fc0ef          	jal	80000c8c <release>
      return -1;
    8000440c:	59fd                	li	s3,-1
    8000440e:	a8b1                	j	8000446a <piperead+0xc2>
    80004410:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004412:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004414:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004416:	05505263          	blez	s5,8000445a <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000441a:	2184a783          	lw	a5,536(s1)
    8000441e:	21c4a703          	lw	a4,540(s1)
    80004422:	02f70c63          	beq	a4,a5,8000445a <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004426:	0017871b          	addiw	a4,a5,1
    8000442a:	20e4ac23          	sw	a4,536(s1)
    8000442e:	1ff7f793          	andi	a5,a5,511
    80004432:	97a6                	add	a5,a5,s1
    80004434:	0187c783          	lbu	a5,24(a5)
    80004438:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000443c:	4685                	li	a3,1
    8000443e:	fbf40613          	addi	a2,s0,-65
    80004442:	85ca                	mv	a1,s2
    80004444:	050a3503          	ld	a0,80(s4)
    80004448:	934fd0ef          	jal	8000157c <copyout>
    8000444c:	01650763          	beq	a0,s6,8000445a <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004450:	2985                	addiw	s3,s3,1
    80004452:	0905                	addi	s2,s2,1
    80004454:	fd3a93e3          	bne	s5,s3,8000441a <piperead+0x72>
    80004458:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000445a:	21c48513          	addi	a0,s1,540
    8000445e:	ac7fd0ef          	jal	80001f24 <wakeup>
  release(&pi->lock);
    80004462:	8526                	mv	a0,s1
    80004464:	829fc0ef          	jal	80000c8c <release>
    80004468:	6b42                	ld	s6,16(sp)
  return i;
}
    8000446a:	854e                	mv	a0,s3
    8000446c:	60a6                	ld	ra,72(sp)
    8000446e:	6406                	ld	s0,64(sp)
    80004470:	74e2                	ld	s1,56(sp)
    80004472:	7942                	ld	s2,48(sp)
    80004474:	79a2                	ld	s3,40(sp)
    80004476:	7a02                	ld	s4,32(sp)
    80004478:	6ae2                	ld	s5,24(sp)
    8000447a:	6161                	addi	sp,sp,80
    8000447c:	8082                	ret

000000008000447e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000447e:	1141                	addi	sp,sp,-16
    80004480:	e422                	sd	s0,8(sp)
    80004482:	0800                	addi	s0,sp,16
    80004484:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004486:	8905                	andi	a0,a0,1
    80004488:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000448a:	8b89                	andi	a5,a5,2
    8000448c:	c399                	beqz	a5,80004492 <flags2perm+0x14>
      perm |= PTE_W;
    8000448e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004492:	6422                	ld	s0,8(sp)
    80004494:	0141                	addi	sp,sp,16
    80004496:	8082                	ret

0000000080004498 <exec>:

int
exec(char *path, char **argv)
{
    80004498:	df010113          	addi	sp,sp,-528
    8000449c:	20113423          	sd	ra,520(sp)
    800044a0:	20813023          	sd	s0,512(sp)
    800044a4:	ffa6                	sd	s1,504(sp)
    800044a6:	fbca                	sd	s2,496(sp)
    800044a8:	0c00                	addi	s0,sp,528
    800044aa:	892a                	mv	s2,a0
    800044ac:	dea43c23          	sd	a0,-520(s0)
    800044b0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800044b4:	c56fd0ef          	jal	8000190a <myproc>
    800044b8:	84aa                	mv	s1,a0

  begin_op();
    800044ba:	dc6ff0ef          	jal	80003a80 <begin_op>

  if((ip = namei(path)) == 0){
    800044be:	854a                	mv	a0,s2
    800044c0:	c04ff0ef          	jal	800038c4 <namei>
    800044c4:	c931                	beqz	a0,80004518 <exec+0x80>
    800044c6:	f3d2                	sd	s4,480(sp)
    800044c8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800044ca:	d21fe0ef          	jal	800031ea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800044ce:	04000713          	li	a4,64
    800044d2:	4681                	li	a3,0
    800044d4:	e5040613          	addi	a2,s0,-432
    800044d8:	4581                	li	a1,0
    800044da:	8552                	mv	a0,s4
    800044dc:	f63fe0ef          	jal	8000343e <readi>
    800044e0:	04000793          	li	a5,64
    800044e4:	00f51a63          	bne	a0,a5,800044f8 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800044e8:	e5042703          	lw	a4,-432(s0)
    800044ec:	464c47b7          	lui	a5,0x464c4
    800044f0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800044f4:	02f70663          	beq	a4,a5,80004520 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800044f8:	8552                	mv	a0,s4
    800044fa:	efbfe0ef          	jal	800033f4 <iunlockput>
    end_op();
    800044fe:	decff0ef          	jal	80003aea <end_op>
  }
  return -1;
    80004502:	557d                	li	a0,-1
    80004504:	7a1e                	ld	s4,480(sp)
}
    80004506:	20813083          	ld	ra,520(sp)
    8000450a:	20013403          	ld	s0,512(sp)
    8000450e:	74fe                	ld	s1,504(sp)
    80004510:	795e                	ld	s2,496(sp)
    80004512:	21010113          	addi	sp,sp,528
    80004516:	8082                	ret
    end_op();
    80004518:	dd2ff0ef          	jal	80003aea <end_op>
    return -1;
    8000451c:	557d                	li	a0,-1
    8000451e:	b7e5                	j	80004506 <exec+0x6e>
    80004520:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004522:	8526                	mv	a0,s1
    80004524:	c8efd0ef          	jal	800019b2 <proc_pagetable>
    80004528:	8b2a                	mv	s6,a0
    8000452a:	2c050b63          	beqz	a0,80004800 <exec+0x368>
    8000452e:	f7ce                	sd	s3,488(sp)
    80004530:	efd6                	sd	s5,472(sp)
    80004532:	e7de                	sd	s7,456(sp)
    80004534:	e3e2                	sd	s8,448(sp)
    80004536:	ff66                	sd	s9,440(sp)
    80004538:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000453a:	e7042d03          	lw	s10,-400(s0)
    8000453e:	e8845783          	lhu	a5,-376(s0)
    80004542:	12078963          	beqz	a5,80004674 <exec+0x1dc>
    80004546:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004548:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000454a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000454c:	6c85                	lui	s9,0x1
    8000454e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004552:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004556:	6a85                	lui	s5,0x1
    80004558:	a085                	j	800045b8 <exec+0x120>
      panic("loadseg: address should exist");
    8000455a:	00003517          	auipc	a0,0x3
    8000455e:	1a650513          	addi	a0,a0,422 # 80007700 <etext+0x700>
    80004562:	a32fc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004566:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004568:	8726                	mv	a4,s1
    8000456a:	012c06bb          	addw	a3,s8,s2
    8000456e:	4581                	li	a1,0
    80004570:	8552                	mv	a0,s4
    80004572:	ecdfe0ef          	jal	8000343e <readi>
    80004576:	2501                	sext.w	a0,a0
    80004578:	24a49a63          	bne	s1,a0,800047cc <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    8000457c:	012a893b          	addw	s2,s5,s2
    80004580:	03397363          	bgeu	s2,s3,800045a6 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004584:	02091593          	slli	a1,s2,0x20
    80004588:	9181                	srli	a1,a1,0x20
    8000458a:	95de                	add	a1,a1,s7
    8000458c:	855a                	mv	a0,s6
    8000458e:	a73fc0ef          	jal	80001000 <walkaddr>
    80004592:	862a                	mv	a2,a0
    if(pa == 0)
    80004594:	d179                	beqz	a0,8000455a <exec+0xc2>
    if(sz - i < PGSIZE)
    80004596:	412984bb          	subw	s1,s3,s2
    8000459a:	0004879b          	sext.w	a5,s1
    8000459e:	fcfcf4e3          	bgeu	s9,a5,80004566 <exec+0xce>
    800045a2:	84d6                	mv	s1,s5
    800045a4:	b7c9                	j	80004566 <exec+0xce>
    sz = sz1;
    800045a6:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045aa:	2d85                	addiw	s11,s11,1
    800045ac:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800045b0:	e8845783          	lhu	a5,-376(s0)
    800045b4:	08fdd063          	bge	s11,a5,80004634 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045b8:	2d01                	sext.w	s10,s10
    800045ba:	03800713          	li	a4,56
    800045be:	86ea                	mv	a3,s10
    800045c0:	e1840613          	addi	a2,s0,-488
    800045c4:	4581                	li	a1,0
    800045c6:	8552                	mv	a0,s4
    800045c8:	e77fe0ef          	jal	8000343e <readi>
    800045cc:	03800793          	li	a5,56
    800045d0:	1cf51663          	bne	a0,a5,8000479c <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    800045d4:	e1842783          	lw	a5,-488(s0)
    800045d8:	4705                	li	a4,1
    800045da:	fce798e3          	bne	a5,a4,800045aa <exec+0x112>
    if(ph.memsz < ph.filesz)
    800045de:	e4043483          	ld	s1,-448(s0)
    800045e2:	e3843783          	ld	a5,-456(s0)
    800045e6:	1af4ef63          	bltu	s1,a5,800047a4 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045ea:	e2843783          	ld	a5,-472(s0)
    800045ee:	94be                	add	s1,s1,a5
    800045f0:	1af4ee63          	bltu	s1,a5,800047ac <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800045f4:	df043703          	ld	a4,-528(s0)
    800045f8:	8ff9                	and	a5,a5,a4
    800045fa:	1a079d63          	bnez	a5,800047b4 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045fe:	e1c42503          	lw	a0,-484(s0)
    80004602:	e7dff0ef          	jal	8000447e <flags2perm>
    80004606:	86aa                	mv	a3,a0
    80004608:	8626                	mv	a2,s1
    8000460a:	85ca                	mv	a1,s2
    8000460c:	855a                	mv	a0,s6
    8000460e:	d5bfc0ef          	jal	80001368 <uvmalloc>
    80004612:	e0a43423          	sd	a0,-504(s0)
    80004616:	1a050363          	beqz	a0,800047bc <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000461a:	e2843b83          	ld	s7,-472(s0)
    8000461e:	e2042c03          	lw	s8,-480(s0)
    80004622:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004626:	00098463          	beqz	s3,8000462e <exec+0x196>
    8000462a:	4901                	li	s2,0
    8000462c:	bfa1                	j	80004584 <exec+0xec>
    sz = sz1;
    8000462e:	e0843903          	ld	s2,-504(s0)
    80004632:	bfa5                	j	800045aa <exec+0x112>
    80004634:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004636:	8552                	mv	a0,s4
    80004638:	dbdfe0ef          	jal	800033f4 <iunlockput>
  end_op();
    8000463c:	caeff0ef          	jal	80003aea <end_op>
  p = myproc();
    80004640:	acafd0ef          	jal	8000190a <myproc>
    80004644:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004646:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000464a:	6985                	lui	s3,0x1
    8000464c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000464e:	99ca                	add	s3,s3,s2
    80004650:	77fd                	lui	a5,0xfffff
    80004652:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004656:	4691                	li	a3,4
    80004658:	6609                	lui	a2,0x2
    8000465a:	964e                	add	a2,a2,s3
    8000465c:	85ce                	mv	a1,s3
    8000465e:	855a                	mv	a0,s6
    80004660:	d09fc0ef          	jal	80001368 <uvmalloc>
    80004664:	892a                	mv	s2,a0
    80004666:	e0a43423          	sd	a0,-504(s0)
    8000466a:	e519                	bnez	a0,80004678 <exec+0x1e0>
  if(pagetable)
    8000466c:	e1343423          	sd	s3,-504(s0)
    80004670:	4a01                	li	s4,0
    80004672:	aab1                	j	800047ce <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004674:	4901                	li	s2,0
    80004676:	b7c1                	j	80004636 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004678:	75f9                	lui	a1,0xffffe
    8000467a:	95aa                	add	a1,a1,a0
    8000467c:	855a                	mv	a0,s6
    8000467e:	ed5fc0ef          	jal	80001552 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004682:	7bfd                	lui	s7,0xfffff
    80004684:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004686:	e0043783          	ld	a5,-512(s0)
    8000468a:	6388                	ld	a0,0(a5)
    8000468c:	cd39                	beqz	a0,800046ea <exec+0x252>
    8000468e:	e9040993          	addi	s3,s0,-368
    80004692:	f9040c13          	addi	s8,s0,-112
    80004696:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004698:	fa0fc0ef          	jal	80000e38 <strlen>
    8000469c:	0015079b          	addiw	a5,a0,1
    800046a0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800046a4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800046a8:	11796e63          	bltu	s2,s7,800047c4 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800046ac:	e0043d03          	ld	s10,-512(s0)
    800046b0:	000d3a03          	ld	s4,0(s10)
    800046b4:	8552                	mv	a0,s4
    800046b6:	f82fc0ef          	jal	80000e38 <strlen>
    800046ba:	0015069b          	addiw	a3,a0,1
    800046be:	8652                	mv	a2,s4
    800046c0:	85ca                	mv	a1,s2
    800046c2:	855a                	mv	a0,s6
    800046c4:	eb9fc0ef          	jal	8000157c <copyout>
    800046c8:	10054063          	bltz	a0,800047c8 <exec+0x330>
    ustack[argc] = sp;
    800046cc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800046d0:	0485                	addi	s1,s1,1
    800046d2:	008d0793          	addi	a5,s10,8
    800046d6:	e0f43023          	sd	a5,-512(s0)
    800046da:	008d3503          	ld	a0,8(s10)
    800046de:	c909                	beqz	a0,800046f0 <exec+0x258>
    if(argc >= MAXARG)
    800046e0:	09a1                	addi	s3,s3,8
    800046e2:	fb899be3          	bne	s3,s8,80004698 <exec+0x200>
  ip = 0;
    800046e6:	4a01                	li	s4,0
    800046e8:	a0dd                	j	800047ce <exec+0x336>
  sp = sz;
    800046ea:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800046ee:	4481                	li	s1,0
  ustack[argc] = 0;
    800046f0:	00349793          	slli	a5,s1,0x3
    800046f4:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde1e8>
    800046f8:	97a2                	add	a5,a5,s0
    800046fa:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800046fe:	00148693          	addi	a3,s1,1
    80004702:	068e                	slli	a3,a3,0x3
    80004704:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004708:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000470c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004710:	f5796ee3          	bltu	s2,s7,8000466c <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004714:	e9040613          	addi	a2,s0,-368
    80004718:	85ca                	mv	a1,s2
    8000471a:	855a                	mv	a0,s6
    8000471c:	e61fc0ef          	jal	8000157c <copyout>
    80004720:	0e054263          	bltz	a0,80004804 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004724:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004728:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000472c:	df843783          	ld	a5,-520(s0)
    80004730:	0007c703          	lbu	a4,0(a5)
    80004734:	cf11                	beqz	a4,80004750 <exec+0x2b8>
    80004736:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004738:	02f00693          	li	a3,47
    8000473c:	a039                	j	8000474a <exec+0x2b2>
      last = s+1;
    8000473e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004742:	0785                	addi	a5,a5,1
    80004744:	fff7c703          	lbu	a4,-1(a5)
    80004748:	c701                	beqz	a4,80004750 <exec+0x2b8>
    if(*s == '/')
    8000474a:	fed71ce3          	bne	a4,a3,80004742 <exec+0x2aa>
    8000474e:	bfc5                	j	8000473e <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004750:	4641                	li	a2,16
    80004752:	df843583          	ld	a1,-520(s0)
    80004756:	158a8513          	addi	a0,s5,344
    8000475a:	eacfc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    8000475e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004762:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004766:	e0843783          	ld	a5,-504(s0)
    8000476a:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000476e:	058ab783          	ld	a5,88(s5)
    80004772:	e6843703          	ld	a4,-408(s0)
    80004776:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004778:	058ab783          	ld	a5,88(s5)
    8000477c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004780:	85e6                	mv	a1,s9
    80004782:	ab4fd0ef          	jal	80001a36 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004786:	0004851b          	sext.w	a0,s1
    8000478a:	79be                	ld	s3,488(sp)
    8000478c:	7a1e                	ld	s4,480(sp)
    8000478e:	6afe                	ld	s5,472(sp)
    80004790:	6b5e                	ld	s6,464(sp)
    80004792:	6bbe                	ld	s7,456(sp)
    80004794:	6c1e                	ld	s8,448(sp)
    80004796:	7cfa                	ld	s9,440(sp)
    80004798:	7d5a                	ld	s10,432(sp)
    8000479a:	b3b5                	j	80004506 <exec+0x6e>
    8000479c:	e1243423          	sd	s2,-504(s0)
    800047a0:	7dba                	ld	s11,424(sp)
    800047a2:	a035                	j	800047ce <exec+0x336>
    800047a4:	e1243423          	sd	s2,-504(s0)
    800047a8:	7dba                	ld	s11,424(sp)
    800047aa:	a015                	j	800047ce <exec+0x336>
    800047ac:	e1243423          	sd	s2,-504(s0)
    800047b0:	7dba                	ld	s11,424(sp)
    800047b2:	a831                	j	800047ce <exec+0x336>
    800047b4:	e1243423          	sd	s2,-504(s0)
    800047b8:	7dba                	ld	s11,424(sp)
    800047ba:	a811                	j	800047ce <exec+0x336>
    800047bc:	e1243423          	sd	s2,-504(s0)
    800047c0:	7dba                	ld	s11,424(sp)
    800047c2:	a031                	j	800047ce <exec+0x336>
  ip = 0;
    800047c4:	4a01                	li	s4,0
    800047c6:	a021                	j	800047ce <exec+0x336>
    800047c8:	4a01                	li	s4,0
  if(pagetable)
    800047ca:	a011                	j	800047ce <exec+0x336>
    800047cc:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800047ce:	e0843583          	ld	a1,-504(s0)
    800047d2:	855a                	mv	a0,s6
    800047d4:	a62fd0ef          	jal	80001a36 <proc_freepagetable>
  return -1;
    800047d8:	557d                	li	a0,-1
  if(ip){
    800047da:	000a1b63          	bnez	s4,800047f0 <exec+0x358>
    800047de:	79be                	ld	s3,488(sp)
    800047e0:	7a1e                	ld	s4,480(sp)
    800047e2:	6afe                	ld	s5,472(sp)
    800047e4:	6b5e                	ld	s6,464(sp)
    800047e6:	6bbe                	ld	s7,456(sp)
    800047e8:	6c1e                	ld	s8,448(sp)
    800047ea:	7cfa                	ld	s9,440(sp)
    800047ec:	7d5a                	ld	s10,432(sp)
    800047ee:	bb21                	j	80004506 <exec+0x6e>
    800047f0:	79be                	ld	s3,488(sp)
    800047f2:	6afe                	ld	s5,472(sp)
    800047f4:	6b5e                	ld	s6,464(sp)
    800047f6:	6bbe                	ld	s7,456(sp)
    800047f8:	6c1e                	ld	s8,448(sp)
    800047fa:	7cfa                	ld	s9,440(sp)
    800047fc:	7d5a                	ld	s10,432(sp)
    800047fe:	b9ed                	j	800044f8 <exec+0x60>
    80004800:	6b5e                	ld	s6,464(sp)
    80004802:	b9dd                	j	800044f8 <exec+0x60>
  sz = sz1;
    80004804:	e0843983          	ld	s3,-504(s0)
    80004808:	b595                	j	8000466c <exec+0x1d4>

000000008000480a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000480a:	7179                	addi	sp,sp,-48
    8000480c:	f406                	sd	ra,40(sp)
    8000480e:	f022                	sd	s0,32(sp)
    80004810:	ec26                	sd	s1,24(sp)
    80004812:	e84a                	sd	s2,16(sp)
    80004814:	1800                	addi	s0,sp,48
    80004816:	892e                	mv	s2,a1
    80004818:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000481a:	fdc40593          	addi	a1,s0,-36
    8000481e:	fa1fd0ef          	jal	800027be <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004822:	fdc42703          	lw	a4,-36(s0)
    80004826:	47bd                	li	a5,15
    80004828:	02e7e963          	bltu	a5,a4,8000485a <argfd+0x50>
    8000482c:	8defd0ef          	jal	8000190a <myproc>
    80004830:	fdc42703          	lw	a4,-36(s0)
    80004834:	01a70793          	addi	a5,a4,26
    80004838:	078e                	slli	a5,a5,0x3
    8000483a:	953e                	add	a0,a0,a5
    8000483c:	611c                	ld	a5,0(a0)
    8000483e:	c385                	beqz	a5,8000485e <argfd+0x54>
    return -1;
  if(pfd)
    80004840:	00090463          	beqz	s2,80004848 <argfd+0x3e>
    *pfd = fd;
    80004844:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004848:	4501                	li	a0,0
  if(pf)
    8000484a:	c091                	beqz	s1,8000484e <argfd+0x44>
    *pf = f;
    8000484c:	e09c                	sd	a5,0(s1)
}
    8000484e:	70a2                	ld	ra,40(sp)
    80004850:	7402                	ld	s0,32(sp)
    80004852:	64e2                	ld	s1,24(sp)
    80004854:	6942                	ld	s2,16(sp)
    80004856:	6145                	addi	sp,sp,48
    80004858:	8082                	ret
    return -1;
    8000485a:	557d                	li	a0,-1
    8000485c:	bfcd                	j	8000484e <argfd+0x44>
    8000485e:	557d                	li	a0,-1
    80004860:	b7fd                	j	8000484e <argfd+0x44>

0000000080004862 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004862:	1101                	addi	sp,sp,-32
    80004864:	ec06                	sd	ra,24(sp)
    80004866:	e822                	sd	s0,16(sp)
    80004868:	e426                	sd	s1,8(sp)
    8000486a:	1000                	addi	s0,sp,32
    8000486c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000486e:	89cfd0ef          	jal	8000190a <myproc>
    80004872:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004874:	0d050793          	addi	a5,a0,208
    80004878:	4501                	li	a0,0
    8000487a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000487c:	6398                	ld	a4,0(a5)
    8000487e:	cb19                	beqz	a4,80004894 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004880:	2505                	addiw	a0,a0,1
    80004882:	07a1                	addi	a5,a5,8
    80004884:	fed51ce3          	bne	a0,a3,8000487c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004888:	557d                	li	a0,-1
}
    8000488a:	60e2                	ld	ra,24(sp)
    8000488c:	6442                	ld	s0,16(sp)
    8000488e:	64a2                	ld	s1,8(sp)
    80004890:	6105                	addi	sp,sp,32
    80004892:	8082                	ret
      p->ofile[fd] = f;
    80004894:	01a50793          	addi	a5,a0,26
    80004898:	078e                	slli	a5,a5,0x3
    8000489a:	963e                	add	a2,a2,a5
    8000489c:	e204                	sd	s1,0(a2)
      return fd;
    8000489e:	b7f5                	j	8000488a <fdalloc+0x28>

00000000800048a0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800048a0:	715d                	addi	sp,sp,-80
    800048a2:	e486                	sd	ra,72(sp)
    800048a4:	e0a2                	sd	s0,64(sp)
    800048a6:	fc26                	sd	s1,56(sp)
    800048a8:	f84a                	sd	s2,48(sp)
    800048aa:	f44e                	sd	s3,40(sp)
    800048ac:	ec56                	sd	s5,24(sp)
    800048ae:	e85a                	sd	s6,16(sp)
    800048b0:	0880                	addi	s0,sp,80
    800048b2:	8b2e                	mv	s6,a1
    800048b4:	89b2                	mv	s3,a2
    800048b6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800048b8:	fb040593          	addi	a1,s0,-80
    800048bc:	822ff0ef          	jal	800038de <nameiparent>
    800048c0:	84aa                	mv	s1,a0
    800048c2:	10050a63          	beqz	a0,800049d6 <create+0x136>
    return 0;

  ilock(dp);
    800048c6:	925fe0ef          	jal	800031ea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800048ca:	4601                	li	a2,0
    800048cc:	fb040593          	addi	a1,s0,-80
    800048d0:	8526                	mv	a0,s1
    800048d2:	d8dfe0ef          	jal	8000365e <dirlookup>
    800048d6:	8aaa                	mv	s5,a0
    800048d8:	c129                	beqz	a0,8000491a <create+0x7a>
    iunlockput(dp);
    800048da:	8526                	mv	a0,s1
    800048dc:	b19fe0ef          	jal	800033f4 <iunlockput>
    ilock(ip);
    800048e0:	8556                	mv	a0,s5
    800048e2:	909fe0ef          	jal	800031ea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048e6:	4789                	li	a5,2
    800048e8:	02fb1463          	bne	s6,a5,80004910 <create+0x70>
    800048ec:	044ad783          	lhu	a5,68(s5)
    800048f0:	37f9                	addiw	a5,a5,-2
    800048f2:	17c2                	slli	a5,a5,0x30
    800048f4:	93c1                	srli	a5,a5,0x30
    800048f6:	4705                	li	a4,1
    800048f8:	00f76c63          	bltu	a4,a5,80004910 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800048fc:	8556                	mv	a0,s5
    800048fe:	60a6                	ld	ra,72(sp)
    80004900:	6406                	ld	s0,64(sp)
    80004902:	74e2                	ld	s1,56(sp)
    80004904:	7942                	ld	s2,48(sp)
    80004906:	79a2                	ld	s3,40(sp)
    80004908:	6ae2                	ld	s5,24(sp)
    8000490a:	6b42                	ld	s6,16(sp)
    8000490c:	6161                	addi	sp,sp,80
    8000490e:	8082                	ret
    iunlockput(ip);
    80004910:	8556                	mv	a0,s5
    80004912:	ae3fe0ef          	jal	800033f4 <iunlockput>
    return 0;
    80004916:	4a81                	li	s5,0
    80004918:	b7d5                	j	800048fc <create+0x5c>
    8000491a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000491c:	85da                	mv	a1,s6
    8000491e:	4088                	lw	a0,0(s1)
    80004920:	f5afe0ef          	jal	8000307a <ialloc>
    80004924:	8a2a                	mv	s4,a0
    80004926:	cd15                	beqz	a0,80004962 <create+0xc2>
  ilock(ip);
    80004928:	8c3fe0ef          	jal	800031ea <ilock>
  ip->major = major;
    8000492c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004930:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004934:	4905                	li	s2,1
    80004936:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000493a:	8552                	mv	a0,s4
    8000493c:	ffafe0ef          	jal	80003136 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004940:	032b0763          	beq	s6,s2,8000496e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004944:	004a2603          	lw	a2,4(s4)
    80004948:	fb040593          	addi	a1,s0,-80
    8000494c:	8526                	mv	a0,s1
    8000494e:	eddfe0ef          	jal	8000382a <dirlink>
    80004952:	06054563          	bltz	a0,800049bc <create+0x11c>
  iunlockput(dp);
    80004956:	8526                	mv	a0,s1
    80004958:	a9dfe0ef          	jal	800033f4 <iunlockput>
  return ip;
    8000495c:	8ad2                	mv	s5,s4
    8000495e:	7a02                	ld	s4,32(sp)
    80004960:	bf71                	j	800048fc <create+0x5c>
    iunlockput(dp);
    80004962:	8526                	mv	a0,s1
    80004964:	a91fe0ef          	jal	800033f4 <iunlockput>
    return 0;
    80004968:	8ad2                	mv	s5,s4
    8000496a:	7a02                	ld	s4,32(sp)
    8000496c:	bf41                	j	800048fc <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000496e:	004a2603          	lw	a2,4(s4)
    80004972:	00003597          	auipc	a1,0x3
    80004976:	dae58593          	addi	a1,a1,-594 # 80007720 <etext+0x720>
    8000497a:	8552                	mv	a0,s4
    8000497c:	eaffe0ef          	jal	8000382a <dirlink>
    80004980:	02054e63          	bltz	a0,800049bc <create+0x11c>
    80004984:	40d0                	lw	a2,4(s1)
    80004986:	00003597          	auipc	a1,0x3
    8000498a:	da258593          	addi	a1,a1,-606 # 80007728 <etext+0x728>
    8000498e:	8552                	mv	a0,s4
    80004990:	e9bfe0ef          	jal	8000382a <dirlink>
    80004994:	02054463          	bltz	a0,800049bc <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004998:	004a2603          	lw	a2,4(s4)
    8000499c:	fb040593          	addi	a1,s0,-80
    800049a0:	8526                	mv	a0,s1
    800049a2:	e89fe0ef          	jal	8000382a <dirlink>
    800049a6:	00054b63          	bltz	a0,800049bc <create+0x11c>
    dp->nlink++;  // for ".."
    800049aa:	04a4d783          	lhu	a5,74(s1)
    800049ae:	2785                	addiw	a5,a5,1
    800049b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049b4:	8526                	mv	a0,s1
    800049b6:	f80fe0ef          	jal	80003136 <iupdate>
    800049ba:	bf71                	j	80004956 <create+0xb6>
  ip->nlink = 0;
    800049bc:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800049c0:	8552                	mv	a0,s4
    800049c2:	f74fe0ef          	jal	80003136 <iupdate>
  iunlockput(ip);
    800049c6:	8552                	mv	a0,s4
    800049c8:	a2dfe0ef          	jal	800033f4 <iunlockput>
  iunlockput(dp);
    800049cc:	8526                	mv	a0,s1
    800049ce:	a27fe0ef          	jal	800033f4 <iunlockput>
  return 0;
    800049d2:	7a02                	ld	s4,32(sp)
    800049d4:	b725                	j	800048fc <create+0x5c>
    return 0;
    800049d6:	8aaa                	mv	s5,a0
    800049d8:	b715                	j	800048fc <create+0x5c>

00000000800049da <sys_dup>:
{
    800049da:	7179                	addi	sp,sp,-48
    800049dc:	f406                	sd	ra,40(sp)
    800049de:	f022                	sd	s0,32(sp)
    800049e0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049e2:	fd840613          	addi	a2,s0,-40
    800049e6:	4581                	li	a1,0
    800049e8:	4501                	li	a0,0
    800049ea:	e21ff0ef          	jal	8000480a <argfd>
    return -1;
    800049ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049f0:	02054363          	bltz	a0,80004a16 <sys_dup+0x3c>
    800049f4:	ec26                	sd	s1,24(sp)
    800049f6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800049f8:	fd843903          	ld	s2,-40(s0)
    800049fc:	854a                	mv	a0,s2
    800049fe:	e65ff0ef          	jal	80004862 <fdalloc>
    80004a02:	84aa                	mv	s1,a0
    return -1;
    80004a04:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a06:	00054d63          	bltz	a0,80004a20 <sys_dup+0x46>
  filedup(f);
    80004a0a:	854a                	mv	a0,s2
    80004a0c:	c48ff0ef          	jal	80003e54 <filedup>
  return fd;
    80004a10:	87a6                	mv	a5,s1
    80004a12:	64e2                	ld	s1,24(sp)
    80004a14:	6942                	ld	s2,16(sp)
}
    80004a16:	853e                	mv	a0,a5
    80004a18:	70a2                	ld	ra,40(sp)
    80004a1a:	7402                	ld	s0,32(sp)
    80004a1c:	6145                	addi	sp,sp,48
    80004a1e:	8082                	ret
    80004a20:	64e2                	ld	s1,24(sp)
    80004a22:	6942                	ld	s2,16(sp)
    80004a24:	bfcd                	j	80004a16 <sys_dup+0x3c>

0000000080004a26 <sys_read>:
{
    80004a26:	7179                	addi	sp,sp,-48
    80004a28:	f406                	sd	ra,40(sp)
    80004a2a:	f022                	sd	s0,32(sp)
    80004a2c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a2e:	fd840593          	addi	a1,s0,-40
    80004a32:	4505                	li	a0,1
    80004a34:	da7fd0ef          	jal	800027da <argaddr>
  argint(2, &n);
    80004a38:	fe440593          	addi	a1,s0,-28
    80004a3c:	4509                	li	a0,2
    80004a3e:	d81fd0ef          	jal	800027be <argint>
  if(argfd(0, 0, &f) < 0)
    80004a42:	fe840613          	addi	a2,s0,-24
    80004a46:	4581                	li	a1,0
    80004a48:	4501                	li	a0,0
    80004a4a:	dc1ff0ef          	jal	8000480a <argfd>
    80004a4e:	87aa                	mv	a5,a0
    return -1;
    80004a50:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a52:	0007ca63          	bltz	a5,80004a66 <sys_read+0x40>
  return fileread(f, p, n);
    80004a56:	fe442603          	lw	a2,-28(s0)
    80004a5a:	fd843583          	ld	a1,-40(s0)
    80004a5e:	fe843503          	ld	a0,-24(s0)
    80004a62:	d58ff0ef          	jal	80003fba <fileread>
}
    80004a66:	70a2                	ld	ra,40(sp)
    80004a68:	7402                	ld	s0,32(sp)
    80004a6a:	6145                	addi	sp,sp,48
    80004a6c:	8082                	ret

0000000080004a6e <sys_write>:
{
    80004a6e:	7179                	addi	sp,sp,-48
    80004a70:	f406                	sd	ra,40(sp)
    80004a72:	f022                	sd	s0,32(sp)
    80004a74:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a76:	fd840593          	addi	a1,s0,-40
    80004a7a:	4505                	li	a0,1
    80004a7c:	d5ffd0ef          	jal	800027da <argaddr>
  argint(2, &n);
    80004a80:	fe440593          	addi	a1,s0,-28
    80004a84:	4509                	li	a0,2
    80004a86:	d39fd0ef          	jal	800027be <argint>
  if(argfd(0, 0, &f) < 0)
    80004a8a:	fe840613          	addi	a2,s0,-24
    80004a8e:	4581                	li	a1,0
    80004a90:	4501                	li	a0,0
    80004a92:	d79ff0ef          	jal	8000480a <argfd>
    80004a96:	87aa                	mv	a5,a0
    return -1;
    80004a98:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a9a:	0007ca63          	bltz	a5,80004aae <sys_write+0x40>
  return filewrite(f, p, n);
    80004a9e:	fe442603          	lw	a2,-28(s0)
    80004aa2:	fd843583          	ld	a1,-40(s0)
    80004aa6:	fe843503          	ld	a0,-24(s0)
    80004aaa:	dceff0ef          	jal	80004078 <filewrite>
}
    80004aae:	70a2                	ld	ra,40(sp)
    80004ab0:	7402                	ld	s0,32(sp)
    80004ab2:	6145                	addi	sp,sp,48
    80004ab4:	8082                	ret

0000000080004ab6 <sys_close>:
{
    80004ab6:	1101                	addi	sp,sp,-32
    80004ab8:	ec06                	sd	ra,24(sp)
    80004aba:	e822                	sd	s0,16(sp)
    80004abc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004abe:	fe040613          	addi	a2,s0,-32
    80004ac2:	fec40593          	addi	a1,s0,-20
    80004ac6:	4501                	li	a0,0
    80004ac8:	d43ff0ef          	jal	8000480a <argfd>
    return -1;
    80004acc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ace:	02054063          	bltz	a0,80004aee <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004ad2:	e39fc0ef          	jal	8000190a <myproc>
    80004ad6:	fec42783          	lw	a5,-20(s0)
    80004ada:	07e9                	addi	a5,a5,26
    80004adc:	078e                	slli	a5,a5,0x3
    80004ade:	953e                	add	a0,a0,a5
    80004ae0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ae4:	fe043503          	ld	a0,-32(s0)
    80004ae8:	bb2ff0ef          	jal	80003e9a <fileclose>
  return 0;
    80004aec:	4781                	li	a5,0
}
    80004aee:	853e                	mv	a0,a5
    80004af0:	60e2                	ld	ra,24(sp)
    80004af2:	6442                	ld	s0,16(sp)
    80004af4:	6105                	addi	sp,sp,32
    80004af6:	8082                	ret

0000000080004af8 <sys_fstat>:
{
    80004af8:	1101                	addi	sp,sp,-32
    80004afa:	ec06                	sd	ra,24(sp)
    80004afc:	e822                	sd	s0,16(sp)
    80004afe:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004b00:	fe040593          	addi	a1,s0,-32
    80004b04:	4505                	li	a0,1
    80004b06:	cd5fd0ef          	jal	800027da <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b0a:	fe840613          	addi	a2,s0,-24
    80004b0e:	4581                	li	a1,0
    80004b10:	4501                	li	a0,0
    80004b12:	cf9ff0ef          	jal	8000480a <argfd>
    80004b16:	87aa                	mv	a5,a0
    return -1;
    80004b18:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b1a:	0007c863          	bltz	a5,80004b2a <sys_fstat+0x32>
  return filestat(f, st);
    80004b1e:	fe043583          	ld	a1,-32(s0)
    80004b22:	fe843503          	ld	a0,-24(s0)
    80004b26:	c36ff0ef          	jal	80003f5c <filestat>
}
    80004b2a:	60e2                	ld	ra,24(sp)
    80004b2c:	6442                	ld	s0,16(sp)
    80004b2e:	6105                	addi	sp,sp,32
    80004b30:	8082                	ret

0000000080004b32 <sys_link>:
{
    80004b32:	7169                	addi	sp,sp,-304
    80004b34:	f606                	sd	ra,296(sp)
    80004b36:	f222                	sd	s0,288(sp)
    80004b38:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b3a:	08000613          	li	a2,128
    80004b3e:	ed040593          	addi	a1,s0,-304
    80004b42:	4501                	li	a0,0
    80004b44:	cb3fd0ef          	jal	800027f6 <argstr>
    return -1;
    80004b48:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b4a:	0c054e63          	bltz	a0,80004c26 <sys_link+0xf4>
    80004b4e:	08000613          	li	a2,128
    80004b52:	f5040593          	addi	a1,s0,-176
    80004b56:	4505                	li	a0,1
    80004b58:	c9ffd0ef          	jal	800027f6 <argstr>
    return -1;
    80004b5c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b5e:	0c054463          	bltz	a0,80004c26 <sys_link+0xf4>
    80004b62:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b64:	f1dfe0ef          	jal	80003a80 <begin_op>
  if((ip = namei(old)) == 0){
    80004b68:	ed040513          	addi	a0,s0,-304
    80004b6c:	d59fe0ef          	jal	800038c4 <namei>
    80004b70:	84aa                	mv	s1,a0
    80004b72:	c53d                	beqz	a0,80004be0 <sys_link+0xae>
  ilock(ip);
    80004b74:	e76fe0ef          	jal	800031ea <ilock>
  if(ip->type == T_DIR){
    80004b78:	04449703          	lh	a4,68(s1)
    80004b7c:	4785                	li	a5,1
    80004b7e:	06f70663          	beq	a4,a5,80004bea <sys_link+0xb8>
    80004b82:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b84:	04a4d783          	lhu	a5,74(s1)
    80004b88:	2785                	addiw	a5,a5,1
    80004b8a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b8e:	8526                	mv	a0,s1
    80004b90:	da6fe0ef          	jal	80003136 <iupdate>
  iunlock(ip);
    80004b94:	8526                	mv	a0,s1
    80004b96:	f02fe0ef          	jal	80003298 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b9a:	fd040593          	addi	a1,s0,-48
    80004b9e:	f5040513          	addi	a0,s0,-176
    80004ba2:	d3dfe0ef          	jal	800038de <nameiparent>
    80004ba6:	892a                	mv	s2,a0
    80004ba8:	cd21                	beqz	a0,80004c00 <sys_link+0xce>
  ilock(dp);
    80004baa:	e40fe0ef          	jal	800031ea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bae:	00092703          	lw	a4,0(s2)
    80004bb2:	409c                	lw	a5,0(s1)
    80004bb4:	04f71363          	bne	a4,a5,80004bfa <sys_link+0xc8>
    80004bb8:	40d0                	lw	a2,4(s1)
    80004bba:	fd040593          	addi	a1,s0,-48
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	c6bfe0ef          	jal	8000382a <dirlink>
    80004bc4:	02054b63          	bltz	a0,80004bfa <sys_link+0xc8>
  iunlockput(dp);
    80004bc8:	854a                	mv	a0,s2
    80004bca:	82bfe0ef          	jal	800033f4 <iunlockput>
  iput(ip);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	f9cfe0ef          	jal	8000336c <iput>
  end_op();
    80004bd4:	f17fe0ef          	jal	80003aea <end_op>
  return 0;
    80004bd8:	4781                	li	a5,0
    80004bda:	64f2                	ld	s1,280(sp)
    80004bdc:	6952                	ld	s2,272(sp)
    80004bde:	a0a1                	j	80004c26 <sys_link+0xf4>
    end_op();
    80004be0:	f0bfe0ef          	jal	80003aea <end_op>
    return -1;
    80004be4:	57fd                	li	a5,-1
    80004be6:	64f2                	ld	s1,280(sp)
    80004be8:	a83d                	j	80004c26 <sys_link+0xf4>
    iunlockput(ip);
    80004bea:	8526                	mv	a0,s1
    80004bec:	809fe0ef          	jal	800033f4 <iunlockput>
    end_op();
    80004bf0:	efbfe0ef          	jal	80003aea <end_op>
    return -1;
    80004bf4:	57fd                	li	a5,-1
    80004bf6:	64f2                	ld	s1,280(sp)
    80004bf8:	a03d                	j	80004c26 <sys_link+0xf4>
    iunlockput(dp);
    80004bfa:	854a                	mv	a0,s2
    80004bfc:	ff8fe0ef          	jal	800033f4 <iunlockput>
  ilock(ip);
    80004c00:	8526                	mv	a0,s1
    80004c02:	de8fe0ef          	jal	800031ea <ilock>
  ip->nlink--;
    80004c06:	04a4d783          	lhu	a5,74(s1)
    80004c0a:	37fd                	addiw	a5,a5,-1
    80004c0c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c10:	8526                	mv	a0,s1
    80004c12:	d24fe0ef          	jal	80003136 <iupdate>
  iunlockput(ip);
    80004c16:	8526                	mv	a0,s1
    80004c18:	fdcfe0ef          	jal	800033f4 <iunlockput>
  end_op();
    80004c1c:	ecffe0ef          	jal	80003aea <end_op>
  return -1;
    80004c20:	57fd                	li	a5,-1
    80004c22:	64f2                	ld	s1,280(sp)
    80004c24:	6952                	ld	s2,272(sp)
}
    80004c26:	853e                	mv	a0,a5
    80004c28:	70b2                	ld	ra,296(sp)
    80004c2a:	7412                	ld	s0,288(sp)
    80004c2c:	6155                	addi	sp,sp,304
    80004c2e:	8082                	ret

0000000080004c30 <sys_unlink>:
{
    80004c30:	7151                	addi	sp,sp,-240
    80004c32:	f586                	sd	ra,232(sp)
    80004c34:	f1a2                	sd	s0,224(sp)
    80004c36:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c38:	08000613          	li	a2,128
    80004c3c:	f3040593          	addi	a1,s0,-208
    80004c40:	4501                	li	a0,0
    80004c42:	bb5fd0ef          	jal	800027f6 <argstr>
    80004c46:	16054063          	bltz	a0,80004da6 <sys_unlink+0x176>
    80004c4a:	eda6                	sd	s1,216(sp)
  begin_op();
    80004c4c:	e35fe0ef          	jal	80003a80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c50:	fb040593          	addi	a1,s0,-80
    80004c54:	f3040513          	addi	a0,s0,-208
    80004c58:	c87fe0ef          	jal	800038de <nameiparent>
    80004c5c:	84aa                	mv	s1,a0
    80004c5e:	c945                	beqz	a0,80004d0e <sys_unlink+0xde>
  ilock(dp);
    80004c60:	d8afe0ef          	jal	800031ea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c64:	00003597          	auipc	a1,0x3
    80004c68:	abc58593          	addi	a1,a1,-1348 # 80007720 <etext+0x720>
    80004c6c:	fb040513          	addi	a0,s0,-80
    80004c70:	9d9fe0ef          	jal	80003648 <namecmp>
    80004c74:	10050e63          	beqz	a0,80004d90 <sys_unlink+0x160>
    80004c78:	00003597          	auipc	a1,0x3
    80004c7c:	ab058593          	addi	a1,a1,-1360 # 80007728 <etext+0x728>
    80004c80:	fb040513          	addi	a0,s0,-80
    80004c84:	9c5fe0ef          	jal	80003648 <namecmp>
    80004c88:	10050463          	beqz	a0,80004d90 <sys_unlink+0x160>
    80004c8c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c8e:	f2c40613          	addi	a2,s0,-212
    80004c92:	fb040593          	addi	a1,s0,-80
    80004c96:	8526                	mv	a0,s1
    80004c98:	9c7fe0ef          	jal	8000365e <dirlookup>
    80004c9c:	892a                	mv	s2,a0
    80004c9e:	0e050863          	beqz	a0,80004d8e <sys_unlink+0x15e>
  ilock(ip);
    80004ca2:	d48fe0ef          	jal	800031ea <ilock>
  if(ip->nlink < 1)
    80004ca6:	04a91783          	lh	a5,74(s2)
    80004caa:	06f05763          	blez	a5,80004d18 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004cae:	04491703          	lh	a4,68(s2)
    80004cb2:	4785                	li	a5,1
    80004cb4:	06f70963          	beq	a4,a5,80004d26 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004cb8:	4641                	li	a2,16
    80004cba:	4581                	li	a1,0
    80004cbc:	fc040513          	addi	a0,s0,-64
    80004cc0:	808fc0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cc4:	4741                	li	a4,16
    80004cc6:	f2c42683          	lw	a3,-212(s0)
    80004cca:	fc040613          	addi	a2,s0,-64
    80004cce:	4581                	li	a1,0
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	869fe0ef          	jal	8000353a <writei>
    80004cd6:	47c1                	li	a5,16
    80004cd8:	08f51b63          	bne	a0,a5,80004d6e <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004cdc:	04491703          	lh	a4,68(s2)
    80004ce0:	4785                	li	a5,1
    80004ce2:	08f70d63          	beq	a4,a5,80004d7c <sys_unlink+0x14c>
  iunlockput(dp);
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	f0cfe0ef          	jal	800033f4 <iunlockput>
  ip->nlink--;
    80004cec:	04a95783          	lhu	a5,74(s2)
    80004cf0:	37fd                	addiw	a5,a5,-1
    80004cf2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cf6:	854a                	mv	a0,s2
    80004cf8:	c3efe0ef          	jal	80003136 <iupdate>
  iunlockput(ip);
    80004cfc:	854a                	mv	a0,s2
    80004cfe:	ef6fe0ef          	jal	800033f4 <iunlockput>
  end_op();
    80004d02:	de9fe0ef          	jal	80003aea <end_op>
  return 0;
    80004d06:	4501                	li	a0,0
    80004d08:	64ee                	ld	s1,216(sp)
    80004d0a:	694e                	ld	s2,208(sp)
    80004d0c:	a849                	j	80004d9e <sys_unlink+0x16e>
    end_op();
    80004d0e:	dddfe0ef          	jal	80003aea <end_op>
    return -1;
    80004d12:	557d                	li	a0,-1
    80004d14:	64ee                	ld	s1,216(sp)
    80004d16:	a061                	j	80004d9e <sys_unlink+0x16e>
    80004d18:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004d1a:	00003517          	auipc	a0,0x3
    80004d1e:	a1650513          	addi	a0,a0,-1514 # 80007730 <etext+0x730>
    80004d22:	a73fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d26:	04c92703          	lw	a4,76(s2)
    80004d2a:	02000793          	li	a5,32
    80004d2e:	f8e7f5e3          	bgeu	a5,a4,80004cb8 <sys_unlink+0x88>
    80004d32:	e5ce                	sd	s3,200(sp)
    80004d34:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d38:	4741                	li	a4,16
    80004d3a:	86ce                	mv	a3,s3
    80004d3c:	f1840613          	addi	a2,s0,-232
    80004d40:	4581                	li	a1,0
    80004d42:	854a                	mv	a0,s2
    80004d44:	efafe0ef          	jal	8000343e <readi>
    80004d48:	47c1                	li	a5,16
    80004d4a:	00f51c63          	bne	a0,a5,80004d62 <sys_unlink+0x132>
    if(de.inum != 0)
    80004d4e:	f1845783          	lhu	a5,-232(s0)
    80004d52:	efa1                	bnez	a5,80004daa <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d54:	29c1                	addiw	s3,s3,16
    80004d56:	04c92783          	lw	a5,76(s2)
    80004d5a:	fcf9efe3          	bltu	s3,a5,80004d38 <sys_unlink+0x108>
    80004d5e:	69ae                	ld	s3,200(sp)
    80004d60:	bfa1                	j	80004cb8 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004d62:	00003517          	auipc	a0,0x3
    80004d66:	9e650513          	addi	a0,a0,-1562 # 80007748 <etext+0x748>
    80004d6a:	a2bfb0ef          	jal	80000794 <panic>
    80004d6e:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d70:	00003517          	auipc	a0,0x3
    80004d74:	9f050513          	addi	a0,a0,-1552 # 80007760 <etext+0x760>
    80004d78:	a1dfb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004d7c:	04a4d783          	lhu	a5,74(s1)
    80004d80:	37fd                	addiw	a5,a5,-1
    80004d82:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d86:	8526                	mv	a0,s1
    80004d88:	baefe0ef          	jal	80003136 <iupdate>
    80004d8c:	bfa9                	j	80004ce6 <sys_unlink+0xb6>
    80004d8e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d90:	8526                	mv	a0,s1
    80004d92:	e62fe0ef          	jal	800033f4 <iunlockput>
  end_op();
    80004d96:	d55fe0ef          	jal	80003aea <end_op>
  return -1;
    80004d9a:	557d                	li	a0,-1
    80004d9c:	64ee                	ld	s1,216(sp)
}
    80004d9e:	70ae                	ld	ra,232(sp)
    80004da0:	740e                	ld	s0,224(sp)
    80004da2:	616d                	addi	sp,sp,240
    80004da4:	8082                	ret
    return -1;
    80004da6:	557d                	li	a0,-1
    80004da8:	bfdd                	j	80004d9e <sys_unlink+0x16e>
    iunlockput(ip);
    80004daa:	854a                	mv	a0,s2
    80004dac:	e48fe0ef          	jal	800033f4 <iunlockput>
    goto bad;
    80004db0:	694e                	ld	s2,208(sp)
    80004db2:	69ae                	ld	s3,200(sp)
    80004db4:	bff1                	j	80004d90 <sys_unlink+0x160>

0000000080004db6 <sys_open>:

uint64
sys_open(void)
{
    80004db6:	7131                	addi	sp,sp,-192
    80004db8:	fd06                	sd	ra,184(sp)
    80004dba:	f922                	sd	s0,176(sp)
    80004dbc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004dbe:	f4c40593          	addi	a1,s0,-180
    80004dc2:	4505                	li	a0,1
    80004dc4:	9fbfd0ef          	jal	800027be <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dc8:	08000613          	li	a2,128
    80004dcc:	f5040593          	addi	a1,s0,-176
    80004dd0:	4501                	li	a0,0
    80004dd2:	a25fd0ef          	jal	800027f6 <argstr>
    80004dd6:	87aa                	mv	a5,a0
    return -1;
    80004dd8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004dda:	0a07c263          	bltz	a5,80004e7e <sys_open+0xc8>
    80004dde:	f526                	sd	s1,168(sp)

  begin_op();
    80004de0:	ca1fe0ef          	jal	80003a80 <begin_op>

  if(omode & O_CREATE){
    80004de4:	f4c42783          	lw	a5,-180(s0)
    80004de8:	2007f793          	andi	a5,a5,512
    80004dec:	c3d5                	beqz	a5,80004e90 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004dee:	4681                	li	a3,0
    80004df0:	4601                	li	a2,0
    80004df2:	4589                	li	a1,2
    80004df4:	f5040513          	addi	a0,s0,-176
    80004df8:	aa9ff0ef          	jal	800048a0 <create>
    80004dfc:	84aa                	mv	s1,a0
    if(ip == 0){
    80004dfe:	c541                	beqz	a0,80004e86 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e00:	04449703          	lh	a4,68(s1)
    80004e04:	478d                	li	a5,3
    80004e06:	00f71763          	bne	a4,a5,80004e14 <sys_open+0x5e>
    80004e0a:	0464d703          	lhu	a4,70(s1)
    80004e0e:	47a5                	li	a5,9
    80004e10:	0ae7ed63          	bltu	a5,a4,80004eca <sys_open+0x114>
    80004e14:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e16:	fe1fe0ef          	jal	80003df6 <filealloc>
    80004e1a:	892a                	mv	s2,a0
    80004e1c:	c179                	beqz	a0,80004ee2 <sys_open+0x12c>
    80004e1e:	ed4e                	sd	s3,152(sp)
    80004e20:	a43ff0ef          	jal	80004862 <fdalloc>
    80004e24:	89aa                	mv	s3,a0
    80004e26:	0a054a63          	bltz	a0,80004eda <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e2a:	04449703          	lh	a4,68(s1)
    80004e2e:	478d                	li	a5,3
    80004e30:	0cf70263          	beq	a4,a5,80004ef4 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e34:	4789                	li	a5,2
    80004e36:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004e3a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004e3e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004e42:	f4c42783          	lw	a5,-180(s0)
    80004e46:	0017c713          	xori	a4,a5,1
    80004e4a:	8b05                	andi	a4,a4,1
    80004e4c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e50:	0037f713          	andi	a4,a5,3
    80004e54:	00e03733          	snez	a4,a4
    80004e58:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e5c:	4007f793          	andi	a5,a5,1024
    80004e60:	c791                	beqz	a5,80004e6c <sys_open+0xb6>
    80004e62:	04449703          	lh	a4,68(s1)
    80004e66:	4789                	li	a5,2
    80004e68:	08f70d63          	beq	a4,a5,80004f02 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e6c:	8526                	mv	a0,s1
    80004e6e:	c2afe0ef          	jal	80003298 <iunlock>
  end_op();
    80004e72:	c79fe0ef          	jal	80003aea <end_op>

  return fd;
    80004e76:	854e                	mv	a0,s3
    80004e78:	74aa                	ld	s1,168(sp)
    80004e7a:	790a                	ld	s2,160(sp)
    80004e7c:	69ea                	ld	s3,152(sp)
}
    80004e7e:	70ea                	ld	ra,184(sp)
    80004e80:	744a                	ld	s0,176(sp)
    80004e82:	6129                	addi	sp,sp,192
    80004e84:	8082                	ret
      end_op();
    80004e86:	c65fe0ef          	jal	80003aea <end_op>
      return -1;
    80004e8a:	557d                	li	a0,-1
    80004e8c:	74aa                	ld	s1,168(sp)
    80004e8e:	bfc5                	j	80004e7e <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004e90:	f5040513          	addi	a0,s0,-176
    80004e94:	a31fe0ef          	jal	800038c4 <namei>
    80004e98:	84aa                	mv	s1,a0
    80004e9a:	c11d                	beqz	a0,80004ec0 <sys_open+0x10a>
    ilock(ip);
    80004e9c:	b4efe0ef          	jal	800031ea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ea0:	04449703          	lh	a4,68(s1)
    80004ea4:	4785                	li	a5,1
    80004ea6:	f4f71de3          	bne	a4,a5,80004e00 <sys_open+0x4a>
    80004eaa:	f4c42783          	lw	a5,-180(s0)
    80004eae:	d3bd                	beqz	a5,80004e14 <sys_open+0x5e>
      iunlockput(ip);
    80004eb0:	8526                	mv	a0,s1
    80004eb2:	d42fe0ef          	jal	800033f4 <iunlockput>
      end_op();
    80004eb6:	c35fe0ef          	jal	80003aea <end_op>
      return -1;
    80004eba:	557d                	li	a0,-1
    80004ebc:	74aa                	ld	s1,168(sp)
    80004ebe:	b7c1                	j	80004e7e <sys_open+0xc8>
      end_op();
    80004ec0:	c2bfe0ef          	jal	80003aea <end_op>
      return -1;
    80004ec4:	557d                	li	a0,-1
    80004ec6:	74aa                	ld	s1,168(sp)
    80004ec8:	bf5d                	j	80004e7e <sys_open+0xc8>
    iunlockput(ip);
    80004eca:	8526                	mv	a0,s1
    80004ecc:	d28fe0ef          	jal	800033f4 <iunlockput>
    end_op();
    80004ed0:	c1bfe0ef          	jal	80003aea <end_op>
    return -1;
    80004ed4:	557d                	li	a0,-1
    80004ed6:	74aa                	ld	s1,168(sp)
    80004ed8:	b75d                	j	80004e7e <sys_open+0xc8>
      fileclose(f);
    80004eda:	854a                	mv	a0,s2
    80004edc:	fbffe0ef          	jal	80003e9a <fileclose>
    80004ee0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004ee2:	8526                	mv	a0,s1
    80004ee4:	d10fe0ef          	jal	800033f4 <iunlockput>
    end_op();
    80004ee8:	c03fe0ef          	jal	80003aea <end_op>
    return -1;
    80004eec:	557d                	li	a0,-1
    80004eee:	74aa                	ld	s1,168(sp)
    80004ef0:	790a                	ld	s2,160(sp)
    80004ef2:	b771                	j	80004e7e <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004ef4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ef8:	04649783          	lh	a5,70(s1)
    80004efc:	02f91223          	sh	a5,36(s2)
    80004f00:	bf3d                	j	80004e3e <sys_open+0x88>
    itrunc(ip);
    80004f02:	8526                	mv	a0,s1
    80004f04:	bd4fe0ef          	jal	800032d8 <itrunc>
    80004f08:	b795                	j	80004e6c <sys_open+0xb6>

0000000080004f0a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f0a:	7175                	addi	sp,sp,-144
    80004f0c:	e506                	sd	ra,136(sp)
    80004f0e:	e122                	sd	s0,128(sp)
    80004f10:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f12:	b6ffe0ef          	jal	80003a80 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f16:	08000613          	li	a2,128
    80004f1a:	f7040593          	addi	a1,s0,-144
    80004f1e:	4501                	li	a0,0
    80004f20:	8d7fd0ef          	jal	800027f6 <argstr>
    80004f24:	02054363          	bltz	a0,80004f4a <sys_mkdir+0x40>
    80004f28:	4681                	li	a3,0
    80004f2a:	4601                	li	a2,0
    80004f2c:	4585                	li	a1,1
    80004f2e:	f7040513          	addi	a0,s0,-144
    80004f32:	96fff0ef          	jal	800048a0 <create>
    80004f36:	c911                	beqz	a0,80004f4a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f38:	cbcfe0ef          	jal	800033f4 <iunlockput>
  end_op();
    80004f3c:	baffe0ef          	jal	80003aea <end_op>
  return 0;
    80004f40:	4501                	li	a0,0
}
    80004f42:	60aa                	ld	ra,136(sp)
    80004f44:	640a                	ld	s0,128(sp)
    80004f46:	6149                	addi	sp,sp,144
    80004f48:	8082                	ret
    end_op();
    80004f4a:	ba1fe0ef          	jal	80003aea <end_op>
    return -1;
    80004f4e:	557d                	li	a0,-1
    80004f50:	bfcd                	j	80004f42 <sys_mkdir+0x38>

0000000080004f52 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f52:	7135                	addi	sp,sp,-160
    80004f54:	ed06                	sd	ra,152(sp)
    80004f56:	e922                	sd	s0,144(sp)
    80004f58:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f5a:	b27fe0ef          	jal	80003a80 <begin_op>
  argint(1, &major);
    80004f5e:	f6c40593          	addi	a1,s0,-148
    80004f62:	4505                	li	a0,1
    80004f64:	85bfd0ef          	jal	800027be <argint>
  argint(2, &minor);
    80004f68:	f6840593          	addi	a1,s0,-152
    80004f6c:	4509                	li	a0,2
    80004f6e:	851fd0ef          	jal	800027be <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f72:	08000613          	li	a2,128
    80004f76:	f7040593          	addi	a1,s0,-144
    80004f7a:	4501                	li	a0,0
    80004f7c:	87bfd0ef          	jal	800027f6 <argstr>
    80004f80:	02054563          	bltz	a0,80004faa <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f84:	f6841683          	lh	a3,-152(s0)
    80004f88:	f6c41603          	lh	a2,-148(s0)
    80004f8c:	458d                	li	a1,3
    80004f8e:	f7040513          	addi	a0,s0,-144
    80004f92:	90fff0ef          	jal	800048a0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f96:	c911                	beqz	a0,80004faa <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f98:	c5cfe0ef          	jal	800033f4 <iunlockput>
  end_op();
    80004f9c:	b4ffe0ef          	jal	80003aea <end_op>
  return 0;
    80004fa0:	4501                	li	a0,0
}
    80004fa2:	60ea                	ld	ra,152(sp)
    80004fa4:	644a                	ld	s0,144(sp)
    80004fa6:	610d                	addi	sp,sp,160
    80004fa8:	8082                	ret
    end_op();
    80004faa:	b41fe0ef          	jal	80003aea <end_op>
    return -1;
    80004fae:	557d                	li	a0,-1
    80004fb0:	bfcd                	j	80004fa2 <sys_mknod+0x50>

0000000080004fb2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fb2:	7135                	addi	sp,sp,-160
    80004fb4:	ed06                	sd	ra,152(sp)
    80004fb6:	e922                	sd	s0,144(sp)
    80004fb8:	e14a                	sd	s2,128(sp)
    80004fba:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fbc:	94ffc0ef          	jal	8000190a <myproc>
    80004fc0:	892a                	mv	s2,a0
  
  begin_op();
    80004fc2:	abffe0ef          	jal	80003a80 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fc6:	08000613          	li	a2,128
    80004fca:	f6040593          	addi	a1,s0,-160
    80004fce:	4501                	li	a0,0
    80004fd0:	827fd0ef          	jal	800027f6 <argstr>
    80004fd4:	04054363          	bltz	a0,8000501a <sys_chdir+0x68>
    80004fd8:	e526                	sd	s1,136(sp)
    80004fda:	f6040513          	addi	a0,s0,-160
    80004fde:	8e7fe0ef          	jal	800038c4 <namei>
    80004fe2:	84aa                	mv	s1,a0
    80004fe4:	c915                	beqz	a0,80005018 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fe6:	a04fe0ef          	jal	800031ea <ilock>
  if(ip->type != T_DIR){
    80004fea:	04449703          	lh	a4,68(s1)
    80004fee:	4785                	li	a5,1
    80004ff0:	02f71963          	bne	a4,a5,80005022 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	aa2fe0ef          	jal	80003298 <iunlock>
  iput(p->cwd);
    80004ffa:	15093503          	ld	a0,336(s2)
    80004ffe:	b6efe0ef          	jal	8000336c <iput>
  end_op();
    80005002:	ae9fe0ef          	jal	80003aea <end_op>
  p->cwd = ip;
    80005006:	14993823          	sd	s1,336(s2)
  return 0;
    8000500a:	4501                	li	a0,0
    8000500c:	64aa                	ld	s1,136(sp)
}
    8000500e:	60ea                	ld	ra,152(sp)
    80005010:	644a                	ld	s0,144(sp)
    80005012:	690a                	ld	s2,128(sp)
    80005014:	610d                	addi	sp,sp,160
    80005016:	8082                	ret
    80005018:	64aa                	ld	s1,136(sp)
    end_op();
    8000501a:	ad1fe0ef          	jal	80003aea <end_op>
    return -1;
    8000501e:	557d                	li	a0,-1
    80005020:	b7fd                	j	8000500e <sys_chdir+0x5c>
    iunlockput(ip);
    80005022:	8526                	mv	a0,s1
    80005024:	bd0fe0ef          	jal	800033f4 <iunlockput>
    end_op();
    80005028:	ac3fe0ef          	jal	80003aea <end_op>
    return -1;
    8000502c:	557d                	li	a0,-1
    8000502e:	64aa                	ld	s1,136(sp)
    80005030:	bff9                	j	8000500e <sys_chdir+0x5c>

0000000080005032 <sys_exec>:

uint64
sys_exec(void)
{
    80005032:	7121                	addi	sp,sp,-448
    80005034:	ff06                	sd	ra,440(sp)
    80005036:	fb22                	sd	s0,432(sp)
    80005038:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000503a:	e4840593          	addi	a1,s0,-440
    8000503e:	4505                	li	a0,1
    80005040:	f9afd0ef          	jal	800027da <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005044:	08000613          	li	a2,128
    80005048:	f5040593          	addi	a1,s0,-176
    8000504c:	4501                	li	a0,0
    8000504e:	fa8fd0ef          	jal	800027f6 <argstr>
    80005052:	87aa                	mv	a5,a0
    return -1;
    80005054:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005056:	0c07c463          	bltz	a5,8000511e <sys_exec+0xec>
    8000505a:	f726                	sd	s1,424(sp)
    8000505c:	f34a                	sd	s2,416(sp)
    8000505e:	ef4e                	sd	s3,408(sp)
    80005060:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005062:	10000613          	li	a2,256
    80005066:	4581                	li	a1,0
    80005068:	e5040513          	addi	a0,s0,-432
    8000506c:	c5dfb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005070:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005074:	89a6                	mv	s3,s1
    80005076:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005078:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000507c:	00391513          	slli	a0,s2,0x3
    80005080:	e4040593          	addi	a1,s0,-448
    80005084:	e4843783          	ld	a5,-440(s0)
    80005088:	953e                	add	a0,a0,a5
    8000508a:	eaafd0ef          	jal	80002734 <fetchaddr>
    8000508e:	02054663          	bltz	a0,800050ba <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005092:	e4043783          	ld	a5,-448(s0)
    80005096:	c3a9                	beqz	a5,800050d8 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005098:	a8dfb0ef          	jal	80000b24 <kalloc>
    8000509c:	85aa                	mv	a1,a0
    8000509e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050a2:	cd01                	beqz	a0,800050ba <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050a4:	6605                	lui	a2,0x1
    800050a6:	e4043503          	ld	a0,-448(s0)
    800050aa:	ed4fd0ef          	jal	8000277e <fetchstr>
    800050ae:	00054663          	bltz	a0,800050ba <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800050b2:	0905                	addi	s2,s2,1
    800050b4:	09a1                	addi	s3,s3,8
    800050b6:	fd4913e3          	bne	s2,s4,8000507c <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ba:	f5040913          	addi	s2,s0,-176
    800050be:	6088                	ld	a0,0(s1)
    800050c0:	c931                	beqz	a0,80005114 <sys_exec+0xe2>
    kfree(argv[i]);
    800050c2:	981fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c6:	04a1                	addi	s1,s1,8
    800050c8:	ff249be3          	bne	s1,s2,800050be <sys_exec+0x8c>
  return -1;
    800050cc:	557d                	li	a0,-1
    800050ce:	74ba                	ld	s1,424(sp)
    800050d0:	791a                	ld	s2,416(sp)
    800050d2:	69fa                	ld	s3,408(sp)
    800050d4:	6a5a                	ld	s4,400(sp)
    800050d6:	a0a1                	j	8000511e <sys_exec+0xec>
      argv[i] = 0;
    800050d8:	0009079b          	sext.w	a5,s2
    800050dc:	078e                	slli	a5,a5,0x3
    800050de:	fd078793          	addi	a5,a5,-48
    800050e2:	97a2                	add	a5,a5,s0
    800050e4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050e8:	e5040593          	addi	a1,s0,-432
    800050ec:	f5040513          	addi	a0,s0,-176
    800050f0:	ba8ff0ef          	jal	80004498 <exec>
    800050f4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f6:	f5040993          	addi	s3,s0,-176
    800050fa:	6088                	ld	a0,0(s1)
    800050fc:	c511                	beqz	a0,80005108 <sys_exec+0xd6>
    kfree(argv[i]);
    800050fe:	945fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005102:	04a1                	addi	s1,s1,8
    80005104:	ff349be3          	bne	s1,s3,800050fa <sys_exec+0xc8>
  return ret;
    80005108:	854a                	mv	a0,s2
    8000510a:	74ba                	ld	s1,424(sp)
    8000510c:	791a                	ld	s2,416(sp)
    8000510e:	69fa                	ld	s3,408(sp)
    80005110:	6a5a                	ld	s4,400(sp)
    80005112:	a031                	j	8000511e <sys_exec+0xec>
  return -1;
    80005114:	557d                	li	a0,-1
    80005116:	74ba                	ld	s1,424(sp)
    80005118:	791a                	ld	s2,416(sp)
    8000511a:	69fa                	ld	s3,408(sp)
    8000511c:	6a5a                	ld	s4,400(sp)
}
    8000511e:	70fa                	ld	ra,440(sp)
    80005120:	745a                	ld	s0,432(sp)
    80005122:	6139                	addi	sp,sp,448
    80005124:	8082                	ret

0000000080005126 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005126:	7139                	addi	sp,sp,-64
    80005128:	fc06                	sd	ra,56(sp)
    8000512a:	f822                	sd	s0,48(sp)
    8000512c:	f426                	sd	s1,40(sp)
    8000512e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005130:	fdafc0ef          	jal	8000190a <myproc>
    80005134:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005136:	fd840593          	addi	a1,s0,-40
    8000513a:	4501                	li	a0,0
    8000513c:	e9efd0ef          	jal	800027da <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005140:	fc840593          	addi	a1,s0,-56
    80005144:	fd040513          	addi	a0,s0,-48
    80005148:	85cff0ef          	jal	800041a4 <pipealloc>
    return -1;
    8000514c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000514e:	0a054463          	bltz	a0,800051f6 <sys_pipe+0xd0>
  fd0 = -1;
    80005152:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005156:	fd043503          	ld	a0,-48(s0)
    8000515a:	f08ff0ef          	jal	80004862 <fdalloc>
    8000515e:	fca42223          	sw	a0,-60(s0)
    80005162:	08054163          	bltz	a0,800051e4 <sys_pipe+0xbe>
    80005166:	fc843503          	ld	a0,-56(s0)
    8000516a:	ef8ff0ef          	jal	80004862 <fdalloc>
    8000516e:	fca42023          	sw	a0,-64(s0)
    80005172:	06054063          	bltz	a0,800051d2 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005176:	4691                	li	a3,4
    80005178:	fc440613          	addi	a2,s0,-60
    8000517c:	fd843583          	ld	a1,-40(s0)
    80005180:	68a8                	ld	a0,80(s1)
    80005182:	bfafc0ef          	jal	8000157c <copyout>
    80005186:	00054e63          	bltz	a0,800051a2 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000518a:	4691                	li	a3,4
    8000518c:	fc040613          	addi	a2,s0,-64
    80005190:	fd843583          	ld	a1,-40(s0)
    80005194:	0591                	addi	a1,a1,4
    80005196:	68a8                	ld	a0,80(s1)
    80005198:	be4fc0ef          	jal	8000157c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000519c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000519e:	04055c63          	bgez	a0,800051f6 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800051a2:	fc442783          	lw	a5,-60(s0)
    800051a6:	07e9                	addi	a5,a5,26
    800051a8:	078e                	slli	a5,a5,0x3
    800051aa:	97a6                	add	a5,a5,s1
    800051ac:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051b0:	fc042783          	lw	a5,-64(s0)
    800051b4:	07e9                	addi	a5,a5,26
    800051b6:	078e                	slli	a5,a5,0x3
    800051b8:	94be                	add	s1,s1,a5
    800051ba:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051be:	fd043503          	ld	a0,-48(s0)
    800051c2:	cd9fe0ef          	jal	80003e9a <fileclose>
    fileclose(wf);
    800051c6:	fc843503          	ld	a0,-56(s0)
    800051ca:	cd1fe0ef          	jal	80003e9a <fileclose>
    return -1;
    800051ce:	57fd                	li	a5,-1
    800051d0:	a01d                	j	800051f6 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800051d2:	fc442783          	lw	a5,-60(s0)
    800051d6:	0007c763          	bltz	a5,800051e4 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800051da:	07e9                	addi	a5,a5,26
    800051dc:	078e                	slli	a5,a5,0x3
    800051de:	97a6                	add	a5,a5,s1
    800051e0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051e4:	fd043503          	ld	a0,-48(s0)
    800051e8:	cb3fe0ef          	jal	80003e9a <fileclose>
    fileclose(wf);
    800051ec:	fc843503          	ld	a0,-56(s0)
    800051f0:	cabfe0ef          	jal	80003e9a <fileclose>
    return -1;
    800051f4:	57fd                	li	a5,-1
}
    800051f6:	853e                	mv	a0,a5
    800051f8:	70e2                	ld	ra,56(sp)
    800051fa:	7442                	ld	s0,48(sp)
    800051fc:	74a2                	ld	s1,40(sp)
    800051fe:	6121                	addi	sp,sp,64
    80005200:	8082                	ret
	...

0000000080005210 <kernelvec>:
    80005210:	7111                	addi	sp,sp,-256
    80005212:	e006                	sd	ra,0(sp)
    80005214:	e40a                	sd	sp,8(sp)
    80005216:	e80e                	sd	gp,16(sp)
    80005218:	ec12                	sd	tp,24(sp)
    8000521a:	f016                	sd	t0,32(sp)
    8000521c:	f41a                	sd	t1,40(sp)
    8000521e:	f81e                	sd	t2,48(sp)
    80005220:	e4aa                	sd	a0,72(sp)
    80005222:	e8ae                	sd	a1,80(sp)
    80005224:	ecb2                	sd	a2,88(sp)
    80005226:	f0b6                	sd	a3,96(sp)
    80005228:	f4ba                	sd	a4,104(sp)
    8000522a:	f8be                	sd	a5,112(sp)
    8000522c:	fcc2                	sd	a6,120(sp)
    8000522e:	e146                	sd	a7,128(sp)
    80005230:	edf2                	sd	t3,216(sp)
    80005232:	f1f6                	sd	t4,224(sp)
    80005234:	f5fa                	sd	t5,232(sp)
    80005236:	f9fe                	sd	t6,240(sp)
    80005238:	c0cfd0ef          	jal	80002644 <kerneltrap>
    8000523c:	6082                	ld	ra,0(sp)
    8000523e:	6122                	ld	sp,8(sp)
    80005240:	61c2                	ld	gp,16(sp)
    80005242:	7282                	ld	t0,32(sp)
    80005244:	7322                	ld	t1,40(sp)
    80005246:	73c2                	ld	t2,48(sp)
    80005248:	6526                	ld	a0,72(sp)
    8000524a:	65c6                	ld	a1,80(sp)
    8000524c:	6666                	ld	a2,88(sp)
    8000524e:	7686                	ld	a3,96(sp)
    80005250:	7726                	ld	a4,104(sp)
    80005252:	77c6                	ld	a5,112(sp)
    80005254:	7866                	ld	a6,120(sp)
    80005256:	688a                	ld	a7,128(sp)
    80005258:	6e6e                	ld	t3,216(sp)
    8000525a:	7e8e                	ld	t4,224(sp)
    8000525c:	7f2e                	ld	t5,232(sp)
    8000525e:	7fce                	ld	t6,240(sp)
    80005260:	6111                	addi	sp,sp,256
    80005262:	10200073          	sret
	...

000000008000526e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000526e:	1141                	addi	sp,sp,-16
    80005270:	e422                	sd	s0,8(sp)
    80005272:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005274:	0c0007b7          	lui	a5,0xc000
    80005278:	4705                	li	a4,1
    8000527a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000527c:	0c0007b7          	lui	a5,0xc000
    80005280:	c3d8                	sw	a4,4(a5)
}
    80005282:	6422                	ld	s0,8(sp)
    80005284:	0141                	addi	sp,sp,16
    80005286:	8082                	ret

0000000080005288 <plicinithart>:

void
plicinithart(void)
{
    80005288:	1141                	addi	sp,sp,-16
    8000528a:	e406                	sd	ra,8(sp)
    8000528c:	e022                	sd	s0,0(sp)
    8000528e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005290:	e4efc0ef          	jal	800018de <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005294:	0085171b          	slliw	a4,a0,0x8
    80005298:	0c0027b7          	lui	a5,0xc002
    8000529c:	97ba                	add	a5,a5,a4
    8000529e:	40200713          	li	a4,1026
    800052a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052a6:	00d5151b          	slliw	a0,a0,0xd
    800052aa:	0c2017b7          	lui	a5,0xc201
    800052ae:	97aa                	add	a5,a5,a0
    800052b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052bc:	1141                	addi	sp,sp,-16
    800052be:	e406                	sd	ra,8(sp)
    800052c0:	e022                	sd	s0,0(sp)
    800052c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c4:	e1afc0ef          	jal	800018de <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052c8:	00d5151b          	slliw	a0,a0,0xd
    800052cc:	0c2017b7          	lui	a5,0xc201
    800052d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052d2:	43c8                	lw	a0,4(a5)
    800052d4:	60a2                	ld	ra,8(sp)
    800052d6:	6402                	ld	s0,0(sp)
    800052d8:	0141                	addi	sp,sp,16
    800052da:	8082                	ret

00000000800052dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052dc:	1101                	addi	sp,sp,-32
    800052de:	ec06                	sd	ra,24(sp)
    800052e0:	e822                	sd	s0,16(sp)
    800052e2:	e426                	sd	s1,8(sp)
    800052e4:	1000                	addi	s0,sp,32
    800052e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052e8:	df6fc0ef          	jal	800018de <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052ec:	00d5151b          	slliw	a0,a0,0xd
    800052f0:	0c2017b7          	lui	a5,0xc201
    800052f4:	97aa                	add	a5,a5,a0
    800052f6:	c3c4                	sw	s1,4(a5)
}
    800052f8:	60e2                	ld	ra,24(sp)
    800052fa:	6442                	ld	s0,16(sp)
    800052fc:	64a2                	ld	s1,8(sp)
    800052fe:	6105                	addi	sp,sp,32
    80005300:	8082                	ret

0000000080005302 <log_message>:

struct spinlock log_lock;
int log_lock_initialized = 0;

void log_message(log_level_t level, const char *message)
{
    80005302:	1101                	addi	sp,sp,-32
    80005304:	ec06                	sd	ra,24(sp)
    80005306:	e822                	sd	s0,16(sp)
    80005308:	e426                	sd	s1,8(sp)
    8000530a:	e04a                	sd	s2,0(sp)
    8000530c:	1000                	addi	s0,sp,32
    8000530e:	892a                	mv	s2,a0
    80005310:	84ae                	mv	s1,a1
  if (!log_lock_initialized) {
    80005312:	00002797          	auipc	a5,0x2
    80005316:	7427a783          	lw	a5,1858(a5) # 80007a54 <log_lock_initialized>
    8000531a:	c7b5                	beqz	a5,80005386 <log_message+0x84>
    initlock(&log_lock, "log");
    log_lock_initialized = 1;
  }

  acquire(&log_lock);  
    8000531c:	0001c517          	auipc	a0,0x1c
    80005320:	93450513          	addi	a0,a0,-1740 # 80020c50 <log_lock>
    80005324:	8d1fb0ef          	jal	80000bf4 <acquire>

  if (level < LOG_INFO || level > LOG_ERROR) {
    80005328:	4789                	li	a5,2
    8000532a:	0727ee63          	bltu	a5,s2,800053a6 <log_message+0xa4>
    release(&log_lock);
    return;
  }

  const char *prefix = log_level_strings[level];
    8000532e:	02091793          	slli	a5,s2,0x20
    80005332:	01d7d913          	srli	s2,a5,0x1d
    80005336:	00002797          	auipc	a5,0x2
    8000533a:	67a78793          	addi	a5,a5,1658 # 800079b0 <log_level_strings>
    8000533e:	97ca                	add	a5,a5,s2
    80005340:	0007b903          	ld	s2,0(a5)
  while (*prefix)
    80005344:	00094503          	lbu	a0,0(s2)
    80005348:	c519                	beqz	a0,80005356 <log_message+0x54>
    uartputc_sync(*prefix++);  
    8000534a:	0905                	addi	s2,s2,1
    8000534c:	d08fb0ef          	jal	80000854 <uartputc_sync>
  while (*prefix)
    80005350:	00094503          	lbu	a0,0(s2)
    80005354:	f97d                	bnez	a0,8000534a <log_message+0x48>

  while (*message)
    80005356:	0004c503          	lbu	a0,0(s1)
    8000535a:	c519                	beqz	a0,80005368 <log_message+0x66>
    uartputc_sync(*message++);
    8000535c:	0485                	addi	s1,s1,1
    8000535e:	cf6fb0ef          	jal	80000854 <uartputc_sync>
  while (*message)
    80005362:	0004c503          	lbu	a0,0(s1)
    80005366:	f97d                	bnez	a0,8000535c <log_message+0x5a>

  uartputc_sync('\n');
    80005368:	4529                	li	a0,10
    8000536a:	ceafb0ef          	jal	80000854 <uartputc_sync>

  release(&log_lock);
    8000536e:	0001c517          	auipc	a0,0x1c
    80005372:	8e250513          	addi	a0,a0,-1822 # 80020c50 <log_lock>
    80005376:	917fb0ef          	jal	80000c8c <release>
}
    8000537a:	60e2                	ld	ra,24(sp)
    8000537c:	6442                	ld	s0,16(sp)
    8000537e:	64a2                	ld	s1,8(sp)
    80005380:	6902                	ld	s2,0(sp)
    80005382:	6105                	addi	sp,sp,32
    80005384:	8082                	ret
    initlock(&log_lock, "log");
    80005386:	00002597          	auipc	a1,0x2
    8000538a:	2d258593          	addi	a1,a1,722 # 80007658 <etext+0x658>
    8000538e:	0001c517          	auipc	a0,0x1c
    80005392:	8c250513          	addi	a0,a0,-1854 # 80020c50 <log_lock>
    80005396:	fdefb0ef          	jal	80000b74 <initlock>
    log_lock_initialized = 1;
    8000539a:	4785                	li	a5,1
    8000539c:	00002717          	auipc	a4,0x2
    800053a0:	6af72c23          	sw	a5,1720(a4) # 80007a54 <log_lock_initialized>
    800053a4:	bfa5                	j	8000531c <log_message+0x1a>
    release(&log_lock);
    800053a6:	0001c517          	auipc	a0,0x1c
    800053aa:	8aa50513          	addi	a0,a0,-1878 # 80020c50 <log_lock>
    800053ae:	8dffb0ef          	jal	80000c8c <release>
    return;
    800053b2:	b7e1                	j	8000537a <log_message+0x78>

00000000800053b4 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053b4:	1141                	addi	sp,sp,-16
    800053b6:	e406                	sd	ra,8(sp)
    800053b8:	e022                	sd	s0,0(sp)
    800053ba:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053bc:	479d                	li	a5,7
    800053be:	04a7ca63          	blt	a5,a0,80005412 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800053c2:	0001c797          	auipc	a5,0x1c
    800053c6:	8a678793          	addi	a5,a5,-1882 # 80020c68 <disk>
    800053ca:	97aa                	add	a5,a5,a0
    800053cc:	0187c783          	lbu	a5,24(a5)
    800053d0:	e7b9                	bnez	a5,8000541e <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053d2:	00451693          	slli	a3,a0,0x4
    800053d6:	0001c797          	auipc	a5,0x1c
    800053da:	89278793          	addi	a5,a5,-1902 # 80020c68 <disk>
    800053de:	6398                	ld	a4,0(a5)
    800053e0:	9736                	add	a4,a4,a3
    800053e2:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800053e6:	6398                	ld	a4,0(a5)
    800053e8:	9736                	add	a4,a4,a3
    800053ea:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053ee:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053f2:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053f6:	97aa                	add	a5,a5,a0
    800053f8:	4705                	li	a4,1
    800053fa:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053fe:	0001c517          	auipc	a0,0x1c
    80005402:	88250513          	addi	a0,a0,-1918 # 80020c80 <disk+0x18>
    80005406:	b1ffc0ef          	jal	80001f24 <wakeup>
}
    8000540a:	60a2                	ld	ra,8(sp)
    8000540c:	6402                	ld	s0,0(sp)
    8000540e:	0141                	addi	sp,sp,16
    80005410:	8082                	ret
    panic("free_desc 1");
    80005412:	00002517          	auipc	a0,0x2
    80005416:	38e50513          	addi	a0,a0,910 # 800077a0 <etext+0x7a0>
    8000541a:	b7afb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000541e:	00002517          	auipc	a0,0x2
    80005422:	39250513          	addi	a0,a0,914 # 800077b0 <etext+0x7b0>
    80005426:	b6efb0ef          	jal	80000794 <panic>

000000008000542a <virtio_disk_init>:
{
    8000542a:	1101                	addi	sp,sp,-32
    8000542c:	ec06                	sd	ra,24(sp)
    8000542e:	e822                	sd	s0,16(sp)
    80005430:	e426                	sd	s1,8(sp)
    80005432:	e04a                	sd	s2,0(sp)
    80005434:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005436:	00002597          	auipc	a1,0x2
    8000543a:	38a58593          	addi	a1,a1,906 # 800077c0 <etext+0x7c0>
    8000543e:	0001c517          	auipc	a0,0x1c
    80005442:	95250513          	addi	a0,a0,-1710 # 80020d90 <disk+0x128>
    80005446:	f2efb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000544a:	100017b7          	lui	a5,0x10001
    8000544e:	4398                	lw	a4,0(a5)
    80005450:	2701                	sext.w	a4,a4
    80005452:	747277b7          	lui	a5,0x74727
    80005456:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000545a:	18f71063          	bne	a4,a5,800055da <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000545e:	100017b7          	lui	a5,0x10001
    80005462:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005464:	439c                	lw	a5,0(a5)
    80005466:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005468:	4709                	li	a4,2
    8000546a:	16e79863          	bne	a5,a4,800055da <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546e:	100017b7          	lui	a5,0x10001
    80005472:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005474:	439c                	lw	a5,0(a5)
    80005476:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005478:	16e79163          	bne	a5,a4,800055da <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000547c:	100017b7          	lui	a5,0x10001
    80005480:	47d8                	lw	a4,12(a5)
    80005482:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005484:	554d47b7          	lui	a5,0x554d4
    80005488:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000548c:	14f71763          	bne	a4,a5,800055da <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005498:	4705                	li	a4,1
    8000549a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549c:	470d                	li	a4,3
    8000549e:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054a0:	10001737          	lui	a4,0x10001
    800054a4:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054a6:	c7ffe737          	lui	a4,0xc7ffe
    800054aa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd9b7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054ae:	8ef9                	and	a3,a3,a4
    800054b0:	10001737          	lui	a4,0x10001
    800054b4:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b6:	472d                	li	a4,11
    800054b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ba:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800054be:	439c                	lw	a5,0(a5)
    800054c0:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054c4:	8ba1                	andi	a5,a5,8
    800054c6:	12078063          	beqz	a5,800055e6 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054ca:	100017b7          	lui	a5,0x10001
    800054ce:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054d2:	100017b7          	lui	a5,0x10001
    800054d6:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800054da:	439c                	lw	a5,0(a5)
    800054dc:	2781                	sext.w	a5,a5
    800054de:	10079a63          	bnez	a5,800055f2 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054e2:	100017b7          	lui	a5,0x10001
    800054e6:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800054ea:	439c                	lw	a5,0(a5)
    800054ec:	2781                	sext.w	a5,a5
  if(max == 0)
    800054ee:	10078863          	beqz	a5,800055fe <virtio_disk_init+0x1d4>
  if(max < NUM)
    800054f2:	471d                	li	a4,7
    800054f4:	10f77b63          	bgeu	a4,a5,8000560a <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800054f8:	e2cfb0ef          	jal	80000b24 <kalloc>
    800054fc:	0001b497          	auipc	s1,0x1b
    80005500:	76c48493          	addi	s1,s1,1900 # 80020c68 <disk>
    80005504:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005506:	e1efb0ef          	jal	80000b24 <kalloc>
    8000550a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000550c:	e18fb0ef          	jal	80000b24 <kalloc>
    80005510:	87aa                	mv	a5,a0
    80005512:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005514:	6088                	ld	a0,0(s1)
    80005516:	10050063          	beqz	a0,80005616 <virtio_disk_init+0x1ec>
    8000551a:	0001b717          	auipc	a4,0x1b
    8000551e:	75673703          	ld	a4,1878(a4) # 80020c70 <disk+0x8>
    80005522:	0e070a63          	beqz	a4,80005616 <virtio_disk_init+0x1ec>
    80005526:	0e078863          	beqz	a5,80005616 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    8000552a:	6605                	lui	a2,0x1
    8000552c:	4581                	li	a1,0
    8000552e:	f9afb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005532:	0001b497          	auipc	s1,0x1b
    80005536:	73648493          	addi	s1,s1,1846 # 80020c68 <disk>
    8000553a:	6605                	lui	a2,0x1
    8000553c:	4581                	li	a1,0
    8000553e:	6488                	ld	a0,8(s1)
    80005540:	f88fb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005544:	6605                	lui	a2,0x1
    80005546:	4581                	li	a1,0
    80005548:	6888                	ld	a0,16(s1)
    8000554a:	f7efb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000554e:	100017b7          	lui	a5,0x10001
    80005552:	4721                	li	a4,8
    80005554:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005556:	4098                	lw	a4,0(s1)
    80005558:	100017b7          	lui	a5,0x10001
    8000555c:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005560:	40d8                	lw	a4,4(s1)
    80005562:	100017b7          	lui	a5,0x10001
    80005566:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000556a:	649c                	ld	a5,8(s1)
    8000556c:	0007869b          	sext.w	a3,a5
    80005570:	10001737          	lui	a4,0x10001
    80005574:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005578:	9781                	srai	a5,a5,0x20
    8000557a:	10001737          	lui	a4,0x10001
    8000557e:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005582:	689c                	ld	a5,16(s1)
    80005584:	0007869b          	sext.w	a3,a5
    80005588:	10001737          	lui	a4,0x10001
    8000558c:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005590:	9781                	srai	a5,a5,0x20
    80005592:	10001737          	lui	a4,0x10001
    80005596:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000559a:	10001737          	lui	a4,0x10001
    8000559e:	4785                	li	a5,1
    800055a0:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800055a2:	00f48c23          	sb	a5,24(s1)
    800055a6:	00f48ca3          	sb	a5,25(s1)
    800055aa:	00f48d23          	sb	a5,26(s1)
    800055ae:	00f48da3          	sb	a5,27(s1)
    800055b2:	00f48e23          	sb	a5,28(s1)
    800055b6:	00f48ea3          	sb	a5,29(s1)
    800055ba:	00f48f23          	sb	a5,30(s1)
    800055be:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055c2:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c6:	100017b7          	lui	a5,0x10001
    800055ca:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800055ce:	60e2                	ld	ra,24(sp)
    800055d0:	6442                	ld	s0,16(sp)
    800055d2:	64a2                	ld	s1,8(sp)
    800055d4:	6902                	ld	s2,0(sp)
    800055d6:	6105                	addi	sp,sp,32
    800055d8:	8082                	ret
    panic("could not find virtio disk");
    800055da:	00002517          	auipc	a0,0x2
    800055de:	1f650513          	addi	a0,a0,502 # 800077d0 <etext+0x7d0>
    800055e2:	9b2fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055e6:	00002517          	auipc	a0,0x2
    800055ea:	20a50513          	addi	a0,a0,522 # 800077f0 <etext+0x7f0>
    800055ee:	9a6fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    800055f2:	00002517          	auipc	a0,0x2
    800055f6:	21e50513          	addi	a0,a0,542 # 80007810 <etext+0x810>
    800055fa:	99afb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    800055fe:	00002517          	auipc	a0,0x2
    80005602:	23250513          	addi	a0,a0,562 # 80007830 <etext+0x830>
    80005606:	98efb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    8000560a:	00002517          	auipc	a0,0x2
    8000560e:	24650513          	addi	a0,a0,582 # 80007850 <etext+0x850>
    80005612:	982fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005616:	00002517          	auipc	a0,0x2
    8000561a:	25a50513          	addi	a0,a0,602 # 80007870 <etext+0x870>
    8000561e:	976fb0ef          	jal	80000794 <panic>

0000000080005622 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005622:	7159                	addi	sp,sp,-112
    80005624:	f486                	sd	ra,104(sp)
    80005626:	f0a2                	sd	s0,96(sp)
    80005628:	eca6                	sd	s1,88(sp)
    8000562a:	e8ca                	sd	s2,80(sp)
    8000562c:	e4ce                	sd	s3,72(sp)
    8000562e:	e0d2                	sd	s4,64(sp)
    80005630:	fc56                	sd	s5,56(sp)
    80005632:	f85a                	sd	s6,48(sp)
    80005634:	f45e                	sd	s7,40(sp)
    80005636:	f062                	sd	s8,32(sp)
    80005638:	ec66                	sd	s9,24(sp)
    8000563a:	1880                	addi	s0,sp,112
    8000563c:	8a2a                	mv	s4,a0
    8000563e:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005640:	00c52c83          	lw	s9,12(a0)
    80005644:	001c9c9b          	slliw	s9,s9,0x1
    80005648:	1c82                	slli	s9,s9,0x20
    8000564a:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000564e:	0001b517          	auipc	a0,0x1b
    80005652:	74250513          	addi	a0,a0,1858 # 80020d90 <disk+0x128>
    80005656:	d9efb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    8000565a:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000565c:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000565e:	0001bb17          	auipc	s6,0x1b
    80005662:	60ab0b13          	addi	s6,s6,1546 # 80020c68 <disk>
  for(int i = 0; i < 3; i++){
    80005666:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005668:	0001bc17          	auipc	s8,0x1b
    8000566c:	728c0c13          	addi	s8,s8,1832 # 80020d90 <disk+0x128>
    80005670:	a8b9                	j	800056ce <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005672:	00fb0733          	add	a4,s6,a5
    80005676:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    8000567a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000567c:	0207c563          	bltz	a5,800056a6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005680:	2905                	addiw	s2,s2,1
    80005682:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005684:	05590963          	beq	s2,s5,800056d6 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005688:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000568a:	0001b717          	auipc	a4,0x1b
    8000568e:	5de70713          	addi	a4,a4,1502 # 80020c68 <disk>
    80005692:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005694:	01874683          	lbu	a3,24(a4)
    80005698:	fee9                	bnez	a3,80005672 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    8000569a:	2785                	addiw	a5,a5,1
    8000569c:	0705                	addi	a4,a4,1
    8000569e:	fe979be3          	bne	a5,s1,80005694 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800056a2:	57fd                	li	a5,-1
    800056a4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056a6:	01205d63          	blez	s2,800056c0 <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800056aa:	f9042503          	lw	a0,-112(s0)
    800056ae:	d07ff0ef          	jal	800053b4 <free_desc>
      for(int j = 0; j < i; j++)
    800056b2:	4785                	li	a5,1
    800056b4:	0127d663          	bge	a5,s2,800056c0 <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800056b8:	f9442503          	lw	a0,-108(s0)
    800056bc:	cf9ff0ef          	jal	800053b4 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056c0:	85e2                	mv	a1,s8
    800056c2:	0001b517          	auipc	a0,0x1b
    800056c6:	5be50513          	addi	a0,a0,1470 # 80020c80 <disk+0x18>
    800056ca:	80ffc0ef          	jal	80001ed8 <sleep>
  for(int i = 0; i < 3; i++){
    800056ce:	f9040613          	addi	a2,s0,-112
    800056d2:	894e                	mv	s2,s3
    800056d4:	bf55                	j	80005688 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056d6:	f9042503          	lw	a0,-112(s0)
    800056da:	00451693          	slli	a3,a0,0x4

  if(write)
    800056de:	0001b797          	auipc	a5,0x1b
    800056e2:	58a78793          	addi	a5,a5,1418 # 80020c68 <disk>
    800056e6:	00a50713          	addi	a4,a0,10
    800056ea:	0712                	slli	a4,a4,0x4
    800056ec:	973e                	add	a4,a4,a5
    800056ee:	01703633          	snez	a2,s7
    800056f2:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056f4:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800056f8:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056fc:	6398                	ld	a4,0(a5)
    800056fe:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005700:	0a868613          	addi	a2,a3,168
    80005704:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005706:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005708:	6390                	ld	a2,0(a5)
    8000570a:	00d605b3          	add	a1,a2,a3
    8000570e:	4741                	li	a4,16
    80005710:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005712:	4805                	li	a6,1
    80005714:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005718:	f9442703          	lw	a4,-108(s0)
    8000571c:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005720:	0712                	slli	a4,a4,0x4
    80005722:	963a                	add	a2,a2,a4
    80005724:	058a0593          	addi	a1,s4,88
    80005728:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000572a:	0007b883          	ld	a7,0(a5)
    8000572e:	9746                	add	a4,a4,a7
    80005730:	40000613          	li	a2,1024
    80005734:	c710                	sw	a2,8(a4)
  if(write)
    80005736:	001bb613          	seqz	a2,s7
    8000573a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000573e:	00166613          	ori	a2,a2,1
    80005742:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005746:	f9842583          	lw	a1,-104(s0)
    8000574a:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000574e:	00250613          	addi	a2,a0,2
    80005752:	0612                	slli	a2,a2,0x4
    80005754:	963e                	add	a2,a2,a5
    80005756:	577d                	li	a4,-1
    80005758:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000575c:	0592                	slli	a1,a1,0x4
    8000575e:	98ae                	add	a7,a7,a1
    80005760:	03068713          	addi	a4,a3,48
    80005764:	973e                	add	a4,a4,a5
    80005766:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000576a:	6398                	ld	a4,0(a5)
    8000576c:	972e                	add	a4,a4,a1
    8000576e:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005772:	4689                	li	a3,2
    80005774:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005778:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000577c:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005780:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005784:	6794                	ld	a3,8(a5)
    80005786:	0026d703          	lhu	a4,2(a3)
    8000578a:	8b1d                	andi	a4,a4,7
    8000578c:	0706                	slli	a4,a4,0x1
    8000578e:	96ba                	add	a3,a3,a4
    80005790:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005794:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005798:	6798                	ld	a4,8(a5)
    8000579a:	00275783          	lhu	a5,2(a4)
    8000579e:	2785                	addiw	a5,a5,1
    800057a0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057a4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057a8:	100017b7          	lui	a5,0x10001
    800057ac:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057b0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057b4:	0001b917          	auipc	s2,0x1b
    800057b8:	5dc90913          	addi	s2,s2,1500 # 80020d90 <disk+0x128>
  while(b->disk == 1) {
    800057bc:	4485                	li	s1,1
    800057be:	01079a63          	bne	a5,a6,800057d2 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800057c2:	85ca                	mv	a1,s2
    800057c4:	8552                	mv	a0,s4
    800057c6:	f12fc0ef          	jal	80001ed8 <sleep>
  while(b->disk == 1) {
    800057ca:	004a2783          	lw	a5,4(s4)
    800057ce:	fe978ae3          	beq	a5,s1,800057c2 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800057d2:	f9042903          	lw	s2,-112(s0)
    800057d6:	00290713          	addi	a4,s2,2
    800057da:	0712                	slli	a4,a4,0x4
    800057dc:	0001b797          	auipc	a5,0x1b
    800057e0:	48c78793          	addi	a5,a5,1164 # 80020c68 <disk>
    800057e4:	97ba                	add	a5,a5,a4
    800057e6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057ea:	0001b997          	auipc	s3,0x1b
    800057ee:	47e98993          	addi	s3,s3,1150 # 80020c68 <disk>
    800057f2:	00491713          	slli	a4,s2,0x4
    800057f6:	0009b783          	ld	a5,0(s3)
    800057fa:	97ba                	add	a5,a5,a4
    800057fc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005800:	854a                	mv	a0,s2
    80005802:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005806:	bafff0ef          	jal	800053b4 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000580a:	8885                	andi	s1,s1,1
    8000580c:	f0fd                	bnez	s1,800057f2 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000580e:	0001b517          	auipc	a0,0x1b
    80005812:	58250513          	addi	a0,a0,1410 # 80020d90 <disk+0x128>
    80005816:	c76fb0ef          	jal	80000c8c <release>
}
    8000581a:	70a6                	ld	ra,104(sp)
    8000581c:	7406                	ld	s0,96(sp)
    8000581e:	64e6                	ld	s1,88(sp)
    80005820:	6946                	ld	s2,80(sp)
    80005822:	69a6                	ld	s3,72(sp)
    80005824:	6a06                	ld	s4,64(sp)
    80005826:	7ae2                	ld	s5,56(sp)
    80005828:	7b42                	ld	s6,48(sp)
    8000582a:	7ba2                	ld	s7,40(sp)
    8000582c:	7c02                	ld	s8,32(sp)
    8000582e:	6ce2                	ld	s9,24(sp)
    80005830:	6165                	addi	sp,sp,112
    80005832:	8082                	ret

0000000080005834 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005834:	1101                	addi	sp,sp,-32
    80005836:	ec06                	sd	ra,24(sp)
    80005838:	e822                	sd	s0,16(sp)
    8000583a:	e426                	sd	s1,8(sp)
    8000583c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000583e:	0001b497          	auipc	s1,0x1b
    80005842:	42a48493          	addi	s1,s1,1066 # 80020c68 <disk>
    80005846:	0001b517          	auipc	a0,0x1b
    8000584a:	54a50513          	addi	a0,a0,1354 # 80020d90 <disk+0x128>
    8000584e:	ba6fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005852:	100017b7          	lui	a5,0x10001
    80005856:	53b8                	lw	a4,96(a5)
    80005858:	8b0d                	andi	a4,a4,3
    8000585a:	100017b7          	lui	a5,0x10001
    8000585e:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005860:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005864:	689c                	ld	a5,16(s1)
    80005866:	0204d703          	lhu	a4,32(s1)
    8000586a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000586e:	04f70663          	beq	a4,a5,800058ba <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005872:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005876:	6898                	ld	a4,16(s1)
    80005878:	0204d783          	lhu	a5,32(s1)
    8000587c:	8b9d                	andi	a5,a5,7
    8000587e:	078e                	slli	a5,a5,0x3
    80005880:	97ba                	add	a5,a5,a4
    80005882:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005884:	00278713          	addi	a4,a5,2
    80005888:	0712                	slli	a4,a4,0x4
    8000588a:	9726                	add	a4,a4,s1
    8000588c:	01074703          	lbu	a4,16(a4)
    80005890:	e321                	bnez	a4,800058d0 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005892:	0789                	addi	a5,a5,2
    80005894:	0792                	slli	a5,a5,0x4
    80005896:	97a6                	add	a5,a5,s1
    80005898:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000589a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000589e:	e86fc0ef          	jal	80001f24 <wakeup>

    disk.used_idx += 1;
    800058a2:	0204d783          	lhu	a5,32(s1)
    800058a6:	2785                	addiw	a5,a5,1
    800058a8:	17c2                	slli	a5,a5,0x30
    800058aa:	93c1                	srli	a5,a5,0x30
    800058ac:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058b0:	6898                	ld	a4,16(s1)
    800058b2:	00275703          	lhu	a4,2(a4)
    800058b6:	faf71ee3          	bne	a4,a5,80005872 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058ba:	0001b517          	auipc	a0,0x1b
    800058be:	4d650513          	addi	a0,a0,1238 # 80020d90 <disk+0x128>
    800058c2:	bcafb0ef          	jal	80000c8c <release>
}
    800058c6:	60e2                	ld	ra,24(sp)
    800058c8:	6442                	ld	s0,16(sp)
    800058ca:	64a2                	ld	s1,8(sp)
    800058cc:	6105                	addi	sp,sp,32
    800058ce:	8082                	ret
      panic("virtio_disk_intr status");
    800058d0:	00002517          	auipc	a0,0x2
    800058d4:	fb850513          	addi	a0,a0,-72 # 80007888 <etext+0x888>
    800058d8:	ebdfa0ef          	jal	80000794 <panic>
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
