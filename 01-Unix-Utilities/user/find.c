#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char *path) {
    char* p;
    for(p = path + strlen(path); p >= path && *p != '/'; p--);
    p++;
    return p;
}

void match_found(char *path, char **execArgs, int execArgc) {
    if (execArgc != 0) {
        execArgs[execArgc] = path;
        execArgs[execArgc + 1] = 0;

        int pid = fork();

        if (pid == 0) {

            exec(execArgs[0], execArgs);
            fprintf(2, "find: exec failed\n");
            exit(1);

        } else if (pid > 0) {
            wait(0);
        }
    }
}

void find(char *path, char *target, char **execArgs, int execArgc) {
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    if( st.type == T_FILE) {
        if (strcmp(fmtname(path), target) == 0) {
            printf("%s\n", path);
            match_found(path, execArgs, execArgc);
        }
    } else if (st.type == T_DIR) {

        if (strcmp(fmtname(path), target) == 0) {
            printf("%s\n", path);
            match_found(path, execArgs, execArgc);
        }

        if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
            printf("find: path too long\n");
        }

        strcpy(buf, path);
        p = buf + strlen(buf);
        *p++ = '/';

        while (read(fd, &de, sizeof(de)) != 0) {
            if (de.inum == 0) {
                continue;
            }

            if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
                continue;
            }

            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = 0;

            find(buf, target, execArgs, execArgc);
        }
    }
    close(fd);
 
}

int
main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(2, "Usage: find path target\n");
        exit(1);
    }
    char *path = argv[1];
    char *target = argv[2];

    char *execArgs[32];
    int execArgc = 0;
    int has_exec = 0;

    if (argc >= 5 && strcmp(argv[3], "-exec") == 0) {
        has_exec = 1;
        for (int i = 4; i < argc; i++) {
            execArgs[execArgc++] = argv[i];
        }
    }

    find(path, target, has_exec ? execArgs : 0, execArgc);
    exit(0);
}