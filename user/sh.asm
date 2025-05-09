
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
      16:	3de58593          	addi	a1,a1,990 # 13f0 <malloc+0x106>
      1a:	4509                	li	a0,2
      1c:	61b000ef          	jal	e36 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	40b000ef          	jal	c30 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	449000ef          	jal	c76 <gets>
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
      58:	3ac58593          	addi	a1,a1,940 # 1400 <malloc+0x116>
      5c:	4509                	li	a0,2
      5e:	1ae010ef          	jal	120c <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	5b3000ef          	jal	e16 <exit>

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
      70:	59f000ef          	jal	e0e <fork>
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
      86:	38e50513          	addi	a0,a0,910 # 1410 <malloc+0x126>
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
      c4:	48070713          	addi	a4,a4,1152 # 1540 <malloc+0x256>
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
      f6:	521000ef          	jal	e16 <exit>
      fa:	43513c23          	sd	s5,1080(sp)
      fe:	43613823          	sd	s6,1072(sp)
     102:	43713423          	sd	s7,1064(sp)
     106:	43813023          	sd	s8,1056(sp)
     10a:	41913c23          	sd	s9,1048(sp)
    panic("runcmd");
     10e:	00001517          	auipc	a0,0x1
     112:	30a50513          	addi	a0,a0,778 # 1418 <malloc+0x12e>
     116:	f35ff0ef          	jal	4a <panic>
    if (ecmd->argv[0] == 0){exit(1);}
     11a:	00853983          	ld	s3,8(a0)
     11e:	04098763          	beqz	s3,16c <runcmd+0xde>
    if (ecmd->argv[0] && strcmp(ecmd->argv[0], "!") == 0) {
     122:	00001597          	auipc	a1,0x1
     126:	2fe58593          	addi	a1,a1,766 # 1420 <malloc+0x136>
     12a:	854e                	mv	a0,s3
     12c:	2af000ef          	jal	bda <strcmp>
     130:	8a2a                	mv	s4,a0
     132:	10051663          	bnez	a0,23e <runcmd+0x1b0>
     136:	43513c23          	sd	s5,1080(sp)
     13a:	43613823          	sd	s6,1072(sp)
     13e:	43713423          	sd	s7,1064(sp)
     142:	43813023          	sd	s8,1056(sp)
     146:	41913c23          	sd	s9,1048(sp)
        char buf[1024] = {0};
     14a:	40000613          	li	a2,1024
     14e:	4581                	li	a1,0
     150:	b9840513          	addi	a0,s0,-1128
     154:	2dd000ef          	jal	c30 <memset>
        for (int i = 1; ecmd->argv[i] != 0; i++) {
     158:	6888                	ld	a0,16(s1)
     15a:	c969                	beqz	a0,22c <runcmd+0x19e>
     15c:	04c1                	addi	s1,s1,16
        int len = 0;
     15e:	8ad2                	mv	s5,s4
            if (len + arglen >= sizeof(buf)) {
     160:	3ff00b13          	li	s6,1023
            if (i > 1)
     164:	4b85                	li	s7,1
                buf[len++] = ' ';
     166:	02000c13          	li	s8,32
     16a:	a03d                	j	198 <runcmd+0x10a>
     16c:	43513c23          	sd	s5,1080(sp)
     170:	43613823          	sd	s6,1072(sp)
     174:	43713423          	sd	s7,1064(sp)
     178:	43813023          	sd	s8,1056(sp)
     17c:	41913c23          	sd	s9,1048(sp)
    if (ecmd->argv[0] == 0){exit(1);}
     180:	4505                	li	a0,1
     182:	495000ef          	jal	e16 <exit>
                buf[len++] = ' ';
     186:	fa0c8793          	addi	a5,s9,-96
     18a:	00878cb3          	add	s9,a5,s0
     18e:	bf8c8c23          	sb	s8,-1032(s9)
     192:	00198c9b          	addiw	s9,s3,1
     196:	8ae6                	mv	s5,s9
            int arglen = strlen(ecmd->argv[i]);
     198:	26f000ef          	jal	c06 <strlen>
            if (len + arglen >= sizeof(buf)) {
     19c:	015509bb          	addw	s3,a0,s5
     1a0:	00098c9b          	sext.w	s9,s3
     1a4:	039b6063          	bltu	s6,s9,1c4 <runcmd+0x136>
            strcpy(buf + len, ecmd->argv[i]);
     1a8:	608c                	ld	a1,0(s1)
     1aa:	b9840793          	addi	a5,s0,-1128
     1ae:	01578533          	add	a0,a5,s5
     1b2:	20d000ef          	jal	bbe <strcpy>
        for (int i = 1; ecmd->argv[i] != 0; i++) {
     1b6:	2905                	addiw	s2,s2,1
     1b8:	04a1                	addi	s1,s1,8
     1ba:	6088                	ld	a0,0(s1)
     1bc:	cd09                	beqz	a0,1d6 <runcmd+0x148>
            if (i > 1)
     1be:	fd2bc4e3          	blt	s7,s2,186 <runcmd+0xf8>
     1c2:	bfd1                	j	196 <runcmd+0x108>
                printf("Message too long\n");
     1c4:	00001517          	auipc	a0,0x1
     1c8:	26450513          	addi	a0,a0,612 # 1428 <malloc+0x13e>
     1cc:	06a010ef          	jal	1236 <printf>
                exit(1);
     1d0:	4505                	li	a0,1
     1d2:	445000ef          	jal	e16 <exit>
            if (i + 1 < len && buf[i] == 'o' && buf[i+1] == 's') {
     1d6:	06f00913          	li	s2,111
     1da:	07300993          	li	s3,115
     1de:	a811                	j	1f2 <runcmd+0x164>
               write(1, &buf[i], 1);
     1e0:	4605                	li	a2,1
     1e2:	b9840793          	addi	a5,s0,-1128
     1e6:	014785b3          	add	a1,a5,s4
     1ea:	4505                	li	a0,1
     1ec:	44b000ef          	jal	e36 <write>
        int len = 0;
     1f0:	8a26                	mv	s4,s1
        for (int i = 0; i < len; ) {
     1f2:	039a5d63          	bge	s4,s9,22c <runcmd+0x19e>
            if (i + 1 < len && buf[i] == 'o' && buf[i+1] == 's') {
     1f6:	001a049b          	addiw	s1,s4,1
     1fa:	ff94d3e3          	bge	s1,s9,1e0 <runcmd+0x152>
     1fe:	fa0a0793          	addi	a5,s4,-96
     202:	97a2                	add	a5,a5,s0
     204:	bf87c783          	lbu	a5,-1032(a5)
     208:	fd279ce3          	bne	a5,s2,1e0 <runcmd+0x152>
     20c:	fa048793          	addi	a5,s1,-96
     210:	97a2                	add	a5,a5,s0
     212:	bf87c783          	lbu	a5,-1032(a5)
     216:	fd3795e3          	bne	a5,s3,1e0 <runcmd+0x152>
                printf("\033[34mos\033[0m");
     21a:	00001517          	auipc	a0,0x1
     21e:	22650513          	addi	a0,a0,550 # 1440 <malloc+0x156>
     222:	014010ef          	jal	1236 <printf>
                i += 2;
     226:	002a049b          	addiw	s1,s4,2
     22a:	b7d9                	j	1f0 <runcmd+0x162>
        printf("\n");
     22c:	00001517          	auipc	a0,0x1
     230:	20c50513          	addi	a0,a0,524 # 1438 <malloc+0x14e>
     234:	002010ef          	jal	1236 <printf>
        exit(0);
     238:	4501                	li	a0,0
     23a:	3dd000ef          	jal	e16 <exit>
    exec(ecmd->argv[0], ecmd->argv);
     23e:	00848593          	addi	a1,s1,8
     242:	854e                	mv	a0,s3
     244:	40b000ef          	jal	e4e <exec>
    printf("exec %s failed\n", ecmd->argv[0]);
     248:	648c                	ld	a1,8(s1)
     24a:	00001517          	auipc	a0,0x1
     24e:	20650513          	addi	a0,a0,518 # 1450 <malloc+0x166>
     252:	7e5000ef          	jal	1236 <printf>
    break;
     256:	a28d                	j	3b8 <runcmd+0x32a>
    close(rcmd->fd);
     258:	5148                	lw	a0,36(a0)
     25a:	3e5000ef          	jal	e3e <close>
    if (open(rcmd->file, rcmd->mode) < 0)
     25e:	508c                	lw	a1,32(s1)
     260:	6888                	ld	a0,16(s1)
     262:	3f5000ef          	jal	e56 <open>
     266:	00054f63          	bltz	a0,284 <runcmd+0x1f6>
     26a:	43513c23          	sd	s5,1080(sp)
     26e:	43613823          	sd	s6,1072(sp)
     272:	43713423          	sd	s7,1064(sp)
     276:	43813023          	sd	s8,1056(sp)
     27a:	41913c23          	sd	s9,1048(sp)
    runcmd(rcmd->cmd);
     27e:	6488                	ld	a0,8(s1)
     280:	e0fff0ef          	jal	8e <runcmd>
     284:	43513c23          	sd	s5,1080(sp)
     288:	43613823          	sd	s6,1072(sp)
     28c:	43713423          	sd	s7,1064(sp)
     290:	43813023          	sd	s8,1056(sp)
     294:	41913c23          	sd	s9,1048(sp)
      fprintf(2, "open %s failed\n", rcmd->file);
     298:	6890                	ld	a2,16(s1)
     29a:	00001597          	auipc	a1,0x1
     29e:	1c658593          	addi	a1,a1,454 # 1460 <malloc+0x176>
     2a2:	4509                	li	a0,2
     2a4:	769000ef          	jal	120c <fprintf>
      exit(1);
     2a8:	4505                	li	a0,1
     2aa:	36d000ef          	jal	e16 <exit>
    if (fork1() == 0)
     2ae:	dbbff0ef          	jal	68 <fork1>
     2b2:	ed11                	bnez	a0,2ce <runcmd+0x240>
     2b4:	43513c23          	sd	s5,1080(sp)
     2b8:	43613823          	sd	s6,1072(sp)
     2bc:	43713423          	sd	s7,1064(sp)
     2c0:	43813023          	sd	s8,1056(sp)
     2c4:	41913c23          	sd	s9,1048(sp)
      runcmd(lcmd->left);
     2c8:	6488                	ld	a0,8(s1)
     2ca:	dc5ff0ef          	jal	8e <runcmd>
     2ce:	43513c23          	sd	s5,1080(sp)
     2d2:	43613823          	sd	s6,1072(sp)
     2d6:	43713423          	sd	s7,1064(sp)
     2da:	43813023          	sd	s8,1056(sp)
     2de:	41913c23          	sd	s9,1048(sp)
    wait(0);
     2e2:	4501                	li	a0,0
     2e4:	33b000ef          	jal	e1e <wait>
    runcmd(lcmd->right);
     2e8:	6888                	ld	a0,16(s1)
     2ea:	da5ff0ef          	jal	8e <runcmd>
    if (pipe(p) < 0)
     2ee:	f9840513          	addi	a0,s0,-104
     2f2:	335000ef          	jal	e26 <pipe>
     2f6:	04054163          	bltz	a0,338 <runcmd+0x2aa>
    if (fork1() == 0)
     2fa:	d6fff0ef          	jal	68 <fork1>
     2fe:	ed29                	bnez	a0,358 <runcmd+0x2ca>
     300:	43513c23          	sd	s5,1080(sp)
     304:	43613823          	sd	s6,1072(sp)
     308:	43713423          	sd	s7,1064(sp)
     30c:	43813023          	sd	s8,1056(sp)
     310:	41913c23          	sd	s9,1048(sp)
      close(1);
     314:	4505                	li	a0,1
     316:	329000ef          	jal	e3e <close>
      dup(p[1]);
     31a:	f9c42503          	lw	a0,-100(s0)
     31e:	371000ef          	jal	e8e <dup>
      close(p[0]);
     322:	f9842503          	lw	a0,-104(s0)
     326:	319000ef          	jal	e3e <close>
      close(p[1]);
     32a:	f9c42503          	lw	a0,-100(s0)
     32e:	311000ef          	jal	e3e <close>
      runcmd(pcmd->left);
     332:	6488                	ld	a0,8(s1)
     334:	d5bff0ef          	jal	8e <runcmd>
     338:	43513c23          	sd	s5,1080(sp)
     33c:	43613823          	sd	s6,1072(sp)
     340:	43713423          	sd	s7,1064(sp)
     344:	43813023          	sd	s8,1056(sp)
     348:	41913c23          	sd	s9,1048(sp)
      panic("pipe");
     34c:	00001517          	auipc	a0,0x1
     350:	12450513          	addi	a0,a0,292 # 1470 <malloc+0x186>
     354:	cf7ff0ef          	jal	4a <panic>
    if (fork1() == 0)
     358:	d11ff0ef          	jal	68 <fork1>
     35c:	ed05                	bnez	a0,394 <runcmd+0x306>
     35e:	43513c23          	sd	s5,1080(sp)
     362:	43613823          	sd	s6,1072(sp)
     366:	43713423          	sd	s7,1064(sp)
     36a:	43813023          	sd	s8,1056(sp)
     36e:	41913c23          	sd	s9,1048(sp)
      close(0);
     372:	2cd000ef          	jal	e3e <close>
      dup(p[0]);
     376:	f9842503          	lw	a0,-104(s0)
     37a:	315000ef          	jal	e8e <dup>
      close(p[0]);
     37e:	f9842503          	lw	a0,-104(s0)
     382:	2bd000ef          	jal	e3e <close>
      close(p[1]);
     386:	f9c42503          	lw	a0,-100(s0)
     38a:	2b5000ef          	jal	e3e <close>
      runcmd(pcmd->right);
     38e:	6888                	ld	a0,16(s1)
     390:	cffff0ef          	jal	8e <runcmd>
    close(p[0]);
     394:	f9842503          	lw	a0,-104(s0)
     398:	2a7000ef          	jal	e3e <close>
    close(p[1]);
     39c:	f9c42503          	lw	a0,-100(s0)
     3a0:	29f000ef          	jal	e3e <close>
    wait(0);
     3a4:	4501                	li	a0,0
     3a6:	279000ef          	jal	e1e <wait>
    wait(0);
     3aa:	4501                	li	a0,0
     3ac:	273000ef          	jal	e1e <wait>
    break;
     3b0:	a021                	j	3b8 <runcmd+0x32a>
    if (fork1() == 0)
     3b2:	cb7ff0ef          	jal	68 <fork1>
     3b6:	cd11                	beqz	a0,3d2 <runcmd+0x344>
     3b8:	43513c23          	sd	s5,1080(sp)
     3bc:	43613823          	sd	s6,1072(sp)
     3c0:	43713423          	sd	s7,1064(sp)
     3c4:	43813023          	sd	s8,1056(sp)
     3c8:	41913c23          	sd	s9,1048(sp)
  exit(0);
     3cc:	4501                	li	a0,0
     3ce:	249000ef          	jal	e16 <exit>
     3d2:	43513c23          	sd	s5,1080(sp)
     3d6:	43613823          	sd	s6,1072(sp)
     3da:	43713423          	sd	s7,1064(sp)
     3de:	43813023          	sd	s8,1056(sp)
     3e2:	41913c23          	sd	s9,1048(sp)
      runcmd(bcmd->cmd);
     3e6:	6488                	ld	a0,8(s1)
     3e8:	ca7ff0ef          	jal	8e <runcmd>

00000000000003ec <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     3ec:	1101                	addi	sp,sp,-32
     3ee:	ec06                	sd	ra,24(sp)
     3f0:	e822                	sd	s0,16(sp)
     3f2:	e426                	sd	s1,8(sp)
     3f4:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3f6:	0a800513          	li	a0,168
     3fa:	6f1000ef          	jal	12ea <malloc>
     3fe:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     400:	0a800613          	li	a2,168
     404:	4581                	li	a1,0
     406:	02b000ef          	jal	c30 <memset>
  cmd->type = EXEC;
     40a:	4785                	li	a5,1
     40c:	c09c                	sw	a5,0(s1)
  return (struct cmd *)cmd;
}
     40e:	8526                	mv	a0,s1
     410:	60e2                	ld	ra,24(sp)
     412:	6442                	ld	s0,16(sp)
     414:	64a2                	ld	s1,8(sp)
     416:	6105                	addi	sp,sp,32
     418:	8082                	ret

000000000000041a <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     41a:	7139                	addi	sp,sp,-64
     41c:	fc06                	sd	ra,56(sp)
     41e:	f822                	sd	s0,48(sp)
     420:	f426                	sd	s1,40(sp)
     422:	f04a                	sd	s2,32(sp)
     424:	ec4e                	sd	s3,24(sp)
     426:	e852                	sd	s4,16(sp)
     428:	e456                	sd	s5,8(sp)
     42a:	e05a                	sd	s6,0(sp)
     42c:	0080                	addi	s0,sp,64
     42e:	8b2a                	mv	s6,a0
     430:	8aae                	mv	s5,a1
     432:	8a32                	mv	s4,a2
     434:	89b6                	mv	s3,a3
     436:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     438:	02800513          	li	a0,40
     43c:	6af000ef          	jal	12ea <malloc>
     440:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     442:	02800613          	li	a2,40
     446:	4581                	li	a1,0
     448:	7e8000ef          	jal	c30 <memset>
  cmd->type = REDIR;
     44c:	4789                	li	a5,2
     44e:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     450:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     454:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     458:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     45c:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     460:	0324a223          	sw	s2,36(s1)
  return (struct cmd *)cmd;
}
     464:	8526                	mv	a0,s1
     466:	70e2                	ld	ra,56(sp)
     468:	7442                	ld	s0,48(sp)
     46a:	74a2                	ld	s1,40(sp)
     46c:	7902                	ld	s2,32(sp)
     46e:	69e2                	ld	s3,24(sp)
     470:	6a42                	ld	s4,16(sp)
     472:	6aa2                	ld	s5,8(sp)
     474:	6b02                	ld	s6,0(sp)
     476:	6121                	addi	sp,sp,64
     478:	8082                	ret

000000000000047a <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     47a:	7179                	addi	sp,sp,-48
     47c:	f406                	sd	ra,40(sp)
     47e:	f022                	sd	s0,32(sp)
     480:	ec26                	sd	s1,24(sp)
     482:	e84a                	sd	s2,16(sp)
     484:	e44e                	sd	s3,8(sp)
     486:	1800                	addi	s0,sp,48
     488:	89aa                	mv	s3,a0
     48a:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     48c:	4561                	li	a0,24
     48e:	65d000ef          	jal	12ea <malloc>
     492:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     494:	4661                	li	a2,24
     496:	4581                	li	a1,0
     498:	798000ef          	jal	c30 <memset>
  cmd->type = PIPE;
     49c:	478d                	li	a5,3
     49e:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4a0:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4a4:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     4a8:	8526                	mv	a0,s1
     4aa:	70a2                	ld	ra,40(sp)
     4ac:	7402                	ld	s0,32(sp)
     4ae:	64e2                	ld	s1,24(sp)
     4b0:	6942                	ld	s2,16(sp)
     4b2:	69a2                	ld	s3,8(sp)
     4b4:	6145                	addi	sp,sp,48
     4b6:	8082                	ret

00000000000004b8 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     4b8:	7179                	addi	sp,sp,-48
     4ba:	f406                	sd	ra,40(sp)
     4bc:	f022                	sd	s0,32(sp)
     4be:	ec26                	sd	s1,24(sp)
     4c0:	e84a                	sd	s2,16(sp)
     4c2:	e44e                	sd	s3,8(sp)
     4c4:	1800                	addi	s0,sp,48
     4c6:	89aa                	mv	s3,a0
     4c8:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4ca:	4561                	li	a0,24
     4cc:	61f000ef          	jal	12ea <malloc>
     4d0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4d2:	4661                	li	a2,24
     4d4:	4581                	li	a1,0
     4d6:	75a000ef          	jal	c30 <memset>
  cmd->type = LIST;
     4da:	4791                	li	a5,4
     4dc:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4de:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4e2:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     4e6:	8526                	mv	a0,s1
     4e8:	70a2                	ld	ra,40(sp)
     4ea:	7402                	ld	s0,32(sp)
     4ec:	64e2                	ld	s1,24(sp)
     4ee:	6942                	ld	s2,16(sp)
     4f0:	69a2                	ld	s3,8(sp)
     4f2:	6145                	addi	sp,sp,48
     4f4:	8082                	ret

00000000000004f6 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     4f6:	1101                	addi	sp,sp,-32
     4f8:	ec06                	sd	ra,24(sp)
     4fa:	e822                	sd	s0,16(sp)
     4fc:	e426                	sd	s1,8(sp)
     4fe:	e04a                	sd	s2,0(sp)
     500:	1000                	addi	s0,sp,32
     502:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     504:	4541                	li	a0,16
     506:	5e5000ef          	jal	12ea <malloc>
     50a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     50c:	4641                	li	a2,16
     50e:	4581                	li	a1,0
     510:	720000ef          	jal	c30 <memset>
  cmd->type = BACK;
     514:	4795                	li	a5,5
     516:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     518:	0124b423          	sd	s2,8(s1)
  return (struct cmd *)cmd;
}
     51c:	8526                	mv	a0,s1
     51e:	60e2                	ld	ra,24(sp)
     520:	6442                	ld	s0,16(sp)
     522:	64a2                	ld	s1,8(sp)
     524:	6902                	ld	s2,0(sp)
     526:	6105                	addi	sp,sp,32
     528:	8082                	ret

000000000000052a <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     52a:	7139                	addi	sp,sp,-64
     52c:	fc06                	sd	ra,56(sp)
     52e:	f822                	sd	s0,48(sp)
     530:	f426                	sd	s1,40(sp)
     532:	f04a                	sd	s2,32(sp)
     534:	ec4e                	sd	s3,24(sp)
     536:	e852                	sd	s4,16(sp)
     538:	e456                	sd	s5,8(sp)
     53a:	e05a                	sd	s6,0(sp)
     53c:	0080                	addi	s0,sp,64
     53e:	8a2a                	mv	s4,a0
     540:	892e                	mv	s2,a1
     542:	8ab2                	mv	s5,a2
     544:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     546:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     548:	00002997          	auipc	s3,0x2
     54c:	ac098993          	addi	s3,s3,-1344 # 2008 <whitespace>
     550:	00b4fc63          	bgeu	s1,a1,568 <gettoken+0x3e>
     554:	0004c583          	lbu	a1,0(s1)
     558:	854e                	mv	a0,s3
     55a:	6f8000ef          	jal	c52 <strchr>
     55e:	c509                	beqz	a0,568 <gettoken+0x3e>
    s++;
     560:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     562:	fe9919e3          	bne	s2,s1,554 <gettoken+0x2a>
     566:	84ca                	mv	s1,s2
  if (q)
     568:	000a8463          	beqz	s5,570 <gettoken+0x46>
    *q = s;
     56c:	009ab023          	sd	s1,0(s5)
  ret = *s;
     570:	0004c783          	lbu	a5,0(s1)
     574:	00078a9b          	sext.w	s5,a5
  switch (*s)
     578:	03c00713          	li	a4,60
     57c:	06f76463          	bltu	a4,a5,5e4 <gettoken+0xba>
     580:	03a00713          	li	a4,58
     584:	00f76e63          	bltu	a4,a5,5a0 <gettoken+0x76>
     588:	cf89                	beqz	a5,5a2 <gettoken+0x78>
     58a:	02600713          	li	a4,38
     58e:	00e78963          	beq	a5,a4,5a0 <gettoken+0x76>
     592:	fd87879b          	addiw	a5,a5,-40
     596:	0ff7f793          	zext.b	a5,a5
     59a:	4705                	li	a4,1
     59c:	06f76b63          	bltu	a4,a5,612 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5a0:	0485                	addi	s1,s1,1
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     5a2:	000b0463          	beqz	s6,5aa <gettoken+0x80>
    *eq = s;
     5a6:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
     5aa:	00002997          	auipc	s3,0x2
     5ae:	a5e98993          	addi	s3,s3,-1442 # 2008 <whitespace>
     5b2:	0124fc63          	bgeu	s1,s2,5ca <gettoken+0xa0>
     5b6:	0004c583          	lbu	a1,0(s1)
     5ba:	854e                	mv	a0,s3
     5bc:	696000ef          	jal	c52 <strchr>
     5c0:	c509                	beqz	a0,5ca <gettoken+0xa0>
    s++;
     5c2:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     5c4:	fe9919e3          	bne	s2,s1,5b6 <gettoken+0x8c>
     5c8:	84ca                	mv	s1,s2
  *ps = s;
     5ca:	009a3023          	sd	s1,0(s4)
  return ret;
}
     5ce:	8556                	mv	a0,s5
     5d0:	70e2                	ld	ra,56(sp)
     5d2:	7442                	ld	s0,48(sp)
     5d4:	74a2                	ld	s1,40(sp)
     5d6:	7902                	ld	s2,32(sp)
     5d8:	69e2                	ld	s3,24(sp)
     5da:	6a42                	ld	s4,16(sp)
     5dc:	6aa2                	ld	s5,8(sp)
     5de:	6b02                	ld	s6,0(sp)
     5e0:	6121                	addi	sp,sp,64
     5e2:	8082                	ret
  switch (*s)
     5e4:	03e00713          	li	a4,62
     5e8:	02e79163          	bne	a5,a4,60a <gettoken+0xe0>
    s++;
     5ec:	00148693          	addi	a3,s1,1
    if (*s == '>')
     5f0:	0014c703          	lbu	a4,1(s1)
     5f4:	03e00793          	li	a5,62
      s++;
     5f8:	0489                	addi	s1,s1,2
      ret = '+';
     5fa:	02b00a93          	li	s5,43
    if (*s == '>')
     5fe:	faf702e3          	beq	a4,a5,5a2 <gettoken+0x78>
    s++;
     602:	84b6                	mv	s1,a3
  ret = *s;
     604:	03e00a93          	li	s5,62
     608:	bf69                	j	5a2 <gettoken+0x78>
  switch (*s)
     60a:	07c00713          	li	a4,124
     60e:	f8e789e3          	beq	a5,a4,5a0 <gettoken+0x76>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     612:	00002997          	auipc	s3,0x2
     616:	9f698993          	addi	s3,s3,-1546 # 2008 <whitespace>
     61a:	00002a97          	auipc	s5,0x2
     61e:	9e6a8a93          	addi	s5,s5,-1562 # 2000 <symbols>
     622:	0324fd63          	bgeu	s1,s2,65c <gettoken+0x132>
     626:	0004c583          	lbu	a1,0(s1)
     62a:	854e                	mv	a0,s3
     62c:	626000ef          	jal	c52 <strchr>
     630:	e11d                	bnez	a0,656 <gettoken+0x12c>
     632:	0004c583          	lbu	a1,0(s1)
     636:	8556                	mv	a0,s5
     638:	61a000ef          	jal	c52 <strchr>
     63c:	e911                	bnez	a0,650 <gettoken+0x126>
      s++;
     63e:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     640:	fe9913e3          	bne	s2,s1,626 <gettoken+0xfc>
  if (eq)
     644:	84ca                	mv	s1,s2
    ret = 'a';
     646:	06100a93          	li	s5,97
  if (eq)
     64a:	f40b1ee3          	bnez	s6,5a6 <gettoken+0x7c>
     64e:	bfb5                	j	5ca <gettoken+0xa0>
    ret = 'a';
     650:	06100a93          	li	s5,97
     654:	b7b9                	j	5a2 <gettoken+0x78>
     656:	06100a93          	li	s5,97
     65a:	b7a1                	j	5a2 <gettoken+0x78>
     65c:	06100a93          	li	s5,97
  if (eq)
     660:	f40b13e3          	bnez	s6,5a6 <gettoken+0x7c>
     664:	b79d                	j	5ca <gettoken+0xa0>

0000000000000666 <peek>:

int peek(char **ps, char *es, char *toks)
{
     666:	7139                	addi	sp,sp,-64
     668:	fc06                	sd	ra,56(sp)
     66a:	f822                	sd	s0,48(sp)
     66c:	f426                	sd	s1,40(sp)
     66e:	f04a                	sd	s2,32(sp)
     670:	ec4e                	sd	s3,24(sp)
     672:	e852                	sd	s4,16(sp)
     674:	e456                	sd	s5,8(sp)
     676:	0080                	addi	s0,sp,64
     678:	8a2a                	mv	s4,a0
     67a:	892e                	mv	s2,a1
     67c:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     67e:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     680:	00002997          	auipc	s3,0x2
     684:	98898993          	addi	s3,s3,-1656 # 2008 <whitespace>
     688:	00b4fc63          	bgeu	s1,a1,6a0 <peek+0x3a>
     68c:	0004c583          	lbu	a1,0(s1)
     690:	854e                	mv	a0,s3
     692:	5c0000ef          	jal	c52 <strchr>
     696:	c509                	beqz	a0,6a0 <peek+0x3a>
    s++;
     698:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     69a:	fe9919e3          	bne	s2,s1,68c <peek+0x26>
     69e:	84ca                	mv	s1,s2
  *ps = s;
     6a0:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     6a4:	0004c583          	lbu	a1,0(s1)
     6a8:	4501                	li	a0,0
     6aa:	e991                	bnez	a1,6be <peek+0x58>
}
     6ac:	70e2                	ld	ra,56(sp)
     6ae:	7442                	ld	s0,48(sp)
     6b0:	74a2                	ld	s1,40(sp)
     6b2:	7902                	ld	s2,32(sp)
     6b4:	69e2                	ld	s3,24(sp)
     6b6:	6a42                	ld	s4,16(sp)
     6b8:	6aa2                	ld	s5,8(sp)
     6ba:	6121                	addi	sp,sp,64
     6bc:	8082                	ret
  return *s && strchr(toks, *s);
     6be:	8556                	mv	a0,s5
     6c0:	592000ef          	jal	c52 <strchr>
     6c4:	00a03533          	snez	a0,a0
     6c8:	b7d5                	j	6ac <peek+0x46>

00000000000006ca <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6ca:	711d                	addi	sp,sp,-96
     6cc:	ec86                	sd	ra,88(sp)
     6ce:	e8a2                	sd	s0,80(sp)
     6d0:	e4a6                	sd	s1,72(sp)
     6d2:	e0ca                	sd	s2,64(sp)
     6d4:	fc4e                	sd	s3,56(sp)
     6d6:	f852                	sd	s4,48(sp)
     6d8:	f456                	sd	s5,40(sp)
     6da:	f05a                	sd	s6,32(sp)
     6dc:	ec5e                	sd	s7,24(sp)
     6de:	1080                	addi	s0,sp,96
     6e0:	8a2a                	mv	s4,a0
     6e2:	89ae                	mv	s3,a1
     6e4:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>"))
     6e6:	00001a97          	auipc	s5,0x1
     6ea:	db2a8a93          	addi	s5,s5,-590 # 1498 <malloc+0x1ae>
  {
    tok = gettoken(ps, es, 0, 0);
    if (gettoken(ps, es, &q, &eq) != 'a')
     6ee:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch (tok)
     6f2:	03c00b93          	li	s7,60
  while (peek(ps, es, "<>"))
     6f6:	a00d                	j	718 <parseredirs+0x4e>
      panic("missing file for redirection");
     6f8:	00001517          	auipc	a0,0x1
     6fc:	d8050513          	addi	a0,a0,-640 # 1478 <malloc+0x18e>
     700:	94bff0ef          	jal	4a <panic>
    {
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     704:	4701                	li	a4,0
     706:	4681                	li	a3,0
     708:	fa043603          	ld	a2,-96(s0)
     70c:	fa843583          	ld	a1,-88(s0)
     710:	8552                	mv	a0,s4
     712:	d09ff0ef          	jal	41a <redircmd>
     716:	8a2a                	mv	s4,a0
  while (peek(ps, es, "<>"))
     718:	8656                	mv	a2,s5
     71a:	85ca                	mv	a1,s2
     71c:	854e                	mv	a0,s3
     71e:	f49ff0ef          	jal	666 <peek>
     722:	c525                	beqz	a0,78a <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     724:	4681                	li	a3,0
     726:	4601                	li	a2,0
     728:	85ca                	mv	a1,s2
     72a:	854e                	mv	a0,s3
     72c:	dffff0ef          	jal	52a <gettoken>
     730:	84aa                	mv	s1,a0
    if (gettoken(ps, es, &q, &eq) != 'a')
     732:	fa040693          	addi	a3,s0,-96
     736:	fa840613          	addi	a2,s0,-88
     73a:	85ca                	mv	a1,s2
     73c:	854e                	mv	a0,s3
     73e:	dedff0ef          	jal	52a <gettoken>
     742:	fb651be3          	bne	a0,s6,6f8 <parseredirs+0x2e>
    switch (tok)
     746:	fb748fe3          	beq	s1,s7,704 <parseredirs+0x3a>
     74a:	03e00793          	li	a5,62
     74e:	02f48263          	beq	s1,a5,772 <parseredirs+0xa8>
     752:	02b00793          	li	a5,43
     756:	fcf491e3          	bne	s1,a5,718 <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     75a:	4705                	li	a4,1
     75c:	20100693          	li	a3,513
     760:	fa043603          	ld	a2,-96(s0)
     764:	fa843583          	ld	a1,-88(s0)
     768:	8552                	mv	a0,s4
     76a:	cb1ff0ef          	jal	41a <redircmd>
     76e:	8a2a                	mv	s4,a0
      break;
     770:	b765                	j	718 <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     772:	4705                	li	a4,1
     774:	60100693          	li	a3,1537
     778:	fa043603          	ld	a2,-96(s0)
     77c:	fa843583          	ld	a1,-88(s0)
     780:	8552                	mv	a0,s4
     782:	c99ff0ef          	jal	41a <redircmd>
     786:	8a2a                	mv	s4,a0
      break;
     788:	bf41                	j	718 <parseredirs+0x4e>
    }
  }
  return cmd;
}
     78a:	8552                	mv	a0,s4
     78c:	60e6                	ld	ra,88(sp)
     78e:	6446                	ld	s0,80(sp)
     790:	64a6                	ld	s1,72(sp)
     792:	6906                	ld	s2,64(sp)
     794:	79e2                	ld	s3,56(sp)
     796:	7a42                	ld	s4,48(sp)
     798:	7aa2                	ld	s5,40(sp)
     79a:	7b02                	ld	s6,32(sp)
     79c:	6be2                	ld	s7,24(sp)
     79e:	6125                	addi	sp,sp,96
     7a0:	8082                	ret

00000000000007a2 <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     7a2:	7159                	addi	sp,sp,-112
     7a4:	f486                	sd	ra,104(sp)
     7a6:	f0a2                	sd	s0,96(sp)
     7a8:	eca6                	sd	s1,88(sp)
     7aa:	e0d2                	sd	s4,64(sp)
     7ac:	fc56                	sd	s5,56(sp)
     7ae:	1880                	addi	s0,sp,112
     7b0:	8a2a                	mv	s4,a0
     7b2:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     7b4:	00001617          	auipc	a2,0x1
     7b8:	cec60613          	addi	a2,a2,-788 # 14a0 <malloc+0x1b6>
     7bc:	eabff0ef          	jal	666 <peek>
     7c0:	e915                	bnez	a0,7f4 <parseexec+0x52>
     7c2:	e8ca                	sd	s2,80(sp)
     7c4:	e4ce                	sd	s3,72(sp)
     7c6:	f85a                	sd	s6,48(sp)
     7c8:	f45e                	sd	s7,40(sp)
     7ca:	f062                	sd	s8,32(sp)
     7cc:	ec66                	sd	s9,24(sp)
     7ce:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     7d0:	c1dff0ef          	jal	3ec <execcmd>
     7d4:	8c2a                	mv	s8,a0
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7d6:	8656                	mv	a2,s5
     7d8:	85d2                	mv	a1,s4
     7da:	ef1ff0ef          	jal	6ca <parseredirs>
     7de:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     7e0:	008c0913          	addi	s2,s8,8
     7e4:	00001b17          	auipc	s6,0x1
     7e8:	cdcb0b13          	addi	s6,s6,-804 # 14c0 <malloc+0x1d6>
  {
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
      break;
    if (tok != 'a')
     7ec:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
     7f0:	4ba9                	li	s7,10
  while (!peek(ps, es, "|)&;"))
     7f2:	a815                	j	826 <parseexec+0x84>
    return parseblock(ps, es);
     7f4:	85d6                	mv	a1,s5
     7f6:	8552                	mv	a0,s4
     7f8:	170000ef          	jal	968 <parseblock>
     7fc:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     7fe:	8526                	mv	a0,s1
     800:	70a6                	ld	ra,104(sp)
     802:	7406                	ld	s0,96(sp)
     804:	64e6                	ld	s1,88(sp)
     806:	6a06                	ld	s4,64(sp)
     808:	7ae2                	ld	s5,56(sp)
     80a:	6165                	addi	sp,sp,112
     80c:	8082                	ret
      panic("syntax");
     80e:	00001517          	auipc	a0,0x1
     812:	c9a50513          	addi	a0,a0,-870 # 14a8 <malloc+0x1be>
     816:	835ff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     81a:	8656                	mv	a2,s5
     81c:	85d2                	mv	a1,s4
     81e:	8526                	mv	a0,s1
     820:	eabff0ef          	jal	6ca <parseredirs>
     824:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     826:	865a                	mv	a2,s6
     828:	85d6                	mv	a1,s5
     82a:	8552                	mv	a0,s4
     82c:	e3bff0ef          	jal	666 <peek>
     830:	ed15                	bnez	a0,86c <parseexec+0xca>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     832:	f9040693          	addi	a3,s0,-112
     836:	f9840613          	addi	a2,s0,-104
     83a:	85d6                	mv	a1,s5
     83c:	8552                	mv	a0,s4
     83e:	cedff0ef          	jal	52a <gettoken>
     842:	c50d                	beqz	a0,86c <parseexec+0xca>
    if (tok != 'a')
     844:	fd9515e3          	bne	a0,s9,80e <parseexec+0x6c>
    cmd->argv[argc] = q;
     848:	f9843783          	ld	a5,-104(s0)
     84c:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     850:	f9043783          	ld	a5,-112(s0)
     854:	04f93823          	sd	a5,80(s2)
    argc++;
     858:	2985                	addiw	s3,s3,1
    if (argc >= MAXARGS)
     85a:	0921                	addi	s2,s2,8
     85c:	fb799fe3          	bne	s3,s7,81a <parseexec+0x78>
      panic("too many args");
     860:	00001517          	auipc	a0,0x1
     864:	c5050513          	addi	a0,a0,-944 # 14b0 <malloc+0x1c6>
     868:	fe2ff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     86c:	098e                	slli	s3,s3,0x3
     86e:	9c4e                	add	s8,s8,s3
     870:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     874:	040c3c23          	sd	zero,88(s8)
     878:	6946                	ld	s2,80(sp)
     87a:	69a6                	ld	s3,72(sp)
     87c:	7b42                	ld	s6,48(sp)
     87e:	7ba2                	ld	s7,40(sp)
     880:	7c02                	ld	s8,32(sp)
     882:	6ce2                	ld	s9,24(sp)
  return ret;
     884:	bfad                	j	7fe <parseexec+0x5c>

0000000000000886 <parsepipe>:
{
     886:	7179                	addi	sp,sp,-48
     888:	f406                	sd	ra,40(sp)
     88a:	f022                	sd	s0,32(sp)
     88c:	ec26                	sd	s1,24(sp)
     88e:	e84a                	sd	s2,16(sp)
     890:	e44e                	sd	s3,8(sp)
     892:	1800                	addi	s0,sp,48
     894:	892a                	mv	s2,a0
     896:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     898:	f0bff0ef          	jal	7a2 <parseexec>
     89c:	84aa                	mv	s1,a0
  if (peek(ps, es, "|"))
     89e:	00001617          	auipc	a2,0x1
     8a2:	c2a60613          	addi	a2,a2,-982 # 14c8 <malloc+0x1de>
     8a6:	85ce                	mv	a1,s3
     8a8:	854a                	mv	a0,s2
     8aa:	dbdff0ef          	jal	666 <peek>
     8ae:	e909                	bnez	a0,8c0 <parsepipe+0x3a>
}
     8b0:	8526                	mv	a0,s1
     8b2:	70a2                	ld	ra,40(sp)
     8b4:	7402                	ld	s0,32(sp)
     8b6:	64e2                	ld	s1,24(sp)
     8b8:	6942                	ld	s2,16(sp)
     8ba:	69a2                	ld	s3,8(sp)
     8bc:	6145                	addi	sp,sp,48
     8be:	8082                	ret
    gettoken(ps, es, 0, 0);
     8c0:	4681                	li	a3,0
     8c2:	4601                	li	a2,0
     8c4:	85ce                	mv	a1,s3
     8c6:	854a                	mv	a0,s2
     8c8:	c63ff0ef          	jal	52a <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8cc:	85ce                	mv	a1,s3
     8ce:	854a                	mv	a0,s2
     8d0:	fb7ff0ef          	jal	886 <parsepipe>
     8d4:	85aa                	mv	a1,a0
     8d6:	8526                	mv	a0,s1
     8d8:	ba3ff0ef          	jal	47a <pipecmd>
     8dc:	84aa                	mv	s1,a0
  return cmd;
     8de:	bfc9                	j	8b0 <parsepipe+0x2a>

00000000000008e0 <parseline>:
{
     8e0:	7179                	addi	sp,sp,-48
     8e2:	f406                	sd	ra,40(sp)
     8e4:	f022                	sd	s0,32(sp)
     8e6:	ec26                	sd	s1,24(sp)
     8e8:	e84a                	sd	s2,16(sp)
     8ea:	e44e                	sd	s3,8(sp)
     8ec:	e052                	sd	s4,0(sp)
     8ee:	1800                	addi	s0,sp,48
     8f0:	892a                	mv	s2,a0
     8f2:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     8f4:	f93ff0ef          	jal	886 <parsepipe>
     8f8:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     8fa:	00001a17          	auipc	s4,0x1
     8fe:	bd6a0a13          	addi	s4,s4,-1066 # 14d0 <malloc+0x1e6>
     902:	a819                	j	918 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     904:	4681                	li	a3,0
     906:	4601                	li	a2,0
     908:	85ce                	mv	a1,s3
     90a:	854a                	mv	a0,s2
     90c:	c1fff0ef          	jal	52a <gettoken>
    cmd = backcmd(cmd);
     910:	8526                	mv	a0,s1
     912:	be5ff0ef          	jal	4f6 <backcmd>
     916:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     918:	8652                	mv	a2,s4
     91a:	85ce                	mv	a1,s3
     91c:	854a                	mv	a0,s2
     91e:	d49ff0ef          	jal	666 <peek>
     922:	f16d                	bnez	a0,904 <parseline+0x24>
  if (peek(ps, es, ";"))
     924:	00001617          	auipc	a2,0x1
     928:	bb460613          	addi	a2,a2,-1100 # 14d8 <malloc+0x1ee>
     92c:	85ce                	mv	a1,s3
     92e:	854a                	mv	a0,s2
     930:	d37ff0ef          	jal	666 <peek>
     934:	e911                	bnez	a0,948 <parseline+0x68>
}
     936:	8526                	mv	a0,s1
     938:	70a2                	ld	ra,40(sp)
     93a:	7402                	ld	s0,32(sp)
     93c:	64e2                	ld	s1,24(sp)
     93e:	6942                	ld	s2,16(sp)
     940:	69a2                	ld	s3,8(sp)
     942:	6a02                	ld	s4,0(sp)
     944:	6145                	addi	sp,sp,48
     946:	8082                	ret
    gettoken(ps, es, 0, 0);
     948:	4681                	li	a3,0
     94a:	4601                	li	a2,0
     94c:	85ce                	mv	a1,s3
     94e:	854a                	mv	a0,s2
     950:	bdbff0ef          	jal	52a <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     954:	85ce                	mv	a1,s3
     956:	854a                	mv	a0,s2
     958:	f89ff0ef          	jal	8e0 <parseline>
     95c:	85aa                	mv	a1,a0
     95e:	8526                	mv	a0,s1
     960:	b59ff0ef          	jal	4b8 <listcmd>
     964:	84aa                	mv	s1,a0
  return cmd;
     966:	bfc1                	j	936 <parseline+0x56>

0000000000000968 <parseblock>:
{
     968:	7179                	addi	sp,sp,-48
     96a:	f406                	sd	ra,40(sp)
     96c:	f022                	sd	s0,32(sp)
     96e:	ec26                	sd	s1,24(sp)
     970:	e84a                	sd	s2,16(sp)
     972:	e44e                	sd	s3,8(sp)
     974:	1800                	addi	s0,sp,48
     976:	84aa                	mv	s1,a0
     978:	892e                	mv	s2,a1
  if (!peek(ps, es, "("))
     97a:	00001617          	auipc	a2,0x1
     97e:	b2660613          	addi	a2,a2,-1242 # 14a0 <malloc+0x1b6>
     982:	ce5ff0ef          	jal	666 <peek>
     986:	c539                	beqz	a0,9d4 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     988:	4681                	li	a3,0
     98a:	4601                	li	a2,0
     98c:	85ca                	mv	a1,s2
     98e:	8526                	mv	a0,s1
     990:	b9bff0ef          	jal	52a <gettoken>
  cmd = parseline(ps, es);
     994:	85ca                	mv	a1,s2
     996:	8526                	mv	a0,s1
     998:	f49ff0ef          	jal	8e0 <parseline>
     99c:	89aa                	mv	s3,a0
  if (!peek(ps, es, ")"))
     99e:	00001617          	auipc	a2,0x1
     9a2:	b5260613          	addi	a2,a2,-1198 # 14f0 <malloc+0x206>
     9a6:	85ca                	mv	a1,s2
     9a8:	8526                	mv	a0,s1
     9aa:	cbdff0ef          	jal	666 <peek>
     9ae:	c90d                	beqz	a0,9e0 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     9b0:	4681                	li	a3,0
     9b2:	4601                	li	a2,0
     9b4:	85ca                	mv	a1,s2
     9b6:	8526                	mv	a0,s1
     9b8:	b73ff0ef          	jal	52a <gettoken>
  cmd = parseredirs(cmd, ps, es);
     9bc:	864a                	mv	a2,s2
     9be:	85a6                	mv	a1,s1
     9c0:	854e                	mv	a0,s3
     9c2:	d09ff0ef          	jal	6ca <parseredirs>
}
     9c6:	70a2                	ld	ra,40(sp)
     9c8:	7402                	ld	s0,32(sp)
     9ca:	64e2                	ld	s1,24(sp)
     9cc:	6942                	ld	s2,16(sp)
     9ce:	69a2                	ld	s3,8(sp)
     9d0:	6145                	addi	sp,sp,48
     9d2:	8082                	ret
    panic("parseblock");
     9d4:	00001517          	auipc	a0,0x1
     9d8:	b0c50513          	addi	a0,a0,-1268 # 14e0 <malloc+0x1f6>
     9dc:	e6eff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     9e0:	00001517          	auipc	a0,0x1
     9e4:	b1850513          	addi	a0,a0,-1256 # 14f8 <malloc+0x20e>
     9e8:	e62ff0ef          	jal	4a <panic>

00000000000009ec <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     9ec:	1101                	addi	sp,sp,-32
     9ee:	ec06                	sd	ra,24(sp)
     9f0:	e822                	sd	s0,16(sp)
     9f2:	e426                	sd	s1,8(sp)
     9f4:	1000                	addi	s0,sp,32
     9f6:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     9f8:	c131                	beqz	a0,a3c <nulterminate+0x50>
    return 0;

  switch (cmd->type)
     9fa:	4118                	lw	a4,0(a0)
     9fc:	4795                	li	a5,5
     9fe:	02e7ef63          	bltu	a5,a4,a3c <nulterminate+0x50>
     a02:	00056783          	lwu	a5,0(a0)
     a06:	078a                	slli	a5,a5,0x2
     a08:	00001717          	auipc	a4,0x1
     a0c:	b5070713          	addi	a4,a4,-1200 # 1558 <malloc+0x26e>
     a10:	97ba                	add	a5,a5,a4
     a12:	439c                	lw	a5,0(a5)
     a14:	97ba                	add	a5,a5,a4
     a16:	8782                	jr	a5
  {
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    for (i = 0; ecmd->argv[i]; i++)
     a18:	651c                	ld	a5,8(a0)
     a1a:	c38d                	beqz	a5,a3c <nulterminate+0x50>
     a1c:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     a20:	67b8                	ld	a4,72(a5)
     a22:	00070023          	sb	zero,0(a4)
    for (i = 0; ecmd->argv[i]; i++)
     a26:	07a1                	addi	a5,a5,8
     a28:	ff87b703          	ld	a4,-8(a5)
     a2c:	fb75                	bnez	a4,a20 <nulterminate+0x34>
     a2e:	a039                	j	a3c <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    nulterminate(rcmd->cmd);
     a30:	6508                	ld	a0,8(a0)
     a32:	fbbff0ef          	jal	9ec <nulterminate>
    *rcmd->efile = 0;
     a36:	6c9c                	ld	a5,24(s1)
     a38:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a3c:	8526                	mv	a0,s1
     a3e:	60e2                	ld	ra,24(sp)
     a40:	6442                	ld	s0,16(sp)
     a42:	64a2                	ld	s1,8(sp)
     a44:	6105                	addi	sp,sp,32
     a46:	8082                	ret
    nulterminate(pcmd->left);
     a48:	6508                	ld	a0,8(a0)
     a4a:	fa3ff0ef          	jal	9ec <nulterminate>
    nulterminate(pcmd->right);
     a4e:	6888                	ld	a0,16(s1)
     a50:	f9dff0ef          	jal	9ec <nulterminate>
    break;
     a54:	b7e5                	j	a3c <nulterminate+0x50>
    nulterminate(lcmd->left);
     a56:	6508                	ld	a0,8(a0)
     a58:	f95ff0ef          	jal	9ec <nulterminate>
    nulterminate(lcmd->right);
     a5c:	6888                	ld	a0,16(s1)
     a5e:	f8fff0ef          	jal	9ec <nulterminate>
    break;
     a62:	bfe9                	j	a3c <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     a64:	6508                	ld	a0,8(a0)
     a66:	f87ff0ef          	jal	9ec <nulterminate>
    break;
     a6a:	bfc9                	j	a3c <nulterminate+0x50>

0000000000000a6c <parsecmd>:
{
     a6c:	7179                	addi	sp,sp,-48
     a6e:	f406                	sd	ra,40(sp)
     a70:	f022                	sd	s0,32(sp)
     a72:	ec26                	sd	s1,24(sp)
     a74:	e84a                	sd	s2,16(sp)
     a76:	1800                	addi	s0,sp,48
     a78:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     a7c:	84aa                	mv	s1,a0
     a7e:	188000ef          	jal	c06 <strlen>
     a82:	1502                	slli	a0,a0,0x20
     a84:	9101                	srli	a0,a0,0x20
     a86:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a88:	85a6                	mv	a1,s1
     a8a:	fd840513          	addi	a0,s0,-40
     a8e:	e53ff0ef          	jal	8e0 <parseline>
     a92:	892a                	mv	s2,a0
  peek(&s, es, "");
     a94:	00001617          	auipc	a2,0x1
     a98:	97460613          	addi	a2,a2,-1676 # 1408 <malloc+0x11e>
     a9c:	85a6                	mv	a1,s1
     a9e:	fd840513          	addi	a0,s0,-40
     aa2:	bc5ff0ef          	jal	666 <peek>
  if (s != es)
     aa6:	fd843603          	ld	a2,-40(s0)
     aaa:	00961c63          	bne	a2,s1,ac2 <parsecmd+0x56>
  nulterminate(cmd);
     aae:	854a                	mv	a0,s2
     ab0:	f3dff0ef          	jal	9ec <nulterminate>
}
     ab4:	854a                	mv	a0,s2
     ab6:	70a2                	ld	ra,40(sp)
     ab8:	7402                	ld	s0,32(sp)
     aba:	64e2                	ld	s1,24(sp)
     abc:	6942                	ld	s2,16(sp)
     abe:	6145                	addi	sp,sp,48
     ac0:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     ac2:	00001597          	auipc	a1,0x1
     ac6:	a4e58593          	addi	a1,a1,-1458 # 1510 <malloc+0x226>
     aca:	4509                	li	a0,2
     acc:	740000ef          	jal	120c <fprintf>
    panic("syntax");
     ad0:	00001517          	auipc	a0,0x1
     ad4:	9d850513          	addi	a0,a0,-1576 # 14a8 <malloc+0x1be>
     ad8:	d72ff0ef          	jal	4a <panic>

0000000000000adc <main>:
{
     adc:	7179                	addi	sp,sp,-48
     ade:	f406                	sd	ra,40(sp)
     ae0:	f022                	sd	s0,32(sp)
     ae2:	ec26                	sd	s1,24(sp)
     ae4:	e84a                	sd	s2,16(sp)
     ae6:	e44e                	sd	s3,8(sp)
     ae8:	e052                	sd	s4,0(sp)
     aea:	1800                	addi	s0,sp,48
  while ((fd = open("console", O_RDWR)) >= 0)
     aec:	00001497          	auipc	s1,0x1
     af0:	a3448493          	addi	s1,s1,-1484 # 1520 <malloc+0x236>
     af4:	4589                	li	a1,2
     af6:	8526                	mv	a0,s1
     af8:	35e000ef          	jal	e56 <open>
     afc:	00054763          	bltz	a0,b0a <main+0x2e>
    if (fd >= 3)
     b00:	4789                	li	a5,2
     b02:	fea7d9e3          	bge	a5,a0,af4 <main+0x18>
      close(fd);
     b06:	338000ef          	jal	e3e <close>
  while (getcmd(buf, sizeof(buf)) >= 0)
     b0a:	00001497          	auipc	s1,0x1
     b0e:	51648493          	addi	s1,s1,1302 # 2020 <buf.0>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     b12:	06300913          	li	s2,99
     b16:	02000993          	li	s3,32
     b1a:	a039                	j	b28 <main+0x4c>
    if (fork1() == 0)
     b1c:	d4cff0ef          	jal	68 <fork1>
     b20:	c93d                	beqz	a0,b96 <main+0xba>
    wait(0);
     b22:	4501                	li	a0,0
     b24:	2fa000ef          	jal	e1e <wait>
  while (getcmd(buf, sizeof(buf)) >= 0)
     b28:	06400593          	li	a1,100
     b2c:	8526                	mv	a0,s1
     b2e:	cd2ff0ef          	jal	0 <getcmd>
     b32:	06054a63          	bltz	a0,ba6 <main+0xca>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     b36:	0004c783          	lbu	a5,0(s1)
     b3a:	ff2791e3          	bne	a5,s2,b1c <main+0x40>
     b3e:	0014c703          	lbu	a4,1(s1)
     b42:	06400793          	li	a5,100
     b46:	fcf71be3          	bne	a4,a5,b1c <main+0x40>
     b4a:	0024c783          	lbu	a5,2(s1)
     b4e:	fd3797e3          	bne	a5,s3,b1c <main+0x40>
      buf[strlen(buf) - 1] = 0; // chop \n
     b52:	00001a17          	auipc	s4,0x1
     b56:	4cea0a13          	addi	s4,s4,1230 # 2020 <buf.0>
     b5a:	8552                	mv	a0,s4
     b5c:	0aa000ef          	jal	c06 <strlen>
     b60:	fff5079b          	addiw	a5,a0,-1
     b64:	1782                	slli	a5,a5,0x20
     b66:	9381                	srli	a5,a5,0x20
     b68:	9a3e                	add	s4,s4,a5
     b6a:	000a0023          	sb	zero,0(s4)
      if (chdir(buf + 3) < 0)
     b6e:	00001517          	auipc	a0,0x1
     b72:	4b550513          	addi	a0,a0,1205 # 2023 <buf.0+0x3>
     b76:	310000ef          	jal	e86 <chdir>
     b7a:	fa0557e3          	bgez	a0,b28 <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf + 3);
     b7e:	00001617          	auipc	a2,0x1
     b82:	4a560613          	addi	a2,a2,1189 # 2023 <buf.0+0x3>
     b86:	00001597          	auipc	a1,0x1
     b8a:	9a258593          	addi	a1,a1,-1630 # 1528 <malloc+0x23e>
     b8e:	4509                	li	a0,2
     b90:	67c000ef          	jal	120c <fprintf>
     b94:	bf51                	j	b28 <main+0x4c>
      runcmd(parsecmd(buf));
     b96:	00001517          	auipc	a0,0x1
     b9a:	48a50513          	addi	a0,a0,1162 # 2020 <buf.0>
     b9e:	ecfff0ef          	jal	a6c <parsecmd>
     ba2:	cecff0ef          	jal	8e <runcmd>
  exit(0);
     ba6:	4501                	li	a0,0
     ba8:	26e000ef          	jal	e16 <exit>

0000000000000bac <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     bac:	1141                	addi	sp,sp,-16
     bae:	e406                	sd	ra,8(sp)
     bb0:	e022                	sd	s0,0(sp)
     bb2:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bb4:	f29ff0ef          	jal	adc <main>
  exit(0);
     bb8:	4501                	li	a0,0
     bba:	25c000ef          	jal	e16 <exit>

0000000000000bbe <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bbe:	1141                	addi	sp,sp,-16
     bc0:	e422                	sd	s0,8(sp)
     bc2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bc4:	87aa                	mv	a5,a0
     bc6:	0585                	addi	a1,a1,1
     bc8:	0785                	addi	a5,a5,1
     bca:	fff5c703          	lbu	a4,-1(a1)
     bce:	fee78fa3          	sb	a4,-1(a5)
     bd2:	fb75                	bnez	a4,bc6 <strcpy+0x8>
    ;
  return os;
}
     bd4:	6422                	ld	s0,8(sp)
     bd6:	0141                	addi	sp,sp,16
     bd8:	8082                	ret

0000000000000bda <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bda:	1141                	addi	sp,sp,-16
     bdc:	e422                	sd	s0,8(sp)
     bde:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     be0:	00054783          	lbu	a5,0(a0)
     be4:	cb91                	beqz	a5,bf8 <strcmp+0x1e>
     be6:	0005c703          	lbu	a4,0(a1)
     bea:	00f71763          	bne	a4,a5,bf8 <strcmp+0x1e>
    p++, q++;
     bee:	0505                	addi	a0,a0,1
     bf0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bf2:	00054783          	lbu	a5,0(a0)
     bf6:	fbe5                	bnez	a5,be6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bf8:	0005c503          	lbu	a0,0(a1)
}
     bfc:	40a7853b          	subw	a0,a5,a0
     c00:	6422                	ld	s0,8(sp)
     c02:	0141                	addi	sp,sp,16
     c04:	8082                	ret

0000000000000c06 <strlen>:

uint
strlen(const char *s)
{
     c06:	1141                	addi	sp,sp,-16
     c08:	e422                	sd	s0,8(sp)
     c0a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c0c:	00054783          	lbu	a5,0(a0)
     c10:	cf91                	beqz	a5,c2c <strlen+0x26>
     c12:	0505                	addi	a0,a0,1
     c14:	87aa                	mv	a5,a0
     c16:	86be                	mv	a3,a5
     c18:	0785                	addi	a5,a5,1
     c1a:	fff7c703          	lbu	a4,-1(a5)
     c1e:	ff65                	bnez	a4,c16 <strlen+0x10>
     c20:	40a6853b          	subw	a0,a3,a0
     c24:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c26:	6422                	ld	s0,8(sp)
     c28:	0141                	addi	sp,sp,16
     c2a:	8082                	ret
  for(n = 0; s[n]; n++)
     c2c:	4501                	li	a0,0
     c2e:	bfe5                	j	c26 <strlen+0x20>

0000000000000c30 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c30:	1141                	addi	sp,sp,-16
     c32:	e422                	sd	s0,8(sp)
     c34:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c36:	ca19                	beqz	a2,c4c <memset+0x1c>
     c38:	87aa                	mv	a5,a0
     c3a:	1602                	slli	a2,a2,0x20
     c3c:	9201                	srli	a2,a2,0x20
     c3e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c42:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c46:	0785                	addi	a5,a5,1
     c48:	fee79de3          	bne	a5,a4,c42 <memset+0x12>
  }
  return dst;
}
     c4c:	6422                	ld	s0,8(sp)
     c4e:	0141                	addi	sp,sp,16
     c50:	8082                	ret

0000000000000c52 <strchr>:

char*
strchr(const char *s, char c)
{
     c52:	1141                	addi	sp,sp,-16
     c54:	e422                	sd	s0,8(sp)
     c56:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c58:	00054783          	lbu	a5,0(a0)
     c5c:	cb99                	beqz	a5,c72 <strchr+0x20>
    if(*s == c)
     c5e:	00f58763          	beq	a1,a5,c6c <strchr+0x1a>
  for(; *s; s++)
     c62:	0505                	addi	a0,a0,1
     c64:	00054783          	lbu	a5,0(a0)
     c68:	fbfd                	bnez	a5,c5e <strchr+0xc>
      return (char*)s;
  return 0;
     c6a:	4501                	li	a0,0
}
     c6c:	6422                	ld	s0,8(sp)
     c6e:	0141                	addi	sp,sp,16
     c70:	8082                	ret
  return 0;
     c72:	4501                	li	a0,0
     c74:	bfe5                	j	c6c <strchr+0x1a>

0000000000000c76 <gets>:

char*
gets(char *buf, int max)
{
     c76:	711d                	addi	sp,sp,-96
     c78:	ec86                	sd	ra,88(sp)
     c7a:	e8a2                	sd	s0,80(sp)
     c7c:	e4a6                	sd	s1,72(sp)
     c7e:	e0ca                	sd	s2,64(sp)
     c80:	fc4e                	sd	s3,56(sp)
     c82:	f852                	sd	s4,48(sp)
     c84:	f456                	sd	s5,40(sp)
     c86:	f05a                	sd	s6,32(sp)
     c88:	ec5e                	sd	s7,24(sp)
     c8a:	1080                	addi	s0,sp,96
     c8c:	8baa                	mv	s7,a0
     c8e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c90:	892a                	mv	s2,a0
     c92:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c94:	4aa9                	li	s5,10
     c96:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c98:	89a6                	mv	s3,s1
     c9a:	2485                	addiw	s1,s1,1
     c9c:	0344d663          	bge	s1,s4,cc8 <gets+0x52>
    cc = read(0, &c, 1);
     ca0:	4605                	li	a2,1
     ca2:	faf40593          	addi	a1,s0,-81
     ca6:	4501                	li	a0,0
     ca8:	186000ef          	jal	e2e <read>
    if(cc < 1)
     cac:	00a05e63          	blez	a0,cc8 <gets+0x52>
    buf[i++] = c;
     cb0:	faf44783          	lbu	a5,-81(s0)
     cb4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cb8:	01578763          	beq	a5,s5,cc6 <gets+0x50>
     cbc:	0905                	addi	s2,s2,1
     cbe:	fd679de3          	bne	a5,s6,c98 <gets+0x22>
    buf[i++] = c;
     cc2:	89a6                	mv	s3,s1
     cc4:	a011                	j	cc8 <gets+0x52>
     cc6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cc8:	99de                	add	s3,s3,s7
     cca:	00098023          	sb	zero,0(s3)
  return buf;
}
     cce:	855e                	mv	a0,s7
     cd0:	60e6                	ld	ra,88(sp)
     cd2:	6446                	ld	s0,80(sp)
     cd4:	64a6                	ld	s1,72(sp)
     cd6:	6906                	ld	s2,64(sp)
     cd8:	79e2                	ld	s3,56(sp)
     cda:	7a42                	ld	s4,48(sp)
     cdc:	7aa2                	ld	s5,40(sp)
     cde:	7b02                	ld	s6,32(sp)
     ce0:	6be2                	ld	s7,24(sp)
     ce2:	6125                	addi	sp,sp,96
     ce4:	8082                	ret

0000000000000ce6 <stat>:

int
stat(const char *n, struct stat *st)
{
     ce6:	1101                	addi	sp,sp,-32
     ce8:	ec06                	sd	ra,24(sp)
     cea:	e822                	sd	s0,16(sp)
     cec:	e04a                	sd	s2,0(sp)
     cee:	1000                	addi	s0,sp,32
     cf0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cf2:	4581                	li	a1,0
     cf4:	162000ef          	jal	e56 <open>
  if(fd < 0)
     cf8:	02054263          	bltz	a0,d1c <stat+0x36>
     cfc:	e426                	sd	s1,8(sp)
     cfe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d00:	85ca                	mv	a1,s2
     d02:	16c000ef          	jal	e6e <fstat>
     d06:	892a                	mv	s2,a0
  close(fd);
     d08:	8526                	mv	a0,s1
     d0a:	134000ef          	jal	e3e <close>
  return r;
     d0e:	64a2                	ld	s1,8(sp)
}
     d10:	854a                	mv	a0,s2
     d12:	60e2                	ld	ra,24(sp)
     d14:	6442                	ld	s0,16(sp)
     d16:	6902                	ld	s2,0(sp)
     d18:	6105                	addi	sp,sp,32
     d1a:	8082                	ret
    return -1;
     d1c:	597d                	li	s2,-1
     d1e:	bfcd                	j	d10 <stat+0x2a>

0000000000000d20 <atoi>:

int
atoi(const char *s)
{
     d20:	1141                	addi	sp,sp,-16
     d22:	e422                	sd	s0,8(sp)
     d24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d26:	00054683          	lbu	a3,0(a0)
     d2a:	fd06879b          	addiw	a5,a3,-48
     d2e:	0ff7f793          	zext.b	a5,a5
     d32:	4625                	li	a2,9
     d34:	02f66863          	bltu	a2,a5,d64 <atoi+0x44>
     d38:	872a                	mv	a4,a0
  n = 0;
     d3a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d3c:	0705                	addi	a4,a4,1
     d3e:	0025179b          	slliw	a5,a0,0x2
     d42:	9fa9                	addw	a5,a5,a0
     d44:	0017979b          	slliw	a5,a5,0x1
     d48:	9fb5                	addw	a5,a5,a3
     d4a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d4e:	00074683          	lbu	a3,0(a4)
     d52:	fd06879b          	addiw	a5,a3,-48
     d56:	0ff7f793          	zext.b	a5,a5
     d5a:	fef671e3          	bgeu	a2,a5,d3c <atoi+0x1c>
  return n;
}
     d5e:	6422                	ld	s0,8(sp)
     d60:	0141                	addi	sp,sp,16
     d62:	8082                	ret
  n = 0;
     d64:	4501                	li	a0,0
     d66:	bfe5                	j	d5e <atoi+0x3e>

0000000000000d68 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d68:	1141                	addi	sp,sp,-16
     d6a:	e422                	sd	s0,8(sp)
     d6c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d6e:	02b57463          	bgeu	a0,a1,d96 <memmove+0x2e>
    while(n-- > 0)
     d72:	00c05f63          	blez	a2,d90 <memmove+0x28>
     d76:	1602                	slli	a2,a2,0x20
     d78:	9201                	srli	a2,a2,0x20
     d7a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d7e:	872a                	mv	a4,a0
      *dst++ = *src++;
     d80:	0585                	addi	a1,a1,1
     d82:	0705                	addi	a4,a4,1
     d84:	fff5c683          	lbu	a3,-1(a1)
     d88:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d8c:	fef71ae3          	bne	a4,a5,d80 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d90:	6422                	ld	s0,8(sp)
     d92:	0141                	addi	sp,sp,16
     d94:	8082                	ret
    dst += n;
     d96:	00c50733          	add	a4,a0,a2
    src += n;
     d9a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d9c:	fec05ae3          	blez	a2,d90 <memmove+0x28>
     da0:	fff6079b          	addiw	a5,a2,-1
     da4:	1782                	slli	a5,a5,0x20
     da6:	9381                	srli	a5,a5,0x20
     da8:	fff7c793          	not	a5,a5
     dac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dae:	15fd                	addi	a1,a1,-1
     db0:	177d                	addi	a4,a4,-1
     db2:	0005c683          	lbu	a3,0(a1)
     db6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dba:	fee79ae3          	bne	a5,a4,dae <memmove+0x46>
     dbe:	bfc9                	j	d90 <memmove+0x28>

0000000000000dc0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dc0:	1141                	addi	sp,sp,-16
     dc2:	e422                	sd	s0,8(sp)
     dc4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dc6:	ca05                	beqz	a2,df6 <memcmp+0x36>
     dc8:	fff6069b          	addiw	a3,a2,-1
     dcc:	1682                	slli	a3,a3,0x20
     dce:	9281                	srli	a3,a3,0x20
     dd0:	0685                	addi	a3,a3,1
     dd2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dd4:	00054783          	lbu	a5,0(a0)
     dd8:	0005c703          	lbu	a4,0(a1)
     ddc:	00e79863          	bne	a5,a4,dec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     de0:	0505                	addi	a0,a0,1
    p2++;
     de2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     de4:	fed518e3          	bne	a0,a3,dd4 <memcmp+0x14>
  }
  return 0;
     de8:	4501                	li	a0,0
     dea:	a019                	j	df0 <memcmp+0x30>
      return *p1 - *p2;
     dec:	40e7853b          	subw	a0,a5,a4
}
     df0:	6422                	ld	s0,8(sp)
     df2:	0141                	addi	sp,sp,16
     df4:	8082                	ret
  return 0;
     df6:	4501                	li	a0,0
     df8:	bfe5                	j	df0 <memcmp+0x30>

