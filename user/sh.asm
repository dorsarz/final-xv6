
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$dorsa-parnian ", 14);
      10:	4639                	li	a2,14
      12:	00001597          	auipc	a1,0x1
      16:	2fe58593          	addi	a1,a1,766 # 1310 <malloc+0xfa>
      1a:	4509                	li	a0,2
      1c:	537000ef          	jal	d52 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	327000ef          	jal	b4c <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	365000ef          	jal	b92 <gets>
  if(buf[0] == 0) // EOF
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
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	2cc58593          	addi	a1,a1,716 # 1320 <malloc+0x10a>
      5c:	4509                	li	a0,2
      5e:	0da010ef          	jal	1138 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	4cf000ef          	jal	d32 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	4bb000ef          	jal	d2a <fork>
  if(pid == -1)
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
      86:	2ae50513          	addi	a0,a0,686 # 1330 <malloc+0x11a>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	711d                	addi	sp,sp,-96
      90:	ec86                	sd	ra,88(sp)
      92:	e8a2                	sd	s0,80(sp)
      94:	1080                	addi	s0,sp,96
  if(cmd == 0)
      96:	c505                	beqz	a0,be <runcmd+0x30>
      98:	e4a6                	sd	s1,72(sp)
      9a:	e0ca                	sd	s2,64(sp)
      9c:	fc4e                	sd	s3,56(sp)
      9e:	84aa                	mv	s1,a0
  switch(cmd->type){
      a0:	4118                	lw	a4,0(a0)
      a2:	4795                	li	a5,5
      a4:	02e7e763          	bltu	a5,a4,d2 <runcmd+0x44>
      a8:	00056783          	lwu	a5,0(a0)
      ac:	078a                	slli	a5,a5,0x2
      ae:	00001717          	auipc	a4,0x1
      b2:	3ca70713          	addi	a4,a4,970 # 1478 <malloc+0x262>
      b6:	97ba                	add	a5,a5,a4
      b8:	439c                	lw	a5,0(a5)
      ba:	97ba                	add	a5,a5,a4
      bc:	8782                	jr	a5
      be:	e4a6                	sd	s1,72(sp)
      c0:	e0ca                	sd	s2,64(sp)
      c2:	fc4e                	sd	s3,56(sp)
      c4:	f852                	sd	s4,48(sp)
      c6:	f456                	sd	s5,40(sp)
      c8:	f05a                	sd	s6,32(sp)
      ca:	ec5e                	sd	s7,24(sp)
    exit(1);
      cc:	4505                	li	a0,1
      ce:	465000ef          	jal	d32 <exit>
      d2:	f852                	sd	s4,48(sp)
      d4:	f456                	sd	s5,40(sp)
      d6:	f05a                	sd	s6,32(sp)
      d8:	ec5e                	sd	s7,24(sp)
    panic("runcmd");
      da:	00001517          	auipc	a0,0x1
      de:	25e50513          	addi	a0,a0,606 # 1338 <malloc+0x122>
      e2:	f69ff0ef          	jal	4a <panic>
        if(ecmd->argv[0] == 0)
      e6:	00853903          	ld	s2,8(a0)
      ea:	06090163          	beqz	s2,14c <runcmd+0xbe>
        if (ecmd->argv[0] && strcmp(ecmd->argv[0], "!") == 0)
      ee:	00001597          	auipc	a1,0x1
      f2:	25258593          	addi	a1,a1,594 # 1340 <malloc+0x12a>
      f6:	854a                	mv	a0,s2
      f8:	1ff000ef          	jal	af6 <strcmp>
      fc:	89aa                	mv	s3,a0
      fe:	e945                	bnez	a0,1ae <runcmd+0x120>
     100:	f852                	sd	s4,48(sp)
     102:	f456                	sd	s5,40(sp)
     104:	f05a                	sd	s6,32(sp)
     106:	ec5e                	sd	s7,24(sp)
            for (int i= 1 ; ecmd->argv[i] !=0 ; i++)
     108:	6888                	ld	a0,16(s1)
     10a:	cd19                	beqz	a0,128 <runcmd+0x9a>
     10c:	01848913          	addi	s2,s1,24
                total_ch +=strlen(ecmd->argv[i]);
     110:	213000ef          	jal	b22 <strlen>
     114:	00a989bb          	addw	s3,s3,a0
            for (int i= 1 ; ecmd->argv[i] !=0 ; i++)
     118:	0921                	addi	s2,s2,8
     11a:	ff893503          	ld	a0,-8(s2)
     11e:	f96d                	bnez	a0,110 <runcmd+0x82>
            if (total_ch > 40)
     120:	02800793          	li	a5,40
     124:	0337cb63          	blt	a5,s3,15a <runcmd+0xcc>
            if(total_ch<= 40)
     128:	04c1                	addi	s1,s1,16
                    if (strcmp(ecmd->argv[i], "os") == 0)
     12a:	00001a17          	auipc	s4,0x1
     12e:	236a0a13          	addi	s4,s4,566 # 1360 <malloc+0x14a>
                        printf("%s", ecmd->argv[i]);
     132:	00001b97          	auipc	s7,0x1
     136:	246b8b93          	addi	s7,s7,582 # 1378 <malloc+0x162>
                        printf("\033[34m%s\033[0m", ecmd->argv[i]);
     13a:	00001b17          	auipc	s6,0x1
     13e:	22eb0b13          	addi	s6,s6,558 # 1368 <malloc+0x152>
                        printf(" ");
     142:	00001a97          	auipc	s5,0x1
     146:	23ea8a93          	addi	s5,s5,574 # 1380 <malloc+0x16a>
     14a:	a815                	j	17e <runcmd+0xf0>
     14c:	f852                	sd	s4,48(sp)
     14e:	f456                	sd	s5,40(sp)
     150:	f05a                	sd	s6,32(sp)
     152:	ec5e                	sd	s7,24(sp)
            exit(1);
     154:	4505                	li	a0,1
     156:	3dd000ef          	jal	d32 <exit>
                printf("long too Message\n");
     15a:	00001517          	auipc	a0,0x1
     15e:	1ee50513          	addi	a0,a0,494 # 1348 <malloc+0x132>
     162:	000010ef          	jal	1162 <printf>
            if(total_ch<= 40)
     166:	a089                	j	1a8 <runcmd+0x11a>
                        printf("%s", ecmd->argv[i]);
     168:	85ca                	mv	a1,s2
     16a:	855e                	mv	a0,s7
     16c:	7f7000ef          	jal	1162 <printf>
                    if (ecmd->argv[i + 1] != 0)
     170:	0089b783          	ld	a5,8(s3)
     174:	c781                	beqz	a5,17c <runcmd+0xee>
                        printf(" ");
     176:	8556                	mv	a0,s5
     178:	7eb000ef          	jal	1162 <printf>
     17c:	04a1                	addi	s1,s1,8
                for (int i = 1; ecmd->argv[i] != 0; i++)
     17e:	89a6                	mv	s3,s1
     180:	0004b903          	ld	s2,0(s1)
     184:	00090c63          	beqz	s2,19c <runcmd+0x10e>
                    if (strcmp(ecmd->argv[i], "os") == 0)
     188:	85d2                	mv	a1,s4
     18a:	854a                	mv	a0,s2
     18c:	16b000ef          	jal	af6 <strcmp>
     190:	fd61                	bnez	a0,168 <runcmd+0xda>
                        printf("\033[34m%s\033[0m", ecmd->argv[i]);
     192:	85ca                	mv	a1,s2
     194:	855a                	mv	a0,s6
     196:	7cd000ef          	jal	1162 <printf>
     19a:	bfd9                	j	170 <runcmd+0xe2>
                printf("\n");
     19c:	00001517          	auipc	a0,0x1
     1a0:	1bc50513          	addi	a0,a0,444 # 1358 <malloc+0x142>
     1a4:	7bf000ef          	jal	1162 <printf>
            exit(0);
     1a8:	4501                	li	a0,0
     1aa:	389000ef          	jal	d32 <exit>
        exec(ecmd->argv[0], ecmd->argv);
     1ae:	00848593          	addi	a1,s1,8
     1b2:	854a                	mv	a0,s2
     1b4:	3b7000ef          	jal	d6a <exec>
        fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     1b8:	6490                	ld	a2,8(s1)
     1ba:	00001597          	auipc	a1,0x1
     1be:	1ce58593          	addi	a1,a1,462 # 1388 <malloc+0x172>
     1c2:	4509                	li	a0,2
     1c4:	775000ef          	jal	1138 <fprintf>
        break;
     1c8:	a239                	j	2d6 <runcmd+0x248>
    close(rcmd->fd);
     1ca:	5148                	lw	a0,36(a0)
     1cc:	38f000ef          	jal	d5a <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     1d0:	508c                	lw	a1,32(s1)
     1d2:	6888                	ld	a0,16(s1)
     1d4:	39f000ef          	jal	d72 <open>
     1d8:	00054963          	bltz	a0,1ea <runcmd+0x15c>
     1dc:	f852                	sd	s4,48(sp)
     1de:	f456                	sd	s5,40(sp)
     1e0:	f05a                	sd	s6,32(sp)
     1e2:	ec5e                	sd	s7,24(sp)
    runcmd(rcmd->cmd);
     1e4:	6488                	ld	a0,8(s1)
     1e6:	ea9ff0ef          	jal	8e <runcmd>
     1ea:	f852                	sd	s4,48(sp)
     1ec:	f456                	sd	s5,40(sp)
     1ee:	f05a                	sd	s6,32(sp)
     1f0:	ec5e                	sd	s7,24(sp)
      fprintf(2, "open %s failed\n", rcmd->file);
     1f2:	6890                	ld	a2,16(s1)
     1f4:	00001597          	auipc	a1,0x1
     1f8:	1a458593          	addi	a1,a1,420 # 1398 <malloc+0x182>
     1fc:	4509                	li	a0,2
     1fe:	73b000ef          	jal	1138 <fprintf>
      exit(1);
     202:	4505                	li	a0,1
     204:	32f000ef          	jal	d32 <exit>
    if(fork1() == 0)
     208:	e61ff0ef          	jal	68 <fork1>
     20c:	e901                	bnez	a0,21c <runcmd+0x18e>
     20e:	f852                	sd	s4,48(sp)
     210:	f456                	sd	s5,40(sp)
     212:	f05a                	sd	s6,32(sp)
     214:	ec5e                	sd	s7,24(sp)
      runcmd(lcmd->left);
     216:	6488                	ld	a0,8(s1)
     218:	e77ff0ef          	jal	8e <runcmd>
     21c:	f852                	sd	s4,48(sp)
     21e:	f456                	sd	s5,40(sp)
     220:	f05a                	sd	s6,32(sp)
     222:	ec5e                	sd	s7,24(sp)
    wait(0);
     224:	4501                	li	a0,0
     226:	315000ef          	jal	d3a <wait>
    runcmd(lcmd->right);
     22a:	6888                	ld	a0,16(s1)
     22c:	e63ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     230:	fa840513          	addi	a0,s0,-88
     234:	30f000ef          	jal	d42 <pipe>
     238:	02054b63          	bltz	a0,26e <runcmd+0x1e0>
    if(fork1() == 0){
     23c:	e2dff0ef          	jal	68 <fork1>
     240:	e129                	bnez	a0,282 <runcmd+0x1f4>
     242:	f852                	sd	s4,48(sp)
     244:	f456                	sd	s5,40(sp)
     246:	f05a                	sd	s6,32(sp)
     248:	ec5e                	sd	s7,24(sp)
      close(1);
     24a:	4505                	li	a0,1
     24c:	30f000ef          	jal	d5a <close>
      dup(p[1]);
     250:	fac42503          	lw	a0,-84(s0)
     254:	357000ef          	jal	daa <dup>
      close(p[0]);
     258:	fa842503          	lw	a0,-88(s0)
     25c:	2ff000ef          	jal	d5a <close>
      close(p[1]);
     260:	fac42503          	lw	a0,-84(s0)
     264:	2f7000ef          	jal	d5a <close>
      runcmd(pcmd->left);
     268:	6488                	ld	a0,8(s1)
     26a:	e25ff0ef          	jal	8e <runcmd>
     26e:	f852                	sd	s4,48(sp)
     270:	f456                	sd	s5,40(sp)
     272:	f05a                	sd	s6,32(sp)
     274:	ec5e                	sd	s7,24(sp)
      panic("pipe");
     276:	00001517          	auipc	a0,0x1
     27a:	13250513          	addi	a0,a0,306 # 13a8 <malloc+0x192>
     27e:	dcdff0ef          	jal	4a <panic>
    if(fork1() == 0){
     282:	de7ff0ef          	jal	68 <fork1>
     286:	e515                	bnez	a0,2b2 <runcmd+0x224>
     288:	f852                	sd	s4,48(sp)
     28a:	f456                	sd	s5,40(sp)
     28c:	f05a                	sd	s6,32(sp)
     28e:	ec5e                	sd	s7,24(sp)
      close(0);
     290:	2cb000ef          	jal	d5a <close>
      dup(p[0]);
     294:	fa842503          	lw	a0,-88(s0)
     298:	313000ef          	jal	daa <dup>
      close(p[0]);
     29c:	fa842503          	lw	a0,-88(s0)
     2a0:	2bb000ef          	jal	d5a <close>
      close(p[1]);
     2a4:	fac42503          	lw	a0,-84(s0)
     2a8:	2b3000ef          	jal	d5a <close>
      runcmd(pcmd->right);
     2ac:	6888                	ld	a0,16(s1)
     2ae:	de1ff0ef          	jal	8e <runcmd>
    close(p[0]);
     2b2:	fa842503          	lw	a0,-88(s0)
     2b6:	2a5000ef          	jal	d5a <close>
    close(p[1]);
     2ba:	fac42503          	lw	a0,-84(s0)
     2be:	29d000ef          	jal	d5a <close>
    wait(0);
     2c2:	4501                	li	a0,0
     2c4:	277000ef          	jal	d3a <wait>
    wait(0);
     2c8:	4501                	li	a0,0
     2ca:	271000ef          	jal	d3a <wait>
    break;
     2ce:	a021                	j	2d6 <runcmd+0x248>
    if(fork1() == 0)
     2d0:	d99ff0ef          	jal	68 <fork1>
     2d4:	c901                	beqz	a0,2e4 <runcmd+0x256>
     2d6:	f852                	sd	s4,48(sp)
     2d8:	f456                	sd	s5,40(sp)
     2da:	f05a                	sd	s6,32(sp)
     2dc:	ec5e                	sd	s7,24(sp)
  exit(0);
     2de:	4501                	li	a0,0
     2e0:	253000ef          	jal	d32 <exit>
     2e4:	f852                	sd	s4,48(sp)
     2e6:	f456                	sd	s5,40(sp)
     2e8:	f05a                	sd	s6,32(sp)
     2ea:	ec5e                	sd	s7,24(sp)
      runcmd(bcmd->cmd);
     2ec:	6488                	ld	a0,8(s1)
     2ee:	da1ff0ef          	jal	8e <runcmd>

00000000000002f2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     2f2:	1101                	addi	sp,sp,-32
     2f4:	ec06                	sd	ra,24(sp)
     2f6:	e822                	sd	s0,16(sp)
     2f8:	e426                	sd	s1,8(sp)
     2fa:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2fc:	6509                	lui	a0,0x2
     2fe:	0521                	addi	a0,a0,8 # 2008 <whitespace>
     300:	717000ef          	jal	1216 <malloc>
     304:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     306:	6609                	lui	a2,0x2
     308:	0621                	addi	a2,a2,8 # 2008 <whitespace>
     30a:	4581                	li	a1,0
     30c:	041000ef          	jal	b4c <memset>
  cmd->type = EXEC;
     310:	4785                	li	a5,1
     312:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     314:	8526                	mv	a0,s1
     316:	60e2                	ld	ra,24(sp)
     318:	6442                	ld	s0,16(sp)
     31a:	64a2                	ld	s1,8(sp)
     31c:	6105                	addi	sp,sp,32
     31e:	8082                	ret

0000000000000320 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     320:	7139                	addi	sp,sp,-64
     322:	fc06                	sd	ra,56(sp)
     324:	f822                	sd	s0,48(sp)
     326:	f426                	sd	s1,40(sp)
     328:	f04a                	sd	s2,32(sp)
     32a:	ec4e                	sd	s3,24(sp)
     32c:	e852                	sd	s4,16(sp)
     32e:	e456                	sd	s5,8(sp)
     330:	e05a                	sd	s6,0(sp)
     332:	0080                	addi	s0,sp,64
     334:	8b2a                	mv	s6,a0
     336:	8aae                	mv	s5,a1
     338:	8a32                	mv	s4,a2
     33a:	89b6                	mv	s3,a3
     33c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     33e:	02800513          	li	a0,40
     342:	6d5000ef          	jal	1216 <malloc>
     346:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     348:	02800613          	li	a2,40
     34c:	4581                	li	a1,0
     34e:	7fe000ef          	jal	b4c <memset>
  cmd->type = REDIR;
     352:	4789                	li	a5,2
     354:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     356:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     35a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     35e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     362:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     366:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     36a:	8526                	mv	a0,s1
     36c:	70e2                	ld	ra,56(sp)
     36e:	7442                	ld	s0,48(sp)
     370:	74a2                	ld	s1,40(sp)
     372:	7902                	ld	s2,32(sp)
     374:	69e2                	ld	s3,24(sp)
     376:	6a42                	ld	s4,16(sp)
     378:	6aa2                	ld	s5,8(sp)
     37a:	6b02                	ld	s6,0(sp)
     37c:	6121                	addi	sp,sp,64
     37e:	8082                	ret

0000000000000380 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     380:	7179                	addi	sp,sp,-48
     382:	f406                	sd	ra,40(sp)
     384:	f022                	sd	s0,32(sp)
     386:	ec26                	sd	s1,24(sp)
     388:	e84a                	sd	s2,16(sp)
     38a:	e44e                	sd	s3,8(sp)
     38c:	1800                	addi	s0,sp,48
     38e:	89aa                	mv	s3,a0
     390:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     392:	4561                	li	a0,24
     394:	683000ef          	jal	1216 <malloc>
     398:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     39a:	4661                	li	a2,24
     39c:	4581                	li	a1,0
     39e:	7ae000ef          	jal	b4c <memset>
  cmd->type = PIPE;
     3a2:	478d                	li	a5,3
     3a4:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     3a6:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     3aa:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     3ae:	8526                	mv	a0,s1
     3b0:	70a2                	ld	ra,40(sp)
     3b2:	7402                	ld	s0,32(sp)
     3b4:	64e2                	ld	s1,24(sp)
     3b6:	6942                	ld	s2,16(sp)
     3b8:	69a2                	ld	s3,8(sp)
     3ba:	6145                	addi	sp,sp,48
     3bc:	8082                	ret

00000000000003be <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     3be:	7179                	addi	sp,sp,-48
     3c0:	f406                	sd	ra,40(sp)
     3c2:	f022                	sd	s0,32(sp)
     3c4:	ec26                	sd	s1,24(sp)
     3c6:	e84a                	sd	s2,16(sp)
     3c8:	e44e                	sd	s3,8(sp)
     3ca:	1800                	addi	s0,sp,48
     3cc:	89aa                	mv	s3,a0
     3ce:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d0:	4561                	li	a0,24
     3d2:	645000ef          	jal	1216 <malloc>
     3d6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3d8:	4661                	li	a2,24
     3da:	4581                	li	a1,0
     3dc:	770000ef          	jal	b4c <memset>
  cmd->type = LIST;
     3e0:	4791                	li	a5,4
     3e2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     3e4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     3e8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     3ec:	8526                	mv	a0,s1
     3ee:	70a2                	ld	ra,40(sp)
     3f0:	7402                	ld	s0,32(sp)
     3f2:	64e2                	ld	s1,24(sp)
     3f4:	6942                	ld	s2,16(sp)
     3f6:	69a2                	ld	s3,8(sp)
     3f8:	6145                	addi	sp,sp,48
     3fa:	8082                	ret

00000000000003fc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3fc:	1101                	addi	sp,sp,-32
     3fe:	ec06                	sd	ra,24(sp)
     400:	e822                	sd	s0,16(sp)
     402:	e426                	sd	s1,8(sp)
     404:	e04a                	sd	s2,0(sp)
     406:	1000                	addi	s0,sp,32
     408:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     40a:	4541                	li	a0,16
     40c:	60b000ef          	jal	1216 <malloc>
     410:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     412:	4641                	li	a2,16
     414:	4581                	li	a1,0
     416:	736000ef          	jal	b4c <memset>
  cmd->type = BACK;
     41a:	4795                	li	a5,5
     41c:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     41e:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     422:	8526                	mv	a0,s1
     424:	60e2                	ld	ra,24(sp)
     426:	6442                	ld	s0,16(sp)
     428:	64a2                	ld	s1,8(sp)
     42a:	6902                	ld	s2,0(sp)
     42c:	6105                	addi	sp,sp,32
     42e:	8082                	ret

0000000000000430 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     430:	7139                	addi	sp,sp,-64
     432:	fc06                	sd	ra,56(sp)
     434:	f822                	sd	s0,48(sp)
     436:	f426                	sd	s1,40(sp)
     438:	f04a                	sd	s2,32(sp)
     43a:	ec4e                	sd	s3,24(sp)
     43c:	e852                	sd	s4,16(sp)
     43e:	e456                	sd	s5,8(sp)
     440:	e05a                	sd	s6,0(sp)
     442:	0080                	addi	s0,sp,64
     444:	8a2a                	mv	s4,a0
     446:	892e                	mv	s2,a1
     448:	8ab2                	mv	s5,a2
     44a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     44c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     44e:	00002997          	auipc	s3,0x2
     452:	bba98993          	addi	s3,s3,-1094 # 2008 <whitespace>
     456:	00b4fc63          	bgeu	s1,a1,46e <gettoken+0x3e>
     45a:	0004c583          	lbu	a1,0(s1)
     45e:	854e                	mv	a0,s3
     460:	70e000ef          	jal	b6e <strchr>
     464:	c509                	beqz	a0,46e <gettoken+0x3e>
    s++;
     466:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     468:	fe9919e3          	bne	s2,s1,45a <gettoken+0x2a>
     46c:	84ca                	mv	s1,s2
  if(q)
     46e:	000a8463          	beqz	s5,476 <gettoken+0x46>
    *q = s;
     472:	009ab023          	sd	s1,0(s5)
  ret = *s;
     476:	0004c783          	lbu	a5,0(s1)
     47a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     47e:	03c00713          	li	a4,60
     482:	06f76463          	bltu	a4,a5,4ea <gettoken+0xba>
     486:	03a00713          	li	a4,58
     48a:	00f76e63          	bltu	a4,a5,4a6 <gettoken+0x76>
     48e:	cf89                	beqz	a5,4a8 <gettoken+0x78>
     490:	02600713          	li	a4,38
     494:	00e78963          	beq	a5,a4,4a6 <gettoken+0x76>
     498:	fd87879b          	addiw	a5,a5,-40
     49c:	0ff7f793          	zext.b	a5,a5
     4a0:	4705                	li	a4,1
     4a2:	06f76b63          	bltu	a4,a5,518 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     4a6:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4a8:	000b0463          	beqz	s6,4b0 <gettoken+0x80>
    *eq = s;
     4ac:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     4b0:	00002997          	auipc	s3,0x2
     4b4:	b5898993          	addi	s3,s3,-1192 # 2008 <whitespace>
     4b8:	0124fc63          	bgeu	s1,s2,4d0 <gettoken+0xa0>
     4bc:	0004c583          	lbu	a1,0(s1)
     4c0:	854e                	mv	a0,s3
     4c2:	6ac000ef          	jal	b6e <strchr>
     4c6:	c509                	beqz	a0,4d0 <gettoken+0xa0>
    s++;
     4c8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     4ca:	fe9919e3          	bne	s2,s1,4bc <gettoken+0x8c>
     4ce:	84ca                	mv	s1,s2
  *ps = s;
     4d0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     4d4:	8556                	mv	a0,s5
     4d6:	70e2                	ld	ra,56(sp)
     4d8:	7442                	ld	s0,48(sp)
     4da:	74a2                	ld	s1,40(sp)
     4dc:	7902                	ld	s2,32(sp)
     4de:	69e2                	ld	s3,24(sp)
     4e0:	6a42                	ld	s4,16(sp)
     4e2:	6aa2                	ld	s5,8(sp)
     4e4:	6b02                	ld	s6,0(sp)
     4e6:	6121                	addi	sp,sp,64
     4e8:	8082                	ret
  switch(*s){
     4ea:	03e00713          	li	a4,62
     4ee:	02e79163          	bne	a5,a4,510 <gettoken+0xe0>
    s++;
     4f2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4f6:	0014c703          	lbu	a4,1(s1)
     4fa:	03e00793          	li	a5,62
      s++;
     4fe:	0489                	addi	s1,s1,2
      ret = '+';
     500:	02b00a93          	li	s5,43
    if(*s == '>'){
     504:	faf702e3          	beq	a4,a5,4a8 <gettoken+0x78>
    s++;
     508:	84b6                	mv	s1,a3
  ret = *s;
     50a:	03e00a93          	li	s5,62
     50e:	bf69                	j	4a8 <gettoken+0x78>
  switch(*s){
     510:	07c00713          	li	a4,124
     514:	f8e789e3          	beq	a5,a4,4a6 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     518:	00002997          	auipc	s3,0x2
     51c:	af098993          	addi	s3,s3,-1296 # 2008 <whitespace>
     520:	00002a97          	auipc	s5,0x2
     524:	ae0a8a93          	addi	s5,s5,-1312 # 2000 <symbols>
     528:	0324fd63          	bgeu	s1,s2,562 <gettoken+0x132>
     52c:	0004c583          	lbu	a1,0(s1)
     530:	854e                	mv	a0,s3
     532:	63c000ef          	jal	b6e <strchr>
     536:	e11d                	bnez	a0,55c <gettoken+0x12c>
     538:	0004c583          	lbu	a1,0(s1)
     53c:	8556                	mv	a0,s5
     53e:	630000ef          	jal	b6e <strchr>
     542:	e911                	bnez	a0,556 <gettoken+0x126>
      s++;
     544:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     546:	fe9913e3          	bne	s2,s1,52c <gettoken+0xfc>
  if(eq)
     54a:	84ca                	mv	s1,s2
    ret = 'a';
     54c:	06100a93          	li	s5,97
  if(eq)
     550:	f40b1ee3          	bnez	s6,4ac <gettoken+0x7c>
     554:	bfb5                	j	4d0 <gettoken+0xa0>
    ret = 'a';
     556:	06100a93          	li	s5,97
     55a:	b7b9                	j	4a8 <gettoken+0x78>
     55c:	06100a93          	li	s5,97
     560:	b7a1                	j	4a8 <gettoken+0x78>
     562:	06100a93          	li	s5,97
  if(eq)
     566:	f40b13e3          	bnez	s6,4ac <gettoken+0x7c>
     56a:	b79d                	j	4d0 <gettoken+0xa0>

000000000000056c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     56c:	7139                	addi	sp,sp,-64
     56e:	fc06                	sd	ra,56(sp)
     570:	f822                	sd	s0,48(sp)
     572:	f426                	sd	s1,40(sp)
     574:	f04a                	sd	s2,32(sp)
     576:	ec4e                	sd	s3,24(sp)
     578:	e852                	sd	s4,16(sp)
     57a:	e456                	sd	s5,8(sp)
     57c:	0080                	addi	s0,sp,64
     57e:	8a2a                	mv	s4,a0
     580:	892e                	mv	s2,a1
     582:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     584:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     586:	00002997          	auipc	s3,0x2
     58a:	a8298993          	addi	s3,s3,-1406 # 2008 <whitespace>
     58e:	00b4fc63          	bgeu	s1,a1,5a6 <peek+0x3a>
     592:	0004c583          	lbu	a1,0(s1)
     596:	854e                	mv	a0,s3
     598:	5d6000ef          	jal	b6e <strchr>
     59c:	c509                	beqz	a0,5a6 <peek+0x3a>
    s++;
     59e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     5a0:	fe9919e3          	bne	s2,s1,592 <peek+0x26>
     5a4:	84ca                	mv	s1,s2
  *ps = s;
     5a6:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     5aa:	0004c583          	lbu	a1,0(s1)
     5ae:	4501                	li	a0,0
     5b0:	e991                	bnez	a1,5c4 <peek+0x58>
}
     5b2:	70e2                	ld	ra,56(sp)
     5b4:	7442                	ld	s0,48(sp)
     5b6:	74a2                	ld	s1,40(sp)
     5b8:	7902                	ld	s2,32(sp)
     5ba:	69e2                	ld	s3,24(sp)
     5bc:	6a42                	ld	s4,16(sp)
     5be:	6aa2                	ld	s5,8(sp)
     5c0:	6121                	addi	sp,sp,64
     5c2:	8082                	ret
  return *s && strchr(toks, *s);
     5c4:	8556                	mv	a0,s5
     5c6:	5a8000ef          	jal	b6e <strchr>
     5ca:	00a03533          	snez	a0,a0
     5ce:	b7d5                	j	5b2 <peek+0x46>

00000000000005d0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     5d0:	711d                	addi	sp,sp,-96
     5d2:	ec86                	sd	ra,88(sp)
     5d4:	e8a2                	sd	s0,80(sp)
     5d6:	e4a6                	sd	s1,72(sp)
     5d8:	e0ca                	sd	s2,64(sp)
     5da:	fc4e                	sd	s3,56(sp)
     5dc:	f852                	sd	s4,48(sp)
     5de:	f456                	sd	s5,40(sp)
     5e0:	f05a                	sd	s6,32(sp)
     5e2:	ec5e                	sd	s7,24(sp)
     5e4:	1080                	addi	s0,sp,96
     5e6:	8a2a                	mv	s4,a0
     5e8:	89ae                	mv	s3,a1
     5ea:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5ec:	00001a97          	auipc	s5,0x1
     5f0:	de4a8a93          	addi	s5,s5,-540 # 13d0 <malloc+0x1ba>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5f4:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     5f8:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     5fc:	a00d                	j	61e <parseredirs+0x4e>
      panic("missing file for redirection");
     5fe:	00001517          	auipc	a0,0x1
     602:	db250513          	addi	a0,a0,-590 # 13b0 <malloc+0x19a>
     606:	a45ff0ef          	jal	4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     60a:	4701                	li	a4,0
     60c:	4681                	li	a3,0
     60e:	fa043603          	ld	a2,-96(s0)
     612:	fa843583          	ld	a1,-88(s0)
     616:	8552                	mv	a0,s4
     618:	d09ff0ef          	jal	320 <redircmd>
     61c:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     61e:	8656                	mv	a2,s5
     620:	85ca                	mv	a1,s2
     622:	854e                	mv	a0,s3
     624:	f49ff0ef          	jal	56c <peek>
     628:	c525                	beqz	a0,690 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     62a:	4681                	li	a3,0
     62c:	4601                	li	a2,0
     62e:	85ca                	mv	a1,s2
     630:	854e                	mv	a0,s3
     632:	dffff0ef          	jal	430 <gettoken>
     636:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     638:	fa040693          	addi	a3,s0,-96
     63c:	fa840613          	addi	a2,s0,-88
     640:	85ca                	mv	a1,s2
     642:	854e                	mv	a0,s3
     644:	dedff0ef          	jal	430 <gettoken>
     648:	fb651be3          	bne	a0,s6,5fe <parseredirs+0x2e>
    switch(tok){
     64c:	fb748fe3          	beq	s1,s7,60a <parseredirs+0x3a>
     650:	03e00793          	li	a5,62
     654:	02f48263          	beq	s1,a5,678 <parseredirs+0xa8>
     658:	02b00793          	li	a5,43
     65c:	fcf491e3          	bne	s1,a5,61e <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     660:	4705                	li	a4,1
     662:	20100693          	li	a3,513
     666:	fa043603          	ld	a2,-96(s0)
     66a:	fa843583          	ld	a1,-88(s0)
     66e:	8552                	mv	a0,s4
     670:	cb1ff0ef          	jal	320 <redircmd>
     674:	8a2a                	mv	s4,a0
      break;
     676:	b765                	j	61e <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     678:	4705                	li	a4,1
     67a:	60100693          	li	a3,1537
     67e:	fa043603          	ld	a2,-96(s0)
     682:	fa843583          	ld	a1,-88(s0)
     686:	8552                	mv	a0,s4
     688:	c99ff0ef          	jal	320 <redircmd>
     68c:	8a2a                	mv	s4,a0
      break;
     68e:	bf41                	j	61e <parseredirs+0x4e>
    }
  }
  return cmd;
}
     690:	8552                	mv	a0,s4
     692:	60e6                	ld	ra,88(sp)
     694:	6446                	ld	s0,80(sp)
     696:	64a6                	ld	s1,72(sp)
     698:	6906                	ld	s2,64(sp)
     69a:	79e2                	ld	s3,56(sp)
     69c:	7a42                	ld	s4,48(sp)
     69e:	7aa2                	ld	s5,40(sp)
     6a0:	7b02                	ld	s6,32(sp)
     6a2:	6be2                	ld	s7,24(sp)
     6a4:	6125                	addi	sp,sp,96
     6a6:	8082                	ret

00000000000006a8 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     6a8:	7159                	addi	sp,sp,-112
     6aa:	f486                	sd	ra,104(sp)
     6ac:	f0a2                	sd	s0,96(sp)
     6ae:	eca6                	sd	s1,88(sp)
     6b0:	e0d2                	sd	s4,64(sp)
     6b2:	fc56                	sd	s5,56(sp)
     6b4:	1880                	addi	s0,sp,112
     6b6:	8a2a                	mv	s4,a0
     6b8:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6ba:	00001617          	auipc	a2,0x1
     6be:	d1e60613          	addi	a2,a2,-738 # 13d8 <malloc+0x1c2>
     6c2:	eabff0ef          	jal	56c <peek>
     6c6:	e149                	bnez	a0,748 <parseexec+0xa0>
     6c8:	e8ca                	sd	s2,80(sp)
     6ca:	e4ce                	sd	s3,72(sp)
     6cc:	f85a                	sd	s6,48(sp)
     6ce:	f45e                	sd	s7,40(sp)
     6d0:	f062                	sd	s8,32(sp)
     6d2:	ec66                	sd	s9,24(sp)
     6d4:	e86a                	sd	s10,16(sp)
     6d6:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6d8:	c1bff0ef          	jal	2f2 <execcmd>
     6dc:	8d2a                	mv	s10,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6de:	8656                	mv	a2,s5
     6e0:	85d2                	mv	a1,s4
     6e2:	eefff0ef          	jal	5d0 <parseredirs>
     6e6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6e8:	008d0913          	addi	s2,s10,8
     6ec:	00001b17          	auipc	s6,0x1
     6f0:	d0cb0b13          	addi	s6,s6,-756 # 13f8 <malloc+0x1e2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6f4:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
     6f8:	6c05                	lui	s8,0x1
    argc++;
    if(argc >= MAXARGS)
     6fa:	20000b93          	li	s7,512
  while(!peek(ps, es, "|)&;")){
     6fe:	865a                	mv	a2,s6
     700:	85d6                	mv	a1,s5
     702:	8552                	mv	a0,s4
     704:	e69ff0ef          	jal	56c <peek>
     708:	e135                	bnez	a0,76c <parseexec+0xc4>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     70a:	f9040693          	addi	a3,s0,-112
     70e:	f9840613          	addi	a2,s0,-104
     712:	85d6                	mv	a1,s5
     714:	8552                	mv	a0,s4
     716:	d1bff0ef          	jal	430 <gettoken>
     71a:	c929                	beqz	a0,76c <parseexec+0xc4>
    if(tok != 'a')
     71c:	03951c63          	bne	a0,s9,754 <parseexec+0xac>
    cmd->argv[argc] = q;
     720:	f9843783          	ld	a5,-104(s0)
     724:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     728:	018907b3          	add	a5,s2,s8
     72c:	f9043703          	ld	a4,-112(s0)
     730:	e398                	sd	a4,0(a5)
    argc++;
     732:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     734:	0921                	addi	s2,s2,8
     736:	03798563          	beq	s3,s7,760 <parseexec+0xb8>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     73a:	8656                	mv	a2,s5
     73c:	85d2                	mv	a1,s4
     73e:	8526                	mv	a0,s1
     740:	e91ff0ef          	jal	5d0 <parseredirs>
     744:	84aa                	mv	s1,a0
     746:	bf65                	j	6fe <parseexec+0x56>
    return parseblock(ps, es);
     748:	85d6                	mv	a1,s5
     74a:	8552                	mv	a0,s4
     74c:	130000ef          	jal	87c <parseblock>
     750:	84aa                	mv	s1,a0
     752:	a825                	j	78a <parseexec+0xe2>
      panic("syntax");
     754:	00001517          	auipc	a0,0x1
     758:	c8c50513          	addi	a0,a0,-884 # 13e0 <malloc+0x1ca>
     75c:	8efff0ef          	jal	4a <panic>
      panic("too many args");
     760:	00001517          	auipc	a0,0x1
     764:	c8850513          	addi	a0,a0,-888 # 13e8 <malloc+0x1d2>
     768:	8e3ff0ef          	jal	4a <panic>
  }
  cmd->argv[argc] = 0;
     76c:	098e                	slli	s3,s3,0x3
     76e:	9d4e                	add	s10,s10,s3
     770:	000d3423          	sd	zero,8(s10)
  cmd->eargv[argc] = 0;
     774:	6785                	lui	a5,0x1
     776:	9d3e                	add	s10,s10,a5
     778:	000d3423          	sd	zero,8(s10)
     77c:	6946                	ld	s2,80(sp)
     77e:	69a6                	ld	s3,72(sp)
     780:	7b42                	ld	s6,48(sp)
     782:	7ba2                	ld	s7,40(sp)
     784:	7c02                	ld	s8,32(sp)
     786:	6ce2                	ld	s9,24(sp)
     788:	6d42                	ld	s10,16(sp)
  return ret;
}
     78a:	8526                	mv	a0,s1
     78c:	70a6                	ld	ra,104(sp)
     78e:	7406                	ld	s0,96(sp)
     790:	64e6                	ld	s1,88(sp)
     792:	6a06                	ld	s4,64(sp)
     794:	7ae2                	ld	s5,56(sp)
     796:	6165                	addi	sp,sp,112
     798:	8082                	ret

000000000000079a <parsepipe>:
{
     79a:	7179                	addi	sp,sp,-48
     79c:	f406                	sd	ra,40(sp)
     79e:	f022                	sd	s0,32(sp)
     7a0:	ec26                	sd	s1,24(sp)
     7a2:	e84a                	sd	s2,16(sp)
     7a4:	e44e                	sd	s3,8(sp)
     7a6:	1800                	addi	s0,sp,48
     7a8:	892a                	mv	s2,a0
     7aa:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7ac:	efdff0ef          	jal	6a8 <parseexec>
     7b0:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7b2:	00001617          	auipc	a2,0x1
     7b6:	c4e60613          	addi	a2,a2,-946 # 1400 <malloc+0x1ea>
     7ba:	85ce                	mv	a1,s3
     7bc:	854a                	mv	a0,s2
     7be:	dafff0ef          	jal	56c <peek>
     7c2:	e909                	bnez	a0,7d4 <parsepipe+0x3a>
}
     7c4:	8526                	mv	a0,s1
     7c6:	70a2                	ld	ra,40(sp)
     7c8:	7402                	ld	s0,32(sp)
     7ca:	64e2                	ld	s1,24(sp)
     7cc:	6942                	ld	s2,16(sp)
     7ce:	69a2                	ld	s3,8(sp)
     7d0:	6145                	addi	sp,sp,48
     7d2:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d4:	4681                	li	a3,0
     7d6:	4601                	li	a2,0
     7d8:	85ce                	mv	a1,s3
     7da:	854a                	mv	a0,s2
     7dc:	c55ff0ef          	jal	430 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e0:	85ce                	mv	a1,s3
     7e2:	854a                	mv	a0,s2
     7e4:	fb7ff0ef          	jal	79a <parsepipe>
     7e8:	85aa                	mv	a1,a0
     7ea:	8526                	mv	a0,s1
     7ec:	b95ff0ef          	jal	380 <pipecmd>
     7f0:	84aa                	mv	s1,a0
  return cmd;
     7f2:	bfc9                	j	7c4 <parsepipe+0x2a>

00000000000007f4 <parseline>:
{
     7f4:	7179                	addi	sp,sp,-48
     7f6:	f406                	sd	ra,40(sp)
     7f8:	f022                	sd	s0,32(sp)
     7fa:	ec26                	sd	s1,24(sp)
     7fc:	e84a                	sd	s2,16(sp)
     7fe:	e44e                	sd	s3,8(sp)
     800:	e052                	sd	s4,0(sp)
     802:	1800                	addi	s0,sp,48
     804:	892a                	mv	s2,a0
     806:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     808:	f93ff0ef          	jal	79a <parsepipe>
     80c:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     80e:	00001a17          	auipc	s4,0x1
     812:	bfaa0a13          	addi	s4,s4,-1030 # 1408 <malloc+0x1f2>
     816:	a819                	j	82c <parseline+0x38>
    gettoken(ps, es, 0, 0);
     818:	4681                	li	a3,0
     81a:	4601                	li	a2,0
     81c:	85ce                	mv	a1,s3
     81e:	854a                	mv	a0,s2
     820:	c11ff0ef          	jal	430 <gettoken>
    cmd = backcmd(cmd);
     824:	8526                	mv	a0,s1
     826:	bd7ff0ef          	jal	3fc <backcmd>
     82a:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     82c:	8652                	mv	a2,s4
     82e:	85ce                	mv	a1,s3
     830:	854a                	mv	a0,s2
     832:	d3bff0ef          	jal	56c <peek>
     836:	f16d                	bnez	a0,818 <parseline+0x24>
  if(peek(ps, es, ";")){
     838:	00001617          	auipc	a2,0x1
     83c:	bd860613          	addi	a2,a2,-1064 # 1410 <malloc+0x1fa>
     840:	85ce                	mv	a1,s3
     842:	854a                	mv	a0,s2
     844:	d29ff0ef          	jal	56c <peek>
     848:	e911                	bnez	a0,85c <parseline+0x68>
}
     84a:	8526                	mv	a0,s1
     84c:	70a2                	ld	ra,40(sp)
     84e:	7402                	ld	s0,32(sp)
     850:	64e2                	ld	s1,24(sp)
     852:	6942                	ld	s2,16(sp)
     854:	69a2                	ld	s3,8(sp)
     856:	6a02                	ld	s4,0(sp)
     858:	6145                	addi	sp,sp,48
     85a:	8082                	ret
    gettoken(ps, es, 0, 0);
     85c:	4681                	li	a3,0
     85e:	4601                	li	a2,0
     860:	85ce                	mv	a1,s3
     862:	854a                	mv	a0,s2
     864:	bcdff0ef          	jal	430 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     868:	85ce                	mv	a1,s3
     86a:	854a                	mv	a0,s2
     86c:	f89ff0ef          	jal	7f4 <parseline>
     870:	85aa                	mv	a1,a0
     872:	8526                	mv	a0,s1
     874:	b4bff0ef          	jal	3be <listcmd>
     878:	84aa                	mv	s1,a0
  return cmd;
     87a:	bfc1                	j	84a <parseline+0x56>

000000000000087c <parseblock>:
{
     87c:	7179                	addi	sp,sp,-48
     87e:	f406                	sd	ra,40(sp)
     880:	f022                	sd	s0,32(sp)
     882:	ec26                	sd	s1,24(sp)
     884:	e84a                	sd	s2,16(sp)
     886:	e44e                	sd	s3,8(sp)
     888:	1800                	addi	s0,sp,48
     88a:	84aa                	mv	s1,a0
     88c:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     88e:	00001617          	auipc	a2,0x1
     892:	b4a60613          	addi	a2,a2,-1206 # 13d8 <malloc+0x1c2>
     896:	cd7ff0ef          	jal	56c <peek>
     89a:	c539                	beqz	a0,8e8 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     89c:	4681                	li	a3,0
     89e:	4601                	li	a2,0
     8a0:	85ca                	mv	a1,s2
     8a2:	8526                	mv	a0,s1
     8a4:	b8dff0ef          	jal	430 <gettoken>
  cmd = parseline(ps, es);
     8a8:	85ca                	mv	a1,s2
     8aa:	8526                	mv	a0,s1
     8ac:	f49ff0ef          	jal	7f4 <parseline>
     8b0:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8b2:	00001617          	auipc	a2,0x1
     8b6:	b7660613          	addi	a2,a2,-1162 # 1428 <malloc+0x212>
     8ba:	85ca                	mv	a1,s2
     8bc:	8526                	mv	a0,s1
     8be:	cafff0ef          	jal	56c <peek>
     8c2:	c90d                	beqz	a0,8f4 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     8c4:	4681                	li	a3,0
     8c6:	4601                	li	a2,0
     8c8:	85ca                	mv	a1,s2
     8ca:	8526                	mv	a0,s1
     8cc:	b65ff0ef          	jal	430 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     8d0:	864a                	mv	a2,s2
     8d2:	85a6                	mv	a1,s1
     8d4:	854e                	mv	a0,s3
     8d6:	cfbff0ef          	jal	5d0 <parseredirs>
}
     8da:	70a2                	ld	ra,40(sp)
     8dc:	7402                	ld	s0,32(sp)
     8de:	64e2                	ld	s1,24(sp)
     8e0:	6942                	ld	s2,16(sp)
     8e2:	69a2                	ld	s3,8(sp)
     8e4:	6145                	addi	sp,sp,48
     8e6:	8082                	ret
    panic("parseblock");
     8e8:	00001517          	auipc	a0,0x1
     8ec:	b3050513          	addi	a0,a0,-1232 # 1418 <malloc+0x202>
     8f0:	f5aff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     8f4:	00001517          	auipc	a0,0x1
     8f8:	b3c50513          	addi	a0,a0,-1220 # 1430 <malloc+0x21a>
     8fc:	f4eff0ef          	jal	4a <panic>

0000000000000900 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     900:	1101                	addi	sp,sp,-32
     902:	ec06                	sd	ra,24(sp)
     904:	e822                	sd	s0,16(sp)
     906:	e426                	sd	s1,8(sp)
     908:	1000                	addi	s0,sp,32
     90a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     90c:	c531                	beqz	a0,958 <nulterminate+0x58>
    return 0;

  switch(cmd->type){
     90e:	4118                	lw	a4,0(a0)
     910:	4795                	li	a5,5
     912:	04e7e363          	bltu	a5,a4,958 <nulterminate+0x58>
     916:	00056783          	lwu	a5,0(a0)
     91a:	078a                	slli	a5,a5,0x2
     91c:	00001717          	auipc	a4,0x1
     920:	b7470713          	addi	a4,a4,-1164 # 1490 <malloc+0x27a>
     924:	97ba                	add	a5,a5,a4
     926:	439c                	lw	a5,0(a5)
     928:	97ba                	add	a5,a5,a4
     92a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     92c:	651c                	ld	a5,8(a0)
     92e:	c78d                	beqz	a5,958 <nulterminate+0x58>
     930:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     934:	6685                	lui	a3,0x1
     936:	16e1                	addi	a3,a3,-8 # ff8 <vprintf+0x148>
     938:	00d78733          	add	a4,a5,a3
     93c:	6318                	ld	a4,0(a4)
     93e:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     942:	07a1                	addi	a5,a5,8 # 1008 <vprintf+0x158>
     944:	ff87b703          	ld	a4,-8(a5)
     948:	fb65                	bnez	a4,938 <nulterminate+0x38>
     94a:	a039                	j	958 <nulterminate+0x58>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     94c:	6508                	ld	a0,8(a0)
     94e:	fb3ff0ef          	jal	900 <nulterminate>
    *rcmd->efile = 0;
     952:	6c9c                	ld	a5,24(s1)
     954:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
     958:	8526                	mv	a0,s1
     95a:	60e2                	ld	ra,24(sp)
     95c:	6442                	ld	s0,16(sp)
     95e:	64a2                	ld	s1,8(sp)
     960:	6105                	addi	sp,sp,32
     962:	8082                	ret
    nulterminate(pcmd->left);
     964:	6508                	ld	a0,8(a0)
     966:	f9bff0ef          	jal	900 <nulterminate>
    nulterminate(pcmd->right);
     96a:	6888                	ld	a0,16(s1)
     96c:	f95ff0ef          	jal	900 <nulterminate>
    break;
     970:	b7e5                	j	958 <nulterminate+0x58>
    nulterminate(lcmd->left);
     972:	6508                	ld	a0,8(a0)
     974:	f8dff0ef          	jal	900 <nulterminate>
    nulterminate(lcmd->right);
     978:	6888                	ld	a0,16(s1)
     97a:	f87ff0ef          	jal	900 <nulterminate>
    break;
     97e:	bfe9                	j	958 <nulterminate+0x58>
    nulterminate(bcmd->cmd);
     980:	6508                	ld	a0,8(a0)
     982:	f7fff0ef          	jal	900 <nulterminate>
    break;
     986:	bfc9                	j	958 <nulterminate+0x58>

0000000000000988 <parsecmd>:
{
     988:	7179                	addi	sp,sp,-48
     98a:	f406                	sd	ra,40(sp)
     98c:	f022                	sd	s0,32(sp)
     98e:	ec26                	sd	s1,24(sp)
     990:	e84a                	sd	s2,16(sp)
     992:	1800                	addi	s0,sp,48
     994:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     998:	84aa                	mv	s1,a0
     99a:	188000ef          	jal	b22 <strlen>
     99e:	1502                	slli	a0,a0,0x20
     9a0:	9101                	srli	a0,a0,0x20
     9a2:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     9a4:	85a6                	mv	a1,s1
     9a6:	fd840513          	addi	a0,s0,-40
     9aa:	e4bff0ef          	jal	7f4 <parseline>
     9ae:	892a                	mv	s2,a0
  peek(&s, es, "");
     9b0:	00001617          	auipc	a2,0x1
     9b4:	97860613          	addi	a2,a2,-1672 # 1328 <malloc+0x112>
     9b8:	85a6                	mv	a1,s1
     9ba:	fd840513          	addi	a0,s0,-40
     9be:	bafff0ef          	jal	56c <peek>
  if(s != es){
     9c2:	fd843603          	ld	a2,-40(s0)
     9c6:	00961c63          	bne	a2,s1,9de <parsecmd+0x56>
  nulterminate(cmd);
     9ca:	854a                	mv	a0,s2
     9cc:	f35ff0ef          	jal	900 <nulterminate>
}
     9d0:	854a                	mv	a0,s2
     9d2:	70a2                	ld	ra,40(sp)
     9d4:	7402                	ld	s0,32(sp)
     9d6:	64e2                	ld	s1,24(sp)
     9d8:	6942                	ld	s2,16(sp)
     9da:	6145                	addi	sp,sp,48
     9dc:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     9de:	00001597          	auipc	a1,0x1
     9e2:	a6a58593          	addi	a1,a1,-1430 # 1448 <malloc+0x232>
     9e6:	4509                	li	a0,2
     9e8:	750000ef          	jal	1138 <fprintf>
    panic("syntax");
     9ec:	00001517          	auipc	a0,0x1
     9f0:	9f450513          	addi	a0,a0,-1548 # 13e0 <malloc+0x1ca>
     9f4:	e56ff0ef          	jal	4a <panic>

00000000000009f8 <main>:
{
     9f8:	7179                	addi	sp,sp,-48
     9fa:	f406                	sd	ra,40(sp)
     9fc:	f022                	sd	s0,32(sp)
     9fe:	ec26                	sd	s1,24(sp)
     a00:	e84a                	sd	s2,16(sp)
     a02:	e44e                	sd	s3,8(sp)
     a04:	e052                	sd	s4,0(sp)
     a06:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a08:	00001497          	auipc	s1,0x1
     a0c:	a5048493          	addi	s1,s1,-1456 # 1458 <malloc+0x242>
     a10:	4589                	li	a1,2
     a12:	8526                	mv	a0,s1
     a14:	35e000ef          	jal	d72 <open>
     a18:	00054763          	bltz	a0,a26 <main+0x2e>
    if(fd >= 3){
     a1c:	4789                	li	a5,2
     a1e:	fea7d9e3          	bge	a5,a0,a10 <main+0x18>
      close(fd);
     a22:	338000ef          	jal	d5a <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a26:	00001497          	auipc	s1,0x1
     a2a:	5fa48493          	addi	s1,s1,1530 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a2e:	06300913          	li	s2,99
     a32:	02000993          	li	s3,32
     a36:	a039                	j	a44 <main+0x4c>
    if(fork1() == 0)
     a38:	e30ff0ef          	jal	68 <fork1>
     a3c:	c93d                	beqz	a0,ab2 <main+0xba>
    wait(0);
     a3e:	4501                	li	a0,0
     a40:	2fa000ef          	jal	d3a <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a44:	06400593          	li	a1,100
     a48:	8526                	mv	a0,s1
     a4a:	db6ff0ef          	jal	0 <getcmd>
     a4e:	06054a63          	bltz	a0,ac2 <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     a52:	0004c783          	lbu	a5,0(s1)
     a56:	ff2791e3          	bne	a5,s2,a38 <main+0x40>
     a5a:	0014c703          	lbu	a4,1(s1)
     a5e:	06400793          	li	a5,100
     a62:	fcf71be3          	bne	a4,a5,a38 <main+0x40>
     a66:	0024c783          	lbu	a5,2(s1)
     a6a:	fd3797e3          	bne	a5,s3,a38 <main+0x40>
      buf[strlen(buf)-1] = 0;  // chop \n
     a6e:	00001a17          	auipc	s4,0x1
     a72:	5b2a0a13          	addi	s4,s4,1458 # 2020 <buf.0>
     a76:	8552                	mv	a0,s4
     a78:	0aa000ef          	jal	b22 <strlen>
     a7c:	fff5079b          	addiw	a5,a0,-1
     a80:	1782                	slli	a5,a5,0x20
     a82:	9381                	srli	a5,a5,0x20
     a84:	9a3e                	add	s4,s4,a5
     a86:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     a8a:	00001517          	auipc	a0,0x1
     a8e:	59950513          	addi	a0,a0,1433 # 2023 <buf.0+0x3>
     a92:	310000ef          	jal	da2 <chdir>
     a96:	fa0557e3          	bgez	a0,a44 <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf+3);
     a9a:	00001617          	auipc	a2,0x1
     a9e:	58960613          	addi	a2,a2,1417 # 2023 <buf.0+0x3>
     aa2:	00001597          	auipc	a1,0x1
     aa6:	9be58593          	addi	a1,a1,-1602 # 1460 <malloc+0x24a>
     aaa:	4509                	li	a0,2
     aac:	68c000ef          	jal	1138 <fprintf>
     ab0:	bf51                	j	a44 <main+0x4c>
      runcmd(parsecmd(buf));
     ab2:	00001517          	auipc	a0,0x1
     ab6:	56e50513          	addi	a0,a0,1390 # 2020 <buf.0>
     aba:	ecfff0ef          	jal	988 <parsecmd>
     abe:	dd0ff0ef          	jal	8e <runcmd>
  exit(0);
     ac2:	4501                	li	a0,0
     ac4:	26e000ef          	jal	d32 <exit>

0000000000000ac8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     ac8:	1141                	addi	sp,sp,-16
     aca:	e406                	sd	ra,8(sp)
     acc:	e022                	sd	s0,0(sp)
     ace:	0800                	addi	s0,sp,16
  extern int main();
  main();
     ad0:	f29ff0ef          	jal	9f8 <main>
  exit(0);
     ad4:	4501                	li	a0,0
     ad6:	25c000ef          	jal	d32 <exit>

0000000000000ada <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     ada:	1141                	addi	sp,sp,-16
     adc:	e422                	sd	s0,8(sp)
     ade:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ae0:	87aa                	mv	a5,a0
     ae2:	0585                	addi	a1,a1,1
     ae4:	0785                	addi	a5,a5,1
     ae6:	fff5c703          	lbu	a4,-1(a1)
     aea:	fee78fa3          	sb	a4,-1(a5)
     aee:	fb75                	bnez	a4,ae2 <strcpy+0x8>
    ;
  return os;
}
     af0:	6422                	ld	s0,8(sp)
     af2:	0141                	addi	sp,sp,16
     af4:	8082                	ret

0000000000000af6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     af6:	1141                	addi	sp,sp,-16
     af8:	e422                	sd	s0,8(sp)
     afa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     afc:	00054783          	lbu	a5,0(a0)
     b00:	cb91                	beqz	a5,b14 <strcmp+0x1e>
     b02:	0005c703          	lbu	a4,0(a1)
     b06:	00f71763          	bne	a4,a5,b14 <strcmp+0x1e>
    p++, q++;
     b0a:	0505                	addi	a0,a0,1
     b0c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b0e:	00054783          	lbu	a5,0(a0)
     b12:	fbe5                	bnez	a5,b02 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b14:	0005c503          	lbu	a0,0(a1)
}
     b18:	40a7853b          	subw	a0,a5,a0
     b1c:	6422                	ld	s0,8(sp)
     b1e:	0141                	addi	sp,sp,16
     b20:	8082                	ret

0000000000000b22 <strlen>:

uint
strlen(const char *s)
{
     b22:	1141                	addi	sp,sp,-16
     b24:	e422                	sd	s0,8(sp)
     b26:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     b28:	00054783          	lbu	a5,0(a0)
     b2c:	cf91                	beqz	a5,b48 <strlen+0x26>
     b2e:	0505                	addi	a0,a0,1
     b30:	87aa                	mv	a5,a0
     b32:	86be                	mv	a3,a5
     b34:	0785                	addi	a5,a5,1
     b36:	fff7c703          	lbu	a4,-1(a5)
     b3a:	ff65                	bnez	a4,b32 <strlen+0x10>
     b3c:	40a6853b          	subw	a0,a3,a0
     b40:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     b42:	6422                	ld	s0,8(sp)
     b44:	0141                	addi	sp,sp,16
     b46:	8082                	ret
  for(n = 0; s[n]; n++)
     b48:	4501                	li	a0,0
     b4a:	bfe5                	j	b42 <strlen+0x20>

0000000000000b4c <memset>:

void*
memset(void *dst, int c, uint n)
{
     b4c:	1141                	addi	sp,sp,-16
     b4e:	e422                	sd	s0,8(sp)
     b50:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     b52:	ca19                	beqz	a2,b68 <memset+0x1c>
     b54:	87aa                	mv	a5,a0
     b56:	1602                	slli	a2,a2,0x20
     b58:	9201                	srli	a2,a2,0x20
     b5a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     b5e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     b62:	0785                	addi	a5,a5,1
     b64:	fee79de3          	bne	a5,a4,b5e <memset+0x12>
  }
  return dst;
}
     b68:	6422                	ld	s0,8(sp)
     b6a:	0141                	addi	sp,sp,16
     b6c:	8082                	ret

0000000000000b6e <strchr>:

char*
strchr(const char *s, char c)
{
     b6e:	1141                	addi	sp,sp,-16
     b70:	e422                	sd	s0,8(sp)
     b72:	0800                	addi	s0,sp,16
  for(; *s; s++)
     b74:	00054783          	lbu	a5,0(a0)
     b78:	cb99                	beqz	a5,b8e <strchr+0x20>
    if(*s == c)
     b7a:	00f58763          	beq	a1,a5,b88 <strchr+0x1a>
  for(; *s; s++)
     b7e:	0505                	addi	a0,a0,1
     b80:	00054783          	lbu	a5,0(a0)
     b84:	fbfd                	bnez	a5,b7a <strchr+0xc>
      return (char*)s;
  return 0;
     b86:	4501                	li	a0,0
}
     b88:	6422                	ld	s0,8(sp)
     b8a:	0141                	addi	sp,sp,16
     b8c:	8082                	ret
  return 0;
     b8e:	4501                	li	a0,0
     b90:	bfe5                	j	b88 <strchr+0x1a>

0000000000000b92 <gets>:

char*
gets(char *buf, int max)
{
     b92:	711d                	addi	sp,sp,-96
     b94:	ec86                	sd	ra,88(sp)
     b96:	e8a2                	sd	s0,80(sp)
     b98:	e4a6                	sd	s1,72(sp)
     b9a:	e0ca                	sd	s2,64(sp)
     b9c:	fc4e                	sd	s3,56(sp)
     b9e:	f852                	sd	s4,48(sp)
     ba0:	f456                	sd	s5,40(sp)
     ba2:	f05a                	sd	s6,32(sp)
     ba4:	ec5e                	sd	s7,24(sp)
     ba6:	1080                	addi	s0,sp,96
     ba8:	8baa                	mv	s7,a0
     baa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bac:	892a                	mv	s2,a0
     bae:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     bb0:	4aa9                	li	s5,10
     bb2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     bb4:	89a6                	mv	s3,s1
     bb6:	2485                	addiw	s1,s1,1
     bb8:	0344d663          	bge	s1,s4,be4 <gets+0x52>
    cc = read(0, &c, 1);
     bbc:	4605                	li	a2,1
     bbe:	faf40593          	addi	a1,s0,-81
     bc2:	4501                	li	a0,0
     bc4:	186000ef          	jal	d4a <read>
    if(cc < 1)
     bc8:	00a05e63          	blez	a0,be4 <gets+0x52>
    buf[i++] = c;
     bcc:	faf44783          	lbu	a5,-81(s0)
     bd0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     bd4:	01578763          	beq	a5,s5,be2 <gets+0x50>
     bd8:	0905                	addi	s2,s2,1
     bda:	fd679de3          	bne	a5,s6,bb4 <gets+0x22>
    buf[i++] = c;
     bde:	89a6                	mv	s3,s1
     be0:	a011                	j	be4 <gets+0x52>
     be2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     be4:	99de                	add	s3,s3,s7
     be6:	00098023          	sb	zero,0(s3)
  return buf;
}
     bea:	855e                	mv	a0,s7
     bec:	60e6                	ld	ra,88(sp)
     bee:	6446                	ld	s0,80(sp)
     bf0:	64a6                	ld	s1,72(sp)
     bf2:	6906                	ld	s2,64(sp)
     bf4:	79e2                	ld	s3,56(sp)
     bf6:	7a42                	ld	s4,48(sp)
     bf8:	7aa2                	ld	s5,40(sp)
     bfa:	7b02                	ld	s6,32(sp)
     bfc:	6be2                	ld	s7,24(sp)
     bfe:	6125                	addi	sp,sp,96
     c00:	8082                	ret

0000000000000c02 <stat>:

int
stat(const char *n, struct stat *st)
{
     c02:	1101                	addi	sp,sp,-32
     c04:	ec06                	sd	ra,24(sp)
     c06:	e822                	sd	s0,16(sp)
     c08:	e04a                	sd	s2,0(sp)
     c0a:	1000                	addi	s0,sp,32
     c0c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c0e:	4581                	li	a1,0
     c10:	162000ef          	jal	d72 <open>
  if(fd < 0)
     c14:	02054263          	bltz	a0,c38 <stat+0x36>
     c18:	e426                	sd	s1,8(sp)
     c1a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     c1c:	85ca                	mv	a1,s2
     c1e:	16c000ef          	jal	d8a <fstat>
     c22:	892a                	mv	s2,a0
  close(fd);
     c24:	8526                	mv	a0,s1
     c26:	134000ef          	jal	d5a <close>
  return r;
     c2a:	64a2                	ld	s1,8(sp)
}
     c2c:	854a                	mv	a0,s2
     c2e:	60e2                	ld	ra,24(sp)
     c30:	6442                	ld	s0,16(sp)
     c32:	6902                	ld	s2,0(sp)
     c34:	6105                	addi	sp,sp,32
     c36:	8082                	ret
    return -1;
     c38:	597d                	li	s2,-1
     c3a:	bfcd                	j	c2c <stat+0x2a>

0000000000000c3c <atoi>:

int
atoi(const char *s)
{
     c3c:	1141                	addi	sp,sp,-16
     c3e:	e422                	sd	s0,8(sp)
     c40:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     c42:	00054683          	lbu	a3,0(a0)
     c46:	fd06879b          	addiw	a5,a3,-48
     c4a:	0ff7f793          	zext.b	a5,a5
     c4e:	4625                	li	a2,9
     c50:	02f66863          	bltu	a2,a5,c80 <atoi+0x44>
     c54:	872a                	mv	a4,a0
  n = 0;
     c56:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     c58:	0705                	addi	a4,a4,1
     c5a:	0025179b          	slliw	a5,a0,0x2
     c5e:	9fa9                	addw	a5,a5,a0
     c60:	0017979b          	slliw	a5,a5,0x1
     c64:	9fb5                	addw	a5,a5,a3
     c66:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c6a:	00074683          	lbu	a3,0(a4)
     c6e:	fd06879b          	addiw	a5,a3,-48
     c72:	0ff7f793          	zext.b	a5,a5
     c76:	fef671e3          	bgeu	a2,a5,c58 <atoi+0x1c>
  return n;
}
     c7a:	6422                	ld	s0,8(sp)
     c7c:	0141                	addi	sp,sp,16
     c7e:	8082                	ret
  n = 0;
     c80:	4501                	li	a0,0
     c82:	bfe5                	j	c7a <atoi+0x3e>

0000000000000c84 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c84:	1141                	addi	sp,sp,-16
     c86:	e422                	sd	s0,8(sp)
     c88:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     c8a:	02b57463          	bgeu	a0,a1,cb2 <memmove+0x2e>
    while(n-- > 0)
     c8e:	00c05f63          	blez	a2,cac <memmove+0x28>
     c92:	1602                	slli	a2,a2,0x20
     c94:	9201                	srli	a2,a2,0x20
     c96:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     c9a:	872a                	mv	a4,a0
      *dst++ = *src++;
     c9c:	0585                	addi	a1,a1,1
     c9e:	0705                	addi	a4,a4,1
     ca0:	fff5c683          	lbu	a3,-1(a1)
     ca4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ca8:	fef71ae3          	bne	a4,a5,c9c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     cac:	6422                	ld	s0,8(sp)
     cae:	0141                	addi	sp,sp,16
     cb0:	8082                	ret
    dst += n;
     cb2:	00c50733          	add	a4,a0,a2
    src += n;
     cb6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     cb8:	fec05ae3          	blez	a2,cac <memmove+0x28>
     cbc:	fff6079b          	addiw	a5,a2,-1
     cc0:	1782                	slli	a5,a5,0x20
     cc2:	9381                	srli	a5,a5,0x20
     cc4:	fff7c793          	not	a5,a5
     cc8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     cca:	15fd                	addi	a1,a1,-1
     ccc:	177d                	addi	a4,a4,-1
     cce:	0005c683          	lbu	a3,0(a1)
     cd2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     cd6:	fee79ae3          	bne	a5,a4,cca <memmove+0x46>
     cda:	bfc9                	j	cac <memmove+0x28>

0000000000000cdc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     cdc:	1141                	addi	sp,sp,-16
     cde:	e422                	sd	s0,8(sp)
     ce0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ce2:	ca05                	beqz	a2,d12 <memcmp+0x36>
     ce4:	fff6069b          	addiw	a3,a2,-1
     ce8:	1682                	slli	a3,a3,0x20
     cea:	9281                	srli	a3,a3,0x20
     cec:	0685                	addi	a3,a3,1
     cee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     cf0:	00054783          	lbu	a5,0(a0)
     cf4:	0005c703          	lbu	a4,0(a1)
     cf8:	00e79863          	bne	a5,a4,d08 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     cfc:	0505                	addi	a0,a0,1
    p2++;
     cfe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d00:	fed518e3          	bne	a0,a3,cf0 <memcmp+0x14>
  }
  return 0;
     d04:	4501                	li	a0,0
     d06:	a019                	j	d0c <memcmp+0x30>
      return *p1 - *p2;
     d08:	40e7853b          	subw	a0,a5,a4
}
     d0c:	6422                	ld	s0,8(sp)
     d0e:	0141                	addi	sp,sp,16
     d10:	8082                	ret
  return 0;
     d12:	4501                	li	a0,0
     d14:	bfe5                	j	d0c <memcmp+0x30>

0000000000000d16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     d16:	1141                	addi	sp,sp,-16
     d18:	e406                	sd	ra,8(sp)
     d1a:	e022                	sd	s0,0(sp)
     d1c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     d1e:	f67ff0ef          	jal	c84 <memmove>
}
     d22:	60a2                	ld	ra,8(sp)
     d24:	6402                	ld	s0,0(sp)
     d26:	0141                	addi	sp,sp,16
     d28:	8082                	ret

0000000000000d2a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     d2a:	4885                	li	a7,1
 ecall
     d2c:	00000073          	ecall
 ret
     d30:	8082                	ret

0000000000000d32 <exit>:
.global exit
exit:
 li a7, SYS_exit
     d32:	4889                	li	a7,2
 ecall
     d34:	00000073          	ecall
 ret
     d38:	8082                	ret

0000000000000d3a <wait>:
.global wait
wait:
 li a7, SYS_wait
     d3a:	488d                	li	a7,3
 ecall
     d3c:	00000073          	ecall
 ret
     d40:	8082                	ret

0000000000000d42 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     d42:	4891                	li	a7,4
 ecall
     d44:	00000073          	ecall
 ret
     d48:	8082                	ret

0000000000000d4a <read>:
.global read
read:
 li a7, SYS_read
     d4a:	4895                	li	a7,5
 ecall
     d4c:	00000073          	ecall
 ret
     d50:	8082                	ret

0000000000000d52 <write>:
.global write
write:
 li a7, SYS_write
     d52:	48c1                	li	a7,16
 ecall
     d54:	00000073          	ecall
 ret
     d58:	8082                	ret

0000000000000d5a <close>:
.global close
close:
 li a7, SYS_close
     d5a:	48d5                	li	a7,21
 ecall
     d5c:	00000073          	ecall
 ret
     d60:	8082                	ret

0000000000000d62 <kill>:
.global kill
kill:
 li a7, SYS_kill
     d62:	4899                	li	a7,6
 ecall
     d64:	00000073          	ecall
 ret
     d68:	8082                	ret

0000000000000d6a <exec>:
.global exec
exec:
 li a7, SYS_exec
     d6a:	489d                	li	a7,7
 ecall
     d6c:	00000073          	ecall
 ret
     d70:	8082                	ret

0000000000000d72 <open>:
.global open
open:
 li a7, SYS_open
     d72:	48bd                	li	a7,15
 ecall
     d74:	00000073          	ecall
 ret
     d78:	8082                	ret

0000000000000d7a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d7a:	48c5                	li	a7,17
 ecall
     d7c:	00000073          	ecall
 ret
     d80:	8082                	ret

0000000000000d82 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d82:	48c9                	li	a7,18
 ecall
     d84:	00000073          	ecall
 ret
     d88:	8082                	ret

0000000000000d8a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     d8a:	48a1                	li	a7,8
 ecall
     d8c:	00000073          	ecall
 ret
     d90:	8082                	ret

0000000000000d92 <link>:
.global link
link:
 li a7, SYS_link
     d92:	48cd                	li	a7,19
 ecall
     d94:	00000073          	ecall
 ret
     d98:	8082                	ret

0000000000000d9a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d9a:	48d1                	li	a7,20
 ecall
     d9c:	00000073          	ecall
 ret
     da0:	8082                	ret

0000000000000da2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     da2:	48a5                	li	a7,9
 ecall
     da4:	00000073          	ecall
 ret
     da8:	8082                	ret

0000000000000daa <dup>:
.global dup
dup:
 li a7, SYS_dup
     daa:	48a9                	li	a7,10
 ecall
     dac:	00000073          	ecall
 ret
     db0:	8082                	ret

0000000000000db2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     db2:	48ad                	li	a7,11
 ecall
     db4:	00000073          	ecall
 ret
     db8:	8082                	ret

0000000000000dba <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     dba:	48b1                	li	a7,12
 ecall
     dbc:	00000073          	ecall
 ret
     dc0:	8082                	ret

0000000000000dc2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     dc2:	48b5                	li	a7,13
 ecall
     dc4:	00000073          	ecall
 ret
     dc8:	8082                	ret

0000000000000dca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     dca:	48b9                	li	a7,14
 ecall
     dcc:	00000073          	ecall
 ret
     dd0:	8082                	ret

0000000000000dd2 <trigger>:
.global trigger
trigger:
 li a7, SYS_trigger
     dd2:	48d9                	li	a7,22
 ecall
     dd4:	00000073          	ecall
 ret
     dd8:	8082                	ret

0000000000000dda <thread>:
.global thread
thread:
 li a7, SYS_thread
     dda:	48dd                	li	a7,23
 ecall
     ddc:	00000073          	ecall
 ret
     de0:	8082                	ret

0000000000000de2 <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
     de2:	48e1                	li	a7,24
 ecall
     de4:	00000073          	ecall
 ret
     de8:	8082                	ret

0000000000000dea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     dea:	1101                	addi	sp,sp,-32
     dec:	ec06                	sd	ra,24(sp)
     dee:	e822                	sd	s0,16(sp)
     df0:	1000                	addi	s0,sp,32
     df2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     df6:	4605                	li	a2,1
     df8:	fef40593          	addi	a1,s0,-17
     dfc:	f57ff0ef          	jal	d52 <write>
}
     e00:	60e2                	ld	ra,24(sp)
     e02:	6442                	ld	s0,16(sp)
     e04:	6105                	addi	sp,sp,32
     e06:	8082                	ret

