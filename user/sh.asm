
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
      16:	3de58593          	addi	a1,a1,990 # 13f0 <malloc+0x104>
      1a:	4509                	li	a0,2
      1c:	625000ef          	jal	e40 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	415000ef          	jal	c3a <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	453000ef          	jal	c80 <gets>
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
      58:	3ac58593          	addi	a1,a1,940 # 1400 <malloc+0x114>
      5c:	4509                	li	a0,2
      5e:	1b0010ef          	jal	120e <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	5bd000ef          	jal	e20 <exit>

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
      70:	5a9000ef          	jal	e18 <fork>
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
      86:	38e50513          	addi	a0,a0,910 # 1410 <malloc+0x124>
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
      c4:	48870713          	addi	a4,a4,1160 # 1548 <malloc+0x25c>
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
      f6:	52b000ef          	jal	e20 <exit>
      fa:	43513c23          	sd	s5,1080(sp)
      fe:	43613823          	sd	s6,1072(sp)
     102:	43713423          	sd	s7,1064(sp)
     106:	43813023          	sd	s8,1056(sp)
     10a:	41913c23          	sd	s9,1048(sp)
    panic("runcmd");
     10e:	00001517          	auipc	a0,0x1
     112:	30a50513          	addi	a0,a0,778 # 1418 <malloc+0x12c>
     116:	f35ff0ef          	jal	4a <panic>
    if (ecmd->argv[0] == 0)
     11a:	00853983          	ld	s3,8(a0)
     11e:	04098763          	beqz	s3,16c <runcmd+0xde>
    if (ecmd->argv[0] && strcmp(ecmd->argv[0], "!") == 0) {
     122:	00001597          	auipc	a1,0x1
     126:	2fe58593          	addi	a1,a1,766 # 1420 <malloc+0x134>
     12a:	854e                	mv	a0,s3
     12c:	2b9000ef          	jal	be4 <strcmp>
     130:	8a2a                	mv	s4,a0
     132:	10051b63          	bnez	a0,248 <runcmd+0x1ba>
     136:	43513c23          	sd	s5,1080(sp)
     13a:	43613823          	sd	s6,1072(sp)
     13e:	43713423          	sd	s7,1064(sp)
     142:	43813023          	sd	s8,1056(sp)
     146:	41913c23          	sd	s9,1048(sp)
        char buf[1024] = {0};
     14a:	40000613          	li	a2,1024
     14e:	4581                	li	a1,0
     150:	b9840513          	addi	a0,s0,-1128
     154:	2e7000ef          	jal	c3a <memset>
        for (int i = 1; ecmd->argv[i] != 0; i++) {
     158:	6888                	ld	a0,16(s1)
     15a:	cd71                	beqz	a0,236 <runcmd+0x1a8>
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
        exit(1);
     180:	4505                	li	a0,1
     182:	49f000ef          	jal	e20 <exit>
                buf[len++] = ' ';
     186:	fa0c8793          	addi	a5,s9,-96
     18a:	00878cb3          	add	s9,a5,s0
     18e:	bf8c8c23          	sb	s8,-1032(s9)
     192:	00198c9b          	addiw	s9,s3,1
     196:	8ae6                	mv	s5,s9
            int arglen = strlen(ecmd->argv[i]);
     198:	279000ef          	jal	c10 <strlen>
            if (len + arglen >= sizeof(buf)) {
     19c:	015509bb          	addw	s3,a0,s5
     1a0:	00098c9b          	sext.w	s9,s3
     1a4:	039b6063          	bltu	s6,s9,1c4 <runcmd+0x136>
            strcpy(buf + len, ecmd->argv[i]);
     1a8:	608c                	ld	a1,0(s1)
     1aa:	b9840793          	addi	a5,s0,-1128
     1ae:	01578533          	add	a0,a5,s5
     1b2:	217000ef          	jal	bc8 <strcpy>
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
     1c8:	26450513          	addi	a0,a0,612 # 1428 <malloc+0x13c>
     1cc:	06c010ef          	jal	1238 <printf>
                exit(1);
     1d0:	4505                	li	a0,1
     1d2:	44f000ef          	jal	e20 <exit>
                printf("%c", buf[i]);
     1d6:	00001917          	auipc	s2,0x1
     1da:	27a90913          	addi	s2,s2,634 # 1450 <malloc+0x164>
            if (i + 1 < len && buf[i] == 'o' && buf[i+1] == 's') {
     1de:	06f00993          	li	s3,111
     1e2:	07300a93          	li	s5,115
     1e6:	a819                	j	1fc <runcmd+0x16e>
                printf("%c", buf[i]);
     1e8:	fa0a0793          	addi	a5,s4,-96
     1ec:	00878a33          	add	s4,a5,s0
     1f0:	bf8a4583          	lbu	a1,-1032(s4)
     1f4:	854a                	mv	a0,s2
     1f6:	042010ef          	jal	1238 <printf>
        int len = 0;
     1fa:	8a26                	mv	s4,s1
        for (int i = 0; i < len; ) {
     1fc:	039a5d63          	bge	s4,s9,236 <runcmd+0x1a8>
            if (i + 1 < len && buf[i] == 'o' && buf[i+1] == 's') {
     200:	001a049b          	addiw	s1,s4,1
     204:	ff94d2e3          	bge	s1,s9,1e8 <runcmd+0x15a>
     208:	fa0a0793          	addi	a5,s4,-96
     20c:	97a2                	add	a5,a5,s0
     20e:	bf87c783          	lbu	a5,-1032(a5)
     212:	fd379be3          	bne	a5,s3,1e8 <runcmd+0x15a>
     216:	fa048793          	addi	a5,s1,-96
     21a:	97a2                	add	a5,a5,s0
     21c:	bf87c783          	lbu	a5,-1032(a5)
     220:	fd5794e3          	bne	a5,s5,1e8 <runcmd+0x15a>
                printf("\033[34mos\033[0m");
     224:	00001517          	auipc	a0,0x1
     228:	21c50513          	addi	a0,a0,540 # 1440 <malloc+0x154>
     22c:	00c010ef          	jal	1238 <printf>
                i += 2;
     230:	002a049b          	addiw	s1,s4,2
     234:	b7d9                	j	1fa <runcmd+0x16c>
        printf("\n");
     236:	00001517          	auipc	a0,0x1
     23a:	20250513          	addi	a0,a0,514 # 1438 <malloc+0x14c>
     23e:	7fb000ef          	jal	1238 <printf>
        exit(0);
     242:	4501                	li	a0,0
     244:	3dd000ef          	jal	e20 <exit>
    exec(ecmd->argv[0], ecmd->argv);
     248:	00848593          	addi	a1,s1,8
     24c:	854e                	mv	a0,s3
     24e:	40b000ef          	jal	e58 <exec>
    printf("exec %s failed\n", ecmd->argv[0]);
     252:	648c                	ld	a1,8(s1)
     254:	00001517          	auipc	a0,0x1
     258:	20450513          	addi	a0,a0,516 # 1458 <malloc+0x16c>
     25c:	7dd000ef          	jal	1238 <printf>
    break;
     260:	a28d                	j	3c2 <runcmd+0x334>
    close(rcmd->fd);
     262:	5148                	lw	a0,36(a0)
     264:	3e5000ef          	jal	e48 <close>
    if (open(rcmd->file, rcmd->mode) < 0)
     268:	508c                	lw	a1,32(s1)
     26a:	6888                	ld	a0,16(s1)
     26c:	3f5000ef          	jal	e60 <open>
     270:	00054f63          	bltz	a0,28e <runcmd+0x200>
     274:	43513c23          	sd	s5,1080(sp)
     278:	43613823          	sd	s6,1072(sp)
     27c:	43713423          	sd	s7,1064(sp)
     280:	43813023          	sd	s8,1056(sp)
     284:	41913c23          	sd	s9,1048(sp)
    runcmd(rcmd->cmd);
     288:	6488                	ld	a0,8(s1)
     28a:	e05ff0ef          	jal	8e <runcmd>
     28e:	43513c23          	sd	s5,1080(sp)
     292:	43613823          	sd	s6,1072(sp)
     296:	43713423          	sd	s7,1064(sp)
     29a:	43813023          	sd	s8,1056(sp)
     29e:	41913c23          	sd	s9,1048(sp)
      fprintf(2, "open %s failed\n", rcmd->file);
     2a2:	6890                	ld	a2,16(s1)
     2a4:	00001597          	auipc	a1,0x1
     2a8:	1c458593          	addi	a1,a1,452 # 1468 <malloc+0x17c>
     2ac:	4509                	li	a0,2
     2ae:	761000ef          	jal	120e <fprintf>
      exit(1);
     2b2:	4505                	li	a0,1
     2b4:	36d000ef          	jal	e20 <exit>
    if (fork1() == 0)
     2b8:	db1ff0ef          	jal	68 <fork1>
     2bc:	ed11                	bnez	a0,2d8 <runcmd+0x24a>
     2be:	43513c23          	sd	s5,1080(sp)
     2c2:	43613823          	sd	s6,1072(sp)
     2c6:	43713423          	sd	s7,1064(sp)
     2ca:	43813023          	sd	s8,1056(sp)
     2ce:	41913c23          	sd	s9,1048(sp)
      runcmd(lcmd->left);
     2d2:	6488                	ld	a0,8(s1)
     2d4:	dbbff0ef          	jal	8e <runcmd>
     2d8:	43513c23          	sd	s5,1080(sp)
     2dc:	43613823          	sd	s6,1072(sp)
     2e0:	43713423          	sd	s7,1064(sp)
     2e4:	43813023          	sd	s8,1056(sp)
     2e8:	41913c23          	sd	s9,1048(sp)
    wait(0);
     2ec:	4501                	li	a0,0
     2ee:	33b000ef          	jal	e28 <wait>
    runcmd(lcmd->right);
     2f2:	6888                	ld	a0,16(s1)
     2f4:	d9bff0ef          	jal	8e <runcmd>
    if (pipe(p) < 0)
     2f8:	f9840513          	addi	a0,s0,-104
     2fc:	335000ef          	jal	e30 <pipe>
     300:	04054163          	bltz	a0,342 <runcmd+0x2b4>
    if (fork1() == 0)
     304:	d65ff0ef          	jal	68 <fork1>
     308:	ed29                	bnez	a0,362 <runcmd+0x2d4>
     30a:	43513c23          	sd	s5,1080(sp)
     30e:	43613823          	sd	s6,1072(sp)
     312:	43713423          	sd	s7,1064(sp)
     316:	43813023          	sd	s8,1056(sp)
     31a:	41913c23          	sd	s9,1048(sp)
      close(1);
     31e:	4505                	li	a0,1
     320:	329000ef          	jal	e48 <close>
      dup(p[1]);
     324:	f9c42503          	lw	a0,-100(s0)
     328:	371000ef          	jal	e98 <dup>
      close(p[0]);
     32c:	f9842503          	lw	a0,-104(s0)
     330:	319000ef          	jal	e48 <close>
      close(p[1]);
     334:	f9c42503          	lw	a0,-100(s0)
     338:	311000ef          	jal	e48 <close>
      runcmd(pcmd->left);
     33c:	6488                	ld	a0,8(s1)
     33e:	d51ff0ef          	jal	8e <runcmd>
     342:	43513c23          	sd	s5,1080(sp)
     346:	43613823          	sd	s6,1072(sp)
     34a:	43713423          	sd	s7,1064(sp)
     34e:	43813023          	sd	s8,1056(sp)
     352:	41913c23          	sd	s9,1048(sp)
      panic("pipe");
     356:	00001517          	auipc	a0,0x1
     35a:	12250513          	addi	a0,a0,290 # 1478 <malloc+0x18c>
     35e:	cedff0ef          	jal	4a <panic>
    if (fork1() == 0)
     362:	d07ff0ef          	jal	68 <fork1>
     366:	ed05                	bnez	a0,39e <runcmd+0x310>
     368:	43513c23          	sd	s5,1080(sp)
     36c:	43613823          	sd	s6,1072(sp)
     370:	43713423          	sd	s7,1064(sp)
     374:	43813023          	sd	s8,1056(sp)
     378:	41913c23          	sd	s9,1048(sp)
      close(0);
     37c:	2cd000ef          	jal	e48 <close>
      dup(p[0]);
     380:	f9842503          	lw	a0,-104(s0)
     384:	315000ef          	jal	e98 <dup>
      close(p[0]);
     388:	f9842503          	lw	a0,-104(s0)
     38c:	2bd000ef          	jal	e48 <close>
      close(p[1]);
     390:	f9c42503          	lw	a0,-100(s0)
     394:	2b5000ef          	jal	e48 <close>
      runcmd(pcmd->right);
     398:	6888                	ld	a0,16(s1)
     39a:	cf5ff0ef          	jal	8e <runcmd>
    close(p[0]);
     39e:	f9842503          	lw	a0,-104(s0)
     3a2:	2a7000ef          	jal	e48 <close>
    close(p[1]);
     3a6:	f9c42503          	lw	a0,-100(s0)
     3aa:	29f000ef          	jal	e48 <close>
    wait(0);
     3ae:	4501                	li	a0,0
     3b0:	279000ef          	jal	e28 <wait>
    wait(0);
     3b4:	4501                	li	a0,0
     3b6:	273000ef          	jal	e28 <wait>
    break;
     3ba:	a021                	j	3c2 <runcmd+0x334>
    if (fork1() == 0)
     3bc:	cadff0ef          	jal	68 <fork1>
     3c0:	cd11                	beqz	a0,3dc <runcmd+0x34e>
     3c2:	43513c23          	sd	s5,1080(sp)
     3c6:	43613823          	sd	s6,1072(sp)
     3ca:	43713423          	sd	s7,1064(sp)
     3ce:	43813023          	sd	s8,1056(sp)
     3d2:	41913c23          	sd	s9,1048(sp)
  exit(0);
     3d6:	4501                	li	a0,0
     3d8:	249000ef          	jal	e20 <exit>
     3dc:	43513c23          	sd	s5,1080(sp)
     3e0:	43613823          	sd	s6,1072(sp)
     3e4:	43713423          	sd	s7,1064(sp)
     3e8:	43813023          	sd	s8,1056(sp)
     3ec:	41913c23          	sd	s9,1048(sp)
      runcmd(bcmd->cmd);
     3f0:	6488                	ld	a0,8(s1)
     3f2:	c9dff0ef          	jal	8e <runcmd>

00000000000003f6 <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     3f6:	1101                	addi	sp,sp,-32
     3f8:	ec06                	sd	ra,24(sp)
     3fa:	e822                	sd	s0,16(sp)
     3fc:	e426                	sd	s1,8(sp)
     3fe:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     400:	0a800513          	li	a0,168
     404:	6e9000ef          	jal	12ec <malloc>
     408:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     40a:	0a800613          	li	a2,168
     40e:	4581                	li	a1,0
     410:	02b000ef          	jal	c3a <memset>
  cmd->type = EXEC;
     414:	4785                	li	a5,1
     416:	c09c                	sw	a5,0(s1)
  return (struct cmd *)cmd;
}
     418:	8526                	mv	a0,s1
     41a:	60e2                	ld	ra,24(sp)
     41c:	6442                	ld	s0,16(sp)
     41e:	64a2                	ld	s1,8(sp)
     420:	6105                	addi	sp,sp,32
     422:	8082                	ret

0000000000000424 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     424:	7139                	addi	sp,sp,-64
     426:	fc06                	sd	ra,56(sp)
     428:	f822                	sd	s0,48(sp)
     42a:	f426                	sd	s1,40(sp)
     42c:	f04a                	sd	s2,32(sp)
     42e:	ec4e                	sd	s3,24(sp)
     430:	e852                	sd	s4,16(sp)
     432:	e456                	sd	s5,8(sp)
     434:	e05a                	sd	s6,0(sp)
     436:	0080                	addi	s0,sp,64
     438:	8b2a                	mv	s6,a0
     43a:	8aae                	mv	s5,a1
     43c:	8a32                	mv	s4,a2
     43e:	89b6                	mv	s3,a3
     440:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     442:	02800513          	li	a0,40
     446:	6a7000ef          	jal	12ec <malloc>
     44a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     44c:	02800613          	li	a2,40
     450:	4581                	li	a1,0
     452:	7e8000ef          	jal	c3a <memset>
  cmd->type = REDIR;
     456:	4789                	li	a5,2
     458:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     45a:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     45e:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     462:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     466:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     46a:	0324a223          	sw	s2,36(s1)
  return (struct cmd *)cmd;
}
     46e:	8526                	mv	a0,s1
     470:	70e2                	ld	ra,56(sp)
     472:	7442                	ld	s0,48(sp)
     474:	74a2                	ld	s1,40(sp)
     476:	7902                	ld	s2,32(sp)
     478:	69e2                	ld	s3,24(sp)
     47a:	6a42                	ld	s4,16(sp)
     47c:	6aa2                	ld	s5,8(sp)
     47e:	6b02                	ld	s6,0(sp)
     480:	6121                	addi	sp,sp,64
     482:	8082                	ret

0000000000000484 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     484:	7179                	addi	sp,sp,-48
     486:	f406                	sd	ra,40(sp)
     488:	f022                	sd	s0,32(sp)
     48a:	ec26                	sd	s1,24(sp)
     48c:	e84a                	sd	s2,16(sp)
     48e:	e44e                	sd	s3,8(sp)
     490:	1800                	addi	s0,sp,48
     492:	89aa                	mv	s3,a0
     494:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     496:	4561                	li	a0,24
     498:	655000ef          	jal	12ec <malloc>
     49c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     49e:	4661                	li	a2,24
     4a0:	4581                	li	a1,0
     4a2:	798000ef          	jal	c3a <memset>
  cmd->type = PIPE;
     4a6:	478d                	li	a5,3
     4a8:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4aa:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4ae:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     4b2:	8526                	mv	a0,s1
     4b4:	70a2                	ld	ra,40(sp)
     4b6:	7402                	ld	s0,32(sp)
     4b8:	64e2                	ld	s1,24(sp)
     4ba:	6942                	ld	s2,16(sp)
     4bc:	69a2                	ld	s3,8(sp)
     4be:	6145                	addi	sp,sp,48
     4c0:	8082                	ret

00000000000004c2 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     4c2:	7179                	addi	sp,sp,-48
     4c4:	f406                	sd	ra,40(sp)
     4c6:	f022                	sd	s0,32(sp)
     4c8:	ec26                	sd	s1,24(sp)
     4ca:	e84a                	sd	s2,16(sp)
     4cc:	e44e                	sd	s3,8(sp)
     4ce:	1800                	addi	s0,sp,48
     4d0:	89aa                	mv	s3,a0
     4d2:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4d4:	4561                	li	a0,24
     4d6:	617000ef          	jal	12ec <malloc>
     4da:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4dc:	4661                	li	a2,24
     4de:	4581                	li	a1,0
     4e0:	75a000ef          	jal	c3a <memset>
  cmd->type = LIST;
     4e4:	4791                	li	a5,4
     4e6:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     4e8:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4ec:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     4f0:	8526                	mv	a0,s1
     4f2:	70a2                	ld	ra,40(sp)
     4f4:	7402                	ld	s0,32(sp)
     4f6:	64e2                	ld	s1,24(sp)
     4f8:	6942                	ld	s2,16(sp)
     4fa:	69a2                	ld	s3,8(sp)
     4fc:	6145                	addi	sp,sp,48
     4fe:	8082                	ret

0000000000000500 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     500:	1101                	addi	sp,sp,-32
     502:	ec06                	sd	ra,24(sp)
     504:	e822                	sd	s0,16(sp)
     506:	e426                	sd	s1,8(sp)
     508:	e04a                	sd	s2,0(sp)
     50a:	1000                	addi	s0,sp,32
     50c:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     50e:	4541                	li	a0,16
     510:	5dd000ef          	jal	12ec <malloc>
     514:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     516:	4641                	li	a2,16
     518:	4581                	li	a1,0
     51a:	720000ef          	jal	c3a <memset>
  cmd->type = BACK;
     51e:	4795                	li	a5,5
     520:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     522:	0124b423          	sd	s2,8(s1)
  return (struct cmd *)cmd;
}
     526:	8526                	mv	a0,s1
     528:	60e2                	ld	ra,24(sp)
     52a:	6442                	ld	s0,16(sp)
     52c:	64a2                	ld	s1,8(sp)
     52e:	6902                	ld	s2,0(sp)
     530:	6105                	addi	sp,sp,32
     532:	8082                	ret

0000000000000534 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     534:	7139                	addi	sp,sp,-64
     536:	fc06                	sd	ra,56(sp)
     538:	f822                	sd	s0,48(sp)
     53a:	f426                	sd	s1,40(sp)
     53c:	f04a                	sd	s2,32(sp)
     53e:	ec4e                	sd	s3,24(sp)
     540:	e852                	sd	s4,16(sp)
     542:	e456                	sd	s5,8(sp)
     544:	e05a                	sd	s6,0(sp)
     546:	0080                	addi	s0,sp,64
     548:	8a2a                	mv	s4,a0
     54a:	892e                	mv	s2,a1
     54c:	8ab2                	mv	s5,a2
     54e:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     550:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     552:	00002997          	auipc	s3,0x2
     556:	ab698993          	addi	s3,s3,-1354 # 2008 <whitespace>
     55a:	00b4fc63          	bgeu	s1,a1,572 <gettoken+0x3e>
     55e:	0004c583          	lbu	a1,0(s1)
     562:	854e                	mv	a0,s3
     564:	6f8000ef          	jal	c5c <strchr>
     568:	c509                	beqz	a0,572 <gettoken+0x3e>
    s++;
     56a:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     56c:	fe9919e3          	bne	s2,s1,55e <gettoken+0x2a>
     570:	84ca                	mv	s1,s2
  if (q)
     572:	000a8463          	beqz	s5,57a <gettoken+0x46>
    *q = s;
     576:	009ab023          	sd	s1,0(s5)
  ret = *s;
     57a:	0004c783          	lbu	a5,0(s1)
     57e:	00078a9b          	sext.w	s5,a5
  switch (*s)
     582:	03c00713          	li	a4,60
     586:	06f76463          	bltu	a4,a5,5ee <gettoken+0xba>
     58a:	03a00713          	li	a4,58
     58e:	00f76e63          	bltu	a4,a5,5aa <gettoken+0x76>
     592:	cf89                	beqz	a5,5ac <gettoken+0x78>
     594:	02600713          	li	a4,38
     598:	00e78963          	beq	a5,a4,5aa <gettoken+0x76>
     59c:	fd87879b          	addiw	a5,a5,-40
     5a0:	0ff7f793          	zext.b	a5,a5
     5a4:	4705                	li	a4,1
     5a6:	06f76b63          	bltu	a4,a5,61c <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5aa:	0485                	addi	s1,s1,1
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     5ac:	000b0463          	beqz	s6,5b4 <gettoken+0x80>
    *eq = s;
     5b0:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
     5b4:	00002997          	auipc	s3,0x2
     5b8:	a5498993          	addi	s3,s3,-1452 # 2008 <whitespace>
     5bc:	0124fc63          	bgeu	s1,s2,5d4 <gettoken+0xa0>
     5c0:	0004c583          	lbu	a1,0(s1)
     5c4:	854e                	mv	a0,s3
     5c6:	696000ef          	jal	c5c <strchr>
     5ca:	c509                	beqz	a0,5d4 <gettoken+0xa0>
    s++;
     5cc:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     5ce:	fe9919e3          	bne	s2,s1,5c0 <gettoken+0x8c>
     5d2:	84ca                	mv	s1,s2
  *ps = s;
     5d4:	009a3023          	sd	s1,0(s4)
  return ret;
}
     5d8:	8556                	mv	a0,s5
     5da:	70e2                	ld	ra,56(sp)
     5dc:	7442                	ld	s0,48(sp)
     5de:	74a2                	ld	s1,40(sp)
     5e0:	7902                	ld	s2,32(sp)
     5e2:	69e2                	ld	s3,24(sp)
     5e4:	6a42                	ld	s4,16(sp)
     5e6:	6aa2                	ld	s5,8(sp)
     5e8:	6b02                	ld	s6,0(sp)
     5ea:	6121                	addi	sp,sp,64
     5ec:	8082                	ret
  switch (*s)
     5ee:	03e00713          	li	a4,62
     5f2:	02e79163          	bne	a5,a4,614 <gettoken+0xe0>
    s++;
     5f6:	00148693          	addi	a3,s1,1
    if (*s == '>')
     5fa:	0014c703          	lbu	a4,1(s1)
     5fe:	03e00793          	li	a5,62
      s++;
     602:	0489                	addi	s1,s1,2
      ret = '+';
     604:	02b00a93          	li	s5,43
    if (*s == '>')
     608:	faf702e3          	beq	a4,a5,5ac <gettoken+0x78>
    s++;
     60c:	84b6                	mv	s1,a3
  ret = *s;
     60e:	03e00a93          	li	s5,62
     612:	bf69                	j	5ac <gettoken+0x78>
  switch (*s)
     614:	07c00713          	li	a4,124
     618:	f8e789e3          	beq	a5,a4,5aa <gettoken+0x76>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     61c:	00002997          	auipc	s3,0x2
     620:	9ec98993          	addi	s3,s3,-1556 # 2008 <whitespace>
     624:	00002a97          	auipc	s5,0x2
     628:	9dca8a93          	addi	s5,s5,-1572 # 2000 <symbols>
     62c:	0324fd63          	bgeu	s1,s2,666 <gettoken+0x132>
     630:	0004c583          	lbu	a1,0(s1)
     634:	854e                	mv	a0,s3
     636:	626000ef          	jal	c5c <strchr>
     63a:	e11d                	bnez	a0,660 <gettoken+0x12c>
     63c:	0004c583          	lbu	a1,0(s1)
     640:	8556                	mv	a0,s5
     642:	61a000ef          	jal	c5c <strchr>
     646:	e911                	bnez	a0,65a <gettoken+0x126>
      s++;
     648:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     64a:	fe9913e3          	bne	s2,s1,630 <gettoken+0xfc>
  if (eq)
     64e:	84ca                	mv	s1,s2
    ret = 'a';
     650:	06100a93          	li	s5,97
  if (eq)
     654:	f40b1ee3          	bnez	s6,5b0 <gettoken+0x7c>
     658:	bfb5                	j	5d4 <gettoken+0xa0>
    ret = 'a';
     65a:	06100a93          	li	s5,97
     65e:	b7b9                	j	5ac <gettoken+0x78>
     660:	06100a93          	li	s5,97
     664:	b7a1                	j	5ac <gettoken+0x78>
     666:	06100a93          	li	s5,97
  if (eq)
     66a:	f40b13e3          	bnez	s6,5b0 <gettoken+0x7c>
     66e:	b79d                	j	5d4 <gettoken+0xa0>

0000000000000670 <peek>:

int peek(char **ps, char *es, char *toks)
{
     670:	7139                	addi	sp,sp,-64
     672:	fc06                	sd	ra,56(sp)
     674:	f822                	sd	s0,48(sp)
     676:	f426                	sd	s1,40(sp)
     678:	f04a                	sd	s2,32(sp)
     67a:	ec4e                	sd	s3,24(sp)
     67c:	e852                	sd	s4,16(sp)
     67e:	e456                	sd	s5,8(sp)
     680:	0080                	addi	s0,sp,64
     682:	8a2a                	mv	s4,a0
     684:	892e                	mv	s2,a1
     686:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     688:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     68a:	00002997          	auipc	s3,0x2
     68e:	97e98993          	addi	s3,s3,-1666 # 2008 <whitespace>
     692:	00b4fc63          	bgeu	s1,a1,6aa <peek+0x3a>
     696:	0004c583          	lbu	a1,0(s1)
     69a:	854e                	mv	a0,s3
     69c:	5c0000ef          	jal	c5c <strchr>
     6a0:	c509                	beqz	a0,6aa <peek+0x3a>
    s++;
     6a2:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     6a4:	fe9919e3          	bne	s2,s1,696 <peek+0x26>
     6a8:	84ca                	mv	s1,s2
  *ps = s;
     6aa:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     6ae:	0004c583          	lbu	a1,0(s1)
     6b2:	4501                	li	a0,0
     6b4:	e991                	bnez	a1,6c8 <peek+0x58>
}
     6b6:	70e2                	ld	ra,56(sp)
     6b8:	7442                	ld	s0,48(sp)
     6ba:	74a2                	ld	s1,40(sp)
     6bc:	7902                	ld	s2,32(sp)
     6be:	69e2                	ld	s3,24(sp)
     6c0:	6a42                	ld	s4,16(sp)
     6c2:	6aa2                	ld	s5,8(sp)
     6c4:	6121                	addi	sp,sp,64
     6c6:	8082                	ret
  return *s && strchr(toks, *s);
     6c8:	8556                	mv	a0,s5
     6ca:	592000ef          	jal	c5c <strchr>
     6ce:	00a03533          	snez	a0,a0
     6d2:	b7d5                	j	6b6 <peek+0x46>

00000000000006d4 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6d4:	711d                	addi	sp,sp,-96
     6d6:	ec86                	sd	ra,88(sp)
     6d8:	e8a2                	sd	s0,80(sp)
     6da:	e4a6                	sd	s1,72(sp)
     6dc:	e0ca                	sd	s2,64(sp)
     6de:	fc4e                	sd	s3,56(sp)
     6e0:	f852                	sd	s4,48(sp)
     6e2:	f456                	sd	s5,40(sp)
     6e4:	f05a                	sd	s6,32(sp)
     6e6:	ec5e                	sd	s7,24(sp)
     6e8:	1080                	addi	s0,sp,96
     6ea:	8a2a                	mv	s4,a0
     6ec:	89ae                	mv	s3,a1
     6ee:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>"))
     6f0:	00001a97          	auipc	s5,0x1
     6f4:	db0a8a93          	addi	s5,s5,-592 # 14a0 <malloc+0x1b4>
  {
    tok = gettoken(ps, es, 0, 0);
    if (gettoken(ps, es, &q, &eq) != 'a')
     6f8:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch (tok)
     6fc:	03c00b93          	li	s7,60
  while (peek(ps, es, "<>"))
     700:	a00d                	j	722 <parseredirs+0x4e>
      panic("missing file for redirection");
     702:	00001517          	auipc	a0,0x1
     706:	d7e50513          	addi	a0,a0,-642 # 1480 <malloc+0x194>
     70a:	941ff0ef          	jal	4a <panic>
    {
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     70e:	4701                	li	a4,0
     710:	4681                	li	a3,0
     712:	fa043603          	ld	a2,-96(s0)
     716:	fa843583          	ld	a1,-88(s0)
     71a:	8552                	mv	a0,s4
     71c:	d09ff0ef          	jal	424 <redircmd>
     720:	8a2a                	mv	s4,a0
  while (peek(ps, es, "<>"))
     722:	8656                	mv	a2,s5
     724:	85ca                	mv	a1,s2
     726:	854e                	mv	a0,s3
     728:	f49ff0ef          	jal	670 <peek>
     72c:	c525                	beqz	a0,794 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     72e:	4681                	li	a3,0
     730:	4601                	li	a2,0
     732:	85ca                	mv	a1,s2
     734:	854e                	mv	a0,s3
     736:	dffff0ef          	jal	534 <gettoken>
     73a:	84aa                	mv	s1,a0
    if (gettoken(ps, es, &q, &eq) != 'a')
     73c:	fa040693          	addi	a3,s0,-96
     740:	fa840613          	addi	a2,s0,-88
     744:	85ca                	mv	a1,s2
     746:	854e                	mv	a0,s3
     748:	dedff0ef          	jal	534 <gettoken>
     74c:	fb651be3          	bne	a0,s6,702 <parseredirs+0x2e>
    switch (tok)
     750:	fb748fe3          	beq	s1,s7,70e <parseredirs+0x3a>
     754:	03e00793          	li	a5,62
     758:	02f48263          	beq	s1,a5,77c <parseredirs+0xa8>
     75c:	02b00793          	li	a5,43
     760:	fcf491e3          	bne	s1,a5,722 <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     764:	4705                	li	a4,1
     766:	20100693          	li	a3,513
     76a:	fa043603          	ld	a2,-96(s0)
     76e:	fa843583          	ld	a1,-88(s0)
     772:	8552                	mv	a0,s4
     774:	cb1ff0ef          	jal	424 <redircmd>
     778:	8a2a                	mv	s4,a0
      break;
     77a:	b765                	j	722 <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     77c:	4705                	li	a4,1
     77e:	60100693          	li	a3,1537
     782:	fa043603          	ld	a2,-96(s0)
     786:	fa843583          	ld	a1,-88(s0)
     78a:	8552                	mv	a0,s4
     78c:	c99ff0ef          	jal	424 <redircmd>
     790:	8a2a                	mv	s4,a0
      break;
     792:	bf41                	j	722 <parseredirs+0x4e>
    }
  }
  return cmd;
}
     794:	8552                	mv	a0,s4
     796:	60e6                	ld	ra,88(sp)
     798:	6446                	ld	s0,80(sp)
     79a:	64a6                	ld	s1,72(sp)
     79c:	6906                	ld	s2,64(sp)
     79e:	79e2                	ld	s3,56(sp)
     7a0:	7a42                	ld	s4,48(sp)
     7a2:	7aa2                	ld	s5,40(sp)
     7a4:	7b02                	ld	s6,32(sp)
     7a6:	6be2                	ld	s7,24(sp)
     7a8:	6125                	addi	sp,sp,96
     7aa:	8082                	ret

00000000000007ac <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     7ac:	7159                	addi	sp,sp,-112
     7ae:	f486                	sd	ra,104(sp)
     7b0:	f0a2                	sd	s0,96(sp)
     7b2:	eca6                	sd	s1,88(sp)
     7b4:	e0d2                	sd	s4,64(sp)
     7b6:	fc56                	sd	s5,56(sp)
     7b8:	1880                	addi	s0,sp,112
     7ba:	8a2a                	mv	s4,a0
     7bc:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     7be:	00001617          	auipc	a2,0x1
     7c2:	cea60613          	addi	a2,a2,-790 # 14a8 <malloc+0x1bc>
     7c6:	eabff0ef          	jal	670 <peek>
     7ca:	e915                	bnez	a0,7fe <parseexec+0x52>
     7cc:	e8ca                	sd	s2,80(sp)
     7ce:	e4ce                	sd	s3,72(sp)
     7d0:	f85a                	sd	s6,48(sp)
     7d2:	f45e                	sd	s7,40(sp)
     7d4:	f062                	sd	s8,32(sp)
     7d6:	ec66                	sd	s9,24(sp)
     7d8:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     7da:	c1dff0ef          	jal	3f6 <execcmd>
     7de:	8c2a                	mv	s8,a0
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7e0:	8656                	mv	a2,s5
     7e2:	85d2                	mv	a1,s4
     7e4:	ef1ff0ef          	jal	6d4 <parseredirs>
     7e8:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     7ea:	008c0913          	addi	s2,s8,8
     7ee:	00001b17          	auipc	s6,0x1
     7f2:	cdab0b13          	addi	s6,s6,-806 # 14c8 <malloc+0x1dc>
  {
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
      break;
    if (tok != 'a')
     7f6:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
     7fa:	4ba9                	li	s7,10
  while (!peek(ps, es, "|)&;"))
     7fc:	a815                	j	830 <parseexec+0x84>
    return parseblock(ps, es);
     7fe:	85d6                	mv	a1,s5
     800:	8552                	mv	a0,s4
     802:	170000ef          	jal	972 <parseblock>
     806:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     808:	8526                	mv	a0,s1
     80a:	70a6                	ld	ra,104(sp)
     80c:	7406                	ld	s0,96(sp)
     80e:	64e6                	ld	s1,88(sp)
     810:	6a06                	ld	s4,64(sp)
     812:	7ae2                	ld	s5,56(sp)
     814:	6165                	addi	sp,sp,112
     816:	8082                	ret
      panic("syntax");
     818:	00001517          	auipc	a0,0x1
     81c:	c9850513          	addi	a0,a0,-872 # 14b0 <malloc+0x1c4>
     820:	82bff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     824:	8656                	mv	a2,s5
     826:	85d2                	mv	a1,s4
     828:	8526                	mv	a0,s1
     82a:	eabff0ef          	jal	6d4 <parseredirs>
     82e:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     830:	865a                	mv	a2,s6
     832:	85d6                	mv	a1,s5
     834:	8552                	mv	a0,s4
     836:	e3bff0ef          	jal	670 <peek>
     83a:	ed15                	bnez	a0,876 <parseexec+0xca>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     83c:	f9040693          	addi	a3,s0,-112
     840:	f9840613          	addi	a2,s0,-104
     844:	85d6                	mv	a1,s5
     846:	8552                	mv	a0,s4
     848:	cedff0ef          	jal	534 <gettoken>
     84c:	c50d                	beqz	a0,876 <parseexec+0xca>
    if (tok != 'a')
     84e:	fd9515e3          	bne	a0,s9,818 <parseexec+0x6c>
    cmd->argv[argc] = q;
     852:	f9843783          	ld	a5,-104(s0)
     856:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     85a:	f9043783          	ld	a5,-112(s0)
     85e:	04f93823          	sd	a5,80(s2)
    argc++;
     862:	2985                	addiw	s3,s3,1
    if (argc >= MAXARGS)
     864:	0921                	addi	s2,s2,8
     866:	fb799fe3          	bne	s3,s7,824 <parseexec+0x78>
      panic("too many args");
     86a:	00001517          	auipc	a0,0x1
     86e:	c4e50513          	addi	a0,a0,-946 # 14b8 <malloc+0x1cc>
     872:	fd8ff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     876:	098e                	slli	s3,s3,0x3
     878:	9c4e                	add	s8,s8,s3
     87a:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     87e:	040c3c23          	sd	zero,88(s8)
     882:	6946                	ld	s2,80(sp)
     884:	69a6                	ld	s3,72(sp)
     886:	7b42                	ld	s6,48(sp)
     888:	7ba2                	ld	s7,40(sp)
     88a:	7c02                	ld	s8,32(sp)
     88c:	6ce2                	ld	s9,24(sp)
  return ret;
     88e:	bfad                	j	808 <parseexec+0x5c>

0000000000000890 <parsepipe>:
{
     890:	7179                	addi	sp,sp,-48
     892:	f406                	sd	ra,40(sp)
     894:	f022                	sd	s0,32(sp)
     896:	ec26                	sd	s1,24(sp)
     898:	e84a                	sd	s2,16(sp)
     89a:	e44e                	sd	s3,8(sp)
     89c:	1800                	addi	s0,sp,48
     89e:	892a                	mv	s2,a0
     8a0:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     8a2:	f0bff0ef          	jal	7ac <parseexec>
     8a6:	84aa                	mv	s1,a0
  if (peek(ps, es, "|"))
     8a8:	00001617          	auipc	a2,0x1
     8ac:	c2860613          	addi	a2,a2,-984 # 14d0 <malloc+0x1e4>
     8b0:	85ce                	mv	a1,s3
     8b2:	854a                	mv	a0,s2
     8b4:	dbdff0ef          	jal	670 <peek>
     8b8:	e909                	bnez	a0,8ca <parsepipe+0x3a>
}
     8ba:	8526                	mv	a0,s1
     8bc:	70a2                	ld	ra,40(sp)
     8be:	7402                	ld	s0,32(sp)
     8c0:	64e2                	ld	s1,24(sp)
     8c2:	6942                	ld	s2,16(sp)
     8c4:	69a2                	ld	s3,8(sp)
     8c6:	6145                	addi	sp,sp,48
     8c8:	8082                	ret
    gettoken(ps, es, 0, 0);
     8ca:	4681                	li	a3,0
     8cc:	4601                	li	a2,0
     8ce:	85ce                	mv	a1,s3
     8d0:	854a                	mv	a0,s2
     8d2:	c63ff0ef          	jal	534 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8d6:	85ce                	mv	a1,s3
     8d8:	854a                	mv	a0,s2
     8da:	fb7ff0ef          	jal	890 <parsepipe>
     8de:	85aa                	mv	a1,a0
     8e0:	8526                	mv	a0,s1
     8e2:	ba3ff0ef          	jal	484 <pipecmd>
     8e6:	84aa                	mv	s1,a0
  return cmd;
     8e8:	bfc9                	j	8ba <parsepipe+0x2a>

00000000000008ea <parseline>:
{
     8ea:	7179                	addi	sp,sp,-48
     8ec:	f406                	sd	ra,40(sp)
     8ee:	f022                	sd	s0,32(sp)
     8f0:	ec26                	sd	s1,24(sp)
     8f2:	e84a                	sd	s2,16(sp)
     8f4:	e44e                	sd	s3,8(sp)
     8f6:	e052                	sd	s4,0(sp)
     8f8:	1800                	addi	s0,sp,48
     8fa:	892a                	mv	s2,a0
     8fc:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     8fe:	f93ff0ef          	jal	890 <parsepipe>
     902:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     904:	00001a17          	auipc	s4,0x1
     908:	bd4a0a13          	addi	s4,s4,-1068 # 14d8 <malloc+0x1ec>
     90c:	a819                	j	922 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     90e:	4681                	li	a3,0
     910:	4601                	li	a2,0
     912:	85ce                	mv	a1,s3
     914:	854a                	mv	a0,s2
     916:	c1fff0ef          	jal	534 <gettoken>
    cmd = backcmd(cmd);
     91a:	8526                	mv	a0,s1
     91c:	be5ff0ef          	jal	500 <backcmd>
     920:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     922:	8652                	mv	a2,s4
     924:	85ce                	mv	a1,s3
     926:	854a                	mv	a0,s2
     928:	d49ff0ef          	jal	670 <peek>
     92c:	f16d                	bnez	a0,90e <parseline+0x24>
  if (peek(ps, es, ";"))
     92e:	00001617          	auipc	a2,0x1
     932:	bb260613          	addi	a2,a2,-1102 # 14e0 <malloc+0x1f4>
     936:	85ce                	mv	a1,s3
     938:	854a                	mv	a0,s2
     93a:	d37ff0ef          	jal	670 <peek>
     93e:	e911                	bnez	a0,952 <parseline+0x68>
}
     940:	8526                	mv	a0,s1
     942:	70a2                	ld	ra,40(sp)
     944:	7402                	ld	s0,32(sp)
     946:	64e2                	ld	s1,24(sp)
     948:	6942                	ld	s2,16(sp)
     94a:	69a2                	ld	s3,8(sp)
     94c:	6a02                	ld	s4,0(sp)
     94e:	6145                	addi	sp,sp,48
     950:	8082                	ret
    gettoken(ps, es, 0, 0);
     952:	4681                	li	a3,0
     954:	4601                	li	a2,0
     956:	85ce                	mv	a1,s3
     958:	854a                	mv	a0,s2
     95a:	bdbff0ef          	jal	534 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     95e:	85ce                	mv	a1,s3
     960:	854a                	mv	a0,s2
     962:	f89ff0ef          	jal	8ea <parseline>
     966:	85aa                	mv	a1,a0
     968:	8526                	mv	a0,s1
     96a:	b59ff0ef          	jal	4c2 <listcmd>
     96e:	84aa                	mv	s1,a0
  return cmd;
     970:	bfc1                	j	940 <parseline+0x56>

0000000000000972 <parseblock>:
{
     972:	7179                	addi	sp,sp,-48
     974:	f406                	sd	ra,40(sp)
     976:	f022                	sd	s0,32(sp)
     978:	ec26                	sd	s1,24(sp)
     97a:	e84a                	sd	s2,16(sp)
     97c:	e44e                	sd	s3,8(sp)
     97e:	1800                	addi	s0,sp,48
     980:	84aa                	mv	s1,a0
     982:	892e                	mv	s2,a1
  if (!peek(ps, es, "("))
     984:	00001617          	auipc	a2,0x1
     988:	b2460613          	addi	a2,a2,-1244 # 14a8 <malloc+0x1bc>
     98c:	ce5ff0ef          	jal	670 <peek>
     990:	c539                	beqz	a0,9de <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     992:	4681                	li	a3,0
     994:	4601                	li	a2,0
     996:	85ca                	mv	a1,s2
     998:	8526                	mv	a0,s1
     99a:	b9bff0ef          	jal	534 <gettoken>
  cmd = parseline(ps, es);
     99e:	85ca                	mv	a1,s2
     9a0:	8526                	mv	a0,s1
     9a2:	f49ff0ef          	jal	8ea <parseline>
     9a6:	89aa                	mv	s3,a0
  if (!peek(ps, es, ")"))
     9a8:	00001617          	auipc	a2,0x1
     9ac:	b5060613          	addi	a2,a2,-1200 # 14f8 <malloc+0x20c>
     9b0:	85ca                	mv	a1,s2
     9b2:	8526                	mv	a0,s1
     9b4:	cbdff0ef          	jal	670 <peek>
     9b8:	c90d                	beqz	a0,9ea <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     9ba:	4681                	li	a3,0
     9bc:	4601                	li	a2,0
     9be:	85ca                	mv	a1,s2
     9c0:	8526                	mv	a0,s1
     9c2:	b73ff0ef          	jal	534 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     9c6:	864a                	mv	a2,s2
     9c8:	85a6                	mv	a1,s1
     9ca:	854e                	mv	a0,s3
     9cc:	d09ff0ef          	jal	6d4 <parseredirs>
}
     9d0:	70a2                	ld	ra,40(sp)
     9d2:	7402                	ld	s0,32(sp)
     9d4:	64e2                	ld	s1,24(sp)
     9d6:	6942                	ld	s2,16(sp)
     9d8:	69a2                	ld	s3,8(sp)
     9da:	6145                	addi	sp,sp,48
     9dc:	8082                	ret
    panic("parseblock");
     9de:	00001517          	auipc	a0,0x1
     9e2:	b0a50513          	addi	a0,a0,-1270 # 14e8 <malloc+0x1fc>
     9e6:	e64ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     9ea:	00001517          	auipc	a0,0x1
     9ee:	b1650513          	addi	a0,a0,-1258 # 1500 <malloc+0x214>
     9f2:	e58ff0ef          	jal	4a <panic>

00000000000009f6 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     9f6:	1101                	addi	sp,sp,-32
     9f8:	ec06                	sd	ra,24(sp)
     9fa:	e822                	sd	s0,16(sp)
     9fc:	e426                	sd	s1,8(sp)
     9fe:	1000                	addi	s0,sp,32
     a00:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     a02:	c131                	beqz	a0,a46 <nulterminate+0x50>
    return 0;

  switch (cmd->type)
     a04:	4118                	lw	a4,0(a0)
     a06:	4795                	li	a5,5
     a08:	02e7ef63          	bltu	a5,a4,a46 <nulterminate+0x50>
     a0c:	00056783          	lwu	a5,0(a0)
     a10:	078a                	slli	a5,a5,0x2
     a12:	00001717          	auipc	a4,0x1
     a16:	b4e70713          	addi	a4,a4,-1202 # 1560 <malloc+0x274>
     a1a:	97ba                	add	a5,a5,a4
     a1c:	439c                	lw	a5,0(a5)
     a1e:	97ba                	add	a5,a5,a4
     a20:	8782                	jr	a5
  {
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    for (i = 0; ecmd->argv[i]; i++)
     a22:	651c                	ld	a5,8(a0)
     a24:	c38d                	beqz	a5,a46 <nulterminate+0x50>
     a26:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     a2a:	67b8                	ld	a4,72(a5)
     a2c:	00070023          	sb	zero,0(a4)
    for (i = 0; ecmd->argv[i]; i++)
     a30:	07a1                	addi	a5,a5,8
     a32:	ff87b703          	ld	a4,-8(a5)
     a36:	fb75                	bnez	a4,a2a <nulterminate+0x34>
     a38:	a039                	j	a46 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    nulterminate(rcmd->cmd);
     a3a:	6508                	ld	a0,8(a0)
     a3c:	fbbff0ef          	jal	9f6 <nulterminate>
    *rcmd->efile = 0;
     a40:	6c9c                	ld	a5,24(s1)
     a42:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a46:	8526                	mv	a0,s1
     a48:	60e2                	ld	ra,24(sp)
     a4a:	6442                	ld	s0,16(sp)
     a4c:	64a2                	ld	s1,8(sp)
     a4e:	6105                	addi	sp,sp,32
     a50:	8082                	ret
    nulterminate(pcmd->left);
     a52:	6508                	ld	a0,8(a0)
     a54:	fa3ff0ef          	jal	9f6 <nulterminate>
    nulterminate(pcmd->right);
     a58:	6888                	ld	a0,16(s1)
     a5a:	f9dff0ef          	jal	9f6 <nulterminate>
    break;
     a5e:	b7e5                	j	a46 <nulterminate+0x50>
    nulterminate(lcmd->left);
     a60:	6508                	ld	a0,8(a0)
     a62:	f95ff0ef          	jal	9f6 <nulterminate>
    nulterminate(lcmd->right);
     a66:	6888                	ld	a0,16(s1)
     a68:	f8fff0ef          	jal	9f6 <nulterminate>
    break;
     a6c:	bfe9                	j	a46 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     a6e:	6508                	ld	a0,8(a0)
     a70:	f87ff0ef          	jal	9f6 <nulterminate>
    break;
     a74:	bfc9                	j	a46 <nulterminate+0x50>

0000000000000a76 <parsecmd>:
{
     a76:	7179                	addi	sp,sp,-48
     a78:	f406                	sd	ra,40(sp)
     a7a:	f022                	sd	s0,32(sp)
     a7c:	ec26                	sd	s1,24(sp)
     a7e:	e84a                	sd	s2,16(sp)
     a80:	1800                	addi	s0,sp,48
     a82:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     a86:	84aa                	mv	s1,a0
     a88:	188000ef          	jal	c10 <strlen>
     a8c:	1502                	slli	a0,a0,0x20
     a8e:	9101                	srli	a0,a0,0x20
     a90:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a92:	85a6                	mv	a1,s1
     a94:	fd840513          	addi	a0,s0,-40
     a98:	e53ff0ef          	jal	8ea <parseline>
     a9c:	892a                	mv	s2,a0
  peek(&s, es, "");
     a9e:	00001617          	auipc	a2,0x1
     aa2:	96a60613          	addi	a2,a2,-1686 # 1408 <malloc+0x11c>
     aa6:	85a6                	mv	a1,s1
     aa8:	fd840513          	addi	a0,s0,-40
     aac:	bc5ff0ef          	jal	670 <peek>
  if (s != es)
     ab0:	fd843603          	ld	a2,-40(s0)
     ab4:	00961c63          	bne	a2,s1,acc <parsecmd+0x56>
  nulterminate(cmd);
     ab8:	854a                	mv	a0,s2
     aba:	f3dff0ef          	jal	9f6 <nulterminate>
}
     abe:	854a                	mv	a0,s2
     ac0:	70a2                	ld	ra,40(sp)
     ac2:	7402                	ld	s0,32(sp)
     ac4:	64e2                	ld	s1,24(sp)
     ac6:	6942                	ld	s2,16(sp)
     ac8:	6145                	addi	sp,sp,48
     aca:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     acc:	00001597          	auipc	a1,0x1
     ad0:	a4c58593          	addi	a1,a1,-1460 # 1518 <malloc+0x22c>
     ad4:	4509                	li	a0,2
     ad6:	738000ef          	jal	120e <fprintf>
    panic("syntax");
     ada:	00001517          	auipc	a0,0x1
     ade:	9d650513          	addi	a0,a0,-1578 # 14b0 <malloc+0x1c4>
     ae2:	d68ff0ef          	jal	4a <panic>

0000000000000ae6 <main>:
{
     ae6:	7179                	addi	sp,sp,-48
     ae8:	f406                	sd	ra,40(sp)
     aea:	f022                	sd	s0,32(sp)
     aec:	ec26                	sd	s1,24(sp)
     aee:	e84a                	sd	s2,16(sp)
     af0:	e44e                	sd	s3,8(sp)
     af2:	e052                	sd	s4,0(sp)
     af4:	1800                	addi	s0,sp,48
  while ((fd = open("console", O_RDWR)) >= 0)
     af6:	00001497          	auipc	s1,0x1
     afa:	a3248493          	addi	s1,s1,-1486 # 1528 <malloc+0x23c>
     afe:	4589                	li	a1,2
     b00:	8526                	mv	a0,s1
     b02:	35e000ef          	jal	e60 <open>
     b06:	00054763          	bltz	a0,b14 <main+0x2e>
    if (fd >= 3)
     b0a:	4789                	li	a5,2
     b0c:	fea7d9e3          	bge	a5,a0,afe <main+0x18>
      close(fd);
     b10:	338000ef          	jal	e48 <close>
  while (getcmd(buf, sizeof(buf)) >= 0)
     b14:	00001497          	auipc	s1,0x1
     b18:	50c48493          	addi	s1,s1,1292 # 2020 <buf.0>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     b1c:	06300913          	li	s2,99
     b20:	02000993          	li	s3,32
     b24:	a039                	j	b32 <main+0x4c>
    if (fork1() == 0)
     b26:	d42ff0ef          	jal	68 <fork1>
     b2a:	c93d                	beqz	a0,ba0 <main+0xba>
    wait(0);
     b2c:	4501                	li	a0,0
     b2e:	2fa000ef          	jal	e28 <wait>
  while (getcmd(buf, sizeof(buf)) >= 0)
     b32:	06400593          	li	a1,100
     b36:	8526                	mv	a0,s1
     b38:	cc8ff0ef          	jal	0 <getcmd>
     b3c:	06054a63          	bltz	a0,bb0 <main+0xca>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     b40:	0004c783          	lbu	a5,0(s1)
     b44:	ff2791e3          	bne	a5,s2,b26 <main+0x40>
     b48:	0014c703          	lbu	a4,1(s1)
     b4c:	06400793          	li	a5,100
     b50:	fcf71be3          	bne	a4,a5,b26 <main+0x40>
     b54:	0024c783          	lbu	a5,2(s1)
     b58:	fd3797e3          	bne	a5,s3,b26 <main+0x40>
      buf[strlen(buf) - 1] = 0; // chop \n
     b5c:	00001a17          	auipc	s4,0x1
     b60:	4c4a0a13          	addi	s4,s4,1220 # 2020 <buf.0>
     b64:	8552                	mv	a0,s4
     b66:	0aa000ef          	jal	c10 <strlen>
     b6a:	fff5079b          	addiw	a5,a0,-1
     b6e:	1782                	slli	a5,a5,0x20
     b70:	9381                	srli	a5,a5,0x20
     b72:	9a3e                	add	s4,s4,a5
     b74:	000a0023          	sb	zero,0(s4)
      if (chdir(buf + 3) < 0)
     b78:	00001517          	auipc	a0,0x1
     b7c:	4ab50513          	addi	a0,a0,1195 # 2023 <buf.0+0x3>
     b80:	310000ef          	jal	e90 <chdir>
     b84:	fa0557e3          	bgez	a0,b32 <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf + 3);
     b88:	00001617          	auipc	a2,0x1
     b8c:	49b60613          	addi	a2,a2,1179 # 2023 <buf.0+0x3>
     b90:	00001597          	auipc	a1,0x1
     b94:	9a058593          	addi	a1,a1,-1632 # 1530 <malloc+0x244>
     b98:	4509                	li	a0,2
     b9a:	674000ef          	jal	120e <fprintf>
     b9e:	bf51                	j	b32 <main+0x4c>
      runcmd(parsecmd(buf));
     ba0:	00001517          	auipc	a0,0x1
     ba4:	48050513          	addi	a0,a0,1152 # 2020 <buf.0>
     ba8:	ecfff0ef          	jal	a76 <parsecmd>
     bac:	ce2ff0ef          	jal	8e <runcmd>
  exit(0);
     bb0:	4501                	li	a0,0
     bb2:	26e000ef          	jal	e20 <exit>

0000000000000bb6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     bb6:	1141                	addi	sp,sp,-16
     bb8:	e406                	sd	ra,8(sp)
     bba:	e022                	sd	s0,0(sp)
     bbc:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bbe:	f29ff0ef          	jal	ae6 <main>
  exit(0);
     bc2:	4501                	li	a0,0
     bc4:	25c000ef          	jal	e20 <exit>

0000000000000bc8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bc8:	1141                	addi	sp,sp,-16
     bca:	e422                	sd	s0,8(sp)
     bcc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bce:	87aa                	mv	a5,a0
     bd0:	0585                	addi	a1,a1,1
     bd2:	0785                	addi	a5,a5,1
     bd4:	fff5c703          	lbu	a4,-1(a1)
     bd8:	fee78fa3          	sb	a4,-1(a5)
     bdc:	fb75                	bnez	a4,bd0 <strcpy+0x8>
    ;
  return os;
}
     bde:	6422                	ld	s0,8(sp)
     be0:	0141                	addi	sp,sp,16
     be2:	8082                	ret

0000000000000be4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     be4:	1141                	addi	sp,sp,-16
     be6:	e422                	sd	s0,8(sp)
     be8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bea:	00054783          	lbu	a5,0(a0)
     bee:	cb91                	beqz	a5,c02 <strcmp+0x1e>
     bf0:	0005c703          	lbu	a4,0(a1)
     bf4:	00f71763          	bne	a4,a5,c02 <strcmp+0x1e>
    p++, q++;
     bf8:	0505                	addi	a0,a0,1
     bfa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bfc:	00054783          	lbu	a5,0(a0)
     c00:	fbe5                	bnez	a5,bf0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c02:	0005c503          	lbu	a0,0(a1)
}
     c06:	40a7853b          	subw	a0,a5,a0
     c0a:	6422                	ld	s0,8(sp)
     c0c:	0141                	addi	sp,sp,16
     c0e:	8082                	ret

0000000000000c10 <strlen>:

uint
strlen(const char *s)
{
     c10:	1141                	addi	sp,sp,-16
     c12:	e422                	sd	s0,8(sp)
     c14:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c16:	00054783          	lbu	a5,0(a0)
     c1a:	cf91                	beqz	a5,c36 <strlen+0x26>
     c1c:	0505                	addi	a0,a0,1
     c1e:	87aa                	mv	a5,a0
     c20:	86be                	mv	a3,a5
     c22:	0785                	addi	a5,a5,1
     c24:	fff7c703          	lbu	a4,-1(a5)
     c28:	ff65                	bnez	a4,c20 <strlen+0x10>
     c2a:	40a6853b          	subw	a0,a3,a0
     c2e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c30:	6422                	ld	s0,8(sp)
     c32:	0141                	addi	sp,sp,16
     c34:	8082                	ret
  for(n = 0; s[n]; n++)
     c36:	4501                	li	a0,0
     c38:	bfe5                	j	c30 <strlen+0x20>

0000000000000c3a <memset>:

void*
memset(void *dst, int c, uint n)
{
     c3a:	1141                	addi	sp,sp,-16
     c3c:	e422                	sd	s0,8(sp)
     c3e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c40:	ca19                	beqz	a2,c56 <memset+0x1c>
     c42:	87aa                	mv	a5,a0
     c44:	1602                	slli	a2,a2,0x20
     c46:	9201                	srli	a2,a2,0x20
     c48:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c4c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c50:	0785                	addi	a5,a5,1
     c52:	fee79de3          	bne	a5,a4,c4c <memset+0x12>
  }
  return dst;
}
     c56:	6422                	ld	s0,8(sp)
     c58:	0141                	addi	sp,sp,16
     c5a:	8082                	ret

0000000000000c5c <strchr>:

char*
strchr(const char *s, char c)
{
     c5c:	1141                	addi	sp,sp,-16
     c5e:	e422                	sd	s0,8(sp)
     c60:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c62:	00054783          	lbu	a5,0(a0)
     c66:	cb99                	beqz	a5,c7c <strchr+0x20>
    if(*s == c)
     c68:	00f58763          	beq	a1,a5,c76 <strchr+0x1a>
  for(; *s; s++)
     c6c:	0505                	addi	a0,a0,1
     c6e:	00054783          	lbu	a5,0(a0)
     c72:	fbfd                	bnez	a5,c68 <strchr+0xc>
      return (char*)s;
  return 0;
     c74:	4501                	li	a0,0
}
     c76:	6422                	ld	s0,8(sp)
     c78:	0141                	addi	sp,sp,16
     c7a:	8082                	ret
  return 0;
     c7c:	4501                	li	a0,0
     c7e:	bfe5                	j	c76 <strchr+0x1a>

0000000000000c80 <gets>:

char*
gets(char *buf, int max)
{
     c80:	711d                	addi	sp,sp,-96
     c82:	ec86                	sd	ra,88(sp)
     c84:	e8a2                	sd	s0,80(sp)
     c86:	e4a6                	sd	s1,72(sp)
     c88:	e0ca                	sd	s2,64(sp)
     c8a:	fc4e                	sd	s3,56(sp)
     c8c:	f852                	sd	s4,48(sp)
     c8e:	f456                	sd	s5,40(sp)
     c90:	f05a                	sd	s6,32(sp)
     c92:	ec5e                	sd	s7,24(sp)
     c94:	1080                	addi	s0,sp,96
     c96:	8baa                	mv	s7,a0
     c98:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c9a:	892a                	mv	s2,a0
     c9c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c9e:	4aa9                	li	s5,10
     ca0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     ca2:	89a6                	mv	s3,s1
     ca4:	2485                	addiw	s1,s1,1
     ca6:	0344d663          	bge	s1,s4,cd2 <gets+0x52>
    cc = read(0, &c, 1);
     caa:	4605                	li	a2,1
     cac:	faf40593          	addi	a1,s0,-81
     cb0:	4501                	li	a0,0
     cb2:	186000ef          	jal	e38 <read>
    if(cc < 1)
     cb6:	00a05e63          	blez	a0,cd2 <gets+0x52>
    buf[i++] = c;
     cba:	faf44783          	lbu	a5,-81(s0)
     cbe:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cc2:	01578763          	beq	a5,s5,cd0 <gets+0x50>
     cc6:	0905                	addi	s2,s2,1
     cc8:	fd679de3          	bne	a5,s6,ca2 <gets+0x22>
    buf[i++] = c;
     ccc:	89a6                	mv	s3,s1
     cce:	a011                	j	cd2 <gets+0x52>
     cd0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cd2:	99de                	add	s3,s3,s7
     cd4:	00098023          	sb	zero,0(s3)
  return buf;
}
     cd8:	855e                	mv	a0,s7
     cda:	60e6                	ld	ra,88(sp)
     cdc:	6446                	ld	s0,80(sp)
     cde:	64a6                	ld	s1,72(sp)
     ce0:	6906                	ld	s2,64(sp)
     ce2:	79e2                	ld	s3,56(sp)
     ce4:	7a42                	ld	s4,48(sp)
     ce6:	7aa2                	ld	s5,40(sp)
     ce8:	7b02                	ld	s6,32(sp)
     cea:	6be2                	ld	s7,24(sp)
     cec:	6125                	addi	sp,sp,96
     cee:	8082                	ret

0000000000000cf0 <stat>:

int
stat(const char *n, struct stat *st)
{
     cf0:	1101                	addi	sp,sp,-32
     cf2:	ec06                	sd	ra,24(sp)
     cf4:	e822                	sd	s0,16(sp)
     cf6:	e04a                	sd	s2,0(sp)
     cf8:	1000                	addi	s0,sp,32
     cfa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cfc:	4581                	li	a1,0
     cfe:	162000ef          	jal	e60 <open>
  if(fd < 0)
     d02:	02054263          	bltz	a0,d26 <stat+0x36>
     d06:	e426                	sd	s1,8(sp)
     d08:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d0a:	85ca                	mv	a1,s2
     d0c:	16c000ef          	jal	e78 <fstat>
     d10:	892a                	mv	s2,a0
  close(fd);
     d12:	8526                	mv	a0,s1
     d14:	134000ef          	jal	e48 <close>
  return r;
     d18:	64a2                	ld	s1,8(sp)
}
     d1a:	854a                	mv	a0,s2
     d1c:	60e2                	ld	ra,24(sp)
     d1e:	6442                	ld	s0,16(sp)
     d20:	6902                	ld	s2,0(sp)
     d22:	6105                	addi	sp,sp,32
     d24:	8082                	ret
    return -1;
     d26:	597d                	li	s2,-1
     d28:	bfcd                	j	d1a <stat+0x2a>

0000000000000d2a <atoi>:

int
atoi(const char *s)
{
     d2a:	1141                	addi	sp,sp,-16
     d2c:	e422                	sd	s0,8(sp)
     d2e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d30:	00054683          	lbu	a3,0(a0)
     d34:	fd06879b          	addiw	a5,a3,-48
     d38:	0ff7f793          	zext.b	a5,a5
     d3c:	4625                	li	a2,9
     d3e:	02f66863          	bltu	a2,a5,d6e <atoi+0x44>
     d42:	872a                	mv	a4,a0
  n = 0;
     d44:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d46:	0705                	addi	a4,a4,1
     d48:	0025179b          	slliw	a5,a0,0x2
     d4c:	9fa9                	addw	a5,a5,a0
     d4e:	0017979b          	slliw	a5,a5,0x1
     d52:	9fb5                	addw	a5,a5,a3
     d54:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d58:	00074683          	lbu	a3,0(a4)
     d5c:	fd06879b          	addiw	a5,a3,-48
     d60:	0ff7f793          	zext.b	a5,a5
     d64:	fef671e3          	bgeu	a2,a5,d46 <atoi+0x1c>
  return n;
}
     d68:	6422                	ld	s0,8(sp)
     d6a:	0141                	addi	sp,sp,16
     d6c:	8082                	ret
  n = 0;
     d6e:	4501                	li	a0,0
     d70:	bfe5                	j	d68 <atoi+0x3e>

0000000000000d72 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d72:	1141                	addi	sp,sp,-16
     d74:	e422                	sd	s0,8(sp)
     d76:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d78:	02b57463          	bgeu	a0,a1,da0 <memmove+0x2e>
    while(n-- > 0)
     d7c:	00c05f63          	blez	a2,d9a <memmove+0x28>
     d80:	1602                	slli	a2,a2,0x20
     d82:	9201                	srli	a2,a2,0x20
     d84:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d88:	872a                	mv	a4,a0
      *dst++ = *src++;
     d8a:	0585                	addi	a1,a1,1
     d8c:	0705                	addi	a4,a4,1
     d8e:	fff5c683          	lbu	a3,-1(a1)
     d92:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d96:	fef71ae3          	bne	a4,a5,d8a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d9a:	6422                	ld	s0,8(sp)
     d9c:	0141                	addi	sp,sp,16
     d9e:	8082                	ret
    dst += n;
     da0:	00c50733          	add	a4,a0,a2
    src += n;
     da4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     da6:	fec05ae3          	blez	a2,d9a <memmove+0x28>
     daa:	fff6079b          	addiw	a5,a2,-1
     dae:	1782                	slli	a5,a5,0x20
     db0:	9381                	srli	a5,a5,0x20
     db2:	fff7c793          	not	a5,a5
     db6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     db8:	15fd                	addi	a1,a1,-1
     dba:	177d                	addi	a4,a4,-1
     dbc:	0005c683          	lbu	a3,0(a1)
     dc0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dc4:	fee79ae3          	bne	a5,a4,db8 <memmove+0x46>
     dc8:	bfc9                	j	d9a <memmove+0x28>

0000000000000dca <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dca:	1141                	addi	sp,sp,-16
     dcc:	e422                	sd	s0,8(sp)
     dce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dd0:	ca05                	beqz	a2,e00 <memcmp+0x36>
     dd2:	fff6069b          	addiw	a3,a2,-1
     dd6:	1682                	slli	a3,a3,0x20
     dd8:	9281                	srli	a3,a3,0x20
     dda:	0685                	addi	a3,a3,1
     ddc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dde:	00054783          	lbu	a5,0(a0)
     de2:	0005c703          	lbu	a4,0(a1)
     de6:	00e79863          	bne	a5,a4,df6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dea:	0505                	addi	a0,a0,1
    p2++;
     dec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dee:	fed518e3          	bne	a0,a3,dde <memcmp+0x14>
  }
  return 0;
     df2:	4501                	li	a0,0
     df4:	a019                	j	dfa <memcmp+0x30>
      return *p1 - *p2;
     df6:	40e7853b          	subw	a0,a5,a4
}
     dfa:	6422                	ld	s0,8(sp)
     dfc:	0141                	addi	sp,sp,16
     dfe:	8082                	ret
  return 0;
     e00:	4501                	li	a0,0
     e02:	bfe5                	j	dfa <memcmp+0x30>

