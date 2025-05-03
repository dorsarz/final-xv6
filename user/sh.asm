
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  }
  exit(0);
}

int getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$parnian-dorsa ", 14);
      10:	4639                	li	a2,14
      12:	00001597          	auipc	a1,0x1
      16:	3ee58593          	addi	a1,a1,1006 # 1400 <malloc+0x106>
      1a:	4509                	li	a0,2
      1c:	633000ef          	jal	e4e <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	423000ef          	jal	c48 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	461000ef          	jal	c8e <gets>
  if (buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  }
  exit(0);
}

void panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	3bc58593          	addi	a1,a1,956 # 1410 <malloc+0x116>
      5c:	4509                	li	a0,2
      5e:	1be010ef          	jal	121c <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	5cb000ef          	jal	e2e <exit>

0000000000000068 <fork1>:
}

int fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	5b7000ef          	jal	e26 <fork>
  if (pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	39e50513          	addi	a0,a0,926 # 1420 <malloc+0x126>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	b9010113          	addi	sp,sp,-1136
      92:	46113423          	sd	ra,1128(sp)
      96:	46813023          	sd	s0,1120(sp)
      9a:	47010413          	addi	s0,sp,1136
  if (cmd == 0)
      9e:	c90d                	beqz	a0,d0 <runcmd+0x42>
      a0:	44913c23          	sd	s1,1112(sp)
      a4:	45213823          	sd	s2,1104(sp)
      a8:	45313423          	sd	s3,1096(sp)
      ac:	45413023          	sd	s4,1088(sp)
      b0:	84aa                	mv	s1,a0
  switch (cmd->type)
      b2:	00052903          	lw	s2,0(a0)
      b6:	4795                	li	a5,5
      b8:	0527e163          	bltu	a5,s2,fa <runcmd+0x6c>
      bc:	00291793          	slli	a5,s2,0x2
      c0:	00001717          	auipc	a4,0x1
      c4:	4a070713          	addi	a4,a4,1184 # 1560 <malloc+0x266>
      c8:	97ba                	add	a5,a5,a4
      ca:	439c                	lw	a5,0(a5)
      cc:	97ba                	add	a5,a5,a4
      ce:	8782                	jr	a5
      d0:	44913c23          	sd	s1,1112(sp)
      d4:	45213823          	sd	s2,1104(sp)
      d8:	45313423          	sd	s3,1096(sp)
      dc:	45413023          	sd	s4,1088(sp)
      e0:	43513c23          	sd	s5,1080(sp)
      e4:	43613823          	sd	s6,1072(sp)
      e8:	43713423          	sd	s7,1064(sp)
      ec:	43813023          	sd	s8,1056(sp)
      f0:	41913c23          	sd	s9,1048(sp)
    exit(1);
      f4:	4505                	li	a0,1
      f6:	539000ef          	jal	e2e <exit>
      fa:	43513c23          	sd	s5,1080(sp)
      fe:	43613823          	sd	s6,1072(sp)
     102:	43713423          	sd	s7,1064(sp)
     106:	43813023          	sd	s8,1056(sp)
     10a:	41913c23          	sd	s9,1048(sp)
    panic("runcmd");
     10e:	00001517          	auipc	a0,0x1
     112:	31a50513          	addi	a0,a0,794 # 1428 <malloc+0x12e>
     116:	f35ff0ef          	jal	4a <panic>
    if (ecmd->argv[0] == 0)
     11a:	00853983          	ld	s3,8(a0)
     11e:	04098863          	beqz	s3,16e <runcmd+0xe0>
    if (ecmd->argv[0] && strcmp(ecmd->argv[0], "!") == 0) {
     122:	00001597          	auipc	a1,0x1
     126:	30e58593          	addi	a1,a1,782 # 1430 <malloc+0x136>
     12a:	854e                	mv	a0,s3
     12c:	2c7000ef          	jal	bf2 <strcmp>
     130:	8a2a                	mv	s4,a0
     132:	12051263          	bnez	a0,256 <runcmd+0x1c8>
     136:	43513c23          	sd	s5,1080(sp)
     13a:	43613823          	sd	s6,1072(sp)
     13e:	43713423          	sd	s7,1064(sp)
     142:	43813023          	sd	s8,1056(sp)
     146:	41913c23          	sd	s9,1048(sp)
        char buf[1024] = {0};
     14a:	40000613          	li	a2,1024
     14e:	4581                	li	a1,0
     150:	b9840513          	addi	a0,s0,-1128
     154:	2f5000ef          	jal	c48 <memset>
        for (int i = 1; ecmd->argv[i] != 0; i++) {
     158:	6888                	ld	a0,16(s1)
     15a:	0e050563          	beqz	a0,244 <runcmd+0x1b6>
     15e:	04c1                	addi	s1,s1,16
        int len = 0;
     160:	8ad2                	mv	s5,s4
            if (len + arglen >= sizeof(buf)) {
     162:	3ff00b13          	li	s6,1023
            if (i > 1)
     166:	4b85                	li	s7,1
                buf[len++] = ' ';
     168:	02000c13          	li	s8,32
     16c:	a03d                	j	19a <runcmd+0x10c>
     16e:	43513c23          	sd	s5,1080(sp)
     172:	43613823          	sd	s6,1072(sp)
     176:	43713423          	sd	s7,1064(sp)
     17a:	43813023          	sd	s8,1056(sp)
     17e:	41913c23          	sd	s9,1048(sp)
        exit(1);
     182:	4505                	li	a0,1
     184:	4ab000ef          	jal	e2e <exit>
                buf[len++] = ' ';
     188:	fa0c8793          	addi	a5,s9,-96
     18c:	00878cb3          	add	s9,a5,s0
     190:	bf8c8c23          	sb	s8,-1032(s9)
     194:	00198c9b          	addiw	s9,s3,1
     198:	8ae6                	mv	s5,s9
            int arglen = strlen(ecmd->argv[i]);
     19a:	285000ef          	jal	c1e <strlen>
            if (len + arglen >= sizeof(buf)) {
     19e:	015509bb          	addw	s3,a0,s5
     1a2:	00098c9b          	sext.w	s9,s3
     1a6:	039b6063          	bltu	s6,s9,1c6 <runcmd+0x138>
            strcpy(buf + len, ecmd->argv[i]);
     1aa:	608c                	ld	a1,0(s1)
     1ac:	b9840793          	addi	a5,s0,-1128
     1b0:	01578533          	add	a0,a5,s5
     1b4:	223000ef          	jal	bd6 <strcpy>
        for (int i = 1; ecmd->argv[i] != 0; i++) {
     1b8:	2905                	addiw	s2,s2,1
     1ba:	04a1                	addi	s1,s1,8
     1bc:	6088                	ld	a0,0(s1)
     1be:	cd09                	beqz	a0,1d8 <runcmd+0x14a>
            if (i > 1)
     1c0:	fd2bc4e3          	blt	s7,s2,188 <runcmd+0xfa>
     1c4:	bfd1                	j	198 <runcmd+0x10a>
                printf("Message too long\n");
     1c6:	00001517          	auipc	a0,0x1
     1ca:	27250513          	addi	a0,a0,626 # 1438 <malloc+0x13e>
     1ce:	078010ef          	jal	1246 <printf>
                exit(1);
     1d2:	4505                	li	a0,1
     1d4:	45b000ef          	jal	e2e <exit>
                printf("%c", buf[i]);
     1d8:	00001917          	auipc	s2,0x1
     1dc:	29090913          	addi	s2,s2,656 # 1468 <malloc+0x16e>
            if (i + 1 < len && buf[i] == 'o' && buf[i+1] == 's') {
     1e0:	06f00993          	li	s3,111
     1e4:	07300a93          	li	s5,115
     1e8:	a819                	j	1fe <runcmd+0x170>
                printf("%c", buf[i]);
     1ea:	fa0a0793          	addi	a5,s4,-96
     1ee:	00878a33          	add	s4,a5,s0
     1f2:	bf8a4583          	lbu	a1,-1032(s4)
     1f6:	854a                	mv	a0,s2
     1f8:	04e010ef          	jal	1246 <printf>
        int len = 0;
     1fc:	8a26                	mv	s4,s1
        for (int i = 0; i < len; ) {
     1fe:	059a5363          	bge	s4,s9,244 <runcmd+0x1b6>
            if (i + 1 < len && buf[i] == 'o' && buf[i+1] == 's') {
     202:	001a049b          	addiw	s1,s4,1
     206:	ff94d2e3          	bge	s1,s9,1ea <runcmd+0x15c>
     20a:	fa0a0793          	addi	a5,s4,-96
     20e:	97a2                	add	a5,a5,s0
     210:	bf87c783          	lbu	a5,-1032(a5)
     214:	fd379be3          	bne	a5,s3,1ea <runcmd+0x15c>
     218:	fa048793          	addi	a5,s1,-96
     21c:	97a2                	add	a5,a5,s0
     21e:	bf87c783          	lbu	a5,-1032(a5)
     222:	fd5794e3          	bne	a5,s5,1ea <runcmd+0x15c>
                printf("%c[34m%s%c[0m", 27, "os", 27);
     226:	46ed                	li	a3,27
     228:	00001617          	auipc	a2,0x1
     22c:	22860613          	addi	a2,a2,552 # 1450 <malloc+0x156>
     230:	45ed                	li	a1,27
     232:	00001517          	auipc	a0,0x1
     236:	22650513          	addi	a0,a0,550 # 1458 <malloc+0x15e>
     23a:	00c010ef          	jal	1246 <printf>
                i += 2;
     23e:	002a049b          	addiw	s1,s4,2
     242:	bf6d                	j	1fc <runcmd+0x16e>
        printf("\n");
     244:	00001517          	auipc	a0,0x1
     248:	20450513          	addi	a0,a0,516 # 1448 <malloc+0x14e>
     24c:	7fb000ef          	jal	1246 <printf>
        exit(0);
     250:	4501                	li	a0,0
     252:	3dd000ef          	jal	e2e <exit>
    exec(ecmd->argv[0], ecmd->argv);
     256:	00848593          	addi	a1,s1,8
     25a:	854e                	mv	a0,s3
     25c:	40b000ef          	jal	e66 <exec>
    printf("exec %s failed\n", ecmd->argv[0]);
     260:	648c                	ld	a1,8(s1)
     262:	00001517          	auipc	a0,0x1
     266:	20e50513          	addi	a0,a0,526 # 1470 <malloc+0x176>
     26a:	7dd000ef          	jal	1246 <printf>
    break;
     26e:	a28d                	j	3d0 <runcmd+0x342>
    close(rcmd->fd);
     270:	5148                	lw	a0,36(a0)
     272:	3e5000ef          	jal	e56 <close>
    if (open(rcmd->file, rcmd->mode) < 0)
     276:	508c                	lw	a1,32(s1)
     278:	6888                	ld	a0,16(s1)
     27a:	3f5000ef          	jal	e6e <open>
     27e:	00054f63          	bltz	a0,29c <runcmd+0x20e>
     282:	43513c23          	sd	s5,1080(sp)
     286:	43613823          	sd	s6,1072(sp)
     28a:	43713423          	sd	s7,1064(sp)
     28e:	43813023          	sd	s8,1056(sp)
     292:	41913c23          	sd	s9,1048(sp)
    runcmd(rcmd->cmd);
     296:	6488                	ld	a0,8(s1)
     298:	df7ff0ef          	jal	8e <runcmd>
     29c:	43513c23          	sd	s5,1080(sp)
     2a0:	43613823          	sd	s6,1072(sp)
     2a4:	43713423          	sd	s7,1064(sp)
     2a8:	43813023          	sd	s8,1056(sp)
     2ac:	41913c23          	sd	s9,1048(sp)
      fprintf(2, "open %s failed\n", rcmd->file);
     2b0:	6890                	ld	a2,16(s1)
     2b2:	00001597          	auipc	a1,0x1
     2b6:	1ce58593          	addi	a1,a1,462 # 1480 <malloc+0x186>
     2ba:	4509                	li	a0,2
     2bc:	761000ef          	jal	121c <fprintf>
      exit(1);
     2c0:	4505                	li	a0,1
     2c2:	36d000ef          	jal	e2e <exit>
    if (fork1() == 0)
     2c6:	da3ff0ef          	jal	68 <fork1>
     2ca:	ed11                	bnez	a0,2e6 <runcmd+0x258>
     2cc:	43513c23          	sd	s5,1080(sp)
     2d0:	43613823          	sd	s6,1072(sp)
     2d4:	43713423          	sd	s7,1064(sp)
     2d8:	43813023          	sd	s8,1056(sp)
     2dc:	41913c23          	sd	s9,1048(sp)
      runcmd(lcmd->left);
     2e0:	6488                	ld	a0,8(s1)
     2e2:	dadff0ef          	jal	8e <runcmd>
     2e6:	43513c23          	sd	s5,1080(sp)
     2ea:	43613823          	sd	s6,1072(sp)
     2ee:	43713423          	sd	s7,1064(sp)
     2f2:	43813023          	sd	s8,1056(sp)
     2f6:	41913c23          	sd	s9,1048(sp)
    wait(0);
     2fa:	4501                	li	a0,0
     2fc:	33b000ef          	jal	e36 <wait>
    runcmd(lcmd->right);
     300:	6888                	ld	a0,16(s1)
     302:	d8dff0ef          	jal	8e <runcmd>
    if (pipe(p) < 0)
     306:	f9840513          	addi	a0,s0,-104
     30a:	335000ef          	jal	e3e <pipe>
     30e:	04054163          	bltz	a0,350 <runcmd+0x2c2>
    if (fork1() == 0)
     312:	d57ff0ef          	jal	68 <fork1>
     316:	ed29                	bnez	a0,370 <runcmd+0x2e2>
     318:	43513c23          	sd	s5,1080(sp)
     31c:	43613823          	sd	s6,1072(sp)
     320:	43713423          	sd	s7,1064(sp)
     324:	43813023          	sd	s8,1056(sp)
     328:	41913c23          	sd	s9,1048(sp)
      close(1);
     32c:	4505                	li	a0,1
     32e:	329000ef          	jal	e56 <close>
      dup(p[1]);
     332:	f9c42503          	lw	a0,-100(s0)
     336:	371000ef          	jal	ea6 <dup>
      close(p[0]);
     33a:	f9842503          	lw	a0,-104(s0)
     33e:	319000ef          	jal	e56 <close>
      close(p[1]);
     342:	f9c42503          	lw	a0,-100(s0)
     346:	311000ef          	jal	e56 <close>
      runcmd(pcmd->left);
     34a:	6488                	ld	a0,8(s1)
     34c:	d43ff0ef          	jal	8e <runcmd>
     350:	43513c23          	sd	s5,1080(sp)
     354:	43613823          	sd	s6,1072(sp)
     358:	43713423          	sd	s7,1064(sp)
     35c:	43813023          	sd	s8,1056(sp)
     360:	41913c23          	sd	s9,1048(sp)
      panic("pipe");
     364:	00001517          	auipc	a0,0x1
     368:	12c50513          	addi	a0,a0,300 # 1490 <malloc+0x196>
     36c:	cdfff0ef          	jal	4a <panic>
    if (fork1() == 0)
     370:	cf9ff0ef          	jal	68 <fork1>
     374:	ed05                	bnez	a0,3ac <runcmd+0x31e>
     376:	43513c23          	sd	s5,1080(sp)
     37a:	43613823          	sd	s6,1072(sp)
     37e:	43713423          	sd	s7,1064(sp)
     382:	43813023          	sd	s8,1056(sp)
     386:	41913c23          	sd	s9,1048(sp)
      close(0);
     38a:	2cd000ef          	jal	e56 <close>
      dup(p[0]);
     38e:	f9842503          	lw	a0,-104(s0)
     392:	315000ef          	jal	ea6 <dup>
      close(p[0]);
     396:	f9842503          	lw	a0,-104(s0)
     39a:	2bd000ef          	jal	e56 <close>
      close(p[1]);
     39e:	f9c42503          	lw	a0,-100(s0)
     3a2:	2b5000ef          	jal	e56 <close>
      runcmd(pcmd->right);
     3a6:	6888                	ld	a0,16(s1)
     3a8:	ce7ff0ef          	jal	8e <runcmd>
    close(p[0]);
     3ac:	f9842503          	lw	a0,-104(s0)
     3b0:	2a7000ef          	jal	e56 <close>
    close(p[1]);
     3b4:	f9c42503          	lw	a0,-100(s0)
     3b8:	29f000ef          	jal	e56 <close>
    wait(0);
     3bc:	4501                	li	a0,0
     3be:	279000ef          	jal	e36 <wait>
    wait(0);
     3c2:	4501                	li	a0,0
     3c4:	273000ef          	jal	e36 <wait>
    break;
     3c8:	a021                	j	3d0 <runcmd+0x342>
    if (fork1() == 0)
     3ca:	c9fff0ef          	jal	68 <fork1>
     3ce:	cd11                	beqz	a0,3ea <runcmd+0x35c>
     3d0:	43513c23          	sd	s5,1080(sp)
     3d4:	43613823          	sd	s6,1072(sp)
     3d8:	43713423          	sd	s7,1064(sp)
     3dc:	43813023          	sd	s8,1056(sp)
     3e0:	41913c23          	sd	s9,1048(sp)
  exit(0);
     3e4:	4501                	li	a0,0
     3e6:	249000ef          	jal	e2e <exit>
     3ea:	43513c23          	sd	s5,1080(sp)
     3ee:	43613823          	sd	s6,1072(sp)
     3f2:	43713423          	sd	s7,1064(sp)
     3f6:	43813023          	sd	s8,1056(sp)
     3fa:	41913c23          	sd	s9,1048(sp)
      runcmd(bcmd->cmd);
     3fe:	6488                	ld	a0,8(s1)
     400:	c8fff0ef          	jal	8e <runcmd>

0000000000000404 <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     404:	1101                	addi	sp,sp,-32
     406:	ec06                	sd	ra,24(sp)
     408:	e822                	sd	s0,16(sp)
     40a:	e426                	sd	s1,8(sp)
     40c:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     40e:	0a800513          	li	a0,168
     412:	6e9000ef          	jal	12fa <malloc>
     416:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     418:	0a800613          	li	a2,168
     41c:	4581                	li	a1,0
     41e:	02b000ef          	jal	c48 <memset>
  cmd->type = EXEC;
     422:	4785                	li	a5,1
     424:	c09c                	sw	a5,0(s1)
  return (struct cmd *)cmd;
}
     426:	8526                	mv	a0,s1
     428:	60e2                	ld	ra,24(sp)
     42a:	6442                	ld	s0,16(sp)
     42c:	64a2                	ld	s1,8(sp)
     42e:	6105                	addi	sp,sp,32
     430:	8082                	ret

0000000000000432 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     432:	7139                	addi	sp,sp,-64
     434:	fc06                	sd	ra,56(sp)
     436:	f822                	sd	s0,48(sp)
     438:	f426                	sd	s1,40(sp)
     43a:	f04a                	sd	s2,32(sp)
     43c:	ec4e                	sd	s3,24(sp)
     43e:	e852                	sd	s4,16(sp)
     440:	e456                	sd	s5,8(sp)
     442:	e05a                	sd	s6,0(sp)
     444:	0080                	addi	s0,sp,64
     446:	8b2a                	mv	s6,a0
     448:	8aae                	mv	s5,a1
     44a:	8a32                	mv	s4,a2
     44c:	89b6                	mv	s3,a3
     44e:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     450:	02800513          	li	a0,40
     454:	6a7000ef          	jal	12fa <malloc>
     458:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     45a:	02800613          	li	a2,40
     45e:	4581                	li	a1,0
     460:	7e8000ef          	jal	c48 <memset>
  cmd->type = REDIR;
     464:	4789                	li	a5,2
     466:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     468:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     46c:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     470:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     474:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     478:	0324a223          	sw	s2,36(s1)
  return (struct cmd *)cmd;
}
     47c:	8526                	mv	a0,s1
     47e:	70e2                	ld	ra,56(sp)
     480:	7442                	ld	s0,48(sp)
     482:	74a2                	ld	s1,40(sp)
     484:	7902                	ld	s2,32(sp)
     486:	69e2                	ld	s3,24(sp)
     488:	6a42                	ld	s4,16(sp)
     48a:	6aa2                	ld	s5,8(sp)
     48c:	6b02                	ld	s6,0(sp)
     48e:	6121                	addi	sp,sp,64
     490:	8082                	ret

0000000000000492 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     492:	7179                	addi	sp,sp,-48
     494:	f406                	sd	ra,40(sp)
     496:	f022                	sd	s0,32(sp)
     498:	ec26                	sd	s1,24(sp)
     49a:	e84a                	sd	s2,16(sp)
     49c:	e44e                	sd	s3,8(sp)
     49e:	1800                	addi	s0,sp,48
     4a0:	89aa                	mv	s3,a0
     4a2:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a4:	4561                	li	a0,24
     4a6:	655000ef          	jal	12fa <malloc>
     4aa:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4ac:	4661                	li	a2,24
     4ae:	4581                	li	a1,0
     4b0:	798000ef          	jal	c48 <memset>
  cmd->type = PIPE;
     4b4:	478d                	li	a5,3
     4b6:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4b8:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4bc:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     4c0:	8526                	mv	a0,s1
     4c2:	70a2                	ld	ra,40(sp)
     4c4:	7402                	ld	s0,32(sp)
     4c6:	64e2                	ld	s1,24(sp)
     4c8:	6942                	ld	s2,16(sp)
     4ca:	69a2                	ld	s3,8(sp)
     4cc:	6145                	addi	sp,sp,48
     4ce:	8082                	ret

00000000000004d0 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     4d0:	7179                	addi	sp,sp,-48
     4d2:	f406                	sd	ra,40(sp)
     4d4:	f022                	sd	s0,32(sp)
     4d6:	ec26                	sd	s1,24(sp)
     4d8:	e84a                	sd	s2,16(sp)
     4da:	e44e                	sd	s3,8(sp)
     4dc:	1800                	addi	s0,sp,48
     4de:	89aa                	mv	s3,a0
     4e0:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4e2:	4561                	li	a0,24
     4e4:	617000ef          	jal	12fa <malloc>
     4e8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4ea:	4661                	li	a2,24
     4ec:	4581                	li	a1,0
     4ee:	75a000ef          	jal	c48 <memset>
  cmd->type = LIST;
     4f2:	4791                	li	a5,4
     4f4:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4f6:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4fa:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     4fe:	8526                	mv	a0,s1
     500:	70a2                	ld	ra,40(sp)
     502:	7402                	ld	s0,32(sp)
     504:	64e2                	ld	s1,24(sp)
     506:	6942                	ld	s2,16(sp)
     508:	69a2                	ld	s3,8(sp)
     50a:	6145                	addi	sp,sp,48
     50c:	8082                	ret

000000000000050e <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     50e:	1101                	addi	sp,sp,-32
     510:	ec06                	sd	ra,24(sp)
     512:	e822                	sd	s0,16(sp)
     514:	e426                	sd	s1,8(sp)
     516:	e04a                	sd	s2,0(sp)
     518:	1000                	addi	s0,sp,32
     51a:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     51c:	4541                	li	a0,16
     51e:	5dd000ef          	jal	12fa <malloc>
     522:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     524:	4641                	li	a2,16
     526:	4581                	li	a1,0
     528:	720000ef          	jal	c48 <memset>
  cmd->type = BACK;
     52c:	4795                	li	a5,5
     52e:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     530:	0124b423          	sd	s2,8(s1)
  return (struct cmd *)cmd;
}
     534:	8526                	mv	a0,s1
     536:	60e2                	ld	ra,24(sp)
     538:	6442                	ld	s0,16(sp)
     53a:	64a2                	ld	s1,8(sp)
     53c:	6902                	ld	s2,0(sp)
     53e:	6105                	addi	sp,sp,32
     540:	8082                	ret

0000000000000542 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     542:	7139                	addi	sp,sp,-64
     544:	fc06                	sd	ra,56(sp)
     546:	f822                	sd	s0,48(sp)
     548:	f426                	sd	s1,40(sp)
     54a:	f04a                	sd	s2,32(sp)
     54c:	ec4e                	sd	s3,24(sp)
     54e:	e852                	sd	s4,16(sp)
     550:	e456                	sd	s5,8(sp)
     552:	e05a                	sd	s6,0(sp)
     554:	0080                	addi	s0,sp,64
     556:	8a2a                	mv	s4,a0
     558:	892e                	mv	s2,a1
     55a:	8ab2                	mv	s5,a2
     55c:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     55e:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     560:	00002997          	auipc	s3,0x2
     564:	aa898993          	addi	s3,s3,-1368 # 2008 <whitespace>
     568:	00b4fc63          	bgeu	s1,a1,580 <gettoken+0x3e>
     56c:	0004c583          	lbu	a1,0(s1)
     570:	854e                	mv	a0,s3
     572:	6f8000ef          	jal	c6a <strchr>
     576:	c509                	beqz	a0,580 <gettoken+0x3e>
    s++;
     578:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     57a:	fe9919e3          	bne	s2,s1,56c <gettoken+0x2a>
     57e:	84ca                	mv	s1,s2
  if (q)
     580:	000a8463          	beqz	s5,588 <gettoken+0x46>
    *q = s;
     584:	009ab023          	sd	s1,0(s5)
  ret = *s;
     588:	0004c783          	lbu	a5,0(s1)
     58c:	00078a9b          	sext.w	s5,a5
  switch (*s)
     590:	03c00713          	li	a4,60
     594:	06f76463          	bltu	a4,a5,5fc <gettoken+0xba>
     598:	03a00713          	li	a4,58
     59c:	00f76e63          	bltu	a4,a5,5b8 <gettoken+0x76>
     5a0:	cf89                	beqz	a5,5ba <gettoken+0x78>
     5a2:	02600713          	li	a4,38
     5a6:	00e78963          	beq	a5,a4,5b8 <gettoken+0x76>
     5aa:	fd87879b          	addiw	a5,a5,-40
     5ae:	0ff7f793          	zext.b	a5,a5
     5b2:	4705                	li	a4,1
     5b4:	06f76b63          	bltu	a4,a5,62a <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5b8:	0485                	addi	s1,s1,1
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     5ba:	000b0463          	beqz	s6,5c2 <gettoken+0x80>
    *eq = s;
     5be:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
     5c2:	00002997          	auipc	s3,0x2
     5c6:	a4698993          	addi	s3,s3,-1466 # 2008 <whitespace>
     5ca:	0124fc63          	bgeu	s1,s2,5e2 <gettoken+0xa0>
     5ce:	0004c583          	lbu	a1,0(s1)
     5d2:	854e                	mv	a0,s3
     5d4:	696000ef          	jal	c6a <strchr>
     5d8:	c509                	beqz	a0,5e2 <gettoken+0xa0>
    s++;
     5da:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     5dc:	fe9919e3          	bne	s2,s1,5ce <gettoken+0x8c>
     5e0:	84ca                	mv	s1,s2
  *ps = s;
     5e2:	009a3023          	sd	s1,0(s4)
  return ret;
}
     5e6:	8556                	mv	a0,s5
     5e8:	70e2                	ld	ra,56(sp)
     5ea:	7442                	ld	s0,48(sp)
     5ec:	74a2                	ld	s1,40(sp)
     5ee:	7902                	ld	s2,32(sp)
     5f0:	69e2                	ld	s3,24(sp)
     5f2:	6a42                	ld	s4,16(sp)
     5f4:	6aa2                	ld	s5,8(sp)
     5f6:	6b02                	ld	s6,0(sp)
     5f8:	6121                	addi	sp,sp,64
     5fa:	8082                	ret
  switch (*s)
     5fc:	03e00713          	li	a4,62
     600:	02e79163          	bne	a5,a4,622 <gettoken+0xe0>
    s++;
     604:	00148693          	addi	a3,s1,1
    if (*s == '>')
     608:	0014c703          	lbu	a4,1(s1)
     60c:	03e00793          	li	a5,62
      s++;
     610:	0489                	addi	s1,s1,2
      ret = '+';
     612:	02b00a93          	li	s5,43
    if (*s == '>')
     616:	faf702e3          	beq	a4,a5,5ba <gettoken+0x78>
    s++;
     61a:	84b6                	mv	s1,a3
  ret = *s;
     61c:	03e00a93          	li	s5,62
     620:	bf69                	j	5ba <gettoken+0x78>
  switch (*s)
     622:	07c00713          	li	a4,124
     626:	f8e789e3          	beq	a5,a4,5b8 <gettoken+0x76>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     62a:	00002997          	auipc	s3,0x2
     62e:	9de98993          	addi	s3,s3,-1570 # 2008 <whitespace>
     632:	00002a97          	auipc	s5,0x2
     636:	9cea8a93          	addi	s5,s5,-1586 # 2000 <symbols>
     63a:	0324fd63          	bgeu	s1,s2,674 <gettoken+0x132>
     63e:	0004c583          	lbu	a1,0(s1)
     642:	854e                	mv	a0,s3
     644:	626000ef          	jal	c6a <strchr>
     648:	e11d                	bnez	a0,66e <gettoken+0x12c>
     64a:	0004c583          	lbu	a1,0(s1)
     64e:	8556                	mv	a0,s5
     650:	61a000ef          	jal	c6a <strchr>
     654:	e911                	bnez	a0,668 <gettoken+0x126>
      s++;
     656:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     658:	fe9913e3          	bne	s2,s1,63e <gettoken+0xfc>
  if (eq)
     65c:	84ca                	mv	s1,s2
    ret = 'a';
     65e:	06100a93          	li	s5,97
  if (eq)
     662:	f40b1ee3          	bnez	s6,5be <gettoken+0x7c>
     666:	bfb5                	j	5e2 <gettoken+0xa0>
    ret = 'a';
     668:	06100a93          	li	s5,97
     66c:	b7b9                	j	5ba <gettoken+0x78>
     66e:	06100a93          	li	s5,97
     672:	b7a1                	j	5ba <gettoken+0x78>
     674:	06100a93          	li	s5,97
  if (eq)
     678:	f40b13e3          	bnez	s6,5be <gettoken+0x7c>
     67c:	b79d                	j	5e2 <gettoken+0xa0>

000000000000067e <peek>:

int peek(char **ps, char *es, char *toks)
{
     67e:	7139                	addi	sp,sp,-64
     680:	fc06                	sd	ra,56(sp)
     682:	f822                	sd	s0,48(sp)
     684:	f426                	sd	s1,40(sp)
     686:	f04a                	sd	s2,32(sp)
     688:	ec4e                	sd	s3,24(sp)
     68a:	e852                	sd	s4,16(sp)
     68c:	e456                	sd	s5,8(sp)
     68e:	0080                	addi	s0,sp,64
     690:	8a2a                	mv	s4,a0
     692:	892e                	mv	s2,a1
     694:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     696:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     698:	00002997          	auipc	s3,0x2
     69c:	97098993          	addi	s3,s3,-1680 # 2008 <whitespace>
     6a0:	00b4fc63          	bgeu	s1,a1,6b8 <peek+0x3a>
     6a4:	0004c583          	lbu	a1,0(s1)
     6a8:	854e                	mv	a0,s3
     6aa:	5c0000ef          	jal	c6a <strchr>
     6ae:	c509                	beqz	a0,6b8 <peek+0x3a>
    s++;
     6b0:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     6b2:	fe9919e3          	bne	s2,s1,6a4 <peek+0x26>
     6b6:	84ca                	mv	s1,s2
  *ps = s;
     6b8:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     6bc:	0004c583          	lbu	a1,0(s1)
     6c0:	4501                	li	a0,0
     6c2:	e991                	bnez	a1,6d6 <peek+0x58>
}
     6c4:	70e2                	ld	ra,56(sp)
     6c6:	7442                	ld	s0,48(sp)
     6c8:	74a2                	ld	s1,40(sp)
     6ca:	7902                	ld	s2,32(sp)
     6cc:	69e2                	ld	s3,24(sp)
     6ce:	6a42                	ld	s4,16(sp)
     6d0:	6aa2                	ld	s5,8(sp)
     6d2:	6121                	addi	sp,sp,64
     6d4:	8082                	ret
  return *s && strchr(toks, *s);
     6d6:	8556                	mv	a0,s5
     6d8:	592000ef          	jal	c6a <strchr>
     6dc:	00a03533          	snez	a0,a0
     6e0:	b7d5                	j	6c4 <peek+0x46>

00000000000006e2 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6e2:	711d                	addi	sp,sp,-96
     6e4:	ec86                	sd	ra,88(sp)
     6e6:	e8a2                	sd	s0,80(sp)
     6e8:	e4a6                	sd	s1,72(sp)
     6ea:	e0ca                	sd	s2,64(sp)
     6ec:	fc4e                	sd	s3,56(sp)
     6ee:	f852                	sd	s4,48(sp)
     6f0:	f456                	sd	s5,40(sp)
     6f2:	f05a                	sd	s6,32(sp)
     6f4:	ec5e                	sd	s7,24(sp)
     6f6:	1080                	addi	s0,sp,96
     6f8:	8a2a                	mv	s4,a0
     6fa:	89ae                	mv	s3,a1
     6fc:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>"))
     6fe:	00001a97          	auipc	s5,0x1
     702:	dbaa8a93          	addi	s5,s5,-582 # 14b8 <malloc+0x1be>
  {
    tok = gettoken(ps, es, 0, 0);
    if (gettoken(ps, es, &q, &eq) != 'a')
     706:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch (tok)
     70a:	03c00b93          	li	s7,60
  while (peek(ps, es, "<>"))
     70e:	a00d                	j	730 <parseredirs+0x4e>
      panic("missing file for redirection");
     710:	00001517          	auipc	a0,0x1
     714:	d8850513          	addi	a0,a0,-632 # 1498 <malloc+0x19e>
     718:	933ff0ef          	jal	4a <panic>
    {
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     71c:	4701                	li	a4,0
     71e:	4681                	li	a3,0
     720:	fa043603          	ld	a2,-96(s0)
     724:	fa843583          	ld	a1,-88(s0)
     728:	8552                	mv	a0,s4
     72a:	d09ff0ef          	jal	432 <redircmd>
     72e:	8a2a                	mv	s4,a0
  while (peek(ps, es, "<>"))
     730:	8656                	mv	a2,s5
     732:	85ca                	mv	a1,s2
     734:	854e                	mv	a0,s3
     736:	f49ff0ef          	jal	67e <peek>
     73a:	c525                	beqz	a0,7a2 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     73c:	4681                	li	a3,0
     73e:	4601                	li	a2,0
     740:	85ca                	mv	a1,s2
     742:	854e                	mv	a0,s3
     744:	dffff0ef          	jal	542 <gettoken>
     748:	84aa                	mv	s1,a0
    if (gettoken(ps, es, &q, &eq) != 'a')
     74a:	fa040693          	addi	a3,s0,-96
     74e:	fa840613          	addi	a2,s0,-88
     752:	85ca                	mv	a1,s2
     754:	854e                	mv	a0,s3
     756:	dedff0ef          	jal	542 <gettoken>
     75a:	fb651be3          	bne	a0,s6,710 <parseredirs+0x2e>
    switch (tok)
     75e:	fb748fe3          	beq	s1,s7,71c <parseredirs+0x3a>
     762:	03e00793          	li	a5,62
     766:	02f48263          	beq	s1,a5,78a <parseredirs+0xa8>
     76a:	02b00793          	li	a5,43
     76e:	fcf491e3          	bne	s1,a5,730 <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     772:	4705                	li	a4,1
     774:	20100693          	li	a3,513
     778:	fa043603          	ld	a2,-96(s0)
     77c:	fa843583          	ld	a1,-88(s0)
     780:	8552                	mv	a0,s4
     782:	cb1ff0ef          	jal	432 <redircmd>
     786:	8a2a                	mv	s4,a0
      break;
     788:	b765                	j	730 <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     78a:	4705                	li	a4,1
     78c:	60100693          	li	a3,1537
     790:	fa043603          	ld	a2,-96(s0)
     794:	fa843583          	ld	a1,-88(s0)
     798:	8552                	mv	a0,s4
     79a:	c99ff0ef          	jal	432 <redircmd>
     79e:	8a2a                	mv	s4,a0
      break;
     7a0:	bf41                	j	730 <parseredirs+0x4e>
    }
  }
  return cmd;
}
     7a2:	8552                	mv	a0,s4
     7a4:	60e6                	ld	ra,88(sp)
     7a6:	6446                	ld	s0,80(sp)
     7a8:	64a6                	ld	s1,72(sp)
     7aa:	6906                	ld	s2,64(sp)
     7ac:	79e2                	ld	s3,56(sp)
     7ae:	7a42                	ld	s4,48(sp)
     7b0:	7aa2                	ld	s5,40(sp)
     7b2:	7b02                	ld	s6,32(sp)
     7b4:	6be2                	ld	s7,24(sp)
     7b6:	6125                	addi	sp,sp,96
     7b8:	8082                	ret

00000000000007ba <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     7ba:	7159                	addi	sp,sp,-112
     7bc:	f486                	sd	ra,104(sp)
     7be:	f0a2                	sd	s0,96(sp)
     7c0:	eca6                	sd	s1,88(sp)
     7c2:	e0d2                	sd	s4,64(sp)
     7c4:	fc56                	sd	s5,56(sp)
     7c6:	1880                	addi	s0,sp,112
     7c8:	8a2a                	mv	s4,a0
     7ca:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     7cc:	00001617          	auipc	a2,0x1
     7d0:	cf460613          	addi	a2,a2,-780 # 14c0 <malloc+0x1c6>
     7d4:	eabff0ef          	jal	67e <peek>
     7d8:	e915                	bnez	a0,80c <parseexec+0x52>
     7da:	e8ca                	sd	s2,80(sp)
     7dc:	e4ce                	sd	s3,72(sp)
     7de:	f85a                	sd	s6,48(sp)
     7e0:	f45e                	sd	s7,40(sp)
     7e2:	f062                	sd	s8,32(sp)
     7e4:	ec66                	sd	s9,24(sp)
     7e6:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     7e8:	c1dff0ef          	jal	404 <execcmd>
     7ec:	8c2a                	mv	s8,a0
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7ee:	8656                	mv	a2,s5
     7f0:	85d2                	mv	a1,s4
     7f2:	ef1ff0ef          	jal	6e2 <parseredirs>
     7f6:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     7f8:	008c0913          	addi	s2,s8,8
     7fc:	00001b17          	auipc	s6,0x1
     800:	ce4b0b13          	addi	s6,s6,-796 # 14e0 <malloc+0x1e6>
  {
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
      break;
    if (tok != 'a')
     804:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
     808:	4ba9                	li	s7,10
  while (!peek(ps, es, "|)&;"))
     80a:	a815                	j	83e <parseexec+0x84>
    return parseblock(ps, es);
     80c:	85d6                	mv	a1,s5
     80e:	8552                	mv	a0,s4
     810:	170000ef          	jal	980 <parseblock>
     814:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     816:	8526                	mv	a0,s1
     818:	70a6                	ld	ra,104(sp)
     81a:	7406                	ld	s0,96(sp)
     81c:	64e6                	ld	s1,88(sp)
     81e:	6a06                	ld	s4,64(sp)
     820:	7ae2                	ld	s5,56(sp)
     822:	6165                	addi	sp,sp,112
     824:	8082                	ret
      panic("syntax");
     826:	00001517          	auipc	a0,0x1
     82a:	ca250513          	addi	a0,a0,-862 # 14c8 <malloc+0x1ce>
     82e:	81dff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     832:	8656                	mv	a2,s5
     834:	85d2                	mv	a1,s4
     836:	8526                	mv	a0,s1
     838:	eabff0ef          	jal	6e2 <parseredirs>
     83c:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     83e:	865a                	mv	a2,s6
     840:	85d6                	mv	a1,s5
     842:	8552                	mv	a0,s4
     844:	e3bff0ef          	jal	67e <peek>
     848:	ed15                	bnez	a0,884 <parseexec+0xca>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     84a:	f9040693          	addi	a3,s0,-112
     84e:	f9840613          	addi	a2,s0,-104
     852:	85d6                	mv	a1,s5
     854:	8552                	mv	a0,s4
     856:	cedff0ef          	jal	542 <gettoken>
     85a:	c50d                	beqz	a0,884 <parseexec+0xca>
    if (tok != 'a')
     85c:	fd9515e3          	bne	a0,s9,826 <parseexec+0x6c>
    cmd->argv[argc] = q;
     860:	f9843783          	ld	a5,-104(s0)
     864:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     868:	f9043783          	ld	a5,-112(s0)
     86c:	04f93823          	sd	a5,80(s2)
    argc++;
     870:	2985                	addiw	s3,s3,1
    if (argc >= MAXARGS)
     872:	0921                	addi	s2,s2,8
     874:	fb799fe3          	bne	s3,s7,832 <parseexec+0x78>
      panic("too many args");
     878:	00001517          	auipc	a0,0x1
     87c:	c5850513          	addi	a0,a0,-936 # 14d0 <malloc+0x1d6>
     880:	fcaff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     884:	098e                	slli	s3,s3,0x3
     886:	9c4e                	add	s8,s8,s3
     888:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     88c:	040c3c23          	sd	zero,88(s8)
     890:	6946                	ld	s2,80(sp)
     892:	69a6                	ld	s3,72(sp)
     894:	7b42                	ld	s6,48(sp)
     896:	7ba2                	ld	s7,40(sp)
     898:	7c02                	ld	s8,32(sp)
     89a:	6ce2                	ld	s9,24(sp)
  return ret;
     89c:	bfad                	j	816 <parseexec+0x5c>

000000000000089e <parsepipe>:
{
     89e:	7179                	addi	sp,sp,-48
     8a0:	f406                	sd	ra,40(sp)
     8a2:	f022                	sd	s0,32(sp)
     8a4:	ec26                	sd	s1,24(sp)
     8a6:	e84a                	sd	s2,16(sp)
     8a8:	e44e                	sd	s3,8(sp)
     8aa:	1800                	addi	s0,sp,48
     8ac:	892a                	mv	s2,a0
     8ae:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     8b0:	f0bff0ef          	jal	7ba <parseexec>
     8b4:	84aa                	mv	s1,a0
  if (peek(ps, es, "|"))
     8b6:	00001617          	auipc	a2,0x1
     8ba:	c3260613          	addi	a2,a2,-974 # 14e8 <malloc+0x1ee>
     8be:	85ce                	mv	a1,s3
     8c0:	854a                	mv	a0,s2
     8c2:	dbdff0ef          	jal	67e <peek>
     8c6:	e909                	bnez	a0,8d8 <parsepipe+0x3a>
}
     8c8:	8526                	mv	a0,s1
     8ca:	70a2                	ld	ra,40(sp)
     8cc:	7402                	ld	s0,32(sp)
     8ce:	64e2                	ld	s1,24(sp)
     8d0:	6942                	ld	s2,16(sp)
     8d2:	69a2                	ld	s3,8(sp)
     8d4:	6145                	addi	sp,sp,48
     8d6:	8082                	ret
    gettoken(ps, es, 0, 0);
     8d8:	4681                	li	a3,0
     8da:	4601                	li	a2,0
     8dc:	85ce                	mv	a1,s3
     8de:	854a                	mv	a0,s2
     8e0:	c63ff0ef          	jal	542 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8e4:	85ce                	mv	a1,s3
     8e6:	854a                	mv	a0,s2
     8e8:	fb7ff0ef          	jal	89e <parsepipe>
     8ec:	85aa                	mv	a1,a0
     8ee:	8526                	mv	a0,s1
     8f0:	ba3ff0ef          	jal	492 <pipecmd>
     8f4:	84aa                	mv	s1,a0
  return cmd;
     8f6:	bfc9                	j	8c8 <parsepipe+0x2a>

00000000000008f8 <parseline>:
{
     8f8:	7179                	addi	sp,sp,-48
     8fa:	f406                	sd	ra,40(sp)
     8fc:	f022                	sd	s0,32(sp)
     8fe:	ec26                	sd	s1,24(sp)
     900:	e84a                	sd	s2,16(sp)
     902:	e44e                	sd	s3,8(sp)
     904:	e052                	sd	s4,0(sp)
     906:	1800                	addi	s0,sp,48
     908:	892a                	mv	s2,a0
     90a:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     90c:	f93ff0ef          	jal	89e <parsepipe>
     910:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     912:	00001a17          	auipc	s4,0x1
     916:	bdea0a13          	addi	s4,s4,-1058 # 14f0 <malloc+0x1f6>
     91a:	a819                	j	930 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     91c:	4681                	li	a3,0
     91e:	4601                	li	a2,0
     920:	85ce                	mv	a1,s3
     922:	854a                	mv	a0,s2
     924:	c1fff0ef          	jal	542 <gettoken>
    cmd = backcmd(cmd);
     928:	8526                	mv	a0,s1
     92a:	be5ff0ef          	jal	50e <backcmd>
     92e:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     930:	8652                	mv	a2,s4
     932:	85ce                	mv	a1,s3
     934:	854a                	mv	a0,s2
     936:	d49ff0ef          	jal	67e <peek>
     93a:	f16d                	bnez	a0,91c <parseline+0x24>
  if (peek(ps, es, ";"))
     93c:	00001617          	auipc	a2,0x1
     940:	bbc60613          	addi	a2,a2,-1092 # 14f8 <malloc+0x1fe>
     944:	85ce                	mv	a1,s3
     946:	854a                	mv	a0,s2
     948:	d37ff0ef          	jal	67e <peek>
     94c:	e911                	bnez	a0,960 <parseline+0x68>
}
     94e:	8526                	mv	a0,s1
     950:	70a2                	ld	ra,40(sp)
     952:	7402                	ld	s0,32(sp)
     954:	64e2                	ld	s1,24(sp)
     956:	6942                	ld	s2,16(sp)
     958:	69a2                	ld	s3,8(sp)
     95a:	6a02                	ld	s4,0(sp)
     95c:	6145                	addi	sp,sp,48
     95e:	8082                	ret
    gettoken(ps, es, 0, 0);
     960:	4681                	li	a3,0
     962:	4601                	li	a2,0
     964:	85ce                	mv	a1,s3
     966:	854a                	mv	a0,s2
     968:	bdbff0ef          	jal	542 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     96c:	85ce                	mv	a1,s3
     96e:	854a                	mv	a0,s2
     970:	f89ff0ef          	jal	8f8 <parseline>
     974:	85aa                	mv	a1,a0
     976:	8526                	mv	a0,s1
     978:	b59ff0ef          	jal	4d0 <listcmd>
     97c:	84aa                	mv	s1,a0
  return cmd;
     97e:	bfc1                	j	94e <parseline+0x56>

0000000000000980 <parseblock>:
{
     980:	7179                	addi	sp,sp,-48
     982:	f406                	sd	ra,40(sp)
     984:	f022                	sd	s0,32(sp)
     986:	ec26                	sd	s1,24(sp)
     988:	e84a                	sd	s2,16(sp)
     98a:	e44e                	sd	s3,8(sp)
     98c:	1800                	addi	s0,sp,48
     98e:	84aa                	mv	s1,a0
     990:	892e                	mv	s2,a1
  if (!peek(ps, es, "("))
     992:	00001617          	auipc	a2,0x1
     996:	b2e60613          	addi	a2,a2,-1234 # 14c0 <malloc+0x1c6>
     99a:	ce5ff0ef          	jal	67e <peek>
     99e:	c539                	beqz	a0,9ec <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     9a0:	4681                	li	a3,0
     9a2:	4601                	li	a2,0
     9a4:	85ca                	mv	a1,s2
     9a6:	8526                	mv	a0,s1
     9a8:	b9bff0ef          	jal	542 <gettoken>
  cmd = parseline(ps, es);
     9ac:	85ca                	mv	a1,s2
     9ae:	8526                	mv	a0,s1
     9b0:	f49ff0ef          	jal	8f8 <parseline>
     9b4:	89aa                	mv	s3,a0
  if (!peek(ps, es, ")"))
     9b6:	00001617          	auipc	a2,0x1
     9ba:	b5a60613          	addi	a2,a2,-1190 # 1510 <malloc+0x216>
     9be:	85ca                	mv	a1,s2
     9c0:	8526                	mv	a0,s1
     9c2:	cbdff0ef          	jal	67e <peek>
     9c6:	c90d                	beqz	a0,9f8 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     9c8:	4681                	li	a3,0
     9ca:	4601                	li	a2,0
     9cc:	85ca                	mv	a1,s2
     9ce:	8526                	mv	a0,s1
     9d0:	b73ff0ef          	jal	542 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     9d4:	864a                	mv	a2,s2
     9d6:	85a6                	mv	a1,s1
     9d8:	854e                	mv	a0,s3
     9da:	d09ff0ef          	jal	6e2 <parseredirs>
}
     9de:	70a2                	ld	ra,40(sp)
     9e0:	7402                	ld	s0,32(sp)
     9e2:	64e2                	ld	s1,24(sp)
     9e4:	6942                	ld	s2,16(sp)
     9e6:	69a2                	ld	s3,8(sp)
     9e8:	6145                	addi	sp,sp,48
     9ea:	8082                	ret
    panic("parseblock");
     9ec:	00001517          	auipc	a0,0x1
     9f0:	b1450513          	addi	a0,a0,-1260 # 1500 <malloc+0x206>
     9f4:	e56ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     9f8:	00001517          	auipc	a0,0x1
     9fc:	b2050513          	addi	a0,a0,-1248 # 1518 <malloc+0x21e>
     a00:	e4aff0ef          	jal	4a <panic>

0000000000000a04 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     a04:	1101                	addi	sp,sp,-32
     a06:	ec06                	sd	ra,24(sp)
     a08:	e822                	sd	s0,16(sp)
     a0a:	e426                	sd	s1,8(sp)
     a0c:	1000                	addi	s0,sp,32
     a0e:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     a10:	c131                	beqz	a0,a54 <nulterminate+0x50>
    return 0;

  switch (cmd->type)
     a12:	4118                	lw	a4,0(a0)
     a14:	4795                	li	a5,5
     a16:	02e7ef63          	bltu	a5,a4,a54 <nulterminate+0x50>
     a1a:	00056783          	lwu	a5,0(a0)
     a1e:	078a                	slli	a5,a5,0x2
     a20:	00001717          	auipc	a4,0x1
     a24:	b5870713          	addi	a4,a4,-1192 # 1578 <malloc+0x27e>
     a28:	97ba                	add	a5,a5,a4
     a2a:	439c                	lw	a5,0(a5)
     a2c:	97ba                	add	a5,a5,a4
     a2e:	8782                	jr	a5
  {
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    for (i = 0; ecmd->argv[i]; i++)
     a30:	651c                	ld	a5,8(a0)
     a32:	c38d                	beqz	a5,a54 <nulterminate+0x50>
     a34:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     a38:	67b8                	ld	a4,72(a5)
     a3a:	00070023          	sb	zero,0(a4)
    for (i = 0; ecmd->argv[i]; i++)
     a3e:	07a1                	addi	a5,a5,8
     a40:	ff87b703          	ld	a4,-8(a5)
     a44:	fb75                	bnez	a4,a38 <nulterminate+0x34>
     a46:	a039                	j	a54 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    nulterminate(rcmd->cmd);
     a48:	6508                	ld	a0,8(a0)
     a4a:	fbbff0ef          	jal	a04 <nulterminate>
    *rcmd->efile = 0;
     a4e:	6c9c                	ld	a5,24(s1)
     a50:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a54:	8526                	mv	a0,s1
     a56:	60e2                	ld	ra,24(sp)
     a58:	6442                	ld	s0,16(sp)
     a5a:	64a2                	ld	s1,8(sp)
     a5c:	6105                	addi	sp,sp,32
     a5e:	8082                	ret
    nulterminate(pcmd->left);
     a60:	6508                	ld	a0,8(a0)
     a62:	fa3ff0ef          	jal	a04 <nulterminate>
    nulterminate(pcmd->right);
     a66:	6888                	ld	a0,16(s1)
     a68:	f9dff0ef          	jal	a04 <nulterminate>
    break;
     a6c:	b7e5                	j	a54 <nulterminate+0x50>
    nulterminate(lcmd->left);
     a6e:	6508                	ld	a0,8(a0)
     a70:	f95ff0ef          	jal	a04 <nulterminate>
    nulterminate(lcmd->right);
     a74:	6888                	ld	a0,16(s1)
     a76:	f8fff0ef          	jal	a04 <nulterminate>
    break;
     a7a:	bfe9                	j	a54 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     a7c:	6508                	ld	a0,8(a0)
     a7e:	f87ff0ef          	jal	a04 <nulterminate>
    break;
     a82:	bfc9                	j	a54 <nulterminate+0x50>

0000000000000a84 <parsecmd>:
{
     a84:	7179                	addi	sp,sp,-48
     a86:	f406                	sd	ra,40(sp)
     a88:	f022                	sd	s0,32(sp)
     a8a:	ec26                	sd	s1,24(sp)
     a8c:	e84a                	sd	s2,16(sp)
     a8e:	1800                	addi	s0,sp,48
     a90:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     a94:	84aa                	mv	s1,a0
     a96:	188000ef          	jal	c1e <strlen>
     a9a:	1502                	slli	a0,a0,0x20
     a9c:	9101                	srli	a0,a0,0x20
     a9e:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     aa0:	85a6                	mv	a1,s1
     aa2:	fd840513          	addi	a0,s0,-40
     aa6:	e53ff0ef          	jal	8f8 <parseline>
     aaa:	892a                	mv	s2,a0
  peek(&s, es, "");
     aac:	00001617          	auipc	a2,0x1
     ab0:	96c60613          	addi	a2,a2,-1684 # 1418 <malloc+0x11e>
     ab4:	85a6                	mv	a1,s1
     ab6:	fd840513          	addi	a0,s0,-40
     aba:	bc5ff0ef          	jal	67e <peek>
  if (s != es)
     abe:	fd843603          	ld	a2,-40(s0)
     ac2:	00961c63          	bne	a2,s1,ada <parsecmd+0x56>
  nulterminate(cmd);
     ac6:	854a                	mv	a0,s2
     ac8:	f3dff0ef          	jal	a04 <nulterminate>
}
     acc:	854a                	mv	a0,s2
     ace:	70a2                	ld	ra,40(sp)
     ad0:	7402                	ld	s0,32(sp)
     ad2:	64e2                	ld	s1,24(sp)
     ad4:	6942                	ld	s2,16(sp)
     ad6:	6145                	addi	sp,sp,48
     ad8:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     ada:	00001597          	auipc	a1,0x1
     ade:	a5658593          	addi	a1,a1,-1450 # 1530 <malloc+0x236>
     ae2:	4509                	li	a0,2
     ae4:	738000ef          	jal	121c <fprintf>
    panic("syntax");
     ae8:	00001517          	auipc	a0,0x1
     aec:	9e050513          	addi	a0,a0,-1568 # 14c8 <malloc+0x1ce>
     af0:	d5aff0ef          	jal	4a <panic>

0000000000000af4 <main>:
{
     af4:	7179                	addi	sp,sp,-48
     af6:	f406                	sd	ra,40(sp)
     af8:	f022                	sd	s0,32(sp)
     afa:	ec26                	sd	s1,24(sp)
     afc:	e84a                	sd	s2,16(sp)
     afe:	e44e                	sd	s3,8(sp)
     b00:	e052                	sd	s4,0(sp)
     b02:	1800                	addi	s0,sp,48
  while ((fd = open("console", O_RDWR)) >= 0)
     b04:	00001497          	auipc	s1,0x1
     b08:	a3c48493          	addi	s1,s1,-1476 # 1540 <malloc+0x246>
     b0c:	4589                	li	a1,2
     b0e:	8526                	mv	a0,s1
     b10:	35e000ef          	jal	e6e <open>
     b14:	00054763          	bltz	a0,b22 <main+0x2e>
    if (fd >= 3)
     b18:	4789                	li	a5,2
     b1a:	fea7d9e3          	bge	a5,a0,b0c <main+0x18>
      close(fd);
     b1e:	338000ef          	jal	e56 <close>
  while (getcmd(buf, sizeof(buf)) >= 0)
     b22:	00001497          	auipc	s1,0x1
     b26:	4fe48493          	addi	s1,s1,1278 # 2020 <buf.0>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     b2a:	06300913          	li	s2,99
     b2e:	02000993          	li	s3,32
     b32:	a039                	j	b40 <main+0x4c>
    if (fork1() == 0)
     b34:	d34ff0ef          	jal	68 <fork1>
     b38:	c93d                	beqz	a0,bae <main+0xba>
    wait(0);
     b3a:	4501                	li	a0,0
     b3c:	2fa000ef          	jal	e36 <wait>
  while (getcmd(buf, sizeof(buf)) >= 0)
     b40:	06400593          	li	a1,100
     b44:	8526                	mv	a0,s1
     b46:	cbaff0ef          	jal	0 <getcmd>
     b4a:	06054a63          	bltz	a0,bbe <main+0xca>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     b4e:	0004c783          	lbu	a5,0(s1)
     b52:	ff2791e3          	bne	a5,s2,b34 <main+0x40>
     b56:	0014c703          	lbu	a4,1(s1)
     b5a:	06400793          	li	a5,100
     b5e:	fcf71be3          	bne	a4,a5,b34 <main+0x40>
     b62:	0024c783          	lbu	a5,2(s1)
     b66:	fd3797e3          	bne	a5,s3,b34 <main+0x40>
      buf[strlen(buf) - 1] = 0; // chop \n
     b6a:	00001a17          	auipc	s4,0x1
     b6e:	4b6a0a13          	addi	s4,s4,1206 # 2020 <buf.0>
     b72:	8552                	mv	a0,s4
     b74:	0aa000ef          	jal	c1e <strlen>
     b78:	fff5079b          	addiw	a5,a0,-1
     b7c:	1782                	slli	a5,a5,0x20
     b7e:	9381                	srli	a5,a5,0x20
     b80:	9a3e                	add	s4,s4,a5
     b82:	000a0023          	sb	zero,0(s4)
      if (chdir(buf + 3) < 0)
     b86:	00001517          	auipc	a0,0x1
     b8a:	49d50513          	addi	a0,a0,1181 # 2023 <buf.0+0x3>
     b8e:	310000ef          	jal	e9e <chdir>
     b92:	fa0557e3          	bgez	a0,b40 <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf + 3);
     b96:	00001617          	auipc	a2,0x1
     b9a:	48d60613          	addi	a2,a2,1165 # 2023 <buf.0+0x3>
     b9e:	00001597          	auipc	a1,0x1
     ba2:	9aa58593          	addi	a1,a1,-1622 # 1548 <malloc+0x24e>
     ba6:	4509                	li	a0,2
     ba8:	674000ef          	jal	121c <fprintf>
     bac:	bf51                	j	b40 <main+0x4c>
      runcmd(parsecmd(buf));
     bae:	00001517          	auipc	a0,0x1
     bb2:	47250513          	addi	a0,a0,1138 # 2020 <buf.0>
     bb6:	ecfff0ef          	jal	a84 <parsecmd>
     bba:	cd4ff0ef          	jal	8e <runcmd>
  exit(0);
     bbe:	4501                	li	a0,0
     bc0:	26e000ef          	jal	e2e <exit>

0000000000000bc4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     bc4:	1141                	addi	sp,sp,-16
     bc6:	e406                	sd	ra,8(sp)
     bc8:	e022                	sd	s0,0(sp)
     bca:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bcc:	f29ff0ef          	jal	af4 <main>
  exit(0);
     bd0:	4501                	li	a0,0
     bd2:	25c000ef          	jal	e2e <exit>

0000000000000bd6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bd6:	1141                	addi	sp,sp,-16
     bd8:	e422                	sd	s0,8(sp)
     bda:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bdc:	87aa                	mv	a5,a0
     bde:	0585                	addi	a1,a1,1
     be0:	0785                	addi	a5,a5,1
     be2:	fff5c703          	lbu	a4,-1(a1)
     be6:	fee78fa3          	sb	a4,-1(a5)
     bea:	fb75                	bnez	a4,bde <strcpy+0x8>
    ;
  return os;
}
     bec:	6422                	ld	s0,8(sp)
     bee:	0141                	addi	sp,sp,16
     bf0:	8082                	ret

0000000000000bf2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bf2:	1141                	addi	sp,sp,-16
     bf4:	e422                	sd	s0,8(sp)
     bf6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bf8:	00054783          	lbu	a5,0(a0)
     bfc:	cb91                	beqz	a5,c10 <strcmp+0x1e>
     bfe:	0005c703          	lbu	a4,0(a1)
     c02:	00f71763          	bne	a4,a5,c10 <strcmp+0x1e>
    p++, q++;
     c06:	0505                	addi	a0,a0,1
     c08:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c0a:	00054783          	lbu	a5,0(a0)
     c0e:	fbe5                	bnez	a5,bfe <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c10:	0005c503          	lbu	a0,0(a1)
}
     c14:	40a7853b          	subw	a0,a5,a0
     c18:	6422                	ld	s0,8(sp)
     c1a:	0141                	addi	sp,sp,16
     c1c:	8082                	ret

0000000000000c1e <strlen>:

uint
strlen(const char *s)
{
     c1e:	1141                	addi	sp,sp,-16
     c20:	e422                	sd	s0,8(sp)
     c22:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c24:	00054783          	lbu	a5,0(a0)
     c28:	cf91                	beqz	a5,c44 <strlen+0x26>
     c2a:	0505                	addi	a0,a0,1
     c2c:	87aa                	mv	a5,a0
     c2e:	86be                	mv	a3,a5
     c30:	0785                	addi	a5,a5,1
     c32:	fff7c703          	lbu	a4,-1(a5)
     c36:	ff65                	bnez	a4,c2e <strlen+0x10>
     c38:	40a6853b          	subw	a0,a3,a0
     c3c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c3e:	6422                	ld	s0,8(sp)
     c40:	0141                	addi	sp,sp,16
     c42:	8082                	ret
  for(n = 0; s[n]; n++)
     c44:	4501                	li	a0,0
     c46:	bfe5                	j	c3e <strlen+0x20>

0000000000000c48 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c48:	1141                	addi	sp,sp,-16
     c4a:	e422                	sd	s0,8(sp)
     c4c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c4e:	ca19                	beqz	a2,c64 <memset+0x1c>
     c50:	87aa                	mv	a5,a0
     c52:	1602                	slli	a2,a2,0x20
     c54:	9201                	srli	a2,a2,0x20
     c56:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c5a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c5e:	0785                	addi	a5,a5,1
     c60:	fee79de3          	bne	a5,a4,c5a <memset+0x12>
  }
  return dst;
}
     c64:	6422                	ld	s0,8(sp)
     c66:	0141                	addi	sp,sp,16
     c68:	8082                	ret

0000000000000c6a <strchr>:

char*
strchr(const char *s, char c)
{
     c6a:	1141                	addi	sp,sp,-16
     c6c:	e422                	sd	s0,8(sp)
     c6e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c70:	00054783          	lbu	a5,0(a0)
     c74:	cb99                	beqz	a5,c8a <strchr+0x20>
    if(*s == c)
     c76:	00f58763          	beq	a1,a5,c84 <strchr+0x1a>
  for(; *s; s++)
     c7a:	0505                	addi	a0,a0,1
     c7c:	00054783          	lbu	a5,0(a0)
     c80:	fbfd                	bnez	a5,c76 <strchr+0xc>
      return (char*)s;
  return 0;
     c82:	4501                	li	a0,0
}
     c84:	6422                	ld	s0,8(sp)
     c86:	0141                	addi	sp,sp,16
     c88:	8082                	ret
  return 0;
     c8a:	4501                	li	a0,0
     c8c:	bfe5                	j	c84 <strchr+0x1a>

0000000000000c8e <gets>:

char*
gets(char *buf, int max)
{
     c8e:	711d                	addi	sp,sp,-96
     c90:	ec86                	sd	ra,88(sp)
     c92:	e8a2                	sd	s0,80(sp)
     c94:	e4a6                	sd	s1,72(sp)
     c96:	e0ca                	sd	s2,64(sp)
     c98:	fc4e                	sd	s3,56(sp)
     c9a:	f852                	sd	s4,48(sp)
     c9c:	f456                	sd	s5,40(sp)
     c9e:	f05a                	sd	s6,32(sp)
     ca0:	ec5e                	sd	s7,24(sp)
     ca2:	1080                	addi	s0,sp,96
     ca4:	8baa                	mv	s7,a0
     ca6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ca8:	892a                	mv	s2,a0
     caa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cac:	4aa9                	li	s5,10
     cae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cb0:	89a6                	mv	s3,s1
     cb2:	2485                	addiw	s1,s1,1
     cb4:	0344d663          	bge	s1,s4,ce0 <gets+0x52>
    cc = read(0, &c, 1);
     cb8:	4605                	li	a2,1
     cba:	faf40593          	addi	a1,s0,-81
     cbe:	4501                	li	a0,0
     cc0:	186000ef          	jal	e46 <read>
    if(cc < 1)
     cc4:	00a05e63          	blez	a0,ce0 <gets+0x52>
    buf[i++] = c;
     cc8:	faf44783          	lbu	a5,-81(s0)
     ccc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cd0:	01578763          	beq	a5,s5,cde <gets+0x50>
     cd4:	0905                	addi	s2,s2,1
     cd6:	fd679de3          	bne	a5,s6,cb0 <gets+0x22>
    buf[i++] = c;
     cda:	89a6                	mv	s3,s1
     cdc:	a011                	j	ce0 <gets+0x52>
     cde:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ce0:	99de                	add	s3,s3,s7
     ce2:	00098023          	sb	zero,0(s3)
  return buf;
}
     ce6:	855e                	mv	a0,s7
     ce8:	60e6                	ld	ra,88(sp)
     cea:	6446                	ld	s0,80(sp)
     cec:	64a6                	ld	s1,72(sp)
     cee:	6906                	ld	s2,64(sp)
     cf0:	79e2                	ld	s3,56(sp)
     cf2:	7a42                	ld	s4,48(sp)
     cf4:	7aa2                	ld	s5,40(sp)
     cf6:	7b02                	ld	s6,32(sp)
     cf8:	6be2                	ld	s7,24(sp)
     cfa:	6125                	addi	sp,sp,96
     cfc:	8082                	ret

0000000000000cfe <stat>:

int
stat(const char *n, struct stat *st)
{
     cfe:	1101                	addi	sp,sp,-32
     d00:	ec06                	sd	ra,24(sp)
     d02:	e822                	sd	s0,16(sp)
     d04:	e04a                	sd	s2,0(sp)
     d06:	1000                	addi	s0,sp,32
     d08:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d0a:	4581                	li	a1,0
     d0c:	162000ef          	jal	e6e <open>
  if(fd < 0)
     d10:	02054263          	bltz	a0,d34 <stat+0x36>
     d14:	e426                	sd	s1,8(sp)
     d16:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d18:	85ca                	mv	a1,s2
     d1a:	16c000ef          	jal	e86 <fstat>
     d1e:	892a                	mv	s2,a0
  close(fd);
     d20:	8526                	mv	a0,s1
     d22:	134000ef          	jal	e56 <close>
  return r;
     d26:	64a2                	ld	s1,8(sp)
}
     d28:	854a                	mv	a0,s2
     d2a:	60e2                	ld	ra,24(sp)
     d2c:	6442                	ld	s0,16(sp)
     d2e:	6902                	ld	s2,0(sp)
     d30:	6105                	addi	sp,sp,32
     d32:	8082                	ret
    return -1;
     d34:	597d                	li	s2,-1
     d36:	bfcd                	j	d28 <stat+0x2a>

0000000000000d38 <atoi>:

int
atoi(const char *s)
{
     d38:	1141                	addi	sp,sp,-16
     d3a:	e422                	sd	s0,8(sp)
     d3c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d3e:	00054683          	lbu	a3,0(a0)
     d42:	fd06879b          	addiw	a5,a3,-48
     d46:	0ff7f793          	zext.b	a5,a5
     d4a:	4625                	li	a2,9
     d4c:	02f66863          	bltu	a2,a5,d7c <atoi+0x44>
     d50:	872a                	mv	a4,a0
  n = 0;
     d52:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d54:	0705                	addi	a4,a4,1
     d56:	0025179b          	slliw	a5,a0,0x2
     d5a:	9fa9                	addw	a5,a5,a0
     d5c:	0017979b          	slliw	a5,a5,0x1
     d60:	9fb5                	addw	a5,a5,a3
     d62:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d66:	00074683          	lbu	a3,0(a4)
     d6a:	fd06879b          	addiw	a5,a3,-48
     d6e:	0ff7f793          	zext.b	a5,a5
     d72:	fef671e3          	bgeu	a2,a5,d54 <atoi+0x1c>
  return n;
}
     d76:	6422                	ld	s0,8(sp)
     d78:	0141                	addi	sp,sp,16
     d7a:	8082                	ret
  n = 0;
     d7c:	4501                	li	a0,0
     d7e:	bfe5                	j	d76 <atoi+0x3e>

0000000000000d80 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d80:	1141                	addi	sp,sp,-16
     d82:	e422                	sd	s0,8(sp)
     d84:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d86:	02b57463          	bgeu	a0,a1,dae <memmove+0x2e>
    while(n-- > 0)
     d8a:	00c05f63          	blez	a2,da8 <memmove+0x28>
     d8e:	1602                	slli	a2,a2,0x20
     d90:	9201                	srli	a2,a2,0x20
     d92:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d96:	872a                	mv	a4,a0
      *dst++ = *src++;
     d98:	0585                	addi	a1,a1,1
     d9a:	0705                	addi	a4,a4,1
     d9c:	fff5c683          	lbu	a3,-1(a1)
     da0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     da4:	fef71ae3          	bne	a4,a5,d98 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     da8:	6422                	ld	s0,8(sp)
     daa:	0141                	addi	sp,sp,16
     dac:	8082                	ret
    dst += n;
     dae:	00c50733          	add	a4,a0,a2
    src += n;
     db2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     db4:	fec05ae3          	blez	a2,da8 <memmove+0x28>
     db8:	fff6079b          	addiw	a5,a2,-1
     dbc:	1782                	slli	a5,a5,0x20
     dbe:	9381                	srli	a5,a5,0x20
     dc0:	fff7c793          	not	a5,a5
     dc4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dc6:	15fd                	addi	a1,a1,-1
     dc8:	177d                	addi	a4,a4,-1
     dca:	0005c683          	lbu	a3,0(a1)
     dce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dd2:	fee79ae3          	bne	a5,a4,dc6 <memmove+0x46>
     dd6:	bfc9                	j	da8 <memmove+0x28>

0000000000000dd8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dd8:	1141                	addi	sp,sp,-16
     dda:	e422                	sd	s0,8(sp)
     ddc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dde:	ca05                	beqz	a2,e0e <memcmp+0x36>
     de0:	fff6069b          	addiw	a3,a2,-1
     de4:	1682                	slli	a3,a3,0x20
     de6:	9281                	srli	a3,a3,0x20
     de8:	0685                	addi	a3,a3,1
     dea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dec:	00054783          	lbu	a5,0(a0)
     df0:	0005c703          	lbu	a4,0(a1)
     df4:	00e79863          	bne	a5,a4,e04 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     df8:	0505                	addi	a0,a0,1
    p2++;
     dfa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dfc:	fed518e3          	bne	a0,a3,dec <memcmp+0x14>
  }
  return 0;
     e00:	4501                	li	a0,0
     e02:	a019                	j	e08 <memcmp+0x30>
      return *p1 - *p2;
     e04:	40e7853b          	subw	a0,a5,a4
}
     e08:	6422                	ld	s0,8(sp)
     e0a:	0141                	addi	sp,sp,16
     e0c:	8082                	ret
  return 0;
     e0e:	4501                	li	a0,0
     e10:	bfe5                	j	e08 <memcmp+0x30>

0000000000000e12 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e12:	1141                	addi	sp,sp,-16
     e14:	e406                	sd	ra,8(sp)
     e16:	e022                	sd	s0,0(sp)
     e18:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e1a:	f67ff0ef          	jal	d80 <memmove>
}
     e1e:	60a2                	ld	ra,8(sp)
     e20:	6402                	ld	s0,0(sp)
     e22:	0141                	addi	sp,sp,16
     e24:	8082                	ret

