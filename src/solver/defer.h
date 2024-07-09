#ifndef _DEFER_H_
#define _DEFER_H_

#define CONCAT_INTERNAL(x, y) x##y
#define CONCAT(x, y) CONCAT_INTERNAL(x, y)

#define DEFER(code) \
    __attribute__((cleanup(CONCAT(_defer_func_, __LINE__)))) int CONCAT(_defer_var_, __LINE__) = 0; \
    void CONCAT(_defer_func_, __LINE__)(int *unused) { (void)unused; code; }

#endif