0000000000000e04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e04:	1141                	addi	sp,sp,-16
     e06:	e406                	sd	ra,8(sp)
     e08:	e022                	sd	s0,0(sp)
     e0a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e0c:	f67ff0ef          	jal	d72 <memmove>
}
     e10:	60a2                	ld	ra,8(sp)
     e12:	6402                	ld	s0,0(sp)
     e14:	0141                	addi	sp,sp,16
     e16:	8082                	ret

0000000000000e18 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e18:	4885                	li	a7,1
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e20:	4889                	li	a7,2
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e28:	488d                	li	a7,3
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e30:	4891                	li	a7,4
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <read>:
.global read
read:
 li a7, SYS_read
     e38:	4895                	li	a7,5
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <write>:
.global write
write:
 li a7, SYS_write
     e40:	48c1                	li	a7,16
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <close>:
.global close
close:
 li a7, SYS_close
     e48:	48d5                	li	a7,21
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e50:	4899                	li	a7,6
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e58:	489d                	li	a7,7
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <open>:
.global open
open:
 li a7, SYS_open
     e60:	48bd                	li	a7,15
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e68:	48c5                	li	a7,17
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e70:	48c9                	li	a7,18
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e78:	48a1                	li	a7,8
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <link>:
.global link
link:
 li a7, SYS_link
     e80:	48cd                	li	a7,19
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e88:	48d1                	li	a7,20
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e90:	48a5                	li	a7,9
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e98:	48a9                	li	a7,10
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ea0:	48ad                	li	a7,11
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ea8:	48b1                	li	a7,12
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     eb0:	48b5                	li	a7,13
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     eb8:	48b9                	li	a7,14
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ec0:	1101                	addi	sp,sp,-32
     ec2:	ec06                	sd	ra,24(sp)
     ec4:	e822                	sd	s0,16(sp)
     ec6:	1000                	addi	s0,sp,32
     ec8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ecc:	4605                	li	a2,1
     ece:	fef40593          	addi	a1,s0,-17
     ed2:	f6fff0ef          	jal	e40 <write>
}
     ed6:	60e2                	ld	ra,24(sp)
     ed8:	6442                	ld	s0,16(sp)
     eda:	6105                	addi	sp,sp,32
     edc:	8082                	ret

