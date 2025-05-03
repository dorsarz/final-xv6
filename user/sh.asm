
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
      16:	36e58593          	addi	a1,a1,878 # 1380 <malloc+0x106>
      1a:	4509                	li	a0,2
      1c:	5b3000ef          	jal	dce <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	3a3000ef          	jal	bc8 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	3e1000ef          	jal	c0e <gets>
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
      58:	33c58593          	addi	a1,a1,828 # 1390 <malloc+0x116>
      5c:	4509                	li	a0,2
      5e:	13e010ef          	jal	119c <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	54b000ef          	jal	dae <exit>

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
      70:	537000ef          	jal	da6 <fork>
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
      86:	31e50513          	addi	a0,a0,798 # 13a0 <malloc+0x126>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	ba010113          	addi	sp,sp,-1120
      92:	44113c23          	sd	ra,1112(sp)
      96:	44813823          	sd	s0,1104(sp)
      9a:	46010413          	addi	s0,sp,1120
  if (cmd == 0)
      9e:	c90d                	beqz	a0,d0 <runcmd+0x42>
      a0:	44913423          	sd	s1,1096(sp)
      a4:	45213023          	sd	s2,1088(sp)
      a8:	43313c23          	sd	s3,1080(sp)
      ac:	43513423          	sd	s5,1064(sp)
      b0:	84aa                	mv	s1,a0
  switch (cmd->type)
      b2:	00052983          	lw	s3,0(a0)
      b6:	4795                	li	a5,5
      b8:	0337ef63          	bltu	a5,s3,f6 <runcmd+0x68>
      bc:	00299793          	slli	a5,s3,0x2
      c0:	00001717          	auipc	a4,0x1
      c4:	40870713          	addi	a4,a4,1032 # 14c8 <malloc+0x24e>
      c8:	97ba                	add	a5,a5,a4
      ca:	439c                	lw	a5,0(a5)
      cc:	97ba                	add	a5,a5,a4
      ce:	8782                	jr	a5
      d0:	44913423          	sd	s1,1096(sp)
      d4:	45213023          	sd	s2,1088(sp)
      d8:	43313c23          	sd	s3,1080(sp)
      dc:	43413823          	sd	s4,1072(sp)
      e0:	43513423          	sd	s5,1064(sp)
      e4:	43613023          	sd	s6,1056(sp)
      e8:	41713c23          	sd	s7,1048(sp)
      ec:	41813823          	sd	s8,1040(sp)
    exit(1);
      f0:	4505                	li	a0,1
      f2:	4bd000ef          	jal	dae <exit>
      f6:	43413823          	sd	s4,1072(sp)
      fa:	43613023          	sd	s6,1056(sp)
      fe:	41713c23          	sd	s7,1048(sp)
     102:	41813823          	sd	s8,1040(sp)
    panic("runcmd");
     106:	00001517          	auipc	a0,0x1
     10a:	2a250513          	addi	a0,a0,674 # 13a8 <malloc+0x12e>
     10e:	f3dff0ef          	jal	4a <panic>
    if (ecmd->argv[0] == 0)
     112:	00853903          	ld	s2,8(a0)
     116:	04090363          	beqz	s2,15c <runcmd+0xce>
    if (ecmd->argv[0] && strcmp(ecmd->argv[0], "!") == 0) {
     11a:	00001597          	auipc	a1,0x1
     11e:	29658593          	addi	a1,a1,662 # 13b0 <malloc+0x136>
     122:	854a                	mv	a0,s2
     124:	24f000ef          	jal	b72 <strcmp>
     128:	8aaa                	mv	s5,a0
     12a:	e961                	bnez	a0,1fa <runcmd+0x16c>
     12c:	43413823          	sd	s4,1072(sp)
     130:	43613023          	sd	s6,1056(sp)
     134:	41713c23          	sd	s7,1048(sp)
     138:	41813823          	sd	s8,1040(sp)
        char buf[1024] = {0};
     13c:	40000613          	li	a2,1024
     140:	4581                	li	a1,0
     142:	ba840513          	addi	a0,s0,-1112
     146:	283000ef          	jal	bc8 <memset>
        for (int i = 1; ecmd->argv[i] != 0; i++) {
     14a:	6888                	ld	a0,16(s1)
     14c:	cd51                	beqz	a0,1e8 <runcmd+0x15a>
     14e:	04c1                	addi	s1,s1,16
            if (len + arglen >= sizeof(buf)) {
     150:	3ff00b13          	li	s6,1023
            if (i > 1)
     154:	4b85                	li	s7,1
                buf[len++] = ' ';
     156:	02000c13          	li	s8,32
     15a:	a02d                	j	184 <runcmd+0xf6>
     15c:	43413823          	sd	s4,1072(sp)
     160:	43613023          	sd	s6,1056(sp)
     164:	41713c23          	sd	s7,1048(sp)
     168:	41813823          	sd	s8,1040(sp)
        exit(1);
     16c:	4505                	li	a0,1
     16e:	441000ef          	jal	dae <exit>
                buf[len++] = ' ';
     172:	fb0a0793          	addi	a5,s4,-80
     176:	00878a33          	add	s4,a5,s0
     17a:	bf8a0c23          	sb	s8,-1032(s4)
     17e:	00190a1b          	addiw	s4,s2,1
     182:	8ad2                	mv	s5,s4
            int arglen = strlen(ecmd->argv[i]);
     184:	21b000ef          	jal	b9e <strlen>
            if (len + arglen >= sizeof(buf)) {
     188:	0155093b          	addw	s2,a0,s5
     18c:	00090a1b          	sext.w	s4,s2
     190:	034b6063          	bltu	s6,s4,1b0 <runcmd+0x122>
            strcpy(buf + len, ecmd->argv[i]);
     194:	608c                	ld	a1,0(s1)
     196:	ba840793          	addi	a5,s0,-1112
     19a:	01578533          	add	a0,a5,s5
     19e:	1b9000ef          	jal	b56 <strcpy>
        for (int i = 1; ecmd->argv[i] != 0; i++) {
     1a2:	2985                	addiw	s3,s3,1
     1a4:	04a1                	addi	s1,s1,8
     1a6:	6088                	ld	a0,0(s1)
     1a8:	cd09                	beqz	a0,1c2 <runcmd+0x134>
            if (i > 1)
     1aa:	fd3bc4e3          	blt	s7,s3,172 <runcmd+0xe4>
     1ae:	bfd1                	j	182 <runcmd+0xf4>
                printf("Message too long\n");
     1b0:	00001517          	auipc	a0,0x1
     1b4:	20850513          	addi	a0,a0,520 # 13b8 <malloc+0x13e>
     1b8:	00e010ef          	jal	11c6 <printf>
                exit(1);
     1bc:	4505                	li	a0,1
     1be:	3f1000ef          	jal	dae <exit>
     1c2:	4481                	li	s1,0
                printf("%c", buf[i]);
     1c4:	00001917          	auipc	s2,0x1
     1c8:	20c90913          	addi	s2,s2,524 # 13d0 <malloc+0x156>
     1cc:	a811                	j	1e0 <runcmd+0x152>
     1ce:	ba840793          	addi	a5,s0,-1112
     1d2:	97a6                	add	a5,a5,s1
     1d4:	0007c583          	lbu	a1,0(a5)
     1d8:	854a                	mv	a0,s2
     1da:	7ed000ef          	jal	11c6 <printf>
        for (int i = 0; i < len; i++) {
     1de:	0485                	addi	s1,s1,1
     1e0:	0004879b          	sext.w	a5,s1
     1e4:	ff47c5e3          	blt	a5,s4,1ce <runcmd+0x140>
        printf("\n");
     1e8:	00001517          	auipc	a0,0x1
     1ec:	1e050513          	addi	a0,a0,480 # 13c8 <malloc+0x14e>
     1f0:	7d7000ef          	jal	11c6 <printf>
        exit(0);
     1f4:	4501                	li	a0,0
     1f6:	3b9000ef          	jal	dae <exit>
    exec(ecmd->argv[0], ecmd->argv);
     1fa:	00848593          	addi	a1,s1,8
     1fe:	854a                	mv	a0,s2
     200:	3e7000ef          	jal	de6 <exec>
    printf("exec %s failed\n", ecmd->argv[0]);
     204:	648c                	ld	a1,8(s1)
     206:	00001517          	auipc	a0,0x1
     20a:	1d250513          	addi	a0,a0,466 # 13d8 <malloc+0x15e>
     20e:	7b9000ef          	jal	11c6 <printf>
    break;
     212:	a299                	j	358 <runcmd+0x2ca>
    close(rcmd->fd);
     214:	5148                	lw	a0,36(a0)
     216:	3c1000ef          	jal	dd6 <close>
    if (open(rcmd->file, rcmd->mode) < 0)
     21a:	508c                	lw	a1,32(s1)
     21c:	6888                	ld	a0,16(s1)
     21e:	3d1000ef          	jal	dee <open>
     222:	00054d63          	bltz	a0,23c <runcmd+0x1ae>
     226:	43413823          	sd	s4,1072(sp)
     22a:	43613023          	sd	s6,1056(sp)
     22e:	41713c23          	sd	s7,1048(sp)
     232:	41813823          	sd	s8,1040(sp)
    runcmd(rcmd->cmd);
     236:	6488                	ld	a0,8(s1)
     238:	e57ff0ef          	jal	8e <runcmd>
     23c:	43413823          	sd	s4,1072(sp)
     240:	43613023          	sd	s6,1056(sp)
     244:	41713c23          	sd	s7,1048(sp)
     248:	41813823          	sd	s8,1040(sp)
      fprintf(2, "open %s failed\n", rcmd->file);
     24c:	6890                	ld	a2,16(s1)
     24e:	00001597          	auipc	a1,0x1
     252:	19a58593          	addi	a1,a1,410 # 13e8 <malloc+0x16e>
     256:	4509                	li	a0,2
     258:	745000ef          	jal	119c <fprintf>
      exit(1);
     25c:	4505                	li	a0,1
     25e:	351000ef          	jal	dae <exit>
    if (fork1() == 0)
     262:	e07ff0ef          	jal	68 <fork1>
     266:	ed01                	bnez	a0,27e <runcmd+0x1f0>
     268:	43413823          	sd	s4,1072(sp)
     26c:	43613023          	sd	s6,1056(sp)
     270:	41713c23          	sd	s7,1048(sp)
     274:	41813823          	sd	s8,1040(sp)
      runcmd(lcmd->left);
     278:	6488                	ld	a0,8(s1)
     27a:	e15ff0ef          	jal	8e <runcmd>
     27e:	43413823          	sd	s4,1072(sp)
     282:	43613023          	sd	s6,1056(sp)
     286:	41713c23          	sd	s7,1048(sp)
     28a:	41813823          	sd	s8,1040(sp)
    wait(0);
     28e:	4501                	li	a0,0
     290:	327000ef          	jal	db6 <wait>
    runcmd(lcmd->right);
     294:	6888                	ld	a0,16(s1)
     296:	df9ff0ef          	jal	8e <runcmd>
    if (pipe(p) < 0)
     29a:	fa840513          	addi	a0,s0,-88
     29e:	321000ef          	jal	dbe <pipe>
     2a2:	02054f63          	bltz	a0,2e0 <runcmd+0x252>
    if (fork1() == 0)
     2a6:	dc3ff0ef          	jal	68 <fork1>
     2aa:	e929                	bnez	a0,2fc <runcmd+0x26e>
     2ac:	43413823          	sd	s4,1072(sp)
     2b0:	43613023          	sd	s6,1056(sp)
     2b4:	41713c23          	sd	s7,1048(sp)
     2b8:	41813823          	sd	s8,1040(sp)
      close(1);
     2bc:	4505                	li	a0,1
     2be:	319000ef          	jal	dd6 <close>
      dup(p[1]);
     2c2:	fac42503          	lw	a0,-84(s0)
     2c6:	361000ef          	jal	e26 <dup>
      close(p[0]);
     2ca:	fa842503          	lw	a0,-88(s0)
     2ce:	309000ef          	jal	dd6 <close>
      close(p[1]);
     2d2:	fac42503          	lw	a0,-84(s0)
     2d6:	301000ef          	jal	dd6 <close>
      runcmd(pcmd->left);
     2da:	6488                	ld	a0,8(s1)
     2dc:	db3ff0ef          	jal	8e <runcmd>
     2e0:	43413823          	sd	s4,1072(sp)
     2e4:	43613023          	sd	s6,1056(sp)
     2e8:	41713c23          	sd	s7,1048(sp)
     2ec:	41813823          	sd	s8,1040(sp)
      panic("pipe");
     2f0:	00001517          	auipc	a0,0x1
     2f4:	10850513          	addi	a0,a0,264 # 13f8 <malloc+0x17e>
     2f8:	d53ff0ef          	jal	4a <panic>
    if (fork1() == 0)
     2fc:	d6dff0ef          	jal	68 <fork1>
     300:	e915                	bnez	a0,334 <runcmd+0x2a6>
     302:	43413823          	sd	s4,1072(sp)
     306:	43613023          	sd	s6,1056(sp)
     30a:	41713c23          	sd	s7,1048(sp)
     30e:	41813823          	sd	s8,1040(sp)
      close(0);
     312:	2c5000ef          	jal	dd6 <close>
      dup(p[0]);
     316:	fa842503          	lw	a0,-88(s0)
     31a:	30d000ef          	jal	e26 <dup>
      close(p[0]);
     31e:	fa842503          	lw	a0,-88(s0)
     322:	2b5000ef          	jal	dd6 <close>
      close(p[1]);
     326:	fac42503          	lw	a0,-84(s0)
     32a:	2ad000ef          	jal	dd6 <close>
      runcmd(pcmd->right);
     32e:	6888                	ld	a0,16(s1)
     330:	d5fff0ef          	jal	8e <runcmd>
    close(p[0]);
     334:	fa842503          	lw	a0,-88(s0)
     338:	29f000ef          	jal	dd6 <close>
    close(p[1]);
     33c:	fac42503          	lw	a0,-84(s0)
     340:	297000ef          	jal	dd6 <close>
    wait(0);
     344:	4501                	li	a0,0
     346:	271000ef          	jal	db6 <wait>
    wait(0);
     34a:	4501                	li	a0,0
     34c:	26b000ef          	jal	db6 <wait>
    break;
     350:	a021                	j	358 <runcmd+0x2ca>
    if (fork1() == 0)
     352:	d17ff0ef          	jal	68 <fork1>
     356:	cd01                	beqz	a0,36e <runcmd+0x2e0>
     358:	43413823          	sd	s4,1072(sp)
     35c:	43613023          	sd	s6,1056(sp)
     360:	41713c23          	sd	s7,1048(sp)
     364:	41813823          	sd	s8,1040(sp)
  exit(0);
     368:	4501                	li	a0,0
     36a:	245000ef          	jal	dae <exit>
     36e:	43413823          	sd	s4,1072(sp)
     372:	43613023          	sd	s6,1056(sp)
     376:	41713c23          	sd	s7,1048(sp)
     37a:	41813823          	sd	s8,1040(sp)
      runcmd(bcmd->cmd);
     37e:	6488                	ld	a0,8(s1)
     380:	d0fff0ef          	jal	8e <runcmd>

0000000000000384 <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     384:	1101                	addi	sp,sp,-32
     386:	ec06                	sd	ra,24(sp)
     388:	e822                	sd	s0,16(sp)
     38a:	e426                	sd	s1,8(sp)
     38c:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     38e:	0a800513          	li	a0,168
     392:	6e9000ef          	jal	127a <malloc>
     396:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     398:	0a800613          	li	a2,168
     39c:	4581                	li	a1,0
     39e:	02b000ef          	jal	bc8 <memset>
  cmd->type = EXEC;
     3a2:	4785                	li	a5,1
     3a4:	c09c                	sw	a5,0(s1)
  return (struct cmd *)cmd;
}
     3a6:	8526                	mv	a0,s1
     3a8:	60e2                	ld	ra,24(sp)
     3aa:	6442                	ld	s0,16(sp)
     3ac:	64a2                	ld	s1,8(sp)
     3ae:	6105                	addi	sp,sp,32
     3b0:	8082                	ret

00000000000003b2 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3b2:	7139                	addi	sp,sp,-64
     3b4:	fc06                	sd	ra,56(sp)
     3b6:	f822                	sd	s0,48(sp)
     3b8:	f426                	sd	s1,40(sp)
     3ba:	f04a                	sd	s2,32(sp)
     3bc:	ec4e                	sd	s3,24(sp)
     3be:	e852                	sd	s4,16(sp)
     3c0:	e456                	sd	s5,8(sp)
     3c2:	e05a                	sd	s6,0(sp)
     3c4:	0080                	addi	s0,sp,64
     3c6:	8b2a                	mv	s6,a0
     3c8:	8aae                	mv	s5,a1
     3ca:	8a32                	mv	s4,a2
     3cc:	89b6                	mv	s3,a3
     3ce:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d0:	02800513          	li	a0,40
     3d4:	6a7000ef          	jal	127a <malloc>
     3d8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3da:	02800613          	li	a2,40
     3de:	4581                	li	a1,0
     3e0:	7e8000ef          	jal	bc8 <memset>
  cmd->type = REDIR;
     3e4:	4789                	li	a5,2
     3e6:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3e8:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     3ec:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     3f0:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     3f4:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     3f8:	0324a223          	sw	s2,36(s1)
  return (struct cmd *)cmd;
}
     3fc:	8526                	mv	a0,s1
     3fe:	70e2                	ld	ra,56(sp)
     400:	7442                	ld	s0,48(sp)
     402:	74a2                	ld	s1,40(sp)
     404:	7902                	ld	s2,32(sp)
     406:	69e2                	ld	s3,24(sp)
     408:	6a42                	ld	s4,16(sp)
     40a:	6aa2                	ld	s5,8(sp)
     40c:	6b02                	ld	s6,0(sp)
     40e:	6121                	addi	sp,sp,64
     410:	8082                	ret

0000000000000412 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     412:	7179                	addi	sp,sp,-48
     414:	f406                	sd	ra,40(sp)
     416:	f022                	sd	s0,32(sp)
     418:	ec26                	sd	s1,24(sp)
     41a:	e84a                	sd	s2,16(sp)
     41c:	e44e                	sd	s3,8(sp)
     41e:	1800                	addi	s0,sp,48
     420:	89aa                	mv	s3,a0
     422:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     424:	4561                	li	a0,24
     426:	655000ef          	jal	127a <malloc>
     42a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     42c:	4661                	li	a2,24
     42e:	4581                	li	a1,0
     430:	798000ef          	jal	bc8 <memset>
  cmd->type = PIPE;
     434:	478d                	li	a5,3
     436:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     438:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     43c:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     440:	8526                	mv	a0,s1
     442:	70a2                	ld	ra,40(sp)
     444:	7402                	ld	s0,32(sp)
     446:	64e2                	ld	s1,24(sp)
     448:	6942                	ld	s2,16(sp)
     44a:	69a2                	ld	s3,8(sp)
     44c:	6145                	addi	sp,sp,48
     44e:	8082                	ret

0000000000000450 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     450:	7179                	addi	sp,sp,-48
     452:	f406                	sd	ra,40(sp)
     454:	f022                	sd	s0,32(sp)
     456:	ec26                	sd	s1,24(sp)
     458:	e84a                	sd	s2,16(sp)
     45a:	e44e                	sd	s3,8(sp)
     45c:	1800                	addi	s0,sp,48
     45e:	89aa                	mv	s3,a0
     460:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     462:	4561                	li	a0,24
     464:	617000ef          	jal	127a <malloc>
     468:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     46a:	4661                	li	a2,24
     46c:	4581                	li	a1,0
     46e:	75a000ef          	jal	bc8 <memset>
  cmd->type = LIST;
     472:	4791                	li	a5,4
     474:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     476:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     47a:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     47e:	8526                	mv	a0,s1
     480:	70a2                	ld	ra,40(sp)
     482:	7402                	ld	s0,32(sp)
     484:	64e2                	ld	s1,24(sp)
     486:	6942                	ld	s2,16(sp)
     488:	69a2                	ld	s3,8(sp)
     48a:	6145                	addi	sp,sp,48
     48c:	8082                	ret

000000000000048e <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     48e:	1101                	addi	sp,sp,-32
     490:	ec06                	sd	ra,24(sp)
     492:	e822                	sd	s0,16(sp)
     494:	e426                	sd	s1,8(sp)
     496:	e04a                	sd	s2,0(sp)
     498:	1000                	addi	s0,sp,32
     49a:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     49c:	4541                	li	a0,16
     49e:	5dd000ef          	jal	127a <malloc>
     4a2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4a4:	4641                	li	a2,16
     4a6:	4581                	li	a1,0
     4a8:	720000ef          	jal	bc8 <memset>
  cmd->type = BACK;
     4ac:	4795                	li	a5,5
     4ae:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     4b0:	0124b423          	sd	s2,8(s1)
  return (struct cmd *)cmd;
}
     4b4:	8526                	mv	a0,s1
     4b6:	60e2                	ld	ra,24(sp)
     4b8:	6442                	ld	s0,16(sp)
     4ba:	64a2                	ld	s1,8(sp)
     4bc:	6902                	ld	s2,0(sp)
     4be:	6105                	addi	sp,sp,32
     4c0:	8082                	ret

00000000000004c2 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     4c2:	7139                	addi	sp,sp,-64
     4c4:	fc06                	sd	ra,56(sp)
     4c6:	f822                	sd	s0,48(sp)
     4c8:	f426                	sd	s1,40(sp)
     4ca:	f04a                	sd	s2,32(sp)
     4cc:	ec4e                	sd	s3,24(sp)
     4ce:	e852                	sd	s4,16(sp)
     4d0:	e456                	sd	s5,8(sp)
     4d2:	e05a                	sd	s6,0(sp)
     4d4:	0080                	addi	s0,sp,64
     4d6:	8a2a                	mv	s4,a0
     4d8:	892e                	mv	s2,a1
     4da:	8ab2                	mv	s5,a2
     4dc:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     4de:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     4e0:	00002997          	auipc	s3,0x2
     4e4:	b2898993          	addi	s3,s3,-1240 # 2008 <whitespace>
     4e8:	00b4fc63          	bgeu	s1,a1,500 <gettoken+0x3e>
     4ec:	0004c583          	lbu	a1,0(s1)
     4f0:	854e                	mv	a0,s3
     4f2:	6f8000ef          	jal	bea <strchr>
     4f6:	c509                	beqz	a0,500 <gettoken+0x3e>
    s++;
     4f8:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     4fa:	fe9919e3          	bne	s2,s1,4ec <gettoken+0x2a>
     4fe:	84ca                	mv	s1,s2
  if (q)
     500:	000a8463          	beqz	s5,508 <gettoken+0x46>
    *q = s;
     504:	009ab023          	sd	s1,0(s5)
  ret = *s;
     508:	0004c783          	lbu	a5,0(s1)
     50c:	00078a9b          	sext.w	s5,a5
  switch (*s)
     510:	03c00713          	li	a4,60
     514:	06f76463          	bltu	a4,a5,57c <gettoken+0xba>
     518:	03a00713          	li	a4,58
     51c:	00f76e63          	bltu	a4,a5,538 <gettoken+0x76>
     520:	cf89                	beqz	a5,53a <gettoken+0x78>
     522:	02600713          	li	a4,38
     526:	00e78963          	beq	a5,a4,538 <gettoken+0x76>
     52a:	fd87879b          	addiw	a5,a5,-40
     52e:	0ff7f793          	zext.b	a5,a5
     532:	4705                	li	a4,1
     534:	06f76b63          	bltu	a4,a5,5aa <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     538:	0485                	addi	s1,s1,1
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     53a:	000b0463          	beqz	s6,542 <gettoken+0x80>
    *eq = s;
     53e:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
     542:	00002997          	auipc	s3,0x2
     546:	ac698993          	addi	s3,s3,-1338 # 2008 <whitespace>
     54a:	0124fc63          	bgeu	s1,s2,562 <gettoken+0xa0>
     54e:	0004c583          	lbu	a1,0(s1)
     552:	854e                	mv	a0,s3
     554:	696000ef          	jal	bea <strchr>
     558:	c509                	beqz	a0,562 <gettoken+0xa0>
    s++;
     55a:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     55c:	fe9919e3          	bne	s2,s1,54e <gettoken+0x8c>
     560:	84ca                	mv	s1,s2
  *ps = s;
     562:	009a3023          	sd	s1,0(s4)
  return ret;
}
     566:	8556                	mv	a0,s5
     568:	70e2                	ld	ra,56(sp)
     56a:	7442                	ld	s0,48(sp)
     56c:	74a2                	ld	s1,40(sp)
     56e:	7902                	ld	s2,32(sp)
     570:	69e2                	ld	s3,24(sp)
     572:	6a42                	ld	s4,16(sp)
     574:	6aa2                	ld	s5,8(sp)
     576:	6b02                	ld	s6,0(sp)
     578:	6121                	addi	sp,sp,64
     57a:	8082                	ret
  switch (*s)
     57c:	03e00713          	li	a4,62
     580:	02e79163          	bne	a5,a4,5a2 <gettoken+0xe0>
    s++;
     584:	00148693          	addi	a3,s1,1
    if (*s == '>')
     588:	0014c703          	lbu	a4,1(s1)
     58c:	03e00793          	li	a5,62
      s++;
     590:	0489                	addi	s1,s1,2
      ret = '+';
     592:	02b00a93          	li	s5,43
    if (*s == '>')
     596:	faf702e3          	beq	a4,a5,53a <gettoken+0x78>
    s++;
     59a:	84b6                	mv	s1,a3
  ret = *s;
     59c:	03e00a93          	li	s5,62
     5a0:	bf69                	j	53a <gettoken+0x78>
  switch (*s)
     5a2:	07c00713          	li	a4,124
     5a6:	f8e789e3          	beq	a5,a4,538 <gettoken+0x76>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5aa:	00002997          	auipc	s3,0x2
     5ae:	a5e98993          	addi	s3,s3,-1442 # 2008 <whitespace>
     5b2:	00002a97          	auipc	s5,0x2
     5b6:	a4ea8a93          	addi	s5,s5,-1458 # 2000 <symbols>
     5ba:	0324fd63          	bgeu	s1,s2,5f4 <gettoken+0x132>
     5be:	0004c583          	lbu	a1,0(s1)
     5c2:	854e                	mv	a0,s3
     5c4:	626000ef          	jal	bea <strchr>
     5c8:	e11d                	bnez	a0,5ee <gettoken+0x12c>
     5ca:	0004c583          	lbu	a1,0(s1)
     5ce:	8556                	mv	a0,s5
     5d0:	61a000ef          	jal	bea <strchr>
     5d4:	e911                	bnez	a0,5e8 <gettoken+0x126>
      s++;
     5d6:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5d8:	fe9913e3          	bne	s2,s1,5be <gettoken+0xfc>
  if (eq)
     5dc:	84ca                	mv	s1,s2
    ret = 'a';
     5de:	06100a93          	li	s5,97
  if (eq)
     5e2:	f40b1ee3          	bnez	s6,53e <gettoken+0x7c>
     5e6:	bfb5                	j	562 <gettoken+0xa0>
    ret = 'a';
     5e8:	06100a93          	li	s5,97
     5ec:	b7b9                	j	53a <gettoken+0x78>
     5ee:	06100a93          	li	s5,97
     5f2:	b7a1                	j	53a <gettoken+0x78>
     5f4:	06100a93          	li	s5,97
  if (eq)
     5f8:	f40b13e3          	bnez	s6,53e <gettoken+0x7c>
     5fc:	b79d                	j	562 <gettoken+0xa0>

00000000000005fe <peek>:

int peek(char **ps, char *es, char *toks)
{
     5fe:	7139                	addi	sp,sp,-64
     600:	fc06                	sd	ra,56(sp)
     602:	f822                	sd	s0,48(sp)
     604:	f426                	sd	s1,40(sp)
     606:	f04a                	sd	s2,32(sp)
     608:	ec4e                	sd	s3,24(sp)
     60a:	e852                	sd	s4,16(sp)
     60c:	e456                	sd	s5,8(sp)
     60e:	0080                	addi	s0,sp,64
     610:	8a2a                	mv	s4,a0
     612:	892e                	mv	s2,a1
     614:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     616:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     618:	00002997          	auipc	s3,0x2
     61c:	9f098993          	addi	s3,s3,-1552 # 2008 <whitespace>
     620:	00b4fc63          	bgeu	s1,a1,638 <peek+0x3a>
     624:	0004c583          	lbu	a1,0(s1)
     628:	854e                	mv	a0,s3
     62a:	5c0000ef          	jal	bea <strchr>
     62e:	c509                	beqz	a0,638 <peek+0x3a>
    s++;
     630:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     632:	fe9919e3          	bne	s2,s1,624 <peek+0x26>
     636:	84ca                	mv	s1,s2
  *ps = s;
     638:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     63c:	0004c583          	lbu	a1,0(s1)
     640:	4501                	li	a0,0
     642:	e991                	bnez	a1,656 <peek+0x58>
}
     644:	70e2                	ld	ra,56(sp)
     646:	7442                	ld	s0,48(sp)
     648:	74a2                	ld	s1,40(sp)
     64a:	7902                	ld	s2,32(sp)
     64c:	69e2                	ld	s3,24(sp)
     64e:	6a42                	ld	s4,16(sp)
     650:	6aa2                	ld	s5,8(sp)
     652:	6121                	addi	sp,sp,64
     654:	8082                	ret
  return *s && strchr(toks, *s);
     656:	8556                	mv	a0,s5
     658:	592000ef          	jal	bea <strchr>
     65c:	00a03533          	snez	a0,a0
     660:	b7d5                	j	644 <peek+0x46>

0000000000000662 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     662:	711d                	addi	sp,sp,-96
     664:	ec86                	sd	ra,88(sp)
     666:	e8a2                	sd	s0,80(sp)
     668:	e4a6                	sd	s1,72(sp)
     66a:	e0ca                	sd	s2,64(sp)
     66c:	fc4e                	sd	s3,56(sp)
     66e:	f852                	sd	s4,48(sp)
     670:	f456                	sd	s5,40(sp)
     672:	f05a                	sd	s6,32(sp)
     674:	ec5e                	sd	s7,24(sp)
     676:	1080                	addi	s0,sp,96
     678:	8a2a                	mv	s4,a0
     67a:	89ae                	mv	s3,a1
     67c:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>"))
     67e:	00001a97          	auipc	s5,0x1
     682:	da2a8a93          	addi	s5,s5,-606 # 1420 <malloc+0x1a6>
  {
    tok = gettoken(ps, es, 0, 0);
    if (gettoken(ps, es, &q, &eq) != 'a')
     686:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch (tok)
     68a:	03c00b93          	li	s7,60
  while (peek(ps, es, "<>"))
     68e:	a00d                	j	6b0 <parseredirs+0x4e>
      panic("missing file for redirection");
     690:	00001517          	auipc	a0,0x1
     694:	d7050513          	addi	a0,a0,-656 # 1400 <malloc+0x186>
     698:	9b3ff0ef          	jal	4a <panic>
    {
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     69c:	4701                	li	a4,0
     69e:	4681                	li	a3,0
     6a0:	fa043603          	ld	a2,-96(s0)
     6a4:	fa843583          	ld	a1,-88(s0)
     6a8:	8552                	mv	a0,s4
     6aa:	d09ff0ef          	jal	3b2 <redircmd>
     6ae:	8a2a                	mv	s4,a0
  while (peek(ps, es, "<>"))
     6b0:	8656                	mv	a2,s5
     6b2:	85ca                	mv	a1,s2
     6b4:	854e                	mv	a0,s3
     6b6:	f49ff0ef          	jal	5fe <peek>
     6ba:	c525                	beqz	a0,722 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     6bc:	4681                	li	a3,0
     6be:	4601                	li	a2,0
     6c0:	85ca                	mv	a1,s2
     6c2:	854e                	mv	a0,s3
     6c4:	dffff0ef          	jal	4c2 <gettoken>
     6c8:	84aa                	mv	s1,a0
    if (gettoken(ps, es, &q, &eq) != 'a')
     6ca:	fa040693          	addi	a3,s0,-96
     6ce:	fa840613          	addi	a2,s0,-88
     6d2:	85ca                	mv	a1,s2
     6d4:	854e                	mv	a0,s3
     6d6:	dedff0ef          	jal	4c2 <gettoken>
     6da:	fb651be3          	bne	a0,s6,690 <parseredirs+0x2e>
    switch (tok)
     6de:	fb748fe3          	beq	s1,s7,69c <parseredirs+0x3a>
     6e2:	03e00793          	li	a5,62
     6e6:	02f48263          	beq	s1,a5,70a <parseredirs+0xa8>
     6ea:	02b00793          	li	a5,43
     6ee:	fcf491e3          	bne	s1,a5,6b0 <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     6f2:	4705                	li	a4,1
     6f4:	20100693          	li	a3,513
     6f8:	fa043603          	ld	a2,-96(s0)
     6fc:	fa843583          	ld	a1,-88(s0)
     700:	8552                	mv	a0,s4
     702:	cb1ff0ef          	jal	3b2 <redircmd>
     706:	8a2a                	mv	s4,a0
      break;
     708:	b765                	j	6b0 <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     70a:	4705                	li	a4,1
     70c:	60100693          	li	a3,1537
     710:	fa043603          	ld	a2,-96(s0)
     714:	fa843583          	ld	a1,-88(s0)
     718:	8552                	mv	a0,s4
     71a:	c99ff0ef          	jal	3b2 <redircmd>
     71e:	8a2a                	mv	s4,a0
      break;
     720:	bf41                	j	6b0 <parseredirs+0x4e>
    }
  }
  return cmd;
}
     722:	8552                	mv	a0,s4
     724:	60e6                	ld	ra,88(sp)
     726:	6446                	ld	s0,80(sp)
     728:	64a6                	ld	s1,72(sp)
     72a:	6906                	ld	s2,64(sp)
     72c:	79e2                	ld	s3,56(sp)
     72e:	7a42                	ld	s4,48(sp)
     730:	7aa2                	ld	s5,40(sp)
     732:	7b02                	ld	s6,32(sp)
     734:	6be2                	ld	s7,24(sp)
     736:	6125                	addi	sp,sp,96
     738:	8082                	ret

000000000000073a <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     73a:	7159                	addi	sp,sp,-112
     73c:	f486                	sd	ra,104(sp)
     73e:	f0a2                	sd	s0,96(sp)
     740:	eca6                	sd	s1,88(sp)
     742:	e0d2                	sd	s4,64(sp)
     744:	fc56                	sd	s5,56(sp)
     746:	1880                	addi	s0,sp,112
     748:	8a2a                	mv	s4,a0
     74a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     74c:	00001617          	auipc	a2,0x1
     750:	cdc60613          	addi	a2,a2,-804 # 1428 <malloc+0x1ae>
     754:	eabff0ef          	jal	5fe <peek>
     758:	e915                	bnez	a0,78c <parseexec+0x52>
     75a:	e8ca                	sd	s2,80(sp)
     75c:	e4ce                	sd	s3,72(sp)
     75e:	f85a                	sd	s6,48(sp)
     760:	f45e                	sd	s7,40(sp)
     762:	f062                	sd	s8,32(sp)
     764:	ec66                	sd	s9,24(sp)
     766:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     768:	c1dff0ef          	jal	384 <execcmd>
     76c:	8c2a                	mv	s8,a0
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     76e:	8656                	mv	a2,s5
     770:	85d2                	mv	a1,s4
     772:	ef1ff0ef          	jal	662 <parseredirs>
     776:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     778:	008c0913          	addi	s2,s8,8
     77c:	00001b17          	auipc	s6,0x1
     780:	cccb0b13          	addi	s6,s6,-820 # 1448 <malloc+0x1ce>
  {
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
      break;
    if (tok != 'a')
     784:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
     788:	4ba9                	li	s7,10
  while (!peek(ps, es, "|)&;"))
     78a:	a815                	j	7be <parseexec+0x84>
    return parseblock(ps, es);
     78c:	85d6                	mv	a1,s5
     78e:	8552                	mv	a0,s4
     790:	170000ef          	jal	900 <parseblock>
     794:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     796:	8526                	mv	a0,s1
     798:	70a6                	ld	ra,104(sp)
     79a:	7406                	ld	s0,96(sp)
     79c:	64e6                	ld	s1,88(sp)
     79e:	6a06                	ld	s4,64(sp)
     7a0:	7ae2                	ld	s5,56(sp)
     7a2:	6165                	addi	sp,sp,112
     7a4:	8082                	ret
      panic("syntax");
     7a6:	00001517          	auipc	a0,0x1
     7aa:	c8a50513          	addi	a0,a0,-886 # 1430 <malloc+0x1b6>
     7ae:	89dff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     7b2:	8656                	mv	a2,s5
     7b4:	85d2                	mv	a1,s4
     7b6:	8526                	mv	a0,s1
     7b8:	eabff0ef          	jal	662 <parseredirs>
     7bc:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;"))
     7be:	865a                	mv	a2,s6
     7c0:	85d6                	mv	a1,s5
     7c2:	8552                	mv	a0,s4
     7c4:	e3bff0ef          	jal	5fe <peek>
     7c8:	ed15                	bnez	a0,804 <parseexec+0xca>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     7ca:	f9040693          	addi	a3,s0,-112
     7ce:	f9840613          	addi	a2,s0,-104
     7d2:	85d6                	mv	a1,s5
     7d4:	8552                	mv	a0,s4
     7d6:	cedff0ef          	jal	4c2 <gettoken>
     7da:	c50d                	beqz	a0,804 <parseexec+0xca>
    if (tok != 'a')
     7dc:	fd9515e3          	bne	a0,s9,7a6 <parseexec+0x6c>
    cmd->argv[argc] = q;
     7e0:	f9843783          	ld	a5,-104(s0)
     7e4:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     7e8:	f9043783          	ld	a5,-112(s0)
     7ec:	04f93823          	sd	a5,80(s2)
    argc++;
     7f0:	2985                	addiw	s3,s3,1
    if (argc >= MAXARGS)
     7f2:	0921                	addi	s2,s2,8
     7f4:	fb799fe3          	bne	s3,s7,7b2 <parseexec+0x78>
      panic("too many args");
     7f8:	00001517          	auipc	a0,0x1
     7fc:	c4050513          	addi	a0,a0,-960 # 1438 <malloc+0x1be>
     800:	84bff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     804:	098e                	slli	s3,s3,0x3
     806:	9c4e                	add	s8,s8,s3
     808:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     80c:	040c3c23          	sd	zero,88(s8)
     810:	6946                	ld	s2,80(sp)
     812:	69a6                	ld	s3,72(sp)
     814:	7b42                	ld	s6,48(sp)
     816:	7ba2                	ld	s7,40(sp)
     818:	7c02                	ld	s8,32(sp)
     81a:	6ce2                	ld	s9,24(sp)
  return ret;
     81c:	bfad                	j	796 <parseexec+0x5c>

000000000000081e <parsepipe>:
{
     81e:	7179                	addi	sp,sp,-48
     820:	f406                	sd	ra,40(sp)
     822:	f022                	sd	s0,32(sp)
     824:	ec26                	sd	s1,24(sp)
     826:	e84a                	sd	s2,16(sp)
     828:	e44e                	sd	s3,8(sp)
     82a:	1800                	addi	s0,sp,48
     82c:	892a                	mv	s2,a0
     82e:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     830:	f0bff0ef          	jal	73a <parseexec>
     834:	84aa                	mv	s1,a0
  if (peek(ps, es, "|"))
     836:	00001617          	auipc	a2,0x1
     83a:	c1a60613          	addi	a2,a2,-998 # 1450 <malloc+0x1d6>
     83e:	85ce                	mv	a1,s3
     840:	854a                	mv	a0,s2
     842:	dbdff0ef          	jal	5fe <peek>
     846:	e909                	bnez	a0,858 <parsepipe+0x3a>
}
     848:	8526                	mv	a0,s1
     84a:	70a2                	ld	ra,40(sp)
     84c:	7402                	ld	s0,32(sp)
     84e:	64e2                	ld	s1,24(sp)
     850:	6942                	ld	s2,16(sp)
     852:	69a2                	ld	s3,8(sp)
     854:	6145                	addi	sp,sp,48
     856:	8082                	ret
    gettoken(ps, es, 0, 0);
     858:	4681                	li	a3,0
     85a:	4601                	li	a2,0
     85c:	85ce                	mv	a1,s3
     85e:	854a                	mv	a0,s2
     860:	c63ff0ef          	jal	4c2 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     864:	85ce                	mv	a1,s3
     866:	854a                	mv	a0,s2
     868:	fb7ff0ef          	jal	81e <parsepipe>
     86c:	85aa                	mv	a1,a0
     86e:	8526                	mv	a0,s1
     870:	ba3ff0ef          	jal	412 <pipecmd>
     874:	84aa                	mv	s1,a0
  return cmd;
     876:	bfc9                	j	848 <parsepipe+0x2a>

0000000000000878 <parseline>:
{
     878:	7179                	addi	sp,sp,-48
     87a:	f406                	sd	ra,40(sp)
     87c:	f022                	sd	s0,32(sp)
     87e:	ec26                	sd	s1,24(sp)
     880:	e84a                	sd	s2,16(sp)
     882:	e44e                	sd	s3,8(sp)
     884:	e052                	sd	s4,0(sp)
     886:	1800                	addi	s0,sp,48
     888:	892a                	mv	s2,a0
     88a:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     88c:	f93ff0ef          	jal	81e <parsepipe>
     890:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     892:	00001a17          	auipc	s4,0x1
     896:	bc6a0a13          	addi	s4,s4,-1082 # 1458 <malloc+0x1de>
     89a:	a819                	j	8b0 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     89c:	4681                	li	a3,0
     89e:	4601                	li	a2,0
     8a0:	85ce                	mv	a1,s3
     8a2:	854a                	mv	a0,s2
     8a4:	c1fff0ef          	jal	4c2 <gettoken>
    cmd = backcmd(cmd);
     8a8:	8526                	mv	a0,s1
     8aa:	be5ff0ef          	jal	48e <backcmd>
     8ae:	84aa                	mv	s1,a0
  while (peek(ps, es, "&"))
     8b0:	8652                	mv	a2,s4
     8b2:	85ce                	mv	a1,s3
     8b4:	854a                	mv	a0,s2
     8b6:	d49ff0ef          	jal	5fe <peek>
     8ba:	f16d                	bnez	a0,89c <parseline+0x24>
  if (peek(ps, es, ";"))
     8bc:	00001617          	auipc	a2,0x1
     8c0:	ba460613          	addi	a2,a2,-1116 # 1460 <malloc+0x1e6>
     8c4:	85ce                	mv	a1,s3
     8c6:	854a                	mv	a0,s2
     8c8:	d37ff0ef          	jal	5fe <peek>
     8cc:	e911                	bnez	a0,8e0 <parseline+0x68>
}
     8ce:	8526                	mv	a0,s1
     8d0:	70a2                	ld	ra,40(sp)
     8d2:	7402                	ld	s0,32(sp)
     8d4:	64e2                	ld	s1,24(sp)
     8d6:	6942                	ld	s2,16(sp)
     8d8:	69a2                	ld	s3,8(sp)
     8da:	6a02                	ld	s4,0(sp)
     8dc:	6145                	addi	sp,sp,48
     8de:	8082                	ret
    gettoken(ps, es, 0, 0);
     8e0:	4681                	li	a3,0
     8e2:	4601                	li	a2,0
     8e4:	85ce                	mv	a1,s3
     8e6:	854a                	mv	a0,s2
     8e8:	bdbff0ef          	jal	4c2 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8ec:	85ce                	mv	a1,s3
     8ee:	854a                	mv	a0,s2
     8f0:	f89ff0ef          	jal	878 <parseline>
     8f4:	85aa                	mv	a1,a0
     8f6:	8526                	mv	a0,s1
     8f8:	b59ff0ef          	jal	450 <listcmd>
     8fc:	84aa                	mv	s1,a0
  return cmd;
     8fe:	bfc1                	j	8ce <parseline+0x56>

0000000000000900 <parseblock>:
{
     900:	7179                	addi	sp,sp,-48
     902:	f406                	sd	ra,40(sp)
     904:	f022                	sd	s0,32(sp)
     906:	ec26                	sd	s1,24(sp)
     908:	e84a                	sd	s2,16(sp)
     90a:	e44e                	sd	s3,8(sp)
     90c:	1800                	addi	s0,sp,48
     90e:	84aa                	mv	s1,a0
     910:	892e                	mv	s2,a1
  if (!peek(ps, es, "("))
     912:	00001617          	auipc	a2,0x1
     916:	b1660613          	addi	a2,a2,-1258 # 1428 <malloc+0x1ae>
     91a:	ce5ff0ef          	jal	5fe <peek>
     91e:	c539                	beqz	a0,96c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     920:	4681                	li	a3,0
     922:	4601                	li	a2,0
     924:	85ca                	mv	a1,s2
     926:	8526                	mv	a0,s1
     928:	b9bff0ef          	jal	4c2 <gettoken>
  cmd = parseline(ps, es);
     92c:	85ca                	mv	a1,s2
     92e:	8526                	mv	a0,s1
     930:	f49ff0ef          	jal	878 <parseline>
     934:	89aa                	mv	s3,a0
  if (!peek(ps, es, ")"))
     936:	00001617          	auipc	a2,0x1
     93a:	b4260613          	addi	a2,a2,-1214 # 1478 <malloc+0x1fe>
     93e:	85ca                	mv	a1,s2
     940:	8526                	mv	a0,s1
     942:	cbdff0ef          	jal	5fe <peek>
     946:	c90d                	beqz	a0,978 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     948:	4681                	li	a3,0
     94a:	4601                	li	a2,0
     94c:	85ca                	mv	a1,s2
     94e:	8526                	mv	a0,s1
     950:	b73ff0ef          	jal	4c2 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     954:	864a                	mv	a2,s2
     956:	85a6                	mv	a1,s1
     958:	854e                	mv	a0,s3
     95a:	d09ff0ef          	jal	662 <parseredirs>
}
     95e:	70a2                	ld	ra,40(sp)
     960:	7402                	ld	s0,32(sp)
     962:	64e2                	ld	s1,24(sp)
     964:	6942                	ld	s2,16(sp)
     966:	69a2                	ld	s3,8(sp)
     968:	6145                	addi	sp,sp,48
     96a:	8082                	ret
    panic("parseblock");
     96c:	00001517          	auipc	a0,0x1
     970:	afc50513          	addi	a0,a0,-1284 # 1468 <malloc+0x1ee>
     974:	ed6ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     978:	00001517          	auipc	a0,0x1
     97c:	b0850513          	addi	a0,a0,-1272 # 1480 <malloc+0x206>
     980:	ecaff0ef          	jal	4a <panic>

0000000000000984 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     984:	1101                	addi	sp,sp,-32
     986:	ec06                	sd	ra,24(sp)
     988:	e822                	sd	s0,16(sp)
     98a:	e426                	sd	s1,8(sp)
     98c:	1000                	addi	s0,sp,32
     98e:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     990:	c131                	beqz	a0,9d4 <nulterminate+0x50>
    return 0;

  switch (cmd->type)
     992:	4118                	lw	a4,0(a0)
     994:	4795                	li	a5,5
     996:	02e7ef63          	bltu	a5,a4,9d4 <nulterminate+0x50>
     99a:	00056783          	lwu	a5,0(a0)
     99e:	078a                	slli	a5,a5,0x2
     9a0:	00001717          	auipc	a4,0x1
     9a4:	b4070713          	addi	a4,a4,-1216 # 14e0 <malloc+0x266>
     9a8:	97ba                	add	a5,a5,a4
     9aa:	439c                	lw	a5,0(a5)
     9ac:	97ba                	add	a5,a5,a4
     9ae:	8782                	jr	a5
  {
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    for (i = 0; ecmd->argv[i]; i++)
     9b0:	651c                	ld	a5,8(a0)
     9b2:	c38d                	beqz	a5,9d4 <nulterminate+0x50>
     9b4:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     9b8:	67b8                	ld	a4,72(a5)
     9ba:	00070023          	sb	zero,0(a4)
    for (i = 0; ecmd->argv[i]; i++)
     9be:	07a1                	addi	a5,a5,8
     9c0:	ff87b703          	ld	a4,-8(a5)
     9c4:	fb75                	bnez	a4,9b8 <nulterminate+0x34>
     9c6:	a039                	j	9d4 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    nulterminate(rcmd->cmd);
     9c8:	6508                	ld	a0,8(a0)
     9ca:	fbbff0ef          	jal	984 <nulterminate>
    *rcmd->efile = 0;
     9ce:	6c9c                	ld	a5,24(s1)
     9d0:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9d4:	8526                	mv	a0,s1
     9d6:	60e2                	ld	ra,24(sp)
     9d8:	6442                	ld	s0,16(sp)
     9da:	64a2                	ld	s1,8(sp)
     9dc:	6105                	addi	sp,sp,32
     9de:	8082                	ret
    nulterminate(pcmd->left);
     9e0:	6508                	ld	a0,8(a0)
     9e2:	fa3ff0ef          	jal	984 <nulterminate>
    nulterminate(pcmd->right);
     9e6:	6888                	ld	a0,16(s1)
     9e8:	f9dff0ef          	jal	984 <nulterminate>
    break;
     9ec:	b7e5                	j	9d4 <nulterminate+0x50>
    nulterminate(lcmd->left);
     9ee:	6508                	ld	a0,8(a0)
     9f0:	f95ff0ef          	jal	984 <nulterminate>
    nulterminate(lcmd->right);
     9f4:	6888                	ld	a0,16(s1)
     9f6:	f8fff0ef          	jal	984 <nulterminate>
    break;
     9fa:	bfe9                	j	9d4 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     9fc:	6508                	ld	a0,8(a0)
     9fe:	f87ff0ef          	jal	984 <nulterminate>
    break;
     a02:	bfc9                	j	9d4 <nulterminate+0x50>

0000000000000a04 <parsecmd>:
{
     a04:	7179                	addi	sp,sp,-48
     a06:	f406                	sd	ra,40(sp)
     a08:	f022                	sd	s0,32(sp)
     a0a:	ec26                	sd	s1,24(sp)
     a0c:	e84a                	sd	s2,16(sp)
     a0e:	1800                	addi	s0,sp,48
     a10:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     a14:	84aa                	mv	s1,a0
     a16:	188000ef          	jal	b9e <strlen>
     a1a:	1502                	slli	a0,a0,0x20
     a1c:	9101                	srli	a0,a0,0x20
     a1e:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a20:	85a6                	mv	a1,s1
     a22:	fd840513          	addi	a0,s0,-40
     a26:	e53ff0ef          	jal	878 <parseline>
     a2a:	892a                	mv	s2,a0
  peek(&s, es, "");
     a2c:	00001617          	auipc	a2,0x1
     a30:	96c60613          	addi	a2,a2,-1684 # 1398 <malloc+0x11e>
     a34:	85a6                	mv	a1,s1
     a36:	fd840513          	addi	a0,s0,-40
     a3a:	bc5ff0ef          	jal	5fe <peek>
  if (s != es)
     a3e:	fd843603          	ld	a2,-40(s0)
     a42:	00961c63          	bne	a2,s1,a5a <parsecmd+0x56>
  nulterminate(cmd);
     a46:	854a                	mv	a0,s2
     a48:	f3dff0ef          	jal	984 <nulterminate>
}
     a4c:	854a                	mv	a0,s2
     a4e:	70a2                	ld	ra,40(sp)
     a50:	7402                	ld	s0,32(sp)
     a52:	64e2                	ld	s1,24(sp)
     a54:	6942                	ld	s2,16(sp)
     a56:	6145                	addi	sp,sp,48
     a58:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a5a:	00001597          	auipc	a1,0x1
     a5e:	a3e58593          	addi	a1,a1,-1474 # 1498 <malloc+0x21e>
     a62:	4509                	li	a0,2
     a64:	738000ef          	jal	119c <fprintf>
    panic("syntax");
     a68:	00001517          	auipc	a0,0x1
     a6c:	9c850513          	addi	a0,a0,-1592 # 1430 <malloc+0x1b6>
     a70:	ddaff0ef          	jal	4a <panic>

0000000000000a74 <main>:
{
     a74:	7179                	addi	sp,sp,-48
     a76:	f406                	sd	ra,40(sp)
     a78:	f022                	sd	s0,32(sp)
     a7a:	ec26                	sd	s1,24(sp)
     a7c:	e84a                	sd	s2,16(sp)
     a7e:	e44e                	sd	s3,8(sp)
     a80:	e052                	sd	s4,0(sp)
     a82:	1800                	addi	s0,sp,48
  while ((fd = open("console", O_RDWR)) >= 0)
     a84:	00001497          	auipc	s1,0x1
     a88:	a2448493          	addi	s1,s1,-1500 # 14a8 <malloc+0x22e>
     a8c:	4589                	li	a1,2
     a8e:	8526                	mv	a0,s1
     a90:	35e000ef          	jal	dee <open>
     a94:	00054763          	bltz	a0,aa2 <main+0x2e>
    if (fd >= 3)
     a98:	4789                	li	a5,2
     a9a:	fea7d9e3          	bge	a5,a0,a8c <main+0x18>
      close(fd);
     a9e:	338000ef          	jal	dd6 <close>
  while (getcmd(buf, sizeof(buf)) >= 0)
     aa2:	00001497          	auipc	s1,0x1
     aa6:	57e48493          	addi	s1,s1,1406 # 2020 <buf.0>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     aaa:	06300913          	li	s2,99
     aae:	02000993          	li	s3,32
     ab2:	a039                	j	ac0 <main+0x4c>
    if (fork1() == 0)
     ab4:	db4ff0ef          	jal	68 <fork1>
     ab8:	c93d                	beqz	a0,b2e <main+0xba>
    wait(0);
     aba:	4501                	li	a0,0
     abc:	2fa000ef          	jal	db6 <wait>
  while (getcmd(buf, sizeof(buf)) >= 0)
     ac0:	06400593          	li	a1,100
     ac4:	8526                	mv	a0,s1
     ac6:	d3aff0ef          	jal	0 <getcmd>
     aca:	06054a63          	bltz	a0,b3e <main+0xca>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     ace:	0004c783          	lbu	a5,0(s1)
     ad2:	ff2791e3          	bne	a5,s2,ab4 <main+0x40>
     ad6:	0014c703          	lbu	a4,1(s1)
     ada:	06400793          	li	a5,100
     ade:	fcf71be3          	bne	a4,a5,ab4 <main+0x40>
     ae2:	0024c783          	lbu	a5,2(s1)
     ae6:	fd3797e3          	bne	a5,s3,ab4 <main+0x40>
      buf[strlen(buf) - 1] = 0; // chop \n
     aea:	00001a17          	auipc	s4,0x1
     aee:	536a0a13          	addi	s4,s4,1334 # 2020 <buf.0>
     af2:	8552                	mv	a0,s4
     af4:	0aa000ef          	jal	b9e <strlen>
     af8:	fff5079b          	addiw	a5,a0,-1
     afc:	1782                	slli	a5,a5,0x20
     afe:	9381                	srli	a5,a5,0x20
     b00:	9a3e                	add	s4,s4,a5
     b02:	000a0023          	sb	zero,0(s4)
      if (chdir(buf + 3) < 0)
     b06:	00001517          	auipc	a0,0x1
     b0a:	51d50513          	addi	a0,a0,1309 # 2023 <buf.0+0x3>
     b0e:	310000ef          	jal	e1e <chdir>
     b12:	fa0557e3          	bgez	a0,ac0 <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf + 3);
     b16:	00001617          	auipc	a2,0x1
     b1a:	50d60613          	addi	a2,a2,1293 # 2023 <buf.0+0x3>
     b1e:	00001597          	auipc	a1,0x1
     b22:	99258593          	addi	a1,a1,-1646 # 14b0 <malloc+0x236>
     b26:	4509                	li	a0,2
     b28:	674000ef          	jal	119c <fprintf>
     b2c:	bf51                	j	ac0 <main+0x4c>
      runcmd(parsecmd(buf));
     b2e:	00001517          	auipc	a0,0x1
     b32:	4f250513          	addi	a0,a0,1266 # 2020 <buf.0>
     b36:	ecfff0ef          	jal	a04 <parsecmd>
     b3a:	d54ff0ef          	jal	8e <runcmd>
  exit(0);
     b3e:	4501                	li	a0,0
     b40:	26e000ef          	jal	dae <exit>

0000000000000b44 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     b44:	1141                	addi	sp,sp,-16
     b46:	e406                	sd	ra,8(sp)
     b48:	e022                	sd	s0,0(sp)
     b4a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     b4c:	f29ff0ef          	jal	a74 <main>
  exit(0);
     b50:	4501                	li	a0,0
     b52:	25c000ef          	jal	dae <exit>

0000000000000b56 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     b56:	1141                	addi	sp,sp,-16
     b58:	e422                	sd	s0,8(sp)
     b5a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b5c:	87aa                	mv	a5,a0
     b5e:	0585                	addi	a1,a1,1
     b60:	0785                	addi	a5,a5,1
     b62:	fff5c703          	lbu	a4,-1(a1)
     b66:	fee78fa3          	sb	a4,-1(a5)
     b6a:	fb75                	bnez	a4,b5e <strcpy+0x8>
    ;
  return os;
}
     b6c:	6422                	ld	s0,8(sp)
     b6e:	0141                	addi	sp,sp,16
     b70:	8082                	ret

0000000000000b72 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b72:	1141                	addi	sp,sp,-16
     b74:	e422                	sd	s0,8(sp)
     b76:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b78:	00054783          	lbu	a5,0(a0)
     b7c:	cb91                	beqz	a5,b90 <strcmp+0x1e>
     b7e:	0005c703          	lbu	a4,0(a1)
     b82:	00f71763          	bne	a4,a5,b90 <strcmp+0x1e>
    p++, q++;
     b86:	0505                	addi	a0,a0,1
     b88:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b8a:	00054783          	lbu	a5,0(a0)
     b8e:	fbe5                	bnez	a5,b7e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b90:	0005c503          	lbu	a0,0(a1)
}
     b94:	40a7853b          	subw	a0,a5,a0
     b98:	6422                	ld	s0,8(sp)
     b9a:	0141                	addi	sp,sp,16
     b9c:	8082                	ret

0000000000000b9e <strlen>:

uint
strlen(const char *s)
{
     b9e:	1141                	addi	sp,sp,-16
     ba0:	e422                	sd	s0,8(sp)
     ba2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     ba4:	00054783          	lbu	a5,0(a0)
     ba8:	cf91                	beqz	a5,bc4 <strlen+0x26>
     baa:	0505                	addi	a0,a0,1
     bac:	87aa                	mv	a5,a0
     bae:	86be                	mv	a3,a5
     bb0:	0785                	addi	a5,a5,1
     bb2:	fff7c703          	lbu	a4,-1(a5)
     bb6:	ff65                	bnez	a4,bae <strlen+0x10>
     bb8:	40a6853b          	subw	a0,a3,a0
     bbc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     bbe:	6422                	ld	s0,8(sp)
     bc0:	0141                	addi	sp,sp,16
     bc2:	8082                	ret
  for(n = 0; s[n]; n++)
     bc4:	4501                	li	a0,0
     bc6:	bfe5                	j	bbe <strlen+0x20>

0000000000000bc8 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bc8:	1141                	addi	sp,sp,-16
     bca:	e422                	sd	s0,8(sp)
     bcc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bce:	ca19                	beqz	a2,be4 <memset+0x1c>
     bd0:	87aa                	mv	a5,a0
     bd2:	1602                	slli	a2,a2,0x20
     bd4:	9201                	srli	a2,a2,0x20
     bd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bde:	0785                	addi	a5,a5,1
     be0:	fee79de3          	bne	a5,a4,bda <memset+0x12>
  }
  return dst;
}
     be4:	6422                	ld	s0,8(sp)
     be6:	0141                	addi	sp,sp,16
     be8:	8082                	ret

