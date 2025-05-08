#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "custom_logger.h"
#include "spinlock.h"

extern void uartputc_sync(int);  // یا consputc اگر می‌خوای به ترمینال بیاد

static const char* log_level_strings[] = {
  "INFO — ",
  "WARNING — ",
  "ERROR — "
};

struct spinlock log_lock;
int log_lock_initialized = 0;

void log_message(log_level_t level, const char *message)
{
  if (!log_lock_initialized) {
    initlock(&log_lock, "log");
    log_lock_initialized = 1;
  }

  acquire(&log_lock);  // گرفتن قفل

  if (level < LOG_INFO || level > LOG_ERROR) {
    release(&log_lock);
    return;
  }

  const char *prefix = log_level_strings[level];
  while (*prefix)
    uartputc_sync(*prefix++);  // یا consputc

  while (*message)
    uartputc_sync(*message++);

  uartputc_sync('\n');

  release(&log_lock);  // آزادسازی قفل
}



