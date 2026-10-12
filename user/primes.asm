
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
#define WRITE_END 1

// Moi process xu ly mot so nguyen to
void primes(int left_pipe[2]) __attribute__((noreturn));

void primes(int left_pipe[2]) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int num;
    int n;
    int right_pipe[2];

    // Process nay chi doc tu pipe dau vao
    close(left_pipe[WRITE_END]);
   c:	4148                	lw	a0,4(a0)
   e:	45c000ef          	jal	ra,46a <close>

    // So dau tien doc duoc la so nguyen to
    n = read(left_pipe[READ_END], &prime, sizeof(int));
  12:	4611                	li	a2,4
  14:	fdc40593          	addi	a1,s0,-36
  18:	4088                	lw	a0,0(s1)
  1a:	440000ef          	jal	ra,45a <read>

    // Het du lieu thi dong pipe va ket thuc
    if (n == 0) {
  1e:	c911                	beqz	a0,32 <primes+0x32>
        close(left_pipe[READ_END]);
        exit(0);
    }

    if (n != sizeof(int)) {
  20:	4791                	li	a5,4
  22:	00f50e63          	beq	a0,a5,3e <primes+0x3e>
        close(left_pipe[READ_END]);
  26:	4088                	lw	a0,0(s1)
  28:	442000ef          	jal	ra,46a <close>
        exit(1);
  2c:	4505                	li	a0,1
  2e:	414000ef          	jal	ra,442 <exit>
        close(left_pipe[READ_END]);
  32:	4088                	lw	a0,0(s1)
  34:	436000ef          	jal	ra,46a <close>
        exit(0);
  38:	4501                	li	a0,0
  3a:	408000ef          	jal	ra,442 <exit>
    }

    printf("prime %d\n", prime);
  3e:	fdc42583          	lw	a1,-36(s0)
  42:	00001517          	auipc	a0,0x1
  46:	99e50513          	addi	a0,a0,-1634 # 9e0 <malloc+0xde>
  4a:	005000ef          	jal	ra,84e <printf>

    // Tao pipe moi cho process tiep theo
    if (pipe(right_pipe) < 0) {
  4e:	fd040513          	addi	a0,s0,-48
  52:	400000ef          	jal	ra,452 <pipe>
  56:	00054e63          	bltz	a0,72 <primes+0x72>
        close(left_pipe[READ_END]);
        exit(1);
    }

    int pid = fork();
  5a:	3e0000ef          	jal	ra,43a <fork>

    if (pid < 0) {
  5e:	02054063          	bltz	a0,7e <primes+0x7e>
        close(right_pipe[READ_END]);
        close(right_pipe[WRITE_END]);
        exit(1);
    }

    if (pid == 0) {
  62:	ed05                	bnez	a0,9a <primes+0x9a>
        // Process con xu ly stage tiep theo
        close(left_pipe[READ_END]);
  64:	4088                	lw	a0,0(s1)
  66:	404000ef          	jal	ra,46a <close>
        primes(right_pipe);
  6a:	fd040513          	addi	a0,s0,-48
  6e:	f93ff0ef          	jal	ra,0 <primes>
        close(left_pipe[READ_END]);
  72:	4088                	lw	a0,0(s1)
  74:	3f6000ef          	jal	ra,46a <close>
        exit(1);
  78:	4505                	li	a0,1
  7a:	3c8000ef          	jal	ra,442 <exit>
        close(left_pipe[READ_END]);
  7e:	4088                	lw	a0,0(s1)
  80:	3ea000ef          	jal	ra,46a <close>
        close(right_pipe[READ_END]);
  84:	fd042503          	lw	a0,-48(s0)
  88:	3e2000ef          	jal	ra,46a <close>
        close(right_pipe[WRITE_END]);
  8c:	fd442503          	lw	a0,-44(s0)
  90:	3da000ef          	jal	ra,46a <close>
        exit(1);
  94:	4505                	li	a0,1
  96:	3ac000ef          	jal	ra,442 <exit>
    }

    // Process cha chi ghi vao pipe dau ra
    close(right_pipe[READ_END]);
  9a:	fd042503          	lw	a0,-48(s0)
  9e:	3cc000ef          	jal	ra,46a <close>

    // Loai cac boi cua prime va chuyen so con lai
    while ((n = read(left_pipe[READ_END], &num, sizeof(int))) == sizeof(int)) {
  a2:	4611                	li	a2,4
  a4:	fd840593          	addi	a1,s0,-40
  a8:	4088                	lw	a0,0(s1)
  aa:	3b0000ef          	jal	ra,45a <read>
  ae:	4791                	li	a5,4
  b0:	04f51063          	bne	a0,a5,f0 <primes+0xf0>
        if (num % prime != 0) {
  b4:	fd842783          	lw	a5,-40(s0)
  b8:	fdc42703          	lw	a4,-36(s0)
  bc:	02e7e7bb          	remw	a5,a5,a4
  c0:	d3ed                	beqz	a5,a2 <primes+0xa2>
            if (write(right_pipe[WRITE_END], &num, sizeof(int)) != sizeof(int)) {
  c2:	4611                	li	a2,4
  c4:	fd840593          	addi	a1,s0,-40
  c8:	fd442503          	lw	a0,-44(s0)
  cc:	396000ef          	jal	ra,462 <write>
  d0:	4791                	li	a5,4
  d2:	fcf508e3          	beq	a0,a5,a2 <primes+0xa2>
                close(left_pipe[READ_END]);
  d6:	4088                	lw	a0,0(s1)
  d8:	392000ef          	jal	ra,46a <close>
                close(right_pipe[WRITE_END]);
  dc:	fd442503          	lw	a0,-44(s0)
  e0:	38a000ef          	jal	ra,46a <close>
                wait(0);
  e4:	4501                	li	a0,0
  e6:	364000ef          	jal	ra,44a <wait>
                exit(1);
  ea:	4505                	li	a0,1
  ec:	356000ef          	jal	ra,442 <exit>
            }
        }
    }

    // Dong pipe de process tiep theo nhan EOF
    close(left_pipe[READ_END]);
  f0:	4088                	lw	a0,0(s1)
  f2:	378000ef          	jal	ra,46a <close>
    close(right_pipe[WRITE_END]);
  f6:	fd442503          	lw	a0,-44(s0)
  fa:	370000ef          	jal	ra,46a <close>

    // Cho process con va cac stage phia sau ket thuc
    wait(0);
  fe:	4501                	li	a0,0
 100:	34a000ef          	jal	ra,44a <wait>

    exit(0);
 104:	4501                	li	a0,0
 106:	33c000ef          	jal	ra,442 <exit>

