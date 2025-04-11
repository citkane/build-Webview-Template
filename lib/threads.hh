#ifndef APP_THREADS_HH
#define APP_THREADS_HH

#include "threads_wrapper.h"

#ifdef IS_CC
#include "threads_wrapper.cc"
#endif

#ifdef IS_C
#include "threads_wrapper.c"
#endif

#endif // APP_THREADS_HH