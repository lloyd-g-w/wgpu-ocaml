/* Regression fixture: preprocessor directives may be indented after the hash.
   The generator must see this sentinel, not skip it. */
#ifndef TEST_FIXTURE_H
#define TEST_FIXTURE_H
#   define WGPU_TEST_SENTINEL (UINT32_MAX)
typedef uint64_t WGPUFlags;
typedef uint32_t WGPUBool;
#endif