000000000000010a <main>:
}

int main(int argc, char *argv[]) {
 10a:	7179                	addi	sp,sp,-48
 10c:	f406                	sd	ra,40(sp)
 10e:	f022                	sd	s0,32(sp)
 110:	ec26                	sd	s1,24(sp)
 112:	1800                	addi	s0,sp,48
    int p[2];

    // Tao pipe dau tien
    if (pipe(p) < 0) {
 114:	fd840513          	addi	a0,s0,-40
 118:	33a000ef          	jal	ra,452 <pipe>
 11c:	00054b63          	bltz	a0,132 <main+0x28>
        fprintf(2, "primes: pipe failed\n");
        exit(1);
    }

    int pid = fork();
 120:	31a000ef          	jal	ra,43a <fork>

    if (pid < 0) {
 124:	02054163          	bltz	a0,146 <main+0x3c>
        close(p[WRITE_END]);
        fprintf(2, "primes: fork failed\n");
        exit(1);
    }

    if (pid == 0) {
 128:	e129                	bnez	a0,16a <main+0x60>
        // Process con bat dau sang so nguyen to
        primes(p);
 12a:	fd840513          	addi	a0,s0,-40
 12e:	ed3ff0ef          	jal	ra,0 <primes>
        fprintf(2, "primes: pipe failed\n");
 132:	00001597          	auipc	a1,0x1
 136:	8be58593          	addi	a1,a1,-1858 # 9f0 <malloc+0xee>
 13a:	4509                	li	a0,2
 13c:	6e8000ef          	jal	ra,824 <fprintf>
        exit(1);
 140:	4505                	li	a0,1
 142:	300000ef          	jal	ra,442 <exit>
        close(p[READ_END]);
 146:	fd842503          	lw	a0,-40(s0)
 14a:	320000ef          	jal	ra,46a <close>
        close(p[WRITE_END]);
 14e:	fdc42503          	lw	a0,-36(s0)
 152:	318000ef          	jal	ra,46a <close>
        fprintf(2, "primes: fork failed\n");
 156:	00001597          	auipc	a1,0x1
 15a:	8b258593          	addi	a1,a1,-1870 # a08 <malloc+0x106>
 15e:	4509                	li	a0,2
 160:	6c4000ef          	jal	ra,824 <fprintf>
        exit(1);
 164:	4505                	li	a0,1
 166:	2dc000ef          	jal	ra,442 <exit>
    }

    // Process chinh chi ghi day so vao pipe
    close(p[READ_END]);
 16a:	fd842503          	lw	a0,-40(s0)
 16e:	2fc000ef          	jal	ra,46a <close>

    // Gui cac so nguyen tu 2 den 280
    for (int i = 2; i <= 280; i++) {
 172:	4789                	li	a5,2
 174:	fcf42a23          	sw	a5,-44(s0)
 178:	11800493          	li	s1,280
        if (write(p[WRITE_END], &i, sizeof(int))
 17c:	4611                	li	a2,4
 17e:	fd440593          	addi	a1,s0,-44
 182:	fdc42503          	lw	a0,-36(s0)
 186:	2dc000ef          	jal	ra,462 <write>
 18a:	4791                	li	a5,4
 18c:	02f51563          	bne	a0,a5,1b6 <main+0xac>
    for (int i = 2; i <= 280; i++) {
 190:	fd442783          	lw	a5,-44(s0)
 194:	2785                	addiw	a5,a5,1
 196:	0007871b          	sext.w	a4,a5
 19a:	fcf42a23          	sw	a5,-44(s0)
 19e:	fce4dfe3          	bge	s1,a4,17c <main+0x72>
            exit(1);
        }
    }

    // Dong dau ghi de bao hieu het du lieu
    close(p[WRITE_END]);
 1a2:	fdc42503          	lw	a0,-36(s0)
 1a6:	2c4000ef          	jal	ra,46a <close>

    // Cho toan bo pipeline ket thuc
    wait(0);
 1aa:	4501                	li	a0,0
 1ac:	29e000ef          	jal	ra,44a <wait>

    exit(0);
 1b0:	4501                	li	a0,0
 1b2:	290000ef          	jal	ra,442 <exit>
            close(p[WRITE_END]);
 1b6:	fdc42503          	lw	a0,-36(s0)
 1ba:	2b0000ef          	jal	ra,46a <close>
            wait(0);
 1be:	4501                	li	a0,0
 1c0:	28a000ef          	jal	ra,44a <wait>
            fprintf(2, "primes: write failed\n");
 1c4:	00001597          	auipc	a1,0x1
 1c8:	85c58593          	addi	a1,a1,-1956 # a20 <malloc+0x11e>
 1cc:	4509                	li	a0,2
 1ce:	656000ef          	jal	ra,824 <fprintf>
            exit(1);
 1d2:	4505                	li	a0,1
 1d4:	26e000ef          	jal	ra,442 <exit>

00000000000001d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e406                	sd	ra,8(sp)
 1dc:	e022                	sd	s0,0(sp)
 1de:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1e0:	f2bff0ef          	jal	ra,10a <main>
  exit(0);
 1e4:	4501                	li	a0,0
 1e6:	25c000ef          	jal	ra,442 <exit>

00000000000001ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f0:	87aa                	mv	a5,a0
 1f2:	0585                	addi	a1,a1,1
 1f4:	0785                	addi	a5,a5,1
 1f6:	fff5c703          	lbu	a4,-1(a1)
 1fa:	fee78fa3          	sb	a4,-1(a5)
 1fe:	fb75                	bnez	a4,1f2 <strcpy+0x8>
    ;
  return os;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 20c:	00054783          	lbu	a5,0(a0)
 210:	cb91                	beqz	a5,224 <strcmp+0x1e>
 212:	0005c703          	lbu	a4,0(a1)
 216:	00f71763          	bne	a4,a5,224 <strcmp+0x1e>
    p++, q++;
 21a:	0505                	addi	a0,a0,1
 21c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 21e:	00054783          	lbu	a5,0(a0)
 222:	fbe5                	bnez	a5,212 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 224:	0005c503          	lbu	a0,0(a1)
}
 228:	40a7853b          	subw	a0,a5,a0
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strlen>:

uint
strlen(const char *s)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cf91                	beqz	a5,258 <strlen+0x26>
 23e:	0505                	addi	a0,a0,1
 240:	87aa                	mv	a5,a0
 242:	4685                	li	a3,1
 244:	9e89                	subw	a3,a3,a0
 246:	00f6853b          	addw	a0,a3,a5
 24a:	0785                	addi	a5,a5,1
 24c:	fff7c703          	lbu	a4,-1(a5)
 250:	fb7d                	bnez	a4,246 <strlen+0x14>
    ;
  return n;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  for(n = 0; s[n]; n++)
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <strlen+0x20>

000000000000025c <memset>:

void*
memset(void *dst, int c, uint n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 262:	ca19                	beqz	a2,278 <memset+0x1c>
 264:	87aa                	mv	a5,a0
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 26e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 272:	0785                	addi	a5,a5,1
 274:	fee79de3          	bne	a5,a4,26e <memset+0x12>
  }
  return dst;
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret

000000000000027e <strchr>:

char*
strchr(const char *s, char c)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  for(; *s; s++)
 284:	00054783          	lbu	a5,0(a0)
 288:	cb99                	beqz	a5,29e <strchr+0x20>
    if(*s == c)
 28a:	00f58763          	beq	a1,a5,298 <strchr+0x1a>
  for(; *s; s++)
 28e:	0505                	addi	a0,a0,1
 290:	00054783          	lbu	a5,0(a0)
 294:	fbfd                	bnez	a5,28a <strchr+0xc>
      return (char*)s;
  return 0;
 296:	4501                	li	a0,0
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <strchr+0x1a>

00000000000002a2 <gets>:

char*
gets(char *buf, int max)
{
 2a2:	711d                	addi	sp,sp,-96
 2a4:	ec86                	sd	ra,88(sp)
 2a6:	e8a2                	sd	s0,80(sp)
 2a8:	e4a6                	sd	s1,72(sp)
 2aa:	e0ca                	sd	s2,64(sp)
 2ac:	fc4e                	sd	s3,56(sp)
 2ae:	f852                	sd	s4,48(sp)
 2b0:	f456                	sd	s5,40(sp)
 2b2:	f05a                	sd	s6,32(sp)
 2b4:	ec5e                	sd	s7,24(sp)
 2b6:	1080                	addi	s0,sp,96
 2b8:	8baa                	mv	s7,a0
 2ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2bc:	892a                	mv	s2,a0
 2be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c0:	4aa9                	li	s5,10
 2c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2c4:	89a6                	mv	s3,s1
 2c6:	2485                	addiw	s1,s1,1
 2c8:	0344d663          	bge	s1,s4,2f4 <gets+0x52>
    cc = read(0, &c, 1);
 2cc:	4605                	li	a2,1
 2ce:	faf40593          	addi	a1,s0,-81
 2d2:	4501                	li	a0,0
 2d4:	186000ef          	jal	ra,45a <read>
    if(cc < 1)
 2d8:	00a05e63          	blez	a0,2f4 <gets+0x52>
    buf[i++] = c;
 2dc:	faf44783          	lbu	a5,-81(s0)
 2e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2e4:	01578763          	beq	a5,s5,2f2 <gets+0x50>
 2e8:	0905                	addi	s2,s2,1
 2ea:	fd679de3          	bne	a5,s6,2c4 <gets+0x22>
  for(i=0; i+1 < max; ){
 2ee:	89a6                	mv	s3,s1
 2f0:	a011                	j	2f4 <gets+0x52>
 2f2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2f4:	99de                	add	s3,s3,s7
 2f6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2fa:	855e                	mv	a0,s7
 2fc:	60e6                	ld	ra,88(sp)
 2fe:	6446                	ld	s0,80(sp)
 300:	64a6                	ld	s1,72(sp)
 302:	6906                	ld	s2,64(sp)
 304:	79e2                	ld	s3,56(sp)
 306:	7a42                	ld	s4,48(sp)
 308:	7aa2                	ld	s5,40(sp)
 30a:	7b02                	ld	s6,32(sp)
 30c:	6be2                	ld	s7,24(sp)
 30e:	6125                	addi	sp,sp,96
 310:	8082                	ret

0000000000000312 <stat>:

int
stat(const char *n, struct stat *st)
{
 312:	1101                	addi	sp,sp,-32
 314:	ec06                	sd	ra,24(sp)
 316:	e822                	sd	s0,16(sp)
 318:	e426                	sd	s1,8(sp)
 31a:	e04a                	sd	s2,0(sp)
 31c:	1000                	addi	s0,sp,32
 31e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 320:	4581                	li	a1,0
 322:	160000ef          	jal	ra,482 <open>
  if(fd < 0)
 326:	02054163          	bltz	a0,348 <stat+0x36>
 32a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 32c:	85ca                	mv	a1,s2
 32e:	16c000ef          	jal	ra,49a <fstat>
 332:	892a                	mv	s2,a0
  close(fd);
 334:	8526                	mv	a0,s1
 336:	134000ef          	jal	ra,46a <close>
  return r;
}
 33a:	854a                	mv	a0,s2
 33c:	60e2                	ld	ra,24(sp)
 33e:	6442                	ld	s0,16(sp)
 340:	64a2                	ld	s1,8(sp)
 342:	6902                	ld	s2,0(sp)
 344:	6105                	addi	sp,sp,32
 346:	8082                	ret
    return -1;
 348:	597d                	li	s2,-1
 34a:	bfc5                	j	33a <stat+0x28>

000000000000034c <atoi>:

int
atoi(const char *s)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 352:	00054683          	lbu	a3,0(a0)
 356:	fd06879b          	addiw	a5,a3,-48
 35a:	0ff7f793          	zext.b	a5,a5
 35e:	4625                	li	a2,9
 360:	02f66863          	bltu	a2,a5,390 <atoi+0x44>
 364:	872a                	mv	a4,a0
  n = 0;
 366:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 368:	0705                	addi	a4,a4,1
 36a:	0025179b          	slliw	a5,a0,0x2
 36e:	9fa9                	addw	a5,a5,a0
 370:	0017979b          	slliw	a5,a5,0x1
 374:	9fb5                	addw	a5,a5,a3
 376:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37a:	00074683          	lbu	a3,0(a4)
 37e:	fd06879b          	addiw	a5,a3,-48
 382:	0ff7f793          	zext.b	a5,a5
 386:	fef671e3          	bgeu	a2,a5,368 <atoi+0x1c>
  return n;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  n = 0;
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <atoi+0x3e>

0000000000000394 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39a:	02b57463          	bgeu	a0,a1,3c2 <memmove+0x2e>
    while(n-- > 0)
 39e:	00c05f63          	blez	a2,3bc <memmove+0x28>
 3a2:	1602                	slli	a2,a2,0x20
 3a4:	9201                	srli	a2,a2,0x20
 3a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ac:	0585                	addi	a1,a1,1
 3ae:	0705                	addi	a4,a4,1
 3b0:	fff5c683          	lbu	a3,-1(a1)
 3b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b8:	fee79ae3          	bne	a5,a4,3ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
    dst += n;
 3c2:	00c50733          	add	a4,a0,a2
    src += n;
 3c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3c8:	fec05ae3          	blez	a2,3bc <memmove+0x28>
 3cc:	fff6079b          	addiw	a5,a2,-1
 3d0:	1782                	slli	a5,a5,0x20
 3d2:	9381                	srli	a5,a5,0x20
 3d4:	fff7c793          	not	a5,a5
 3d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3da:	15fd                	addi	a1,a1,-1
 3dc:	177d                	addi	a4,a4,-1
 3de:	0005c683          	lbu	a3,0(a1)
 3e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e6:	fee79ae3          	bne	a5,a4,3da <memmove+0x46>
 3ea:	bfc9                	j	3bc <memmove+0x28>

00000000000003ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e422                	sd	s0,8(sp)
 3f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f2:	ca05                	beqz	a2,422 <memcmp+0x36>
 3f4:	fff6069b          	addiw	a3,a2,-1
 3f8:	1682                	slli	a3,a3,0x20
 3fa:	9281                	srli	a3,a3,0x20
 3fc:	0685                	addi	a3,a3,1
 3fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 400:	00054783          	lbu	a5,0(a0)
 404:	0005c703          	lbu	a4,0(a1)
 408:	00e79863          	bne	a5,a4,418 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 40c:	0505                	addi	a0,a0,1
    p2++;
 40e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 410:	fed518e3          	bne	a0,a3,400 <memcmp+0x14>
  }
  return 0;
 414:	4501                	li	a0,0
 416:	a019                	j	41c <memcmp+0x30>
      return *p1 - *p2;
 418:	40e7853b          	subw	a0,a5,a4
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  return 0;
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <memcmp+0x30>

0000000000000426 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 42e:	f67ff0ef          	jal	ra,394 <memmove>
}
 432:	60a2                	ld	ra,8(sp)
 434:	6402                	ld	s0,0(sp)
 436:	0141                	addi	sp,sp,16
 438:	8082                	ret

000000000000043a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43a:	4885                	li	a7,1
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <exit>:
.global exit
exit:
 li a7, SYS_exit
 442:	4889                	li	a7,2
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <wait>:
.global wait
wait:
 li a7, SYS_wait
 44a:	488d                	li	a7,3
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 452:	4891                	li	a7,4
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <read>:
.global read
read:
 li a7, SYS_read
 45a:	4895                	li	a7,5
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <write>:
.global write
write:
 li a7, SYS_write
 462:	48c1                	li	a7,16
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <close>:
.global close
close:
 li a7, SYS_close
 46a:	48d5                	li	a7,21
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <kill>:
.global kill
kill:
 li a7, SYS_kill
 472:	4899                	li	a7,6
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <exec>:
.global exec
exec:
 li a7, SYS_exec
 47a:	489d                	li	a7,7
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <open>:
.global open
open:
 li a7, SYS_open
 482:	48bd                	li	a7,15
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48a:	48c5                	li	a7,17
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 492:	48c9                	li	a7,18
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49a:	48a1                	li	a7,8
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <link>:
.global link
link:
 li a7, SYS_link
 4a2:	48cd                	li	a7,19
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4aa:	48d1                	li	a7,20
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b2:	48a5                	li	a7,9
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ba:	48a9                	li	a7,10
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c2:	48ad                	li	a7,11
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ca:	48b1                	li	a7,12
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d2:	48b5                	li	a7,13
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4da:	48b9                	li	a7,14
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e2:	1101                	addi	sp,sp,-32
 4e4:	ec06                	sd	ra,24(sp)
 4e6:	e822                	sd	s0,16(sp)
 4e8:	1000                	addi	s0,sp,32
 4ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ee:	4605                	li	a2,1
 4f0:	fef40593          	addi	a1,s0,-17
 4f4:	f6fff0ef          	jal	ra,462 <write>
}
 4f8:	60e2                	ld	ra,24(sp)
 4fa:	6442                	ld	s0,16(sp)
 4fc:	6105                	addi	sp,sp,32
 4fe:	8082                	ret