0000000000000bea <strchr>:

char*
strchr(const char *s, char c)
{
     bea:	1141                	addi	sp,sp,-16
     bec:	e422                	sd	s0,8(sp)
     bee:	0800                	addi	s0,sp,16
  for(; *s; s++)
     bf0:	00054783          	lbu	a5,0(a0)
     bf4:	cb99                	beqz	a5,c0a <strchr+0x20>
    if(*s == c)
     bf6:	00f58763          	beq	a1,a5,c04 <strchr+0x1a>
  for(; *s; s++)
     bfa:	0505                	addi	a0,a0,1
     bfc:	00054783          	lbu	a5,0(a0)
     c00:	fbfd                	bnez	a5,bf6 <strchr+0xc>
      return (char*)s;
  return 0;
     c02:	4501                	li	a0,0
}
     c04:	6422                	ld	s0,8(sp)
     c06:	0141                	addi	sp,sp,16
     c08:	8082                	ret
  return 0;
     c0a:	4501                	li	a0,0
     c0c:	bfe5                	j	c04 <strchr+0x1a>

0000000000000c0e <gets>:

char*
gets(char *buf, int max)
{
     c0e:	711d                	addi	sp,sp,-96
     c10:	ec86                	sd	ra,88(sp)
     c12:	e8a2                	sd	s0,80(sp)
     c14:	e4a6                	sd	s1,72(sp)
     c16:	e0ca                	sd	s2,64(sp)
     c18:	fc4e                	sd	s3,56(sp)
     c1a:	f852                	sd	s4,48(sp)
     c1c:	f456                	sd	s5,40(sp)
     c1e:	f05a                	sd	s6,32(sp)
     c20:	ec5e                	sd	s7,24(sp)
     c22:	1080                	addi	s0,sp,96
     c24:	8baa                	mv	s7,a0
     c26:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c28:	892a                	mv	s2,a0
     c2a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c2c:	4aa9                	li	s5,10
     c2e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c30:	89a6                	mv	s3,s1
     c32:	2485                	addiw	s1,s1,1
     c34:	0344d663          	bge	s1,s4,c60 <gets+0x52>
    cc = read(0, &c, 1);
     c38:	4605                	li	a2,1
     c3a:	faf40593          	addi	a1,s0,-81
     c3e:	4501                	li	a0,0
     c40:	186000ef          	jal	dc6 <read>
    if(cc < 1)
     c44:	00a05e63          	blez	a0,c60 <gets+0x52>
    buf[i++] = c;
     c48:	faf44783          	lbu	a5,-81(s0)
     c4c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c50:	01578763          	beq	a5,s5,c5e <gets+0x50>
     c54:	0905                	addi	s2,s2,1
     c56:	fd679de3          	bne	a5,s6,c30 <gets+0x22>
    buf[i++] = c;
     c5a:	89a6                	mv	s3,s1
     c5c:	a011                	j	c60 <gets+0x52>
     c5e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c60:	99de                	add	s3,s3,s7
     c62:	00098023          	sb	zero,0(s3)
  return buf;
}
     c66:	855e                	mv	a0,s7
     c68:	60e6                	ld	ra,88(sp)
     c6a:	6446                	ld	s0,80(sp)
     c6c:	64a6                	ld	s1,72(sp)
     c6e:	6906                	ld	s2,64(sp)
     c70:	79e2                	ld	s3,56(sp)
     c72:	7a42                	ld	s4,48(sp)
     c74:	7aa2                	ld	s5,40(sp)
     c76:	7b02                	ld	s6,32(sp)
     c78:	6be2                	ld	s7,24(sp)
     c7a:	6125                	addi	sp,sp,96
     c7c:	8082                	ret

