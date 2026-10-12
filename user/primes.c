
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define READ_END  0
#define WRITE_END 1

// Moi process xu ly mot so nguyen to
void primes(int left_pipe[2]) __attribute__((noreturn));

void primes(int left_pipe[2]) {
    int prime;
    int num;
    int n;
    int right_pipe[2];

    // Process nay chi doc tu pipe dau vao
    close(left_pipe[WRITE_END]);

    // So dau tien doc duoc la so nguyen to
    n = read(left_pipe[READ_END], &prime, sizeof(int));

    // Het du lieu thi dong pipe va ket thuc
    if (n == 0) {
        close(left_pipe[READ_END]);
        exit(0);
    }

    if (n != sizeof(int)) {
        close(left_pipe[READ_END]);
        exit(1);
    }

    printf("prime %d\n", prime);

    // Tao pipe moi cho process tiep theo
    if (pipe(right_pipe) < 0) {
        close(left_pipe[READ_END]);
        exit(1);
    }

    int pid = fork();

    if (pid < 0) {
        close(left_pipe[READ_END]);
        close(right_pipe[READ_END]);
        close(right_pipe[WRITE_END]);
        exit(1);
    }

    if (pid == 0) {
        // Process con xu ly stage tiep theo
        close(left_pipe[READ_END]);
        primes(right_pipe);
    }

    // Process cha chi ghi vao pipe dau ra
    close(right_pipe[READ_END]);

    // Loai cac boi cua prime va chuyen so con lai
    while ((n = read(left_pipe[READ_END], &num, sizeof(int))) == sizeof(int)) {
        if (num % prime != 0) {
            if (write(right_pipe[WRITE_END], &num, sizeof(int)) != sizeof(int)) {
                close(left_pipe[READ_END]);
                close(right_pipe[WRITE_END]);
                wait(0);
                exit(1);
            }
        }
    }

    // Dong pipe de process tiep theo nhan EOF
    close(left_pipe[READ_END]);
    close(right_pipe[WRITE_END]);

    // Cho process con va cac stage phia sau ket thuc
    wait(0);

    exit(0);
}

int main(int argc, char *argv[]) {
    int p[2];

    // Tao pipe dau tien
    if (pipe(p) < 0) {
        fprintf(2, "primes: pipe failed\n");
        exit(1);
    }

    int pid = fork();

    if (pid < 0) {
        close(p[READ_END]);
        close(p[WRITE_END]);
        fprintf(2, "primes: fork failed\n");
        exit(1);
    }

    if (pid == 0) {
        // Process con bat dau sang so nguyen to
        primes(p);
    }

    // Process chinh chi ghi day so vao pipe
    close(p[READ_END]);

    // Gui cac so nguyen tu 2 den 280
    for (int i = 2; i <= 280; i++) {
        if (write(p[WRITE_END], &i, sizeof(int))
            != sizeof(int)) {
            close(p[WRITE_END]);
            wait(0);
            fprintf(2, "primes: write failed\n");
            exit(1);
        }
    }

    // Dong dau ghi de bao hieu het du lieu
    close(p[WRITE_END]);

    // Cho toan bo pipeline ket thuc
    wait(0);

    exit(0);
}