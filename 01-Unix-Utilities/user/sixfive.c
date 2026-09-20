#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

char separators[] = " -\r\t\n./,";

void process(int fd) {
    char ch;
    int num = 0;
    int hasDigits = 0;
    int isValid = 1;
    while(read(fd, &ch, 1) > 0) {
        if (ch >= '0' && ch <= '9' ) {
            if (isValid) {
                num *= 10;
                int n = ch - '0';
                num += n;
                hasDigits = 1;
            }

        } else if (strchr(separators, ch) != 0) {
            if (hasDigits && isValid) {
                if(num % 5 == 0 || num % 6 == 0) {
                    printf("%d\n", num); 
                }
            
            }
            num = 0;
            hasDigits = 0;
            isValid = 1;
        } else {
            isValid = 0;
        }
    }
    if (hasDigits && isValid) {
         if(num % 5 == 0 || num % 6 == 0) {
            printf("%d\n", num); 
        }
        num = 0;
        hasDigits = 0;
        isValid = 1;
    }
}

int main(int argc, char *argv[]) {
    int fd;

    if(argc <= 1){
        process(0);
        exit(0);
    }

    for (int i = 1; i < argc; i++) {
        fd = open(argv[i], 0);
        if (fd < 0) {
            fprintf(2, "cannot open %s\n", argv[i]);
            exit(1);
        }

        process(fd);
        close(fd);
    }
    exit(0);
}