0000000000000c7e <stat>:

int
stat(const char *n, struct stat *st)
{
     c7e:	1101                	addi	sp,sp,-32
     c80:	ec06                	sd	ra,24(sp)
     c82:	e822                	sd	s0,16(sp)
     c84:	e04a                	sd	s2,0(sp)
     c86:	1000                	addi	s0,sp,32
     c88:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c8a:	4581                	li	a1,0
     c8c:	162000ef          	jal	dee <open>
  if(fd < 0)
     c90:	02054263          	bltz	a0,cb4 <stat+0x36>
     c94:	e426                	sd	s1,8(sp)
     c96:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     c98:	85ca                	mv	a1,s2
     c9a:	16c000ef          	jal	e06 <fstat>
     c9e:	892a                	mv	s2,a0
  close(fd);
     ca0:	8526                	mv	a0,s1
     ca2:	134000ef          	jal	dd6 <close>
  return r;
     ca6:	64a2                	ld	s1,8(sp)
}
     ca8:	854a                	mv	a0,s2
     caa:	60e2                	ld	ra,24(sp)
     cac:	6442                	ld	s0,16(sp)
     cae:	6902                	ld	s2,0(sp)
     cb0:	6105                	addi	sp,sp,32
     cb2:	8082                	ret
    return -1;
     cb4:	597d                	li	s2,-1
     cb6:	bfcd                	j	ca8 <stat+0x2a>