0000000000000500 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	7139                	addi	sp,sp,-64
 502:	fc06                	sd	ra,56(sp)
 504:	f822                	sd	s0,48(sp)
 506:	f426                	sd	s1,40(sp)
 508:	f04a                	sd	s2,32(sp)
 50a:	ec4e                	sd	s3,24(sp)
 50c:	0080                	addi	s0,sp,64
 50e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 510:	c299                	beqz	a3,516 <printint+0x16>
 512:	0805c763          	bltz	a1,5a0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 516:	2581                	sext.w	a1,a1
  neg = 0;
 518:	4881                	li	a7,0
 51a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 51e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 520:	2601                	sext.w	a2,a2
 522:	00000517          	auipc	a0,0x0
 526:	51e50513          	addi	a0,a0,1310 # a40 <digits>
 52a:	883a                	mv	a6,a4
 52c:	2705                	addiw	a4,a4,1
 52e:	02c5f7bb          	remuw	a5,a1,a2
 532:	1782                	slli	a5,a5,0x20
 534:	9381                	srli	a5,a5,0x20
 536:	97aa                	add	a5,a5,a0
 538:	0007c783          	lbu	a5,0(a5)
 53c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 540:	0005879b          	sext.w	a5,a1
 544:	02c5d5bb          	divuw	a1,a1,a2
 548:	0685                	addi	a3,a3,1
 54a:	fec7f0e3          	bgeu	a5,a2,52a <printint+0x2a>
  if(neg)
 54e:	00088c63          	beqz	a7,566 <printint+0x66>
    buf[i++] = '-';
 552:	fd070793          	addi	a5,a4,-48
 556:	00878733          	add	a4,a5,s0
 55a:	02d00793          	li	a5,45
 55e:	fef70823          	sb	a5,-16(a4)
 562:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 566:	02e05663          	blez	a4,592 <printint+0x92>
 56a:	fc040793          	addi	a5,s0,-64
 56e:	00e78933          	add	s2,a5,a4
 572:	fff78993          	addi	s3,a5,-1
 576:	99ba                	add	s3,s3,a4
 578:	377d                	addiw	a4,a4,-1
 57a:	1702                	slli	a4,a4,0x20
 57c:	9301                	srli	a4,a4,0x20
 57e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 582:	fff94583          	lbu	a1,-1(s2)
 586:	8526                	mv	a0,s1
 588:	f5bff0ef          	jal	ra,4e2 <putc>
  while(--i >= 0)
 58c:	197d                	addi	s2,s2,-1
 58e:	ff391ae3          	bne	s2,s3,582 <printint+0x82>
}
 592:	70e2                	ld	ra,56(sp)
 594:	7442                	ld	s0,48(sp)
 596:	74a2                	ld	s1,40(sp)
 598:	7902                	ld	s2,32(sp)
 59a:	69e2                	ld	s3,24(sp)
 59c:	6121                	addi	sp,sp,64
 59e:	8082                	ret
    x = -xx;
 5a0:	40b005bb          	negw	a1,a1
    neg = 1;
 5a4:	4885                	li	a7,1
    x = -xx;
 5a6:	bf95                	j	51a <printint+0x1a>

