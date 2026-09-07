/* Regression fixture: a bit set that does not fit in an OCaml int.
   The generator must refuse it instead of emitting an out-of-range literal. */
#ifndef TEST_FIXTURE_H
#define TEST_FIXTURE_H
typedef uint64_t WGPUFlags;
typedef uint32_t WGPUBool;
typedef WGPUFlags WGPUTestUsage;
static const WGPUTestUsage WGPUTestUsage_None = 0x0000000000000000;
static const WGPUTestUsage WGPUTestUsage_Top = 1 << 63;
#endif