0000000000000cb8 <atoi>:

int
atoi(const char *s)
{
     cb8:	1141                	addi	sp,sp,-16
     cba:	e422                	sd	s0,8(sp)
     cbc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cbe:	00054683          	lbu	a3,0(a0)
     cc2:	fd06879b          	addiw	a5,a3,-48
     cc6:	0ff7f793          	zext.b	a5,a5
     cca:	4625                	li	a2,9
     ccc:	02f66863          	bltu	a2,a5,cfc <atoi+0x44>
     cd0:	872a                	mv	a4,a0
  n = 0;
     cd2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     cd4:	0705                	addi	a4,a4,1
     cd6:	0025179b          	slliw	a5,a0,0x2
     cda:	9fa9                	addw	a5,a5,a0
     cdc:	0017979b          	slliw	a5,a5,0x1
     ce0:	9fb5                	addw	a5,a5,a3
     ce2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ce6:	00074683          	lbu	a3,0(a4)
     cea:	fd06879b          	addiw	a5,a3,-48
     cee:	0ff7f793          	zext.b	a5,a5
     cf2:	fef671e3          	bgeu	a2,a5,cd4 <atoi+0x1c>
  return n;
}
     cf6:	6422                	ld	s0,8(sp)
     cf8:	0141                	addi	sp,sp,16
     cfa:	8082                	ret
  n = 0;
     cfc:	4501                	li	a0,0
     cfe:	bfe5                	j	cf6 <atoi+0x3e>