00000000000005a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a8:	7119                	addi	sp,sp,-128
 5aa:	fc86                	sd	ra,120(sp)
 5ac:	f8a2                	sd	s0,112(sp)
 5ae:	f4a6                	sd	s1,104(sp)
 5b0:	f0ca                	sd	s2,96(sp)
 5b2:	ecce                	sd	s3,88(sp)
 5b4:	e8d2                	sd	s4,80(sp)
 5b6:	e4d6                	sd	s5,72(sp)
 5b8:	e0da                	sd	s6,64(sp)
 5ba:	fc5e                	sd	s7,56(sp)
 5bc:	f862                	sd	s8,48(sp)
 5be:	f466                	sd	s9,40(sp)
 5c0:	f06a                	sd	s10,32(sp)
 5c2:	ec6e                	sd	s11,24(sp)
 5c4:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c6:	0005c903          	lbu	s2,0(a1)
 5ca:	22090e63          	beqz	s2,806 <vprintf+0x25e>
 5ce:	8b2a                	mv	s6,a0
 5d0:	8a2e                	mv	s4,a1
 5d2:	8bb2                	mv	s7,a2
  state = 0;
 5d4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5d6:	4481                	li	s1,0
 5d8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5da:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5de:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5e2:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5e6:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ea:	00000c97          	auipc	s9,0x0
 5ee:	456c8c93          	addi	s9,s9,1110 # a40 <digits>
 5f2:	a005                	j	612 <vprintf+0x6a>
        putc(fd, c0);
 5f4:	85ca                	mv	a1,s2
 5f6:	855a                	mv	a0,s6
 5f8:	eebff0ef          	jal	ra,4e2 <putc>
 5fc:	a019                	j	602 <vprintf+0x5a>
    } else if(state == '%'){
 5fe:	03598263          	beq	s3,s5,622 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 602:	2485                	addiw	s1,s1,1
 604:	8726                	mv	a4,s1
 606:	009a07b3          	add	a5,s4,s1
 60a:	0007c903          	lbu	s2,0(a5)
 60e:	1e090c63          	beqz	s2,806 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 612:	0009079b          	sext.w	a5,s2
    if(state == 0){
 616:	fe0994e3          	bnez	s3,5fe <vprintf+0x56>
      if(c0 == '%'){
 61a:	fd579de3          	bne	a5,s5,5f4 <vprintf+0x4c>
        state = '%';
 61e:	89be                	mv	s3,a5
 620:	b7cd                	j	602 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 622:	cfa5                	beqz	a5,69a <vprintf+0xf2>
 624:	00ea06b3          	add	a3,s4,a4
 628:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 62c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 62e:	c681                	beqz	a3,636 <vprintf+0x8e>
 630:	9752                	add	a4,a4,s4
 632:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 636:	03878a63          	beq	a5,s8,66a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 63a:	05a78463          	beq	a5,s10,682 <vprintf+0xda>
      } else if(c0 == 'u'){
 63e:	0db78763          	beq	a5,s11,70c <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 642:	07800713          	li	a4,120
 646:	10e78963          	beq	a5,a4,758 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 64a:	07000713          	li	a4,112
 64e:	12e78e63          	beq	a5,a4,78a <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 652:	07300713          	li	a4,115
 656:	16e78b63          	beq	a5,a4,7cc <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 65a:	05579063          	bne	a5,s5,69a <vprintf+0xf2>
        putc(fd, '%');
 65e:	85d6                	mv	a1,s5
 660:	855a                	mv	a0,s6
 662:	e81ff0ef          	jal	ra,4e2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 666:	4981                	li	s3,0
 668:	bf69                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e89ff0ef          	jal	ra,500 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	b749                	j	602 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 682:	03868663          	beq	a3,s8,6ae <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 686:	05a68163          	beq	a3,s10,6c8 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 68a:	09b68d63          	beq	a3,s11,724 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 68e:	03a68f63          	beq	a3,s10,6cc <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 692:	07800793          	li	a5,120
 696:	0cf68d63          	beq	a3,a5,770 <vprintf+0x1c8>
        putc(fd, '%');
 69a:	85d6                	mv	a1,s5
 69c:	855a                	mv	a0,s6
 69e:	e45ff0ef          	jal	ra,4e2 <putc>
        putc(fd, c0);
 6a2:	85ca                	mv	a1,s2
 6a4:	855a                	mv	a0,s6
 6a6:	e3dff0ef          	jal	ra,4e2 <putc>
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bf99                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4685                	li	a3,1
 6b4:	4629                	li	a2,10
 6b6:	000ba583          	lw	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	e45ff0ef          	jal	ra,500 <printint>
        i += 1;
 6c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 1;
 6c6:	bf35                	j	602 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c8:	03860563          	beq	a2,s8,6f2 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6cc:	07b60963          	beq	a2,s11,73e <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6d0:	07800793          	li	a5,120
 6d4:	fcf613e3          	bne	a2,a5,69a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4641                	li	a2,16
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e1bff0ef          	jal	ra,500 <printint>
        i += 2;
 6ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	bf09                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4685                	li	a3,1
 6f8:	4629                	li	a2,10
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e01ff0ef          	jal	ra,500 <printint>
        i += 2;
 704:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 2;
 70a:	bde5                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 70c:	008b8913          	addi	s2,s7,8
 710:	4681                	li	a3,0
 712:	4629                	li	a2,10
 714:	000ba583          	lw	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	de7ff0ef          	jal	ra,500 <printint>
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
 722:	b5c5                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	008b8913          	addi	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	dcfff0ef          	jal	ra,500 <printint>
        i += 1;
 736:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 1;
 73c:	b5d9                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	db5ff0ef          	jal	ra,500 <printint>
        i += 2;
 750:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 2;
 756:	b575                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4641                	li	a2,16
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	d9bff0ef          	jal	ra,500 <printint>
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bd51                	j	602 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4641                	li	a2,16
 778:	000ba583          	lw	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	d83ff0ef          	jal	ra,500 <printint>
        i += 1;
 782:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
        i += 1;
 788:	bdad                	j	602 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 78a:	008b8793          	addi	a5,s7,8
 78e:	f8f43423          	sd	a5,-120(s0)
 792:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 796:	03000593          	li	a1,48
 79a:	855a                	mv	a0,s6
 79c:	d47ff0ef          	jal	ra,4e2 <putc>
  putc(fd, 'x');
 7a0:	07800593          	li	a1,120
 7a4:	855a                	mv	a0,s6
 7a6:	d3dff0ef          	jal	ra,4e2 <putc>
 7aa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ac:	03c9d793          	srli	a5,s3,0x3c
 7b0:	97e6                	add	a5,a5,s9
 7b2:	0007c583          	lbu	a1,0(a5)
 7b6:	855a                	mv	a0,s6
 7b8:	d2bff0ef          	jal	ra,4e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7bc:	0992                	slli	s3,s3,0x4
 7be:	397d                	addiw	s2,s2,-1
 7c0:	fe0916e3          	bnez	s2,7ac <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 7c4:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bd25                	j	602 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7cc:	008b8993          	addi	s3,s7,8
 7d0:	000bb903          	ld	s2,0(s7)
 7d4:	00090f63          	beqz	s2,7f2 <vprintf+0x24a>
        for(; *s; s++)
 7d8:	00094583          	lbu	a1,0(s2)
 7dc:	c195                	beqz	a1,800 <vprintf+0x258>
          putc(fd, *s);
 7de:	855a                	mv	a0,s6
 7e0:	d03ff0ef          	jal	ra,4e2 <putc>
        for(; *s; s++)
 7e4:	0905                	addi	s2,s2,1
 7e6:	00094583          	lbu	a1,0(s2)
 7ea:	f9f5                	bnez	a1,7de <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7ec:	8bce                	mv	s7,s3
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bd09                	j	602 <vprintf+0x5a>
          s = "(null)";
 7f2:	00000917          	auipc	s2,0x0
 7f6:	24690913          	addi	s2,s2,582 # a38 <malloc+0x136>
        for(; *s; s++)
 7fa:	02800593          	li	a1,40
 7fe:	b7c5                	j	7de <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 800:	8bce                	mv	s7,s3
      state = 0;
 802:	4981                	li	s3,0
 804:	bbfd                	j	602 <vprintf+0x5a>
    }
  }
}
 806:	70e6                	ld	ra,120(sp)
 808:	7446                	ld	s0,112(sp)
 80a:	74a6                	ld	s1,104(sp)
 80c:	7906                	ld	s2,96(sp)
 80e:	69e6                	ld	s3,88(sp)
 810:	6a46                	ld	s4,80(sp)
 812:	6aa6                	ld	s5,72(sp)
 814:	6b06                	ld	s6,64(sp)
 816:	7be2                	ld	s7,56(sp)
 818:	7c42                	ld	s8,48(sp)
 81a:	7ca2                	ld	s9,40(sp)
 81c:	7d02                	ld	s10,32(sp)
 81e:	6de2                	ld	s11,24(sp)
 820:	6109                	addi	sp,sp,128
 822:	8082                	ret