0000000000000dfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dfa:	1141                	addi	sp,sp,-16
     dfc:	e406                	sd	ra,8(sp)
     dfe:	e022                	sd	s0,0(sp)
     e00:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e02:	f67ff0ef          	jal	d68 <memmove>
}
     e06:	60a2                	ld	ra,8(sp)
     e08:	6402                	ld	s0,0(sp)
     e0a:	0141                	addi	sp,sp,16
     e0c:	8082                	ret

0000000000000e0e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e0e:	4885                	li	a7,1
 ecall
     e10:	00000073          	ecall
 ret
     e14:	8082                	ret

0000000000000e16 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e16:	4889                	li	a7,2
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <wait>:
.global wait
wait:
 li a7, SYS_wait
     e1e:	488d                	li	a7,3
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e26:	4891                	li	a7,4
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <read>:
.global read
read:
 li a7, SYS_read
     e2e:	4895                	li	a7,5
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <write>:
.global write
write:
 li a7, SYS_write
     e36:	48c1                	li	a7,16
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <close>:
.global close
close:
 li a7, SYS_close
     e3e:	48d5                	li	a7,21
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e46:	4899                	li	a7,6
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e4e:	489d                	li	a7,7
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <open>:
.global open
open:
 li a7, SYS_open
     e56:	48bd                	li	a7,15
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e5e:	48c5                	li	a7,17
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e66:	48c9                	li	a7,18
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e6e:	48a1                	li	a7,8
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <link>:
.global link
link:
 li a7, SYS_link
     e76:	48cd                	li	a7,19
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e7e:	48d1                	li	a7,20
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e86:	48a5                	li	a7,9
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <dup>:
.global dup
dup:
 li a7, SYS_dup
     e8e:	48a9                	li	a7,10
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e96:	48ad                	li	a7,11
 ecall
     e98:	00000073          	ecall
 ret
     e9c:	8082                	ret