0000000000000e08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e08:	7139                	addi	sp,sp,-64
     e0a:	fc06                	sd	ra,56(sp)
     e0c:	f822                	sd	s0,48(sp)
     e0e:	f426                	sd	s1,40(sp)
     e10:	0080                	addi	s0,sp,64
     e12:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e14:	c299                	beqz	a3,e1a <printint+0x12>
     e16:	0805c963          	bltz	a1,ea8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e1a:	2581                	sext.w	a1,a1
  neg = 0;
     e1c:	4881                	li	a7,0
     e1e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     e22:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e24:	2601                	sext.w	a2,a2
     e26:	00000517          	auipc	a0,0x0
     e2a:	68250513          	addi	a0,a0,1666 # 14a8 <digits>
     e2e:	883a                	mv	a6,a4
     e30:	2705                	addiw	a4,a4,1
     e32:	02c5f7bb          	remuw	a5,a1,a2
     e36:	1782                	slli	a5,a5,0x20
     e38:	9381                	srli	a5,a5,0x20
     e3a:	97aa                	add	a5,a5,a0
     e3c:	0007c783          	lbu	a5,0(a5)
     e40:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e44:	0005879b          	sext.w	a5,a1
     e48:	02c5d5bb          	divuw	a1,a1,a2
     e4c:	0685                	addi	a3,a3,1
     e4e:	fec7f0e3          	bgeu	a5,a2,e2e <printint+0x26>
  if(neg)
     e52:	00088c63          	beqz	a7,e6a <printint+0x62>
    buf[i++] = '-';
     e56:	fd070793          	addi	a5,a4,-48
     e5a:	00878733          	add	a4,a5,s0
     e5e:	02d00793          	li	a5,45
     e62:	fef70823          	sb	a5,-16(a4)
     e66:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     e6a:	02e05a63          	blez	a4,e9e <printint+0x96>
     e6e:	f04a                	sd	s2,32(sp)
     e70:	ec4e                	sd	s3,24(sp)
     e72:	fc040793          	addi	a5,s0,-64
     e76:	00e78933          	add	s2,a5,a4
     e7a:	fff78993          	addi	s3,a5,-1
     e7e:	99ba                	add	s3,s3,a4
     e80:	377d                	addiw	a4,a4,-1
     e82:	1702                	slli	a4,a4,0x20
     e84:	9301                	srli	a4,a4,0x20
     e86:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e8a:	fff94583          	lbu	a1,-1(s2)
     e8e:	8526                	mv	a0,s1
     e90:	f5bff0ef          	jal	dea <putc>
  while(--i >= 0)
     e94:	197d                	addi	s2,s2,-1
     e96:	ff391ae3          	bne	s2,s3,e8a <printint+0x82>
     e9a:	7902                	ld	s2,32(sp)
     e9c:	69e2                	ld	s3,24(sp)
}
     e9e:	70e2                	ld	ra,56(sp)
     ea0:	7442                	ld	s0,48(sp)
     ea2:	74a2                	ld	s1,40(sp)
     ea4:	6121                	addi	sp,sp,64
     ea6:	8082                	ret
    x = -xx;
     ea8:	40b005bb          	negw	a1,a1
    neg = 1;
     eac:	4885                	li	a7,1
    x = -xx;
     eae:	bf85                	j	e1e <printint+0x16>