0000000000000824 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 824:	715d                	addi	sp,sp,-80
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e010                	sd	a2,0(s0)
 82e:	e414                	sd	a3,8(s0)
 830:	e818                	sd	a4,16(s0)
 832:	ec1c                	sd	a5,24(s0)
 834:	03043023          	sd	a6,32(s0)
 838:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 840:	8622                	mv	a2,s0
 842:	d67ff0ef          	jal	ra,5a8 <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6161                	addi	sp,sp,80
 84c:	8082                	ret

000000000000084e <printf>:

void
printf(const char *fmt, ...)
{
 84e:	711d                	addi	sp,sp,-96
 850:	ec06                	sd	ra,24(sp)
 852:	e822                	sd	s0,16(sp)
 854:	1000                	addi	s0,sp,32
 856:	e40c                	sd	a1,8(s0)
 858:	e810                	sd	a2,16(s0)
 85a:	ec14                	sd	a3,24(s0)
 85c:	f018                	sd	a4,32(s0)
 85e:	f41c                	sd	a5,40(s0)
 860:	03043823          	sd	a6,48(s0)
 864:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 868:	00840613          	addi	a2,s0,8
 86c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 870:	85aa                	mv	a1,a0
 872:	4505                	li	a0,1
 874:	d35ff0ef          	jal	ra,5a8 <vprintf>
}
 878:	60e2                	ld	ra,24(sp)
 87a:	6442                	ld	s0,16(sp)
 87c:	6125                	addi	sp,sp,96
 87e:	8082                	ret

