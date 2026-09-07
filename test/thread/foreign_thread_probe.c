/* Test fixture: calls an OCaml callback from a thread the OCaml runtime has
   never seen.

   wgpu-native's log sink is process-global and webgpu.h documents the
   uncaptured-error callback as callable "from any thread", so the bindings
   register foreign threads and take the domain lock inside callbacks.  This
   fixture reproduces that situation without needing a GPU: it is the smallest
   thing that can prove the mechanism works. */
#include <pthread.h>
#include <stddef.h>
#include <stdint.h>
#include <time.h>

/* Mirrors WGPUStringView: a struct passed to the callback by value, which is
   the shape every real wgpu callback uses. */
struct probe_string_view {
  const char *data;
  size_t length;
};

typedef void (*probe_cb)(uint32_t, void *);
typedef void (*probe_sv_cb)(struct probe_string_view, void *);

struct plain_args {
  probe_cb cb;
  uint32_t n;
  void *userdata;
};

static void *plain_runner(void *p) {
  struct plain_args *a = (struct plain_args *)p;
  for (uint32_t i = 0; i < a->n; i++) a->cb(i, a->userdata);
  return NULL;
}

/* Calls [cb] [n] times from a brand-new thread, then joins it. */
void probe_call_from_new_thread(probe_cb cb, uint32_t n, void *userdata) {
  pthread_t t;
  struct plain_args a;
  a.cb = cb;
  a.n = n;
  a.userdata = userdata;
  if (pthread_create(&t, NULL, plain_runner, &a) != 0) return;
  pthread_join(t, NULL);
}

struct sv_args {
  probe_sv_cb cb;
  const char *text;
  void *userdata;
};

static void *sv_runner(void *p) {
  struct sv_args *a = (struct sv_args *)p;
  struct probe_string_view sv;
  size_t n = 0;
  while (a->text[n] != '\0') n++;
  sv.data = a->text;
  sv.length = n;
  a->cb(sv, a->userdata);
  return NULL;
}

/* Calls [cb] once from a brand-new thread, passing a struct by value. */
void probe_call_with_struct(probe_sv_cb cb, const char *text, void *userdata) {
  pthread_t t;
  struct sv_args a;
  a.cb = cb;
  a.text = text;
  a.userdata = userdata;
  if (pthread_create(&t, NULL, sv_runner, &a) != 0) return;
  pthread_join(t, NULL);
}

/* Burns native time without touching the OCaml runtime, so a test can hold a
   binding "inside a native call" while other threads run. */
void probe_sleep_ms(uint32_t ms) {
  struct timespec ts;
  ts.tv_sec = ms / 1000;
  ts.tv_nsec = (long)(ms % 1000) * 1000000L;
  nanosleep(&ts, NULL);
}