0000000000000e26 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e26:	4885                	li	a7,1
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <exit>:
.global exit
exit:
 li a7, SYS_exit
     e2e:	4889                	li	a7,2
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e36:	488d                	li	a7,3
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e3e:	4891                	li	a7,4
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <read>:
.global read
read:
 li a7, SYS_read
     e46:	4895                	li	a7,5
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <write>:
.global write
write:
 li a7, SYS_write
     e4e:	48c1                	li	a7,16
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <close>:
.global close
close:
 li a7, SYS_close
     e56:	48d5                	li	a7,21
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <kill>:
.global kill
kill:
 li a7, SYS_kill
     e5e:	4899                	li	a7,6
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e66:	489d                	li	a7,7
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <open>:
.global open
open:
 li a7, SYS_open
     e6e:	48bd                	li	a7,15
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e76:	48c5                	li	a7,17
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e7e:	48c9                	li	a7,18
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e86:	48a1                	li	a7,8
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <link>:
.global link
link:
 li a7, SYS_link
     e8e:	48cd                	li	a7,19
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e96:	48d1                	li	a7,20
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	8082                	ret

0000000000000e9e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e9e:	48a5                	li	a7,9
 ecall
     ea0:	00000073          	ecall
 ret
     ea4:	8082                	ret

0000000000000ea6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ea6:	48a9                	li	a7,10
 ecall
     ea8:	00000073          	ecall
 ret
     eac:	8082                	ret