0000000000000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	1141                	addi	sp,sp,-16
 882:	e422                	sd	s0,8(sp)
 884:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 886:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	00000797          	auipc	a5,0x0
 88e:	7767b783          	ld	a5,1910(a5) # 1000 <freep>
 892:	a02d                	j	8bc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 894:	4618                	lw	a4,8(a2)
 896:	9f2d                	addw	a4,a4,a1
 898:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89c:	6398                	ld	a4,0(a5)
 89e:	6310                	ld	a2,0(a4)
 8a0:	a83d                	j	8de <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a2:	ff852703          	lw	a4,-8(a0)
 8a6:	9f31                	addw	a4,a4,a2
 8a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	ff053683          	ld	a3,-16(a0)
 8ae:	a091                	j	8f2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e7e463          	bltu	a5,a4,8ba <free+0x3a>
 8b6:	00e6ea63          	bltu	a3,a4,8ca <free+0x4a>
{
 8ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bc:	fed7fae3          	bgeu	a5,a3,8b0 <free+0x30>
 8c0:	6398                	ld	a4,0(a5)
 8c2:	00e6e463          	bltu	a3,a4,8ca <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	fee7eae3          	bltu	a5,a4,8ba <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8ca:	ff852583          	lw	a1,-8(a0)
 8ce:	6390                	ld	a2,0(a5)
 8d0:	02059813          	slli	a6,a1,0x20
 8d4:	01c85713          	srli	a4,a6,0x1c
 8d8:	9736                	add	a4,a4,a3
 8da:	fae60de3          	beq	a2,a4,894 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e2:	4790                	lw	a2,8(a5)
 8e4:	02061593          	slli	a1,a2,0x20
 8e8:	01c5d713          	srli	a4,a1,0x1c
 8ec:	973e                	add	a4,a4,a5
 8ee:	fae68ae3          	beq	a3,a4,8a2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70f73623          	sd	a5,1804(a4) # 1000 <freep>
}
 8fc:	6422                	ld	s0,8(sp)
 8fe:	0141                	addi	sp,sp,16
 900:	8082                	ret