0000000000000eb0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     eb0:	711d                	addi	sp,sp,-96
     eb2:	ec86                	sd	ra,88(sp)
     eb4:	e8a2                	sd	s0,80(sp)
     eb6:	e0ca                	sd	s2,64(sp)
     eb8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     eba:	0005c903          	lbu	s2,0(a1)
     ebe:	26090863          	beqz	s2,112e <vprintf+0x27e>
     ec2:	e4a6                	sd	s1,72(sp)
     ec4:	fc4e                	sd	s3,56(sp)
     ec6:	f852                	sd	s4,48(sp)
     ec8:	f456                	sd	s5,40(sp)
     eca:	f05a                	sd	s6,32(sp)
     ecc:	ec5e                	sd	s7,24(sp)
     ece:	e862                	sd	s8,16(sp)
     ed0:	e466                	sd	s9,8(sp)
     ed2:	8b2a                	mv	s6,a0
     ed4:	8a2e                	mv	s4,a1
     ed6:	8bb2                	mv	s7,a2
  state = 0;
     ed8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     eda:	4481                	li	s1,0
     edc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     ede:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     ee2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     ee6:	06c00c93          	li	s9,108
     eea:	a005                	j	f0a <vprintf+0x5a>
        putc(fd, c0);
     eec:	85ca                	mv	a1,s2
     eee:	855a                	mv	a0,s6
     ef0:	efbff0ef          	jal	dea <putc>
     ef4:	a019                	j	efa <vprintf+0x4a>
    } else if(state == '%'){
     ef6:	03598263          	beq	s3,s5,f1a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     efa:	2485                	addiw	s1,s1,1
     efc:	8726                	mv	a4,s1
     efe:	009a07b3          	add	a5,s4,s1
     f02:	0007c903          	lbu	s2,0(a5)
     f06:	20090c63          	beqz	s2,111e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     f0a:	0009079b          	sext.w	a5,s2
    if(state == 0){
     f0e:	fe0994e3          	bnez	s3,ef6 <vprintf+0x46>
      if(c0 == '%'){
     f12:	fd579de3          	bne	a5,s5,eec <vprintf+0x3c>
        state = '%';
     f16:	89be                	mv	s3,a5
     f18:	b7cd                	j	efa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     f1a:	00ea06b3          	add	a3,s4,a4
     f1e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     f22:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     f24:	c681                	beqz	a3,f2c <vprintf+0x7c>
     f26:	9752                	add	a4,a4,s4
     f28:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     f2c:	03878f63          	beq	a5,s8,f6a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     f30:	05978963          	beq	a5,s9,f82 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     f34:	07500713          	li	a4,117
     f38:	0ee78363          	beq	a5,a4,101e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     f3c:	07800713          	li	a4,120
     f40:	12e78563          	beq	a5,a4,106a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     f44:	07000713          	li	a4,112
     f48:	14e78a63          	beq	a5,a4,109c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     f4c:	07300713          	li	a4,115
     f50:	18e78a63          	beq	a5,a4,10e4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     f54:	02500713          	li	a4,37
     f58:	04e79563          	bne	a5,a4,fa2 <vprintf+0xf2>
        putc(fd, '%');
     f5c:	02500593          	li	a1,37
     f60:	855a                	mv	a0,s6
     f62:	e89ff0ef          	jal	dea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     f66:	4981                	li	s3,0
     f68:	bf49                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     f6a:	008b8913          	addi	s2,s7,8
     f6e:	4685                	li	a3,1
     f70:	4629                	li	a2,10
     f72:	000ba583          	lw	a1,0(s7)
     f76:	855a                	mv	a0,s6
     f78:	e91ff0ef          	jal	e08 <printint>
     f7c:	8bca                	mv	s7,s2
      state = 0;
     f7e:	4981                	li	s3,0
     f80:	bfad                	j	efa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     f82:	06400793          	li	a5,100
     f86:	02f68963          	beq	a3,a5,fb8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f8a:	06c00793          	li	a5,108
     f8e:	04f68263          	beq	a3,a5,fd2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     f92:	07500793          	li	a5,117
     f96:	0af68063          	beq	a3,a5,1036 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     f9a:	07800793          	li	a5,120
     f9e:	0ef68263          	beq	a3,a5,1082 <vprintf+0x1d2>
        putc(fd, '%');
     fa2:	02500593          	li	a1,37
     fa6:	855a                	mv	a0,s6
     fa8:	e43ff0ef          	jal	dea <putc>
        putc(fd, c0);
     fac:	85ca                	mv	a1,s2
     fae:	855a                	mv	a0,s6
     fb0:	e3bff0ef          	jal	dea <putc>
      state = 0;
     fb4:	4981                	li	s3,0
     fb6:	b791                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     fb8:	008b8913          	addi	s2,s7,8
     fbc:	4685                	li	a3,1
     fbe:	4629                	li	a2,10
     fc0:	000ba583          	lw	a1,0(s7)
     fc4:	855a                	mv	a0,s6
     fc6:	e43ff0ef          	jal	e08 <printint>
        i += 1;
     fca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     fcc:	8bca                	mv	s7,s2
      state = 0;
     fce:	4981                	li	s3,0
        i += 1;
     fd0:	b72d                	j	efa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     fd2:	06400793          	li	a5,100
     fd6:	02f60763          	beq	a2,a5,1004 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     fda:	07500793          	li	a5,117
     fde:	06f60963          	beq	a2,a5,1050 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     fe2:	07800793          	li	a5,120
     fe6:	faf61ee3          	bne	a2,a5,fa2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fea:	008b8913          	addi	s2,s7,8
     fee:	4681                	li	a3,0
     ff0:	4641                	li	a2,16
     ff2:	000ba583          	lw	a1,0(s7)
     ff6:	855a                	mv	a0,s6
     ff8:	e11ff0ef          	jal	e08 <printint>
        i += 2;
     ffc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     ffe:	8bca                	mv	s7,s2
      state = 0;
    1000:	4981                	li	s3,0
        i += 2;
    1002:	bde5                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1004:	008b8913          	addi	s2,s7,8
    1008:	4685                	li	a3,1
    100a:	4629                	li	a2,10
    100c:	000ba583          	lw	a1,0(s7)
    1010:	855a                	mv	a0,s6
    1012:	df7ff0ef          	jal	e08 <printint>
        i += 2;
    1016:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1018:	8bca                	mv	s7,s2
      state = 0;
    101a:	4981                	li	s3,0
        i += 2;
    101c:	bdf9                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    101e:	008b8913          	addi	s2,s7,8
    1022:	4681                	li	a3,0
    1024:	4629                	li	a2,10
    1026:	000ba583          	lw	a1,0(s7)
    102a:	855a                	mv	a0,s6
    102c:	dddff0ef          	jal	e08 <printint>
    1030:	8bca                	mv	s7,s2
      state = 0;
    1032:	4981                	li	s3,0
    1034:	b5d9                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1036:	008b8913          	addi	s2,s7,8
    103a:	4681                	li	a3,0
    103c:	4629                	li	a2,10
    103e:	000ba583          	lw	a1,0(s7)
    1042:	855a                	mv	a0,s6
    1044:	dc5ff0ef          	jal	e08 <printint>
        i += 1;
    1048:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    104a:	8bca                	mv	s7,s2
      state = 0;
    104c:	4981                	li	s3,0
        i += 1;
    104e:	b575                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1050:	008b8913          	addi	s2,s7,8
    1054:	4681                	li	a3,0
    1056:	4629                	li	a2,10
    1058:	000ba583          	lw	a1,0(s7)
    105c:	855a                	mv	a0,s6
    105e:	dabff0ef          	jal	e08 <printint>
        i += 2;
    1062:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1064:	8bca                	mv	s7,s2
      state = 0;
    1066:	4981                	li	s3,0
        i += 2;
    1068:	bd49                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    106a:	008b8913          	addi	s2,s7,8
    106e:	4681                	li	a3,0
    1070:	4641                	li	a2,16
    1072:	000ba583          	lw	a1,0(s7)
    1076:	855a                	mv	a0,s6
    1078:	d91ff0ef          	jal	e08 <printint>
    107c:	8bca                	mv	s7,s2
      state = 0;
    107e:	4981                	li	s3,0
    1080:	bdad                	j	efa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1082:	008b8913          	addi	s2,s7,8
    1086:	4681                	li	a3,0
    1088:	4641                	li	a2,16
    108a:	000ba583          	lw	a1,0(s7)
    108e:	855a                	mv	a0,s6
    1090:	d79ff0ef          	jal	e08 <printint>
        i += 1;
    1094:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1096:	8bca                	mv	s7,s2
      state = 0;
    1098:	4981                	li	s3,0
        i += 1;
    109a:	b585                	j	efa <vprintf+0x4a>
    109c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    109e:	008b8d13          	addi	s10,s7,8
    10a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10a6:	03000593          	li	a1,48
    10aa:	855a                	mv	a0,s6
    10ac:	d3fff0ef          	jal	dea <putc>
  putc(fd, 'x');
    10b0:	07800593          	li	a1,120
    10b4:	855a                	mv	a0,s6
    10b6:	d35ff0ef          	jal	dea <putc>
    10ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10bc:	00000b97          	auipc	s7,0x0
    10c0:	3ecb8b93          	addi	s7,s7,1004 # 14a8 <digits>
    10c4:	03c9d793          	srli	a5,s3,0x3c
    10c8:	97de                	add	a5,a5,s7
    10ca:	0007c583          	lbu	a1,0(a5)
    10ce:	855a                	mv	a0,s6
    10d0:	d1bff0ef          	jal	dea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10d4:	0992                	slli	s3,s3,0x4
    10d6:	397d                	addiw	s2,s2,-1
    10d8:	fe0916e3          	bnez	s2,10c4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    10dc:	8bea                	mv	s7,s10
      state = 0;
    10de:	4981                	li	s3,0
    10e0:	6d02                	ld	s10,0(sp)
    10e2:	bd21                	j	efa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    10e4:	008b8993          	addi	s3,s7,8
    10e8:	000bb903          	ld	s2,0(s7)
    10ec:	00090f63          	beqz	s2,110a <vprintf+0x25a>
        for(; *s; s++)
    10f0:	00094583          	lbu	a1,0(s2)
    10f4:	c195                	beqz	a1,1118 <vprintf+0x268>
          putc(fd, *s);
    10f6:	855a                	mv	a0,s6
    10f8:	cf3ff0ef          	jal	dea <putc>
        for(; *s; s++)
    10fc:	0905                	addi	s2,s2,1
    10fe:	00094583          	lbu	a1,0(s2)
    1102:	f9f5                	bnez	a1,10f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1104:	8bce                	mv	s7,s3
      state = 0;
    1106:	4981                	li	s3,0
    1108:	bbcd                	j	efa <vprintf+0x4a>
          s = "(null)";
    110a:	00000917          	auipc	s2,0x0
    110e:	36690913          	addi	s2,s2,870 # 1470 <malloc+0x25a>
        for(; *s; s++)
    1112:	02800593          	li	a1,40
    1116:	b7c5                	j	10f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1118:	8bce                	mv	s7,s3
      state = 0;
    111a:	4981                	li	s3,0
    111c:	bbf9                	j	efa <vprintf+0x4a>
    111e:	64a6                	ld	s1,72(sp)
    1120:	79e2                	ld	s3,56(sp)
    1122:	7a42                	ld	s4,48(sp)
    1124:	7aa2                	ld	s5,40(sp)
    1126:	7b02                	ld	s6,32(sp)
    1128:	6be2                	ld	s7,24(sp)
    112a:	6c42                	ld	s8,16(sp)
    112c:	6ca2                	ld	s9,8(sp)
    }
  }
}
    112e:	60e6                	ld	ra,88(sp)
    1130:	6446                	ld	s0,80(sp)
    1132:	6906                	ld	s2,64(sp)
    1134:	6125                	addi	sp,sp,96
    1136:	8082                	ret

