/* Test fixture: a shared library that looks like wgpu-native but reports a
   different version.  Used to exercise the loader's version gate without
   building a second wgpu-native.

   It also records its own unloading, so the test can prove that the loader
   closes a handle it rejected instead of leaving it mapped. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static void note(const char *what) {
  const char *p = getenv("WGPU_OCAML_TEST_DTOR_LOG");
  if (p != NULL) {
    FILE *f = fopen(p, "a");
    if (f != NULL) {
      fprintf(f, "%s\n", what);
      fclose(f);
    }
  }
}

__attribute__((destructor)) static void on_unload(void) { note("fake_wrong_version unloaded"); }

/* 1.2.3.4, which is not the pinned version. */
uint32_t wgpuGetVersion(void) { return 0x01020304u; }
