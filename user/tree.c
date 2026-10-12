#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "user/user.h"

#define MAXPATH 128

// Kiem tra mot duong dan co phai thu muc hay khong
int is_dir(char *path) {
  int fd;
  struct stat st;

  fd = open(path, O_RDONLY);
  if (fd < 0)
    return 0;

  if (fstat(fd, &st) < 0) {
    close(fd);
    return 0;
  }

  close(fd);
  return st.type == T_DIR;
}

// Tao duong dan con tu duong dan cha va ten entry
int make_path(char *child, char *parent, char *name) {
  int len = strlen(parent);
  int name_len = strlen(name);

  if (len + name_len + 2 > MAXPATH)
    return -1;

  memmove(child, parent, len);

  if (len > 0 && parent[len - 1] != '/')
    child[len++] = '/';

  memmove(child + len, name, name_len + 1);
  return 0;
}

// Doc ten entry va bo qua "." va ".."
int get_name(struct dirent *de, char *name) {
  int i;

  if (de->inum == 0)
    return 0;

  memmove(name, de->name, DIRSIZ);
  name[DIRSIZ] = '\0';

  // Loai bo cac byte NULL o cuoi ten
  for (i = 0; i < DIRSIZ; i++) {
    if (name[i] == '\0')
      break;
  }
  name[i] = '\0';

  if (strcmp(name, ".") == 0 || strcmp(name, "..") == 0)
    return 0;

  return 1;
}

// Dem so entry se duoc in
int count_entries(char *path, int onlyDir) {
  int fd;
  int count = 0;
  char name[DIRSIZ + 1];
  char child[MAXPATH];
  struct dirent de;

  fd = open(path, O_RDONLY);
  if (fd < 0)
    return -1;

  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (!get_name(&de, name))
      continue;

    if (make_path(child, path, name) < 0)
      continue;

    if (onlyDir && !is_dir(child))
      continue;

    count++;
  }

  close(fd);
  return count;
}

// In phan dau dong theo cap thu muc
void print_prefix(int level, int last[]) {
  int i;

  for (i = 0; i < level; i++) {
    if (last[i])
      printf("    ");
    else
      printf("|   ");
  }
}

// Duyet cay thu muc bang de quy
void tree(char *path, int level, int maxDepth,
          int onlyDir, int last[]) {
  int fd;
  int total;
  int seen = 0;
  int isdir;
  char name[DIRSIZ + 1];
  char child[MAXPATH];
  struct dirent de;

  // Khong duyet vuot qua do sau cho phep
  if (maxDepth >= 0 && level >= maxDepth)
    return;

  total = count_entries(path, onlyDir);
  if (total <= 0)
    return;

  fd = open(path, O_RDONLY);
  if (fd < 0)
    return;

  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (!get_name(&de, name))
      continue;

    if (make_path(child, path, name) < 0)
      continue;

    isdir = is_dir(child);

    // Neu -d thi bo qua file thuong
    if (onlyDir && !isdir)
      continue;

    seen++;
    last[level] = (seen == total);

    print_prefix(level, last);

    if (last[level])
      printf("`-- ");
    else
      printf("|-- ");

    printf("%s\n", name);

    // Chi de quy vao thu muc
    if (isdir)
      tree(child, level + 1, maxDepth, onlyDir, last);
  }

  close(fd);
}

int main(int argc, char *argv[]) {
  char *path = ".";
  int maxDepth = -1;
  int onlyDir = 0;
  int i;
  int depth;
  int last[128];
  struct stat st;
  int fd;

  // Phan tich cac tham so dong lenh
  for (i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-d") == 0) {
      onlyDir = 1;
    } else if (strcmp(argv[i], "-L") == 0) {
      if (i + 1 >= argc) {
        fprintf(2, "Usage: tree [path] [-L depth] [-d]\n");
        exit(1);
      }

      depth = atoi(argv[++i]);
      if (depth < 0 || depth >= 128) {
        fprintf(2, "tree: invalid depth\n");
        exit(1);
      }

      maxDepth = depth;
    } else if (argv[i][0] == '-') {
      fprintf(2, "Usage: tree [path] [-L depth] [-d]\n");
      exit(1);
    } else {
      path = argv[i];
    }
  }

  // Kiem tra duong dan dau vao
  fd = open(path, O_RDONLY);
  if (fd < 0) {
    fprintf(2, "tree: cannot open %s\n", path);
    exit(1);
  }

  if (fstat(fd, &st) < 0) {
    close(fd);
    fprintf(2, "tree: cannot stat %s\n", path);
    exit(1);
  }

  close(fd);

  // Luon in duong dan goc
  printf("%s\n", path);

  if (st.type == T_DIR)
    tree(path, 0, maxDepth, onlyDir, last);

  exit(0);
}