0000000000000902 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 902:	7139                	addi	sp,sp,-64
 904:	fc06                	sd	ra,56(sp)
 906:	f822                	sd	s0,48(sp)
 908:	f426                	sd	s1,40(sp)
 90a:	f04a                	sd	s2,32(sp)
 90c:	ec4e                	sd	s3,24(sp)
 90e:	e852                	sd	s4,16(sp)
 910:	e456                	sd	s5,8(sp)
 912:	e05a                	sd	s6,0(sp)
 914:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 916:	02051493          	slli	s1,a0,0x20
 91a:	9081                	srli	s1,s1,0x20
 91c:	04bd                	addi	s1,s1,15
 91e:	8091                	srli	s1,s1,0x4
 920:	0014899b          	addiw	s3,s1,1
 924:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 926:	00000517          	auipc	a0,0x0
 92a:	6da53503          	ld	a0,1754(a0) # 1000 <freep>
 92e:	c515                	beqz	a0,95a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 930:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 932:	4798                	lw	a4,8(a5)
 934:	02977f63          	bgeu	a4,s1,972 <malloc+0x70>
 938:	8a4e                	mv	s4,s3
 93a:	0009871b          	sext.w	a4,s3
 93e:	6685                	lui	a3,0x1
 940:	00d77363          	bgeu	a4,a3,946 <malloc+0x44>
 944:	6a05                	lui	s4,0x1
 946:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 94a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 94e:	00000917          	auipc	s2,0x0
 952:	6b290913          	addi	s2,s2,1714 # 1000 <freep>
  if(p == (char*)-1)
 956:	5afd                	li	s5,-1
 958:	a885                	j	9c8 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 95a:	00000797          	auipc	a5,0x0
 95e:	6b678793          	addi	a5,a5,1718 # 1010 <base>
 962:	00000717          	auipc	a4,0x0
 966:	68f73f23          	sd	a5,1694(a4) # 1000 <freep>
 96a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 970:	b7e1                	j	938 <malloc+0x36>
      if(p->s.size == nunits)
 972:	02e48c63          	beq	s1,a4,9aa <malloc+0xa8>
        p->s.size -= nunits;
 976:	4137073b          	subw	a4,a4,s3
 97a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97c:	02071693          	slli	a3,a4,0x20
 980:	01c6d713          	srli	a4,a3,0x1c
 984:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 986:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98a:	00000717          	auipc	a4,0x0
 98e:	66a73b23          	sd	a0,1654(a4) # 1000 <freep>
      return (void*)(p + 1);
 992:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 996:	70e2                	ld	ra,56(sp)
 998:	7442                	ld	s0,48(sp)
 99a:	74a2                	ld	s1,40(sp)
 99c:	7902                	ld	s2,32(sp)
 99e:	69e2                	ld	s3,24(sp)
 9a0:	6a42                	ld	s4,16(sp)
 9a2:	6aa2                	ld	s5,8(sp)
 9a4:	6b02                	ld	s6,0(sp)
 9a6:	6121                	addi	sp,sp,64
 9a8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9aa:	6398                	ld	a4,0(a5)
 9ac:	e118                	sd	a4,0(a0)
 9ae:	bff1                	j	98a <malloc+0x88>
  hp->s.size = nu;
 9b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b4:	0541                	addi	a0,a0,16
 9b6:	ecbff0ef          	jal	ra,880 <free>
  return freep;
 9ba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9be:	dd61                	beqz	a0,996 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c2:	4798                	lw	a4,8(a5)
 9c4:	fa9777e3          	bgeu	a4,s1,972 <malloc+0x70>
    if(p == freep)
 9c8:	00093703          	ld	a4,0(s2)
 9cc:	853e                	mv	a0,a5
 9ce:	fef719e3          	bne	a4,a5,9c0 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 9d2:	8552                	mv	a0,s4
 9d4:	af7ff0ef          	jal	ra,4ca <sbrk>
  if(p == (char*)-1)
 9d8:	fd551ce3          	bne	a0,s5,9b0 <malloc+0xae>
        return 0;
 9dc:	4501                	li	a0,0
 9de:	bf65                	j	996 <malloc+0x94>