0000000000000ede <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ede:	7139                	addi	sp,sp,-64
     ee0:	fc06                	sd	ra,56(sp)
     ee2:	f822                	sd	s0,48(sp)
     ee4:	f426                	sd	s1,40(sp)
     ee6:	0080                	addi	s0,sp,64
     ee8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     eea:	c299                	beqz	a3,ef0 <printint+0x12>
     eec:	0805c963          	bltz	a1,f7e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ef0:	2581                	sext.w	a1,a1
  neg = 0;
     ef2:	4881                	li	a7,0
     ef4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ef8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     efa:	2601                	sext.w	a2,a2
     efc:	00000517          	auipc	a0,0x0
     f00:	67c50513          	addi	a0,a0,1660 # 1578 <digits>
     f04:	883a                	mv	a6,a4
     f06:	2705                	addiw	a4,a4,1
     f08:	02c5f7bb          	remuw	a5,a1,a2
     f0c:	1782                	slli	a5,a5,0x20
     f0e:	9381                	srli	a5,a5,0x20
     f10:	97aa                	add	a5,a5,a0
     f12:	0007c783          	lbu	a5,0(a5)
     f16:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f1a:	0005879b          	sext.w	a5,a1
     f1e:	02c5d5bb          	divuw	a1,a1,a2
     f22:	0685                	addi	a3,a3,1
     f24:	fec7f0e3          	bgeu	a5,a2,f04 <printint+0x26>
  if(neg)
     f28:	00088c63          	beqz	a7,f40 <printint+0x62>
    buf[i++] = '-';
     f2c:	fd070793          	addi	a5,a4,-48
     f30:	00878733          	add	a4,a5,s0
     f34:	02d00793          	li	a5,45
     f38:	fef70823          	sb	a5,-16(a4)
     f3c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f40:	02e05a63          	blez	a4,f74 <printint+0x96>
     f44:	f04a                	sd	s2,32(sp)
     f46:	ec4e                	sd	s3,24(sp)
     f48:	fc040793          	addi	a5,s0,-64
     f4c:	00e78933          	add	s2,a5,a4
     f50:	fff78993          	addi	s3,a5,-1
     f54:	99ba                	add	s3,s3,a4
     f56:	377d                	addiw	a4,a4,-1
     f58:	1702                	slli	a4,a4,0x20
     f5a:	9301                	srli	a4,a4,0x20
     f5c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f60:	fff94583          	lbu	a1,-1(s2)
     f64:	8526                	mv	a0,s1
     f66:	f5bff0ef          	jal	ec0 <putc>
  while(--i >= 0)
     f6a:	197d                	addi	s2,s2,-1
     f6c:	ff391ae3          	bne	s2,s3,f60 <printint+0x82>
     f70:	7902                	ld	s2,32(sp)
     f72:	69e2                	ld	s3,24(sp)
}
     f74:	70e2                	ld	ra,56(sp)
     f76:	7442                	ld	s0,48(sp)
     f78:	74a2                	ld	s1,40(sp)
     f7a:	6121                	addi	sp,sp,64
     f7c:	8082                	ret
    x = -xx;
     f7e:	40b005bb          	negw	a1,a1
    neg = 1;
     f82:	4885                	li	a7,1
    x = -xx;
     f84:	bf85                	j	ef4 <printint+0x16>

