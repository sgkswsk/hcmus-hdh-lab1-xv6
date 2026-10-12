#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

#define NULL 0
#define STDERR 2

#define MODE_DEFAULT 0
#define MODE_SUMMARY 1
#define MODE_ALL 2
char mode = MODE_DEFAULT;

uint64 du(char* name, int len) {
    // +1 for string terminator
    static char pathbuf[MAXPATH + 1] = { 0 };
    static int top = 0;

    int isFirst = !top;

    if (top + len > MAXPATH) {
        if (mode != MODE_SUMMARY || isFirst) fprintf(STDERR, "du: path too long\n");

        // back to parent
        while (1) {
            if (top == 0) break;
            if (pathbuf[top] == '/') { pathbuf[top] = 0; break; }
            
            top--;
        }
        return 0;
    }

    // open directory
    memmove(pathbuf + top, name, len);
    top += len;
    pathbuf[top] = 0;

    int fd = open(pathbuf, O_RDONLY);
    if (fd < 0) {
        if (mode != MODE_SUMMARY || isFirst) fprintf(STDERR, "du: can't open %s\n", pathbuf);

        // back to parent
        while (1) {
            if (top == 0) break;
            if (pathbuf[top] == '/') { pathbuf[top] = 0; break; }
            
            top--;
        }
        return 0;
    }

    struct stat st;
    if (fstat(fd, &st) < 0) {
        if (mode != MODE_SUMMARY || isFirst) fprintf(STDERR, "du: can't stat %s\n", pathbuf);

        // back to parent
        while (1) {
            if (top == 0) break;
            if (pathbuf[top] == '/') { pathbuf[top] = 0; break; }
            
            top--;
        }
        
        close(fd);
        return 0;
    }

    uint64 size = 0;
    if (st.type == T_DIR) {
        struct dirent de;
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
            // inactive
            if (de.inum == 0) continue;


            char* nameptr = de.name;
            while (1) {
                if ((nameptr - de.name) == DIRSIZ) break;
                if (*nameptr == 0) break;

                nameptr++;
            }

            int name_len = nameptr - de.name;

            // skip . and ..
            if (
                (name_len == 1 && (de.name[0] == '.')) ||
                (name_len == 2 && (de.name[0] == '.' && de.name[1] == '.'))
            ) continue;
            
            pathbuf[top++] = '/';
            size += du(de.name, name_len);
        }

        if (mode != MODE_SUMMARY || isFirst) printf("%ld\t%s\n", size, pathbuf);
    } else if (st.type == T_FILE) {
        size = st.size;
        if (mode == MODE_ALL) printf("%ld\t%s\n", size, pathbuf);
    }

    // back to parent
    while (1) {
        if (top == 0) break;
        if (pathbuf[top] == '/') { pathbuf[top] = 0; break; }
        
        top--;
    }

    close(fd);
    return size;
}

int main(int argc, char **argv) {
    if (argc < 2 || 3 < argc) {
        fprintf(STDERR, "usage: du [path] [-a/-s]");
        exit(0);
    }

    char *path = NULL;
    for (int i = 1; i < argc; i++) {
        if (argv[i][0] == '-') {
            if (argv[i][1] == 's') mode = MODE_SUMMARY;
            if (argv[i][1] == 'a') mode = MODE_ALL;

            // unchanged == unknown flag, longer than 1 character is also unknown
            if (mode == MODE_DEFAULT || argv[i][2] != 0) {
                fprintf(STDERR, "du: unknown flag %s\n", argv[i]);
                exit(0);
            }
            
            continue;
        }

        path = argv[i];
    }

    if (path == NULL) {
        fprintf(STDERR, "du: no path supplied\n");
        exit(0);
    }

    int plen = 0;
    while (path[plen] != 0) plen++;

    du(path, plen);

    exit(0);
}