0000000000001138 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1138:	715d                	addi	sp,sp,-80
    113a:	ec06                	sd	ra,24(sp)
    113c:	e822                	sd	s0,16(sp)
    113e:	1000                	addi	s0,sp,32
    1140:	e010                	sd	a2,0(s0)
    1142:	e414                	sd	a3,8(s0)
    1144:	e818                	sd	a4,16(s0)
    1146:	ec1c                	sd	a5,24(s0)
    1148:	03043023          	sd	a6,32(s0)
    114c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1150:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1154:	8622                	mv	a2,s0
    1156:	d5bff0ef          	jal	eb0 <vprintf>
}
    115a:	60e2                	ld	ra,24(sp)
    115c:	6442                	ld	s0,16(sp)
    115e:	6161                	addi	sp,sp,80
    1160:	8082                	ret

0000000000001162 <printf>:

void
printf(const char *fmt, ...)
{
    1162:	711d                	addi	sp,sp,-96
    1164:	ec06                	sd	ra,24(sp)
    1166:	e822                	sd	s0,16(sp)
    1168:	1000                	addi	s0,sp,32
    116a:	e40c                	sd	a1,8(s0)
    116c:	e810                	sd	a2,16(s0)
    116e:	ec14                	sd	a3,24(s0)
    1170:	f018                	sd	a4,32(s0)
    1172:	f41c                	sd	a5,40(s0)
    1174:	03043823          	sd	a6,48(s0)
    1178:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    117c:	00840613          	addi	a2,s0,8
    1180:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1184:	85aa                	mv	a1,a0
    1186:	4505                	li	a0,1
    1188:	d29ff0ef          	jal	eb0 <vprintf>
}
    118c:	60e2                	ld	ra,24(sp)
    118e:	6442                	ld	s0,16(sp)
    1190:	6125                	addi	sp,sp,96
    1192:	8082                	ret