0000000000000eae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     eae:	48ad                	li	a7,11
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	8082                	ret

0000000000000eb6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     eb6:	48b1                	li	a7,12
 ecall
     eb8:	00000073          	ecall
 ret
     ebc:	8082                	ret

0000000000000ebe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ebe:	48b5                	li	a7,13
 ecall
     ec0:	00000073          	ecall
 ret
     ec4:	8082                	ret

0000000000000ec6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ec6:	48b9                	li	a7,14
 ecall
     ec8:	00000073          	ecall
 ret
     ecc:	8082                	ret

0000000000000ece <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ece:	1101                	addi	sp,sp,-32
     ed0:	ec06                	sd	ra,24(sp)
     ed2:	e822                	sd	s0,16(sp)
     ed4:	1000                	addi	s0,sp,32
     ed6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     eda:	4605                	li	a2,1
     edc:	fef40593          	addi	a1,s0,-17
     ee0:	f6fff0ef          	jal	e4e <write>
}
     ee4:	60e2                	ld	ra,24(sp)
     ee6:	6442                	ld	s0,16(sp)
     ee8:	6105                	addi	sp,sp,32
     eea:	8082                	ret

0000000000000eec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eec:	7139                	addi	sp,sp,-64
     eee:	fc06                	sd	ra,56(sp)
     ef0:	f822                	sd	s0,48(sp)
     ef2:	f426                	sd	s1,40(sp)
     ef4:	0080                	addi	s0,sp,64
     ef6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ef8:	c299                	beqz	a3,efe <printint+0x12>
     efa:	0805c963          	bltz	a1,f8c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     efe:	2581                	sext.w	a1,a1
  neg = 0;
     f00:	4881                	li	a7,0
     f02:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f06:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f08:	2601                	sext.w	a2,a2
     f0a:	00000517          	auipc	a0,0x0
     f0e:	68650513          	addi	a0,a0,1670 # 1590 <digits>
     f12:	883a                	mv	a6,a4
     f14:	2705                	addiw	a4,a4,1
     f16:	02c5f7bb          	remuw	a5,a1,a2
     f1a:	1782                	slli	a5,a5,0x20
     f1c:	9381                	srli	a5,a5,0x20
     f1e:	97aa                	add	a5,a5,a0
     f20:	0007c783          	lbu	a5,0(a5)
     f24:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f28:	0005879b          	sext.w	a5,a1
     f2c:	02c5d5bb          	divuw	a1,a1,a2
     f30:	0685                	addi	a3,a3,1
     f32:	fec7f0e3          	bgeu	a5,a2,f12 <printint+0x26>
  if(neg)
     f36:	00088c63          	beqz	a7,f4e <printint+0x62>
    buf[i++] = '-';
     f3a:	fd070793          	addi	a5,a4,-48
     f3e:	00878733          	add	a4,a5,s0
     f42:	02d00793          	li	a5,45
     f46:	fef70823          	sb	a5,-16(a4)
     f4a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f4e:	02e05a63          	blez	a4,f82 <printint+0x96>
     f52:	f04a                	sd	s2,32(sp)
     f54:	ec4e                	sd	s3,24(sp)
     f56:	fc040793          	addi	a5,s0,-64
     f5a:	00e78933          	add	s2,a5,a4
     f5e:	fff78993          	addi	s3,a5,-1
     f62:	99ba                	add	s3,s3,a4
     f64:	377d                	addiw	a4,a4,-1
     f66:	1702                	slli	a4,a4,0x20
     f68:	9301                	srli	a4,a4,0x20
     f6a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f6e:	fff94583          	lbu	a1,-1(s2)
     f72:	8526                	mv	a0,s1
     f74:	f5bff0ef          	jal	ece <putc>
  while(--i >= 0)
     f78:	197d                	addi	s2,s2,-1
     f7a:	ff391ae3          	bne	s2,s3,f6e <printint+0x82>
     f7e:	7902                	ld	s2,32(sp)
     f80:	69e2                	ld	s3,24(sp)
}
     f82:	70e2                	ld	ra,56(sp)
     f84:	7442                	ld	s0,48(sp)
     f86:	74a2                	ld	s1,40(sp)
     f88:	6121                	addi	sp,sp,64
     f8a:	8082                	ret
    x = -xx;
     f8c:	40b005bb          	negw	a1,a1
    neg = 1;
     f90:	4885                	li	a7,1
    x = -xx;
     f92:	bf85                	j	f02 <printint+0x16>

