#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <myfile>\n", argv[0]);
        return 1;
    }

    char lockfile[strlen(argv[1]) + 5];
    sprintf(lockfile, "%s.lck", argv[1]);

    int fd_lock;
    while ((fd_lock = open(lockfile, O_CREAT | O_EXCL | O_WRONLY, 0644)) == -1) {
        usleep(10000);
    }

    pid_t pid = getpid();
    char pid_str[16];
    sprintf(pid_str, "%d", pid);
    write(fd_lock, pid_str, strlen(pid_str));
    close(fd_lock);

    sleep(1);

    fd_lock = open(lockfile, O_RDONLY);
    if (fd_lock == -1) {
        printf("Error: Lock file disappeared!\n");
        return 1;
    }
    char read_pid[16];
    read(fd_lock, read_pid, sizeof(read_pid));
    close(fd_lock);

    if (strcmp(read_pid, pid_str) != 0) {
        printf("Error: Lock file owned by another process!\n");
        return 1;
    }

    printf("Removing lock file %s, owned by PID %s\n", lockfile, read_pid);

    FILE *stats_file = fopen("stats.txt", "a");
    if (stats_file == NULL) {
        perror("Failed to open stats.txt for appending");
        return 1;
    }
    
    fprintf(stats_file, "PID: %s, Lock count: 1\n", pid_str);
    fclose(stats_file);

    remove(lockfile);

    return 0;
}
