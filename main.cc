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

/*******************************************************************************
* This file (`main.cc`) is tailored for both C++ and C usage. See also `main.c`
********************************************************************************/
// NOLINTBEGIN(hicpp-use-auto)

#include "main.hh"

#if defined(IS_MSVC)
#include <windows.h>
int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrevInst, LPSTR lpCmdLine,
                   int nCmdShow) {
#else
int main() {
#endif

  mutex mtx;
  threads_ctx_t ctx;
  init_ctx(&ctx);
  ctx.main_lock = lock_mtx(&mtx);

  webview_t w = webview_create(1, null_char);
  ctx.w = w;

  std_thread worker_thread = create_thread(make_worker_thread, &ctx);
  condition_wait(&ctx.cv, &ctx.main_lock, &ctx.worker_ready);

  webview_run(w);
  // The main thread is now blocked until Webview is terminated
  atomic_release(&ctx.wv_done);
  condition_notify_one(&ctx.cv);

  webview_destroy(w);
  app_destroy(&ctx, &worker_thread);

  return 0;
}

int make_worker_thread(void *arg) {
  mutex mtx;
  threads_ctx_t *ctx = (threads_ctx_t *)arg;
  ctx->child_lock = lock_mtx(&mtx);

  webview_t w = ctx->w;

  const char *unsafe_html = get_html_unsafe();
  webview_set_html(w, unsafe_html);
  webview_init(w, INIT_SCRIPT);
  free_char_buffer(unsafe_html);
  webview_bind(w, "dummy", dummy_cb, null_char);
  webview_set_title(w, USER_PROJECT_NAME);
  webview_set_size(w, 1200, 1200, WEBVIEW_HINT_NONE);

  atomic_release(&ctx->worker_ready);
  condition_notify_one(&ctx->cv);
  condition_wait_for(&ctx->cv, &ctx->child_lock, TIMEOUT, &ctx->wv_done);

  if (!atomic_check(&ctx->wv_done)) {
    webview_terminate(w);
  }

  return 0;
}
// NOLINTEND(hicpp-use-auto)
