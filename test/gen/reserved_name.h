/* Regression fixture: an enum constant whose generated name collides with a
   member the generated module defines itself. */
#ifndef TEST_FIXTURE_H
#define TEST_FIXTURE_H
typedef uint64_t WGPUFlags;
typedef uint32_t WGPUBool;
typedef enum WGPUThing {
    WGPUThing_Values = 0x00000000,
    WGPUThing_Force32 = 0x7FFFFFFF
} WGPUThing;
#endif
