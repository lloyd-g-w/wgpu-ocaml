/* Test fixture: a shared library that opens fine but is not wgpu-native at
   all (no wgpuGetVersion).  The loader must say so instead of letting a bare
   Dl.DL_error escape, and must close the handle again. */
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

__attribute__((destructor)) static void on_unload(void) { note("fake_not_wgpu unloaded"); }

int wgpu_ocaml_test_marker(void) { return 42; }
