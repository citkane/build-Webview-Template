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

#include "wrappers/threads_wrapper.h"

#ifndef USER_PROJECT_NAME
#define USER_PROJECT_NAME "Unknown"
#endif
#ifndef USER_PROJECT_MESSAGE
#define USER_PROJECT_MESSAGE "Unknown"
#endif
#if defined(IS_COMPILED) || defined(IS_TARGETED)
#include "webview/webview.h"
#else
// We have linked a library, so we only include api.h
// to avoid re-compiling Webview through webview.h
#include "webview/api.h"
#endif // defined(IS_COMPILED) || defined(IS_TARGETED)

/// Sets the timeout in seconds before the Webview window automatically closes
#define TIMEOUT 3
#define HTML_TEMPLATE                                                          \
  "<html>"                                                                     \
  "<p><strong>Running \"%s\" on %s</strong></p>"                               \
  "<p>This checks that all child worker thread functions are called "          \
  "successfully from the Webview public API.</p>"                              \
  "<p>Webview should automatically close after %d seconds if successful.</p>"  \
  "</html>"
#define HTML_ARGS                                                              \
  HTML_TEMPLATE, USER_PROJECT_NAME, USER_PROJECT_MESSAGE, TIMEOUT

/// Implementation function for the child worker thread
int make_worker_thread(void *arg);

#if defined(IS_CC)

#include <cstdio>
#include <cstdlib>

static char *null_char = nullptr;

#endif // defined(IS_CC)
#if defined(IS_C)

#include <stdio.h>
#include <stdlib.h>

char *null_char = NULL;

#endif // defined(IS_C)

static char *char_alloc(size_t buffer_size) {
#ifdef IS_CC
  return new char[buffer_size + 1];
#else
  char *result = malloc(buffer_size + 1);
  return result;
#endif
}

static void char_free(const char *string) {
#ifdef IS_CC
  delete[] (char *)string;
#else
  free((char *)string);
#endif
}

/// Getter for the Webview window HTML string.
const char *get_html_unsafe() {
  size_t buffer_size = snprintf(null_char, 0, HTML_ARGS);
  char *html = char_alloc(buffer_size);
  (void)snprintf(html, buffer_size + 1, HTML_ARGS);

  return html;
}

/// Free resources for Webview window HTML string.
void free_char_buffer(const char *char_buffer) { char_free(char_buffer); }

/// A dummy Webview callback function
void dummy_cb(const char *name, const char *id, void *arg) {};

#endif // APP_MAIN_HH
