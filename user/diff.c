#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

#define MAX_DONG 512
static char dong1[MAX_DONG];
static char dong2[MAX_DONG];
// Doc mot dong tu fd vao buf. Khong giu ky tu '\n' o cuoi, va ket thuc buf bang '\0' 
//1  doc duoc mot dong
//0  het file
//-1  loi doc, hoac dong dai hon max-1 byte
static int readline(int fd, char *buf, int max){
  int n = 0;                    // so byte cua dong da doc duoc
  char c;
  int r;

  while((r = read(fd, &c, 1)) == 1){
    if(c == '\n'){              // het dong
      buf[n] = '\0';
      return 1;
    }
    if(n >= max - 1)            
      return -1;
    buf[n++] = c;
  }

  if(r < 0)                     
    return -1;
  if(n == 0)                    // read() tra 0 ma chua gom byte nao: het file
    return 0;
  buf[n] = '\0';                // dong cuoi khong ket thuc bang '\n'
  return 1;
}

static void usage(void){
  fprintf(2, "usage: diff file1 file2 [-q]\n");
  exit(2);
}

int main(int argc, char *argv[]){
  char *ten1 = 0, *ten2 = 0;
  int im_lang = 0;              
  int fd1, fd2;
  int r1, r2;
  int so_dong = 0;              // bo dem dung chung cho ca hai file
  int khac_nhau = 0;
  int i;
  for(i = 1; i < argc; i++){
    if(strcmp(argv[i], "-q") == 0)
      im_lang = 1;
    else if(argv[i][0] == '-')
      usage();                  
    else if(ten1 == 0)
      ten1 = argv[i];
    else if(ten2 == 0)
      ten2 = argv[i];
    else
      usage();                 
  }
  if(ten1 == 0 || ten2 == 0)
    usage();

  if((fd1 = open(ten1, O_RDONLY)) < 0){
    fprintf(2, "diff: cannot open %s\n", ten1);
    exit(2);
  }
  if((fd2 = open(ten2, O_RDONLY)) < 0){
    fprintf(2, "diff: cannot open %s\n", ten2);
    close(fd1);
    exit(2);
  }

  // So sanh theo vi tri: dong thu i cua file1 doi chieu dong thu i cua file2
  for(;;){
    r1 = readline(fd1, dong1, MAX_DONG);
    r2 = readline(fd2, dong2, MAX_DONG);

    if(r1 < 0 || r2 < 0){
      fprintf(2, "diff: loi doc, hoac dong dai hon %d byte\n", MAX_DONG - 1);
      close(fd1);
      close(fd2);
      exit(2);
    }
    if(r1 == 0 && r2 == 0)      // ca hai file het cung luc
      break;

    so_dong++;

    if(r1 == 1 && r2 == 1 && strcmp(dong1, dong2) == 0)
      continue;                 // hai dong giong nhau, khong in gi

    khac_nhau = 1;
    if(im_lang)                 
      break;

    // File nao het truoc thi in chu EOF thay cho noi dung dong.
    printf("%s:%d: < %s\n", ten1, so_dong, r1 ? dong1 : "EOF");
    printf("%s:%d: > %s\n", ten2, so_dong, r2 ? dong2 : "EOF");
  }

  close(fd1);
  close(fd2);

  if(khac_nhau){
    if(im_lang)
      printf("diff: files differ\n");
    exit(1);                    
  }
  exit(0);                      // giong het thi khong in gi ca
}