0000000000000e9e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e9e:	48b1                	li	a7,12
 ecall
     ea0:	00000073          	ecall
 ret
     ea4:	8082                	ret

0000000000000ea6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ea6:	48b5                	li	a7,13
 ecall
     ea8:	00000073          	ecall
 ret
     eac:	8082                	ret

0000000000000eae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     eae:	48b9                	li	a7,14
 ecall
     eb0:	00000073          	ecall
 ret
     eb4:	8082                	ret

0000000000000eb6 <trigger>:
.global trigger
trigger:
 li a7, SYS_trigger
     eb6:	48d9                	li	a7,22
 ecall
     eb8:	00000073          	ecall
 ret
     ebc:	8082                	ret

0000000000000ebe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ebe:	1101                	addi	sp,sp,-32
     ec0:	ec06                	sd	ra,24(sp)
     ec2:	e822                	sd	s0,16(sp)
     ec4:	1000                	addi	s0,sp,32
     ec6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     eca:	4605                	li	a2,1
     ecc:	fef40593          	addi	a1,s0,-17
     ed0:	f67ff0ef          	jal	e36 <write>
}
     ed4:	60e2                	ld	ra,24(sp)
     ed6:	6442                	ld	s0,16(sp)
     ed8:	6105                	addi	sp,sp,32
     eda:	8082                	ret

