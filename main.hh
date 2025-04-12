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

#ifndef APP_MAIN_HH
#define APP_MAIN_HH

#include "lib/main_data.hh"
#include "lib/threads.hh"

#if defined(IS_COMPILED) || defined(IS_TARGETED)
#include "webview/webview.h"
#else
// We have linked a library, so we only include api.h
// to avoid re-compiling Webview through webview.h
#include "webview/api.h"
#endif // defined(IS_COMPILED) || defined(IS_TARGETED)

#if defined(IS_CC)

#include <cstdarg>
#include <cstdio>

static char *null_char = nullptr;
static void char_free(const char *string) { delete[] (char *)string; }
static char *char_alloc(size_t buffer_size) {
  return new char[buffer_size + 1];
}
#endif // defined(IS_CC)

#if defined(IS_C)

#include <stdio.h>
#include <stdlib.h>

static char *null_char = NULL;
static void char_free(const char *string) { free((char *)string); }
static char *char_alloc(size_t buffer_size) {
  char *result = malloc(buffer_size + 1);
  return result;
}
#endif //  defined(IS_C)

/// Implementation function for the child worker thread
int make_worker_thread(void *arg);

/// Getter for the Webview window HTML string.
const char *get_html_unsafe() {
  size_t buffer_size = snprintf(null_char, 0, HTML_TEMPLATE_ARGS);
  char *html = char_alloc(buffer_size);
  (void)snprintf(html, buffer_size + 1, HTML_TEMPLATE_ARGS);

  return html;
}

/// Free resources for Webview window HTML string.
void free_char_buffer(const char *char_buffer) { char_free(char_buffer); }

/// A dummy Webview callback function
void dummy_cb(const char *name, const char *id, void *arg) {};

void app_destroy(threads_ctx_t *ctx, std_thread *thread) {
  condition_destroy(&ctx->cv);
  thread_join(thread);
}

#endif // APP_MAIN_HH
