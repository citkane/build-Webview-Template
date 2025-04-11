window.onload = function () {
  window.app = {
    countdownHTML: document.getElementById("countdown"),
    initHTML: document.getElementById("init"),
  };
  app.initHTML.classList.add("ready");
  app.timeout = app.countdownHTML.innerText * 1;
  app.interval = setInterval(() => {
    app.timeout--;
    app.countdownHTML.innerText = app.timeout;
    if (!app.timeout) clearInterval(app.interval);
  }, 1000);
};