0000000000000edc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     edc:	7139                	addi	sp,sp,-64
     ede:	fc06                	sd	ra,56(sp)
     ee0:	f822                	sd	s0,48(sp)
     ee2:	f426                	sd	s1,40(sp)
     ee4:	0080                	addi	s0,sp,64
     ee6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ee8:	c299                	beqz	a3,eee <printint+0x12>
     eea:	0805c963          	bltz	a1,f7c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     eee:	2581                	sext.w	a1,a1
  neg = 0;
     ef0:	4881                	li	a7,0
     ef2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ef6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ef8:	2601                	sext.w	a2,a2
     efa:	00000517          	auipc	a0,0x0
     efe:	67650513          	addi	a0,a0,1654 # 1570 <digits>
     f02:	883a                	mv	a6,a4
     f04:	2705                	addiw	a4,a4,1
     f06:	02c5f7bb          	remuw	a5,a1,a2
     f0a:	1782                	slli	a5,a5,0x20
     f0c:	9381                	srli	a5,a5,0x20
     f0e:	97aa                	add	a5,a5,a0
     f10:	0007c783          	lbu	a5,0(a5)
     f14:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f18:	0005879b          	sext.w	a5,a1
     f1c:	02c5d5bb          	divuw	a1,a1,a2
     f20:	0685                	addi	a3,a3,1
     f22:	fec7f0e3          	bgeu	a5,a2,f02 <printint+0x26>
  if(neg)
     f26:	00088c63          	beqz	a7,f3e <printint+0x62>
    buf[i++] = '-';
     f2a:	fd070793          	addi	a5,a4,-48
     f2e:	00878733          	add	a4,a5,s0
     f32:	02d00793          	li	a5,45
     f36:	fef70823          	sb	a5,-16(a4)
     f3a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f3e:	02e05a63          	blez	a4,f72 <printint+0x96>
     f42:	f04a                	sd	s2,32(sp)
     f44:	ec4e                	sd	s3,24(sp)
     f46:	fc040793          	addi	a5,s0,-64
     f4a:	00e78933          	add	s2,a5,a4
     f4e:	fff78993          	addi	s3,a5,-1
     f52:	99ba                	add	s3,s3,a4
     f54:	377d                	addiw	a4,a4,-1
     f56:	1702                	slli	a4,a4,0x20
     f58:	9301                	srli	a4,a4,0x20
     f5a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f5e:	fff94583          	lbu	a1,-1(s2)
     f62:	8526                	mv	a0,s1
     f64:	f5bff0ef          	jal	ebe <putc>
  while(--i >= 0)
     f68:	197d                	addi	s2,s2,-1
     f6a:	ff391ae3          	bne	s2,s3,f5e <printint+0x82>
     f6e:	7902                	ld	s2,32(sp)
     f70:	69e2                	ld	s3,24(sp)
}
     f72:	70e2                	ld	ra,56(sp)
     f74:	7442                	ld	s0,48(sp)
     f76:	74a2                	ld	s1,40(sp)
     f78:	6121                	addi	sp,sp,64
     f7a:	8082                	ret
    x = -xx;
     f7c:	40b005bb          	negw	a1,a1
    neg = 1;
     f80:	4885                	li	a7,1
    x = -xx;
     f82:	bf85                	j	ef2 <printint+0x16>