0000000000000d00 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d00:	1141                	addi	sp,sp,-16
     d02:	e422                	sd	s0,8(sp)
     d04:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d06:	02b57463          	bgeu	a0,a1,d2e <memmove+0x2e>
    while(n-- > 0)
     d0a:	00c05f63          	blez	a2,d28 <memmove+0x28>
     d0e:	1602                	slli	a2,a2,0x20
     d10:	9201                	srli	a2,a2,0x20
     d12:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d16:	872a                	mv	a4,a0
      *dst++ = *src++;
     d18:	0585                	addi	a1,a1,1
     d1a:	0705                	addi	a4,a4,1
     d1c:	fff5c683          	lbu	a3,-1(a1)
     d20:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d24:	fef71ae3          	bne	a4,a5,d18 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d28:	6422                	ld	s0,8(sp)
     d2a:	0141                	addi	sp,sp,16
     d2c:	8082                	ret
    dst += n;
     d2e:	00c50733          	add	a4,a0,a2
    src += n;
     d32:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d34:	fec05ae3          	blez	a2,d28 <memmove+0x28>
     d38:	fff6079b          	addiw	a5,a2,-1
     d3c:	1782                	slli	a5,a5,0x20
     d3e:	9381                	srli	a5,a5,0x20
     d40:	fff7c793          	not	a5,a5
     d44:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d46:	15fd                	addi	a1,a1,-1
     d48:	177d                	addi	a4,a4,-1
     d4a:	0005c683          	lbu	a3,0(a1)
     d4e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d52:	fee79ae3          	bne	a5,a4,d46 <memmove+0x46>
     d56:	bfc9                	j	d28 <memmove+0x28>

