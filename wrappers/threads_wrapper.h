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

#if defined(__cplusplus) // C++ with PThreads
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

#elif defined(IS_MSVC) // C MSVC build with WINThreads

#define IS_C
#define IS_C_WINTHRD

#include <stdatomic.h>
#include <stdbool.h>
#include <stdlib.h>
#include <threads.h> // Note: <threads.h> on MSVC needs Visual Studio 2022 version 17.8 or greater

typedef mtx_t mutex;
typedef cnd_t condition_variable;
typedef thrd_t std_thread;
typedef mtx_t unique_lock;
typedef int (*make_worker_thread_t)(void *);
typedef bool atomic_acquire_t;

#else // C build with PThreads

#define IS_C
#define IS_C_PTHRD
#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#endif
#include <pthread.h>
#include <stdatomic.h>
#include <stdbool.h>
#include <unistd.h>

typedef pthread_mutex_t mutex;
typedef pthread_cond_t condition_variable;
typedef pthread_t std_thread;
typedef pthread_mutex_t unique_lock;
typedef int (*make_worker_thread_t)(void *);
typedef bool atomic_acquire_t;

#endif

/// A context type for the child worker thread
typedef struct {
  condition_variable cv;
  atomic_bool wv_done;
  atomic_bool worker_ready;
  void *w;
} threads_ctx_t;

#ifdef IS_CC
/// C++ helper callback function to aquire a atomic boolean flag
static atomic_acquire_t atomic_acquire(atomic_bool &atomic_flag) {
  return [&]() { return atomic_flag.load(std::memory_order_acquire); };
}
#endif
#if defined(IS_C)
/// C helper callback function to aquire a atomic boolean flag
static atomic_acquire_t atomic_acquire(atomic_bool atomic_flag) {
  return atomic_load_explicit(&atomic_flag, memory_order_acquire);
}
#endif

#ifdef IS_CC
/// C++ wrapper to release an atomic hold
static void atomic_release(atomic_bool &atomic_flag) {
  atomic_flag.store(true, std::memory_order_release);
}
#endif
#if defined(IS_C)
/// C wrapper to release an atomic hold
static void atomic_release(atomic_bool atomic_flag) {
  atomic_store_explicit(&atomic_flag, true, memory_order_release);
}
#endif

/// C/C++ Wrapper to lock a unique mutex
static unique_lock lock_mtx(mutex *mtx) {
#ifdef IS_CC
  return unique_lock((*mtx));
#elif defined(IS_C_WINTHRD)
  (void)mtx_init(mtx, mtx_plain);
  (void)mtx_lock(mtx);
  return (*mtx);
#else
  pthread_mutex_init(mtx, NULL);
  return (*mtx);
#endif
}

/// C/C++ Wrapper to conditionally wait for an atomic boolean flag
void condition_wait(condition_variable *cv, unique_lock *lock,
                    atomic_bool *atomic_flag) {
#ifdef IS_CC
  cv->wait(((*lock)), atomic_acquire((*atomic_flag)));
#elif defined(IS_C_WINTHRD)
  while (!atomic_acquire(atomic_flag)) {
    (void)cnd_wait(cv, lock);
  }
#else
  while (!atomic_acquire(atomic_flag)) {
    pthread_cond_wait(cv, lock);
  }
#endif
}

/// C/C++ Wrapper to notify a conditional variable on one thread
void condition_notify_one(condition_variable *cv) {
#ifdef IS_CC
  cv->notify_one();
#elif defined(IS_C_WINTHRD)
  (void)cnd_signal(cv);
#else
  pthread_cond_signal(cv);
#endif
}

/// C/C++ wrapper to sleep a thread for a time in seconds
void sleep_for(int seconds) {
#ifdef IS_CC
  std::this_thread::sleep_for(std::chrono::seconds(seconds));
#elif defined(IS_C_WINTHRD)
  struct timespec duration = {.tv_sec = seconds, .tv_nsec = 0};
  (void)thrd_sleep(&duration, NULL);
#else
  sleep(seconds);
#endif
}

/// C/C++ wrapper to create a thread
std_thread create_thread(make_worker_thread_t fn, threads_ctx_t *ctx) {
#ifdef IS_CC
  std_thread worker_thread(fn, ctx);
  return worker_thread;
#elif defined(IS_C_WINTHRD)
  std_thread worker_thread;
  (void)thrd_create(&worker_thread, fn, ctx);
  return worker_thread;
#else
  std_thread worker_thread;
  pthread_create(&worker_thread, NULL, (void *)fn, ctx);
  return worker_thread;
#endif
}

/// C/C++ wrapper to join a thread
void join_thread(std_thread *thread) {
#ifdef IS_CC
  thread->join();
#elif defined(IS_C_WINTHRD)
  int result;
  (void)thrd_join((*thread), &result);
#else
  void **result;
  pthread_join((*thread), result);
#endif
}

/// Destroys C memory resource.
/// NOOP for C++
void destroy_mtx_lock(unique_lock *lock) {
#ifdef IS_CC
  return;
#elif defined(IS_C_WINTHRD)
  int stat = mtx_unlock(lock);
  mtx_destroy(lock);
#else
  pthread_mutex_unlock(lock);
  pthread_mutex_destroy(lock);
#endif
};

/// Destroys C memory resource.
/// NOOP for C++
void destroy_cv(condition_variable *cv) {
#ifdef IS_C_WINTHRD
  cnd_destroy(cv);
#elif defined(IS_C_PTHRD)
  pthread_cond_destroy(cv);
#endif
};

/// Initialises C memory resource.
/// NOOP for C++
void init_ctx(threads_ctx_t *ctx) {
#ifdef IS_C_WINTHRD
  (void)cnd_init(&ctx->cv);
  atomic_init(&ctx->worker_ready, 0);
  atomic_init(&ctx->wv_done, 0);
#elif defined(IS_C_PTHRD)
  pthread_cond_init(&ctx->cv, NULL);
  atomic_init(&ctx->wv_done, false);
  atomic_init(&ctx->worker_ready, false);
#endif
};

#endif //APP_THREADS_WRAPPER_H
