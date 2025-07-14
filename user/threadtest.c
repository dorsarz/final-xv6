#include "user/user.h"
#include "kernel/types.h"

volatile int print_lock = 0;

void acquire_print_lock() {
  while (__sync_lock_test_and_set(&print_lock, 1)) {}
}

void release_print_lock() {
  __sync_lock_release(&print_lock);
}

struct thread_data {
  int thread_id;
  uint64 start_number;
};

void my_thread(void *arg) {
  struct thread_data *data = (struct thread_data *) arg;
  for (int i = 0; i < 10; ++i) {
    data->start_number++;

    acquire_print_lock();
    printf("thread %d: %lu\n", data->thread_id, data->start_number);
    release_print_lock();

    sleep(0);
  }
  exitthread();
}

int main(int argc, char *argv[]) {
  static struct thread_data data1 = {1, 100};
  static struct thread_data data2 = {2, 200};
  static struct thread_data data3 = {3, 300};

  uint64 sp1[4096/8], sp2[4096/8], sp3[4096/8];

  int ta = thread_create(my_thread, (void*)(sp1 + 4096/8), (void*)&data1);
  printf("NEW THREAD CREATED 1\n");
  int tb = thread_create(my_thread, (void*)(sp2 + 4096/8), (void*)&data2);
  printf("NEW THREAD CREATED 2\n");
  int tc = thread_create(my_thread, (void*)(sp3 + 4096/8), (void*)&data3);
  printf("NEW THREAD CREATED 3\n");

  jointhread(ta);
  jointhread(tb);
  jointhread(tc);

  printf("DONE\n");
  exit(0);
}
