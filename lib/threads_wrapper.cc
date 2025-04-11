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

#ifndef APP_THREADS_WRAPPER_CC
#define APP_THREADS_WRAPPER_CC

#include "threads_wrapper.h"

void condition_notify_one(condition_variable *cv) { cv->notify_one(); }

atomic_acquire_t atomic_acquire(atomic_bool *atomic_flag) {
  return [=]() { return atomic_flag->load(std::memory_order_acquire); };
}

void atomic_release(atomic_bool *atomic_flag) {
  atomic_flag->store(true, std::memory_order_release);
}

bool atomic_check(atomic_bool *atomic_flag) {
  return atomic_flag->load(std::memory_order_acquire);
}

unique_lock lock_mtx(mutex *mtx) { return unique_lock((*mtx)); }

void condition_wait(condition_variable *cv, unique_lock *lock,
                    atomic_bool *atomic_flag) {
  cv->wait(((*lock)), atomic_acquire(atomic_flag));
}

void condition_wait_for(condition_variable *cv, unique_lock *lock, int seconds,
                        atomic_bool *atomic_flag) {
  cv->wait_for(((*lock)), std::chrono::seconds(seconds),
               atomic_acquire(atomic_flag));
}

std_thread create_thread(make_worker_thread_t fn, threads_ctx_t *ctx) {
  std_thread worker_thread(fn, ctx);
  return worker_thread;
}

void join_thread(std_thread *thread) { thread->join(); }

void destroy_mtx_lock(unique_lock * /*lock*/) {}
void destroy_cv(condition_variable * /*cv*/) {}
void init_ctx(threads_ctx_t * /*ctx*/) {}

#endif // APP_THREADS_WRAPPER_CC