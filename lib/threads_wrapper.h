/*
 * MIT License
 *
 * Copyright (c) 2025 Michael Jonker
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef APP_THREADS_WRAPPER_H
#define APP_THREADS_WRAPPER_H
#pragma clang diagnostic ignored "-Wempty-translation-unit"

#if defined(__cplusplus) // C++ build with PThreads
#define IS_CC

#include <atomic>
#include <condition_variable>
#include <functional>
#include <thread>

typedef std::mutex mutex;
typedef std::atomic<bool> atomic_bool;
typedef std::condition_variable condition_variable;
typedef std::unique_lock<mutex> unique_lock;
typedef std::atomic<bool> atomic_bool;
typedef std::thread std_thread;
typedef std::function<int(void *)> make_worker_thread_t;
typedef std::function<bool()> atomic_acquire_t;

#else // C build with WINThreads or PThreads
#define IS_C

#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#endif

#include <stdatomic.h>
#include <stdbool.h>
//#include <unistd.h>

typedef int (*make_worker_thread_t)(void *);
typedef bool atomic_acquire_t;

#endif

#if defined(IS_MSVC) && defined(IS_C) // C MSVC build with WINThreads
#define IS_C_WINTHRD

#include <threads.h> // Note: <threads.h> on MSVC needs Visual Studio 2022 version 17.8 or greater
#include <time.h>

typedef mtx_t mutex;
typedef cnd_t condition_variable;
typedef thrd_t std_thread;
typedef mtx_t unique_lock;

#elif defined(IS_C) // C build with PThreads
#define IS_C_PTHRD

#include <pthread.h>

typedef pthread_mutex_t mutex;
typedef pthread_cond_t condition_variable;
typedef pthread_t std_thread;
typedef pthread_mutex_t unique_lock;

#endif

/// A context type for the child worker thread
typedef struct {
  unique_lock main_lock;
  unique_lock child_lock;
  condition_variable cv;
  atomic_bool wv_done;
  atomic_bool worker_ready;
  void *w;
} threads_ctx_t;

/// C/C++ Wrapper to notify a conditional variable on one thread
void condition_notify_one(condition_variable *cv);

/// C/C++ helper callback function to aquire a atomic boolean flag
atomic_acquire_t atomic_acquire(atomic_bool *atomic_flag);

/// C/C++ wrapper to get an atomic value
bool atomic_get(atomic_bool *atomic_flag);

/// C/C++ wrapper to release an atomic hold
void atomic_release(atomic_bool *atomic_flag);

/// C/C++ Wrapper to lock a unique mutex
unique_lock lock_mtx(mutex *mtx);

/// C/C++ Wrapper to conditionally wait for an atomic boolean flag
void condition_wait(condition_variable *cv, unique_lock *lock,
                    atomic_bool *atomic_flag);

/// C/C++ Wrapper to wait for a time period in seconds
void condition_wait_for(condition_variable *cv, unique_lock *lock, int seconds,
                        atomic_bool *atomic_flag);

/// C/C++ wrapper to create a thread
std_thread create_thread(make_worker_thread_t fn, threads_ctx_t *ctx);

/// C/C++ wrapper to join a thread
void join_thread(std_thread *thread);

/// Destroys C memory resource.
/// NOOP for C++
void destroy_mtx_lock(unique_lock *lock);

/// Destroys C memory resource.
/// NOOP for C++
void destroy_cv(condition_variable *cv);

/// Initialises C memory resources.
/// NOOP for C++
void init_ctx(threads_ctx_t *ctx);

#endif //APP_THREADS_WRAPPER_H