0000000000000d58 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d58:	1141                	addi	sp,sp,-16
     d5a:	e422                	sd	s0,8(sp)
     d5c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d5e:	ca05                	beqz	a2,d8e <memcmp+0x36>
     d60:	fff6069b          	addiw	a3,a2,-1
     d64:	1682                	slli	a3,a3,0x20
     d66:	9281                	srli	a3,a3,0x20
     d68:	0685                	addi	a3,a3,1
     d6a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d6c:	00054783          	lbu	a5,0(a0)
     d70:	0005c703          	lbu	a4,0(a1)
     d74:	00e79863          	bne	a5,a4,d84 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d78:	0505                	addi	a0,a0,1
    p2++;
     d7a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d7c:	fed518e3          	bne	a0,a3,d6c <memcmp+0x14>
  }
  return 0;
     d80:	4501                	li	a0,0
     d82:	a019                	j	d88 <memcmp+0x30>
      return *p1 - *p2;
     d84:	40e7853b          	subw	a0,a5,a4
}
     d88:	6422                	ld	s0,8(sp)
     d8a:	0141                	addi	sp,sp,16
     d8c:	8082                	ret
  return 0;
     d8e:	4501                	li	a0,0
     d90:	bfe5                	j	d88 <memcmp+0x30>

0000000000000d92 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     d92:	1141                	addi	sp,sp,-16
     d94:	e406                	sd	ra,8(sp)
     d96:	e022                	sd	s0,0(sp)
     d98:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     d9a:	f67ff0ef          	jal	d00 <memmove>
}
     d9e:	60a2                	ld	ra,8(sp)
     da0:	6402                	ld	s0,0(sp)
     da2:	0141                	addi	sp,sp,16
     da4:	8082                	ret

0000000000000da6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     da6:	4885                	li	a7,1
 ecall
     da8:	00000073          	ecall
 ret
     dac:	8082                	ret

0000000000000dae <exit>:
.global exit
exit:
 li a7, SYS_exit
     dae:	4889                	li	a7,2
 ecall
     db0:	00000073          	ecall
 ret
     db4:	8082                	ret

0000000000000db6 <wait>:
.global wait
wait:
 li a7, SYS_wait
     db6:	488d                	li	a7,3
 ecall
     db8:	00000073          	ecall
 ret
     dbc:	8082                	ret

0000000000000dbe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     dbe:	4891                	li	a7,4
 ecall
     dc0:	00000073          	ecall
 ret
     dc4:	8082                	ret

0000000000000dc6 <read>:
.global read
read:
 li a7, SYS_read
     dc6:	4895                	li	a7,5
 ecall
     dc8:	00000073          	ecall
 ret
     dcc:	8082                	ret

0000000000000dce <write>:
.global write
write:
 li a7, SYS_write
     dce:	48c1                	li	a7,16
 ecall
     dd0:	00000073          	ecall
 ret
     dd4:	8082                	ret

0000000000000dd6 <close>:
.global close
close:
 li a7, SYS_close
     dd6:	48d5                	li	a7,21
 ecall
     dd8:	00000073          	ecall
 ret
     ddc:	8082                	ret

0000000000000dde <kill>:
.global kill
kill:
 li a7, SYS_kill
     dde:	4899                	li	a7,6
 ecall
     de0:	00000073          	ecall
 ret
     de4:	8082                	ret

0000000000000de6 <exec>:
.global exec
exec:
 li a7, SYS_exec
     de6:	489d                	li	a7,7
 ecall
     de8:	00000073          	ecall
 ret
     dec:	8082                	ret

0000000000000dee <open>:
.global open
open:
 li a7, SYS_open
     dee:	48bd                	li	a7,15
 ecall
     df0:	00000073          	ecall
 ret
     df4:	8082                	ret

0000000000000df6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     df6:	48c5                	li	a7,17
 ecall
     df8:	00000073          	ecall
 ret
     dfc:	8082                	ret

0000000000000dfe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     dfe:	48c9                	li	a7,18
 ecall
     e00:	00000073          	ecall
 ret
     e04:	8082                	ret

0000000000000e06 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e06:	48a1                	li	a7,8
 ecall
     e08:	00000073          	ecall
 ret
     e0c:	8082                	ret

0000000000000e0e <link>:
.global link
link:
 li a7, SYS_link
     e0e:	48cd                	li	a7,19
 ecall
     e10:	00000073          	ecall
 ret
     e14:	8082                	ret

