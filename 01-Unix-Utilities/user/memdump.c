#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

void memdump(char *fmt, char *data, int len);

int
main(int argc, char *argv[])
{
  if (argc == 1) {
    printf("Example 1:\n");
    int a[2] = {61810, 2026};
    memdump("ii", (char *)a, sizeof(a));

    printf("Example 2:\n");
    memdump("S", "a string", sizeof("a string"));

    printf("Example 3:\n");
    char *s = "another";
    memdump("s", (char *)&s, sizeof(s));

    struct sss {
      char *ptr;
      int num1;
      short num2;
      char byte;
      char bytes[8];
    } example;

    example.ptr = "hello";
    example.num1 = 1819438967;
    example.num2 = 100;
    example.byte = 'z';
    strcpy(example.bytes, "xyzzy");

    printf("Example 4:\n");
    memdump("pihcS", (char *)&example, sizeof(example));

    printf("Example 5:\n");
    memdump("sccccc", (char *)&example, sizeof(example));
  } else if (argc == 2) {
    // format in argv[1], up to 512 bytes of data from standard input.
    char data[512];
    int n = 0;
    memset(data, '\0', sizeof(data));
    while (n < sizeof(data)) {
      int nn = read(0, data + n, sizeof(data) - n);
      if (nn <= 0)
        break;
      n += nn;
    }
    memdump(argv[1], data, n);
  } else {
    printf("Usage: memdump [format]\n");
    exit(1);
  }
  exit(0);
}

void
memdump(char *fmt, char *data, int len)
{
  int bitCounter = 0;
  while (*fmt != '\0') {
    char c = *fmt;
    if (c == 'i') {

        if (bitCounter + 4 > len) {
          printf("memdump: not enough data for '%c'\n", c);
          return;
        }

        int val = *(int*)data;
        printf("%d\n", val);

        data += 4;
        bitCounter += 4;

    } else if (c == 'p') {

        if (bitCounter + 8 > len){
          printf("memdump: not enough data for '%c'\n", c);
          return;
        }

        uint64 val = *(uint64*)data;
        printf("%lx\n", val);
        
        data += 8;
        bitCounter += 8;
      
    } else if (c == 'h') {
    
        if (bitCounter + 2 > len) {
          printf("memdump: not enough data for '%c'\n", c);
          return;
        }
      
        short val = *(short*)data;
        printf("%d\n", val);
      
        data += 2;
        bitCounter += 2;
    
    } else if (c == 'c') {
    
        if (bitCounter + 1 > len){
          printf("memdump: not enough data for '%c'\n", c);
          return;
        }
      
        char val = *(char*)data;
        printf("%c\n", val);
      
        data += 1;
        bitCounter += 1;
    
    } else if (c == 's') {
    
        if (bitCounter + 8 > len) {
          printf("memdump: not enough data for '%c'\n", c);
          return;
        }
      
        char* val = *(char**)data;
        printf("%s\n", val);
      
        data += 8;
        bitCounter += 8;
      
    } else if (c == 'S') {
        while (bitCounter < len && *data != '\0') {
              printf("%c", *data);
              data += 1;
              bitCounter += 1;
        }

        printf("\n");

        if (bitCounter < len && *data == '\0') {
            data += 1;
            bitCounter += 1;
        }
    }
    
    fmt++;
  }
}
