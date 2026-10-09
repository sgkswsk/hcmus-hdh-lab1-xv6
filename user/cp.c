#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/fs.h"

#define STDERR 2

static char buf[BSIZE];

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(STDERR, "usage: cp src dst\n");
        exit(1);
    }

    int src = open(argv[1], O_RDONLY);
    if (src < 0) {
        fprintf(STDERR, "cp: cannot open %s\n", argv[1]);
        exit(1);
    }

    struct stat src_stat;
    if (fstat(src, &src_stat) < 0) {
        fprintf(STDERR, "cp: cannot stat %s\n", argv[1]);
        close(src);
        exit(1);
    }
    if (src_stat.type == T_DIR) {
        fprintf(STDERR, "cp: %s is not a file\n", argv[1]);
        close(src);
        exit(1);
    }

    // check dst stat first to perform identity check before opening dst
    struct stat dst_stat;
    if (stat(argv[2], &dst_stat) < 0) {
        fprintf(STDERR, "cp: cannot stat %s\n", argv[2]);
        close(src);
        exit(1);
    }
    if (
        src_stat.dev == dst_stat.dev &&
        src_stat.ino == dst_stat.ino
    ) {
        fprintf(STDERR, "cp: %s and %s are the same file\n", argv[1], argv[2]);
        close(src);
        exit(1);
    }

    int dst = open(argv[2], O_CREATE | O_WRONLY | O_TRUNC);
    if (dst < 0) {
        fprintf(STDERR, "cp: cannot create %s\n", argv[2]);
        close(src);
        exit(1);
    }

    int bytes_read;
    while ((bytes_read = read(src, buf, sizeof(buf))) > 0) {
        int write_offset = 0;
        int to_write = bytes_read;
        while (to_write > 0) {
            int written = write(dst, buf + write_offset, to_write);
            if (written <= 0) {
                fprintf(STDERR, "cp: failed to write to %s\n", argv[2]);
                close(src);
                close(dst);
                exit(1);
            }

            write_offset += written;
            to_write -= written;
        }
    }

    if (bytes_read < 0) {
        fprintf(STDERR, "cp: failed to read %s\n", argv[1]);
        close(src);
        close(dst);
        exit(1);
    }

    close(src);
    close(dst);
    exit(0);
}