0000000000000e16 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e16:	48d1                	li	a7,20
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e1e:	48a5                	li	a7,9
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e26:	48a9                	li	a7,10
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e2e:	48ad                	li	a7,11
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e36:	48b1                	li	a7,12
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e3e:	48b5                	li	a7,13
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e46:	48b9                	li	a7,14
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e4e:	1101                	addi	sp,sp,-32
     e50:	ec06                	sd	ra,24(sp)
     e52:	e822                	sd	s0,16(sp)
     e54:	1000                	addi	s0,sp,32
     e56:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e5a:	4605                	li	a2,1
     e5c:	fef40593          	addi	a1,s0,-17
     e60:	f6fff0ef          	jal	dce <write>
}
     e64:	60e2                	ld	ra,24(sp)
     e66:	6442                	ld	s0,16(sp)
     e68:	6105                	addi	sp,sp,32
     e6a:	8082                	ret

0000000000000e6c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e6c:	7139                	addi	sp,sp,-64
     e6e:	fc06                	sd	ra,56(sp)
     e70:	f822                	sd	s0,48(sp)
     e72:	f426                	sd	s1,40(sp)
     e74:	0080                	addi	s0,sp,64
     e76:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e78:	c299                	beqz	a3,e7e <printint+0x12>
     e7a:	0805c963          	bltz	a1,f0c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e7e:	2581                	sext.w	a1,a1
  neg = 0;
     e80:	4881                	li	a7,0
     e82:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     e86:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e88:	2601                	sext.w	a2,a2
     e8a:	00000517          	auipc	a0,0x0
     e8e:	66e50513          	addi	a0,a0,1646 # 14f8 <digits>
     e92:	883a                	mv	a6,a4
     e94:	2705                	addiw	a4,a4,1
     e96:	02c5f7bb          	remuw	a5,a1,a2
     e9a:	1782                	slli	a5,a5,0x20
     e9c:	9381                	srli	a5,a5,0x20
     e9e:	97aa                	add	a5,a5,a0
     ea0:	0007c783          	lbu	a5,0(a5)
     ea4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ea8:	0005879b          	sext.w	a5,a1
     eac:	02c5d5bb          	divuw	a1,a1,a2
     eb0:	0685                	addi	a3,a3,1
     eb2:	fec7f0e3          	bgeu	a5,a2,e92 <printint+0x26>
  if(neg)
     eb6:	00088c63          	beqz	a7,ece <printint+0x62>
    buf[i++] = '-';
     eba:	fd070793          	addi	a5,a4,-48
     ebe:	00878733          	add	a4,a5,s0
     ec2:	02d00793          	li	a5,45
     ec6:	fef70823          	sb	a5,-16(a4)
     eca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     ece:	02e05a63          	blez	a4,f02 <printint+0x96>
     ed2:	f04a                	sd	s2,32(sp)
     ed4:	ec4e                	sd	s3,24(sp)
     ed6:	fc040793          	addi	a5,s0,-64
     eda:	00e78933          	add	s2,a5,a4
     ede:	fff78993          	addi	s3,a5,-1
     ee2:	99ba                	add	s3,s3,a4
     ee4:	377d                	addiw	a4,a4,-1
     ee6:	1702                	slli	a4,a4,0x20
     ee8:	9301                	srli	a4,a4,0x20
     eea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     eee:	fff94583          	lbu	a1,-1(s2)
     ef2:	8526                	mv	a0,s1
     ef4:	f5bff0ef          	jal	e4e <putc>
  while(--i >= 0)
     ef8:	197d                	addi	s2,s2,-1
     efa:	ff391ae3          	bne	s2,s3,eee <printint+0x82>
     efe:	7902                	ld	s2,32(sp)
     f00:	69e2                	ld	s3,24(sp)
}
     f02:	70e2                	ld	ra,56(sp)
     f04:	7442                	ld	s0,48(sp)
     f06:	74a2                	ld	s1,40(sp)
     f08:	6121                	addi	sp,sp,64
     f0a:	8082                	ret
    x = -xx;
     f0c:	40b005bb          	negw	a1,a1
    neg = 1;
     f10:	4885                	li	a7,1
    x = -xx;
     f12:	bf85                	j	e82 <printint+0x16>