0000000000001194 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1194:	1141                	addi	sp,sp,-16
    1196:	e422                	sd	s0,8(sp)
    1198:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    119a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    119e:	00001797          	auipc	a5,0x1
    11a2:	e727b783          	ld	a5,-398(a5) # 2010 <freep>
    11a6:	a02d                	j	11d0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11a8:	4618                	lw	a4,8(a2)
    11aa:	9f2d                	addw	a4,a4,a1
    11ac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11b0:	6398                	ld	a4,0(a5)
    11b2:	6310                	ld	a2,0(a4)
    11b4:	a83d                	j	11f2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11b6:	ff852703          	lw	a4,-8(a0)
    11ba:	9f31                	addw	a4,a4,a2
    11bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11be:	ff053683          	ld	a3,-16(a0)
    11c2:	a091                	j	1206 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11c4:	6398                	ld	a4,0(a5)
    11c6:	00e7e463          	bltu	a5,a4,11ce <free+0x3a>
    11ca:	00e6ea63          	bltu	a3,a4,11de <free+0x4a>
{
    11ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d0:	fed7fae3          	bgeu	a5,a3,11c4 <free+0x30>
    11d4:	6398                	ld	a4,0(a5)
    11d6:	00e6e463          	bltu	a3,a4,11de <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11da:	fee7eae3          	bltu	a5,a4,11ce <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11de:	ff852583          	lw	a1,-8(a0)
    11e2:	6390                	ld	a2,0(a5)
    11e4:	02059813          	slli	a6,a1,0x20
    11e8:	01c85713          	srli	a4,a6,0x1c
    11ec:	9736                	add	a4,a4,a3
    11ee:	fae60de3          	beq	a2,a4,11a8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11f6:	4790                	lw	a2,8(a5)
    11f8:	02061593          	slli	a1,a2,0x20
    11fc:	01c5d713          	srli	a4,a1,0x1c
    1200:	973e                	add	a4,a4,a5
    1202:	fae68ae3          	beq	a3,a4,11b6 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1206:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1208:	00001717          	auipc	a4,0x1
    120c:	e0f73423          	sd	a5,-504(a4) # 2010 <freep>
}
    1210:	6422                	ld	s0,8(sp)
    1212:	0141                	addi	sp,sp,16
    1214:	8082                	ret