0000000000000f86 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f86:	711d                	addi	sp,sp,-96
     f88:	ec86                	sd	ra,88(sp)
     f8a:	e8a2                	sd	s0,80(sp)
     f8c:	e0ca                	sd	s2,64(sp)
     f8e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f90:	0005c903          	lbu	s2,0(a1)
     f94:	26090863          	beqz	s2,1204 <vprintf+0x27e>
     f98:	e4a6                	sd	s1,72(sp)
     f9a:	fc4e                	sd	s3,56(sp)
     f9c:	f852                	sd	s4,48(sp)
     f9e:	f456                	sd	s5,40(sp)
     fa0:	f05a                	sd	s6,32(sp)
     fa2:	ec5e                	sd	s7,24(sp)
     fa4:	e862                	sd	s8,16(sp)
     fa6:	e466                	sd	s9,8(sp)
     fa8:	8b2a                	mv	s6,a0
     faa:	8a2e                	mv	s4,a1
     fac:	8bb2                	mv	s7,a2
  state = 0;
     fae:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     fb0:	4481                	li	s1,0
     fb2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     fb4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     fb8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     fbc:	06c00c93          	li	s9,108
     fc0:	a005                	j	fe0 <vprintf+0x5a>
        putc(fd, c0);
     fc2:	85ca                	mv	a1,s2
     fc4:	855a                	mv	a0,s6
     fc6:	efbff0ef          	jal	ec0 <putc>
     fca:	a019                	j	fd0 <vprintf+0x4a>
    } else if(state == '%'){
     fcc:	03598263          	beq	s3,s5,ff0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     fd0:	2485                	addiw	s1,s1,1
     fd2:	8726                	mv	a4,s1
     fd4:	009a07b3          	add	a5,s4,s1
     fd8:	0007c903          	lbu	s2,0(a5)
     fdc:	20090c63          	beqz	s2,11f4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     fe0:	0009079b          	sext.w	a5,s2
    if(state == 0){
     fe4:	fe0994e3          	bnez	s3,fcc <vprintf+0x46>
      if(c0 == '%'){
     fe8:	fd579de3          	bne	a5,s5,fc2 <vprintf+0x3c>
        state = '%';
     fec:	89be                	mv	s3,a5
     fee:	b7cd                	j	fd0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     ff0:	00ea06b3          	add	a3,s4,a4
     ff4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     ff8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     ffa:	c681                	beqz	a3,1002 <vprintf+0x7c>
     ffc:	9752                	add	a4,a4,s4
     ffe:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1002:	03878f63          	beq	a5,s8,1040 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1006:	05978963          	beq	a5,s9,1058 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    100a:	07500713          	li	a4,117
    100e:	0ee78363          	beq	a5,a4,10f4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1012:	07800713          	li	a4,120
    1016:	12e78563          	beq	a5,a4,1140 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    101a:	07000713          	li	a4,112
    101e:	14e78a63          	beq	a5,a4,1172 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1022:	07300713          	li	a4,115
    1026:	18e78a63          	beq	a5,a4,11ba <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    102a:	02500713          	li	a4,37
    102e:	04e79563          	bne	a5,a4,1078 <vprintf+0xf2>
        putc(fd, '%');
    1032:	02500593          	li	a1,37
    1036:	855a                	mv	a0,s6
    1038:	e89ff0ef          	jal	ec0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    103c:	4981                	li	s3,0
    103e:	bf49                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1040:	008b8913          	addi	s2,s7,8
    1044:	4685                	li	a3,1
    1046:	4629                	li	a2,10
    1048:	000ba583          	lw	a1,0(s7)
    104c:	855a                	mv	a0,s6
    104e:	e91ff0ef          	jal	ede <printint>
    1052:	8bca                	mv	s7,s2
      state = 0;
    1054:	4981                	li	s3,0
    1056:	bfad                	j	fd0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1058:	06400793          	li	a5,100
    105c:	02f68963          	beq	a3,a5,108e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1060:	06c00793          	li	a5,108
    1064:	04f68263          	beq	a3,a5,10a8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1068:	07500793          	li	a5,117
    106c:	0af68063          	beq	a3,a5,110c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1070:	07800793          	li	a5,120
    1074:	0ef68263          	beq	a3,a5,1158 <vprintf+0x1d2>
        putc(fd, '%');
    1078:	02500593          	li	a1,37
    107c:	855a                	mv	a0,s6
    107e:	e43ff0ef          	jal	ec0 <putc>
        putc(fd, c0);
    1082:	85ca                	mv	a1,s2
    1084:	855a                	mv	a0,s6
    1086:	e3bff0ef          	jal	ec0 <putc>
      state = 0;
    108a:	4981                	li	s3,0
    108c:	b791                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    108e:	008b8913          	addi	s2,s7,8
    1092:	4685                	li	a3,1
    1094:	4629                	li	a2,10
    1096:	000ba583          	lw	a1,0(s7)
    109a:	855a                	mv	a0,s6
    109c:	e43ff0ef          	jal	ede <printint>
        i += 1;
    10a0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    10a2:	8bca                	mv	s7,s2
      state = 0;
    10a4:	4981                	li	s3,0
        i += 1;
    10a6:	b72d                	j	fd0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    10a8:	06400793          	li	a5,100
    10ac:	02f60763          	beq	a2,a5,10da <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    10b0:	07500793          	li	a5,117
    10b4:	06f60963          	beq	a2,a5,1126 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    10b8:	07800793          	li	a5,120
    10bc:	faf61ee3          	bne	a2,a5,1078 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10c0:	008b8913          	addi	s2,s7,8
    10c4:	4681                	li	a3,0
    10c6:	4641                	li	a2,16
    10c8:	000ba583          	lw	a1,0(s7)
    10cc:	855a                	mv	a0,s6
    10ce:	e11ff0ef          	jal	ede <printint>
        i += 2;
    10d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    10d4:	8bca                	mv	s7,s2
      state = 0;
    10d6:	4981                	li	s3,0
        i += 2;
    10d8:	bde5                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    10da:	008b8913          	addi	s2,s7,8
    10de:	4685                	li	a3,1
    10e0:	4629                	li	a2,10
    10e2:	000ba583          	lw	a1,0(s7)
    10e6:	855a                	mv	a0,s6
    10e8:	df7ff0ef          	jal	ede <printint>
        i += 2;
    10ec:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    10ee:	8bca                	mv	s7,s2
      state = 0;
    10f0:	4981                	li	s3,0
        i += 2;
    10f2:	bdf9                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    10f4:	008b8913          	addi	s2,s7,8
    10f8:	4681                	li	a3,0
    10fa:	4629                	li	a2,10
    10fc:	000ba583          	lw	a1,0(s7)
    1100:	855a                	mv	a0,s6
    1102:	dddff0ef          	jal	ede <printint>
    1106:	8bca                	mv	s7,s2
      state = 0;
    1108:	4981                	li	s3,0
    110a:	b5d9                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    110c:	008b8913          	addi	s2,s7,8
    1110:	4681                	li	a3,0
    1112:	4629                	li	a2,10
    1114:	000ba583          	lw	a1,0(s7)
    1118:	855a                	mv	a0,s6
    111a:	dc5ff0ef          	jal	ede <printint>
        i += 1;
    111e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1120:	8bca                	mv	s7,s2
      state = 0;
    1122:	4981                	li	s3,0
        i += 1;
    1124:	b575                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1126:	008b8913          	addi	s2,s7,8
    112a:	4681                	li	a3,0
    112c:	4629                	li	a2,10
    112e:	000ba583          	lw	a1,0(s7)
    1132:	855a                	mv	a0,s6
    1134:	dabff0ef          	jal	ede <printint>
        i += 2;
    1138:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    113a:	8bca                	mv	s7,s2
      state = 0;
    113c:	4981                	li	s3,0
        i += 2;
    113e:	bd49                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1140:	008b8913          	addi	s2,s7,8
    1144:	4681                	li	a3,0
    1146:	4641                	li	a2,16
    1148:	000ba583          	lw	a1,0(s7)
    114c:	855a                	mv	a0,s6
    114e:	d91ff0ef          	jal	ede <printint>
    1152:	8bca                	mv	s7,s2
      state = 0;
    1154:	4981                	li	s3,0
    1156:	bdad                	j	fd0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1158:	008b8913          	addi	s2,s7,8
    115c:	4681                	li	a3,0
    115e:	4641                	li	a2,16
    1160:	000ba583          	lw	a1,0(s7)
    1164:	855a                	mv	a0,s6
    1166:	d79ff0ef          	jal	ede <printint>
        i += 1;
    116a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    116c:	8bca                	mv	s7,s2
      state = 0;
    116e:	4981                	li	s3,0
        i += 1;
    1170:	b585                	j	fd0 <vprintf+0x4a>
    1172:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1174:	008b8d13          	addi	s10,s7,8
    1178:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    117c:	03000593          	li	a1,48
    1180:	855a                	mv	a0,s6
    1182:	d3fff0ef          	jal	ec0 <putc>
  putc(fd, 'x');
    1186:	07800593          	li	a1,120
    118a:	855a                	mv	a0,s6
    118c:	d35ff0ef          	jal	ec0 <putc>
    1190:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1192:	00000b97          	auipc	s7,0x0
    1196:	3e6b8b93          	addi	s7,s7,998 # 1578 <digits>
    119a:	03c9d793          	srli	a5,s3,0x3c
    119e:	97de                	add	a5,a5,s7
    11a0:	0007c583          	lbu	a1,0(a5)
    11a4:	855a                	mv	a0,s6
    11a6:	d1bff0ef          	jal	ec0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11aa:	0992                	slli	s3,s3,0x4
    11ac:	397d                	addiw	s2,s2,-1
    11ae:	fe0916e3          	bnez	s2,119a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    11b2:	8bea                	mv	s7,s10
      state = 0;
    11b4:	4981                	li	s3,0
    11b6:	6d02                	ld	s10,0(sp)
    11b8:	bd21                	j	fd0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    11ba:	008b8993          	addi	s3,s7,8
    11be:	000bb903          	ld	s2,0(s7)
    11c2:	00090f63          	beqz	s2,11e0 <vprintf+0x25a>
        for(; *s; s++)
    11c6:	00094583          	lbu	a1,0(s2)
    11ca:	c195                	beqz	a1,11ee <vprintf+0x268>
          putc(fd, *s);
    11cc:	855a                	mv	a0,s6
    11ce:	cf3ff0ef          	jal	ec0 <putc>
        for(; *s; s++)
    11d2:	0905                	addi	s2,s2,1
    11d4:	00094583          	lbu	a1,0(s2)
    11d8:	f9f5                	bnez	a1,11cc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    11da:	8bce                	mv	s7,s3
      state = 0;
    11dc:	4981                	li	s3,0
    11de:	bbcd                	j	fd0 <vprintf+0x4a>
          s = "(null)";
    11e0:	00000917          	auipc	s2,0x0
    11e4:	36090913          	addi	s2,s2,864 # 1540 <malloc+0x254>
        for(; *s; s++)
    11e8:	02800593          	li	a1,40
    11ec:	b7c5                	j	11cc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    11ee:	8bce                	mv	s7,s3
      state = 0;
    11f0:	4981                	li	s3,0
    11f2:	bbf9                	j	fd0 <vprintf+0x4a>
    11f4:	64a6                	ld	s1,72(sp)
    11f6:	79e2                	ld	s3,56(sp)
    11f8:	7a42                	ld	s4,48(sp)
    11fa:	7aa2                	ld	s5,40(sp)
    11fc:	7b02                	ld	s6,32(sp)
    11fe:	6be2                	ld	s7,24(sp)
    1200:	6c42                	ld	s8,16(sp)
    1202:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1204:	60e6                	ld	ra,88(sp)
    1206:	6446                	ld	s0,80(sp)
    1208:	6906                	ld	s2,64(sp)
    120a:	6125                	addi	sp,sp,96
    120c:	8082                	ret

000000000000120e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    120e:	715d                	addi	sp,sp,-80
    1210:	ec06                	sd	ra,24(sp)
    1212:	e822                	sd	s0,16(sp)
    1214:	1000                	addi	s0,sp,32
    1216:	e010                	sd	a2,0(s0)
    1218:	e414                	sd	a3,8(s0)
    121a:	e818                	sd	a4,16(s0)
    121c:	ec1c                	sd	a5,24(s0)
    121e:	03043023          	sd	a6,32(s0)
    1222:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1226:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    122a:	8622                	mv	a2,s0
    122c:	d5bff0ef          	jal	f86 <vprintf>
}
    1230:	60e2                	ld	ra,24(sp)
    1232:	6442                	ld	s0,16(sp)
    1234:	6161                	addi	sp,sp,80
    1236:	8082                	ret

0000000000001238 <printf>:

void
printf(const char *fmt, ...)
{
    1238:	711d                	addi	sp,sp,-96
    123a:	ec06                	sd	ra,24(sp)
    123c:	e822                	sd	s0,16(sp)
    123e:	1000                	addi	s0,sp,32
    1240:	e40c                	sd	a1,8(s0)
    1242:	e810                	sd	a2,16(s0)
    1244:	ec14                	sd	a3,24(s0)
    1246:	f018                	sd	a4,32(s0)
    1248:	f41c                	sd	a5,40(s0)
    124a:	03043823          	sd	a6,48(s0)
    124e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1252:	00840613          	addi	a2,s0,8
    1256:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    125a:	85aa                	mv	a1,a0
    125c:	4505                	li	a0,1
    125e:	d29ff0ef          	jal	f86 <vprintf>
}
    1262:	60e2                	ld	ra,24(sp)
    1264:	6442                	ld	s0,16(sp)
    1266:	6125                	addi	sp,sp,96
    1268:	8082                	ret

000000000000126a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    126a:	1141                	addi	sp,sp,-16
    126c:	e422                	sd	s0,8(sp)
    126e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1270:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1274:	00001797          	auipc	a5,0x1
    1278:	d9c7b783          	ld	a5,-612(a5) # 2010 <freep>
    127c:	a02d                	j	12a6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    127e:	4618                	lw	a4,8(a2)
    1280:	9f2d                	addw	a4,a4,a1
    1282:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1286:	6398                	ld	a4,0(a5)
    1288:	6310                	ld	a2,0(a4)
    128a:	a83d                	j	12c8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    128c:	ff852703          	lw	a4,-8(a0)
    1290:	9f31                	addw	a4,a4,a2
    1292:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1294:	ff053683          	ld	a3,-16(a0)
    1298:	a091                	j	12dc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    129a:	6398                	ld	a4,0(a5)
    129c:	00e7e463          	bltu	a5,a4,12a4 <free+0x3a>
    12a0:	00e6ea63          	bltu	a3,a4,12b4 <free+0x4a>
{
    12a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12a6:	fed7fae3          	bgeu	a5,a3,129a <free+0x30>
    12aa:	6398                	ld	a4,0(a5)
    12ac:	00e6e463          	bltu	a3,a4,12b4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b0:	fee7eae3          	bltu	a5,a4,12a4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    12b4:	ff852583          	lw	a1,-8(a0)
    12b8:	6390                	ld	a2,0(a5)
    12ba:	02059813          	slli	a6,a1,0x20
    12be:	01c85713          	srli	a4,a6,0x1c
    12c2:	9736                	add	a4,a4,a3
    12c4:	fae60de3          	beq	a2,a4,127e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    12c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12cc:	4790                	lw	a2,8(a5)
    12ce:	02061593          	slli	a1,a2,0x20
    12d2:	01c5d713          	srli	a4,a1,0x1c
    12d6:	973e                	add	a4,a4,a5
    12d8:	fae68ae3          	beq	a3,a4,128c <free+0x22>
    p->s.ptr = bp->s.ptr;
    12dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    12de:	00001717          	auipc	a4,0x1
    12e2:	d2f73923          	sd	a5,-718(a4) # 2010 <freep>
}
    12e6:	6422                	ld	s0,8(sp)
    12e8:	0141                	addi	sp,sp,16
    12ea:	8082                	ret

00000000000012ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12ec:	7139                	addi	sp,sp,-64
    12ee:	fc06                	sd	ra,56(sp)
    12f0:	f822                	sd	s0,48(sp)
    12f2:	f426                	sd	s1,40(sp)
    12f4:	ec4e                	sd	s3,24(sp)
    12f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12f8:	02051493          	slli	s1,a0,0x20
    12fc:	9081                	srli	s1,s1,0x20
    12fe:	04bd                	addi	s1,s1,15
    1300:	8091                	srli	s1,s1,0x4
    1302:	0014899b          	addiw	s3,s1,1
    1306:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1308:	00001517          	auipc	a0,0x1
    130c:	d0853503          	ld	a0,-760(a0) # 2010 <freep>
    1310:	c915                	beqz	a0,1344 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1312:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1314:	4798                	lw	a4,8(a5)
    1316:	08977a63          	bgeu	a4,s1,13aa <malloc+0xbe>
    131a:	f04a                	sd	s2,32(sp)
    131c:	e852                	sd	s4,16(sp)
    131e:	e456                	sd	s5,8(sp)
    1320:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1322:	8a4e                	mv	s4,s3
    1324:	0009871b          	sext.w	a4,s3
    1328:	6685                	lui	a3,0x1
    132a:	00d77363          	bgeu	a4,a3,1330 <malloc+0x44>
    132e:	6a05                	lui	s4,0x1
    1330:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1334:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1338:	00001917          	auipc	s2,0x1
    133c:	cd890913          	addi	s2,s2,-808 # 2010 <freep>
  if(p == (char*)-1)
    1340:	5afd                	li	s5,-1
    1342:	a081                	j	1382 <malloc+0x96>
    1344:	f04a                	sd	s2,32(sp)
    1346:	e852                	sd	s4,16(sp)
    1348:	e456                	sd	s5,8(sp)
    134a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    134c:	00001797          	auipc	a5,0x1
    1350:	d3c78793          	addi	a5,a5,-708 # 2088 <base>
    1354:	00001717          	auipc	a4,0x1
    1358:	caf73e23          	sd	a5,-836(a4) # 2010 <freep>
    135c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    135e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1362:	b7c1                	j	1322 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1364:	6398                	ld	a4,0(a5)
    1366:	e118                	sd	a4,0(a0)
    1368:	a8a9                	j	13c2 <malloc+0xd6>
  hp->s.size = nu;
    136a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    136e:	0541                	addi	a0,a0,16
    1370:	efbff0ef          	jal	126a <free>
  return freep;
    1374:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1378:	c12d                	beqz	a0,13da <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    137a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    137c:	4798                	lw	a4,8(a5)
    137e:	02977263          	bgeu	a4,s1,13a2 <malloc+0xb6>
    if(p == freep)
    1382:	00093703          	ld	a4,0(s2)
    1386:	853e                	mv	a0,a5
    1388:	fef719e3          	bne	a4,a5,137a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    138c:	8552                	mv	a0,s4
    138e:	b1bff0ef          	jal	ea8 <sbrk>
  if(p == (char*)-1)
    1392:	fd551ce3          	bne	a0,s5,136a <malloc+0x7e>
        return 0;
    1396:	4501                	li	a0,0
    1398:	7902                	ld	s2,32(sp)
    139a:	6a42                	ld	s4,16(sp)
    139c:	6aa2                	ld	s5,8(sp)
    139e:	6b02                	ld	s6,0(sp)
    13a0:	a03d                	j	13ce <malloc+0xe2>
    13a2:	7902                	ld	s2,32(sp)
    13a4:	6a42                	ld	s4,16(sp)
    13a6:	6aa2                	ld	s5,8(sp)
    13a8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    13aa:	fae48de3          	beq	s1,a4,1364 <malloc+0x78>
        p->s.size -= nunits;
    13ae:	4137073b          	subw	a4,a4,s3
    13b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13b4:	02071693          	slli	a3,a4,0x20
    13b8:	01c6d713          	srli	a4,a3,0x1c
    13bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13c2:	00001717          	auipc	a4,0x1
    13c6:	c4a73723          	sd	a0,-946(a4) # 2010 <freep>
      return (void*)(p + 1);
    13ca:	01078513          	addi	a0,a5,16
  }
}
    13ce:	70e2                	ld	ra,56(sp)
    13d0:	7442                	ld	s0,48(sp)
    13d2:	74a2                	ld	s1,40(sp)
    13d4:	69e2                	ld	s3,24(sp)
    13d6:	6121                	addi	sp,sp,64
    13d8:	8082                	ret
    13da:	7902                	ld	s2,32(sp)
    13dc:	6a42                	ld	s4,16(sp)
    13de:	6aa2                	ld	s5,8(sp)
    13e0:	6b02                	ld	s6,0(sp)
    13e2:	b7f5                	j	13ce <malloc+0xe2>
