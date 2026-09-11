(function () {
  /** Biel Mean Time = UTC+1, no DST. 1 day = 1000 beats. */
  function toBeat(date) {
    var utcMs = date.getTime() + date.getTimezoneOffset() * 60000;
    var bmt = new Date(utcMs + 3600000);
    var sec =
      bmt.getHours() * 3600 +
      bmt.getMinutes() * 60 +
      bmt.getSeconds() +
      bmt.getMilliseconds() / 1000;
    return (sec / 86.4) % 1000;
  }

  function formatBeat(n) {
    var v = Math.floor(n * 100) / 100;
    var s = v.toFixed(2);
    while (s.length < 6) s = "0" + s;
    return "@" + s;
  }

  function pad(n) {
    return n < 10 ? "0" + n : String(n);
  }

  function beatToClock(beat) {
    var b = Number(beat);
    if (!isFinite(b)) return null;
    b = ((b % 1000) + 1000) % 1000;
    var totalSec = b * 86.4;
    var h = Math.floor(totalSec / 3600) % 24;
    var m = Math.floor((totalSec % 3600) / 60);
    var s = Math.floor(totalSec % 60);
    return {
      h: h,
      m: m,
      s: s,
      label: pad(h) + ":" + pad(m) + ":" + pad(s) + " BMT (UTC+1)",
    };
  }

  function parseClock(str) {
    var m = String(str)
      .trim()
      .match(/^(\d{1,2}):(\d{2})(?::(\d{2}))?$/);
    if (!m) return null;
    var h = +m[1],
      mi = +m[2],
      s = m[3] ? +m[3] : 0;
    if (h > 23 || mi > 59 || s > 59) return null;
    return { h: h, m: mi, s: s };
  }

  function clockToBeat(h, m, s) {
    return ((h * 3600 + m * 60 + s) / 86.4) % 1000;
  }

  function tick() {
    var now = new Date();
    var beat = toBeat(now);
    var local =
      pad(now.getHours()) +
      ":" +
      pad(now.getMinutes()) +
      ":" +
      pad(now.getSeconds());
    var utc =
      pad(now.getUTCHours()) +
      ":" +
      pad(now.getUTCMinutes()) +
      ":" +
      pad(now.getUTCSeconds());
    document.querySelectorAll("[data-sb-beat]").forEach(function (el) {
      el.textContent = formatBeat(beat);
    });
    document.querySelectorAll("[data-sb-local]").forEach(function (el) {
      el.textContent = local;
    });
    document.querySelectorAll("[data-sb-utc]").forEach(function (el) {
      el.textContent = utc + " UTC";
    });
  }

  tick();
  setInterval(tick, 200);

  var clockIn = document.querySelector("[data-sb-clock-in]");
  var clockOut = document.querySelector("[data-sb-clock-out]");
  var beatIn = document.querySelector("[data-sb-beat-in]");
  var beatOut = document.querySelector("[data-sb-beat-out]");

  if (clockIn && clockOut) {
    (function seedClock() {
      var utcMs = Date.now() + new Date().getTimezoneOffset() * 60000;
      var bmt = new Date(utcMs + 3600000);
      clockIn.value =
        pad(bmt.getHours()) +
        ":" +
        pad(bmt.getMinutes()) +
        ":" +
        pad(bmt.getSeconds());
    })();
    function runClock() {
      var p = parseClock(clockIn.value);
      if (!p) {
        clockOut.textContent = "Use HH:MM or HH:MM:SS (BMT / UTC+1)";
        return;
      }
      clockOut.textContent = formatBeat(clockToBeat(p.h, p.m, p.s));
    }
    clockIn.addEventListener("input", runClock);
    runClock();
  }

  if (beatIn && beatOut) {
    function runBeat() {
      var raw = String(beatIn.value).replace(/^@/, "").trim();
      var n = parseFloat(raw);
      var c = beatToClock(n);
      beatOut.textContent = c ? c.label : "Enter a beat 0–999";
    }
    beatIn.addEventListener("input", runBeat);
    runBeat();
  }
})();