0000000000001216 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1216:	7139                	addi	sp,sp,-64
    1218:	fc06                	sd	ra,56(sp)
    121a:	f822                	sd	s0,48(sp)
    121c:	f426                	sd	s1,40(sp)
    121e:	ec4e                	sd	s3,24(sp)
    1220:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1222:	02051493          	slli	s1,a0,0x20
    1226:	9081                	srli	s1,s1,0x20
    1228:	04bd                	addi	s1,s1,15
    122a:	8091                	srli	s1,s1,0x4
    122c:	0014899b          	addiw	s3,s1,1
    1230:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1232:	00001517          	auipc	a0,0x1
    1236:	dde53503          	ld	a0,-546(a0) # 2010 <freep>
    123a:	c915                	beqz	a0,126e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    123c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    123e:	4798                	lw	a4,8(a5)
    1240:	08977a63          	bgeu	a4,s1,12d4 <malloc+0xbe>
    1244:	f04a                	sd	s2,32(sp)
    1246:	e852                	sd	s4,16(sp)
    1248:	e456                	sd	s5,8(sp)
    124a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    124c:	8a4e                	mv	s4,s3
    124e:	0009871b          	sext.w	a4,s3
    1252:	6685                	lui	a3,0x1
    1254:	00d77363          	bgeu	a4,a3,125a <malloc+0x44>
    1258:	6a05                	lui	s4,0x1
    125a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    125e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1262:	00001917          	auipc	s2,0x1
    1266:	dae90913          	addi	s2,s2,-594 # 2010 <freep>
  if(p == (char*)-1)
    126a:	5afd                	li	s5,-1
    126c:	a081                	j	12ac <malloc+0x96>
    126e:	f04a                	sd	s2,32(sp)
    1270:	e852                	sd	s4,16(sp)
    1272:	e456                	sd	s5,8(sp)
    1274:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1276:	00001797          	auipc	a5,0x1
    127a:	e1278793          	addi	a5,a5,-494 # 2088 <base>
    127e:	00001717          	auipc	a4,0x1
    1282:	d8f73923          	sd	a5,-622(a4) # 2010 <freep>
    1286:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1288:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    128c:	b7c1                	j	124c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    128e:	6398                	ld	a4,0(a5)
    1290:	e118                	sd	a4,0(a0)
    1292:	a8a9                	j	12ec <malloc+0xd6>
  hp->s.size = nu;
    1294:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1298:	0541                	addi	a0,a0,16
    129a:	efbff0ef          	jal	1194 <free>
  return freep;
    129e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12a2:	c12d                	beqz	a0,1304 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12a6:	4798                	lw	a4,8(a5)
    12a8:	02977263          	bgeu	a4,s1,12cc <malloc+0xb6>
    if(p == freep)
    12ac:	00093703          	ld	a4,0(s2)
    12b0:	853e                	mv	a0,a5
    12b2:	fef719e3          	bne	a4,a5,12a4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    12b6:	8552                	mv	a0,s4
    12b8:	b03ff0ef          	jal	dba <sbrk>
  if(p == (char*)-1)
    12bc:	fd551ce3          	bne	a0,s5,1294 <malloc+0x7e>
        return 0;
    12c0:	4501                	li	a0,0
    12c2:	7902                	ld	s2,32(sp)
    12c4:	6a42                	ld	s4,16(sp)
    12c6:	6aa2                	ld	s5,8(sp)
    12c8:	6b02                	ld	s6,0(sp)
    12ca:	a03d                	j	12f8 <malloc+0xe2>
    12cc:	7902                	ld	s2,32(sp)
    12ce:	6a42                	ld	s4,16(sp)
    12d0:	6aa2                	ld	s5,8(sp)
    12d2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    12d4:	fae48de3          	beq	s1,a4,128e <malloc+0x78>
        p->s.size -= nunits;
    12d8:	4137073b          	subw	a4,a4,s3
    12dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12de:	02071693          	slli	a3,a4,0x20
    12e2:	01c6d713          	srli	a4,a3,0x1c
    12e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12ec:	00001717          	auipc	a4,0x1
    12f0:	d2a73223          	sd	a0,-732(a4) # 2010 <freep>
      return (void*)(p + 1);
    12f4:	01078513          	addi	a0,a5,16
  }
}
    12f8:	70e2                	ld	ra,56(sp)
    12fa:	7442                	ld	s0,48(sp)
    12fc:	74a2                	ld	s1,40(sp)
    12fe:	69e2                	ld	s3,24(sp)
    1300:	6121                	addi	sp,sp,64
    1302:	8082                	ret
    1304:	7902                	ld	s2,32(sp)
    1306:	6a42                	ld	s4,16(sp)
    1308:	6aa2                	ld	s5,8(sp)
    130a:	6b02                	ld	s6,0(sp)
    130c:	b7f5                	j	12f8 <malloc+0xe2>
