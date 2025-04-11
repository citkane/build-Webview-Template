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

#ifndef APP_THREADS_WRAPPER_C
#define APP_THREADS_WRAPPER_C

#pragma clang diagnostic ignored "-Wpedantic"
// NOLINTBEGIN(readability-non-const-parameter)

#include "threads_wrapper.h"
#include <threads.h>

atomic_acquire_t atomic_acquire(atomic_bool *atomic_flag) {
  return atomic_load(atomic_flag);
}

void atomic_release(atomic_bool *atomic_flag) {
  atomic_store(atomic_flag, true);
}

bool atomic_get(atomic_bool *atomic_flag) { return atomic_load(atomic_flag); }

#if defined(IS_C_PTHRD)
void condition_notify_one(condition_variable *cv) { pthread_cond_signal(cv); };

unique_lock lock_mtx(mutex *mtx) {
  pthread_mutex_init(mtx, NULL);
  return (*mtx);
}

void condition_wait(condition_variable *cv, unique_lock *lock,
                    atomic_bool *atomic_flag) {
  while (!atomic_acquire(atomic_flag)) {
    pthread_cond_wait(cv, lock);
  }
}

void condition_wait_for(condition_variable *cv, unique_lock *lock, int seconds,
                        atomic_bool *atomic_flag) {
  struct timespec duration;
  (void)clock_gettime(CLOCK_REALTIME, &duration);
  duration.tv_sec += seconds;
  while (!atomic_get(atomic_flag)) {
    pthread_cond_timedwait(cv, lock, &duration);
    break;
  }
}

std_thread create_thread(make_worker_thread_t fn, threads_ctx_t *ctx) {
  std_thread worker_thread;
  pthread_create(&worker_thread, NULL, (void *)fn, ctx);
  return worker_thread;
}

void join_thread(std_thread *thread) {
  void **result = NULL;
  pthread_join((*thread), result);
}

void destroy_mtx_lock(unique_lock *lock) {
  pthread_mutex_unlock(lock);
  pthread_mutex_destroy(lock);
}

void destroy_cv(condition_variable *cv) { pthread_cond_destroy(cv); }

void init_ctx(threads_ctx_t *ctx) {
  pthread_cond_init(&ctx->cv, NULL);
  atomic_init(&ctx->worker_ready, false);
  atomic_init(&ctx->wv_done, false);
}

#endif

#if defined(IS_C_WINTHRD)

void condition_notify_one(condition_variable *cv) { (void)cnd_signal(cv); }

unique_lock lock_mtx(mutex *mtx) {
  (void)mtx_init(mtx, mtx_plain);
  (void)mtx_lock(mtx);
  return (*mtx);
}

void condition_wait(condition_variable *cv, unique_lock *lock,
                    atomic_bool *atomic_flag) {
  while (!atomic_acquire(atomic_flag)) {
    (void)cnd_wait(cv, lock);
  }
}

void condition_wait_for(condition_variable *cv, unique_lock *lock, int seconds,
                        atomic_bool *atomic_flag) {
  struct timespec duration;
  (void)clock_gettime(CLOCK_REALTIME, &duration);
  duration.tv_sec += seconds;

  while (!atomic_acquire(atomic_flag)) {
    (void)cnd_timedwait(cv, lock, &duration);
    break;
  }
}

std_thread create_thread(make_worker_thread_t fn, threads_ctx_t *ctx) {
  std_thread worker_thread;
  (void)thrd_create(&worker_thread, fn, ctx);
  return worker_thread;
}

void join_thread(std_thread *thread) {
  int result;
  (void)thrd_join((*thread), &result);
}

void destroy_mtx_lock(unique_lock *lock) {
  (void)mtx_unlock(lock);
  mtx_destroy(lock);
}

void destroy_cv(condition_variable *cv) { cnd_destroy(cv); }

void init_ctx(threads_ctx_t *ctx) {
  (void)cnd_init(&ctx->cv);
  atomic_init(&ctx->worker_ready, 0);
  atomic_init(&ctx->wv_done, 0);
}

#endif // defined(IS_C_WINTHRD)
// NOLINTEND(readability-non-const-parameter)
#endif // APP_THREADS_WRAPPER_C
