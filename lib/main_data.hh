#ifndef APP_MAIN_DATA_HH
#define APP_MAIN_DATA_HH

#ifndef USER_PROJECT_NAME
#define USER_PROJECT_NAME "Unknown"
#endif
#ifndef USER_PROJECT_MESSAGE
#define USER_PROJECT_MESSAGE "Unknown"
#endif

/// Defines the timeout in seconds before the Webview window automatically closes
#define TIMEOUT 5

/// Defines the HTML template for the Webview window
#define HTML_TEMPLATE                                                          \
  "<html><body>"                                                               \
  "<h3>Running \"%s\" on %s</h3>"                                              \
  "<p>This checks that all child worker thread functions are called "          \
  "successfully from the Webview public API.</p>"                              \
  "<p>Webview should automatically close after <strong><span "                 \
  "id=countdown>%d</span></strong> seconds if successful.</p>"                 \
  "<div class=messages>"                                                       \
  "<p id=init><pre>webview_init</pre> script "                                 \
  "received.</p>"                                                              \
  "</div>"                                                                     \
  "</body></html>"

#define HTML_TEMPLATE_ARGS                                                     \
  HTML_TEMPLATE, USER_PROJECT_NAME, USER_PROJECT_MESSAGE, TIMEOUT

/// JS script to pass to `webview_init`
#define INIT_SCRIPT                                                            \
  "window.onload = function() {"                                               \
  "window.app = {"                                                             \
  "countdownHTML: document.getElementById('countdown'),"                       \
  "initHTML: document.getElementById('init')"                                  \
  "};"                                                                         \
  "app.initHTML.classList.add('ready');"                                       \
  "app.timeout = app.countdownHTML.innerText * 1;"                             \
  "app.interval = setInterval(() => {"                                         \
  "  app.timeout--;"                                                           \
  "  app.countdownHTML.innerText = app.timeout;"                               \
  "  if (!app.timeout) clearInterval(app.interval);"                           \
  "}, 1000);"                                                                  \
  "}"

#endif // APP_MAIN_DATA_HH