0000000000000f94 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f94:	711d                	addi	sp,sp,-96
     f96:	ec86                	sd	ra,88(sp)
     f98:	e8a2                	sd	s0,80(sp)
     f9a:	e0ca                	sd	s2,64(sp)
     f9c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f9e:	0005c903          	lbu	s2,0(a1)
     fa2:	26090863          	beqz	s2,1212 <vprintf+0x27e>
     fa6:	e4a6                	sd	s1,72(sp)
     fa8:	fc4e                	sd	s3,56(sp)
     faa:	f852                	sd	s4,48(sp)
     fac:	f456                	sd	s5,40(sp)
     fae:	f05a                	sd	s6,32(sp)
     fb0:	ec5e                	sd	s7,24(sp)
     fb2:	e862                	sd	s8,16(sp)
     fb4:	e466                	sd	s9,8(sp)
     fb6:	8b2a                	mv	s6,a0
     fb8:	8a2e                	mv	s4,a1
     fba:	8bb2                	mv	s7,a2
  state = 0;
     fbc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     fbe:	4481                	li	s1,0
     fc0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     fc2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     fc6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     fca:	06c00c93          	li	s9,108
     fce:	a005                	j	fee <vprintf+0x5a>
        putc(fd, c0);
     fd0:	85ca                	mv	a1,s2
     fd2:	855a                	mv	a0,s6
     fd4:	efbff0ef          	jal	ece <putc>
     fd8:	a019                	j	fde <vprintf+0x4a>
    } else if(state == '%'){
     fda:	03598263          	beq	s3,s5,ffe <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     fde:	2485                	addiw	s1,s1,1
     fe0:	8726                	mv	a4,s1
     fe2:	009a07b3          	add	a5,s4,s1
     fe6:	0007c903          	lbu	s2,0(a5)
     fea:	20090c63          	beqz	s2,1202 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     fee:	0009079b          	sext.w	a5,s2
    if(state == 0){
     ff2:	fe0994e3          	bnez	s3,fda <vprintf+0x46>
      if(c0 == '%'){
     ff6:	fd579de3          	bne	a5,s5,fd0 <vprintf+0x3c>
        state = '%';
     ffa:	89be                	mv	s3,a5
     ffc:	b7cd                	j	fde <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     ffe:	00ea06b3          	add	a3,s4,a4
    1002:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1006:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1008:	c681                	beqz	a3,1010 <vprintf+0x7c>
    100a:	9752                	add	a4,a4,s4
    100c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1010:	03878f63          	beq	a5,s8,104e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1014:	05978963          	beq	a5,s9,1066 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1018:	07500713          	li	a4,117
    101c:	0ee78363          	beq	a5,a4,1102 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1020:	07800713          	li	a4,120
    1024:	12e78563          	beq	a5,a4,114e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1028:	07000713          	li	a4,112
    102c:	14e78a63          	beq	a5,a4,1180 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1030:	07300713          	li	a4,115
    1034:	18e78a63          	beq	a5,a4,11c8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1038:	02500713          	li	a4,37
    103c:	04e79563          	bne	a5,a4,1086 <vprintf+0xf2>
        putc(fd, '%');
    1040:	02500593          	li	a1,37
    1044:	855a                	mv	a0,s6
    1046:	e89ff0ef          	jal	ece <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    104a:	4981                	li	s3,0
    104c:	bf49                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    104e:	008b8913          	addi	s2,s7,8
    1052:	4685                	li	a3,1
    1054:	4629                	li	a2,10
    1056:	000ba583          	lw	a1,0(s7)
    105a:	855a                	mv	a0,s6
    105c:	e91ff0ef          	jal	eec <printint>
    1060:	8bca                	mv	s7,s2
      state = 0;
    1062:	4981                	li	s3,0
    1064:	bfad                	j	fde <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1066:	06400793          	li	a5,100
    106a:	02f68963          	beq	a3,a5,109c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    106e:	06c00793          	li	a5,108
    1072:	04f68263          	beq	a3,a5,10b6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1076:	07500793          	li	a5,117
    107a:	0af68063          	beq	a3,a5,111a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    107e:	07800793          	li	a5,120
    1082:	0ef68263          	beq	a3,a5,1166 <vprintf+0x1d2>
        putc(fd, '%');
    1086:	02500593          	li	a1,37
    108a:	855a                	mv	a0,s6
    108c:	e43ff0ef          	jal	ece <putc>
        putc(fd, c0);
    1090:	85ca                	mv	a1,s2
    1092:	855a                	mv	a0,s6
    1094:	e3bff0ef          	jal	ece <putc>
      state = 0;
    1098:	4981                	li	s3,0
    109a:	b791                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    109c:	008b8913          	addi	s2,s7,8
    10a0:	4685                	li	a3,1
    10a2:	4629                	li	a2,10
    10a4:	000ba583          	lw	a1,0(s7)
    10a8:	855a                	mv	a0,s6
    10aa:	e43ff0ef          	jal	eec <printint>
        i += 1;
    10ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    10b0:	8bca                	mv	s7,s2
      state = 0;
    10b2:	4981                	li	s3,0
        i += 1;
    10b4:	b72d                	j	fde <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    10b6:	06400793          	li	a5,100
    10ba:	02f60763          	beq	a2,a5,10e8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    10be:	07500793          	li	a5,117
    10c2:	06f60963          	beq	a2,a5,1134 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    10c6:	07800793          	li	a5,120
    10ca:	faf61ee3          	bne	a2,a5,1086 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10ce:	008b8913          	addi	s2,s7,8
    10d2:	4681                	li	a3,0
    10d4:	4641                	li	a2,16
    10d6:	000ba583          	lw	a1,0(s7)
    10da:	855a                	mv	a0,s6
    10dc:	e11ff0ef          	jal	eec <printint>
        i += 2;
    10e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    10e2:	8bca                	mv	s7,s2
      state = 0;
    10e4:	4981                	li	s3,0
        i += 2;
    10e6:	bde5                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    10e8:	008b8913          	addi	s2,s7,8
    10ec:	4685                	li	a3,1
    10ee:	4629                	li	a2,10
    10f0:	000ba583          	lw	a1,0(s7)
    10f4:	855a                	mv	a0,s6
    10f6:	df7ff0ef          	jal	eec <printint>
        i += 2;
    10fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    10fc:	8bca                	mv	s7,s2
      state = 0;
    10fe:	4981                	li	s3,0
        i += 2;
    1100:	bdf9                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1102:	008b8913          	addi	s2,s7,8
    1106:	4681                	li	a3,0
    1108:	4629                	li	a2,10
    110a:	000ba583          	lw	a1,0(s7)
    110e:	855a                	mv	a0,s6
    1110:	dddff0ef          	jal	eec <printint>
    1114:	8bca                	mv	s7,s2
      state = 0;
    1116:	4981                	li	s3,0
    1118:	b5d9                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    111a:	008b8913          	addi	s2,s7,8
    111e:	4681                	li	a3,0
    1120:	4629                	li	a2,10
    1122:	000ba583          	lw	a1,0(s7)
    1126:	855a                	mv	a0,s6
    1128:	dc5ff0ef          	jal	eec <printint>
        i += 1;
    112c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    112e:	8bca                	mv	s7,s2
      state = 0;
    1130:	4981                	li	s3,0
        i += 1;
    1132:	b575                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1134:	008b8913          	addi	s2,s7,8
    1138:	4681                	li	a3,0
    113a:	4629                	li	a2,10
    113c:	000ba583          	lw	a1,0(s7)
    1140:	855a                	mv	a0,s6
    1142:	dabff0ef          	jal	eec <printint>
        i += 2;
    1146:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1148:	8bca                	mv	s7,s2
      state = 0;
    114a:	4981                	li	s3,0
        i += 2;
    114c:	bd49                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    114e:	008b8913          	addi	s2,s7,8
    1152:	4681                	li	a3,0
    1154:	4641                	li	a2,16
    1156:	000ba583          	lw	a1,0(s7)
    115a:	855a                	mv	a0,s6
    115c:	d91ff0ef          	jal	eec <printint>
    1160:	8bca                	mv	s7,s2
      state = 0;
    1162:	4981                	li	s3,0
    1164:	bdad                	j	fde <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1166:	008b8913          	addi	s2,s7,8
    116a:	4681                	li	a3,0
    116c:	4641                	li	a2,16
    116e:	000ba583          	lw	a1,0(s7)
    1172:	855a                	mv	a0,s6
    1174:	d79ff0ef          	jal	eec <printint>
        i += 1;
    1178:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    117a:	8bca                	mv	s7,s2
      state = 0;
    117c:	4981                	li	s3,0
        i += 1;
    117e:	b585                	j	fde <vprintf+0x4a>
    1180:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1182:	008b8d13          	addi	s10,s7,8
    1186:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    118a:	03000593          	li	a1,48
    118e:	855a                	mv	a0,s6
    1190:	d3fff0ef          	jal	ece <putc>
  putc(fd, 'x');
    1194:	07800593          	li	a1,120
    1198:	855a                	mv	a0,s6
    119a:	d35ff0ef          	jal	ece <putc>
    119e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11a0:	00000b97          	auipc	s7,0x0
    11a4:	3f0b8b93          	addi	s7,s7,1008 # 1590 <digits>
    11a8:	03c9d793          	srli	a5,s3,0x3c
    11ac:	97de                	add	a5,a5,s7
    11ae:	0007c583          	lbu	a1,0(a5)
    11b2:	855a                	mv	a0,s6
    11b4:	d1bff0ef          	jal	ece <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11b8:	0992                	slli	s3,s3,0x4
    11ba:	397d                	addiw	s2,s2,-1
    11bc:	fe0916e3          	bnez	s2,11a8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    11c0:	8bea                	mv	s7,s10
      state = 0;
    11c2:	4981                	li	s3,0
    11c4:	6d02                	ld	s10,0(sp)
    11c6:	bd21                	j	fde <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    11c8:	008b8993          	addi	s3,s7,8
    11cc:	000bb903          	ld	s2,0(s7)
    11d0:	00090f63          	beqz	s2,11ee <vprintf+0x25a>
        for(; *s; s++)
    11d4:	00094583          	lbu	a1,0(s2)
    11d8:	c195                	beqz	a1,11fc <vprintf+0x268>
          putc(fd, *s);
    11da:	855a                	mv	a0,s6
    11dc:	cf3ff0ef          	jal	ece <putc>
        for(; *s; s++)
    11e0:	0905                	addi	s2,s2,1
    11e2:	00094583          	lbu	a1,0(s2)
    11e6:	f9f5                	bnez	a1,11da <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    11e8:	8bce                	mv	s7,s3
      state = 0;
    11ea:	4981                	li	s3,0
    11ec:	bbcd                	j	fde <vprintf+0x4a>
          s = "(null)";
    11ee:	00000917          	auipc	s2,0x0
    11f2:	36a90913          	addi	s2,s2,874 # 1558 <malloc+0x25e>
        for(; *s; s++)
    11f6:	02800593          	li	a1,40
    11fa:	b7c5                	j	11da <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    11fc:	8bce                	mv	s7,s3
      state = 0;
    11fe:	4981                	li	s3,0
    1200:	bbf9                	j	fde <vprintf+0x4a>
    1202:	64a6                	ld	s1,72(sp)
    1204:	79e2                	ld	s3,56(sp)
    1206:	7a42                	ld	s4,48(sp)
    1208:	7aa2                	ld	s5,40(sp)
    120a:	7b02                	ld	s6,32(sp)
    120c:	6be2                	ld	s7,24(sp)
    120e:	6c42                	ld	s8,16(sp)
    1210:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1212:	60e6                	ld	ra,88(sp)
    1214:	6446                	ld	s0,80(sp)
    1216:	6906                	ld	s2,64(sp)
    1218:	6125                	addi	sp,sp,96
    121a:	8082                	ret

000000000000121c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    121c:	715d                	addi	sp,sp,-80
    121e:	ec06                	sd	ra,24(sp)
    1220:	e822                	sd	s0,16(sp)
    1222:	1000                	addi	s0,sp,32
    1224:	e010                	sd	a2,0(s0)
    1226:	e414                	sd	a3,8(s0)
    1228:	e818                	sd	a4,16(s0)
    122a:	ec1c                	sd	a5,24(s0)
    122c:	03043023          	sd	a6,32(s0)
    1230:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1234:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1238:	8622                	mv	a2,s0
    123a:	d5bff0ef          	jal	f94 <vprintf>
}
    123e:	60e2                	ld	ra,24(sp)
    1240:	6442                	ld	s0,16(sp)
    1242:	6161                	addi	sp,sp,80
    1244:	8082                	ret

0000000000001246 <printf>:

void
printf(const char *fmt, ...)
{
    1246:	711d                	addi	sp,sp,-96
    1248:	ec06                	sd	ra,24(sp)
    124a:	e822                	sd	s0,16(sp)
    124c:	1000                	addi	s0,sp,32
    124e:	e40c                	sd	a1,8(s0)
    1250:	e810                	sd	a2,16(s0)
    1252:	ec14                	sd	a3,24(s0)
    1254:	f018                	sd	a4,32(s0)
    1256:	f41c                	sd	a5,40(s0)
    1258:	03043823          	sd	a6,48(s0)
    125c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1260:	00840613          	addi	a2,s0,8
    1264:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1268:	85aa                	mv	a1,a0
    126a:	4505                	li	a0,1
    126c:	d29ff0ef          	jal	f94 <vprintf>
}
    1270:	60e2                	ld	ra,24(sp)
    1272:	6442                	ld	s0,16(sp)
    1274:	6125                	addi	sp,sp,96
    1276:	8082                	ret

0000000000001278 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1278:	1141                	addi	sp,sp,-16
    127a:	e422                	sd	s0,8(sp)
    127c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    127e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1282:	00001797          	auipc	a5,0x1
    1286:	d8e7b783          	ld	a5,-626(a5) # 2010 <freep>
    128a:	a02d                	j	12b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    128c:	4618                	lw	a4,8(a2)
    128e:	9f2d                	addw	a4,a4,a1
    1290:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1294:	6398                	ld	a4,0(a5)
    1296:	6310                	ld	a2,0(a4)
    1298:	a83d                	j	12d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    129a:	ff852703          	lw	a4,-8(a0)
    129e:	9f31                	addw	a4,a4,a2
    12a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    12a2:	ff053683          	ld	a3,-16(a0)
    12a6:	a091                	j	12ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12a8:	6398                	ld	a4,0(a5)
    12aa:	00e7e463          	bltu	a5,a4,12b2 <free+0x3a>
    12ae:	00e6ea63          	bltu	a3,a4,12c2 <free+0x4a>
{
    12b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12b4:	fed7fae3          	bgeu	a5,a3,12a8 <free+0x30>
    12b8:	6398                	ld	a4,0(a5)
    12ba:	00e6e463          	bltu	a3,a4,12c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12be:	fee7eae3          	bltu	a5,a4,12b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    12c2:	ff852583          	lw	a1,-8(a0)
    12c6:	6390                	ld	a2,0(a5)
    12c8:	02059813          	slli	a6,a1,0x20
    12cc:	01c85713          	srli	a4,a6,0x1c
    12d0:	9736                	add	a4,a4,a3
    12d2:	fae60de3          	beq	a2,a4,128c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    12d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12da:	4790                	lw	a2,8(a5)
    12dc:	02061593          	slli	a1,a2,0x20
    12e0:	01c5d713          	srli	a4,a1,0x1c
    12e4:	973e                	add	a4,a4,a5
    12e6:	fae68ae3          	beq	a3,a4,129a <free+0x22>
    p->s.ptr = bp->s.ptr;
    12ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    12ec:	00001717          	auipc	a4,0x1
    12f0:	d2f73223          	sd	a5,-732(a4) # 2010 <freep>
}
    12f4:	6422                	ld	s0,8(sp)
    12f6:	0141                	addi	sp,sp,16
    12f8:	8082                	ret

00000000000012fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12fa:	7139                	addi	sp,sp,-64
    12fc:	fc06                	sd	ra,56(sp)
    12fe:	f822                	sd	s0,48(sp)
    1300:	f426                	sd	s1,40(sp)
    1302:	ec4e                	sd	s3,24(sp)
    1304:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1306:	02051493          	slli	s1,a0,0x20
    130a:	9081                	srli	s1,s1,0x20
    130c:	04bd                	addi	s1,s1,15
    130e:	8091                	srli	s1,s1,0x4
    1310:	0014899b          	addiw	s3,s1,1
    1314:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1316:	00001517          	auipc	a0,0x1
    131a:	cfa53503          	ld	a0,-774(a0) # 2010 <freep>
    131e:	c915                	beqz	a0,1352 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1320:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1322:	4798                	lw	a4,8(a5)
    1324:	08977a63          	bgeu	a4,s1,13b8 <malloc+0xbe>
    1328:	f04a                	sd	s2,32(sp)
    132a:	e852                	sd	s4,16(sp)
    132c:	e456                	sd	s5,8(sp)
    132e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1330:	8a4e                	mv	s4,s3
    1332:	0009871b          	sext.w	a4,s3
    1336:	6685                	lui	a3,0x1
    1338:	00d77363          	bgeu	a4,a3,133e <malloc+0x44>
    133c:	6a05                	lui	s4,0x1
    133e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1342:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1346:	00001917          	auipc	s2,0x1
    134a:	cca90913          	addi	s2,s2,-822 # 2010 <freep>
  if(p == (char*)-1)
    134e:	5afd                	li	s5,-1
    1350:	a081                	j	1390 <malloc+0x96>
    1352:	f04a                	sd	s2,32(sp)
    1354:	e852                	sd	s4,16(sp)
    1356:	e456                	sd	s5,8(sp)
    1358:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    135a:	00001797          	auipc	a5,0x1
    135e:	d2e78793          	addi	a5,a5,-722 # 2088 <base>
    1362:	00001717          	auipc	a4,0x1
    1366:	caf73723          	sd	a5,-850(a4) # 2010 <freep>
    136a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    136c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1370:	b7c1                	j	1330 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1372:	6398                	ld	a4,0(a5)
    1374:	e118                	sd	a4,0(a0)
    1376:	a8a9                	j	13d0 <malloc+0xd6>
  hp->s.size = nu;
    1378:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    137c:	0541                	addi	a0,a0,16
    137e:	efbff0ef          	jal	1278 <free>
  return freep;
    1382:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1386:	c12d                	beqz	a0,13e8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1388:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    138a:	4798                	lw	a4,8(a5)
    138c:	02977263          	bgeu	a4,s1,13b0 <malloc+0xb6>
    if(p == freep)
    1390:	00093703          	ld	a4,0(s2)
    1394:	853e                	mv	a0,a5
    1396:	fef719e3          	bne	a4,a5,1388 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    139a:	8552                	mv	a0,s4
    139c:	b1bff0ef          	jal	eb6 <sbrk>
  if(p == (char*)-1)
    13a0:	fd551ce3          	bne	a0,s5,1378 <malloc+0x7e>
        return 0;
    13a4:	4501                	li	a0,0
    13a6:	7902                	ld	s2,32(sp)
    13a8:	6a42                	ld	s4,16(sp)
    13aa:	6aa2                	ld	s5,8(sp)
    13ac:	6b02                	ld	s6,0(sp)
    13ae:	a03d                	j	13dc <malloc+0xe2>
    13b0:	7902                	ld	s2,32(sp)
    13b2:	6a42                	ld	s4,16(sp)
    13b4:	6aa2                	ld	s5,8(sp)
    13b6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    13b8:	fae48de3          	beq	s1,a4,1372 <malloc+0x78>
        p->s.size -= nunits;
    13bc:	4137073b          	subw	a4,a4,s3
    13c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13c2:	02071693          	slli	a3,a4,0x20
    13c6:	01c6d713          	srli	a4,a3,0x1c
    13ca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13cc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13d0:	00001717          	auipc	a4,0x1
    13d4:	c4a73023          	sd	a0,-960(a4) # 2010 <freep>
      return (void*)(p + 1);
    13d8:	01078513          	addi	a0,a5,16
  }
}
    13dc:	70e2                	ld	ra,56(sp)
    13de:	7442                	ld	s0,48(sp)
    13e0:	74a2                	ld	s1,40(sp)
    13e2:	69e2                	ld	s3,24(sp)
    13e4:	6121                	addi	sp,sp,64
    13e6:	8082                	ret
    13e8:	7902                	ld	s2,32(sp)
    13ea:	6a42                	ld	s4,16(sp)
    13ec:	6aa2                	ld	s5,8(sp)
    13ee:	6b02                	ld	s6,0(sp)
    13f0:	b7f5                	j	13dc <malloc+0xe2>
