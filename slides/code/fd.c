#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
  char *output = "hello world\n";
  int fd = open("fd.out",O_CREAT|O_WRONLY|O_TRUNC);
  printf("file descriptor: %d\n",fd);
  write(fd, output, 12);
  close(fd);
  sleep(20);
  return 0;
}