0000000000000f14 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f14:	711d                	addi	sp,sp,-96
     f16:	ec86                	sd	ra,88(sp)
     f18:	e8a2                	sd	s0,80(sp)
     f1a:	e0ca                	sd	s2,64(sp)
     f1c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f1e:	0005c903          	lbu	s2,0(a1)
     f22:	26090863          	beqz	s2,1192 <vprintf+0x27e>
     f26:	e4a6                	sd	s1,72(sp)
     f28:	fc4e                	sd	s3,56(sp)
     f2a:	f852                	sd	s4,48(sp)
     f2c:	f456                	sd	s5,40(sp)
     f2e:	f05a                	sd	s6,32(sp)
     f30:	ec5e                	sd	s7,24(sp)
     f32:	e862                	sd	s8,16(sp)
     f34:	e466                	sd	s9,8(sp)
     f36:	8b2a                	mv	s6,a0
     f38:	8a2e                	mv	s4,a1
     f3a:	8bb2                	mv	s7,a2
  state = 0;
     f3c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     f3e:	4481                	li	s1,0
     f40:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     f42:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     f46:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     f4a:	06c00c93          	li	s9,108
     f4e:	a005                	j	f6e <vprintf+0x5a>
        putc(fd, c0);
     f50:	85ca                	mv	a1,s2
     f52:	855a                	mv	a0,s6
     f54:	efbff0ef          	jal	e4e <putc>
     f58:	a019                	j	f5e <vprintf+0x4a>
    } else if(state == '%'){
     f5a:	03598263          	beq	s3,s5,f7e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     f5e:	2485                	addiw	s1,s1,1
     f60:	8726                	mv	a4,s1
     f62:	009a07b3          	add	a5,s4,s1
     f66:	0007c903          	lbu	s2,0(a5)
     f6a:	20090c63          	beqz	s2,1182 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     f6e:	0009079b          	sext.w	a5,s2
    if(state == 0){
     f72:	fe0994e3          	bnez	s3,f5a <vprintf+0x46>
      if(c0 == '%'){
     f76:	fd579de3          	bne	a5,s5,f50 <vprintf+0x3c>
        state = '%';
     f7a:	89be                	mv	s3,a5
     f7c:	b7cd                	j	f5e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     f7e:	00ea06b3          	add	a3,s4,a4
     f82:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     f86:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     f88:	c681                	beqz	a3,f90 <vprintf+0x7c>
     f8a:	9752                	add	a4,a4,s4
     f8c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     f90:	03878f63          	beq	a5,s8,fce <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     f94:	05978963          	beq	a5,s9,fe6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     f98:	07500713          	li	a4,117
     f9c:	0ee78363          	beq	a5,a4,1082 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     fa0:	07800713          	li	a4,120
     fa4:	12e78563          	beq	a5,a4,10ce <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     fa8:	07000713          	li	a4,112
     fac:	14e78a63          	beq	a5,a4,1100 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     fb0:	07300713          	li	a4,115
     fb4:	18e78a63          	beq	a5,a4,1148 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     fb8:	02500713          	li	a4,37
     fbc:	04e79563          	bne	a5,a4,1006 <vprintf+0xf2>
        putc(fd, '%');
     fc0:	02500593          	li	a1,37
     fc4:	855a                	mv	a0,s6
     fc6:	e89ff0ef          	jal	e4e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     fca:	4981                	li	s3,0
     fcc:	bf49                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     fce:	008b8913          	addi	s2,s7,8
     fd2:	4685                	li	a3,1
     fd4:	4629                	li	a2,10
     fd6:	000ba583          	lw	a1,0(s7)
     fda:	855a                	mv	a0,s6
     fdc:	e91ff0ef          	jal	e6c <printint>
     fe0:	8bca                	mv	s7,s2
      state = 0;
     fe2:	4981                	li	s3,0
     fe4:	bfad                	j	f5e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     fe6:	06400793          	li	a5,100
     fea:	02f68963          	beq	a3,a5,101c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     fee:	06c00793          	li	a5,108
     ff2:	04f68263          	beq	a3,a5,1036 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     ff6:	07500793          	li	a5,117
     ffa:	0af68063          	beq	a3,a5,109a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     ffe:	07800793          	li	a5,120
    1002:	0ef68263          	beq	a3,a5,10e6 <vprintf+0x1d2>
        putc(fd, '%');
    1006:	02500593          	li	a1,37
    100a:	855a                	mv	a0,s6
    100c:	e43ff0ef          	jal	e4e <putc>
        putc(fd, c0);
    1010:	85ca                	mv	a1,s2
    1012:	855a                	mv	a0,s6
    1014:	e3bff0ef          	jal	e4e <putc>
      state = 0;
    1018:	4981                	li	s3,0
    101a:	b791                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    101c:	008b8913          	addi	s2,s7,8
    1020:	4685                	li	a3,1
    1022:	4629                	li	a2,10
    1024:	000ba583          	lw	a1,0(s7)
    1028:	855a                	mv	a0,s6
    102a:	e43ff0ef          	jal	e6c <printint>
        i += 1;
    102e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1030:	8bca                	mv	s7,s2
      state = 0;
    1032:	4981                	li	s3,0
        i += 1;
    1034:	b72d                	j	f5e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1036:	06400793          	li	a5,100
    103a:	02f60763          	beq	a2,a5,1068 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    103e:	07500793          	li	a5,117
    1042:	06f60963          	beq	a2,a5,10b4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1046:	07800793          	li	a5,120
    104a:	faf61ee3          	bne	a2,a5,1006 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    104e:	008b8913          	addi	s2,s7,8
    1052:	4681                	li	a3,0
    1054:	4641                	li	a2,16
    1056:	000ba583          	lw	a1,0(s7)
    105a:	855a                	mv	a0,s6
    105c:	e11ff0ef          	jal	e6c <printint>
        i += 2;
    1060:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1062:	8bca                	mv	s7,s2
      state = 0;
    1064:	4981                	li	s3,0
        i += 2;
    1066:	bde5                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1068:	008b8913          	addi	s2,s7,8
    106c:	4685                	li	a3,1
    106e:	4629                	li	a2,10
    1070:	000ba583          	lw	a1,0(s7)
    1074:	855a                	mv	a0,s6
    1076:	df7ff0ef          	jal	e6c <printint>
        i += 2;
    107a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    107c:	8bca                	mv	s7,s2
      state = 0;
    107e:	4981                	li	s3,0
        i += 2;
    1080:	bdf9                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1082:	008b8913          	addi	s2,s7,8
    1086:	4681                	li	a3,0
    1088:	4629                	li	a2,10
    108a:	000ba583          	lw	a1,0(s7)
    108e:	855a                	mv	a0,s6
    1090:	dddff0ef          	jal	e6c <printint>
    1094:	8bca                	mv	s7,s2
      state = 0;
    1096:	4981                	li	s3,0
    1098:	b5d9                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    109a:	008b8913          	addi	s2,s7,8
    109e:	4681                	li	a3,0
    10a0:	4629                	li	a2,10
    10a2:	000ba583          	lw	a1,0(s7)
    10a6:	855a                	mv	a0,s6
    10a8:	dc5ff0ef          	jal	e6c <printint>
        i += 1;
    10ac:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    10ae:	8bca                	mv	s7,s2
      state = 0;
    10b0:	4981                	li	s3,0
        i += 1;
    10b2:	b575                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10b4:	008b8913          	addi	s2,s7,8
    10b8:	4681                	li	a3,0
    10ba:	4629                	li	a2,10
    10bc:	000ba583          	lw	a1,0(s7)
    10c0:	855a                	mv	a0,s6
    10c2:	dabff0ef          	jal	e6c <printint>
        i += 2;
    10c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    10c8:	8bca                	mv	s7,s2
      state = 0;
    10ca:	4981                	li	s3,0
        i += 2;
    10cc:	bd49                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    10ce:	008b8913          	addi	s2,s7,8
    10d2:	4681                	li	a3,0
    10d4:	4641                	li	a2,16
    10d6:	000ba583          	lw	a1,0(s7)
    10da:	855a                	mv	a0,s6
    10dc:	d91ff0ef          	jal	e6c <printint>
    10e0:	8bca                	mv	s7,s2
      state = 0;
    10e2:	4981                	li	s3,0
    10e4:	bdad                	j	f5e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10e6:	008b8913          	addi	s2,s7,8
    10ea:	4681                	li	a3,0
    10ec:	4641                	li	a2,16
    10ee:	000ba583          	lw	a1,0(s7)
    10f2:	855a                	mv	a0,s6
    10f4:	d79ff0ef          	jal	e6c <printint>
        i += 1;
    10f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    10fa:	8bca                	mv	s7,s2
      state = 0;
    10fc:	4981                	li	s3,0
        i += 1;
    10fe:	b585                	j	f5e <vprintf+0x4a>
    1100:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1102:	008b8d13          	addi	s10,s7,8
    1106:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    110a:	03000593          	li	a1,48
    110e:	855a                	mv	a0,s6
    1110:	d3fff0ef          	jal	e4e <putc>
  putc(fd, 'x');
    1114:	07800593          	li	a1,120
    1118:	855a                	mv	a0,s6
    111a:	d35ff0ef          	jal	e4e <putc>
    111e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1120:	00000b97          	auipc	s7,0x0
    1124:	3d8b8b93          	addi	s7,s7,984 # 14f8 <digits>
    1128:	03c9d793          	srli	a5,s3,0x3c
    112c:	97de                	add	a5,a5,s7
    112e:	0007c583          	lbu	a1,0(a5)
    1132:	855a                	mv	a0,s6
    1134:	d1bff0ef          	jal	e4e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1138:	0992                	slli	s3,s3,0x4
    113a:	397d                	addiw	s2,s2,-1
    113c:	fe0916e3          	bnez	s2,1128 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1140:	8bea                	mv	s7,s10
      state = 0;
    1142:	4981                	li	s3,0
    1144:	6d02                	ld	s10,0(sp)
    1146:	bd21                	j	f5e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1148:	008b8993          	addi	s3,s7,8
    114c:	000bb903          	ld	s2,0(s7)
    1150:	00090f63          	beqz	s2,116e <vprintf+0x25a>
        for(; *s; s++)
    1154:	00094583          	lbu	a1,0(s2)
    1158:	c195                	beqz	a1,117c <vprintf+0x268>
          putc(fd, *s);
    115a:	855a                	mv	a0,s6
    115c:	cf3ff0ef          	jal	e4e <putc>
        for(; *s; s++)
    1160:	0905                	addi	s2,s2,1
    1162:	00094583          	lbu	a1,0(s2)
    1166:	f9f5                	bnez	a1,115a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1168:	8bce                	mv	s7,s3
      state = 0;
    116a:	4981                	li	s3,0
    116c:	bbcd                	j	f5e <vprintf+0x4a>
          s = "(null)";
    116e:	00000917          	auipc	s2,0x0
    1172:	35290913          	addi	s2,s2,850 # 14c0 <malloc+0x246>
        for(; *s; s++)
    1176:	02800593          	li	a1,40
    117a:	b7c5                	j	115a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    117c:	8bce                	mv	s7,s3
      state = 0;
    117e:	4981                	li	s3,0
    1180:	bbf9                	j	f5e <vprintf+0x4a>
    1182:	64a6                	ld	s1,72(sp)
    1184:	79e2                	ld	s3,56(sp)
    1186:	7a42                	ld	s4,48(sp)
    1188:	7aa2                	ld	s5,40(sp)
    118a:	7b02                	ld	s6,32(sp)
    118c:	6be2                	ld	s7,24(sp)
    118e:	6c42                	ld	s8,16(sp)
    1190:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1192:	60e6                	ld	ra,88(sp)
    1194:	6446                	ld	s0,80(sp)
    1196:	6906                	ld	s2,64(sp)
    1198:	6125                	addi	sp,sp,96
    119a:	8082                	ret

000000000000119c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    119c:	715d                	addi	sp,sp,-80
    119e:	ec06                	sd	ra,24(sp)
    11a0:	e822                	sd	s0,16(sp)
    11a2:	1000                	addi	s0,sp,32
    11a4:	e010                	sd	a2,0(s0)
    11a6:	e414                	sd	a3,8(s0)
    11a8:	e818                	sd	a4,16(s0)
    11aa:	ec1c                	sd	a5,24(s0)
    11ac:	03043023          	sd	a6,32(s0)
    11b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11b8:	8622                	mv	a2,s0
    11ba:	d5bff0ef          	jal	f14 <vprintf>
}
    11be:	60e2                	ld	ra,24(sp)
    11c0:	6442                	ld	s0,16(sp)
    11c2:	6161                	addi	sp,sp,80
    11c4:	8082                	ret

00000000000011c6 <printf>:

void
printf(const char *fmt, ...)
{
    11c6:	711d                	addi	sp,sp,-96
    11c8:	ec06                	sd	ra,24(sp)
    11ca:	e822                	sd	s0,16(sp)
    11cc:	1000                	addi	s0,sp,32
    11ce:	e40c                	sd	a1,8(s0)
    11d0:	e810                	sd	a2,16(s0)
    11d2:	ec14                	sd	a3,24(s0)
    11d4:	f018                	sd	a4,32(s0)
    11d6:	f41c                	sd	a5,40(s0)
    11d8:	03043823          	sd	a6,48(s0)
    11dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11e0:	00840613          	addi	a2,s0,8
    11e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11e8:	85aa                	mv	a1,a0
    11ea:	4505                	li	a0,1
    11ec:	d29ff0ef          	jal	f14 <vprintf>
}
    11f0:	60e2                	ld	ra,24(sp)
    11f2:	6442                	ld	s0,16(sp)
    11f4:	6125                	addi	sp,sp,96
    11f6:	8082                	ret

00000000000011f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11f8:	1141                	addi	sp,sp,-16
    11fa:	e422                	sd	s0,8(sp)
    11fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1202:	00001797          	auipc	a5,0x1
    1206:	e0e7b783          	ld	a5,-498(a5) # 2010 <freep>
    120a:	a02d                	j	1234 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    120c:	4618                	lw	a4,8(a2)
    120e:	9f2d                	addw	a4,a4,a1
    1210:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1214:	6398                	ld	a4,0(a5)
    1216:	6310                	ld	a2,0(a4)
    1218:	a83d                	j	1256 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    121a:	ff852703          	lw	a4,-8(a0)
    121e:	9f31                	addw	a4,a4,a2
    1220:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1222:	ff053683          	ld	a3,-16(a0)
    1226:	a091                	j	126a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1228:	6398                	ld	a4,0(a5)
    122a:	00e7e463          	bltu	a5,a4,1232 <free+0x3a>
    122e:	00e6ea63          	bltu	a3,a4,1242 <free+0x4a>
{
    1232:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1234:	fed7fae3          	bgeu	a5,a3,1228 <free+0x30>
    1238:	6398                	ld	a4,0(a5)
    123a:	00e6e463          	bltu	a3,a4,1242 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    123e:	fee7eae3          	bltu	a5,a4,1232 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1242:	ff852583          	lw	a1,-8(a0)
    1246:	6390                	ld	a2,0(a5)
    1248:	02059813          	slli	a6,a1,0x20
    124c:	01c85713          	srli	a4,a6,0x1c
    1250:	9736                	add	a4,a4,a3
    1252:	fae60de3          	beq	a2,a4,120c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1256:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    125a:	4790                	lw	a2,8(a5)
    125c:	02061593          	slli	a1,a2,0x20
    1260:	01c5d713          	srli	a4,a1,0x1c
    1264:	973e                	add	a4,a4,a5
    1266:	fae68ae3          	beq	a3,a4,121a <free+0x22>
    p->s.ptr = bp->s.ptr;
    126a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    126c:	00001717          	auipc	a4,0x1
    1270:	daf73223          	sd	a5,-604(a4) # 2010 <freep>
}
    1274:	6422                	ld	s0,8(sp)
    1276:	0141                	addi	sp,sp,16
    1278:	8082                	ret

000000000000127a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    127a:	7139                	addi	sp,sp,-64
    127c:	fc06                	sd	ra,56(sp)
    127e:	f822                	sd	s0,48(sp)
    1280:	f426                	sd	s1,40(sp)
    1282:	ec4e                	sd	s3,24(sp)
    1284:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1286:	02051493          	slli	s1,a0,0x20
    128a:	9081                	srli	s1,s1,0x20
    128c:	04bd                	addi	s1,s1,15
    128e:	8091                	srli	s1,s1,0x4
    1290:	0014899b          	addiw	s3,s1,1
    1294:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1296:	00001517          	auipc	a0,0x1
    129a:	d7a53503          	ld	a0,-646(a0) # 2010 <freep>
    129e:	c915                	beqz	a0,12d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12a2:	4798                	lw	a4,8(a5)
    12a4:	08977a63          	bgeu	a4,s1,1338 <malloc+0xbe>
    12a8:	f04a                	sd	s2,32(sp)
    12aa:	e852                	sd	s4,16(sp)
    12ac:	e456                	sd	s5,8(sp)
    12ae:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    12b0:	8a4e                	mv	s4,s3
    12b2:	0009871b          	sext.w	a4,s3
    12b6:	6685                	lui	a3,0x1
    12b8:	00d77363          	bgeu	a4,a3,12be <malloc+0x44>
    12bc:	6a05                	lui	s4,0x1
    12be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12c6:	00001917          	auipc	s2,0x1
    12ca:	d4a90913          	addi	s2,s2,-694 # 2010 <freep>
  if(p == (char*)-1)
    12ce:	5afd                	li	s5,-1
    12d0:	a081                	j	1310 <malloc+0x96>
    12d2:	f04a                	sd	s2,32(sp)
    12d4:	e852                	sd	s4,16(sp)
    12d6:	e456                	sd	s5,8(sp)
    12d8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12da:	00001797          	auipc	a5,0x1
    12de:	dae78793          	addi	a5,a5,-594 # 2088 <base>
    12e2:	00001717          	auipc	a4,0x1
    12e6:	d2f73723          	sd	a5,-722(a4) # 2010 <freep>
    12ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12ec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12f0:	b7c1                	j	12b0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    12f2:	6398                	ld	a4,0(a5)
    12f4:	e118                	sd	a4,0(a0)
    12f6:	a8a9                	j	1350 <malloc+0xd6>
  hp->s.size = nu;
    12f8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12fc:	0541                	addi	a0,a0,16
    12fe:	efbff0ef          	jal	11f8 <free>
  return freep;
    1302:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1306:	c12d                	beqz	a0,1368 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1308:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    130a:	4798                	lw	a4,8(a5)
    130c:	02977263          	bgeu	a4,s1,1330 <malloc+0xb6>
    if(p == freep)
    1310:	00093703          	ld	a4,0(s2)
    1314:	853e                	mv	a0,a5
    1316:	fef719e3          	bne	a4,a5,1308 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    131a:	8552                	mv	a0,s4
    131c:	b1bff0ef          	jal	e36 <sbrk>
  if(p == (char*)-1)
    1320:	fd551ce3          	bne	a0,s5,12f8 <malloc+0x7e>
        return 0;
    1324:	4501                	li	a0,0
    1326:	7902                	ld	s2,32(sp)
    1328:	6a42                	ld	s4,16(sp)
    132a:	6aa2                	ld	s5,8(sp)
    132c:	6b02                	ld	s6,0(sp)
    132e:	a03d                	j	135c <malloc+0xe2>
    1330:	7902                	ld	s2,32(sp)
    1332:	6a42                	ld	s4,16(sp)
    1334:	6aa2                	ld	s5,8(sp)
    1336:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1338:	fae48de3          	beq	s1,a4,12f2 <malloc+0x78>
        p->s.size -= nunits;
    133c:	4137073b          	subw	a4,a4,s3
    1340:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1342:	02071693          	slli	a3,a4,0x20
    1346:	01c6d713          	srli	a4,a3,0x1c
    134a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    134c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1350:	00001717          	auipc	a4,0x1
    1354:	cca73023          	sd	a0,-832(a4) # 2010 <freep>
      return (void*)(p + 1);
    1358:	01078513          	addi	a0,a5,16
  }
}
    135c:	70e2                	ld	ra,56(sp)
    135e:	7442                	ld	s0,48(sp)
    1360:	74a2                	ld	s1,40(sp)
    1362:	69e2                	ld	s3,24(sp)
    1364:	6121                	addi	sp,sp,64
    1366:	8082                	ret
    1368:	7902                	ld	s2,32(sp)
    136a:	6a42                	ld	s4,16(sp)
    136c:	6aa2                	ld	s5,8(sp)
    136e:	6b02                	ld	s6,0(sp)
    1370:	b7f5                	j	135c <malloc+0xe2>
