/* Regression fixture: an indented macro in the WGPU_ namespace that the
   generator does not understand must abort, not be dropped silently. */
#ifndef TEST_FIXTURE_H
#define TEST_FIXTURE_H
#  define WGPU_TEST_MYSTERY __attribute__((deprecated))
typedef uint64_t WGPUFlags;
typedef uint32_t WGPUBool;
#endif