0000000000000f84 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f84:	711d                	addi	sp,sp,-96
     f86:	ec86                	sd	ra,88(sp)
     f88:	e8a2                	sd	s0,80(sp)
     f8a:	e0ca                	sd	s2,64(sp)
     f8c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f8e:	0005c903          	lbu	s2,0(a1)
     f92:	26090863          	beqz	s2,1202 <vprintf+0x27e>
     f96:	e4a6                	sd	s1,72(sp)
     f98:	fc4e                	sd	s3,56(sp)
     f9a:	f852                	sd	s4,48(sp)
     f9c:	f456                	sd	s5,40(sp)
     f9e:	f05a                	sd	s6,32(sp)
     fa0:	ec5e                	sd	s7,24(sp)
     fa2:	e862                	sd	s8,16(sp)
     fa4:	e466                	sd	s9,8(sp)
     fa6:	8b2a                	mv	s6,a0
     fa8:	8a2e                	mv	s4,a1
     faa:	8bb2                	mv	s7,a2
  state = 0;
     fac:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     fae:	4481                	li	s1,0
     fb0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     fb2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     fb6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     fba:	06c00c93          	li	s9,108
     fbe:	a005                	j	fde <vprintf+0x5a>
        putc(fd, c0);
     fc0:	85ca                	mv	a1,s2
     fc2:	855a                	mv	a0,s6
     fc4:	efbff0ef          	jal	ebe <putc>
     fc8:	a019                	j	fce <vprintf+0x4a>
    } else if(state == '%'){
     fca:	03598263          	beq	s3,s5,fee <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     fce:	2485                	addiw	s1,s1,1
     fd0:	8726                	mv	a4,s1
     fd2:	009a07b3          	add	a5,s4,s1
     fd6:	0007c903          	lbu	s2,0(a5)
     fda:	20090c63          	beqz	s2,11f2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     fde:	0009079b          	sext.w	a5,s2
    if(state == 0){
     fe2:	fe0994e3          	bnez	s3,fca <vprintf+0x46>
      if(c0 == '%'){
     fe6:	fd579de3          	bne	a5,s5,fc0 <vprintf+0x3c>
        state = '%';
     fea:	89be                	mv	s3,a5
     fec:	b7cd                	j	fce <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     fee:	00ea06b3          	add	a3,s4,a4
     ff2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     ff6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     ff8:	c681                	beqz	a3,1000 <vprintf+0x7c>
     ffa:	9752                	add	a4,a4,s4
     ffc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1000:	03878f63          	beq	a5,s8,103e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1004:	05978963          	beq	a5,s9,1056 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1008:	07500713          	li	a4,117
    100c:	0ee78363          	beq	a5,a4,10f2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1010:	07800713          	li	a4,120
    1014:	12e78563          	beq	a5,a4,113e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1018:	07000713          	li	a4,112
    101c:	14e78a63          	beq	a5,a4,1170 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1020:	07300713          	li	a4,115
    1024:	18e78a63          	beq	a5,a4,11b8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1028:	02500713          	li	a4,37
    102c:	04e79563          	bne	a5,a4,1076 <vprintf+0xf2>
        putc(fd, '%');
    1030:	02500593          	li	a1,37
    1034:	855a                	mv	a0,s6
    1036:	e89ff0ef          	jal	ebe <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    103a:	4981                	li	s3,0
    103c:	bf49                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    103e:	008b8913          	addi	s2,s7,8
    1042:	4685                	li	a3,1
    1044:	4629                	li	a2,10
    1046:	000ba583          	lw	a1,0(s7)
    104a:	855a                	mv	a0,s6
    104c:	e91ff0ef          	jal	edc <printint>
    1050:	8bca                	mv	s7,s2
      state = 0;
    1052:	4981                	li	s3,0
    1054:	bfad                	j	fce <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1056:	06400793          	li	a5,100
    105a:	02f68963          	beq	a3,a5,108c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    105e:	06c00793          	li	a5,108
    1062:	04f68263          	beq	a3,a5,10a6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1066:	07500793          	li	a5,117
    106a:	0af68063          	beq	a3,a5,110a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    106e:	07800793          	li	a5,120
    1072:	0ef68263          	beq	a3,a5,1156 <vprintf+0x1d2>
        putc(fd, '%');
    1076:	02500593          	li	a1,37
    107a:	855a                	mv	a0,s6
    107c:	e43ff0ef          	jal	ebe <putc>
        putc(fd, c0);
    1080:	85ca                	mv	a1,s2
    1082:	855a                	mv	a0,s6
    1084:	e3bff0ef          	jal	ebe <putc>
      state = 0;
    1088:	4981                	li	s3,0
    108a:	b791                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    108c:	008b8913          	addi	s2,s7,8
    1090:	4685                	li	a3,1
    1092:	4629                	li	a2,10
    1094:	000ba583          	lw	a1,0(s7)
    1098:	855a                	mv	a0,s6
    109a:	e43ff0ef          	jal	edc <printint>
        i += 1;
    109e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    10a0:	8bca                	mv	s7,s2
      state = 0;
    10a2:	4981                	li	s3,0
        i += 1;
    10a4:	b72d                	j	fce <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    10a6:	06400793          	li	a5,100
    10aa:	02f60763          	beq	a2,a5,10d8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    10ae:	07500793          	li	a5,117
    10b2:	06f60963          	beq	a2,a5,1124 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    10b6:	07800793          	li	a5,120
    10ba:	faf61ee3          	bne	a2,a5,1076 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10be:	008b8913          	addi	s2,s7,8
    10c2:	4681                	li	a3,0
    10c4:	4641                	li	a2,16
    10c6:	000ba583          	lw	a1,0(s7)
    10ca:	855a                	mv	a0,s6
    10cc:	e11ff0ef          	jal	edc <printint>
        i += 2;
    10d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    10d2:	8bca                	mv	s7,s2
      state = 0;
    10d4:	4981                	li	s3,0
        i += 2;
    10d6:	bde5                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    10d8:	008b8913          	addi	s2,s7,8
    10dc:	4685                	li	a3,1
    10de:	4629                	li	a2,10
    10e0:	000ba583          	lw	a1,0(s7)
    10e4:	855a                	mv	a0,s6
    10e6:	df7ff0ef          	jal	edc <printint>
        i += 2;
    10ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    10ec:	8bca                	mv	s7,s2
      state = 0;
    10ee:	4981                	li	s3,0
        i += 2;
    10f0:	bdf9                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    10f2:	008b8913          	addi	s2,s7,8
    10f6:	4681                	li	a3,0
    10f8:	4629                	li	a2,10
    10fa:	000ba583          	lw	a1,0(s7)
    10fe:	855a                	mv	a0,s6
    1100:	dddff0ef          	jal	edc <printint>
    1104:	8bca                	mv	s7,s2
      state = 0;
    1106:	4981                	li	s3,0
    1108:	b5d9                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    110a:	008b8913          	addi	s2,s7,8
    110e:	4681                	li	a3,0
    1110:	4629                	li	a2,10
    1112:	000ba583          	lw	a1,0(s7)
    1116:	855a                	mv	a0,s6
    1118:	dc5ff0ef          	jal	edc <printint>
        i += 1;
    111c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    111e:	8bca                	mv	s7,s2
      state = 0;
    1120:	4981                	li	s3,0
        i += 1;
    1122:	b575                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1124:	008b8913          	addi	s2,s7,8
    1128:	4681                	li	a3,0
    112a:	4629                	li	a2,10
    112c:	000ba583          	lw	a1,0(s7)
    1130:	855a                	mv	a0,s6
    1132:	dabff0ef          	jal	edc <printint>
        i += 2;
    1136:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1138:	8bca                	mv	s7,s2
      state = 0;
    113a:	4981                	li	s3,0
        i += 2;
    113c:	bd49                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    113e:	008b8913          	addi	s2,s7,8
    1142:	4681                	li	a3,0
    1144:	4641                	li	a2,16
    1146:	000ba583          	lw	a1,0(s7)
    114a:	855a                	mv	a0,s6
    114c:	d91ff0ef          	jal	edc <printint>
    1150:	8bca                	mv	s7,s2
      state = 0;
    1152:	4981                	li	s3,0
    1154:	bdad                	j	fce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1156:	008b8913          	addi	s2,s7,8
    115a:	4681                	li	a3,0
    115c:	4641                	li	a2,16
    115e:	000ba583          	lw	a1,0(s7)
    1162:	855a                	mv	a0,s6
    1164:	d79ff0ef          	jal	edc <printint>
        i += 1;
    1168:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    116a:	8bca                	mv	s7,s2
      state = 0;
    116c:	4981                	li	s3,0
        i += 1;
    116e:	b585                	j	fce <vprintf+0x4a>
    1170:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1172:	008b8d13          	addi	s10,s7,8
    1176:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    117a:	03000593          	li	a1,48
    117e:	855a                	mv	a0,s6
    1180:	d3fff0ef          	jal	ebe <putc>
  putc(fd, 'x');
    1184:	07800593          	li	a1,120
    1188:	855a                	mv	a0,s6
    118a:	d35ff0ef          	jal	ebe <putc>
    118e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1190:	00000b97          	auipc	s7,0x0
    1194:	3e0b8b93          	addi	s7,s7,992 # 1570 <digits>
    1198:	03c9d793          	srli	a5,s3,0x3c
    119c:	97de                	add	a5,a5,s7
    119e:	0007c583          	lbu	a1,0(a5)
    11a2:	855a                	mv	a0,s6
    11a4:	d1bff0ef          	jal	ebe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11a8:	0992                	slli	s3,s3,0x4
    11aa:	397d                	addiw	s2,s2,-1
    11ac:	fe0916e3          	bnez	s2,1198 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    11b0:	8bea                	mv	s7,s10
      state = 0;
    11b2:	4981                	li	s3,0
    11b4:	6d02                	ld	s10,0(sp)
    11b6:	bd21                	j	fce <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    11b8:	008b8993          	addi	s3,s7,8
    11bc:	000bb903          	ld	s2,0(s7)
    11c0:	00090f63          	beqz	s2,11de <vprintf+0x25a>
        for(; *s; s++)
    11c4:	00094583          	lbu	a1,0(s2)
    11c8:	c195                	beqz	a1,11ec <vprintf+0x268>
          putc(fd, *s);
    11ca:	855a                	mv	a0,s6
    11cc:	cf3ff0ef          	jal	ebe <putc>
        for(; *s; s++)
    11d0:	0905                	addi	s2,s2,1
    11d2:	00094583          	lbu	a1,0(s2)
    11d6:	f9f5                	bnez	a1,11ca <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    11d8:	8bce                	mv	s7,s3
      state = 0;
    11da:	4981                	li	s3,0
    11dc:	bbcd                	j	fce <vprintf+0x4a>
          s = "(null)";
    11de:	00000917          	auipc	s2,0x0
    11e2:	35a90913          	addi	s2,s2,858 # 1538 <malloc+0x24e>
        for(; *s; s++)
    11e6:	02800593          	li	a1,40
    11ea:	b7c5                	j	11ca <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    11ec:	8bce                	mv	s7,s3
      state = 0;
    11ee:	4981                	li	s3,0
    11f0:	bbf9                	j	fce <vprintf+0x4a>
    11f2:	64a6                	ld	s1,72(sp)
    11f4:	79e2                	ld	s3,56(sp)
    11f6:	7a42                	ld	s4,48(sp)
    11f8:	7aa2                	ld	s5,40(sp)
    11fa:	7b02                	ld	s6,32(sp)
    11fc:	6be2                	ld	s7,24(sp)
    11fe:	6c42                	ld	s8,16(sp)
    1200:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1202:	60e6                	ld	ra,88(sp)
    1204:	6446                	ld	s0,80(sp)
    1206:	6906                	ld	s2,64(sp)
    1208:	6125                	addi	sp,sp,96
    120a:	8082                	ret

000000000000120c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    120c:	715d                	addi	sp,sp,-80
    120e:	ec06                	sd	ra,24(sp)
    1210:	e822                	sd	s0,16(sp)
    1212:	1000                	addi	s0,sp,32
    1214:	e010                	sd	a2,0(s0)
    1216:	e414                	sd	a3,8(s0)
    1218:	e818                	sd	a4,16(s0)
    121a:	ec1c                	sd	a5,24(s0)
    121c:	03043023          	sd	a6,32(s0)
    1220:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1224:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1228:	8622                	mv	a2,s0
    122a:	d5bff0ef          	jal	f84 <vprintf>
}
    122e:	60e2                	ld	ra,24(sp)
    1230:	6442                	ld	s0,16(sp)
    1232:	6161                	addi	sp,sp,80
    1234:	8082                	ret

0000000000001236 <printf>:

void
printf(const char *fmt, ...)
{
    1236:	711d                	addi	sp,sp,-96
    1238:	ec06                	sd	ra,24(sp)
    123a:	e822                	sd	s0,16(sp)
    123c:	1000                	addi	s0,sp,32
    123e:	e40c                	sd	a1,8(s0)
    1240:	e810                	sd	a2,16(s0)
    1242:	ec14                	sd	a3,24(s0)
    1244:	f018                	sd	a4,32(s0)
    1246:	f41c                	sd	a5,40(s0)
    1248:	03043823          	sd	a6,48(s0)
    124c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1250:	00840613          	addi	a2,s0,8
    1254:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1258:	85aa                	mv	a1,a0
    125a:	4505                	li	a0,1
    125c:	d29ff0ef          	jal	f84 <vprintf>
}
    1260:	60e2                	ld	ra,24(sp)
    1262:	6442                	ld	s0,16(sp)
    1264:	6125                	addi	sp,sp,96
    1266:	8082                	ret

0000000000001268 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1268:	1141                	addi	sp,sp,-16
    126a:	e422                	sd	s0,8(sp)
    126c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    126e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1272:	00001797          	auipc	a5,0x1
    1276:	d9e7b783          	ld	a5,-610(a5) # 2010 <freep>
    127a:	a02d                	j	12a4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    127c:	4618                	lw	a4,8(a2)
    127e:	9f2d                	addw	a4,a4,a1
    1280:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1284:	6398                	ld	a4,0(a5)
    1286:	6310                	ld	a2,0(a4)
    1288:	a83d                	j	12c6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    128a:	ff852703          	lw	a4,-8(a0)
    128e:	9f31                	addw	a4,a4,a2
    1290:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1292:	ff053683          	ld	a3,-16(a0)
    1296:	a091                	j	12da <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1298:	6398                	ld	a4,0(a5)
    129a:	00e7e463          	bltu	a5,a4,12a2 <free+0x3a>
    129e:	00e6ea63          	bltu	a3,a4,12b2 <free+0x4a>
{
    12a2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12a4:	fed7fae3          	bgeu	a5,a3,1298 <free+0x30>
    12a8:	6398                	ld	a4,0(a5)
    12aa:	00e6e463          	bltu	a3,a4,12b2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12ae:	fee7eae3          	bltu	a5,a4,12a2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    12b2:	ff852583          	lw	a1,-8(a0)
    12b6:	6390                	ld	a2,0(a5)
    12b8:	02059813          	slli	a6,a1,0x20
    12bc:	01c85713          	srli	a4,a6,0x1c
    12c0:	9736                	add	a4,a4,a3
    12c2:	fae60de3          	beq	a2,a4,127c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    12c6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12ca:	4790                	lw	a2,8(a5)
    12cc:	02061593          	slli	a1,a2,0x20
    12d0:	01c5d713          	srli	a4,a1,0x1c
    12d4:	973e                	add	a4,a4,a5
    12d6:	fae68ae3          	beq	a3,a4,128a <free+0x22>
    p->s.ptr = bp->s.ptr;
    12da:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    12dc:	00001717          	auipc	a4,0x1
    12e0:	d2f73a23          	sd	a5,-716(a4) # 2010 <freep>
}
    12e4:	6422                	ld	s0,8(sp)
    12e6:	0141                	addi	sp,sp,16
    12e8:	8082                	ret

00000000000012ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12ea:	7139                	addi	sp,sp,-64
    12ec:	fc06                	sd	ra,56(sp)
    12ee:	f822                	sd	s0,48(sp)
    12f0:	f426                	sd	s1,40(sp)
    12f2:	ec4e                	sd	s3,24(sp)
    12f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12f6:	02051493          	slli	s1,a0,0x20
    12fa:	9081                	srli	s1,s1,0x20
    12fc:	04bd                	addi	s1,s1,15
    12fe:	8091                	srli	s1,s1,0x4
    1300:	0014899b          	addiw	s3,s1,1
    1304:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1306:	00001517          	auipc	a0,0x1
    130a:	d0a53503          	ld	a0,-758(a0) # 2010 <freep>
    130e:	c915                	beqz	a0,1342 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1310:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1312:	4798                	lw	a4,8(a5)
    1314:	08977a63          	bgeu	a4,s1,13a8 <malloc+0xbe>
    1318:	f04a                	sd	s2,32(sp)
    131a:	e852                	sd	s4,16(sp)
    131c:	e456                	sd	s5,8(sp)
    131e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1320:	8a4e                	mv	s4,s3
    1322:	0009871b          	sext.w	a4,s3
    1326:	6685                	lui	a3,0x1
    1328:	00d77363          	bgeu	a4,a3,132e <malloc+0x44>
    132c:	6a05                	lui	s4,0x1
    132e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1332:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1336:	00001917          	auipc	s2,0x1
    133a:	cda90913          	addi	s2,s2,-806 # 2010 <freep>
  if(p == (char*)-1)
    133e:	5afd                	li	s5,-1
    1340:	a081                	j	1380 <malloc+0x96>
    1342:	f04a                	sd	s2,32(sp)
    1344:	e852                	sd	s4,16(sp)
    1346:	e456                	sd	s5,8(sp)
    1348:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    134a:	00001797          	auipc	a5,0x1
    134e:	d3e78793          	addi	a5,a5,-706 # 2088 <base>
    1352:	00001717          	auipc	a4,0x1
    1356:	caf73f23          	sd	a5,-834(a4) # 2010 <freep>
    135a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    135c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1360:	b7c1                	j	1320 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1362:	6398                	ld	a4,0(a5)
    1364:	e118                	sd	a4,0(a0)
    1366:	a8a9                	j	13c0 <malloc+0xd6>
  hp->s.size = nu;
    1368:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    136c:	0541                	addi	a0,a0,16
    136e:	efbff0ef          	jal	1268 <free>
  return freep;
    1372:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1376:	c12d                	beqz	a0,13d8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1378:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    137a:	4798                	lw	a4,8(a5)
    137c:	02977263          	bgeu	a4,s1,13a0 <malloc+0xb6>
    if(p == freep)
    1380:	00093703          	ld	a4,0(s2)
    1384:	853e                	mv	a0,a5
    1386:	fef719e3          	bne	a4,a5,1378 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    138a:	8552                	mv	a0,s4
    138c:	b13ff0ef          	jal	e9e <sbrk>
  if(p == (char*)-1)
    1390:	fd551ce3          	bne	a0,s5,1368 <malloc+0x7e>
        return 0;
    1394:	4501                	li	a0,0
    1396:	7902                	ld	s2,32(sp)
    1398:	6a42                	ld	s4,16(sp)
    139a:	6aa2                	ld	s5,8(sp)
    139c:	6b02                	ld	s6,0(sp)
    139e:	a03d                	j	13cc <malloc+0xe2>
    13a0:	7902                	ld	s2,32(sp)
    13a2:	6a42                	ld	s4,16(sp)
    13a4:	6aa2                	ld	s5,8(sp)
    13a6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    13a8:	fae48de3          	beq	s1,a4,1362 <malloc+0x78>
        p->s.size -= nunits;
    13ac:	4137073b          	subw	a4,a4,s3
    13b0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13b2:	02071693          	slli	a3,a4,0x20
    13b6:	01c6d713          	srli	a4,a3,0x1c
    13ba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13bc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13c0:	00001717          	auipc	a4,0x1
    13c4:	c4a73823          	sd	a0,-944(a4) # 2010 <freep>
      return (void*)(p + 1);
    13c8:	01078513          	addi	a0,a5,16
  }
}
    13cc:	70e2                	ld	ra,56(sp)
    13ce:	7442                	ld	s0,48(sp)
    13d0:	74a2                	ld	s1,40(sp)
    13d2:	69e2                	ld	s3,24(sp)
    13d4:	6121                	addi	sp,sp,64
    13d6:	8082                	ret
    13d8:	7902                	ld	s2,32(sp)
    13da:	6a42                	ld	s4,16(sp)
    13dc:	6aa2                	ld	s5,8(sp)
    13de:	6b02                	ld	s6,0(sp)
    13e0:	b7f5                	j	13cc <malloc+0xe2>
